@echo off
echo ========================================
echo   FINAL SOLUTION - Use YARN
echo ========================================
echo.
echo npm is failing due to network timeouts.
echo Installing Yarn package manager...
echo.

REM Install Yarn globally
call npm install -g yarn
if %errorlevel% NEQ 0 (
    echo Failed to install Yarn. Trying alternative...
    call npm config set registry https://registry.npmmirror.com
    call npm install -g yarn
)

echo.
echo Cleaning up corrupted packages...
cd /d "%~dp0frontend"

REM Remove corrupted node_modules
if exist node_modules\next rmdir /s /q node_modules\next
if exist node_modules\tailwindcss rmdir /s /q node_modules\tailwindcss

echo.
echo Installing with Yarn (more reliable than npm)...
call yarn install

if %errorlevel% EQU 0 (
    echo.
    echo ========================================
    echo   ✓ Installation Successful!
    echo ========================================
    echo.
    echo Starting frontend server...
    echo.
    start "Frontend Server" cmd /k "yarn dev"

    echo.
    echo Your app is now running:
    echo   Frontend: http://localhost:3000
    echo   Backend:  http://localhost:8000
    echo.
    pause
) else (
    echo.
    echo ========================================
    echo   Installation still failed
    echo ========================================
    echo.
    echo Please try these manual steps:
    echo.
    echo 1. Close all terminals
    echo 2. Connect to a different network (try mobile hotspot)
    echo 3. Run this file again
    echo.
    echo OR test backend only at: http://localhost:8000/docs
    echo.
    pause
)
