export SHELL := /bin/bash

# ============================================================
# VSCode IDE セットアップ用Makefile (IDE基礎設定)
# ============================================================

OS_NAME := $(shell uname -s)
ifeq ($(OS_NAME),Darwin)
    VSCODE_USER_DIR := $(HOME)/Library/Application Support/Code/User
else
    VSCODE_USER_DIR := $(HOME)/.config/Code/User
endif

.PHONY: setup-vscode install-vscode uninstall-vscode

setup-vscode: install-vscode

install-vscode:
	@echo "📝 VSCodeの設定をリンクしています..."
	@mkdir -p "$(VSCODE_USER_DIR)"
	@for f in settings.json keybindings.json; do \
		src="$(REPO_ROOT)/vscode/$$f"; \
		dst="$(VSCODE_USER_DIR)/$$f"; \
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
	@rm -f "$(VSCODE_USER_DIR)/settings.json"
	@rm -f "$(VSCODE_USER_DIR)/keybindings.json"
	@echo "✅ VSCodeの設定解除が完了しました"
