@echo off
echo Checking if container is running...
docker ps | find "simple-web-app-container"
if %errorlevel% equ 0 (
    echo Container is running
) else (
    echo Container is not running
    exit /b 1
)

echo Testing web application...
curl -s http://localhost:8080 | find "Welcome to My Simple Web App"
if %errorlevel% equ 0 (
    echo Web application is serving content correctly
) else (
    echo Web application is not responding correctly
    exit /b 1
)
