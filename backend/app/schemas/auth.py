from pydantic import BaseModel, EmailStr

class UserRegister(BaseModel):
    full_name: str
    email: str
    phone: str
    password: str
    vehicle_model: str | None = None
    vehicle_plate: str | None = None
    avatar_url: str | None = None

class EmployeeRegister(BaseModel):
    full_name: str
    email: str
    phone: str
    password: str
    employee_id: str | None = None
    assigned_roles: list[str] = ["mechanic", "evSupport"]
    vehicle_info: str = "ResQGo Support Van"
    license_number: str = "DL98202319842"
    avatar_url: str | None = None

class LoginRequest(BaseModel):
    identifier: str | None = None
    email: str | None = None
    phone: str | None = None
    password: str

class TokenResponse(BaseModel):
    access_token: str
    token_type: str = "bearer"
    role: str
    user_id: str
    user_name: str | None = None
    phone: str | None = None
    vehicle_model: str | None = None
    vehicle_plate: str | None = None

