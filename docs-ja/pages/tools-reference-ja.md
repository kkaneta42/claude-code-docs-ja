> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# ツール リファレンス

> Claude Code が使用できるツールの完全なリファレンス（権限要件とツール別の動作を含む）

Claude Code は、コードベースを理解および変更するのに役立つ組み込みツールのセットにアクセスできます。ツール名は、[権限ルール](/ja/permissions#tool-specific-permission-rules)、[subagent ツールリスト](/ja/sub-agents)、および[フック マッチャー](/ja/hooks)で使用する正確な文字列です。ツールを完全に無効にするには、[権限設定](/ja/permissions#tool-specific-permission-rules)の `deny` 配列にその名前を追加します。

カスタム ツールを追加するには、[MCP サーバー](/ja/mcp)を接続します。再利用可能なプロンプトベースのワークフローで Claude を拡張するには、[skill](/ja/skills)を作成します。これは新しいツール エントリを追加するのではなく、既存の `Skill` ツールを通じて実行されます。

| ツール                    | 説明                                                                                                                                                                                                                                                                                                                              | 権限が必要 |
| :--------------------- | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | :---- |
| `Agent`                | 独自のコンテキストウィンドウを持つ [subagent](/ja/sub-agents)を生成してタスクを処理します。[Agent ツールの動作](#agent-tool-behavior)を参照してください                                                                                                                                                                                                                        | いいえ   |
| `AskUserQuestion`      | 要件を収集したり曖昧さを明確にするために複数選択肢の質問をします                                                                                                                                                                                                                                                                                                | いいえ   |
| `Bash`                 | 環境でシェル コマンドを実行します。[Bash ツールの動作](#bash-tool-behavior)を参照してください                                                                                                                                                                                                                                                                   | はい    |
| `CronCreate`           | 現在のセッション内で定期的または 1 回限りのプロンプトをスケジュールします。タスクはセッションスコープであり、`--resume` または `--continue` で復元されます（有効期限が切れていない場合）。[スケジュール済みタスク](/ja/scheduled-tasks)を参照してください                                                                                                                                                                          | いいえ   |
| `CronDelete`           | ID でスケジュール済みタスクをキャンセルします                                                                                                                                                                                                                                                                                                        | いいえ   |
| `CronList`             | セッション内のすべてのスケジュール済みタスクをリストします                                                                                                                                                                                                                                                                                                   | いいえ   |
| `Edit`                 | 特定のファイルに対して対象を絞った編集を行います。[Edit ツールの動作](#edit-tool-behavior)を参照してください                                                                                                                                                                                                                                                            | はい    |
| `EnterPlanMode`        | Plan Mode に切り替えてコーディング前にアプローチを設計します                                                                                                                                                                                                                                                                                             | いいえ   |
| `EnterWorktree`        | 分離された [git worktree](/ja/worktrees)を作成してそこに切り替えます。現在のリポジトリの既存の worktree に切り替えるには、新しいものを作成する代わりに `path` を渡します。Subagent では利用できません                                                                                                                                                                                                 | いいえ   |
| `ExitPlanMode`         | 承認用のプランを提示して Plan Mode を終了します                                                                                                                                                                                                                                                                                                   | はい    |
| `ExitWorktree`         | worktree セッションを終了して元のディレクトリに戻ります。Subagent では利用できません                                                                                                                                                                                                                                                                             | いいえ   |
| `Glob`                 | パターン マッチングに基づいてファイルを検索します。[Glob ツールの動作](#glob-tool-behavior)を参照してください                                                                                                                                                                                                                                                           | いいえ   |
| `Grep`                 | ファイル コンテンツ内のパターンを検索します。[Grep ツールの動作](#grep-tool-behavior)を参照してください                                                                                                                                                                                                                                                              | いいえ   |
| `ListMcpResourcesTool` | 接続された [MCP servers](/ja/mcp)によって公開されたリソースをリストします                                                                                                                                                                                                                                                                                | いいえ   |
| `LSP`                  | 言語サーバー経由のコード インテリジェンス：定義へのジャンプ、参照の検索、型エラーと警告の報告。[LSP ツールの動作](#lsp-tool-behavior)を参照してください                                                                                                                                                                                                                                       | いいえ   |
| `Monitor`              | コマンドをバックグラウンドで実行し、各出力行を Claude にフィードバックするため、会話の途中でログ エントリ、ファイル変更、またはポーリング ステータスに対応できます。[Monitor ツール](#monitor-tool)を参照してください                                                                                                                                                                                                    | はい    |
| `NotebookEdit`         | Jupyter ノートブック セルを変更します。[NotebookEdit ツールの動作](#notebookedit-tool-behavior)を参照してください                                                                                                                                                                                                                                             | はい    |
| `PowerShell`           | PowerShell コマンドをネイティブに実行します。[PowerShell ツール](#powershell-tool)の可用性を参照してください                                                                                                                                                                                                                                                     | はい    |
| `PushNotification`     | デスクトップ通知を送信し、[Remote Control](/ja/remote-control)が接続されている場合は電話プッシュ通知を送信するため、長時間実行タスクまたは[スケジュール済みタスク](/ja/scheduled-tasks)が離席時に到達できます。{/* plan-availability: feature=push-notifications providers=anthropic */}プッシュ配信は Anthropic ホスト インフラストラクチャを通じて実行されます。これは Amazon Bedrock、Google Vertex AI、または Microsoft Foundry からはアクセスできません | いいえ   |
| `Read`                 | ファイルの内容を読み取ります。[Read ツールの動作](#read-tool-behavior)を参照してください                                                                                                                                                                                                                                                                      | いいえ   |
| `ReadMcpResourceTool`  | URI で特定の MCP リソースを読み取ります                                                                                                                                                                                                                                                                                                        | いいえ   |
| `RemoteTrigger`        | claude.ai で[ルーチン](/ja/routines)を作成、更新、実行、リストします。`/schedule` コマンドをサポートします。{/* plan-availability: feature=routines plans=pro,max,team,enterprise providers=anthropic */}ルーチンは claude.ai に存在し、Pro、Max、Team、または Enterprise プランが必要なため、このツールは Amazon Bedrock、Google Vertex AI、または Microsoft Foundry からはアクセスできません                      | いいえ   |
| `SendMessage`          | [agent team](/ja/agent-teams)メンバーにメッセージを送信するか、agent ID で [subagent](/ja/sub-agents#resume-subagents)を再開します。停止した subagent はバックグラウンドで自動的に再開されます。`CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1` が設定されている場合にのみ利用可能です                                                                                                                      | いいえ   |
| `ShareOnboardingGuide` | {/* plan-availability: feature=onboarding-guide-share plans=pro,max,team,enterprise providers=anthropic */}}`ONBOARDING.md` をアップロードし、チームメンバーが Claude Code で開くことができる共有リンクを返します。ガイドが作成された後、`/team-onboarding` から呼び出されます。claude.ai の Pro、Max、Team、および Enterprise プランのサブスクライバーが利用可能です                                               | はい    |
| `Skill`                | メイン会話内で [skill](/ja/skills#control-who-invokes-a-skill)を実行します                                                                                                                                                                                                                                                                   | はい    |
| `TaskCreate`           | タスク リストに新しいタスクを作成します                                                                                                                                                                                                                                                                                                            | いいえ   |
| `TaskGet`              | 特定のタスクの完全な詳細を取得します                                                                                                                                                                                                                                                                                                              | いいえ   |
| `TaskList`             | すべてのタスクとその現在のステータスをリストします                                                                                                                                                                                                                                                                                                       | いいえ   |
| `TaskOutput`           | （非推奨）バックグラウンド タスクから出力を取得します。タスクの出力ファイル パスで `Read` を使用することをお勧めします                                                                                                                                                                                                                                                                | いいえ   |
| `TaskStop`             | ID で実行中のバックグラウンド タスクを終了します                                                                                                                                                                                                                                                                                                      | いいえ   |
| `TaskUpdate`           | タスク ステータス、依存関係、詳細を更新するか、タスクを削除します                                                                                                                                                                                                                                                                                               | いいえ   |
| `TeamCreate`           | 複数のメンバーを持つ [agent team](/ja/agent-teams)を作成します。`CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1` が設定されている場合にのみ利用可能です                                                                                                                                                                                                                     | いいえ   |
| `TeamDelete`           | agent team を解散してメンバー プロセスをクリーンアップします。`CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1` が設定されている場合にのみ利用可能です                                                                                                                                                                                                                               | いいえ   |
| `TodoWrite`            | セッション タスク チェックリストを管理します。非対話型モードと [Agent SDK](/ja/headless)で利用可能です。対話型セッションでは代わりに TaskCreate、TaskGet、TaskList、TaskUpdate を使用します                                                                                                                                                                                                  | いいえ   |
| `ToolSearch`           | [ツール検索](/ja/mcp#scale-with-mcp-tool-search)が有効な場合、遅延ツールを検索してロードします                                                                                                                                                                                                                                                              | いいえ   |
| `WebFetch`             | 指定された URL からコンテンツを取得します。[WebFetch ツールの動作](#webfetch-tool-behavior)を参照してください                                                                                                                                                                                                                                                     | はい    |
| `WebSearch`            | Web 検索を実行します。[WebSearch ツールの動作](#websearch-tool-behavior)を参照してください                                                                                                                                                                                                                                                              | はい    |
| `Write`                | ファイルを作成または上書きします。[Write ツールの動作](#write-tool-behavior)を参照してください                                                                                                                                                                                                                                                                  | はい    |

## 権限ルールとフックでツールを構成する

ほとんどの場合、Claude はこれらのツールをいつ使用するかを決定し、Claude と対話するときにツール名を自分で指定する必要はありません。権限およびその他の構成を定義するときにツール名を直接参照します：

* 設定の [`permissions.allow` と `permissions.deny`](/ja/settings#available-settings)および `/permissions` インターフェイス内
* Agent SDK の [`allowedTools` と `disallowedTools`](/ja/agent-sdk/permissions#allow-and-deny-rules)オプション内
* [CLI フラグ](/ja/cli-reference)の `--allowedTools` と `--disallowedTools` 内
* [subagent の `tools` または `disallowedTools`](/ja/sub-agents#supported-frontmatter-fields)frontmatter 内
* [skill の `allowed-tools`](/ja/skills#frontmatter-reference)frontmatter 内
* フックの [`if` 条件](/ja/hooks-guide#filter-by-tool-name-and-arguments-with-the-if-field)内

これらはすべて同じルール形式 `ToolName(specifier)` を受け入れます。指定子はツールによって異なり、複数のツールが形式を共有します：

| ルール形式                          | 適用対象                    | 詳細                                                        |
| :----------------------------- | :---------------------- | :-------------------------------------------------------- |
| `Bash(npm run *)`              | Bash、Monitor            | [コマンド パターン マッチング](/ja/permissions#bash)                   |
| `PowerShell(Get-ChildItem *)`  | PowerShell              | [コマンド パターン マッチング](/ja/permissions#powershell)             |
| `Read(~/secrets/**)`           | Read、Grep、Glob、LSP      | [パス パターン マッチング](/ja/permissions#read-and-edit)            |
| `Edit(/src/**)`                | Edit、Write、NotebookEdit | [パス パターン マッチング](/ja/permissions#read-and-edit)            |
| `Skill(deploy *)`              | Skill                   | [Skill 名マッチング](/ja/skills#restrict-claude's-skill-access) |
| `Agent(Explore)`               | Agent                   | [Subagent タイプ マッチング](/ja/permissions#agent-subagents)     |
| `WebFetch(domain:example.com)` | WebFetch                | [ドメイン マッチング](/ja/permissions#webfetch)                    |
| `WebSearch`                    | WebSearch               | 指定子なし。ツール全体を許可または拒否します                                    |

ここにリストされていないツール（`ExitPlanMode` や `ShareOnboardingGuide` など）は、指定子なしのベア ツール名のみを受け入れます。

`Edit(...)` 許可ルールは同じパスへの読み取りアクセスも付与するため、一致する `Read(...)` ルールは必要ありません。

フック `matcher` フィールドは括弧で囲まれたルール形式ではなく、ベア ツール名を使用します。[マッチャー パターン](/ja/hooks#matcher-patterns)のマッチング ルールを参照してください。各ツールがフック内の `tool_input` に渡すフィールド名については、[PreToolUse 入力リファレンス](/ja/hooks#pretooluse-input)を参照してください。

## Agent ツールの動作

Agent ツールは、別のコンテキストウィンドウで subagent を生成します。Subagent はそのタスクを自律的に処理し、親会話に単一のテキスト結果を返します。親は subagent の中間ツール呼び出しまたは出力を見ず、その最終結果のみを見ます。Subagent が実行するターン数を制限するには、[subagent 定義](/ja/sub-agents#supported-frontmatter-fields)で `maxTurns` を設定します。

同じ Agent ツールは、フォーク モードが有効な場合に[フォーク subagent](/ja/sub-agents#fork-the-current-conversation)も起動します。フォークは新規に開始する代わりに完全な親会話を継承し、常にバックグラウンドで実行され、ターミナルで権限プロンプトを表示します。このセクションの残りは名前付き subagent について説明します。

名前付き subagent が使用できるツールは、[subagent 定義](/ja/sub-agents#supported-frontmatter-fields)の `tools` および `disallowedTools` フィールドに依存します：

* **どちらのフィールドも設定されていない**：subagent は親が利用可能なすべてのツールを継承します。
* **`tools` のみ**：subagent はリストされたツールのみを取得します。
* **`disallowedTools` のみ**：subagent は親のすべてのツール（リストされたもの除く）を取得します。
* **両方設定**：`disallowedTools` が優先されます。両方にリストされているツールは削除されます。

Subagent を起動しても、それ自体は権限を求めるプロンプトを表示しません。Subagent の独自のツール呼び出しは、実行時に権限ルールに対してチェックされます：

* **フォアグラウンド subagent** は、メイン会話で見られるのと同じ権限プロンプトを表示し、各ツール呼び出しが発生した時点で表示されます。
* **バックグラウンド subagent** はプロンプトを表示しません。セッションで既に付与されている権限で実行され、そうでなければプロンプトを表示するツール呼び出しを自動的に拒否します。拒否後、subagent はそのツールなしで続行します。

Subagent が最初に到達できるものを制限するには、その `tools` フィールドを絞り込み、Bash をリストから外すか、[Subagent 機能の制御](/ja/sub-agents#control-subagent-capabilities)で説明されているように設定で拒否ルールを設定します。フォアグラウンドとバックグラウンドの選択の詳細については、[Subagent をフォアグラウンドまたはバックグラウンドで実行](/ja/sub-agents#run-subagents-in-foreground-or-background)を参照してください。

## Bash ツールの動作

Bash ツールは、次の永続化動作で各コマンドを別々のプロセスで実行します：

* Claude がメイン セッションで `cd` を実行すると、新しい作業ディレクトリはプロジェクト ディレクトリ内に留まる限り、または `--add-dir`、`/add-dir`、または設定の `additionalDirectories` で追加した[追加の作業ディレクトリ](/ja/permissions#working-directories)内に留まる限り、後の Bash コマンドに引き継がれます。Subagent セッションは作業ディレクトリの変更を引き継ぎません。
  * `cd` がこれらのディレクトリの外に出た場合、Claude Code はプロジェクト ディレクトリにリセットし、ツール結果に `Shell cwd was reset to <dir>` を追加します。
  * この引き継ぎを無効にして、すべての Bash コマンドがプロジェクト ディレクトリで開始されるようにするには、`CLAUDE_BASH_MAINTAIN_PROJECT_WORKING_DIR=1` を設定します。
* 環境変数は永続化されません。1 つのコマンドの `export` は次のコマンドでは利用できません。

Claude Code を起動する前に virtualenv または conda 環境をアクティブ化してください。Bash コマンド間で環境変数を永続化するには、Claude Code を起動する前に [`CLAUDE_ENV_FILE`](/ja/env-vars)をシェル スクリプトに設定するか、[SessionStart フック](/ja/hooks#persist-environment-variables)を使用して動的に設定します。

2 つの制限が各コマンドを制限します：

* **タイムアウト**：デフォルトでは 2 分です。Claude は `timeout` パラメーターで 1 コマンドあたり最大 10 分をリクエストできます。[`BASH_DEFAULT_TIMEOUT_MS` と `BASH_MAX_TIMEOUT_MS`](/ja/env-vars)でデフォルトと上限をオーバーライドします。
* **出力長**：デフォルトでは 30,000 文字です。コマンドがそれ以上を生成する場合、Claude Code は完全な出力をセッション ディレクトリのファイルに保存し、Claude にファイル パスと開始からの短いプレビューを提供します。Claude は必要に応じてそのファイルを読み取るか検索します。[`BASH_MAX_OUTPUT_LENGTH`](/ja/env-vars)で制限を上げます。上限は 150,000 文字です。

開発サーバーやウォッチ ビルドなどの長時間実行プロセスの場合、Claude は `run_in_background: true` を設定して、コマンドをバックグラウンド タスクとして開始し、実行中に作業を続けることができます。`/tasks` でバックグラウンド タスクをリストおよび停止します。

## Edit ツールの動作

Edit ツールは正確な文字列置換を実行します。`old_string` と `new_string` を取り、最初のものを 2 番目のものに置き換えます。正規表現またはあいまい一致は使用しません。

編集を適用するには、3 つのチェックが合格する必要があります：

* **編集前の読み取り**：Claude は現在の会話でファイルを読み取っている必要があり、その読み取り以降、ファイルはディスク上で変更されていない必要があります。このチェックは最初に実行され、文字列マッチングの前に実行されます。
* **マッチ**：`old_string` はファイルに正確に記述されたとおりに表示される必要があります。空白またはインデントの 1 文字の違いでも不一致になります。
* **一意性**：`old_string` は正確に 1 回表示される必要があります。複数回表示される場合、Claude は 1 つの出現を特定するのに十分な周囲コンテキストを含む長い文字列を提供するか、`replace_all: true` を設定してすべてを置き換えます。

Bash でファイルを表示することは、コマンドが `cat path/to/file` または `sed -n 'X,Yp' path/to/file` である場合、単一ファイルでパイプまたはリダイレクトがない場合、編集前の読み取り要件を満たします。`head`、`tail`、またはパイプ出力などの他の Bash コマンドはカウントされず、Claude はこれらの場合は編集前に Read を使用する必要があります。

これは編集の適格性にのみ影響し、権限には影響しません。[Read および Edit 拒否ルール](/ja/permissions#tool-specific-permission-rules)は、Claude Code が `cat`、`head`、`tail`、`sed` などの Bash で認識するファイル コマンドにも適用されますが、Python または Node スクリプトがファイルを自分で開くなど、ファイルを間接的に読み取るまたは書き込む任意のサブプロセスには適用されません。すべてのプロセスをカバーする OS レベルの強制については、[サンドボックスを有効にする](/ja/sandboxing)を参照してください。

## Glob ツールの動作

Glob ツールはファイルを名前パターンで検索します。`**` を含む標準 glob 構文をサポートして、再帰的なディレクトリ マッチングを行います：

* `**/*.js` は任意の深さのすべての `.js` ファイルにマッチします
* `src/**/*.ts` は `src/` の下のすべての `.ts` ファイルにマッチします
* `*.{json,yaml}` は現在のディレクトリの `.json` および `.yaml` ファイルにマッチします

結果は変更時刻でソートされ、100 ファイルで制限されます。制限に達した場合、Claude は結果に切り詰めフラグを見て、パターンを絞り込むことができます。

Glob はデフォルトで `.gitignore` を尊重しないため、追跡されたファイルと並んで gitignore されたファイルを検出します。これは [Grep](#grep-tool-behavior)とは異なり、gitignore されたファイルをスキップします。Glob が `.gitignore` を尊重するようにするには、Claude Code を起動する前に `CLAUDE_CODE_GLOB_NO_IGNORE=false` を設定します。

## Grep ツールの動作

Grep ツールはファイル コンテンツ内のパターンを検索します。[Glob](#glob-tool-behavior)がファイルを名前で検索する場合、Grep はそれらの内部の行を検索します。

Grep は [ripgrep](https://github.com/BurntSushi/ripgrep)に基づいており、POSIX grep ではなく ripgrep の正規表現構文を使用します。正規表現メタ文字を含むパターンはエスケープが必要です。たとえば、Go コードで `interface{}` を検出するには、パターン `interface\{\}` が必要です。

3 つの出力モードは、戻ってくるものを制御します：

* `files_with_matches`：ファイル パスのみ、行コンテンツなし。これがデフォルトです。
* `content`：ファイルと行番号を含む一致する行。
* `count`：ファイルごとの一致数。

Claude は `**/*.tsx` などの `glob` パラメーターでファイルごとに結果をスコープするか、`py` または `rust` などの `type` パラメーターで言語ごとにスコープできます。デフォルトでは、パターンは単一行内で一致します。Claude は `multiline: true` を設定して、行の境界を越えて一致させることができます。

Grep は `.gitignore` を尊重するため、gitignore されたファイルはスキップされます。gitignore されたファイルを検索するには、Claude はそのパスを直接渡します。

## LSP ツールの動作

LSP ツールは、実行中の言語サーバーから Claude にコード インテリジェンスを提供します。ファイル編集後、型エラーと警告を自動的に報告するため、Claude は別のビルド ステップなしで問題を修正できます。Claude はナビゲーション操作のために直接呼び出すこともできます：

* シンボルの定義へのジャンプ
* シンボルへのすべての参照を検索
* 位置での型情報を取得
* ファイルまたはワークスペース内のシンボルをリスト
* インターフェイスの実装を検索
* 呼び出し階層をトレース

ツールは、言語の[コード インテリジェンス プラグイン](/ja/discover-plugins#code-intelligence)をインストールするまで非アクティブです。プラグインは言語サーバー構成をバンドルし、サーバー バイナリは別途インストールします。

## Monitor ツール

<Note>
  Monitor ツールには Claude Code v2.1.98 以降が必要です。
</Note>

Monitor ツールを使用すると、Claude は会話を一時停止することなく、バックグラウンドで何かを監視し、変更時に対応できます。Claude に以下を依頼します：

* ログ ファイルをテールして、エラーが表示されたらフラグを立てる
* PR または CI ジョブをポーリングして、ステータスが変更されたときに報告する
* ディレクトリのファイル変更を監視する
* 指定した長時間実行スクリプトからの出力を追跡する

Claude は監視用の小さなスクリプトを作成し、バックグラウンドで実行し、到着した各出力行を受け取ります。同じセッションで作業を続け、イベントが到着すると Claude が割り込みます。Claude にキャンセルするよう依頼するか、セッションを終了することで Monitor を停止します。

Monitor は [Bash と同じ権限ルール](/ja/permissions#tool-specific-permission-rules)を使用するため、Bash に設定した `allow` および `deny` パターンがここにも適用されます。Amazon Bedrock、Google Vertex AI、または Microsoft Foundry では利用できません。`DISABLE_TELEMETRY` または `CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC` が設定されている場合も利用できません。

プラグインは、Claude に開始するよう依頼する代わりに、プラグインがアクティブな場合に自動的に開始される Monitor を宣言できます。[プラグイン Monitor](/ja/plugins-reference#monitors)を参照してください。

## NotebookEdit ツールの動作

NotebookEdit は、Jupyter ノートブックを 1 回に 1 セル、`cell_id` でセルをターゲットにして変更します。[Edit](#edit-tool-behavior)がプレーン ファイルで行うようにノートブック全体で文字列置換を実行しません。

3 つの編集モードは、ターゲット セルに何が起こるかを制御します：

* `replace`：セルのソースを上書きします。これがデフォルトです。
* `insert`：ターゲットの後に新しいセルを追加します。`cell_id` がない場合、新しいセルはノートブックの開始に移動します。`cell_type` を `code` または `markdown` に設定する必要があります。
* `delete`：ターゲット セルを削除します。

権限ルールは `Edit(...)` パス形式を使用します。`Edit(notebooks**)` のようなルールは、そのディレクトリ内のファイルに対する NotebookEdit 呼び出しをカバーします。

## PowerShell ツール

PowerShell ツールを使用すると、Claude は PowerShell コマンドをネイティブに実行できます。Windows では、これは Git Bash を経由するのではなく、PowerShell でコマンドが実行されることを意味します。Git Bash がない Windows では、ツールは自動的に有効になります。Git Bash がインストールされている Windows では、ツールは段階的にロールアウトされています。Linux、macOS、および WSL では、ツールはオプトインです。

### PowerShell ツールを有効にする

環境または `settings.json` で `CLAUDE_CODE_USE_POWERSHELL_TOOL=1` を設定します：

```json theme={null}
{
  "env": {
    "CLAUDE_CODE_USE_POWERSHELL_TOOL": "1"
  }
}
```

Windows では、変数を `0` に設定してロールアウトをオプトアウトします。Linux、macOS、および WSL では、ツールに PowerShell 7 以降が必要です：`pwsh` をインストールして、`PATH` に含まれていることを確認します。

Windows では、Claude Code は PowerShell 7 以降の `pwsh.exe` を自動検出し、PowerShell 5.1 の `powershell.exe` にフォールバックします。ツールが有効になっている場合、Claude は PowerShell をプライマリシェルとして扱います。Git Bash がインストールされている場合、Bash ツールは POSIX スクリプト用に利用可能なままです。

### 設定、フック、スキルでのシェル選択

3 つの追加設定は PowerShell が使用される場所を制御します：

* [`settings.json`](/ja/settings#available-settings)の `"defaultShell": "powershell"`：対話型 `!` コマンドを PowerShell 経由でルーティングします。PowerShell ツールが有効になっている必要があります。
* 個別の[コマンド フック](/ja/hooks#command-hook-fields)の `"shell": "powershell"`：そのフックを PowerShell で実行します。フックは PowerShell を直接生成するため、`CLAUDE_CODE_USE_POWERSHELL_TOOL` に関係なく機能します。
* [skill frontmatter](/ja/skills#frontmatter-reference)の `shell: powershell`：`` !`command` `` ブロックを PowerShell で実行します。PowerShell ツールが有効になっている必要があります。

Bash ツール セクションで説明されている同じメイン セッション作業ディレクトリ リセット動作が PowerShell コマンドに適用されます。これには `CLAUDE_BASH_MAINTAIN_PROJECT_WORKING_DIR` 環境変数が含まれます。

### プレビューの制限事項

PowerShell ツールには、プレビュー中に次の既知の制限事項があります：

* PowerShell プロファイルはロードされません
* Windows では、サンドボックスはサポートされていません

## Read ツールの動作

Read ツールはファイル パスを取得し、行番号付きでコンテンツを返します。Claude は常に絶対パスを渡すよう指示されます。

デフォルトでは、Read は開始からファイルを返します。サイズ しきい値を超えるファイルは、部分的なコンテンツではなくエラーを返し、Claude は `offset` と `limit` で再試行して特定の範囲を読み取るよう促します。

Read はプレーン テキストを超えるいくつかのファイル タイプを処理します：

* **画像**：PNG、JPG、およびその他の画像形式は、生バイトではなく Claude が見ることができるビジュアル コンテンツとして返されます。Claude Code は大きな画像をモデルの画像サイズ制限に合わせるようにサイズ変更および再圧縮するため、Claude は大きなスクリーンショットのダウンスケール版を見る場合があります。Claude が大きな画像で細かいピクセル レベルの詳細を見落とす場合は、ImageMagick を使用して Bash 経由で関心領域を最初にトリミングするよう依頼してください。
* **PDF**：Claude は短い `.pdf` ファイルを全体的に読み取ります。10 ページより長い PDF の場合、`pages` パラメーター（`"1-5"` など）で範囲で読み取り、一度に最大 20 ページまで読み取ります。
* **Jupyter ノートブック**：`.ipynb` ファイルは、コード、マークダウン、ビジュアライゼーションを含む、すべてのセルとその出力を返します。

Read はファイルのみを読み取り、ディレクトリは読み取りません。Claude は Bash ツール経由で `ls` を使用してディレクトリ コンテンツをリストします。

## WebFetch ツールの動作

WebFetch は URL と抽出する内容を説明するプロンプトを取得します。ページを取得し、サーバーが HTML を返す場合は応答を Markdown に変換し、小さく高速なモデルを使用してコンテンツに対してプロンプトを実行します。ほとんどのフェッチでは、Claude はそのモデルの回答を受け取り、生のページではなく受け取ります。変換ステップは構成不可です。

これにより WebFetch は設計上損失があります。抽出プロンプトは Claude に到達するものを決定するため、ページが何かについて言及していないという結果は、プロンプトがそれについて尋ねなかったことのみを意味する場合があります。Claude にもっと具体的なプロンプトで再度フェッチするよう依頼するか、Bash 経由で `curl` を使用して未処理のページを取得します。

いくつかの動作は Claude が受け取る応答を形成します：

* HTTP URL は自動的に HTTPS にアップグレードされます。
* 大きなページは処理前に固定文字制限に切り詰められます。
* 応答は 15 分間キャッシュされるため、同じ URL の繰り返しフェッチは迅速に返されます。
* URL が別のホストにリダイレクトされる場合、WebFetch はそれに従う代わりに、元の URL とリダイレクト ターゲットを名前付けするテキスト結果を返します。Claude は 2 番目の WebFetch 呼び出しで新しい URL をフェッチします。

デフォルトおよび `acceptEdits` 権限モードでは、WebFetch は新しいドメインに最初に到達するときにプロンプトを表示します。プロンプトなしで事前にドメインを許可するには、`WebFetch(domain:example.com)` のような権限ルールを追加します。`auto` および `bypassPermissions` [権限モード](/ja/permissions#permission-modes)はプロンプトを完全にスキップします。

WebFetch は `Claude-User` で始まる `User-Agent` ヘッダーと、HTML よりも Markdown を優先する `Accept` ヘッダーを設定するため、コンテンツ ネゴシエーションをサポートするサーバーは Markdown を直接返すことができます。[Sandbox](/ja/sandboxing)ネットワーク ルールは別途構成されるため、サンドボックス化されたプロセスが到達したいドメインには、明示的なサンドボックス権限ルールが必要です。

## WebSearch ツールの動作

WebSearch は Anthropic の [web search](https://platform.claude.com/docs/en/agents-and-tools/tool-use/web-search-tool)バックエンドに対してクエリを実行し、結果のタイトルと URL を返します。結果ページをフェッチしません。Claude が検索結果で見つけたページを読むには、[WebFetch](#webfetch-tool-behavior)でフォローアップします。

ツールは 1 回の呼び出しあたり最大 8 つのバックエンド検索を発行し、結果を返す前に内部的に検索を絞り込む場合があります。Claude は `allowed_domains` で結果をスコープして特定のホストのみを含めるか、`blocked_domains` で除外できます。2 つのリストは 1 回の呼び出しで組み合わせることはできません。

検索バックエンドは構成不可です。別のプロバイダーで検索するには、検索ツールを公開する [MCP サーバー](/ja/mcp)を追加します。

WebSearch 権限ルールは指定子を取りません。`allow` または `deny` の裸の `WebSearch` エントリのみが唯一の形式です。

<Note>
  WebSearch は Claude API と Microsoft Foundry で利用可能です。Google Cloud Vertex AI では、Opus、Sonnet、Haiku を含む Claude 4 モデルで機能します。Amazon Bedrock はサーバー側の Web 検索ツールを公開していません。
</Note>

## Write ツールの動作

Write ツールは新しいファイルを作成するか、提供された完全なコンテンツで既存のファイルを上書きします。追加またはマージは行いません。

ターゲット パスが既に存在する場合、Claude は現在の会話でそのファイルを少なくとも 1 回読み取っている必要があります。読み取られていない既存ファイルへの Write はエラーで失敗します。この制約は新しいファイルには適用されません。

Bash `cat` または `sed -n` でファイルを表示することは、[Edit ツールの動作](#edit-tool-behavior)で説明されているように、この要件を満たします。

既存ファイルへの部分的な変更の場合、Claude は Write ではなく Edit を使用します。

## 利用可能なツールを確認する

正確なツール セットは、プロバイダー、プラットフォーム、および設定によって異なります。実行中のセッションで読み込まれているものを確認するには、Claude に直接尋ねます：

```text theme={null}
What tools do you have access to?
```

Claude は会話形式の概要を提供します。正確な MCP ツール名については、`/mcp` を実行します。

## 関連項目

* [MCP servers](/ja/mcp)：外部サーバーを接続してカスタム ツールを追加する
* [権限](/ja/permissions)：権限システム、ルール構文、ツール固有のパターン
* [Subagents](/ja/sub-agents)：subagent のツール アクセスを構成する
* [フック](/ja/hooks-guide)：ツール実行の前後にカスタム コマンドを実行する
