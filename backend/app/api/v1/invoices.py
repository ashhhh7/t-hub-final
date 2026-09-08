import random
import datetime
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from app.api.deps import get_db, get_current_employee
from app.models.invoice import Invoice, InvoiceItem
from app.models.service_request import ServiceRequest
from app.models.employee import Employee
from app.models.transaction import Transaction
from app.schemas.invoice import InvoiceResponse

router = APIRouter()

@router.get("/", response_model=list[InvoiceResponse])
def get_all_invoices(db: Session = Depends(get_db)):
    invoices = db.query(Invoice).order_by(Invoice.issued_date.desc()).all()
    return invoices

@router.get("/{id}", response_model=InvoiceResponse)
def get_invoice_by_id(id: str, db: Session = Depends(get_db)):
    inv = db.query(Invoice).filter((Invoice.id == id) | (Invoice.invoice_number == id)).first()
    if not inv:
        raise HTTPException(status_code=404, detail="Invoice not found")
    return inv

@router.post("/generate/{request_id}", response_model=InvoiceResponse, status_code=status.HTTP_201_CREATED)
def generate_invoice_for_request(
    request_id: str,
    payment_method: str = "Online UPI",
    tip_amount: float = 0.0,
    db: Session = Depends(get_db),
):
    req = db.query(ServiceRequest).filter(ServiceRequest.id == request_id).first()
    if not req:
        raise HTTPException(status_code=404, detail="Service request not found")

    emp = None
    if req.assigned_employee_id:
        emp = db.query(Employee).filter(Employee.id == req.assigned_employee_id).first()
    if not emp:
        emp = db.query(Employee).first()

    emp_name = emp.full_name if emp else "Specialist Technician"
    emp_id = emp.id if emp else "RSQ-EMP-7842"

    req.status = "paid"
    req.tip_amount = tip_amount
    req.payment_method = payment_method

    inv_id = f"INV-{req.id.replace('REQ-', '')}-{random.randint(1000, 9999)}"
    inv_number = f"INV-2026-{random.randint(10000, 99999)}"
    
    subtotal = req.base_fare + req.labor_cost + req.parts_cost + tip_amount
    tax_rate = 0.18
    tax_amt = subtotal * tax_rate
    grand_total = subtotal + tax_amt

    new_invoice = Invoice(
        id=inv_id,
        invoice_number=inv_number,
        request_id=req.id,
        issued_date=datetime.datetime.utcnow(),
        due_date=datetime.datetime.utcnow(),
        customer_name=req.customer_name,
        customer_phone=req.customer_phone,
        customer_address=req.customer_address,
        employee_name=emp_name,
        employee_id=emp_id,
        vehicle_details=f"{req.vehicle_model} ({req.vehicle_plate})",
        service_category=req.role_type,
        discount=0.0,
        tax_rate=tax_rate,
        payment_mode=payment_method,
        payment_status="PAID",
        grand_total=grand_total,
    )
    db.add(new_invoice)
    db.flush()

    # Add items
    item1 = InvoiceItem(
        id=f"item_{inv_id}_1",
        invoice_id=inv_id,
        description=f"{req.role_type} Base Callout & Labor",
        quantity=1,
        unit_price=req.base_fare + req.labor_cost,
    )
    db.add(item1)

    if req.parts_cost > 0:
        item2 = InvoiceItem(
            id=f"item_{inv_id}_2",
            invoice_id=inv_id,
            description="Parts & Consumables / Emergency Fuel",
            quantity=1,
            unit_price=req.parts_cost,
        )
        db.add(item2)

    if tip_amount > 0:
        item3 = InvoiceItem(
            id=f"item_{inv_id}_3",
            invoice_id=inv_id,
            description="Special Service Gratitude / Tip",
            quantity=1,
            unit_price=tip_amount,
        )
        db.add(item3)

    # Update Employee Wallet & Jobs count
    earned_payout = req.base_fare + req.labor_cost + req.parts_cost + tip_amount + req.tax_amount
    if emp:
        emp.wallet_balance += earned_payout
        emp.total_jobs_completed += 1

    # Record Credit Transaction
    txn_id = f"TXN-{random.randint(100000, 999999)}"
    new_txn = Transaction(
        id=txn_id,
        employee_id=emp_id,
        title=f"Payout: {req.role_type}",
        subtitle=f"Customer: {req.customer_name} ({req.vehicle_model})",
        amount=earned_payout,
        type="credit",
        date=datetime.datetime.utcnow(),
        request_id=req.id,
        status="Completed",
        method=payment_method,
    )
    db.add(new_txn)

    db.commit()
    db.refresh(new_invoice)
    return new_invoice
