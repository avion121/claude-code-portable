# Changelog

All notable changes to the `claude-code-portable` project will be documented in this file.

## [1.2.0] - 2026-11-15

### Added & Updated
- **Claude Code CLI Integration**: Fully replaced Claude Code desktop executable with official Claude Code CLI driven by zero-trace `freellmapi launch`.
- Added portable **Windows Terminal**, **Fiddler Classic**, and **Pageant SSH Agent** utilities in `05_UTILITIES/`.
- Updated master launcher `PORTABLE-SUITE-MASTER.bat` menu and launch handlers for Claude Code CLI.
- Updated documentation (`README.md`), manifest (`manifest.json`), and package config (`package.json`) to version 1.2.0.

## [1.1.0] - 2026-11-15

### Added
- Integrated **Portable Python runtime** (`02_RUNTIMES/python-portable`) for backend development (FastAPI, Flask, Django, Data Science).
- Updated `PORTABLE-SUITE-MASTER.bat` with Python PATH injection and diagnostic checks (`python --version`).
- Updated component manifest to version 1.1 with Python backend runtime support.

## [1.0.0] - 2026-11-15

### Added
- Created master launcher `run-claude.bat` and `PORTABLE-SUITE-MASTER.bat` with dry-run verification.
- Added `00_LAUNCHERS/Launch-Dev-Prompt.bat` for isolated CLI environment.
- Added `00_LAUNCHERS/Launch-VSCode.bat` for portable VS Code.
- Added `00_LAUNCHERS/Verify-Portable-Env.bat` for system diagnostics.
- Added zero-footprint credential injection via `freellmapi`.
- Initialized manifest and production repository files.
