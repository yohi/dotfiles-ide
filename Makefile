# Orchestrator core configuration
# Note: These are symlinked from ../../common-mk/ when managed by dotfiles-core
-include _mk/core.mk
-include _mk/help.mk

# Component-specific logic





REPO_ROOT ?= $(CURDIR)
include _mk/cursor.mk

.PHONY: setup
setup: ## セットアップ（依存関係、設定適用）を一括実行します
	@echo "==> Setting up dotfiles-ide"
	$(MAKE) -f _mk/cursor.mk install-cursor

.PHONY: link
link: ## シンボリックリンクを展開し、dotfiles を配置します
	@echo "==> Linking dotfiles-ide (Skipped, handled manually or none)"
