import math
import random
import datetime
from fastapi import APIRouter, Depends, HTTPException, Query, status
from sqlalchemy.orm import Session
from app.api.deps import get_db, get_current_employee
from app.models.service_request import ServiceRequest, ChecklistItem, ChatMessage
from app.models.employee import Employee
from app.schemas.service_request import (
    ServiceRequestCreate,
    ServiceRequestResponse,
    StatusUpdateSchema,
    RatingSubmitSchema,
    ChatMessageCreate,
)

router = APIRouter()

DEFAULT_CHECKLIST = [
    "Setup Safety Cones & Hazard Warning Lights",
    "Perform Diagnostic Inspection of Issue",
    "Execute Authorized Repair / Fuel / EV Charge",
    "Verify Vehicle Start & Safe Driveability",
    "Obtain Customer Digital Signature / Confirmation",
]

def calculate_haversine(lat1: float, lon1: float, lat2: float, lon2: float) -> float:
    p = 0.017453292519943295  # math.pi / 180
    a = 0.5 - math.cos((lat2 - lat1) * p) / 2 + math.cos(lat1 * p) * math.cos(lat2 * p) * (1 - math.cos((lon2 - lon1) * p)) / 2
    return 12742 * math.asin(math.sqrt(a))

def populate_emp_info(req: ServiceRequest, db: Session) -> ServiceRequestResponse:
    resp = ServiceRequestResponse.model_validate(req)
    if req.assigned_employee_id:
        emp = db.query(Employee).filter(Employee.id == req.assigned_employee_id).first()
        if not emp:
            emp = db.query(Employee).first()
        if emp:
            resp.assigned_employee_name = emp.full_name
            resp.assigned_employee_phone = emp.phone
            resp.assigned_employee_vehicle = emp.vehicle_info
            resp.assigned_employee_rating = emp.rating
    return resp

@router.get("/nearby", response_model=list[ServiceRequestResponse])
def get_nearby_requests(
    max_distance_km: float = Query(5000.0, description="Max search radius in km"),
    lat: float | None = Query(None, description="Employee Latitude"),
    lng: float | None = Query(None, description="Employee Longitude"),
    db: Session = Depends(get_db),
):
    pending_reqs = (
        db.query(ServiceRequest)
        .filter(ServiceRequest.status == "pending")
        .order_by(ServiceRequest.created_at.desc())
        .all()
    )
    if lat is not None and lng is not None:
        for req in pending_reqs:
            dist = calculate_haversine(lat, lng, req.customer_lat, req.customer_lng)
            req.distance_km = round(dist, 1)
            req.eta_minutes = max(3, min(90, round((dist / 30.0) * 60 + 3)))
    
    return [populate_emp_info(r, db) for r in pending_reqs]

@router.post("/", response_model=ServiceRequestResponse, status_code=status.HTTP_201_CREATED)
def create_service_request(
    req_data: ServiceRequestCreate,
    db: Session = Depends(get_db),
):
    req_id = f"REQ-{random.randint(900, 999)}"
    
    dist_km = 1.8
    eta_mins = 10

    new_req = ServiceRequest(
        id=req_id,
        customer_name=req_data.customer_name,
        customer_phone=req_data.customer_phone,
        customer_avatar=req_data.customer_avatar or "https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150",
        customer_address=req_data.customer_address,
        customer_lat=req_data.customer_lat,
        customer_lng=req_data.customer_lng,
        vehicle_model=req_data.vehicle_model,
        vehicle_plate=req_data.vehicle_plate,
        is_ev=req_data.is_ev,
        role_type=req_data.role_type,
        title=req_data.title,
        description=req_data.description,
        issue_image=req_data.issue_image,
        distance_km=dist_km,
        eta_minutes=eta_mins,
        base_fare=req_data.base_fare,
        parts_cost=req_data.parts_cost,
        labor_cost=req_data.labor_cost,
        tax_amount=req_data.tax_amount,
        payment_method=req_data.payment_method,
        status="pending",
    )

    db.add(new_req)
    db.flush()

    for idx, item_title in enumerate(DEFAULT_CHECKLIST, start=1):
        item = ChecklistItem(
            id=f"c_{req_id}_{idx}",
            request_id=req_id,
            title=item_title,
            is_completed=False,
        )
        db.add(item)

    db.commit()
    db.refresh(new_req)
    return populate_emp_info(new_req, db)

@router.get("/user/latest", response_model=ServiceRequestResponse | None)
def get_latest_user_request(
    phone: str | None = Query(None, description="Customer Phone Number"),
    db: Session = Depends(get_db),
):
    if not phone or not phone.strip():
        return None
    
    clean_target = "".join(filter(str.isdigit, phone))
    active_statuses = ["pending", "accepted", "onTheWay", "arrived", "inProgress"]
    all_reqs = (
        db.query(ServiceRequest)
        .filter(ServiceRequest.status.in_(active_statuses))
        .order_by(ServiceRequest.created_at.desc())
        .all()
    )
    for r in all_reqs:
        r_phone_clean = "".join(filter(str.isdigit, r.customer_phone or ""))
        if clean_target and r_phone_clean and (clean_target in r_phone_clean or r_phone_clean in clean_target):
            return populate_emp_info(r, db)
        if r.customer_phone == phone:
            return populate_emp_info(r, db)
    
    return None

@router.get("/active", response_model=ServiceRequestResponse | None)
@router.get("/employee/active", response_model=ServiceRequestResponse | None)
def get_active_employee_request(
    employee_id: str | None = Query(None, description="Employee ID"),
    db: Session = Depends(get_db),
):
    if not employee_id:
        emp = db.query(Employee).first()
        employee_id = emp.id if emp else "RSQ-EMP-7842"
        
    active_req = (
        db.query(ServiceRequest)
        .filter(ServiceRequest.assigned_employee_id == employee_id)
        .filter(ServiceRequest.status.in_(["accepted", "onTheWay", "arrived", "inProgress"]))
        .first()
    )
    return populate_emp_info(active_req, db) if active_req else None

@router.get("/history", response_model=list[ServiceRequestResponse])
def get_completed_requests(
    db: Session = Depends(get_db),
):
    completed = (
        db.query(ServiceRequest)
        .filter(ServiceRequest.status.in_(["completed", "paid"]))
        .order_by(ServiceRequest.created_at.desc())
        .all()
    )
    return [populate_emp_info(r, db) for r in completed]

@router.get("/{id}", response_model=ServiceRequestResponse)
def get_request_by_id(id: str, db: Session = Depends(get_db)):
    req = db.query(ServiceRequest).filter(ServiceRequest.id == id).first()
    if not req:
        raise HTTPException(status_code=404, detail="Service request not found")
    return populate_emp_info(req, db)

@router.post("/{id}/accept", response_model=ServiceRequestResponse)
def accept_request(
    id: str,
    employee_id: str | None = Query(None, description="Assigned Employee ID"),
    db: Session = Depends(get_db),
):
    req = db.query(ServiceRequest).filter(ServiceRequest.id == id).first()
    if not req:
        raise HTTPException(status_code=404, detail="Service request not found")
    
    req.status = "accepted"
    if employee_id:
        emp = db.query(Employee).filter(Employee.id == employee_id).first()
        if not emp:
            emp = Employee(
                id=employee_id,
                full_name="ResQGo Specialist",
                email=f"{employee_id.lower()}@resqgo.com",
                phone="+91 98765 43210",
                hashed_password="hashed_placeholder",
                vehicle_info="ResQGo Support Van (TN-57-RSQ-909)",
            )
            db.add(emp)
            db.flush()
        req.assigned_employee_id = emp.id
    else:
        emp = db.query(Employee).first()
        req.assigned_employee_id = emp.id if emp else "RSQ-EMP-7842"

    db.commit()
    db.refresh(req)
    return populate_emp_info(req, db)

@router.post("/{id}/reject")
def reject_request(id: str, db: Session = Depends(get_db)):
    req = db.query(ServiceRequest).filter(ServiceRequest.id == id).first()
    if not req:
        raise HTTPException(status_code=404, detail="Service request not found")
    return {"message": "Request rejected", "id": id}

@router.patch("/{id}/status", response_model=ServiceRequestResponse)
@router.post("/{id}/status", response_model=ServiceRequestResponse)
def update_request_status(
    id: str,
    payload: StatusUpdateSchema,
    db: Session = Depends(get_db),
):
    req = db.query(ServiceRequest).filter(ServiceRequest.id == id).first()
    if not req:
        raise HTTPException(status_code=404, detail="Service request not found")
    
    valid_statuses = ["pending", "accepted", "onTheWay", "arrived", "inProgress", "completed", "paid", "cancelled"]
    if payload.status not in valid_statuses:
        raise HTTPException(status_code=400, detail=f"Invalid status. Must be one of {valid_statuses}")
    
    old_status = req.status
    req.status = payload.status
    
    if payload.status in ["completed", "paid"] and old_status not in ["completed", "paid"] and req.assigned_employee_id:
        emp = db.query(Employee).filter(Employee.id == req.assigned_employee_id).first()
        if emp:
            emp.total_jobs_completed += 1
            earned = req.base_fare + req.parts_cost + req.labor_cost + req.tax_amount + req.tip_amount
            emp.wallet_balance += earned

    db.commit()
    db.refresh(req)
    return populate_emp_info(req, db)

@router.post("/{id}/rate", response_model=ServiceRequestResponse)
def rate_service_request(
    id: str,
    payload: RatingSubmitSchema,
    db: Session = Depends(get_db),
):
    req = db.query(ServiceRequest).filter(ServiceRequest.id == id).first()
    if not req:
        raise HTTPException(status_code=404, detail="Service request not found")
    
    req.user_rating = payload.rating
    if payload.review:
        req.user_review = payload.review
    
    if req.assigned_employee_id:
        emp = db.query(Employee).filter(Employee.id == req.assigned_employee_id).first()
        if emp:
            rated_reqs = (
                db.query(ServiceRequest)
                .filter(ServiceRequest.assigned_employee_id == emp.id)
                .filter(ServiceRequest.user_rating.isnot(None))
                .all()
            )
            ratings = [r.user_rating for r in rated_reqs if r.user_rating is not None]
            if ratings:
                emp.rating = round(sum(ratings) / len(ratings), 1)
            else:
                emp.rating = 0.0

    db.commit()
    db.refresh(req)
    return populate_emp_info(req, db)

@router.patch("/{id}/checklist/{item_id}", response_model=ServiceRequestResponse)
def toggle_checklist_item(
    id: str,
    item_id: str,
    db: Session = Depends(get_db),
):
    req = db.query(ServiceRequest).filter(ServiceRequest.id == id).first()
    if not req:
        raise HTTPException(status_code=404, detail="Service request not found")
    
    item = db.query(ChecklistItem).filter(ChecklistItem.id == item_id, ChecklistItem.request_id == id).first()
    if not item:
        raise HTTPException(status_code=404, detail="Checklist item not found")
    
    item.is_completed = not item.is_completed
    db.commit()
    db.refresh(req)
    return populate_emp_info(req, db)

@router.post("/{id}/chat", response_model=ServiceRequestResponse)
def send_chat_message(
    id: str,
    payload: ChatMessageCreate,
    db: Session = Depends(get_db),
):
    req = db.query(ServiceRequest).filter(ServiceRequest.id == id).first()
    if not req:
        raise HTTPException(status_code=404, detail="Service request not found")
    
    msg_id = f"msg_{int(datetime.datetime.utcnow().timestamp() * 1000)}"
    msg = ChatMessage(
        id=msg_id,
        request_id=id,
        sender_name=payload.sender_name,
        sender_type=payload.sender_type,
        message=payload.message,
    )
    db.add(msg)
    db.commit()
    db.refresh(req)
    return populate_emp_info(req, db)
