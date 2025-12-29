from sqlmodel import select
from sqlmodel.ext.asyncio.session import AsyncSession
from fastapi import HTTPException, status
from src.models.task import Task
from src.models.user import User


async def create_task(
    db: AsyncSession, user_id: int, title: str, description: str | None = None
) -> Task:
    """Create a new task for a user"""
    # Validate title
    title = title.strip()
    if not title:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Title cannot be empty"
        )
    if len(title) > 200:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Title exceeds 200 characters"
        )

    # Validate description
    if description and len(description) > 1000:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Description exceeds 1000 characters"
        )

    task = Task(
        user_id=user_id,
        title=title,
        description=description,
        status="Incomplete"
    )
    db.add(task)
    await db.commit()
    await db.refresh(task)
    return task


async def get_user_tasks(db: AsyncSession, user_id: int) -> list[Task]:
    """Get all tasks for a user"""
    result = await db.execute(
        select(Task).where(Task.user_id == user_id).order_by(Task.created_at.desc())
    )
    return list(result.scalars().all())


async def get_task_by_id(db: AsyncSession, task_id: int, user_id: int) -> Task:
    """Get a specific task by ID, ensuring it belongs to the user"""
    result = await db.execute(
        select(Task).where(Task.id == task_id, Task.user_id == user_id)
    )
    task = result.scalar_one_or_none()
    if not task:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Task not found"
        )
    return task


async def update_task(
    db: AsyncSession,
    task_id: int,
    user_id: int,
    title: str | None = None,
    description: str | None = None,
    status: str | None = None
) -> Task:
    """Update a task"""
    task = await get_task_by_id(db, task_id, user_id)

    if title is not None:
        title = title.strip()
        if not title:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Title cannot be empty"
            )
        if len(title) > 200:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Title exceeds 200 characters"
            )
        task.title = title

    if description is not None:
        if len(description) > 1000:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Description exceeds 1000 characters"
            )
        task.description = description

    if status is not None:
        if status not in ["Complete", "Incomplete"]:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Status must be 'Complete' or 'Incomplete'"
            )
        task.status = status

    await db.commit()
    await db.refresh(task)
    return task


async def delete_task(db: AsyncSession, task_id: int, user_id: int) -> None:
    """Delete a task"""
    task = await get_task_by_id(db, task_id, user_id)
    await db.delete(task)
    await db.commit()


async def toggle_task_status(db: AsyncSession, task_id: int, user_id: int) -> Task:
    """Toggle task status between Complete and Incomplete"""
    task = await get_task_by_id(db, task_id, user_id)
    task.status = "Complete" if task.status == "Incomplete" else "Incomplete"
    await db.commit()
    await db.refresh(task)
    return task
