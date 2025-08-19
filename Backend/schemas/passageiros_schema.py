# backend/app/schemas/passageiros_schema.py
from pydantic import BaseModel

class PassageiroBase(BaseModel):
    nome: str
    email: str
    telefone: str | None = None

class PassageiroCreate(PassageiroBase):
    senha: str

class PassageiroResponse(PassageiroBase):
    id: int
    class Config:
        orm_mode = True
