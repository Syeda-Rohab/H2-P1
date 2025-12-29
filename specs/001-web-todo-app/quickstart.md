# Quickstart Guide: Full-Stack Web Todo Application (Phase II)

**Date**: 2025-12-28
**Feature**: Full-Stack Web Todo App
**Purpose**: Get the development environment running in under 15 minutes

## Prerequisites

Before starting, ensure you have the following installed:

- **Python 3.13+** (check: `python --version`)
- **UV package manager** (install: `curl -LsSf https://astral.sh/uv/install.sh | sh`)
- **Node.js 18+** (check: `node --version`)
- **npm or pnpm** (check: `npm --version` or `pnpm --version`)
- **Docker Desktop** (optional, for local PostgreSQL): https://www.docker.com/products/docker-desktop/
- **Git** (check: `git --version`)

---

## Quick Start (3 Steps)

### Step 1: Clone and Setup Database

```bash
# Clone the repository
git clone https://github.com/Syeda-Rohab/H2-P1.git
cd H2-P1

# Checkout Phase II branch
git checkout 001-web-todo-app

# Option A: Use Neon (cloud PostgreSQL - easiest)
# 1. Sign up at https://neon.tech (free tier)
# 2. Create a new database
# 3. Copy the connection string

# Option B: Use Docker (local PostgreSQL)
cd docker
docker-compose up -d postgres
# Connection string: postgresql+asyncpg://todo_user:todo_password@localhost:5432/todo_db
```

### Step 2: Setup Backend

```bash
cd backend

# Create .env file
cp .env.example .env

# Edit .env with your database URL and secrets
# DATABASE_URL=postgresql+asyncpg://user:password@localhost:5432/todo_db
# JWT_SECRET_KEY=your-secret-key-at-least-32-characters-long
# JWT_ALGORITHM=HS256
# ACCESS_TOKEN_EXPIRE_DAYS=7

# Install dependencies with UV
uv sync

# Run database migrations
uv run alembic upgrade head

# Start the backend server
uv run uvicorn src.main:app --reload --port 8000
```

Backend should now be running at **http://localhost:8000**
API docs available at **http://localhost:8000/docs**

### Step 3: Setup Frontend

```bash
# Open a new terminal
cd frontend

# Create .env.local file
cp .env.local.example .env.local

# Edit .env.local
# NEXT_PUBLIC_API_URL=http://localhost:8000

# Install dependencies
npm install
# or: pnpm install

# Start the development server
npm run dev
# or: pnpm dev
```

Frontend should now be running at **http://localhost:3000**

---

## Detailed Setup Instructions

### 1. Database Setup (Neon Cloud)

**Why Neon**: Free tier, no local setup, automatic backups, fast.

1. **Sign Up**:
   - Go to https://neon.tech
   - Sign up with GitHub or email
   - Create a new project

2. **Create Database**:
   - Project name: "todo-app-phase2"
   - PostgreSQL version: 16
   - Region: Choose closest to you

3. **Get Connection String**:
   - Click "Connection string"
   - Copy the string (looks like: `postgresql://user:pass@ep-xxx.neon.tech/neondb`)
   - **Important**: Change `postgresql://` to `postgresql+asyncpg://` for async support

4. **Add to Backend .env**:
   ```env
   DATABASE_URL=postgresql+asyncpg://user:pass@ep-xxx.neon.tech/neondb?sslmode=require
   ```

### 2. Database Setup (Local Docker)

**Why Docker**: Full control, works offline, no cloud account needed.

1. **Create docker-compose.yml** (already in `/docker` directory):
   ```yaml
   version: '3.8'

   services:
     postgres:
       image: postgres:16
       container_name: todo-postgres
       environment:
         POSTGRES_DB: todo_db
         POSTGRES_USER: todo_user
         POSTGRES_PASSWORD: todo_password
       ports:
         - "5432:5432"
       volumes:
         - postgres_data:/var/lib/postgresql/data

   volumes:
     postgres_data:
   ```

2. **Start PostgreSQL**:
   ```bash
   cd docker
   docker-compose up -d postgres
   ```

3. **Verify it's running**:
   ```bash
   docker ps
   # Should show todo-postgres container
   ```

4. **Add to Backend .env**:
   ```env
   DATABASE_URL=postgresql+asyncpg://todo_user:todo_password@localhost:5432/todo_db
   ```

### 3. Backend Setup (Detailed)

#### Install UV (if not already installed)

**macOS/Linux**:
```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

**Windows**:
```powershell
powershell -c "irm https://astral.sh/uv/install.ps1 | iex"
```

#### Initialize Backend Project

```bash
cd backend

# UV will create a virtual environment and install dependencies
uv sync
```

#### Environment Variables

Create `backend/.env`:

```env
# Database
DATABASE_URL=postgresql+asyncpg://user:pass@host:5432/dbname

# JWT Configuration
JWT_SECRET_KEY=your-super-secret-key-at-least-32-characters-for-security
JWT_ALGORITHM=HS256
ACCESS_TOKEN_EXPIRE_DAYS=7

# CORS (comma-separated origins)
ALLOWED_ORIGINS=http://localhost:3000,http://127.0.0.1:3000

# Server
APP_NAME=Todo API
DEBUG=True
```

**Generate JWT Secret** (Linux/macOS):
```bash
openssl rand -hex 32
```

**Generate JWT Secret** (Python):
```python
import secrets
print(secrets.token_urlsafe(32))
```

#### Database Migrations

```bash
# Create initial migration (only needed once)
uv run alembic revision --autogenerate -m "create users and tasks tables"

# Apply migrations
uv run alembic upgrade head

# Verify tables created
uv run python -c "from src.db.session import engine; from sqlmodel import inspect; print(inspect(engine).get_table_names())"
```

#### Run Backend Server

```bash
# Development mode (auto-reload on file changes)
uv run uvicorn src.main:app --reload --port 8000

# Alternative: using the main.py script
uv run python src/main.py
```

**Verify Backend**:
- Open http://localhost:8000
- Should see: `{"message": "Todo API - Phase II"}`
- Open http://localhost:8000/docs
- Should see: Interactive API documentation (Swagger UI)

### 4. Frontend Setup (Detailed)

#### Install Node.js Dependencies

```bash
cd frontend

# Using npm
npm install

# Or using pnpm (faster, recommended)
npm install -g pnpm
pnpm install
```

#### Environment Variables

Create `frontend/.env.local`:

```env
# Backend API URL
NEXT_PUBLIC_API_URL=http://localhost:8000

# Optional: Enable debug mode
NEXT_PUBLIC_DEBUG=true
```

**Important**: Variables starting with `NEXT_PUBLIC_` are exposed to the browser.

#### Run Frontend Server

```bash
# Development mode (hot reload)
npm run dev
# or: pnpm dev

# Runs on http://localhost:3000
```

**Verify Frontend**:
- Open http://localhost:3000
- Should see: Landing page with "Login" and "Register" links
- No console errors in browser DevTools

---

## Testing the Application

### 1. Test Registration Flow

**Using the Web UI**:
1. Open http://localhost:3000/register
2. Enter email: `test@example.com`
3. Enter password: `password123`
4. Click "Register"
5. Should redirect to `/dashboard` with JWT token stored

**Using curl**:
```bash
curl -X POST http://localhost:8000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{"email": "test@example.com", "password": "password123"}'
```

**Expected Response**:
```json
{
  "id": 1,
  "email": "test@example.com",
  "created_at": "2025-12-28T12:00:00Z",
  "access_token": "eyJhbGc...",
  "token_type": "bearer"
}
```

### 2. Test Login Flow

**Using the Web UI**:
1. Open http://localhost:3000/login
2. Enter email: `test@example.com`
3. Enter password: `password123`
4. Click "Login"
5. Should redirect to `/dashboard`

**Using curl**:
```bash
curl -X POST http://localhost:8000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email": "test@example.com", "password": "password123"}'
```

### 3. Test Task Creation

**Using the Web UI**:
1. From `/dashboard`, click "Add Task"
2. Enter title: "Buy groceries"
3. Enter description: "Milk, eggs, bread"
4. Click "Create"
5. Task should appear in the task list

**Using curl** (replace `<token>` with JWT from login):
```bash
TOKEN="<your-jwt-token>"

curl -X POST http://localhost:8000/api/tasks \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{"title": "Buy groceries", "description": "Milk, eggs, bread"}'
```

### 4. Test Task Operations

**View all tasks**:
```bash
curl -X GET http://localhost:8000/api/tasks \
  -H "Authorization: Bearer $TOKEN"
```

**Toggle task status**:
```bash
curl -X PATCH http://localhost:8000/api/tasks/1/toggle \
  -H "Authorization: Bearer $TOKEN"
```

**Update task**:
```bash
curl -X PUT http://localhost:8000/api/tasks/1 \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{"title": "Buy groceries and cook dinner"}'
```

**Delete task**:
```bash
curl -X DELETE http://localhost:8000/api/tasks/1 \
  -H "Authorization: Bearer $TOKEN"
```

---

## Troubleshooting

### Backend Issues

**Problem**: `ModuleNotFoundError: No module named 'fastapi'`
**Solution**: Install dependencies with `uv sync` in the `backend/` directory

**Problem**: `sqlalchemy.exc.OperationalError: could not connect to database`
**Solution**:
- Check DATABASE_URL in `.env`
- Verify PostgreSQL is running (`docker ps` or check Neon dashboard)
- Ensure database exists and credentials are correct

**Problem**: `alembic.util.exc.CommandError: Target database is not up to date`
**Solution**: Run `uv run alembic upgrade head`

**Problem**: `401 Unauthorized` on all API calls
**Solution**:
- Check JWT token is included in Authorization header
- Verify JWT_SECRET_KEY matches between registration and login
- Token may have expired (check ACCESS_TOKEN_EXPIRE_DAYS)

### Frontend Issues

**Problem**: `Error: connect ECONNREFUSED 127.0.0.1:8000`
**Solution**:
- Ensure backend is running on port 8000
- Check NEXT_PUBLIC_API_URL in `.env.local`

**Problem**: CORS error in browser console
**Solution**:
- Verify ALLOWED_ORIGINS in backend `.env` includes `http://localhost:3000`
- Restart backend server after changing CORS settings

**Problem**: "Failed to fetch" on API calls
**Solution**:
- Open browser DevTools → Network tab
- Check if API requests are reaching the backend
- Verify response status codes and error messages

### Database Issues

**Problem**: Docker PostgreSQL won't start
**Solution**:
```bash
# Stop all containers
docker-compose down

# Remove volumes and start fresh
docker-compose down -v
docker-compose up -d postgres
```

**Problem**: Neon connection timeout
**Solution**:
- Check your internet connection
- Verify connection string includes `?sslmode=require`
- Try pinging Neon host: `ping ep-xxx.neon.tech`

---

## Development Workflow

### Making Changes

1. **Create a new branch**:
   ```bash
   git checkout -b feature/add-task-priorities
   ```

2. **Make code changes**:
   - Backend changes: Modify files in `backend/src/`
   - Frontend changes: Modify files in `frontend/src/`
   - Both servers auto-reload on file save

3. **Test manually**:
   - Use web UI to verify changes
   - Use API docs (http://localhost:8000/docs) to test endpoints

4. **Create database migration** (if models changed):
   ```bash
   cd backend
   uv run alembic revision --autogenerate -m "add priority field"
   uv run alembic upgrade head
   ```

5. **Commit and push**:
   ```bash
   git add .
   git commit -m "feat: add task priority field"
   git push origin feature/add-task-priorities
   ```

### Running Tests

**Backend tests** (when implemented):
```bash
cd backend
uv run pytest tests/
```

**Frontend tests** (when implemented):
```bash
cd frontend
npm run test
# or: pnpm test
```

---

## Deployment (Future)

Phase II focuses on local development. Deployment to production will be covered in a separate guide. Recommended platforms:

- **Frontend**: Vercel, Netlify, or AWS Amplify
- **Backend**: Fly.io, Railway, or AWS ECS
- **Database**: Neon (already cloud-hosted)

---

## Next Steps

Once the application is running:

1. **Familiarize with the codebase**:
   - Read `backend/src/main.py` (FastAPI app setup)
   - Read `frontend/src/app/dashboard/page.tsx` (main UI)
   - Explore API docs at http://localhost:8000/docs

2. **Review the specification**:
   - Read `specs/001-web-todo-app/spec.md`
   - Understand user stories and acceptance criteria

3. **Check the planning artifacts**:
   - `specs/001-web-todo-app/plan.md` - Implementation plan
   - `specs/001-web-todo-app/data-model.md` - Database schema
   - `specs/001-web-todo-app/contracts/api-endpoints.md` - API documentation

4. **Start implementation**:
   - Run `/sp.tasks` to generate task breakdown
   - Run `/sp.implement` to begin feature implementation

---

## Summary

**Total Setup Time**: ~10-15 minutes

**Servers Running**:
- Backend API: http://localhost:8000
- Frontend UI: http://localhost:3000
- API Docs: http://localhost:8000/docs
- PostgreSQL: localhost:5432 (Docker) or Neon cloud

**Key Files**:
- `backend/.env` - Backend configuration
- `frontend/.env.local` - Frontend configuration
- `docker/docker-compose.yml` - Local PostgreSQL setup

**Useful Commands**:
```bash
# Backend
cd backend && uv run uvicorn src.main:app --reload

# Frontend
cd frontend && npm run dev

# Database migrations
cd backend && uv run alembic upgrade head

# Docker PostgreSQL
cd docker && docker-compose up -d postgres
```

Ready to build! 🚀
