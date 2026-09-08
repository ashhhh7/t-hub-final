import datetime
from sqlalchemy import String, Float, DateTime, ForeignKey
from sqlalchemy.orm import Mapped, mapped_column
from app.db.session import Base

class Transaction(Base):
    __tablename__ = "transactions"

    id: Mapped[str] = mapped_column(String, primary_key=True, index=True)
    employee_id: Mapped[str] = mapped_column(String, ForeignKey("employees.id"), nullable=False)
    title: Mapped[str] = mapped_column(String, nullable=False)
    subtitle: Mapped[str] = mapped_column(String, nullable=False)
    amount: Mapped[float] = mapped_column(Float, nullable=False)
    type: Mapped[str] = mapped_column(String, nullable=False) # 'credit', 'debit', 'payout'
    date: Mapped[datetime.datetime] = mapped_column(DateTime, default=datetime.datetime.utcnow)
    request_id: Mapped[str | None] = mapped_column(String, nullable=True)
    status: Mapped[str] = mapped_column(String, default="Completed")
    method: Mapped[str] = mapped_column(String, default="UPI / Bank Transfer")
