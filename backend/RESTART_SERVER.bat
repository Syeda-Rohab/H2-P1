@echo off
echo.
echo ========================================
echo    RESTARTING TODO APP BACKEND
echo ========================================
echo.

cd /d "%~dp0"

echo Stopping any existing server...
taskkill /F /FI "WINDOWTITLE eq Todo Backend*" 2>nul
taskkill /F /IM python.exe /FI "MEMUSAGE gt 50000" 2>nul
timeout /t 2 /nobreak >nul

echo.
echo Starting backend server...
echo.
start "Todo Backend Server" cmd /k "python -m uvicorn src.main:app --reload --port 8000"

timeout /t 3 /nobreak >nul

echo.
echo ========================================
echo    ✓ SERVER STARTED!
echo ========================================
echo.
echo Your API is now running at:
echo   http://127.0.0.1:8000
echo   http://127.0.0.1:8000/docs
echo.
echo A new window has opened with the server.
echo Close that window to stop the server.
echo.
pause
