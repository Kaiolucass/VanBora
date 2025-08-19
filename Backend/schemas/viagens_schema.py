# backend/app/schemas/viagens_schema.py

from pydantic import BaseModel
from datetime import date, time

class ViagemBase(BaseModel):
    data: date
    hora: time

class ViagemCreate(ViagemBase):
    van_id: int
    passageiro_id: int

class ViagemResponse(ViagemBase):
    id: int
    van_id: int
    passageiro_id: int

    class Config:
        orm_mode = True
