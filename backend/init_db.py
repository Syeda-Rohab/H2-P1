"""Initialize SQLite database with tables"""
import asyncio
import sys
from pathlib import Path

# Add backend directory to path
sys.path.insert(0, str(Path(__file__).parent))

from sqlmodel import SQLModel
from src.db.session import engine
from src.models.user import User
from src.models.task import Task


async def init_db():
    """Create all tables"""
    async with engine.begin() as conn:
        await conn.run_sync(SQLModel.metadata.create_all)
    print("✅ Database initialized successfully!")


if __name__ == "__main__":
    asyncio.run(init_db())
