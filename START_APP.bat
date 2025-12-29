@echo off
echo ========================================
echo    TODO APP PHASE 2 - QUICK START
echo ========================================
echo.
echo BACKEND: Running at http://localhost:8000
echo FRONTEND: Will run at http://localhost:3000
echo.
echo ========================================
echo.

cd /d "%~dp0"

echo [INFO] Backend is already running!
echo [INFO] Visit: http://localhost:8000/docs
echo.

echo [STEP 1/2] Installing frontend dependencies...
echo This may take a few minutes due to network speed...
echo.

cd frontend

REM Try to install with retries
set MAX_RETRIES=3
set RETRY_COUNT=0

:install_loop
if %RETRY_COUNT% GEQ %MAX_RETRIES% goto :install_failed

set /a RETRY_COUNT=%RETRY_COUNT%+1
echo Attempt %RETRY_COUNT% of %MAX_RETRIES%...

call npm install --legacy-peer-deps --prefer-offline --no-audit --fetch-timeout=600000 2>nul
if %errorlevel% EQU 0 goto :install_success

echo Retry %RETRY_COUNT% failed, trying again...
timeout /t 2 /nobreak >nul
goto :install_loop

:install_success
echo.
echo ✓ Frontend dependencies installed!
echo.

:start_frontend
echo [STEP 2/2] Starting frontend server...
echo.
start "Todo Frontend" cmd /k "npm run dev"
timeout /t 3 /nobreak >nul

echo.
echo ========================================
echo    ✓ APPLICATION STARTED SUCCESSFULLY!
echo ========================================
echo.
echo Your Todo App is now running:
echo   Frontend: http://localhost:3000
echo   Backend:  http://localhost:8000
echo   API Docs: http://localhost:8000/docs
echo.
echo Two windows are open:
echo   - Backend Server (already running)
echo   - Frontend Server (just started)
echo.
echo Close those windows to stop the servers.
echo.
pause
exit

:install_failed
echo.
echo ========================================
echo    WARNING: Automatic install failed
echo ========================================
echo.
echo Please install frontend manually:
echo.
echo 1. Open a new terminal/command prompt
echo 2. Run these commands:
echo    cd C:\Users\Dell\Desktop\H2 todo-app\frontend
echo    npm install --legacy-peer-deps
echo    npm run dev
echo.
echo Then visit: http://localhost:3000
echo.
echo Backend is still running at: http://localhost:8000/docs
echo.
pause
exit
