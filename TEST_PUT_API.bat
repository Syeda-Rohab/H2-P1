@echo off
echo ========================================
echo   TESTING PUT API - COMPLETE DEMO
echo ========================================
echo.

echo [Step 1] Registering user...
curl -s -X POST http://127.0.0.1:8000/api/auth/register ^
  -H "Content-Type: application/json" ^
  -d "{\"email\":\"puttest@test.com\",\"password\":\"password12345\"}" > response.json

echo Response saved to response.json
type response.json
echo.
echo.

echo [Step 2] Extracting token...
for /f "tokens=2 delims=:," %%a in ('findstr "access_token" response.json') do set TOKEN=%%a
set TOKEN=%TOKEN:"=%
set TOKEN=%TOKEN: =%
echo Token: %TOKEN:~0,50%...
echo.

echo [Step 3] Creating a task...
curl -s -X POST http://127.0.0.1:8000/api/tasks/ ^
  -H "Authorization: Bearer %TOKEN%" ^
  -H "Content-Type: application/json" ^
  -d "{\"title\":\"Original Title\",\"description\":\"Original Description\"}" > task.json

echo Task created:
type task.json
echo.
echo.

for /f "tokens=2 delims=:," %%a in ('findstr "\"id\"" task.json') do set TASK_ID=%%a
set TASK_ID=%TASK_ID: =%
echo Task ID: %TASK_ID%
echo.

echo [Step 4] TESTING PUT API - Updating task...
curl -s -X PUT http://127.0.0.1:8000/api/tasks/%TASK_ID% ^
  -H "Authorization: Bearer %TOKEN%" ^
  -H "Content-Type: application/json" ^
  -d "{\"title\":\"UPDATED TITLE\",\"description\":\"UPDATED DESCRIPTION\"}" > updated.json

echo.
echo ========================================
echo   PUT API RESULT:
echo ========================================
type updated.json
echo.
echo.

echo [Step 5] Verifying update - Getting task...
curl -s -X GET http://127.0.0.1:8000/api/tasks/%TASK_ID% ^
  -H "Authorization: Bearer %TOKEN%" > verify.json

echo.
echo Verification:
type verify.json
echo.
echo.

echo ========================================
echo   ✓ PUT API TEST COMPLETE!
echo ========================================
echo.
echo If you see "UPDATED TITLE" above, PUT is working!
echo.

del response.json task.json updated.json verify.json 2>nul

pause
