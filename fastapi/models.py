from pydantic import BaseModel
from typing import List, Optional

class ProductBase(BaseModel):
    good_id: str
    good_name: str
    good_article: Optional[str] = None
    good_barcode: str
    good_description: Optional[str] = None
    photo_path: Optional[str] = None

# Input model (for POST/PUT requests)
class ProductCreate(ProductBase):
    good_category: Optional[str] = None
    good_brand: Optional[int] = None

# Output model (for GET responses)
class ProductGet(ProductBase):
    cat_name: Optional[str] = None
    brand_name: Optional[str]

class CategoryModel(BaseModel):
    cat_id: str
    cat_name: str

class BrandModel(BaseModel):
    brand_id: int
    brand_name: str

class Token(BaseModel):
    access_token: str
    token_type: str = "bearer"

class AdminLoginRequest(BaseModel):
    username: str
    password: str
