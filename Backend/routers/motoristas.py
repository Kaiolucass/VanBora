# backend/app/routers/motoristas.py
from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from core.database import get_db
from models.models import Motorista
from schemas.motoristas_schema import MotoristaCreate, MotoristaResponse
from typing import List  

router = APIRouter(prefix="/motoristas", tags=["Motoristas"])

@router.post("/", response_model=MotoristaResponse)
def criar_motorista(motorista: MotoristaCreate, db: Session = Depends(get_db)):
    novo_motorista = Motorista(
        nome=motorista.nome,
        email=motorista.email,
        telefone=motorista.telefone,
        senha=motorista.senha  # Em produção: usar hash
    )
    db.add(novo_motorista)
    db.commit()
    db.refresh(novo_motorista)
    return novo_motorista

@router.get("/", response_model=List[MotoristaResponse])
def listar_motoristas(db: Session = Depends(get_db)):
    return db.query(Motorista).all()
