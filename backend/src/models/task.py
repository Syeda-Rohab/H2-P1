from sqlmodel import SQLModel, Field, Relationship
from typing import Optional, TYPE_CHECKING
from src.db.base import TimestampMixin

if TYPE_CHECKING:
    from src.models.user import User


class Task(TimestampMixin, table=True):
    """Task model for todo items"""
    __tablename__ = "tasks"

    id: Optional[int] = Field(default=None, primary_key=True)
    user_id: int = Field(foreign_key="users.id", index=True)
    title: str = Field(max_length=200)
    description: Optional[str] = Field(default=None, max_length=1000)
    status: str = Field(default="Incomplete", max_length=50)

    # Relationship
    user: "User" = Relationship(back_populates="tasks")
