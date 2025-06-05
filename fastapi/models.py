from pydantic import BaseModel
from typing import List, Optional

#Base Model
class ProductBase(BaseModel):
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
    good_id: str
    cat_name: Optional[str] = None
    brand_name: Optional[str]

#Base Model
class CategoryBase(BaseModel):
    cat_name: str
    cat_parent: str

# Input model (for POST/PUT requests)
class CategoryCreate(CategoryBase):
    cat_keywords: str
    cat_photo_path: str
    bad_keywords: str

# Output model (for GET responses)
class CategoryGet(CategoryBase):
    cat_id: str

#Base Model
class BrandBase(BaseModel):
    brand_id: int
    brand_name: str

# Input model (for POST/PUT requests)
class BrandCreate(BrandBase):
    brand_keywords: List[str]

class Token(BaseModel):
    access_token: str
    token_type: str = "bearer"

class AdminLoginRequest(BaseModel):
    username: str
    password: str
