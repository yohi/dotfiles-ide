REPO_ROOT ?= $(CURDIR)
.DEFAULT_GOAL := setup
include _mk/cursor.mk
include _mk/ide-vscode.mk


.PHONY: setup
setup:
	@echo "==> Setting up dotfiles-ide"
	$(MAKE) -f _mk/cursor.mk install-cursor
	$(MAKE) setup-vscode
.PHONY: link
link:
	@echo "==> Linking dotfiles-ide (Skipped, handled manually or none)"

