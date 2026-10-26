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

ステータスラインは組み込みのフッターバッジの上にある独自の行にレンダリングされ、それらを置き換えません。カスタムステータスラインが設定されている場合、Claude Code はフッターのキーボードヒントのほとんどを表示しなくなります。これには `esc to interrupt`、`? for shortcuts` フォールバック、および `hold space to speak` [音声入力](https://code.claude.com/docs/ja/voice-dictation.md) ヒントが含まれます。会話内に ID が表示されたときにフッターにクリック可能なリンクバッジを追加する場合は、スクリプトを記述せずに [`footerLinksRegexes`](https://code.claude.com/docs/ja/settings-reference#footerlinksregexes) を設定してください。

以下は、最初の行に git 情報を表示し、2 番目の行にカラーコード化されたコンテキストバーを表示する [複数行ステータスライン](#display-multiple-lines) の例です。

![最初の行にモデル名、ディレクトリ、git ブランチを表示し、2 番目の行にコンテキスト使用状況プログレスバー、コスト、期間を表示する複数行ステータスライン](https://mintcdn.com/claude-code/HDAmBwgbrZVk0pOt/images/statusline-multiline.png?fit=max\&auto=format\&n=HDAmBwgbrZVk0pOt\&q=85\&s=a9d0a2fe8e446d80b1abc46da3f93270)

このページでは、[基本的なステータスラインの設定](#set-up-a-status-line) について説明し、Claude Code からスクリプトへの [データフロー](#how-status-lines-work) について説明し、[表示できるすべてのフィールド](#available-data) をリストアップし、git ステータス、コスト追跡、プログレスバーなどの一般的なパターンの [すぐに使える例](#examples) を提供します。

## ステータスラインを設定する

[`/statusline` コマンド](#use-the-%2Fstatusline-command) を使用して Claude Code にスクリプトを生成させるか、[手動でスクリプトを作成](#manually-configure-a-status-line) して設定に追加します。

### /statusline コマンドを使用する

`/statusline` コマンドは、表示したい内容を説明する自然言語の指示を受け入れます。Claude Code は `~/.claude/` にスクリプトファイルを生成し、設定を自動的に更新します：

```text theme={null}
/statusline show model name and context percentage with a progress bar
```

セットアップ中に Claude Code が権限を求める場合は、ファイル編集プロンプトを承認してください。

### ステータスラインを手動で設定する

ユーザー設定（`~/.claude/settings.json`、`~` はホームディレクトリ）または [プロジェクト設定](https://code.claude.com/docs/ja/settings.md#where-settings-live) に `statusLine` フィールドを追加します。`type` を `"command"` に設定し、`command` をスクリプトパスまたはインラインシェルコマンドに指定します。スクリプト作成の完全なチュートリアルについては、[ステータスラインをステップバイステップで構築する](#build-a-status-line-step-by-step) を参照してください。

```json theme={null}
{
  "statusLine": {
    "type": "command",
    "command": "~/.claude/statusline.sh",
    "padding": 2
  }
}
```

`command` フィールドはシェルで実行されるため、スクリプトファイルの代わりにインラインコマンドを使用することもできます。この例では `jq` を使用して JSON 入力を解析し、モデル名とコンテキスト割合を表示します：

```json theme={null}
{
  "statusLine": {
    "type": "command",
    "command": "jq -r '\"[\\(.model.display_name)] \\(.context_window.used_percentage // 0)% context\"'"
  }
}
```

オプションの `padding` フィールドは、ステータスラインコンテンツに追加の水平スペース（文字単位）を追加します。デフォルトは `0` です。このパディングはインターフェイスの組み込みスペースに加えて追加されるため、ターミナルエッジからの絶対距離ではなく相対的なインデントを制御します。

オプションの `refreshInterval` フィールドは、[イベント駆動更新](#how-status-lines-work) に加えて、N 秒ごとにコマンドを再実行します。最小値は `1` です。ステータスラインが時計などの時間ベースのデータを表示する場合、またはメインセッションがアイドル状態の間にバックグラウンドサブエージェントが git 状態を変更する場合に設定します。イベントのみで実行する場合は設定しないままにします。

オプションの `hideVimModeIndicator` フィールドは、プロンプトの下にある組み込みの `-- INSERT --` テキストを非表示にします。スクリプトが [`vim.mode`](#available-data) 自体をレンダリングする場合は、これを `true` に設定して、モードが 2 回表示されないようにします。

### ステータスラインを無効にする

`/statusline` を実行し、ステータスラインを削除またはクリアするよう指示します（例：`/statusline delete`、`/statusline clear`、`/statusline remove it`）。settings.json から `statusLine` フィールドを手動で削除することもできます。

## ステータスラインをステップバイステップで構築する

このチュートリアルでは、現在のモデル、作業ディレクトリ、コンテキストウィンドウ使用状況の割合を表示するステータスラインを手動で作成することで、`/statusline` が内部で何をセットアップするかを示します。

> [!NOTE]
>
> [`/statusline`](#use-the-%2Fstatusline-command) を実行して、表示したい内容を説明すると、これらすべてが自動的に設定されます。

これらの例では Bash スクリプトを使用しており、macOS と Linux で動作します。Windows では、[Windows 設定](#windows-configuration) で PowerShell と Git Bash の例を参照してください。

![モデル名、ディレクトリ、コンテキスト割合を表示するステータスライン](https://mintcdn.com/claude-code/HDAmBwgbrZVk0pOt/images/statusline-quickstart.png?fit=max\&auto=format\&n=HDAmBwgbrZVk0pOt\&q=85\&s=88a7eab9c1038dd098ee8e284d96b7e6)

**1. JSON を読み取り、出力を出力するスクリプトを作成する**

Claude Code は stdin 経由でスクリプトに JSON データを送信します。このスクリプトは [`jq`](https://jqlang.org/)（コマンドラインの JSON パーサーで、インストールが必要な場合があります）を使用して、モデル名、ディレクトリ、コンテキスト割合を抽出し、フォーマットされた行を出力します。

これを `~/.claude/statusline.sh` に保存します（`~` はホームディレクトリ、macOS では `/Users/username`、Linux では `/home/username` など）：

```bash theme={null}
#!/bin/bash
# Claude Code が stdin に送信する JSON データを読み取る
input=$(cat)

# jq を使用してフィールドを抽出する
MODEL=$(echo "$input" | jq -r '.model.display_name')
DIR=$(echo "$input" | jq -r '.workspace.current_dir')
# "// 0" はフィールドが null の場合のフォールバックを提供します
PCT=$(echo "$input" | jq -r '.context_window.used_percentage // 0' | cut -d. -f1)

# ステータスラインを出力します - ${DIR##*/} はフォルダ名のみを抽出します
echo "[$MODEL] 📁 ${DIR##*/} | ${PCT}% context"
```

**2. 実行可能にする**

スクリプトを実行可能にマークして、シェルが実行できるようにします：

```bash theme={null}
chmod +x ~/.claude/statusline.sh
```

**3. 設定に追加する**

Claude Code にスクリプトをステータスラインとして実行するよう指示します。この設定を `~/.claude/settings.json` に追加します。これは `type` を `"command"`（「このシェルコマンドを実行する」という意味）に設定し、`command` をスクリプトに指定します：

```json theme={null}
{
  "statusLine": {
    "type": "command",
    "command": "~/.claude/statusline.sh"
  }
}
```

ステータスラインはインターフェイスの下部に表示されます。Claude Code は設定を自動的に再読み込みし、ファイルを保存するとすぐにスクリプトを実行します。

## ステータスラインの仕組み

Claude Code はスクリプトを実行し、stdin 経由で [JSON セッションデータ](#available-data) を渡します。スクリプトが stdout に出力したものを Claude Code が表示します。

> [!NOTE]
>
> ステータスラインはローカルで実行され、API トークンを消費しません。ヘルプメニューと権限プロンプトを含む特定の UI 相互作用中は一時的に非表示になります。

### ステータスラインが更新されるタイミング

スクリプトはセッション開始時（再開時を含む）に 1 回実行されます。その後、以下の場合に再度実行されます：

* 新しいアシスタントメッセージが到着したとき
* `/compact` が完了したとき
* 権限モードが変更されたとき
* Vim モードが切り替わったとき
* `statusLine` 設定で `command` を変更したとき
* [`refreshInterval`](#manually-configure-a-status-line) タイマーが経過したとき（設定した場合）
* スクリプトが最後に受け取ったデータ内の [レート制限ウィンドウ](#rate-limit-usage) が `resets_at` 時刻に到達したとき
* スクリプトが最後に受け取ったデータ内のウォーム [プロンプトキャッシュ](#prompt-cache-fields) が `expires_at` 時刻に到達したとき

Claude Code は更新を 300ms でデバウンスするため、急速な変更がバッチ処理され、スクリプトは変更が停止した後に 1 回実行されます。`command` 自体への変更はデバウンスをスキップします。Claude Code は新しいコマンドをすぐに実行します。スクリプトがまだ実行中に新しい更新がトリガーされた場合、Claude Code は実行中のスクリプトをキャンセルします。スクリプトを編集した場合、変更は更新トリガーが次に実行されるときに表示されます。

イベント駆動型トリガーは、メインセッションがアイドル状態の場合（例えば、コーディネーターがバックグラウンドサブエージェントを待機している場合）、静かになる可能性があります。アイドル期間中に時間ベースまたは外部ソースのセグメントを最新に保つには、[`refreshInterval`](#manually-configure-a-status-line) を設定して、固定タイマーでもコマンドを再実行します。

### スクリプトが出力できるもの

スクリプトは、1 行のプレーンテキスト以上のものを出力できます：

* **複数行**：各 `echo` または `print` ステートメントは別の行として表示されます。[複数行の例](#display-multiple-lines) を参照してください。
* **色**：`\033[32m` のような [ANSI エスケープコード](https://en.wikipedia.org/wiki/ANSI_escape_code#Colors) を使用して緑色を表示します（ターミナルがサポートしている必要があります）。[git ステータスの例](#git-status-with-colors) を参照してください。
* **リンク**：[OSC 8 エスケープシーケンス](https://en.wikipedia.org/wiki/ANSI_escape_code#OSC) を使用してテキストをクリック可能にします（macOS では Cmd+クリック、Windows/Linux では Ctrl+クリック）。iTerm2、Kitty、WezTerm などのハイパーリンクをサポートするターミナルが必要です。[クリック可能なリンクの例](#clickable-links) を参照してください。

### ターミナルに出力をサイズ調整する

Claude Code はスクリプトの出力をキャプチャするため、ターミナルに直接接続しません。そのため、`tput cols` と言語レベルの幅検出はスクリプト内からターミナルサイズを読み取ることができません。代わりに `COLUMNS` および `LINES` 環境変数を読み取ってください。Claude Code はスクリプトを実行する前に、これらを現在のターミナルサイズに設定します。

## 利用可能なデータ

Claude Code は、stdin 経由で以下の JSON フィールドをスクリプトに送信します。

| フィールド | 説明 |
| - | - |
| `model.id`, `model.display_name` | 現在のモデル識別子と表示名 |
| `cwd`, `workspace.current_dir` | 現在の作業ディレクトリ。両フィールドには同じ値が含まれます。`workspace.project_dir` との一貫性のため、`workspace.current_dir` の使用が推奨されます。 |
| `workspace.project_dir` | Claude Code が起動されたディレクトリ。セッション中に作業ディレクトリが変更された場合、`cwd` と異なることがあります |
| `workspace.added_dirs` | `/add-dir` または `--add-dir` で追加されたディレクトリ。何も追加されていない場合は空の配列です |
| `workspace.git_worktree` | 現在のディレクトリが `git worktree add` で作成されたリンク済み worktree 内にある場合の Git worktree 名。メインの作業ツリーでは存在しません。`worktree.*` はセッションが [worktree セッション](https://code.claude.com/docs/ja/worktrees.md)にある間のみ存在するのに対し、こちらはあらゆる git worktree で設定されます |
| `workspace.repo.host`, `workspace.repo.owner`, `workspace.repo.name` | `origin` リモートから解析されたリポジトリの識別情報。例：`"github.com"`、`"anthropics"`、`"claude-code"`。git リポジトリの外にいる場合や、`origin` リモートが設定されていない場合は存在しません。サブグループにネストされた gitlab.com プロジェクトの場合、`owner` は `"group/subgroup"` のようにスラッシュを含む完全な名前空間パスになります。v2.1.260 より前は、これらのプロジェクトでは `workspace.repo` が存在しませんでした |
| `cost.total_cost_usd` | 推定セッションコスト（USD）。[`modelPricing`](https://code.claude.com/docs/ja/settings-reference#modelpricing) テーブルが有効でない限り、クライアント側で定価に基づいて計算されます。実際の請求額とは異なる場合があります。`/clear` で新しいセッションが開始されると \$0 にリセットされます |
| `cost.total_duration_ms` | セッションが実行されている合計の実時間（ミリ秒）。再開をまたいで累積され、セッションが実行されていない間の時間は含まれません |
| `cost.total_api_duration_ms` | API レスポンスの待機に費やされた合計時間（ミリ秒） |
| `cost.total_lines_added`, `cost.total_lines_removed` | 変更されたコードの行数 |
| `context_window.total_input_tokens`, `context_window.total_output_tokens` | 直近の API レスポンスに基づく、現在コンテキストウィンドウ内にあるトークン数。入力にはキャッシュの読み取りと書き込みが含まれます |
| `context_window.context_window_size` | 最大コンテキストウィンドウサイズ（トークン）。デフォルトは 200000、拡張コンテキストを持つモデルでは 1000000 です。 |
| `context_window.used_percentage` | 事前計算されたコンテキストウィンドウの使用率 |
| `context_window.remaining_percentage` | 事前計算されたコンテキストウィンドウの残り率 |
| `context_window.current_usage` | 最後の API 呼び出しからのトークン数。[コンテキストウィンドウのフィールド](#context-window-fields)で説明しています |
| `exceeds_200k_tokens` | 直近の API レスポンスからの合計トークン数（入力、キャッシュ、出力トークンの合計）が 200k を超えているかどうか。これは実際のコンテキストウィンドウサイズに関係なく固定されたしきい値です。 |
| `fast_mode` | セッションで [fast mode](https://code.claude.com/docs/ja/fast-mode.md) が有効かどうか |
| `effort.level` | 現在の推論エフォート（`low`、`medium`、`high`、`xhigh`、または `max`）。セッション途中の `/effort` による変更を含め、セッションの現在の値を反映します。現在のモデルが effort パラメータをサポートしていない場合は存在しません |
| `thinking.enabled` | セッションで拡張思考が有効かどうか |
| `rate_limits.five_hour.used_percentage`, `rate_limits.seven_day.used_percentage` | 5 時間または 7 日間のレート制限の消費率（0 から 100） |
| `rate_limits.five_hour.resets_at`, `rate_limits.seven_day.resets_at` | 5 時間または 7 日間のレート制限ウィンドウがリセットされる時刻（Unix エポック秒） |
| `rate_limits.spend_limit.used_percentage`, `rate_limits.spend_limit.resets_at` | Claude apps ゲートウェイの背後で、支出上限をどれだけ使用したか、およびその期間がいつリセットされるか。[支出上限のフィールド](#spend-limit-fields)を参照してください。Claude Code v2.1.251 以降が必要です |
| `rate_limits.spend_limit.used_usd`, `rate_limits.spend_limit.limit_usd`, `rate_limits.spend_limit.period` | 米ドル建ての推定支出額と上限、および上限の期間。これらのフィールドは存在しない場合があります。[支出上限のフィールド](#spend-limit-fields)を参照してください。Claude Code とゲートウェイの両方で v2.1.284 以降が必要です |
| `prompt_cache` | メインの会話におけるセッションの[プロンプトキャッシュ](https://code.claude.com/docs/ja/prompt-caching.md)統計：ヒット率、ミス、キャッシュがウォームかどうか。すべてのフィールドについては[プロンプトキャッシュのフィールド](#prompt-cache-fields)を参照してください。メインの会話の最初の API レスポンスまでは存在しません。Claude Code v2.1.251 以降が必要です |
| `session_id` | 一意のセッション識別子 |
| `session_name` | セッション名。`--name` フラグまたは `/rename` で設定されたカスタム名があればそれを使用し、なければ AI が生成したセッションタイトルを使用します。`my-app-3f` のような[デフォルトの表示名](https://code.claude.com/docs/ja/sessions.md#name-your-sessions)は、このフィールドには設定されません。セッションにカスタム名も AI 生成のタイトルもない場合は存在しません |
| `prompt_id` | 現在処理中のユーザープロンプトを識別する UUID。[OpenTelemetry イベントの `prompt.id` 属性](https://code.claude.com/docs/ja/monitoring-usage#event-correlation-attributes)と一致します。最初のユーザー入力までは存在しません |
| `transcript_path` | 会話トランスクリプトファイルへのパス |
| `version` | Claude Code のバージョン |
| `output_style.name` | 現在の出力スタイルの名前 |
| `vim.mode` | [vim モード](https://code.claude.com/docs/ja/interactive-mode.md#vim-editor-mode)が有効な場合の現在の vim モード（`NORMAL`、`INSERT`、`VISUAL`、または `VISUAL LINE`） |
| `agent.name` | `--agent` フラグで実行している場合、またはエージェント設定が構成されている場合のエージェント名 |
| `pr.number`, `pr.url` | 現在のブランチのオープンなプルリクエスト。フッターの PR バッジを反映します。GitLab リモートを持つリポジトリでは、Claude Code は代わりにブランチのオープンな[マージリクエスト](https://code.claude.com/docs/ja/interactive-mode.md#gitlab-merge-requests)からこれらのフィールドを設定するため、`pr.number` はマージリクエスト番号になります。マージリクエストのデータには Claude Code v2.1.234 以降が必要です。git リポジトリ内にいない場合、プルリクエストまたはマージリクエストが見つかるまで、あるいはそれがマージまたはクローズされた後は存在しません |
| `pr.review_state` | オープンな PR のレビューステータス：`approved`、`pending`、`changes_requested`、または `draft`。`pr` が存在する場合でも、独立して存在しないことがあります |
| `pr.kind` | `pr` が [GitLab マージリクエスト](https://code.claude.com/docs/ja/interactive-mode.md#gitlab-merge-requests)を表す場合は `mr`。GitHub プルリクエストでは存在しないため、このフィールド以前に書かれたスクリプトも引き続き動作します。マージリクエストの場合、Claude Code は GitLab がマージ可能と報告したときに `review_state` を `approved` に、その他のオープン状態では `pending` に、ドラフトでは `draft` に設定します。Claude Code v2.1.234 以降が必要です |
| `worktree.name` | アクティブな worktree の名前。セッションが [worktree セッション](https://code.claude.com/docs/ja/worktrees.md)にある間のみ存在します |
| `worktree.path` | worktree ディレクトリへの絶対パス |
| `worktree.branch` | worktree の Git ブランチ名（例：`"worktree-my-feature"`）。フックベースの worktree では存在しません |
| `worktree.original_cwd` | worktree に入る前に Claude がいたディレクトリ |
| `worktree.original_branch` | worktree に入る前にチェックアウトされていた Git ブランチ。フックベースの worktree では存在しません |

> **完全な JSON スキーマ**
>
> ステータスラインコマンドは、stdin 経由で次の JSON 構造を受け取ります。
>
> ```json theme={null}
> {
>   "cwd": "/current/working/directory",
>   "session_id": "abc123...",
>   "session_name": "my-session",
>   "prompt_id": "550e8400-e29b-41d4-a716-446655440000",
>   "transcript_path": "/path/to/transcript.jsonl",
>   "model": {
>     "id": "claude-opus-5-5",
>     "display_name": "Opus"
>   },
>   "workspace": {
>     "current_dir": "/current/working/directory",
>     "project_dir": "/original/project/directory",
>     "added_dirs": [],
>     "git_worktree": "feature-xyz",
>     "repo": {
>       "host": "github.com",
>       "owner": "anthropics",
>       "name": "claude-code"
>     }
>   },
>   "version": "2.1.90",
>   "output_style": {
>     "name": "default"
>   },
>   "cost": {
>     "total_cost_usd": 0.01234,
>     "total_duration_ms": 45000,
>     "total_api_duration_ms": 2300,
>     "total_lines_added": 156,
>     "total_lines_removed": 23
>   },
>   "context_window": {
>     "total_input_tokens": 15500,
>     "total_output_tokens": 1200,
>     "context_window_size": 200000,
>     "used_percentage": 8,
>     "remaining_percentage": 92,
>     "current_usage": {
>       "input_tokens": 8500,
>       "output_tokens": 1200,
>       "cache_creation_input_tokens": 5000,
>       "cache_read_input_tokens": 2000
>     }
>   },
>   "exceeds_200k_tokens": false,
>   "prompt_cache": {
>     "warm": true,
>     "caching_observed": true,
>     "ttl": "1h",
>     "expires_at": 1738429200,
>     "requests": 14,
>     "misses": 2,
>     "expected_rebuilds": 1,
>     "hit_ratio": 0.91,
>     "cache_write_tokens": 352000,
>     "miss_recache_tokens": 310200,
>     "last_miss_at": 1738425230,
>     "last_miss_cause": {
>       "causes": ["tools_changed"],
>       "tools_added": 2,
>       "tools_removed": 0
>     },
>     "miss_causes": {
>       "tools_changed": 2
>     },
>     "recache_tokens_if_cold": 45000
>   },
>   "fast_mode": false,
>   "effort": {
>     "level": "high"
>   },
>   "thinking": {
>     "enabled": true
>   },
>   "rate_limits": {
>     "five_hour": {
>       "used_percentage": 23.5,
>       "resets_at": 1738425600
>     },
>     "seven_day": {
>       "used_percentage": 41.2,
>       "resets_at": 1738857600
>     },
>     "spend_limit": {
>       "used_percentage": 62.8,
>       "resets_at": 1740787200,
>       "used_usd": 314.12,
>       "limit_usd": 500,
>       "period": "monthly"
>     }
>   },
>   "vim": {
>     "mode": "NORMAL"
>   },
>   "agent": {
>     "name": "security-reviewer"
>   },
>   "pr": {
>     "number": 1234,
>     "url": "https://github.com/anthropics/claude-code/pull/1234",
>     "review_state": "pending"
>   },
>   "worktree": {
>     "name": "my-feature",
>     "path": "/path/to/.claude/worktrees/my-feature",
>     "branch": "worktree-my-feature",
>     "original_cwd": "/path/to/project",
>     "original_branch": "main"
>   }
> }
> ```
>
> **存在しない可能性のあるフィールド**（JSON に含まれない）：
>
> * `session_name`：`--name` または `/rename` でカスタム名が設定された場合、または AI 生成のセッションタイトルが存在するようになった時点で表示されます。`my-app-3f` のようなデフォルトの表示名はこのフィールドには設定されません
> * `prompt_id`：最初のユーザー入力の後にのみ表示されます
> * `workspace.git_worktree`：現在のディレクトリがリンク済みの git worktree 内にある場合にのみ表示されます
> * `workspace.repo`：`origin` リモートが設定された git リポジトリ内でのみ表示されます
> * `effort`：現在のモデルが推論エフォートパラメータをサポートしている場合にのみ表示されます
> * `vim`：vim モードが有効な場合にのみ表示されます
> * `agent`：`--agent` フラグで実行している場合、またはエージェント設定が構成されている場合にのみ表示されます
> * `pr`：現在のブランチでオープンな PR または GitLab マージリクエストが見つかっている間のみ表示され、マージまたはクローズされると削除されます。`pr.review_state` と `pr.kind` は独立して存在しないことがあります
> * `worktree`：セッションが [worktree セッション](https://code.claude.com/docs/ja/worktrees.md)にある間のみ表示されます。存在する場合でも、フックベースの worktree では `branch` と `original_branch` が存在しないことがあります
> * `rate_limits`：claude.ai の Pro および Max サブスクライバー、または支出上限を設定する Claude apps ゲートウェイの背後にいる場合にのみ、かつセッションの最初の API レスポンスの後にのみ表示されます。各ウィンドウ（`five_hour`、`seven_day`、`spend_limit`）は独立して存在しないことがあり、Claude Code は `resets_at` の時刻を過ぎたウィンドウを削除します。存在しない場合を適切に処理するには、`jq -r '.rate_limits.five_hour.used_percentage // empty'` を使用してください。
> * `prompt_cache`：メインの会話の最初の API レスポンスの後に表示されます。[プロンプトキャッシュのフィールド](#prompt-cache-fields)を参照してください
>
> **`null` になる可能性のあるフィールド**：
>
> * `context_window.current_usage`：セッションの最初の API 呼び出しの前は `null` で、`/compact` の後も次の API 呼び出しで再設定されるまで再び `null` になります
> * `context_window.used_percentage`、`context_window.remaining_percentage`：セッションの初期段階では `null` になることがあります
>
> スクリプトでは、存在しないフィールドは条件付きアクセスで、null 値はフォールバックのデフォルト値で処理してください。

### コンテキストウィンドウのフィールド

`context_window` オブジェクトは、直近の API レスポンスに基づく現在のコンテキストウィンドウを表します。

* **合計値**（`total_input_tokens`、`total_output_tokens`）：現在コンテキストウィンドウ内にあるトークン。`total_input_tokens` は `input_tokens`、`cache_creation_input_tokens`、`cache_read_input_tokens` の合計で、`total_output_tokens` は直近の応答の出力トークンです。どちらも最初の API レスポンスの前は `0` です。
* **コンポーネント別の使用量**（`current_usage`）：同じトークン数をカテゴリ別に分けたもの。キャッシュヒットを新規の入力と分けて把握する必要がある場合に使用します。

`current_usage` オブジェクトには以下が含まれます。

* `input_tokens`：現在のコンテキスト内の入力トークン
* `output_tokens`：生成された出力トークン
* `cache_creation_input_tokens`：キャッシュに書き込まれたトークン
* `cache_read_input_tokens`：キャッシュから読み取られたトークン

キャッシュフィールドの意味と課金方法については、[キャッシュパフォーマンスの確認](https://code.claude.com/docs/ja/prompt-caching.md#check-cache-performance)を参照してください。

`used_percentage` フィールドは入力トークンのみから計算されます：`input_tokens + cache_creation_input_tokens + cache_read_input_tokens`。`output_tokens` は含まれません。

`current_usage` からコンテキストの割合を手動で計算する場合は、`used_percentage` と一致させるために同じ入力のみの計算式を使用してください。

`current_usage` オブジェクトは、セッションの最初の API 呼び出しの前は `null` で、`/compact` の直後も次の API 呼び出しで再設定されるまで再び `null` になります。

### 支出上限のフィールド

[支出上限が設定された Claude apps ゲートウェイ](https://code.claude.com/docs/ja/claude-apps-gateway-spend-limits.md#usage-warnings-in-claude-code)の背後では、`rate_limits.spend_limit` オブジェクトがユーザーに適用される支出上限を表します。このオブジェクトはセッションの最初の API レスポンスの後に表示され、Claude Code v2.1.251 以降が必要です。スクリプトは、そのフィールドを別々のタイミングで受け取ります。

* `used_percentage` と `resets_at`：すべての応答で送られるため、`spend_limit` が存在する場合は常に存在します。`used_percentage` は 0 から 100 の範囲で、上限を超えると 100 を上回ります。`resets_at` は上限の期間がリセットされる時刻（Unix エポック秒）です。
* `used_usd`、`limit_usd`、`period`：これまでの米ドル建ての推定支出額と上限、および上限が対象とする期間（`daily`、`weekly`、`monthly` のいずれか）。ゲートウェイは [`used_usd` をトークン数から計算](https://code.claude.com/docs/ja/claude-apps-gateway-spend-limits#how-requests-are-priced)するため、これは推定値であり、請求額ではありません。Claude Code は、リクエストを送信している間、約 5 分ごとに別のリクエストでゲートウェイからこれらを読み取ります。金額は `used_percentage` より約 5 分古い場合があるため、両者が一時的に一致しないことがあります。Claude Code とゲートウェイの両方で v2.1.284 以降が必要です。

スクリプトは割合をこれらより先に受け取るため、`spend_limit` が存在する場合でも、`used_usd`、`limit_usd`、`period` は省略可能として扱ってください。スクリプトでは、`jq -r '.rate_limits.spend_limit.used_usd // empty'` のように、それぞれをフォールバック付きで読み取ってください。Claude Code v2.1.295 より前は、`CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC` を設定するとそのリクエストが無効になり、これらのフィールドは存在しないままでした。

### プロンプトキャッシュのフィールド

`prompt_cache` オブジェクトは、セッションのメインの会話が[プロンプトキャッシュ](https://code.claude.com/docs/ja/prompt-caching.md)をどのように使用しているかをまとめたものです。Claude Code は API の応答に含まれるキャッシュトークン数からこれを計算するため、すべてのプロバイダーで機能します。

このオブジェクトは、メインの会話の最初の API レスポンスの後に表示されます。Claude Code は、サブエージェントのリクエストをこれらの統計に含めません。Claude Code v2.1.251 以降が必要です。

次の表に、各フィールドとその意味を示します。タイムスタンプは `rate_limits.*.resets_at` と同じ単位の Unix エポック秒です。短いステータスラインでは通常、これらのうち 1 つか 2 つを表示します。`warm` と `hit_ratio` は、キャッシュの状態を最も直接的に要約します。

| フィールド | 説明 |
| - | - |
| `warm` | キャッシュされたプレフィックスがまだ TTL 内にあるかどうか。最後の応答でキャッシュトークンが報告されなかった場合は、`caching_observed` が `true` であっても `false` になります |
| `caching_observed` | このセッションでいずれかの応答がキャッシュトークンを報告したかどうか。`false` は、プロンプトキャッシュが無効であるか、プロバイダーまたはゲートウェイがそれを報告しないことを意味します |
| `ttl` | 現在キャッシュされているプレフィックスの[キャッシュの有効期間](https://code.claude.com/docs/ja/prompt-caching.md#cache-lifetime)：`"5m"` または `"1h"` |
| `expires_at` | キャッシュされたプレフィックスが TTL を過ぎてコールドになる時刻（エポック秒）。最後の応答でキャッシュトークンが報告されなかった場合は `null` |
| `requests` | このセッションでメインの会話について記録された API リクエスト数 |
| `misses` | キャッシュがすでに保持していたコンテンツを再処理したリクエスト数：リクエストがキャッシュから読み取れたはずの量のうち 5% 超かつ 2,000 トークン以上を再処理し、キャッシュ読み取りの不足をコンテキスト圧縮やツール結果のクリアで説明できないもの |
| `expected_rebuilds` | コンテキスト圧縮または古いツール結果のクリアに続いて行われたキャッシュの再構築の回数 |
| `hit_ratio` | このセッションのすべての入力トークンに占めるキャッシュ読み取りトークンの割合（0 から 1）。分母にはキャッシュ読み取り、キャッシュ書き込み、キャッシュされていない入力が含まれます。これらがすべてゼロの間は `null` |
| `cache_write_tokens` | このセッションでキャッシュに書き込まれたすべてのトークン（最初のリクエストの初回書き込みを含む） |
| `miss_recache_tokens` | ミスとしてカウントされたリクエストによってキャッシュに書き込まれたトークン |
| `last_miss_at` | 最後のミスが発生した時刻（エポック秒）。セッションにミスがない間は `null` |
| `last_miss_cause` | Claude Code が最後のミスの原因と推定したもの。[最後のミスの原因](#last-miss-cause)で説明しています。Claude Code v2.1.260 以降が必要です |
| `miss_causes` | このセッションで診断されたミスのうち、各原因によるものの件数。キーは `last_miss_cause` と同じ原因名です。Claude Code v2.1.260 以降が必要です |
| `recache_tokens_if_cold` | 次のリクエストまでにキャッシュがコールドになっていた場合に、そのリクエストが再キャッシュするトークン数。コンテキスト圧縮または古いツール結果のクリアの直後は、次のリクエストが書き換えられた会話のサイズを記録するまで `null` |

Claude Code は、同じ統計をターミナルの [`/usage` コマンドの `Prompt cache (main)` 行](https://code.claude.com/docs/ja/costs#prompt-cache-statistics)にも表示します。

#### 最後のミスの原因

`last_miss_cause` オブジェクトは、Claude Code が直近のミスの原因と推定したものを報告します。その `causes` 配列には、`tools_changed`、`system_prompt_changed`、`ttl_expired_5m`、`likely_server_side` などの原因名が 1 つ以上含まれます。このオブジェクトは、セッションの最初のミスまでは `null` で、Claude Code が直近のミスの原因を特定できなかった場合も再び `null` になります。Claude Code v2.1.260 以降が必要です。

2 つの原因では、オブジェクトに件数が追加されます。

* `tools_added` と `tools_removed`：`tools_changed` とともに、リクエストに追加またはリクエストから削除されたツールの数
* `system_char_delta`：`system_prompt_changed` とともに、システムプロンプトの長さの変化（文字数）

## 例

これらの例は一般的なステータスラインパターンを示しています。任意の例を使用するには：

1. スクリプトを `~/.claude/statusline.sh`（または `.py`/`.js`）などのファイルに保存します
2. 実行可能にします：`chmod +x ~/.claude/statusline.sh`
3. [設定](#manually-configure-a-status-line) にパスを追加します

Bash の例は [`jq`](https://jqlang.org/) を使用して JSON を解析します。Python と Node.js には組み込みの JSON 解析があります。

### コンテキストウィンドウの使用状況

現在のモデルとコンテキストウィンドウの使用状況を視覚的なプログレスバーで表示します。各スクリプトは stdin から JSON を読み取り、`used_percentage` フィールドを抽出し、塗りつぶされたブロック（▓）が使用状況を表す 10 文字のバーを構築します：

![モデル名とパーセンテージ付きプログレスバーを表示するステータスライン](https://mintcdn.com/claude-code/HDAmBwgbrZVk0pOt/images/statusline-context-window-usage.png?fit=max\&auto=format\&n=HDAmBwgbrZVk0pOt\&q=85\&s=f3918a549912dc47e90f2b69e68bc847)

```bash Bash theme={null}
#!/bin/bash
# stdin 全体を変数に読み込む
input=$(cat)

# jq でフィールドを抽出します。"// 0" は null のフォールバックを提供します
MODEL=$(echo "$input" | jq -r '.model.display_name')
PCT=$(echo "$input" | jq -r '.context_window.used_percentage // 0' | cut -d. -f1)

# プログレスバーを構築します：printf -v はスペースを作成し、
# ${var// /▓} は各スペースをブロック文字に置き換えます
BAR_WIDTH=10
FILLED=$((PCT * BAR_WIDTH / 100))
EMPTY=$((BAR_WIDTH - FILLED))
BAR=""
[ "$FILLED" -gt 0 ] && printf -v FILL "%${FILLED}s" && BAR="${FILL// /▓}"
[ "$EMPTY" -gt 0 ] && printf -v PAD "%${EMPTY}s" && BAR="${BAR}${PAD// /░}"

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

### git ステータスと色

ステージングされたファイルと変更されたファイルのカラーコード化されたインジケーターを使用して git ブランチを表示します。このスクリプトはターミナルの色に [ANSI エスケープコード](https://en.wikipedia.org/wiki/ANSI_escape_code#Colors) を使用します：`\033[32m` は緑、`\033[33m` は黄、`\033[0m` はデフォルトにリセットします。

![モデル、ディレクトリ、git ブランチ、ステージングされたファイルと変更されたファイルのカラーコード化されたインジケーターを表示するステータスライン](https://mintcdn.com/claude-code/HDAmBwgbrZVk0pOt/images/statusline-git-context.png?fit=max\&auto=format\&n=HDAmBwgbrZVk0pOt\&q=85\&s=f13c190724d9ec7188c17cd2f98b7bf4)

各スクリプトは現在のディレクトリが git リポジトリであるかどうかを確認し、ステージングされたファイルと変更されたファイルをカウントし、カラーコード化されたインジケーターを表示します：

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

### コストと期間の追跡

セッションの API コストと経過時間を追跡します。`cost.total_cost_usd` フィールドは現在のセッションのすべての API 呼び出しの推定コストを累積します。`cost.total_duration_ms` フィールドはセッション開始からの総経過時間を測定し、`cost.total_api_duration_ms` は API レスポンスを待つのに費やされた時間のみを追跡します。

各スクリプトはコストを通貨としてフォーマットし、ミリ秒を分と秒に変換します：

![モデル名、セッションコスト、期間を表示するステータスライン](https://mintcdn.com/claude-code/HDAmBwgbrZVk0pOt/images/statusline-cost-tracking.png?fit=max\&auto=format\&n=HDAmBwgbrZVk0pOt\&q=85\&s=925f7024c3b38be0f0eca63564bfb52f)

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

### 複数行を表示する

スクリプトは複数の行を出力して、より豊かなディスプレイを作成できます。

![最初の行にモデル名、ディレクトリ、git ブランチを表示し、2 番目の行にコンテキスト使用状況プログレスバー、コスト、期間を表示する複数行ステータスライン](https://mintcdn.com/claude-code/HDAmBwgbrZVk0pOt/images/statusline-multiline.png?fit=max\&auto=format\&n=HDAmBwgbrZVk0pOt\&q=85\&s=a9d0a2fe8e446d80b1abc46da3f93270)

この例は複数のテクニックを組み合わせています：閾値ベースの色（70% 未満は緑、70～89% は黄、90% 以上は赤）、プログレスバー、git ブランチ情報。各 `print` または `echo` ステートメントは別の行を作成します：

```bash Bash theme={null}
#!/bin/bash
input=$(cat)

MODEL=$(echo "$input" | jq -r '.model.display_name')
DIR=$(echo "$input" | jq -r '.workspace.current_dir')
COST=$(echo "$input" | jq -r '.cost.total_cost_usd // 0')
PCT=$(echo "$input" | jq -r '.context_window.used_percentage // 0' | cut -d. -f1)
DURATION_MS=$(echo "$input" | jq -r '.cost.total_duration_ms // 0')

CYAN='\033[36m'; GREEN='\033[32m'; YELLOW='\033[33m'; RED='\033[31m'; RESET='\033[0m'

# コンテキスト使用状況に基づいてバーの色を選択します
if [ "$PCT" -ge 90 ]; then BAR_COLOR="$RED"
elif [ "$PCT" -ge 70 ]; then BAR_COLOR="$YELLOW"
else BAR_COLOR="$GREEN"; fi

FILLED=$((PCT / 10)); EMPTY=$((10 - FILLED))
printf -v FILL "%${FILLED}s"; printf -v PAD "%${EMPTY}s"
BAR="${FILL// /█}${PAD// /░}"

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

### クリック可能なリンク

この例は GitHub リポジトリへのクリック可能なリンクを作成します。Cmd（macOS）または Ctrl（Windows/Linux）を押しながらクリックして、ブラウザでリンクを開きます。

![GitHub リポジトリへのクリック可能なリンクを表示するステータスライン](https://mintcdn.com/claude-code/HDAmBwgbrZVk0pOt/images/statusline-links.png?fit=max\&auto=format\&n=HDAmBwgbrZVk0pOt\&q=85\&s=4778a144a28cb498c99d5fa018bb374a)

各スクリプトは git リモート URL を取得し、SSH 形式を HTTPS に変換し、リポジトリ名を OSC 8 エスケープコードでラップします。Bash バージョンは `printf '%b'` を使用します。これはバックスラッシュエスケープを異なるシェル間でより確実に解釈します：

```bash Bash theme={null}
#!/bin/bash
input=$(cat)

MODEL=$(echo "$input" | jq -r '.model.display_name')

# git SSH URL を HTTPS に変換します
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

# git リモート URL を取得します
try:
    remote = subprocess.check_output(
        ['git', 'remote', 'get-url', 'origin'],
        stderr=subprocess.DEVNULL, text=True
    ).strip()
    # SSH を HTTPS 形式に変換します
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
        // SSH を HTTPS 形式に変換します
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

### レート制限の使用状況

claude.ai サブスクリプションのレート制限使用状況、または Claude アプリゲートウェイの支出制限に対する支出額をステータスラインに表示します。サブスクライバーの場合、`rate_limits` オブジェクトには、ローリング `five_hour` ウィンドウと週間 `seven_day` ウィンドウが含まれます。各ウィンドウは `used_percentage`（0～100）とウィンドウがリセットされる Unix エポック秒の `resets_at` を提供します。ゲートウェイの背後では、[支出制限フィールド](#spend-limit-fields) で説明されている `spend_limit` オブジェクトを読み取ります。

`rate_limits` オブジェクトは claude.ai Pro および Max サブスクライバー、または支出制限を持つ Claude アプリゲートウェイの背後にある場合のみ存在し、最初の API レスポンスの後のみです。各スクリプトは不在のフィールドを適切に処理し、ゲートウェイの背後では `spend: $314.12 / $500` を出力します。ドル額のフィールドが不在の間は `spend: 63%` を出力します：

```bash Bash theme={null}
#!/bin/bash
input=$(cat)

MODEL=$(echo "$input" | jq -r '.model.display_name')
# "// empty" は rate_limits が不在の場合、出力を生成しません
FIVE_H=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
WEEK=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')

LIMITS=""
[ -n "$FIVE_H" ] && LIMITS="5h: $(printf '%.0f' "$FIVE_H")%"
[ -n "$WEEK" ] && LIMITS="${LIMITS:+$LIMITS }7d: $(printf '%.0f' "$WEEK")%"

# Claude アプリゲートウェイの背後：ゲートウェイがドル額を報告する場合はドル額、それ以外はパーセンテージ
SPEND_PCT=$(echo "$input" | jq -r '.rate_limits.spend_limit.used_percentage // empty')
SPEND_USD=$(echo "$input" | jq -r '.rate_limits.spend_limit | select(.used_usd != null) | "$\(.used_usd) / $\(.limit_usd)"')
[ -n "$SPEND_PCT" ] && LIMITS="${LIMITS:+$LIMITS }spend: ${SPEND_USD:-$(printf '%.0f' "$SPEND_PCT")%}"

[ -n "$LIMITS" ] && echo "[$MODEL] | $LIMITS" || echo "[$MODEL]"
```

```python Python theme={null}
#!/usr/bin/env python3
import json, sys

data = json.load(sys.stdin)
model = data['model']['display_name']

parts = []
rate = data.get('rate_limits', {})
five_h = rate.get('five_hour', {}).get('used_percentage')
week = rate.get('seven_day', {}).get('used_percentage')

if five_h is not None:
    parts.append(f"5h: {five_h:.0f}%")
if week is not None:
    parts.append(f"7d: {week:.0f}%")

# Claude アプリゲートウェイの背後：ゲートウェイがドル額を報告する場合はドル額、それ以外はパーセンテージ
spend = rate.get('spend_limit', {})
if spend.get('used_percentage') is not None:
    if spend.get('used_usd') is not None:
        parts.append(f"spend: ${spend['used_usd']} / ${spend['limit_usd']}")
    else:
        parts.append(f"spend: {spend['used_percentage']:.0f}%")

if parts:
    print(f"[{model}] | {' '.join(parts)}")
else:
    print(f"[{model}]")
```

```javascript Node.js theme={null}
#!/usr/bin/env node
let input = '';
process.stdin.on('data', chunk => input += chunk);
process.stdin.on('end', () => {
    const data = JSON.parse(input);
    const model = data.model.display_name;

    const parts = [];
    const fiveH = data.rate_limits?.five_hour?.used_percentage;
    const week = data.rate_limits?.seven_day?.used_percentage;

    if (fiveH != null) parts.push(`5h: ${Math.round(fiveH)}%`);
    if (week != null) parts.push(`7d: ${Math.round(week)}%`);

    // Claude アプリゲートウェイの背後：ゲートウェイがドル額を報告する場合はドル額、それ以外はパーセンテージ
    const spend = data.rate_limits?.spend_limit;
    if (spend?.used_percentage != null) {
        parts.push(spend.used_usd != null
            ? `spend: $${spend.used_usd} / $${spend.limit_usd}`
            : `spend: ${Math.round(spend.used_percentage)}%`);
    }

    console.log(parts.length ? `[${model}] | ${parts.join(' ')}` : `[${model}]`);
});
```

### 高コストな操作をキャッシュする

ステータスラインスクリプトはアクティブなセッション中に頻繁に実行されます。`git status` や `git diff` などのコマンドは、特に大規模なリポジトリでは遅い場合があります。この例は git 情報を一時ファイルにキャッシュし、5 秒ごとにのみ更新します。

キャッシュファイル名は、セッション内のステータスラインの呼び出し間で安定している必要がありますが、異なるリポジトリの同時セッションが互いのキャッシュされた git 状態を読み取らないように、セッション間で一意である必要があります。`$$`、`os.getpid()`、`process.pid` のようなプロセスベースの識別子は、呼び出しのたびに変わり、キャッシュを無効にします。代わりに JSON 入力から `session_id` を使用します：これはセッションの有効期間中は安定しており、セッションごとに一意です。

各スクリプトは git コマンドを実行する前に、キャッシュファイルが不在であるか 5 秒より古いかを確認します：

```bash Bash theme={null}
#!/bin/bash
input=$(cat)

MODEL=$(echo "$input" | jq -r '.model.display_name')
DIR=$(echo "$input" | jq -r '.workspace.current_dir')
SESSION_ID=$(echo "$input" | jq -r '.session_id')

CACHE_FILE="/tmp/statusline-git-cache-$SESSION_ID"
CACHE_MAX_AGE=5  # 秒

cache_is_stale() {
    [ ! -f "$CACHE_FILE" ] || \
    # stat -c %Y（Linux）または stat -f %m（macOS）はファイルの最終更新時刻を出力します。
    # Linux フォームは最初に実行する必要があります：Linux では、macOS フォームは stdout にファイルシステムレポートを出力してから失敗し、その出力はコマンド置換によってキャプチャされ、算術を破壊します。
    [ $(($(date +%s) - $(stat -c %Y "$CACHE_FILE" 2>/dev/null || stat -f %m "$CACHE_FILE" 2>/dev/null || echo 0))) -gt $CACHE_MAX_AGE ]
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
session_id = data['session_id']

CACHE_FILE = f"/tmp/statusline-git-cache-{session_id}"
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
    const sessionId = data.session_id;

    const CACHE_FILE = `/tmp/statusline-git-cache-${sessionId}`;
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

### Windows 設定

Windows では、Claude Code はステータスラインコマンドを Git Bash 経由で実行します。Git Bash がインストールされている場合、または Git Bash がない場合は PowerShell を通じて実行します。

Git Bash は引用符なしのバックスラッシュをエスケープ文字として扱うため、`C:\Users\username\script.mjs` のような Windows スタイルのパスはセパレーターが削除された状態でスクリプトランナーに到達し、目に見えるエラーなしでコマンドが失敗します。`command` 文字列のファイルパスを以下の例に示すようにフォワードスラッシュで記述します。`~` 短縮形も機能し、Windows ホームディレクトリに展開されます。

PowerShell スクリプトをステータスラインとして実行するには、`powershell` 経由で呼び出します。これは Claude Code がコマンドを Git Bash または PowerShell を通じてルーティングするかどうかに関わらず機能します：

```json settings.json theme={null}
{
  "statusLine": {
    "type": "command",
    "command": "powershell -NoProfile -File C:/Users/username/.claude/statusline.ps1"
  }
}
```

```powershell statusline.ps1 theme={null}
$input_json = $input | Out-String | ConvertFrom-Json
$cwd = $input_json.cwd
$model = $input_json.model.display_name
$used = $input_json.context_window.used_percentage
$dirname = Split-Path $cwd -Leaf

if ($used) {
    Write-Host "$dirname [$model] ctx: $used%"
} else {
    Write-Host "$dirname [$model]"
}
```

または、Git Bash がインストールされている場合は、Bash スクリプトを直接実行します：

```json settings.json theme={null}
{
  "statusLine": {
    "type": "command",
    "command": "~/.claude/statusline.sh"
  }
}
```

```bash statusline.sh theme={null}
#!/usr/bin/env bash
input=$(cat)
cwd=$(echo "$input" | grep -o '"cwd":"[^"]*"' | cut -d'"' -f4)
model=$(echo "$input" | grep -o '"display_name":"[^"]*"' | cut -d'"' -f4)
dirname="${cwd##*[/\\]}"
echo "$dirname [$model]"
```

## サブエージェントステータスライン

`subagentStatusLine` 設定は、エージェントパネルに表示される各 [サブエージェント](https://code.claude.com/docs/ja/sub-agents.md) のカスタム行本体をレンダリングします。デフォルトの `name · description · token count` 行を独自のフォーマットに置き換えるために使用します。

```json theme={null}
{
  "subagentStatusLine": {
    "type": "command",
    "command": "~/.claude/subagent-statusline.sh"
  }
}
```

コマンドはリフレッシュティックごとに 1 回実行され、表示されているすべてのサブエージェント行を単一の JSON オブジェクトとして stdin で受け取ります。入力には [基本フックフィールド](https://code.claude.com/docs/ja/hooks.md#common-input-fields)、使用可能な行幅を示す `columns` フィールド、および行ごとに 1 つのエントリを持つ `tasks` 配列が含まれます。`tasks` 配列については [タスクフィールド](#task-fields) で説明します。

オーバーライドしたい各行に対して stdout に 1 つの JSON 行を書き込みます。形式は `{"id": "<task id>", "content": "<row body>"}` です。`content` 文字列はそのままレンダリングされます。ANSI 色と OSC 8 ハイパーリンクを含みます。タスクの `id` を省略して、その行のデフォルトレンダリングを保持します。空の `content` 文字列を出力して、その行を非表示にします。

`statusLine` に適用される同じトラストと `disableAllHooks` および [`allowManagedHooksOnly`](https://code.claude.com/docs/ja/settings-reference#allowmanagedhooksonly) ゲートが `subagentStatusLine` に適用されます。プラグインは、[`settings.json`](https://code.claude.com/docs/ja/plugins/manifest-reference#standard-layout) でデフォルトの `subagentStatusLine` を配布できます。ただし、フックとは異なり、プラグインが管理設定の `enabledPlugins` で強制的に有効化されている場合でも、プラグイン値は `allowManagedHooksOnly` の下で実行されません。

### タスクフィールド

`tasks` 配列の各エントリは、以下のフィールドで 1 つのサブエージェント行を記述します。省略可能と記載されたフィールドは値がない場合に省略されるため、スクリプトではそれらが存在しない場合に備えてください。

| フィールド | 型 | 説明 |
| :- | :- | :- |
| `id` | string | タスクの識別子。この行に対して書き戻す行で `id` としてそのまま返します |
| `name` | string、省略可能 | サブエージェントに名前がある場合、その [呼び出しに使われる](https://code.claude.com/docs/ja/sub-agents.md#subagent-names) 名前 |
| `type` | string | タスクの種類: `local_agent` |
| `agentType` | string | タスクが実行されるサブエージェントタイプ。組み込みの [`Explore`](https://code.claude.com/docs/ja/sub-agents#built-in-subagents) やカスタムの `code-reviewer` などです。フックが [`agent_type`](https://code.claude.com/docs/ja/hooks#subagentstart) として受け取るのと同じ値を保持します。Claude Code v2.1.293 以降が必要です |
| `status` | string | タスクの状態。`running`、`completed`、`failed`、`killed` など |
| `description` | string | タスクの短い説明。Claude がサブエージェントを生成したときに付けた説明など |
| `label` | string | Claude Code が持っている場合はタスクの短い進捗サマリー、それ以外の場合は `description` と同じテキスト |
| `startTime` | number | タスクが開始された時刻（Unix エポックからのミリ秒） |
| `model` | string、省略可能 | タスクが実行される解決済みモデルの ID。モデルが解決されるまでは省略されます |
| `effort` | string または number、省略可能 | サブエージェントの [定義フロントマター](https://code.claude.com/docs/ja/sub-agents.md#supported-frontmatter-fields) または個別の呼び出しで設定された推論 effort: `low`、`medium`、`high`、`xhigh`、`max`、またはトークン予算の数値。これは設定された値であり、モデルがそのレベルをサポートしていない場合、Claude Code が実際に適用する effort は異なる可能性があります。effort が設定されていない場合は省略されます |
| `contextWindowSize` | number、省略可能 | `model` のコンテキストウィンドウ（トークン単位）。メインステータスラインの [`context_window.context_window_size`](#context-window-fields) と同じ方法で計算されるため、`tokenCount` から行ごとのパーセンテージをレンダリングできます。`model` が省略されている場合は省略されます |
| `tokenCount` | number | サブエージェントの累計トークン数。デフォルトの行に表示される数値です |
| `tokenSamples` | array of numbers | 直近最大 16 個の `tokenCount` の読み取り値。リフレッシュティックごとに 1 つずつ、古い順に並び、現在の値で終わります |
| `cwd` | string | サブエージェントの作業ディレクトリ。隔離された worktree など独自のディレクトリで実行される場合はそのディレクトリ、それ以外の場合はセッションの作業ディレクトリです |

## ヒント

* **モック入力でテストする**：`echo '{"model":{"display_name":"Opus"},"workspace":{"current_dir":"/home/user/project"},"context_window":{"used_percentage":25},"session_id":"test-session-abc"}' | ./statusline.sh`
* **出力を短く保つ**：ステータスバーの幅は限られているため、長い出力は切り詰められたり、不適切にラップされたりする可能性があります
* **遅い操作をキャッシュする**：スクリプトはアクティブなセッション中に頻繁に実行されるため、`git status` などのコマンドは遅延を引き起こす可能性があります。これを処理する方法については、[キャッシング例](#cache-expensive-operations) を参照してください。

[ccstatusline](https://github.com/sirmalloc/ccstatusline) や [starship-claude](https://github.com/martinemde/starship-claude) などのコミュニティプロジェクトは、テーマと追加機能を備えた事前構築設定を提供します。

## トラブルシューティング

ステータスラインが空白の場合は、まず[ステータスラインが表示されない](#status-line-not-appearing)を確認してください。信頼していないフォルダや失敗するスクリプトによっても空白になります。これについては[ワークスペーストラストが必要](#workspace-trust-required)と[スクリプトエラーまたはハング](#script-errors-or-hangs)で説明しています。

### ステータスラインが表示されない

ステータスラインを設定したのにインターフェースの下部に何も表示されない場合は、次の項目を確認してください：

* スクリプトが実行可能であることを確認します：`chmod +x ~/.claude/statusline.sh`
* スクリプトが stdout に出力し、stderr に出力していないことを確認します
* スクリプトを手動で実行して、出力を生成することを確認します
* Windows で Git Bash がインストールされている場合、`command` パスのバックスラッシュはスクリプトが実行される前にエスケープ文字として消費される可能性があります。パスでは前方スラッシュを使用してください。[Windows 設定](#windows-configuration)を参照してください。
* [設定の優先順位](https://code.claude.com/docs/ja/hooks.md#disable-or-remove-hooks)が適用された後、`disableAllHooks` が管理設定外で `true` の場合、Claude Code は管理設定からの `statusLine` のみを実行し、管理 `statusLine` がない場合はステータスラインが無効になります。この設定を削除するか、それを設定するファイルで `false` に設定して、再度有効にします。[`disableAllHooks`](https://code.claude.com/docs/ja/settings-reference#disableallhooks)を参照してください。
* 組織が管理設定で `allowManagedHooksOnly` を設定している場合、カスタムステータスラインは警告なく消えます：これらの管理設定の `statusLine` 値からのみステータスラインを取得できます。[`allowManagedHooksOnly` で実行される内容](https://code.claude.com/docs/ja/settings-reference#what-runs-under-allowmanagedhooksonly)を参照して完全な動作を確認し、この設定が自分に適用されるかどうかを管理者に確認してください。
* `claude --debug` を実行すると、ステータスラインの呼び出しごとにスクリプトの stderr が、セッション内の最初の呼び出しではその終了コードがログに記録されます
* Claude に設定ファイルを読み取り、`statusLine` コマンドを直接実行するよう依頼して、エラーを表示します

### ステータスラインが `--` または空の値を表示する

フィールドは最初の API レスポンスが完了する前は `null` の可能性があるため、jq の `// 0` のようなフォールバックを使用してスクリプトで null 値を処理してください。複数のメッセージの後も値が空のままの場合は、Claude Code を再起動します。

### コンテキスト割合が予期しない値を表示する

ステータスラインは最後の API レスポンスからのカウントを報告し、`/context` はそのレスポンス以降に追加されたメッセージの推定値を加算するため、次のレスポンスまで `/context` の値の方が高くなることがあります。最も単純で正確なコンテキスト状態には `used_percentage` を使用します。`used_percentage` の計算式については、[コンテキストウィンドウフィールド](#context-window-fields)を参照してください。

### OSC 8 リンクがクリック可能でない

リンクがクリック可能かどうかは、ターミナル、Claude Code がそのターミナルでハイパーリンクサポートを検出するかどうか、SSH や tmux がエスケープシーケンスを取り除くかどうか、そしてスクリプトがそれをどのように出力するかによって決まります：

* ターミナルが OSC 8 ハイパーリンクをサポートしていることを確認します（iTerm2、Kitty、WezTerm）

* Terminal.app はクリック可能なリンクをサポートしていません

* リンクテキストが表示されているがクリック可能でない場合、Claude Code がターミナルのハイパーリンクサポートを検出できていない可能性があります。Claude Code を起動する前に `FORCE_HYPERLINK` 環境変数を設定して、検出を上書きします：

  ```bash theme={null}
  FORCE_HYPERLINK=1 claude
  ```

  PowerShell では、最初に現在のセッションで変数を設定します：

  ```powershell theme={null}
  $env:FORCE_HYPERLINK = "1"; claude
  ```

* SSH と tmux セッションは設定に応じて OSC シーケンスをストリップする可能性があります

* エスケープシーケンスが `\e]8;;` のようなリテラルテキストとして表示される場合は、`echo -e` の代わりに `printf '%b'` を使用して、より確実なエスケープ処理を行います

### エスケープシーケンスでの表示の不具合

複雑なエスケープシーケンス（ANSI 色、OSC 8 リンク）は、他の UI 更新と重複する場合、時々破損した出力を引き起こす可能性があります。エスケープコード付きの複数行ステータスラインは、プレーンテキストの単一行よりもレンダリングの問題が発生しやすくなります。

破損したテキストが表示される場合は、スクリプトをプレーンテキスト出力に簡略化してみてください。

### ワークスペーストラストが必要

ワークスペーストラストダイアログを受け入れるまで、ステータスラインは空白のままです。`statusLine` はシェルコマンドを実行するため、Claude Code は[設定ファイルのフックと同じワークスペーストラストルール](https://code.claude.com/docs/ja/permissions.md#what-runs-before-you-trust-a-folder)の下で実行します。フォルダのダイアログを受け入れるか、その信頼がそれに拡張される親ディレクトリのダイアログを受け入れるだけで十分です。

それまでの間、`claude --debug` は `Status line command skipped: workspace trust not accepted` をログに記録します。Claude Code を再起動し、トラストダイアログを受け入れて有効にします。

### スクリプトエラーまたはハング

Claude Code は、スクリプトが終了コード 0 で終了した後にのみ、その出力を表示します：

* ゼロ以外のコードで終了するか、出力を生成しないスクリプトは、ステータスラインを空白にします
* 遅いスクリプトは、完了するまでステータスラインの更新をブロックします。古い出力を避けるために、スクリプトを高速に保ちます。
* 遅いスクリプトの実行中に新しい更新がトリガーされた場合、実行中のスクリプトはキャンセルされます
* 設定する前に、モック入力を使用してスクリプトを独立してテストします

### 通知がステータスラインの行を共有する

[フルスクリーンレンダリング](https://code.claude.com/docs/ja/fullscreen.md)の外では、Claude Code は通知をステータスラインと同じ行に表示します。フルスクリーンレンダリングでは、Claude Code は通知に独自の行を提供します。

* MCP サーバーエラーおよび自動更新などのシステム通知は、行の右側に表示されます。コンテキスト低警告などの一時的な通知もこの領域を循環します。
* 詳細モードを有効にすると、この領域にトークンカウンターが追加されます。これは最後の API レスポンスが報告したコンテキストのサイズを示すもので、[スピナーの横に表示されるターンごとのカウント](https://code.claude.com/docs/ja/costs.md#read-the-token-count-beside-the-spinner)ではありません
* 狭いターミナルでは、これらの通知がステータスラインの出力を切り詰める可能性があります
