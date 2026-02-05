#!/bin/bash
# Claude Code ドキュメント自動更新スクリプト

SCRIPT_DIR="$(dirname "$0")"
DOCS_DIR="$(dirname "$SCRIPT_DIR")"
PAGES_DIR="$DOCS_DIR/pages"
CACHE_FILE="$DOCS_DIR/.cache"
BASE_URL="https://code.claude.com/docs/ja"
LLMS_URL="https://code.claude.com/docs/llms.txt"

mkdir -p "$PAGES_DIR"

echo "🔍 ページ一覧を取得中..."

# llms.txt からページ候補を抽出
PAGES=$(curl -s "$LLMS_URL" | grep -oE '/docs/en/[a-z0-9-]+\.md' | sed 's|/docs/en/||;s|\.md||' | sort -u)

# 日本語版の存在チェック & 更新
NEW_COUNT=0
UPDATE_COUNT=0

for page in $PAGES; do
  # changelogは除外
  [[ "$page" == "changelog" ]] && continue
  FILE="$PAGES_DIR/${page}-ja.md"
  URL="${BASE_URL}/${page}.md"

  # Last-Modified取得
  HEADERS=$(curl -sI "$URL" 2>/dev/null)
  HTTP_CODE=$(echo "$HEADERS" | head -1 | grep -oE '[0-9]{3}')

  [[ "$HTTP_CODE" != "200" ]] && continue

  LAST_MOD=$(echo "$HEADERS" | grep -i "last-modified" | cut -d: -f2- | xargs)
  CACHED=$(grep "^${page}=" "$CACHE_FILE" 2>/dev/null | cut -d= -f2-)

  if [[ -z "$CACHED" ]]; then
    # 新規
    echo "🆕 $page"
    curl -s "$URL" > "$FILE"
    echo "${page}=${LAST_MOD}" >> "$CACHE_FILE"
    ((NEW_COUNT++))
  elif [[ "$CACHED" != "$LAST_MOD" ]]; then
    # 更新
    echo "📝 $page"
    curl -s "$URL" > "$FILE"
    sed -i.bak "s|^${page}=.*|${page}=${LAST_MOD}|" "$CACHE_FILE" && rm -f "$CACHE_FILE.bak"
    ((UPDATE_COUNT++))
  fi
done

echo ""
echo "✅ 完了: 新規${NEW_COUNT}件、更新${UPDATE_COUNT}件"
