# dotfiles-ide

VS Code、Cursorなど、IDE（統合開発環境）の設定や拡張機能を管理するコンポーネントリポジトリです。
`dotfiles-core` と連携して動作します。

## 💡 設計思想: `dotfiles-ai` との境界線
当リポジトリ（`dotfiles-ide`）は、**「エディタとしての基本的な器と振る舞い（UI/UX）」** を一元管理する役割を担います。
対して、`dotfiles-ai` は **「AIの振る舞いとルール（頭脳）」** を管理します。
*   **`dotfiles-ide`** (本リポジトリ): VS CodeやCursorのUI設定（`settings.json`）、キーバインド（`keybindings.json`）、拡張機能リストなどを管理。
*   **`dotfiles-ai`**: AIエージェントへの指示（プロンプト）、SkillPortによるスキル管理、MCPハブ設定、エディタ向けAI設定（`mcp.json` や `supercursor` など）を管理。

この「関心の分離」により、すべてのAIツールで統一されたペルソナを維持しつつ、エディタのUI設定と切り離してスケーラブルに運用します。

