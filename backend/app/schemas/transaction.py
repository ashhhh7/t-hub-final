import datetime
from pydantic import BaseModel, ConfigDict

class WithdrawalRequest(BaseModel):
    amount: float
    destination: str

class TransactionResponse(BaseModel):
    id: str
    employee_id: str
    title: str
    subtitle: str
    amount: float
    type: str  # credit, debit, payout
    date: datetime.datetime
    request_id: str | None = None
    status: str
    method: str

    model_config = ConfigDict(from_attributes=True)
