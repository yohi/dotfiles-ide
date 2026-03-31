include _mk/core.mk
include _mk/help.mk
-include _mk/cursor.mk
-include _mk/ide-vscode.mk

install: install-ide ## IDE 関連のインストール
setup: setup-ide ## IDE の設定適用

install-ide:
	@echo "==> Installing dotfiles-ide"
	$(MAKE) -f _mk/cursor.mk install-cursor

setup-ide:
	@echo "==> Setting up dotfiles-ide"
	$(MAKE) setup-vscode
