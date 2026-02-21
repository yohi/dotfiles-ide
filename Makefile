.DEFAULT_GOAL := setup
include cursor.mk
.PHONY: setup
setup:
	@echo "==> Setting up dotfiles-ide"
	$(MAKE) -f cursor.mk install-cursor || true
