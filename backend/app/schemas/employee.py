import datetime
from pydantic import BaseModel, ConfigDict

class EmployeeUpdate(BaseModel):
    full_name: str | None = None
    email: str | None = None
    phone: str | None = None
    vehicle_info: str | None = None
    avatar_url: str | None = None
    assigned_roles: list[str] | None = None
    is_online: bool | None = None

class EmployeeResponse(BaseModel):
    id: str
    full_name: str
    email: str
    phone: str
    avatar_url: str | None = None
    assigned_roles: list[str]
    rating: float
    total_jobs_completed: int
    wallet_balance: float
    is_online: bool
    vehicle_info: str
    license_number: str
    created_at: datetime.datetime

    model_config = ConfigDict(from_attributes=True)
