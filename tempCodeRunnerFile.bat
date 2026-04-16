@echo off
set MVN_PATH="D:\spring env\IntelliJ IDEA Community Edition 2024.1.4\plugins\maven\lib\maven3\bin\mvn.cmd"
set TOMCAT_HOME="C:\Program Files (x86)\Apache Software Foundation\Tomcat 9.0"

echo.
echo ========================================
echo   Starting Skyline CRM Project
echo ========================================
echo.

echo [1/3] Stopping any existing process on port 8080...
for /f "tokens=5" %%a in ('netstat -aon ^| findstr :8080 ^| findstr LISTENING') do (
    taskkill /f /pid %%a >nul 2>&1
    echo Fixed port conflict.
)

echo [2/3] Building WAR file...
call %MVN_PATH% clean install -DskipTests

if errorlevel 1 (
    echo [ERROR] Maven build failed.
    pause
    exit /b
)

echo [3/3] Deploying to Tomcat 9...
set WAR_FILE="target\SkylineCRM-1.0-SNAPSHOT.war"
set DEST_WAR=%TOMCAT_HOME%\webapps\SkylineCRM.war

if exist %DEST_WAR% del %DEST_WAR%
copy %WAR_FILE% %DEST_WAR%

echo Starting Tomcat 9...
cd /d %TOMCAT_HOME%\bin
call startup.bat

echo.
echo Project deployed to: http://localhost:8080/SkylineCRM/
echo.
pause