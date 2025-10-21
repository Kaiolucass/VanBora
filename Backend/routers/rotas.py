# backend/routers/rotas.py

from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from core.database import get_db
from models.models import Rota, Parada
from schemas.rotas_schema import RotaCreate, RotaResponse

router = APIRouter(prefix="/rotas", tags=["Rotas"])

# -------------------------------
# CRIAR ROTA
# -------------------------------
@router.post("/", response_model=RotaResponse)
def criar_rota(rota: RotaCreate, db: Session = Depends(get_db)):
    nova_rota = Rota(nome=rota.nome, van_id=rota.van_id)
    db.add(nova_rota)
    db.commit()
    db.refresh(nova_rota)

    # Cria as paradas associadas, se houver
    if rota.paradas:
        for parada in rota.paradas:
            nova_parada = Parada(
                endereco=parada.endereco,
                ordem=parada.ordem,
                rota_id=nova_rota.id
            )
            db.add(nova_parada)
        db.commit()
        db.refresh(nova_rota)

    return nova_rota


# -------------------------------
# LISTAR TODAS AS ROTAS
# -------------------------------
@router.get("/", response_model=list[RotaResponse])
def listar_rotas(db: Session = Depends(get_db)):
    rotas = db.query(Rota).all()
    return rotas
