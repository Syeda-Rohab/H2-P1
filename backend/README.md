# Todo Backend - Phase II

FastAPI backend for multi-user todo application with JWT authentication.

## Features

- User registration and authentication with JWT
- Create, read, update, delete (CRUD) tasks
- Task status toggling (Complete/Incomplete)
- User-specific task isolation
- PostgreSQL database with SQLModel ORM
- Async/await throughout

## Tech Stack

- FastAPI (async web framework)
- SQLModel (async ORM)
- PostgreSQL (database)
- Alembic (migrations)
- Pydantic (validation)
- JWT (authentication)
- bcrypt (password hashing)

## Setup

### 1. Install Dependencies

```bash
cd backend
uv sync
```

### 2. Start PostgreSQL Database

```bash
cd docker
docker-compose up -d postgres
```

### 3. Configure Environment

Copy `.env.example` to `.env` and update:

```bash
cp .env.example .env
```

Edit `.env` with your database URL and JWT secret.

### 4. Run Migrations

```bash
cd backend
uv run alembic upgrade head
```

### 5. Start Server

```bash
uv run uvicorn src.main:app --reload --port 8000
```

Server will run at http://localhost:8000

## API Documentation

Once running, visit:
- Swagger UI: http://localhost:8000/docs
- ReDoc: http://localhost:8000/redoc

## API Endpoints

### Authentication
- `POST /api/auth/register` - Register new user
- `POST /api/auth/login` - Login and get JWT token

### Tasks (requires authentication)
- `GET /api/tasks/` - Get all user's tasks
- `POST /api/tasks/` - Create new task
- `GET /api/tasks/{id}` - Get specific task
- `PUT /api/tasks/{id}` - Update task
- `DELETE /api/tasks/{id}` - Delete task
- `POST /api/tasks/{id}/toggle` - Toggle task status

## Project Structure

```
backend/
├── src/
│   ├── api/          # API endpoints
│   ├── core/         # Config and security
│   ├── db/           # Database setup
│   ├── models/       # Database models
│   └── services/     # Business logic
├── alembic/          # Database migrations
└── tests/            # Tests
```

## Development

```bash
# Run tests
uv run pytest

# Format code
uv run black .

# Lint code
uv run ruff check .

# Type check
uv run mypy .
```
