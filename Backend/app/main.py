from fastapi import FastAPI
from core.database import create_db  
from routers import passageiros, vans, viagens, motoristas, rotas, paradas, viagem_passageiros,login


app = FastAPI(title="VanBora API")

from fastapi.middleware.cors import CORSMiddleware

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


app.include_router(passageiros.router)
app.include_router(vans.router)
app.include_router(viagens.router)
app.include_router(motoristas.router)
app.include_router(rotas.router)
app.include_router(paradas.router)
app.include_router(viagem_passageiros.router)
app.include_router(login.router)

@app.on_event("startup")
def startup():
    create_db()



