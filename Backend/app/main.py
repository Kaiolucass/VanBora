from fastapi import FastAPI
from core.database import create_db  
from routers import passageiros, vans, viagens, motoristas, rotas, paradas, viagem_passageiros


app = FastAPI(title="VanBora API")

app.include_router(passageiros.router)
app.include_router(vans.router)
app.include_router(viagens.router)
app.include_router(motoristas.router)
app.include_router(rotas.router)
app.include_router(paradas.router)
app.include_router(viagem_passageiros.router)

@app.on_event("startup")
def startup():
    create_db()



