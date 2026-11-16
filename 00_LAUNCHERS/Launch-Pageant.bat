@echo off
cd /d "%~dp0.."
set "DEV_ROOT=%CD%"
set "PAGEANT_DIR=%DEV_ROOT%\05_UTILITIES\pageant"

rem Launch Pageant (PuTTY SSH Agent)
if exist "%PAGEANT_DIR%\pageant.exe" (
    start "" "%PAGEANT_DIR%\pageant.exe"
    echo [OK] Pageant SSH Agent launched.
) else (
    echo [ERROR] Pageant not found at %PAGEANT_DIR%
    echo Please extract PuTTY Portable to this directory.
    pause
    exit /b 1
)