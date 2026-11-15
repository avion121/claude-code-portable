@echo off
setlocal enableextensions enabledelayedexpansion
title Portable Dev Suite - Auto Runtime Setup

cd /d "%~dp0.."
set "DEV_ROOT=%CD%"

echo ============================================================
echo      PORTABLE DEV SUITE - AUTO RUNTIME SETUP
echo ============================================================
echo.
echo This will download and extract all required runtimes into:
echo %DEV_ROOT%
echo.
echo WARNING: This downloads ~1.5 GB total. Requires internet.
echo.
set /p CONFIRM="Continue? (Y/N): "
if /i not "%CONFIRM%"=="Y" (
    echo Aborted.
    pause
    exit /b 1
)

echo.
echo [*] Creating directory structure...
if not exist "%DEV_ROOT%\01_EDITORS" mkdir "%DEV_ROOT%\01_EDITORS"
if not exist "%DEV_ROOT%\02_RUNTIMES" mkdir "%DEV_ROOT%\02_RUNTIMES"
if not exist "%DEV_ROOT%\02_RUNTIMES\node-v24.9.0-win-x64" mkdir "%DEV_ROOT%\02_RUNTIMES\node-v24.9.0-win-x64"
if not exist "%DEV_ROOT%\02_RUNTIMES\python-portable" mkdir "%DEV_ROOT%\02_RUNTIMES\python-portable"
if not exist "%DEV_ROOT%\02_RUNTIMES\Git-Portable" mkdir "%DEV_ROOT%\02_RUNTIMES\Git-Portable"
if not exist "%DEV_ROOT%\03_AI_TOOLS" mkdir "%DEV_ROOT%\03_AI_TOOLS"
if not exist "%DEV_ROOT%\04_DEV_TOOLS" mkdir "%DEV_ROOT%\04_DEV_TOOLS"
if not exist "%DEV_ROOT%\05_UTILITIES" mkdir "%DEV_ROOT%\05_UTILITIES"
if not exist "%DEV_ROOT%\05_UTILITIES\Windows-Terminal" mkdir "%DEV_ROOT%\05_UTILITIES\Windows-Terminal"
if not exist "%DEV_ROOT%\05_UTILITIES\Fiddler" mkdir "%DEV_ROOT%\05_UTILITIES\Fiddler"
if not exist "%DEV_ROOT%\05_UTILITIES\pageant" mkdir "%DEV_ROOT%\05_UTILITIES\pageant"
if not exist "%DEV_ROOT%\05_UTILITIES\7-Zip-Portable" mkdir "%DEV_ROOT%\05_UTILITIES\7-Zip-Portable"

set "TEMP_DIR=%DEV_ROOT%\._tmp_downloads"
if not exist "%TEMP_DIR%" mkdir "%TEMP_DIR%"

echo.
echo ============================================================
echo [1/10] Downloading Node.js v24.9.0...
echo ============================================================
cd /d "%TEMP_DIR%"
curl -L -o node.zip "https://nodejs.org/dist/v24.9.0/node-v24.9.0-win-x64.zip"
if errorlevel 1 (echo [FAIL] Node.js download failed & goto CLEANUP)
tar -xf node.zip -C "%DEV_ROOT%\02_RUNTIMES\node-v24.9.0-win-x64" --strip-components=1
echo [OK] Node.js extracted.

echo.
echo ============================================================
echo [2/10] Downloading WinPython (portable Python 3.12)...
echo ============================================================
curl -L -o winpython.exe "https://github.com/winpython/winpython/releases/download/3.12.7.0/Winpython32-3.12.7.0.exe"
if errorlevel 1 (echo [FAIL] WinPython download failed & goto CLEANUP)
echo [INFO] WinPython is an installer. Run it manually and choose:
echo         Destination: %DEV_ROOT%\02_RUNTIMES\python-portable
echo         (Then press any key to continue...)
pause
start "" "%TEMP_DIR%\winpython.exe"
echo [OK] WinPython installer launched. Complete it manually.

echo.
echo ============================================================
echo [3/10] Downloading Git Portable...
echo ============================================================
curl -L -o git.zip "https://github.com/git-for-windows/git/releases/download/v2.47.1.windows.1/PortableGit-2.47.1-64-bit.7z.exe"
if errorlevel 1 (echo [FAIL] Git download failed & goto CLEANUP)
7z x git.zip -o"%DEV_ROOT%\02_RUNTIMES\Git-Portable" -y
echo [OK] Git Portable extracted.

echo.
echo ============================================================
echo [4/10] Downloading VS Code Portable...
echo ============================================================
curl -L -o vscode.zip "https://code.visualstudio.com/sha/download?build=stable&os=win32-x64-archive"
if errorlevel 1 (echo [FAIL] VS Code download failed & goto CLEANUP)
7z x vscode.zip -o"%DEV_ROOT%\01_EDITORS\VSCode-Portable" -y
if not exist "%DEV_ROOT%\01_EDITORS\VSCode-Portable\data" mkdir "%DEV_ROOT%\01_EDITORS\VSCode-Portable\data"
echo [OK] VS Code Portable extracted with data folder.

echo.
echo ============================================================
echo [5/10] Downloading Windows Terminal...
echo ============================================================
curl -L -o wt.msixbundle "https://github.com/microsoft/terminal/releases/download/v1.22.10982.0/Microsoft.WindowsTerminal_1.22.10982.0_8wekyb3d8bbwe.msixbundle"
if errorlevel 1 (echo [FAIL] Windows Terminal download failed & goto CLEANUP)
7z x wt.msixbundle -o"%DEV_ROOT%\05_UTILITIES\Windows-Terminal" -y
echo [OK] Windows Terminal extracted.

echo.
echo ============================================================
echo [6/10] Downloading Fiddler Classic...
echo ============================================================
curl -L -o fiddler.zip "https://www.telerik.com/download/fiddler/fiddler4/fiddler4.zip"
if errorlevel 1 (echo [WARN] Fiddler download may need manual step & goto SKIP_FIDDLER)
7z x fiddler.zip -o"%DEV_ROOT%\05_UTILITIES\Fiddler" -y
echo [OK] Fiddler extracted.
:SKIP_FIDDLER

echo.
echo ============================================================
echo [7/10] Downloading Pageant (PuTTY)...
echo ============================================================
curl -L -o putty.zip "https://the.earth.li/~sgtatham/putty/latest/w64/putty.zip"
if errorlevel 1 (echo [FAIL] PuTTY download failed & goto CLEANUP)
7z x putty.zip -o"%TEMP_DIR%\putty" -y
copy "%TEMP_DIR%\putty\pageant.exe" "%DEV_ROOT%\05_UTILITIES\pageant\pageant.exe"
echo [OK] Pageant copied.

echo.
echo ============================================================
echo [8/10] Downloading 7-Zip Portable...
echo ============================================================
curl -L -o 7zip.exe "https://www.7-zip.org/a/7z2408.exe"
if errorlevel 1 (echo [FAIL] 7-Zip download failed & goto CLEANUP)
7z x 7zip.exe -o"%DEV_ROOT%\05_UTILITIES\7-Zip-Portable" -y
echo [OK] 7-Zip extracted.

echo.
echo ============================================================
echo [9/10] Setting up freellmapi...
echo ============================================================
cd /d "%DEV_ROOT%\03_AI_TOOLS"
git clone https://github.com/freellmapi/freellmapi.git freellmapi
if errorlevel 1 (echo [WARN] freellmapi clone failed - may need manual setup)
cd /d "%DEV_ROOT%\03_AI_TOOLS\freellmapi"
npm install
npm run build
echo [OK] freellmapi built.

echo.
echo ============================================================
echo [10/10] Cleaning up...
echo ============================================================
:CLEANUP
cd /d "%DEV_ROOT%"
rmdir /s /q "%TEMP_DIR%" 2>nul

echo.
echo ============================================================
echo  SETUP COMPLETE
echo ============================================================
echo.
echo Next steps:
echo 1. Run WinPython installer if it didn't auto-complete
echo 2. Run Fiddler installer if download was skipped
echo 3. Run: PORTABLE-SUITE-MASTER.bat -> Option [7] to verify
echo.
pause