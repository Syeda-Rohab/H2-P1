@echo off
echo 🚀 Installing minimal dependencies with timeout fix...
echo.

cd backend

echo Installing core packages...
python -m pip install --timeout=300 --retries 5 fastapi || goto :error
python -m pip install --timeout=300 --retries 5 uvicorn || goto :error
python -m pip install --timeout=300 --retries 5 sqlmodel || goto :error
python -m pip install --timeout=300 --retries 5 aiosqlite || goto :error
python -m pip install --timeout=300 --retries 5 python-dotenv || goto :error
python -m pip install --timeout=300 --retries 5 pydantic-settings || goto :error

echo Installing auth packages (this may take longer)...
python -m pip install --timeout=300 --retries 5 python-jose[cryptography] || goto :error
python -m pip install --timeout=300 --retries 5 passlib[bcrypt] || goto :error

echo.
echo ✅ Backend dependencies installed!
echo.
echo Creating database...
python init_db.py

echo.
echo Starting backend server...
echo Backend will run at http://localhost:8000
echo.
start "Backend Server" cmd /k "python -m uvicorn src.main:app --reload --port 8000"

cd ..\frontend

echo.
echo Installing frontend dependencies...
call npm install --legacy-peer-deps

echo.
echo Starting frontend server...
echo Frontend will run at http://localhost:3000
echo.
start "Frontend Server" cmd /k "npm run dev"

echo.
echo ✅ Application is starting!
echo 📍 Frontend: http://localhost:3000
echo 📍 Backend API: http://localhost:8000/docs
echo.
pause
exit

:error
echo.
echo ❌ Installation failed. Try running again or check your internet connection.
pause
exit /b 1
