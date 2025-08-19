# backend/app/models/models.py
from sqlalchemy import Column, Integer, String, ForeignKey, Date, Time
from sqlalchemy.orm import relationship
from core.database import Base

class Motorista(Base):
    __tablename__ = "motoristas"

    id = Column(Integer, primary_key=True, index=True)
    nome = Column(String, nullable=False)
    email = Column(String, unique=True, index=True, nullable=False)
    senha = Column(String, nullable=False)
    telefone = Column(String, nullable=True)

    vans = relationship("Van", back_populates="motorista")

class Passageiro(Base):
    __tablename__ = "passageiros"

    id = Column(Integer, primary_key=True, index=True)
    nome = Column(String, nullable=False)
    email = Column(String, unique=True, index=True, nullable=False)
    senha = Column(String, nullable=False)
    telefone = Column(String, nullable=True)

    viagens = relationship("Viagem", back_populates="passageiro")

class Van(Base):
    __tablename__ = "vans"

    id = Column(Integer, primary_key=True, index=True)
    modelo = Column(String, nullable=False)
    placa = Column(String, unique=True, nullable=False)
    motorista_id = Column(Integer, ForeignKey("motoristas.id"))

    motorista = relationship("Motorista", back_populates="vans")
    viagens = relationship("Viagem", back_populates="van")

class Viagem(Base):
    __tablename__ = "viagens"

    id = Column(Integer, primary_key=True, index=True)
    data = Column(Date, nullable=False)
    hora = Column(Time, nullable=False)
    van_id = Column(Integer, ForeignKey("vans.id"))
    passageiro_id = Column(Integer, ForeignKey("passageiros.id"))

    van = relationship("Van", back_populates="viagens")
    passageiro = relationship("Passageiro", back_populates="viagens")
