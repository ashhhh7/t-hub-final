from app.db.session import SessionLocal, engine
from sqlalchemy import inspect
from app.models.user import User
from app.models.employee import Employee
from app.models.service_request import ServiceRequest
from app.models.invoice import Invoice
from app.models.transaction import Transaction

def inspect_db():
    insp = inspect(engine)
    tables = insp.get_table_names()
    print("Available tables in database:", tables)

    db = SessionLocal()
    try:
        print("\n" + "="*50)
        print("1. USERS TABLE (`users`)")
        print("="*50)
        users = db.query(User).all()
        print(f"Total count: {len(users)}")
        for u in users:
            print(f" • ID: {u.id}")
            print(f"   Name: {u.full_name}")
            print(f"   Phone: {u.phone}")
            print(f"   Email: {u.email}")
            print(f"   Vehicle: {getattr(u, 'vehicle_model', 'N/A')} ({getattr(u, 'vehicle_plate', 'N/A')})")
            print(f"   Created: {getattr(u, 'created_at', 'N/A')}")
            print("-" * 30)

        print("\n" + "="*50)
        print("2. EMPLOYEES / TECHNICIANS TABLE (`employees`)")
        print("="*50)
        employees = db.query(Employee).all()
        print(f"Total count: {len(employees)}")
        for e in employees:
            print(f" • ID: {e.id}")
            print(f"   Name: {e.full_name}")
            print(f"   Phone: {e.phone}")
            print(f"   Email: {e.email}")
            print(f"   Roles: {e.assigned_roles}")
            print(f"   Rating: {e.rating} (Jobs completed: {e.total_jobs_completed})")
            print(f"   Online Status: {e.is_online}")
            print(f"   Wallet Balance: INR {e.wallet_balance}")
            print(f"   Vehicle Info: {e.vehicle_info}")
            print("-" * 30)

        print("\n" + "="*50)
        print("3. SERVICE REQUESTS TABLE (`service_requests`)")
        print("="*50)
        reqs = db.query(ServiceRequest).all()
        print(f"Total count: {len(reqs)}")
        for r in reqs:
            print(f" * Request ID: {r.id}")
            print(f"   User: {r.user_name} (Phone: {r.user_phone})")
            print(f"   Service Type: {r.service_type} | Vehicle: {r.vehicle_type} ({r.vehicle_model})")
            print(f"   Status: {r.status}")
            print(f"   Assigned Tech: {r.assigned_employee_id}")
            print(f"   Pickup/Location: Lat {r.pickup_lat}, Lng {r.pickup_lng}")
            print(f"   Notes: {r.notes}")
            print(f"   Price Estimate: INR {r.estimated_price}")
            print(f"   Rating: {r.user_rating} | Review: {r.user_review}")
            print(f"   Created: {r.created_at}")
            print("-" * 30)

        print("\n" + "="*50)
        print("4. INVOICES TABLE (`invoices`)")
        print("="*50)
        invoices = db.query(Invoice).all()
        print(f"Total count: {len(invoices)}")
        for inv in invoices:
            print(f" * Invoice ID: {inv.id}")
            print(f"   Request ID: {inv.request_id}")
            print(f"   Base Price: INR {inv.base_price} | Tax: INR {inv.tax} | Tip: INR {inv.tip_amount}")
            print(f"   Total: INR {inv.total_amount}")
            print(f"   Payment Status: {inv.payment_status} | Method: {inv.payment_method}")
            print(f"   Paid At: {inv.paid_at}")
            print("-" * 30)

        print("\n" + "="*50)
        print("5. TRANSACTIONS TABLE (`transactions`)")
        print("="*50)
        txs = db.query(Transaction).all()
        print(f"Total count: {len(txs)}")
        for t in txs:
            print(f" * ID: {t.id}")
            print(f"   Employee ID: {t.employee_id}")
            print(f"   Type: {t.type} | Amount: INR {t.amount}")
            print(f"   Description: {t.description}")
            print(f"   Created At: {t.created_at}")
            print("-" * 30)

    finally:
        db.close()

if __name__ == "__main__":
    inspect_db()
