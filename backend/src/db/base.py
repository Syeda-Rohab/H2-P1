from sqlmodel import SQLModel, Field
from datetime import datetime


class TimestampMixin(SQLModel):
    """Base model with created_at and updated_at timestamps"""
    created_at: datetime = Field(default_factory=datetime.utcnow)
    updated_at: datetime = Field(default_factory=datetime.utcnow)
