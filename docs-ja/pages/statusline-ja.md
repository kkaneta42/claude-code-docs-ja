> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# ステータスラインの設定

> Claude Codeのカスタムステータスラインを作成して、コンテキスト情報を表示します

Claude Codeをカスタムステータスラインで自分好みにカスタマイズできます。このステータスラインはClaude Codeインターフェースの下部に表示され、Oh-my-zshなどのシェルのターミナルプロンプト（PS1）と同様に機能します。

## カスタムステータスラインを作成する

以下のいずれかの方法を使用できます：

* `/statusline`を実行して、Claude Codeにカスタムステータスラインの設定を支援してもらいます。デフォルトではターミナルのプロンプトを再現しようとしますが、`/statusline show the model name in orange`など、Claude Codeに希望する動作について追加の指示を提供できます

* `.claude/settings.json`に直接`statusLine`コマンドを追加します：

```json  theme={null}
{
  "statusLine": {
    "type": "command",
    "command": "~/.claude/statusline.sh",
    "padding": 0 // Optional: set to 0 to let status line go to edge
  }
}
```

## 仕組み

* ステータスラインは会話メッセージが更新されるときに更新されます
* 更新は最大300msごとに実行されます
* コマンドのstdoutの最初の行がステータスラインテキストになります
* ステータスラインのスタイル設定にはANSIカラーコードがサポートされています
* Claude Codeは現在のセッションに関するコンテキスト情報（モデル、ディレクトリなど）をJSON形式でstdin経由でスクリプトに渡します

## JSON入力構造

ステータスラインコマンドはJSON形式でstdin経由で構造化されたデータを受け取ります：

```json  theme={null}
{
  "hook_event_name": "Status",
  "session_id": "abc123...",
  "transcript_path": "/path/to/transcript.json",
  "cwd": "/current/working/directory",
  "model": {
    "id": "claude-opus-4-1",
    "display_name": "Opus"
  },
  "workspace": {
    "current_dir": "/current/working/directory",
    "project_dir": "/original/project/directory"
  },
  "version": "1.0.80",
  "output_style": {
    "name": "default"
  },
  "cost": {
    "total_cost_usd": 0.01234,
    "total_duration_ms": 45000,
    "total_api_duration_ms": 2300,
    "total_lines_added": 156,
    "total_lines_removed": 23
  },
  "context_window": {
    "total_input_tokens": 15234,
    "total_output_tokens": 4521,
    "context_window_size": 200000,
    "current_usage": {
      "input_tokens": 8500,
      "output_tokens": 1200,
      "cache_creation_input_tokens": 5000,
      "cache_read_input_tokens": 2000
    }
  }
}
```

## スクリプト例

### シンプルなステータスライン

```bash  theme={null}
#!/bin/bash
# Read JSON input from stdin
input=$(cat)

# Extract values using jq
MODEL_DISPLAY=$(echo "$input" | jq -r '.model.display_name')
CURRENT_DIR=$(echo "$input" | jq -r '.workspace.current_dir')

echo "[$MODEL_DISPLAY] 📁 ${CURRENT_DIR##*/}"
```

### Git対応ステータスライン

```bash  theme={null}
#!/bin/bash
# Read JSON input from stdin
input=$(cat)

# Extract values using jq
MODEL_DISPLAY=$(echo "$input" | jq -r '.model.display_name')
CURRENT_DIR=$(echo "$input" | jq -r '.workspace.current_dir')

# Show git branch if in a git repo
GIT_BRANCH=""
if git rev-parse --git-dir > /dev/null 2>&1; then
    BRANCH=$(git branch --show-current 2>/dev/null)
    if [ -n "$BRANCH" ]; then
        GIT_BRANCH=" | 🌿 $BRANCH"
    fi
fi

echo "[$MODEL_DISPLAY] 📁 ${CURRENT_DIR##*/}$GIT_BRANCH"
```

### Pythonの例

```python  theme={null}
#!/usr/bin/env python3
import json
import sys
import os

# Read JSON from stdin
data = json.load(sys.stdin)

# Extract values
model = data['model']['display_name']
current_dir = os.path.basename(data['workspace']['current_dir'])

# Check for git branch
git_branch = ""
if os.path.exists('.git'):
    try:
        with open('.git/HEAD', 'r') as f:
            ref = f.read().strip()
            if ref.startswith('ref: refs/heads/'):
                git_branch = f" | 🌿 {ref.replace('ref: refs/heads/', '')}"
    except:
        pass

print(f"[{model}] 📁 {current_dir}{git_branch}")
```

### Node.jsの例

```javascript  theme={null}
#!/usr/bin/env node

const fs = require('fs');
const path = require('path');

// Read JSON from stdin
let input = '';
process.stdin.on('data', chunk => input += chunk);
process.stdin.on('end', () => {
    const data = JSON.parse(input);
    
    // Extract values
    const model = data.model.display_name;
    const currentDir = path.basename(data.workspace.current_dir);
    
    // Check for git branch
    let gitBranch = '';
    try {
        const headContent = fs.readFileSync('.git/HEAD', 'utf8').trim();
        if (headContent.startsWith('ref: refs/heads/')) {
            gitBranch = ` | 🌿 ${headContent.replace('ref: refs/heads/', '')}`;
        }
    } catch (e) {
        // Not a git repo or can't read HEAD
    }
    
    console.log(`[${model}] 📁 ${currentDir}${gitBranch}`);
});
```

### ヘルパー関数アプローチ

より複雑なbashスクリプトの場合、ヘルパー関数を作成できます：

```bash  theme={null}
#!/bin/bash
# Read JSON input once
input=$(cat)

# Helper functions for common extractions
get_model_name() { echo "$input" | jq -r '.model.display_name'; }
get_current_dir() { echo "$input" | jq -r '.workspace.current_dir'; }
get_project_dir() { echo "$input" | jq -r '.workspace.project_dir'; }
get_version() { echo "$input" | jq -r '.version'; }
get_cost() { echo "$input" | jq -r '.cost.total_cost_usd'; }
get_duration() { echo "$input" | jq -r '.cost.total_duration_ms'; }
get_lines_added() { echo "$input" | jq -r '.cost.total_lines_added'; }
get_lines_removed() { echo "$input" | jq -r '.cost.total_lines_removed'; }
get_input_tokens() { echo "$input" | jq -r '.context_window.total_input_tokens'; }
get_output_tokens() { echo "$input" | jq -r '.context_window.total_output_tokens'; }
get_context_window_size() { echo "$input" | jq -r '.context_window.context_window_size'; }

# Use the helpers
MODEL=$(get_model_name)
DIR=$(get_current_dir)
echo "[$MODEL] 📁 ${DIR##*/}"
```

### コンテキストウィンドウの使用状況

コンテキストウィンドウの消費パーセンテージを表示します。`context_window`オブジェクトには以下が含まれます：

* `total_input_tokens` / `total_output_tokens`：セッション全体の累積合計
* `current_usage`：最後のAPI呼び出しからの現在のコンテキストウィンドウ使用状況（メッセージがまだない場合は`null`の可能性があります）
  * `input_tokens`：現在のコンテキスト内の入力トークン
  * `output_tokens`：生成された出力トークン
  * `cache_creation_input_tokens`：キャッシュに書き込まれたトークン
  * `cache_read_input_tokens`：キャッシュから読み取られたトークン

正確なコンテキストパーセンテージについては、実際のコンテキストウィンドウ状態を反映する`current_usage`を使用します：

```bash  theme={null}
#!/bin/bash
input=$(cat)

MODEL=$(echo "$input" | jq -r '.model.display_name')
CONTEXT_SIZE=$(echo "$input" | jq -r '.context_window.context_window_size')
USAGE=$(echo "$input" | jq '.context_window.current_usage')

if [ "$USAGE" != "null" ]; then
    # Calculate current context from current_usage fields
    CURRENT_TOKENS=$(echo "$USAGE" | jq '.input_tokens + .cache_creation_input_tokens + .cache_read_input_tokens')
    PERCENT_USED=$((CURRENT_TOKENS * 100 / CONTEXT_SIZE))
    echo "[$MODEL] Context: ${PERCENT_USED}%"
else
    echo "[$MODEL] Context: 0%"
fi
```

## ヒント

* ステータスラインは簡潔に保つ - 1行に収まるべきです
* 絵文字（ターミナルがサポートしている場合）と色を使用して、情報をスキャンしやすくします
* BashでのJSON解析には`jq`を使用します（上記の例を参照）
* モックJSON入力を使用して手動でスクリプトをテストします：`echo '{"model":{"display_name":"Test"},"workspace":{"current_dir":"/test"}}' | ./statusline.sh`
* 必要に応じて、高コストの操作（gitステータスなど）をキャッシュすることを検討します

## トラブルシューティング

* ステータスラインが表示されない場合は、スクリプトが実行可能であることを確認します（`chmod +x`）
* スクリプトがstdoutに出力していることを確認します（stderrではなく）
