# PROJECT KNOWLEDGE BASE

**Repository:** dotfiles-ide
**Role:** IDE configuration — VS Code settings, keybindings, extensions, and Cursor editor settings

## STRUCTURE

```text
dotfiles-ide/
├── _mk/                        # Makefile sub-targets
│   └── cursor.mk              # Cursor-specific Makefile targets
├── cursor/                     # Cursor editor configuration
│   ├── CLAUDE.md               # Claude Code context for Cursor
│   ├── commands/               # Custom command definitions
│   ├── keybindings.json        # Cursor keybindings
│   ├── mcp.json                # MCP server configuration
│   ├── mcp.json.template       # MCP config template
│   ├── settings.json           # Cursor settings
│   └── supercursor/            # SuperCursor agent framework
├── vscode/                     # VS Code configuration
│   ├── extensions.list         # Extension list
│   ├── keybindings.json        # VS Code keybindings
│   ├── settings.json           # VS Code settings
│   ├── copilot-instructions/   # GitHub Copilot instruction files
│   ├── settings/               # SuperCopilot scripts
│   └── setup-supercopilot.sh   # SuperCopilot setup script
└── Makefile                    # Setup entry point
```

## COMPONENT LAYOUT CONVENTION

This repository is part of the **dotfiles polyrepo** orchestrated by `dotfiles-core`.
All changes MUST comply with the central layout rules. Please refer to the central [ARCHITECTURE.md](https://raw.githubusercontent.com/yohi/dotfiles-core/refs/heads/master/docs/ARCHITECTURE.md) for the full, authoritative rules and constraints.

## THIS COMPONENT — SPECIAL NOTES

- `cursor/` and `vscode/` settings are installed via Makefile targets or manual symlink.
- `_mk/cursor.mk` contains Cursor-specific install/setup targets, included by the root Makefile.
- IDE settings files (`settings.json`, `keybindings.json`) are managed per-editor in subdirectories.
- `mcp.json.template` is the editable template; `mcp.json` may be generated from it.
- Symlinks are managed explicitly via `ln -sfn` in the Makefile.

## CODE STYLE

- **Documentation / README**: Japanese (日本語)
- **AGENTS.md**: English
- **Commit Messages**: Japanese, Conventional Commits (e.g., `feat: 新機能追加`, `fix: バグ修正`)
- **Shell**: `set -euo pipefail`, dynamic path resolution, idempotent operations

## FORBIDDEN OPERATIONS

Per `opencode.jsonc` (when present), these operations are blocked for agent execution:

- `rm` (destructive file operations)
- `ssh` (remote access)
- `sudo` (privilege escalation)
