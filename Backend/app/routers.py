
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