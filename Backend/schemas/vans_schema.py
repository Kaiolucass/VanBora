# backend/app/schemas/vans_schema.py

from pydantic import BaseModel
from typing import Optional

class VanBase(BaseModel):
    modelo: str
    placa: str

class VanCreate(VanBase):
    motorista_id: int

class VanResponse(VanBase):
    id: int
    motorista_id: int

    class Config:
        orm_mode = True
