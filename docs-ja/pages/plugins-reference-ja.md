> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# プラグインリファレンス

> Claude Code プラグインシステムの完全な技術リファレンス。スキーマ、CLI コマンド、コンポーネント仕様を含みます。

<Tip>
  プラグインをインストールしたいですか？「[プラグインの検出とインストール](/docs/ja/discover-plugins)」を参照してください。プラグインの作成については、「[プラグイン](/docs/ja/plugins)」を参照してください。プラグインの配布については、「[プラグインマーケットプレイス](/docs/ja/plugin-marketplaces)」を参照してください。
</Tip>

**プラグイン**は、Claude Code をカスタム機能で拡張する自己完結型のコンポーネントディレクトリです。プラグインコンポーネントには、skills、agents、hooks、MCP servers、LSP servers、および monitors が含まれます。

<h2 id="plugin-components-reference">
  プラグインコンポーネントリファレンス
</h2>

<h3 id="skills">
  Skills
</h3>

プラグインは Claude Code に skills を追加し、`/name` ショートカットを作成します。これらは、ユーザーまたは Claude が呼び出すことができます。

**場所**: プラグインルートの `skills/` または `commands/` ディレクトリ、またはプラグインルートの単一の `SKILL.md` ファイル

**ファイル形式**: Skills はディレクトリで `SKILL.md` を含みます。commands はシンプルな markdown ファイルです

**Skill の構造**:

```text theme={null}
skills/
├── pdf-processor/
│   ├── SKILL.md
│   ├── reference.md (optional)
│   └── scripts/ (optional)
└── code-reviewer/
    └── SKILL.md
```

Skills と commands は、プラグインがインストールされると自動的に検出されます。

プラグインに `skills/` ディレクトリがなく、`skills` マニフェストフィールドもない場合、プラグインルートの `SKILL.md` は単一の skill として読み込まれます。frontmatter の `name` フィールドを設定して、skill の呼び出し名を制御します。これがない場合、Claude Code はインストールディレクトリ名にフォールバックします。マーケットプレイスからインストールされたプラグインの場合、これは更新のたびに変わるバージョン文字列です。複数の skill を含むプラグインの場合は、上記の `skills/` ディレクトリレイアウトを使用します。

プラグイン skills と commands では、`disable-model-invocation` などのブール値 frontmatter フィールドが、`true` と `false` に加えて、任意の大文字小文字で `yes`、`no`、`on`、`off`、`1`、`0` を受け入れます。v2.1.218 より前では、Claude Code は `true` と `false` のみを認識していました。

詳細については、[Skills](/docs/ja/skills) を参照してください。

<h3 id="agents">
  Agents
</h3>

プラグインは、Claude が必要に応じて自動的に呼び出すことができる特定のタスク用の特化したサブエージェントを提供できます。

**場所**: プラグインルートの `agents/` ディレクトリ

**ファイル形式**: エージェント機能を説明する markdown ファイル

**エージェント構造**:

```markdown theme={null}
---
name: agent-name
description: このエージェントが専門とする内容と Claude がそれを呼び出すべき時期
model: sonnet
effort: medium
maxTurns: 20
disallowedTools: Write, Edit
---

エージェントの役割、専門知識、および動作を説明する詳細なシステムプロンプト。
```

プラグインエージェントは、`name`、`description`、`model`、`effort`、`maxTurns`、`tools`、`disallowedTools`、`skills`、`memory`、`background`、および `isolation` frontmatter フィールドをサポートしています。唯一の有効な `isolation` 値は `"worktree"` です。セキュリティ上の理由から、`hooks`、`mcpServers`、および `permissionMode` はプラグイン提供エージェントではサポートされていません。

Claude Code は、frontmatter に `name` がない場合またはパースに失敗した場合でも、プラグインエージェントを読み込みます。

* `name` がない場合: Claude Code はファイル名に基づいてエージェントに名前を付けるため、`my-plugin` という名前のプラグイン内の `agents/reviewer.md` は `my-plugin:reviewer` として読み込まれます
* Frontmatter がパースに失敗した場合: Claude Code はファイル名に基づいてエージェントに名前を付け、説明として `Agent from my-plugin plugin` を使用し、ファイル内のすべてのフィールドを無視します

対照的に、Claude Code は、frontmatter に `name` がない場合またはパースに失敗した場合、プロジェクト、ユーザー、または管理エージェントファイルをスキップします。

プラグインのデフォルト `agents/` ディレクトリ内で frontmatter がパースに失敗したファイルを見つけるには、`claude plugin validate` を実行します。渡すパスは、プラグインがマニフェストを持つかどうかによって異なり、両方の例では `./my-plugin` をプラグインディレクトリとして使用します。

* マニフェスト付きプラグイン: `claude plugin validate ./my-plugin`
* マニフェストなしプラグイン: `claude plugin validate ./my-plugin/agents`。Claude Code v2.1.233 以降が必要です。

エージェントは、プラグインが有効になると、[@-mention typeahead](/docs/ja/sub-agents#invoke-subagents-explicitly) に `my-plugin:code-reviewer` などのスコープ付き名で表示されます。

詳細については、[Subagents](/docs/ja/sub-agents) を参照してください。

<h3 id="hooks">
  Hooks
</h3>

プラグインは、Claude Code イベントに自動的に応答するイベントハンドラーを提供できます。

**場所**: プラグインルートの `hooks/hooks.json`、または plugin.json 内のインライン

**形式**: イベントマッチャーとアクションを含む JSON 設定

**Hook 設定**:

```json theme={null}
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": "\"${CLAUDE_PLUGIN_ROOT}\"/scripts/format-code.sh"
          }
        ]
      }
    ]
  }
}
```

プラグイン hooks は、[ユーザー定義 hooks](/docs/ja/hooks) と同じライフサイクルイベントに応答します。

| イベント                  | 発火するタイミング                                                                                                                                                     |
| :-------------------- | :------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `SessionStart`        | セッションが開始または再開されたとき                                                                                                                                            |
| `Setup`               | `--init-only` で Claude Code を起動するとき、または `-p` モードで `--init` または `--maintenance` を使用するとき。CI またはスクリプトでの 1 回限りの準備用                                                |
| `UserPromptSubmit`    | プロンプトを送信するとき、Claude が処理する前                                                                                                                                    |
| `UserPromptExpansion` | ユーザーが入力したコマンドがプロンプトに展開されるとき、Claude に到達する前。展開をブロックできます                                                                                                         |
| `PreToolUse`          | ツール呼び出しが実行される前。ブロックできます                                                                                                                                       |
| `PermissionRequest`   | ツール呼び出しが権限決定を必要とするとき                                                                                                                                          |
| `PermissionDenied`    | オートモードがツール呼び出しを拒否するとき、分類器の判定がない拒否を含みます。JSON `hookSpecificOutput.retry: true` を使用して、モデルが拒否されたツール呼び出しを再試行できることを伝えます。Claude Code は分類器が判定を出さなかった場合、`retry` を無視します |
| `PostToolUse`         | ツール呼び出しが成功した後                                                                                                                                                 |
| `PostToolUseFailure`  | ツール呼び出しが失敗した後                                                                                                                                                 |
| `PostToolBatch`       | 並列ツール呼び出しの完全なバッチが解決した後、次のモデル呼び出しの前                                                                                                                            |
| `Notification`        | Claude Code が通知を送信するとき                                                                                                                                        |
| `MessageDisplay`      | アシスタントメッセージテキストが表示されている間                                                                                                                                      |
| `SubagentStart`       | サブエージェントがスポーンされるとき                                                                                                                                            |
| `SubagentStop`        | サブエージェントが終了するとき                                                                                                                                               |
| `TaskCreated`         | `TaskCreate` 経由でタスクが作成されるとき                                                                                                                                   |
| `TaskCompleted`       | タスクが完了としてマークされるとき                                                                                                                                             |
| `Stop`                | Claude が応答を終了するとき                                                                                                                                             |
| `StopFailure`         | API エラーが原因でターンが終了するとき                                                                                                                                         |
| `TeammateIdle`        | [エージェントチーム](/docs/ja/agent-teams) のチームメイトがアイドル状態になろうとするとき                                                                                                          |
| `InstructionsLoaded`  | CLAUDE.md または `.claude/rules/*.md` ファイルがコンテキストに読み込まれるとき。セッション開始時およびセッション中にファイルが遅延読み込みされるときに発火します                                                              |
| `ConfigChange`        | セッション中に設定ファイルが変更されるとき                                                                                                                                         |
| `CwdChanged`          | 作業ディレクトリが変更されるとき、例えば Claude が `cd` コマンドを実行するとき。direnv などのツールを使用したリアクティブな環境管理に便利です                                                                             |
| `DirectoryAdded`      | `/add-dir` または SDK `register_repo_root` コントロールリクエスト経由でセッション中盤に作業ディレクトリが追加されるとき                                                                                |
| `FileChanged`         | 監視対象ファイルがディスク上で変更されるとき。`matcher` フィールドは監視するファイル名を指定します                                                                                                        |
| `WorktreeCreate`      | `--worktree`、`isolation: "worktree"`、またはバックグラウンドセッション経由で worktree が作成されるとき。デフォルトの git 動作を置き換えます                                                               |
| `WorktreeRemove`      | セッション終了時、サブエージェント終了時、またはバックグラウンドセッションを削除するときに worktree が削除されるとき                                                                                               |
| `PreCompact`          | コンテキスト圧縮の前                                                                                                                                                    |
| `PostCompact`         | コンテキスト圧縮が完了した後                                                                                                                                                |
| `PreModelSwitch`      | Claude Code があなたまたはクライアントがリクエストしたモデルスイッチを適用する前。スイッチをブロックできます                                                                                                  |
| `PostModelSwitch`     | セッションのモデルが変更された後、Claude Code が独自に行う変更（セッションを再開するときのモデル復元など）を含みます                                                                                              |
| `Elicitation`         | MCP サーバーがツール呼び出し中にユーザー入力をリクエストするとき                                                                                                                            |
| `ElicitationResult`   | ユーザーが MCP エリシテーションに応答した後、レスポンスがサーバーに送り返される前                                                                                                                   |
| `SessionEnd`          | セッションが終了するとき                                                                                                                                                  |

**Hook タイプ**:

* `command`: シェルコマンドまたはスクリプトを実行
* `http`: イベント JSON を URL への POST リクエストとして送信
* `mcp_tool`: 設定された [MCP サーバー](/docs/ja/mcp) 上のツールを呼び出す
* `prompt`: LLM でプロンプトを評価（コンテキスト用に `$ARGUMENTS` プレースホルダーを使用）
* `agent`: 複雑な検証タスク用にツール付きの agentic verifier を実行

プラグイン自身の [バンドルされた MCP サーバー](#mcp-servers) をターゲットとする hooks は、スコープ付き名を使用する必要があります。ツールマッチャーと `if` フィールドはスコープ付きツール名 `mcp__plugin_<plugin-name>_<server-name>__<tool>` を取り、`mcp_tool` hook の `server` フィールドは `plugin:<plugin-name>:<server-name>` を取ります。ベアサーバーキーに対して記述されたマッチャーは発火しません。[MCP ツールをマッチ](/docs/ja/hooks#match-mcp-tools) および [プラグイン提供 MCP サーバー](/docs/ja/mcp#plugin-provided-mcp-servers) を参照してください。

<h3 id="mcp-servers">
  MCP servers
</h3>

プラグインは Model Context Protocol（MCP）サーバーをバンドルして、Claude Code を外部ツールおよびサービスに接続できます。

**場所**: プラグインルートの `.mcp.json`、または plugin.json 内のインライン

**形式**: 標準 MCP サーバー設定

**MCP サーバー設定**:

```json theme={null}
{
  "mcpServers": {
    "plugin-database": {
      "command": "${CLAUDE_PLUGIN_ROOT}/servers/db-server",
      "args": ["--config", "${CLAUDE_PLUGIN_ROOT}/config.json"],
      "env": {
        "DB_PATH": "${CLAUDE_PLUGIN_ROOT}/data"
      }
    },
    "plugin-api-client": {
      "command": "npx",
      "args": ["@company/mcp-server", "--plugin-mode"]
    }
  }
}
```

**統合動作**:

* プラグイン MCP サーバーはプラグインが有効になると自動的に起動します
* サーバーは Claude のツールキット内の標準 MCP ツールとして表示されます
* プラグインサーバーはユーザー MCP サーバーとは独立して設定できます
* セッション中に [`/reload-plugins`](/docs/ja/discover-plugins#apply-plugin-changes-without-restarting) を実行する場合、Claude Code は設定が変わらないサーバーのライブ接続を保持します

<h3 id="lsp-servers">
  LSP servers
</h3>

<Tip>
  LSP プラグインを使用したいですか？公式マーケットプレイスからインストールしてください。`/plugin` Discover タブで「lsp」を検索してください。このセクションでは、公式マーケットプレイスでカバーされていない言語用の LSP プラグインを作成する方法を説明しています。
</Tip>

プラグインは [Language Server Protocol](https://microsoft.github.io/language-server-protocol/)（LSP）サーバーを提供して、コードベースで作業する際に Claude に [リアルタイムコード インテリジェンス](/docs/ja/discover-plugins#code-intelligence) を提供できます。

**場所**: プラグインルートの `.lsp.json`、または `plugin.json` 内のインライン

**形式**: 言語サーバー名をその設定にマップする JSON 設定

**`.lsp.json` ファイル形式**:

```json theme={null}
{
  "go": {
    "command": "gopls",
    "args": ["serve"],
    "extensionToLanguage": {
      ".go": "go"
    }
  }
}
```

**`plugin.json` 内のインライン**:

```json theme={null}
{
  "name": "my-plugin",
  "lspServers": {
    "go": {
      "command": "gopls",
      "args": ["serve"],
      "extensionToLanguage": {
        ".go": "go"
      }
    }
  }
}
```

**必須フィールド:**

| フィールド                 | 説明                                 |
| :-------------------- | :--------------------------------- |
| `command`             | 実行する LSP バイナリ（PATH に含まれている必要があります） |
| `extensionToLanguage` | ファイル拡張子を言語識別子にマップします               |

**オプションフィールド:**

| フィールド                   | 説明                                                                                                                              |
| :---------------------- | :------------------------------------------------------------------------------------------------------------------------------ |
| `args`                  | LSP サーバーのコマンドライン引数                                                                                                              |
| `transport`             | 通信トランスポート: `stdio`（デフォルト）または `socket`。Claude Code は `socket` を受け入れますが、すべてのサーバーを stdio 経由で実行するため、stdout プロトコルルールがすべてのサーバーに適用されます |
| `env`                   | サーバー起動時に設定する環境変数                                                                                                                |
| `initializationOptions` | 初期化中にサーバーに渡されるオプション                                                                                                             |
| `settings`              | `workspace/didChangeConfiguration` 経由で渡される設定                                                                                    |
| `workspaceFolder`       | サーバーのワークスペースフォルダーパス                                                                                                             |
| `startupTimeout`        | サーバー起動を待つ最大時間（ミリ秒）                                                                                                              |
| `shutdownTimeout`       | グレースフルシャットダウンを待つ最大時間（ミリ秒）。タイムアウトが経過すると、Claude Code はサーバープロセスを終了します。設定されていない場合、タイムアウトは適用されません                                    |
| `restartOnCrash`        | クラッシュ後にサーバーを再起動するかどうか。デフォルトは `true`。クラッシュしたサーバーを再起動する代わりに停止したままにするには `false` に設定します                                             |
| `maxRestarts`           | 諦める前の最大再起動試行回数                                                                                                                  |
| `diagnostics`           | 編集後に診断を Claude のコンテキストにプッシュするかどうか（デフォルト `true`）。コード ナビゲーションは保持しながら自動診断注入を抑制するには `false` に設定します                                  |

`restartOnCrash` と `shutdownTimeout` には Claude Code v2.1.205 以降が必要です。v2.1.205 より前では、設定スキーマは両方のオプションを受け入れていましたが、どちらかを設定すると Claude Code はその LSP サーバーを起動時に完全にスキップしていました。理由は `claude --debug` 出力でのみ表示されます。

**同じ拡張子の複数サーバー**: 複数の有効な LSP サーバーが `extensionToLanguage` で同じファイル拡張子を宣言する場合、サーバーが 1 つのプラグインから来ているか異なるプラグインから来ているかに関わらず、最初に登録されたサーバーがその拡張子のファイルを処理し、他のサーバーは起動しません。`/plugin` インターフェイスは、アクティブなサーバーを持つプラグインに名前を付ける警告を表示します。

**初期化に失敗したサーバー**: Claude Code は、`command` または `extensionToLanguage` が見つからないなど、設定が無効なサーバーをスキップし、他の設定されたサーバーは起動します。`claude --debug` を実行して、サーバーがスキップされた理由を確認します。

スキップされたサーバーはそのファイル拡張子を要求しないため、同じ拡張子を宣言する別の有効なサーバー（同じプラグインまたは異なるプラグインから）がそれらのファイルを処理します。

**ログ出力を stdout ではなく stderr に送信**: Claude Code はサーバーの stdout をプロトコルメッセージとしてのみ読み取り、メッセージヘッダーは最大 64 KiB、メッセージボディは最大 32 MiB を受け入れます。Claude Code は、どちらかの制限を超えるか、非プロトコル出力を stdout に書き込むサーバーを切断し、その切断を `restartOnCrash` と `maxRestarts` のクラッシュとしてカウントします。`--debug` で実行する場合、Claude Code は原因に名前を付けるエラーをデバッグログに書き込みます。

<Warning>
  **言語サーバーバイナリを別途インストールする必要があります。** LSP プラグインは Claude Code が言語サーバーに接続する方法を設定しますが、サーバー自体は含まれていません。`/plugin` Errors タブに `Executable not found in $PATH` が表示される場合は、言語に必要なバイナリをインストールしてください。
</Warning>

**利用可能な LSP プラグイン:**

| プラグイン               | 言語サーバー                     | インストールコマンド                                                                         |
| :------------------ | :------------------------- | :--------------------------------------------------------------------------------- |
| `pyright-lsp`       | Pyright（Python）            | `pip install pyright` または `npm install -g pyright`                                 |
| `typescript-lsp`    | TypeScript Language Server | `npm install -g typescript-language-server typescript`                             |
| `rust-analyzer-lsp` | rust-analyzer              | [rust-analyzer インストール参照](https://rust-analyzer.github.io/manual.html#installation) |

言語サーバーをインストールしてから、マーケットプレイスからプラグインをインストールします。

<h3 id="monitors">
  Monitors
</h3>

プラグインは、プラグインがアクティブな場合に Claude Code が自動的に起動するバックグラウンドモニターを宣言できます。各モニターはセッションの期間中シェルコマンドを実行し、すべての stdout 行を Claude に通知として配信するため、Claude は自分自身でウォッチを開始するよう求められることなく、ログエントリ、ステータス変更、またはポーリングイベントに反応できます。

プラグインモニターは [Monitor ツール](/docs/ja/tools-reference#monitor-tool) と同じメカニズムを使用し、その可用性制約を共有します。これらはインタラクティブ CLI セッションでのみ実行され、[hooks](#hooks) と同じ信頼レベルでサンドボックス化されずに実行され、Monitor ツールが利用できないホストではスキップされます。

**場所**: プラグインルートの `monitors/monitors.json`、または plugin.json 内のインライン

**形式**: モニターエントリの JSON 配列

次の `monitors/monitors.json` はデプロイメントステータスエンドポイントとローカルエラーログを監視します。

```json theme={null}
[
  {
    "name": "deploy-status",
    "command": "\"${CLAUDE_PLUGIN_ROOT}\"/scripts/poll-deploy.sh",
    "description": "Deployment status changes"
  },
  {
    "name": "error-log",
    "command": "tail -F ./logs/error.log",
    "description": "Application error log",
    "when": "on-skill-invoke:debug"
  }
]
```

モニターをインラインで宣言するには、`plugin.json` の `experimental.monitors` を同じ配列に設定します。デフォルト以外のパスから読み込むには、`experimental.monitors` を `"./config/monitors.json"` などの相対パス文字列に設定します。モニターは [実験的コンポーネント](#experimental-components) です。

**必須フィールド:**

| フィールド         | 説明                                                          |
| :------------ | :---------------------------------------------------------- |
| `name`        | プラグイン内で一意の識別子。プラグインが再読み込みされるか skill が再度呼び出されるときに重複プロセスを防ぎます |
| `command`     | セッション作業ディレクトリで永続的なバックグラウンドプロセスとして実行されるシェルコマンド               |
| `description` | 監視対象の簡潔な説明。タスクパネルと通知サマリーに表示されます                             |

**オプションフィールド:**

| フィールド  | 説明                                                                                                                                            |
| :----- | :-------------------------------------------------------------------------------------------------------------------------------------------- |
| `when` | モニターが開始するタイミングを制御します。`"always"` はセッション開始時とプラグイン再読み込み時に開始し、デフォルトです。`"on-skill-invoke:<skill-name>"` はこのプラグイン内の名前付き skill が最初にディスパッチされるときに開始します |

`command` 値は [パス置換](#environment-variables) `${CLAUDE_PLUGIN_ROOT}`、`${CLAUDE_PLUGIN_DATA}`、および `${CLAUDE_PROJECT_DIR}` をサポートしており、環境からの任意の `${ENV_VAR}` もサポートしています。スクリプトがプラグイン自身のディレクトリから実行される必要がある場合は、コマンドの前に `cd "${CLAUDE_PLUGIN_ROOT}" && ` を付けます。

モニター `command` は [`${user_config.*}`](#user-configuration) 値を参照できません。コマンドはシェルを通じて実行されるため、Claude Code は値を置換する代わりに [エラー](/docs/ja/errors#plugin-command-references-user-config) でモニターを拒否します。モニタープロセスは `CLAUDE_PLUGIN_OPTION_<KEY>` 環境変数を受け取らないため、モニタースクリプトが所有する設定ファイルから値を読み取ります。

セッション中にプラグインを無効にする場合、Claude Code は既に実行中のモニターを停止しません。セッションが終了するときに停止します。

<h3 id="themes">
  Themes
</h3>

プラグインは、`/theme` に組み込みプリセットおよびユーザーのローカルテーマと一緒に表示されるカラーテーマを配布できます。テーマは `themes/` 内の JSON ファイルで、`base` プリセットとカラートークンのスパース `overrides` マップを持ちます。テーマは [実験的コンポーネント](#experimental-components) です。

```json theme={null}
{
  "name": "Dracula",
  "base": "dark",
  "overrides": {
    "claude": "#bd93f9",
    "error": "#ff5555",
    "success": "#50fa7b"
  }
}
```

ユーザーがプラグインテーマを選択すると、Claude Code は `custom:<plugin-name>:<slug>` をその設定に保存します。プラグインテーマは読み取り専用です。ユーザーが `/theme` でそれに対して `Ctrl+E` を押すと、Claude Code はそれを `~/.claude/themes/` にコピーして、編集できるようにします。

***

<h2 id="plugin-installation-scopes">
  プラグインのインストールスコープ
</h2>

プラグインをインストールする際に、プラグインが利用可能な場所と他のユーザーが使用できるかどうかを決定する**スコープ**を選択します。

| スコープ      | 設定ファイル                                   | ユースケース                                              |
| :-------- | :--------------------------------------- | :-------------------------------------------------- |
| `user`    | `~/.claude/settings.json`                | すべてのプロジェクト全体で利用可能な個人用プラグイン（デフォルト）                   |
| `project` | `.claude/settings.json`                  | バージョン管理を通じて共有されるチームプラグイン                            |
| `local`   | `.claude/settings.local.json`            | プロジェクト固有のプラグイン。Claude Code が設定を保存する際に gitignore される |
| `managed` | [Managed settings](/docs/ja/managed-settings) | 管理されたプラグイン（読み取り専用、更新のみ）                             |

プラグインは、他の Claude Code 設定と同じスコープシステムを使用します。インストール手順とスコープフラグについては、[プラグインのインストール](/docs/ja/discover-plugins#install-plugins)を参照してください。スコープの完全な説明については、[設定スコープ](/docs/ja/settings#where-settings-live)を参照してください。

***

<h2 id="skills-directory-plugins">
  スキルディレクトリプラグイン
</h2>

スキルディレクトリの下にあるフォルダで `.claude-plugin/plugin.json` マニフェストを含むフォルダは、次のセッションで `<name>@skills-dir` という名前のプラグインとして読み込まれます。マーケットプレイスもインストール手順もありません。[`plugin init`](#plugin-init) でスキャフォルドできます。コピーされたマーケットプレイスインストールとは異なり、プラグインはプラグインキャッシュにコピーされるのではなく、その場で検出されます。

スキルディレクトリツリーは 3 つの異なるものをサポートしています。

| 内容                                            | 説明                                                     |
| :-------------------------------------------- | :----------------------------------------------------- |
| マニフェストなしの `<skills-dir>/foo/SKILL.md`         | `foo` という名前の通常の [スキル](/docs/ja/skills)                      |
| `<skills-dir>/foo/.claude-plugin/plugin.json` | プラグイン `foo@skills-dir`。独自のスキル、エージェント、hooks などをバンドルできます |
| `<plugin>/skills/bar/SKILL.md`                | プラグイン内にパッケージされたスキル `bar`                               |

<h3 id="choose-where-the-plugin-loads-from">
  プラグインの読み込み元を選択する
</h3>

| スキルディレクトリ               | スコープ   | 読み込み                                                                                    |
| :---------------------- | :----- | :-------------------------------------------------------------------------------------- |
| `~/.claude/skills/`     | 個人     | すべてのプロジェクトで読み込まれます。この場所はあなた自身のものだからです                                                   |
| `<cwd>/.claude/skills/` | プロジェクト | そのフォルダのワークスペース [信頼ダイアログ](/docs/ja/permissions#what-runs-before-you-trust-a-folder) を受け入れた後のみ |

プロジェクトスコープのプラグインはリポジトリにチェックインされ、それをクローンしたすべての協力者に到達します。そのコンテンツはあなたではなくリポジトリから来ているため、`.claude/settings.json` のプロジェクト許可ルールを管理するのと同じ信頼ゲートの後にのみ読み込まれます。親フォルダを信頼したり `-p` で実行したりするだけでは不十分で、コードを実行するコンポーネントはさらに制限されます。

* 宣言する MCP サーバーはプロジェクト `.mcp.json` と同じ [サーバーごとの承認](/docs/ja/mcp) を通過します
* LSP サーバーはワークスペースを信頼した後にのみ開始します
* [バックグラウンドモニター](#monitors) は読み込まれません

個人スコープのプラグインにはこれらの制限はありません。

<Warning>
  プロジェクトスコープの `@skills-dir` プラグインはセッションの [プライマリワーキングディレクトリ](/docs/ja/permissions#working-directories) の `.claude/skills/` からのみ読み込まれます。通常のスキルとコマンドのように [リポジトリルートまで遡りません](/docs/ja/skills#discovery-from-parent-and-nested-directories)。そのため、サブディレクトリから起動するとリポジトリルートにあるプラグインが見つかりません。リポジトリルートから起動するか、[v2.1.246 以降で `/cd` でセッションをそこに移動](/docs/ja/permissions#move-the-session-to-another-directory) してください。
</Warning>

<h3 id="edit-reload-and-disable-a-skills-directory-plugin">
  スキルディレクトリプラグインを編集、リロード、無効化する
</h3>

スキルの `SKILL.md` に加えた変更は現在のセッションで即座に有効になります。プラグインの他のコンポーネント（`hooks/`、`.mcp.json`、`agents/`、`output-styles/` など）への変更は有効になりません。`/reload-plugins` を実行するか Claude Code を再起動してそれらを反映させてください。[ライブ変更検出](/docs/ja/skills#live-change-detection) を参照してください。

スキルディレクトリプラグインの読み込みを停止するには、そのフォルダを削除するか、名前で無効化します。マーケットプレイスからインストールされていないため、`uninstall` ステップはありません。

```bash theme={null}
claude plugin disable my-tool@skills-dir
```

***

<h2 id="synced-plugins">
  claude.ai から同期されたプラグイン
</h2>

[Cowork](https://claude.com/product/cowork) と[クラウドセッション](/docs/ja/cloud-environments#what-carries-over-from-your-setup)では、Claude Code はカスタマーの claude.ai アカウント用に有効化されたプラグインをセッション独自の環境内の `~/.claude/plugins/synced/` にダウンロードし、各プラグインを `<name>@synced` として読み込みます。マーケットプレイスはなく、インストール記録もありません。Claude Code はカスタマーが独自のターミナルで開始したセッションではこれらのプラグインを読み込みません。その Cowork またはクラウド環境内では、`claude plugin list` はダウンロードされたコピーを `Synced from claude.ai` という見出しの下に表示します。v2.1.239 より前では、Claude Code はこれらのプラグインを `<name>@inline` として読み込んでいました。これは `--plugin-dir` プラグインが使用する ID です。

同期されたプラグインを `claude plugin list` が出力する `<name>@synced` ID で管理します。

* **プラグインをオフにする**: 同期されたセッション内で `claude plugin disable <name>@synced` を実行するか、Claude に実行するよう依頼します。Claude Code はこの選択を、その環境のユーザーレベルの [`enabledPlugins`](/docs/ja/settings-reference#enabledplugins) に `"<name>@synced": false` として保存します。プラグインを再度オンにするには、同じセッション内で `claude plugin enable <name>@synced` を実行します。すべての同期されたセッションからプラグインを除外するには、[claude.ai アカウント用にプラグインをオフにします](/docs/ja/desktop#extend-claude-code)。1 つのプロジェクトのすべての環境での同期されたセッションからプラグインを除外するには、そのプロジェクトのコミットされた `.claude/settings.json` の `enabledPlugins` の下に `"<name>@synced": false` を設定します。
* **claude.ai でプラグイン自体を管理する**: `claude plugin install`、`update`、`uninstall` は同期されたプラグインには適用されません。プラグインを削除するには、claude.ai アカウント用にプラグインをオフにします。次の同期されたセッションはそれなしで開始されます。

マーケットプレイスインストール、[スキルディレクトリプラグイン](#skills-directory-plugins)、または `--plugin-dir` プラグインなど、他のソースからの有効化されたプラグインが同期されたプラグインの名前と一致する場合、Claude Code はそのプラグインを読み込み、同期されたコピーが読み込まれていないと報告します。claude.ai のコピーを代わりに使用するには、独自のコピーを無効化します。v2.1.239 より前では、Claude Code は同じ名前のマーケットプレイスインストールの代わりに同期されたコピーを読み込んでいました。

***

<h2 id="plugin-manifest-schema">
  プラグインマニフェストスキーマ
</h2>

`.claude-plugin/plugin.json` ファイルは、プラグインのメタデータと設定を定義します。

マニフェストはオプションです。省略した場合、Claude Code は[デフォルトの場所](#file-locations-reference)のコンポーネントを自動検出し、ディレクトリ名からプラグイン名を導出します。メタデータまたはカスタムコンポーネントパスを提供する必要がある場合は、マニフェストを使用してください。

<h3 id="complete-schema">
  完全なスキーマ
</h3>

```json theme={null}
{
  "name": "plugin-name",
  "displayName": "Plugin Name",
  "version": "1.2.0",
  "description": "Brief plugin description",
  "author": {
    "name": "Author Name",
    "email": "author@example.com",
    "url": "https://github.com/author"
  },
  "homepage": "https://docs.example.com/plugin",
  "repository": "https://github.com/author/plugin",
  "license": "MIT",
  "keywords": ["keyword1", "keyword2"],
  "metadata": { "catalogId": "cat-123", "tier": "pro" },
  "skills": "./custom/skills/",
  "commands": ["./custom/commands/special.md"],
  "agents": ["./custom/agents/reviewer.md"],
  "hooks": "./config/hooks.json",
  "mcpServers": "./mcp-config.json",
  "outputStyles": "./styles/",
  "lspServers": "./.lsp.json",
  "experimental": {
    "themes": "./themes/",
    "monitors": "./monitors.json",
    "evals": "quality/evals"
  },
  "dependencies": [
    "helper-lib",
    { "name": "secrets-vault", "version": "~2.1.0" }
  ]
}
```

<h3 id="required-fields">
  必須フィールド
</h3>

マニフェストを含める場合、`name` は唯一の必須フィールドです。

| フィールド  | 型      | 説明                                                                                                                                                                          | 例                    |
| :----- | :----- | :-------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :------------------- |
| `name` | string | ケバブケースの一意の識別子。スペース、制御文字、双方向フォーマット文字を含みません。[マーケットプレイスエントリ](/docs/ja/plugin-marketplaces#plugin-entries)がプラグインを別の名前でリストする場合、マーケットプレイスエントリ名が `enabledPlugins` キーと `/plugin` で使用されます | `"deployment-tools"` |

この名前はコンポーネントの名前空間に使用されます。たとえば、UI では、名前が `plugin-dev` のプラグインのエージェント `agent-creator` は `plugin-dev:agent-creator` として表示されます。

<h3 id="unrecognized-fields">
  認識されないフィールド
</h3>

Claude Code は認識しないトップレベルフィールドを無視します。`plugin.json` に別のエコシステムからのメタデータを保持でき、プラグインは引き続き読み込まれます。これにより、VS Code または Cursor 拡張マニフェスト、npm `package.json`、または MCPB/DXT バンドルマニフェストとして機能する 1 つのマニフェストを保守することが実用的になります。

`claude plugin validate` は認識されないフィールドを警告として報告し、エラーではありません。フィールドが認識されたフィールドから 1 文字または 2 文字異なる場合、警告は意図された名前を示唆します。認識されないフィールド警告のみを持つプラグインは検証に合格し、実行時に読み込まれます。

Claude Code が認識されたフィールドを処理する方法は、値の型が間違っている場合、フィールドによって異なります。

* **ほとんどのフィールド**: プラグインは読み込みに失敗します。たとえば、文字列の代わりに配列である `keywords` 値は読み込みエラーであり、`claude plugin validate` はそれをエラーとして報告します。
* **`experimental` と `metadata`**: Claude Code は非オブジェクト値を無視し、`claude plugin validate` は警告を報告します。

`--strict` を渡して、警告をエラーとして扱います。CI で使用して、公開前に別のツールのマニフェストから残されたスペルミスのあるフィールド名またはフィールドをキャッチします。ただし、プラグインは実行時に読み込まれます。

```bash theme={null}
claude plugin validate ./my-plugin --strict
```

<h3 id="metadata-fields">
  メタデータフィールド
</h3>

| フィールド            | 型       | 説明                                                                                                                                                                                                                                                                                              | 例                                                                 |
| :--------------- | :------ | :---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :---------------------------------------------------------------- |
| `$schema`        | string  | エディタのオートコンプリートと検証用の JSON Schema URL。Claude Code は読み込み時にこのフィールドを無視します。                                                                                                                                                                                                                           | `"https://json.schemastore.org/claude-code-plugin-manifest.json"` |
| `displayName`    | string  | `/plugin` ピッカーおよび他の UI サーフェスに表示される人間が読める名前。マーケットプレイスインストール済みプラグインの場合、[マーケットプレイスエントリ](/docs/ja/plugin-marketplaces#optional-plugin-fields)の `displayName` はこの値より優先されます。どちらの場所にも表示名が設定されていない場合、ユーザーは `name` を見ます。`name` とは異なり、スペースと任意の大文字小文字を含むことができます。名前空間またはルックアップには使用されません。                         | `"Deployment Tools"`                                              |
| `version`        | string  | オプション。セマンティックバージョン。これを設定するとプラグインをそのバージョン文字列にピンします。ユーザーはバージョンをバンプしたときのみ更新を受け取ります。[`command` ソース](/docs/ja/plugin-marketplaces#command-sources)を除きます。[バージョン管理](#version-management)を参照してください。マーケットプレイスエントリにも設定されている場合、`plugin.json` が優先されます。省略した場合、バージョンは[バージョン管理](#version-management)の次のソースから取得されます。 | `"2.1.0"`                                                         |
| `description`    | string  | プラグインの目的の簡潔な説明                                                                                                                                                                                                                                                                                  | `"Deployment automation tools"`                                   |
| `author`         | object  | 著者情報                                                                                                                                                                                                                                                                                            | `{"name": "Dev Team", "email": "dev@company.com"}`                |
| `homepage`       | string  | ドキュメント URL                                                                                                                                                                                                                                                                                      | `"https://docs.example.com"`                                      |
| `repository`     | string  | ソースコード URL                                                                                                                                                                                                                                                                                      | `"https://github.com/user/plugin"`                                |
| `license`        | string  | ライセンス識別子                                                                                                                                                                                                                                                                                        | `"MIT"`、`"Apache-2.0"`                                            |
| `keywords`       | array   | 検出タグ                                                                                                                                                                                                                                                                                            | `["deployment", "ci-cd"]`                                         |
| `metadata`       | object  | 権利付与またはカタログフィールドなど、独自のデータ用のフリーフォームオブジェクト。Claude Code はこれを読まないため、値はプラグインの動作に影響しません。Claude Code は非オブジェクト値を無視し、`claude plugin validate` は警告として報告します。v2.1.222 より前では、Claude Code はキーを[認識されないフィールド](#unrecognized-fields)として扱いました。                                                                    | `{"catalogId": "cat-123"}`                                        |
| `defaultEnabled` | boolean | ユーザーが設定を設定していない場合、プラグインが有効な状態で開始するかどうか。デフォルトは `true` です。[デフォルト有効化](#default-enablement)を参照してください。                                                                                                                                                                                               | `false`                                                           |

<h3 id="default-enablement">
  デフォルト有効化
</h3>

`plugin.json` で `defaultEnabled: false` を設定して、無効な状態でインストールされるプラグインを配布します。ユーザーは `claude plugin enable <plugin>` または `/plugin` インターフェースでオンにします。外部サービスに接続するなど、ユーザーがオプトインすべきコストまたはスコープを追加するプラグインに使用します。

`defaultEnabled` は、他に何もプラグインの状態を決定していない場合のフォールバックです。2 つのことがそれより優先されます。

* **ユーザーの設定**: 任意の設定スコープで `enabledPlugins` のプラグインエントリ。一度書き込まれると、プラグイン更新と再インストール全体で永続化されるため、後のリリースで `defaultEnabled` を変更しても既存ユーザーは反転しません。
* **依存関係要件**: プラグインが別のアクティブなプラグインによって必要とされる場合、Claude Code はインストール時または有効化時に `true` を書き込みます。これにより明示的な設定が与えられるため、独自のデフォルトは適用されなくなります。[依存関係を持つプラグインを有効または無効にする](/docs/ja/plugin-dependencies#enable-or-disable-a-plugin-with-dependencies)を参照してください。

同じフィールドはプラグインのマーケットプレイスエントリに表示でき、`plugin.json` の値より優先されます。[オプションプラグインフィールド](/docs/ja/plugin-marketplaces#optional-plugin-fields)を参照してください。

<h3 id="component-path-fields">
  コンポーネントパスフィールド
</h3>

| フィールド                   | 型                     | 説明                                                                                                                                                             | 例                                                    |
| :---------------------- | :-------------------- | :------------------------------------------------------------------------------------------------------------------------------------------------------------- | :--------------------------------------------------- |
| `skills`                | string\|array         | `<name>/SKILL.md` を含むカスタムスキルディレクトリ。デフォルト `skills/` スキャンに追加されます。マーケットプレイスルート例外については[パス動作ルール](#path-behavior-rules)を参照してください                                     | `"./custom/skills/"`                                 |
| `commands`              | string\|array         | カスタムフラット `.md` スキルファイルまたはディレクトリ（デフォルト `commands/` を置き換え）                                                                                                       | `"./custom/cmd.md"` または `["./cmd1.md"]`              |
| `agents`                | string\|array         | カスタムエージェントファイル（デフォルト `agents/` を置き換え）                                                                                                                          | `"./custom/agents/reviewer.md"`                      |
| `workflows`             | string\|array         | カスタム[ワークフロー](/docs/ja/workflows)スクリプトファイルまたはディレクトリ（デフォルト `workflows/` を置き換え）                                                                                        | `"./custom/workflows/"`                              |
| `hooks`                 | string\|array\|object | フックコンフィグパスまたはインラインコンフィグ                                                                                                                                        | `"./my-extra-hooks.json"`                            |
| `mcpServers`            | string\|array\|object | MCP コンフィグパスまたはインラインコンフィグ                                                                                                                                       | `"./my-extra-mcp-config.json"`                       |
| `outputStyles`          | string\|array         | カスタム出力スタイルファイル/ディレクトリ（デフォルト `output-styles/` を置き換え）                                                                                                            | `"./styles/"`                                        |
| `lspServers`            | string\|array\|object | コード知能（定義へ移動、参照を検索など）用の[Language Server Protocol](https://microsoft.github.io/language-server-protocol/)コンフィグ                                                   | `"./.lsp.json"`                                      |
| `experimental.themes`   | string\|array         | カラーテーマファイル/ディレクトリ（デフォルト `themes/` を置き換え）。[テーマ](#themes)を参照してください                                                                                               | `"./themes/"`                                        |
| `experimental.monitors` | string\|array         | プラグインがアクティブな場合に自動的に開始されるバックグラウンド[Monitor](/docs/ja/tools-reference#monitor-tool)コンフィグ。[モニター](#monitors)を参照してください                                                    | `"./monitors.json"`                                  |
| `experimental.evals`    | string\|array         | プラグインルートの下のディレクトリ。プラグインの[eval ケース](/docs/ja/plugin-evals#use-a-different-eval-directory)を保持します。デフォルト `evals/` ではない場合。`claude plugin eval --eval-dir` はそれをオーバーライドします | `"quality/evals"`                                    |
| `userConfig`            | object                | 有効化時にプロンプトされるユーザー設定可能な値。[ユーザー設定](#user-configuration)を参照してください                                                                                                 | 以下を参照                                                |
| `channels`              | array                 | メッセージ注入用のチャネル宣言（Telegram、Slack、Discord スタイル）。[チャネル](#channels)を参照してください                                                                                        | 以下を参照                                                |
| `dependencies`          | array                 | このプラグインが必要とする他のプラグイン。オプションで semver バージョン制約付き。[プラグイン依存関係バージョンを制約する](/docs/ja/plugin-dependencies)を参照してください                                                           | `[{ "name": "secrets-vault", "version": "~2.1.0" }]` |

<h3 id="experimental-components">
  実験的コンポーネント
</h3>

`experimental` キー、`themes` および `monitors` の下のコンポーネントは、安定化中にリリース間でマニフェストスキーマが変更される可能性があります。それらを宣言する場所は別の移行です。トップレベルはまだ機能し、`claude plugin validate` は警告を出し、将来のリリースは `experimental.*` を必要とします。

<h3 id="user-configuration">
  ユーザー設定
</h3>

`userConfig` フィールドは、プラグインが有効化されたときに Claude Code がユーザーにプロンプトする値を宣言します。ユーザーに `settings.json` を手動で編集させる代わりに、これを使用してください。

```json theme={null}
{
  "userConfig": {
    "api_endpoint": {
      "type": "string",
      "title": "API endpoint",
      "description": "Your team's API endpoint"
    },
    "api_token": {
      "type": "string",
      "title": "API token",
      "description": "API authentication token",
      "sensitive": true
    }
  }
}
```

キーは有効な識別子である必要があります。各オプションはこれらのフィールドをサポートします。

| フィールド         | 必須  | 説明                                                         |
| :------------ | :-- | :--------------------------------------------------------- |
| `type`        | はい  | `string`、`number`、`boolean`、`directory`、または `file` のいずれか   |
| `title`       | はい  | 設定ダイアログに表示されるラベル                                           |
| `description` | はい  | フィールドの下に表示されるヘルプテキスト                                       |
| `sensitive`   | いいえ | `true` の場合、入力をマスクし、値を `settings.json` の代わりにセキュアストレージに保存します |
| `required`    | いいえ | `true` の場合、フィールドが空の場合は検証が失敗します                             |
| `default`     | いいえ | ユーザーが何も提供しない場合に使用される値                                      |
| `multiple`    | いいえ | `string` 型の場合、文字列の配列を許可します                                 |
| `min` / `max` | いいえ | `number` 型の境界                                              |

各値は MCP および LSP サーバーコンフィグとフックコマンドで `${user_config.KEY}` として置換可能です。機密でない値はスキルおよびエージェントコンテンツでも置換できます。すべての値は `CLAUDE_PLUGIN_OPTION_<KEY>` 環境変数としてフックプロセスにエクスポートされます。ここで `<KEY>` はオプションキーを大文字にしたものです。

シェルで実行されるフィールドは `${user_config.*}` を拒否します。設定された値をシェルコマンドに置換すると、シェルはその値が含むものを実行できるため、コンポーネントは[エラー](/docs/ja/errors#plugin-command-references-user-config)で失敗します。拒否された各フィールドには、値を渡す別の方法があります。

| 拒否されたフィールド                                                                   | 値を渡す方法                                                                                                    |
| :--------------------------------------------------------------------------- | :-------------------------------------------------------------------------------------------------------- |
| シェル形式フックコマンド                                                                 | `args` で[exec 形式](/docs/ja/hooks#exec-form-and-shell-form)を使用するか、フックの環境から `CLAUDE_PLUGIN_OPTION_<KEY>` を読み取ります |
| [Monitor](#monitors)コマンド                                                     | スクリプトの設定ファイルから値を読み取ります                                                                                    |
| MCP [`headersHelper`](/docs/ja/mcp#use-dynamic-headers-for-custom-authentication) | スクリプトの設定ファイルから値を読み取ります                                                                                    |

v2.1.207 より前では、これらのフィールドは `${user_config.KEY}` 値を置換しました。これに依存していたプラグインを更新してください。

機密でない値は、ユーザー `settings.json` の [`pluginConfigs`](/docs/ja/settings-reference#pluginconfigs) キーの下に `pluginConfigs[<plugin-id>].options` として保存されます。

macOS では、Claude Code は機密値を macOS キーチェーンに保存し、キーチェーンが書き込みを拒否した場合は `~/.claude/.credentials.json` にフォールバックします。サポートされているキーチェーンのないプラットフォームでは、`~/.claude/.credentials.json` に保存されます。キーチェーンストレージは OAuth トークンと共有され、約 2 KB の合計制限があるため、機密値は小さく保ってください。

Claude Code は 3 つの設定ソースからのみすべての `pluginConfigs` 値を読み取ります。

* **ユーザー設定**: `~/.claude/settings.json`。有効化時プロンプトが書き込むファイル
* **`--settings`**: CLI フラグまたは SDK インライン設定
* **管理設定**: [組織制御ポリシー](/docs/ja/permissions#managed-settings)

複数のソースが同じキーを設定する場合、管理設定が優先され、次に `--settings`、次にユーザー設定が優先されます。このリストから削除できる唯一のソースはユーザー設定です。`user` なしで [`--setting-sources`](/docs/ja/cli-reference#cli-flags) を渡すと、Claude Code はそれらをスキップします。管理設定と `--settings` は、渡すものが何であれ保持されます。SDK の [`settingSources`](/docs/ja/agent-sdk/claude-code-features#what-settingsources-does-not-control)オプションは同じリストを設定します。

プロジェクトの `.claude/settings.json` または `.claude/settings.local.json` のエントリは無視されます。両方のファイルはワークスペースに存在するため、クローンされたリポジトリはそこに値を提供でき、それらの値はプラグインフックコマンド、MCP サーバーコンフィグ、LSP コマンド、およびモニターコマンドに流れます。v2.1.207 より前では、これらのエントリが読み取られました。制限は `pluginConfigs` に固有です。[`enabledPlugins`](/docs/ja/settings-reference#enabledplugins)はまだプロジェクトおよびローカル設定を尊重します。

<h3 id="channels">
  チャネル
</h3>

`channels` フィールドを使用すると、プラグインは 1 つ以上のメッセージチャネルを宣言でき、コンテンツを会話に注入します。各チャネルはプラグインが提供する MCP サーバーにバインドされます。

```json theme={null}
{
  "channels": [
    {
      "server": "telegram",
      "userConfig": {
        "bot_token": {
          "type": "string",
          "title": "Bot token",
          "description": "Telegram bot token",
          "sensitive": true
        },
        "owner_id": {
          "type": "string",
          "title": "Owner ID",
          "description": "Your Telegram user ID"
        }
      }
    }
  ]
}
```

`server` フィールドは必須で、プラグインの `mcpServers` のキーと一致する必要があります。オプションのチャネルごとの `userConfig` はトップレベルフィールドと同じスキーマを使用し、プラグインがプラグイン有効化時にボットトークンまたはオーナー ID をプロンプトできるようにします。

<h3 id="path-behavior-rules">
  パス動作ルール
</h3>

カスタムパスがプラグインのデフォルトディレクトリを置き換えるか拡張するかは、フィールドによって異なります。

* **デフォルトを置き換え**: `commands`、`agents`、`workflows`、`outputStyles`、`experimental.themes`、`experimental.monitors`。たとえば、マニフェストが `commands` を指定する場合、デフォルト `commands/` ディレクトリはスキャンされません。デフォルトを保持して追加するには、明示的にリストします。`"commands": ["./commands/", "./extras/"]`
* **デフォルトに追加**: `skills`。デフォルト `skills/` ディレクトリは常にスキャンされ、`skills` にリストされているディレクトリはそれと一緒に読み込まれます。例外: [ソースがマーケットプレイスルートに解決される](/docs/ja/plugin-marketplaces#advanced-plugin-entries)マーケットプレイスエントリの場合、特定のサブディレクトリを宣言するとデフォルト `skills/` スキャンが置き換えられます
* **独自のマージルール**: [フック](#hooks)、[MCP サーバー](#mcp-servers)、および[LSP サーバー](#lsp-servers)。各セクションで複数のソースがどのように結合されるかを参照してください

プラグインがデフォルトフォルダと一致するマニフェストキーの両方を持つ場合、Claude Code は `claude plugin list` と `/plugin` 詳細ビューで無視されたフォルダについて警告します。プラグインはマニフェストパスを使用して読み込まれます。マニフェストキーがデフォルトフォルダを指す場合、Claude Code は警告しません。たとえば `"commands": ["./commands/deploy.md"]` の場合、そのパスはフォルダを明示的に名前付けするためです。

すべてのパスフィールドについて。

* すべてのパスはプラグインルートに相対的で `./` で始まる必要があります。ただし、`skills` フィールドは `.` も受け入れます
  * `"."` と `"./"` の両方はプラグインルート自体を示します
  * v2.1.221 より前では、`"."` はマニフェスト検証に失敗し、プラグインは読み込まれなかったため、以前のバージョンをサポートするには `"./"` を使用してください
* カスタムパスのコンポーネントは同じ命名および名前空間ルールを使用します
* 複数のパスは配列として指定できます
* スキルパスは `SKILL.md` を直接含むディレクトリを指すことができます。たとえば、プラグインルートの場合は `"skills": ["."]`
  * Claude Code はスキルの呼び出し名を `SKILL.md` のフロントマター `name` フィールドから取得するため、インストールディレクトリの名前が何であれ、名前は安定したままです
  * フロントマターで `name` が設定されていない場合、Claude Code はディレクトリベース名にフォールバックします

プラグインがルートに `SKILL.md` を持ち、`skills/` サブディレクトリがなく、`skills` マニフェストフィールドがない場合、自動的に単一スキルプラグインとして読み込まれます。このレイアウトの場合、`plugin.json` で `"skills": ["./"]` を設定する必要はありません。

**パスの例**:

```json theme={null}
{
  "commands": [
    "./specialized/deploy.md",
    "./utilities/batch-process.md"
  ],
  "agents": [
    "./custom-agents/reviewer.md",
    "./custom-agents/tester.md"
  ]
}
```

<h3 id="environment-variables">
  環境変数
</h3>

Claude Code は 3 つのパス参照用変数を提供します。

| 変数                      | 解決先                                                                 | 用途                                                           |
| :---------------------- | :------------------------------------------------------------------ | :----------------------------------------------------------- |
| `${CLAUDE_PLUGIN_ROOT}` | プラグインのインストールディレクトリへの絶対パス                                            | プラグインにバンドルされたスクリプト、バイナリ、設定ファイル                               |
| `${CLAUDE_PLUGIN_DATA}` | プラグイン更新を超えて存続する[永続ディレクトリ](#persistent-data-directory)。最初の参照時に作成されます | `node_modules` または Python 仮想環境などのインストール済み依存関係、生成されたコード、キャッシュ |
| `${CLAUDE_PROJECT_DIR}` | プロジェクトルート                                                           | プロジェクトローカルスクリプトと設定ファイル                                       |

3 つすべてはフックプロセスおよび MCP と LSP サーバーサブプロセスに環境変数としてエクスポートされます。どのフィールドがそれらをインラインで置換するかは、プラグインコンポーネントによって異なります。

| プラグインコンポーネント               | プレースホルダーが解決されるフィールド                      |
| :------------------------- | :--------------------------------------- |
| スキルおよびエージェントコンテンツ          | プレースホルダーが表示される任意の場所                      |
| フックおよびモニターコマンド             | プレースホルダーが表示される任意の場所                      |
| MCP `stdio` サーバー           | `command`、`args`、`env`                   |
| MCP `http`、`sse`、`ws` サーバー | `url`、`headers`、`headersHelper`          |
| LSP サーバー                   | `command`、`args`、`env`、`workspaceFolder` |

フックコマンドでは、各パスが 1 つの引数として引用符なしで渡されるように、`args` で[exec 形式](/docs/ja/hooks#exec-form-and-shell-form)を使用してください。シェル形式フックおよびモニターコマンドでは、変数を二重引用符で囲みます。`"${CLAUDE_PROJECT_DIR}/scripts/server.sh"` のように。このシェル形式フックはプラグインにバンドルされたスクリプトを実行します。

```json theme={null}
{
  "hooks": {
    "PostToolUse": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "\"${CLAUDE_PLUGIN_ROOT}\"/scripts/process.sh"
          }
        ]
      }
    ]
  }
}
```

`${CLAUDE_PLUGIN_ROOT}` はプラグインが更新されるときに変更されます。前のバージョンのディレクトリは更新後の猶予期間ディスク上に残りますが、それを一時的なものとして扱い、そこに状態を書き込まないでください。クリーンアップセマンティクスについては[プラグインキャッシング](#plugin-caching-and-file-resolution)を参照してください。

プラグインがセッション中に更新される場合、フックコマンド、モニター、MCP サーバー、および LSP サーバーは前のバージョンのパスを使用し続けます。`/reload-plugins` を実行して、フック、MCP サーバー、および LSP サーバーを新しいパスに切り替えます。モニターはセッション再開が必要です。インタラクティブターミナルのないセッションでは、リロードはプラグイン MCP サーバーを次のセッションまで古いパスに残します。

`command` ソースを持つプラグインの場合、Claude Code は[プラグイン自体を再実行](/docs/ja/plugin-marketplaces#when-claude-code-re-runs-the-command)できます。

MCP サーバーは実行時にセッションの作業ディレクトリを読み取るために `roots/list` リクエストを呼び出すこともできます。[`roots/list` が返すもの、および Claude Code がサーバーに変更を通知するタイミング](/docs/ja/mcp#option-3-add-a-local-stdio-server)を参照してください。

<h4 id="persistent-data-directory">
  永続データディレクトリ
</h4>

`${CLAUDE_PLUGIN_DATA}` ディレクトリは `~/.claude/plugins/data/{id}/` に解決されます。ここで `{id}` はプラグイン識別子で、`a-z`、`A-Z`、`0-9`、`_`、および `-` 以外の文字は `-` に置き換えられます。`formatter@my-marketplace` としてインストールされたプラグインの場合、ディレクトリは `~/.claude/plugins/data/formatter-my-marketplace/` です。

一般的な用途は、言語依存関係を 1 回インストールし、セッションとプラグイン更新全体で再利用することです。Python 依存関係、Yarn または pnpm でロックされた依存関係、およびライフサイクルスクリプトを実行する必要があるパッケージに使用します。マーケットプレイスインストール済みプラグインの場合、それが必要ない場合があります。Claude Code はプラグインをキャッシュするときに、適格な[Node.js パッケージ依存関係](#node-js-package-dependencies)を自動的にインストールします。

データディレクトリは単一のプラグインバージョンより長く存続するため、ディレクトリ存在チェックのみでは、更新がプラグインの依存関係マニフェストを変更したときを検出できません。推奨パターンはバンドルされたマニフェストをデータディレクトリのコピーと比較し、異なる場合は再インストールします。

この `SessionStart` フックは最初の実行時に `node_modules` をインストールし、プラグイン更新に変更された `package.json` が含まれるたびに再度インストールします。

```json theme={null}
{
  "hooks": {
    "SessionStart": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "diff -q \"${CLAUDE_PLUGIN_ROOT}/package.json\" \"${CLAUDE_PLUGIN_DATA}/package.json\" >/dev/null 2>&1 || (cd \"${CLAUDE_PLUGIN_DATA}\" && cp \"${CLAUDE_PLUGIN_ROOT}/package.json\" . && npm install) || rm -f \"${CLAUDE_PLUGIN_DATA}/package.json\""
          }
        ]
      }
    ]
  }
}
```

`diff` はストレージコピーが見つからないか、バンドルされたものと異なる場合にゼロ以外で終了し、最初の実行と依存関係変更更新の両方をカバーします。`npm install` が失敗した場合、末尾の `rm` はコピーされたマニフェストを削除して、次のセッションが再試行されるようにします。

`${CLAUDE_PLUGIN_ROOT}` にバンドルされたスクリプトは、永続化された `node_modules` に対して実行できます。

```json theme={null}
{
  "mcpServers": {
    "routines": {
      "command": "node",
      "args": ["${CLAUDE_PLUGIN_ROOT}/server.js"],
      "env": {
        "NODE_PATH": "${CLAUDE_PLUGIN_DATA}/node_modules"
      }
    }
  }
}
```

データディレクトリは、プラグインをインストールされている最後のスコープからアンインストールするときに自動的に削除されます。`/plugin` インターフェースはディレクトリサイズを表示し、削除前にプロンプトします。CLI はデフォルトで削除します。[`--keep-data`](#plugin-uninstall)を渡して保持します。

***

<h2 id="plugin-caching-and-file-resolution">
  プラグインのキャッシングとファイル解決
</h2>

プラグインは以下の 2 つの方法のいずれかで指定されます。

* `claude --plugin-dir` または `claude --plugin-url` を通じて、セッションの期間中。
* マーケットプレイスを通じて、今後のセッション用にインストール。

セキュリティと検証の目的で、Claude Code はマーケットプレイス プラグインをユーザーのローカル **プラグインキャッシュ** （`~/.claude/plugins/cache`）にコピーします。ただし、[リンクモードの `command` ソース](/docs/ja/plugin-marketplaces#copy-mode-and-link-mode)は例外で、Claude Code はキャッシュエントリ内のリンクを通じてこれらをインプレイスで使用します。

コピーされたプラグインの場合、インストールされた各バージョンはキャッシュ内の個別のディレクトリであり、マーケットプレイスとプラグインでグループ化され、解決されたバージョンに対して名前が付けられ、プラグインのファイルと [Node.js パッケージ依存関係](#node-js-package-dependencies)の独自のコピーを持ちます。[リリースタグ](/docs/ja/plugin-dependencies#tag-plugin-releases-for-version-resolution)から解決された依存関係は、コミット SHA サフィックス付きのディレクトリ名を取得します。

プラグインを更新またはアンインストールすると、Claude Code は前のバージョンディレクトリを孤立したものとしてマークし、約 14 日後のバックグラウンドスイープで削除します。猶予期間により、既に古いバージョンをロードした同時実行中の Claude Code セッションがエラーなく実行を続けることができます。Claude Code はスイープを実行するのは、少なくとも 1 つのプラグインがインストールされている場合のみです。最後のプラグインをアンインストールした後、孤立したディレクトリはディスク上に残り、プラグインを再度インストールするまで保持されます。

Claude Code は、プラグインまたはマーケットプレイスフォルダをキャッシュから削除するのは、ディレクトリまたはシンボリックリンクが含まれなくなった場合のみです。開発チェックアウトをキャッシュにシンボリックリンクとしてプラグインのバージョンエントリにリンクする場合、Claude Code はリンクを孤立したものとしてマークすることはなく、削除することもなく、それを保持するフォルダも削除しません。Claude Code はリンクされたチェックアウト内にバージョン追跡ファイルを書き込むこともありません。

Claude の Glob および Grep ツールは検索中に孤立したバージョンディレクトリをスキップするため、ファイル結果には古いプラグインコードが含まれません。

<h3 id="node-js-package-dependencies">
  Node.js パッケージ依存関係
</h3>

Claude Code がプラグインをキャッシュにコピーするとき、プラグインの Node.js パッケージ依存関係もそこにインストールするため、プラグインのフック と MCP サーバーはそれらをロードできます。このセクションでは、プラグインが独自の `package.json` で宣言する npm および Bun パッケージについて説明します。他のプラグインに依存するプラグインについては、[プラグイン依存関係バージョン](/docs/ja/plugin-dependencies)を参照してください。

Claude Code は、コピーされたバージョンディレクトリを作成するたびに、その内部でインストールを実行します。プラグインをインストールするとき、Claude Code がプラグインを新しいバージョンに更新するとき、および有効なプラグインがまだキャッシュされていない場合のセッション開始時（新しいマシンなど）です。インストールは、プラグインのルートディレクトリに `package.json` とサポートされているロックファイルの両方が含まれている場合にのみ実行されます。

| ロックファイル                                       | コマンド                                             |
| :-------------------------------------------- | :----------------------------------------------- |
| `bun.lock` または `bun.lockb`                    | `bun install --frozen-lockfile --ignore-scripts` |
| `npm-shrinkwrap.json` または `package-lock.json` | `npm ci --ignore-scripts`                        |

プラグインにこれらのロックファイルが複数含まれている場合、Claude Code は最初のマッチを使用し、順序をチェックします。`bun.lock`、`bun.lockb`、`npm-shrinkwrap.json`、`package-lock.json`。Claude Code は `yarn.lock` と `pnpm-lock.yaml` をスキップします。Yarn と pnpm は `--ignore-scripts` をバイパスする解決時間設定フックをサポートしているためです。

最も広いリーチのために npm ロックファイルを配布してください。Claude Code はマッチされたロックファイルのパッケージマネージャーをユーザーの PATH から実行し、ロックファイルが見つからない場合は他のロックファイルにフォールバックしません。npm ソースを通じて配布されるプラグインの場合は、`npm-shrinkwrap.json` を使用してください。npm は公開されたパッケージから `package-lock.json` を除外します。

Claude Code はこの依存関係インストールを制約して、プラグインまたはそのパッケージからのコードがインストール中に実行されず、実行時間が制限されます。

* **凍結された解決:** Bun と npm はロックファイルがピンしたものを正確にインストールし、`package.json` とロックファイルが一致しない場合は再解決するのではなく失敗します。
* **ライフサイクルスクリプトなし:** `--ignore-scripts` は `preinstall`、`install`、および `postinstall` スクリプトが実行されないようにするため、これらのスクリプトでネイティブモジュールをビルドする依存関係はダウンロードされますが、このインストール中にはコンパイルされません。
* **60 秒のタイムアウト:** Claude Code は実行時間が長いインストールを停止し、失敗として扱います。

npm ソースプラグイン自体をフェッチすると、この依存関係インストールが実行される前に、ライフサイクルスクリプトが有効な状態で `npm install` が実行されます。

失敗またはスキップされたインストールはプラグインをブロックすることはありません。インストールが失敗した場合、または Claude Code が yarn または pnpm ロックファイルをスキップした場合、理由は [デバッグ出力](#debugging-commands)の警告として記録されます。`package.json` とロックファイルがないプラグインはログエントリなしでスキップされます。タイムアウトしたインストールは、キャッシュされたコピーに部分的な `node_modules` ツリーを残すことができます。

自動インストールをオフにすることはできません。設定または環境変数はそれを無効にしません。制限されたネットワークでは、[ネットワークアクセス要件](/docs/ja/network-config#network-access-requirements)を参照して、許可するホストを確認してください。

自動インストールが提供できない依存関係（ライフサイクルスクリプトをビルドする必要があるパッケージ、Python 依存関係、または Yarn または pnpm でロックされたプラグインなど）については、[永続データディレクトリ](#persistent-data-directory)へのフックからインストールしてください。

<h3 id="path-traversal-limitations">
  パストラバーサルの制限
</h3>

Claude Code はプラグインが独自のディレクトリ外のファイルを参照することを許可しません。プラグインルートの外に解決されるコンポーネントパスを拒否します。パスが `plugin.json` で宣言されているか、[マーケットプレイスエントリ](/docs/ja/plugin-marketplaces#plugin-entries)で宣言されているかに関わらず。これは、`../shared-utils` などのように書かれたプラグインの外を指すパス、および [1 つのマーケットプレイス内のリンク](#share-files-within-a-marketplace-with-symlinks)以外のプラグインの外につながるシンボリックリンクをカバーします。

macOS と Linux では、Claude Code はコンポーネントパスにバックスラッシュが含まれている場合も拒否します。バックスラッシュパスで宣言されたコンポーネントは、Windows でのみロードされます。`./commands/deploy.md` などのようにフォワードスラッシュを使用してコンポーネントパスを記述してください。

Claude Code がパスを拒否すると、[`path escapes plugin directory`](/docs/ja/errors#path-escapes-plugin-directory) エラーを報告し、そのコンポーネントなしでプラグインをロードします。

Claude Code はプラグインをインストールするときにプラグインディレクトリ外のファイルをキャッシュにコピーしないため、コピーされたプラグイン内のスクリプトがプラグインルート上のパスを読み取る場合、それらのファイルも見つかりません。

<h3 id="share-files-within-a-marketplace-with-symlinks">
  シンボリックリンクを使用してマーケットプレイス内でファイルを共有する
</h3>

プラグインが同じマーケットプレイスの他の部分とファイルを共有する必要がある場合は、プラグインディレクトリ内にシンボリックリンクを作成できます。プラグインがキャッシュにコピーされるときにシンボリックリンクがどのように処理されるかは、そのターゲットがどこに解決されるかによって異なります。

* **プラグイン独自のディレクトリ内:** シンボリックリンクはキャッシュ内の相対シンボリックリンクとして保持されるため、実行時にコピーされたターゲットへの解決を続けます。
* **同じマーケットプレイス内の他の場所:** シンボリックリンクは逆参照されます。ターゲットのコンテンツはキャッシュにコピーされます。これにより、メタプラグインの `skills/` ディレクトリがマーケットプレイス内の他のプラグインで定義されたスキルにリンクできます。
* **マーケットプレイス外:** シンボリックリンクはセキュリティのためスキップされます。これにより、プラグインがシステムパスなどの任意のホストファイルをキャッシュに取り込むことを防ぎます。

`--plugin-dir` でインストールされたプラグイン、ローカルパスから、または [コピーモードの `command` ソース](/docs/ja/plugin-marketplaces#copy-mode-and-link-mode)から、プラグイン独自のディレクトリ内で解決されるシンボリックリンクのみが保持されます。その他はすべてスキップされます。

次のコマンドは、マーケットプレイスプラグイン内から、兄弟プラグインで定義された共有スキルへのリンクを作成します。Windows では、昇格されたコマンドプロンプトから `mklink /D` を使用するか、開発者モードを有効にしてください。

```bash theme={null}
ln -s ../../shared-plugin/skills/foo ./skills/foo
```

***

<h2 id="plugin-directory-structure">
  プラグインディレクトリ構造
</h2>

<h3 id="standard-plugin-layout">
  標準プラグインレイアウト
</h3>

完全なプラグインは以下の構造に従います：

```text theme={null}
enterprise-plugin/
├── .claude-plugin/           # メタデータディレクトリ（オプション）
│   └── plugin.json             # プラグインマニフェスト
├── skills/                   # Skills
│   ├── code-reviewer/
│   │   └── SKILL.md
│   └── pdf-processor/
│       ├── SKILL.md
│       └── scripts/
├── commands/                 # Skills をフラット .md ファイルとして
│   ├── status.md
│   └── logs.md
├── agents/                   # Subagent 定義
│   ├── security-reviewer.md
│   ├── performance-tester.md
│   └── compliance-checker.md
├── workflows/                # ワークフロースクリプト
│   └── release-audit.js
├── output-styles/            # 出力スタイル定義
│   └── terse.md
├── themes/                   # カラーテーマ定義
│   └── dracula.json
├── monitors/                 # バックグラウンドモニター設定
│   └── monitors.json
├── hooks/                    # Hook 設定
│   ├── hooks.json           # メイン hook 設定
│   └── security-hooks.json  # 追加 hooks
├── bin/                      # プラグイン実行ファイルが PATH に追加される
│   └── my-tool               # Bash tool で裸のコマンドとして呼び出し可能
├── settings.json            # プラグインのデフォルト設定
├── .mcp.json                # MCP サーバー定義
├── .lsp.json                # LSP サーバー設定
├── scripts/                 # Hook とユーティリティスクリプト
│   ├── security-scan.sh
│   ├── format-code.py
│   └── deploy.js
├── LICENSE                  # ライセンスファイル
└── CHANGELOG.md             # バージョン履歴
```

<Warning>
  `.claude-plugin/` ディレクトリには `plugin.json` ファイルが含まれます。その他すべてのディレクトリ（commands/、agents/、skills/、workflows/、output-styles/、themes/、monitors/、hooks/）は `.claude-plugin/` 内ではなく、プラグインルートに配置する必要があります。
</Warning>

プラグインルートの `CLAUDE.md` ファイルはプロジェクトコンテキストとして読み込まれません。プラグインは CLAUDE.md ではなく、skills、agents、hooks を通じてコンテキストを提供します。Claude のコンテキストに読み込まれる命令を配布するには、[skill](#skills) に配置してください。

<h3 id="file-locations-reference">
  ファイルロケーション参照
</h3>

| コンポーネント      | デフォルトロケーション                  | 目的                                                                                                                                                                                          |
| :----------- | :--------------------------- | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| **マニフェスト**   | `.claude-plugin/plugin.json` | プラグインメタデータと設定（オプション）                                                                                                                                                                        |
| **Skills**   | `skills/`                    | `<name>/SKILL.md` 構造の Skills                                                                                                                                                                |
| **コマンド**     | `commands/`                  | フラット Markdown ファイルとしての Skills。新しいプラグインには `skills/` を使用してください                                                                                                                                |
| **Agents**   | `agents/`                    | Subagent Markdown ファイル                                                                                                                                                                      |
| **ワークフロー**   | `workflows/`                 | [ワークフロー](/docs/ja/workflows) スクリプトファイル                                                                                                                                                           |
| **出力スタイル**   | `output-styles/`             | 出力スタイル定義                                                                                                                                                                                    |
| **テーマ**      | `themes/`                    | カラーテーマ定義                                                                                                                                                                                    |
| **Hooks**    | `hooks/hooks.json`           | Hook 設定                                                                                                                                                                                     |
| **MCP サーバー** | `.mcp.json`                  | MCP サーバー定義                                                                                                                                                                                  |
| **LSP サーバー** | `.lsp.json`                  | 言語サーバー設定                                                                                                                                                                                    |
| **モニター**     | `monitors/monitors.json`     | バックグラウンドモニター設定                                                                                                                                                                              |
| **実行ファイル**   | `bin/`                       | Bash tool の `PATH` に追加され、プラグインが有効な間は裸のコマンドとして呼び出し可能な実行ファイル。[claude.ai 組織設定を通じて配布するプラグイン](/docs/ja/plugin-marketplaces#keep-executables-out-of-the-top-level-bin-directory)にはこのディレクトリを含めることはできません |
| **設定**       | `settings.json`              | プラグインが有効になったときに適用されるデフォルト設定。[`agent`](/docs/ja/sub-agents) と [`subagentStatusLine`](/docs/ja/statusline#subagent-status-lines) キーのみがサポートされています                                                        |

***

<h2 id="cli-commands-reference">
  CLI コマンドリファレンス
</h2>

Claude Code は、非対話的なプラグイン管理用の CLI コマンドを提供します。スクリプトとオートメーションに便利です。

<h3 id="plugin-init">
  plugin init
</h3>

`~/.claude/skills/<name>/` に新しいプラグインをスキャフォルドします。次の Claude Code セッションで、`<name>@skills-dir` として自動的に読み込まれ、`/plugin` と `claude plugin list` に表示されます。インストール手順は不要です。

[スキルディレクトリプラグイン](#skills-directory-plugins)のスコープと信頼要件を参照してください。

```bash theme={null}
claude plugin init <name> [options]
```

コマンドは以下の引数を取ります:

* `<name>`: プラグイン名。スキル名前空間と `~/.claude/skills/` の下のディレクトリ名になるため、スペースやパス区切り文字を含めることはできません。

コマンドは以下のオプションを受け入れます:

| オプション                    | 説明                                                                                          | デフォルト                   |
| :----------------------- | :------------------------------------------------------------------------------------------ | :---------------------- |
| `--description <text>`   | マニフェストの説明                                                                                   |                         |
| `--author <name>`        | 作成者名                                                                                        | `git config user.name`  |
| `--author-email <email>` | 作成者メール                                                                                      | `git config user.email` |
| `--with <components...>` | コンポーネントフォルダもスキャフォルドします。有効な値: `skills`、`agents`、`hooks`、`mcp`、`lsp`、`output-style`、`channel` |                         |
| `-f, --force`            | ターゲットの既存 `.claude-plugin/` を上書きします                                                          |                         |
| `-h, --help`             | コマンドのヘルプを表示                                                                                 |                         |

`claude plugin new` はこのコマンドのエイリアスです。

各 `--with` 値は、そのコンポーネント用のスターターファイルを追加し、編集可能な状態にします:

| コンポーネント        | スキャフォルドされるもの                                                                            |
| :------------- | :-------------------------------------------------------------------------------------- |
| `skills`       | デフォルトのスキルと並んで、追加の名前空間付き `<name>:example` スキル                                            |
| `agents`       | `agents/` サブエージェント定義                                                                    |
| `hooks`        | サンプルイベントハンドラを含む `hooks/hooks.json`                                                      |
| `mcp`          | HTTP と stdio サーバーの例を含む `.mcp.json`                                                      |
| `lsp`          | `.lsp.json` 言語サーバーの例                                                                    |
| `output-style` | プラグインが有効な間に自動的に適用される `output-styles/<name>.md`                                          |
| `channel`      | MCP ベースの[チャネル](/docs/ja/channels): stdio サーバー（`server.ts`）、その `.mcp.json`、および `package.json` |

スキャフォルドされたプラグインは、マーケットプレイスではなく `@skills-dir` ソースを使用します。管理者は `strictKnownMarketplaces` でこのソースをブロックするか、[管理設定](/docs/ja/plugin-marketplaces#managed-marketplace-restrictions)の `blockedMarketplaces` に `{"source": "skills-dir"}` を追加することでブロックできます。ブロックされている場合、`plugin init` は書き込み前に失敗します。

これらの例は一般的な呼び出しを示しています:

```bash theme={null}
# 最小限のプラグインをスキャフォルド
claude plugin init my-helper

# スキルとフックフォルダを含めてスキャフォルド
claude plugin init my-helper --with skills hooks

# 既存のスキャフォルドを上書き
claude plugin init my-helper --force
```

<h3 id="plugin-install">
  plugin install
</h3>

利用可能なマーケットプレイスからプラグインをインストールします。

```bash theme={null}
claude plugin install <plugin> [options]
```

コマンドは以下の引数を取ります:

* `<plugin>`: プラグイン名、または特定のマーケットプレイス用の `plugin-name@marketplace-name`

コマンドは以下のオプションを受け入れます:

| オプション                  | 説明                                                                                                                                                                                                                                                                                                                                                                                       | デフォルト  |
| :--------------------- | :--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :----- |
| `-s, --scope <scope>`  | インストールスコープ: `user`、`project`、または `local`                                                                                                                                                                                                                                                                                                                                                 | `user` |
| `--config <key=value>` | プラグインのマニフェストで宣言された[`userConfig`](#user-configuration)オプションを設定します。複数のオプションを設定するにはフラグを繰り返します                                                                                                                                                                                                                                                                                               |        |
| `-y, --yes`            | 確認プロンプトなしで、プラグインのマーケットプレイスが宣言するコマンドを受け入れます: [`command` ソース](/docs/ja/plugin-marketplaces#command-sources)を持つプラグインを生成するコマンド、またはアーカイブダウンロードを認証する[`headersHelper`](/docs/ja/plugin-marketplaces#authenticate-archive-downloads)。`headersHelper` を受け入れるには Claude Code v2.1.238 以降が必要です。Claude Code はまずコマンドを出力します。stdin または stdout が TTY でない場合は必須です。Claude Code セッション内では効果がないため、独自のターミナルからコマンドを実行してください |        |
| `--json`               | 結果を stdout の最後の行に 1 つの JSON オブジェクトとして出力します。スクリプトで使用するための人間が読める形式の代わりに。[JSON 結果形式](#plugin-json-result)を参照してください。Claude Code v2.1.268 以降が必須です                                                                                                                                                                                                                                             |        |
| `-h, --help`           | コマンドのヘルプを表示                                                                                                                                                                                                                                                                                                                                                                              |        |

スコープは、インストールされたプラグインが追加される設定ファイルを決定します。たとえば、`--scope project` は .claude/settings.json の `enabledPlugins` に書き込み、プロジェクトリポジトリをクローンした全員がプラグインを利用できるようにします。

<span id="plugin-json-result" />`--json` を使用すると、stdout の最後の行は 1 つの JSON オブジェクトです。マーケットプレイスが宣言するコマンドが前に出力される可能性があるため、その行のみを解析してください。3 つのフィールドは常に存在します:

* `command`: 実行されたサブコマンド（`install` など）
* `outcome`: `ok` または `failed`
* `message`: 結果の人間が読める説明

`pluginId`、`scope`、`failureCode` などの他のフィールドは、適用される場合にのみ表示されます。`plugin uninstall`、`plugin update`、`plugin enable`、および `plugin disable` の `--json` オプションは、そのサブコマンド独自のフィールドを持つ同じオブジェクトを出力します。`--scope` が無効な場合などの使用エラーは、結果行を出力せず、終了コード 1 で理由を stderr に出力します。

これらの例は一般的な呼び出しを示しています:

```bash theme={null}
# ユーザースコープにインストール（デフォルト）
claude plugin install formatter@my-marketplace

# プロジェクトスコープにインストール（チームと共有）
claude plugin install formatter@my-marketplace --scope project

# ローカルスコープにインストール（チームと共有しない）
claude plugin install formatter@my-marketplace --scope local
```

<h3 id="plugin-uninstall">
  plugin uninstall
</h3>

インストール済みプラグインを削除します。

```bash theme={null}
claude plugin uninstall <plugin> [options]
```

コマンドは以下の引数を取ります:

* `<plugin>`: プラグイン名、または `plugin-name@marketplace-name`

コマンドは以下のオプションを受け入れます:

| オプション                 | 説明                                                                                                                                                     | デフォルト  |
| :-------------------- | :----------------------------------------------------------------------------------------------------------------------------------------------------- | :----- |
| `-s, --scope <scope>` | スコープからアンインストール: `user`、`project`、または `local`                                                                                                           | `user` |
| `--keep-data`         | プラグインの[永続データディレクトリ](#persistent-data-directory)を保持します                                                                                                  |        |
| `--prune`             | 他のプラグインが必要としない自動インストール依存関係も削除します。[plugin prune](#plugin-prune) を参照                                                                                     |        |
| `-y, --yes`           | `--prune` 確認プロンプトをスキップします。stdin または stdout が TTY でない場合は必須                                                                                              |        |
| `--json`              | 結果を stdout の最後の行に 1 つの JSON オブジェクトとして出力します。[`plugin install --json`](#plugin-json-result)と同じ形式で。`--prune` と組み合わせることはできません。Claude Code v2.1.268 以降が必須です |        |
| `-h, --help`          | コマンドのヘルプを表示                                                                                                                                            |        |

`claude plugin remove` と `claude plugin rm` はこのコマンドのエイリアスです。

デフォルトでは、最後に残ったスコープからアンインストールすると、プラグインの `${CLAUDE_PLUGIN_DATA}` ディレクトリも削除されます。新しいバージョンをテストした後に再インストールする場合など、保持するには `--keep-data` を使用します。

<Note>
  異なるマーケットプレイスからインストールされたプラグインが同じ名前を共有する場合、`plugin-name@marketplace-name` 形式は指定されたマーケットプレイスからのプラグインのみをアンインストールします。v2.1.212 より前は、修飾形式は異なるマーケットプレイスから同じ名前のプラグインにマッチしてアンインストールする可能性がありました。
</Note>

<h3 id="plugin-prune">
  plugin prune
</h3>

インストール済みプラグインによって不要になった自動インストール依存関係を削除します。Claude Code が別のプラグインの[`dependencies`](/docs/ja/plugin-dependencies)フィールドを満たすために取得した依存関係は削除されます。直接インストールしたプラグインは決して削除されません。

```bash theme={null}
claude plugin prune [options]
```

コマンドは以下のオプションを受け入れます:

| オプション                 | 説明                                              | デフォルト  |
| :-------------------- | :---------------------------------------------- | :----- |
| `-s, --scope <scope>` | スコープでプルーン: `user`、`project`、または `local`         | `user` |
| `--dry-run`           | 削除せずに削除されるものをリストします                             |        |
| `-y, --yes`           | 確認プロンプトをスキップします。stdin または stdout が TTY でない場合は必須 |        |
| `-h, --help`          | コマンドのヘルプを表示                                     |        |

`claude plugin autoremove` はこのコマンドのエイリアスです。

コマンドは孤立した依存関係をリストし、削除前に確認を求めます。プラグインを削除し、その依存関係をワンステップでクリーンアップするには、`claude plugin uninstall <plugin> --prune` を実行します。

<h3 id="plugin-enable">
  plugin enable
</h3>

無効なプラグインを有効にします。ターゲットがマーケットプレイスからインストールされ、[依存関係](/docs/ja/plugin-dependencies)を宣言している場合、Claude Code は同じスコープで推移的にそれらを有効にします。コマンドは[依存関係を持つプラグインを有効または無効にする](/docs/ja/plugin-dependencies#enable-or-disable-a-plugin-with-dependencies)がリストする条件下で失敗します。

```bash theme={null}
claude plugin enable <plugin> [options]
```

コマンドは以下の引数を取ります:

* `<plugin>`: プラグイン名、または `plugin-name@marketplace-name`

コマンドは以下のオプションを受け入れます:

| オプション                 | 説明                                                                                                                           | デフォルト |
| :-------------------- | :--------------------------------------------------------------------------------------------------------------------------- | :---- |
| `-s, --scope <scope>` | 有効にするスコープ: `user`、`project`、または `local`。省略した場合、Claude Code はプラグインがインストールされているスコープを検出します                                      | 自動検出  |
| `--json`              | 結果を stdout の最後の行に 1 つの JSON オブジェクトとして出力します。[`plugin install --json`](#plugin-json-result)と同じ形式で。Claude Code v2.1.268 以降が必須です |       |
| `-h, --help`          | コマンドのヘルプを表示                                                                                                                  |       |

<h3 id="plugin-disable">
  plugin disable
</h3>

プラグインをアンインストールせずに無効にします。ターゲットがマーケットプレイスからインストールされている場合、別の有効なプラグインが[それに依存](/docs/ja/plugin-dependencies#enable-or-disable-a-plugin-with-dependencies)している場合、コマンドは失敗します。エラーメッセージには、最初にすべての依存プラグインを無効にするチェーンコマンドが含まれます。

```bash theme={null}
claude plugin disable [plugin] [options]
```

コマンドは以下の引数を取ります:

* `[plugin]`: プラグイン名、または `plugin-name@marketplace-name`。`--all` を使用する場合はオプション

コマンドは以下のオプションを受け入れます:

| オプション                 | 説明                                                                                                                           | デフォルト |
| :-------------------- | :--------------------------------------------------------------------------------------------------------------------------- | :---- |
| `-a, --all`           | すべての有効なプラグインを無効にします。`--scope` と組み合わせることはできません                                                                                |       |
| `-s, --scope <scope>` | 無効にするスコープ: `user`、`project`、または `local`。省略した場合、Claude Code はプラグインがインストールされているスコープを検出します                                      | 自動検出  |
| `--json`              | 結果を stdout の最後の行に 1 つの JSON オブジェクトとして出力します。[`plugin install --json`](#plugin-json-result)と同じ形式で。Claude Code v2.1.268 以降が必須です |       |
| `-h, --help`          | コマンドのヘルプを表示                                                                                                                  |       |

<h3 id="plugin-update">
  plugin update
</h3>

プラグインを最新バージョンに更新します。

```bash theme={null}
claude plugin update <plugin> [options]
```

コマンドは以下の引数を取ります:

* `<plugin>`: プラグイン名、または `plugin-name@marketplace-name`

コマンドは以下のオプションを受け入れます:

| オプション                 | 説明                                                                                                                                                                                                                                                                                                                                                                                       | デフォルト  |
| :-------------------- | :--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :----- |
| `-s, --scope <scope>` | 更新するスコープ: `user`、`project`、`local`、または `managed`                                                                                                                                                                                                                                                                                                                                         | `user` |
| `-y, --yes`           | 確認プロンプトなしで、プラグインのマーケットプレイスが宣言するコマンドを受け入れます: [`command` ソース](/docs/ja/plugin-marketplaces#command-sources)を持つプラグインを生成するコマンド、またはアーカイブダウンロードを認証する[`headersHelper`](/docs/ja/plugin-marketplaces#authenticate-archive-downloads)。`headersHelper` を受け入れるには Claude Code v2.1.238 以降が必要です。Claude Code はまずコマンドを出力します。stdin または stdout が TTY でない場合は必須です。Claude Code セッション内では効果がないため、独自のターミナルからコマンドを実行してください |        |
| `--json`              | 結果を stdout の最後の行に 1 つの JSON オブジェクトとして出力します。[`plugin install --json`](#plugin-json-result)と同じ形式で。Claude Code v2.1.268 以降が必須です                                                                                                                                                                                                                                                             |        |
| `-h, --help`          | コマンドのヘルプを表示                                                                                                                                                                                                                                                                                                                                                                              |        |

<Note>
  Claude Code は、インストール済みプラグインに対して修飾されていないプラグイン名を解決します。異なるマーケットプレイスからインストールされたプラグインが名前を共有する場合、Claude Code は更新を拒否し、代わりに実行する修飾 `plugin-name@marketplace-name` コマンドをリストします。v2.1.246 より前は、Claude Code は修飾形式のみを受け入れ、修飾されていない名前を見つからないものとして拒否していました。
</Note>

***

<h3 id="plugin-list">
  plugin list
</h3>

インストール済みプラグインをバージョン、ソースマーケットプレイス、および有効状態と共にリストします。

```bash theme={null}
claude plugin list [options]
```

コマンドは以下のオプションを受け入れます:

| オプション         | 説明                                                                                                                                                                                                          | デフォルト |
| :------------ | :---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :---- |
| `--json`      | JSON として出力します。読み込み問題またはオーサリング警告を含むプラグイン行は `errors` または `notes` 文字列配列を含みます。Claude Code v2.1.268 以降では、並列 `errorDetails` および `noteDetails` 配列は各エントリの診断 `type` と、プラグイン、マーケットプレイス、サーバー、またはファイルなど、それが参照する名前を提供します |       |
| `--available` | マーケットプレイスから利用可能なプラグインを含めます。`--json` が必須                                                                                                                                                                     |       |
| `-h, --help`  | コマンドのヘルプを表示                                                                                                                                                                                                 |       |

対話的セッション内では、`/plugin list` は同様のリストをインラインで出力しますが、マーケットプレイスからインストールされたプラグインのみをカバーします:

* スキルディレクトリから読み込まれたプラグインは `/plugin` インターフェイスと `claude plugin list` に表示されますが、インラインの `/plugin list` 出力には表示されません。
* Claude Code v2.1.239 以降では、[claude.ai から同期されたプラグイン](#synced-plugins)は、同期されたセッションがそれらをダウンロードした環境で `claude plugin list` を実行するときに表示されます。インラインの `/plugin list` 出力には表示されません。
* `--plugin-dir` または `--plugin-url` でセッション用に読み込まれたプラグインは `/plugin` インターフェイスに表示され、`claude --plugin-dir <dir> plugin list` のように同じフラグがサブコマンドの前にある場合にのみ `claude plugin list` に表示されます。フラグ名のみがそれらの場所を指定するため、修飾されていない `claude plugin list` は同期されたプラグインとスキルディレクトリプラグインとは異なり、Claude Code がスキャンする固定ディレクトリを持たないため、それらを見つけることができません。

対話的形式は、`--enabled` または `--disabled` を受け入れてそのスタイルのプラグインのみを表示し、`ls` を `list` の短縮形として受け入れます。

<h3 id="plugin-details">
  plugin details
</h3>

プラグインのコンポーネント在庫と予想トークンコストを表示します。出力は、プラグインが提供するすべてのコンポーネントをスキル、エージェント、フック、MCP サーバー、および LSP サーバーとしてグループ化し、各セッションに追加するトークン数の推定値を含めてリストします。スキルグループには `skills/` と `commands/` エントリの両方が含まれます。

```bash theme={null}
claude plugin details <name>
```

コマンドは以下の引数を取ります:

* `<name>`: プラグイン名、または `plugin-name@marketplace-name`

コマンドは以下のオプションを受け入れます:

| オプション        | 説明          | デフォルト |
| :----------- | :---------- | :---- |
| `-h, --help` | コマンドのヘルプを表示 |       |

出力は各コンポーネントの 2 つのコスト数値を表示します:

* **常時オン:** スキル説明、エージェント説明、コマンド名など、プラグインのリストテキストによってすべてのセッションに追加されるトークン。コンポーネントが発火するかどうかに関係なく。
* **呼び出し時:** コンポーネントが発火するときにコンポーネントがコストするトークン。プラグイン全体ではなくコンポーネントごとに表示されます。典型的なセッションはコンポーネントのサブセットのみを呼び出すため。

この例は、2 つのスキルを持つプラグインの出力がどのように見えるかを示しています:

```
dependency-guard 1.2.0
  Dependency analysis for Claude Code sessions
  Source: dependency-guard@example-marketplace

Component inventory
  Skills (2)  scan-dependencies, review-changes
  Agents (0)
  Hooks (1)  SessionStart  (harness-only — no model context cost)
  MCP servers (0)
  LSP servers (0)

Projected token cost
  Always-on:   ~180 tok   added to every session

Per-component (rounded)
  component            always-on  on-invoke
  scan-dependencies        ~100      ~2400
  review-changes            ~80      ~1800

  On-invoke cost is paid each time a skill or agent fires.
  Token counts are estimates and may differ from actual usage.
```

常時オンの合計は、アクティブなモデルの `count_tokens` API を介して計算されます。コンポーネントごとの数値はその合計から比例的にスケーリングされます。API に到達できない場合、コマンドは文字ベースの推定値にフォールバックします。

<h3 id="plugin-validate">
  plugin validate
</h3>

公開前にプラグインまたはマーケットプレイスの構文とスキーマエラーをチェックします。

検証が成功すると終了コード 0、失敗すると 1、検証実行自体が失敗した場合（渡したパスが読み取り不可能な場合など）は 2 で終了します。

```bash theme={null}
claude plugin validate <path> [options]
```

コマンドは以下の引数を取ります:

* `<path>`: プラグインディレクトリまたはマーケットプレイスディレクトリへのパス。プラグイン実行がカバーするファイルについては、[マニフェストなしでプラグインまたはディレクトリを検証](/docs/ja/plugin-marketplaces#validate-a-plugin-or-a-directory-without-a-manifest)を参照してください。

コマンドは以下のオプションを受け入れます:

| オプション        | 説明                                                                                                 | デフォルト |
| :----------- | :------------------------------------------------------------------------------------------------- | :---- |
| `--strict`   | 警告をエラーとして扱い、それらで終了コード 1 で終了します。CI で使用して、[認識されないフィールド](#unrecognized-fields)など、ランタイムが許容する問題をキャッチします |       |
| `--json`     | 検証レポートを同じ終了コードを持つ 1 つの JSON オブジェクトとして出力します。Claude Code v2.1.259 以降が必須                              |       |
| `-h, --help` | コマンドのヘルプを表示                                                                                        |       |

`--json` を使用すると、Claude Code はレポートを stdout に 1 つの JSON オブジェクトとして書き込み、これらのトップレベルフィールドを持ちます:

* `success`: 終了コードが与える同じ判定
* `strict`: 実行が警告をエラーとして扱ったかどうか
* `target`: Claude Code が検証した解決されたパス
* `manifest`: マニフェスト自体の結果、または[マニフェストなしの実行](/docs/ja/plugin-marketplaces#validate-a-plugin-or-a-directory-without-a-manifest)の場合は `null`
* `contents`: ファイルごとの結果。各結果は `file` を指定し、`errors`、`warnings`、および `notes` 配列を含みます

終了コード 2 では、コマンドは stdout に何も書き込みません。エラーメッセージは stderr に送られます。

対話的セッション内では、`/plugin validate <path>` は同じチェックをインラインで実行します。

<h3 id="plugin-eval">
  plugin eval
</h3>

プラグインの[eval ケース](/docs/ja/plugin-evals)を実行し、スコア付き結果をレポートします。Claude Code v2.1.269 以降が必須です。各ケースはプロンプトとグレーダーです。Claude Code はターゲットプラグインのみが読み込まれた分離されたセッションで複数回実行し、デフォルトではプラグインなしでも実行するため、レポートは差を示します。ケース形式、グレーダー、結果、および CI 使用については、[プラグインを eval でテストする](/docs/ja/plugin-evals)を参照してください。

```bash theme={null}
claude plugin eval [target] [options]
```

オプションの `target` は、プラグインディレクトリ、単一の `prompt.md` または `case.yaml` ファイル、`name` または `name@marketplace` としてインストールされたプラグイン、または `name@skills-dir` であり、デフォルトは現在のディレクトリです。`--tag`、`--allow-tools`、および `--json` の前に配置します。

このテーブルは、ほとんどの実行が使用するオプションをリストします。`claude plugin eval --help` を実行して、`--case`、`--tag`、`--output-dir`、`--report`、`--allow-real-servers`、`--keep-temp`、および `--verbose` を含む完全なセットを確認してください。

| オプション                      | 説明                                                                                                                                  | デフォルト                                                                        |
| :------------------------- | :---------------------------------------------------------------------------------------------------------------------------------- | :--------------------------------------------------------------------------- |
| `--runs <n>`               | アーム当たりケース当たりの実行                                                                                                                     | 各ケースの `runs`、それ以外は 3                                                         |
| `-j, --concurrency <n>`    | 一度に実行するエージェントセッション、1 から 8。レート制限を共有します                                                                                               | `1`                                                                          |
| `--model <model>`          | テスト対象のエージェント用モデル                                                                                                                    | 各ケースの `model`、それ以外は `ANTHROPIC_MODEL` が設定されている場合はそれ、それ以外は Claude Code のデフォルト |
| `--judge-model <model>`    | `llm` および `baseline` グレーダー用モデル                                                                                                      | 小さく高速なモデル                                                                    |
| `--ablation <mode>`        | `none` または `with-without`。[プラグインなしベースラインと比較する](/docs/ja/plugin-evals#compare-against-a-no-plugin-baseline)を参照                            | プラグインが解決される場合は `with-without`、それ以外は `none`                                   |
| `--threshold <0..1>`       | いずれかのケースがこれ以下でスコアされた場合は終了コード 1                                                                                                      | `1.0`                                                                        |
| `--max-cost-usd <usd>`     | 支出がこれに達したら次の実行前に停止し、終了コード 2 を返し、部分的な結果をレポート                                                                                         | 上限なし                                                                         |
| `--allow-tools <tools...>` | `Bash`、`Write`、`Edit`、または `"mcp__plugin_<plugin>_<server>__*"` など、読み取り専用セット以外のツールを付与します。[ツールを付与する](/docs/ja/plugin-evals#grant-tools)を参照 |                                                                              |
| `--scaffold`               | 各ケースの[`scaffold_script`](/docs/ja/plugin-evals#add-setup-or-history-with-case-yaml)を実行                                                   | オフ                                                                           |
| `--trust-plugin`           | 最初の実行信頼プロンプトをスキップします。CI 用。[実行がアクセスできるもの](/docs/ja/plugin-evals#security)を参照                                                              | オフ                                                                           |
| `--mocks <mode>`           | `record` または `off`。[MCP サーバーをモック](/docs/ja/plugin-evals#mock-mcp-servers)を参照                                                             | `record`                                                                     |
| `--eval-dir <dir>`         | ケースを保持するプラグイン下のディレクトリ                                                                                                               | マニフェストの `experimental.evals`、それ以外は `evals`                                   |
| `--json [path]`            | [結果ドキュメント](/docs/ja/plugin-evals#json-result)を stdout に出力するか、`.json` パスに書き込み                                                             |                                                                              |
| `--no-publish`             | HTML レポートをローカルに保持                                                                                                                   |                                                                              |
| `-h, --help`               | コマンドのヘルプを表示                                                                                                                         |                                                                              |

コマンドは、すべてのケースがしきい値を満たす場合は終了コード 0、失敗したケース、読み込みエラー、または信頼されていないプラグインディレクトリの場合は 1、部分的な実行の場合は 2、中断された場合は 130、終了された場合は 143 で終了します。[CI で eval を実行する](/docs/ja/plugin-evals#run-evals-in-ci)を参照してください。

<h3 id="plugin-eval-init">
  plugin eval init
</h3>

現在のディレクトリのプラグイン用の eval スイートを作成します。Claude Code v2.1.269 以降が必須です。ターミナルでは、これはプラグインを読み取り、ケースとグレーダーを提案し、それらをパイロットし、ファイルを書き込むオーサリングインタビューを開始します。`--bare` を使用するか、ターミナルなしで、代わりに空白の単一ケーステンプレートを書き込みます。対話的な Claude Code セッション内から実行すると、そのセッションが従うべきインタビュー指示を出力します。[最初の eval スイートを作成する](/docs/ja/plugin-evals#create-your-first-eval-suite)を参照してください。

```bash theme={null}
claude plugin eval init [name] [options]
```

オプションの `name` はケース名です: インタビューは 1 つを必要としませんが、`--bare` とターミナルなしテンプレートパスはそれを必要とします。これらのオプションを受け入れます:

| オプション               | 説明                                                          | デフォルト                                      |
| :------------------ | :---------------------------------------------------------- | :----------------------------------------- |
| `--bare`            | `<name>` の代わりに空白の `prompt.md` と `graders/criteria.md` を書き込み |                                            |
| `-i, --interactive` | インタビューを必須にします。テンプレートを書き込む代わりにターミナルなしで失敗                     |                                            |
| `--eval-dir <dir>`  | ケースを書き込む現在のディレクトリ下のディレクトリ                                   | マニフェストの `experimental.evals`、それ以外は `evals` |
| `-h, --help`        | コマンドのヘルプを表示                                                 |                                            |

<h3 id="plugin-tag">
  plugin tag
</h3>

プラグインのリリース git タグを作成します。デフォルトではコマンドは現在のディレクトリのプラグインにタグを付けます。別の場所のプラグインにタグを付けるにはパスを渡します。[プラグインリリースにタグを付ける](/docs/ja/plugin-dependencies#tag-plugin-releases-for-version-resolution)を参照してください。

```bash theme={null}
claude plugin tag [path] [options]
```

コマンドは以下の引数を取ります:

* `[path]`: プラグインディレクトリへのパス。デフォルトは現在のディレクトリです。

コマンドは以下のオプションを受け入れます:

| オプション                 | 説明                                           | デフォルト    |
| :-------------------- | :------------------------------------------- | :------- |
| `--push`              | タグを作成した後、リモートにプッシュします                        |          |
| `--dry-run`           | タグを作成せずにタグ付けされるものを出力します                      |          |
| `-f, --force`         | ワーキングツリーがダーティであるか、タグが既に存在する場合でもタグを作成します      |          |
| `-m, --message <msg>` | タグアノテーションメッセージ。バージョンのプレースホルダーとして `%s` を使用します |          |
| `--remote <name>`     | `--push` でプッシュするリモート                         | `origin` |
| `-h, --help`          | コマンドのヘルプを表示                                  |          |

***

<h2 id="debugging-and-development-tools">
  デバッグと開発ツール
</h2>

<h3 id="debugging-commands">
  デバッグコマンド
</h3>

`claude --debug` を使用してプラグインの読み込み詳細を確認します：

これにより以下が表示されます：

* どのプラグインが読み込まれているか
* プラグインマニフェストのエラー
* Skill、agent、hook の登録
* MCP サーバーの初期化

<h3 id="common-issues">
  よくある問題
</h3>

| 問題                                  | 原因                              | 解決策                                                                                                                                                                                                                                                                                                                                                     |
| :---------------------------------- | :------------------------------ | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| プラグインが読み込まれない                       | 無効な `plugin.json`               | `claude plugin validate ./my-plugin` または `/plugin validate ./my-plugin` を実行します。ここで `./my-plugin` はプラグインディレクトリです。`plugin.json`、`hooks/hooks.json`、およびプラグインのデフォルトディレクトリ内の skill、agent、command のフロントマターの構文とスキーマエラーをチェックします。実行内容については [プラグインまたはマニフェストなしのディレクトリを検証する](/docs/ja/plugin-marketplaces#validate-a-plugin-or-a-directory-without-a-manifest) を参照してください |
| Skill が表示されない                       | ディレクトリ構造が間違っている                 | `skills/` または `commands/` がプラグインルートにあることを確認します。`.claude-plugin/` 内にはありません                                                                                                                                                                                                                                                                               |
| Hook が発火しない                         | スクリプトが実行可能でない                   | `chmod +x script.sh` を実行します                                                                                                                                                                                                                                                                                                                             |
| MCP サーバーが失敗する                       | `${CLAUDE_PLUGIN_ROOT}` が見つからない | すべてのプラグインパスに変数を使用します                                                                                                                                                                                                                                                                                                                                    |
| パスエラー                               | 絶対パスが使用されている                    | パスを相対パスにします。`./` で始まります。[パス動作ルール](#path-behavior-rules) を参照してください。これは `skills` フィールドの `"."` 例外をカバーしています                                                                                                                                                                                                                                                 |
| LSP `Executable not found in $PATH` | 言語サーバーがインストールされていない             | バイナリをインストールします（例：`npm install -g typescript-language-server typescript`）                                                                                                                                                                                                                                                                                |

<h3 id="example-error-messages">
  エラーメッセージの例
</h3>

**マニフェスト検証エラー**：

* `Invalid JSON syntax: Unexpected token } in JSON at position 142`：コンマの欠落、余分なコンマ、またはクォートされていない文字列がないか確認してください
* `Plugin <name> has an invalid manifest file at .claude-plugin/plugin.json. Validation errors: name: Invalid input: expected string, received undefined`：必須フィールドが見つかりません
* `Plugin <name> has a corrupt manifest file at .claude-plugin/plugin.json. JSON parse error: ...`：JSON 構文エラー。v2.1.246 より前では、Claude Code は UTF-8 で保存され、バイト順マーク（BOM）が先頭にある `plugin.json` に対してもこのエラーを生成していました。JSON が有効な場合でも同様です。

**プラグイン読み込みエラー**：

* `Warning: No commands found in plugin my-plugin custom directory: ./cmds. Expected .md files or SKILL.md in subdirectories.`：コマンドパスは存在しますが、有効なコマンドファイルが含まれていません
* `Plugin directory not found at path: ./plugins/my-plugin. Check that the marketplace entry has the correct path.`：marketplace.json の `source` パスが存在しないディレクトリを指しています
* `Plugin my-plugin has conflicting manifests: both plugin.json and marketplace entry specify components.`：重複するコンポーネント定義を削除するか、marketplace エントリから `strict: false` を削除します

<h3 id="hook-troubleshooting">
  Hook のトラブルシューティング
</h3>

**Hook スクリプトが実行されない**：

1. スクリプトが実行可能であることを確認します：`chmod +x ./scripts/your-script.sh`
2. shebang 行を確認します：最初の行は `#!/bin/bash` または `#!/usr/bin/env bash` である必要があります
3. パスが `${CLAUDE_PLUGIN_ROOT}` を使用していることを確認します：`"command": "\"${CLAUDE_PLUGIN_ROOT}\"/scripts/your-script.sh"`
4. スクリプトを手動でテストします：`./scripts/your-script.sh`

**Hook が予期されたイベントでトリガーされない**：

1. イベント名が正しいことを確認します（大文字と小文字を区別）：`postToolUse` ではなく `PostToolUse`
2. マッチャーパターンがツールと一致することを確認します：ファイル操作の場合は `"matcher": "Write|Edit"`
3. hook タイプが有効であることを確認します：`command`、`http`、`mcp_tool`、`prompt`、または `agent`

<h3 id="mcp-server-troubleshooting">
  MCP サーバーのトラブルシューティング
</h3>

**サーバーが起動しない**：

1. コマンドが存在し、実行可能であることを確認します
2. すべてのパスが `${CLAUDE_PLUGIN_ROOT}` 変数を使用していることを確認します
3. MCP サーバーログを確認します：`claude --debug` は初期化エラーを表示します
4. Claude Code の外部でサーバーを手動でテストします

**サーバーツールが表示されない**：

1. サーバーが `.mcp.json` または `plugin.json` で正しく設定されていることを確認します
2. サーバーが MCP プロトコルを正しく実装していることを確認します
3. デバッグ出力で接続タイムアウトを確認します

<h3 id="directory-structure-mistakes">
  ディレクトリ構造の間違い
</h3>

**症状**：プラグインは読み込まれますが、コンポーネント（skill、agent、hook）が見つかりません。

**正しい構造**：コンポーネントはプラグインルートにある必要があります。`.claude-plugin/` 内にはありません。`plugin.json` のみが `.claude-plugin/` に属します。

**デバッグチェックリスト**：

1. `claude --debug` を実行し、「loading plugin」メッセージを探します
2. 各コンポーネントディレクトリがデバッグ出力に表示されていることを確認します
3. ファイルのアクセス許可がプラグインファイルの読み取りを許可していることを確認します

***

<h2 id="distribution-and-versioning-reference">
  配布とバージョン管理リファレンス
</h2>

<h3 id="version-management">
  バージョン管理
</h3>

Claude Code はプラグインのバージョンをキャッシュキーとして使用し、アップデートが利用可能かどうかを判断します。`/plugin update` を実行するか自動アップデートが実行されると、Claude Code は現在のバージョンを計算し、既にインストールされているものと一致する場合はアップデートをスキップします。

`command` 以外のすべてのソースタイプについて、Claude Code は以下の最初に設定されたものからバージョンを解決します。

1. プラグインの `plugin.json` の `version` フィールド
2. `marketplace.json` のプラグインのマーケットプレイスエントリの `version` フィールド
3. git ホストマーケットプレイス内の `github`、`url`、`git-subdir`、および相対パスソースのプラグインの git コミット SHA
4. [`archive` ソース](/docs/ja/plugin-marketplaces#zip-archives)の SHA-256 ダイジェスト。マーケットプレイスエントリの `sha256` ピン、またはピンを設定しない場合はダウンロードされたファイルのダイジェスト。Claude Code はこれを最初の 12 文字に短縮します
5. `npm` ソースまたは git リポジトリ内にないローカルディレクトリの場合は `unknown`

[`command` ソース](/docs/ja/plugin-marketplaces#command-sources)の場合、Claude Code は常にコマンドが生成したものからバージョンを導出します。単独の 12 文字のコンテンツハッシュ、または 1 つが設定されている場合は `plugin.json` バージョンに `<version>-<hash>` として追加されます。Claude Code はコマンドソースのマーケットプレイスエントリの `version` フィールドを無視します。ハッシュされた出力が変更されるコマンドは、作成されたバージョン文字列が同じままでも、新しいバージョンを生成します。[リンクモード](/docs/ja/plugin-marketplaces#copy-mode-and-link-mode)では、ハッシュはファイルコンテンツではなく、印刷されたディレクトリの実際のパスとそのトップレベルエントリをカバーします。

これらのソースタイプについて、プラグインをバージョン管理する 3 つの方法があります。

| アプローチ              | 方法                                                                                                        | アップデート動作                                                                                             | 最適な用途                                         |
| :----------------- | :-------------------------------------------------------------------------------------------------------- | :--------------------------------------------------------------------------------------------------- | :-------------------------------------------- |
| **明示的なバージョン**      | `plugin.json` で `"version": "2.1.0"` を設定                                                                  | ユーザーはこのフィールドをバンプした場合のみアップデートを取得します。バンプせずに新しいコミットをプッシュしても効果がなく、`/plugin update` は「既に最新バージョンです」と報告します。 | 安定したリリースサイクルを持つ公開プラグイン                        |
| **コミット SHA バージョン** | `plugin.json` とマーケットプレイスエントリの両方から `version` を省略                                                           | ユーザーはソースの解決されたコミットが変更されるたびにアップデートを取得します                                                              | アクティブに開発中の内部またはチームプラグイン                       |
| **ダイジェストバージョン**    | [`archive` ソース](/docs/ja/plugin-marketplaces#zip-archives)を使用し、`plugin.json` とマーケットプレイスエントリの両方から `version` を省略 | `sha256` ピンを使用する場合、ユーザーはピンを変更するとアップデートを取得します。ピンがない場合、ユーザーはホストされている zip ファイルのバイトが変更されるたびにアップデートを取得します | 静的サーバーまたはアーティファクトリポジトリに zip ファイルとして公開されるプラグイン |

明示的なバージョンを使用する場合は、[セマンティックバージョニング](https://semver.org)（`MAJOR.MINOR.PATCH`）に従ってください。破壊的な変更の場合は MAJOR をバンプし、新機能の場合は MINOR をバンプし、バグ修正の場合は PATCH をバンプします。`CHANGELOG.md` で変更を文書化します。

***

<h2 id="see-also">
  関連項目
</h2>

* [プラグイン](/docs/ja/plugins) - チュートリアルと実践的な使用法
* [プラグインマーケットプレイス](/docs/ja/plugin-marketplaces) - マーケットプレイスの作成と管理
* [Skills](/docs/ja/skills) - Skill 開発の詳細
* [Subagents](/docs/ja/sub-agents) - エージェント設定と機能
* [Hooks](/docs/ja/hooks) - イベント処理と自動化
* [MCP](/docs/ja/mcp) - 外部ツール統合
* [設定](/docs/ja/settings) - プラグインの設定オプション
