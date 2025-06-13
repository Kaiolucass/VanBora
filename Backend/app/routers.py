from fastapi import APIRouter
from core import SessionLocal
from models import Usuario, Van, Viagem

auth_routes = APIRouter()
viagem_routes = APIRouter()
van_routes = APIRouter()

# Auth endpoints
@auth_routes.post("/cadastro")
def cadastrar(nome: str, email: str, senha: str, tipo_perfil: str):
    db = SessionLocal()
    if db.query(Usuario).filter_by(email=email).first():
        return {"erro": "Email já registrado"}
    novo = Usuario(nome=nome, email=email, senha=senha, tipo_perfil=tipo_perfil)
    db.add(novo)
    db.commit()
    return {"msg": "Cadastrado com sucesso"}

@auth_routes.post("/login")
def login(email: str, senha: str):
    db = SessionLocal()
    user = db.query(Usuario).filter_by(email=email, senha=senha).first()
    if not user:
        return {"erro": "Credenciais inválidas"}
    return {"msg": "Login OK", "id": user.id, "perfil": user.tipo_perfil}

# Vans endpoints
@van_routes.post("/")
def cadastrar_van(placa: str, modelo: str, capacidade: int, motorista_id: str):
    db = SessionLocal()
    van = Van(placa=placa, modelo=modelo, capacidade=capacidade, motorista_id=motorista_id)
    db.add(van)
    db.commit()
    return {"msg": "Van cadastrada"}

@van_routes.get("/")
def listar_vans():
    db = SessionLocal()
    return db.query(Van).all()

# Viagens endpoints
@viagem_routes.post("/")
def iniciar_viagem(van_id: str):
    db = SessionLocal()
    viagem = Viagem(van_id=van_id)
    db.add(viagem)
    db.commit()
    return {"msg": "Viagem iniciada"}

@viagem_routes.get("/")
def listar_viagens():
    db = SessionLocal()
    return db.query(Viagem).all()
