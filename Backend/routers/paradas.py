#backend/routers/paradas.py

from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from core.database import get_db
from models.models import Parada
from schemas.paradas_schema import ParadaCreate, ParadaResponse
from typing import List

router = APIRouter(prefix="/paradas", tags=["Paradas"])

@router.post("/", response_model=ParadaResponse)
def criar_parada(parada: ParadaCreate, db: Session = Depends(get_db)):
    nova_parada = Parada(**parada.dict())
    db.add(nova_parada)
    db.commit()
    db.refresh(nova_parada)
    return nova_parada

@router.get("/", response_model=List[ParadaResponse])
def listar_paradas(db: Session = Depends(get_db)):
    return db.query(Parada).all()
