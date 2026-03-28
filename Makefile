# Orchestrator core configuration
# Note: These are symlinked from ../../common-mk/ when managed by dotfiles-core
-include _mk/core.mk
-include _mk/help.mk

# Component-specific logic

# Orchestrator core configuration
# Note: These are symlinked from ../../common-mk/ when managed by dotfiles-core

# Component-specific logic

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
