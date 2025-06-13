from fastapi import FastAPI
from core import create_db
from routers import auth_routes, viagem_routes, van_routes

app = FastAPI()

app.include_router(auth_routes, prefix="/auth", tags=["Auth"])
app.include_router(viagem_routes, prefix="/viagens", tags=["Viagens"])
app.include_router(van_routes, prefix="/vans", tags=["Vans"])

@app.on_event("startup")
def on_startup():
    create_db()

@app.get("/")
def root():
    return {"msg": "VanBora API Online"}
