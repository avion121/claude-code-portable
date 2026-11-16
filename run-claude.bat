@echo off
setlocal enableextensions enabledelayedexpansion
cd /d "%~dp0"
for %%I in ("%~dp0") do set "PORTABLE_ROOT=%%~fI"

echo ============================================================
echo      PORTABLE DEV SUITE - AUTO-UPDATE & LAUNCH
echo ============================================================
echo.
echo [*] Detecting OS: Windows
echo [*] USB Root: %PORTABLE_ROOT%
echo.

echo [*] Step 1/3: Checking for updates from GitHub...
git -C "%PORTABLE_ROOT%" remote set-url origin https://github.com/avion121/claude-code-portable.git 2>nul
git -C "%PORTABLE_ROOT%" fetch --quiet --tags 2>nul
if errorlevel 1 (
    echo [WARN] Could not fetch updates (offline or no network). Continuing with local version.
) else (
    set "BEFORE=0"
    for /f "tokens=*" %%A in ('git -C "%PORTABLE_ROOT%" rev-parse HEAD') do set "BEFORE=%%A"
    git -C "%PORTABLE_ROOT%" pull --quiet --ff-only 2>nul
    if errorlevel 1 (
        echo [WARN] Pull failed (merge conflict or offline). Continuing locally.
    ) else (
        for /f "tokens=*" %%A in ('git -C "%PORTABLE_ROOT%" rev-parse HEAD') do set "AFTER=%%A"
        if /i not "%BEFORE%"=="%AFTER%" (
            echo [OK] Updated to latest commit.
        ) else (
            echo [OK] Already at latest version.
        )
    )
)

echo.
echo [*] Step 2/3: Running health checks...
call "%PORTABLE_ROOT%00_LAUNCHERS\Verify-Portable-Env.bat"
if errorlevel 1 (
    echo.
    echo [!] Some runtimes are missing. Run Option [0] in the menu to auto-setup.
    echo.
)

echo.
echo [*] Step 3/3: Launching master control menu...
echo.
call "%PORTABLE_ROOT%PORTABLE-SUITE-MASTER.bat"