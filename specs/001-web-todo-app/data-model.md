# Data Model: Full-Stack Web Todo Application (Phase II)

**Date**: 2025-12-28
**Feature**: Full-Stack Web Todo App
**Purpose**: Define database entities, relationships, and validation rules

## Overview

This document specifies the data model for the multi-user todo application. The model consists of two primary entities (User and Task) with a one-to-many relationship enforced by foreign key constraints.

---

## Entity: User

**Purpose**: Represents a registered user account with authentication credentials.

### Fields

| Field | Type | Constraints | Description |
|-------|------|-------------|-------------|
| `id` | Integer | PRIMARY KEY, AUTO_INCREMENT | Unique user identifier |
| `email` | String(255) | UNIQUE, NOT NULL, INDEX | User's email address (used for login) |
| `hashed_password` | String(255) | NOT NULL | Bcrypt-hashed password (never store plaintext) |
| `created_at` | DateTime | NOT NULL, DEFAULT now() | Account creation timestamp (UTC) |
| `updated_at` | DateTime | NOT NULL, DEFAULT now(), ON UPDATE now() | Last modification timestamp (UTC) |

### Validation Rules

**Email**:
- **Format**: Must match email regex pattern (e.g., `user@example.com`)
- **Uniqueness**: Case-insensitive unique constraint (lowercase before insert)
- **Length**: 5-255 characters
- **Required**: Cannot be null or empty

**Password** (before hashing):
- **Length**: Minimum 8 characters (enforced at API level, not database)
- **Storage**: Always hashed with bcrypt (cost factor 12) before saving
- **Never Exposed**: Excluded from API responses

### Indexes

- **PRIMARY INDEX**: `id` (auto-created with PRIMARY KEY)
- **UNIQUE INDEX**: `email` (for fast login lookups and uniqueness enforcement)

### Relationships

- **Tasks**: One-to-many relationship with Task entity
  - A user can have zero or more tasks
  - Cascade behavior: `ON DELETE CASCADE` (deleting user deletes all their tasks)

### SQLModel Example

```python
from sqlmodel import Field, SQLModel, Relationship
from datetime import datetime
from typing import Optional, List

class User(SQLModel, table=True):
    __tablename__ = "users"

    id: Optional[int] = Field(default=None, primary_key=True)
    email: str = Field(unique=True, index=True, max_length=255)
    hashed_password: str = Field(max_length=255)
    created_at: datetime = Field(default_factory=datetime.utcnow)
    updated_at: datetime = Field(default_factory=datetime.utcnow)

    # Relationship
    tasks: List["Task"] = Relationship(back_populates="user", cascade_delete=True)
```

### Security Considerations

1. **Password Hashing**: Never store passwords in plaintext
   - Use `passlib.hash.bcrypt` with cost factor 12
   - Hash verification on login: `bcrypt.verify(plain_password, hashed_password)`

2. **Email Privacy**: Email addresses are PII (Personally Identifiable Information)
   - Only expose to the authenticated user themselves
   - Never include in public API responses

3. **User Isolation**: All queries must filter by `user_id` from JWT token
   - Example: `SELECT * FROM tasks WHERE user_id = <current_user.id>`

---

## Entity: Task

**Purpose**: Represents a single todo item belonging to a specific user.

### Fields

| Field | Type | Constraints | Description |
|-------|------|-------------|-------------|
| `id` | Integer | PRIMARY KEY, AUTO_INCREMENT | Unique task identifier |
| `user_id` | Integer | FOREIGN KEY → users(id), NOT NULL, INDEX | Owner of this task |
| `title` | String(200) | NOT NULL | Task title (1-200 characters) |
| `description` | String(1000) | NULLABLE | Optional detailed description (0-1000 characters) |
| `status` | String(20) | NOT NULL, DEFAULT 'Incomplete' | Task completion status |
| `created_at` | DateTime | NOT NULL, DEFAULT now() | Task creation timestamp (UTC) |
| `updated_at` | DateTime | NOT NULL, DEFAULT now(), ON UPDATE now() | Last modification timestamp (UTC) |

### Validation Rules

**Title**:
- **Required**: Cannot be null or empty string
- **Length**: 1-200 characters
- **Trimming**: Leading/trailing whitespace removed before save
- **Validation**: Enforced at both API level (Pydantic) and database level (constraint)

**Description**:
- **Optional**: Can be null or empty string
- **Length**: 0-1000 characters if provided
- **Trimming**: Leading/trailing whitespace removed before save
- **Validation**: Enforced at API level (Pydantic)

**Status**:
- **Values**: Enum with two allowed values
  - `"Incomplete"` (default for new tasks)
  - `"Complete"`
- **Case-Sensitive**: Must match exactly (no "complete" or "COMPLETE")
- **Immutability**: Only changeable via toggle endpoint, not general update

**User ID**:
- **Required**: Every task must belong to a user
- **Foreign Key**: Must reference existing user in `users` table
- **Cascade Delete**: When user is deleted, all their tasks are deleted
- **Index**: For fast filtering (`WHERE user_id = X`)

### Indexes

- **PRIMARY INDEX**: `id` (auto-created with PRIMARY KEY)
- **FOREIGN KEY INDEX**: `user_id` (for JOIN performance and filtering)
- **COMPOSITE INDEX**: `(user_id, created_at DESC)` (for sorted task lists per user)

### Relationships

- **User**: Many-to-one relationship with User entity
  - Each task belongs to exactly one user
  - Enforced by foreign key constraint

### SQLModel Example

```python
from sqlmodel import Field, SQLModel, Relationship
from datetime import datetime
from typing import Optional
from enum import Enum

class TaskStatus(str, Enum):
    INCOMPLETE = "Incomplete"
    COMPLETE = "Complete"

class Task(SQLModel, table=True):
    __tablename__ = "tasks"

    id: Optional[int] = Field(default=None, primary_key=True)
    user_id: int = Field(foreign_key="users.id", index=True)
    title: str = Field(min_length=1, max_length=200)
    description: Optional[str] = Field(default=None, max_length=1000)
    status: TaskStatus = Field(default=TaskStatus.INCOMPLETE)
    created_at: datetime = Field(default_factory=datetime.utcnow)
    updated_at: datetime = Field(default_factory=datetime.utcnow)

    # Relationship
    user: User = Relationship(back_populates="tasks")
```

### Business Rules

1. **User Isolation**: Tasks are private to each user
   - A user can only see/modify their own tasks
   - Enforced at API level by filtering `WHERE user_id = current_user.id`
   - Database constraint ensures task cannot exist without valid user

2. **Status Toggle**: Status can only transition between two values
   - `Incomplete` ↔ `Complete`
   - No intermediate states or custom statuses in Phase II

3. **Immutable Creation**: `created_at` never changes after initial creation
   - Provides audit trail for task age
   - Used for default sorting (newest first)

4. **Soft Delete Not Implemented**: Deletion is permanent in Phase II
   - No `deleted_at` field or soft delete pattern
   - User must be certain before deleting

---

## Entity Relationship Diagram

```text
┌─────────────────────┐
│       User          │
├─────────────────────┤
│ id (PK)            │
│ email (UNIQUE)     │
│ hashed_password    │
│ created_at         │
│ updated_at         │
└─────────────────────┘
          │
          │ 1
          │
          │ has many
          │
          │ N
          ▼
┌─────────────────────┐
│       Task          │
├─────────────────────┤
│ id (PK)            │
│ user_id (FK)       │◀─── FOREIGN KEY → users(id)
│ title              │     ON DELETE CASCADE
│ description        │
│ status             │
│ created_at         │
│ updated_at         │
└─────────────────────┘
```

**Relationship**:
- **Type**: One-to-many (1:N)
- **Cardinality**: One user can have zero or more tasks
- **Ownership**: User owns tasks (cascade delete enforced)
- **Directionality**: Bidirectional (User → tasks, Task → user)

---

## Database Constraints

### Foreign Key Constraints

```sql
ALTER TABLE tasks
ADD CONSTRAINT fk_task_user
FOREIGN KEY (user_id) REFERENCES users(id)
ON DELETE CASCADE
ON UPDATE CASCADE;
```

**Behavior**:
- **ON DELETE CASCADE**: When user is deleted, automatically delete all their tasks
- **ON UPDATE CASCADE**: If user.id changes (unlikely), update task.user_id references

### Unique Constraints

```sql
ALTER TABLE users
ADD CONSTRAINT uq_user_email
UNIQUE (email);
```

**Behavior**:
- Prevents duplicate registrations with same email
- Database-level enforcement (in addition to API validation)

### Check Constraints (Optional)

```sql
ALTER TABLE tasks
ADD CONSTRAINT chk_task_title_not_empty
CHECK (LENGTH(TRIM(title)) > 0);

ALTER TABLE tasks
ADD CONSTRAINT chk_task_status_enum
CHECK (status IN ('Incomplete', 'Complete'));
```

**Note**: These are optional - Pydantic validation at API level may be sufficient.

---

## Migration Strategy (Alembic)

### Initial Migration

Create tables in dependency order (users first, then tasks):

```python
# alembic/versions/001_create_users_and_tasks.py

def upgrade():
    # Create users table
    op.create_table(
        'users',
        sa.Column('id', sa.Integer(), primary_key=True),
        sa.Column('email', sa.String(255), unique=True, nullable=False, index=True),
        sa.Column('hashed_password', sa.String(255), nullable=False),
        sa.Column('created_at', sa.DateTime(), server_default=sa.func.now()),
        sa.Column('updated_at', sa.DateTime(), server_default=sa.func.now(), onupdate=sa.func.now()),
    )

    # Create tasks table
    op.create_table(
        'tasks',
        sa.Column('id', sa.Integer(), primary_key=True),
        sa.Column('user_id', sa.Integer(), sa.ForeignKey('users.id', ondelete='CASCADE'), nullable=False, index=True),
        sa.Column('title', sa.String(200), nullable=False),
        sa.Column('description', sa.String(1000), nullable=True),
        sa.Column('status', sa.String(20), server_default='Incomplete', nullable=False),
        sa.Column('created_at', sa.DateTime(), server_default=sa.func.now()),
        sa.Column('updated_at', sa.DateTime(), server_default=sa.func.now(), onupdate=sa.func.now()),
    )

    # Create composite index for efficient task queries
    op.create_index('ix_tasks_user_created', 'tasks', ['user_id', 'created_at'])

def downgrade():
    op.drop_table('tasks')
    op.drop_table('users')
```

---

## Query Patterns

### Common Queries

**Get all tasks for a user (sorted by newest first)**:
```python
async with session:
    statement = select(Task).where(Task.user_id == current_user.id).order_by(Task.created_at.desc())
    results = await session.exec(statement)
    tasks = results.all()
```

**Create new task**:
```python
async with session:
    task = Task(
        user_id=current_user.id,
        title="Buy groceries",
        description="Milk, eggs, bread",
        status=TaskStatus.INCOMPLETE
    )
    session.add(task)
    await session.commit()
    await session.refresh(task)
```

**Toggle task status**:
```python
async with session:
    task = await session.get(Task, task_id)
    if task and task.user_id == current_user.id:
        task.status = TaskStatus.COMPLETE if task.status == TaskStatus.INCOMPLETE else TaskStatus.INCOMPLETE
        task.updated_at = datetime.utcnow()
        await session.commit()
```

**Delete task**:
```python
async with session:
    task = await session.get(Task, task_id)
    if task and task.user_id == current_user.id:
        await session.delete(task)
        await session.commit()
```

---

## Data Integrity Rules

1. **Referential Integrity**: Task.user_id must reference valid User.id (enforced by FK)
2. **Orphan Prevention**: Tasks cannot exist without a user (CASCADE DELETE)
3. **Uniqueness**: Email addresses must be unique across all users
4. **Non-Null Requirements**: Title, user_id, email, hashed_password cannot be null
5. **Enumerated Values**: Task status must be one of two allowed values

---

## Future Extensions (Out of Scope for Phase II)

The following are **NOT** implemented in Phase II but documented for future reference:

1. **Task Priorities**: Add `priority` field (Low/Medium/High)
2. **Due Dates**: Add `due_date` DateTime field with reminder logic
3. **Categories/Tags**: Many-to-many relationship with separate `tags` table
4. **Task Sharing**: Add `shared_with` table for collaborative tasks
5. **Soft Delete**: Add `deleted_at` field for recoverable deletion
6. **Audit Trail**: Add separate `task_history` table for change tracking
7. **Subtasks**: Add self-referencing FK for parent-child task relationships

These features would require schema changes and are explicitly out of scope per the specification.

---

## Summary

**Entities**: 2 (User, Task)
**Relationships**: 1 (User has many Tasks)
**Foreign Keys**: 1 (tasks.user_id → users.id)
**Unique Constraints**: 1 (users.email)
**Indexes**: 3 (users.email, tasks.user_id, tasks.user_id+created_at)

This data model supports all functional requirements from the specification while maintaining simplicity and enforcing data integrity at the database level.
