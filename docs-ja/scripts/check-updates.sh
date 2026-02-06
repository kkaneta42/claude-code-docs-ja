#!/bin/bash
# Claude Code ドキュメント自動更新スクリプト

SCRIPT_DIR="$(dirname "$0")"
DOCS_DIR="$(dirname "$SCRIPT_DIR")"
PAGES_DIR="$DOCS_DIR/pages"
BASE_URL_JA="https://code.claude.com/docs/ja"
BASE_URL_EN="https://code.claude.com/docs/en"
LLMS_URL="https://code.claude.com/docs/llms.txt"
CHANGELOG_URL="https://raw.githubusercontent.com/anthropics/claude-code/main/CHANGELOG.md"

mkdir -p "$PAGES_DIR"

echo "🔍 ページ一覧を取得中..."

# llms.txt からページ候補を抽出
PAGES=$(curl -s "$LLMS_URL" | grep -oE '/docs/en/[a-z0-9-]+\.md' | sed 's|/docs/en/||;s|\.md||' | sort -u)

# 日本語版を試し、なければ英語版にフォールバック
for page in $PAGES; do
  [[ "$page" == "changelog" ]] && continue
  curl -s "${BASE_URL_JA}/${page}.md" -o "$PAGES_DIR/${page}-ja.md"
  content=$(cat "$PAGES_DIR/${page}-ja.md")
  if [[ "$content" == "null" || -z "$content" ]]; then
    # JA版がない → 削除してEN版をダウンロード
    rm -f "$PAGES_DIR/${page}-ja.md"
    curl -s "${BASE_URL_EN}/${page}.md" -o "$PAGES_DIR/${page}-en.md"
  else
    # JA版が正常 → EN版を削除
    rm -f "$PAGES_DIR/${page}-en.md"
  fi
done

# CHANGELOG.md (GitHub)
curl -s "$CHANGELOG_URL" -o "$PAGES_DIR/changelog.md"

echo "✅ 完了"
