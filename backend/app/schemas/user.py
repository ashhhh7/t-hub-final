import datetime
from pydantic import BaseModel, ConfigDict

class UserResponse(BaseModel):
    id: str
    full_name: str
    email: str
    phone: str
    vehicle_model: str | None = None
    vehicle_plate: str | None = None
    avatar_url: str | None = None
    created_at: datetime.datetime

    model_config = ConfigDict(from_attributes=True)
