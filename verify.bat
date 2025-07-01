@echo off
echo Checking if container is running...
docker ps | find "simple-web-app-container"
if %errorlevel% equ 0 (
    echo [SUCCESS] Container is running
) else (
    echo [ERROR] Container is not running
    exit /b 1
)

echo Testing web application...
curl -s http://localhost:8081 | find "Welcome to My Simple Web App"
if %errorlevel% equ 0 (
    echo [SUCCESS] Web application is serving content correctly
) else (
    echo [ERROR] Web application is not responding correctly
    exit /b 1
)
