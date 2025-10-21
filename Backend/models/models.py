# backend/models/models.py

from sqlalchemy import Column, Integer, String, ForeignKey, DateTime, Boolean
from sqlalchemy.orm import relationship
from core.database import Base


# 🧑‍✈️ Motorista
class Motorista(Base):
    __tablename__ = "motoristas"

    id = Column(Integer, primary_key=True, index=True)
    nome = Column(String(100), nullable=False)
    email = Column(String(100), unique=True, nullable=False)
    telefone = Column(String(20), nullable=False)
    senha = Column(String(255), nullable=False)

    # 🔗 Relação com as vans
    vans = relationship("Van", back_populates="motorista", cascade="all, delete-orphan")


# 🚐 Van
class Van(Base):
    __tablename__ = "vans"

    id = Column(Integer, primary_key=True, index=True)
    modelo = Column(String(100), nullable=False)
    placa = Column(String(20), unique=True, nullable=False)
    capacidade = Column(Integer, nullable=False)
    motorista_id = Column(Integer, ForeignKey("motoristas.id", ondelete="CASCADE"), nullable=False)

    motorista = relationship("Motorista", back_populates="vans")
    rotas = relationship("Rota", back_populates="van", cascade="all, delete-orphan")


# 🗺️ Rota
class Rota(Base):
    __tablename__ = "rotas"

    id = Column(Integer, primary_key=True, index=True)
    nome = Column(String(100), nullable=False)
    van_id = Column(Integer, ForeignKey("vans.id", ondelete="CASCADE"), nullable=False)

    van = relationship("Van", back_populates="rotas")
    paradas = relationship("Parada", back_populates="rota", cascade="all, delete-orphan")
    viagens = relationship("Viagem", back_populates="rota", cascade="all, delete-orphan")


# 🏁 Parada
class Parada(Base):
    __tablename__ = "paradas"

    id = Column(Integer, primary_key=True, index=True)
    endereco = Column(String(255), nullable=False)
    ordem = Column(Integer, nullable=False)
    rota_id = Column(Integer, ForeignKey("rotas.id", ondelete="CASCADE"), nullable=False)

    rota = relationship("Rota", back_populates="paradas")
    passageiros = relationship("Passageiro", back_populates="parada", cascade="all, delete-orphan")


# 🧍 Passageiro
class Passageiro(Base):
    __tablename__ = "passageiros"

    id = Column(Integer, primary_key=True, index=True)
    nome = Column(String(100), nullable=False)
    email = Column(String(100), unique=True, nullable=False)
    telefone = Column(String(20), nullable=False)
    senha = Column(String(255), nullable=False)

    parada_id = Column(Integer, ForeignKey("paradas.id", ondelete="SET NULL"))
    parada = relationship("Parada", back_populates="passageiros")

    viagens = relationship("ViagemPassageiro", back_populates="passageiro", cascade="all, delete-orphan")


# 🚌 Viagem
class Viagem(Base):
    __tablename__ = "viagens"

    id = Column(Integer, primary_key=True, index=True)
    data_hora = Column(DateTime, nullable=False)

    rota_id = Column(Integer, ForeignKey("rotas.id", ondelete="CASCADE"), nullable=False)
    rota = relationship("Rota", back_populates="viagens")

    passageiros = relationship("ViagemPassageiro", back_populates="viagem", cascade="all, delete-orphan")


# 🎫 Associação entre Viagem e Passageiro
class ViagemPassageiro(Base):
    __tablename__ = "viagem_passageiros"

    id = Column(Integer, primary_key=True, index=True)
    viagem_id = Column(Integer, ForeignKey("viagens.id", ondelete="CASCADE"), nullable=False)
    passageiro_id = Column(Integer, ForeignKey("passageiros.id", ondelete="CASCADE"), nullable=False)
    confirmado = Column(Boolean, default=False)

    viagem = relationship("Viagem", back_populates="passageiros")
    passageiro = relationship("Passageiro", back_populates="viagens")