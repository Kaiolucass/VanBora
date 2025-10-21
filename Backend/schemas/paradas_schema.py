from pydantic import BaseModel

class ParadaBase(BaseModel):
    endereco: str
    ordem: int
    rota_id: int

class ParadaCreate(ParadaBase):
    pass

class ParadaResponse(ParadaBase):
    id: int

    class Config:
        from_attributes = True