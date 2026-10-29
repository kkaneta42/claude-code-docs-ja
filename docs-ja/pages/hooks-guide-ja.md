> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# hooks でアクションを自動化する

> Claude Code がファイルを編集したり、タスクを完了したり、入力が必要になったりしたときに、シェルコマンドを自動的に実行します。コードをフォーマットし、通知を送信し、コマンドを検証し、プロジェクトルールを適用します。

Hooks はユーザー定義のシェルコマンドです。Claude Code はそのライフサイクルの特定のポイントで実行され、決定論的な制御を提供します。LLM が実行を選択するのに依存するのではなく、特定のアクションが常に発生します。Hooks を使用して、プロジェクトルールを適用し、反復的なタスクを自動化し、Claude Code を既存のツールと統合します。

判断が必要な決定については、決定論的なルールではなく、Claude モデルを使用して条件を評価する [プロンプトベースの hooks](#prompt-based-hooks) または [エージェントベースの hooks](#agent-based-hooks) を使用することもできます。

Claude Code を拡張する他の方法については、Claude に追加の指示と実行可能なコマンドを与えるための [skills](https://code.claude.com/docs/ja/skills.md)、分離されたコンテキストでタスクを実行するための [subagents](https://code.claude.com/docs/ja/sub-agents.md)、プロジェクト全体で共有する拡張機能をパッケージ化するための [plugins](https://code.claude.com/docs/ja/plugins/overview.md) を参照してください。

> [!TIP]
>
> このガイドでは一般的なユースケースと始め方をカバーしています。完全なイベントスキーマ、JSON 入力/出力形式、非同期 hooks や MCP ツール hooks などの高度な機能については、[Hooks リファレンス](https://code.claude.com/docs/ja/hooks.md) を参照してください。

## 最初の hook をセットアップする

Hook を作成するには、[設定ファイル](#configure-hook-location) に `hooks` ブロックを追加します。このチュートリアルではデスクトップ通知 hook を作成するため、Claude があなたの入力を待っているときにアラートを受け取ることができます。ターミナルを監視する代わりに。

**1. hook を設定に追加する**

`~/.claude/settings.json` を開き、`Notification` hook を追加します。ファイルが存在しない場合は、作成してください。以下の例は macOS 用に `osascript` を使用しています。Linux と Windows のコマンドについては、[Claude が入力を必要とするときに通知を受け取る](#get-notified-when-claude-needs-input) を参照してください。

```json theme={null}
{
  "hooks": {
    "Notification": [
      {
        "matcher": "",
        "hooks": [
          {
            "type": "command",
            "command": "osascript -e 'display notification \"Claude Code needs your attention\" with title \"Claude Code\"'"
          }
        ]
      }
    ]
  }
}
```

設定ファイルに既に `hooks` キーがある場合は、オブジェクト全体を置き換えるのではなく、`Notification` を既存のイベントキーの兄弟として追加します。各イベント名は単一の `hooks` オブジェクト内のキーです：

```json theme={null}
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [{ "type": "command", "command": "jq -r '.tool_input.file_path' | xargs npx prettier --write" }]
      }
    ],
    "Notification": [
      {
        "matcher": "",
        "hooks": [{ "type": "command", "command": "osascript -e 'display notification \"Claude Code needs your attention\" with title \"Claude Code\"'" }]
      }
    ]
  }
}
```

CLI で実現したい内容を説明して、Claude にフックを書いてもらうこともできます。

**2. 設定を確認する**

Claude Code のプロンプトで `/hooks` と入力して hooks ブラウザを開きます。新しいフックが `Notification` の下のリストに表示されます。

**3. フックをテストする**

`Esc` を押して CLI に戻ります。ステータスバーに `⏸ manual mode on` が表示されるまで `Shift+Tab` を押し、権限が必要な操作を Claude に依頼してから、ターミナル以外のウィンドウに切り替えます。デスクトップ通知を受け取るはずです。

## 自動化できること

フックを使うと、Claude Code のライフサイクルの重要なポイントでコードを実行できます。編集後のファイルのフォーマット、実行前のコマンドのブロック、Claude が入力を必要としたときの通知送信、セッション開始時のコンテキスト注入などが可能です。フックイベントの全一覧については、[フックリファレンス](https://code.claude.com/docs/ja/hooks.md#hook-lifecycle)を参照してください。

各例には、[設定ファイル](#configure-hook-location)に追加するだけで使える設定ブロックが含まれています。

別のモデルによるレビューを実行し、その結果をセッションにフィードバックするフックの本番環境での例については、[`security-guidance` プラグインが Claude Code と統合される仕組み](https://code.claude.com/docs/ja/security-guidance#how-the-plugin-integrates-with-claude-code)を参照してください。

### Claude が入力を必要としたときに通知を受け取る

Claude が作業を終えて入力を必要とするたびにデスクトップ通知を受け取れるため、ターミナルを確認しなくても他のタスクに切り替えられます。

このフックは `Notification` イベントを使用します。このイベントは、Claude が入力または権限を待っているときに Claude Code が発火させます。正確なタイミングについては、[各通知タイプが発火するタイミング](https://code.claude.com/docs/ja/hooks.md#notification)を参照してください。

以下の各タブでは、プラットフォームネイティブの通知コマンドを使用しています。これを `~/.claude/settings.json` に追加します。

**macOS**

```json theme={null}
{
  "hooks": {
    "Notification": [
      {
        "matcher": "",
        "hooks": [
          {
            "type": "command",
            "command": "osascript -e 'display notification \"Claude Code needs your attention\" with title \"Claude Code\"'"
          }
        ]
      }
    ]
  }
}
```

> **通知が表示されない場合**
>
> `osascript` は、組み込みのスクリプトエディタアプリを経由して通知を送ります。スクリプトエディタに通知の権限がない場合、コマンドは何も表示せずに失敗し、macOS は権限の付与を求めるプロンプトを表示しません。
>
> ターミナルで次のコマンドを一度実行して、スクリプトエディタが通知設定に表示されるようにします。
>
> ```bash theme={null}
> osascript -e 'display notification "test"'
> ```
>
> この時点ではまだ何も表示されません。**システム設定 > 通知**を開き、一覧から**スクリプトエディタ**を見つけて、**通知を許可**をオンにします。コマンドを再度実行して、テスト通知が表示されることを確認します。

**Linux**

```json theme={null}
{
  "hooks": {
    "Notification": [
      {
        "matcher": "",
        "hooks": [
          {
            "type": "command",
            "command": "notify-send 'Claude Code' 'Claude Code needs your attention'"
          }
        ]
      }
    ]
  }
}
```

> **通知が表示されない場合**
>
> `notify-send` にはデスクトップ通知デーモンが必要ですが、ヘッドレスサーバー、SSH セッション、およびほとんどのコンテナにはこれがありません。まずコマンドを直接テストします。
>
> ```bash theme={null}
> notify-send 'Claude Code' 'test'
> ```
>
> コマンドが見つからない場合は、Debian および Ubuntu では `libnotify-bin` パッケージを、それ以外ではディストリビューションの同等のパッケージをインストールします。

**Windows (PowerShell)**

```json theme={null}
{
  "hooks": {
    "Notification": [
      {
        "matcher": "",
        "hooks": [
          {
            "type": "command",
            "command": "powershell.exe -Command \"[System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms'); [System.Windows.Forms.MessageBox]::Show('Claude Code needs your attention', 'Claude Code')\""
          }
        ]
      }
    ]
  }
}
```

> **ダイアログが表示されない場合**
>
> このコマンドは画面の隅に表示される通知ではなくダイアログボックスを開くため、ダイアログがターミナルウィンドウの背後に開くことがあります。まず PowerShell でコマンドを直接テストしてください。
>
> WSL 内で Claude Code を実行している場合は、Windows の相互運用機能を通じて `powershell.exe` が `PATH` 上で利用可能である必要があります。

空の `matcher` はすべての通知タイプで発火します。特定のイベントでのみ発火させるには、次のいずれかの値を設定します。

| Matcher | 発火するタイミング |
| :- | :- |
| `permission_prompt` | Claude がツールの使用、またはサンドボックス化されたコマンドの[ネットワークリクエスト](https://code.claude.com/docs/ja/sandboxing.md#network-isolation)の承認を必要とし、プロンプトが約 6 秒間待機したとき |
| `idle_prompt` | Claude が約 60 秒前に応答を終え、それ以降ユーザーが入力していないとき |
| `auth_success` | 認証が完了したとき |
| `elicitation_dialog` | MCP サーバーが elicitation フォームを開き、ユーザーが約 6 秒間入力していないとき |
| `elicitation_url_dialog` | MCP サーバーがブラウザで URL を開くよう求め、ユーザーが約 6 秒間入力していないとき |
| `elicitation_complete` | MCP サーバーが [URL モードの elicitation](https://code.claude.com/docs/ja/hooks.md#elicitation-input) の完了を報告したとき |
| `elicitation_response` | MCP の elicitation への応答がサーバーに送り返されたとき |
| `agent_needs_input` | [エージェントビュー](https://code.claude.com/docs/ja/agent-view.md)が開いている間に、バックグラウンドセッションがユーザーの入力待ちを開始したとき。また、ターミナルセッションで[エージェントチームのチームメイトのターミナル設定に関する質問](https://code.claude.com/docs/ja/agent-teams.md#choose-a-display-mode)や、auto モードの[分類器リクエストの料金](https://code.claude.com/docs/ja/auto-mode-classifier-billing.md)に関するお知らせが表示され、ユーザーが約 6 秒間入力していないときにも発火します |
| `agent_completed` | バックグラウンドセッションが完了または失敗したとき。[エージェントビュー](https://code.claude.com/docs/ja/agent-view.md)が開いている間のみ発火します |
| `quota_auto_resume_fired` | claude.ai の使用制限によって一時停止されたタスクを Claude Code が続行したとき。リセット時、または待機中に Claude Code で行った操作（使用クレジットの追加、プランのアップグレード、モデルの切り替えなど）によって使用量が再び利用可能になった場合はそれより早く続行します。ただし[モデル設定に関する例外](https://code.claude.com/docs/ja/interactive-mode.md#wait-for-a-usage-limit-to-reset)があります |
| `quota_auto_resume_stale` | コンピューターが約 30 分を超えてスリープしている間に claude.ai の使用制限がリセットされたとき。Claude Code は続行せず、ユーザーが `Enter` を押すのを待ちます。スリープがそれより短い場合は続行し、代わりに `quota_auto_resume_fired` を発火させます |
| `quota_auto_resume_disabled` | Claude Code がタスクを続行せずに claude.ai の使用制限の待機を終了したとき。具体的には、[`autoContinueAtUsageLimit`](https://code.claude.com/docs/ja/settings-reference#autocontinueatusagelimit) がオフにされた場合、Claude Code が自ら開始した待機中にリセットが 24 時間以上先に移動した場合、続行したタスクが繰り返し制限に達した場合、または続行がモデルに届く前にブロックされた場合です。ユーザーが `Esc` または `Ctrl+C` を押した場合や、**Don't continue automatically** を選択した場合は発火しません |
| `plugin_notification` | [mod](https://code.claude.com/docs/ja/plugins/mods/api.md#show-something-without-starting-a-turn) が `$.ui.notify` で通知を発行したとき。mod がタイトルを設定していない限り、フックの `title` は mod の名前になります |

Claude Code は、ターミナルと、Claude Desktop、VS Code 拡張機能、および Agent SDK を通じて権限リクエストに応答するその他のホストとで、`permission_prompt` のタイミングを異なる方法で計測します。両方のタイミングについては、[各通知タイプが発火するタイミング](https://code.claude.com/docs/ja/hooks.md#notification)を参照してください。

`quota_auto_resume_fired`、`quota_auto_resume_stale`、`quota_auto_resume_disabled` の各 matcher には Claude Code v2.1.234 以降が必要です。

ターミナルセッションでは、サンドボックス化されたコマンドのネットワークリクエストに対する `permission_prompt` には Claude Code v2.1.246 以降が必要です。

チームメイトのターミナル設定に関する質問に対する `agent_needs_input` には Claude Code v2.1.248 以降が必要です。

Claude Code のプロンプトで `/hooks` と入力し、フックが `Notification` の下に表示されることを確認します。

### 編集後にコードを自動フォーマットする

Claude が編集するすべてのファイルに対して [Prettier](https://prettier.io/) を自動的に実行し、手動で介入しなくてもフォーマットの一貫性を保ちます。

このフックは `Edit|Write` matcher を指定した `PostToolUse` イベントを使用するため、ファイル編集ツールの後にのみ実行されます。コマンドは [`jq`](https://jqlang.org/) で編集されたファイルのパスを抽出し、Prettier に渡します。これをプロジェクトルートの `.claude/settings.json` に追加します。

```json theme={null}
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [
          {
            "type": "command",
            "command": "jq -r '.tool_input.file_path' | xargs npx prettier --write"
          }
        ]
      }
    ]
  }
}
```

フックをテストするには、シングルクォートの文字列を含む行を JavaScript ファイルに追加するよう Claude に依頼してから、そのファイルを開きます。Prettier のデフォルト設定では、フックがそれらをダブルクォートに書き換えます。

フックが成功した場合、Claude Code は会話に何も表示しません。フックが実行されたことを確認するには、編集したファイルが再フォーマットされていることを確認するか、[フックが何をしたかを確認する](#check-what-a-hook-did)を参照してください。

`Bash` コマンドによる書き換えを含め、特定のファイルがどのように変更されても再フォーマットするには、代わりに [FileChanged](https://code.claude.com/docs/ja/hooks.md#filechanged) フックを使用します。

> [!NOTE]
>
> このページの Bash の例では、JSON の解析に `jq` を使用しています。macOS では `brew install jq`、Debian および Ubuntu では `apt-get install jq` でインストールするか、[`jq` のダウンロード](https://jqlang.org/download/)を参照してください。

### 保護されたファイルへの編集をブロックする

`.env`、`package-lock.json`、または `.git/` 内のファイルなど、機密性の高いファイルを Claude が変更しないようにします。Claude は編集がブロックされた理由を説明するフィードバックを受け取るため、アプローチを調整できます。

この例では、フックが呼び出す別のスクリプトファイルを使用します。スクリプトは対象のファイルパスを保護パターンのリストと照合し、終了コード 2 で終了して編集をブロックします。

**1. フックスクリプトを作成する**

これを `.claude/hooks/protect-files.sh` に保存します。

```bash theme={null}
#!/bin/bash
# protect-files.sh

INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')

# Normalize Windows backslash separators so the patterns below match
FILE_PATH="${FILE_PATH//\\//}"

PROTECTED_PATTERNS=(".env" "package-lock.json" ".git/")

for pattern in "${PROTECTED_PATTERNS[@]}"; do
  if [[ "$FILE_PATH" == *"$pattern"* ]]; then
    echo "Blocked: $FILE_PATH matches protected pattern '$pattern'" >&2
    exit 2
  fi
done

exit 0
```

**2. macOS と Linux でスクリプトを実行可能にする**

Claude Code がフックスクリプトを実行するには、スクリプトが実行可能である必要があります。

```bash theme={null}
chmod +x .claude/hooks/protect-files.sh
```

**3. フックを登録する**

`Edit` または `Write` のツール呼び出しの前にスクリプトを実行する `PreToolUse` フックを `.claude/settings.json` に追加します。

```json theme={null}
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [
          {
            "type": "command",
            "command": "\"$CLAUDE_PROJECT_DIR\"/.claude/hooks/protect-files.sh"
          }
        ]
      }
    ]
  }
}
```

**4. フックをテストする**

`.env` ファイルにコメントを追加するよう Claude に依頼します。Claude Code は編集が実行される前にブロックし、スクリプトの `Blocked:` メッセージをフィードバックとして Claude に渡します。

### コンテキスト圧縮後にコンテキストを再注入する

Claude のコンテキストウィンドウがいっぱいになると、コンテキスト圧縮によって会話が要約され、空き容量が確保されます。これにより重要な詳細が失われることがあります。`compact` matcher を指定した `SessionStart` フックを使用して、圧縮のたびに重要なコンテキストを再注入します。

Claude Code は、コマンドが stdout に書き込んだプレーンテキストを Claude のコンテキストに追加します。この例では、プロジェクトの規約と最近の作業を Claude にリマインドします。これをプロジェクトルートの `.claude/settings.json` に追加します。

```json theme={null}
{
  "hooks": {
    "SessionStart": [
      {
        "matcher": "compact",
        "hooks": [
          {
            "type": "command",
            "command": "echo 'Reminder: use Bun, not npm. Run bun test before committing. Current sprint: auth refactor.'"
          }
        ]
      }
    ]
  }
}
```

`echo` は、最近のコミットを表示する `git log --oneline -5` など、動的な出力を生成する任意のコマンドに置き換えられます。すべてのセッション開始時にコンテキストを注入する場合は、代わりに [CLAUDE.md](https://code.claude.com/docs/ja/memory.md) の使用を検討してください。環境変数については、リファレンスの [`CLAUDE_ENV_FILE`](https://code.claude.com/docs/ja/hooks#persist-environment-variables) を参照してください。

### 設定の変更を監査する

セッション中に設定ファイルやスキルファイルが変更されたタイミングを追跡します。`ConfigChange` イベントは、外部プロセスやエディタが設定ファイルを変更したときに発火するため、コンプライアンスのために変更をログに記録したり、許可されていない変更をブロックしたりできます。

この例では、各変更を監査ログに追記します。これを `~/.claude/settings.json` に追加します。

```json theme={null}
{
  "hooks": {
    "ConfigChange": [
      {
        "matcher": "",
        "hooks": [
          {
            "type": "command",
            "command": "jq -c '{timestamp: now | todate, source: .source, file: .file_path}' >> ~/claude-config-audit.log"
          }
        ]
      }
    ]
  }
}
```

matcher は設定の種類でフィルタリングします。`user_settings`、`project_settings`、`local_settings`、`policy_settings`、`skills` のいずれかです。変更が反映されないようにブロックするには、終了コード 2 で終了するか、`{"decision": "block"}` を返します。入力スキーマの全体については、[ConfigChange リファレンス](https://code.claude.com/docs/ja/hooks.md#configchange)を参照してください。

フックが変更を記録していることを確認するには、セッションの実行中に別のエディタで設定ファイルを編集してから、`~/claude-config-audit.log` を開きます。フックは変更ごとに、タイムスタンプ、ソース、ファイルパスを含む JSON を 1 行追記します。

### ディレクトリやファイルが変更されたときに環境を再読み込みする

プロジェクトによっては、どのディレクトリにいるかに応じて異なる環境変数を設定します。[direnv](https://direnv.net/) などのツールはシェルでこれを自動的に行いますが、Claude の Bash ツールはそれらの変更を自動的には取り込みません。

`SessionStart` フックと `CwdChanged` フックを組み合わせると、この問題を解決できます。`SessionStart` は起動時のディレクトリの変数を読み込み、`CwdChanged` は Claude がディレクトリを変更するたびに変数を再読み込みします。どちらも `CLAUDE_ENV_FILE` に書き込み、Claude Code はこれを各 Bash コマンドの前にスクリプトのプリアンブルとして実行します。これを `~/.claude/settings.json` に追加します。

```json theme={null}
{
  "hooks": {
    "SessionStart": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "direnv export bash > \"$CLAUDE_ENV_FILE\""
          }
        ]
      }
    ],
    "CwdChanged": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "direnv export bash > \"$CLAUDE_ENV_FILE\""
          }
        ]
      }
    ]
  }
}
```

`.envrc` があるディレクトリごとに `direnv allow` を一度実行し、direnv がそれを読み込めるように許可します。direnv の代わりに devbox や nix を使用している場合は、`direnv export bash` の代わりに `devbox shellenv` または `devbox global shellenv` を使用すれば同じパターンが使えます。

ディレクトリの変更のたびではなく特定のファイルに反応させるには、監視するファイル名を `|` で区切って列挙した `matcher` とともに `FileChanged` を使用します。監視リストを作成する際、Claude Code はこの値を正規表現として評価するのではなく、リテラルのファイル名に分割します。ファイルが変更されたときに実行されるフックグループを同じ値がどのようにフィルタリングするかについては、[FileChanged](https://code.claude.com/docs/ja/hooks.md#filechanged) を参照してください。この例では、作業ディレクトリ内の `.envrc` と `.env` を監視します。

```json theme={null}
{
  "hooks": {
    "FileChanged": [
      {
        "matcher": ".envrc|.env",
        "hooks": [
          {
            "type": "command",
            "command": "direnv export bash > \"$CLAUDE_ENV_FILE\""
          }
        ]
      }
    ]
  }
}
```

入力スキーマ、`watchPaths` の出力、`CLAUDE_ENV_FILE` の詳細については、[CwdChanged](https://code.claude.com/docs/ja/hooks.md#cwdchanged) および [FileChanged](https://code.claude.com/docs/ja/hooks.md#filechanged) のリファレンス項目を参照してください。

### 特定の権限プロンプトを自動承認する

常に許可しているツール呼び出しについて、承認ダイアログをスキップします。この例では、Claude がプランの提示を終えて続行の可否を尋ねるときに呼び出すツールである `ExitPlanMode` を自動承認するため、プランの準備ができるたびにプロンプトが表示されることはありません。

上記の終了コードの例とは異なり、自動承認ではフックが JSON の決定を stdout に書き込む必要があります。Claude Code はユーザーに権限を求めようとするときに `PermissionRequest` フックを実行し、フックが `"behavior": "allow"` を返すと、Claude Code がユーザーに代わってリクエストに応答します。

matcher によってフックのスコープが `ExitPlanMode` のみに限定されるため、他のプロンプトには影響しません。これを `~/.claude/settings.json` に追加します。

```json theme={null}
{
  "hooks": {
    "PermissionRequest": [
      {
        "matcher": "ExitPlanMode",
        "hooks": [
          {
            "type": "command",
            "command": "echo '{\"hookSpecificOutput\": {\"hookEventName\": \"PermissionRequest\", \"decision\": {\"behavior\": \"allow\"}}}'"
          }
        ]
      }
    ]
  }
}
```

フックが承認すると、Claude Code は plan モードを終了し、plan モードに入る前に有効だった権限モードを復元します。トランスクリプトには、ダイアログが表示されるはずだった場所に「Allowed by PermissionRequest hook」と表示されます。フック経由の場合は常に現在の会話が維持されます。ダイアログのようにコンテキストをクリアして新しい実装セッションを開始することはできません。

代わりに特定の権限モードを設定するには、フックの出力に `setMode` エントリを含む `updatedPermissions` 配列を含めることができます。`mode` の値には `default`、`acceptEdits`、`bypassPermissions` などの任意の権限モードを指定でき、`destination: "session"` を指定すると現在のセッションにのみ適用されます。

> [!NOTE]
>
> `bypassPermissions` は、バイパスモードがすでに利用可能な状態でセッションを開始した場合にのみ適用されます。具体的には、`--dangerously-skip-permissions`、`--permission-mode bypassPermissions`、`--allow-dangerously-skip-permissions`、または[ユーザー設定、`--settings`、管理設定](https://code.claude.com/docs/ja/settings-reference#permissions-defaultmode)での `permissions.defaultMode: "bypassPermissions"` のいずれかです。[`permissions.disableBypassPermissionsMode`](https://code.claude.com/docs/ja/permissions#managed-settings) によってバイパスモードが無効化されている場合や、[制限モード](https://code.claude.com/docs/ja/cli-reference.md#cli-flags)でセッションを開始した場合は適用されません。
>
> Claude Code がこれを `defaultMode` として保存することはありません。

セッションを `acceptEdits` に切り替えるには、フックが次の JSON を stdout に書き込みます。

```json theme={null}
{
  "hookSpecificOutput": {
    "hookEventName": "PermissionRequest",
    "decision": {
      "behavior": "allow",
      "updatedPermissions": [
        { "type": "setMode", "mode": "acceptEdits", "destination": "session" }
      ]
    }
  }
}
```

matcher はできるだけ狭く保ってください。`.*` でマッチさせたり matcher を空のままにしたりすると、ファイルの書き込みやシェルコマンドを含むすべてのツールの権限プロンプトが自動承認されてしまいます。決定フィールドの全体については、[PermissionRequest リファレンス](https://code.claude.com/docs/ja/hooks.md#permissionrequest-decision-control)を参照してください。

## フックの仕組み

Claude Code は、ライフサイクルの特定の時点でフックイベントを発火させます。イベントが発火すると、Claude Code は一致するフックを並列に実行します。重複したハンドラーの扱いについては [フックハンドラーのフィールド](https://code.claude.com/docs/ja/hooks.md#hook-handler-fields) を参照してください。以下の表は、各イベントとそれがトリガーされるタイミングを示しています。

| イベント | 発火するタイミング |
| :- | :- |
| `SessionStart` | セッションが開始または再開されたとき |
| `Setup` | `--init-only` で Claude Code を起動するとき、または `-p` モードで `--init` または `--maintenance` を使用するとき。CI またはスクリプトでの 1 回限りの準備用 |
| `UserPromptSubmit` | プロンプトを送信するとき、Claude が処理する前。[Claude Code が独自に開始するターン](https://code.claude.com/docs/ja/hooks.md#userpromptsubmit)でも発火します |
| `UserPromptExpansion` | ユーザーが入力したコマンドがプロンプトに展開されるとき、Claude に到達する前。展開をブロックできます |
| `PreToolUse` | ツール呼び出しが実行される前。ブロックできます |
| `PermissionRequest` | ツール呼び出しが権限決定を必要とするとき |
| `PermissionDenied` | オートモードがツール呼び出しを拒否するとき、分類器の判定がない拒否を含みます。JSON `hookSpecificOutput.retry: true` を使用して、モデルが拒否されたツール呼び出しを再試行できることを伝えます。Claude Code は分類器が判定を出さなかった場合、`retry` を無視します |
| `PostToolUse` | ツール呼び出しが成功した後 |
| `PostToolUseFailure` | ツール呼び出しが失敗した後 |
| `PostToolBatch` | 並列ツール呼び出しの完全なバッチが解決した後、次のモデル呼び出しの前 |
| `Notification` | Claude Code が通知を送信するとき |
| `MessageDisplay` | アシスタントメッセージテキストが表示されている間 |
| `SubagentStart` | サブエージェントがスポーンされるとき |
| `SubagentStop` | サブエージェントが終了するとき |
| `TaskCreated` | `TaskCreate` 経由でタスクが作成されるとき |
| `TaskCompleted` | タスクが完了としてマークされるとき |
| `Stop` | Claude が応答を終了するとき |
| `StopFailure` | API エラーが原因でターンが終了するとき |
| `TeammateIdle` | [エージェントチーム](https://code.claude.com/docs/ja/agent-teams.md) のチームメイトがアイドル状態になろうとするとき |
| `InstructionsLoaded` | CLAUDE.md または `.claude/rules/*.md` ファイルがコンテキストに読み込まれるとき。セッション開始時およびセッション中にファイルが遅延読み込みされるときに発火します |
| `ConfigChange` | セッション中に設定ファイルが変更されるとき |
| `CwdChanged` | 作業ディレクトリが変更されるとき、例えば Claude が `cd` コマンドを実行するとき。direnv などのツールを使用したリアクティブな環境管理に便利です |
| `DirectoryAdded` | `/add-dir` または SDK `register_repo_root` コントロールリクエスト経由でセッション中盤に作業ディレクトリが追加されるとき |
| `FileChanged` | 監視対象ファイルがディスク上で変更されるとき。`matcher` フィールドは監視するファイル名を指定します |
| `WorktreeCreate` | `--worktree`、`isolation: "worktree"`、またはバックグラウンドセッション経由で worktree が作成されるとき。デフォルトの git 動作を置き換えます |
| `WorktreeRemove` | `WorktreeCreate` フックが作成した worktree が削除されるとき |
| `PreCompact` | コンテキスト圧縮の前 |
| `PostCompact` | コンテキスト圧縮が完了した後 |
| `PreModelSwitch` | Claude Code があなたまたはクライアントがリクエストしたモデルスイッチを適用する前。スイッチをブロックできます |
| `PostModelSwitch` | セッションのモデルが変更された後、Claude Code が独自に行う変更（セッションを再開するときのモデル復元など）を含みます |
| `Elicitation` | MCP サーバーがツール呼び出し中にユーザー入力をリクエストするとき |
| `ElicitationResult` | ユーザーが MCP エリシテーションに応答した後、レスポンスがサーバーに送り返される前 |
| `SessionEnd` | セッションが終了するとき |

各フックには、実行方法を決める `type` があります。ほとんどのフックは、シェルコマンドを実行する `"type": "command"` を使用します。ほかに 4 つのタイプが利用できます。

* `"type": "http"`：イベントデータを URL に POST します。[HTTP フック](#http-hooks) を参照してください。
* `"type": "mcp_tool"`：設定済みの MCP サーバー上のツールを呼び出します。[MCP ツールフック](https://code.claude.com/docs/ja/hooks.md#mcp-tool-hook-fields) を参照してください。
* `"type": "prompt"`：シングルターンの LLM 評価です。[プロンプトベースのフック](#prompt-based-hooks) を参照してください。
* `"type": "agent"`：ツールにアクセスできるマルチターンの検証です。エージェントフックは実験的な機能であり、変更される可能性があります。[エージェントベースのフック](#agent-based-hooks) を参照してください。

### 複数のフックの結果を組み合わせる

複数のフックが同じイベントに一致した場合、Claude Code は、すべてのフックのコマンドが完了するまで実行してから結果をマージします。あるフックが `deny` を返しても、兄弟フックの実行は止まりません。あるフックの `deny` によって、別のフックの副作用を抑止できると想定しないでください。

一致するすべてのフックが完了すると、Claude Code はそれらの出力を組み合わせます。`PreToolUse` の権限の判定では、`deny`、`defer`、`ask`、`allow` の順で、最も制限の厳しい回答が適用されます。`additionalContext` のテキストはすべてのフックから保持され、まとめて Claude に渡されます。

以下の例では、`Bash` に対して 2 つの `PreToolUse` フックを登録しています。1 つ目はすべてのコマンドをログファイルに追記して終了コード 0 で終了します。2 つ目は、コマンドに `rm -rf` が含まれる場合に終了コード 2 で終了して拒否するスクリプトを実行します。

```json theme={null}
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "jq -r .tool_input.command >> ~/.claude/bash.log"
          },
          {
            "type": "command",
            "command": "\"$CLAUDE_PROJECT_DIR\"/.claude/hooks/block-rm-rf.sh"
          }
        ]
      }
    ]
  }
}
```

Claude が `rm -rf /tmp/build` を実行しようとすると、両方のフックが並列に実行されます。ログ記録フックはコマンドを `~/.claude/bash.log` に書き込んで終了コード 0 で終了し、これは判定なしを意味します。ガードレールフックは終了コード 2 で終了し、ツール呼び出しを拒否します。拒否が優先されるため、Claude Code はコマンドをブロックし、ガードレールの stderr を Claude に表示します。ログ記録フックはすでに実行済みであるため、ログのエントリは書き込まれたままになります。

### 入力を読み取り、出力を返す

フックは、stdin、stdout、stderr、および終了コードを通じて Claude Code とやり取りします。イベントが発火すると、Claude Code はイベント固有のデータを JSON としてスクリプトの stdin に渡します。スクリプトはそのデータを読み取って処理を行い、終了コードによって次に何をすべきかを Claude Code に伝えます。

#### フックの入力

すべてのイベントには、セッションの一意な ID である `session_id` や、イベント発火時の作業ディレクトリである `cwd` などの共通フィールドが含まれますが、イベントタイプごとに異なるデータが追加されます。Claude が Bash コマンドを実行するとき、`PreToolUse` フックは stdin で次のフィールドを受け取ります。

* `hook_event_name`：フックをトリガーしたイベント
* `tool_name`：Claude が使用しようとしているツール
* `tool_input`：Claude がツールに渡した引数。Bash の場合、その `command` フィールドにシェルコマンドが入ります。

たとえば、`npm test` コマンドのフック入力は次のようになります。

```json theme={null}
{
  "session_id": "abc123",
  "cwd": "/Users/sarah/myproject",
  "hook_event_name": "PreToolUse",
  "tool_name": "Bash",
  "tool_input": {
    "command": "npm test"
  }
}
```

スクリプトはこの JSON を解析し、これらのフィールドのいずれかに基づいて処理を行えます。`UserPromptSubmit` フックは代わりに `prompt` テキストを受け取り、`SessionStart` フックは `startup`、`resume`、`clear`、`compact`、`fork` のいずれかの `source` を受け取る、といった具合です。共通フィールドについてはリファレンスの [共通入力フィールド](https://code.claude.com/docs/ja/hooks.md#common-input-fields) を、イベント固有のスキーマについては各イベントのセクションを参照してください。

#### フックの出力

スクリプトは、stdout または stderr に書き込み、特定のコードで終了することで、次に何をすべきかを Claude Code に伝えます。次の `PreToolUse` フックはコマンドをブロックします。

```bash theme={null}
#!/bin/bash
INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command')

if echo "$COMMAND" | grep -q "drop table"; then
  echo "Blocked: dropping tables is not allowed" >&2  # stderr becomes Claude's feedback
  exit 2 # exit 2 = block the action
fi

exit 0  # exit 0 = no decision; the normal permission flow applies
```

終了コードが 0 と 2 以外で、有効な JSON 出力がない場合、ほとんどのイベントではアクションが続行されます。ただし、そのフックが [失敗時にアクションをブロックする](https://code.claude.com/docs/ja/hooks.md#block-the-action-when-a-hook-fails) フックである場合は除きます。`onFailure` が `"block"` に設定されたフックがその一例です。異議がないことを伝えるには終了コード 0 で、アクションをブロックするには終了コード 2 で終了します。

* **終了コード 0**：`PreToolUse` フックから終了コード 0 で終了した場合でも、ツール呼び出しは通常の [権限フロー](https://code.claude.com/docs/ja/permissions.md) を経由します。終了コード 0 はツール呼び出しを承認するものではないためです。`UserPromptSubmit`、`UserPromptExpansion`、`SessionStart`、`PostModelSwitch` フックでは、Claude Code は [プレーンテキストとして扱う](https://code.claude.com/docs/ja/hooks.md#exit-code-0) stdout を Claude のコンテキストに追加します。
* **終了コード 2**：stderr に理由を書き込みます。イベントに応じて、Claude が調整できるようにフィードバックとして受け取るか、ユーザーに表示されるか、あるいは `ConfigChange` や `Elicitation` のようにメッセージが表示されないかのいずれかになります。ブロックできないイベントもあります。`SessionStart` などでは、終了コード 2 は stderr をユーザーに表示し、実行は続行されます。完全な一覧については [イベントごとの終了コード 2 の動作](https://code.claude.com/docs/ja/hooks.md#exit-code-2-behavior-per-event) を参照してください。
* **その他の終了コード**：0 以外の終了コードで失敗する `WorktreeCreate` など、イベントごとの例外については [終了コードの出力](https://code.claude.com/docs/ja/hooks.md#exit-code-output) を参照してください。その他のイベントでは、フックが失敗時にアクションをブロックするものでない限り、フックが stdout に出力した内容から該当するケースを確認してください。
  * スキーマ検証に合格する解析済みオブジェクト：Claude Code は終了コードを無視し、JSON のみで結果が決まり、フックはエラーとして報告されません。
  * スキーマ検証に失敗する解析済みオブジェクト、または Claude Code が [JSON として解析しようとする](https://code.claude.com/docs/ja/hooks.md#exit-code-0) ものの有効な JSON ではない stdout：アクションは非ブロッキングエラーとして続行されます。検証または解析のメッセージについては、`<hook name> hook error` の通知を確認してください。
  * Claude Code が [プレーンテキストとして扱う](https://code.claude.com/docs/ja/hooks.md#exit-code-0) stdout、または空の stdout：アクションは非ブロッキングエラーとして続行されます。トランスクリプトには `<hook name> hook error` の通知が表示され、その後に `Failed with non-blocking status code:` が先頭に付いた stderr の 1 行目が表示されます。stderr の全体を取得するには、`claude --debug` を使用するか、セッション中に `/debug` を実行して [デバッグログ](https://code.claude.com/docs/ja/hooks.md#debug-hooks) を有効にしてください。

#### 構造化 JSON 出力

終了コードでは、ブロックするか何もしないかしか選べません。より細かく制御するには、代わりに終了コード 0 で終了し、JSON オブジェクトを stdout に出力します。

> [!NOTE]
>
> stderr のメッセージとともにブロックするには終了コード 2 を、構造化された制御には JSON とともに終了コード 0 を使用します。フックごとにいずれか一方の方法を選んでください。両者を混在させた場合の動作については、[終了コードの出力](https://code.claude.com/docs/ja/hooks.md#exit-code-output) を参照してください。

たとえば、`PreToolUse` フックはツール呼び出しを拒否してその理由を Claude に伝えたり、承認を求めてユーザーにエスカレーションしたりできます。

```json theme={null}
{
  "hookSpecificOutput": {
    "hookEventName": "PreToolUse",
    "permissionDecision": "deny",
    "permissionDecisionReason": "Use rg instead of grep for better performance"
  }
}
```

`"deny"` の場合、Claude Code はツール呼び出しをキャンセルし、`permissionDecisionReason` を Claude にフィードバックします。

`PreToolUse` では、`"ask"` を返してユーザーに通常の権限プロンプトを表示したり、`"allow"` を返して対話的な権限プロンプトをスキップしたりすることもできます。`"allow"` の場合でも、エンタープライズ管理の拒否リストを含む拒否ルールと確認ルールは引き続き適用され、次の場合のプロンプトも表示されます。

* [ネットワークパス](https://code.claude.com/docs/ja/permissions.md#network-paths) からの読み取り
* [`requiresUserInteraction`](https://code.claude.com/docs/ja/mcp#require-approval-for-a-specific-tool) が指定された MCP ツール
* [Agent SDK アプリが `always_ask` を指定したツール](https://code.claude.com/docs/ja/agent-sdk/custom-tools#require-approval-for-specific-tools) の呼び出し（[権限モードがその呼び出しを承認する](https://code.claude.com/docs/ja/agent-sdk/typescript.md#permission-modes-that-can-approve-an-always_ask-call) 場合を除く）
* その設定が Claude Code に及ぶセッションにおいて、[組織が `ask` に設定した](https://code.claude.com/docs/ja/mcp#organization-controls-on-connector-tools) コネクタツール

plan モードでの `"allow"` の動作については、[plan モードでのフックによる承認](https://code.claude.com/docs/ja/permissions.md#hook-approvals-in-plan-mode) を参照してください。

4 つ目の値である `"defer"` は、`-p` フラグを使用した [非対話モード](https://code.claude.com/docs/ja/headless.md) で利用できます。これを返すと、ツール呼び出しを保持したままターンが終了するため、Agent SDK のラッパーが入力を収集して再開できます。リファレンスの [ツール呼び出しを後回しにする](https://code.claude.com/docs/ja/hooks.md#defer-a-tool-call-for-later) を参照してください。

`PreModelSwitch` フックも同じ `permissionDecision` フィールドを返します。`"allow"` はモデルの切り替えを続行させ、`"deny"` はキャンセルします。`"ask"` は、対話セッションで `/model` を実行したときに切り替えの確認を求めます。それ以外の場面では、Claude Code は `"ask"` を拒否として扱います。[PreModelSwitch の判定制御](https://code.claude.com/docs/ja/hooks.md#premodelswitch-decision-control) を参照してください。

その他のイベントでは、異なる判定パターンを使用します。たとえば、`PostToolUse` と `Stop` フックはトップレベルの `decision: "block"` フィールドを使用し、`PermissionRequest` は `hookSpecificOutput.decision.behavior` を使用します。イベントごとの詳細な内訳については、リファレンスの [概要表](https://code.claude.com/docs/ja/hooks.md#decision-control) を参照してください。

`UserPromptSubmit` フックでは、Claude のコンテキストにテキストを挿入するために、代わりに `hookSpecificOutput.additionalContext` を使用します。`additionalContext` は `hookSpecificOutput` の内側にネストしてください。JSON のトップレベルに配置すると、Claude Code は何も通知せずにそれを無視します。たとえば、次の出力はすべてのプロンプトに現在のブランチの状態を追加します。

```json theme={null}
{
  "hookSpecificOutput": {
    "hookEventName": "UserPromptSubmit",
    "additionalContext": "Current branch: release-42. Deploy freeze until Friday."
  }
}
```

プロンプトのブロックやセッションタイトルの設定を含む出力の完全な形式については、[UserPromptSubmit の判定制御](https://code.claude.com/docs/ja/hooks.md#userpromptsubmit-decision-control) を参照してください。

`type: "prompt"` のフックは出力の扱いが異なります。[プロンプトベースのフック](#prompt-based-hooks) を参照してください。

### matcher でフックを絞り込む

matcher がない場合、フックはそのイベントが発生するたびに発火します。matcher を使うと、これを絞り込めます。たとえば、すべてのツール呼び出しの後ではなく、ファイル編集の後にのみフォーマッターを実行したい場合は、`PostToolUse` フックに matcher を追加します。

```json theme={null}
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [
          { "type": "command", "command": "prettier --write ..." }
        ]
      }
    ]
  }
}
```

`"Edit|Write"` matcher は、Claude が `Edit` または `Write` ツールを使用したときにのみ発火し、`Bash`、`Read`、その他のツールを使用したときには発火しません。カンマも同様に選択肢を区切るため、`"Edit, Write"` も同等です。単純な名前と正規表現がどのように評価されるかについては、[matcher のパターン](https://code.claude.com/docs/ja/hooks.md#matcher-patterns) を参照してください。

> [!NOTE]
>
> Claude はシェルコマンドを実行してファイルを作成または変更することもできます。コンプライアンススキャンや監査ログの記録など、フックがすべてのファイル変更を把握する必要がある場合は、ターンごとに 1 回作業ツリーをスキャンする [`Stop`](https://code.claude.com/docs/ja/hooks#stop) フックを追加してください。代わりに呼び出しごとに網羅したい場合は、`Bash|PowerShell` にも一致させ、スクリプトで `git status --porcelain` を使って変更されたファイルと追跡されていないファイルを一覧表示するようにします。`Bash` だけに一致させるのでは不十分な理由については、[PowerShell フックの入力セクション](https://code.claude.com/docs/ja/hooks.md#powershell) で説明しています。書き込んだのが何であれ、特定のファイルがディスク上で変更されたときにフックを実行するには、[FileChanged](https://code.claude.com/docs/ja/hooks.md#filechanged) フックを使用してください。

各イベントタイプは、特定のフィールドに対して照合されます。

| イベント | matcher が絞り込む対象 | matcher の値の例 |
| :- | :- | :- |
| `PreToolUse`、`PostToolUse`、`PostToolUseFailure`、`PermissionRequest`、`PermissionDenied` | ツール名 | `Bash`、`Edit\|Write`、`mcp__.*` |
| `SessionStart` | セッションの開始方法 | `startup`、`resume`、`clear`、`compact`、`fork` |
| `Setup` | セットアップをトリガーした CLI フラグ | `init`、`maintenance` |
| `SessionEnd` | セッションが終了した理由 | `clear`、`resume`、`logout`、`prompt_input_exit`、`other` |
| `Notification` | 通知の種類 | `permission_prompt`、`idle_prompt`、`auth_success`、`elicitation_dialog`、`elicitation_url_dialog`、`elicitation_complete`、`elicitation_response`、`agent_needs_input`、`agent_completed`、`quota_auto_resume_fired`、`quota_auto_resume_stale`、`quota_auto_resume_disabled`、`plugin_notification` |
| `SubagentStart` | エージェントの種類 | `general-purpose`、`Explore`、`Plan`、またはカスタムエージェント名 |
| `PreCompact`、`PostCompact` | コンテキスト圧縮をトリガーしたもの | `manual`、`auto` |
| `PreModelSwitch`、`PostModelSwitch` | [PreModelSwitch](https://code.claude.com/docs/ja/hooks.md#premodelswitch) で説明されている、セッションの切り替え先モデルの正規名 | `claude-opus-5`、`claude-opus-4-6\|claude-opus-5`、`.*opus.*` |
| `SubagentStop` | エージェントの種類 | `SubagentStart` と同じ値 |
| `ConfigChange` | 設定のソース | `user_settings`、`project_settings`、`local_settings`、`policy_settings`、`skills` |
| `DirectoryAdded` | ディレクトリが追加された方法 | `slash_command`、`register_repo_root` |
| `StopFailure` | エラーの種類 | `rate_limit`、`overloaded`、`authentication_failed`、`oauth_org_not_allowed`、`account_on_hold`、`billing_error`、`invalid_request`、`model_not_found`、`server_error`、`max_output_tokens`、`cloud_credential_error`、`unknown` |
| `InstructionsLoaded` | 読み込みの理由 | `session_start`、`nested_traversal`、`path_glob_match`、`include`、`compact` |
| `Elicitation` | MCP サーバー名 | 設定済みの MCP サーバー名 |
| `ElicitationResult` | MCP サーバー名 | `Elicitation` と同じ値 |
| `FileChanged` | 監視するファイル名のリテラル（[FileChanged](https://code.claude.com/docs/ja/hooks.md#filechanged) を参照） | `.envrc\|.env` |
| `UserPromptExpansion` | コマンド名 | スキル名またはコマンド名 |
| `UserPromptSubmit`、`PostToolBatch`、`Stop`、`TeammateIdle`、`TaskCreated`、`TaskCompleted`、`WorktreeCreate`、`WorktreeRemove`、`CwdChanged`、`MessageDisplay` | matcher 非対応 | 発生するたびに常に発火 |

以下のタブでは、さまざまなイベントタイプに対する matcher の例をさらにいくつか示します。

**すべての Bash コマンドをログに記録する**

`Bash` ツールの呼び出しのみに一致させ、各コマンドをファイルにログとして記録します。`PostToolUse` イベントはコマンドの完了後に発火するため、`tool_input.command` には実行された内容が含まれます。フックは stdin で JSON としてイベントデータを受け取り、`jq -r '.tool_input.command'` がコマンド文字列のみを抽出し、`>>` がそれをログファイルに追記します。

```json theme={null}
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "jq -r '.tool_input.command' >> ~/.claude/command-log.txt"
          }
        ]
      }
    ]
  }
}
```

**MCP ツールに一致させる**

MCP ツールは、組み込みツールとは異なる命名規則 `mcp__<server>__<tool>` を使用します。ここで `<server>` は MCP サーバー名、`<tool>` はそのサーバーが提供するツールです。たとえば、`mcp__github__search_repositories` や `mcp__filesystem__read_file` などです。[プラグインにバンドルされたサーバー](https://code.claude.com/docs/ja/mcp.md#plugin-provided-mcp-servers) のツールは、代わりに `mcp__plugin_my-plugin_db__query` のようにスコープ付きのサーバーセグメントを使用します。特定のサーバーのすべてのツールを対象にするには正規表現の matcher を使用し、サーバーをまたいで一致させるには `mcp__.*__write.*` のようなパターンを使用します。例の完全な一覧については、リファレンスの [MCP ツールに一致させる](https://code.claude.com/docs/ja/hooks.md#match-mcp-tools) を参照してください。

以下のコマンドは、`jq` を使ってフックの JSON 入力からツール名を抽出し、stderr に書き込みます。stderr に書き込むことで、stdout を JSON 出力用にクリーンに保ち、メッセージを [デバッグログ](https://code.claude.com/docs/ja/hooks.md#debug-hooks) に送ることができます。

```json theme={null}
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "mcp__github__.*",
        "hooks": [
          {
            "type": "command",
            "command": "echo \"GitHub tool called: $(jq -r '.tool_name')\" >&2"
          }
        ]
      }
    ]
  }
}
```

**セッション終了時にクリーンアップする**

`SessionEnd` イベントは、セッションが終了した理由に対する matcher をサポートしています。このフックは、`/clear` を実行したときに設定される `clear` の理由でのみ発火し、通常の終了では発火しません。

```json theme={null}
{
  "hooks": {
    "SessionEnd": [
      {
        "matcher": "clear",
        "hooks": [
          {
            "type": "command",
            "command": "rm -f /tmp/claude-scratch-*.txt"
          }
        ]
      }
    ]
  }
}
```

#### `if` フィールドでツール名と引数によって絞り込む

`if` フィールドは [権限ルールの構文](https://code.claude.com/docs/ja/permissions.md) を使用して、ツール名と引数の両方でフックを絞り込みます。これにより、ツール呼び出しが一致した場合にのみフックのプロセスが起動されます。これは、グループレベルでツール名のみによって絞り込む `matcher` よりも踏み込んだ絞り込みです。

たとえば、次の設定では、すべての Bash コマンドではなく、Claude が `git` コマンドを使用したときにのみフックを実行します。

```json theme={null}
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "if": "Bash(git *)",
            "command": "\"$CLAUDE_PROJECT_DIR\"/.claude/hooks/check-git-policy.sh"
          }
        ]
      }
    ]
  }
}
```

フックのコマンドが実行されるかどうかは、`if` パターンの形と、Claude が呼び出す Bash コマンドによって決まります。

| `if` パターン | Bash コマンド | フックは実行されるか | 理由 |
| :- | :- | :- | :- |
| `Bash(git *)` | `git push` | はい | コマンド名が一致する |
| `Bash(git *)` | `npm test && git push` | はい | 各サブコマンドがチェックされ、`git push` が一致する |
| `Bash(git *)` | `echo $(git log)` | はい | `$()` やバッククォート内のコマンドもチェックされ、`git log` が一致する |
| `Bash(git *)` | `echo $(date)` | いいえ | `git *` に一致するサブコマンドがない |
| `Bash(git push *)` | `echo $(date)` | はい | コマンド名以上を指定するパターンでは、`$()`、バッククォート、`$VAR` があるとフックがいずれにせよ実行される |

Bash の入力がどのコマンドを実行するかを Claude Code が判断できない場合、パターンにかかわらずフックが実行されます。Claude Code がサブコマンド単位で絞り込めるコマンドの形と絞り込めない形については、[Bash の照合表](https://code.claude.com/docs/ja/hooks.md#bash-if-matching) を参照してください。この絞り込みはベストエフォートであるため、厳密な許可や拒否を強制するには、フックではなく [権限システム](https://code.claude.com/docs/ja/permissions.md) を使用してください。

`if` フィールドは、権限ルールと同じパターン（`"Bash(git *)"`、`"Edit(*.ts)"` など）を受け付けます。複数のツール名に一致させるには、それぞれ独自の `if` 値を持つ個別のハンドラーを使用するか、パイプによる選択がサポートされている `matcher` レベルで照合してください。

`if` はツールイベント（`PreToolUse`、`PostToolUse`、`PostToolUseFailure`、`PermissionRequest`、`PermissionDenied`）でのみ機能します。それ以外のイベントに追加すると、フックは実行されなくなります。

### フックの場所を設定する

フックを追加する場所によって、そのスコープが決まります。

| 場所 | スコープ | 共有可能か |
| :- | :- | :- |
| `~/.claude/settings.json` | すべてのプロジェクト | いいえ、ローカルマシンのみ |
| `.claude/settings.json` | 単一のプロジェクト | はい、リポジトリにコミット可能 |
| `.claude/settings.local.json` | 単一のプロジェクト | いいえ、Claude Code がこのファイルに設定を保存した時点で gitignore される |
| 管理ポリシー設定 | 組織全体 | はい、管理者が制御 |
| [プラグイン](https://code.claude.com/docs/ja/plugins/overview.md) の `hooks/hooks.json` | プラグインが有効なとき | はい、プラグインにバンドル |
| [スキル](https://code.claude.com/docs/ja/skills.md) のフロントマター | スキルが呼び出された後、セッションの残りの期間。[スキルとエージェントにおけるフック](https://code.claude.com/docs/ja/hooks.md#hooks-in-skills-and-agents) を参照 | はい、スキルファイル内で定義 |
| [サブエージェント](https://code.claude.com/docs/ja/sub-agents.md) のフロントマター | そのサブエージェントの実行中 | はい、サブエージェントファイル内で定義 |

Claude Code で [`/hooks`](https://code.claude.com/docs/ja/hooks#the-%2Fhooks-menu) を実行すると、設定済みのすべてのフックをイベントごとにグループ化して参照できます。

フックを無効にするには、設定ファイルで `"disableAllHooks": true` を設定します。Claude Code は [設定の優先順位](https://code.claude.com/docs/ja/hooks.md#disable-or-remove-hooks) が適用された後に残った値を読み取るため、プロジェクトの設定ファイルがユーザーの設定を上書きすることがあります。管理設定で構成されたフックは、そこでも `disableAllHooks` が設定されていない限り実行され続けます。各レベルの影響範囲の詳細については、[`disableAllHooks`](https://code.claude.com/docs/ja/settings-reference#disableallhooks) を参照してください。

Claude Code の実行中に設定ファイルを直接編集した場合、通常はファイルウォッチャーがフックの変更を自動的に検出します。

## プロンプトベースの hooks

決定論的なルールではなく判断が必要な決定については、`type: "prompt"` hooks を使用します。シェルコマンドを実行する代わりに、Claude Code はプロンプトと hook の入力データを Claude モデルに送信して決定を下します。より多くの機能が必要な場合は、`model` フィールドで異なるモデルを指定できます。

モデルの唯一の仕事は、その決定を JSON として返すことです：

* `"ok": true`：アクションが続行されます
* `"ok": false`：何が起こるかはイベントによって異なります：
  * `Stop` および `SubagentStop`：`reason` は Claude にフィードバックとして返されるため、作業を続けます。ただし、応答が `"impossible": true` も設定している場合は、その条件が決して満たされることのない条件として印付けられ、その場合 Claude Code は停止を許可してターンが終了します
  * `PreToolUse`：ツール呼び出しが拒否されます。デフォルトではターンが終了し、拒否の `reason` は警告行としてチャットに表示されます。フックに `continueOnBlock: true` を設定すると、代わりに `reason` を Claude にツールエラーとして返すため、調整して続行できます
  * `PostToolUse`：デフォルトではターンが終了し、`reason` は警告行としてチャットに表示されます。`continueOnBlock: true` を設定すると、`reason` を Claude にフィードバックとして返し、代わりにターンを続行します
  * `PostToolBatch`、`UserPromptSubmit`、および `UserPromptExpansion`：ターンが終了し、`reason` は警告行としてチャットに表示されます

この例は `Stop` hook を使用して、要求されたすべてのタスクが完了しているかどうかをモデルに尋ねます。モデルが条件がまだ満たされていないため `"ok": false` を返す場合、Claude は作業を続け、`reason` を次の指示として使用します：

```json theme={null}
{
  "hooks": {
    "Stop": [
      {
        "hooks": [
          {
            "type": "prompt",
            "prompt": "Check if all tasks are complete. If not, respond with {\"ok\": false, \"reason\": \"what remains to be done\"}."
          }
        ]
      }
    ]
  }
}
```

完全な設定オプションについては、リファレンスの [プロンプトベースの hooks](https://code.claude.com/docs/ja/hooks.md#prompt-based-hooks) を参照してください。

## エージェントベースの hooks

> [!WARNING]
>
> エージェント hooks は実験的です。動作と設定は将来のリリースで変更される可能性があります。本番ワークフローについては、[コマンド hooks](https://code.claude.com/docs/ja/hooks.md#command-hook-fields) を優先してください。

検証がファイルの検査またはコマンドの実行を必要とする場合、`type: "agent"` hooks を使用します。プロンプト hooks は単一の LLM 呼び出しを行いますが、エージェント hooks は条件を返す前にファイルを読み取り、コードを検索し、他のツールを使用できる subagent を生成します。

エージェント hooks は `"ok"` / `"reason"` 応答形式を使用し、デフォルトのタイムアウトが 60 秒で、最大 50 ツール使用ターンです。プロンプト hooks の `impossible` フィールドはサポートされていません。`ok: false` の場合、Claude Code はエージェント hooks を同じイベント上で `continueOnBlock: true` を持つプロンプト hooks と同じ方法で処理するため、`PreToolUse` と `PostToolUse` ではターンが続行されます。エージェント hooks には `continueOnBlock` フィールドがありません。フィールドを含む [エージェント hooks の設定](https://code.claude.com/docs/ja/hooks.md#agent-hook-configuration) を参照してください。これには Claude Code が hooks の JSON 入力に置き換える `$ARGUMENTS` プレースホルダーが含まれます。

この例は Claude が停止することを許可する前にテストが合格することを検証します：

```json theme={null}
{
  "hooks": {
    "Stop": [
      {
        "hooks": [
          {
            "type": "agent",
            "prompt": "Verify that all unit tests pass. Run the test suite and check the results. $ARGUMENTS",
            "timeout": 120
          }
        ]
      }
    ]
  }
}
```

Hook 入力データだけで決定を下すのに十分な場合はプロンプト hooks を使用します。コードベースの実際の状態に対して何かを検証する必要がある場合はエージェント hooks を使用します。

完全な設定オプションについては、リファレンスの [エージェントベースの hooks](https://code.claude.com/docs/ja/hooks.md#agent-based-hooks) を参照してください。

## HTTP hooks

`type: "http"` hooks を使用して、シェルコマンドを実行する代わりに、イベントデータを HTTP エンドポイントに POST します。エンドポイントはコマンド hook が stdin で受け取るのと同じ JSON を受け取り、HTTP レスポンスボディを使用して同じ JSON 形式で結果を返します。

HTTP hooks は、Web サーバー、クラウド関数、または外部サービスに hook ロジックを処理させたい場合に便利です。たとえば、チーム全体のツール使用イベントをログに記録する共有監査サービス。

この例はすべてのツール使用をローカルログサービスに POST します：

```json theme={null}
{
  "hooks": {
    "PostToolUse": [
      {
        "hooks": [
          {
            "type": "http",
            "url": "http://localhost:8080/hooks/tool-use",
            "headers": {
              "Authorization": "Bearer $MY_TOKEN"
            },
            "allowedEnvVars": ["MY_TOKEN"]
          }
        ]
      }
    ]
  }
}
```

エンドポイントは、コマンドフックと同じ [出力形式](https://code.claude.com/docs/ja/hooks.md#json-output) の JSON ボディで応答し、Claude Code はレスポンスのステータスも確認します：

* **2xx ステータス**：ツール呼び出しをブロックするには、ボディで適切な `hookSpecificOutput` フィールドを返します。
* **その他のステータス、またはリクエストが失敗した場合**：Claude Code は [ノンブロッキングエラー](https://code.claude.com/docs/ja/hooks.md#exit-code-output) を報告し、アクションを続行させます。失敗したエンドポイントでアクションをブロックするには、フックに [`onFailure: "block"`](https://code.claude.com/docs/ja/hooks#block-the-action-when-a-hook-fails) を設定します。

ヘッダー値は `$VAR_NAME` または `${VAR_NAME}` 構文を使用した環境変数補間をサポートします。`allowedEnvVars` 配列にリストされている変数のみが解決されます。他のすべての `$VAR` 参照は空のままです。

完全な設定オプションとレスポンス処理については、リファレンスの [HTTP hooks](https://code.claude.com/docs/ja/hooks.md#http-hook-fields) を参照してください。

## 制限事項とトラブルシューティング

### 制限事項

フックを設計する際は、以下の制約に留意してください。

* コマンドフックは stdout、stderr、終了コードのみを介して通信します。`/` コマンドやツール呼び出しをトリガーすることはできません。`additionalContext` を介して返されたテキストは[システムリマインダー](https://code.claude.com/docs/ja/glossary.md#system-reminder)として挿入され、Claude はこれをプレーンテキストとして読み取ります。HTTP フックは代わりにレスポンスボディを介して通信します。
* フックのタイムアウトはタイプによって異なります。フックごとに `timeout` フィールド（秒単位）で上書きできます。
  * `command`、`http`、`mcp_tool`：10 分。Claude Code は、`UserPromptSubmit`、`PreModelSwitch`、`PostModelSwitch` フックではこのデフォルトを 30 秒に、`MessageDisplay` では 10 秒に引き下げます。
  * `prompt`：30 秒。
  * `agent`：60 秒。
  * [`SessionEnd`](https://code.claude.com/docs/ja/hooks#sessionend) フックは、タイプを問わず 1.5 秒の割り当て時間を共有します。設定でフックごとにより長い `timeout` を指定している場合、Claude Code は最大 60 秒までそれに合わせて割り当て時間を引き上げます。
* `PostToolUse` フックは、ツールがすでに実行されているため、アクションを元に戻すことはできません。
* [`PermissionRequest`](https://code.claude.com/docs/ja/hooks#permissionrequest) フックは、Claude Code がユーザーに権限を求めようとするとき、またはプロンプトを表示できない呼び出しをそのままでは自動的に拒否するときに発火します。`-p` フラグを使用した[非対話モード](https://code.claude.com/docs/ja/headless.md)でも、[`dontAsk` モード](https://code.claude.com/docs/ja/permission-modes#allow-only-pre-approved-tools-with-dontask-mode)以外では引き続き実行され、どのフックも判断せず、他に応答できるものもない呼び出しは拒否されます。
* `Stop` フックは、タスクの完了時だけでなく、Claude が応答を終えるたびに発火します。ユーザーによる中断では発火しません。API エラーの場合は代わりに [StopFailure](https://code.claude.com/docs/ja/hooks.md#stopfailure) が発火します。
* 複数の `PreToolUse` フックがツールの入力を書き換えるために [`updatedInput`](https://code.claude.com/docs/ja/hooks#pretooluse) を返す場合、Claude Code は書き換えをマージせず、どの書き換えでツールが実行されるかも保証しません。同じツールの入力を複数のフックで書き換えることは避けてください。

### フックと権限モード

設定ファイルやプラグインの `hooks/hooks.json` 内のフックでは、権限ルールが許可する範囲を超えて制限を緩めることはできず、フックの `"deny"` はすべての権限モードで有効です。

* **`"allow"` に対して引き続き有効なもの**：`"allow"` を返すフックは、設定の拒否ルールを回避することはできず、以下のプロンプトを抑制することもできません。
  * [ネットワークパス](https://code.claude.com/docs/ja/permissions.md#network-paths)からの読み取り
  * [`requiresUserInteraction`](https://code.claude.com/docs/ja/mcp#require-approval-for-a-specific-tool) が指定された MCP ツール
  * [Agent SDK アプリが `always_ask` を指定したツール](https://code.claude.com/docs/ja/agent-sdk/custom-tools#require-approval-for-specific-tools)の呼び出し（ただし、[権限モードがその呼び出しを承認する](https://code.claude.com/docs/ja/agent-sdk/typescript.md#permission-modes-that-can-approve-an-always_ask-call)場合を除く）
  * その設定が Claude Code に反映されるセッションにおいて、[組織が `ask` に設定した](https://code.claude.com/docs/ja/mcp#organization-controls-on-connector-tools)コネクタツール

[plan モード](https://code.claude.com/docs/ja/permissions.md#hook-approvals-in-plan-mode)では、`PreToolUse` フックがファイル編集に対して `"allow"` を返しても、フックがない場合にその編集が受けるのと同じプロンプト、ブロック、または承認が適用されます。フックによる承認に対するこの制限を解除するには、[プランを承認する](https://code.claude.com/docs/ja/permission-modes.md#review-and-approve-a-plan)か、別の権限モードに切り替えてください。

* **すべての権限モードでの `"deny"`**：`permissionDecision: "deny"` を返すフックは、`bypassPermissions` モードや `--dangerously-skip-permissions` を使用している場合でもツールをブロックします。`PreToolUse` フックは、`dontAsk` を含むすべての[権限モード](https://code.claude.com/docs/ja/permission-modes.md)において、権限モードのチェックより前に発火します。これにより、ユーザーが権限モードを変更しても回避できないポリシーを適用できます。

> [!NOTE]
>
> マシンに[管理設定](https://code.claude.com/docs/ja/settings.md#check-what-your-organization-enforces)がなく、セッションで Team または Enterprise プランの [`/login` 認証情報](https://code.claude.com/docs/ja/authentication#authentication-precedence)を使用していない場合、`PreToolUse` フックがブロックした呼び出しを [mod](https://code.claude.com/docs/ja/plugins/mods/overview.md) が承認できます。代わりに API キーや長期間有効な [`CLAUDE_CODE_OAUTH_TOKEN`](https://code.claude.com/docs/ja/authentication#generate-a-long-lived-token) で実行されるセッションは、そのログインが保存されている場合でも、そのログインを使用していません。
>
> plan モードでは、mod がそのようなブロックされた呼び出しを承認できるのは読み取り専用の場合のみであり、ファイル編集は承認できません。mod の承認がルールやフックを通過しないケースについては、[フックで権限を拡張する](https://code.claude.com/docs/ja/permissions.md#precedence-among-rules-hooks-and-mods)を参照してください。

### フックが発火しない

フックは設定されているが、一度も実行されない場合。

* `/hooks` を実行し、フックが正しいイベントの下に表示されていることを確認します
* スキルのフロントマター内のフックの場合は、スキルを呼び出すか Claude に呼び出すよう依頼してから、`/hooks` を再度実行します。`/hooks` は、セッション内でまだ呼び出されていないスキルのフックを一覧表示しません。それでも `/hooks` にフックが表示されない場合は、[解析されなかったフロントマター](https://code.claude.com/docs/ja/skills.md#skill-not-triggering)や[スキルのフックに関する制限](https://code.claude.com/docs/ja/hooks.md#limits-on-skill-hooks)のいずれかなど、他の原因を確認してください
* matcher のパターンがツール名と正確に一致していることを確認します。matcher は大文字と小文字を区別します
* 正しいイベントタイプをトリガーしていることを確認します。`PreToolUse` はツールの実行前に、`PostToolUse` は実行後に発火します。`PermissionRequest` フックは Claude Code がユーザーに権限を求めようとするときに発火します。非対話の場合については[制限事項](#limitations)を参照してください

### 出力にフックエラーが表示される

トランスクリプトに「PreToolUse hook error: ...」のようなメッセージが表示される場合。

* スクリプトが予期せずゼロ以外のコードで終了しています。サンプルの JSON をパイプで渡して手動でテストします。
  ```bash theme={null}
  echo '{"tool_name":"Bash","tool_input":{"command":"ls"}}' | ./my-hook.sh
  echo $?  # Check the exit code
  ```
* 「command not found」と表示される場合は、絶対パスまたは `${CLAUDE_PROJECT_DIR}` を使用してスクリプトを参照します。シェルのクォートを完全に回避するには、`"args": []` を追加して [exec 形式](https://code.claude.com/docs/ja/hooks.md#exec-form-and-shell-form)に切り替えます。これにより、シェルを介さずにスクリプトが直接起動されます
* 「jq: command not found」と表示される場合は、`jq` をインストールするか、JSON の解析に Python/Node.js を使用します
* メッセージに `blocking because Git Bash wasn't found` が含まれる場合は、Windows 上で Claude Code が Git Bash を見つけられず、失敗またはタイムアウトしたフックがツール呼び出しをブロックしています。修正方法については [Git Bash のない Windows で失敗したフック](https://code.claude.com/docs/ja/hooks.md#failed-hooks-on-windows-without-git-bash)を参照してください
* 通知に JSON 検証メッセージが表示される場合、フックの stdout は JSON として解析されましたが、スキーマ検証に失敗しています。JSON 解析メッセージが表示される場合、stdout は JSON オブジェクトのように見えましたが、有効な JSON ではありませんでした。どちらも終了コード 0 の場合でも発生します。

  解析の失敗を修正するには、文字列の連結ではなく `jq` などの JSON エンコーダーを使用してペイロードを組み立て、値に含まれる引用符やバックスラッシュがエスケープされるようにします。終了コードと JSON の組み合わせについては、リファレンスの[終了コードの出力](https://code.claude.com/docs/ja/hooks.md#exit-code-output)セクションで説明しています
* スクリプトがまったく実行されていない場合は、実行可能にします：`chmod +x ./my-hook.sh`

### `/hooks` にフックが設定されていないと表示される

設定ファイルを編集したが、フックがメニューに表示されない場合。

* ファイルの編集は通常自動的に反映されます。数秒経っても表示されない場合は、ファイルウォッチャーが変更を検出できなかった可能性があります。セッションを再起動して強制的に再読み込みしてください。
* JSON が有効であることを確認します。末尾のカンマやコメントは使用できません
* 設定ファイルが正しい場所にあることを確認します。プロジェクトのフックは `.claude/settings.json`、グローバルのフックは `~/.claude/settings.json` です
* メニューに `Only hooks from managed settings run here` と表示される場合は、組織が [`allowManagedHooksOnly`](https://code.claude.com/docs/ja/settings-reference#allowmanagedhooksonly) を設定しています。ユーザー、プロジェクト、ローカルの設定ファイル内のフックは実行されず、一覧にも表示されません

### Stop フックがブロック上限に達する

Claude が停止せずに作業を続け、その後 Stop フックが連続してブロックした回数が多すぎるという警告とともにターンを終了する場合。

Claude Code は、Stop フックが間に Claude によるツール呼び出しを挟まずに 8 回連続でブロックすると、そのフックを上書きします。フックスクリプトでは、すでに継続をトリガーしたかどうかを確認する必要があります。JSON 入力から `stop_hook_active` フィールドを解析し、`true` の場合は早期に終了します。

```bash theme={null}
#!/bin/bash
INPUT=$(cat)
if [ "$(echo "$INPUT" | jq -r '.stop_hook_active')" = "true" ]; then
  exit 0  # Allow Claude to stop
fi
# ... rest of your hook logic
```

フックが収束するまでに正当な理由で 8 回を超える反復が必要な場合は、[`CLAUDE_CODE_STOP_HOOK_BLOCK_CAP`](https://code.claude.com/docs/ja/env-vars) で上限を引き上げてください。

### フックの JSON が効果を持たない

フックは有効な JSON を出力しているが、判断が反映されず、トランスクリプトにもエラーが表示されない場合。どの原因に該当するかを確認してください。

* **JSON の前に余分な出力がある**：他の何かが先に stdout に書き込んでいます。通常はシェルプロファイル内の無条件の `echo` です。そのため出力が `{` で始まらなくなります。[JSON の前に出力されるシェルプロファイルの出力](#shell-profile-output-before-the-json)を参照してください。
* **フィールドの階層が間違っている**：各フィールドの配置を [JSON 出力](https://code.claude.com/docs/ja/hooks.md#json-output)の形式と比較してください。たとえば、`permissionDecision` はトップレベルではなく `hookSpecificOutput` の内側に配置する必要があります。[フィールドの階層が間違っている](#fields-at-the-wrong-level)を参照してください。

#### JSON の前に出力されるシェルプロファイルの出力

フックは非対話シェルで実行されますが、Git Bash や、`BASH_ENV` が `~/.bashrc` を指しているなどの一部の設定では、それでもプロファイルが読み込まれます。プロファイルが出力した内容はすべて、フックの JSON より先に stdout に届きます。

```text theme={null}
Shell ready on arm64
{"decision": "block", "reason": "Not allowed"}
```

フックが[非同期](https://code.claude.com/docs/ja/hooks.md#how-async-hooks-execute)でない限り、Claude Code は `{` で始まらない出力をプレーンテキストとして読み取るため、JSON は無視されます。フックは終了コード 0 で終了しているため、トランスクリプトにもエラーは表示されません。この原因に該当するかを確認するには、`claude --debug` で Claude Code を起動してフックをトリガーし、[デバッグログ](https://code.claude.com/docs/ja/hooks.md#debug-hooks)で `Hook output does not start with {` を検索します。これを修正するには、プロファイル内の `echo` 文を、対話シェルでのみ実行されるように囲みます。

```bash theme={null}
# In ~/.zshrc or ~/.bashrc
if [[ $- == *i* ]]; then
  echo "Shell ready"
fi
```

`$-` 変数にはシェルのフラグが含まれており、`i` は対話を意味します。フックは非対話シェルで実行されるため、echo はスキップされます。

#### フィールドの階層が間違っている

フックが `permissionDecision` や `additionalContext` を `hookSpecificOutput` の内側ではなくトップレベルで返した場合でも、JSON は解析されますが、Claude Code は誤って配置されたフィールドをエラーを報告せずに無視します。どのフィールドが無視されたかを確認するには、`claude --debug` で Claude Code を起動し、[デバッグログ](https://code.claude.com/docs/ja/hooks.md#debug-hooks)で `Hook JSON output had unrecognized keys` を検索します。

### フックの動作を確認する

`Ctrl+O` を押してトランスクリプトビューを開き、フックの結果を確認します。

* **成功**：フックの JSON が `systemMessage` や Stop フックのフィードバックなどを表示しない限り、何も表示されません。
  * フックが実行されたことを確認するには、ファイルが再フォーマットされたなどの効果を確認します
* **ブロッキングエラー**：ほとんどのイベントでは、ブロックに伴うメッセージが表示されます（例：`Blocked: rm commands are not allowed`）。`ConfigChange` や `Elicitation` などの一部のイベントでは、メッセージは表示されません。メッセージの出どころについては[終了コード 2](https://code.claude.com/docs/ja/hooks.md#exit-code-2) で説明しています。
* **非ブロッキングエラー**：`<hook name> hook error` という通知と短い説明が表示されます。説明は、`Failed with non-blocking status code:` の後に続く stderr の最初の行や、JSON の検証メッセージまたは解析メッセージなどです。アクションは続行されています。

特定の終了コードと stdout に対する結果（イベントごとの例外を含む）を調べるには、リファレンスの[終了コードの出力](https://code.claude.com/docs/ja/hooks.md#exit-code-output)を参照してください。

フックの終了コード、stdout、stderr を含む実行の詳細をすべて確認するには、[デバッグログ](https://code.claude.com/docs/ja/hooks.md#debug-hooks)を読みます。`claude --debug-file /tmp/claude.log` で Claude Code を起動して既知のパスに書き込み、別のターミナルで `tail -f /tmp/claude.log` を実行します。このフラグを付けずに起動した場合は、セッションの途中で `/debug` を実行してログを有効にし、ログのパスを確認します。

## 詳細を学ぶ

* [Hooks リファレンス](https://code.claude.com/docs/ja/hooks.md)：完全なイベントスキーマ、JSON 出力形式、非同期 hooks、および MCP ツール hooks
* [セキュリティに関する考慮事項](https://code.claude.com/docs/ja/hooks.md#security-considerations)：共有または本番環境に hooks をデプロイする前に確認してください
* [Bash コマンドバリデーター例](https://github.com/anthropics/claude-code/blob/main/examples/hooks/bash_command_validator_example.py)：完全なリファレンス実装
