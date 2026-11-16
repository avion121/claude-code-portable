@echo off
setlocal enableextensions enabledelayedexpansion
title Portable Dev Suite - Auto Runtime Setup

cd /d "%~dp0.."
set "DEV_ROOT=%CD%"

echo ============================================================
echo      PORTABLE DEV SUITE - AUTO RUNTIME SETUP
echo ============================================================
echo.
echo Installing into: %DEV_ROOT%
echo.
set /p CONFIRM="Continue? (Y/N): "
if /i not "%CONFIRM%"=="Y" ( echo Aborted. & pause & exit /b 1 )

echo.
echo [*] Creating directory structure...
if not exist "%DEV_ROOT%\01_EDITORS" mkdir "%DEV_ROOT%\01_EDITORS"
if not exist "%DEV_ROOT%\01_EDITORS\VSCode-Portable" mkdir "%DEV_ROOT%\01_EDITORS\VSCode-Portable"
if not exist "%DEV_ROOT%\02_RUNTIMES" mkdir "%DEV_ROOT%\02_RUNTIMES"
if not exist "%DEV_ROOT%\02_RUNTIMES\node-v24.9.0-win-x64" mkdir "%DEV_ROOT%\02_RUNTIMES\node-v24.9.0-win-x64"
if not exist "%DEV_ROOT%\02_RUNTIMES\python-portable" mkdir "%DEV_ROOT%\02_RUNTIMES\python-portable"
if not exist "%DEV_ROOT%\02_RUNTIMES\Git-Portable" mkdir "%DEV_ROOT%\02_RUNTIMES\Git-Portable"
if not exist "%DEV_ROOT%\03_AI_TOOLS" mkdir "%DEV_ROOT%\03_AI_TOOLS"
if not exist "%DEV_ROOT%\04_DEV_TOOLS" mkdir "%DEV_ROOT%\04_DEV_TOOLS"
if not exist "%DEV_ROOT%\05_UTILITIES" mkdir "%DEV_ROOT%\05_UTILITIES"

set "TEMP_DIR=%DEV_ROOT%\._tmp_downloads"
if not exist "%TEMP_DIR%" mkdir "%TEMP_DIR%"

echo.
echo ============================================================
echo [1/6] Node.js v24.9.0
echo ============================================================
cd /d "%TEMP_DIR%"
curl -L -o node.zip "https://nodejs.org/dist/v24.9.0/node-v24.9.0-win-x64.zip"
if errorlevel 1 (echo [FAIL] download & goto CLEANUP)
call :check_size node.zip 20000000 || goto CLEANUP
tar -xf node.zip -C "%DEV_ROOT%\02_RUNTIMES\node-v24.9.0-win-x64" --strip-components=1
if errorlevel 1 (echo [FAIL] extract & goto CLEANUP)
echo [OK] Node.js extracted.

echo.
echo ============================================================
echo [2/6] Python 3.12.7 (embeddable, no installer)
echo ============================================================
curl -L -o python.zip "https://www.python.org/ftp/python/3.12.7/python-3.12.7-embed-amd64.zip"
if errorlevel 1 (echo [FAIL] download & goto CLEANUP)
call :check_size python.zip 5000000 || goto CLEANUP
tar -xf python.zip -C "%DEV_ROOT%\02_RUNTIMES\python-portable"
if errorlevel 1 (echo [FAIL] extract & goto CLEANUP)
if exist "%DEV_ROOT%\02_RUNTIMES\python-portable\python312._pth" (
    powershell -NoProfile -Command "(Get-Content '%DEV_ROOT%\02_RUNTIMES\python-portable\python312._pth') -replace '#import site','import site' | Set-Content '%DEV_ROOT%\02_RUNTIMES\python-portable\python312._pth'"
)
curl -L -o "%TEMP_DIR%\get-pip.py" "https://bootstrap.pypa.io/get-pip.py"
if errorlevel 1 (echo [WARN] get-pip download failed - pip not installed) else (
    "%DEV_ROOT%\02_RUNTIMES\python-portable\python.exe" "%TEMP_DIR%\get-pip.py" --no-warn-script-location
)
echo [OK] Python 3.12.7 portable ready.

echo.
echo ============================================================
echo [3/6] Git Portable
echo ============================================================
curl -L -o git.exe "https://github.com/git-for-windows/git/releases/download/v2.47.1.windows.1/PortableGit-2.47.1-64-bit.7z.exe"
if errorlevel 1 (echo [FAIL] download & goto CLEANUP)
call :check_size git.exe 40000000 || goto CLEANUP
"%TEMP_DIR%\git.exe" -y -gm2 -InstallPath="%DEV_ROOT%\02_RUNTIMES\Git-Portable"
if errorlevel 1 (echo [FAIL] extract & goto CLEANUP)
echo [OK] Git Portable extracted.

echo.
echo ============================================================
echo [4/6] VS Code Portable
echo ============================================================
curl -L -o vscode.zip "https://update.code.visualstudio.com/latest/win32-x64-archive/stable"
if errorlevel 1 (echo [FAIL] download & goto CLEANUP)
call :check_size vscode.zip 50000000 || goto CLEANUP
tar -xf vscode.zip -C "%DEV_ROOT%\01_EDITORS\VSCode-Portable"
if errorlevel 1 (echo [FAIL] extract & goto CLEANUP)
if not exist "%DEV_ROOT%\01_EDITORS\VSCode-Portable\data" mkdir "%DEV_ROOT%\01_EDITORS\VSCode-Portable\data"
echo [OK] VS Code Portable extracted.

echo.
echo ============================================================
echo [5/6] freellmapi
echo ============================================================
set "PATH=%DEV_ROOT%\02_RUNTIMES\node-v24.9.0-win-x64;%DEV_ROOT%\02_RUNTIMES\Git-Portable\cmd;%PATH%"
cd /d "%DEV_ROOT%\03_AI_TOOLS"
if exist freellmapi ( echo [INFO] freellmapi exists - skipping clone. ) else (
    git clone https://github.com/tashfeenahmed/freellmapi.git freellmapi
    if errorlevel 1 (echo [WARN] clone failed)
)
cd /d "%DEV_ROOT%\03_AI_TOOLS\freellmapi"
call npm install
if errorlevel 1 (echo [WARN] npm install failed)
call npm run build
if errorlevel 1 (echo [WARN] npm run build failed) else (echo [OK] freellmapi built.)

echo.
echo ============================================================
echo [6/6] Cleanup
echo ============================================================
:CLEANUP
cd /d "%DEV_ROOT%"
rmdir /s /q "%TEMP_DIR%" 2>nul

echo.
echo ============================================================
echo  SETUP COMPLETE
echo ============================================================
echo Next steps:
echo  1. Run: PORTABLE-SUITE-MASTER.bat  -^> Option [4] to verify.
echo.
pause
exit /b 0

:check_size
:: %1 = filename in TEMP_DIR, %2 = minimum bytes. Returns 1 if too small.
for %%A in ("%TEMP_DIR%\%~1") do (
    if %%~zA LSS %~2 (
        echo [FAIL] %~1 is only %%~zA bytes - server returned an error page.
        exit /b 1
    )
)
exit /b 0