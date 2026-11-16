# Portable Claude Code CLI & Dev Suite

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/Platform-Windows%20%7C%20Linux%20%7C%20macOS-0078D6.svg)]()

A complete, zero-footprint, USB-portable development environment equipped with **Claude Code CLI** (invoked securely via `freellmapi`), Node.js runtime, **Python backend runtime**, Git, and VS Code.

Designed to run off any pendrive or external drive on **Windows, Linux, and macOS** **without administrative privileges** and without leaving traces in system directories or registries.

---

## What's Included

| Component | Purpose |
|---|---|
| **Claude Code CLI** | AI coding assistant, driven by `freellmapi` (zero-trace credential injection) |
| **VS Code** | Fully portable editor (settings/extensions stay on USB via `data/` folder) |
| **Node.js 24.9.0** | JavaScript/TypeScript runtime |
| **Python 3.12.7** | Backend runtime (embeddable, no installer) |
| **Git 2.47.1** | Version control (portable build) |

---

## Key Features

- **100% Portable**: No installer required. Runs directly from USB drive letters.
- **Dual Runtimes**: Portable **Node.js (v24.9.0)** + **Python 3.12.7 (embeddable)** for full-stack frontend & backend development.
- **Zero-Footprint Credential Security**: Integrates `freellmapi` CLI which injects API keys directly into child process memory without persisting tokens or keys to disk.
- **Claude Code CLI Integration**: Fully replaces any desktop executable with the official Claude Code CLI driven by the zero-trace `freellmapi launch` mechanism.
- **Dynamic Path Resolution**: Launcher scripts resolve USB drive letters dynamically (`%~dp0`), ensuring seamless execution whether mounted as `E:`, `F:`, or `H:`.
- **Isolated Caches**: Redirects global `npm` caches and VS Code extension data to the USB drive.
- **Fully Automatic**: `run-claude.bat` checks for updates, auto-installs missing runtimes, runs health checks, and launches VS Code — all in one click.

---

## Repository & USB Directory Layout

```text
claude-code-portable/
├── run-claude.bat                  # Root launcher (auto-update + auto-setup + launch VS Code)
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
│   ├── Verify-Portable-Env.bat     # Diagnostic integrity check script
│   └── Setup-Runtimes.bat          # Auto-download & extract all runtimes
│
├── 01_EDITORS/                     # VS Code Portable (zip + 'data' dir)
├── 02_RUNTIMES/
│   ├── node-v24.9.0-win-x64/       # Portable Node.js
│   ├── python-portable/            # Portable Python (embeddable)
│   └── Git-Portable/               # Portable Git Bash & Unix CLI utilities
├── 03_AI_TOOLS/                    # freellmapi built CLI monorepo & configs
└── 04_DEV_TOOLS/                   # Reserved for additional dev tools
```

---

## Quick Start Guide

### 1. Clone to Your USB Drive
```cmd
# Windows
git clone https://github.com/avion121/claude-code-portable.git E:\
# Linux / macOS
git clone https://github.com/avion121/claude-code-portable.git /media/your_usb
```

### 2. Auto-Update & Launch (One Command)
Double-click the root launcher — it **checks for updates, auto-installs missing runtimes, runs health checks, and launches VS Code** all in one go:

| OS | Command |
|---|---|
| **Windows** | `run-claude.bat` |
| **Linux / macOS** | `./run-claude.sh` |

### 3. Manual Menu
For individual control, run the master menu:

| OS | Command |
|---|---|
| **Windows** | `PORTABLE-SUITE-MASTER.bat` |
| **Linux / macOS** | `./PORTABLE-SUITE-MASTER.sh` |

Menu options:
- `[1]` Launch Claude Code CLI (via freellmapi zero-trace)
- `[2]` Launch Portable VS Code
- `[3]` Open Developer Command Prompt (Node + Python + Git)
- `[4]` Run System Health & Environment Check
- `[0]` Exit

### 4. Launching Claude Code CLI
- **Automatic**: Double-click `run-claude.bat` — it auto-installs everything and opens VS Code.
- **Manual**: Run Option `[1]` from `PORTABLE-SUITE-MASTER.bat`.
  - Runs a dry-run check to verify configuration.
  - Launches Claude Code CLI with in-memory key injection via `freellmapi`.

---

## Cross-Platform Support

The suite runs on **Windows, Linux, and macOS**. Platform-specific scripts:

| Purpose | Windows | Linux / macOS |
|---|---|---|
| Root launcher (auto-update + auto-setup + launch) | `run-claude.bat` | `./run-claude.sh` |
| Master control menu | `PORTABLE-SUITE-MASTER.bat` | `./PORTABLE-SUITE-MASTER.sh` |
| Health check | `Verify-Portable-Env.bat` | `Verify-Portable-Env.sh` |
| Auto runtime setup | `Setup-Runtimes.bat` | `Setup-Runtimes.sh` |

On Linux/macOS the suite uses **system-installed** Node, Python, and Git (no admin required) — it copies them into the portable folders during setup. Claude Code CLI still runs via `freellmapi` for zero-trace credential injection.

---

## How to Push This Repository to GitHub (`avion121`)

```bash
git init
git add .
git commit -m "feat: portable claude code cli suite with freellmapi"
git branch -M main
git remote add origin https://github.com/avion121/claude-code-portable.git
git push -u origin main
```

---

## License

MIT License. See [LICENSE](LICENSE) for details.