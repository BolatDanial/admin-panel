from fastapi import APIRouter, Depends, HTTPException
from fastapi.security import OAuth2PasswordRequestForm
from datetime import datetime, timedelta
from jose import jwt
from config import JWT_SECRET, JWT_ALGORITHM, TOKEN_EXPIRE_MINUTES
from models import Token

router = APIRouter()

# Dummy admin login for test
ADMIN_USER = {
    "username": "admin",
    "password": "admin123"
}

@router.post("/admin/login", response_model=Token)
async def login(form_data: OAuth2PasswordRequestForm = Depends()):
    if form_data.username != ADMIN_USER["username"] or form_data.password != ADMIN_USER["password"]:
        raise HTTPException(status_code=401, detail="Invalid credentials")

    expire = datetime.utcnow() + timedelta(minutes=TOKEN_EXPIRE_MINUTES)
    token_data = {
        "sub": form_data.username,
        "exp": expire
    }
    token = jwt.encode(token_data, JWT_SECRET, algorithm=JWT_ALGORITHM)
    return Token(access_token=token)
