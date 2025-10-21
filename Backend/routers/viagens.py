# backend/routers/viagens.py

from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from core.database import get_db
from models.models import Viagem, ViagemPassageiro, Passageiro, Rota, Van, Motorista

router = APIRouter(prefix="/viagens", tags=["Viagens"])

# Motorista vê os passageiros confirmados nas suas viagens
@router.get("/motorista/{motorista_id}")
def listar_passageiros_por_motorista(motorista_id: int, db: Session = Depends(get_db)):
    # Viagem -> Rota -> Van -> Motorista
    viagens = (
        db.query(Viagem)
        .join(Rota, Viagem.rota)
        .join(Van, Rota.van)
        .join(Motorista, Van.motorista)
        .filter(Motorista.id == motorista_id)
        .all()
    )

    if not viagens:
        raise HTTPException(status_code=404, detail="Nenhuma viagem encontrada para este motorista")

    resultado = []
    for v in viagens:
        passageiros = (
            db.query(Passageiro, ViagemPassageiro.confirmado)
            .join(ViagemPassageiro, ViagemPassageiro.passageiro_id == Passageiro.id)
            .filter(ViagemPassageiro.viagem_id == v.id)
            .all()
        )
        resultado.append({
            "viagem_id": v.id,
            "rota_id": v.rota_id,
            "data_hora": v.data_hora.isoformat() if v.data_hora else None,
            "passageiros": [
                {
                    "id": p.Passageiro.id,
                    "nome": p.Passageiro.nome,
                    "email": p.Passageiro.email,
                    "telefone": p.Passageiro.telefone,
                    "confirmado": p.confirmado,
                }
                for p in passageiros
            ]
        })
    return resultado


# Passageiro vê suas viagens
@router.get("/passageiro/{passageiro_id}")
def listar_viagens_por_passageiro(passageiro_id: int, db: Session = Depends(get_db)):
    viagens = (
        db.query(Viagem, ViagemPassageiro.confirmado)
        .join(ViagemPassageiro, ViagemPassageiro.viagem_id == Viagem.id)
        .filter(ViagemPassageiro.passageiro_id == passageiro_id)
        .all()
    )

    if not viagens:
        raise HTTPException(status_code=404, detail="Nenhuma viagem encontrada para este passageiro")

    return [
        {
            "viagem_id": v.Viagem.id,
            "rota_id": v.Viagem.rota_id,
            "data_hora": v.Viagem.data_hora.isoformat() if v.Viagem.data_hora else None,
            "confirmado": v.confirmado,
        }
        for v in viagens
    ]
