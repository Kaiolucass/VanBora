
#backend/routers/viagem_passageiros.py
from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from core.database import get_db
from models.models import ViagemPassageiro
from schemas.viagens_schema import ViagemPassageiroCreate, ViagemPassageiroResponse
from typing import List

router = APIRouter(prefix="/viagem-passageiros", tags=["ViagemPassageiros"])

@router.post("/", response_model=ViagemPassageiroResponse)
def adicionar_passageiro_viagem(vp: ViagemPassageiroCreate, db: Session = Depends(get_db)):
    novo_vp = ViagemPassageiro(**vp.dict())
    db.add(novo_vp)
    db.commit()
    db.refresh(novo_vp)
    return novo_vp

@router.get("/", response_model=List[ViagemPassageiroResponse])
def listar_viagem_passageiros(db: Session = Depends(get_db)):
    return db.query(ViagemPassageiro).all()
