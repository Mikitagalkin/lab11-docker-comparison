import asyncio
import signal
import time
from contextlib import asynccontextmanager
from fastapi import FastAPI
import uvicorn

@asynccontextmanager
async def lifespan(app: FastAPI):
    # Startup
    print("Python сервер запущен")
    yield
    # Shutdown
    print("Python сервер остановлен")

app = FastAPI(lifespan=lifespan)

@app.get("/health")
async def health():
    return {"status": "healthy", "time": time.time()}

@app.get("/ping")
async def ping():
    return {"message": "pong", "time": time.time()}

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)