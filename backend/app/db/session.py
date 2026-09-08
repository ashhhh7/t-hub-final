from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker, DeclarativeBase
from app.core.config import settings

db_url = settings.normalized_database_url

try:
    connect_args = {}
    if db_url.startswith("sqlite"):
        connect_args = {"check_same_thread": False}

    test_engine = create_engine(
        db_url,
        connect_args=connect_args,
        pool_pre_ping=True,
    )
    with test_engine.connect() as conn:
        pass
    engine = test_engine
    print(f"[INFO] Successfully connected to Database: {db_url}")
except Exception as e:
    print(f"[WARN] Failed to connect to Primary Database ({db_url}): {e}")
    print("[WARN] Falling back to local SQLite database (sqlite:///./resqgo.db)...")
    db_url = "sqlite:///./resqgo.db"
    engine = create_engine(
        db_url,
        connect_args={"check_same_thread": False},
        pool_pre_ping=True,
    )

SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

class Base(DeclarativeBase):
    pass

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

