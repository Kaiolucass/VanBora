# backend/app/routers/passageiros.py

from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from core.database import SessionLocal
from models.models import Passageiro
from pydantic import BaseModel
from typing import List

router = APIRouter(prefix="/passageiros", tags=["Passageiros"])

class PassageiroCreate(BaseModel):
    nome: str
    email: str
    senha: str
    telefone: str

    class Config:
        orm_mode = True

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@router.post("/", response_model=PassageiroCreate)
def criar_passageiro(passageiro: PassageiroCreate, db: Session = Depends(get_db)):
    novo_passageiro = Passageiro(**passageiro.dict())
    db.add(novo_passageiro)
    db.commit()
    db.refresh(novo_passageiro)
    return novo_passageiro

@router.get("/", response_model=List[PassageiroCreate])
def listar_passageiros(db: Session = Depends(get_db)):
    return db.query(Passageiro).all()

