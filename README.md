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
<summary>2026-11-11</summary>

**変更ファイル:**

```
 docs-ja/pages/admin-setup-ja.md                    |   2 +-
 docs-ja/pages/advisor-ja.md                        |   9 +-
 docs-ja/pages/agent-view-ja.md                     |   4 +-
 docs-ja/pages/amazon-bedrock-ja.md                 |   4 +-
 docs-ja/pages/artifacts-ja.md                      |  21 +-
 docs-ja/pages/auto-mode-classifier-billing-ja.md   |   2 +-
 docs-ja/pages/auto-mode-config-ja.md               |   8 +-
 docs-ja/pages/channels-reference-ja.md             |   2 +-
 docs-ja/pages/claude-apps-gateway-config-ja.md     |   8 +-
 docs-ja/pages/claude-apps-gateway-deploy-ja.md     |   4 +-
 docs-ja/pages/claude-apps-gateway-ja.md            | 224 ++---
 .../pages/claude-apps-gateway-spend-limits-ja.md   |   2 +-
 docs-ja/pages/claude-code-on-the-web-ja.md         |   7 +-
 docs-ja/pages/claude-directory-ja.md               |   9 +-
 docs-ja/pages/claude-platform-on-aws-ja.md         |   4 +-
 docs-ja/pages/claude-projects-ja.md                |  50 +-
 docs-ja/pages/claude-security-ja.md                |   8 +-
 docs-ja/pages/cloud-environments-ja.md             |  32 +-
 docs-ja/pages/code-review-local-ja.md              |   4 +-
 docs-ja/pages/commands-ja.md                       |   4 +-
 docs-ja/pages/costs-ja.md                          |  12 +-
 docs-ja/pages/desktop-ios-simulator-ja.md          |   4 +-
 docs-ja/pages/desktop-ja.md                        |   4 +-
 docs-ja/pages/env-vars-ja.md                       |  19 +-
 docs-ja/pages/errors-ja.md                         | 897 ++++++++++++---------
 docs-ja/pages/fast-mode-ja.md                      |  58 +-
 docs-ja/pages/feature-availability-ja.md           |  13 +-
 docs-ja/pages/gateways-ja.md                       |   2 +-
 docs-ja/pages/github-enterprise-server-ja.md       |   2 +-
 docs-ja/pages/goal-ja.md                           |   3 +-
 docs-ja/pages/google-vertex-ai-ja.md               |   4 +-
 docs-ja/pages/hooks-ja.md                          |  32 +-
 docs-ja/pages/interactive-mode-ja.md               |   4 +-
 docs-ja/pages/keybindings-ja.md                    | 372 ++++-----
 docs-ja/pages/large-codebases-ja.md                |   2 +-
 docs-ja/pages/llm-gateway-connect-ja.md            |   4 +-
 docs-ja/pages/llm-gateway-ja.md                    |   2 +-
 docs-ja/pages/llm-gateway-protocol-ja.md           |   6 +-
 docs-ja/pages/llm-gateway-rollout-ja.md            |   2 +-
 docs-ja/pages/managed-mcp-ja.md                    |   2 +-
 docs-ja/pages/managed-settings-ja.md               |   2 +-
 docs-ja/pages/mcp-ja.md                            | 524 ++++++------
 docs-ja/pages/memory-ja.md                         |   2 +-
 docs-ja/pages/model-config-ja.md                   |   4 +-
 docs-ja/pages/monitoring-usage-ja.md               | 721 +++++++++--------
 docs-ja/pages/permission-modes-ja.md               |   8 +-
 docs-ja/pages/permissions-ja.md                    |   2 +
 docs-ja/pages/prompt-caching-ja.md                 |   2 +-
 docs-ja/pages/quickstart-ja.md                     |  12 +-
 docs-ja/pages/remote-control-ja.md                 |  19 +-
 docs-ja/pages/routines-ja.md                       |  10 +-
 docs-ja/pages/sandbox-environments-ja.md           |   5 +-
 docs-ja/pages/sandboxing-ja.md                     |   2 +-
 docs-ja/pages/scheduled-tasks-ja.md                |   6 +-
 docs-ja/pages/security-guidance-ja.md              |   6 +-
 .../self-hosted-environments-configuration-ja.md   |   4 +-
 .../pages/self-hosted-environments-deploy-ja.md    |   8 +-
 .../pages/self-hosted-environments-reference-ja.md | 224 ++---
 .../pages/self-hosted-environments-testing-ja.md   |   2 +-
 docs-ja/pages/server-managed-settings-ja.md        |  51 +-
 docs-ja/pages/settings-example-ja.md               |  55 +-
 docs-ja/pages/settings-ja.md                       |   4 +-
 docs-ja/pages/terminal-config-ja.md                |  24 +-
 docs-ja/pages/troubleshoot-install-ja.md           |  20 +-
 docs-ja/pages/web-quickstart-ja.md                 |   8 +-
 docs-ja/pages/workflows-ja.md                      |  14 +-
 docs-ja/pages/zero-data-retention-ja.md            |   6 +-
 67 files changed, 1952 insertions(+), 1645 deletions(-)
```

<details>
<summary>admin-setup-ja.md</summary>

```diff
diff --git a/docs-ja/pages/admin-setup-ja.md b/docs-ja/pages/admin-setup-ja.md
index 591a80b..1571287 100644
--- a/docs-ja/pages/admin-setup-ja.md
+++ b/docs-ja/pages/admin-setup-ja.md
@@ -97,5 +97,5 @@ WSL 2 ユーティリティ VM 内のプロセスは、Windows 側のエンド
 | [MCP サーバーの制御](https://code.claude.com/docs/ja/managed-mcp.md) | ユーザーが追加または接続できる MCP サーバーを制限したり、固定のセットをデプロイしたり、各ユーザー自身のサーバーに加えてリモートサーバーを全ユーザーに提供したりします | `allowedMcpServers`、`deniedMcpServers`、`allowManagedMcpServersOnly`、`managedMcpServers`、またはデプロイされた `managed-mcp.json` ファイル |
 | [プラグインマーケットプレイスの制御](https://code.claude.com/docs/ja/plugins/org.md#restrict-what-users-can-install) | ユーザーが追加およびインストールできるマーケットプレイスソースを制限し、単一の実行のためにプラグイン、エージェント、MCP サーバーをサイドロードする CLI フラグを拒否します。[`command` プラグインソース](https://code.claude.com/docs/ja/plugins/marketplace-reference#command-plugin-source)をブロックし、ターミナルでどのマーケットプレイスのプラグインを提案できるかを許可リストで指定します | `strictKnownMarketplaces`、`blockedMarketplaces`、`disableSideloadFlags`、`disableCommandPluginSources`、`pluginSuggestionMarketplaces` |
-| [カスタマイズのロックダウン](https://code.claude.com/docs/ja/settings-reference.md#strictpluginonlycustomization) | ユーザーおよびプロジェクトのソースからのスキル、エージェント、フック、MCP サーバーをブロックし、プラグインまたは管理設定からのみ提供されるようにします。スキルをロックすると、[開発者が claude.ai で有効にしたスキル](https://code.claude.com/docs/ja/skills.md#where-synced-skills-load)の同期も停止します | `strictPluginOnlyCustomization` |
+| [カスタマイズのロックダウン](https://code.claude.com/docs/ja/settings-reference.md#strictpluginonlycustomization) | ユーザーおよびプロジェクトのソースからのスキル、エージェント、フック、MCP サーバーをブロックします。スキルをロックすると、[開発者が claude.ai で有効にしたスキル](https://code.claude.com/docs/ja/skills.md#where-synced-skills-load)の同期も停止します | `strictPluginOnlyCustomization` |
 | [claude.ai 同期の無効化](https://code.claude.com/docs/ja/settings-reference.md#syncclaudeaiskills) | 開発者が claude.ai で有効にした[スキル](https://code.claude.com/docs/ja/skills.md#how-synced-skills-behave)と[プラグイン](https://code.claude.com/docs/ja/plugins/loading.md#synced-plugins)を Claude Code が読み込まないようにします。claude.ai で組織の Skills をオフにすると、Claude Code は両方の同期を停止し、v2.1.273 以降では同期済みのものも削除します。Skills をオフにせずにいずれかを停止するには、管理設定でそのキーを `false` に設定します | `syncClaudeAiSkills`、`syncClaudeAiPlugins` |
 | [フックの制限](https://code.claude.com/docs/ja/settings-reference.md#allowmanagedhooksonly) | 実行するフックと HTTP フックの URL を制限します。影響の全一覧は [`allowManagedHooksOnly` で実行されるもの](https://code.claude.com/docs/ja/settings-reference#what-runs-under-allowmanagedhooksonly)を参照してください | `allowManagedHooksOnly`、`allowedHttpHookUrls` |
```

</details>

<details>
<summary>advisor-ja.md</summary>

```diff
diff --git a/docs-ja/pages/advisor-ja.md b/docs-ja/pages/advisor-ja.md
index 40d9f33..c44ff56 100644
--- a/docs-ja/pages/advisor-ja.md
+++ b/docs-ja/pages/advisor-ja.md
@@ -9,5 +9,5 @@
 > [!NOTE]
 >
-> advisor ツールは実験的機能であり、Anthropic API が必要です。Amazon Bedrock、Claude Platform on AWS、Google Cloud の Agent Platform、Microsoft Foundry では利用できません。動作、価格設定、および利用可能性は変更される可能性があります。
+> advisor ツールは実験的機能であり、Anthropic API または [Claude Platform on AWS](https://code.claude.com/docs/ja/claude-platform-on-aws.md) が必要です。Claude Platform on AWS では、Claude Code v2.1.300 以降が必要です。Amazon Bedrock、Google Cloud の Agent Platform、Microsoft Foundry では利用できません。動作、価格設定、および利用可能性は変更される可能性があります。
 
 advisor ツールを使用すると、Claude はタスク中の重要な瞬間（アプローチをコミットする前、繰り返し発生するエラーで行き詰まった場合、またはタスク完了を宣言する前など）に、通常はより強力な 2 番目のモデルに相談できます。advisor は、すべてのツール呼び出しと結果を含む完全な会話を受け取り、Claude が続行する前に適用するガイダンスを返します。
@@ -175,9 +175,8 @@ advisor モデル自体の会話の読み取りはキャッシュされません
 ## 要件
 
-advisor ツールには、以下のすべてが必要です。
-
-* **Anthropic API のみ**：advisor はサーバー実行ツールです。Amazon Bedrock、Claude Platform on AWS、Google Cloud の Agent Platform、または Microsoft Foundry では利用できません。[LLM ゲートウェイ](https://code.claude.com/docs/ja/llm-gateway)を通じて `ANTHROPIC_BASE_URL` で構成されている場合、利用可能性はゲートウェイがリクエストを Anthropic API に完全に転送するかどうかに依存します。ゲートウェイまたはそのアップストリームが advisor ツールを認識しない場合は、[自動リトライとエラー転送](https://code.claude.com/docs/ja/llm-gateway-protocol.md#automatic-retry-and-error-forwarding)を参照して、Claude Code がどのように応答するかを確認してください。
+* **プロバイダー**：Anthropic API または [Claude Platform on AWS](https://code.claude.com/docs/ja/claude-platform-on-aws.md)。Amazon Bedrock、Google Cloud の Agent Platform、Microsoft Foundry では利用できません。Claude Platform on AWS では、advisor を使用するには Claude Code v2.1.300 以降が必要です。
+* **LLM ゲートウェイ**：`ANTHROPIC_BASE_URL` で構成された [LLM ゲートウェイ](https://code.claude.com/docs/ja/llm-gateway)を経由する場合、利用可能性はゲートウェイがリクエストを Anthropic API にそのまま転送するかどうかに依存します。ゲートウェイまたはそのアップストリームが advisor ツールを認識しない場合に Claude Code がどのように応答するかについては、[自動再試行とエラー転送](https://code.claude.com/docs/ja/llm-gateway-protocol.md#automatic-retry-and-error-forwarding)を参照してください。
 * **サポートされているメインモデル**：Fable、Opus 4.6 以降、Sonnet 4.6 以降、Haiku 4.5、または Haiku 5.5。各メインモデルがどの advisor を受け入れるかについては、[advisor モデルを選択する](#choose-an-advisor-model)を参照してください。
-* **フィーチャーフラグ取得**：Claude Code は Anthropic から取得するフィーチャーフラグを通じて advisor をオンにします。`DISABLE_TELEMETRY` など、フラグ取得をオフにする変数が設定されているセッションでは、advisor はオフのままです。[フィーチャーフラグ取得が必要な機能](https://code.claude.com/docs/ja/env-vars.md#features-that-need-feature-flag-fetching)を参照してください。
+* **フィーチャーフラグ取得**：Claude Platform on AWS を使用している場合を除き、advisor には Anthropic から取得するフィーチャーフラグが必要です。`DISABLE_TELEMETRY` など、取得をオフにする変数が設定されているセッションには、そのフラグがありません。セッションを確認するには、[取得をスキップするセッション、またはフラグなしで開始するセッション](https://code.claude.com/docs/ja/env-vars.md#features-that-need-feature-flag-fetching)を参照してください。
 
 ## advisor をオフにする
```

</details>

<details>
<summary>agent-view-ja.md</summary>

```diff
diff --git a/docs-ja/pages/agent-view-ja.md b/docs-ja/pages/agent-view-ja.md
index eb7640f..d980ea1 100644
--- a/docs-ja/pages/agent-view-ja.md
+++ b/docs-ja/pages/agent-view-ja.md
@@ -170,5 +170,7 @@ Completed
 リストが [ディレクトリでグループ化](#organize-the-list) されている場合、概要はセッションの状態を示す色付きの単語で始まります。例えば `Needs input · double jump or wall climb?` のようになります。デフォルトの状態グループ化では、グループヘッダーがすでに状態を示しているため、行は概要のみを表示します。
 
-ターン終了時の概要と各ターン途中の書き直しは、通常のプロバイダーを通じた 1 回の短い Haiku クラスリクエストであり、セッション自体と同じ [データ使用条件](https://code.claude.com/docs/ja/data-usage.md) の下で課金および処理されます。モデルによる書き直しの間の 15 秒ごとの更新はセッション自身の出力を再利用し、リクエストを送信しません。Haiku クラスモデルが設定されていないサードパーティプロバイダーまたはゲートウェイでは、リクエストは代わりにセッションのメインモデルを使用します。モデルを選択するには [`ANTHROPIC_DEFAULT_HAIKU_MODEL`](https://code.claude.com/docs/ja/model-config#environment-variables) を設定します。
+#### 行の概要のコスト
+
+ターン終了時の概要と各ターン途中の書き直しは、通常のプロバイダーを通じた 1 回の短いリクエストであり、セッション自体と同じ [データ使用条件](https://code.claude.com/docs/ja/data-usage.md) の下で課金および処理されます。サードパーティプロバイダーまたはゲートウェイでは、概要は [`ANTHROPIC_DEFAULT_HAIKU_MODEL`](https://code.claude.com/docs/ja/model-config#environment-variables) で設定したモデルを使用します。これが設定されていない場合は、プロバイダーのバックグラウンドタスク用モデルを使用します。[Amazon Bedrock](https://code.claude.com/docs/ja/amazon-bedrock.md#4-pin-model-versions)、[Google Cloud の Agent Platform](https://code.claude.com/docs/ja/google-vertex-ai.md#5-pin-model-versions)、[Microsoft Foundry](https://code.claude.com/docs/ja/microsoft-foundry.md#4-pin-model-versions)、または [ゲートウェイ](https://code.claude.com/docs/ja/llm-gateway-protocol.md#requests-and-defaults-by-connection-method) を参照してください。
 
 ### プルリクエストステータス
```

</details>

<details>
<summary>amazon-bedrock-ja.md</summary>

```diff
diff --git a/docs-ja/pages/amazon-bedrock-ja.md b/docs-ja/pages/amazon-bedrock-ja.md
index 3a3ffc8..483d241 100644
--- a/docs-ja/pages/amazon-bedrock-ja.md
+++ b/docs-ja/pages/amazon-bedrock-ja.md
@@ -368,5 +368,5 @@ Amazon Bedrock の [Invoke API](https://docs.aws.amazon.com/bedrock/latest/APIRe
 | その他すべてのリージョン | `global.` |
 
-`ANTHROPIC_BEDROCK_REGION_PREFIX` を設定して、Claude Code が最初に試すプレフィックスを選択します。Claude Code がプロファイルの可用性を確認でき、モデルに一致するプロファイルが見つからない場合、以下の解決順序に従ってフォールバックします。有効な値は `us`、`eu`、`apac`、`jp`、`au`、および `global` です。たとえば、アカウントに `global.` プロファイルが有効になっているが、Claude Code が AWS リージョンから地理的に固有のプロファイルを導出する場合は、`global` に設定します。Claude Code v2.1.224 以降が必要です。
+`ANTHROPIC_BEDROCK_REGION_PREFIX` を設定して、Claude Code が最初に試すプレフィックスを選択します。有効な値は `us`、`eu`、`apac`、`jp`、`au`、および `global` です。たとえば、アカウントに `global.` プロファイルが有効になっているが、Claude Code が AWS リージョンから地理的に固有のプロファイルを導出する場合は、`global` に設定します。
 
 この例は、デフォルトモデルを `global.` プロファイルを通じてルーティングします。
@@ -387,5 +387,5 @@ export ANTHROPIC_BEDROCK_REGION_PREFIX=global
 * プロファイル検出が利用できない場合、Claude Code は可用性を確認せずにプレフィックスを適用します。アカウントにそのプレフィックスを持つ推論プロファイルが有効になっていない場合、リクエストは 400 エラーで失敗します。
 
-Claude Code は、自分で設定した Amazon Bedrock 推論プロファイル ID または ARN、または [`modelOverrides`](#map-each-model-version-to-an-inference-profile) 値を書き直しません。Anthropic 形式のモデル ID は [/model ピッカーと同じマッピング](#map-each-model-version-to-an-inference-profile) を通じて解決されます。Claude Code は 2 つのケースで変数を無視します。
+Claude Code は、自分で設定した Amazon Bedrock 推論プロファイル ID または ARN、または [`modelOverrides`](#map-each-model-version-to-an-inference-profile) 値を書き直しません。Anthropic 形式のモデル ID は [`/model` ピッカーと同じマッピング](#map-each-model-version-to-an-inference-profile) を通じて解決されます。Claude Code は次の 2 つのケースでも変数を無視します。
 
 * AWS GovCloud リージョンでは、Claude Code は常に `us-gov.` を使用します。これは GovCloud パーティション内でルーティングする唯一のプレフィックスです。
```

</details>

<details>
<summary>artifacts-ja.md</summary>

```diff
diff --git a/docs-ja/pages/artifacts-ja.md b/docs-ja/pages/artifacts-ja.md
index 99f86d2..c8344e1 100644
--- a/docs-ja/pages/artifacts-ja.md
+++ b/docs-ja/pages/artifacts-ja.md
@@ -65,5 +65,5 @@ Claude が公開できないと応答した場合、またはリンクなしで
 | セッションが [plan モード](https://code.claude.com/docs/ja/permission-modes.md#analyze-before-you-edit-with-plan-mode)になっている | 各アーティファクトの最初の公開前に確認する |
 | 公開が、[コネクタ呼び出し](#pull-live-data-with-mcp-connectors)や[ファイルダウンロード](#offer-a-file-download)など、ページのランタイム機能を宣言している | その公開の前に確認する |
-| アーティファクトを公開共有している | 変更前に会話ごとに 1 回確認する |
+| アーティファクトを公開共有している | 変更前に会話ごとに 1 回確認し、アーティファクトへのコメントに返信する前にも毎回確認する |
 | 入力したプロンプトではなく、セッション内で実行された[セッションスコープのスケジュールタスク](https://code.claude.com/docs/ja/scheduled-tasks.md)によって開始されたターンで Claude が公開する | 各アーティファクトの最初の公開前に確認する |
 | Claude がユーザーの承認なしではファイルを読み取れない | 公開前に確認する。`Artifact` ツールの許可ルールがあっても、このプロンプトはスキップされない |
@@ -90,4 +90,20 @@ https://claude.ai/code/artifact/5fbea6f3-... を本日の数値で更新しま
 ```
 
+### ワンステップのアーティファクト更新をオフにする
+
+ワンステップ更新とは、Claude が `Edit` や `Write` の呼び出しを介さずに、公開処理の一部としてアーティファクトのファイルに加える小さな変更です。
+
+ワンステップ更新をオフにするには、[`CLAUDE_CODE_ARTIFACT_PUBLISH_EDITS`](https://code.claude.com/docs/ja/env-vars) を `0` に設定します。次の例では、`~/.claude/settings.json` の `env` ブロックにこの変数を追加しています。
+
+```json theme={null}
+{
+  "env": {
+    "CLAUDE_CODE_ARTIFACT_PUBLISH_EDITS": "0"
+  }
+}
+```
+
+その後、Claude Code を終了して再起動してください。実行中のセッションは変数を再読み込みしないためです。
+
```

</details>

<details>
<summary>auto-mode-classifier-billing-ja.md</summary>

```diff
diff --git a/docs-ja/pages/auto-mode-classifier-billing-ja.md b/docs-ja/pages/auto-mode-classifier-billing-ja.md
index 7b230e0..9cf94c6 100644
--- a/docs-ja/pages/auto-mode-classifier-billing-ja.md
+++ b/docs-ja/pages/auto-mode-classifier-billing-ja.md
@@ -35,5 +35,5 @@ We're changing auto mode to no longer charge for classifier requests in Claude C
 * **レスポンス**: ゲートウェイは、フィールドをドロップしたり tool-use ID を書き換えたりせずに、レスポンスとストリーミングイベントを返します。チェックの結果を通すために、`safeguard_results` フィールドを保持します。
 
-このようにトラフィックを通すゲートウェイは、この機能と将来の機能で動作し続けます。その後、新しいセッションはサーバーのチェックを再度使用します。
+ゲートウェイがこのように動作するようになると、新しいセッションはサーバーのチェックを再度使用します。
 
 ゲートウェイがサーバーのチェックを提供できないことが既にわかっている場合、セッションを開始する前に、シェルまたは [`env` 設定キー](https://code.claude.com/docs/ja/settings-reference#env)で `CLAUDE_CODE_AUTO_MODE_SERVER` を `0` に設定して、Claude Code にそこでチェックを要求しないよう指示してください。
```

</details>

<details>
<summary>auto-mode-config-ja.md</summary>

```diff
diff --git a/docs-ja/pages/auto-mode-config-ja.md b/docs-ja/pages/auto-mode-config-ja.md
index 64c9a47..4285381 100644
--- a/docs-ja/pages/auto-mode-config-ja.md
+++ b/docs-ja/pages/auto-mode-config-ja.md
@@ -181,5 +181,5 @@ Claude のプッシュおよびプルリクエストコマンドの前に人間
 Claude Code はバックグラウンドでスキャンを行い、その後草案を表示します。草案は全体として承認または破棄するため、個々のエントリを調整するには後で `~/.claude/settings.json` を編集してください。承認すると、Claude Code は草案を書き込み、既存の設定と整合させます。
 
-* Claude Code は `environment` リストを `"$defaults"` なしで書き込みます。草案には、変更されなかった組み込みエントリが明記されているためです
+* `~/.claude/settings.json` の `environment` リストへの追加を選んだ場合、リスト内の `"$defaults"` エントリは保持されます。そのリストの置き換えを選んだ場合はそのエントリが失われるため、デフォルトのエントリが必要な場合は `"$defaults"` を追加し直してください
 * Claude Code は、草案がエントリを追加する `allow`、`soft_deny`、`hard_deny` の各リストに `"$defaults"` を含めます（ただし、`"$defaults"` を含まない `allow` リストをすでに書いている場合を除きます）。これにより、置き換えていない[組み込みルール](#override-the-block-and-allow-rules)が引き続き有効になります
 * 保存後、Claude Code は `~/.claude/settings.json` 内の `permissions.allow` ルールのうち、`Bash(*)` のように auto モードが無視するもの、または破壊的なコマンドを自動承認するものを削除するよう提案します
@@ -217,5 +217,5 @@ Claude Code のプロンプトで `/auto-mode-setup` と入力すると `Unknown
 3 つの追加フィールドを使用すると、分類器の組み込みルールリストを置き換えることができます。
 
-* `autoMode.hard_deny`：無条件のセキュリティ境界
+* `autoMode.hard_deny`：ユーザーが求めた場合でもブロックするアクション
 * `autoMode.soft_deny`：ユーザーの意図でクリアできる破壊的なアクション
 * `autoMode.allow`：ソフトブロックルールの例外
@@ -232,5 +232,5 @@ Claude Code のプロンプトで `/auto-mode-setup` と入力すると `Unknown
 一般的なリクエストは明示的な意図としてカウントされません。Claude に「リポジトリをクリーンアップする」ように依頼することは force push を認可しませんが、「このブランチを force push する」ように依頼することは認可します。
 
-緩和するには、分類器がデフォルトの例外がカバーしていないルーチンパターンを繰り返しフラグする場合、`allow` に追加します。厳しくするには、環境に固有で、デフォルトが見落としているリスクについて `soft_deny` に追加するか、絶対に越えてはいけないセキュリティ境界について `hard_deny` に追加します。
+緩和するには、分類器がデフォルトの例外がカバーしていない日常的なパターンを繰り返し警告する場合、`allow` に追加します。厳しくするには、環境に固有でデフォルトが見落としている破壊的なリスクについて `soft_deny` に追加するか、ユーザーが求めた場合でもブロックするアクションについて `hard_deny` に追加します。
 
 組み込みルールを保持しながら独自のルールを追加するには、配列にリテラル文字列 `"$defaults"` を含めます。デフォルトルールはその位置に挿入されるため、カスタムルールはそれらの前後に配置でき、リリース全体でビルトインリストが変更されるにつれて更新を継続して継承します。
@@ -253,5 +253,5 @@ Claude Code のプロンプトで `/auto-mode-setup` と入力すると `Unknown
       "$defaults",
       "Never run database migrations outside the migrations CLI, even against dev databases",
-      "Never modify files under infra/terraform/prod/: production infrastructure changes go through the review workflow"
+      "Running terraform apply in infra/terraform/prod/ needs an explicit request: production infrastructure changes go through the review workflow"
```

</details>

<details>
<summary>channels-reference-ja.md</summary>

```diff
diff --git a/docs-ja/pages/channels-reference-ja.md b/docs-ja/pages/channels-reference-ja.md
index 1a7f3cd..ef92105 100644
--- a/docs-ja/pages/channels-reference-ja.md
+++ b/docs-ja/pages/channels-reference-ja.md
@@ -323,5 +323,5 @@ instructions: 'Messages arrive as <channel source="webhook" chat_id="...">. Repl
 以下は、双方向サポート付きの完全な `webhook.ts` です。アウトバウンド返信は [Server-Sent Events](https://developer.mozilla.org/en-US/docs/Web/API/Server-sent_events)（SSE）を使用して `GET /events` でストリーミングされるため、`curl -N localhost:8788/events` はそれらをライブで見ることができます。インバウンドチャットは `POST /` に到着します：
 
-```ts title="返信ツール付きの完全な webhook.ts' expandable theme={null}
+```ts title="返信ツール付きの完全な webhook.ts" expandable theme={null}
 #!/usr/bin/env bun
 import { Server } from '@modelcontextprotocol/sdk/server/index.js'
```

</details>

<details>
<summary>claude-apps-gateway-config-ja.md</summary>

```diff
diff --git a/docs-ja/pages/claude-apps-gateway-config-ja.md b/docs-ja/pages/claude-apps-gateway-config-ja.md
index d30d7cd..681492b 100644
--- a/docs-ja/pages/claude-apps-gateway-config-ja.md
+++ b/docs-ja/pages/claude-apps-gateway-config-ja.md
@@ -58,5 +58,9 @@ Claude apps gateway デプロイメントは、慣例的に `gateway.yaml` と
 | `public_url` | `host` がループバックでない場合 | 外部から見える `https://` オリジンで、IdP の `redirect_uri` とディスカバリメタデータの構築に使用されます。`host` がループバックアドレスでない場合は常に必須です。これは、TLS が ALB、Ingress、Cloud Run などのプロキシで終端される場合も、`tls` を通じてゲートウェイ自体で終端される場合も同様です。ゲートウェイは自身のオリジンを `X-Forwarded-*` ヘッダーから導出することがないためです。これらのヘッダーはクライアントが偽装できます。これがないと起動に失敗します。下記の `trusted_proxies` はクライアント IP の解決のみを制御します。また、ゲートウェイはクライアントにプッシュする OTLP エンドポイントをこの URL から構築するため、[テレメトリ](#telemetry)を有効にする場合にも必須です。 |
 | `tls.cert` / `tls.key` | いいえ | ゲートウェイ自体が TLS を終端する場合の PEM パス |
-| `trusted_proxies` | いいえ | ゲートウェイの前段にあるロードバランサーの CIDR または IP。設定すると、ゲートウェイはこれらのピアからの `X-Forwarded-For` のみを信頼し、IP ごとのレート制限と監査のために実際のクライアント IP を記録します。nginx の `set_real_ip_from` に相当します。一部のロードバランサーが行うように `ipv4:port` または `[ipv6]:port` の形式で書かれた `X-Forwarded-For` エントリは、ポートを除いて読み取られます。角括弧なしでポートが付加された IPv6 アドレスは、別のアドレスとして読み取られるか、まったく読み取られない可能性があるため、その形式で書き込むプロキシではポートオプションをオフにしてください。 |
+| `trusted_proxies` | いいえ | 信頼するフロントエンドの CIDR または IP。設定すると、ゲートウェイはこれらのピアからの `X-Forwarded-For` のみを信頼し、IP ごとのレート制限と監査のために実際のクライアント IP を記録します。 |
+
+`trusted_proxies` にフロントエンドを記載するのは、そのフロントエンドが渡す最後の `X-Forwarded-For` エントリが、どの開発者も書き込んでいないものである場合に限ってください。開発者の接続元となるアドレスや範囲は記載しないでください。受信した各接続のアドレスを追記するフロントエンドは条件を満たします。開発者が送信したままの状態でヘッダーを渡すフロントエンドは条件を満たしません。
+
+一部のロードバランサーのように `ipv4:port` または `[ipv6]:port` の形式で書かれた `X-Forwarded-For` エントリは、ポートを除いて読み取られます。角括弧なしでポートが付加された IPv6 アドレスは、別のアドレスとして読み取られるか、まったく読み取られない可能性があります。その形式で書き込むプロキシでは、ポートのオプションをオフにしてください。
 
 ### `oidc`
@@ -1658,5 +1662,5 @@ Claude Code はシグナルを直接エクスポートする前にエンドポ
 どちらのシグナルも、ゲートウェイが解決したクライアントアドレスを使用します。ロードバランサー、ポートフォワード、またはトンネルがトラフィックをリレーしていて、`listen.trusted_proxies` にリストされていない場合、ゲートウェイにはリレーのアドレス（通常はプライベート）が見えるため、実行時の警告もプライベートの許可リストも、それを経由してリレーされたトラフィックを検出できません。
 
-そのようなフロントエンドの背後では、まず [`listen.trusted_proxies`](#listen) を設定してゲートウェイが実際のクライアントアドレスを見られるようにし、いずれにしてもゲートウェイとその前段にあるすべてのものをパブリックインターネットから到達できないようにしてください。
+中継元が [`listen.trusted_proxies` に含めるべきもの](#listen)であれば、そこに列挙してください。いずれにしても、ゲートウェイとその前段にあるすべてのものは、パブリックインターネットから到達できないようにしてください。
 
 ### `load_test_mode`
```

</details>

*...以降省略*

</details>


<details>
<summary>2026-11-10</summary>

**変更ファイル:**

```
 docs-ja/pages/advisor-ja.md                        |   9 +-
 docs-ja/pages/agent-teams-ja.md                    |   2 +-
 docs-ja/pages/agent-view-ja.md                     |  48 +-
 docs-ja/pages/best-practices-ja.md                 |   4 +-
 docs-ja/pages/changelog.md                         | 125 ++++
 docs-ja/pages/claude-apps-gateway-config-ja.md     |  38 +
 docs-ja/pages/claude-apps-gateway-deploy-ja.md     |  14 +
 docs-ja/pages/claude-apps-gateway-ja.md            |   2 +-
 .../pages/claude-apps-gateway-spend-limits-ja.md   |  13 +-
 docs-ja/pages/cli-reference-ja.md                  | 184 ++---
 docs-ja/pages/commands-ja.md                       |   2 +-
 docs-ja/pages/costs-ja.md                          |   2 +-
 docs-ja/pages/cross-session-messaging-ja.md        | 132 ++--
 docs-ja/pages/desktop-ja.md                        |   4 +-
 docs-ja/pages/env-vars-ja.md                       |   3 +-
 docs-ja/pages/errors-ja.md                         | 807 +++++++++++----------
 docs-ja/pages/fast-mode-ja.md                      |  39 +-
 docs-ja/pages/github-actions-ja.md                 |   1 +
 docs-ja/pages/goal-ja.md                           |   2 +-
 docs-ja/pages/hooks-guide-ja.md                    |   2 +-
 docs-ja/pages/hooks-ja.md                          |  14 +-
 docs-ja/pages/large-codebases-ja.md                |   4 +-
 docs-ja/pages/llm-gateway-protocol-ja.md           |   2 +-
 docs-ja/pages/model-config-ja.md                   |  79 +-
 docs-ja/pages/permissions-ja.md                    |   9 +-
 docs-ja/pages/prompt-caching-ja.md                 |   4 +-
 docs-ja/pages/remote-control-ja.md                 |   3 +
 docs-ja/pages/sandboxing-ja.md                     |   4 +
 .../self-hosted-environments-configuration-ja.md   |  18 +-
 .../pages/self-hosted-environments-deploy-ja.md    |  21 +-
 .../self-hosted-environments-quickstart-ja.md      |   4 +-
 .../pages/self-hosted-environments-reference-ja.md |   2 +-
 docs-ja/pages/settings-ja.md                       |   1 +
 docs-ja/pages/settings-reference-ja.md             |   8 +-
 docs-ja/pages/skills-ja.md                         |   2 +-
 docs-ja/pages/sub-agents-ja.md                     |   2 +
 docs-ja/pages/tools-reference-ja.md                |  29 +-
 docs-ja/pages/worktrees-ja.md                      |   2 +-
 docs-ja/pages/zero-data-retention-ja.md            |   4 +-
 39 files changed, 1002 insertions(+), 643 deletions(-)
```

<details>
<summary>advisor-ja.md</summary>

```diff
diff --git a/docs-ja/pages/advisor-ja.md b/docs-ja/pages/advisor-ja.md
index aa9edfb..40d9f33 100644
--- a/docs-ja/pages/advisor-ja.md
+++ b/docs-ja/pages/advisor-ja.md
@@ -99,8 +99,9 @@ Claude Code はアドバイザーの役割における能力に基づいてモ
 | Sonnet 5.5 | Fable、Opus 5 以降、Sonnet 5.5 |
 | Opus 5 または Opus 5.5 | Fable、Opus 5 以降 |
-| Fable 5 | Fable 5.1 または Fable 5 |
-| Fable 5.1 | Fable 5.1 |
+| Fable 5 | Fable 5.2、Fable 5.1、または Fable 5 |
+| Fable 5.1 | Fable 5.2 または Fable 5.1 |
+| Fable 5.2 | Fable 5.2 |
 
-Fable 5.1 には Claude Code v2.1.257 以降が必要です。Fable モデルには [Fable アクセス](https://code.claude.com/docs/ja/model-config.md#work-with-fable) が必要です。Opus 4.7 または Opus 4.8 のメインモデルに対して Sonnet 5.5 をアドバイザーとして使用するには、Claude Code v2.1.287 以降が必要です。Haiku 5.5 をメインモデルまたはアドバイザーとして使用するには、Claude Code v2.1.293 以降が必要です。
+Fable 5.2 には Claude Code v2.1.321 以降が必要で、Fable 5.1 には v2.1.257 以降が必要です。Fable モデルには [Fable アクセス](https://code.claude.com/docs/ja/model-config.md#work-with-fable) が必要です。Opus 4.7 または Opus 4.8 のメインモデルに対して Sonnet 5.5 をアドバイザーとして使用するには、Claude Code v2.1.287 以降が必要です。Haiku 5.5 をメインモデルまたはアドバイザーとして使用するには、Claude Code v2.1.293 以降が必要です。
 
 アドバイザーを `fable`、`opus`、または `sonnet` として設定します。これらのエイリアスは Claude Code の各モデルファミリーの[組み込みデフォルトバージョン](https://code.claude.com/docs/ja/model-config.md#model-aliases)に解決され、新しい Claude Code リリースで進化します。`claude-opus-5-5` や `claude-haiku-5-5` などの完全なモデル ID を渡すこともできます。Haiku 4.5 はアドバイザーを呼び出すことはできますが、アドバイザーとして機能することはできません。
@@ -160,5 +161,5 @@ Claude が advisor を呼び出すと、advisor モデルが会話を読むた
 * **サブスクリプションプラン**: advisor 使用量はプランの使用制限にカウントされます。ただし、Fable advisor は Fable 使用量が課金される計画では[使用クレジット](https://code.claude.com/docs/ja/model-config.md#fable-and-usage-credits)に課金されます
 
-アカウントが使用クレジット同意を必要とする場合、Fable advisor は同意を与えるまで何も課金されません。Claude Code はそれまで[選択を適用しない](#fable-advisor-and-usage-credits)ためです。
+Fable advisor と使用クレジットの連携については、[Fable advisor と使用クレジット](#fable-advisor-and-usage-credits)を参照してください。
 
 Claude は各ターンではなく決定ポイントで advisor を呼び出すため、より高速なメインモデルをより強力な advisor と組み合わせることは、通常、より強力なモデルを全体で実行するよりもコストが低くなります。advisor 使用量は [`/usage`](https://code.claude.com/docs/ja/costs#track-your-costs)で表示されるセッション合計にカウントされます。
```

</details>

<details>
<summary>agent-teams-ja.md</summary>

```diff
diff --git a/docs-ja/pages/agent-teams-ja.md b/docs-ja/pages/agent-teams-ja.md
index e2a4c53..89d3278 100644
--- a/docs-ja/pages/agent-teams-ja.md
+++ b/docs-ja/pages/agent-teams-ja.md
@@ -9,5 +9,5 @@
 > [!WARNING]
 >
-> エージェントチームは実験的機能であり、デフォルトでは無効になっています。[settings.json](https://code.claude.com/docs/ja/settings.md) または環境に `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1` を設定して有効にしてください。その変数がない場合、セッション開始時にチームが設定されず、チームディレクトリが書き込まれず、Claude はチームメンバーをスポーンまたは提案しません。エージェントチームには、セッション再開、タスク調整、シャットダウン動作に関する[既知の制限](#limitations)があります。
+> エージェントチームは実験的機能であり、デフォルトでは無効になっています。[settings.json](https://code.claude.com/docs/ja/settings.md) または環境に `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1` を設定して有効にしてください。エージェントチームには、セッション再開、タスク調整、シャットダウン動作に関する[既知の制限](#limitations)があります。
 
 エージェントチームを使用すると、複数の Claude Code インスタンスが連携して動作するように調整できます。1 つのセッションがチームリーダーとして機能し、作業を調整し、タスクを割り当て、結果を統合します。チームメンバーは独立して動作し、それぞれ独自のコンテキストウィンドウで動作し、互いに直接通信します。リーダーを経由せずに、任意のチームメンバーと直接対話することもできます。
```

</details>

<details>
<summary>agent-view-ja.md</summary>

```diff
diff --git a/docs-ja/pages/agent-view-ja.md b/docs-ja/pages/agent-view-ja.md
index 89968e2..eb7640f 100644
--- a/docs-ja/pages/agent-view-ja.md
+++ b/docs-ja/pages/agent-view-ja.md
@@ -842,27 +842,27 @@ claude agents --settings ./ci-settings.json --add-dir ../shared-lib
 セッションが独自の言葉で進捗を報告するようにしたい場合は、`state.json` を編集する代わりに、例えば `$CLAUDE_JOB_DIR/tmp` の下など、独自のファイルを書き込むようにしてください。
 
-## バックグラウンドセッションのホスティング方法
+## バックグラウンドセッションのホスト方法
 
-Claude Code は、エージェントビューに表示されているすべてのセッションをバックグラウンドセッションとして扱います。現在接続しているかどうかに関わらず、バックグラウンドセッションとして扱われます。これに対して、`claude` を直接実行して開始したセッションはそのターミナルに紐付けられ、ターミナルが閉じると終了します。ただし、[バックグラウンドに送信](#from-inside-a-session)することはできます。
+Claude Code は、エージェントビューに一覧表示されるすべてのセッションを、現在アタッチしているかどうかにかかわらずバックグラウンドセッションとして扱います。これに対して、`claude` を直接実行して開始したセッションはそのターミナルに紐付けられ、[バックグラウンドに送る](#from-inside-a-session)場合を除き、ターミナルを閉じると終了します。
 
-どのような種類のセッションにいるかを確認するには、[`/status`](https://code.claude.com/docs/ja/commands) を実行してください。バックグラウンドセッションでは、`Session kind` の行に `background job · attached` または `background job · unattended` と表示されます。ターミナルが接続されているかどうかによって異なります。その他のセッションでは `interactive` と表示されます。
+現在どの種類のセッションにいるかを確認するには、[`/status`](https://code.claude.com/docs/ja/commands) を実行します。`Session kind` 行には、バックグラウンドセッションではターミナルがアタッチされているかどうかに応じて `background job · attached` または `background job · unattended` と表示され、それ以外のセッションでは `interactive` と表示されます。
 
 ### スーパーバイザープロセス
 
-スーパーバイザーはバックグラウンドサービスで、バックグラウンドセッションを実行し、エージェントビューやターミナルを閉じた後もセッションが動作し続けるようにします。Claude Code は、セッションをバックグラウンドに送信するか、エージェントビューを開いた時点で最初にスーパーバイザーを起動します。自分で管理する必要はありません。
+スーパーバイザーは、エージェントビューやターミナルを閉じた後もバックグラウンドセッションが動作し続けるよう、それらを実行するバックグラウンドサービスです。Claude Code は、初めてセッションをバックグラウンドに送るかエージェントビューを開いたときにスーパーバイザーを起動するため、自分で管理する必要はありません。
 
-各セッションはスーパーバイザーの下で独自の Claude Code プロセスであり、そのプロセスに何が起こるかはセッションの状態によって異なります。
+各セッションはスーパーバイザー配下の個別の Claude Code プロセスであり、そのプロセスがどうなるかはセッションの状態によって異なります。
 
-* **動作中、権限プロンプトまたは他のダイアログで一時停止中、または接続中**：プロセスは実行を続けます。実行中のサブエージェント、ワークフロー、またはモニターは動作中としてカウントされます。`/loop` のウェイクアップなど、保留中の[セッションスコープのスケジュールタスク](https://code.claude.com/docs/ja/scheduled-tasks.md)も同様です。
-* **完了したか次のメッセージを待機中で、約 1 時間未接続**：スーパーバイザーはリソースを解放するためにプロセスを停止します。質問を投げかけてターンを終了したセッションは、次のメッセージを待機中としてカウントされます。会話はディスクに保存され、次回接続または返信するときに、セッションは中断したところから再開されます。`Ctrl+T` でセッションをピンして、プロセスの実行を継続させます。
-* **スーパーバイザーが実行中に予期せず終了した**：スーパーバイザーはプロセスを再起動します。`←` または `/background` で自分でバックグラウンドに送信したセッションを、たとえば `kill` で終了した場合は、再起動されずに停止済みとしてマークされます。シャットダウンで終了したセッションについては、[セッションがシャットダウン後に失敗または停止として表示される](#sessions-show-as-failed-after-shutdown) を参照してください。
-* **自動更新後**：スーパーバイザーは新しいバージョンに再起動し、アイドル状態のセッションをバックグラウンドで移動します。動作中、ユーザーの応答を待機中、または接続中のセッションは中断されません。
-* **スーパーバイザー自体が停止した**（たとえば、そのプロセスが Claude Code の外部から終了された場合）：macOS と Linux では、約 1 分以内に新しいスーパーバイザーが接続しない限り、セッションは停止します。スーパーバイザーを起動するには、シェルで `claude agents` を実行してください。その 1 分が経過した後については、[スーパーバイザーの停止後もセッションを実行し続ける](#keep-sessions-running-after-the-supervisor-stops) を参照してください。
+* **作業中、権限プロンプトやその他のダイアログで一時停止中、またはアタッチ中**：プロセスは実行を続けます。実行中のサブエージェント、ワークフロー、モニターは作業中とみなされ、`/loop` のウェイクアップなど保留中の[セッションスコープのスケジュールタスク](https://code.claude.com/docs/ja/scheduled-tasks.md)も同様です。
```

</details>

<details>
<summary>best-practices-ja.md</summary>

```diff
diff --git a/docs-ja/pages/best-practices-ja.md b/docs-ja/pages/best-practices-ja.md
index a75b509..a645f5c 100644
--- a/docs-ja/pages/best-practices-ja.md
+++ b/docs-ja/pages/best-practices-ja.md
@@ -434,5 +434,5 @@ auto モードがアクションをブロックすると通知が届き、その
 ### モデルと effort を変更する
 
-[effort](https://code.claude.com/docs/ja/model-config.md#adjust-effort-level) は Claude が考える長さを制御する主な手段であり、かつてプロンプトの言い回しで行っていたことのほとんどを置き換えます。Claude Opus 5.5、Sonnet 5.5、Haiku 5.5 のデフォルトは `medium` で、スコープが明確な日常的な機能開発には十分です。セッション内で `/effort` を使って変更するのは次のような場合です：
+[effort](https://code.claude.com/docs/ja/model-config.md#adjust-effort-level) は Claude が考える長さを制御する主な手段であり、かつてプロンプトの言い回しで行っていたことのほとんどを置き換えます。Claude Fable 5.2、Opus 5.5、Sonnet 5.5、Haiku 5.5 のデフォルトは `medium` で、スコープが明確な日常的な機能開発には十分です。セッション内で `/effort` を使って変更するのは次のような場合です：
 
 * 正しく仕上げられるかどうかが見落としやすいケースにかかっているときは、`/effort high` または `/effort xhigh` で引き上げます。自分が書いていないコードのバグ、不安定なテスト、古い形式を読んでいる箇所を Claude がすべて見つけなければならないスキーマ変更などです。Claude はより多くのエッジケースをチェックし、回答前に自分の作業をより多く検証します。追加の時間とトークンはそこに使われます。
@@ -441,5 +441,5 @@ auto モードがアクションをブロックすると通知が届き、その
 * 日常的な作業の途中で難しい質問が 1 つだけあるときのように、次のメッセージだけに必要な場合は、設定を変更する代わりにそのプロンプトに [`ultrathink`](https://code.claude.com/docs/ja/model-config#use-ultrathink-for-one-off-deep-reasoning) を入れます。
 
-モデル自体については、デフォルトの Opus 5.5 がほとんどのコーディングをうまくこなし、Sonnet は日常的な作業でより低コストです。[Claude Fable 5.1](https://code.claude.com/docs/ja/model-config.md#work-with-fable) は `/model fable` で明示的に選択したときに使用でき、Haiku は単純な仕事をするサブエージェントに適しています。プランとプロバイダーごとの完全なリストは[モデル設定](https://code.claude.com/docs/ja/model-config.md)にあります。
+モデル自体については、デフォルトの Opus 5.5 がほとんどのコーディングをうまくこなし、Sonnet は日常的な作業でより低コストです。[Claude Fable 5.2](https://code.claude.com/docs/ja/model-config.md#work-with-fable) を使用するには、`/model fable` を実行します。Haiku は単純な仕事をするサブエージェントに適しています。プランとプロバイダーごとの完全なリストは[モデル設定](https://code.claude.com/docs/ja/model-config.md)にあります。
 
 ### サブエージェントのコストを知る
```

</details>

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index cb9d948..766241d 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,129 @@
 # Changelog
 
+## 2.1.322
+
+- Added fast mode on Vertex in the global, us and eu regions, falling back to standard speed if Vertex refuses it
+
+## 2.1.321
+
+- Added Claude Fable 5.2 (`claude-fable-5-2`), now the default Fable model — 1M context, $8/$40 per Mtok with $0.20/Mtok cache reads
+- Added `--settings <file>` to `claude remote-control`, which applies a settings file to every session it starts; if the file changes, no new session starts until you restart `claude remote-control`
+- Fixed MCP OAuth requests sending secrets such as refresh tokens to another host when a server redirected them
+- Fixed a case where a read-only Bash command ran outside the sandbox without a permission prompt
+- Fixed a case where Bash permission checks judged a file write from the wrong folder and didn't prompt
+- Fixed deny rules and protected-file prompts not applying to the file that a `cp` or `mv` into a directory writes
+- Fixed the "Draws from usage credits" note showing after a switch to Fable on Enterprise seats whose plan includes Fable
+- Fixed the fallback model sometimes declining a request or mentioning a stopped response when the first model was blocked before replying
+- Fixed `claude mcp login` printing a SEP-2352 issuer warning each time you sign in again to a server that Claude Code registered with
+- Fixed `NotebookEdit` deleting or overwriting a notebook's first cell when the call named no cell, on network paths (UNC shares, WSL folders, `/net` mounts)
+- Fixed Edit changing the first of several matches, replacing a whole file on an empty `old_string`, or editing a notebook as text, on network paths (UNC shares, WSL folders, `/net` mounts)
+- Fixed `/config` showing Manual as the default permission mode when new sessions start in auto mode; pressing Space on "Auto (default)" now saves Don't Ask, not Plan
+- Windows: Fixed `FileChanged` hooks stopping for paths set through `watchPaths` after the first shell command, when the session's working directory had a lowercase drive letter
+- Fixed `--plugin-dir .` and `--plugin-dir ./builtin` writing generated type files for Claude Code's built-in plugins into a `builtin` folder
+- Fixed context usage estimates overcounting tool definitions when exact token counts are unavailable
+- Fixed `/compact` showing twice in Remote Control on web and mobile
+- Fixed plugin auto-updates and `/plugin` marketplace updates downloading a plugin again for each worktree or folder of a repository
```

</details>

<details>
<summary>claude-apps-gateway-config-ja.md</summary>

```diff
diff --git a/docs-ja/pages/claude-apps-gateway-config-ja.md b/docs-ja/pages/claude-apps-gateway-config-ja.md
index 4b432c5..d30d7cd 100644
--- a/docs-ja/pages/claude-apps-gateway-config-ja.md
+++ b/docs-ja/pages/claude-apps-gateway-config-ja.md
@@ -27,4 +27,5 @@ Claude apps gateway デプロイメントは、慣例的に `gateway.yaml` と
 **オプションセクション：**
 
+* [`login_notice`](#login_notice)：開発者がサインイン時に表示される通知
 * [`admin`](#admin)：Admin API 認証、支出制限の保持
 * [`enforcement`](#enforcement)：支出制限のフェイルオープンまたはフェイルクローズ動作
@@ -846,4 +847,16 @@ IdP の userinfo エンドポイントが groups クレームを返し、かつ
 ## オプションセクション
 
+### `login_notice`
+
+開発者がサインインするときにお知らせを表示するには、トップレベルの `login_notice` キーにお知らせのテキストを最大 500 文字で設定します。次の例では、ゲートウェイの対象者とアクセスに関する問い合わせ先を示しています。
+
+```yaml theme={null}
+login_notice: This gateway is for Example Corp staff. For access questions, email it-help@example.com.
+```
+
+開発者には、ブラウザのゲートウェイ検証ページと、ターミナルの対話型サインイン画面で、`Notice from <gateway hostname>` の下にこのテキストが表示されます。テキスト内の改行はスペースになります。お知らせはサインイン前に表示されるため、ゲートウェイにアクセスできる人なら誰でも読むことができます。
+
+ゲートウェイサーバーに Claude Code v2.1.319 以降が必要です。ターミナル画面については、開発者のマシンにも同じバージョンが必要です。それより前のゲートウェイは、このキーを見つけると起動を拒否します。キーを追加する前にすべてのレプリカをアップグレードし、ロールバックする前にキーを削除してください。
+
 ### `admin`
 
@@ -864,4 +877,7 @@ admin:
   admin_groups: [platform-finops]
   blocked_message: request an increase at https://go.example.com/claude-limits
```

</details>

<details>
<summary>claude-apps-gateway-deploy-ja.md</summary>

```diff
diff --git a/docs-ja/pages/claude-apps-gateway-deploy-ja.md b/docs-ja/pages/claude-apps-gateway-deploy-ja.md
index 770c8e3..61e114c 100644
--- a/docs-ja/pages/claude-apps-gateway-deploy-ja.md
+++ b/docs-ja/pages/claude-apps-gateway-deploy-ja.md
@@ -174,4 +174,18 @@ IdP がリフレッシュトークンを発行する場合、Claude Code はセ
 * **運用ログ**: 起動、警告、アップストリームのエラーについて、`[gateway]` というプレフィックスの付いた人間が読める形式の行を出力します。詳細度は `CLAUDE_GATEWAY_LOG_LEVEL` 環境変数で制御し、`debug`、`info`、`warn`、`error` のいずれかを指定できます。デフォルトは `info` です。`debug` では、サインインとリフレッシュのたびに id\_token に含まれるクレームの名前（値ではありません）もログに記録され、`userinfo_fallback` が何らかのクレームを提供した場合は userinfo クレームの名前も記録されます。これにより、PII をログに残さずに `email_claim` と `groups_claim` の設定を診断できます。この設定は監査イベントには影響せず、監査イベントは常に出力されます。
 
+#### 運用ログを JSON として書き出す
+
+ログコレクターが各行のレベルを JSON フィールドから読み取る場合は、ゲートウェイの環境で `CLAUDE_GATEWAY_LOG_FORMAT=json` を設定します。ゲートウェイサーバーで Claude Code v2.1.319 以降が必要です。
+
+これにより、各運用ログ行は `severity`、`time`、`message` を持つ 1 つのオブジェクトになります。
+
+```json theme={null}
+{"severity":"INFO","time":"2026-11-04T17:03:21.512Z","message":"claude gateway listening on http://0.0.0.0:8080"}
+```
+
+`severity` は大文字で表したログレベルで、`warn` は `WARNING` と書かれます。起動の失敗は `ERROR` の行になります。
+
+同じく stderr に出力される監査イベントは変わりません。監査イベントには `ts` と `evt` が含まれ、`severity` は含まれません。
+
 ### ヘルスチェック
 
```

</details>

*...以降省略*

</details>


<details>
<summary>2026-11-09</summary>

**変更ファイル:**

```
 docs-ja/pages/desktop-ja.md            | 33 ++++++++++++++++++++++++++++++---
 docs-ja/pages/settings-reference-ja.md |  4 +++-
 2 files changed, 33 insertions(+), 4 deletions(-)
```

<details>
<summary>desktop-ja.md</summary>

```diff
diff --git a/docs-ja/pages/desktop-ja.md b/docs-ja/pages/desktop-ja.md
index 21bf31f..d5364bb 100644
--- a/docs-ja/pages/desktop-ja.md
+++ b/docs-ja/pages/desktop-ja.md
@@ -117,5 +117,5 @@ Desktop を Google Cloud の Agent Platform にルーティングする Enterpri
 Claude は dev サーバーを起動し、Browser ペインで開いて変更を確認できます。これはフロントエンド Web アプリとバックエンドサーバーの両方で機能します：Claude は API エンドポイントをテストし、サーバーログを表示し、見つけた問題を反復処理できます。ほとんどの場合、Claude はプロジェクトファイルを編集した後、サーバーを自動的に起動します。いつでも Claude にプレビューを要求することもできます。デフォルトでは、Claude は編集後に[変更を自動検証](#auto-verify-changes)します。
 
-ローカルセッションでは、チャットで HTML、PDF、またはビデオのパスをクリックすると、Browser ペインで開きます。
+ローカルセッションでは、チャットで HTML、PDF、またはビデオのパスをクリックすると、Browser ペインで開きます。SSH または WSL セッションでは、[HTML ファイルをプレビュー](#preview-html-files-in-ssh-and-wsl-sessions)できます。
 
 > [!NOTE]
@@ -138,4 +138,31 @@ Claude はプロジェクトに基づいて初期サーバー設定を作成し
 Browser の保存データをクリアするには、Browser ペインの **⋮** メニューで **Clear browsing data** を選択します。Browser を完全にオフにするには、**Settings > Code** または **Settings > Claude Code** で **Browser tools** をオフにします。
 
+#### SSH および WSL セッションで HTML ファイルをプレビューする
+
+[SSH](#ssh-sessions) または [WSL](https://code.claude.com/docs/ja/desktop-wsl.md) セッションでは、チャットで HTML ファイルのパスをクリックすると、Browser ペインでそのファイルをプレビューできます。プレビュー内のグラフや表が空のままの場合は、その上に表示される通知で理由を確認できます：
+
+* **`This preview doesn't load anything from the web`**：ファイルに記述されたスクリプトは実行されますが、ライブラリを Web から読み込むグラフは空のままです。通知に **Export** ボタンがある場合は、それを選択し、保存したファイルをブラウザで開きます。ブラウザでは Web からのコンテンツが読み込まれます。
+* **`This preview doesn't run scripts or load anything from the web`**：Claude Desktop v4.23118.0 より前のバージョンでは、これらのプレビューでスクリプトが実行されなかったため、Desktop を更新してファイルを再度開きます。Desktop が最新であっても通知が表示されたままの場合は、Desktop を再起動します。それでも表示される場合は、[組織でスクリプトがオフになっている](#turn-off-scripts-in-ssh-and-wsl-previews-for-your-organization)可能性があるため、管理者に問い合わせてください。
+
+通知を閉じた場合は、ファイルを再度開くと通知が再び表示されます。
+
+#### 組織の SSH および WSL プレビューでスクリプトをオフにする
+
+[SSH および WSL セッションでの HTML プレビュー](#preview-html-files-in-ssh-and-wsl-sessions)でスクリプトが実行されないようにするには、[`disableBrowserExternalNavigation` 管理設定](#managed-settings)を `true` に設定します。この設定を有効にすると、ユーザーは Browser ペインで[外部サイトを閲覧する](#restrict-external-browsing-for-your-organization)こともできなくなります。
+
+この設定は、[サーバー管理設定](https://code.claude.com/docs/ja/server-managed-settings.md)で行うか、Desktop を実行するコンピューター上の [Claude Code MDM ポリシーまたは管理設定ファイル](https://code.claude.com/docs/ja/managed-settings.md#where-each-mechanism-stores-the-policy)で行います。Desktop はリモートマシンや WSL ディストリビューションからこの設定を読み取りません。[サードパーティプロバイダー](https://code.claude.com/docs/ja/third-party-integrations.md)を使用する場合は、MDM ポリシーまたはファイルを使用します。
+
+> [!WARNING]
```

</details>

<details>
<summary>settings-reference-ja.md</summary>

```diff
diff --git a/docs-ja/pages/settings-reference-ja.md b/docs-ja/pages/settings-reference-ja.md
index 63aeec1..37181e2 100644
--- a/docs-ja/pages/settings-reference-ja.md
+++ b/docs-ja/pages/settings-reference-ja.md
@@ -5428,5 +5428,5 @@ Claude Code は `/config` の **Auto-update channel** で選択すると、ユ
 ### `disableBrowserExternalNavigation`
 
-デスクトップアプリの[ブラウザペイン](https://code.claude.com/docs/ja/desktop.md#browse-external-sites)で、ユーザーと Claude の両方に対して外部ブラウジングをオフにします。Localhost 開発サーバープレビューは引き続き機能します。デスクトップアプリはこのキーを読み取ります。ターミナル CLI は無視します。
+デスクトップアプリの[ブラウザペイン](https://code.claude.com/docs/ja/desktop.md#browse-external-sites)で、ユーザーと Claude の両方に対して外部ブラウジングをオフにします。Localhost 開発サーバープレビューは引き続き機能します。SSH および WSL セッションの HTML プレビューは引き続き開きますが、[スクリプトは実行されません](https://code.claude.com/docs/ja/desktop.md#turn-off-scripts-in-ssh-and-wsl-previews-for-your-organization)。デスクトップアプリはこのキーを読み取ります。ターミナル CLI は無視します。
 
 * **スコープ**: [`Managed`](#scopes)
@@ -5444,4 +5444,6 @@ Claude Code は `/config` の **Auto-update channel** で選択すると、ユ
 デスクトップアプリはその他の値を無視し、文字列`"true"`や`1`などのブール値ではない値も警告をログに記録します。外部ブラウジングはオンのままにしておきたいが、Claude のツールを外部ページでオフにしたい場合は、代わりに[`browserExternalPageTools`](#browserexternalpagetools)を設定してください。[組織の外部ブラウジングを制限する](https://code.claude.com/docs/ja/desktop.md#restrict-external-browsing-for-your-organization)を参照してください。
 
+デスクトップアプリを実行するコンピューターが他の Claude Code 管理設定を受け取らない場合は、作成する管理設定で[`parentSettingsBehavior`](#parentsettingsbehavior)も`"merge"`に設定してください。Windows では、管理設定ファイルを作成すると、ユーザーは[許可する](https://code.claude.com/docs/ja/admin-setup.md#wsl-sessions-in-claude-code-desktop)まで WSL セッションも使用できなくなります。その理由については、[組織の SSH および WSL プレビューでスクリプトをオフにする](https://code.claude.com/docs/ja/desktop.md#turn-off-scripts-in-ssh-and-wsl-previews-for-your-organization)を参照してください。
+
 ### `disableMobileSimulatorTools`
 
```

</details>

</details>


<details>
<summary>2026-11-08</summary>

**変更ファイル:**

```
 docs-ja/pages/hooks-guide-ja.md | 18 ++++--------------
 docs-ja/pages/hooks-ja.md       |  2 +-
 docs-ja/pages/mcp-ja.md         |  8 +++++---
 docs-ja/pages/sandboxing-ja.md  |  1 +
 4 files changed, 11 insertions(+), 18 deletions(-)
```

<details>
<summary>hooks-guide-ja.md</summary>

```diff
diff --git a/docs-ja/pages/hooks-guide-ja.md b/docs-ja/pages/hooks-guide-ja.md
index f2ae397..e5ea4e7 100644
--- a/docs-ja/pages/hooks-guide-ja.md
+++ b/docs-ja/pages/hooks-guide-ja.md
@@ -422,5 +422,5 @@ matcher は設定の種類でフィルタリングします。`user_settings`、
 常に許可しているツール呼び出しについて、承認ダイアログをスキップします。この例では、Claude がプランの提示を終えて続行の可否を尋ねるときに呼び出すツールである `ExitPlanMode` を自動承認するため、プランの準備ができるたびにプロンプトが表示されることはありません。
 
-上記の終了コードの例とは異なり、自動承認ではフックが JSON の決定を stdout に書き込む必要があります。Claude Code はユーザーに権限を求めようとするときに `PermissionRequest` フックを実行し、フックが `"behavior": "allow"` を返すと、Claude Code がユーザーに代わってリクエストに応答します。
+上記の終了コードの例とは異なり、自動承認ではフックが JSON の決定を stdout に書き込む必要があります。Claude Code はユーザーに権限を求めようとするときに `PermissionRequest` フックを実行し、フックが `"behavior": "allow"` を返すと、Claude Code がユーザーに代わってリクエストに応答します。`ExitPlanMode` のような[ユーザーの操作を必要とする](https://code.claude.com/docs/ja/hooks.md#allow-with-updatedinput)ツールの場合、許可には `updatedInput` も必要です。これがないと、Claude Code は許可を無視し、引き続きプロンプトを表示します。
 
 matcher によってフックのスコープが `ExitPlanMode` のみに限定されるため、他のプロンプトには影響しません。これを `~/.claude/settings.json` に追加します。
@@ -435,5 +435,5 @@ matcher によってフックのスコープが `ExitPlanMode` のみに限定
           {
             "type": "command",
-            "command": "echo '{\"hookSpecificOutput\": {\"hookEventName\": \"PermissionRequest\", \"decision\": {\"behavior\": \"allow\"}}}'"
+            "command": "jq -c '{hookSpecificOutput: {hookEventName: \"PermissionRequest\", decision: {behavior: \"allow\", updatedInput: .tool_input}}}'"
           }
         ]
@@ -454,18 +454,8 @@ matcher によってフックのスコープが `ExitPlanMode` のみに限定
 > Claude Code がこれを `defaultMode` として保存することはありません。
 
-セッションを `acceptEdits` に切り替えるには、フックが次の JSON を stdout に書き込みます。
+セッションを `acceptEdits` に切り替えるには、そのフックの `command` 行を次の行に置き換えます。
 
 ```json theme={null}
-{
-  "hookSpecificOutput": {
-    "hookEventName": "PermissionRequest",
-    "decision": {
-      "behavior": "allow",
```

</details>

<details>
<summary>hooks-ja.md</summary>

```diff
diff --git a/docs-ja/pages/hooks-ja.md b/docs-ja/pages/hooks-ja.md
index 3ac6935..a00281c 100644
--- a/docs-ja/pages/hooks-ja.md
+++ b/docs-ja/pages/hooks-ja.md
@@ -2167,5 +2167,5 @@ PreToolUse フックは、権限が必要かどうかにかかわらず、すべ
 | :- | :- |
 | `behavior` | `"allow"` は権限を付与し、`"deny"` は拒否します。[拒否ルールと確認ルール](https://code.claude.com/docs/ja/permissions.md#manage-permissions)は引き続き評価されるため、`"allow"` を返すフックが一致する拒否ルールを上書きすることはありません |
-| `updatedInput` | `"allow"` の場合のみ：実行前にツールの入力パラメータを変更します。入力オブジェクト全体を置き換えるため、変更したフィールドと一緒に変更していないフィールドも含めてください。変更された入力は、拒否ルールと確認ルールに対して再評価されます |
+| `updatedInput` | `"allow"` の場合のみ：実行前にツールの入力パラメータを変更します。入力オブジェクト全体を置き換えるため、変更したフィールドと一緒に変更していないフィールドも含めてください。変更された入力は拒否ルールと確認ルールに対して再評価されます。`AskUserQuestion` と `ExitPlanMode` には[このフィールドが必要です](#allow-with-updatedinput) |
 | `updatedPermissions` | `"allow"` の場合のみ：適用する[権限更新エントリ](#permission-update-entries)の配列です。許可ルールの追加やセッションの権限モードの変更などを指定します |
 | `message` | `"deny"` の場合のみ：権限が拒否された理由を Claude に伝えます |
```

</details>

<details>
<summary>mcp-ja.md</summary>

```diff
diff --git a/docs-ja/pages/mcp-ja.md b/docs-ja/pages/mcp-ja.md
index 0a06748..faad22f 100644
--- a/docs-ja/pages/mcp-ja.md
+++ b/docs-ja/pages/mcp-ja.md
@@ -597,5 +597,5 @@ MCP サーバーを構築する場合、長時間実行される `tools/call` 
 #### タスクで呼び出しに応答する
 
-リクエストに拡張機能が含まれている場合にのみタスクで応答してください。そうしないと、Claude はツールエラー `Unsupported result type 'task' for tools/call` を受け取ります。`taskId`、`status`、`createdAt`、`lastUpdatedAt`、`ttlMs` のいずれかが欠けている場合も、Claude は同じエラーを受け取ります。タスクオブジェクトは `tools/call` レスポンスの JSON-RPC `result` であり、`content` 配列は不要です。この例では、オプションの `statusMessage` と `pollIntervalMs` も含めています。
+タスクで応答するのは、リクエストにその拡張が含まれている場合のみにしてください。そうでない場合、呼び出しはツールエラー `Unsupported result type 'task' for tools/call` で失敗します。応答に `taskId` がない場合や有効な `status` がない場合も、呼び出しは同じように失敗します。タスクオブジェクトは `tools/call` レスポンスの JSON-RPC `result` であり、`content` 配列は不要です。次の例では、オプションの `statusMessage` と `pollIntervalMs` も含めています。
 
 ```json theme={null}
@@ -617,8 +617,10 @@ MCP サーバーを構築する場合、長時間実行される `tools/call` 
 | `taskId` | 必須。スペースを含まない、最大 128 文字の印字可能な ASCII 文字。そうでない場合、Claude は `MCP server "<name>" returned a malformed task handle for tool "<tool>"` で始まるツールエラーを受け取ります。再開後、Claude Code は新しい接続でこの ID について問い合わせるため、接続をまたいで ID に応答できるようにしてください |
 | `status` | 必須。`working`、`input_required`、`completed`、`failed`、`cancelled` のいずれか。それ以外の値では `Unsupported result type` エラーになります |
-| `createdAt`, `lastUpdatedAt`, `ttlMs` | 必須。`ttlMs` は `null` でもかまいません。Claude Code は `ttlMs` を過ぎたことを理由にタスクを破棄しません |
-| `pollIntervalMs` | オプション。ただし `null` は不可。`tasks/get` リクエストの間隔（ミリ秒）で、250 から 30000 の範囲に制限されます。フィールドがない場合、Claude Code は 2000 を使用し、各 `tasks/get` レスポンスから値を読み直します |
+| `createdAt`, `lastUpdatedAt`, `ttlMs` | タスク拡張で必須とされており、`ttlMs` は `null` でもかまいません。Claude Code は、`ttlMs` が経過したことを理由にタスクを破棄することはありません |
+| `pollIntervalMs` | オプションです。`tasks/get` リクエストの間隔（ミリ秒）で、250〜30000 の範囲に制限されます。フィールドがないか `null` の場合、Claude Code は 2000 を使用します。値は各 `tasks/get` レスポンスから読み直されます |
 | `statusMessage` | オプション。`/tasks` には、この最初の応答ではなく最新の `tasks/get` レスポンスの値が表示され、フィールドを省略したレスポンスでは値がクリアされます。[Claude Code からのステータスメッセージ](#status-messages-on-an-mcp-task)がこれに代わって表示されることがあります |
 
+Claude Code は、`createdAt`、`lastUpdatedAt`、`ttlMs` を省略したタスク応答や、`pollIntervalMs` を `null` に設定したタスク応答を受け付けます。v2.1.317 より前は、代わりに `Unsupported result type` エラーで呼び出しが失敗していました。これらのバージョンでも動作させるには、タスク拡張で必須とされる 3 つのフィールドを送信し、`pollIntervalMs` は数値として送信するか、まったく送信しないでください。
+
 HTTP または claude.ai コネクタのサーバーでは、タスクの応答は[リクエストごとのタイマー](#time-limits-on-mcp-tool-calls)内に開始する必要があるため、先にジョブを受け付けて応答してから作業を行ってください。
 
```

</details>

<details>
<summary>sandboxing-ja.md</summary>

```diff
diff --git a/docs-ja/pages/sandboxing-ja.md b/docs-ja/pages/sandboxing-ja.md
index 6389943..0a3cf3f 100644
--- a/docs-ja/pages/sandboxing-ja.md
+++ b/docs-ja/pages/sandboxing-ja.md
@@ -42,4 +42,5 @@ Claude Code は、オープンソースの [`@anthropic-ai/sandbox-runtime`](htt
 * **組み込みのファイルツールと Web ツール**：Read、Edit、Write、WebFetch、WebSearch などのツールは、代わりに[権限ルール](https://code.claude.com/docs/ja/permissions.md)に従います。`denyRead` エントリは Read ツールを止めず、`allowedDomains` は WebFetch を制限しません
 * **Claude Code が起動するその他のプロセス**：コマンド[フック](https://code.claude.com/docs/ja/hooks.md)、ローカルの [MCP サーバー](https://code.claude.com/docs/ja/mcp.md)、[プラグインモニター](https://code.claude.com/docs/ja/plugins/components.md#monitors)、[LSP サーバー](https://code.claude.com/docs/ja/tools-reference.md#lsp-tool-behavior)、および[ステータスライン](https://code.claude.com/docs/ja/statusline.md)コマンドや `apiKeyHelper` などのヘルパーコマンドは、ユーザーの完全なアクセス権で実行されます
+* **mod**：[mod](https://code.claude.com/docs/ja/plugins/mods/overview.md) は Claude Code の内部で独自のコードを実行するため、そのファイルアクセス、ネットワークリクエスト、および [`$.process`](https://code.claude.com/docs/ja/plugins/mods/api#reach-files-processes-and-the-network) で起動したプログラムはサンドボックス化されません。[mod がアクセスできる範囲](https://code.claude.com/docs/ja/plugins/mods/overview.md#what-a-mod-can-reach)を参照してください
 
 設定によっては、一部のシェルコマンドもサンドボックスの外で実行されます。
```

</details>

</details>


<details>
<summary>2026-11-07</summary>

**変更ファイル:**

```
 docs-ja/pages/artifacts-ja.md                      |   2 +-
 docs-ja/pages/auto-mode-classifier-billing-ja.md   |   7 +-
 docs-ja/pages/changelog.md                         | 149 +++++
 docs-ja/pages/claude-apps-gateway-ja.md            |   4 +-
 docs-ja/pages/cloud-environments-ja.md             |   2 +-
 docs-ja/pages/deep-links-ja.md                     |   2 +-
 docs-ja/pages/desktop-ios-simulator-ja.md          |  23 +-
 docs-ja/pages/desktop-ja.md                        |  11 +-
 docs-ja/pages/desktop-linux-ja.md                  |   2 +-
 docs-ja/pages/desktop-scheduled-tasks-ja.md        |   6 +-
 docs-ja/pages/env-vars-ja.md                       |   6 +-
 docs-ja/pages/errors-ja.md                         | 683 +++++++++++----------
 docs-ja/pages/fast-mode-ja.md                      |  10 +-
 docs-ja/pages/hooks-guide-ja.md                    |   7 +-
 docs-ja/pages/hooks-ja.md                          |  84 ++-
 docs-ja/pages/mcp-ja.md                            |  16 +-
 docs-ja/pages/mobile-ja.md                         |   2 +-
 docs-ja/pages/model-config-ja.md                   |  11 +-
 docs-ja/pages/network-config-ja.md                 |   7 +
 docs-ja/pages/permission-modes-ja.md               |   8 +-
 docs-ja/pages/remote-control-ja.md                 |   4 +-
 docs-ja/pages/sandbox-environments-ja.md           |  11 +-
 .../self-hosted-environments-configuration-ja.md   |   1 +
 docs-ja/pages/server-managed-settings-ja.md        |   1 +
 docs-ja/pages/settings-reference-ja.md             |  17 +-
 docs-ja/pages/setup-ja.md                          |   8 +-
 docs-ja/pages/tools-reference-ja.md                |   2 +-
 docs-ja/pages/vs-code-ja.md                        |  15 +-
 docs-ja/pages/web-quickstart-ja.md                 |   6 +-
 29 files changed, 684 insertions(+), 423 deletions(-)
```

<details>
<summary>artifacts-ja.md</summary>

```diff
diff --git a/docs-ja/pages/artifacts-ja.md b/docs-ja/pages/artifacts-ja.md
index 7bd02a8..99f86d2 100644
--- a/docs-ja/pages/artifacts-ja.md
+++ b/docs-ja/pages/artifacts-ja.md
@@ -142,5 +142,5 @@ Claude は他の人が書いたページを、[WebFetch](https://code.claude.com
 * **ネットワークアクセスのないクラウドセッション**：[クラウド環境](https://code.claude.com/docs/ja/cloud-environments.md#access-levels) の場合、**None** レベルがこれに該当します。[auto モード](https://code.claude.com/docs/ja/permission-modes.md#eliminate-prompts-with-auto-mode) では代わりに分類器が承認できますが、[Cowork](https://claude.com/product/cowork) セッションでは、承認できるのはユーザー本人だけです。
 * **別の組織の公開アーティファクト**：Claude Code は auto モードであっても、まずユーザーに確認します。`bypassPermissions` モードなど、Claude Code がユーザーに確認できない場合、Claude はそのアーティファクトを読むことができません。Claude がこれらのアーティファクトを読めるのは、[機能フラグの取得](https://code.claude.com/docs/ja/env-vars.md#features-that-need-feature-flag-fetching) がオンになっている間だけです。
-* **所有者またはネットワーク設定が未確認**：Claude Code がアーティファクトの作成者を確認できない場合、またはクラウドセッションのネットワーク設定を確認できない場合は確認を求めます。ユーザーの承認はその 1 回のリクエストにのみ適用されます。
+* **所有者またはネットワーク設定が未確認**：Claude Code がアーティファクトの作成者を確認できない場合、またはクラウドセッションのネットワーク設定を確認できない場合は確認を求めます。ユーザーの承認はその 1 回のリクエストにのみ適用されます。[auto モード](https://code.claude.com/docs/ja/permission-modes.md#eliminate-prompts-with-auto-mode) では、ユーザーに確認する代わりに、分類器が読み取りを承認またはブロックできます。
 * **plan モード**：[plan モード](https://code.claude.com/docs/ja/permission-modes.md#analyze-before-you-edit-with-plan-mode) では、Claude Code は、組織内の他の人が作成したアーティファクトを Artifact ツールが読む前に確認を求めます。
 
```

</details>

<details>
<summary>auto-mode-classifier-billing-ja.md</summary>

```diff
diff --git a/docs-ja/pages/auto-mode-classifier-billing-ja.md b/docs-ja/pages/auto-mode-classifier-billing-ja.md
index 9ce1285..7b230e0 100644
--- a/docs-ja/pages/auto-mode-classifier-billing-ja.md
+++ b/docs-ja/pages/auto-mode-classifier-billing-ja.md
@@ -30,5 +30,10 @@ We're changing auto mode to no longer charge for classifier requests in Claude C
 ## セッションを対応可能にする
 
-ゲートウェイが原因の場合、会社の管理者またはゲートウェイプロバイダーに、リクエストと返信を変更せずに通すよう依頼してください。つまり、ゲートウェイが認識しない `safeguards` リクエストフィールドなどのリクエストヘッダーとボディフィールドをそのまま転送し、`safeguard_results` フィールドなどのキーをドロップしたり、tool-use ID を書き換えたりせずにレスポンスとストリーミングイベントを返すことです。[ゲートウェイ互換性ガイド](https://code.claude.com/docs/ja/llm-gateway-protocol.md#feature-pass-through)で説明されているとおりです。このようにトラフィックを通すゲートウェイは、この機能と将来の機能で動作し続けます。その後、新しいセッションはサーバーのチェックを再度使用します。
+ゲートウェイが原因で auto モードのサーバー側チェックがセッションに届かず、そのゲートウェイを自分で運用していない場合は、以下の要件を会社の管理者またはゲートウェイプロバイダーに伝えてください。[ゲートウェイが受け取る形式をアップストリームが受け付ける](https://code.claude.com/docs/ja/llm-gateway-protocol.md#format-mismatch-with-the-upstream)場合、Claude Code は、[ゲートウェイ互換性ガイド](https://code.claude.com/docs/ja/llm-gateway-protocol.md#feature-pass-through)で説明されているとおり、ゲートウェイがリクエストとレスポンスを変更せずに通すことを想定しています。
+
+* **リクエスト**: チェックを通すために、ゲートウェイは `anthropic-beta` ヘッダーと `safeguards` ボディフィールドの両方を変更せずに転送します。[この 2 つはペアで送られる](https://code.claude.com/docs/ja/llm-gateway-protocol.md#beta-header-and-body-field-pairs)ためです。[Amazon Bedrock InvokeModel 形式](https://code.claude.com/docs/ja/llm-gateway-protocol.md#api-formats)では、ヘッダーの代わりに `anthropic_beta` ボディフィールドを転送します。
+* **レスポンス**: ゲートウェイは、フィールドをドロップしたり tool-use ID を書き換えたりせずに、レスポンスとストリーミングイベントを返します。チェックの結果を通すために、`safeguard_results` フィールドを保持します。
+
+このようにトラフィックを通すゲートウェイは、この機能と将来の機能で動作し続けます。その後、新しいセッションはサーバーのチェックを再度使用します。
 
 ゲートウェイがサーバーのチェックを提供できないことが既にわかっている場合、セッションを開始する前に、シェルまたは [`env` 設定キー](https://code.claude.com/docs/ja/settings-reference#env)で `CLAUDE_CODE_AUTO_MODE_SERVER` を `0` に設定して、Claude Code にそこでチェックを要求しないよう指示してください。
```

</details>

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index 2aae83b..cb9d948 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,153 @@
 # Changelog
 
+## 2.1.319
+
+- Changed auto mode with telemetry or feature flags off, including behind LLM gateways: calls the server can't check are asked about or denied, with no fallback to the built-in classifier; set `CLAUDE_CODE_AUTO_MODE_SERVER=0` to keep using it (Bedrock, Vertex and Foundry are unchanged)
+- Changed auto mode behind an LLM gateway: `CLAUDE_CODE_AUTO_MODE_SERVER=1` turns on the server-side check even with `CLAUDE_CODE_DISABLE_EXPERIMENTAL_BETAS` set; if managed settings set the latter, they must set the `1` too
+- Added support for MCP tasks in the terminal: when an MCP server runs a tool call as a task, Claude Code moves it to the background right away and tells Claude the result when it finishes
+- Added the `CLAUDE_CODE_DISABLE_MCP_TASK_BACKGROUND` environment variable to make Claude Code wait for an MCP task inside its tool call instead of moving it to the background right away
+- Added `permissions.denyInsteadOfPrompting` setting: a tool call that would wait on a permission prompt is denied and the turn continues, in terminal sessions, subagents and teammates
+- Added `/claude-api latency-optimize` to find where your Claude API code makes people wait and try faster settings against your eval
+- Added the `CLAUDE_CODE_DISABLE_FEATURE_FLAGS` environment variable, which stops feature-flag fetching without turning off telemetry; every flag then uses its built-in default
+- Added spend for today, this week and this month to `/usage` for developers behind a Claude apps gateway who have no spend limit, when the gateway runs this version or later
+- Added `admin.pooled_conflict_rule` and `admin.pooled_priority_order` to the Claude apps gateway, to set which pooled group budget pays first for a developer in several groups
+- Added an optional `login_notice` setting to the Claude apps gateway that shows an operator-defined message on the gateway's browser verification page and on Claude Code's sign-in screen
+- Added `CLAUDE_GATEWAY_LOG_FORMAT=json` to the Claude apps gateway: operational log lines become JSON with `severity`, `time` and `message`, for log collectors that read the level from a field
+- Added a Claude apps gateway boot warning for a case where another policy's `availableModels` also allows a custom model id that one policy lists by name
+- Added start-up warnings to the Claude apps gateway for policies with no `desktopHome` that rely on `coworkTabEnabled: false` or `chatSessionRetentionDays`, ahead of Claude Desktop's November 10 change
+- Added a warning when your claude.ai login ends and Claude Code continues on the sign-in from `ant auth login`, which bills usage to your Claude Console organization
+- Added a line at startup naming the Claude Console organization that is billed in a case where Claude Code uses the sign-in from `ant auth login`
+- Added an "Earlier in this session" row to `/tasks` that lists finished subagents, so you can reopen one and message it even after it leaves the list or you restart
+- Added a note to `/loop` confirmations in cloud sessions that a timer stops with its container, with an offer of a loop that survives
+- Fixed MCP servers on the older handshake failing to connect, or returning empty results, because Claude Code declared an extension that it only uses with newer servers
+- Fixed a long-running MCP tool call on a claude.ai connector sometimes never reporting its result after `--resume`
+- Fixed a session's diff failing to load on claude.ai and the mobile apps when the folder Claude Code runs in has a file or folder named `HEAD`
+- Fixed `/diff` showing "Diff unavailable" when a git repository has a file or folder named `HEAD` at its top level
```

</details>

<details>
<summary>claude-apps-gateway-ja.md</summary>

```diff
diff --git a/docs-ja/pages/claude-apps-gateway-ja.md b/docs-ja/pages/claude-apps-gateway-ja.md
index 12a46e8..785f3ed 100644
--- a/docs-ja/pages/claude-apps-gateway-ja.md
+++ b/docs-ja/pages/claude-apps-gateway-ja.md
@@ -351,5 +351,5 @@ Claude Code はゲートウェイに接続する前に `/login` でリストを
 ### Claude Desktop セッションにポリシーを配信する
 
-Claude Desktop は、各タブを組み込みの Claude Code セッション上で実行し、それらのモデルリクエストをゲートウェイ経由で送信します。Claude Desktop は、ゲートウェイが `/user/bootstrap` で提供する設定から構築したポリシーを、これらの各セッションに渡します。この設定には、一致したポリシーの `cli` ブロックまたは `code` ブロックから導出されるモデル許可リスト、無効化されたツール、エグレス許可リストに加えて、[`desktop` オーバーレイ](https://code.claude.com/docs/ja/claude-apps-gateway-config#claude-desktop-overlay)が含まれます。
+Claude Desktop は、そのタブを組み込みの Claude Code セッション上で実行し、それらのモデルリクエストをゲートウェイ経由で送信します。Claude Desktop は、ゲートウェイが `/user/bootstrap` で提供する設定から構築したポリシーを、これらの各セッションに渡します。この設定には、一致したポリシーの `cli` ブロックまたは `code` ブロックから導出されるモデル許可リスト、無効化されたツール、エグレス許可リストに加えて、[`desktop` オーバーレイ](https://code.claude.com/docs/ja/claude-apps-gateway-config#claude-desktop-overlay)が含まれます。
 
 フック、`env`、および `Bash(npm *)` のようなスコープ付き権限ルールなど、ブロックの他のキーは、`/login` を通じてサインインするクライアントに到達します。`code` の下にある場合、[Code タブの条件](https://code.claude.com/docs/ja/claude-apps-gateway-config.md#apply-code-settings-in-the-code-tab)が満たされていれば、Code タブのセッションにも到達します。Cowork セッションや Chat セッションには到達しません。Claude Desktop はゲートウェイ URL を独自の管理設定から読み取り、[ゲートウェイ URL を設定する](#set-the-gateway-url)の `forceLoginMethod` と `forceLoginGatewayUrl` キーとは別の独自のフローでサインインします。
@@ -522,5 +522,5 @@ Claude Desktop は同じブラウザ SSO ステップでゲートウェイのア
 | 100 万トークンのコンテキストウィンドウ | 利用可能 | Fable モデル、Sonnet 5 以降、Opus 4.7 以降は、デフォルトで 100 万トークンのウィンドウで動作します。[拡張コンテキスト](https://code.claude.com/docs/ja/model-config.md#extended-context)を参照してください。Fable モデルと Opus モデルで 100 万トークンをデフォルトにするには、開発者のマシン上で Claude Code v2.1.287 以降が必要です |
 | IdP グループごとのモデルアクセスと管理設定 | 利用可能 | モデルアクセスはサーバー側で適用されます。管理設定は IdP グループごとに配信され、CLI によって[管理設定の階層](https://code.claude.com/docs/ja/settings.md#settings-precedence)で適用されます |
-| Claude Desktop | オプトインで利用可能 | ポリシーで [`desktop` キー](https://code.claude.com/docs/ja/claude-apps-gateway-config#claude-desktop-overlay)を使ってオプトインします。ゲートウェイサーバー上で Claude Code v2.1.203 以降が必要です。 |
+| Claude Desktop | オプトインで利用可能 | [`desktop` キー](https://code.claude.com/docs/ja/claude-apps-gateway-config#claude-desktop-overlay)を使用してポリシーをオプトインします。ゲートウェイサーバー上で Claude Code v2.1.203 以降が必要です。 |
 | テレメトリのファンアウト（OTLP/HTTP） | 利用可能 | エクスポートごとに ID が付与されます。protobuf と JSON の両方のエンコーディングに対応しています |
 | OIDC ID プロバイダー | 利用可能 | OIDC に準拠した任意の IdP に対応しています。ゲートウェイは標準の OIDC ディスカバリーと認可コードフローを実行します。IdP ごとの設定については [ID プロバイダーのセットアップ](https://code.claude.com/docs/ja/claude-apps-gateway-deploy.md#identity-provider-setup)を参照してください |
```

</details>

<details>
<summary>cloud-environments-ja.md</summary>

```diff
diff --git a/docs-ja/pages/cloud-environments-ja.md b/docs-ja/pages/cloud-environments-ja.md
index 7c1893e..96e4079 100644
--- a/docs-ja/pages/cloud-environments-ja.md
+++ b/docs-ja/pages/cloud-environments-ja.md
@@ -122,5 +122,5 @@ Anthropic ホスト型環境では、セッションは環境の値をセッシ
 
 * **許可されたウェブサイト**: `api.example.com` などの API のホスト。先頭の `*.` はすべてのサブドメインと一致します
-* **カスタムヘッダー**: キーを運ぶヘッダーの 1 行。行には既に **ヘッダー名** として `Authorization`、**プレフィックス** として `Bearer` が入力されています。キー自体を **値** として貼り付けます。`X-Api-Key` のようなベア値を取るヘッダーの場合は、名前を変更してプレフィックスをクリアします
+* **カスタムヘッダー**: キーを運ぶヘッダーの 1 行。行には既に **ヘッダー名** として `Authorization`、**プレフィックス** として `Bearer` が入力されています。キー自体を **値** として貼り付けます。`X-Api-Key` のようなベア値を取得するヘッダーの場合、名前を変更してプレフィックスをクリアします
 
 別の方法で認証する API の場合、別の **シークレットタイプ** を選択します。リストは [Claude Tag](https://claude.com/docs/claude-tag/overview)（Team および Enterprise プランの Slack 統合）が [接続](https://claude.com/docs/claude-tag/admins/add-connections) に提供するものと同じです。
```

</details>

<details>
<summary>deep-links-ja.md</summary>

```diff
diff --git a/docs-ja/pages/deep-links-ja.md b/docs-ja/pages/deep-links-ja.md
index 7d2f610..4fb78ff 100644
--- a/docs-ja/pages/deep-links-ja.md
+++ b/docs-ja/pages/deep-links-ja.md
@@ -105,5 +105,5 @@ Enter キーを押して送信する前にプロンプトを編集できます
 ```
 
-独自のランブックでこれを使用するには、`acme/web-gateway` をサービスのリポジトリスラッグに置き換えます。エンジニアがステップ 2 をクリックする前に、そのマシンに [`claude-cli://` ハンドラーが登録](#registration-and-supported-platforms)されている必要があり、またローカルクローンまたは worktree で `claude` を実行しておく必要があります。
+独自のランブックでこれを使用するには、`acme/web-gateway` をサービスのリポジトリスラッグに置き換えます。エンジニアがステップ 2 をクリックする前に、そのマシンに [`claude-cli://` ハンドラーが登録されている](#registration-and-supported-platforms)必要があり、ローカルクローンまたは worktree で `claude` を実行しておく必要があります。
 
 ### シェルからリンクを開く
```

</details>

<details>
<summary>desktop-ios-simulator-ja.md</summary>

```diff
diff --git a/docs-ja/pages/desktop-ios-simulator-ja.md b/docs-ja/pages/desktop-ios-simulator-ja.md
index aedab83..3863920 100644
--- a/docs-ja/pages/desktop-ios-simulator-ja.md
+++ b/docs-ja/pages/desktop-ios-simulator-ja.md
@@ -5,5 +5,5 @@
 # iOS シミュレータでアプリをテストする
 
-> Claude Code Desktop は、Claude がアプリをビルド、実行、またはチェックするときに、iOS シミュレータペインでアプリを開きます。各セッションに対して個別のシミュレータが用意されます。
+> Claude Code Desktop は、Claude がアプリをビルド、実行、またはチェックするときに、iOS シミュレータペインでアプリを開きます。
 
 > [!NOTE]
@@ -64,5 +64,5 @@ Build the app and run it in the simulator to check the onboarding flow.
 アプリがシミュレータで起動すると、iOS シミュレータペインが会話の横に開きます。Claude がデバイスを初めて使用するときは、デスクトップアプリがアクセスを許可するよう求めます。[Claude にデバイスへのアクセスを許可する](#grant-claude-access-to-a-device)を参照してください。Claude はアプリをインストールし、タップして操作し、画面を読み取って独自の変更を検証しながら、あなたが見守ります。
 
-シミュレータペインは、Claude がセッション内のいずれかの時点でシミュレータでアプリを起動するたびに開きます。リクエストがアプリを見ることについてである場合、例えば「新しい画面は正しく見えますか？」という場合、Claude は作業を開始する前にシミュレータを起動します。Claude がバグを修正または画面を変更した後、変更を検証するよう依頼します。アプリを再起動すると、ペインが開いていない場合は再度開きます。
+リクエストがアプリを見ることについてである場合、例えば「新しい画面は正しく見えますか？」という場合、Claude は作業を開始する前にシミュレータを起動します。Claude がバグを修正または画面を変更した後、変更を検証するよう依頼してください。
 
 シミュレータペインは、アプリが実際に起動したデバイスを表示します。特定のデバイスでテストするには、リクエストでそれを指定します。例えば「iPhone SE シミュレータで実行してください」と言えば、Claude はビルドと起動時にそのデバイスをターゲットにします。
@@ -87,7 +87,14 @@ Claude が起動したデバイスは Apple の Simulator アプリにも表示
 あなたと Claude は同じデバイスを操作するため、あなたのタップは Claude が見るアプリの状態を変更します。Claude に特定の画面をチェックさせるには、タップして移動してから依頼します。Claude がデバイスを操作している間、ペインは画面の上に **Claude is using this device** バッジを表示します。バッジが消えるまでタップを控えて、結果があなたの入力ではなくアプリを反映するようにします。
 
+### シミュレータペインを最小化または閉じる
+
+シミュレータペインは最小化することも閉じることもでき、どちらの場合も Claude は引き続きデバイスを使用できます。
+
+* ペインを最小化すると、デバイスは小さいサイズで表示されたままになります。ペインを最小化する方法や再度展開する方法については、[ペインを最小化する](https://code.claude.com/docs/ja/desktop.md#minimize-a-pane)を参照してください。
+* フルサイズまたは最小化されたペインを閉じても、デバイスはアタッチされたまま実行され続けます。デバイスを再度表示するには、セッションのタイトルバーで **iOS Simulator** をクリックします。
+
 ## セッションがデバイスを管理する方法
 
```

</details>

<details>
<summary>desktop-ja.md</summary>

```diff
diff --git a/docs-ja/pages/desktop-ja.md b/docs-ja/pages/desktop-ja.md
index a9c2b7f..21bf31f 100644
--- a/docs-ja/pages/desktop-ja.md
+++ b/docs-ja/pages/desktop-ja.md
@@ -550,13 +550,16 @@ Claude Code はセッション間で 3 つの安全動作を適用します：
 
 * **そのセッションでオンにする**：セッションの **Remote Control** スイッチを使用するか、プロンプトボックスに `/remote-control` と入力します。
-* **開始時に接続される**：**Settings > Code** または **Settings > Claude Code** で **Connect new sessions to Remote Control** がオンの間、新しいセッションは自動的に接続されます。この設定を一度も変更していない場合、Desktop はユーザー設定または管理設定の [`remoteControlAtStartup`](https://code.claude.com/docs/ja/settings-reference#remotecontrolatstartup) に従い、次に組織のデフォルトに従います。
+* **開始時に接続される**：**Settings > Code** または **Settings > Claude Code** で **Connect new sessions to Remote Control** がオンの間、新しいセッションは自動的に接続されます。ただし、管理設定で [`remoteControlAtStartup`](https://code.claude.com/docs/ja/settings-reference#remotecontrolatstartup) が `false` の場合を除きます。**Connect new sessions to Remote Control** を一度も変更していない場合、Desktop はユーザー設定または管理設定の `remoteControlAtStartup` を使用します。どちらでも設定されていない場合、Desktop は組織のデフォルトを使用し、組織のデフォルトがない場合は Desktop 自体のデフォルトを使用します。
 
 セッションが接続されているかどうかを確認するには、[セッション詳細パネル](#see-session-details)の **Environment** カードにある **Remote Control** スイッチを確認します。
 
-セッションを他のデバイスに表示しないようにするには、必要なレベルで Remote Control をオフにします：
+#### セッションを他のデバイスに表示しないようにする
+
+1 つのセッション、このコンピュータ上のセッション、または管理するコンピュータに対して Remote Control をオフにします：
 
 * **1 つのセッション**：そのセッションの **Remote Control** スイッチをオフにします。開始時に接続されたセッションで `/remote-control` と入力すると、Remote Control はオンのままとなり、`Remote Control is already on. This session connected automatically when it started.` と表示されます。切断するには、その行の **Turn off** をクリックします。
-* **このコンピュータ上の新しい Desktop セッション**：**Settings > Code** または **Settings > Claude Code** で **Connect new sessions to Remote Control** をオフにします。すでにオフと表示されている場合は、一度オンにしてからオフにすると、Desktop が選択を保存します。保存されると、`remoteControlAtStartup` およびデフォルトよりも優先されます。
+* **このコンピュータ上の新しい Desktop セッション**：**Settings > Code** または **Settings > Claude Code** で **Connect new sessions to Remote Control** をオフにします。すでにオフと表示されている場合は、一度オンにしてからオフにすると、Desktop が選択を保存します。保存されると、`remoteControlAtStartup` やデフォルトが接続を指定していても、新しいセッションは自動的に接続されなくなります。
 * **CLI を含む、このコンピュータ上のすべてのセッション**：`~/.claude/settings.json` で [`disableRemoteControl`](https://code.claude.com/docs/ja/settings-reference#disableremotecontrol) を `true` に設定すると、セッションが接続されなくなります。ファイルを保存した時点ですでに接続されていたセッションは、そのセッションで Remote Control をオフにするまで接続されたままです。
+* **管理するコンピュータ上の Desktop セッション**：コンピュータの[最も優先度の高い MDM ポリシーまたは管理設定ファイル](https://code.claude.com/docs/ja/managed-settings.md#how-claude-code-combines-managed-sources)で `remoteControlAtStartup` を `false` に設定すると、[サーバー管理設定](https://code.claude.com/docs/ja/server-managed-settings.md)でこのキーが `true` であっても、そのコンピュータ上のセッションは自動的に接続されなくなります。この目的にはユーザーレベルの `HKCU` レジストリ値を使用しないでください。ユーザーは引き続き自分でセッションの Remote Control をオンにできます。これを防ぐには、[管理コンソール](#admin-console-controls)を使用してください。Claude Desktop v4.4212.0 以降が必要です。
 
 他のデバイスにすでに表示されているセッションを非表示にするには、Desktop でそのセッションをアーカイブします。Desktop はセッションの Remote Control 側のコピーもアーカイブするため、それらのデバイスのデフォルトのセッションリストから消えます。そこで表示または削除するには、[セッションをアーカイブする](https://code.claude.com/docs/ja/claude-code-on-the-web.md#archive-sessions)を参照してください。
@@ -2015,4 +2018,6 @@ HIPAA が有効になっている Enterprise 組織では、**Desktop** トグ
 | `managedMcpServers` | MCP サーバー設定をすべてのユーザーにプッシュします。サードパーティ（3P）Desktop デプロイでのみ利用可能です。各エントリで、`"http"`、`"sse"`、または`"stdio"`のトランスポート、接続詳細、およびオプションで、そのサーバーのどのツールをユーザーが呼び出せるかを制限する`toolPolicy`マップを設定します。管理設定ファイル、MDM、または Claude apps gateway ポリシーの[`desktop`ブロック](https://code.claude.com/docs/ja/claude-apps-gateway-config#claude-desktop-overlay)を通じて配信します。3P デプロイは管理コンソール設定を受け取らないためです。ゲートウェイを通じて配信するには、ゲートウェイサーバーで Claude Code v2.1.232 以降が必要です。これはデスクトップアプリ自体のキーです。Claude Code は、異なるエントリ形状を持つ、同じ名前の[管理設定](https://code.claude.com/docs/ja/managed-mcp.md#provide-servers-through-managed-settings)を読み取ります。 |
 
+コンピューターの[最上位の MDM ポリシーまたは管理設定ファイル](https://code.claude.com/docs/ja/managed-settings.md#how-claude-code-combines-managed-sources)で`browserExternalPageTools`、`disableMobileSimulatorTools`、または`disableBrowserExternalNavigation`を使用して機能をオフにすると、そのコンピューターではその機能がオフのままになります。[サーバー管理設定](https://code.claude.com/docs/ja/server-managed-settings.md)でそのキーが未設定の場合や、その機能が許可されている場合でも、オフのままです。この目的でユーザーレベルの`HKCU`レジストリ値を使用しないでください。機能をオンに戻すには、値を設定した場所からその値を削除してください。Claude Desktop v4.4212.0 以降が必要です。
+
 Desktop セッションがどこで実行されるかに応じて、どの管理設定がそのセッションに到達するかが異なります。[`availableModels`](https://code.claude.com/docs/ja/model-config#restrict-model-selection)などのモデル制限は、Desktop の Claude Code セッションでターミナル CLI と同じ方法で適用されます。[surface coverage](https://code.claude.com/docs/ja/model-config.md#surface-coverage)を参照してください。
```

</details>

<details>
<summary>desktop-linux-ja.md</summary>

```diff
diff --git a/docs-ja/pages/desktop-linux-ja.md b/docs-ja/pages/desktop-linux-ja.md
index 43fb8f5..11a9497 100644
--- a/docs-ja/pages/desktop-linux-ja.md
+++ b/docs-ja/pages/desktop-linux-ja.md
@@ -54,5 +54,5 @@ gpg --show-keys /usr/share/keyrings/claude-desktop-archive-keyring.asc
 ```
 
-gpg が出力するフィンガープリントは `31DDDE24DDFAB679F42D7BD2BAA929FF1A7ECACE` である必要があります。gpg がファイルを開けない、または有効な OpenPGP データが含まれていないと報告する場合は、ダウンロードが失敗したか、間違ったコンテンツが返されました。ネットワークが `downloads.claude.ai` に到達できることを確認してから、ダウンロードコマンドを再度実行してください。
+gpg が出力するフィンガープリントは `31DDDE24DDFAB679F42D7BD2BAA929FF1A7ECACE` のみである必要があります。gpg がファイルを開けない、または有効な OpenPGP データが含まれていないと報告する場合は、ダウンロードが失敗したか、間違ったコンテンツが返されました。ネットワークが `downloads.claude.ai` に到達できることを確認してから、ダウンロードコマンドを再度実行してください。
 
 リポジトリを登録します。
```

</details>

*...以降省略*

</details>


<details>
<summary>2026-11-06</summary>

**変更ファイル:**

```
 docs-ja/pages/agent-teams-ja.md                       |  2 +-
 docs-ja/pages/channels-ja.md                          |  2 +-
 docs-ja/pages/claude-apps-gateway-config-ja.md        |  2 +-
 docs-ja/pages/claude-apps-gateway-deploy-ja.md        |  2 ++
 docs-ja/pages/claude-apps-gateway-ja.md               | 10 ++++------
 docs-ja/pages/claude-apps-gateway-on-aws-ja.md        |  1 +
 docs-ja/pages/claude-apps-gateway-on-gcp-ja.md        |  1 +
 docs-ja/pages/claude-projects-ja.md                   | 11 ++++++-----
 docs-ja/pages/cloud-environments-ja.md                |  8 +++-----
 docs-ja/pages/code-review-customize-ja.md             | 19 ++++++++++++++++---
 docs-ja/pages/data-usage-ja.md                        |  2 +-
 docs-ja/pages/deep-links-ja.md                        |  2 +-
 docs-ja/pages/desktop-ios-simulator-ja.md             |  7 ++++---
 docs-ja/pages/env-vars-ja.md                          |  2 +-
 docs-ja/pages/errors-ja.md                            | 19 ++++++++++++++-----
 docs-ja/pages/permission-modes-ja.md                  |  2 +-
 docs-ja/pages/permissions-ja.md                       | 11 +++++++----
 docs-ja/pages/prompt-caching-ja.md                    |  2 +-
 .../self-hosted-environments-configuration-ja.md      | 14 +++++++++++---
 docs-ja/pages/settings-reference-ja.md                | 16 +++++++++-------
 docs-ja/pages/slack-ja.md                             | 17 +++++++----------
 docs-ja/pages/terminal-config-ja.md                   |  8 ++++----
 docs-ja/pages/web-quickstart-ja.md                    | 10 ++++++----
 23 files changed, 103 insertions(+), 67 deletions(-)
```

<details>
<summary>agent-teams-ja.md</summary>

```diff
diff --git a/docs-ja/pages/agent-teams-ja.md b/docs-ja/pages/agent-teams-ja.md
index 9855c18..e2a4c53 100644
--- a/docs-ja/pages/agent-teams-ja.md
+++ b/docs-ja/pages/agent-teams-ja.md
@@ -297,5 +297,5 @@ Claude がすでに実行されていないインプロセスのチームメイ
 > 編集前に確認を求めるようにするには、エージェントパネルの `main` 行で Enter を押し、リーダーも Manual モードに切り替えてください。これにより、リーダーも確認を求めるようになり、Manual モードの他のチームメイトも同様に確認を求めます。
 
-生成時にチームメイトごとの権限モードを設定することはできません。新しいチームメイトはリーダーのモードで開始されます。これには、`--dangerously-skip-permissions` によってオンになる `bypassPermissions` モードも含まれます。リーダーが [`dontAsk` モード](https://code.claude.com/docs/ja/permission-modes#allow-only-pre-approved-tools-with-dontask-mode)の場合、チームメイトは代わりに [Manual モード](https://code.claude.com/docs/ja/permission-modes.md#available-modes)で開始されます。
+生成時にチームメイトごとの権限モードを設定することはできません。新しいチームメイトはリーダーのモードで開始されます。これには、`--dangerously-skip-permissions` によってオンになる `bypassPermissions` モードも含まれます。リーダーが [`dontAsk` モード](https://code.claude.com/docs/ja/permission-modes#allow-only-pre-approved-tools-with-dontask-mode)の場合、チームメイトは代わりに [Manual モード](https://code.claude.com/docs/ja/permission-modes.md#available-modes)で開始されます。リーダーが Manual モードまたは `dontAsk` モードである分割ペインのチームメイトの場合、これには Claude Code v2.1.317 以降が必要です。
 
 [インプロセス](#choose-a-display-mode)のチームメイトはリーダーの現在の許可ルールと拒否ルールの下で実行されるため、[`--disallowedTools`](https://code.claude.com/docs/ja/cli-reference#cli-flags)、`--tools`、`--allowedTools` はすべてこのチームメイトに適用されます。分割ペインのチームメイトの場合は、フラグごとに確認してください。
```

</details>

<details>
<summary>channels-ja.md</summary>

```diff
diff --git a/docs-ja/pages/channels-ja.md b/docs-ja/pages/channels-ja.md
index deeae07..dd9db4f 100644
--- a/docs-ja/pages/channels-ja.md
+++ b/docs-ja/pages/channels-ja.md
@@ -355,5 +355,5 @@ Claude Code のいくつかの機能はターミナルの外のシステムに
 | - | - | - |
 | [クラウドセッション](https://code.claude.com/docs/ja/claude-code-on-the-web.md) | GitHub からクローンされた新しいクラウドサンドボックスでタスクを実行 | 後で確認する自己完結型の非同期作業を委任する |
-| [Slack の Claude](https://code.claude.com/docs/ja/slack.md) | チャネルまたはスレッドの `@Claude` メンションからクラウドセッションを生成 | チームの会話コンテキストから直接タスクを開始する |
+| [Slack の Claude](https://code.claude.com/docs/ja/slack.md) | チャンネルまたはスレッドの `@Claude` メンションからクラウドセッションを生成 | チームの会話から直接タスクを開始する |
 | 標準 [MCP サーバー](https://code.claude.com/docs/ja/mcp.md) | Claude はタスク中にそれをクエリします。セッションには何もプッシュされません | Claude にシステムを読み取るまたはクエリするオンデマンドアクセスを提供する |
 | [Remote Control](https://code.claude.com/docs/ja/remote-control.md) | claude.ai または Claude モバイルアプリからローカルセッションを駆動 | デスクから離れている間に進行中のセッションを操舵する |
```

</details>

<details>
<summary>claude-apps-gateway-config-ja.md</summary>

```diff
diff --git a/docs-ja/pages/claude-apps-gateway-config-ja.md b/docs-ja/pages/claude-apps-gateway-config-ja.md
index be1b421..4b432c5 100644
--- a/docs-ja/pages/claude-apps-gateway-config-ja.md
+++ b/docs-ja/pages/claude-apps-gateway-config-ja.md
@@ -1650,5 +1650,5 @@ load_test_mode:
 | `reply_seconds` | いいえ | デフォルト `9.5`。ストリーミング返信にかかる時間で、0 から 600 までです。`0` は返信全体を一度に送信します。非ストリーミングリクエストへの返信は常に一度に返されます。 |
 
-このモードでのロードテストは、ゲートウェイ、Postgres、およびゲートウェイの前段にあるすべてのものをカバーします。プロバイダーの制限、速度、ネットワークパスはカバーしません。
+このモードでの負荷テストは、ゲートウェイ、Postgres、およびゲートウェイの前段にあるすべてを対象とします。プロバイダーの制限、速度、ネットワーク経路や、各レプリカの[同時アップストリームリクエスト数の上限](https://code.claude.com/docs/ja/claude-apps-gateway-deploy.md#concurrent-upstream-requests)での待機は対象外です。開いているリクエストがその上限を超えた場合、つまり本番環境のリクエストが待機し始める時点では、レプリカは引き続き `client requests are open` 警告をログに記録します。
 
 プロバイダーにはモデルリクエストが送信されないため、レプリカのリクエストあたりの CPU は見積もりであり、プロバイダーへのトラフィックも暗号化する本番環境より低く表示されます。レプリカ数は、実際のプロバイダーに対する小規模なパイロットで確認してください。v2.1.283 より前では、見積もりはさらに大幅に低く表示されます。
```

</details>

<details>
<summary>claude-apps-gateway-deploy-ja.md</summary>

```diff
diff --git a/docs-ja/pages/claude-apps-gateway-deploy-ja.md b/docs-ja/pages/claude-apps-gateway-deploy-ja.md
index d84e6eb..770c8e3 100644
--- a/docs-ja/pages/claude-apps-gateway-deploy-ja.md
+++ b/docs-ja/pages/claude-apps-gateway-deploy-ja.md
@@ -203,4 +203,6 @@ CPU に基づいてオートスケールしている場合、上限に達した
 > 開いているリクエストはすべて、ストリーミング中および空きスロットの待機中に、ゲートウェイプロセスのメモリを保持します。上限を 256 のままにしていても、待機中のリクエストはリクエストボディを保持するため、過負荷のレプリカのメモリは増え続けます。ピーク時に開いているリクエスト数に合わせてコンテナのメモリを見積もり、上限を変更する際はメモリを監視してください。メモリ不足になったレプリカは強制終了され、保持しているすべてのストリームが切断されます。
 
+[`load_test_mode`](https://code.claude.com/docs/ja/claude-apps-gateway-config#load_test_mode) を使用した負荷テストでは、リクエストはこの上限で待機しませんが、レプリカは引き続き `client requests are open` の警告をログに記録します。
+
 ### `API_TIMEOUT_MS` をゲートウェイの最初のバイトまでの時間より大きく保つ
 
```

</details>

<details>
<summary>claude-apps-gateway-ja.md</summary>

```diff
diff --git a/docs-ja/pages/claude-apps-gateway-ja.md b/docs-ja/pages/claude-apps-gateway-ja.md
index 749e224..12a46e8 100644
--- a/docs-ja/pages/claude-apps-gateway-ja.md
+++ b/docs-ja/pages/claude-apps-gateway-ja.md
@@ -351,5 +351,5 @@ Claude Code はゲートウェイに接続する前に `/login` でリストを
 ### Claude Desktop セッションにポリシーを配信する
 
-Claude Desktop は、Cowork タブと Code タブ、および有効にした場合は Chat を、組み込みの Claude Code セッション上で実行し、それらのモデルリクエストをゲートウェイ経由で送信します。Claude Desktop は、ゲートウェイが `/user/bootstrap` で提供する設定から構築したポリシーを、これらの各セッションに渡します。このポリシーには、一致したポリシーの `cli` ブロックまたは `code` ブロックから導出されるモデル許可リスト、無効化されたツール、エグレス許可リストに加えて、[`desktop` オーバーレイ](https://code.claude.com/docs/ja/claude-apps-gateway-config#claude-desktop-overlay)が含まれます。
+Claude Desktop は、各タブを組み込みの Claude Code セッション上で実行し、それらのモデルリクエストをゲートウェイ経由で送信します。Claude Desktop は、ゲートウェイが `/user/bootstrap` で提供する設定から構築したポリシーを、これらの各セッションに渡します。この設定には、一致したポリシーの `cli` ブロックまたは `code` ブロックから導出されるモデル許可リスト、無効化されたツール、エグレス許可リストに加えて、[`desktop` オーバーレイ](https://code.claude.com/docs/ja/claude-apps-gateway-config#claude-desktop-overlay)が含まれます。
 
 フック、`env`、および `Bash(npm *)` のようなスコープ付き権限ルールなど、ブロックの他のキーは、`/login` を通じてサインインするクライアントに到達します。`code` の下にある場合、[Code タブの条件](https://code.claude.com/docs/ja/claude-apps-gateway-config.md#apply-code-settings-in-the-code-tab)が満たされていれば、Code タブのセッションにも到達します。Cowork セッションや Chat セッションには到達しません。Claude Desktop はゲートウェイ URL を独自の管理設定から読み取り、[ゲートウェイ URL を設定する](#set-the-gateway-url)の `forceLoginMethod` と `forceLoginGatewayUrl` キーとは別の独自のフローでサインインします。
@@ -477,10 +477,8 @@ OS ポリシー（HKLM レジストリポリシーまたは管理設定プリス
 ### Claude Desktop を接続する
 
-[Claude Desktop](https://code.claude.com/docs/ja/desktop.md)は異なる MDM キーを通じて同じゲートウェイに接続します。Claude Desktop の[管理設定](https://claude.com/docs/third-party/claude-desktop/configuration)で `bootstrapUrl` を `<listen.public_url>/user/bootstrap` に設定し、ユーザーのポリシーを `desktop` キーでオプトインします。[Claude Desktop オーバーレイ](https://code.claude.com/docs/ja/claude-apps-gateway-config.md#claude-desktop-overlay)は両方の部分をカバーしています。ゲートウェイサーバーで Claude Code v2.1.203 以降が必要です。
+[Claude Desktop](https://code.claude.com/docs/ja/desktop.md)は異なる MDM キーを通じて同じゲートウェイに接続します。Claude Desktop の[管理設定](https://claude.com/docs/third-party/claude-desktop/configuration)で `bootstrapUrl` を `<listen.public_url>/user/bootstrap` に設定し、ユーザーのポリシーを `desktop` キーでオプトインします。[Claude Desktop オーバーレイ](https://code.claude.com/docs/ja/claude-apps-gateway-config.md#claude-desktop-overlay)は両方の部分をカバーしています。ゲートウェイサーバーで Claude Code v2.1.203 以降が必要です。接続すると、Claude Desktop は有効なすべてのタブからモデルリクエストをゲートウェイを通じて送信します。
 
 Claude Desktop は同じブラウザ SSO ステップでゲートウェイのアイデンティティプロバイダーを通じて開発者にサインインし、Anthropic ではなくゲートウェイから設定をフェッチします。モデルアクセスとポリシーは CLI と同じグループごとのルールに従います。CLI と Claude Desktop の両方を使用する開発者は各々に個別にサインインします。ゲートウェイセッションはそれらの間で共有されません。
 
-接続すると、Claude Desktop は有効なすべてのタブからモデルリクエストをゲートウェイを通じて送信します。デフォルトで Cowork タブと Code タブを表示します。Chat も利用できるようにするには、Claude Code v2.1.227 以降を実行しているゲートウェイで、ポリシーの [`desktop` ブロック](https://code.claude.com/docs/ja/claude-apps-gateway-config#claude-desktop-overlay)で `chatTabEnabled` を `true` に設定します。Cowork がオンの場合、Claude Desktop は Chat と Cowork を 1 つのタブにまとめて表示します。
-
 ### CI パイプラインとリモートマシン
 
@@ -524,5 +522,5 @@ Claude Desktop は同じブラウザ SSO ステップでゲートウェイのア
 | 100 万トークンのコンテキストウィンドウ | 利用可能 | Fable モデル、Sonnet 5 以降、Opus 4.7 以降は、デフォルトで 100 万トークンのウィンドウで動作します。[拡張コンテキスト](https://code.claude.com/docs/ja/model-config.md#extended-context)を参照してください。Fable モデルと Opus モデルで 100 万トークンをデフォルトにするには、開発者のマシン上で Claude Code v2.1.287 以降が必要です |
 | IdP グループごとのモデルアクセスと管理設定 | 利用可能 | モデルアクセスはサーバー側で適用されます。管理設定は IdP グループごとに配信され、CLI によって[管理設定の階層](https://code.claude.com/docs/ja/settings.md#settings-precedence)で適用されます |
-| Claude Desktop | オプトインで利用可能 | ポリシーで [`desktop` キーによりオプトイン](https://code.claude.com/docs/ja/claude-apps-gateway-config#claude-desktop-overlay)すると、ゲートウェイは `/user/bootstrap` で Claude Desktop の設定を提供し、Claude Desktop はゲートウェイ経由でモデルリクエストを送信します。Chat をオンにするには、[Claude Desktop を接続する](#connect-claude-desktop)を参照してください。ゲートウェイサーバー上で Claude Code v2.1.203 以降が必要です。 |
+| Claude Desktop | オプトインで利用可能 | ポリシーで [`desktop` キー](https://code.claude.com/docs/ja/claude-apps-gateway-config#claude-desktop-overlay)を使ってオプトインします。ゲートウェイサーバー上で Claude Code v2.1.203 以降が必要です。 |
 | テレメトリのファンアウト（OTLP/HTTP） | 利用可能 | エクスポートごとに ID が付与されます。protobuf と JSON の両方のエンコーディングに対応しています |
 | OIDC ID プロバイダー | 利用可能 | OIDC に準拠した任意の IdP に対応しています。ゲートウェイは標準の OIDC ディスカバリーと認可コードフローを実行します。IdP ごとの設定については [ID プロバイダーのセットアップ](https://code.claude.com/docs/ja/claude-apps-gateway-deploy.md#identity-provider-setup)を参照してください |
```

</details>

<details>
<summary>claude-apps-gateway-on-aws-ja.md</summary>

```diff
diff --git a/docs-ja/pages/claude-apps-gateway-on-aws-ja.md b/docs-ja/pages/claude-apps-gateway-on-aws-ja.md
index 7cdda40..0707e09 100644
--- a/docs-ja/pages/claude-apps-gateway-on-aws-ja.md
+++ b/docs-ja/pages/claude-apps-gateway-on-aws-ja.md
@@ -629,4 +629,5 @@ managed:
 * [設定リファレンス](https://code.claude.com/docs/ja/claude-apps-gateway-config.md)：すべての `gateway.yaml` オプション。`managed.policies` と `telemetry` を含む
 * [デプロイメントと運用](https://code.claude.com/docs/ja/claude-apps-gateway-deploy.md)：IdP セットアップ、ヘルスチェック、JWT シークレットローテーション、アップグレード、およびセキュリティモデル
+* [負荷テストモード](https://code.claude.com/docs/ja/claude-apps-gateway-config.md#load_test_mode)：モデルプロバイダーを呼び出さずにゲートウェイの負荷テストを行う
 * [Claude apps gateway 概要](https://code.claude.com/docs/ja/claude-apps-gateway)：クイックスタートと開発者の接続
 * [Claude apps gateway の AWS サンプル](https://github.com/aws-samples/anthropic-on-aws/tree/main/claude-apps-gateway)：顧客環境の範囲をカバーする AWS 保守デプロイメントサンプル
```

</details>

<details>
<summary>claude-apps-gateway-on-gcp-ja.md</summary>

```diff
diff --git a/docs-ja/pages/claude-apps-gateway-on-gcp-ja.md b/docs-ja/pages/claude-apps-gateway-on-gcp-ja.md
index 56d8583..2f2a2c7 100644
--- a/docs-ja/pages/claude-apps-gateway-on-gcp-ja.md
+++ b/docs-ja/pages/claude-apps-gateway-on-gcp-ja.md
@@ -317,3 +317,4 @@ upstreams:
 * [設定リファレンス](https://code.claude.com/docs/ja/claude-apps-gateway-config.md)：すべての `gateway.yaml` オプション（`managed.policies` および `telemetry` を含む）
 * [デプロイメントと運用](https://code.claude.com/docs/ja/claude-apps-gateway-deploy.md)：IdP セットアップ、ヘルスチェック、JWT シークレットローテーション、アップグレード、およびセキュリティモデル
+* [負荷テストモード](https://code.claude.com/docs/ja/claude-apps-gateway-config.md#load_test_mode)：モデルプロバイダーを呼び出さずにゲートウェイを負荷テストする
 * [Claude apps gateway 概要](https://code.claude.com/docs/ja/claude-apps-gateway)：クイックスタートと開発者の接続
```

</details>

<details>
<summary>claude-projects-ja.md</summary>

```diff
diff --git a/docs-ja/pages/claude-projects-ja.md b/docs-ja/pages/claude-projects-ja.md
index b96f608..1640b03 100644
--- a/docs-ja/pages/claude-projects-ja.md
+++ b/docs-ja/pages/claude-projects-ja.md
@@ -96,5 +96,5 @@
 
 * **Name**：**Projects** リストでプロジェクトがどのように表示されるか。
-* **Goal**（オプション）：「p95 API レイテンシを 200 ms 以下に保つ」など、達成しようとしていることの 1 行の説明。会話内の Claude はそれに向かって作業します。ゴールがない場合、Claude は送信したタスクから作業し、後で **Project settings > General** でゴールを追加できます。
+* **What do you want to work on?**（オプション）：プロジェクトのゴールになる 1 行の説明。「p95 API レイテンシを 200 ms 以下に保つ」など。会話内の Claude はそれに向かって作業します。ゴールがない場合、Claude は送信したタスクから作業し、後で **Project settings > General** でゴールを追加できます。
 * **Context**（オプション）：このプロジェクトが作業する GitHub リポジトリ、およびスレッドが読むべきファイル、フォルダ、または Google Drive フォルダ。各項目に対して **Add** をクリックします。作業が触れる可能性のあるすべてのリポジトリではなく、ほとんどのタスクが必要とするリポジトリを追加します。[追加するリポジトリを決定する](#decide-which-repositories-to-add)で選択について説明しており、後で **Project settings > Environment** でさらに追加できます。
 
@@ -389,4 +389,5 @@ Claude は**デバイス上のフォルダーで作業することを Claude に
 | 使用量 | Usage | スレッドおよびモデル別の [トークン使用量](#usage-and-cost) |
 | Memory | Memory | プロジェクトの [メモリファイル](#give-a-project-standing-context) |
+| 使用制限のリセット時に自動継続 | General | [使用制限で停止した](#usage-limit-reached)スレッドまたはプロジェクト会話が、制限のリセット時に自動的に続行するかどうか。デフォルトでオンです。 |
 | Claude を再起動 | General | [Claude が応答していない](#claude-hasnt-responded) 場合、プロジェクト会話を再起動します |
 | 一時停止、アーカイブ、削除 | General | プロジェクトを停止、非表示、削除します。[プロジェクトを一時停止、アーカイブ、削除する](#pause-archive-or-delete-a-project) を参照してください |
@@ -404,5 +405,5 @@ Claude は**デバイス上のフォルダーで作業することを Claude に
 プロジェクトの使用状況は、他の Claude Code セッションと同じ[プラン制限](https://code.claude.com/docs/ja/errors.md#youve-hit-your-session-limit)にカウントされ、プロジェクト自体がその制限を超えて使用することはできません。
 
-スレッドがプランの制限に達すると、制限がリセットされるまで待機し、制限がリセットされると自動的に続行されるため、実行中のまま残した作業は、メッセージなしで次の使用期間を使用し始めます。[スレッドが使用制限に達した](#usage-limit-reached)では、表示される内容、停止方法、および待機しない 1 つのケースについて説明しています。
+プランの制限で停止したスレッドは待機し、デフォルトでは制限がリセットされると自動的に続行されます。その後の作業は次の使用期間にカウントされます。スレッドが続行しないようにするには、[スレッドが使用制限に達した](#usage-limit-reached)を参照してください。
 
 作業がプランの制限を超えるのは、アカウントで[使用クレジット](https://code.claude.com/docs/ja/costs.md#add-usage-credits-to-your-subscription)をオンにしている場合のみです。スレッドがあなたのためにそれをオンにすることはできません。
@@ -485,7 +486,7 @@ Claude が実行中だが、その返信がプロジェクトに到達してい
 ### スレッドが使用制限に達した
 
-スレッドまたはプロジェクト会話がプランの 5 時間または週間制限に達すると、自動的に再試行を続け、制限がリセットされると続行されます。スケジュールタスクが開始したスレッドは待機しません。そのターンは制限エラーで停止します。制限がリセットされた後に、そのスレッドにメッセージを送信してください。
+スレッドまたはプロジェクト会話がプランの 5 時間または週間の制限で停止すると、待機し、デフォルトでは制限がリセットされたときに自動的に続行されます。
 
```

</details>

<details>
<summary>cloud-environments-ja.md</summary>

```diff
diff --git a/docs-ja/pages/cloud-environments-ja.md b/docs-ja/pages/cloud-environments-ja.md
index 96f7cbf..7c1893e 100644
--- a/docs-ja/pages/cloud-environments-ja.md
+++ b/docs-ja/pages/cloud-environments-ja.md
@@ -121,7 +121,6 @@ Anthropic ホスト型環境では、セッションは環境の値をセッシ
 **シークレットを追加**（管理設定では **追加** と表示）を選択してフォームに入力します。API キーがリクエストヘッダーで移動する場合はデフォルトの **シークレットタイプ**、**Bearer** を保持し、これらのフィールドに入力します。
 
-* **名前**: `Internal billing API` などのシークレットのラベル
 * **許可されたウェブサイト**: `api.example.com` などの API のホスト。先頭の `*.` はすべてのサブドメインと一致します
-* **カスタムヘッダー**: キーを運ぶヘッダーの 1 行。行は `Authorization` をヘッダーの **名前** として、`Bearer` を **プレフィックス** として開始します。キー自体を **値** として貼り付けます。`X-Api-Key` のようなベア値を取得するヘッダーの場合、名前を変更してプレフィックスをクリアします
+* **カスタムヘッダー**: キーを運ぶヘッダーの 1 行。行には既に **ヘッダー名** として `Authorization`、**プレフィックス** として `Bearer` が入力されています。キー自体を **値** として貼り付けます。`X-Api-Key` のようなベア値を取るヘッダーの場合は、名前を変更してプレフィックスをクリアします
 
 別の方法で認証する API の場合、別の **シークレットタイプ** を選択します。リストは [Claude Tag](https://claude.com/docs/claude-tag/overview)（Team および Enterprise プランの Slack 統合）が [接続](https://claude.com/docs/claude-tag/admins/add-connections) に提供するものと同じです。
@@ -138,6 +137,5 @@ Team または Enterprise プランで [組織管理者ロール](#requirements)
 
 * **ホスト**: シークレットを受け取る 1 つのホスト（`api.example.com` など）。フォームは `*.` ワイルドカードを受け付けません
-* **名前**: シークレットの任意のラベル
-* **シークレットタイプ**: リクエストヘッダーで送信されるキーの場合は **トークン**、または **ユーザー名とパスワード**。トークンの場合は、キーを **値** として貼り付けます
+* **シークレットタイプ**: リクエストヘッダーで送信されるキーの場合は **トークン**、または **ユーザー名とパスワード**。トークンの場合は、キーを **トークン** フィールドに貼り付けます。`X-Api-Key` など `Authorization` 以外のヘッダーの場合は、**ヘッダー** をその名前に変更します
 
 #### どのリクエストがシークレットを取得するか
@@ -446,5 +444,5 @@ apt update && apt install -y shellcheck
 セットアップスクリプトには、対応する 4 つの制約があります。
 
-* **ゼロで終了**：スクリプトがゼロ以外で終了する場合、セッションは開始に失敗します。非重要なコマンドに `|| true` を追加して、一時的なインストール失敗がセッションをブロックしないようにします。
+* **ゼロで終了**：スクリプトがゼロ以外で終了する場合、セッションは [開始に失敗](https://code.claude.com/docs/ja/web-quickstart.md#setup-script-failed) するか、スクリプトがインストールに失敗したものがない状態で開始されます。非重要なコマンドに `|| true` を追加して、一時的なインストール失敗によってスクリプトが失敗しないようにします。
 * **5 分以内に完了**：スクリプトの総実行時間を約 5 分以内に保つため、[環境キャッシュ](#environment-caching) をビルドできます。セットアップが 5 分以上かかる場合、環境はキャッシュされません。独立したインストールを `&` と `wait` で並列実行し、フィットしない単一ダウンロードを [SessionStart フック](#setup-scripts-vs-sessionstart-hooks) に移動して、バックグラウンドで起動します。新しいセッションがセットアップ中にハングまたはタイムアウトする場合は、[新しいセッションがセットアップ中にハングまたはタイムアウトする](https://code.claude.com/docs/ja/web-quickstart.md#new-sessions-hang-or-time-out-during-setup) を参照してください。
 * **インストール用のネットワークアクセス**：パッケージインストールはレジストリに到達する必要があります。デフォルトの **Trusted** レベルは npm、PyPI、RubyGems、crates.io を含む [一般的なパッケージレジストリ](#default-allowed-domains) をカバーします。**None** ネットワークアクセスでは、インストールは失敗します。
```

</details>

<details>
<summary>code-review-customize-ja.md</summary>

```diff
diff --git a/docs-ja/pages/code-review-customize-ja.md b/docs-ja/pages/code-review-customize-ja.md
index 261ced3..ee7182a 100644
--- a/docs-ja/pages/code-review-customize-ja.md
+++ b/docs-ja/pages/code-review-customize-ja.md
@@ -26,5 +26,5 @@ Code Review は、リポジトリの `CLAUDE.md` ファイルをプロジェク
 ## レビュー専用のルールには REVIEW\.md を使用する
 
-`REVIEW.md` は、Code Review をリポジトリに合わせて調整するための、リポジトリのルートに置くファイルです。サブディレクトリに `REVIEW.md` を追加して、ルートのファイルに加えて、そのパス配下の変更に対するチェックを追加することもできます。
+`REVIEW.md` は、Code Review をリポジトリに合わせて調整するための、リポジトリのルートに置くファイルです。[保護されたブランチ](#what-a-review-reads-for-each-branch-setup)では、[ほとんどのサブディレクトリ](#when-a-subdirectory-review-md-doesnt-apply)に `REVIEW.md` を追加して、ルートのファイルに加えて、そのサブディレクトリ配下の変更に対するチェックを追加することもできます。
 
 問題を検出するエージェントと、それを検証するエージェントは、Code Review のデフォルトのレビューガイダンスとともに、このファイルの内容をリポジトリのレビュー指示として受け取ります。最終的なレビューを書き出すステップでは、重大度を確定してサマリーを書く前にこのファイルを参照します。
@@ -47,4 +47,17 @@ your-repo/
 > Code Review サービスとローカルの [`/code-review` コマンド](https://code.claude.com/docs/ja/code-review-local)は別々のツールであり、読み込むファイルが異なります。サービスは `CLAUDE.md` と `REVIEW.md` の両方を読み込みます。自分のマシン上の Claude Code セッション内で実行する `/code-review` コマンドは、`CLAUDE.md` ファイルを読み込みますが、`REVIEW.md` は読み込みません。両方で適用したいガイダンスは `CLAUDE.md` に記述し、`REVIEW.md` はプルリクエストのレビューに固有のルールのために使用してください。
 
+### サブディレクトリの REVIEW\.md が適用されない場合
+
+Code Review は、次のいずれかの名前を持つサブディレクトリ内またはその配下にある `REVIEW.md` を、そのサブディレクトリの内容にかかわらず適用しません。サブディレクトリ名は名前全体としてのみ一致し、大文字と小文字は区別されず、どの階層でも一致します。そのため、`Tests` は一致しますが、`integration-tests` は一致しません。
+
+* **テスト**：`test`、`tests`、`__tests__`、`testdata`、`fixtures`、`__fixtures__`、`golden`、`corpus`、`snapshots`、`__snapshots__`
+* **サンプル**：`example`、`examples`、`sample`、`samples`、`demo`、`demos`
+* **生成コード**：`generated`
+* **サードパーティのコード**：`vendor`、`third_party`、`third-party`、`thirdparty`、`node_modules`、`bower_components`、`external`、`extern`、`deps`、`godeps`、`pods`、`carthage`、`site-packages`、`contrib`
+
+これらのサブディレクトリに対するチェックは、ルートの `REVIEW.md` に記述してください。または、親サブディレクトリ自体もそれより上のどのディレクトリもリストに含まれていない場合は、その親サブディレクトリの `REVIEW.md` に記述してください。
+
+プルリクエストが変更するパス上にある残りのサブディレクトリの `REVIEW.md` ファイルは、ルートのファイルを除いて、合計 150,000 バイトの上限を共有します。[チェック実行](https://code.claude.com/docs/ja/code-review-pull-requests.md#check-run-output)でそれらの一部が収まらなかったと報告された場合は、その上限に収まるようにファイルを短くしてください。
+
 ### REVIEW\.md の例
 
@@ -218,6 +231,6 @@ Code Review は、次の設定を保護とみなします。
```

</details>

*...以降省略*

</details>


<details>
<summary>2026-11-05</summary>

**変更ファイル:**

```
 docs-ja/pages/agent-view-ja.md                     |   4 +-
 docs-ja/pages/amazon-bedrock-ja.md                 |  14 +--
 docs-ja/pages/best-practices-ja.md                 |   2 +-
 docs-ja/pages/claude-apps-gateway-deploy-ja.md     |   1 +
 docs-ja/pages/claude-directory-ja.md               |   5 +-
 docs-ja/pages/claude-projects-ja.md                |   4 +-
 docs-ja/pages/desktop-ja.md                        |  20 ++-
 docs-ja/pages/env-vars-ja.md                       |   3 +-
 docs-ja/pages/errors-ja.md                         | 137 ++++++++++++++++++++-
 docs-ja/pages/headless-ja.md                       |   4 +-
 docs-ja/pages/permission-modes-ja.md               |   5 +-
 docs-ja/pages/permissions-ja.md                    |   2 +-
 docs-ja/pages/remote-control-ja.md                 |  15 +++
 .../self-hosted-environments-configuration-ja.md   |  23 ++++
 docs-ja/pages/server-managed-settings-ja.md        |  15 ++-
 docs-ja/pages/settings-ja.md                       |   4 +-
 docs-ja/pages/settings-reference-ja.md             |  14 +--
 docs-ja/pages/skills-ja.md                         |   2 +-
 docs-ja/pages/troubleshoot-install-ja.md           |  14 +++
 19 files changed, 248 insertions(+), 40 deletions(-)
```

<details>
<summary>agent-view-ja.md</summary>

```diff
diff --git a/docs-ja/pages/agent-view-ja.md b/docs-ja/pages/agent-view-ja.md
index 13d88ca..89968e2 100644
--- a/docs-ja/pages/agent-view-ja.md
+++ b/docs-ja/pages/agent-view-ja.md
@@ -1021,5 +1021,5 @@ claude daemon stop --any --keep-workers
 macOS では、バックグラウンドセッションホストは独自のプロセスとして実行され、ターミナルとは別に保護されたフォルダへのアクセスをリクエストします。バックグラウンドセッションが `~/Desktop`、`~/Documents`、`~/Downloads`、または別の保護された場所を読み取るときに `Operation not permitted` を報告する場合、System Settings の Privacy & Security > Files and Folders でアクセスを許可するか、エントリの Full Disk Access を有効にしてください。
 
-ネイティブインストーラーを使用すると、エントリは Claude Code として表示され、許可は更新全体で保持されます。Homebrew または npm などの他のインストール方法を使用すると、エントリはバイナリパスを表示し、更新後に再度許可が必要になる場合があります。
+どちらのリストでも、Claude Code という名前のエントリ、または `claude` バイナリのパスやファイル名が付いたエントリを探してください。このファイル名は `2.1.316` のようなバージョン番号の場合があります。Claude Code の更新後に `Operation not permitted` が再び発生する場合は、新しいバージョン名が付いたエントリなど、新しいエントリを探してください。見つかった場合は、そのエントリにアクセスを許可してください。
 
 ### macOS でバックグラウンドセッションがローカルネットワークホストに到達できない
@@ -1068,5 +1068,5 @@ Agent view はリサーチプレビュー中に急速に進化しました。古
 | v2.1.295 | [アタッチ中のバックグラウンドセッション](#attach-to-a-session)のアイドル状態のプロンプトで `Ctrl+C` を押しても、[自己ペースの `/loop`](https://code.claude.com/docs/ja/scheduled-tasks#let-claude-choose-the-interval) の保留中のウェイクアップには影響しないため、2 回押すとデタッチされ、ループは実行を続けます。そのプロンプトで `Esc` を押すと[自己ペースのループが停止し](https://code.claude.com/docs/ja/scheduled-tasks.md#stop-a-loop)、`Pending wakeup cancelled` という通知が表示されます。このリリースより前は、最初の `Ctrl+C` で自己ペースのループが何の表示もなく終了することがあり、セッションとともにバックグラウンドに移動したループは `Esc` で停止しませんでした。 |
 | v2.1.295 | macOS と Linux では、[スーパーバイザー](#keep-sessions-running-after-the-supervisor-stops)が実行されていない状態で `claude agents` が終了する場合、新しいスーパーバイザーを自動的に起動しません。その場合、`claude agents` を再度実行しない限り、実行中のセッションは約 1 分後に停止し、agent view は終了時にその旨の通知を表示することがあります。このリリースより前は、終了する `claude agents` が新しいスーパーバイザーを起動していました。 |
-| v2.1.295 | ネイティブインストーラーを使用した macOS では、更新後にまとめて再起動されるバックグラウンドセッションは、付与した[保護フォルダへのアクセス](#background-sessions-can’t-read-desktop-documents-or-downloads-on-macos)を持つ同じ Claude Code エントリの下で実行されます。このリリースより前は、これらのセッションが代わりにバイナリ自身のパスの下で実行されることがありました。macOS はそのパスを別のエントリとして扱うため、更新後にフォルダアクセスのプロンプトが再び表示されることがありました。 |
+| v2.1.295 | ネイティブインストーラーを使用した macOS では、更新後にまとめて再起動されるバックグラウンドセッションは、同じ `~/.local/share/claude/ClaudeCode.app` フォルダからホストプロセスを実行します。このリリースより前は、これらのプロセスが代わりにバイナリ自身のパスから実行されることがありました。macOS はそのパスを別のエントリとして一覧表示することがあるため、更新後に[フォルダアクセスのプロンプト](#background-sessions-can’t-read-desktop-documents-or-downloads-on-macos)が再び表示されることがありました。 |
 | v2.1.290 | [`claude attach` と `claude logs`](#manage-sessions-from-the-shell) は、ID の代わりにセッションの名前の一部を受け付けます。 |
 | v2.1.290 | `/model`、`/effort`、`/rename`、`/usage` を作業中のセッションへの[ピーク返信](#peek-and-reply)として送信すると、すぐに実行されます。 |
```

</details>

<details>
<summary>amazon-bedrock-ja.md</summary>

```diff
diff --git a/docs-ja/pages/amazon-bedrock-ja.md b/docs-ja/pages/amazon-bedrock-ja.md
index 0664f02..3a3ffc8 100644
--- a/docs-ja/pages/amazon-bedrock-ja.md
+++ b/docs-ja/pages/amazon-bedrock-ja.md
@@ -461,5 +461,7 @@ export ANTHROPIC_BEDROCK_SERVICE_TIER=priority
 ```
 
-Claude Code は、各リクエストで `X-Amzn-Bedrock-Service-Tier` ヘッダーとしてこれを送信します。ティアの可用性はモデルとリージョンによって異なります。予約容量は、この設定の代わりに[プロビジョニングされたスループット](https://docs.aws.amazon.com/bedrock/latest/userguide/prov-throughput.html) ARN をモデル ID として使用します。
+Claude Code は、この変数が設定されたセッションからのすべての [Invoke API](https://docs.aws.amazon.com/bedrock/latest/APIReference/API_runtime_InvokeModelWithResponseStream.html) リクエストで、これを `X-Amzn-Bedrock-Service-Tier` ヘッダーとして送信します。ただし、[モデルアクセスチェック](#startup-model-checks)は除きます。この設定は、[Mantle エンドポイント](#use-the-mantle-endpoint)へのリクエストや [Claude apps ゲートウェイ](https://code.claude.com/docs/ja/claude-apps-gateway)を経由するリクエストには影響しません。ティアの可用性はモデルとリージョンによって異なります。予約容量は、この設定の代わりに[プロビジョニングされたスループット](https://docs.aws.amazon.com/bedrock/latest/userguide/prov-throughput.html) ARN をモデル ID として使用します。
+
+ターミナルから開始する[バックグラウンドセッション](https://code.claude.com/docs/ja/agent-view.md#settings-and-provider)にも適用するには、設定の [`env`](https://code.claude.com/docs/ja/settings-reference#env) ブロックで `ANTHROPIC_BEDROCK_SERVICE_TIER` を設定します。これらのセッションがエクスポートした値を受け取るのは、[スーパーバイザー](https://code.claude.com/docs/ja/agent-view.md#the-supervisor-process)を開始したシェルがその値をエクスポートしていた場合のみです。
 
 ## AWS Guardrails
@@ -489,5 +491,5 @@ Mantle は `bedrock-mantle:` プレフィックスの下に独自の IAM アク
 ### Mantle を有効にする
 
-AWS 認証情報が既に設定されている場合、`CLAUDE_CODE_USE_MANTLE` を設定して、リクエストを Mantle エンドポイントにルーティングします。
+AWS 認証情報が既に設定されている場合、`CLAUDE_CODE_USE_MANTLE` と AWS リージョンを設定します。
 
 ```bash theme={null}
@@ -519,5 +521,5 @@ export CLAUDE_CODE_USE_MANTLE=1
 ```
 
-Mantle モデルを `/model` ピッカーに表示するには、[settings file](https://code.claude.com/docs/ja/settings.md) の `availableModels` にその ID をリストします。この設定はピッカーをリストされたエントリに制限するため、保持したいバージョンのバージョンプレフィックスまたは完全な ID もリストします。Mantle ID と `haiku` エイリアスは同じモデルファミリーに解決されるため、マージはより具体的なエントリのみを保持します。[Merge behavior](https://code.claude.com/docs/ja/model-config.md#merge-behavior) を参照してください。
+Mantle モデルを `/model` ピッカーに表示するには、[settings file](https://code.claude.com/docs/ja/settings.md) の `availableModels` にその ID をリストします。この設定は、ピッカーをリストされたエントリに制限する働きもあります。`anthropic.claude-haiku-4-5` をリストすると、単独の `haiku` エイリアスがピッカーから削除されるため、引き続き選択可能にしておきたいバージョンについては、バージョンプレフィックスまたは完全な ID もリストしてください。Mantle ID と `haiku` エイリアスは同じモデルファミリーに解決されるため、マージはより具体的なエントリのみを保持します。[Merge behavior](https://code.claude.com/docs/ja/model-config.md#merge-behavior) を参照してください。
 
 ```json theme={null}
@@ -589,6 +591,4 @@ v2.1.261 より前では、**Use credentials already in my environment** オプ
 * モデルを [inference profile](https://docs.aws.amazon.com/bedrock/latest/userguide/inference-profiles-support.html) ID として指定します
 
```

</details>

<details>
<summary>best-practices-ja.md</summary>

```diff
diff --git a/docs-ja/pages/best-practices-ja.md b/docs-ja/pages/best-practices-ja.md
index c5fa631..a75b509 100644
--- a/docs-ja/pages/best-practices-ja.md
+++ b/docs-ja/pages/best-practices-ja.md
@@ -545,5 +545,5 @@ Claude に `have the reviewer compare the rate limiter against SPEC.md` と依
 
 * [`--bare`](https://code.claude.com/docs/ja/headless#start-faster-with-bare-mode) は、フック、スキル、プラグイン、MCP サーバー、`CLAUDE.md` ファイル（リポジトリのものもマシンのものも）をスキップするため、どこで実行しても同じ動作になります。また、claude.ai のログインには一切触れません。認証は `ANTHROPIC_API_KEY`、`--settings` で渡すファイル内の `apiKeyHelper`、またはクラウドプロバイダーの認証情報から取得します。
-* `--append-system-prompt`、`--mcp-config`、`--settings` は、その実行で*実際に*必要なものを明示的に渡します。
+* `--append-system-prompt`、`--mcp-config`、`--settings` は、その実行で*実際に*必要なものを明示的に渡します。`--settings` で渡したフックは [`--bare` では実行されない](https://code.claude.com/docs/ja/headless#start-faster-with-bare-mode)ため、フックを必要とする実行では `--bare` を使わないでください。
 * `--allowedTools` はツールを事前承認し、[`--permission-mode dontAsk`](https://code.claude.com/docs/ja/permission-modes#allow-only-pre-approved-tools-with-dontask-mode) はそれ以外で確認が必要になるものをすべて拒否します。
 * `--output-format json` は解析用の単一の結果オブジェクトを返し、`stream-json` を `--verbose` と組み合わせると、イベントが発生するたびにストリーミングされます。
```

</details>

<details>
<summary>claude-apps-gateway-deploy-ja.md</summary>

```diff
diff --git a/docs-ja/pages/claude-apps-gateway-deploy-ja.md b/docs-ja/pages/claude-apps-gateway-deploy-ja.md
index e61c8b1..d84e6eb 100644
--- a/docs-ja/pages/claude-apps-gateway-deploy-ja.md
+++ b/docs-ja/pages/claude-apps-gateway-deploy-ja.md
@@ -425,4 +425,5 @@ gateway の stderr には監査イベントストリームが含まれ、監査
 | 開発者がサインインした後、そのセッションからのすべてのリクエストが `431` エラーで失敗する | すべてのリクエストの `Authorization` ヘッダーにあるセッショントークンには開発者の IdP グループが列挙されるため、多数のグループに所属する開発者では、ヘッダーの合計が gateway の受け入れ上限を超えることがある | どの制限が適用されるか、および何を変更すべきかについては、[サインイン後にリクエストヘッダーが大きすぎる](#request-headers-too-large-after-sign-in)を参照してください |
 | すべての Amazon Bedrock リクエストが 502 を返す。ログに `Could not load credentials from any providers` が表示される | EC2 では、IMDSv2 のデフォルトホップリミット 1 がコンテナ内からのインスタンスメタデータリクエストをブロックします。ブートと `/readyz` は AWS SDK がクライアント構築時ではなく最初のリクエストでインスタンス認証情報を解決するため、とにかく成功します | `aws ec2 modify-instance-metadata-options --instance-id <id> --http-put-response-hop-limit 2` でホップリミットを上げるか、起動テンプレートで設定してください。変更はインスタンス上のすべてのコンテナに適用されます。利用可能な場合は ECS タスクロールを優先してください。これは ECS コンテナ認証情報エンドポイントから認証情報を読み込み、変更を完全に回避します。または、変更を専用 gateway インスタンスに適用して露出を制限してください。 |
+| ログ: Google 認証情報ファイルのタイプが `external_account` であるアップストリームで、`upstream <name>: Google issued an access token that expires in <N>s` を含む警告が表示される | リクエストはそのアクセストークンの有効期限が切れるまで成功し、その後は、`credential_source` が指すトークンが先に更新されていない限り失敗する。 | プロセスがそのトークンをファイルに書き込んでいる場合は、古いトークンの有効期限が切れる 5 分以上前に新しいトークンを書き込むようにしてください |
 | ピークロード時に、レスポンスの開始が遅い、またはハングしているように見える、または upstream が健全な場合に 502 `all upstreams failed` で失敗する | レプリカは upstream に一度に送信するよりも多くのリクエストを開いているため、余分なリクエストは gateway 内で待機します。`provider: anthropic` upstream では、`timeouts.upstream_ttfb_ms` より長く待つリクエストはその upstream をあきらめ、後の upstream がそれを処理しない場合は 502 を生成します。ログは `client requests are open` を含む警告を表示します。 | レプリカを追加するか、各レプリカの制限を上げてください。[同時 upstream リクエスト](#concurrent-upstream-requests)を参照してください。 |
 | `provider: anthropic` 以外のアップストリームで、長い思考の間を含むターンが失敗する。ゲートウェイの前にあるプロキシが、約 12.5 分間開いたままのリクエストを 1 件記録し、その後 `504` エラーを連続して記録する | Claude Code は、最初のレスポンスイベントを配信した後はキープアライブの ping のみを運んでいたストリームを終了しました。リクエストをストリーミングなしで再送信しましたが、各応答にはプロキシのタイムアウトより長い時間がかかります。 | 開発者向けに `CLAUDE_STREAM_IDLE_TIMEOUT_MS` を上げてください。[長い思考がプロキシのタイムアウトで終わる](#long-thinking-ends-in-proxy-timeouts)を参照してください。 |
```

</details>

<details>
<summary>claude-directory-ja.md</summary>

```diff
diff --git a/docs-ja/pages/claude-directory-ja.md b/docs-ja/pages/claude-directory-ja.md
index fed6888..9283ba3 100644
--- a/docs-ja/pages/claude-directory-ja.md
+++ b/docs-ja/pages/claude-directory-ja.md
@@ -132,5 +132,5 @@ Claude Code は、[`cleanupPeriodDays`](https://code.claude.com/docs/ja/settings
 | `tasks/` | タスクツールで書き込まれたタスクリスト。リストごとに 1 つのディレクトリ |
 | `shell-snapshots/` | 起動時にキャプチャされたエイリアス、関数、シェルオプション。[Bash ツール](https://code.claude.com/docs/ja/tools-reference.md#bash-tool-behavior)によって各コマンドに適用されます。クリーンな終了時に削除されます。スイープはクラッシュ後に残されたものをクリアします |
-| `backups/` | `~/.claude.json` の以前のバージョン。Claude Code がファイルを書き直すときにコピーされます。Claude Code は最新の 5 つと、解析できなかったバージョンのコピーを保持します |
+| `backups/` | `~/.claude.json` の以前のバージョン。Claude Code がファイルを書き直すときにコピーされます。Claude Code は最新の 5 つと、解析できなかったバージョンのコピーを保持します。経過日数の閾値を過ぎると、設定を保持している最後のコピーも削除されます。現在のファイルが解析可能で、設定を保持しており、8 MiB 未満の場合は、その新しいコピーが残ります |
 | `feedback-bundles/` | サードパーティプロバイダー上で、または Anthropic 認証情報が設定されていない場合に `/feedback` によって書き込まれた、編集済みトランスクリプトアーカイブ。Anthropic アカウントチームに送信するため |
 | `feedback/drafts/` | キューに入った [Claude が作成したフィードバック](https://code.claude.com/docs/ja/tools-reference.md#sendfeedback-tool-behavior)。`/feedback` でのレビューを待機中です。`cleanupPeriodDays` または 30 日のいずれか短い方の後にスイープされます。キューが 10 ドラフトの上限に達すると、Claude Code は最も古いドラフトを削除して空き容量を作ります |
@@ -289,5 +289,6 @@ claude purge ~/work/my-repo --yes
 | `~/.claude/skills/.trash/`、`~/.claude/plugins/.trash/` | Claude Code が削除した[同期されたスキル](https://code.claude.com/docs/ja/skills.md#how-synced-skills-behave)と[同期されたプラグイン](https://code.claude.com/docs/ja/plugins/loading.md#synced-plugins)を復元する機会 |
 | `~/.claude/plugins/installed_plugins.set-aside.<date>.<hash>.json`、`~/.claude/plugins/installed_plugins.unreadable.<date>.<hash>.kept` | Claude Code が削除したプラグインインストールレコード、または読み込めなかったファイルのコピー。何もそれらを読み込み直しません |
-| `~/.claude/debug/`、`~/.claude/plans/`、`~/.claude/session-env/`、`~/.claude/shell-snapshots/`、`~/.claude/backups/` | ユーザーに見える何もなし |
+| `~/.claude/debug/`、`~/.claude/plans/`、`~/.claude/session-env/`、`~/.claude/shell-snapshots/` | ユーザーに見える何もなし |
+| `~/.claude/backups/` | [`~/.claude.json` の復元元](https://code.claude.com/docs/ja/errors#configuration-error-in-claude-json)として使える以前のコピー |
 | `~/.claude/todos/`、`~/.claude/statsig/`、`~/.claude/logs/`、`~/.claude/image-cache/` | なし。現在のバージョンで書き込まれていないレガシーディレクトリ |
 
```

</details>

<details>
<summary>claude-projects-ja.md</summary>

```diff
diff --git a/docs-ja/pages/claude-projects-ja.md b/docs-ja/pages/claude-projects-ja.md
index f65f37e..b96f608 100644
--- a/docs-ja/pages/claude-projects-ja.md
+++ b/docs-ja/pages/claude-projects-ja.md
@@ -481,5 +481,5 @@ Claude が実行中だが、その返信がプロジェクトに到達してい
 * **「Claude がアクセスできません」**リポジトリは、**新規プロジェクト**ダイアログまたは**プロジェクト設定**でリポジトリを保存するときに表示されます。メッセージは、インストール リンクと再接続リンクで続きます。Claude GitHub App がそのリポジトリにない場合はインストール リンクを使用し、ある場合は再接続リンクを使用します。GitHub App は GitHub にインストールされていても、Claude に接続したアカウントにリンクされていない可能性があるためです。メッセージが GitHub App が一時停止されているか、このリポジトリを含まないと言っている場合は、そのリンクをたどって GitHub でそれを修正してください。
 
-これらのいずれかを修正するには、メッセージが提供するボタン（**GitHub App をインストール**または**GitHub で リポジトリを選択**など）をクリックしてから、**再度確認**をクリックします。ブロックが GitHub 組織側にある場合（アプリを承認していないオーナーや Claude を除外する IP 許可リストなど）、メッセージは代わりに**修正方法を確認**リンクを表示します。ボタンがない場合は、[GitHub アクセスのセットアップ](#set-up-github-access)に従い、別のメッセージを送信して再試行してください。
+「セッションを開始できませんでした」または「リポジトリにアクセスできません」の GitHub アクセスを修正するには、メッセージが提供するボタン（**GitHub にインストール**や**リポジトリを選択**など）をクリックします。ボタンがない場合は、[GitHub アクセスのセットアップ](#set-up-github-access)に従ってください。修正後、プロジェクト会話で Claude に同じ作業のための新しいスレッドを開始するよう求めてください。
 
 ### スレッドが使用制限に達した
@@ -506,5 +506,5 @@ Claude が実行中だが、その返信がプロジェクトに到達してい
 | メッセージ | 実行する操作 |
 | :- | :- |
-| 「リポジトリに接続できません」と「Claude はリポジトリをフェッチするために GitHub に到達できませんでした」 | 少し待ってから、別のメッセージを送信して再試行してください |
+| 「リポジトリに接続できません」と「Claude はリポジトリをフェッチするために GitHub に到達できませんでした」 | 少し待ってから、プロジェクト会話で Claude に同じ作業のための新しいスレッドを開始するよう求めてください |
 | 「リポジトリに接続できません」と「Claude はリポジトリまたは環境にアクセスできませんでした」 | GitHub アカウントはリポジトリへのプッシュ アクセスが必要で、環境はまだ存在する必要があります。**プロジェクト設定 > 環境**で両方を確認してから、再試行してください |
 | 「セットアップ提案を表示できませんでした」 | 開いているアプリは、Claude が送信した**セットアップの推奨事項**より古いです。ページを更新するか、デスクトップ アプリを再起動するか、Claude にセットアップを再度提案するよう求めてください |
```

</details>

<details>
<summary>desktop-ja.md</summary>

```diff
diff --git a/docs-ja/pages/desktop-ja.md b/docs-ja/pages/desktop-ja.md
index 0582cc5..a9c2b7f 100644
--- a/docs-ja/pages/desktop-ja.md
+++ b/docs-ja/pages/desktop-ja.md
@@ -85,5 +85,5 @@ Claude にファイルを渡すには、プロンプトボックスでファイ
 権限モードは、セッション中に Claude がどの程度の自律性を持つかを制御します：ファイルの編集、コマンドの実行、またはその両方の前に確認するかどうかです。プロンプトボックスの下の行にあるモードセレクタを使用して、いつでも権限モードを切り替えることができます。各変更を自分で承認するには、Manual に切り替えます。
 
-新しいローカルセッションのデフォルトモードを設定するには、[設定ファイル](https://code.claude.com/docs/ja/settings.md#where-settings-live)に`permissions.defaultMode`を追加します。デスクトップアプリは CLI と同じ設定ファイルを読み取ります。セレクタで選択したモードはフォルダごとに記憶され、そのフォルダの`defaultMode`より優先されます。ただし Plan は現在のセッションにのみ適用されます。
+新しいローカルセッションのデフォルトの権限モードを設定するには、[設定ファイル](https://code.claude.com/docs/ja/settings.md#where-settings-live)に `permissions.defaultMode` を追加します。ローカルセッションで選択したモードはフォルダごとに記憶され、プロジェクトの `.claude/` 設定にある `defaultMode` より優先されます。ただし、新しいローカルセッションが `~/.claude/settings.json` または管理設定の `defaultMode` で開始される場合もあるため、最初のメッセージを送信する前にセレクタを確認してください。Plan を選択した場合は、このセッションにのみ適用されます。
 
 | モード | 設定キー | 動作 |
@@ -228,4 +228,15 @@ Code タブはペインを任意のレイアウトで配置できるように構
 パネルを表示または非表示にするには、セッションのタイトルバー、またはバーの\*\*⋮**メニューで、**Hide session rail**または**Show session rail\*\*をクリックします。それでもパネルが表示されない場合は、[使用している Code タブのレイアウトを確認してください](#check-which-layout-you-have)。
 
+### ペインを最小化する
+
+Terminal、Browser、または [iOS Simulator](https://code.claude.com/docs/ja/desktop-ios-simulator.md) を小さいサイズで表示したままにするには、ペインのヘッダーにある**Minimize**をクリックします。このボタンを使用するには、Claude Desktop v4.0.0 以降と、[サードパーティプロバイダー](https://code.claude.com/docs/ja/third-party-integrations.md)ではなく Claude アカウントが必要です。Browser ペインでは、ローカルセッションでのみこのボタンが表示されます。
+
+最小化されたペインは、[セッション詳細パネル](#see-session-details)が画面に表示されている間はそのパネル内に配置され、それ以外の場合はチャットの隅にフローティング表示されます：
+
+* **パネル内**：最小化されたペインはパネルのカードの下に配置され、移動やサイズ変更はできません。代わりにチャットの上にフローティング表示するには、[パネルを非表示にします](#hide-or-show-the-session-details-panel)。
+* **チャットの隅**：最小化されたペインにホバーするとヘッダーが表示されます。ヘッダーをドラッグすると別の隅に移動できます。サイズを変更するには、最小化されたペインのうちチャットの中央に最も近い角をドラッグします。
+
+元のペインに戻すには、最小化されたペインのヘッダーにある**Expand**をクリックします。最小化されたペインを閉じる場合は、**Expand**の横にある閉じるボタンをクリックします。
+
 ### ターミナルでコマンドを実行する
 
@@ -1290,5 +1301,5 @@ Claude Code は、Desktop がリモートマシンにインストールするバ
 > [!WARNING]
 >
```

</details>

<details>
<summary>env-vars-ja.md</summary>

```diff
diff --git a/docs-ja/pages/env-vars-ja.md b/docs-ja/pages/env-vars-ja.md
index e8cc029..e7a4767 100644
--- a/docs-ja/pages/env-vars-ja.md
+++ b/docs-ja/pages/env-vars-ja.md
@@ -140,5 +140,5 @@ Claude Code はスタートアップ時にシェル環境変数を読み込む
 | `ANTHROPIC_BEDROCK_MANTLE_BASE_URL` | Amazon Bedrock Mantle のエンドポイント URL を上書きします。[Mantle エンドポイント](https://code.claude.com/docs/ja/amazon-bedrock.md#use-the-mantle-endpoint)を参照してください |
 | `ANTHROPIC_BEDROCK_REGION_PREFIX` | AWS リージョンから導出されるプレフィックスの代わりに Claude Code が最初に試す、クロスリージョン推論プロファイルのプレフィックス（`us`、`eu`、`apac`、`jp`、`au`、`global` のいずれか）。AWS GovCloud リージョンでは無視されます。Claude Code v2.1.224 以降が必要です。[Amazon Bedrock](https://code.claude.com/docs/ja/amazon-bedrock.md#cross-region-inference-profile-prefixes) を参照してください |
-| `ANTHROPIC_BEDROCK_SERVICE_TIER` | Amazon Bedrock の[サービスティア](https://docs.aws.amazon.com/bedrock/latest/userguide/service-tiers-inference.html)（`default`、`flex`、`priority` のいずれか）。`X-Amzn-Bedrock-Service-Tier` ヘッダーとして送信されます。[Amazon Bedrock](https://code.claude.com/docs/ja/amazon-bedrock.md#service-tiers) を参照してください |
+| `ANTHROPIC_BEDROCK_SERVICE_TIER` | Amazon Bedrock の[サービスティア](https://docs.aws.amazon.com/bedrock/latest/userguide/service-tiers-inference.html)（`default`、`flex`、`priority`）。[Amazon Bedrock](https://code.claude.com/docs/ja/amazon-bedrock.md#service-tiers) を参照してください |
 | `ANTHROPIC_BETAS` | API リクエストに含める追加の `anthropic-beta` ヘッダー値のカンマ区切りリスト。Claude Code は必要なベータヘッダーをすでに送信しています。Claude Code がネイティブサポートを追加する前に [Anthropic API のベータ](https://platform.claude.com/docs/en/api/beta-headers)を利用するには、この変数を使用します。API キー認証を必要とする [`--betas` フラグ](https://code.claude.com/docs/ja/cli-reference#cli-flags)とは異なり、この変数は Claude.ai サブスクリプションを含むすべての認証方法で機能します |
 | `ANTHROPIC_CUSTOM_HEADERS` | リクエストに追加するカスタムヘッダー（`Name: Value` 形式。複数のヘッダーは改行で区切ります）。名前または値に、カーリークォートやゼロ幅スペースなど HTTP ヘッダーで扱えない文字が含まれている場合、リクエストは位置によってそのペアを特定するエラーで失敗します。Claude Code v2.1.227 以降が必要です。正確な文字セットとチェックが実行される場所については、[Invalid request header value](https://code.claude.com/docs/ja/errors.md#invalid-request-header-value) を参照してください。`Authorization` や `Host` など、認証情報、組織またはテナント、ルーティング、API の動作に関するヘッダーを設定する値は、サーバー管理設定によって配信される場合、[承認が必要な設定](https://code.claude.com/docs/ja/server-managed-settings.md#environment-variables-and-the-approval-dialog)として扱われます。プロジェクト設定またはローカル設定からの場合、そのような値は [`env` の値が適用されるタイミングのルール](https://code.claude.com/docs/ja/settings-reference#when-claude-code-applies-env-values)に従います |
@@ -239,4 +239,5 @@ Claude Code はスタートアップ時にシェル環境変数を読み込む
 | `CLAUDE_CODE_DISABLE_BG_EXIT_HANDOFF` | `1` に設定すると、[スーパーバイザー](https://code.claude.com/docs/ja/agent-view.md#the-supervisor-process) がセッションのプロセスを停止、再起動、または更新したときに、[バックグラウンドセッションの](https://code.claude.com/docs/ja/agent-view.md) 進行中の作業を、セッションの次のプロセスに引き継ぐのではなく停止します。その作業とは、セッションで実行中のバックグラウンドシェルコマンドと、v2.1.198 以降ではバックグラウンドサブエージェントです。影響するのはこの引き継ぎのみです。`←` や [`/background`](https://code.claude.com/docs/ja/agent-view#from-inside-a-session) でセッションをバックグラウンドに移動した場合は、進行中のバックグラウンド作業が引き続き引き継がれます。Claude Code v2.1.196 以降が必要です |
 | `CLAUDE_CODE_DISABLE_BG_SHELL_PRESSURE_REAP` | `1` に設定すると、メモリ逼迫時に Claude Code が[バックグラウンドシェルコマンド](https://code.claude.com/docs/ja/interactive-mode.md#background-bash-commands)を終了しないようにします。デフォルトでは、macOS と Linux で、オペレーティングシステムが深刻なメモリ逼迫を報告し、かつセッションがターンやサブエージェントの実行なしで 30 分間アイドル状態だった場合、Claude Code はバックグラウンドシェルを終了します。Windows にはメモリ逼迫のシグナルがないため、この変数は効果がありません。Claude Code v2.1.193 以降が必要です |
+| `CLAUDE_CODE_DISABLE_BG_STABLE_PATH` | ネイティブインストーラーを使用している macOS で `1` に設定すると、各[バックグラウンドセッション](https://code.claude.com/docs/ja/agent-view.md)のホストプロセスを `~/.local/share/claude/ClaudeCode.app` ではなく、インストールされたバイナリから実行します。その場合、macOS は[フォルダーへのアクセス](https://code.claude.com/docs/ja/agent-view.md#background-sessions-can’t-read-desktop-documents-or-downloads-on-macos)などの権限を、更新のたびを含めて再度求めることがあります。シェルではなく、ユーザー設定、管理設定ファイル、または MDM ポリシーの [`env` ブロック](#in-settings-files)で設定します。`ClaudeCode.app` を削除するには、手動で削除します。Claude Code v2.1.295 以降が必要です |
 | `CLAUDE_CODE_DISABLE_BUNDLED_SKILLS` | `1` に設定すると、Claude Code に含まれる[スキル](https://code.claude.com/docs/ja/skills.md)とワークフローを無効にします。バンドルスキルとワークフローは完全に削除され、`/init` などの組み込みコマンドは入力可能なままですが、モデルからは隠されます。`/doctor` は組み込みコマンドと同様に入力可能なままです。隠すには、代わりに `DISABLE_DOCTOR_COMMAND` を使用します。プラグイン、`.claude/skills/`、`.claude/commands/` のスキルは影響を受けません。[`disableBundledSkills`](https://code.claude.com/docs/ja/settings-reference#disablebundledskills) 設定と同等です |
 | `CLAUDE_CODE_DISABLE_CFC_PROMPT` | Claude Code を組み込み、独自のブラウザーガイダンスを提供するホスト向けです。`1` に設定すると、[Claude in Chrome](https://code.claude.com/docs/ja/chrome.md) のブラウザーツールを利用可能なままにしつつ、システムプロンプトの Chrome セクションと `/claude-in-chrome` [バンドルスキル](https://code.claude.com/docs/ja/skills.md#bundled-skills)を省略します。VS Code では、v2.1.314 以降の拡張機能は、セッションのメッセージからも Claude in Chrome の指示を除外します。Claude Code v2.1.257 以降が必要です |
```

</details>

<details>
<summary>errors-ja.md</summary>

```diff
diff --git a/docs-ja/pages/errors-ja.md b/docs-ja/pages/errors-ja.md
index c7292d3..d187326 100644
--- a/docs-ja/pages/errors-ja.md
+++ b/docs-ja/pages/errors-ja.md
@@ -56,4 +56,6 @@
 | `Not logged in · Please run /login` | [認証](#not-logged-in) |
 | `Couldn't save your login` | [認証](#couldnt-save-your-login) |
+| `Sign in again to take your previous account or API key off the config file.` | [認証](#sign-in-again-to-take-your-previous-account-or-api-key-off-the-config-file) |
+| `Your account or API key may still be in the config file. Run claude auth logout.` | [認証](#your-account-or-api-key-may-still-be-in-the-config-file) |
 | `Authentication required · Sign in again to continue` | [認証](#not-logged-in) |
 | `Could not resolve authentication method` | [認証](#could-not-resolve-authentication-method) |
@@ -83,4 +85,7 @@
 | `Remote Control is disabled by your organization's policy` | [Remote Control のトラブルシューティング](https://code.claude.com/docs/ja/remote-control.md#remote-control-is-disabled-by-your-organizations-policy) |
 | `Remote Control was turned off by your organization's policy` | [Remote Control のトラブルシューティング](https://code.claude.com/docs/ja/remote-control.md#remote-control-was-turned-off-by-your-organizations-policy) |
+| `Session failed: working folder not found:` | [Remote Control のトラブルシューティング](https://code.claude.com/docs/ja/remote-control.md#working-folder-not-found) |
+| `The program file this Remote Control started from is gone` | [Remote Control のトラブルシューティング](https://code.claude.com/docs/ja/remote-control.md#program-file-is-gone) |
+| `Session failed: spawn error:` の後に `ENOENT` メッセージが続くもの | [Remote Control のトラブルシューティング](https://code.claude.com/docs/ja/remote-control.md#program-file-is-gone) |
 | `OAuth token revoked` / `OAuth token has expired` | [認証](#oauth-token-revoked-or-expired) |
 | `Failed to authenticate: OAuth token revoked` | [認証](#oauth-token-revoked-or-expired) |
@@ -166,4 +171,5 @@
 | `Image was too large` | [リクエストエラー](#image-was-too-large) |
 | `API Error: an image in the conversation could not be processed and was removed` | [リクエストエラー](#image-was-too-large) |
+| `An image in the conversation exceeds the dimension limit for many-image requests` | [リクエストエラー](#image-was-too-large) |
 | `Unable to resize image` | [リクエストエラー](#unable-to-resize-image) |
 | `Request rejected as unprocessable by the model` | [リクエストエラー](#request-rejected-as-unprocessable-by-the-model) |
@@ -230,4 +236,6 @@
 | `Error: --agents file not found` | [コマンドラインエラー](#invalid-agents-configuration) |
 | `Error: Settings file exceeds the 2MiB limit` | [コマンドラインエラー](#settings-file-exceeds-the-2mib-limit) |
+| `Configuration error in` | [コマンドラインエラー](#configuration-error-in-claude-json) |
+| `Claude configuration file at <path> was empty and no backup holds anything: starting with defaults.` | [コマンドラインエラー](#claude-configuration-file-was-empty) |
```

</details>

*...以降省略*

</details>


<details>
<summary>2026-11-04</summary>

**変更ファイル:**

```
 docs-ja/pages/admin-setup-ja.md                    |   6 +-
 docs-ja/pages/agent-teams-ja.md                    | 122 ++++-----
 docs-ja/pages/agent-view-ja.md                     |   2 +-
 docs-ja/pages/amazon-bedrock-ja.md                 |   8 +-
 docs-ja/pages/best-practices-ja.md                 |   4 +-
 docs-ja/pages/changelog.md                         |  87 +++++++
 docs-ja/pages/claude-apps-gateway-config-ja.md     |   5 +-
 docs-ja/pages/cli-reference-ja.md                  |   2 +-
 docs-ja/pages/code-review-local-ja.md              |   2 +-
 docs-ja/pages/commands-ja.md                       |   2 +-
 docs-ja/pages/debug-your-config-ja.md              |   2 +
 docs-ja/pages/desktop-ja.md                        |  76 +++++-
 docs-ja/pages/env-vars-ja.md                       |   2 +-
 docs-ja/pages/errors-ja.md                         |  44 +++-
 docs-ja/pages/hooks-ja.md                          |  21 +-
 docs-ja/pages/interactive-mode-ja.md               |   8 +-
 docs-ja/pages/jetbrains-ja.md                      |   4 +
 docs-ja/pages/large-codebases-ja.md                |   2 +-
 docs-ja/pages/memory-ja.md                         |  10 +-
 docs-ja/pages/model-config-ja.md                   |   6 +-
 docs-ja/pages/monitoring-usage-ja.md               |   4 +
 docs-ja/pages/permission-modes-ja.md               |   4 +-
 docs-ja/pages/routines-ja.md                       |   8 +-
 docs-ja/pages/sandboxing-ja.md                     |  86 +++++--
 .../self-hosted-environments-configuration-ja.md   |  24 +-
 .../pages/self-hosted-environments-deploy-ja.md    |   2 +-
 .../pages/self-hosted-environments-reference-ja.md |   2 +-
 docs-ja/pages/server-managed-settings-ja.md        |   4 +-
 docs-ja/pages/settings-reference-ja.md             | 276 +++++++++++----------
 docs-ja/pages/setup-ja.md                          |  10 +-
 docs-ja/pages/sub-agents-ja.md                     |   4 +
 docs-ja/pages/vs-code-ja.md                        |   9 +-
 docs-ja/pages/web-quickstart-ja.md                 |   2 +-
 33 files changed, 563 insertions(+), 287 deletions(-)
```

<details>
<summary>admin-setup-ja.md</summary>

```diff
diff --git a/docs-ja/pages/admin-setup-ja.md b/docs-ja/pages/admin-setup-ja.md
index 9dba669..591a80b 100644
--- a/docs-ja/pages/admin-setup-ja.md
+++ b/docs-ja/pages/admin-setup-ja.md
@@ -130,9 +130,9 @@ WSL 2 ユーティリティ VM 内のプロセスは、Windows 側のエンド
 ### 接続された GitHub アカウント
 
-Team プランと Enterprise プランでは、[**Organization settings > Git providers**](https://claude.ai/admin-settings/source-control) の GitHub セクションに、[Claude GitHub App](https://github.com/apps/claude) を通じて Claude 組織にリンクされた GitHub 組織と個人アカウントが一覧表示されます。Claude Code、[Claude Tag](https://claude.com/docs/claude-tag/admins/configure-github)、Claude Security はこの一覧を共有します。このページを開くには、Claude 組織の管理者ロールが必要です。
+Team プランと Enterprise プランでは、[**Organization settings > Git providers**](https://claude.ai/admin-settings/source-control) の GitHub セクションに、[Claude GitHub App](https://github.com/apps/claude) を通じて Claude 組織にリンクされた GitHub 組織と個人アカウントが一覧表示されます。Claude Code、[Claude Tag](https://claude.com/docs/claude-tag/admins/configure-github)、Claude Security はこの一覧を共有します。このページを開くには、Claude 組織の [Owner ロール](https://code.claude.com/docs/ja/server-managed-settings.md#access-control)が必要です。Admin ロールではこのページを開けません。
 
-アカウントは管理者またはメンバーがリンクできます。
+アカウントは、Git プロバイダーページから、または GitHub を Claude に接続することでリンクできます。
 
-* **管理者による接続**：管理者がそのセクションで **Connect** をクリックするか、アカウントが接続済みの場合は **Add organization** をクリックし、GitHub 組織に Claude GitHub App をインストールします。この方法で組織をリンクするには、GitHub 組織の Owner であり、かつ Claude 組織の管理者でもあるユーザーが必要です。
+* **Owner による接続**：Owner がそのセクションで **Connect** をクリックするか、アカウントが接続済みの場合は **Add organization** をクリックし、GitHub 組織に Claude GitHub App をインストールします。この方法で組織をリンクするには、Claude 組織の Owner であり、かつ GitHub 組織の所有者でもあるユーザーが必要です。
 * **メンバーによる接続**：メンバーが自分の GitHub アカウントを Claude に接続すると（たとえば[クラウドセッションのセットアップ](https://code.claude.com/docs/ja/web-quickstart.md#connect-github)中）、Claude は、そのメンバーが所有し、Claude GitHub App がすでにインストールされている GitHub アカウントをリンクします。これには、メンバーの個人アカウントや、メンバーが所有する GitHub 組織が含まれる場合があります。
 
```

</details>

<details>
<summary>agent-teams-ja.md</summary>

```diff
diff --git a/docs-ja/pages/agent-teams-ja.md b/docs-ja/pages/agent-teams-ja.md
index 0883838..9855c18 100644
--- a/docs-ja/pages/agent-teams-ja.md
+++ b/docs-ja/pages/agent-teams-ja.md
@@ -159,9 +159,9 @@ Claude Code は、チームメンバーに対して選択したモデルを、
 * **プロバイダー固有のモデル ID を持つプロバイダーで代替が動作しないファミリーエイリアス、またはそのファミリーに許可されたバージョンがないもの、またはその他のブロックされた値**：Claude Code はチームメンバーをリーダーのモデルで実行します。`CLAUDE_CODE_SUBAGENT_MODEL` を設定した場合、Claude Code はそのモデルを最初に試し、これらの同じルールの下で実行します。
 
-デフォルトでは、チームメンバーはリーダーの [effort レベル](https://code.claude.com/docs/ja/model-config.md#adjust-effort-level)を継承します。分割ペインモードではこれは v2.1.186 から適用されます。それより前のバージョンではリーダーのセッションの effort を分割ペインのチームメンバーに渡していませんでした。
+デフォルトでは、リーダーのモデルで動作するチームメイトはリーダーの [effort レベル](https://code.claude.com/docs/ja/model-config.md#adjust-effort-level)を継承します。分割ペインモードではこれは v2.1.186 から適用されます。それより前のバージョンではリーダーのセッションの effort を分割ペインのチームメイトに渡していませんでした。別のモデルで動作するチームメイトについては、[サブエージェントとチームメイトの effort レベル](https://code.claude.com/docs/ja/model-config.md#effort-level-of-subagents-and-teammates)を参照してください。
 
 ### チームメンバーが実装前にプランを立てるようにする
 
-複雑またはリスクの高いタスクの場合、チームメンバーが実装前にプランを立てることができます。リーダーが[プランモード](https://code.claude.com/docs/ja/permission-modes.md#analyze-before-you-edit-with-plan-mode)にある間に Claude がスポーンするチームメンバーは、プランが準備できるまで読み取り専用プランモードで動作します。まずリーダーをプランモードに切り替えてから、チームメンバーを要求してください。
+複雑またはリスクの高いタスクの場合、チームメンバーが実装前にプランを立てることができます。リーダーが [plan モード](https://code.claude.com/docs/ja/permission-modes.md#analyze-before-you-edit-with-plan-mode)にある間に Claude がスポーンするチームメンバーも、プランが準備できるまで plan モードで動作します。まずリーダーを plan モードに切り替えてから、チームメンバーを要求してください。
 
 ```text wrap theme={null}
@@ -169,5 +169,5 @@ Spawn an architect teammate to refactor the authentication module.
 ```
 
-そのチームメイトがプランを完了すると、リーダーにプラン承認リクエストを送信します。スポーン後にそのチームメイトの権限モードを変更していない場合、Claude Code はリクエストが到着するとすぐにプランを承認し、リーダーがそれをレビューすることはありません。チームメイトの編集とコマンドは、引き続き[権限](#permissions)で説明されている権限プロンプトを通過します。承認されると、チームメイトは plan モードを終了し、実装を開始します。
+そのチームメイトがプランを完了すると、リーダーにプラン承認リクエストを送信します。スポーン後にそのチームメイトの権限モードを変更していない場合、Claude Code はリクエストが到着するとすぐにプランを承認し、リーダーがそれをレビューすることはありません。承認されると、チームメイトは plan モードを終了し、実装を開始します。Claude Code はチームメイトにリーダーの現在の[権限モード](#permissions)を渡します。それが plan モードの場合は Manual を渡します。
 
 実行中の in-process チームメイトのセッションを表示している間に [`Shift+Tab`](https://code.claude.com/docs/ja/permission-modes#switch-permission-modes) を押してそのチームメイトを plan モードにした場合、その実行のプランは Claude Code が承認するのではなく、リーダーがレビューします。ユーザーに承認は求められません。リーダーがプランを承認するか、修正のために差し戻します。
@@ -220,51 +220,51 @@ Ask the researcher teammate to shut down
 * [`TaskCompleted`](https://code.claude.com/docs/ja/hooks#taskcompleted)：タスクが完了としてマークされているときに実行されます。終了コード 2 で完了を防止し、フィードバックを送信してください。
 
-## エージェントチームの動作方法
+## エージェントチームの仕組み
 
-このセクションでは、エージェントチームの背後にあるアーキテクチャとメカニクスについて説明します。使用を開始したい場合は、上記の [エージェントチームを制御する](#control-your-agent-team) を参照してください。
```

</details>

<details>
<summary>agent-view-ja.md</summary>

```diff
diff --git a/docs-ja/pages/agent-view-ja.md b/docs-ja/pages/agent-view-ja.md
index 9ca98d7..13d88ca 100644
--- a/docs-ja/pages/agent-view-ja.md
+++ b/docs-ja/pages/agent-view-ja.md
@@ -443,5 +443,5 @@ Claude Code がセッションをバックグラウンドにすると（約 10 
 `/background` またはそのエイリアス `/bg` を実行すると、現在の会話がバックグラウンドセッションに移動します。`/bg run the test suite and fix any failures` のようにプロンプトを渡すと、先にもう 1 つ指示を与えられます。`/bg` の実行時に Claude が応答中の場合、応答はバックグラウンドセッションで続行されます。
 
-サブエージェント、バックグラウンドシェルコマンド、ワークフロー、[モニター](https://code.claude.com/docs/ja/tools-reference.md#monitor-tool) などのバックグラウンド作業がまだ実行中のセッションを終了しようとすると、すぐに終了する代わりに `Background work is running` ダイアログが表示されます。`Move to background and exit` を選択すると、`/background` と同じ方法でセッションをバックグラウンドに移動してシェルに戻ります。エージェントビューが [オフになっている](#turn-off-agent-view) 場合、このオプションは表示されません。
+サブエージェントやワークフローなど、特定の種類のバックグラウンド作業が実行中にセッションを終了すると、`Background work is running` ダイアログが表示され、その作業が停止することを警告します。`Move to background and exit` を選択すると、`/background` と同じ方法でセッションをバックグラウンドに移動してシェルに戻ります。エージェントビューが [オフになっている](#turn-off-agent-view) 場合、このオプションは表示されません。
 
 リスト上のバックグラウンドセッションが既にその会話の名前を持っている場合、Claude Code は新しい行の名前に `my-session (2)` のような番号を付け、既存の行の名前はそのままにします。新しい行の名前を変更するには、エージェントビューでその行を選択して `Ctrl+R` を押します。
```

</details>

<details>
<summary>amazon-bedrock-ja.md</summary>

```diff
diff --git a/docs-ja/pages/amazon-bedrock-ja.md b/docs-ja/pages/amazon-bedrock-ja.md
index 6490b2d..0664f02 100644
--- a/docs-ja/pages/amazon-bedrock-ja.md
+++ b/docs-ja/pages/amazon-bedrock-ja.md
@@ -465,7 +465,9 @@ Claude Code は、各リクエストで `X-Amzn-Bedrock-Service-Tier` ヘッダ
 ## AWS Guardrails
 
-[Amazon Bedrock Guardrails](https://docs.aws.amazon.com/bedrock/latest/userguide/guardrails.html)を使用すると、Claude Code のコンテンツフィルタリングを実装できます。[Amazon Bedrock コンソール](https://console.aws.amazon.com/bedrock/)で Guardrail を作成し、バージョンを公開してから、Guardrail ヘッダーを [settings file](https://code.claude.com/docs/ja/settings.md) に追加します。クロスリージョン推論プロファイルを使用している場合は、Guardrail でクロスリージョン推論を有効にしてください。
+[Amazon Bedrock Guardrails](https://docs.aws.amazon.com/bedrock/latest/userguide/guardrails.html)を使用すると、Claude Code のコンテンツフィルタリングを実装できます。[Amazon Bedrock コンソール](https://console.aws.amazon.com/bedrock/)で Guardrail を作成し、バージョンを公開します。クロスリージョン推論プロファイルを使用している場合は、Guardrail でクロスリージョン推論を有効にしてください。
 
-設定例：
+[Claude apps gateway](https://code.claude.com/docs/ja/claude-apps-gateway) を通じて Guardrail を適用するには、[Amazon Bedrock guardrail を適用する](https://code.claude.com/docs/ja/claude-apps-gateway-config.md#apply-an-amazon-bedrock-guardrail)の手順に従ってください。Claude apps gateway を使用しない場合は、Guardrail ヘッダーを[設定ファイル](https://code.claude.com/docs/ja/settings.md)に追加します。
+
+設定ファイルの設定例：
 
 ```json theme={null}
@@ -477,6 +479,4 @@ Claude Code は、各リクエストで `X-Amzn-Bedrock-Service-Tier` ヘッダ
 ```
 
-組織が [Claude apps gateway](https://code.claude.com/docs/ja/claude-apps-gateway) ポリシーを通じて guardrail ヘッダーを配信する場合、それらは [承認が必要な設定](https://code.claude.com/docs/ja/server-managed-settings.md#environment-variables-and-the-approval-dialog)としてカウントされます。
-
 guardrail が応答を途中でブロックした場合、それまでにストリーミングされたテキストはそのまま残り、応答はブロックされた応答用に guardrail で設定されたメッセージで終了します。
 
```

</details>

<details>
<summary>best-practices-ja.md</summary>

```diff
diff --git a/docs-ja/pages/best-practices-ja.md b/docs-ja/pages/best-practices-ja.md
index 7854452..c5fa631 100644
--- a/docs-ja/pages/best-practices-ja.md
+++ b/docs-ja/pages/best-practices-ja.md
@@ -156,5 +156,5 @@ Claude Code は [`CLAUDE.md`](https://code.claude.com/docs/ja/memory) をすべ
 ```
 
-セッション内で `/context` を実行すると、Claude がファイルを読み込んだことを確認できます。
+セッション内で [`/context all`](https://code.claude.com/docs/ja/commands#all-commands) を実行すると、Claude がファイルを読み込んだことを確認できます。
 
 型チェックの行はコマンドだけである点に注目してください。Claude は作業しながら自分の作業を確認できるよう、コマンドを知っている必要があります。Claude が終了する前に型チェックの合格を Claude Code に*強制*させたい場合は、[`Stop` フック](#enforce-the-check-with-a-stop-hook)の出番です。このファイルに `Always typecheck before you finish` のような行を書いても、たいていは機能しますが、毎回ではありません。
@@ -604,5 +604,5 @@ config/dev-credentials.json
 > `claude -p --worktree` の実行は確認せずに終了するため、自分でクリーンアップする必要があります。`git worktree remove <path>` で削除し、worktree がロックされているために git が拒否する場合は、先に `git worktree unlock <path>` を実行します。
 
-多数のファイルにわたる 1 つの大きな機械的変更には、[`/batch migrate every handler to the v2 response helpers`](https://code.claude.com/docs/ja/commands) が作業を 5～30 個の単位に分割し、計画を表示します。その後、各単位を専用の worktree で実行し、それぞれについて PR を作成します。シェルからは、[`claude agents`](https://code.claude.com/docs/ja/agent-view)（まだリサーチプレビュー）で、マシン上のバックグラウンドで実行中のすべてを 1 つの画面で確認できます。
+多数のファイルにわたる 1 つの大きな機械的変更には、[`/batch migrate every handler to the v2 response helpers`](https://code.claude.com/docs/ja/commands) が作業を 5～30 個の単位に分割し、計画を表示します。計画を承認すると、各単位に専用の worktree が割り当てられ、PR を作成するか、何が起きたかを報告します。シェルからは、[`claude agents`](https://code.claude.com/docs/ja/agent-view)（まだリサーチプレビュー）で、マシン上のバックグラウンドで実行中のすべてを 1 つの画面で確認できます。
 
 2 つ目のセッションは、手に入る中で最も手軽な独立レビュアーでもあります。一方のセッションがレートリミッターを書き、もう一方が書かれる過程を見ずに `@src/middleware/rateLimiter.ts` をレビューし、その指摘を最初のセッションに貼り付けます。`/code-review` と同じ考え方で、メッセージの受け渡しをユーザーが行う形です。
```

</details>

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index 9d784f1..2aae83b 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,91 @@
 # Changelog
 
+## 2.1.318
+
+- Added a record of your answer when Claude Code asks to turn on the mods it writes in a session
+- Added `assume_role` on `mantle` upstreams of the Claude apps gateway, for a role in another AWS account and for per-developer AWS cost attribution
+- Added an `effort` option to a mod's `$.model.fork`, so a quick side job can run at `low` whatever effort the session uses; the result reports the effort sent
+- Added the date a stored claude.ai sign-in ends to `claude auth status` (`loginExpiresAt`) and to `claude -p` JSON results (`credential_expires_at`)
+- Added a one-line stderr warning to `claude -p` text output, starting 10 days before a stored claude.ai sign-in ends
+- Fixed `--continue` sometimes losing the earlier conversation after a malformed tool call's retries ran out (regression in 2.1.314)
+- Fixed macOS sessions with many running Bash commands stalling while memory grew
+- Fixed permission prompts being answered by keys typed just after sending a message, or before a slow prompt appeared
+- Fixed `/logout`, `claude auth logout` and `claude mcp remove` reporting success, and changes to trust, consent or MCP settings being dropped with no word, when the config file could not be updated on a shared network home directory
+- Fixed jobs exiting with `Not logged in` when another terminal or host signs in again to the same account and organization on the same home
+- Fixed `claude mcp add` and `remove` writing the config without its lock: they now wait for it or exit 1, though another job's save can still replace a saved server
+- Fixed `claude plugin` commands exiting before a slow token refresh was saved, which could sign you out on the next run
+- Fixed `claude plugin validate` passing a custom-named marketplace file that `claude plugin marketplace add` rejects
+- Fixed stdio MCP servers that exit on the version probe being re-probed on every start; a server that dies in under 3s for its own reason is also pinned to the legacy handshake for 7 days
+- Fixed sessions being refused at startup by an `allowedProviders` list that another login on the same machine had stored
+- Fixed idle compaction replacing a conversation with a reply that was not a summary
+- Fixed the "Now using usage credits" notice reappearing about every 30 seconds while a background subagent is running
+- Fixed custom slash commands that fail, or that only Claude can invoke, printing nothing in `claude -p` and SDK sessions
+- Fixed `claude -p` and Agent SDK sessions reporting success when an API error cut off a reply while a mod hooked `turn.step`
+- Fixed a message sent right after a model change still running after Stop in headless sessions: Stop now cancels or stops it as it would a queued message
+- Fixed a deleted session transcript being re-created with its last prompt when an idle non-interactive session exited
```

</details>

<details>
<summary>claude-apps-gateway-config-ja.md</summary>

```diff
diff --git a/docs-ja/pages/claude-apps-gateway-config-ja.md b/docs-ja/pages/claude-apps-gateway-config-ja.md
index 3b8115a..be1b421 100644
--- a/docs-ja/pages/claude-apps-gateway-config-ja.md
+++ b/docs-ja/pages/claude-apps-gateway-config-ja.md
@@ -493,5 +493,5 @@ upstreams:
 * STS が拒否した場合や到達できない場合、ゲートウェイはアップストリーム自身の認証情報でリクエストを送信しません。確認すべき点とともに STS エラーをログに記録し、列挙した次のアップストリームを試行します。どのアップストリームも成功しなかった場合にクライアントが受け取る内容については、[アップストリームのエラーメッセージ](#upstream-error-messages)で説明しています。`assume_role` のない後続のアップストリームは自身の認証情報でリクエストを処理するため、それを意図する場合にのみ列挙してください。
 * ゲートウェイはリージョンの STS エンドポイント `sts.<region>.amazonaws.com` を呼び出すため、ゲートウェイのネットワークからそこに到達できる必要があります。FIPS エンドポイントを使用するには、AWS 設定ファイルの `use_fips_endpoint` ではなく、ゲートウェイの環境で `AWS_USE_FIPS_ENDPOINT=true` を設定してください。
-* `assume_role` は `provider: bedrock` にのみ適用され、SigV4 のソース認証情報が必要です。`aws_bearer_token` と並べて設定すると、ゲートウェイは起動を拒否します。
+* `assume_role` には SigV4 のソース認証情報が必要です。`aws_bearer_token` と並べて設定すると、ゲートウェイは起動を拒否します。
 * [`groups` リスト](#send-each-team-to-its-own-upstream)がない場合、ゲートウェイが許可するすべての開発者がこのアップストリームを使用できます。開発者が使用できるモデルを制限するには、[`managed`](#managed) ポリシーで `availableModels` を設定してください。
 * ロール経由で提供されるモデルが別のアカウントからも提供されないようにするには、そのモデルに、`upstream_model` マップにこのアップストリームの名前のみを持つカスタム ID を割り当ててください。そのような ID の場合、ゲートウェイは他のすべてのアップストリームをスキップするため、リクエストも、中断されたリクエストのトークンカウントも、別のアカウントにフェイルオーバーすることはありません。
@@ -555,4 +555,5 @@ upstreams:
 | `models` | はい | AWS アカウントに Mantle で付与されているモデル。`claude-haiku-4-5` のように、クライアントが送信する名前で指定します。これらのモデルのみがこのアップストリームに送信され、その他のモデルはすべて次のアップストリームにスキップされます。 |
 | `auth` | いいえ | [Amazon Bedrock](#amazon-bedrock) アップストリームの `auth` ブロックと同じキーを、同じルールで受け付けます。 |
+| `assume_role` | いいえ | このアップストリームのリクエストが経由するロール。[`bedrock` アップストリームの場合](#bedrock-in-another-aws-account)と同じキーを持ち、[開発者ごとの帰属](#per-developer-aws-cost-attribution)用の `session_name` も含みます。ロールには Mantle の IAM アクションを付与してください。Claude Code v2.1.318 以降を実行しているゲートウェイが必要です。それより前のゲートウェイは、起動時に `Unrecognized key(s) in object: 'assume_role'` で終了します。 |
 | `base_url` | いいえ | 導出されたエンドポイントを上書きします。末尾の `/anthropic` パスは残してください。 |
 
@@ -564,5 +565,5 @@ upstreams:
 
 * **`guardrail`**: ゲートウェイは Mantle に送信するリクエストに [Bedrock ガードレール](#apply-an-amazon-bedrock-guardrail)を適用しないため、いずれかの `bedrock` アップストリームで `guardrail` が設定されている状態で `mantle` アップストリームが列挙されていると、起動を拒否します。
-* **`assume_role`**: `mantle` アップストリームは [`assume_role`](#bedrock-in-another-aws-account) を受け付けません。Mantle が処理するリクエストは `mantle` アップストリーム自身の `auth` 認証情報で送信され、[開発者ごとに帰属](#per-developer-aws-cost-attribution)されません。
+* **`assume_role`**：`mantle` アップストリーム自体に設定してください。設定しない場合、Mantle が処理するリクエストは `mantle` アップストリーム自身の `auth` の認証情報で送信されます。
 
 Mantle 自身のエラーレスポンスの意味については、[Mantle エンドポイントのエラー](https://code.claude.com/docs/ja/amazon-bedrock.md#mantle-endpoint-errors)を参照してください。
```

</details>

<details>
<summary>cli-reference-ja.md</summary>

```diff
diff --git a/docs-ja/pages/cli-reference-ja.md b/docs-ja/pages/cli-reference-ja.md
index d63f63b..c908d0d 100644
--- a/docs-ja/pages/cli-reference-ja.md
+++ b/docs-ja/pages/cli-reference-ja.md
@@ -86,5 +86,5 @@
 | `--disable-slash-commands` | このセッションのすべてのスキルとコマンドを無効にします | `claude --disable-slash-commands` |
 | `--disallowedTools`, `--disallowed-tools` | 拒否ルール。ベアツール名は一致するツールを Claude のコンテキストから削除します。`"Edit"` は Edit を削除し、`"*"` はすべてのツールを削除し、`"mcp__*"` はすべての MCP ツールを削除します。`Bash(rm *)` などのスコープ付きルールはツールを利用可能なままにし、[書かれたとおりに](https://code.claude.com/docs/ja/permissions.md#bash-rule-limits)一致する呼び出しのみを拒否します。[`EndConversation`](https://code.claude.com/docs/ja/tools-reference#endconversation-tool-behavior)という名前のルールは、他のツールが残っている間はそれを削除できません | `"Bash(git log *)" "Bash(git diff *)" "Edit"` |
-| `--effort` | 現在のセッションの[努力レベル](https://code.claude.com/docs/ja/model-config.md#adjust-effort-level)を設定します。オプション：`low`、`medium`、`high`、`xhigh`、`max`、または `ultracode`。利用可能なレベルはモデルによって異なります。`ultracode` は [ultracode](https://code.claude.com/docs/ja/workflows.md#let-claude-decide-with-ultracode) をオンにして `xhigh` 努力をリクエストし、Claude Code v2.1.203 以降が必要です。このセッションの [`modelSettings`](https://code.claude.com/docs/ja/settings-reference#modelsettings) と [`effortLevel`](https://code.claude.com/docs/ja/settings-reference#effortlevel) 設定をオーバーライドし、保持されません | `claude --effort high` |
+| `--effort` | 現在のセッションの [effort レベル](https://code.claude.com/docs/ja/model-config.md#adjust-effort-level)を設定します。オプション：`low`、`medium`、`high`、`xhigh`、`max`、または `ultracode`。利用可能なレベルはモデルによって異なります。`ultracode` は [ultracode](https://code.claude.com/docs/ja/workflows.md#let-claude-decide-with-ultracode) をオンにして `xhigh` effort を要求し、Claude Code v2.1.203 以降が必要です。メイン会話のモデルでは、このセッションの [`modelSettings`](https://code.claude.com/docs/ja/settings-reference#modelsettings) と [`effortLevel`](https://code.claude.com/docs/ja/settings-reference#effortlevel) 設定を上書きし、保持されません | `claude --effort high` |
 | `--enable-auto-mode` | v2.1.111 で削除されました。オートモードはデフォルトで `Shift+Tab` サイクルに含まれるようになりました。`--permission-mode auto` を使用して開始します | `claude --permission-mode auto` |
 | `--environment <environment-id>` | 指定された ID の[自己ホスト環境](https://code.claude.com/docs/ja/self-hosted-environments)で実行される新しいクラウドセッションを作成します。環境 ID は `ccpool_` で始まります。ディスパッチ動作とそれが拒否するフラグの組み合わせについては、[`--environment` ディスパッチ動作](https://code.claude.com/docs/ja/self-hosted-environments-testing#environment-dispatch-behavior)を参照してください。Claude Code v2.1.224 以降が必要です | `claude -p "Fix the login bug" --environment ccpool_abc123` |
```

</details>

*...以降省略*

</details>


<details>
<summary>2026-11-03</summary>

**変更ファイル:**

```
 docs-ja/pages/admin-setup-ja.md                |   2 +
 docs-ja/pages/amazon-bedrock-ja.md             |  20 ++-
 docs-ja/pages/analytics-ja.md                  |  20 +--
 docs-ja/pages/authentication-ja.md             |   2 +-
 docs-ja/pages/auto-mode-config-ja.md           |  39 ++++-
 docs-ja/pages/best-practices-ja.md             |   2 +-
 docs-ja/pages/changelog.md                     |  90 ++++++++++
 docs-ja/pages/claude-apps-gateway-config-ja.md | 229 +++++++++++++++++++++++--
 docs-ja/pages/claude-apps-gateway-deploy-ja.md |   9 +-
 docs-ja/pages/claude-apps-gateway-ja.md        |   2 +-
 docs-ja/pages/claude-apps-gateway-on-aws-ja.md |   2 +-
 docs-ja/pages/cli-reference-ja.md              |   4 +-
 docs-ja/pages/cloud-environments-ja.md         |   1 +
 docs-ja/pages/commands-ja.md                   |   4 +-
 docs-ja/pages/costs-ja.md                      |  10 +-
 docs-ja/pages/desktop-ja.md                    |  33 ++--
 docs-ja/pages/env-vars-ja.md                   |  15 +-
 docs-ja/pages/errors-ja.md                     |  87 ++++++++--
 docs-ja/pages/fast-mode-ja.md                  |   9 +-
 docs-ja/pages/google-vertex-ai-ja.md           |  15 +-
 docs-ja/pages/hooks-guide-ja.md                |   2 +-
 docs-ja/pages/hooks-ja.md                      |   6 +-
 docs-ja/pages/interactive-mode-ja.md           |  12 +-
 docs-ja/pages/llm-gateway-protocol-ja.md       |  35 +++-
 docs-ja/pages/llm-gateway-rollout-ja.md        |   2 +-
 docs-ja/pages/managed-settings-ja.md           |   4 +-
 docs-ja/pages/mcp-ja.md                        |  24 ++-
 docs-ja/pages/memory-ja.md                     |  11 +-
 docs-ja/pages/model-config-ja.md               |   2 +-
 docs-ja/pages/monitoring-usage-ja.md           |   2 +-
 docs-ja/pages/network-config-ja.md             |   6 +-
 docs-ja/pages/permission-modes-ja.md           |  10 +-
 docs-ja/pages/permissions-ja.md                |  11 +-
 docs-ja/pages/remote-control-ja.md             |   6 +-
 docs-ja/pages/routines-ja.md                   |   2 +-
 docs-ja/pages/sandboxing-ja.md                 |   1 +
 docs-ja/pages/server-managed-settings-ja.md    |   9 +
 docs-ja/pages/settings-ja.md                   |   5 +-
 docs-ja/pages/settings-reference-ja.md         |  57 +++++-
 docs-ja/pages/slack-ja.md                      |  20 +--
 docs-ja/pages/sub-agents-ja.md                 |   4 +-
 docs-ja/pages/tools-reference-ja.md            |  35 ++--
 docs-ja/pages/worktrees-ja.md                  |  20 ++-
 43 files changed, 729 insertions(+), 152 deletions(-)
```

<details>
<summary>admin-setup-ja.md</summary>

```diff
diff --git a/docs-ja/pages/admin-setup-ja.md b/docs-ja/pages/admin-setup-ja.md
index ce2c6f9..9dba669 100644
--- a/docs-ja/pages/admin-setup-ja.md
+++ b/docs-ja/pages/admin-setup-ja.md
@@ -80,4 +80,6 @@ WSL セッションが有効になった後、管理設定をそれらに拡張
 * WSL セッション内で `/status` を実行して検証し、`Setting sources` 行を読んでください。それを解釈する方法については、[/status で出力を読む](https://code.claude.com/docs/ja/managed-settings.md#read-the-source-in-/status)を参照してください。
 
+Claude Desktop の [`allowedWorkspaceFolders`](https://claude.com/docs/third-party/claude-desktop/configuration#allowedworkspacefolders) リストが設定されたデバイスで WSL セッションが開始される場合、`~` エントリはディストリビューション内のホームディレクトリを意味します。
+
 WSL 2 ユーティリティ VM 内のプロセスは、Windows 側のエンドポイント検出センサーに表示されません。ディストリビューション内のプロセスとファイルアクティビティを観察するには、エンドポイント検出ベンダーの WSL ガイダンスで、ディストリビューション内で実行できる Linux センサーと、それが必要とする除外を確認してください。Claude Code の [OpenTelemetry ツール実行テレメトリ](https://code.claude.com/docs/ja/monitoring-usage.md)は WSL とネイティブセッションで同じように出力されます。
 
```

</details>

<details>
<summary>amazon-bedrock-ja.md</summary>

```diff
diff --git a/docs-ja/pages/amazon-bedrock-ja.md b/docs-ja/pages/amazon-bedrock-ja.md
index 3b47cb2..6490b2d 100644
--- a/docs-ja/pages/amazon-bedrock-ja.md
+++ b/docs-ja/pages/amazon-bedrock-ja.md
@@ -309,13 +309,27 @@ export ANTHROPIC_MODEL='arn:aws:bedrock:us-east-2:your-account-id:application-in
 Claude Code が Amazon Bedrock で設定されて起動する場合、使用予定のモデルがアカウントでアクセス可能であることを確認します。
 
-現在の Claude Code デフォルトより古いモデルバージョンをピン留めしており、アカウントが新しいバージョンを呼び出せる場合、Claude Code はピンを更新するよう促します。受け入れると、新しいモデル ID が[ユーザー設定ファイル](https://code.claude.com/docs/ja/settings.md)に書き込まれ、Claude Code が再起動します。拒否すると、次のデフォルトバージョン変更まで記憶されます。[アプリケーション推論プロファイル ARN](#map-each-model-version-to-an-inference-profile) を指す pin は、管理者によって管理されるため、スキップされます。
+現在の Claude Code デフォルトより古いモデルバージョンをピン留めしている場合があります。アカウントが新しいバージョンを呼び出せる場合、Claude Code はピンを更新するよう促します。受け入れると、新しいモデル ID が[ユーザー設定ファイル](https://code.claude.com/docs/ja/settings.md)に書き込まれ、Claude Code が再起動します。拒否すると、次のデフォルトバージョン変更まで記憶されます。
+
+Claude Code は、次のピンについてはチェックも更新の促しも行いません。
+
+* [管理設定](https://code.claude.com/docs/ja/managed-settings.md)の `env` ブロック内のピン
+* [アプリケーション推論プロファイル ARN](#map-each-model-version-to-an-inference-profile) を指すピン（管理者が管理しているため）
+
+管理設定のピンについて更新の促しが引き続き表示される場合は、Claude Code を v2.1.314 以降に更新してください。v2.1.314 より前では、受け入れた後も管理設定のピンが有効なままだったため、次回の起動時に再び促しが表示されていました。
 
 モデルをピン留めしておらず、現在のデフォルトがアカウントで利用できない場合、Claude Code は現在のセッションにフォールバックし、通知を表示します。デフォルトモデルの以前のバージョンを最初に試し、デフォルトが Opus モデルで Opus バージョンが利用できない場合、デフォルト Sonnet モデルにフォールバックします。フォールバックは保持されません。Amazon Bedrock アカウントで新しいモデルを有効にするか、[バージョンをピン留めして](#4-pin-model-versions)選択を永続的にしてください。
 
+### 特定のモデルでセッションを開始する
+
 特定の Sonnet または Opus バージョンでセッションを開始する場合（例えば `--model`、`ANTHROPIC_MODEL`、または[`model` 設定](https://code.claude.com/docs/ja/settings-reference#model)を使用）、そのバージョンは一致する `sonnet` または `opus` エイリアスのセッションのピン留めされたデフォルトとして機能します。Claude Code は、設定したモデルが置き換える組み込みデフォルトの可用性チェックをスキップし、設定したモデルで起動し、フォールバック通知はありません。
 
-`opus` などのモデルエイリアスはピンとして機能せず、Claude Code が認識しないモデル ID（アプリケーション推論プロファイル ARN など）も同様です。
+次のものでセッションを開始しても、ピンとしては機能しません。
+
+* `opus` などのモデルエイリアス
+* Claude Code が認識しないモデル ID（アプリケーション推論プロファイル ARN など）
+
+### 記憶されたモデルの拒否
```

</details>

<details>
<summary>analytics-ja.md</summary>

```diff
diff --git a/docs-ja/pages/analytics-ja.md b/docs-ja/pages/analytics-ja.md
index 13a8c5b..cc8b9e9 100644
--- a/docs-ja/pages/analytics-ja.md
+++ b/docs-ja/pages/analytics-ja.md
@@ -78,5 +78,5 @@ GitHub 認証フローを完了し、分析に含める GitHub 組織を選択
 * **PRs with Claude Code（%）**：Claude Code 支援コードを含むすべてのマージされた PR のパーセンテージ
 * **Suggestion accept rate**：ユーザーが Claude Code のコード編集提案を受け入れる回数のパーセンテージ。Edit、Write、NotebookEdit ツール使用を含みます。
-* **Lines of code accepted**：ユーザーがセッション内で受け入れた Claude Code で記述されたコード行の総数。これは拒否された提案を除外し、その後の削除を追跡しません。
+* **Lines of code accepted**：受け入れられた編集において Claude Code の Edit ツールと Write ツールが追加または削除したコード行の総数。拒否された提案は除外され、後で削除された行によって合計が減ることはありません。
 
 ### チャートを探索する
@@ -193,5 +193,5 @@ GitHub を通じてこのデータをクエリするには、`claude-code-assist
 ## API カスタマー向けの分析にアクセスする
 
-Claude Console を使用している API カスタマーは、[platform.claude.com/claude-code](https://platform.claude.com/claude-code) で分析にアクセスできます。ダッシュボードにアクセスするには UsageView 権限が必要です。これは Developer、Billing、Admin、Owner、Primary Owner ロールに付与されます。同じ日次ユーザーごとのメトリクスをプログラムで取得するには、Admin API キーを使用して [Claude Code Analytics API](https://platform.claude.com/docs/ja/build-with-claude/claude-code-analytics-api) を使用してください。
+Claude Console を使用している API カスタマーは、[platform.claude.com/claude-code](https://platform.claude.com/claude-code) で分析にアクセスできます。ダッシュボードにアクセスするには UsageView 権限が必要です。これは Developer、Billing、Admin、Owner、Primary Owner ロールに付与されます。日次のユーザーごとのメトリクスをプログラムで取得するには、Admin API キーを使用して [Claude Code Analytics API](https://platform.claude.com/docs/ja/build-with-claude/claude-code-analytics-api) を使用してください。
 
 > [!NOTE]
@@ -201,20 +201,20 @@ Claude Console を使用している API カスタマーは、[platform.claude.c
 Console ダッシュボードは以下を表示します。
 
-* **Lines of code accepted**：ユーザーがセッション内で受け入れた Claude Code で記述されたコード行の総数。これは拒否された提案を除外し、その後の削除を追跡しません。
+* **Lines of code accepted**：受け入れられた編集において、Claude Code の Edit ツールと Write ツールが追加または削除したコード行の総数。拒否された提案は除外され、後から削除された行によって合計が減ることはありません。
 * **Suggestion accept rate**：ユーザーがコード編集ツール使用を受け入れる回数のパーセンテージ。Edit、Write、NotebookEdit ツールを含みます。
-* **Activity**：チャートに表示される日次アクティブユーザーとセッション。
-* **Spend**：ユーザー数と並んでドルでの日次 API コスト。
+* **Active users** と **Sessions**：アクティブユーザー数と Claude Code セッション数の日次カウント。
+* **Spend**：ドルでの日次 API コスト。
 
 ### チームインサイトを表示する
```

</details>

<details>
<summary>authentication-ja.md</summary>

```diff
diff --git a/docs-ja/pages/authentication-ja.md b/docs-ja/pages/authentication-ja.md
index 4c5c280..a9865d3 100644
--- a/docs-ja/pages/authentication-ja.md
+++ b/docs-ja/pages/authentication-ja.md
@@ -252,5 +252,5 @@ Claude Code は認証情報を安全に管理します。
 3. `ANTHROPIC_API_KEY` 環境変数。`X-Api-Key` ヘッダーとして送信されます。[Claude Console](https://platform.claude.com) からのキーを使用して Anthropic API に直接アクセスする場合に使用します。対話モードでは、キーを承認または拒否するよう 1 回プロンプトが表示され、選択が記憶されます。後で変更するには、`/config` の「Use custom API key」トグルを使用します。トグルは `ANTHROPIC_API_KEY` が環境に設定されている間のみ表示されます。非対話モード（`-p`）では、キーが存在する場合は常に使用されます。
 4. [`apiKeyHelper`](https://code.claude.com/docs/ja/settings-reference#apikeyhelper) スクリプト出力。動的または回転する認証情報（ボルトから取得した短期トークンなど）に使用します。
-5. `CLAUDE_CODE_OAUTH_TOKEN` 環境変数。[`claude setup-token`](#generate-a-long-lived-token) によって生成された長期 OAuth トークン。ブラウザログインが利用できない CI パイプラインとスクリプトに使用します。この変数が設定されている間に `/login` を実行すると、Claude Code は現在のセッションを新しいログインに切り替えますが、シェルプロファイルまたは[設定ファイル](https://code.claude.com/docs/ja/settings.md)の `env` ブロックから変数を削除するまで、新しいセッションのたびに変数を再度読み込みます。
+5. `CLAUDE_CODE_OAUTH_TOKEN` 環境変数。[`claude setup-token`](#generate-a-long-lived-token) によって生成された長期 OAuth トークン。ブラウザログインが利用できない CI パイプラインとスクリプトに使用します。この変数が設定されている間に `/login` を実行すると、Claude Code は現在のセッションを新しいログインに切り替えます。新しいセッションでもそのログインを維持するには、シェルプロファイルと、ユーザー設定など[この変数を設定できる設定ファイル](https://code.claude.com/docs/ja/settings-reference.md#variables-claude-code-ignores-in-env)から変数を削除してください。
 6. Anthropic プロファイルおよびフェデレーション認証情報。`ant` CLI および Workload Identity Federation が使用する認証情報。`ant auth login` が書き込んだプロファイルは、`ANTHROPIC_PROFILE` で名前を付けた場合にのみここにランク付けされます。そうでない場合は `/login` より下にランク付けされます。[Anthropic プロファイルおよびフェデレーション認証情報](#anthropic-profiles-and-federation-credentials)を参照してください。
 7. `/login` からのサブスクリプション OAuth 認証情報。これは Claude Pro、Max、Ultra、Team、および Enterprise ユーザーのデフォルトです。
```

</details>

<details>
<summary>auto-mode-config-ja.md</summary>

```diff
diff --git a/docs-ja/pages/auto-mode-config-ja.md b/docs-ja/pages/auto-mode-config-ja.md
index 8dd2f4c..64c9a47 100644
--- a/docs-ja/pages/auto-mode-config-ja.md
+++ b/docs-ja/pages/auto-mode-config-ja.md
@@ -356,19 +356,46 @@ claude auto-mode reset
 ## 拒否の確認
 
-オートモード分類器が拒否したアクションを確認して再試行するには、`/permissions` を開いて **Recently denied** タブを選択します。ここで Claude Code は各拒否を記録しています。拒否されたアクションで `r` を押してリトライ対象としてマークします。ダイアログを終了すると、Claude Code はモデルにそのツール呼び出しを再試行できることを伝えるメッセージを送信し、会話を再開します。
+ブロックされたアクションを Claude に再試行させるには、`/permissions` の **Recently blocked** タブを使用します。
 
-分類器が[アクションの安全性について判定できない](https://code.claude.com/docs/ja/errors.md#auto-mode-cannot-determine-the-safety-of-an-action)場合、オートモードとは別の安全チェックが分類器自身のリクエストを拒否したか、またはそのレスポンスが解析できなかったため、Claude Code はアクションを拒否しますが、**Recently denied** に記録しません。リンク先のエラーエントリでは、Claude に伝えられる内容と、必要な場合にアクションを実行する方法について説明しています。
+**1. タブを開く**
+
+セッションで `/permissions` を実行して権限ダイアログを開き、**Recently blocked** タブを選択します。
+
+**2. アクションを確認する**
+
+アクションの行をハイライトし、リストの下に表示されるコマンドまたは入力を読みます。行の説明は Claude またはツールが書いたものなので、説明ではなくコマンドまたは入力をもとに判断してください。
+
+**3. アクションを承認する**
+
+`r` を押してアクションを承認し、Claude に再試行させます。
+
+**4. ダイアログを閉じる**
+
+`Esc` を押してダイアログを閉じ、承認を適用します。`/permissions` を開いたときに Claude が作業中だった場合は、Claude の作業が終わった後にメッセージを送信すると、Claude がアクションを再試行します。それ以外の場合は何も送信する必要はありません。Claude はすぐに作業を続行し、アクションを再試行することがあります。再試行しない場合は、[会話で伝える承認](https://code.claude.com/docs/ja/permission-modes.md#approvals-you-state-in-conversation)で説明されているように、次のメッセージでそのアクションを指定してください。
+
+アクションを承認しても権限ルールは追加されません。auto モードでは、再試行されたアクションは再びチェックを受けるため、再度ブロックされる可能性があります。今後そのコマンドを通すには、[`allow` ルールを追加](#fix-a-denial-with-an-allow-rule-an-environment-entry-or-a-retry)します。
+
+Claude にすぐに再試行させたくない場合は、アクションを後で使うために承認する、承認を取り消す、またはダイアログを閉じて承認を破棄することができます。
```

</details>

<details>
<summary>best-practices-ja.md</summary>

```diff
diff --git a/docs-ja/pages/best-practices-ja.md b/docs-ja/pages/best-practices-ja.md
index 83ce129..7854452 100644
--- a/docs-ja/pages/best-practices-ja.md
+++ b/docs-ja/pages/best-practices-ja.md
@@ -398,5 +398,5 @@ use a subagent to review the rate limiter diff against SPEC.md, check every requ
 * ユーザーではなく、Claude が読んだコンテンツによって引き起こされたように見えるアクション
 
-実際に何かをブロックすると通知が届き、そのアクションは `/permissions` の **Recently denied** に表示されます。そこから手動承認で再試行できます。[3 回連続](https://code.claude.com/docs/ja/permission-modes.md#when-auto-mode-falls-back)（または合計 20 回）ブロックされると、auto モードは一時停止し、ユーザーに確認する方式に戻ります。
+auto モードがアクションをブロックすると通知が届き、そのアクションは `/permissions` の **Recently blocked** に表示されます。そこで[アクションを承認して Claude が再試行できるようにする](https://code.claude.com/docs/ja/auto-mode-config.md#review-denials)ことができます。[3 回連続](https://code.claude.com/docs/ja/permission-modes.md#when-auto-mode-falls-back)（または合計 20 回）ブロックされると、auto モードは一時停止し、ユーザーに確認する方式に戻ります。
 
 これは決定論的な制御に取って代わるものではありません。それらの*後*に実行されるからです。拒否ルール、確認ルール、`PreToolUse` フックは分類器が何かを見る前に適用されるため、拒否ルールは auto モードでも他のすべての場所とまったく同じようにブロックします。サンドボックスも引き続き、[ラップするシェルコマンド](https://code.claude.com/docs/ja/sandboxing.md#what-runs-outside-the-sandbox)を制限します。
```

</details>

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index f160c85..9d784f1 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,94 @@
 # Changelog
 
+## 2.1.317
+
+- Added a warning to `/schedule` when a new cloud scheduled task gets connectors you did not ask for, with how to remove them
+- Added a check that asks before a web or shell tool call sends your account email address to the network
+- Added `onFailure: "block"` for Agent SDK hook callbacks, so a callback that fails blocks the action instead of letting it run
+- Added a notice in Claude Desktop's Code tab when your organization's remote managed settings haven't loaded for the session, and another once they do
+- Added a notice when auto mode's check has no answer for a subagent's tool call, which used to leave nothing in the main view
+- Added `anthropic.plan`, `anthropic.seat_type`, `anthropic.provider` and `anthropic.custom_base_url` to OTel metrics, events and spans
+- Added a cost report to the Claude apps gateway admin API, `GET /v1/organizations/analytics/cost`, for reading past spend over a date range in total, per developer, per day or per IdP group
+- Added a daily record of each developer's IdP groups on Claude apps gateways with `admin:` set, kept for `admin.identity_retention_days`, which the cost report groups by
+- Added `CLAUDE_CODE_DISABLE_NESTED_SESSION_ID`: set it to `1` on a self-hosted runner to have `claude -p` run inside a session use that session's ID and transcript, as in earlier versions
+- Fixed project and local MCP servers disconnecting after the first turn in some Claude desktop sessions
+- Fixed auto mode failing every turn when an LLM gateway set as the base URL answers 403 or 422 to its server-side safety check (a 403 with an apiKeyHelper is unchanged)
+- Fixed `claude auth status` exiting before a slow token refresh was saved, which could sign you out on the next run
+- Fixed a project's `effortLevel` setting being ignored by sessions that an app starts ahead of time and then opens in the project, such as new sessions in the desktop app's Code tab
+- Fixed `claude --from-pr` reporting "No conversations found" in projects with many sessions when the linked session was older than the first page
+- Fixed the second of two simultaneous permission prompts showing no file path or command on claude.ai and the mobile apps
+- Fixed Remote Control and SDK hosts offering "don't ask again" on a mod's tool calls
+- Fixed session titles being lost in cloud and SDK sessions when a new message or Stop arrived while the title was generating
+- Fixed self-paced `/loop` wakeups sometimes not being scheduled when Claude left a field out of its request
+- Fixed auto mode in cloud sessions stopping for approval when the Artifact tool uploaded, wrote to a database or saved a file through the outputs folder
+- Fixed skills synced from claude.ai being lost or downloaded again every ten minutes when they can't be written to disk
+- Fixed `/schedule` leaving a cloud scheduled task's next run time and link out of its results after creating or updating it
```

</details>

<details>
<summary>claude-apps-gateway-config-ja.md</summary>

```diff
diff --git a/docs-ja/pages/claude-apps-gateway-config-ja.md b/docs-ja/pages/claude-apps-gateway-config-ja.md
index 5f14717..3b8115a 100644
--- a/docs-ja/pages/claude-apps-gateway-config-ja.md
+++ b/docs-ja/pages/claude-apps-gateway-config-ja.md
@@ -213,5 +213,5 @@ export CLAUDE_GATEWAY_PROXY_IS_EGRESS_BOUNDARY=1
 ### `upstreams`
 
-`upstreams` は順序付きリストです。ゲートウェイは、要求されたモデルを解決する最初のアップストリームに推論を転送します。
+`upstreams` は順序付きリストです。ゲートウェイは、要求されたモデルを解決できる最初のアップストリームに推論を転送します。その際、[`groups` リスト](#send-each-team-to-its-own-upstream)にその開発者が含まれていないアップストリームはスキップします。
 
 `5xx`、`429`、`401`、`403`、`404`、またはタイムアウトの場合、ゲートウェイは次のアップストリームにフェイルオーバーします。その他の `4xx` ではフェイルオーバーしません。これらのエラーはアップストリームではなくリクエストに起因するためです。`401` または `403` は、ゲートウェイが使用した認証情報をアップストリームが拒否したか、たとえば要求されたモデルへのアクセスを拒否したことを意味します。`404` は、そのアップストリームが要求されたモデルを提供していないことを意味するため、リスト内の後続のアップストリームが提供できる可能性があります。
@@ -230,5 +230,5 @@ Amazon Bedrock、Claude Platform on AWS、Google Cloud の Agent Platform、Micr
 
 * **ゲートウェイが[フェイルオーバー](#multiple-upstreams)しないステータスをアップストリームが返した場合**: そのアップストリームのレスポンス。ゲートウェイはそれ以上のアップストリームを試行しません。
-* **ゲートウェイが試行したすべてのアップストリームが、[フェイルオーバー対象](#multiple-upstreams)となる形で失敗した場合**: 最後の `429`。`429` を返したものがない場合、ゲートウェイは最後の `401` または `403`、最後の `404`、最後の `501` の順に優先します。いずれも返されなかった場合は、ゲートウェイ独自の `502`、`all upstreams failed (N attempted)` を返します。ここで N は、要求されたモデルを提供していないためにゲートウェイがスキップしたエントリも含め、[`upstreams`](#upstreams) 内のすべてのエントリの数です。
+* **ゲートウェイが試行したすべてのアップストリームが、[フェイルオーバーの対象となる](#multiple-upstreams)形で失敗した場合**：最後の `429`。`429` を返したものがない場合、ゲートウェイは最後の `401` または `403`、最後の `404`、最後の `501` の順に優先します。それらのいずれも返されなかった場合は、ゲートウェイ自身の `502`、`all upstreams failed (N attempted)` を返します。N は、スキップされたものも含めた [`upstreams`](#upstreams) のエントリ数から、[`groups`](#send-each-team-to-its-own-upstream) リストにその開発者が含まれていないものを除いた数です。
 
 ゲートウェイがアップストリームのレスポンスを返すとき、アップストリームのステータスコードは維持されます。アップストリームのメッセージを維持するかどうかはプロバイダーによって異なります。Anthropic API アップストリームのエラー本文は、変更されずに開発者に届きます。
@@ -360,8 +360,4 @@ upstreams:
 ```
 
-> [!WARNING]
->
-> ゲートウェイはガードレールの入力タグをサポートしていません。プロンプトにガードコンテンツタグを追加しないため、Amazon Bedrock がタグ付きの入力にのみ適用するガードレールフィルターは、ゲートウェイを経由するトラフィックでは実行されません。どのフィルターが入力タグに依存するかについては、Amazon Bedrock ドキュメントの[入力タグ](https://docs.aws.amazon.com/bedrock/latest/userguide/guardrails-tagging.html)を参照してください。
-
 また、このアップストリームのリクエストに署名するプリンシパル（ゲートウェイの AWS プリンシパル、または [`assume_role`](#bedrock-in-another-aws-account) を使用する場合は `role_arn` で指定したロール）に、ガードレールに対する `bedrock:ApplyGuardrail` を付与してください。
 
@@ -372,4 +368,88 @@ upstreams:
 `amazon-bedrock-guardrailConfig` などの `amazon-bedrock-*` フィールドを本文に含む `/v1/messages` リクエストが、`guardrail` が設定された Bedrock アップストリームに到達した場合、ゲートウェイはそれを転送せずに 400 を返します。
 
```

</details>

*...以降省略*

</details>


<details>
<summary>2026-11-02</summary>

**変更ファイル:**

```
 docs-ja/pages/desktop-ja.md | 37 ++++++++++++++++++++++++++++++++-----
 docs-ja/pages/setup-ja.md   | 11 ++++++-----
 2 files changed, 38 insertions(+), 10 deletions(-)
```

<details>
<summary>desktop-ja.md</summary>

```diff
diff --git a/docs-ja/pages/desktop-ja.md b/docs-ja/pages/desktop-ja.md
index ddf761f..0248d07 100644
--- a/docs-ja/pages/desktop-ja.md
+++ b/docs-ja/pages/desktop-ja.md
@@ -121,5 +121,5 @@ Claude は dev サーバーを起動し、Browser ペインで開いて変更を
 > [!NOTE]
 >
-> [SSH セッション](#ssh-sessions)では、Claude は Browser ペインのツールを利用できないため、Browser ペインでアプリを開くことができません。アプリを自分で確認するには、[そのポートをコンピューターに転送](#reach-a-port-on-the-remote-machine)します。
+> [SSH セッション](#ssh-sessions)では、Claude は Browser ペインのツールを利用できないため、ペインでアプリを開いたり、変更を[自動検証](#auto-verify-changes)したりすることができません。ペインの **Dev servers** メニューと[設定済みのプレビューサーバー](#configure-preview-servers)も利用できません。アプリを自分で確認するには、リモートマシンでサーバーを起動してから、[そのポートをコンピューターに転送](#reach-a-port-on-the-remote-machine)します。
 
 ローカルセッションで Claude がサーバーを起動した後に Browser ペインが開いていない場合は、チャット内のサーバーのカードにある **Open** をクリックします。
@@ -1003,5 +1003,5 @@ Linux または macOS のリモートマシンには、サポートされてい
 * **インストールフォルダ**：Desktop は、ホームディレクトリの `~/.claude/remote/` の下にヘルパープログラムと Claude Code をインストールします。そこからそれらを実行するため、そのフォルダを `noexec` でマウントされたファイルシステム上に置くことはできません。接続する各ユーザーのホームディレクトリに約 1 GB のディスク容量を確保してください。そのフォルダに含まれる内容については、[リモートマシン上のファイルとプロセス](#files-and-processes-on-the-remote-machine)を参照してください。
 * **シェル**：リモートマシン上のアカウントに設定されているシェルは、Bash、Zsh、`sh` と同様に、SSH 経由で送信されたコマンドを実行できる必要があります
-* **ネットワーク**：Claude Code はリモートマシンで実行され、そこからネットワークリクエストを行うため、マシンには [Claude Code が必要とするネットワークアクセス](https://code.claude.com/docs/ja/network-config.md#network-access-requirements)が必要です。マシンが Claude Code をダウンロードできない場合、Desktop はコンピューター上でダウンロードしてアップロードします。Claude Code のその他のリクエストは引き続きリモートマシンから送信されます。Linux のリモートマシンで、それらのリクエストにプロキシが必要な場合は、[SSH セッション用に設定してください](#set-a-proxy-or-a-ca-certificate-for-ssh-sessions)。
+* **ネットワーク**: Claude Code はリモートマシン上で実行され、そこからネットワークリクエストを送信するため、マシンには [Claude Code が必要とするネットワークアクセス](https://code.claude.com/docs/ja/network-config.md#network-access-requirements)が必要です。マシンが Claude Code をダウンロードできない場合、Desktop が自分のコンピューターでダウンロードしてアップロードします。Claude Code のその他のリクエストは引き続きリモートマシンから送信されます。Linux のリモートマシンでプロキシや CA 証明書が必要な場合は、[SSH セッション用に設定](#set-a-proxy-or-a-ca-certificate-for-ssh-sessions)してください。
 
 #### リモートマシンのホスト鍵を確認する
@@ -1031,5 +1031,5 @@ Linux または macOS のリモートマシンには、サポートされてい
 Linux のリモートマシンがプロキシ経由でインターネットに接続する場合、または CA 証明書が必要な場合は、そのマシン上の `~/.claude/settings.json` の `env` に[プロキシと CA の変数](https://code.claude.com/docs/ja/network-config.md)を追加してください。そのマシンの `~/.profile`、`~/.bash_profile`、`~/.zprofile`、または `~/.zshrc` ですでにエクスポートしている場合でも追加してください。
 
-SSH セッションでは、そのマシンのターミナルで実行した `claude` にはそれらのファイルの変数が渡される場合でも、Claude Code には渡されません。その結果、セッションがハングしたり、**The connection from … to the API failed** や **Authentication failed** が表示されたりすることがあり、再度サインインしても解決しません。
+SSH セッションでは、そのマシンのターミナルで実行する `claude` には変数が渡される場合でも、Claude Code にはこれらのファイルの変数が渡されません。その結果、セッションがハングしたり、**The connection from … to the API failed**、**Authentication failed**、**Claude Code on … couldn’t verify the API connection’s certificate** と表示されたりすることがあります。再度サインインしても解決しません。
 
 **1. 変数を追加する**
@@ -1949,4 +1949,26 @@ Desktop セッションがどこで実行されるかに応じて、どの管理
 管理ソースのみが設定できる権限、プラグイン、および配信キーについては、[管理設定のみが設定できるキー](https://code.claude.com/docs/ja/managed-settings.md#managed-only-settings)を参照してください。
 
+#### Code タブで動作が異なる Claude Code 設定
+
```

</details>

<details>
<summary>setup-ja.md</summary>

```diff
diff --git a/docs-ja/pages/setup-ja.md b/docs-ja/pages/setup-ja.md
index 0869e11..c6f6a8b 100644
--- a/docs-ja/pages/setup-ja.md
+++ b/docs-ja/pages/setup-ja.md
@@ -27,4 +27,5 @@ Claude Code は以下のプラットフォームと構成で実行されます
 
 * **ripgrep**: 通常は Claude Code に含まれています。検索が失敗する場合は、[検索トラブルシューティング](https://code.claude.com/docs/ja/troubleshooting.md#search-and-discovery-issues)を参照してください。
+* **Git**: 任意です。git がインストールされている場合、[`claude plugin eval`](https://code.claude.com/docs/ja/plugin-evals#requirements) には 2.31 以降が必要です。macOS、Linux、または WSL からの[ローカルリポジトリのクラウドセッションへのアップロード](https://code.claude.com/docs/ja/claude-code-on-the-web.md#send-local-repositories-without-github)には git 2.31 以降が必要です。`git --version` を実行してバージョンを確認してください。
 
 ## Claude Code をインストール
@@ -40,5 +41,5 @@ Claude Code をインストールするには、ターミナルを開いてシ
 > **macOS、Linux、WSL：**
 >
-> ```bash theme={null}
+> ```bash theme={null} theme={null} theme={null} theme={null} theme={null} theme={null} theme={null} theme={null} theme={null} theme={null} theme={null} theme={null}
 > curl -fsSL https://claude.ai/install.sh | bash
 > ```
@@ -48,5 +49,5 @@ Claude Code をインストールするには、ターミナルを開いてシ
 > **Windows PowerShell：**
 >
-> ```powershell theme={null}
+> ```powershell theme={null} theme={null} theme={null} theme={null} theme={null} theme={null} theme={null} theme={null} theme={null} theme={null} theme={null} theme={null}
 > irm https://claude.ai/install.ps1 | iex
 > ```
@@ -54,5 +55,5 @@ Claude Code をインストールするには、ターミナルを開いてシ
 > **Windows CMD：**
 >
-> ```batch theme={null}
+> ```batch theme={null} theme={null} theme={null} theme={null} theme={null} theme={null} theme={null} theme={null} theme={null} theme={null} theme={null} theme={null}
 > curl -fsSL https://claude.ai/install.cmd -o install.cmd && install.cmd && del install.cmd
```

</details>

</details>


<details>
<summary>2026-10-31</summary>

**変更ファイル:**

```
 docs-ja/pages/agents-ja.md                         |   2 +-
 docs-ja/pages/artifacts-ja.md                      |   8 +-
 docs-ja/pages/authentication-ja.md                 |  42 +-
 docs-ja/pages/auto-mode-classifier-billing-ja.md   |   2 +-
 docs-ja/pages/auto-mode-config-ja.md               |   2 +-
 docs-ja/pages/best-practices-ja.md                 |   2 +-
 docs-ja/pages/changelog.md                         |  58 ++
 docs-ja/pages/channels-ja.md                       | 378 +++++-----
 docs-ja/pages/chrome-ja.md                         |   2 +-
 docs-ja/pages/claude-apps-gateway-on-aws-ja.md     | 278 +++----
 docs-ja/pages/claude-apps-gateway-on-gcp-ja.md     | 154 ++--
 docs-ja/pages/claude-code-on-the-web-ja.md         |   6 +-
 docs-ja/pages/claude-projects-ja.md                |  10 +-
 docs-ja/pages/cloud-environments-ja.md             |  40 +-
 docs-ja/pages/code-review-ja.md                    |  10 +-
 docs-ja/pages/commands-ja.md                       |  10 +-
 docs-ja/pages/common-workflows-ja.md               |   8 +-
 docs-ja/pages/communications-kit-ja.md             | 214 +++---
 docs-ja/pages/computer-use-ja.md                   |   4 +-
 docs-ja/pages/costs-ja.md                          | 100 +--
 docs-ja/pages/data-usage-ja.md                     |  58 +-
 docs-ja/pages/debug-your-config-ja.md              |  52 +-
 docs-ja/pages/deep-links-ja.md                     |  70 +-
 docs-ja/pages/desktop-ios-simulator-ja.md          |   2 +-
 docs-ja/pages/desktop-ja.md                        | 216 +++---
 docs-ja/pages/desktop-quickstart-ja.md             |  10 +-
 docs-ja/pages/devcontainer-ja.md                   |   2 +-
 docs-ja/pages/env-vars-ja.md                       |  82 +-
 docs-ja/pages/errors-ja.md                         |  10 +-
 docs-ja/pages/fast-mode-ja.md                      |  10 +-
 docs-ja/pages/feature-availability-ja.md           | 162 ++--
 docs-ja/pages/features-overview-ja.md              | 386 +++++-----
 docs-ja/pages/github-actions-cloud-providers-ja.md | 392 +++++-----
 docs-ja/pages/github-actions-ja.md                 |   2 +-
 docs-ja/pages/gitlab-ci-cd-ja.md                   | 104 +--
 docs-ja/pages/glossary-ja.md                       |   9 +-
 docs-ja/pages/hooks-guide-ja.md                    | 288 ++++----
 docs-ja/pages/hooks-ja.md                          | 822 ++++++++++-----------
 docs-ja/pages/how-claude-code-works-ja.md          |   6 +-
 docs-ja/pages/interactive-mode-ja.md               |  66 +-
 docs-ja/pages/jetbrains-ja.md                      |   2 +-
 docs-ja/pages/legal-and-compliance-ja.md           |   8 +-
 docs-ja/pages/llm-gateway-connect-ja.md            | 290 ++++----
 docs-ja/pages/llm-gateway-rollout-ja.md            | 136 ++--
 docs-ja/pages/managed-mcp-ja.md                    |  10 +-
 docs-ja/pages/mcp-ja.md                            |  70 +-
 docs-ja/pages/mcp-quickstart-ja.md                 |  14 +-
 docs-ja/pages/mobile-ja.md                         |   4 +-
 docs-ja/pages/model-config-ja.md                   |   8 +-
 docs-ja/pages/overview-ja.md                       | 238 +++---
 docs-ja/pages/permission-modes-ja.md               | 275 +++----
 docs-ja/pages/platforms-ja.md                      |  12 +-
 docs-ja/pages/quickstart-ja.md                     | 112 +--
 docs-ja/pages/remote-control-ja.md                 | 194 ++---
 docs-ja/pages/routines-ja.md                       |  22 +-
 docs-ja/pages/sandboxing-ja.md                     |  24 +-
 docs-ja/pages/security-ja.md                       |   2 +-
 .../self-hosted-environments-configuration-ja.md   |  42 +-
 .../pages/self-hosted-environments-identity-ja.md  | 156 ++--
 docs-ja/pages/self-hosted-environments-ja.md       |   6 +-
 docs-ja/pages/sessions-ja.md                       |   2 +-
 docs-ja/pages/settings-example-ja.md               | 640 ++++++++--------
 docs-ja/pages/settings-reference-ja.md             |   2 +-
 docs-ja/pages/setup-ja.md                          | 502 ++++++-------
 docs-ja/pages/skills-ja.md                         |   2 +-
 docs-ja/pages/slack-ja.md                          |  22 +-
 docs-ja/pages/statusline-ja.md                     |   8 +-
 docs-ja/pages/sub-agents-ja.md                     | 154 ++--
 docs-ja/pages/terminal-config-ja.md                |  32 +-
 docs-ja/pages/tools-reference-ja.md                |   4 +-
 docs-ja/pages/troubleshoot-install-ja.md           | 546 +++++++-------
 docs-ja/pages/troubleshooting-ja.md                |  54 +-
 docs-ja/pages/ultrareview-ja.md                    |   3 +-
 docs-ja/pages/voice-dictation-ja.md                |   2 +-
 docs-ja/pages/vs-code-ja.md                        |  64 +-
 docs-ja/pages/web-quickstart-ja.md                 |   4 +-
 76 files changed, 3928 insertions(+), 3817 deletions(-)
```

<details>
<summary>agents-ja.md</summary>

```diff
diff --git a/docs-ja/pages/agents-ja.md b/docs-ja/pages/agents-ja.md
index afa7188..4b3e54c 100644
--- a/docs-ja/pages/agents-ja.md
+++ b/docs-ja/pages/agents-ja.md
@@ -14,5 +14,5 @@ Claude Code には、複数のタスクを同時に処理する 5 つの方法
 | [エージェントビュー](https://code.claude.com/docs/ja/agent-view.md) | `claude agents` で開く、バックグラウンドで実行されているセッションをディスパッチして監視する 1 つの画面。リサーチプレビュー | 複数の独立したタスクがあり、それらを引き継いで、一目で状態を確認し、必要な場合のみ介入したい場合 |
 | [エージェントチーム](https://code.claude.com/docs/ja/agent-teams.md) | 共有タスクリストとエージェント間メッセージングを備えた複数の調整されたセッション。リーダーによって管理される。実験的で、デフォルトでは無効 | Claude にプロジェクトを分割させ、割り当てさせ、ワーカーを同期させたい場合 |
-| [プロジェクト](https://code.claude.com/docs/ja/claude-projects.md) | claude.ai/code またはデスクトップアプリでの 1 つの継続的な会話。Claude は threads と呼ばれる並列セッションを開始し、クラウドで、またはリモートコントロール経由でコンピューターで実行し、各セッションにプロジェクトの指示を提供し、どのセッションがあなたを必要としているかを表示します。Pro および Max でのパブリックベータ | 作業が数日または数週間にわたる多くのタスクに及び、マシンがオフの場合でも実行を続け、各セッションをディスパッチして追跡するのではなく、一度説明したい場合 |
+| [プロジェクト](https://code.claude.com/docs/ja/claude-projects.md) | claude.ai/code またはデスクトップアプリでの 1 つの継続的な会話。Claude は threads と呼ばれる並列セッションを、クラウドで、または指示した場合は Remote Control を介してコンピューター上で開始します。各セッションにプロジェクトの指示を渡し、どのセッションでユーザーの対応が必要かを表示します。Pro、Max、Ultra でのパブリックベータ | 作業が数日または数週間にわたる多くのタスクに及び、マシンがオフの場合でも実行を続け、各セッションをディスパッチして追跡するのではなく、一度説明したい場合 |
 | [動的ワークフロー](https://code.claude.com/docs/ja/workflows.md) | 多くのサブエージェントを実行し、その結果をチェックするスクリプト。1 回のターンで調整するには大きすぎるジョブ向け | タスクが大きすぎてサブエージェント数個では対応できない場合、または検出結果を相互に検証したい場合。コードベース全体の監査、500 ファイルのマイグレーション、相互検証が必要な調査、または複数の角度から作成されたプランなど |
 
```

</details>

<details>
<summary>artifacts-ja.md</summary>

```diff
diff --git a/docs-ja/pages/artifacts-ja.md b/docs-ja/pages/artifacts-ja.md
index 7ff59be..7bd02a8 100644
--- a/docs-ja/pages/artifacts-ja.md
+++ b/docs-ja/pages/artifacts-ja.md
@@ -9,5 +9,5 @@
 > [!NOTE]
 >
-> Artifacts は Pro、Max、Team、Enterprise プランで利用可能で、[`/login`](https://code.claude.com/docs/ja/setup#authenticate) でサインインしたセッションが必要です。要件の完全なセットについては、[利用可能性](#availability)を参照してください。
+> Artifacts は Pro、Max、Ultra、Team、Enterprise プランで利用可能で、[`/login`](https://code.claude.com/docs/ja/setup#authenticate) でサインインしたセッションが必要です。要件の完全なセットについては、[利用可能性](#availability)を参照してください。
 
 [アーティファクト](https://claude.com/features/artifacts)は、Claude Code がセッションから claude.ai 上のプライベート URL に公開するライブでインタラクティブな Web ページです。ブラウザで開くと、セッションが続く間、その場で更新されます。他の人にも見てもらいたい場合は、ページヘッダーから共有します。
@@ -198,5 +198,5 @@ Claude Code が自動で開始した監視は、アーティファクトで数
 ## MCP コネクタでライブデータを取得する
 
-アーティファクトは、誰かが閲覧するたびに [MCP コネクタ](https://code.claude.com/docs/ja/mcp.md#use-mcp-servers-from-claude-ai)を呼び出せます。そのため、ページにはそれを作成したセッション時点のスナップショットではなく、最新のデータが表示されます。アーティファクトからのコネクタ呼び出しは Pro、Max、Team、Enterprise プランで利用でき、Claude Code v2.1.209 以降が必要です。それより前のバージョンでは、Claude はページの作成中にセッションが収集したデータをそのまま使ってページを公開します。
+アーティファクトは、誰かが閲覧するたびに [MCP コネクタ](https://code.claude.com/docs/ja/mcp.md#use-mcp-servers-from-claude-ai)を呼び出せます。そのため、ページにはそれを作成したセッション時点のスナップショットではなく、最新のデータが表示されます。アーティファクトからのコネクタ呼び出しは Pro、Max、Ultra、Team、Enterprise プランで利用でき、Claude Code v2.1.209 以降が必要です。それより前のバージョンでは、Claude はページの作成中にセッションが収集したデータをそのまま使ってページを公開します。
 
 コネクタを利用するページを作成するには、プロンプトでコネクタと必要なデータを指定します。
@@ -315,5 +315,5 @@ Claude はデザインシステムを独自の選択肢より高い優先度と
 > [!NOTE]
 >
-> テンプレートはベータ版です。Pro、Max、Team プランではデフォルトで有効になっています。Enterprise プランでは、Owner が **Organization settings > Artifacts** の下で [各テンプレートを有効にします](https://support.claude.com/en/articles/16994751-artifacts-admin-guide-for-team-and-enterprise-plans)。組織で Slides テンプレートが無効になっている場合、`/slides` は表示されません。Design テンプレートが無効になっている場合、`/design` はデザインを作成しません。両方のコマンドには Claude Code v2.1.265 以降と [アーティファクトが利用可能](#availability) なセッションが必要です。
+> テンプレートはベータ版です。Pro、Max、Ultra、Team プランではデフォルトで有効になっています。Enterprise プランでは、Owner が **Organization settings > Artifacts** の下で [各テンプレートを有効にします](https://support.claude.com/en/articles/16994751-artifacts-admin-guide-for-team-and-enterprise-plans)。組織で Slides テンプレートが無効になっている場合、`/slides` は表示されません。Design テンプレートが無効になっている場合、`/design` はデザインを作成しません。両方のコマンドには Claude Code v2.1.265 以降と [アーティファクトが利用可能](#availability) なセッションが必要です。
 
 ### スライドデッキを作成する
@@ -369,5 +369,5 @@ Artifacts には以下のすべての条件が必要です。いずれかが満
 | 要件 | 利用可能な場合 |
 | :- | :- |
-| プラン | Pro、Max、Team、または Enterprise。Pro および Max プランでは、Artifacts は共有するまであなたのみがアクセスでき、管理者管理は適用されません。Team および Enterprise プランでは、Artifacts はデフォルトで有効です。Owner が claude.ai 管理設定で[それらを組織に対して無効にする](#manage-artifacts-for-your-organization)ことができます。 |
+| プラン | Pro、Max、Ultra、Team、または Enterprise。Pro、Max、および Ultra プランでは、アーティファクトは共有するまで本人のみがアクセスでき、管理者管理は適用されません。Team および Enterprise プランでは、アーティファクトはデフォルトで有効です。Owner が claude.ai 管理設定で[それらを組織に対して無効にする](#manage-artifacts-for-your-organization)ことができます。 |
```

</details>

<details>
<summary>authentication-ja.md</summary>

```diff
diff --git a/docs-ja/pages/authentication-ja.md b/docs-ja/pages/authentication-ja.md
index 1dcbca9..4c5c280 100644
--- a/docs-ja/pages/authentication-ja.md
+++ b/docs-ja/pages/authentication-ja.md
@@ -24,5 +24,5 @@ Claude Code は、セットアップに応じて複数の認証方法をサポ
 以下のいずれかのアカウントタイプで認証できます。
 
-* **Claude Pro または Max サブスクリプション**: claude.ai アカウントでログインします。[claude.com/pricing](https://claude.com/pricing?utm_source=claude_code\&utm_medium=docs\&utm_content=authentication_pro_max) で購読してください。
+* **Claude Pro、Max、または Ultra サブスクリプション**: claude.ai アカウントでログインします。[claude.com/pricing](https://claude.com/pricing?utm_source=claude_code\&utm_medium=docs\&utm_content=authentication_pro_max) で購読してください。
 * **Claude for Teams または Enterprise**: チーム管理者が招待した claude.ai アカウントでログインします。
 * **Claude Console**: Console 認証情報でログインします。管理者が事前に[招待](#claude-console-authentication)している必要があります。[API キーを作成せずにサインイン](#sign-in-without-an-api-key)することも、API キーを作成することもできます。
@@ -254,5 +254,5 @@ Claude Code は認証情報を安全に管理します。
 5. `CLAUDE_CODE_OAUTH_TOKEN` 環境変数。[`claude setup-token`](#generate-a-long-lived-token) によって生成された長期 OAuth トークン。ブラウザログインが利用できない CI パイプラインとスクリプトに使用します。この変数が設定されている間に `/login` を実行すると、Claude Code は現在のセッションを新しいログインに切り替えますが、シェルプロファイルまたは[設定ファイル](https://code.claude.com/docs/ja/settings.md)の `env` ブロックから変数を削除するまで、新しいセッションのたびに変数を再度読み込みます。
 6. Anthropic プロファイルおよびフェデレーション認証情報。`ant` CLI および Workload Identity Federation が使用する認証情報。`ant auth login` が書き込んだプロファイルは、`ANTHROPIC_PROFILE` で名前を付けた場合にのみここにランク付けされます。そうでない場合は `/login` より下にランク付けされます。[Anthropic プロファイルおよびフェデレーション認証情報](#anthropic-profiles-and-federation-credentials)を参照してください。
-7. `/login` からのサブスクリプション OAuth 認証情報。これは Claude Pro、Max、Team、および Enterprise ユーザーのデフォルトです。
+7. `/login` からのサブスクリプション OAuth 認証情報。これは Claude Pro、Max、Ultra、Team、および Enterprise ユーザーのデフォルトです。
 
 署名済みの [Claude apps gateway](https://code.claude.com/docs/ja/claude-apps-gateway) セッションはこのリストの外に位置します。これは Amazon Bedrock または Google Cloud の Agent Platform のようなプロバイダー選択であり、それらより優先されます。ゲートウェイセッションが存在する場合、CLI は `CLAUDE_CODE_USE_BEDROCK`、`CLAUDE_CODE_USE_VERTEX`、または `CLAUDE_CODE_USE_FOUNDRY` が設定されていても、ゲートウェイトークンで認証され、ベアラートークン、API キー、`apiKeyHelper`、およびプロファイルなどの上記の認証情報ソースは使用されません。
@@ -301,23 +301,23 @@ claude setup-token
 このコマンドは `/login` と同じブラウザ認可フローを開き、ブラウザでアクセスを承認した後、トークンはターミナルに出力されます。トークンはどこにも保存されません。トークンをコピーして、認証したい場所で `CLAUDE_CODE_OAUTH_TOKEN` 環境変数として設定します。
 
-**macOS, Linux, WSL**
-
-```bash theme={null}
-export CLAUDE_CODE_OAUTH_TOKEN=your-token
-```
-
-**Windows PowerShell**
-
-```powershell theme={null}
```

</details>

<details>
<summary>auto-mode-classifier-billing-ja.md</summary>

```diff
diff --git a/docs-ja/pages/auto-mode-classifier-billing-ja.md b/docs-ja/pages/auto-mode-classifier-billing-ja.md
index bfaf66e..9ce1285 100644
--- a/docs-ja/pages/auto-mode-classifier-billing-ja.md
+++ b/docs-ja/pages/auto-mode-classifier-billing-ja.md
@@ -44,5 +44,5 @@ export CLAUDE_CODE_AUTO_MODE_SERVER=0
 ## ダイアログが表示される理由
 
-[サーバー側分類器レビュー](https://code.claude.com/docs/ja/permission-modes.md#server-side-classifier-review)は、サーバーに分類器チェックをリクエストするセッションを一覧表示します。Pro、Max、Team プランではダイアログが表示されることはありません。ダイアログが表示される場合、通常の原因は以下の通りです：
+Pro、Max、Ultra、Team プランではダイアログが表示されることはありません。どのセッションがサーバーに分類器チェックをリクエストするかについては、[サーバー側分類器レビュー](https://code.claude.com/docs/ja/permission-modes.md#server-side-classifier-review)を参照してください。ダイアログが表示される場合は、以下の通常の原因を確認してください：
 
 * **LLM ゲートウェイまたはプロキシがパスに存在する**：リクエストヘッダーを削除または書き換える、認識しないリクエストフィールドを削除する、またはレスポンスを編集するもの。その場合、サーバーはチェックのリクエストを受け取らないか、Claude Code はレスポンスを受け取りません。設定またはレスポンスがゲートウェイを特定する場合、ダイアログはそれに名前を付けます。
```

</details>

<details>
<summary>auto-mode-config-ja.md</summary>

```diff
diff --git a/docs-ja/pages/auto-mode-config-ja.md b/docs-ja/pages/auto-mode-config-ja.md
index ca5060f..8dd2f4c 100644
--- a/docs-ja/pages/auto-mode-config-ja.md
+++ b/docs-ja/pages/auto-mode-config-ja.md
@@ -162,5 +162,5 @@ Claude のプッシュおよびプルリクエストコマンドの前に人間
 > [!NOTE]
 >
-> `/auto-mode-setup` は Pro、Max、Team、Enterprise プラン、および Claude Console の API キーで利用できます。Pro、Max、Team プランでは v2.1.228 以降（ネイティブ Windows では v2.1.233 以降）が必要です。Enterprise プランまたは Claude Console の API キーでは v2.1.283 以降が必要です。セッションでこのコマンドが見つからない場合は、[`/auto-mode-setup` が「Unknown command」を返す](#auto-mode-setup-returns-unknown-command)を参照してください。
+> `/auto-mode-setup` は Pro、Max、Ultra、Team、Enterprise プラン、および Claude Console の API キーで利用できます。Pro、Max、Ultra、Team プランでは v2.1.228 以降（ネイティブ Windows では v2.1.233 以降）が必要です。Enterprise プランまたは Claude Console の API キーでは v2.1.283 以降が必要です。セッションでこのコマンドが見つからない場合は、[`/auto-mode-setup` が「Unknown command」を返す](#auto-mode-setup-returns-unknown-command)を参照してください。
 
 ### `/auto-mode-setup` が読み取る内容
```

</details>

<details>
<summary>best-practices-ja.md</summary>

```diff
diff --git a/docs-ja/pages/best-practices-ja.md b/docs-ja/pages/best-practices-ja.md
index b3251e5..83ce129 100644
--- a/docs-ja/pages/best-practices-ja.md
+++ b/docs-ja/pages/best-practices-ja.md
@@ -490,5 +490,5 @@ Claude に `have the reviewer compare the rate limiter against SPEC.md` と依
 現在のほとんどのモデルは 1M トークンのウィンドウを持ち、その上限近くでコンテキスト圧縮が行われるため、コンテキストが足りなくなることはまれです。それでも、不要なコンテキストに*支払う*ことはあり得ます。すべてのリクエストは会話全体を送信するため、無関係な 3 つのタスクを抱えたセッションでは、4 つ目のタスクのターンごとに 3 つすべてを再読み込みします。これは[キャッシュが有効な間は割引され](https://code.claude.com/docs/ja/costs.md#why-usage-climbs-in-a-long-session)、期限が切れると正規料金になります。
 
-まず確認すべきは [`/usage`](https://code.claude.com/docs/ja/costs) です。Pro、Max、Team、Enterprise では、使用量をスキル、サブエージェント、プラグイン、MCP サーバーごとに分類して表示します。また、長いコンテキストや頻繁なキャッシュミスなどのパターンが使用量の 10% を超えると、それを指摘します。そこからの一般的な対処法は次のとおりです：
+まず確認すべきは [`/usage`](https://code.claude.com/docs/ja/costs) です。Pro、Max、Ultra、Team、Enterprise では、使用量をスキル、サブエージェント、プラグイン、MCP サーバーごとに分類して表示します。また、長いコンテキストや頻繁なキャッシュミスなどのパターンが使用量の 10% を超えると、それを指摘します。そこからの一般的な対処法は次のとおりです：
 
 * 無関係なタスクの間には `/clear`。コストはかからず、次のタスクが前のタスクの履歴の分まで支払い続けることがなくなります。`/clear oauth-migration` は離れるセッションに名前を付けるので、後で戻ってこられます。
```

</details>

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index d4e57ac..f160c85 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,62 @@
 # Changelog
 
+## 2.1.316
+
+- Added `CLAUDE_CODE_DISABLE_ULTRATHINK`, which turns the `ultrathink` keyword off
+- Added pooled group budgets to the Claude apps gateway: one monthly budget that a group's members share, on top of each member's own limit, set with `pooled_budget` on the spend limits admin API
+- Added `CLAUDE_CODE_DISABLE_LOOPED_CROSS_CERT_DROP` to keep system cross-certificates that certify each other in a loop, for servers whose private CA needs one
+- Added `CLAUDE_CODE_SUBAGENT_EFFORT` to set the effort level subagents run at when nothing else names one, instead of inheriting the session's
+- Added `managed.policy_mode: layered` to the Claude apps gateway: every policy that matches a developer applies, each merged over the ones listed below it, not only the first
+- Added `guardrail.input_tagging` on Claude apps gateway Bedrock upstreams, which wraps prompts in the input tags that an Amazon Bedrock guardrail's prompt attacks filter needs; `all_messages_and_system` also tags the system prompt
+- Deprecated fast mode for Opus 4.8 as of October 30, 2026; it will be removed on November 30, 2026. After removal, fast mode requests on Opus 4.8 return an error and do not fall back to standard Opus 4.8. Migrate to Opus 5.5 to keep the speedup
+- Fixed shell commands being left running on macOS and Linux when Claude Code exits by itself, for example when credentials are refused or a cloud session is archived
+- Fixed bash aliases with line breaks in their value (except in Git Bash), and functions whose names start with a dash, being garbled or lost in the Bash tool's shell
+- Fixed bash scripts started from the Bash tool stopping after their first command when `SHELLOPTS` is exported
+- Fixed PowerShell hooks not blocking on exit code 2 when the command begins with a type cast, `param`, `using` or an attribute
+- Fixed some network requests hanging when a compressed response was cut off or corrupted
+- Fixed `sonnet`, `opus` and `haiku` on Vertex AI and Amazon Bedrock showing an error mid-session instead of switching to an older model when the newest is not yet available to the account or region
+- Fixed the Claude apps gateway not checking every model a request names against `availableModels`, `deniedModels` and `models`; a request that names a blocked model now gets a 400 naming the field
+- Fixed `claude auth login` refusing to run where managed settings require a Claude apps gateway; in a terminal it now shows the gateway sign-in
+- Fixed `--restricted` sessions uploading files from outside the working directories when a Read allow rule covered them
+- Fixed prompts containing invisible characters needing a second Enter to send; plain prompts now send cleaned on the first Enter, and commands still wait for review
+- Fixed sub-agents that inherited a parent sub-agent's model moving to the main model when a background job or message woke them
+- Fixed a managed `autoMode.allow` list without `"$defaults"` getting the built-in exceptions back from a host app's `--settings`, a first rule added in `/permissions`, or `/auto-mode-setup`
+- Fixed cloud sessions and cloud scheduled tasks not being marked as failed when auto mode stopped a turn because the server returned no safety verdict
+- Fixed `claude -p` text output sometimes not saying why auto mode stopped a turn when a background agent was still running
```

</details>

<details>
<summary>channels-ja.md</summary>

```diff
diff --git a/docs-ja/pages/channels-ja.md b/docs-ja/pages/channels-ja.md
index 3b501f8..deeae07 100644
--- a/docs-ja/pages/channels-ja.md
+++ b/docs-ja/pages/channels-ja.md
@@ -25,197 +25,197 @@ Team、Enterprise、または Console 組織を管理している場合は、[
 サポートされている各チャネルはプラグインで、[Bun](https://bun.sh) が必要です。実際のプラットフォームを接続する前にプラグインフローの実践的なデモを試すには、[fakechat クイックスタート](#quickstart)を試してください。
 
-**Telegram**
-
-完全な[Telegram プラグインソース](https://github.com/anthropics/claude-plugins-official/tree/main/external_plugins/telegram)を表示します。
-
-**1. Telegram ボットを作成する**
-
-Telegram で [BotFather](https://t.me/BotFather) を開き、`/newbot` を送信します。表示名と `bot` で終わる一意のユーザー名を指定します。BotFather が返すトークンをコピーします。
-
-**2. プラグインをインストールする**
-
-ターミナルで `claude` を実行して Claude Code を起動し、そのプロンプトで以下を入力します。
-
-```
-/plugin install telegram@claude-plugins-official
-```
-
-インストールが失敗した場合は、Claude Code が報告するメッセージと照合してください。
-
-* `Marketplace "claude-plugins-official" not found`：`/plugin marketplace add anthropics/claude-plugins-official` でマーケットプレイスを追加してから、インストールを再試行してください。
-* `Plugin "<name>" not found in marketplace "claude-plugins-official"`：ローカルにあるマーケットプレイスカタログのコピーが古くなっている可能性があります。`/plugin marketplace update claude-plugins-official` で更新してから、インストールを再試行してください。再試行しても同じメッセージが表示される場合は、[Plugin not found in marketplace](https://code.claude.com/docs/ja/plugins/troubleshooting.md#plugin-not-found-in-marketplace) を参照してください。
-
-インストールがインストールスコープを求めるとき、ユーザースコープオプションを選択して、プラグインがすべてのプロジェクト全体で利用可能になるようにしてください。インストール概要を確認してください。`Run /reload-plugins to apply.` と報告されている場合は、[プラグイン変更を再起動なしで適用する](https://code.claude.com/docs/ja/plugins/cli-reference.md#reload-plugins)を参照して、プラグインの設定コマンドを利用可能にしてください。
-
```

</details>

*...以降省略*

</details>


<details>
<summary>2026-10-30</summary>

**変更ファイル:**

```
 docs-ja/pages/artifacts-ja.md                      |   2 +-
 docs-ja/pages/authentication-ja.md                 |   2 +-
 docs-ja/pages/changelog.md                         | 122 +++++++++++++++++++++
 docs-ja/pages/channels-ja.md                       |   6 +-
 docs-ja/pages/chrome-ja.md                         |  19 +++-
 docs-ja/pages/claude-apps-gateway-ja.md            |   8 +-
 docs-ja/pages/claude-code-on-the-web-ja.md         |  13 ++-
 docs-ja/pages/claude-directory-ja.md               |   4 +-
 docs-ja/pages/claude-projects-ja.md                |   2 +-
 docs-ja/pages/cloud-environments-ja.md             |   2 +-
 docs-ja/pages/code-review-costs-ja.md              |   1 +
 docs-ja/pages/commands-ja.md                       |   3 +-
 docs-ja/pages/costs-ja.md                          |   7 +-
 docs-ja/pages/deep-links-ja.md                     |  11 +-
 docs-ja/pages/desktop-ja.md                        |  18 +++
 docs-ja/pages/env-vars-ja.md                       |   3 +-
 docs-ja/pages/errors-ja.md                         |  16 ++-
 docs-ja/pages/goal-ja.md                           |   2 +-
 docs-ja/pages/hipaa-setup-ja.md                    |   6 +-
 docs-ja/pages/hooks-ja.md                          |  14 ++-
 docs-ja/pages/interactive-mode-ja.md               |   4 +-
 docs-ja/pages/model-config-ja.md                   |  20 ++--
 docs-ja/pages/monitoring-usage-ja.md               |   9 +-
 docs-ja/pages/prompt-caching-ja.md                 |   2 +-
 docs-ja/pages/sandboxing-ja.md                     |   2 +
 .../self-hosted-environments-configuration-ja.md   |   7 +-
 .../pages/self-hosted-environments-deploy-ja.md    |  56 ++++++++--
 .../pages/self-hosted-environments-identity-ja.md  |  10 +-
 docs-ja/pages/self-hosted-environments-ja.md       |   7 +-
 .../pages/self-hosted-environments-reference-ja.md |   2 +-
 docs-ja/pages/settings-reference-ja.md             |   4 +-
 docs-ja/pages/setup-ja.md                          |  14 ++-
 docs-ja/pages/skills-ja.md                         |   2 +-
 docs-ja/pages/slack-ja.md                          |   2 +-
 docs-ja/pages/statusline-ja.md                     |   2 +-
 docs-ja/pages/terminal-config-ja.md                |   8 +-
 docs-ja/pages/troubleshoot-install-ja.md           |  38 ++++++-
 docs-ja/pages/ultrareview-ja.md                    |   4 +-
 38 files changed, 359 insertions(+), 95 deletions(-)
```

<details>
<summary>artifacts-ja.md</summary>

```diff
diff --git a/docs-ja/pages/artifacts-ja.md b/docs-ja/pages/artifacts-ja.md
index 3f2c5bd..7ff59be 100644
--- a/docs-ja/pages/artifacts-ja.md
+++ b/docs-ja/pages/artifacts-ja.md
@@ -370,5 +370,5 @@ Artifacts には以下のすべての条件が必要です。いずれかが満
 | :- | :- |
 | プラン | Pro、Max、Team、または Enterprise。Pro および Max プランでは、Artifacts は共有するまであなたのみがアクセスでき、管理者管理は適用されません。Team および Enterprise プランでは、Artifacts はデフォルトで有効です。Owner が claude.ai 管理設定で[それらを組織に対して無効にする](#manage-artifacts-for-your-organization)ことができます。 |
-| 認証 | セッションが claude.ai アカウントでサポートされています。CLI またはデスクトップアプリで `/login` でサインインします。Claude Tag セッションはエージェントの ID を通じてサインインするため、追加の手順は不要です。API キー、[ゲートウェイトークン](https://code.claude.com/docs/ja/llm-gateway)、またはクラウドプロバイダー認証情報を使用するセッションは公開できません。 |
+| 認証 | セッションが claude.ai アカウントでサポートされています。CLI またはデスクトップアプリで `/login` でサインインします。Claude Tag セッションではサインイン手順は不要です。API キー、[ゲートウェイトークン](https://code.claude.com/docs/ja/llm-gateway)、またはクラウドプロバイダー認証情報を使用するセッションは公開できません。 |
 | モデルプロバイダー | Anthropic API。[Amazon Bedrock](https://code.claude.com/docs/ja/amazon-bedrock.md)、[Google Cloud の Agent Platform](https://code.claude.com/docs/ja/google-vertex-ai.md)、または[Microsoft Foundry](https://code.claude.com/docs/ja/microsoft-foundry.md)では利用できません。 |
 | 組織ポリシー | カスタマー管理暗号化キー（CMEK）、HIPAA、および[Zero Data Retention](https://code.claude.com/docs/ja/zero-data-retention.md)は組織に対して有効になっていません。 |
```

</details>

<details>
<summary>authentication-ja.md</summary>

```diff
diff --git a/docs-ja/pages/authentication-ja.md b/docs-ja/pages/authentication-ja.md
index 75444fe..1dcbca9 100644
--- a/docs-ja/pages/authentication-ja.md
+++ b/docs-ja/pages/authentication-ja.md
@@ -28,5 +28,5 @@ Claude Code は、セットアップに応じて複数の認証方法をサポ
 * **Claude Console**: Console 認証情報でログインします。管理者が事前に[招待](#claude-console-authentication)している必要があります。[API キーを作成せずにサインイン](#sign-in-without-an-api-key)することも、API キーを作成することもできます。
 * **クラウドプロバイダー**: 組織が [Amazon Bedrock](https://code.claude.com/docs/ja/amazon-bedrock.md)、[Google Cloud の Agent Platform](https://code.claude.com/docs/ja/google-vertex-ai.md)、または [Microsoft Foundry](https://code.claude.com/docs/ja/microsoft-foundry.md) を使用している場合は、`claude` を実行する前に必要な環境変数を設定するか、ログインプロンプトで **3rd-party platform** を選択してください。これにより、Bedrock と Vertex AI 向けのインタラクティブセットアップウィザードが起動します。ブラウザログインは不要です。
-* **クラウドゲートウェイ**: 組織がセルフホストされた [Claude apps gateway](https://code.claude.com/docs/ja/claude-apps-gateway) を実行している場合は、`/login` を通じて企業 SSO でサインインします。ゲートウェイが発行したトークンはセッションの唯一の認証情報です。
+* **Cloud gateway**: 組織がセルフホストされた [Claude apps gateway](https://code.claude.com/docs/ja/claude-apps-gateway) を実行している場合は、`/login` を通じて企業 SSO でサインインします。ゲートウェイが発行したトークンはセッションの唯一の認証情報です。
 
 管理者は、どのログイン方法を開発者が使用するかを指定し、claude.ai ログインが特定の組織に属することを要求できます。[ログインを組織に制限する](#restrict-login-to-your-organization)を参照してください。
```

</details>

<!-- UPDATE_LOG_END -->
