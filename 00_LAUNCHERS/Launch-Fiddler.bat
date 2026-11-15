@echo off
cd /d "%~dp0.."
set "DEV_ROOT=%CD%"
set "FIDDLER_DIR=%DEV_ROOT%\05_UTILITIES\Fiddler"

rem Launch Fiddler Classic (HTTP/HTTPS debugger)
if exist "%FIDDLER_DIR%\Fiddler.exe" (
    start "" "%FIDDLER_DIR%\Fiddler.exe"
    echo [OK] Fiddler Classic launched.
) else (
    echo [ERROR] Fiddler Classic not found at %FIDDLER_DIR%
    echo Please extract Fiddler Classic Portable to this directory.
    pause
    exit /b 1
)