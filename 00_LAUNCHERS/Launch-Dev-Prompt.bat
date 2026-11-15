@echo off
title Portable Dev Environment
cd /d "%~dp0.."
set "DEV_ROOT=%CD%"

rem Prepend all portable runtimes to PATH
set "PATH=%DEV_ROOT%\02_RUNTIMES\node-v24.9.0-win-x64;%DEV_ROOT%\02_RUNTIMES\Git-Portable\cmd;%DEV_ROOT%\02_RUNTIMES\Git-Portable\usr\bin;%DEV_ROOT%\05_UTILITIES\7-Zip-Portable;%PATH%"

rem Redirect global npm cache to USB to prevent host writing
set "npm_config_cache=%DEV_ROOT%\02_RUNTIMES\node-v24.9.0-win-x64\.npm-cache"

echo ============================================================
echo   PORTABLE DEVELOPER ENVIRONMENT LOADED
echo ============================================================
echo   Node.js : %DEV_ROOT%\02_RUNTIMES\node-v24.9.0-win-x64
echo   Git     : %DEV_ROOT%\02_RUNTIMES\Git-Portable
echo   AI Tools: %DEV_ROOT%\03_AI_TOOLS
echo ============================================================
echo.

cmd /k "echo Type 'node -v', 'git --version', or run '..\run-claude.bat'"
