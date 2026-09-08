import datetime
from sqlalchemy import String, Float, Integer, Boolean, DateTime, ForeignKey, Text
from sqlalchemy.orm import Mapped, mapped_column, relationship
from app.db.session import Base

class ServiceRequest(Base):
    __tablename__ = "service_requests"

    id: Mapped[str] = mapped_column(String, primary_key=True, index=True) # e.g. REQ-901
    customer_id: Mapped[str | None] = mapped_column(String, ForeignKey("users.id"), nullable=True)
    customer_name: Mapped[str] = mapped_column(String, nullable=False)
    customer_phone: Mapped[str] = mapped_column(String, nullable=False)
    customer_avatar: Mapped[str] = mapped_column(String, default="")
    customer_address: Mapped[str] = mapped_column(Text, nullable=False)
    customer_lat: Mapped[float] = mapped_column(Float, nullable=False)
    customer_lng: Mapped[float] = mapped_column(Float, nullable=False)
    vehicle_model: Mapped[str] = mapped_column(String, nullable=False)
    vehicle_plate: Mapped[str] = mapped_column(String, nullable=False)
    is_ev: Mapped[bool] = mapped_column(Boolean, default=False)
    role_type: Mapped[str] = mapped_column(String, nullable=False) # e.g. 'evSupport', 'mechanic', 'petrolSupply'
    title: Mapped[str] = mapped_column(String, nullable=False)
    description: Mapped[str] = mapped_column(Text, nullable=False)
    issue_image: Mapped[str | None] = mapped_column(String, nullable=True)
    distance_km: Mapped[float] = mapped_column(Float, default=2.5)
    eta_minutes: Mapped[int] = mapped_column(Integer, default=10)
    base_fare: Mapped[float] = mapped_column(Float, default=40.0)
    parts_cost: Mapped[float] = mapped_column(Float, default=0.0)
    labor_cost: Mapped[float] = mapped_column(Float, default=15.0)
    tax_amount: Mapped[float] = mapped_column(Float, default=8.0)
    tip_amount: Mapped[float] = mapped_column(Float, default=0.0)
    payment_method: Mapped[str] = mapped_column(String, default="Online UPI")
    status: Mapped[str] = mapped_column(String, default="pending") # pending, accepted, onTheWay, arrived, inProgress, completed, paid, cancelled
    assigned_employee_id: Mapped[str | None] = mapped_column(String, ForeignKey("employees.id"), nullable=True)
    user_rating: Mapped[float | None] = mapped_column(Float, nullable=True)
    user_review: Mapped[str | None] = mapped_column(Text, nullable=True)
    created_at: Mapped[datetime.datetime] = mapped_column(DateTime, default=datetime.datetime.utcnow)

    checklist: Mapped[list["ChecklistItem"]] = relationship("ChecklistItem", back_populates="service_request", cascade="all, delete-orphan")
    chat_messages: Mapped[list["ChatMessage"]] = relationship("ChatMessage", back_populates="service_request", cascade="all, delete-orphan")

class ChecklistItem(Base):
    __tablename__ = "checklist_items"

    id: Mapped[str] = mapped_column(String, primary_key=True, index=True)
    request_id: Mapped[str] = mapped_column(String, ForeignKey("service_requests.id"), nullable=False)
    title: Mapped[str] = mapped_column(String, nullable=False)
    is_completed: Mapped[bool] = mapped_column(Boolean, default=False)

    service_request: Mapped["ServiceRequest"] = relationship("ServiceRequest", back_populates="checklist")

class ChatMessage(Base):
    __tablename__ = "chat_messages"

    id: Mapped[str] = mapped_column(String, primary_key=True, index=True)
    request_id: Mapped[str] = mapped_column(String, ForeignKey("service_requests.id"), nullable=False)
    sender_name: Mapped[str] = mapped_column(String, nullable=False)
    sender_type: Mapped[str] = mapped_column(String, nullable=False) # 'user' or 'employee'
    message: Mapped[str] = mapped_column(Text, nullable=False)
    timestamp: Mapped[datetime.datetime] = mapped_column(DateTime, default=datetime.datetime.utcnow)

    service_request: Mapped["ServiceRequest"] = relationship("ServiceRequest", back_populates="chat_messages")
