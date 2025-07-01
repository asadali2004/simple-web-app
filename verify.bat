@echo off
echo Starting verification...

:: Check container status
docker ps | find "simple-web-app-container" >nul
if %errorlevel% neq 0 (
    echo ERROR: Container not running!
    docker ps -a | find "simple-web-app-container"
    exit /b 1
)

:: Test application response
curl -s -o response.html http://localhost:8081
find "Welcome to My Simple Web App" response.html >nul
if %errorlevel% neq 0 (
    echo ERROR: Application not responding correctly
    type response.html
    del response.html
    exit /b 1
)

echo Verification successful!
del response.html 2>nul
exit /b 0
