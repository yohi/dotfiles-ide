# PROJECT KNOWLEDGE BASE

**Repository:** dotfiles-ide
**Role:** IDE configuration — VS Code settings, keybindings, extensions, and Cursor editor settings

## COMPONENT LAYOUT CONVENTION

This repository is part of the **dotfiles polyrepo** orchestrated by [dotfiles-core](https://github.com/yohi/dotfiles-core).
All changes MUST comply with the central layout rules. Please refer to the central [ARCHITECTURE.md](https://raw.githubusercontent.com/yohi/dotfiles-core/refs/heads/master/docs/ARCHITECTURE.md) for the full, authoritative rules and constraints.

## STRUCTURE

```text
dotfiles-ide/
├── _mk/                        # Makefile sub-targets
│   ├── cursor.mk              # Cursor-specific Makefile targets
│   └── ide-vscode.mk          # VS Code-specific Makefile targets
├── cursor/                     # Cursor editor configuration
│   ├── keybindings.json        # Cursor keybindings
│   └── settings.json           # Cursor settings
├── vscode/                     # VS Code configuration
│   ├── extensions.list         # Extension list
│   ├── keybindings.json        # VS Code keybindings
│   └── settings.json           # VS Code settings
└── Makefile                    # Setup entry point
```

## THIS COMPONENT — SPECIAL NOTES

### 💡 Core Design Philosophy: Separation of Concerns
We strictly separate **"IDE Infrastructure & UI"** (`dotfiles-ide`) from **"AI Rules & Behavior"** (`dotfiles-ai`).
- **`dotfiles-ide`** (this repository) manages the physical editor settings (`settings.json`, `keybindings.json`, visual themes).
- **`dotfiles-ai`** manages the mind and tools of the AI (`mcp.json`, `supercursor` framework, Agent instructions, SkillPort).
Never mix AI instructions or MCP configs here, and never put IDE styling configurations in `dotfiles-ai`.

**Note:** If you find any AI-related configuration files (like `mcp.json`, `CLAUDE.md`, or AI frameworks) in this repository, please move them to the `dotfiles-ai` repository.

- `cursor/` and `vscode/` settings are installed via Makefile targets or manual symlink.
- `_mk/cursor.mk` and `_mk/ide-vscode.mk` contain editor-specific install/setup targets.
- IDE settings files (`settings.json`, `keybindings.json`) are managed per-editor in subdirectories.
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
