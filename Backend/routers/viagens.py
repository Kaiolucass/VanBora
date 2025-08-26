# backend/app/routers/viagens.py

from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from core.database import SessionLocal
from models.models import Viagem
from schemas.viagens_schema import ViagemCreate, ViagemResponse
from typing import List

router = APIRouter(prefix="/viagens", tags=["Viagens"])

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@router.post("/", response_model=ViagemResponse)
def criar_viagem(viagem: ViagemCreate, db: Session = Depends(get_db)):
    nova_viagem = Viagem(**viagem.dict())
    db.add(nova_viagem)
    db.commit()
    db.refresh(nova_viagem)
    return nova_viagem

@router.get("/", response_model=List[ViagemResponse])
def listar_viagens(db: Session = Depends(get_db)):
    return db.query(Viagem).all()

@router.get("/passageiro/{id}", response_model=List[ViagemResponse])
def listar_viagens_passageiro(id: int, db: Session = Depends(get_db)):
    viagens = db.query(Viagem).filter(Viagem.passageiro_id == id).all()
    return viagens

@router.get("/motorista/{id}", response_model=List[ViagemResponse])
def listar_viagens_motorista(id: int, db: Session = Depends(get_db)):
    viagens = db.query(Viagem).filter(Viagem.motorista_id == id).all()
    return viagens