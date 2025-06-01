import os
from dotenv import load_dotenv

load_dotenv()

admin_db_connect = os.getenv("DB_CONNECT")
print(admin_db_connect)

JWT_SECRET = os.getenv("JWT_SECRET")
JWT_ALGORITHM = os.getenv("JWT_ALGORITHM")
TOKEN_EXPIRE_MINUTES = os.getenv("TOKEN_EXPIRE_MINUTES")

UPLOAD_DIR = "./uploads"
os.makedirs(UPLOAD_DIR, exist_ok=True)
