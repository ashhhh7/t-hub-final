import datetime
from pydantic import BaseModel, ConfigDict

class InvoiceItemSchema(BaseModel):
    id: str
    description: str
    quantity: int
    unit_price: float

    model_config = ConfigDict(from_attributes=True)

class InvoiceResponse(BaseModel):
    id: str
    invoice_number: str
    request_id: str | None = None
    issued_date: datetime.datetime
    due_date: datetime.datetime
    customer_name: str
    customer_phone: str
    customer_address: str
    employee_name: str
    employee_id: str
    vehicle_details: str
    service_category: str
    discount: float
    tax_rate: float
    payment_mode: str
    payment_status: str
    grand_total: float
    items: list[InvoiceItemSchema] = []

    model_config = ConfigDict(from_attributes=True)
