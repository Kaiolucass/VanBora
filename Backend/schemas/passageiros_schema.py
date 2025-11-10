# backend/app/schemas/passageiros_schema.py
from pydantic import BaseModel

class PassageiroBase(BaseModel):
    nome: str
    email: str

class PassageiroCreate(PassageiroBase):
    senha: str

class PassageiroResponse(PassageiroBase):
    id: int
    class Config:
       from_attributes = True

