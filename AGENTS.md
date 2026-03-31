# Agent Instructions: dotfiles-ide

This repository manages the **IDE configurations (VS Code, Cursor)** within the dotfiles system.
It focuses on the "Container/UI" aspect, while `dotfiles-ai` handles the "Brain/AI" logic.

This repository is part of the **dotfiles polyrepo** managed by [dotfiles-core](https://github.com/yohi/dotfiles-core).

## 🛠 Role & Scope
- **Domain:** Editor UI, UX, standard extensions, and keybindings.
- **Tools:** VS Code, Cursor.
- **Relationship:** Depends on `common-mk` from `dotfiles-core`. Complements `dotfiles-ai`.

## 📐 Project Structure
- `cursor/`: Settings for Cursor editor.
- `vscode/`: Settings and extension lists for VS Code.
- `_mk/`: Internal Makefile components linked from `common-mk`.

## 🤖 AI Interaction Guidelines
- **Global Constraints:** This repository inherits all **FORBIDDEN OPERATIONS** (rm, ssh, sudo) and **CODE STYLE GUIDELINES** (Japanese language, Conventional Commits) defined in the root [AGENTS.md](https://github.com/yohi/dotfiles-core/blob/master/AGENTS.md).
- **Context Awareness:** Always check if a configuration change belongs here (UI/Editor) or in `dotfiles-ai` (AI logic/MCP).
- **Architectural Compliance:** All modifications must adhere to the layout defined in the central [ARCHITECTURE.md](https://github.com/yohi/dotfiles-core/blob/master/docs/ARCHITECTURE.md).
- **Idempotency:** Ensure all setup scripts and Makefile targets are idempotent.

## 🔗 Related Components
- [dotfiles-core](https://github.com/yohi/dotfiles-core): Orchestrator and common build logic.
- [dotfiles-ai](https://github.com/yohi/dotfiles-ai): AI personas, skills, and MCP configurations.
