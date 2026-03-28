# ============================================================
# VSCode IDE セットアップ用Makefile (IDE基礎設定)
# ============================================================

include _mk/common.mk

.PHONY: setup-vscode install-vscode uninstall-vscode

setup-vscode: install-vscode

install-vscode:
        @echo "📝 VSCodeの設定をリンクしています..."
        @mkdir -p "$(VSCODE_USER_DIR)"
        @for f in settings.json keybindings.json; do \
                src="$(REPO_ROOT)/vscode/$$f"; \
                dst="$(VSCODE_USER_DIR)/$$f"; \
                if [ ! -e "$$src" ]; then \
                        echo "⚠️  ソースファイルが見つからないためスキップします: $$src"; \
                        continue; \
                fi; \
                if [ -f "$$dst" ] && [ ! -L "$$dst" ]; then \
                        backup="$$dst.bak.$$(date +%Y%m%d_%H%M%S)"; \
                        echo "⚠️  既存の $$f をバックアップします: $$backup"; \
                        mv "$$dst" "$$backup"; \
                fi; \
                ln -sf "$$src" "$$dst"; \
        done
        @echo "✅ VSCodeの設定リンクが完了しました"

uninstall-vscode:
        @echo "🧹 VSCodeの設定リンクを解除しています..."
        @for f in settings.json keybindings.json; do \
                path="$(VSCODE_USER_DIR)/$$f"; \
                if [ -L "$$path" ]; then \
                        echo "🗑️  シンボリックリンクを削除します: $$path"; \
                        rm -f "$$path"; \
                elif [ -e "$$path" ]; then \
                        echo "ℹ️  ファイル（実体）のため削除をスキップします: $$path"; \
                fi; \
        done
        @echo "✅ VSCodeの設定解除が完了しました"
