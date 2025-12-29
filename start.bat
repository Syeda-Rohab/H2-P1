@echo off
echo 🚀 Starting Phase II Todo App...
echo.

REM Check if Docker is running
docker info >nul 2>&1
if %errorlevel% neq 0 (
    echo ⚠️  Docker is not running. Please start Docker Desktop first.
    exit /b 1
)

REM Start PostgreSQL
echo 📦 Starting PostgreSQL database...
cd docker
docker-compose up -d postgres
cd ..

REM Wait for PostgreSQL to be ready
echo ⏳ Waiting for database to be ready...
timeout /t 5 /nobreak >nul

REM Setup Backend
echo 🐍 Setting up backend...
cd backend

REM Check if .env exists
if not exist .env (
    echo 📝 Creating .env file...
    copy .env.example .env
    echo ⚠️  Please edit backend\.env with your DATABASE_URL and JWT_SECRET_KEY
    echo    Then run this script again.
    cd ..
    pause
    exit /b 1
)

REM Install dependencies
echo 📥 Installing backend dependencies...
call uv sync

REM Run migrations
echo 🔧 Running database migrations...
call uv run alembic upgrade head

REM Start backend
echo 🚀 Starting backend server...
start "Backend" cmd /k "uv run uvicorn src.main:app --reload --port 8000"

cd ..

REM Setup Frontend
echo ⚛️  Setting up frontend...
cd frontend

REM Check if .env.local exists
if not exist .env.local (
    echo 📝 Creating .env.local file...
    copy .env.local.example .env.local
)

REM Install dependencies
if not exist node_modules (
    echo 📥 Installing frontend dependencies...
    call npm install
)

REM Start frontend
echo 🚀 Starting frontend server...
start "Frontend" cmd /k "npm run dev"

cd ..

echo.
echo ✅ Todo App is starting up!
echo.
echo 📍 Backend API: http://localhost:8000
echo 📍 API Docs: http://localhost:8000/docs
echo 📍 Frontend: http://localhost:3000
echo.
echo Close the backend and frontend windows to stop the services
echo.
pause
