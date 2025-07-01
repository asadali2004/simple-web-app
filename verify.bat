@echo off
echo Checking container status...
docker ps | find "simple-web-app-container" > nul
if %errorlevel% neq 0 (
   echo ERROR: Container is not running
   exit /b 1
)

echo Testing application...
curl -s http://localhost:8081 | find "Welcome to My Simple Web App" > nul
if %errorlevel% neq 0 (
   echo ERROR: Application not responding correctly
   exit /b 1
)

echo SUCCESS: Container is running and application is accessible
exit /b 0
