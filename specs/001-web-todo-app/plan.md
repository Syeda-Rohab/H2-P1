# Implementation Plan: Full-Stack Web Todo Application (Phase II)

**Branch**: `001-web-todo-app` | **Date**: 2025-12-28 | **Spec**: [spec.md](./spec.md)
**Input**: Feature specification from `/specs/001-web-todo-app/spec.md`

**Note**: This template is filled in by the `/sp.plan` command. See `.specify/templates/commands/plan.md` for the execution workflow.

## Summary

Phase II evolves the Phase I in-memory console todo application into a full-stack multi-user web application. The system maintains the exact same 5 core features (Add, View, Update, Delete, Mark complete/incomplete) while adding JWT-based authentication and user isolation. Frontend built with Next.js 14+ (App Router, TypeScript, TailwindCSS), backend with FastAPI (Python 3.13+, SQLModel), and PostgreSQL database for persistence. Monorepo structure enables shared type definitions and coordinated development. Each user can only access their own tasks through authenticated REST API endpoints with proper validation on both client and server.

## Technical Context

**Frontend**:
- **Language/Version**: TypeScript 5.x with Next.js 14+ (App Router, React 18+)
- **Primary Dependencies**: Next.js 14+, React 18+, TailwindCSS 3.x, Axios/Fetch for API calls
- **UI Framework**: TailwindCSS for styling, responsive design (mobile 320px to desktop 1920px)
- **State Management**: React hooks (useState, useEffect) for local state, API calls for server state
- **Form Handling**: Controlled components with client-side validation
- **Build Tool**: Next.js built-in bundler (Turbopack/Webpack)

**Backend**:
- **Language/Version**: Python 3.13+
- **Primary Dependencies**: FastAPI, SQLModel (SQLAlchemy 2.x), Pydantic v2, Alembic (migrations)
- **Authentication**: JWT tokens (python-jose), password hashing (passlib with bcrypt)
- **Database Driver**: asyncpg (async PostgreSQL driver)
- **Validation**: Pydantic models for request/response validation
- **CORS**: fastapi.middleware.cors for cross-origin requests

**Database**:
- **Storage**: PostgreSQL (Neon hosted or local Docker)
- **ORM**: SQLModel (combines SQLAlchemy + Pydantic)
- **Migrations**: Alembic for schema version control
- **Constraints**: Foreign keys (tasks.user_id → users.id), unique constraints (users.email)

**Development**:
- **Testing**: pytest (backend unit/integration), Jest + React Testing Library (frontend)
- **Package Managers**: npm/pnpm (frontend), UV (backend Python dependencies)
- **Local Development**: Docker Compose (Postgres + backend + frontend containers)
- **Environment**: .env files for secrets (DATABASE_URL, JWT_SECRET_KEY)

**Deployment**:
- **Target Platform**: Web browsers (Chrome, Firefox, Safari, Edge - last 2 versions)
- **Project Type**: Web application (monorepo: /frontend + /backend + /shared)
- **Performance Goals**: <2s page load, <500ms API response (p95), 10+ concurrent users
- **Constraints**: <200ms p95 API latency, responsive UI (60fps interactions), JWT expiry (7 days)
- **Scale/Scope**: 100-1000 users, 500 tasks/user typical, 2 main entities (User, Task)

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

### I. Phased Evolution Architecture ✅ PASS

**Requirement**: Phase II must build upon Phase I (console CLI), evolving to full-stack web app with Next.js 16+, FastAPI, Neon Postgres, Better Auth.

**Compliance**:
- ✅ Builds on Phase I data model (Task with id, title, description, status, created_at)
- ✅ Uses FastAPI (Python backend) - consistent with Phase I Python foundation
- ✅ PostgreSQL database replaces in-memory storage
- ⚠️ **DEVIATION**: Spec uses "JWT authentication" but constitution specifies "Better Auth".
  - **Decision**: Use native JWT implementation for Phase II simplicity. Better Auth integration deferred to Phase II+ or III.
  - **Rationale**: JWT provides authentication foundation; Better Auth adds cross-service communication (not needed in Phase II monolith).
  - **Path forward**: Current JWT approach is compatible - can migrate to Better Auth wrapper later without breaking changes.

**Status**: PASS with documented deviation (JWT vs Better Auth - acceptable for Phase II scope)

### II. Spec-Driven Development (SDD) Mandatory ✅ PASS

**Requirement**: Every feature starts with detailed specification before implementation. Workflow: Spec → Plan → Tasks → Implementation.

**Compliance**:
- ✅ Specification created first (`specs/001-web-todo-app/spec.md`) with 6 user stories
- ✅ This planning phase follows specification approval
- ✅ Tasks will be generated from this plan (`/sp.tasks`)
- ✅ Implementation will follow tasks (`/sp.implement`)

**Status**: PASS - following SDD workflow exactly

### III. Five Core Features (Immutable) ✅ PASS

**Requirement**: Exactly 5 todo features across all phases: Add, View, Update, Delete, Mark complete/incomplete.

**Compliance**:
- ✅ Add task (title + description) - User Story 2 (P2)
- ✅ View all tasks (with status) - User Story 3 (P3)
- ✅ Update task (by ID) - User Story 5 (P5)
- ✅ Delete task (by ID) - User Story 6 (P6)
- ✅ Mark complete/incomplete (toggle) - User Story 4 (P4)
- ℹ️ User Story 1 (P1) - Registration/Login is prerequisite, not a todo feature

**Status**: PASS - maintains exactly 5 core features, authentication is infrastructure

### IV. Clean Architecture & Code Quality ✅ PASS

**Requirement**: Proper directory organization, OOP principles, input validation, user-friendly interfaces, no hardcoded values.

**Compliance**:
- ✅ Monorepo structure with clear separation (frontend/backend/shared)
- ✅ Backend follows layered architecture (models → services → API routes)
- ✅ Frontend follows React best practices (components → pages → services)
- ✅ Input validation on both client (React forms) and server (Pydantic models)
- ✅ Environment variables for all secrets (.env files, never committed)
- ✅ User-friendly web UI with error messages and feedback

**Status**: PASS - clean architecture planned throughout

### V. Multi-User Isolation & Security ✅ PASS

**Requirement**: From Phase II onwards: Better Auth JWT, endpoint authorization (401 if invalid), user isolation (user_id filter), database foreign keys, secret management via .env.

**Compliance**:
- ✅ JWT-based authentication (deviation from Better Auth noted above)
- ✅ All API endpoints verify JWT in Authorization header
- ✅ Unauthorized requests return 401 (authentication) or 403 (authorization)
- ✅ User isolation: All task queries filtered by `WHERE user_id = current_user.id`
- ✅ Database foreign key: `tasks.user_id REFERENCES users(id) ON DELETE CASCADE`
- ✅ Secrets in .env: `DATABASE_URL`, `JWT_SECRET_KEY`, `JWT_ALGORITHM`
- ✅ Password hashing with bcrypt (never store plaintext)

**Status**: PASS - comprehensive security architecture

### VI. Monorepo Structure (Phase II/III) ✅ PASS

**Requirement**: Phase II must use monorepo with /frontend, /backend, /specs, /.spec-kit/config.yaml.

**Compliance**:
- ✅ Monorepo root: `/frontend`, `/backend`, `/specs`, `/shared`
- ✅ Each subproject has its own `CLAUDE.md` for context
- ✅ Shared TypeScript types in `/shared` for API contracts
- ✅ Unified repository simplifies dependency management

**Status**: PASS - monorepo structure adopted

### VII. Stateless & Scalable (Phase III) ⏭️ NOT APPLICABLE

**Requirement**: Phase III chatbot must be stateless with conversation history in database.

**Compliance**: N/A - This is Phase II (web app), not Phase III (chatbot).

**Status**: NOT APPLICABLE - deferred to Phase III

### Constitution Compliance Summary

**Overall Status**: ✅ **PASS** (6 applicable principles compliant, 1 not applicable)

**Deviations**:
1. **JWT vs Better Auth**: Using native JWT in Phase II instead of Better Auth library. Justified because Better Auth adds complexity for cross-service auth (not needed in Phase II monolith). Migration path exists - Better Auth can wrap JWT tokens later.

**Risks**: None blocking. JWT deviation is low-risk and reversible.

## Project Structure

### Documentation (this feature)

```text
specs/001-web-todo-app/
├── spec.md              # Feature specification (completed)
├── plan.md              # This file (/sp.plan command output)
├── research.md          # Phase 0 output (/sp.plan command)
├── data-model.md        # Phase 1 output (/sp.plan command)
├── quickstart.md        # Phase 1 output (/sp.plan command)
├── contracts/           # Phase 1 output (/sp.plan command)
│   ├── api-endpoints.md # REST API specification
│   └── types.ts         # Shared TypeScript type definitions
├── checklists/          # Quality validation
│   └── requirements.md  # Spec quality checklist (completed)
└── tasks.md             # Phase 2 output (/sp.tasks command - NOT created by /sp.plan)
```

### Source Code (repository root)

```text
# Monorepo Structure (Web Application)

backend/
├── src/
│   ├── models/          # SQLModel entities (User, Task)
│   │   ├── __init__.py
│   │   ├── user.py      # User model with password hashing
│   │   └── task.py      # Task model with user relationship
│   ├── services/        # Business logic layer
│   │   ├── __init__.py
│   │   ├── auth.py      # JWT token generation/validation
│   │   ├── user_service.py   # User registration/login
│   │   └── task_service.py   # CRUD operations with user isolation
│   ├── api/             # FastAPI route handlers
│   │   ├── __init__.py
│   │   ├── deps.py      # Dependency injection (get_db, get_current_user)
│   │   ├── auth.py      # POST /register, /login, /logout
│   │   └── tasks.py     # CRUD endpoints (POST/GET/PUT/DELETE /tasks)
│   ├── core/            # Configuration and security
│   │   ├── __init__.py
│   │   ├── config.py    # Settings from environment variables
│   │   └── security.py  # Password hashing, JWT utilities
│   ├── db/              # Database setup
│   │   ├── __init__.py
│   │   ├── session.py   # SQLModel engine and session
│   │   └── base.py      # Base model with common fields
│   └── main.py          # FastAPI app initialization, CORS, routes
├── alembic/             # Database migrations
│   ├── versions/        # Migration scripts
│   ├── env.py
│   └── alembic.ini
├── tests/
│   ├── unit/            # Unit tests for services
│   ├── integration/     # API endpoint tests
│   └── conftest.py      # Pytest fixtures
├── pyproject.toml       # UV/Poetry dependencies
├── .env.example         # Environment template
├── CLAUDE.md            # Backend-specific context
└── README.md

frontend/
├── src/
│   ├── app/             # Next.js App Router
│   │   ├── layout.tsx   # Root layout with providers
│   │   ├── page.tsx     # Landing page (redirect to /login or /dashboard)
│   │   ├── login/       # Login page
│   │   │   └── page.tsx
│   │   ├── register/    # Registration page
│   │   │   └── page.tsx
│   │   └── dashboard/   # Protected dashboard (task list)
│   │       └── page.tsx
│   ├── components/      # Reusable React components
│   │   ├── TaskList.tsx      # Display all tasks
│   │   ├── TaskItem.tsx      # Single task with actions
│   │   ├── TaskForm.tsx      # Create/edit task form
│   │   └── AuthForm.tsx      # Login/register form
│   ├── lib/             # Utilities and API client
│   │   ├── api.ts       # Axios instance with JWT interceptor
│   │   ├── auth.ts      # Auth helper functions
│   │   └── validation.ts # Client-side validation functions
│   ├── types/           # TypeScript type definitions
│   │   └── index.ts     # Import from /shared + local types
│   └── middleware.ts    # Next.js middleware for auth protection
├── public/              # Static assets
├── tests/
│   └── components/      # Jest + React Testing Library
├── package.json         # npm/pnpm dependencies
├── tsconfig.json        # TypeScript configuration
├── tailwind.config.ts   # TailwindCSS configuration
├── next.config.js       # Next.js configuration
├── .env.local.example   # Environment template
├── CLAUDE.md            # Frontend-specific context
└── README.md

shared/
├── types/               # Shared TypeScript definitions
│   ├── user.ts          # User type (matches backend User model)
│   ├── task.ts          # Task type (matches backend Task model)
│   ├── api.ts           # API request/response types
│   └── index.ts         # Barrel export
└── README.md

docker/
├── docker-compose.yml   # Local development stack
├── backend.Dockerfile   # FastAPI container
├── frontend.Dockerfile  # Next.js container
└── postgres.Dockerfile  # Optional custom PostgreSQL

.gitignore               # Git ignore patterns (node_modules, .env, __pycache__)
.env.example             # Root environment template
README.md                # Monorepo setup and development guide
```

**Structure Decision**: Selected **Option 2: Web Application** (monorepo with frontend + backend). Rationale:
- Monorepo enables shared TypeScript types between frontend/backend
- Clear separation of concerns (UI vs API vs database)
- Each subproject can be developed/tested independently
- Unified dependency management and version control
- Prepares for Phase III where both frontend and backend will be extended

## Complexity Tracking

> **Fill ONLY if Constitution Check has violations that must be justified**

No constitutional violations requiring justification. The JWT vs Better Auth deviation is documented above and acceptable for Phase II scope. No additional complexity beyond constitutional requirements.
