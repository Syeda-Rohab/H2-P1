@echo off
echo ========================================
echo   FRONTEND INSTALLATION - NETWORK FIX
echo ========================================
echo.
echo Your network is experiencing timeouts.
echo Trying alternative installation methods...
echo.

cd /d "%~dp0"

echo [Method 1] Trying with Taobao Registry (China - Fast)...
call npm install --registry=https://registry.npmmirror.com --legacy-peer-deps
if %errorlevel% EQU 0 goto :success

echo.
echo [Method 2] Trying with Alibaba Registry...
call npm install --registry=https://registry.npm.taobao.org --legacy-peer-deps
if %errorlevel% EQU 0 goto :success

echo.
echo [Method 3] Trying with npmmirror.com...
call npm install --registry=https://registry.npmmirror.com/
if %errorlevel% EQU 0 goto :success

echo.
echo [Method 4] Trying core packages only...
call npm install --save next@14 react@18 react-dom@18 --registry=https://registry.npmmirror.com
call npm install --save-dev typescript @types/react @types/node --registry=https://registry.npmmirror.com
call npm install axios tailwindcss postcss autoprefixer --registry=https://registry.npmmirror.com
if %errorlevel% EQU 0 goto :success

echo.
echo ========================================
echo   All automatic methods failed
echo ========================================
echo.
echo Please try one of these manual solutions:
echo.
echo 1. Use Yarn:
echo    npm install -g yarn
echo    yarn install
echo.
echo 2. Use mobile hotspot and retry
echo.
echo 3. Try again later when network is stable
echo.
pause
exit /b 1

:success
echo.
echo ========================================
echo   ✓ Installation Successful!
echo ========================================
echo.
echo Starting development server...
echo.
call npm run dev
