import datetime
from sqlalchemy import String, Float, Integer, DateTime, ForeignKey
from sqlalchemy.orm import Mapped, mapped_column, relationship
from app.db.session import Base

class Invoice(Base):
    __tablename__ = "invoices"

    id: Mapped[str] = mapped_column(String, primary_key=True, index=True)
    invoice_number: Mapped[str] = mapped_column(String, unique=True, index=True, nullable=False)
    request_id: Mapped[str | None] = mapped_column(String, ForeignKey("service_requests.id"), nullable=True)
    issued_date: Mapped[datetime.datetime] = mapped_column(DateTime, default=datetime.datetime.utcnow)
    due_date: Mapped[datetime.datetime] = mapped_column(DateTime, default=datetime.datetime.utcnow)
    customer_name: Mapped[str] = mapped_column(String, nullable=False)
    customer_phone: Mapped[str] = mapped_column(String, nullable=False)
    customer_address: Mapped[str] = mapped_column(String, nullable=False)
    employee_name: Mapped[str] = mapped_column(String, nullable=False)
    employee_id: Mapped[str] = mapped_column(String, nullable=False)
    vehicle_details: Mapped[str] = mapped_column(String, nullable=False)
    service_category: Mapped[str] = mapped_column(String, nullable=False)
    discount: Mapped[float] = mapped_column(Float, default=0.0)
    tax_rate: Mapped[float] = mapped_column(Float, default=0.18)
    payment_mode: Mapped[str] = mapped_column(String, default="UPI Direct")
    payment_status: Mapped[str] = mapped_column(String, default="PAID")
    grand_total: Mapped[float] = mapped_column(Float, default=0.0)

    items: Mapped[list["InvoiceItem"]] = relationship("InvoiceItem", back_populates="invoice", cascade="all, delete-orphan")

class InvoiceItem(Base):
    __tablename__ = "invoice_items"

    id: Mapped[str] = mapped_column(String, primary_key=True, index=True)
    invoice_id: Mapped[str] = mapped_column(String, ForeignKey("invoices.id"), nullable=False)
    description: Mapped[str] = mapped_column(String, nullable=False)
    quantity: Mapped[int] = mapped_column(Integer, default=1)
    unit_price: Mapped[float] = mapped_column(Float, nullable=False)

    invoice: Mapped["Invoice"] = relationship("Invoice", back_populates="items")
