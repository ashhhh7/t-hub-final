import datetime
import json
from sqlalchemy import String, Float, Integer, Boolean, DateTime, Text
from sqlalchemy.orm import Mapped, mapped_column
from app.db.session import Base

class Employee(Base):
    __tablename__ = "employees"

    id: Mapped[str] = mapped_column(String, primary_key=True, index=True) # e.g. RSQ-EMP-7842
    full_name: Mapped[str] = mapped_column(String, nullable=False)
    email: Mapped[str] = mapped_column(String, unique=True, index=True, nullable=False)
    phone: Mapped[str] = mapped_column(String, nullable=False)
    hashed_password: Mapped[str] = mapped_column(String, nullable=False)
    avatar_url: Mapped[str | None] = mapped_column(String, nullable=True)
    assigned_roles_json: Mapped[str] = mapped_column(Text, default="[]")  # JSON string of role types
    rating: Mapped[float] = mapped_column(Float, default=0.0)
    total_jobs_completed: Mapped[int] = mapped_column(Integer, default=0)
    wallet_balance: Mapped[float] = mapped_column(Float, default=0.0)
    is_online: Mapped[bool] = mapped_column(Boolean, default=True)
    vehicle_info: Mapped[str] = mapped_column(String, default="ResQGo Support Van")
    license_number: Mapped[str] = mapped_column(String, default="DL98202319842")
    created_at: Mapped[datetime.datetime] = mapped_column(DateTime, default=datetime.datetime.utcnow)

    @property
    def assigned_roles(self) -> list[str]:
        try:
            return json.loads(self.assigned_roles_json)
        except Exception:
            return []

    @assigned_roles.setter
    def assigned_roles(self, roles: list[str]):
        self.assigned_roles_json = json.dumps(roles)
