# ============================================================
# dotfiles-ide: IDE 設定・インストール
# ============================================================

REPO_ROOT := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))

include _mk/core.mk
include _mk/help.mk
-include _mk/cursor.mk
-include _mk/ide-vscode.mk

.PHONY: install setup install-ide setup-ide

install: install-ide ## IDE 関連のインストール
setup: setup-ide ## IDE の設定適用

install-ide:
	@echo "==> Installing dotfiles-ide"
	$(MAKE) install-cursor

setup-ide:
	@echo "==> Setting up dotfiles-ide"
	$(MAKE) setup-vscode
