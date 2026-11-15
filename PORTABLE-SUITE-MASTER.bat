@echo off
setlocal enableextensions enabledelayedexpansion
title Portable Dev Suite & Claude Code CLI Master Control

cd /d "%~dp0"
set "PORTABLE_ROOT=%~dp0"
for %%I in ("%PORTABLE_ROOT%") do set "PORTABLE_ROOT=%%~fI"

rem Set portable environment paths (Node.js, Git, Python, Utilities)
set "NODE_DIR=%PORTABLE_ROOT%02_RUNTIMES\node-v24.9.0-win-x64"
set "GIT_DIR=%PORTABLE_ROOT%02_RUNTIMES\Git-Portable"
set "PYTHON_DIR=%PORTABLE_ROOT%02_RUNTIMES\python-portable"
set "FREELLMAPI_DIR=%PORTABLE_ROOT%03_AI_TOOLS\freellmapi"
set "VSCODE_DIR=%PORTABLE_ROOT%01_EDITORS\VSCode-Portable"
set "WT_DIR=%PORTABLE_ROOT%05_UTILITIES\Windows-Terminal"
set "FIDDLER_DIR=%PORTABLE_ROOT%05_UTILITIES\Fiddler"
set "PAGEANT_DIR=%PORTABLE_ROOT%05_UTILITIES\pageant"

rem Include portable binaries in PATH
set "PATH=%PYTHON_DIR%;%PYTHON_DIR%\Scripts;%NODE_DIR%;%GIT_DIR%\cmd;%PORTABLE_ROOT%05_UTILITIES\7-Zip-Portable;%PATH%"
set "npm_config_cache=%NODE_DIR%\.npm-cache"

:MENU
cls
echo ============================================================
echo      PORTABLE CLAUDE CODE CLI & DEV SUITE MASTER CONTROL
echo ============================================================
echo  Root Directory: %PORTABLE_ROOT%
echo  Runtimes      : Node.js, Python, Git
echo ============================================================
echo.
echo   [1] Launch Claude Code CLI (via freellmapi zero-trace)
echo   [2] Launch Portable VS Code
echo   [3] Launch Windows Terminal (Tabbed Console)
echo   [4] Launch Fiddler Classic (HTTP/HTTPS Proxy Debugger)
echo   [5] Launch Pageant (PuTTY SSH Key Agent)
echo   [6] Open Developer Command Prompt (Node + Python + Git)
echo   [7] Run System Health & Environment Check
echo   [8] Initialize Git & Push Project to GitHub (avion121)
echo   [9] Auto-Setup Directory Structure & Check Runtimes
echo   [0] Exit
echo.
echo ============================================================
set /p CHOICE="Select an option (0-9) and press Enter: "

if "%CHOICE%"=="1" goto LAUNCH_CLAUDE
if "%CHOICE%"=="2" goto LAUNCH_VSCODE
if "%CHOICE%"=="3" goto LAUNCH_WT
if "%CHOICE%"=="4" goto LAUNCH_FIDDLER
if "%CHOICE%"=="5" goto LAUNCH_PAGEANT
if "%CHOICE%"=="6" goto LAUNCH_CLI
if "%CHOICE%"=="7" goto DIAGNOSTICS
if "%CHOICE%"=="8" goto PUSH_GITHUB
if "%CHOICE%"=="9" goto SETUP_DIRS
if "%CHOICE%"=="0" goto EXIT_APP
goto MENU

:LAUNCH_CLAUDE
cls
echo ============================================================
echo         LAUNCHING PORTABLE CLAUDE CODE CLI (freellmapi)
echo ============================================================
echo.
echo [*] Step 1: Dry-run verification...
if exist "%FREELLMAPI_DIR%\dist\index.js" (
    call node "%FREELLMAPI_DIR%\dist\index.js" launch --dry-run
) else (
    echo [!] freellmapi dist build missing at %FREELLMAPI_DIR%\dist\index.js
)
echo.
echo [*] Step 2: Executing Claude Code CLI via freellmapi...
if exist "%FREELLMAPI_DIR%\dist\index.js" (
    call node "%FREELLMAPI_DIR%\dist\index.js" launch
) else (
    echo [ERROR] freellmapi not found. Please ensure freellmapi is present in 03_AI_TOOLS.
)
echo.
pause
goto MENU

:LAUNCH_VSCODE
cls
echo ============================================================
echo              LAUNCHING PORTABLE VS CODE
echo ============================================================
if exist "%VSCODE_DIR%\Code.exe" (
    start "" "%VSCODE_DIR%\Code.exe"
    echo [OK] VS Code launched.
) else (
    echo [ERROR] VS Code Portable binary not found at:
    echo %VSCODE_DIR%\Code.exe
)
echo.
pause
goto MENU

:LAUNCH_WT
cls
echo ============================================================
echo           LAUNCHING PORTABLE WINDOWS TERMINAL
echo ============================================================
if exist "%WT_DIR%\wt.exe" (
    start "" "%WT_DIR%\wt.exe"
    echo [OK] Windows Terminal launched.
) else (
    echo [ERROR] wt.exe not found at %WT_DIR%
)
echo.
pause
goto MENU

:LAUNCH_FIDDLER
cls
echo ============================================================
echo           LAUNCHING FIDDLER CLASSIC HTTP PROXY
echo ============================================================
if exist "%FIDDLER_DIR%\Fiddler.exe" (
    start "" "%FIDDLER_DIR%\Fiddler.exe"
    echo [OK] Fiddler Classic launched.
) else (
    echo [ERROR] Fiddler.exe not found at %FIDDLER_DIR%
)
echo.
pause
goto MENU

:LAUNCH_PAGEANT
cls
echo ============================================================
echo           LAUNCHING PAGEANT SSH KEY AGENT
echo ============================================================
if exist "%PAGEANT_DIR%\pageant.exe" (
    start "" "%PAGEANT_DIR%\pageant.exe"
    echo [OK] Pageant SSH Agent launched.
) else (
    echo [ERROR] pageant.exe not found at %PAGEANT_DIR%
)
echo.
pause
goto MENU

:LAUNCH_CLI
cls
echo ============================================================
echo            PORTABLE DEVELOPER COMMAND PROMPT
echo ============================================================
echo Environment loaded with Node, Python, Git, and portable utilities.
echo.
cmd /k "echo Type 'node -v', 'python --version', 'git --version', or exit to return to menu."
goto MENU

:DIAGNOSTICS
cls
echo ============================================================
echo              SYSTEM INTEGRITY DIAGNOSTICS
echo ============================================================
echo.
set "ERR_COUNT=0"

if exist "%NODE_DIR%\node.exe" (
    echo [OK] Node.js binary found.
) else (
    echo [FAIL] Node.js missing at %NODE_DIR%
    set /a ERR_COUNT+=1
)

if exist "%PYTHON_DIR%\python.exe" (
    echo [OK] Portable Python binary found.
) else (
    echo [WARN] Portable Python missing at %PYTHON_DIR%
)

if exist "%GIT_DIR%\cmd\git.exe" (
    echo [OK] Portable Git found.
) else (
    echo [FAIL] Git missing at %GIT_DIR%
    set /a ERR_COUNT+=1
)

if exist "%WT_DIR%\wt.exe" (
    echo [OK] Windows Terminal found.
) else (
    echo [WARN] Windows Terminal missing at %WT_DIR%
)

if exist "%FIDDLER_DIR%\Fiddler.exe" (
    echo [OK] Fiddler Classic found.
) else (
    echo [WARN] Fiddler Classic missing at %FIDDLER_DIR%
)

if exist "%PAGEANT_DIR%\pageant.exe" (
    echo [OK] Pageant SSH Agent found.
) else (
    echo [WARN] Pageant SSH Agent missing at %PAGEANT_DIR%
)

if exist "%FREELLMAPI_DIR%\dist\index.js" (
    echo [OK] freellmapi CLI build verified.
) else (
    echo [WARN] freellmapi dist build missing.
)

if exist "%VSCODE_DIR%\data" (
    echo [OK] VS Code 'data' directory active (Portable mode enabled).
) else (
    echo [WARN] VS Code 'data' folder missing.
)

echo.
echo ------------------------------------------------------------
if %ERR_COUNT%==0 (
    echo STATUS: READY - Portable environment passes all core checks.
) else (
    echo STATUS: ATTENTION NEEDED (%ERR_COUNT% missing core runtime[s]).
)
echo ------------------------------------------------------------
echo.
pause
goto MENU

:PUSH_GITHUB
cls
echo ============================================================
echo         GIT INITIALIZATION & GITHUB PUSH (avion121)
echo ============================================================
echo.
echo Target Repository: https://github.com/avion121/claude-code-portable.git
echo.
set /p CONFIRM="Proceed with Git commit and push? (Y/N): "
if /i not "%CONFIRM%"=="Y" goto MENU

echo.
echo [*] Initializing Git...
git init
git add .
git commit -m "feat: replace claude code desktop with cli via freellmapi and add dev utilities"
git branch -M main
git remote remove origin >nul 2>&1
git remote add origin https://github.com/avion121/claude-code-portable.git

echo [*] Pushing to GitHub...
git push -u origin main

if errorlevel 1 (
    echo.
    echo [ERROR] Push failed. Check internet connection and GitHub credentials.
) else (
    echo.
    echo [SUCCESS] Successfully pushed to https://github.com/avion121/claude-code-portable.git
)
echo.
pause
goto MENU

:SETUP_DIRS
cls
echo ============================================================
echo            DIRECTORY STRUCTURE INITIALIZATION
echo ============================================================
echo.
if not exist "%PORTABLE_ROOT%00_LAUNCHERS" mkdir "%PORTABLE_ROOT%00_LAUNCHERS"
if not exist "%PORTABLE_ROOT%01_EDITORS" mkdir "%PORTABLE_ROOT%01_EDITORS"
if not exist "%PORTABLE_ROOT%02_RUNTIMES" mkdir "%PORTABLE_ROOT%02_RUNTIMES"
if not exist "%PORTABLE_ROOT%02_RUNTIMES\python-portable" mkdir "%PORTABLE_ROOT%02_RUNTIMES\python-portable"
if not exist "%PORTABLE_ROOT%03_AI_TOOLS" mkdir "%PORTABLE_ROOT%03_AI_TOOLS"
if not exist "%PORTABLE_ROOT%04_DEV_TOOLS" mkdir "%PORTABLE_ROOT%04_DEV_TOOLS"
if not exist "%PORTABLE_ROOT%05_UTILITIES" mkdir "%PORTABLE_ROOT%05_UTILITIES"
if not exist "%PORTABLE_ROOT%05_UTILITIES\Windows-Terminal" mkdir "%PORTABLE_ROOT%05_UTILITIES\Windows-Terminal"
if not exist "%PORTABLE_ROOT%05_UTILITIES\Fiddler" mkdir "%PORTABLE_ROOT%05_UTILITIES\Fiddler"
if not exist "%PORTABLE_ROOT%05_UTILITIES\pageant" mkdir "%PORTABLE_ROOT%05_UTILITIES\pageant"

echo [OK] All directories verified/created.
echo.
pause
goto MENU

:EXIT_APP
cls
echo Goodbye!
exit /b 0
