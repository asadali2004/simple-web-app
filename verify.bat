@echo off
echo Starting verification...

:: Check if container is running
docker ps | findstr /I "simple-web-app-container" >nul
if %errorlevel% neq 0 (
    echo ERROR: Container not running!
    docker ps -a | findstr /I "simple-web-app-container"
    exit /b 1
)

:: Test application response
curl -s http://localhost:8082 > response.html
findstr /I "Welcome to My Simple Web App" response.html >nul
if %errorlevel% neq 0 (
    echo ERROR: Application not responding correctly
    type response.html
    del response.html >nul 2>&1
    exit /b 1
)

echo Verification successful!
del response.html >nul 2>&1
exit /b 0
