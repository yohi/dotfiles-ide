# ============================================================
# 共通環境設定
# ============================================================

OS_NAME := $(shell uname -s)

ifeq ($(OS_NAME),Darwin)
    # macOS
    VSCODE_USER_DIR := $(HOME)/Library/Application Support/Code/User
    CURSOR_USER_DIR := $(HOME)/Library/Application Support/Cursor/User
    # macOS (BSD)
    STAT_SIZE  := stat -f%z
    STAT_MTIME := stat -f"%Sm" -t"%Y"
    SHA256_CMD := shasum -a 256
else
    # Linux
    VSCODE_USER_DIR := $(HOME)/.config/Code/User
    CURSOR_USER_DIR := $(HOME)/.config/Cursor/User
    # Linux (GNU)
    STAT_SIZE  := stat -c%s
    STAT_MTIME := stat -c%y
    SHA256_CMD := sha256sum
endif

# timeout コマンドの検出
TIMEOUT_CMD := $(shell command -v timeout 2>/dev/null || command -v gtimeout 2>/dev/null || echo "false")
