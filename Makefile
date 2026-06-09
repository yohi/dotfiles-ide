# ============================================================
# dotfiles-ide: IDE 設定・インストール
# ============================================================

.DEFAULT_GOAL := help

REPO_ROOT := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))

# プリフライトチェック: 依存する共通設定ファイルの存在確認
MISSING_MK := $(strip $(foreach mk,_mk/core.mk _mk/help.mk,$(if $(wildcard $(mk)),,$(mk))))
ifneq ($(MISSING_MK),)
$(error エラー: 必須コンポーネントが見つかりません: $(MISSING_MK). \
    これらは ../../../common-mk/ へのシンボリックリンクです。 \
    dotfiles-core が正しく配置されているか、シンボリックリンクが壊れていないか確認してください。)
endif

include _mk/core.mk
include _mk/help.mk
-include _mk/cursor.mk
-include _mk/ide-vscode.mk

.PHONY: help install setup install-ide setup-ide

install: install-ide
setup: setup-ide

install-ide:
	@echo "==> Installing dotfiles-ide"
	$(MAKE) install-cursor

setup-ide:
	@echo "==> Setting up dotfiles-ide"
	$(MAKE) setup-vscode
