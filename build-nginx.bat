@echo off
echo 🛠️ Building local NGINX reverse proxy image...

docker build -f nginx.Dockerfile -t fbi-nginx .

if %ERRORLEVEL% neq 0 (
    echo ❌ Build failed!
    exit /b %ERRORLEVEL%
) else (
    echo ✅ Build completed successfully.
)
