# Claude Code 日本語ドキュメント

Claude Code公式ドキュメントの日本語版を自動更新・管理するリポジトリです。

## ドキュメント

日本語ドキュメントは [`docs-ja/`](docs-ja/index.md) を参照してください。

## 自動更新

- **ソース**: https://code.claude.com/docs/ja/
- **更新頻度**: 毎日 9:00 JST（GitHub Actions）
- **処理**: llms.txt解析 → 全ページダウンロード → 差分検知 → 自動コミット

## 更新ログ

<!-- UPDATE_LOG_START -->

<details>
<summary>2026-05-12</summary>

**変更ファイル:**

```
 docs-ja/pages/admin-setup-ja.md              |   3 +-
 docs-ja/pages/changelog.md                   |  53 +++
 docs-ja/pages/claude-directory-ja.md         |  46 +-
 docs-ja/pages/cli-reference-ja.md            |   8 +-
 docs-ja/pages/commands-ja.md                 |   7 +-
 docs-ja/pages/common-workflows-ja.md         | 684 ++++-----------------------
 docs-ja/pages/data-usage-ja.md               |  24 +-
 docs-ja/pages/env-vars-ja.md                 |  17 +-
 docs-ja/pages/fullscreen-ja.md               |   2 +
 docs-ja/pages/glossary-ja.md                 |  18 +-
 docs-ja/pages/hooks-guide-ja.md              |   4 +-
 docs-ja/pages/hooks-ja.md                    | 122 +++--
 docs-ja/pages/interactive-mode-ja.md         |  45 +-
 docs-ja/pages/keybindings-ja.md              |   2 +-
 docs-ja/pages/llm-gateway-ja.md              |  61 ++-
 docs-ja/pages/mcp-ja.md                      |  10 +-
 docs-ja/pages/memory-ja.md                   |  20 +-
 docs-ja/pages/model-config-ja.md             |   8 +-
 docs-ja/pages/monitoring-usage-ja.md         |  75 ++-
 docs-ja/pages/output-styles-ja.md            |   4 +-
 docs-ja/pages/overview-ja.md                 |   2 +-
 docs-ja/pages/permission-modes-ja.md         |  22 +-
 docs-ja/pages/permissions-ja.md              |   8 +-
 docs-ja/pages/plugins-reference-ja.md        |  78 ++-
 docs-ja/pages/quickstart-ja.md               |   4 +-
 docs-ja/pages/scheduled-tasks-ja.md          |  10 +-
 docs-ja/pages/settings-ja.md                 |   2 +
 docs-ja/pages/sub-agents-ja.md               |  14 +-
 docs-ja/pages/third-party-integrations-ja.md |  18 +-
 docs-ja/pages/tools-reference-ja.md          | 257 ++++++++--
 docs-ja/pages/vs-code-ja.md                  |  56 +--
 31 files changed, 842 insertions(+), 842 deletions(-)
```

**新規追加:**


<details>
<summary>admin-setup-ja.md</summary>

```diff
diff --git a/docs-ja/pages/admin-setup-ja.md b/docs-ja/pages/admin-setup-ja.md
index 64e4f81..118bc30 100644
--- a/docs-ja/pages/admin-setup-ja.md
+++ b/docs-ja/pages/admin-setup-ja.md
@@ -64,5 +64,5 @@ plist と HKLM レジストリの場所は任意のプロバイダーで機能
 ## 実行する内容を決定する
 
-マネージド設定は、ツール、サンドボックス実行、MCP サーバーとプラグインソースへのアクセスをロックダウンし、実行されるフックを制御できます。各行は、それを駆動する設定キーを持つ制御サーフェスです。
+マネージド設定は、ツール、サンドボックス実行、MCP サーバーとプラグインソースへのアクセスをロックダウンし、実行されるフック を制御できます。各行は、それを駆動する設定キーを持つ制御サーフェスです。
 
 | 制御                                                                                     | 機能                                                              | キー設定                                                                         |
@@ -75,4 +75,5 @@ plist と HKLM レジストリの場所は任意のプロバイダーで機能
 | [Plugin marketplace control](/ja/plugin-marketplaces#managed-marketplace-restrictions) | ユーザーが追加およびインストールできるマーケットプレイスソースを制限する                            | `strictKnownMarketplaces`、`blockedMarketplaces`                              |
 | [Hook restrictions](/ja/settings#hook-configuration)                                   | マネージドフックのみが読み込まれる。HTTP フック URL を制限する                            | `allowManagedHooksOnly`、`allowedHttpHookUrls`                                |
+| [Disable agent view](/ja/agent-view#how-background-sessions-are-hosted)                | `claude agents`、`--bg`、`/background`、およびオンデマンドスーパーバイザーをオフにする    | `disableAgentView`                                                           |
 | [Version floor](/ja/settings)                                                          | 自動更新が組織全体の最小値より下にインストールされるのを防ぐ                                  | `minimumVersion`                                                             |
 
```

</details>

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index 3e8bd69..af9c193 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,57 @@
 # Changelog
 
+## 2.1.139
+
+- Added agent view (Research Preview): a single list of every Claude Code session — running, blocked on you, or done. Run `claude agents` to get started. See https://code.claude.com/docs/en/agent-view
+- Added `/goal` command: set a completion condition and Claude keeps working across turns until it's met. Works in interactive, `-p`, and Remote Control. Shows live elapsed/turns/tokens as an overlay panel
+- Added `/scroll-speed` command to tune mouse wheel scroll speed with a live preview
+- Added `claude plugin details <name>` to show a plugin's component inventory and projected per-session token cost
+- Added transcript view navigation: `?` for keyboard shortcuts, `{`/`}` to jump between user prompts, `v` to toggle shortcut panel
+- Added hook `args: string[]` field (exec form) that spawns the command directly without a shell, so path placeholders never need quoting
+- Added hook `continueOnBlock` config option for `PostToolUse` — set to `true` to feed the hook's rejection reason back to Claude and continue the turn
+- MCP stdio servers now receive `CLAUDE_PROJECT_DIR` in their environment, matching hooks. Plugin configs can reference `${CLAUDE_PROJECT_DIR}` in commands
+- Compaction prompt now asks the model to preserve sensitive user instructions
+- `/mcp` Reconnect now picks up `.mcp.json` edits without a restart, and shows the HTTP status and URL when reconnecting fails
+- `/context all` per-skill token estimates now account for the model's tokenizer and show rounded values
+- `claude plugin install <name>@<marketplace>` now auto-refreshes the marketplace and retries before reporting a plugin as not found
+- `/plugin` installed-plugin details now show hook event names and MCP server names cleanly
+- `/context` now shows the providing plugin's name for plugin-sourced skills
+- Remote MCP server reconnect retry on transient failures is now enabled for all users
+- API requests from subagents now carry `x-claude-code-agent-id` / `x-claude-code-parent-agent-id` headers, and `claude_code.llm_request` OTEL spans include `agent_id` / `parent_agent_id` attributes
+- Remote Control, `/schedule`, claude.ai MCP connectors, and notification preferences are now disabled when `ANTHROPIC_API_KEY` / `apiKeyHelper` / `ANTHROPIC_AUTH_TOKEN` is set, even if a Claude.ai login also exists. Unset the API key to use these features
+- Fixed a deadlock where expired credentials and the `forceRemoteSettingsRefresh` policy setting blocked `claude auth login`/`logout`/`status` with no way to recover
+- Fixed `autoAllowBashIfSandboxed` not auto-approving commands with shell expansions like `$VAR` and `$(cmd)`
+- Fixed a bug where a hook writing to the terminal could corrupt an on-screen interactive prompt; hooks now run without terminal access
+- Fixed unbounded memory growth when an HTTP/SSE MCP server streams non-protocol data — response bodies now capped at 16 MB per SSE frame
```

</details>

<details>
<summary>claude-directory-ja.md</summary>

```diff
diff --git a/docs-ja/pages/claude-directory-ja.md b/docs-ja/pages/claude-directory-ja.md
index c270b4e..56d7d22 100644
--- a/docs-ja/pages/claude-directory-ja.md
+++ b/docs-ja/pages/claude-directory-ja.md
@@ -1465,21 +1465,21 @@ Windows では、`~/.claude` は `%USERPROFILE%\.claude` に解決されます
 ファイル名をクリックして、上記のエクスプローラーでそのノードを開きます。
 
-| ファイル                                                | スコープ           | コミット | 機能                                     | リファレンス                                                               |
-| --------------------------------------------------- | -------------- | ---- | -------------------------------------- | -------------------------------------------------------------------- |
-| [`CLAUDE.md`](#ce-claude-md)                        | プロジェクトおよびグローバル | ✓    | 毎セッション読み込まれる指示                         | [メモリ](/ja/memory)                                                    |
-| [`rules/*.md`](#ce-rules)                           | プロジェクトおよびグローバル | ✓    | トピックスコープの指示、オプションでパスゲート                | [ルール](/ja/memory#organize-rules-with-claude/rules/)                  |
-| [`settings.json`](#ce-settings-json)                | プロジェクトおよびグローバル | ✓    | パーミッション、hooks、環境変数、モデルデフォルト            | [設定](/ja/settings)                                                   |
-| [`settings.local.json`](#ce-settings-local-json)    | プロジェクトのみ       |      | 個人的なオーバーライド、自動 gitignore               | [設定スコープ](/ja/settings#settings-files)                                |
-| [`.mcp.json`](#ce-mcp-json)                         | プロジェクトのみ       | ✓    | チーム共有 MCP サーバー                         | [MCP スコープ](/ja/mcp#mcp-installation-scopes)                          |
-| [`.worktreeinclude`](#ce-worktreeinclude)           | プロジェクトのみ       | ✓    | 新しい worktrees にコピーする gitignore ファイル    | [Worktrees](/ja/common-workflows#copy-gitignored-files-to-worktrees) |
-| [`skills/<name>/SKILL.md`](#ce-skills)              | プロジェクトおよびグローバル | ✓    | `/name` で呼び出される、または自動呼び出される再利用可能なプロンプト | [Skills](/ja/skills)                                                 |
-| [`commands/*.md`](#ce-commands)                     | プロジェクトおよびグローバル | ✓    | シングルファイルプロンプト。skills と同じメカニズム          | [Skills](/ja/skills)                                                 |
-| [`output-styles/*.md`](#ce-output-styles)           | プロジェクトおよびグローバル | ✓    | カスタムシステムプロンプトセクション                     | [出力スタイル](/ja/output-styles)                                          |
-| [`agents/*.md`](#ce-agents)                         | プロジェクトおよびグローバル | ✓    | 独自のプロンプトとツールを持つ subagent 定義            | [Subagents](/ja/sub-agents)                                          |
-| [`agent-memory/<name>/`](#ce-agent-memory)          | プロジェクトおよびグローバル | ✓    | subagents の永続メモリ                       | [永続メモリ](/ja/sub-agents#enable-persistent-memory)                     |
-| [`~/.claude.json`](#ce-claude-json)                 | グローバルのみ        |      | アプリ状態、OAuth、UI トグル、個人 MCP サーバー         | [グローバル設定](/ja/settings#global-config-settings)                       |
-| [`projects/<project>/memory/`](#ce-global-projects) | グローバルのみ        |      | Auto memory：Claude のセッション間のメモ          | [Auto memory](/ja/memory#auto-memory)                                |
-| [`keybindings.json`](#ce-keybindings)               | グローバルのみ        |      | カスタムキーボードショートカット                       | [キーバインディング](/ja/keybindings)                                         |
-| [`themes/*.json`](#ce-themes)                       | グローバルのみ        |      | カスタムカラーテーマ                             | [カスタムテーマ](/ja/terminal-config#create-a-custom-theme)                 |
+| ファイル                                                | スコープ           | コミット | 機能                                     | リファレンス                                                          |
+| --------------------------------------------------- | -------------- | ---- | -------------------------------------- | --------------------------------------------------------------- |
+| [`CLAUDE.md`](#ce-claude-md)                        | プロジェクトおよびグローバル | ✓    | 毎セッション読み込まれる指示                         | [メモリ](/ja/memory)                                               |
+| [`rules/*.md`](#ce-rules)                           | プロジェクトおよびグローバル | ✓    | トピックスコープの指示、オプションでパスゲート                | [ルール](/ja/memory#organize-rules-with-claude/rules/)             |
+| [`settings.json`](#ce-settings-json)                | プロジェクトおよびグローバル | ✓    | パーミッション、hooks、環境変数、モデルデフォルト            | [設定](/ja/settings)                                              |
+| [`settings.local.json`](#ce-settings-local-json)    | プロジェクトのみ       |      | 個人的なオーバーライド、自動 gitignore               | [設定スコープ](/ja/settings#settings-files)                           |
```

</details>

<details>
<summary>cli-reference-ja.md</summary>

```diff
diff --git a/docs-ja/pages/cli-reference-ja.md b/docs-ja/pages/cli-reference-ja.md
index c81bcc0..de6df18 100644
--- a/docs-ja/pages/cli-reference-ja.md
+++ b/docs-ja/pages/cli-reference-ja.md
@@ -25,11 +25,16 @@
 | `claude auth logout`            | Anthropic アカウントからログアウト                                                                                                                                                                                                                                                                                         | `claude auth logout`                                        |
 | `claude auth status`            | 認証ステータスを JSON として表示します。`--text` を使用して人間が読める形式で表示できます。ログイン済みの場合はコード 0 で終了し、ログインしていない場合は 1 で終了します                                                                                                                                                                                                                | `claude auth status`                                        |
-| `claude agents`                 | すべての設定済み [subagents](/ja/sub-agents) をソース別にグループ化して一覧表示                                                                                                                                                                                                                                                         | `claude agents`                                             |
+| `claude agents`                 | [エージェントビュー](/ja/agent-view) を開いて、並列バックグラウンドセッションを監視およびディスパッチします。出力がパイプされている場合は、代わりに設定済み [subagents](/ja/sub-agents) を一覧表示します                                                                                                                                                                                   | `claude agents`                                             |
+| `claude attach <id>`            | このターミナルで [バックグラウンドセッション](/ja/agent-view#manage-sessions-from-the-shell) に接続します                                                                                                                                                                                                                                 | `claude attach 7c5dcf5d`                                    |
 | `claude auto-mode defaults`     | 組み込み [auto mode](/ja/permission-modes#eliminate-prompts-with-auto-mode) 分類器ルールを JSON として出力します。`claude auto-mode config` を使用して、設定が適用された有効な設定を確認してください                                                                                                                                                           | `claude auto-mode defaults > rules.json`                    |
+| `claude logs <id>`              | [バックグラウンドセッション](/ja/agent-view#manage-sessions-from-the-shell) からの最近の出力を出力します                                                                                                                                                                                                                                  | `claude logs 7c5dcf5d`                                      |
 | `claude mcp`                    | Model Context Protocol（MCP）サーバーを設定                                                                                                                                                                                                                                                                             | [Claude Code MCP ドキュメント](/ja/mcp) を参照してください。                |
 | `claude plugin`                 | Claude Code [plugins](/ja/plugins) を管理します。エイリアス：`claude plugins`。サブコマンドについては [plugin reference](/ja/plugins-reference#cli-commands-reference) を参照してください                                                                                                                                                        | `claude plugin install code-review@claude-plugins-official` |
 | `claude project purge [path]`   | プロジェクトのすべてのローカル Claude Code 状態を削除します：トランスクリプト、タスクリスト、デバッグログ、ファイル編集履歴、プロンプト履歴行、および `~/.claude.json` 内のプロジェクトエントリ。`[path]` を省略して、インタラクティブリストから選択します。フラグ：`--dry-run` でプレビュー、`-y`/`--yes` で確認をスキップ、`-i`/`--interactive` で各項目を確認、`--all` ですべてのプロジェクト。[ローカルデータをクリア](/ja/claude-directory#clear-local-data) を参照してください | `claude project purge ~/work/repo --dry-run`                |
 | `claude remote-control`         | [Remote Control](/ja/remote-control) サーバーを開始して、Claude.ai または Claude アプリから Claude Code を制御します。サーバーモード（ローカルインタラクティブセッションなし）で実行されます。[サーバーモードフラグ](/ja/remote-control#start-a-remote-control-session) を参照してください                                                                                                     | `claude remote-control --name "My Project"`                 |
+| `claude respawn <id>`           | 会話を保持したまま、停止した [バックグラウンドセッション](/ja/agent-view#manage-sessions-from-the-shell) を再開します。`--all` を使用してすべての停止したセッションを再開します                                                                                                                                                                                          | `claude respawn 7c5dcf5d`                                   |
+| `claude rm <id>`                | [バックグラウンドセッション](/ja/agent-view#manage-sessions-from-the-shell) をリストから削除します                                                                                                                                                                                                                                     | `claude rm 7c5dcf5d`                                        |
 | `claude setup-token`            | CI とスクリプト用の長期間有効な OAuth トークンを生成します。ターミナルにトークンを出力し、保存しません。Claude サブスクリプションが必要です。[長期間有効なトークンを生成](/ja/authentication#generate-a-long-lived-token) を参照してください                                                                                                                                                       | `claude setup-token`                                        |
+| `claude stop <id>`              | [バックグラウンドセッション](/ja/agent-view#manage-sessions-from-the-shell) を停止します。`claude kill` も受け入れます                                                                                                                                                                                                                    | `claude stop 7c5dcf5d`                                      |
 | `claude ultrareview [target]`   | [ultrareview](/ja/ultrareview#run-ultrareview-non-interactively) を非対話的に実行します。結果を stdout に出力し、成功時は 0 で終了し、失敗時は 1 で終了します。`--json` を使用して生のペイロードを取得し、`--timeout <minutes>` を使用して 30 分のデフォルトをオーバーライドできます                                                                                                            | `claude ultrareview 1234 --json`                            |
 
@@ -51,4 +56,5 @@
 | `--bare`                                        | 最小限モード：hooks、skills、plugins、MCP サーバー、自動メモリ、CLAUDE.md の自動検出をスキップして、スクリプト化された呼び出しをより高速に開始します。Claude は Bash、ファイル読み取り、ファイル編集ツールにアクセスできます。[`CLAUDE_CODE_SIMPLE`](/ja/env-vars) を設定します。[bare mode](/ja/headless#start-faster-with-bare-mode) を参照してください                                                                            | `claude --bare -p "query"`                                                                         |
 | `--betas`                                       | API リクエストに含めるベータヘッダー（API キーユーザーのみ）                                                                                                                                                                                                                                                                                          | `claude --betas interleaved-thinking`                                                              |
+| `--bg`                                          | セッションを [バックグラウンドエージェント](/ja/agent-view) として開始し、すぐに戻ります。セッション ID と管理コマンドを出力します。`--agent` と組み合わせて特定の subagent を実行します                                                                                                                                                                                                          | `claude --bg "investigate the flaky test"`                                                         |
 | `--channels`                                    | （研究プレビュー）Claude がこのセッションでリッスンすべき [channel](/ja/channels) 通知を持つ MCP サーバー。`plugin:<name>@<marketplace>` エントリのスペース区切りリスト。Claude.ai 認証が必要です                                                                                                                                                                                     | `claude --channels plugin:my-notifier@my-marketplace`                                              |
 | `--chrome`                                      | Web 自動化とテストのための [Chrome ブラウザ統合](/ja/chrome) を有効にします                                                                                                                                                                                                                                                                         | `claude --chrome`                                                                                  |
```

</details>

<details>
<summary>commands-ja.md</summary>

```diff
diff --git a/docs-ja/pages/commands-ja.md b/docs-ja/pages/commands-ja.md
index 48db7e5..ff8b82d 100644
--- a/docs-ja/pages/commands-ja.md
+++ b/docs-ja/pages/commands-ja.md
@@ -21,4 +21,6 @@
 **タスク中。** `/plan` は大きな変更の前に Plan Mode に切り替えます。`/model` と `/effort` は使用している推論量を調整します。会話が長くなったら、`/context` はウィンドウがどこに向かっているかを表示し、`/compact` はそれを要約します。`/btw` を使用して、履歴を膨らませるべきではない素早い脇道を作成します。
 
+**並行して作業を実行する。** `/agents` は Claude が副次的なタスクを委譲できる[サブエージェント](/ja/sub-agents)のマネージャーを開き、`/tasks` は現在のセッションのバックグラウンドで実行されているものをリストします。`/background` はセッション全体をデタッチして[バックグラウンドエージェント](/ja/agent-view)として実行し続け、ターミナルを解放します。コードベース全体にまたがる大きな変更の場合、`/batch` はそれを独立したユニットに分解し、各ユニットを独自の[worktree](/ja/worktrees)で実行します。これらのアプローチがどのように関連しているかについては、[エージェントを並行して実行する](/ja/agents)を参照してください。
+
 **リリース前。** `/diff` は変更内容を表示し、`/simplify` は最近のファイルをレビューして品質と効率の修正を適用し、`/review` または `/security-review` はより深い読み取り専用パスを提供します。
 
@@ -42,5 +44,5 @@
 | `/agents`                                       | [エージェント](/ja/sub-agents)設定を管理します                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
 | `/autofix-pr [prompt]`                          | 現在のブランチの PR を監視し、CI が失敗するか、レビュアーがコメントを残したときに修正をプッシュする [Claude Code on the web](/ja/claude-code-on-the-web#auto-fix-pull-requests) セッションを生成します。`gh pr view` で開いている PR を検出します。別の PR を監視するには、最初にそのブランチをチェックアウトしてください。デフォルトでは、リモートセッションはすべての CI 失敗とレビューコメントを修正するよう指示されます。プロンプトを渡して異なる指示を与えることができます。例えば `/autofix-pr only fix lint and type errors`。`gh` CLI と [Claude Code on the web](/ja/claude-code-on-the-web#who-can-use-claude-code-on-the-web) へのアクセスが必要です                                                  |
-| `/batch <instruction>`                          | **[スキル](/ja/skills#bundled-skills)。** コードベース全体にわたる大規模な変更を並列で調整します。コードベースを調査し、作業を 5 ～ 30 個の独立したユニットに分解し、計画を提示します。承認されると、分離された [git worktree](/ja/worktrees) 内の各ユニットごとに 1 つのバックグラウンドエージェントを生成します。各エージェントはそのユニットを実装し、テストを実行し、プルリクエストを開きます。git リポジトリが必要です。例: `/batch migrate src/ from Solid to React`                                                                                                                                                                                                             |
+| `/batch <instruction>`                          | **[スキル](/ja/skills#bundled-skills)。** コードベース全体にわたる大規模な変更を並列で調整します。コードベースを調査し、作業を 5 ～ 30 個の独立したユニットに分解し、計画を提示します。承認されると、分離された [git worktree](/ja/worktrees) 内の各ユニットごとに 1 つのバックグラウンドサブエージェントを生成します。各サブエージェントはそのユニットを実装し、テストを実行し、プルリクエストを開きます。git リポジトリが必要です。例: `/batch migrate src/ from Solid to React`                                                                                                                                                                                                         |
 | `/branch [name]`                                | この時点で現在の会話のブランチを作成します。ブランチに切り替え、元の会話を保持します。`/resume` で戻ることができます。エイリアス: `/fork`。[`CLAUDE_CODE_FORK_SUBAGENT`](/ja/env-vars) が設定されている場合、`/fork` は代わりに[フォークされたサブエージェント](/ja/sub-agents#fork-the-current-conversation)を生成し、このコマンドのエイリアスではなくなります                                                                                                                                                                                                                                                                    |
 | `/btw <question>`                               | 会話に追加せずに[サイドクエスチョン](/ja/interactive-mode#side-questions-with-%2Fbtw)として素早く質問します                                                                                                                                                                                                                                                                                                                                                                                                                                |
@@ -66,4 +68,5 @@
 | `/fewer-permission-prompts`                     | **[スキル](/ja/skills#bundled-skills)。** トランスクリプトで一般的な読み取り専用 Bash と MCP ツール呼び出しをスキャンし、プロジェクト `.claude/settings.json` に優先度付きの許可リストを追加して権限プロンプトを削減します                                                                                                                                                                                                                                                                                                                                                               |
 | `/focus`                                        | フォーカスビューを切り替えます。最後のプロンプト、編集 diffstats を含む 1 行のツール呼び出し要約、および最終応答のみを表示します。選択は複数セッション間で保持されます。設定で [`viewMode`](/ja/settings#available-settings) を設定してオーバーライドします。[フルスクリーンレンダリング](/ja/fullscreen)でのみ利用可能です                                                                                                                                                                                                                                                                                                          |
+| `/goal [condition\|clear]`                      | [目標](/ja/goal)を設定します。Claude は条件が満たされるまでターン間で作業を続けます。引数なしで、現在または最後に達成された目標を表示します。`clear`、`stop`、`off`、`reset`、`none`、または `cancel` はアクティブな目標を早期に削除します                                                                                                                                                                                                                                                                                                                                                            |
 | `/heapdump`                                     | JavaScript ヒープスナップショットとメモリ分析を `~/Desktop` に書き込んで、高いメモリ使用量を診断します。Linux で Desktop フォルダがない場合はホームディレクトリに書き込みます。[トラブルシューティング](/ja/troubleshooting#high-cpu-or-memory-usage)を参照してください                                                                                                                                                                                                                                                                                                                                |
 | `/help`                                         | ヘルプと利用可能なコマンドを表示します                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
@@ -101,4 +104,5 @@
 | `/sandbox`                                      | [サンドボックスモード](/ja/sandboxing)を切り替えます。サポートされているプラットフォームでのみ利用可能です                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
 | `/schedule [description]`                       | [ルーチン](/ja/routines)を作成、更新、リスト表示、または実行します。Claude がセットアップを会話形式でガイドします。エイリアス: `/routines`                                                                                                                                                                                                                                                                                                                                                                                                                        |
+| `/scroll-speed`                                 | マウスホイール[スクロール速度](/ja/fullscreen#mouse-wheel-scrolling)をインタラクティブに調整します。ダイアログが開いている間にスクロールできるルーラーで変更をプレビューできます。[フルスクリーンレンダリング](/ja/fullscreen)でのみ利用可能で、JetBrains IDE ターミナルでは利用できません                                                                                                                                                                                                                                                                                                                              |
 | `/security-review`                              | 現在のブランチの保留中の変更をセキュリティ脆弱性について分析します。git diff をレビューし、インジェクション、認証の問題、データ露出などのリスクを特定します                                                                                                                                                                                                                                                                                                                                                                                                                             |
 | `/setup-bedrock`                                | [Amazon Bedrock](/ja/amazon-bedrock) 認証、リージョン、モデルピンをインタラクティブウィザードで構成します。`CLAUDE_CODE_USE_BEDROCK=1` が設定されている場合のみ表示されます。初回 Bedrock ユーザーはログイン画面からこのウィザードにアクセスすることもできます                                                                                                                                                                                                                                                                                                                                           |
```

</details>

<details>
<summary>common-workflows-ja.md</summary>

```diff
diff --git a/docs-ja/pages/common-workflows-ja.md b/docs-ja/pages/common-workflows-ja.md
index 26283e8..0115bb6 100644
--- a/docs-ja/pages/common-workflows-ja.md
+++ b/docs-ja/pages/common-workflows-ja.md
@@ -7,9 +7,22 @@
 > Claude Code を使用してコードベースの探索、バグ修正、リファクタリング、テスト、その他の日常的なタスクを実行するためのステップバイステップガイド。
 
-このページでは、日常的な開発のための実践的なワークフローについて説明します。未知のコードの探索、デバッグ、リファクタリング、テストの作成、PR の作成、セッションの管理などです。各セクションには、自分のプロジェクトに適応させることができるプロンプトの例が含まれています。より高度なパターンとヒントについては、[ベストプラクティス](/ja/best-practices)を参照してください。
+このページでは、日常的な開発のための短いレシピを集めています。プロンプティングとコンテキスト管理に関する高度なガイダンスについては、[ベストプラクティス](/ja/best-practices)を参照してください。
 
-## 新しいコードベースを理解する
+このページでは以下をカバーしています：
 
-### コードベースの概要を素早く把握する
+* [プロンプトレシピ](#prompt-recipes)：コード探索、バグ修正、リファクタリング、テスト、PR、ドキュメント用
+* [以前の会話を再開する](#resume-previous-conversations)：タスクを複数回に分けて実行できるようにする
+* [worktree を使用して並列セッションを実行する](#run-parallel-sessions-with-worktrees)：同時編集が衝突しないようにする
+* [編集前に計画する](#plan-before-editing)：ディスクに変更を加える前に確認する
+* [研究を subagent に委譲する](#delegate-research-to-subagents)：メインコンテキストをクリーンに保つ
+* [Claude をスクリプトにパイプする](#pipe-claude-into-scripts)：CI とバッチ処理用
+
+## プロンプトレシピ
+
+これらは、未知のコード探索、デバッグ、リファクタリング、テスト作成、PR 作成などの日常的なタスク用のプロンプトパターンです。各パターンは任意の Claude Code サーフェスで機能します。プロジェクトに合わせて表現を調整してください。
+
+### 新しいコードベースを理解する
+
+#### コードベースの概要を素早く把握する
 
 新しいプロジェクトに参加したばかりで、その構造を素早く理解する必要があるとします。
```

</details>

*...以降省略*

</details>


<details>
<summary>2026-05-11</summary>

**変更ファイル:**

```
 docs-ja/pages/errors-ja.md      | 34 +++++++++++++++++++++++++++++++---
 docs-ja/pages/hooks-guide-ja.md | 34 ++++++++++++++++++++++++++++++++--
 docs-ja/pages/settings-ja.md    |  2 ++
 docs-ja/pages/skills-ja.md      |  4 ++--
 4 files changed, 67 insertions(+), 7 deletions(-)
```

<details>
<summary>errors-ja.md</summary>

```diff
diff --git a/docs-ja/pages/errors-ja.md b/docs-ja/pages/errors-ja.md
index 4779629..414f4be 100644
--- a/docs-ja/pages/errors-ja.md
+++ b/docs-ja/pages/errors-ja.md
@@ -25,4 +25,6 @@
 | `Request timed out`                                                                  | [サーバーエラー](#request-timed-out)、またはメッセージがインターネット接続に言及している場合は[ネットワーク](#unable-to-connect-to-api) |
 | `<model> is temporarily unavailable, so auto mode cannot determine the safety of...` | [サーバーエラー](#auto-mode-cannot-determine-the-safety-of-an-action)                                |
+| `Auto mode could not evaluate this action and is blocking it for safety`             | [サーバーエラー](#auto-mode-cannot-determine-the-safety-of-an-action)                                |
+| `Auto mode classifier transcript exceeded context window`                            | [サーバーエラー](#auto-mode-cannot-determine-the-safety-of-an-action)                                |
 | `You've hit your session limit` / `You've hit your weekly limit`                     | [使用制限](#youve-hit-your-session-limit)                                                         |
 | `Server is temporarily limiting requests`                                            | [使用制限](#server-is-temporarily-limiting-requests)                                              |
@@ -117,5 +119,9 @@ Request timed out
 ### Auto mode cannot determine the safety of an action
 
-[auto mode](/ja/permission-modes#eliminate-prompts-with-auto-mode)がアクションを分類するために使用するモデルがオーバーロードされているため、auto mode はそれをチェックなしで承認する代わりにアクションをブロックしました。
+[auto mode](/ja/permission-modes#eliminate-prompts-with-auto-mode)がアクションを分類するために使用するモデルが決定を生成できなかったため、auto mode はアクションを自動的に承認しませんでした。表示されるメッセージは、分類器が失敗した理由によって異なります。
+
+読み取り、検索、および作業ディレクトリ内の編集は分類器をスキップするため、これらすべてのケースで機能し続けます。
+
+分類器モデルがオーバーロードされている場合：
 
 ```text theme={null}
@@ -123,6 +129,4 @@ Request timed out
 ```
 
-読み取り、検索、および作業ディレクトリ内の編集は分類器をスキップするため、停止中も機能し続けます。
-
 **対応方法：**
 
@@ -131,4 +135,28 @@ Request timed out
```

</details>

<details>
<summary>hooks-guide-ja.md</summary>

```diff
diff --git a/docs-ja/pages/hooks-guide-ja.md b/docs-ja/pages/hooks-guide-ja.md
index 997f2d5..ea59109 100644
--- a/docs-ja/pages/hooks-guide-ja.md
+++ b/docs-ja/pages/hooks-guide-ja.md
@@ -471,6 +471,4 @@ Hook イベントは Claude Code のライフサイクルの特定のポイン
 | `SessionEnd`          | When a session terminates                                                                                                                              |
 
-複数の hooks がマッチする場合、それぞれが独自の結果を返します。決定については、Claude Code は最も制限的な答えを選択します。`PreToolUse` hook が `deny` を返すと、他が何を返すかに関わらず、ツール呼び出しがキャンセルされます。1 つの hook が `ask` を返すと、残りが `allow` を返しても、許可プロンプトが強制されます。`additionalContext` からのテキストはすべての hook から保持され、Claude に一緒に渡されます。
-
 各 hook には、それがどのように実行されるかを決定する `type` があります。ほとんどの hooks は `"type": "command"` を使用し、シェルコマンドを実行します。他の 4 つのタイプが利用可能です：
 
@@ -480,4 +478,36 @@ Hook イベントは Claude Code のライフサイクルの特定のポイン
 * `"type": "agent"`：ツールアクセス付きマルチターン検証。エージェント hooks は実験的であり、変更される可能性があります。[エージェントベースの hooks](#agent-based-hooks) を参照してください。
 
+### 複数の hooks からの結果を組み合わせる
+
+複数の hooks が同じイベントにマッチする場合、すべての hook のコマンドが完了してから Claude Code は結果をマージします。1 つの hook が `deny` を返しても、兄弟 hooks の実行は停止されません。1 つの hook の `deny` が別の hook の副作用を抑制することに依存しないでください。
+
+すべてのマッチングする hooks が完了した後、Claude Code はそれらの出力を組み合わせます。`PreToolUse` 許可決定については、最も制限的な答えが勝ちます：`deny` は `ask` をオーバーライドし、`ask` は `allow` をオーバーライドします。`additionalContext` からのテキストはすべての hook から保持され、Claude に一緒に渡されます。
+
+以下の例は `Bash` に 2 つの `PreToolUse` hooks を登録しています。最初のものはすべてのコマンドをログファイルに追加して 0 で終了します。2 番目のものはスクリプトを実行し、コマンドに `rm -rf` が含まれている場合は 2 で終了して拒否します：
+
+```json theme={null}
+{
+  "hooks": {
+    "PreToolUse": [
+      {
+        "matcher": "Bash",
+        "hooks": [
+          {
```

</details>

<details>
<summary>settings-ja.md</summary>

```diff
diff --git a/docs-ja/pages/settings-ja.md b/docs-ja/pages/settings-ja.md
index 85a546b..b72108e 100644
--- a/docs-ja/pages/settings-ja.md
+++ b/docs-ja/pages/settings-ja.md
@@ -207,4 +207,5 @@ Windows では、`~/.claude` として表示されるパスは `%USERPROFILE%\.c
 | `includeGitInstructions`          | Claude のシステムプロンプトに組み込みコミットおよび PR ワークフロー命令と git ステータススナップショットを含めます（デフォルト：`true`）。たとえば、独自の git ワークフロースキルを使用する場合は、これらの命令を削除するために `false` に設定します。`CLAUDE_CODE_DISABLE_GIT_INSTRUCTIONS` 環境変数が設定されている場合、この設定よりも優先されます                                                                                                                                                                             | `false`                                                                                                                         |
 | `language`                        | Claude の優先応答言語を構成します（例：`"japanese"`、`"spanish"`、`"french"`）。Claude はデフォルトでこの言語で応答します。また、[音声ディクテーション](/ja/voice-dictation#change-the-dictation-language)言語も設定します                                                                                                                                                                                                                              | `"japanese"`                                                                                                                    |
+| `maxSkillDescriptionChars`        | {/* min-version: 2.1.105 */}[スキルリスティング](/ja/skills#skill-descriptions-are-cut-short)Claude が各ターンで見る `description` と `when_to_use` テキストの結合されたスキルごとの文字上限（デフォルト：`1536`）。この長さより長いテキストは切り詰められます。長い説明を保持するために上げるか、より多くのスキルを [`skillListingBudgetFraction`](#available-settings)の下に収めるために下げます。Claude Code v2.1.105 以降が必要です                                                                          | `2048`                                                                                                                          |
 | `minimumVersion`                  | 背景自動更新と `claude update` が特定のバージョン以下にインストールするのを防止するフロア。`"latest"` チャネルから `"stable"` に `/config` を通じて切り替えると、現在のバージョンに留まるか、ダウングレードを許可するかを求めるプロンプトが表示されます。留まることを選択すると、この値が設定されます。また、[managed 設定](/ja/permissions#managed-settings)で組織全体の最小値をピンするのに役立ちます                                                                                                                                          | `"2.1.100"`                                                                                                                     |
 | `model`                           | Claude Code に使用するデフォルトモデルをオーバーライドします。`--model` と [`ANTHROPIC_MODEL`](/ja/model-config#environment-variables)はこれを 1 セッション間オーバーライドします                                                                                                                                                                                                                                                          | `"claude-sonnet-4-6"`                                                                                                           |
@@ -224,4 +225,5 @@ Windows では、`~/.claude` として表示されるパスは `%USERPROFILE%\.c
 | `showThinkingSummaries`           | [拡張思考](/ja/model-config#extended-thinking)サマリーをインタラクティブセッションに表示します。未設定または `false`（インタラクティブモードのデフォルト）の場合、思考ブロックは API によって編集され、折りたたまれたスタブとして表示されます。編集は表示内容のみを変更し、モデルが生成するものは変更しません：思考支出を削減するには、[予算を低下させるか思考を無効にする](/ja/model-config#extended-thinking)代わりに。非インタラクティブモード（`-p`）と SDK 呼び出し元は、この設定に関係なく常にサマリーを受け取ります                                                                               | `true`                                                                                                                          |
 | `showTurnDuration`                | レスポンス後のターン期間メッセージを表示します（例：「Cooked for 1m 6s」）。デフォルト：`true`。`/config` に**ターン期間を表示**として表示されます                                                                                                                                                                                                                                                                                                  | `false`                                                                                                                         |
+| `skillListingBudgetFraction`      | {/* min-version: 2.1.105 */}[スキルリスティング](/ja/skills#skill-descriptions-are-cut-short)Claude が各ターンで見るモデルのコンテキストウィンドウ用に予約されたフラクション（デフォルト：`0.01` = 1%）。リスティングが予算を超える場合、最も使用頻度の低いスキルの説明は、Claude が引き続き呼び出すことができるが理由を見ることができないように、ベアネームに折りたたまれます。より多くの説明を表示するために上げるか、より多くのスキルを収めるために下げます。`/doctor` は現在の切り詰めカウントと影響を受けるスキルを表示します。Claude Code v2.1.105 以降が必要です                                        | `0.02`                                                                                                                          |
 | `skillOverrides`                  | {/* min-version: 2.1.129 */}スキル名でキー付けされたスキルごとの可視性オーバーライド。値は `"on"`、`"name-only"`、`"user-invocable-only"`、または `"off"` です。スキルの SKILL.md を編集することなく、スキルを非表示または折りたたむことができます。プラグインスキルには適用されません。これらは `/plugin` を通じて管理されます。`/skills` メニューはこれらを `.claude/settings.local.json` に書き込みます。[設定からスキルの可視性をオーバーライド](/ja/skills#override-skill-visibility-from-settings)を参照してください。Claude Code v2.1.129 以降が必要です | `{"legacy-context": "name-only", "deploy": "off"}`                                                                              |
 | `skipWebFetchPreflight`           | [WebFetch ドメイン安全チェック](/ja/data-usage#webfetch-domain-safety-check)をスキップします。このチェックは、フェッチ前に各リクエストされたホスト名を `api.anthropic.com` に送信します。Bedrock、Vertex AI、または制限的な出力を持つ Foundry デプロイメントなど、Anthropic へのトラフィックをブロックする環境で `true` に設定します。スキップされた場合、WebFetch はブロックリストを参照せずに任意の URL を試みます                                                                                                                | `true`                                                                                                                          |
```

</details>

<details>
<summary>skills-ja.md</summary>

```diff
diff --git a/docs-ja/pages/skills-ja.md b/docs-ja/pages/skills-ja.md
index 47de823..21a6874 100644
--- a/docs-ja/pages/skills-ja.md
+++ b/docs-ja/pages/skills-ja.md
@@ -753,7 +753,7 @@ Claude がスキルを使用したくない場合：
 ### スキルの説明が短縮される
 
-スキルの説明がコンテキストに読み込まれるため、Claude は利用可能なものを知っています。すべてのスキル名は常に含まれていますが、多くのスキルがある場合、説明は文字予算に合わせて短縮される可能性があり、Claude が一致するために必要なキーワードを削除できます。予算はコンテキストウィンドウの 1% で動的にスケーリングされ、8,000 文字のフォールバックがあります。
+スキルの説明がコンテキストに読み込まれるため、Claude は利用可能なものを知っています。すべてのスキル名は常に含まれていますが、多くのスキルがある場合、説明は文字予算に合わせて短縮される可能性があり、Claude が一致するために必要なキーワードを削除できます。予算はモデルのコンテキストウィンドウの 1% でスケーリングされます。オーバーフローすると、最も呼び出しが少ないスキルの説明が最初に削除され、実際に使用するスキルは完全なテキストを保持します。`/doctor` を実行して、予算がオーバーフローしているかどうか、どのスキルが影響を受けているかを確認します。
 
-制限を上げるには、`SLASH_COMMAND_TOOL_CHAR_BUDGET` 環境変数を設定します。他のスキルの予算を解放するには、[`skillOverrides`](#override-skill-visibility-from-settings) で低優先度のエントリを `"name-only"` に設定して、説明なしでリストアップします。ソースで `description` と `when_to_use` テキストをトリミングすることもできます。各エントリの組み合わせテキストは予算に関係なく 1,536 文字でキャップされているため、主要なユースケースを前置きしてください。
+予算を上げるには、[`skillListingBudgetFraction`](/ja/settings#available-settings) 設定（例：`0.02` = 2%）または `SLASH_COMMAND_TOOL_CHAR_BUDGET` 環境変数を固定文字数に設定します。他のスキルの予算を解放するには、[`skillOverrides`](#override-skill-visibility-from-settings) で低優先度のエントリを `"name-only"` に設定して、説明なしでリストアップします。ソースで `description` と `when_to_use` テキストをトリミングすることもできます。各エントリの組み合わせテキストは予算に関係なく 1,536 文字でキャップされているため、主要なユースケースを前置きしてください。キャップは [`maxSkillDescriptionChars`](/ja/settings#available-settings) で設定可能です。
 
 ## 関連リソース
```

</details>

</details>


<details>
<summary>2026-05-10</summary>

**変更ファイル:**

```
 docs-ja/pages/auto-mode-config-ja.md        |  27 +++--
 docs-ja/pages/changelog.md                  |   4 +
 docs-ja/pages/commands-ja.md                | 171 ++++++++++++++--------------
 docs-ja/pages/env-vars-ja.md                |   2 +
 docs-ja/pages/errors-ja.md                  |  16 +++
 docs-ja/pages/interactive-mode-ja.md        |   2 +-
 docs-ja/pages/mcp-ja.md                     |   2 +
 docs-ja/pages/permissions-ja.md             |   7 ++
 docs-ja/pages/plugins-reference-ja.md       |  11 +-
 docs-ja/pages/routines-ja.md                |  10 +-
 docs-ja/pages/security-ja.md                |   2 +-
 docs-ja/pages/server-managed-settings-ja.md |   5 +-
 docs-ja/pages/settings-ja.md                |  29 ++++-
 13 files changed, 183 insertions(+), 105 deletions(-)
```

<details>
<summary>auto-mode-config-ja.md</summary>

```diff
diff --git a/docs-ja/pages/auto-mode-config-ja.md b/docs-ja/pages/auto-mode-config-ja.md
index 5a1d229..88d9241 100644
--- a/docs-ja/pages/auto-mode-config-ja.md
+++ b/docs-ja/pages/auto-mode-config-ja.md
@@ -40,5 +40,5 @@
 分類器は `.claude/settings.json` の共有プロジェクト設定から `autoMode` を読み込まないため、チェックインされたリポジトリは独自の許可ルールを注入できません。
 
-各スコープのエントリは結合されます。開発者は個人エントリで `environment`、`allow`、`soft_deny` を拡張できますが、管理設定が提供するエントリを削除することはできません。許可ルールは分類器内のブロックルールの例外として機能するため、開発者が追加した `allow` エントリは組織の `soft_deny` エントリをオーバーライドできます。組み合わせは加算的であり、ハードポリシー境界ではありません。
+各スコープのエントリは結合されます。開発者は個人エントリで `environment`、`allow`、`soft_deny`、および `hard_deny` を拡張できますが、管理設定が提供するエントリを削除することはできません。許可ルールは分類器内のソフトブロックルールの例外として機能するため、開発者が追加した `allow` エントリは組織の `soft_deny` エントリをオーバーライドできます。組み合わせは加算的であり、ハードポリシー境界ではありません。
 
 <Note>
@@ -100,15 +100,16 @@
 ## ブロックルールと許可ルールをオーバーライドする
 
-2 つの追加フィールドを使用すると、分類器の組み込みルールリストを置き換えることができます。`autoMode.soft_deny` はブロックされる内容を制御し、`autoMode.allow` は適用される例外を制御します。各フィールドは散文説明の配列であり、自然言語ルールとして読み込まれます。`autoMode.deny` フィールドはありません。意図に関係なくアクションをハードブロックするには、分類器の前に実行される [`permissions.deny`](/ja/permissions) を使用します。
+3 つの追加フィールドを使用すると、分類器の組み込みルールリストを置き換えることができます。`autoMode.hard_deny` は無条件のセキュリティ境界用、`autoMode.soft_deny` はユーザーの意図でクリアできる破壊的なアクション用、`autoMode.allow` は例外用です。各フィールドは散文説明の配列であり、自然言語ルールとして読み込まれます。分類器の前に実行されるツールパターンベースのハードブロックについては、[`permissions.deny`](/ja/permissions) を使用します。
 
-分類器内では、優先順位は 3 つのレベルで機能します。
+分類器内では、優先順位は 4 つのレベルで機能します。
 
-* `soft_deny` ルールが最初にブロック
-* `allow` ルールが一致するブロックを例外としてオーバーライド
-* 明示的なユーザーの意図が両方をオーバーライド。ユーザーのメッセージが Claude が実行しようとしている正確なアクションを直接かつ具体的に説明する場合、`soft_deny` ルールが一致しても分類器はそれを許可します
+* `hard_deny` ルールは無条件にブロックします。ユーザーの意図と `allow` 例外は適用されません。
+* `soft_deny` ルールが次にブロックします。ユーザーの意図と `allow` 例外はこれらをオーバーライドできます。
+* `allow` ルールは一致する `soft_deny` ルールを例外としてオーバーライドします。
+* 明示的なユーザーの意図が残りのソフトブロックをオーバーライドします。ユーザーのメッセージが Claude が実行しようとしている正確なアクションを直接かつ具体的に説明する場合、`soft_deny` ルールが一致しても分類器はそれを許可します。
 
 一般的なリクエストは明示的な意図としてカウントされません。Claude に「リポジトリをクリーンアップする」ように依頼することは force push を認可しませんが、「このブランチを force push する」ように依頼することは認可します。
 
```

</details>

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index 60efa10..3e8bd69 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,8 @@
 # Changelog
 
+## 2.1.138
+
+- Internal fixes
+
 ## 2.1.137
 
```

</details>

<details>
<summary>commands-ja.md</summary>

```diff
diff --git a/docs-ja/pages/commands-ja.md b/docs-ja/pages/commands-ja.md
index e218299..48db7e5 100644
--- a/docs-ja/pages/commands-ja.md
+++ b/docs-ja/pages/commands-ja.md
@@ -37,89 +37,90 @@
 </Note>
 
-| コマンド                                            | 目的                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
-| :---------------------------------------------- | :----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
-| `/add-dir <path>`                               | 現在のセッション中にファイルアクセス用の作業ディレクトリを追加。ほとんどの `.claude/` 設定は追加されたディレクトリから[検出されません](/ja/permissions#additional-directories-grant-file-access-not-configuration)。後で `--continue` または `--resume` を使用して、追加されたディレクトリからセッションを再開できます                                                                                                                                                                                                                                                                                        |
-| `/agents`                                       | [エージェント](/ja/sub-agents)設定を管理                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
-| `/autofix-pr [prompt]`                          | 現在のブランチの PR を監視し、CI が失敗するか、レビュアーがコメントを残したときに修正をプッシュする [Claude Code on the web](/ja/claude-code-on-the-web#auto-fix-pull-requests) セッションを生成。`gh pr view` で開いている PR を検出します。別の PR を監視するには、最初にそのブランチをチェックアウトしてください。デフォルトでは、リモートセッションはすべての CI 失敗とレビューコメントを修正するよう指示されます。プロンプトを渡して異なる指示を与えることができます。例えば `/autofix-pr only fix lint and type errors`。`gh` CLI と [Claude Code on the web](/ja/claude-code-on-the-web#who-can-use-claude-code-on-the-web) へのアクセスが必要です                                                   |
-| `/batch <instruction>`                          | **[スキル](/ja/skills#bundled-skills)。** コードベース全体にわたる大規模な変更を並列で調整します。コードベースを調査し、作業を 5 ～ 30 個の独立したユニットに分解し、計画を提示します。承認されると、分離された [git worktree](/ja/worktrees) 内の各ユニットごとに 1 つのバックグラウンドエージェントを生成します。各エージェントはそのユニットを実装し、テストを実行し、プルリクエストを開きます。git リポジトリが必要です。例: `/batch migrate src/ from Solid to React`                                                                                                                                                                                                           |
-| `/branch [name]`                                | この時点で現在の会話のブランチを作成。ブランチに切り替え、元の会話を保持します。`/resume` で戻ることができます。エイリアス: `/fork`。[`CLAUDE_CODE_FORK_SUBAGENT`](/ja/env-vars) が設定されている場合、`/fork` は代わりに[フォークされたサブエージェント](/ja/sub-agents#fork-the-current-conversation)を生成し、このコマンドのエイリアスではなくなります                                                                                                                                                                                                                                                                     |
-| `/btw <question>`                               | 会話に追加せずに[サイドクエスチョン](/ja/interactive-mode#side-questions-with-%2Fbtw)として素早く質問                                                                                                                                                                                                                                                                                                                                                                                                                                 |
-| `/chrome`                                       | [Chrome の Claude](/ja/chrome) 設定を構成                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
-| `/claude-api [migrate\|managed-agents-onboard]` | **[スキル](/ja/skills#bundled-skills)。** プロジェクトの言語（Python、TypeScript、Java、Go、Ruby、C#、PHP、または cURL）と Managed Agents リファレンス用の Claude API リファレンス資料を読み込みます。ツール使用、ストリーミング、バッチ、構造化出力、および一般的な落とし穴をカバーしています。また、コードが `anthropic` または `@anthropic-ai/sdk` をインポートするときに自動的にアクティブになります。`/claude-api migrate` を実行して、既存の Claude API コードを新しいモデルにアップグレード: Claude はスキャンするファイルとターゲットモデルを尋ね、モデル ID、思考設定、およびバージョン間で変更されたその他のパラメータを更新します。`/claude-api managed-agents-onboard` を実行して、新しい Managed Agent をゼロから作成するインタラクティブなウォークスルーを実施します |
-| `/clear`                                        | 空のコンテキストで新しい会話を開始。前の会話は `/resume` で利用可能なままです。同じ会話を続けながらコンテキストを解放するには、代わりに `/compact` を使用してください。エイリアス: `/reset`、`/new`                                                                                                                                                                                                                                                                                                                                                                                        |
-| `/color [color\|default]`                       | 現在のセッションのプロンプトバーの色を設定。利用可能な色: `red`、`blue`、`green`、`yellow`、`purple`、`orange`、`pink`、`cyan`。`default` を使用してリセット。引数なしで実行するとランダムな色を選択します。[リモートコントロール](/ja/remote-control)が接続されている場合、色は claude.ai/code に同期されます                                                                                                                                                                                                                                                                                                  |
-| `/compact [instructions]`                       | 会話をここまで要約してコンテキストを解放。オプションで要約のフォーカス指示を渡します。[コンパクション時にルール、スキル、メモリファイルがどのように処理されるか](/ja/context-window#what-survives-compaction)を参照してください                                                                                                                                                                                                                                                                                                                                                                      |
-| `/config`                                       | [設定](/ja/settings)インターフェースを開いて、テーマ、モデル、[出力スタイル](/ja/output-styles)、およびその他の設定を調整。エイリアス: `/settings`                                                                                                                                                                                                                                                                                                                                                                                                           |
-| `/context`                                      | 現在のコンテキスト使用状況をカラーグリッドとして視覚化。コンテキストが多いツール、メモリ肥大化、容量警告の最適化提案を表示                                                                                                                                                                                                                                                                                                                                                                                                                                                |
-| `/copy [N]`                                     | 最後のアシスタント応答をクリップボードにコピー。数字 `N` を渡して N 番目に新しい応答をコピー: `/copy 2` は 2 番目に新しい応答をコピー。コードブロックが存在する場合、個別ブロックまたは完全な応答を選択するインタラクティブピッカーを表示。ピッカーで `w` を押して、クリップボードの代わりにファイルに選択内容を書き込み。SSH 経由で便利です                                                                                                                                                                                                                                                                                                                       |
-| `/cost`                                         | `/usage` のエイリアス                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
-| `/debug [description]`                          | **[スキル](/ja/skills#bundled-skills)。** 現在のセッションのデバッグログを有効にし、セッションデバッグログを読むことで問題をトラブルシューティングします。デバッグログはデフォルトではオフです。`claude --debug` で開始した場合を除き、セッション中に `/debug` を実行するとその時点からログのキャプチャを開始します。オプションで問題を説明して分析にフォーカスを当てます                                                                                                                                                                                                                                                                                          |
-| `/desktop`                                      | 現在のセッションを Claude Code デスクトップアプリで続行。macOS と Windows のみ。エイリアス: `/app`                                                                                                                                                                                                                                                                                                                                                                                                                                          |
-| `/diff`                                         | コミットされていない変更と各ターンの diff を表示するインタラクティブ diff ビューアを開きます。左右矢印を使用して現在の git diff と個別の Claude ターンを切り替え、上下矢印でファイルをブラウズします                                                                                                                                                                                                                                                                                                                                                                                            |
-| `/doctor`                                       | Claude Code のインストールと設定を診断および検証。結果はステータスアイコン付きで表示されます。`f` を押して Claude に報告された問題を修正させます                                                                                                                                                                                                                                                                                                                                                                                                                         |
-| `/effort [level\|auto]`                         | モデルの[努力レベル](/ja/model-config#adjust-effort-level)を設定。`low`、`medium`、`high`、`xhigh`、または `max` を受け入れます。利用可能なレベルはモデルに依存し、`max` はセッションのみです。`auto` はモデルのデフォルトにリセットします。引数なしで、インタラクティブスライダーを開きます。左右矢印でレベルを選択し、`Enter` で適用します。現在の応答の完了を待たずに即座に有効になります                                                                                                                                                                                                                                                                |
-| `/exit`                                         | CLI を終了。エイリアス: `/quit`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
```

</details>

<details>
<summary>env-vars-ja.md</summary>

```diff
diff --git a/docs-ja/pages/env-vars-ja.md b/docs-ja/pages/env-vars-ja.md
index 1e078de..039d7dd 100644
--- a/docs-ja/pages/env-vars-ja.md
+++ b/docs-ja/pages/env-vars-ja.md
@@ -117,4 +117,5 @@ Claude Code は、その動作を制御するために以下の環境変数を
 | `CLAUDE_CODE_MAX_TOOL_USE_CONCURRENCY`                  | 並列実行できる読み取り専用ツールと subagent の最大数（デフォルト：10）。高い値は並列性を増加させますが、より多くのリソースを消費します                                                                                                                                                                                                                                                                                                                                                      |
 | `CLAUDE_CODE_MCP_ALLOWLIST_ENV`                         | stdio MCP サーバーをシェル環境を継承する代わりに、安全なベースライン環境とサーバーの設定された `env` のみでスポーンするには `1` に設定します                                                                                                                                                                                                                                                                                                                                              |
+| `CLAUDE_CODE_NATIVE_CURSOR`                             | ターミナル独自のカーソルを入力キャレットに表示するには `1` に設定します。描画されたブロックの代わりに。カーソルはターミナルのまばたき、形状、フォーカス設定を尊重します                                                                                                                                                                                                                                                                                                                                         |
 | `CLAUDE_CODE_NEW_INIT`                                  | `/init` が対話的なセットアップフローを実行するようにするには `1` に設定します。フローは、CLAUDE.md、スキル、フックを含む、生成するファイルを尋ねてから、コードベースを探索して書き込みます。この変数がない場合、`/init` はプロンプトなしに CLAUDE.md を自動的に生成します。                                                                                                                                                                                                                                                                     |
 | `CLAUDE_CODE_NO_FLICKER`                                | [フルスクリーンレンダリング](/ja/fullscreen) を有効にするには `1` に設定します。これは研究プレビューで、フリッカーを減らし、長い会話でメモリをフラットに保ちます。[`tui`](/ja/settings#available-settings) 設定と同等です。`/tui fullscreen` で切り替えることもできます                                                                                                                                                                                                                                                  |
@@ -192,4 +193,5 @@ Claude Code は、その動作を制御するために以下の環境変数を
 | `DISABLE_UPDATES`                                       | すべての更新をブロックするには `1` に設定します。手動の `claude update` と `claude install` を含みます。`DISABLE_AUTOUPDATER` より厳密です。Claude Code を独自のチャネルを通じて配布し、ユーザーが自己更新すべきでない場合に使用します                                                                                                                                                                                                                                                                       |
 | `DISABLE_UPGRADE_COMMAND`                               | `/upgrade` コマンドを非表示にするには `1` に設定します                                                                                                                                                                                                                                                                                                                                                                                            |
+| `DO_NOT_TRACK`                                          | テレメトリをオプトアウトするには `1` に設定します。`DISABLE_TELEMETRY` を設定するのと同等です。[標準クロスツール規約](https://consoledonottrack.com/) として尊重されます                                                                                                                                                                                                                                                                                                             |
 | `ENABLE_CLAUDEAI_MCP_SERVERS`                           | Claude Code で [claude.ai MCP サーバー](/ja/mcp#use-mcp-servers-from-claude-ai) を無効にするには `false` に設定します。ログインしているユーザーではデフォルトで有効です                                                                                                                                                                                                                                                                                                    |
 | `ENABLE_PROMPT_CACHING_1H`                              | API キー、[Bedrock](/ja/amazon-bedrock)、[Vertex](/ja/google-vertex-ai)、[Foundry](/ja/microsoft-foundry) ユーザーの場合、デフォルトの 5 分の代わりに 1 時間のプロンプトキャッシュ TTL をリクエストするには `1` に設定します。サブスクリプションユーザーは 1 時間の TTL を自動的に受け取ります。1 時間キャッシュ書き込みはより高いレートで請求されます                                                                                                                                                                                       |
```

</details>

<details>
<summary>errors-ja.md</summary>

```diff
diff --git a/docs-ja/pages/errors-ja.md b/docs-ja/pages/errors-ja.md
index d9c5e3d..4779629 100644
--- a/docs-ja/pages/errors-ja.md
+++ b/docs-ja/pages/errors-ja.md
@@ -32,4 +32,5 @@
 | `Invalid API key`                                                                    | [認証](#invalid-api-key)                                                                        |
 | `This organization has been disabled`                                                | [認証](#this-organization-has-been-disabled)                                                    |
+| `Routines are disabled by your organization's policy`                                | [認証](#routines-are-disabled-by-your-organizations-policy)                                     |
 | `OAuth token revoked` / `OAuth token has expired`                                    | [認証](#oauth-token-revoked-or-expired)                                                         |
 | `does not meet scope requirement user:profile`                                       | [認証](#oauth-scope-requirement)                                                                |
@@ -253,4 +254,19 @@ API Error: 400 ... This organization has been disabled.
 * 環境変数が設定されておらず、エラーが続く場合、無効な組織は `/login` に関連付けられているものです。サポートに連絡するか、別のアカウントでサインインしてください。
 
+### Routines are disabled by your organization's policy
+
+チームまたはエンタープライズ管理者が、組織レベルでルーチンをオフにしています。エラーは、`/schedule` および claude.ai/code の [Routines](/ja/routines) UI を含め、ルーチンを作成または実行しようとするときに表示されます。
+
+```text theme={null}
+Routines are disabled by your organization's policy.
+```
+
+これはサーバー側の設定であるため、ローカル設定、環境変数、または CLI フラグからオーバーライドすることはできません。
+
+**対応方法：**
+
+* 管理者に [claude.ai/admin-settings/claude-code](https://claude.ai/admin-settings/claude-code) で **Routines** トグルを有効にするよう依頼してください
+* 組織レベルのルーチンを必要としない 1 回限りのスケジュール済み作業については、[スケジュール済みタスク](/ja/scheduled-tasks)を参照してください
+
 ### OAuth token revoked or expired
 
```

</details>

<details>
<summary>interactive-mode-ja.md</summary>

```diff
diff --git a/docs-ja/pages/interactive-mode-ja.md b/docs-ja/pages/interactive-mode-ja.md
index cc0d611..42cfa91 100644
--- a/docs-ja/pages/interactive-mode-ja.md
+++ b/docs-ja/pages/interactive-mode-ja.md
@@ -290,5 +290,5 @@ Bash モード：
 Claude が応答した後、マルチパートリクエストのフォローアップステップや、ワークフローの自然な継続など、会話履歴に基づいて提案が表示され続けます。
 
-* **Tab** または **Right arrow** を押して提案を受け入れるか、**Enter** を押して受け入れて送信
+* **Tab** または **Right arrow** を押して提案をプロンプト入力に配置してから、**Enter** を押して送信
 * 入力を開始して却下
 
```

</details>

<details>
<summary>mcp-ja.md</summary>

```diff
diff --git a/docs-ja/pages/mcp-ja.md b/docs-ja/pages/mcp-ja.md
index 90382ce..2271b72 100644
--- a/docs-ja/pages/mcp-ja.md
+++ b/docs-ja/pages/mcp-ja.md
@@ -264,4 +264,6 @@ claude mcp add --transport http secure-api https://api.example.com/mcp \
 ```
 
+MCP サーバーを `.mcp.json`、`~/.claude.json`、または `claude mcp add-json` で JSON を使用して設定する場合、`type` フィールドは `http` のエイリアスとして `streamable-http` を受け入れます。MCP 仕様ではこのトランスポートに `streamable-http` という名前を使用しているため、サーバードキュメントからコピーされた設定は変更なしで機能します。
+
 ### オプション 2：リモート SSE サーバーを追加する
 
```

</details>

<details>
<summary>permissions-ja.md</summary>

```diff
diff --git a/docs-ja/pages/permissions-ja.md b/docs-ja/pages/permissions-ja.md
index 8ded97f..b4d1fd9 100644
--- a/docs-ja/pages/permissions-ja.md
+++ b/docs-ja/pages/permissions-ja.md
@@ -211,4 +211,11 @@ Windows では、パスはマッチング前に POSIX 形式に正規化され
 * `Read(src/**)`: `<current-directory>/src/` から読み取ります
 
+ルールはそのアンカーの下のファイルのみをマッチさせるため、アンカーは deny ルールがどこまで到達するかを決定します。ベアファイル名は gitignore セマンティクスに従い、任意の深さでマッチするため、`Read(.env)` と `Read(**/.env)` は同等です。
+
+| Deny ルール                         | ブロック                    | ブロックしない                       |
+| -------------------------------- | ----------------------- | ----------------------------- |
+| `Read(.env)` または `Read(**/.env)` | 現在のディレクトリ以下の任意の `.env`  | 親ディレクトリまたは別のプロジェクト内の `.env`   |
+| `Read(//**/.env)`                | ファイルシステム上の任意の場所の `.env` | なし。ルールはファイルシステムルートにアンカーされています |
+
 <Note>
   gitignore パターンでは、`*` は単一のディレクトリ内のファイルをマッチさせ、`**` はディレクトリ全体で再帰的にマッチさせます。すべてのファイルアクセスを許可するには、括弧なしでツール名を使用します。`Read`、`Edit`、または `Write`。
```

</details>

<details>
<summary>plugins-reference-ja.md</summary>

```diff
diff --git a/docs-ja/pages/plugins-reference-ja.md b/docs-ja/pages/plugins-reference-ja.md
index e0364d1..e278347 100644
--- a/docs-ja/pages/plugins-reference-ja.md
+++ b/docs-ja/pages/plugins-reference-ja.md
@@ -424,5 +424,5 @@ monitors をインラインで宣言するには、`plugin.json` の `experiment
 | フィールド                   | 型                     | 説明                                                                                                                  | 例                                                    |
 | :---------------------- | :-------------------- | :------------------------------------------------------------------------------------------------------------------ | :--------------------------------------------------- |
-| `skills`                | string\|array         | `<name>/SKILL.md` を含むカスタム skill ディレクトリ（デフォルト `skills/` を置き換え）                                                       | `"./custom/skills/"`                                 |
+| `skills`                | string\|array         | `<name>/SKILL.md` を含むカスタム skill ディレクトリ（デフォルト `skills/` に加えて）                                                        | `"./custom/skills/"`                                 |
 | `commands`              | string\|array         | カスタムフラット `.md` skill ファイルまたはディレクトリ（デフォルト `commands/` を置き換え）                                                         | `"./custom/cmd.md"` または `["./cmd1.md"]`              |
 | `agents`                | string\|array         | カスタムエージェントファイル（デフォルト `agents/` を置き換え）                                                                               | `"./custom/agents/reviewer.md"`                      |
@@ -511,10 +511,15 @@ monitors をインラインで宣言するには、`plugin.json` の `experiment
 ### パス動作ルール
 
-`skills`、`commands`、`agents`、`outputStyles`、`experimental.themes`、`experimental.monitors` の場合、カスタムパスはデフォルトを置き換えます。マニフェストが `skills` を指定する場合、デフォルト `skills/` ディレクトリはスキャンされません。`experimental.monitors` を指定する場合、デフォルト `monitors/monitors.json` は読み込まれません。[Hooks](#hooks)、[MCP servers](#mcp-servers)、[LSP servers](#lsp-servers)は複数のソースを処理するための異なるセマンティクスを持ちます。
+カスタムパスがプラグインのデフォルトディレクトリを置き換えるか拡張するかは、フィールドによって異なります:
+
+* **デフォルトを置き換える**: `commands`、`agents`、`outputStyles`、`experimental.themes`、`experimental.monitors`。たとえば、マニフェストが `commands` を指定する場合、デフォルト `commands/` ディレクトリはスキャンされません。デフォルトを保持してさらに追加するには、明示的にリストします: `"commands": ["./commands/", "./extras/"]`
+* **デフォルトに追加**: `skills`。デフォルト `skills/` ディレクトリは常にスキャンされ、`skills` にリストされているディレクトリはそれと一緒に読み込まれます
+* **独自のマージルール**: [hooks](#hooks)、[MCP servers](#mcp-servers)、[LSP servers](#lsp-servers)。各セクションで複数のソースがどのように結合されるかを参照してください
+
+すべてのパスフィールドについて:
 
 * すべてのパスはプラグインルートに相対的で、`./` で始まる必要があります
 * カスタムパスからのコンポーネントは同じ命名と名前空間ルールを使用します
 * 複数のパスを配列として指定できます
-* skills、commands、agents、output styles のデフォルトディレクトリを保持してさらにパスを追加するには、配列にデフォルトを含めます: `"skills": ["./skills/", "./extras/"]`
 * skill パスが `SKILL.md` を直接含むディレクトリを指す場合（例: `"skills": ["./"]` がプラグインルートを指す）、`SKILL.md` の frontmatter `name` フィールドが skill の呼び出し名を決定します。これはインストールディレクトリに関係なく安定した名前を提供します。frontmatter に `name` が設定されていない場合、ディレクトリ basename がフォールバックとして使用されます。
 
```

</details>

*...以降省略*

</details>


<details>
<summary>2026-05-09</summary>

**変更ファイル:**

```
 docs-ja/pages/agent-teams-ja.md       |   2 +-
 docs-ja/pages/changelog.md            |  59 ++++
 docs-ja/pages/cli-reference-ja.md     |   4 +-
 docs-ja/pages/commands-ja.md          |  22 +-
 docs-ja/pages/desktop-ja.md           |  17 +
 docs-ja/pages/env-vars-ja.md          | 452 ++++++++++++------------
 docs-ja/pages/features-overview-ja.md |   2 +-
 docs-ja/pages/hooks-ja.md             |  21 +-
 docs-ja/pages/overview-ja.md          | 636 +--------------------------------
 docs-ja/pages/plugins-ja.md           |  10 +-
 docs-ja/pages/quickstart-ja.md        | 639 +---------------------------------
 docs-ja/pages/settings-ja.md          |  14 +-
 docs-ja/pages/setup-ja.md             |   2 +
 docs-ja/pages/sub-agents-ja.md        |   6 +-
 docs-ja/pages/terminal-config-ja.md   |   2 +-
 docs-ja/pages/vs-code-ja.md           |   2 +-
 16 files changed, 367 insertions(+), 1523 deletions(-)
```

<details>
<summary>agent-teams-ja.md</summary>

```diff
diff --git a/docs-ja/pages/agent-teams-ja.md b/docs-ja/pages/agent-teams-ja.md
index f457bb0..691d350 100644
--- a/docs-ja/pages/agent-teams-ja.md
+++ b/docs-ja/pages/agent-teams-ja.md
@@ -421,4 +421,4 @@ tmux kill-session -t <session-name>
 
 * **軽量委任**：[subagents](/ja/sub-agents) はセッション内で調査または検証用のヘルパーエージェントを生成し、エージェント間調整が必要ないタスクに適しています
-* **手動並列セッション**：[Git worktrees](/ja/common-workflows#run-parallel-claude-code-sessions-with-git-worktrees) を使用すると、自動チーム調整なしで複数の Claude Code セッションを自分で実行できます
+* **手動並列セッション**：[Git worktrees](/ja/worktrees) を使用すると、自動チーム調整なしで複数の Claude Code セッションを自分で実行できます
 * **アプローチを比較**：[subagent とエージェントチーム](/ja/features-overview#compare-similar-features)の比較を参照して、並べて比較してください
```

</details>

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index 32b662b..60efa10 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,63 @@
 # Changelog
 
+## 2.1.137
+
+- [VSCode] Fixed extension failing to activate on Windows
+
+## 2.1.136
+
+- Added `CLAUDE_CODE_ENABLE_FEEDBACK_SURVEY_FOR_OTEL` to re-enable the session quality survey for enterprises capturing responses through OpenTelemetry
+- Added `settings.autoMode.hard_deny` for auto mode classifier rules that block unconditionally regardless of user intent or allow exceptions
+- Fixed MCP servers configured in `.mcp.json`, plugins, and claude.ai connectors silently disappearing after `/clear` in the VS Code extension, JetBrains plugin, and Agent SDK
+- Fixed a rare login loop where a concurrent credential write could overwrite a freshly-rotated OAuth token and force re-login
+- Fixed MCP OAuth refresh tokens being lost when multiple servers refresh concurrently — users with several remote MCP servers should no longer need daily re-authentication
+- Fixed an API error (400) when extended thinking emitted a redacted thinking block after a tool call
+- Fixed `--resume` / `--continue` not finding sessions when the project path contains underscores
+- Fixed plan mode not blocking file writes when a matching `Edit(...)` allow rule exists
+- WSL2: image paste from Windows clipboard now works via a PowerShell fallback when xclip/wl-paste cannot read image data
+- Fixed plugin `Stop`/`UserPromptSubmit` hooks failing when cache cleanup deletes a version still in use by a running session
+- Improved visual consistency across slash command dialogs: standardized footer hints, dialog spacing, and arrow-key styling, and the dialog frame now appears immediately during loading instead of popping in after
+- Fixed colors appearing at wrong positions in bash command output and markdown code blocks
+- Fixed ReasonML diffs rendering corrupted "undefined" text artifacts at word-diff boundaries
+- Fixed worktree exit dialog warning about uncommitted files in the wrong directory after worktree removal
+- Fixed `@` file picker not matching files created mid-session in small non-git directories
+- Fixed `@`-mention file picker not finding files in directories with more than 100 entries
+- Fixed failed tool calls not being click-to-expand in fullscreen mode when their output was truncated
```

</details>

<details>
<summary>cli-reference-ja.md</summary>

```diff
diff --git a/docs-ja/pages/cli-reference-ja.md b/docs-ja/pages/cli-reference-ja.md
index a7190a9..c81bcc0 100644
--- a/docs-ja/pages/cli-reference-ja.md
+++ b/docs-ja/pages/cli-reference-ja.md
@@ -85,5 +85,5 @@
 | `--permission-prompt-tool`                      | 非インタラクティブモードで権限プロンプトを処理する MCP ツールを指定します                                                                                                                                                                                                                                                                                     | `claude -p --permission-prompt-tool mcp_auth_tool "query"`                                         |
 | `--plugin-dir`                                  | このセッションのみのプラグインをディレクトリまたは `.zip` アーカイブから読み込みます。各フラグは 1 つのパスを取ります。複数のプラグインの場合はフラグを繰り返します：`--plugin-dir A --plugin-dir B.zip`                                                                                                                                                                                                 | `claude --plugin-dir ./my-plugin`                                                                  |
-| `--plugin-url`                                  | このセッションのみのプラグイン `.zip` アーカイブを URL から取得します。各フラグは 1 つの URL を取ります。複数のプラグインの場合はフラグを繰り返します                                                                                                                                                                                                                                       | `claude --plugin-url https://example.com/plugin.zip`                                               |
+| `--plugin-url`                                  | このセッションのみのプラグイン `.zip` アーカイブを URL から取得します。複数のプラグインの場合はフラグを繰り返すか、スペース区切りの URL を単一の引用符で囲まれた値で渡します                                                                                                                                                                                                                             | `claude --plugin-url https://example.com/plugin.zip`                                               |
 | `--print`, `-p`                                 | インタラクティブモードなしで応答を出力します（プログラムによる使用の詳細については [Agent SDK ドキュメント](/ja/agent-sdk/overview) を参照）                                                                                                                                                                                                                                   | `claude -p "query"`                                                                                |
 | `--remote`                                      | 提供されたタスク説明で claude.ai に新しい [Web セッション](/ja/claude-code-on-the-web) を作成します                                                                                                                                                                                                                                                   | `claude --remote "Fix the login bug"`                                                              |
@@ -104,5 +104,5 @@
 | `--verbose`                                     | 詳細ログを有効にし、ターンごとの完全な出力を表示します。このセッションの [`viewMode`](/ja/settings#available-settings) 設定をオーバーライドします                                                                                                                                                                                                                            | `claude --verbose`                                                                                 |
 | `--version`, `-v`                               | バージョン番号を出力します                                                                                                                                                                                                                                                                                                               | `claude -v`                                                                                        |
-| `--worktree`, `-w`                              | Claude を `<repo>/.claude/worktrees/<name>` の分離された [git worktree](/ja/worktrees) で開始します。名前が指定されていない場合は、自動生成されます                                                                                                                                                                                                              | `claude -w feature-auth`                                                                           |
+| `--worktree`, `-w`                              | Claude を `<repo>/.claude/worktrees/<name>` の分離された [git worktree](/ja/worktrees) で開始します。名前が指定されていない場合は、自動生成されます。`#<number>` または GitHub プルリクエスト URL を渡して、`origin` からその PR をフェッチし、worktree をそこからブランチします                                                                                                                        | `claude -w feature-auth`                                                                           |
 
 ### システムプロンプトフラグ
```

</details>

<details>
<summary>commands-ja.md</summary>

```diff
diff --git a/docs-ja/pages/commands-ja.md b/docs-ja/pages/commands-ja.md
index 98542ab..e218299 100644
--- a/docs-ja/pages/commands-ja.md
+++ b/docs-ja/pages/commands-ja.md
@@ -13,10 +13,28 @@
 コマンドはメッセージの開始時にのみ認識されます。コマンド名の後に続くテキストは引数として渡されます。
 
-以下の表は Claude Code に含まれるすべてのコマンドをリストしています。**[スキル](/ja/skills#bundled-skills)** とマークされたエントリはバンドルされたスキルです。これらは自分で作成するスキルと同じメカニズムを使用します。Claude に渡されるプロンプトであり、Claude は関連する場合に自動的に呼び出すこともできます。その他はすべて、CLI にコード化された動作を持つ組み込みコマンドです。独自のコマンドを追加するには、[スキル](/ja/skills)を参照してください。
+## 典型的なワークフロー全体でのコマンド
+
+ほとんどのコマンドはセッション内の特定の時点で有用です。プロジェクトのセットアップから変更のリリースまでです。
+
+**リポジトリでの最初のセッション。** `/init` を実行してスターター `CLAUDE.md` を生成し、その後 `/memory` を実行して改善します。`/mcp` と `/agents` を使用してプロジェクトが必要とするサーバーまたはサブエージェントをセットアップし、`/permissions` を使用して必要な承認ルールを設定します。
+
+**タスク中。** `/plan` は大きな変更の前に Plan Mode に切り替えます。`/model` と `/effort` は使用している推論量を調整します。会話が長くなったら、`/context` はウィンドウがどこに向かっているかを表示し、`/compact` はそれを要約します。`/btw` を使用して、履歴を膨らませるべきではない素早い脇道を作成します。
+
+**リリース前。** `/diff` は変更内容を表示し、`/simplify` は最近のファイルをレビューして品質と効率の修正を適用し、`/review` または `/security-review` はより深い読み取り専用パスを提供します。
 
-すべてのコマンドがすべてのユーザーに表示されるわけではありません。可用性はプラットフォーム、プラン、環境によって異なります。たとえば、`/desktop` は macOS と Windows にのみ表示され、`/upgrade` は Pro プランと Max プランにのみ表示されます。
+**セッション間。** `/clear` は新しいタスクで新しく開始しながらプロジェクトメモリを保持します。`/resume` と `/branch` を使用して、以前の会話に戻るか、フォークできます。`/teleport` はウェブセッションをこのターミナルに引き込み、`/remote-control` を使用してこのローカルセッションを別のデバイスから続行できます。
+
+**何か問題がある場合。** `/rewind` はコードと会話をチェックポイントに巻き戻します。`/doctor` と `/debug` はインストールとランタイムの問題を診断し、`/feedback` はセッションコンテキストが添付されたバグを報告します。
+
+## すべてのコマンド
+
+以下の表は Claude Code に含まれるすべてのコマンドをリストしています。**[スキル](/ja/skills#bundled-skills)** とマークされたエントリはバンドルされたスキルです。これらは自分で作成するスキルと同じメカニズムを使用します。Claude に渡されるプロンプトであり、Claude は関連する場合に自動的に呼び出すこともできます。その他はすべて、CLI にコード化された動作を持つ組み込みコマンドです。独自のコマンドを追加するには、[スキル](/ja/skills)を参照してください。
 
 以下の表では、`<arg>` は必須引数を示し、`[arg]` はオプション引数を示します。
 
+<Note>
```

</details>

<details>
<summary>desktop-ja.md</summary>

```diff
diff --git a/docs-ja/pages/desktop-ja.md b/docs-ja/pages/desktop-ja.md
index 24cc374..a5ebd8a 100644
--- a/docs-ja/pages/desktop-ja.md
+++ b/docs-ja/pages/desktop-ja.md
@@ -565,4 +565,20 @@ SSH 接続を追加するには、セッションを開始する前に環境ド
 各エントリには `id`、`name`、および `sshHost` が必要です。`sshPort`、`sshIdentityFile`、および `startDirectory` フィールドはオプションです。ユーザーは、ダイアログを通じて追加された接続が保存される独自の `~/.claude/settings.json` に `sshConfigs` を追加することもできます。
 
+#### ユーザーが接続できる SSH ホストを制限する
+
+管理者は、[管理設定](/ja/settings#settings-precedence)ファイルに `sshHostAllowlist` を追加することで、Desktop の SSH セッションを承認されたホストのセットに制限できます。設定されると、ユーザーは解決されたホスト名がパターンの 1 つと一致するホストにのみ接続できます。SSH セッションを完全に無効にするには、空の配列に設定します。
+
+次の例は、`devboxes.example.com` の下のすべてのホストと、単一の名前付きバスティオンホストへの接続を許可しています：
+
+```json theme={null}
+{
+  "sshHostAllowlist": ["*.devboxes.example.com", "bastion.example.com"]
+}
+```
+
+パターンは大文字と小文字を区別しません。`*` はすべてのホストと一致し、`*.example.com` は `example.com` とすべてのサブドメインと一致します。その他はすべて完全一致です。チェックは `ssh -G` を経由した `~/.ssh/config` 解決後のホスト名に対して実行されるため、`Host` エイリアスと `ProxyCommand`/`ProxyJump` エントリは、解決された `HostName` が一致する限り許可されます。
+
+`sshHostAllowlist` は管理設定からのみ読み取られます。ユーザーまたはプロジェクト設定の値は無視されます。Claude Desktop アプリのみがこの設定を尊重します。Claude Code CLI と IDE 拡張機能はこれを読み取らず、Bash ツールを通じて実行される `ssh` コマンドを制限しません。これは Desktop アプリが接続するホストを管理し、ネットワーク出力ではないため、ハード境界が必要な場合は組織のネットワークまたはゼロトラストコントロールと組み合わせてください。
+
 ## エンタープライズ設定
 
@@ -588,4 +604,5 @@ Team または Enterprise プランの組織は、管理コンソールコント
 | `autoMode`                                 | 組織全体で auto mode 分類器が信頼およびブロックするものをカスタマイズします。[auto mode を設定する](/ja/auto-mode-config)を参照してください。                                                       |
 | `sshConfigs`                               | 環境ドロップダウンに表示される[SSH 接続](#pre-configure-ssh-connections-for-your-team)を事前設定します。ユーザーは管理接続を編集または削除できません。                                               |
+| `sshHostAllowlist`                         | [SSH セッション](#restrict-which-ssh-hosts-users-can-connect-to)を、解決されたホスト名がこれらのパターンのいずれかと一致するホストに制限します。空の配列は SSH セッションを無効にします。管理設定からのみ読み取られます。          |
 
```

</details>

<details>
<summary>env-vars-ja.md</summary>

```diff
diff --git a/docs-ja/pages/env-vars-ja.md b/docs-ja/pages/env-vars-ja.md
index 6a52fc6..1e078de 100644
--- a/docs-ja/pages/env-vars-ja.md
+++ b/docs-ja/pages/env-vars-ja.md
@@ -9,229 +9,231 @@
 Claude Code は、その動作を制御するために以下の環境変数をサポートしています。`claude` を起動する前にシェルで設定するか、[`settings.json`](/ja/settings#available-settings) の `env` キーで設定して、すべてのセッションに適用するか、チーム全体にロールアウトしてください。
 
-| 変数                                                      | 目的                                                                                                                                                                                                                                                                                                                                                                                                                    |
-| :------------------------------------------------------ | :-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
-| `ANTHROPIC_API_KEY`                                     | `X-Api-Key` ヘッダーとして送信される API キー。設定されている場合、ログインしていても Claude Pro、Max、Team、または Enterprise サブスクリプションの代わりにこのキーが使用されます。非対話モード（`-p`）では、キーが存在する場合は常に使用されます。対話モードでは、キーがサブスクリプションをオーバーライドする前に一度承認するよう求められます。代わりにサブスクリプションを使用するには、`unset ANTHROPIC_API_KEY` を実行してください                                                                                                                                                            |
-| `ANTHROPIC_AUTH_TOKEN`                                  | `Authorization` ヘッダーのカスタム値（ここで設定した値には `Bearer ` が接頭辞として付けられます）                                                                                                                                                                                                                                                                                                                                                        |
-| `ANTHROPIC_BASE_URL`                                    | API エンドポイントをオーバーライドして、プロキシまたはゲートウェイを通じてリクエストをルーティングします。ファーストパーティ以外のホストに設定されている場合、[MCP ツール検索](/ja/mcp#scale-with-mcp-tool-search) はデフォルトで無効になります。プロキシが `tool_reference` ブロックを転送する場合は、`ENABLE_TOOL_SEARCH=true` を設定してください                                                                                                                                                                                               |
-| `ANTHROPIC_BEDROCK_BASE_URL`                            | Bedrock エンドポイント URL をオーバーライドします。カスタム Bedrock エンドポイントを使用する場合、または [LLM ゲートウェイ](/ja/llm-gateway) を通じてルーティングする場合に使用します。[Amazon Bedrock](/ja/amazon-bedrock) を参照してください                                                                                                                                                                                                                                                     |
-| `ANTHROPIC_BEDROCK_MANTLE_BASE_URL`                     | Bedrock Mantle エンドポイント URL をオーバーライドします。[Mantle エンドポイント](/ja/amazon-bedrock#use-the-mantle-endpoint) を参照してください                                                                                                                                                                                                                                                                                                         |
-| `ANTHROPIC_BEDROCK_SERVICE_TIER`                        | Bedrock [サービスティア](https://docs.aws.amazon.com/bedrock/latest/userguide/service-tiers-inference.html)（`default`、`flex`、または `priority`）。`X-Amzn-Bedrock-Service-Tier` ヘッダーとして送信されます。[Amazon Bedrock](/ja/amazon-bedrock#service-tiers) を参照してください                                                                                                                                                                        |
-| `ANTHROPIC_BETAS`                                       | API リクエストに含める追加の `anthropic-beta` ヘッダー値のカンマ区切りリスト。Claude Code は既に必要なベータヘッダーを送信しています。Claude Code がネイティブサポートを追加する前に、[Anthropic API ベータ](https://platform.claude.com/docs/en/api/beta-headers) にオプトインするために使用します。API キー認証が必要な [`--betas` フラグ](/ja/cli-reference#cli-flags) とは異なり、この変数は Claude.ai サブスクリプションを含むすべての認証方法で機能します                                                                                               |
-| `ANTHROPIC_CUSTOM_HEADERS`                              | リクエストに追加するカスタムヘッダー（`Name: Value` 形式、複数のヘッダーの場合は改行で区切られます）                                                                                                                                                                                                                                                                                                                                                             |
-| `ANTHROPIC_CUSTOM_MODEL_OPTION`                         | `/model` ピッカーにカスタムエントリとして追加するモデル ID。組み込みエイリアスを置き換えずに、非標準またはゲートウェイ固有のモデルを選択可能にするために使用します。[モデル設定](/ja/model-config#add-a-custom-model-option) を参照してください                                                                                                                                                                                                                                                                 |
-| `ANTHROPIC_CUSTOM_MODEL_OPTION_DESCRIPTION`             | `/model` ピッカーのカスタムモデルエントリの表示説明。設定されていない場合、デフォルトは `Custom model (<model-id>)` です                                                                                                                                                                                                                                                                                                                                       |
-| `ANTHROPIC_CUSTOM_MODEL_OPTION_NAME`                    | `/model` ピッカーのカスタムモデルエントリの表示名。設定されていない場合、デフォルトはモデル ID です                                                                                                                                                                                                                                                                                                                                                              |
-| `ANTHROPIC_CUSTOM_MODEL_OPTION_SUPPORTED_CAPABILITIES`  | [モデル設定](/ja/model-config#customize-pinned-model-display-and-capabilities) を参照してください                                                                                                                                                                                                                                                                                                                                   |
-| `ANTHROPIC_DEFAULT_HAIKU_MODEL`                         | [モデル設定](/ja/model-config#environment-variables) を参照してください                                                                                                                                                                                                                                                                                                                                                             |
-| `ANTHROPIC_DEFAULT_HAIKU_MODEL_DESCRIPTION`             | [モデル設定](/ja/model-config#customize-pinned-model-display-and-capabilities) を参照してください                                                                                                                                                                                                                                                                                                                                   |
-| `ANTHROPIC_DEFAULT_HAIKU_MODEL_NAME`                    | [モデル設定](/ja/model-config#customize-pinned-model-display-and-capabilities) を参照してください                                                                                                                                                                                                                                                                                                                                   |
-| `ANTHROPIC_DEFAULT_HAIKU_MODEL_SUPPORTED_CAPABILITIES`  | [モデル設定](/ja/model-config#customize-pinned-model-display-and-capabilities) を参照してください                                                                                                                                                                                                                                                                                                                                   |
-| `ANTHROPIC_DEFAULT_OPUS_MODEL`                          | [モデル設定](/ja/model-config#environment-variables) を参照してください                                                                                                                                                                                                                                                                                                                                                             |
-| `ANTHROPIC_DEFAULT_OPUS_MODEL_DESCRIPTION`              | [モデル設定](/ja/model-config#customize-pinned-model-display-and-capabilities) を参照してください                                                                                                                                                                                                                                                                                                                                   |
-| `ANTHROPIC_DEFAULT_OPUS_MODEL_NAME`                     | [モデル設定](/ja/model-config#customize-pinned-model-display-and-capabilities) を参照してください                                                                                                                                                                                                                                                                                                                                   |
-| `ANTHROPIC_DEFAULT_OPUS_MODEL_SUPPORTED_CAPABILITIES`   | [モデル設定](/ja/model-config#customize-pinned-model-display-and-capabilities) を参照してください                                                                                                                                                                                                                                                                                                                                   |
-| `ANTHROPIC_DEFAULT_SONNET_MODEL`                        | [モデル設定](/ja/model-config#environment-variables) を参照してください                                                                                                                                                                                                                                                                                                                                                             |
```

</details>

<details>
<summary>features-overview-ja.md</summary>

```diff
diff --git a/docs-ja/pages/features-overview-ja.md b/docs-ja/pages/features-overview-ja.md
index 1dae4a0..d15b86b 100644
--- a/docs-ja/pages/features-overview-ja.md
+++ b/docs-ja/pages/features-overview-ja.md
@@ -250,5 +250,5 @@ Claude Code は、コードについて推論するモデルと、ファイル
     **コンテキストコスト：** 使用されるまで低い。ユーザーのみのスキルは呼び出されるまでゼロコストです。
 
-    **Subagents 内：** スキルは subagents で異なる動作をします。オンデマンドロードの代わりに、subagent に渡されるスキルは起動時にそのコンテキストに完全にプリロードされます。Subagents はメインセッションからスキルを継承しません。明示的に指定する必要があります。
+    **Subagents 内：** スキルは subagents で異なる動作をします。オンデマンドロードの代わりに、subagent の `skills` フィールドにリストされているスキルは起動時にそのコンテキストに完全にプリロードされます。Subagents はスキルツールを通じて、リストされていないプロジェクト、ユーザー、プラグインスキルを発見して呼び出すことができます。
 
     <Tip>副作用を持つスキルには `disable-model-invocation: true` を使用します。これはコンテキストを節約し、あなたのみがそれらをトリガーすることを保証します。</Tip>
```

</details>

*...以降省略*

</details>


<details>
<summary>2026-05-08</summary>

**変更ファイル:**

```
 docs-ja/pages/amazon-bedrock-ja.md           | 130 +++---------------------
 docs-ja/pages/authentication-ja.md           |  13 ++-
 docs-ja/pages/changelog.md                   |  20 ++++
 docs-ja/pages/claude-code-on-the-web-ja.md   |  41 +++++++-
 docs-ja/pages/cli-reference-ja.md            | 142 +++++++++++++--------------
 docs-ja/pages/debug-your-config-ja.md        |  46 ++++++---
 docs-ja/pages/discover-plugins-ja.md         |  82 +++++++++-------
 docs-ja/pages/env-vars-ja.md                 |  17 ++--
 docs-ja/pages/errors-ja.md                   |  36 +++++--
 docs-ja/pages/fullscreen-ja.md               |  18 +++-
 docs-ja/pages/google-vertex-ai-ja.md         | 139 +++++---------------------
 docs-ja/pages/interactive-mode-ja.md         |   4 +-
 docs-ja/pages/mcp-ja.md                      |  20 +++-
 docs-ja/pages/memory-ja.md                   |  14 ++-
 docs-ja/pages/microsoft-foundry-ja.md        | 112 +--------------------
 docs-ja/pages/model-config-ja.md             |   6 +-
 docs-ja/pages/output-styles-ja.md            |  25 +++--
 docs-ja/pages/routines-ja.md                 |  86 ++++++++++++----
 docs-ja/pages/settings-ja.md                 |  35 ++++---
 docs-ja/pages/statusline-ja.md               |  38 ++++---
 docs-ja/pages/terminal-config-ja.md          |  10 +-
 docs-ja/pages/third-party-integrations-ja.md |  74 +++++++++++++-
 docs-ja/pages/vs-code-ja.md                  |   2 +
 23 files changed, 555 insertions(+), 555 deletions(-)
```

<details>
<summary>amazon-bedrock-ja.md</summary>

```diff
diff --git a/docs-ja/pages/amazon-bedrock-ja.md b/docs-ja/pages/amazon-bedrock-ja.md
index 799be23..e27a827 100644
--- a/docs-ja/pages/amazon-bedrock-ja.md
+++ b/docs-ja/pages/amazon-bedrock-ja.md
@@ -77,115 +77,5 @@ export const ContactSalesCard = ({surface}) => {
 };
 
-export const Experiment = ({flag, treatment, children}) => {
-  const VID_KEY = 'exp_vid';
-  const CONSENT_COUNTRIES = new Set(['AT', 'BE', 'BG', 'HR', 'CY', 'CZ', 'DK', 'EE', 'FI', 'FR', 'DE', 'GR', 'HU', 'IE', 'IT', 'LV', 'LT', 'LU', 'MT', 'NL', 'PL', 'PT', 'RO', 'SK', 'SI', 'ES', 'SE', 'RE', 'GP', 'MQ', 'GF', 'YT', 'BL', 'MF', 'PM', 'WF', 'PF', 'NC', 'AW', 'CW', 'SX', 'FO', 'GL', 'AX', 'GB', 'UK', 'AI', 'BM', 'IO', 'VG', 'KY', 'FK', 'GI', 'MS', 'PN', 'SH', 'TC', 'GG', 'JE', 'IM', 'CA', 'BR', 'IN']);
-  const fnv1a = s => {
-    let h = 0x811c9dc5;
-    for (let i = 0; i < s.length; i++) {
-      h ^= s.charCodeAt(i);
-      h += (h << 1) + (h << 4) + (h << 7) + (h << 8) + (h << 24);
-    }
-    return h >>> 0;
-  };
-  const bucket = (seed, vid) => fnv1a(fnv1a(seed + vid) + '') % 10000 < 5000 ? 'control' : 'treatment';
-  const [decision] = useState(() => {
-    const params = new URLSearchParams(location.search);
-    const preBucketed = document.documentElement.dataset['gb_' + flag.replace(/-/g, '_')];
-    const force = params.get('gb-force');
-    if (force) {
-      for (const p of force.split(',')) {
-        const [k, v] = p.split(':');
-        if (k === flag) return {
-          variant: v || 'treatment',
-          track: false
-        };
```

</details>

<details>
<summary>authentication-ja.md</summary>

```diff
diff --git a/docs-ja/pages/authentication-ja.md b/docs-ja/pages/authentication-ja.md
index af808d9..a34f95d 100644
--- a/docs-ja/pages/authentication-ja.md
+++ b/docs-ja/pages/authentication-ja.md
@@ -112,7 +112,12 @@ Amazon Bedrock、Google Vertex AI、または Microsoft Foundry を使用する
 ## 認証情報管理
 
-Claude Code は認証認証情報を安全に管理します。
-
-* **保存場所**: macOS では、認証情報は暗号化された macOS Keychain に保存されます。Linux と Windows では、認証情報は `~/.claude/.credentials.json` に保存されるか、その変数が設定されている場合は `$CLAUDE_CONFIG_DIR` の下に保存されます。Linux では、ファイルはモード `0600` で書き込まれます。Windows では、ユーザープロファイルディレクトリのアクセス制御を継承します。
+Claude Code は認証情報を安全に管理します。
+
+* **保存場所**:
+  * macOS では、認証情報は暗号化された macOS Keychain に保存されます。
+  * Linux では、認証情報は `~/.claude/.credentials.json` に保存され、ファイルモードは `0600` です。
+  * Windows では、認証情報は `%USERPROFILE%\.claude\.credentials.json` に保存され、ユーザープロファイルディレクトリのアクセス制御を継承します。これにより、ファイルはデフォルトでユーザーアカウントに制限されます。
+  * Linux または Windows で `CLAUDE_CONFIG_DIR` 環境変数を設定している場合、`.credentials.json` ファイルはそのディレクトリの下に配置されます。
+  * Claude Code は `/login` と `/logout` を通じて `.credentials.json` を管理します。リクエストをカスタム API エンドポイント経由でルーティングするには、代わりに [`ANTHROPIC_BASE_URL`](/ja/env-vars) 環境変数を設定してください。
 * **サポートされている認証タイプ**: Claude.ai 認証情報、Claude API 認証情報、Azure Auth、Bedrock Auth、および Vertex Auth。
 * **カスタム認証情報スクリプト**: [`apiKeyHelper`](/ja/settings#available-settings) 設定は、API キーを返すシェルスクリプトを実行するように設定できます。
@@ -129,5 +134,5 @@ Claude Code は認証認証情報を安全に管理します。
 2. `ANTHROPIC_AUTH_TOKEN` 環境変数。`Authorization: Bearer` ヘッダーとして送信されます。Anthropic API キーではなくベアラートークンで認証する [LLM ゲートウェイまたはプロキシ](/ja/llm-gateway)を通じてルーティングする場合に使用します。
 3. `ANTHROPIC_API_KEY` 環境変数。`X-Api-Key` ヘッダーとして送信されます。[Claude Console](https://platform.claude.com) からのキーを使用して Anthropic API に直接アクセスする場合に使用します。対話モードでは、キーを承認または拒否するよう 1 回プロンプトが表示され、選択が記憶されます。後で変更するには、`/config` の「Use custom API key」トグルを使用します。非対話モード（`-p`）では、キーが存在する場合は常に使用されます。
-4. [`apiKeyHelper`](/ja/settings#available-settings) スクリプト出力。短期トークンなど、動的または回転する認証情報に使用します。これはボルトから取得されます。
+4. [`apiKeyHelper`](/ja/settings#available-settings) スクリプト出力。動的または回転する認証情報（ボルトから取得した短期トークンなど）に使用します。
 5. `CLAUDE_CODE_OAUTH_TOKEN` 環境変数。[`claude setup-token`](#generate-a-long-lived-token) によって生成された長期 OAuth トークン。ブラウザログインが利用できない CI パイプラインとスクリプトに使用します。
 6. `/login` からのサブスクリプション OAuth 認証情報。これは Claude Pro、Max、Team、および Enterprise ユーザーのデフォルトです。
```

</details>

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index a109771..32b662b 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,24 @@
 # Changelog
 
+## 2.1.133
+
+- Added `worktree.baseRef` setting (`fresh` | `head`) to choose whether `--worktree`, `EnterWorktree`, and agent-isolation worktrees branch from `origin/<default>` or local `HEAD`. **Note:** the default `fresh` changes `EnterWorktree`'s base back to `origin/<default>` (it has been local `HEAD` since 2.1.128) — set `worktree.baseRef: "head"` to keep unpushed commits in new worktrees
+- Added `sandbox.bwrapPath` and `sandbox.socatPath` managed settings (Linux/WSL) to specify custom bubblewrap and socat binary locations
+- Added `parentSettingsBehavior` admin-tier key (`'first-wins' | 'merge'`) to let admins opt SDK `managedSettings` (parent tier) into the policy merge
+- Hooks now receive the active effort level via the `effort.level` JSON input field and the `$CLAUDE_EFFORT` environment variable, and Bash tool commands can read `$CLAUDE_EFFORT`
+- Improved focus mode behavior
+- Improved memory usage by releasing warm-spare background workers under memory pressure
+- Fixed parallel sessions all dead-ending at 401 after a refresh-token race wiped shared credentials
+- Fixed `Edit`/`Write` allow rules scoped to a drive root (`C:\`) or POSIX `/` matching incorrectly and always prompting
+- Fixed an unhandled rejection (`ECOMPROMISED`) when a history or session-log file lock is compromised by clock skew or slow disk
+- Fixed pressing Esc during conversation compaction showing a spurious "Error compacting conversation" notification
+- Fixed `HTTP(S)_PROXY` / `NO_PROXY` / mTLS not being respected for the full MCP OAuth flow including discovery, dynamic client registration, token exchange, and token refresh
+- Fixed Read/Write/Edit being denied on mapped network drives passed via `--add-dir` / SDK `additionalDirectories`
+- Fixed Remote Control stop/interrupt from claude.ai not fully canceling the CLI session the same way local Esc does, causing queued messages to never advance after interrupting a stuck tool or prompt
+- Fixed `/effort` in one session unexpectedly changing the effort level of other concurrent sessions, and a related issue where an IDE effort change could be silently dropped
+- Fixed subagents not discovering project, user, or plugin skills via the Skill tool
+- `claude --help` now lists `--remote-control` alongside `--remote-control-session-name-prefix`
+- [VSCode] Fixed `claudeCode.claudeProcessWrapper` failing with "Unsupported platform" when the extension build doesn't bundle a Claude binary
+
 ## 2.1.132
 
```

</details>

<details>
<summary>claude-code-on-the-web-ja.md</summary>

```diff
diff --git a/docs-ja/pages/claude-code-on-the-web-ja.md b/docs-ja/pages/claude-code-on-the-web-ja.md
index d1a97f3..73d3404 100644
--- a/docs-ja/pages/claude-code-on-the-web-ja.md
+++ b/docs-ja/pages/claude-code-on-the-web-ja.md
@@ -114,8 +114,8 @@ Team および Enterprise 管理者は [claude.ai/admin-settings/claude-code](ht
 各クラウドセッションは claude.ai 上にトランスクリプト URL を持ち、セッションは `CLAUDE_CODE_REMOTE_SESSION_ID` 環境変数から独自の ID を読み取ることができます。これを使用して、PR 本文、コミットメッセージ、Slack 投稿、または生成されたレポートに追跡可能なリンクを配置し、レビュアーがそれを生成した実行を開くことができます。
 
-Claude に環境変数からリンクを構築するよう依頼してください。次のコマンドは URL を出力します：
+変数の値は `cse_` プレフィックスを使用し、トランスクリプト URL パスは同じ ID を `session_` プレフィックスで使用します。リンクを構築するときにプレフィックスを置き換えてください。次のコマンドは URL を出力します：
 
 ```bash theme={null}
-echo "https://claude.ai/code/${CLAUDE_CODE_REMOTE_SESSION_ID}"
+echo "https://claude.ai/code/${CLAUDE_CODE_REMOTE_SESSION_ID/#cse_/session_}"
 ```
 
@@ -157,5 +157,5 @@ Docker はコンテナ化されたサービスを実行するために利用可
 | :------------------- | :--------------------------------------------------------------------------------------------------------------------- |
 | 環境を追加                | 現在の環境を選択して環境セレクターを開き、**Add environment** を選択します。ダイアログには名前、ネットワークアクセスレベル、環境変数、セットアップスクリプトが含まれます。                        |
-| 環境を編集                | 環境名の右側の設定アイコンを選択します。                                                                                                   |
+| 環境を編集                | クラウドアイコンを選択して現在の環境の名前を表示し、セレクターを開き、環境にマウスを合わせて、右側に表示される設定アイコンをクリックします。                                                 |
 | 環境をアーカイブ             | 環境を編集用に開き、**Archive** を選択します。アーカイブされた環境はセレクターから非表示になりますが、既存のセッションは実行を続けます。                                             |
 | `--remote` のデフォルトを設定 | ターミナルで `/remote-env` を実行します。単一の環境がある場合、このコマンドは現在の設定を表示します。`/remote-env` はデフォルトのみを選択します。ウェブインターフェースから環境を追加、編集、アーカイブします。 |
@@ -186,4 +186,6 @@ apt update && apt install -y gh
 スクリプトがゼロ以外で終了する場合、セッションは開始に失敗します。不安定なインストール失敗でセッションをブロックするのを避けるために、重要でないコマンドに `|| true` を追加します。
 
+スクリプトの総実行時間を約 5 分以下に保つため、[環境キャッシュ](#environment-caching)を構築できます。`&` と `wait` を使用して独立したインストールを並列で実行します。単一のダウンロードが 5 分の制限に収まらない場合は、バックグラウンドで起動する [SessionStart フック](#setup-scripts-vs-sessionstart-hooks)に移動します。
+
 <Note>
   パッケージをインストールするセットアップスクリプトはレジストリに到達するためにネットワークアクセスが必要です。デフォルトの **Trusted** ネットワークアクセスは npm、PyPI、RubyGems、crates.io を含む[一般的なパッケージレジストリ](#default-allowed-domains)への接続を許可します。環境が **None** ネットワークアクセスを使用する場合、スクリプトはパッケージのインストールに失敗します。
@@ -266,4 +268,10 @@ SessionStart フックはクラウドセッションでいくつかの制限が
```

</details>

<details>
<summary>cli-reference-ja.md</summary>

```diff
diff --git a/docs-ja/pages/cli-reference-ja.md b/docs-ja/pages/cli-reference-ja.md
index 08d61cd..a7190a9 100644
--- a/docs-ja/pages/cli-reference-ja.md
+++ b/docs-ja/pages/cli-reference-ja.md
@@ -40,69 +40,69 @@
 これらのコマンドラインフラグを使用して Claude Code の動作をカスタマイズします。`claude --help` はすべてのフラグをリストしていないため、`--help` にフラグが表示されていないことは、そのフラグが利用できないことを意味しません。
 
-| フラグ                                             | 説明                                                                                                                                                                                                                                                            | 例                                                                                                  |
-| :---------------------------------------------- | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | :------------------------------------------------------------------------------------------------- |
-| `--add-dir`                                     | Claude がファイルを読み取り、編集するための追加の作業ディレクトリを追加します。ファイルアクセスを許可します。ほとんどの `.claude/` 設定は [これらのディレクトリから検出されません](/ja/permissions#additional-directories-grant-file-access-not-configuration)。各パスがディレクトリとして存在することを検証します                                                    | `claude --add-dir ../apps ../lib`                                                                  |
-| `--agent`                                       | 現在のセッションのエージェントを指定します（`agent` 設定をオーバーライドします）                                                                                                                                                                                                                  | `claude --agent my-custom-agent`                                                                   |
-| `--agents`                                      | JSON 経由でカスタム subagents を動的に定義します。subagent [frontmatter](/ja/sub-agents#supported-frontmatter-fields) と同じフィールド名を使用し、さらにエージェントの指示用の `prompt` フィールドを追加します                                                                                                        | `claude --agents '{"reviewer":{"description":"Reviews code","prompt":"You are a code reviewer"}}'` |
-| `--allow-dangerously-skip-permissions`          | `Shift+Tab` モードサイクルに `bypassPermissions` を追加します。これを開始時に有効にしません。`plan` のような別のモードで開始し、後で `bypassPermissions` に切り替えることができます。[権限モード](/ja/permission-modes#skip-all-checks-with-bypasspermissions-mode) を参照してください                                                  | `claude --permission-mode plan --allow-dangerously-skip-permissions`                               |
-| `--allowedTools`                                | 権限を求めずに実行するツール。パターンマッチングについては [権限ルール構文](/ja/settings#permission-rule-syntax) を参照してください。利用可能なツールを制限するには、代わりに `--tools` を使用してください                                                                                                                               | `"Bash(git log *)" "Bash(git diff *)" "Read"`                                                      |
-| `--append-system-prompt`                        | デフォルトシステムプロンプトの末尾にカスタムテキストを追加                                                                                                                                                                                                                                 | `claude --append-system-prompt "Always use TypeScript"`                                            |
-| `--append-system-prompt-file`                   | ファイルから追加のシステムプロンプトテキストを読み込み、デフォルトプロンプトに追加                                                                                                                                                                                                                     | `claude --append-system-prompt-file ./extra-rules.txt`                                             |
-| `--bare`                                        | 最小限モード：hooks、skills、plugins、MCP サーバー、自動メモリ、CLAUDE.md の自動検出をスキップして、スクリプト化された呼び出しをより高速に開始します。Claude は Bash、ファイル読み取り、ファイル編集ツールにアクセスできます。[`CLAUDE_CODE_SIMPLE`](/ja/env-vars) を設定します。[bare mode](/ja/headless#start-faster-with-bare-mode) を参照してください              | `claude --bare -p "query"`                                                                         |
-| `--betas`                                       | API リクエストに含めるベータヘッダー（API キーユーザーのみ）                                                                                                                                                                                                                            | `claude --betas interleaved-thinking`                                                              |
-| `--channels`                                    | （研究プレビュー）Claude がこのセッションでリッスンすべき [channel](/ja/channels) 通知を持つ MCP サーバー。`plugin:<name>@<marketplace>` エントリのスペース区切りリスト。Claude.ai 認証が必要です                                                                                                                       | `claude --channels plugin:my-notifier@my-marketplace`                                              |
-| `--chrome`                                      | Web 自動化とテストのための [Chrome ブラウザ統合](/ja/chrome) を有効にします                                                                                                                                                                                                           | `claude --chrome`                                                                                  |
-| `--continue`, `-c`                              | 現在のディレクトリで最新の会話を読み込みます。このディレクトリを `/add-dir` で追加したセッションを含みます                                                                                                                                                                                                   | `claude --continue`                                                                                |
-| `--dangerously-load-development-channels`       | 承認されたアローリストにない [channels](/ja/channels-reference#test-during-the-research-preview) をローカル開発用に有効にします。`plugin:<name>@<marketplace>` および `server:<name>` エントリを受け入れます。確認を求めます                                                                                      | `claude --dangerously-load-development-channels server:webhook`                                    |
-| `--dangerously-skip-permissions`                | すべての権限プロンプトをスキップします。`--permission-mode bypassPermissions` と同等です。[権限モード](/ja/permission-modes#skip-all-checks-with-bypasspermissions-mode) を参照して、これが何をスキップし、何をスキップしないかを確認してください                                                                                | `claude --dangerously-skip-permissions`                                                            |
-| `--debug`                                       | オプションのカテゴリフィルタリング付きでデバッグモードを有効にします（例：`"api,hooks"` または `"!statsig,!file"`）                                                                                                                                                                                    | `claude --debug "api,mcp"`                                                                         |
-| `--debug-file <path>`                           | デバッグログを特定のファイルパスに書き込みます。暗黙的にデバッグモードを有効にします。`CLAUDE_CODE_DEBUG_LOGS_DIR` より優先されます                                                                                                                                                                              | `claude --debug-file /tmp/claude-debug.log`                                                        |
-| `--disable-slash-commands`                      | このセッションのすべてのスキルとコマンドを無効にします                                                                                                                                                                                                                                   | `claude --disable-slash-commands`                                                                  |
-| `--disallowedTools`                             | モデルのコンテキストから削除され、使用できないツール                                                                                                                                                                                                                                    | `"Bash(git log *)" "Bash(git diff *)" "Edit"`                                                      |
-| `--effort`                                      | 現在のセッションの [努力レベル](/ja/model-config#adjust-effort-level) を設定します。オプション：`low`、`medium`、`high`、`xhigh`、`max`。利用可能なレベルはモデルによって異なります。セッションスコープであり、設定に永続化されません                                                                                                       | `claude --effort high`                                                                             |
-| `--enable-auto-mode`                            | {/* max-version: 2.1.110 */}v2.1.111 で削除されました。Auto mode は現在 `Shift+Tab` サイクルにデフォルトで含まれています。`--permission-mode auto` を使用して開始してください                                                                                                                             | `claude --permission-mode auto`                                                                    |
-| `--exclude-dynamic-system-prompt-sections`      | システムプロンプトからマシンごとのセクション（作業ディレクトリ、環境情報、メモリパス、git ステータス）を最初のユーザーメッセージに移動します。異なるユーザーとマシンで同じタスクを実行する場合、prompt-cache の再利用を改善します。デフォルトシステムプロンプトにのみ適用されます。`--system-prompt` または `--system-prompt-file` が設定されている場合は無視されます。スクリプト化された複数ユーザーのワークロードの場合は `-p` と一緒に使用してください | `claude -p --exclude-dynamic-system-prompt-sections "query"`                                       |
```

</details>

<details>
<summary>debug-your-config-ja.md</summary>

```diff
diff --git a/docs-ja/pages/debug-your-config-ja.md b/docs-ja/pages/debug-your-config-ja.md
index 1abb6e4..846395c 100644
--- a/docs-ja/pages/debug-your-config-ja.md
+++ b/docs-ja/pages/debug-your-config-ja.md
@@ -9,5 +9,5 @@
 Claude が指示を無視したり、設定した機能が表示されない場合、通常の原因はファイルが読み込まれなかった、予期した場所とは異なる場所から読み込まれた、または別のファイルがそれをオーバーライドしたことです。このガイドでは、Claude Code が実際に読み込んだ内容を検査して、どれが当てはまるかを絞り込む方法を示します。
 
-インストール、認証、接続の問題については、代わりに [トラブルシューティング](/ja/troubleshoot-install) を参照してください。
+インストール、認証、接続の問題については、代わりに [トラブルシューティング インストールとログイン](/ja/troubleshoot-install) を参照してください。
 
 ## コンテキストに読み込まれた内容を確認する
@@ -17,14 +17,15 @@ Claude が指示を無視したり、設定した機能が表示されない場
 特定のカテゴリの詳細については、専用コマンドで確認してください：
 
-| コマンド           | 表示内容                                      |
-| :------------- | :---------------------------------------- |
-| `/memory`      | 読み込まれた `CLAUDE.md` とルールファイル、およびオートメモリエントリ |
-| `/skills`      | プロジェクト、ユーザー、プラグインソースから利用可能なスキル            |
-| `/agents`      | 設定されたサブエージェントとその設定                        |
-| `/hooks`       | アクティブなフック設定                               |
-| `/mcp`         | 接続された MCP サーバーとそのステータス                    |
-| `/permissions` | 現在有効な許可と拒否ルール                             |
-| `/doctor`      | 設定診断：無効なキー、スキーマエラー、インストール状態               |
-| `/status`      | アクティブな設定ソース（マネージド設定が有効かどうかを含む）            |
+| コマンド             | 表示内容                                               |
+| :--------------- | :------------------------------------------------- |
+| `/memory`        | 読み込まれた `CLAUDE.md` とルールファイル、およびオートメモリエントリ          |
+| `/skills`        | プロジェクト、ユーザー、プラグインソースから利用可能なスキル                     |
+| `/agents`        | 設定されたサブエージェントとその設定                                 |
+| `/hooks`         | アクティブなフック設定                                        |
```

</details>

*...以降省略*

</details>


<details>
<summary>2026-05-07</summary>

**変更ファイル:**

```
 docs-ja/pages/changelog.md                |  66 ++++++++++++
 docs-ja/pages/cli-reference-ja.md         |   7 +-
 docs-ja/pages/commands-ja.md              |  10 +-
 docs-ja/pages/env-vars-ja.md              |  13 ++-
 docs-ja/pages/features-overview-ja.md     |   8 +-
 docs-ja/pages/headless-ja.md              |  32 +++++-
 docs-ja/pages/how-claude-code-works-ja.md |  24 ++---
 docs-ja/pages/interactive-mode-ja.md      |   3 +-
 docs-ja/pages/llm-gateway-ja.md           |   4 +-
 docs-ja/pages/model-config-ja.md          |  42 +++++---
 docs-ja/pages/monitoring-usage-ja.md      |  82 ++++++++++++++-
 docs-ja/pages/plugins-ja.md               |   6 ++
 docs-ja/pages/plugins-reference-ja.md     |  46 +++++----
 docs-ja/pages/settings-ja.md              | 161 +++++++++++++++---------------
 docs-ja/pages/setup-ja.md                 |  10 +-
 docs-ja/pages/skills-ja.md                |  95 ++++++++++++------
 16 files changed, 424 insertions(+), 185 deletions(-)
```

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index 4051405..a109771 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,70 @@
 # Changelog
 
+## 2.1.132
+
+- Added `CLAUDE_CODE_SESSION_ID` environment variable to the Bash tool subprocess environment, matching the `session_id` passed to hooks
+- Added `CLAUDE_CODE_DISABLE_ALTERNATE_SCREEN=1` env var to opt out of the fullscreen alternate-screen renderer and keep the conversation in the terminal's native scrollback
+- Added a "Pasting…" footer hint while a Ctrl+V image paste is being read from the clipboard
+- Fixed external SIGINT (e.g. IDE stop button, `kill -INT`) not running graceful shutdown — terminal modes are now restored and the `--resume` hint is printed instead of an abrupt exit
+- Fixed an uncaught exception when the terminal is closed or SSH disconnects mid-session under the native build
+- Fixed `--resume` failing with `no low surrogate in string` when a tool error truncation split an emoji; pre-corrupted sessions are sanitized on load
+- Fixed `--permission-mode` flag being ignored when resuming a plan-mode session with `-p --continue`/`--resume`, and plan mode not being re-applied after `ExitPlanMode` within the same session
+- Fixed fullscreen mode showing a blank screen after laptop sleep/wake or Ctrl+Z/`fg` until the next keystroke or stream output
+- Fixed cursor landing mid-grapheme on Ctrl+E/A/K/U/arrow keys when an Indic conjunct or ZWJ emoji wraps across lines
+- Fixed vim operators corrupting text containing decomposed (NFD) accented characters
+- Fixed pasting text starting with `/` silently swallowing the input or triggering an unknown-command reply
+- Fixed pasting dumping stray escape sequences into the prompt when focus events or mouse-tracking reports interleave with the bracketed paste
+- Fixed mouse wheel scrolling being too fast in Cursor and VS Code 1.92–1.104 due to an upstream xterm.js bug
+- Fixed scroll-wheel handling in JetBrains IDE 2025.2 terminals (spurious arrow keys, wrong-direction events, runaway acceleration)
+- Fixed `/usage` Ctrl+S hanging when copying the stats screenshot to the clipboard on Linux/X11
+- Fixed `/terminal-setup` showing a contradictory error in Windows Terminal — Shift+Enter is natively supported there
+- Fixed `/effort` picker not reflecting the `CLAUDE_CODE_EFFORT_LEVEL` env var override
+- Fixed `/status` showing the wrong default model for some users
+- Fixed slash command autocomplete popup being capped at ~3–5 visible commands instead of scaling with terminal height
+- Fixed statusline `context_window` token counts reflecting cumulative session totals instead of current context usage
+- Fixed Alt+T (thinking toggle) not working on macOS terminals without "Option as Meta" enabled (iTerm2, Terminal.app defaults)
```

</details>

<details>
<summary>cli-reference-ja.md</summary>

```diff
diff --git a/docs-ja/pages/cli-reference-ja.md b/docs-ja/pages/cli-reference-ja.md
index d535196..08d61cd 100644
--- a/docs-ja/pages/cli-reference-ja.md
+++ b/docs-ja/pages/cli-reference-ja.md
@@ -84,5 +84,6 @@
 | `--permission-mode`                             | 指定された [権限モード](/ja/permission-modes) で開始します。`default`、`acceptEdits`、`plan`、`auto`、`dontAsk`、または `bypassPermissions` を受け入れます。設定ファイルの `defaultMode` をオーバーライドします                                                                                                  | `claude --permission-mode plan`                                                                    |
 | `--permission-prompt-tool`                      | 非インタラクティブモードで権限プロンプトを処理する MCP ツールを指定します                                                                                                                                                                                                                       | `claude -p --permission-prompt-tool mcp_auth_tool "query"`                                         |
-| `--plugin-dir`                                  | このセッションのみのプラグインをディレクトリから読み込みます。各フラグは 1 つのパスを取ります。複数のディレクトリの場合はフラグを繰り返します：`--plugin-dir A --plugin-dir B`                                                                                                                                                      | `claude --plugin-dir ./my-plugins`                                                                 |
+| `--plugin-dir`                                  | このセッションのみのプラグインをディレクトリまたは `.zip` アーカイブから読み込みます。各フラグは 1 つのパスを取ります。複数のプラグインの場合はフラグを繰り返します：`--plugin-dir A --plugin-dir B.zip`                                                                                                                                   | `claude --plugin-dir ./my-plugin`                                                                  |
+| `--plugin-url`                                  | このセッションのみのプラグイン `.zip` アーカイブを URL から取得します。各フラグは 1 つの URL を取ります。複数のプラグインの場合はフラグを繰り返します                                                                                                                                                                         | `claude --plugin-url https://example.com/plugin.zip`                                               |
 | `--print`, `-p`                                 | インタラクティブモードなしで応答を出力します（プログラムによる使用の詳細については [Agent SDK ドキュメント](/ja/agent-sdk/overview) を参照）                                                                                                                                                                     | `claude -p "query"`                                                                                |
 | `--remote`                                      | 提供されたタスク説明で claude.ai に新しい [Web セッション](/ja/claude-code-on-the-web) を作成します                                                                                                                                                                                     | `claude --remote "Fix the login bug"`                                                              |
@@ -93,5 +94,5 @@
 | `--session-id`                                  | 会話に特定のセッション ID を使用します（有効な UUID である必要があります）                                                                                                                                                                                                                    | `claude --session-id "550e8400-e29b-41d4-a716-446655440000"`                                       |
 | `--setting-sources`                             | 読み込む設定ソースのカンマ区切りリスト（`user`、`project`、`local`）                                                                                                                                                                                                                 | `claude --setting-sources user,project`                                                            |
-| `--settings`                                    | 追加の設定を読み込むための設定 JSON ファイルまたは JSON 文字列へのパス                                                                                                                                                                                                                     | `claude --settings ./settings.json`                                                                |
+| `--settings`                                    | 設定 JSON ファイルまたはインライン JSON 文字列へのパス。ここで設定した値は、このセッションの `settings.json` ファイル内の同じキーをオーバーライドします。省略したキーはファイルベースの値を保持します。[設定の優先順位](/ja/settings#settings-precedence) を参照してください                                                                                       | `claude --settings ./settings.json`                                                                |
 | `--strict-mcp-config`                           | `--mcp-config` からのみ MCP サーバーを使用し、他のすべての MCP 設定を無視します                                                                                                                                                                                                          | `claude --strict-mcp-config --mcp-config ./mcp.json`                                               |
 | `--system-prompt`                               | デフォルトシステムプロンプト全体をカスタムテキストで置き換え                                                                                                                                                                                                                                | `claude --system-prompt "You are a Python expert"`                                                 |
@@ -103,5 +104,5 @@
 | `--verbose`                                     | 詳細ログを有効にし、ターンごとの完全な出力を表示                                                                                                                                                                                                                                      | `claude --verbose`                                                                                 |
 | `--version`, `-v`                               | バージョン番号を出力                                                                                                                                                                                                                                                    | `claude -v`                                                                                        |
-| `--worktree`, `-w`                              | Claude を `<repo>/.claude/worktrees/<name>` の分離された [git worktree](/ja/common-workflows#run-parallel-claude-code-sessions-with-git-worktrees) で開始します。名前が指定されていない場合は、自動生成されます                                                                                    | `claude -w feature-auth`                                                                           |
+| `--worktree`, `-w`                              | Claude を `<repo>/.claude/worktrees/<name>` の分離された [git worktree](/ja/worktrees) で開始します。名前が指定されていない場合は、自動生成されます                                                                                                                                                | `claude -w feature-auth`                                                                           |
 
 ### システムプロンプトフラグ
```

</details>

<details>
<summary>commands-ja.md</summary>

```diff
diff --git a/docs-ja/pages/commands-ja.md b/docs-ja/pages/commands-ja.md
index 727d194..98542ab 100644
--- a/docs-ja/pages/commands-ja.md
+++ b/docs-ja/pages/commands-ja.md
@@ -11,4 +11,6 @@
 `/` と入力すると、利用可能なすべてのコマンドが表示されます。または `/` の後に文字を入力してフィルタリングできます。
 
+コマンドはメッセージの開始時にのみ認識されます。コマンド名の後に続くテキストは引数として渡されます。
+
 以下の表は Claude Code に含まれるすべてのコマンドをリストしています。**[スキル](/ja/skills#bundled-skills)** とマークされたエントリはバンドルされたスキルです。これらは自分で作成するスキルと同じメカニズムを使用します。Claude に渡されるプロンプトであり、Claude は関連する場合に自動的に呼び出すこともできます。その他はすべて、CLI にコード化された動作を持つ組み込みコマンドです。独自のコマンドを追加するには、[スキル](/ja/skills)を参照してください。
 
@@ -22,5 +24,5 @@
 | `/agents`                                       | [エージェント](/ja/sub-agents)設定を管理                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
 | `/autofix-pr [prompt]`                          | 現在のブランチの PR を監視し、CI が失敗するか、レビュアーがコメントを残したときに修正をプッシュする [Claude Code on the web](/ja/claude-code-on-the-web#auto-fix-pull-requests) セッションを生成。`gh pr view` で開いている PR を検出します。別の PR を監視するには、最初にそのブランチをチェックアウトしてください。デフォルトでは、リモートセッションはすべての CI 失敗とレビューコメントを修正するよう指示されます。プロンプトを渡して異なる指示を与えることができます。例えば `/autofix-pr only fix lint and type errors`。`gh` CLI と [Claude Code on the web](/ja/claude-code-on-the-web#who-can-use-claude-code-on-the-web) へのアクセスが必要です                                                   |
-| `/batch <instruction>`                          | **[スキル](/ja/skills#bundled-skills)。** コードベース全体にわたる大規模な変更を並列で調整します。コードベースを調査し、作業を 5 ～ 30 個の独立したユニットに分解し、計画を提示します。承認されると、分離された [git worktree](/ja/common-workflows#run-parallel-claude-code-sessions-with-git-worktrees) 内の各ユニットごとに 1 つのバックグラウンドエージェントを生成します。各エージェントはそのユニットを実装し、テストを実行し、プルリクエストを開きます。git リポジトリが必要です。例: `/batch migrate src/ from Solid to React`                                                                                                                                               |
+| `/batch <instruction>`                          | **[スキル](/ja/skills#bundled-skills)。** コードベース全体にわたる大規模な変更を並列で調整します。コードベースを調査し、作業を 5 ～ 30 個の独立したユニットに分解し、計画を提示します。承認されると、分離された [git worktree](/ja/worktrees) 内の各ユニットごとに 1 つのバックグラウンドエージェントを生成します。各エージェントはそのユニットを実装し、テストを実行し、プルリクエストを開きます。git リポジトリが必要です。例: `/batch migrate src/ from Solid to React`                                                                                                                                                                                                           |
 | `/branch [name]`                                | この時点で現在の会話のブランチを作成。ブランチに切り替え、元の会話を保持します。`/resume` で戻ることができます。エイリアス: `/fork`。[`CLAUDE_CODE_FORK_SUBAGENT`](/ja/env-vars) が設定されている場合、`/fork` は代わりに[フォークされたサブエージェント](/ja/sub-agents#fork-the-current-conversation)を生成し、このコマンドのエイリアスではなくなります                                                                                                                                                                                                                                                                     |
 | `/btw <question>`                               | 会話に追加せずに[サイドクエスチョン](/ja/interactive-mode#side-questions-with-%2Fbtw)として素早く質問                                                                                                                                                                                                                                                                                                                                                                                                                                 |
@@ -28,5 +30,5 @@
 | `/claude-api [migrate\|managed-agents-onboard]` | **[スキル](/ja/skills#bundled-skills)。** プロジェクトの言語（Python、TypeScript、Java、Go、Ruby、C#、PHP、または cURL）と Managed Agents リファレンス用の Claude API リファレンス資料を読み込みます。ツール使用、ストリーミング、バッチ、構造化出力、および一般的な落とし穴をカバーしています。また、コードが `anthropic` または `@anthropic-ai/sdk` をインポートするときに自動的にアクティブになります。`/claude-api migrate` を実行して、既存の Claude API コードを新しいモデルにアップグレード: Claude はスキャンするファイルとターゲットモデルを尋ね、モデル ID、思考設定、およびバージョン間で変更されたその他のパラメータを更新します。`/claude-api managed-agents-onboard` を実行して、新しい Managed Agent をゼロから作成するインタラクティブなウォークスルーを実施します |
 | `/clear`                                        | 空のコンテキストで新しい会話を開始。前の会話は `/resume` で利用可能なままです。同じ会話を続けながらコンテキストを解放するには、代わりに `/compact` を使用してください。エイリアス: `/reset`、`/new`                                                                                                                                                                                                                                                                                                                                                                                        |
-| `/color [color\|default]`                       | 現在のセッションのプロンプトバーの色を設定。利用可能な色: `red`、`blue`、`green`、`yellow`、`purple`、`orange`、`pink`、`cyan`。`default` を使用してリセット。[リモートコントロール](/ja/remote-control)が接続されている場合、色は claude.ai/code に同期されます                                                                                                                                                                                                                                                                                                                         |
+| `/color [color\|default]`                       | 現在のセッションのプロンプトバーの色を設定。利用可能な色: `red`、`blue`、`green`、`yellow`、`purple`、`orange`、`pink`、`cyan`。`default` を使用してリセット。引数なしで実行するとランダムな色を選択します。[リモートコントロール](/ja/remote-control)が接続されている場合、色は claude.ai/code に同期されます                                                                                                                                                                                                                                                                                                  |
 | `/compact [instructions]`                       | 会話をここまで要約してコンテキストを解放。オプションで要約のフォーカス指示を渡します。[コンパクション時にルール、スキル、メモリファイルがどのように処理されるか](/ja/context-window#what-survives-compaction)を参照してください                                                                                                                                                                                                                                                                                                                                                                      |
 | `/config`                                       | [設定](/ja/settings)インターフェースを開いて、テーマ、モデル、[出力スタイル](/ja/output-styles)、およびその他の設定を調整。エイリアス: `/settings`                                                                                                                                                                                                                                                                                                                                                                                                           |
@@ -45,5 +47,5 @@
 | `/feedback [report]`                            | Claude Code に関するフィードバックを送信。エイリアス: `/bug`                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
 | `/fewer-permission-prompts`                     | **[スキル](/ja/skills#bundled-skills)。** トランスクリプトで一般的な読み取り専用 Bash と MCP ツール呼び出しをスキャンし、プロジェクト `.claude/settings.json` に優先度付きの許可リストを追加して権限プロンプトを削減します                                                                                                                                                                                                                                                                                                                                                             |
-| `/focus`                                        | フォーカスビューを切り替えます。最後のプロンプト、編集 diffstats を含む 1 行のツール呼び出し要約、および最終応答のみを表示します。選択は複数セッション間で保持されます。[フルスクリーンレンダリング](/ja/fullscreen)でのみ利用可能です                                                                                                                                                                                                                                                                                                                                                                          |
+| `/focus`                                        | フォーカスビューを切り替えます。最後のプロンプト、編集 diffstats を含む 1 行のツール呼び出し要約、および最終応答のみを表示します。選択は複数セッション間で保持されます。設定で [`viewMode`](/ja/settings#available-settings) を設定してオーバーライドします。[フルスクリーンレンダリング](/ja/fullscreen)でのみ利用可能です                                                                                                                                                                                                                                                                                                        |
```

</details>

<details>
<summary>env-vars-ja.md</summary>

```diff
diff --git a/docs-ja/pages/env-vars-ja.md b/docs-ja/pages/env-vars-ja.md
index f4c5c35..67ee4e1 100644
--- a/docs-ja/pages/env-vars-ja.md
+++ b/docs-ja/pages/env-vars-ja.md
@@ -61,5 +61,5 @@ Claude Code は、その動作を制御するために以下の環境変数を
 | `CLAUDE_CODE_AUTO_COMPACT_WINDOW`                       | オートコンパクション計算に使用されるコンテキスト容量をトークン単位で設定します。デフォルトはモデルのコンテキストウィンドウです：標準モデルの場合は 200K、[拡張コンテキスト](/ja/model-config#extended-context) モデルの場合は 1M。1M モデルで `500000` などの低い値を使用して、コンパクション目的でウィンドウを 500K として扱います。値はモデルの実際のコンテキストウィンドウでキャップされます。`CLAUDE_AUTOCOMPACT_PCT_OVERRIDE` はこの値のパーセンテージとして適用されます。この変数を設定すると、コンパクション閾値がステータスラインの `used_percentage` から分離されます。これは常にモデルの完全なコンテキストウィンドウを使用します                                      |
 | `CLAUDE_CODE_AUTO_CONNECT_IDE`                          | 自動 [IDE 接続](/ja/vs-code) をオーバーライドします。デフォルトでは、Claude Code はサポートされている IDE の統合ターミナル内で起動されると自動的に接続します。これを防ぐには `false` に設定します。tmux が親ターミナルを隠すなど、自動検出が失敗した場合に接続を強制するには `true` に設定します                                                                                                                                                                                                                                        |
-| `CLAUDE_CODE_CERT_STORE`                                | TLS 接続用の CA 証明書ソースのカンマ区切りリスト。`bundled` は Claude Code に付属する Mozilla CA セットです。`system` はオペレーティングシステムの信頼ストアです。デフォルトは `bundled,system` です。システムストア統合にはネイティブバイナリ配布が必須です。Node.js ランタイムでは、この値に関係なく、バンドルされたセットのみが使用されます                                                                                                                                                                                                        |
+| `CLAUDE_CODE_CERT_STORE`                                | TLS 接続用の CA 証明書ソースのカンマ区切りリスト。`bundled` は Claude Code に付属する Mozilla CA セットです。`system` はオペレーティングシステムの信頼ストアです。デフォルトは `bundled,system` です                                                                                                                                                                                                                                                                                 |
 | `CLAUDE_CODE_CLIENT_CERT`                               | mTLS 認証用のクライアント証明書ファイルへのパス                                                                                                                                                                                                                                                                                                                                                                                            |
 | `CLAUDE_CODE_CLIENT_KEY`                                | mTLS 認証用のクライアント秘密鍵ファイルへのパス                                                                                                                                                                                                                                                                                                                                                                                            |
@@ -91,5 +91,6 @@ Claude Code は、その動作を制御するために以下の環境変数を
 | `CLAUDE_CODE_ENABLE_AWAY_SUMMARY`                       | [セッションリキャップ](/ja/interactive-mode#session-recap) の利用可能性をオーバーライドします。`/config` トグルに関係なくリキャップを強制的にオフにするには `0` に設定します。[`awaySummaryEnabled`](/ja/settings#available-settings) が `false` の場合にリキャップを強制的にオンにするには `1` に設定します。設定と `/config` トグルより優先されます                                                                                                                                                                        |
 | `CLAUDE_CODE_ENABLE_BACKGROUND_PLUGIN_REFRESH`          | [非対話モード](/ja/headless) でバックグラウンドインストールが完了した後、ターン境界でプラグイン状態をリフレッシュするには `1` に設定します。リフレッシュはセッション中にシステムプロンプトを変更するため、デフォルトではオフです。これにより、そのターンの [プロンプトキャッシング](https://platform.claude.com/docs/en/build-with-claude/prompt-caching) が無効になります                                                                                                                                                                                 |
-| `CLAUDE_CODE_ENABLE_FINE_GRAINED_TOOL_STREAMING`        | 細粒度ツール入力ストリーミングを強制的に有効にするには `1` に設定します。これがない場合、API はツール入力パラメータを完全にバッファリングしてからデルタイベントを送信します。これは大きなツール入力での表示を遅延させる可能性があります。Anthropic API のみ：Bedrock、Vertex、または Foundry では効果がありません                                                                                                                                                                                                                                       |
+| `CLAUDE_CODE_ENABLE_FINE_GRAINED_TOOL_STREAMING`        | ツール呼び出し入力が Claude によって生成されるときに API からストリーミングされるかどうかを制御します。これがない場合、大きなツール入力（長いファイル書き込みなど）は Claude が生成を完了した後にのみ到着します。これは、ハングしているように見える可能性があります。Anthropic API のみで有効です。Bedrock、Vertex、Foundry、または [ゲートウェイ](/ja/llm-gateway) 接続には効果がありません                                                                                                                                                                                  |
+| `CLAUDE_CODE_ENABLE_GATEWAY_MODEL_DISCOVERY`            | `ANTHROPIC_BASE_URL` が LiteLLM、Kong、または内部プロキシなどの Anthropic 互換ゲートウェイを指している場合、ゲートウェイの `/v1/models` エンドポイントから `/model` ピッカーを入力するには `1` に設定します。共有 API キーでバックアップされたゲートウェイはそれ以外の場合、すべてのユーザーにキーがアクセスできるすべてのモデルを表示するため、デフォルトではオフです。検出されたモデルは依然として [`availableModels`](/ja/settings#available-settings) 許可リストでフィルタリングされます                                                                                                      |
 | `CLAUDE_CODE_ENABLE_PROMPT_SUGGESTION`                  | プロンプト提案を無効にするには `false` に設定します（`/config` の「プロンプト提案」トグル）。これらは Claude が応答した後にプロンプト入力に表示される灰色の予測です。[プロンプト提案](/ja/interactive-mode#prompt-suggestions) を参照してください                                                                                                                                                                                                                                                          |
 | `CLAUDE_CODE_ENABLE_TASKS`                              | 非対話モード（`-p` フラグ）でタスク追跡システムを有効にするには `1` に設定します。タスクは対話モードではデフォルトでオンです。[タスクリスト](/ja/interactive-mode#task-list) を参照してください                                                                                                                                                                                                                                                                                                |
@@ -99,4 +100,5 @@ Claude Code は、その動作を制御するために以下の環境変数を
 | `CLAUDE_CODE_EXTRA_BODY`                                | すべての API リクエストボディの最上位にマージする JSON オブジェクト。Claude Code が直接公開していないプロバイダー固有のパラメータを渡すのに役立ちます                                                                                                                                                                                                                                                                                                                                |
 | `CLAUDE_CODE_FILE_READ_MAX_OUTPUT_TOKENS`               | ファイル読み取りのデフォルトトークン制限をオーバーライドします。より大きなファイルを完全に読み取る必要がある場合に役立ちます                                                                                                                                                                                                                                                                                                                                                        |
+| `CLAUDE_CODE_FORCE_SYNC_OUTPUT`                         | ターミナルがサポートしているが自動検出されていない場合、DEC プライベートモード 2026 [同期出力](https://gist.github.com/christianparpart/d8a62cc1ab659194337d73e399004036) を強制的に有効にするには `1` に設定します。Emacs `eat` などのエミュレーターで役立ちます。これは BSU/ESU を実装していますが、機能プローブに応答しません。tmux では効果がありません                                                                                                                                                                             |
 | `CLAUDE_CODE_FORK_SUBAGENT`                             | [フォークされた subagent](/ja/sub-agents#fork-the-current-conversation) を有効にするには `1` に設定します。フォークされた subagent は、最初から開始する代わりに、メインセッションから完全な会話コンテキストを継承します。有効にすると、`/fork` は [`/branch`](/ja/commands) のエイリアスとして機能する代わりに、フォークされた subagent をスポーンします。すべての subagent スポーンはバックグラウンドで実行されます。対話モードと SDK または `claude -p` を通じて                                                                                                            |
 | `CLAUDE_CODE_GIT_BASH_PATH`                             | Windows のみ：Git Bash 実行可能ファイル（`bash.exe`）へのパス。Git Bash がインストールされているが PATH にない場合に使用します。[Windows セットアップ](/ja/setup#set-up-on-windows) を参照してください                                                                                                                                                                                                                                                                          |
@@ -121,4 +123,5 @@ Claude Code は、その動作を制御するために以下の環境変数を
 | `CLAUDE_CODE_OTEL_HEADERS_HELPER_DEBOUNCE_MS`           | 動的 OpenTelemetry ヘッダーをリフレッシュする間隔（ミリ秒）（デフォルト：1740000 / 29 分）。[動的ヘッダー](/ja/monitoring-usage#dynamic-headers) を参照してください                                                                                                                                                                                                                                                                                                  |
 | `CLAUDE_CODE_OTEL_SHUTDOWN_TIMEOUT_MS`                  | シャットダウン時に OpenTelemetry エクスポーターが完了するためのタイムアウト（ミリ秒）（デフォルト：2000）。終了時にメトリクスがドロップされる場合は増やしてください。[監視](/ja/monitoring-usage) を参照してください                                                                                                                                                                                                                                                                                      |
+| `CLAUDE_CODE_PACKAGE_MANAGER_AUTO_UPDATE`               | 新しいバージョンが利用可能な場合、Claude Code がパッケージマネージャーのアップグレードコマンドをバックグラウンドで実行できるようにするには `1` に設定します。Homebrew と WinGet インストールに適用されます。他のパッケージマネージャーは、実行せずにアップグレードコマンドを表示し続けます。[自動更新](/ja/setup#auto-updates) を参照してください                                                                                                                                                                                                               |
 | `CLAUDE_CODE_PERFORCE_MODE`                             | Perforce 対応の書き込み保護を有効にするには `1` に設定します。設定されている場合、Edit、Write、NotebookEdit は、ターゲットファイルが所有者書き込みビットを欠いている場合に `p4 edit <file>` ヒント付きで失敗します。これは Perforce が同期されたファイルで消去し、`p4 edit` が開くまで消去したままにします。これにより、Claude Code が Perforce 変更追跡をバイパスすることを防ぎます                                                                                                                                                                            |
```

</details>

<details>
<summary>features-overview-ja.md</summary>

```diff
diff --git a/docs-ja/pages/features-overview-ja.md b/docs-ja/pages/features-overview-ja.md
index c306054..1dae4a0 100644
--- a/docs-ja/pages/features-overview-ja.md
+++ b/docs-ja/pages/features-overview-ja.md
@@ -206,5 +206,5 @@ Claude Code は、コードについて推論するモデルと、ファイル
 ## コンテキストコストを理解する
 
-追加する各機能は Claude のコンテキストの一部を消費します。多すぎるとコンテキストウィンドウがいっぱいになる可能性がありますが、Claude の効果を低下させるノイズを追加することもできます。スキルが正しくトリガーされない場合や、Claude が規約を失う場合があります。これらのトレードオフを理解することで、効果的なセットアップを構築するのに役立ちます。実行中のセッションでこれらの機能がどのように組み合わされるかのインタラクティブビューについては、[Explore the context window](/ja/context-window) を参照してください。
+追加する各機能は Claude のコンテキストの一部を消費します。多すぎるとコンテキストウィンドウがいっぱいになる可能性がありますが、Claude の効果を低下させるノイズを追加することもできます。スキルが正しくトリガーされない場合や、Claude が規約を失う場合があります。これらのトレードオフを理解することで、効果的なセットアップを構築するのに役立ちます。実行中のセッションでこれらの機能がどのように組み合わされるかのインタラクティブビューについては、[コンテキストウィンドウを探索する](/ja/context-window) を参照してください。
 
 ### 機能別のコンテキストコスト
@@ -220,5 +220,5 @@ Claude Code は、コードについて推論するモデルと、ファイル
 | **Hooks**     | トリガー時         | なし（外部で実行）                 | ゼロ（フックが追加コンテキストを返さない限り） |
 
-\*デフォルトでは、スキル説明はセッション開始時にロードされるため、Claude はそれらを使用する時期を決定できます。スキルの frontmatter で `disable-model-invocation: true` を設定して、手動で呼び出すまで Claude から完全に非表示にします。これにより、自分でのみトリガーするスキルのコンテキストコストをゼロに削減します。
+\*デフォルトでは、スキル説明はセッション開始時にロードされるため、Claude はそれらを使用する時期を決定できます。スキルの frontmatter で `disable-model-invocation: true` を設定して、手動で呼び出すまで Claude から完全に非表示にします。これにより、自分でのみトリガーするスキルのコンテキストコストをゼロに削減します。書いていないスキルの場合は、ファイルを編集せずに同じことを行うために settings で [`skillOverrides`](/ja/skills#override-skill-visibility-from-settings) を設定します。
 
 ### 機能がどのようにロードされるかを理解する
@@ -234,5 +234,5 @@ Claude Code は、コードについて推論するモデルと、ファイル
     **ロード内容：** すべての CLAUDE.md ファイル（管理、ユーザー、プロジェクトレベル）の完全なコンテンツ。
 
-    **継承：** Claude は作業ディレクトリからルートまで CLAUDE.md ファイルを読み取り、サブディレクトリにネストされたものを、それらのファイルにアクセスするときに検出します。詳細は [How CLAUDE.md files load](/ja/memory#how-claudemd-files-load) を参照してください。
+    **継承：** Claude は作業ディレクトリからルートまで CLAUDE.md ファイルを読み取り、サブディレクトリにネストされたものを、それらのファイルにアクセスするときに検出します。詳細は [CLAUDE.md ファイルがどのようにロードされるか](/ja/memory#how-claudemd-files-load) を参照してください。
 
     <Tip>CLAUDE.md を 200 行以下に保ちます。リファレンスマテリアルをスキルに移動します。スキルはオンデマンドでロードされます。</Tip>
@@ -260,5 +260,5 @@ Claude Code は、コードについて推論するモデルと、ファイル
     **ロード内容：** 接続されたサーバーからのツール名。完全な JSON スキーマは Claude が特定のツールを必要とするまで遅延されます。
 
-    **コンテキストコスト：** [Tool search](/ja/mcp#scale-with-mcp-tool-search) はデフォルトで有効になっているため、アイドル MCP ツールは最小限のコンテキストを消費します。
+    **コンテキストコスト：** [ツール検索](/ja/mcp#scale-with-mcp-tool-search) はデフォルトで有効になっているため、アイドル MCP ツールは最小限のコンテキストを消費します。
```

</details>

<details>
<summary>headless-ja.md</summary>

```diff
diff --git a/docs-ja/pages/headless-ja.md b/docs-ja/pages/headless-ja.md
index ec16841..9a5267f 100644
--- a/docs-ja/pages/headless-ja.md
+++ b/docs-ja/pages/headless-ja.md
@@ -55,5 +55,5 @@ claude --bare -p "Summarize this file" --allowedTools "Read"
 | MCP サーバー    | `--mcp-config <file-or-json>`                          |
 | カスタムエージェント  | `--agents <json>`                                      |
-| プラグインディレクトリ | `--plugin-dir <path>`                                  |
+| プラグイン       | `--plugin-dir <path>`、`--plugin-url <url>`             |
 
 ベアモードは OAuth とキーチェーン読み取りをスキップします。Anthropic 認証は `ANTHROPIC_API_KEY` または `--settings` に渡される JSON の `apiKeyHelper` から取得する必要があります。Bedrock、Vertex、および Foundry は通常のプロバイダー認証情報を使用します。
@@ -67,4 +67,34 @@ claude --bare -p "Summarize this file" --allowedTools "Read"
 これらの例は、一般的な CLI パターンを強調しています。CI およびその他のスクリプト呼び出しの場合は、[`--bare`](#start-faster-with-bare-mode) を追加して、ローカルで設定されているものを取得しないようにします。
 
+### Claude にデータをパイプする
+
+非対話モードは stdin を読み取るため、他のコマンドラインツールと同様にデータをパイプして応答をリダイレクトできます。
+
+この例は、ビルドログを Claude にパイプし、説明をファイルに書き込みます。
+
+```bash theme={null}
+cat build-error.txt | claude -p 'concisely explain the root cause of this build error' > output.txt
+```
+
+`--output-format json` を使用すると、応答ペイロードに `total_cost_usd` とモデルごとのコスト内訳が含まれるため、スクリプト呼び出し元は [使用状況ダッシュボード](/ja/costs) を参照せずに呼び出しごとの支出を追跡できます。
+
+<Note>
+  Claude Code v2.1.128 以降、パイプされた stdin は 10MB に制限されています。制限を超える場合、Claude Code は明確なエラーと 0 以外のステータスで終了します。より大きな入力を処理するには、コンテンツをファイルに書き込み、パイプする代わりにプロンプトでファイルパスを参照してください。
+</Note>
+
```

</details>

*...以降省略*

</details>


<details>
<summary>2026-05-06</summary>

**変更ファイル:**

```
 docs-ja/pages/data-usage-ja.md          |  2 +-
 docs-ja/pages/desktop-ja.md             |  8 +++++---
 docs-ja/pages/permissions-ja.md         | 16 ++++++++--------
 docs-ja/pages/platforms-ja.md           | 21 ++++++++++++---------
 docs-ja/pages/plugin-marketplaces-ja.md | 14 ++++++++------
 docs-ja/pages/plugins-reference-ja.md   | 16 ++++++++++------
 docs-ja/pages/security-ja.md            |  2 +-
 docs-ja/pages/settings-ja.md            | 33 ++++++++++++++++++++++++++++-----
 8 files changed, 73 insertions(+), 39 deletions(-)
```

<details>
<summary>data-usage-ja.md</summary>

```diff
diff --git a/docs-ja/pages/data-usage-ja.md b/docs-ja/pages/data-usage-ja.md
index 92376e4..1add0f9 100644
--- a/docs-ja/pages/data-usage-ja.md
+++ b/docs-ja/pages/data-usage-ja.md
@@ -68,5 +68,5 @@ Web 上の個別の Claude Code セッションはいつでも削除できます
 以下の図は、インストール中および通常の操作中に Claude Code が外部サービスにどのように接続するかを示しています。実線は必須の接続を示し、破線はオプションまたはユーザーが開始したデータフローを表します。
 
-<img src="https://mintcdn.com/claude-code/YcBW2H7CArGcduPb/images/claude-code-data-flow.svg?fit=max&auto=format&n=YcBW2H7CArGcduPb&q=85&s=b600a89f84fc86f9ff7be00a466c0635" alt="Claude Code の外部接続を示す図：インストール/更新は配布サーバーに接続し、ユーザーリクエストは Console 認証、public-api、およびオプションで Statsig、Sentry、バグレポートを含む Anthropic サービスに接続します" width="720" height="520" data-path="images/claude-code-data-flow.svg" />
+<img src="https://mintcdn.com/claude-code/RcOyXc06Ja8cuvMZ/images/claude-code-data-flow.svg?fit=max&auto=format&n=RcOyXc06Ja8cuvMZ&q=85&s=b5be40abf333defe984993af89546c19" alt="Claude Code の外部接続を示す図：インストール/更新は配布サーバーに接続し、ユーザーリクエストは Console 認証、public-api、およびオプションで Statsig、Sentry、バグレポートを含む Anthropic サービスに接続します" width="720" height="520" data-path="images/claude-code-data-flow.svg" />
 
 Claude Code はローカルで実行されます。LLM と対話するために、Claude Code はネットワーク経由でデータを送信します。このデータには、すべてのユーザープロンプトとモデル出力が含まれます。データは TLS 1.2 以上で転送中に暗号化されます。Claude Code はほとんどの一般的な VPN および LLM プロキシと互換性があります。
```

</details>

<details>
<summary>desktop-ja.md</summary>

```diff
diff --git a/docs-ja/pages/desktop-ja.md b/docs-ja/pages/desktop-ja.md
index 8a9c6a5..24cc374 100644
--- a/docs-ja/pages/desktop-ja.md
+++ b/docs-ja/pages/desktop-ja.md
@@ -283,9 +283,11 @@ Terminal、Finder または File Explorer、System Settings または Settings 
 ### セッションで並列に作業する
 
-サイドバーの\*\*+ New session**をクリックするか、macOS で**Cmd+N**を、Windows で**Ctrl+N**を押して、複数のタスクを並列で作業します。**Ctrl+Tab**と**Ctrl+Shift+Tab\*\*を押してサイドバーのセッションをサイクルします。Git リポジトリの場合、各セッションは[Git worktrees](/ja/common-workflows#run-parallel-claude-code-sessions-with-git-worktrees)を使用してプロジェクトの独立した分離コピーを取得するため、1 つのセッションの変更は、コミットするまで他のセッションに影響しません。
+サイドバーの\*\*+ New session**をクリックするか、macOS で**Cmd+N**を、Windows で**Ctrl+N**を押して、複数のタスクを並列で作業します。**Ctrl+Tab**と**Ctrl+Shift+Tab\*\*を押してサイドバーのセッションをサイクルします。Git リポジトリの場合、各セッションは[Git worktrees](/ja/worktrees)を使用してプロジェクトの独立した分離コピーを取得するため、1 つのセッションの変更は、コミットするまで他のセッションに影響しません。
+
+2 つのセッションを同時に表示するには、macOS で**Cmd**を、Windows で**Ctrl**を押しながらサイドバーのセッションをクリックします。セッションは既に開いているセッションの横の 2 番目のペインで開きます。分割がアクティブな間、別のサイドバーセッションをクリックすると、フォーカスがあるペインが置き換わります。macOS で\*\*Cmd+\\**を、Windows で**Ctrl+\\\*\*を押して、フォーカスされたペインを閉じて、単一のセッションに戻ります。
 
 Worktrees はデフォルトで`<project-root>/.claude/worktrees/`に保存されます。Settings → Claude Code の「Worktree location」でカスタムディレクトリに変更できます。また、すべての worktree ブランチ名の前に付加されるブランチプレフィックスを設定することもできます。これは Claude が作成したブランチを整理するのに便利です。完了したら、サイドバーのセッションにマウスを合わせてアーカイブアイコンをクリックして worktree を削除します。PR がマージまたはクローズされた後にセッションを自動的にアーカイブするには、Settings → Claude Code で**Auto-archive after PR merge or close**をオンにします。Auto-archive はローカルセッションで実行が完了したものにのみ適用されます。
 
-gitignored ファイル（`.env`など）を新しい worktrees に含めるには、プロジェクトルートに[`.worktreeinclude`ファイル](/ja/common-workflows#copy-gitignored-files-to-worktrees)を作成します。
+gitignored ファイル（`.env`など）を新しい worktrees に含めるには、プロジェクトルートに[`.worktreeinclude`ファイル](/ja/worktrees#copy-gitignored-files-into-worktrees)を作成します。
 
 <Note>
@@ -517,5 +519,5 @@ Claude が別のポートを選択すると、割り当てられたポートを`
 ローカルセッションと dev サーバーの環境変数を設定するには、プロンプトボックスの環境ドロップダウンを開き、**Local** にマウスを合わせて、ギアアイコンをクリックしてローカル環境エディタを開きます。ここで保存する変数は、マシンに暗号化されて保存され、開始するすべてのローカルセッションとプレビューサーバーに適用されます。また、`~/.claude/settings.json` ファイルの `env` キーに変数を追加することもできます。ただし、これらは Claude セッションにのみ到達し、dev サーバーには到達しません。サポートされている変数の完全なリストについては、[環境変数](/ja/env-vars)を参照してください。
 
-[拡張思考](/ja/common-workflows#use-extended-thinking-thinking-mode)はデフォルトで有効になっており、複雑な推論タスクのパフォーマンスを向上させますが、追加のトークンを使用します。思考を完全に無効にするには、ローカル環境エディタで `MAX_THINKING_TOKENS` を `0` に設定します。[適応的推論](/ja/model-config#adjust-effort-level)を持つモデルでは、適応的推論が思考の深さを制御するため、他の `MAX_THINKING_TOKENS` 値は無視されます。Opus 4.6 と Sonnet 4.6 では、固定思考予算を使用するために `CLAUDE_CODE_DISABLE_ADAPTIVE_THINKING` を `1` に設定します。Opus 4.7 は常に適応的推論を使用し、固定予算モードはありません。
+[拡張思考](/ja/model-config#extended-thinking)はデフォルトで有効になっており、複雑な推論タスクのパフォーマンスを向上させますが、追加のトークンを使用します。思考を完全に無効にするには、ローカル環境エディタで `MAX_THINKING_TOKENS` を `0` に設定します。[適応的推論](/ja/model-config#adjust-effort-level)を持つモデルでは、適応的推論が思考の深さを制御するため、他の `MAX_THINKING_TOKENS` 値は無視されます。Opus 4.6 と Sonnet 4.6 では、固定思考予算を使用するために `CLAUDE_CODE_DISABLE_ADAPTIVE_THINKING` を `1` に設定します。Opus 4.7 は常に適応的推論を使用し、固定予算モードはありません。
 
 ### リモートセッション
```

</details>

<details>
<summary>permissions-ja.md</summary>

```diff
diff --git a/docs-ja/pages/permissions-ja.md b/docs-ja/pages/permissions-ja.md
index dca121a..8ded97f 100644
--- a/docs-ja/pages/permissions-ja.md
+++ b/docs-ja/pages/permissions-ja.md
@@ -37,8 +37,8 @@ Claude Code は、ツールの承認方法を制御するいくつかの権限
 | `default`           | 標準動作。各ツールの最初の使用時に権限を促します                                                                                      |
 | `acceptEdits`       | ファイル編集と一般的なファイルシステムコマンド（`mkdir`、`touch`、`mv`、`cp` など）を、作業ディレクトリまたは `additionalDirectories` 内のパスに対して自動的に受け入れます |
-| `plan`              | Plan Mode。Claude はファイルを分析できますが、ファイルを変更したりコマンドを実行したりすることはできません                                                 |
+| `plan`              | Plan Mode。Claude はファイルを読み取り、読み取り専用シェルコマンドを実行して探索しますが、ソースファイルを編集しません                                           |
 | `auto`              | バックグラウンド安全チェック付きでツール呼び出しを自動承認し、アクションがリクエストと一致することを確認します。現在は研究プレビューです                                          |
 | `dontAsk`           | `/permissions` または `permissions.allow` ルールで事前に承認されていない限り、ツールを自動的に拒否します                                        |
-| `bypassPermissions` | ファイルシステムルートまたはホームディレクトリの削除（`rm -rf /` など）は回路遮断器として引き続きプロンプトを表示しますが、その他すべての権限プロンプトをスキップします                     |
+| `bypassPermissions` | すべての権限プロンプトをスキップします。ファイルシステムルートまたはホームディレクトリの削除（`rm -rf /` など）は回路遮断器として引き続きプロンプトを表示します                         |
 
 <Warning>
@@ -297,8 +297,8 @@ Claude がシンボリックリンクにアクセスするとき、権限ルー
 * 権限 deny ルールは、Claude が制限されたリソースへのアクセスを試みることさえ防止します
 * サンドボックス制限は、プロンプトインジェクションが Claude の意思決定をバイパスしても、Bash コマンドが定義された境界外のリソースに到達することを防止します
-* サンドボックス内のファイルシステム制限は、Read と Edit deny ルールを使用し、別のサンドボックス設定は使用しません
-* ネットワーク制限は、WebFetch 権限ルールとサンドボックスの `allowedDomains` と `deniedDomains` リストを組み合わせます
+* サンドボックス内のファイルシステム制限は、[`sandbox.filesystem`](/ja/sandboxing) 設定と Read および Edit deny ルールを組み合わせます。両方が最終的なサンドボックス境界にマージされます
+* ネットワーク制限は、WebFetch 権限ルールとサンドボックスの `allowedDomains` および `deniedDomains` リストを組み合わせます
 
-サンドボックスが `autoAllowBashIfSandboxed: true` で有効になっている場合（デフォルト）、サンドボックス化された Bash コマンドは、権限に `ask: Bash(*)` が含まれている場合でもプロンプトなしで実行されます。サンドボックス境界はコマンドごとのプロンプトの代わりになります。[サンドボックスモード](/ja/sandboxing#sandbox-modes)を参照して、この動作を変更してください。
+サンドボックスが `autoAllowBashIfSandboxed: true` で有効になっている場合（デフォルト）、サンドボックス化された Bash コマンドは、権限に `ask: Bash(*)` が含まれている場合でもプロンプトなしで実行されます。サンドボックス境界はコマンドごとのプロンプトの代わりになります。明示的な deny ルールは引き続き適用され、`/`、ホームディレクトリ、またはその他の重要なシステムパスをターゲットとする `rm` または `rmdir` コマンドは、引き続きプロンプトをトリガーします。[サンドボックスモード](/ja/sandboxing#sandbox-modes)を参照して、この動作を変更してください。
 
 ## 管理設定
@@ -317,10 +317,10 @@ Claude Code 設定の一元的な制御が必要な組織の場合、管理者
 | `allowManagedPermissionRulesOnly`              | `true` の場合、ユーザーおよびプロジェクト設定が `allow`、`ask`、または `deny` 権限ルールを定義することを防止します。管理設定のルールのみが適用されます                                                                                                           |
 | `blockedMarketplaces`                          | マーケットプレイスソースのブロックリスト。ブロックされたソースはダウンロード前にチェックされるため、ファイルシステムに触れることはありません。[管理マーケットプレイス制限](/ja/plugin-marketplaces#managed-marketplace-restrictions)を参照してください                                           |
```

</details>

<details>
<summary>platforms-ja.md</summary>

```diff
diff --git a/docs-ja/pages/platforms-ja.md b/docs-ja/pages/platforms-ja.md
index b59110f..5d26b5e 100644
--- a/docs-ja/pages/platforms-ja.md
+++ b/docs-ja/pages/platforms-ja.md
@@ -5,5 +5,5 @@
 # プラットフォームと統合
 
-> Claude Code を実行する場所を選択し、何に接続するかを決定します。CLI、Desktop、VS Code、JetBrains、Web、および Chrome、Slack、CI/CD などの統合を比較します。
+> Claude Code を実行する場所を選択し、何に接続するかを決定します。CLI、Desktop、VS Code、JetBrains、Web、モバイル、および Chrome、Slack、CI/CD などの統合を比較します。
 
 Claude Code は、どこでも同じ基盤となるエンジンを実行しますが、各サーフェスは異なる作業方法に合わせて調整されています。このページは、ワークフローに適したプラットフォームを選択し、既に使用しているツールを接続するのに役立ちます。
@@ -13,13 +13,14 @@ Claude Code は、どこでも同じ基盤となるエンジンを実行しま
 プロジェクトがどこにあるか、どのように作業したいかに基づいてプラットフォームを選択します。
 
-| プラットフォーム                          | 最適な用途                                                | 提供される機能                                                                                                                                  |
-| :-------------------------------- | :--------------------------------------------------- | :--------------------------------------------------------------------------------------------------------------------------------------- |
-| [CLI](/ja/quickstart)             | ターミナルワークフロー、スクリプティング、リモートサーバー                        | 完全な機能セット、[Agent SDK](/ja/headless)、サードパーティプロバイダー                                                                                         |
-| [Desktop](/ja/desktop)            | ビジュアルレビュー、並列セッション、管理されたセットアップ                        | Diff ビューアー、アプリプレビュー、Pro および Max での[コンピューター使用](/ja/desktop#let-claude-use-your-computer)および[Dispatch](/ja/desktop#sessions-from-dispatch) |
-| [VS Code](/ja/vs-code)            | ターミナルに切り替えずに VS Code 内で作業                            | インラインの Diff、統合ターミナル、ファイルコンテキスト                                                                                                           |
-| [JetBrains](/ja/jetbrains)        | IntelliJ、PyCharm、WebStorm、またはその他の JetBrains IDE 内で作業 | Diff ビューアー、選択共有、ターミナルセッション                                                                                                               |
-| [Web](/ja/claude-code-on-the-web) | あまり操作が必要ない長時間実行タスク、またはオフラインの場合も続行すべき作業               | Anthropic 管理クラウド、切断後も続行                                                                                                                  |
+| プラットフォーム                          | 最適な用途                                                | 提供される機能                                                                                                                                                          |
+| :-------------------------------- | :--------------------------------------------------- | :--------------------------------------------------------------------------------------------------------------------------------------------------------------- |
+| [CLI](/ja/quickstart)             | ターミナルワークフロー、スクリプティング、リモートサーバー                        | 完全な機能セット、[Agent SDK](/ja/headless)、[コンピューター使用](/ja/computer-use)（macOS の Pro および Max）、サードパーティプロバイダー                                                              |
+| [Desktop](/ja/desktop)            | ビジュアルレビュー、並列セッション、管理されたセットアップ                        | Diff ビューアー、アプリプレビュー、Pro および Max での[コンピューター使用](/ja/desktop#let-claude-use-your-computer)および[Dispatch](/ja/desktop#sessions-from-dispatch)                         |
+| [VS Code](/ja/vs-code)            | ターミナルに切り替えずに VS Code 内で作業                            | インラインの Diff、統合ターミナル、ファイルコンテキスト                                                                                                                                   |
+| [JetBrains](/ja/jetbrains)        | IntelliJ、PyCharm、WebStorm、またはその他の JetBrains IDE 内で作業 | Diff ビューアー、選択共有、ターミナルセッション                                                                                                                                       |
+| [Web](/ja/claude-code-on-the-web) | あまり操作が必要ない長時間実行タスク、またはオフラインの場合も続行すべき作業               | Anthropic 管理クラウド、切断後も続行                                                                                                                                          |
+| モバイル                              | コンピューターから離れている間にタスクを開始および監視                          | iOS および Android 用 Claude アプリからのクラウドセッション、ローカルセッション用の[Remote Control](/ja/remote-control)、Pro および Max での Desktop への[Dispatch](/ja/desktop#sessions-from-dispatch) |
 
```

</details>

<details>
<summary>plugin-marketplaces-ja.md</summary>

```diff
diff --git a/docs-ja/pages/plugin-marketplaces-ja.md b/docs-ja/pages/plugin-marketplaces-ja.md
index 3d8a40a..bfd075a 100644
--- a/docs-ja/pages/plugin-marketplaces-ja.md
+++ b/docs-ja/pages/plugin-marketplaces-ja.md
@@ -24,5 +24,5 @@
 ## チュートリアル：ローカルマーケットプレイスの作成
 
-この例では、1 つのプラグイン（コードレビュー用の `/quality-review` skill）を含むマーケットプレイスを作成します。ディレクトリ構造を作成し、skill を追加し、プラグインマニフェストとマーケットプレイスカタログを作成してから、インストールしてテストします。
+この例では、1 つのプラグイン（コードレビュー用の `quality-review` skill）を含むマーケットプレイスを作成します。ディレクトリ構造を作成し、skill を追加し、プラグインマニフェストとマーケットプレイスカタログを作成してから、インストールしてテストします。
 
 <Steps>
@@ -36,5 +36,5 @@
 
   <Step title="skill の作成">
-    `/quality-review` skill が何をするかを定義する `SKILL.md` ファイルを作成します。
+    `quality-review` skill が何をするかを定義する `SKILL.md` ファイルを作成します。
 
     ```markdown my-marketplace/plugins/quality-review-plugin/skills/quality-review/SKILL.md theme={null}
@@ -60,5 +60,5 @@
     {
       "name": "quality-review-plugin",
-      "description": "Adds a /quality-review skill for quick code reviews",
+      "description": "Adds a quality-review skill for quick code reviews",
       "version": "1.0.0"
     }
@@ -83,5 +83,5 @@
           "name": "quality-review-plugin",
           "source": "./plugins/quality-review-plugin",
-          "description": "Adds a /quality-review skill for quick code reviews"
+          "description": "Adds a quality-review skill for quick code reviews"
```

</details>

<details>
<summary>plugins-reference-ja.md</summary>

```diff
diff --git a/docs-ja/pages/plugins-reference-ja.md b/docs-ja/pages/plugins-reference-ja.md
index 807141b..6783090 100644
--- a/docs-ja/pages/plugins-reference-ja.md
+++ b/docs-ja/pages/plugins-reference-ja.md
@@ -262,9 +262,9 @@ LSP 統合は以下を提供します:
 **利用可能な LSP プラグイン:**
 
-| プラグイン            | 言語サーバー                     | インストールコマンド                                                                          |
-| :--------------- | :------------------------- | :---------------------------------------------------------------------------------- |
-| `pyright-lsp`    | Pyright（Python）            | `pip install pyright` または `npm install -g pyright`                                  |
-| `typescript-lsp` | TypeScript Language Server | `npm install -g typescript-language-server typescript`                              |
-| `rust-lsp`       | rust-analyzer              | [rust-analyzer インストールを参照](https://rust-analyzer.github.io/manual.html#installation) |
+| プラグイン               | 言語サーバー                     | インストールコマンド                                                                          |
+| :------------------ | :------------------------- | :---------------------------------------------------------------------------------- |
+| `pyright-lsp`       | Pyright（Python）            | `pip install pyright` または `npm install -g pyright`                                  |
+| `typescript-lsp`    | TypeScript Language Server | `npm install -g typescript-language-server typescript`                              |
+| `rust-analyzer-lsp` | rust-analyzer              | [rust-analyzer インストールを参照](https://rust-analyzer.github.io/manual.html#installation) |
 
 言語サーバーをまずインストールしてから、マーケットプレイスからプラグインをインストールしてください。
@@ -532,5 +532,7 @@ monitors をインラインで宣言するには、`plugin.json` の `monitors`
 Claude Code は、プラグインパスを参照するための 2 つの変数を提供します。どちらも skill コンテンツ、エージェントコンテンツ、hook コマンド、monitor コマンド、MCP または LSP サーバー設定に表示される場所にインラインで置換されます。どちらも hook プロセスおよび MCP または LSP サーバーサブプロセスに環境変数としてエクスポートされます。
 
-**`${CLAUDE_PLUGIN_ROOT}`**: プラグインのインストールディレクトリへの絶対パス。プラグインにバンドルされたスクリプト、バイナリ、設定ファイルを参照するために使用します。このパスはプラグインが更新されると変更されるため、ここに書き込むファイルは更新後に保持されません。
+**`${CLAUDE_PLUGIN_ROOT}`**: プラグインのインストールディレクトリへの絶対パス。プラグインにバンドルされたスクリプト、バイナリ、設定ファイルを参照するために使用します。このパスはプラグインが更新されると変更されます。前のバージョンのディレクトリは更新後約 7 日間ディスク上に残りますが、これを一時的なものとして扱い、ここに状態を書き込まないでください。
+
+プラグインがセッション中に更新されると、hook コマンド、monitors、MCP サーバー、LSP サーバーは前のバージョンのパスを使用し続けます。`/reload-plugins` を実行して、hook、MCP サーバー、LSP サーバーを新しいパスに切り替えます。monitors はセッション再起動が必要です。
 
 **`${CLAUDE_PLUGIN_DATA}`**: 更新後も保持される永続ディレクトリ。`node_modules` または Python 仮想環境などのインストール済み依存関係、生成されたコード、キャッシュ、およびプラグインバージョン全体で保持する必要があるその他のファイルに使用します。このディレクトリは、この変数が最初に参照されるときに自動的に作成されます。
@@ -678,4 +680,6 @@ enterprise-plugin/
 </Warning>
```

</details>

*...以降省略*

</details>


<details>
<summary>2026-05-05</summary>

**変更ファイル:**

```
 docs-ja/pages/changelog.md               | 40 +++++++++++++
 docs-ja/pages/features-overview-ja.md    | 97 ++++++++++++++++++++++----------
 docs-ja/pages/hooks-guide-ja.md          | 20 ++++++-
 docs-ja/pages/hooks-ja.md                | 22 ++++++--
 docs-ja/pages/memory-ja.md               |  8 +--
 docs-ja/pages/monitoring-usage-ja.md     | 22 +++++---
 docs-ja/pages/settings-ja.md             | 12 ++--
 docs-ja/pages/sub-agents-ja.md           | 69 +++++++++++++++--------
 docs-ja/pages/terminal-config-ja.md      | 45 ++++++++++++---
 docs-ja/pages/troubleshoot-install-ja.md |  6 +-
 docs-ja/pages/voice-dictation-ja.md      |  4 +-
 docs-ja/pages/vs-code-ja.md              | 36 +++++++-----
 12 files changed, 280 insertions(+), 101 deletions(-)
```

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index 01788b6..4051405 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,44 @@
 # Changelog
 
+## 2.1.128
+
+- Bare `/color` (no args) now picks a random session color
+- `/mcp` now shows the tool count for connected servers and flags servers that connected with 0 tools
+- `--plugin-dir` now accepts `.zip` plugin archives in addition to directories
+- `--channels` now works with console (API key) authentication — console orgs with managed settings must set `channelsEnabled: true` to enable
+- Updated `/model` picker: collapsed duplicate Opus 4.7 entries, and current Opus now shows as "Opus" instead of "Opus 4.7"
+- Subprocesses (Bash, hooks, MCP, LSP) no longer inherit `OTEL_*` environment variables, so OTEL-instrumented apps run via the Bash tool no longer pick up the CLI's own OTLP endpoint
+- MCP: `workspace` is now a reserved server name — existing servers with that name will be skipped with a warning
+- Reconnecting MCP servers no longer flood the conversation with full tool-name lists on every reconnect — re-announced tools are summarized by server prefix
+- SDK hosts now receive a persistent `localSettings` suggestion for Bash permission prompts, so "Always allow" writes to `.claude/settings.local.json`
+- `EnterWorktree` now creates the new branch from local HEAD as documented, instead of `origin/<default-branch>` — unpushed commits are no longer dropped
+- Auto mode: when the classifier can't evaluate an action, the error now includes a hint (retry, `/compact`, or run with `--debug`)
+- Fixed focus mode briefly dimming the previous response when submitting a new prompt
+- Fixed stray "4;0;" desktop notification on every `/exit` in Kitty and other terminals that interpret OSC 9 as a notification
+- Fixed Remote Control showing an empty "Opening your options…" message on rate limit instead of actionable upsell options
+- Fixed drag-and-drop image upload hanging on "Pasting text…" when the image read fails
+- Fixed crash loop when piping very large input (>10 MB) to `claude -p` via stdin
+- Fixed long URLs not being individually clickable on every wrapped row in fullscreen mode
+- Fixed `/plugin` Components panel showing "Marketplace 'inline' not found" for plugins loaded via `--plugin-dir`
+- Fixed MCP tool results dropping images when the server returns both structured content and content blocks
+- Fixed fenced code blocks inside list items carrying leading whitespace into the clipboard on copy-paste
+- Fixed tab navigation in `/config` stranding focus — the tab header now stays focused so arrows and Esc keep working
```

</details>

<details>
<summary>features-overview-ja.md</summary>

```diff
diff --git a/docs-ja/pages/features-overview-ja.md b/docs-ja/pages/features-overview-ja.md
index b5ceb1b..c306054 100644
--- a/docs-ja/pages/features-overview-ja.md
+++ b/docs-ja/pages/features-overview-ja.md
@@ -13,5 +13,5 @@ Claude Code は、コードについて推論するモデルと、ファイル
 </Note>
 
-**Claude Code は初めてですか？** [CLAUDE.md](/ja/memory) でプロジェクト規約を開始します。必要に応じて他の拡張機能を追加してください。
+**Claude Code は初めてですか？** [CLAUDE.md](/ja/memory) でプロジェクト規約を開始します。その後、[特定のトリガーが発生したときに](#build-your-setup-over-time)他の拡張機能を追加してください。
 
 ## 概要
@@ -24,5 +24,5 @@ Claude Code は、コードについて推論するモデルと、ファイル
 * **[Subagents](/ja/sub-agents)** は独立したコンテキストで独自のループを実行し、サマリーを返します
 * **[Agent teams](/ja/agent-teams)** は、共有タスクとピアツーピアメッセージングを使用して複数の独立したセッションを調整します
-* **[Hooks](/ja/hooks)** はループの外側で決定論的スクリプトとして実行されます
+* **[Hooks](/ja/hooks-guide)** はライフサイクルイベントで発火し、スクリプト、HTTP リクエスト、プロンプト、または subagent を実行できます
 * **[Plugins](/ja/plugins)** と **[marketplaces](/ja/plugin-marketplaces)** はこれらの機能をパッケージ化して配布します
 
@@ -33,15 +33,31 @@ Claude Code は、コードについて推論するモデルと、ファイル
 機能は、Claude がすべてのセッションで見る常時オンのコンテキストから、あなたまたは Claude が呼び出すことができるオンデマンド機能、特定のイベントで実行される背景自動化まで、さまざまです。以下の表は、利用可能な機能と各機能が適切な場合を示しています。
 
-| 機能                                 | 機能                           | 使用する場合                           | 例                                                            |
-| ---------------------------------- | ---------------------------- | -------------------------------- | ------------------------------------------------------------ |
-| **CLAUDE.md**                      | すべての会話で読み込まれる永続的なコンテキスト      | プロジェクト規約、「常に X を実行する」ルール         | 「pnpm を使用し、npm は使用しない。コミット前にテストを実行する。」                       |
-| **Skill**                          | Claude が使用できる指示、知識、ワークフロー    | 再利用可能なコンテンツ、リファレンスドキュメント、繰り返しタスク | `/deploy` はデプロイメントチェックリストを実行します。エンドポイントパターンを持つ API ドキュメントスキル |
-| **Subagent**                       | サマリー結果を返す独立した実行コンテキスト        | コンテキスト分離、並列タスク、専門的なワーカー          | 多くのファイルを読み取るが、主要な結果のみを返す研究タスク                                |
-| **[Agent teams](/ja/agent-teams)** | 複数の独立した Claude Code セッションを調整 | 並列研究、新機能開発、競合する仮説でのデバッグ          | セキュリティ、パフォーマンス、テストを同時にチェックするレビュアーをスポーン                       |
-| **MCP**                            | 外部サービスに接続                    | 外部データまたはアクション                    | データベースをクエリ、Slack に投稿、ブラウザを制御                                 |
-| **Hook**                           | イベントで実行される決定論的スクリプト          | 予測可能な自動化、LLM は関与しない              | すべてのファイル編集後に ESLint を実行                                      |
+| 機能                                 | 機能                                            | 使用する場合                           | 例                                                            |
```

</details>

<details>
<summary>hooks-guide-ja.md</summary>

```diff
diff --git a/docs-ja/pages/hooks-guide-ja.md b/docs-ja/pages/hooks-guide-ja.md
index 2f316e7..997f2d5 100644
--- a/docs-ja/pages/hooks-guide-ja.md
+++ b/docs-ja/pages/hooks-guide-ja.md
@@ -172,4 +172,17 @@ Claude が作業を完了して入力を必要とするときはいつでもデ
 </Tabs>
 
+空の `matcher` はすべての通知タイプで発火します。特定のイベントでのみ発火させるには、次のいずれかの値に設定します：
+
+| Matcher                | 発火するタイミング                   |
+| :--------------------- | :-------------------------- |
+| `permission_prompt`    | Claude がツール使用を承認する必要があるとき   |
+| `idle_prompt`          | Claude が完了し、次のプロンプトを待っているとき |
+| `auth_success`         | 認証が完了したとき                   |
+| `elicitation_dialog`   | MCP サーバーが引き出しフォームを開くとき      |
+| `elicitation_complete` | MCP 引き出しフォームが送信または却下されたとき   |
+| `elicitation_response` | MCP 引き出し応答がサーバーに送り返されたとき    |
+
+`/hooks` と入力して `Notification` を選択し、hook が登録されていることを確認します。完全なイベントスキーマについては、[Notification リファレンス](/ja/hooks#notification) を参照してください。
+
 ### 編集後にコードを自動フォーマットする
 
@@ -346,4 +359,6 @@ Claude のコンテキストウィンドウがいっぱいになると、圧縮
 ```
 
+`direnv allow` をすべてのディレクトリで 1 回実行して、direnv が `.envrc` をロードすることが許可されるようにします。direnv の代わりに devbox または nix を使用する場合、同じパターンは `direnv export bash` の代わりに `devbox shellenv` または `devbox global shellenv` で機能します。
+
 すべてのディレクトリ変更ではなく、特定のファイルに反応するには、`FileChanged` を `matcher` で使用して、監視するファイル名をリストします（パイプで区切られています）。ウォッチリストを構築するために、この値は正規表現として評価されるのではなく、リテラルファイル名に分割されます。[FileChanged](/ja/hooks#filechanged) を参照して、同じ値がファイルが変更されたときにどの hook グループが実行されるかをフィルタリングする方法を確認してください。この例は現在のディレクトリの `.envrc` と `.env` を監視します：
 
@@ -721,5 +736,8 @@ Claude Code が実行中に設定ファイルを直接編集する場合、フ
```

</details>

<details>
<summary>hooks-ja.md</summary>

```diff
diff --git a/docs-ja/pages/hooks-ja.md b/docs-ja/pages/hooks-ja.md
index 52f531b..a3178e2 100644
--- a/docs-ja/pages/hooks-ja.md
+++ b/docs-ja/pages/hooks-ja.md
@@ -975,5 +975,5 @@ InstructionsLoaded フックは決定制御がありません。命令ロード
 | `reason`            | `decision` が `"block"` のときにユーザーに表示されます。コンテキストに追加されません                         |
 | `additionalContext` | Claude のコンテキストに追加される文字列。[Claude のコンテキストを追加](#add-context-for-claude)を参照してください |
-| `sessionTitle`      | セッション タイトルを設定します。`/rename` と同じ効果。プロンプト コンテンツに基づいてセッションを自動的に名前付けするのに使用         |
+| `sessionTitle`      | セッション タイトルを設定します。プロンプト コンテンツに基づいてセッションを自動的に名前付けするのに使用                         |
 
 ```json theme={null}
@@ -2023,5 +2023,5 @@ FileChanged フックは決定制御がありません。ファイル変更を
 フックは作成されたワークツリー ディレクトリへの絶対パスを返す必要があります。Claude Code はこのパスを分離されたセッションの作業ディレクトリとして使用します。コマンド フックは stdout にパスを出力します。HTTP フックは `hookSpecificOutput.worktreePath` 経由で返します。
 
-フックはデフォルトの git 動作を完全に置き換えるため、[`.worktreeinclude`](/ja/common-workflows#copy-gitignored-files-to-worktrees)は処理されません。`.env` などのローカル設定ファイルを新しいワークツリーにコピーする必要がある場合は、フック スクリプト内で実行してください。
+フックはデフォルトの git 動作を完全に置き換えるため、[`.worktreeinclude`](/ja/worktrees#copy-gitignored-files-into-worktrees)は処理されません。`.env` などのローカル設定ファイルを新しいワークツリーにコピーする必要がある場合は、フック スクリプト内で実行してください。
 
 この例は SVN 作業コピーを作成し、Claude Code が使用するパスを出力します。リポジトリ URL を自分のものに置き換えます。
@@ -2407,8 +2407,18 @@ LLM は以下を含む JSON で応答する必要があります：
 ```
 
-| フィールド    | 説明                                    |
-| :------- | :------------------------------------ |
-| `ok`     | `true` はアクションを許可、`false` は防止          |
-| `reason` | `ok` が `false` のときに必須。Claude に表示される説明 |
+| フィールド    | 説明                            |
+| :------- | :---------------------------- |
+| `ok`     | `true` はアクションを許可、`false` は防止  |
+| `reason` | `ok` が `false` のときに必須。ブロックの説明 |
+
```

</details>

<details>
<summary>memory-ja.md</summary>

```diff
diff --git a/docs-ja/pages/memory-ja.md b/docs-ja/pages/memory-ja.md
index 2d83d0b..c6448ca 100644
--- a/docs-ja/pages/memory-ja.md
+++ b/docs-ja/pages/memory-ja.md
@@ -298,8 +298,8 @@ Claude Code をチーム全体に展開する組織の場合、指示を一元
 ## 自動メモリ
 
-自動メモリを使用すると、Claude は何も書かずにセッション間で知識を蓄積できます。Claude は作業中に自分自身のためにメモを保存します。ビルドコマンド、デバッグの洞察、アーキテクチャノート、コードスタイルの好み、ワークフローの習慣。Claude はすべてのセッションで何かを保存するわけではありません。情報が将来の会話で役立つかどうかに基づいて、何を記憶する価値があるかを決定します。
+自動メモリを使用すると、Claude は何も書かずにセッション間で知識を蓄積できます。Claude は作業中に自分自身のためにメモを保存します。ビルドコマンド、デバッグの洞察、アーキテクチャノート、コードスタイルの好み、ワークフローの習慣です。Claude はすべてのセッションで何かを保存するわけではありません。情報が将来の会話で役立つかどうかに基づいて、何を記憶する価値があるかを決定します。
 
 <Note>
-  自動メモリには Claude Code v2.1.59 以降が必要です。`claude --version` でバージョンを確認します。
+  自動メモリには Claude Code v2.1.59 以降が必要です。`claude --version` でバージョンを確認してください。
 </Note>
 
@@ -320,5 +320,5 @@ Claude Code をチーム全体に展開する組織の場合、指示を一元
 各プロジェクトは `~/.claude/projects/<project>/memory/` に独自のメモリディレクトリを取得します。`<project>` パスは git リポジトリから派生しているため、同じリポジトリ内のすべてのワーキングツリーとサブディレクトリは 1 つの自動メモリディレクトリを共有します。git リポジトリの外では、プロジェクトルートが代わりに使用されます。
 
-自動メモリを別の場所に保存するには、ユーザーまたはローカル設定で `autoMemoryDirectory` を設定します。
+自動メモリを別の場所に保存するには、`~/.claude/settings.json` のユーザー設定で `autoMemoryDirectory` を設定します。
 
 ```json theme={null}
@@ -328,5 +328,5 @@ Claude Code をチーム全体に展開する組織の場合、指示を一元
 ```
 
-この設定はポリシー、ローカル、およびユーザー設定から受け入れられます。共有プロジェクトが自動メモリ書き込みを機密の場所にリダイレクトするのを防ぐため、プロジェクト設定（`.claude/settings.json`）からは受け入れられません。
+値は絶対パスであるか、`~/` で始まる必要があります。この設定はポリシーおよびユーザー設定から受け入れられ、`--settings` フラグからも受け入れられます。プロジェクトまたはローカル設定からは受け入れられません。両方のファイルはプロジェクトディレクトリ内に存在し、クローンされたリポジトリは自動メモリ書き込みを機密の場所にリダイレクトするために、どちらかを提供する可能性があるためです。
 
 ディレクトリには `MEMORY.md` エントリポイントとオプションのトピックファイルが含まれます。
```

</details>

<details>
<summary>monitoring-usage-ja.md</summary>

```diff
diff --git a/docs-ja/pages/monitoring-usage-ja.md b/docs-ja/pages/monitoring-usage-ja.md
index 0a23d1a..a441917 100644
--- a/docs-ja/pages/monitoring-usage-ja.md
+++ b/docs-ja/pages/monitoring-usage-ja.md
@@ -198,9 +198,9 @@ Agent SDK および `claude -p` セッションでは、`TRACEPARENT` が環境
 **`claude_code.tool.blocked_on_user`**
 
-| 属性            | 説明                            | ゲート |
-| ------------- | ----------------------------- | --- |
-| `duration_ms` | 権限決定の待機に費やされた時間               |     |
-| `decision`    | `accept` または `reject`         |     |
-| `source`      | 決定ソース。`tool_decision` イベントと一致 |     |
+| 属性            | 説明                                                    | ゲート |
+| ------------- | ----------------------------------------------------- | --- |
+| `duration_ms` | 権限決定の待機に費やされた時間                                       |     |
+| `decision`    | `accept` または `reject`                                 |     |
+| `source`      | 決定ソース。[Tool decision event](#tool-decision-event) と一致 |     |
 
 **`claude_code.tool.execution`**
@@ -459,5 +459,5 @@ Claude Code を介して git コミットを作成するときにインクリメ
 * `tool_name`: ツール名 (`"Edit"`、`"Write"`、`"NotebookEdit"`)
 * `decision`: ユーザーの決定 (`"accept"`、`"reject"`)
-* `source`: 決定ソース - `"config"`、`"hook"`、`"user_permanent"`、`"user_temporary"`、`"user_abort"`、または `"user_reject"`
+* `source`: 決定ソース - `"config"`、`"hook"`、`"user_permanent"`、`"user_temporary"`、`"user_abort"`、または `"user_reject"`。詳細は [ツール決定イベント](#tool-decision-event)を参照してください。
 * `language`: 編集されたファイルのプログラミング言語。例: `"TypeScript"`、`"Python"`、`"JavaScript"`、`"Markdown"`。認識されないファイル拡張子の場合は `"unknown"` を返します。
 
@@ -525,5 +525,5 @@ Claude Code は、OpenTelemetry ログ/イベント経由で以下のイベン
 * `error` (`OTEL_LOG_TOOL_DETAILS=1` の場合): ツールが失敗した場合の完全なエラーメッセージ
 * `decision_type`: `"accept"` または `"reject"`
-* `decision_source`: 決定ソース - `"config"`、`"hook"`、`"user_permanent"`、`"user_temporary"`、`"user_abort"`、または `"user_reject"`
```

</details>

*...以降省略*

</details>


<details>
<summary>2026-05-03</summary>

**変更ファイル:**

```
 docs-ja/pages/claude-directory-ja.md     |   2 +-
 docs-ja/pages/code-review-ja.md          |  86 ++++++++++++-----
 docs-ja/pages/desktop-ja.md              | 110 +++++++++++-----------
 docs-ja/pages/desktop-quickstart-ja.md   |   2 +-
 docs-ja/pages/github-actions-ja.md       |  10 +-
 docs-ja/pages/gitlab-ci-cd-ja.md         |  22 ++---
 docs-ja/pages/legal-and-compliance-ja.md |   2 +-
 docs-ja/pages/monitoring-usage-ja.md     |   2 +-
 docs-ja/pages/settings-ja.md             | 153 ++++++++++++++++---------------
 docs-ja/pages/vs-code-ja.md              |  41 +++++++--
 docs-ja/pages/zero-data-retention-ja.md  |   2 +-
 11 files changed, 248 insertions(+), 184 deletions(-)
```

**新規追加:**


<details>
<summary>claude-directory-ja.md</summary>

```diff
diff --git a/docs-ja/pages/claude-directory-ja.md b/docs-ja/pages/claude-directory-ja.md
index b501cf1..c270b4e 100644
--- a/docs-ja/pages/claude-directory-ja.md
+++ b/docs-ja/pages/claude-directory-ja.md
@@ -95,5 +95,5 @@ export const ClaudeExplorer = () => {
 # API credentials
 config/secrets.json`,
-        docsLink: '/en/common-workflows#copy-gitignored-files-to-worktrees'
+        docsLink: '/en/worktrees#copy-gitignored-files-into-worktrees'
       }, {
         id: 'dot-claude',
```

</details>

<details>
<summary>code-review-ja.md</summary>

```diff
diff --git a/docs-ja/pages/code-review-ja.md b/docs-ja/pages/code-review-ja.md
index 4c8761d..080d8e9 100644
--- a/docs-ja/pages/code-review-ja.md
+++ b/docs-ja/pages/code-review-ja.md
@@ -8,5 +8,5 @@
 
 <Note>
-  Code Review はリサーチプレビュー段階であり、[Teams および Enterprise](https://claude.ai/admin-settings/claude-code) サブスクリプションで利用可能です。[Zero Data Retention](/ja/zero-data-retention) が有効になっている組織では利用できません。
+  Code Review はリサーチプレビュー段階であり、[Team および Enterprise](https://claude.ai/admin-settings/claude-code) サブスクリプションで利用可能です。[Zero Data Retention](/ja/zero-data-retention) が有効になっている組織では利用できません。
 </Note>
 
@@ -46,4 +46,10 @@ Claude を管理サービスではなく独自の CI インフラストラクチ
 結果には、展開可能な拡張推論セクションが含まれており、Claude がなぜ問題をフラグ立てしたのか、どのように問題を検証したのかを理解するために展開できます。
 
+### 結果に対する評価と返信
+
+Claude からの各レビューコメントには、👍 と 👎 が既に添付されているため、GitHub UI で両方のボタンがワンクリック評価のために表示されます。結果が有用だった場合は 👍 をクリックし、間違っていたか騒々しかった場合は 👎 をクリックしてください。Anthropic は PR がマージされた後にリアクションカウントを収集し、それを使用してレビュアーをチューニングします。リアクションは再レビューをトリガーしたり、PR 上の何かを変更したりしません。
+
+インラインコメントに返信しても、Claude が応答したり PR を更新したりするようにプロンプトされません。結果に対処するには、コードを修正してプッシュしてください。PR がプッシュトリガーレビューにサブスクライブされている場合、次の実行は問題が修正されるとスレッドを解決します。プッシュせずに新しいレビューをリクエストするには、[トップレベルの PR コメント](#manually-trigger-reviews)として `@claude review once` とコメントしてください。
+
 ### チェック実行出力
 
@@ -136,12 +142,12 @@ PR の現在の状態についてフィードバックが必要だが、その
 ## レビューをカスタマイズする
 
-Code Review はリポジトリから 2 つのファイルを読み取り、フラグを立てる内容をガイドします。どちらもデフォルトの正確性チェックの上に追加されます：
+Code Review はリポジトリから 2 つのファイルを読み取り、フラグを立てる内容をガイドします。これらは、デフォルトの正確性チェックの上にどの程度強く影響するかが異なります：
 
-* **`CLAUDE.md`**: Claude Code がすべてのタスク（レビューだけではなく）に使用する共有プロジェクト指示。ガイダンスが対話的な Claude Code セッションにも適用される場合に使用します。
-* **`REVIEW.md`**: レビューのみのガイダンス、コードレビュー中にのみ読み取られます。レビュー中にフラグを立てるか、スキップするかについての厳密なルールで、一般的な `CLAUDE.md` を乱雑にするルールに使用します。
```

</details>

<details>
<summary>desktop-ja.md</summary>

```diff
diff --git a/docs-ja/pages/desktop-ja.md b/docs-ja/pages/desktop-ja.md
index 8d5190c..8a9c6a5 100644
--- a/docs-ja/pages/desktop-ja.md
+++ b/docs-ja/pages/desktop-ja.md
@@ -7,5 +7,5 @@
 > Claude Code Desktop をさらに活用する：Git 分離による並列セッション、ドラッグアンドドロップペインレイアウト、統合ターミナルとファイルエディタ、サイドチャット、コンピュータ使用、電話から Dispatch セッションを送信、ビジュアル diff レビュー、アプリプレビュー、PR 監視、コネクタ、エンタープライズ設定。
 
-Claude Desktop アプリ内の Code タブを使用すると、ターミナルではなくグラフィカルインターフェイスを通じて Claude Code を使用できます。
+Claude Desktop アプリには 3 つのタブがあります：**Chat** は会話用、**Cowork** は [Dispatch とより長い agentic work](https://claude.com/product/cowork) 用、**Code** はソフトウェア開発用です。このページは Code タブのリファレンスです。
 
 <CardGroup cols={2}>
@@ -19,27 +19,19 @@ Claude Desktop アプリ内の Code タブを使用すると、ターミナル
 </CardGroup>
 
-For Windows ARM64, download the [ARM64 installer](https://claude.ai/api/desktop/win32/arm64/setup/latest/redirect?utm_source=claude_code\&utm_medium=docs). Linux is not supported.
+For Windows ARM64, download the [ARM64 installer](https://claude.ai/api/desktop/win32/arm64/setup/latest/redirect?utm_source=claude_code\&utm_medium=docs). The desktop app is not available on Linux; use the [CLI](/en/quickstart) instead.
 
-インストール後、Claude を起動してサインインし、**Code**タブをクリックします。最初のセッションの完全なウォークスルーについては、[はじめにガイド](/ja/desktop-quickstart)を参照してください。
+インストール後、Claude を起動してサインインし、**Code** タブをクリックします。Windows で初めて開く場合、[Git for Windows](https://git-scm.com/downloads/win) がインストールされている必要があります。インストール後、アプリを再起動してください。最初のセッションのウォークスルーについては、[はじめにガイド](/ja/desktop-quickstart)を参照してください。
 
-Desktop は標準的な Claude Code エクスペリエンスに以下の機能を追加します：
+Code タブでは、各会話は **セッション** です：独自のチャット履歴、プロジェクトフォルダ、コード変更を持ち、他のセッションとは独立しています。サイドバーはセッションをリストアップし、複数を並列で実行できます。セッション内では以下のことができます：
 
-* [並列セッション](#work-in-parallel-with-sessions)（自動 Git worktree 分離付き）
-* [ドラッグアンドドロップレイアウト](#arrange-your-workspace)（統合ターミナル、ファイルエディタ、プレビューペイン付き）
-* [サイドチャット](#ask-a-side-question-without-derailing-the-session)（メインスレッドに影響を与えずに分岐）
-* [ビジュアル diff レビュー](#review-changes-with-diff-view)（インラインコメント付き）
-* [ライブアプリプレビュー](#preview-your-app)（dev サーバー、HTML ファイル、PDF 付き）
-* [コンピュータ使用](#let-claude-use-your-computer)（macOS と Windows でアプリを開いてスクリーンを制御）
-* [GitHub PR 監視](#monitor-pull-request-status)（自動修正、自動マージ、自動アーカイブ付き）
```

</details>

<details>
<summary>desktop-quickstart-ja.md</summary>

```diff
diff --git a/docs-ja/pages/desktop-quickstart-ja.md b/docs-ja/pages/desktop-quickstart-ja.md
index 2145a52..cb22f4a 100644
--- a/docs-ja/pages/desktop-quickstart-ja.md
+++ b/docs-ja/pages/desktop-quickstart-ja.md
@@ -19,5 +19,5 @@
 </CardGroup>
 
-For Windows ARM64, download the [ARM64 installer](https://claude.ai/api/desktop/win32/arm64/setup/latest/redirect?utm_source=claude_code\&utm_medium=docs). Linux is not supported.
+For Windows ARM64, download the [ARM64 installer](https://claude.ai/api/desktop/win32/arm64/setup/latest/redirect?utm_source=claude_code\&utm_medium=docs). The desktop app is not available on Linux; use the [CLI](/en/quickstart) instead.
 
 <Note>
```

</details>

<details>
<summary>github-actions-ja.md</summary>

```diff
diff --git a/docs-ja/pages/github-actions-ja.md b/docs-ja/pages/github-actions-ja.md
index 4bee071..1d5cdfe 100644
--- a/docs-ja/pages/github-actions-ja.md
+++ b/docs-ja/pages/github-actions-ja.md
@@ -10,9 +10,9 @@ Claude Code GitHub Actions は、GitHub ワークフローに AI を活用した
 
 <Note>
-  Claude Code GitHub Actions は [Claude Agent SDK](https://platform.claude.com/docs/en/agent-sdk/overview) の上に構築されており、Claude Code をアプリケーションにプログラム的に統合できます。SDK を使用して、GitHub Actions を超えたカスタム自動化ワークフローを構築できます。
+  Claude Code GitHub Actions は [Claude Agent SDK](/ja/agent-sdk/overview) の上に構築されており、Claude Code をアプリケーションにプログラム的に統合できます。SDK を使用して、GitHub Actions を超えたカスタム自動化ワークフローを構築できます。
 </Note>
 
 <Info>
-  **Claude Opus 4.6 が利用可能になりました。** Claude Code GitHub Actions はデフォルトで Sonnet を使用します。Opus 4.6 を使用するには、[model パラメータ](#breaking-changes-reference) を `claude-opus-4-6` に設定してください。
+  **Claude Opus 4.7 が利用可能になりました。** Claude Code GitHub Actions はデフォルトで Sonnet を使用します。Opus 4.7 を使用するには、[model パラメータ](#breaking-changes-reference) を `claude-opus-4-7` に設定してください。
 </Info>
 
@@ -46,5 +46,5 @@ Claude Code は、コードの操作方法を変える強力な GitHub Action 
   * GitHub アプリをインストールしてシークレットを追加するには、リポジトリ管理者である必要があります
   * GitHub アプリは、Contents、Issues、Pull requests に対する読み取りと書き込みのアクセス許可をリクエストします
-  * このクイックスタート方法は、直接 Claude API ユーザーのみが利用できます。AWS Bedrock または Google Vertex AI を使用している場合は、[AWS Bedrock と Google Vertex AI での使用](#using-with-aws-bedrock-%26-google-vertex-ai) セクションを参照してください。
+  * このクイックスタート方法は、直接 Claude API ユーザーのみが利用できます。Amazon Bedrock または Google Vertex AI を使用している場合は、[Amazon Bedrock と Google Vertex AI での使用](#using-with-amazon-bedrock-%26-google-vertex-ai) セクションを参照してください。
 </Note>
 
@@ -275,5 +275,5 @@ Claude Code Action v1 は、統一されたパラメータで設定を簡素化
 </Tip>
 
-## AWS Bedrock と Google Vertex AI での使用
+## Amazon Bedrock と Google Vertex AI での使用
 
 エンタープライズ環境では、Claude Code GitHub Actions を独自のクラウドインフラストラクチャで使用できます。このアプローチにより、データレジデンシーと請求を制御しながら、同じ機能を維持できます。
```

</details>

<details>
<summary>gitlab-ci-cd-ja.md</summary>

```diff
diff --git a/docs-ja/pages/gitlab-ci-cd-ja.md b/docs-ja/pages/gitlab-ci-cd-ja.md
index 5597975..e6ad63f 100644
--- a/docs-ja/pages/gitlab-ci-cd-ja.md
+++ b/docs-ja/pages/gitlab-ci-cd-ja.md
@@ -14,5 +14,5 @@
 
 <Note>
-  この統合は [Claude Code CLI and Agent SDK](https://platform.claude.com/docs/ja/agent-sdk/overview) の上に構築されており、CI/CD ジョブとカスタム自動化ワークフローで Claude をプログラム的に使用できます。
+  この統合は [Claude Code CLI and Agent SDK](/ja/agent-sdk/overview) の上に構築されており、CI/CD ジョブとカスタム自動化ワークフローで Claude をプログラム的に使用できます。
 </Note>
 
@@ -23,5 +23,5 @@
 * **プロジェクト対応**: Claude は `CLAUDE.md` ガイドラインと既存のコードパターンに従います
 * **シンプルなセットアップ**: `.gitlab-ci.yml` に 1 つのジョブとマスクされた CI/CD 変数を追加します
-* **エンタープライズ対応**: Claude API、AWS Bedrock、または Google Vertex AI を選択して、データレジデンシーと調達のニーズを満たします
+* **エンタープライズ対応**: Claude API、Amazon Bedrock、または Google Vertex AI を選択して、データレジデンシーと調達のニーズを満たします
 * **デフォルトでセキュア**: GitLab ランナーで実行され、ブランチ保護と承認が適用されます
 
@@ -34,5 +34,5 @@ Claude Code は GitLab CI/CD を使用して AI タスクを分離されたジ
 2. **プロバイダー抽象化**: 環境に適したプロバイダーを使用します。
    * Claude API（SaaS）
-   * AWS Bedrock（IAM ベースのアクセス、クロスリージョンオプション）
+   * Amazon Bedrock（IAM ベースのアクセス、クロスリージョンオプション）
    * Google Vertex AI（GCP ネイティブ、Workload Identity Federation）
 
@@ -99,5 +99,5 @@ claude:
 
 <Note>
-  Claude API の代わりに AWS Bedrock または Google Vertex AI で実行するには、以下の [Using with AWS Bedrock & Google Vertex AI](#using-with-aws-bedrock--google-vertex-ai) セクションを参照して、認証と環境セットアップを確認してください。
+  Claude API の代わりに Amazon Bedrock または Google Vertex AI で実行するには、以下の [Using with Amazon Bedrock & Google Vertex AI](#using-with-amazon-bedrock--google-vertex-ai) セクションを参照して、認証と環境セットアップを確認してください。
```

</details>

<details>
<summary>legal-and-compliance-ja.md</summary>

```diff
diff --git a/docs-ja/pages/legal-and-compliance-ja.md b/docs-ja/pages/legal-and-compliance-ja.md
index cb5693a..2419d8c 100644
--- a/docs-ja/pages/legal-and-compliance-ja.md
+++ b/docs-ja/pages/legal-and-compliance-ja.md
@@ -18,5 +18,5 @@ Claude Code の使用は、以下の対象となります。
 ### 商用契約
 
-Claude API を直接（1P）使用している場合でも、AWS Bedrock または Google Vertex を通じてアクセスしている場合（3P）でも、既存の商用契約が Claude Code の使用に適用されます。ただし、相互に別途合意した場合を除きます。
+Claude API を直接（1P）使用している場合でも、Amazon Bedrock または Google Vertex を通じてアクセスしている場合（3P）でも、既存の商用契約が Claude Code の使用に適用されます。ただし、相互に別途合意した場合を除きます。
 
 ## 規制対応
```

</details>

<details>
<summary>monitoring-usage-ja.md</summary>

```diff
diff --git a/docs-ja/pages/monitoring-usage-ja.md b/docs-ja/pages/monitoring-usage-ja.md
index 7c8fc94..0a23d1a 100644
--- a/docs-ja/pages/monitoring-usage-ja.md
+++ b/docs-ja/pages/monitoring-usage-ja.md
@@ -860,5 +860,5 @@ API リクエストが複数回の試行後に失敗した場合に 1 回ログ
 
 <Note>
-  コストメトリクスは概算です。公式な請求データについては、API プロバイダー (Claude Console、AWS Bedrock、または Google Cloud Vertex) を参照してください。
+  コストメトリクスは概算です。公式な請求データについては、API プロバイダー (Claude Console、Amazon Bedrock、または Google Cloud Vertex) を参照してください。
 </Note>
 
```

</details>

*...以降省略*

</details>


<details>
<summary>2026-05-02</summary>

**変更ファイル:**

```
 docs-ja/pages/authentication-ja.md       |  2 +-
 docs-ja/pages/auto-mode-config-ja.md     |  4 ++
 docs-ja/pages/changelog.md               | 35 +++++++++++++++
 docs-ja/pages/claude-directory-ja.md     | 35 ++++++++++++++-
 docs-ja/pages/cli-reference-ja.md        | 43 +++++++++---------
 docs-ja/pages/data-usage-ja.md           |  2 +
 docs-ja/pages/env-vars-ja.md             |  3 ++
 docs-ja/pages/fullscreen-ja.md           |  4 ++
 docs-ja/pages/headless-ja.md             | 77 +++++++++++++++++++++++++++++---
 docs-ja/pages/hooks-guide-ja.md          | 36 +++++++--------
 docs-ja/pages/hooks-ja.md                | 48 ++++++++++----------
 docs-ja/pages/interactive-mode-ja.md     |  7 +--
 docs-ja/pages/keybindings-ja.md          | 71 +++++++++++++++--------------
 docs-ja/pages/llm-gateway-ja.md          | 10 ++++-
 docs-ja/pages/model-config-ja.md         |  2 +-
 docs-ja/pages/monitoring-usage-ja.md     | 28 +++++++++---
 docs-ja/pages/permission-modes-ja.md     | 14 +++---
 docs-ja/pages/permissions-ja.md          | 48 ++++++++++++++------
 docs-ja/pages/plugins-reference-ja.md    |  2 +-
 docs-ja/pages/sub-agents-ja.md           | 38 ++++++++--------
 docs-ja/pages/tools-reference-ja.md      |  2 +-
 docs-ja/pages/troubleshoot-install-ja.md | 14 +++---
 22 files changed, 363 insertions(+), 162 deletions(-)
```

<details>
<summary>authentication-ja.md</summary>

```diff
diff --git a/docs-ja/pages/authentication-ja.md b/docs-ja/pages/authentication-ja.md
index d100276..af808d9 100644
--- a/docs-ja/pages/authentication-ja.md
+++ b/docs-ja/pages/authentication-ja.md
@@ -15,5 +15,5 @@ Claude Code は、セットアップに応じて複数の認証方法をサポ
 ブラウザが自動的に開かない場合は、`c` を押してログイン URL をクリップボードにコピーし、ブラウザに貼り付けます。
 
-ブラウザがサインイン後にリダイレクトされずにログインコードを表示する場合は、`Paste code here if prompted` プロンプトでそれをターミナルに貼り付けます。
+ブラウザがサインイン後にリダイレクトされずにログインコードを表示する場合は、`Paste code here if prompted` プロンプトでそれをターミナルに貼り付けます。これは、ブラウザが Claude Code のローカルコールバックサーバーに到達できない場合に発生します。これは WSL2、SSH セッション、およびコンテナで一般的です。
 
 以下のいずれかのアカウントタイプで認証できます。
```

</details>

<details>
<summary>auto-mode-config-ja.md</summary>

```diff
diff --git a/docs-ja/pages/auto-mode-config-ja.md b/docs-ja/pages/auto-mode-config-ja.md
index 7cb4b3c..5a1d229 100644
--- a/docs-ja/pages/auto-mode-config-ja.md
+++ b/docs-ja/pages/auto-mode-config-ja.md
@@ -9,4 +9,8 @@
 [オートモード](/ja/permission-modes#eliminate-prompts-with-auto-mode)を使用すると、Claude Code は各ツール呼び出しを分類器にルーティングして、不可逆的、破壊的、または環境外を対象とした操作をブロックすることで、権限プロンプトなしで実行できます。`autoMode` 設定ブロックを使用して、その分類器に、組織が信頼するリポジトリ、バケット、ドメインを指定すると、ルーチンの内部操作のブロックが停止します。
 
+<Note>
+  オートモードは、Anthropic API を通じて Max、Team、Enterprise、API プランで利用可能です。Pro プランでは利用できず、Bedrock、Vertex、Foundry でも利用できません。Claude Code がアカウントでオートモードが利用不可と報告する場合は、[完全な要件](/ja/permission-modes#eliminate-prompts-with-auto-mode)を確認してください。これには、サポートされているモデルと Team および Enterprise プランの管理者有効化も含まれます。
+</Note>
+
 デフォルトでは、分類器は作業ディレクトリと現在のリポジトリの設定されたリモートのみを信頼します。会社のソース管理組織へのプッシュやチームクラウドバケットへの書き込みなどのアクションは、`autoMode.environment` に追加するまでブロックされます。
 
```

</details>

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index 6cf89e7..01788b6 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,39 @@
 # Changelog
 
+## 2.1.126
+
+- The `/model` picker now lists models from your gateway's `/v1/models` endpoint when `ANTHROPIC_BASE_URL` points at an Anthropic-compatible gateway
+- - Added `claude project purge [path]` to delete all Claude Code state for a project (transcripts, tasks, file history, config entry) — supports `--dry-run`, `-y/--yes`, `-i/--interactive`, and `--all`
+- `--dangerously-skip-permissions` now bypasses prompts for writes to `.claude/`, `.git/`, `.vscode/`, shell config files, and other previously-protected paths (catastrophic removal commands still prompt as a safety net)
+- `claude auth login` now accepts the OAuth code pasted into the terminal when the browser callback can't reach localhost (WSL2, SSH, containers)
+- `claude_code.skill_activated` OpenTelemetry event now fires for user-typed slash commands and carries a new `invocation_trigger` attribute (`"user-slash"`, `"claude-proactive"`, or `"nested-skill"`)
+- Auto mode: the spinner now turns red when a permission check stalls, instead of looking like the tool is running
+- Host-managed deployments (`CLAUDE_CODE_PROVIDER_MANAGED_BY_HOST`) no longer auto-disable analytics on Bedrock/Vertex/Foundry
+- Windows: PowerShell 7 installed via the Microsoft Store, MSI without PATH, or `.NET global tool` is now detected
+- Windows: when the PowerShell tool is enabled, Claude now treats PowerShell as the primary shell instead of defaulting to Bash
+- Read tool: removed the per-file malware-assessment reminder that could cause spurious refusals and "this is not malware" commentary on legacy models
+- **Security:** Fixed `allowManagedDomainsOnly` / `allowManagedReadPathsOnly` being ignored when a higher-priority managed-settings source lacked a `sandbox` block
+- Fixed pasting an image larger than 2000px breaking the session — images are now downscaled on paste, and oversized images in history are automatically removed and the request retried
+- Fixed showing the login screen for "OAuth not allowed for organization" errors — now shows guidance to contact your admin
+- Fixed OAuth login failing with timeout on slow or proxied connections, in IPv6-only devcontainers, and when the browser callback can't reach localhost
+- Fixed a rare race where a concurrent credential write could clear a valid OAuth refresh token
+- Fixed API retry countdown sticking at "0s" instead of counting down between attempts
+- Fixed "Stream idle timeout" error after waking Mac from sleep mid-request
+- Fixed background and remote sessions falsely aborting with "Stream idle timeout" during long model thinking pauses
+- Fixed a hang where the assistant could finish thinking but show no output after a run of empty turns
+- Fixed overly fast trackpad scrolling in Cursor and VS Code 1.92–1.104 integrated terminals
+- Fixed claude.ai MCP connectors being suppressed by manual servers stuck in needs-auth state
```

</details>

<details>
<summary>claude-directory-ja.md</summary>

```diff
diff --git a/docs-ja/pages/claude-directory-ja.md b/docs-ja/pages/claude-directory-ja.md
index fbee99f..b501cf1 100644
--- a/docs-ja/pages/claude-directory-ja.md
+++ b/docs-ja/pages/claude-directory-ja.md
@@ -1530,5 +1530,38 @@ Windows では、`~/.claude` は `%USERPROFILE%\.claude` に解決されます
 ### ローカルデータをクリアする
 
-上記のアプリケーションデータパスのいずれかをいつでも削除できます。新しいセッションは影響を受けません。以下のテーブルは、過去のセッションで失うものを示しています。
+`claude project purge` を実行して、1 つのプロジェクトに対して Claude Code が保持する状態を削除します：
+
+* `projects/` の下のトランスクリプトと自動メモリ
+* セッションごとの `tasks/`、`debug/`、`file-history/` エントリ
+* `history.jsonl` の一致するプロンプト行
+* `~/.claude.json` のプロジェクトエントリ
+
+このコマンドは完全な削除計画を出力し、何かを削除する前に確認を求めます。
+
+削除せずに計画をプレビューします：
+
+```bash theme={null}
+claude project purge ~/work/my-repo --dry-run
+```
+
+単一の確認プロンプトで削除します：
+
+```bash theme={null}
+claude project purge ~/work/my-repo
+```
+
+パスを省略して、対話型リストからプロジェクトを選択します。
```

</details>

<details>
<summary>cli-reference-ja.md</summary>

```diff
diff --git a/docs-ja/pages/cli-reference-ja.md b/docs-ja/pages/cli-reference-ja.md
index d12336f..d535196 100644
--- a/docs-ja/pages/cli-reference-ja.md
+++ b/docs-ja/pages/cli-reference-ja.md
@@ -11,25 +11,26 @@
 これらのコマンドを使用して、セッションを開始し、コンテンツをパイプし、会話を再開し、更新を管理できます。
 
-| コマンド                            | 説明                                                                                                                                                                                                         | 例                                                           |
-| :------------------------------ | :--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :---------------------------------------------------------- |
-| `claude`                        | インタラクティブセッションを開始                                                                                                                                                                                           | `claude`                                                    |
-| `claude "query"`                | 初期プロンプト付きでインタラクティブセッションを開始                                                                                                                                                                                 | `claude "explain this project"`                             |
-| `claude -p "query"`             | SDK 経由でクエリを実行してから終了                                                                                                                                                                                        | `claude -p "explain this function"`                         |
-| `cat file \| claude -p "query"` | パイプされたコンテンツを処理                                                                                                                                                                                             | `cat logs.txt \| claude -p "explain"`                       |
-| `claude -c`                     | 現在のディレクトリで最新の会話を続行                                                                                                                                                                                         | `claude -c`                                                 |
-| `claude -c -p "query"`          | SDK 経由で続行                                                                                                                                                                                                  | `claude -c -p "Check for type errors"`                      |
-| `claude -r "<session>" "query"` | セッション ID または名前でセッションを再開                                                                                                                                                                                    | `claude -r "auth-refactor" "Finish this PR"`                |
-| `claude update`                 | 最新バージョンに更新                                                                                                                                                                                                 | `claude update`                                             |
-| `claude install [version]`      | ネイティブバイナリをインストールまたは再インストールします。`2.1.118` のようなバージョン、または `stable` または `latest` を受け入れます。[特定のバージョンをインストール](/ja/setup#install-a-specific-version) を参照してください                                                      | `claude install stable`                                     |
-| `claude auth login`             | Anthropic アカウントにサインインします。`--email` を使用してメールアドレスを事前入力し、`--sso` を使用して SSO 認証を強制し、`--console` を使用して Claude サブスクリプションの代わりに Anthropic Console で API 使用料金をサインインできます                                              | `claude auth login --console`                               |
-| `claude auth logout`            | Anthropic アカウントからログアウト                                                                                                                                                                                     | `claude auth logout`                                        |
-| `claude auth status`            | 認証ステータスを JSON として表示します。`--text` を使用して人間が読める形式で表示できます。ログイン済みの場合はコード 0 で終了し、ログインしていない場合は 1 で終了します                                                                                                            | `claude auth status`                                        |
-| `claude agents`                 | すべての設定済み [subagents](/ja/sub-agents) をソース別にグループ化して一覧表示                                                                                                                                                     | `claude agents`                                             |
-| `claude auto-mode defaults`     | 組み込み [auto mode](/ja/permission-modes#eliminate-prompts-with-auto-mode) 分類器ルールを JSON として出力します。`claude auto-mode config` を使用して、設定が適用された有効な設定を確認してください                                                       | `claude auto-mode defaults > rules.json`                    |
-| `claude mcp`                    | Model Context Protocol（MCP）サーバーを設定                                                                                                                                                                         | [Claude Code MCP ドキュメント](/ja/mcp) を参照してください。                |
-| `claude plugin`                 | Claude Code [plugins](/ja/plugins) を管理します。エイリアス：`claude plugins`。サブコマンドについては [plugin reference](/ja/plugins-reference#cli-commands-reference) を参照してください                                                    | `claude plugin install code-review@claude-plugins-official` |
-| `claude remote-control`         | [Remote Control](/ja/remote-control) サーバーを開始して、Claude.ai または Claude アプリから Claude Code を制御します。サーバーモード（ローカルインタラクティブセッションなし）で実行されます。[サーバーモードフラグ](/ja/remote-control#start-a-remote-control-session) を参照してください | `claude remote-control --name "My Project"`                 |
-| `claude setup-token`            | CI とスクリプト用の長期間有効な OAuth トークンを生成します。ターミナルにトークンを出力し、保存しません。Claude サブスクリプションが必要です。[長期間有効なトークンを生成](/ja/authentication#generate-a-long-lived-token) を参照してください                                                   | `claude setup-token`                                        |
-| `claude ultrareview [target]`   | [ultrareview](/ja/ultrareview#run-ultrareview-non-interactively) を非対話的に実行します。結果を stdout に出力し、成功時は 0 で終了し、失敗時は 1 で終了します。`--json` を使用して生のペイロードを取得し、`--timeout <minutes>` を使用して 30 分のデフォルトをオーバーライドできます        | `claude ultrareview 1234 --json`                            |
+| コマンド                            | 説明                                                                                                                                                                                                                                                                                                             | 例                                                           |
+| :------------------------------ | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :---------------------------------------------------------- |
```

</details>

<details>
<summary>data-usage-ja.md</summary>

```diff
diff --git a/docs-ja/pages/data-usage-ja.md b/docs-ja/pages/data-usage-ja.md
index 715a115..92376e4 100644
--- a/docs-ja/pages/data-usage-ja.md
+++ b/docs-ja/pages/data-usage-ja.md
@@ -116,4 +116,6 @@ Claude Code は、ユーザーのマシンから Sentry に接続して、運用
 すべての環境変数は `settings.json` にチェックインできます（[settings reference](/ja/settings) を参照）。
 
+v2.1.126 以降、ホストプラットフォームが `CLAUDE_CODE_PROVIDER_MANAGED_BY_HOST` を設定する場合、Statsig メトリクスは Vertex、Bedrock、および Foundry でデフォルトでオンになり、標準の `DISABLE_TELEMETRY` オプトアウトに従います。Sentry エラーレポートと `/feedback` レポートは、これらのプロバイダーではデフォルトでオフのままです。
+
 ### WebFetch ドメインセーフティチェック
 
```

</details>

<details>
<summary>env-vars-ja.md</summary>

```diff
diff --git a/docs-ja/pages/env-vars-ja.md b/docs-ja/pages/env-vars-ja.md
index dd25739..f4c5c35 100644
--- a/docs-ja/pages/env-vars-ja.md
+++ b/docs-ja/pages/env-vars-ja.md
@@ -16,4 +16,5 @@ Claude Code は、その動作を制御するために以下の環境変数を
 | `ANTHROPIC_BEDROCK_BASE_URL`                            | Bedrock エンドポイント URL をオーバーライドします。カスタム Bedrock エンドポイントを使用する場合、または [LLM ゲートウェイ](/ja/llm-gateway) を通じてルーティングする場合に使用します。[Amazon Bedrock](/ja/amazon-bedrock) を参照してください                                                                                                                                                                                                                                                     |
 | `ANTHROPIC_BEDROCK_MANTLE_BASE_URL`                     | Bedrock Mantle エンドポイント URL をオーバーライドします。[Mantle エンドポイント](/ja/amazon-bedrock#use-the-mantle-endpoint) を参照してください                                                                                                                                                                                                                                                                                                         |
+| `ANTHROPIC_BEDROCK_SERVICE_TIER`                        | Bedrock [サービスティア](https://docs.aws.amazon.com/bedrock/latest/userguide/service-tiers-inference.html)（`default`、`flex`、または `priority`）。`X-Amzn-Bedrock-Service-Tier` ヘッダーとして送信されます。[Amazon Bedrock](/ja/amazon-bedrock#service-tiers) を参照してください                                                                                                                                                                        |
 | `ANTHROPIC_BETAS`                                       | API リクエストに含める追加の `anthropic-beta` ヘッダー値のカンマ区切りリスト。Claude Code は既に必要なベータヘッダーを送信しています。Claude Code がネイティブサポートを追加する前に、[Anthropic API ベータ](https://platform.claude.com/docs/en/api/beta-headers) にオプトインするために使用します。API キー認証が必要な [`--betas` フラグ](/ja/cli-reference#cli-flags) とは異なり、この変数は Claude.ai サブスクリプションを含むすべての認証方法で機能します                                                                                               |
 | `ANTHROPIC_CUSTOM_HEADERS`                              | リクエストに追加するカスタムヘッダー（`Name: Value` 形式、複数のヘッダーの場合は改行で区切られます）                                                                                                                                                                                                                                                                                                                                                             |
@@ -125,4 +126,5 @@ Claude Code は、その動作を制御するために以下の環境変数を
 | `CLAUDE_CODE_PLUGIN_KEEP_MARKETPLACE_ON_FAILURE`        | `git pull` が失敗した場合、既存のマーケットプレイスキャッシュを保持するには `1` に設定します。ワイプして再クローンする代わりに。オフラインまたはエアギャップ環境で役立ちます。再クローンは同じ方法で失敗します。[オフライン環境でのマーケットプレイス更新の失敗](/ja/plugin-marketplaces#marketplace-updates-fail-in-offline-environments) を参照してください                                                                                                                                                                                         |
 | `CLAUDE_CODE_PLUGIN_SEED_DIR`                           | 1 つ以上の読み取り専用プラグインシードディレクトリへのパス。Unix では `:` で、Windows では `;` で区切られます。事前入力されたプラグインディレクトリをコンテナイメージにバンドルするために使用します。Claude Code はこれらのディレクトリからマーケットプレイスを登録し、再クローンなしで事前キャッシュされたプラグインを使用します。[コンテナ用のプラグインを事前入力](/ja/plugin-marketplaces#pre-populate-plugins-for-containers) を参照してください                                                                                                                                         |
+| `CLAUDE_CODE_PROVIDER_MANAGED_BY_HOST`                  | Claude Code を埋め込み、その代わりにモデルプロバイダーのルーティングを管理するホストプラットフォームによって設定されます。設定されている場合、`CLAUDE_CODE_USE_BEDROCK`、`ANTHROPIC_BASE_URL`、`ANTHROPIC_API_KEY` などのプロバイダー選択、エンドポイント、認証変数は設定ファイルで無視されるため、ユーザー設定はホストのルーティングをオーバーライドできません。Bedrock、Vertex、Foundry の自動テレメトリオプトアウトもスキップされるため、テレメトリは標準の `DISABLE_TELEMETRY` オプトアウトに従います。[API プロバイダーごとのデフォルト動作](/ja/data-usage#default-behaviors-by-api-provider) を参照してください                   |
 | `CLAUDE_CODE_PROXY_RESOLVES_HOSTS`                      | プロキシが呼び出し元の代わりに DNS 解決を実行できるようにするには `1` に設定します。プロキシがホスト名解決を処理する必要がある環境でオプトインします                                                                                                                                                                                                                                                                                                                                       |
 | `CLAUDE_CODE_REMOTE`                                    | Claude Code が [クラウドセッション](/ja/claude-code-on-the-web) として実行されている場合に自動的に `true` に設定されます。フックまたはセットアップスクリプトからこれを読み取って、クラウド環境にいるかどうかを検出します                                                                                                                                                                                                                                                                                |
@@ -170,4 +172,5 @@ Claude Code は、その動作を制御するために以下の環境変数を
 | `DISABLE_EXTRA_USAGE_COMMAND`                           | ユーザーがレート制限を超えて追加使用量を購入できる `/extra-usage` コマンドを非表示にするには `1` に設定します                                                                                                                                                                                                                                                                                                                                                     |
 | `DISABLE_FEEDBACK_COMMAND`                              | `/feedback` コマンドを無効にするには `1` に設定します。古い名前 `DISABLE_BUG_COMMAND` も受け入れられます                                                                                                                                                                                                                                                                                                                                              |
+| `DISABLE_GROWTHBOOK`                                    | GrowthBook フィーチャーフラグ取得を無効にするには `1` に設定します。すべてのフラグにコードデフォルトを使用します。テレメトリイベントログは `DISABLE_TELEMETRY` も設定されていない限りオンのままです                                                                                                                                                                                                                                                                                                  |
 | `DISABLE_INSTALLATION_CHECKS`                           | インストール警告を無効にするには `1` に設定します。インストール場所を手動で管理する場合にのみ使用してください。標準インストールの問題をマスクする可能性があります                                                                                                                                                                                                                                                                                                                                   |
 | `DISABLE_INSTALL_GITHUB_APP_COMMAND`                    | `/install-github-app` コマンドを非表示にするには `1` に設定します。サードパーティプロバイダー（Bedrock、Vertex、または Foundry）を使用する場合は既に非表示です                                                                                                                                                                                                                                                                                                               |
```

</details>

<details>
<summary>fullscreen-ja.md</summary>

```diff
diff --git a/docs-ja/pages/fullscreen-ja.md b/docs-ja/pages/fullscreen-ja.md
index 452ec3f..a334d36 100644
--- a/docs-ja/pages/fullscreen-ja.md
+++ b/docs-ja/pages/fullscreen-ja.md
@@ -117,4 +117,8 @@ export CLAUDE_CODE_SCROLL_SPEED=3
 `Esc` または `q` を押してプロンプトに戻ります。
 
+## 会話をクリアする
+
+2 秒以内に `Ctrl+L` を 2 回押して `/clear` を実行し、新しい会話を開始します。最初のプレスは画面を再描画してヒントを表示します。2 番目のプレスは会話をクリアします。macOS では、`Cmd+K` をダブルプレスしても `/clear` が実行されます。
+
 ## tmux で使用する
 
```

</details>

*...以降省略*

</details>


<details>
<summary>2026-05-01</summary>

**変更ファイル:**

```
 docs-ja/pages/memory-ja.md | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)
```

<details>
<summary>memory-ja.md</summary>

```diff
diff --git a/docs-ja/pages/memory-ja.md b/docs-ja/pages/memory-ja.md
index fb7c79b..2d83d0b 100644
--- a/docs-ja/pages/memory-ja.md
+++ b/docs-ja/pages/memory-ja.md
@@ -48,5 +48,5 @@ CLAUDE.md を、そうでなければ再度説明する場所として扱いま
 * 新しいチームメンバーが生産的になるために同じコンテキストが必要になる
 
-Claude がすべてのセッションで保持すべき事実に限定します。ビルドコマンド、規約、プロジェクトレイアウト、「常に X を実行する」ルール。エントリが複数ステップの手順である場合、またはコードベースの 1 つの部分にのみ関連する場合は、代わりに [skill](/ja/skills) または [パススコープルール](#organize-rules-with-clauderules) に移動します。[拡張機能の概要](/ja/features-overview#build-your-setup-over-time)では、各メカニズムをいつ使用するかについて説明しています。
+Claude がすべてのセッションで保持すべき事実に限定します。ビルドコマンド、規約、プロジェクトレイアウト、「常に X を実行する」ルール。エントリが複数ステップの手順である場合、またはコードベースの 1 つの部分にのみ関連する場合は、代わりに [skill](/ja/skills) または [パススコープルール](#organize-rules-with-claude/rules/) に移動します。[拡張機能の概要](/ja/features-overview#build-your-setup-over-time)では、各メカニズムをいつ使用するかについて説明しています。
 
 ### CLAUDE.md ファイルをどこに配置するかを選択する
@@ -61,7 +61,7 @@ CLAUDE.md ファイルはいくつかの場所に配置でき、それぞれ異
 | **ローカル指示**   | `./CLAUDE.local.md`                                                                                                                                                   | 個人的なプロジェクト固有の好み。`.gitignore` に追加します | あなたのサンドボックス URL、好みのテストデータ         | あなただけ（現在のプロジェクト）  |
 
-ワーキングディレクトリより上のディレクトリ階層内の CLAUDE.md および CLAUDE.local.md ファイルは、起動時に完全に読み込まれます。サブディレクトリ内のファイルは、Claude がそれらのディレクトリ内のファイルを読むときにオンデマンドで読み込まれます。完全な解決順序については、[CLAUDE.md ファイルの読み込み方法](#how-claudemd-files-load)を参照してください。
+ワーキングディレクトリより上のディレクトリ階層内の CLAUDE.md および CLAUDE.local.md ファイルは、起動時に完全に読み込まれます。サブディレクトリ内のファイルは、Claude がそれらのディレクトリ内のファイルを読むときにオンデマンドで読み込まれます。完全な解決順序については、[CLAUDE.md ファイルの読み込み方法](#how-claude-md-files-load)を参照してください。
 
-大規模なプロジェクトの場合、[プロジェクトルール](#organize-rules-with-clauderules)を使用してトピック固有のファイルに指示を分割できます。ルールを使用すると、特定のファイルタイプまたはサブディレクトリに指示をスコープできます。
+大規模なプロジェクトの場合、[プロジェクトルール](#organize-rules-with-claude/rules/)を使用してトピック固有のファイルに指示を分割できます。ルールを使用すると、特定のファイルタイプまたはサブディレクトリに指示をスコープできます。
 
 ### プロジェクト CLAUDE.md を設定する
@@ -89,5 +89,5 @@ CLAUDE.md ファイルは各セッションの開始時にコンテキストウ
 * 「ファイルを整理しておく」ではなく「API ハンドラーは `src/api/handlers/` に存在する」
 
-**一貫性**: 2 つのルールが互いに矛盾している場合、Claude は 1 つを任意に選択する可能性があります。CLAUDE.md ファイル、サブディレクトリ内のネストされた CLAUDE.md ファイル、および [`.claude/rules/`](#organize-rules-with-clauderules) を定期的に確認して、古い指示または矛盾する指示を削除します。モノレポでは、[`claudeMdExcludes`](#exclude-specific-claudemd-files) を使用して、作業に関連のない他のチームの CLAUDE.md ファイルをスキップします。
+**一貫性**: 2 つのルールが互いに矛盾している場合、Claude は 1 つを任意に選択する可能性があります。CLAUDE.md ファイル、サブディレクトリ内のネストされた CLAUDE.md ファイル、および [`.claude/rules/`](#organize-rules-with-claude/rules/) を定期的に確認して、古い指示または矛盾する指示を削除します。モノレポでは、[`claudeMdExcludes`](#exclude-specific-claude-md-files) を使用して、作業に関連のない他のチームの CLAUDE.md ファイルをスキップします。
 
 ### 追加ファイルをインポートする
@@ -119,5 +119,5 @@ README、package.json、およびワークフローガイドを取得するに
 </Warning>
```

</details>

</details>


<details>
<summary>2026-04-30</summary>

**変更ファイル:**

```
 docs-ja/pages/changelog.md               |  4 ++++
 docs-ja/pages/claude-directory-ja.md     |  2 +-
 docs-ja/pages/env-vars-ja.md             |  2 +-
 docs-ja/pages/overview-ja.md             |  6 +++---
 docs-ja/pages/quickstart-ja.md           |  6 +++---
 docs-ja/pages/setup-ja.md                | 14 +++++++-------
 docs-ja/pages/skills-ja.md               |  3 +--
 docs-ja/pages/statusline-ja.md           |  4 ++--
 docs-ja/pages/tools-reference-ja.md      |  2 +-
 docs-ja/pages/troubleshoot-install-ja.md | 25 +++++++++++++++++++++----
 docs-ja/pages/ultrareview-ja.md          |  2 ++
 11 files changed, 46 insertions(+), 24 deletions(-)
```

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index 7359d2c..6cf89e7 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,8 @@
 # Changelog
 
+## 2.1.123
+
+- Fixed OAuth authentication failing with a 401 retry loop when `CLAUDE_CODE_DISABLE_EXPERIMENTAL_BETAS=1` is set
+
 ## 2.1.122
 
```

</details>

<details>
<summary>claude-directory-ja.md</summary>

```diff
diff --git a/docs-ja/pages/claude-directory-ja.md b/docs-ja/pages/claude-directory-ja.md
index f951427..fbee99f 100644
--- a/docs-ja/pages/claude-directory-ja.md
+++ b/docs-ja/pages/claude-directory-ja.md
@@ -486,5 +486,5 @@ Every finding must include a concrete fix.`
           oneLiner: 'Custom keyboard shortcuts',
           when: 'Read at session start and hot-reloaded when you edit the file',
-          description: <>Rebind keyboard shortcuts in the interactive CLI. Run <C>/keybindings</C> to create or open this file with a schema reference. Ctrl+C, Ctrl+D, and Ctrl+M are reserved and cannot be rebound.</>,
+          description: <>Rebind keyboard shortcuts in the interactive CLI. Run <C>/keybindings</C> to create or open this file with a schema reference. Ctrl+C, Ctrl+D, Ctrl+M, and Caps Lock are reserved and cannot be rebound.</>,
           exampleIntro: <>This example binds <C>Ctrl+E</C> to open your external editor and unbinds <C>Ctrl+U</C> by setting it to <C>null</C>. The <C>context</C> field scopes bindings to a specific part of the CLI, here the main chat input.</>,
           example: `{
```

</details>

<details>
<summary>env-vars-ja.md</summary>

```diff
diff --git a/docs-ja/pages/env-vars-ja.md b/docs-ja/pages/env-vars-ja.md
index 9fe4beb..dd25739 100644
--- a/docs-ja/pages/env-vars-ja.md
+++ b/docs-ja/pages/env-vars-ja.md
@@ -154,5 +154,5 @@ Claude Code は、その動作を制御するために以下の環境変数を
 | `CLAUDE_CODE_USE_MANTLE`                                | Bedrock [Mantle エンドポイント](/ja/amazon-bedrock#use-the-mantle-endpoint) を使用します                                                                                                                                                                                                                                                                                                                                           |
 | `CLAUDE_CODE_USE_NATIVE_FILE_SEARCH`                    | ripgrep の代わりに Node.js ファイル API を使用してカスタムコマンド、subagent、出力スタイルを検出するには `1` に設定します。バンドルされた ripgrep バイナリが利用できないか、環境でブロックされている場合に設定します。Grep またはファイル検索ツールには影響しません                                                                                                                                                                                                                                                            |
-| `CLAUDE_CODE_USE_POWERSHELL_TOOL`                       | PowerShell ツールを制御します。Windows では、ツールは段階的にロールアウトされています：オプトインするには `1` に、オプトアウトするには `0` に設定します。Linux、macOS、WSL では、有効にするには `1` に設定します。これには PATH に `pwsh` が必須です。Windows で有効にすると、Claude は Git Bash を通じてルーティングする代わりに PowerShell コマンドをネイティブに実行できます。[PowerShell ツール](/ja/tools-reference#powershell-tool) を参照してください                                                                                                             |
+| `CLAUDE_CODE_USE_POWERSHELL_TOOL`                       | PowerShell ツールを制御します。Windows では Git Bash がない場合、ツールは自動的に有効になります。無効にするには `0` に設定します。Windows に Git Bash がインストールされている場合、ツールは段階的にロールアウトされています：オプトインするには `1` に、オプトアウトするには `0` に設定します。Linux、macOS、WSL では、有効にするには `1` に設定します。これには PATH に `pwsh` が必須です。Windows で有効にすると、Claude は Git Bash を通じてルーティングする代わりに PowerShell コマンドをネイティブに実行できます。[PowerShell ツール](/ja/tools-reference#powershell-tool) を参照してください                         |
 | `CLAUDE_CODE_USE_VERTEX`                                | [Vertex](/ja/google-vertex-ai) を使用します                                                                                                                                                                                                                                                                                                                                                                                 |
 | `CLAUDE_CONFIG_DIR`                                     | 設定ディレクトリをオーバーライドします（デフォルト：`~/.claude`）。すべての設定、認証情報、セッション履歴、プラグインはこのパスの下に保存されます。複数のアカウントを並行して実行する場合に役立ちます：例えば、`alias claude-work='CLAUDE_CONFIG_DIR=~/.claude-work claude'`                                                                                                                                                                                                                                            |
```

</details>

<details>
<summary>overview-ja.md</summary>

```diff
diff --git a/docs-ja/pages/overview-ja.md b/docs-ja/pages/overview-ja.md
index e3a9595..2334771 100644
--- a/docs-ja/pages/overview-ja.md
+++ b/docs-ja/pages/overview-ja.md
@@ -490,8 +490,8 @@ export const InstallConfigurator = ({defaultSurface = 'terminal'}) => {
       {target === 'terminal' && <div className="cc-ic-below">
           {isWinInstaller && <span>
-              Requires{' '}
               <a href="https://git-scm.com/downloads/win" target="_blank" rel="noopener">
                 Git for Windows
-              </a>.
+              </a>{' '}
+              recommended. PowerShell is used if Git Bash is absent.
             </span>}
           {(pkg === 'brew' || pkg === 'winget') && <span>
@@ -675,5 +675,5 @@ Claude Code は AI を活用したコーディングアシスタントで、機
         If you see `The token '&&' is not a valid statement separator`, you're in PowerShell, not CMD. If you see `'irm' is not recognized as an internal or external command`, you're in CMD, not PowerShell. Your prompt shows `PS C:\` when you're in PowerShell and `C:\` without the `PS` when you're in CMD.
 
-        [Git for Windows](https://git-scm.com/downloads/win) is required on native Windows so Claude Code can use the Bash tool. WSL setups do not need Git for Windows.
+        [Git for Windows](https://git-scm.com/downloads/win) is recommended on native Windows so Claude Code can use the Bash tool. If Git for Windows is not installed, Claude Code uses PowerShell as the shell tool instead. WSL setups do not need Git for Windows.
 
         <Info>
```

</details>

<details>
<summary>quickstart-ja.md</summary>

```diff
diff --git a/docs-ja/pages/quickstart-ja.md b/docs-ja/pages/quickstart-ja.md
index 426425a..4f9925e 100644
--- a/docs-ja/pages/quickstart-ja.md
+++ b/docs-ja/pages/quickstart-ja.md
@@ -490,8 +490,8 @@ export const InstallConfigurator = ({defaultSurface = 'terminal'}) => {
       {target === 'terminal' && <div className="cc-ic-below">
           {isWinInstaller && <span>
-              Requires{' '}
               <a href="https://git-scm.com/downloads/win" target="_blank" rel="noopener">
                 Git for Windows
-              </a>.
+              </a>{' '}
+              recommended. PowerShell is used if Git Bash is absent.
             </span>}
           {(pkg === 'brew' || pkg === 'winget') && <span>
@@ -680,5 +680,5 @@ To install Claude Code, use one of the following methods:
     If you see `The token '&&' is not a valid statement separator`, you're in PowerShell, not CMD. If you see `'irm' is not recognized as an internal or external command`, you're in CMD, not PowerShell. Your prompt shows `PS C:\` when you're in PowerShell and `C:\` without the `PS` when you're in CMD.
 
-    [Git for Windows](https://git-scm.com/downloads/win) is required on native Windows so Claude Code can use the Bash tool. WSL setups do not need Git for Windows.
+    [Git for Windows](https://git-scm.com/downloads/win) is recommended on native Windows so Claude Code can use the Bash tool. If Git for Windows is not installed, Claude Code uses PowerShell as the shell tool instead. WSL setups do not need Git for Windows.
 
     <Info>
```

</details>

<details>
<summary>setup-ja.md</summary>

```diff
diff --git a/docs-ja/pages/setup-ja.md b/docs-ja/pages/setup-ja.md
index d49e141..546dd06 100644
--- a/docs-ja/pages/setup-ja.md
+++ b/docs-ja/pages/setup-ja.md
@@ -60,5 +60,5 @@ To install Claude Code, use one of the following methods:
     If you see `The token '&&' is not a valid statement separator`, you're in PowerShell, not CMD. If you see `'irm' is not recognized as an internal or external command`, you're in CMD, not PowerShell. Your prompt shows `PS C:\` when you're in PowerShell and `C:\` without the `PS` when you're in CMD.
 
-    [Git for Windows](https://git-scm.com/downloads/win) is required on native Windows so Claude Code can use the Bash tool. WSL setups do not need Git for Windows.
+    [Git for Windows](https://git-scm.com/downloads/win) is recommended on native Windows so Claude Code can use the Bash tool. If Git for Windows is not installed, Claude Code uses PowerShell as the shell tool instead. WSL setups do not need Git for Windows.
 
     <Info>
@@ -104,9 +104,9 @@ claude
 Claude Code をネイティブに Windows で実行することも、WSL 内で実行することもできます。プロジェクトの場所と必要な機能に基づいて選択してください。
 
-| オプション         | 必須                                                      | [サンドボックス](/ja/sandboxing) | 使用時期                              |
-| ------------- | ------------------------------------------------------- | ------------------------- | --------------------------------- |
-| ネイティブ Windows | [Git for Windows](https://git-scm.com/downloads/win)が必須 | サポートされていません               | Windows ネイティブプロジェクトとツール           |
-| WSL 2         | WSL 2 有効                                                | サポートされています                | Linux ツールチェーンまたはサンドボックス化されたコマンド実行 |
-| WSL 1         | WSL 1 有効                                                | サポートされていません               | WSL 2 が利用できない場合                   |
+| オプション         | 必須                                                                           | [サンドボックス](/ja/sandboxing) | 使用時期                              |
+| ------------- | ---------------------------------------------------------------------------- | ------------------------- | --------------------------------- |
+| ネイティブ Windows | [Git for Windows](https://git-scm.com/downloads/win)推奨；不在の場合は PowerShell を使用 | サポートされていません               | Windows ネイティブプロジェクトとツール           |
+| WSL 2         | WSL 2 有効                                                                     | サポートされています                | Linux ツールチェーンまたはサンドボックス化されたコマンド実行 |
+| WSL 1         | WSL 1 有効                                                                     | サポートされていません               | WSL 2 が利用できない場合                   |
 
 **オプション 1: Git Bash を使用したネイティブ Windows**
@@ -126,5 +126,5 @@ PowerShell または CMD からインストールするかどうかは、実行
 ```
 
-Claude Code は Windows でネイティブに PowerShell を実行することもできます。PowerShell ツールは段階的にロールアウトされています。オプトインするには `CLAUDE_CODE_USE_POWERSHELL_TOOL=1` を設定するか、オプトアウトするには `0` を設定します。セットアップと制限については、[PowerShell ツール](/ja/tools-reference#powershell-tool)を参照してください。
```

</details>

<details>
<summary>skills-ja.md</summary>

```diff
diff --git a/docs-ja/pages/skills-ja.md b/docs-ja/pages/skills-ja.md
index bd1a731..989c286 100644
--- a/docs-ja/pages/skills-ja.md
+++ b/docs-ja/pages/skills-ja.md
@@ -41,5 +41,5 @@ Claude Code には、すべてのセッションで利用可能な一連のバ
 
   <Step title="SKILL.md を記述する">
-    すべてのスキルには `SKILL.md` ファイルが必要です。2 つの部分があります。YAML フロントマター（`---` マーカー間）は Claude にスキルをいつ使用するかを伝え、マークダウンコンテンツはスキルが呼び出されるときに Claude が従う指示です。`name` フィールドは `/slash-command` になり、`description` は Claude がスキルを自動的に読み込むかどうかを決定するのに役立ちます。
+    すべてのスキルには `SKILL.md` ファイルが必要です。2 つの部分があります。YAML フロントマター（`---` マーカー間）は Claude にスキルをいつ使用するかを伝え、マークダウンコンテンツはスキルが呼び出されるときに Claude が従う指示です。ディレクトリ名は `/slash-command` になり、`description` は Claude がスキルを自動的に読み込むかどうかを決定するのに役立ちます。
 
     `~/.claude/skills/explain-code/SKILL.md` を作成します：
@@ -47,5 +47,4 @@ Claude Code には、すべてのセッションで利用可能な一連のバ
     ```yaml theme={null}
     ---
-    name: explain-code
     description: Explains code with visual diagrams and analogies. Use when explaining how code works, teaching about a codebase, or when the user asks "how does this work?"
     ---
```

</details>

<details>
<summary>statusline-ja.md</summary>

```diff
diff --git a/docs-ja/pages/statusline-ja.md b/docs-ja/pages/statusline-ja.md
index 28c960a..df2cb56 100644
--- a/docs-ja/pages/statusline-ja.md
+++ b/docs-ja/pages/statusline-ja.md
@@ -917,5 +917,5 @@ Claude.ai サブスクリプションのレート制限使用状況をステー
 ### Windows 設定
 
-Windows では、Claude Code はステータスラインコマンドを Git Bash 経由で実行します。そのシェルから PowerShell を呼び出すことができます：
+Windows では、Claude Code はステータスラインコマンドを Git Bash 経由で実行します。Git Bash がインストールされている場合、または Git Bash がない場合は PowerShell を通じて実行します。PowerShell スクリプトをステータスラインとして実行するには、`powershell` 経由で呼び出します。これはどちらのシェルからでも機能します：
 
 <CodeGroup>
@@ -944,5 +944,5 @@ Windows では、Claude Code はステータスラインコマンドを Git Bash
 </CodeGroup>
 
-または Bash スクリプトを直接実行します：
+または、Git Bash がインストールされている場合は、Bash スクリプトを直接実行します：
 
 <CodeGroup>
```

</details>

<details>
<summary>tools-reference-ja.md</summary>

```diff
diff --git a/docs-ja/pages/tools-reference-ja.md b/docs-ja/pages/tools-reference-ja.md
index 462b419..4964c27 100644
--- a/docs-ja/pages/tools-reference-ja.md
+++ b/docs-ja/pages/tools-reference-ja.md
@@ -96,5 +96,5 @@ Monitor は [Bash と同じ権限ルール](/ja/permissions#tool-specific-permis
 ## PowerShell ツール
 
-PowerShell ツールを使用すると、Claude は PowerShell コマンドをネイティブに実行できます。Windows では、これは Git Bash を経由するのではなく、PowerShell でコマンドが実行されることを意味します。ツールは Windows で段階的にロールアウトされており、Linux、macOS、および WSL ではオプトインです。
+PowerShell ツールを使用すると、Claude は PowerShell コマンドをネイティブに実行できます。Windows では、これは Git Bash を経由するのではなく、PowerShell でコマンドが実行されることを意味します。Git Bash がない Windows では、ツールは自動的に有効になります。Git Bash がインストールされている Windows では、ツールは段階的にロールアウトされています。Linux、macOS、および WSL では、ツールはオプトインです。
 
 ### PowerShell ツールを有効にする
```

</details>

<details>
<summary>troubleshoot-install-ja.md</summary>

```diff
diff --git a/docs-ja/pages/troubleshoot-install-ja.md b/docs-ja/pages/troubleshoot-install-ja.md
index e316bda..15b50da 100644
--- a/docs-ja/pages/troubleshoot-install-ja.md
+++ b/docs-ja/pages/troubleshoot-install-ja.md
@@ -23,6 +23,7 @@
 | `irm is not recognized` または `&& is not valid`                                                | [シェルに適切なコマンドを使用する](#wrong-install-command-on-windows)                                             |
 | `'bash' is not recognized as the name of a cmdlet`                                           | [Windows インストーラーコマンドを使用する](#wrong-install-command-on-windows)                                     |
-| `Claude Code on Windows requires git-bash`                                                   | [Git Bash をインストールまたは設定する](#claude-code-on-windows-requires-git-bash)                              |
+| `Claude Code on Windows requires either Git for Windows (for bash) or PowerShell`            | [シェルをインストールする](#claude-code-on-windows-requires-either-git-for-windows-for-bash-or-powershell)    |
 | `Claude Code does not support 32-bit Windows`                                                | [Windows PowerShell を開く（x86 エントリではなく）](#claude-code-does-not-support-32-bit-windows)              |
+| `The process cannot access the file ... because it is being used by another process`         | [ダウンロードフォルダをクリアして再試行する](#the-process-cannot-access-the-file-during-windows-install)               |
 | `Error loading shared library`                                                               | [システムに対応したバイナリバリアント](#linux-musl-or-glibc-binary-mismatch)                                        |
 | `Illegal instruction`                                                                        | [アーキテクチャまたは CPU 命令セットの不一致](#illegal-instruction)                                                  |
@@ -112,4 +113,6 @@ curl -sI https://downloads.claude.ai/claude-code-releases/latest
     または、ターミナルを閉じて再度開いてください。
 
+    fish や Nushell などの他のシェルの場合は、シェル独自の設定構文を使用して `~/.local/bin` を PATH に追加してから、ターミナルを再起動してください。
+
     修正が機能したことを確認してください：
 
@@ -454,4 +457,15 @@ Invoke-Expression: Missing argument in parameter list.
   ```
 
+### Windows インストール中の `The process cannot access the file`
+
+PowerShell インストーラーが `Failed to download binary: The process cannot access the file ... because it is being used by another process` で失敗する場合、インストーラーは `%USERPROFILE%\.claude\downloads` に書き込むことができませんでした。これは通常、以前のインストール試行がまだ実行されているか、アンチウイルスソフトウェアがそのフォルダー内の部分的にダウンロードされたバイナリをスキャンしていることを意味します。
+
+インストーラーを実行している他の PowerShell ウィンドウを閉じ、アンチウイルススキャンがファイルを解放するのを待ってください。その後、ダウンロードフォルダーを削除してインストーラーを再度実行してください：
+
+```powershell theme={null}
```

</details>

*...以降省略*

</details>


<details>
<summary>2026-04-29</summary>

**変更ファイル:**

```
 docs-ja/pages/admin-setup-ja.md             |   8 +-
 docs-ja/pages/amazon-bedrock-ja.md          |   7 +-
 docs-ja/pages/authentication-ja.md          |  42 +-
 docs-ja/pages/changelog.md                  |  88 +++
 docs-ja/pages/cli-reference-ja.md           |   7 +-
 docs-ja/pages/commands-ja.md                | 170 ++---
 docs-ja/pages/common-workflows-ja.md        |  14 +-
 docs-ja/pages/data-usage-ja.md              |  14 +-
 docs-ja/pages/debug-your-config-ja.md       |  11 +-
 docs-ja/pages/env-vars-ja.md                |  17 +-
 docs-ja/pages/errors-ja.md                  |  19 +-
 docs-ja/pages/fullscreen-ja.md              |   6 +-
 docs-ja/pages/google-vertex-ai-ja.md        |   6 +-
 docs-ja/pages/hooks-guide-ja.md             |  12 +-
 docs-ja/pages/hooks-ja.md                   | 219 +++++--
 docs-ja/pages/interactive-mode-ja.md        |   2 +-
 docs-ja/pages/jetbrains-ja.md               |  75 ++-
 docs-ja/pages/legal-and-compliance-ja.md    |   8 +-
 docs-ja/pages/llm-gateway-ja.md             |  10 +
 docs-ja/pages/mcp-ja.md                     |  24 +-
 docs-ja/pages/monitoring-usage-ja.md        |  48 +-
 docs-ja/pages/overview-ja.md                | 678 ++++++++++++++++++-
 docs-ja/pages/plugin-dependencies-ja.md     |  18 +
 docs-ja/pages/plugin-marketplaces-ja.md     |  15 +-
 docs-ja/pages/plugins-ja.md                 |   4 +-
 docs-ja/pages/plugins-reference-ja.md       |  79 ++-
 docs-ja/pages/quickstart-ja.md              |   4 +-
 docs-ja/pages/sandboxing-ja.md              |   4 +
 docs-ja/pages/security-ja.md                |  20 +-
 docs-ja/pages/server-managed-settings-ja.md |  18 +-
 docs-ja/pages/settings-ja.md                |   2 +-
 docs-ja/pages/setup-ja.md                   |  24 +-
 docs-ja/pages/skills-ja.md                  |   1 +
 docs-ja/pages/statusline-ja.md              |   2 +
 docs-ja/pages/sub-agents-ja.md              |  10 +-
 docs-ja/pages/terminal-config-ja.md         |   2 +
 docs-ja/pages/tools-reference-ja.md         |   1 -
 docs-ja/pages/troubleshooting-ja.md         | 972 ++--------------------------
 docs-ja/pages/ultrareview-ja.md             |  25 +-
 docs-ja/pages/voice-dictation-en.md         | 189 ------
 40 files changed, 1427 insertions(+), 1448 deletions(-)
```

**新規追加:**


**削除:**


<!-- UPDATE_LOG_END -->
