> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# .claude ディレクトリを探索する

> Claude Code が CLAUDE.md、settings.json、hooks、skills、commands、subagents、workflows、rules、auto memory を読み込む場所。プロジェクト内の .claude ディレクトリとホームディレクトリの ~/.claude を探索します。

Claude Code は、プロジェクトディレクトリとホームディレクトリの `~/.claude` から、指示、設定、skills、subagents、メモリを読み込みます。プロジェクトファイルを git にコミットしてチームと共有します。`~/.claude` 内のファイルは、すべてのプロジェクトに適用される個人設定です。

Windows では、`~/.claude` は `%USERPROFILE%\.claude` に解決されます。[`CLAUDE_CONFIG_DIR`](/ja/env-vars) を設定した場合、このページのすべての `~/.claude` パスはそのディレクトリの下に存在します。

ほとんどのユーザーは `CLAUDE.md` と `settings.json` のみを編集します。ディレクトリの残りはオプションです。必要に応じて skills、rules、または subagents を追加してください。

<h2 id="explore-the-directory">
  ディレクトリを探索する
</h2>

ツリー内のファイルをクリックして、各ファイルの機能、読み込みタイミング、および例を確認してください。

<h2 id="what-s-not-shown">
  表示されていないもの
</h2>

エクスプローラーは、作成および編集するファイルをカバーしています。関連するいくつかのファイルは他の場所に存在します。

| ファイル                    | 場所                   | 目的                                                                                                                                                                                                         |
| ----------------------- | -------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `managed-settings.json` | システムレベル、OS によって異なる   | オーバーライドできないエンタープライズが強制する設定。[サーバー管理設定](/ja/server-managed-settings)を参照してください。                                                                                                                               |
| `CLAUDE.local.md`       | プロジェクトルート            | このプロジェクトの個人的な設定。CLAUDE.md と一緒に読み込まれます。手動で作成し、`.gitignore` に追加してください。                                                                                                                                       |
| インストール済みプラグイン           | `~/.claude/plugins/` | クローンされたマーケットプレイス、インストール済みプラグインバージョン、およびプラグインごとのデータ。`claude plugin` コマンドで管理されます。孤立したバージョンはプラグインの更新またはアンインストール後 7 日で削除されます。[プラグインキャッシング](/ja/plugins-reference#plugin-caching-and-file-resolution)を参照してください。 |

`~/.claude` は、作業中に Claude Code が書き込むデータも保持します。トランスクリプト、プロンプト履歴、ファイルスナップショット、キャッシュ、ログです。以下の[アプリケーションデータ](#application-data)を参照してください。

<h2 id="choose-the-right-file">
  適切なファイルを選択する
</h2>

異なる種類のカスタマイズは異なるファイルに存在します。このテーブルを使用して、変更がどこに属するかを見つけてください。

| 実行したいこと                           | 編集                                        | スコープ           | リファレンス                                        |
| :-------------------------------- | :---------------------------------------- | :------------- | :-------------------------------------------- |
| Claude にプロジェクトコンテキストと規約を提供する      | `CLAUDE.md`                               | プロジェクトまたはグローバル | [メモリ](/ja/memory)                             |
| 特定のツール呼び出しを許可またはブロックする            | `settings.json` `permissions` または `hooks` | プロジェクトまたはグローバル | [パーミッション](/ja/permissions)、[Hooks](/ja/hooks) |
| ツール呼び出しの前後にスクリプトを実行する             | `settings.json` `hooks`                   | プロジェクトまたはグローバル | [Hooks](/ja/hooks)                            |
| セッションの環境変数を設定する                   | `settings.json` `env`                     | プロジェクトまたはグローバル | [設定](/ja/settings#available-settings)         |
| 個人的なオーバーライドを git から除外する           | `settings.local.json`                     | プロジェクトのみ       | [設定スコープ](/ja/settings#settings-files)         |
| `/name` で呼び出すプロンプトまたは機能を追加する      | `skills/<name>/SKILL.md`                  | プロジェクトまたはグローバル | [Skills](/ja/skills)                          |
| 独自のツールを持つ特化した subagent を定義する      | `agents/*.md`                             | プロジェクトまたはグローバル | [Subagents](/ja/sub-agents)                   |
| スクリプトから多くの subagent をオーケストレーションする | `workflows/*.js`                          | プロジェクトまたはグローバル | [動的ワークフロー](/ja/workflows)                     |
| MCP 経由で外部ツールを接続する                 | `.mcp.json`                               | プロジェクトのみ       | [MCP](/ja/mcp)                                |
| Claude がレスポンスをフォーマットする方法を変更する     | `output-styles/*.md`                      | プロジェクトまたはグローバル | [出力スタイル](/ja/output-styles)                   |

<h2 id="file-reference">
  ファイルリファレンス
</h2>

このテーブルは、エクスプローラーがカバーするすべてのファイルをリストしています。プロジェクトスコープのファイルはリポジトリの `.claude/` の下に存在します（`CLAUDE.md`、`.mcp.json`、`.worktreeinclude` はルートにあります）。グローバルスコープのファイルは `~/.claude/` に存在し、すべてのプロジェクトに適用されます。

<Note>
  これらのファイルに入れたものをオーバーライドできるいくつかのことがあります。

  * 組織によってデプロイされた[管理設定](/ja/server-managed-settings)はすべてに優先します
  * `--permission-mode` や `--settings` などの CLI フラグはそのセッションの `settings.json` をオーバーライドします
  * 一部の環境変数は同等の設定に優先しますが、これは異なります。各設定について[環境変数リファレンス](/ja/env-vars)を確認してください

  完全な順序については[設定の優先順位](/ja/settings#settings-precedence)を参照してください。
</Note>

ファイル名をクリックして、上記のエクスプローラーでそのノードを開きます。

| ファイル                                                | スコープ           | コミット | 機能                                                                        | リファレンス                                                          |
| --------------------------------------------------- | -------------- | ---- | ------------------------------------------------------------------------- | --------------------------------------------------------------- |
| [`CLAUDE.md`](#ce-claude-md)                        | プロジェクトおよびグローバル | ✓    | 毎セッション読み込まれる指示                                                            | [メモリ](/ja/memory)                                               |
| [`rules/*.md`](#ce-rules)                           | プロジェクトおよびグローバル | ✓    | トピックスコープの指示、オプションでパスゲート                                                   | [ルール](/ja/memory#organize-rules-with-claude/rules/)             |
| [`settings.json`](#ce-settings-json)                | プロジェクトおよびグローバル | ✓    | パーミッション、hooks、環境変数、モデルデフォルト                                               | [設定](/ja/settings)                                              |
| [`settings.local.json`](#ce-settings-local-json)    | プロジェクトのみ       |      | 個人的なオーバーライド、自動 gitignore                                                  | [設定スコープ](/ja/settings#settings-files)                           |
| [`.mcp.json`](#ce-mcp-json)                         | プロジェクトのみ       | ✓    | チーム共有 MCP サーバー                                                            | [MCP スコープ](/ja/mcp#mcp-installation-scopes)                     |
| [`.worktreeinclude`](#ce-worktreeinclude)           | プロジェクトのみ       | ✓    | 新しい worktrees にコピーする gitignore ファイル                                       | [Worktrees](/ja/worktrees#copy-gitignored-files-into-worktrees) |
| [`skills/<name>/SKILL.md`](#ce-skills)              | プロジェクトおよびグローバル | ✓    | `/name` で呼び出される、または自動呼び出される再利用可能なプロンプト                                    | [Skills](/ja/skills)                                            |
| [`commands/*.md`](#ce-commands)                     | プロジェクトおよびグローバル | ✓    | シングルファイルプロンプト。skills と同じメカニズム                                             | [Skills](/ja/skills)                                            |
| [`output-styles/*.md`](#ce-output-styles)           | プロジェクトおよびグローバル | ✓    | カスタムシステムプロンプトセクション                                                        | [出力スタイル](/ja/output-styles)                                     |
| [`agents/*.md`](#ce-agents)                         | プロジェクトおよびグローバル | ✓    | 独自のプロンプトとツールを持つ subagent 定義                                               | [Subagents](/ja/sub-agents)                                     |
| [`workflows/*.js`](#ce-workflows)                   | プロジェクトおよびグローバル | ✓    | Claude によって書かれた動的ワークフロースクリプト、`/workflows` から保存。各ファイルは `/<name>` コマンドになります | [動的ワークフロー](/ja/workflows)                                       |
| [`agent-memory/<name>/`](#ce-agent-memory)          | プロジェクトおよびグローバル | ✓    | subagents の永続メモリ                                                          | [永続メモリ](/ja/sub-agents#enable-persistent-memory)                |
| [`~/.claude.json`](#ce-claude-json)                 | グローバルのみ        |      | アプリ状態、OAuth、UI トグル、個人 MCP サーバー                                            | [グローバル設定](/ja/settings#global-config-settings)                  |
| [`projects/<project>/memory/`](#ce-global-projects) | グローバルのみ        |      | Auto memory：Claude のセッション間のメモ                                             | [Auto memory](/ja/memory#auto-memory)                           |
| [`keybindings.json`](#ce-keybindings)               | グローバルのみ        |      | カスタムキーボードショートカット                                                          | [キーバインディング](/ja/keybindings)                                    |
| [`themes/*.json`](#ce-themes)                       | グローバルのみ        |      | カスタムカラーテーマ                                                                | [カスタムテーマ](/ja/terminal-config#create-a-custom-theme)            |

<h2 id="troubleshoot-configuration">
  設定をトラブルシューティングする
</h2>

設定、hook、またはファイルが有効になっていない場合は、[設定をデバッグする](/ja/debug-your-config)を参照して、検査コマンドと症状優先ルックアップテーブルを確認してください。

<h2 id="application-data">
  アプリケーションデータ
</h2>

作成する設定を超えて、`~/.claude` はセッション中に Claude Code が書き込むデータを保持します。これらのファイルはプレーンテキストです。ツールを通過するすべてのものはディスク上のトランスクリプトに記録されます。ファイルコンテンツ、コマンド出力、貼り付けられたテキスト。

<h3 id="cleaned-up-automatically">
  自動的にクリーンアップされる
</h3>

以下のパス内のファイルは、[`cleanupPeriodDays`](/ja/settings#available-settings) より古い場合、起動時に削除されます。デフォルトは 30 日です。

| `~/.claude/` の下のパス                           | コンテンツ                                                                                |
| -------------------------------------------- | ------------------------------------------------------------------------------------ |
| `projects/<project>/<session>.jsonl`         | 完全な会話トランスクリプト：すべてのメッセージ、ツール呼び出し、ツール結果                                                |
| `projects/<project>/<session>/subagents/`    | [Subagent](/ja/sub-agents) 会話トランスクリプト。親セッショントランスクリプトが古くなると一緒に削除されます                  |
| `projects/<project>/<session>/tool-results/` | 大きなツール出力を別ファイルにこぼしたもの                                                                |
| `file-history/<session>/`                    | Claude が変更したファイルの編集前スナップショット。[チェックポイント復元](/ja/checkpointing)に使用                      |
| `plans/`                                     | [プランモード](/ja/permission-modes#analyze-before-you-edit-with-plan-mode)中に書き込まれたプランファイル |
| `debug/`                                     | セッションごとのデバッグログ。`--debug` で開始するか `/debug` を実行した場合のみ書き込まれます                            |
| `paste-cache/`、`image-cache/`                | 大きな貼り付けと添付画像のコンテンツ                                                                   |
| `session-env/`                               | セッションごとの環境メタデータ                                                                      |
| `tasks/`                                     | タスクツールによって書き込まれたセッションごとのタスクリスト                                                       |
| `shell-snapshots/`                           | Bash ツールによって使用されるキャプチャされたシェル環境。正常な終了時に削除されます。スイープはクラッシュ後に残されたものをクリアします。              |
| `backups/`                                   | 設定マイグレーション前に取得された `~/.claude.json` のタイムスタンプ付きコピー                                     |
| `feedback-bundles/`                          | `/feedback` によってサードパーティプロバイダーに書き込まれた編集済みトランスクリプトアーカイブ。Anthropic アカウントチームに送信するため      |
| `todos/`、`statsig/`、`logs/`                  | 古いバージョンのレガシーディレクトリ。現在は書き込まれません。スイープはコンテンツを削除してから空のディレクトリを削除します。                      |

<h3 id="kept-until-you-delete-them">
  削除するまで保持される
</h3>

以下のパスは自動クリーンアップの対象ではなく、無期限に保持されます。

| `~/.claude/` の下のパス     | コンテンツ                                                                                  |
| ---------------------- | -------------------------------------------------------------------------------------- |
| `history.jsonl`        | 入力したすべてのプロンプト（タイムスタンプとプロジェクトパス付き）。上矢印リコール用に使用                                          |
| `stats-cache.json`     | `/usage` で表示される集計トークンおよびコスト数                                                           |
| `remote-settings.json` | 組織の[サーバー管理設定](/ja/server-managed-settings)のキャッシュコピー。組織が設定を構成している場合のみ存在します。各起動時に更新されます。 |

その他の小さなキャッシュおよびロックファイルは、使用する機能に応じて表示され、削除しても安全です。

<h3 id="plaintext-storage">
  プレーンテキストストレージ
</h3>

トランスクリプトと履歴は保存時に暗号化されません。OS ファイルパーミッションのみが保護です。ツールが `.env` ファイルを読み込むか、コマンドが認証情報を出力する場合、その値は `projects/<project>/<session>.jsonl` に書き込まれます。露出を減らすには：

* `cleanupPeriodDays` を低くしてトランスクリプトの保持期間を短縮します
* [`CLAUDE_CODE_SKIP_PROMPT_HISTORY`](/ja/env-vars) 環境変数を設定して、任意のモードでトランスクリプトとプロンプト履歴の書き込みをスキップします。非対話型モードでは、代わりに `-p` と一緒に `--no-session-persistence` を渡すか、Agent SDK で `persistSession: false` を設定できます。
* [パーミッションルール](/ja/permissions)を使用して認証情報ファイルの読み込みを拒否します

<h3 id="clear-local-data">
  ローカルデータをクリアする
</h3>

`claude project purge` を実行して、1 つのプロジェクトに対して Claude Code が保持する状態を削除します。このコマンドには Claude Code v2.1.124 以降が必要です。以下を削除します：

* `projects/` の下のトランスクリプトと自動メモリ
* セッションごとの `tasks/`、`debug/`、`file-history/` エントリ
* `history.jsonl` の一致するプロンプト行
* `~/.claude.json` のプロジェクトエントリ

このコマンドは完全な削除計画を出力し、何かを削除する前に確認を求めます。

削除せずに計画をプレビューします：

```bash theme={null}
claude project purge ~/work/my-repo --dry-run
```

単一の確認プロンプトで削除します：

```bash theme={null}
claude project purge ~/work/my-repo
```

パスを省略して、対話型リストからプロジェクトを選択します。

スクリプトで使用するために確認プロンプトをスキップします：

```bash theme={null}
claude project purge ~/work/my-repo --yes
```

パスの代わりに `--all` を渡して、すべてのプロジェクトの状態を一度にパージします。これは `history.jsonl` をフィルタリングするのではなく完全に削除します。`-i` を渡して削除計画を一度に 1 つずつステップスルーします。

このコマンドは `shell-snapshots/` と `backups/` をそのままにしておきます。これらはプロジェクトスコープではないため、計画出力で警告します。指定されたパスに一致する状態がない場合、ステータス 1 で終了します。

上記のアプリケーションデータパスのいずれかを手動で削除することもできます。新しいセッションは影響を受けません。以下のテーブルは、過去のセッションで失うものを示しています。

| 削除                                                                                                                                                                                    | 失うもの                            |
| ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------- |
| `~/.claude/projects/`                                                                                                                                                                 | 過去のセッションの再開、続行、巻き戻し             |
| `~/.claude/history.jsonl`                                                                                                                                                             | 上矢印プロンプトリコール                    |
| `~/.claude/file-history/`                                                                                                                                                             | 過去のセッションのチェックポイント復元             |
| `~/.claude/stats-cache.json`                                                                                                                                                          | `/usage` で表示される履歴合計             |
| `~/.claude/remote-settings.json`                                                                                                                                                      | なし。次の起動時に再取得されます。               |
| `~/.claude/debug/`、`~/.claude/plans/`、`~/.claude/paste-cache/`、`~/.claude/image-cache/`、`~/.claude/session-env/`、`~/.claude/tasks/`、`~/.claude/shell-snapshots/`、`~/.claude/backups/` | ユーザー向けのもの                       |
| `~/.claude/todos/`、`~/.claude/statsig/`、`~/.claude/logs/`                                                                                                                             | なし。現在のバージョンでは書き込まれないレガシーディレクトリ。 |

`~/.claude.json`、`~/.claude/settings.json`、または `~/.claude/plugins/` は削除しないでください。これらは認証、設定、インストール済みプラグインを保持しています。

<h2 id="related-resources">
  関連リソース
</h2>

* [Claude のメモリを管理する](/ja/memory)：CLAUDE.md、rules、auto memory を書き込んで整理します
* [設定を構成する](/ja/settings)：パーミッション、hooks、環境変数、モデルデフォルトを設定します
* [Skills を作成する](/ja/skills)：再利用可能なプロンプトとワークフローを構築します
* [Subagents を構成する](/ja/sub-agents)：独自のコンテキストを持つ特化したエージェントを定義します
