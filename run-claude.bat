@echo off
setlocal enableextensions
cd /d "%~dp0"
set "PORTABLE_ROOT=%CD%"

echo ============================================================
echo      PORTABLE DEV SUITE - MASTER CONTROL
echo ============================================================
echo.
echo [*] USB Root: %PORTABLE_ROOT%
echo.

if exist "%PORTABLE_ROOT%\PORTABLE-SUITE-MASTER.bat" (
    call "%PORTABLE_ROOT%\PORTABLE-SUITE-MASTER.bat"
) else (
    echo [ERROR] Master menu not found.
    pause
)