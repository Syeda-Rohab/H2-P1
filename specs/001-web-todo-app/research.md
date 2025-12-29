# Technical Research: Full-Stack Web Todo Application (Phase II)

**Date**: 2025-12-28
**Feature**: Full-Stack Web Todo App
**Purpose**: Document technology decisions and best practices for Phase II implementation

## Overview

This document consolidates research findings for building a multi-user web todo application. All decisions align with constitutional requirements while providing rationale for specific technology choices.

---

## Decision 1: JWT Authentication vs Better Auth

**Context**: Constitution specifies "Better Auth" for Phase II, but Better Auth is primarily designed for cross-service authentication in microservices architectures.

**Decision**: Use native JWT authentication (python-jose + passlib) for Phase II.

**Rationale**:
- **Simplicity**: Phase II is a monolithic application with single backend - no cross-service auth needed
- **Learning Curve**: JWT tokens are industry standard and well-documented
- **Migration Path**: Better Auth can wrap JWT tokens in future phases - current approach is compatible
- **Dependencies**: Fewer external dependencies reduces complexity for educational project
- **Phase Alignment**: Phase II focuses on web fundamentals; Better Auth optimization deferred to Phase III

**Alternatives Considered**:
1. **Better Auth**: Adds cross-service auth features (overkill for monolith), steeper learning curve
2. **OAuth2/OIDC**: Too complex for simple todo app, requires third-party provider
3. **Session-based auth**: Harder to scale, doesn't work well with separate frontend/backend

**Implementation**:
- Libraries: `python-jose[cryptography]` for JWT, `passlib[bcrypt]` for password hashing
- Token Expiry: 7 days (configurable via environment)
- Storage: Client stores JWT in localStorage, includes in Authorization header
- Security: HTTPS only, JWT secret from environment variable

---

## Decision 2: SQLModel ORM

**Context**: Need to choose ORM for PostgreSQL database with type safety and validation.

**Decision**: Use SQLModel (combines SQLAlchemy 2.x + Pydantic v2).

**Rationale**:
- **Type Safety**: Full TypeScript-like type hints in Python with Pydantic
- **Dual Models**: Same class works as both SQLAlchemy model and Pydantic schema
- **Validation**: Automatic request/response validation via Pydantic
- **Async Support**: Built-in async/await with SQLAlchemy 2.x
- **FastAPI Integration**: Designed specifically for FastAPI by same author (Sebastián Ramírez)
- **Migration Path**: Uses Alembic (industry standard) for schema migrations

**Alternatives Considered**:
1. **Raw SQLAlchemy**: More verbose, requires separate Pydantic models for validation
2. **Django ORM**: Tied to Django framework, not compatible with FastAPI
3. **Tortoise ORM**: Less mature, smaller community, fewer features

**Implementation**:
- Models: `User` and `Task` inherit from `SQLModel`
- Relationships: `Task.user_id` foreign key to `User.id`
- Validation: Automatic via Pydantic (title 1-200 chars, description 0-1000 chars)
- Queries: Async using `select()` statements for performance

---

## Decision 3: Next.js App Router Architecture

**Context**: Need to choose frontend framework and routing strategy.

**Decision**: Use Next.js 14+ with App Router (not Pages Router).

**Rationale**:
- **React Server Components**: Improved performance with server-side rendering
- **File-Based Routing**: Intuitive structure (`app/dashboard/page.tsx` → `/dashboard`)
- **Built-in Middleware**: Easy authentication protection per route
- **TypeScript**: First-class TypeScript support out of the box
- **Industry Standard**: Next.js is the most popular React framework (used by Vercel, Netflix, etc.)
- **Future-Proof**: App Router is the recommended approach as of Next.js 13+

**Alternatives Considered**:
1. **Next.js Pages Router**: Legacy approach, missing modern features like Server Components
2. **Vite + React Router**: More configuration needed, no built-in SSR
3. **Create React App**: Deprecated, no longer recommended by React team
4. **Remix**: Great framework but smaller ecosystem than Next.js

**Implementation**:
- Routes: `/login`, `/register`, `/dashboard` as separate directories
- Middleware: Auth protection checks JWT in `middleware.ts`
- Components: Client components for interactivity, Server components for data fetching
- Styling: TailwindCSS for utility-first responsive design

---

## Decision 4: Database Choice - PostgreSQL via Neon or Docker

**Context**: Need reliable relational database with proper constraints and migrations.

**Decision**: PostgreSQL with two deployment options (Neon cloud or local Docker).

**Rationale**:
- **Relational Model**: Todo app requires foreign keys (tasks → users) and constraints
- **ACID Compliance**: Ensures data integrity for user isolation
- **Industry Standard**: PostgreSQL is most popular open-source RDBMS
- **JSON Support**: Can store metadata as JSONB if needed in future
- **Neon Option**: Free tier with serverless PostgreSQL (no local setup)
- **Docker Option**: Full control for local development

**Alternatives Considered**:
1. **MySQL**: Less feature-rich than PostgreSQL, weaker JSON support
2. **SQLite**: File-based, no user permissions, bad for concurrent writes
3. **MongoDB**: NoSQL overkill for simple relational data, no foreign keys

**Implementation**:
- **Neon Setup** (production/easy dev):
  - Sign up at neon.tech, create database
  - Copy connection string to `DATABASE_URL` in .env
  - Automatic backups and scaling

- **Docker Setup** (full control):
  ```yaml
  services:
    postgres:
      image: postgres:16
      environment:
        POSTGRES_DB: todo_db
        POSTGRES_USER: todo_user
        POSTGRES_PASSWORD: secret
      ports:
        - "5432:5432"
  ```

---

## Decision 5: Monorepo Structure with Shared Types

**Context**: Need to coordinate frontend and backend development with type safety.

**Decision**: Monorepo with `/frontend`, `/backend`, `/shared` for TypeScript types.

**Rationale**:
- **Single Source of Truth**: Shared types prevent API contract drift
- **Type Safety**: Frontend knows exact shape of API responses
- **Unified Versioning**: Single git repo ensures frontend/backend stay in sync
- **Simplified Development**: One `git clone`, one PR for full-stack features
- **Constitutional Requirement**: Constitution mandates monorepo for Phase II

**Alternatives Considered**:
1. **Separate Repos**: More complex to keep in sync, no shared types
2. **Backend-Only Types**: Frontend would need to manually duplicate types
3. **Code Generation**: OpenAPI → TypeScript adds build complexity

**Implementation**:
- `/shared/types/`: TypeScript interfaces matching backend SQLModel schemas
- Backend generates types manually (or via script) from Pydantic models
- Frontend imports: `import { Task, User } from '@/../../shared/types'`
- Build process: Shared types compiled before frontend build

---

## Decision 6: Environment-Based Configuration

**Context**: Need secure way to manage secrets and environment-specific settings.

**Decision**: Use `.env` files with `python-dotenv` (backend) and Next.js env vars (frontend).

**Rationale**:
- **Security**: Secrets never committed to git (`.env` in `.gitignore`)
- **Flexibility**: Different configs for dev/staging/production
- **Standard Practice**: Industry standard for 12-factor apps
- **Type Safety**: Pydantic Settings validates required environment variables
- **Constitutional Requirement**: "No hardcoded values" mandate

**Alternatives Considered**:
1. **Config Files**: YAML/JSON files risk accidental commit of secrets
2. **Environment Only**: Hard to document required variables
3. **Vault/Secrets Manager**: Overkill for Phase II, adds deployment complexity

**Implementation**:
- **Backend** (`.env`):
  ```env
  DATABASE_URL=postgresql+asyncpg://user:pass@localhost:5432/db
  JWT_SECRET_KEY=your-secret-key-min-32-chars
  JWT_ALGORITHM=HS256
  ACCESS_TOKEN_EXPIRE_DAYS=7
  ```

- **Frontend** (`.env.local`):
  ```env
  NEXT_PUBLIC_API_URL=http://localhost:8000
  ```

- **Validation**: Pydantic `BaseSettings` raises error if required vars missing

---

## Decision 7: API Design - RESTful Endpoints

**Context**: Need to design API contract between frontend and backend.

**Decision**: RESTful API with standard HTTP methods and JSON payloads.

**Rationale**:
- **Simplicity**: REST is well-understood and widely supported
- **HTTP Semantics**: GET (read), POST (create), PUT (update), DELETE (delete) are intuitive
- **Stateless**: Each request contains full context (JWT token + payload)
- **Tooling**: Easy to test with curl, Postman, or browser DevTools
- **Next.js Compatible**: Built-in `fetch()` works seamlessly

**Alternatives Considered**:
1. **GraphQL**: Overkill for simple CRUD, adds complexity
2. **tRPC**: TypeScript-only, ties frontend to backend language
3. **gRPC**: Binary protocol, harder to debug, not browser-native

**Implementation**:
```text
POST   /api/auth/register      - Create new user account
POST   /api/auth/login         - Get JWT token
POST   /api/auth/logout        - Invalidate token (optional)

GET    /api/tasks              - List all user's tasks
POST   /api/tasks              - Create new task
GET    /api/tasks/{id}         - Get single task (optional)
PUT    /api/tasks/{id}         - Update task
DELETE /api/tasks/{id}         - Delete task
PATCH  /api/tasks/{id}/toggle  - Toggle task status
```

---

## Decision 8: Testing Strategy

**Context**: Need to ensure code quality while maintaining development velocity.

**Decision**: Unit tests for services, integration tests for API endpoints, minimal E2E.

**Rationale**:
- **Fast Feedback**: Unit tests run in milliseconds
- **Backend Focus**: Business logic in services is most critical to test
- **API Contract**: Integration tests verify endpoints match spec
- **Pragmatic**: Skip E2E for Phase II (Playwright/Cypress adds complexity)
- **TDD Compatible**: Write tests alongside implementation

**Alternatives Considered**:
1. **E2E Only**: Too slow, brittle, hard to debug
2. **No Tests**: Risky for multi-user app with auth/isolation
3. **100% Coverage**: Diminishing returns, slows development

**Implementation**:
- **Backend**:
  - Unit: `tests/unit/test_task_service.py` (mock database)
  - Integration: `tests/integration/test_tasks_api.py` (real database)
  - Fixtures: `conftest.py` with test database and sample data

- **Frontend** (optional for Phase II):
  - Component: `tests/components/TaskList.test.tsx`
  - Manual: Test in browser during development

---

## Decision 9: CORS Configuration

**Context**: Frontend (localhost:3000) needs to call backend (localhost:8000) during development.

**Decision**: Configure CORS in FastAPI with allowed origins from environment.

**Rationale**:
- **Development**: Enable localhost:3000 for local frontend development
- **Production**: Restrict to actual frontend domain (e.g., todo-app.com)
- **Security**: Whitelist prevents unauthorized origins from calling API
- **Standard Practice**: CORS is the browser standard for cross-origin requests

**Alternatives Considered**:
1. **Proxy Through Frontend**: Next.js can proxy API calls, but hides real architecture
2. **Allow All Origins**: Security risk, defeats CORS purpose
3. **No CORS**: Won't work - browser enforces same-origin policy

**Implementation**:
```python
from fastapi.middleware.cors import CORSMiddleware

app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.ALLOWED_ORIGINS,  # ["http://localhost:3000"]
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
```

---

## Decision 10: Alembic for Database Migrations

**Context**: Need version control for database schema changes.

**Decision**: Use Alembic for SQLAlchemy migration management.

**Rationale**:
- **Industry Standard**: Default migration tool for SQLAlchemy
- **Version Control**: Each migration is a file committed to git
- **Rollback Support**: Can revert schema changes safely
- **Team Coordination**: Prevents schema drift between developers
- **Production Ready**: Safe to run migrations on live databases

**Alternatives Considered**:
1. **Manual SQL**: Error-prone, no version tracking
2. **SQLModel Built-in**: Doesn't have migration support (just create_all)
3. **Flyway/Liquibase**: Java-centric, more complex

**Implementation**:
```bash
# Create migration
alembic revision --autogenerate -m "create users and tasks tables"

# Apply migration
alembic upgrade head

# Rollback
alembic downgrade -1
```

---

## Summary of Technology Stack

**Frontend**:
- Next.js 14+ (App Router)
- React 18+
- TypeScript 5.x
- TailwindCSS 3.x
- Axios for HTTP client

**Backend**:
- Python 3.13+
- FastAPI
- SQLModel (SQLAlchemy 2.x + Pydantic v2)
- Alembic (migrations)
- python-jose (JWT)
- passlib (password hashing)
- asyncpg (PostgreSQL driver)

**Database**:
- PostgreSQL 15+ (Neon cloud or Docker)

**Development**:
- UV (Python package manager)
- npm/pnpm (Node package manager)
- Docker Compose (local services)
- pytest (backend testing)
- Jest + React Testing Library (frontend testing - optional)

**Deployment**:
- Docker containers (backend + frontend)
- Environment variables for secrets
- Neon PostgreSQL (managed database)

---

## Next Steps

1. ✅ Research complete - all decisions documented
2. → Create `data-model.md` with User and Task entities
3. → Create `contracts/api-endpoints.md` with REST API specification
4. → Create `quickstart.md` with development setup guide
5. → Generate tasks with `/sp.tasks` command
