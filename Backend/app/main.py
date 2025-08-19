from fastapi import FastAPI
from core.database import create_db  
from routers import passageiros, vans, viagens

app = FastAPI(title="VanBora API")

app.include_router(passageiros.router)
app.include_router(vans.router)
app.include_router(viagens.router)

@app.on_event("startup")
def startup():
    create_db()
