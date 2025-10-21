# backend/app/schemas/viagens_schema.py

from pydantic import BaseModel
from datetime import datetime
from typing import List

class ViagemBase(BaseModel):
    data_hora: datetime
    rota_id: int

class ViagemCreate(ViagemBase):
    pass

class ViagemResponse(ViagemBase):
    id: int
    class Config:
        from_attributes = True



class ViagemPassageiroBase(BaseModel):
    viagem_id: int
    passageiro_id: int
    confirmado: bool = False

class ViagemPassageiroCreate(ViagemPassageiroBase):
    pass

class ViagemPassageiroResponse(ViagemPassageiroBase):
    id: int

    class Config:
       from_attributes = True

