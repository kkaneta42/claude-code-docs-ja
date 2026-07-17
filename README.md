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
<summary>2026-07-17</summary>

**変更ファイル:**

```
 docs-ja/pages/accessibility-ja.md              |   2 +-
 docs-ja/pages/admin-setup-ja.md                |  17 +-
 docs-ja/pages/advisor-ja.md                    |   4 +-
 docs-ja/pages/agent-teams-ja.md                |   6 +-
 docs-ja/pages/agent-view-ja.md                 | 104 +++++--
 docs-ja/pages/agents-ja.md                     |   2 +-
 docs-ja/pages/amazon-bedrock-ja.md             |  57 +++-
 docs-ja/pages/analytics-ja.md                  |   2 +-
 docs-ja/pages/artifacts-ja.md                  | 112 +++++--
 docs-ja/pages/authentication-ja.md             |  21 +-
 docs-ja/pages/auto-mode-config-ja.md           |  76 +++--
 docs-ja/pages/channels-ja.md                   |   2 +-
 docs-ja/pages/checkpointing-ja.md              |   1 +
 docs-ja/pages/chrome-ja.md                     |   4 +-
 docs-ja/pages/claude-apps-gateway-config-ja.md |  11 +-
 docs-ja/pages/claude-apps-gateway-deploy-ja.md |  46 +--
 docs-ja/pages/claude-apps-gateway-ja.md        |  22 +-
 docs-ja/pages/claude-code-on-the-web-ja.md     |  44 ++-
 docs-ja/pages/claude-directory-ja.md           |  40 +--
 docs-ja/pages/claude-platform-on-aws-ja.md     |   6 +-
 docs-ja/pages/cli-reference-ja.md              |   6 +-
 docs-ja/pages/commands-ja.md                   | 210 ++++++-------
 docs-ja/pages/costs-ja.md                      |  33 +-
 docs-ja/pages/data-usage-ja.md                 |  33 +-
 docs-ja/pages/debug-your-config-ja.md          |   2 +-
 docs-ja/pages/desktop-ja.md                    | 149 ++++++---
 docs-ja/pages/desktop-linux-ja.md              |   2 +-
 docs-ja/pages/desktop-quickstart-ja.md         |   4 +-
 docs-ja/pages/desktop-scheduled-tasks-ja.md    |   2 +
 docs-ja/pages/discover-plugins-ja.md           |   6 +-
 docs-ja/pages/errors-ja.md                     | 402 +++++++++++++++++++------
 docs-ja/pages/fast-mode-ja.md                  |   4 +-
 docs-ja/pages/feature-availability-ja.md       |  76 +++--
 docs-ja/pages/features-overview-ja.md          |   2 +-
 docs-ja/pages/fullscreen-ja.md                 |  23 +-
 docs-ja/pages/glossary-ja.md                   |   4 +-
 docs-ja/pages/goal-ja.md                       |  12 +-
 docs-ja/pages/google-vertex-ai-ja.md           |  29 +-
 docs-ja/pages/headless-ja.md                   |  11 +-
 docs-ja/pages/hooks-guide-ja.md                |  21 +-
 docs-ja/pages/hooks-ja.md                      |  40 ++-
 docs-ja/pages/interactive-mode-ja.md           |  25 +-
 docs-ja/pages/jetbrains-ja.md                  |  26 ++
 docs-ja/pages/keybindings-ja.md                |  41 +--
 docs-ja/pages/large-codebases-ja.md            |   2 +
 docs-ja/pages/legal-and-compliance-ja.md       |   2 +-
 docs-ja/pages/llm-gateway-connect-ja.md        |  48 ++-
 docs-ja/pages/llm-gateway-protocol-ja.md       |  16 +-
 docs-ja/pages/llm-gateway-rollout-ja.md        |   2 +-
 docs-ja/pages/managed-mcp-ja.md                |   9 +-
 docs-ja/pages/mcp-ja.md                        |  44 ++-
 docs-ja/pages/memory-ja.md                     |   4 +
 docs-ja/pages/microsoft-foundry-ja.md          |  10 +-
 docs-ja/pages/model-config-ja.md               |  71 +++--
 docs-ja/pages/network-config-ja.md             |  32 +-
 docs-ja/pages/overview-ja.md                   |   1 +
 docs-ja/pages/permission-modes-ja.md           |  78 +++--
 docs-ja/pages/permissions-ja.md                |  38 ++-
 docs-ja/pages/platforms-ja.md                  |   2 +-
 docs-ja/pages/plugin-dependencies-ja.md        |  37 ++-
 docs-ja/pages/plugin-hints-ja.md               |   2 +
 docs-ja/pages/plugin-marketplaces-ja.md        |  12 +-
 docs-ja/pages/plugins-reference-ja.md          |  55 +++-
 docs-ja/pages/prompt-caching-ja.md             |   2 +-
 docs-ja/pages/remote-control-ja.md             |  24 +-
 docs-ja/pages/routines-ja.md                   |  18 +-
 docs-ja/pages/sandbox-environments-ja.md       |   2 +-
 docs-ja/pages/sandboxing-ja.md                 |  21 +-
 docs-ja/pages/scheduled-tasks-ja.md            |   6 +-
 docs-ja/pages/security-ja.md                   |   2 +-
 docs-ja/pages/server-managed-settings-ja.md    |   6 +-
 docs-ja/pages/sessions-ja.md                   |   2 +-
 docs-ja/pages/settings-ja.md                   | 286 ++++++++++--------
 docs-ja/pages/setup-ja.md                      |   6 +
 docs-ja/pages/slack-ja.md                      |   2 +-
 docs-ja/pages/sub-agents-ja.md                 |  25 +-
 docs-ja/pages/terminal-config-ja.md            |   6 +-
 docs-ja/pages/third-party-integrations-ja.md   |  17 +-
 docs-ja/pages/tools-reference-ja.md            | 116 +++----
 docs-ja/pages/troubleshoot-install-ja.md       |  10 +-
 docs-ja/pages/troubleshooting-ja.md            |   6 +
 docs-ja/pages/vs-code-ja.md                    |  42 +--
 docs-ja/pages/workflows-ja.md                  |  30 +-
 docs-ja/pages/worktrees-ja.md                  |  24 +-
 docs-ja/pages/zero-data-retention-ja.md        |   1 +
 85 files changed, 1927 insertions(+), 934 deletions(-)
```

**新規追加:**


<details>
<summary>accessibility-ja.md</summary>

```diff
diff --git a/docs-ja/pages/accessibility-ja.md b/docs-ja/pages/accessibility-ja.md
index 15abedf..0e317ee 100644
--- a/docs-ja/pages/accessibility-ja.md
+++ b/docs-ja/pages/accessibility-ja.md
@@ -31,5 +31,5 @@ Claude Code には、ビジュアルターミナルインターフェースを
 SSH 経由で Claude Code を使用する場合は、Claude Code が実行されるリモートマシンで環境変数または設定を設定します。
 
-モードがオンの場合、Claude Code が最初に出力するのは、それをオンにした方法を名前付けする確認行です。`[Screen Reader Mode: on via flag]`、`[Screen Reader Mode: on via env]`、または `[Screen Reader Mode: on via settings]` です。このメソッド命名形式には Claude Code v2.1.206 以降が必要です。
+モードがオンの場合、Claude Code が最初に出力するのは、それをオンにした方法を名前付けする確認行です。`[Screen Reader Mode: on via flag]`、`[Screen Reader Mode: on via env]`、または `[Screen Reader Mode: on via settings]` です。このメソッド命名形式には Claude Code v2.1.206 以降が必要です。Claude Code が自身を再起動する場合（例えば、アップデートのインストールを完了するため）、新しいプロセスは `CLAUDE_AX_SCREEN_READER` 環境変数を通じてモードを継承するため、使用した方法に関係なく、その確認行は `[Screen Reader Mode: on via env]` と表示されます。
 {/* max-version: 2.1.205 */}以前のバージョンは `[Accessible screen reader mode: on]` を出力します。
 
```

</details>

<details>
<summary>admin-setup-ja.md</summary>

```diff
diff --git a/docs-ja/pages/admin-setup-ja.md b/docs-ja/pages/admin-setup-ja.md
index 78d75b8..ab3ff5b 100644
--- a/docs-ja/pages/admin-setup-ja.md
+++ b/docs-ja/pages/admin-setup-ja.md
@@ -96,7 +96,8 @@ WSL 2 ユーティリティ VM 内のプロセスは、Windows 側のエンド
 | [Managed policy CLAUDE.md](/ja/memory#deploy-organization-wide-claude-md)              | すべてのセッションで読み込まれる組織全体の指示。除外できない                                                                                                                                                                        | マネージドポリシーパスのファイル                                                                                       |
 | [MCP server control](/ja/managed-mcp)                                                  | ユーザーが追加または接続できる MCP サーバーを制限するか、固定セットをデプロイする                                                                                                                                                           | `allowedMcpServers`、`deniedMcpServers`、`allowManagedMcpServersOnly`、またはデプロイされた `managed-mcp.json` ファイル |
-| [Plugin marketplace control](/ja/plugin-marketplaces#managed-marketplace-restrictions) | ユーザーが追加およびインストールできるマーケットプレイスソースを制限し、単一実行のためにプラグイン、エージェント、MCP サーバーをサイドロードする CLI フラグを拒否する                                                                                                               | `strictKnownMarketplaces`、`blockedMarketplaces`、`disableSideloadFlags`                                 |
+| [Plugin marketplace control](/ja/plugin-marketplaces#managed-marketplace-restrictions) | ユーザーが追加およびインストールできるマーケットプレイスソースを制限し、単一実行のためにプラグイン、エージェント、MCP サーバーをサイドロードする CLI フラグを拒否し、どのマーケットプレイスのプラグインが提案されるかをホワイトリストに登録する                                                                          | `strictKnownMarketplaces`、`blockedMarketplaces`、`disableSideloadFlags`、`pluginSuggestionMarketplaces`  |
 | [Customization lockdown](/ja/settings#strictpluginonlycustomization)                   | スキル、エージェント、フック、および MCP サーバーをユーザーおよびプロジェクトソースからブロックし、プラグインまたはマネージド設定からのみ取得できるようにする                                                                                                                     | `strictPluginOnlyCustomization`                                                                        |
 | [Hook restrictions](/ja/settings#hook-configuration)                                   | マネージドフックのみが読み込まれる。HTTP フック URL を制限する                                                                                                                                                                  | `allowManagedHooksOnly`、`allowedHttpHookUrls`                                                          |
+| [Login enforcement](/ja/settings#available-settings)                                   | インタラクティブログインを特定の方法または Anthropic 組織に制限する。設定されている場合、`ANTHROPIC_API_KEY`、`ANTHROPIC_AUTH_TOKEN`、または `apiKeyHelper` によって認証されたセッションはスタートアップでブロックされます。クラウドプロバイダーセッションは影響を受けません                              | `forceLoginMethod`、`forceLoginOrgUUID`                                                                 |
 | [Disable agent view](/ja/agent-view#how-background-sessions-are-hosted)                | `claude agents`、`--bg`、`/background`、およびオンデマンドスーパーバイザーをオフにする                                                                                                                                          | `disableAgentView`                                                                                     |
 | [Model restrictions](/ja/model-config#restrict-model-selection)                        | `availableModels` はピッカーに表示されるモデルをフィルタリングします。`enforceAvailableModels` を追加すると、自動選択されるデフォルトモデルも制限されます。この設定が CLI、ウェブ、IDE にどのように到達するかについては、[surface coverage](/ja/model-config#surface-coverage) を参照してください | `availableModels`、`enforceAvailableModels`                                                             |
@@ -106,4 +107,6 @@ WSL 2 ユーティリティ VM 内のプロセスは、Windows 側のエンド
 claude.ai または Anthropic API を通じて認証するメンバーを持つ組織は、設定をデプロイせずにモデルを管理することもできます。[organization model restrictions](/ja/model-config#organization-model-restrictions) は個別のモデルを無効化し、[organization default model](/ja/model-config#organization-default-model) は新しいセッションが開始するモデルを設定し、[organization effort limits](/ja/model-config#organization-effort-limits) はロールごとのエフォートレベルを制限します。3 つのコントロールすべてに Claude Enterprise プランが必要です。モデル制限とエフォート制限はサーバー側で実行されます。デフォルトモデルは、組織がそれを実行しない限り、ユーザーが変更できる開始点です。実行は限定的な組織セットで利用可能です。可用性については、Anthropic アカウントチームにお問い合わせください。これらのコントロールのいずれも、Amazon Bedrock、Google Cloud の Agent Platform、Microsoft Foundry、または [Claude Platform on AWS](/ja/claude-platform-on-aws) 上のセッションには到達しません。これらのプロバイダーでは、制限に上記の `availableModels` を使用し、マネージド設定の `model` キーをデフォルトに使用してください。
 
+[Claude Code on the web](/ja/claude-code-on-the-web) には独自の管理サーフェスがあります。管理設定のクラウド環境ページで、オーナーと管理者は、メンバーのクラウドセッションの [network access level](/ja/claude-code-on-the-web#network-access)、環境変数、セットアップスクリプトを設定する [organization-shared environments](/ja/claude-code-on-the-web#organization-shared-environments) を作成し、組織のデフォルト環境を選択します。
+
 パーミッションルールとサンドボックスは異なるレイヤーをカバーします。WebFetch を拒否すると Claude の fetch ツールがブロックされますが、Bash が許可されている場合、`curl` と `wget` は依然として任意の URL に到達できます。サンドボックスは OS レベルで実行されるネットワークドメイン許可リストでそのギャップを閉じます。
 
@@ -116,10 +119,10 @@ claude.ai または Anthropic API を通じて認証するメンバーを持つ
 必要なレポート内容に基づいて監視を選択してください。ダッシュボード、API、支出管理は Claude for Teams または Enterprise プランと Claude Console 組織で異なるため、機能に基づいてレポートを計画する前に「利用可能性」列を確認してください。
 
-| 機能                     | 取得内容                                                                     | 利用可能性                                                                                                                                                                                                                                                             | 開始場所                                                  |
-| :--------------------- | :----------------------------------------------------------------------- | :---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :---------------------------------------------------- |
-| Usage monitoring       | セッション、ツール、トークンの OpenTelemetry エクスポート                                     | すべてのプロバイダー                                                                                                                                                                                                                                                        | [Monitoring usage](/ja/monitoring-usage)              |
-| Analytics dashboard    | Teams / Enterprise でのリーダーボード付き採用度と貢献度メトリクス、Console でのユーザーごとの使用状況と支出メトリクス | Teams / Enterprise は [claude.ai/analytics](https://claude.ai/analytics/claude-code)、Console は [platform.claude.com/claude-code](https://platform.claude.com/claude-code)                                                                                          | [Analytics](/ja/analytics)                            |
-| Programmatic reporting | API を通じたユーザーごとの使用状況とコストデータ                                               | Enterprise 向け [Enterprise Analytics API](https://support.claude.com/en/articles/13703965-claude-enterprise-analytics-api-reference-guide)、Console 向け [Claude Code Analytics API](https://platform.claude.com/docs/en/build-with-claude/claude-code-analytics-api) | [Costs](/ja/costs#manage-costs-for-your-organization) |
-| Spend controls         | 支出制限とレート制限                                                               | Teams / Enterprise の管理者設定、Console のワークスペース制限、サードパーティクラウドではクラウド予算管理またはユーザーごとの [支出制限](/ja/claude-apps-gateway-spend-limits) を備えた [Claude apps gateway](/ja/claude-apps-gateway)                                                                                     | [Costs](/ja/costs#manage-costs-for-your-organization) |
```

</details>

<details>
<summary>advisor-ja.md</summary>

```diff
diff --git a/docs-ja/pages/advisor-ja.md b/docs-ja/pages/advisor-ja.md
index c27253d..63997f9 100644
--- a/docs-ja/pages/advisor-ja.md
+++ b/docs-ja/pages/advisor-ja.md
@@ -8,5 +8,5 @@
 
 <Note>
-  advisor ツールは実験的機能であり、Anthropic API が必要です。Amazon Bedrock、Google Cloud の Agent Platform、Microsoft Foundry では利用できません。動作、価格設定、および利用可能性は変更される可能性があります。
+  advisor ツールは実験的機能であり、Anthropic API が必要です。Amazon Bedrock、Claude Platform on AWS、Google Cloud の Agent Platform、Microsoft Foundry では利用できません。動作、価格設定、および利用可能性は変更される可能性があります。
 </Note>
 
@@ -160,5 +160,5 @@ advisor モデル自体の会話の読み取りはキャッシュされません
 advisor ツールには、以下のすべてが必要です。
 
-* **Anthropic API のみ**：advisor はサーバー実行ツールです。Amazon Bedrock、Google Cloud の Agent Platform、または Microsoft Foundry では利用できません。[LLM ゲートウェイ](/ja/llm-gateway)を通じて `ANTHROPIC_BASE_URL` で構成されている場合、利用可能性はゲートウェイがリクエストを Anthropic API に完全に転送するかどうかに依存します。
+* **Anthropic API のみ**：advisor はサーバー実行ツールです。Amazon Bedrock、Claude Platform on AWS、Google Cloud の Agent Platform、または Microsoft Foundry では利用できません。[LLM ゲートウェイ](/ja/llm-gateway)を通じて `ANTHROPIC_BASE_URL` で構成されている場合、利用可能性はゲートウェイがリクエストを Anthropic API に完全に転送するかどうかに依存します。
 * **サポートされているメインモデル**：Opus 4.6 以降、Sonnet 4.6 以降、または Haiku 4.5。{/* min-version: 2.1.170 */}Fable 5 も Claude Code v2.1.170 以降で適格です。
 
```

</details>

<details>
<summary>agent-teams-ja.md</summary>

```diff
diff --git a/docs-ja/pages/agent-teams-ja.md b/docs-ja/pages/agent-teams-ja.md
index 97ea6f6..b982eb4 100644
--- a/docs-ja/pages/agent-teams-ja.md
+++ b/docs-ja/pages/agent-teams-ja.md
@@ -250,4 +250,6 @@ Ask the researcher teammate to shut down
 表示設定オプションについては、[表示モードを選択](#choose-a-display-mode) を参照してください。チームメンバーのメッセージはリーダーに自動的に到着します。
 
+各エージェントのメールボックスは `~/.claude/teams/{team-name}/inboxes/{agent-name}.json` にある JSON ファイルです。Claude Code はメールボックスファイルを読み取るときにすべてのエントリを検証します。メッセージ形式と一致しないエントリはエラーとして報告され、ファイルから削除されます。有効なメッセージは引き続き配信されます。v2.1.207 より前では、1 つの不正なメールボックスエントリが毎秒繰り返しエラーを引き起こし、ファイルを手動で削除するまでそのメールボックスの配信をブロックしていました。
+
 システムはタスク依存関係を自動的に管理します。チームメンバーが他のタスクが依存するタスクを完了すると、ブロックされたタスクは手動介入なしにブロック解除されます。
 
@@ -291,5 +293,7 @@ Spawn a teammate using the security-reviewer agent type to audit the auth module
 チームメンバーはリーダーの権限設定で開始します。リーダーが `--dangerously-skip-permissions` で実行する場合、すべてのチームメンバーも同様に実行します。生成後、個別のチームメンバーモードを変更できますが、生成時にチームメンバーごとのモードを設定することはできません。
 
-1 つのエージェントが `SendMessage` 経由で別のエージェントにメッセージを送信する場合、受信エージェントには、あなたからではなく別の Claude セッションから来たことが通知されます。チームメンバーは権限プロンプトを承認したり、あなたに代わって同意を提供したりすることはできません。また、アクションが拒否されたチームメンバーは、チェックをバイパスするために別のチームメンバーにそれをリレーすることはできません。[auto mode](/ja/permission-modes#eliminate-prompts-with-auto-mode) では、別のエージェントからリレーされた承認クレームは、あなたからの確認ではなく、信頼できない入力として分類器によって扱われます。チームメンバーの権限プロンプトはリーダーセッションにバブルアップするため、そこで自分で承認してください。
+1 つのエージェントが `SendMessage` 経由で別のエージェントにメッセージを送信する場合、受信エージェントには、あなたからではなく別の Claude セッションから来たことが通知されます。チームメンバーは権限プロンプトを承認したり、あなたに代わって同意を提供したりすることはできません。また、アクションが拒否されたチームメンバーは、チェックをバイパスするために別のチームメンバーにそれをリレーすることはできません。[auto mode](/ja/permission-modes#eliminate-prompts-with-auto-mode) では、別のエージェントからリレーされた承認クレームは、あなたからの確認ではなく、信頼できない入力として分類器によって扱われます。
+
+チームメンバーの権限プロンプトはリーダーセッションに表示されるため、そこで自分で承認してください。[プラン承認を要求する](#require-plan-approval-for-teammates) は設計された例外です。リーダーセッションはあなたへの別のプロンプトなしにチームメンバープラン承認を付与します。
 
 <h3 id="context-and-communication">
```

</details>

<details>
<summary>agent-view-ja.md</summary>

```diff
diff --git a/docs-ja/pages/agent-view-ja.md b/docs-ja/pages/agent-view-ja.md
index 319446e..2e85a74 100644
--- a/docs-ja/pages/agent-view-ja.md
+++ b/docs-ja/pages/agent-view-ja.md
@@ -71,9 +71,11 @@ Claude が複数の独立したタスクに対して、あなたが毎ステッ
 `claude agents` を `claude` の代わりにプライマリエントリーポイントとして使用できます。エージェントビューからすべてのタスクをディスパッチし、フル会話が必要な場合はアタッチし、`←` を押してテーブルに戻ります。
 
+{/* min-version: 2.1.205 */}通常の `claude` セッション内では、プロンプトフッターの `←` ヒントは、`← 2 agents` のように入力を待機中のバックグラウンドエージェントの数をカウントし、入力が必要なエージェントがない場合は `← for agents` に戻ります。99 を超えるカウントは `99+` として表示されます。カウントはターミナルがフォーカスされている間は約 10 秒ごとに更新され、フォーカスが戻ると即座に更新されます。カウントが移動したときとエージェントが完了したときに色が一時的に変わります。ただし、[`prefersReducedMotion` 設定](/ja/settings#available-settings)がオンの場合は除きます。また、[スクリーンリーダーモード](/ja/accessibility)では非表示になります。[Amazon Bedrock、Google Cloud の Agent Platform、Microsoft Foundry](/ja/third-party-integrations)では、ヒントはカウントなしの通常の `← for agents` 形式のままです。Claude Code v2.1.205 以降が必要です。
+
 <h2 id="monitor-sessions-with-agent-view">
   エージェントビューでセッションを監視する
 </h2>
 
-`claude agents` を実行してエージェントビューを開きます。ターミナル全体を占有し、状態でグループ化されたすべてのセッションをリストします。ピン留めされたセッションと入力が必要なセッションが上部に表示されます。各行はセッションの名前、現在のアクティビティ、最後に変更されてからの経過時間を表示します。
+`claude agents` を実行してエージェントビューを開きます。ターミナル全体を占有し、状態でグループ化されたすべてのセッションをリストします。ピン留めされたセッションと入力が必要なセッションが上部に表示されます。各行はセッションの名前、現在のアクティビティ、およびセッションが作成されてからの経過時間を表示します。完了したセッションの経過時間は、実行にかかった時間で固定されます。
 
 名前は、そのセッションで [`/color`](/ja/commands) によって設定されたカラーで色付けされます。{/* min-version: 2.1.199 */}v2.1.199 以降、`←` または `/background` で [セッションをバックグラウンドにする](#from-inside-a-session) ときにカラーが引き継がれます。
@@ -150,5 +152,7 @@ v2.1.198 以降、エージェントビューが開いている間、Claude Code
 各行の 1 行の概要は [Haiku クラスモデル](/ja/model-config) によって生成されるため、トランスクリプトを開かずにセッションが何をしているか、何が必要か、または何を生成したかを伝えることができます。セッションがアクティブに作業している間、行テキストはセッション自身の最近の出力から最大 15 秒ごとに 1 回更新され、モデルリクエストを送信せず、各ターンが終了したときに新しい概要を書きます。
 
-作業中の行はセッションが何をしているかを示し、ブロックされた行は質問を示します。長いターンの間、モデルは約 1 分ごとに概要を書き直し、各書き直しの後に 2 倍待機して最大 4 分まで待機するため、ビジーな行は古い概要を表示し続けません。テキストは 64 列で切り詰められます。[ピークパネル](#peek-and-reply) を開いて文全体を読みます。v2.1.205 より前では、作業中の行は生のツール呼び出しの代わりにレポートを表示でき、並列作業項目を実行しているセッションはテキストの前に `2/5` などの `done/total` カウントを表示していました。
+作業中の行はセッションが何をしているかを示し、ブロックされた行は質問を示します。長いターンの間、モデルは約 1 分ごとに概要を書き直し、各書き直しの後に 2 倍待機して最大 4 分まで待機するため、ビジーな行は古い概要を表示し続けません。概要テキストは行の残りの幅を埋め、ターミナルの右端でのみ切り詰められます。[ピークパネル](#peek-and-reply) を開いてエッジが切り詰める文を読みます。v2.1.205 より前では、作業中の行は生のツール呼び出しの代わりにレポートを表示でき、並列作業項目を実行しているセッションはテキストの前に `2/5` などの `done/total` カウントを表示していました。
+
+概要テキストは行の残りの幅を埋め、ターミナルの右端でのみ切り詰められます。[ピークパネル](#peek-and-reply) を開いてエッジが切り詰める文を読みます。v2.1.206 より前では、テキストはターミナル幅に関係なく 64 列で切り詰められていました。
 
 リストが [ディレクトリでグループ化](#organize-the-list) されている場合、概要はセッションの状態を色付きの単語で開きます。例えば `Needs input · double jump or wall climb?` のようになります。デフォルトの状態グループ化では、グループヘッダーはすでに状態を名前付けするため、行は概要のみを表示します。v2.1.205 より前では、ディレクトリでグループ化された行は状態の単語を持ちませんでした。
@@ -185,10 +189,20 @@ Claude Code はコマンド出力全体からプルリクエストを読み取
 </h3>
 
-選択した行で `Space` を押してピークパネルを開きます。セッションの完全なステータス文で開き、行が切り詰める部分と、変更されてからの経過時間、その後にセッションにリンクされたプルリクエストが続きます。入力を待機しているセッションの場合、尋ねている正確な質問も返信入力の上に表示されます。ほとんどの場合、ピークパネルで十分であり、フルトランスクリプトを開く必要はありません。
```

</details>

<details>
<summary>agents-ja.md</summary>

```diff
diff --git a/docs-ja/pages/agents-ja.md b/docs-ja/pages/agents-ja.md
index bc64ab4..7b0bd36 100644
--- a/docs-ja/pages/agents-ja.md
+++ b/docs-ja/pages/agents-ja.md
@@ -55,5 +55,5 @@
 * バックグラウンドセッションの場合、`claude agents` は [エージェントビュー](/ja/agent-view) を開きます。すべてのセッション、その状態、および入力が必要なセッションを表示する 1 つの画面です。
 * 現在のセッション内のサブエージェントの場合、名前付きバックグラウンドサブエージェントは @-メンション入力補完に状態とともに表示されます。{/* min-version: 2.1.198 */}v2.1.198 以降、`/agents` はパネルを開かなくなり、サブエージェントファイルの場所を指すお知らせを出力します。[カスタムサブエージェントを作成および編集](/ja/sub-agents#configure-subagents) するには、Claude に質問するか、ファイルを直接編集してください。名前は似ていますが、`/agents` は `claude agents` とは別です。
-* 現在のセッションのバックグラウンドで実行されているもの場合、`/tasks` は各項目をリストし、確認、アタッチ、または停止できます。
+* 現在のセッションのバックグラウンドで実行されているもの場合、`/tasks` は各項目をリストし、確認、アタッチ、または停止できます。リストには完了したサブエージェントも含まれます。
 * 動的ワークフローの場合、`/workflows` は実行中および完了した実行、各実行がある段階、および完了したエージェント数をリストします。
 
```

</details>

<details>
<summary>amazon-bedrock-ja.md</summary>

```diff
diff --git a/docs-ja/pages/amazon-bedrock-ja.md b/docs-ja/pages/amazon-bedrock-ja.md
index ccb026a..8878fc1 100644
--- a/docs-ja/pages/amazon-bedrock-ja.md
+++ b/docs-ja/pages/amazon-bedrock-ja.md
@@ -112,5 +112,5 @@ AWS 認証情報を持っていて、Amazon Bedrock を通じて Claude Code の
 </Steps>
 
-サインイン後、いつでも `/setup-bedrock` を実行してウィザードを再度開き、認証情報、リージョン、またはモデルピンを変更できます。
+サインイン後、いつでも `/setup-bedrock` を実行してウィザードを再度開き、認証情報、リージョン、またはモデルピンを変更できます。モデルピンステップは、現在ピン留めされているモデルから開始されます。ウィザードは `~/.claude/settings.json` に書き込むか、[`CLAUDE_CONFIG_DIR`](/ja/env-vars#variables) が設定されている場合は `$CLAUDE_CONFIG_DIR/settings.json` に書き込みます。
 
 <h2 id="set-up-manually">
@@ -155,10 +155,14 @@ export AWS_SESSION_TOKEN=your-session-token
 **オプション C：環境変数（SSO プロファイル）**
 
+`your-profile-name` をこれらのコマンドを実行する前に AWS プロファイルの名前に置き換えてください。
+
 ```bash theme={null}
-aws sso login --profile=<your-profile-name>
+aws sso login --profile=your-profile-name
 
 export AWS_PROFILE=your-profile-name
 ```
 
+Claude Code は、IAM Identity Center リージョンから役割認証情報をリクエストします。このリージョンはプロファイルの `sso_region` で指定されており、Amazon Bedrock を実行するリージョンと一致する必要はありません。{/* min-version: 2.1.208 */}v2.1.207 では、Amazon Bedrock リージョンが `sso_region` をオーバーライドしていたため、IAM Identity Center インスタンスが別のリージョンにあるプロファイルは `Session token not found or invalid` エラーで認証に失敗しました。
+
 **オプション D：AWS Management Console 認証情報**
 
@@ -177,4 +181,16 @@ export AWS_BEARER_TOKEN_BEDROCK=your-bedrock-api-key
 Amazon Bedrock API キーは、完全な AWS 認証情報を必要としない、より簡単な認証方法を提供します。[Amazon Bedrock API キーについて詳しく学習](https://aws.amazon.com/blogs/machine-learning/accelerate-ai-development-with-amazon-bedrock-api-keys/)してください。
 
```

</details>

<details>
<summary>analytics-ja.md</summary>

```diff
diff --git a/docs-ja/pages/analytics-ja.md b/docs-ja/pages/analytics-ja.md
index e6e77eb..4e183cf 100644
--- a/docs-ja/pages/analytics-ja.md
+++ b/docs-ja/pages/analytics-ja.md
@@ -229,5 +229,5 @@ PR マージ日の 21 日前から 2 日後のセッションが属性マッチ
 </h4>
 
-Enterprise プランでは、[Claude Enterprise Analytics API](https://support.claude.com/en/articles/13703965-claude-enterprise-analytics-api-reference-guide) は、Claude Code を含む Claude サーフェス全体で、組織のユーザーごとのエンゲージメント、使用状況、コストレポートを返します。プライマリオーナーが [claude.ai/analytics/api-keys](https://claude.ai/analytics/api-keys) で `read:analytics` スコープを持つキーを作成します。API は Teams プランでは利用できません。
+Enterprise プランでは、[Claude Enterprise Analytics API](https://platform.claude.com/docs/en/api/admin/analytics) は、Claude Code を含む Claude サーフェス全体で、組織のユーザーごとのエンゲージメント、使用状況、コストレポートを返します。プライマリオーナーが [claude.ai/analytics/api-keys](https://claude.ai/analytics/api-keys) で `read:analytics` スコープを持つキーを作成します。API は Teams プランでは利用できません。
 
 GitHub を通じてこのデータをクエリするには、`claude-code-assisted` でラベル付けされた PR を検索します。
```

</details>

*...以降省略*

</details>


<details>
<summary>2026-07-16</summary>

**変更ファイル:**

```
 docs-ja/pages/changelog.md | 40 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)
```

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index 61050ed..9daf8f0 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,44 @@
 # Changelog
 
+## 2.1.211
+
+- Added `--forward-subagent-text` flag and `CLAUDE_CODE_FORWARD_SUBAGENT_TEXT` environment variable to include subagent text and thinking in stream-json output
+- Fixed permission previews relayed to chat channels not neutralizing bidirectional-override, zero-width, and look-alike quote characters, so tool inputs cannot visually alter the approval message
+- Fixed auto mode overriding a PreToolUse hook's `ask` decision for unsandboxed Bash — a hook `ask` now floors the decision at a prompt
+- Fixed parallel Claude Code sessions all logging out simultaneously after wake-from-sleep when many sessions share one credential store
+- Fixed plugin MCP servers not reconnecting after an idle web session woke, leaving MCP calls failing until the next message
+- Fixed Claude Code on Vertex and Bedrock attempting the default Opus model at startup and printing a spurious fallback notice when a model is explicitly configured
+- Fixed subagents spawned with an explicit model override reverting to the parent's model when resumed or sent a follow-up message
+- Fixed nested `.claude/rules/*.md` files loading even when setting sources exclude project settings
+- Fixed file upload validation: filenames ending in a DOS device suffix (`.prn`) or trailing dot are now accepted, and files with multiple hard links are refused
+- Fixed file uploads to Claude in Chrome from remote and CLI sessions
+- Fixed edits that leave the input as "?" being silently swallowed and toggling the shortcuts panel
+- Fixed a startup hang when the Claude in Chrome extension is enabled but Chrome is not running
+- Fixed a 300ms delay revealing async content (Settings tabs, Stats, diff views, and other loading states)
+- Fixed reopening a just-stopped background session from the agents view starting a blank conversation under the same session id
+- Fixed `/loop` hiding the session from `/resume` after a single use
+- Fixed screen reader users losing the audible terminal bell after `/terminal-setup` or onboarding terminal setup
+- Fixed background jobs on LLM gateway auth (`ANTHROPIC_AUTH_TOKEN` + `ANTHROPIC_BASE_URL`) coming back "Not logged in" after the daemon respawns them
+- Fixed `claude agents` jobs becoming permanently undeletable when git no longer recognizes their worktree — the row now shows why the delete was refused instead of silently reappearing
+- Fixed `/clear` not resetting the session cost counter — the statusline's cost now starts at $0 after `/clear`
+- Fixed Claude in Chrome setup pages failing to open in the browser on Windows
+- Fixed headless print-mode sessions on Windows crashing or silently exiting when stdin is unreadable
```

</details>

</details>


<details>
<summary>2026-07-15</summary>

**変更ファイル:**

```
 docs-ja/pages/changelog.md | 90 +++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 89 insertions(+), 1 deletion(-)
```

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index 2438058..61050ed 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,92 @@
 # Changelog
 
+## 2.1.210
+
+- Added a live elapsed-time counter to the collapsed tool summary line so long-running tool calls visibly tick instead of looking stuck
+- Added a startup warning for `Write(path)`, `NotebookEdit(path)`, and `Glob(path)` permission rules — use `Edit(path)` or `Read(path)` instead
+- Fixed `isolation: 'worktree'` subagents being able to run git-mutating commands against the main repo checkout instead of their own isolated worktree
+- Fixed the `ultracode` keyword opt-in firing on non-human-originated input such as webhook payloads and relayed PR comments
+- Fixed a rendered text fragment leaking into crash telemetry when a UI component returned content outside a styled text element
+- Fixed paste markers leaking into external editors opened from Claude Code, which could appear as stray È/É characters around pasted text
+- Fixed `claude attach` sometimes failing with "job not found" or "agent is still starting" errors during session transitions — attach now waits for the daemon to settle, and terminal resizes during a slow attach are applied once it completes
+- Fixed a session crash when a tool's result renderer returned a numeric bigint value or plain text instead of a UI element
+- Fixed a hook callback timeout being misreported to the model as a user rejection, which made unattended sessions stop and wait
+- Fixed Claude assuming a `cd` took effect after its command was moved to the background; the tool result now states the working directory is unchanged
+- Fixed plugin-provided MCP servers being torn down when MCP servers are re-synced mid-session
+- Fixed plan approvals without edits being labeled "(edited by user)" and overwriting the plan file with a stale snapshot
+- Fixed `/doctor` skipping its auto-mode-default proposal on Bedrock, Vertex, and Foundry, where auto mode no longer needs an opt-in
+- Fixed Grep content mode claiming "No matches found" when paginating past the end of results
+- Fixed unmatched `$1`/`$2` positional placeholders in skills and commands being silently stripped; they are now preserved verbatim
+- Fixed plugin cache writes leaving temp files behind on failure and failing on locked-file renames on Windows and network filesystems
+- Fixed background workers crash-looping when a client resets its connection to the background service
+- Fixed `claude agents --effort ultracode` not reaching dispatched sessions; the value was silently dropped
+- Fixed pressing ← to open the agents view dropping the task tracker when returning to the session
+- Fixed the agents dashboard retaining pasted images from abandoned reply drafts after their session was deleted
+- Fixed killed background sessions leaving a permanent `git worktree lock` behind; the periodic sweep now releases locks whose owning process is gone
```

</details>

</details>


<details>
<summary>2026-07-14</summary>

**変更ファイル:**

```
 docs-ja/pages/admin-setup-ja.md             |  28 +-
 docs-ja/pages/advisor-ja.md                 |   5 +-
 docs-ja/pages/amazon-bedrock-ja.md          |   6 +-
 docs-ja/pages/analytics-ja.md               |   6 +-
 docs-ja/pages/best-practices-ja.md          |   4 +-
 docs-ja/pages/channels-ja.md                |   2 +-
 docs-ja/pages/channels-reference-ja.md      |   6 +-
 docs-ja/pages/checkpointing-ja.md           |   4 +-
 docs-ja/pages/chrome-ja.md                  |   2 +-
 docs-ja/pages/cli-reference-ja.md           |   4 +-
 docs-ja/pages/commands-ja.md                |   2 +-
 docs-ja/pages/common-workflows-ja.md        |   2 +-
 docs-ja/pages/computer-use-ja.md            |   5 +-
 docs-ja/pages/costs-ja.md                   |  71 +++-
 docs-ja/pages/deep-links-ja.md              |   4 -
 docs-ja/pages/desktop-ja.md                 |  11 +-
 docs-ja/pages/desktop-quickstart-ja.md      |   1 +
 docs-ja/pages/discover-plugins-ja.md        |   2 +-
 docs-ja/pages/env-vars-ja.md                | 582 ++++++++++++++--------------
 docs-ja/pages/errors-ja.md                  |   3 +-
 docs-ja/pages/fast-mode-ja.md               |   8 +-
 docs-ja/pages/feature-availability-ja.md    |   5 +-
 docs-ja/pages/fullscreen-ja.md              |  29 +-
 docs-ja/pages/glossary-ja.md                |   2 +-
 docs-ja/pages/google-vertex-ai-ja.md        |   6 +-
 docs-ja/pages/hooks-guide-ja.md             |   4 -
 docs-ja/pages/hooks-ja.md                   |   4 -
 docs-ja/pages/how-claude-code-works-ja.md   |   4 +-
 docs-ja/pages/keybindings-ja.md             |   4 -
 docs-ja/pages/mcp-ja.md                     |   2 +-
 docs-ja/pages/memory-ja.md                  |   4 -
 docs-ja/pages/permission-modes-ja.md        |   6 +-
 docs-ja/pages/plugin-marketplaces-ja.md     |  48 ++-
 docs-ja/pages/plugins-ja.md                 |   2 +-
 docs-ja/pages/prompt-caching-ja.md          |   4 -
 docs-ja/pages/remote-control-ja.md          |   6 +-
 docs-ja/pages/routines-ja.md                |   1 -
 docs-ja/pages/sandboxing-ja.md              |   2 +-
 docs-ja/pages/scheduled-tasks-ja.md         |   4 -
 docs-ja/pages/server-managed-settings-ja.md |   1 -
 docs-ja/pages/settings-ja.md                |  10 +-
 docs-ja/pages/sub-agents-ja.md              |   4 +-
 docs-ja/pages/terminal-config-ja.md         |   2 +-
 docs-ja/pages/tools-reference-ja.md         |   4 -
 docs-ja/pages/ultraplan-ja.md               |   2 +-
 docs-ja/pages/ultrareview-ja.md             |   2 +-
 docs-ja/pages/voice-dictation-ja.md         |   2 +-
 docs-ja/pages/web-quickstart-ja.md          |   2 +-
 48 files changed, 489 insertions(+), 435 deletions(-)
```

**新規追加:**


<details>
<summary>admin-setup-ja.md</summary>

```diff
diff --git a/docs-ja/pages/admin-setup-ja.md b/docs-ja/pages/admin-setup-ja.md
index 654e47d..78d75b8 100644
--- a/docs-ja/pages/admin-setup-ja.md
+++ b/docs-ja/pages/admin-setup-ja.md
@@ -70,4 +70,17 @@ plist と HKLM レジストリの場所は任意のプロバイダーで機能
 [Server-managed settings](/ja/server-managed-settings) と [Settings files and precedence](/ja/settings#settings-files) を参照してください。
 
+<h3 id="wsl-sessions-in-claude-code-desktop">
+  Claude Code Desktop の WSL セッション
+</h3>
+
+Windows では、[Claude Code Desktop は WSL 2 ディストリビューション内で Code セッションを実行できます](/ja/desktop-wsl)。セッションの Claude Code プロセスはディストリビューション内で実行されるため、上記の WSL 検出パスを通じてマネージド設定を解決します。`wslInheritsWindowsSettings: true` が展開されていない限り、Windows のみのソースはそれに到達しません。
+
+マネージド設定が存在するデバイスでは、Desktop WSL セッションはデフォルトで利用できません。組織がそれらを有効にしたい場合は、Anthropic アカウントチームに連絡してください。有効にされた場合：
+
+* HKLM レジストリまたは `C:\Program Files\ClaudeCode` ファイルを通じて `wslInheritsWindowsSettings: true` を展開して、WSL セッションがホストセッションと同じポリシーを継承するようにしてください。
+* WSL セッション内で `/status` を実行して検証してください。`Setting sources` 行は、展開した Windows ソース（`(HKLM)` または `(file)`）を含む `Enterprise managed settings` を表示する必要があります。
+
+WSL 2 ユーティリティ VM 内のプロセスは、Windows 側のエンドポイント検出センサーに表示されません。CrowdStrike Falcon を使用する場合は、CrowdStrike の WSL ドキュメントが必要とする 2 つの除外（WSL 仮想マシンプロセスと VM ディスクイメージ）を使用して、WSL 2 で Linux 用 Falcon センサーを有効にしてください。これにより、ディストリビューション内のプロセスとファイルアクティビティが観察可能になります。Claude Code の [OpenTelemetry ツール実行テレメトリ](/ja/monitoring-usage) は WSL とネイティブセッションで同じように出力されます。
+
 <h2 id="decide-what-to-enforce">
   実行する内容を決定する
@@ -101,13 +114,14 @@ claude.ai または Anthropic API を通じて認証するメンバーを持つ
 </h2>
 
-必要なレポート内容に基づいて監視を選択してください。
+必要なレポート内容に基づいて監視を選択してください。ダッシュボード、API、支出管理は Claude for Teams または Enterprise プランと Claude Console 組織で異なるため、機能に基づいてレポートを計画する前に「利用可能性」列を確認してください。
 
-| 機能                  | 取得内容                                 | 利用可能性                                                                                                                                   | 開始場所                                     |
-| :------------------ | :----------------------------------- | :-------------------------------------------------------------------------------------------------------------------------------------- | :--------------------------------------- |
```

</details>

<details>
<summary>advisor-ja.md</summary>

```diff
diff --git a/docs-ja/pages/advisor-ja.md b/docs-ja/pages/advisor-ja.md
index 3d40e5f..c27253d 100644
--- a/docs-ja/pages/advisor-ja.md
+++ b/docs-ja/pages/advisor-ja.md
@@ -7,8 +7,6 @@
 > メインモデルをより強力な advisor モデルと組み合わせて、タスク中の重要な瞬間に Claude が相談できるようにします。
 
-{/* plan-availability: feature=advisor providers=anthropic */}
-
 <Note>
-  advisor ツールは実験的機能であり、Anthropic API を使用する Claude Code v2.1.98 以降が必要です。Amazon Bedrock、Google Cloud の Agent Platform、Microsoft Foundry では利用できません。動作、価格設定、および利用可能性は変更される可能性があります。
+  advisor ツールは実験的機能であり、Anthropic API が必要です。Amazon Bedrock、Google Cloud の Agent Platform、Microsoft Foundry では利用できません。動作、価格設定、および利用可能性は変更される可能性があります。
 </Note>
 
@@ -162,5 +160,4 @@ advisor モデル自体の会話の読み取りはキャッシュされません
 advisor ツールには、以下のすべてが必要です。
 
-* **Claude Code v2.1.98 以降**：`claude update` を実行してアップグレードします。
 * **Anthropic API のみ**：advisor はサーバー実行ツールです。Amazon Bedrock、Google Cloud の Agent Platform、または Microsoft Foundry では利用できません。[LLM ゲートウェイ](/ja/llm-gateway)を通じて `ANTHROPIC_BASE_URL` で構成されている場合、利用可能性はゲートウェイがリクエストを Anthropic API に完全に転送するかどうかに依存します。
 * **サポートされているメインモデル**：Opus 4.6 以降、Sonnet 4.6 以降、または Haiku 4.5。{/* min-version: 2.1.170 */}Fable 5 も Claude Code v2.1.170 以降で適格です。
```

</details>

<details>
<summary>amazon-bedrock-ja.md</summary>

```diff
diff --git a/docs-ja/pages/amazon-bedrock-ja.md b/docs-ja/pages/amazon-bedrock-ja.md
index a50c82f..ccb026a 100644
--- a/docs-ja/pages/amazon-bedrock-ja.md
+++ b/docs-ja/pages/amazon-bedrock-ja.md
@@ -333,5 +333,5 @@ export ENABLE_PROMPT_CACHING_1H=1
 </h2>
 
-Claude Code が Amazon Bedrock で設定されて起動すると、使用するモデルがアカウントでアクセス可能であることを確認します。このチェックには Claude Code v2.1.94 以降が必要です。
+Claude Code が Amazon Bedrock で設定されて起動すると、使用するモデルがアカウントでアクセス可能であることを確認します。
 
 現在の Claude Code デフォルトより古いモデルバージョンをピン留めしていて、アカウントが新しいバージョンを呼び出せる場合、Claude Code はピンを更新するよう促します。受け入れると、新しいモデル ID が [user settings file](/ja/settings) に書き込まれ、Claude Code が再起動されます。拒否すると、次のデフォルトバージョン変更まで記憶されます。[アプリケーション推論プロファイル ARN](#map-each-model-version-to-an-inference-profile)を指す PIN は、管理者によって管理されるため、スキップされます。
@@ -436,8 +436,4 @@ Claude Code は、各リクエストで `X-Amzn-Bedrock-Service-Tier` ヘッダ
 Mantle は、Bedrock Invoke API ではなく、ネイティブ Anthropic API シェイプを通じて Claude モデルを提供する Amazon Bedrock エンドポイントです。同じ AWS 認証情報、IAM 権限、および `awsAuthRefresh` 設定を使用します。このページで前述したものです。
 
-<Note>
-  Mantle には Claude Code v2.1.94 以降が必要です。確認するには `claude --version` を実行してください。
-</Note>
-
 <h3 id="enable-mantle">
   Mantle を有効にする
```

</details>

<details>
<summary>analytics-ja.md</summary>

```diff
diff --git a/docs-ja/pages/analytics-ja.md b/docs-ja/pages/analytics-ja.md
index 741d0b1..e6e77eb 100644
--- a/docs-ja/pages/analytics-ja.md
+++ b/docs-ja/pages/analytics-ja.md
@@ -27,5 +27,5 @@ Team と Enterprise ダッシュボードには以下が含まれます。
 * **データエクスポート**：カスタムレポート用に貢献データを CSV としてダウンロード
 
-ユーザーごとのトークン数とコスト推定については、[OpenTelemetry エクスポート](/ja/monitoring-usage)を構成してください。
+ユーザーごとのトークン数とコスト推定については、[OpenTelemetry エクスポート](/ja/monitoring-usage)を構成するか、組織の分析設定から[支出レポート](https://support.claude.com/en/articles/12883420-view-usage-analytics-for-team-and-enterprise-plans)をエクスポートしてください。これはユーザーごと、モデルごとのトークン使用量と推定使用クレジット支出を一覧表示します。
 
 <h3 id="enable-contribution-metrics">
@@ -229,4 +229,6 @@ PR マージ日の 21 日前から 2 日後のセッションが属性マッチ
 </h4>
 
+Enterprise プランでは、[Claude Enterprise Analytics API](https://support.claude.com/en/articles/13703965-claude-enterprise-analytics-api-reference-guide) は、Claude Code を含む Claude サーフェス全体で、組織のユーザーごとのエンゲージメント、使用状況、コストレポートを返します。プライマリオーナーが [claude.ai/analytics/api-keys](https://claude.ai/analytics/api-keys) で `read:analytics` スコープを持つキーを作成します。API は Teams プランでは利用できません。
+
 GitHub を通じてこのデータをクエリするには、`claude-code-assisted` でラベル付けされた PR を検索します。
 
@@ -235,5 +237,5 @@ GitHub を通じてこのデータをクエリするには、`claude-code-assist
 </h2>
 
-Claude Console を使用している API カスタマーは、[platform.claude.com/claude-code](https://platform.claude.com/claude-code) で分析にアクセスできます。ダッシュボードにアクセスするには UsageView 権限が必要です。これは Developer、Billing、Admin、Owner、Primary Owner ロールに付与されます。
+Claude Console を使用している API カスタマーは、[platform.claude.com/claude-code](https://platform.claude.com/claude-code) で分析にアクセスできます。ダッシュボードにアクセスするには UsageView 権限が必要です。これは Developer、Billing、Admin、Owner、Primary Owner ロールに付与されます。同じ日次ユーザーごとのメトリクスをプログラムで取得するには、Admin API キーを使用して [Claude Code Analytics API](https://platform.claude.com/docs/ja/build-with-claude/claude-code-analytics-api) を使用してください。
 
 <Note>
```

</details>

<details>
<summary>best-practices-ja.md</summary>

```diff
diff --git a/docs-ja/pages/best-practices-ja.md b/docs-ja/pages/best-practices-ja.md
index 2b85e48..8b11ac2 100644
--- a/docs-ja/pages/best-practices-ja.md
+++ b/docs-ja/pages/best-practices-ja.md
@@ -482,5 +482,5 @@ Claude は変更前に自動的にファイルをスナップショットする
 
 <Warning>
-  チェックポイントは Claude が行った変更のみを追跡します。外部プロセスではありません。これは git の代替ではありません。
+  チェックポイントは Claude が行った変更のみを追跡します。Bash コマンドまたは外部プロセスを通じて行われた変更はキャプチャされません。これは git の代替ではありません。
 </Warning>
 
@@ -513,5 +513,5 @@ Claude Code は会話をローカルに保存するため、タスクが複数
 </Tip>
 
-`claude -p "your prompt"` を使用すると、セッションなしで Claude を非対話的に実行できます。[非対話型モード](/ja/headless)は、Claude を CI パイプライン、プリコミットフック、または自動化されたワークフローに統合する方法です。出力形式を使用すると、結果をプログラムで解析できます。プレーンテキスト、JSON、またはストリーミング JSON です。
+`claude -p "your prompt"` を使用すると、セッションなしで Claude を非対話的に実行できます。実行は `--no-session-persistence` を渡さない限り、再開可能なセッションを作成します。[非対話型モード](/ja/headless)は、Claude を CI パイプライン、プリコミットフック、または自動化されたワークフローに統合する方法です。出力形式を使用すると、結果をプログラムで解析できます。プレーンテキスト、JSON、またはストリーミング JSON です。
 
 ```bash theme={null}
```

</details>

<details>
<summary>channels-ja.md</summary>

```diff
diff --git a/docs-ja/pages/channels-ja.md b/docs-ja/pages/channels-ja.md
index fa35a06..c25f963 100644
--- a/docs-ja/pages/channels-ja.md
+++ b/docs-ja/pages/channels-ja.md
@@ -8,5 +8,5 @@
 
 <Note>
-  チャネルは[リサーチプレビュー](#research-preview)段階にあり、Claude Code v2.1.80 以降が必要です。Anthropic 認証が claude.ai または Console API キーを通じて必要で、Amazon Bedrock、Google Cloud の Agent Platform、Microsoft Foundry では利用できません。Team および Enterprise 組織は[明示的に有効にする](#enterprise-controls)必要があります。
+  チャネルは[リサーチプレビュー](#research-preview)段階にあります。Anthropic 認証が claude.ai または Console API キーを通じて必要で、Amazon Bedrock、Google Cloud の Agent Platform、Microsoft Foundry では利用できません。Team および Enterprise 組織は[明示的に有効にする](#enterprise-controls)必要があります。
 </Note>
 
```

</details>

<details>
<summary>channels-reference-ja.md</summary>

```diff
diff --git a/docs-ja/pages/channels-reference-ja.md b/docs-ja/pages/channels-reference-ja.md
index b4e2b2e..b947579 100644
--- a/docs-ja/pages/channels-reference-ja.md
+++ b/docs-ja/pages/channels-reference-ja.md
@@ -8,5 +8,5 @@
 
 <Note>
-  チャネルは[リサーチプレビュー](/ja/channels#research-preview)段階にあり、Claude Code v2.1.80 以降が必要です。Team および Enterprise 組織は[明示的に有効化](/ja/channels#enterprise-controls)する必要があります。
+  チャネルは[リサーチプレビュー](/ja/channels#research-preview)段階にあります。Team および Enterprise 組織は[明示的に有効化](/ja/channels#enterprise-controls)する必要があります。
 </Note>
 
@@ -454,8 +454,4 @@ await mcp.notification({ ... })
 </h2>
 
-<Note>
-  権限リレーには Claude Code v2.1.81 以降が必要です。以前のバージョンは `claude/channel/permission` 機能を無視します。
-</Note>
-
 Claude が承認が必要なツールを呼び出すと、ローカルターミナルダイアログが開き、セッションが待機します。双方向チャネルは、同じプロンプトを並行して受け取り、別のデバイスでそれをリレーすることを選択できます。両方がライブのままです：ターミナルまたは電話で答えることができ、Claude Code は最初に到着した答えを適用し、もう一方を閉じます。
 
```

</details>

<details>
<summary>checkpointing-ja.md</summary>

```diff
diff --git a/docs-ja/pages/checkpointing-ja.md b/docs-ja/pages/checkpointing-ja.md
index 4611de8..adfc41b 100644
--- a/docs-ja/pages/checkpointing-ja.md
+++ b/docs-ja/pages/checkpointing-ja.md
@@ -13,5 +13,5 @@ Claude Code は、作業中に Claude が行ったファイルエディットを
 </h2>
 
-Claude で作業する際、チェックポイント機能は各エディット前のコード状態を自動的にキャプチャします。このセーフティネットにより、野心的で大規模なタスクを実行する際に、いつでも以前のコード状態に戻ることができるという安心感を持って作業できます。
+Claude で作業する際、チェックポイント機能は各ユーザープロンプト前のコード状態を自動的にキャプチャします。このセーフティネットにより、野心的で大規模なタスクを実行する際に、いつでも以前のコード状態に戻ることができるという安心感を持って作業できます。
 
 <h3 id="automatic-tracking">
@@ -22,5 +22,5 @@ Claude Code は、ファイル編集ツールで行われたすべての変更
 
 * ユーザープロンプトごとに新しいチェックポイントが作成されます
-* チェックポイントはセッション間で保持されるため、再開した会話でアクセスできます
+* チェックポイントはセッションと共に保存されるため、再開したセッションでも `/rewind` で戻ることができます
 * セッション終了後 30 日後に自動的にクリーンアップされます（設定可能）
 
```

</details>

*...以降省略*

</details>


<details>
<summary>2026-07-12</summary>

**変更ファイル:**

```
 docs-ja/pages/amazon-bedrock-ja.md         | 10 +++++-----
 docs-ja/pages/changelog.md                 | 27 +++++++++++++++++++++++++++
 docs-ja/pages/claude-platform-on-aws-ja.md |  4 ++--
 docs-ja/pages/communications-kit-ja.md     | 24 ++++++++++++------------
 docs-ja/pages/desktop-ja.md                |  2 +-
 docs-ja/pages/desktop-linux-ja.md          | 12 ++++++++++--
 docs-ja/pages/errors-ja.md                 | 26 +++++++++++++-------------
 docs-ja/pages/glossary-ja.md               |  2 +-
 docs-ja/pages/google-vertex-ai-ja.md       | 10 +++++-----
 docs-ja/pages/how-claude-code-works-ja.md  |  2 +-
 docs-ja/pages/model-config-ja.md           | 22 +++++++++++++++-------
 docs-ja/pages/permission-modes-ja.md       |  2 +-
 docs-ja/pages/permissions-ja.md            | 12 ++++++------
 docs-ja/pages/security-ja.md               |  4 ++--
 docs-ja/pages/setup-ja.md                  |  2 +-
 docs-ja/pages/tools-reference-ja.md        |  2 ++
 docs-ja/pages/troubleshoot-install-ja.md   |  2 +-
 docs-ja/pages/troubleshooting-ja.md        |  2 +-
 docs-ja/pages/vs-code-ja.md                |  4 ++--
 19 files changed, 108 insertions(+), 63 deletions(-)
```

<details>
<summary>amazon-bedrock-ja.md</summary>

```diff
diff --git a/docs-ja/pages/amazon-bedrock-ja.md b/docs-ja/pages/amazon-bedrock-ja.md
index 1b124cd..a50c82f 100644
--- a/docs-ja/pages/amazon-bedrock-ja.md
+++ b/docs-ja/pages/amazon-bedrock-ja.md
@@ -268,5 +268,5 @@ Claude Code で Amazon Bedrock を有効にする場合は、以下に注意し
 これらの環境変数を特定の Amazon Bedrock モデル ID に設定します。
 
-`ANTHROPIC_DEFAULT_OPUS_MODEL` なしでは、Amazon Bedrock の `opus` エイリアスは Opus 4.6 に解決されます。最新モデルを使用するには、Opus 4.8 ID に設定します。
+これらの変数がない場合、Amazon Bedrock の `opus` エイリアスは Opus 4.8 に解決され、`sonnet` エイリアスは Sonnet 4.5 に解決されます。各変数を設定して、そのエイリアスを特定のバージョンにピン留めします。
 
 ```bash theme={null}
@@ -280,8 +280,8 @@ export ANTHROPIC_DEFAULT_HAIKU_MODEL='us.anthropic.claude-haiku-4-5-20251001-v1:
 ピン留め変数が設定されていない場合、Claude Code はこれらのデフォルトモデルを使用します。
 
-| モデルタイプ   | デフォルト値                                         |
-| :------- | :--------------------------------------------- |
-| プライマリモデル | `us.anthropic.claude-sonnet-4-5-20250929-v1:0` |
-| 小型/高速モデル | プライマリモデルと同じ                                    |
+| モデルタイプ   | デフォルト値                         |
+| :------- | :----------------------------- |
+| プライマリモデル | `us.anthropic.claude-opus-4-8` |
+| 小型/高速モデル | プライマリモデルと同じ                    |
 
 セッションタイトル生成などのバックグラウンドタスクは、小型/高速モデル（通常は Haiku クラスモデル）を使用します。Amazon Bedrock では、すべてのアカウントまたはリージョンで Haiku が有効になっていない可能性があるため、Claude Code はこれをプライマリモデルにデフォルト設定します。バックグラウンドタスクに Haiku を使用するには、`ANTHROPIC_DEFAULT_HAIKU_MODEL` をアカウントで利用可能なモデル ID に設定してください。
```

</details>

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index a1320bd..2438058 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,31 @@
 # Changelog
 
+## 2.1.207
+
+- Auto mode is now available without `CLAUDE_CODE_ENABLE_AUTO_MODE` opt-in on Bedrock, Vertex AI, and Foundry; disable via `disableAutoMode` in settings
+- Fixed the terminal freezing and keystrokes lagging while streaming responses containing very long lists, tables, paragraphs, or code blocks
+- Fixed remote managed settings from a non-interactive run (`claude -p`, the SDK) being permanently recorded as consented without ever showing the security consent dialog
+- Fixed spurious prompt-injection warnings triggered by benign system-generated conversation updates
+- Fixed the auto-updater overwriting a custom launcher script or symlink at `~/.local/bin/claude` on every release; `/doctor` now reports an externally managed launcher
+- Fixed compound commands with `cd` prompting for permission when the only output redirect was to `/dev/null`
+- Fixed the transcript jumping above the start of the answer when a response finishes streaming
+- Fixed `extensions.worktreeConfig` being left in the repo's `.git/config` (breaking go-git tools like `tea`) after the last `worktree.sparsePaths` worktree was removed
+- Fixed malformed bracket patterns in rules globs, skill paths, `.ignore`, and `.worktreeinclude` breaking file reads, file suggestions, and worktree creation
+- Fixed a crash loop in agent teams where a malformed teammate mailbox message caused repeated errors every second until the mailbox file was manually deleted
+- Fixed background sessions auto-named by accepting a plan not showing that name on their agent-view row
+- Fixed background sessions that entered a git worktree resuming blank after a cold reopen from the agent list
+- Fixed Remote Control task status updates being lost when the connection recovered from a network interruption or credential refresh
+- Fixed Remote Control sessions hosted by the desktop app not showing background agent and workflow progress on mobile and web
+- Fixed Deep research runs labeling every Fetch-phase agent "unknown" — chips now show the source hostname
+- Fixed Bedrock repeatedly requesting fresh AWS SSO credentials from IAM Identity Center on every API request
+- Improved agent view: pasting the same text again now expands the collapsed `[Pasted text #N]` placeholder instead of adding a second one
+- Improved agent view: blocked session peeks now lead with the question and show a worded staleness clock (`waiting 3m`) instead of the same timestamp twice
+- Changed Bedrock, Vertex, and Claude Platform on AWS to default to Claude Opus 4.8
+- Changed auto mode to no longer read `autoMode` from `.claude/settings.local.json` (repo-resident); use `~/.claude/settings.json` instead
+- Fixed an indefinite hang on Windows when AWS credential resolution stalls (e.g. a stuck `credential_process`): the 60-second stall guard now fires instead of waiting forever.
```

</details>

<details>
<summary>claude-platform-on-aws-ja.md</summary>

```diff
diff --git a/docs-ja/pages/claude-platform-on-aws-ja.md b/docs-ja/pages/claude-platform-on-aws-ja.md
index 1b02308..17daf8b 100644
--- a/docs-ja/pages/claude-platform-on-aws-ja.md
+++ b/docs-ja/pages/claude-platform-on-aws-ja.md
@@ -277,5 +277,5 @@ AWS 上の Claude Platform は、環境に AWS 認証情報が存在する場合
 </h3>
 
-AWS 上の Claude Platform は、直接 Claude API と同じモデル ID を使用します。デフォルトのエイリアス `fable`、`opus`、`sonnet`、`haiku` は Claude Code の AWS 上の Claude Platform 用の組み込みデフォルトに解決されます。これは最新リリースより遅れる可能性があります。`ANTHROPIC_DEFAULT_OPUS_MODEL` がない場合、`opus` エイリアスは Opus 4.7 に解決されます。
+AWS 上の Claude Platform は、直接 Claude API と同じモデル ID を使用します。デフォルトのエイリアス `fable`、`opus`、`sonnet`、`haiku` は Claude Code の AWS 上の Claude Platform 用の組み込みデフォルトに解決されます。これは最新リリースより遅れる可能性があります。`ANTHROPIC_DEFAULT_OPUS_MODEL` がない場合、`opus` エイリアスは Opus 4.8 に解決されます。
 
 Claude Code をチームにデプロイする場合、モデル ID を明示的にピン留めして、新しいリリースがすべてのユーザーを一度に移動しないようにします。
@@ -283,5 +283,5 @@ Claude Code をチームにデプロイする場合、モデル ID を明示的
 ```bash theme={null}
 export ANTHROPIC_DEFAULT_FABLE_MODEL=claude-fable-5
-export ANTHROPIC_DEFAULT_OPUS_MODEL=claude-opus-4-7
+export ANTHROPIC_DEFAULT_OPUS_MODEL=claude-opus-4-8
 export ANTHROPIC_DEFAULT_SONNET_MODEL=claude-sonnet-5
 export ANTHROPIC_DEFAULT_HAIKU_MODEL=claude-haiku-4-5
```

</details>

<details>
<summary>communications-kit-ja.md</summary>

```diff
diff --git a/docs-ja/pages/communications-kit-ja.md b/docs-ja/pages/communications-kit-ja.md
index 3ed2b52..30abae1 100644
--- a/docs-ja/pages/communications-kit-ja.md
+++ b/docs-ja/pages/communications-kit-ja.md
@@ -329,8 +329,8 @@ Claude が「見る」ことができるようにコンポーネントの 200 
 
 *Shift+Tab* は Claude が得る権限の量を循環させます。*Manual*（`default` 設定値）
-は各アクションの前に尋ね、*acceptEdits* はファイル編集と一般的なファイル
-システムコマンドがフローを通して流れることを許可しながら、他のシェル
-コマンドの前にチェックし、*plan* は何かに触れる前に承認のための変更を
-提案します。Plan モードは信頼構築者なので、複数のファイルに触れるもの
+はファイル編集とほとんどのシェルコマンドの前に尋ね、*acceptEdits* はファイル
+編集と一般的なファイルシステムコマンドがフローを通して流れることを許可しながら、
+他のシェルコマンドの前にチェックし、*plan* は何かに触れる前に承認のための
+変更を提案します。Plan モードは信頼構築者なので、複数のファイルに触れるもの
 については最初にそこから始めてください。
 
@@ -545,12 +545,12 @@ Claude Code から跳ね返るほとんどの人は、これらの 1 つをス
 最も頻繁に聞かれる質問への 1 行の返信。
 
-| 質問                      | 回答                                                                                                                                       |
-| ----------------------- | ---------------------------------------------------------------------------------------------------------------------------------------- |
-| 「VS Code で動作しますか？」      | はい。VS Code 拡張機能と JetBrains プラグインがあり、エディタに埋め込まれた同じ機能があります。[VS Code →](/ja/vs-code)                                                        |
-| 「最初に何かを設定する必要がありますか？」   | いいえ。インストールしてから、任意のリポジトリで `claude` を実行してください。`/init` を 1 回実行すれば完了です。[クイックスタート →](/ja/quickstart)                                          |
-| 「私のコードはどこに行きますか？」       | CLI はターミナルで実行され、コンテキストを Anthropic の API に送信して推論を行い、第三者のサーバーはありません。エンタープライズプランの下では、コードとプロンプトはモデルのトレーニングに使用されません。[データ使用 →](/ja/data-usage) |
-| 「リポジトリ全体を見ることができますか？」   | アクセス権を与えたものを読みます。作業ディレクトリ内のファイル読み取りはプロンプトしません。許可プロンプトはゲート編集、シェルコマンド、およびそのディレクトリの外側のすべてです。[許可 →](/ja/permissions)                         |
-| 「これは Copilot とどう違いますか？」 | Copilot は行を自動補完します。Claude Code はファイルを読み、コマンドを実行し、マルチファイル編集を行うエージェントです。[概要 →](/ja/overview)                                               |
-| 「最初に何を試すべきですか？」         | 退屈だから先延ばしにしていたバグ。「\[ファイル] のテストは不安定です、理由を調べてください。」[クイックスタート →](/ja/quickstart)                                                            |
+| 質問                      | 回答                                                                                                                                                                                                                                                            |
+| ----------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
```

</details>

<details>
<summary>desktop-ja.md</summary>

```diff
diff --git a/docs-ja/pages/desktop-ja.md b/docs-ja/pages/desktop-ja.md
index 9354858..825d8c8 100644
--- a/docs-ja/pages/desktop-ja.md
+++ b/docs-ja/pages/desktop-ja.md
@@ -95,5 +95,5 @@ Code タブの以前のバージョンでは、これらのモードを Ask perm
 <span id="auto-mode-availability" />
 
-Auto mode は Anthropic API のすべてのユーザーが利用できる研究プレビューです。Claude Opus 4.6 以降、または Sonnet 4.6 以降が必要です。Google Cloud の Agent Platform にルーティングするエンタープライズデプロイメントでは、[`CLAUDE_CODE_ENABLE_AUTO_MODE`を設定](/ja/permission-modes#enable-auto-mode-on-bedrock-agent-platform-or-foundry)するまで auto mode はオフになり、そこでは Claude Sonnet 5、Opus 4.7、および Opus 4.8 のみがサポートされています。
+Auto mode は Anthropic API のすべてのユーザーが利用でき、Claude Opus 4.6 以降、または Sonnet 4.6 以降が必要です。Google Cloud の Agent Platform にルーティングするエンタープライズデプロイメントでは、[`CLAUDE_CODE_ENABLE_AUTO_MODE`を設定](/ja/permission-modes#enable-auto-mode-on-bedrock-agent-platform-or-foundry)するまで auto mode はオフになり、そこでは Claude Sonnet 5、Opus 4.7、および Opus 4.8 のみがサポートされています。
 
 <Tip title="ベストプラクティス">
```

</details>

<details>
<summary>desktop-linux-ja.md</summary>

```diff
diff --git a/docs-ja/pages/desktop-linux-ja.md b/docs-ja/pages/desktop-linux-ja.md
index 3142b4f..0f8fb38 100644
--- a/docs-ja/pages/desktop-linux-ja.md
+++ b/docs-ja/pages/desktop-linux-ja.md
@@ -76,5 +76,13 @@ Anthropic の apt リポジトリからインストールして、更新がシ
 </h3>
 
-apt リポジトリを使用できない場合は、まず [claude.com/download](https://claude.com/download) からアーキテクチャ（x64 または arm64）に対応した `.deb` パッケージをダウンロードしてから、ダウンロードしたファイルをソフトウェアインストーラーで開くか、ダウンロードしたファイルが含まれているディレクトリから apt でインストールします。
+apt リポジトリを使用できない場合は、リポジトリのパッケージプールから `.deb` パッケージを直接ダウンロードしてください。このコマンドはリポジトリインデックスでアーキテクチャに対応した最新パッケージを検索し、現在のディレクトリにダウンロードします。
+
+```bash theme={null}
+curl -fLO "https://downloads.claude.ai/claude-desktop/apt/stable/$(curl -s "https://downloads.claude.ai/claude-desktop/apt/stable/dists/stable/main/binary-$(dpkg --print-architecture)/Packages" | grep '^Filename: pool/main/c/claude-desktop/claude-desktop_' | sort -V | tail -n 1 | cut -d' ' -f2)"
+```
+
+コマンドが `Remote file name has no length` で失敗する場合、検索がパッケージパスを返しませんでした。これはリポジトリインデックスを取得できなかった場合（例えば、ネットワークが `downloads.claude.ai` をブロックしている場合）、またはアーキテクチャに対応したパッケージが存在しない場合を意味します。ネットワークが `downloads.claude.ai` に到達できることを確認し、`dpkg --print-architecture` が `amd64` または `arm64` を出力することを確認してください。リポジトリは他のアーキテクチャのパッケージを公開していません。
+
+次に、ダウンロードしたファイルをソフトウェアインストーラー（GNOME Software など）で開くか、ダウンロードしたファイルが含まれているディレクトリから apt でインストールします。
 
 ```bash theme={null}
@@ -84,5 +92,5 @@ sudo apt install ./claude-desktop_*.deb
 apt が `E: Unsupported file ./claude-desktop_*.deb given on commandline` を報告する場合、パターンが現在のディレクトリ内の `.deb` ファイルと一致しませんでした。ダウンロードが完了したことを確認してから、ファイルが含まれているディレクトリからコマンドを再度実行してください。
 
-この方法でインストールされた `.deb` は更新を受け取りません。apt を通じて更新を取得するには、上記のようにリポジトリを追加するか、パッケージが `/etc/apt/sources.list.d/claude-desktop.list` に書き込むプレースホルダーエントリの `deb` 行をコメント解除します。
+この方法でインストールされた `.deb` は更新を受け取りません。apt を通じて更新を取得するには、[Anthropic の apt リポジトリを追加する](#install) ステップからリポジトリを登録してください。パッケージは `/etc/apt/sources.list.d/claude-desktop.list` にコメントアウトされたリポジトリエントリも書き込みます。その `deb` 行をコメント解除することと同等です。
 
 <h2 id="update">
```

</details>

<details>
<summary>errors-ja.md</summary>

```diff
diff --git a/docs-ja/pages/errors-ja.md b/docs-ja/pages/errors-ja.md
index 5c35a94..b56042e 100644
--- a/docs-ja/pages/errors-ja.md
+++ b/docs-ja/pages/errors-ja.md
@@ -32,5 +32,5 @@
 | `Auto mode classifier transcript exceeded context window`                                     | [サーバーエラー](#auto-mode-cannot-determine-the-safety-of-an-action)                                |
 | `Agent terminated early due to an API error`                                                  | [サーバーエラー](#agent-terminated-early-due-to-an-api-error)                                        |
-| `You've hit your session limit` / `You've hit your weekly limit`                              | [使用制限](#you%E2%80%99ve-hit-your-session-limit)                                                |
+| `You've hit your session limit` / `You've hit your weekly limit`                              | [使用制限](#youve-hit-your-session-limit)                                                         |
 | `Usage credits required for 1M context`                                                       | [使用制限](#usage-credits-required-for-1m-context)                                                |
 | `Server is temporarily limiting requests`                                                     | [使用制限](#server-is-temporarily-limiting-requests)                                              |
@@ -43,5 +43,5 @@
 | `Your organization has disabled API key authentication`                                       | [認証](#your-organization-has-disabled-api-key-authentication)                                  |
 | `Your organization has disabled Claude subscription access`                                   | [認証](#your-organization-has-disabled-claude-subscription-access)                              |
-| `Routines are disabled by your organization's policy`                                         | [認証](#routines-are-disabled-by-your-organization%E2%80%99s-policy)                            |
+| `Routines are disabled by your organization's policy`                                         | [認証](#routines-are-disabled-by-your-organizations-policy)                                     |
 | `Remote Control is only available when using Claude via api.anthropic.com`                    | [認証](#remote-control-requires-the-anthropic-api)                                              |
 | `OAuth token revoked` / `OAuth token has expired`                                             | [認証](#oauth-token-revoked-or-expired)                                                         |
@@ -54,5 +54,5 @@
 | `SSL certificate error (...)` during login or startup                                         | [ネットワーク](#ssl-certificate-errors)                                                             |
 | `403` with `x-deny-reason: host_not_allowed` in a cloud or routine session                    | [ネットワーク](#host-not-allowed-in-a-cloud-session)                                                |
-| `Couldn't reconnect to your Remote Control session`                                           | [ネットワーク](#couldn%E2%80%99t-reconnect-to-your-remote-control-session)                          |
+| `Couldn't reconnect to your Remote Control session`                                           | [ネットワーク](#couldnt-reconnect-to-your-remote-control-session)                                   |
 | `Prompt is too long`                                                                          | [リクエストエラー](#prompt-is-too-long)                                                               |
 | `Error during compaction: Conversation too long`                                              | [リクエストエラー](#error-during-compaction-conversation-too-long)                                    |
@@ -62,8 +62,8 @@
 | `PDF too large` / `PDF is password protected`                                                 | [リクエストエラー](#pdf-errors)                                                                       |
 | `Extra inputs are not permitted`                                                              | [リクエストエラー](#extra-inputs-are-not-permitted)                                                   |
-| `There's an issue with the selected model`                                                    | [リクエストエラー](#there%E2%80%99s-an-issue-with-the-selected-model)                                 |
+| `There's an issue with the selected model`                                                    | [リクエストエラー](#theres-an-issue-with-the-selected-model)                                          |
```

</details>

*...以降省略*

</details>


<details>
<summary>2026-07-11</summary>

**変更ファイル:**

```
 docs-ja/pages/admin-setup-ja.md                    |  22 +-
 docs-ja/pages/advisor-ja.md                        |   4 +-
 docs-ja/pages/agent-view-ja.md                     | 102 ++-
 docs-ja/pages/amazon-bedrock-ja.md                 |  66 +-
 docs-ja/pages/artifacts-ja.md                      |   2 +-
 docs-ja/pages/authentication-ja.md                 |  24 +-
 docs-ja/pages/auto-mode-config-ja.md               |   8 +-
 docs-ja/pages/channels-ja.md                       |   2 +-
 docs-ja/pages/channels-reference-ja.md             |   4 +-
 docs-ja/pages/chrome-ja.md                         |   2 +-
 docs-ja/pages/claude-apps-gateway-config-ja.md     |  30 +-
 docs-ja/pages/claude-apps-gateway-deploy-ja.md     |   2 +-
 docs-ja/pages/claude-apps-gateway-ja.md            |  50 +-
 .../pages/claude-apps-gateway-spend-limits-ja.md   |   4 +-
 docs-ja/pages/claude-code-on-the-web-ja.md         |  48 +-
 docs-ja/pages/claude-platform-on-aws-ja.md         |   2 +-
 docs-ja/pages/cli-reference-ja.md                  |  17 +-
 docs-ja/pages/code-review-ja.md                    |   2 +-
 docs-ja/pages/commands-ja.md                       | 210 +++---
 docs-ja/pages/common-workflows-ja.md               |   2 +-
 docs-ja/pages/communications-kit-ja.md             |   6 +-
 docs-ja/pages/computer-use-ja.md                   |   2 +-
 docs-ja/pages/costs-ja.md                          |   2 +-
 docs-ja/pages/data-usage-ja.md                     |  24 +-
 docs-ja/pages/debug-your-config-ja.md              |  34 +-
 docs-ja/pages/desktop-ja.md                        | 110 ++-
 docs-ja/pages/desktop-linux-ja.md                  |  28 +-
 docs-ja/pages/desktop-quickstart-ja.md             |  12 +-
 docs-ja/pages/devcontainer-ja.md                   |   4 +-
 docs-ja/pages/discover-plugins-ja.md               |  13 +-
 docs-ja/pages/errors-ja.md                         | 770 +++++++++++++--------
 docs-ja/pages/fast-mode-ja.md                      |   6 +-
 docs-ja/pages/feature-availability-ja.md           |  32 +-
 docs-ja/pages/fullscreen-ja.md                     |   4 +-
 docs-ja/pages/github-actions-ja.md                 |  82 +--
 docs-ja/pages/github-enterprise-server-ja.md       | 101 ++-
 docs-ja/pages/gitlab-ci-cd-ja.md                   |  60 +-
 docs-ja/pages/glossary-ja.md                       |   4 +-
 docs-ja/pages/google-vertex-ai-ja.md               |  76 +-
 docs-ja/pages/headless-ja.md                       |  12 +-
 docs-ja/pages/hooks-guide-ja.md                    |   2 +-
 docs-ja/pages/hooks-ja.md                          |  58 +-
 docs-ja/pages/how-claude-code-works-ja.md          |  10 +-
 docs-ja/pages/interactive-mode-ja.md               |  42 +-
 docs-ja/pages/keybindings-ja.md                    |  25 +-
 docs-ja/pages/legal-and-compliance-ja.md           |   2 +-
 docs-ja/pages/llm-gateway-connect-ja.md            |  14 +-
 docs-ja/pages/llm-gateway-ja.md                    |   2 +-
 docs-ja/pages/llm-gateway-protocol-ja.md           |  40 +-
 docs-ja/pages/llm-gateway-rollout-ja.md            |  22 +-
 docs-ja/pages/mcp-ja.md                            |  57 +-
 docs-ja/pages/mcp-quickstart-ja.md                 |   2 +-
 docs-ja/pages/microsoft-foundry-ja.md              |  18 +-
 docs-ja/pages/model-config-ja.md                   | 207 ++++--
 docs-ja/pages/monitoring-usage-ja.md               |  70 +-
 docs-ja/pages/network-config-ja.md                 |   4 +-
 docs-ja/pages/overview-ja.md                       |   6 +-
 docs-ja/pages/permission-modes-ja.md               |  65 +-
 docs-ja/pages/permissions-ja.md                    |  46 +-
 docs-ja/pages/platforms-ja.md                      |   2 +-
 docs-ja/pages/plugin-dependencies-ja.md            |   4 +-
 docs-ja/pages/plugin-marketplaces-ja.md            |   4 +-
 docs-ja/pages/plugins-ja.md                        |   2 +
 docs-ja/pages/plugins-reference-ja.md              |  16 +-
 docs-ja/pages/prompt-caching-ja.md                 |  10 +-
 docs-ja/pages/quickstart-ja.md                     |   2 +-
 docs-ja/pages/remote-control-ja.md                 |  27 +-
 docs-ja/pages/routines-ja.md                       |   2 +-
 docs-ja/pages/sandboxing-ja.md                     |   2 +-
 docs-ja/pages/scheduled-tasks-ja.md                |  10 +-
 docs-ja/pages/security-guidance-ja.md              |   2 +-
 docs-ja/pages/server-managed-settings-ja.md        |   4 +-
 docs-ja/pages/settings-ja.md                       | 345 ++++-----
 docs-ja/pages/setup-ja.md                          |  12 +-
 docs-ja/pages/skills-ja.md                         |  18 +-
 docs-ja/pages/statusline-ja.md                     |   4 +-
 docs-ja/pages/sub-agents-ja.md                     |  48 +-
 docs-ja/pages/third-party-integrations-ja.md       |  28 +-
 docs-ja/pages/tools-reference-ja.md                |  92 +--
 docs-ja/pages/troubleshoot-install-ja.md           |  79 ++-
 docs-ja/pages/troubleshooting-ja.md                |  29 +-
 docs-ja/pages/ultraplan-ja.md                      |   2 +-
 docs-ja/pages/ultrareview-ja.md                    |   8 +-
 docs-ja/pages/voice-dictation-ja.md                |   5 +-
 docs-ja/pages/vs-code-ja.md                        |  46 +-
 docs-ja/pages/web-quickstart-ja.md                 |  30 +-
 docs-ja/pages/workflows-ja.md                      |  46 +-
 docs-ja/pages/worktrees-ja.md                      |  16 +-
 docs-ja/pages/zero-data-retention-ja.md            |   2 +-
 89 files changed, 2110 insertions(+), 1464 deletions(-)
```

<details>
<summary>admin-setup-ja.md</summary>

```diff
diff --git a/docs-ja/pages/admin-setup-ja.md b/docs-ja/pages/admin-setup-ja.md
index 45b4031..654e47d 100644
--- a/docs-ja/pages/admin-setup-ja.md
+++ b/docs-ja/pages/admin-setup-ja.md
@@ -15,11 +15,11 @@ Claude Code は、ローカル開発者設定よりも優先されるマネー
 </Note>
 
-| 決定                                                        | 選択内容                      | 参照                                                                                                                                    |
-| :-------------------------------------------------------- | :------------------------ | :------------------------------------------------------------------------------------------------------------------------------------ |
-| [API プロバイダーを選択する](#choose-your-api-provider)              | Claude Code が認証される場所と課金方法 | [Authentication](/ja/authentication)、[Bedrock](/ja/amazon-bedrock)、[Vertex AI](/ja/google-vertex-ai)、[Foundry](/ja/microsoft-foundry) |
-| [設定がデバイスに到達する方法を決定する](#decide-how-settings-reach-devices) | マネージドポリシーが開発者マシンに到達する方法   | [Server-managed settings](/ja/server-managed-settings)、[Settings files](/ja/settings#settings-files)                                  |
-| [実行する内容を決定する](#decide-what-to-enforce)                    | どのツール、コマンド、統合が許可されるか      | [Permissions](/ja/permissions)、[Sandboxing](/ja/sandboxing)                                                                           |
-| [使用状況の可視性をセットアップする](#set-up-usage-visibility)             | 支出と採用を追跡する方法              | [Analytics](/ja/analytics)、[Monitoring](/ja/monitoring-usage)、[Costs](/ja/costs)                                                      |
-| [データ処理を確認する](#review-data-handling)                       | データ保持とコンプライアンス体制          | [Data usage](/ja/data-usage)、[Security](/ja/security)                                                                                 |
+| 決定                                                        | 選択内容                      | 参照                                                                                                                                                                         |
+| :-------------------------------------------------------- | :------------------------ | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
+| [API プロバイダーを選択する](#choose-your-api-provider)              | Claude Code が認証される場所と課金方法 | [Authentication](/ja/authentication)、[Amazon Bedrock](/ja/amazon-bedrock)、[Google Cloud の Agent Platform](/ja/google-vertex-ai)、[Microsoft Foundry](/ja/microsoft-foundry) |
+| [設定がデバイスに到達する方法を決定する](#decide-how-settings-reach-devices) | マネージドポリシーが開発者マシンに到達する方法   | [Server-managed settings](/ja/server-managed-settings)、[Settings files](/ja/settings#settings-files)                                                                       |
+| [実行する内容を決定する](#decide-what-to-enforce)                    | どのツール、コマンド、統合が許可されるか      | [Permissions](/ja/permissions)、[Sandboxing](/ja/sandboxing)                                                                                                                |
+| [使用状況の可視性をセットアップする](#set-up-usage-visibility)             | 支出と採用を追跡する方法              | [Analytics](/ja/analytics)、[Monitoring](/ja/monitoring-usage)、[Costs](/ja/costs)                                                                                           |
+| [データ処理を確認する](#review-data-handling)                       | データ保持とコンプライアンス体制          | [Data usage](/ja/data-usage)、[Security](/ja/security)                                                                                                                      |
 
 <h2 id="choose-your-api-provider">
@@ -34,8 +34,8 @@ Claude Code は複数の API プロバイダーのいずれかを通じて Claud
 | Claude Console                | API ファーストまたは従量課金を希望する場合                                                                    |
 | Amazon Bedrock                | 既存の AWS コンプライアンス制御と課金を継承したい場合                                                              |
-| Google Vertex AI              | 既存の GCP コンプライアンス制御と課金を継承したい場合                                                              |
+| Google Cloud の Agent Platform | 既存の GCP コンプライアンス制御と課金を継承したい場合                                                              |
 | Microsoft Foundry             | 既存の Azure コンプライアンス制御と課金を継承したい場合                                                            |
 
```

</details>

<details>
<summary>advisor-ja.md</summary>

```diff
diff --git a/docs-ja/pages/advisor-ja.md b/docs-ja/pages/advisor-ja.md
index 7162342..3d40e5f 100644
--- a/docs-ja/pages/advisor-ja.md
+++ b/docs-ja/pages/advisor-ja.md
@@ -10,5 +10,5 @@
 
 <Note>
-  advisor ツールは実験的機能であり、Anthropic API を使用する Claude Code v2.1.98 以降が必要です。Amazon Bedrock、Google Vertex AI、Microsoft Foundry では利用できません。動作、価格設定、および利用可能性は変更される可能性があります。
+  advisor ツールは実験的機能であり、Anthropic API を使用する Claude Code v2.1.98 以降が必要です。Amazon Bedrock、Google Cloud の Agent Platform、Microsoft Foundry では利用できません。動作、価格設定、および利用可能性は変更される可能性があります。
 </Note>
 
@@ -163,5 +163,5 @@ advisor ツールには、以下のすべてが必要です。
 
 * **Claude Code v2.1.98 以降**：`claude update` を実行してアップグレードします。
-* **Anthropic API のみ**：advisor はサーバー実行ツールです。Amazon Bedrock、Google Vertex AI、または Microsoft Foundry では利用できません。[LLM ゲートウェイ](/ja/llm-gateway)を通じて `ANTHROPIC_BASE_URL` で構成されている場合、利用可能性はゲートウェイがリクエストを Anthropic API に完全に転送するかどうかに依存します。
+* **Anthropic API のみ**：advisor はサーバー実行ツールです。Amazon Bedrock、Google Cloud の Agent Platform、または Microsoft Foundry では利用できません。[LLM ゲートウェイ](/ja/llm-gateway)を通じて `ANTHROPIC_BASE_URL` で構成されている場合、利用可能性はゲートウェイがリクエストを Anthropic API に完全に転送するかどうかに依存します。
 * **サポートされているメインモデル**：Opus 4.6 以降、Sonnet 4.6 以降、または Haiku 4.5。{/* min-version: 2.1.170 */}Fable 5 も Claude Code v2.1.170 以降で適格です。
 
```

</details>

<details>
<summary>agent-view-ja.md</summary>

```diff
diff --git a/docs-ja/pages/agent-view-ja.md b/docs-ja/pages/agent-view-ja.md
index 7fe5e50..319446e 100644
--- a/docs-ja/pages/agent-view-ja.md
+++ b/docs-ja/pages/agent-view-ja.md
@@ -91,5 +91,5 @@ claude agents --cwd ~/projects/my-app
 ```text theme={null}
 Pinned
-  ✽ clawd walk cycle          Write assets/sprites/clawd-walk.png           3m
+  ✽ clawd walk cycle          Drawing the walk-cycle sprite frames          3m
 
 Ready for review
@@ -97,8 +97,8 @@ Ready for review
 
 Needs input
-  ✻ power-up design           needs input: double jump or wall climb?       1m
+  ✻ power-up design           double jump or wall climb?                    1m
 
 Working
-  ✽ collision detection       Edit src/physics/CollisionSystem.ts           2m
+  ✽ collision detection       Adding swept-AABB checks to CollisionSystem   2m
   ✢ playtest level 3          run 12 · all checkpoints cleared           in 4m
 
@@ -142,13 +142,19 @@ v2.1.198 以降、エージェントビューが開いている間、Claude Code
 セッション状態はディスク上に永続化され、自動更新とスーパーバイザー再起動を通じて保存されます。セッションはマシンがスリープするときも保存されます。プロセスはウェイク時に再開され、スーパーバイザーはアイドルとして時間ギャップを扱う代わりにそれらに再接続します。シャットダウンはまだ実行中のセッションを停止します。[シャットダウン後にセッションが失敗として表示される](#sessions-show-as-failed-after-shutdown) を参照して、それらを復旧する方法を確認してください。
 
+応答しなくなったセッションを開くと、スーパーバイザーはそのプロセスを再起動し、セッションは中断した応答を中断したところから続行します。マシンがスリープしている間に応答の途中でセッションがその状態になる可能性があります。Claude Code v2.1.200 以降が必要です。
+
 <h3 id="row-summaries">
   行の概要
 </h3>
```

</details>

<details>
<summary>amazon-bedrock-ja.md</summary>

```diff
diff --git a/docs-ja/pages/amazon-bedrock-ja.md b/docs-ja/pages/amazon-bedrock-ja.md
index db66d71..1b124cd 100644
--- a/docs-ja/pages/amazon-bedrock-ja.md
+++ b/docs-ja/pages/amazon-bedrock-ja.md
@@ -83,12 +83,12 @@ export const ContactSalesCard = ({surface}) => {
 </h2>
 
-Claude Code を Bedrock で設定する前に、以下を確認してください。
+Claude Code を Amazon Bedrock で設定する前に、以下を確認してください。
 
-* Bedrock アクセスが有効になっている AWS アカウント
-* Bedrock で目的の Claude モデル（例：Claude Sonnet 4.6）へのアクセス
+* Amazon Bedrock アクセスが有効になっている AWS アカウント
+* Amazon Bedrock で目的の Claude モデル（例：Claude Sonnet 4.6）へのアクセス
 * AWS CLI がインストールされ、設定されていること（オプション - 認証情報を取得する別のメカニズムがない場合のみ必要）
 * 適切な IAM 権限
 
-Bedrock 認証情報を使用してサインインするには、以下の [Bedrock でサインイン](#sign-in-with-bedrock)に従ってください。チーム全体に Claude Code をデプロイするには、[手動でセットアップ](#set-up-manually)の手順を使用し、ロールアウト前に[モデルバージョンをピン留め](#4-pin-model-versions)してください。
+Amazon Bedrock 認証情報を使用してサインインするには、以下の [Amazon Bedrock でサインイン](#sign-in-with-bedrock)に従ってください。チーム全体に Claude Code をデプロイするには、[手動でセットアップ](#set-up-manually)の手順を使用し、ロールアウト前に[モデルバージョンをピン留め](#4-pin-model-versions)してください。
 
 <h2 id="sign-in-with-bedrock">
@@ -96,5 +96,5 @@ Bedrock 認証情報を使用してサインインするには、以下の [Bedr
 </h2>
 
-AWS 認証情報を持っていて、Bedrock を通じて Claude Code の使用を開始したい場合、ログインウィザードがそれをガイドします。AWS 側の前提条件はアカウントごとに 1 回完了します。ウィザードは Claude Code 側を処理します。
+AWS 認証情報を持っていて、Amazon Bedrock を通じて Claude Code の使用を開始したい場合、ログインウィザードがそれをガイドします。AWS 側の前提条件はアカウントごとに 1 回完了します。ウィザードは Claude Code 側を処理します。
 
 <Steps>
@@ -103,10 +103,10 @@ AWS 認証情報を持っていて、Bedrock を通じて Claude Code の使用
   </Step>
```

</details>

<details>
<summary>artifacts-ja.md</summary>

```diff
diff --git a/docs-ja/pages/artifacts-ja.md b/docs-ja/pages/artifacts-ja.md
index f018128..62ba0ca 100644
--- a/docs-ja/pages/artifacts-ja.md
+++ b/docs-ja/pages/artifacts-ja.md
@@ -193,5 +193,5 @@ Claude はデザインシステムを独自の選択よりも高い優先度と
 | プラン       | Pro、Max、Team、または Enterprise。Pro および Max プランでは、アーティファクトはプライベートであり、管理者管理は適用されません。Team プランでは、アーティファクトはデフォルトで有効です。Enterprise プランでは、Owner が claude.ai 管理設定で[有効にします](#manage-artifacts-for-your-organization)。               |
 | 認証        | `/login` で claude.ai にサインインしています。API キー、[ゲートウェイトークン](/ja/llm-gateway)、またはクラウドプロバイダー認証情報を使用するセッションは公開できません。                                                                                                             |
-| モデルプロバイダー | Anthropic API。[Amazon Bedrock](/ja/amazon-bedrock)、[Google Cloud Vertex AI](/ja/google-vertex-ai)、または [Microsoft Foundry](/ja/microsoft-foundry) では利用できません。                                                            |
+| モデルプロバイダー | Anthropic API。[Amazon Bedrock](/ja/amazon-bedrock)、[Google Cloud の Agent Platform](/ja/google-vertex-ai)、または [Microsoft Foundry](/ja/microsoft-foundry) では利用できません。                                                     |
 | 組織ポリシー    | カスタマー管理暗号化キー（CMEK）、HIPAA、および [Zero Data Retention](/ja/zero-data-retention) は組織で有効になっていません。                                                                                                                            |
 | サーフェス     | Claude Code CLI、または Claude デスクトップアプリバージョン 1.13576.0 以降。[Agent SDK](/ja/agent-sdk/overview)、GitHub Action、MCP サーバーコンテキストではデフォルトでオフになっており、[`CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC`](/ja/env-vars) が設定されている場合もオフになります。 |
```

</details>

<details>
<summary>authentication-ja.md</summary>

```diff
diff --git a/docs-ja/pages/authentication-ja.md b/docs-ja/pages/authentication-ja.md
index 3306636..fd09223 100644
--- a/docs-ja/pages/authentication-ja.md
+++ b/docs-ja/pages/authentication-ja.md
@@ -7,5 +7,5 @@
 > Claude Code にログインし、個人、チーム、組織向けの認証を設定します。
 
-Claude Code は、セットアップに応じて複数の認証方法をサポートしています。個人ユーザーは Claude.ai アカウントでログインでき、チームは Claude for Teams または Enterprise、Claude Console、または Amazon Bedrock、Google Vertex AI、Microsoft Foundry などのクラウドプロバイダーを使用できます。
+Claude Code は、セットアップに応じて複数の認証方法をサポートしています。個人ユーザーは Claude.ai アカウントでログインでき、チームは Claude for Teams または Enterprise、Claude Console、または Amazon Bedrock、Google Cloud の Agent Platform、Microsoft Foundry などのクラウドプロバイダーを使用できます。
 
 <h2 id="log-in-to-claude-code">
@@ -24,5 +24,5 @@ Claude Code は、セットアップに応じて複数の認証方法をサポ
 * **Claude for Teams または Enterprise**: チーム管理者が招待した Claude.ai アカウントでログインします。
 * **Claude Console**: Console 認証情報でログインします。管理者が事前に[招待](#claude-console-authentication)している必要があります。
-* **クラウドプロバイダー**: 組織が [Amazon Bedrock](/ja/amazon-bedrock)、[Google Vertex AI](/ja/google-vertex-ai)、または [Microsoft Foundry](/ja/microsoft-foundry) を使用している場合は、`claude` を実行する前に必要な環境変数を設定してください。ブラウザログインは不要です。
+* **クラウドプロバイダー**: 組織が [Amazon Bedrock](/ja/amazon-bedrock)、[Google Cloud の Agent Platform](/ja/google-vertex-ai)、または [Microsoft Foundry](/ja/microsoft-foundry) を使用している場合は、`claude` を実行する前に必要な環境変数を設定してください。ブラウザログインは不要です。
 * **クラウドゲートウェイ**: 組織がセルフホストされた [Claude apps gateway](/ja/claude-apps-gateway) を実行している場合は、`/login` を通じて企業 SSO でサインインします。ゲートウェイが発行したトークンはセッションの唯一の認証情報です。
 
@@ -41,5 +41,5 @@ Claude Code は、セットアップに応じて複数の認証方法をサポ
 * [Claude apps gateway](/ja/claude-apps-gateway)（開発者を IdP でサインインさせ、設定したクラウドプロバイダーに推論をルーティングする自己ホスト型ゲートウェイ）
 * [Amazon Bedrock](/ja/amazon-bedrock)
-* [Google Vertex AI](/ja/google-vertex-ai)
+* [Google Cloud の Agent Platform](/ja/google-vertex-ai)
 * [Microsoft Foundry](/ja/microsoft-foundry)
 
@@ -106,9 +106,9 @@ API ベースの請求を希望する組織の場合、Claude Console を通じ
 </h3>
 
-Amazon Bedrock、Google Vertex AI、または Microsoft Foundry を使用するチームの場合。
+Amazon Bedrock、Google Cloud の Agent Platform、または Microsoft Foundry を使用するチームの場合。
```

</details>

<details>
<summary>auto-mode-config-ja.md</summary>

```diff
diff --git a/docs-ja/pages/auto-mode-config-ja.md b/docs-ja/pages/auto-mode-config-ja.md
index eedc4be..095011f 100644
--- a/docs-ja/pages/auto-mode-config-ja.md
+++ b/docs-ja/pages/auto-mode-config-ja.md
@@ -10,5 +10,5 @@
 
 <Note>
-  オートモードは、Anthropic API を通じてすべてのユーザーが利用できます。Amazon Bedrock、Google Cloud Vertex AI、Microsoft Foundry、およびサインイン済みの[Claude アプリゲートウェイ](/ja/claude-apps-gateway)セッションでは、まず [`CLAUDE_CODE_ENABLE_AUTO_MODE`](/ja/permission-modes#enable-auto-mode-on-bedrock-vertex-ai-or-foundry) を[設定](/ja/permission-modes#enable-auto-mode-on-bedrock-vertex-ai-or-foundry)する必要があります。Claude Code がアカウントでオートモードが利用不可と報告する場合は、[完全な要件](/ja/permission-modes#eliminate-prompts-with-auto-mode)を確認してください。これには、サポートされているモデルと Team および Enterprise プランの Owner 有効化も含まれます。
+  オートモードは、Anthropic API を通じてすべてのユーザーが利用できます。Amazon Bedrock、Google Cloud の Agent Platform、Microsoft Foundry、およびサインイン済みの[Claude アプリゲートウェイ](/ja/claude-apps-gateway)セッションでは、まず [`CLAUDE_CODE_ENABLE_AUTO_MODE`](/ja/permission-modes#enable-auto-mode-on-bedrock-agent-platform-or-foundry) を[設定](/ja/permission-modes#enable-auto-mode-on-bedrock-agent-platform-or-foundry)する必要があります。Claude Code がアカウントでオートモードが利用不可と報告する場合は、[完全な要件](/ja/permission-modes#eliminate-prompts-with-auto-mode)を確認してください。これには、サポートされているモデルと Team および Enterprise プランの Owner 有効化も含まれます。
 </Note>
 
@@ -61,5 +61,5 @@ Claude Code v2.1.198 以降、`claude auto-mode defaults` は 3 種類の環境
   * **Primary use of Claude Code**：デフォルトはソフトウェア開発
   * **Cloud provider(s)**
-  * **Repository visibility**：リポジトリはリモートホストと名前が別途示さない限り、プライベートと見なされます
+  * **Repository visibility**：リポジトリはリモートホストと名前が別途示さない限り、プライベートと見なされます。{/* min-version: 2.1.200 */}または、会話内で分類器が読み込む前のトランスクリプト内の可視性チェックがそれが公開されていることを示している場合。分類器はメッセージと Claude が実行するコマンドを読み込みますが、その出力は読み込みません。そのため、証拠はリポジトリを公開として指定するあなた自身のメッセージなど、読み込める何かである必要があります。`gh repo view` の出力だけではそこに到達しません。トランスクリプト証拠チェックには Claude Code v2.1.200 以降が必要です
   * **Internal sharing / snippet hosting**：パブリックペーストおよび gist サービスは、指定するまで信頼境界の外側として扱われます
   * **Org-specific CLIs**
@@ -70,5 +70,5 @@ Claude Code v2.1.198 以降、`claude auto-mode defaults` は 3 種類の環境
   * **Protected deployment namespaces / environments**：指定するまで、機密リモートターゲットヒューリスティックにフォールバックします
   * **Data retention / declassification**
-* **信頼スロット**：分類器が境界内として扱うものを指定します。スロットは「信頼できるリポジトリ」、「ソース管理」、「信頼できる内部ドメイン」、「信頼できるクラウドバケット」、「主要な内部サービス」、および「内部パッケージレジストリ」です。リポジトリとソース管理エントリはデフォルトで作業リポジトリとその設定されたリモートになります。他のすべての信頼スロットはデフォルトで `None configured` になるため、追加するまで他には何も信頼されません。
+* **信頼スロット**：分類器が境界内として扱うものを指定します。スロットは「信頼できるリポジトリ」、「ソース管理」、「信頼できる内部ドメイン」、「信頼できるクラウドバケット」、「主要な内部サービス」、および「内部パッケージレジストリ」です。リポジトリとソース管理エントリはデフォルトで作業リポジトリとその設定されたリモートになります。他のすべての信頼スロットはデフォルトで `None configured` になるため、追加するまで他には何も信頼されません。{/* min-version: 2.1.203 */}リポジトリの可視性は機密情報のみをスコープします。プライベートリポジトリは機密情報の許容可能な宛先ですが、リポジトリをプライベートにしても、秘密、個人データ、または信頼されたデータをそこにクリアすることはなく、分類器は、作業リポジトリの外から移植、再ポイント、または最初に読み込まれたコンテンツを、そのリポジトリ自体の作業として扱いません。このスコープには Claude Code v2.1.203 以降が必要です。
 * **感度スロット**：保護ルールが高リスクとして扱うものを指定します。スロットは「機密データの場所とオーディエンス」、「機密リモートターゲット」、および「保護された IaC スコープ」です。各スロットはデフォルトで広いヒューリスティックになります。例えば、名前に `prod` または `production` を含むホストまたはネームスペースを機密リモートターゲットとして扱うため、保護ルールは何も設定する前にアクティブになります。感度スロットで具体的なターゲットを指定すると、これらのルールはヒューリスティックではなく指定されたターゲットに適用されます。
 
@@ -99,5 +99,5 @@ Claude Code v2.1.198 以降、`claude auto-mode defaults` は 3 種類の環境
 * **主要な内部サービス**：CI、アーティファクトレジストリ、内部パッケージインデックス、インシデント対応ツール
 * **内部パッケージレジストリ**：インストールがルーティングされるべき private npm、PyPI、またはその他のレジストリ。パブリックレジストリをバイパスするインストールはブロックされます
-* **Sensitive data locations & audiences**：個人データ、機密ビジネスデータ、認証情報、規制対象データ、または同様に機密性の高い情報を保持するバケット、データベース、またはパス。各場所のデータが共有される可能性があるオーディエンス。分類器がコンテンツから推測する代わりにこれらの場所を保護します。{/* min-version: 2.1.195 */}{/* max-version: 2.1.197 */}Claude Code v2.1.195 から v2.1.197 はこのエントリを PII / 規制対象データの場所として指定し、オーディエンスディメンションなしで個人データまたは規制対象データを保持する場所のみをカバーします
+* **機密データの場所とオーディエンス**：個人データ、機密ビジネスデータ、認証情報、規制対象データ、または同様に機密性の高い情報を保持するバケット、データベース、またはパス。各場所のデータが共有される可能性があるオーディエンス。分類器がコンテンツから推測する代わりにこれらの場所を保護します。{/* min-version: 2.1.195 */}{/* max-version: 2.1.197 */}Claude Code v2.1.195 から v2.1.197 はこのエントリを PII / 規制対象データの場所として指定し、オーディエンスディメンションなしで個人データまたは規制対象データを保持する場所のみをカバーします
```

</details>

*...以降省略*

</details>


<details>
<summary>2026-07-10</summary>

**変更ファイル:**

```
 docs-ja/pages/changelog.md | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)
```

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index 9049203..a1320bd 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,34 @@
 # Changelog
 
+## 2.1.206
+
+- Added directory path suggestions to `/cd`, matching `/add-dir` behavior
+- Added a `/doctor` check that proposes trimming checked-in `CLAUDE.md` files by cutting content Claude could derive from the codebase
+- `/commit-push-pr` now auto-allows `git push` to the repo's configured push remote (`remote.pushDefault`, or the sole remote when only one is configured) in addition to `origin`
+- Gateway: `/login` now supports Anthropic-operated public gateway endpoints
+- `EnterWorktree` now asks for confirmation before entering a git worktree outside the project's `.claude/worktrees/` directory
+- Background agents now upgrade to a new version in the background right after a Claude Code update, instead of paying a slow stale-session upgrade when you attach
+- Fixed an expired login failing every model with a misleading "There's an issue with the selected model" error instead of prompting to run `/login`
+- Fixed `claude --resume` and `--continue` not responding to keyboard input on startup
+- Fixed MCP servers configured via `--mcp-config` or `.mcp.json` ignoring a per-server `request_timeout_ms`, which caused long-running MCP tool calls to time out at the 60s default in fresh sessions
+- Fixed `CLAUDE_CODE_EXTRA_BODY` being silently ignored by `claude agents` / `--bg` background workers; the shell-exported override now follows the dispatching session
+- Fixed OAuth MCP servers requiring manual re-authentication after a single failed token refresh
+- Fixed `--permission-prompt-tool` pointing at an MCP server crashing with "MCP tool not found" on cold start before the server finishes connecting
+- Fixed `/model` picker rows printing a price for a different model than the row named, and stopped quoting first-party list prices on providers that don't bill them
+- Fixed server-provided model rows being misplaced in the `/model` picker when an entitlement or allowlist restriction drops the row they were positioned against
+- Fixed desktop sessions getting stuck showing "running" after a slash command was sent mid-turn
+- Fixed keyboard input being ignored in the agents view when a setup prompt appeared before a bare `claude --resume` on Windows
+- Fixed `claude rm` leaving the removed job in the daemon roster, causing the row to reappear in `claude agents`
+- Fixed `/remote-control` showing "Unknown command" when logged out — it now explains how to sign in
+- Fixed left arrow not stepping back out of a phase or agent in the workflow detail view
+- Fixed `/status` listing the same broken-install warning twice
+- Fixed false "disused plugin" tips and skewed disuse telemetry for LSP plugins
```

</details>

</details>


<details>
<summary>2026-07-09</summary>

**変更ファイル:**

```
 docs-ja/pages/changelog.md | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)
```

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index 3281a9a..9049203 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,34 @@
 # Changelog
 
+## 2.1.205
+
+- Added an auto mode rule that blocks tampering with session transcript files
+- Fixed `--json-schema` silently producing unstructured output when the schema was invalid, and schemas using the `format` keyword being rejected
+- Fixed a message sent while Claude was working being silently lost when the turn ended at the `--max-turns` limit
+- Fixed Windows worktree removal deleting files outside the worktree when an NTFS junction or directory symlink existed inside it
+- Fixed background agents staying shown as "failed" or "completed" in the agent list after being resumed with `SendMessage`
+- Fixed background jobs flipping from "needs input" back to "working" in the agent list when the agent's turn contained no readable text
+- Fixed `claude attach` erroring when a background agent was mid-upgrade restart instead of waiting for it to come back
+- Fixed session-to-PR linking missing a PR created in a Bash call whose output exceeded the 30K inline limit
+- Fixed `claude mcp add-from-claude-desktop` getting stuck when a server name contains unsupported characters; invalid names are now reported and remaining servers still import
+- Fixed a plugin LSP server that fails to initialize preventing a valid LSP server from another plugin handling the same file extension
+- Fixed a Windows crash when the directory Claude was launched from is deleted, locked, or unmounted while a command is running
+- Fixed a crash when a file watcher was closed while a directory scan was still in flight
+- Fixed project verify skills being rewritten on every session instead of only when a documented command changed
+- Fixed the agent view rendering one line too high and clipping its header when the job list slightly overflowed the screen
+- Fixed background tasks in the web and mobile Remote Control panels showing stale "Running" status by forwarding full task state on every membership change
+- Improved auto mode to ask before running `rm -rf` on a variable it can't resolve from context
+- Auto-update binary downloads now stream to disk instead of buffering in memory, cutting the updater's peak memory usage by roughly 400 MB
+- Background task notifications now explicitly state that no human input has occurred, preventing fabricated in-transcript approvals from being acted on
+- Improved agent view: sessions that edit, merge, comment on, or push to an existing PR now link it in `claude agents`
+- Improved agent view: rows now show a colored state word and a classifier-written headline instead of raw tool call text, and the peek opens with full status including the exact ask for blocked sessions
+- `/doctor` is now a full setup checkup that can diagnose and fix issues; `/checkup` is its alias
```

</details>

</details>


<details>
<summary>2026-07-08</summary>

**変更ファイル:**

```
 docs-ja/pages/changelog.md | 40 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)
```

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index 6d222e9..3281a9a 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,44 @@
 # Changelog
 
+## 2.1.203
+
+- Added a warning when your login is about to expire, so you can re-authenticate before background sessions are interrupted
+- Added a grey ⏸ badge to the footer when in manual permission mode, making the active mode always visible
+- Added the session's additional working directories to MCP `roots/list`, with `notifications/roots/list_changed` sent when the set changes
+- Fixed opening or switching background agent sessions on macOS stalling for 15–20 seconds due to a false low-memory detection (regression in 2.1.196)
+- Fixed background sessions becoming permanently unresponsive to attach, replies, and stop when the daemon's session token went stale — the session now recovers automatically
+- Fixed returning to `claude agents` silently stopping running subagents and re-running the prompt from scratch — their work now carries over
+- Fixed a memory and per-turn CPU regression in interactive sessions: the context-usage indicator no longer re-analyzes the entire transcript after every turn
+- Fixed background agents inheriting a stale `PATH` from the daemon instead of the dispatching shell, causing missing tools on Windows
+- Fixed background and agent-view sessions dropping a shell-exported `ANTHROPIC_BASE_URL`, which sent API keys to the default endpoint and failed with 401
+- Fixed Bash failing with "argument list too long" in repos with many git worktrees
+- Fixed worktree-isolated subagents sometimes running shell commands in the parent checkout instead of their own worktree
+- Fixed worktree creation rejecting nested repositories in multi-repo workspaces, leaving background sessions unable to isolate and edit
+- Fixed background agents crash-looping when their working directory was deleted, replaced by a file, or became an invalid path — they now fail once with a clear error
+- Fixed a background daemon auto-upgrade failure silently killing all running background sessions
+- Fixed `TaskStop` and `TaskOutput` failing to find background agents spawned by another agent — errors now list running agents by id and description
+- Fixed the `claude agents` composer discarding your typed message when a slash command isn't available there
+- Fixed the agent list crashing when opening a stopped session whose conversation was already open in another session
+- Fixed background sessions showing "Needs input" in the agent list after the question was already answered
+- Fixed background agent startup failures showing only "exit_with_message" instead of the actual error
+- Fixed background sessions ignoring `effortLevel` changes in settings.json when forked through the daemon
+- Fixed attached background sessions ignoring `CLAUDE_CODE_DISABLE_MOUSE` and `CLAUDE_CODE_DISABLE_MOUSE_CLICKS` opt-outs
```

</details>

</details>


<details>
<summary>2026-07-07</summary>

**変更ファイル:**

```
 docs-ja/pages/changelog.md | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)
```

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index 4bfce89..6d222e9 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,25 @@
 # Changelog
 
+## 2.1.202
+
+- Added a "Dynamic workflow size" setting in `/config` for controlling how large Claude generally makes dynamic workflows (small/medium/large agent counts) — an advisory guideline, not an enforced cap
+- Added `workflow.run_id` and `workflow.name` OpenTelemetry attributes to telemetry emitted by workflow-spawned agents, so a workflow run's activity can be reconstructed from OTel data
+- Fixed a crash in the inline Ctrl+R history search when accepting or cancelling while the search was still scanning the history file
+- Fixed `/rename` on background sessions being reverted when the job restarts, which broke addressing the session by its new name
+- Fixed transient mTLS handshake failures when settings were re-applied during an in-place client certificate rotation
+- Fixed commands sent from Remote Control (mobile/web) into an interactive session failing with "Unknown command"
+- Fixed images and files sent from the Remote Control mobile or web app without a caption being silently dropped
+- Fixed the sign-in URL printed by `claude auth login` and `claude mcp login --no-browser` not being reliably clickable when it wraps over SSH — it is now emitted as a single hyperlink
+- Fixed opening a chat from `claude agents` sometimes failing with "currently running as a background agent" followed by a worker crash/respawn loop
+- Fixed workflow scripts with unicode quote escapes in strings being corrupted before parsing; workflow parse errors now show the offending line instead of always blaming TypeScript
+- Fixed voice dictation retrying in an unbounded loop when the microphone or audio recorder fails — repeated capture failures now pause voice input
+- Fixed `/remote-control` sessions showing the wrong permission mode in the mobile and web apps
+- Fixed resuming a session by name, or opening the resume picker, taking minutes and using a large amount of memory in repositories with many git worktrees
+- Fixed installer and updater downloads failing immediately with "aborted" when a proxy or network drops the connection mid-download — transient connection drops now retry
+- Fixed re-invoking an already-loaded skill appending a duplicate copy of its instructions to context
+- Improved `/workflows` agent list layout: wider titles, a dedicated time column, shorter model names, and no per-row tool-call counts
+- Improved MCP error messages: clearer error when a server config has `url` but no `type`, suggesting `"type": "http"` instead of the misleading "command: expected string"
+- Changed `/review <pr>` back to a fast single-pass review; use `/code-review <level> <pr#>` for the multi-agent review at a chosen effort level
+
 ## 2.1.201
 
```

</details>

</details>


<details>
<summary>2026-07-04</summary>

**変更ファイル:**

```
 docs-ja/pages/admin-setup-ja.md                |   2 +
 docs-ja/pages/advisor-ja.md                    |  15 +-
 docs-ja/pages/agent-teams-ja.md                |  15 +-
 docs-ja/pages/agent-view-ja.md                 | 127 ++++++++++----
 docs-ja/pages/agents-ja.md                     |   2 +-
 docs-ja/pages/amazon-bedrock-ja.md             |   2 +-
 docs-ja/pages/auto-mode-config-ja.md           |  25 ++-
 docs-ja/pages/changelog.md                     |  24 +++
 docs-ja/pages/chrome-ja.md                     |  17 +-
 docs-ja/pages/claude-apps-gateway-config-ja.md |  66 +++++++-
 docs-ja/pages/claude-apps-gateway-ja.md        |  60 +++----
 docs-ja/pages/claude-code-on-the-web-ja.md     |  12 +-
 docs-ja/pages/claude-platform-on-aws-ja.md     |   2 +-
 docs-ja/pages/cli-reference-ja.md              |   6 +-
 docs-ja/pages/commands-ja.md                   |  17 +-
 docs-ja/pages/context-window-ja.md             |   2 +-
 docs-ja/pages/debug-your-config-ja.md          |   3 +-
 docs-ja/pages/desktop-ja.md                    |   2 +-
 docs-ja/pages/env-vars-ja.md                   |  10 +-
 docs-ja/pages/errors-ja.md                     | 222 ++++++++++++++++++++-----
 docs-ja/pages/fullscreen-ja.md                 |   4 +-
 docs-ja/pages/gateways-ja.md                   |   2 +-
 docs-ja/pages/hooks-guide-ja.md                |  66 ++++----
 docs-ja/pages/hooks-ja.md                      | 136 +++++++++------
 docs-ja/pages/how-claude-code-works-ja.md      |   1 -
 docs-ja/pages/llm-gateway-protocol-ja.md       |  10 +-
 docs-ja/pages/mcp-ja.md                        |  43 +++++
 docs-ja/pages/memory-ja.md                     |   4 +-
 docs-ja/pages/model-config-ja.md               |  60 ++++++-
 docs-ja/pages/monitoring-usage-ja.md           |   2 +-
 docs-ja/pages/permission-modes-ja.md           |  29 +++-
 docs-ja/pages/permissions-ja.md                |  25 ++-
 docs-ja/pages/plugin-relevance-en.md           | 170 -------------------
 docs-ja/pages/plugins-ja.md                    |   4 +-
 docs-ja/pages/plugins-reference-ja.md          |   2 +-
 docs-ja/pages/sandboxing-ja.md                 |  48 +++++-
 docs-ja/pages/server-managed-settings-ja.md    |  44 +++--
 docs-ja/pages/sessions-ja.md                   |   2 +
 docs-ja/pages/settings-ja.md                   |  59 +++----
 docs-ja/pages/setup-ja.md                      |   2 +-
 docs-ja/pages/skills-ja.md                     |   6 +
 docs-ja/pages/sub-agents-ja.md                 | 154 +++++++++--------
 docs-ja/pages/tools-reference-ja.md            |  26 +--
 docs-ja/pages/worktrees-ja.md                  |   2 +
 44 files changed, 973 insertions(+), 559 deletions(-)
```

**新規追加:**


**削除:**


<details>
<summary>admin-setup-ja.md</summary>

```diff
diff --git a/docs-ja/pages/admin-setup-ja.md b/docs-ja/pages/admin-setup-ja.md
index 2e42a33..45b4031 100644
--- a/docs-ja/pages/admin-setup-ja.md
+++ b/docs-ja/pages/admin-setup-ja.md
@@ -91,4 +91,6 @@ plist と HKLM レジストリの場所は任意のプロバイダーで機能
 | [Required version range](/ja/settings)                                                 | 実行中のバージョンが組織承認の範囲外の場合、まったく起動を拒否する。`minimumVersion` より強力で、ダウングレードのみをブロックする                                                                                                                             | `requiredMinimumVersion`、`requiredMaximumVersion`                                                      |
 
+claude.ai または Anthropic API を通じて認証するメンバーを持つ組織は、設定をデプロイせずにモデルを管理することもできます。[organization model restrictions](/ja/model-config#organization-model-restrictions) は個別のモデルを無効化し、[organization default model](/ja/model-config#organization-default-model) は新しいセッションが開始するモデルを設定し、[organization effort limits](/ja/model-config#organization-effort-limits) はロールごとのエフォートレベルを制限します。3 つのコントロールすべてに Claude Enterprise プランが必要です。モデル制限とエフォート制限はサーバー側で実行されます。デフォルトモデルは、組織がそれを実行しない限り、ユーザーが変更できる開始点です。実行は限定的な組織セットで利用可能です。可用性については、Anthropic アカウントチームにお問い合わせください。これらのコントロールのいずれも、Amazon Bedrock、Google Cloud の Agent Platform、Microsoft Foundry、または [Claude Platform on AWS](/ja/claude-platform-on-aws) 上のセッションには到達しません。これらのプロバイダーでは、制限に上記の `availableModels` を使用し、マネージド設定の `model` キーをデフォルトに使用してください。
+
 パーミッションルールとサンドボックスは異なるレイヤーをカバーします。WebFetch を拒否すると Claude の fetch ツールがブロックされますが、Bash が許可されている場合、`curl` と `wget` は依然として任意の URL に到達できます。サンドボックスは OS レベルで実行されるネットワークドメイン許可リストでそのギャップを閉じます。
 
```

</details>

<details>
<summary>advisor-ja.md</summary>

```diff
diff --git a/docs-ja/pages/advisor-ja.md b/docs-ja/pages/advisor-ja.md
index 9fde894..7162342 100644
--- a/docs-ja/pages/advisor-ja.md
+++ b/docs-ja/pages/advisor-ja.md
@@ -85,11 +85,12 @@ claude --advisor opus
 advisor はメインモデル以上の機能を持つ必要があります。各メインモデルで受け入れられる advisor は次のとおりです。
 
-| メインモデル                                          | 受け入れられる advisor            | 注記                                                                            |
-| ----------------------------------------------- | -------------------------- | ----------------------------------------------------------------------------- |
-| Haiku 4.5                                       | Fable、Opus、Sonnet          | Haiku は advisor を呼び出すことはできますが、advisor として機能することはできません                         |
-| Sonnet 4.6                                      | Fable、Opus、Sonnet          |                                                                               |
-| Sonnet 5                                        | Fable、Opus、Sonnet 5        | Sonnet 4.6 advisor は拒否されます                                                    |
-| Opus 4.6 以降                                     | Fable、メインモデルのバージョン以上の Opus | Opus 4.7 メインと Opus 4.6 advisor は拒否されます。Opus 4.6 メインは Sonnet 5 advisor も受け入れます |
-| Fable 5 ({/* min-version: 2.1.170 */}v2.1.170+) | Fable                      | Opus または Sonnet advisor は拒否されます                                               |
+| メインモデル                                          | 受け入れられる advisor         | 注記                                                                                                                    |
+| ----------------------------------------------- | ----------------------- | --------------------------------------------------------------------------------------------------------------------- |
+| Haiku 4.5                                       | Fable、Opus、Sonnet       | Haiku は advisor を呼び出すことはできますが、advisor として機能することはできません                                                                 |
+| Sonnet 4.6                                      | Fable、Opus、Sonnet       |                                                                                                                       |
+| Sonnet 5                                        | Fable、Opus、Sonnet 5     | Sonnet 4.6 advisor は拒否されます                                                                                            |
+| Opus 4.6                                        | Fable、Opus、Sonnet 5     | Sonnet 5 と Opus 4.6 は同等の機能として評価されるため、Opus 4.6 メインは Sonnet 5 advisor を受け入れます                                           |
+| Opus 4.7 以降                                     | Fable、Opus 4.7、Opus 4.8 | Opus 4.7 と Opus 4.8 は同等の機能として評価されるため、どちらでも他方を advisor として受け入れます。Opus 4.6 または Sonnet 5 advisor を持つ Opus 4.7 メインは拒否されます |
+| Fable 5 ({/* min-version: 2.1.170 */}v2.1.170+) | Fable                   | Opus または Sonnet advisor は拒否されます                                                                                       |
 
 Fable 5 は、メインモデルとして機能するか advisor として機能するかに関わらず、Claude Code v2.1.170 以降と Fable 5 アクセスが必要です。
```

</details>

<details>
<summary>agent-teams-ja.md</summary>

```diff
diff --git a/docs-ja/pages/agent-teams-ja.md b/docs-ja/pages/agent-teams-ja.md
index 984c277..97ea6f6 100644
--- a/docs-ja/pages/agent-teams-ja.md
+++ b/docs-ja/pages/agent-teams-ja.md
@@ -90,5 +90,7 @@ one on UX, one on technical architecture, one playing devil's advocate.
 * **Escape**: 選択したチームメンバーの現在のターンを中断する
 
-{/* min-version: 2.1.181 */}v2.1.181 以降、アイドル状態のチームメンバーの行は 30 秒後に非表示になり、次のターンで再表示されます。チームメンバーは非表示中も実行中で対応可能な状態が続きます。
+{/* min-version: 2.1.199 */}v2.1.199 以降、アイドル状態のチームメンバーの行は、他のチームメンバーまたはサブエージェントがまだ作業中の間、パネルに留まるため、トランスクリプトを確認したり、さらに作業を割り当てたりするために選択できます。パネル内のすべてのエージェントがアイドル状態になると、アイドル行は 30 秒後に非表示になり、チームメンバーの次のターンで再表示されます。チームメンバーは非表示中も実行中で対応可能な状態が続きます。v2.1.181 から v2.1.198 では、アイドル行は他のチームメンバーがまだ作業中であっても、独自のターンが終了してから 30 秒後に非表示になりました。v2.1.181 より前のバージョンではアイドル行は非表示になりません。
+
+3 人以上のチームメンバーが同時にアイドル状態の場合、最初の 3 行を超える行は、折りたたまれたチームメンバーをカウントする単一の行に折りたたまれます。例えば、5 人がアイドル状態の場合は `2 idle agents` のようになります。それを選択して Enter キーを押すと折りたたまれた行が展開され、Esc キーを押すと再び折りたたまれます。作業中のチームメンバー、失敗したチームメンバー、および表示中のチームメンバーは常に独自の行を保持します。
 
 各チームメンバーを独自の分割ペインに配置したい場合は、[表示モードを選択](#choose-a-display-mode)を参照してください。
@@ -175,4 +177,8 @@ Require plan approval before they make any changes.
 * **分割ペインモード**：チームメンバーのペインをクリックして、セッションと直接対話してください。各チームメンバーは独自のターミナルの完全なビューを持っています。
 
+In-process チームメンバーを表示している間、プレーンテキストと [skills](/ja/skills) はそのチームメンバーに送信されますが、組み込みコマンドはリーダーのセッションで実行されます。
+
+チームメンバーのモデルと高速モードはそれが生成されるときに固定されるため、`/model` と `/fast` はリーダーの設定のみを変更します。{/* min-version: 2.1.199 */}v2.1.199 以降、チームメンバーを表示している間にいずれかのコマンドを入力すると、変更がリーダーに適用されることを示す通知が表示されます。それより前のバージョンでは、指示なしでリーダーに適用されました。`/effort` はチームメンバーの後続のターンに適用されます。これはチームメンバーがリーダーの[努力レベル](/ja/model-config#adjust-effort-level)に従うためです。
+
 <h3 id="assign-and-claim-tasks">
   タスクを割り当てて要求する
@@ -296,5 +302,5 @@ Spawn a teammate using the security-reviewer agent type to audit the auth module
 
 * **自動メッセージ配信**：チームメンバーがメッセージを送信すると、受信者に自動的に配信されます。リーダーは更新をポーリングする必要はありません。
-* **アイドル通知**：チームメンバーが完了して停止すると、リーダーに自動的に通知します。
+* **アイドル通知**：チームメンバーが完了して停止すると、リーダーに自動的に通知します。{/* min-version: 2.1.198 */}v2.1.198 以降、ターンが API エラーで終了するチームメンバーは、通常に完了したように見えるのではなく、失敗したことをリーダーに通知し、エラーテキストを含めます。
 * **共有タスクリスト**：すべてのエージェントはタスクステータスを表示でき、利用可能な作業を要求できます。
 * **チームメンバーメッセージング**：その名前で特定のチームメンバーにメッセージを送信します。全員に到達するには、受信者ごとに 1 つのメッセージを送信してください。
@@ -431,5 +437,5 @@ Claude にチームメンバーを生成するよう指示した後、チーム
```

</details>

<details>
<summary>agent-view-ja.md</summary>

```diff
diff --git a/docs-ja/pages/agent-view-ja.md b/docs-ja/pages/agent-view-ja.md
index eaa1e35..7fe5e50 100644
--- a/docs-ja/pages/agent-view-ja.md
+++ b/docs-ja/pages/agent-view-ja.md
@@ -28,5 +28,5 @@ Claude が複数の独立したタスクに対して、あなたが毎ステッ
 * [エージェントビューでセッションを監視する](#monitor-sessions-with-agent-view)。状態アイコン、ピーク表示と返信、アタッチ、整理、キーボードショートカットを含みます
 * [新しいエージェントをディスパッチする](#dispatch-new-agents)。エージェントビューから、セッション内から、またはシェルから
-* [シェルからセッションを管理する](#manage-sessions-from-the-shell)
+* [シェルからセッションを管理する](#manage-sessions-from-the-shell)。`claude agents`、`claude attach`、および関連コマンドを使用して
 * [バックグラウンドセッションがどのようにホストされるか](#how-background-sessions-are-hosted)。スーパーバイザープロセスによって
 
@@ -77,4 +77,6 @@ Claude が複数の独立したタスクに対して、あなたが毎ステッ
 `claude agents` を実行してエージェントビューを開きます。ターミナル全体を占有し、状態でグループ化されたすべてのセッションをリストします。ピン留めされたセッションと入力が必要なセッションが上部に表示されます。各行はセッションの名前、現在のアクティビティ、最後に変更されてからの経過時間を表示します。
 
+名前は、そのセッションで [`/color`](/ja/commands) によって設定されたカラーで色付けされます。{/* min-version: 2.1.199 */}v2.1.199 以降、`←` または `/background` で [セッションをバックグラウンドにする](#from-inside-a-session) ときにカラーが引き継がれます。
+
 デフォルトでは、リストはすべてのプロジェクト全体で開始したすべてのバックグラウンドセッションを表示します。1 つのリポジトリで作業しているセッションと別のワークツリーで作業している別のセッションの両方がここに表示されます。エージェントビューを開いたディレクトリに関係なく表示されます。リストを 1 つのプロジェクトに絞り込むには、`--cwd` を渡します：
 
@@ -92,5 +94,5 @@ Pinned
 
 Ready for review
-  ∙ jump physics              Opened PR with collision fix              PR #2048  2h
+  ∙ jump physics              Opened PR with collision fix                 #2048  2h
 
 Needs input
@@ -111,5 +113,5 @@ Completed
 </h3>
 
-各行は、セッションの状態を示すアイコンで始まります。アイコンの色とアニメーションはセッションの状態を示します。
+各行は、セッションの状態を示すアイコンで始まります。アイコンの色とアニメーションはセッションの状態を示します：
```

</details>

<details>
<summary>agents-ja.md</summary>

```diff
diff --git a/docs-ja/pages/agents-ja.md b/docs-ja/pages/agents-ja.md
index cd96e4e..bc64ab4 100644
--- a/docs-ja/pages/agents-ja.md
+++ b/docs-ja/pages/agents-ja.md
@@ -54,5 +54,5 @@
 
 * バックグラウンドセッションの場合、`claude agents` は [エージェントビュー](/ja/agent-view) を開きます。すべてのセッション、その状態、および入力が必要なセッションを表示する 1 つの画面です。
-* 現在のセッション内のサブエージェントの場合、`/agents` はパネルを開き、ライブサブエージェントをリストする **Running** タブと、[カスタムサブエージェントを作成および編集](/ja/sub-agents#use-the-%2Fagents-command) できる **Library** タブがあります。名前は似ていますが、これは `claude agents` とは別です。
+* 現在のセッション内のサブエージェントの場合、名前付きバックグラウンドサブエージェントは @-メンション入力補完に状態とともに表示されます。{/* min-version: 2.1.198 */}v2.1.198 以降、`/agents` はパネルを開かなくなり、サブエージェントファイルの場所を指すお知らせを出力します。[カスタムサブエージェントを作成および編集](/ja/sub-agents#configure-subagents) するには、Claude に質問するか、ファイルを直接編集してください。名前は似ていますが、`/agents` は `claude agents` とは別です。
 * 現在のセッションのバックグラウンドで実行されているもの場合、`/tasks` は各項目をリストし、確認、アタッチ、または停止できます。
 * 動的ワークフローの場合、`/workflows` は実行中および完了した実行、各実行がある段階、および完了したエージェント数をリストします。
```

</details>

<details>
<summary>amazon-bedrock-ja.md</summary>

```diff
diff --git a/docs-ja/pages/amazon-bedrock-ja.md b/docs-ja/pages/amazon-bedrock-ja.md
index f7a17ca..db66d71 100644
--- a/docs-ja/pages/amazon-bedrock-ja.md
+++ b/docs-ja/pages/amazon-bedrock-ja.md
@@ -185,5 +185,5 @@ Claude Code は、AWS SSO および企業 ID プロバイダーの自動認証
 これら 2 つの設定には異なるトリガー条件があります。
 
-* **`awsAuthRefresh`**：Claude Code がローカルのタイムスタンプに基づくか、Bedrock が認証情報エラーを返した場合に AWS 認証情報の有効期限が切れていることを検出した場合にのみ実行され、更新された認証情報でリクエストを再試行します。
+* **`awsAuthRefresh`**：Claude Code がローカルのタイムスタンプに基づくか、API が認証情報エラーを返した場合に AWS 認証情報の有効期限が切れていることを検出した場合にのみ実行され、更新された認証情報でリクエストを再試行します。
 * **`awsCredentialExport`**：セッション開始時および各認証情報リロード時に実行されます。AWS デフォルト認証情報プロバイダーチェーン内の認証情報がまだ有効な場合でも実行されます。Bedrock アカウントがデフォルトプロバイダーチェーンが解決するものと異なるクロスアカウント認証情報を必要とする場合に使用します。
 
```

</details>

<details>
<summary>auto-mode-config-ja.md</summary>

```diff
diff --git a/docs-ja/pages/auto-mode-config-ja.md b/docs-ja/pages/auto-mode-config-ja.md
index ca66c7c..eedc4be 100644
--- a/docs-ja/pages/auto-mode-config-ja.md
+++ b/docs-ja/pages/auto-mode-config-ja.md
@@ -55,10 +55,21 @@
 ほとんどの組織では、`autoMode.environment` が設定する必要がある唯一のフィールドです。これは、分類器に、どのリポジトリ、バケット、ドメインが信頼できるかを指定します。分類器はこれを使用して「外部」が何を意味するかを決定するため、リストに記載されていない宛先は潜在的な流出ターゲットです。
 
-Claude Code v2.1.195 以降、`claude auto-mode defaults` は 2 種類の環境エントリを出力します。
-
+Claude Code v2.1.198 以降、`claude auto-mode defaults` は 3 種類の環境エントリを出力します。v2.1.195 より前のバージョンは、最初の 5 つの信頼スロットのみを出力します。
+
+* **コンテキストスロット**：分類器が他のルールをコンテキストで読み込むように、組織、スタック、セキュリティ体制を説明します。他の 2 種類と異なり、コンテキストスロットはそれらをターゲットにする独自のルールはありません。各スロットはデフォルトで `None configured` または次に記載されている保守的な仮定になります。
+  * **Organization**
+  * **Primary use of Claude Code**：デフォルトはソフトウェア開発
+  * **Cloud provider(s)**
+  * **Repository visibility**：リポジトリはリモートホストと名前が別途示さない限り、プライベートと見なされます
+  * **Internal sharing / snippet hosting**：パブリックペーストおよび gist サービスは、指定するまで信頼境界の外側として扱われます
+  * **Org-specific CLIs**
+  * **Secrets management**
+  * **Default / protected branches**：`main` と `master` は、他を指定するまで保護されたものとして扱われます
+  * **CI/CD deploy targets**
+  * **Network posture**
+  * **Protected deployment namespaces / environments**：指定するまで、機密リモートターゲットヒューリスティックにフォールバックします
+  * **Data retention / declassification**
 * **信頼スロット**：分類器が境界内として扱うものを指定します。スロットは「信頼できるリポジトリ」、「ソース管理」、「信頼できる内部ドメイン」、「信頼できるクラウドバケット」、「主要な内部サービス」、および「内部パッケージレジストリ」です。リポジトリとソース管理エントリはデフォルトで作業リポジトリとその設定されたリモートになります。他のすべての信頼スロットはデフォルトで `None configured` になるため、追加するまで他には何も信頼されません。
-* **感度スロット**：保護ルールが高リスクとして扱うものを指定します。スロットは「PII / 規制対象データの場所」、「機密リモートターゲット」、および「保護された IaC スコープ」です。各スロットはデフォルトで広いヒューリスティックになります。例えば、名前に `prod` または `production` を含むホストまたはネームスペースを機密リモートターゲットとして扱うため、保護ルールは何も設定する前にアクティブになります。感度スロットで具体的なターゲットを指定すると、これらのルールはヒューリスティックではなく指定されたターゲットに適用されます。
-
-v2.1.195 より前のバージョンは、最初の 5 つの信頼スロットのみを出力します。
+* **感度スロット**：保護ルールが高リスクとして扱うものを指定します。スロットは「機密データの場所とオーディエンス」、「機密リモートターゲット」、および「保護された IaC スコープ」です。各スロットはデフォルトで広いヒューリスティックになります。例えば、名前に `prod` または `production` を含むホストまたはネームスペースを機密リモートターゲットとして扱うため、保護ルールは何も設定する前にアクティブになります。感度スロットで具体的なターゲットを指定すると、これらのルールはヒューリスティックではなく指定されたターゲットに適用されます。
 
```

</details>

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index 05e2d78..4bfce89 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,28 @@
 # Changelog
 
+## 2.1.201
+
+- Claude Sonnet 5 sessions no longer use the mid-conversation system role for harness reminders
+
+## 2.1.200
+
+- Changed `AskUserQuestion` dialogs to no longer auto-continue by default; opt into an idle timeout via `/config`
+- Changed the "default" permission mode to "Manual" across the CLI, `--help`, VS Code, and JetBrains; `--permission-mode manual` and `"defaultMode": "manual"` are accepted alongside `default`
+- Fixed a crash at startup when `disabledMcpServers` or `enabledMcpServers` in `.claude.json` is set to a non-array value
+- Fixed background sessions silently stopping mid-turn after sleep/wake or when reopening a stalled session
+- Fixed background sessions re-running a turn cancelled with Esc after a stall respawn
+- Fixed background agents never starting again after a crash left a stale `daemon.lock` whose PID the OS reused
+- Fixed background-agent daemon handover so a reinstalled older build can no longer take over the daemon; build recency is now judged by the version's embedded build timestamp
+- Fixed background-agent roster issues: transient corruption permanently disabling orphan cleanup, older binaries not preserving fields written by newer versions, and socket auth tokens being stripped during daemon restarts
+- Fixed subagents cut off by a rate limit before producing any text output returning an empty result instead of failing cleanly
+- Fixed control bytes from background-agent output reaching the terminal in the agent view
+- Fixed `claude agents --plugin-dir <dir>` not showing the plugin's agents and skills in the agent view when the flag is placed after `agents`
+- Fixed project-scoped plugins not loading correctly from git worktrees of the same repository
+- Fixed `/mcp` server list not tracking focus for screen readers and magnifiers
+- Fixed voice dictation showing a misleading "Voice connection failed" message when a recording captures no audio
+- Fixed rendering flicker under tmux 3.4+ by enabling synchronized terminal output
+- Improved screen-reader output: decorative glyphs are now hidden, transcript symbols read as short labels, and nested tables read as `Header: value.` lines
+- Improved the install script to explain when installation is killed by the system running out of memory
```

</details>

*...以降省略*

</details>


<details>
<summary>2026-07-03</summary>

**変更ファイル:**

```
 docs-ja/pages/advisor-ja.md              |  2 +-
 docs-ja/pages/agent-view-ja.md           |  4 +-
 docs-ja/pages/artifacts-ja.md            | 12 ++--
 docs-ja/pages/changelog.md               | 28 ++++++++++
 docs-ja/pages/costs-ja.md                |  6 +-
 docs-ja/pages/desktop-linux-ja.md        |  2 +
 docs-ja/pages/env-vars-ja.md             |  2 +-
 docs-ja/pages/feature-availability-ja.md |  4 +-
 docs-ja/pages/interactive-mode-ja.md     |  6 +-
 docs-ja/pages/keybindings-ja.md          | 14 ++---
 docs-ja/pages/model-config-ja.md         |  6 +-
 docs-ja/pages/permission-modes-ja.md     |  2 +-
 docs-ja/pages/plugins-ja.md              |  6 +-
 docs-ja/pages/tools-reference-ja.md      |  2 +-
 docs-ja/pages/workflows-ja.md            | 95 +++++++++++++++++++++++++++++++-
 15 files changed, 159 insertions(+), 32 deletions(-)
```

<details>
<summary>advisor-ja.md</summary>

```diff
diff --git a/docs-ja/pages/advisor-ja.md b/docs-ja/pages/advisor-ja.md
index 159eea2..9fde894 100644
--- a/docs-ja/pages/advisor-ja.md
+++ b/docs-ja/pages/advisor-ja.md
@@ -175,5 +175,5 @@ advisor の使用を停止し、保存された `advisorModel` をクリアす
 ```
 
-advisor ツール全体（`/advisor` コマンドと `--advisor` フラグを含む）を無効にするには、`CLAUDE_CODE_DISABLE_ADVISOR_TOOL=1` を設定します。[環境変数](/ja/env-vars)を参照してください。
+advisor ツール全体を無効にするには、`CLAUDE_CODE_DISABLE_ADVISOR_TOOL=1` を設定します。`/advisor` コマンドは利用できなくなり、設定された `advisorModel` は無視されます。`--advisor` フラグは受け入れられますが、効果はありません。このフラグを渡す既存のスクリプトはエラーなしで動作し続けます。[環境変数](/ja/env-vars)を参照してください。
 
 <h2 id="compare-with-related-features">
```

</details>

<details>
<summary>agent-view-ja.md</summary>

```diff
diff --git a/docs-ja/pages/agent-view-ja.md b/docs-ja/pages/agent-view-ja.md
index 26f438b..eaa1e35 100644
--- a/docs-ja/pages/agent-view-ja.md
+++ b/docs-ja/pages/agent-view-ja.md
@@ -65,5 +65,5 @@ Claude が複数の独立したタスクに対して、あなたが毎ステッ
 
   <Step title="既存のセッションを持ち込む">
-    既に開いているセッションをエージェントビューに移動するには、セッション内で `/bg` を実行するか、空のプロンプトで `←` を押してセッションをバックグラウンドにし、1 ステップでエージェントビューを開きます。セッションは実行し続け、ディスパッチしたセッションと並行して行として表示されます。
+    このステップは実行中のセッションが必要です。前のステップに従った場合、このターミナルで開いているセッションはないため、別のターミナルで通常の `claude` セッションを開き、最初にメッセージを送信してください。既に開いているセッションをエージェントビューに移動するには、セッション内で `/bg` を実行するか、空のプロンプトで `←` を押してセッションをバックグラウンドにし、1 ステップでエージェントビューを開きます。セッションは実行し続け、ディスパッチしたセッションと並行して行として表示されます。
   </Step>
 </Steps>
@@ -295,5 +295,5 @@ Completed
 
 * そのディレクトリで `claude agents` を開きます。
-* 親ディレクトリで `claude agents` を開き、プロンプトで `@<repo>` を使用して子リポジトリを言及してセッションをそこで実行します。`@` を入力すると、起動ディレクトリの 1 レベル下の git リポジトリ、およびリスト内に既にセッションがあるディレクトリがリストされます。名前にスペースが含まれるディレクトリはリストされません。
+* 親ディレクトリで `claude agents` を開き、プロンプトで `@<repo>` を使用して子リポジトリを言及します。`@` を入力すると、起動ディレクトリの 1 レベル下の git リポジトリ、およびリスト内に既にセッションがあるディレクトリがリストされます。名前にスペースが含まれるディレクトリはリストされません。
 * シェルから、ディレクトリに `cd` して `claude --bg "<prompt>"` を実行します。
 
```

</details>

<details>
<summary>artifacts-ja.md</summary>

```diff
diff --git a/docs-ja/pages/artifacts-ja.md b/docs-ja/pages/artifacts-ja.md
index 10fb365..f018128 100644
--- a/docs-ja/pages/artifacts-ja.md
+++ b/docs-ja/pages/artifacts-ja.md
@@ -5,13 +5,13 @@
 # セッション出力をアーティファクトとして共有する
 
-> アーティファクトは Claude Code の作業をライブでインタラクティブなページに変え、組織内で共有できるプライベート URL で利用できます。
+> アーティファクトは Claude Code の作業をライブでインタラクティブなページに変え、claude.ai 上のプライベート URL で利用できます。
 
-{/* plan-availability: feature=artifacts plans=team,enterprise providers=anthropic */}
+{/* plan-availability: feature=artifacts plans=pro,max,team,enterprise providers=anthropic */}
 
 <Note>
-  アーティファクトはベータ版です。Team または Enterprise プランと、[`/login`](/ja/setup#authenticate) でサインインしたセッションが必要です。要件の完全なセットについては、[利用可能性](#availability)を参照してください。
+  アーティファクトは Pro、Max、Team、および Enterprise プランで利用でき、[`/login`](/ja/setup#authenticate) でサインインしたセッションが必要です。要件の完全なセットについては、[利用可能性](#availability)を参照してください。
 </Note>
 
-アーティファクトは、Claude Code がセッションから claude.ai のプライベート URL に公開するライブでインタラクティブなウェブページです。ブラウザで開くと、セッションが続く間、ページはその場で更新されます。ページヘッダーから共有して、チームメイトにも見てもらうことができます。たとえば、アーティファクトを使用して、注釈付きの差分でプルリクエストをレビュアーに説明したり、セッションデータからダッシュボードを構築したり、Claude が作業する際に埋まっていく調査タイムラインを保持したりできます。
+アーティファクトは、Claude Code がセッションから claude.ai のプライベート URL に公開するライブでインタラクティブなウェブページです。ブラウザで開くと、セッションが続く間、ページはその場で更新されます。Team および Enterprise プランでは、ページヘッダーから共有して、チームメイトにも見てもらうことができます。たとえば、アーティファクトを使用して、注釈付きの差分でプルリクエストをレビュアーに説明したり、セッションデータからダッシュボードを構築したり、Claude が作業する際に埋まっていく調査タイムラインを保持したりできます。
 
 <Frame>
@@ -85,5 +85,5 @@ https://claude.ai/code/artifact/5fbea6f3-... を今日の数字で更新して
 </h2>
 
-新しいアーティファクトは、あなただけに表示されます。ブラウザで開き、ページヘッダーの **Share** コントロールを使用して、組織内の特定の人またはすべての人にアクセス権を付与します。ヘッダーはあなたをアーティファクトの作成者として名前を付けるため、共有した人は誰がページを公開したかを見ることができます。また、[claude.ai/code/artifacts](https://claude.ai/code/artifacts) のギャラリーにリンクしており、作成したすべてのアーティファクトが一覧表示されます。
+新しいアーティファクトは、あなただけに表示されます。Pro プランと Max プランでは、アーティファクトはあなたのみに非公開のままです。Team プランと Enterprise プランでは、ブラウザでアーティファクトを開き、ページヘッダーの **Share** コントロールを使用して、組織内の特定の人またはすべての人にアクセス権を付与します。ヘッダーはあなたをアーティファクトの作成者として名前を付けるため、共有した人は誰がページを公開したかを見ることができます。また、[claude.ai/code/artifacts](https://claude.ai/code/artifacts) のギャラリーにリンクしており、作成したすべてのアーティファクトが一覧表示されます。
 
 共有は組織で停止します。ビューアは、アーティファクトを公開した同じ組織のメンバーとして claude.ai にサインインする必要があり、組織外で表示可能にするオプションはありません。組織外の人に基になるコンテンツを送信するには、Claude に HTML ファイルを依頼し、そのファイルを直接共有してください。
@@ -191,5 +191,5 @@ Claude はデザインシステムを独自の選択よりも高い優先度と
```

</details>

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index 642541c..05e2d78 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,6 +1,34 @@
 # Changelog
 
+## 2.1.199
+
+- Stacked slash-skill invocations like `/skill-a /skill-b do XYZ` now load all leading skills (up to 5), not just the first
+- Fixed SSL certificate errors (TLS-inspecting proxies, missing `NODE_EXTRA_CA_CERTS`, expired certs) burning retries before showing actionable guidance — they now fail immediately with the fix hint
+- Fixed streaming responses being discarded when the API emits a mid-stream overloaded/server error after partial output — the partial is now kept with an incomplete-response notice
+- Fixed subagents cut off by a rate limit or server error silently failing instead of returning their partial work to the parent
+- Fixed subagents reporting API errors (e.g. usage limit reached) as successful results — the error is now reported to the parent agent
+- Fixed the background-agent daemon on Linux killing itself and every running agent every ~50 seconds after an unclean shutdown left a corrupted worker record
+- Fixed background agents failing to cold-start over SSH on macOS with "Could not switch to audit session" (regression in 2.1.196)
+- Fixed `claude stop` being silently undone when it raced a background-agent respawn — the respawn now honors the stop
+- Fixed background job progress indicators stalling for minutes while the job ran long commands
+- Fixed background sessions on memory-starved machines showing a generic error — they now indicate low memory and suggest freeing resources
+- Fixed remote sessions briefly flapping between Working and Idle in the agent view when a background agent completes
+- Fixed idle subagents vanishing from the agent panel while other subagents were still working; surplus idle agents now collapse into an expandable summary row
+- Fixed typing `/model` or `/fast` while viewing a subagent silently opening the lead's model picker — a notice now explains the command applies to the lead
+- Fixed `SessionStart`, `Setup`, and `SubagentStart` hooks silently hiding stderr when exiting with code 2 — the error is now shown in the transcript
+- Fixed `claude --dangerously-skip-permissions daemon <subcommand>` being treated as a chat prompt instead of running the subcommand
+- Fixed `SendMessage` silently misrouting when a re-spawned agent reuses a previous agent's name — the tool now detects the mismatch and asks the caller to retarget
+- Fixed opening or resuming a session with no new messages needlessly growing the transcript file
+- Fixed backgrounding a session with `←` or `/background` dropping its `/color` from the agent view row
+- Fixed resetting a corrupted config file from the startup recovery dialog destroying it unrecoverably — it now backs up the file first
+- Fixed Claude in Chrome repeatedly opening the reconnect page when sessions run from different builds or config directories
+- Fixed plan mode not prompting for state-changing browser tool calls; read-only `browser_batch` calls are now correctly auto-allowed
```

</details>

<details>
<summary>costs-ja.md</summary>

```diff
diff --git a/docs-ja/pages/costs-ja.md b/docs-ja/pages/costs-ja.md
index d3358dc..e1dd691 100644
--- a/docs-ja/pages/costs-ja.md
+++ b/docs-ja/pages/costs-ja.md
@@ -108,5 +108,5 @@ Bedrock、Vertex、および Foundry では、Claude Code はクラウドから
 * **カスタムコンパクション指示を追加する**: `/compact Focus on code samples and API usage` は、要約中に保持する内容を Claude に指示します。
 
-CLAUDE.md でコンパクション動作をカスタマイズすることもできます。
+プロジェクトのルートにある CLAUDE.md ファイルでコンパクション動作をカスタマイズすることもできます。
 
 ```markdown theme={null}
@@ -171,5 +171,5 @@ MCP ツール定義は [デフォルトで遅延](/ja/mcp#scale-with-mcp-tool-se
 
   <Tab title="filter-test-output.sh">
-    フックはこのスクリプトを呼び出し、コマンドがテストランナーであるかどうかを確認し、失敗のみを表示するように変更します。
+    フックはこのスクリプトを呼び出します。`mkdir -p ~/.claude/hooks` でフォルダを作成し、以下のスクリプトを `~/.claude/hooks/filter-test-output.sh` として保存し、`chmod +x ~/.claude/hooks/filter-test-output.sh` で実行可能にします。コマンドがテストランナーであるかどうかを確認し、失敗のみを表示するように変更します。
 
     ```bash theme={null}
@@ -199,5 +199,5 @@ MCP ツール定義は [デフォルトで遅延](/ja/mcp#scale-with-mcp-tool-se
 </h3>
 
-拡張思考はデフォルトで有効になっています。これは複雑な計画と推論タスクのパフォーマンスを大幅に向上させるためです。思考トークンは出力トークンとして課金され、デフォルト予算はモデルに応じて数万トークンになる場合があります。深い推論が必要ない単純なタスクの場合、`/effort` で [努力レベル](/ja/model-config#adjust-effort-level) を低下させるか、`/model` で、`/config` で思考を無効にするか、`MAX_THINKING_TOKENS=8000` で予算を低下させることでコストを削減できます。適応推論モデルはゼロ以外の予算を無視するため、代わりに努力レベルを使用します。Fable 5 では思考を無効にすることはできません。これは常に拡張思考を使用します。
+拡張思考はデフォルトで有効になっています。これは複雑な計画と推論タスクのパフォーマンスを大幅に向上させるためです。思考トークンは出力トークンとして課金され、デフォルト予算はモデルに応じて数万トークンになる場合があります。深い推論が必要ない単純なタスクの場合、`/effort` で [努力レベル](/ja/model-config#adjust-effort-level) を低下させるか、`/model` で、`/config` で思考を無効にするか、[固定思考予算](/ja/model-config#adaptive-reasoning-and-fixed-thinking-budgets) を持つモデルで、`MAX_THINKING_TOKENS=8000` などの `MAX_THINKING_TOKENS` [環境変数](/ja/env-vars) を設定して予算を低下させることでコストを削減できます。適応推論モデルはゼロ以外の予算を無視するため、代わりに努力レベルを使用します。Fable 5 では思考を無効にすることはできません。これは常に拡張思考を使用します。
 
 <h3 id="delegate-verbose-operations-to-subagents">
```

</details>

<details>
<summary>desktop-linux-ja.md</summary>

```diff
diff --git a/docs-ja/pages/desktop-linux-ja.md b/docs-ja/pages/desktop-linux-ja.md
index dc8eaad..429ea53 100644
--- a/docs-ja/pages/desktop-linux-ja.md
+++ b/docs-ja/pages/desktop-linux-ja.md
@@ -51,4 +51,6 @@ Anthropic の apt リポジトリからインストールして、更新がシ
   <Step title="起動してサインインする">
     アプリケーションランチャーから **Claude** を起動するか、ターミナルから `claude-desktop` を実行して、Anthropic アカウントでサインインします。
+
+    Linux アプリは macOS と Windows と同じ方法でサインインします。claude.ai サブスクリプション、または組織の SSO を通じてサインインします。Desktop は Claude Console API キーを直接受け入れません。API キー認証には [CLI](/ja/quickstart) を使用してください。Google Cloud の Agent Platform または LLM ゲートウェイに Desktop をルーティングするエンタープライズデプロイメントについては、[エンタープライズ設定ガイド](https://support.claude.com/en/articles/12622667-enterprise-configuration) および [ネットワーク設定](/ja/network-config) を参照してください。
   </Step>
 </Steps>
```

</details>

<details>
<summary>env-vars-ja.md</summary>

```diff
diff --git a/docs-ja/pages/env-vars-ja.md b/docs-ja/pages/env-vars-ja.md
index bd22524..b1e096d 100644
--- a/docs-ja/pages/env-vars-ja.md
+++ b/docs-ja/pages/env-vars-ja.md
@@ -346,5 +346,5 @@ Claude Code は起動時に環境変数を読み取るため、変更は `claude
 | `MAX_THINKING_TOKENS`                                   | [拡張思考](https://platform.claude.com/docs/en/build-with-claude/extended-thinking) トークン予算をオーバーライドします。上限はモデルの [最大出力トークン](https://platform.claude.com/docs/en/about-claude/models/overview#latest-models-comparison) から 1 を引いた値です。Anthropic API で思考を完全に無効にするには `0` に設定します。Fable 5 を除く。思考をオフにすることはできません。[サードパーティプロバイダー](/ja/third-party-integrations) では、`0` 同様にパラメータを省略するため、2 つの変数はそこで同じ動作をします。[適応的推論](/ja/model-config#adjust-effort-level) を備えたモデルでは、非ゼロ値の場合、`CLAUDE_CODE_DISABLE_ADAPTIVE_THINKING` を通じて適応的推論が無効にされない限り、予算は無視されます                                                                                  |
 | `MCP_CLIENT_SECRET`                                     | [事前設定された認証情報](/ja/mcp#use-pre-configured-oauth-credentials) が必要な MCP サーバーの OAuth クライアントシークレット。`--client-secret` でサーバーを追加するときに対話的なプロンプトを回避します                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
-| `MCP_CONNECTION_NONBLOCKING`                            | スタートアップが最初のクエリの前に MCP サーバーの接続を待機するかどうかを制御します。{/* min-version: 2.1.142 */}Claude Code v2.1.142 以降、MCP スタートアップはデフォルトで非ブ ロッキングです：サーバーはバックグラウンドで接続し、完了するとそのツールが利用可能になります。`0` に設定してブロッキング 5 秒接続待機を復元します。[`alwaysLoad: true`](/ja/mcp#exempt-a-server-from-deferral) で設定されたサーバーは、ツールが最初のプロンプトが構築されるときに存在する必要があるため、この設定に関係なく常にブロックします                                                                                                                                                                                                                                                                                   |
+| `MCP_CONNECTION_NONBLOCKING`                            | スタートアップが最初のクエリの前に MCP サーバーの接続を待機するかどうかを制御します。{/* min-version: 2.1.142 */}Claude Code v2.1.142 以降、MCP スタートアップはデフォルトで非ブロッキングです：サーバーはバックグラウンドで接続し、完了するとそのツールが利用可能になります。`0` に設定してブロッキング 5 秒接続待機を復元します。[`alwaysLoad: true`](/ja/mcp#exempt-a-server-from-deferral) で設定されたサーバーは、ツールが最初のプロンプトが構築されるときに存在する必要があるため、この設定に関係なく常にブロックします                                                                                                                                                                                                                                                                                    |
 | `MCP_CONNECT_TIMEOUT_MS`                                | ブロッキング MCP スタートアップが接続バッチを待機する時間（ミリ秒）。ツールリストをスナップショットする前のデフォルト：5000。`MCP_CONNECTION_NONBLOCKING=0` の場合、または [`alwaysLoad: true`](/ja/mcp#exempt-a-server-from-deferral) でマークされたサーバーに適用されます。期限で保留中のサーバーはバックグラウンドで接続し続けますが、次のクエリまで表示されません。`MCP_TIMEOUT` とは異なります。これは個別のサーバーの接続試行を制限します                                                                                                                                                                                                                                                                                                                                |
 | `MCP_OAUTH_CALLBACK_PORT`                               | OAuth リダイレクトコールバック用の固定ポート。[事前設定された認証情報](/ja/mcp#use-pre-configured-oauth-credentials) で MCP サーバーを追加する場合の `--callback-port` の代替                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
```

</details>

<details>
<summary>feature-availability-ja.md</summary>

```diff
diff --git a/docs-ja/pages/feature-availability-ja.md b/docs-ja/pages/feature-availability-ja.md
index 3f8fde5..98ef5fd 100644
--- a/docs-ja/pages/feature-availability-ja.md
+++ b/docs-ja/pages/feature-availability-ja.md
@@ -51,5 +51,5 @@ Claude Code CLI とローカルで実行されるすべてのものは、すべ
 * [Chrome 拡張機能](/ja/chrome)
 * [Computer use](/ja/computer-use)：Pro および Max プラン
-* [Artifacts](/ja/artifacts)：Team および Enterprise プラン
+* [Artifacts](/ja/artifacts)：Pro、Max、Team、および Enterprise プラン
 * [Voice dictation](/ja/voice-dictation)
 
@@ -287,5 +287,5 @@ Bedrock、Vertex AI、Foundry、または Anthropic Console API キーを通じ
 | Dispatch（[Desktop](/ja/desktop#sessions-from-dispatch)）                                 | ✓   | ✓   | ✗             | ✗                                 |
 | [Code Review](/ja/code-review)                                                          | ✗   | ✗   | ✓             | ✓                                 |
-| [Artifacts](/ja/artifacts)                                                              | ✗   | ✗   | ✓             | Admin-enabled                     |
+| [Artifacts](/ja/artifacts)                                                              | ✓   | ✓   | ✓             | Admin-enabled                     |
 | [アナリティクスダッシュボード、API、および貢献メトリクス](/ja/analytics)                                          | ✗   | ✗   | ✓             | ✓                                 |
 | [サーバー管理設定](/ja/server-managed-settings)                                                 | ✗   | ✗   | ✓             | ✓                                 |
```

</details>

<details>
<summary>interactive-mode-ja.md</summary>

```diff
diff --git a/docs-ja/pages/interactive-mode-ja.md b/docs-ja/pages/interactive-mode-ja.md
index cb4f485..2fcd922 100644
--- a/docs-ja/pages/interactive-mode-ja.md
+++ b/docs-ja/pages/interactive-mode-ja.md
@@ -38,5 +38,5 @@
 | `Ctrl+V` または `Cmd+V`（iTerm2）または `Alt+V`（Windows および WSL） | クリップボードから画像を貼り付け                                                                                                  | カーソルに `[Image #N]` チップを挿入して、プロンプト内で位置的に参照できます。WSL では、`Ctrl+V` と `Alt+V` の両方がバインドされています。ターミナルが `Ctrl+V` をインターセプトする場合は `Alt+V` を使用してください                                                 |
 | `Ctrl+B`                                                 | バックグラウンドで実行中のタスク                                                                                                  | bash コマンドとエージェントをバックグラウンドで実行します。Tmux ユーザーは 2 回押す                                                                                                                                       |
-| `Ctrl+T`                                                 | タスクリストを切り替え                                                                                                       | ターミナルステータス領域の [タスクリスト](#task-list) を表示または非表示                                                                                                                                           |
+| `Ctrl+T`                                                 | Claude のタスクチェックリストを切り替え                                                                                           | ステータス領域の [Claude のタスクチェックリスト](#task-list) を表示または非表示にします。これはバックグラウンドタスクビューではありません。実行中のシェルとサブエージェントを確認するには [`/tasks`](/ja/commands) を使用してください                                            |
 | `Left/Right 矢印`                                          | ダイアログタブを循環                                                                                                        | 権限ダイアログとメニューのタブ間を移動                                                                                                                                                                    |
 | `Up/Down 矢印` または `Ctrl+P`/`Ctrl+N`                       | カーソルを移動またはコマンド履歴を移動                                                                                               | 複数行入力では、最初にカーソルをプロンプト内で移動します。カーソルが既に上端または下端にある場合、もう一度押すとコマンド履歴を移動します。{/* min-version: 2.1.169 */}v2.1.169 以降、折り返された単一行入力は複数行入力と同じように動作します                                              |
@@ -390,7 +390,7 @@ export CLAUDE_CODE_ENABLE_PROMPT_SUGGESTION=false
 </h2>
 
-複雑なマルチステップ作業に取り組む場合、Claude はタスクリストを作成して進捗を追跡します。タスクはターミナルのステータス領域に表示され、保留中、進行中、または完了を示すインジケータが表示されます。
+タスクリストは Claude のやることリストです。マルチステップ作業を計画するために Claude が作成したアイテムで、保留中、進行中、または完了を示すインジケータが表示されます。これはバックグラウンドタスクビューとは別です。実行中のシェルとサブエージェントを確認するには、代わりに [`/tasks`](/ja/commands) を使用してください。
 
-* `Ctrl+T` を押してタスクリストビューを切り替えます。表示は一度に最大 5 個のタスクを表示します
+* `Ctrl+T` を押してタスクリストビューを切り替えます。表示は一度に最大 5 個のタスクを表示します。Claude がまだチェックリストアイテムを作成していない場合、トグルは表示する内容がないため目に見える効果がありません
 * すべてのタスクを表示するか、クリアするには、Claude に直接質問します：「すべてのタスクを表示して」または「すべてのタスクをクリアして」
 * タスクはコンテキストコンパクション全体で保持され、Claude がより大きなプロジェクトで整理された状態を保つのに役立ちます
```

</details>

*...以降省略*

</details>


<details>
<summary>2026-07-02</summary>

**変更ファイル:**

```
 docs-ja/pages/advisor-ja.md              | 14 ++++++-------
 docs-ja/pages/agent-teams-ja.md          |  2 ++
 docs-ja/pages/agent-view-ja.md           | 28 ++++++++++++-------------
 docs-ja/pages/changelog.md               | 35 ++++++++++++++++++++++++++++++++
 docs-ja/pages/env-vars-ja.md             |  3 ++-
 docs-ja/pages/llm-gateway-protocol-ja.md |  2 +-
 docs-ja/pages/monitoring-usage-ja.md     |  2 +-
 docs-ja/pages/skills-ja.md               |  2 ++
 docs-ja/pages/tools-reference-ja.md      |  2 +-
 docs-ja/pages/troubleshoot-install-ja.md |  8 +++++++-
 docs-ja/pages/vs-code-ja.md              |  2 ++
 11 files changed, 74 insertions(+), 26 deletions(-)
```

<details>
<summary>advisor-ja.md</summary>

```diff
diff --git a/docs-ja/pages/advisor-ja.md b/docs-ja/pages/advisor-ja.md
index 7269a1a..159eea2 100644
--- a/docs-ja/pages/advisor-ja.md
+++ b/docs-ja/pages/advisor-ja.md
@@ -85,11 +85,11 @@ claude --advisor opus
 advisor はメインモデル以上の機能を持つ必要があります。各メインモデルで受け入れられる advisor は次のとおりです。
 
-| メインモデル                                          | 受け入れられる advisor            | 注記                                                    |
-| ----------------------------------------------- | -------------------------- | ----------------------------------------------------- |
-| Haiku 4.5                                       | Fable、Opus、Sonnet          | Haiku は advisor を呼び出すことはできますが、advisor として機能することはできません |
-| Sonnet 4.6                                      | Fable、Opus、Sonnet          |                                                       |
-| Sonnet 5                                        | Fable、Opus、Sonnet 5        | Sonnet 4.6 advisor は拒否されます                            |
-| Opus 4.6 以降                                     | Fable、メインモデルのバージョン以上の Opus | Opus 4.7 メインと Opus 4.6 advisor は拒否されます                |
-| Fable 5 ({/* min-version: 2.1.170 */}v2.1.170+) | Fable                      | Opus または Sonnet advisor は拒否されます                       |
+| メインモデル                                          | 受け入れられる advisor            | 注記                                                                            |
+| ----------------------------------------------- | -------------------------- | ----------------------------------------------------------------------------- |
+| Haiku 4.5                                       | Fable、Opus、Sonnet          | Haiku は advisor を呼び出すことはできますが、advisor として機能することはできません                         |
+| Sonnet 4.6                                      | Fable、Opus、Sonnet          |                                                                               |
+| Sonnet 5                                        | Fable、Opus、Sonnet 5        | Sonnet 4.6 advisor は拒否されます                                                    |
+| Opus 4.6 以降                                     | Fable、メインモデルのバージョン以上の Opus | Opus 4.7 メインと Opus 4.6 advisor は拒否されます。Opus 4.6 メインは Sonnet 5 advisor も受け入れます |
+| Fable 5 ({/* min-version: 2.1.170 */}v2.1.170+) | Fable                      | Opus または Sonnet advisor は拒否されます                                               |
 
 Fable 5 は、メインモデルとして機能するか advisor として機能するかに関わらず、Claude Code v2.1.170 以降と Fable 5 アクセスが必要です。
```

</details>

<details>
<summary>agent-teams-ja.md</summary>

```diff
diff --git a/docs-ja/pages/agent-teams-ja.md b/docs-ja/pages/agent-teams-ja.md
index 544d62a..984c277 100644
--- a/docs-ja/pages/agent-teams-ja.md
+++ b/docs-ja/pages/agent-teams-ja.md
@@ -285,4 +285,6 @@ Spawn a teammate using the security-reviewer agent type to audit the auth module
 チームメンバーはリーダーの権限設定で開始します。リーダーが `--dangerously-skip-permissions` で実行する場合、すべてのチームメンバーも同様に実行します。生成後、個別のチームメンバーモードを変更できますが、生成時にチームメンバーごとのモードを設定することはできません。
 
+1 つのエージェントが `SendMessage` 経由で別のエージェントにメッセージを送信する場合、受信エージェントには、あなたからではなく別の Claude セッションから来たことが通知されます。チームメンバーは権限プロンプトを承認したり、あなたに代わって同意を提供したりすることはできません。また、アクションが拒否されたチームメンバーは、チェックをバイパスするために別のチームメンバーにそれをリレーすることはできません。[auto mode](/ja/permission-modes#eliminate-prompts-with-auto-mode) では、別のエージェントからリレーされた承認クレームは、あなたからの確認ではなく、信頼できない入力として分類器によって扱われます。チームメンバーの権限プロンプトはリーダーセッションにバブルアップするため、そこで自分で承認してください。
+
 <h3 id="context-and-communication">
   コンテキストと通信
```

</details>

<details>
<summary>agent-view-ja.md</summary>

```diff
diff --git a/docs-ja/pages/agent-view-ja.md b/docs-ja/pages/agent-view-ja.md
index c8b6854..26f438b 100644
--- a/docs-ja/pages/agent-view-ja.md
+++ b/docs-ja/pages/agent-view-ja.md
@@ -272,15 +272,15 @@ Completed
 プロンプトの一部をプレフィックスまたは言及してセッションの開始方法を制御します：
 
-| 入力                               | 効果                                                                                                       |
-| :------------------------------- | :------------------------------------------------------------------------------------------------------- |
-| `<agent-name> <prompt>`          | 最初の単語がカスタム [subagent](/ja/sub-agents) 名と一致する場合、その subagent はセッションのメインエージェントとして実行され、frontmatter の設定を使用します |
-| `@<agent-name>`                  | プロンプト内の任意の場所でカスタム subagent を言及してメインエージェントとして実行                                                           |
-| `@<repo>`                        | エージェントビューを開いたディレクトリの下のリポジトリを言及してセッションをそこで実行                                                              |
-| `/<command>`                     | [skills](/ja/skills) および [commands](/ja/commands) をディスパッチプロンプトとして提案                                      |
-| `! <command>`                    | Claude セッションを開始する代わりに、シェルコマンドをバックグラウンドジョブとして実行します。ジョブは行として表示され、アタッチ、監視、デタッチできます                          |
-| `#<number>` または pull request URL | セッションが既にその PR で作業している場合は、ディスパッチの代わりに選択                                                                   |
-| `Shift+Enter`                    | ディスパッチして新しいセッションに直ちにアタッチ                                                                                 |
-
-エージェントビュー自体で実行される少数のコマンドがあります。ディスパッチの代わりに：`/exit` および `/quit` はエージェントビューを閉じ、`/logout` はサインアウトします。`/model` はディスパッチモデルを設定します。skills、独自のコマンド、および `/init` などのプロンプト展開組み込みは、新しいバックグラウンドセッションにその最初のプロンプトとして送信されます。その他の組み込みコマンドは、代わりに `attach to a session to run it` ヒントを表示します。
+| 入力                               | 効果                                                                                                              |
+| :------------------------------- | :-------------------------------------------------------------------------------------------------------------- |
+| `<agent-name> <prompt>`          | 最初の単語がカスタム [subagent](/ja/sub-agents) 名と一致する場合、その subagent はセッションのメインエージェントとして実行され、frontmatter の設定を使用します        |
+| `@<agent-name>`                  | プロンプト内の任意の場所でカスタム subagent を言及してメインエージェントとして実行                                                                  |
+| `@<repo>`                        | リポジトリを言及してセッションをそこで実行します。どのリポジトリがリストされるかについては、[特定のディレクトリにディスパッチする](#dispatch-to-a-specific-directory) を参照してください |
+| `/<command>`                     | [skills](/ja/skills) および [commands](/ja/commands) をディスパッチプロンプトとして提案                                             |
+| `! <command>`                    | Claude セッションを開始する代わりに、シェルコマンドをバックグラウンドジョブとして実行します。ジョブは行として表示され、アタッチ、監視、デタッチできます                                 |
+| `#<number>` または pull request URL | セッションが既にその PR で作業している場合は、ディスパッチの代わりに選択                                                                          |
+| `Shift+Enter`                    | ディスパッチして新しいセッションに直ちにアタッチ                                                                                        |
+
+エージェントビュー自体で実行される少数のコマンドがあります。ディスパッチの代わりに：`/exit` および `/quit` はエージェントビューを閉じ、`/logout` はサインアウトします。`/model` は [ディスパッチモデル](#set-the-model) を設定します。skills、独自のコマンド、および `/init` などのプロンプト展開組み込みは、新しいバックグラウンドセッションにその最初のプロンプトとして送信されます。その他の組み込みコマンドは、代わりに `attach to a session to run it` ヒントを表示します。
 
```

</details>

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index 5615452..642541c 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,39 @@
 # Changelog
 
+## 2.1.198
+
+- Claude in Chrome is now generally available
+- Added background agent notifications in `claude agents` — sessions that need input or finish now fire the `Notification` hook (`agent_needs_input` / `agent_completed`)
+- Added `/dataviz` skill for chart and dashboard design guidance with a runnable color-palette validator
+- Gateway: added Claude Platform on AWS (anthropicAws) as an upstream provider; model-not-found responses now advance the failover chain
+- Background agents launched from `claude agents` now commit, push, and open a draft PR when they finish code work in a worktree, instead of stopping to ask
+- The built-in Explore agent now inherits the main session's model (capped at opus) instead of running on haiku
+- Subagents and context compaction now inherit the session's extended thinking configuration, improving output quality on delegated tasks
+- Fixed brief network drops mid-response aborting the turn — transient errors like ECONNRESET now retry with backoff instead of failing
+- Fixed excessive background classifier requests when sandboxed processes repeatedly accessed the same network host
+- Fixed background tasks in web, desktop, and VS Code task panels getting stuck on "Running" after they finish or after resuming a session
+- Fixed agent teams: a teammate that dies on an API error now reports "failed" to the lead, and messaging a stuck teammate wakes it to retry immediately
+- Fixed the `/diff` panel not refreshing when you switch branches or commit outside the session
+- Fixed markdown tables overflowing and wrapping their right border when rendered in fullscreen mode
+- Fixed Claude Platform on AWS and Mantle sessions dead-ending with "Please run /login" when the STS token expires — `awsAuthRefresh` now runs automatically
+- Fixed "no route to host" for local-network hosts in macOS background agent sessions by declaring Local Network entitlements
+- Fixed `/desktop` failing with "Cannot determine working directory" after entering and exiting a worktree
+- Fixed background agents repeatedly showing "Reconnecting…" every ~52 seconds on macOS while the agents view was open
+- Fixed pressing `←` inside `claude attach <id>` exiting to the shell instead of opening the agent view
+- Fixed `claude --bg` silently creating an unattachable session when combined with `--print`/`-p`; the conflicting flags are now rejected up front
+- Fixed the workflow progress view dropping the earliest agents from the list while the phase counter stayed correct in SDK and desktop-app sessions
+- Fixed `.claude/rules/` conditional rules not loading when the target file is reached via a symlinked path
```

</details>

<details>
<summary>env-vars-ja.md</summary>

```diff
diff --git a/docs-ja/pages/env-vars-ja.md b/docs-ja/pages/env-vars-ja.md
index 574d0dd..bd22524 100644
--- a/docs-ja/pages/env-vars-ja.md
+++ b/docs-ja/pages/env-vars-ja.md
@@ -269,5 +269,5 @@ Claude Code は起動時に環境変数を読み取るため、変更は `claude
 | `CLAUDE_CODE_SESSIONEND_HOOKS_TIMEOUT_MS`               | [SessionEnd](/ja/hooks#sessionend) フックの時間予算をオーバーライドします（ミリ秒）。セッション終了、`/clear`、および対話的な `/resume` を通じたセッション切り替えに適用されます。デフォルトでは予算は 1.5 秒で、設定ファイルで設定されたフックごとの最高 `timeout` に自動的に引き上げられます。最大 60 秒。プラグイン提供フックのタイムアウトは予算を引き上げません                                                                                                                                                                                                                                                                                                                                                                                          |
 | `CLAUDE_CODE_SESSION_ID`                                | Bash と PowerShell ツールサブプロセスで現在のセッション ID に自動的に設定されます。[フック](/ja/hooks) コマンドサブプロセスと stdio [MCP サーバー](/ja/mcp) サブプロセスでも設定されます。フックに渡される `session_id` フィールドと一致します。`/clear` で更新されます。スクリプトと外部ツールを Claude Code セッションと相関させるために使用します                                                                                                                                                                                                                                                                                                                                                                                        |
-| `CLAUDE_CODE_SHELL`                                     | 自動シェル検出をオーバーライドします。ログインシェルが優先作業シェルと異なる場合に役立ちます（例：`bash` vs `zsh`）                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
+| `CLAUDE_CODE_SHELL`                                     | Claude Code が Bash ツールコマンドを実行するために使用するシェルを設定します。`bash` または `zsh` バイナリへのパス（例：`/opt/homebrew/bin/bash`）を受け入れます。`fish` などの他のシェルはサポートされていません。値が機能する `bash` または `zsh` パスでない場合、Claude Code はそれを無視し、自動検出にフォールバックします。自動検出は、`bash` または `zsh` を指している場合に `$SHELL` を使用します。それ以外の場合は、PATH と標準インストール場所で見つかった最初の機能する `zsh` を選択し、次に `bash` を選択します                                                                                                                                                                                                                                                                                 |
 | `CLAUDE_CODE_SHELL_PREFIX`                              | Claude Code がスポーンするシェルコマンドをラップするコマンドプレフィックス：Bash ツール呼び出し、[フック](/ja/hooks) コマンド、[ステータスライン](/ja/statusline) コマンド、stdio [MCP サーバー](/ja/mcp) スタートアップコマンド。PowerShell フックと exec 形式フックはプレフィックスなしで実行されます。ログまたは監査に役立ちます。`/path/to/logger.sh` などの裸の実行可能ファイルパスを設定すると、各コマンドが `/path/to/logger.sh '<command>'` として実行されます。ラッパーはコマンドラインを `$1` の単一シェルクォート引数として受け取るため、ラッパーは `$1` を `exec bash -c "$1"` などのシェルで再評価する必要があります。`$1` を裸の実行可能ファイルパスとして扱うと、`npx -y <package>` などの引数を渡す stdio MCP サーバーが壊れます。Bash ツール呼び出しの場合、`$1` には Claude が組み立てた完全なシェル呼び出しが含まれます。環境セットアップを含みます。Claude が実行したコマンドのみではありません                                 |
 | `CLAUDE_CODE_SIMPLE`                                    | 最小限のシステムプロンプトと Bash、ファイル読み取り、ファイル編集ツールのみで実行するには `1` に設定します。`--mcp-config` からの MCP ツールは引き続き利用可能です。フック、スキル、プラグイン、MCP サーバー、自動メモリ、CLAUDE.md の自動検出を無効にします。OAuth トークンとキーチェーン認証情報は読み取られないため、Anthropic 認証は `ANTHROPIC_API_KEY` または `--settings` の `apiKeyHelper` から取得する必要があります。[`--bare`](/ja/headless#start-faster-with-bare-mode) CLI フラグと同等です                                                                                                                                                                                                                                                                         |
@@ -379,4 +379,5 @@ Claude Code は起動時に環境変数を読み取るため、変更は `claude
 | `VERTEX_REGION_CLAUDE_4_7_OPUS`                         | {/* min-version: 2.1.111 */}Vertex AI を使用する場合、Claude Opus 4.7 のリージョンをオーバーライドします。v2.1.111 で追加されました                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
 | `VERTEX_REGION_CLAUDE_4_8_OPUS`                         | {/* min-version: 2.1.154 */}Vertex AI を使用する場合、Claude Opus 4.8 のリージョンをオーバーライドします。v2.1.154 で追加されました                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
+| `VERTEX_REGION_CLAUDE_5_SONNET`                         | {/* min-version: 2.1.197 */}Vertex AI を使用する場合、Claude Sonnet 5 のリージョンをオーバーライドします。v2.1.197 で追加されました                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
 | `VERTEX_REGION_CLAUDE_FABLE_5`                          | {/* min-version: 2.1.170 */}Vertex AI を使用する場合、Claude Fable 5 のリージョンをオーバーライドします。v2.1.170 で追加されました                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
 | `VERTEX_REGION_CLAUDE_HAIKU_4_5`                        | Vertex AI を使用する場合、Claude Haiku 4.5 のリージョンをオーバーライドします                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
```

</details>

<details>
<summary>llm-gateway-protocol-ja.md</summary>

```diff
diff --git a/docs-ja/pages/llm-gateway-protocol-ja.md b/docs-ja/pages/llm-gateway-protocol-ja.md
index a003766..b451358 100644
--- a/docs-ja/pages/llm-gateway-protocol-ja.md
+++ b/docs-ja/pages/llm-gateway-protocol-ja.md
@@ -196,5 +196,5 @@ Claude Code はレスポンスの `data` 配列の各エントリから `id` と
 ピッカーは、開発者が Claude Code で `/model` を実行するときに開く対話型モデルリストです。各検出されたエントリは「ゲートウェイから」とラベル付けされ、提供されている場合は `display_name` を使用します。[`availableModels` マネージド設定](/ja/settings#available-settings)は検出が追加できるものを制限します。
 
-検出された ID は、ピッカーに既に存在する行と正確に一致する場合、または検出されたものと既存の ID の両方が [Fable](/ja/model-config#work-with-fable-5) に解決される場合のみスキップされます。組み込み行は `sonnet` などのエイリアスをキーとするため、`claude-sonnet-4-6` などの検出された ID は、組み込みエントリの横に独自の「ゲートウェイから」行を追加します。
+検出された ID は、ピッカーに既に存在する行と正確に一致する場合、または検出されたものと既存の ID の両方が [Fable](/ja/model-config#work-with-fable-5) に解決される場合のみスキップされます。{/* min-version: 2.1.197 */}Claude Code v2.1.197 以降では、検出された明示的な ID は、両方が同じモデルに解決される場合、組み込みエントリに折りたたまれます。組み込み行は `sonnet` などのエイリアスをキーとするため、エイリアスが現在解決するモデルの検出された明示的な ID（`claude-sonnet-5` など）は `sonnet` 行に折りたたまれ、エイリアスが解決しない ID（`claude-sonnet-4-6` など）は組み込みエントリの横に独自の「ゲートウェイから」行を追加します。
 
 結果は `~/.claude/cache/gateway-models.json` にキャッシュされます。Windows では `%USERPROFILE%\.claude\cache\gateway-models.json`。各スタートアップで更新されます。リクエストが失敗するか、ゲートウェイが `/v1/models` を実装しない場合、ピッカーは前回のスタートアップからのキャッシュリストまたは組み込みモデルリストにフォールバックします。ゲートウェイが検出フィルターと一致しないエイリアスの下で Claude モデルを提供する場合、開発者は [モデル設定](/ja/model-config)変数を使用してそれらのエイリアスを手動で追加できます。
```

</details>

<details>
<summary>monitoring-usage-ja.md</summary>

```diff
diff --git a/docs-ja/pages/monitoring-usage-ja.md b/docs-ja/pages/monitoring-usage-ja.md
index 23ac919..7f259a8 100644
--- a/docs-ja/pages/monitoring-usage-ja.md
+++ b/docs-ja/pages/monitoring-usage-ja.md
@@ -629,5 +629,5 @@ Claude Code は、OpenTelemetry ログ/イベント経由で以下のイベン
 * `response_length`: レスポンステキストの長さ (文字単位)
 * `response`: レスポンステキスト。60 KB で切り詰められます。デフォルトでは `<REDACTED>` にマスクされます。`OTEL_LOG_ASSISTANT_RESPONSES=1` で有効化します。`OTEL_LOG_ASSISTANT_RESPONSES` が設定されていない場合、`OTEL_LOG_USER_PROMPTS` が代わりに制御するため、プロンプトログが有効な場合でもレスポンスをマスクしたままにするには `OTEL_LOG_ASSISTANT_RESPONSES=0` を設定します
-* `model`: モデル識別子 (例: "claude-sonnet-4-6")
+* `model`: モデル識別子 (例: "claude-sonnet-5")
 * `request_id`: レスポンスの `request-id` ヘッダーからの Anthropic API リクエスト ID。API が返す場合のみ存在します
 * `query_source`: リクエストを発行したサブシステム。例: `"repl_main_thread"`、`"compact"`、またはサブエージェント名
```

</details>

<details>
<summary>skills-ja.md</summary>

```diff
diff --git a/docs-ja/pages/skills-ja.md b/docs-ja/pages/skills-ja.md
index 9c7f4a3..d52a0c6 100644
--- a/docs-ja/pages/skills-ja.md
+++ b/docs-ja/pages/skills-ja.md
@@ -130,4 +130,6 @@ Claude Code には、[`disableBundledSkills`](/ja/settings#available-settings) 
 `/deploy` を入力するとプロジェクトルートスキルが実行されます。修飾名 `/apps/web:deploy` を入力してネストされたバリアントを明示的に実行します。
 
+`<skill-name>` エントリは enterprise、personal、またはプロジェクトの場所にあり、ディスク上の別の場所のディレクトリへのシンボリックリンクにすることができます。Claude Code はシンボリックリンクをたどり、ターゲットディレクトリから `SKILL.md` を読み取ります。同じターゲットが複数の場所から到達可能な場合、Claude Code はスキルを 1 回だけ読み込みます。プラグインスキルはシンボリックリンクを異なる方法で処理します。[シンボリックリンクを使用してマーケットプレイス内でファイルを共有する](/ja/plugins-reference#share-files-within-a-marketplace-with-symlinks)を参照してください。
+
 <Note>
   スキルフォルダに `.claude-plugin/plugin.json` を追加すると、`<name>@skills-dir` という名前の[プラグイン](/ja/plugins-reference#skills-directory-plugins)として読み込まれるため、エージェント、hooks、および MCP サーバーをバンドルできます。プロジェクトの `.claude/skills/` では、これはまずワークスペーストラストダイアログを受け入れる必要があります。
```

</details>

<details>
<summary>tools-reference-ja.md</summary>

```diff
diff --git a/docs-ja/pages/tools-reference-ja.md b/docs-ja/pages/tools-reference-ja.md
index bf025af..ca65fea 100644
--- a/docs-ja/pages/tools-reference-ja.md
+++ b/docs-ja/pages/tools-reference-ja.md
@@ -362,5 +362,5 @@ WebSearch 権限ルールは指定子を取りません。`allow` または `den
 
 <Note>
-  WebSearch は Claude API と Microsoft Foundry で利用可能です。Google Cloud Vertex AI では、Opus、Sonnet、Haiku を含む Claude 4 モデルで機能します。Amazon Bedrock はサーバー側の Web 検索ツールを公開していません。
+  WebSearch は Claude API と Microsoft Foundry で利用可能です。Google Cloud Vertex AI では、Opus、Sonnet、Haiku を含む Claude 4 モデル以降で機能します。Amazon Bedrock はサーバー側の Web 検索ツールを公開していません。
 </Note>
 
```

</details>

<details>
<summary>troubleshoot-install-ja.md</summary>

```diff
diff --git a/docs-ja/pages/troubleshoot-install-ja.md b/docs-ja/pages/troubleshoot-install-ja.md
index 4bffa7b..9293217 100644
--- a/docs-ja/pages/troubleshoot-install-ja.md
+++ b/docs-ja/pages/troubleshoot-install-ja.md
@@ -27,4 +27,5 @@
 | `Cask 'claude-code' is unavailable: No Cask with this name exists`                           | [Homebrew を更新する](#homebrew-cask-unavailable-or-outdated)                                          |
 | `'bash' is not recognized as the name of a cmdlet`                                           | [Windows インストーラーコマンドを使用する](#wrong-install-command-on-windows)                                     |
+| `A parameter cannot be found that matches parameter name 'fsSL'`                             | [Windows インストーラーコマンドを使用する](#wrong-install-command-on-windows)                                     |
 | `Claude Code on Windows requires either Git for Windows (for bash) or PowerShell`            | [シェルをインストールする](#claude-code-on-windows-requires-either-git-for-windows-for-bash-or-powershell)    |
 | `Claude Code does not support 32-bit Windows`                                                | [Windows PowerShell を開く（x86 エントリではなく）](#claude-code-does-not-support-32-bit-windows)              |
@@ -490,5 +491,5 @@ Homebrew が予想より古い Claude Code バージョンをインストール
 </h3>
 
-`'irm' is not recognized`、`The token '&&' is not valid`、または `'bash' is not recognized as the name of a cmdlet` が表示される場合、別のシェルまたはオペレーティングシステムのインストールコマンドをコピーしました。
+`'irm' is not recognized`、`The token '&&' is not valid`、`A parameter cannot be found that matches parameter name 'fsSL'`、または `'bash' is not recognized as the name of a cmdlet` が表示される場合、別のシェルまたはオペレーティングシステムのインストールコマンドをコピーしました。
 
 * **`irm` が認識されない**：CMD にいて、PowerShell ではありません。2 つのオプションがあります：
@@ -511,4 +512,9 @@ Homebrew が予想より古い Claude Code バージョンをインストール
   ```
 
+* **`A parameter cannot be found that matches parameter name 'fsSL'`**：Windows PowerShell で macOS/Linux `curl -fsSL ... | bash` インストーラーを実行しました。ここで `curl` は `Invoke-WebRequest` のエイリアスであり、`-fsSL` フラグを拒否します。代わりに PowerShell インストーラーを使用してください：
+  ```powershell theme={null}
+  irm https://claude.ai/install.ps1 | iex
+  ```
+
 * **`bash` が認識されない**：Windows で macOS/Linux インストーラーを実行しました。代わりに PowerShell インストーラーを使用してください：
   ```powershell theme={null}
```

</details>

*...以降省略*

</details>


<details>
<summary>2026-07-01</summary>

**変更ファイル:**

```
 docs-ja/pages/admin-setup-ja.md                    |  28 +-
 docs-ja/pages/advisor-ja.md                        |   3 +-
 docs-ja/pages/agent-view-ja.md                     | 104 +--
 docs-ja/pages/amazon-bedrock-ja.md                 |  24 +-
 docs-ja/pages/authentication-ja.md                 |   6 +-
 docs-ja/pages/auto-mode-config-ja.md               |  84 ++-
 docs-ja/pages/changelog.md                         |   4 +
 docs-ja/pages/claude-apps-gateway-config-en.md     | 699 ---------------------
 docs-ja/pages/claude-apps-gateway-deploy-en.md     | 263 --------
 docs-ja/pages/claude-apps-gateway-en.md            | 319 ----------
 docs-ja/pages/claude-apps-gateway-on-gcp-en.md     | 318 ----------
 .../pages/claude-apps-gateway-spend-limits-en.md   | 142 -----
 docs-ja/pages/claude-code-on-the-web-ja.md         |  13 +-
 docs-ja/pages/claude-platform-on-aws-ja.md         |   2 +-
 docs-ja/pages/cli-reference-ja.md                  |   3 +-
 docs-ja/pages/commands-ja.md                       |   2 +
 docs-ja/pages/computer-use-ja.md                   |   6 +-
 docs-ja/pages/context-window-ja.md                 |   2 +-
 docs-ja/pages/costs-ja.md                          |   2 +-
 docs-ja/pages/data-usage-ja.md                     |   4 +-
 docs-ja/pages/debug-your-config-ja.md              |  22 +-
 docs-ja/pages/deep-links-ja.md                     |   2 +-
 docs-ja/pages/desktop-ja.md                        |  18 +-
 docs-ja/pages/desktop-quickstart-ja.md             |  10 +-
 docs-ja/pages/discover-plugins-ja.md               |  18 +-
 docs-ja/pages/env-vars-ja.md                       |  42 +-
 docs-ja/pages/errors-ja.md                         |  26 +-
 docs-ja/pages/fullscreen-ja.md                     |   8 +-
 docs-ja/pages/gateways-en.md                       |  73 ---
 docs-ja/pages/github-actions-ja.md                 |  10 +-
 docs-ja/pages/glossary-ja.md                       |   2 +-
 docs-ja/pages/google-vertex-ai-ja.md               |   4 +-
 docs-ja/pages/hooks-ja.md                          |  78 ++-
 docs-ja/pages/interactive-mode-ja.md               |  28 +-
 docs-ja/pages/jetbrains-ja.md                      |   2 +-
 docs-ja/pages/llm-gateway-connect-ja.md            |  19 +-
 docs-ja/pages/llm-gateway-ja.md                    |  52 +-
 docs-ja/pages/llm-gateway-protocol-ja.md           |  53 +-
 docs-ja/pages/llm-gateway-rollout-ja.md            |  20 +-
 docs-ja/pages/mcp-ja.md                            |  44 +-
 docs-ja/pages/microsoft-foundry-ja.md              |   2 +-
 docs-ja/pages/model-config-ja.md                   | 182 ++++--
 docs-ja/pages/monitoring-usage-ja.md               |  55 +-
 docs-ja/pages/network-config-ja.md                 |   4 +-
 docs-ja/pages/output-styles-ja.md                  |   4 +-
 docs-ja/pages/permission-modes-ja.md               |  89 ++-
 docs-ja/pages/permissions-ja.md                    |  81 +--
 docs-ja/pages/plugin-dependencies-ja.md            |   5 +
 docs-ja/pages/plugin-marketplaces-ja.md            |  98 ++-
 docs-ja/pages/plugins-reference-ja.md              |   6 +-
 docs-ja/pages/quickstart-ja.md                     |   3 +-
 docs-ja/pages/remote-control-ja.md                 |   7 +
 docs-ja/pages/scheduled-tasks-ja.md                |   9 +-
 docs-ja/pages/server-managed-settings-ja.md        |  12 +-
 docs-ja/pages/sessions-ja.md                       |  10 +-
 docs-ja/pages/settings-ja.md                       | 264 ++++----
 docs-ja/pages/setup-ja.md                          |   2 +-
 docs-ja/pages/skills-ja.md                         |  27 +-
 docs-ja/pages/statusline-ja.md                     |   3 +
 docs-ja/pages/sub-agents-ja.md                     |  58 +-
 docs-ja/pages/third-party-integrations-ja.md       |   1 +
 docs-ja/pages/tools-reference-ja.md                | 127 ++--
 docs-ja/pages/troubleshoot-install-ja.md           |   4 +-
 docs-ja/pages/voice-dictation-ja.md                |  19 +-
 docs-ja/pages/workflows-ja.md                      |   2 +
 65 files changed, 1145 insertions(+), 2488 deletions(-)
```

**新規追加:**


**削除:**


<details>
<summary>admin-setup-ja.md</summary>

```diff
diff --git a/docs-ja/pages/admin-setup-ja.md b/docs-ja/pages/admin-setup-ja.md
index 8c5ff4e..2e42a33 100644
--- a/docs-ja/pages/admin-setup-ja.md
+++ b/docs-ja/pages/admin-setup-ja.md
@@ -37,5 +37,5 @@ Claude Code は複数の API プロバイダーのいずれかを通じて Claud
 | Microsoft Foundry             | 既存の Azure コンプライアンス制御と課金を継承したい場合                                                            |
 
-一部の Claude Code 機能には Claude.ai アカウントが必要です。[web 上の Claude Code](/ja/claude-code-on-the-web)、[Routines](/ja/routines)、[Code Review](/ja/code-review)、[Remote Control](/ja/remote-control)、および [Chrome 拡張機能](/ja/chrome) は、Console API キーまたはクラウドプロバイダーの認証情報だけでは利用できません。Bedrock、Vertex、または Foundry を通じてデプロイする場合は、開発者が Claude for Teams または Enterprise シートも必要かどうかを検討してください。各機能ページにはプラン要件が記載されています。
+一部の Claude Code 機能には claude.ai アカウントが必要です。[web 上の Claude Code](/ja/claude-code-on-the-web)、[Routines](/ja/routines)、[Code Review](/ja/code-review)、[Remote Control](/ja/remote-control)、および [Chrome 拡張機能](/ja/chrome) は、Console API キーまたはクラウドプロバイダーの認証情報だけでは利用できません。Bedrock、Vertex、または Foundry を通じてデプロイする場合は、開発者が Claude for Teams または Enterprise シートも必要かどうかを検討してください。各機能ページにはプラン要件が記載されています。
 
 認証、リージョン、機能パリティをカバーする完全なプロバイダー比較については、[エンタープライズ展開概要](/ja/third-party-integrations) を参照してください。各プロバイダーの認証セットアップは [Authentication](/ja/authentication) にあります。
@@ -47,16 +47,18 @@ Claude Code は複数の API プロバイダーのいずれかを通じて Claud
 </h2>
 
-マネージド設定は、ローカル開発者設定よりも優先されるポリシーを定義します。Claude Code は以下の 4 つのソースを優先順位順にチェックし、空でない設定を返す最初のものを適用します。
+マネージド設定は、ローカル開発者設定よりも優先されるポリシーを定義します。Claude Code は以下の 4 つのソースを優先順位順にチェックし、空でない設定を返す最初のものを適用します。ただし 1 つの例外があります。[クロスソースロックキー](/ja/settings#settings-precedence)（サンドボックス許可リストロックなど）の小さなセットは、管理者が制御するソースがそれらを設定する場合に尊重されます。
 
 | メカニズム                   | 配信                                                                                                                                                                                                  | 優先度 | プラットフォーム      |
 | :---------------------- | :-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :-- | :------------ |
-| Server-managed          | Claude.ai 管理コンソール                                                                                                                                                                                   | 最高  | すべて           |
+| Server-managed          | claude.ai 管理コンソール、またはゲートウェイサインイン用の自己ホスト型 [Claude apps gateway](/ja/claude-apps-gateway)                                                                                                             | 最高  | すべて           |
 | plist / registry policy | macOS: `com.anthropic.claudecode` plist<br />Windows: `HKLM\SOFTWARE\Policies\ClaudeCode`                                                                                                           | 高   | macOS、Windows |
 | File-based managed      | macOS: `/Library/Application Support/ClaudeCode/managed-settings.json`<br />Linux と WSL: `/etc/claude-code/managed-settings.json`<br />Windows: `C:\Program Files\ClaudeCode\managed-settings.json` | 中   | すべて           |
 | Windows user registry   | `HKCU\SOFTWARE\Policies\ClaudeCode`                                                                                                                                                                 | 最低  | Windows のみ    |
 
-Server-managed 設定はデバイスが認証されるときに到達し、アクティブなセッション中は 1 時間ごとに更新されます。エンドポイントインフラストラクチャは不要です。Claude for Teams または Enterprise プランが必要なため、他のプロバイダーでの展開は、代わりにファイルベースまたは OS レベルのメカニズムのいずれかが必要です。
+設定済みの [`policyHelper`](/ja/settings#compute-managed-settings-with-a-policy-helper) は 4 つのソースすべてに優先します。その出力は実行時のマネージド設定の唯一のものになります。[設定の優先度](/ja/settings#settings-precedence) を参照してください。
 
-組織が複数のプロバイダーを混在させている場合、Claude.ai ユーザー向けに [server-managed settings](/ja/server-managed-settings) を設定し、他のユーザーがマネージドポリシーを受け取るように [ファイルベースまたは plist/registry フォールバック](/ja/settings#settings-files) を設定してください。
+Server-managed 設定はデバイスが認証されるときに到達し、アクティブなセッション中は 1 時間ごとに更新されます。エンドポイントインフラストラクチャは不要です。claude.ai 管理コンソール経由の配信には Claude for Teams または Enterprise プランが必要です。Bedrock、Vertex AI、または Foundry での展開は、[Claude apps gateway](/ja/claude-apps-gateway) を実行することで同じリモート配信を取得できます。または、代わりにファイルベースまたは OS レベルのメカニズムのいずれかを使用してください。
```

</details>

<details>
<summary>advisor-ja.md</summary>

```diff
diff --git a/docs-ja/pages/advisor-ja.md b/docs-ja/pages/advisor-ja.md
index 0445cf9..7269a1a 100644
--- a/docs-ja/pages/advisor-ja.md
+++ b/docs-ja/pages/advisor-ja.md
@@ -89,4 +89,5 @@ advisor はメインモデル以上の機能を持つ必要があります。各
 | Haiku 4.5                                       | Fable、Opus、Sonnet          | Haiku は advisor を呼び出すことはできますが、advisor として機能することはできません |
 | Sonnet 4.6                                      | Fable、Opus、Sonnet          |                                                       |
+| Sonnet 5                                        | Fable、Opus、Sonnet 5        | Sonnet 4.6 advisor は拒否されます                            |
 | Opus 4.6 以降                                     | Fable、メインモデルのバージョン以上の Opus | Opus 4.7 メインと Opus 4.6 advisor は拒否されます                |
 | Fable 5 ({/* min-version: 2.1.170 */}v2.1.170+) | Fable                      | Opus または Sonnet advisor は拒否されます                       |
@@ -162,5 +163,5 @@ advisor ツールには、以下のすべてが必要です。
 * **Claude Code v2.1.98 以降**：`claude update` を実行してアップグレードします。
 * **Anthropic API のみ**：advisor はサーバー実行ツールです。Amazon Bedrock、Google Vertex AI、または Microsoft Foundry では利用できません。[LLM ゲートウェイ](/ja/llm-gateway)を通じて `ANTHROPIC_BASE_URL` で構成されている場合、利用可能性はゲートウェイがリクエストを Anthropic API に完全に転送するかどうかに依存します。
-* **サポートされているメインモデル**：Opus 4.6 以降、Sonnet 4.6、または Haiku 4.5。{/* min-version: 2.1.170 */}Fable 5 も Claude Code v2.1.170 以降で適格です。
+* **サポートされているメインモデル**：Opus 4.6 以降、Sonnet 4.6 以降、または Haiku 4.5。{/* min-version: 2.1.170 */}Fable 5 も Claude Code v2.1.170 以降で適格です。
 
 <h2 id="turn-the-advisor-off">
```

</details>

<details>
<summary>agent-view-ja.md</summary>

```diff
diff --git a/docs-ja/pages/agent-view-ja.md b/docs-ja/pages/agent-view-ja.md
index 90fe71c..c8b6854 100644
--- a/docs-ja/pages/agent-view-ja.md
+++ b/docs-ja/pages/agent-view-ja.md
@@ -49,5 +49,5 @@ Claude が複数の独立したタスクに対して、あなたが毎ステッ
 
   <Step title="セッションをディスパッチする">
-    タスクを説明するプロンプトを入力して `Enter` を押します。新しいバックグラウンドセッションがそのタスクで開始され、作業中か、入力を待機中か、完了しているかを示す行として表示されます。新しいセッションはエージェントビューヘッダーに表示されているモデルと、そのディレクトリで `claude` を実行する場合と同じ[パーミッションモード](#permission-mode-model-and-effort)を使用します。
+    タスクを説明するプロンプトを入力して `Enter` を押します。新しいバックグラウンドセッションがそのタスクで開始され、作業中か、入力を待機中か、完了しているかを示す行として表示されます。新しいセッションはエージェントビューヘッダーに表示されているモデルと、そのディレクトリで `claude` を実行する場合と同じ[権限モード](#permission-mode-model-and-effort)を使用します。
 
     ここで入力するすべてのプロンプトは独自の新しいセッションを開始します。別のプロンプトを入力して `Enter` を押すと、最初のセッションへのフォローアップを送信するのではなく、最初のセッションと並行して 2 番目のセッションが起動します。この方法で複数を並行して実行できます。
@@ -77,5 +77,5 @@ Claude が複数の独立したタスクに対して、あなたが毎ステッ
 `claude agents` を実行してエージェントビューを開きます。ターミナル全体を占有し、状態でグループ化されたすべてのセッションをリストします。ピン留めされたセッションと入力が必要なセッションが上部に表示されます。各行はセッションの名前、現在のアクティビティ、最後に変更されてからの経過時間を表示します。
 
-デフォルトでは、リストはすべてのプロジェクト全体で開始したすべてのバックグラウンドセッションを表示します。1 つのリポジトリで作業しているセッションと別のワークツリーで作業している別のセッションの両方がここに表示されます。エージェントビューを開いたディレクトリに関係なく表示されます。リストを 1 つのプロジェクトに絞り込むには、`--cwd` を渡します（Claude Code v2.1.141 以降が必要です）。
+デフォルトでは、リストはすべてのプロジェクト全体で開始したすべてのバックグラウンドセッションを表示します。1 つのリポジトリで作業しているセッションと別のワークツリーで作業している別のセッションの両方がここに表示されます。エージェントビューを開いたディレクトリに関係なく表示されます。リストを 1 つのプロジェクトに絞り込むには、`--cwd` を渡します：
 
 ```bash theme={null}
@@ -144,5 +144,5 @@ Completed
 各行の 1 行の概要は [Haiku クラスモデル](/ja/model-config) によって生成されるため、行はトランスクリプトを開かずにセッションが何をしているか、何が必要か、または何を生成したかを伝えることができます。セッションがアクティブに作業している間、概要は最大 15 秒ごとに 1 回、および各ターンが終了したときに 1 回更新されます。
 
-v2.1.161 以降では、セッションが subagents、バックグラウンドシェルコマンド、またはモニターなど、2 つ以上の並列作業項目を実行している場合、`2/5` などの `done/total` カウントが概要テキストの前に表示されます。
+セッションが subagents、バックグラウンドシェルコマンド、またはモニターなど、2 つ以上の並列作業項目を実行している場合、`2/5` などの `done/total` カウントが概要テキストの前に表示されます。
 
 各更新は通常のプロバイダーを通じた 1 つの短い Haiku クラスリクエストであり、セッション自体と同じ [データ使用条件](/ja/data-usage) の下で請求および処理されます。Bedrock、Vertex AI、Microsoft Foundry、カスタムゲートウェイなどのサードパーティプロバイダーでは、Haiku モデルが設定されていない場合、リクエストはセッションのメインモデルにフォールバックします。これらのプロバイダーでこれらの概要のモデルを選択するには、[`ANTHROPIC_DEFAULT_HAIKU_MODEL`](/ja/model-config#environment-variables) を設定します。
@@ -158,5 +158,5 @@ v2.1.161 以降では、セッションが subagents、バックグラウンド
 プルリクエスト番号はそのステータスで色付けされます。
 
-| 色   | プルリクエストステータス               |
+| カラー | プルリクエストステータス               |
```

</details>

<details>
<summary>amazon-bedrock-ja.md</summary>

```diff
diff --git a/docs-ja/pages/amazon-bedrock-ja.md b/docs-ja/pages/amazon-bedrock-ja.md
index b6fd13f..f7a17ca 100644
--- a/docs-ja/pages/amazon-bedrock-ja.md
+++ b/docs-ja/pages/amazon-bedrock-ja.md
@@ -398,7 +398,7 @@ Claude Code に必要な権限を持つ IAM ポリシーを作成します。
 </h2>
 
-Claude Opus 4.6 以降および Sonnet 4.6 は、Amazon Bedrock で [1M トークンコンテキストウィンドウ](https://platform.claude.com/docs/ja/build-with-claude/context-windows#1m-token-context-window)をサポートしています。Claude Code は、1M モデルバリアントを選択すると、拡張コンテキストウィンドウを自動的に有効にします。
+Claude Sonnet 5、Opus 4.6 以降、および Sonnet 4.6 は、Amazon Bedrock で [1M トークンコンテキストウィンドウ](https://platform.claude.com/docs/ja/build-with-claude/context-windows#1m-token-context-window)をサポートしています。Sonnet 5 は [Mantle エンドポイント](#use-the-mantle-endpoint)を通じて提供され、常に 1M ウィンドウで実行されます。選択する `[1m]` バリアントはありません。その他のモデルについては、Claude Code は 1M モデルバリアントを選択すると、拡張コンテキストウィンドウを自動的に有効にします。
 
-[セットアップウィザード](#sign-in-with-bedrock)は、モデルをピン留めするときに 1M コンテキストオプションを提供します。手動でピン留めされたモデルの代わりに有効にするには、モデル ID に `[1m]` を追加します。詳細については、[Pin models for third-party deployments](/ja/model-config#pin-models-for-third-party-deployments) を参照してください。
+[セットアップウィザード](#sign-in-with-bedrock)は、モデルをピン留めするときに 1M コンテキストオプションを提供します。手動でピン留めされたモデルの代わりに有効にするには、モデル ID に `[1m]` を追加します。詳細については、[サードパーティデプロイメント用のモデルをピン留めする](/ja/model-config#pin-models-for-third-party-deployments)を参照してください。
 
 <h2 id="service-tiers">
@@ -431,5 +431,5 @@ Claude Code は、各リクエストで `X-Amzn-Bedrock-Service-Tier` ヘッダ
 
 <h2 id="use-the-mantle-endpoint">
-  Mantle エンドポイントを使用
+  Mantle エンドポイントを使用する
 </h2>
 
@@ -456,8 +456,8 @@ Claude Code 内で `/status` を実行して確認します。Mantle がアク
 
 <h3 id="select-a-mantle-model">
-  Mantle モデルを選択
+  Mantle モデルを選択する
 </h3>
 
-Mantle は `anthropic.` で始まり、バージョンサフィックスのないモデル ID を使用します。例えば `anthropic.claude-haiku-4-5`。アカウントで利用可能なモデルは、組織に付与されたものに依存します。追加のモデル ID は AWS からのオンボーディング資料に記載されています。AWS アカウントチームに連絡して、許可リストされたモデルへのアクセスをリクエストしてください。
+Mantle は `anthropic.` で始まり、バージョンサフィックスのないモデル ID を使用します。例えば `anthropic.claude-sonnet-5` または `anthropic.claude-haiku-4-5` です。アカウントで利用可能なモデルは、組織に付与されたものに依存します。追加のモデル ID は AWS からのオンボーディング資料に記載されています。AWS アカウントチームに連絡して、許可リストされたモデルへのアクセスをリクエストしてください。
```

</details>

<details>
<summary>authentication-ja.md</summary>

```diff
diff --git a/docs-ja/pages/authentication-ja.md b/docs-ja/pages/authentication-ja.md
index 6810308..3306636 100644
--- a/docs-ja/pages/authentication-ja.md
+++ b/docs-ja/pages/authentication-ja.md
@@ -25,4 +25,5 @@ Claude Code は、セットアップに応じて複数の認証方法をサポ
 * **Claude Console**: Console 認証情報でログインします。管理者が事前に[招待](#claude-console-authentication)している必要があります。
 * **クラウドプロバイダー**: 組織が [Amazon Bedrock](/ja/amazon-bedrock)、[Google Vertex AI](/ja/google-vertex-ai)、または [Microsoft Foundry](/ja/microsoft-foundry) を使用している場合は、`claude` を実行する前に必要な環境変数を設定してください。ブラウザログインは不要です。
+* **クラウドゲートウェイ**: 組織がセルフホストされた [Claude apps gateway](/ja/claude-apps-gateway) を実行している場合は、`/login` を通じて企業 SSO でサインインします。ゲートウェイが発行したトークンはセッションの唯一の認証情報です。
 
 ログアウトして再認証するには、Claude Code プロンプトで `/logout` と入力します。
@@ -38,4 +39,5 @@ Claude Code は、セットアップに応じて複数の認証方法をサポ
 * [Claude for Teams または Enterprise](#claude-for-teams-or-enterprise)（ほとんどのチームに推奨）
 * [Claude Console](#claude-console-authentication)
+* [Claude apps gateway](/ja/claude-apps-gateway)（開発者を IdP でサインインさせ、設定したクラウドプロバイダーに推論をルーティングする自己ホスト型ゲートウェイ）
 * [Amazon Bedrock](/ja/amazon-bedrock)
 * [Google Vertex AI](/ja/google-vertex-ai)
@@ -132,5 +134,5 @@ Claude Code は認証情報を安全に管理します。
   * Linux または Windows で `CLAUDE_CONFIG_DIR` 環境変数を設定している場合、`.credentials.json` ファイルはそのディレクトリの下に配置されます。
   * Claude Code は `/login` と `/logout` を通じて `.credentials.json` を管理します。リクエストをカスタム API エンドポイント経由でルーティングするには、代わりに [`ANTHROPIC_BASE_URL`](/ja/env-vars) 環境変数を設定してください。
-* **サポートされている認証タイプ**: Claude.ai 認証情報、Claude API 認証情報、Azure Auth、Bedrock Auth、および Vertex Auth。
+* **サポートされている認証タイプ**: Claude.ai 認証情報、Claude API 認証情報、Azure Auth、Bedrock Auth、Vertex Auth、および [Claude apps gateway](/ja/claude-apps-gateway) セッショントークン。
 * **カスタム認証情報スクリプト**: [`apiKeyHelper`](/ja/settings#available-settings) 設定は、API キーを返すシェルスクリプトを実行するように設定できます。
 * **更新間隔**: デフォルトでは、`apiKeyHelper` は 5 分後または HTTP 401 レスポンス時に呼び出されます。カスタム更新間隔の場合は、`CLAUDE_CODE_API_KEY_HELPER_TTL_MS` 環境変数を設定してください。
@@ -152,4 +154,6 @@ Claude Code は認証情報を安全に管理します。
 6. `/login` からのサブスクリプション OAuth 認証情報。これは Claude Pro、Max、Team、および Enterprise ユーザーのデフォルトです。
 
+署名済みの [Claude apps gateway](/ja/claude-apps-gateway) セッションはこのリストの外に位置します。これは Bedrock または Vertex のようなプロバイダー選択であり、それらより優先されます。ゲートウェイセッションが存在する場合、CLI は `CLAUDE_CODE_USE_BEDROCK`、`CLAUDE_CODE_USE_VERTEX`、または `CLAUDE_CODE_USE_FOUNDRY` が設定されていても、ゲートウェイトークンで認証され、上記のベアラートークン、API キー、および `apiKeyHelper` エントリは使用されません。
+
 アクティブな Claude サブスクリプションがあり、環境に `ANTHROPIC_API_KEY` も設定されている場合、API キーは承認されると優先されます。キーが無効または期限切れの組織に属している場合、これは認証エラーを引き起こす可能性があります。`unset ANTHROPIC_API_KEY` を実行してサブスクリプションにフォールバックし、`/status` をチェックしてどの方法がアクティブであるかを確認します。
 
```

</details>

<details>
<summary>auto-mode-config-ja.md</summary>

```diff
diff --git a/docs-ja/pages/auto-mode-config-ja.md b/docs-ja/pages/auto-mode-config-ja.md
index 2fd488c..ca66c7c 100644
--- a/docs-ja/pages/auto-mode-config-ja.md
+++ b/docs-ja/pages/auto-mode-config-ja.md
@@ -10,5 +10,5 @@
 
 <Note>
-  オートモードは、Anthropic API を通じてすべてのユーザーが利用できます。Amazon Bedrock、Google Cloud Vertex AI、Microsoft Foundry では、まず [`CLAUDE_CODE_ENABLE_AUTO_MODE`](/ja/permission-modes#enable-auto-mode-on-bedrock-vertex-ai-or-foundry) を[設定](/ja/permission-modes#enable-auto-mode-on-bedrock-vertex-ai-or-foundry)する必要があります。Claude Code がアカウントでオートモードが利用不可と報告する場合は、[完全な要件](/ja/permission-modes#eliminate-prompts-with-auto-mode)を確認してください。これには、サポートされているモデルと Team および Enterprise プランの管理者有効化も含まれます。
+  オートモードは、Anthropic API を通じてすべてのユーザーが利用できます。Amazon Bedrock、Google Cloud Vertex AI、Microsoft Foundry、およびサインイン済みの[Claude アプリゲートウェイ](/ja/claude-apps-gateway)セッションでは、まず [`CLAUDE_CODE_ENABLE_AUTO_MODE`](/ja/permission-modes#enable-auto-mode-on-bedrock-vertex-ai-or-foundry) を[設定](/ja/permission-modes#enable-auto-mode-on-bedrock-vertex-ai-or-foundry)する必要があります。Claude Code がアカウントでオートモードが利用不可と報告する場合は、[完全な要件](/ja/permission-modes#eliminate-prompts-with-auto-mode)を確認してください。これには、サポートされているモデルと Team および Enterprise プランの Owner 有効化も含まれます。
 </Note>
 
@@ -22,4 +22,5 @@
 * [`autoMode.environment` で信頼できるインフラストラクチャを定義する](#define-trusted-infrastructure)
 * [デフォルトが適切でない場合、ブロックルールと許可ルールをオーバーライドする](#override-the-block-and-allow-rules)
+* [`autoMode.classifyAllShell` ですべてのシェルコマンドを分類器にルーティングする](#route-all-shell-commands-through-the-classifier)
 * [`claude auto-mode` サブコマンドで有効な設定を確認する](#inspect-the-defaults-and-your-effective-config)
 * [拒否を確認する](#review-denials)（次に何を追加するかを知るため）
@@ -54,5 +55,14 @@
 ほとんどの組織では、`autoMode.environment` が設定する必要がある唯一のフィールドです。これは、分類器に、どのリポジトリ、バケット、ドメインが信頼できるかを指定します。分類器はこれを使用して「外部」が何を意味するかを決定するため、リストに記載されていない宛先は潜在的な流出ターゲットです。
 
-デフォルトの環境リストは、作業リポジトリとその設定されたリモートを信頼します。そのデフォルトと一緒に独自のエントリを追加するには、配列にリテラル文字列 `"$defaults"` を含めます。デフォルトエントリはその位置に挿入されるため、カスタムエントリはそれらの前後に配置できます。
+Claude Code v2.1.195 以降、`claude auto-mode defaults` は 2 種類の環境エントリを出力します。
+
+* **信頼スロット**：分類器が境界内として扱うものを指定します。スロットは「信頼できるリポジトリ」、「ソース管理」、「信頼できる内部ドメイン」、「信頼できるクラウドバケット」、「主要な内部サービス」、および「内部パッケージレジストリ」です。リポジトリとソース管理エントリはデフォルトで作業リポジトリとその設定されたリモートになります。他のすべての信頼スロットはデフォルトで `None configured` になるため、追加するまで他には何も信頼されません。
+* **感度スロット**：保護ルールが高リスクとして扱うものを指定します。スロットは「PII / 規制対象データの場所」、「機密リモートターゲット」、および「保護された IaC スコープ」です。各スロットはデフォルトで広いヒューリスティックになります。例えば、名前に `prod` または `production` を含むホストまたはネームスペースを機密リモートターゲットとして扱うため、保護ルールは何も設定する前にアクティブになります。感度スロットで具体的なターゲットを指定すると、これらのルールはヒューリスティックではなく指定されたターゲットに適用されます。
+
+v2.1.195 より前のバージョンは、最初の 5 つの信頼スロットのみを出力します。
+
+デフォルトと一緒に独自のエントリを追加するには、配列にリテラル文字列 `"$defaults"` を含めます。デフォルトエントリはその位置に挿入されるため、カスタムエントリはそれらの前後に配置できます。
+
```

</details>

*...以降省略*

</details>


<details>
<summary>2026-06-30</summary>

**変更ファイル:**

```
 docs-ja/pages/changelog.md      | 30 ++++++++++++++++++++++++++++++
 docs-ja/pages/llm-gateway-ja.md |  2 +-
 2 files changed, 31 insertions(+), 1 deletion(-)
```

**新規追加:**


<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index 3fa4a5d..8152155 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,34 @@
 # Changelog
 
+## 2.1.196
+
+- Added support for organization default models — admins set it in the org console; it shows as "Org default" (or "Role default") in `/model` when you haven't picked one yourself
+- Added readable default names for sessions at start, making them easier to identify and message
+- Added clickable file attachments in chat — Cmd/Ctrl-click reveals the file in Finder/Explorer
+- Security: `claude mcp list`/`get` no longer spawn `.mcp.json` servers that a repo self-approved via a committed `.claude/settings.json`; untrusted workspaces show `⏸ Pending approval`
+- Fixed waking a background job permanently deleting its conversation and re-running the original prompt when the transcript probe misread a real transcript; the file is now set aside, never deleted
+- Fixed the rate-limit warning flickering off and rate-limit telemetry being over-counted when multiple parallel requests were in flight at the moment a usage limit was hit
+- Fixed duplicate recap lines after a background session's turn: a schema-rejected StructuredOutput attempt no longer renders alongside its retry
+- Fixed PowerShell `git diff`/`git grep`, `egrep`/`fgrep`, and quoted search patterns containing `|` being reported as failures when they exit 1, matching Bash behavior
+- Fixed multiple `claude agents` side panel issues: keyboard focus getting stuck when opening an agent, background jobs losing their subagent types on every open, and sessions showing incorrect status while actively running
+- Fixed `claude agents --dangerously-skip-permissions` silently falling back to auto mode instead of showing the bypass disclaimer and applying bypass mode to spawned agents
+- Fixed mid-turn crash recovery for Remote sessions — sessions interrupted by a server restart now auto-resume on the next worker
+- Fixed sessions moved with `/cd` reappearing in the old directory's resume list after a non-graceful exit when the old path contained special characters
+- Fixed `claude plugin validate` skipping local plugins whose source is "." and stopping after the first error class
+- Fixed Esc Esc at an idle prompt not opening the rewind menu (regression); use Ctrl+C or Ctrl+X Ctrl+K to stop background agents
+- Fixed MCP OAuth requesting the authorization server's full `scopes_supported` catalog when no scope is specified, causing `invalid_scope` failures on GitLab self-hosted and other enterprise IdPs
+- Fixed `/context` showing 0 tokens for all tool groups on Bedrock
+- Fixed `/deep-research` misreporting verifier failures as "all claims refuted" instead of `unverified`
+- Fixed plugin dependency version pins not being honored when the marketplace was added as a local folder path backed by a git repo
+- Fixed `claude agents` session status: completed rows no longer flip between "Done" and "Needs your input", stalled agents are now labeled "Needs attention", and results that mention a PR show a clickable link
+- Fixed voice dictation swallowing spaces and spuriously starting a recording during very fast typing when voice mode is enabled
+- Improved background session reliability: long-running commands and workflows now survive the session's process being stopped, restarted, or updated — including on Windows, where background shells are handed off instead of being killed
```

</details>

<details>
<summary>llm-gateway-ja.md</summary>

```diff
diff --git a/docs-ja/pages/llm-gateway-ja.md b/docs-ja/pages/llm-gateway-ja.md
index cb3e944..aaa9867 100644
--- a/docs-ja/pages/llm-gateway-ja.md
+++ b/docs-ja/pages/llm-gateway-ja.md
@@ -40,5 +40,5 @@ LLM gateway は、Claude Code とモデルプロバイダー間に組織が実
 
 <Frame>
-  <img src="https://mintcdn.com/claude-code/zIcIE_SQv4Z0Zbhc/images/llm-gateway-flow.svg?fit=max&auto=format&n=zIcIE_SQv4Z0Zbhc&q=85&s=490607d033d235694efb49a73a5b9e4b" alt="Claude Code が LLM gateway 経由でルーティングされることを示す図。開発者マシンゾーンでは、Claude Code CLI、VS Code 拡張機能、CI またはエージェント SDK クライアントがゲートウェイにリクエストを送信し、ゲートウェイの API 形式のベース URL 変数がそれを指し、各開発者が開発者ごとの認証情報を保持し、デスクトップアプリは組織が配布した設定を通じて同じゲートウェイに到達します。あなたのインフラストラクチャというラベルが付いたゾーンでは、LLM gateway が認証、使用状況追跡、予算、ルーティングを処理し、組織の認証情報を使用してリクエストを転送します。モデルプロバイダーゾーンでは、実線矢印が設定したプロバイダー（Anthropic API として表示）に向かい、破線矢印が他のプロバイダーオプション（Amazon Bedrock、Google Vertex AI、Microsoft Foundry の例として示されている）に向かいます。" width="780" height="322" data-path="images/llm-gateway-flow.svg" />
+  <img src="https://mintcdn.com/claude-code/-uq-4JE0W_JO5Er5/images/llm-gateway-flow.svg?fit=max&auto=format&n=-uq-4JE0W_JO5Er5&q=85&s=1c1a8dcc0cfcc3a58652cc8e28cd3e20" alt="Claude Code が LLM gateway 経由でルーティングされることを示す図。開発者マシンゾーンでは、Claude Code CLI、VS Code 拡張機能、CI またはエージェント SDK クライアントがゲートウェイにリクエストを送信し、ゲートウェイの API 形式のベース URL 変数がそれを指し、各開発者が開発者ごとの認証情報を保持し、デスクトップアプリは組織が配布した設定を通じて同じゲートウェイに到達します。あなたのインフラストラクチャというラベルが付いたゾーンでは、LLM gateway が認証、使用状況追跡、予算、ルーティングを処理し、組織の認証情報を使用してリクエストを転送します。モデルプロバイダーゾーンでは、実線矢印が設定したプロバイダー（Anthropic API として表示）に向かい、破線矢印が他のプロバイダーオプション（Amazon Bedrock、Google Vertex AI、Microsoft Foundry の例として示されている）に向かいます。" width="780" height="322" data-path="images/llm-gateway-flow.svg" />
 </Frame>
 
```

</details>

</details>


<details>
<summary>2026-06-27</summary>

**変更ファイル:**

```
 docs-ja/pages/agent-teams-ja.md          |  7 ---
 docs-ja/pages/artifacts-ja.md            |  9 ----
 docs-ja/pages/changelog.md               | 15 +++++++
 docs-ja/pages/channels-ja.md             | 10 +----
 docs-ja/pages/devcontainer-ja.md         |  7 +--
 docs-ja/pages/env-vars-ja.md             |  2 +-
 docs-ja/pages/fast-mode-ja.md            | 18 ++++----
 docs-ja/pages/fullscreen-ja.md           |  2 +-
 docs-ja/pages/goal-ja.md                 |  7 ---
 docs-ja/pages/llm-gateway-ja.md          | 14 ++----
 docs-ja/pages/sandbox-environments-ja.md |  7 +--
 docs-ja/pages/sandboxing-ja.md           |  7 ---
 docs-ja/pages/sessions-ja.md             | 40 +++++++++++++----
 docs-ja/pages/settings-ja.md             | 73 ++++++++++++++++----------------
 docs-ja/pages/sub-agents-ja.md           |  9 +---
 docs-ja/pages/workflows-ja.md            |  7 ---
 16 files changed, 99 insertions(+), 135 deletions(-)
```

<details>
<summary>agent-teams-ja.md</summary>

```diff
diff --git a/docs-ja/pages/agent-teams-ja.md b/docs-ja/pages/agent-teams-ja.md
index 87f5a87..544d62a 100644
--- a/docs-ja/pages/agent-teams-ja.md
+++ b/docs-ja/pages/agent-teams-ja.md
@@ -19,11 +19,4 @@
 </Note>
 
-このページでは、以下について説明します。
-
-* [エージェントチームを使用する場合](#when-to-use-agent-teams)（ユースケースと subagents との比較を含む）
-* [チームを開始する](#start-your-first-agent-team)
-* [チームメンバーを制御する](#control-your-agent-team)（表示モード、タスク割り当て、委任を含む）
-* [並列作業のベストプラクティス](#best-practices)
-
 <h2 id="when-to-use-agent-teams">
   エージェントチームを使用する場合
```

</details>

<details>
<summary>artifacts-ja.md</summary>

```diff
diff --git a/docs-ja/pages/artifacts-ja.md b/docs-ja/pages/artifacts-ja.md
index 46a22fc..10fb365 100644
--- a/docs-ja/pages/artifacts-ja.md
+++ b/docs-ja/pages/artifacts-ja.md
@@ -19,13 +19,4 @@
 </Frame>
 
-このページでは、以下の内容について説明します。
-
-* [アーティファクトを使用する時期](#when-to-use-an-artifact)を判断する
-* アーティファクトを[作成](#create-an-artifact)、[更新](#update-an-artifact)、[共有](#share-an-artifact)する
-* より豊かなページのための[プロンプティングパターン](#what-you-can-build)を適用する
-* [ビジュアルデザインを改善](#improve-the-visual-design)して、アーティファクトが製品のブランディングと一致するようにする
-* [ページの制約](#page-constraints)と[利用可能性の要件](#availability)を理解する
-* アーティファクトを[無効にする](#disable-artifacts)か、[組織のアーティファクトを管理](#manage-artifacts-for-your-organization)する
-
 <h2 id="when-to-use-an-artifact">
   アーティファクトを使用する時期
```

</details>

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index 534a987..3fa4a5d 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,19 @@
 # Changelog
 
+## 2.1.195
+
+- Added `CLAUDE_CODE_DISABLE_MOUSE_CLICKS` to disable mouse click/drag/hover in fullscreen mode while keeping wheel scroll
+- Fixed hook matchers with hyphenated identifiers (e.g. `code-reviewer`, `mcp__brave-search`) accidentally substring-matching — they now exact-match. Use `mcp__brave-search__.*` to match all tools from a hyphenated MCP server.
+- Fixed voice dictation on macOS capturing silence in long-running sessions after the default input device changes
+- Fixed voice dictation auto-submit never firing for languages written without spaces (Japanese, Chinese, Thai)
+- Fixed external plugins enabled only by project `.claude/settings.json` not requiring explicit install consent on every loader path
+- Fixed `/plugin` Enable/Disable not working when a plugin's `plugin.json` `name` differs from its marketplace entry name
+- Fixed background jobs disappearing from `claude agents` or losing data when written by a newer Claude Code version
+- Fixed reopening a crashed background task showing a blank screen for up to 5 seconds instead of its restart
+- Fixed background agent daemons running unreachable when the control socket fails to start, blocking restarts
+- Improved voice mode on Linux: now distinguishes "no microphone" from "SoX not installed" when SoX is present but no audio capture device exists
+- Improved `claude agents` completed list to fill available vertical space; on short terminals the header compacts so live sessions stay visible
+- Improved Remote session startup with a provisioning checklist while the container starts
+
 ## 2.1.193
 
```

</details>

<!-- UPDATE_LOG_END -->
