import random
import datetime
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from app.api.deps import get_db, get_current_employee
from app.models.transaction import Transaction
from app.models.employee import Employee
from app.schemas.transaction import TransactionResponse, WithdrawalRequest

router = APIRouter()

@router.get("/transactions", response_model=list[TransactionResponse])
def get_wallet_transactions(
    db: Session = Depends(get_db),
    current_emp: Employee = Depends(get_current_employee),
):
    txns = (
        db.query(Transaction)
        .filter(Transaction.employee_id == current_emp.id)
        .order_by(Transaction.date.desc())
        .all()
    )
    return txns

@router.post("/withdraw", response_model=TransactionResponse)
def process_wallet_withdrawal(
    req: WithdrawalRequest,
    db: Session = Depends(get_db),
    current_emp: Employee = Depends(get_current_employee),
):
    if req.amount <= 0:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="Withdrawal amount must be greater than zero")
    if req.amount > current_emp.wallet_balance:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="Insufficient wallet balance")

    current_emp.wallet_balance -= req.amount

    txn_id = f"WTH-{random.randint(100000, 999999)}"
    new_txn = Transaction(
        id=txn_id,
        employee_id=current_emp.id,
        title=f"Withdrawal to {req.destination}",
        subtitle="Processed instantly",
        amount=req.amount,
        type="payout",
        date=datetime.datetime.utcnow(),
        status="Completed",
        method=req.destination,
    )
    db.add(new_txn)
    db.commit()
    db.refresh(new_txn)
    return new_txn
