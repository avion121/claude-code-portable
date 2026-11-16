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
git -C "%PORTABLE_ROOT%" remote set-url origin https://github.com/avion121/claude-code-portable.git >nul 2>&1
git -C "%PORTABLE_ROOT%" fetch --quiet --tags >nul 2>&1
if errorlevel 1 (
    echo [WARN] Could not fetch updates (offline or no network). Continuing with local version.
) else (
    git -C "%PORTABLE_ROOT%" rev-parse HEAD > "%TEMP%\_cc_before.txt" 2>nul
    git -C "%PORTABLE_ROOT%" pull --quiet --ff-only >nul 2>&1
    if errorlevel 1 (
        echo [WARN] Pull failed (merge conflict or offline). Continuing locally.
    ) else (
        git -C "%PORTABLE_ROOT%" rev-parse HEAD > "%TEMP%\_cc_after.txt" 2>nul
        rem fc returns 0 = same, 1 = different
        fc /w "%TEMP%\_cc_before.txt" "%TEMP%\_cc_after.txt" >nul 2>&1
        if errorlevel 1 (
            echo [OK] Updated to latest commit.
        ) else (
            echo [OK] Already at latest version.
        )
    )
    del "%TEMP%\_cc_before.txt" "%TEMP%\_cc_after.txt" 2>nul
)

echo.
echo [*] Step 2/3: Running health checks...
if exist "%PORTABLE_ROOT%\00_LAUNCHERS\Verify-Portable-Env.bat" (
    call "%PORTABLE_ROOT%\00_LAUNCHERS\Verify-Portable-Env.bat"
    if errorlevel 1 (
        echo.
        echo [!] Some runtimes are missing. Run Option [0] in the menu to auto-setup.
        echo.
    )
) else (
    echo [WARN] Health check script not found.
)

echo.
echo [*] Step 3/3: Launching master control menu...
echo.
if exist "%PORTABLE_ROOT%\PORTABLE-SUITE-MASTER.bat" (
    call "%PORTABLE_ROOT%\PORTABLE-SUITE-MASTER.bat"
) else (
    echo [ERROR] Master menu not found at %PORTABLE_ROOT%\PORTABLE-SUITE-MASTER.bat
    pause
)