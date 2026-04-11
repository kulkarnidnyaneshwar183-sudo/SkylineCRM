@echo off
set MVN_PATH="D:\spring env\IntelliJ IDEA Community Edition 2024.1.4\plugins\maven\lib\maven3\bin\mvn.cmd"

echo.
echo ========================================
echo   Starting Skyline CRM Project
echo ========================================
echo.

echo [1/2] Stopping any existing process on port 8080...
for /f "tokens=5" %%a in ('netstat -aon ^| findstr :8080 ^| findstr LISTENING') do (
    taskkill /f /pid %%a >nul 2>&1
    echo Fixed port conflict.
)

echo [2/2] Building and Starting Server...
%MVN_PATH% clean install tomcat7:run -DskipTests

pause
