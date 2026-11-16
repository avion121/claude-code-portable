@echo off
setlocal enableextensions
cd /d "%~dp0"
set "PORTABLE_ROOT=%CD%"

rem Keep window open on any early exit
if "%~1"=="/keep" goto :KEEP_OPEN
cmd /k "%~f0" /keep
exit /b 0

:KEEP_OPEN

echo ============================================================
echo      PORTABLE DEV SUITE - FULLY AUTOMATIC LAUNCH
echo ============================================================
echo [*] USB Root: %PORTABLE_ROOT%
echo.

rem Step 1: Auto-update from GitHub
echo [*] Step 1/4: Checking for updates from GitHub...
cd /d "%PORTABLE_ROOT%"
where git >nul 2>nul
if errorlevel 1 (
    echo [WARN] git not in PATH - skipping auto-update. Install Git or run Setup-Runtimes.bat first.
) else (
    git remote set-url origin https://github.com/avion121/claude-code-portable.git 2>nul
    if exist .git (
        git fetch --quiet 2>nul
        if errorlevel 1 (
            echo [WARN] Could not fetch updates (offline). Continuing locally.
        ) else (
            git pull --quiet --ff-only 2>nul
            if errorlevel 1 (
                echo [WARN] Pull failed (merge conflict). Continuing locally.
            ) else (
                echo [OK] Updated to latest version.
            )
        )
    ) else (
        echo [WARN] Not a git repo - skipping update.
    )
)

rem Step 2: Auto-setup runtimes if missing
echo.
echo [*] Step 2/4: Checking runtimes...
if exist "%PORTABLE_ROOT%\02_RUNTIMES\node-v24.9.0-win-x64\node.exe" (
    echo [OK] Node.js already installed.
) else (
    echo [INFO] Node.js missing - running auto-setup...
    if exist "%PORTABLE_ROOT%\00_LAUNCHERS\Setup-Runtimes.bat" (
        call "%PORTABLE_ROOT%\00_LAUNCHERS\Setup-Runtimes.bat"
    )
)
if exist "%PORTABLE_ROOT%\02_RUNTIMES\Git-Portable\cmd\git.exe" (
    echo [OK] Git already installed.
) else (
    echo [INFO] Git missing - running auto-setup...
    if exist "%PORTABLE_ROOT%\00_LAUNCHERS\Setup-Runtimes.bat" (
        call "%PORTABLE_ROOT%\00_LAUNCHERS\Setup-Runtimes.bat"
    )
)
if exist "%PORTABLE_ROOT%\02_RUNTIMES\python-portable\python.exe" (
    echo [OK] Python already installed.
) else (
    echo [INFO] Python missing - running auto-setup...
    if exist "%PORTABLE_ROOT%\00_LAUNCHERS\Setup-Runtimes.bat" (
        call "%PORTABLE_ROOT%\00_LAUNCHERS\Setup-Runtimes.bat"
    )
)
if exist "%PORTABLE_ROOT%\03_AI_TOOLS\freellmapi\dist\index.js" (
    echo [OK] freellmapi already built.
) else (
    echo [INFO] freellmapi missing - running auto-setup...
    if exist "%PORTABLE_ROOT%\00_LAUNCHERS\Setup-Runtimes.bat" (
        call "%PORTABLE_ROOT%\00_LAUNCHERS\Setup-Runtimes.bat"
    )
)

rem Step 3: Health check
echo.
echo [*] Step 3/4: Running health check...
if exist "%PORTABLE_ROOT%\00_LAUNCHERS\Verify-Portable-Env.bat" (
    call "%PORTABLE_ROOT%\00_LAUNCHERS\Verify-Portable-Env.bat"
) else (
    echo [WARN] Verifier not found.
)

rem Step 4: Launch VS Code with Claude Code CLI
echo.
echo [*] Step 4/4: Launching VS Code with Claude Code CLI...
set "PATH=%PORTABLE_ROOT%\02_RUNTIMES\node-v24.9.0-win-x64;%PORTABLE_ROOT%\02_RUNTIMES\Git-Portable\cmd;%PORTABLE_ROOT%\02_RUNTIMES\python-portable;%PATH%"
set "npm_config_cache=%PORTABLE_ROOT%\02_RUNTIMES\node-v24.9.0-win-x64\.npm-cache"

if exist "%PORTABLE_ROOT%\01_EDITORS\VSCode-Portable\Code.exe" (
    start "" "%PORTABLE_ROOT%\01_EDITORS\VSCode-Portable\Code.exe" "%PORTABLE_ROOT%"
    echo [OK] VS Code launched with portable workspace.
) else (
    echo [ERROR] VS Code Portable not found at 01_EDITORS\VSCode-Portable\Code.exe
    pause
    exit /b 1
)

echo.
echo [OK] Portable environment fully loaded.
echo [*] VS Code is running. Use the terminal to run Claude Code CLI:
echo     node 03_AI_TOOLS\freellmapi\dist\index.js launch
echo.
pause
exit /b 0