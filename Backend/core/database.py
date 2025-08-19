from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker, declarative_base

# CONEXÃO COM O POSTGRES
DATABASE_URL = "postgresql://postgres:12345678@localhost:5432/vanbora"

engine = create_engine(DATABASE_URL)
SessionLocal = sessionmaker(bind=engine, autocommit=False, autoflush=False)
Base = declarative_base()


# CRIA AS TABELAS NO BANCO (executar uma vez só)
def create_db():
    from models.models import Motorista, Passageiro, Van, Viagem
    Base.metadata.create_all(bind=engine)


# Função para abrir conexão nos routers
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()
