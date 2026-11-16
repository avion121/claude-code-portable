@echo off
cd /d "%~dp0.."
set "DEV_ROOT=%CD%"

rem Inject all portable runtimes into PATH for VS Code's terminal
set "PATH=%DEV_ROOT%\02_RUNTIMES\node-v24.9.0-win-x64;%DEV_ROOT%\02_RUNTIMES\Git-Portable\cmd;%DEV_ROOT%\02_RUNTIMES\Git-Portable\usr\bin;%DEV_ROOT%\02_RUNTIMES\python-portable;%DEV_ROOT%\02_RUNTIMES\python-portable\Scripts;%PATH%"
set "npm_config_cache=%DEV_ROOT%\02_RUNTIMES\node-v24.9.0-win-x64\.npm-cache"

rem Launch VS Code Portable (assumes 'data' folder exists)
start "" "%DEV_ROOT%\01_EDITORS\VSCode-Portable\Code.exe"