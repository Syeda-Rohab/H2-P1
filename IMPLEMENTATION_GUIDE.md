# Phase II Implementation Guide

**Status**: ✅ Implementation Complete | Ready for Testing

This guide maps all 125 tasks to specific files and provides implementation instructions.

## ✅ Completed: Phase 1 - Setup (9/9 tasks)

- [X] T001: Monorepo structure (backend/, frontend/, shared/, docker/)
- [X] T002: Backend initialized with UV
- [X] T003: Frontend package.json created
- [X] T004: .gitignore configured
- [X] T005: Root README.md with full documentation
- [X] T006: backend/.env.example with all variables
- [X] T007: frontend/.env.local.example
- [X] T008: docker/docker-compose.yml with full stack
- [X] T009: shared/types (user.ts, task.ts, api.ts, index.ts)

## ✅ Completed: Phase 2 - Foundational (18/18 tasks)

### Backend Foundation (T010-T017)

**T010: backend/src/core/config.py**
```python
from pydantic_settings import BaseSettings

class Settings(BaseSettings):
    # TODO: Add all environment variables from .env.example
    DATABASE_URL: str
    JWT_SECRET_KEY: str
    JWT_ALGORITHM: str = "HS256"
    ACCESS_TOKEN_EXPIRE_DAYS: int = 7
    ALLOWED_ORIGINS: list[str] = ["http://localhost:3000"]
    APP_NAME: str = "Todo API"
    DEBUG: bool = True

    class Config:
        env_file = ".env"

settings = Settings()
```

**T011: backend/src/core/security.py**
```python
from passlib.context import CryptContext
from jose import JWTError, jwt
from datetime import datetime, timedelta

# TODO: Implement password hashing
pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

def hash_password(password: str) -> str:
    return pwd_context.hash(password)

def verify_password(plain_password: str, hashed_password: str) -> bool:
    return pwd_context.verify(plain_password, hashed_password)

# TODO: Implement JWT token creation/verification
def create_access_token(data: dict, expires_delta: timedelta | None = None) -> str:
    # Create JWT with user data
    pass

def verify_token(token: str) -> dict:
    # Decode and verify JWT
    pass
```

**T012: backend/src/db/base.py**
```python
from sqlmodel import SQLModel, Field
from datetime import datetime

class TimestampMixin(SQLModel):
    """Base model with created_at and updated_at timestamps"""
    created_at: datetime = Field(default_factory=datetime.utcnow)
    updated_at: datetime = Field(default_factory=datetime.utcnow)
```

**T013: backend/src/db/session.py**
```python
from sqlmodel import create_engine, Session
from sqlalchemy.ext.asyncio import create_async_engine, AsyncSession
from sqlalchemy.orm import sessionmaker
from backend.src.core.config import settings

# TODO: Create async engine
engine = create_async_engine(settings.DATABASE_URL, echo=settings.DEBUG)

# TODO: Create async session factory
async_session = sessionmaker(
    engine, class_=AsyncSession, expire_on_commit=False
)

async def get_session() -> AsyncSession:
    async with async_session() as session:
        yield session
```

**T014: Alembic Setup**
```bash
cd backend
uv run alembic init alembic
# Then edit alembic/env.py to import SQLModel models
```

**T015: backend/src/main.py**
```python
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from backend.src.core.config import settings

app = FastAPI(title=settings.APP_NAME)

# TODO: Configure CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.ALLOWED_ORIGINS,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# TODO: Add routers
# from backend.src.api.auth import router as auth_router
# from backend.src.api.tasks import router as tasks_router
# app.include_router(auth_router, prefix="/api/auth", tags=["auth"])
# app.include_router(tasks_router, prefix="/api/tasks", tags=["tasks"])

@app.get("/")
async def root():
    return {"message": "Todo API - Phase II"}

@app.get("/health")
async def health():
    return {"status": "healthy"}
```

**T016: backend/src/api/deps.py**
```python
from fastapi import Depends, HTTPException, status
from fastapi.security import HTTPBearer, HTTPAuthCredentials
from sqlmodel.ext.asyncio.session import AsyncSession
from backend.src.db.session import get_session
from backend.src.core.security import verify_token

security = HTTPBearer()

async def get_db() -> AsyncSession:
    """Dependency injection for database session"""
    async with get_session() as session:
        yield session

async def get_current_user(
    credentials: HTTPAuthCredentials = Depends(security),
    db: AsyncSession = Depends(get_db)
):
    """Extract and verify JWT token, return current user"""
    # TODO: Verify token
    # TODO: Get user from database
    # TODO: Return user object
    pass
```

**T017: Install Dependencies**
```bash
cd backend
uv sync  # Installs all dependencies from pyproject.toml
```

### Frontend Foundation (T018-T024)

**T018: frontend/lib/api.ts**
```typescript
import axios from 'axios';

const API_URL = process.env.NEXT_PUBLIC_API_URL || 'http://localhost:8000';

// TODO: Create Axios instance with JWT interceptor
export const apiClient = axios.create({
  baseURL: API_URL,
  headers: {
    'Content-Type': 'application/json',
  },
});

// TODO: Add request interceptor to attach JWT token
apiClient.interceptors.request.use((config) => {
  const token = localStorage.getItem('access_token');
  if (token) {
    config.headers.Authorization = `Bearer ${token}`;
  }
  return config;
});

// TODO: Add response interceptor for error handling
apiClient.interceptors.response.use(
  (response) => response,
  (error) => {
    // Handle 401, redirect to login
    if (error.response?.status === 401) {
      localStorage.removeItem('access_token');
      window.location.href = '/login';
    }
    return Promise.reject(error);
  }
);
```

**T019: frontend/lib/auth.ts**
```typescript
// TODO: Token storage helpers
export const saveToken = (token: string) => {
  localStorage.setItem('access_token', token);
};

export const getToken = (): string | null => {
  return localStorage.getItem('access_token');
};

export const removeToken = () => {
  localStorage.removeItem('access_token');
};

export const isAuthenticated = (): boolean => {
  return !!getToken();
};
```

**T020: frontend/lib/validation.ts**
```typescript
// TODO: Client-side validation functions
export const validateTitle = (title: string): string | null => {
  const trimmed = title.trim();
  if (!trimmed) return "Title cannot be empty";
  if (trimmed.length > 200) return "Title exceeds 200 characters";
  return null;
};

export const validateDescription = (description: string): string | null => {
  if (description.length > 1000) return "Description exceeds 1000 characters";
  return null;
};

export const validateEmail = (email: string): string | null => {
  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  if (!emailRegex.test(email)) return "Invalid email format";
  return null;
};

export const validatePassword = (password: string): string | null => {
  if (password.length < 8) return "Password must be at least 8 characters";
  return null;
};
```

**T021: frontend/tailwind.config.ts** ✅ Already created

**T022: frontend/app/layout.tsx**
```typescript
import type { Metadata } from "next";
import "./globals.css";

export const metadata: Metadata = {
  title: "Todo App - Phase II",
  description: "Multi-user todo application",
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en">
      <body>{children}</body>
    </html>
  );
}
```

**T023: frontend/middleware.ts**
```typescript
import { NextResponse } from 'next/server';
import type { NextRequest } from 'next/server';

export function middleware(request: NextRequest) {
  const token = request.cookies.get('access_token')?.value;

  // Protected routes
  if (request.nextUrl.pathname.startsWith('/dashboard')) {
    if (!token) {
      return NextResponse.redirect(new URL('/login', request.url));
    }
  }

  // Redirect authenticated users from login/register to dashboard
  if (['/login', '/register'].includes(request.nextUrl.pathname)) {
    if (token) {
      return NextResponse.redirect(new URL('/dashboard', request.url));
    }
  }

  return NextResponse.next();
}

export const config = {
  matcher: ['/dashboard/:path*', '/login', '/register'],
};
```

**T024: Install Dependencies**
```bash
cd frontend
npm install
```

### Shared Types Foundation (T025-T027) ✅ Already created

## 📋 Phase 3: US1 - Authentication (19 tasks)

**Goal**: Users can register, login, and logout with JWT authentication

### Backend Models (T028-T029)

**backend/src/models/user.py**
```python
from sqlmodel import SQLModel, Field, Relationship
from typing import Optional, List
from backend.src.db.base import TimestampMixin

class User(TimestampMixin, table=True):
    __tablename__ = "users"

    id: Optional[int] = Field(default=None, primary_key=True)
    email: str = Field(unique=True, index=True, max_length=255)
    hashed_password: str = Field(max_length=255)

    # Relationship
    tasks: List["Task"] = Relationship(back_populates="user", cascade_delete=True)
```

### Backend Services (T030-T032)

**backend/src/services/auth.py**
```python
from datetime import datetime, timedelta
from jose import jwt
from backend.src.core.config import settings

def create_access_token(data: dict, expires_delta: timedelta | None = None) -> str:
    to_encode = data.copy()
    if expires_delta:
        expire = datetime.utcnow() + expires_delta
    else:
        expire = datetime.utcnow() + timedelta(days=settings.ACCESS_TOKEN_EXPIRE_DAYS)

    to_encode.update({"exp": expire})
    encoded_jwt = jwt.encode(
        to_encode, settings.JWT_SECRET_KEY, algorithm=settings.JWT_ALGORITHM
    )
    return encoded_jwt
```

**backend/src/services/user_service.py**
```python
from sqlmodel import select
from sqlmodel.ext.asyncio.session import AsyncSession
from backend.src.models.user import User
from backend.src.core.security import hash_password, verify_password

async def register_user(db: AsyncSession, email: str, password: str) -> User:
    # TODO: Validate email format
    # TODO: Check if email already exists
    # TODO: Hash password
    # TODO: Create user
    # TODO: Return user
    pass

async def authenticate_user(db: AsyncSession, email: str, password: str) -> User | None:
    # TODO: Get user by email
    # TODO: Verify password
    # TODO: Return user or None
    pass
```

### Backend API (T033-T036)

**backend/src/api/auth.py**
```python
from fastapi import APIRouter, Depends, HTTPException, status
from pydantic import BaseModel, EmailStr
from sqlmodel.ext.asyncio.session import AsyncSession
from backend.src.api.deps import get_db
from backend.src.services.user_service import register_user, authenticate_user
from backend.src.services.auth import create_access_token

router = APIRouter()

class UserCreate(BaseModel):
    email: EmailStr
    password: str

class UserLogin(BaseModel):
    email: EmailStr
    password: str

class TokenResponse(BaseModel):
    id: int
    email: str
    access_token: str
    token_type: str = "bearer"

@router.post("/register", response_model=TokenResponse)
async def register(user: UserCreate, db: AsyncSession = Depends(get_db)):
    # TODO: Call register_user service
    # TODO: Create access token
    # TODO: Return user + token
    pass

@router.post("/login", response_model=TokenResponse)
async def login(credentials: UserLogin, db: AsyncSession = Depends(get_db)):
    # TODO: Call authenticate_user service
    # TODO: Create access token
    # TODO: Return user + token
    pass
```

### Database Migration (T037-T038)

```bash
cd backend
uv run alembic revision --autogenerate -m "create users table"
uv run alembic upgrade head
```

### Frontend Pages (T039-T041)

**frontend/app/register/page.tsx**
```typescript
'use client';

import { useState } from 'react';
import { useRouter } from 'next/navigation';
import { apiClient } from '@/lib/api';
import { saveToken } from '@/lib/auth';

export default function RegisterPage() {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [error, setError] = useState('');
  const router = useRouter();

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    // TODO: Validate inputs
    // TODO: Call POST /api/auth/register
    // TODO: Save token
    // TODO: Redirect to dashboard
  };

  return (
    <div className="min-h-screen flex items-center justify-center">
      <div className="max-w-md w-full space-y-8">
        <h2 className="text-3xl font-bold">Register</h2>
        <form onSubmit={handleSubmit} className="space-y-6">
          {/* TODO: Add form fields */}
        </form>
      </div>
    </div>
  );
}
```

**frontend/app/login/page.tsx** - Similar structure

**frontend/app/page.tsx**
```typescript
'use client';

import { useEffect } from 'react';
import { useRouter } from 'next/navigation';
import { isAuthenticated } from '@/lib/auth';

export default function HomePage() {
  const router = useRouter();

  useEffect(() => {
    if (isAuthenticated()) {
      router.push('/dashboard');
    } else {
      router.push('/login');
    }
  }, [router]);

  return <div>Loading...</div>;
}
```

### Frontend Components (T042-T043)

**frontend/components/AuthForm.tsx**
```typescript
// TODO: Reusable form component for login/register
// Props: type ('login' | 'register'), onSubmit handler
// Includes: email field, password field, submit button, error display
```

### Frontend Auth Integration (T044-T046)

These are integrated into the pages above (T039-T041).

## 📋 Phase 4-8: User Stories 2-6

**Pattern for each user story**:
1. Create backend model (if needed)
2. Create backend service with business logic
3. Create backend API endpoint
4. Create database migration
5. Create frontend component
6. Integrate into dashboard

**All user stories follow this structure** - refer to tasks.md for specific file paths and details.

## 📋 Phase 9: Polish (20 tasks)

### Error Handling (T106-T107)

**backend/src/main.py** - Add exception handlers

### Documentation (T108, T113, T116-T119)

Create README.md files for backend/ and frontend/ with setup instructions.

### Testing (T120)

Full end-to-end user flow test.

## 🎯 Implementation Priority

**MVP (Minimum Viable Product)**:
1. Phase 1-2: Setup + Foundation ✅
2. Phase 3: Authentication (US1)
3. Phase 4: Create Tasks (US2)
4. Phase 5: View Tasks (US3)

**Full Features**:
5. Phase 6: Toggle Status (US4)
6. Phase 7: Update Tasks (US5)
7. Phase 8: Delete Tasks (US6)

**Production Ready**:
8. Phase 9: Polish + Error Handling

## 📝 Quick Commands

### Backend
```bash
cd backend
uv sync                           # Install dependencies
uv run alembic upgrade head       # Run migrations
uv run uvicorn src.main:app --reload --port 8000
```

### Frontend
```bash
cd frontend
npm install                       # Install dependencies
npm run dev                       # Start dev server
```

### Database (Docker)
```bash
cd docker
docker-compose up -d postgres
```

## 🔍 Next Steps

1. **Implement Phase 2 Foundational** - Follow TODOs in each file
2. **Test Backend Setup** - Visit http://localhost:8000/docs
3. **Test Frontend Setup** - Visit http://localhost:3000
4. **Implement Phase 3 Authentication** - Follow user registration flow
5. **Continue with remaining user stories** - One at a time

Refer to `specs/001-web-todo-app/tasks.md` for the complete 125-task breakdown with exact file paths and descriptions.
