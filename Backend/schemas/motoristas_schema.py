# backend/app/schemas/motoristas_schema.py
from pydantic import BaseModel

class MotoristaBase(BaseModel):
    nome: str
    email: str
    telefone: str | None = None

class MotoristaCreate(MotoristaBase):
    senha: str

class MotoristaResponse(MotoristaBase):
    id: int
    class Config:
        orm_mode = True
