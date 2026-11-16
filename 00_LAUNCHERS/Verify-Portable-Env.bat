@echo off
title Portable Environment Verification
cd /d "%~dp0.."
set "DEV_ROOT=%CD%"
set ERR_COUNT=0

echo ============================================================
echo         PORTABLE ENVIRONMENT INTEGRITY CHECK
echo ============================================================
echo.

rem Check Node.js
if exist "%DEV_ROOT%\02_RUNTIMES\node-v24.9.0-win-x64\node.exe" (
    echo [OK] Node.js binary detected.
) else (
    echo [FAIL] Node.js missing at 02_RUNTIMES\node-v24.9.0-win-x64
    set /a ERR_COUNT=ERR_COUNT+1
)

rem Check Git
if exist "%DEV_ROOT%\02_RUNTIMES\Git-Portable\cmd\git.exe" (
    echo [OK] Portable Git detected.
) else (
    echo [FAIL] Git missing at 02_RUNTIMES\Git-Portable
    set /a ERR_COUNT=ERR_COUNT+1
)

rem Check freellmapi built CLI
if exist "%DEV_ROOT%\03_AI_TOOLS\freellmapi\dist\index.js" (
    echo [OK] freellmapi CLI build verified.
) else (
    echo [FAIL] freellmapi build missing at 03_AI_TOOLS\freellmapi\dist\index.js
    set /a ERR_COUNT=ERR_COUNT+1
)

echo.
echo ============================================================
if %ERR_COUNT%==0 (
    echo    SUCCESS: Environment is fully operational and ready.
) else (
    echo    ERROR: Found %ERR_COUNT% issue(s). Review log above.
)
echo ============================================================
echo.
exit /b %ERR_COUNT%