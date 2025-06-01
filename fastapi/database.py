import asyncpg
from contextlib import asynccontextmanager
from fastapi import Depends
from typing import Optional, Dict
from config import admin_db_connect

class DatabasePools:
    def __init__(self):
        self.pools: Dict[str, Optional[asyncpg.Pool]] = {
            "admin": None
        }

    async def init_all_pools(self):
        self.pools["admin"] = await asyncpg.create_pool(
            dsn=admin_db_connect,
            min_size=2,
            max_size=10,
            command_timeout=30
        )

    async def close_all_pools(self):
        if self.pools["admin"] and not self.pools["admin"]._closed:
            await self.pools["admin"].close()
            self.pools["admin"] = None

db_pools = DatabasePools()

def get_db_connection(pool_name: str):
    async def dependency():
        async with db_pools.pools[pool_name].acquire() as conn:
            async with conn.transaction():
                yield conn
    return Depends(dependency)
