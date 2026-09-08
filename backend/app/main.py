from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.core.config import settings
from app.db.base import Base
from app.db.session import engine

# Import Routers
from app.api.v1 import auth, users, employees, requests, invoices, wallet

from sqlalchemy import text

# Auto-create tables & migrate schema on launch (for Railway / PostgreSQL / SQLite dev setup)
try:
    Base.metadata.create_all(bind=engine)
    with engine.begin() as conn:
        try:
            conn.execute(text("ALTER TABLE service_requests ADD COLUMN IF NOT EXISTS user_rating FLOAT;"))
        except Exception as e:
            print(f"[MIGRATION WARN] user_rating: {e}")
        try:
            conn.execute(text("ALTER TABLE service_requests ADD COLUMN IF NOT EXISTS user_review TEXT;"))
        except Exception as e:
            print(f"[MIGRATION WARN] user_review: {e}")
except Exception as e:
    print(f"[WARN] Table creation check skipped: {e}")


app = FastAPI(
    title=settings.PROJECT_NAME,
    description="ResQGo 24/7 Roadside & EV Emergency Assistance Backend REST API",
    version="1.0.0",
    docs_url="/docs",
    redoc_url="/redoc",
)

# Enable CORS for Flutter Web / Mobile apps
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Include v1 Router Endpoints
app.include_router(auth.router, prefix=f"{settings.API_V1_STR}/auth", tags=["Auth"])
app.include_router(users.router, prefix=f"{settings.API_V1_STR}/users", tags=["Users"])
app.include_router(employees.router, prefix=f"{settings.API_V1_STR}/employees", tags=["Employees"])
app.include_router(requests.router, prefix=f"{settings.API_V1_STR}/requests", tags=["Service Requests"])
app.include_router(invoices.router, prefix=f"{settings.API_V1_STR}/invoices", tags=["Invoices"])
app.include_router(wallet.router, prefix=f"{settings.API_V1_STR}/wallet", tags=["Wallet & Payouts"])

@app.get("/")
def root():
    return {
        "status": "online",
        "service": settings.PROJECT_NAME,
        "docs": "/docs",
        "version": "1.0.0",
    }
