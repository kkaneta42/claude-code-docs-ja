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

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index 6430cae..d4e57ac 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,126 @@
 # Changelog
 
+## 2.1.314
+
+- Added `permissions.blockWritesOutsideWorkingDirectories`: Write, Edit and NotebookEdit refuse paths outside the working directories in every permission mode
+- Added an optional `groups` list to Claude apps gateway upstreams: only developers in the listed IdP groups are sent to that upstream, on failover too
+- Added `guardrail_trace` to Claude apps gateway Bedrock upstreams, to log which Amazon Bedrock guardrail filter fired on a request, without the matched text
+- Added idle compaction to VS Code and Claude Desktop's Code tab: a 200K+ token conversation left idle is summarized, and the summary is used on your next message if the prompt cache has expired
+- Fixed sessions failing turn after turn with "Invalid effort level" when an organization's admin caps a model's effort: Claude Code now lowers the effort, retries, and says which level it uses
+- Fixed `claude -p` exiting with code 0 and no output when startup failed; it now prints the error and exits 1
+- Fixed Bedrock sessions with many images failing every turn and `/compact` with "400 Input is too long." instead of removing older images and compacting
+- Fixed Microsoft Foundry sessions failing when the resource has no deployment for the default Sonnet, Opus or Haiku model: Claude Code now falls back to an older model of that family
+- Fixed repeated refused requests behind a gateway that doesn't accept tool search's `tool_reference` blocks: the request is sent again once without tool search, and the session remembers
+- Fixed TLS connections failing with `UNABLE_TO_GET_ISSUER_CERT` when the system certificate store holds a renewed root certificate that is cross-signed with its predecessor
+- Fixed MCP servers that also work without sign-in showing "needs authentication" after their stored sign-in stopped working; they are now used signed out
+- Fixed `claude mcp logout` reporting success when the MCP sign-in was not removed, for example while the macOS keychain is locked over SSH
+- Fixed extra sign-in renewals when several sessions share an Anthropic profile login and the credentials lock is busy
+- Fixed `claude ultrareview` and `claude remote-control` asking the workspace trust question in a CI job that has a terminal; with `CI` set they now refuse an untrusted folder at once
+- Fixed an administrator's TLS trust settings in managed settings not being applied in Claude Desktop sessions
+- Fixed model switching being refused on machines with managed plugin settings when one of your own `--plugin-dir` or `--plugin-url` plugins had a broken manifest or failed to download
+- Fixed the Bedrock and Vertex model upgrade offer coming back at every start when managed settings pin the model
+- Fixed `forceRemoteSettingsRefresh` set only in remote managed settings no longer applying once the stored copy had expired, which let sessions start without policy when the server could not be reached
+- Fixed "Continue automatically at usage limit" continuing more than three times without a prompt from you when a task restarted itself between waits (a /goal check-in, a background or scheduled task)
+- Fixed background and cloud sessions started with Ultracode turning it back on at their next start after it had been switched off
+- Fixed the last broken reply and its retry prompts staying in the conversation after Claude gave up on a tool call that could not be parsed
```

</details>

<details>
<summary>channels-ja.md</summary>

```diff
diff --git a/docs-ja/pages/channels-ja.md b/docs-ja/pages/channels-ja.md
index eeda3e9..3b501f8 100644
--- a/docs-ja/pages/channels-ja.md
+++ b/docs-ja/pages/channels-ja.md
@@ -354,8 +354,8 @@ Claude Code のいくつかの機能はターミナルの外のシステムに
 | 機能 | 何をするか | 適している用途 |
 | - | - | - |
-| [ウェブ上の Claude Code](https://code.claude.com/docs/ja/claude-code-on-the-web.md) | GitHub からクローンされた新しいクラウドサンドボックスでタスクを実行 | 後で確認する自己完結型の非同期作業を委任する |
+| [クラウドセッション](https://code.claude.com/docs/ja/claude-code-on-the-web.md) | GitHub からクローンされた新しいクラウドサンドボックスでタスクを実行 | 後で確認する自己完結型の非同期作業を委任する |
 | [Slack の Claude](https://code.claude.com/docs/ja/slack.md) | チャネルまたはスレッドの `@Claude` メンションからクラウドセッションを生成 | チームの会話コンテキストから直接タスクを開始する |
 | 標準 [MCP サーバー](https://code.claude.com/docs/ja/mcp.md) | Claude はタスク中にそれをクエリします。セッションには何もプッシュされません | Claude にシステムを読み取るまたはクエリするオンデマンドアクセスを提供する |
-| [リモートコントロール](https://code.claude.com/docs/ja/remote-control.md) | claude.ai または Claude モバイルアプリからローカルセッションを駆動 | デスクから離れている間に進行中のセッションを操舵する |
+| [Remote Control](https://code.claude.com/docs/ja/remote-control.md) | claude.ai または Claude モバイルアプリからローカルセッションを駆動 | デスクから離れている間に進行中のセッションを操舵する |
 
 チャネルは、Claude 以外のソースからのイベントをすでに実行中のローカルセッションにプッシュすることで、そのリストのギャップを埋めます。
@@ -369,4 +369,4 @@ Claude Code のいくつかの機能はターミナルの外のシステムに
 
 * [独自のチャネルを構築](https://code.claude.com/docs/ja/channels-reference.md)して、まだプラグインがないシステムに対応する
-* [リモートコントロール](https://code.claude.com/docs/ja/remote-control.md)を使用して、イベントをそれに転送する代わりに電話からローカルセッションを駆動する
+* [Remote Control](https://code.claude.com/docs/ja/remote-control.md) を使用して、イベントをそれに転送する代わりに電話からローカルセッションを駆動する
 * [セッションスコープのスケジュールタスク](https://code.claude.com/docs/ja/scheduled-tasks.md)を使用して、プッシュされたイベントに対応する代わりにタイマーでポーリングする
```

</details>

<details>
<summary>chrome-ja.md</summary>

```diff
diff --git a/docs-ja/pages/chrome-ja.md b/docs-ja/pages/chrome-ja.md
index 46d4883..7696123 100644
--- a/docs-ja/pages/chrome-ja.md
+++ b/docs-ja/pages/chrome-ja.md
@@ -77,5 +77,5 @@ type "hooks", and tell me what results appear
 いつでも `/chrome` を実行して、接続ステータスの確認、権限の管理、拡張機能の再接続、または使用する接続済みブラウザの選択を行えます。ステータスパネルに「ステータス: 有効」と「拡張機能: インストール済み」が表示されていれば、統合は正常に動作しています。
 
-複数のブラウザが接続されている場合は、Claude が使用するブラウザを選択します。選択する前にブラウザアクションが開始されると、Claude はいずれかを選択するよう促します。後でブラウザを切り替えるには、`/chrome` を実行して **ブラウザを選択…** を選びます。別のブラウザが接続された場合でも、Claude は選択したブラウザを使い続けます。
+複数のブラウザが接続されている場合は、Claude が使用するブラウザを選択します。選択する前にブラウザアクションが開始されると、Claude はいずれかを選択するよう促します。後でブラウザを切り替えるには、`/chrome` を実行して **Select browser…** を選びます。別のブラウザが接続された場合でも、Claude は選択したブラウザを使い続けます。
 
 VS Code については、[VS Code でのブラウザ自動化](https://code.claude.com/docs/ja/vs-code.md#automate-browser-tasks-with-chrome) を参照してください。
@@ -83,11 +83,11 @@ VS Code については、[VS Code でのブラウザ自動化](https://code.cla
 ### Claude から求められたときに拡張機能をインストールする
 
-対話型セッションで Claude がブラウザを必要とし、Claude Code が拡張機能を検出できない場合、Claude Code は「Claude がブラウザの使用を求めています」というタイトルのインストールプロンプトを表示します。Claude Code が確認するのは 1 セッションにつき最大 1 回です。
+対話型セッションで Claude がブラウザを必要とし、Claude Code が拡張機能を検出できない場合、Claude Code は「Claude wants to use your browser」というタイトルのインストールプロンプトを表示します。Claude Code が確認するのは 1 セッションにつき最大 1 回です。
 
 プロンプトには 3 つの選択肢があります。
 
-* **拡張機能をインストール**: ブラウザで拡張機能のインストールページを開き、ガイド付きセットアップを開始します。Claude Code はインストールを待機し、拡張機能を接続して、同じセッション内でブラウザツールを有効にします。接続の準備ができたら「ブラウザツールを使用して続行」を選択すると、Claude はブラウザでタスクを再開します。「ブラウザツールなしで続行」を選択してセットアップを中断し、後で `/chrome` で完了することもできます。
-* **今はしない**: ブラウザツールなしでタスクを続行します。Claude Code は後のセッションで再度確認することがあります。
-* **今後確認しない**: 今後のセッションでプロンプトを表示しないようにします。`/chrome` を使えば、いつでも統合をセットアップできます。
+* **Install extension**: ブラウザで拡張機能のインストールページを開き、ガイド付きセットアップを開始します。Claude Code はインストールを待機し、拡張機能を接続して、同じセッション内でブラウザツールを有効にします。接続の準備ができたら「Continue with browser tools」を選択すると、Claude はブラウザでタスクを再開します。「Continue without browser tools」を選択してセットアップを中断し、後で `/chrome` で完了することもできます。
+* **Not now**: ブラウザツールなしでタスクを続行します。Claude Code は後のセッションで再度確認することがあります。
+* **Don't ask again**: 今後のセッションでプロンプトを表示しないようにします。`/chrome` を使えば、いつでも統合をセットアップできます。
 
 次の 2 つの管理 MCP ポリシーによってプロンプトはオフになります。
@@ -108,4 +108,13 @@ Chrome が実行されていない場合でも、Claude Code は通常どおり
 > Chrome をデフォルトで有効にすると、ブラウザツールとその指示が常にロードされるため、コンテキスト使用量が増加します。コンテキスト消費の増加に気付いた場合は、この設定をオフにして、必要なときにのみ接続してください。CLI では `--chrome` を使用し、VS Code ではプロンプトボックスに [`@browser`](https://code.claude.com/docs/ja/vs-code#automate-browser-tasks-with-chrome) と入力します。
 
```

</details>

<details>
<summary>claude-apps-gateway-ja.md</summary>

```diff
diff --git a/docs-ja/pages/claude-apps-gateway-ja.md b/docs-ja/pages/claude-apps-gateway-ja.md
index fda094b..1799c3f 100644
--- a/docs-ja/pages/claude-apps-gateway-ja.md
+++ b/docs-ja/pages/claude-apps-gateway-ja.md
@@ -36,5 +36,5 @@ Claude アプリゲートウェイは、開発者の Claude Code クライアン
 * **アップストリームルーティング**：クライアントは Anthropic Messages API をゲートウェイに話しかけ、ゲートウェイは各アップストリーム（Amazon Bedrock、[Claude Platform on AWS](https://code.claude.com/docs/ja/claude-platform-on-aws.md)、Google Cloud の Agent Platform、Microsoft Foundry、または Anthropic API）に対して変換し、それらの間でフェイルオーバーします。開発者が気付いたり再設定したりすることなく、リージョン、プロバイダー、またはフェイルオーバー順序を変更できます。
 
-![Claude Code クライアントと Claude Desktop の Chat、Cowork、Code タブがベアラートークンを使用して HTTPS 経由でインフラストラクチャ内の自己ホスト型 Claude apps ゲートウェイに接続し、IdP に対してユーザーにサインインし、PostgreSQL に認証状態を保存し、テレメトリを OTLP コレクターにリレーし、Amazon Bedrock、Claude Platform on AWS、Google Cloud、Microsoft Foundry、または Anthropic API に推論を転送する図](https://mintcdn.com/claude-code/VbyXug8hBU9UK6oT/images/claude-gateway-architecture.svg?fit=max\&auto=format\&n=VbyXug8hBU9UK6oT\&q=85\&s=9e4f1190fc56718144190a3db61c63af)
+![Claude Code クライアントと Claude Desktop がベアラートークンを使用して HTTPS 経由でインフラストラクチャ内の自己ホスト型 Claude apps gateway に接続し、ゲートウェイが IdP に対してユーザーをサインインさせ、PostgreSQL に認証状態を保存し、テレメトリを OTLP コレクターにリレーし、Amazon Bedrock、Claude Platform on AWS、Google Cloud、Microsoft Foundry、または Anthropic API に推論を転送する図](https://mintcdn.com/claude-code/VbyXug8hBU9UK6oT/images/claude-gateway-architecture.svg?fit=max\&auto=format\&n=VbyXug8hBU9UK6oT\&q=85\&s=9e4f1190fc56718144190a3db61c63af)
 
 > [!NOTE]
@@ -351,5 +351,5 @@ Claude Code はゲートウェイに接続する前に `/login` でリストを
 ### Claude Desktop セッションにポリシーを配信する
 
-Claude Desktop は Cowork タブと Code タブ、および有効にした場合は Chat タブを、埋め込み Claude Code セッションで実行し、それらのモデルリクエストをゲートウェイを通じて送信します。ゲートウェイが `/user/bootstrap` で提供する設定から構築されたポリシーを各セッションに渡します。モデル許可リスト、無効化されたツール、および一致したポリシーの `cli` または `code` ブロックから派生した出力許可リスト、および[`desktop` オーバーレイ](https://code.claude.com/docs/ja/claude-apps-gateway-config#claude-desktop-overlay)です。
+Claude Desktop は、Cowork タブと Code タブ、および有効にした場合は Chat を、組み込みの Claude Code セッション上で実行し、それらのモデルリクエストをゲートウェイ経由で送信します。Claude Desktop は、ゲートウェイが `/user/bootstrap` で提供する設定から構築したポリシーを、これらの各セッションに渡します。このポリシーには、一致したポリシーの `cli` ブロックまたは `code` ブロックから導出されるモデル許可リスト、無効化されたツール、エグレス許可リストに加えて、[`desktop` オーバーレイ](https://code.claude.com/docs/ja/claude-apps-gateway-config#claude-desktop-overlay)が含まれます。
 
 フック、`env`、および `Bash(npm *)` のようなスコープ付き権限ルールなど、ブロックの他のキーは、`/login` を通じてサインインするクライアントに到達します。`code` の下にある場合、[Code タブの条件](https://code.claude.com/docs/ja/claude-apps-gateway-config.md#apply-code-settings-in-the-code-tab)が満たされていれば、Code タブのセッションにも到達します。Cowork セッションや Chat セッションには到達しません。Claude Desktop はゲートウェイ URL を独自の管理設定から読み取り、[ゲートウェイ URL を設定する](#set-the-gateway-url)の `forceLoginMethod` と `forceLoginGatewayUrl` キーとは別の独自のフローでサインインします。
@@ -481,5 +481,5 @@ OS ポリシー（HKLM レジストリポリシーまたは管理設定プリス
 Claude Desktop は同じブラウザ SSO ステップでゲートウェイのアイデンティティプロバイダーを通じて開発者にサインインし、Anthropic ではなくゲートウェイから設定をフェッチします。モデルアクセスとポリシーは CLI と同じグループごとのルールに従います。CLI と Claude Desktop の両方を使用する開発者は各々に個別にサインインします。ゲートウェイセッションはそれらの間で共有されません。
 
-接続すると、Claude Desktop は有効なすべてのタブからモデルリクエストをゲートウェイを通じて送信します。デフォルトで Cowork タブと Code タブを表示します。Chat タブもオンにするには、Claude Desktop の[管理設定](https://claude.com/docs/third-party/claude-desktop/configuration)で `chatTabEnabled` を `true` に設定するか、Claude Code v2.1.227 以降を実行しているゲートウェイのポリシーの [`desktop` ブロック](https://code.claude.com/docs/ja/claude-apps-gateway-config#claude-desktop-overlay)で設定します。
+接続すると、Claude Desktop は有効なすべてのタブからモデルリクエストをゲートウェイを通じて送信します。デフォルトで Cowork タブと Code タブを表示します。Chat も利用できるようにするには、Claude Code v2.1.227 以降を実行しているゲートウェイで、ポリシーの [`desktop` ブロック](https://code.claude.com/docs/ja/claude-apps-gateway-config#claude-desktop-overlay)で `chatTabEnabled` を `true` に設定します。Cowork がオンの場合、Claude Desktop は Chat と Cowork を 1 つのタブにまとめて表示します。
 
 ### CI パイプラインとリモートマシン
@@ -524,5 +524,5 @@ Claude Desktop は同じブラウザ SSO ステップでゲートウェイのア
 | 100 万トークンのコンテキストウィンドウ | 利用可能 | Fable モデル、Sonnet 5 以降、Opus 4.7 以降は、デフォルトで 100 万トークンのウィンドウで動作します。[拡張コンテキスト](https://code.claude.com/docs/ja/model-config.md#extended-context)を参照してください。Fable モデルと Opus モデルで 100 万トークンをデフォルトにするには、開発者のマシン上で Claude Code v2.1.287 以降が必要です |
 | IdP グループごとのモデルアクセスと管理設定 | 利用可能 | モデルアクセスはサーバー側で適用されます。管理設定は IdP グループごとに配信され、CLI によって[管理設定の階層](https://code.claude.com/docs/ja/settings.md#settings-precedence)で適用されます |
-| Claude Desktop | オプトインで利用可能 | ポリシーで [`desktop` キーによりオプトイン](https://code.claude.com/docs/ja/claude-apps-gateway-config#claude-desktop-overlay)すると、ゲートウェイは `/user/bootstrap` で Claude Desktop の設定を提供し、Claude Desktop は Cowork タブと Code タブから、および有効にした場合は Chat タブから、ゲートウェイ経由でモデルリクエストを送信します。Chat タブをオンにするには、[Claude Desktop を接続する](#connect-claude-desktop)を参照してください。ゲートウェイサーバー上で Claude Code v2.1.203 以降が必要です。 |
+| Claude Desktop | オプトインで利用可能 | ポリシーで [`desktop` キーによりオプトイン](https://code.claude.com/docs/ja/claude-apps-gateway-config#claude-desktop-overlay)すると、ゲートウェイは `/user/bootstrap` で Claude Desktop の設定を提供し、Claude Desktop はゲートウェイ経由でモデルリクエストを送信します。Chat をオンにするには、[Claude Desktop を接続する](#connect-claude-desktop)を参照してください。ゲートウェイサーバー上で Claude Code v2.1.203 以降が必要です。 |
```

</details>

<details>
<summary>claude-code-on-the-web-ja.md</summary>

```diff
diff --git a/docs-ja/pages/claude-code-on-the-web-ja.md b/docs-ja/pages/claude-code-on-the-web-ja.md
index c1b02d3..496ffce 100644
--- a/docs-ja/pages/claude-code-on-the-web-ja.md
+++ b/docs-ja/pages/claude-code-on-the-web-ja.md
@@ -202,5 +202,5 @@ View: https://claude.ai/code/session_01DiUkqY2kzbUbDmW1w96rfi?from=cli&m=0
 次のいずれかの方法で、クラウドセッションをターミナルに取り込みます。
 
-* **`--teleport` を使用する**: コマンドラインから `claude --teleport` を実行すると対話型のセッション選択画面が開き、`claude --teleport <session-id>` を実行すると特定のセッションを直接再開できます。コミットされていない変更がある場合は、先に stash するよう求められます。
+* **`--teleport` を使用する**: コマンドラインから `claude --teleport` を実行すると対話型のセッション選択画面が開き、`claude --teleport <session-id>` を実行すると特定のセッションを直接再開できます。コミットされていない変更がある場合は、先に stash するよう求められます。[`--resume`](https://code.claude.com/docs/ja/sessions#resume-a-session) はこのマシンのローカル履歴から会話を再開するもので、クラウドセッションは一覧に表示されません。
 * **`/teleport` を使用する**: 既存の CLI セッション内で `/teleport` または `/tp` を実行すると、Claude Code を再起動せずに同じセッション選択画面を開けます。
 * **`/tasks` から**: `/tasks` を実行してバックグラウンドセッションを表示し、`t` を押してセッションに teleport します。
@@ -208,7 +208,11 @@ View: https://claude.ai/code/session_01DiUkqY2kzbUbDmW1w96rfi?from=cli&m=0
 * **クラウドセッション内から**: `/teleport` と入力すると、Claude Code がそのセッション用の正確な `claude --teleport <session-id>` コマンドを返します。このコマンドはリポジトリのチェックアウトからすぐに実行できます。セッションの環境に Claude Code v2.1.223 以降が必要です。
 
-セッションを teleport すると、Claude は正しいリポジトリにいることを確認し、クラウドセッションのブランチをフェッチしてチェックアウトし、会話の全履歴をターミナルに読み込みます。ターミナルはセッションの独自のコピーを取得します。そこで行った新しい作業はローカルにとどまり、claude.ai や Claude モバイルアプリのクラウドセッションには表示されません。teleport 後もスマートフォンから操作を続けるには、ローカルセッションで [`/remote-control`](https://code.claude.com/docs/ja/remote-control) を開始してください。
+セッションを teleport すると、Claude は正しいリポジトリにいることを確認し、クラウドセッションのブランチをフェッチしてチェックアウトし、会話をターミナルに読み込みます。
 
-`--teleport` は `--resume` とは異なります。`--resume` はこのマシンのローカル履歴から会話を再開するもので、クラウドセッションは一覧に表示されません。`--teleport` はクラウドセッションとそのブランチを取り込みます。
+> [!NOTE]
+>
+> Claude Code がクラウドセッションを[コンパクト化](https://code.claude.com/docs/ja/context-window.md#what-survives-compaction)している場合（長いセッションでは自動的に行われます）、要約された以前のメッセージはターミナルにコピーされません。Claude は要約から続行します。元のメッセージを読むには、claude.ai または Claude モバイルアプリのクラウドセッションで上にスクロールしてください。
+
+ターミナルはセッションの独自のコピーを取得します。そこで行った新しい作業はローカルにとどまり、claude.ai や Claude モバイルアプリのクラウドセッションには表示されません。teleport 後もスマートフォンから操作を続けるには、ローカルセッションで [`/remote-control`](https://code.claude.com/docs/ja/remote-control) を開始してください。
 
 #### Teleport の要件
@@ -496,5 +500,6 @@ v2.1.274 から v2.1.289 までは、サインインメッセージは `Claude C
 * **時間制限**: Claude が実行するコマンドと SessionStart フックにはデフォルトのタイムアウトがあり、変更できます。セットアップスクリプトはおよそ 5 分以内に完了した場合のみキャッシュされます。[時間制限](https://code.claude.com/docs/ja/cloud-environments.md#time-limits) を参照してください。
 * **リポジトリ認証**: クラウドセッションをターミナルに取り込むことができるのは、同じアカウントで認証されている場合のみです。
-* **プラットフォーム制限**: リポジトリのクローンとプルリクエストの作成には GitHub が必要です。自己ホスト型の [GitHub Enterprise Server](https://code.claude.com/docs/ja/github-enterprise-server.md) インスタンスは Team および Enterprise プランでサポートされています。GitLab、Bitbucket、またはその他の非 GitHub リポジトリをクラウドセッションに [ローカルバンドル](#send-local-repositories-without-github) として送信できます。これは `CCR_FORCE_BUNDLE=1` を設定することで実現できますが、セッションはその結果をリモートにプッシュバックできません。
+* **プラットフォーム制限**: Anthropic ホスト環境でのリポジトリのクローンとプルリクエストの作成には GitHub が必要です。自己ホスト型の [GitHub Enterprise Server](https://code.claude.com/docs/ja/github-enterprise-server.md) インスタンスは Team および Enterprise プランでサポートされています。GitLab、Bitbucket、またはその他の非 GitHub リポジトリをクラウドセッションに [ローカルバンドル](#send-local-repositories-without-github) として送信できます。これは `CCR_FORCE_BUNDLE=1` を設定することで実現できますが、セッションはその結果をリモートにプッシュバックできません。
```

</details>

*...以降省略*

</details>


<details>
<summary>2026-10-29</summary>

**変更ファイル:**

```
 docs-ja/pages/authentication-ja.md                 |  17 ++-
 docs-ja/pages/auto-mode-config-ja.md               |  52 +++----
 docs-ja/pages/channels-reference-ja.md             |  74 ++++-----
 docs-ja/pages/checkpointing-ja.md                  |  50 +++---
 docs-ja/pages/claude-apps-gateway-config-ja.md     |  19 ++-
 docs-ja/pages/claude-apps-gateway-ja.md            |   6 +-
 docs-ja/pages/claude-code-on-the-web-ja.md         |   5 +-
 docs-ja/pages/claude-directory-ja.md               |   2 +-
 docs-ja/pages/cloud-environments-ja.md             |  11 +-
 docs-ja/pages/context-window-ja.md                 |  20 +--
 docs-ja/pages/corporate-launcher-ja.md             |   2 +-
 docs-ja/pages/debug-your-config-ja.md              |  10 +-
 docs-ja/pages/deep-links-ja.md                     |   4 +-
 docs-ja/pages/desktop-ja.md                        |  12 +-
 docs-ja/pages/desktop-quickstart-ja.md             |   2 +-
 docs-ja/pages/devcontainer-ja.md                   |   2 +-
 docs-ja/pages/env-vars-ja.md                       |   6 +-
 docs-ja/pages/errors-ja.md                         |  60 ++++++--
 docs-ja/pages/fast-mode-ja.md                      |  18 ++-
 docs-ja/pages/feature-availability-ja.md           |   4 +-
 docs-ja/pages/github-actions-ja.md                 |   4 +-
 docs-ja/pages/github-enterprise-server-ja.md       |   9 ++
 docs-ja/pages/hooks-guide-ja.md                    |  94 ++++++------
 docs-ja/pages/interactive-mode-ja.md               |   6 +-
 docs-ja/pages/managed-settings-ja.md               | 170 +++++++++++----------
 docs-ja/pages/mcp-ja.md                            |  65 +++++---
 docs-ja/pages/mcp-quickstart-ja.md                 |   1 +
 docs-ja/pages/model-config-ja.md                   |  21 ++-
 docs-ja/pages/monitoring-usage-ja.md               |   1 +
 docs-ja/pages/permission-modes-ja.md               |  36 ++---
 .../self-hosted-environments-configuration-ja.md   |  37 ++++-
 .../pages/self-hosted-environments-deploy-ja.md    |  21 ++-
 .../self-hosted-environments-quickstart-ja.md      |   2 +-
 .../pages/self-hosted-environments-reference-ja.md |  31 ++--
 docs-ja/pages/server-managed-settings-ja.md        |   1 +
 docs-ja/pages/settings-ja.md                       | 130 ++++++++--------
 docs-ja/pages/settings-reference-ja.md             |  17 ++-
 docs-ja/pages/skills-ja.md                         |  13 +-
 docs-ja/pages/sub-agents-ja.md                     |   2 +-
 docs-ja/pages/terminal-config-ja.md                | 110 ++++++-------
 docs-ja/pages/troubleshoot-install-ja.md           |  24 ++-
 docs-ja/pages/vs-code-ja.md                        |  21 ++-
 docs-ja/pages/worktrees-ja.md                      |  16 +-
 43 files changed, 709 insertions(+), 499 deletions(-)
```

<details>
<summary>authentication-ja.md</summary>

```diff
diff --git a/docs-ja/pages/authentication-ja.md b/docs-ja/pages/authentication-ja.md
index 3819766..75444fe 100644
--- a/docs-ja/pages/authentication-ja.md
+++ b/docs-ja/pages/authentication-ja.md
@@ -18,5 +18,5 @@ Claude Code は、セットアップに応じて複数の認証方法をサポ
 ブラウザが自動的に開かない場合は、`c` を押してログイン URL をクリップボードにコピーし、ブラウザに貼り付けます。
 
-ブラウザがサインイン後にリダイレクトされずにログインコードを表示する場合は、`Paste code here if prompted` プロンプトでそれをターミナルに貼り付けます。これは、ブラウザが Claude Code のローカルコールバックサーバーに到達できない場合に発生します。これは WSL2、SSH セッション、およびコンテナで一般的です。
+ブラウザがサインイン後にリダイレクトされずにログインコードを表示する場合は、`Paste code here if prompted` プロンプトでそれをターミナルに貼り付けます。
 
 ログインが完了すると、ターミナルに `Login successful` と表示され、`Enter` キーを押して続行するよう求められます。
@@ -128,5 +128,6 @@ API キーを作成しなくても Console アカウントにサインインで
 
 * Amazon Bedrock、Google Cloud の Agent Platform、Microsoft Foundry などの [クラウドプロバイダーに対して実行](https://code.claude.com/docs/ja/third-party-integrations.md)するか、[AWS 上の Claude Platform](https://code.claude.com/docs/ja/claude-platform-on-aws.md) に対して実行する
-* 任意の設定ファイルが [`forceLoginOrgUUID`](#restrict-login-to-your-organization) を設定するか、`forceLoginMethod` を `"claudeai"` または `"console"` に設定する
+* 任意の設定ファイルが [`forceLoginOrgUUID`](#restrict-login-to-your-organization) を設定するか、`forceLoginMethod` を `"claudeai"` に設定する
+* `forceLoginMethod` が `"console"` で、どの設定ファイルも `forceLoginOrgUUID` を設定していない場合（サインインに失敗した後にエラー画面から再試行するまで）
 * マシン上に管理設定ファイル、MDM プロファイル、キャッシュされたサーバー管理設定などの管理設定ソースが存在しますが、Claude Code が [それを読み取ることができず](https://code.claude.com/docs/ja/managed-settings.md#invalid-entries-in-managed-settings)、他の管理ソースがポリシーを提供していない
 
@@ -141,4 +142,14 @@ API キーを作成しなくても Console アカウントにサインインで
 プロファイルに関するその他すべてのことがこのサインインに適用されます。これには、他の認証情報に対するランク付け、`/status` で取得される `Profile` 行、および claude.ai ログインが必要な機能が含まれます。[Anthropic プロファイルとフェデレーション認証情報](#anthropic-profiles-and-federation-credentials)を参照してください。
 
+#### 管理対象マシンでキーレスサインインの提供を停止する
+
+Claude Code が [キーレスサインイン](#sign-in-without-an-api-key)を提供しないようにするには、デバイス管理ツールを使用して、[管理設定](https://code.claude.com/docs/ja/managed-settings.md)の [`forceLoginOrgUUID`](https://code.claude.com/docs/ja/settings-reference#forceloginorguuid) を各開発者のマシンにデプロイします。値には [Console の組織 ID](https://platform.claude.com/settings/organization) を設定します。デプロイする前に、各開発者が [API キーを作成できるロール](#claude-console-authentication)を持っていることを確認してください。デプロイ後は、そのロールを持たない開発者は `/login` で Console にサインインできなくなります。
+
+`forceLoginMethod` を `"console"` に設定しただけの場合、開発者は失敗したサインインを再試行してキーレスのオプションを選択できます。`forceLoginOrgUUID` をデプロイすると、ログイン画面からそのオプションはなくなりますが、開発者は既に持っている、または [`ant auth login`](https://platform.claude.com/docs/en/cli-sdks-libraries/cli/authentication) で作成した [Anthropic プロファイル](#anthropic-profiles-and-federation-credentials)を引き続き使用できます。デプロイ後は、各マシンで以下の認証情報とログインに対処してください。
+
+* **キーレスサインイン**: 開発者を API キーに移行するには、いったんログアウトしてから Console に再度ログインしてもらいます。これによりキーが作成されます。キーレスサインインの場合は、シェルで `claude auth logout` を実行します。`ant auth login` のプロファイルの場合は、`ant auth logout` を実行します。プロファイルと API キーの両方がマシン上にあると Claude Code はセッションを拒否するため、先にログアウトしてもらいます。
+* **環境変数およびヘルパーの認証情報**: Claude Code は、`ANTHROPIC_API_KEY`、`ANTHROPIC_AUTH_TOKEN`、または `apiKeyHelper` で認証するセッションを、管理設定がそれらを提供している場合でも拒否します。これらの認証情報を削除してから、開発者に `/login` を実行して保存済みの API キーを作成してもらいます。
```

</details>

<details>
<summary>auto-mode-config-ja.md</summary>

```diff
diff --git a/docs-ja/pages/auto-mode-config-ja.md b/docs-ja/pages/auto-mode-config-ja.md
index 6ff722a..ca5060f 100644
--- a/docs-ja/pages/auto-mode-config-ja.md
+++ b/docs-ja/pages/auto-mode-config-ja.md
@@ -156,40 +156,40 @@ Claude のプッシュおよびプルリクエストコマンドの前に人間
 すべてを一度に入力する必要はありません。合理的なロールアウト: デフォルトから始めて、ソース管理組織と主要な内部サービスを追加します。これにより、独自のリポジトリへのプッシュなど、最も一般的な誤検知が解決されます。次に信頼できるドメインとクラウドバケットを追加します。ブロックが発生したら残りを入力します。
 
-## `/auto-mode-setup` で環境エントリを生成する
+## `/auto-mode-setup` で environment エントリを生成する
 
-`/auto-mode-setup` を実行すると、Claude Code がプロジェクトと最近のセッションから `autoMode.environment` エントリを作成し、時には[ルールエントリ](#override-the-block-and-allow-rules)も作成します。ドラフトを承認すると、Claude Code は `~/.claude/settings.json` に書き込みます。
+`/auto-mode-setup` を実行すると、Claude Code がプロジェクトとそのプロジェクトでの最近のセッションから `autoMode.environment` エントリの草案を作成し、場合によっては[ルールエントリ](#override-the-block-and-allow-rules)の草案も作成します。草案を承認すると、Claude Code はそれを `~/.claude/settings.json` に書き込みます。
 
 > [!NOTE]
 >
-> `/auto-mode-setup` は Pro、Max、Team、Enterprise プラン、および Claude Console API キーで利用できます。Pro、Max、または Team プランでは v2.1.228 以降が必要です。ネイティブ Windows では v2.1.233 以降が必要です。Enterprise プランまたは Claude Console API キーでは v2.1.283 以降が必要です。セッションにこのコマンドが見当たらない場合は、[`/auto-mode-setup` が "Unknown command" を返す](#auto-mode-setup-returns-unknown-command)を参照してください。
+> `/auto-mode-setup` は Pro、Max、Team、Enterprise プラン、および Claude Console の API キーで利用できます。Pro、Max、Team プランでは v2.1.228 以降（ネイティブ Windows では v2.1.233 以降）が必要です。Enterprise プランまたは Claude Console の API キーでは v2.1.283 以降が必要です。セッションでこのコマンドが見つからない場合は、[`/auto-mode-setup` が「Unknown command」を返す](#auto-mode-setup-returns-unknown-command)を参照してください。
 
-### `/auto-mode-setup` が読み込むもの
+### `/auto-mode-setup` が読み取る内容
 
-`~/.claude/settings.json` に既に `autoMode` エントリが含まれている場合、Claude Code はまず環境リストに追加するか置き換えるかを尋ね、どちらの場合でも作成したルールを保持します。その後、Claude Code はこのプロジェクトの使用方法を尋ね、スキャンの前に 2 つのオプションスキャンを提供します。スキャンでは、Claude Code は常にこれらのソースを読み込みます：
+`~/.claude/settings.json` にすでに `autoMode` エントリがある場合、Claude Code はまず environment リストに追加するか置き換えるかを尋ねます。どちらの場合も、ユーザーが書いたルールは保持されます。次に Claude Code はこのプロジェクトの使い方を尋ね、スキャンを始める前に 2 つの任意のスキャンを提示します。スキャンでは、Claude Code は常に次のソースを読み取ります。
 
-* このプロジェクトの `CLAUDE.md`、`README.md`、設定ファイル、および git リモート
-* `autoMode` および `permissions.allow` 設定
-* Claude がこのプロジェクトの最近のセッションで実行したコマンドのホスト、バケット、コマンド名（メッセージは含まない）
+* このプロジェクトの `CLAUDE.md`、`README.md`、設定ファイル、git リモート
+* `autoMode` および `permissions.allow` の設定
+* このプロジェクトでの最近のセッションで Claude が実行したコマンドに含まれるホスト、バケット、コマンド名（ユーザーのメッセージは読み取りません）
```

</details>

<details>
<summary>channels-reference-ja.md</summary>

```diff
diff --git a/docs-ja/pages/channels-reference-ja.md b/docs-ja/pages/channels-reference-ja.md
index ebb471a..1a7f3cd 100644
--- a/docs-ja/pages/channels-reference-ja.md
+++ b/docs-ja/pages/channels-reference-ja.md
@@ -51,13 +51,13 @@
 リサーチプレビュー中、カスタムチャネルは[承認許可リスト](https://code.claude.com/docs/ja/channels.md#supported-channels)にありません。ローカルでテストするには `--dangerously-load-development-channels` を使用してください。詳細については、[リサーチプレビュー中のテスト](#test-during-the-research-preview)を参照してください。
 
-## 例：webhook レシーバーを構築
+## 例：webhook レシーバーを構築する
 
-このウォークスルーでは、HTTP リクエストをリッスンして Claude Code セッションに転送する単一ファイルサーバーを構築します。終了時には、CI パイプライン、監視アラート、または `curl` コマンドなど、HTTP POST を送信できるものはすべて、Claude にイベントをプッシュできます。
+このウォークスルーでは、HTTP リクエストを待ち受けて Claude Code セッションに転送する単一ファイルのサーバーを構築します。最終的には、CI パイプライン、監視アラート、`curl` コマンドなど、HTTP POST を送信できるものであれば何でも Claude にイベントをプッシュできるようになります。
 
-この例では、組み込み HTTP サーバーと TypeScript サポートのために [Bun](https://bun.sh) をランタイムとして使用しています。代わりに [Node](https://nodejs.org) または [Deno](https://deno.com) を使用できます。唯一の要件は [MCP SDK](https://www.npmjs.com/package/@modelcontextprotocol/sdk) です。
+この例では、組み込みの HTTP サーバーと TypeScript サポートを備えた [Bun](https://bun.sh) をランタイムとして使用します。代わりに [Node](https://nodejs.org) や [Deno](https://deno.com) を使用することもできます。唯一の要件は [MCP SDK](https://www.npmjs.com/package/@modelcontextprotocol/sdk) です。
 
-**1. プロジェクトを作成**
+**1. プロジェクトを作成する**
 
-[権限リレー](#relay-permission-prompts) の例は `zod` を直接インポートするため、MCP SDK と一緒にインストールされます。新しいディレクトリを作成して両方をインストールします：
+[権限リレー](#relay-permission-prompts)の例では `zod` を直接インポートするため、MCP SDK と一緒にインストールします。新しいディレクトリを作成し、両方をインストールします。
 
 ```bash theme={null}
@@ -66,7 +66,7 @@ bun add @modelcontextprotocol/sdk zod
 ```
 
-**2. チャネルサーバーを記述**
+**2. チャネルサーバーを作成する**
 
-`webhook.ts` というファイルを作成します。これはチャネルサーバー全体です：stdio 経由で Claude Code に接続し、ポート 8788 で HTTP POST をリッスンします。リクエストが到着すると、本文をチャネルイベントとして Claude にプッシュします。
```

</details>

<details>
<summary>checkpointing-ja.md</summary>

```diff
diff --git a/docs-ja/pages/checkpointing-ja.md b/docs-ja/pages/checkpointing-ja.md
index 6be6271..f61b283 100644
--- a/docs-ja/pages/checkpointing-ja.md
+++ b/docs-ja/pages/checkpointing-ja.md
@@ -11,53 +11,53 @@ Claude Code は、作業中に Claude が行ったファイルエディットを
 ## チェックポイントの仕組み
 
-Claude で作業する際、チェックポイント機能は送信する各プロンプトがターンを開始する前のコード状態を自動的にキャプチャします。
+Claude と作業する際、チェックポイント機能は、ターンを開始するプロンプトを送信するたびに、その前のコードの状態を自動的に保存します。
 
 ### 自動追跡
 
-Claude Code は、ファイル編集ツールで行われたすべての変更を追跡します。
+Claude Code は、ファイル編集ツールによって行われたすべての変更を追跡します。
 
-* 送信する各プロンプトがターンを開始するたびに新しいチェックポイントが作成されます
-* Claude Code はセッション内の最新 100 個のチェックポイントのファイルスナップショットを保持します。古いチェックポイントを破棄すると、残りのチェックポイントが参照しないスナップショットファイルが削除されます。ただし、各ファイルの最初のスナップショットは除外されます。これは VS Code 拡張機能がセッション diff のベースラインとして使用します。
-* チェックポイントはセッションと共に保存されるため、再開したセッションでも `/rewind` で戻ることができます
-* Claude Code は[保持期間スイープ](https://code.claude.com/docs/ja/claude-directory.md#cleaned-up-automatically)でセッションのファイルスナップショットを削除します。デフォルトではセッションが最後に保存されてから約 30 日後です。スナップショットが削除されたチェックポイントに巻き戻すと、[`No files were restored`](https://code.claude.com/docs/ja/errors#no-files-were-restored) エラーで失敗する可能性があります。スナップショットをより長く保持するには、[`cleanupPeriodDays`](https://code.claude.com/docs/ja/settings-reference#cleanupperioddays) を設定してください。
+* ターンを開始するプロンプトを送信するたびに、新しいチェックポイントが作成されます
+* Claude Code は、セッション内の直近 100 個のチェックポイントについてファイルのスナップショットを保持します。古いチェックポイントを破棄すると、残っているどのチェックポイントからも参照されていないスナップショットファイルが削除されます。ただし、各ファイルの最初のスナップショットは、VS Code 拡張機能がセッションの差分のベースラインとして使用するため削除されません。
+* Claude Code はチェックポイントを会話とともに保存するため、セッションを再開した後でも `/rewind` を実行できます
+* Claude Code は、[保持期間のクリーンアップ](https://code.claude.com/docs/ja/claude-directory.md#cleaned-up-automatically)でセッションのファイルスナップショットを削除します。デフォルトでは、セッションが最後にスナップショットを保存してから約 30 日後に削除されます。スナップショットが削除されたチェックポイントに巻き戻そうとすると、[`No files were restored`](https://code.claude.com/docs/ja/errors#no-files-were-restored) で失敗することがあります。スナップショットをより長く保持するには、[`cleanupPeriodDays`](https://code.claude.com/docs/ja/settings-reference#cleanupperioddays) を設定してください。
 
 ### 巻き戻しと要約
 
-`/rewind` を実行するか、プロンプト入力が空の状態で `Esc` キーを 2 回押して、巻き戻しメニューを開きます。
+`/rewind` を実行するか、プロンプト入力が空のときに `Esc` を 2 回押すと、巻き戻しメニューが開きます。
 
 > [!NOTE]
```

</details>

<details>
<summary>claude-apps-gateway-config-ja.md</summary>

```diff
diff --git a/docs-ja/pages/claude-apps-gateway-config-ja.md b/docs-ja/pages/claude-apps-gateway-config-ja.md
index 8d558aa..5f14717 100644
--- a/docs-ja/pages/claude-apps-gateway-config-ja.md
+++ b/docs-ja/pages/claude-apps-gateway-config-ja.md
@@ -420,5 +420,5 @@ upstreams:
 ```yaml theme={null}
 models:
-  - id: claude-opus-restricted          # a custom id, not a built-in model name
+  - id: restricted-claude-opus-4-8      # a custom id, not a built-in model name
     upstream_model:
       bedrock-isolated: us.anthropic.claude-opus-4-8   # the only upstream that serves it
@@ -630,5 +630,8 @@ AWS SigV4 でリクエストに署名する Amazon Bedrock または Claude Plat
 ゲートウェイは失敗したアップストリームの記録を保持しないため、アップストリームがダウンしている間、そこに到達するすべてのリクエストは引き続きそのアップストリームを試行し、失敗するのを待ってから次に進みます。
 
-Anthropic API アップストリームでは、[`timeouts.upstream_ttfb_ms`](#http-tuning) がダウンしたアップストリームでの待機時間の上限を定めます。この設定は他のプロバイダーには適用されず、それらのプロバイダーでは、ゲートウェイはアップストリームが応答を開始するまで最大 1 時間待機します。
+ゲートウェイがレスポンスの開始を待機する時間は次のとおりです。
+
+* **`provider: anthropic` アップストリーム**: [`timeouts.upstream_ttfb_ms`](#http-tuning)。デフォルトは 120 秒
+* **その他のプロバイダー**: 最大 1 時間。ストリーミングリクエストでこの待機時間を短縮するには、ゲートウェイ v2.1.295 以降で `timeouts.upstream_ttfb_ms` を設定します。非ストリーミングのモデルリクエストは、いずれの場合も最大 1 時間待機します
 
 `404` はアップストリームごとのモデルの提供状況を表すため、モデルを有効にしていないアップストリームが、そのモデルを提供する後続のアップストリームを妨げることはありません。要求されたモデルを解決できないアップストリームは、ネットワークのラウンドトリップなしでスキップされます。
@@ -874,7 +877,9 @@ managed:
     - match: { groups: [restricted-projects] }
       cli:
-        availableModels: [claude-opus-restricted]
+        availableModels: [restricted-claude-opus-4-8]
         enforceAvailableModels: true
-        model: claude-opus-restricted
+        model: restricted-claude-opus-4-8
+        env:
```

</details>

<details>
<summary>claude-apps-gateway-ja.md</summary>

```diff
diff --git a/docs-ja/pages/claude-apps-gateway-ja.md b/docs-ja/pages/claude-apps-gateway-ja.md
index 9f663ee..fda094b 100644
--- a/docs-ja/pages/claude-apps-gateway-ja.md
+++ b/docs-ja/pages/claude-apps-gateway-ja.md
@@ -398,5 +398,5 @@ Claude Code は親が提供した [`sandbox.credentials`](https://code.claude.co
 * **[`mode: mask`](https://code.claude.com/docs/ja/sandboxing#mask-credential-files)を持つファイルエントリ**：センチネルのみとして転送され、`injectHosts` が空のリストである全ファイルマスクとして。プロキシは親が提供したエントリの実際の値を任意のプラットフォームで置き換えることはありません。すべての構造化マスキングフィールドも削除されるため、親が提供した抽出パターンは別のソースが同じパスに設定するより厳密なマスクを置き換えることはできません。
 * **`mode: mask` を持つ `envVars` エントリ**：転送されません。`deny` は親チャネルが `envVars` エントリを通じて表現できる唯一の制限です。
-* **[`awsPairs` と `sigv4`](https://code.claude.com/docs/ja/sandboxing#re-sign-aws-requests)**：制限のみ転送されます。`sigv4` からは `deny` 値のみが保持され、親が `sigv4` ブロックをまったく定義する場合、すべての 3 つのリクエスト形式 `streaming`、`presigned`、および `sigv4a` を `deny` にピン留めします。`awsPairs` ペアは再署名できる形式では転送されません。従来の AWS 変数の 1 つに名前を付けるペアは、`AWS_ACCESS_KEY_ID`、`AWS_SECRET_ACCESS_KEY`、および `AWS_SESSION_TOKEN` の自動ペアリングを抑制したままにする不活性エントリに置き換えられます。
+* **[`awsPairs` と `sigv4`](https://code.claude.com/docs/ja/sandboxing#re-sign-aws-requests)**：制限のみ転送されます。`sigv4` からは `deny` 値のみが保持され、親が `sigv4` ブロックを何らかの形で定義する場合、すべての 3 つのリクエスト形式 `streaming`、`presigned`、および `sigv4a` を `deny` にピン留めします。`awsPairs` ペアは再署名できる形式では転送されません。従来の AWS 変数の 1 つに名前を付けるペアは、`AWS_ACCESS_KEY_ID`、`AWS_SECRET_ACCESS_KEY`、および `AWS_SESSION_TOKEN` の自動ペアリングを抑制したままにする不活性エントリに置き換えられます。
 
 #### ロックをデプロイする
@@ -447,5 +447,5 @@ OS ポリシー（HKLM レジストリポリシーまたは管理設定プリス
 5 つのロックすべてが設定されていても、以下の親が提供した設定はフィルターを通過します。
 
-* **`forceLoginOrgUUID`**：最優先の管理ソースが組織 UUID を設定しない場合、Claude Code は親が提供した値を尊重します。ゲートウェイサインインはこのキーをチェックしません。最優先の管理ソースの組織 UUID は親の値をブロックし、Claude Code が強制するものです。
+* **`forceLoginOrgUUID`**：Claude Code が適用する管理設定が組織 UUID を設定していない場合、Claude Code は親が提供した値を尊重します。ゲートウェイサインインはこのキーをチェックしません。Claude Code が適用する管理設定内の組織 UUID は親の値をブロックし、Claude Code が強制する組織 UUID になります。フリートで Anthropic 組織を固定している場合、`forceLoginOrgUUID` をどこに設定するかについては[ログインキーを提供する管理ソース](https://code.claude.com/docs/ja/managed-settings.md#which-managed-source-supplies-login-keys)を参照してください。
 * **`allowedMcpServers`**：有効な管理リストがない場合、Claude Code は親が提供した許可リストを尊重します。`allowManagedMcpServersOnly` はそれをブロックしません。ロックは勝者となったリストを管理値として強制し、どの管理ソースもリストを提供しない場合は親が提供したリストも含まれるためです。最優先の管理ソースのリストは親のリストをブロックし、Claude Code が強制するリストになるため、ロックの隣のそこに `allowedMcpServers` を設定します。v2.1.223 より前では、任意の管理ソースのいずれかのキーの値は親の値をブロックしました。
 * **`availableModels`**：勝者の管理ソースが設定しない場合、Claude Code は親が提供したモデルリストを尊重します。フリートがモデルを制限する場合、勝者ソースに `availableModels` を設定します。
@@ -455,5 +455,5 @@ OS ポリシー（HKLM レジストリポリシーまたは管理設定プリス
 * **`strictPluginOnlyCustomization`**：このキーはロックに関係なくフィルターを通過し、Claude Code が開発者独自のカスタマイズ（保護フックを含む）を無視するようにします。ロックはそれをブロックしません。
 
-デフォルトの最初の勝ちの設定の下では、管理値が親の値をブロックするのは、それが最優先の管理ソースにある場合のみです。ただし、[MCP サーバーロック](#lock-behavior-across-sources)がオンの間の `allowedMcpServers` は除きます。`managedSourcesBehavior` マージオプトインの下では、[Claude Code が管理ソースを組み合わせる方法](https://code.claude.com/docs/ja/managed-settings.md#how-claude-code-combines-managed-sources)が代わりにどのソースの値が適用されるかを示します。
+`managedSourcesBehavior` を `"merge"` に設定している場合は、[キーの種類ごとにどのソースの値が適用されるか](https://code.claude.com/docs/ja/managed-settings.md#compose-every-managed-source)を確認してください。
 
 #### 親設定のフックキーとスキルキーがどのように有効になるか
```

</details>

*...以降省略*

</details>


<details>
<summary>2026-10-28</summary>

**変更ファイル:**

```
 docs-ja/pages/accessibility-ja.md                  |   4 +-
 docs-ja/pages/admin-setup-ja.md                    |   1 +
 docs-ja/pages/agent-view-ja.md                     |  10 +-
 docs-ja/pages/agents-ja.md                         |   2 +-
 docs-ja/pages/amazon-bedrock-ja.md                 |   4 +-
 docs-ja/pages/artifacts-ja.md                      |  40 +-
 docs-ja/pages/changelog.md                         |  42 ++
 docs-ja/pages/chrome-ja.md                         |   2 +-
 docs-ja/pages/claude-apps-gateway-config-ja.md     |   4 +-
 docs-ja/pages/claude-code-on-the-web-ja.md         |  16 +-
 docs-ja/pages/claude-platform-on-aws-ja.md         |   4 +-
 docs-ja/pages/claude-projects-ja.md                |  22 +-
 docs-ja/pages/code-review-local-ja.md              |   6 +-
 docs-ja/pages/commands-ja.md                       |   4 +-
 docs-ja/pages/computer-use-ja.md                   |  12 +-
 docs-ja/pages/cross-session-messaging-ja.md        |   4 +
 docs-ja/pages/desktop-ja.md                        | 132 ++--
 docs-ja/pages/desktop-scheduled-tasks-ja.md        |   4 +-
 docs-ja/pages/env-vars-ja.md                       |   2 +
 docs-ja/pages/errors-ja.md                         | 661 +++++++++++----------
 docs-ja/pages/fast-mode-ja.md                      |   4 +-
 docs-ja/pages/google-vertex-ai-ja.md               |   4 +-
 docs-ja/pages/headless-ja.md                       |   7 +-
 docs-ja/pages/hooks-ja.md                          |  14 +-
 docs-ja/pages/interactive-mode-ja.md               |   6 +-
 docs-ja/pages/large-codebases-ja.md                |   6 +-
 docs-ja/pages/llm-gateway-connect-ja.md            |   2 -
 docs-ja/pages/mcp-ja.md                            |  10 +-
 docs-ja/pages/memory-ja.md                         |   4 +-
 docs-ja/pages/model-config-ja.md                   |  10 +-
 docs-ja/pages/monitoring-usage-ja.md               |  14 +-
 docs-ja/pages/output-styles-ja.md                  |   2 +-
 docs-ja/pages/permission-modes-ja.md               |  69 ++-
 docs-ja/pages/permissions-ja.md                    |  48 +-
 docs-ja/pages/remote-control-ja.md                 |   4 +-
 docs-ja/pages/routines-ja.md                       |  14 +-
 docs-ja/pages/sandboxing-ja.md                     |   3 +-
 .../self-hosted-environments-configuration-ja.md   |   2 +-
 docs-ja/pages/server-managed-settings-ja.md        |   8 +-
 docs-ja/pages/sessions-ja.md                       |   2 +-
 docs-ja/pages/settings-ja.md                       |   2 +-
 docs-ja/pages/settings-reference-ja.md             | 329 +++++-----
 docs-ja/pages/skills-ja.md                         |  10 +-
 docs-ja/pages/sub-agents-ja.md                     |  13 +-
 docs-ja/pages/terminal-config-ja.md                |   2 +-
 docs-ja/pages/ultrareview-ja.md                    |   8 +-
 docs-ja/pages/web-quickstart-ja.md                 |   2 +-
 docs-ja/pages/workflows-ja.md                      |  12 +-
 docs-ja/pages/worktrees-ja.md                      |  30 +-
 49 files changed, 898 insertions(+), 719 deletions(-)
```

<details>
<summary>accessibility-ja.md</summary>

```diff
diff --git a/docs-ja/pages/accessibility-ja.md b/docs-ja/pages/accessibility-ja.md
index 68bf9f7..5e0d246 100644
--- a/docs-ja/pages/accessibility-ja.md
+++ b/docs-ja/pages/accessibility-ja.md
@@ -80,7 +80,5 @@ Claude Code は起動時に [確認行](#turn-on-screen-reader-mode) を印刷
 | `Cost:` | Claude Code が終了するときのセッションコスト概要（アカウントが [コストを表示](https://code.claude.com/docs/ja/costs.md) している場合） |
 
-Claude Code はターミナルカーソルを入力キャレットに保つため、スクリーンリーダーの現在の行を読むコマンドは、編集しているプロンプトを読み込みます。
-
-入力行の末尾に入力するとき、または `Backspace` を押すと、Claude Code は変更された文字のみを書き込みます。スクリーンリーダーはそれらの文字のみをエコーします。
+Claude Code はターミナルカーソルを入力キャレットに保つため、スクリーンリーダーの現在の行を読むコマンドは、編集しているプロンプトを読み込みます。入力行の末尾で入力するとき、またはそこで `Backspace` を押すとき、Claude Code は変更された文字のみを書き込みます。スクリーンリーダーはそれらの文字のみをエコーします。
 
 [テキスト編集ショートカット](https://code.claude.com/docs/ja/interactive-mode.md#text-editing) の 1 つで単語または行を削除すると、Claude Code は削除されたテキストを発表します：
```

</details>

<details>
<summary>admin-setup-ja.md</summary>

```diff
diff --git a/docs-ja/pages/admin-setup-ja.md b/docs-ja/pages/admin-setup-ja.md
index b63e797..ce2c6f9 100644
--- a/docs-ja/pages/admin-setup-ja.md
+++ b/docs-ja/pages/admin-setup-ja.md
@@ -192,4 +192,5 @@ Team、Enterprise、Claude API、およびクラウドプロバイダープラ
 * [All settings](https://code.claude.com/docs/ja/settings-reference.md): すべての設定キー、ファイルの場所、および例
 * [Which value Claude Code uses](https://code.claude.com/docs/ja/settings.md#which-value-claude-code-uses): マネージド、プロジェクト、ローカル、およびユーザー設定全体の優先度ルール
+* [Manage plugins for your organization](https://code.claude.com/docs/ja/plugins/org.md): 管理設定を通じて、すべてのマシンに共有プラグインをインストールする
 * [Monorepos and large repos](https://code.claude.com/docs/ja/large-codebases.md): 大規模リポジトリをデプロイする組織向けのディレクトリごとの設定パターン
 * [Amazon Bedrock](https://code.claude.com/docs/ja/amazon-bedrock.md)、[Google Cloud's Agent Platform](https://code.claude.com/docs/ja/google-vertex-ai.md)、[Microsoft Foundry](https://code.claude.com/docs/ja/microsoft-foundry.md): プロバイダー固有のデプロイメント
```

</details>

<details>
<summary>agent-view-ja.md</summary>

```diff
diff --git a/docs-ja/pages/agent-view-ja.md b/docs-ja/pages/agent-view-ja.md
index d2bdbac..9ca98d7 100644
--- a/docs-ja/pages/agent-view-ja.md
+++ b/docs-ja/pages/agent-view-ja.md
@@ -321,5 +321,5 @@ Claude Code がセッションをバックグラウンドにすると（約 10 
 #### 過去のセッションを戻す
 
-Claude Code v2.1.212 以降でセッションを戻すには、[ディスパッチ入力](#dispatch-an-agent-from-agent-view) に `/resume` と入力します。ピッカーが開き、エージェントビューを開いたリポジトリの過去のセッションが新しい順に表示されます。リストから削除したセッションも含まれます。既に行があるセッションは表示されません。`Enter` を押すと、選択したセッションがバックグラウンドセッションとして再開され、行としてリストに戻ります。
+セッションを戻すには、[ディスパッチ入力](#dispatch-an-agent-from-agent-view) に `/resume` と入力します。ピッカーが開き、エージェントビューを開いたリポジトリの過去のセッションが新しい順に表示されます。リストから削除したセッションも含まれます。既に行があるセッションは表示されません。`Enter` を押すと、選択したセッションがバックグラウンドセッションとして再開され、行としてリストに戻ります。
 
 次の場合、`/resume` は `isn't available in agent view` で失敗します：
@@ -411,5 +411,5 @@ Claude Code v2.1.212 以降でセッションを戻すには、[ディスパッ
 * `/model`、`/effort`、`/fast` は、[次にディスパッチするセッションの開始時の設定](#set-the-model-effort-and-fast-mode) を指定します。`/effort` と `/fast` には Claude Code v2.1.299 以降が必要です。
 * `/login` はサインインダイアログを開き、セッションにアタッチせずに再度サインインできます
-* 引数なしの `/resume`、またはそのエイリアス `/continue` は、リポジトリの過去のセッションのピッカーを開き、1 つをバックグラウンドセッションとして [復帰させます](#bring-back-a-past-session)。Claude Code v2.1.212 以降が必要です
+* 引数なしの `/resume`、またはそのエイリアス `/continue` は、リポジトリの過去のセッションのピッカーを開き、1 つをバックグラウンドセッションとして [復帰させます](#bring-back-a-past-session)
 
 スキル、独自のコマンド、および `/init` などのプロンプトを展開する組み込みコマンドは、新しいバックグラウンドセッションの最初のプロンプトとして送信されます。`isn't available in agent view` というヒントは、入力した組み込みコマンドが実行されなかったことを意味します。実行するには、[セッションにアタッチ](#attach-to-a-session) してそこで入力してください。入力した内容はすべてヒントの横の入力に残るため、編集できます。
@@ -455,8 +455,12 @@ Claude Code v2.1.212 以降でセッションを戻すには、[ディスパッ
 [エージェントビューがオフになっている](#turn-off-agent-view) 場合、`/fork` はセッションをコピーする代わりに [フォークされたサブエージェント](https://code.claude.com/docs/ja/sub-agents.md#fork-the-current-conversation) を開始します。
 
+##### コピーにプロンプトを送信してそのセッションを開く
+
 `/fork open a draft pull request with the work so far` のようにプロンプトを渡すと、コピーはすぐにその作業を開始します。プロンプトがない場合、コピーは最初の指示を待ちます。`claude agents` でその行を選択して `Space` を押して指示を送信するか、`claude attach <id>` を実行します。待機中、選択された行には `space to send it a prompt` が表示されます。
 
 `/fork` の確認は 1 行で、コピーの状態（`session running` など）、エージェントビューの行の名前、および `claude attach` 用のセッション ID を表示します。名前をクリックするとコピーに切り替わります。`←` を押した場合と同様にこのセッションはバックグラウンドに移動し、エージェントビューがコピーのセッションを開きます。
 
+##### コピーが実行される場所
+
 コピーが [その場で編集する](#how-file-edits-are-isolated) 場合を除き、Claude Code はコード変更を行う前に独自の worktree を作成するようコピーに指示します。git リポジトリの外では、フックが作成した worktree から移動したコピーのみがこの指示を受けます。[`WorktreeCreate` フック](https://code.claude.com/docs/ja/hooks#worktreecreate) がない場合、コピーはその場で編集します。元のセッションの worktree から移動したコピーには、分離設定に関係なく、その worktree を編集したり、そこでコマンドを実行したり、そこに入ったりしないようにも指示されます。
```

</details>

<details>
<summary>agents-ja.md</summary>

```diff
diff --git a/docs-ja/pages/agents-ja.md b/docs-ja/pages/agents-ja.md
index c5a6431..afa7188 100644
--- a/docs-ja/pages/agents-ja.md
+++ b/docs-ja/pages/agents-ja.md
@@ -33,5 +33,5 @@ Claude Code には、複数のタスクを同時に処理する 5 つの方法
 > [!NOTE]
 >
-> 複数のセッションまたはサブエージェントを同時に実行すると、トークン使用量が増加します。使用量とレート制限の詳細については、[コスト](https://code.claude.com/docs/ja/costs.md) を参照してください。
+> 複数のセッションやサブエージェントを同時に実行すると、トークン使用量が倍増します。使用量とレート制限の詳細については、[コスト](https://code.claude.com/docs/ja/costs.md)を参照してください。
 
 ## アプローチを選択する
```

</details>

<details>
<summary>amazon-bedrock-ja.md</summary>

```diff
diff --git a/docs-ja/pages/amazon-bedrock-ja.md b/docs-ja/pages/amazon-bedrock-ja.md
index 666f3c9..3b47cb2 100644
--- a/docs-ja/pages/amazon-bedrock-ja.md
+++ b/docs-ja/pages/amazon-bedrock-ja.md
@@ -252,4 +252,6 @@ export ANTHROPIC_DEFAULT_HAIKU_MODEL='us.anthropic.claude-haiku-4-5-20251001-v1:
 | 小型/高速モデル | Sonnet 4.5、例えば `us-*` リージョンの `us.anthropic.claude-sonnet-4-5-20250929-v1:0` |
 
+v2.1.280 より前では、Amazon Bedrock のプライマリモデルは Opus 5 にデフォルト設定され、`opus` エイリアスは v2.1.219 から Opus 5 に解決されました。
+
 セッションタイトル生成などのバックグラウンドタスクは、小型/高速モデル（通常は Haiku クラスモデル）を使用します。Amazon Bedrock では、すべてのアカウントまたはリージョンで Haiku が有効になっていない可能性があるため、Claude Code はバックグラウンドタスクにデフォルト Sonnet モデルを使用します。2 つの選択がどのモデルがそれらを実行するかを変更します。
 
@@ -261,6 +263,4 @@ export ANTHROPIC_DEFAULT_HAIKU_MODEL='us.anthropic.claude-haiku-4-5-20251001-v1:
 > Opus モデルは Sonnet モデルよりトークンあたりの価格が高いため、プライマリモデルをピンしない場合は Opus のレートで請求されます。Sonnet 4.5 をプライマリモデルとして使用するには、`ANTHROPIC_MODEL` をその完全なモデル ID に設定してください。`ANTHROPIC_DEFAULT_SONNET_MODEL` でデフォルトを指定し、`ANTHROPIC_DEFAULT_OPUS_MODEL` を設定していないデプロイでは、指定した Sonnet モデルがデフォルトとして維持されます。
 
-v2.1.280 より前では、Amazon Bedrock のプライマリモデルは Opus 5 にデフォルト設定され、`opus` エイリアスは v2.1.219 から Opus 5 に解決されました。v2.1.207 から v2.1.218 では、Amazon Bedrock のプライマリモデルは Opus 4.8 にデフォルト設定され、`opus` エイリアスは Opus 4.8 に解決されました。
-
 モデルをさらにカスタマイズするには、以下のいずれかの方法を使用してください。
 
```

</details>

<details>
<summary>artifacts-ja.md</summary>

```diff
diff --git a/docs-ja/pages/artifacts-ja.md b/docs-ja/pages/artifacts-ja.md
index 2ffbccb..3f2c5bd 100644
--- a/docs-ja/pages/artifacts-ja.md
+++ b/docs-ja/pages/artifacts-ja.md
@@ -96,5 +96,5 @@ Claude Code で `/artifacts` を実行すると、所有しているアーティ
 アーティファクトを選択し、次のいずれかのキーを押します。
 
-* **`Enter`**：現在のセッションにすでに添付されている場合はブラウザで開き、添付されていない場合は添付します。v2.1.216 より前のバージョンでは、`Enter` キーでブラウザで開きました
+* **`Enter`**：現在のセッションにすでに添付されている場合はブラウザで開き、添付されていない場合は添付します
 * **`o`**：ブラウザで開きます
 * **`c`**：リンクをコピーします
@@ -196,9 +196,9 @@ Claude Code が自動で開始した監視は、アーティファクトで数
 コメントを配信するサービスが利用できなくなるか、応答を停止した場合、Claude Code はしばらく再接続を試み、その後、セッションが監視していた各アーティファクトの監視を停止します。
 
-## MCP コネクタで ライブデータを取得する
+## MCP コネクタでライブデータを取得する
 
-アーティファクトは、誰かがそれを表示するたびに [MCP コネクタ](https://code.claude.com/docs/ja/mcp.md#use-mcp-servers-from-claude-ai) を呼び出すことができるため、ページはセッションから取得したスナップショットではなく、現在のデータを表示します。アーティファクトからのコネクタ呼び出しは Pro、Max、Team、Enterprise プランで利用可能であり、Claude Code v2.1.209 以降が必要です。以前のバージョンでは、Claude はセッション中に収集したデータでページを公開します。
+アーティファクトは、誰かが閲覧するたびに [MCP コネクタ](https://code.claude.com/docs/ja/mcp.md#use-mcp-servers-from-claude-ai)を呼び出せます。そのため、ページにはそれを作成したセッション時点のスナップショットではなく、最新のデータが表示されます。アーティファクトからのコネクタ呼び出しは Pro、Max、Team、Enterprise プランで利用でき、Claude Code v2.1.209 以降が必要です。それより前のバージョンでは、Claude はページの作成中にセッションが収集したデータをそのまま使ってページを公開します。
 
-コネクタバックアップページを作成するには、プロンプトでコネクタと必要なデータを指定します。
+コネクタを利用するページを作成するには、プロンプトでコネクタと必要なデータを指定します。
 
 ```text wrap theme={null}
@@ -206,30 +206,30 @@ Build a dashboard artifact of our open pull requests that pulls the live list th
 ```
 
-Claude はページの公開の一部として、ページが呼び出す可能性のあるコネクタを宣言し、ページはその宣言の外側のコネクタを呼び出すことはできません。claude.ai アカウントからのコネクタのみが対象となります。Claude はそれらを宣言で指定し、ページを表示するときに、各呼び出しは [表示アカウント独自の接続を通じて実行されます](#how-connector-calls-work-for-viewers)。`.mcp.json` など Claude Code で設定するローカル MCP サーバーは、Claude がページを構築している間にデータを提供できますが、公開されたページはそれらを呼び出すことはできません。
+Claude は公開処理の一環として、ページが呼び出せるコネクタを宣言します。ページはその宣言に含まれないコネクタを呼び出せません。対象となるのは claude.ai アカウントのコネクタのみです。Claude が宣言でそれらを指定し、誰かがページを閲覧すると、各呼び出しはそのコネクタに対する[閲覧しているアカウント自身の接続を通じて実行されます](#how-connector-calls-work-for-viewers)。`.mcp.json` のサーバーなど、Claude Code で設定したローカルの MCP サーバーは、Claude がページを作成する間はデータを提供できますが、公開されたページからは呼び出せません。
 
```

</details>

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index 5c0dce0..6430cae 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,46 @@
 # Changelog
 
+## 2.1.312
+
+- Added `oidc.user_id_claim` to the Claude apps gateway, to identify people by an id_token claim other than `sub`, such as Microsoft Entra ID's `oid`
+- Added click to send: in fullscreen, clicking the "to send now" hint under a queued message sends it right away, as its key does
+- Fixed managed settings and organization policy not being fetched for the rest of the session after signing in from the VS Code extension
+- Fixed Claude overwriting a very large CLAUDE.md, rules file or @-included file in a subdirectory after seeing only its start; Write now asks Claude to read it all or edit in place
+- Fixed per-directory and `paths:` skills not being found after a Bash `cd` deeper into a git repository
+- Fixed a rare case where the first reply after resuming a session in the terminal could be missing the next time the session was resumed
+- Fixed a command with an invalid name stopping all commands from loading, which could leave `claude -p` with no output
+- Fixed the Read tool sometimes failing on PDF pages with "pdftoppm failed: Could not write image" when the clean-up of old session files ran at the same time
+- Fixed the spinner, OpenTelemetry `effort` values and transcripts naming a newly picked effort level during a task before the model applied it; they now show the level in force
+- Fixed the `/model` and `/effort` cache warning saying the re-read waits for your next message; a change made while Claude is working can trigger it sooner
+- Fixed some sessions showing as waiting on you when the last message only mentioned items waiting on you mid-sentence
+- Fixed agent view restoring input text on the next launch after it was cleared with Ctrl+C just before exiting
+- Fixed agent view reopening in shell mode after exiting with Ctrl+D from an empty `!` input
+- Fixed vim mode `d`, `c` and `y` with a `gj` or `gk` count larger than the lines left deleting or copying text; like Vim, they now only move the cursor
+- Fixed `/verify` showing a long description meant for Claude in `/help` and the `/` command menu instead of a short one
+- Improved the prompt's effort indicator: a change made mid-task now says it may wait for your next message, and the note clears when it no longer applies
+- Improved WebFetch errors in cloud sessions: a host that does not resolve is now explained as possibly outside the allowed network domains, so Claude names the host to allow
+- Changed Bedrock, Vertex, Foundry and Mantle to use the shorter system prompt for model names Claude Code doesn't recognize, such as custom deployment names and inference profile ARNs, even when they front Sonnet or Haiku; set `CLAUDE_CODE_SIMPLE_SYSTEM_PROMPT=0` to keep the full prompt
+- Changed automatic model switches after a flagged message to also cover model names Claude Code doesn't recognize, such as custom deployment names; set `CLAUDE_CODE_DISABLE_REFUSAL_FALLBACK=1` to turn them off
+- Changed usage limit messages to call the 5-hour window the "5-hour limit" instead of the "session limit"
+- Changed cloud sessions started from the CLI to get their names and branch names from the server
```

</details>

<details>
<summary>chrome-ja.md</summary>

```diff
diff --git a/docs-ja/pages/chrome-ja.md b/docs-ja/pages/chrome-ja.md
index 13e3b50..46d4883 100644
--- a/docs-ja/pages/chrome-ja.md
+++ b/docs-ja/pages/chrome-ja.md
@@ -44,5 +44,5 @@ Claude Code を Chrome で使用する前に、以下が必要です。
 HIPAA が有効になっている Enterprise 組織では、Claude in Chrome はデフォルトでオフになっており、[Owner](https://code.claude.com/docs/ja/server-managed-settings.md#access-control) が [**Organization settings > Claude in Chrome**](https://claude.ai/admin-settings/browser-extension) でオンにできます。Anthropic との事業提携契約（BAA）は、Claude in Chrome を通じてサードパーティのサイトに送信されるデータを対象としていません。対象サービス（Eligible Services）の一覧については、[実装ガイド](https://trust.anthropic.com/resources?s=l1wrssd9hsbi4gak0tp5a6\&name=%5Banthropic%5D-hipaa-ready-offering-implementation-guide)を参照してください。
 
-Chrome 統合を使用するには、`/login` でサインインする必要もあります。API キーまたは [`claude setup-token`](https://code.claude.com/docs/ja/authentication#generate-a-long-lived-token) で発行した長期間有効なトークンで認証している場合、ブラウザ拡張機能はこれらの認証情報では認証できないため、`--chrome` を渡しても Claude Code は Chrome 統合を無効のままにします。v2.1.216 より前のバージョンでは、これらのセッションでも Chrome 統合を有効にできましたが、ブラウザ拡張機能への接続はすべて 403 エラーで失敗していました。
+Chrome 統合を使用するには、`/login` でサインインする必要もあります。API キーまたは [`claude setup-token`](https://code.claude.com/docs/ja/authentication#generate-a-long-lived-token) で発行した長期間有効なトークンで認証している場合、`--chrome` を渡しても Claude Code は Chrome 統合を無効のままにします。ブラウザ拡張機能はこれらの認証情報では認証できません。
 
 > [!NOTE]
```

</details>

<details>
<summary>claude-apps-gateway-config-ja.md</summary>

```diff
diff --git a/docs-ja/pages/claude-apps-gateway-config-ja.md b/docs-ja/pages/claude-apps-gateway-config-ja.md
index 897d786..8d558aa 100644
--- a/docs-ja/pages/claude-apps-gateway-config-ja.md
+++ b/docs-ja/pages/claude-apps-gateway-config-ja.md
@@ -995,7 +995,5 @@ managed:
 承認がどのくらい持続し、いつダイアログが再表示されるかについては [承認の記憶](https://code.claude.com/docs/ja/server-managed-settings.md#approval-memory) を参照してください。
 
-Claude Code は、モデル選択設定や数値制限など、配信された `env` 変数の一部をデベロッパーに承認ダイアログを表示せずに適用します。その他の配信変数は、有効になる前にデベロッパーの承認が必要な場合があります。空でないプロキシ、ベース URL、または `OTEL_EXPORTER_OTLP_ENDPOINT` の値は常に承認が必要です。配信変数に承認が必要な場合、ダイアログにはその変数名が表示されます。
-
-詳細は [環境変数と承認ダイアログ](https://code.claude.com/docs/ja/server-managed-settings.md#environment-variables-and-the-approval-dialog) を参照してください。配信値によって承認が必要かどうかが決まる 4 つのプライバシートグルについても記載されています。v2.1.218 より前では、Claude Code がデベロッパーに確認せずに適用する変数が少なかったため、より多くの配信変数でダイアログが表示されていました。
+Claude Code は、モデル選択の設定や数値の上限など、配信された一部の `env` 変数を、開発者に承認ダイアログを表示せずに適用します。配信されたその他の変数は開発者の承認を必要とする場合があり、空でないプロキシ、ベース URL、または `OTEL_EXPORTER_OTLP_ENDPOINT` の値は常に承認が必要です。配信された変数に承認が必要な場合、ダイアログにその変数名が表示されます。詳細は[環境変数と承認ダイアログ](https://code.claude.com/docs/ja/server-managed-settings.md#environment-variables-and-the-approval-dialog)を参照してください。配信された値によって承認が必要かどうかが決まる 4 つのプライバシー切り替えについても記載されています。
 
 ゲートウェイの [テレメトリ](#telemetry) 設定は `OTEL_EXPORTER_OTLP_ENDPOINT` をプッシュするため、`telemetry.forward_to` を設定すると各インタラクティブクライアントでダイアログが表示されます。このダイアログは、侵害されたゲートウェイや悪意のあるゲートウェイからデベロッパーのマシンを保護するものであり、デベロッパーから組織を保護するものではありません。
```

</details>

*...以降省略*

</details>


<details>
<summary>2026-10-27</summary>

**変更ファイル:**

```
 docs-ja/pages/admin-setup-ja.md                    |   2 +-
 docs-ja/pages/agent-teams-ja.md                    |   2 +-
 docs-ja/pages/agent-view-ja.md                     |  27 +-
 docs-ja/pages/best-practices-ja.md                 | 776 +++++++++++----------
 docs-ja/pages/changelog.md                         |  95 +++
 docs-ja/pages/claude-apps-gateway-config-ja.md     |  13 +-
 docs-ja/pages/claude-apps-gateway-deploy-ja.md     |   1 +
 docs-ja/pages/claude-code-on-the-web-ja.md         |  22 +
 docs-ja/pages/claude-directory-ja.md               |  11 +-
 docs-ja/pages/claude-security-ja.md                |  22 +-
 docs-ja/pages/commands-ja.md                       |   2 +-
 docs-ja/pages/context-window-ja.md                 |   2 +-
 docs-ja/pages/desktop-ja.md                        |  79 ++-
 docs-ja/pages/env-vars-ja.md                       |   4 +-
 docs-ja/pages/errors-ja.md                         | 726 ++++++++++---------
 docs-ja/pages/features-overview-ja.md              |   2 +-
 docs-ja/pages/glossary-ja.md                       |   2 +-
 docs-ja/pages/hooks-guide-ja.md                    | 198 +++---
 docs-ja/pages/hooks-ja.md                          |   2 +-
 docs-ja/pages/how-claude-code-works-ja.md          |   2 +-
 docs-ja/pages/interactive-mode-ja.md               |   2 +-
 docs-ja/pages/large-codebases-ja.md                |   4 +-
 docs-ja/pages/managed-settings-ja.md               |   2 +-
 docs-ja/pages/mcp-ja.md                            |  11 +-
 docs-ja/pages/model-config-ja.md                   |  15 +-
 docs-ja/pages/permission-modes-ja.md               |  92 ++-
 docs-ja/pages/sandboxing-ja.md                     |   2 +-
 .../self-hosted-environments-configuration-ja.md   |   2 +-
 .../pages/self-hosted-environments-deploy-ja.md    |  67 +-
 .../pages/self-hosted-environments-reference-ja.md |  30 +-
 docs-ja/pages/server-managed-settings-ja.md        |   4 +-
 docs-ja/pages/sessions-ja.md                       |   4 +-
 docs-ja/pages/settings-reference-ja.md             | 191 ++---
 docs-ja/pages/skills-ja.md                         |   2 +-
 docs-ja/pages/vs-code-ja.md                        |  53 +-
 docs-ja/pages/web-quickstart-ja.md                 |   2 +-
 docs-ja/pages/workflows-ja.md                      |  11 +-
 37 files changed, 1483 insertions(+), 1001 deletions(-)
```

<details>
<summary>admin-setup-ja.md</summary>

```diff
diff --git a/docs-ja/pages/admin-setup-ja.md b/docs-ja/pages/admin-setup-ja.md
index 6d41fed..b63e797 100644
--- a/docs-ja/pages/admin-setup-ja.md
+++ b/docs-ja/pages/admin-setup-ja.md
@@ -94,5 +94,5 @@ WSL 2 ユーティリティ VM 内のプロセスは、Windows 側のエンド
 | [管理ポリシーの CLAUDE.md](https://code.claude.com/docs/ja/memory.md#deploy-organization-wide-claude-md) | クライアントで強制されるルールではなく、組織全体で Claude に与える動作のガイダンス | 管理ポリシーのパスに置くファイル |
 | [MCP サーバーの制御](https://code.claude.com/docs/ja/managed-mcp.md) | ユーザーが追加または接続できる MCP サーバーを制限したり、固定のセットをデプロイしたり、各ユーザー自身のサーバーに加えてリモートサーバーを全ユーザーに提供したりします | `allowedMcpServers`、`deniedMcpServers`、`allowManagedMcpServersOnly`、`managedMcpServers`、またはデプロイされた `managed-mcp.json` ファイル |
-| [プラグインマーケットプレイスの制御](https://code.claude.com/docs/ja/plugins/org.md#restrict-what-users-can-install) | ユーザーが追加およびインストールできるマーケットプレイスソースを制限し、単一の実行のためにプラグイン、エージェント、MCP サーバーをサイドロードする CLI フラグを拒否し、[`command` プラグインソース](https://code.claude.com/docs/ja/plugins/marketplace-reference#command-plugin-source)をブロックし、どのマーケットプレイスのプラグインを提案できるかを許可リストで指定します | `strictKnownMarketplaces`、`blockedMarketplaces`、`disableSideloadFlags`、`disableCommandPluginSources`、`pluginSuggestionMarketplaces` |
+| [プラグインマーケットプレイスの制御](https://code.claude.com/docs/ja/plugins/org.md#restrict-what-users-can-install) | ユーザーが追加およびインストールできるマーケットプレイスソースを制限し、単一の実行のためにプラグイン、エージェント、MCP サーバーをサイドロードする CLI フラグを拒否します。[`command` プラグインソース](https://code.claude.com/docs/ja/plugins/marketplace-reference#command-plugin-source)をブロックし、ターミナルでどのマーケットプレイスのプラグインを提案できるかを許可リストで指定します | `strictKnownMarketplaces`、`blockedMarketplaces`、`disableSideloadFlags`、`disableCommandPluginSources`、`pluginSuggestionMarketplaces` |
 | [カスタマイズのロックダウン](https://code.claude.com/docs/ja/settings-reference.md#strictpluginonlycustomization) | ユーザーおよびプロジェクトのソースからのスキル、エージェント、フック、MCP サーバーをブロックし、プラグインまたは管理設定からのみ提供されるようにします。スキルをロックすると、[開発者が claude.ai で有効にしたスキル](https://code.claude.com/docs/ja/skills.md#where-synced-skills-load)の同期も停止します | `strictPluginOnlyCustomization` |
 | [claude.ai 同期の無効化](https://code.claude.com/docs/ja/settings-reference.md#syncclaudeaiskills) | 開発者が claude.ai で有効にした[スキル](https://code.claude.com/docs/ja/skills.md#how-synced-skills-behave)と[プラグイン](https://code.claude.com/docs/ja/plugins/loading.md#synced-plugins)を Claude Code が読み込まないようにします。claude.ai で組織の Skills をオフにすると、Claude Code は両方の同期を停止し、v2.1.273 以降では同期済みのものも削除します。Skills をオフにせずにいずれかを停止するには、管理設定でそのキーを `false` に設定します | `syncClaudeAiSkills`、`syncClaudeAiPlugins` |
```

</details>

<details>
<summary>agent-teams-ja.md</summary>

```diff
diff --git a/docs-ja/pages/agent-teams-ja.md b/docs-ja/pages/agent-teams-ja.md
index e318c9a..0883838 100644
--- a/docs-ja/pages/agent-teams-ja.md
+++ b/docs-ja/pages/agent-teams-ja.md
@@ -189,5 +189,5 @@ In-process チームメイトを表示している間、プレーンテキスト
 ### タスクを割り当てて要求する
 
-共有タスクリストはチーム全体の作業を調整します。リーダーがタスクを作成し、チームメンバーがそれらを処理します。タスクには 3 つの状態があります。保留中、進行中、完了。タスクは他のタスクに依存することもできます。未解決の依存関係を持つ保留中のタスクは、それらの依存関係が完了するまで要求できません。
+共有タスクリストはチーム全体の作業を調整します。リーダーがタスクを作成し、チームメンバーがそれらを処理します。タスクには 3 つの状態があります。保留中、進行中、完了。タスクは他のタスクに依存することもでき、その場合は依存先のタスクが完了するまでタスクリストでブロック中として表示されます。チームメンバーはブロックされたタスクを自己要求しませんが、ユーザーまたはリーダーは引き続きそのタスクを割り当てることができます。
 
 [Task ツールを持たない](https://code.claude.com/docs/ja/tools-reference.md#task-tool-availability)エージェントは、共有タスクリストの代わりにメッセージを通じて調整します。
```

</details>

<details>
<summary>agent-view-ja.md</summary>

```diff
diff --git a/docs-ja/pages/agent-view-ja.md b/docs-ja/pages/agent-view-ja.md
index 5a8458c..d2bdbac 100644
--- a/docs-ja/pages/agent-view-ja.md
+++ b/docs-ja/pages/agent-view-ja.md
@@ -207,5 +207,8 @@ Completed
 * 作業中のセッション：その完全なステータス文
 
-次に、セッションにリンクされたプルリクエストがリストされます。ユーザーを待っているセッションの場合、その下に `waiting 3m` のような行が表示されて待機時間を示し、これがパネルに表示される唯一の時間です。行の右端の経過時間は別の数字で、セッションが開始されてからカウントされます。
+次に、セッションにリンクされたプルリクエストがリストされます。ユーザーを待っているセッション、またはセーフモードで実行されているセッションでは、その下にもう 1 行表示されます：
+
+* `waiting 3m` のような行：セッションがユーザーを待っている時間。行の右端の経過時間は別の数字で、セッションが開始されてからカウントされます
+* `safe mode · customizations are off`：シェルから `claude --bg --safe-mode` で開始したため、このセッションは [カスタマイズをオフにした状態](https://code.claude.com/docs/ja/debug-your-config.md#test-against-a-clean-configuration) で実行されています。そのままにしておいてもかまいません。カスタマイズをオンに戻して会話を続けるには、シェルで [`claude stop <id>`](#manage-sessions-from-the-shell) を実行してから [`claude --resume`](https://code.claude.com/docs/ja/sessions#resume-a-session) を実行します
 
 ほとんどの場合、ピークパネルで十分であり、完全なトランスクリプトを開く必要はありません。
@@ -469,9 +472,9 @@ Claude Code v2.1.212 以降でセッションを戻すには、[ディスパッ
 #### バックグラウンドに移動するときに引き継がれるもの
 
-バックグラウンドへの移動では、保存された会話から再開する新しいプロセスが開始され、進行中のバックグラウンド作業はそのプロセスに移動します。実行中のバックグラウンドシェルコマンド、バックグラウンド化されたサブエージェント、動的ワークフロー、[`/loop`](https://code.claude.com/docs/ja/scheduled-tasks) で作成したスケジュールタスク、および Claude の [アーティファクトコメントへの自動返信](https://code.claude.com/docs/ja/artifacts.md#let-claude-reply-to-comments-on-its-own) はすべて引き継がれ、そこで実行を続けます。サブエージェントは自身が開始したすべてのものと一緒に移動するため、その作業のすべてが移動できる場合にのみ引き継がれます。
-
-[動的ワークフロー](https://code.claude.com/docs/ja/workflows.md) でまだサブエージェントが実行中の場合、Claude Code はバックグラウンドに移動する前に `Background this session?` ダイアログで確認を求め、再起動されるサブエージェントの数を示します。先に完了させるには `Stay` を選択します。確認すると、Claude Code はバックグラウンドセッションで実行を再生します。まだ実行中だったサブエージェントは最初からやり直されるため、それまでに使用したトークンは再度消費されます。完了したサブエージェントのうち、保存された結果を返すものと再実行されるものについては、[一時停止後の再開](https://code.claude.com/docs/ja/workflows.md#resume-after-a-pause) を参照してください。
+セッションをバックグラウンドに移動すると、進行中のバックグラウンド作業は種類ごとに、バックグラウンドセッションに引き継がれるか、Claude がそこで再起動した場合にのみ続行されるか、停止するかのいずれかになります。
 
-Claude Code は、実行中の [モニター](https://code.claude.com/docs/ja/tools-reference.md#monitor-tool) など引き継げないバックグラウンド作業を停止し、モニターを所有するバックグラウンド化されたサブエージェントも一緒に停止します。そのような作業が実行中の場合、Claude Code は `Background this session?` ダイアログを表示し、作業を停止する前に確認できるようにします。
+* **引き継がれるもの**: 実行中のバックグラウンドシェルコマンド、バックグラウンド化されたサブエージェント、[`/loop`](https://code.claude.com/docs/ja/scheduled-tasks) で作成したスケジュールタスク、および Claude の [アーティファクトコメントへの自動返信](https://code.claude.com/docs/ja/artifacts.md#let-claude-reply-to-comments-on-its-own) は、バックグラウンドセッションで実行を続けます。サブエージェントは自身が開始したすべてのものと一緒に移動するため、その作業のすべてが移動できる場合にのみ引き継がれます。
+* **Claude が再起動した場合にのみ続行されるもの**: 実行中の [動的ワークフロー](https://code.claude.com/docs/ja/workflows.md)。バックグラウンドセッションを確認したときにワークフローが続行されていない場合は、[Claude に再起動を依頼してください](#dynamic-workflows-when-you-background)。
+* **停止するもの**: 実行中の [モニター](https://code.claude.com/docs/ja/tools-reference.md#monitor-tool) など、バックグラウンドセッションに移動できない作業。そのような作業が実行中の場合、Claude Code は `Background this session?` ダイアログを表示し、作業を停止する前に確認できるようにします。モニターを所有するバックグラウンド化されたサブエージェントは、モニターと一緒に停止します。
 
 バックグラウンドに移動した後、セッションは新しいサブエージェント、モニター、バックグラウンドコマンドを開始でき、それらはその後のデタッチや再アタッチをまたいで実行を続けます。
@@ -489,4 +492,10 @@ Claude Code は、実行中の [モニター](https://code.claude.com/docs/ja/to
 セッション中に [`/add-dir`](https://code.claude.com/docs/ja/permissions#additional-directories-grant-file-access-not-configuration) で追加したディレクトリも引き継がれます。`--allow-dangerously-skip-permissions` を引き継ぐと、バックグラウンド化されたセッションでも `bypassPermissions` に切り替えられる状態が維持されますが、新たに何かを付与するわけではありません。このモードには引き続き、[バイパスの免責事項への同意](https://code.claude.com/docs/ja/permission-modes.md#skip-all-checks-with-bypasspermissions-mode) が記録されている必要があります。
```

</details>

<details>
<summary>best-practices-ja.md</summary>

```diff
diff --git a/docs-ja/pages/best-practices-ja.md b/docs-ja/pages/best-practices-ja.md
index 8edd680..b3251e5 100644
--- a/docs-ja/pages/best-practices-ja.md
+++ b/docs-ja/pages/best-practices-ja.md
@@ -5,574 +5,630 @@
 # Claude Code のベストプラクティス
 
-> 環境設定から並列セッションでのスケーリングまで、Claude Code を最大限に活用するためのヒントとパターン。
+> Claude Code をさらに活用するために、Claude に見えないことを伝え、実行できるチェックを与え、例外を許さないルールを強制します。
 
-Claude Code は agentic coding 環境です。質問に答えて待つチャットボットとは異なり、Claude Code はファイルを読み取り、コマンドを実行し、変更を加え、あなたが見守ったり、方向を変えたり、完全に任せたりしながら、自律的に問題を解決できます。
+Claude Code は、ほとんどの場合、新しいセッションで最初に送るシンプルなプロンプトだけで、ユーザー側の設定なしに正しく動作するよう作られています。
 
-これはあなたの作業方法を変えます。自分でコードを書いて Claude にレビューしてもらう代わりに、やりたいことを説明すると Claude がそれをどのように構築するかを考え出します。Claude は探索し、計画し、実装します。
+例えば：
 
-しかし、この自律性にも学習曲線があります。Claude は理解する必要がある特定の制約の中で動作します。
+* 各コマンドを逐一承認しなくても安全に実行できるよう、新しいターミナルおよび VS Code セッションは [auto モード](https://code.claude.com/docs/ja/permission-modes.md#eliminate-prompts-with-auto-mode)で開始します。このモードでは、リスクのある操作は実行前に分類器がレビューします。
+* 独立した作業を並列で進めながらメインの会話を集中した状態に保つため、Claude はサブエージェントに委譲し、必要なときだけ確認を求めます。
+* ユーザーが管理しなくても長いセッションを続けられるよう、コンテキストウィンドウがいっぱいになる前に、会話が自動でコンテキスト圧縮されます。
 
-このガイドでは、Anthropic の内部チームと、様々なコードベース、言語、環境で Claude Code を使用しているエンジニアの間で効果的であることが証明されたパターンについて説明します。agentic ループがどのように機能するかについては、[Claude Code の仕組み](https://code.claude.com/docs/ja/how-claude-code-works.md)を参照してください。
+このページでは、デフォルトだけでは不十分な場合に何をすべきかを説明します。これは通常、Claude がコードだけからは把握できない知識、ルール、制約がプロジェクトにある場合に起こります：
 
-***
+* 誰かの頭の中にしかないデプロイ手順
+* 決して読み取ってはいけないファイル
+* 何かを完了とみなす前に必ず通過しなければならないチェック
+* 超えてはならない予算
 
```

</details>

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index eab938d..5c0dce0 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,99 @@
 # Changelog
 
+## 2.1.311
+
+- Added `--hold-idle-file` and `--max-hold-min` to `self-hosted-runner`, to keep an idle session while your host reports processes it left running
+- Added a tip for the Explanatory output style, shown when you ask Claude for explanations
+- Fixed long freezes at startup and after reading or editing files when a CLAUDE.md file holds a very long list item
+- Fixed interrupting Claude not taking effect until a timeout while an MCP server had not answered a resource read or a skill was still downloading
+- Fixed standard-context sessions stopping with "Usage credits required for 1M context" when a request ran over 200K tokens; Claude Code now compacts the conversation and continues
+- Fixed Write and Edit stalling for up to 5 seconds after they ran, and reporting 0 lines changed, when changing thousands of lines in a file
+- Fixed subagents being unable to use MCP tools from servers that finish connecting after the subagent starts
+- Fixed Claude seeing stale MEMORY.md and CLAUDE.md content right after automatic compaction when those files were edited earlier in the session
+- Fixed `claude -p` and SDK sessions saving transcript messages out of order or keeping messages that were taken back
+- Fixed `SubagentStop` hooks running about twice a minute for each running subagent instead of once when it finishes
+- Fixed the @ file picker ignoring `.ignore`/`.rgignore` negation rules that re-include git-ignored files
+- Fixed a subagent's isolated worktree being removed while a background subagent it started was still working in it
+- Fixed background agents in auto mode that wait on their own shells starting a new main conversation turn on every wake
+- Fixed the Bash tool description claiming the working directory always persists between calls
+- Fixed the environment block naming a shell commands don't run in, such as fish when the Bash tool uses zsh
+- Fixed `claude mcp add`, `claude mcp remove` and `/mcp` naming the current folder instead of the project entry in `~/.claude.json` that holds a local-scope server when run below a repository root
+- Fixed `claude mcp list` and `claude mcp get` showing the error code twice on failed-connection lines (for example `ENOENT: ENOENT: …`)
+- Fixed Remote Control sessions staying on "Connecting" for about two minutes when a network proxy blocks a startup request
+- Fixed messages that Claude sends to a cloud or Remote Control session appearing as your own message in the Claude mobile apps
+- Fixed Claude not being told the cause when a file attached to a message sent over Remote Control or to a cloud session could not be saved because the disk was full, or that a message's attachments past the first 20 were left out
+- Fixed WebFetch and WebSearch hanging on a stalled response in Cowork cloud sessions; an unfinished request now fails after 300 seconds
```

</details>

<details>
<summary>claude-apps-gateway-config-ja.md</summary>

```diff
diff --git a/docs-ja/pages/claude-apps-gateway-config-ja.md b/docs-ja/pages/claude-apps-gateway-config-ja.md
index 219e90c..897d786 100644
--- a/docs-ja/pages/claude-apps-gateway-config-ja.md
+++ b/docs-ja/pages/claude-apps-gateway-config-ja.md
@@ -926,4 +926,9 @@ managed:
 切り替える際は、ブロック名を変更するのと同じ編集で、`serve_to_desktop` の行をすべて削除してください。説明で `cli` ブロックに言及している箇所では、`code` ブロックを使用してください。
 
+`serve_to_desktop: true` は、ポリシーの `cli` 設定を Code タブに提供するためのレガシーな方法です。Claude Desktop が [`bootstrapUrl`](#claude-desktop-overlay) を通じて接続する場合は効果がありません。ポリシーで `cli` を使用している間に、このキーを示す起動時の警告が表示された場合、それらの設定は Code タブに届いていません。
+
+* **Code タブを対象にするには**：ユーザーのマシンが [Code タブで `code` の設定を適用する](#apply-code-settings-in-the-code-tab)の条件を満たしたら、`code` に切り替えます
+* **`cli` のままにするには**：ポリシーで `cli` の横に `serve_to_desktop: false` を設定して、警告を抑制します
+
 #### `cli` に何を入れるか
 
@@ -973,5 +978,5 @@ managed:
 | `availableModels` | ゲートウェイ + CLI | モデル許可リスト。`/v1/messages` でもチェックされるため、パッチされたクライアントはバイパスできません。 |
 | [`deniedModels`](https://code.claude.com/docs/ja/settings-reference#deniedmodels)、[`availableModelsMatch`](https://code.claude.com/docs/ja/settings-reference#availablemodelsmatch) | ゲートウェイ + CLI | `availableModels` では本来許可される [特定のモデルやバージョンをブロック](https://code.claude.com/docs/ja/model-config.md#block-specific-models-or-versions) します。ブロックされたモデルは `/v1/messages` で `400` により拒否され、`/v1/models` から除外されます。ゲートウェイ自体のチェックには、ゲートウェイサーバー上の Claude Code v2.1.299 以降が必要です。CLI のチェックにはクライアント上の v2.1.283 以降が必要で、それより前のクライアントは両方のキーを無視します。 |
-| `permissions.allow` / `.deny` | CLI | ツールとコマンドのルール。[権限](https://code.claude.com/docs/ja/permissions.md) を参照してください。 |
+| `permissions.allow` / `.deny` | CLI | ツールとコマンドのルール。[権限](https://code.claude.com/docs/ja/permissions.md)と [Bash ルールが一致しないもの](https://code.claude.com/docs/ja/permissions.md#bash-rule-limits)を参照してください。 |
 | `permissions.disableBypassPermissionsMode` | CLI | `disable` に設定すると、[`bypassPermissions`](https://code.claude.com/docs/ja/permission-modes#skip-all-checks-with-bypasspermissions-mode)（権限プロンプトをスキップするモード）と `--dangerously-skip-permissions` フラグをブロックします |
 | `allowManagedPermissionRulesOnly` | CLI | `true` の場合、管理設定が権限ルールの唯一の設定ソースになります。[`allowManagedPermissionRulesOnly`](https://code.claude.com/docs/ja/settings-reference#allowmanagedpermissionrulesonly) エントリには、その場合に Claude Code が無視するすべてのソースがリストされています。 |
@@ -1002,4 +1007,8 @@ Claude Code は、モデル選択設定や数値制限など、配信された `
 `cli` キーは以前のリリースでは `settings` という名前で、ゲートウェイは引き続きその表記をエイリアスとして受け付けます。新しいデプロイでは [`code`](#choose-cli-or-code) を使用してください。
 
+#### デプロイ前にポリシーをテストする
+
+ポリシーの変更をテストするには、使い捨ての Postgres データベースに対してゲートウェイを起動します。ゲートウェイは、`cli`、`code`、`desktop` ブロックの内容をチェックする前に、Postgres に接続してスキーマのマイグレーションを適用します。データベースに到達できない場合、起動は `could not connect to Postgres` で停止し、それらの内容については何も報告されません。
+
 #### ターミナルセッションのコンテキストウィンドウ
 
```

</details>

<details>
<summary>claude-apps-gateway-deploy-ja.md</summary>

```diff
diff --git a/docs-ja/pages/claude-apps-gateway-deploy-ja.md b/docs-ja/pages/claude-apps-gateway-deploy-ja.md
index 3e7007d..d0ad06a 100644
--- a/docs-ja/pages/claude-apps-gateway-deploy-ja.md
+++ b/docs-ja/pages/claude-apps-gateway-deploy-ja.md
@@ -394,4 +394,5 @@ gateway の stderr には監査イベントストリームが含まれ、監査
 | 開発者のリクエストが `Not signed in to the Cloud gateway — run /login.` で失敗する | マシンの管理設定で `forceLoginMethod: "gateway"` または `forceLoginGatewayUrl` が設定されており、セッションに gateway サインインがない。残っている claude.ai ログインは要件を満たしていません。 | 開発者に `/login` を実行して gateway サインインを完了させてください。[Administrator policy requires a Cloud gateway sign-in](https://code.claude.com/docs/ja/errors.md#administrator-policy-requires-a-cloud-gateway-sign-in) も参照してください。 |
 | Claude Desktop がブートストラップ設定を取得できないと報告する | `/user/bootstrap` が 404 を返した: ユーザーに一致するポリシーが `desktop` キーを持たないか、ポリシーが一致しなかった。gateway の監査ログは各拒否を `desktop_bootstrap.denied` として理由とともに記録します。 | ユーザーに一致するポリシー、または `match: {}` ベースレイヤーに `desktop` ブロックを追加してください。空の `desktop: {}` で十分です。[Claude Desktop overlay](https://code.claude.com/docs/ja/claude-apps-gateway-config.md#claude-desktop-overlay) を参照してください。 |
+| 監査ログに、`/v1/logs` または `/v1/metrics` で `reason: invalid_token` を伴う `auth.denied` が記録される | マシンの管理設定で [`otelHeadersHelper`](https://code.claude.com/docs/ja/settings-reference#otelheadershelper) を設定している。そのマシン上の Claude Desktop セッションでは、Claude Code はセッショントークンの代わりにヘルパーからの `Authorization` ヘッダーを gateway のテレメトリリレーに送信します。Claude Desktop が v2.1.307 より前の Claude Code をバンドルしている場合、それらの設定で `OTEL_EXPORTER_OTLP_HEADERS` またはシグナルごとの形式に `Authorization` ヘッダーを設定すると、同じ拒否が発生します。 | それらの設定からヘルパーを削除してください。Claude Desktop が v2.1.307 より前の Claude Code をバンドルしている場合は、変数を削除してください。 |
 | スタートアップが `Gateway login is configured in managed settings, but this Claude Code build does not include Cloud gateway support.` を表示する | インストールされている Claude Code ビルドが gateway サポート前のバージョン | 開発者に Claude Code を Cloud gateway サポートを含むリリースに更新させてください |
 | スタートアップが `Administrator policy requires a Cloud gateway sign-in on this machine` で終了する | 開発者の環境が `ANTHROPIC_API_KEY` または `ANTHROPIC_AUTH_TOKEN` を設定しているか、設定が [`apiKeyHelper`](https://code.claude.com/docs/ja/settings-reference#apikeyhelper) を設定しているか、または以前の Claude Console ログインからの API キーがまだ保存されている | 適用される各項目をクリアするよう開発者に指示してください: 変数を設定解除するか、`apiKeyHelper` エントリを削除するか、`claude auth logout` を実行して保存されたキーを削除してください。`CLAUDE_CODE_USE_*` でクラウドプロバイダーを選択するセッションはサインインなしで開始されます。その他のすべてのセッションについては、開発者に `claude` を起動して `/login` でサインインさせてください。[Administrator policy requires a Cloud gateway sign-in](https://code.claude.com/docs/ja/errors.md#administrator-policy-requires-a-cloud-gateway-sign-in) も参照してください。 |
```

</details>

<details>
<summary>claude-code-on-the-web-ja.md</summary>

```diff
diff --git a/docs-ja/pages/claude-code-on-the-web-ja.md b/docs-ja/pages/claude-code-on-the-web-ja.md
index d0c2d00..4e27000 100644
--- a/docs-ja/pages/claude-code-on-the-web-ja.md
+++ b/docs-ja/pages/claude-code-on-the-web-ja.md
@@ -289,4 +289,26 @@ Claude Code はこれらの差分を raw git blob コンテンツから計算す
 [Agent teams](https://code.claude.com/docs/ja/agent-teams.md)はデフォルトでオフですが、[環境変数](https://code.claude.com/docs/ja/cloud-environments.md#set-environment-variables)に `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1` を追加することで有効にできます。
 
+### 会話内のプラグインの提案
+
+会話内に 1 つ以上の[プラグイン](https://code.claude.com/docs/ja/plugins/overview.md)を一覧表示し、**Add** ボタンを備えたカードが表示された場合、Claude がタスクのためにプラグインを提案していることを意味します。Claude はユーザーが求めなくてもこれらの提案を行うことがあります。応答する必要はなく、どちらの場合でも Claude はタスクを続行します。
+
+#### 提案されたプラグインを追加または削除する
+
+プラグインの **Add** を選択すると、claude.ai アカウントでそのプラグインがオンになり、セッション終了後もオンのままになります。元に戻すには、カードから追加したプラグインを開き、**Manage** を選択して claude.ai 上のプラグインのページに移動し、そのページからプラグインを削除します。
+
+#### プラグインの提案をオフにする
+
+Claude がプラグインを提案しないようにするには、[権限ルール](https://code.claude.com/docs/ja/permissions.md#manage-permissions)で `SearchPlugins` ツールと `SuggestPluginInstall` ツールを拒否します。[プロジェクト](https://code.claude.com/docs/ja/claude-projects.md)外で 1 つのリポジトリを持つセッションでは、両方のツール名を `permissions.deny` の下に列挙して、ルールをそのリポジトリの `.claude/settings.json` にコミットします：
+
+```json theme={null}
+{
+  "permissions": {
+    "deny": ["SearchPlugins", "SuggestPluginInstall"]
+  }
+}
+```
+
+Claude Code は、セッションに適用される[管理設定](https://code.claude.com/docs/ja/managed-settings.md)で [`allowManagedPermissionRulesOnly`](https://code.claude.com/docs/ja/settings-reference#allowmanagedpermissionrulesonly) が設定されている場合、これらの拒否ルールを含め、リポジトリの `.claude/settings.json` 内の権限ルールを無視します。その場合は、代わりにそれらの管理設定にルールを記述します。複数のリポジトリを持つセッションやプロジェクト内のクラウドスレッドなど、その他の構成については、どの[設定がクラウドセッションに適用されるか](https://code.claude.com/docs/ja/settings.md#settings-in-cloud-sessions)を参照してください。
+
 ### キューに入ったメッセージを取り戻す
```

</details>

*...以降省略*

</details>


<details>
<summary>2026-10-26</summary>

**変更ファイル:**

```
 .../pages/claude-apps-gateway-spend-limits-ja.md   |   2 +-
 docs-ja/pages/claude-projects-ja.md                |  13 +-
 docs-ja/pages/desktop-ja.md                        |  63 ++++++--
 docs-ja/pages/errors-ja.md                         |   2 +
 docs-ja/pages/fast-mode-ja.md                      |   4 +-
 docs-ja/pages/features-overview-ja.md              |   2 +-
 docs-ja/pages/glossary-ja.md                       |   4 +-
 docs-ja/pages/hooks-ja.md                          |   5 +-
 docs-ja/pages/how-claude-code-works-ja.md          |   2 +-
 docs-ja/pages/llm-gateway-protocol-ja.md           |   2 +-
 docs-ja/pages/monitoring-usage-ja.md               |   4 +-
 docs-ja/pages/prompt-caching-ja.md                 |  14 +-
 docs-ja/pages/sandboxing-ja.md                     |  28 +++-
 .../self-hosted-environments-configuration-ja.md   |   2 +-
 .../pages/self-hosted-environments-deploy-ja.md    |  13 +-
 .../self-hosted-environments-quickstart-ja.md      |   2 +-
 .../pages/self-hosted-environments-reference-ja.md |  17 +-
 docs-ja/pages/settings-reference-ja.md             |   8 +-
 docs-ja/pages/statusline-ja.md                     | 178 ++++++++++-----------
 19 files changed, 223 insertions(+), 142 deletions(-)
```

<details>
<summary>claude-apps-gateway-spend-limits-ja.md</summary>

```diff
diff --git a/docs-ja/pages/claude-apps-gateway-spend-limits-ja.md b/docs-ja/pages/claude-apps-gateway-spend-limits-ja.md
index fbea04d..4074faa 100644
--- a/docs-ja/pages/claude-apps-gateway-spend-limits-ja.md
+++ b/docs-ja/pages/claude-apps-gateway-spend-limits-ja.md
@@ -99,5 +99,5 @@ Claude Code は開発者が上限に近づくと警告します。最も消費
 警告と使用率は `anthropic-ratelimit-unified-*` ヘッダーから取得されます。ゲートウェイは、上限が設定されている開発者に対する成功した各 `/v1/messages` レスポンスにこれらのヘッダーを追加します。ヘッダーは常に開発者自身の上限を表します。ゲートウェイは、共有クォータを表すアップストリームプロバイダーのレート制限ヘッダーを削除し、決して転送しません。
 
-開発者に表示される支出額はゲートウェイ独自の [推定値](#how-requests-are-priced) であり、上限の適用に使われるのと同じ数値です。プロバイダーの請求書の金額ではありません。Claude Code はゲートウェイへの別のリクエストでドル金額を取得します。[コンプライアンス体制](https://code.claude.com/docs/ja/claude-apps-gateway-deploy.md#compliance-posture) で推奨されているように開発者のマシンで `CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC` を設定している場合、Claude Code はそのリクエストを行いません。この変数が設定されている場合、またはゲートウェイサーバーが v2.1.284 より古い場合、バーとステータスラインは使用率のみの表示になります。
+開発者に表示される支出額はゲートウェイ独自の [推定値](#how-requests-are-priced) であり、上限の適用に使われるのと同じ数値です。プロバイダーの請求書の金額ではありません。Claude Code はゲートウェイへの別のリクエストでドル金額を取得します。このリクエストは、開発者のマシンで `CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC` を設定している場合でも送信されます。v2.1.295 より前は、この変数が設定されていると Claude Code はそのリクエストを行わず、`/usage` とステータスラインには使用率とリセット日のみが表示され、ドル金額は表示されませんでした。
 
 ## 管理 API リファレンス
```

</details>

<details>
<summary>claude-projects-ja.md</summary>

```diff
diff --git a/docs-ja/pages/claude-projects-ja.md b/docs-ja/pages/claude-projects-ja.md
index 1080931..8f8efdc 100644
--- a/docs-ja/pages/claude-projects-ja.md
+++ b/docs-ja/pages/claude-projects-ja.md
@@ -112,5 +112,5 @@
 プロジェクトはサイドバーの **Projects** の下にリストされ、その会話が開いています。[最初のバッチ](#your-first-batch)では、作業を送信する前に何をセットアップするかについて説明しています。
 
-### 既存のクラウドセッションから開始する
+### 既存のセッションから開始する
 
 自分で開始したクラウドセッションがプロジェクトに属する作業を行っている場合は、そのセッションのサイドバーメニューを開いて **Move to project** を選択し、サブメニューから選択します。
@@ -121,5 +121,10 @@
 クラウドセッションのメッセージボックスの上に **Set up project** バナーが表示されることもあります。**Continue as new project** の代わりにこれを使用した場合も結果は同じですが、プロジェクトが開くとセッションの実行中のターンが停止します。
 
-ローカルセッションにはこれらのオプションがありません。プロジェクトでその作業を続行するには、プロジェクト会話で作業を説明するか、ブランチをプッシュし、そのリポジトリをプロジェクトに追加して、タスクでブランチに名前を付けます。
+自分のマシン上のセッションも、[Remote Control](https://code.claude.com/docs/ja/remote-control.md#start-a-remote-control-session) で接続すると、claude.ai/code で同じサイドバーメニューが使えるようになります。ただし、アカウントで [**Require trusted devices**](https://code.claude.com/docs/ja/remote-control.md#trusted-devices) がオンになっている間に接続したセッションのトランスクリプトは、プロジェクトから Claude が読み取ることはできません。この設定がオフの場合は、次の手順に従います。
+
+1. セッションがまだ接続されていない場合は、そのセッションで `/remote-control` を実行します。この設定がオンの間に接続した場合は、まず切断してから再接続してください。
+2. ブラウザで [claude.ai/code](https://claude.ai/code) のサイドバーにあるセッションの行を見つけ、そのメニューを開いて、同じサブメニューから選択します。
+
+**Require trusted devices** がオンの場合、または Remote Control を使用していない場合は、プロジェクトの会話で自分で作業を説明してください。または、セッションのブランチをプッシュし、そのリポジトリをプロジェクトに追加して、Claude にブランチ名を伝えます。
 
 ### GitHub アクセスをセットアップする
@@ -426,5 +431,5 @@ Claude は**デバイス上のフォルダーで作業することを Claude に
 * **スケジュールタスク**: プロジェクトでスケジュールされた作業を要求すると、Claude はそのプロジェクト内のスレッドとして実行され、その **Scheduled tasks** タブに表示される[クラウドスケジュールタスク](https://code.claude.com/docs/ja/routines.md)を作成します。プロジェクト外で作成したスケジュールタスクは独立して動作し続けます。
 * **Remote Control**: [Remote Control](https://code.claude.com/docs/ja/remote-control.md) は claude.ai をマシン上で実行している Claude Code セッションに接続します。プロジェクトで Claude にコンピュータ上でスレッドを実行するよう要求すると、プロジェクトは [Remote Control を使用してそれを実行します](#run-a-thread-on-your-own-computer)。
-* **Local sessions と agent view**: ターミナル、IDE、またはデスクトップアプリのローカル環境で自分で開始したセッションはプロジェクトに追加できません。[Agent view](https://code.claude.com/docs/ja/agent-view.md) は複数のローカルセッションを並べて追跡するための画面であり、各セッションを自分で開始してタスクを割り当てます。
+* **ローカルセッションと agent view**: ターミナル、IDE、またはデスクトップアプリのローカル環境で自分で開始したセッションはプロジェクトの外に留まりますが、[その作業をプロジェクトに取り込む](#start-from-an-existing-cloud-session)ことはできます。[Agent view](https://code.claude.com/docs/ja/agent-view.md) は複数のローカルセッションを並べて追跡するための画面であり、各セッションの開始とタスクの割り当ては引き続き自分で行います。
 * **worktree**: [worktree](https://code.claude.com/docs/ja/worktrees.md) は各ローカルセッションにリポジトリの独自の作業コピーを提供します。クラウドスレッドはそれらを必要としません。各スレッドはリポジトリを独自のクラウドサンドボックスにクローンし、独自のブランチで作業します。
 * **Agent teams**: [agent team](https://code.claude.com/docs/ja/agent-teams.md) は、マシン上またはクラウドセッション内で単一のタスク用にチームメイトセッションを開始し、そのタスクで終了する 1 つのセッションです。
```

</details>

<details>
<summary>desktop-ja.md</summary>

```diff
diff --git a/docs-ja/pages/desktop-ja.md b/docs-ja/pages/desktop-ja.md
index 58138bf..5365666 100644
--- a/docs-ja/pages/desktop-ja.md
+++ b/docs-ja/pages/desktop-ja.md
@@ -985,5 +985,10 @@ Linux または macOS のリモートマシンには、サポートされてい
 * **システム**：x86\_64 または arm64 プロセッサ。マシンは Claude Code の[システム要件](https://code.claude.com/docs/ja/setup.md#system-requirements)も満たす必要があります。Linux では、Claude Code には glibc 2.17 以降、または musl が必要です。マシンがどちらを使用しているかを確認するには、そのマシンで `ldd --version` を実行します。Alpine Linux などの musl ベースのディストリビューションでは、[Claude Code が必要とするパッケージ](https://code.claude.com/docs/ja/setup.md#alpine-linux-and-musl-based-distributions)もインストールしてください。
 * **SFTP**：SSH サーバーが SFTP サブシステムを提供している必要があります。これは `sshd_config` の `Subsystem sftp` 行で有効になります。確認するには、コンピューターのターミナルで `sftp` を使用して同じホストとポートに接続します。正常に動作しているサーバーでは `sftp>` プロンプトが表示されます。
-* **接続あたりのセッション数**：macOS と Linux の Desktop は、1 つの SSH 接続で複数のセッションを開きます。サーバーの `sshd_config` で `MaxSessions 1` が設定されている場合は、OpenSSH のデフォルトである 10 などに引き上げてください。
+* **サーバーでの `MaxSessions 1`**: `sshd_config` で `MaxSessions 1` が設定されているサーバーに接続するには、次のいずれかを行います。
+  * **コンピューターが macOS または Linux の場合**: Claude Desktop v3.1623.0 以降に更新します
+  * **コンピューターが Windows の場合**: Desktop の組み込み SSH クライアントはそのサーバーに接続できないため、Desktop が [OpenSSH クライアント経由で接続する](#use-your-ssh-configuration)ようにします
+  * **サーバーを変更できる場合**: `MaxSessions` を、たとえば OpenSSH のデフォルトである 10 に引き上げます
+* **`MaxSessions 1` でのログイン**: SSH エージェントが保持する鍵など、プロンプトなしで機能するログインを使用してください。Desktop は接続または再接続のたびに少なくとも 2 回ログインします。さらに、[ターミナル](#run-commands-in-the-terminal)タブごと、および `!` で始まるコマンドを実行する Desktop セッションごとに、少なくとも 1 回のログインが追加で発生します。Claude が実行するコマンドではログインは発生しません。
+* **`MaxSessions 1` でのワンタイムコード**: ワンタイムコードのようにログインのたびにプロンプトが表示される場合、`!` コマンドは失敗します。代わりに、それらのコマンドはターミナルタブで実行してください。ターミナルタブでは、独自のペインでプロンプトが表示されます。
 * **インストールフォルダ**：Desktop は、ホームディレクトリの `~/.claude/remote/` の下にヘルパープログラムと Claude Code をインストールします。そこからそれらを実行するため、そのフォルダを `noexec` でマウントされたファイルシステム上に置くことはできません。接続する各ユーザーのホームディレクトリに約 1 GB のディスク容量を確保してください。そのフォルダに含まれる内容については、[リモートマシン上のファイルとプロセス](#files-and-processes-on-the-remote-machine)を参照してください。
 * **シェル**：リモートマシン上のアカウントに設定されているシェルは、Bash、Zsh、`sh` と同様に、SSH 経由で送信されたコマンドを実行できる必要があります
@@ -994,5 +999,5 @@ Linux または macOS のリモートマシンには、サポートされてい
 Linux のリモートマシンがプロキシ経由でインターネットに接続する場合、または CA 証明書が必要な場合は、そのマシン上の `~/.claude/settings.json` の `env` に[プロキシと CA の変数](https://code.claude.com/docs/ja/network-config.md)を追加してください。そのマシンの `~/.profile`、`~/.bash_profile`、`~/.zprofile`、または `~/.zshrc` ですでにエクスポートしている場合でも追加してください。
 
-そのマシンのターミナルで実行した `claude` がそれらのファイルから変数を取得する場合でも、SSH セッションはそれらのファイルから変数を取得しません。その結果、セッションが応答しなくなったり、**The connection from … to the API failed** や **Authentication failed** が表示されたりすることがあり、再度サインインしても解決しません。
+SSH セッションでは、そのマシンのターミナルで実行した `claude` にはそれらのファイルの変数が渡される場合でも、Claude Code には渡されません。その結果、セッションがハングしたり、**The connection from … to the API failed** や **Authentication failed** が表示されたりすることがあり、再度サインインしても解決しません。
 
 **1. 変数を追加する**
@@ -1029,17 +1034,40 @@ Linux のリモートマシンがプロキシまたは CA の変数を別の場
 リモートマシンを再起動するか、[ヘルパーを削除する](#files-and-processes-on-the-remote-machine)手順の最初の 2 つのステップと同様に、Desktop を終了してヘルパーのプロセスを終了します。どちらの方法でも Claude の作業が中断されるため、タスクが実行されていないときに行ってください。
 
-#### macOS と Linux で SSH 設定を使用する
+#### SSH 設定を使用する
 
-macOS と Linux では、Desktop はコンピューター上の OpenSSH クライアントを実行して接続するため、`~/.ssh/config` が使用されます。OpenSSH クライアントを介した接続には Claude Desktop v1.37937.0 以降が必要です。そのファイルの `Host` 名を **SSH host** フィールドに入力すると、`HostName`、`User`、`IdentityFile`、`CertificateFile`、`ProxyJump`、`ProxyCommand` など、そのエントリの設定が使用されます。
```

</details>

<details>
<summary>errors-ja.md</summary>

```diff
diff --git a/docs-ja/pages/errors-ja.md b/docs-ja/pages/errors-ja.md
index b51930d..6d94138 100644
--- a/docs-ja/pages/errors-ja.md
+++ b/docs-ja/pages/errors-ja.md
@@ -328,4 +328,6 @@
 | `subagent_type is required: the general-purpose agent is not available in this session` | [ツールエラー](#subagent-type-is-required) |
 | `Error: this write left the memory index at MEMORY.md at ..., over its ... read limit` | [ツールエラー](#memory-index-is-over-its-read-limit) |
+| `Sandbox is required but failed to initialize: <reason>` | [サンドボックス化のトラブルシューティング](https://code.claude.com/docs/ja/sandboxing.md#commands-refused-with-sandbox-is-required) |
+| `Sandbox is required (sandbox.failIfUnavailable) and stopped being available in this session: <reason>` | [サンドボックス化のトラブルシューティング](https://code.claude.com/docs/ja/sandboxing.md#commands-refused-with-sandbox-is-required) |
 | `pkill: refusing to run` | [ツールエラー](#pkill-pattern-matches-the-claude-code-process) |
 | `Failed to write to <name>'s inbox — nothing was sent` | [ツールエラー](#failed-to-write-to-a-teammate-inbox) |
```

</details>

<details>
<summary>fast-mode-ja.md</summary>

```diff
diff --git a/docs-ja/pages/fast-mode-ja.md b/docs-ja/pages/fast-mode-ja.md
index b53bfb8..b8b3b9c 100644
--- a/docs-ja/pages/fast-mode-ja.md
+++ b/docs-ja/pages/fast-mode-ja.md
@@ -81,9 +81,9 @@ Claude Code は、モデル切り替え、再接続、または失敗した[可
 高速モード価格は完全な 1M トークンコンテキストウィンドウ全体で一定です。比較対象となる標準 Opus レートについては、[Claude 価格リファレンス](https://platform.claude.com/docs/ja/about-claude/pricing)を参照してください。
 
-会話で初めて fast mode を有効にすると、会話コンテキスト全体に対して、fast mode のキャッシュされていない入力トークンの価格を全額支払います。会話が進んでいるほどこのコストは高くなるため、最初に fast mode を有効にしたときに請求額が最も小さくなります。コストは会話ごとに 1 回だけ適用されるため、後で fast mode をオフにしてから再びオンに切り替えても、再度請求されることはありません。仕組みについては、[fast mode がプロンプトキャッシュとどのように相互作用するか](https://code.claude.com/docs/ja/prompt-caching.md#turning-on-fast-mode)を参照してください。
+会話で初めて fast mode を有効にすると、会話コンテキスト全体に対して、fast mode のキャッシュされていない入力トークンの価格を全額支払います。会話が進んでいるほどこのコストは高くなるため、最初に fast mode を有効にしたときに請求額が最も小さくなります。fast mode と標準速度は[別々のキャッシュ](https://code.claude.com/docs/ja/prompt-caching.md#turning-on-fast-mode)を保持するため、その後切り替えるたびに、会話の一部または全体が再びキャッシュなしで読み込まれます。
 
 ### 高速モード支出がどこに表示されるかを確認する
 
-高速モード支出がどこに表示されるかは、サインイン方法によって異なるため、まず [`/status`](https://code.claude.com/docs/ja/commands)を実行して確認してください。`Claude Max アカウント`などの `ログイン方法`行が表示される場合は、Claude サブスクリプションでサインインしています。代わりに `API キー`行が表示される場合は、リクエストが Claude Console 組織に請求されます。
+fast mode の支出がどこに表示されるかは、サインイン方法によって異なるため、まず [`/status`](https://code.claude.com/docs/ja/commands) を実行して確認してください。`Claude Max account` などの `Login method` 行が表示される場合は、Claude サブスクリプションでサインインしています。代わりに `API key` 行が表示される場合は、リクエストが Claude Console 組織に請求されます。
 
 * **Pro と Max**：使用クレジットから高速モードの料金を支払います。claude.ai の [**設定 > 使用状況**](https://claude.ai/settings/usage)に移動します。ここで、**使用クレジット**セクションに今月の使用クレジットの支出額が表示されます。この数字には高速モードが含まれていますが、別途に分類されていません。
```

</details>

<details>
<summary>features-overview-ja.md</summary>

```diff
diff --git a/docs-ja/pages/features-overview-ja.md b/docs-ja/pages/features-overview-ja.md
index 1162703..b6703d1 100644
--- a/docs-ja/pages/features-overview-ja.md
+++ b/docs-ja/pages/features-overview-ja.md
@@ -263,5 +263,5 @@ Claude Code は、フックをライフサイクルイベントで実行し、
 **コンテキストコスト：** 使用されるまで低い。ユーザーのみのスキルは呼び出されるまでゼロコストです。
 
-**Subagents 内：** スキルは subagents で異なる動作をします。オンデマンドロードの代わりに、subagent の `skills` フィールドにリストされているスキルは起動時にそのコンテキストに完全にプリロードされます。Subagents はスキルツールを通じて、リストされていないプロジェクト、ユーザー、プラグインスキルを発見して呼び出すことができます。
+**サブエージェント内：** サブエージェントの `skills` フィールドにリストされているスキルの完全なコンテンツは、オンデマンドではなく[起動時にそのコンテキストにロードされます](https://code.claude.com/docs/ja/sub-agents.md#preload-skills-into-subagents)。サブエージェントは引き続き、Skill ツールを通じてリストされていないプロジェクト、ユーザー、プラグインのスキルを発見して呼び出すことができます。
 
 > [!TIP]
```

</details>

<details>
<summary>glossary-ja.md</summary>

```diff
diff --git a/docs-ja/pages/glossary-ja.md b/docs-ja/pages/glossary-ja.md
index d514e7e..8187c95 100644
--- a/docs-ja/pages/glossary-ja.md
+++ b/docs-ja/pages/glossary-ja.md
@@ -121,7 +121,7 @@ CLAUDE.md は、プロジェクトスコープでは `./CLAUDE.md` または `./
 ### Compaction
 
-[コンテキストウィンドウ](#context-window)が上限に近づいたときに、会話を自動的に要約する処理です。まず古いツール出力がクリアされ、次に会話が要約されます。プロジェクトルートの CLAUDE.md と自動メモリは圧縮後も保持され、ディスクから再読み込みされますが、会話の中でのみ与えられた指示は失われる可能性があります。手動で実行するには `/compact` を実行します。`/compact focus on the API changes` のように重点を指定することもできます。
+[コンテキストウィンドウ](#context-window)が上限に近づいたときに、会話を自動的に要約する処理です。プロジェクトルートの CLAUDE.md と自動メモリは圧縮後も保持されますが、会話の中でのみ与えられた指示は失われる可能性があります。手動で実行するには `/compact` を実行します。`/compact focus on the API changes` のように重点を指定することもできます。
 
-詳細: [コンテキスト圧縮後も保持されるもの](https://code.claude.com/docs/ja/context-window.md#what-survives-compaction) · [コンテキストがいっぱいになったとき](https://code.claude.com/docs/ja/how-claude-code-works.md#when-context-fills-up)
+詳細: [コンテキスト圧縮後も保持されるもの](https://code.claude.com/docs/ja/context-window.md#what-survives-compaction) · [コンテキストがいっぱいになったとき](https://code.claude.com/docs/ja/how-claude-code-works.md#when-context-fills-up) · [アイドル状態のままにした会話を Claude Code が圧縮するタイミング](https://code.claude.com/docs/ja/settings-reference.md#idlecompaction)
 
 ### Connector
```

</details>

<details>
<summary>hooks-ja.md</summary>

```diff
diff --git a/docs-ja/pages/hooks-ja.md b/docs-ja/pages/hooks-ja.md
index 17cc722..af8bcf2 100644
--- a/docs-ja/pages/hooks-ja.md
+++ b/docs-ja/pages/hooks-ja.md
@@ -1748,5 +1748,5 @@ Claude がツールのパラメータを作成した後、ツール呼び出し
 [PreToolUse の決定制御](#pretooluse-decision-control)を使用して、ツール呼び出しを許可、拒否、確認、または遅延します。
 
-`PreToolUse` の [Agent SDK コールバックフック](https://code.claude.com/docs/ja/agent-sdk/hooks.md)がタイムアウトを超えると、ツール呼び出しはブロックされ、Claude はタイムアウトを示すエラー結果を受け取ります。
+タイムアウトを超えた `PreToolUse` の [Agent SDK コールバックフック](https://code.claude.com/docs/ja/agent-sdk/hooks.md#hook-timeout)は、ツール呼び出しをブロックします。
 
 #### PreToolUse の入力
@@ -4087,5 +4087,5 @@ Claude Code が非同期フックの結果を配信するのは、セッショ
 非同期フックが発火すると、Claude Code はフック プロセスを開始し、完了を待たずにすぐに続行します。フックは同期フックと同じ JSON 入力を stdin 経由で受け取ります。
 
-バックグラウンド プロセスが終了した後、Claude Code はフックの JSON レスポンスに含まれる `additionalContext` フィールドと `systemMessage` フィールドを次の会話ターンで Claude に配信します。同期フックの `systemMessage` とは異なり、どちらのフィールドもユーザーには表示されません。
+バックグラウンド プロセスが終了した後、Claude Code はフックの JSON レスポンスに含まれる `additionalContext` フィールドと `systemMessage` フィールドを次の会話ターンで Claude に配信します。ただし、[繰り返される `SessionStart` の出力](#limitations)は除きます。同期フックの `systemMessage` とは異なり、どちらのフィールドもユーザーには表示されません。
 
 JSON レスポンスは、stdout に単独で出力するか、それ自体だけの 1 行として出力します。
@@ -4155,4 +4155,5 @@ jq -nc --arg msg "$MSG" '{hookSpecificOutput: {hookEventName: "PostToolUse", add
 * フック出力は次の会話ターンで配信されます。セッションがアイドル状態の場合、レスポンスは次のユーザー操作まで待機します。例外: `asyncRewake` フックが終了コード 2 で終了すると、セッションがアイドル状態でも Claude を直ちに起動します。
 * 各実行は個別のバックグラウンド プロセスを作成します。
+* 非同期の `SessionStart` フックは、イベントが発火するたびに実行されます。`additionalContext` と `systemMessage` のテキストが、Claude がそのフックから最後に受け取った内容と一致する場合、Claude Code はフックの出力をスキップします。ただし、それ以降に同期 `SessionStart` フックが別のテキストを追加した場合は除きます。Claude Code はテキストが変更されたときにそのテキストを配信し、コンテキスト圧縮または `/clear` の後に次にフックが実行されたときにも再度配信します。v2.1.295 より前は、Claude Code は再開のたびに同じテキストを会話に再度追加していました。
 
 ## セキュリティに関する考慮事項
```

</details>

<details>
<summary>how-claude-code-works-ja.md</summary>

```diff
diff --git a/docs-ja/pages/how-claude-code-works-ja.md b/docs-ja/pages/how-claude-code-works-ja.md
index 027f4ed..564de85 100644
--- a/docs-ja/pages/how-claude-code-works-ja.md
+++ b/docs-ja/pages/how-claude-code-works-ja.md
@@ -132,5 +132,5 @@ Claude が `Co-Authored-By` トレーラーをコミットに追加するなど
 #### コンテキストが満杯になったとき
 
-Claude Code はコンテキストウィンドウの制限に近づくと、自動的にコンテキストを管理します。古いツール出力をクリアし、必要に応じて会話を要約します。リクエストと主要なコードスニペットは保持されます。会話の早い段階からの詳細な指示は失われる可能性があります。会話履歴に依存するのではなく、永続的なルールを CLAUDE.md に入れてください。
+Claude Code は制限に近づくと、自動的にコンテキストを管理します。会話を要約に圧縮します。要約にはリクエストと主要なコードスニペットが保持されますが、会話の早い段階からの詳細な指示は失われる可能性があります。会話履歴に依存するのではなく、永続的なルールを CLAUDE.md に入れてください。
 
 コンパクト化中に保持されるものを制御するには、CLAUDE.md に「Compact Instructions」セクションを追加するか、`/compact` をフォーカス付きで実行します（例：`/compact focus on the API changes`）。
```

</details>

<details>
<summary>llm-gateway-protocol-ja.md</summary>

```diff
diff --git a/docs-ja/pages/llm-gateway-protocol-ja.md b/docs-ja/pages/llm-gateway-protocol-ja.md
index 4b6882e..0f78705 100644
--- a/docs-ja/pages/llm-gateway-protocol-ja.md
+++ b/docs-ja/pages/llm-gateway-protocol-ja.md
@@ -149,5 +149,5 @@ Claude Code はルーティングヒントも送信できます。ゲートウ
 | `x-claude-code-request-class` | このリクエストの種類：メイン会話のターンの場合は `main`、[サブエージェント](https://code.claude.com/docs/ja/sub-agents.md)のターンの場合は `subagent`、ワークフロー内で実行されているエージェントの場合は `workflow`、会話をコンパクト化する要約リクエストの場合は `compaction`、セッションタイトル、分類器、および要約などのサイドリクエストの場合は `auxiliary`。すべてのリクエストで送信されます |
 | `x-claude-code-agent-type` | リクエストを発行したサブエージェントの種類：`Explore`、`Plan`、または `general-purpose` などの組み込みエージェント型名、ユーザー定義エージェントの場合は `custom`、[エージェントチーム](https://code.claude.com/docs/ja/agent-teams.md)メンバーがリードのプロセスで実行されている場合は `teammate`、または [フォーク](https://code.claude.com/docs/ja/sub-agents.md#fork-the-current-conversation)の場合は `fork`。サブエージェント自身のターンにのみ存在します。サブエージェントのコンパクト化またはサイドリクエストはエージェント ID を保持しますが、タイプは含みません。ユーザーが選択したエージェント名は送信されません |
-| `x-claude-code-compaction` | [コンテキスト圧縮](https://code.claude.com/docs/ja/prompt-caching.md#compacting-the-conversation)中に会話を要約するリクエストに存在します。値は何がトリガーしたかを示します。コンテキストウィンドウが容量に近づいた場合は `auto`、`/compact` の場合は `manual`、API がリクエストが長すぎると拒否した場合は `reactive`。[アイドル時の圧縮](https://code.claude.com/docs/ja/settings-reference.md#idlecompaction)の場合も値は `auto` です。他のすべてのリクエストでは存在しません |
+| `x-claude-code-compaction` | [コンテキスト圧縮](https://code.claude.com/docs/ja/prompt-caching.md#compacting-the-conversation)中に会話を要約するリクエストに存在します。値は何がトリガーしたかを示します。コンテキストウィンドウが容量に近づいた場合は `auto`、`/compact` の場合は `manual`、API がリクエストが長すぎると拒否した場合は `reactive`。インタラクティブなターミナルセッションでの[アイドル時の圧縮](https://code.claude.com/docs/ja/settings-reference.md#idlecompaction)の場合も値は `auto` です。他のすべてのリクエストでは存在しません。これには、圧縮の前にバックグラウンドで要約を書き込むリクエストも含まれます |
 | `x-claude-code-context-compacted` | コンパクト化後の最初のメイン会話リクエストに 1 回存在し、`x-claude-code-compaction` と同じ値を持ちます。このリクエストの前の会話プレフィックスはもう使用されないため、それをキーとしたキャッシュは削除できます |
 | `x-claude-code-prev-tool-durations` | このリクエストが含む結果のツール呼び出しの測定実行時間。`<name>=<ms>;<name>=<ms>` として、例えば `Bash=742;Read=9`。同じ会話のツール呼び出しのバッチ後の次のリクエストで送信されます。メインセッションまたはサブエージェントから送信されます |
```

</details>

*...以降省略*

</details>


<details>
<summary>2026-10-25</summary>

**変更ファイル:**

```
 docs-ja/pages/artifacts-ja.md                      |   4 +-
 docs-ja/pages/channels-reference-ja.md             |   9 +-
 docs-ja/pages/checkpointing-ja.md                  |   4 +-
 docs-ja/pages/claude-apps-gateway-ja.md            |  12 +-
 docs-ja/pages/claude-code-on-the-web-ja.md         |  40 +-
 docs-ja/pages/cloud-environments-ja.md             |   7 +-
 docs-ja/pages/code-review-customize-ja.md          |  68 ++-
 docs-ja/pages/code-review-ja.md                    |   2 +-
 docs-ja/pages/code-review-pull-requests-ja.md      |   5 +-
 docs-ja/pages/code-review-troubleshooting-ja.md    |   5 +-
 docs-ja/pages/desktop-ja.md                        |   8 +-
 docs-ja/pages/desktop-scheduled-tasks-ja.md        |  25 +-
 docs-ja/pages/env-vars-ja.md                       |   2 +-
 docs-ja/pages/errors-ja.md                         |  75 ++-
 docs-ja/pages/fast-mode-ja.md                      |  32 +-
 docs-ja/pages/hooks-guide-ja.md                    |   2 +-
 docs-ja/pages/hooks-ja.md                          |  40 +-
 docs-ja/pages/interactive-mode-ja.md               |   2 +
 docs-ja/pages/jetbrains-ja.md                      |   2 +-
 docs-ja/pages/keybindings-ja.md                    |   8 +-
 docs-ja/pages/large-codebases-ja.md                |   4 +-
 docs-ja/pages/llm-gateway-connect-ja.md            |   5 +-
 docs-ja/pages/llm-gateway-protocol-ja.md           |   5 +-
 docs-ja/pages/mcp-ja.md                            |   6 +-
 docs-ja/pages/model-config-ja.md                   |   9 +-
 docs-ja/pages/monitoring-usage-ja.md               | 649 +++++++++++----------
 docs-ja/pages/network-config-ja.md                 |   4 +-
 docs-ja/pages/permission-modes-ja.md               |   2 +-
 docs-ja/pages/prompt-caching-ja.md                 |   2 +-
 docs-ja/pages/remote-control-ja.md                 |  12 +-
 docs-ja/pages/routines-ja.md                       |  50 +-
 docs-ja/pages/sandboxing-ja.md                     |  14 +-
 .../self-hosted-environments-configuration-ja.md   |  88 ++-
 .../pages/self-hosted-environments-deploy-ja.md    | 174 +++++-
 docs-ja/pages/self-hosted-environments-ja.md       |  21 +-
 .../self-hosted-environments-quickstart-ja.md      |   2 +
 .../pages/self-hosted-environments-reference-ja.md |  84 ++-
 docs-ja/pages/settings-reference-ja.md             | 449 +++++++-------
 docs-ja/pages/terminal-config-ja.md                |   5 +
 docs-ja/pages/tools-reference-ja.md                |   7 +-
 docs-ja/pages/ultrareview-ja.md                    |   4 +-
 docs-ja/pages/vs-code-ja.md                        |   7 +-
 docs-ja/pages/web-quickstart-ja.md                 |  18 +-
 43 files changed, 1314 insertions(+), 659 deletions(-)
```

<details>
<summary>artifacts-ja.md</summary>

```diff
diff --git a/docs-ja/pages/artifacts-ja.md b/docs-ja/pages/artifacts-ja.md
index ade85a9..2ffbccb 100644
--- a/docs-ja/pages/artifacts-ja.md
+++ b/docs-ja/pages/artifacts-ja.md
@@ -341,7 +341,5 @@ UI、画面フロー、ランディングページ、またはポスターをモ
 Claude Docs は Claude Code にコマンドではなく claude.ai [コネクター](https://code.claude.com/docs/ja/mcp.md#use-mcp-servers-from-claude-ai) として到達します。接続されている場合、`/mcp` はそれを `claude.ai Claude Docs` としてリストします。他の人のためのドキュメントのリクエストは、アーティファクトページではなく Claude Docs に送られます。仕様、提案、またはセッションで作成したプランの書き込みです。Claude はドキュメントが作成されたときにドキュメントのリンクを提供します。
 
-README などのコードベースに属するドキュメントはファイルのままです。Claude が Claude Docs に配置するであろう何かのためにファイルを取得するには、`.docx` またはリポジトリ内の Markdown ファイルなどの形式を指定します。
-
-コネクターをオフにするには、`claude.ai Claude Docs` を `deniedMcpServers` に追加するか、[claude.ai コネクターを無効にする](https://code.claude.com/docs/ja/mcp.md#disable-claude-ai-connectors) で説明されている `/mcp` トグルを使用します。
+README などのコードベースに属するドキュメントはファイルのままです。Claude が Claude Docs に配置するであろう何かのためにファイルを取得するには、`.docx` またはリポジトリ内の Markdown ファイルなどの形式を指定します。`claude.ai Claude Docs` コネクタのみをオフにするには、[claude.ai コネクタを無効にする](https://code.claude.com/docs/ja/mcp.md#disable-claude-ai-connectors) を参照してください。
 
 ## ページの制約
```

</details>

<details>
<summary>channels-reference-ja.md</summary>

```diff
diff --git a/docs-ja/pages/channels-reference-ja.md b/docs-ja/pages/channels-reference-ja.md
index 954daea..ebb471a 100644
--- a/docs-ja/pages/channels-reference-ja.md
+++ b/docs-ja/pages/channels-reference-ja.md
@@ -526,5 +526,5 @@ const PermissionRequestSchema = z.object({
     request_id: z.string(),     // 5 つの小文字、プロンプトに逐語的に含める
     tool_name: z.string(),      // 例：'Bash'、'Write'
-    description: z.string(),    // この呼び出しが何をするかの要約。信頼されないものとして扱う。
+    description: z.string(),    // この呼び出しの要約。信頼されないものとして扱う。
     input_preview: z.string(),  // ツール引数を JSON 形式のテキストとして。信頼されないものとして扱う。
   }),
@@ -582,8 +582,9 @@ async function onInbound(message: PlatformMessage) {
 ```
 
-期待されたフォーマットと正確に一致しないリモート返信は、2 つの方法のいずれかで失敗し、どちらの場合もローカルターミナルダイアログは開いたままです：
+リモート返信が効果を持たず、ローカルターミナルダイアログが開いたままの場合は、次の原因を確認してください：
 
-* **異なるフォーマット**：インバウンドハンドラーの正規表現が一致しないため、'approve it'または ID なしの'yes'のようなテキストは通常のメッセージとして Claude にフォールスルーします。
-* **正しいフォーマット、間違った ID**：サーバーは判定を発行しますが、Claude Code はその ID を持つ開いているリクエストを見つけず、サイレントにドロップします。
+* **フォーマットが間違っている**：インバウンドハンドラーの正規表現が一致しないため、`approve it` や ID なしの `yes` のようなテキストは通常のメッセージとして Claude にフォールスルーします。
+* **ID が間違っている**：サーバーは判定を発行しますが、Claude Code はその ID を持つ開いているリクエストを見つけられず、サイレントにドロップします。
+* **ID が以前のプロンプトで使用されていた**：サーバーはリクエストの ID を使って判定を発行しますが、セッション内の以前のプロンプトが同じ ID を持っていました。ID が重複すると、Claude Code はその ID を持つチャネル判定をすべてドロップします。これにより、一方のプロンプト向けの返信がもう一方を承認することはありません。ID はランダムな 5 文字なので、重複はまれです。代わりにターミナルで応答してください。
 
 ### 完全な例
```

</details>

<details>
<summary>checkpointing-ja.md</summary>

```diff
diff --git a/docs-ja/pages/checkpointing-ja.md b/docs-ja/pages/checkpointing-ja.md
index b1b1b9c..6be6271 100644
--- a/docs-ja/pages/checkpointing-ja.md
+++ b/docs-ja/pages/checkpointing-ja.md
@@ -91,7 +91,7 @@ Claude Code は、ファイル編集ツールで行われたすべての変更
 ### ターン中に送信されたメッセージはチェックポイントされません
 
-巻き戻しメニューでは、[Claude がまだ作業中に入力した](https://code.claude.com/docs/ja/interactive-mode.md#queue-messages-while-claude-works)メッセージに **No code restore**（コードの復元なし）と表示されることがあります。Claude はそのメッセージをターンの終了前に読み取っています。[チェックポイントはターンを開始するプロンプトに対して作成される](#how-checkpoints-work)ため、このメッセージ自体にはチェックポイントがありません。Claude がそのメッセージを読んだ後に行った編集は、ターンを開始したプロンプトに含まれます。
+巻き戻しメニューでは、[Claude がまだ作業中に入力した](https://code.claude.com/docs/ja/interactive-mode.md#queue-messages-while-claude-works)メッセージに **No code restore**（コードの復元なし）と表示されることがあります。このように表示されたメッセージには、それ自体の[チェックポイント](#how-checkpoints-work)がありません。
 
-メッセージ自体について何かをする必要はありません。セッションのその部分でのファイル変更を取り消すには、ターンを開始したプロンプトを選択し、**Restore code**（コードを復元）または **Restore code and conversation**（コードと会話を復元）を選択します。これにより、メッセージが到達する前の編集を含め、ターン全体での Claude のファイル編集が元に戻されます。マークされたメッセージを選択した場合も **Restore conversation**（会話を復元）は利用でき、会話をそのメッセージまで巻き戻し、ファイルはそのまま残します。
+そのメッセージの後に Claude が行ったファイル編集を取り消すには、ターンを開始したプロンプトを選択し、**Restore code**（コードを復元）または **Restore code and conversation**（コードと会話を復元）を選択します。これにより、メッセージが到達する前の編集を含め、ターン全体での Claude のファイル編集が元に戻されます。
 
 ### シンボリックリンクおよびハードリンクパスは復元されません
```

</details>

<details>
<summary>claude-apps-gateway-ja.md</summary>

```diff
diff --git a/docs-ja/pages/claude-apps-gateway-ja.md b/docs-ja/pages/claude-apps-gateway-ja.md
index 0d10fde..9f663ee 100644
--- a/docs-ja/pages/claude-apps-gateway-ja.md
+++ b/docs-ja/pages/claude-apps-gateway-ja.md
@@ -459,15 +459,17 @@ OS ポリシー（HKLM レジストリポリシーまたは管理設定プリス
 #### 親設定のフックキーとスキルキーがどのように有効になるか
 
-Agent SDK の `managedSettings` オプションを通じて `disableAllHooks: true` を親設定として渡しても、すべてのフックが停止するわけではありません。[SDK フックコールバック](https://code.claude.com/docs/ja/agent-sdk/hooks.md)は引き続き実行され、管理者のフックも実行されます。管理者のフックはアプリケーションからオフにできません。
+アプリケーションが Agent SDK の [`managedSettings`](https://code.claude.com/docs/ja/agent-sdk/typescript#options) オプションで渡すキーは親設定です。管理者が管理設定をデプロイしているマシンでは、管理者が[埋め込みホストにポリシーの追加を許可](https://code.claude.com/docs/ja/managed-settings.md#let-an-embedding-host-add-policy)しない限り、Claude Code は親設定を無視します。
 
-管理者が管理設定をデプロイしているマシンでは、管理者が[埋め込みホストにポリシーの追加を許可](https://code.claude.com/docs/ja/managed-settings.md#let-an-embedding-host-add-policy)しない限り、Claude Code は親設定を無視します。
+`managedSettings` で [`disableAllHooks: true`](https://code.claude.com/docs/ja/settings-reference#disableallhooks) を渡した場合：
+
+* **停止するもの**：ユーザー、プロジェクト、およびローカルのフックと、エージェントのフロントマターまたは SDK の [`settings` オプション](https://code.claude.com/docs/ja/agent-sdk/typescript#options)で宣言されたフック。
+* **引き続き実行されるもの**：アプリケーションの [SDK フックコールバック](https://code.claude.com/docs/ja/agent-sdk/hooks.md)と、管理設定にある管理者のフック。管理者のフックはアプリケーションからオフにできません。
 
 | 渡すもの | 何が起こるか |
 | :- | :- |
-| `disableAllHooks: true` | `allowManagedHooksOnly: true` として扱われるため、[`allowManagedHooksOnly` でブロックされる](https://code.claude.com/docs/ja/settings-reference#what-runs-under-allowmanagedhooksonly)ものとして挙げられているフックが停止し、SDK の [`settings` オプション](https://code.claude.com/docs/ja/agent-sdk/typescript#options)のフックも停止します。 |
-| [`disableSkillShellExecution: true`](https://code.claude.com/docs/ja/settings-reference#disableskillshellexecution) | 有効になります。 |
+| `hooks`、またはエントリを含む `allowedHttpHookUrls` または `httpHookAllowedEnvVars` | Claude Code はこのキーを無視します。代わりに SDK の `settings` オプションを使用してください。 |
 | `allowedHttpHookUrls: []` | 管理者が `hooks` を定義しているかプラグインを有効にしていない限り、有効になります。別の設定ソースが挙げている URL を除き、HTTP フックは実行されません。 |
 | `httpHookAllowedEnvVars: []` | 管理者が `hooks` を定義しているかプラグインを有効にしていない限り、有効になります。HTTP フックのヘッダーには、別の設定ソースが挙げている環境変数のみを含めることができます。 |
-| エントリを含む `allowedHttpHookUrls` または `httpHookAllowedEnvVars` | マージすると管理者のリストが広がるため、Claude Code はこれを無視します。代わりに SDK の `settings` オプションを使用してください。 |
+| [`disableSkillShellExecution: true`](https://code.claude.com/docs/ja/settings-reference#disableskillshellexecution) | 有効になります。 |
 
 `managedSettings` でこれらのキーを渡すには、Claude Code v2.1.309 以降、または TypeScript Agent SDK v0.3.309 以降が必要です。
```

</details>

<details>
<summary>claude-code-on-the-web-ja.md</summary>

```diff
diff --git a/docs-ja/pages/claude-code-on-the-web-ja.md b/docs-ja/pages/claude-code-on-the-web-ja.md
index edd953f..d0c2d00 100644
--- a/docs-ja/pages/claude-code-on-the-web-ja.md
+++ b/docs-ja/pages/claude-code-on-the-web-ja.md
@@ -9,5 +9,5 @@
 > [!NOTE]
 >
-> クラウドセッションは Pro、Max、Team プランで利用でき、Premium シートまたは Chat + Claude Code シートを持つ Enterprise ユーザーも対象です。Enterprise 組織が[カスタムロール](https://support.claude.com/en/articles/13930452)でアクセスを管理している場合は、クラウドセッションの権限を含むロールも必要です。Owner にロールの確認を依頼し、不足している場合は [**Organization settings > Roles**](https://claude.ai/admin-settings/roles) で追加してもらってください。
+> クラウドセッションは Pro、Max、Team プランで利用でき、Premium シートまたは Chat + Claude Code シートを持つ Enterprise ユーザーも対象です。[カスタムロール](https://support.claude.com/en/articles/13930452)でアクセスが管理されている場合、ブラウザ、アプリ、またはターミナルから Anthropic のインフラストラクチャでセッションを開始するには、クラウドセッションの権限を含むロールも必要です。Owner に依頼して、[**Organization settings > Roles**](https://claude.ai/admin-settings/roles) でいずれかのロールにこの権限を追加してもらってください。
 
 クラウドセッションは、マシン上ではなくクラウドインフラストラクチャで実行される Claude Code セッションです。デフォルトでは Anthropic が管理するインフラストラクチャで実行されるか、ルーティングされた場合は組織の[セルフホスト環境](https://code.claude.com/docs/ja/self-hosted-environments)で実行されます。セッションはラップトップを閉じた後も実行を続け、任意のデバイスから確認または操作できます。クラウドセッションは、Claude および Claude Code のその他の使用量と合わせてプランの使用制限にカウントされ、クラウド VM に対する別途料金はかかりません。
@@ -19,5 +19,5 @@
 * **ブラウザ**：[claude.ai/code](https://claude.ai/code)（ウェブ上の Claude Code とも呼ばれます）
 * **モバイル**：[Claude アプリ](https://code.claude.com/docs/ja/mobile.md)の**Code** タブ
-* **デスクトップアプリ**：[セッションを開始](https://code.claude.com/docs/ja/desktop.md#run-long-running-tasks-in-the-cloud)するときに**Local** の代わりに**Cloud** を選択
+* **デスクトップアプリ**：[セッションを開始](https://code.claude.com/docs/ja/desktop.md#run-long-running-tasks-in-the-cloud)するときに、環境セレクターの**Cloud** の下にある環境を選択
 * **ターミナル**：[`claude --cloud`](#from-terminal-to-cloud)
 * **クラウドスケジュールタスク**：[スケジュール実行とトリガー実行](https://code.claude.com/docs/ja/routines.md)は各々クラウドセッションとして実行されます
@@ -248,7 +248,13 @@ Teleport には claude.ai のサブスクリプション認証が必要です。
 ### 変更を確認
 
-各セッションは追加および削除された行数を示す差分インジケーター（例：`+42 -18`）を表示します。それを選択して差分ビューを開き、特定の行にインラインコメントを残し、次のメッセージで Claude に送信します。
+Claude がブランチに変更をプッシュすると、チャットの横のパネルにある **Changes** カードに、`+42 -18` のように追加および削除された行数が表示されます。**Changes** カードの行数をクリックすると差分ビューが開きます。
 
-差分ビューは、デフォルトでセッションの変更をそのベースブランチと比較します。リポジトリ内の他の任意のブランチと比較するには、**Compare against** を選択してブランチを 1 つ選びます。
+* セッションのタイトルバー、またはバーの **⋮** メニューにある **Changes** をクリックすることもできます。
+* パネルが非表示のときに表示するには、セッションのタイトルバー、またはバーの **⋮** メニューにある **Show session rail** アイコンをクリックします。
+
+差分ビューでは、行にコメントしたり、別のブランチと比較したりできます：
+
```

</details>

<details>
<summary>cloud-environments-ja.md</summary>

```diff
diff --git a/docs-ja/pages/cloud-environments-ja.md b/docs-ja/pages/cloud-environments-ja.md
index ae00c7c..1a4c3a3 100644
--- a/docs-ja/pages/cloud-environments-ja.md
+++ b/docs-ja/pages/cloud-environments-ja.md
@@ -110,5 +110,5 @@ Anthropic ホスト型環境では、セッションは環境の値をセッシ
 #### シークレットを追加する
 
-シークレットは一度に 1 つずつ追加し、追加後にシークレットを編集することはできません。シークレットのホストまたは値を変更するには、削除して再度追加します。
+シークレットは一度に 1 つずつ追加します。シークレットのホストまたは値を変更するには、削除して再度追加します。
 
 [共有環境](#organization-shared-environments) にシークレットを追加するには、[管理設定](https://claude.ai/admin-settings) の **クラウド環境** ページから環境を編集用に開き、その **ネットワークシークレット** セクションで手順 2 から続けます。Team プランで [組織管理者ロール](#requirements) を持っていない場合は、自分の環境で手順 1 に従い、その後 [短いフォームに入力](#add-a-secret-without-the-role) します。
@@ -120,5 +120,5 @@ Anthropic ホスト型環境では、セッションは環境の値をセッシ
 **2. シークレットを追加する**
 
-**シークレットを追加** を選択してフォームに入力します。API キーがリクエストヘッダーで移動する場合はデフォルトの **シークレットタイプ**、**Bearer** を保持し、これらのフィールドに入力します。
+**シークレットを追加**（管理設定では **追加** と表示）を選択してフォームに入力します。API キーがリクエストヘッダーで移動する場合はデフォルトの **シークレットタイプ**、**Bearer** を保持し、これらのフィールドに入力します。
 
 * **名前**: `Internal billing API` などのシークレットのラベル
@@ -444,9 +444,10 @@ apt update && apt install -y shellcheck
 ### スクリプト要件
 
-セットアップスクリプトには、対応する 3 つの制約があります。
+セットアップスクリプトには、対応する 4 つの制約があります。
 
 * **ゼロで終了**：スクリプトがゼロ以外で終了する場合、セッションは開始に失敗します。非重要なコマンドに `|| true` を追加して、一時的なインストール失敗がセッションをブロックしないようにします。
 * **5 分以内に完了**：スクリプトの総実行時間を約 5 分以内に保つため、[環境キャッシュ](#environment-caching) をビルドできます。セットアップが 5 分以上かかる場合、環境はキャッシュされません。独立したインストールを `&` と `wait` で並列実行し、フィットしない単一ダウンロードを [SessionStart フック](#setup-scripts-vs-sessionstart-hooks) に移動して、バックグラウンドで起動します。新しいセッションがセットアップ中にハングまたはタイムアウトする場合は、[新しいセッションがセットアップ中にハングまたはタイムアウトする](https://code.claude.com/docs/ja/web-quickstart.md#new-sessions-hang-or-time-out-during-setup) を参照してください。
 * **インストール用のネットワークアクセス**：パッケージインストールはレジストリに到達する必要があります。デフォルトの **Trusted** レベルは npm、PyPI、RubyGems、crates.io を含む [一般的なパッケージレジストリ](#default-allowed-domains) をカバーします。**None** ネットワークアクセスでは、インストールは失敗します。
+* **環境の変数はまだ設定されていない**：スクリプトは、セッションが環境の [環境変数](#set-environment-variables) を設定する前に実行されます。スクリプトが必要とする値は、スクリプト自体で設定してください。
 
 ### 環境キャッシング
```

</details>

<details>
<summary>code-review-customize-ja.md</summary>

```diff
diff --git a/docs-ja/pages/code-review-customize-ja.md b/docs-ja/pages/code-review-customize-ja.md
index ac7788c..261ced3 100644
--- a/docs-ja/pages/code-review-customize-ja.md
+++ b/docs-ja/pages/code-review-customize-ja.md
@@ -124,11 +124,71 @@ Code Review は保護されたブランチから `REVIEW.md` を読み込む場
 レビューで取り込んだファイルが適用されない場合は、次の各項目を確認してください。
 
-* **場所**：ファイルをリポジトリのルートに移動します。`@docs/review-rules.md` のようなサブディレクトリ内へのパスは取り込まれません。
+* **場所**：ファイルをリポジトリのルートに移動します。[スキルファイル](#include-a-skill-file)を除き、`@docs/review-rules.md` のようなサブディレクトリ内へのパスは取り込まれません。
 * **名前**：大文字と小文字を含めてファイル名を正確に一致させ、スペースを含まない名前を使用します。`REVIEW.md` と同じ場所にあるどのファイルとも名前が一致しない行は、プレーンテキストとして `REVIEW.md` に残り、チェック実行ではスキップされた取り込みとして報告されません。
-* **1 階層のみ**：すべてのファイルをルートの `REVIEW.md` に列挙します。取り込まれたファイル内やサブディレクトリの `REVIEW.md` 内の `@` 行はプレーンテキストのまま残り、別のファイルへの Markdown リンクは取り込みになりません。
+* **1 階層のみ**：すべてのファイルをルートの `REVIEW.md` に列挙します。取り込まれたファイル内やサブディレクトリの `REVIEW.md` 内の `@` 行はプレーンテキストのまま残り（[スキルファイルは異なります](#include-a-skill-file)）、別のファイルへの Markdown リンクは取り込みになりません。
 * **上限**：取り込むファイルは異なるファイルで最大 8 つまでとし、`REVIEW.md` とそれが取り込むファイルの合計を 150,000 バイト未満に保ちます。バイト数の上限に達するファイルは、途中で切り詰められるのではなく、ファイル全体がスキップされます。チェック実行では、いずれかの上限によってスキップされた取り込み行の数が報告されます。
-* **リンク**：`REVIEW.md` とそれが取り込むファイル全体で、Markdown リンクを 64 個以下に保ちます。`http`、`https`、`mailto` アドレスへのリンクと `#` アンカーへのリンクは数に含まれません。この上限を超えると、レビューは取り込まれたファイルだけでなく、ルートの `REVIEW.md` 全体をスキップします。その場合、チェック実行では[指示が適用されなかったことが示されます](https://code.claude.com/docs/ja/code-review-troubleshooting.md#the-check-run-mentions-review-md)。
+* **リンク**：`REVIEW.md` とそれが取り込むファイル全体で、Markdown リンクを 64 個以下に保ちます。`http`、`https`、`mailto` アドレスへのリンクと `#` アンカーへのリンクは数に含まれず、[スキルファイル](#include-a-skill-file)内のリンクも含まれません。この上限を超えると、レビューは取り込まれたファイルだけでなく、ルートの `REVIEW.md` 全体をスキップします。その場合、チェック実行では[指示が適用されなかったことが示されます](https://code.claude.com/docs/ja/code-review-troubleshooting.md#the-check-run-mentions-review-md)。
 * **マージ済みのコピー**：取り込むファイルを [`REVIEW.md` が読み込まれるブランチ](#which-branch-review-md-is-read-from)にマージします。レビューは両方を同じコミットから読み込み、プルリクエスト自体の変更から読み込むことはありません。
 
+### スキルファイルを取り込む
+
+[スキル](https://code.claude.com/docs/ja/skills.md)で管理しているガイダンスにレビューを従わせるには、スキルの `SKILL.md` をルートの `REVIEW.md` に取り込みます。Code Review はスキルを実行しません。
+
+`@` と `SKILL.md` へのパスを `.claude/skills/<folder>/SKILL.md` の形式で、単独の行に追加します。
+
+```markdown theme={null}
+# Review instructions
+
+Report at most five Nits per review.
+
+@.claude/skills/api-review/SKILL.md
+
```

</details>

*...以降省略*

</details>


<details>
<summary>2026-10-24</summary>

**変更ファイル:**

```
 docs-ja/pages/accessibility-ja.md                  |   46 +-
 docs-ja/pages/admin-setup-ja.md                    |  124 +-
 docs-ja/pages/advisor-ja.md                        |   52 +-
 docs-ja/pages/agent-teams-ja.md                    |  108 +-
 docs-ja/pages/agent-view-ja.md                     |  258 ++--
 docs-ja/pages/agents-ja.md                         |   56 +-
 docs-ja/pages/amazon-bedrock-ja.md                 |   72 +-
 docs-ja/pages/analytics-ja.md                      |   14 +-
 docs-ja/pages/artifacts-ja.md                      |   80 +-
 docs-ja/pages/authentication-ja.md                 |  114 +-
 docs-ja/pages/auto-mode-classifier-billing-ja.md   |   24 +-
 docs-ja/pages/auto-mode-config-ja.md               |   64 +-
 docs-ja/pages/best-practices-ja.md                 |   80 +-
 docs-ja/pages/champion-kit-ja.md                   |   28 +-
 docs-ja/pages/changelog.md                         |   29 +
 docs-ja/pages/channels-ja.md                       |   42 +-
 docs-ja/pages/channels-reference-ja.md             |   26 +-
 docs-ja/pages/checkpointing-ja.md                  |   20 +-
 docs-ja/pages/chrome-ja.md                         |   42 +-
 docs-ja/pages/claude-apps-gateway-config-ja.md     |  170 +--
 docs-ja/pages/claude-apps-gateway-deploy-ja.md     |  172 ++-
 docs-ja/pages/claude-apps-gateway-ja.md            |  160 +-
 docs-ja/pages/claude-apps-gateway-on-aws-ja.md     |   70 +-
 docs-ja/pages/claude-apps-gateway-on-gcp-ja.md     |   36 +-
 .../pages/claude-apps-gateway-spend-limits-ja.md   |   42 +-
 docs-ja/pages/claude-code-on-the-web-ja.md         |  132 +-
 docs-ja/pages/claude-directory-ja.md               |  169 +--
 docs-ja/pages/claude-platform-on-aws-ja.md         |   20 +-
 docs-ja/pages/claude-projects-ja.md                |  102 +-
 docs-ja/pages/claude-security-ja.md                |   44 +-
 docs-ja/pages/cli-reference-ja.md                  |  174 +--
 docs-ja/pages/cloud-environments-ja.md             |  146 +-
 docs-ja/pages/code-review-costs-ja.md              |   20 +-
 docs-ja/pages/code-review-customize-ja.md          |   24 +-
 docs-ja/pages/code-review-ja.md                    |   50 +-
 docs-ja/pages/code-review-local-ja.md              |   58 +-
 docs-ja/pages/code-review-pull-requests-ja.md      |   28 +-
 docs-ja/pages/code-review-setup-ja.md              |   42 +-
 docs-ja/pages/code-review-troubleshooting-ja.md    |   32 +-
 docs-ja/pages/commands-ja.md                       |  214 +--
 docs-ja/pages/common-workflows-ja.md               |   46 +-
 docs-ja/pages/communications-kit-ja.md             |   22 +-
 docs-ja/pages/computer-use-ja.md                   |   22 +-
 docs-ja/pages/context-window-ja.md                 |   46 +-
 docs-ja/pages/corporate-launcher-ja.md             |   34 +-
 docs-ja/pages/costs-ja.md                          |  132 +-
 docs-ja/pages/cross-session-messaging-ja.md        |  102 +-
 docs-ja/pages/data-usage-ja.md                     |   36 +-
 docs-ja/pages/debug-your-config-ja.md              |   68 +-
 docs-ja/pages/deep-links-ja.md                     |   10 +-
 docs-ja/pages/desktop-ios-simulator-ja.md          |   20 +-
 docs-ja/pages/desktop-ja.md                        |  483 ++++--
 docs-ja/pages/desktop-linux-ja.md                  |   12 +-
 docs-ja/pages/desktop-quickstart-ja.md             |   62 +-
 docs-ja/pages/desktop-scheduled-tasks-ja.md        |   42 +-
 docs-ja/pages/desktop-wsl-ja.md                    |   14 +-
 docs-ja/pages/devcontainer-ja.md                   |   50 +-
 docs-ja/pages/env-vars-ja.md                       |  658 ++++-----
 docs-ja/pages/errors-ja.md                         | 1368 ++++++++---------
 docs-ja/pages/fast-mode-ja.md                      |   44 +-
 docs-ja/pages/feature-availability-ja.md           |  178 +--
 docs-ja/pages/features-overview-ja.md              |  132 +-
 docs-ja/pages/fullscreen-ja.md                     |   54 +-
 docs-ja/pages/gateways-ja.md                       |   36 +-
 docs-ja/pages/github-actions-cloud-providers-ja.md |   32 +-
 docs-ja/pages/github-actions-ja.md                 |   48 +-
 docs-ja/pages/github-enterprise-server-ja.md       |   40 +-
 docs-ja/pages/gitlab-ci-cd-ja.md                   |    4 +-
 docs-ja/pages/glossary-ja.md                       |  138 +-
 docs-ja/pages/goal-ja.md                           |   42 +-
 docs-ja/pages/google-vertex-ai-ja.md               |   40 +-
 docs-ja/pages/headless-ja.md                       |  115 +-
 docs-ja/pages/hipaa-setup-ja.md                    |   68 +-
 docs-ja/pages/hooks-guide-ja.md                    |  172 +--
 docs-ja/pages/hooks-ja.md                          |  354 ++---
 docs-ja/pages/how-claude-code-works-ja.md          |   66 +-
 docs-ja/pages/interactive-mode-ja.md               |  218 +--
 docs-ja/pages/jetbrains-ja.md                      |   20 +-
 docs-ja/pages/keybindings-ja.md                    |   74 +-
 docs-ja/pages/large-codebases-ja.md                |   78 +-
 docs-ja/pages/legal-and-compliance-ja.md           |    8 +-
 docs-ja/pages/llm-gateway-connect-ja.md            |  104 +-
 docs-ja/pages/llm-gateway-ja.md                    |   36 +-
 docs-ja/pages/llm-gateway-protocol-ja.md           |  124 +-
 docs-ja/pages/llm-gateway-rollout-ja.md            |   90 +-
 docs-ja/pages/managed-mcp-ja.md                    |   98 +-
 docs-ja/pages/managed-settings-ja.md               |  208 +--
 docs-ja/pages/mcp-ja.md                            |  432 ++++--
 docs-ja/pages/mcp-quickstart-ja.md                 |   44 +-
 docs-ja/pages/memory-ja.md                         |   94 +-
 docs-ja/pages/microsoft-foundry-ja.md              |   14 +-
 docs-ja/pages/mobile-ja.md                         |   44 +-
 docs-ja/pages/model-config-ja.md                   |  270 ++--
 docs-ja/pages/monitoring-usage-ja.md               |  314 ++--
 docs-ja/pages/network-config-ja.md                 |   88 +-
 docs-ja/pages/output-styles-ja.md                  |   50 +-
 docs-ja/pages/overview-ja.md                       |   96 +-
 docs-ja/pages/permission-modes-ja.md               |  320 ++--
 docs-ja/pages/permissions-ja.md                    |  236 +--
 docs-ja/pages/platforms-ja.md                      |   74 +-
 docs-ja/pages/plugin-evals-ja.md                   |   44 +-
 docs-ja/pages/prompt-caching-ja.md                 |  134 +-
 docs-ja/pages/prompt-library-ja.md                 |   16 +-
 docs-ja/pages/quickstart-ja.md                     |   38 +-
 docs-ja/pages/remote-control-ja.md                 |  128 +-
 docs-ja/pages/routines-ja.md                       |   70 +-
 docs-ja/pages/sandbox-environments-ja.md           |   62 +-
 docs-ja/pages/sandboxing-ja.md                     |  260 ++--
 docs-ja/pages/scheduled-tasks-ja.md                |   52 +-
 docs-ja/pages/security-guidance-ja.md              |   40 +-
 docs-ja/pages/security-ja.md                       |   64 +-
 .../self-hosted-environments-configuration-ja.md   |  187 +--
 .../pages/self-hosted-environments-deploy-ja.md    |  190 +--
 .../pages/self-hosted-environments-identity-ja.md  |   22 +-
 docs-ja/pages/self-hosted-environments-ja.md       |   62 +-
 .../self-hosted-environments-quickstart-ja.md      |   44 +-
 .../pages/self-hosted-environments-reference-ja.md |   80 +-
 .../pages/self-hosted-environments-testing-ja.md   |   20 +-
 docs-ja/pages/server-managed-settings-ja.md        |  116 +-
 docs-ja/pages/sessions-ja.md                       |  123 +-
 docs-ja/pages/settings-example-ja.md               |   20 +-
 docs-ja/pages/settings-ja.md                       |  166 +--
 docs-ja/pages/settings-reference-ja.md             | 1555 ++++++++++----------
 docs-ja/pages/setup-ja.md                          |   70 +-
 docs-ja/pages/skills-ja.md                         |  248 ++--
 docs-ja/pages/slack-ja.md                          |   12 +-
 docs-ja/pages/statusline-ja.md                     |   60 +-
 docs-ja/pages/sub-agents-ja.md                     |  286 ++--
 docs-ja/pages/terminal-config-ja.md                |   78 +-
 docs-ja/pages/third-party-integrations-ja.md       |   46 +-
 docs-ja/pages/tools-reference-ja.md                |  291 ++--
 docs-ja/pages/troubleshoot-install-ja.md           |   68 +-
 docs-ja/pages/troubleshooting-ja.md                |   66 +-
 docs-ja/pages/ultrareview-ja.md                    |   28 +-
 docs-ja/pages/voice-dictation-ja.md                |   34 +-
 docs-ja/pages/vs-code-ja.md                        |  214 +--
 docs-ja/pages/web-quickstart-ja.md                 |   70 +-
 docs-ja/pages/workflows-ja.md                      |   90 +-
 docs-ja/pages/worktrees-ja.md                      |   84 +-
 docs-ja/pages/zero-data-retention-ja.md            |   18 +-
 140 files changed, 8472 insertions(+), 7892 deletions(-)
```

<details>
<summary>accessibility-ja.md</summary>

```diff
diff --git a/docs-ja/pages/accessibility-ja.md b/docs-ja/pages/accessibility-ja.md
index 4bbbc65..68bf9f7 100644
--- a/docs-ja/pages/accessibility-ja.md
+++ b/docs-ja/pages/accessibility-ja.md
@@ -9,5 +9,5 @@
 Claude Code には、ビジュアルターミナルインターフェースをプレーンな線形テキストに置き換えるスクリーンリーダーモードがあります。ボックス、プログレスアニメーション、インプレース再描画の代わりに、Claude Code はラベル付きの行を出力し、VoiceOver や NVDA などのスクリーンリーダーが順番に読み上げます。完全な会話を保持し、ツール権限を承認し、出力を最後まで確認できます。
 
-スクリーンリーダーモードはオプトインです。スクリーン拡大鏡、モーション削減、またはスクリーンリーダーの代わりにカラーブラインド対応テーマを使用する場合は、[アクセシビリティ設定](#accessibility-settings)テーブルから `CLAUDE_CODE_ACCESSIBILITY`、`prefersReducedMotion`、または `theme` を設定してください。スクリーンリーダーモードはターミナルインターフェースのみを適応させるため、VS Code 拡張機能のチャットパネルではこれを必要としません。Claude Code v2.1.236 以降では、拡張機能は設定なしで[スクリーンリーダーにコンバーセーション活動を通知](/docs/ja/vs-code.md#use-a-screen-reader)します。
+スクリーンリーダーモードはオプトインです。スクリーン拡大鏡、モーション削減、またはスクリーンリーダーの代わりにカラーブラインド対応テーマを使用する場合は、[アクセシビリティ設定](#accessibility-settings)テーブルから `CLAUDE_CODE_ACCESSIBILITY`、`prefersReducedMotion`、または `theme` を設定してください。スクリーンリーダーモードはターミナルインターフェースのみを適応させるため、VS Code 拡張機能のチャットパネルではこれを必要としません。Claude Code v2.1.236 以降では、拡張機能は設定なしで[スクリーンリーダーにコンバーセーション活動を通知](https://code.claude.com/docs/ja/vs-code.md#use-a-screen-reader)します。
 
 ## スクリーンリーダーモードをオンにする
@@ -17,7 +17,7 @@ Claude Code には、ビジュアルターミナルインターフェースを
 * 1 つのセッション用：`claude --ax-screen-reader` を実行します。
 * 1 つのシェルから開始されたセッション用：`CLAUDE_AX_SCREEN_READER` 環境変数を `1` に設定します。Bash または Zsh では `export CLAUDE_AX_SCREEN_READER=1` を実行し、PowerShell では `$env:CLAUDE_AX_SCREEN_READER = "1"` を実行します。シェルプロファイルにその行を追加して、今後のシェルでも保持します。
-* マシン上のすべてのセッション用：ユーザー[設定ファイル](/docs/ja/settings.md)に `"axScreenReader": true` を追加します。この設定は VS Code 統合ターミナルを含むすべてのターミナルに適用されます。
+* マシン上のすべてのセッション用：ユーザー[設定ファイル](https://code.claude.com/docs/ja/settings.md)に `"axScreenReader": true` を追加します。この設定は VS Code 統合ターミナルを含むすべてのターミナルに適用されます。
 
-メソッドを組み合わせた場合、Claude Code は [`--ax-screen-reader`](/docs/ja/cli-reference#cli-flags) フラグを [`CLAUDE_AX_SCREEN_READER`](/docs/ja/env-vars#variables) 環境変数より優先し、その環境変数を [`axScreenReader`](/docs/ja/settings-reference#axscreenreader) 設定より優先します。
+メソッドを組み合わせた場合、Claude Code は [`--ax-screen-reader`](https://code.claude.com/docs/ja/cli-reference#cli-flags) フラグを [`CLAUDE_AX_SCREEN_READER`](https://code.claude.com/docs/ja/env-vars#variables) 環境変数より優先し、その環境変数を [`axScreenReader`](https://code.claude.com/docs/ja/settings-reference#axscreenreader) 設定より優先します。
 
 SSH 経由で Claude Code を使用する場合は、Claude Code が実行されるリモートマシンで環境変数または設定を設定します。
@@ -29,5 +29,5 @@ Claude Code が最初に出力する行がモードを確認します。`[Screen
 起動時に `Screen reader mode is off: project settings can't turn it on` という行が表示される場合、プロジェクトがスクリーンリーダーモードを要求しており、ほかにモードをオンにするものがないことを意味します。Claude Code は、プロジェクトの `.claude/settings.json` および `.claude/settings.local.json` にある `axScreenReader` キーと、`env` 配下の `CLAUDE_AX_SCREEN_READER` の値を、その値にかかわらずどちらも無視します。
 
-* **モードをオンにするには**：`--ax-screen-reader` を指定して Claude Code を起動するか、シェルで `CLAUDE_AX_SCREEN_READER` を `1` に設定するか、ユーザー[設定ファイル](/docs/ja/settings.md)に `"axScreenReader": true` を追加して Claude Code を再起動します。プロジェクトのファイルを変更する必要はありません。モードをオンにすると、起動時には代わりに[確認の行](#turn-on-screen-reader-mode)が表示されます。
+* **モードをオンにするには**：`--ax-screen-reader` を指定して Claude Code を起動するか、シェルで `CLAUDE_AX_SCREEN_READER` を `1` に設定するか、ユーザー[設定ファイル](https://code.claude.com/docs/ja/settings.md)に `"axScreenReader": true` を追加して Claude Code を再起動します。プロジェクトのファイルを変更する必要はありません。モードをオンにすると、起動時には代わりに[確認の行](#turn-on-screen-reader-mode)が表示されます。
 * **スクリーンリーダーを使用しない場合**：何もする必要はありません。この行を表示しないようにするには、ユーザー設定ファイルに `"axScreenReader": false` を追加するか、プロジェクトの設定ファイルから `axScreenReader` キーと `CLAUDE_AX_SCREEN_READER` 変数を削除します。
 
@@ -42,13 +42,13 @@ Claude Code が最初に出力する行がモードを確認します。`[Screen
 | オプション | タイプ | 変更内容 |
```

</details>

<details>
<summary>admin-setup-ja.md</summary>

```diff
diff --git a/docs-ja/pages/admin-setup-ja.md b/docs-ja/pages/admin-setup-ja.md
index 8779894..6d41fed 100644
--- a/docs-ja/pages/admin-setup-ja.md
+++ b/docs-ja/pages/admin-setup-ja.md
@@ -17,9 +17,9 @@ Claude Code は、ローカル開発者設定よりも優先されるマネー
 | 決定 | 選択内容 | 参照 |
 | :- | :- | :- |
-| [API プロバイダーを選択する](#choose-your-api-provider) | Claude Code が認証される場所と課金方法 | [Authentication](/docs/ja/authentication.md)、[Amazon Bedrock](/docs/ja/amazon-bedrock.md)、[Google Cloud の Agent Platform](/docs/ja/google-vertex-ai.md)、[Microsoft Foundry](/docs/ja/microsoft-foundry.md) |
-| [設定がデバイスに到達する方法を決定する](#decide-how-settings-reach-devices) | マネージドポリシーが開発者マシンに到達する方法 | [Server-managed settings](/docs/ja/server-managed-settings.md)、[Delivery mechanisms](/docs/ja/managed-settings.md#delivery-mechanisms) |
-| [実行する内容を決定する](#decide-what-to-enforce) | どのツール、コマンド、統合が許可されるか | [Permissions](/docs/ja/permissions.md)、[Sandboxing](/docs/ja/sandboxing.md) |
-| [使用状況の可視性をセットアップする](#set-up-usage-visibility) | 支出と採用を追跡する方法 | [Analytics](/docs/ja/analytics.md)、[Monitoring](/docs/ja/monitoring-usage.md)、[Costs](/docs/ja/costs.md) |
-| [データ処理を確認する](#review-data-handling) | データ保持とコンプライアンス体制 | [Data usage](/docs/ja/data-usage.md)、[Security](/docs/ja/security.md) |
+| [API プロバイダーを選択する](#choose-your-api-provider) | Claude Code が認証される場所と課金方法 | [Authentication](https://code.claude.com/docs/ja/authentication.md)、[Amazon Bedrock](https://code.claude.com/docs/ja/amazon-bedrock.md)、[Google Cloud の Agent Platform](https://code.claude.com/docs/ja/google-vertex-ai.md)、[Microsoft Foundry](https://code.claude.com/docs/ja/microsoft-foundry.md) |
+| [設定がデバイスに到達する方法を決定する](#decide-how-settings-reach-devices) | マネージドポリシーが開発者マシンに到達する方法 | [Server-managed settings](https://code.claude.com/docs/ja/server-managed-settings.md)、[Delivery mechanisms](https://code.claude.com/docs/ja/managed-settings.md#delivery-mechanisms) |
+| [実行する内容を決定する](#decide-what-to-enforce) | どのツール、コマンド、統合が許可されるか | [Permissions](https://code.claude.com/docs/ja/permissions.md)、[Sandboxing](https://code.claude.com/docs/ja/sandboxing.md) |
+| [使用状況の可視性をセットアップする](#set-up-usage-visibility) | 支出と採用を追跡する方法 | [Analytics](https://code.claude.com/docs/ja/analytics.md)、[Monitoring](https://code.claude.com/docs/ja/monitoring-usage.md)、[Costs](https://code.claude.com/docs/ja/costs.md) |
+| [データ処理を確認する](#review-data-handling) | データ保持とコンプライアンス体制 | [Data usage](https://code.claude.com/docs/ja/data-usage.md)、[Security](https://code.claude.com/docs/ja/security.md) |
 
 ## API プロバイダーを選択する
@@ -35,34 +35,34 @@ Claude Code は複数の API プロバイダーのいずれかを通じて Claud
 | Microsoft Foundry | 既存の Azure コンプライアンス制御と課金を継承したい場合 |
 
-一部の Claude Code 機能には claude.ai アカウントが必要です。[クラウドセッション](/docs/ja/claude-code-on-the-web.md)、[クラウドのスケジュールタスク](/docs/ja/routines.md)、[Code Review](/docs/ja/code-review.md)、[Remote Control](/docs/ja/remote-control.md)、および [Chrome 拡張機能](/docs/ja/chrome.md) は、Console API キーまたはクラウドプロバイダーの認証情報だけでは利用できません。Amazon Bedrock、Google Cloud の Agent Platform、または Microsoft Foundry を通じてデプロイする場合は、開発者が Claude for Teams または Enterprise シートも必要かどうかを検討してください。各機能ページにはプラン要件が記載されています。
+一部の Claude Code 機能には claude.ai アカウントが必要です。[クラウドセッション](https://code.claude.com/docs/ja/claude-code-on-the-web.md)、[クラウドのスケジュールタスク](https://code.claude.com/docs/ja/routines.md)、[Code Review](https://code.claude.com/docs/ja/code-review.md)、[Remote Control](https://code.claude.com/docs/ja/remote-control.md)、および [Chrome 拡張機能](https://code.claude.com/docs/ja/chrome.md) は、Console API キーまたはクラウドプロバイダーの認証情報だけでは利用できません。Amazon Bedrock、Google Cloud の Agent Platform、または Microsoft Foundry を通じてデプロイする場合は、開発者が Claude for Teams または Enterprise シートも必要かどうかを検討してください。各機能ページにはプラン要件が記載されています。
 
-認証、リージョン、機能パリティをカバーする完全なプロバイダー比較については、[エンタープライズ展開概要](/docs/ja/third-party-integrations.md) を参照してください。各プロバイダーの認証セットアップは [Authentication](/docs/ja/authentication.md) にあります。
+認証、リージョン、機能パリティをカバーする完全なプロバイダー比較については、[エンタープライズ展開概要](https://code.claude.com/docs/ja/third-party-integrations.md) を参照してください。各プロバイダーの認証セットアップは [Authentication](https://code.claude.com/docs/ja/authentication.md) にあります。
 
-[ネットワーク設定](/docs/ja/network-config.md) のプロキシとファイアウォール要件は、プロバイダーに関係なく適用されます。複数のプロバイダーの前に単一のエンドポイントを配置したい場合、または集中化されたリクエストログを記録したい場合は、[LLM gateway](/docs/ja/llm-gateway) を参照してください。
+[ネットワーク設定](https://code.claude.com/docs/ja/network-config.md) のプロキシとファイアウォール要件は、プロバイダーに関係なく適用されます。複数のプロバイダーの前に単一のエンドポイントを配置したい場合、または集中化されたリクエストログを記録したい場合は、[LLM gateway](https://code.claude.com/docs/ja/llm-gateway) を参照してください。
```

</details>

<details>
<summary>advisor-ja.md</summary>

```diff
diff --git a/docs-ja/pages/advisor-ja.md b/docs-ja/pages/advisor-ja.md
index 337715c..aa9edfb 100644
--- a/docs-ja/pages/advisor-ja.md
+++ b/docs-ja/pages/advisor-ja.md
@@ -21,5 +21,5 @@ advisor は Anthropic インフラストラクチャ上でサーバー側で実
 advisor は、ほとんどのターンが定型的であるが、プラン品質が結果を決定する長い複数ステップのタスクに適しています。例としては、大規模なリファクタリング、エラーが繰り返し発生するデバッグセッション、および Claude が完了を宣言する前に独立して確認したいタスクが挙げられます。
 
-計画する必要がほとんどない短いタスク、またはすべてのターンで最強のモデルが必要な作業では、価値が低くなります。その場合は、[メインモデルを切り替える](/docs/ja/model-config.md#setting-your-model)か、[advisor が opusplan およびサブエージェントとどのように比較されるか](#compare-with-related-features)を参照して、2 番目の意見を得る他の方法を確認してください。
+計画する必要がほとんどない短いタスク、またはすべてのターンで最強のモデルが必要な作業では、価値が低くなります。その場合は、[メインモデルを切り替える](https://code.claude.com/docs/ja/model-config.md#setting-your-model)か、[advisor が opusplan およびサブエージェントとどのように比較されるか](#compare-with-related-features)を参照して、2 番目の意見を得る他の方法を確認してください。
 
 ## advisor を有効にする
@@ -28,10 +28,10 @@ advisor モデルは 3 つの方法で設定できます。
 
 * **`/advisor` コマンド**：セッション中に advisor を設定または変更し、デフォルトとして保存します
-* **`advisorModel` 設定**：[設定ファイル](/docs/ja/settings.md)で永続的なデフォルトを構成します
+* **`advisorModel` 設定**：[設定ファイル](https://code.claude.com/docs/ja/settings.md)で永続的なデフォルトを構成します
 * **`--advisor` フラグ**：起動時に単一セッションの advisor を設定します
 
 これらのいずれかが advisor を有効にするのは、メインモデルが[それをサポートしている](#choose-an-advisor-model)セッションです。セッションが開始されると、Claude Code は `Advisor Tool (experimental) is on and may use more tokens · /advisor` 通知を表示します。advisor の使用を停止するには、[advisor をオフにする](#turn-the-advisor-off)を参照してください。
 
-一部のプランでは、Fable を advisor として使用する場合、Fable の使用を使用クレジットに請求することへの 1 回限りの[同意](/docs/ja/model-config.md#fable-and-usage-credits)も必要です。その同意を与える前に何が起こるかについては、[Fable advisor と使用クレジット](#fable-advisor-and-usage-credits)を参照してください。
+一部のプランでは、Fable を advisor として使用する場合、Fable の使用を使用クレジットに請求することへの 1 回限りの[同意](https://code.claude.com/docs/ja/model-config.md#fable-and-usage-credits)も必要です。その同意を与える前に何が起こるかについては、[Fable advisor と使用クレジット](#fable-advisor-and-usage-credits)を参照してください。
 
 ### `/advisor` コマンドを使用する
@@ -43,7 +43,7 @@ advisor モデルは 3 つの方法で設定できます。
 ```
 
-コマンドは `Advisor set to` で確認し、その後に advisor モデル名が続きます。選択はユーザー設定の `advisorModel` に保存され、セッション全体で保持されます。ただし、[`advisorModel` エントリ](/docs/ja/settings-reference#advisormodel)が現在のセッションにのみ適用されるとリストしている場合は除きます。
+コマンドは `Advisor set to` で確認し、その後に advisor モデル名が続きます。選択はユーザー設定の `advisorModel` に保存され、セッション全体で保持されます。ただし、[`advisorModel` エントリ](https://code.claude.com/docs/ja/settings-reference#advisormodel)が現在のセッションにのみ適用されるとリストしている場合は除きます。
 
```

</details>

<details>
<summary>agent-teams-ja.md</summary>

```diff
diff --git a/docs-ja/pages/agent-teams-ja.md b/docs-ja/pages/agent-teams-ja.md
index 6529df8..e318c9a 100644
--- a/docs-ja/pages/agent-teams-ja.md
+++ b/docs-ja/pages/agent-teams-ja.md
@@ -9,9 +9,9 @@
 > [!WARNING]
 >
-> エージェントチームは実験的機能であり、デフォルトでは無効になっています。[settings.json](/docs/ja/settings.md) または環境に `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1` を設定して有効にしてください。その変数がない場合、セッション開始時にチームが設定されず、チームディレクトリが書き込まれず、Claude はチームメンバーをスポーンまたは提案しません。エージェントチームには、セッション再開、タスク調整、シャットダウン動作に関する[既知の制限](#limitations)があります。
+> エージェントチームは実験的機能であり、デフォルトでは無効になっています。[settings.json](https://code.claude.com/docs/ja/settings.md) または環境に `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1` を設定して有効にしてください。その変数がない場合、セッション開始時にチームが設定されず、チームディレクトリが書き込まれず、Claude はチームメンバーをスポーンまたは提案しません。エージェントチームには、セッション再開、タスク調整、シャットダウン動作に関する[既知の制限](#limitations)があります。
 
 エージェントチームを使用すると、複数の Claude Code インスタンスが連携して動作するように調整できます。1 つのセッションがチームリーダーとして機能し、作業を調整し、タスクを割り当て、結果を統合します。チームメンバーは独立して動作し、それぞれ独自のコンテキストウィンドウで動作し、互いに直接通信します。リーダーを経由せずに、任意のチームメンバーと直接対話することもできます。
 
-チームを設定する前に、より軽量なオプションで十分かどうかを確認してください。[Subagents](/docs/ja/sub-agents.md) は単一セッション内で動作し、[クロスセッションメッセージング](/docs/ja/cross-session-messaging.md) を使用すると Claude は自分で実行するセッション間で検出結果を渡すことができます。
+チームを設定する前に、より軽量なオプションで十分かどうかを確認してください。[Subagents](https://code.claude.com/docs/ja/sub-agents.md) は単一セッション内で動作し、[クロスセッションメッセージング](https://code.claude.com/docs/ja/cross-session-messaging.md) を使用すると Claude は自分で実行するセッション間で検出結果を渡すことができます。
 
 ## エージェントチームを使用する場合
@@ -24,9 +24,9 @@
 * **クロスレイヤー調整**：フロントエンド、バックエンド、テストにまたがる変更で、それぞれ異なるチームメンバーが担当します
 
-エージェントチームは調整オーバーヘッドを追加し、単一セッションよりも大幅に多くのトークンを使用します。チームメンバーが独立して動作できる場合に最も効果的です。順序付きタスク、同じファイルの編集、または多くの依存関係を持つ作業の場合は、単一セッションまたは [subagents](/docs/ja/sub-agents.md) がより効果的です。
+エージェントチームは調整オーバーヘッドを追加し、単一セッションよりも大幅に多くのトークンを使用します。チームメンバーが独立して動作できる場合に最も効果的です。順序付きタスク、同じファイルの編集、または多くの依存関係を持つ作業の場合は、単一セッションまたは [subagents](https://code.claude.com/docs/ja/sub-agents.md) がより効果的です。
 
 ### subagents との比較
 
-エージェントチームと [subagents](/docs/ja/sub-agents.md) の両方を使用すると、作業を並列化できますが、動作方法が異なります。チームなしでメッセージを相互に渡す別々のセッションについては、[クロスセッションメッセージング](/docs/ja/cross-session-messaging.md)を参照してください。
+エージェントチームと [subagents](https://code.claude.com/docs/ja/sub-agents.md) の両方を使用すると、作業を並列化できますが、動作方法が異なります。チームなしでメッセージを相互に渡す別々のセッションについては、[クロスセッションメッセージング](https://code.claude.com/docs/ja/cross-session-messaging.md)を参照してください。
 
 ![Subagent とエージェントチームのアーキテクチャを比較する図。Subagents はメインエージェントによって生成され、作業を実行し、結果を報告します。エージェントチームは共有タスクリストを通じて調整され、チームメンバーが互いに直接通信します。](https://mintcdn.com/claude-code/nsvRFSDNfpSU5nT7/images/subagents-vs-agent-teams-light.png?fit=max\&auto=format\&n=nsvRFSDNfpSU5nT7\&q=85\&s=2f8db9b4f3705dd3ab931fbe2d96e42a)
@@ -37,6 +37,6 @@ Subagents は結果をメインエージェントに報告します。エージ
 | :- | :- | :- |
```

</details>

<details>
<summary>agent-view-ja.md</summary>

```diff
diff --git a/docs-ja/pages/agent-view-ja.md b/docs-ja/pages/agent-view-ja.md
index 01ddc75..5a8458c 100644
--- a/docs-ja/pages/agent-view-ja.md
+++ b/docs-ja/pages/agent-view-ja.md
@@ -15,5 +15,5 @@ Claude が複数の独立したタスクに対して、あなたが毎ステッ
 任意のエージェントのセッションでより直接的に作業したい場合は、行にアタッチして完全な会話に入ります。
 
-エージェントビューを subagents、agent teams、worktrees と比較するには、[エージェントを並列で実行する](/docs/ja/agents.md)を参照してください。エージェントビューはあなたのマシン上でセッションを実行し、各セッションをディスパッチします。1 つの会話からクラウドで Claude が並列セッションを開始して追跡するには、[Projects](/docs/ja/claude-projects.md)を参照してください。
+エージェントビューを subagents、agent teams、worktrees と比較するには、[エージェントを並列で実行する](https://code.claude.com/docs/ja/agents.md)を参照してください。エージェントビューはあなたのマシン上でセッションを実行し、各セッションをディスパッチします。1 つの会話からクラウドで Claude が並列セッションを開始して追跡するには、[Projects](https://code.claude.com/docs/ja/claude-projects.md)を参照してください。
 
 > [!NOTE]
@@ -33,5 +33,5 @@ claude agents
 ```
 
-まだディレクトリの[ワークスペーストラストダイアログ](/docs/ja/permissions.md#project-allow-rules-and-workspace-trust)を受け入れていない場合、Claude Code はエージェントビューが開く前にそれを表示します。これは `claude` が表示するのと同じダイアログです。受け入れてワークスペースの信頼を保存して続行します。拒否すると、Claude Code はエージェントビューを開かずに終了します。
+まだディレクトリの[ワークスペーストラストダイアログ](https://code.claude.com/docs/ja/permissions.md#project-allow-rules-and-workspace-trust)を受け入れていない場合、Claude Code はエージェントビューが開く前にそれを表示します。これは `claude` が表示するのと同じダイアログです。受け入れてワークスペースの信頼を保存して続行します。拒否すると、Claude Code はエージェントビューを開かずに終了します。
 
 エージェントビューが開き、下部に入力フィールドが表示され、セッションが開始されるとテーブルが埋まります。`Esc` を押すとシェルに戻ります。`←` でセッションをバックグラウンドにしてエージェントビューを開いた場合、`Esc` はそのセッションの会話に戻ります。セッションは離れている間も実行し続け、次にエージェントビューを開いたときに再度表示されます。
@@ -65,5 +65,5 @@ claude agents
 * **完了数**: 入力を待機しているセッションがない状態でバックグラウンドセッションが正常に完了すると、フッターに完了した数が一時的に表示されます。たとえば 2 つの場合は `← 2 done` と表示されます
 
-待機中の数は、増減したとき、およびバックグラウンドセッションが正常に完了したときに一時的に色が変わります。[`prefersReducedMotion`](/docs/ja/settings-reference#prefersreducedmotion) をオンにすると、色の変化も `done` のカウントも表示されません。[スクリーンリーダーモード](/docs/ja/accessibility.md)では、`←` ヒントとそのカウントは非表示になります。
+待機中の数は、増減したとき、およびバックグラウンドセッションが正常に完了したときに一時的に色が変わります。[`prefersReducedMotion`](https://code.claude.com/docs/ja/settings-reference#prefersreducedmotion) をオンにすると、色の変化も `done` のカウントも表示されません。[スクリーンリーダーモード](https://code.claude.com/docs/ja/accessibility.md)では、`←` ヒントとそのカウントは非表示になります。
 
 ### デフォルトでエージェントビューを開く
@@ -73,5 +73,5 @@ claude agents
 **1. 設定をオンにする**
 
-通常の `claude` セッションで `/config` を実行し、**デフォルトでエージェントビューを開く**をオンにします。メニューをスキップするには、[`defaultToAgentsView`](/docs/ja/settings-reference#defaulttoagentsview) キーを直接設定します。
+通常の `claude` セッションで `/config` を実行し、**デフォルトでエージェントビューを開く**をオンにします。メニューをスキップするには、[`defaultToAgentsView`](https://code.claude.com/docs/ja/settings-reference#defaulttoagentsview) キーを直接設定します。
```

</details>

<details>
<summary>agents-ja.md</summary>

```diff
diff --git a/docs-ja/pages/agents-ja.md b/docs-ja/pages/agents-ja.md
index 05cc96a..c5a6431 100644
--- a/docs-ja/pages/agents-ja.md
+++ b/docs-ja/pages/agents-ja.md
@@ -7,31 +7,31 @@
 > Claude Code が複数のタスクを同時に実行する 5 つの方法を比較します。サブエージェント、エージェントビュー、エージェントチーム、動的ワークフロー、およびプロジェクトについて説明します。
 
-Claude Code には、複数のタスクを同時に処理する 5 つの方法があります。[サブエージェント](/docs/ja/sub-agents.md)、[エージェントビュー](/docs/ja/agent-view.md)、[エージェントチーム](/docs/ja/agent-teams.md)、[動的ワークフロー](/docs/ja/workflows.md)、および [プロジェクト](/docs/ja/claude-projects.md) です。これらは、各会話に自分で留まるのか、Claude にワーカーのグループを調整させるのかという関与の度合いや、作業がマシン上で実行されるのかクラウドで実行されるのかという点で異なります。
+Claude Code には、複数のタスクを同時に処理する 5 つの方法があります。[サブエージェント](https://code.claude.com/docs/ja/sub-agents.md)、[エージェントビュー](https://code.claude.com/docs/ja/agent-view.md)、[エージェントチーム](https://code.claude.com/docs/ja/agent-teams.md)、[動的ワークフロー](https://code.claude.com/docs/ja/workflows.md)、および [プロジェクト](https://code.claude.com/docs/ja/claude-projects.md) です。これらは、各会話に自分で留まるのか、Claude にワーカーのグループを調整させるのかという関与の度合いや、作業がマシン上で実行されるのかクラウドで実行されるのかという点で異なります。
 
 | アプローチ | 提供内容 | 使用する場合 |
 | :- | :- | :- |
-| [サブエージェント](/docs/ja/sub-agents.md) | 1 つのセッション内で委任されたワーカーが、独自のコンテキストでサイドタスクを実行し、サマリーを返す | サイドタスクが検索結果、ログ、またはファイルコンテンツで主な会話を埋め尽くす場合（再度参照しない） |
-| [エージェントビュー](/docs/ja/agent-view.md) | `claude agents` で開く、バックグラウンドで実行されているセッションをディスパッチして監視する 1 つの画面。リサーチプレビュー | 複数の独立したタスクがあり、それらを引き継いで、一目で状態を確認し、必要な場合のみ介入したい場合 |
-| [エージェントチーム](/docs/ja/agent-teams.md) | 共有タスクリストとエージェント間メッセージングを備えた複数の調整されたセッション。リーダーによって管理される。実験的で、デフォルトでは無効 | Claude にプロジェクトを分割させ、割り当てさせ、ワーカーを同期させたい場合 |
-| [プロジェクト](/docs/ja/claude-projects.md) | claude.ai/code またはデスクトップアプリでの 1 つの継続的な会話。Claude は threads と呼ばれる並列セッションを開始し、クラウドで、またはリモートコントロール経由でコンピューターで実行し、各セッションにプロジェクトの指示を提供し、どのセッションがあなたを必要としているかを表示します。Pro および Max でのパブリックベータ | 作業が数日または数週間にわたる多くのタスクに及び、マシンがオフの場合でも実行を続け、各セッションをディスパッチして追跡するのではなく、一度説明したい場合 |
-| [動的ワークフロー](/docs/ja/workflows.md) | 多くのサブエージェントを実行し、その結果をチェックするスクリプト。1 回のターンで調整するには大きすぎるジョブ向け | タスクが大きすぎてサブエージェント数個では対応できない場合、または検出結果を相互に検証したい場合。コードベース全体の監査、500 ファイルのマイグレーション、相互検証が必要な調査、または複数の角度から作成されたプランなど |
+| [サブエージェント](https://code.claude.com/docs/ja/sub-agents.md) | 1 つのセッション内で委任されたワーカーが、独自のコンテキストでサイドタスクを実行し、サマリーを返す | サイドタスクが検索結果、ログ、またはファイルコンテンツで主な会話を埋め尽くす場合（再度参照しない） |
+| [エージェントビュー](https://code.claude.com/docs/ja/agent-view.md) | `claude agents` で開く、バックグラウンドで実行されているセッションをディスパッチして監視する 1 つの画面。リサーチプレビュー | 複数の独立したタスクがあり、それらを引き継いで、一目で状態を確認し、必要な場合のみ介入したい場合 |
+| [エージェントチーム](https://code.claude.com/docs/ja/agent-teams.md) | 共有タスクリストとエージェント間メッセージングを備えた複数の調整されたセッション。リーダーによって管理される。実験的で、デフォルトでは無効 | Claude にプロジェクトを分割させ、割り当てさせ、ワーカーを同期させたい場合 |
+| [プロジェクト](https://code.claude.com/docs/ja/claude-projects.md) | claude.ai/code またはデスクトップアプリでの 1 つの継続的な会話。Claude は threads と呼ばれる並列セッションを開始し、クラウドで、またはリモートコントロール経由でコンピューターで実行し、各セッションにプロジェクトの指示を提供し、どのセッションがあなたを必要としているかを表示します。Pro および Max でのパブリックベータ | 作業が数日または数週間にわたる多くのタスクに及び、マシンがオフの場合でも実行を続け、各セッションをディスパッチして追跡するのではなく、一度説明したい場合 |
+| [動的ワークフロー](https://code.claude.com/docs/ja/workflows.md) | 多くのサブエージェントを実行し、その結果をチェックするスクリプト。1 回のターンで調整するには大きすぎるジョブ向け | タスクが大きすぎてサブエージェント数個では対応できない場合、または検出結果を相互に検証したい場合。コードベース全体の監査、500 ファイルのマイグレーション、相互検証が必要な調査、または複数の角度から作成されたプランなど |
 
-すべてのアプローチにおいて、ワーカーは Claude セッションです。別のツールを関与させるには、それを Claude に [MCP サーバー](/docs/ja/mcp.md) として公開します。
+すべてのアプローチにおいて、ワーカーは Claude セッションです。別のツールを関与させるには、それを Claude に [MCP サーバー](https://code.claude.com/docs/ja/mcp.md) として公開します。
 
 この作業をサポートする 3 つの追加ツールがありますが、エージェント自体を実行する方法ではありません。
 
-* [Worktree](/docs/ja/worktrees.md) は各セッションに個別の git チェックアウトを提供するため、並列セッションはそれぞれ自分のファイルのコピーを編集します。自分で実行するセッションに使用します。エージェントビューからディスパッチしたセッションは、[ファイルを編集する前に専用の worktree に移動](/docs/ja/agent-view.md#how-file-edits-are-isolated) し、スポーンするサブエージェントもそれぞれ worktree を取得できます。
-* [クロスセッションメッセージング](/docs/ja/cross-session-messaging.md) により、Claude はこのマシン上、別のマシン上、または [クラウド](/docs/ja/claude-code-on-the-web.md) 上の他の Claude Code セッションをリストして、メッセージを送信できます。自分で実行するセッションは、検出結果とステータスを相互に渡すことができます。
```

</details>

*...以降省略*

</details>


<details>
<summary>2026-10-23</summary>

**変更ファイル:**

```
 docs-ja/pages/accessibility-ja.md                  |   29 +-
 docs-ja/pages/admin-setup-ja.md                    |  118 +-
 docs-ja/pages/advisor-ja.md                        |   38 +-
 docs-ja/pages/agent-teams-ja.md                    |   89 +-
 docs-ja/pages/agent-view-ja.md                     |  172 +--
 docs-ja/pages/agents-ja.md                         |   56 +-
 docs-ja/pages/amazon-bedrock-ja.md                 |   50 +-
 docs-ja/pages/analytics-ja.md                      |   14 +-
 docs-ja/pages/artifacts-ja.md                      |   72 +-
 docs-ja/pages/authentication-ja.md                 |   86 +-
 docs-ja/pages/auto-mode-classifier-billing-ja.md   |   22 +-
 docs-ja/pages/auto-mode-config-ja.md               |   60 +-
 docs-ja/pages/best-practices-ja.md                 |   72 +-
 docs-ja/pages/champion-kit-ja.md                   |   28 +-
 docs-ja/pages/changelog.md                         |   86 ++
 docs-ja/pages/channels-ja.md                       |   42 +-
 docs-ja/pages/channels-reference-ja.md             |   24 +-
 docs-ja/pages/checkpointing-ja.md                  |   28 +-
 docs-ja/pages/chrome-ja.md                         |   32 +-
 docs-ja/pages/claude-apps-gateway-config-ja.md     |  149 +-
 docs-ja/pages/claude-apps-gateway-deploy-ja.md     |  283 ++--
 docs-ja/pages/claude-apps-gateway-ja.md            |  136 +-
 docs-ja/pages/claude-apps-gateway-on-aws-ja.md     |   85 +-
 docs-ja/pages/claude-apps-gateway-on-gcp-ja.md     |   28 +-
 .../pages/claude-apps-gateway-spend-limits-ja.md   |   18 +-
 docs-ja/pages/claude-code-on-the-web-ja.md         |  116 +-
 docs-ja/pages/claude-directory-ja.md               |  144 +-
 docs-ja/pages/claude-platform-on-aws-ja.md         |   18 +-
 docs-ja/pages/claude-projects-ja.md                |  110 +-
 docs-ja/pages/claude-security-ja.md                |   40 +-
 docs-ja/pages/cli-reference-ja.md                  |  162 +-
 docs-ja/pages/cloud-environments-ja.md             |  104 +-
 docs-ja/pages/code-review-costs-ja.md              |   20 +-
 docs-ja/pages/code-review-customize-ja.md          |   20 +-
 docs-ja/pages/code-review-ja.md                    |   46 +-
 docs-ja/pages/code-review-local-ja.md              |   52 +-
 docs-ja/pages/code-review-pull-requests-ja.md      |   52 +-
 docs-ja/pages/code-review-setup-ja.md              |   38 +-
 docs-ja/pages/code-review-troubleshooting-ja.md    |   31 +-
 docs-ja/pages/commands-ja.md                       |  210 +--
 docs-ja/pages/common-workflows-ja.md               |   38 +-
 docs-ja/pages/communications-kit-ja.md             |   22 +-
 docs-ja/pages/computer-use-ja.md                   |   22 +-
 docs-ja/pages/context-window-ja.md                 |   46 +-
 docs-ja/pages/corporate-launcher-ja.md             |   28 +-
 docs-ja/pages/costs-ja.md                          |  113 +-
 docs-ja/pages/cross-session-messaging-ja.md        |   82 +-
 docs-ja/pages/data-usage-ja.md                     |   34 +-
 docs-ja/pages/debug-your-config-ja.md              |   59 +-
 docs-ja/pages/deep-links-ja.md                     |   10 +-
 docs-ja/pages/desktop-ios-simulator-ja.md          |   20 +-
 docs-ja/pages/desktop-ja.md                        |  388 +++--
 docs-ja/pages/desktop-linux-ja.md                  |   12 +-
 docs-ja/pages/desktop-quickstart-ja.md             |   62 +-
 docs-ja/pages/desktop-scheduled-tasks-ja.md        |   38 +-
 docs-ja/pages/desktop-wsl-ja.md                    |   14 +-
 docs-ja/pages/devcontainer-ja.md                   |   48 +-
 docs-ja/pages/env-vars-ja.md                       |  604 ++++----
 docs-ja/pages/errors-ja.md                         | 1620 +++++++++++---------
 docs-ja/pages/fast-mode-ja.md                      |   36 +-
 docs-ja/pages/feature-availability-ja.md           |  176 +--
 docs-ja/pages/features-overview-ja.md              |  130 +-
 docs-ja/pages/fullscreen-ja.md                     |   26 +-
 docs-ja/pages/gateways-ja.md                       |   18 +-
 docs-ja/pages/github-actions-cloud-providers-ja.md |   32 +-
 docs-ja/pages/github-actions-ja.md                 |   46 +-
 docs-ja/pages/github-enterprise-server-ja.md       |   38 +-
 docs-ja/pages/gitlab-ci-cd-ja.md                   |    4 +-
 docs-ja/pages/glossary-ja.md                       |  136 +-
 docs-ja/pages/goal-ja.md                           |   32 +-
 docs-ja/pages/google-vertex-ai-ja.md               |   28 +-
 docs-ja/pages/headless-ja.md                       |   84 +-
 docs-ja/pages/hipaa-setup-ja.md                    |   54 +-
 docs-ja/pages/hooks-guide-ja.md                    |  149 +-
 docs-ja/pages/hooks-ja.md                          |  301 ++--
 docs-ja/pages/how-claude-code-works-ja.md          |   62 +-
 docs-ja/pages/interactive-mode-ja.md               |  162 +-
 docs-ja/pages/jetbrains-ja.md                      |   10 +-
 docs-ja/pages/keybindings-ja.md                    |   61 +-
 docs-ja/pages/large-codebases-ja.md                |   68 +-
 docs-ja/pages/legal-and-compliance-ja.md           |    8 +-
 docs-ja/pages/llm-gateway-connect-ja.md            |   88 +-
 docs-ja/pages/llm-gateway-ja.md                    |   32 +-
 docs-ja/pages/llm-gateway-protocol-ja.md           |   90 +-
 docs-ja/pages/llm-gateway-rollout-ja.md            |   82 +-
 docs-ja/pages/managed-mcp-ja.md                    |  258 ++--
 docs-ja/pages/managed-settings-ja.md               |  108 +-
 docs-ja/pages/mcp-ja.md                            |  193 ++-
 docs-ja/pages/mcp-quickstart-ja.md                 |   38 +-
 docs-ja/pages/memory-ja.md                         |  102 +-
 docs-ja/pages/microsoft-foundry-ja.md              |   12 +-
 docs-ja/pages/mobile-ja.md                         |   44 +-
 docs-ja/pages/model-config-ja.md                   |  198 +--
 docs-ja/pages/monitoring-usage-ja.md               |  168 +-
 docs-ja/pages/network-config-ja.md                 |   74 +-
 docs-ja/pages/output-styles-ja.md                  |   46 +-
 docs-ja/pages/overview-ja.md                       |   92 +-
 docs-ja/pages/permission-modes-ja.md               |  282 ++--
 docs-ja/pages/permissions-ja.md                    |  220 +--
 docs-ja/pages/platforms-ja.md                      |   74 +-
 docs-ja/pages/plugin-evals-ja.md                   |   42 +-
 docs-ja/pages/prompt-caching-ja.md                 |   98 +-
 docs-ja/pages/prompt-library-ja.md                 |   14 +-
 docs-ja/pages/quickstart-ja.md                     |   32 +-
 docs-ja/pages/remote-control-ja.md                 |  116 +-
 docs-ja/pages/routines-ja.md                       |   81 +-
 docs-ja/pages/sandbox-environments-ja.md           |   60 +-
 docs-ja/pages/sandboxing-ja.md                     |  180 ++-
 docs-ja/pages/scheduled-tasks-ja.md                |   46 +-
 docs-ja/pages/security-guidance-ja.md              |   36 +-
 docs-ja/pages/security-ja.md                       |   60 +-
 .../self-hosted-environments-configuration-ja.md   |  188 ++-
 .../pages/self-hosted-environments-deploy-ja.md    |  254 +--
 .../pages/self-hosted-environments-identity-ja.md  |   18 +-
 docs-ja/pages/self-hosted-environments-ja.md       |   54 +-
 .../self-hosted-environments-quickstart-ja.md      |   42 +-
 .../pages/self-hosted-environments-reference-ja.md |  131 +-
 .../pages/self-hosted-environments-testing-ja.md   |   14 +-
 docs-ja/pages/server-managed-settings-ja.md        |  253 +--
 docs-ja/pages/sessions-ja.md                       |   84 +-
 docs-ja/pages/settings-example-ja.md               |   16 +-
 docs-ja/pages/settings-ja.md                       |  114 +-
 docs-ja/pages/settings-reference-ja.md             | 1353 ++++++++--------
 docs-ja/pages/setup-ja.md                          |   50 +-
 docs-ja/pages/skills-ja.md                         |  363 ++---
 docs-ja/pages/slack-ja.md                          |   12 +-
 docs-ja/pages/statusline-ja.md                     |   46 +-
 docs-ja/pages/sub-agents-ja.md                     |  235 ++-
 docs-ja/pages/terminal-config-ja.md                |   60 +-
 docs-ja/pages/third-party-integrations-ja.md       |   40 +-
 docs-ja/pages/tools-reference-ja.md                |  228 +--
 docs-ja/pages/troubleshoot-install-ja.md           |   64 +-
 docs-ja/pages/troubleshooting-ja.md                |   52 +-
 docs-ja/pages/ultrareview-ja.md                    |   45 +-
 docs-ja/pages/voice-dictation-ja.md                |   28 +-
 docs-ja/pages/vs-code-ja.md                        |  292 ++--
 docs-ja/pages/web-quickstart-ja.md                 |   68 +-
 docs-ja/pages/workflows-ja.md                      |   74 +-
 docs-ja/pages/worktrees-ja.md                      |   72 +-
 docs-ja/pages/zero-data-retention-ja.md            |   18 +-
 140 files changed, 8056 insertions(+), 7079 deletions(-)
```

<details>
<summary>accessibility-ja.md</summary>

```diff
diff --git a/docs-ja/pages/accessibility-ja.md b/docs-ja/pages/accessibility-ja.md
index e07a364..4bbbc65 100644
--- a/docs-ja/pages/accessibility-ja.md
+++ b/docs-ja/pages/accessibility-ja.md
@@ -9,5 +9,5 @@
 Claude Code には、ビジュアルターミナルインターフェースをプレーンな線形テキストに置き換えるスクリーンリーダーモードがあります。ボックス、プログレスアニメーション、インプレース再描画の代わりに、Claude Code はラベル付きの行を出力し、VoiceOver や NVDA などのスクリーンリーダーが順番に読み上げます。完全な会話を保持し、ツール権限を承認し、出力を最後まで確認できます。
 
-スクリーンリーダーモードはオプトインです。スクリーン拡大鏡、モーション削減、またはスクリーンリーダーの代わりにカラーブラインド対応テーマを使用する場合は、[アクセシビリティ設定](#accessibility-settings)テーブルから `CLAUDE_CODE_ACCESSIBILITY`、`prefersReducedMotion`、または `theme` を設定してください。スクリーンリーダーモードはターミナルインターフェースのみを適応させるため、VS Code 拡張機能のチャットパネルではこれを必要としません。Claude Code v2.1.236 以降では、拡張機能は設定なしで[スクリーンリーダーにコンバーセーション活動を通知](/docs/ja/vs-code#use-a-screen-reader)します。
+スクリーンリーダーモードはオプトインです。スクリーン拡大鏡、モーション削減、またはスクリーンリーダーの代わりにカラーブラインド対応テーマを使用する場合は、[アクセシビリティ設定](#accessibility-settings)テーブルから `CLAUDE_CODE_ACCESSIBILITY`、`prefersReducedMotion`、または `theme` を設定してください。スクリーンリーダーモードはターミナルインターフェースのみを適応させるため、VS Code 拡張機能のチャットパネルではこれを必要としません。Claude Code v2.1.236 以降では、拡張機能は設定なしで[スクリーンリーダーにコンバーセーション活動を通知](/docs/ja/vs-code.md#use-a-screen-reader)します。
 
 ## スクリーンリーダーモードをオンにする
@@ -17,5 +17,5 @@ Claude Code には、ビジュアルターミナルインターフェースを
 * 1 つのセッション用：`claude --ax-screen-reader` を実行します。
 * 1 つのシェルから開始されたセッション用：`CLAUDE_AX_SCREEN_READER` 環境変数を `1` に設定します。Bash または Zsh では `export CLAUDE_AX_SCREEN_READER=1` を実行し、PowerShell では `$env:CLAUDE_AX_SCREEN_READER = "1"` を実行します。シェルプロファイルにその行を追加して、今後のシェルでも保持します。
-* マシン上のすべてのセッション用：ユーザー[設定ファイル](/docs/ja/settings)に `"axScreenReader": true` を追加します。この設定は VS Code 統合ターミナルを含むすべてのターミナルに適用されます。
+* マシン上のすべてのセッション用：ユーザー[設定ファイル](/docs/ja/settings.md)に `"axScreenReader": true` を追加します。この設定は VS Code 統合ターミナルを含むすべてのターミナルに適用されます。
 
 メソッドを組み合わせた場合、Claude Code は [`--ax-screen-reader`](/docs/ja/cli-reference#cli-flags) フラグを [`CLAUDE_AX_SCREEN_READER`](/docs/ja/env-vars#variables) 環境変数より優先し、その環境変数を [`axScreenReader`](/docs/ja/settings-reference#axscreenreader) 設定より優先します。
@@ -25,7 +25,14 @@ SSH 経由で Claude Code を使用する場合は、Claude Code が実行され
 Claude Code が最初に出力する行がモードを確認します。`[Screen Reader Mode: on via flag]`、`[Screen Reader Mode: on via env]`、または `[Screen Reader Mode: on via settings]` です。
 
+### プロジェクト設定ではスクリーンリーダーモードをオンにできない
+
+起動時に `Screen reader mode is off: project settings can't turn it on` という行が表示される場合、プロジェクトがスクリーンリーダーモードを要求しており、ほかにモードをオンにするものがないことを意味します。Claude Code は、プロジェクトの `.claude/settings.json` および `.claude/settings.local.json` にある `axScreenReader` キーと、`env` 配下の `CLAUDE_AX_SCREEN_READER` の値を、その値にかかわらずどちらも無視します。
+
+* **モードをオンにするには**：`--ax-screen-reader` を指定して Claude Code を起動するか、シェルで `CLAUDE_AX_SCREEN_READER` を `1` に設定するか、ユーザー[設定ファイル](/docs/ja/settings.md)に `"axScreenReader": true` を追加して Claude Code を再起動します。プロジェクトのファイルを変更する必要はありません。モードをオンにすると、起動時には代わりに[確認の行](#turn-on-screen-reader-mode)が表示されます。
+* **スクリーンリーダーを使用しない場合**：何もする必要はありません。この行を表示しないようにするには、ユーザー設定ファイルに `"axScreenReader": false` を追加するか、プロジェクトの設定ファイルから `axScreenReader` キーと `CLAUDE_AX_SCREEN_READER` 変数を削除します。
+
 ## スクリーンリーダーモードをオフにする
 
```

</details>

<details>
<summary>admin-setup-ja.md</summary>

```diff
diff --git a/docs-ja/pages/admin-setup-ja.md b/docs-ja/pages/admin-setup-ja.md
index 37e18e9..8779894 100644
--- a/docs-ja/pages/admin-setup-ja.md
+++ b/docs-ja/pages/admin-setup-ja.md
@@ -17,9 +17,9 @@ Claude Code は、ローカル開発者設定よりも優先されるマネー
 | 決定 | 選択内容 | 参照 |
 | :- | :- | :- |
-| [API プロバイダーを選択する](#choose-your-api-provider) | Claude Code が認証される場所と課金方法 | [Authentication](/docs/ja/authentication)、[Amazon Bedrock](/docs/ja/amazon-bedrock)、[Google Cloud の Agent Platform](/docs/ja/google-vertex-ai)、[Microsoft Foundry](/docs/ja/microsoft-foundry) |
-| [設定がデバイスに到達する方法を決定する](#decide-how-settings-reach-devices) | マネージドポリシーが開発者マシンに到達する方法 | [Server-managed settings](/docs/ja/server-managed-settings)、[Delivery mechanisms](/docs/ja/managed-settings#delivery-mechanisms) |
-| [実行する内容を決定する](#decide-what-to-enforce) | どのツール、コマンド、統合が許可されるか | [Permissions](/docs/ja/permissions)、[Sandboxing](/docs/ja/sandboxing) |
-| [使用状況の可視性をセットアップする](#set-up-usage-visibility) | 支出と採用を追跡する方法 | [Analytics](/docs/ja/analytics)、[Monitoring](/docs/ja/monitoring-usage)、[Costs](/docs/ja/costs) |
-| [データ処理を確認する](#review-data-handling) | データ保持とコンプライアンス体制 | [Data usage](/docs/ja/data-usage)、[Security](/docs/ja/security) |
+| [API プロバイダーを選択する](#choose-your-api-provider) | Claude Code が認証される場所と課金方法 | [Authentication](/docs/ja/authentication.md)、[Amazon Bedrock](/docs/ja/amazon-bedrock.md)、[Google Cloud の Agent Platform](/docs/ja/google-vertex-ai.md)、[Microsoft Foundry](/docs/ja/microsoft-foundry.md) |
+| [設定がデバイスに到達する方法を決定する](#decide-how-settings-reach-devices) | マネージドポリシーが開発者マシンに到達する方法 | [Server-managed settings](/docs/ja/server-managed-settings.md)、[Delivery mechanisms](/docs/ja/managed-settings.md#delivery-mechanisms) |
+| [実行する内容を決定する](#decide-what-to-enforce) | どのツール、コマンド、統合が許可されるか | [Permissions](/docs/ja/permissions.md)、[Sandboxing](/docs/ja/sandboxing.md) |
+| [使用状況の可視性をセットアップする](#set-up-usage-visibility) | 支出と採用を追跡する方法 | [Analytics](/docs/ja/analytics.md)、[Monitoring](/docs/ja/monitoring-usage.md)、[Costs](/docs/ja/costs.md) |
+| [データ処理を確認する](#review-data-handling) | データ保持とコンプライアンス体制 | [Data usage](/docs/ja/data-usage.md)、[Security](/docs/ja/security.md) |
 
 ## API プロバイダーを選択する
@@ -35,13 +35,13 @@ Claude Code は複数の API プロバイダーのいずれかを通じて Claud
 | Microsoft Foundry | 既存の Azure コンプライアンス制御と課金を継承したい場合 |
 
-一部の Claude Code 機能には claude.ai アカウントが必要です。[クラウドセッション](/docs/ja/claude-code-on-the-web)、[クラウドのスケジュールタスク](/docs/ja/routines)、[Code Review](/docs/ja/code-review)、[Remote Control](/docs/ja/remote-control)、および [Chrome 拡張機能](/docs/ja/chrome) は、Console API キーまたはクラウドプロバイダーの認証情報だけでは利用できません。Amazon Bedrock、Google Cloud の Agent Platform、または Microsoft Foundry を通じてデプロイする場合は、開発者が Claude for Teams または Enterprise シートも必要かどうかを検討してください。各機能ページにはプラン要件が記載されています。
+一部の Claude Code 機能には claude.ai アカウントが必要です。[クラウドセッション](/docs/ja/claude-code-on-the-web.md)、[クラウドのスケジュールタスク](/docs/ja/routines.md)、[Code Review](/docs/ja/code-review.md)、[Remote Control](/docs/ja/remote-control.md)、および [Chrome 拡張機能](/docs/ja/chrome.md) は、Console API キーまたはクラウドプロバイダーの認証情報だけでは利用できません。Amazon Bedrock、Google Cloud の Agent Platform、または Microsoft Foundry を通じてデプロイする場合は、開発者が Claude for Teams または Enterprise シートも必要かどうかを検討してください。各機能ページにはプラン要件が記載されています。
 
-認証、リージョン、機能パリティをカバーする完全なプロバイダー比較については、[エンタープライズ展開概要](/docs/ja/third-party-integrations) を参照してください。各プロバイダーの認証セットアップは [Authentication](/docs/ja/authentication) にあります。
+認証、リージョン、機能パリティをカバーする完全なプロバイダー比較については、[エンタープライズ展開概要](/docs/ja/third-party-integrations.md) を参照してください。各プロバイダーの認証セットアップは [Authentication](/docs/ja/authentication.md) にあります。
 
-[ネットワーク設定](/docs/ja/network-config) のプロキシとファイアウォール要件は、プロバイダーに関係なく適用されます。複数のプロバイダーの前に単一のエンドポイントを配置したい場合、または集中化されたリクエストログを記録したい場合は、[LLM gateway](/docs/ja/llm-gateway) を参照してください。
+[ネットワーク設定](/docs/ja/network-config.md) のプロキシとファイアウォール要件は、プロバイダーに関係なく適用されます。複数のプロバイダーの前に単一のエンドポイントを配置したい場合、または集中化されたリクエストログを記録したい場合は、[LLM gateway](/docs/ja/llm-gateway) を参照してください。
```

</details>

<details>
<summary>advisor-ja.md</summary>

```diff
diff --git a/docs-ja/pages/advisor-ja.md b/docs-ja/pages/advisor-ja.md
index 9c75b8a..337715c 100644
--- a/docs-ja/pages/advisor-ja.md
+++ b/docs-ja/pages/advisor-ja.md
@@ -21,5 +21,5 @@ advisor は Anthropic インフラストラクチャ上でサーバー側で実
 advisor は、ほとんどのターンが定型的であるが、プラン品質が結果を決定する長い複数ステップのタスクに適しています。例としては、大規模なリファクタリング、エラーが繰り返し発生するデバッグセッション、および Claude が完了を宣言する前に独立して確認したいタスクが挙げられます。
 
-計画する必要がほとんどない短いタスク、またはすべてのターンで最強のモデルが必要な作業では、価値が低くなります。その場合は、[メインモデルを切り替える](/docs/ja/model-config#setting-your-model)か、[advisor が opusplan およびサブエージェントとどのように比較されるか](#compare-with-related-features)を参照して、2 番目の意見を得る他の方法を確認してください。
+計画する必要がほとんどない短いタスク、またはすべてのターンで最強のモデルが必要な作業では、価値が低くなります。その場合は、[メインモデルを切り替える](/docs/ja/model-config.md#setting-your-model)か、[advisor が opusplan およびサブエージェントとどのように比較されるか](#compare-with-related-features)を参照して、2 番目の意見を得る他の方法を確認してください。
 
 ## advisor を有効にする
@@ -28,10 +28,10 @@ advisor モデルは 3 つの方法で設定できます。
 
 * **`/advisor` コマンド**：セッション中に advisor を設定または変更し、デフォルトとして保存します
-* **`advisorModel` 設定**：[設定ファイル](/docs/ja/settings)で永続的なデフォルトを構成します
+* **`advisorModel` 設定**：[設定ファイル](/docs/ja/settings.md)で永続的なデフォルトを構成します
 * **`--advisor` フラグ**：起動時に単一セッションの advisor を設定します
 
 これらのいずれかが advisor を有効にするのは、メインモデルが[それをサポートしている](#choose-an-advisor-model)セッションです。セッションが開始されると、Claude Code は `Advisor Tool (experimental) is on and may use more tokens · /advisor` 通知を表示します。advisor の使用を停止するには、[advisor をオフにする](#turn-the-advisor-off)を参照してください。
 
-一部のプランでは、Fable を advisor として使用する場合、Fable の使用を使用クレジットに請求することへの 1 回限りの[同意](/docs/ja/model-config#fable-and-usage-credits)も必要です。その同意を与える前に何が起こるかについては、[Fable advisor と使用クレジット](#fable-advisor-and-usage-credits)を参照してください。
+一部のプランでは、Fable を advisor として使用する場合、Fable の使用を使用クレジットに請求することへの 1 回限りの[同意](/docs/ja/model-config.md#fable-and-usage-credits)も必要です。その同意を与える前に何が起こるかについては、[Fable advisor と使用クレジット](#fable-advisor-and-usage-credits)を参照してください。
 
 ### `/advisor` コマンドを使用する
@@ -45,5 +45,5 @@ advisor モデルは 3 つの方法で設定できます。
 コマンドは `Advisor set to` で確認し、その後に advisor モデル名が続きます。選択はユーザー設定の `advisorModel` に保存され、セッション全体で保持されます。ただし、[`advisorModel` エントリ](/docs/ja/settings-reference#advisormodel)が現在のセッションにのみ適用されるとリストしている場合は除きます。
 
-このコマンドは、ターミナルピッカーがない場所でも機能します。[非対話モード](/docs/ja/headless)で `-p` を使用する場合、Agent SDK 内、デスクトップアプリ内、および [Remote Control](/docs/ja/remote-control) 経由です。これには Claude Code v2.1.260 以降が必要です。これらのサーフェスでは、
+このコマンドは、ターミナルピッカーがない場所でも機能します。[非対話モード](/docs/ja/headless.md)で `-p` を使用する場合、Agent SDK 内、デスクトップアプリ内、および [Remote Control](/docs/ja/remote-control.md) 経由です。これには Claude Code v2.1.260 以降が必要です。これらのサーフェスでは、
 
```

</details>

<details>
<summary>agent-teams-ja.md</summary>

```diff
diff --git a/docs-ja/pages/agent-teams-ja.md b/docs-ja/pages/agent-teams-ja.md
index 334b3d1..6529df8 100644
--- a/docs-ja/pages/agent-teams-ja.md
+++ b/docs-ja/pages/agent-teams-ja.md
@@ -9,9 +9,9 @@
 > [!WARNING]
 >
-> エージェントチームは実験的機能であり、デフォルトでは無効になっています。[settings.json](/docs/ja/settings) または環境に `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1` を設定して有効にしてください。その変数がない場合、セッション開始時にチームが設定されず、チームディレクトリが書き込まれず、Claude はチームメンバーをスポーンまたは提案しません。エージェントチームには、セッション再開、タスク調整、シャットダウン動作に関する[既知の制限](#limitations)があります。
+> エージェントチームは実験的機能であり、デフォルトでは無効になっています。[settings.json](/docs/ja/settings.md) または環境に `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1` を設定して有効にしてください。その変数がない場合、セッション開始時にチームが設定されず、チームディレクトリが書き込まれず、Claude はチームメンバーをスポーンまたは提案しません。エージェントチームには、セッション再開、タスク調整、シャットダウン動作に関する[既知の制限](#limitations)があります。
 
 エージェントチームを使用すると、複数の Claude Code インスタンスが連携して動作するように調整できます。1 つのセッションがチームリーダーとして機能し、作業を調整し、タスクを割り当て、結果を統合します。チームメンバーは独立して動作し、それぞれ独自のコンテキストウィンドウで動作し、互いに直接通信します。リーダーを経由せずに、任意のチームメンバーと直接対話することもできます。
 
-チームを設定する前に、より軽量なオプションで十分かどうかを確認してください。[Subagents](/docs/ja/sub-agents) は単一セッション内で動作し、[クロスセッションメッセージング](/docs/ja/cross-session-messaging) を使用すると Claude は自分で実行するセッション間で検出結果を渡すことができます。
+チームを設定する前に、より軽量なオプションで十分かどうかを確認してください。[Subagents](/docs/ja/sub-agents.md) は単一セッション内で動作し、[クロスセッションメッセージング](/docs/ja/cross-session-messaging.md) を使用すると Claude は自分で実行するセッション間で検出結果を渡すことができます。
 
 ## エージェントチームを使用する場合
@@ -24,17 +24,19 @@
 * **クロスレイヤー調整**：フロントエンド、バックエンド、テストにまたがる変更で、それぞれ異なるチームメンバーが担当します
 
-エージェントチームは調整オーバーヘッドを追加し、単一セッションよりも大幅に多くのトークンを使用します。チームメンバーが独立して動作できる場合に最も効果的です。順序付きタスク、同じファイルの編集、または多くの依存関係を持つ作業の場合は、単一セッションまたは [subagents](/docs/ja/sub-agents) がより効果的です。
+エージェントチームは調整オーバーヘッドを追加し、単一セッションよりも大幅に多くのトークンを使用します。チームメンバーが独立して動作できる場合に最も効果的です。順序付きタスク、同じファイルの編集、または多くの依存関係を持つ作業の場合は、単一セッションまたは [subagents](/docs/ja/sub-agents.md) がより効果的です。
 
 ### subagents との比較
 
-エージェントチームと [subagents](/docs/ja/sub-agents) の両方を使用すると、作業を並列化できますが、動作方法が異なります。チームなしでメッセージを相互に渡す別々のセッションについては、[クロスセッションメッセージング](/docs/ja/cross-session-messaging)を参照してください。
+エージェントチームと [subagents](/docs/ja/sub-agents.md) の両方を使用すると、作業を並列化できますが、動作方法が異なります。チームなしでメッセージを相互に渡す別々のセッションについては、[クロスセッションメッセージング](/docs/ja/cross-session-messaging.md)を参照してください。
 
 ![Subagent とエージェントチームのアーキテクチャを比較する図。Subagents はメインエージェントによって生成され、作業を実行し、結果を報告します。エージェントチームは共有タスクリストを通じて調整され、チームメンバーが互いに直接通信します。](https://mintcdn.com/claude-code/nsvRFSDNfpSU5nT7/images/subagents-vs-agent-teams-light.png?fit=max\&auto=format\&n=nsvRFSDNfpSU5nT7\&q=85\&s=2f8db9b4f3705dd3ab931fbe2d96e42a)
 
+Subagents は結果をメインエージェントに報告します。エージェントチームでは、チームメンバーがタスクリストを共有し、作業を要求し、互いに直接通信します。
```

</details>

<details>
<summary>agent-view-ja.md</summary>

```diff
diff --git a/docs-ja/pages/agent-view-ja.md b/docs-ja/pages/agent-view-ja.md
index 4c8c4f0..01ddc75 100644
--- a/docs-ja/pages/agent-view-ja.md
+++ b/docs-ja/pages/agent-view-ja.md
@@ -15,5 +15,5 @@ Claude が複数の独立したタスクに対して、あなたが毎ステッ
 任意のエージェントのセッションでより直接的に作業したい場合は、行にアタッチして完全な会話に入ります。
 
-エージェントビューを subagents、agent teams、worktrees と比較するには、[エージェントを並列で実行する](/docs/ja/agents)を参照してください。エージェントビューはあなたのマシン上でセッションを実行し、各セッションをディスパッチします。1 つの会話からクラウドで Claude が並列セッションを開始して追跡するには、[Projects](/docs/ja/claude-projects)を参照してください。
+エージェントビューを subagents、agent teams、worktrees と比較するには、[エージェントを並列で実行する](/docs/ja/agents.md)を参照してください。エージェントビューはあなたのマシン上でセッションを実行し、各セッションをディスパッチします。1 つの会話からクラウドで Claude が並列セッションを開始して追跡するには、[Projects](/docs/ja/claude-projects.md)を参照してください。
 
 > [!NOTE]
@@ -33,5 +33,5 @@ claude agents
 ```
 
-まだディレクトリの[ワークスペーストラストダイアログ](/docs/ja/permissions#project-allow-rules-and-workspace-trust)を受け入れていない場合、Claude Code はエージェントビューが開く前にそれを表示します。これは `claude` が表示するのと同じダイアログです。受け入れてワークスペースの信頼を保存して続行します。拒否すると、Claude Code はエージェントビューを開かずに終了します。
+まだディレクトリの[ワークスペーストラストダイアログ](/docs/ja/permissions.md#project-allow-rules-and-workspace-trust)を受け入れていない場合、Claude Code はエージェントビューが開く前にそれを表示します。これは `claude` が表示するのと同じダイアログです。受け入れてワークスペースの信頼を保存して続行します。拒否すると、Claude Code はエージェントビューを開かずに終了します。
 
 エージェントビューが開き、下部に入力フィールドが表示され、セッションが開始されるとテーブルが埋まります。`Esc` を押すとシェルに戻ります。`←` でセッションをバックグラウンドにしてエージェントビューを開いた場合、`Esc` はそのセッションの会話に戻ります。セッションは離れている間も実行し続け、次にエージェントビューを開いたときに再度表示されます。
@@ -65,5 +65,5 @@ claude agents
 * **完了数**: 入力を待機しているセッションがない状態でバックグラウンドセッションが正常に完了すると、フッターに完了した数が一時的に表示されます。たとえば 2 つの場合は `← 2 done` と表示されます
 
-待機中の数は、増減したとき、およびバックグラウンドセッションが正常に完了したときに一時的に色が変わります。[`prefersReducedMotion`](/docs/ja/settings-reference#prefersreducedmotion) をオンにすると、色の変化も `done` のカウントも表示されません。[スクリーンリーダーモード](/docs/ja/accessibility)では、`←` ヒントとそのカウントは非表示になります。
+待機中の数は、増減したとき、およびバックグラウンドセッションが正常に完了したときに一時的に色が変わります。[`prefersReducedMotion`](/docs/ja/settings-reference#prefersreducedmotion) をオンにすると、色の変化も `done` のカウントも表示されません。[スクリーンリーダーモード](/docs/ja/accessibility.md)では、`←` ヒントとそのカウントは非表示になります。
 
 ### デフォルトでエージェントビューを開く
@@ -105,5 +105,5 @@ claude agents --cwd ~/projects/my-app
 これはそのディレクトリの下で開始されたセッションのみを表示します。`~/projects/my-app/.claude/worktrees/` の下の [worktree に移動した](#how-file-edits-are-isolated) セッションも引き続き表示されます。
 
-他のターミナルで開いているインタラクティブセッションは、[バックグラウンドにする](#from-inside-a-session) までは表示されません。セッションが生成する [サブエージェント](/docs/ja/sub-agents) と [チームメイト](/docs/ja/agent-teams) は、個別の行としてはリストされません。
+他のターミナルで開いているインタラクティブセッションは、[バックグラウンドにする](#from-inside-a-session) までは表示されません。セッションが生成する [サブエージェント](/docs/ja/sub-agents.md) と [チームメイト](/docs/ja/agent-teams.md) は、個別の行としてはリストされません。
```

</details>

<details>
<summary>agents-ja.md</summary>

```diff
diff --git a/docs-ja/pages/agents-ja.md b/docs-ja/pages/agents-ja.md
index 1c1cdc6..05cc96a 100644
--- a/docs-ja/pages/agents-ja.md
+++ b/docs-ja/pages/agents-ja.md
@@ -7,31 +7,31 @@
 > Claude Code が複数のタスクを同時に実行する 5 つの方法を比較します。サブエージェント、エージェントビュー、エージェントチーム、動的ワークフロー、およびプロジェクトについて説明します。
 
-Claude Code には、複数のタスクを同時に処理する 5 つの方法があります。[サブエージェント](/docs/ja/sub-agents)、[エージェントビュー](/docs/ja/agent-view)、[エージェントチーム](/docs/ja/agent-teams)、[動的ワークフロー](/docs/ja/workflows)、および [プロジェクト](/docs/ja/claude-projects) です。これらは、各会話に自分で留まるのか、Claude にワーカーのグループを調整させるのかという関与の度合いや、作業がマシン上で実行されるのかクラウドで実行されるのかという点で異なります。
+Claude Code には、複数のタスクを同時に処理する 5 つの方法があります。[サブエージェント](/docs/ja/sub-agents.md)、[エージェントビュー](/docs/ja/agent-view.md)、[エージェントチーム](/docs/ja/agent-teams.md)、[動的ワークフロー](/docs/ja/workflows.md)、および [プロジェクト](/docs/ja/claude-projects.md) です。これらは、各会話に自分で留まるのか、Claude にワーカーのグループを調整させるのかという関与の度合いや、作業がマシン上で実行されるのかクラウドで実行されるのかという点で異なります。
 
 | アプローチ | 提供内容 | 使用する場合 |
 | :- | :- | :- |
-| [サブエージェント](/docs/ja/sub-agents) | 1 つのセッション内で委任されたワーカーが、独自のコンテキストでサイドタスクを実行し、サマリーを返す | サイドタスクが検索結果、ログ、またはファイルコンテンツで主な会話を埋め尽くす場合（再度参照しない） |
-| [エージェントビュー](/docs/ja/agent-view) | `claude agents` で開く、バックグラウンドで実行されているセッションをディスパッチして監視する 1 つの画面。リサーチプレビュー | 複数の独立したタスクがあり、それらを引き継いで、一目で状態を確認し、必要な場合のみ介入したい場合 |
-| [エージェントチーム](/docs/ja/agent-teams) | 共有タスクリストとエージェント間メッセージングを備えた複数の調整されたセッション。リーダーによって管理される。実験的で、デフォルトでは無効 | Claude にプロジェクトを分割させ、割り当てさせ、ワーカーを同期させたい場合 |
-| [プロジェクト](/docs/ja/claude-projects) | claude.ai/code またはデスクトップアプリでの 1 つの継続的な会話。Claude は threads と呼ばれる並列セッションを開始し、クラウドで、またはリモートコントロール経由でコンピューターで実行し、各セッションにプロジェクトの指示を提供し、どのセッションがあなたを必要としているかを表示します。Pro および Max でのパブリックベータ | 作業が数日または数週間にわたる多くのタスクに及び、マシンがオフの場合でも実行を続け、各セッションをディスパッチして追跡するのではなく、一度説明したい場合 |
-| [動的ワークフロー](/docs/ja/workflows) | 多くのサブエージェントを実行し、その結果をチェックするスクリプト。1 回のターンで調整するには大きすぎるジョブ向け | タスクが大きすぎてサブエージェント数個では対応できない場合、または検出結果を相互に検証したい場合。コードベース全体の監査、500 ファイルのマイグレーション、相互検証が必要な調査、または複数の角度から作成されたプランなど |
+| [サブエージェント](/docs/ja/sub-agents.md) | 1 つのセッション内で委任されたワーカーが、独自のコンテキストでサイドタスクを実行し、サマリーを返す | サイドタスクが検索結果、ログ、またはファイルコンテンツで主な会話を埋め尽くす場合（再度参照しない） |
+| [エージェントビュー](/docs/ja/agent-view.md) | `claude agents` で開く、バックグラウンドで実行されているセッションをディスパッチして監視する 1 つの画面。リサーチプレビュー | 複数の独立したタスクがあり、それらを引き継いで、一目で状態を確認し、必要な場合のみ介入したい場合 |
+| [エージェントチーム](/docs/ja/agent-teams.md) | 共有タスクリストとエージェント間メッセージングを備えた複数の調整されたセッション。リーダーによって管理される。実験的で、デフォルトでは無効 | Claude にプロジェクトを分割させ、割り当てさせ、ワーカーを同期させたい場合 |
+| [プロジェクト](/docs/ja/claude-projects.md) | claude.ai/code またはデスクトップアプリでの 1 つの継続的な会話。Claude は threads と呼ばれる並列セッションを開始し、クラウドで、またはリモートコントロール経由でコンピューターで実行し、各セッションにプロジェクトの指示を提供し、どのセッションがあなたを必要としているかを表示します。Pro および Max でのパブリックベータ | 作業が数日または数週間にわたる多くのタスクに及び、マシンがオフの場合でも実行を続け、各セッションをディスパッチして追跡するのではなく、一度説明したい場合 |
+| [動的ワークフロー](/docs/ja/workflows.md) | 多くのサブエージェントを実行し、その結果をチェックするスクリプト。1 回のターンで調整するには大きすぎるジョブ向け | タスクが大きすぎてサブエージェント数個では対応できない場合、または検出結果を相互に検証したい場合。コードベース全体の監査、500 ファイルのマイグレーション、相互検証が必要な調査、または複数の角度から作成されたプランなど |
 
-すべてのアプローチにおいて、ワーカーは Claude セッションです。別のツールを関与させるには、それを Claude に [MCP サーバー](/docs/ja/mcp) として公開します。
+すべてのアプローチにおいて、ワーカーは Claude セッションです。別のツールを関与させるには、それを Claude に [MCP サーバー](/docs/ja/mcp.md) として公開します。
 
 この作業をサポートする 3 つの追加ツールがありますが、エージェント自体を実行する方法ではありません。
 
-* [Worktree](/docs/ja/worktrees) は各セッションに個別の git チェックアウトを提供するため、並列セッションはそれぞれ自分のファイルのコピーを編集します。自分で実行するセッションに使用します。エージェントビューからディスパッチしたセッションは、[ファイルを編集する前に専用の worktree に移動](/docs/ja/agent-view#how-file-edits-are-isolated) し、スポーンするサブエージェントもそれぞれ worktree を取得できます。
-* [クロスセッションメッセージング](/docs/ja/cross-session-messaging) により、Claude はこのマシン上、別のマシン上、または [クラウド](/docs/ja/claude-code-on-the-web) 上の他の Claude Code セッションをリストして、メッセージを送信できます。自分で実行するセッションは、検出結果とステータスを相互に渡すことができます。
```

</details>

*...以降省略*

</details>


<details>
<summary>2026-10-22</summary>

**変更ファイル:**

```
 docs-ja/pages/admin-setup-ja.md                    |  86 ++--
 docs-ja/pages/advisor-ja.md                        |   2 +-
 docs-ja/pages/agent-teams-ja.md                    |   8 +-
 docs-ja/pages/agent-view-ja.md                     |  49 ++-
 docs-ja/pages/artifacts-ja.md                      |  10 +
 docs-ja/pages/changelog.md                         |  51 +++
 docs-ja/pages/channels-ja.md                       |   2 +-
 docs-ja/pages/claude-code-on-the-web-ja.md         |  11 +-
 docs-ja/pages/claude-directory-ja.md               |   2 +-
 docs-ja/pages/claude-projects-ja.md                |  40 +-
 docs-ja/pages/claude-security-ja.md                |   2 +-
 docs-ja/pages/cli-reference-ja.md                  |   4 +-
 docs-ja/pages/cloud-environments-ja.md             |  13 +-
 docs-ja/pages/code-review-customize-ja.md          |  42 +-
 docs-ja/pages/code-review-troubleshooting-ja.md    |   6 +-
 docs-ja/pages/commands-ja.md                       |   8 +-
 docs-ja/pages/common-workflows-ja.md               |   9 +-
 docs-ja/pages/cross-session-messaging-ja.md        |   2 +-
 docs-ja/pages/desktop-ja.md                        |  22 +-
 docs-ja/pages/desktop-linux-ja.md                  |  12 +-
 docs-ja/pages/desktop-quickstart-ja.md             |  28 +-
 docs-ja/pages/desktop-scheduled-tasks-ja.md        |  30 +-
 docs-ja/pages/env-vars-ja.md                       |   6 +-
 docs-ja/pages/errors-ja.md                         | 163 ++++++--
 docs-ja/pages/features-overview-ja.md              | 220 +++++-----
 docs-ja/pages/fullscreen-ja.md                     |   1 +
 docs-ja/pages/hooks-guide-ja.md                    | 149 +++----
 docs-ja/pages/hooks-ja.md                          |  18 +-
 docs-ja/pages/interactive-mode-ja.md               |  15 +
 docs-ja/pages/keybindings-ja.md                    |  21 +
 docs-ja/pages/large-codebases-ja.md                |   4 +-
 docs-ja/pages/llm-gateway-protocol-ja.md           |   6 +-
 docs-ja/pages/managed-settings-ja.md               |   2 +-
 docs-ja/pages/mcp-ja.md                            |  10 +-
 docs-ja/pages/mcp-quickstart-ja.md                 |   2 +-
 docs-ja/pages/memory-ja.md                         |  15 +-
 docs-ja/pages/model-config-ja.md                   |   8 +-
 docs-ja/pages/overview-ja.md                       |  10 +-
 docs-ja/pages/permission-modes-ja.md               |  31 +-
 docs-ja/pages/permissions-ja.md                    |  37 +-
 docs-ja/pages/prompt-caching-ja.md                 |  13 +-
 docs-ja/pages/remote-control-ja.md                 | 172 ++++----
 docs-ja/pages/routines-ja.md                       |  19 +-
 docs-ja/pages/sandboxing-ja.md                     |  14 +-
 docs-ja/pages/scheduled-tasks-ja.md                |  16 +-
 .../self-hosted-environments-configuration-ja.md   |  30 +-
 docs-ja/pages/server-managed-settings-ja.md        |   2 +-
 docs-ja/pages/settings-example-ja.md               |   2 +-
 docs-ja/pages/settings-ja.md                       |   6 +-
 docs-ja/pages/settings-reference-ja.md             |   4 +-
 docs-ja/pages/setup-ja.md                          |  10 +-
 docs-ja/pages/skills-ja.md                         |  18 +-
 docs-ja/pages/sub-agents-ja.md                     | 451 +++++++++++----------
 docs-ja/pages/tools-reference-ja.md                |   9 +-
 docs-ja/pages/vs-code-ja.md                        |   4 +-
 docs-ja/pages/worktrees-ja.md                      |   1 +
 56 files changed, 1181 insertions(+), 747 deletions(-)
```

<details>
<summary>admin-setup-ja.md</summary>

```diff
diff --git a/docs-ja/pages/admin-setup-ja.md b/docs-ja/pages/admin-setup-ja.md
index 0ed93c5..37e18e9 100644
--- a/docs-ja/pages/admin-setup-ja.md
+++ b/docs-ja/pages/admin-setup-ja.md
@@ -82,45 +82,45 @@ WSL セッションが有効になった後、管理設定をそれらに拡張
 WSL 2 ユーティリティ VM 内のプロセスは、Windows 側のエンドポイント検出センサーに表示されません。ディストリビューション内のプロセスとファイルアクティビティを観察するには、エンドポイント検出ベンダーの WSL ガイダンスで、ディストリビューション内で実行できる Linux センサーと、それが必要とする除外を確認してください。Claude Code の [OpenTelemetry ツール実行テレメトリ](/docs/ja/monitoring-usage)は WSL とネイティブセッションで同じように出力されます。
 
-## 実装する内容を決定する
+## 適用する内容を決める
 
-マネージド設定は、ツール、サンドボックス実行、MCP サーバーとプラグインソース、および実行するフック を制限できます。各行は、それを駆動する設定キーを持つ制御サーフェスです。
+管理設定では、ツールのロックダウン、実行のサンドボックス化、MCP サーバーやプラグインソースの制限、実行するフックの制御を行えます。各行は制御対象とそれを動かす設定キーを示しています。
 
-| 制御 | 機能 | キー設定 |
+| 制御 | 内容 | 主な設定 |
 | :- | :- | :- |
-| [権限ルール](/docs/ja/permissions) | 特定のツールとコマンドを許可、確認、または拒否する | `permissions.allow`、`permissions.deny` |
-| [権限ロックダウン](/docs/ja/permissions#managed-only-settings) | マネージド設定を[権限ルールの唯一の設定ソース](/docs/ja/settings-reference#allowmanagedpermissionrulesonly)にします。`--dangerously-skip-permissions` を無効にする | `allowManagedPermissionRulesOnly`、`permissions.disableBypassPermissionsMode` |
-| [開始権限モード](/docs/ja/permission-modes#which-mode-a-session-starts-in) | 組み込みの開始権限モードの代わりに、開発者のターミナルセッションが開始する権限モードを選択するか、自動モードを削除します。[権限モードの切り替え](/docs/ja/permission-modes#switch-permission-modes)は、VS Code 拡張機能が `defaultMode` を読み取る時期を一覧表示します | `permissions.defaultMode`、`permissions.disableAutoMode` |
-| [サンドボックス](/docs/ja/sandboxing) | ドメイン許可リスト付きの OS レベルのファイルシステムとネットワーク分離 | `sandbox.enabled`、`sandbox.network.allowedDomains` |
-| [マネージドポリシー CLAUDE.md](/docs/ja/memory#deploy-organization-wide-claude-md) | すべてのセッションで読み込まれる組織全体の指示。除外できません | マネージドポリシーパスのファイル |
-| [MCP サーバー制御](/docs/ja/managed-mcp) | ユーザーが追加または接続できる MCP サーバーを制限し、固定セットをデプロイするか、リモートサーバーをすべてのユーザーに提供します | `allowedMcpServers`、`deniedMcpServers`、`allowManagedMcpServersOnly`、`managedMcpServers`、またはデプロイされた `managed-mcp.json` ファイル |
-| [プラグインマーケットプレイス制御](/docs/ja/plugins/org#restrict-what-users-can-install) | ユーザーが追加およびインストールできるマーケットプレイスソースを制限し、単一実行のためにプラグイン、エージェント、MCP サーバーをサイドロードする CLI フラグを拒否し、[`command` プラグインソース](/docs/ja/plugins/marketplace-reference#command-plugin-source)をブロックし、どのマーケットプレイスのプラグインを提案できるかをホワイトリストに登録します | `strictKnownMarketplaces`、`blockedMarketplaces`、`disableSideloadFlags`、`disableCommandPluginSources`、`pluginSuggestionMarketplaces` |
-| [カスタマイズロックダウン](/docs/ja/settings-reference#strictpluginonlycustomization) | スキル、エージェント、フック、MCP サーバーをユーザーおよびプロジェクトソースからブロックし、プラグインまたはマネージド設定からのみ取得できるようにします。スキルをロックすると、開発者が claude.ai で有効にした[スキル](/docs/ja/skills#where-synced-skills-load)の同期も停止します | `strictPluginOnlyCustomization` |
-| [claude.ai 同期を無効にする](/docs/ja/settings-reference#syncclaudeaiskills) | Claude Code が開発者が claude.ai で有効にした[スキル](/docs/ja/skills#how-synced-skills-behave)と[プラグイン](/docs/ja/plugins/loading#synced-plugins)を読み込むのを停止します。組織の claude.ai でスキルをオフにすると、Claude Code は両方の同期を停止します。v2.1.273 以降では、既に同期したものも削除します。スキルをオフにせずにどちらか一方を停止するには、マネージド設定でそのキーを `false` に設定します | `syncClaudeAiSkills`、`syncClaudeAiPlugins` |
-| [フック制限](/docs/ja/settings-reference#allowmanagedhooksonly) | 実行するフックを制限し、HTTP フック URL を制限します。[`allowManagedHooksOnly` で実行される内容](/docs/ja/settings-reference#what-runs-under-allowmanagedhooksonly)の完全な効果リストを参照してください | `allowManagedHooksOnly`、`allowedHttpHookUrls` |
-| [ログイン強制](/docs/ja/settings-reference#forceloginmethod) | ログインを特定の方法または Anthropic 組織に制限します。メソッド制限は VS Code 拡張機能、Agent SDK、`claude setup-token`、`/install-github-app` 全体に適用され、ターミナルのインタラクティブログイン画面（`/login` または初回オンボーディングで到達）はメソッドを事前選択しますが強制しません。Claude Code は、ターミナル、VS Code 拡張機能、Agent SDK での claude.ai アカウントログインの組織を検証し、Claude Console ログインまたは[ゲートウェイ](/docs/ja/claude-apps-gateway)サインインではチェックしません。v2.1.212 より前は、ターミナルログインのみが両方のキーを適用していました。設定すると、`ANTHROPIC_API_KEY`、`ANTHROPIC_AUTH_TOKEN`、または `apiKeyHelper` によって認証されたセッションはスタートアップでブロックされます。クラウドプロバイダーセッションは影響を受けません | `forceLoginMethod`、`forceLoginOrgUUID` |
-| [プロバイダー制限](/docs/ja/settings-reference#allowedproviders) | マシンが使用できる API プロバイダーを制限します。リストに記載されていないプロバイダー上のセッションはスタートアップ時、ログイン時、および次に API に接続するときに拒否されます。Claude Code v2.1.285 以降が必要です | `allowedProviders` |
-| [エージェントビューを無効にする](/docs/ja/agent-view#how-background-sessions-are-hosted) | `claude agents`、`--bg`、`/background`、およびオンデマンドスーパーバイザーをオフにします | `disableAgentView` |
-| [企業ランチャーを構成する](/docs/ja/corporate-launcher) | [バックグラウンドエージェントスーパーバイザー](/docs/ja/agent-view#how-background-sessions-are-hosted)、そのワーカー、および[その他のカバーされたバックグラウンドプロセス](/docs/ja/corporate-launcher#what-the-launcher-covers)に、エージェントビューをオフにする代わりに、必須の企業ランチャーをプレフィックスします | `processWrapper` |
```

</details>

<details>
<summary>advisor-ja.md</summary>

```diff
diff --git a/docs-ja/pages/advisor-ja.md b/docs-ja/pages/advisor-ja.md
index 2ca1537..9c75b8a 100644
--- a/docs-ja/pages/advisor-ja.md
+++ b/docs-ja/pages/advisor-ja.md
@@ -84,5 +84,5 @@ Claude Code はそのセッションの `advisorModel` 設定の代わりにフ
 `--advisor` で[バックグラウンドセッション](/docs/ja/agent-view)を開始し、これらのいずれかが当てはまる場合、Claude Code は終了する代わりに advisor なしでセッションを開始します。
 
-リクエストされたモデルが advisor として機能できるものの、セッションのメインモデルより[下位にランク付けされている](#choose-an-advisor-model)場合でも、Claude Code はセッションを開始します。バックグラウンドセッション以外では、そのモデルがメインモデルに対して `cannot advise` であるという警告も起動時に表示します。
+渡したモデルが advisor として機能できるものの、メインモデルより[下位にランク付けされている](#choose-an-advisor-model)場合、バックグラウンドセッションかどうかにかかわらずセッションは開始されます。その場合、メインモデルは advisor なしで実行されます。
 
 ## アドバイザーモデルを選択する
```

</details>

<details>
<summary>agent-teams-ja.md</summary>

```diff
diff --git a/docs-ja/pages/agent-teams-ja.md b/docs-ja/pages/agent-teams-ja.md
index ab3ca26..334b3d1 100644
--- a/docs-ja/pages/agent-teams-ja.md
+++ b/docs-ja/pages/agent-teams-ja.md
@@ -35,5 +35,5 @@
 | :- | :- | :- |
 | **コンテキスト** | 独自のコンテキストウィンドウ。結果は呼び出し元に返される | 独自のコンテキストウィンドウ。完全に独立 |
-| **通信** | 呼び出し元に結果を返します。Claude が生成した際に名前を付けた Subagents は、[互いにメッセージを送信](/docs/ja/sub-agents#what-loads-at-startup)することもできます | チームメンバーが互いに直接メッセージを送信 |
+| **通信** | 呼び出し元に結果を返します。Claude が生成時に[名前を付けた](/docs/ja/sub-agents#subagent-names)サブエージェントは、[互いにメッセージを送信](/docs/ja/sub-agents#what-loads-at-startup)することもできます | チームメイトが互いに直接メッセージを送信 |
 | **調整** | メインエージェントがすべての作業を管理 | メッセージを通じた自己調整、および [Task ツールを持つエージェント](/docs/ja/tools-reference#task-tool-availability)のための共有タスクリスト |
 | **最適な用途** | 結果のみが重要な焦点を絞ったタスク | 議論と協力が必要な複雑な作業 |
@@ -167,5 +167,7 @@ Spawn an architect teammate to refactor the authentication module.
 ```
 
-チームメンバーがプランを完了すると、リーダーにプラン承認リクエストを送信します。Claude Code はリクエストが到着するとすぐにリーダーのセッションでプランを承認し、リーダーがそれをレビューすることはありません。チームメンバーの編集とコマンドは、[権限](#permissions)で説明されている権限プロンプトを通じて実行されます。承認されると、チームメンバーはプランモードを終了し、実装を開始します。
+そのチームメイトがプランを完了すると、リーダーにプラン承認リクエストを送信します。スポーン後にそのチームメイトの権限モードを変更していない場合、Claude Code はリクエストが到着するとすぐにプランを承認し、リーダーがそれをレビューすることはありません。チームメイトの編集とコマンドは、引き続き[権限](#permissions)で説明されている権限プロンプトを通過します。承認されると、チームメイトは plan モードを終了し、実装を開始します。
+
+実行中の in-process チームメイトのセッションを表示している間に [`Shift+Tab`](/docs/ja/permission-modes#switch-permission-modes) を押してそのチームメイトを plan モードにした場合、その実行のプランは Claude Code が承認するのではなく、リーダーがレビューします。ユーザーに承認は求められません。リーダーがプランを承認するか、修正のために差し戻します。
 
 ### チームメンバーと直接通信する
@@ -287,5 +289,5 @@ Claude Code が戻すチームメンバーについて、プロジェクトの `
 チームメンバーはリーダーの権限モードで開始します。ただし、[`dontAsk` モード](/docs/ja/permission-modes#allow-only-pre-approved-tools-with-dontask-mode) は継承しません。リーダーが `--dangerously-skip-permissions` で実行する場合、すべてのチームメンバーも同様に実行します。生成後、個別のチームメンバーの権限モードを変更できますが、生成時にチームメンバーごとの権限モードを設定することはできません。
 
-チームメンバーの権限プロンプトはリーダーセッションに表示されるため、そこで自分で承認してください。[プラン承認](#have-teammates-plan-before-implementing) は設計された例外です。リーダーセッションはあなたへの別のプロンプトなしにチームメンバープラン承認を付与します。
+チームメイトの権限プロンプトはリーダーセッションに表示されるため、そこで自分で承認してください。[チームメイトのプラン](#have-teammates-plan-before-implementing) を承認する必要はありません。
 
 #### エージェント間のメッセージ
```

</details>

<details>
<summary>agent-view-ja.md</summary>

```diff
diff --git a/docs-ja/pages/agent-view-ja.md b/docs-ja/pages/agent-view-ja.md
index a7f0649..4c8c4f0 100644
--- a/docs-ja/pages/agent-view-ja.md
+++ b/docs-ja/pages/agent-view-ja.md
@@ -277,7 +277,7 @@ Claude Code が会話を再度開けない場合は、終了して会話を再
 約 10 秒経過すると、Claude Code はそれ以上待たずにセッションをバックグラウンドにします。ただし、次のようなケースは例外です：
 
-* **フォアグラウンドのサブエージェントがまだ実行中**：Claude が開始した [フォアグラウンドのサブエージェント](/docs/ja/sub-agents#run-subagents-in-foreground-or-background) の作業が引き継がれるよう、Claude Code は待機を続け、`Still backgrounding after the current tool` を表示します。待たずにバックグラウンドにするには `←` を再度押しますが、その場合それらのサブエージェントは最初からやり直しになります。
+* **フォアグラウンドのサブエージェントがまだ実行中の場合**：Claude が開始した[フォアグラウンドのサブエージェント](/docs/ja/sub-agents#run-subagents-in-foreground-or-background)の作業を引き継ぐため、Claude Code は待機を続け、`Still backgrounding after the current tool` と表示します。待たずにバックグラウンドに移すには、もう一度 `←` を押します。この場合、それらのサブエージェントは最初からやり直しになります。
 * **権限プロンプトまたは質問が回答を待っている**：権限プロンプトまたは Claude が尋ねた質問が待機している間、Claude Code は待機を続け、`Still backgrounding after the current tool — a question is waiting for your answer.` を表示します。権限プロンプトでの **Yes** など、回答によってターンが続行する場合、Claude Code は現在のツールが完了した時点でセッションをバックグラウンドにします。
-* **プロンプト入力に入力した**：未送信のテキストはターミナルの入力ボックスに残り、バックグラウンドセッションには移動しないため、Claude Code は切り替えをキャンセルします。`Backgrounding cancelled — you have unsent text in the input. Send it or clear it, then press ← again.` と表示されます。
+* **プロンプト入力に入力した**：未送信のテキストはターミナルの入力ボックスに残り、バックグラウンドセッションには移動しないため、Claude Code は切り替えをキャンセルします。`Backgrounding cancelled — you have unsent text in the input. Send it or clear it, then press ← again.` と表示されます。Claude はフォアグラウンドで作業を続けます。
 * **ターンを停止した**：Claude Code は切り替えをキャンセルし、`Backgrounding cancelled — the turn was stopped.` を表示します。たとえば、[`Esc` で Claude を中断した](/docs/ja/interactive-mode#general-controls) 場合、メインの会話からの権限プロンプトで [コメントなしで](/docs/ja/permissions#add-a-comment-when-you-answer-a-permission-prompt) **No** を選択した場合、またはそこで Claude が尋ねた質問で `Esc` を押した場合に、ターンは停止します。セッションをバックグラウンドにするには、`←` を再度押します。
 * **キューに入れたメッセージを移動できない**：[Claude の作業中にキューに入れた](/docs/ja/interactive-mode#queue-messages-while-claude-works) メッセージは、会話とともにバックグラウンドセッションに移動します。そのいずれかを移動できない場合、セッションはフォアグラウンドに留まり、Claude Code は `Cannot open agents — 1 queued message can't move to the background. Press ← again once Claude has read it.` のような通知を表示します。
@@ -289,4 +289,13 @@ Claude Code がセッションをバックグラウンドにすると（約 10 
 フォアグラウンドセッションでのこのショートカットは、`/config` の [`leftArrowOpensAgents`](/docs/ja/settings-reference#leftarrowopensagents) 設定でオフにできます。
 
+##### セッションがバックグラウンドに移動する際に送信されたプロンプト
+
+セッションがバックグラウンドに移動する瞬間にプロンプトまたは `!` シェルコマンドを入力すると、それは停止されるか、未送信のままになります：
+
+* **会話が閉じるときに送信された場合**：会話が閉じてエージェントビューが開くときに、応答またはコマンドは停止します
+* **その時点でまだ [フック](/docs/ja/hooks) を待っていた場合**：プロンプトは送信されず、画面上にもその旨は表示されません。これには、[`SessionStart` フック](/docs/ja/hooks#sessionstart) がまだ実行中の間に入力したプロンプトも含まれます
+
+どちらの場合も、入力したテキストは [プロンプト履歴](/docs/ja/interactive-mode#command-history) に保持されます。再度送信するには、バックグラウンドにしたセッションを開き、そのプロンプトで `↑` を押してテキストを呼び戻します。
+
 ### リストを整理する
 
@@ -363,5 +372,5 @@ Claude Code v2.1.212 以降でセッションを戻すには、[ディスパッ
 | `Shift+↑` / `Shift+↓` | 選択したセッションを並べ替え |
```

</details>

<details>
<summary>artifacts-ja.md</summary>

```diff
diff --git a/docs-ja/pages/artifacts-ja.md b/docs-ja/pages/artifacts-ja.md
index bd41638..7f60487 100644
--- a/docs-ja/pages/artifacts-ja.md
+++ b/docs-ja/pages/artifacts-ja.md
@@ -114,4 +114,14 @@ Claude Code は claude.ai アカウントからリストを読み込むため、
 * **公開**: インターネット上の誰でも開くことができるリンクを共有でき、claude.ai へのサインインは不要です。Team プランと Enterprise プランでは、Owner が [組織に対して公開共有を有効にする](#control-public-sharing) まで、公開共有はオフになっています。
 
+### 特定のビューにリンクする
+
+ページにタブやセクションなど複数のビューがある場合は、そのうちの 1 つに直接リンクできます。Claude にリンクを依頼してください。
+
+```text wrap theme={null}
+Give me a link to each tab of the deploy failures dashboard.
+```
+
+各リンクは、アーティファクトのリンクの末尾に `#overview` などのアンカーを付けたものです。
+
 ### 他のユーザーと一緒に編集する
 
```

</details>

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index 16c67ed..a3f8624 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,55 @@
 # Changelog
 
+## 2.1.307
+
+- Added `/claude-api api-version` to move Claude API code to API version `2026-10-21`
+- Added the `claude_code.safety_event` OpenTelemetry event for each tool call a permission rule, auto mode, a safety check, a hook or the sandbox stopped, prompted or sent back
+- Fixed requests failing with a model-not-found error when `CLAUDE_CODE_DISABLE_1M_CONTEXT` is set and the model is an alias with the `[1m]` suffix, such as `opus[1m]`
+- Fixed the `prompt-caching-scope` beta header being sent behind custom `ANTHROPIC_BASE_URL` gateways and on Foundry, where it has no effect
+- Fixed MCP servers showing "needs authentication" in `claude -p` on macOS while the login keychain was locked; they now say why, and the next run after an unlock connects without a new sign-in
+- Fixed MCP servers being reported as timed out, and staying failed in headless runs, when a macOS or Linux computer went to sleep while they were connecting
+- Fixed HTTP MCP tool calls being sent twice when the connection closed mid-call; only read-only or idempotent tools are now retried
+- Fixed a turn sometimes starting without an SDK MCP server's latest tools when a background task was running
+- Fixed some "Autocompact is thrashing" errors in turns that read many PDF pages, images or other large tool results
+- Fixed `/autocompact` in cloud sessions going back to the default window after the session restarted
+- Fixed a conversation cleared with `/clear` sometimes coming back when a cloud or self-hosted runner session restarted
+- Fixed `CLAUDE_STREAM_FIRST_BYTE_TIMEOUT_MS` being ignored in Claude apps gateway sessions
+- Fixed telemetry from Claude Desktop sessions behind a Claude apps gateway being rejected when `OTEL_EXPORTER_OTLP_HEADERS` is set
+- Fixed `/permissions` > Recently denied not showing the denied shell command, and auto mode's local classifier ignoring an approval from there when it checks a retried command; approving a row now names the command, not its description
+- Fixed `/help` and the `/` command menu showing long model-facing descriptions for bundled skills such as `/claude-api` instead of their short descriptions
+- Fixed subagent transcripts recording placeholder token usage and an empty stop reason for streamed responses
+- Fixed model switches through the Agent SDK's `setModel()`, and apps built on it, being refused when the API took more than 5 seconds to confirm the model; Claude Code now waits up to 15 seconds
+- Fixed a background command stopped through a connected app (such as the desktop app archiving an idle session) being reported to Claude as stopped by the user; the notice now names its output file
+- Fixed WebFetch in Cowork cloud sessions reporting a tool error when a site answered with a 4xx status or a robots.txt refusal; it is now a normal result, as in local sessions
+- Fixed write tools on a directly configured GitHub MCP server showing a form that closed without creating anything in the desktop app's Code tab
+- Fixed Artifact tool reads failing with a connection reset when the server had closed a reused connection
```

</details>

<details>
<summary>channels-ja.md</summary>

```diff
diff --git a/docs-ja/pages/channels-ja.md b/docs-ja/pages/channels-ja.md
index c9ab201..0191222 100644
--- a/docs-ja/pages/channels-ja.md
+++ b/docs-ja/pages/channels-ja.md
@@ -272,5 +272,5 @@ what's in my working directory?
 メッセージが Claude Code セッションに到着します。ターミナルは `← fakechat · web: what's in my working directory?` のようなインバウンドチャネル行として表示し、モデルはプラグインのスコープ付きサーバー名を使用して `<channel source="plugin:fakechat:fakechat">` イベントとして受け取ります。Claude がそれを読み、作業を実行し、Fakechat の `reply` ツールを呼び出します。Claude Code が最初の返信の権限を求める場合、それを承認してください。答えがチャット UI に表示されます。
 
-Claude がターミナルから離れている間に権限プロンプトに達した場合、セッションは応答するまで一時停止します。[権限リレー機能](/docs/ja/channels-reference#relay-permission-prompts)を宣言するチャネルサーバーは、これらのプロンプトをあなたに転送して、リモートで承認または拒否できるようにします。無人使用の場合、[`--dangerously-skip-permissions`](/docs/ja/permission-modes#skip-all-checks-with-bypasspermissions-mode) はほとんどのプロンプトをバイパスしますが、信頼できる環境でのみ使用してください。それでも、[no モードが自動承認するアクション](/docs/ja/permission-modes#actions-no-mode-auto-approves)は引き続き適用されます。
+Claude がターミナルから離れている間に権限プロンプトに達した場合、セッションは応答するまで一時停止します。[権限リレー機能](/docs/ja/channels-reference#relay-permission-prompts)を宣言するチャネルサーバーは、これらのプロンプトをあなたに転送して、リモートで承認または拒否できるようにします。無人使用の場合、[`--dangerously-skip-permissions`](/docs/ja/permission-modes#skip-all-checks-with-bypasspermissions-mode) はほとんどのプロンプトをバイパスしますが、信頼できる環境でのみ使用してください。それでも、[どのモードも自動承認しないアクション](/docs/ja/permission-modes#actions-no-mode-auto-approves)は引き続き適用されます。
 
 チャネルを `-p` で非対話モードで実行する場合、複数選択質問やプランモード承認など、ターミナル入力が必要なツールは無効になり、セッションは入力を待つために停止することはありません。
```

</details>

*...以降省略*

</details>


<details>
<summary>2026-10-21</summary>

**変更ファイル:**

```
 docs-ja/pages/accessibility-ja.md                  |   40 +-
 docs-ja/pages/admin-setup-ja.md                    |   48 +-
 docs-ja/pages/advisor-ja.md                        |   70 +-
 docs-ja/pages/agent-teams-ja.md                    |  186 +-
 docs-ja/pages/agent-view-ja.md                     |  417 ++--
 docs-ja/pages/agents-ja.md                         |   20 +-
 docs-ja/pages/amazon-bedrock-ja.md                 |  275 +--
 docs-ja/pages/analytics-ja.md                      |  140 +-
 docs-ja/pages/artifacts-ja.md                      |  181 +-
 docs-ja/pages/authentication-ja.md                 |  174 +-
 docs-ja/pages/auto-mode-classifier-billing-ja.md   |   16 +-
 docs-ja/pages/auto-mode-config-ja.md               |  110 +-
 docs-ja/pages/best-practices-ja.md                 |  374 ++-
 docs-ja/pages/champion-kit-ja.md                   |  104 +-
 docs-ja/pages/changelog.md                         |   41 +
 docs-ja/pages/channels-ja.md                       |  378 ++-
 docs-ja/pages/channels-reference-ja.md             |  526 ++--
 docs-ja/pages/checkpointing-ja.md                  |   74 +-
 docs-ja/pages/chrome-ja.md                         |  167 +-
 docs-ja/pages/claude-apps-gateway-config-ja.md     |  407 ++--
 docs-ja/pages/claude-apps-gateway-deploy-ja.md     |  134 +-
 docs-ja/pages/claude-apps-gateway-ja.md            |  448 ++--
 docs-ja/pages/claude-apps-gateway-on-aws-ja.md     |  828 ++++---
 docs-ja/pages/claude-apps-gateway-on-gcp-ja.md     |  468 ++--
 .../pages/claude-apps-gateway-spend-limits-ja.md   |   54 +-
 docs-ja/pages/claude-code-on-the-web-ja.md         |  316 +--
 docs-ja/pages/claude-directory-ja.md               | 1500 +-----------
 docs-ja/pages/claude-platform-on-aws-ja.md         |  254 +-
 docs-ja/pages/claude-projects-ja.md                |  284 +--
 docs-ja/pages/claude-security-ja.md                |   90 +-
 docs-ja/pages/cli-reference-ja.md                  |   24 +-
 docs-ja/pages/cloud-environments-ja.md             |  763 +++---
 docs-ja/pages/code-review-costs-ja.md              |   24 +-
 docs-ja/pages/code-review-customize-ja.md          |   44 +-
 docs-ja/pages/code-review-ja.md                    |   88 +-
 docs-ja/pages/code-review-local-ja.md              |   94 +-
 docs-ja/pages/code-review-pull-requests-ja.md      |  116 +-
 docs-ja/pages/code-review-setup-ja.md              |  108 +-
 docs-ja/pages/code-review-troubleshooting-ja.md    |   44 +-
 docs-ja/pages/commands-ja.md                       |   35 +-
 docs-ja/pages/common-workflows-ja.md               |  700 +++---
 docs-ja/pages/communications-kit-ja.md             |  248 +-
 docs-ja/pages/computer-use-ja.md                   |  126 +-
 docs-ja/pages/context-window-ja.md                 | 1593 +------------
 docs-ja/pages/corporate-launcher-ja.md             |  130 +-
 docs-ja/pages/costs-ja.md                          |  280 +--
 docs-ja/pages/cross-session-messaging-ja.md        |   98 +-
 docs-ja/pages/data-usage-ja.md                     |   62 +-
 docs-ja/pages/debug-your-config-ja.md              |  134 +-
 docs-ja/pages/deep-links-ja.md                     |  120 +-
 docs-ja/pages/desktop-ios-simulator-ja.md          |   94 +-
 docs-ja/pages/desktop-ja.md                        | 1207 ++++------
 docs-ja/pages/desktop-linux-ja.md                  |  116 +-
 docs-ja/pages/desktop-quickstart-ja.md             |  124 +-
 docs-ja/pages/desktop-scheduled-tasks-ja.md        |  132 +-
 docs-ja/pages/desktop-wsl-ja.md                    |   42 +-
 docs-ja/pages/devcontainer-ja.md                   |  144 +-
 docs-ja/pages/env-vars-ja.md                       |  170 +-
 docs-ja/pages/errors-ja.md                         | 1866 ++++++---------
 docs-ja/pages/fast-mode-ja.md                      |   84 +-
 docs-ja/pages/feature-availability-ja.md           |  269 +--
 docs-ja/pages/features-overview-ja.md              |  370 ++-
 docs-ja/pages/fullscreen-ja.md                     |   84 +-
 docs-ja/pages/gateways-ja.md                       |   34 +-
 docs-ja/pages/github-actions-cloud-providers-ja.md |  538 ++---
 docs-ja/pages/github-actions-ja.md                 |  158 +-
 docs-ja/pages/github-enterprise-server-ja.md       |  122 +-
 docs-ja/pages/gitlab-ci-cd-ja.md                   |  222 +-
 docs-ja/pages/glossary-ja.md                       |  280 +--
 docs-ja/pages/goal-ja.md                           |   82 +-
 docs-ja/pages/google-vertex-ai-ja.md               |  199 +-
 docs-ja/pages/headless-ja.md                       |  156 +-
 docs-ja/pages/hipaa-setup-ja.md                    |  139 +-
 docs-ja/pages/hooks-guide-ja.md                    |  590 ++---
 docs-ja/pages/hooks-ja.md                          | 1596 +++++--------
 docs-ja/pages/how-claude-code-works-ja.md          |  114 +-
 docs-ja/pages/interactive-mode-ja.md               |  323 +--
 docs-ja/pages/jetbrains-ja.md                      |  158 +-
 docs-ja/pages/keybindings-ja.md                    |  174 +-
 docs-ja/pages/large-codebases-ja.md                |   92 +-
 docs-ja/pages/legal-and-compliance-ja.md           |   48 +-
 docs-ja/pages/llm-gateway-connect-ja.md            |  508 ++--
 docs-ja/pages/llm-gateway-ja.md                    |   26 +-
 docs-ja/pages/llm-gateway-protocol-ja.md           |  152 +-
 docs-ja/pages/llm-gateway-rollout-ja.md            |  220 +-
 docs-ja/pages/managed-mcp-ja.md                    |  326 ++-
 docs-ja/pages/managed-settings-ja.md               |  174 +-
 docs-ja/pages/mcp-ja.md                            | 1034 ++++----
 docs-ja/pages/mcp-quickstart-ja.md                 |  464 ++--
 docs-ja/pages/memory-ja.md                         |  228 +-
 docs-ja/pages/microsoft-foundry-ja.md              |  151 +-
 docs-ja/pages/mobile-ja.md                         |   60 +-
 docs-ja/pages/model-config-ja.md                   |  282 +--
 docs-ja/pages/monitoring-usage-ja.md               |  416 +---
 docs-ja/pages/network-config-ja.md                 |  105 +-
 docs-ja/pages/output-styles-ja.md                  |  114 +-
 docs-ja/pages/overview-ja.md                       |  324 ++-
 docs-ja/pages/permission-modes-ja.md               |  548 ++---
 docs-ja/pages/permissions-ja.md                    |  287 +--
 docs-ja/pages/platforms-ja.md                      |   30 +-
 docs-ja/pages/plugin-evals-ja.md                   |  312 +--
 docs-ja/pages/prompt-caching-ja.md                 |  162 +-
 docs-ja/pages/prompt-library-ja.md                 | 1555 +-----------
 docs-ja/pages/quickstart-ja.md                     |  232 +-
 docs-ja/pages/remote-control-ja.md                 |  394 ++-
 docs-ja/pages/routines-ja.md                       |  537 ++---
 docs-ja/pages/sandbox-environments-ja.md           |   78 +-
 docs-ja/pages/sandboxing-ja.md                     |  440 ++--
 docs-ja/pages/scheduled-tasks-ja.md                |   97 +-
 docs-ja/pages/security-guidance-ja.md              |   78 +-
 docs-ja/pages/security-ja.md                       |   80 +-
 .../self-hosted-environments-configuration-ja.md   |  258 +-
 .../pages/self-hosted-environments-deploy-ja.md    |  257 +-
 .../pages/self-hosted-environments-identity-ja.md  |  252 +-
 docs-ja/pages/self-hosted-environments-ja.md       |   62 +-
 .../self-hosted-environments-quickstart-ja.md      |  120 +-
 .../pages/self-hosted-environments-reference-ja.md |   50 +-
 .../pages/self-hosted-environments-testing-ja.md   |   62 +-
 docs-ja/pages/server-managed-settings-ja.md        |  192 +-
 docs-ja/pages/sessions-ja.md                       |   80 +-
 docs-ja/pages/settings-example-ja.md               |  612 +++--
 docs-ja/pages/settings-ja.md                       |  590 +----
 docs-ja/pages/settings-reference-ja.md             | 2508 +++++---------------
 docs-ja/pages/setup-ja.md                          |  720 +++---
 docs-ja/pages/skills-ja.md                         |  576 ++---
 docs-ja/pages/slack-ja.md                          |  234 +-
 docs-ja/pages/statusline-ja.md                     | 1608 ++++++-------
 docs-ja/pages/sub-agents-ja.md                     |  838 +++----
 docs-ja/pages/terminal-config-ja.md                |  368 ++-
 docs-ja/pages/third-party-integrations-ja.md       |  118 +-
 docs-ja/pages/tools-reference-ja.md                |  218 +-
 docs-ja/pages/troubleshoot-install-ja.md           |  791 +++---
 docs-ja/pages/troubleshooting-ja.md                |  138 +-
 docs-ja/pages/ultrareview-ja.md                    |   56 +-
 docs-ja/pages/voice-dictation-ja.md                |  120 +-
 docs-ja/pages/vs-code-ja.md                        |  459 ++--
 docs-ja/pages/web-quickstart-ja.md                 |  234 +-
 docs-ja/pages/workflows-ja.md                      |  322 +--
 docs-ja/pages/worktrees-ja.md                      |  134 +-
 docs-ja/pages/zero-data-retention-ja.md            |   44 +-
 140 files changed, 15174 insertions(+), 28943 deletions(-)
```

<details>
<summary>accessibility-ja.md</summary>

```diff
diff --git a/docs-ja/pages/accessibility-ja.md b/docs-ja/pages/accessibility-ja.md
index dcf7f5e..e07a364 100644
--- a/docs-ja/pages/accessibility-ja.md
+++ b/docs-ja/pages/accessibility-ja.md
@@ -11,7 +11,5 @@ Claude Code には、ビジュアルターミナルインターフェースを
 スクリーンリーダーモードはオプトインです。スクリーン拡大鏡、モーション削減、またはスクリーンリーダーの代わりにカラーブラインド対応テーマを使用する場合は、[アクセシビリティ設定](#accessibility-settings)テーブルから `CLAUDE_CODE_ACCESSIBILITY`、`prefersReducedMotion`、または `theme` を設定してください。スクリーンリーダーモードはターミナルインターフェースのみを適応させるため、VS Code 拡張機能のチャットパネルではこれを必要としません。Claude Code v2.1.236 以降では、拡張機能は設定なしで[スクリーンリーダーにコンバーセーション活動を通知](/docs/ja/vs-code#use-a-screen-reader)します。
 
-<h2 id="turn-on-screen-reader-mode">
-  スクリーンリーダーモードをオンにする
-</h2>
+## スクリーンリーダーモードをオンにする
 
 スクリーンリーダーを使用する頻度に合わせて方法を選択してください。
@@ -27,13 +25,9 @@ SSH 経由で Claude Code を使用する場合は、Claude Code が実行され
 Claude Code が最初に出力する行がモードを確認します。`[Screen Reader Mode: on via flag]`、`[Screen Reader Mode: on via env]`、または `[Screen Reader Mode: on via settings]` です。
 
-<h2 id="turn-off-screen-reader-mode">
-  スクリーンリーダーモードをオフにする
-</h2>
+## スクリーンリーダーモードをオフにする
 
 モードをオンにした方法を逆にします。フラグなしで開始するか、環境変数を設定解除するか、`axScreenReader` を `false` に設定します。`CLAUDE_AX_SCREEN_READER` を `0` に設定すると、設定が `true` の場合でもモードはオフのままです。
 
-<h2 id="accessibility-settings">
-  アクセシビリティ設定
-</h2>
+## アクセシビリティ設定
 
 次の表は、各アクセシビリティオプション、フラグ、環境変数、または設定として設定するかどうか、および何を変更するかを示しています。
@@ -51,7 +45,5 @@ Claude Code が最初に出力する行がモードを確認します。`[Screen
```

</details>

<details>
<summary>admin-setup-ja.md</summary>

```diff
diff --git a/docs-ja/pages/admin-setup-ja.md b/docs-ja/pages/admin-setup-ja.md
index f3a18fe..0ed93c5 100644
--- a/docs-ja/pages/admin-setup-ja.md
+++ b/docs-ja/pages/admin-setup-ja.md
@@ -11,7 +11,7 @@ Claude Code は、ローカル開発者設定よりも優先されるマネー
 このページでは、展開の決定を順番に説明します。各行は以下のセクションと、その領域の参照ページにリンクしています。
 
-<Note>
-  SSO、SCIM プロビジョニング、シート割り当ては Claude アカウントレベルで設定されます。これらの手順については、[Claude Enterprise Administrator Guide](https://claude.com/resources/tutorials/claude-enterprise-administrator-guide) と [シート割り当て](https://support.claude.com/en/articles/11845131-use-claude-code-with-your-team-or-enterprise-plan) を参照してください。
-</Note>
+> [!NOTE]
+>
+> SSO、SCIM プロビジョニング、シート割り当ては Claude アカウントレベルで設定されます。これらの手順については、[Claude Enterprise Administrator Guide](https://claude.com/resources/tutorials/claude-enterprise-administrator-guide) と [シート割り当て](https://support.claude.com/en/articles/11845131-use-claude-code-with-your-team-or-enterprise-plan) を参照してください。
 
 | 決定 | 選択内容 | 参照 |
@@ -23,7 +23,5 @@ Claude Code は、ローカル開発者設定よりも優先されるマネー
 | [データ処理を確認する](#review-data-handling) | データ保持とコンプライアンス体制 | [Data usage](/docs/ja/data-usage)、[Security](/docs/ja/security) |
 
-<h2 id="choose-your-api-provider">
-  API プロバイダーを選択する
-</h2>
+## API プロバイダーを選択する
 
 Claude Code は複数の API プロバイダーのいずれかを通じて Claude に接続します。選択は課金、認証、継承するコンプライアンス体制、および開発者が使用できる Claude Code 機能に影響します。
@@ -37,5 +35,5 @@ Claude Code は複数の API プロバイダーのいずれかを通じて Claud
 | Microsoft Foundry | 既存の Azure コンプライアンス制御と課金を継承したい場合 |
 
-一部の Claude Code 機能には claude.ai アカウントが必要です。[web 上の Claude Code](/docs/ja/claude-code-on-the-web)、[Routines](/docs/ja/routines)、[Code Review](/docs/ja/code-review)、[Remote Control](/docs/ja/remote-control)、および [Chrome 拡張機能](/docs/ja/chrome) は、Console API キーまたはクラウドプロバイダーの認証情報だけでは利用できません。Amazon Bedrock、Google Cloud の Agent Platform、または Microsoft Foundry を通じてデプロイする場合は、開発者が Claude for Teams または Enterprise シートも必要かどうかを検討してください。各機能ページにはプラン要件が記載されています。
+一部の Claude Code 機能には claude.ai アカウントが必要です。[クラウドセッション](/docs/ja/claude-code-on-the-web)、[クラウドのスケジュールタスク](/docs/ja/routines)、[Code Review](/docs/ja/code-review)、[Remote Control](/docs/ja/remote-control)、および [Chrome 拡張機能](/docs/ja/chrome) は、Console API キーまたはクラウドプロバイダーの認証情報だけでは利用できません。Amazon Bedrock、Google Cloud の Agent Platform、または Microsoft Foundry を通じてデプロイする場合は、開発者が Claude for Teams または Enterprise シートも必要かどうかを検討してください。各機能ページにはプラン要件が記載されています。
 
```

</details>

<details>
<summary>advisor-ja.md</summary>

```diff
diff --git a/docs-ja/pages/advisor-ja.md b/docs-ja/pages/advisor-ja.md
index dd69937..2ca1537 100644
--- a/docs-ja/pages/advisor-ja.md
+++ b/docs-ja/pages/advisor-ja.md
@@ -7,7 +7,7 @@
 > メインモデルをより強力な advisor モデルと組み合わせて、タスク中の重要な瞬間に Claude が相談できるようにします。
 
-<Note>
-  advisor ツールは実験的機能であり、Anthropic API が必要です。Amazon Bedrock、Claude Platform on AWS、Google Cloud の Agent Platform、Microsoft Foundry では利用できません。動作、価格設定、および利用可能性は変更される可能性があります。
-</Note>
+> [!NOTE]
+>
+> advisor ツールは実験的機能であり、Anthropic API が必要です。Amazon Bedrock、Claude Platform on AWS、Google Cloud の Agent Platform、Microsoft Foundry では利用できません。動作、価格設定、および利用可能性は変更される可能性があります。
 
 advisor ツールを使用すると、Claude はタスク中の重要な瞬間（アプローチをコミットする前、繰り返し発生するエラーで行き詰まった場合、またはタスク完了を宣言する前など）に、通常はより強力な 2 番目のモデルに相談できます。advisor は、すべてのツール呼び出しと結果を含む完全な会話を受け取り、Claude が続行する前に適用するガイダンスを返します。
@@ -17,7 +17,5 @@ advisor は Anthropic インフラストラクチャ上でサーバー側で実
 このページでは、advisor を有効にする方法、受け入れられるモデルペアリング、相談中に Claude が表示する内容、および advisor 使用量がどのように課金されるかについて説明します。
 
-<h2 id="when-to-use-the-advisor">
-  advisor を使用する場合
-</h2>
+## advisor を使用する場合
 
 advisor は、ほとんどのターンが定型的であるが、プラン品質が結果を決定する長い複数ステップのタスクに適しています。例としては、大規模なリファクタリング、エラーが繰り返し発生するデバッグセッション、および Claude が完了を宣言する前に独立して確認したいタスクが挙げられます。
@@ -25,7 +23,5 @@ advisor は、ほとんどのターンが定型的であるが、プラン品質
 計画する必要がほとんどない短いタスク、またはすべてのターンで最強のモデルが必要な作業では、価値が低くなります。その場合は、[メインモデルを切り替える](/docs/ja/model-config#setting-your-model)か、[advisor が opusplan およびサブエージェントとどのように比較されるか](#compare-with-related-features)を参照して、2 番目の意見を得る他の方法を確認してください。
 
-<h2 id="enable-the-advisor">
-  advisor を有効にする
-</h2>
```

</details>

<details>
<summary>agent-teams-ja.md</summary>

```diff
diff --git a/docs-ja/pages/agent-teams-ja.md b/docs-ja/pages/agent-teams-ja.md
index d8d8fc6..ab3ca26 100644
--- a/docs-ja/pages/agent-teams-ja.md
+++ b/docs-ja/pages/agent-teams-ja.md
@@ -7,7 +7,7 @@
 > 複数の Claude Code インスタンスがチームとして連携して動作するように調整し、共有タスク、エージェント間メッセージング、および一元管理を実現します。
 
-<Warning>
-  エージェントチームは実験的機能であり、デフォルトでは無効になっています。[settings.json](/docs/ja/settings) または環境に `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1` を設定して有効にしてください。その変数がない場合、セッション開始時にチームが設定されず、チームディレクトリが書き込まれず、Claude はチームメンバーをスポーンまたは提案しません。エージェントチームには、セッション再開、タスク調整、シャットダウン動作に関する[既知の制限](#limitations)があります。
-</Warning>
+> [!WARNING]
+>
+> エージェントチームは実験的機能であり、デフォルトでは無効になっています。[settings.json](/docs/ja/settings) または環境に `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1` を設定して有効にしてください。その変数がない場合、セッション開始時にチームが設定されず、チームディレクトリが書き込まれず、Claude はチームメンバーをスポーンまたは提案しません。エージェントチームには、セッション再開、タスク調整、シャットダウン動作に関する[既知の制限](#limitations)があります。
 
 エージェントチームを使用すると、複数の Claude Code インスタンスが連携して動作するように調整できます。1 つのセッションがチームリーダーとして機能し、作業を調整し、タスクを割り当て、結果を統合します。チームメンバーは独立して動作し、それぞれ独自のコンテキストウィンドウで動作し、互いに直接通信します。リーダーを経由せずに、任意のチームメンバーと直接対話することもできます。
@@ -15,7 +15,5 @@
 チームを設定する前に、より軽量なオプションで十分かどうかを確認してください。[Subagents](/docs/ja/sub-agents) は単一セッション内で動作し、[クロスセッションメッセージング](/docs/ja/cross-session-messaging) を使用すると Claude は自分で実行するセッション間で検出結果を渡すことができます。
 
-<h2 id="when-to-use-agent-teams">
-  エージェントチームを使用する場合
-</h2>
+## エージェントチームを使用する場合
 
 エージェントチームは、並列探索が実際の価値を追加するタスクに最も効果的です。完全なシナリオについては、[ユースケース例](#use-case-examples)を参照してください。最も強力なユースケースは以下の通りです。
@@ -28,15 +26,9 @@
 エージェントチームは調整オーバーヘッドを追加し、単一セッションよりも大幅に多くのトークンを使用します。チームメンバーが独立して動作できる場合に最も効果的です。順序付きタスク、同じファイルの編集、または多くの依存関係を持つ作業の場合は、単一セッションまたは [subagents](/docs/ja/sub-agents) がより効果的です。
 
-<h3 id="compare-with-subagents">
-  subagents との比較
-</h3>
```

</details>

<details>
<summary>agent-view-ja.md</summary>

```diff
diff --git a/docs-ja/pages/agent-view-ja.md b/docs-ja/pages/agent-view-ja.md
index 64f64e3..a7f0649 100644
--- a/docs-ja/pages/agent-view-ja.md
+++ b/docs-ja/pages/agent-view-ja.md
@@ -9,7 +9,5 @@
 `claude agents` で開くエージェントビューは、すべてのバックグラウンドセッションの 1 つの画面です。実行中のもの、入力が必要なもの、完了したものが表示されます。新しいセッションをディスパッチし、トランスクリプトをスクロールする代わりに一目でセッションの状態を確認し、セッションが必要とするときだけ介入します。各バックグラウンドセッションは完全な Claude Code の会話であり、ターミナルが接続されていなくてもバックグラウンドで実行し続けるため、いつでも開いて、返信して、去ることができます。
 
-<img src="https://mintcdn.com/claude-code/HDAmBwgbrZVk0pOt/images/agent-view-light.png?fit=max&auto=format&n=HDAmBwgbrZVk0pOt&q=85&s=d6905012bee31f3e6b3920b09c05dd02" className="dark:hidden" alt="ターミナルのエージェントビュー。上部の行は、入力を待機しているセッション、実行中のセッション、完了したセッションの数をカウントします。4 つのセッションは「入力が必要」、「実行中」、「完了」の下にグループ化されています。各行はセッションの名前、最新のステータスまたは質問、および時間を表示します。下部には新しいタスクを説明するための入力と、キーボードヒントの行があります。" width="1872" height="680" data-path="images/agent-view-light.png" />
-
-<img src="https://mintcdn.com/claude-code/HDAmBwgbrZVk0pOt/images/agent-view-dark.png?fit=max&auto=format&n=HDAmBwgbrZVk0pOt&q=85&s=fc3c195bfc57e313ced1f1beb36cee93" className="hidden dark:block" alt="ターミナルのエージェントビュー。上部の行は、入力を待機しているセッション、実行中のセッション、完了したセッションの数をカウントします。4 つのセッションは「入力が必要」、「実行中」、「完了」の下にグループ化されています。各行はセッションの名前、最新のステータスまたは質問、および時間を表示します。下部には新しいタスクを説明するための入力と、キーボードヒントの行があります。" width="1872" height="680" data-path="images/agent-view-dark.png" />
+![ターミナルのエージェントビュー。上部の行は、入力を待機しているセッション、実行中のセッション、完了したセッションの数をカウントします。4 つのセッションは「入力が必要」、「実行中」、「完了」の下にグループ化されています。各行はセッションの名前、最新のステータスまたは質問、および時間を表示します。下部には新しいタスクを説明するための入力と、キーボードヒントの行があります。](https://mintcdn.com/claude-code/HDAmBwgbrZVk0pOt/images/agent-view-light.png?fit=max\&auto=format\&n=HDAmBwgbrZVk0pOt\&q=85\&s=d6905012bee31f3e6b3920b09c05dd02)
 
 Claude が複数の独立したタスクに対して、あなたが毎ステップを監視することなく作業できる場合に、エージェントビューを使用します。バグ修正、プルリクエストレビュー、不安定なテストの調査を 3 つの行としてディスパッチし、別のウィンドウで作業を続け、行が入力が必要であることを示すか、結果が得られたときに確認します。
@@ -19,83 +17,79 @@ Claude が複数の独立したタスクに対して、あなたが毎ステッ
 エージェントビューを subagents、agent teams、worktrees と比較するには、[エージェントを並列で実行する](/docs/ja/agents)を参照してください。エージェントビューはあなたのマシン上でセッションを実行し、各セッションをディスパッチします。1 つの会話からクラウドで Claude が並列セッションを開始して追跡するには、[Projects](/docs/ja/claude-projects)を参照してください。
 
-<Note>
-  エージェントビューはリサーチプレビュー中です。インターフェースとキーボードショートカットは機能の進化に伴って変更される可能性があります。
-</Note>
+> [!NOTE]
+>
+> エージェントビューはリサーチプレビュー中です。インターフェースとキーボードショートカットは機能の進化に伴って変更される可能性があります。
 
-<h2 id="quick-start">
-  クイックスタート
-</h2>
+## クイックスタート
 
 このチュートリアルでは、コアエージェントビューループについて説明します。タスクをディスパッチし、Claude が作業する際に行が更新されるのを見守り、ピークして確認して返信し、フル会話にアタッチします。ディスパッチしたセッションはエージェントビューを閉じた後も実行し続けるため、離れて後で戻ることができます。
 
```

</details>

<!-- UPDATE_LOG_END -->
