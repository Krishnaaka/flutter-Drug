@echo off
echo ========================================================
echo Starting DISCTS System (Full Auto-Run)
echo ========================================================

echo.
echo Starting Spring Boot Backend...
start cmd /k "title DISCTS-Backend && cd backend && ..\apache-maven-3.9.6\bin\mvn.cmd spring-boot:run"

echo.
echo Downloading required Flutter Engine Binaries (First Time Only)...
echo Starting Flutter Frontend...
start cmd /k "title DISCTS-Frontend && cd frontend && ..\flutter_sdk\flutter\bin\flutter.bat run -d chrome"

echo.
echo ========================================================
echo Apps are launching! The UI will pop up when compilation finishes.
echo ========================================================
pause
