from fastapi import APIRouter, Depends, HTTPException
from pydantic import BaseModel
from sqlalchemy.orm import Session
from core.database import get_db
from core.auth import create_access_token, verify_password
from models.models import Passageiro, Motorista
from datetime import timedelta

router = APIRouter(prefix="/login", tags=["Login"])

# ✅ Define o formato do JSON esperado
class LoginRequest(BaseModel):
    email: str
    senha: str

@router.post("/")
def login(request: LoginRequest, db: Session = Depends(get_db)):
    email = request.email
    senha = request.senha

    # 🔹 Tenta achar o passageiro
    passageiro = db.query(Passageiro).filter(Passageiro.email == email).first()
    if passageiro and verify_password(senha, passageiro.senha):
        token = create_access_token(
            {"sub": passageiro.email, "tipo": "passageiro", "id": passageiro.id},
            expires_delta=timedelta(hours=24)
        )
        return {
            "access_token": token,
            "token_type": "bearer",
            "tipo": "passageiro",
            "id": passageiro.id,
            "nome": passageiro.nome
        }

    # 🔹 Se não for passageiro, tenta motorista
    motorista = db.query(Motorista).filter(Motorista.email == email).first()
    if motorista and verify_password(senha, motorista.senha):
        token = create_access_token(
            {"sub": motorista.email, "tipo": "motorista", "id": motorista.id},
            expires_delta=timedelta(hours=24)
        )
        return {
            "access_token": token,
            "token_type": "bearer",
            "tipo": "motorista",
            "id": motorista.id,
            "nome": motorista.nome
        }

    # ❌ Nenhum usuário encontrado
    raise HTTPException(status_code=401, detail="Email ou senha inválidos")
