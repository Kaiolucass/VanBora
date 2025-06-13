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





