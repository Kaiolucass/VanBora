from pydantic import BaseModel
from typing import Optional, List
from schemas.paradas_schema import ParadaCreate, ParadaResponse

class RotaBase(BaseModel):
    nome: str
    van_id: int


class RotaCreate(RotaBase):
    paradas: Optional[List[ParadaCreate]] = None  


class RotaResponse(RotaBase):
    id: int
    paradas: Optional[List[ParadaResponse]] = None

    class Config:
        from_attributes = True  
