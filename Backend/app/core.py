# app/core/database.py
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker, declarative_base

DATABASE_URL = "sqlite:///./vanbora.db"  # Trocar para PostgreSQL depois
engine = create_engine(DATABASE_URL, connect_args={"check_same_thread": False})
SessionLocal = sessionmaker(bind=engine, autocommit=False, autoflush=False)
Base = declarative_base()

def create_db():
    from app.models import usuario, viagem, van  # importa para registrar models
    Base.metadata.create_all(bind=engine)

