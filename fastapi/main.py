from fastapi import FastAPI, Depends, HTTPException, Query
from fastapi.middleware.cors import CORSMiddleware
from fastapi.security import OAuth2PasswordBearer
from jose import jwt, JWTError
from config import JWT_SECRET, JWT_ALGORITHM
from database import db_pools, get_db_connection
from models import ProductGet, ProductCreate, CategoryGet, CategoryCreate, BrandBase, BrandCreate
from typing import List, Annotated, Optional
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

@app.get("/admin/products", response_model=List[ProductGet])
async def get_products(conn: AdminConn, emptyField: Optional[str] = None,  category: Optional[str] = None, search: Optional[str] = None, limit: int = Query(20), offset: int = Query(0), user: str = Depends(verify_token)):
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
        conditions.append(f"(c.cat_name = ${len(params)})")

    if search:
        params.append(f"%{search}%")
        conditions.append(f"(g.good_name ILIKE ${len(params)} OR g.good_id ILIKE ${len(params)} OR g.good_barcode ILIKE ${len(params)})")

    params.append(limit)
    params.append(offset)

    where_clause = f"WHERE {' AND '.join(conditions)}" if conditions else ""
    limit_clause = f"LIMIT ${len(params)-1} OFFSET ${len(params)}"

    query = f"""
            SELECT 
                g.good_id, g.good_name, g.good_article, g.good_barcode, c.cat_name,
                g.good_description, b.brand_name, g.photo_path
            FROM goods g
            LEFT JOIN goods_categories c ON g.good_category = c.cat_id
            LEFT JOIN goods_brands b ON g.good_brand = b.brand_id
            {where_clause}
            ORDER BY g.good_id ASC 
            {limit_clause};
        """

    rows = await conn.fetch(query, *params)
    return [ProductGet(**dict(row)) for row in rows]

@app.get("/admin/products/{product_id}", response_model=ProductGet)
async def get_product(conn: AdminConn, product_id: str, user: str = Depends(verify_token)):
    query = f"""
            SELECT 
                g.good_id, g.good_name, g.good_article, g.good_barcode, c.cat_name,
                g.good_description, b.brand_name, g.photo_path
            FROM goods g
            LEFT JOIN goods_categories c ON g.good_category = c.cat_id
            LEFT JOIN goods_brands b ON g.good_brand = b.brand_id
            WHERE g.good_id = $1
        """

    row = await conn.fetchrow(query, product_id)
    print(row)
    return ProductGet(**dict(row))

@app.post("/admin/products", response_model=ProductCreate)
async def create_product(conn: AdminConn, product: ProductCreate, user: str = Depends(verify_token)):
    query = f"""
        INSERT INTO goods (good_name, good_article, good_barcode,
        good_category, good_description, good_brand, active, filled, photo_path)
        VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9)
        RETURNING *;
    """

    row = await conn.fetchrow(query, product.good_name, product.good_article,
                        product.good_barcode, product.good_category, product.good_description,
                        product.good_brand, False, False, product.photo_path)

    return ProductCreate(**dict(row))

@app.put("/admin/products/{product_id}", response_model=ProductCreate)
async def update_product(product_id: str, conn: AdminConn, product: ProductCreate, user: str = Depends(verify_token)):
    query = f"""
        UPDATE goods SET
            good_name=$1, good_article=$2, good_barcode=$3, good_category=$4,
            good_description=$5, good_brand=$6,
            active=$7, filled=$8, photo_path=$9
        WHERE good_id=$10
        RETURNING *;
    """

    row = await conn.fetchrow(query, product.good_name, product.good_article,
                        product.good_barcode, product.good_category, product.good_description,
                        product.good_brand, False, False, product.photo_path, product_id)

    return ProductCreate(**dict(row))

@app.delete("/admin/products/{product_id}")
async def delete_product(product_id: str, conn: AdminConn, user: str = Depends(verify_token)):
    query = "DELETE FROM goods WHERE good_id=$1 RETURNING good_id;"
    row = await conn.fetchrow(query, product_id)
    if row:
        return {"deletedId": row['good_id']}
    else:
        raise HTTPException(status_code=404, detail="Product not found.")

@app.get("/admin/categories", response_model=List[CategoryGet])
async def get_category(conn: AdminConn, isParents: bool = False, user: str = Depends(verify_token)):
    where_clause = ""
    if isParents == False:
        where_clause = f"WHERE cat_parent != '0'"
    elif isParents == True:
        where_clause = f"WHERE cat_parent = '0'"

    query = f"""
        SELECT c.cat_id, c.cat_name, cat_parent FROM goods_categories c {where_clause} ORDER BY c.cat_name ASC 
    """

    rows = await conn.fetch(query)
    return [CategoryGet(**dict(row)) for row in rows]


@app.post("/admin/categories", response_model=CategoryCreate)
async def create_category(conn: AdminConn, categpry: CategoryCreate, user: str = Depends(verify_token)):
    query = f"""
        INSERT INTO goods_categories (cat_name, cat_parent, cat_keywords, cat_photo_path, bad_keywords) 
        VALUES ($1, $2, $3, $4, $5) 
        RETURNING *; 
    """

    row = await conn.fetchrow(query, categpry.cat_name, categpry.cat_parent, categpry.cat_keywords, categpry.cat_photo_path, categpry.bad_keywords)
    return CategoryCreate(**dict(row))

@app.get("/admin/brands", response_model=List[BrandBase])
async def get_brands(conn: AdminConn, user: str = Depends(verify_token)):
    query = f"""
        SELECT b.brand_id, b.brand_name FROM goods_brands b ORDER BY b.brand_id ASC 
    """

    rows = await conn.fetch(query)
    return [BrandBase(**dict(row)) for row in rows]

@app.post("/admin/brands", response_model=BrandCreate)
async def create_brand(conn: AdminConn, brand: BrandCreate, user: str = Depends(verify_token)):
    query = f"""
        INSERT INTO goods_brands (brand_id, brand_name, brand_keywords)
        VALUES ($1, $2, $3)
        RETURNING *;
    """

    row = await conn.fetchrow(query, brand.brand_id, brand.brand_name, brand.brand_keywords)

    return BrandCreate(**dict(row))