# Estrutura base do Backend do VanBora (FastAPI - MVP)

# app/main.py
from fastapi import FastAPI
from app.routers import auth, viagens, vans
from app.core.database import create_db

app = FastAPI(title="VanBora API")

app.include_router(auth.router, prefix="/auth", tags=["Auth"])
app.include_router(viagens.router, prefix="/viagens", tags=["Viagens"])
app.include_router(vans.router, prefix="/vans", tags=["Vans"])

@app.on_event("startup")
def startup():
    create_db()

@app.get("/")
def home():
    return {"msg": "VanBora API MVP"}


# app/core/database.py
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker, declarative_base

DATABASE_URL = "sqlite:///./vanbora.db"  # Trocar para PostgreSQL depois
engine = create_engine(DATABASE_URL, connect_args={"check_same_thread": False})
SessionLocal = sessionmaker(bind=engine, autocommit=False, autoflush=False)
Base = declarative_base()

def create_db():
    from app.models import usuario, viagem, van  # importa para registrar models
    Base.metadata.create_all(bind=engine)


# app/models/usuario.py
from sqlalchemy import Column, String
from sqlalchemy.dialects.sqlite import BLOB
from sqlalchemy.orm import relationship
from app.core.database import Base
import uuid

class Usuario(Base):
    __tablename__ = "usuarios"
    id = Column(String, primary_key=True, default=lambda: str(uuid.uuid4()))
    nome = Column(String, nullable=False)
    email = Column(String, unique=True, nullable=False)
    senha = Column(String, nullable=False)
    tipo_perfil = Column(String, nullable=False)  # motorista ou passageiro


# app/models/van.py
from sqlalchemy import Column, String, Integer, ForeignKey
from sqlalchemy.orm import relationship
from app.core.database import Base
import uuid

class Van(Base):
    __tablename__ = "vans"
    id = Column(String, primary_key=True, default=lambda: str(uuid.uuid4()))
    placa = Column(String, unique=True)
    modelo = Column(String)
    capacidade = Column(Integer)
    motorista_id = Column(String, ForeignKey("usuarios.id"))


# app/models/viagem.py
from sqlalchemy import Column, String, ForeignKey, DateTime
from sqlalchemy.orm import relationship
from app.core.database import Base
import uuid
from datetime import datetime

class Viagem(Base):
    __tablename__ = "viagens"
    id = Column(String, primary_key=True, default=lambda: str(uuid.uuid4()))
    van_id = Column(String, ForeignKey("vans.id"))
    data_viagem = Column(DateTime, default=datetime.utcnow)
    status = Column(String, default="pendente")


# app/routers/auth.py
from fastapi import APIRouter, HTTPException
from app.core.database import SessionLocal
from app.models.usuario import Usuario

router = APIRouter()

@router.post("/cadastro")
def cadastro(nome: str, email: str, senha: str, tipo_perfil: str):
    db = SessionLocal()
    if db.query(Usuario).filter_by(email=email).first():
        raise HTTPException(status_code=400, detail="Email já registrado")
    user = Usuario(nome=nome, email=email, senha=senha, tipo_perfil=tipo_perfil)
    db.add(user)
    db.commit()
    db.refresh(user)
    return {"msg": "Usuário cadastrado", "id": user.id}

@router.post("/login")
def login(email: str, senha: str):
    db = SessionLocal()
    user = db.query(Usuario).filter_by(email=email, senha=senha).first()
    if not user:
        raise HTTPException(status_code=401, detail="Credenciais inválidas")
    return {"msg": "Login bem-sucedido", "id": user.id, "tipo": user.tipo_perfil}


# app/routers/vans.py
from fastapi import APIRouter
from app.core.database import SessionLocal
from app.models.van import Van

router = APIRouter()

@router.post("/")
def criar_van(placa: str, modelo: str, capacidade: int, motorista_id: str):
    db = SessionLocal()
    van = Van(placa=placa, modelo=modelo, capacidade=capacidade, motorista_id=motorista_id)
    db.add(van)
    db.commit()
    db.refresh(van)
    return van

@router.get("/")
def listar_vans():
    db = SessionLocal()
    return db.query(Van).all()


# app/routers/viagens.py
from fastapi import APIRouter
from app.core.database import SessionLocal
from app.models.viagem import Viagem

router = APIRouter()

@router.post("/")
def iniciar_viagem(van_id: str):
    db = SessionLocal()
    viagem = Viagem(van_id=van_id)
    db.add(viagem)
    db.commit()
    db.refresh(viagem)
    return viagem

@router.get("/")
def listar_viagens():
    db = SessionLocal()
    return db.query(Viagem).all()
