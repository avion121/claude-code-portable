@echo off
cd /d "%~dp0.."
set "DEV_ROOT=%CD%"
set "WT_DIR=%DEV_ROOT%\05_UTILITIES\Windows-Terminal"

rem Set portable environment paths
set "PATH=%DEV_ROOT%\02_RUNTIMES\node-v24.9.0-win-x64;%DEV_ROOT%\02_RUNTIMES\Git-Portable\cmd;%DEV_ROOT%\02_RUNTIMES\python-portable;%DEV_ROOT%\05_UTILITIES\7-Zip-Portable;%PATH%"
set "npm_config_cache=%DEV_ROOT%\02_RUNTIMES\node-v24.9.0-win-x64\.npm-cache"

rem Launch Windows Terminal with portable profiles
if exist "%WT_DIR%\wt.exe" (
    start "" "%WT_DIR%\wt.exe" --launch-profile "PowerShell"
) else (
    echo [ERROR] Windows Terminal not found at %WT_DIR%
    echo Please extract Windows Terminal zip to this directory.
    pause
    exit /b 1
)