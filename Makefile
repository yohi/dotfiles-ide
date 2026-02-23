REPO_ROOT ?= $(CURDIR)
.DEFAULT_GOAL := setup
include _mk/cursor.mk

.PHONY: setup
setup:
	@echo "==> Setting up dotfiles-ide"
	$(MAKE) -f _mk/cursor.mk install-cursor

.PHONY: link
link:
	@echo "==> Linking dotfiles-ide (Skipped, handled manually or none)"
