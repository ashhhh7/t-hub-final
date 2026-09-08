from sqlalchemy import text
from app.db.base import Base
from app.db.session import engine, SessionLocal
from app.core.security import get_password_hash
from app.models.user import User
from app.models.employee import Employee

def seed_database():
    print("[INIT] Resetting Schema & Initializing Database...")
    try:
        with engine.connect() as conn:
            conn.execute(text("DROP SCHEMA public CASCADE; CREATE SCHEMA public;"))
            conn.commit()
    except Exception as e:
        print(f"[WARN] Reset schema warning: {e}")

    Base.metadata.create_all(bind=engine)
    db = SessionLocal()

    try:
        # 1. Create Default Technician Account (Specialist Technician)
        emp = db.query(Employee).filter(Employee.id == "RSQ-EMP-7842").first()
        if not emp:
            emp = Employee(
                id="RSQ-EMP-7842",
                full_name="Specialist Technician",
                email="specialist@resqgo.com",
                phone="+91 98765 43210",
                hashed_password=get_password_hash("password123"),
                rating=4.92,
                total_jobs_completed=0,
                wallet_balance=0.00,
                is_online=True,
                vehicle_info="ResQGo Rapid Support Van (DL-08-EV-2024)",
                license_number="DL-98202319842",
            )
            emp.assigned_roles = ["evSupport", "mechanic", "petrolSupply", "batteryInstallation", "towing"]
            db.add(emp)

        # 2. Create Default Registered Users
        user = db.query(User).filter(User.email == "priya@gmail.com").first()
        if not user:
            user = User(
                id="USR-1001",
                full_name="Priya Sharma",
                email="priya@gmail.com",
                phone="+91 98112 34567",
                hashed_password=get_password_hash("user123"),
            )
            db.add(user)

        user2 = db.query(User).filter((User.phone == "1111111111") | (User.id == "USR-8431")).first()
        if not user2:
            user2 = User(
                id="USR-8431",
                full_name="Niveshh",
                email="1111111111@user.resqgo.com",
                phone="1111111111",
                hashed_password=get_password_hash("123456"),
                vehicle_model="TATA Nexon EV Red Dark",
                vehicle_plate="TN-57-EV-8844",
            )
            db.add(user2)
        else:
            user2.vehicle_model = "TATA Nexon EV Red Dark"
            user2.vehicle_plate = "TN-57-EV-8844"

        db.commit()
        print("[SUCCESS] Database schema clean & ready for real user distress requests!")
    except Exception as e:
        db.rollback()
        print(f"[ERROR] Error initializing database: {e}")
    finally:
        db.close()

if __name__ == "__main__":
    seed_database()
