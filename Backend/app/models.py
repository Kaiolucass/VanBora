from sqlalchemy import Column, String, Integer, ForeignKey, DateTime
from core import Base
import uuid
from datetime import datetime

class Usuario(Base):
    __tablename__ = "usuarios"
    id = Column(String, primary_key=True, default=lambda: str(uuid.uuid4()))
    nome = Column(String, nullable=False)
    email = Column(String, unique=True, nullable=False)
    senha = Column(String, nullable=False)
    tipo_perfil = Column(String, nullable=False)

class Van(Base):
    __tablename__ = "vans"
    id = Column(String, primary_key=True, default=lambda: str(uuid.uuid4()))
    placa = Column(String, unique=True)
    modelo = Column(String)
    capacidade = Column(Integer)
    motorista_id = Column(String, ForeignKey("usuarios.id"))

class Viagem(Base):
    __tablename__ = "viagens"
    id = Column(String, primary_key=True, default=lambda: str(uuid.uuid4()))
    van_id = Column(String, ForeignKey("vans.id"))
    data_viagem = Column(DateTime, default=datetime.utcnow)
    status = Column(String, default="pendente")
