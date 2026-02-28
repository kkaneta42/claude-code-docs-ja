> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# ステータスラインをカスタマイズする

> Claude Code でコンテキストウィンドウの使用状況、コスト、git ステータスを監視するカスタムステータスバーを設定します

ステータスラインは Claude Code の下部にあるカスタマイズ可能なバーで、設定したシェルスクリプトを実行します。stdin 経由で JSON セッションデータを受け取り、スクリプトが出力したものを表示し、コンテキスト使用状況、コスト、git ステータス、またはその他の追跡したい情報を一目で確認できる永続的なビューを提供します。

ステータスラインは以下の場合に便利です：

* 作業中にコンテキストウィンドウの使用状況を監視したい
* セッションコストを追跡する必要がある
* 複数のセッション間で作業し、それらを区別する必要がある
* git ブランチとステータスを常に表示したい

以下は、最初の行に git 情報を表示し、2 番目の行にカラーコード化されたコンテキストバーを表示する[マルチラインステータスライン](#display-multiple-lines)の例です。

<Frame>
  <img src="https://mintcdn.com/claude-code/nibzesLaJVh4ydOq/images/statusline-multiline.png?fit=max&auto=format&n=nibzesLaJVh4ydOq&q=85&s=60f11387658acc9ff75158ae85f2ac87" alt="モデル名、ディレクトリ、git ブランチを最初の行に表示し、コンテキスト使用状況プログレスバー、コスト、期間を 2 番目の行に表示するマルチラインステータスライン" data-og-width="776" width="776" data-og-height="212" height="212" data-path="images/statusline-multiline.png" data-optimize="true" data-opv="3" srcset="https://mintcdn.com/claude-code/nibzesLaJVh4ydOq/images/statusline-multiline.png?w=280&fit=max&auto=format&n=nibzesLaJVh4ydOq&q=85&s=2e448b44c332620e6c9c2be4ded992e5 280w, https://mintcdn.com/claude-code/nibzesLaJVh4ydOq/images/statusline-multiline.png?w=560&fit=max&auto=format&n=nibzesLaJVh4ydOq&q=85&s=f796af2db9c68ab2ddbc5136840b9551 560w, https://mintcdn.com/claude-code/nibzesLaJVh4ydOq/images/statusline-multiline.png?w=840&fit=max&auto=format&n=nibzesLaJVh4ydOq&q=85&s=d29c13d6164773198a0b2c47b31f6c09 840w, https://mintcdn.com/claude-code/nibzesLaJVh4ydOq/images/statusline-multiline.png?w=1100&fit=max&auto=format&n=nibzesLaJVh4ydOq&q=85&s=d7720e5f51310185c0c02152f6c10d8b 1100w, https://mintcdn.com/claude-code/nibzesLaJVh4ydOq/images/statusline-multiline.png?w=1650&fit=max&auto=format&n=nibzesLaJVh4ydOq&q=85&s=b4e008cde27990a8d5783e41e5b93246 1650w, https://mintcdn.com/claude-code/nibzesLaJVh4ydOq/images/statusline-multiline.png?w=2500&fit=max&auto=format&n=nibzesLaJVh4ydOq&q=85&s=40ab24813303dc2e4c09f2675f3faf6e 2500w" />
</Frame>

このページでは、[基本的なステータスラインの設定](#set-up-a-status-line)について説明し、Claude Code からスクリプトへの[データフロー](#how-status-lines-work)について説明し、[表示できるすべてのフィールド](#available-data)をリストアップし、git ステータス、コスト追跡、プログレスバーなどの一般的なパターンの[すぐに使える例](#examples)を提供します。

## ステータスラインを設定する

[`/statusline` コマンド](#use-the-statusline-command)を使用して Claude Code にスクリプトを生成させるか、[手動でスクリプトを作成](#manually-configure-a-status-line)して設定に追加します。

### /statusline コマンドを使用する

`/statusline` コマンドは、表示したい内容を説明する自然言語の指示を受け入れます。Claude Code は `~/.claude/` にスクリプトファイルを生成し、設定を自動的に更新します：

```text  theme={null}
/statusline show model name and context percentage with a progress bar
```

### ステータスラインを手動で設定する

ユーザー設定（`~/.claude/settings.json`、`~` はホームディレクトリ）または[プロジェクト設定](/ja/settings#settings-files)に `statusLine` フィールドを追加します。`type` を `"command"` に設定し、`command` をスクリプトパスまたはインラインシェルコマンドに指定します。スクリプト作成の完全なウォークスルーについては、[ステータスラインをステップバイステップで構築する](#build-a-status-line-step-by-step)を参照してください。

```json  theme={null}
{
  "statusLine": {
    "type": "command",
    "command": "~/.claude/statusline.sh",
    "padding": 2
  }
}
```

`command` フィールドはシェルで実行されるため、スクリプトファイルの代わりにインラインコマンドを使用することもできます。この例では `jq` を使用して JSON 入力を解析し、モデル名とコンテキスト割合を表示します：

```json  theme={null}
{
  "statusLine": {
    "type": "command",
    "command": "jq -r '\"[\\(.model.display_name)] \\(.context_window.used_percentage // 0)% context\"'"
  }
}
```

オプションの `padding` フィールドは、ステータスラインコンテンツに追加の水平スペース（文字単位）を追加します。デフォルトは `0` です。このパディングはインターフェイスの組み込みスペースに加えて追加されるため、ターミナルエッジからの絶対距離ではなく相対的なインデントを制御します。

### ステータスラインを無効にする

`/statusline` を実行し、ステータスラインを削除またはクリアするよう指示します（例：`/statusline delete`、`/statusline clear`、`/statusline remove it`）。settings.json から `statusLine` フィールドを手動で削除することもできます。

## ステータスラインをステップバイステップで構築する

このウォークスルーでは、現在のモデル、作業ディレクトリ、コンテキストウィンドウ使用率の割合を表示するステータスラインを手動で作成することで、内部で何が起こっているかを示します。

<Note>[`/statusline`](#use-the-statusline-command)を実行して、表示したい内容を説明すると、これらすべてが自動的に設定されます。</Note>

これらの例では Bash スクリプトを使用しており、macOS と Linux で動作します。Windows では、[WSL（Windows Subsystem for Linux）](https://learn.microsoft.com/en-us/windows/wsl/install)を通じて Bash スクリプトを実行するか、PowerShell で書き直すことができます。

<Frame>
  <img src="https://mintcdn.com/claude-code/nibzesLaJVh4ydOq/images/statusline-quickstart.png?fit=max&auto=format&n=nibzesLaJVh4ydOq&q=85&s=696445e59ca0059213250651ad23db6b" alt="モデル名、ディレクトリ、コンテキスト割合を表示するステータスライン" data-og-width="726" width="726" data-og-height="164" height="164" data-path="images/statusline-quickstart.png" data-optimize="true" data-opv="3" srcset="https://mintcdn.com/claude-code/nibzesLaJVh4ydOq/images/statusline-quickstart.png?w=280&fit=max&auto=format&n=nibzesLaJVh4ydOq&q=85&s=728c4bd06c8559cb46ddffffad983373 280w, https://mintcdn.com/claude-code/nibzesLaJVh4ydOq/images/statusline-quickstart.png?w=560&fit=max&auto=format&n=nibzesLaJVh4ydOq&q=85&s=f9d28e0f8f48f695167dd1d632a6cf4f 560w, https://mintcdn.com/claude-code/nibzesLaJVh4ydOq/images/statusline-quickstart.png?w=840&fit=max&auto=format&n=nibzesLaJVh4ydOq&q=85&s=57a2803a18cafe8cf1aa05619444f20c 840w, https://mintcdn.com/claude-code/nibzesLaJVh4ydOq/images/statusline-quickstart.png?w=1100&fit=max&auto=format&n=nibzesLaJVh4ydOq&q=85&s=52cdd52865842f0cda24489dd5310d3b 1100w, https://mintcdn.com/claude-code/nibzesLaJVh4ydOq/images/statusline-quickstart.png?w=1650&fit=max&auto=format&n=nibzesLaJVh4ydOq&q=85&s=f8876ea1f72bf40bd0aeec483ee20164 1650w, https://mintcdn.com/claude-code/nibzesLaJVh4ydOq/images/statusline-quickstart.png?w=2500&fit=max&auto=format&n=nibzesLaJVh4ydOq&q=85&s=6b1524305c7c71122cde65d0c3822374 2500w" />
</Frame>

<Steps>
  <Step title="JSON を読み取り、出力を出力するスクリプトを作成する">
    Claude Code は stdin 経由で JSON データをスクリプトに送信します。このスクリプトは[`jq`](https://jqlang.github.io/jq/)（インストールが必要な場合があるコマンドラインの JSON パーサー）を使用して、モデル名、ディレクトリ、コンテキスト割合を抽出し、フォーマットされた行を出力します。

    これを `~/.claude/statusline.sh` に保存します（`~` はホームディレクトリ、macOS では `/Users/username`、Linux では `/home/username` など）：

    ```bash  theme={null}
    #!/bin/bash
    # Claude Code が stdin に送信する JSON データを読み取る
    input=$(cat)

    # jq を使用してフィールドを抽出する
    MODEL=$(echo "$input" | jq -r '.model.display_name')
    DIR=$(echo "$input" | jq -r '.workspace.current_dir')
    # "// 0" はフィールドが null の場合のフォールバックを提供します
    PCT=$(echo "$input" | jq -r '.context_window.used_percentage // 0' | cut -d. -f1)

    # ステータスラインを出力 - ${DIR##*/} はフォルダ名のみを抽出します
    echo "[$MODEL] 📁 ${DIR##*/} | ${PCT}% context"
    ```
  </Step>

  <Step title="実行可能にする">
    スクリプトを実行可能にマークして、シェルが実行できるようにします：

    ```bash  theme={null}
    chmod +x ~/.claude/statusline.sh
    ```
  </Step>

  <Step title="設定に追加する">
    Claude Code にスクリプトをステータスラインとして実行するよう指示します。この設定を `~/.claude/settings.json` に追加します。これは `type` を `"command"`（「このシェルコマンドを実行する」という意味）に設定し、`command` をスクリプトに指定します：

    ```json  theme={null}
    {
      "statusLine": {
        "type": "command",
        "command": "~/.claude/statusline.sh"
      }
    }
    ```

    ステータスラインはインターフェイスの下部に表示されます。設定は自動的に再読み込みされますが、Claude Code との次の相互作用まで変更は表示されません。
  </Step>
</Steps>

## ステータスラインの仕組み

Claude Code はスクリプトを実行し、[JSON セッションデータ](#available-data)を stdin 経由でパイプします。スクリプトは JSON を読み取り、必要なものを抽出し、stdout にテキストを出力します。Claude Code はスクリプトが出力したものを表示します。

**更新のタイミング**

スクリプトは新しいアシスタントメッセージの後、パーミッションモードが変更されたとき、または vim モードが切り替わったときに実行されます。更新は 300ms でデバウンスされます。つまり、急速な変更がバッチ処理され、スクリプトは物事が落ち着いたら 1 回実行されます。スクリプトがまだ実行中に新しい更新がトリガーされた場合、実行中の実行はキャンセルされます。スクリプトを編集した場合、Claude Code との次の相互作用がアップデートをトリガーするまで変更は表示されません。

**スクリプトが出力できるもの**

* **複数行**：各 `echo` または `print` ステートメントは別の行として表示されます。[マルチライン例](#display-multiple-lines)を参照してください。
* **色**：`\033[32m` のような[ANSI エスケープコード](https://en.wikipedia.org/wiki/ANSI_escape_code#Colors)を使用して緑色を表示します（ターミナルがサポートしている必要があります）。[git ステータス例](#git-status-with-colors)を参照してください。
* **リンク**：[OSC 8 エスケープシーケンス](https://en.wikipedia.org/wiki/ANSI_escape_code#OSC)を使用してテキストをクリック可能にします（macOS では Cmd+クリック、Windows/Linux では Ctrl+クリック）。iTerm2、Kitty、WezTerm などのハイパーリンクをサポートするターミナルが必要です。[クリック可能なリンク例](#clickable-links)を参照してください。

<Note>ステータスラインはローカルで実行され、API トークンを消費しません。オートコンプリート提案、ヘルプメニュー、パーミッションプロンプトなど、特定の UI 相互作用中は一時的に非表示になります。</Note>

## 利用可能なデータ

Claude Code は以下の JSON フィールドを stdin 経由でスクリプトに送信します：

| フィールド                                                                    | 説明                                                                                                |
| ------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------- |
| `model.id`、`model.display_name`                                          | 現在のモデル識別子と表示名                                                                                     |
| `cwd`、`workspace.current_dir`                                            | 現在の作業ディレクトリ。両方のフィールドに同じ値が含まれます。`workspace.current_dir` は `workspace.project_dir` との一貫性のために推奨されます。 |
| `workspace.project_dir`                                                  | Claude Code が起動されたディレクトリ。セッション中に作業ディレクトリが変更された場合、`cwd` と異なる場合があります                                |
| `cost.total_cost_usd`                                                    | USD でのセッションの総コスト                                                                                  |
| `cost.total_duration_ms`                                                 | セッション開始からの総経過時間（ミリ秒）                                                                              |
| `cost.total_api_duration_ms`                                             | API レスポンスを待つのに費やされた総時間（ミリ秒）                                                                       |
| `cost.total_lines_added`、`cost.total_lines_removed`                      | 変更されたコード行                                                                                         |
| `context_window.total_input_tokens`、`context_window.total_output_tokens` | セッション全体の累積トークン数                                                                                   |
| `context_window.context_window_size`                                     | トークン単位の最大コンテキストウィンドウサイズ。デフォルトは 200000、拡張コンテキストを持つモデルの場合は 1000000                                  |
| `context_window.used_percentage`                                         | 事前計算されたコンテキストウィンドウ使用率の割合                                                                          |
| `context_window.remaining_percentage`                                    | 事前計算されたコンテキストウィンドウ残り率の割合                                                                          |
| `context_window.current_usage`                                           | 最後の API 呼び出しからのトークン数。[コンテキストウィンドウフィールド](#context-window-fields)で説明されています                          |
| `exceeds_200k_tokens`                                                    | 最新の API レスポンスからの総トークン数（入力、キャッシュ、出力トークンの組み合わせ）が 200k を超えるかどうか。これは実際のコンテキストウィンドウサイズに関係なく固定閾値です。     |
| `session_id`                                                             | 一意のセッション識別子                                                                                       |
| `transcript_path`                                                        | 会話トランスクリプトファイルへのパス                                                                                |
| `version`                                                                | Claude Code バージョン                                                                                 |
| `output_style.name`                                                      | 現在の出力スタイルの名前                                                                                      |
| `vim.mode`                                                               | [vim モード](/ja/interactive-mode#vim-editor-mode)が有効な場合の現在の vim モード（`NORMAL` または `INSERT`）          |
| `agent.name`                                                             | `--agent` フラグまたはエージェント設定が設定されている場合のエージェント名                                                        |

<Accordion title="完全な JSON スキーマ">
  ステータスラインコマンドは stdin 経由でこの JSON 構造を受け取ります：

  ```json  theme={null}
  {
    "cwd": "/current/working/directory",
    "session_id": "abc123...",
    "transcript_path": "/path/to/transcript.jsonl",
    "model": {
      "id": "claude-opus-4-6",
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
      "used_percentage": 8,
      "remaining_percentage": 92,
      "current_usage": {
        "input_tokens": 8500,
        "output_tokens": 1200,
        "cache_creation_input_tokens": 5000,
        "cache_read_input_tokens": 2000
      }
    },
    "exceeds_200k_tokens": false,
    "vim": {
      "mode": "NORMAL"
    },
    "agent": {
      "name": "security-reviewer"
    }
  }
  ```

  **存在しない可能性があるフィールド**（JSON に存在しない）：

  * `vim`：vim モードが有効な場合のみ表示されます
  * `agent`：`--agent` フラグまたはエージェント設定が設定されている場合のみ表示されます

  **`null` である可能性があるフィールド**：

  * `context_window.current_usage`：セッションの最初の API 呼び出しの前は `null`
  * `context_window.used_percentage`、`context_window.remaining_percentage`：セッションの早期段階では `null` である可能性があります

  スクリプトで条件付きアクセスを使用して欠落フィールドを処理し、null 値をフォールバックデフォルトで処理します。
</Accordion>

### コンテキストウィンドウフィールド

`context_window` オブジェクトは、コンテキスト使用状況を追跡する 2 つの方法を提供します：

* **累積合計**（`total_input_tokens`、`total_output_tokens`）：セッション全体のすべてのトークンの合計。総消費量を追跡するのに便利です
* **現在の使用状況**（`current_usage`）：最新の API 呼び出しからのトークン数。実際のコンテキスト状態を反映しているため、正確なコンテキスト割合にはこれを使用します

`current_usage` オブジェクトには以下が含まれます：

* `input_tokens`：現在のコンテキストの入力トークン
* `output_tokens`：生成された出力トークン
* `cache_creation_input_tokens`：キャッシュに書き込まれたトークン
* `cache_read_input_tokens`：キャッシュから読み取られたトークン

`used_percentage` フィールドは入力トークンのみから計算されます：`input_tokens + cache_creation_input_tokens + cache_read_input_tokens`。`output_tokens` は含まれません。

`current_usage` からコンテキスト割合を手動で計算する場合は、`used_percentage` と一致させるために同じ入力のみの式を使用します。

`current_usage` オブジェクトはセッションの最初の API 呼び出しの前は `null` です。

## 例

これらの例は一般的なステータスラインパターンを示しています。任意の例を使用するには：

1. スクリプトを `~/.claude/statusline.sh`（または `.py`/`.js`）などのファイルに保存します
2. 実行可能にします：`chmod +x ~/.claude/statusline.sh`
3. パスを[設定](#manually-configure-a-status-line)に追加します

Bash の例は JSON を解析するために[`jq`](https://jqlang.github.io/jq/)を使用します。Python と Node.js には組み込みの JSON 解析があります。

### コンテキストウィンドウの使用状況

現在のモデルとコンテキストウィンドウの使用状況を視覚的なプログレスバーで表示します。各スクリプトは stdin から JSON を読み取り、`used_percentage` フィールドを抽出し、塗りつぶされたブロック（▓）が使用状況を表す 10 文字のバーを構築します：

<Frame>
  <img src="https://mintcdn.com/claude-code/nibzesLaJVh4ydOq/images/statusline-context-window-usage.png?fit=max&auto=format&n=nibzesLaJVh4ydOq&q=85&s=15b58ab3602f036939145dde3165c6f7" alt="モデル名とパーセンテージ付きのプログレスバーを表示するステータスライン" data-og-width="448" width="448" data-og-height="152" height="152" data-path="images/statusline-context-window-usage.png" data-optimize="true" data-opv="3" srcset="https://mintcdn.com/claude-code/nibzesLaJVh4ydOq/images/statusline-context-window-usage.png?w=280&fit=max&auto=format&n=nibzesLaJVh4ydOq&q=85&s=a18fecd31f06b16e984b1ab3310acbc0 280w, https://mintcdn.com/claude-code/nibzesLaJVh4ydOq/images/statusline-context-window-usage.png?w=560&fit=max&auto=format&n=nibzesLaJVh4ydOq&q=85&s=2f4b3caff156efede2ded995dbaf167f 560w, https://mintcdn.com/claude-code/nibzesLaJVh4ydOq/images/statusline-context-window-usage.png?w=840&fit=max&auto=format&n=nibzesLaJVh4ydOq&q=85&s=8f6b8c7e7d3a999c570e96ad2ea13d5a 840w, https://mintcdn.com/claude-code/nibzesLaJVh4ydOq/images/statusline-context-window-usage.png?w=1100&fit=max&auto=format&n=nibzesLaJVh4ydOq&q=85&s=d9334e6a08e6f11a253733c8592774a9 1100w, https://mintcdn.com/claude-code/nibzesLaJVh4ydOq/images/statusline-context-window-usage.png?w=1650&fit=max&auto=format&n=nibzesLaJVh4ydOq&q=85&s=e79490da8f62952e4d92837c408e63dc 1650w, https://mintcdn.com/claude-code/nibzesLaJVh4ydOq/images/statusline-context-window-usage.png?w=2500&fit=max&auto=format&n=nibzesLaJVh4ydOq&q=85&s=6f7c9ef8e629a794969c54b24163f92d 2500w" />
</Frame>

<CodeGroup>
  ```bash Bash theme={null}
  #!/bin/bash
  # stdin 全体を変数に読み込む
  input=$(cat)

  # jq でフィールドを抽出、"// 0" は null のフォールバックを提供
  MODEL=$(echo "$input" | jq -r '.model.display_name')
  PCT=$(echo "$input" | jq -r '.context_window.used_percentage // 0' | cut -d. -f1)

  # プログレスバーを構築：printf はスペースを作成、tr はブロックに置き換え
  BAR_WIDTH=10
  FILLED=$((PCT * BAR_WIDTH / 100))
  EMPTY=$((BAR_WIDTH - FILLED))
  BAR=""
  [ "$FILLED" -gt 0 ] && BAR=$(printf "%${FILLED}s" | tr ' ' '▓')
  [ "$EMPTY" -gt 0 ] && BAR="${BAR}$(printf "%${EMPTY}s" | tr ' ' '░')"

  echo "[$MODEL] $BAR $PCT%"
  ```

  ```python Python theme={null}
  #!/usr/bin/env python3
  import json, sys

  # json.load は stdin を 1 ステップで読み取り、解析します
  data = json.load(sys.stdin)
  model = data['model']['display_name']
  # "or 0" は null 値を処理します
  pct = int(data.get('context_window', {}).get('used_percentage', 0) or 0)

  # 文字列乗算がバーを構築します
  filled = pct * 10 // 100
  bar = '▓' * filled + '░' * (10 - filled)

  print(f"[{model}] {bar} {pct}%")
  ```

  ```javascript Node.js theme={null}
  #!/usr/bin/env node
  // Node.js はイベントで stdin を非同期に読み取ります
  let input = '';
  process.stdin.on('data', chunk => input += chunk);
  process.stdin.on('end', () => {
      const data = JSON.parse(input);
      const model = data.model.display_name;
      // オプショナルチェーン（?.）は null フィールドを安全に処理します
      const pct = Math.floor(data.context_window?.used_percentage || 0);

      // String.repeat() がバーを構築します
      const filled = Math.floor(pct * 10 / 100);
      const bar = '▓'.repeat(filled) + '░'.repeat(10 - filled);

      console.log(`[${model}] ${bar} ${pct}%`);
  });
  ```
</CodeGroup>

### git ステータスとカラー

git ブランチをステージングされたファイルと変更されたファイルのカラーコード化されたインジケーターで表示します。このスクリプトは[ANSI エスケープコード](https://en.wikipedia.org/wiki/ANSI_escape_code#Colors)をターミナルカラーに使用します：`\033[32m` は緑、`\033[33m` は黄色、`\033[0m` はデフォルトにリセットします。

<Frame>
  <img src="https://mintcdn.com/claude-code/nibzesLaJVh4ydOq/images/statusline-git-context.png?fit=max&auto=format&n=nibzesLaJVh4ydOq&q=85&s=e656f34f90d1d9a1d0e220988914345f" alt="モデル、ディレクトリ、git ブランチ、ステージングされたファイルと変更されたファイルのカラーコード化されたインジケーターを表示するステータスライン" data-og-width="742" width="742" data-og-height="178" height="178" data-path="images/statusline-git-context.png" data-optimize="true" data-opv="3" srcset="https://mintcdn.com/claude-code/nibzesLaJVh4ydOq/images/statusline-git-context.png?w=280&fit=max&auto=format&n=nibzesLaJVh4ydOq&q=85&s=c1bced5f46afdc9aae549702591f8457 280w, https://mintcdn.com/claude-code/nibzesLaJVh4ydOq/images/statusline-git-context.png?w=560&fit=max&auto=format&n=nibzesLaJVh4ydOq&q=85&s=debe46a7a888234ec692751243bba492 560w, https://mintcdn.com/claude-code/nibzesLaJVh4ydOq/images/statusline-git-context.png?w=840&fit=max&auto=format&n=nibzesLaJVh4ydOq&q=85&s=3a069d5c8b0395908e42f0e295fd4854 840w, https://mintcdn.com/claude-code/nibzesLaJVh4ydOq/images/statusline-git-context.png?w=1100&fit=max&auto=format&n=nibzesLaJVh4ydOq&q=85&s=26aff0978865756d5ea299a22e5e9afd 1100w, https://mintcdn.com/claude-code/nibzesLaJVh4ydOq/images/statusline-git-context.png?w=1650&fit=max&auto=format&n=nibzesLaJVh4ydOq&q=85&s=d5ac1d59881e6f2032af053557dc4590 1650w, https://mintcdn.com/claude-code/nibzesLaJVh4ydOq/images/statusline-git-context.png?w=2500&fit=max&auto=format&n=nibzesLaJVh4ydOq&q=85&s=46febbf34b0ee646502d095433132709 2500w" />
</Frame>

各スクリプトは現在のディレクトリが git リポジトリであるかどうかをチェックし、ステージングされたファイルと変更されたファイルをカウントし、カラーコード化されたインジケーターを表示します：

<CodeGroup>
  ```bash Bash theme={null}
  #!/bin/bash
  input=$(cat)

  MODEL=$(echo "$input" | jq -r '.model.display_name')
  DIR=$(echo "$input" | jq -r '.workspace.current_dir')

  GREEN='\033[32m'
  YELLOW='\033[33m'
  RESET='\033[0m'

  if git rev-parse --git-dir > /dev/null 2>&1; then
      BRANCH=$(git branch --show-current 2>/dev/null)
      STAGED=$(git diff --cached --numstat 2>/dev/null | wc -l | tr -d ' ')
      MODIFIED=$(git diff --numstat 2>/dev/null | wc -l | tr -d ' ')

      GIT_STATUS=""
      [ "$STAGED" -gt 0 ] && GIT_STATUS="${GREEN}+${STAGED}${RESET}"
      [ "$MODIFIED" -gt 0 ] && GIT_STATUS="${GIT_STATUS}${YELLOW}~${MODIFIED}${RESET}"

      echo -e "[$MODEL] 📁 ${DIR##*/} | 🌿 $BRANCH $GIT_STATUS"
  else
      echo "[$MODEL] 📁 ${DIR##*/}"
  fi
  ```

  ```python Python theme={null}
  #!/usr/bin/env python3
  import json, sys, subprocess, os

  data = json.load(sys.stdin)
  model = data['model']['display_name']
  directory = os.path.basename(data['workspace']['current_dir'])

  GREEN, YELLOW, RESET = '\033[32m', '\033[33m', '\033[0m'

  try:
      subprocess.check_output(['git', 'rev-parse', '--git-dir'], stderr=subprocess.DEVNULL)
      branch = subprocess.check_output(['git', 'branch', '--show-current'], text=True).strip()
      staged_output = subprocess.check_output(['git', 'diff', '--cached', '--numstat'], text=True).strip()
      modified_output = subprocess.check_output(['git', 'diff', '--numstat'], text=True).strip()
      staged = len(staged_output.split('\n')) if staged_output else 0
      modified = len(modified_output.split('\n')) if modified_output else 0

      git_status = f"{GREEN}+{staged}{RESET}" if staged else ""
      git_status += f"{YELLOW}~{modified}{RESET}" if modified else ""

      print(f"[{model}] 📁 {directory} | 🌿 {branch} {git_status}")
  except:
      print(f"[{model}] 📁 {directory}")
  ```

  ```javascript Node.js theme={null}
  #!/usr/bin/env node
  const { execSync } = require('child_process');
  const path = require('path');

  let input = '';
  process.stdin.on('data', chunk => input += chunk);
  process.stdin.on('end', () => {
      const data = JSON.parse(input);
      const model = data.model.display_name;
      const dir = path.basename(data.workspace.current_dir);

      const GREEN = '\x1b[32m', YELLOW = '\x1b[33m', RESET = '\x1b[0m';

      try {
          execSync('git rev-parse --git-dir', { stdio: 'ignore' });
          const branch = execSync('git branch --show-current', { encoding: 'utf8' }).trim();
          const staged = execSync('git diff --cached --numstat', { encoding: 'utf8' }).trim().split('\n').filter(Boolean).length;
          const modified = execSync('git diff --numstat', { encoding: 'utf8' }).trim().split('\n').filter(Boolean).length;

          let gitStatus = staged ? `${GREEN}+${staged}${RESET}` : '';
          gitStatus += modified ? `${YELLOW}~${modified}${RESET}` : '';

          console.log(`[${model}] 📁 ${dir} | 🌿 ${branch} ${gitStatus}`);
      } catch {
          console.log(`[${model}] 📁 ${dir}`);
      }
  });
  ```
</CodeGroup>

### コストと期間の追跡

セッションの API コストと経過時間を追跡します。`cost.total_cost_usd` フィールドは現在のセッションのすべての API 呼び出しのコストを累積します。`cost.total_duration_ms` フィールドはセッション開始からの総経過時間を測定し、`cost.total_api_duration_ms` は API レスポンスを待つのに費やされた時間のみを追跡します。

各スクリプトはコストを通貨としてフォーマットし、ミリ秒を分と秒に変換します：

<Frame>
  <img src="https://mintcdn.com/claude-code/nibzesLaJVh4ydOq/images/statusline-cost-tracking.png?fit=max&auto=format&n=nibzesLaJVh4ydOq&q=85&s=e3444a51fe6f3440c134bd5f1f08ad29" alt="モデル名、セッションコスト、期間を表示するステータスライン" data-og-width="588" width="588" data-og-height="180" height="180" data-path="images/statusline-cost-tracking.png" data-optimize="true" data-opv="3" srcset="https://mintcdn.com/claude-code/nibzesLaJVh4ydOq/images/statusline-cost-tracking.png?w=280&fit=max&auto=format&n=nibzesLaJVh4ydOq&q=85&s=b1d35fa8acd792f559b6b1662ed10204 280w, https://mintcdn.com/claude-code/nibzesLaJVh4ydOq/images/statusline-cost-tracking.png?w=560&fit=max&auto=format&n=nibzesLaJVh4ydOq&q=85&s=a3ed4330c3645fc28b87a6cab55be0b7 560w, https://mintcdn.com/claude-code/nibzesLaJVh4ydOq/images/statusline-cost-tracking.png?w=840&fit=max&auto=format&n=nibzesLaJVh4ydOq&q=85&s=386ee2ed68a7d520eba20eac54f7fe52 840w, https://mintcdn.com/claude-code/nibzesLaJVh4ydOq/images/statusline-cost-tracking.png?w=1100&fit=max&auto=format&n=nibzesLaJVh4ydOq&q=85&s=479c2515e53f46d5d1da3b87a6dd993a 1100w, https://mintcdn.com/claude-code/nibzesLaJVh4ydOq/images/statusline-cost-tracking.png?w=1650&fit=max&auto=format&n=nibzesLaJVh4ydOq&q=85&s=1340c7589a4cb89ec071234aba3571d1 1650w, https://mintcdn.com/claude-code/nibzesLaJVh4ydOq/images/statusline-cost-tracking.png?w=2500&fit=max&auto=format&n=nibzesLaJVh4ydOq&q=85&s=69056cf4fe3271770cac4dc1704bcd0a 2500w" />
</Frame>

<CodeGroup>
  ```bash Bash theme={null}
  #!/bin/bash
  input=$(cat)

  MODEL=$(echo "$input" | jq -r '.model.display_name')
  COST=$(echo "$input" | jq -r '.cost.total_cost_usd // 0')
  DURATION_MS=$(echo "$input" | jq -r '.cost.total_duration_ms // 0')

  COST_FMT=$(printf '$%.2f' "$COST")
  DURATION_SEC=$((DURATION_MS / 1000))
  MINS=$((DURATION_SEC / 60))
  SECS=$((DURATION_SEC % 60))

  echo "[$MODEL] 💰 $COST_FMT | ⏱️ ${MINS}m ${SECS}s"
  ```

  ```python Python theme={null}
  #!/usr/bin/env python3
  import json, sys

  data = json.load(sys.stdin)
  model = data['model']['display_name']
  cost = data.get('cost', {}).get('total_cost_usd', 0) or 0
  duration_ms = data.get('cost', {}).get('total_duration_ms', 0) or 0

  duration_sec = duration_ms // 1000
  mins, secs = duration_sec // 60, duration_sec % 60

  print(f"[{model}] 💰 ${cost:.2f} | ⏱️ {mins}m {secs}s")
  ```

  ```javascript Node.js theme={null}
  #!/usr/bin/env node
  let input = '';
  process.stdin.on('data', chunk => input += chunk);
  process.stdin.on('end', () => {
      const data = JSON.parse(input);
      const model = data.model.display_name;
      const cost = data.cost?.total_cost_usd || 0;
      const durationMs = data.cost?.total_duration_ms || 0;

      const durationSec = Math.floor(durationMs / 1000);
      const mins = Math.floor(durationSec / 60);
      const secs = durationSec % 60;

      console.log(`[${model}] 💰 $${cost.toFixed(2)} | ⏱️ ${mins}m ${secs}s`);
  });
  ```
</CodeGroup>

### 複数行を表示する

スクリプトは複数行を出力して、より豊かなディスプレイを作成できます。各 `echo` ステートメントはステータス領域に別の行を生成します。

<Frame>
  <img src="https://mintcdn.com/claude-code/nibzesLaJVh4ydOq/images/statusline-multiline.png?fit=max&auto=format&n=nibzesLaJVh4ydOq&q=85&s=60f11387658acc9ff75158ae85f2ac87" alt="最初の行にモデル名、ディレクトリ、git ブランチを表示し、2 番目の行にコンテキスト使用状況プログレスバー、コスト、期間を表示するマルチラインステータスライン" data-og-width="776" width="776" data-og-height="212" height="212" data-path="images/statusline-multiline.png" data-optimize="true" data-opv="3" srcset="https://mintcdn.com/claude-code/nibzesLaJVh4ydOq/images/statusline-multiline.png?w=280&fit=max&auto=format&n=nibzesLaJVh4ydOq&q=85&s=2e448b44c332620e6c9c2be4ded992e5 280w, https://mintcdn.com/claude-code/nibzesLaJVh4ydOq/images/statusline-multiline.png?w=560&fit=max&auto=format&n=nibzesLaJVh4ydOq&q=85&s=f796af2db9c68ab2ddbc5136840b9551 560w, https://mintcdn.com/claude-code/nibzesLaJVh4ydOq/images/statusline-multiline.png?w=840&fit=max&auto=format&n=nibzesLaJVh4ydOq&q=85&s=d29c13d6164773198a0b2c47b31f6c09 840w, https://mintcdn.com/claude-code/nibzesLaJVh4ydOq/images/statusline-multiline.png?w=1100&fit=max&auto=format&n=nibzesLaJVh4ydOq&q=85&s=d7720e5f51310185c0c02152f6c10d8b 1100w, https://mintcdn.com/claude-code/nibzesLaJVh4ydOq/images/statusline-multiline.png?w=1650&fit=max&auto=format&n=nibzesLaJVh4ydOq&q=85&s=b4e008cde27990a8d5783e41e5b93246 1650w, https://mintcdn.com/claude-code/nibzesLaJVh4ydOq/images/statusline-multiline.png?w=2500&fit=max&auto=format&n=nibzesLaJVh4ydOq&q=85&s=40ab24813303dc2e4c09f2675f3faf6e 2500w" />
</Frame>

この例は複数の手法を組み合わせています：閾値ベースのカラー（70% 未満は緑、70～89% は黄色、90% 以上は赤）、プログレスバー、git ブランチ情報。各 `print` または `echo` ステートメントは別の行を作成します：

<CodeGroup>
  ```bash Bash theme={null}
  #!/bin/bash
  input=$(cat)

  MODEL=$(echo "$input" | jq -r '.model.display_name')
  DIR=$(echo "$input" | jq -r '.workspace.current_dir')
  COST=$(echo "$input" | jq -r '.cost.total_cost_usd // 0')
  PCT=$(echo "$input" | jq -r '.context_window.used_percentage // 0' | cut -d. -f1)
  DURATION_MS=$(echo "$input" | jq -r '.cost.total_duration_ms // 0')

  CYAN='\033[36m'; GREEN='\033[32m'; YELLOW='\033[33m'; RED='\033[31m'; RESET='\033[0m'

  # コンテキスト使用状況に基づいてバーの色を選択
  if [ "$PCT" -ge 90 ]; then BAR_COLOR="$RED"
  elif [ "$PCT" -ge 70 ]; then BAR_COLOR="$YELLOW"
  else BAR_COLOR="$GREEN"; fi

  FILLED=$((PCT / 10)); EMPTY=$((10 - FILLED))
  BAR=$(printf "%${FILLED}s" | tr ' ' '█')$(printf "%${EMPTY}s" | tr ' ' '░')

  MINS=$((DURATION_MS / 60000)); SECS=$(((DURATION_MS % 60000) / 1000))

  BRANCH=""
  git rev-parse --git-dir > /dev/null 2>&1 && BRANCH=" | 🌿 $(git branch --show-current 2>/dev/null)"

  echo -e "${CYAN}[$MODEL]${RESET} 📁 ${DIR##*/}$BRANCH"
  COST_FMT=$(printf '$%.2f' "$COST")
  echo -e "${BAR_COLOR}${BAR}${RESET} ${PCT}% | ${YELLOW}${COST_FMT}${RESET} | ⏱️ ${MINS}m ${SECS}s"
  ```

  ```python Python theme={null}
  #!/usr/bin/env python3
  import json, sys, subprocess, os

  data = json.load(sys.stdin)
  model = data['model']['display_name']
  directory = os.path.basename(data['workspace']['current_dir'])
  cost = data.get('cost', {}).get('total_cost_usd', 0) or 0
  pct = int(data.get('context_window', {}).get('used_percentage', 0) or 0)
  duration_ms = data.get('cost', {}).get('total_duration_ms', 0) or 0

  CYAN, GREEN, YELLOW, RED, RESET = '\033[36m', '\033[32m', '\033[33m', '\033[31m', '\033[0m'

  bar_color = RED if pct >= 90 else YELLOW if pct >= 70 else GREEN
  filled = pct // 10
  bar = '█' * filled + '░' * (10 - filled)

  mins, secs = duration_ms // 60000, (duration_ms % 60000) // 1000

  try:
      branch = subprocess.check_output(['git', 'branch', '--show-current'], text=True, stderr=subprocess.DEVNULL).strip()
      branch = f" | 🌿 {branch}" if branch else ""
  except:
      branch = ""

  print(f"{CYAN}[{model}]{RESET} 📁 {directory}{branch}")
  print(f"{bar_color}{bar}{RESET} {pct}% | {YELLOW}${cost:.2f}{RESET} | ⏱️ {mins}m {secs}s")
  ```

  ```javascript Node.js theme={null}
  #!/usr/bin/env node
  const { execSync } = require('child_process');
  const path = require('path');

  let input = '';
  process.stdin.on('data', chunk => input += chunk);
  process.stdin.on('end', () => {
      const data = JSON.parse(input);
      const model = data.model.display_name;
      const dir = path.basename(data.workspace.current_dir);
      const cost = data.cost?.total_cost_usd || 0;
      const pct = Math.floor(data.context_window?.used_percentage || 0);
      const durationMs = data.cost?.total_duration_ms || 0;

      const CYAN = '\x1b[36m', GREEN = '\x1b[32m', YELLOW = '\x1b[33m', RED = '\x1b[31m', RESET = '\x1b[0m';

      const barColor = pct >= 90 ? RED : pct >= 70 ? YELLOW : GREEN;
      const filled = Math.floor(pct / 10);
      const bar = '█'.repeat(filled) + '░'.repeat(10 - filled);

      const mins = Math.floor(durationMs / 60000);
      const secs = Math.floor((durationMs % 60000) / 1000);

      let branch = '';
      try {
          branch = execSync('git branch --show-current', { encoding: 'utf8', stdio: ['pipe', 'pipe', 'ignore'] }).trim();
          branch = branch ? ` | 🌿 ${branch}` : '';
      } catch {}

      console.log(`${CYAN}[${model}]${RESET} 📁 ${dir}${branch}`);
      console.log(`${barColor}${bar}${RESET} ${pct}% | ${YELLOW}$${cost.toFixed(2)}${RESET} | ⏱️ ${mins}m ${secs}s`);
  });
  ```
</CodeGroup>

### クリック可能なリンク

この例は GitHub リポジトリへのクリック可能なリンクを作成します。git リモート URL を読み取り、SSH 形式を `sed` で HTTPS に変換し、リポジトリ名を OSC 8 エスケープコードでラップします。Cmd（macOS）または Ctrl（Windows/Linux）を押しながらクリックして、ブラウザでリンクを開きます。

<Frame>
  <img src="https://mintcdn.com/claude-code/nibzesLaJVh4ydOq/images/statusline-links.png?fit=max&auto=format&n=nibzesLaJVh4ydOq&q=85&s=4bcc6e7deb7cf52f41ab85a219b52661" alt="GitHub リポジトリへのクリック可能なリンクを表示するステータスライン" data-og-width="726" width="726" data-og-height="198" height="198" data-path="images/statusline-links.png" data-optimize="true" data-opv="3" srcset="https://mintcdn.com/claude-code/nibzesLaJVh4ydOq/images/statusline-links.png?w=280&fit=max&auto=format&n=nibzesLaJVh4ydOq&q=85&s=9386f78056f7be99599bcefe9e838180 280w, https://mintcdn.com/claude-code/nibzesLaJVh4ydOq/images/statusline-links.png?w=560&fit=max&auto=format&n=nibzesLaJVh4ydOq&q=85&s=d748012a0866c37dddc6babd4b7a88c4 560w, https://mintcdn.com/claude-code/nibzesLaJVh4ydOq/images/statusline-links.png?w=840&fit=max&auto=format&n=nibzesLaJVh4ydOq&q=85&s=bade8fbfcde957c1033c376c58b89131 840w, https://mintcdn.com/claude-code/nibzesLaJVh4ydOq/images/statusline-links.png?w=1100&fit=max&auto=format&n=nibzesLaJVh4ydOq&q=85&s=9f7e0c729ea093c3b39682619fd3f201 1100w, https://mintcdn.com/claude-code/nibzesLaJVh4ydOq/images/statusline-links.png?w=1650&fit=max&auto=format&n=nibzesLaJVh4ydOq&q=85&s=ccec17e90a89d82381888a4a9a8fa40e 1650w, https://mintcdn.com/claude-code/nibzesLaJVh4ydOq/images/statusline-links.png?w=2500&fit=max&auto=format&n=nibzesLaJVh4ydOq&q=85&s=4d2e34a4d2f24e174cae1256c84f9a52 2500w" />
</Frame>

各スクリプトは git リモート URL を取得し、SSH 形式を HTTPS に変換し、リポジトリ名を OSC 8 エスケープコードでラップします。Bash バージョンは `printf '%b'` を使用します。これはシェル間でバックスラッシュエスケープをより確実に解釈します：

<CodeGroup>
  ```bash Bash theme={null}
  #!/bin/bash
  input=$(cat)

  MODEL=$(echo "$input" | jq -r '.model.display_name')

  # git SSH URL を HTTPS に変換
  REMOTE=$(git remote get-url origin 2>/dev/null | sed 's/git@github.com:/https:\/\/github.com\//' | sed 's/\.git$//')

  if [ -n "$REMOTE" ]; then
      REPO_NAME=$(basename "$REMOTE")
      # OSC 8 形式：\e]8;;URL\a その後 TEXT その後 \e]8;;\a
      # printf %b はシェル間でエスケープシーケンスを確実に解釈します
      printf '%b' "[$MODEL] 🔗 \e]8;;${REMOTE}\a${REPO_NAME}\e]8;;\a\n"
  else
      echo "[$MODEL]"
  fi
  ```

  ```python Python theme={null}
  #!/usr/bin/env python3
  import json, sys, subprocess, re, os

  data = json.load(sys.stdin)
  model = data['model']['display_name']

  # git リモート URL を取得
  try:
      remote = subprocess.check_output(
          ['git', 'remote', 'get-url', 'origin'],
          stderr=subprocess.DEVNULL, text=True
      ).strip()
      # SSH を HTTPS 形式に変換
      remote = re.sub(r'^git@github\.com:', 'https://github.com/', remote)
      remote = re.sub(r'\.git$', '', remote)
      repo_name = os.path.basename(remote)
      # OSC 8 エスケープシーケンス
      link = f"\033]8;;{remote}\a{repo_name}\033]8;;\a"
      print(f"[{model}] 🔗 {link}")
  except:
      print(f"[{model}]")
  ```

  ```javascript Node.js theme={null}
  #!/usr/bin/env node
  const { execSync } = require('child_process');
  const path = require('path');

  let input = '';
  process.stdin.on('data', chunk => input += chunk);
  process.stdin.on('end', () => {
      const data = JSON.parse(input);
      const model = data.model.display_name;

      try {
          let remote = execSync('git remote get-url origin', { encoding: 'utf8', stdio: ['pipe', 'pipe', 'ignore'] }).trim();
          // SSH を HTTPS 形式に変換
          remote = remote.replace(/^git@github\.com:/, 'https://github.com/').replace(/\.git$/, '');
          const repoName = path.basename(remote);
          // OSC 8 エスケープシーケンス
          const link = `\x1b]8;;${remote}\x07${repoName}\x1b]8;;\x07`;
          console.log(`[${model}] 🔗 ${link}`);
      } catch {
          console.log(`[${model}]`);
      }
  });
  ```
</CodeGroup>

### 高価な操作をキャッシュする

ステータスラインスクリプトはアクティブなセッション中に頻繁に実行されます。`git status` や `git diff` などのコマンドは、特に大規模なリポジトリでは遅くなる可能性があります。この例は git 情報を一時ファイルにキャッシュし、5 秒ごとにのみ更新します。

`/tmp/statusline-git-cache` のような安定した固定ファイル名をキャッシュファイルに使用します。各ステータスライン呼び出しは新しいプロセスとして実行されるため、`$$`、`os.getpid()`、`process.pid` のようなプロセスベースの識別子は毎回異なる値を生成し、キャッシュは再利用されません。

各スクリプトは git コマンドを実行する前に、キャッシュファイルが欠落しているか 5 秒より古いかをチェックします：

<CodeGroup>
  ```bash Bash theme={null}
  #!/bin/bash
  input=$(cat)

  MODEL=$(echo "$input" | jq -r '.model.display_name')
  DIR=$(echo "$input" | jq -r '.workspace.current_dir')

  CACHE_FILE="/tmp/statusline-git-cache"
  CACHE_MAX_AGE=5  # 秒

  cache_is_stale() {
      [ ! -f "$CACHE_FILE" ] || \
      # stat -f %m は macOS、stat -c %Y は Linux
      [ $(($(date +%s) - $(stat -f %m "$CACHE_FILE" 2>/dev/null || stat -c %Y "$CACHE_FILE" 2>/dev/null || echo 0))) -gt $CACHE_MAX_AGE ]
  }

  if cache_is_stale; then
      if git rev-parse --git-dir > /dev/null 2>&1; then
          BRANCH=$(git branch --show-current 2>/dev/null)
          STAGED=$(git diff --cached --numstat 2>/dev/null | wc -l | tr -d ' ')
          MODIFIED=$(git diff --numstat 2>/dev/null | wc -l | tr -d ' ')
          echo "$BRANCH|$STAGED|$MODIFIED" > "$CACHE_FILE"
      else
          echo "||" > "$CACHE_FILE"
      fi
  fi

  IFS='|' read -r BRANCH STAGED MODIFIED < "$CACHE_FILE"

  if [ -n "$BRANCH" ]; then
      echo "[$MODEL] 📁 ${DIR##*/} | 🌿 $BRANCH +$STAGED ~$MODIFIED"
  else
      echo "[$MODEL] 📁 ${DIR##*/}"
  fi
  ```

  ```python Python theme={null}
  #!/usr/bin/env python3
  import json, sys, subprocess, os, time

  data = json.load(sys.stdin)
  model = data['model']['display_name']
  directory = os.path.basename(data['workspace']['current_dir'])

  CACHE_FILE = "/tmp/statusline-git-cache"
  CACHE_MAX_AGE = 5  # 秒

  def cache_is_stale():
      if not os.path.exists(CACHE_FILE):
          return True
      return time.time() - os.path.getmtime(CACHE_FILE) > CACHE_MAX_AGE

  if cache_is_stale():
      try:
          subprocess.check_output(['git', 'rev-parse', '--git-dir'], stderr=subprocess.DEVNULL)
          branch = subprocess.check_output(['git', 'branch', '--show-current'], text=True).strip()
          staged = subprocess.check_output(['git', 'diff', '--cached', '--numstat'], text=True).strip()
          modified = subprocess.check_output(['git', 'diff', '--numstat'], text=True).strip()
          staged_count = len(staged.split('\n')) if staged else 0
          modified_count = len(modified.split('\n')) if modified else 0
          with open(CACHE_FILE, 'w') as f:
              f.write(f"{branch}|{staged_count}|{modified_count}")
      except:
          with open(CACHE_FILE, 'w') as f:
              f.write("||")

  with open(CACHE_FILE) as f:
      branch, staged, modified = f.read().strip().split('|')

  if branch:
      print(f"[{model}] 📁 {directory} | 🌿 {branch} +{staged} ~{modified}")
  else:
      print(f"[{model}] 📁 {directory}")
  ```

  ```javascript Node.js theme={null}
  #!/usr/bin/env node
  const { execSync } = require('child_process');
  const fs = require('fs');
  const path = require('path');

  let input = '';
  process.stdin.on('data', chunk => input += chunk);
  process.stdin.on('end', () => {
      const data = JSON.parse(input);
      const model = data.model.display_name;
      const dir = path.basename(data.workspace.current_dir);

      const CACHE_FILE = '/tmp/statusline-git-cache';
      const CACHE_MAX_AGE = 5; // 秒

      const cacheIsStale = () => {
          if (!fs.existsSync(CACHE_FILE)) return true;
          return (Date.now() / 1000) - fs.statSync(CACHE_FILE).mtimeMs / 1000 > CACHE_MAX_AGE;
      };

      if (cacheIsStale()) {
          try {
              execSync('git rev-parse --git-dir', { stdio: 'ignore' });
              const branch = execSync('git branch --show-current', { encoding: 'utf8' }).trim();
              const staged = execSync('git diff --cached --numstat', { encoding: 'utf8' }).trim().split('\n').filter(Boolean).length;
              const modified = execSync('git diff --numstat', { encoding: 'utf8' }).trim().split('\n').filter(Boolean).length;
              fs.writeFileSync(CACHE_FILE, `${branch}|${staged}|${modified}`);
          } catch {
              fs.writeFileSync(CACHE_FILE, '||');
          }
      }

      const [branch, staged, modified] = fs.readFileSync(CACHE_FILE, 'utf8').trim().split('|');

      if (branch) {
          console.log(`[${model}] 📁 ${dir} | 🌿 ${branch} +${staged} ~${modified}`);
      } else {
          console.log(`[${model}] 📁 ${dir}`);
      }
  });
  ```
</CodeGroup>

## ヒント

* **モック入力でテストする**：`echo '{"model":{"display_name":"Opus"},"context_window":{"used_percentage":25}}' | ./statusline.sh`
* **出力を短く保つ**：ステータスバーの幅は限られているため、長い出力は切り詰められたり、awkwardly ラップされたりする可能性があります
* **遅い操作をキャッシュする**：スクリプトはアクティブなセッション中に頻繁に実行されるため、`git status` などのコマンドはラグを引き起こす可能性があります。これを処理する方法については、[キャッシング例](#cache-expensive-operations)を参照してください。

[ccstatusline](https://github.com/sirmalloc/ccstatusline) や [starship-claude](https://github.com/martinemde/starship-claude) などのコミュニティプロジェクトは、テーマと追加機能を備えた事前構築設定を提供します。

## トラブルシューティング

**ステータスラインが表示されない**

* スクリプトが実行可能であることを確認します：`chmod +x ~/.claude/statusline.sh`
* スクリプトが stdout に出力し、stderr に出力していないことを確認します
* スクリプトを手動で実行して、出力を生成することを確認します
* `disableAllHooks` が設定で `true` に設定されている場合、ステータスラインも無効になります。この設定を削除するか、`false` に設定して再度有効にします。

**ステータスラインが `--` または空の値を表示する**

* 最初の API レスポンスが完了する前に、フィールドが `null` である可能性があります
* スクリプトで `// 0` in jq などのフォールバックを使用して null 値を処理します
* 複数のメッセージの後も値が空のままの場合は、Claude Code を再起動します

**コンテキスト割合が予期しない値を表示する**

* 累積合計ではなく、正確なコンテキスト状態に `used_percentage` を使用します
* `total_input_tokens` と `total_output_tokens` はセッション全体で累積され、コンテキストウィンドウサイズを超える可能性があります
* コンテキスト割合は `/context` 出力と異なる場合があります。これは各が計算されるタイミングが異なるためです

**OSC 8 リンクがクリック可能でない**

* ターミナルが OSC 8 ハイパーリンクをサポートしていることを確認します（iTerm2、Kitty、WezTerm）
* Terminal.app はクリック可能なリンクをサポートしていません
* SSH と tmux セッションは設定に応じて OSC シーケンスをストリップする可能性があります
* `\e]8;;` のようなリテラルテキストとしてエスケープシーケンスが表示される場合は、`echo -e` の代わりに `printf '%b'` を使用して、より確実なエスケープ処理を行います

**エスケープシーケンスでのディスプレイグリッチ**

* 複雑なエスケープシーケンス（ANSI カラー、OSC 8 リンク）は、他の UI 更新と重複する場合、時々破損した出力を引き起こす可能性があります
* 破損したテキストが表示される場合は、スクリプトをプレーンテキスト出力に簡略化してみてください
* マルチラインステータスラインとエスケープコードは、単一行のプレーンテキストよりもレンダリングの問題が発生しやすくなります

**スクリプトエラーまたはハング**

* ゼロ以外のコードで終了するか、出力を生成しないスクリプトは、ステータスラインを空白にします
* 遅いスクリプトは、完了するまでステータスラインの更新をブロックします。古い出力を避けるためにスクリプトを高速に保ちます。
* 遅いスクリプトの実行中に新しい更新がトリガーされた場合、実行中のスクリプトはキャンセルされます
* 設定する前に、モック入力を使用してスクリプトを独立してテストします

**通知がステータスラインの行を共有する**

* MCP サーバーエラー、自動更新、トークン警告などのシステム通知は、ステータスラインと同じ行の右側に表示されます
* 詳細モードを有効にすると、この領域にトークンカウンターが追加されます
* 狭いターミナルでは、これらの通知がステータスラインの出力を切り詰める可能性があります
