from fastapi import FastAPI, Depends, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from fastapi.security import OAuth2PasswordBearer
from jose import jwt, JWTError
from config import JWT_SECRET, JWT_ALGORITHM
from database import db_pools, get_db_connection
from models import ProductModel
from typing import List, Annotated, Optional
from asyncpg import Connection
from auth import router as auth_router
from contextlib import asynccontextmanager
from urllib.parse import unquote

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
async def get_products(conn: AdminConn, emptyField: Optional[str] = None,  category: Optional[str] = None, user: str = Depends(verify_token)):
    conditions = []
    params = []

    if emptyField == "Article":
        conditions.append("(g.good_article IS NULL OR g.good_article = '' OR g.good_article = '@')")

    if emptyField == "Category":
        conditions.append("(g.good_category IS NULL OR g.good_category = '' OR g.good_category = '@')")

    if emptyField == "Description":
        conditions.append("(g.good_description IS NULL OR g.good_description = '' OR g.good_description = '@')")

    if emptyField == "Brand":
        conditions.append("(g.good_brand IS NULL)")

    if emptyField == "Photo":
        conditions.append("(g.photo_path IS NULL OR g.photo_path = '@')")

    if category:
        params.append(category)
        conditions.append(f"c.cat_name = ${len(params)}")

    where_clause = f"WHERE {' AND '.join(conditions)}" if conditions else ""

    query = f"""
            SELECT 
                g.good_id, g.good_name, g.good_article, g.good_barcode, c.cat_name,
                g.good_description, g.good_brand, 
                g.active, g.filled, g.photo_path
            FROM goods g
            LEFT JOIN goods_categories c ON g.good_category = c.cat_id
            {where_clause}
            ORDER BY g.good_id ASC 
            LIMIT 100;
        """

    rows = await conn.fetch(query, *params)
    return [ProductModel(**dict(row)) for row in rows]
