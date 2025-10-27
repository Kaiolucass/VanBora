# backend/app/routers/login.py

from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from core.database import get_db
from models.models import Passageiro, Motorista

router = APIRouter(prefix="/login", tags=["Login"])

@router.post("/")
def login(email: str, senha: str, db: Session = Depends(get_db)):
    passageiro = db.query(Passageiro).filter_by(email=email, senha=senha).first()
    if passageiro:
        return {"tipo": "passageiro", "id": passageiro.id, "nome": passageiro.nome}

    motorista = db.query(Motorista).filter_by(email=email, senha=senha).first()
    if motorista:
        return {"tipo": "motorista", "id": motorista.id, "nome": motorista.nome}

    raise HTTPException(status_code=401, detail="Credenciais inválidas")
