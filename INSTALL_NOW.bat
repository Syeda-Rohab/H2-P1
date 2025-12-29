@echo off
echo ========================================
echo    QUICK INSTALL - TODO APP PHASE 2
echo ========================================
echo.

cd /d "%~dp0backend"

echo [Step 1/4] Installing Backend Dependencies...
echo Please wait, this may take a few minutes...
echo.

REM Install packages with maximum timeout and retries
python -m pip config set global.timeout 600
python -m pip install --no-cache-dir --timeout=600 --retries 10 fastapi
if %errorlevel% neq 0 goto :backend_error

python -m pip install --no-cache-dir --timeout=600 --retries 10 uvicorn
if %errorlevel% neq 0 goto :backend_error

python -m pip install --no-cache-dir --timeout=600 --retries 10 sqlmodel
if %errorlevel% neq 0 goto :backend_error

python -m pip install --no-cache-dir --timeout=600 --retries 10 aiosqlite
if %errorlevel% neq 0 goto :backend_error

python -m pip install --no-cache-dir --timeout=600 --retries 10 python-dotenv
if %errorlevel% neq 0 goto :backend_error

python -m pip install --no-cache-dir --timeout=600 --retries 10 pydantic-settings
if %errorlevel% neq 0 goto :backend_error

python -m pip install --no-cache-dir --timeout=600 --retries 10 python-jose[cryptography]
if %errorlevel% neq 0 goto :backend_error

python -m pip install --no-cache-dir --timeout=600 --retries 10 passlib[bcrypt]
if %errorlevel% neq 0 goto :backend_error

echo.
echo ✓ Backend dependencies installed successfully!
echo.

echo [Step 2/4] Creating Database...
python init_db.py
if %errorlevel% neq 0 (
    echo Warning: Database initialization had issues, but continuing...
)

echo.
echo [Step 3/4] Starting Backend Server...
start "Todo Backend API" cmd /k "python -m uvicorn src.main:app --reload --port 8000"
timeout /t 3 /nobreak >nul

cd ..\frontend

echo.
echo [Step 4/4] Installing Frontend...
call npm config set fetch-retry-mintimeout 60000
call npm config set fetch-retry-maxtimeout 120000
call npm install --legacy-peer-deps --prefer-offline
if %errorlevel% neq 0 goto :frontend_error

echo.
echo ✓ Frontend dependencies installed!
echo.

echo Starting Frontend Server...
start "Todo Frontend" cmd /k "npm run dev"

echo.
echo ========================================
echo    ✓ APPLICATION STARTED SUCCESSFULLY!
echo ========================================
echo.
echo Your app is running at:
echo   Frontend: http://localhost:3000
echo   Backend:  http://localhost:8000
echo   API Docs: http://localhost:8000/docs
echo.
echo Two windows will open for backend and frontend servers.
echo Close those windows to stop the servers.
echo.
pause
exit

:backend_error
echo.
echo ========================================
echo    ERROR: Backend Installation Failed
echo ========================================
echo.
echo Try these solutions:
echo 1. Check your internet connection
echo 2. Try using a different network (mobile hotspot)
echo 3. Run: python -m pip install --index-url https://mirrors.aliyun.com/pypi/simple/ fastapi uvicorn sqlmodel aiosqlite
echo.
pause
exit /b 1

:frontend_error
echo.
echo ========================================
echo    ERROR: Frontend Installation Failed
echo ========================================
echo.
echo Try these solutions:
echo 1. Check your internet connection
echo 2. Delete node_modules folder and try again
echo 3. Run: npm install --legacy-peer-deps --registry https://registry.npmmirror.com
echo.
pause
exit /b 1
