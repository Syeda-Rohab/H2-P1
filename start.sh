#!/bin/bash

echo "🚀 Starting Phase II Todo App..."
echo ""

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "⚠️  Docker is not running. Please start Docker Desktop first."
    exit 1
fi

# Start PostgreSQL
echo "📦 Starting PostgreSQL database..."
cd docker
docker-compose up -d postgres
cd ..

# Wait for PostgreSQL to be ready
echo "⏳ Waiting for database to be ready..."
sleep 5

# Setup Backend
echo "🐍 Setting up backend..."
cd backend

# Check if .env exists
if [ ! -f .env ]; then
    echo "📝 Creating .env file..."
    cp .env.example .env
    echo "⚠️  Please edit backend/.env with your DATABASE_URL and JWT_SECRET_KEY"
    echo "   Then run this script again."
    exit 1
fi

# Install dependencies
echo "📥 Installing backend dependencies..."
uv sync

# Run migrations
echo "🔧 Running database migrations..."
uv run alembic upgrade head

# Start backend in background
echo "🚀 Starting backend server..."
uv run uvicorn src.main:app --reload --port 8000 &
BACKEND_PID=$!
echo "Backend PID: $BACKEND_PID"

cd ..

# Setup Frontend
echo "⚛️  Setting up frontend..."
cd frontend

# Check if .env.local exists
if [ ! -f .env.local ]; then
    echo "📝 Creating .env.local file..."
    cp .env.local.example .env.local
fi

# Install dependencies
if [ ! -d node_modules ]; then
    echo "📥 Installing frontend dependencies..."
    npm install
fi

# Start frontend
echo "🚀 Starting frontend server..."
npm run dev &
FRONTEND_PID=$!
echo "Frontend PID: $FRONTEND_PID"

cd ..

echo ""
echo "✅ Todo App is starting up!"
echo ""
echo "📍 Backend API: http://localhost:8000"
echo "📍 API Docs: http://localhost:8000/docs"
echo "📍 Frontend: http://localhost:3000"
echo ""
echo "Press Ctrl+C to stop all services"
echo ""

# Wait for interrupt
trap "echo ''; echo '🛑 Stopping services...'; kill $BACKEND_PID $FRONTEND_PID; docker-compose -f docker/docker-compose.yml down; echo '✅ All services stopped'; exit 0" INT

# Keep script running
wait
