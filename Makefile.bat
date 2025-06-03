@echo off
setlocal

REM Configuration
set IMAGE=fbi-test-extension
set TAG=latest
set PRODUCTION_TAG=1.0.0
set BUILDER=buildx-multi-arch

REM Help
if "%1"=="" goto help

if "%1"=="build-extension" goto build_extension
if "%1"=="install-extension" goto install_extension
if "%1"=="update-extension" goto update_extension
if "%1"=="uninstall-extension" goto uninstall_extension
if "%1"=="prepare-buildx" goto prepare_buildx
if "%1"=="push-extension" goto push_extension
if "%1"=="validate-extension" goto validate_extension
goto help

:build_extension
echo Building Docker image %IMAGE%:%TAG%
docker build --tag=%IMAGE%:%TAG% .
goto :eof

:install_extension
call :build_extension
echo Installing Docker extension %IMAGE%:%TAG%
docker extension install %IMAGE%:%TAG%
goto :eof

:update_extension
call :build_extension
echo Updating Docker extension %IMAGE%:%TAG%
docker extension update %IMAGE%:%TAG%
goto :eof

:uninstall_extension
echo Uninstalling Docker extension %IMAGE%:%TAG%
docker extension uninstall %IMAGE%:%TAG%
goto :eof

:prepare_buildx
echo Checking for buildx builder %BUILDER%...
docker buildx inspect %BUILDER% >nul 2>&1 || docker buildx create --name=%BUILDER% --driver=docker-container --driver-opt=network=host
goto :eof

:push_extension
call :prepare_buildx
echo Checking if tag %TAG% already exists...
docker pull %IMAGE%:%TAG% >nul 2>&1
if not errorlevel 1 (
    echo Tag %TAG% already exists. Aborting.
    goto :eof
)
echo Building and pushing multi-arch images...
docker buildx build --push --builder=%BUILDER% --platform=linux/amd64,linux/arm64 --build-arg TAG=%TAG% --tag=%IMAGE%:%TAG% .
docker buildx build --push --builder=%BUILDER% --platform=linux/amd64,linux/arm64 --build-arg TAG=latest --tag=%IMAGE%:latest .
docker buildx build --push --builder=%BUILDER% --platform=linux/amd64,linux/arm64 --build-arg TAG=latest --tag=%IMAGE%:%PRODUCTION_TAG% .
goto :eof

:validate_extension
echo Validating extension %IMAGE%
docker extension validate -a -s -i %IMAGE%
goto :eof

:help
echo.
echo Available commands:
echo   build-extension       - Build service image to be deployed as a desktop extension
echo   install-extension     - Install the extension
echo   update-extension      - Update the extension
echo   uninstall-extension   - Uninstall the extension
echo   prepare-buildx        - Create buildx builder for multi-arch build
echo   push-extension        - Build and upload multi-arch extension image
echo   validate-extension    - Validate extension
echo.
goto :eof
