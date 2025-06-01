from pydantic import BaseModel
from typing import List, Optional

class ProductModel(BaseModel):
    good_id: str
    good_name: str
    good_article: Optional[str]
    good_barcode: Optional[str]
    good_description: Optional[str]
    good_brand: Optional[int]
    good_category: Optional[str]
    active: bool
    filled: bool
    photo_path: Optional[str]

class Token(BaseModel):
    access_token: str
    token_type: str = "bearer"

class AdminLoginRequest(BaseModel):
    username: str
    password: str
