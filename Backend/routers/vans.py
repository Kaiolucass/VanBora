# backend/app/routers/vans.py

from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from core.database import SessionLocal
from models.models import Van
from schemas.vans_schema import VanCreate, VanResponse
from typing import List

router = APIRouter(prefix="/vans", tags=["Vans"])

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@router.post("/", response_model=VanResponse)
def criar_van(van: VanCreate, db: Session = Depends(get_db)):
    nova_van = Van(**van.dict())
    db.add(nova_van)
    db.commit()
    db.refresh(nova_van)
    return nova_van

@router.get("/", response_model=List[VanResponse])
def listar_vans(db: Session = Depends(get_db)):
    return db.query(Van).all()
