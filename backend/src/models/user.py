from sqlmodel import SQLModel, Field, Relationship
from typing import Optional, List, TYPE_CHECKING
from src.db.base import TimestampMixin

if TYPE_CHECKING:
    from src.models.task import Task


class User(TimestampMixin, table=True):
    """User model for authentication"""
    __tablename__ = "users"

    id: Optional[int] = Field(default=None, primary_key=True)
    email: str = Field(unique=True, index=True, max_length=255)
    hashed_password: str = Field(max_length=255)

    # Relationship
    tasks: List["Task"] = Relationship(back_populates="user", cascade_delete=True)
