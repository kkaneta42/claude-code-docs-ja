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

<details>
<summary>channels-ja.md</summary>

```diff
diff --git a/docs-ja/pages/channels-ja.md b/docs-ja/pages/channels-ja.md
index 9579881..84a5ad5 100644
--- a/docs-ja/pages/channels-ja.md
+++ b/docs-ja/pages/channels-ja.md
@@ -19,13 +19,5 @@
 Claude がチャネルを通じて返信する場合、ターミナルに受信メッセージが表示されますが、返信テキストは表示されません。ターミナルはツール呼び出しと確認（「送信済み」など）を表示し、実際の返信は他のプラットフォームに表示されます。
 
-このページでは以下をカバーしています。
-
-* [サポートされているチャネル](#supported-channels)：Telegram、Discord、iMessage のセットアップ
-* [チャネルをインストールして実行する](#quickstart)（fakechat、localhost デモ）
-* [メッセージをプッシュできるユーザー](#security)：送信者許可リストとペアリング方法
-* [組織のチャネルを有効にする](#enterprise-controls)（Team および Enterprise）
-* [チャネルの比較方法](#how-channels-compare)（ウェブセッション、Slack、MCP、リモートコントロール）
-
-独自のチャネルを構築するには、[チャネルリファレンス](/ja/channels-reference)を参照してください。
+Team、Enterprise、または Console 組織を管理している場合は、[組織のチャネルを有効にする](#enterprise-controls)を参照してください。独自のチャネルを構築するには、[チャネルリファレンス](/ja/channels-reference)を参照してください。
 
 <h2 id="supported-channels">
```

</details>

<details>
<summary>devcontainer-ja.md</summary>

```diff
diff --git a/docs-ja/pages/devcontainer-ja.md b/docs-ja/pages/devcontainer-ja.md
index b8e179c..308bbed 100644
--- a/docs-ja/pages/devcontainer-ja.md
+++ b/docs-ja/pages/devcontainer-ja.md
@@ -9,10 +9,5 @@
 [開発コンテナ](https://containers.dev/)（dev container）を使用すると、チームのすべてのエンジニアが実行できる同一の分離環境を定義できます。Claude Code がそのコンテナにインストールされている場合、Claude が実行するコマンドはホストマシンではなくコンテナ内で実行され、プロジェクトファイルへの編集はローカルリポジトリに表示されます。
 
-このページでは、[開発コンテナに Claude Code をインストール](#add-claude-code-to-your-dev-container)する方法と、その後の設定トピックについて説明します。各トピックは独立しているため、必要な設定に合わせてジャンプしてください：
-
-* [再構築時に認証と設定を保持する](#persist-authentication-and-settings-across-rebuilds)
-* [組織ポリシーを適用する](#enforce-organization-policy)
-* [ネットワークエグレスを制限する](#restrict-network-egress)
-* [権限プロンプトなしで実行する](#run-without-permission-prompts)
+このページでは、[開発コンテナに Claude Code をインストール](#add-claude-code-to-your-dev-container)する方法と、その後の自己完結型の設定トピックについて説明します。認証をリビルド全体で保持する、組織ポリシーを適用する、ネットワークエグレスを制限する、権限プロンプトなしで実行するなどです。セットアップに合致するものをお読みください。
 
 <Warning>
```

</details>

<details>
<summary>env-vars-ja.md</summary>

```diff
diff --git a/docs-ja/pages/env-vars-ja.md b/docs-ja/pages/env-vars-ja.md
index 0a91aa7..163289e 100644
--- a/docs-ja/pages/env-vars-ja.md
+++ b/docs-ja/pages/env-vars-ja.md
@@ -238,5 +238,5 @@ Claude Code は起動時に環境変数を読み取るため、変更は `claude
 | `CLAUDE_CODE_OAUTH_SCOPES`                              | リフレッシュトークンが発行されたスペース区切りの OAuth スコープ（例：`"user:profile user:inference user:sessions:claude_code"`）。`CLAUDE_CODE_OAUTH_REFRESH_TOKEN` が設定されている場合は必須です                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
 | `CLAUDE_CODE_OAUTH_TOKEN`                               | Claude.ai 認証用の OAuth アクセストークン。SDK および自動化された環境での `/login` の代替。キーチェーンに保存された認証情報よりも優先されます。[`claude setup-token`](/ja/authentication#generate-a-long-lived-token) で生成します                                                                                                                                                                                                                                                                                                                                                                                                                                             |
-| `CLAUDE_CODE_OPUS_4_6_FAST_MODE_OVERRIDE`               | {/* max-version: 2.1.159 */}v2.1.160 で削除されました。現在は no-op です。以前は [高速モード](/ja/fast-mode) を現在のデフォルトの代わりに Claude Opus 4.6 にピンしていました。Opus 4.6 が廃止されるまで高速モード Opus 4.6 で実行するには、最初に `/model` でモデルを選択してから、`/fast on` を実行します                                                                                                                                                                                                                                                                                                                                                                                                |
+| `CLAUDE_CODE_OPUS_4_6_FAST_MODE_OVERRIDE`               | {/* max-version: 2.1.159 */}v2.1.160 で削除されました。現在は no-op です。以前は [高速モード](/ja/fast-mode) を現在のデフォルトの代わりに Claude Opus 4.6 にピンしていました                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
 | `CLAUDE_CODE_OTEL_DIAG_STDERR`                          | {/* min-version: 2.1.179 */}OpenTelemetry エクスポーター診断エラーを stderr に書き込むには `1` に設定します。デフォルトでは、これらのエラーは `--debug` でのみ表示されるため、Prometheus ポート衝突などの設定が間違ったエクスポーターはそれ以外の場合、サイレントに失敗します。Claude Code v2.1.179 以降が必須です。[監視](/ja/monitoring-usage) を参照してください                                                                                                                                                                                                                                                                                                                                                                  |
 | `CLAUDE_CODE_OTEL_FLUSH_TIMEOUT_MS`                     | 保留中の OpenTelemetry スパンをフラッシュするためのタイムアウト（ミリ秒）（デフォルト：5000）。[監視](/ja/monitoring-usage) を参照してください                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
```

</details>

<details>
<summary>fast-mode-ja.md</summary>

```diff
diff --git a/docs-ja/pages/fast-mode-ja.md b/docs-ja/pages/fast-mode-ja.md
index 636106a..3d7ff2c 100644
--- a/docs-ja/pages/fast-mode-ja.md
+++ b/docs-ja/pages/fast-mode-ja.md
@@ -13,8 +13,8 @@
 高速モードは Claude Opus の高速構成で、モデルを最大 2.5 倍高速化しますが、トークンあたりのコストは高くなります。迅速な反復やライブデバッグなどのインタラクティブな作業で速度が必要な場合は `/fast` でオンにし、コストがレイテンシーより重要な場合はオフにします。
 
-高速モードは異なるモデルではありません。Claude Opus を使用していますが、コスト効率よりも速度を優先する異なる API 構成です。同じ品質と機能が得られ、レスポンスが高速化されるだけです。高速モードは Opus 4.8、Opus 4.7、および Opus 4.6 でサポートされています。Sonnet、Haiku、または他のモデルでは利用できません。
+高速モードは異なるモデルではありません。Claude Opus を使用していますが、コスト効率よりも速度を優先する異なる API 構成です。同じ品質と機能が得られ、レスポンスが高速化されるだけです。高速モードは Opus 4.8 および Opus 4.7 でサポートされています。Sonnet、Haiku、または他のモデルでは利用できません。
 
 <Warning>
-  Opus 4.6 の高速モードは非推奨であり、Opus 4.8 のローンチ後約 30 日で削除される予定です。削除後、Opus 4.6 の高速モードは標準速度で標準価格にフォールバックします。高速化を維持するには Opus 4.8 または Opus 4.7 に移行してください。
+  Opus 4.7 の高速モードは 2026 年 6 月 25 日時点で非推奨となり、2026 年 7 月 24 日に削除される予定です。削除後、Opus 4.7 の高速モードリクエストはエラーを返し、標準 Opus 4.7 にフォールバックしません。高速化を維持するには Opus 4.8 に移行してください。
 </Warning>
 
@@ -26,10 +26,8 @@
 
 * Claude Code CLI で `/fast` を使用して高速モードをオンにします。VS Code Extension では高速モードはサポートされていません。
-* 高速モード価格は Opus 4.8 で $10/$50 MTok、Opus 4.7 および Opus 4.6 で $30/$150 MTok です。
+* 高速モード価格は Opus 4.8 で入力/出力あたり $10/$50 MTok、Opus 4.7 で $30/$150 MTok です。
 * サブスクリプションプラン（Pro/Max/Team/Enterprise）の Claude Code ユーザーと Claude Console のすべてのユーザーが利用可能です。
 * サブスクリプションプラン（Pro/Max/Team/Enterprise）の Claude Code ユーザーの場合、高速モードは使用量クレジットのみで利用可能であり、サブスクリプションレート制限に含まれていません。
 
-このページでは、[高速モードの切り替え](#toggle-fast-mode)、[コストのトレードオフ](#understand-the-cost-tradeoff)、[使用時期の判断](#decide-when-to-use-fast-mode)、[要件](#requirements)、[セッションごとのオプトイン](#require-per-session-opt-in)、および[レート制限の処理](#handle-rate-limits)について説明します。
-
 <h2 id="toggle-fast-mode">
   高速モードの切り替え
@@ -62,8 +60,8 @@ Opus 4.8 は Claude Code v2.1.154 以降の高速モードのデフォルトで
 高速モードは標準 Opus よりもトークンあたりの価格が高くなります。乗数はモデルによって異なります：
 
```

</details>

<details>
<summary>fullscreen-ja.md</summary>

```diff
diff --git a/docs-ja/pages/fullscreen-ja.md b/docs-ja/pages/fullscreen-ja.md
index 2540987..495d472 100644
--- a/docs-ja/pages/fullscreen-ja.md
+++ b/docs-ja/pages/fullscreen-ja.md
@@ -23,5 +23,5 @@
 </h2>
 
-Claude Code の会話内で `/tui fullscreen` を実行してください。CLI は [`tui` 設定](/ja/settings#available-settings)を保存し、会話をそのままにしてフルスクリーンで再起動するため、コンテキストを失わずにセッション中に切り替えることができます。引数なしで `/tui` を実行して、どのレンダラーがアクティブかを確認してください。
+Claude Code の会話内で `/tui fullscreen` を実行してください。CLI は [`tui` 設定](/ja/settings#available-settings)を保存し、会話をそのままにしてフルスクリーンで再起動するため、コンテキストを失わずにセッション中に切り替えることができます。`/tui default` を実行してクラシックレンダラーに戻すか、引数なしで `/tui` を実行してどのレンダラーがアクティブかを確認してください。
 
 Claude Code を起動する前に `CLAUDE_CODE_NO_FLICKER` 環境変数を設定することもできます。
```

</details>

<details>
<summary>goal-ja.md</summary>

```diff
diff --git a/docs-ja/pages/goal-ja.md b/docs-ja/pages/goal-ja.md
index 457d90a..10ee28c 100644
--- a/docs-ja/pages/goal-ja.md
+++ b/docs-ja/pages/goal-ja.md
@@ -20,11 +20,4 @@
 * ラベル付きの問題バックログを処理し、キューが空になるまで
 
-このページでは以下について説明します。
-
-* [セッションを実行し続ける方法の比較](#compare-ways-to-keep-a-session-running)：`/loop`、Stop hook、および自動モード
-* [ゴールの設定](#set-a-goal)と[効果的な条件の作成](#write-an-effective-condition)
-* [ステータスの確認](#check-status)、[早期クリア](#clear-a-goal)、および[非対話的な実行](#run-non-interactively)
-* [評価の仕組み](#how-evaluation-works)と[要件](#requirements)を確認
-
 <h2 id="compare-ways-to-keep-a-session-running">
   セッションを実行し続ける方法の比較
```

</details>

*...以降省略*

</details>


<details>
<summary>2026-06-26</summary>

**変更ファイル:**

```
 docs-ja/pages/admin-setup-ja.md              |  28 +--
 docs-ja/pages/agent-teams-ja.md              |   2 +
 docs-ja/pages/agent-view-ja.md               |   2 +-
 docs-ja/pages/amazon-bedrock-ja.md           |   2 +-
 docs-ja/pages/artifacts-ja.md                |   2 +-
 docs-ja/pages/authentication-ja.md           |   2 +-
 docs-ja/pages/best-practices-ja.md           |   2 +-
 docs-ja/pages/changelog.md                   |  18 ++
 docs-ja/pages/channels-ja.md                 |   4 +-
 docs-ja/pages/checkpointing-ja.md            |   6 +
 docs-ja/pages/claude-code-on-the-web-ja.md   |   2 +-
 docs-ja/pages/cli-reference-ja.md            |   2 +-
 docs-ja/pages/code-review-ja.md              |   2 +-
 docs-ja/pages/costs-ja.md                    |   2 +-
 docs-ja/pages/debug-your-config-ja.md        |   3 +-
 docs-ja/pages/env-vars-ja.md                 |   4 +-
 docs-ja/pages/errors-ja.md                   |  10 +-
 docs-ja/pages/fast-mode-ja.md                |  10 +-
 docs-ja/pages/features-overview-ja.md        |   2 +-
 docs-ja/pages/github-enterprise-server-ja.md |   4 +-
 docs-ja/pages/glossary-ja.md                 |   2 +-
 docs-ja/pages/hooks-guide-ja.md              |   2 +-
 docs-ja/pages/hooks-ja.md                    |  14 +-
 docs-ja/pages/interactive-mode-ja.md         |  38 ++--
 docs-ja/pages/llm-gateway-ja.md              | 269 +++++++--------------------
 docs-ja/pages/mcp-ja.md                      |   4 +-
 docs-ja/pages/mcp-quickstart-ja.md           |   2 +
 docs-ja/pages/monitoring-usage-ja.md         |   4 +-
 docs-ja/pages/overview-ja.md                 |   2 +
 docs-ja/pages/permission-modes-ja.md         |   2 +-
 docs-ja/pages/quickstart-ja.md               |   2 +
 docs-ja/pages/remote-control-ja.md           |  83 ++++++++-
 docs-ja/pages/routines-ja.md                 |   8 +-
 docs-ja/pages/sandboxing-ja.md               |   4 +-
 docs-ja/pages/server-managed-settings-ja.md  |   9 +-
 docs-ja/pages/settings-ja.md                 |  23 +--
 docs-ja/pages/setup-ja.md                    |   2 +
 docs-ja/pages/third-party-integrations-ja.md |   8 +-
 docs-ja/pages/ultrareview-ja.md              |   2 +-
 docs-ja/pages/web-quickstart-ja.md           |   8 +-
 40 files changed, 290 insertions(+), 307 deletions(-)
```

**新規追加:**


<details>
<summary>admin-setup-ja.md</summary>

```diff
diff --git a/docs-ja/pages/admin-setup-ja.md b/docs-ja/pages/admin-setup-ja.md
index 78221e8..8c5ff4e 100644
--- a/docs-ja/pages/admin-setup-ja.md
+++ b/docs-ja/pages/admin-setup-ja.md
@@ -74,18 +74,18 @@ plist と HKLM レジストリの場所は任意のプロバイダーで機能
 マネージド設定は、ツール、サンドボックス実行、MCP サーバーとプラグインソースへのアクセスをロックダウンし、実行されるフックを制御できます。各行は、それを駆動する設定キーを持つ制御サーフェスです。
 
-| 制御                                                                                     | 機能                                                                                                                                                | キー設定                                                                                                   |
-| :------------------------------------------------------------------------------------- | :------------------------------------------------------------------------------------------------------------------------------------------------ | :----------------------------------------------------------------------------------------------------- |
-| [Permission rules](/ja/permissions)                                                    | 特定のツールとコマンドを許可、確認、または拒否する                                                                                                                         | `permissions.allow`、`permissions.deny`                                                                 |
-| [Permission lockdown](/ja/permissions#managed-only-settings)                           | マネージドパーミッションルールのみが適用される。`--dangerously-skip-permissions` を無効化する                                                                                   | `allowManagedPermissionRulesOnly`、`permissions.disableBypassPermissionsMode`                           |
-| [Sandboxing](/ja/sandboxing)                                                           | ドメイン許可リスト付きの OS レベルのファイルシステムとネットワーク分離                                                                                                             | `sandbox.enabled`、`sandbox.network.allowedDomains`                                                     |
-| [Managed policy CLAUDE.md](/ja/memory#deploy-organization-wide-claude-md)              | すべてのセッションで読み込まれる組織全体の指示。除外できない                                                                                                                    | マネージドポリシーパスのファイル                                                                                       |
-| [MCP server control](/ja/managed-mcp)                                                  | ユーザーが追加または接続できる MCP サーバーを制限するか、固定セットをデプロイする                                                                                                       | `allowedMcpServers`、`deniedMcpServers`、`allowManagedMcpServersOnly`、またはデプロイされた `managed-mcp.json` ファイル |
-| [Plugin marketplace control](/ja/plugin-marketplaces#managed-marketplace-restrictions) | ユーザーが追加およびインストールできるマーケットプレイスソースを制限する                                                                                                              | `strictKnownMarketplaces`、`blockedMarketplaces`                                                        |
-| [Customization lockdown](/ja/settings#strictpluginonlycustomization)                   | スキル、エージェント、フック、および MCP サーバーをユーザーおよびプロジェクトソースからブロックし、プラグインまたはマネージド設定からのみ取得できるようにする                                                                 | `strictPluginOnlyCustomization`                                                                        |
-| [Hook restrictions](/ja/settings#hook-configuration)                                   | マネージドフックのみが読み込まれる。HTTP フック URL を制限する                                                                                                              | `allowManagedHooksOnly`、`allowedHttpHookUrls`                                                          |
-| [Disable agent view](/ja/agent-view#how-background-sessions-are-hosted)                | `claude agents`、`--bg`、`/background`、およびオンデマンドスーパーバイザーをオフにする                                                                                      | `disableAgentView`                                                                                     |
-| [Model restrictions](/ja/model-config#restrict-model-selection)                        | ユーザーが選択できるモデルを制限し、オプションでデフォルトモデル選択にも許可リストを適用する。この設定が CLI、ウェブ、IDE にどのように到達するかについては、[surface coverage](/ja/model-config#surface-coverage) を参照してください | `availableModels`、`enforceAvailableModels`                                                             |
-| [Version floor](/ja/settings)                                                          | 自動更新が組織全体の最小値より下にインストールされるのを防ぐ                                                                                                                    | `minimumVersion`                                                                                       |
-| [Required version range](/ja/settings)                                                 | 実行中のバージョンが組織承認の範囲外の場合、まったく起動を拒否する。`minimumVersion` より強力で、ダウングレードのみをブロックする                                                                         | `requiredMinimumVersion`、`requiredMaximumVersion`                                                      |
+| 制御                                                                                     | 機能                                                                                                                                                                                                    | キー設定                                                                                                   |
+| :------------------------------------------------------------------------------------- | :---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :----------------------------------------------------------------------------------------------------- |
+| [Permission rules](/ja/permissions)                                                    | 特定のツールとコマンドを許可、確認、または拒否する                                                                                                                                                                             | `permissions.allow`、`permissions.deny`                                                                 |
+| [Permission lockdown](/ja/permissions#managed-only-settings)                           | マネージドパーミッションルールのみが適用される。`--dangerously-skip-permissions` を無効化する                                                                                                                                       | `allowManagedPermissionRulesOnly`、`permissions.disableBypassPermissionsMode`                           |
+| [Sandboxing](/ja/sandboxing)                                                           | ドメイン許可リスト付きの OS レベルのファイルシステムとネットワーク分離                                                                                                                                                                 | `sandbox.enabled`、`sandbox.network.allowedDomains`                                                     |
+| [Managed policy CLAUDE.md](/ja/memory#deploy-organization-wide-claude-md)              | すべてのセッションで読み込まれる組織全体の指示。除外できない                                                                                                                                                                        | マネージドポリシーパスのファイル                                                                                       |
+| [MCP server control](/ja/managed-mcp)                                                  | ユーザーが追加または接続できる MCP サーバーを制限するか、固定セットをデプロイする                                                                                                                                                           | `allowedMcpServers`、`deniedMcpServers`、`allowManagedMcpServersOnly`、またはデプロイされた `managed-mcp.json` ファイル |
+| [Plugin marketplace control](/ja/plugin-marketplaces#managed-marketplace-restrictions) | ユーザーが追加およびインストールできるマーケットプレイスソースを制限する                                                                                                                                                                  | `strictKnownMarketplaces`、`blockedMarketplaces`                                                        |
+| [Customization lockdown](/ja/settings#strictpluginonlycustomization)                   | スキル、エージェント、フック、および MCP サーバーをユーザーおよびプロジェクトソースからブロックし、プラグインまたはマネージド設定からのみ取得できるようにする                                                                                                                     | `strictPluginOnlyCustomization`                                                                        |
```

</details>

<details>
<summary>agent-teams-ja.md</summary>

```diff
diff --git a/docs-ja/pages/agent-teams-ja.md b/docs-ja/pages/agent-teams-ja.md
index 1c4a354..87f5a87 100644
--- a/docs-ja/pages/agent-teams-ja.md
+++ b/docs-ja/pages/agent-teams-ja.md
@@ -156,4 +156,6 @@ each teammate.
 チームメンバーはデフォルトではリーダーの `/model` 選択を継承しません。プロンプトで指定されていない場合に使用されるモデルを変更するには、`/config` で **Default teammate model** を設定してください。チームメンバーがリーダーの現在のモデルに従うようにするには、**Default (leader's model)** を選択してください。
 
+{/* min-version: 2.1.186 */}チームメンバーはリーダーの[努力レベル](/ja/model-config#adjust-effort-level)を継承します。分割ペインモードではこれは v2.1.186 から適用されます。それより前のバージョンではリーダーのセッション努力を分割ペインチームメンバーに渡しませんでした。
+
 <h3 id="require-plan-approval-for-teammates">
   チームメンバーのプラン承認を要求する
```

</details>

<details>
<summary>agent-view-ja.md</summary>

```diff
diff --git a/docs-ja/pages/agent-view-ja.md b/docs-ja/pages/agent-view-ja.md
index 55f5768..90fe71c 100644
--- a/docs-ja/pages/agent-view-ja.md
+++ b/docs-ja/pages/agent-view-ja.md
@@ -325,5 +325,5 @@ v2.1.145 以降では、[音声ディクテーション](/ja/voice-dictation) 
 </h3>
 
-`--bg` を渡してセッションを直接バックグラウンドに送信します：
+`--bg` またはその長い形式 `--background` を渡してセッションを直接バックグラウンドに送信します：
 
 ```bash theme={null}
```

</details>

<details>
<summary>amazon-bedrock-ja.md</summary>

```diff
diff --git a/docs-ja/pages/amazon-bedrock-ja.md b/docs-ja/pages/amazon-bedrock-ja.md
index 4a6bb5b..b6fd13f 100644
--- a/docs-ja/pages/amazon-bedrock-ja.md
+++ b/docs-ja/pages/amazon-bedrock-ja.md
@@ -478,5 +478,5 @@ export CLAUDE_CODE_USE_MANTLE=1
 ```
 
-Mantle モデルを `/model` ピッカーに表示するには、[settings file](/ja/settings) の `availableModels` にその ID をリストします。この設定はピッカーをリストされたエントリに制限するため、保持したいバージョンのバージョンプレフィックスまたは完全な ID もリストします。[Merge behavior](/ja/model-config#merge-behavior) を参照してください。
+Mantle モデルを `/model` ピッカーに表示するには、[settings file](/ja/settings) の `availableModels` にその ID をリストします。この設定はピッカーをリストされたエントリに制限するため、保持したいバージョンのバージョンプレフィックスまたは完全な ID もリストします。Mantle ID と `haiku` エイリアスは同じモデルファミリーに解決されるため、マージは より具体的なエントリのみを保持します。[Merge behavior](/ja/model-config#merge-behavior) を参照してください。
 
 ```json theme={null}
```

</details>

<details>
<summary>artifacts-ja.md</summary>

```diff
diff --git a/docs-ja/pages/artifacts-ja.md b/docs-ja/pages/artifacts-ja.md
index 4001ea7..46a22fc 100644
--- a/docs-ja/pages/artifacts-ja.md
+++ b/docs-ja/pages/artifacts-ja.md
@@ -200,5 +200,5 @@ Claude はデザインシステムを独自の選択よりも高い優先度と
 | 要件        | 利用可能な場合                                                                                                                                                                                                                |
 | :-------- | :--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
-| プラン       | Team または Enterprise。Team プランでは、アーティファクトはデフォルトで有効です。Enterprise プランでは、管理者が claude.ai 管理設定で[有効にします](#manage-artifacts-for-your-organization)。                                                                             |
+| プラン       | Team または Enterprise。Team プランでは、アーティファクトはデフォルトで有効です。Enterprise プランでは、Owner が claude.ai 管理設定で[有効にします](#manage-artifacts-for-your-organization)。                                                                          |
 | 認証        | `/login` で claude.ai にサインインしています。API キー、[ゲートウェイトークン](/ja/llm-gateway)、またはクラウドプロバイダー認証情報を使用するセッションは公開できません。                                                                                                             |
 | モデルプロバイダー | Anthropic API。[Amazon Bedrock](/ja/amazon-bedrock)、[Google Cloud Vertex AI](/ja/google-vertex-ai)、または [Microsoft Foundry](/ja/microsoft-foundry) では利用できません。                                                            |
```

</details>

<details>
<summary>authentication-ja.md</summary>

```diff
diff --git a/docs-ja/pages/authentication-ja.md b/docs-ja/pages/authentication-ja.md
index fb172dc..6810308 100644
--- a/docs-ja/pages/authentication-ja.md
+++ b/docs-ja/pages/authentication-ja.md
@@ -137,5 +137,5 @@ Claude Code は認証情報を安全に管理します。
 * **遅いヘルパー通知**: `apiKeyHelper` がキーを返すのに 10 秒以上かかる場合、Claude Code はプロンプトバーに経過時間を表示する警告通知を表示します。この通知が定期的に表示される場合は、認証情報スクリプトを最適化できるかどうかを確認してください。
 
-`apiKeyHelper`、`ANTHROPIC_API_KEY`、および `ANTHROPIC_AUTH_TOKEN` はターミナル CLI セッションにのみ適用されます。Claude Desktop とクラウドセッションは OAuth のみを使用し、`apiKeyHelper` を呼び出したり、API キー環境変数を読み込んだりしません。
+`apiKeyHelper`、`ANTHROPIC_API_KEY`、および `ANTHROPIC_AUTH_TOKEN` は CLI およびそれをラップするサーフェス（VS Code 拡張機能、Agent SDK、GitHub Actions を含む）に適用されます。Claude Desktop とクラウドセッションは `apiKeyHelper` を呼び出したり、これらの環境変数を読み込んだりしません。OAuth を使用します。ただし、[組織配布のサードパーティ推論設定](/ja/llm-gateway-connect#desktop-app)を実行しているデスクトップセッションは、その設定の認証情報で認証します。
 
 <h3 id="authentication-precedence">
```

</details>

<details>
<summary>best-practices-ja.md</summary>

```diff
diff --git a/docs-ja/pages/best-practices-ja.md b/docs-ja/pages/best-practices-ja.md
index e548ab6..2b85e48 100644
--- a/docs-ja/pages/best-practices-ja.md
+++ b/docs-ja/pages/best-practices-ja.md
@@ -594,5 +594,5 @@ claude -p "<your prompt>" --output-format json | your_command
 </h3>
 
-無中断の実行と背景のセーフティチェックについては、[auto mode](/ja/permission-modes#eliminate-prompts-with-auto-mode) を使用します。分類器モデルはコマンドを実行前にレビューし、スコープエスカレーション、未知のインフラストラクチャ、敵対的なコンテンツ駆動のアクションをブロックしながら、ルーチンワークをプロンプトなしで進めさせます。
+無中断の実行とバックグラウンドのセーフティチェックについては、[auto mode](/ja/permission-modes#eliminate-prompts-with-auto-mode) を使用します。分類器モデルはコマンドを実行前にレビューし、スコープエスカレーション、未知のインフラストラクチャ、敵対的なコンテンツ駆動のアクションをブロックしながら、ルーチンワークをプロンプトなしで進めさせます。
 
 ```bash theme={null}
```

</details>

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index 98d57ef..534a987 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,22 @@
 # Changelog
 
+## 2.1.193
+
+- Added `autoMode.classifyAllShell` setting to route all Bash/PowerShell commands through the auto-mode classifier instead of only arbitrary-code-execution patterns
+- Added auto-mode denial reasons to the transcript, the denial toast, and `/permissions` recent denials
+- Added `claude_code.assistant_response` OpenTelemetry log event containing the model's response text. Redacted unless `OTEL_LOG_ASSISTANT_RESPONSES=1`; when that var is unset it follows `OTEL_LOG_USER_PROMPTS`, so deployments that already log prompt content will start receiving response content on upgrade — set `OTEL_LOG_ASSISTANT_RESPONSES=0` to keep prompts-only.
+- Added live file path autocomplete to bash mode (`!`)
+- Added a startup notice when MCP servers need authentication, pointing at `/mcp`
+- Added automatic memory-pressure reaping for idle background shell commands (disable with `CLAUDE_CODE_DISABLE_BG_SHELL_PRESSURE_REAP=1`)
+- Fixed `/model` and other client-data-gated UI showing stale/empty state immediately after `/login`
+- Fixed backgrounding (←←) spuriously cancelling with "N background tasks would be abandoned" when all running tasks carry over to the new session
+- Fixed pinned background agents being re-prompted to "Continue from where you left off" after every auto-update
+- Fixed backgrounding the main turn spawning a phantom "general-purpose (resumed)" subagent that re-ran the main conversation
+- Fixed agent panel hiding sibling agents when viewing a subagent
+- Improved background agents: the launch result no longer instructs Claude to "end your response" — it keeps working on other tasks while the agent runs
+- Improved MCP `headersHelper` auth: the helper now re-runs and reconnects automatically when a tool call returns 401/403
+- Improved plugin auto-rename: marketplace `renames` maps are now followed automatically, updating your settings to the new name
+- Improved `/add-dir` message when the directory is already a working directory
+
 ## 2.1.191
 
```

</details>

<details>
<summary>channels-ja.md</summary>

```diff
diff --git a/docs-ja/pages/channels-ja.md b/docs-ja/pages/channels-ja.md
index 32b82d0..9579881 100644
--- a/docs-ja/pages/channels-ja.md
+++ b/docs-ja/pages/channels-ja.md
@@ -301,5 +301,5 @@ iMessage は異なります。自分自身にテキストを送信するとゲ
 管理者は 2 つの[管理設定](/ja/settings)を通じて可用性を制御します。ユーザーはこれらをオーバーライドできません。デフォルトは認証方法によって異なります。
 
-* **claude.ai Team および Enterprise**：チャネルは管理者が有効にするまでブロックされます。
+* **claude.ai Team および Enterprise**：チャネルは Owner が有効にするまでブロックされます。
 * **Anthropic Console と API キー認証**：チャネルはデフォルトで許可されます。組織が管理設定をデプロイする場合のみこの設定が必要です。
 
@@ -317,5 +317,5 @@ iMessage は異なります。自分自身にテキストを送信するとゲ
 </h3>
 
-管理者は [**claude.ai → Admin settings → Claude Code → Channels**](https://claude.ai/admin-settings/claude-code) からチャネルを有効にするか、管理設定で `channelsEnabled` を `true` に設定できます。
+[**claude.ai → Admin settings → Claude Code → Channels**](https://claude.ai/admin-settings/claude-code) から組織のチャネルを有効にします。これには Owner ロールが必要です。または、管理設定で `channelsEnabled` を `true` に設定します。
 
 有効にすると、組織内のユーザーは `--channels` を使用して個別のセッションにチャネルサーバーをオプトインできます。設定が無効または未設定の場合、MCP サーバーは接続され、そのツールは機能しますが、チャネルメッセージは到着しません。スタートアップ警告は、ユーザーに管理者が設定を有効にするよう指示します。
```

</details>

<details>
<summary>checkpointing-ja.md</summary>

```diff
diff --git a/docs-ja/pages/checkpointing-ja.md b/docs-ja/pages/checkpointing-ja.md
index 20adba9..4611de8 100644
--- a/docs-ja/pages/checkpointing-ja.md
+++ b/docs-ja/pages/checkpointing-ja.md
@@ -48,4 +48,10 @@ Claude Code は、ファイル編集ツールで行われたすべての変更
 「ここまで要約」を選択すると、会話の最後に留まり、入力フィールドは空になります。
 
+<h4 id="rewind-past-a-cleared-conversation">
+  クリアされた会話を超えて巻き戻す
+</h4>
+
+同じ Claude Code プロセスの前の段階で `/clear` を実行した場合、巻き戻しメニューはリストの最上部に `/resume <session-id>（前のセッション）` というラベルの追加エントリを表示します。これを選択して、`/clear` が実行される前にアクティブだった会話を再開します。このエントリは Claude Code を終了するか別のセッションを再開するまで利用可能であり、Claude Code v2.1.191 以降が必要です。以前のバージョンでは、`/resume` を実行してリストから前のセッションを選択してください。
+
 <h4 id="restore-vs-summarize">
   復元と要約の違い
```

</details>

<details>
<summary>claude-code-on-the-web-ja.md</summary>

```diff
diff --git a/docs-ja/pages/claude-code-on-the-web-ja.md b/docs-ja/pages/claude-code-on-the-web-ja.md
index acd0c35..001aade 100644
--- a/docs-ja/pages/claude-code-on-the-web-ja.md
+++ b/docs-ja/pages/claude-code-on-the-web-ja.md
@@ -874,5 +874,5 @@ Claude は PR を解決する際に GitHub のレビューコメントスレッ
 * ローカルで `/login` を実行して認証情報をリフレッシュし、再接続してください
 * セッションを所有する同じアカウントにサインインしていることを確認してください
-* `Remote Control may not be available for this organization` が表示される場合、管理者がプランのクラウドセッションを有効にしていません
+* `Remote Control may not be available for this organization` が表示される場合、Owner がクラウドセッションを組織に対して有効にしていません
 
 <h3 id="environment-expired">
```

</details>

*...以降省略*

</details>


<details>
<summary>2026-06-25</summary>

**変更ファイル:**

```
 docs-ja/pages/admin-setup-ja.md             | 29 ++++++-----
 docs-ja/pages/advisor-ja.md                 | 16 +++---
 docs-ja/pages/amazon-bedrock-ja.md          |  4 +-
 docs-ja/pages/changelog.md                  | 27 ++++++++++
 docs-ja/pages/claude-code-on-the-web-ja.md  | 39 +++++++-------
 docs-ja/pages/commands-ja.md                |  2 +-
 docs-ja/pages/desktop-ja.md                 | 28 +++++-----
 docs-ja/pages/discover-plugins-ja.md        |  4 ++
 docs-ja/pages/env-vars-ja.md                |  1 +
 docs-ja/pages/errors-ja.md                  | 17 ++++++
 docs-ja/pages/fast-mode-ja.md               |  2 +-
 docs-ja/pages/fullscreen-ja.md              |  1 +
 docs-ja/pages/github-actions-ja.md          |  4 +-
 docs-ja/pages/glossary-ja.md                |  4 +-
 docs-ja/pages/interactive-mode-ja.md        |  3 +-
 docs-ja/pages/mcp-ja.md                     |  2 +
 docs-ja/pages/monitoring-usage-ja.md        |  2 +-
 docs-ja/pages/permission-modes-ja.md        |  8 +--
 docs-ja/pages/sandboxing-ja.md              | 34 +++++++++++-
 docs-ja/pages/server-managed-settings-ja.md | 21 ++++----
 docs-ja/pages/settings-ja.md                | 81 ++++++++++++++++-------------
 docs-ja/pages/skills-ja.md                  | 36 ++++++-------
 docs-ja/pages/sub-agents-ja.md              |  4 ++
 docs-ja/pages/voice-dictation-ja.md         |  4 +-
 24 files changed, 237 insertions(+), 136 deletions(-)
```

<details>
<summary>admin-setup-ja.md</summary>

```diff
diff --git a/docs-ja/pages/admin-setup-ja.md b/docs-ja/pages/admin-setup-ja.md
index a692aae..78221e8 100644
--- a/docs-ja/pages/admin-setup-ja.md
+++ b/docs-ja/pages/admin-setup-ja.md
@@ -64,5 +64,5 @@ plist と HKLM レジストリの場所は任意のプロバイダーで機能
 デフォルトでは WSL は `/etc/claude-code` の Linux ファイルパスのみを読み取ります。同じマシン上の WSL に Windows レジストリと `C:\Program Files\ClaudeCode` ポリシーを拡張するには、これらの管理者のみが使用できる Windows ソースのいずれかで [`wslInheritsWindowsSettings: true`](/ja/settings#available-settings) を設定してください。
 
-どのメカニズムを選択しても、マネージド値はユーザーおよびプロジェクト設定よりも優先されます。`permissions.allow` や `permissions.deny` などの配列設定は、すべてのソースからのエントリをマージするため、開発者はマネージドリストを拡張できますが、削除することはできません。
+どのメカニズムを選択しても、マネージド値はユーザーおよびプロジェクト設定よりも優先されます。`permissions.allow` や `permissions.deny` などの配列設定は、すべてのソースからのエントリをマージするため、開発者はマネージドリストを拡張できますが、削除することはできません。[2 つの例外](/ja/settings#settings-precedence) があります。`fallbackModel` と `availableModels` では、マネージド値は下位レイヤーとマージするのではなく、置き換えます。
 
 [Server-managed settings](/ja/server-managed-settings) と [Settings files and precedence](/ja/settings#settings-files) を参照してください。
@@ -74,17 +74,18 @@ plist と HKLM レジストリの場所は任意のプロバイダーで機能
 マネージド設定は、ツール、サンドボックス実行、MCP サーバーとプラグインソースへのアクセスをロックダウンし、実行されるフックを制御できます。各行は、それを駆動する設定キーを持つ制御サーフェスです。
 
-| 制御                                                                                     | 機能                                                                                | キー設定                                                                                                   |
-| :------------------------------------------------------------------------------------- | :-------------------------------------------------------------------------------- | :----------------------------------------------------------------------------------------------------- |
-| [Permission rules](/ja/permissions)                                                    | 特定のツールとコマンドを許可、確認、または拒否する                                                         | `permissions.allow`、`permissions.deny`                                                                 |
-| [Permission lockdown](/ja/permissions#managed-only-settings)                           | マネージドパーミッションルールのみが適用される。`--dangerously-skip-permissions` を無効化する                   | `allowManagedPermissionRulesOnly`、`permissions.disableBypassPermissionsMode`                           |
-| [Sandboxing](/ja/sandboxing)                                                           | ドメイン許可リスト付きの OS レベルのファイルシステムとネットワーク分離                                             | `sandbox.enabled`、`sandbox.network.allowedDomains`                                                     |
-| [Managed policy CLAUDE.md](/ja/memory#deploy-organization-wide-claude-md)              | すべてのセッションで読み込まれる組織全体の指示。除外できない                                                    | マネージドポリシーパスのファイル                                                                                       |
-| [MCP server control](/ja/managed-mcp)                                                  | ユーザーが追加または接続できる MCP サーバーを制限するか、固定セットをデプロイする                                       | `allowedMcpServers`、`deniedMcpServers`、`allowManagedMcpServersOnly`、またはデプロイされた `managed-mcp.json` ファイル |
-| [Plugin marketplace control](/ja/plugin-marketplaces#managed-marketplace-restrictions) | ユーザーが追加およびインストールできるマーケットプレイスソースを制限する                                              | `strictKnownMarketplaces`、`blockedMarketplaces`                                                        |
-| [Customization lockdown](/ja/settings#strictpluginonlycustomization)                   | スキル、エージェント、フック、および MCP サーバーをユーザーおよびプロジェクトソースからブロックし、プラグインまたはマネージド設定からのみ取得できるようにする | `strictPluginOnlyCustomization`                                                                        |
-| [Hook restrictions](/ja/settings#hook-configuration)                                   | マネージドフックのみが読み込まれる。HTTP フック URL を制限する                                              | `allowManagedHooksOnly`、`allowedHttpHookUrls`                                                          |
-| [Disable agent view](/ja/agent-view#how-background-sessions-are-hosted)                | `claude agents`、`--bg`、`/background`、およびオンデマンドスーパーバイザーをオフにする                      | `disableAgentView`                                                                                     |
-| [Version floor](/ja/settings)                                                          | 自動更新が組織全体の最小値より下にインストールされるのを防ぐ                                                    | `minimumVersion`                                                                                       |
-| [Required version range](/ja/settings)                                                 | 実行中のバージョンが組織承認の範囲外の場合、まったく起動を拒否する。`minimumVersion` より強力で、ダウングレードのみをブロックする         | `requiredMinimumVersion`、`requiredMaximumVersion`                                                      |
+| 制御                                                                                     | 機能                                                                                                                                                | キー設定                                                                                                   |
+| :------------------------------------------------------------------------------------- | :------------------------------------------------------------------------------------------------------------------------------------------------ | :----------------------------------------------------------------------------------------------------- |
+| [Permission rules](/ja/permissions)                                                    | 特定のツールとコマンドを許可、確認、または拒否する                                                                                                                         | `permissions.allow`、`permissions.deny`                                                                 |
```

</details>

<details>
<summary>advisor-ja.md</summary>

```diff
diff --git a/docs-ja/pages/advisor-ja.md b/docs-ja/pages/advisor-ja.md
index e404b48..0445cf9 100644
--- a/docs-ja/pages/advisor-ja.md
+++ b/docs-ja/pages/advisor-ja.md
@@ -53,5 +53,5 @@ advisor モデルは 3 つの方法で設定できます。
 ```
 
-選択は、ユーザー設定の `advisorModel` に保存され、セッション全体で保持されます。現在のメインモデルが advisor をサポートしていない場合、選択は引き続き保存され、[`/model`](/ja/model-config#setting-your-model)で[互換性のあるメインモデル](#choose-an-advisor-model)に切り替えるときにアクティブになります。
+選択は、ユーザー設定の `advisorModel` に保存され、セッション全体で保持されます。組織の [`availableModels`](/ja/model-config#restrict-model-selection)許可リストが保存された advisor モデルを除外している場合、`/advisor` で許可されたモデルを選択するまで advisor は呼び出されません。現在のメインモデルが advisor をサポートしていない場合、選択は引き続き保存され、[`/model`](/ja/model-config#setting-your-model)で[互換性のあるメインモデル](#choose-an-advisor-model)に切り替えるときにアクティブになります。
 
 <h3 id="set-advisormodel-in-settings">
@@ -77,5 +77,5 @@ claude --advisor opus
 ```
 
-フラグはそのセッションの `advisorModel` 設定よりも優先されます。`/advisor` とは異なり、セッションのメインモデルが advisor をサポートしていない場合、フラグはエラーで終了します。
+フラグはそのセッションの `advisorModel` 設定よりも優先されます。セッションのメインモデルが advisor をサポートしていない場合、またはリクエストされた advisor モデルが組織の [`availableModels`](/ja/model-config#restrict-model-selection)許可リストで除外されている場合、エラーで終了します。
 
 <h2 id="choose-an-advisor-model">
@@ -182,10 +182,10 @@ advisor ツール全体（`/advisor` コマンドと `--advisor` フラグを含
 advisor は、モデルの強みを組み合わせるいくつかの方法の 1 つです。2 番目のモデルをいつ関与させるかに基づいて選択します。
 
-| アプローチ                                                 | より強力なモデルが実行される場合                | 開始方法                          |
-| ----------------------------------------------------- | ------------------------------- | ----------------------------- |
-| Advisor ツール                                           | タスク中の決定ポイント                     | Claude がガイダンスが必要な場合に呼び出します    |
-| [`opusplan`](/ja/model-config#opusplan-model-setting) | プランモード中、その後実行用に Sonnet に切り替わります | プランモードに入ります                   |
-| [サブエージェント](/ja/sub-agents#choose-a-model)（`model` 設定） | 委任されたサブタスク全体                    | Claude が委任するか、サブエージェントを呼び出します |
-| [`/model`](/ja/model-config#setting-your-model)       | 後続のすべてのターン                      | モデルを切り替えます                    |
+| アプローチ                                                 | より強力なモデルが実行される場合                                                                                          | 開始方法                          |
+| ----------------------------------------------------- | --------------------------------------------------------------------------------------------------------- | ----------------------------- |
+| Advisor ツール                                           | タスク中の決定ポイント                                                                                               | Claude がガイダンスが必要な場合に呼び出します    |
```

</details>

<details>
<summary>amazon-bedrock-ja.md</summary>

```diff
diff --git a/docs-ja/pages/amazon-bedrock-ja.md b/docs-ja/pages/amazon-bedrock-ja.md
index 8292c40..4a6bb5b 100644
--- a/docs-ja/pages/amazon-bedrock-ja.md
+++ b/docs-ja/pages/amazon-bedrock-ja.md
@@ -478,9 +478,9 @@ export CLAUDE_CODE_USE_MANTLE=1
 ```
 
-Mantle モデルを `/model` ピッカーに表示するには、[settings file](/ja/settings) の `availableModels` にその ID をリストします。この設定はピッカーをリストされたエントリに制限するため、保持したいすべてのエイリアスを含めます。
+Mantle モデルを `/model` ピッカーに表示するには、[settings file](/ja/settings) の `availableModels` にその ID をリストします。この設定はピッカーをリストされたエントリに制限するため、保持したいバージョンのバージョンプレフィックスまたは完全な ID もリストします。[Merge behavior](/ja/model-config#merge-behavior) を参照してください。
 
 ```json theme={null}
 {
-  "availableModels": ["opus", "sonnet", "haiku", "anthropic.claude-haiku-4-5"]
+  "availableModels": ["opus", "sonnet", "claude-haiku-4-5", "anthropic.claude-haiku-4-5"]
 }
 ```
```

</details>

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index 3507be5..98d57ef 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,31 @@
 # Changelog
 
+## 2.1.191
+
+- Added `/rewind` support for resuming a conversation from before `/clear` was run
+- Fixed scroll position jumping to the bottom while reading earlier output during a streaming response
+- Fixed background agents resurrecting after being stopped — stopping an agent from the tasks panel is now permanent
+- Fixed `/voice` showing a generic "not available" message when disabled by an organization's policy — it now explains the restriction
+- Fixed `/login` URL opening truncated in Windows Terminal when it wraps across lines
+- Fixed Cmd+click on links in fullscreen mode for Ghostty over ssh/tmux
+- Fixed `claude agents` sending builtin slash commands like `/usage` to background sessions as prompt text instead of showing a hint
+- Fixed `claude agents` job rows showing full filesystem paths for pasted images instead of the `[Image #N]` placeholder
+- Fixed hooks with comma-separated matchers (e.g. `"Bash,PowerShell"`) silently never firing
+- Fixed `/permissions` Recently-denied tab: approving a denial now persists on close instead of being silently discarded
+- Fixed the agent panel jumping by one row when scrolling the roster past the overflow cap
+- Fixed the welcome splash art overflowing the default 80×24 macOS Terminal window
+- Fixed managed settings: `forceRemoteSettingsRefresh` now takes effect when set via MDM or file policy, and the fetch sends `Cache-Control: no-cache` to prevent proxies from serving stale responses
+- Improved sandbox network permission dialog: hosts you allow with "Yes" are now remembered for the rest of the session instead of re-prompting on every connection
+- Improved MCP server reliability: capability discovery (`tools/list`, `prompts/list`, `resources/list`) now retries transient network errors with short backoff
+- Improved MCP OAuth: discovery and token requests now retry once after transient network errors, and headless environments skip the browser popup and go straight to the paste-the-URL prompt
+- Improved MCP error messages: HTTP 404 errors now show the URL and point to your MCP config
+- Improved vim mode prompt-history search (NORMAL `/`) to hint how to reach slash commands
+- Reduced CPU usage during streaming responses by ~37% by coalescing text updates to 100ms
+- Reduced long-session memory growth from terminal output cache
+
```

</details>

<details>
<summary>claude-code-on-the-web-ja.md</summary>

```diff
diff --git a/docs-ja/pages/claude-code-on-the-web-ja.md b/docs-ja/pages/claude-code-on-the-web-ja.md
index 6d126df..acd0c35 100644
--- a/docs-ja/pages/claude-code-on-the-web-ja.md
+++ b/docs-ja/pages/claude-code-on-the-web-ja.md
@@ -64,22 +64,23 @@ Team および Enterprise 管理者は [claude.ai/admin-settings/claude-code](ht
 </h3>
 
-クラウドセッションはリポジトリの新しいクローンから開始されます。リポジトリにコミットされたものはすべて利用可能です。自分のマシンにのみインストールまたは設定したものは利用できません。
-
-|                                                                    | クラウドセッションで利用可能 | 理由                                                                                                         |
-| :----------------------------------------------------------------- | :------------- | :--------------------------------------------------------------------------------------------------------- |
-| リポジトリの `CLAUDE.md`                                                 | はい             | クローンの一部                                                                                                    |
-| リポジトリの `.claude/settings.json` フック                                 | はい             | クローンの一部                                                                                                    |
-| リポジトリの `.mcp.json` MCP サーバー                                        | はい             | クローンの一部                                                                                                    |
-| リポジトリの `.claude/rules/`                                            | はい             | クローンの一部                                                                                                    |
-| リポジトリの `.claude/skills/`、`.claude/agents/`、`.claude/commands/`     | はい             | クローンの一部                                                                                                    |
-| `.claude/settings.json` で宣言されたプラグイン                                | はい             | 宣言した[マーケットプレイス](/ja/plugin-marketplaces)からセッション開始時にインストールされます。マーケットプレイスソースに到達するためにはネットワークアクセスが必要です         |
-| ユーザー `~/.claude/CLAUDE.md`                                         | いいえ            | マシンに存在し、リポジトリには存在しません                                                                                      |
-| ユーザー `~/.claude/skills/`、`~/.claude/agents/`、`~/.claude/commands/` | いいえ            | マシンに存在し、リポジトリには存在しません。代わりにリポジトリの `.claude/` ディレクトリにコミットしてください。claude.ai で有効にしたスキルはクラウドセッションに自動的にロードされます    |
-| ユーザー設定でのみ有効なプラグイン                                                  | いいえ            | ユーザースコープの `enabledPlugins` は `~/.claude/settings.json` に存在します。代わりにリポジトリの `.claude/settings.json` で宣言してください |
-| `claude mcp add` で追加した MCP サーバー                                    | いいえ            | これらはローカルユーザー設定に書き込まれ、リポジトリには書き込まれません。代わりに [`.mcp.json`](/ja/mcp#project-scope) でサーバーを宣言してください              |
-| 静的 API トークンと認証情報                                                   | いいえ            | 専用シークレットストアはまだ存在しません。以下を参照してください                                                                           |
-| AWS SSO のようなインタラクティブ認証                                             | いいえ            | サポートされていません。SSO はクラウドセッションで実行できないブラウザベースのログインが必要です                                                         |
-
-クラウドセッションで設定を利用可能にするには、リポジトリにコミットしてください。専用シークレットストアはまだ利用できません。環境変数とセットアップスクリプトの両方は環境設定に保存され、その環境を編集できる誰もが見ることができます。クラウドセッションでシークレットが必要な場合は、その可視性を念頭に置いて環境変数として追加してください。
+クラウドセッションはリポジトリの新しいクローンから開始されます。リポジトリにコミットされたものはすべて利用可能です。自分のマシンにのみインストールまたは設定したものは利用できません。組織のポリシーは [サーバー管理設定](/ja/server-managed-settings)を通じて別途到着します。
+
+|                                                                    | クラウドセッションで利用可能 | 理由                                                                                                                                                                                                                         |
+| :----------------------------------------------------------------- | :------------- | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
+| リポジトリの `CLAUDE.md`                                                 | はい             | クローンの一部                                                                                                                                                                                                                    |
```

</details>

<details>
<summary>commands-ja.md</summary>

```diff
diff --git a/docs-ja/pages/commands-ja.md b/docs-ja/pages/commands-ja.md
index ff8fc31..13d234b 100644
--- a/docs-ja/pages/commands-ja.md
+++ b/docs-ja/pages/commands-ja.md
@@ -89,5 +89,5 @@
 | `/init`                                                                            | `CLAUDE.md` ガイドでプロジェクトを初期化します。スキル、フック、個人メモリファイルをウォークスルーするインタラクティブフローについては、`CLAUDE_CODE_NEW_INIT=1` を設定します                                                                                                                                                                                                                                                                                                                                                                                                      |
 | `/insights`                                                                        | Claude Code セッションを分析するレポートを生成します。プロジェクト領域、相互作用パターン、および摩擦点を含みます                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
-| `/install-github-app`                                                              | リポジトリ用の [Claude GitHub Actions](/ja/github-actions) アプリをセットアップします。リポジトリを選択して統合を構成するプロセスをガイドします                                                                                                                                                                                                                                                                                                                                                                                                                 |
+| `/install-github-app`                                                              | リポジトリ用の Claude GitHub App をインストールします。オプションで [GitHub Actions](/ja/github-actions) ワークフローとシークレットをセットアップするステップを含みます。リポジトリを選択して統合を構成するプロセスをガイドします                                                                                                                                                                                                                                                                                                                                                                  |
 | `/install-slack-app`                                                               | Claude Slack アプリをインストールします。OAuth フローを完了するためにブラウザを開きます                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
 | `/keybindings`                                                                     | キーバインディング設定ファイルを開きます                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
```

</details>

<details>
<summary>desktop-ja.md</summary>

```diff
diff --git a/docs-ja/pages/desktop-ja.md b/docs-ja/pages/desktop-ja.md
index dbaf842..587803f 100644
--- a/docs-ja/pages/desktop-ja.md
+++ b/docs-ja/pages/desktop-ja.md
@@ -692,16 +692,20 @@ Team または Enterprise プランの組織は、管理コンソールコント
 </h3>
 
-管理設定はプロジェクトおよびユーザー設定をオーバーライドし、Desktop が CLI セッションを生成するときに適用されます。これらのキーを組織の[管理設定](/ja/settings#settings-precedence)ファイルで設定するか、管理コンソールを通じてリモートでプッシュできます。
-
-| キー                                         | 説明                                                                                                                                                                                              |
-| ------------------------------------------ | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
-| `permissions.disableBypassPermissionsMode` | ユーザーが Bypass permissions モードを有効にするのを防ぐには`"disable"`に設定します。                                                                                                                                      |
-| `disableAutoMode`                          | ユーザーが[Auto](/ja/permission-modes#eliminate-prompts-with-auto-mode)モードを有効にするのを防ぐには`"disable"`に設定します。モードセレクタから Auto を削除します。`permissions`の下でも受け入れられます。                                             |
-| `autoMode`                                 | 組織全体で auto mode 分類器が信頼およびブロックするものをカスタマイズします。[auto mode を設定する](/ja/auto-mode-config)を参照してください。                                                                                                   |
-| `sshConfigs`                               | 環境ドロップダウンに表示される[SSH 接続](#pre-configure-ssh-connections-for-your-team)を事前設定します。ユーザーは管理接続を編集または削除できません。                                                                                           |
-| `sshHostAllowlist`                         | [SSH セッション](#restrict-which-ssh-hosts-users-can-connect-to)を、解決されたホスト名がこれらのパターンのいずれかと一致するホストに制限します。空の配列は SSH セッションを無効にします。管理設定からのみ読み取られます。                                                      |
-| `managedMcpServers`                        | MCP サーバー設定をサードパーティデプロイメント内のすべてのユーザーにプッシュします。各エントリは`"http"`、`"sse"`、または`"stdio"`のトランスポート、接続詳細、およびオプションで、そのサーバー内のどのツールをユーザーが呼び出せるかを制限する`toolPolicy`マップを指定します。サードパーティ（3P）Desktop デプロイメントでのみ利用可能です。 |
-
-ディスク上の各マシンにデプロイされた管理設定ファイルは Desktop セッションに適用されます。管理コンソールを通じてリモートでプッシュされた管理設定は、現在 CLI および IDE セッションにのみ適用されるため、Desktop デプロイメントの場合は MDM 経由でファイルを配布するか、上記の[管理コンソールコントロール](#admin-console-controls)を使用してください。
+管理設定はプロジェクトおよびユーザー設定をオーバーライドし、Claude Code セッションに Desktop で適用されます。これらのキーを組織の[管理設定](/ja/settings#settings-precedence)ファイルで設定するか、管理コンソールを通じてリモートでプッシュできます。
+
+| キー                                         | 説明                                                                                                                                                                                                                                                                    |
+| ------------------------------------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
+| `permissions.disableBypassPermissionsMode` | ユーザーが Bypass permissions モードを有効にするのを防ぐには`"disable"`に設定します。                                                                                                                                                                                                            |
+| `disableAutoMode`                          | ユーザーが[Auto](/ja/permission-modes#eliminate-prompts-with-auto-mode)モードを有効にするのを防ぐには`"disable"`に設定します。モードセレクタから Auto を削除します。`permissions`の下でも受け入れられます。                                                                                                                   |
+| `autoMode`                                 | 組織全体で auto mode 分類器が信頼およびブロックするものをカスタマイズします。[auto mode を設定する](/ja/auto-mode-config)を参照してください。                                                                                                                                                                         |
+| `sshConfigs`                               | 環境ドロップダウンに表示される[SSH 接続](#pre-configure-ssh-connections-for-your-team)を事前設定します。ユーザーは管理接続を編集または削除できません。                                                                                                                                                                 |
+| `sshHostAllowlist`                         | [SSH セッション](#restrict-which-ssh-hosts-users-can-connect-to)を、解決されたホスト名がこれらのパターンのいずれかと一致するホストに制限します。空の配列は SSH セッションを無効にします。管理設定からのみ読み取られます。                                                                                                                            |
+| `managedMcpServers`                        | MCP サーバー設定をサードパーティデプロイメント内のすべてのユーザーにプッシュします。各エントリは`"http"`、`"sse"`、または`"stdio"`のトランスポート、接続詳細、およびオプションで、そのサーバー内のどのツールをユーザーが呼び出せるかを制限する`toolPolicy`マップを指定します。サードパーティ（3P）Desktop デプロイメントでのみ利用可能です。管理設定ファイルまたは MDM を通じてこのキーを配信してください。サードパーティデプロイメントは管理コンソール設定を受け取らないためです。 |
+
```

</details>

*...以降省略*

</details>


<details>
<summary>2026-06-24</summary>

**変更ファイル:**

```
 docs-ja/pages/agent-view-ja.md             | 35 +++++++++++++++++++++++++++---
 docs-ja/pages/changelog.md                 | 24 ++++++++++++++++++++
 docs-ja/pages/claude-code-on-the-web-ja.md |  1 +
 docs-ja/pages/skills-ja.md                 |  1 +
 docs-ja/pages/slack-ja.md                  | 16 +++++++++++++-
 5 files changed, 73 insertions(+), 4 deletions(-)
```

<details>
<summary>agent-view-ja.md</summary>

```diff
diff --git a/docs-ja/pages/agent-view-ja.md b/docs-ja/pages/agent-view-ja.md
index 6333b01..55f5768 100644
--- a/docs-ja/pages/agent-view-ja.md
+++ b/docs-ja/pages/agent-view-ja.md
@@ -282,5 +282,5 @@ v2.1.145 以降では、[音声ディクテーション](/ja/voice-dictation) 
 | `Shift+Enter`                    | ディスパッチして新しいセッションに直ちにアタッチ                                                                                 |
 
-エージェントビュー自体で実行される少数のコマンドがあります。ディスパッチの代わりに：`/exit` および `/quit` はエージェントビューを閉じ、`/logout` はサインアウトします。その他のすべてのコマンドとスキルは、新しいバックグラウンドセッションにその最初のプロンプトとして送信されます。
+エージェントビュー自体で実行される少数のコマンドがあります。ディスパッチの代わりに：`/exit` および `/quit` はエージェントビューを閉じ、`/logout` はサインアウトします。`/model` はディスパッチモデルを設定します。skills、独自のコマンド、および `/init` などのプロンプト展開組み込みは、新しいバックグラウンドセッションにその最初のプロンプトとして送信されます。その他の組み込みコマンドは、代わりに `attach to a session to run it` ヒントを表示します。
 
 繰り返しタスクを [skill](/ja/skills) としてパッケージ化すると、プロンプトを再入力せずにエージェントビューから同じワークフローを何度も開始できます。
@@ -413,4 +413,13 @@ git リポジトリの外では、セッションは作業ディレクトリに
 エージェントビューヘッダーに表示されるモデル名はディスパッチのデフォルトです。入力から開始する新しいセッションはこのモデルを使用します。これは [`model` setting](/ja/settings#available-settings) からユーザー設定で取得されます。[`/model` picker](/ja/model-config) でモデルを選択して設定するか、設定を直接編集します。エージェントビューセッション全体でオーバーライドするには、エージェントビューを開く際に `--model` を渡します。[パーミッションモード、モデル、および努力](#permission-mode-model-and-effort) を参照してください。
 
+エージェントビューの入力でディスパッチモデルを変更するには、ディスパッチ入力に `/model` の後にモデル名を入力して `Enter` を押します。ヘッダーは `(session)` マーカー付きでそのモデルを表示するように更新され、その後ディスパッチするセッションはそれを使用します。`/model default` と入力してオーバーライドをクリアし、ディスパッチのデフォルトに戻します。このオーバーライドは現在の `claude agents` 実行の残りの間続き、設定ファイルに書き込まれず、Claude Code v2.1.172 以降が必要です。{/* min-version: 2.1.172 */} 次の例は、1 つのセッションを Opus でディスパッチし、次のセッションを Sonnet でディスパッチします：
+
+```text theme={null}
+/model opus
+refactor auth
+/model sonnet
+run the test suite
+```
+
 各バックグラウンドセッションは異なるモデルで実行できます。1 つのセッションでオーバーライドするには：
 
@@ -423,5 +432,7 @@ git リポジトリの外では、セッションは作業ディレクトリに
 </h3>
 
-バックグラウンドセッションは、そこで `claude` を開始した場合と同じように、実行されるディレクトリから [settings](/ja/settings) を読み取ります。
+バックグラウンドセッションは、そこで `claude` を開始した場合と同じように、実行されるディレクトリから [settings](/ja/settings) を読み取ります。これには、プロジェクト設定の [`env` values](/ja/settings#available-settings) が含まれるため、そこで設定された `ANTHROPIC_MODEL` またはプロバイダー変数がそのディレクトリのバックグラウンドセッションに適用されます。
```

</details>

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index 3c832a7..3507be5 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,28 @@
 # Changelog
 
+## 2.1.187
+
+- Added `sandbox.credentials` setting to block sandboxed commands from reading credential files and secret environment variables
+- Added org-configured model restrictions to the model picker, `--model`, `/model`, and `ANTHROPIC_MODEL`, with a "restricted by your organization's settings" message when a restricted model is selected
+- Added mouse click support to select menus (permission prompts, `/model`, `/config`, etc.) in fullscreen mode
+- Fixed `--resume` failing with "No conversation found" when the original `-p` run produced no model turns
+- Fixed `--json-schema` and workflow `agent({schema})` structured output: the model can no longer re-call `StructuredOutput` indefinitely after a successful call, and follow-up turns now reliably return structured output
+- Fixed remote MCP tool calls that hang with no response for 5 minutes — they now abort with an error instead of blocking indefinitely (override with `CLAUDE_CODE_MCP_TOOL_IDLE_TIMEOUT`)
+- Fixed Claude Code Remote sessions taking ~2.7s longer to start after the agent proxy CA system-trust install was added
+- Fixed pasted Korean/CJK text turning into mojibake in terminals that deliver paste as per-byte extended-key events
+- Fixed `/update` over Remote Control hanging when a startup trust dialog would have shown
+- Fixed background jobs in the agents view getting stuck in "working" indefinitely when the agent ended a turn without producing structured output
+- Fixed channel connections dropping after navigating to the agents view and back, and after `/bg`, `/tui`, or `/update`
+- Fixed agent stop notifications not correctly attributing who stopped the agent, and improved wording ("finished"/"stopped" instead of "came to rest")
+- Fixed subagent depth tracking: resumed subagents now restore their original spawn depth, and forked subagents now count toward the depth cap
+- Fixed leaked agent worktree registrations: locked `.git/worktrees/` entries from killed agents are now cleaned up automatically
+- Fixed Cmd+click not opening URLs in fullscreen mode in Ghostty on macOS
+- Fixed `claude --help` not listing the `--bg`/`--background` flag
+- Fixed Esc, Ctrl-C, and Ctrl-D not working while `/share` is uploading
+- Improved `/install-github-app`: GitHub Actions workflow setup is now optional — you can install just the GitHub App and skip the workflow/secret steps
+- Improved `/btw` with ←/→ arrow navigation to step through earlier answers
+- Improved `/plugin` to surface plugins you haven't used recently so you can clean them up
+- [VSCode] Fixed extension becoming unresponsive when resuming a large session
```

</details>

<details>
<summary>claude-code-on-the-web-ja.md</summary>

```diff
diff --git a/docs-ja/pages/claude-code-on-the-web-ja.md b/docs-ja/pages/claude-code-on-the-web-ja.md
index 3058b3c..6d126df 100644
--- a/docs-ja/pages/claude-code-on-the-web-ja.md
+++ b/docs-ja/pages/claude-code-on-the-web-ja.md
@@ -905,2 +905,3 @@ Claude は PR を解決する際に GitHub のレビューコメントスレッ
 * [セキュリティ](/ja/security)：分離保証とデータ処理
 * [データ使用](/ja/data-usage)：Anthropic がクラウドセッションから保持するもの
+* [Claude Tag](https://claude.com/docs/claude-tag/overview)：Slack で実行される組織管理の @Claude で、同じクラウド環境で動作
```

</details>

<details>
<summary>skills-ja.md</summary>

```diff
diff --git a/docs-ja/pages/skills-ja.md b/docs-ja/pages/skills-ja.md
index 265b1d9..c54da1f 100644
--- a/docs-ja/pages/skills-ja.md
+++ b/docs-ja/pages/skills-ja.md
@@ -915,2 +915,3 @@ Claude がスキルを使用したくない場合：
 * **[コマンド](/ja/commands)**：組み込みコマンドとバンドルされたスキルのリファレンス
 * **[権限](/ja/permissions)**：ツールとスキルアクセスを制御する
+* **[Claude Tag スキル](https://claude.com/docs/claude-tag/admins/skills-repo)**：リポジトリにコミットされたプロジェクトスキルは、そのリポジトリが Claude Tag チャネルで使用される場合にも読み込まれます
```

</details>

<details>
<summary>slack-ja.md</summary>

```diff
diff --git a/docs-ja/pages/slack-ja.md b/docs-ja/pages/slack-ja.md
index 45ca981..81b9aef 100644
--- a/docs-ja/pages/slack-ja.md
+++ b/docs-ja/pages/slack-ja.md
@@ -7,7 +7,11 @@
 > Slack ワークスペースから直接コーディングタスクを委任する
 
+<Note>
+  Claude Code in Slack は、Team および Enterprise ワークスペース向けに [Claude Tag](https://claude.com/docs/claude-tag/overview) に置き換わります。Claude Tag は、管理者が設定したアクセス権限を持つ組織の共有 ID として @Claude を実行し、同じ Slack アプリの下で動作するため、再インストールする必要がなく、既存のセットアップは移行中も機能し続けます。ワークスペースを切り替えるには、[Claude in Slack の以前のバージョンから移行する](https://claude.com/docs/claude-tag/admins/migrate-from-earlier)を参照してください。
+</Note>
+
 Slack での Claude Code は、Claude Code の機能を Slack ワークスペースに直接もたらします。`@Claude` にコーディングタスクをメンションすると、Claude は自動的に意図を検出し、ウェブ上で Claude Code セッションを作成します。これにより、チームの会話を離れることなく開発作業を委任できます。
 
-この統合は既存の Claude for Slack アプリに基づいていますが、コーディング関連のリクエストに対して Claude Code ウェブへのインテリジェントなルーティングを追加しています。
+この統合は既存の Claude for Slack アプリに基づいていますが、コーディング関連のリクエストに対して Claude Code ウェブへのインテリジェントなルーティングを追加しています。各セッションは自分の Claude アカウントで実行され、接続されたリポジトリと自分のプラン制限を使用します。
 
 <h2 id="use-cases">
@@ -218,4 +222,10 @@ Enterprise および Team アカウントの場合、Slack の Claude から作
 </h2>
 
+<h3 id="claude-code-is-not-enabled-for-your-account">
+  'Claude Code がアカウントで有効になっていません'
+</h3>
+
+このエラーは、Claude アカウントにまだクラウド環境がないことを意味します。管理者が何かを有効にする必要があるわけではありません。Slack に接続したのと同じアカウントで [claude.ai/code](https://claude.ai/code) に 1 回サインインしてください。初回訪問時にデフォルトのクラウド環境が作成され、次回のメンション時にエラーが解消されます。各ユーザーが個別に実行する必要があります。
+
 <h3 id="sessions-not-starting">
   セッションが開始しない
@@ -278,4 +288,8 @@ Enterprise および Team アカウントの場合、Slack の Claude から作
   </Card>
```

</details>

</details>


<details>
<summary>2026-06-23</summary>

**変更ファイル:**

```
 docs-ja/pages/agent-teams-ja.md            |  31 ++--
 docs-ja/pages/amazon-bedrock-ja.md         |   2 +
 docs-ja/pages/artifacts-en.md              | 226 -----------------------------
 docs-ja/pages/changelog.md                 |  36 +++++
 docs-ja/pages/chrome-ja.md                 |   2 +-
 docs-ja/pages/claude-code-on-the-web-ja.md |   8 +-
 docs-ja/pages/claude-platform-on-aws-ja.md |   4 +-
 docs-ja/pages/cli-reference-ja.md          |   5 +-
 docs-ja/pages/commands-ja.md               |   8 +-
 docs-ja/pages/env-vars-ja.md               |  25 +++-
 docs-ja/pages/errors-ja.md                 |  14 +-
 docs-ja/pages/features-overview-ja.md      |   1 +
 docs-ja/pages/fullscreen-ja.md             |   4 +-
 docs-ja/pages/glossary-ja.md               |   8 +
 docs-ja/pages/headless-ja.md               |   6 +-
 docs-ja/pages/interactive-mode-ja.md       |   4 +-
 docs-ja/pages/keybindings-ja.md            |  15 +-
 docs-ja/pages/managed-mcp-ja.md            |   9 +-
 docs-ja/pages/mcp-ja.md                    |  40 ++++-
 docs-ja/pages/mcp-quickstart-ja.md         |  15 +-
 docs-ja/pages/model-config-ja.md           |   2 +
 docs-ja/pages/monitoring-usage-ja.md       |  13 +-
 docs-ja/pages/network-config-ja.md         |  19 +--
 docs-ja/pages/permission-modes-ja.md       |   3 +
 docs-ja/pages/permissions-ja.md            |  12 +-
 docs-ja/pages/plugin-marketplaces-ja.md    |  22 ++-
 docs-ja/pages/prompt-library-ja.md         |   2 +-
 docs-ja/pages/remote-control-ja.md         |   9 +-
 docs-ja/pages/sandboxing-ja.md             |   2 +
 docs-ja/pages/settings-ja.md               |  73 +++++-----
 docs-ja/pages/skills-ja.md                 |  36 +++++
 docs-ja/pages/statusline-ja.md             |   2 +-
 docs-ja/pages/sub-agents-ja.md             |  29 ++--
 docs-ja/pages/tools-reference-ja.md        |   7 +-
 docs-ja/pages/ultrareview-ja.md            |  29 ++--
 docs-ja/pages/workflows-ja.md              |  23 +--
 docs-ja/pages/zero-data-retention-ja.md    |  11 +-
 37 files changed, 370 insertions(+), 387 deletions(-)
```

**新規追加:**


**削除:**


<details>
<summary>agent-teams-ja.md</summary>

```diff
diff --git a/docs-ja/pages/agent-teams-ja.md b/docs-ja/pages/agent-teams-ja.md
index 60edb30..1c4a354 100644
--- a/docs-ja/pages/agent-teams-ja.md
+++ b/docs-ja/pages/agent-teams-ja.md
@@ -91,5 +91,11 @@ one on UX, one on technical architecture, one playing devil's advocate.
 その後、Claude は [共有タスクリスト](/ja/interactive-mode#task-list) を作成し、各視点のチームメンバーを生成し、問題を探索させ、完了時に調査結果を統合します。
 
-リーダーのターミナルには、すべてのチームメンバーと彼らが取り組んでいる内容が表示されます。Shift+Down を使用してチームメンバーをサイクルして、直接メッセージを送信してください。最後のチームメンバーの後、Shift+Down はリーダーに戻ります。
+リーダーのターミナルには、プロンプト入力の下のエージェントパネルにチームメンバーが表示されます。パネルから以下の操作ができます。
+
+* **上下矢印**: チームメンバーを選択する
+* **Enter**: 選択したチームメンバーのトランスクリプトを開き、直接メッセージを送信する
+* **Escape**: 選択したチームメンバーの現在のターンを中断する
+
+{/* min-version: 2.1.181 */}v2.1.181 以降、アイドル状態のチームメンバーの行は 30 秒後に非表示になり、次のターンで再表示されます。チームメンバーは非表示中も実行中で対応可能な状態が続きます。
 
 各チームメンバーを独自の分割ペインに配置したい場合は、[表示モードを選択](#choose-a-display-mode)を参照してください。
@@ -107,5 +113,5 @@ one on UX, one on technical architecture, one playing devil's advocate.
 エージェントチームは 2 つの表示モードをサポートしています。
 
-* **In-process**：すべてのチームメンバーがメインターミナル内で実行されます。Shift+Down を使用してチームメンバーをサイクルして、直接メッセージを入力してください。追加のセットアップなしで任意のターミナルで動作します。
+* **In-process**：すべてのチームメンバーがメインターミナル内で実行されます。エージェントパネルで上下矢印キーを使用してチームメンバーを選択し、Enter キーを押してそれを表示して、直接メッセージを入力してください。追加のセットアップなしで任意のターミナルで動作します。
 * **分割ペイン**：各チームメンバーが独自のペインを取得します。すべてのユーザーの出力を一度に表示でき、ペインをクリックして直接対話できます。tmux または iTerm2 が必要です。
 
@@ -114,16 +120,20 @@ one on UX, one on technical architecture, one playing devil's advocate.
 </Note>
 
-デフォルトは `"auto"` で、既に tmux セッション内で実行している場合は分割ペインを使用し、そうでない場合は in-process を使用します。`"tmux"` 設定は分割ペインモードを有効にし、ターミナルに基づいて tmux または iTerm2 を使用するかどうかを自動検出します。オーバーライドするには、[`teammateMode`](/ja/settings#available-settings) を `~/.claude/settings.json` で設定してください。
+デフォルトは `"in-process"` です。v2.1.179 より前は、デフォルトは `"auto"` でした。そのため、以前に分割ペインを開いたアップグレードされたセッションは、モードを明示的に設定しない限り、1 つのターミナルに留まります。`"auto"` を設定して、既に tmux セッション内で実行している場合または使用しているターミナルが iTerm2 の場合は分割ペインを有効にし、それ以外の場合は in-process にフォールバックします。`"tmux"` 設定は分割ペインモードを有効にし、ターミナルに基づいて tmux または iTerm2 を使用するかどうかを自動検出します。
+
```

</details>

<details>
<summary>amazon-bedrock-ja.md</summary>

```diff
diff --git a/docs-ja/pages/amazon-bedrock-ja.md b/docs-ja/pages/amazon-bedrock-ja.md
index d49c6b9..8292c40 100644
--- a/docs-ja/pages/amazon-bedrock-ja.md
+++ b/docs-ja/pages/amazon-bedrock-ja.md
@@ -220,4 +220,6 @@ Claude Code は、AWS SSO および企業 ID プロバイダーの自動認証
 ```
 
+{/* min-version: 2.1.181 */}`aws configure export-credentials --format process` からのフラット出力も受け入れられます。`Credentials` の下にネストされるのではなく、同じキーがトップレベルにあります。
+
 `Expiration` はオプションです。{/* min-version: 2.1.176 */}Claude Code v2.1.176 以降では、コマンドが有効な ISO 8601 `Expiration` を返す場合、Claude Code はその時刻の 5 分前までの認証情報をキャッシュします。それがない場合、または以前のバージョンでは、認証情報は 1 時間キャッシュされます。
 
```

</details>

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index 40c2515..3c832a7 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,40 @@
 # Changelog
 
+## 2.1.186
+
+- Added `claude mcp login <name>` and `claude mcp logout <name>` to authenticate MCP servers from the CLI without opening the interactive `/mcp` menu, with `--no-browser` stdin redirect support for completing over SSH
+- Added status filtering (press `f`) to the `/workflows` agent detail view
+- Added a "Skills" section to the `/plugin` Installed tab
+- Added `teammateMode: "iterm2"` setting with a warning when auto mode cannot find the `it2` CLI
+- Added "Claude Platform on AWS - refresh credentials" option to `/login` when `awsAuthRefresh` is configured
+- `!` bash commands now trigger Claude to respond to the output automatically; set `"respondToBashCommands": false` in settings.json to keep the previous context-only behavior
+- Fixed streaming requests failing with "Content block not found" or JSON parse errors after the machine wakes from sleep
+- Fixed subagent transcript scroll position bleeding into the main transcript on exit
+- Fixed background task previews flashing raw tool names before the agent's plan loaded
+- Fixed Chrome tab-group isolation not applying when the in-product permissions gate is off for concurrent CLI sessions
+- Fixed background session recaps being duplicated; the agent's own end-of-turn summary now shows as the recap line
+- Fixed opening a background session from `claude agents` leaving the previous screen painted behind it
+- Fixed `Agent(type)` deny rules and `Agent(x,y)` allowed-types restrictions not being enforced for named subagent spawns
+- Fixed Esc and Ctrl+C not responding while background agents are still running after the main turn ends
+- Fixed misaligned option numbers in permission prompts when the option text overflows
+- Fixed pressing `x` on a finished subagent in the agent panel not dismissing it
+- Fixed a misleading "MCP server disconnected" notice for intentionally retired tools when resuming older sessions
+- Fixed `/plugin` Installed showing a "more above" indicator when already scrolled to the top
+- Fixed `~~strikethrough~~` showing literal tildes in assistant messages instead of rendering as strikethrough
+- Fixed `--tools` allowing feature-gated tools to slip through before flags loaded on a cold first launch
+- Fixed background job status in `claude agents` showing a stale "needs input" message after replying
```

</details>

<details>
<summary>chrome-ja.md</summary>

```diff
diff --git a/docs-ja/pages/chrome-ja.md b/docs-ja/pages/chrome-ja.md
index 2c75e91..09cbbce 100644
--- a/docs-ja/pages/chrome-ja.md
+++ b/docs-ja/pages/chrome-ja.md
@@ -199,5 +199,5 @@ Claude はインタラクションシーケンスを記録し、GIF ファイル
 </h3>
 
-Claude Code の setup-issues 行に `chrome` がリストされている場合：
+Claude Code が Chrome 拡張機能を検出できない場合：
 
 1. Chrome 拡張機能が `chrome://extensions` にインストールされ、有効になっていることを確認します
```

</details>

<details>
<summary>claude-code-on-the-web-ja.md</summary>

```diff
diff --git a/docs-ja/pages/claude-code-on-the-web-ja.md b/docs-ja/pages/claude-code-on-the-web-ja.md
index 0c40dbf..3058b3c 100644
--- a/docs-ja/pages/claude-code-on-the-web-ja.md
+++ b/docs-ja/pages/claude-code-on-the-web-ja.md
@@ -125,11 +125,13 @@ Team および Enterprise 管理者は [claude.ai/admin-settings/claude-code](ht
 </Steps>
 
-<h3 id="link-artifacts-back-to-the-session">
-  アーティファクトをセッションにリンク
+<h3 id="link-output-back-to-the-session">
+  セッションに出力をリンク
 </h3>
 
 各クラウドセッションは claude.ai 上にトランスクリプト URL を持ち、セッションは `CLAUDE_CODE_REMOTE_SESSION_ID` 環境変数から独自の ID を読み取ることができます。これを使用して、PR 本文、コミットメッセージ、Slack 投稿、または生成されたレポートに追跡可能なリンクを配置し、レビュアーがそれを生成した実行を開くことができます。
 
-変数の値は `cse_` プレフィックスを使用し、トランスクリプト URL パスは同じ ID を `session_` プレフィックスで使用します。リンクを構築するときにプレフィックスを置き換えてください。次のコマンドは URL を出力します：
+v2.1.179 以降、Claude がウェブセッションで作成するコミットには `Claude-Session: <url>` git トレーラーが含まれ、PR 本文にはセッション URL が独立した行に含まれます。{/* min-version: 2.1.182 */}v2.1.182 以降、[`attribution.sessionUrl`](/ja/settings#attribution-settings)を `false` に設定してトレーラーと PR 本文リンクを省略できます。
+
+コミットまたは PR 以外のもの（Claude が投稿する Slack メッセージやそれが書き込むレポートファイルなど）にセッションリンクを含めるには、Claude に次のコマンドを実行させ、その出力を使用してください。このコマンドは環境変数の値の `cse_` プレフィックスをトランスクリプト URL が期待する `session_` プレフィックスに変換します：
 
 ```bash theme={null}
```

</details>

<details>
<summary>claude-platform-on-aws-ja.md</summary>

```diff
diff --git a/docs-ja/pages/claude-platform-on-aws-ja.md b/docs-ja/pages/claude-platform-on-aws-ja.md
index 6b1d64d..262c879 100644
--- a/docs-ja/pages/claude-platform-on-aws-ja.md
+++ b/docs-ja/pages/claude-platform-on-aws-ja.md
@@ -239,4 +239,6 @@ SSO 認証情報がセッション中に期限切れになった場合、[`awsAu
 ```
 
+`awsAuthRefresh` が設定されている場合、`/login` は **Using 3rd-party platforms** の下に **Claude Platform on AWS · refresh credentials** オプションを表示します。これを選択すると、設定されたコマンドが実行され、Claude Code を再起動せずに AWS 認証情報が再度読み込まれます。
+
 **オプション B: ワークスペース API キー**
 
@@ -252,5 +254,5 @@ export ANTHROPIC_AWS_API_KEY=sk-ant-xxxxx
 
 <Note>
-  `/login` および `/logout` コマンドは AWS 上の Claude Platform 認証を変更しません。認証は AWS 認証情報またはワークスペース API キーを通じて実行され、Claude.ai サブスクリプションを通じてではありません。
+  `/login` および `/logout` コマンドは Claude.ai サブスクリプションに対してサインインしません。AWS 上の Claude Platform の場合、認証は AWS 認証情報またはワークスペース API キーを通じて実行されます。例外は、`awsAuthRefresh` が設定されている場合に `/login` が表示する **refresh credentials** オプションで、これは上記で説明したように AWS 認証情報を再度読み込みます。
 </Note>
 
```

</details>

<details>
<summary>cli-reference-ja.md</summary>

```diff
diff --git a/docs-ja/pages/cli-reference-ja.md b/docs-ja/pages/cli-reference-ja.md
index 0384265..a83f835 100644
--- a/docs-ja/pages/cli-reference-ja.md
+++ b/docs-ja/pages/cli-reference-ja.md
@@ -34,4 +34,6 @@
 | `claude logs <id>`              | [バックグラウンドセッション](/ja/agent-view#manage-sessions-from-the-shell) からの最近の出力を出力します                                                                                                                                                                                                                                                                                                                                                                                                             | `claude logs 7c5dcf5d`                                      |
 | `claude mcp`                    | Model Context Protocol（MCP）サーバーを設定                                                                                                                                                                                                                                                                                                                                                                                                                                                        | [Claude Code MCP ドキュメント](/ja/mcp) を参照してください。                |
+| `claude mcp login <name>`       | {/* min-version: 2.1.186 */}設定済み MCP サーバーの OAuth フローを実行します。インタラクティブな `/mcp` パネルを開きません。HTTP、SSE、および claude.ai コネクタサーバーで機能します。SSH 経由で `--no-browser` を追加して、ブラウザを開く代わりに認可 URL を出力し、リダイレクト URL をプロンプトに貼り付けます。Claude Code v2.1.186 以降が必要です。[コマンドラインから認証](/ja/mcp#authenticate-from-the-command-line) を参照してください                                                                                                                                                                                 | `claude mcp login sentry`                                   |
+| `claude mcp logout <name>`      | {/* min-version: 2.1.186 */}MCP サーバーの保存された OAuth 認証情報をクリアします。Claude Code v2.1.186 以降が必要です                                                                                                                                                                                                                                                                                                                                                                                                 | `claude mcp logout sentry`                                  |
 | `claude plugin`                 | Claude Code [plugins](/ja/plugins) を管理します。エイリアス：`claude plugins`。サブコマンドについては [plugin reference](/ja/plugins-reference#cli-commands-reference) を参照してください                                                                                                                                                                                                                                                                                                                                   | `claude plugin install code-review@claude-plugins-official` |
 | `claude project purge [path]`   | プロジェクトのすべてのローカル Claude Code 状態を削除します：トランスクリプト、タスクリスト、デバッグログ、ファイル編集履歴、プロンプト履歴行、および `~/.claude.json` 内のプロジェクトエントリ。`[path]` を省略して、インタラクティブリストから選択します。フラグ：`--dry-run` でプレビュー、`-y`/`--yes` で確認をスキップ、`-i`/`--interactive` で各項目を確認、`--all` ですべてのプロジェクト。[ローカルデータをクリア](/ja/claude-directory#clear-local-data) を参照してください                                                                                                                                                                            | `claude project purge ~/work/repo --dry-run`                |
@@ -61,4 +63,5 @@
 | `--append-system-prompt`                        | デフォルトシステムプロンプトの末尾にカスタムテキストを追加します                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              | `claude --append-system-prompt "Always use TypeScript"`                                             |
 | `--append-system-prompt-file`                   | ファイルから追加のシステムプロンプトテキストを読み込み、デフォルトプロンプトに追加します                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  | `claude --append-system-prompt-file ./extra-rules.txt`                                              |
+| `--ax-screen-reader`                            | {/* min-version: 2.1.181 */}スクリーンリーダーフレンドリーな出力をレンダリングします：装飾的なボーダーやアニメーションなしのフラットテキスト。クラシックレンダラーを強制するため、このセッションでは [`tui`](/ja/settings#available-settings) 設定は効果がありません。[`CLAUDE_AX_SCREEN_READER`](/ja/env-vars) と [`axScreenReader`](/ja/settings#available-settings) 設定より優先されます。Claude Code v2.1.181 以降が必要です                                                                                                                                                                                                                                                                 | `claude --ax-screen-reader`                                                                         |
 | `--bare`                                        | 最小限モード：hooks、skills、plugins、MCP サーバー、自動メモリ、CLAUDE.md の自動検出をスキップして、スクリプト化された呼び出しをより高速に開始します。Claude は Bash、ファイル読み取り、ファイル編集ツールにアクセスできます。[`CLAUDE_CODE_SIMPLE`](/ja/env-vars) を設定します。[bare mode](/ja/headless#start-faster-with-bare-mode) を参照してください                                                                                                                                                                                                                                                                                                                              | `claude --bare -p "query"`                                                                          |
 | `--betas`                                       | API リクエストに含めるベータヘッダー（API キーユーザーのみ）                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            | `claude --betas interleaved-thinking`                                                               |
@@ -115,5 +118,5 @@
 | `--system-prompt-file`                          | ファイルからシステムプロンプトを読み込み、デフォルトプロンプトを置き換えます                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        | `claude --system-prompt-file ./custom-prompt.txt`                                                   |
 | `--teleport`                                    | [Web セッション](/ja/claude-code-on-the-web) をローカルターミナルで再開します                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      | `claude --teleport`                                                                                 |
-| `--teammate-mode`                               | [エージェントチーム](/ja/agent-teams) のチームメイトの表示方法を設定します：`auto`（デフォルト）、`in-process`、または `tmux`。このセッションの [`teammateMode`](/ja/settings#available-settings) 設定をオーバーライドします。[ディスプレイモードを選択](/ja/agent-teams#choose-a-display-mode) を参照してください                                                                                                                                                                                                                                                                                                                                                | `claude --teammate-mode in-process`                                                                 |
+| `--teammate-mode`                               | [エージェントチーム](/ja/agent-teams) のチームメイトの表示方法を設定します：`in-process`（デフォルト）、`auto`、`tmux`、または {/* min-version: 2.1.186 */}`iterm2`（v2.1.186 で追加）。デフォルトは v2.1.179 で `auto` から変更されました。このセッションの [`teammateMode`](/ja/settings#available-settings) 設定をオーバーライドします。[ディスプレイモードを選択](/ja/agent-teams#choose-a-display-mode) を参照してください                                                                                                                                                                                                                                                          | `claude --teammate-mode auto`                                                                       |
 | `--tmux`                                        | worktree 用に tmux セッションを作成します。`--worktree` が必要です。利用可能な場合は iTerm2 ネイティブペインを使用します。従来の tmux の場合は `--tmux=classic` を渡します                                                                                                                                                                                                                                                                                                                                                                                                                                                           | `claude -w feature-auth --tmux`                                                                     |
 | `--tools`                                       | Claude が使用できる組み込みツールを制限します。`""` を使用してすべてを無効にし、`"default"` を使用してすべてを有効にするか、`"Bash,Edit,Read"` のようなツール名を使用します。MCP ツールは影響を受けません。それらも拒否するには、`--disallowedTools "mcp__*"` を使用するか、`--mcp-config` なしで `--strict-mcp-config` を渡して、MCP サーバーが読み込まれないようにします                                                                                                                                                                                                                                                                                                                              | `claude --tools "Bash,Edit,Read"`                                                                   |
```

</details>

<details>
<summary>commands-ja.md</summary>

```diff
diff --git a/docs-ja/pages/commands-ja.md b/docs-ja/pages/commands-ja.md
index affb61d..ff8fc31 100644
--- a/docs-ja/pages/commands-ja.md
+++ b/docs-ja/pages/commands-ja.md
@@ -25,5 +25,5 @@
 **並行して作業を実行する。** `/agents` は Claude が副次的なタスクを委譲できる[サブエージェント](/ja/sub-agents)のマネージャーを開き、`/tasks` は現在のセッションのバックグラウンドで実行されているものをリストします。`/background` はセッション全体をデタッチして[バックグラウンドエージェント](/ja/agent-view)として実行し続け、ターミナルを解放します。コードベース全体にまたがる大きな変更の場合、`/batch` はそれを独立したユニットに分解し、各ユニットを独自の[worktree](/ja/worktrees)で実行します。これらのアプローチがどのように関連しているかについては、[エージェントを並行して実行する](/ja/agents)を参照してください。
 
-**リリース前。** `/diff` は変更内容を表示し、`/code-review` は diff の正確性のバグをチェックし、`--fix` で検出結果を適用できます。`/review` または `/security-review` はより深い読み取り専用パスを提供します。`/code-review ultra` はクラウドでマルチエージェントレビューを実行します。
+**リリース前。** `/diff` は変更内容を表示し、`/code-review` は diff の正確性のバグをチェックし、`--fix` で検出結果を適用できます。`/review` は GitHub プルリクエストで同じ読み取り専用レビューを実行し、`/security-review` はより深い読み取り専用パスを提供します。`/code-review ultra` はクラウドでマルチエージェントレビューを実行します。
 
 **セッション間。** `/clear` は新しいタスクで新しく開始しながらプロジェクトメモリを保持します。`/resume` と `/branch` を使用して、以前の会話に戻るか、フォークできます。`/teleport` はウェブセッションをこのターミナルに引き込み、`/remote-control` を使用してこのローカルセッションを別のデバイスから続行できます。
@@ -62,8 +62,8 @@
 | `/claude-api [migrate\|managed-agents-onboard]`                                    | **[スキル](/ja/skills#bundled-skills)。** プロジェクトの言語（Python、TypeScript、Java、Go、Ruby、C#、PHP、または cURL）と Managed Agents リファレンス用の Claude API リファレンス資料を読み込みます。ツール使用、ストリーミング、バッチ、構造化出力、および一般的な落とし穴をカバーしています。また、コードが `anthropic` または `@anthropic-ai/sdk` をインポートするときに自動的にアクティブになります。`/claude-api migrate` を実行して、既存の Claude API コードを新しいモデルにアップグレードします。Claude はスキャンするファイルとターゲットモデルを尋ね、モデル ID、思考設定、およびバージョン間で変更されたその他のパラメータを更新します。`/claude-api managed-agents-onboard` を実行して、新しい Managed Agent をゼロから作成するインタラクティブなウォークスルーを実施します |
 | `/clear [name]`                                                                    | 空のコンテキストで新しい会話を開始します。前の会話は `/resume` で利用可能なままです。前の会話にラベルを付けるために名前を渡します。`/resume` ピッカーで。同じ会話を続けながらコンテキストを解放するには、代わりに `/compact` を使用してください。エイリアス: `/reset`、`/new`                                                                                                                                                                                                                                                                                                                                                |
-| `/code-review [low\|medium\|high\|xhigh\|max\|ultra] [--fix] [--comment] [target]` | **[スキル](/ja/skills#bundled-skills)。** 現在の diff を正確性バグについてレビューし、再利用、簡潔化、効率化のクリーンアップについてレビューします。`--fix` を渡して結果を作業ツリーに適用し、`--comment` を渡して GitHub PR にインラインコメントとして投稿し、`ultra` を渡してディープ[クラウドレビュー](/ja/ultrareview)を実行します。{/* min-version: 2.1.154 */}v2.1.154 以降、`/simplify` は別のクリーンアップのみのレビューを実行し、バグを探さずに修正を適用します。バグを見つけるには `/code-review` を使用してください。[diff をローカルでレビュー](/ja/code-review#review-a-diff-locally)を参照して、努力レベルとターゲット設定を確認してください                                                                         |
+| `/code-review [low\|medium\|high\|xhigh\|max\|ultra] [--fix] [--comment] [target]` | **[スキル](/ja/skills#bundled-skills)。** 現在の diff を正確性バグについてレビューし、再利用、簡潔化、効率化のクリーンアップについてレビューします。`--fix` を渡して結果を作業ツリーに適用し、`--comment` を渡して GitHub PR にインラインコメントとして投稿し、`ultra` を渡してディープ[クラウドレビュー](/ja/ultrareview)を実行します。{/* min-version: 2.1.154 */}v2.1.154 以降、`/simplify` は別のクリーンアップのみのレビューを実行し、バグを探さずに修正を適用します。[diff をローカルでレビュー](/ja/code-review#review-a-diff-locally)を参照して、努力レベルとターゲット設定を確認してください                                                                                                            |
 | `/color [color\|default]`                                                          | 現在のセッションのプロンプトバーの色を設定します。利用可能な色: `red`、`blue`、`green`、`yellow`、`purple`、`orange`、`pink`、`cyan`。`default` を使用してリセットするか、引数なしで実行するとランダムな色を選択します。[リモートコントロール](/ja/remote-control)が接続されている場合、色は claude.ai/code に同期されます                                                                                                                                                                                                                                                                                              |
 | `/compact [instructions]`                                                          | 会話をここまで要約してコンテキストを解放します。オプションで要約のフォーカス指示を渡します。[コンパクション時にルール、スキル、メモリファイルがどのように処理されるか](/ja/context-window#what-survives-compaction)を参照してください                                                                                                                                                                                                                                                                                                                                                                     |
-| `/config`                                                                          | [設定](/ja/settings)インターフェースを開いて、テーマ、モデル、[出力スタイル](/ja/output-styles)、およびその他の設定を調整します。エイリアス: `/settings`                                                                                                                                                                                                                                                                                                                                                                                                          |
+| `/config [key=value ...]`                                                          | [設定](/ja/settings)インターフェースを開いて、テーマ、モデル、[出力スタイル](/ja/output-styles)、およびその他の設定を調整します。{/* min-version: 2.1.181 */}v2.1.181 以降、1 つ以上の `key=value` ペアを渡して、インターフェースを開かずに設定を直接設定できます。例えば `/config thinking=false`。{/* min-version: 2.1.182 */}v2.1.182 以降、`/config theme=dark` や `/config model=sonnet` などの名前付きショートハンドキーも受け入れられます。`key=value` 形式は非対話モード（`-p`）と[リモートコントロール](/ja/remote-control)からも機能します。`/config --help` を実行して設定できるキーをリストします。エイリアス: `/settings`                                                        |
 | `/context [all]`                                                                   | 現在のコンテキスト使用状況をカラーグリッドとして視覚化します。コンテキストが多いツール、メモリ肥大化、容量警告の最適化提案を表示します。[フルスクリーンモード](/ja/fullscreen)では、項目ごとの内訳はグリッドを表示したままにするために折りたたまれます。`all` を渡して展開します                                                                                                                                                                                                                                                                                                                                                           |
 | `/copy [N]`                                                                        | 最後のアシスタント応答をクリップボードにコピーします。数字 `N` を渡して N 番目に新しい応答をコピーします。`/copy 2` は 2 番目に新しい応答をコピーします。コードブロックが存在する場合、個別ブロックまたは完全な応答を選択するインタラクティブピッカーを表示します。ピッカーで `w` を押して、クリップボードの代わりにファイルに選択内容を書き込みます。SSH 経由で便利です                                                                                                                                                                                                                                                                                                            |
@@ -115,5 +115,5 @@
 | `/rename [name]`                                                                   | 現在のセッションの名前を変更してプロンプトバーに名前を表示します。名前を指定しない場合、会話履歴から自動生成されます                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
 | `/resume [session]`                                                                | ID または名前で会話を再開するか、セッションピッカーを開きます。v2.1.144 以降、[バックグラウンドセッション](/ja/agent-view)はピッカーに `bg` とマークされて表示されます。エイリアス: `/continue`                                                                                                                                                                                                                                                                                                                                                                                       |
-| `/review [PR]`                                                                     | 現在のセッションでプルリクエストをローカルでレビューします。より深いクラウドベースのレビューについては、[`/code-review ultra`](/ja/ultrareview)を参照してください                                                                                                                                                                                                                                                                                                                                                                                                           |
+| `/review [PR]`                                                                     | GitHub プルリクエストを番号でレビューします。`/code-review` と同じレビューエンジンを使用します。引数なしで、選択するオープン PR をリストします。クラウドベースのレビューについては、[`/code-review ultra`](/ja/ultrareview)を参照してください                                                                                                                                                                                                                                                                                                                                                        |
 | `/rewind`                                                                          | 会話またはコードを前の時点に巻き戻すか、選択したメッセージから要約します。[チェックポイント](/ja/checkpointing)を参照してください。エイリアス: `/checkpoint`、`/undo`                                                                                                                                                                                                                                                                                                                                                                                                       |
 | `/run`                                                                             | **[スキル](/ja/skills#bundled-skills)。** プロジェクトのアプリを起動して実行し、テストだけでなく実行中のアプリで変更が機能しているのを確認します。[アプリを実行して検証](/ja/skills#run-and-verify-your-app)を参照してください。{/* min-version: 2.1.145 */}Claude Code v2.1.145 以降が必要です                                                                                                                                                                                                                                                                                                   |
```

</details>

*...以降省略*

</details>


<details>
<summary>2026-06-21</summary>

**変更ファイル:**

```
 docs-ja/pages/changelog.md | 4 ++++
 1 file changed, 4 insertions(+)
```

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index 2551042..40c2515 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,8 @@
 # Changelog
 
+## 2.1.185
+
+- The stream-stall hint now reads "Waiting for API response · will retry in …" instead of "No response from API · Retrying in …", and triggers after 20s of silence instead of 10s
+
 ## 2.1.183
 
```

</details>

</details>


<details>
<summary>2026-06-20</summary>

**変更ファイル:**

```
 docs-ja/pages/changelog.md | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)
```

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index b19e538..2551042 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,24 @@
 # Changelog
 
+## 2.1.183
+
+- Improved auto mode safety: destructive git commands (`git reset --hard`, `git checkout -- .`, `git clean -fd`, `git stash drop`) are now blocked when you didn't ask to discard local work, `git commit --amend` is blocked when the commit wasn't made by the agent this session, and `terraform destroy`/`pulumi destroy`/`cdk destroy` are blocked unless you asked for the specific stack
+- Added a warning when the requested model is deprecated or automatically updated to a newer model, shown on stderr in print mode (`-p`) and now also covering models set in agent frontmatter
+- Added `attribution.sessionUrl` setting to omit the claude.ai session link from commits and PRs in web and Remote Control sessions
+- Added `/config --help` to list all available shorthand keys for `/config key=value`
+- Changed `/config` toggle behavior: Enter and Space both change the selected setting, and Esc now saves and closes instead of reverting
+- Removed the startup "setup issues" line under the logo — run `/doctor` to see configuration issues or use `--debug`
+- Fixed `thinking.disabled.display: Extra inputs are not permitted` 400 errors on subagent spawns and session-title generation for affected configurations
+- Fixed WebSearch returning empty results in subagents
+- Fixed the terminal cursor being stranded above the prompt after navigating history in vim mode with the native cursor enabled
+- Fixed fullscreen TUI corruption (statusline mid-screen, duplicated spinner rows, merged text) in Windows Terminal under heavy nested-subagent load
+- Fixed turns silently completing with no visible output when the model returned only a thinking block; Claude now re-prompts once
+- Fixed user-level skills appearing multiple times in slash-command autocomplete when multiple plugins are enabled
+- Fixed MCP servers requiring authentication exposing auth-stub tools to the model in headless/SDK mode
+- Fixed tmux teammate panes failing to launch when the shell has slow rc-file initialization, and keystrokes typed during agent spawn leaking into the new tmux pane instead of the leader prompt
+- Fixed background tasks started by a teammate being killed when the teammate finishes a turn
+- Fixed scheduled task and webhook trigger deliveries being treated as keyboard input; they now classify as task notifications and can no longer approve a pending action or set the session title in auto mode
+- Fixed focus mode showing "Ran N PostToolUse hooks" timing lines under each response
+
 ## 2.1.181
 
```

</details>

</details>


<details>
<summary>2026-06-19</summary>

**変更ファイル:**

```
 docs-ja/pages/changelog.md | 1 +
 docs-ja/pages/memory-ja.md | 2 ++
 2 files changed, 3 insertions(+)
```

**新規追加:**


<!-- UPDATE_LOG_END -->
