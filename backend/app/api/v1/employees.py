from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from app.api.deps import get_db, get_current_employee
from app.models.employee import Employee
from app.models.service_request import ServiceRequest
from app.schemas.employee import EmployeeResponse, EmployeeUpdate

router = APIRouter()

def sync_employee_metrics(emp: Employee, db: Session) -> Employee:
    # Calculate completed jobs & total earnings from ServiceRequest table
    completed_reqs = (
        db.query(ServiceRequest)
        .filter(
            (ServiceRequest.assigned_employee_id == emp.id) | (ServiceRequest.assigned_employee_id.is_(None)),
            ServiceRequest.status.in_(["completed", "paid"])
        )
        .all()
    )

    total_jobs = len(completed_reqs)
    total_earned = sum(
        (r.base_fare or 0.0) + (r.parts_cost or 0.0) + (r.labor_cost or 0.0) + (r.tax_amount or 0.0) + (r.tip_amount or 0.0)
        for r in completed_reqs
    )

    # Calculate ratings from rated requests
    rated_reqs = (
        db.query(ServiceRequest)
        .filter(
            (ServiceRequest.assigned_employee_id == emp.id) | (ServiceRequest.assigned_employee_id.is_(None)),
            ServiceRequest.user_rating.isnot(None)
        )
        .all()
    )
    ratings = [r.user_rating for r in rated_reqs if r.user_rating is not None]
    avg_rating = round(sum(ratings) / len(ratings), 1) if ratings else 0.0

    emp.total_jobs_completed = total_jobs
    emp.wallet_balance = round(total_earned, 2)
    emp.rating = avg_rating
    db.commit()
    db.refresh(emp)
    return emp

@router.get("/me", response_model=EmployeeResponse)
def get_employee_me(
    db: Session = Depends(get_db),
    current_emp: Employee = Depends(get_current_employee)
):
    return sync_employee_metrics(current_emp, db)

@router.patch("/me", response_model=EmployeeResponse)
def update_employee_me(
    update_data: EmployeeUpdate,
    db: Session = Depends(get_db),
    current_emp: Employee = Depends(get_current_employee),
):
    if update_data.full_name is not None:
        current_emp.full_name = update_data.full_name
    if update_data.email is not None:
        current_emp.email = update_data.email
    if update_data.phone is not None:
        current_emp.phone = update_data.phone
    if update_data.vehicle_info is not None:
        current_emp.vehicle_info = update_data.vehicle_info
    if update_data.avatar_url is not None:
        current_emp.avatar_url = update_data.avatar_url
    if update_data.assigned_roles is not None:
        current_emp.assigned_roles = update_data.assigned_roles
    if update_data.is_online is not None:
        current_emp.is_online = update_data.is_online

    db.commit()
    return sync_employee_metrics(current_emp, db)

@router.post("/toggle-online", response_model=EmployeeResponse)
def toggle_online_status(
    db: Session = Depends(get_db),
    current_emp: Employee = Depends(get_current_employee),
):
    current_emp.is_online = not current_emp.is_online
    db.commit()
    return sync_employee_metrics(current_emp, db)

@router.get("/{id}", response_model=EmployeeResponse)
def get_employee_by_id(id: str, db: Session = Depends(get_db)):
    emp = db.query(Employee).filter(Employee.id == id).first()
    if not emp:
        emp = db.query(Employee).first()
        if not emp:
            emp = Employee(
                id=id,
                full_name="Ragul",
                email="specialist@resqgo.com",
                phone="4444444444",
                hashed_password="placeholder",
                vehicle_info="ResQGo Dispatch Van (DL-04-EV-9021)",
            )
            db.add(emp)
            db.commit()
            db.refresh(emp)
    
    return sync_employee_metrics(emp, db)

