@echo off
cd /d "%~dp0.."
set "DEV_ROOT=%CD%"

rem Inject portable paths
set "PATH=%DEV_ROOT%\02_RUNTIMES\node-v24.9.0-win-x64;%DEV_ROOT%\02_RUNTIMES\Git-Portable\cmd;%PATH%"

rem Launch VS Code Portable (assumes 'data' folder exists)
start "" "%DEV_ROOT%\01_EDITORS\VSCode-Portable\Code.exe"
