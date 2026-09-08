import datetime
from pydantic import BaseModel, ConfigDict

class ChecklistItemSchema(BaseModel):
    id: str
    title: str
    is_completed: bool = False

    model_config = ConfigDict(from_attributes=True)

class ChatMessageSchema(BaseModel):
    id: str
    sender_name: str
    sender_type: str  # "user" or "employee"
    message: str
    timestamp: datetime.datetime

    model_config = ConfigDict(from_attributes=True)

class ChatMessageCreate(BaseModel):
    sender_name: str
    sender_type: str  # "user" or "employee"
    message: str

class ServiceRequestCreate(BaseModel):
    customer_name: str
    customer_phone: str
    customer_avatar: str | None = "https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150"
    customer_address: str
    customer_lat: float
    customer_lng: float
    vehicle_model: str
    vehicle_plate: str
    is_ev: bool = False
    role_type: str  # e.g. evSupport, mechanic, petrolSupply, towing, batteryInstallation
    title: str
    description: str
    issue_image: str | None = None
    distance_km: float = 2.5
    eta_minutes: int = 10
    base_fare: float = 40.0
    parts_cost: float = 0.0
    labor_cost: float = 15.0
    tax_amount: float = 8.0
    payment_method: str = "Online UPI"

class StatusUpdateSchema(BaseModel):
    status: str

class RatingSubmitSchema(BaseModel):
    rating: float
    review: str | None = None

class ServiceRequestResponse(BaseModel):
    id: str
    customer_id: str | None = None
    customer_name: str
    customer_phone: str
    customer_avatar: str
    customer_address: str
    customer_lat: float
    customer_lng: float
    vehicle_model: str
    vehicle_plate: str
    is_ev: bool
    role_type: str
    title: str
    description: str
    issue_image: str | None = None
    distance_km: float
    eta_minutes: int
    base_fare: float
    parts_cost: float
    labor_cost: float
    tax_amount: float
    tip_amount: float
    payment_method: str
    status: str
    assigned_employee_id: str | None = None
    assigned_employee_name: str | None = None
    assigned_employee_phone: str | None = None
    assigned_employee_vehicle: str | None = None
    assigned_employee_rating: float | None = None
    user_rating: float | None = None
    user_review: str | None = None
    created_at: datetime.datetime
    checklist: list[ChecklistItemSchema] = []
    chat_messages: list[ChatMessageSchema] = []

    model_config = ConfigDict(from_attributes=True)
