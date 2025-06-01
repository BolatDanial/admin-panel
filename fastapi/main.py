from fastapi import FastAPI, Depends, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from fastapi.security import OAuth2PasswordBearer
from jose import jwt, JWTError
from config import JWT_SECRET, JWT_ALGORITHM
from database import db_pools, get_db_connection
from models import ProductModel
from typing import List, Annotated
from asyncpg import Connection
from auth import router as auth_router
from contextlib import asynccontextmanager

AdminConn = Annotated[Connection, get_db_connection("admin")]

oauth2_scheme = OAuth2PasswordBearer(tokenUrl="/admin/login")

def verify_token(token: str = Depends(oauth2_scheme)):
    try:
        payload = jwt.decode(token, JWT_SECRET, algorithms=[JWT_ALGORITHM])
        return payload.get("sub")
    except JWTError:
        raise HTTPException(status_code=403, detail="Invalid or expired token")

@asynccontextmanager
async def lifespan(app: FastAPI):
    await db_pools.init_all_pools()
    yield
    await db_pools.close_all_pools()

app = FastAPI(title="Admin Panel", lifespan=lifespan)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(auth_router)

@app.get("/admin/products", response_model=List[ProductModel])
async def get_products(conn: AdminConn, user: str = Depends(verify_token)):
    query = """
        SELECT 
            g.good_id, g.good_name, g.good_article, g.good_barcode, 
            g.good_description, g.good_brand, g.good_category, 
            g.active, g.filled, g.photo_path
        FROM goods g
        WHERE g.good_id=$1
        LIMIT 100;
    """
    rows = await conn.fetch(query, "00494f92-e6a1-4645-bcd1-428b5397c453")
    return [ProductModel(**dict(row)) for row in rows]
