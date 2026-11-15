# Portable Claude Code CLI & Dev Suite

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/Platform-Windows%2010%2F11-0078D6.svg)]()

A complete, zero-footprint, USB-portable development environment equipped with **Claude Code CLI** (invoked securely via `freellmapi`), Node.js runtime, **Python backend runtime**, Git Bash, VS Code Portable, Windows Terminal, Fiddler Classic, and Pageant SSH Agent.

Designed to run off any pendrive or external drive on any Windows PC **without administrative privileges** and without leaving traces in system directories or registries.

---

## Key Features

- **100% Portable**: No installer required. Runs directly from USB drive letters.
- **Dual Runtimes**: Portable **Node.js (v24.9.0)** + **Python 3.x (WinPython / Embedded Python)** for full-stack frontend & backend development.
- **Zero-Footprint Credential Security**: Integrates `freellmapi` CLI which injects API keys directly into child process memory without persisting tokens or keys to disk.
- **Claude Code CLI Integration**: Fully replaces any desktop executable with the official Claude Code CLI driven by the zero-trace `freellmapi launch` mechanism.
- **Developer Utilities**: Includes Windows Terminal, Fiddler Classic proxy debugger, and Pageant SSH key agent.
- **Dynamic Path Resolution**: Launcher scripts resolve USB drive letters dynamically (`%~dp0`), ensuring seamless execution whether mounted as `E:`, `F:`, or `H:`.
- **Isolated Caches**: Redirects global `npm` caches and VS Code extension data to the USB drive.

---

## Repository & USB Directory Layout

```text
claude-code-portable/
├── run-claude.bat                  # Root master launcher for Claude Code CLI
├── PORTABLE-SUITE-MASTER.bat       # Master interactive control menu
├── README.md                       # Documentation
├── package.json                    # Project metadata & npm script shortcuts
├── manifest.json                   # Component version manifest
├── CHANGELOG.md                    # Release history
├── .gitignore                      # Git exclusion rules
│
├── 00_LAUNCHERS/
│   ├── Launch-Dev-Prompt.bat       # Opens Command Prompt with portable Node & Python PATH
│   ├── Launch-VSCode.bat           # Launches isolated portable VS Code
│   ├── Launch-WindowsTerminal.bat  # Launches portable Windows Terminal
│   ├── Launch-Fiddler.bat          # Launches portable Fiddler Classic
│   ├── Launch-Pageant.bat          # Launches portable Pageant SSH Agent
│   └── Verify-Portable-Env.bat     # Diagnostic integrity check script
│
├── 01_EDITORS/                     # VS Code Portable (zip + 'data' dir)
├── 02_RUNTIMES/
│   ├── node-v24.9.0-win-x64/       # Portable Node.js
│   ├── python-portable/            # Portable Python (WinPython / Embedded Python)
│   └── Git-Portable/               # Portable Git Bash & Unix CLI utilities
├── 03_AI_TOOLS/                    # freellmapi built CLI monorepo & configs
├── 04_DEV_TOOLS/                   # Bruno API client, DBeaver DB client
└── 05_UTILITIES/
    ├── 7-Zip-Portable/             # Portable 7-Zip archiver
    ├── Windows-Terminal/           # Portable Windows Terminal (wt.exe)
    ├── Fiddler/                    # Portable Fiddler Classic
    └── pageant/                    # Portable Pageant SSH Agent
```

---

## Quick Start Guide

### 1. First-Time Setup (New PC / Fresh USB)
On a new computer, run the **auto-setup** which downloads and extracts all runtimes:
```cmd
PORTABLE-SUITE-MASTER.bat
# Select Option [0] for Auto-Download & Setup All Runtimes
```
This downloads ~1.5 GB and populates all folders automatically. Requires internet.

### 2. Verification
After setup, verify everything is in place:
```cmd
PORTABLE-SUITE-MASTER.bat
# Select Option [7] for System Integrity Diagnostics
```

### 3. Launching Claude Code CLI
Double-click `run-claude.bat` or run Option `[1]` from `PORTABLE-SUITE-MASTER.bat`.
- Runs a dry-run check to verify configuration.
- Launches Claude Code CLI with in-memory key injection via `freellmapi`.

### 3. Launching Portable Developer Tools & Backend Runtimes
- **Claude Code CLI**: Option `[1]`
- **Portable VS Code**: Option `[2]`
- **Windows Terminal**: Option `[3]`
- **Fiddler Proxy**: Option `[4]`
- **Pageant SSH Agent**: Option `[5]`
- **Portable Console**: Option `[6]` (`node -v`, `python --version`, `git --version` in PATH).

---

## How to Push This Repository to GitHub (`avion121`)

Option `[8]` in `PORTABLE-SUITE-MASTER.bat` automatically handles initializing git, committing, and pushing to:
`https://github.com/avion121/claude-code-portable.git`

Or manually via terminal:
```bash
git init
git add .
git commit -m "feat: replace claude code desktop with cli via freellmapi"
git branch -M main
git remote add origin https://github.com/avion121/claude-code-portable.git
git push -u origin main
```

---

## License

MIT License. See [LICENSE](LICENSE) for details.
