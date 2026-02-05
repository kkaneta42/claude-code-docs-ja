#!/bin/bash
# README.md 更新ログ生成スクリプト
# check-updates.sh 実行後に呼び出し、変更内容を README.md に追記する

QUIET=false
[[ "$1" == "--quiet" ]] && QUIET=true

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
README="$ROOT_DIR/README.md"
MAX_ENTRIES=90
MAX_LINES_PER_FILE=30
MAX_TOTAL_LINES=150

# README.md とマーカーの存在確認
if [[ ! -f "$README" ]]; then
  $QUIET || echo "README.md が見つかりません"
  exit 0
fi

if ! grep -q '<!-- UPDATE_LOG_START -->' "$README"; then
  $QUIET || echo "README.md にマーカーがありません"
  exit 0
fi

# 変更ファイル検知（変更 + 新規）
MODIFIED=$(git diff --name-only -- docs-ja/pages/ 2>/dev/null)
NEW=$(git ls-files --others --exclude-standard -- docs-ja/pages/ 2>/dev/null)
DELETED=$(git diff --name-only --diff-filter=D -- docs-ja/pages/ 2>/dev/null)

ALL_CHANGES=$(printf '%s\n%s' "$MODIFIED" "$NEW" | sort -u | grep -v '^$')

if [[ -z "$ALL_CHANGES" ]]; then
  $QUIET || echo "変更なし"
  exit 0
fi

DATE=$(TZ=Asia/Tokyo date '+%Y-%m-%d')

# ログエントリ生成
TMPENTRY=$(mktemp)

printf '<details>\n<summary>%s</summary>\n\n' "$DATE" > "$TMPENTRY"

# 変更ファイル一覧（stat）
if [[ -n "$MODIFIED" ]]; then
  STAT=$(git diff --stat -- docs-ja/pages/)
  printf '**変更ファイル:**\n\n```\n%s\n```\n\n' "$STAT" >> "$TMPENTRY"
fi

# 新規ファイル一覧
if [[ -n "$NEW" ]]; then
  printf '**新規追加:**\n\n' >> "$TMPENTRY"
  while IFS= read -r file; do
    [[ -z "$file" ]] && continue
    FNAME=$(basename "$file")
    printf '- `%s`\n' "$FNAME" >> "$TMPENTRY"
  done <<< "$NEW"
  printf '\n' >> "$TMPENTRY"
fi

# 削除ファイル一覧
if [[ -n "$DELETED" ]]; then
  printf '**削除:**\n\n' >> "$TMPENTRY"
  while IFS= read -r file; do
    [[ -z "$file" ]] && continue
    FNAME=$(basename "$file")
    printf '- `%s`\n' "$FNAME" >> "$TMPENTRY"
  done <<< "$DELETED"
  printf '\n' >> "$TMPENTRY"
fi

# 各ファイルの差分（変更ファイルのみ、新規は除く）
TOTAL_LINES=0
if [[ -n "$MODIFIED" ]]; then
  while IFS= read -r file; do
    [[ -z "$file" ]] && continue
    # 削除ファイルはスキップ
    echo "$DELETED" | grep -qx "$file" && continue

    FNAME=$(basename "$file")
    FILE_DIFF=$(git diff -U2 -- "$file" | head -n "$MAX_LINES_PER_FILE")
    DIFF_LINES=$(printf '%s' "$FILE_DIFF" | wc -l | tr -d ' ')
    TOTAL_LINES=$((TOTAL_LINES + DIFF_LINES))

    printf '<details>\n<summary>%s</summary>\n\n```diff\n%s\n```\n\n</details>\n\n' "$FNAME" "$FILE_DIFF" >> "$TMPENTRY"

    if [[ $TOTAL_LINES -ge $MAX_TOTAL_LINES ]]; then
      printf '*...以降省略*\n\n' >> "$TMPENTRY"
      break
    fi
  done <<< "$MODIFIED"
fi

printf '</details>\n' >> "$TMPENTRY"

# README.md にエントリを挿入
TMPREADME=$(mktemp)
awk -v entry_file="$TMPENTRY" '
  /<!-- UPDATE_LOG_START -->/ {
    print
    print ""
    while ((getline line < entry_file) > 0) print line
    print ""
    next
  }
  { print }
' "$README" > "$TMPREADME"

# 古いエントリの削除（90件超）
awk '
  BEGIN { in_log = 0; count = 0; skip = 0 }
  /<!-- UPDATE_LOG_START -->/ { in_log = 1; print; next }
  /<!-- UPDATE_LOG_END -->/ { in_log = 0; print; next }
  in_log && /^<details>$/ {
    count++
    if (count > '"$MAX_ENTRIES"') { skip = 1 }
    else { skip = 0 }
  }
  in_log && skip && /^<\/details>$/ { next }
  in_log && skip { next }
  { print }
' "$TMPREADME" > "$README"

rm -f "$TMPENTRY" "$TMPREADME"

CHANGE_COUNT=$(echo "$ALL_CHANGES" | wc -l | tr -d ' ')
$QUIET || echo "📝 ${CHANGE_COUNT}件の変更を README.md に記録しました"
