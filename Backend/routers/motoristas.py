# backend/app/routers/motoristas.py
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from core.database import get_db
from core.auth import hash_password 
from models.models import Motorista
from schemas.motoristas_schema import MotoristaCreate, MotoristaResponse
from typing import List  

router = APIRouter(prefix="/motoristas", tags=["Motoristas"])


@router.post("/", response_model=MotoristaResponse)
def criar_motorista(motorista: MotoristaCreate, db: Session = Depends(get_db)):
    # 🔹 Verifica se o e-mail já está cadastrado
    existente = db.query(Motorista).filter(Motorista.email == motorista.email).first()
    if existente:
        raise HTTPException(status_code=400, detail="E-mail já cadastrado")

    # 🔹 Criptografa a senha antes de salvar
    novo_motorista = Motorista(
        nome=motorista.nome,
        email=motorista.email,
        senha=hash_password(motorista.senha), 
    )

    db.add(novo_motorista)
    db.commit()
    db.refresh(novo_motorista)
    return novo_motorista


@router.get("/", response_model=List[MotoristaResponse])
def listar_motoristas(db: Session = Depends(get_db)):
    return db.query(Motorista).all()
