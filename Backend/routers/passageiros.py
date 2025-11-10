## backend/app/routers/passageiros.py
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from core.database import SessionLocal, get_db
from models.models import Passageiro
from pydantic import BaseModel
from typing import List
from core.auth import hash_password  

router = APIRouter(prefix="/passageiros", tags=["Passageiros"])


class PassageiroCreate(BaseModel):
    nome: str
    email: str
    senha: str
    class Config:
        orm_mode = True


@router.post("/", response_model=PassageiroCreate)
def criar_passageiro(passageiro: PassageiroCreate, db: Session = Depends(get_db)):
    # 🔹 Verifica se já existe um passageiro com o mesmo e-mail
    existente = db.query(Passageiro).filter(Passageiro.email == passageiro.email).first()
    if existente:
        raise HTTPException(status_code=400, detail="E-mail já cadastrado")

    # 🔹 Criptografa a senha antes de salvar
    novo_passageiro = Passageiro(
        nome=passageiro.nome,
        email=passageiro.email,
        senha=hash_password(passageiro.senha),
    )

    db.add(novo_passageiro)
    db.commit()
    db.refresh(novo_passageiro)
    return novo_passageiro


@router.get("/", response_model=List[PassageiroCreate])
def listar_passageiros(db: Session = Depends(get_db)):
    return db.query(Passageiro).all()
