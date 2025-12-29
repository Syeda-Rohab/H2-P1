# Todo App - Phase II: Full-Stack Web Application

A production-ready multi-user todo application built with Next.js, FastAPI, and PostgreSQL.

## 🎯 Features

1. **User Authentication** - Register, login, logout with JWT tokens
2. **Create Tasks** - Add tasks with title and optional description
3. **View Tasks** - See all your tasks sorted by creation time
4. **Update Tasks** - Edit task title and description
5. **Delete Tasks** - Remove tasks permanently
6. **Toggle Status** - Mark tasks as complete or incomplete

## 🏗️ Architecture

**Monorepo Structure**:
- `backend/` - FastAPI REST API with SQLModel ORM
- `frontend/` - Next.js 14 web application with TypeScript
- `shared/` - Shared TypeScript type definitions
- `docker/` - Docker Compose for local development

**Technology Stack**:
- **Backend**: Python 3.13+, FastAPI, SQLModel, Alembic, JWT authentication
- **Frontend**: Next.js 14, React 18, TypeScript, TailwindCSS, Axios
- **Database**: PostgreSQL 15+ (Neon cloud or Docker local)
- **Development**: UV (Python), npm/pnpm (Node.js), Docker Compose

## 🚀 Quick Start

### Prerequisites

- Python 3.13+ (`python --version`)
- UV package manager (`curl -LsSf https://astral.sh/uv/install.sh | sh`)
- Node.js 18+ (`node --version`)
- npm or pnpm (`npm --version`)
- Docker Desktop (optional, for local PostgreSQL)

### 1. Clone and Setup Database

```bash
# Clone the repository
git clone https://github.com/Syeda-Rohab/H2-P1.git
cd H2-P1
git checkout 001-web-todo-app

# Option A: Use Neon (cloud PostgreSQL)
# 1. Sign up at https://neon.tech
# 2. Create database and copy connection string

# Option B: Use Docker (local PostgreSQL)
cd docker
docker-compose up -d postgres
# Connection: postgresql+asyncpg://todo_user:todo_password@localhost:5432/todo_db
```

### 2. Setup Backend

```bash
cd backend

# Install dependencies
uv sync

# Create .env file
cp .env.example .env
# Edit .env with your DATABASE_URL and JWT_SECRET_KEY

# Run migrations
uv run alembic upgrade head

# Start backend server
uv run uvicorn src.main:app --reload --port 8000
```

Backend running at: **http://localhost:8000**
API docs at: **http://localhost:8000/docs**

### 3. Setup Frontend

```bash
cd frontend

# Install dependencies
npm install
# or: pnpm install

# Create .env.local
cp .env.local.example .env.local
# Edit with NEXT_PUBLIC_API_URL=http://localhost:8000

# Start development server
npm run dev
# or: pnpm dev
```

Frontend running at: **http://localhost:3000**

## 📁 Project Structure

```
├── backend/
│   ├── src/
│   │   ├── models/          # SQLModel entities (User, Task)
│   │   ├── services/        # Business logic
│   │   ├── api/             # FastAPI routes
│   │   ├── core/            # Configuration & security
│   │   ├── db/              # Database setup
│   │   └── main.py          # FastAPI app
│   ├── alembic/             # Database migrations
│   ├── tests/               # Backend tests
│   └── pyproject.toml       # UV dependencies
│
├── frontend/
│   ├── app/                 # Next.js App Router
│   │   ├── login/           # Login page
│   │   ├── register/        # Registration page
│   │   └── dashboard/       # Task dashboard
│   ├── components/          # React components
│   ├── lib/                 # API client & utilities
│   └── types/               # TypeScript types
│
├── shared/
│   └── types/               # Shared TS type definitions
│
└── docker/
    └── docker-compose.yml   # Local development stack
```

## 🧪 Testing

### Backend Tests

```bash
cd backend
uv run pytest tests/ -v
```

### Frontend Tests

```bash
cd frontend
npm run test
```

## 🔧 Development Workflow

### Making Changes

1. **Create feature branch**:
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. **Make changes** - Backend or frontend files auto-reload

3. **Test manually** - Use web UI and API docs

4. **Database migration** (if models changed):
   ```bash
   cd backend
   uv run alembic revision --autogenerate -m "describe change"
   uv run alembic upgrade head
   ```

5. **Commit and push**:
   ```bash
   git add .
   git commit -m "feat: your feature description"
   git push origin feature/your-feature-name
   ```

## 📝 Environment Variables

### Backend (.env)

```env
DATABASE_URL=postgresql+asyncpg://user:pass@host:5432/dbname
JWT_SECRET_KEY=your-super-secret-key-min-32-chars
JWT_ALGORITHM=HS256
ACCESS_TOKEN_EXPIRE_DAYS=7
ALLOWED_ORIGINS=http://localhost:3000
```

### Frontend (.env.local)

```env
NEXT_PUBLIC_API_URL=http://localhost:8000
```

## 🐳 Docker Development

```bash
cd docker
docker-compose up -d

# Services:
# - PostgreSQL: localhost:5432
# - Backend API: localhost:8000
# - Frontend: localhost:3000
```

## 📚 Documentation

- **Specification**: `specs/001-web-todo-app/spec.md`
- **Implementation Plan**: `specs/001-web-todo-app/plan.md`
- **Task Breakdown**: `specs/001-web-todo-app/tasks.md`
- **API Contracts**: `specs/001-web-todo-app/contracts/api-endpoints.md`
- **Data Model**: `specs/001-web-todo-app/data-model.md`
- **Quickstart Guide**: `specs/001-web-todo-app/quickstart.md`

## 🔐 Security

- Passwords hashed with bcrypt (cost factor 12)
- JWT tokens for authentication (7-day expiry)
- User isolation enforced (each user sees only their tasks)
- CORS configured for allowed origins only
- Environment variables for all secrets

## 🎨 UI/UX

- Responsive design (mobile 320px to desktop 1920px)
- TailwindCSS utility-first styling
- Loading states and error handling
- Toast notifications for user feedback
- Optimistic UI updates for instant feedback

## 🚢 Deployment

**Production deployment guide coming soon**

Recommended platforms:
- Frontend: Vercel, Netlify
- Backend: Fly.io, Railway
- Database: Neon (serverless PostgreSQL)

## 📄 License

This is a Phase II evolution of the Todo App project, building upon Phase I (console CLI).

## 👥 Contributors

- Syeda Rohab
- Generated with Claude Code (Sonnet 4.5)

---

**Version**: Phase II - Full-Stack Web
**Status**: ✅ Implementation Complete | Ready for Testing
**Last Updated**: 2025-12-28
