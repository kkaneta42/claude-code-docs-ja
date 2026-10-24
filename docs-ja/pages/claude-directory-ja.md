> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# .claude ディレクトリを探索する

> Claude Code が CLAUDE.md、settings.json、hooks、skills、commands、subagents、workflows、rules、auto memory を読み込む場所。プロジェクト内の .claude ディレクトリとホームディレクトリの ~/.claude を探索します。

Claude Code は、プロジェクトディレクトリとホームディレクトリの `~/.claude` から、指示、設定、skills、subagents、メモリを読み込みます。プロジェクトファイルを git にコミットしてチームと共有します。`~/.claude` 内のファイルは、すべてのプロジェクトに適用される個人設定です。

Windows では、`~/.claude` は `%USERPROFILE%\.claude` に解決されます。[`CLAUDE_CONFIG_DIR`](https://code.claude.com/docs/ja/env-vars) を設定した場合、このページのすべての `~/.claude` パスはそのディレクトリの下に存在します。

ほとんどのユーザーは `CLAUDE.md` と `settings.json` のみを編集します。リポジトリに他のコーディングエージェント用の `AGENTS.md` が既にある場合、Claude Code は `CLAUDE.md` の代わりに[それを読み込むことができます](https://code.claude.com/docs/ja/memory.md#agents-md)。ディレクトリの残りはオプションです。必要に応じてスキル、ルール、またはサブエージェントを追加してください。

## ディレクトリを探索する

ツリー内のファイルをクリックして、各ファイルの機能、読み込みタイミング、および例を確認してください。

## 表示されないもの

エクスプローラーは、あなたが作成および編集するファイルをカバーしています。いくつかの関連ファイルは他の場所にあります。

| ファイル | 場所 | 目的 |
| - | - | - |
| `managed-settings.json` | システムレベル、OS によって異なる | エンタープライズが強制する設定で、[限定的な例外](https://code.claude.com/docs/ja/settings.md#exceptions-to-managed-settings-precedence)を除き、自身の設定ファイルや `--settings` の値で上書きすることはできません。[ファイルの保存場所](https://code.claude.com/docs/ja/managed-settings.md#deploy-a-managed-settings-file)と [Claude Code が使用する管理ソース](https://code.claude.com/docs/ja/managed-settings.md#precedence-within-the-managed-tier)を参照してください。 |
| `CLAUDE.local.md` | プロジェクトルート | このプロジェクトの個人的な設定で、CLAUDE.md と一緒に読み込まれます。手動で作成し、`.gitignore` に追加してください。 |
| `AGENTS.md` | プロジェクトルート、`.claude/`、または任意のディレクトリ | AI コーディングエージェント向けに作成するプロジェクト指示。Claude Code は `CLAUDE.md` の代わりに[これを読み込む](https://code.claude.com/docs/ja/memory.md#agents-md)ことができます。 |
| インストール済みプラグイン | `~/.claude/plugins` | クローンされたマーケットプレイス、インストール済みプラグインバージョン、`installed_plugins.json` インストール記録、およびプラグインごとのデータで、`claude plugin` コマンドで管理されます。[claude.ai アカウントから同期された](https://code.claude.com/docs/ja/plugins/loading.md#synced-plugins)プラグインは `~/.claude/plugins/synced/` にダウンロードされます。リンクモードでマーケットプレイス [`command` ソース](https://code.claude.com/docs/ja/plugins/marketplace-reference#command-plugin-source)からインストールされたプラグインの場合、Claude Code はコピーの代わりにここにリンクを保存し、プラグインのファイルはコマンドが出力するディレクトリに留まります。`command` ソースには Claude Code v2.1.229 以降が必要です。ローカルパスから追加したマーケットプレイスで相対パスによってリストされているプラグインも、キャッシュコピーではなく、ソースディレクトリから[その場で読み込まれます](https://code.claude.com/docs/ja/plugins/loading.md#find-plugins-on-disk)。[プラグインキャッシング](https://code.claude.com/docs/ja/plugins/loading.md#find-plugins-on-disk)を参照して、孤立したバージョンがどのようにクリーンアップされるかを確認してください。 |

`~/.claude` はまた、Claude Code があなたが作業する際に書き込むデータも保持しています。トランスクリプト、プロンプト履歴、ファイルスナップショット、キャッシュ、およびログです。下記の[アプリケーションデータ](#application-data)を参照してください。

## 適切なファイルを選択する

異なる種類のカスタマイズは異なるファイルに存在します。このテーブルを使用して、変更がどこに属するかを見つけてください。

| 実行したいこと | 編集 | スコープ | リファレンス |
| :- | :- | :- | :- |
| Claude にプロジェクトコンテキストと規約を提供する | `CLAUDE.md` | プロジェクトまたはグローバル | [メモリ](https://code.claude.com/docs/ja/memory.md) |
| 特定のツール呼び出しを許可またはブロックする | `settings.json` `permissions` または `hooks` | プロジェクトまたはグローバル | [パーミッション](https://code.claude.com/docs/ja/permissions.md)、[Hooks](https://code.claude.com/docs/ja/hooks.md) |
| ツール呼び出しの前後にスクリプトを実行する | `settings.json` `hooks` | プロジェクトまたはグローバル | [Hooks](https://code.claude.com/docs/ja/hooks.md) |
| セッションの環境変数を設定する | `settings.json` `env` | プロジェクトまたはグローバル | [設定](https://code.claude.com/docs/ja/settings-reference.md#all-settings) |
| 個人的なオーバーライドを git から除外する | `settings.local.json` | プロジェクトのみ | [設定スコープ](https://code.claude.com/docs/ja/settings.md#where-settings-live) |
| `/name` で呼び出すプロンプトまたは機能を追加する | `skills/<name>/SKILL.md` | プロジェクトまたはグローバル | [Skills](https://code.claude.com/docs/ja/skills.md) |
| 独自のツールを持つ特化した subagent を定義する | `agents/*.md` | プロジェクトまたはグローバル | [Subagents](https://code.claude.com/docs/ja/sub-agents.md) |
| スクリプトから多くの subagent をオーケストレーションする | `workflows/*.js` | プロジェクトまたはグローバル | [動的ワークフロー](https://code.claude.com/docs/ja/workflows.md) |
| MCP 経由で外部ツールを接続する | `.mcp.json` | プロジェクトのみ | [MCP](https://code.claude.com/docs/ja/mcp.md) |
| Claude がレスポンスをフォーマットする方法を変更する | `output-styles/*.md` | プロジェクトまたはグローバル | [出力スタイル](https://code.claude.com/docs/ja/output-styles.md) |

## ファイルリファレンス

このテーブルは、エクスプローラーがカバーするすべてのファイルをリストしています。プロジェクトスコープのファイルはリポジトリの `.claude/` の下に存在します（`CLAUDE.md`、`.mcp.json`、`.worktreeinclude` はルートにあります）。グローバルスコープのファイルは `~/.claude/` に存在し、すべてのプロジェクトに適用されます。

> [!NOTE]
>
> これらのファイルに入れたものをオーバーライドできるいくつかのことがあります。
>
> * 組織によってデプロイされた[管理設定](https://code.claude.com/docs/ja/server-managed-settings.md)は、[設定の優先順位における例外](https://code.claude.com/docs/ja/settings.md#exceptions-to-managed-settings-precedence)を除き、すべての設定ファイルおよび `--settings` の値に優先します
> * `--permission-mode` や `--settings` などの CLI フラグはそのセッションの `settings.json` をオーバーライドします
> * 一部の環境変数は同等の設定に優先しますが、これは異なります。各設定について[環境変数リファレンス](https://code.claude.com/docs/ja/env-vars.md)を確認してください
>
> 完全な順序については[設定の優先順位](https://code.claude.com/docs/ja/settings.md#settings-precedence)を参照してください。

ファイル名をクリックして、上記のエクスプローラーでそのノードを開きます。

| ファイル | スコープ | コミット | 機能 | リファレンス |
| - | - | - | - | - |
| [`CLAUDE.md`](#ce-claude-md) | プロジェクトおよびグローバル | ✓ | 毎セッション読み込まれる指示 | [メモリ](https://code.claude.com/docs/ja/memory.md) |
| [`rules/*.md`](#ce-rules) | プロジェクトおよびグローバル | ✓ | トピックスコープの指示、オプションでパスゲート | [ルール](https://code.claude.com/docs/ja/memory.md#organize-rules-with-claude/rules/) |
| [`settings.json`](#ce-settings-json) | プロジェクトおよびグローバル | ✓ | 権限、hooks、環境変数、モデルデフォルト | [設定](https://code.claude.com/docs/ja/settings.md) |
| [`settings.local.json`](#ce-settings-local-json) | プロジェクトのみ | | 個人的なオーバーライド、Claude Code が設定を保存するときに gitignore | [設定スコープ](https://code.claude.com/docs/ja/settings.md#where-settings-live) |
| [`.mcp.json`](#ce-mcp-json) | プロジェクトのみ | ✓ | チーム共有 MCP サーバー | [MCP スコープ](https://code.claude.com/docs/ja/mcp.md#mcp-installation-scopes) |
| [`.worktreeinclude`](#ce-worktreeinclude) | プロジェクトのみ | ✓ | 新しい worktrees にコピーする gitignore ファイル | [Worktrees](https://code.claude.com/docs/ja/worktrees.md#copy-gitignored-files-into-worktrees) |
| [`skills/<name>/SKILL.md`](#ce-skills) | プロジェクトおよびグローバル | ✓ | `/name` で呼び出される、または自動呼び出される再利用可能なプロンプト | [Skills](https://code.claude.com/docs/ja/skills.md) |
| [`commands/*.md`](#ce-commands) | プロジェクトおよびグローバル | ✓ | シングルファイルプロンプト。skills と同じメカニズム | [Skills](https://code.claude.com/docs/ja/skills.md) |
| [`output-styles/*.md`](#ce-output-styles) | プロジェクトおよびグローバル | ✓ | Claude の動作方法を調整するカスタム指示セット | [出力スタイル](https://code.claude.com/docs/ja/output-styles.md) |
| [`agents/*.md`](#ce-agents) | プロジェクトおよびグローバル | ✓ | 独自のプロンプトとツールを持つ subagent 定義 | [Subagents](https://code.claude.com/docs/ja/sub-agents.md) |
| [`workflows/*.js`](#ce-workflows) | プロジェクトおよびグローバル | ✓ | Claude によって書かれた動的ワークフロースクリプト、`/workflows` から保存。各ファイルは `/<name>` コマンドになります | [動的ワークフロー](https://code.claude.com/docs/ja/workflows.md) |
| [`agent-memory/<name>/`](#ce-agent-memory) | プロジェクトおよびグローバル | ✓ | subagents の永続メモリ | [永続メモリ](https://code.claude.com/docs/ja/sub-agents.md#enable-persistent-memory) |
| [`~/.claude.json`](#ce-claude-json) | グローバルのみ | | アプリ状態、アカウント詳細、UI トグル、個人 MCP サーバー | [グローバル設定](https://code.claude.com/docs/ja/settings-reference.md#global-config-settings) |
| [`projects/<project>/memory/`](#ce-global-projects) | グローバルのみ | | Auto memory：Claude のセッション間のメモ | [Auto memory](https://code.claude.com/docs/ja/memory.md#auto-memory) |
| [`keybindings.json`](#ce-keybindings) | グローバルのみ | | カスタムキーボードショートカット | [キーバインディング](https://code.claude.com/docs/ja/keybindings.md) |
| [`themes/*.json`](#ce-themes) | グローバルのみ | | カスタムカラーテーマ | [カスタムテーマ](https://code.claude.com/docs/ja/terminal-config.md#create-a-custom-theme) |

## ファイル別フロントマターフィールド

スキル、コマンドファイル、サブエージェント、出力スタイル、およびルールは、ファイルの上部にある YAML [フロントマター](https://code.claude.com/docs/ja/glossary.md#frontmatter)から設定を読み込み、それぞれが独自のフィールドセットを受け入れます。このテーブルは、各ファイルのフィールド名をリストアップし、それらを説明するリファレンスへのリンクを提供します。

| ファイル | フロントマターフィールド | リファレンス |
| - | - | - |
| `skills/<name>/SKILL.md` | `name`, `description`, `when_to_use`, `argument-hint`, `arguments`, `disable-model-invocation`, `user-invocable`, `allowed-tools`, `disallowed-tools`, `model`, `effort`, `context`, `agent`, `background`, `hooks`, `paths`, `shell`, `metadata`, `license`, `compatibility` | [スキルフロントマター](https://code.claude.com/docs/ja/skills.md#frontmatter-reference) |
| `commands/*.md` | `name` と `paths` を除くスキルフィールド | [スキルフロントマター](https://code.claude.com/docs/ja/skills.md#frontmatter-reference) |
| `agents/*.md` | `name`, `description`, `tools`, `disallowedTools`, `model`, `permissionMode`, `maxTurns`, `autoCompactWindow`, `skills`, `mcpServers`, `hooks`, `memory`, `background`, `effort`, `isolation`, `color`, `initialPrompt`, `omitClaudeMd`, `experimental` | [サブエージェントフロントマター](https://code.claude.com/docs/ja/sub-agents.md#supported-frontmatter-fields) |
| `output-styles/*.md` | `name`, `description`, `keep-coding-instructions`, `force-for-plugin` | [出力スタイルフロントマター](https://code.claude.com/docs/ja/output-styles.md#frontmatter) |
| `rules/*.md` | `paths` | [ルールフロントマター](https://code.claude.com/docs/ja/memory.md#rules-frontmatter-reference) |

[プラグイン](https://code.claude.com/docs/ja/plugins/components.md#agents)に含まれるエージェントは、サブエージェントフィールドのサブセットに対応しています。

## 設定をトラブルシューティングする

設定、hook、またはファイルが有効になっていない場合は、[設定をデバッグする](https://code.claude.com/docs/ja/debug-your-config.md)を参照して、検査コマンドと症状優先ルックアップテーブルを確認してください。

## アプリケーションデータ

作成したコンフィグ以外に、`~/.claude` には Claude Code がセッション中に書き込むデータが保存されます。これらのファイルはプレーンテキストです。ツールを通過するすべてのものは、ディスク上のトランスクリプトに書き込まれます。ファイルの内容、コマンド出力、貼り付けたテキストなどです。

### 自動的にクリーンアップされるファイル

Claude Code は、[`cleanupPeriodDays`](https://code.claude.com/docs/ja/settings-reference#cleanupperioddays) より古いファイルを以下のパスから削除します。ただし、保持期間を安全に判定できる場合に限ります。デフォルトは 30 日で、最小値は 1 です。`0` に設定するとバリデーションエラーが発生します。同じ経過日数の閾値が、[孤立した worktrees の自動削除](https://code.claude.com/docs/ja/worktrees.md#clean-up-subagent-and-background-session-worktrees)にも適用されます。

| `~/.claude/` 下のパス | 内容 |
| - | - |
| `projects/<project>/<session>.jsonl` | 完全な会話トランスクリプト：すべてのメッセージ、ツール呼び出し、ツール結果 |
| `projects/<project>/<session>.orphaned-<timestamp>-<suffix>.jsonl`、`projects/<project>/<session>.jsonl.superseded-<timestamp>` | Claude Code が上書きまたは削除する代わりに脇に置いたセッションの前のトランスクリプト。セッションピッカーには表示されません |
| `projects/<project>/<session>/subagents/` | [サブエージェント](https://code.claude.com/docs/ja/sub-agents.md)の会話トランスクリプト。親セッションのトランスクリプトが経過時間で削除されるときに削除されます |
| `projects/<project>/<session>/tool-results/` | 別ファイルにこぼれた大きなツール出力、および [MCP ツールが返す画像](https://code.claude.com/docs/ja/mcp.md#images-in-tool-results)のフルサイズコピー |
| `projects/<project>/<session>/mcp-tasks/` | 再開したセッションが実行中の [MCP タスク](https://code.claude.com/docs/ja/mcp.md#mcp-tasks-that-run-on-the-server)を再び追跡するために必要な情報、および Claude がまだ読み取っていない完了済みタスクの結果 |
| `file-history/<session>/` | Claude が変更したファイルの編集前スナップショット。[チェックポイント復元](https://code.claude.com/docs/ja/checkpointing.md)に使用されます。最新 100 個のチェックポイントのスナップショットを保持します。保持されたチェックポイントが参照していないスナップショットファイルは削除されます。ただし、各ファイルの最初のスナップショットは除きます |
| `plans/` | [プランモード](https://code.claude.com/docs/ja/permission-modes.md#analyze-before-you-edit-with-plan-mode)中に書き込まれたプランファイル |
| `debug/` | セッションごとのデバッグログ。デバッグログが有効な場合に書き込まれます。例えば、[`--debug`](https://code.claude.com/docs/ja/cli-reference#cli-flags)で起動した場合や `/debug` を実行した場合 |
| `paste-cache/` | 大きな貼り付けの内容 |
| `image-cache/<session>/` | Claude Code v2.1.274 以前で保存された添付画像。それ以降のバージョンでは、貼り付けた画像と添付画像は `~/.claude` の外に保存されます。[`CLAUDE_CODE_TMPDIR`](https://code.claude.com/docs/ja/env-vars)が制御する一時ディレクトリの下の各セッションの `images/` ディレクトリに保存されます。スイープは、年齢に関係なく、ここにある他のセッションの残されたディレクトリを削除します |
| `uploads/<session>/` | Web またはモバイルアプリから添付したファイル、およびモバイルアプリから添付した写真。[リモートコントロール](https://code.claude.com/docs/ja/remote-control.md)セッションにメッセージを送信する場合。[クラウドセッション](https://code.claude.com/docs/ja/claude-code-on-the-web.md)への添付は、代わりにそのセッション自身のクラウド環境に保存され、マシン上には保存されません |
| `dev-mods/<session>/` | [Claude が作成した Mods](https://code.claude.com/docs/ja/plugins/mods/create.md#ask-claude-for-a-mod)。セッション中に作成されたもの |
| `session-env/` | セッションごとの環境メタデータ |
| `tasks/` | タスクツールで書き込まれたタスクリスト。リストごとに 1 つのディレクトリ |
| `shell-snapshots/` | 起動時にキャプチャされたエイリアス、関数、シェルオプション。[Bash ツール](https://code.claude.com/docs/ja/tools-reference.md#bash-tool-behavior)によって各コマンドに適用されます。クリーンな終了時に削除されます。スイープはクラッシュ後に残されたものをクリアします |
| `backups/` | `~/.claude.json` の以前のバージョン。Claude Code がファイルを書き直すときにコピーされます。Claude Code は最新の 5 つと、解析できなかったバージョンのコピーを保持します |
| `feedback-bundles/` | `/feedback` でサードパーティプロバイダーに書き込まれた、または Anthropic 認証情報が設定されていない場合に書き込まれた、編集済みトランスクリプトアーカイブ。Anthropic アカウントチームに送信するため |
| `feedback/drafts/` | キューに入った [Claude が作成したフィードバック](https://code.claude.com/docs/ja/tools-reference.md#sendfeedback-tool-behavior)。`/feedback` でのレビューを待機中です。`cleanupPeriodDays` または 30 日のいずれか短い方の後にスイープされます。キューが 10 ドラフトの上限に達すると、Claude Code は最も古いドラフトを削除して空き容量を作ります |
| `usage-data/` | `report.html` と [`/insights`](https://code.claude.com/docs/ja/costs#analyze-your-usage-patterns)で書き込まれたタイムスタンプ付きレポートコピー。それらを構築するために使用されるキャッシュされたセッションごとの分析データ |
| `skills/.trash/`、`plugins/.trash/` | [スキル](https://code.claude.com/docs/ja/skills.md#how-synced-skills-behave)と [プラグイン](https://code.claude.com/docs/ja/plugins/loading.md#synced-plugins)。claude.ai 同期で削除されたもの。例えば、claude.ai でオフにした後、または同期を停止した後。ファイルはここに残るため、スイープが削除するまで復元できます |
| `plugins/installed_plugins.set-aside.<date>.<hash>.json`、`plugins/installed_plugins.unreadable.<date>.<hash>.kept` | 日付付きコピー。Claude Code が [`installed_plugins.json`](https://code.claude.com/docs/ja/plugins/loading#find-plugins-on-disk) を書き直す前に作成します。削除したインストールレコード、および読み込めなかったファイルの内容 |
| `todos/`、`statsig/`、`logs/` | 古いバージョンのレガシーディレクトリ。現在は書き込まれていません。スイープはその内容を削除してから、空のディレクトリを削除します |

`sessions/` のセッションファイル、自動メモリ、Claude Desktop および Cowork トランスクリプトは、それぞれ独自の保持ルールに従います：

* **`sessions/`**：実行中の各セッションに 1 つの小さいファイルを保持します。同時実行セッションとクラッシュを検出するために使用されます。年齢ベースのスイープの一部ではありません。Claude Code は、セッションが終了するときに各ファイルを削除し、次の起動時にクラッシュの残りをクリアします。
* **自動メモリ**：スイープは、プロジェクトの[自動メモリ](https://code.claude.com/docs/ja/memory.md#auto-memory)ディレクトリ `projects/<project>/memory/` 内のメモリファイルを削除しません。Claude Code は、保持期間全体が空だった場合にのみそのディレクトリを削除します。v2.1.228 より前では、スイープはメモリディレクトリ内のフォルダをセッションデータとして扱い、その下の古いファイルを削除できました。
* **Claude Desktop および Cowork トランスクリプト**：Claude Code は、Claude Desktop または Cowork で開始または最後に続行したセッションのトランスクリプトを任意の年齢で保持します。これらのトランスクリプトに年齢制限を与えるには、[`desktopSessionCleanupPeriodDays`](https://code.claude.com/docs/ja/settings-reference#desktopsessioncleanupperioddays) を設定します。Claude Code v2.1.248 以降が必要です。それより前のバージョンでは、`cleanupPeriodDays` の後に削除します。

  次のいずれかの場合、Claude Code は代わりに `cleanupPeriodDays` の後にこれらのトランスクリプトを削除します：

  * [管理設定](https://code.claude.com/docs/ja/managed-settings.md)が `cleanupPeriodDays` を設定している
  * [HIPAA 設定がセッションに適用されている](https://code.claude.com/docs/ja/hipaa-setup.md#check-how-developers-sign-in-and-connect)

Claude Code は、以下の場合に年齢ベースのスイープをスキップします：

* **ベアモード**：[`--bare`](https://code.claude.com/docs/ja/headless#start-faster-with-bare-mode)で `claude -p` を実行する場合、Claude Code はそのセッションでスイープを実行しません。
* **一時停止されたスイープ**：Claude Code が保持期間を安全に判定できない場合、保持クリーンアップスイープを一時停止します。[`retention_sweep` イベント](https://code.claude.com/docs/ja/monitoring-usage#retention-sweep-event)は、それを一時停止する各設定をリストします。原因が読み込みまたは解析できない設定ファイル、または `cleanupPeriodDays` または `desktopSessionCleanupPeriodDays` が明示的に設定された設定エラーの場合、Claude Code は設定エラーを修正するまで `/status` に警告も表示します。[管理設定](https://code.claude.com/docs/ja/server-managed-settings.md)が `cleanupPeriodDays` を提供する場合、Claude Code はどちらの場合でも管理値でスイープを実行します。

組織内のマシンが設定した保持期間でスイープを実行していることを確認するには、[保持スイープを確認する](https://code.claude.com/docs/ja/monitoring-usage.md#check-the-retention-sweep)を参照してください。

### セッションスクラッチパッドディレクトリ

スクラッチパッドは、Claude Code が Claude に一時ファイル用に提供するセッションごとのディレクトリです。中間結果、ヘルパースクリプト、プロジェクトに属さないドラフトです。Claude が「スクラッチパッドに保存した」と言う場合、ファイルはそこにあります。Claude は `/tmp` の代わりにそれを使用し、権限プロンプトなしでそれ内のファイルを作成、編集、読み取ることができます。

スクラッチパッドは `~/.claude` ではなく Claude Code の一時ディレクトリの下に存在します。プラットフォームの現在のセッションのパスを見つけます：

* **macOS**：`/private/tmp/claude-<uid>/<project>/<session-id>/scratchpad/`
* **Linux**：`/tmp/claude-<uid>/<project>/<session-id>/scratchpad/`、またはシステムが設定する場合は `$TMPDIR` の下の同じ形状
* **Windows**：`%TEMP%\claude\<project>\<session-id>\scratchpad\`

`<project>` は、文字と数字以外のすべての文字が `-` に置き換えられた作業ディレクトリパスです。例えば、`-Users-you-my-project`。[`CLAUDE_CODE_TMPDIR`](https://code.claude.com/docs/ja/env-vars)を設定する場合、ツリーはそのディレクトリの下に移動します。フックは現在のセッションのパスを [`scratchpad_dir`](https://code.claude.com/docs/ja/hooks#common-input-fields)として受け取ります。

スクラッチパッドファイルはセッションのトランスクリプトと同じ期間続きます。[保持スイープ](#cleaned-up-automatically)はトランスクリプトを削除するときにディレクトリを削除し、[`claude purge`](#clear-local-data)は一時ディレクトリに触れません。ディレクトリはシステムの一時場所の下にあるため、オペレーティングシステムもそれをクリアできます。例えば、再起動時。Claude がそこに書き込んだものを保持するには、Claude にそれをプロジェクトに移動するよう依頼します。

セッションがスクラッチパッドを持つのは、以下のすべてが成り立つ場合のみです：

* API キーではなく claude.ai アカウントでサインインしている
* セッションが Amazon Bedrock、Google Cloud の Agent Platform、または Microsoft Foundry ではなく Anthropic API を使用している
* [`enableArtifact`](https://code.claude.com/docs/ja/settings-reference#enableartifact)が `false` に設定されていない

### 削除するまで保持されるファイル

特に記載のある行を除き、保持クリーンアップスイープは以下のパスを削除せず、Claude Code はそれらを削除するまで保持します。

| `~/.claude/` 下のパス | 内容 |
| - | - |
| `history.jsonl` | 入力したプロンプトが、タイムスタンプとプロジェクトパスとともに記録されます。上矢印キーによる呼び出し、`Ctrl+R` による履歴検索、`!` によるシェルコマンドの補完に使用されます。[HIPAA 設定がセッションに適用される](https://code.claude.com/docs/ja/hipaa-setup.md#check-how-developers-sign-in-and-connect)場合、各クリーンアップ処理で `cleanupPeriodDays` より古いエントリが削除されます。 |
| `stats-cache.json` | `/usage` で表示される集計トークンとコスト数 |
| `remote-settings.json` | 組織の[サーバー管理設定](https://code.claude.com/docs/ja/server-managed-settings.md)のキャッシュコピー。組織が何も設定していない場合は `{}`。セッションが[それらを取得](https://code.claude.com/docs/ja/server-managed-settings.md#platform-availability)する場合にのみ存在します。Claude Code は起動時と、セッション中は 1 時間ごとに更新を確認します。ログアウト時に削除されます |
| `cache/changelog.md` | Claude Code チェンジログのキャッシュコピー。`/release-notes` で表示されます。バックグラウンドで更新されます |
| `policy-limits.json` | 組織のキャッシュされた機能ポリシー設定。一部のアカウントタイプにのみ存在します。自動的に更新されます。`policy-limits.json.stamp.json` サイドカーは、キャッシュが属するアカウントまたは API キーを記録します。Claude Code はログアウト時に両方のファイルを削除します |

#### 保持するべき状態ファイル

使用する機能に応じて、`~/.claude/` には [アプリケーションデータ](#application-data)の表に記載されていないファイルも保存されます。そのうち、キャッシュとロックファイルは削除しても安全です。以下の状態ファイルは保持してください：

* `.credentials.json`：[ログイン認証情報](https://code.claude.com/docs/ja/authentication.md#credential-management)
* `agent-memory/`：[サブエージェントメモリ](https://code.claude.com/docs/ja/sub-agents.md#enable-persistent-memory)
* `jobs/` と `daemon/`：[バックグラウンドセッション](https://code.claude.com/docs/ja/agent-view.md#where-state-is-stored)の状態

### プレーンテキストストレージ

トランスクリプトと履歴は保存時に暗号化されません。OS ファイル権限が唯一の保護です。ツールが `.env` ファイルを読み込むか、コマンドが認証情報を出力する場合、その値は `projects/<project>/<session>.jsonl` に書き込まれます。露出を減らすには：

* `cleanupPeriodDays` を低くして、Claude Code がトランスクリプトを保持する期間を短縮します
* [`desktopSessionCleanupPeriodDays`](https://code.claude.com/docs/ja/settings-reference#desktopsessioncleanupperioddays)を設定して、Claude Desktop および Cowork トランスクリプトにも年齢制限を与えます
* [`CLAUDE_CODE_SKIP_PROMPT_HISTORY`](https://code.claude.com/docs/ja/env-vars)環境変数を設定して、任意のモードでトランスクリプトとプロンプト履歴の書き込みをスキップします。非対話モードでは、代わりに `-p` と一緒に `--no-session-persistence` を渡すか、TypeScript Agent SDK で `persistSession: false` を設定できます。Python SDK には同等のオプションがありません。
* [権限ルール](https://code.claude.com/docs/ja/permissions.md)を使用して、認証情報ファイルの読み取りを拒否します

### ローカルデータをクリアする

`claude purge` を実行して、1 つのプロジェクトに対して Claude Code が保持する状態を削除します。削除されるもの：

* `projects/` の下のトランスクリプトと自動メモリ
* セッションごとの `tasks/`、`debug/`、`file-history/` エントリ
* `history.jsonl` の一致するプロンプト行
* `~/.claude.json` のプロジェクトエントリ

プロジェクトのセッションで貼り付けた、または添付した画像、および各セッションの[スクラッチパッド](#session-scratchpad-directory)は、`~/.claude` ではなく Claude Code の一時ディレクトリの下に保存されるため、パージは削除しません。[保持スイープ](#cleaned-up-automatically)は、`cleanupPeriodDays` より古くなると画像を削除します。パージされたセッションのスクラッチパッドは、削除するか、オペレーティングシステムが一時ディレクトリをクリアするまで残ります。

コマンドは完全な削除計画を出力し、何かを削除する前に確認を求めます。

v2.1.288 より前は、コマンドは `claude project purge` でした。

以下の例では、`~/work/my-repo` をプレースホルダーとして使用します。プロジェクトへのパスに置き換えます。パスに一致する状態がない場合、コマンドはエラーを出力し、ステータス 1 で終了します。

削除せずに計画をプレビューします：

```bash theme={null}
claude purge ~/work/my-repo --dry-run
```

計画は各一致するアイテムと、それが含まれる理由をリストします：

```text theme={null}
Purge plan for /home/user/work/my-repo:

  dir:    /home/user/.claude/projects/-home-user-work-my-repo
           project transcripts (.jsonl) and memory/
  config: projects["/home/user/work/my-repo"]
           project entry in ~/.claude.json (trust, history, MCP servers)
  filter: /home/user/.claude/history.jsonl
           12 prompt(s) typed in this project

shell-snapshots/ are not project-scoped and will not be touched
backups/ may still contain this project entry in old .claude.json snapshots (/home/user/.claude/backups); at most 5 are kept and they rotate out automatically
Dry run: 3 item(s) would be deleted.
```

単一の確認プロンプトで削除します：

```bash theme={null}
claude purge ~/work/my-repo
```

コマンドは同じ計画を出力してから、`Delete 3 item(s) for /home/user/work/my-repo? This cannot be undone. [y/N]` と尋ね、`y` と答えた場合のみ削除します。

パスを省略して、対話的なリストからプロジェクトを選択します。

スクリプトで使用するために確認プロンプトをスキップします：

```bash theme={null}
claude purge ~/work/my-repo --yes
```

その他のオプション：

* パスの代わりに `--all` を渡して、すべてのプロジェクトの状態を一度にパージします。これは `history.jsonl` をフィルタリングするのではなく、完全に削除します。
* `-i` を渡して、削除計画を 1 つずつステップスルーします。

コマンドは `shell-snapshots/` と `backups/` をそのままにしておきます。これらはプロジェクトスコープではないため、計画出力で警告します。マシン上で誰かが [`/heapdump`](https://code.claude.com/docs/ja/troubleshooting#high-cpu-or-memory-usage) を実行した場合は、それが書き込んだ `.heapsnapshot` ファイルも削除してください。ヒープスナップショットには会話全体とプロセスが保持していた認証情報が含まれており、保持スイープもパージもそれには触れません。

[保持するべき状態ファイル](#state-files-to-keep)を除き、上記のアプリケーションデータパスのいずれかを手動で削除することもできます。

| 削除 | 失うもの |
| - | - |
| `~/.claude/projects/` | 過去のセッションの再開、続行、巻き戻し、およびすべてのプロジェクトの自動メモリ |
| `~/.claude/history.jsonl` | 上矢印プロンプトリコール、`Ctrl+R` 履歴検索、`!` シェルコマンド補完 |
| `~/.claude/paste-cache/` | リコールされたプロンプトで貼り付けたテキスト。[大きなコンテンツを貼り付ける](https://code.claude.com/docs/ja/terminal-config.md#paste-large-content)を参照 |
| `~/.claude/uploads/` | 過去の[リモートコントロール](https://code.claude.com/docs/ja/remote-control.md)セッションがパスで参照する添付ファイル |
| `~/.claude/file-history/` | 過去のセッションのチェックポイント復元 |
| `~/.claude/stats-cache.json` | `/usage` で表示される履歴合計 |
| `~/.claude/usage-data/` | 過去の [`/insights`](https://code.claude.com/docs/ja/costs#analyze-your-usage-patterns) レポートと、それらを構築するために使用されるキャッシュされた分析データ |
| `~/.claude/feedback-bundles/` | Anthropic アカウントチームにまだ送信していないフィードバックとバグレポートアーカイブ |
| `~/.claude/feedback/drafts/` | 送信していない [Claude が作成したフィードバック](https://code.claude.com/docs/ja/tools-reference.md#sendfeedback-tool-behavior) |
| `~/.claude/remote-settings.json` | なし。次の起動時に再取得されます |
| `~/.claude/cache/changelog.md` | なし。バックグラウンドで更新されます |
| `~/.claude/policy-limits.json` | なし。自動的に更新されます |
| `~/.claude/tasks/` | まだ使用中のものを含む[タスクリスト](https://code.claude.com/docs/ja/interactive-mode.md#task-list) |
| `~/.claude/skills/.trash/`、`~/.claude/plugins/.trash/` | Claude Code が削除した[同期されたスキル](https://code.claude.com/docs/ja/skills.md#how-synced-skills-behave)と[同期されたプラグイン](https://code.claude.com/docs/ja/plugins/loading.md#synced-plugins)を復元する機会 |
| `~/.claude/plugins/installed_plugins.set-aside.<date>.<hash>.json`、`~/.claude/plugins/installed_plugins.unreadable.<date>.<hash>.kept` | Claude Code が削除したプラグインインストールレコード、または読み込めなかったファイルのコピー。何もそれらを読み込み直しません |
| `~/.claude/debug/`、`~/.claude/plans/`、`~/.claude/session-env/`、`~/.claude/shell-snapshots/`、`~/.claude/backups/` | ユーザーに見える何もなし |
| `~/.claude/todos/`、`~/.claude/statsig/`、`~/.claude/logs/`、`~/.claude/image-cache/` | なし。現在のバージョンで書き込まれていないレガシーディレクトリ |

`~/.claude.json`、`~/.claude/settings.json`、`~/.claude/plugins/` は削除しないでください。これらはアカウント情報、環境設定、インストール済みプラグインを保持しています。

## 関連リソース

* [Claude のメモリを管理する](https://code.claude.com/docs/ja/memory.md)：CLAUDE.md、rules、auto memory を書き込んで整理します
* [設定を構成する](https://code.claude.com/docs/ja/settings.md)：パーミッション、hooks、環境変数、モデルデフォルトを設定します
* [Skills を作成する](https://code.claude.com/docs/ja/skills.md)：再利用可能なプロンプトとワークフローを構築します
* [Subagents を構成する](https://code.claude.com/docs/ja/sub-agents.md)：独自のコンテキストを持つ特化したエージェントを定義します
