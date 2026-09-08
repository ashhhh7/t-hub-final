import random
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from app.api.deps import get_db, get_current_token_payload
from app.core.security import get_password_hash, verify_password, create_access_token
from app.models.user import User
from app.models.employee import Employee
from app.schemas.auth import UserRegister, EmployeeRegister, LoginRequest, TokenResponse
from app.schemas.user import UserResponse
from app.schemas.employee import EmployeeResponse

router = APIRouter()

@router.post("/register/user", response_model=TokenResponse)
def register_user(req: UserRegister, db: Session = Depends(get_db)):
    existing = db.query(User).filter((User.email == req.email) | (User.phone == req.phone)).first()
    if existing:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="Mobile number or Email already registered")
    
    user_id = f"USR-{random.randint(1000, 9999)}"
    new_user = User(
        id=user_id,
        full_name=req.full_name,
        email=req.email,
        phone=req.phone,
        hashed_password=get_password_hash(req.password),
        vehicle_model=req.vehicle_model,
        vehicle_plate=req.vehicle_plate,
        avatar_url=req.avatar_url,
    )
    db.add(new_user)
    db.commit()
    db.refresh(new_user)

    token = create_access_token(subject=new_user.id, role="user")
    return TokenResponse(
        access_token=token,
        role="user",
        user_id=new_user.id,
        user_name=new_user.full_name,
        phone=new_user.phone,
        vehicle_model=new_user.vehicle_model,
        vehicle_plate=new_user.vehicle_plate,
    )

@router.post("/register/employee", response_model=TokenResponse)
def register_employee(req: EmployeeRegister, db: Session = Depends(get_db)):
    existing = db.query(Employee).filter((Employee.email == req.email) | (Employee.phone == req.phone)).first()
    if existing:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="Employee with this email or phone already registered")
    
    emp_id = req.employee_id if req.employee_id and len(req.employee_id) > 3 else f"RSQ-EMP-{random.randint(1000, 9999)}"
    new_emp = Employee(
        id=emp_id,
        full_name=req.full_name,
        email=req.email,
        phone=req.phone,
        hashed_password=get_password_hash(req.password),
        vehicle_info=req.vehicle_info,
        license_number=req.license_number,
        avatar_url=req.avatar_url,
    )
    new_emp.assigned_roles = req.assigned_roles
    db.add(new_emp)
    db.commit()
    db.refresh(new_emp)

    token = create_access_token(subject=new_emp.id, role="employee")
    return TokenResponse(
        access_token=token,
        role="employee",
        user_id=new_emp.id,
        user_name=new_emp.full_name,
        phone=new_emp.phone,
        vehicle_model=new_emp.vehicle_info,
    )

@router.post("/login/user", response_model=TokenResponse)
def login_user(req: LoginRequest, db: Session = Depends(get_db)):
    target = (req.identifier or req.phone or req.email or "").strip()
    if not target:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="Please enter mobile number or email")
    
    clean_target = "".join(filter(str.isdigit, target))

    all_users = db.query(User).all()
    user = None
    for u in all_users:
        u_phone_clean = "".join(filter(str.isdigit, u.phone or ""))
        if (
            (u.email and u.email.lower() == target.lower())
            or (clean_target and u_phone_clean and (clean_target in u_phone_clean or u_phone_clean in clean_target))
            or u.phone == target
        ):
            user = u
            break

    if not user or not verify_password(req.password, user.hashed_password):
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Invalid mobile number/email or password")
    
    token = create_access_token(subject=user.id, role="user")
    return TokenResponse(
        access_token=token,
        role="user",
        user_id=user.id,
        user_name=user.full_name,
        phone=user.phone,
        vehicle_model=user.vehicle_model,
        vehicle_plate=user.vehicle_plate,
    )

@router.post("/login/employee", response_model=TokenResponse)
def login_employee(req: LoginRequest, db: Session = Depends(get_db)):
    target = (req.identifier or req.phone or req.email or "").strip()
    if not target:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="Please enter Employee ID, phone, or email")
    
    clean_target = "".join(filter(str.isdigit, target))

    all_emps = db.query(Employee).all()
    emp = None
    for e in all_emps:
        e_phone_clean = "".join(filter(str.isdigit, e.phone or ""))
        if (
            (e.id and e.id.lower() == target.lower())
            or (e.email and e.email.lower() == target.lower())
            or (clean_target and e_phone_clean and (clean_target in e_phone_clean or e_phone_clean in clean_target))
            or e.phone == target
        ):
            emp = e
            break

    if not emp or not verify_password(req.password, emp.hashed_password):
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Invalid Employee ID/phone/email or password")
    
    token = create_access_token(subject=emp.id, role="employee")
    return TokenResponse(
        access_token=token,
        role="employee",
        user_id=emp.id,
        user_name=emp.full_name,
        phone=emp.phone,
        vehicle_model=emp.vehicle_info,
    )

@router.get("/me")
def get_current_profile(payload: dict = Depends(get_current_token_payload), db: Session = Depends(get_db)):
    role = payload.get("role")
    sub = payload.get("sub")
    if role == "user":
        user = db.query(User).filter(User.id == sub).first()
        if not user:
            raise HTTPException(status_code=404, detail="User not found")
        return {"role": "user", "profile": UserResponse.model_validate(user)}
    elif role == "employee":
        emp = db.query(Employee).filter(Employee.id == sub).first()
        if not emp:
            raise HTTPException(status_code=404, detail="Employee not found")
        return {"role": "employee", "profile": EmployeeResponse.model_validate(emp)}
    raise HTTPException(status_code=400, detail="Invalid role in token")
