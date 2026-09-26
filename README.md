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
<summary>2026-09-26</summary>

**変更ファイル:**

```
 docs-ja/pages/admin-setup-ja.md                |  40 ++--
 docs-ja/pages/agent-teams-ja.md                |   2 +-
 docs-ja/pages/agents-ja.md                     |   2 +-
 docs-ja/pages/amazon-bedrock-ja.md             |   9 +-
 docs-ja/pages/best-practices-ja.md             |  14 +-
 docs-ja/pages/changelog.md                     | 100 ++++++++-
 docs-ja/pages/channels-ja.md                   |  26 +--
 docs-ja/pages/channels-reference-ja.md         |   8 +-
 docs-ja/pages/checkpointing-ja.md              |   2 +-
 docs-ja/pages/claude-apps-gateway-deploy-ja.md |   2 +-
 docs-ja/pages/claude-code-on-the-web-ja.md     |  14 +-
 docs-ja/pages/claude-directory-ja.md           |  52 ++---
 docs-ja/pages/claude-platform-on-aws-ja.md     |   2 +-
 docs-ja/pages/claude-projects-ja.md            | 208 +++++++++---------
 docs-ja/pages/claude-security-ja.md            |  20 +-
 docs-ja/pages/claude-tag-ja.md                 |  12 +-
 docs-ja/pages/cli-reference-ja.md              |  12 +-
 docs-ja/pages/cloud-environments-ja.md         |   4 +-
 docs-ja/pages/commands-ja.md                   |  14 +-
 docs-ja/pages/common-workflows-ja.md           |   2 +-
 docs-ja/pages/costs-ja.md                      |   2 +-
 docs-ja/pages/debug-your-config-ja.md          |   2 +-
 docs-ja/pages/desktop-ja.md                    |  12 +-
 docs-ja/pages/env-vars-ja.md                   |   2 +-
 docs-ja/pages/errors-ja.md                     |  46 ++--
 docs-ja/pages/feature-availability-ja.md       |   2 +-
 docs-ja/pages/features-overview-ja.md          |  34 +--
 docs-ja/pages/fullscreen-ja.md                 |   3 +-
 docs-ja/pages/github-actions-ja.md             |   4 +-
 docs-ja/pages/github-enterprise-server-ja.md   |  26 +--
 docs-ja/pages/glossary-ja.md                   |   6 +-
 docs-ja/pages/headless-ja.md                   |   2 +-
 docs-ja/pages/hooks-guide-ja.md                |  22 +-
 docs-ja/pages/how-claude-code-works-ja.md      |  14 +-
 docs-ja/pages/interactive-mode-ja.md           |  15 +-
 docs-ja/pages/keybindings-ja.md                |  52 +++--
 docs-ja/pages/large-codebases-ja.md            |  10 +-
 docs-ja/pages/managed-mcp-ja.md                |   2 +-
 docs-ja/pages/managed-settings-ja.md           | 228 ++++++++++----------
 docs-ja/pages/mcp-ja.md                        |  34 +--
 docs-ja/pages/monitoring-usage-ja.md           |  12 +-
 docs-ja/pages/network-config-ja.md             |   2 +-
 docs-ja/pages/output-styles-ja.md              |   4 +-
 docs-ja/pages/permission-modes-ja.md           |  17 +-
 docs-ja/pages/permissions-ja.md                |  22 +-
 docs-ja/pages/platforms-ja.md                  |  18 +-
 docs-ja/pages/plugin-evals-ja.md               |  91 +++++---
 docs-ja/pages/prompt-caching-ja.md             |  16 +-
 docs-ja/pages/prompt-library-ja.md             |   7 +-
 docs-ja/pages/remote-control-ja.md             |  12 +-
 docs-ja/pages/sandboxing-ja.md                 | 283 +++++++++++++------------
 docs-ja/pages/security-guidance-ja.md          |  10 +-
 docs-ja/pages/server-managed-settings-ja.md    |   4 +-
 docs-ja/pages/sessions-ja.md                   |   2 +-
 docs-ja/pages/settings-example-ja.md           |  16 +-
 docs-ja/pages/settings-ja.md                   | 128 +++++------
 docs-ja/pages/settings-reference-ja.md         | 126 ++++++-----
 docs-ja/pages/skills-ja.md                     |  44 ++--
 docs-ja/pages/statusline-ja.md                 |   2 +-
 docs-ja/pages/sub-agents-ja.md                 |  40 ++--
 docs-ja/pages/terminal-config-ja.md            |   2 +-
 docs-ja/pages/tools-reference-ja.md            |  14 +-
 docs-ja/pages/vs-code-ja.md                    |   4 +-
 docs-ja/pages/workflows-ja.md                  |   2 +-
 docs-ja/pages/zero-data-retention-ja.md        |   2 +-
 65 files changed, 1073 insertions(+), 870 deletions(-)
```

<details>
<summary>admin-setup-ja.md</summary>

```diff
diff --git a/docs-ja/pages/admin-setup-ja.md b/docs-ja/pages/admin-setup-ja.md
index 86f1c19..8b44218 100644
--- a/docs-ja/pages/admin-setup-ja.md
+++ b/docs-ja/pages/admin-setup-ja.md
@@ -94,24 +94,24 @@ WSL 2 ユーティリティ VM 内のプロセスは、Windows 側のエンド
 マネージド設定は、ツール、サンドボックス実行、MCP サーバーとプラグインソース、および実行するフック を制限できます。各行は、それを駆動する設定キーを持つ制御サーフェスです。
 
-| 制御                                                                           | 機能                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           | キー設定                                                                                                                                |
-| :--------------------------------------------------------------------------- | :----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :---------------------------------------------------------------------------------------------------------------------------------- |
-| [権限ルール](/docs/ja/permissions)                                                     | 特定のツールとコマンドを許可、確認、または拒否する                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | `permissions.allow`、`permissions.deny`                                                                                              |
-| [権限ロックダウン](/docs/ja/permissions#managed-only-settings)                            | マネージド設定を[権限ルールの唯一の設定ソース](/docs/ja/settings-reference#allowmanagedpermissionrulesonly)にします。`--dangerously-skip-permissions` を無効にする                                                                                                                                                                                                                                                                                                                                                                                 | `allowManagedPermissionRulesOnly`、`permissions.disableBypassPermissionsMode`                                                        |
-| [開始権限モード](/docs/ja/permission-modes#which-mode-a-session-starts-in)               | 組み込みの開始権限モードの代わりに、開発者のターミナルセッションが開始する権限モードを選択するか、自動モードを削除します。VS Code 拡張機能は、Pro、Max、Team プランでのみ設定した `defaultMode` を読み取ります。[権限モードの切り替え](/docs/ja/permission-modes#switch-permission-modes)は、拡張機能が読み取る内容を一覧表示します                                                                                                                                                                                                                                                                                                     | `permissions.defaultMode`、`permissions.disableAutoMode`                                                                             |
-| [サンドボックス](/docs/ja/sandboxing)                                                    | ドメイン許可リスト付きの OS レベルのファイルシステムとネットワーク分離                                                                                                                                                                                                                                                                                                                                                                                                                                                                        | `sandbox.enabled`、`sandbox.network.allowedDomains`                                                                                  |
-| [マネージドポリシー CLAUDE.md](/docs/ja/memory#deploy-organization-wide-claude-md)         | すべてのセッションで読み込まれる組織全体の指示。除外できません                                                                                                                                                                                                                                                                                                                                                                                                                                                                              | マネージドポリシーパスのファイル                                                                                                                    |
-| [MCP サーバー制御](/docs/ja/managed-mcp)                                                | ユーザーが追加または接続できる MCP サーバーを制限し、固定セットをデプロイするか、リモートサーバーをすべてのユーザーに提供します                                                                                                                                                                                                                                                                                                                                                                                                                                           | `allowedMcpServers`、`deniedMcpServers`、`allowManagedMcpServersOnly`、`managedMcpServers`、またはデプロイされた `managed-mcp.json` ファイル          |
-| [プラグインマーケットプレイス制御](/docs/ja/plugin-marketplaces#managed-marketplace-restrictions) | ユーザーが追加およびインストールできるマーケットプレイスソースを制限し、単一実行のためにプラグイン、エージェント、MCP サーバーをサイドロードする CLI フラグを拒否し、[`command` プラグインソース](/docs/ja/plugin-marketplaces#command-sources)をブロックし、どのマーケットプレイスのプラグインを提案できるかをホワイトリストに登録します                                                                                                                                                                                                                                                                                                            | `strictKnownMarketplaces`、`blockedMarketplaces`、`disableSideloadFlags`、`disableCommandPluginSources`、`pluginSuggestionMarketplaces` |
-| [カスタマイズロックダウン](/docs/ja/settings-reference#strictpluginonlycustomization)         | スキル、エージェント、フック、MCP サーバーをユーザーおよびプロジェクトソースからブロックし、プラグインまたはマネージド設定からのみ取得できるようにします。スキルをロックすると、開発者が claude.ai で有効にした[スキル](/docs/ja/skills#where-synced-skills-load)の同期も停止します                                                                                                                                                                                                                                                                                                                                           | `strictPluginOnlyCustomization`                                                                                                     |
-| [claude.ai 同期を無効にする](/docs/ja/settings-reference#syncclaudeaiskills)              | Claude Code が開発者が claude.ai で有効にした[スキル](/docs/ja/skills#how-synced-skills-behave)と[プラグイン](/docs/ja/plugins-reference#synced-plugins)を読み込むのを停止します。組織の claude.ai でスキルをオフにすると、Claude Code は両方の同期を停止します。v2.1.273 以降では、既に同期したものも削除します。スキルをオフにせずにどちらか一方を停止するには、マネージド設定でそのキーを `false` に設定します                                                                                                                                                                                                                                  | `syncClaudeAiSkills`、`syncClaudeAiPlugins`                                                                                          |
-| [フック制限](/docs/ja/settings-reference#allowmanagedhooksonly)                        | 実行するフックを制限し、HTTP フック URL を制限します。[`allowManagedHooksOnly` で実行される内容](/docs/ja/settings-reference#what-runs-under-allowmanagedhooksonly)の完全な効果リストを参照してください                                                                                                                                                                                                                                                                                                                                                           | `allowManagedHooksOnly`、`allowedHttpHookUrls`                                                                                       |
-| [ログイン強制](/docs/ja/settings-reference#forceloginmethod)                            | ログインを特定の方法または Anthropic 組織に制限します。メソッド制限は VS Code 拡張機能、Agent SDK、`claude setup-token`、`/install-github-app` 全体に適用され、ターミナルのインタラクティブログイン画面（`/login` または初回オンボーディングで到達）はメソッドを事前選択しますが強制しません。Claude Code は、ターミナル、VS Code 拡張機能、Agent SDK での claude.ai アカウントログインの組織を検証し、Claude Console ログインまたは[ゲートウェイ](/docs/ja/claude-apps-gateway)サインインではチェックしません。v2.1.212 より前は、ターミナルログインのみが両方のキーを適用していました。設定すると、`ANTHROPIC_API_KEY`、`ANTHROPIC_AUTH_TOKEN`、または `apiKeyHelper` によって認証されたセッションはスタートアップでブロックされます。クラウドプロバイダーセッションは影響を受けません | `forceLoginMethod`、`forceLoginOrgUUID`                                                                                              |
-| [エージェントビューを無効にする](/docs/ja/agent-view#how-background-sessions-are-hosted)         | `claude agents`、`--bg`、`/background`、およびオンデマンドスーパーバイザーをオフにします                                                                                                                                                                                                                                                                                                                                                                                                                                                | `disableAgentView`                                                                                                                  |
-| [企業ランチャーを構成する](/docs/ja/corporate-launcher)                                       | [バックグラウンドエージェントスーパーバイザー](/docs/ja/agent-view#how-background-sessions-are-hosted)、そのワーカー、および[その他のカバーされたバックグラウンドプロセス](/docs/ja/corporate-launcher#what-the-launcher-covers)に、エージェントビューをオフにする代わりに、必須の企業ランチャーをプレフィックスします                                                                                                                                                                                                                                                                                                   | `processWrapper`                                                                                                                    |
-| [モデル制限](/docs/ja/model-config#restrict-model-selection)                           | `availableModels` はピッカーに表示されるモデルをフィルタリングします。`enforceAvailableModels` を追加すると、自動選択されたデフォルトモデルも制限されます。このセッティングが CLI、ウェブ、IDE にどのように到達するかについては、[サーフェスカバレッジ](/docs/ja/model-config#surface-coverage)を参照してください                                                                                                                                                                                                                                                                                                           | `availableModels`、`enforceAvailableModels`                                                                                          |
-| [エフォートキャップ](/docs/ja/settings-reference#maxeffortlevel)                           | すべてのモデルまたはモデルごとに、すべてのプロバイダーで[エフォートレベル](/docs/ja/model-config#adjust-effort-level)をキャップします                                                                                                                                                                                                                                                                                                                                                                                                                         | `maxEffortLevel`                                                                                                                    |
-| [バージョンフロア](/docs/ja/settings-reference#minimumversion)                            | 自動更新が組織全体の最小値以下をインストールするのを防ぎます                                                                                                                                                                                                                                                                                                                                                                                                                                                                               | `minimumVersion`                                                                                                                    |
-| [必須バージョン範囲](/docs/ja/settings-reference#requiredminimumversion)                   | 実行中のバージョンが組織承認範囲外の場合、まったく起動を拒否します。ダウングレードのみをブロックする `minimumVersion` より強力です                                                                                                                                                                                                                                                                                                                                                                                                                                   | `requiredMinimumVersion`、`requiredMaximumVersion`                                                                                   |
-| [テレメトリオプトアウト](/docs/ja/data-usage#telemetry-services)                             | すべてのデバイスで Anthropic バウンドの使用メトリクス、エラーレポート、およびサーベイをオフにします                                                                                                                                                                                                                                                                                                                                                                                                                                                      | `env` に `CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC` を `1` に設定します。リンクされたセクションはカテゴリごとの変数を一覧表示します                                       |
+| 制御                                                                   | 機能                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           | キー設定                                                                                                                                |
+| :------------------------------------------------------------------- | :----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :---------------------------------------------------------------------------------------------------------------------------------- |
+| [権限ルール](/docs/ja/permissions)                                             | 特定のツールとコマンドを許可、確認、または拒否する                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | `permissions.allow`、`permissions.deny`                                                                                              |
```

</details>

<details>
<summary>agent-teams-ja.md</summary>

```diff
diff --git a/docs-ja/pages/agent-teams-ja.md b/docs-ja/pages/agent-teams-ja.md
index 7974b36..8aa560b 100644
--- a/docs-ja/pages/agent-teams-ja.md
+++ b/docs-ja/pages/agent-teams-ja.md
@@ -119,5 +119,5 @@ v2.1.199 以降、アイドル状態のチームメンバーの行は、他の
 デフォルトは `"in-process"` です。`"auto"` を設定して、既に tmux セッション内で実行している場合または使用しているターミナルが iTerm2 で `it2` CLI がインストールされている場合は分割ペインを有効にし、それ以外の場合は in-process にフォールバックします。`"tmux"` 設定は分割ペインモードを有効にし、ターミナルに基づいて tmux または iTerm2 を使用するかどうかを自動検出します。
 
-v2.1.186 以降、`"iterm2"` を設定して iTerm2 ネイティブ分割ペインを明示的に使用してください。このモードは [`it2` CLI](https://github.com/mkusaka/it2) が必要で、`it2` が見つからない場合はインストールコマンド付きでエラーを表示します。`it2` をインストールするか tmux に切り替えるオプションを提供するセットアッププロンプトは、ターミナルが iTerm2 で tmux がフォールバックとして利用可能な場合、`"auto"` または `"tmux"` の下に表示されます。
+`"iterm2"` を設定して iTerm2 ネイティブ分割ペインを明示的に使用してください。このモードは [`it2` CLI](https://github.com/mkusaka/it2) が必要で、`it2` が見つからない場合はインストールコマンド付きでエラーを表示します。`it2` をインストールするか tmux に切り替えるオプションを提供するセットアッププロンプトは、ターミナルが iTerm2 で tmux がフォールバックとして利用可能な場合、`"auto"` または `"tmux"` の下に表示されます。
 
 デフォルトをオーバーライドするには、`~/.claude/settings.json` で [`teammateMode`](/docs/ja/settings-reference#teammatemode) を設定してください。
```

</details>

<details>
<summary>agents-ja.md</summary>

```diff
diff --git a/docs-ja/pages/agents-ja.md b/docs-ja/pages/agents-ja.md
index 6faf8f2..688cc7a 100644
--- a/docs-ja/pages/agents-ja.md
+++ b/docs-ja/pages/agents-ja.md
@@ -23,5 +23,5 @@ Claude Code には、複数のタスクを同時に処理する 5 つの方法
 * [ワークツリー](/docs/ja/worktrees) は各セッションに個別の git チェックアウトを提供するため、並列セッションが同じファイルを編集することはありません。自分で実行するセッションに使用します。エージェントビューからディスパッチされたセッションは、[ファイルを編集する前に独自のワークツリーに移動](/docs/ja/agent-view#how-file-edits-are-isolated) し、スポーンするサブエージェントも各々独自のワークツリーを取得できます。
 * [クロスセッションメッセージング](/docs/ja/cross-session-messaging) により、Claude はこのマシン上、別のマシン上、または [クラウド](/docs/ja/claude-code-on-the-web) 上の他の Claude Code セッションをリストして、メッセージを送信できます。自分で実行するセッションは、検出結果とステータスを相互に渡すことができます。
-* [`/batch`](/docs/ja/commands) は、1 つの大きな変更を 5 ～ 30 個のワークツリー分離サブエージェントに分割し、各エージェントがプルリクエストを開く [skill](/docs/ja/skills) です。これはサブエージェントとワークツリーのパッケージ化された使用法であり、別の調整スタイルではありません。
+* [`/batch`](/docs/ja/commands) は、1 つの大きな変更を 5 ～ 30 個のワークツリー分離サブエージェントに分割する [skill](/docs/ja/skills) です。これはサブエージェントとワークツリーのパッケージ化された使用法であり、別の調整スタイルではありません。
 
 他にも Claude を各ステップで駆動することなく実行する機能がいくつかありますが、これらはエージェント間で作業を分割することとは異なる問題を解決します。
```

</details>

<details>
<summary>amazon-bedrock-ja.md</summary>

```diff
diff --git a/docs-ja/pages/amazon-bedrock-ja.md b/docs-ja/pages/amazon-bedrock-ja.md
index ec20931..e4551ab 100644
--- a/docs-ja/pages/amazon-bedrock-ja.md
+++ b/docs-ja/pages/amazon-bedrock-ja.md
@@ -520,5 +520,7 @@ Claude Code は、各リクエストで `X-Amzn-Bedrock-Service-Tier` ヘッダ
 </h2>
 
-Mantle は、Bedrock Invoke API ではなく、ネイティブ Anthropic API シェイプを通じて Claude モデルを提供する Amazon Bedrock エンドポイントです。同じ [AWS 認証情報](#2-configure-aws-credentials)、[IAM 権限](#iam-configuration)、および [`awsAuthRefresh` 設定](#advanced-credential-configuration) を使用します。
+Mantle は、Bedrock Invoke API ではなく、ネイティブ Anthropic API シェイプを通じて Claude モデルを提供する Amazon Bedrock エンドポイントです。同じ [AWS 認証情報](#2-configure-aws-credentials) と [`awsAuthRefresh` 設定](#advanced-credential-configuration) を使用します。
+
+Mantle は `bedrock-mantle:` プレフィックスの下に独自の IAM アクションを持つため、[IAM 設定](#iam-configuration) の `bedrock:` アクションはこれをカバーしていません。推論用に `bedrock-mantle:CreateInference` と、トークンカウント用に `bedrock-mantle:CountTokens` を IAM アイデンティティに付与します。AWS ドキュメントの [推論リクエストの実行](https://docs.aws.amazon.com/bedrock/latest/userguide/inference.html) と [トークンのカウント](https://docs.aws.amazon.com/bedrock/latest/userguide/count-tokens.html)、および [サービス認可リファレンス](https://docs.aws.amazon.com/service-authorization/latest/reference/list_amazonbedrockpoweredbyawsmantle.html) を参照して、すべての Mantle アクションを確認してください。
 
 <h3 id="enable-mantle">
@@ -672,5 +674,8 @@ v2.1.196 以降に更新してください。
 `CLAUDE_CODE_USE_MANTLE` を設定した後、`/status` が `Amazon Bedrock (Mantle)` を表示しない場合、変数がプロセスに到達していません。Claude Code を起動したシェルでエクスポートされているか、[settings file](/docs/ja/settings) の `env` ブロックで設定されていることを確認してください。
 
-有効な認証情報を持つ Mantle エンドポイントからの `403` は、AWS アカウントがリクエストしたモデルへのアクセスを許可されていないことを意味します。AWS アカウントチームに連絡してアクセスをリクエストしてください。
+Mantle エンドポイントからの `403` が何を意味するかは、エラーが IAM アクションを名前付けるかどうかによって異なります：
+
+* エラーが `bedrock-mantle:` アクションを名前付ける場合は、IAM アイデンティティにそのアクションを付与してください。
+* エラーがアクションを名前付けず、認証情報が有効な場合は、AWS アカウントがリクエストしたモデルへのアクセスを許可されていません。AWS アカウントチームに連絡してアクセスをリクエストしてください。
 
 モデル ID を名前付ける `400` は、そのモデルが Mantle で提供されていないことを意味します。Mantle は標準 Amazon Bedrock カタログとは別の独自のモデルラインアップを持っているため、`us.anthropic.claude-sonnet-4-6` などの推論プロファイル ID は機能しません。Mantle 形式の ID を使用するか、[両方のエンドポイントを有効にして](#run-mantle-alongside-the-invoke-api)、Claude Code が各リクエストをモデルが利用可能なエンドポイントにルーティングするようにしてください。
```

</details>

<details>
<summary>best-practices-ja.md</summary>

```diff
diff --git a/docs-ja/pages/best-practices-ja.md b/docs-ja/pages/best-practices-ja.md
index c4d77a4..b173ddb 100644
--- a/docs-ja/pages/best-practices-ja.md
+++ b/docs-ja/pages/best-practices-ja.md
@@ -203,5 +203,5 @@ CLAUDE.md ファイルは `@path/to/import` 構文を使用して追加ファイ
 
 <h3 id="configure-permissions">
-  パーミッションを設定する
+  権限モードを設定する
 </h3>
 
@@ -210,12 +210,12 @@ CLAUDE.md ファイルは `@path/to/import` 構文を使用して追加ファイ
 </Tip>
 
-Pro、Max、Team プランでは、auto mode は対話型ターミナルと VS Code セッションの[組み込みの開始パーミッションモード](/docs/ja/permission-modes#eliminate-prompts-with-auto-mode)です。別の分類器モデルがほとんどのアクションをレビューし、スコープエスカレーション、未知のインフラストラクチャ、敵対的なコンテンツ駆動のアクションなど、リスクがあるように見えるものだけをブロックします。
+Pro、Max、Team プランでは、auto mode は対話型ターミナルと VS Code セッションの[組み込みの開始権限モード](/docs/ja/permission-modes#eliminate-prompts-with-auto-mode)です。別の分類器モデルがほとんどのアクションをレビューし、スコープエスカレーション、未知のインフラストラクチャ、敵対的なコンテンツ駆動のアクションなど、リスクがあるように見えるものだけをブロックします。
 
-Manual モード（他のプランの組み込みの開始パーミッションモード）では、Claude Code はシステムを変更する可能性のあるアクション（ファイル書き込み、Bash コマンド、MCP ツール）の前に尋ねます。これは安全ですが、面倒です。10 回目の承認後、あなたはクリックしているだけで、本当にレビューしていません。これらの中断を減らす 2 つのツールがあり、Manual モードで適用され、auto mode でも同様に適用されます。
+Manual モード（他のプランの組み込みの開始権限モード）では、Claude Code はシステムを変更する可能性のあるアクション（ファイル書き込み、Bash コマンド、MCP ツール）の前に尋ねます。これは安全ですが、面倒です。10 回目の承認後、あなたはクリックしているだけで、本当にレビューしていません。これらの中断を減らす 2 つのツールがあり、Manual モードで適用され、auto mode でも同様に適用されます。
 
-* **パーミッションホワイトリスト**：`npm run lint` や `git commit` など、安全であることがわかっているツールを許可します
+* **権限ホワイトリスト**：`npm run lint` や `git commit` など、安全であることがわかっているツールを許可します
 * **サンドボックス**：OS レベルの分離を有効にして、ファイルシステムとネットワークアクセスを制限し、Claude が定義された境界内でより自由に動作できるようにします
 
-[パーミッションモード](/docs/ja/permission-modes)、[パーミッションルール](/docs/ja/permissions)、[サンドボックス](/docs/ja/sandboxing)の詳細をお読みください。
+[権限モード](/docs/ja/permission-modes)、[権限ルール](/docs/ja/permissions)、[サンドボックス](/docs/ja/sandboxing)の詳細をお読みください。
 
 <h3 id="use-cli-tools">
@@ -335,5 +335,5 @@ Claude に明示的にサブエージェントを使用するよう指示しま
 </Tip>
```

</details>

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index 92e3505..b6c326f 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,101 @@
 # Changelog
 
+## 2.1.283
+
+- Added `x-claude-code-prompt-id` to the gateway hint headers so LLM gateways can group the requests that serve one user prompt; opt in with `CLAUDE_CODE_GATEWAY_HINT_HEADERS=1`
+- Added `availableModelsMatch` managed setting: with `"exact"`, an `availableModels` entry allows only the model version it names, so new releases stay blocked until listed
+- Added `deniedModels` managed setting to block specific models, even when `availableModels` allows them
+- Added MCP tool, WebFetch and WebSearch outputs to the `tool.output` OpenTelemetry span event when `OTEL_LOG_TOOL_CONTENT=1`
+- Added `/doctor prompt-audit` (also `/checkup prompt-audit`) to audit your CLAUDE.md files, skills, agents and commands for prompting patterns written for older models
+- Added click-to-expand for truncated messages from your other sessions in fullscreen mode
+- Added `path` to `--plugin-dir` load-failure entries in the stream-json `system/init` `plugin_errors`, naming the directory that did not load
+- Added an opt-in `load_test_mode` block to the Claude apps gateway config: requests are built and signed but not sent upstream, and clients get a canned reply, so a deployment can be load tested
+- Added a `mantle` upstream provider to the Claude apps gateway for Amazon Bedrock's Mantle endpoint
+- Fixed SDK sessions losing a deferred tool call or finished tool result when a turn ended early, a held approval prompt after a worker restart, and a non-streaming fallback's `result.usage`
+- Fixed MCP progress notifications being discarded once a long-running tool call moved to the background; the background task now shows the latest progress
+- Fixed stdio MCP servers being left running when the session ended while they were still starting
+- Fixed a brief HTTP 404 from a stateless remote MCP server (for example a proxy mid-redeploy) leaving that server unusable for the rest of the session while still shown as connected
+- Fixed MCP sign-in for a server with no valid URL failing with an opaque SDK error; `/mcp` no longer offers Authenticate for such servers
+- Fixed the weekly Fable limit not appearing in `/usage` and the VS Code usage meters when telemetry is disabled
+- Fixed `/model` accepting Sonnet 4.6 or Sonnet 5 with `[1m]` when the id carried a date or `-v1:0` suffix, in the cases where the plain id was refused
+- Fixed `/model` picker showing a hardcoded Haiku version and price when `ANTHROPIC_DEFAULT_HAIKU_MODEL` pins a different model
+- Fixed dynamic workflows started during a model fallback running every agent on the fallback model instead of retrying the configured model
+- Fixed `DISABLE_PROMPT_CACHING_HAIKU` having no effect when Haiku is the session's main model
+- Fixed `claude plugin validate` saying Claude Code accepts a plugin or marketplace name it cannot install; such names in `marketplace.json` now fail validation
+- Fixed `claude plugin validate` passing plugins whose `outputStyles`, `themes`, `monitors`, or `lspServers` paths are missing or point outside the plugin directory
```

</details>

<details>
<summary>channels-ja.md</summary>

```diff
diff --git a/docs-ja/pages/channels-ja.md b/docs-ja/pages/channels-ja.md
index 6defd50..426efb3 100644
--- a/docs-ja/pages/channels-ja.md
+++ b/docs-ja/pages/channels-ja.md
@@ -46,7 +46,7 @@ Team、Enterprise、または Console 組織を管理している場合は、[
 
         * `Marketplace "claude-plugins-official" not found`：`/plugin marketplace add anthropics/claude-plugins-official` でマーケットプレイスを追加してから、インストールを再試行してください。
-        * プラグインが[マーケットプレイスで見つかりません](/docs/ja/discover-plugins#install-plugins)：プラグイン名を確認してください。
+        * プラグインが[マーケットプレイスで見つかりません](/docs/ja/plugins/install#install-a-plugin)：プラグイン名を確認してください。
 
-        インストールがインストールスコープを求めるとき、ユーザースコープオプションを選択して、プラグインがすべてのプロジェクト全体で利用可能になるようにしてください。インストール概要を確認してください。`Run /reload-plugins to activate.` と報告されている場合は、[プラグイン変更を再起動なしで適用する](/docs/ja/discover-plugins#apply-plugin-changes-without-restarting)を参照して、プラグインの設定コマンドを利用可能にしてください。
+        インストールがインストールスコープを求めるとき、ユーザースコープオプションを選択して、プラグインがすべてのプロジェクト全体で利用可能になるようにしてください。インストール概要を確認してください。`Run /reload-plugins to activate.` と報告されている場合は、[プラグイン変更を再起動なしで適用する](/docs/ja/plugins/cli-reference#reload-plugins)を参照して、プラグインの設定コマンドを利用可能にしてください。
       </Step>
 
@@ -124,7 +124,7 @@ Team、Enterprise、または Console 組織を管理している場合は、[
 
         * `Marketplace "claude-plugins-official" not found`：`/plugin marketplace add anthropics/claude-plugins-official` でマーケットプレイスを追加してから、インストールを再試行してください。
-        * プラグインが[マーケットプレイスで見つかりません](/docs/ja/discover-plugins#install-plugins)：プラグイン名を確認してください。
+        * プラグインが[マーケットプレイスで見つかりません](/docs/ja/plugins/install#install-a-plugin)：プラグイン名を確認してください。
 
-        インストールがインストールスコープを求めるとき、ユーザースコープオプションを選択して、プラグインがすべてのプロジェクト全体で利用可能になるようにしてください。インストール概要を確認してください。`Run /reload-plugins to activate.` と報告されている場合は、[プラグイン変更を再起動なしで適用する](/docs/ja/discover-plugins#apply-plugin-changes-without-restarting)を参照して、プラグインの設定コマンドを利用可能にしてください。
+        インストールがインストールスコープを求めるとき、ユーザースコープオプションを選択して、プラグインがすべてのプロジェクト全体で利用可能になるようにしてください。インストール概要を確認してください。`Run /reload-plugins to activate.` と報告されている場合は、[プラグイン変更を再起動なしで適用する](/docs/ja/plugins/cli-reference#reload-plugins)を参照して、プラグインの設定コマンドを利用可能にしてください。
       </Step>
 
@@ -189,7 +189,9 @@ Team、Enterprise、または Console 組織を管理している場合は、[
 
         * `Marketplace "claude-plugins-official" not found`：`/plugin marketplace add anthropics/claude-plugins-official` でマーケットプレイスを追加してから、インストールを再試行してください。
-        * プラグインが[マーケットプレイスで見つかりません](/docs/ja/discover-plugins#install-plugins)：プラグイン名を確認してください。
+        * プラグインが[マーケットプレイスで見つかりません](/docs/ja/plugins/install#install-a-plugin)：プラグイン名を確認してください。
 
```

</details>

*...以降省略*

</details>


<details>
<summary>2026-09-25</summary>

**変更ファイル:**

```
 docs-ja/pages/changelog.md                  |  89 +++++++++++
 docs-ja/pages/claude-apps-gateway-ja.md     |   4 +-
 docs-ja/pages/costs-ja.md                   |   2 +
 docs-ja/pages/env-vars-ja.md                |   6 +-
 docs-ja/pages/errors-ja.md                  | 223 ++++++++++++++++++++++------
 docs-ja/pages/interactive-mode-ja.md        |   2 +-
 docs-ja/pages/managed-settings-ja.md        |   2 +-
 docs-ja/pages/memory-ja.md                  |  12 +-
 docs-ja/pages/plugin-evals-ja.md            |  28 ++--
 docs-ja/pages/server-managed-settings-ja.md |   2 +-
 docs-ja/pages/settings-reference-ja.md      |   4 +
 11 files changed, 304 insertions(+), 70 deletions(-)
```

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index 288b140..92e3505 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,93 @@
 # Changelog
 
+## 2.1.282
+
+- Added a `maxProseWidth` setting that caps the width of Claude's prose in wide terminals while tables and code blocks keep the full width
+- Added a startup notice, and `/status` and `claude doctor` entries, listing telemetry variables in a project's settings files that were ignored or that turned telemetry off
+- Added the `allowClaudeInChromeWithManagedMcp` managed setting to let `claude --chrome` run alongside an exclusive `managed-mcp.json`; the error shown when Chrome is blocked now names it
+- Added `store.readiness_grace_seconds` to the Claude apps gateway so `/readyz` can stay ready through a short Postgres outage such as a database failover
+- Added a scrollbar to the `/feedback` drafts list in fullscreen mode; it appears while the mouse is over the list
+- Fixed every request failing with a 400 error in conversations whose history holds web search results the API cannot decrypt (for example, from a turn answered through a third-party gateway)
+- Fixed more cases of continued or resumed sessions (`--continue`, `--resume`) re-sending earlier messages in a changed form, which could make the API drop Claude's earlier reasoning
+- Fixed earlier extended thinking being dropped when `/model`, `/rename`, `/artifacts` or another immediate slash command was used while Claude was working
+- Fixed continued or resumed conversations losing earlier extended thinking when relaunched with a `--tools` list that leaves out a built-in tool offered earlier in the conversation
+- Fixed sessions failing on every turn with an "Invalid `data` in `redacted_thinking` block" API error; Claude Code now drops the conversation's thinking blocks and retries once
+- Fixed compaction failing when the summarization request is refused; it now retries on a fallback model
+- Fixed a failed turn ("Effort 'xhigh' isn't available with thinking turned off") after a safety-related model switch in sessions with thinking off and effort above high
+- Fixed an unanswered Fable usage-credits prompt switching models in SDK-hosted sessions such as Claude Desktop; the turn now ends instead, and Remote Control clients now see the model-switch notice
+- Fixed `/model` with a full Fable model id stopping at an API error instead of opening the usage-credits prompt when the plan needs usage credits that aren't turned on yet
+- Fixed requests failing for up to a minute with an "another Claude Code process is refreshing it" login error after that other process was closed or killed mid-refresh
+- Fixed sessions started while another Claude Code window was refreshing the sign-in (common with several VS Code windows) not retrying their organization policy fetch
+- Fixed CLAUDE.md and rules being read at startup through a repository symlink reaching macOS's `/Network` via `..` or a `/.vol`-style kernel path, or a rules link to macOS's `/home` being listed
+- Fixed Bash permission rules with a mid-pattern `:*` being skipped in settings files while `--allowedTools` honored them; they now work from every source, with a startup warning on how they match
+- Fixed a command approved on a restored permission prompt running twice when a remote session's worker restarted
+- Fixed managed settings ignoring a mistyped value for boolean lock keys such as `disableClaudeAiConnectors` or `allowManagedPermissionRulesOnly`; the lock now applies and startup names the key
+- Fixed managed `permissions`, `autoMode`, `worktree` and `attribution` settings being ignored entirely when one nested value was invalid; the rest of the block now still applies
```

</details>

<details>
<summary>claude-apps-gateway-ja.md</summary>

```diff
diff --git a/docs-ja/pages/claude-apps-gateway-ja.md b/docs-ja/pages/claude-apps-gateway-ja.md
index 2dbc080..be5bd8a 100644
--- a/docs-ja/pages/claude-apps-gateway-ja.md
+++ b/docs-ja/pages/claude-apps-gateway-ja.md
@@ -449,9 +449,11 @@ hooks ロックと `allowManagedPermissionRulesOnly` の開発者独自のルー
 </h4>
 
-5 つのロックすべてが設定されていても、4 つの親が提供した設定がフィルターを通過します。デフォルトの最初の勝ちの設定の下で、親をブロックする管理値は最優先の管理ソースにあるものです。ただし、[MCP サーバーロック](#lock-behavior-across-sources)がオンの間は `allowedMcpServers` を除きます。`managedSourcesBehavior` マージオプトインの下で、[Claude Code が管理ソースを組み合わせる方法](/docs/ja/managed-settings#how-claude-code-combines-managed-sources)は代わりにどのソースの値が適用されるかを示します。
+5 つのロックすべてが設定されていても、6 つの親が提供した設定がフィルターを通過します。デフォルトの最初の勝ちの設定の下で、親をブロックする管理値は最優先の管理ソースにあるものです。ただし、[MCP サーバーロック](#lock-behavior-across-sources)がオンの間は `allowedMcpServers` を除きます。`managedSourcesBehavior` マージオプトインの下で、[Claude Code が管理ソースを組み合わせる方法](/docs/ja/managed-settings#how-claude-code-combines-managed-sources)は代わりにどのソースの値が適用されるかを示します。
 
 * **`forceLoginOrgUUID`**：最優先の管理ソースが組織 UUID を設定しない場合、Claude Code は親が提供した値を尊重します。ゲートウェイサインインはこのキーをチェックしないため、最初の当事者 Anthropic ログインも使用するフリートにのみ重要です。最優先の管理ソースの組織 UUID は親の値をブロックし、Claude Code が強制するものです。そこに `forceLoginOrgUUID` を設定します。
 * **`allowedMcpServers`**：最優先の管理ソースが設定しない場合、Claude Code は親が提供した許可リストを尊重します。`allowManagedMcpServersOnly` はそれをブロックしません。ロックは勝者の許可リストを管理値として強制するため、最優先の管理ソースが設定しない場合は親が提供した許可リストを含みます。最優先の管理ソースのリストは親のリストをブロックし、Claude Code が強制するリストです。ロックの隣にそこに `allowedMcpServers` を設定します。v2.1.223 より前では、任意の管理ソースのいずれかのキーの値は親のリストをブロックしました。
 * **`availableModels`**：勝者の管理ソースが設定しない場合、Claude Code は親が提供したモデルリストを尊重します。フリートがモデルを制限する場合、勝者ソースに `availableModels` を設定します。
+* **`strictKnownMarketplaces`**：勝者の管理ソースが設定しない場合、Claude Code は親が提供したプラグインマーケットプレイス許可リストを尊重します。フリートがマーケットプレイスを制限する場合、勝者ソースに `strictKnownMarketplaces` を設定します。Claude Code v2.1.282 以降が必要です。
+* **`blockedMarketplaces`**：親が提供したマーケットプレイスブロックリストは通過し、管理ソースが設定するブロックリストに追加されます。ブロックリストはさらに制限することのみができるためです。Claude Code v2.1.282 以降が必要です。
 * **`strictPluginOnlyCustomization`**：このキーはロックに関係なくフィルターを通過し、Claude Code が開発者独自のカスタマイズ（保護フックを含む）を無視するようにします。ロックはそれをブロックしません。
 
```

</details>

<details>
<summary>costs-ja.md</summary>

```diff
diff --git a/docs-ja/pages/costs-ja.md b/docs-ja/pages/costs-ja.md
index 0086a69..f9a1153 100644
--- a/docs-ja/pages/costs-ja.md
+++ b/docs-ja/pages/costs-ja.md
@@ -408,4 +408,6 @@ Claude Code はアイドル状態でも、バックグラウンド機能にト
 これらのバックグラウンドプロセスは、アクティブなインタラクションがなくても、少量のトークン（通常はセッションあたり \$0.04 未満）を消費します。
 
+プロンプト提案がオンの場合、Claude Code は Claude が応答した後、セッションが使用しているモデルに短いリクエストを送信して、[次のプロンプトを提案](/docs/ja/interactive-mode#prompt-suggestions)します。そのリクエストは会話のプロンプトキャッシュを再利用するため、ほぼキャッシュ読み取りと少数の出力トークンです。Claude Code は[アカウントが使用量制限に近い、または達している場合、提案をスキップ](/docs/ja/interactive-mode#when-claude-code-skips-suggestions)します。これらのリクエストを停止するには、[プロンプト提案をオフにしてください](/docs/ja/interactive-mode#turn-prompt-suggestions-off)。
+
 <h2 id="why-usage-climbs-in-a-long-session">
   長いセッションで使用量が増加する理由
```

</details>

<details>
<summary>env-vars-ja.md</summary>

```diff
diff --git a/docs-ja/pages/env-vars-ja.md b/docs-ja/pages/env-vars-ja.md
index 46a24e8..18f81da 100644
--- a/docs-ja/pages/env-vars-ja.md
+++ b/docs-ja/pages/env-vars-ja.md
@@ -350,5 +350,5 @@ Claude Code はスタートアップ時にシェル環境変数を読み込む
 | `CLAUDE_CODE_PRINT_BG_WAIT_CEILING_MS`                  | [非対話モード](/docs/ja/headless#background-tasks-at-exit) で `-p` フラグを使用した最終ターン後、バックグラウンドサブエージェントとワークフローを待機するアイドル待機の上限（ミリ秒単位）。アイドル待機は Claude がバックグラウンド結果を処理するターンを取るたびに再開されます。デフォルト：`600000`、または 10 分。アイドル待機が上限に達すると、Claude Code は残りのバックグラウンドタスクの待機を停止して終了します。`0` に設定して無期限に待機します。このキャップは、プレーンバックグラウンドシェルに適用される 5 秒の猶予期間とは別です。Claude Code v2.1.182 以降が必要です                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
 | `CLAUDE_CODE_PROCESS_WRAPPER`                           | Claude Code が独自のバイナリから開始するプロセス（[エージェントビュー](/docs/ja/agent-view) セッションをホストするバックグラウンドサービスなど）を、`/opt/corp/launcher` などの argv プレフィックスとして指定されたコーポレートランチャーを通じて起動します。ユーザーまたは [管理設定](/docs/ja/managed-settings) の `env` ブロックで設定します。プロジェクトおよびローカル設定では設定できません。デタッチされたバックグラウンドサービスがそれを継承するため。[`processWrapper` 設定](/docs/ja/settings-reference#processwrapper) と同等です。Claude Code v2.1.210 以降が必要です。この変数は両方が設定されている場合に優先されます。VS Code 拡張機能は `claudeProcessWrapper` 設定を通じて独自のランチャーを個別に設定します。Windows では無視されます。値の形式、ランチャーがカバーするもの、ランチャーが満たす必要があるコントラクトについては、[コーポレートランチャーの背後で Claude Code を実行](/docs/ja/corporate-launcher) を参照してください。Claude Code v2.1.208 以降が必要です                                                                                                                                                                                                                                                                                                      |
-| `CLAUDE_CODE_PROJECT_DIR_NAME`                          | `CLAUDE_CONFIG_DIR` と一緒に設定して、Claude Code がそのセッションのトランスクリプトと自動メモリを保存する `projects/` ディレクトリ名を選択します。作業ディレクトリパスから派生したものの代わりに。例えば、`CLAUDE_CONFIG_DIR=/srv/tenant-a CLAUDE_CODE_PROJECT_DIR_NAME=work claude` で開始すると、`/srv/tenant-a/projects/work/` の下に保存されます。`CLAUDE_CONFIG_DIR` が設定されていない場合、Claude Code はこの変数を無視し、`claude` を開始する環境からのみ読み取ります。設定ファイル `env` ブロックからは読み取りません。[プロジェクトディレクトリを自分で名前付け](/docs/ja/sessions#name-your-project-directory-yourself) を参照してください。Claude Code v2.1.234 以降が必要です                                                                                                                                                                                                                                                                                                                                                                                                                                              |
+| `CLAUDE_CODE_PROJECT_DIR_NAME`                          | `CLAUDE_CONFIG_DIR` と一緒に設定して、Claude Code がそのセッションのトランスクリプトと自動メモリを保存する `projects/` ディレクトリ名を選択します。作業ディレクトリパスから派生したものの代わりに。例えば、`CLAUDE_CONFIG_DIR=/srv/tenant-a CLAUDE_CODE_PROJECT_DIR_NAME=work claude` で開始すると、`/srv/tenant-a/projects/work/` の下に保存されます。`CLAUDE_CONFIG_DIR` が設定されていない場合、Claude Code はこの変数を無視します。また、この変数は `claude` を開始する環境からのみ読み取り、[設定ファイル `env` ブロック](#in-settings-files)からは読み取りません。[プロジェクトディレクトリを自分で名前付け](/docs/ja/sessions#name-the-project-directory-yourself) を参照してください。Claude Code v2.1.234 以降が必要です                                                                                                                                                                                                                                                                                                                                                                                                                |
 | `CLAUDE_CODE_PROMPT_CACHE_TTL`                          | `5m` または `1h` に設定します。Claude Code が受け入れる唯一の値。メイン会話の [プロンプトキャッシュ TTL](/docs/ja/prompt-caching#cache-lifetime) を選択します：対話的、`-p`、SDK ターン、およびそれらと一緒に実行されるヘルパー。`promptCacheTtl` 設定および `ENABLE_PROMPT_CACHING_1H` より優先されます。`FORCE_PROMPT_CACHING_5M` がそれをオーバーライドします。API は 1 時間のキャッシュ書き込みをより高いレートで請求します。Claude Code v2.1.242 以降が必要です                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
 | `CLAUDE_CODE_PROPAGATE_TRACEPARENT`                     | `ANTHROPIC_BASE_URL` がカスタムプロキシを指している場合、W3C トレースコンテキストを伝播するには `1` に設定します。伝播はモデルおよび HTTP MCP リクエストの `traceparent` ヘッダーと、Bash、PowerShell、フックサブプロセスの `TRACEPARENT` 環境変数をカバーします。デフォルトでは、伝播は Anthropic API への直接接続に接続されている場合にのみ有効になります。v2.1.152 で追加されました。[トレース（ベータ）](/docs/ja/monitoring-usage#traces-beta) を参照してください                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
@@ -462,5 +462,5 @@ Claude Code はスタートアップ時にシェル環境変数を読み込む
 | `MAX_MCP_OUTPUT_TOKENS`                                 | MCP ツール応答で許可される最大トークン数。Claude Code は出力が 10,000 トークンを超える場合に警告を表示します。[`anthropic/maxResultSizeChars`](/docs/ja/mcp#raise-the-limit-for-a-specific-tool) を宣言するツールは、テキストコンテンツにはその文字制限を使用しますが、それらのツールからの画像コンテンツはこの変数の対象です（デフォルト：25000）                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
 | `MAX_STRUCTURED_OUTPUT_RETRIES`                         | 非対話モードで `-p` フラグを使用して、モデルの応答が [`--json-schema`](/docs/ja/cli-reference#cli-flags) に対する検証に失敗した場合、Claude Code が許可する試行回数。その後、有効な出力がない場合、実行は失敗します。[ワークフロー](/docs/ja/workflows) サブエージェントの構造化出力が検証に失敗した場合にも同じキャップが適用されます。デフォルト 5。最初の試行と 4 回の再試行                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
-| `MAX_THINKING_TOKENS`                                   | [拡張思考](https://platform.claude.com/docs/en/build-with-claude/extended-thinking) の固定トークン予算。Claude Code はそれを要求の最大出力トークンの 1 トークン下でキャップし、1,024 未満にはしません。[`CLAUDE_CODE_MAX_OUTPUT_TOKENS`](/docs/ja/model-config#adjust-effort-level) でそのリミットを設定する方法を参照してください。設定されていない場合、[適応的推論](/docs/ja/model-config#adjust-effort-level) を持つモデルは独自の思考深度を選択し、他のモデルはキャップを使用します。Anthropic API で思考を無効にするには `0` に設定します。Opus 5.5 および Fable モデルを除き、思考をオフにすることはできません。[サードパーティプロバイダー](/docs/ja/third-party-integrations) では、`0` は代わりに `thinking` パラメーターを省略します。Anthropic API で思考がオフの場合、Claude Code は、Opus 5 などの [その組み合わせを受け入れないモデル](/docs/ja/errors#effort-isnt-available-with-thinking-turned-off) に努力 `high` を送信します。Claude Code は、適応的推論モデルの非ゼロ値を無視します。ただし、`CLAUDE_CODE_DISABLE_ADAPTIVE_THINKING` が適応的推論をオフにするモデルを除きます                                                                                                                                                          |
+| `MAX_THINKING_TOKENS`                                   | [拡張思考](https://platform.claude.com/docs/en/build-with-claude/extended-thinking) の固定トークン予算。Claude Code はそれを要求の最大出力トークンの 1 トークン下でキャップし、1,024 未満にはしません。そのリミットの設定方法については、`CLAUDE_CODE_MAX_OUTPUT_TOKENS` を参照してください。設定されておらず思考が有効な場合、[適応的推論](/docs/ja/model-config#adjust-effort-level) を持つモデルは独自の思考深度を選択し、他のモデルはキャップを使用します。Anthropic API で思考を無効にするには `0` に設定します。ただし、思考をオフにできない Opus 5.5 および Fable モデルは除きます。[サードパーティプロバイダー](/docs/ja/third-party-integrations) では、`0` は代わりに `thinking` パラメーターを省略します。Anthropic API で思考がオフの場合、Claude Code は、Opus 5 など、[その組み合わせを受け入れない](/docs/ja/errors#effort-isnt-available-with-thinking-turned-off) とわかっているモデルに、より高いレベルではなく努力 `high` を送信します。Claude Code は、適応的推論モデルの非ゼロ値を無視します。ただし、`CLAUDE_CODE_DISABLE_ADAPTIVE_THINKING` が適応的推論をオフにするモデルを除きます                                                                                                                                                                       |
 | `MCP_CLIENT_SECRET`                                     | [事前設定された認証情報](/docs/ja/mcp#use-pre-configured-oauth-credentials) が必要な MCP サーバーの OAuth クライアントシークレット。`--client-secret` でサーバーを追加するときに対話的なプロンプトを回避します                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
 | `MCP_CONNECTION_NONBLOCKING`                            | MCP サーバーが最初のクエリの前に接続するのを待機するかどうかを制御します。MCP スタートアップはデフォルトで非ブロッキングです：サーバーはバックグラウンドで接続し、完了するとそれらのツールが利用可能になります。最初のクエリの前にサーバーが接続するのを待機するには `0` に設定します。[`alwaysLoad: true`](/docs/ja/mcp#exempt-a-server-from-deferral) で設定されたサーバーは、[検出キャッシュ](/docs/ja/mcp#server-status-detail) から提供される場合を除き、関係なくスタートアップを待機させます。ツールは最初のプロンプトが構築されるときに存在する必要があります。非対話モード（`-p`）で `--input-format stream-json` がない場合、Claude Code は最初のターンの前に保留中のサーバーを待機します。[`--mcp-config`](/docs/ja/cli-reference#cli-flags) を明示的に渡すと、待機にはより長いデッドラインがあります。キャッシュされたサーバーの例外については、そのフラグのエントリを参照してください                                                                                                                                                                                                                                                                                                                                                                                      |
@@ -471,5 +471,5 @@ Claude Code はスタートアップ時にシェル環境変数を読み込む
 | `MCP_DISCOVERY_CACHE_TTL_S`                             | Claude Code が [検出キャッシュ](/docs/ja/mcp#server-status-detail) エントリをリフレッシュせずに使用する秒数（デフォルト：900）。エントリがそれより古い開始では、Claude Code は引き続きそれを使用しますが、バックグラウンドでリフレッシュします。エントリが `MCP_DISCOVERY_CACHE_MAX_STALE_S` より古い場合、Claude Code は代わりに破棄します。Claude Code は値を `MCP_DISCOVERY_CACHE_MAX_STALE_S`（デフォルト 4 時間）でキャップします。v2.1.238 より前は、Claude Code は値をキャップしませんでした                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
 | `MCP_OAUTH_CALLBACK_PORT`                               | [事前設定された認証情報](/docs/ja/mcp#use-pre-configured-oauth-credentials) を使用して MCP サーバーを追加するときの OAuth リダイレクトコールバック用の固定ポート。`--callback-port` の代替                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
-| `MCP_PROTOCOL_NEGOTIATION`                              | [v2 MCP クライアントランタイム](/docs/ja/mcp#mcp-client-runtimes) でのみ、Claude Code が MCP プロトコルリビジョン 2026-07-28 のサーバーをプローブするかどうか。HTTP、claude.ai コネクター、stdio サーバーをプローブするには `auto` に設定します。プローブに応答しないサーバーは以前のプロトコルで接続します。SSE および WebSocket サーバーは常にそうします。すべてのサーバーのプローブをスキップするには `legacy` に設定します。変数がない場合、Claude Code は HTTP サーバーをプローブし、[機能フラグを取得](/docs/ja/mcp#mcp-client-runtimes) するセッションで claude.ai コネクターサーバーもプローブします。その他の値は警告で無視されます。Claude Code v2.1.221 以降が必要です                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
+| `MCP_PROTOCOL_NEGOTIATION`                              | [v2 MCP クライアントランタイム](/docs/ja/mcp#mcp-client-runtimes) でのみ、Claude Code が MCP プロトコルリビジョン 2026-07-28 のサーバーをプローブするかどうか。HTTP、claude.ai コネクター、stdio サーバーをプローブするには `auto` に設定します。プローブに応答しないサーバーは以前のプロトコルで接続します。SSE および WebSocket サーバーは常にそうします。すべてのサーバーのプローブをスキップするには `legacy` に設定します。変数がない場合、Claude Code は HTTP サーバーをプローブし、[機能フラグを取得](#features-that-need-feature-flag-fetching) するセッションで claude.ai コネクターサーバーもプローブします。その他の値は無視され、デバッグログに警告が書き込まれます。Claude Code v2.1.221 以降が必要です                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
 | `MCP_REMOTE_SERVER_CONNECTION_BATCH_SIZE`               | スタートアップ中に並列で接続するリモート MCP サーバー（HTTP/SSE）の最大数（デフォルト：20）                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
 | `MCP_SDK_GENERATION`                                    | このプロセスが MCP サーバーに接続する [MCP クライアントランタイム](/docs/ja/mcp#mcp-client-runtimes) をピン留めします：`v1`（MCP TypeScript SDK 1.x に基づく）または `v2`（[MCP TypeScript SDK 2.0](https://ts.sdk.modelcontextprotocol.io/v2/) に基づく）。変数がない場合、Claude Code は v2 を使用します。そのセクションにリストされているバージョンから開始。Claude Code v2.1.221 以降では、v2 ランタイムは MCP OAuth サーバーが認可応答で返す発行者をチェックし、一致しない場合、`Issuer mismatch in authorization response` で始まるエラーでサインインに失敗します。v1 ランタイムはこのチェックを実行しません。認識されない値を設定すると、Claude Code はそれを無視し、デバッグログに警告を書き込みます。Claude Code はプロセスごとに値を 1 回読み取ります。Claude Code v2.1.218 以降が必要です                                                                                                                                                                                                                                                                                                                                                                                  |
```

</details>

<details>
<summary>errors-ja.md</summary>

```diff
diff --git a/docs-ja/pages/errors-ja.md b/docs-ja/pages/errors-ja.md
index 6282f10..a53f8b1 100644
--- a/docs-ja/pages/errors-ja.md
+++ b/docs-ja/pages/errors-ja.md
@@ -37,4 +37,6 @@
 | `Auto mode classifier transcript exceeded context window`                                                                                                                                                                                                            | [サーバーエラー](#auto-mode-cannot-determine-the-safety-of-an-action)                                    |
 | `Agent aborted: auto mode classifier request refused by the safety safeguard`                                                                                                                                                                                        | [サーバーエラー](#auto-mode-cannot-determine-the-safety-of-an-action)                                    |
+| `The server-side auto mode classifier gave no verdict`                                                                                                                                                                                                               | [サーバーエラー](#the-server-returned-no-safety-verdict)                                                 |
+| `Auto mode is unavailable — the server returned no safety verdict for the last 10 responses`                                                                                                                                                                         | [サーバーエラー](#the-server-returned-no-safety-verdict)                                                 |
 | `Agent terminated early due to an API error`                                                                                                                                                                                                                         | [サーバーエラー](#agent-terminated-early-due-to-an-api-error)                                            |
 | `You've hit your session limit` / `You've hit your weekly limit` / `You've hit your Opus limit` / `You've hit your Sonnet limit`                                                                                                                                     | [使用制限](#youve-hit-your-session-limit)                                                             |
@@ -155,4 +157,6 @@
 | `API Error: 400 duplicate tool_use ID in conversation history`                                                                                                                                                                                                       | [リクエストエラー](#tool-use-or-thinking-block-mismatch)                                                  |
 | `[Unsupported tool content removed]`                                                                                                                                                                                                                                 | [リクエストエラー](#unsupported-tool-content-removed)                                                     |
+| `role 'system' must precede an 'assistant' message`                                                                                                                                                                                                                  | [リクエストエラー](#role-system-must-precede-an-assistant-message)                                        |
+| `Invalid encrypted_content in search_result block` / `Invalid encrypted_index in text block` / `Failed to decrypt web search result content`                                                                                                                         | [リクエストエラー](#invalid-encrypted-content-in-search-result-block)                                     |
 | `server_tool_use.name: Input should be` on every turn of a resumed session                                                                                                                                                                                           | [リクエストエラー](#unsupported-tool-content-removed)                                                     |
 | `<model> can't help with this. Start a new session to continue`                                                                                                                                                                                                      | [リクエストエラー](#usage-policy-refusal)                                                                 |
@@ -172,4 +176,5 @@
 | `Error: Settings file exceeds the 2MiB limit`                                                                                                                                                                                                                        | [コマンドラインエラー](#settings-file-exceeds-the-2mib-limit)                                               |
 | `The current directory no longer exists (it was deleted or moved)` / `Can't read the current directory`                                                                                                                                                              | [コマンドラインエラー](#the-current-directory-no-longer-exists)                                             |
+| `Temp directory <dir> ... Refusing to use it` / `ENOSPC: no space left on device, mkdir '<dir>'`                                                                                                                                                                     | [コマンドラインエラー](#temp-directory-refused-or-cannot-be-created)                                        |
 | `couldn't be resolved to a real location, so its skills, commands, and agents weren't loaded`                                                                                                                                                                        | [コマンドラインエラー](#directory-couldnt-be-resolved-to-a-real-location)                                   |
 | `Error: Workspace not trusted` when starting Remote Control                                                                                                                                                                                                          | [コマンドラインエラー](#workspace-not-trusted-when-starting-remote-control)                                 |
@@ -215,4 +220,5 @@
 | `Marketplace "<name>" is registered from an untrusted source`                                                                                                                                                                                                        | [プラグインエラー](#marketplace-is-registered-from-an-untrusted-source)                                   |
 | `Marketplace "<name>" is already added from a different source`                                                                                                                                                                                                      | [プラグインエラー](#marketplace-is-already-added-from-a-different-source)                                 |
+| `"<name>" is another spelling of "<reserved>", a reserved marketplace name`                                                                                                                                                                                          | [プラグインエラー](#marketplace-name-is-another-spelling-of-a-reserved-name)                              |
 | `references ${user_config.*} in a shell-form command`                                                                                                                                                                                                                | [プラグインエラー](#plugin-command-references-user-config)                                                |
 | `Monitor "<name>" from plugin <plugin> references ${user_config.*} in its command`                                                                                                                                                                                   | [プラグインエラー](#plugin-command-references-user-config)                                                |
```

</details>

<details>
<summary>interactive-mode-ja.md</summary>

```diff
diff --git a/docs-ja/pages/interactive-mode-ja.md b/docs-ja/pages/interactive-mode-ja.md
index 0be1131..fc9dd03 100644
--- a/docs-ja/pages/interactive-mode-ja.md
+++ b/docs-ja/pages/interactive-mode-ja.md
@@ -440,5 +440,5 @@ Claude が応答した後、Claude Code は会話履歴に基づいて次のプ
 * 入力を開始して提案を閉じます
 
-Claude Code は、これらの次のプロンプト提案を、会話のプロンプトキャッシュを再利用するバックグラウンドリクエストで生成するため、追加コストは最小限です。
+Claude Code は、これらの次のプロンプト提案を、セッションが使用しているのと同じモデルへのバックグラウンドリクエストで生成します。このリクエストはプランの使用制限または API コストにカウントされます。会話のプロンプトキャッシュを再利用するため、主にキャッシュ読み取りと少数の出力トークンで構成されるため、追加コストは最小限です。
 
 <h3 id="when-claude-code-skips-suggestions">
```

</details>

<details>
<summary>managed-settings-ja.md</summary>

```diff
diff --git a/docs-ja/pages/managed-settings-ja.md b/docs-ja/pages/managed-settings-ja.md
index 3817b63..89f0621 100644
--- a/docs-ja/pages/managed-settings-ja.md
+++ b/docs-ja/pages/managed-settings-ja.md
@@ -96,5 +96,5 @@ Jamf、Iru、Intune、グループポリシーのスターターテンプレー
   * **リモート Cowork セッション**: これらは Anthropic 管理 VM 上で実行され、Claude Code はデバイスポリシーを読み取ることができません。
 
-  [サーフェスカバレッジ](/docs/ja/model-config#surface-coverage) テーブルは Cowork と他のサーフェスを比較しています。
+  セッションが実行される場所に関係なく、claude.ai は管理コンソールの [`strictKnownMarketplaces`](/docs/ja/settings-reference#strictknownmarketplaces) および [`blockedMarketplaces`](/docs/ja/settings-reference#blockedmarketplaces) リストを、誰かが claude.ai 上の git リポジトリからマーケットプレイスを追加するか、Cowork タブの **Customize** から追加する場合に自動的に適用します。[制限がどのように機能するか](/docs/ja/plugin-marketplaces#how-restrictions-work) はそのチェックについて説明しています。[サーフェスカバレッジ](/docs/ja/model-config#surface-coverage) テーブルは Cowork と他のサーフェスを比較しています。
 * **実行中のセッション**: ほとんどの変更は、[配信メカニズムテーブル](#choose-a-delivery-mechanism) のスケジュールに従って、再起動なしで実行中のセッションに到達します。
   * [`forceRemoteSettingsRefresh`](/docs/ja/settings-reference#forceremotesettingsrefresh)、[`requiredMinimumVersion`](/docs/ja/settings-reference#requiredminimumversion)、および [いくつかのユーザー編集可能キー](/docs/ja/settings#when-edits-take-effect) への変更は、次のセッション開始時に有効になります。
```

</details>

<details>
<summary>memory-ja.md</summary>

```diff
diff --git a/docs-ja/pages/memory-ja.md b/docs-ja/pages/memory-ja.md
index 593320a..fbff3ad 100644
--- a/docs-ja/pages/memory-ja.md
+++ b/docs-ja/pages/memory-ja.md
@@ -380,5 +380,5 @@ Claude Code は [`AGENTS.md`](/docs/ja/glossary#agents-md) をプロジェクト
 
 <Note>
-  `AGENTS.md` を直接読み込むには Claude Code v2.1.277 以降が必要です。Amazon Bedrock 上のセッションやテレメトリが無効になっているセッションなど、一部のセッションでは Claude が [`AGENTS.md` を読み込むことができない](#when-agents-md-support-is-unavailable) ため、代わりに [`CLAUDE.md` からインポート](#share-one-file-with-other-coding-tools) してください。
+  `AGENTS.md` を直接読み込むには Claude Code v2.1.277 以降が必要です。一部のセッションでは Claude が [`AGENTS.md` を読み込むことができない](#when-agents-md-support-is-unavailable) ため、代わりに [`CLAUDE.md` からインポート](#share-one-file-with-other-coding-tools) してください。
 </Note>
 
@@ -437,9 +437,8 @@ Claude が読み込むファイルを変更するには、Claude Code セッシ
 
 * Claude Code v2.1.277 より前のバージョンを使用している
-* セッション が Anthropic から [フィーチャーフラグをフェッチしない](/docs/ja/env-vars#features-that-need-feature-flag-fetching)（例えば Amazon Bedrock または別のサードパーティプロバイダーを使用している、またはテレメトリを無効にしている）。リンク先のセクションに完全なリストがあります
-* `AGENTS.md` サポート付きのバージョンに [インストールまたはアップグレード](/docs/ja/env-vars#first-session-after-an-install-or-upgrade) した後の最初のセッションです。次のセッションから Claude は `AGENTS.md` を読み込みます
 * 組み込み `agents-md` プラグインを `/plugin` で無効にしました
+* 一部の場合、v2.1.276 以前から [アップグレード](/docs/ja/env-vars#first-session-after-an-install-or-upgrade) した後の最初のセッションです。次のセッションから Claude は `AGENTS.md` を読み込みます
 
-これらのセッションで Claude に `AGENTS.md` を提供するには、[`CLAUDE.md` からインポート](#share-one-file-with-other-coding-tools) してください。
+v2.1.281 より前では、Amazon Bedrock 上のセッションやテレメトリが無効になっているセッションなど、一部のセッションは `CLAUDE.md` ファイルのみを読み込みます。これらのバージョンでは Claude Code を更新してください。これらのセッションのいずれかで Claude に `AGENTS.md` を提供するには、[`CLAUDE.md` からインポート](#share-one-file-with-other-coding-tools) してください。
 
 <h3 id="where-agents-md-differs-from-claude-md">
@@ -638,7 +637,6 @@ CLAUDE.md のコンテンツは、システムプロンプト自体の一部で
 
 1. 作業ディレクトリまたはそれより上のディレクトリ（`~/.claude/CLAUDE.md` を除く）で `CLAUDE.md`、`.claude/CLAUDE.md`、または `CLAUDE.local.md` を探します。見つかった場合、**Project instructions** を `claude-md-and-agents-md` に設定しない限り、Claude はそれを `AGENTS.md` の代わりに読み込みます。
-2. `claude --version` を実行し、v2.1.277 以降であることを確認します。
-3. セッションが [AGENTS.md を読み込むことができない](#when-agents-md-support-is-unavailable) セッション（サードパーティプロバイダーのセッションやテレメトリが無効なセッションなど）であるかどうかを確認します。
-4. セッションで `/config` を入力して設定パネルを開き、**Project instructions** が `claude-md` または `managed-only` に設定されていないことを確認します。そこに設定が表示されない場合、セッションは [AGENTS.md を読み込むことができない](#when-agents-md-support-is-unavailable) セッションです。
+2. `claude --version` を実行し、v2.1.277 以降であることを確認します。v2.1.281 より前では、Amazon Bedrock 上のセッションやテレメトリが無効なセッションなど、一部のセッションは [AGENTS.md を読み込むことができない](#when-agents-md-support-is-unavailable) ため、これらのバージョンでは v2.1.281 以降に更新してください。
```

</details>

*...以降省略*

</details>


<details>
<summary>2026-09-24</summary>

**変更ファイル:**

```
 docs-ja/pages/artifacts-ja.md              |  22 ++--
 docs-ja/pages/changelog.md                 | 179 +++++++++++++++++++++++++++++
 docs-ja/pages/claude-code-on-the-web-ja.md |   2 +-
 docs-ja/pages/cloud-environments-ja.md     |   2 +-
 docs-ja/pages/env-vars-ja.md               |   9 +-
 docs-ja/pages/feature-availability-ja.md   |   1 -
 docs-ja/pages/glossary-ja.md               |   2 +-
 docs-ja/pages/mcp-ja.md                    |   4 +-
 docs-ja/pages/monitoring-usage-ja.md       |   5 +
 docs-ja/pages/plugin-marketplaces-ja.md    |  38 ++----
 docs-ja/pages/plugins-ja.md                |   2 +
 docs-ja/pages/skills-ja.md                 |  10 ++
 docs-ja/pages/ultrareview-ja.md            |  22 ++--
 docs-ja/pages/voice-dictation-ja.md        |  14 ++-
 docs-ja/pages/vs-code-ja.md                |  27 ++++-
 docs-ja/pages/web-quickstart-ja.md         |   2 +-
 16 files changed, 284 insertions(+), 57 deletions(-)
```

<details>
<summary>artifacts-ja.md</summary>

```diff
diff --git a/docs-ja/pages/artifacts-ja.md b/docs-ja/pages/artifacts-ja.md
index 1c2771d..0ebc105 100644
--- a/docs-ja/pages/artifacts-ja.md
+++ b/docs-ja/pages/artifacts-ja.md
@@ -345,13 +345,17 @@ UI、画面フロー、ランディングページ、またはポスターをモ
 </h2>
 
-アーティファクトには、以下のすべての条件が必要です。いずれかが満たされていない場合、Claude はローカル HTML ファイルを書き込むか、公開できないと言います。
-
-| 要件        | 利用可能な場合                                                                                                                                                                                                                                                                                                                                            |
-| :-------- | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
-| プラン       | Pro、Max、Team、または Enterprise。Pro および Max プランでは、アーティファクトはあなたにプライベートであり、共有するまで管理者管理は適用されません。Team プランでは、アーティファクトはデフォルトで有効です。Enterprise プランでは、Owner が claude.ai 管理設定で[有効にします](#manage-artifacts-for-your-organization)。                                                                                                                                 |
-| 認証        | セッションは claude.ai アカウントでバックアップされています。CLI またはデスクトップアプリで `/login` でサインインしてください。Claude Tag セッションはエージェントの ID を通じてサインインするため、追加の手順は不要です。API キー、[ゲートウェイトークン](/docs/ja/llm-gateway)、またはクラウドプロバイダー認証情報を使用するセッションは公開できません。                                                                                                                                         |
-| モデルプロバイダー | Anthropic API。[Amazon Bedrock](/docs/ja/amazon-bedrock)、[Google Cloud の Agent Platform](/docs/ja/google-vertex-ai)、または [Microsoft Foundry](/docs/ja/microsoft-foundry) では利用できません。                                                                                                                                                                                 |
-| 組織ポリシー    | カスタマー管理暗号化キー（CMEK）、HIPAA、および [Zero Data Retention](/docs/ja/zero-data-retention) は組織で有効になっていません。                                                                                                                                                                                                                                                        |
-| サーフェス     | Claude Code CLI、または Claude デスクトップアプリバージョン 1.13576.0 以降。[Claude Tag](https://claude.com/docs/claude-tag/overview) セッションは、Claude Tag とアーティファクトの両方が組織で有効になっている場合、アーティファクトを公開することもできます。[Agent SDK](/docs/ja/agent-sdk/overview)、GitHub Action、MCP サーバーコンテキストではデフォルトでオフになっており、[`CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC`](/docs/ja/env-vars) が設定されている場合もオフになります。 |
+Artifacts には以下のすべての条件が必要です。いずれかが満たされていない場合、Claude はローカル HTML ファイルを作成するか、公開できないと述べます。
+
+| 要件        | 利用可能な場合                                                                                                                                                                                                                                                                                                                                           |
+| :-------- | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
+| プラン       | Pro、Max、Team、または Enterprise。Pro および Max プランでは、Artifacts は共有するまであなたのみがアクセスでき、管理者管理は適用されません。Team プランでは、Artifacts はデフォルトで有効です。Enterprise プランでは、Owner が claude.ai 管理設定で[それらを有効にします](#manage-artifacts-for-your-organization)。                                                                                                                         |
+| 認証        | セッションが claude.ai アカウントでサポートされています。CLI またはデスクトップアプリで `/login` でサインインします。Claude Tag セッションはエージェントの ID を通じてサインインするため、追加の手順は不要です。API キー、[ゲートウェイトークン](/docs/ja/llm-gateway)、またはクラウドプロバイダー認証情報を使用するセッションは公開できません。                                                                                                                                             |
+| モデルプロバイダー | Anthropic API。[Amazon Bedrock](/docs/ja/amazon-bedrock)、[Google Cloud の Agent Platform](/docs/ja/google-vertex-ai)、または[Microsoft Foundry](/docs/ja/microsoft-foundry)では利用できません。                                                                                                                                                                                  |
+| 組織ポリシー    | カスタマー管理暗号化キー（CMEK）、HIPAA、および[Zero Data Retention](/docs/ja/zero-data-retention)は組織に対して有効になっていません。                                                                                                                                                                                                                                                      |
+| サーフェス     | Claude Code CLI、または Claude デスクトップアプリバージョン 1.13576.0 以降。[Claude Tag](https://claude.com/docs/claude-tag/overview) セッションは、Claude Tag と Artifacts の両方が組織に対して有効な場合にも Artifacts を公開できます。[Agent SDK](/docs/ja/agent-sdk/overview)、GitHub Action、および MCP サーバーコンテキストではデフォルトで無効です。また、[`CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC`](/docs/ja/env-vars)が設定されている場合も無効です。 |
+
+Artifacts が組織に対して許可されているかどうかは、Claude Code が `api.anthropic.com` から読み込む組織のポリシーから決まります。Claude Code がポリシーを読み込めない場合、Artifacts は利用できません。リクエストすると、Claude がその理由を説明します。
+
+プロキシ、VPN、またはウェブフィルターが関係している場合は、IT 管理者に `api.anthropic.com` を許可するよう依頼してください。Claude Code はバックグラウンドで再試行を続け、ポリシーが読み込まれて許可されると、Artifacts が利用可能になります。
 
```

</details>

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index c970aeb..288b140 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,183 @@
 # Changelog
 
+## 2.1.281
+
+- Added Claude apps gateway support for newer Claude Desktop keys in `desktop` policy blocks, including `blockReadsOutsideWorkingDirectories` and `disableBypassPermissionsMode`
+- Added `assume_role` on Claude apps gateway Bedrock upstreams: the gateway calls Bedrock as an IAM role it assumes through STS, in another AWS account if needed, optionally one session per developer
+- Added `guardrail: {id, version}` on Claude apps gateway Bedrock upstreams to apply an Amazon Bedrock guardrail to every request sent through them (set it on all Bedrock upstreams or none)
+- Added `telemetry.resource_attributes` to the Claude apps gateway config, to put fixed labels on the telemetry of Claude Desktop and `/login` sessions
+- Added `"attribution": false` in `settings.json` to hide all commit and PR attribution; older CLI versions skip a settings file that holds it, so keep the object form in files shared across versions
+- Added MCP URL-mode elicitation on 2026-07-28 protocol connections, so servers can ask Claude Code to open a browser-based flow; no waiting dialog is left on screen when the server has no way to confirm completion
+- Added MCP server checks to `claude plugin validate`: it reports `.mcp.json` entries that would be silently dropped at load, undeclared `${user_config.*}` references, and insecure URLs
+- Added an auto mode recommendation to `/insights` that estimates how many permission prompts auto mode could have handled in your recent sessions
+- Added a scrollbar to the `/skills`, `/mcp` and `/plugin` Installed lists in fullscreen mode, like the one `/workflows` now has: it appears while the mouse is over the list and can be clicked or dragged
+- Fixed a crash ("unrecoverable interface error") that could end a session while an API request was being retried
+- Fixed a turn that could retry indefinitely, ignoring `--max-turns`, when the model alternated unparseable tool calls and output-limit truncation
+- Fixed resumed sessions re-sending earlier turns in a changed form (a parallel tool-call turn, an MCP tool call's input or a tool-search result while its server was still reconnecting, or a tool-search result whose loading turn was interrupted), which could make the API drop the conversation's prior reasoning
+- Fixed resuming a very large session sometimes restoring only its last few messages
+- Fixed a session resumed after a restart during a pending permission prompt sending a different history than before, which broke the prompt cache from that point
+- Fixed resuming a session that ended during a tool call: Claude now sees the call and is told its outcome is unknown, and a manual resume no longer adds a hidden "Continue" message
+- Fixed sessions with an earlier advisor result the API could no longer read failing one request every turn and repeatedly losing earlier reasoning; the history is now repaired once
+- Fixed the prompt cache being lost when an MCP server disconnects mid-conversation, or is still connecting after a resume, while tool search is off (for example behind a proxy or gateway)
+- Fixed responses cut short by a proxy or gateway that closes the stream cleanly being shown as complete with no warning, and tool calls running twice on duplicated stream events
+- Fixed responses failing with "Content block not found" when a proxy drops a stream event mid-response; the partial response is now kept, and web search keeps results that already arrived
+- Fixed an empty completed response being requested twice when the connection dropped before the stream's final event
+- Fixed the stop reason being lost when a proxy sends a trailing usage-only frame
```

</details>

<details>
<summary>claude-code-on-the-web-ja.md</summary>

```diff
diff --git a/docs-ja/pages/claude-code-on-the-web-ja.md b/docs-ja/pages/claude-code-on-the-web-ja.md
index 3c4211b..9c57b1d 100644
--- a/docs-ja/pages/claude-code-on-the-web-ja.md
+++ b/docs-ja/pages/claude-code-on-the-web-ja.md
@@ -8,5 +8,5 @@
 
 <Note>
-  クラウドセッションは Pro、Max、Team ユーザー、および Premium シートまたは Chat + Claude Code シートを持つ Enterprise ユーザーを対象に研究プレビュー中です。
+  クラウドセッションは Pro、Max、Team プランで利用でき、Premium シートまたは Chat + Claude Code シートを持つ Enterprise ユーザーも対象です。
 </Note>
 
```

</details>

<details>
<summary>cloud-environments-ja.md</summary>

```diff
diff --git a/docs-ja/pages/cloud-environments-ja.md b/docs-ja/pages/cloud-environments-ja.md
index a0f8fa2..20124db 100644
--- a/docs-ja/pages/cloud-environments-ja.md
+++ b/docs-ja/pages/cloud-environments-ja.md
@@ -8,5 +8,5 @@
 
 <Note>
-  クラウド環境は [クラウドセッション](/docs/ja/claude-code-on-the-web) に適用されます。これは Pro、Max、Team ユーザーの研究プレビュー版であり、[プレミアムシートまたは Chat + Claude Code シートを持つ](https://support.claude.com/en/articles/11845131-use-claude-code-with-your-team-or-enterprise-plan) Enterprise ユーザー向けです。
+  クラウド環境は [クラウドセッション](/docs/ja/claude-code-on-the-web) に適用されます。これは Pro、Max、Team プランで利用可能であり、[プレミアムシートまたは Chat + Claude Code シートを持つ](https://support.claude.com/en/articles/11845131-use-claude-code-with-your-team-or-enterprise-plan) Enterprise ユーザー向けです。
 </Note>
 
```

</details>

<details>
<summary>env-vars-ja.md</summary>

```diff
diff --git a/docs-ja/pages/env-vars-ja.md b/docs-ja/pages/env-vars-ja.md
index c7ca51d..46a24e8 100644
--- a/docs-ja/pages/env-vars-ja.md
+++ b/docs-ja/pages/env-vars-ja.md
@@ -312,4 +312,5 @@ Claude Code はスタートアップ時にシェル環境変数を読み込む
 | `CLAUDE_CODE_MAX_CONCURRENT_SUBAGENTS`                  | 1 つのセッションで実行できる [サブエージェント](/docs/ja/sub-agents#concurrent-subagent-limit) の数。Agent ツールが別のセッションを生成するのを拒否する前（デフォルト：20）。平文数字で正の整数を受け入れます。その他は無視されるため、変数は上限を調整できますが、無効にすることはできません。Claude Code v2.1.217 以降が必要です                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
 | `CLAUDE_CODE_MAX_CONTEXT_TOKENS`                        | Claude Code がアクティブなモデルに対して想定するコンテキストウィンドウサイズをオーバーライドします。v2.1.193 以降、それがどのように適用されるかは Claude Code がモデル ID をどのように解決するかに依存します。[ゲートウェイまたはカスタムモデル ID のウィンドウを修正](/docs/ja/model-config#correct-the-window-for-a-gateway-or-custom-model-id) を参照してください。`ANTHROPIC_BASE_URL` を通じてモデルにルーティングする場合、その名前の組み込みサイズと一致しないコンテキストウィンドウを持つモデルの場合に使用します                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
+| `CLAUDE_CODE_MAX_MCP_DESCRIPTION_LENGTH`                | Claude Code がモデルに送信する各 MCP ツール説明と各 MCP サーバーの指示の最大長（文字単位）（デフォルト：2048）。Claude Code は [より長いテキストを切り詰めます](/docs/ja/mcp#for-mcp-server-authors)。平文数字で正の整数を受け入れます。その他は無視され、デフォルトが適用されます。Claude Code v2.1.280 以降が必要です                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
 | `CLAUDE_CODE_MAX_OUTPUT_TOKENS`                         | ほとんどのリクエストの最大出力トークン数を設定します。デフォルトと上限はモデルによって異なります。[最大出力トークン](https://platform.claude.com/docs/en/about-claude/models/overview#latest-models-comparison) を参照してください。Claude Code は、ゲートウェイ固有の名前など、認識しないモデル ID に対して 32000 にデフォルト設定し、モデルの上限を超える値をモデルの上限に低下させます。この値を増加させると、[自動圧縮](/docs/ja/costs#reduce-token-usage) がトリガーされる前に利用可能な有効なコンテキストウィンドウが減少します                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
 | `CLAUDE_CODE_MAX_RETRIES`                               | 失敗した API リクエストを再試行する回数をオーバーライドします（デフォルト：10）。v2.1.186 以降、15 でキャップされます。v2.1.199 以降、`CLAUDE_CODE_RETRY_WATCHDOG` はデフォルトを上げ、キャップを削除します。より長い停止を待つ必要がある無人セッションの場合は、代わりに `CLAUDE_CODE_RETRY_WATCHDOG` を設定します                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
@@ -341,4 +342,5 @@ Claude Code はスタートアップ時にシェル環境変数を読み込む
 | `CLAUDE_CODE_PERFORCE_MODE`                             | Perforce 対応の書き込み保護を有効にするには `1` に設定します。設定されている場合、Edit、Write、および NotebookEdit は、所有者書き込みビットがないターゲットファイルで失敗します。Perforce は同期されたファイルでこれをクリアします。`p4 edit` がそれらを開くまで。これにより、Claude Code が Perforce 変更追跡をバイパスするのを防ぎます                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
 | `CLAUDE_CODE_PLUGIN_CACHE_DIR`                          | プラグインルートディレクトリをオーバーライドします。名前に反して、これは親ディレクトリを設定します。マーケットプレイスとプラグインキャッシュはこのパスの下のサブディレクトリに存在します。デフォルトは `~/.claude/plugins` です                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
+| `CLAUDE_CODE_PLUGIN_DIRS`                               | セッション用に読み込むプラグインディレクトリ。各ディレクトリは [`--plugin-dir`](/docs/ja/plugins#test-your-plugins-locally) フラグが読み込む方法で読み込まれます。Unix では `:` で、Windows では `;` で複数のパスを分離します。各パスを絶対パスとして指定するか、`~` で開始します。Claude Code は相対パスをスキップするため。Claude Code v2.1.280 以降が必要です                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
 | `CLAUDE_CODE_PLUGIN_GIT_TIMEOUT_MS`                     | プラグインのインストールまたは更新時の git 操作のタイムアウト（ミリ秒単位）（デフォルト：120000）。大規模なリポジトリまたは遅いネットワーク接続の場合は、この値を増加させます。[Git 操作がタイムアウト](/docs/ja/plugin-marketplaces#git-operations-time-out) を参照してください                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
 | `CLAUDE_CODE_PLUGIN_KEEP_MARKETPLACE_ON_FAILURE`        | マーケットプレイスリフレッシュがリモートに到達または認証できない場合、再複製試行をスキップし、既存のマーケットプレイスチェックアウトを使用し続けるには `1` に設定します。オフラインまたはエアギャップ環境で再複製が同じ方法で失敗する場合に便利です。[オフライン環境でのマーケットプレイス更新の失敗](/docs/ja/plugin-marketplaces#marketplace-updates-fail-in-offline-environments) を参照してください                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
@@ -348,5 +350,5 @@ Claude Code はスタートアップ時にシェル環境変数を読み込む
 | `CLAUDE_CODE_PRINT_BG_WAIT_CEILING_MS`                  | [非対話モード](/docs/ja/headless#background-tasks-at-exit) で `-p` フラグを使用した最終ターン後、バックグラウンドサブエージェントとワークフローを待機するアイドル待機の上限（ミリ秒単位）。アイドル待機は Claude がバックグラウンド結果を処理するターンを取るたびに再開されます。デフォルト：`600000`、または 10 分。アイドル待機が上限に達すると、Claude Code は残りのバックグラウンドタスクの待機を停止して終了します。`0` に設定して無期限に待機します。このキャップは、プレーンバックグラウンドシェルに適用される 5 秒の猶予期間とは別です。Claude Code v2.1.182 以降が必要です                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
 | `CLAUDE_CODE_PROCESS_WRAPPER`                           | Claude Code が独自のバイナリから開始するプロセス（[エージェントビュー](/docs/ja/agent-view) セッションをホストするバックグラウンドサービスなど）を、`/opt/corp/launcher` などの argv プレフィックスとして指定されたコーポレートランチャーを通じて起動します。ユーザーまたは [管理設定](/docs/ja/managed-settings) の `env` ブロックで設定します。プロジェクトおよびローカル設定では設定できません。デタッチされたバックグラウンドサービスがそれを継承するため。[`processWrapper` 設定](/docs/ja/settings-reference#processwrapper) と同等です。Claude Code v2.1.210 以降が必要です。この変数は両方が設定されている場合に優先されます。VS Code 拡張機能は `claudeProcessWrapper` 設定を通じて独自のランチャーを個別に設定します。Windows では無視されます。値の形式、ランチャーがカバーするもの、ランチャーが満たす必要があるコントラクトについては、[コーポレートランチャーの背後で Claude Code を実行](/docs/ja/corporate-launcher) を参照してください。Claude Code v2.1.208 以降が必要です                                                                                                                                                                                                                                                                                                      |
-| `CLAUDE_CODE_PROJECT_DIR_NAME`                          | `CLAUDE_CONFIG_DIR` と一緒に設定して、Claude Code がそのセッションのトランスクリプトと自動メモリを保存する `projects/` ディレクトリ名を選択します。作業ディレクトリパスから派生したものの代わりに。例えば、`CLAUDE_CONFIG_DIR=/srv/tenant-a CLAUDE_CODE_PROJECT_DIR_NAME=work claude` で開始すると、`/srv/tenant-a/projects/work/` の下に保存されます。`CLAUDE_CONFIG_DIR` が設定されていない場合、Claude Code はこの変数を無視します。また、この変数は `claude` を開始する環境からのみ読み取り、[設定ファイル `env` ブロック](#in-settings-files)からは読み取りません。[プロジェクトディレクトリを自分で名前付け](/docs/ja/sessions#name-the-project-directory-yourself) を参照してください。Claude Code v2.1.234 以降が必要です                                                                                                                                                                                                                                                                                                                                                                                                                |
+| `CLAUDE_CODE_PROJECT_DIR_NAME`                          | `CLAUDE_CONFIG_DIR` と一緒に設定して、Claude Code がそのセッションのトランスクリプトと自動メモリを保存する `projects/` ディレクトリ名を選択します。作業ディレクトリパスから派生したものの代わりに。例えば、`CLAUDE_CONFIG_DIR=/srv/tenant-a CLAUDE_CODE_PROJECT_DIR_NAME=work claude` で開始すると、`/srv/tenant-a/projects/work/` の下に保存されます。`CLAUDE_CONFIG_DIR` が設定されていない場合、Claude Code はこの変数を無視し、`claude` を開始する環境からのみ読み取ります。設定ファイル `env` ブロックからは読み取りません。[プロジェクトディレクトリを自分で名前付け](/docs/ja/sessions#name-your-project-directory-yourself) を参照してください。Claude Code v2.1.234 以降が必要です                                                                                                                                                                                                                                                                                                                                                                                                                                              |
 | `CLAUDE_CODE_PROMPT_CACHE_TTL`                          | `5m` または `1h` に設定します。Claude Code が受け入れる唯一の値。メイン会話の [プロンプトキャッシュ TTL](/docs/ja/prompt-caching#cache-lifetime) を選択します：対話的、`-p`、SDK ターン、およびそれらと一緒に実行されるヘルパー。`promptCacheTtl` 設定および `ENABLE_PROMPT_CACHING_1H` より優先されます。`FORCE_PROMPT_CACHING_5M` がそれをオーバーライドします。API は 1 時間のキャッシュ書き込みをより高いレートで請求します。Claude Code v2.1.242 以降が必要です                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
 | `CLAUDE_CODE_PROPAGATE_TRACEPARENT`                     | `ANTHROPIC_BASE_URL` がカスタムプロキシを指している場合、W3C トレースコンテキストを伝播するには `1` に設定します。伝播はモデルおよび HTTP MCP リクエストの `traceparent` ヘッダーと、Bash、PowerShell、フックサブプロセスの `TRACEPARENT` 環境変数をカバーします。デフォルトでは、伝播は Anthropic API への直接接続に接続されている場合にのみ有効になります。v2.1.152 で追加されました。[トレース（ベータ）](/docs/ja/monitoring-usage#traces-beta) を参照してください                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
@@ -460,5 +462,5 @@ Claude Code はスタートアップ時にシェル環境変数を読み込む
 | `MAX_MCP_OUTPUT_TOKENS`                                 | MCP ツール応答で許可される最大トークン数。Claude Code は出力が 10,000 トークンを超える場合に警告を表示します。[`anthropic/maxResultSizeChars`](/docs/ja/mcp#raise-the-limit-for-a-specific-tool) を宣言するツールは、テキストコンテンツにはその文字制限を使用しますが、それらのツールからの画像コンテンツはこの変数の対象です（デフォルト：25000）                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
 | `MAX_STRUCTURED_OUTPUT_RETRIES`                         | 非対話モードで `-p` フラグを使用して、モデルの応答が [`--json-schema`](/docs/ja/cli-reference#cli-flags) に対する検証に失敗した場合、Claude Code が許可する試行回数。その後、有効な出力がない場合、実行は失敗します。[ワークフロー](/docs/ja/workflows) サブエージェントの構造化出力が検証に失敗した場合にも同じキャップが適用されます。デフォルト 5。最初の試行と 4 回の再試行                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
-| `MAX_THINKING_TOKENS`                                   | [拡張思考](https://platform.claude.com/docs/en/build-with-claude/extended-thinking) の固定トークン予算。Claude Code はそれを要求の最大出力トークンの 1 トークン下でキャップし、1,024 未満にはしません。そのリミットの設定方法については、`CLAUDE_CODE_MAX_OUTPUT_TOKENS` を参照してください。設定されておらず思考が有効な場合、[適応的推論](/docs/ja/model-config#adjust-effort-level) を持つモデルは独自の思考深度を選択し、他のモデルはキャップを使用します。Anthropic API で思考を無効にするには `0` に設定します。ただし、思考をオフにできない Opus 5.5 および Fable モデルは除きます。[サードパーティプロバイダー](/docs/ja/third-party-integrations) では、`0` は代わりに `thinking` パラメーターを省略します。Anthropic API で思考がオフの場合、Claude Code は、Opus 5 など、[その組み合わせを受け入れない](/docs/ja/errors#effort-isnt-available-with-thinking-turned-off) とわかっているモデルに、より高いレベルではなく努力 `high` を送信します。Claude Code は、適応的推論モデルの非ゼロ値を無視します。ただし、`CLAUDE_CODE_DISABLE_ADAPTIVE_THINKING` が適応的推論をオフにするモデルを除きます                                                                                                                                                                       |
+| `MAX_THINKING_TOKENS`                                   | [拡張思考](https://platform.claude.com/docs/en/build-with-claude/extended-thinking) の固定トークン予算。Claude Code はそれを要求の最大出力トークンの 1 トークン下でキャップし、1,024 未満にはしません。[`CLAUDE_CODE_MAX_OUTPUT_TOKENS`](/docs/ja/model-config#adjust-effort-level) でそのリミットを設定する方法を参照してください。設定されていない場合、[適応的推論](/docs/ja/model-config#adjust-effort-level) を持つモデルは独自の思考深度を選択し、他のモデルはキャップを使用します。Anthropic API で思考を無効にするには `0` に設定します。Opus 5.5 および Fable モデルを除き、思考をオフにすることはできません。[サードパーティプロバイダー](/docs/ja/third-party-integrations) では、`0` は代わりに `thinking` パラメーターを省略します。Anthropic API で思考がオフの場合、Claude Code は、Opus 5 などの [その組み合わせを受け入れないモデル](/docs/ja/errors#effort-isnt-available-with-thinking-turned-off) に努力 `high` を送信します。Claude Code は、適応的推論モデルの非ゼロ値を無視します。ただし、`CLAUDE_CODE_DISABLE_ADAPTIVE_THINKING` が適応的推論をオフにするモデルを除きます                                                                                                                                                          |
 | `MCP_CLIENT_SECRET`                                     | [事前設定された認証情報](/docs/ja/mcp#use-pre-configured-oauth-credentials) が必要な MCP サーバーの OAuth クライアントシークレット。`--client-secret` でサーバーを追加するときに対話的なプロンプトを回避します                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
 | `MCP_CONNECTION_NONBLOCKING`                            | MCP サーバーが最初のクエリの前に接続するのを待機するかどうかを制御します。MCP スタートアップはデフォルトで非ブロッキングです：サーバーはバックグラウンドで接続し、完了するとそれらのツールが利用可能になります。最初のクエリの前にサーバーが接続するのを待機するには `0` に設定します。[`alwaysLoad: true`](/docs/ja/mcp#exempt-a-server-from-deferral) で設定されたサーバーは、[検出キャッシュ](/docs/ja/mcp#server-status-detail) から提供される場合を除き、関係なくスタートアップを待機させます。ツールは最初のプロンプトが構築されるときに存在する必要があります。非対話モード（`-p`）で `--input-format stream-json` がない場合、Claude Code は最初のターンの前に保留中のサーバーを待機します。[`--mcp-config`](/docs/ja/cli-reference#cli-flags) を明示的に渡すと、待機にはより長いデッドラインがあります。キャッシュされたサーバーの例外については、そのフラグのエントリを参照してください                                                                                                                                                                                                                                                                                                                                                                                      |
```

</details>

<details>
<summary>feature-availability-ja.md</summary>

```diff
diff --git a/docs-ja/pages/feature-availability-ja.md b/docs-ja/pages/feature-availability-ja.md
index 542cf4b..6bc29b3 100644
--- a/docs-ja/pages/feature-availability-ja.md
+++ b/docs-ja/pages/feature-availability-ja.md
@@ -39,5 +39,4 @@ Claude Code CLI とローカルで実行されるすべてのものは、すべ
 これらにはプロバイダー固有の違いがあります：
 
-* **CLAUDE.md メモリ**：`CLAUDE.md` ファイルはすべてのプロバイダーでロードされます。[`AGENTS.md` ファイル](/docs/ja/memory#agents-md)をプロジェクト指示として読み込むには、[機能フラグを取得](/docs/ja/env-vars#features-that-need-feature-flag-fetching)するセッションも必要です
 * **MCP サーバー**：[claude.ai からのコネクタ](/docs/ja/mcp#use-mcp-servers-from-claude-ai)は、claude.ai サブスクリプションがアクティブな認証方法である場合にのみロードされます。[ツール検索](/docs/ja/mcp#configure-tool-search)は `ANTHROPIC_BASE_URL` がファーストパーティ以外のホストを指している場合、デフォルトでオフになり、Google Cloud の Agent Platform の Claude 4.5 世代より前のモデルまたは Microsoft Foundry の [Azure でホストされているデプロイメント](https://platform.claude.com/docs/en/build-with-claude/claude-in-microsoft-foundry#hosting-options)ではサポートされていません
 * **Subagents**：組み込みの [Explore subagent](/docs/ja/sub-agents#built-in-subagents)は、Claude API で継承されたモデルを Opus に制限し、他のプロバイダー（Claude Platform on AWS を含む）では直接メイン会話のモデルを継承します
```

</details>

<details>
<summary>glossary-ja.md</summary>

```diff
diff --git a/docs-ja/pages/glossary-ja.md b/docs-ja/pages/glossary-ja.md
index 8e82424..a4a1cd3 100644
--- a/docs-ja/pages/glossary-ja.md
+++ b/docs-ja/pages/glossary-ja.md
@@ -17,5 +17,5 @@
 </h3>
 
-AI コーディングエージェント向けに作成するプロジェクト指示のマークダウンファイル。リポジトリに AGENTS.md があり、[CLAUDE.md](#claude-md) がない場合、Claude はこれをプロジェクト指示として読み込みます。別のファイルを追加する必要はありません。`/config` の **Project instructions** 設定を変更して、Claude が両方のファイルを読み込むか、CLAUDE.md のみを読み込むかを指定できます。AGENTS.md を直接読み込むには、Claude Code v2.1.277 以降がセッション内で機能フラグを取得する必要があります。その他のバージョンでは、CLAUDE.md からインポートしてください。
+AI コーディングエージェント向けに作成するプロジェクト指示のマークダウンファイル。リポジトリに AGENTS.md があり、[CLAUDE.md](#claude-md) がない場合、Claude はこれをプロジェクト指示として読み込みます。別のファイルを追加する必要はありません。`/config` の **Project instructions** 設定を変更して、Claude が両方のファイルを読み込むか、CLAUDE.md のみを読み込むかを指定できます。AGENTS.md を直接読み込むには、Claude Code v2.1.277 以降が必要です。一部のセッションでは Claude が [AGENTS.md を読み込めない](/docs/ja/memory#when-agents-md-support-is-unavailable) ため、代わりに [CLAUDE.md からインポート](/docs/ja/memory#share-one-file-with-other-coding-tools) してください。
 
 詳細情報: [AGENTS.md](/docs/ja/memory#agents-md)
```

</details>

<details>
<summary>mcp-ja.md</summary>

```diff
diff --git a/docs-ja/pages/mcp-ja.md b/docs-ja/pages/mcp-ja.md
index ed7d06a..00110e1 100644
--- a/docs-ja/pages/mcp-ja.md
+++ b/docs-ja/pages/mcp-ja.md
@@ -1563,5 +1563,7 @@ MCP サーバーを構築している場合、ツール検索が有効になる
 * サーバーが提供する主な機能
 
-Claude Code はツール説明とサーバー指示を各 2KB で切り詰めます。切り詰めを避けるために簡潔に保ち、重要な詳細は最初の方に配置してください。
+Claude Code はツール説明とサーバー指示を各 2,048 文字でデフォルトで切り詰めます。簡潔に保ち、重要な詳細は最初の方に配置してください。
+
+セッション内のすべての MCP サーバーの上限を変更するには、[`CLAUDE_CODE_MAX_MCP_DESCRIPTION_LENGTH`](/docs/ja/env-vars#variables)を文字数に設定します。この変数には Claude Code v2.1.280 以降が必要です。
 
 <h3 id="configure-tool-search">
```

</details>

<details>
<summary>monitoring-usage-ja.md</summary>

```diff
diff --git a/docs-ja/pages/monitoring-usage-ja.md b/docs-ja/pages/monitoring-usage-ja.md
index dda0cf9..695f437 100644
--- a/docs-ja/pages/monitoring-usage-ja.md
+++ b/docs-ja/pages/monitoring-usage-ja.md
@@ -1222,4 +1222,9 @@ API リクエストが複数の試行後に失敗した場合、1 回ログさ
 * `num_cancelled`: 完了前にキャンセルされたカウント
 * `total_duration_ms`: すべてのマッチするフックのウォールクロック期間
+* `stdout_chars`: 成功したマッチするフック全体の stdout の総文字数。Claude Code v2.1.280 以降が必要
+* `additional_context_chars`: マッチするフックによって返された `additionalContext` の総文字数。Claude Code v2.1.280 以降が必要
+* `system_message_chars`: マッチするフックによって返された `systemMessage` の総文字数。Claude Code v2.1.280 以降が必要
+* `initial_user_message_chars`: マッチするフックによって返された `initialUserMessage` の総文字数。Claude Code v2.1.280 以降が必要
+* `num_outputs_persisted`: [10,000 文字キャップ](/docs/ja/hooks#json-output) を超えたフック出力の数。Claude Code がファイルに保存。Claude Code v2.1.280 以降が必要
 * `managed_only`: 管理ポリシーフックのみが許可される場合は `"true"`
 * `hook_source`: `"policySettings"` または `"merged"`
```

</details>

*...以降省略*

</details>


<details>
<summary>2026-09-23</summary>

**変更ファイル:**

```
 docs-ja/pages/admin-setup-ja.md                    |   2 +-
 docs-ja/pages/advisor-ja.md                        |  28 +-
 docs-ja/pages/agent-teams-ja.md                    |   4 -
 docs-ja/pages/amazon-bedrock-ja.md                 |  18 +-
 docs-ja/pages/artifacts-ja.md                      |  14 +-
 docs-ja/pages/authentication-ja.md                 |   4 +-
 docs-ja/pages/changelog.md                         | 117 ++++
 docs-ja/pages/claude-code-on-the-web-ja.md         |   4 +-
 docs-ja/pages/claude-directory-ja.md               |  28 +-
 docs-ja/pages/claude-platform-on-aws-ja.md         |   2 +-
 docs-ja/pages/claude-projects-ja.md                |  66 +-
 docs-ja/pages/cli-reference-ja.md                  | 164 ++---
 docs-ja/pages/cloud-environments-ja.md             |   4 +-
 docs-ja/pages/commands-ja.md                       | 243 +++----
 docs-ja/pages/communications-kit-ja.md             |  16 +-
 docs-ja/pages/context-window-ja.md                 |   3 +-
 docs-ja/pages/costs-ja.md                          |  58 +-
 docs-ja/pages/desktop-ja.md                        |   4 +-
 docs-ja/pages/desktop-linux-ja.md                  |   2 +-
 docs-ja/pages/discover-plugins-ja.md               |   6 +-
 docs-ja/pages/env-vars-ja.md                       | 598 ++++++++---------
 docs-ja/pages/errors-ja.md                         | 168 ++++-
 docs-ja/pages/fast-mode-ja.md                      |   9 +-
 docs-ja/pages/features-overview-ja.md              | 214 +++---
 docs-ja/pages/fullscreen-ja.md                     |   4 +-
 docs-ja/pages/github-actions-ja.md                 |   2 +-
 docs-ja/pages/glossary-ja.md                       |  12 +
 docs-ja/pages/google-vertex-ai-ja.md               |   6 +-
 docs-ja/pages/headless-ja.md                       |   5 +-
 docs-ja/pages/how-claude-code-works-ja.md          |  34 +-
 docs-ja/pages/interactive-mode-ja.md               |  14 +-
 docs-ja/pages/keybindings-ja.md                    | 284 ++++----
 docs-ja/pages/large-codebases-ja.md                |   2 +-
 docs-ja/pages/llm-gateway-protocol-ja.md           |   1 +
 docs-ja/pages/llm-gateway-rollout-ja.md            |  21 +-
 docs-ja/pages/managed-settings-ja.md               |   1 +
 docs-ja/pages/memory-ja.md                         |  41 +-
 docs-ja/pages/monitoring-usage-ja.md               |   3 +-
 docs-ja/pages/network-config-ja.md                 |   1 +
 docs-ja/pages/output-styles-ja.md                  | 166 +++--
 docs-ja/pages/overview-ja.md                       |   1 +
 docs-ja/pages/permission-modes-ja.md               |  73 ++-
 docs-ja/pages/permissions-ja.md                    |  12 +-
 docs-ja/pages/plugin-evals-ja.md                   |   2 +-
 docs-ja/pages/plugin-marketplaces-ja.md            |  18 +-
 docs-ja/pages/plugins-reference-ja.md              | 234 ++++---
 docs-ja/pages/prompt-caching-ja.md                 |  24 +-
 docs-ja/pages/prompt-library-ja.md                 |   2 +-
 docs-ja/pages/quickstart-ja.md                     |   3 +-
 docs-ja/pages/remote-control-ja.md                 |   2 +-
 docs-ja/pages/security-guidance-ja.md              |   8 +-
 .../pages/self-hosted-environments-deploy-ja.md    |  10 +-
 docs-ja/pages/sessions-ja.md                       |   8 +-
 docs-ja/pages/settings-example-ja.md               |  10 +-
 docs-ja/pages/settings-ja.md                       |   6 +-
 docs-ja/pages/settings-reference-ja.md             | 279 ++++----
 docs-ja/pages/skills-ja.md                         | 728 ++++++++++++++-------
 docs-ja/pages/statusline-ja.md                     |   2 +-
 docs-ja/pages/sub-agents-ja.md                     | 102 +--
 docs-ja/pages/terminal-config-ja.md                |  26 +-
 docs-ja/pages/third-party-integrations-ja.md       |   4 +-
 docs-ja/pages/troubleshoot-install-ja.md           | 230 +++----
 docs-ja/pages/troubleshooting-ja.md                |   6 +-
 docs-ja/pages/ultrareview-ja.md                    |  13 +-
 docs-ja/pages/vs-code-ja.md                        | 207 +++---
 docs-ja/pages/workflows-ja.md                      |   6 +-
 66 files changed, 2630 insertions(+), 1759 deletions(-)
```

<details>
<summary>admin-setup-ja.md</summary>

```diff
diff --git a/docs-ja/pages/admin-setup-ja.md b/docs-ja/pages/admin-setup-ja.md
index fc8322d..86f1c19 100644
--- a/docs-ja/pages/admin-setup-ja.md
+++ b/docs-ja/pages/admin-setup-ja.md
@@ -168,5 +168,5 @@ Team、Enterprise、Claude API、およびクラウドプロバイダープラ
 * [クイックスタート](/docs/ja/quickstart): インストールからプロジェクトの操作まで、最初のセッションのウォークスルー
 * [一般的なワークフロー](/docs/ja/common-workflows): コードレビュー、リファクタリング、デバッグなどの日常的なタスクのパターン
-* [Claude 101](https://anthropic.skilljar.com/claude-101) と [Claude Code in Action](https://anthropic.skilljar.com/claude-code-in-action): Anthropic Academy の自習型コース
+* [Claude Code 101](https://academy.claude.com/courses/claude-code-101) と [Claude Code in Action](https://academy.claude.com/courses/claude-code-in-action): [Claude Academy](https://academy.claude.com/) の無料の自習型コース
 
 ログインの問題については、開発者に [認証のトラブルシューティング](/docs/ja/troubleshoot-install#login-and-authentication) を指してください。最も一般的な修正は次のとおりです。
```

</details>

<details>
<summary>advisor-ja.md</summary>

```diff
diff --git a/docs-ja/pages/advisor-ja.md b/docs-ja/pages/advisor-ja.md
index 8291257..391e629 100644
--- a/docs-ja/pages/advisor-ja.md
+++ b/docs-ja/pages/advisor-ja.md
@@ -57,5 +57,5 @@ advisor モデルは 3 つの方法で設定できます。
 * `/advisor off` を実行してそれをオフにします。
 
-Claude Code は、組織の [`availableModels`](/docs/ja/model-config#restrict-model-selection)許可リストが除外した保存済み advisor を呼び出しません。advisor を使用するには、`/advisor` で許可されたモデルを選択してください。Claude Code は、現在のメインモデルがサポートしていない advisor を引き続き保存します。その advisor は、[`/model`](/docs/ja/model-config#setting-your-model)で[互換性のあるメインモデル](#choose-an-advisor-model)に切り替えた後にアクティブになります。
+Claude Code は、組織の [`availableModels`](/docs/ja/model-config#restrict-model-selection)許可リストが除外した保存済み advisor を呼び出しません。advisor を使用するには、`/advisor` で許可されたモデルを選択してください。Claude Code は、現在のメインモデルがサポートしていない advisor を引き続き保存します。その advisor は、[`/model`](/docs/ja/model-config#setting-your-model)で[互換性のあるメインモデル](#choose-an-advisor-model)に切り替えた後にアクティブになります。API がすでに現在の会話で保存済み advisor を拒否した場合、モデルを切り替えた後でも、`/clear` または `/compact` まで、それはオフのままです。
 
 一部のプランでは、Fable を advisor として使用する場合、Fable の使用を使用クレジットに請求することへの 1 回限りの[同意](/docs/ja/model-config#fable-and-usage-credits)も必要です。その同意を与える前に `/advisor fable` が何をするかについては、[Fable advisor と使用クレジット](#fable-advisor-and-usage-credits)を参照してください。
@@ -98,18 +98,18 @@ Claude Code はそのセッションの `advisorModel` 設定の代わりにフ
 アドバイザーはメインモデル以上の能力を持つ必要があります。各メインモデルで受け入れられるアドバイザーは以下の通りです。
 
-| メインモデル                | 受け入れられるアドバイザー              | 注記                                                                                    |
-| --------------------- | -------------------------- | ------------------------------------------------------------------------------------- |
-| Haiku 4.5             | Fable、Opus、Sonnet          | Haiku はアドバイザーを呼び出すことはできますが、アドバイザーとして機能することはできません                                      |
-| Sonnet 4.6            | Fable、Opus、Sonnet          |                                                                                       |
-| Sonnet 5              | Fable、Opus 4.7 以降、Sonnet 5 | Sonnet 4.6 アドバイザーは拒否され、Opus 4.6 アドバイザーを使用したリクエストは API エラーで失敗します                       |
-| Opus 4.6              | Fable、Opus、Sonnet 5        | Sonnet 4.6 アドバイザーは拒否されます                                                              |
-| Opus 4.7 または Opus 4.8 | Fable、および Opus 4.7 以降      | Opus 4.6 または Sonnet アドバイザーは拒否されます                                                     |
-| Opus 5                | Fable、Opus 5               | Opus 4.6 または Sonnet アドバイザーは拒否され、Opus 4.7 または Opus 4.8 アドバイザーを使用したリクエストは API エラーで失敗します |
-| Fable 5               | Fable 5.1 または Fable 5      | Opus または Sonnet アドバイザーは拒否されます                                                         |
-| Fable 5.1             | Fable 5.1                  | Opus または Sonnet アドバイザーは拒否され、Fable 5 アドバイザーを使用したリクエストは API エラーで失敗します                   |
+| メインモデル                | 受け入れられるアドバイザー              | 注記                                                                       |
+| --------------------- | -------------------------- | ------------------------------------------------------------------------ |
+| Haiku 4.5             | Fable、Opus、Sonnet          | Haiku はアドバイザーを呼び出すことはできますが、アドバイザーとして機能することはできません                         |
+| Sonnet 4.6            | Fable、Opus、Sonnet          |                                                                          |
+| Sonnet 5              | Fable、Opus 4.7 以降、Sonnet 5 | Sonnet 4.6 アドバイザーは拒否され、Opus 4.6 アドバイザーを使用したリクエストは API エラーで失敗します          |
+| Opus 4.6              | Fable、Opus、Sonnet 5        | Sonnet 4.6 アドバイザーは拒否されます                                                 |
```

</details>

<details>
<summary>agent-teams-ja.md</summary>

```diff
diff --git a/docs-ja/pages/agent-teams-ja.md b/docs-ja/pages/agent-teams-ja.md
index fd98969..7974b36 100644
--- a/docs-ja/pages/agent-teams-ja.md
+++ b/docs-ja/pages/agent-teams-ja.md
@@ -15,8 +15,4 @@
 チームを設定する前に、より軽量なオプションで十分かどうかを確認してください。[Subagents](/docs/ja/sub-agents) は単一セッション内で動作し、[クロスセッションメッセージング](/docs/ja/cross-session-messaging) を使用すると Claude は自分で実行するセッション間で検出結果を渡すことができます。
 
-<Note>
-  このページは v2.1.178 時点のエージェントチームについて説明しています。`CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS` が設定されている場合、チームメンバーのスポーンにはセットアップステップが不要になり、セッション終了時にクリーンアップが自動的に行われます。v2.1.178 より前は、最初にチームを作成して名前を付けるよう Claude に依頼し、Claude は `TeamCreate` と `TeamDelete` ツールを使用してセットアップと削除を行いました。両方のツールはもう存在しません。Agent ツールの `team_name` 入力は受け入れられますが無視され、`TaskCreated`、`TaskCompleted`、および `TeammateIdle` [hook ペイロード](/docs/ja/hooks#taskcreated)の `team_name` フィールドはセッション派生名を含み、非推奨です。
-</Note>
-
 <h2 id="when-to-use-agent-teams">
   エージェントチームを使用する場合
```

</details>

<details>
<summary>amazon-bedrock-ja.md</summary>

```diff
diff --git a/docs-ja/pages/amazon-bedrock-ja.md b/docs-ja/pages/amazon-bedrock-ja.md
index b1b8203..ec20931 100644
--- a/docs-ja/pages/amazon-bedrock-ja.md
+++ b/docs-ja/pages/amazon-bedrock-ja.md
@@ -292,5 +292,5 @@ Claude Code で Amazon Bedrock を有効にする場合、以下の点に注意
 これらの環境変数を特定の Amazon Bedrock モデル ID に設定してください。
 
-`ANTHROPIC_DEFAULT_OPUS_MODEL` がない場合、Amazon Bedrock の `opus` エイリアスは Opus 5 に解決され、`ANTHROPIC_DEFAULT_SONNET_MODEL` がない場合、`sonnet` エイリアスは Sonnet 4.5 に解決されます。この例では各エイリアスを特定のバージョンにピンしています。
+`ANTHROPIC_DEFAULT_OPUS_MODEL` がない場合、Amazon Bedrock の `opus` エイリアスは Opus 5.5 に解決され、`ANTHROPIC_DEFAULT_SONNET_MODEL` がない場合、`sonnet` エイリアスは Sonnet 4.5 に解決されます。この例では各エイリアスを特定のバージョンにピンしています。
 
 ```bash theme={null}
@@ -304,8 +304,8 @@ export ANTHROPIC_DEFAULT_HAIKU_MODEL='us.anthropic.claude-haiku-4-5-20251001-v1:
 組み込みデフォルトモデルを保持し、優先プレフィックスのみを変更するには、ピンの代わりに [`ANTHROPIC_BEDROCK_REGION_PREFIX`](#cross-region-inference-profile-prefixes) を設定してください。`opus` エイリアスが解決する内容の違いを示します。
 
-| 設定内容                                                          | `opus` エイリアスが解決する内容                                |
-| :------------------------------------------------------------ | :------------------------------------------------- |
-| `ANTHROPIC_DEFAULT_OPUS_MODEL='us.anthropic.claude-opus-4-8'` | `us.anthropic.claude-opus-4-8`、ピンした正確な ID          |
-| `ANTHROPIC_BEDROCK_REGION_PREFIX=eu`                          | `eu.anthropic.claude-opus-5`、優先プレフィックス付きの組み込みデフォルト |
+| 設定内容                                                          | `opus` エイリアスが解決する内容                                  |
+| :------------------------------------------------------------ | :--------------------------------------------------- |
+| `ANTHROPIC_DEFAULT_OPUS_MODEL='us.anthropic.claude-opus-4-8'` | `us.anthropic.claude-opus-4-8`、ピンした正確な ID            |
+| `ANTHROPIC_BEDROCK_REGION_PREFIX=eu`                          | `eu.anthropic.claude-opus-5-5`、優先プレフィックス付きの組み込みデフォルト |
 
 現在および従来のモデル ID については、[Models overview](https://platform.claude.com/docs/en/about-claude/models/overview) を参照してください。ピン環境変数の完全なリストについては、[Model configuration](/docs/ja/model-config#pin-models-for-third-party-deployments) を参照してください。
@@ -315,5 +315,5 @@ export ANTHROPIC_DEFAULT_HAIKU_MODEL='us.anthropic.claude-haiku-4-5-20251001-v1:
 | モデルタイプ   | デフォルトモデル                                                                    |
 | :------- | :-------------------------------------------------------------------------- |
-| プライマリモデル | Opus 5、例えば `us-*` リージョンの `us.anthropic.claude-opus-5`                       |
+| プライマリモデル | Opus 5.5、例えば `us-*` リージョンの `us.anthropic.claude-opus-5-5`                   |
 | 小型/高速モデル | Sonnet 4.5、例えば `us-*` リージョンの `us.anthropic.claude-sonnet-4-5-20250929-v1:0` |
```

</details>

<details>
<summary>artifacts-ja.md</summary>

```diff
diff --git a/docs-ja/pages/artifacts-ja.md b/docs-ja/pages/artifacts-ja.md
index 77a117c..1c2771d 100644
--- a/docs-ja/pages/artifacts-ja.md
+++ b/docs-ja/pages/artifacts-ja.md
@@ -347,11 +347,11 @@ UI、画面フロー、ランディングページ、またはポスターをモ
 アーティファクトには、以下のすべての条件が必要です。いずれかが満たされていない場合、Claude はローカル HTML ファイルを書き込むか、公開できないと言います。
 
-| 要件        | 利用可能な場合                                                                                                                                                                                                                                                                                                                                                             |
-| :-------- | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
-| プラン       | Pro、Max、Team、または Enterprise。Pro および Max プランでは、アーティファクトはあなたにプライベートであり、共有するまで管理者管理は適用されません。Team プランでは、アーティファクトはデフォルトで有効です。Enterprise プランでは、Owner が claude.ai 管理設定で[有効にします](#manage-artifacts-for-your-organization)。                                                                                                                                                  |
-| 認証        | セッションは claude.ai アカウントでバックアップされています。CLI またはデスクトップアプリで `/login` でサインインしてください。Claude Tag セッションはエージェントの ID を通じてサインインするため、追加の手順は不要です。API キー、[ゲートウェイトークン](/docs/ja/llm-gateway)、またはクラウドプロバイダー認証情報を使用するセッションは公開できません。                                                                                                                                                          |
-| モデルプロバイダー | Anthropic API。[Amazon Bedrock](/docs/ja/amazon-bedrock)、[Google Cloud の Agent Platform](/docs/ja/google-vertex-ai)、または [Microsoft Foundry](/docs/ja/microsoft-foundry) では利用できません。                                                                                                                                                                                                  |
-| 組織ポリシー    | カスタマー管理暗号化キー（CMEK）、HIPAA、および [Zero Data Retention](/docs/ja/zero-data-retention) は組織で有効になっていません。                                                                                                                                                                                                                                                                         |
-| サーフェス     | Claude Code CLI バージョン 2.1.183 以降、または Claude デスクトップアプリバージョン 1.13576.0 以降。[Claude Tag](https://claude.com/docs/claude-tag/overview) セッションは、Claude Tag とアーティファクトの両方が組織で有効になっている場合、アーティファクトを公開することもできます。[Agent SDK](/docs/ja/agent-sdk/overview)、GitHub Action、MCP サーバーコンテキストではデフォルトでオフになっており、[`CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC`](/docs/ja/env-vars) が設定されている場合もオフになります。 |
+| 要件        | 利用可能な場合                                                                                                                                                                                                                                                                                                                                            |
+| :-------- | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
+| プラン       | Pro、Max、Team、または Enterprise。Pro および Max プランでは、アーティファクトはあなたにプライベートであり、共有するまで管理者管理は適用されません。Team プランでは、アーティファクトはデフォルトで有効です。Enterprise プランでは、Owner が claude.ai 管理設定で[有効にします](#manage-artifacts-for-your-organization)。                                                                                                                                 |
+| 認証        | セッションは claude.ai アカウントでバックアップされています。CLI またはデスクトップアプリで `/login` でサインインしてください。Claude Tag セッションはエージェントの ID を通じてサインインするため、追加の手順は不要です。API キー、[ゲートウェイトークン](/docs/ja/llm-gateway)、またはクラウドプロバイダー認証情報を使用するセッションは公開できません。                                                                                                                                         |
+| モデルプロバイダー | Anthropic API。[Amazon Bedrock](/docs/ja/amazon-bedrock)、[Google Cloud の Agent Platform](/docs/ja/google-vertex-ai)、または [Microsoft Foundry](/docs/ja/microsoft-foundry) では利用できません。                                                                                                                                                                                 |
+| 組織ポリシー    | カスタマー管理暗号化キー（CMEK）、HIPAA、および [Zero Data Retention](/docs/ja/zero-data-retention) は組織で有効になっていません。                                                                                                                                                                                                                                                        |
+| サーフェス     | Claude Code CLI、または Claude デスクトップアプリバージョン 1.13576.0 以降。[Claude Tag](https://claude.com/docs/claude-tag/overview) セッションは、Claude Tag とアーティファクトの両方が組織で有効になっている場合、アーティファクトを公開することもできます。[Agent SDK](/docs/ja/agent-sdk/overview)、GitHub Action、MCP サーバーコンテキストではデフォルトでオフになっており、[`CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC`](/docs/ja/env-vars) が設定されている場合もオフになります。 |
 
 <h2 id="disable-artifacts">
```

</details>

<details>
<summary>authentication-ja.md</summary>

```diff
diff --git a/docs-ja/pages/authentication-ja.md b/docs-ja/pages/authentication-ja.md
index 5807b96..840e5d8 100644
--- a/docs-ja/pages/authentication-ja.md
+++ b/docs-ja/pages/authentication-ja.md
@@ -54,6 +54,6 @@ Claude Code は、セットアップに応じて複数の認証方法をサポ
 [Claude for Teams](https://claude.com/pricing?utm_source=claude_code\&utm_medium=docs\&utm_content=authentication_teams#team-&-enterprise) と [Claude for Enterprise](https://anthropic.com/contact-sales?utm_source=claude_code\&utm_medium=docs\&utm_content=authentication_enterprise) は、Claude Code を使用する組織に最適なエクスペリエンスを提供します。チームメンバーは Claude Code と Web 上の Claude の両方にアクセスでき、一元化された請求とチーム管理が可能です。
 
-* **Claude for Teams**: コラボレーション機能、管理ツール、請求管理を備えたセルフサービスプラン。小規模なチームに最適です。
-* **Claude for Enterprise**: SSO、ドメインキャプチャ、ロールベースの権限、コンプライアンス API、および組織全体の Claude Code 設定のための管理ポリシー設定を追加します。セキュリティとコンプライアンス要件を持つ大規模な組織に最適です。
+* **Claude for Teams**: コラボレーション機能、管理ツール、SSO、請求管理、および組織全体の Claude Code 設定のための [サーバー管理設定](/docs/ja/server-managed-settings)を備えたセルフサービスプラン。小規模なチームに最適です。
+* **Claude for Enterprise**: ドメインキャプチャ、ロールベースの権限、およびコンプライアンス API を追加します。セキュリティとコンプライアンス要件を持つ大規模な組織に最適です。
 
 <Steps>
```

</details>

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index dc067eb..c970aeb 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,121 @@
 # Changelog
 
+## 2.1.280
+
+- Added Claude Opus 5.5 (`claude-opus-5-5`), now the default Opus model — 1M context, $4/$20 per Mtok with $0.20/Mtok cache reads
+- Added mouse support to more lists in fullscreen mode: the wheel scrolls the `/skills` list, and a skill's state options in `/plugin` can be clicked
+- Added `CLAUDE_CODE_MAX_MCP_DESCRIPTION_LENGTH` to change the 2,048-character cap on MCP tool descriptions and server instructions for every MCP server in the session
+- Added hook output sizes and the number of oversized outputs saved to a file to the `hook_execution_complete` OpenTelemetry event
+- Fixed writes through a symlinked path being judged by their in-tree spelling: the prompt names where the write lands, and `acceptEdits`, allow rules and auto mode no longer approve one landing outside
+- Fixed auto mode retrying an action over and over when a safety check declined to review it; the action is now denied once, noting that retrying won't help
+- Fixed auto mode denying actions over and over without pause when a safety check gave no answer; retries now back off, and the turn stops with a message after ten in a row
+- Fixed Write calls failing validation when a model sends `path`, `file_text`, `file_content` or a stray `description` instead of `file_path` and `content`
+- Fixed Ctrl+C or Ctrl+D pressed twice in most dialogs (`/model`, `/effort`, `/config`, `/status`, `/usage`, `/plugin`, `/sandbox`, `/permissions`, `/artifacts`, `/mobile`, `/login`, `/upgrade`, `/usage-credits`, `/install-github-app`, `/setup-bedrock`, `/setup-vertex`) quitting Claude Code instead of closing the dialog
+- Fixed a click that only brought the terminal window to the front also triggering the item under the pointer — in search pickers, tab bars, agent/workflow rows, slash-command links and suggestion dropdowns
+- Fixed a stray `n` closing dialogs and a stray `y` confirming them; Enter and Esc accept and cancel (bind `y`/`n` to `confirm:yes`/`confirm:no` in `keybindings.json` to restore)
+- Fixed text fields in dialogs losing a typed letter, digit or Space to a keybinding on that key
+- Fixed the prompt line staying scrambled on Windows terminals after invisible characters were removed on Enter; the screen is now repainted so you review the exact text that will be sent
+- Fixed the invisible-character cleanup removing the zero-width non-joiner that Persian and Arabic text uses to attach a suffix to a Latin word or number, such as the plural of "PDF"
+- Fixed voice dictation not stopping on Ctrl+C (the prompt cleared but the microphone kept recording), Esc not cancelling while a transcript was processing, and held Space starting dictation from the transcript view and vim NORMAL mode
+- Fixed a model switch made from a host app (Claude Desktop, VS Code, SDK) while Claude is working causing a prompt-cache miss on the next prompt
+- Fixed resumed fork subagents rebuilding their tool list instead of re-sending the one they first used, which broke prompt caching for that agent
+- Fixed subagent hand-back messages showing an internal provenance preamble when expanded outside verbose mode
+- Fixed `installed_plugins.json` keeping the install-time commit after updating a plugin from a GitHub repository or git URL that tracks a branch or tag
+- Fixed skills in `~/.claude/skills/` being moved to `~/.claude/skills/.trash/` when a `manifest.json` in that folder listed their names
+- Fixed the session feedback survey showing no hover highlight on light and ANSI themes
```

</details>

<details>
<summary>claude-code-on-the-web-ja.md</summary>

```diff
diff --git a/docs-ja/pages/claude-code-on-the-web-ja.md b/docs-ja/pages/claude-code-on-the-web-ja.md
index 5fdacff..3c4211b 100644
--- a/docs-ja/pages/claude-code-on-the-web-ja.md
+++ b/docs-ja/pages/claude-code-on-the-web-ja.md
@@ -251,7 +251,7 @@ Claude がすでにメッセージを読んでいる場合、それは会話に
 クラウドセッションは[組み込みコマンド](/docs/ja/commands)をサポートしており、テキスト出力を生成します。ターミナルインターフェイスでのみ実行されるコマンド（`/plugin` や `/resume` など）は利用できません。ターミナルでピッカーまたはパネルを開くコマンドはクラウドセッションで異なる動作をします：
 
-* **`/model`、`/effort`、`/color`、`/rename`**：ターミナルピッカーまたはスライダーを開く代わりに、引数として値を渡します。例えば `/model sonnet` のように使用します。引数形式はセッションの環境で Claude Code v2.1.205 以降が必要であり、各コマンドの[利用可能性に関する注記](/docs/ja/commands#all-commands)に従います。`/effort` はモデルの[起動デフォルト努力保持](/docs/ja/model-config#adjust-effort-level)が有効な場合は `Not applied` を報告します。
+* **`/model`、`/effort`、`/color`、`/rename`**：ターミナルピッカーまたはスライダーを開く代わりに、引数として値を渡します。例えば `/model sonnet` のように使用します。引数形式はセッションの環境で Claude Code v2.1.205 以降が必要であり、各コマンドの[利用可能性に関する注記](/docs/ja/commands#all-commands)に従います。
 * **`/fast`**：アカウントで[利用可能な場合](/docs/ja/fast-mode#requirements)、セッションの[ファストモード](/docs/ja/fast-mode#use-fast-mode-in-cloud-sessions)を切り替えます。セッションの環境で Claude Code v2.1.271 以降が必要です。
-* **`/config`**：ウェブ上では、値を設定する代わりに Claude Code セクションの設定を開き、`key=value` を含むコマンド後のテキストは無視されます。クラウドセッションの設定を変更するには、[環境変数](/docs/ja/cloud-environments#set-environment-variables)を環境に設定するか、1 つのリポジトリを持つセッションでキーをそのリポジトリの `.claude/settings.json` にコミットします。[クラウドセッションの設定](/docs/ja/settings#settings-in-cloud-sessions)には各セッションが読み込むものが記載されています。
+* **`/config`**：ブラウザの claude.ai/code では、値を設定する代わりに Claude Code セクションの設定を開き、`key=value` を含むコマンド後のテキストは無視されます。クラウドセッションの設定を変更するには、[環境変数](/docs/ja/cloud-environments#set-environment-variables)を環境に設定するか、1 つのリポジトリを持つセッションでキーをそのリポジトリの `.claude/settings.json` にコミットします。[クラウドセッションの設定](/docs/ja/settings#settings-in-cloud-sessions)には各セッションが読み込むものが記載されています。
 
 コンテキスト管理の場合：
```

</details>

*...以降省略*

</details>


<details>
<summary>2026-09-22</summary>

**変更ファイル:**

```
 docs-ja/pages/artifacts-ja.md               |  18 +--
 docs-ja/pages/changelog.md                  |   1 -
 docs-ja/pages/claude-apps-gateway-ja.md     |   9 +-
 docs-ja/pages/claude-directory-ja.md        |  92 +++++++-------
 docs-ja/pages/desktop-ja.md                 |   2 +-
 docs-ja/pages/discover-plugins-ja.md        |   6 +-
 docs-ja/pages/fast-mode-ja.md               |  10 +-
 docs-ja/pages/interactive-mode-ja.md        |  17 ++-
 docs-ja/pages/keybindings-ja.md             |  40 +++---
 docs-ja/pages/llm-gateway-connect-ja.md     | 191 +++++++++++++++++-----------
 docs-ja/pages/llm-gateway-protocol-ja.md    |  33 +++++
 docs-ja/pages/managed-settings-ja.md        |  41 +++---
 docs-ja/pages/monitoring-usage-ja.md        |  94 +++++++++++---
 docs-ja/pages/network-config-ja.md          |   2 +-
 docs-ja/pages/security-guidance-ja.md       |   3 +-
 docs-ja/pages/server-managed-settings-ja.md |   2 +-
 docs-ja/pages/settings-reference-ja.md      |   2 +
 docs-ja/pages/vs-code-ja.md                 |  68 ++++++----
 18 files changed, 412 insertions(+), 219 deletions(-)
```

<details>
<summary>artifacts-ja.md</summary>

```diff
diff --git a/docs-ja/pages/artifacts-ja.md b/docs-ja/pages/artifacts-ja.md
index 0f1b4d4..77a117c 100644
--- a/docs-ja/pages/artifacts-ja.md
+++ b/docs-ja/pages/artifacts-ja.md
@@ -326,12 +326,12 @@ UI、画面フロー、ランディングページ、またはポスターをモ
 各アーティファクトは 1 つの自己完結したページです。Claude Code は公開するファイルを HTML ドキュメントシェルでラップし、厳密なコンテンツセキュリティポリシー（CSP）の下で提供します。これはページが実行できることを形作ります。
 
-| 制約         | 効果                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
-| :--------- | :----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
-| 外部リクエスト    | ページは Google Fonts からタイプフェイスを読み込むことができ、[4 つのパブリック CDN ホスト](#allowlist-the-viewer-domain)からスクリプトを読み込むことができます：cdnjs、Tailwind と jQuery CDN、および jsDelivr 上の `/npm/` などの選択されたパス。CSP はすべての外部画像とその他すべての外部スクリプト、スタイルシート、フォントをブロックし、`fetch`、XHR、WebSocket 呼び出しがページ自身のオリジンと Google Fonts ホストにのみ到達できるようにします。Claude はページが必要とするライブラリをこれらの CDN の 1 つから読み込み、その他すべての CSS と JavaScript をインライン化し、画像をデータ URI として埋め込みます。[コネクタ呼び出し](#pull-live-data-with-mcp-connectors)は claude.ai を通じて行われ、ネットワーク呼び出しを自身で実行します。 |
-| バックエンドなし   | アーティファクトは静的ページです。ビューアを自身で認証することはできません。                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
-| ダウンロード     | ページはダウンロードを自身で開始することはできません。ビューアがページが生成するファイルを保存できるようにするには、Claude はダウンロード機能を宣言します。[ファイルダウンロードを提供する](#offer-a-file-download)を参照してください。                                                                                                                                                                                                                                                                                                                                                       |
-| シングルページ    | 相対リンクは解決されません。ページと一緒に何もデプロイされていないためです。マルチセクションコンテンツの場合、Claude は個別ファイルではなくページ内アンカーを使用します。                                                                                                                                                                                                                                                                                                                                                                                                   |
-| ソースファイルタイプ | 公開されるファイルは `.html`、`.htm`、または `.md` である必要があり、UTF-8 として、またはバイトオーダーマークによってリトルエンディアン UTF-16 としてデコードできる必要があります。Markdown ファイルはスタイル付きドキュメントページとしてレンダリングされ、構文強調表示されたコードが含まれます。デコードできないファイル、または置換文字 `U+FFFD` を含むファイルは、[修正する行と列とともに拒否されます](/docs/ja/errors#the-source-file-is-not-valid-utf-8-text)。                                                                                                                                                                                                     |
-| レンダリングサイズ  | レンダリングされたページは 16 MiB 以下である必要があります。大きな埋め込み画像は、公開が失敗する場合の通常の原因です。                                                                                                                                                                                                                                                                                                                                                                                                                            |
+| 制約         | 効果                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
+| :--------- | :----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
+| 外部リクエスト    | ページは Google Fonts からタイプフェイスを読み込むことができ、[5 つのパブリック CDN ホスト](#allowlist-the-viewer-domain)からスクリプトを読み込むことができます：cdnjs、unpkg、Tailwind と jQuery CDN、および jsDelivr 上の `/npm/` などの選択されたパス。CSP はすべての外部画像とその他すべての外部スクリプト、スタイルシート、フォントをブロックし、`fetch`、XHR、WebSocket 呼び出しがページ自身のオリジンと Google Fonts ホストにのみ到達できるようにします。Claude はページが必要とするライブラリをこれらの CDN の 1 つから読み込み、その他すべての CSS と JavaScript をインライン化し、画像をデータ URI として埋め込みます。[コネクタ呼び出し](#pull-live-data-with-mcp-connectors)は claude.ai を通じて行われ、ネットワーク呼び出しを自身で実行します。 |
+| バックエンドなし   | アーティファクトは静的ページです。ビューアを自身で認証することはできません。                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
+| ダウンロード     | ページはダウンロードを自身で開始することはできません。ビューアがページが生成するファイルを保存できるようにするには、Claude はダウンロード機能を宣言します。[ファイルダウンロードを提供する](#offer-a-file-download)を参照してください。                                                                                                                                                                                                                                                                                                                                                             |
+| シングルページ    | 相対リンクは解決されません。ページと一緒に何もデプロイされていないためです。マルチセクションコンテンツの場合、Claude は個別ファイルではなくページ内アンカーを使用します。                                                                                                                                                                                                                                                                                                                                                                                                         |
+| ソースファイルタイプ | 公開されるファイルは `.html`、`.htm`、または `.md` である必要があり、UTF-8 として、またはバイトオーダーマークによってリトルエンディアン UTF-16 としてデコードできる必要があります。Markdown ファイルはスタイル付きドキュメントページとしてレンダリングされ、構文強調表示されたコードが含まれます。デコードできないファイル、または置換文字 `U+FFFD` を含むファイルは、[修正する行と列とともに拒否されます](/docs/ja/errors#the-source-file-is-not-valid-utf-8-text)。                                                                                                                                                                                                           |
+| レンダリングサイズ  | レンダリングされたページは 16 MiB 以下である必要があります。大きな埋め込み画像は、公開が失敗する場合の通常の原因です。                                                                                                                                                                                                                                                                                                                                                                                                                                  |
 
 アーティファクトを生成することは、他のレスポンスと同様に出力トークンを使用し、スタイル付きページはターミナルテキストと同じコンテンツよりもトークン集約的です。インライン CSS、インタラクティブコントロール用の JavaScript、特にデータ URI として埋め込まれた画像が主な要因です。アーティファクトのトークンコストを削減するには：
@@ -418,5 +418,5 @@ claude.ai のビューアは、サンドボックス化された `*.claudeuserco
 [Google Fonts](#improve-the-visual-design)からタイプフェイスを読み込むアーティファクトは、`fonts.googleapis.com` と `fonts.gstatic.com` もリクエストします。どちらのホストもオプションです。ブロックすると、アーティファクトはフォールバックタイプフェイスでレンダリングされます。フォントリクエストが即座に失敗するように、サイレントドロップではなく高速拒否でブロックして、ページの最初のレンダリングが遅延しないようにします。
 
-アーティファクトは、React やチャートパッケージなどの JavaScript ライブラリを `cdnjs.cloudflare.com`、`cdn.jsdelivr.net`、`cdn.tailwindcss.com`、`code.jquery.com` から読み込むことができ、他の外部ホストからは読み込めません。これらのホストをブロックすると、ライブラリに依存するアーティファクトの部分が機能しません。ブロックされたフォントとは異なり、ブロックされたライブラリにはフォールバックがありません。ブロックされたライブラリリクエストが即座に失敗するように、ここでも高速拒否でブロックして、タイムアウトするまでハングしないようにします。
+アーティファクトは、React やチャートパッケージなどの JavaScript ライブラリを `cdnjs.cloudflare.com`、`cdn.jsdelivr.net`、`cdn.tailwindcss.com`、`code.jquery.com`、および `unpkg.com` から読み込むことができ、他の外部ホストからは読み込めません。これらのホストをブロックすると、ライブラリに依存するアーティファクトの部分が機能しません。ブロックされたフォントとは異なり、ブロックされたライブラリにはフォールバックがありません。ブロックされたライブラリリクエストが即座に失敗するように、ここでも高速拒否でブロックして、タイムアウトするまでハングしないようにします。
```

</details>

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index 6d69d78..dc067eb 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -173,5 +173,4 @@
 - [VSCode] Fixed a rare case where text selected in a git-ignored file could be sent to Claude after the extension was unresponsive for several seconds
 - [VSCode] Fixed renaming a running session reverting to the generated name (regression in 2.1.269)
-- [VSCode] Fixed some claude.ai/code sessions opening in VS Code as an empty conversation with no messages
 - [VSCode] Fixed slash commands typed while Claude is responding being sent to the model as text instead of running once the response finishes
 - [VSCode] Fixed unreadable code in the plan preview and the Hooks and Permission rules dialogs with the High Contrast Light theme
```

</details>

<details>
<summary>claude-apps-gateway-ja.md</summary>

```diff
diff --git a/docs-ja/pages/claude-apps-gateway-ja.md b/docs-ja/pages/claude-apps-gateway-ja.md
index 438997b..2dbc080 100644
--- a/docs-ja/pages/claude-apps-gateway-ja.md
+++ b/docs-ja/pages/claude-apps-gateway-ja.md
@@ -173,5 +173,5 @@ Claude アプリゲートウェイは、開発者の Claude Code クライアン
     ```
 
-    ゲートウェイは、設定を読み取り、Postgres に接続してスキーママイグレーションを適用し、IdP に対して OIDC ディスカバリーを実行し、アップストリームクライアントを構築し、リッスンを開始する単一の Linux バイナリです。起動は設定、5 秒タイムアウト付き Postgres 接続、OIDC ディスカバリー、およびアップストリームクライアント構築に対して失敗時に閉じられます。これらのいずれかが到達不可能または設定が誤っている場合、ゲートウェイは低下した状態でトラフィックを提供するのではなく、エラーで終了します。
+    ゲートウェイは、設定を読み取り、Postgres に接続してスキーママイグレーションを適用し、IdP に対して OIDC ディスカバリーを実行し、アップストリームクライアントを構築し、リッスンを開始する単一の Linux バイナリです。起動は設定、Postgres 接続、OIDC ディスカバリー、およびアップストリームクライアント構築に対して失敗時に閉じられます。これらのいずれかが到達不可能または設定が誤っている場合、ゲートウェイは低下した状態でトラフィックを提供するのではなく、エラーで終了します。
 
     成功した起動は推論パスを検証しません。Amazon Bedrock と Google Cloud の Agent Platform インスタンス認証情報は起動時ではなく最初のリクエストで解決されるためです。
@@ -274,4 +274,8 @@ openssl x509 -noout -fingerprint -sha256 -in cert.pem | cut -d= -f2 | tr -d : |
 証明書がローテーションされると、すべての開発者は再度信頼プロンプトを見るため、ローテーションを計画されたイベントとして扱い、フィンガープリントを再公開します。ゲートウェイポリシーに[承認が必要な設定](/docs/ja/server-managed-settings#security-approval-dialogs)が含まれている場合、開発者は新しい証明書を受け入れた後、その承認ダイアログも再度見ます。Claude Code は[承認メモリ](/docs/ja/server-managed-settings#approval-memory)をピン留めされた証明書にキーイングするためです。
 
+ゲートウェイはトークンレスポンスでオプションの `email` フィールドを返して、サインインが使用したアカウントに名前を付けることができます。そうする場合、開発者は Claude Code が認証情報を保存する前にアカウントを確認します。確認されたサインイン後、`/status` はアカウントを表示します。
+
+確認には開発者マシンで Claude Code v2.1.275 以降が必要です。そのバージョンより下のクライアントはフィールドを無視します。`claude` バイナリのゲートウェイサーバーはフィールドを返さないため、そのサインインは確認なしで完了します。
+
 開発者がサインインすると、[モデルピッカー](/docs/ja/model-config)は開発者の `availableModels` 許可リストのモデルを表示します。管理設定は起動時に適用され、1 時間ごとに更新され、テレメトリはコレクターにルーティングされます。
 
@@ -488,4 +492,7 @@ Claude Desktop は同じブラウザ SSO ステップでゲートウェイのア
 * **ゲートウェイがセッションを終了した後の起動**：[起動時の失敗クローズを強制する](/docs/ja/server-managed-settings#enforce-fail-closed-startup)を参照して、どの起動がゲートウェイからサインアウトした状態で開き、どの起動がゲートウェイが `401` で応答するときに終了するかを確認します。
 * **プロビジョニング解除**：ユーザーが IdP で無効化されたセッションは、次の更新が失敗したときに `ttl_hours` 内に期限切れになります。
+* **サインアウト**：`/logout` はゲートウェイ認証情報を開発者のマシンから削除します。
+  * ゲートウェイの検出ドキュメントがゲートウェイ URL 独自のスキーム、ホスト、およびポートで `revocation_endpoint` をアドバタイズする場合、`/logout` は保存されたトークンをそのエンドポイントに送信して、ゲートウェイがその側でセッションを終了できるようにします。リクエストはベストエフォートであるため、エンドポイントが応答するかどうかに関係なく、サインアウトは開発者のマシンで完了します。失効には開発者マシンで Claude Code v2.1.275 以降が必要です。
+  * `claude` バイナリのゲートウェイサーバーはアドバタイズしないため、そこからのサインアウトは開発者のマシンでのみセッションを終了します。サーバー側でセッションを強制的に終了するには、[JWT シークレットローテーション](/docs/ja/claude-apps-gateway-deploy#jwt-secret-rotation)を参照してください。
 
 <h3 id="what-the-organization-can-see">
```

</details>

<details>
<summary>claude-directory-ja.md</summary>

```diff
diff --git a/docs-ja/pages/claude-directory-ja.md b/docs-ja/pages/claude-directory-ja.md
index 3a153e0..486075f 100644
--- a/docs-ja/pages/claude-directory-ja.md
+++ b/docs-ja/pages/claude-directory-ja.md
@@ -1451,10 +1451,10 @@ Windows では、`~/.claude` は `%USERPROFILE%\.claude` に解決されます
 エクスプローラーは、あなたが作成および編集するファイルをカバーしています。いくつかの関連ファイルは他の場所にあります。
 
-| ファイル                    | 場所                                | 目的                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
-| ----------------------- | --------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
-| `managed-settings.json` | システムレベル、OS によって異なる                | エンタープライズが強制する設定で、[限定的な例外](/docs/ja/settings#security-keys-where-the-stricter-value-applies)を除いてオーバーライドできません。[ファイルの保存場所](/docs/ja/managed-settings#deploy-a-managed-settings-file)と [Claude Code が使用する管理ソース](/docs/ja/managed-settings#precedence-within-the-managed-tier)を参照してください。                                                                                                                                                                                                                                                                                 |
-| `CLAUDE.local.md`       | プロジェクトルート                         | このプロジェクトの個人的な設定で、CLAUDE.md と一緒に読み込まれます。手動で作成し、`.gitignore` に追加してください。                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
-| `AGENTS.md`             | プロジェクトルート、`.claude/`、または任意のディレクトリ | AI コーディングエージェント向けに作成するプロジェクト指示。Claude Code は[それを読み込む](/docs/ja/memory#agents-md)ことができます。これは独立して、または `CLAUDE.md` と一緒に読み込まれます。                                                                                                                                                                                                                                                                                                                                                                                                                              |
-| インストール済みプラグイン           | `~/.claude/plugins`               | クローンされたマーケットプレイス、インストール済みプラグインバージョン、およびプラグインごとのデータで、`claude plugin` コマンドで管理されます。リンクモードでマーケットプレイス [`command` ソース](/docs/ja/plugin-marketplaces#command-sources)からインストールされたプラグインの場合、Claude Code はコピーの代わりにここにリンクを保存し、プラグインのファイルはコマンドが出力するディレクトリに留まります。`command` ソースには Claude Code v2.1.229 以降が必要です。ローカルディレクトリマーケットプレイスで相対パスでリストされているプラグインも、キャッシュコピーではなく、ソースディレクトリから[その場で読み込まれます](/docs/ja/plugins-reference#plugin-caching-and-file-resolution)。[プラグインキャッシング](/docs/ja/plugins-reference#plugin-caching-and-file-resolution)を参照して、孤立したバージョンがどのようにクリーンアップされるかを確認してください。 |
+| ファイル                    | 場所                                | 目的                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
+| ----------------------- | --------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
+| `managed-settings.json` | システムレベル、OS によって異なる                | エンタープライズが強制する設定で、[限定的な例外](/docs/ja/settings#security-keys-where-the-stricter-value-applies)を除いてオーバーライドできません。[ファイルの保存場所](/docs/ja/managed-settings#deploy-a-managed-settings-file)と [Claude Code が使用する管理ソース](/docs/ja/managed-settings#precedence-within-the-managed-tier)を参照してください。                                                                                                                                                                                                                                                                                                                                                                                                |
+| `CLAUDE.local.md`       | プロジェクトルート                         | このプロジェクトの個人的な設定で、CLAUDE.md と一緒に読み込まれます。手動で作成し、`.gitignore` に追加してください。                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
+| `AGENTS.md`             | プロジェクトルート、`.claude/`、または任意のディレクトリ | AI コーディングエージェント向けに作成するプロジェクト指示。Claude Code は[それを読み込む](/docs/ja/memory#agents-md)ことができます。これは独立して、または `CLAUDE.md` と一緒に読み込まれます。                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
+| インストール済みプラグイン           | `~/.claude/plugins`               | クローンされたマーケットプレイス、インストール済みプラグインバージョン、およびプラグインごとのデータで、`claude plugin` コマンドで管理されます。プラグイン[あなたの claude.ai アカウントから同期](/docs/ja/plugins-reference#synced-plugins)は `~/.claude/plugins/synced/` にダウンロードされます。リンクモードでマーケットプレイス [`command` ソース](/docs/ja/plugin-marketplaces#command-sources)からインストールされたプラグインの場合、Claude Code はコピーの代わりにここにリンクを保存し、プラグインのファイルはコマンドが出力するディレクトリに留まります。`command` ソースには Claude Code v2.1.229 以降が必要です。ローカルディレクトリマーケットプレイスで相対パスでリストされているプラグインも、キャッシュコピーではなく、ソースディレクトリから[その場で読み込まれます](/docs/ja/plugins-reference#plugin-caching-and-file-resolution)。[プラグインキャッシング](/docs/ja/plugins-reference#plugin-caching-and-file-resolution)を参照して、孤立したバージョンがどのようにクリーンアップされるかを確認してください。 |
 
 `~/.claude` はまた、Claude Code があなたが作業する際に書き込むデータも保持しています。トランスクリプト、プロンプト履歴、ファイルスナップショット、キャッシュ、およびログです。下記の[アプリケーションデータ](#application-data)を参照してください。
@@ -1534,25 +1534,25 @@ Windows では、`~/.claude` は `%USERPROFILE%\.claude` に解決されます
 Claude Code は、[`cleanupPeriodDays`](/docs/ja/settings-reference#cleanupperioddays) より古いファイルを以下のパスから削除します。ただし、保持期間を安全に判定できる場合に限ります。デフォルトは 30 日で、最小値は 1 です。`0` に設定するとバリデーションエラーが発生します。同じ経過日数の閾値が、[孤立した worktrees](/docs/ja/worktrees#clean-up-subagent-and-background-session-worktrees) の自動削除にも適用されます。
 
-| `~/.claude/` 下のパス                                                                                                              | 内容                                                                                                                                                                                                            |
-| ------------------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
-| `projects/<project>/<session>.jsonl`                                                                                           | 完全な会話トランスクリプト：すべてのメッセージ、ツール呼び出し、ツール結果                                                                                                                                                                         |
-| `projects/<project>/<session>.orphaned-<timestamp>-<suffix>.jsonl`、`projects/<project>/<session>.jsonl.superseded-<timestamp>` | Claude Code が上書きまたは削除する代わりに脇に置いたセッションの前のトランスクリプト。セッションピッカーには表示されません                                                                                                                                           |
-| `projects/<project>/<session>/subagents/`                                                                                      | [Subagent](/docs/ja/sub-agents) の会話トランスクリプト。親セッションのトランスクリプトが経過時間で削除されるときに削除されます                                                                                                                                    |
-| `projects/<project>/<session>/tool-results/`                                                                                   | 別ファイルにこぼれた大きなツール出力                                                                                                                                                                                            |
```

</details>

<details>
<summary>desktop-ja.md</summary>

```diff
diff --git a/docs-ja/pages/desktop-ja.md b/docs-ja/pages/desktop-ja.md
index 7350b3a..d99dfe2 100644
--- a/docs-ja/pages/desktop-ja.md
+++ b/docs-ja/pages/desktop-ja.md
@@ -927,5 +927,5 @@ Anthropic は、到着元のアドレスを使用して、組織の IP 許可リ
 [Artifact](/docs/ja/artifacts)が[Google Fonts](/docs/ja/artifacts#improve-the-visual-design)からタイプフェイスを読み込む場合、`fonts.googleapis.com`および`fonts.gstatic.com`もリクエストします。両方のホストはオプションです。それらをブロックする場合、artifact はフォールバックタイプフェイスでレンダリングされます。フォントリクエストが即座に失敗するように、高速拒否でブロックしてください。ページの最初のレンダリングを遅延させるのではなく。
 
-Artifact は、React またはチャートパッケージなどの JavaScript ライブラリを`cdnjs.cloudflare.com`、`cdn.jsdelivr.net`、`cdn.tailwindcss.com`、および`code.jquery.com`から読み込むこともできます。他の外部ホストからは読み込みません。それらのホストをブロックする場合、ライブラリに依存する artifact の部分は機能しません。ブロックされたフォントとは異なり、ブロックされたライブラリにはフォールバックがありません。ここでも高速拒否でブロックしてください。ブロックされたライブラリリクエストが即座に失敗するように。タイムアウトするまでハングするのではなく。
+Artifact は、React またはチャートパッケージなどの JavaScript ライブラリを`cdnjs.cloudflare.com`、`cdn.jsdelivr.net`、`cdn.tailwindcss.com`、`code.jquery.com`、および`unpkg.com`から読み込むこともできます。他の外部ホストからは読み込みません。それらのホストをブロックする場合、ライブラリに依存する artifact の部分は機能しません。ブロックされたフォントとは異なり、ブロックされたライブラリにはフォールバックがありません。ここでも高速拒否でブロックしてください。ブロックされたライブラリリクエストが即座に失敗するように。タイムアウトするまでハングするのではなく。
 
 <h3 id="authentication-and-sso">
```

</details>

<details>
<summary>discover-plugins-ja.md</summary>

```diff
diff --git a/docs-ja/pages/discover-plugins-ja.md b/docs-ja/pages/discover-plugins-ja.md
index 6c0972a..9398c2a 100644
--- a/docs-ja/pages/discover-plugins-ja.md
+++ b/docs-ja/pages/discover-plugins-ja.md
@@ -43,5 +43,9 @@ Claude Code は初めて対話的に起動すると、公式 Anthropic マーケ
 ```
 
-`/plugin` はターミナル CLI で対話的なパネルを開きます。Claude が `/plugin` がこの環境では利用できないと返答する場合は、Claude デスクトップアプリの[プラグインブラウザー](/docs/ja/desktop#install-plugins)を使用するか、クラウドセッションの `.claude/settings.json` で [`enabledPlugins`](/docs/ja/settings-reference#enabledplugins) の下にプラグインを宣言してください。
+`/plugin` はターミナル CLI で対話的なパネルを開きます。Claude が `/plugin` がこの環境では利用できないと返答する場合は、別の方法でプラグインをインストールしてください：
+
+* **Claude デスクトップアプリ**：[プラグインブラウザー](/docs/ja/desktop#install-plugins)を使用してください。
+* **VS Code 拡張機能**：[**Manage plugins** ダイアログ](/docs/ja/vs-code#manage-plugins)からインストールしてください。
+* **クラウドセッション**：`.claude/settings.json` で [`enabledPlugins`](/docs/ja/settings-reference#enabledplugins) の下にプラグインを宣言してください。
 
 インストールが失敗した場合は、Claude Code が報告するメッセージと照合してください：
```

</details>

<details>
<summary>fast-mode-ja.md</summary>

```diff
diff --git a/docs-ja/pages/fast-mode-ja.md b/docs-ja/pages/fast-mode-ja.md
index bbadc49..f42ffdc 100644
--- a/docs-ja/pages/fast-mode-ja.md
+++ b/docs-ja/pages/fast-mode-ja.md
@@ -15,9 +15,9 @@
 高速モードは異なるモデルではありません。Claude Opus を使用していますが、コスト効率よりも速度を優先する異なる API 構成です。同じ品質と機能が得られ、レスポンスが高速化されるだけです。高速モードは Opus 5 および Opus 4.8 でサポートされています。Sonnet、Haiku、または他のモデルでは利用できません。
 
-Claude Code は Opus 4.7 を高速モードをサポートしていない他のモデルと同じように扱います。Opus 4.7 に切り替えると高速モードがオフになります。Opus 4.7 の高速モードは 2026 年 6 月 25 日に非推奨となり、2026 年 7 月 24 日に削除されました。
+Opus 4.7 は高速モードをサポートしていないため、それに切り替えると高速モードがオフになります。Opus 4.7 の高速モードは 2026 年 6 月 25 日に非推奨となり、2026 年 7 月 24 日に削除されました。
 
 知っておくべきこと：
 
-* Claude Code CLI で `/fast` を使用して高速モードをオンにします。VS Code Extension は [`fastMode` 設定](#toggle-fast-mode)に従い、選択したモデルが高速モードをサポートしている場合は**高速モードを切り替え**コマンドを提供します。
+* Claude Code CLI で `/fast` を使用して高速モードをオンにします。[VS Code 拡張機能](/docs/ja/vs-code)は、選択したモデルが高速モードをサポートしている場合、**高速モードを切り替え**コマンドを提供します。Claude Code はそのトグルを [`fastMode` 設定](#toggle-fast-mode)に保存します。
 * 高速モード価格は Opus 5 および Opus 4.8 で入力/出力あたり $10/$50 MTok です。
 * サブスクリプションプラン（Pro/Max/Team/Enterprise）の Claude Code ユーザーと Claude Console のすべてのユーザーが利用可能です。Team および Enterprise 組織は Owner が最初に有効にする必要があり、Console 組織はアクセスを最初にプロビジョニングする必要があります。どちらも[要件](#requirements)に記載されています。
@@ -146,7 +146,9 @@ Claude Code は、モデル切り替え、再接続、または失敗した[可
 
 <Note>
-  2 つの組織設定が `/fast` で高速モードをオンにすることをブロックできます：
+  4 つの組織設定が `/fast` で高速モードをオンにすることをブロックできます：
 
   * **高速モードが有効になっていない**：組織で高速モードが有効になっていない場合、`/fast` で高速モードをオンにすると「Fast mode has been disabled by your organization.」と表示されます。
+  * **高速モードが管理設定によってオフにされている**：組織が [`fastMode: false`](/docs/ja/settings-reference#fastmode) を設定する[管理設定](/docs/ja/managed-settings)をデプロイしている場合、`/fast` で高速モードをオンにすると同じ「Fast mode has been disabled by your organization」メッセージが表示されます。
+  * **セッションごとのオプトインが必要**：[`fastModePerSessionOptIn: true`](#require-per-session-opt-in) を設定する管理設定は、インタラクティブターミナルセッション以外のすべての場所で `/fast on` を同じメッセージで拒否します。
   * **高速モードモデルが許可されていない**：組織の [`availableModels`](/docs/ja/model-config#restrict-model-selection) 許可リストが高速モード Opus モデルを除外している場合、オンにすることは「is not in your organization's allowed models」で拒否されます。高速モードをサポートする許可された Opus モデルで既に実行中のセッションでは、`/fast` はモデルを切り替える代わりに現在のモデルで高速モードを有効にします。
 </Note>
@@ -205,4 +207,6 @@ Claude Code は、モデル切り替え、再接続、または失敗した[可
 これは、ユーザーが複数の同時セッションを実行する組織でコストを制御するのに役立ちます。ユーザーの高速モード設定は保存されたままなので、この設定を削除するとデフォルトの永続的な動作が復元されます。
 
```

</details>

<details>
<summary>interactive-mode-ja.md</summary>

```diff
diff --git a/docs-ja/pages/interactive-mode-ja.md b/docs-ja/pages/interactive-mode-ja.md
index 4c5b096..663d809 100644
--- a/docs-ja/pages/interactive-mode-ja.md
+++ b/docs-ja/pages/interactive-mode-ja.md
@@ -40,4 +40,5 @@
 | `Esc`                                                                    | Claude を割り込むか、ダイアログを閉じる                                                                                                                                                                                    | 現在の応答またはツール呼び出しを途中で停止して、リダイレクトできます。Claude はこれまでの作業を保持します。[メッセージがキューに入っている](#queue-messages-while-claude-works)場合、Claude Code は次にそれらを送信します。ダイアログが開いている場合、`Esc` はダイアログを閉じます。権限プロンプトでは、`Esc` はアクション（[コメントなしの**いいえ**](/docs/ja/permissions#add-a-comment-when-you-answer-a-permission-prompt)と同じ）を拒否します                                                                      |
 | `Esc` + `Esc`                                                            | 入力ドラフトをクリアするか、巻き戻す                                                                                                                                                                                         | プロンプト入力にテキストが含まれている場合、ダブル `Esc` はそれをクリアし、ドラフトを履歴に保存して `Up` で呼び出せるようにします。入力が空の場合、ダブル `Esc` は[巻き戻しメニュー](/docs/ja/checkpointing)を開いて、前の時点からコードと会話を復元または要約できます                                                                                                                                                                                                               |
+| `Ctrl+Enter` または `Ctrl+X Ctrl+S`                                         | キューに入れたメッセージを今すぐ送信                                                                                                                                                                                         | 現在のターンを割り込んで、[キューに入れたメッセージ](#queue-messages-while-claude-works)とドラフトがターン終了時ではなく直ちに送出されます。[シェルモード](#shell-mode-with-prefix)では、キーはコマンドをキューに入れて割り込みません。拡張キーを報告しないターミナルでは、`Ctrl+Enter` は通常の `Enter` として到着します。`Ctrl+X Ctrl+S` はすべてのターミナルで機能します。Claude Code v2.1.275 以降が必要です                                                                                              |
 | `Shift+Tab`、または Node または Bun ランタイムが VT 入力モードを有効にしない場合は Windows で `Alt+M` | 権限モードを循環                                                                                                                                                                                                   | `default`（モード指標で Manual とラベル付け）、`acceptEdits`、`plan`、および利用可能な場合は `bypassPermissions` と `auto` を循環します。`auto` から、最初のプレスは `default` に切り替わります。[権限モード](/docs/ja/permission-modes)を参照してください。ファイル権限プロンプトでは、同じキーが開いている[コメントフィールド](/docs/ja/permissions#add-a-comment-when-you-answer-a-permission-prompt)を閉じます。フィールドが開いていない場合、プロンプトがそのオプションを提供するときに、セッションの残りの部分でアクションを許可するオプションを選択します |
 | `Option+P`（macOS）または `Alt+P`（Windows/Linux）                              | モデルを切り替え                                                                                                                                                                                                   | プロンプトをクリアせずにモデルを切り替え                                                                                                                                                                                                                                                                                                                                                |
@@ -349,5 +350,7 @@ Claude Code がコマンドをバックグラウンドで実行する場合、
 * セッションを終了する代わりにバックグラウンドにした場合、バックグラウンドタスクはバックグラウンドセッションで実行され続けます。[実行中のセッションをバックグラウンドにする](/docs/ja/agent-view#from-inside-a-session)を参照してください
 * 出力が 5GB を超える場合、バックグラウンドタスクは自動的に終了され、stderr に理由を説明するメモが表示されます
-* macOS と Linux では、セッションが少なくとも 30 分間アイドル状態にあり、ターンまたはサブエージェントが実行されていない場合、Claude Code はオペレーティングシステムがメモリプレッシャーを通知するときに実行中のバックグラウンドタスクを終了します。[`CLAUDE_CODE_DISABLE_BG_SHELL_PRESSURE_REAP`](/docs/ja/env-vars) を `1` に設定してこれをオフにします。Claude Code v2.1.193 以降が必要です
+* macOS と Linux では、セッションが少なくとも 30 分間アイドル状態にあり、ターンまたはサブエージェントが実行されていない場合、Claude Code はオペレーティングシステムがメモリプレッシャーを通知するときに実行中のバックグラウンドタスクを停止します。Claude Code v2.1.193 以降が必要です
+  * [デバッグログ](/docs/ja/debug-your-config)は、タスクが停止された理由、またはプレッシャーイベントがそれらを実行し続けた理由を示します
+  * [`CLAUDE_CODE_DISABLE_BG_SHELL_PRESSURE_REAP`](/docs/ja/env-vars) を `1` に設定してメモリプレッシャー停止をオフにします
 * [サブエージェント](/docs/ja/sub-agents)が所有するバックグラウンドコマンドには時間制限がありません。ただし、フォアグラウンドで実行されているサブエージェントが所有するコマンドは、そのサブエージェントが最終応答を行うときに終了します。ツール参照の[バックグラウンドコマンド](/docs/ja/tools-reference#background-commands)を参照してください。v2.1.218 より前では、メモリプレッシャーリープも、サブエージェントコマンドに対する以前の 60 分制限も、`Ctrl+B` でバックグラウンドに移動されたコマンドをカバーしていませんでした
 
@@ -395,4 +398,6 @@ Claude はコマンド出力がトランスクリプトに到着すると自動
 Claude が作業中に、メッセージを入力して `Enter` キーを押すと、Claude Code はターンを中断する代わりにメッセージをキューに入れ、入力ボックスの上にキューに入れられたエントリを表示します。`!` [シェルコマンド](#shell-mode-with-prefix)と、ほとんどの[コマンド](/docs/ja/commands)をキューに入れることができます。ただし、Claude Code が送信直後に実行する `/status` などのコマンドは除きます。
 
+送信されたメッセージとキューに入れられたメッセージは、Claude が応答を開始するまでグレーで表示されるため、Claude がまだ処理していないメッセージを判別できます。
+
 <h3 id="when-claude-code-sends-what-you-queued">
   Claude Code がキューに入れたものを送信するタイミング
@@ -401,8 +406,12 @@ Claude が作業中に、メッセージを入力して `Enter` キーを押す
 キューに入れたエントリが Claude に到達するタイミングは、何をキューに入れたかによって異なります。
 
-* メッセージ：Claude がツール呼び出しを実行している間にメッセージをキューに入れた場合、Claude Code はそれらのツール呼び出しが完了するとすぐに、同じターン内で Claude に渡します。ターンがメッセージがまだキューに入った状態で終了した場合、Claude Code は次のターンで最も古いものだけを送信します。残りはキューに留まり、同じルールに従います。Claude Code はそのターンのツール呼び出しが完了したときに Claude に渡すか、その次のターンで次に古いものを送信します。
```

</details>

*...以降省略*

</details>


<details>
<summary>2026-09-21</summary>

**変更ファイル:**

```
 docs-ja/pages/artifacts-ja.md | 6 +++---
 docs-ja/pages/commands-ja.md  | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)
```

<details>
<summary>artifacts-ja.md</summary>

```diff
diff --git a/docs-ja/pages/artifacts-ja.md b/docs-ja/pages/artifacts-ja.md
index 0d54b43..0f1b4d4 100644
--- a/docs-ja/pages/artifacts-ja.md
+++ b/docs-ja/pages/artifacts-ja.md
@@ -310,5 +310,5 @@ Claude はデザインシステムを独自の選択肢より高い優先度と
 </h2>
 
-UI、画面フロー、ランディングページ、またはポスターをモックアップするために、ページを構築するのではなく、`/design` をブリーフと共に実行します。Claude はデザインを 1 つのキャンバス上のアートボードとして作成し、Claude Design のエディターの研究プレビューを実行するアーティファクトとしてキャンバスを公開します。ブリーフは描画する内容を指定します。
+UI、画面フロー、ランディングページ、またはポスターをモックアップするために、ページを構築するのではなく、`/design` をブリーフと共に実行します。Claude はデザインを 1 つのキャンバス上のアートボードとして作成し、キャンバスを Design アーティファクトとして公開します。ブリーフは描画する内容を指定します。
 
 ```text wrap theme={null}
@@ -316,7 +316,7 @@ UI、画面フロー、ランディングページ、またはポスターをモ
 ```
 
-公開されたアーティファクトを開いてアートボードを確認します。アカウントで保存が有効になっている場合は、アートボード上の要素を選択して変更し、保存して新しいバージョンを公開します。それ以外の場合は、ドラフトを表示してPNG または PDF としてエクスポートします。
+公開されたアーティファクトをデスクトップブラウザーで開いてアートボードを確認します。アートボード上の要素を選択して変更すると、編集は自動的に保存されます。各アートボードを PNG または PDF としてエクスポートできます。
 
-`/design` は [アーティファクトが利用可能](#availability) なセッションと Claude Code v2.1.234 以降が必要です。
+`/design` は [アーティファクトが利用可能](#availability) なセッションと Claude Code v2.1.265 以降が必要です。
 
 <h2 id="page-constraints">
```

</details>

<details>
<summary>commands-ja.md</summary>

```diff
diff --git a/docs-ja/pages/commands-ja.md b/docs-ja/pages/commands-ja.md
index aafb3ba..710b6c2 100644
--- a/docs-ja/pages/commands-ja.md
+++ b/docs-ja/pages/commands-ja.md
@@ -80,5 +80,5 @@ Claude が応答中にコマンドを送信した場合、Claude Code はそれ
 | `/debug [description]`                                                                                       | **[Skill](/docs/ja/skills#bundled-skills).** 現在のセッションのデバッグログを有効にし、セッションデバッグログを読んで問題をトラブルシューティングします。デバッグログはデフォルトではオフです。`claude --debug` で開始した場合を除き、セッション中に `/debug` を実行するとその時点からログのキャプチャを開始します。オプションで問題を説明して分析に焦点を当てます                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
 | `/deep-research <question>`                                                                                  | **[Workflow](/docs/ja/workflows#bundled-workflows).** 質問に関する Web 検索を展開し、ソースを取得して相互確認し、引用されたレポートを合成します                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
-| `/design [brief]`                                                                                            | **[Skill](/docs/ja/skills#bundled-skills).** UI モックアップ、スクリーンフロー、ランディングページ、またはポスターを 1 つのキャンバス上のアートボードとしてドラフトし、Claude Design のエディターの研究プレビューを実行する[アーティファクト](/docs/ja/artifacts#draft-a-design-canvas)として公開します。たとえば `/design a settings screen for a mobile banking app`。アカウントで保存が有効な場合、キャンバス上のアートボードを編集して新しいバージョンを公開するために保存します。そうでない場合は、ドラフトを表示して PNG または PDF としてエクスポートします。[アーティファクトが利用可能](/docs/ja/artifacts#availability)なセッションと Claude Code v2.1.234 以降が必要です。Anthropic API で利用可能です。Amazon Bedrock、Google Cloud の Agent Platform、Microsoft Foundry、および Claude Platform on AWS では、アーティファクトが利用できないため、コマンドはそこで利用できません                                                                                                                                                                                                                                                                                                                                                                                                                  |
+| `/design [brief]`                                                                                            | **[Skill](/docs/ja/skills#bundled-skills).** UI モックアップ、スクリーンフロー、ランディングページ、またはポスターを 1 つのキャンバス上のアートボードとしてドラフトし、Design [アーティファクト](/docs/ja/artifacts#draft-a-design-canvas)として公開します。たとえば `/design a settings screen for a mobile banking app`。デスクトップブラウザでアートボードを編集し、編集は自動的に保存されます。各アートボードを PNG または PDF としてエクスポートできます。[アーティファクトが利用可能](/docs/ja/artifacts#availability)なセッションと Claude Code v2.1.265 以降が必要です。Anthropic API で利用可能です。Amazon Bedrock、Google Cloud の Agent Platform、Microsoft Foundry、および Claude Platform on AWS では、アーティファクトが利用できないため、コマンドはそこで利用できません                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
 | `/design-login`                                                                                              | claude.ai アカウントで `/design-sync` のデザインシステムアクセスを認可します                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
 | `/design-sync [hint]`                                                                                        | **[Skill](/docs/ja/skills#bundled-skills).** リポジトリの React デザインシステムを変換して [Claude Design](https://claude.ai/design) にアップロードし、生成するデザインが実際のコンポーネントを使用するようにします。オプションでデザインシステムに名前を付けます。たとえば `/design-sync Acme DS`。初回同期はすべてのコンポーネントを検証し、大規模なリポジトリでは数時間かかる場合があります。Anthropic API で利用可能です。Amazon Bedrock、Google Cloud の Agent Platform、Microsoft Foundry、および Claude Platform on AWS では、基盤となるツールが claude.ai に到達できないため、コマンドは利用できません。[Claude apps gateway](/docs/ja/claude-apps-gateway#availability-and-limitations) 経由でも利用できません                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
```

</details>

</details>


<details>
<summary>2026-09-20</summary>

**変更ファイル:**

```
 docs-ja/pages/changelog.md           | 5 +++++
 docs-ja/pages/permission-modes-ja.md | 2 +-
 2 files changed, 6 insertions(+), 1 deletion(-)
```

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index c8982b9..6d69d78 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,9 @@
 # Changelog
 
+## 2.1.278
+
+- Changed auto mode for Claude API and Enterprise users, and on Bedrock, Vertex, Foundry and gateways, to default to the server-side classifier, which does not charge for classifier overhead (`CLAUDE_CODE_AUTO_MODE_SERVER=0` opts out on Bedrock, Vertex, Foundry and gateways); warns on billed fallback. See https://code.claude.com/docs/en/auto-mode-classifier-billing
+- Added an `Auto mode server` row to `/status` showing whether this session's auto mode classifier runs on the server
+
 ## 2.1.277
 
```

</details>

<details>
<summary>permission-modes-ja.md</summary>

```diff
diff --git a/docs-ja/pages/permission-modes-ja.md b/docs-ja/pages/permission-modes-ja.md
index dcbc669..216d2ef 100644
--- a/docs-ja/pages/permission-modes-ja.md
+++ b/docs-ja/pages/permission-modes-ja.md
@@ -333,5 +333,5 @@ v2.1.158 から v2.1.206 では、これらのプロバイダーで自動モー
 </h3>
 
-Anthropic API、[AWS 上の Claude Platform](/docs/ja/claude-platform-on-aws)、Amazon Bedrock、Google Cloud の Agent Platform、Microsoft Foundry、および `ANTHROPIC_BASE_URL` を[LLM ゲートウェイまたはプロキシ](/docs/ja/llm-gateway)に指す場合、自動モードの Claude Code はサーバーに[クラシファイアに送信されるアクション](#how-the-classifier-evaluates-actions)をセッションのモデルリクエストの一部としてレビューするよう要求します。サーバーがそれらをレビューする場所では、その判定がこれらのアクションを決定します。レビューしない場所では、通常はゲートウェイまたはプロキシがトラフィックに干渉するため、Claude Code は独自のクラシファイアリクエストにフォールバックします。そのフォールバックがセッションの残りの間保持されると、これらのリクエストが請求されるアカウントで[クラシファイアリクエスト料金に関する 1 回限りのダイアログ](/docs/ja/auto-mode-classifier-billing)を表示します。サーバーに質問することをスキップして、常に Claude Code 独自のクラシファイアリクエストを使用するには、[`CLAUDE_CODE_AUTO_MODE_SERVER=0`](/docs/ja/env-vars) を設定します。変数は Anthropic API への直接接続では読み取られません。`CLAUDE_CODE_DISABLE_EXPERIMENTAL_BETAS=1` を設定し、`CLAUDE_CODE_AUTO_MODE_SERVER` を設定しないままにする場合、Claude Code もサーバーに質問することを停止します。
+Enterprise プランおよび Claude API を使用するアカウント、[AWS 上の Claude Platform](/docs/ja/claude-platform-on-aws)、Amazon Bedrock、Google Cloud の Agent Platform、Microsoft Foundry、および `ANTHROPIC_BASE_URL` を[LLM ゲートウェイまたはプロキシ](/docs/ja/llm-gateway)に指す場合、自動モードの Claude Code はサーバーに[クラシファイアに送信されるアクション](#how-the-classifier-evaluates-actions)をセッションのモデルリクエストの一部としてレビューするよう要求します。サーバーがそれらをレビューする場所では、その判定がこれらのアクションを決定します。レビューしない場所では、通常はゲートウェイまたはプロキシがトラフィックに干渉するため、プラットフォーム、リージョン、または認証情報がまだサーバー側チェックを持たないため、Claude Code は独自のクラシファイアリクエストにフォールバックします。そのフォールバックがセッションの残りの間保持されると、これらのリクエストが請求されるアカウントで[クラシファイアリクエスト料金に関する通知](/docs/ja/auto-mode-classifier-billing)を表示します。サーバーに質問することをスキップして、常に Claude Code 独自のクラシファイアリクエストを使用するには、[`CLAUDE_CODE_AUTO_MODE_SERVER=0`](/docs/ja/env-vars) を設定します。変数は Anthropic API への直接接続では読み取られません。`CLAUDE_CODE_DISABLE_EXPERIMENTAL_BETAS=1` を設定し、`CLAUDE_CODE_AUTO_MODE_SERVER` を設定しないままにする場合、Claude Code もサーバーに質問することを停止します。
 
 デフォルトでサーバーに質問することには Claude Code v2.1.278 以降が必要です。
```

</details>

</details>


<details>
<summary>2026-09-19</summary>

**変更ファイル:**

```
 docs-ja/pages/accessibility-ja.md                  |   2 -
 docs-ja/pages/agent-teams-ja.md                    |   4 +
 docs-ja/pages/amazon-bedrock-ja.md                 |   2 +-
 docs-ja/pages/artifacts-ja.md                      |   2 +-
 docs-ja/pages/changelog.md                         |  96 ++-
 docs-ja/pages/channels-reference-ja.md             |   2 +-
 docs-ja/pages/claude-apps-gateway-deploy-ja.md     | 144 +++-
 docs-ja/pages/claude-apps-gateway-ja.md            |  14 +-
 docs-ja/pages/claude-apps-gateway-on-aws-ja.md     |   2 +-
 docs-ja/pages/claude-apps-gateway-on-gcp-ja.md     |   2 +-
 docs-ja/pages/claude-code-on-the-web-ja.md         |   8 +
 docs-ja/pages/claude-directory-ja.md               | 113 ++--
 docs-ja/pages/claude-projects-ja.md                |  74 ++-
 docs-ja/pages/cloud-environments-ja.md             |  99 +--
 docs-ja/pages/commands-ja.md                       |   3 +-
 docs-ja/pages/context-window-ja.md                 |   2 +-
 docs-ja/pages/corporate-launcher-ja.md             |   2 +-
 docs-ja/pages/desktop-ja.md                        |  14 +-
 docs-ja/pages/discover-plugins-ja.md               |  39 +-
 docs-ja/pages/env-vars-ja.md                       | 739 +++++++++++----------
 docs-ja/pages/errors-ja.md                         | 661 ++++++++++++------
 docs-ja/pages/feature-availability-ja.md           |   5 +-
 docs-ja/pages/glossary-ja.md                       |  10 +-
 docs-ja/pages/headless-ja.md                       | 179 ++---
 docs-ja/pages/how-claude-code-works-ja.md          |   2 +-
 docs-ja/pages/interactive-mode-ja.md               |   2 +-
 docs-ja/pages/llm-gateway-ja.md                    |   2 +-
 docs-ja/pages/llm-gateway-protocol-ja.md           | 102 ++-
 docs-ja/pages/llm-gateway-rollout-ja.md            |  24 +-
 docs-ja/pages/managed-mcp-ja.md                    |  37 +-
 docs-ja/pages/managed-settings-ja.md               |  16 +-
 docs-ja/pages/mcp-ja.md                            |   4 +-
 docs-ja/pages/memory-ja.md                         | 359 ++++++----
 docs-ja/pages/mobile-ja.md                         |   9 +-
 docs-ja/pages/output-styles-ja.md                  |   7 +-
 docs-ja/pages/overview-ja.md                       |   2 +-
 docs-ja/pages/permission-modes-ja.md               |  12 +-
 docs-ja/pages/plugin-dependencies-ja.md            |   6 +-
 docs-ja/pages/plugin-marketplaces-ja.md            |  33 +-
 docs-ja/pages/plugin-relevance-ja.md               |   4 +-
 docs-ja/pages/plugins-reference-ja.md              |  15 +-
 docs-ja/pages/prompt-caching-ja.md                 |   2 +-
 docs-ja/pages/remote-control-ja.md                 |   3 +-
 docs-ja/pages/routines-ja.md                       |  85 ++-
 docs-ja/pages/scheduled-tasks-ja.md                |   2 +-
 .../pages/self-hosted-environments-deploy-ja.md    |  14 +-
 .../pages/self-hosted-environments-reference-ja.md |   1 +
 docs-ja/pages/server-managed-settings-ja.md        |   4 +-
 docs-ja/pages/settings-reference-ja.md             | 640 +++++++++---------
 docs-ja/pages/slack-ja.md                          |   4 +-
 docs-ja/pages/sub-agents-ja.md                     |   2 +-
 docs-ja/pages/tools-reference-ja.md                |   1 +
 docs-ja/pages/ultrareview-ja.md                    |  43 +-
 docs-ja/pages/vs-code-ja.md                        |   2 +
 docs-ja/pages/web-quickstart-ja.md                 |   6 +-
 docs-ja/pages/workflows-ja.md                      |  18 +-
 56 files changed, 2244 insertions(+), 1437 deletions(-)
```

<details>
<summary>accessibility-ja.md</summary>

```diff
diff --git a/docs-ja/pages/accessibility-ja.md b/docs-ja/pages/accessibility-ja.md
index 32668f1..c79d6f1 100644
--- a/docs-ja/pages/accessibility-ja.md
+++ b/docs-ja/pages/accessibility-ja.md
@@ -11,6 +11,4 @@ Claude Code には、ビジュアルターミナルインターフェースを
 スクリーンリーダーモードはオプトインです。スクリーン拡大鏡、モーション削減、またはスクリーンリーダーの代わりにカラーブラインド対応テーマを使用する場合は、[アクセシビリティ設定](#accessibility-settings)テーブルから `CLAUDE_CODE_ACCESSIBILITY`、`prefersReducedMotion`、または `theme` を設定してください。スクリーンリーダーモードはターミナルインターフェースのみを適応させるため、VS Code 拡張機能のチャットパネルではこれを必要としません。Claude Code v2.1.236 以降では、拡張機能は設定なしで[スクリーンリーダーにコンバーセーション活動を通知](/docs/ja/vs-code#use-a-screen-reader)します。
 
-スクリーンリーダーモードには Claude Code v2.1.181 以降が必要です。以前のバージョンは `--ax-screen-reader` フラグを `error: unknown option '--ax-screen-reader'` で拒否します。
-
 <h2 id="turn-on-screen-reader-mode">
   スクリーンリーダーモードをオンにする
```

</details>

<details>
<summary>agent-teams-ja.md</summary>

```diff
diff --git a/docs-ja/pages/agent-teams-ja.md b/docs-ja/pages/agent-teams-ja.md
index a6888da..fd98969 100644
--- a/docs-ja/pages/agent-teams-ja.md
+++ b/docs-ja/pages/agent-teams-ja.md
@@ -311,4 +311,8 @@ Claude Code は名前を付けた subagent 定義を読み取り、これらの
 * **`mcpServers`**：分割ペインチームメンバーの場合、Claude Code は [そのフィールドのルール](/docs/ja/sub-agents#scope-mcp-servers-to-a-subagent) に従って定義の `mcpServers` を適用します。これは `--agent` で開始されたセッションもカバーします。インプロセスチームメンバーはフィールドを無視し、プロジェクトおよびユーザー設定から MCP サーバーをロードします。
 
+Claude がインプロセスチームメンバーにメッセージを送信し、そのチームメンバーがもう実行されていない場合、Claude Code はそれを同じセッション内に戻し、保存されている会話を復元し、メッセージを次のプロンプトとして提供します。セッションを再開した後、チームメンバーはこの方法では戻されません。[再開の制限](#limitations) に従います。
+
+Claude Code が戻すチームメンバーについて、プロジェクトの `.claude/agents/` ディレクトリまたは `--add-dir` ディレクトリから来た定義は、[エージェントファイルが存在するフォルダを信頼している](/docs/ja/permissions#what-runs-before-you-trust-a-folder) 場合にのみ再適用されます。親フォルダを信頼することはカウントされません。それまで、チームメンバーはすべてのインプロセスチームメンバーに Claude Code が追加するツールのみを保持して、定義のツールまたは指示なしで戻ります。[チームメンバーのエージェント定義が復元されませんでした](/docs/ja/errors#teammate-agent-definition-not-restored) を参照して、通知テキストを確認してください。
+
 <h3 id="permissions">
   権限
```

</details>

<details>
<summary>amazon-bedrock-ja.md</summary>

```diff
diff --git a/docs-ja/pages/amazon-bedrock-ja.md b/docs-ja/pages/amazon-bedrock-ja.md
index 0a62bae..b1b8203 100644
--- a/docs-ja/pages/amazon-bedrock-ja.md
+++ b/docs-ja/pages/amazon-bedrock-ja.md
@@ -238,5 +238,5 @@ Claude Code は AWS SSO および企業 ID プロバイダーの自動認証情
 ```
 
-Claude Code v2.1.181 以降、`aws configure export-credentials --format process` からのフラット出力も受け入れられます。同じキーが `Credentials` の下にネストされるのではなく、トップレベルにあります。
+`aws configure export-credentials --format process` からのフラット出力も受け入れられます。同じキーが `Credentials` の下にネストされるのではなく、トップレベルにあります。
 
 `Expiration` はオプションです。コマンドが有効な ISO 8601 `Expiration` を返すと、Claude Code はその時刻の 5 分前まで認証情報をキャッシュします。それがない場合、認証情報は 1 時間キャッシュされます。
```

</details>

<details>
<summary>artifacts-ja.md</summary>

```diff
diff --git a/docs-ja/pages/artifacts-ja.md b/docs-ja/pages/artifacts-ja.md
index 50a55ac..0d54b43 100644
--- a/docs-ja/pages/artifacts-ja.md
+++ b/docs-ja/pages/artifacts-ja.md
@@ -292,5 +292,5 @@ Claude はダウンロード機能を公開の一部として宣言します。
 </h2>
 
-Claude がアーティファクトを構築する際、組み込みのデザインスキルを適用するため、ページは追加のプロンプトなしで意図的なパレット、タイポグラフィ、レイアウトを取得します。Claude Code v2.1.182 以降が必要です。そのスキルはまた、独自のものを選択する前に、プロジェクト内の既存のデザインシステムを探します。デザイントークンは、デザインシステムが再利用する名前付きの色、タイポグラフィ、スペーシング値です。アーティファクトを製品のブランディングと一致させるために、Claude が見つけられる場所（プロジェクトの [CLAUDE.md](/docs/ja/memory) またはリポジトリのテーマファイルなど）に記録します。
+Claude がアーティファクトを構築する際、組み込みのデザインスキルを適用するため、ページは追加のプロンプトなしで意図的なパレット、タイポグラフィ、レイアウトを取得します。そのスキルはまた、独自のものを選択する前に、プロジェクト内の既存のデザインシステムを探します。デザイントークンは、デザインシステムが再利用する名前付きの色、タイポグラフィ、スペーシング値です。アーティファクトを製品のブランディングと一致させるために、Claude が見つけられる場所（プロジェクトの [CLAUDE.md](/docs/ja/memory) またはリポジトリのテーマファイルなど）に記録します。
 
 ```markdown theme={null}
```

</details>

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index c5b586a..c8982b9 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,98 @@
 # Changelog
 
+## 2.1.277
+
+- Added AGENTS.md support: in a project with no CLAUDE.md, Claude Code reads AGENTS.md instead; change it under "Project instructions" in `/config` (not yet on Bedrock, Vertex or Foundry)
+- Added `CLAUDE_GATEWAY_PROXY_IS_EGRESS_BOUNDARY=1` for Claude apps gateways whose only egress is a forward proxy: every outbound request hands the proxy the hostname instead of resolving it locally
+- Added an optional `headers:` map on Claude apps gateway upstreams, to send static headers to a proxy you run in front of a provider
+- Added a line saying a background task's update is waiting when it finishes while a panel such as `/tasks` is open
+- Fixed `claude -p` and Agent SDK sessions that could hang with no result after an internal error; they now report the error and exit with code 1
+- Fixed conversations failing every request with "text content blocks must be non-empty" when an earlier assistant turn held an empty text block beside other content, including after `--resume`
+- Fixed being unexpectedly logged out when an older Claude Code build (for example an IDE extension's bundled CLI) runs on the same machine as the current one
+- Fixed interactive start-up hanging or showing an error for `ANTHROPIC_API_KEY` users when `~/.claude.json` holds a malformed `customApiKeyResponses` value
+- Fixed update checks erroring every 30 minutes, and `claude update` hanging when a minimum or maximum version is set, if a proxy returns an invalid version; a malformed `minimumVersion` is now ignored
+- Fixed `claude update` on winget- or apk-managed installs reporting "up to date" when the version lookup failed
+- Fixed `claude plugin install` sometimes failing and breaking the installed copy when reinstalling a plugin version that a session or another program was using; an unchanged copy is now left alone
+- Fixed Grep and Glob reporting no matches when the search could not start because the system was out of processes, memory or file handles; they now return an error saying so
+- Fixed the Write tool silently ending the turn as a declined permission when the target path is an existing directory; it now reports a clear error
+- Fixed the Edit tool treating an escaped backslash followed by `uXXXX` text as a `\uXXXX` escape, which could make an edit of a non-ASCII character rewrite an escaped backslash sequence instead
+- Fixed the Edit tool reporting "Invalid regular expression: regular expression too large" instead of "String not found in file" when a very large edit containing non-ASCII text did not match the file
+- Fixed a turn ending early with "Path contains null bytes" when a tool call's file path contained `\u0000` written as an escape sequence; escaped control characters now stay as literal text
+- Fixed background sessions (`claude --bg`) exiting when a plugin's LSP server exited or closed its stdin
+- Fixed a crash ("Type error") when opening `/mcp` or `/plugin manage` with a malformed `claudeAiMcpEverConnected` value in `~/.claude.json`
+- Fixed a crash at launch when `~/.claude.json` holds a malformed `theme` value
+- Fixed a crash ("unrecoverable interface error") when the prompt held text containing terminal color codes, for example a prompt recalled from history or text loaded from the external editor
+- Fixed a crash when resuming a session whose saved history holds an assistant message stored as a plain string
```

</details>

<details>
<summary>channels-reference-ja.md</summary>

```diff
diff --git a/docs-ja/pages/channels-reference-ja.md b/docs-ja/pages/channels-reference-ja.md
index fe30200..3779119 100644
--- a/docs-ja/pages/channels-reference-ja.md
+++ b/docs-ja/pages/channels-reference-ja.md
@@ -510,5 +510,5 @@ Claude Code v2.1.234 以降のクライアントはまた、`description` と `i
 マスキングはフィールドを受け取る人を変更しません。マスクされていない状態で残るものは、`--channels` または開発フラグでオプトインしたサーバーにのみ送信されます。両方のフィールドをクライアントフリートを制御しない限り信頼されないものとして扱います。
 
-サーバーが返送する判定は `notifications/claude/channel/permission` で、2 つのフィールド：上記の ID を反映する `request_id` と、`'allow'` または `'deny'` に設定された `behavior`。Allow はツール呼び出しを続行させます。Deny はそれを拒否し、ローカルダイアログで No と答えるのと同じです。どちらの判定も将来の呼び出しに影響しません。
+サーバーが返送する判定は `notifications/claude/channel/permission` で、2 つのフィールド：上記の ID を反映する `request_id` と、`'allow'` または `'deny'` に設定された `behavior`。Allow はツール呼び出しを続行させます。Deny はそれを拒否します。どちらの判定も将来の呼び出しに影響しません。
 
 <h3 id="add-relay-to-a-chat-bridge">
```

</details>

<details>
<summary>claude-apps-gateway-deploy-ja.md</summary>

```diff
diff --git a/docs-ja/pages/claude-apps-gateway-deploy-ja.md b/docs-ja/pages/claude-apps-gateway-deploy-ja.md
index 87a9565..3ea1fd2 100644
--- a/docs-ja/pages/claude-apps-gateway-deploy-ja.md
+++ b/docs-ja/pages/claude-apps-gateway-deploy-ja.md
@@ -127,4 +127,29 @@ Google Cloud での完全な実装例（Cloud Run または GKE、Cloud SQL、Se
 各メカニズムがポリシーを保存する場所については [where each mechanism stores the policy](/docs/ja/managed-settings#where-each-mechanism-stores-the-policy) を参照し、Claude Desktop `bootstrapUrl` 相当については [Client-side managed settings](/docs/ja/claude-apps-gateway-config#client-side-managed-settings) を参照してください。
 
+<h3 id="large-rollouts">
+  大規模なロールアウト
+</h3>
+
+サインインはクライアント IP アドレスごとにレート制限されており、デフォルトは小規模なチームに適しています。各アドレスは 10 分ごとに 30 回のサインイン開始と 10 回のコード送信を取得します。数千人の開発者へのロールアウトは、次の 2 つの理由のいずれかで、最初の朝にこれらの制限に達する可能性があります：
+
+* **ゲートウェイはロードバランサーを超えて見ることができません。** [`listen.trusted_proxies`](/docs/ja/claude-apps-gateway-config#listen) がない場合、すべての開発者はロードバランサーのアドレスから来ているように見え、1 つの制限を共有します。他の何よりも先にそれを設定します。ゲートウェイは、`X-Forwarded-For` ヘッダーを無視する最初の時間に警告をログに記録します。
+* **多くの開発者が少数の NAT または VPN エグレスアドレスを共有しています。** `trusted_proxies` が正しい場合でも、それらのアドレスの制限を共有します。[`rate_limits`](/docs/ja/claude-apps-gateway-config#http-tuning) を引き上げて適合させます。
+
+`max` のサイズを決定するには、開発者をそれらが共有するエグレスアドレスで割ります。1 つの `window_seconds` 期間内にそれらのうち何人がサインインするかを推定します。デフォルトは 10 分です。その後、リトライと Claude Code と Claude Desktop の両方にサインインする開発者をカバーするために 2 倍にします。
+
+例えば、10,000 人の開発者が 4 つのエグレスアドレスの背後にあり、1 時間にわたって均等にサインインします。これは、アドレスごとに 2,500 人の開発者で、各 10 分ごとに約 420 人です。これを 2 倍にして 1,000 に切り上げます。以下の例は両方の制限を 1,000 に設定します：
+
+```yaml theme={null}
+rate_limits:
+  device_authorization: { max: 1000, window_seconds: 600 }
+  device_verify: { max: 1000, window_seconds: 600 }
+```
+
+`device_verify` は、別の開発者のサインインコードを推測するのを防ぐものであるため、推定が必要な限りだけそれを引き上げます。これらの制限でも、コードは 20 文字のアルファベットから 8 文字で、10 分後に期限切れになるため、推測は実用的なままです。[User-code brute-force resistance](#user-code-brute-force-resistance) を参照してください。
+
+IdP がリフレッシュトークンを発行する場合、Claude Code はセッションをサイレントに更新するため、ロールアウト後に制限を戻すことができます。リフレッシュトークンがない場合、開発者は [`session.ttl_hours`](/docs/ja/claude-apps-gateway-config#session) ごとに再度サインインします。その定常状態レートの両方の制限のサイズを決定し、それらを引き上げたままにします。
+
```

</details>

<details>
<summary>claude-apps-gateway-ja.md</summary>

```diff
diff --git a/docs-ja/pages/claude-apps-gateway-ja.md b/docs-ja/pages/claude-apps-gateway-ja.md
index 7c73c54..438997b 100644
--- a/docs-ja/pages/claude-apps-gateway-ja.md
+++ b/docs-ja/pages/claude-apps-gateway-ja.md
@@ -431,7 +431,13 @@ OS ポリシー（HKLM レジストリポリシーまたは管理設定プリス
 </h4>
 
-1 つのロックを設定しても、他のロックは制限されません。各キーは[設定リファレンス](/docs/ja/settings-reference#all-settings)で文書化されています。勝者より下の管理ソースから、2 つのサンドボックスロックは引き続き適用され、`allowManagedPermissionRulesOnly` は引き続き親が提供した許可ルールと `additionalDirectories` をブロックします。hooks と MCP サーバーロック、および `allowManagedPermissionRulesOnly` の開発者独自のルールへの影響は、デフォルトで勝者ソースが必要です。[Claude Code が管理ソースを組み合わせる方法](/docs/ja/managed-settings#how-claude-code-combines-managed-sources)の `managedSourcesBehavior` マージオプトインの下で、Claude Code はすべてのロックについてすべてのソースが設定する最も厳密な値を適用します。[`policyHelper`](/docs/ja/settings-reference#policyhelper) フリートでは、ロックはヘルパーの出力からのみ読み取られます。
+1 つのロックを設定しても、他のロックは制限されません。各キーは[設定リファレンス](/docs/ja/settings-reference#all-settings)で文書化されています。勝者より下の管理ソースから、2 つのサンドボックスロックは引き続き適用され、`allowManagedPermissionRulesOnly` は引き続き親が提供した許可ルールと `additionalDirectories` をブロックします。Claude Code v2.1.273 以降では、MCP サーバーロックも勝者より下のソースから適用され、それがオンの間、管理 `allowedMcpServers` リストは最優先の管理ソースから来ます。
 
-各ロックは Claude Code が開発者独自のエントリをその設定について無視するようにするため、組織の許可リストをロックの隣に含めます。空の管理ドメインリストでネットワークドメインをロックするとサンドボックス化された全アウトバウンドトラフィックがブロックされ、管理またはホストが提供した `allowedMcpServers` なしで MCP サーバーをロックすると、`deniedMcpServers` がブロックしないすべてのサーバーが読み込まれます。`allowRead` エントリは `denyRead` 領域内のパスのみを再許可するため、管理 `denyRead` とペアにします。
+hooks ロックと `allowManagedPermissionRulesOnly` の開発者独自のルールへの影響は、デフォルトで勝者ソースが必要です。[Claude Code が管理ソースを組み合わせる方法](/docs/ja/managed-settings#how-claude-code-combines-managed-sources)の `managedSourcesBehavior` マージオプトインの下で、Claude Code はすべてのロックについてすべてのソースが設定する最も厳密な値を適用します。[`policyHelper`](/docs/ja/settings-reference#policyhelper) フリートでは、ロックはヘルパーの出力からのみ読み取られます。
+
+各ロックは Claude Code が開発者独自のエントリをその設定について無視するようにするため、組織の許可リストをロックの隣に含めます。
+
+* **ネットワークドメイン**：空の管理ドメインリストでロックするとサンドボックス化された全アウトバウンドトラフィックがブロックされます。
+* **MCP サーバー**：管理またはホストが提供した `allowedMcpServers` なしでロックすると、`deniedMcpServers` がブロックしないすべてのサーバーが読み込まれます。
+* **読み取りパス**：`allowRead` エントリは `denyRead` 領域内のパスのみを再許可するため、管理 `denyRead` とペアにします。
 
 <h4 id="settings-the-locks-don’t-cover">
@@ -439,8 +445,8 @@ OS ポリシー（HKLM レジストリポリシーまたは管理設定プリス
 </h4>
 
-5 つのロックすべてが設定されていても、4 つの親が提供した設定がフィルターを通過します。デフォルトの最初の勝ちの設定の下で、親をブロックする管理値は最優先の管理ソースにあるものです。`managedSourcesBehavior` マージオプトインの下で、[Claude Code が管理ソースを組み合わせる方法](/docs/ja/managed-settings#how-claude-code-combines-managed-sources)は代わりにどのソースの値が適用されるかを示します。
+5 つのロックすべてが設定されていても、4 つの親が提供した設定がフィルターを通過します。デフォルトの最初の勝ちの設定の下で、親をブロックする管理値は最優先の管理ソースにあるものです。ただし、[MCP サーバーロック](#lock-behavior-across-sources)がオンの間は `allowedMcpServers` を除きます。`managedSourcesBehavior` マージオプトインの下で、[Claude Code が管理ソースを組み合わせる方法](/docs/ja/managed-settings#how-claude-code-combines-managed-sources)は代わりにどのソースの値が適用されるかを示します。
 
 * **`forceLoginOrgUUID`**：最優先の管理ソースが組織 UUID を設定しない場合、Claude Code は親が提供した値を尊重します。ゲートウェイサインインはこのキーをチェックしないため、最初の当事者 Anthropic ログインも使用するフリートにのみ重要です。最優先の管理ソースの組織 UUID は親の値をブロックし、Claude Code が強制するものです。そこに `forceLoginOrgUUID` を設定します。
-* **`allowedMcpServers`**：最優先の管理ソースが設定しない場合、Claude Code は親が提供した許可リストを尊重し、`allowManagedMcpServersOnly` はそれをブロックしません。ロックは勝者の許可リストを管理値として強制するため、最優先の管理ソースが設定しない場合は親が提供した許可リストを含みます。最優先の管理ソースのリストは親のリストをブロックし、Claude Code が強制するリストです。ロックの隣にそこに `allowedMcpServers` を設定します。v2.1.223 より前では、任意の管理ソースのいずれかのキーの値は親のリストをブロックしました。
+* **`allowedMcpServers`**：最優先の管理ソースが設定しない場合、Claude Code は親が提供した許可リストを尊重します。`allowManagedMcpServersOnly` はそれをブロックしません。ロックは勝者の許可リストを管理値として強制するため、最優先の管理ソースが設定しない場合は親が提供した許可リストを含みます。最優先の管理ソースのリストは親のリストをブロックし、Claude Code が強制するリストです。ロックの隣にそこに `allowedMcpServers` を設定します。v2.1.223 より前では、任意の管理ソースのいずれかのキーの値は親のリストをブロックしました。
 * **`availableModels`**：勝者の管理ソースが設定しない場合、Claude Code は親が提供したモデルリストを尊重します。フリートがモデルを制限する場合、勝者ソースに `availableModels` を設定します。
```

</details>

<details>
<summary>claude-apps-gateway-on-aws-ja.md</summary>

```diff
diff --git a/docs-ja/pages/claude-apps-gateway-on-aws-ja.md b/docs-ja/pages/claude-apps-gateway-on-aws-ja.md
index 234af77..0d91616 100644
--- a/docs-ja/pages/claude-apps-gateway-on-aws-ja.md
+++ b/docs-ja/pages/claude-apps-gateway-on-aws-ja.md
@@ -504,5 +504,5 @@ export PRIVATE_SUBNETS="<subnet-id-a> <subnet-id-b>"
 | Bedrock がオンデマンドスループットがサポートされていないと言う `ValidationException` を返す                                                                              | カスタム `models:` エントリが、リージョンが推論プロファイルを通じてのみ提供する基盤モデル ID にマップされている                                                                                                                                                                                                                                                       | モデルをクロスリージョン推論プロファイル ID（`us.anthropic.*`）にマップしてください。組み込みカタログはすでにこれを行っています                                                                                                                                                                    |
 | ECS タスクがゲートウェイがログに何も出力する前に `ResourceInitializationError` で停止する                                                                             | 実行ロールが Secrets Manager シークレットを読み取ることができない、またはプライベートサブネットが Secrets Manager または ECR へのパスを持たない                                                                                                                                                                                                                           | 実行ロールに 3 つの `gateway-` シークレット ARN に対する `secretsmanager:GetSecretValue` を付与し、NAT ゲートウェイ経由でエグレスを提供するか、NAT ゲートウェイなしで Secrets Manager、ECR、CloudWatch Logs のインターフェースエンドポイント（`awslogs` ドライバーが同じステージで必要とする）と S3 ゲートウェイエンドポイントを提供してください              |
-| ゲートウェイブートが Postgres 接続タイムアウトエラーで終了する                                                                                                       | データベースセキュリティグループがゲートウェイのセキュリティグループを 5432 で許可していない、またはサービスがデータベースの VPC 外で実行されている。ストアは 5 秒後に待機を停止します                                                                                                                                                                                                                    | データベースのセキュリティグループでゲートウェイのセキュリティグループから 5432 を許可し、サービスを DB サブネットグループと同じ VPC で実行してください                                                                                                                                                          |
+| ゲートウェイブートが Postgres 接続タイムアウトエラーで終了する                                                                                                       | データベースセキュリティグループがゲートウェイのセキュリティグループを 5432 で許可していない、またはサービスがデータベースの VPC 外で実行されている                                                                                                                                                                                                                                       | データベースのセキュリティグループでゲートウェイのセキュリティグループから 5432 を許可し、サービスを DB サブネットグループと同じ VPC で実行してください                                                                                                                                                          |
 | ゲートウェイブートが Postgres TLS 証明書検証エラーで終了する                                                                                                      | 接続文字列が `sslmode=verify-full` を設定しているが、イメージが RDS CA バンドルを信頼していない。バンドルがイメージにコピーされていない、または `NODE_EXTRA_CA_CERTS` がそれを指していない                                                                                                                                                                                              | ビルドステップの 2 つの Dockerfile 行を追加してバンドルをコピーし、`NODE_EXTRA_CA_CERTS` を設定してから、リビルドして新しいタグで プッシュし、再デプロイしてください                                                                                                                                        |
 | ストリーミング応答が静止期間後にストリーム途中でドロップする                                                                                                             | v2.1.229 より前のゲートウェイが Bedrock または AWS 上の Claude Platform 上流で、上流が静止している間（例えば、ストリーム出力のない拡張思考中）は何も送信しません。ALB はデフォルトで 60 秒間データがない場合に接続を閉じるため、そのギャップでストリームを切断します。v2.1.229 以降のゲートウェイはそのタイムアウト下で静止したストリームを保持します。これらの上流では、ゲートウェイはストリームデータがない状態で約 15 秒経過すると SSE `ping` イベントを 1 回発行し、Anthropic API 上流ではゲートウェイは API 自体のピングをリレーします | ゲートウェイを v2.1.229 以降に更新するか、`idle_timeout.timeout_seconds` 属性を `3600` に設定してください。`modify-load-balancer-attributes` または EKS の `load-balancer-attributes` Ingress アノテーション経由で設定します                                                                 |
```

</details>

<details>
<summary>claude-apps-gateway-on-gcp-ja.md</summary>

```diff
diff --git a/docs-ja/pages/claude-apps-gateway-on-gcp-ja.md b/docs-ja/pages/claude-apps-gateway-on-gcp-ja.md
index 488de45..c22e3cc 100644
--- a/docs-ja/pages/claude-apps-gateway-on-gcp-ja.md
+++ b/docs-ja/pages/claude-apps-gateway-on-gcp-ja.md
@@ -319,5 +319,5 @@ gcloud config set project "$PROJECT_ID"
 | `--no-invoker-iam-check` が `invoker_iam_disabled is not currently available` で拒否される | `constraints/run.managed.requireInvokerIam` でブロック                                      | `--allow-unauthenticated` を使用します。`constraints/iam.allowedPolicyMemberDomains` 経由の Domain Restricted Sharing もそれをブロックする場合は、GKE トラックを使用します。これはネットワークレイヤーでゲートウェイを公開し、`allUsers` バインディングはありません。 |
 | デプロイ時に `Container manifest type … must support amd64/linux`                         | イメージが非 amd64 ホストでビルドされたか、buildx が OCI イメージインデックスを発行した                                  | `--platform=linux/amd64 --provenance=false` でビルドします                                                                                                                                         |
-| ゲートウェイブートが Cloud Run で Postgres 接続タイムアウトエラーで終了                                      | Service が VPC にアタッチされていないか、Cloud SQL がその VPC にプライベート IP がない。ストアは 5 秒後に待機を停止します         | Direct VPC egress 用に `--network` および `--subnet` でデプロイし、Cloud SQL インスタンスを `--no-assign-ip` および `--network` で同じ VPC を指すように作成します                                                               |
+| ゲートウェイブートが Cloud Run で Postgres 接続タイムアウトエラーで終了                                      | Service が VPC にアタッチされていないか、Cloud SQL がその VPC にプライベート IP がない                            | Direct VPC egress 用に `--network` および `--subnet` でデプロイし、Cloud SQL インスタンスを `--no-assign-ip` および `--network` で同じ VPC を指すように作成します                                                               |
 | Agent Platform リクエストが `403 PERMISSION_DENIED` を返す                                   | ランタイムが `claude-gateway` service account を使用していないか、モデルが Model Garden でプロジェクト用に有効になっていない | Cloud Run で `--service-account` を設定するか、GKE で Workload Identity をバインドし、各 Claude モデルを Model Garden でターゲット地域用に有効にします                                                                           |
 | ストリーミング応答が固定期間後に切断される                                                               | フロントエンドリクエストタイムアウト：GKE Ingress の背後のロードバランサーバックエンドサービスはデフォルトで 30 秒、Cloud Run は 300 秒    | GKE で `timeoutSec` を上げた BackendConfig をアタッチするか、Cloud Run で `--timeout=3600` でデプロイします                                                                                                        |
```

</details>

*...以降省略*

</details>


<details>
<summary>2026-09-18</summary>

**変更ファイル:**

```
 docs-ja/pages/admin-setup-ja.md                    |    3 +-
 docs-ja/pages/agent-teams-ja.md                    |    2 +-
 docs-ja/pages/agent-view-ja.md                     |  302 +++---
 docs-ja/pages/agents-ja.md                         |   19 +-
 docs-ja/pages/amazon-bedrock-ja.md                 |    2 +-
 docs-ja/pages/artifacts-ja.md                      |    6 +-
 docs-ja/pages/authentication-ja.md                 |   12 +-
 docs-ja/pages/auto-mode-config-ja.md               |   50 +-
 docs-ja/pages/changelog.md                         |   99 ++
 docs-ja/pages/channels-ja.md                       |   32 +-
 docs-ja/pages/channels-reference-ja.md             |    2 +-
 docs-ja/pages/checkpointing-ja.md                  |    2 +-
 docs-ja/pages/claude-apps-gateway-config-ja.md     |  487 +++++----
 docs-ja/pages/claude-apps-gateway-deploy-ja.md     |   72 +-
 docs-ja/pages/claude-apps-gateway-ja.md            |   67 +-
 docs-ja/pages/claude-apps-gateway-on-gcp-ja.md     |  121 +--
 docs-ja/pages/claude-code-on-the-web-ja.md         |   70 +-
 docs-ja/pages/claude-directory-ja.md               |   26 +-
 docs-ja/pages/cli-reference-ja.md                  |  196 ++--
 docs-ja/pages/cloud-environments-ja.md             |  159 +--
 docs-ja/pages/code-review-ja.md                    |  207 +++-
 docs-ja/pages/commands-ja.md                       |   10 +-
 docs-ja/pages/context-window-ja.md                 |   29 +-
 docs-ja/pages/costs-ja.md                          |    2 +-
 docs-ja/pages/cross-session-messaging-ja.md        |  142 +--
 docs-ja/pages/data-usage-ja.md                     |   34 +-
 docs-ja/pages/debug-your-config-ja.md              |   38 +-
 docs-ja/pages/desktop-ios-simulator-ja.md          |    2 +-
 docs-ja/pages/desktop-ja.md                        |   36 +-
 docs-ja/pages/desktop-quickstart-ja.md             |    4 +-
 docs-ja/pages/devcontainer-ja.md                   |    4 +-
 docs-ja/pages/discover-plugins-ja.md               |    7 +-
 docs-ja/pages/errors-ja.md                         |  469 ++++++---
 docs-ja/pages/fast-mode-ja.md                      |   19 +-
 docs-ja/pages/feature-availability-ja.md           |    4 +-
 docs-ja/pages/features-overview-ja.md              |    2 +-
 docs-ja/pages/fullscreen-ja.md                     |    1 +
 docs-ja/pages/github-actions-cloud-providers-ja.md |    2 +-
 docs-ja/pages/github-actions-ja.md                 |    4 +-
 docs-ja/pages/github-enterprise-server-ja.md       |   44 +-
 docs-ja/pages/glossary-ja.md                       |   25 +-
 docs-ja/pages/goal-ja.md                           |   40 +-
 docs-ja/pages/how-claude-code-works-ja.md          |    2 +-
 docs-ja/pages/interactive-mode-ja.md               |    1 +
 docs-ja/pages/jetbrains-ja.md                      |    2 +-
 docs-ja/pages/llm-gateway-protocol-ja.md           |    4 +-
 docs-ja/pages/managed-mcp-ja.md                    |    5 +-
 docs-ja/pages/managed-settings-ja.md               |   11 +-
 docs-ja/pages/mcp-ja.md                            |   74 +-
 docs-ja/pages/mcp-quickstart-ja.md                 |    4 +-
 docs-ja/pages/memory-ja.md                         |  214 ++--
 docs-ja/pages/mobile-ja.md                         |   16 +-
 docs-ja/pages/monitoring-usage-ja.md               | 1073 ++++++++++++--------
 docs-ja/pages/overview-ja.md                       |   24 +-
 docs-ja/pages/permission-modes-ja.md               |  293 +++---
 docs-ja/pages/permissions-ja.md                    |   43 +-
 docs-ja/pages/platforms-ja.md                      |    3 +-
 docs-ja/pages/plugin-dependencies-ja.md            |    2 +-
 docs-ja/pages/plugin-marketplaces-ja.md            |  302 +++---
 docs-ja/pages/plugins-ja.md                        |   12 +-
 docs-ja/pages/plugins-reference-ja.md              |  151 +--
 docs-ja/pages/prompt-caching-ja.md                 |    4 +-
 docs-ja/pages/remote-control-ja.md                 |   38 +-
 docs-ja/pages/routines-ja.md                       |   84 +-
 docs-ja/pages/sandbox-environments-ja.md           |   48 +-
 docs-ja/pages/scheduled-tasks-ja.md                |    2 +-
 docs-ja/pages/security-guidance-ja.md              |    4 +-
 docs-ja/pages/security-ja.md                       |    4 +-
 .../self-hosted-environments-configuration-ja.md   |   28 +-
 .../pages/self-hosted-environments-deploy-ja.md    |    8 +-
 docs-ja/pages/self-hosted-environments-ja.md       |    4 +-
 .../pages/self-hosted-environments-reference-ja.md |    3 +
 .../pages/self-hosted-environments-testing-ja.md   |    6 +-
 docs-ja/pages/server-managed-settings-ja.md        |    2 +-
 docs-ja/pages/settings-example-ja.md               |    2 +-
 docs-ja/pages/settings-ja.md                       |   15 +-
 docs-ja/pages/settings-reference-ja.md             |  580 ++++++-----
 docs-ja/pages/setup-ja.md                          |    2 +-
 docs-ja/pages/slack-ja.md                          |   50 +-
 docs-ja/pages/statusline-ja.md                     |    6 +-
 docs-ja/pages/sub-agents-ja.md                     |  831 +++++++++------
 docs-ja/pages/terminal-config-ja.md                |    2 +-
 docs-ja/pages/third-party-integrations-ja.md       |    2 +-
 docs-ja/pages/tools-reference-ja.md                |   29 +-
 docs-ja/pages/ultrareview-ja.md                    |   32 +-
 docs-ja/pages/voice-dictation-ja.md                |   48 +-
 docs-ja/pages/vs-code-ja.md                        |   11 +-
 docs-ja/pages/web-quickstart-ja.md                 |   62 +-
 docs-ja/pages/workflows-ja.md                      |  115 ++-
 docs-ja/pages/zero-data-retention-ja.md            |   15 +-
 90 files changed, 4210 insertions(+), 2917 deletions(-)
```

**新規追加:**


<details>
<summary>admin-setup-ja.md</summary>

```diff
diff --git a/docs-ja/pages/admin-setup-ja.md b/docs-ja/pages/admin-setup-ja.md
index cbc402c..fc8322d 100644
--- a/docs-ja/pages/admin-setup-ja.md
+++ b/docs-ja/pages/admin-setup-ja.md
@@ -103,5 +103,6 @@ WSL 2 ユーティリティ VM 内のプロセスは、Windows 側のエンド
 | [MCP サーバー制御](/docs/ja/managed-mcp)                                                | ユーザーが追加または接続できる MCP サーバーを制限し、固定セットをデプロイするか、リモートサーバーをすべてのユーザーに提供します                                                                                                                                                                                                                                                                                                                                                                                                                                           | `allowedMcpServers`、`deniedMcpServers`、`allowManagedMcpServersOnly`、`managedMcpServers`、またはデプロイされた `managed-mcp.json` ファイル          |
 | [プラグインマーケットプレイス制御](/docs/ja/plugin-marketplaces#managed-marketplace-restrictions) | ユーザーが追加およびインストールできるマーケットプレイスソースを制限し、単一実行のためにプラグイン、エージェント、MCP サーバーをサイドロードする CLI フラグを拒否し、[`command` プラグインソース](/docs/ja/plugin-marketplaces#command-sources)をブロックし、どのマーケットプレイスのプラグインを提案できるかをホワイトリストに登録します                                                                                                                                                                                                                                                                                                            | `strictKnownMarketplaces`、`blockedMarketplaces`、`disableSideloadFlags`、`disableCommandPluginSources`、`pluginSuggestionMarketplaces` |
-| [カスタマイズロックダウン](/docs/ja/settings-reference#strictpluginonlycustomization)         | スキル、エージェント、フック、MCP サーバーをユーザーおよびプロジェクトソースからブロックし、プラグインまたはマネージド設定からのみ取得できるようにします                                                                                                                                                                                                                                                                                                                                                                                                                               | `strictPluginOnlyCustomization`                                                                                                     |
+| [カスタマイズロックダウン](/docs/ja/settings-reference#strictpluginonlycustomization)         | スキル、エージェント、フック、MCP サーバーをユーザーおよびプロジェクトソースからブロックし、プラグインまたはマネージド設定からのみ取得できるようにします。スキルをロックすると、開発者が claude.ai で有効にした[スキル](/docs/ja/skills#where-synced-skills-load)の同期も停止します                                                                                                                                                                                                                                                                                                                                           | `strictPluginOnlyCustomization`                                                                                                     |
+| [claude.ai 同期を無効にする](/docs/ja/settings-reference#syncclaudeaiskills)              | Claude Code が開発者が claude.ai で有効にした[スキル](/docs/ja/skills#how-synced-skills-behave)と[プラグイン](/docs/ja/plugins-reference#synced-plugins)を読み込むのを停止します。組織の claude.ai でスキルをオフにすると、Claude Code は両方の同期を停止します。v2.1.273 以降では、既に同期したものも削除します。スキルをオフにせずにどちらか一方を停止するには、マネージド設定でそのキーを `false` に設定します                                                                                                                                                                                                                                  | `syncClaudeAiSkills`、`syncClaudeAiPlugins`                                                                                          |
 | [フック制限](/docs/ja/settings-reference#allowmanagedhooksonly)                        | 実行するフックを制限し、HTTP フック URL を制限します。[`allowManagedHooksOnly` で実行される内容](/docs/ja/settings-reference#what-runs-under-allowmanagedhooksonly)の完全な効果リストを参照してください                                                                                                                                                                                                                                                                                                                                                           | `allowManagedHooksOnly`、`allowedHttpHookUrls`                                                                                       |
 | [ログイン強制](/docs/ja/settings-reference#forceloginmethod)                            | ログインを特定の方法または Anthropic 組織に制限します。メソッド制限は VS Code 拡張機能、Agent SDK、`claude setup-token`、`/install-github-app` 全体に適用され、ターミナルのインタラクティブログイン画面（`/login` または初回オンボーディングで到達）はメソッドを事前選択しますが強制しません。Claude Code は、ターミナル、VS Code 拡張機能、Agent SDK での claude.ai アカウントログインの組織を検証し、Claude Console ログインまたは[ゲートウェイ](/docs/ja/claude-apps-gateway)サインインではチェックしません。v2.1.212 より前は、ターミナルログインのみが両方のキーを適用していました。設定すると、`ANTHROPIC_API_KEY`、`ANTHROPIC_AUTH_TOKEN`、または `apiKeyHelper` によって認証されたセッションはスタートアップでブロックされます。クラウドプロバイダーセッションは影響を受けません | `forceLoginMethod`、`forceLoginOrgUUID`                                                                                              |
```

</details>

<details>
<summary>agent-teams-ja.md</summary>

```diff
diff --git a/docs-ja/pages/agent-teams-ja.md b/docs-ja/pages/agent-teams-ja.md
index 1d7598d..a6888da 100644
--- a/docs-ja/pages/agent-teams-ja.md
+++ b/docs-ja/pages/agent-teams-ja.md
@@ -121,5 +121,5 @@ v2.1.199 以降、アイドル状態のチームメンバーの行は、他の
 </Note>
 
-デフォルトは `"in-process"` です。v2.1.179 より前は、デフォルトは `"auto"` でした。そのため、以前に分割ペインを開いたアップグレードされたセッションは、モードを明示的に設定しない限り、1 つのターミナルに留まります。`"auto"` を設定して、既に tmux セッション内で実行している場合または使用しているターミナルが iTerm2 で `it2` CLI がインストールされている場合は分割ペインを有効にし、それ以外の場合は in-process にフォールバックします。`"tmux"` 設定は分割ペインモードを有効にし、ターミナルに基づいて tmux または iTerm2 を使用するかどうかを自動検出します。
+デフォルトは `"in-process"` です。`"auto"` を設定して、既に tmux セッション内で実行している場合または使用しているターミナルが iTerm2 で `it2` CLI がインストールされている場合は分割ペインを有効にし、それ以外の場合は in-process にフォールバックします。`"tmux"` 設定は分割ペインモードを有効にし、ターミナルに基づいて tmux または iTerm2 を使用するかどうかを自動検出します。
 
 v2.1.186 以降、`"iterm2"` を設定して iTerm2 ネイティブ分割ペインを明示的に使用してください。このモードは [`it2` CLI](https://github.com/mkusaka/it2) が必要で、`it2` が見つからない場合はインストールコマンド付きでエラーを表示します。`it2` をインストールするか tmux に切り替えるオプションを提供するセットアッププロンプトは、ターミナルが iTerm2 で tmux がフォールバックとして利用可能な場合、`"auto"` または `"tmux"` の下に表示されます。
```

</details>

<details>
<summary>agent-view-ja.md</summary>

```diff
diff --git a/docs-ja/pages/agent-view-ja.md b/docs-ja/pages/agent-view-ja.md
index de10ff7..c4bb971 100644
--- a/docs-ja/pages/agent-view-ja.md
+++ b/docs-ja/pages/agent-view-ja.md
@@ -17,5 +17,5 @@ Claude が複数の独立したタスクに対して、あなたが毎ステッ
 任意のエージェントのセッションでより直接的に作業したい場合は、行にアタッチして完全な会話に入ります。
 
-エージェントビューを subagents、agent teams、worktrees と比較するには、[エージェントを並列で実行する](/docs/ja/agents)を参照してください。
+エージェントビューを subagents、agent teams、worktrees と比較するには、[エージェントを並列で実行する](/docs/ja/agents)を参照してください。エージェントビューはあなたのマシン上でセッションを実行し、各セッションをディスパッチします。1 つの会話からクラウドで Claude が並列セッションを開始して追跡するには、[Projects](/docs/ja/claude-projects)を参照してください。
 
 <Note>
@@ -341,5 +341,5 @@ Claude Code v2.1.212 以降でセッションを戻すには、ディスパッ
 </h2>
 
-エージェントビューから新しいバックグラウンドセッションをディスパッチするか、既存のインタラクティブセッションをバックグラウンドに送信するか、シェルから直接開始できます。
+エージェントビューから新しいバックグラウンドセッションをディスパッチしたり、既存のインタラクティブセッションをバックグラウンドに送信またはコピーしたり、シェルから直接開始したりできます。
 
 <h3 id="from-agent-view">
@@ -347,36 +347,36 @@ Claude Code v2.1.212 以降でセッションを戻すには、ディスパッ
 </h3>
 
-エージェントビューの下部の入力にプロンプトを入力して `Enter` を押すと、新しいバックグラウンドセッションが開始されます。セッションはプロンプトから自動的に名前が付けられます。後で `Ctrl+R` で名前を変更できます。
+エージェントビューの下部の入力にプロンプトを入力して `Enter` キーを押すと、新しいバックグラウンドセッションが開始されます。セッションはプロンプトから自動的に名前が付けられます。後で `Ctrl+R` で名前を変更できます。
 
-自動名は [Haiku クラスモデル](/docs/ja/model-config) によって書かれた短いラベルです。セッションが後で取得する名前もその行に表示されます。これには、そのセッションで [プランを承認](/docs/ja/permission-modes#review-and-approve-a-plan) するときに生成される [タイトル](/docs/ja/sessions#name-your-sessions) も含まれます。
+自動名は [Haiku クラスモデル](/docs/ja/model-config) によって書かれた短いラベルです。セッションが後で取得する名前もその行に表示されます。これには、そのセッションで [プランを承認](/docs/ja/permission-modes#review-and-approve-a-plan) するときにセッションが取得する [生成されたタイトル](/docs/ja/sessions#name-your-sessions) が含まれます。
 
-プロンプトに画像を貼り付けて、タスクにスクリーンショットまたは図を含めます。
+プロンプトに画像を貼り付けて、スクリーンショットまたは図をタスクに含めることができます。
 
```

</details>

<details>
<summary>agents-ja.md</summary>

```diff
diff --git a/docs-ja/pages/agents-ja.md b/docs-ja/pages/agents-ja.md
index 59ee566..6faf8f2 100644
--- a/docs-ja/pages/agents-ja.md
+++ b/docs-ja/pages/agents-ja.md
@@ -5,14 +5,15 @@
 # エージェントを並列実行する
 
-> Claude Code が複数のタスクを同時に実行する方法を比較します。サブエージェント、エージェントビュー、エージェントチーム、および動的ワークフローについて説明します。
+> Claude Code が複数のタスクを同時に実行する 5 つの方法を比較します。サブエージェント、エージェントビュー、エージェントチーム、動的ワークフロー、およびプロジェクトについて説明します。
 
-[サブエージェント](/docs/ja/sub-agents)、[エージェントビュー](/docs/ja/agent-view)、[エージェントチーム](/docs/ja/agent-teams)、および [動的ワークフロー](/docs/ja/workflows) は、それぞれ異なる方法で作業を並列化します。どれを選ぶかは、各会話に自分で留まりたいのか、タスクを引き継いで後で確認したいのか、それとも Claude に一群のワーカーを調整させたいのかによって異なります。
+Claude Code には、複数のタスクを同時に処理する 5 つの方法があります。[サブエージェント](/docs/ja/sub-agents)、[エージェントビュー](/docs/ja/agent-view)、[エージェントチーム](/docs/ja/agent-teams)、[動的ワークフロー](/docs/ja/workflows)、および [プロジェクト](/docs/ja/claude-projects) です。これらは、各会話に自分で留まるのか、Claude にワーカーのグループを調整させるのかという関与の度合いや、作業がマシン上で実行されるのかクラウドで実行されるのかという点で異なります。
 
-| アプローチ                        | 提供内容                                                                    | 使用する場合                                                                      |
-| :--------------------------- | :---------------------------------------------------------------------- | :-------------------------------------------------------------------------- |
-| [サブエージェント](/docs/ja/sub-agents)   | 1 つのセッション内で委任されたワーカーが、独自のコンテキストでサイドタスクを実行し、サマリーを返す                      | サイドタスクが検索結果、ログ、またはファイルコンテンツで主な会話を埋め尽くす場合（再度参照しない）                           |
-| [エージェントビュー](/docs/ja/agent-view)  | `claude agents` で開く、バックグラウンドで実行されているセッションをディスパッチして監視する 1 つの画面。リサーチプレビュー | 複数の独立したタスクがあり、それらを引き継いで、一目で状態を確認し、必要な場合のみ介入したい場合                            |
-| [エージェントチーム](/docs/ja/agent-teams) | 共有タスクリストとエージェント間メッセージングを備えた複数の調整されたセッション。リーダーによって管理される。実験的で、デフォルトでは無効   | Claude にプロジェクトを分割させ、割り当てさせ、ワーカーを同期させたい場合                                    |
-| [動的ワークフロー](/docs/ja/workflows)    | 多くのサブエージェントを実行し、その結果をチェックするスクリプト。1 回のターンで調整するには大きすぎるジョブ向け               | タスクが大きすぎてサブエージェント数個では対応できない場合。コードベース全体の監査、500 ファイルのマイグレーション、または相互検証が必要な調査など |
+| アプローチ                         | 提供内容                                                                                                                                                               | 使用する場合                                                                                                         |
+| :---------------------------- | :----------------------------------------------------------------------------------------------------------------------------------------------------------------- | :------------------------------------------------------------------------------------------------------------- |
+| [サブエージェント](/docs/ja/sub-agents)    | 1 つのセッション内で委任されたワーカーが、独自のコンテキストでサイドタスクを実行し、サマリーを返す                                                                                                                 | サイドタスクが検索結果、ログ、またはファイルコンテンツで主な会話を埋め尽くす場合（再度参照しない）                                                              |
+| [エージェントビュー](/docs/ja/agent-view)   | `claude agents` で開く、バックグラウンドで実行されているセッションをディスパッチして監視する 1 つの画面。リサーチプレビュー                                                                                            | 複数の独立したタスクがあり、それらを引き継いで、一目で状態を確認し、必要な場合のみ介入したい場合                                                               |
+| [エージェントチーム](/docs/ja/agent-teams)  | 共有タスクリストとエージェント間メッセージングを備えた複数の調整されたセッション。リーダーによって管理される。実験的で、デフォルトでは無効                                                                                              | Claude にプロジェクトを分割させ、割り当てさせ、ワーカーを同期させたい場合                                                                       |
+| [プロジェクト](/docs/ja/claude-projects) | claude.ai/code またはデスクトップアプリでの 1 つの継続的な会話。Claude は threads と呼ばれる並列クラウドセッションを開始し、各セッションにプロジェクトのリポジトリ、指示、およびメモリを提供し、どのセッションがあなたを必要としているかを表示します。Pro および Max でのパブリックベータ | 作業が数日または数週間にわたる多くのタスクに及び、マシンがオフの場合でも実行を続け、各セッションをディスパッチして追跡するのではなく、一度説明したい場合                                   |
+| [動的ワークフロー](/docs/ja/workflows)     | 多くのサブエージェントを実行し、その結果をチェックするスクリプト。1 回のターンで調整するには大きすぎるジョブ向け                                                                                                          | タスクが大きすぎてサブエージェント数個では対応できない場合、または検出結果を相互に検証したい場合。コードベース全体の監査、500 ファイルのマイグレーション、相互検証が必要な調査、または複数の角度から作成されたプランなど |
 
 すべてのアプローチにおいて、ワーカーは Claude セッションです。別のツールを関与させるには、それを Claude に [MCP サーバー](/docs/ja/mcp) として公開します。
@@ -21,5 +22,5 @@
 
```

</details>

<details>
<summary>amazon-bedrock-ja.md</summary>

```diff
diff --git a/docs-ja/pages/amazon-bedrock-ja.md b/docs-ja/pages/amazon-bedrock-ja.md
index 28aa514..0a62bae 100644
--- a/docs-ja/pages/amazon-bedrock-ja.md
+++ b/docs-ja/pages/amazon-bedrock-ja.md
@@ -520,5 +520,5 @@ Claude Code は、各リクエストで `X-Amzn-Bedrock-Service-Tier` ヘッダ
 </h2>
 
-Mantle は、Bedrock Invoke API ではなく、ネイティブ Anthropic API シェイプを通じて Claude モデルを提供する Amazon Bedrock エンドポイントです。同じ AWS 認証情報、IAM 権限、および `awsAuthRefresh` 設定を使用します。このページで前述したものです。
+Mantle は、Bedrock Invoke API ではなく、ネイティブ Anthropic API シェイプを通じて Claude モデルを提供する Amazon Bedrock エンドポイントです。同じ [AWS 認証情報](#2-configure-aws-credentials)、[IAM 権限](#iam-configuration)、および [`awsAuthRefresh` 設定](#advanced-credential-configuration) を使用します。
 
 <h3 id="enable-mantle">
```

</details>

<details>
<summary>artifacts-ja.md</summary>

```diff
diff --git a/docs-ja/pages/artifacts-ja.md b/docs-ja/pages/artifacts-ja.md
index 210a1d4..50a55ac 100644
--- a/docs-ja/pages/artifacts-ja.md
+++ b/docs-ja/pages/artifacts-ja.md
@@ -11,5 +11,5 @@
 </Note>
 
-アーティファクトは、Claude Code がセッションから claude.ai 上のプライベート URL に公開するライブでインタラクティブな Web ページです。ブラウザで開くと、セッションが続く間、その場で更新されます。他の人にも見てもらいたい場合は、ページヘッダーから共有します。
+[アーティファクト](https://claude.com/features/artifacts)は、Claude Code がセッションから claude.ai 上のプライベート URL に公開するライブでインタラクティブな Web ページです。ブラウザで開くと、セッションが続く間、その場で更新されます。他の人にも見てもらいたい場合は、ページヘッダーから共有します。
 
 <Frame>
@@ -143,5 +143,5 @@ Read the comments on https://claude.ai/code/artifact/5fbea6f3-... and make the c
 ```
 
-Claude がコメントを読めないと言う場合は、3 つのことを確認してください。
+Claude がコメントを読めないと言う場合は、バージョン、セッション、フィーチャーフラグ設定を確認してください。
 
 * Claude Code v2.1.221 以降を実行しています。
@@ -332,5 +332,5 @@ UI、画面フロー、ランディングページ、またはポスターをモ
 | ダウンロード     | ページはダウンロードを自身で開始することはできません。ビューアがページが生成するファイルを保存できるようにするには、Claude はダウンロード機能を宣言します。[ファイルダウンロードを提供する](#offer-a-file-download)を参照してください。                                                                                                                                                                                                                                                                                                                                                       |
 | シングルページ    | 相対リンクは解決されません。ページと一緒に何もデプロイされていないためです。マルチセクションコンテンツの場合、Claude は個別ファイルではなくページ内アンカーを使用します。                                                                                                                                                                                                                                                                                                                                                                                                   |
-| ソースファイルタイプ | 公開されるファイルは `.html`、`.htm`、または `.md` である必要があり、UTF-8 として、またはバイトオーダーマークによってリトルエンディアン UTF-16 としてデコードできる必要があります。Markdown ファイルはスタイル付き HTML としてレンダリングされます。デコードできないファイル、または置換文字 `U+FFFD` を含むファイルは、[修正する行と列とともに拒否されます](/docs/ja/errors#the-source-file-is-not-valid-utf-8-text)。                                                                                                                                                                                                                         |
+| ソースファイルタイプ | 公開されるファイルは `.html`、`.htm`、または `.md` である必要があり、UTF-8 として、またはバイトオーダーマークによってリトルエンディアン UTF-16 としてデコードできる必要があります。Markdown ファイルはスタイル付きドキュメントページとしてレンダリングされ、構文強調表示されたコードが含まれます。デコードできないファイル、または置換文字 `U+FFFD` を含むファイルは、[修正する行と列とともに拒否されます](/docs/ja/errors#the-source-file-is-not-valid-utf-8-text)。                                                                                                                                                                                                     |
 | レンダリングサイズ  | レンダリングされたページは 16 MiB 以下である必要があります。大きな埋め込み画像は、公開が失敗する場合の通常の原因です。                                                                                                                                                                                                                                                                                                                                                                                                                            |
 
```

</details>

<details>
<summary>authentication-ja.md</summary>

```diff
diff --git a/docs-ja/pages/authentication-ja.md b/docs-ja/pages/authentication-ja.md
index deed654..5807b96 100644
--- a/docs-ja/pages/authentication-ja.md
+++ b/docs-ja/pages/authentication-ja.md
@@ -7,5 +7,5 @@
 > Claude Code にログインし、個人、チーム、組織向けの認証を設定します。
 
-Claude Code は、セットアップに応じて複数の認証方法をサポートしています。個人ユーザーは Claude.ai アカウントでログインでき、チームは Claude for Teams または Enterprise、Claude Console、または Amazon Bedrock、Google Cloud の Agent Platform、Microsoft Foundry などのクラウドプロバイダーを使用できます。
+Claude Code は、セットアップに応じて複数の認証方法をサポートしています。個人ユーザーは claude.ai アカウントでログインでき、チームは Claude for Teams または Enterprise、Claude Console、または Amazon Bedrock、Google Cloud の Agent Platform、Microsoft Foundry などのクラウドプロバイダーを使用できます。
 
 <h2 id="log-in-to-claude-code">
@@ -23,6 +23,6 @@ Claude Code は、セットアップに応じて複数の認証方法をサポ
 以下のいずれかのアカウントタイプで認証できます。
 
-* **Claude Pro または Max サブスクリプション**: Claude.ai アカウントでログインします。[claude.com/pricing](https://claude.com/pricing?utm_source=claude_code\&utm_medium=docs\&utm_content=authentication_pro_max) で購読してください。
-* **Claude for Teams または Enterprise**: チーム管理者が招待した Claude.ai アカウントでログインします。
+* **Claude Pro または Max サブスクリプション**: claude.ai アカウントでログインします。[claude.com/pricing](https://claude.com/pricing?utm_source=claude_code\&utm_medium=docs\&utm_content=authentication_pro_max) で購読してください。
+* **Claude for Teams または Enterprise**: チーム管理者が招待した claude.ai アカウントでログインします。
 * **Claude Console**: Console 認証情報でログインします。管理者が事前に[招待](#claude-console-authentication)している必要があります。[API キーを作成せずにサインイン](#sign-in-without-an-api-key)することも、API キーを作成することもできます。
 * **クラウドプロバイダー**: 組織が [Amazon Bedrock](/docs/ja/amazon-bedrock)、[Google Cloud の Agent Platform](/docs/ja/google-vertex-ai)、または [Microsoft Foundry](/docs/ja/microsoft-foundry) を使用している場合は、`claude` を実行する前に必要な環境変数を設定するか、ログインプロンプトで **3rd-party platform** を選択してください。これにより、Bedrock と Vertex AI 向けのインタラクティブセットアップウィザードが起動します。ブラウザログインは不要です。
@@ -67,5 +67,5 @@ Claude Code は、セットアップに応じて複数の認証方法をサポ
 
   <Step title="インストールしてログイン">
-    チームメンバーは Claude Code をインストールし、Claude.ai アカウントでログインします。
+    チームメンバーは Claude Code をインストールし、claude.ai アカウントでログインします。
   </Step>
 </Steps>
@@ -191,5 +191,5 @@ Claude Code は認証情報を安全に管理します。
   * `CLAUDE_CONFIG_DIR` 環境変数を設定している場合、Claude Code は `.credentials.json` ファイルをそのディレクトリの下に保存します。これには macOS フォールバックが書き込むファイルも含まれ、macOS Keychain エントリもそのディレクトリをキーとします。そのため、異なる `CLAUDE_CONFIG_DIR` を持つセッションは異なるエントリを読み込みます。
   * Claude Code は `/login` と `/logout` を通じて `.credentials.json` を管理します。リクエストをカスタム API エンドポイント経由でルーティングするには、代わりに [`ANTHROPIC_BASE_URL`](/docs/ja/env-vars) 環境変数を設定してください。
```

</details>

<details>
<summary>auto-mode-config-ja.md</summary>

```diff
diff --git a/docs-ja/pages/auto-mode-config-ja.md b/docs-ja/pages/auto-mode-config-ja.md
index 463ff19..3b100c3 100644
--- a/docs-ja/pages/auto-mode-config-ja.md
+++ b/docs-ja/pages/auto-mode-config-ja.md
@@ -92,27 +92,29 @@ Claude のプッシュおよびプルリクエストコマンドの前に人間
 </h2>
 
-ほとんどの組織では、`autoMode.environment` が唯一設定する必要があるフィールドです。これは分類器にどのリポジトリ、バケット、ドメインが信頼できるかを伝えます。分類器はこれを使用して「外部」が何を意味するかを決定するため、リストに記載されていない宛先は潜在的なデータ流出ターゲットになります。
+ほとんどの組織では、`autoMode.environment` が設定する必要がある唯一のフィールドです。これは分類器にどのリポジトリ、バケット、ドメインが信頼できるかを伝えます。分類器はこれを使用して「外部」が何を意味するかを決定するため、リストに記載されていない宛先は潜在的なデータ流出ターゲットです。
 
 Claude Code v2.1.198 以降、`claude auto-mode defaults` は 3 種類の環境エントリを出力します。v2.1.195 より前のバージョンは最初の 5 つの信頼スロットのみを出力します。
 
 * **コンテキストスロット**: 組織、スタック、セキュリティ体制を説明し、分類器がコンテキスト内の他のルールを読み取れるようにします。各スロットはデフォルトで `None configured` または次に示す保守的な仮定に設定されます。
-  * **Organization**
+  * **Organization（組織）**
   * **Claude Code の主な用途**: ソフトウェア開発がデフォルト
   * **クラウドプロバイダー**
-  * **リポジトリの可視性**: リポジトリはリモートホストと名前が別途示さない限りプライベートと見なされます。または、分類器が読み取る会話の前の可視性チェックでそれがパブリックであることが示されます。分類器はクロード Code が実行するコマンドとメッセージを読み取り、その出力は読み取りません。そのため、証拠はリポジトリをパブリックとして名前を付けるメッセージなど、読み取ることができるものである必要があります。`gh repo view` の出力だけではそこに到達しません。トランスクリプト証拠チェックには Claude Code v2.1.200 以降が必要です
+  * **リポジトリの可視性**: リポジトリはリモートホストと名前が別途示さない限りプライベートと見なされます。または分類器が会話の前の段階で読み取った可視性チェックでそれがパブリックであることが示されている場合。
+
+    Claude Code 自体が送信する分類器リクエストでは、分類器はメッセージと Claude が実行するコマンドを読み取り、その出力は読み取りません。証拠は分類器が読み取ることができるもの（リポジトリをパブリックとして名前を付けた独自のメッセージなど）である必要があります。`gh repo view` の出力だけではそこに到達しません。トランスクリプト証拠チェックには Claude Code v2.1.200 以降が必要です
   * **内部共有 / スニペットホスティング**: パブリックペーストおよび gist サービスは、名前を付けるまで信頼境界の外側として扱われます
   * **組織固有の CLI**
   * **シークレット管理**
   * **CI/CD デプロイターゲット**
-  * **ネットワークポスチャ**
-  * **ホスト封じ込め**: デフォルトは、オープンインターネットを備えた通常の開発者マシンまたは CI ランナーです。Claude Code がエグレス許可リストまたは接触してはいけないネイバーを持つコンテナ、VM、またはポッドで実行される場合は、許可されたホスト、クラウドメタデータエンドポイントに到達可能かどうか、およびタスクが使用するクラウドプロジェクト、クラスタ、またはレジストリとそれが使用する ID を名前付けします。このエントリがその ID を名前付けするまで、分類器は [ホストの独自の認証情報のリクエストをブロック](/docs/ja/permission-modes#what-the-classifier-blocks-by-default) します。Claude Code v2.1.257 以降が必要です
-  * **保護されたデプロイメント名前空間 / 環境**: 名前を付けるまで、機密リモートターゲットヒューリスティックにフォールバックします
+  * **ネットワーク体制**
+  * **ホスト隔離**: デフォルトは、オープンインターネットを備えた通常の開発者マシンまたは CI ランナーです。Claude Code がコンテナ、VM、またはポッド内で実行され、エグレス許可リストまたは接触してはいけないネイバーがある場合は、許可されたホスト、クラウドメタデータエンドポイントに到達可能かどうか、およびタスクが使用するクラウドプロジェクト、クラスタ、またはレジストリと使用する ID を名前付けします。このエントリがその ID を名前付けするまで、分類器は[ホストの独自の認証情報に対するリクエストをブロック](/docs/ja/permission-modes#what-the-classifier-blocks-by-default)します。Claude Code v2.1.257 以降が必要です
```

</details>

*...以降省略*

</details>


<details>
<summary>2026-09-17</summary>

**変更ファイル:**

```
 docs-ja/pages/changelog.md | 111 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 111 insertions(+)
```

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index b2323fc..4dd31b5 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,115 @@
 # Changelog
 
+## 2.1.274
+
+- Added a visible warning when memory usage is critical, with steps to free memory or restart safely
+- Added `CLAUDE_CODE_MCP_STARTUP_WAIT_MS` to bound how long the first non-interactive turn waits for connecting MCP servers (`0` = don't wait)
+- Added `effort` attribute to the `claude_code.llm_request` OpenTelemetry trace span, matching the `api_request` event
+- Added `claude_code.managed_settings_resolved` OTel event: managed-settings sources and policy helper state; redacted settings and digests with `OTEL_LOG_MANAGED_SETTINGS=1`
+- Added `store.connect_timeout_seconds` to the Claude apps gateway config to lengthen the Postgres connect timeout (default 5 seconds), and improved the boot error when the database is unreachable to point to `store.postgres_url` and the configured timeout
+- Added `enduser.sub`, the IdP subject, to the telemetry Claude Desktop and Cowork send through a Claude apps gateway
+- Added a Claude apps gateway warning when a replica has more requests open than the 256 it sends upstream at once, and a startup log line showing that limit
+- Added click-to-expand for collapsed teammate and agent messages in fullscreen mode
+- Fixed sessions getting stuck endlessly retrying "unexpected tool_use_id" 400 errors: corrupted transcripts now self-heal where possible, and otherwise a clear error (with a `/rewind` hint) ends the loop
+- Fixed MCP servers configured as `http` that only speak legacy HTTP+SSE failing to connect when they answer the first request with 422 or another 4xx error
+- Fixed Streamable HTTP MCP tool calls timing out after about 5 minutes even when a longer per-server `timeout` was set
+- Fixed MCP prompts and resources not refreshing when a server sends list-changed notifications without declaring `listChanged`
+- Fixed MCP tool calls refused with 403 insufficient_scope being reported as an expired sign-in: the error now names the missing permissions and points to `/mcp` re-authentication
+- Fixed hook-driven sessions (such as an active `/goal`) ending with "Prompt is too long" instead of compacting when the context overflowed again after a reactive compaction
+- Fixed an active `/goal` being lost when resuming (`--continue` / `--resume`) a session that had compacted
+- Fixed `claude agents` losing `--model`, `--effort`, `--permission-mode`, `--allow-dangerously-skip-permissions` and `--agent` after an auto-update relaunch
+- Fixed a per-turn slowdown when a language server publishes project-wide diagnostics for thousands of files
+- Fixed subagents with `model: "opus"` on Bedrock, Vertex or Foundry leaving the session's model when its id has no recognizable model family (unless `ANTHROPIC_DEFAULT_OPUS_MODEL` is set)
+- Fixed self-hosted runner sessions failing every turn with a 401 after a few failed token refreshes, until the next scheduled refresh; the runner now keeps retrying, and fetches a new token after a 401
+- Fixed clickable links to local file paths doing nothing in VS Code and other terminals that require a `file://` URI
+- Fixed the transcript renumbering ordered lists in your own messages (typing "3. 2. 1." displayed "3. 4. 5."); numbers and "N)" markers now show as typed
```

</details>

</details>


<details>
<summary>2026-09-16</summary>

**変更ファイル:**

```
 docs-ja/pages/changelog.md         | 67 ++++++++++++++++++++++++++++++++++++++
 docs-ja/pages/context-window-ja.md |  8 ++---
 2 files changed, 70 insertions(+), 5 deletions(-)
```

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index 62e075d..b2323fc 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,71 @@
 # Changelog
 
+## 2.1.273
+
+- Added `x-claude-code-request-class`, `x-claude-code-agent-type`, `x-claude-code-prev-tool-durations`, `x-claude-code-compaction` and `x-claude-code-context-compacted` request headers for LLM gateways; opt in with `CLAUDE_CODE_GATEWAY_HINT_HEADERS=1`
+- Added a notification when an MCP server disconnects mid-session and automatic reconnection gives up, pointing at `/mcp`
+- Added forking a session started with `claude --remote-control` or `/remote-control` from the Claude app; the fork runs as a background session on your computer
+- Fixed Bash commands the permission checker cannot fully analyze skipping the prompt under `permissions.blockReadsOutsideWorkingDirectories`, and a subshell hiding a dangerous `rm` in bypass mode
+- Fixed skills synced from claude.ai staying available after your organization turns Skills off; they now move to the recoverable trash
+- Fixed `allowManagedMcpServersOnly`, `deniedMcpServers` and `disableClaudeAiConnectors` set via MDM or `managed-settings.json` being ignored when server-managed settings are also present
+- Fixed 401/403 errors on Bedrock, Vertex and Foundry, and Claude apps gateway 403s, telling you to run `/login`; the message now names the credential to refresh or points to your gateway administrator
+- Fixed `/login`, `/upgrade`, and `/extra-usage` discarding earlier thinking from the conversation, which forced a full prompt-cache rewrite on the next request
+- Fixed auto mode stopping for approval when the Artifact tool uploads a file you attached to the chat in a cloud or Remote Control session
+- Fixed a long-running session recreating a stub `.git/info/exclude` after the repository's `.git` directory was removed or moved away
+- Fixed the main prompt dropping a `!` typed at the start while already in shell mode, so negated commands like `! grep …` can be typed
+- Fixed Read on macOS refusing a dragged-in screenshot, or any file the system reports under a second path, with "symlink resolution changed after permission was checked"
+- Fixed `permissions.blockReadsOutsideWorkingDirectories`: a memory directory chosen by a repository's settings is no longer loaded into the prompt, recalled, indexed, or used by memory extraction
+- Fixed sub-agents and background agents being reported as failed, with their result never delivered, when the final streamed reply omitted token usage or carried no model id
+- Fixed the context meter and auto-compact counting advisor-tool turns at roughly twice their real context size, which made auto-compact fire at about half the real window
+- Fixed `/tui` refusing to restart because of an agent-team teammate that had already finished its work and was no longer shown in the agents panel
+- Fixed saved scheduled tasks running in the wrong session after `.claude/scheduled_tasks.json` was copied into another folder, such as a new worktree
+- Fixed SDK and `--output-format stream-json` output dropping a subagent's remaining messages and final report after it is moved to the background mid-run (e.g. by `CLAUDE_AUTO_BACKGROUND_TASKS`)
+- Fixed `/install-github-app` reporting a SAML single sign-on block as "admin permissions required"
+- Fixed Remote Control clients attached to a Claude Desktop, VS Code or JetBrains session being refused when they ask for the session's context window usage
+- Fixed the spinner showing a doubled ellipsis ("……") on compaction status lines such as "Running PreCompact hooks…"
```

</details>

<details>
<summary>context-window-ja.md</summary>

```diff
diff --git a/docs-ja/pages/context-window-ja.md b/docs-ja/pages/context-window-ja.md
index 6df7f47..e40d673 100644
--- a/docs-ja/pages/context-window-ja.md
+++ b/docs-ja/pages/context-window-ja.md
@@ -113,5 +113,4 @@ export const ContextWindow = () => {
     color: '#4A9B8E',
     vis: 'brief',
-    restoredAfterCompact: true,
     desc: 'This rule in `.claude/rules/` has a `paths:` pattern matching `src/api/**`. It loaded automatically when Claude read a file in that directory. You see "Loaded .claude/rules/api-conventions.md" in your terminal, but not the rule content.',
     link: '/en/memory#path-specific-rules'
@@ -143,5 +142,4 @@ export const ContextWindow = () => {
     color: '#4A9B8E',
     vis: 'brief',
-    restoredAfterCompact: true,
     desc: 'Another path-scoped rule, this one matching `*.test.ts` files. Triggered when Claude read auth.test.ts. Shown as a one-line "Loaded" notice.',
     link: '/en/memory#path-specific-rules'
@@ -626,6 +624,6 @@ export const ContextWindow = () => {
   }, [hovEvent]);
   const focusT = hovEvent ? hovEvent.t : time;
-  const takeaway = isCompacted ? 'Compaction replaces the conversation with a structured summary. System prompt, CLAUDE.md, memory, and MCP tools reload automatically. Claude Code also re-reads up to five of the files modified most recently, reloads the rules that match them, and re-injects the skills you invoked. The skill listing does not reload.' : focusT < STARTUP_END ? 'A lot loads before you type anything. CLAUDE.md, memory, skills, and MCP tools are all in context before your first prompt.' : focusT < 0.28 ? "Your prompt is tiny compared to what's already loaded. Most of Claude's context is project knowledge, not your words." : focusT < 0.50 ? 'Each file Claude reads grows the context. Path-scoped rules load automatically alongside matching files.' : focusT < 0.71 ? 'Hooks fire automatically on tool events. Output reaches Claude via additionalContext JSON. Exit code 2 surfaces stderr to Claude. Plain stdout on exit 0 goes to the debug log, not the transcript.' : focusT < 0.79 ? 'Follow-up questions keep building on the same context. Everything from earlier is still there.' : focusT < 0.87 ? "The subagent works in its own separate context window. None of its file reads touch yours. Only the final summary comes back." : focusT < 0.88 ? 'Bang commands run in your shell and prefix the output to your next message. Useful for grounding Claude in command results without it running them.' : focusT < 0.90 ? 'User-only skills stay out of context entirely until you invoke them. The skill index at startup only lists skills Claude can call on its own.' : '/compact summarizes the conversation to free space while keeping key information. In a real session, run it when context starts affecting performance or before a long new task.';
-  const terminalView = isCompacted ? 'A "Conversation compacted" message, then a one-line "Read auth.ts" for each re-read file and "Skills restored (commit-push)". The rules show as "Loaded" lines on Claude\'s next turn. None of the content itself appears.' : focusT < STARTUP_END ? 'The input box, waiting for your first message. Everything above loads silently before you type anything.' : focusT < 0.28 ? 'Your prompt. Claude hasn\'t started working yet.' : focusT < 0.52 ? 'Your prompt and "Reading files...". Rules show as one-line "Loaded" notices, not their content.' : focusT < 0.72 ? "Claude's response and file diffs. Hooks fire silently. Tool output like npm test shows as a brief summary, not the full content." : focusT < 0.79 ? 'Your follow-up prompt.' : focusT < 0.86 ? "A brief notice that a subagent is working, then its result. You don't see the subagent's individual file reads." : focusT < 0.90 ? "Claude's response, your git status output, and the commit-push skill running." : 'Your full conversation. /compact is available to run.';
+  const takeaway = isCompacted ? 'Compaction replaces the conversation with a structured summary. System prompt, CLAUDE.md, memory, and MCP tools reload automatically. Claude Code also re-reads up to five of the files modified most recently and re-injects the skills you invoked. The skill listing does not reload.' : focusT < STARTUP_END ? 'A lot loads before you type anything. CLAUDE.md, memory, skills, and MCP tools are all in context before your first prompt.' : focusT < 0.28 ? "Your prompt is tiny compared to what's already loaded. Most of Claude's context is project knowledge, not your words." : focusT < 0.50 ? 'Each file Claude reads grows the context. Path-scoped rules load automatically alongside matching files.' : focusT < 0.71 ? 'Hooks fire automatically on tool events. Output reaches Claude via additionalContext JSON. Exit code 2 surfaces stderr to Claude. Plain stdout on exit 0 goes to the debug log, not the transcript.' : focusT < 0.79 ? 'Follow-up questions keep building on the same context. Everything from earlier is still there.' : focusT < 0.87 ? "The subagent works in its own separate context window. None of its file reads touch yours. Only the final summary comes back." : focusT < 0.88 ? 'Bang commands run in your shell and prefix the output to your next message. Useful for grounding Claude in command results without it running them.' : focusT < 0.90 ? 'User-only skills stay out of context entirely until you invoke them. The skill index at startup only lists skills Claude can call on its own.' : '/compact summarizes the conversation to free space while keeping key information. In a real session, run it when context starts affecting performance or before a long new task.';
+  const terminalView = isCompacted ? 'A "Conversation compacted" message, then a one-line "Read auth.ts" for each re-read file and "Skills restored (commit-push)". None of the content itself appears.' : focusT < STARTUP_END ? 'The input box, waiting for your first message. Everything above loads silently before you type anything.' : focusT < 0.28 ? 'Your prompt. Claude hasn\'t started working yet.' : focusT < 0.52 ? 'Your prompt and "Reading files...". Rules show as one-line "Loaded" notices, not their content.' : focusT < 0.72 ? "Claude's response and file diffs. Hooks fire silently. Tool output like npm test shows as a brief summary, not the full content." : focusT < 0.79 ? 'Your follow-up prompt.' : focusT < 0.86 ? "A brief notice that a subagent is working, then its result. You don't see the subagent's individual file reads." : focusT < 0.90 ? "Claude's response, your git status output, and the commit-push skill running." : 'Your full conversation. /compact is available to run.';
   const mono = 'var(--font-mono, ui-monospace, SFMono-Regular, Menlo, monospace)';
   const renderWithCode = s => s.split('`').map((part, i) => i % 2 === 1 ? <code key={i} style={{
@@ -953,5 +951,5 @@ export const ContextWindow = () => {
     marginTop: 4
   }}>
-                This is what's left in context: startup content, which lives outside the message history and reloads after compaction, a structured summary of the entire conversation, the files modified most recently, which Claude Code re-reads along with the rules that match them, and the body of each skill you invoked. Skill descriptions don't reload.
+                This is what's left in context: startup content, which lives outside the message history and reloads after compaction, a structured summary of the entire conversation, the files modified most recently, and the body of each skill you invoked. Skill descriptions don't reload.
```

</details>

</details>


<details>
<summary>2026-09-15</summary>

**変更ファイル:**

```
 docs-ja/pages/admin-setup-ja.md              |   4 +-
 docs-ja/pages/advisor-ja.md                  |  61 ++-
 docs-ja/pages/agent-view-ja.md               | 760 +++++++++++++++++---------
 docs-ja/pages/amazon-bedrock-ja.md           |   2 +-
 docs-ja/pages/artifacts-ja.md                | 263 ++++++---
 docs-ja/pages/authentication-ja.md           |   9 +-
 docs-ja/pages/best-practices-ja.md           |   6 +-
 docs-ja/pages/changelog.md                   | 103 ++++
 docs-ja/pages/claude-code-on-the-web-ja.md   |  56 +-
 docs-ja/pages/claude-directory-ja.md         | 174 +++---
 docs-ja/pages/cloud-environments-ja.md       |  13 +-
 docs-ja/pages/common-workflows-ja.md         |   2 +-
 docs-ja/pages/computer-use-ja.md             |   4 +-
 docs-ja/pages/costs-ja.md                    |   5 +-
 docs-ja/pages/cross-session-messaging-ja.md  | 407 +++++++++++++-
 docs-ja/pages/desktop-ja.md                  |  14 +-
 docs-ja/pages/desktop-quickstart-ja.md       |   4 +-
 docs-ja/pages/env-vars-ja.md                 |   1 +
 docs-ja/pages/errors-ja.md                   | 624 +++++++++++----------
 docs-ja/pages/fast-mode-ja.md                |   2 +-
 docs-ja/pages/github-enterprise-server-ja.md |   2 +-
 docs-ja/pages/goal-ja.md                     |  35 +-
 docs-ja/pages/how-claude-code-works-ja.md    |   2 +-
 docs-ja/pages/jetbrains-ja.md                |   8 +-
 docs-ja/pages/large-codebases-ja.md          |  56 +-
 docs-ja/pages/llm-gateway-rollout-ja.md      | 126 ++---
 docs-ja/pages/managed-settings-ja.md         |   2 +
 docs-ja/pages/mobile-ja.md                   |   2 +-
 docs-ja/pages/output-styles-ja.md            |  58 +-
 docs-ja/pages/permissions-ja.md              |  26 +-
 docs-ja/pages/plugin-marketplaces-ja.md      | 775 ++++++++++++++++++++-------
 docs-ja/pages/prompt-caching-ja.md           | 220 ++++----
 docs-ja/pages/remote-control-ja.md           |  20 +-
 docs-ja/pages/sandbox-environments-ja.md     |   2 +-
 docs-ja/pages/server-managed-settings-ja.md  |   3 +-
 docs-ja/pages/settings-reference-ja.md       |  34 +-
 docs-ja/pages/terminal-config-ja.md          |  15 +-
 docs-ja/pages/troubleshoot-install-ja.md     |  30 +-
 docs-ja/pages/vs-code-ja.md                  |  53 +-
 39 files changed, 2663 insertions(+), 1320 deletions(-)
```

<details>
<summary>admin-setup-ja.md</summary>

```diff
diff --git a/docs-ja/pages/admin-setup-ja.md b/docs-ja/pages/admin-setup-ja.md
index ccaada5..cbc402c 100644
--- a/docs-ja/pages/admin-setup-ja.md
+++ b/docs-ja/pages/admin-setup-ja.md
@@ -84,7 +84,5 @@ WSL セッションが有効になった後、マネージド設定をそれら
 
 * HKLM レジストリまたは `C:\Program Files\ClaudeCode` ファイルを通じて `wslInheritsWindowsSettings: true` をデプロイして、WSL セッションがホストセッションと同じポリシーを継承するようにしてください。
-* WSL セッション内で `/status` を実行して検証してください。`Setting sources` 行を読んでください。Claude Code は [選択したマネージドソース](/docs/ja/server-managed-settings#settings-precedence)のみを名前付けするため、行が何を示すかはセッションによって異なります。
-  * **[server-managed settings をフェッチし](/docs/ja/server-managed-settings#platform-availability)、任意のキーを受け取るセッション内**: `Enterprise managed settings (remote)` です。Claude Code は Windows ソースより前にそれらを選択するため、行は フラグが到達したかどうかを示しません。
-  * **その他のセッション内**: `Enterprise managed settings (HKLM)` はレジストリデプロイメントを確認します。`(file)` は Windows ファイルまたはディストリビューション独自の `/etc/claude-code/managed-settings.json` を名前付けるため、ディストリビューションが独自のマネージドファイルを持たない場合にのみ Windows ファイルデプロイメントを確認します。
+* WSL セッション内で `/status` を実行して検証し、`Setting sources` 行を読んでください。それを解釈する方法については、[/status で出力を読む](/docs/ja/managed-settings#read-the-source-in-/status)を参照してください。
 
 WSL 2 ユーティリティ VM 内のプロセスは、Windows 側のエンドポイント検出センサーに表示されません。ディストリビューション内のプロセスとファイルアクティビティを観察するには、エンドポイント検出ベンダーの WSL ガイダンスで、ディストリビューション内で実行できる Linux センサーと、それが必要とする除外を確認してください。Claude Code の [OpenTelemetry ツール実行テレメトリ](/docs/ja/monitoring-usage)は WSL とネイティブセッションで同じように出力されます。
```

</details>

<details>
<summary>advisor-ja.md</summary>

```diff
diff --git a/docs-ja/pages/advisor-ja.md b/docs-ja/pages/advisor-ja.md
index a54c0df..8291257 100644
--- a/docs-ja/pages/advisor-ja.md
+++ b/docs-ja/pages/advisor-ja.md
@@ -93,38 +93,41 @@ Claude Code はそのセッションの `advisorModel` 設定の代わりにフ
 
 <h2 id="choose-an-advisor-model">
-  advisor モデルを選択する
+  アドバイザーモデルを選択する
 </h2>
 
-advisor はメインモデル以上の機能を持つ必要があります。各メインモデルで受け入れられる advisor は次のとおりです。
+アドバイザーはメインモデル以上の能力を持つ必要があります。各メインモデルで受け入れられるアドバイザーは以下の通りです。
 
-| メインモデル                | 受け入れられる advisor       | 注記                                                                                                                    |
-| --------------------- | --------------------- | --------------------------------------------------------------------------------------------------------------------- |
-| Haiku 4.5             | Fable、Opus、Sonnet     | Haiku は advisor を呼び出すことはできますが、advisor として機能することはできません                                                                 |
-| Sonnet 4.6            | Fable、Opus、Sonnet     |                                                                                                                       |
-| Sonnet 5              | Fable、Opus、Sonnet 5   | Sonnet 4.6 advisor は拒否されます                                                                                            |
-| Opus 4.6              | Fable、Opus、Sonnet 5   | Sonnet 5 と Opus 4.6 は同等の機能として評価されるため、Opus 4.6 メインは Sonnet 5 advisor を受け入れます                                           |
-| Opus 4.7 以降           | Fable、Opus 4.7 以降     | Opus 4.7 以降の Opus モデルは同等の機能として評価されるため、どれでも他方を advisor として受け入れます。Opus 4.6 または Sonnet 5 advisor を持つ Opus 4.7 メインは拒否されます |
-| Fable 5.1 または Fable 5 | Fable 5.1 または Fable 5 | Opus または Sonnet advisor は拒否されます                                                                                       |
+| メインモデル                | 受け入れられるアドバイザー              | 注記                                                                                    |
+| --------------------- | -------------------------- | ------------------------------------------------------------------------------------- |
+| Haiku 4.5             | Fable、Opus、Sonnet          | Haiku はアドバイザーを呼び出すことはできますが、アドバイザーとして機能することはできません                                      |
+| Sonnet 4.6            | Fable、Opus、Sonnet          |                                                                                       |
+| Sonnet 5              | Fable、Opus 4.7 以降、Sonnet 5 | Sonnet 4.6 アドバイザーは拒否され、Opus 4.6 アドバイザーを使用したリクエストは API エラーで失敗します                       |
+| Opus 4.6              | Fable、Opus、Sonnet 5        | Sonnet 4.6 アドバイザーは拒否されます                                                              |
+| Opus 4.7 または Opus 4.8 | Fable、および Opus 4.7 以降      | Opus 4.6 または Sonnet アドバイザーは拒否されます                                                     |
+| Opus 5                | Fable、Opus 5               | Opus 4.6 または Sonnet アドバイザーは拒否され、Opus 4.7 または Opus 4.8 アドバイザーを使用したリクエストは API エラーで失敗します |
```

</details>

<details>
<summary>agent-view-ja.md</summary>

```diff
diff --git a/docs-ja/pages/agent-view-ja.md b/docs-ja/pages/agent-view-ja.md
index 0fed38a..de10ff7 100644
--- a/docs-ja/pages/agent-view-ja.md
+++ b/docs-ja/pages/agent-view-ja.md
@@ -9,7 +9,7 @@
 `claude agents` で開くエージェントビューは、すべてのバックグラウンドセッションの 1 つの画面です。実行中のもの、入力が必要なもの、完了したものが表示されます。新しいセッションをディスパッチし、トランスクリプトをスクロールする代わりに一目でセッションの状態を確認し、セッションが必要とするときだけ介入します。各バックグラウンドセッションは完全な Claude Code の会話であり、ターミナルが接続されていなくてもバックグラウンドで実行し続けるため、いつでも開いて、返信して、去ることができます。
 
-<img src="https://mintcdn.com/claude-code/1B48Qz2Z9hac4SLG/images/agent-view-light.png?fit=max&auto=format&n=1B48Qz2Z9hac4SLG&q=85&s=7a186c96ed47d6700d084d77e786be65" className="dark:hidden" alt="ターミナルのエージェントビュー：ヘッダーは Claude Code v2.1.140、モデル、作業ディレクトリ、および概要カウントを表示します。セッションは'入力が必要'、'実行中'、'完了'の下にグループ化され、下部にディスパッチ入力とキーボードヒントのフッターがあります。" width="1772" height="780" data-path="images/agent-view-light.png" />
+<img src="https://mintcdn.com/claude-code/1B48Qz2Z9hac4SLG/images/agent-view-light.png?fit=max&auto=format&n=1B48Qz2Z9hac4SLG&q=85&s=7a186c96ed47d6700d084d77e786be65" className="dark:hidden" alt="ターミナルのエージェントビュー：ヘッダーは Claude Code v2.1.140、モデル、作業ディレクトリ、および概要カウントを表示します。セッションは「入力が必要」、「実行中」、「完了」の下にグループ化され、下部にディスパッチ入力とキーボードヒントのフッターがあります。" width="1772" height="780" data-path="images/agent-view-light.png" />
 
-<img src="https://mintcdn.com/claude-code/1B48Qz2Z9hac4SLG/images/agent-view-dark.png?fit=max&auto=format&n=1B48Qz2Z9hac4SLG&q=85&s=a5bed7434bae368faea3a8f023b52aa2" className="hidden dark:block" alt="ターミナルのエージェントビュー：ヘッダーは Claude Code v2.1.140、モデル、作業ディレクトリ、および概要カウントを表示します。セッションは'入力が必要'、'実行中'、'完了'の下にグループ化され、下部にディスパッチ入力とキーボードヒントのフッターがあります。" width="1772" height="780" data-path="images/agent-view-dark.png" />
+<img src="https://mintcdn.com/claude-code/1B48Qz2Z9hac4SLG/images/agent-view-dark.png?fit=max&auto=format&n=1B48Qz2Z9hac4SLG&q=85&s=a5bed7434bae368faea3a8f023b52aa2" className="hidden dark:block" alt="ターミナルのエージェントビュー：ヘッダーは Claude Code v2.1.140、モデル、作業ディレクトリ、および概要カウントを表示します。セッションは「入力が必要」、「実行中」、「完了」の下にグループ化され、下部にディスパッチ入力とキーボードヒントのフッターがあります。" width="1772" height="780" data-path="images/agent-view-dark.png" />
 
 Claude が複数の独立したタスクに対して、あなたが毎ステップを監視することなく作業できる場合に、エージェントビューを使用します。バグ修正、プルリクエストレビュー、不安定なテストの調査を 3 つの行としてディスパッチし、別のウィンドウで作業を続け、行が入力が必要であることを示すか、結果が得られたときに確認します。
@@ -20,15 +20,7 @@ Claude が複数の独立したタスクに対して、あなたが毎ステッ
 
 <Note>
-  エージェントビューはリサーチプレビューであり、Claude Code v2.1.139 以降が必要です。`claude --version` でバージョンを確認してください。インターフェースとキーボードショートカットは機能の進化に伴って変更される可能性があります。
+  エージェントビューはリサーチプレビュー中です。インターフェースとキーボードショートカットは機能の進化に伴って変更される可能性があります。
 </Note>
 
-このページでは以下をカバーしています。
-
-* [クイックスタート](#quick-start)：Claude にバックグラウンドで作業するタスクを与え、確認し、必要なときに介入する
-* [エージェントビューでセッションを監視する](#monitor-sessions-with-agent-view)。状態アイコン、ピーク表示と返信、アタッチ、整理、キーボードショートカットを含みます
-* [新しいエージェントをディスパッチする](#dispatch-new-agents)。エージェントビューから、セッション内から、またはシェルから
-* [シェルからセッションを管理する](#manage-sessions-from-the-shell)。`claude agents`、`claude attach`、および関連コマンドを使用して
-* [バックグラウンドセッションがどのようにホストされるか](#how-background-sessions-are-hosted)。スーパーバイザープロセスによって
-
 <h2 id="quick-start">
```

</details>

<details>
<summary>amazon-bedrock-ja.md</summary>

```diff
diff --git a/docs-ja/pages/amazon-bedrock-ja.md b/docs-ja/pages/amazon-bedrock-ja.md
index 9777be4..28aa514 100644
--- a/docs-ja/pages/amazon-bedrock-ja.md
+++ b/docs-ja/pages/amazon-bedrock-ja.md
@@ -240,5 +240,5 @@ Claude Code は AWS SSO および企業 ID プロバイダーの自動認証情
 Claude Code v2.1.181 以降、`aws configure export-credentials --format process` からのフラット出力も受け入れられます。同じキーが `Credentials` の下にネストされるのではなく、トップレベルにあります。
 
-`Expiration` はオプションです。Claude Code v2.1.176 以降、コマンドが有効な ISO 8601 `Expiration` を返すと、Claude Code はその時刻の 5 分前まで認証情報をキャッシュします。それがない場合、または以前のバージョンでは、認証情報は 1 時間キャッシュされます。
+`Expiration` はオプションです。コマンドが有効な ISO 8601 `Expiration` を返すと、Claude Code はその時刻の 5 分前まで認証情報をキャッシュします。それがない場合、認証情報は 1 時間キャッシュされます。
 
 `awsCredentialExport` を `awsAuthRefresh` なしで設定する場合、Claude Code はエクスポートされた認証情報を直接使用し、スタートアップで AWS デフォルト認証情報プロバイダーチェーンを再解決しません。Claude Code v2.1.206 以降が必要です。
```

</details>

<details>
<summary>artifacts-ja.md</summary>

```diff
diff --git a/docs-ja/pages/artifacts-ja.md b/docs-ja/pages/artifacts-ja.md
index 0585728..210a1d4 100644
--- a/docs-ja/pages/artifacts-ja.md
+++ b/docs-ja/pages/artifacts-ja.md
@@ -5,30 +5,30 @@
 # セッション出力をアーティファクトとして共有する
 
-> アーティファクトは Claude Code の作業をライブでインタラクティブなページに変え、claude.ai 上で非公開に保つか、組織と共有するか、公開リンクに公開できます。
+> Artifacts は Claude Code の成果物を claude.ai 上のライブでインタラクティブなページに変え、プライベートに保つ、組織と共有する、または公開リンクで公開することができます。
 
 <Note>
-  アーティファクトは Pro、Max、Team、および Enterprise プランで利用でき、[`/login`](/docs/ja/setup#authenticate) でサインインしたセッションが必要です。要件の完全なセットについては、[利用可能性](#availability)を参照してください。
+  Artifacts は Pro、Max、Team、Enterprise プランで利用可能で、[`/login`](/docs/ja/setup#authenticate) でサインインしたセッションが必要です。要件の完全なセットについては、[利用可能性](#availability)を参照してください。
 </Note>
 
-アーティファクトは、Claude Code がセッションから claude.ai のプライベート URL に公開するライブでインタラクティブなウェブページです。ブラウザで開くと、セッションが続く間、ページはその場で更新されます。ページヘッダーから共有して、他の人にも見てもらうことができます。たとえば、アーティファクトを使用して、注釈付きの差分でプルリクエストをレビュアーに説明したり、セッションデータからダッシュボードを構築したり、Claude が作業する際に埋まっていく調査タイムラインを保持したりできます。
+アーティファクトは、Claude Code がセッションから claude.ai 上のプライベート URL に公開するライブでインタラクティブな Web ページです。ブラウザで開くと、セッションが続く間、その場で更新されます。他の人にも見てもらいたい場合は、ページヘッダーから共有します。
 
 <Frame>
-  <img src="https://mintcdn.com/claude-code/kaHIYYMIYMYPxQg9/images/artifacts-viewer.png?fit=max&auto=format&n=kaHIYYMIYMYPxQg9&q=85&s=dbfd671cdb0d15f49f808b9e89778fe1" alt="claude.ai/code/artifact で開かれたアーティファクト。ビューアヘッダーには、アーティファクトタイトル acme-funnel-fix、Share ボタン、および作成者アバターが表示されます。Share メニューが開いており、Always share latest version トグル、Sharing version 2 と表示されたバージョンピッカー、Everyone at Acme オーディエンスセレクタ、および Copy link ボタンが表示されます。ヘッダーの下には、2 つのモバイルモックアップが並んで表示され、ファネルチャート、およびメトリックカードの行が表示されます。" width="2511" height="1890" data-path="images/artifacts-viewer.png" />
+  <img src="https://mintcdn.com/claude-code/kaHIYYMIYMYPxQg9/images/artifacts-viewer.png?fit=max&auto=format&n=kaHIYYMIYMYPxQg9&q=85&s=dbfd671cdb0d15f49f808b9e89778fe1" alt="claude.ai/code/artifact で開かれたアーティファクト。ビューアヘッダーには、アーティファクトタイトル acme-funnel-fix、Share ボタン、著者アバターが表示されています。Share メニューが開いており、Always share latest version トグル、Sharing version 2 と表示されたバージョンピッカー、Everyone at Acme オーディエンスセレクタ、Copy link ボタンが表示されています。ヘッダーの下には、2 つのモバイルモックアップが並んで表示され、ファネルチャート、メトリクスカードの行が表示されています。" width="2511" height="1890" data-path="images/artifacts-viewer.png" />
 </Frame>
 
 <h2 id="when-to-use-an-artifact">
-  アーティファクトを使用する時期
+  アーティファクトを使用する場合
 </h2>
 
-ターミナルテキストが Claude が生成した出力に適さない場合、アーティファクトを使用します。つまり、行ごとに読むよりも見たり操作したりする方が簡単な出力です。Claude はセッションが到達できるもの（コードベースや[接続されたツール](/docs/ja/mcp)を通じて取得したデータを含む）からページを構築するため、ページは段落で説明するのに時間がかかるものを表示できます。たとえば、Claude に以下を依頼します。
+ターミナルテキストが Claude が生成したものを表示するのに適さない場合にアーティファクトを使用してください。つまり、1 行ずつ読むよりも見たり操作したりする方が簡単な出力です。Claude はセッションが到達できるもの（コードベースや [接続されたツール](/docs/ja/mcp) を通じて取得するデータを含む）からページを構築するため、説明に段落が必要になるようなものを表示できます。たとえば、Claude に以下のことを依頼してください。
```

</details>

<details>
<summary>authentication-ja.md</summary>

```diff
diff --git a/docs-ja/pages/authentication-ja.md b/docs-ja/pages/authentication-ja.md
index ad06674..deed654 100644
--- a/docs-ja/pages/authentication-ja.md
+++ b/docs-ja/pages/authentication-ja.md
@@ -171,15 +171,10 @@ Claude Console ログインの場合、Claude Code は `forceLoginOrgUUID` を
 * **[ゲートウェイ](/docs/ja/claude-apps-gateway)サインイン**: `forceLoginMethod: "gateway"` によって選択され、それによって制限されず、Anthropic 組織に対して認証されないため、`forceLoginOrgUUID` は適用されません。ゲートウェイ ID プロバイダーを使用してアクセスを制限します
 
-デバイス管理ツールを通じてキーをデプロイします。[サーバー管理設定](/docs/ja/server-managed-settings)は、既に組織に認証されているアカウントにのみ到達するため、開発者の最初のログインをリダイレクトできません。組織がサーバー管理設定も配布する場合、両方の場所にキーを設定します。管理設定ソースは [マージされず](/docs/ja/server-managed-settings#settings-precedence)、キャッシュされたサーバー管理設定はデバイス管理ファイルを置き換えます。ただし、2 種類のキーは依然として失敗したソースから入力されます。
-
-* **`env` ブロック**: Claude Code v2.1.223 以降で [キーごとにマージ](/docs/ja/server-managed-settings#per-key-exceptions-across-managed-sources)されます
-* **[クロスソースロックキー](/docs/ja/server-managed-settings#per-key-exceptions-across-managed-sources)**: 任意の管理ソースから尊重されます
-
-`forceLoginMethod` と `forceLoginOrgUUID` はどちらでもないため、両方の場所に保持します。
+デバイス管理ツールを通じてキーをデプロイします。[サーバー管理設定](/docs/ja/server-managed-settings)は、既に組織に認証されているアカウントにのみ到達するため、開発者の最初のログインをリダイレクトできません。組織がサーバー管理設定も配布する場合、両方の場所にキーを設定します。管理設定ソースは [マージされず](/docs/ja/server-managed-settings#settings-precedence)、キャッシュされたサーバー管理設定はデバイス管理ファイルを置き換えます。ただし、いくつかの [キーごとの例外](/docs/ja/server-managed-settings#per-key-exceptions-across-managed-sources)を除いて。`forceLoginOrgUUID` と `forceLoginMethod` の `"claudeai"` および `"console"` 値はこれらの例外に含まれていないため、両方の場所に保持します。
 
 キーはまた、ログイン認証情報を使用しないセッションが開始できるかどうかも決定します。設定リファレンスの [`forceLoginOrgUUID`](/docs/ja/settings-reference#forceloginorguuid) を参照して、完全な動作を確認してください。
 
 * **`ANTHROPIC_API_KEY`、`ANTHROPIC_AUTH_TOKEN`、または `apiKeyHelper`**: 環境認証情報の組織メンバーシップを確認できないため、起動時にブロックされます
-* **Amazon Bedrock などのクラウドプロバイダーセッション**: ブラウザーに対して認証されるため、ブロックされません。クラウド IAM ポリシーを通じてそれらを制限します
+* **Amazon Bedrock などのクラウドプロバイダーセッション**: クラウドプロバイダーに対して認証されるため、ブロックされません。クラウド IAM ポリシーを通じてそれらを制限します
 * **[Anthropic プロファイルまたはフェデレーション認証情報](#anthropic-profiles-and-federation-credentials)**: ブロックされず、キーはプロファイルが属する組織を確認しません
 
```

</details>

<details>
<summary>best-practices-ja.md</summary>

```diff
diff --git a/docs-ja/pages/best-practices-ja.md b/docs-ja/pages/best-practices-ja.md
index f3334cd..c4d77a4 100644
--- a/docs-ja/pages/best-practices-ja.md
+++ b/docs-ja/pages/best-practices-ja.md
@@ -490,5 +490,5 @@ Claude Code は会話をローカルに保存するため、タスクが複数
 </Tip>
 
-`claude -p "your prompt"` を使用すると、セッションなしで Claude を非対話的に実行できます。実行は `--no-session-persistence` を渡さない限り、再開可能なセッションを作成します。[非対話型モード](/docs/ja/headless)は、Claude を CI パイプライン、プリコミットフック、または自動化されたワークフローに統合する方法です。出力形式を使用すると、結果をプログラムで解析できます。プレーンテキスト、JSON、またはストリーミング JSON です。
+`claude -p "your prompt"` を使用すると、対話型プロンプトなしで Claude を非対話的に実行できます。実行は `--no-session-persistence` を渡さない限り、再開可能なセッションを作成します。[非対話型モード](/docs/ja/headless)は、Claude を CI パイプライン、プリコミットフック、または自動化されたワークフローに統合する方法です。出力形式を使用すると、結果をプログラムで解析できます。プレーンテキスト、JSON、またはストリーミング JSON です。
 
 ```bash theme={null}
@@ -539,5 +539,5 @@ claude -p "Analyze this log file" --output-format stream-json --verbose
 
 <Tip>
-  各タスクに対して `claude -p` を呼び出すループを実行します。バッチ操作のスコープパーミッションに `--allowedTools` を使用します。
+  各タスクに対して `claude -p` を呼び出すループを実行します。バッチ操作のスコープ権限に `--allowedTools` を使用します。
 </Tip>
 
@@ -569,6 +569,4 @@ claude -p "<your prompt>" --output-format json | your_command
 ```
 
-開発中は `--verbose` を使用し、本番環境ではオフにします。
-
 <h3 id="run-autonomously-with-auto-mode">
   auto mode で自律的に実行する
```

</details>

*...以降省略*

</details>


<details>
<summary>2026-09-13</summary>

**変更ファイル:**

```
 docs-ja/pages/amazon-bedrock-ja.md                       |  2 +-
 docs-ja/pages/changelog.md                               |  4 ++++
 docs-ja/pages/claude-directory-ja.md                     |  2 +-
 docs-ja/pages/cli-reference-ja.md                        | 16 ++++++++--------
 docs-ja/pages/errors-ja.md                               |  8 ++++----
 docs-ja/pages/hooks-guide-ja.md                          |  2 +-
 docs-ja/pages/llm-gateway-protocol-ja.md                 |  2 +-
 docs-ja/pages/mcp-ja.md                                  |  4 ++--
 docs-ja/pages/permission-modes-ja.md                     |  2 +-
 docs-ja/pages/plugin-evals-ja.md                         |  2 +-
 docs-ja/pages/plugins-reference-ja.md                    | 14 +++++++-------
 docs-ja/pages/remote-control-ja.md                       |  4 ++--
 .../pages/self-hosted-environments-configuration-ja.md   |  2 +-
 docs-ja/pages/self-hosted-environments-deploy-ja.md      | 10 +++++-----
 docs-ja/pages/workflows-ja.md                            |  2 +-
 15 files changed, 40 insertions(+), 36 deletions(-)
```

<details>
<summary>amazon-bedrock-ja.md</summary>

```diff
diff --git a/docs-ja/pages/amazon-bedrock-ja.md b/docs-ja/pages/amazon-bedrock-ja.md
index bbb9092..9777be4 100644
--- a/docs-ja/pages/amazon-bedrock-ja.md
+++ b/docs-ja/pages/amazon-bedrock-ja.md
@@ -191,5 +191,5 @@ Claude Code は AWS デフォルト認証情報プロバイダーチェーンを
 チェーンの各解決は 60 秒後にタイムアウトします。チェーン内のステップが停止した場合（例えば、受け取ることができない入力を待つ `credential_process` ヘルパー）、リクエストは [`AWS default-chain credential resolve timed out`](/docs/ja/errors#aws-default-chain-credential-resolve-timed-out) で失敗します。チェーンが正当に長い時間が必要なインタラクティブサインイン（`aws-vault` のようなラッパーを使用した MFA 付きブラウザベースの SSO など）を実行する場合、[`CLAUDE_CODE_AWS_CHAIN_RESOLVE_TIMEOUT_MS`](/docs/ja/env-vars) でミリ秒単位で制限を引き上げてください。v2.1.207 より前では、停止した認証情報解決はリクエストを無期限に待機させていました。
 
-Amazon Bedrock API キーで認証しない場合を除き、[セットアップウィザード](#sign-in-with-bedrock)は認証情報を検証する際に行う各 AWS 呼び出しに同じ制限を適用し、各モデルチェック前の認証情報ルックアップにも適用します。認証情報検証中に、制限を超えるチェックは [`Timed out after 60s waiting for AWS`](/docs/ja/errors#bedrock-setup-verification-timed-out-waiting-for-aws) で失敗します。
+Amazon Bedrock API キーで認証する場合を除き、[セットアップウィザード](#sign-in-with-bedrock)は認証情報を検証する際に行う各 AWS 呼び出しに同じ制限を適用し、各モデルチェック前の認証情報ルックアップにも適用します。認証情報検証中に、制限を超えるチェックは [`Timed out after 60s waiting for AWS`](/docs/ja/errors#bedrock-setup-verification-timed-out-waiting-for-aws) で失敗します。
 
 <h4 id="advanced-credential-configuration">
```

</details>

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index 8421a9a..facb720 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,8 @@
 # Changelog
 
+## 2.1.270
+
+- Fixed read-only git commands in Bash unexpectedly asking for permission after a session had been running for a while (regression in 2.1.269)
+
 ## 2.1.269
 
```

</details>

<details>
<summary>claude-directory-ja.md</summary>

```diff
diff --git a/docs-ja/pages/claude-directory-ja.md b/docs-ja/pages/claude-directory-ja.md
index 4a959cc..577e8aa 100644
--- a/docs-ja/pages/claude-directory-ja.md
+++ b/docs-ja/pages/claude-directory-ja.md
@@ -1673,5 +1673,5 @@ claude project purge ~/work/my-repo --yes
 | `~/.claude/policy-limits.json`                                                                                                            | なし。自動的に更新されます。                                                                                |
 | `~/.claude/tasks/`                                                                                                                        | 再開されたセッションが取得するタスクリスト                                                                         |
-| `~/.claude/debug/`、`~/.claude/plans/`、`~/.claude/image-cache/`、`~/.claude/session-env/`、`~/.claude/shell-snapshots/`、`~/.claude/backups/` | ユーザー向けのもの                                                                                     |
+| `~/.claude/debug/`、`~/.claude/plans/`、`~/.claude/image-cache/`、`~/.claude/session-env/`、`~/.claude/shell-snapshots/`、`~/.claude/backups/` | ユーザー向けのものはなし                                                                                  |
 | `~/.claude/todos/`、`~/.claude/statsig/`、`~/.claude/logs/`                                                                                 | なし。現在のバージョンでは書き込まれないレガシーディレクトリ。                                                               |
 
```

</details>

<details>
<summary>cli-reference-ja.md</summary>

```diff
diff --git a/docs-ja/pages/cli-reference-ja.md b/docs-ja/pages/cli-reference-ja.md
index 1b5bbcd..e899a92 100644
--- a/docs-ja/pages/cli-reference-ja.md
+++ b/docs-ja/pages/cli-reference-ja.md
@@ -133,5 +133,5 @@ v2.1.199 以降、`claude --dangerously-skip-permissions daemon <subcommand>` 
 | `--system-prompt`                               | デフォルトシステムプロンプト全体をカスタムテキストで置き換えます                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      | `claude --system-prompt "You are a Python expert"`                                                  |
 | `--system-prompt-file`                          | ファイルからシステムプロンプトを読み込み、デフォルトプロンプトを置き換えます                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                | `claude --system-prompt-file ./custom-prompt.txt`                                                   |
-| `--system-prompt-snapshot`                      | `off` を渡して、[会話の最初のリクエストで記録された](/docs/ja/cli-flags#system-prompt-flags-in-resumed-conversations) プロンプトを再利用する代わりに、すべてのリクエストでシステムプロンプトを再構築します。例えば、`--continue` 実行全体で `--append-system-prompt` テキストを反復処理する場合。Claude Code v2.1.257 以降が必要です                                                                                                                                                                                                                                                                                                                                                                                                      | `claude --system-prompt-snapshot off`                                                               |
+| `--system-prompt-snapshot`                      | `off` を渡して、[会話の最初のリクエストで記録された](#system-prompt-flags-in-resumed-conversations) プロンプトを再利用する代わりに、すべてのリクエストでシステムプロンプトを再構築します。例えば、`--continue` 実行全体で `--append-system-prompt` テキストを反復処理する場合。Claude Code v2.1.257 以降が必要です                                                                                                                                                                                                                                                                                                                                                                                                                   | `claude --system-prompt-snapshot off`                                                               |
 | `--teleport`                                    | [Web セッション](/docs/ja/claude-code-on-the-web) をローカルターミナルで再開します                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              | `claude --teleport`                                                                                 |
 | `--teammate-mode`                               | [エージェントチーム](/docs/ja/agent-teams) のチームメイトの表示方法を設定します：`in-process`（デフォルト）、`auto`、`tmux`、または `iterm2`（v2.1.186 で追加）。このセッションの [`teammateMode`](/docs/ja/settings-reference#teammatemode) 設定をオーバーライドします。[ディスプレイモードを選択](/docs/ja/agent-teams#choose-a-display-mode) を参照してください                                                                                                                                                                                                                                                                                                                                                                             | `claude --teammate-mode auto`                                                                       |
@@ -148,11 +148,11 @@ v2.1.199 以降、`claude --dangerously-skip-permissions daemon <subcommand>` 
 Claude Code は、システムプロンプトをカスタマイズするための 5 つのフラグを提供します。4 つはそのテキストを設定し、`--system-prompt-snapshot` を使用して、会話がそれを開始したテキストを保持するかどうかを制御します。5 つすべてがインタラクティブモードと非インタラクティブモードの両方で機能します。
 
-| フラグ                           | 動作                                                                                                                                       | 例                                                                          |
-| :---------------------------- | :--------------------------------------------------------------------------------------------------------------------------------------- | :------------------------------------------------------------------------- |
-| `--system-prompt`             | デフォルトプロンプト全体を置き換えます                                                                                                                      | `claude --system-prompt "You are a Python expert"`                         |
-| `--system-prompt-file`        | ファイルの内容で置き換えます                                                                                                                           | `claude --system-prompt-file ./prompts/review.txt`                         |
-| `--append-system-prompt`      | デフォルトプロンプトに追加します                                                                                                                         | `claude --append-system-prompt "Always use TypeScript"`                    |
-| `--append-system-prompt-file` | ファイルの内容をデフォルトプロンプトに追加します                                                                                                                 | `claude --append-system-prompt-file ./style-rules.txt`                     |
-| `--system-prompt-snapshot`    | `off` を使用すると、プロンプトを再構築します。`on` を使用すると、デフォルトで、[記録が適用される](/docs/ja/cli-flags#system-prompt-flags-in-resumed-conversations) 場所で記録されたプロンプトを再利用します | `claude --append-system-prompt "Draft rules" --system-prompt-snapshot off` |
+| フラグ                           | 動作                                                                                                                          | 例                                                                          |
+| :---------------------------- | :-------------------------------------------------------------------------------------------------------------------------- | :------------------------------------------------------------------------- |
+| `--system-prompt`             | デフォルトプロンプト全体を置き換えます                                                                                                         | `claude --system-prompt "You are a Python expert"`                         |
+| `--system-prompt-file`        | ファイルの内容で置き換えます                                                                                                              | `claude --system-prompt-file ./prompts/review.txt`                         |
+| `--append-system-prompt`      | デフォルトプロンプトに追加します                                                                                                            | `claude --append-system-prompt "Always use TypeScript"`                    |
+| `--append-system-prompt-file` | ファイルの内容をデフォルトプロンプトに追加します                                                                                                    | `claude --append-system-prompt-file ./style-rules.txt`                     |
+| `--system-prompt-snapshot`    | `off` を使用すると、プロンプトを再構築します。`on` を使用すると、デフォルトで、[記録が適用される](#system-prompt-flags-in-resumed-conversations) 場所で記録されたプロンプトを再利用します | `claude --append-system-prompt "Draft rules" --system-prompt-snapshot off` |
 
 `--system-prompt` と `--system-prompt-file` は相互に排他的です。追加フラグは、置き換えフラグのいずれかと組み合わせることができます。
```

</details>

<details>
<summary>errors-ja.md</summary>

```diff
diff --git a/docs-ja/pages/errors-ja.md b/docs-ja/pages/errors-ja.md
index 53a1526..8a3feb4 100644
--- a/docs-ja/pages/errors-ja.md
+++ b/docs-ja/pages/errors-ja.md
@@ -1187,5 +1187,5 @@ OAuth token does not meet scope requirement: user:profile
 </h3>
 
-[claude.ai コネクター](/docs/ja/mcp#use-mcp-servers-from-claude-ai) リクエストが失敗しました。claude.ai が Claude Code ログインからのトークンを拒否したため。通常、期限切れになり、更新できなかったログイン。拒否されたトークンはコネクターのログイン、コネクターの claude.ai での独自の認可ではないため、コネクターを再度認可してもそれは解決しません。`/mcp` では、コネクターは `connected · session token rejected` として表示され、その詳細ビューは以下のように読みます：
+[claude.ai コネクター](/docs/ja/mcp#use-mcp-servers-from-claude-ai) リクエストが失敗しました。claude.ai が Claude Code ログインからのトークンを拒否したため。通常、期限切れになり、更新できなかったログイン。拒否されたトークンはあなたのログインであり、コネクターの claude.ai での独自の認可ではないため、コネクターを再度認可してもそれは解決しません。`/mcp` では、コネクターは `connected · session token rejected` として表示され、その詳細ビューは以下のように読みます：
 
 ```text theme={null}
@@ -1412,5 +1412,5 @@ A proxy is configured via HTTPS_PROXY. Check that it allows connections to the h
 Claude Code は、API リクエストと同じ [プロキシ設定](/docs/ja/network-config) を通じてチェックを送信し、各プローブに 10 秒を与えます。失敗したプローブがプロキシを通過した場合、メッセージは `HTTPS_PROXY` などの環境変数を名前で指定します。v2.1.222 より前では、チェックはタイムアウトなしの異なるプロキシトランスポートを使用していました。`https://` スキーム付きのプロキシ URL の背後では、`Checking connectivity...` で無期限に停止してから失敗する可能性があり、同じプロキシを通じた API リクエストが成功しても失敗します。
 
-Claude Code は、[管理設定ファイル、MDM ポリシー、またはポリシーヘルパー](/docs/ja/managed-settings) が [`forceLoginMethod`](/docs/ja/settings-reference#forceloginmethod) を `"gateway"` に設定するか、`forceLoginMethod` なしで [`forceLoginGatewayUrl`](/docs/ja/settings-reference#forcelogingatewayurl) を設定する場合、このチェックをスキップします。どちらかの設定では、Claude Code は **Cloud gateway** 画面ではなく Anthropic サインイン方法でサインインステップを開きます。マシン上の管理設定ソースが存在するが読み取れない場合、Claude Code はチェックをスキップします。そのソースはゲートウェイ設定を保持する可能性があるためです。v2.1.247 より前では、Claude Code はこの設定下でもチェックを実行し、Anthropic のエンドポイントに到達できない場合、このエラーで終了しました。
+Claude Code は、[管理設定ファイル、MDM ポリシー、またはポリシーヘルパー](/docs/ja/managed-settings) が [`forceLoginMethod`](/docs/ja/settings-reference#forceloginmethod) を `"gateway"` に設定するか、`forceLoginMethod` なしで [`forceLoginGatewayUrl`](/docs/ja/settings-reference#forcelogingatewayurl) を設定する場合、このチェックをスキップします。どちらの設定でも、Claude Code は Anthropic サインイン方法ではなく **Cloud gateway** 画面でサインインステップを開きます。マシン上の管理設定ソースが存在するが読み取れない場合も、Claude Code はチェックをスキップします。そのソースはゲートウェイ設定を保持する可能性があるためです。v2.1.247 より前では、Claude Code はこの設定下でもチェックを実行し、Anthropic のエンドポイントに到達できない場合、このエラーで終了しました。
 
 **対応方法：**
@@ -1720,5 +1720,5 @@ v2.1.162 より前では、Claude Code は圧縮を試行し、失敗時に裸
 </h3>
 
-`/context` は、会話がモデルのコンテキストウィンドウを超えて成長した場合、その出力の上部にこの警告を表示します。[`Prompt is too long`](#prompt-is-too-long) でリクエストが失敗するまで、スペースを解放してください。インタラクティブセッションは、そのエラーを `Context limit reached` 行として表示します。
+`/context` は、会話がモデルのコンテキストウィンドウを超えて成長した場合、その出力の上部にこの警告を表示します。スペースを解放するまで、リクエストは [`Prompt is too long`](#prompt-is-too-long) で失敗します。インタラクティブセッションは、そのエラーを `Context limit reached` 行として表示します。
 
 ```text theme={null}
@@ -2239,5 +2239,5 @@ The connection dropped while downloading the update (attempt 3/3: aborted). Chec
 
 ```text theme={null}
---bg と --print が競合しています。--print は `claude agents` が接続するインタラクティブセッションを開始しないため、ジョブは接続不可になります。プロンプトは位置引数です。--print を削除してください。`claude --bg '<task>'` です。
+--bg and --print conflict: --print never starts the interactive session that `claude agents` attaches to, so the job would be unattachable. The prompt is the positional — drop --print: `claude --bg '<task>'`.
```

</details>

<!-- UPDATE_LOG_END -->
