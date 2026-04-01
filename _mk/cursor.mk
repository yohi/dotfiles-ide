export SHELL := /bin/sh

# ============================================================
# Cursor IDE セットアップ用Makefile
# Cursor IDEのインストール、アップデート、管理を担当
#
# Maintainer Note: 実行シェルとして /bin/sh を明示的に指定し、
# POSIX準拠の動作を保証しています。
# ============================================================

include _mk/common.mk

# MB換算用定数 (1024 * 1024)
BYTES_TO_MB := 1048576

# Cursor API URL
CURSOR_API_URL := https://www.cursor.com/api/download?platform=linux-deb-x64&releaseTrack=stable

# Cursor IDEのインストール
.PHONY: install-packages-cursor _cursor_download _cursor_link_settings \
	update-cursor stop-cursor check-cursor-version \
	setup-cursor

install-packages-cursor:
	@echo "📝 Cursor IDEのインストールを開始します..."
	@if command -v cursor >/dev/null 2>&1; then \
		echo "✅ Cursor IDEは既にインストールされています"; \
	else \
		$(MAKE) _cursor_download; \
	fi
	@$(MAKE) _cursor_link_settings
	@echo "✅ Cursor IDEのインストールが完了しました"
setup-cursor: _cursor_link_settings ## Cursorの設定をセットアップ（設定ファイルのみ）

_cursor_link_settings:
	@echo "📝 Cursorの設定をリンクしています..."
	@mkdir -p "$(CURSOR_USER_DIR)"
	@for f in settings.json keybindings.json; do \
	        src="$(REPO_ROOT)/cursor/$$f"; \
	        dst="$(CURSOR_USER_DIR)/$$f"; \
	        if [ ! -f "$$src" ]; then \
	                echo "⚠️  ソースファイルが見つからないためスキップします: $$src"; \
	                continue; \
	        fi; \
	        if [ -f "$$dst" ] && [ ! -L "$$dst" ]; then \
	                backup="$$dst.bak.$$(date +%Y%m%d_%H%M%S)"; \
	                echo "⚠️  既存の $$f をバックアップします: $$backup"; \
	                mv "$$dst" "$$backup" || exit 1; \
	        fi; \
	        ln -sf "$$src" "$$dst" || exit 1; \
	done
	@echo "✅ Cursor設定のリンクが完了しました"

_cursor_download:
	@echo "📦 最新のCursor .debパッケージをダウンロード中..."
	@cd /tmp && \
	echo "🌐 最新のダウンロード情報を取得中..." && \
	DOWNLOAD_URL=""; \
	API_RESPONSE=$$(curl -sL "$(CURSOR_API_URL)" 2>/dev/null); \
	if [ -n "$$API_RESPONSE" ]; then \
		if command -v jq >/dev/null 2>&1; then \
			DOWNLOAD_URL=$$(echo "$$API_RESPONSE" | jq -r '.downloadUrl' 2>/dev/null); \
		else \
			DOWNLOAD_URL=$$(echo "$$API_RESPONSE" | grep -o '"downloadUrl":"[^"]*"' | cut -d'"' -f4); \
		fi; \
	fi; \
	if [ -z "$$DOWNLOAD_URL" ] || [ "$$DOWNLOAD_URL" = "null" ]; then \
		echo "⚠️  APIからのURL取得に失敗しました。フォールバックを使用します..."; \
		DOWNLOAD_URL="https://downloader.cursor.sh/linux/deb/x64"; \
	fi; \
	echo "📥 ダウンロード中: $$DOWNLOAD_URL" && \
	if curl -L --user-agent "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36" \
		--max-time 120 --retry 2 --retry-delay 3 \
		-o cursor.deb "$$DOWNLOAD_URL" 2>/dev/null; then \
		echo "🔐 ダウンロードファイルの整合性を検証中 (SHA256)..."; \
		ACTUAL_HASH=$$( $(SHA256_CMD) cursor.deb | awk '{print $$1}'); \
		VALID_DOWNLOAD=0; \
		if [ -n "$(CURSOR_SHA256)" ]; then \
			if [ "$$ACTUAL_HASH" != "$(CURSOR_SHA256)" ]; then \
				echo "❌ ハッシュ不一致エラー"; \
				echo "   期待値: $(CURSOR_SHA256)"; \
				echo "   実際値: $$ACTUAL_HASH"; \
				rm -f cursor.deb; \
				exit 1; \
			else \
				echo "✅ ハッシュ検証に成功しました"; \
				VALID_DOWNLOAD=1; \
			fi; \
		elif [ "$(CURSOR_NO_VERIFY_HASH)" = "true" ]; then \
			echo "⚠️  【セキュリティ警告】SHA256チェックサムが設定されていません。そのままインストールを続行します。"; \
			VALID_DOWNLOAD=1; \
		else \
			echo "❌ エラー: CURSOR_SHA256 が設定されていません"; \
			echo "   セキュリティポリシーにより、整合性検証のないインストールはブロックされます。"; \
			echo "   CURSOR_NO_VERIFY_HASH=true でスキップできます。"; \
			rm -f cursor.deb; \
			exit 1; \
		fi; \
		if [ "$$VALID_DOWNLOAD" -eq 1 ]; then \
			echo "📦 パッケージをインストール中..."; \
			sudo apt-get update && sudo apt-get install -y ./cursor.deb; \
			rm -f cursor.deb; \
			exit 0; \
		fi; \
	fi; \
	echo "❌ Cursor IDEのインストールに失敗しました"; \
	exit 1

	# Cursor IDEのアップデート

update-cursor:
	@echo "🔄 Cursor IDEのアップデートを開始します..."
	@CURSOR_UPDATED=false && \
	\
	echo "🔍 現在のCursor IDEを確認中..." && \
	if command -v cursor >/dev/null 2>&1; then \
		echo "🔄 Cursor IDEの実行状況を確認中..." && \
		if pgrep -f "cursor" >/dev/null 2>&1; then \
			echo "⚠️  Cursor IDEが実行中です。アップデートを続行するには、まずCursor IDEを終了してください。"; \
			echo ""; \
			echo "💡 自動的にCursor IDEを終了するには: make stop-cursor"; \
			exit 1; \
		fi && \
		echo "📦 最新バージョンのダウンロード情報を取得中..." && \
		cd /tmp && \
		rm -f cursor-new.deb 2>/dev/null && \
		\
		echo "🌐 Cursor APIから最新バージョン情報を取得中..." && \
		if command -v jq >/dev/null 2>&1; then \
			API_RESPONSE=$$(curl -sL "$(CURSOR_API_URL)" 2>/dev/null); \
			if [ -n "$$API_RESPONSE" ] && echo "$$API_RESPONSE" | jq . >/dev/null 2>&1; then \
				DOWNLOAD_URL=$$(echo "$$API_RESPONSE" | jq -r '.downloadUrl' 2>/dev/null); \
				VERSION=$$(echo "$$API_RESPONSE" | jq -r '.version' 2>/dev/null); \
				if [ "$$DOWNLOAD_URL" != "null" ] && [ "$$DOWNLOAD_URL" != "" ]; then \
					echo "📋 最新バージョン: $$VERSION"; \
					echo "🔗 ダウンロードURL: $$DOWNLOAD_URL"; \
				else \
					DOWNLOAD_URL=""; \
				fi; \
			else \
				echo "⚠️  API応答の解析に失敗しました。フォールバック方式を使用します..."; \
				DOWNLOAD_URL=""; \
			fi; \
		else \
			echo "⚠️  jqがインストールされていないため、フォールバック方式を使用します..."; \
			DOWNLOAD_URL=""; \
		fi && \
		\
		if [ -z "$$DOWNLOAD_URL" ]; then \
			echo "🔄 フォールバック: 直接ダウンロードを試行中..."; \
			DOWNLOAD_URL="https://downloader.cursor.sh/linux/deb/x64"; \
		fi && \
		\
		echo "📥 ダウンロード中: $$DOWNLOAD_URL" && \
		if curl -L --user-agent "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36" \
			--max-time 120 --retry 3 --retry-delay 5 \
			-o cursor-new.deb "$$DOWNLOAD_URL" 2>/dev/null; then \
			echo "🔐 ダウンロードファイルの整合性を検証中 (SHA256)..."; \
			ACTUAL_HASH=$$( $(SHA256_CMD) cursor-new.deb | awk '{print $$1}'); \
			if [ -n "$(CURSOR_SHA256)" ]; then \
				if [ "$$ACTUAL_HASH" != "$(CURSOR_SHA256)" ]; then \
					echo "❌ ハッシュ不一致エラー"; \
					echo "   期待値: $(CURSOR_SHA256)"; \
					echo "   実際値: $$ACTUAL_HASH"; \
					rm -f cursor-new.deb; \
					exit 1; \
				fi; \
			elif [ "$(CURSOR_NO_VERIFY_HASH)" != "true" ]; then \
				echo "❌ エラー: CURSOR_SHA256 が設定されていません"; \
				echo "   セキュリティポリシーにより、整合性検証のないアップデートはブロックされます。"; \
				echo "   CURSOR_NO_VERIFY_HASH=true でスキップできます。"; \
				rm -f cursor-new.deb; \
				exit 1; \
			fi; \
			echo "📦 パッケージをアップデート中..."; \
			sudo apt-get update && sudo apt-get install -y ./cursor-new.deb; \
			rm -f cursor-new.deb && \
			CURSOR_UPDATED=true && \
			echo "🎉 Cursor IDEのアップデートが完了しました"; \
		else \
			echo "❌ ダウンロードに失敗しました"; \
		fi; \
	else \
		echo "❌ Cursor IDEがインストールされていません"; \
		echo "   'make install-packages-cursor' でインストールしてください"; \
	fi && \
	\
	if [ "$$CURSOR_UPDATED" = "false" ]; then \
		echo "💡 手動アップデート手順:"; \
		echo "1. ブラウザで https://www.cursor.com/ を開く"; \
		echo "2. 'Download for Linux (.deb)' をクリック"; \
		echo "3. sudo apt install ./cursor.deb でインストール"; \
	fi

# Cursor IDEを停止
stop-cursor:
	@echo "🛑 Cursor IDEを停止しています..."
	@CURSOR_RUNNING=false && \
	\
	if pgrep -f "cursor" >/dev/null 2>&1; then \
		CURSOR_RUNNING=true; \
		echo "📋 実行中のCursor関連プロセスを終了中..."; \
		\
		echo "🔄 Cursor IDEの優雅な終了を試行中..."; \
		pkill -TERM -f "cursor" 2>/dev/null; \
		sleep 3; \
		\
		if pgrep -f "cursor" >/dev/null 2>&1; then \
			echo "⚠️  一部のプロセスが残っています。強制終了中..."; \
			pkill -9 -f "cursor" 2>/dev/null; \
			sleep 2; \
		fi; \
		\
		if pgrep -f "cursor" >/dev/null 2>&1; then \
			echo "⚠️  まだ一部のプロセスが残っています"; \
			echo "📋 残存プロセス:"; \
			pgrep -af "cursor" | head -5; \
		else \
			echo "✅ 全てのCursor関連プロセスを停止しました"; \
		fi; \
	fi && \
	\
	if [ "$$CURSOR_RUNNING" = "false" ]; then \
		echo "ℹ️  Cursor IDEは実行されていません"; \
	fi

# Cursor IDEのバージョン確認
check-cursor-version:
	@echo "🔍 Cursor IDEのバージョン情報を確認中..."
	@CURRENT_VERSION="" && \
	LATEST_VERSION="" && \
	\
	if command -v cursor >/dev/null 2>&1; then \
		echo "📋 インストール済みバージョンを確認中..."; \
		# cursor --version コマンドからバージョン番号のみを抽出 \
		CURRENT_VERSION=$$(cursor --version 2>/dev/null | head -1 | cut -d' ' -f1 || echo "不明"); \
		if [ "$$CURRENT_VERSION" = "不明" ]; then \
			CURRENT_VERSION="インストール済み"; \
		fi; \
		echo "💻 現在のバージョン: $$CURRENT_VERSION"; \
	else \
		echo "❌ Cursor IDEがインストールされていません"; \
	fi && \
	\
	echo "🌐 最新バージョンを確認中..." && \
	if command -v jq >/dev/null 2>&1; then \
		API_RESPONSE=$$(curl -sL "$(CURSOR_API_URL)" 2>/dev/null); \
		if [ -n "$$API_RESPONSE" ] && echo "$$API_RESPONSE" | jq . >/dev/null 2>&1; then \
			LATEST_VERSION=$$(echo "$$API_RESPONSE" | jq -r '.version' 2>/dev/null); \
			echo "🆕 最新バージョン: $$LATEST_VERSION"; \
			\
			if [ -n "$$CURRENT_VERSION" ] && [ "$$CURRENT_VERSION" != "不明" ] && \
			   [ "$$CURRENT_VERSION" != "インストール済み" ] && \
			   [ "$$CURRENT_VERSION" != "$$LATEST_VERSION" ]; then \
				echo ""; \
				echo "🔄 アップデートが利用可能です!"; \
				echo "   'make update-cursor' でアップデートできます"; \
			elif [ "$$CURRENT_VERSION" = "$$LATEST_VERSION" ]; then \
				echo "✅ 最新バージョンです"; \
			fi; \
		else \
			echo "❌ 最新バージョンの確認に失敗しました"; \
		fi; \
	else \
		echo "⚠️  jqがインストールされていないため、最新バージョンを確認できません"; \
		echo "   'sudo apt install jq' でjqをインストールしてください"; \
	fi


# ========================================
# エイリアス
# ========================================

.PHONY: install-cursor
install-cursor: install-packages-cursor  ## Cursor IDEをインストール(エイリアス)

