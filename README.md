# dotfiles-ide

VS Code、Cursorなど、IDE（統合開発環境）の設定や拡張機能を管理するコンポーネントリポジトリです。
`dotfiles-core` と連携して動作します。

## 主要機能

- **エディタ設定の同期**: VS Code / Cursor の基本設定 (`settings.json`) やキーバインドの統一。
- **拡張機能管理**: 推奨プラグインリストの一括管理。

## 管理と依存関係

本リポジトリは [dotfiles-core](https://github.com/yohi/dotfiles-core) によって管理されるコンポーネントの一つです。

### ⚠️ 単体使用時の注意点
本リポジトリは `dotfiles-core` の共通 Makefile ルール（`common-mk`）に依存しています。単体で使用（クローン）する場合は、以下の手順が必要です：

1. `common-mk` ディレクトリを本リポジトリの親ディレクトリに配置するか、パスを適切に設定してください。
2. `make help` を実行して、正しく設定されていることを確認してください。

推奨される使用方法は、`dotfiles-core` から `make setup` を実行することです。

## ディレクトリ構成

```text
.
├── Makefile
├── README.md
├── AGENTS.md
├── _mk/                    # Makefile sub-targets
├── cursor/                 # Cursor settings (settings.json, keybindings.json)
└── vscode/                 # VS Code settings (extensions.list, etc.)
```

## 💡 設計思想: `dotfiles-ai` との境界線
当リポジトリ（`dotfiles-ide`）は、**「エディタとしての基本的な器と振る舞い（UI/UX）」** を一元管理する役割を担います。
対して、`dotfiles-ai` は **「AIの振る舞いとルール（頭脳）」** を管理します。
*   **`dotfiles-ide`** (本リポジトリ): VS CodeやCursorのUI設定（`settings.json`）、キーバインド（`keybindings.json`）、拡張機能リストなどを管理。
*   **`dotfiles-ai`**: AIエージェントへの指示（プロンプト）、SkillPortによるスキル管理、MCPハブ設定、エディタ向けAI設定（`mcp.json` や `supercursor` など）を管理。

この「関心の分離」により、すべてのAIツールで統一されたペルソナを維持しつつ、エディタのUI設定と切り離してスケーラブルに運用します。
<<<<<<< Updated upstream

=======
>>>>>>> Stashed changes
