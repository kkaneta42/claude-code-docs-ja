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
<summary>2026-06-18</summary>

**変更ファイル:**

```
 docs-ja/pages/admin-setup-ja.md              |  33 +-
 docs-ja/pages/advisor-en.md                  | 168 ---------
 docs-ja/pages/agent-teams-ja.md              | 226 +++++++----
 docs-ja/pages/agent-view-ja.md               |  45 ++-
 docs-ja/pages/agents-ja.md                   |  14 +-
 docs-ja/pages/amazon-bedrock-ja.md           | 144 +++++--
 docs-ja/pages/analytics-ja.md                |   2 +-
 docs-ja/pages/authentication-ja.md           |   2 +-
 docs-ja/pages/auto-mode-config-ja.md         |  22 +-
 docs-ja/pages/changelog.md                   |  42 +++
 docs-ja/pages/channels-reference-ja.md       |  18 +-
 docs-ja/pages/checkpointing-ja.md            |   4 +-
 docs-ja/pages/claude-code-on-the-web-ja.md   |  36 +-
 docs-ja/pages/claude-directory-ja.md         |  12 +-
 docs-ja/pages/claude-platform-on-aws-ja.md   |   9 +-
 docs-ja/pages/cli-reference-ja.md            | 196 +++++-----
 docs-ja/pages/code-review-ja.md              |  92 +++--
 docs-ja/pages/commands-ja.md                 |  37 +-
 docs-ja/pages/communications-kit-ja.md       |  22 +-
 docs-ja/pages/computer-use-ja.md             |  82 ++--
 docs-ja/pages/context-window-ja.md           |  34 +-
 docs-ja/pages/costs-ja.md                    |  10 +-
 docs-ja/pages/data-usage-ja.md               |   4 +-
 docs-ja/pages/debug-your-config-ja.md        |   8 +-
 docs-ja/pages/deep-links-ja.md               |   4 +-
 docs-ja/pages/desktop-ja.md                  | 106 +++---
 docs-ja/pages/desktop-quickstart-ja.md       |   6 +-
 docs-ja/pages/desktop-scheduled-tasks-ja.md  |   2 +-
 docs-ja/pages/devcontainer-ja.md             |   2 +-
 docs-ja/pages/discover-plugins-ja.md         | 134 +++++--
 docs-ja/pages/env-vars-ja.md                 | 535 ++++++++++++++-------------
 docs-ja/pages/errors-ja.md                   | 251 ++++++++++---
 docs-ja/pages/fast-mode-ja.md                |   4 +-
 docs-ja/pages/features-overview-ja.md        |   6 +-
 docs-ja/pages/fullscreen-ja.md               |  25 +-
 docs-ja/pages/github-actions-ja.md           | 172 ++++++---
 docs-ja/pages/github-enterprise-server-ja.md |   6 +-
 docs-ja/pages/gitlab-ci-cd-ja.md             | 114 ++++--
 docs-ja/pages/glossary-ja.md                 |  20 +-
 docs-ja/pages/google-vertex-ai-ja.md         |   4 +-
 docs-ja/pages/headless-ja.md                 |  18 +-
 docs-ja/pages/hooks-guide-ja.md              |  18 +-
 docs-ja/pages/hooks-ja.md                    | 104 ++++--
 docs-ja/pages/how-claude-code-works-ja.md    |  10 +-
 docs-ja/pages/interactive-mode-ja.md         |  11 +-
 docs-ja/pages/jetbrains-ja.md                | 100 +++--
 docs-ja/pages/keybindings-ja.md              |  40 +-
 docs-ja/pages/large-codebases-ja.md          |  20 +-
 docs-ja/pages/llm-gateway-ja.md              |   4 +-
 docs-ja/pages/managed-mcp-ja.md              |  18 +-
 docs-ja/pages/mcp-ja.md                      | 238 ++++++++----
 docs-ja/pages/memory-ja.md                   | 128 +++++--
 docs-ja/pages/microsoft-foundry-ja.md        |   4 +-
 docs-ja/pages/model-config-ja.md             | 186 ++++++++--
 docs-ja/pages/monitoring-usage-ja.md         | 105 ++++--
 docs-ja/pages/output-styles-ja.md            |   2 +
 docs-ja/pages/overview-ja.md                 |   4 +-
 docs-ja/pages/permission-modes-ja.md         |  30 +-
 docs-ja/pages/permissions-ja.md              |  92 ++++-
 docs-ja/pages/platforms-ja.md                |   2 +-
 docs-ja/pages/plugin-hints-ja.md             |  11 +-
 docs-ja/pages/plugin-marketplaces-ja.md      |  29 +-
 docs-ja/pages/plugins-ja.md                  |  10 +-
 docs-ja/pages/plugins-reference-ja.md        |  37 +-
 docs-ja/pages/prompt-caching-ja.md           |  17 +-
 docs-ja/pages/quickstart-ja.md               |  37 +-
 docs-ja/pages/remote-control-ja.md           | 113 ++++--
 docs-ja/pages/routines-ja.md                 |   2 +-
 docs-ja/pages/sandbox-environments-ja.md     |   8 +-
 docs-ja/pages/sandboxing-ja.md               |  25 +-
 docs-ja/pages/scheduled-tasks-ja.md          |   2 +-
 docs-ja/pages/security-ja.md                 |   8 +-
 docs-ja/pages/server-managed-settings-ja.md  |  16 +-
 docs-ja/pages/sessions-ja.md                 |  26 +-
 docs-ja/pages/settings-ja.md                 | 140 +++++--
 docs-ja/pages/setup-ja.md                    |  34 +-
 docs-ja/pages/skills-ja.md                   |  31 +-
 docs-ja/pages/slack-ja.md                    |  10 +-
 docs-ja/pages/statusline-ja.md               |  86 +++--
 docs-ja/pages/sub-agents-ja.md               |  78 ++--
 docs-ja/pages/third-party-integrations-ja.md |   2 +-
 docs-ja/pages/tools-reference-ja.md          |  37 +-
 docs-ja/pages/troubleshoot-install-ja.md     |  28 +-
 docs-ja/pages/troubleshooting-ja.md          |   7 +-
 docs-ja/pages/ultraplan-ja.md                |   2 +-
 docs-ja/pages/ultrareview-ja.md              |   4 +-
 docs-ja/pages/vs-code-ja.md                  | 206 ++++++++---
 docs-ja/pages/web-quickstart-ja.md           |   6 +-
 docs-ja/pages/workflows-ja.md                |  16 +-
 docs-ja/pages/worktrees-ja.md                |   6 +-
 docs-ja/pages/zero-data-retention-ja.md      |  24 +-
 91 files changed, 3151 insertions(+), 1694 deletions(-)
```

**新規追加:**


**削除:**


<details>
<summary>admin-setup-ja.md</summary>

```diff
diff --git a/docs-ja/pages/admin-setup-ja.md b/docs-ja/pages/admin-setup-ja.md
index ab983f9..a692aae 100644
--- a/docs-ja/pages/admin-setup-ja.md
+++ b/docs-ja/pages/admin-setup-ja.md
@@ -23,5 +23,7 @@ Claude Code は、ローカル開発者設定よりも優先されるマネー
 | [データ処理を確認する](#review-data-handling)                       | データ保持とコンプライアンス体制          | [Data usage](/ja/data-usage)、[Security](/ja/security)                                                                                 |
 
-## API プロバイダーを選択する
+<h2 id="choose-your-api-provider">
+  API プロバイダーを選択する
+</h2>
 
 Claude Code は複数の API プロバイダーのいずれかを通じて Claude に接続します。選択は課金、認証、継承するコンプライアンス体制、および開発者が使用できる Claude Code 機能に影響します。
@@ -41,7 +43,9 @@ Claude Code は複数の API プロバイダーのいずれかを通じて Claud
 [ネットワーク設定](/ja/network-config) のプロキシとファイアウォール要件は、プロバイダーに関係なく適用されます。複数のプロバイダーの前に単一のエンドポイントを配置したい場合、または集中化されたリクエストログを記録したい場合は、[LLM gateway](/ja/llm-gateway) を参照してください。
 
-## 設定がデバイスに到達する方法を決定する
+<h2 id="decide-how-settings-reach-devices">
+  設定がデバイスに到達する方法を決定する
+</h2>
 
-マネージド設定は、ローカル開発者設定よりも優先されるポリシーを定義します。Claude Code は 4 つの場所で設定を探し、特定のデバイスで最初に見つかったものを使用します。
+マネージド設定は、ローカル開発者設定よりも優先されるポリシーを定義します。Claude Code は以下の 4 つのソースを優先順位順にチェックし、空でない設定を返す最初のものを適用します。
 
 | メカニズム                   | 配信                                                                                                                                                                                                  | 優先度 | プラットフォーム      |
@@ -64,5 +68,7 @@ plist と HKLM レジストリの場所は任意のプロバイダーで機能
 [Server-managed settings](/ja/server-managed-settings) と [Settings files and precedence](/ja/settings#settings-files) を参照してください。
 
-## 実行する内容を決定する
+<h2 id="decide-what-to-enforce">
```

</details>

<details>
<summary>agent-teams-ja.md</summary>

```diff
diff --git a/docs-ja/pages/agent-teams-ja.md b/docs-ja/pages/agent-teams-ja.md
index 9e7818b..60edb30 100644
--- a/docs-ja/pages/agent-teams-ja.md
+++ b/docs-ja/pages/agent-teams-ja.md
@@ -8,5 +8,5 @@
 
 <Warning>
-  エージェントチームは実験的機能であり、デフォルトでは無効になっています。[settings.json](/ja/settings) または環境に `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS` を追加して有効にしてください。エージェントチームには、セッション再開、タスク調整、シャットダウン動作に関する[既知の制限](#limitations)があります。
+  エージェントチームは実験的機能であり、デフォルトでは無効になっています。[settings.json](/ja/settings) または環境に `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS` を追加して有効にしてください。その変数がない場合、セッション開始時にチームが設定されず、チームディレクトリが書き込まれず、Claude はチームメンバーをスポーンまたは提案しません。エージェントチームには、セッション再開、タスク調整、シャットダウン動作に関する[既知の制限](#limitations)があります。
 </Warning>
 
@@ -16,5 +16,5 @@
 
 <Note>
-  エージェントチームには Claude Code v2.1.32 以降が必要です。`claude --version` でバージョンを確認してください。
+  このページは v2.1.178 時点のエージェントチームについて説明しています。`CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS` が設定されている場合、チームメンバーのスポーンにはセットアップステップが不要になり、セッション終了時にクリーンアップが自動的に行われます。v2.1.178 より前は、最初にチームを作成して名前を付けるよう Claude に依頼し、Claude は `TeamCreate` と `TeamDelete` ツールを使用してセットアップと削除を行いました。両方のツールはもう存在しません。Agent ツールの `team_name` 入力は受け入れられますが無視され、`TaskCreated`、`TaskCompleted`、および `TeammateIdle` [hook ペイロード](/ja/hooks#taskcreated)の `team_name` フィールドはセッション派生名を含み、非推奨です。
 </Note>
 
@@ -26,5 +26,7 @@
 * [並列作業のベストプラクティス](#best-practices)
 
-## エージェントチームを使用する場合
+<h2 id="when-to-use-agent-teams">
+  エージェントチームを使用する場合
+</h2>
 
 エージェントチームは、並列探索が実際の価値を追加するタスクに最も効果的です。完全なシナリオについては、[ユースケース例](#use-case-examples)を参照してください。最も強力なユースケースは以下の通りです。
@@ -37,5 +39,7 @@
 エージェントチームは調整オーバーヘッドを追加し、単一セッションよりも大幅に多くのトークンを使用します。チームメンバーが独立して動作できる場合に最も効果的です。順序付きタスク、同じファイルの編集、または多くの依存関係を持つ作業の場合は、単一セッションまたは [subagents](/ja/sub-agents) がより効果的です。
 
```

</details>

<details>
<summary>agent-view-ja.md</summary>

```diff
diff --git a/docs-ja/pages/agent-view-ja.md b/docs-ja/pages/agent-view-ja.md
index c57f9c8..6333b01 100644
--- a/docs-ja/pages/agent-view-ja.md
+++ b/docs-ja/pages/agent-view-ja.md
@@ -144,4 +144,6 @@ Completed
 各行の 1 行の概要は [Haiku クラスモデル](/ja/model-config) によって生成されるため、行はトランスクリプトを開かずにセッションが何をしているか、何が必要か、または何を生成したかを伝えることができます。セッションがアクティブに作業している間、概要は最大 15 秒ごとに 1 回、および各ターンが終了したときに 1 回更新されます。
 
+v2.1.161 以降では、セッションが subagents、バックグラウンドシェルコマンド、またはモニターなど、2 つ以上の並列作業項目を実行している場合、`2/5` などの `done/total` カウントが概要テキストの前に表示されます。
+
 各更新は通常のプロバイダーを通じた 1 つの短い Haiku クラスリクエストであり、セッション自体と同じ [データ使用条件](/ja/data-usage) の下で請求および処理されます。Bedrock、Vertex AI、Microsoft Foundry、カスタムゲートウェイなどのサードパーティプロバイダーでは、Haiku モデルが設定されていない場合、リクエストはセッションのメインモデルにフォールバックします。これらのプロバイダーでこれらの概要のモデルを選択するには、[`ANTHROPIC_DEFAULT_HAIKU_MODEL`](/ja/model-config#environment-variables) を設定します。
 
@@ -171,7 +173,9 @@ Completed
 選択した行で `Space` を押してピークパネルを開きます。セッションが何を必要としているか、最新の出力、および開いたプルリクエストが表示されます。ほとんどの場合、これで十分であり、フルトランスクリプトを開く必要はありません。
 
+v2.1.161 以降では、セッションが並列作業項目を実行している場合、パネルは最も長く実行されているものとその実行時間を名前で表示するため、アタッチせずにセッションが何を待機しているかを確認できます。
+
 ピークパネルに返信を入力して `Enter` を押すと、そのセッションに送信されます。セッションが複数選択肢の質問をしている場合、ピークパネルはオプションを表示し、数字キーを押して 1 つを選択できます。他のブロックされたセッションの場合は、`Tab` を押して入力に提案された返信を入力し、送信前に編集できます。返信の前に `!` を付けて Bash コマンドを代わりに送信します。
 
-[音声ディクテーション](/ja/voice-dictation) が有効な場合、返信入力がフォーカスされている間、プッシュトゥトークキーを押したままにするか、タップして返信をディクテーションします。これはエージェントビューの下部のディスパッチ入力でも同じように機能します。
+v2.1.145 以降では、[音声ディクテーション](/ja/voice-dictation) が有効な場合、返信入力がフォーカスされている間、プッシュトゥトークキーを押したままにするか、タップして返信をディクテーションします。これはエージェントビューの下部のディスパッチ入力でも同じように機能します。
 
 `↑` と `↓` を使用してパネルを閉じずに隣接するセッションをピーク表示するか、`→` を使用してアタッチします。
@@ -225,4 +229,5 @@ Completed
 | `s:<state>`            | 指定された状態のセッション。例えば `s:working`。また `s:blocked` はあなたを待機しているすべてのセッションを受け入れます |
 | `#<number>` または PR URL | そのプルリクエストで作業しているセッション                                                    |
+| その他の URL               | 最初のプロンプトにその URL が含まれていたセッション                                             |
 
 <h3 id="keyboard-shortcuts">
@@ -478,17 +483,17 @@ claude agents --settings ./ci-settings.json --add-dir ../shared-lib
 すべてのバックグラウンドセッションには、シェルから使用できる短い ID があります。ID は `claude --bg` でセッションを開始するときに出力され、各セッションの ID は `~/.claude/jobs/` の下のディレクトリ名です。これらのコマンドはスクリプティングまたはエージェントビューを開きたくない場合に便利です。
```

</details>

<details>
<summary>agents-ja.md</summary>

```diff
diff --git a/docs-ja/pages/agents-ja.md b/docs-ja/pages/agents-ja.md
index 4d18871..cd96e4e 100644
--- a/docs-ja/pages/agents-ja.md
+++ b/docs-ja/pages/agents-ja.md
@@ -9,10 +9,10 @@
 [サブエージェント](/ja/sub-agents)、[エージェントビュー](/ja/agent-view)、[エージェントチーム](/ja/agent-teams)、および [動的ワークフロー](/ja/workflows) は、それぞれ異なる方法で作業を並列化します。どれを選ぶかは、各会話に自分で留まりたいのか、タスクを引き継いで後で確認したいのか、それとも Claude に一群のワーカーを調整させたいのかによって異なります。
 
-| アプローチ                        | 提供内容                                                                    | 使用する場合                                                                       |
-| :--------------------------- | :---------------------------------------------------------------------- | :--------------------------------------------------------------------------- |
-| [サブエージェント](/ja/sub-agents)   | 1 つのセッション内で委任されたワーカーが、独自のコンテキストでサイドタスクを実行し、サマリーを返す                      | サイドタスクが検索結果、ログ、またはファイルコンテンツで主な会話を埋め尽くす場合（再度参照しない）                            |
-| [エージェントビュー](/ja/agent-view)  | `claude agents` で開く、バックグラウンドで実行されているセッションをディスパッチして監視する 1 つの画面。リサーチプレビュー | 複数の独立したタスクがあり、それらを引き継いで、一目で状態を確認し、必要な場合のみ介入したい場合                             |
-| [エージェントチーム](/ja/agent-teams) | 共有タスクリストとエージェント間メッセージングを備えた複数の調整されたセッション。リーダーによって管理される。実験的で、デフォルトでは無効   | Claude にプロジェクトを分割させ、割り当てさせ、ワーカーを同期させたい場合                                     |
-| [動的ワークフロー](/ja/workflows)    | 多くのサブエージェントを実行し、その結果をチェックするスクリプト。1 回のターンで調整するには大きすぎるジョブ向け。リサーチプレビュー     | タスクが大きすぎてサブエージェント数個では対応できない場合。コードベース全体の監査、500 ファイルのマイグレーション、または敵対的検証が必要な調査など |
+| アプローチ                        | 提供内容                                                                    | 使用する場合                                                                      |
+| :--------------------------- | :---------------------------------------------------------------------- | :-------------------------------------------------------------------------- |
+| [サブエージェント](/ja/sub-agents)   | 1 つのセッション内で委任されたワーカーが、独自のコンテキストでサイドタスクを実行し、サマリーを返す                      | サイドタスクが検索結果、ログ、またはファイルコンテンツで主な会話を埋め尽くす場合（再度参照しない）                           |
+| [エージェントビュー](/ja/agent-view)  | `claude agents` で開く、バックグラウンドで実行されているセッションをディスパッチして監視する 1 つの画面。リサーチプレビュー | 複数の独立したタスクがあり、それらを引き継いで、一目で状態を確認し、必要な場合のみ介入したい場合                            |
+| [エージェントチーム](/ja/agent-teams) | 共有タスクリストとエージェント間メッセージングを備えた複数の調整されたセッション。リーダーによって管理される。実験的で、デフォルトでは無効   | Claude にプロジェクトを分割させ、割り当てさせ、ワーカーを同期させたい場合                                    |
+| [動的ワークフロー](/ja/workflows)    | 多くのサブエージェントを実行し、その結果をチェックするスクリプト。1 回のターンで調整するには大きすぎるジョブ向け               | タスクが大きすぎてサブエージェント数個では対応できない場合。コードベース全体の監査、500 ファイルのマイグレーション、または相互検証が必要な調査など |
 
 すべてのアプローチにおいて、ワーカーは Claude セッションです。別のツールを関与させるには、それを Claude に [MCP サーバー](/ja/mcp) として公開します。
@@ -64,5 +64,5 @@
 </h2>
 
-以下の各ガイドは、1 つのアプローチのセットアップと構成をカバーしています。
+各ガイド以下は、1 つのアプローチのセットアップと構成をカバーしています。
 
 * [カスタムサブエージェントを作成する](/ja/sub-agents)：再利用可能なスペシャリストを定義し、使用できるツールを制御します。
```

</details>

<details>
<summary>amazon-bedrock-ja.md</summary>

```diff
diff --git a/docs-ja/pages/amazon-bedrock-ja.md b/docs-ja/pages/amazon-bedrock-ja.md
index c411db1..d49c6b9 100644
--- a/docs-ja/pages/amazon-bedrock-ja.md
+++ b/docs-ja/pages/amazon-bedrock-ja.md
@@ -79,5 +79,7 @@ export const ContactSalesCard = ({surface}) => {
 <ContactSalesCard surface="bedrock" />
 
-## 前提条件
+<h2 id="prerequisites">
+  前提条件
+</h2>
 
 Claude Code を Bedrock で設定する前に、以下を確認してください。
@@ -88,7 +90,9 @@ Claude Code を Bedrock で設定する前に、以下を確認してくださ
 * 適切な IAM 権限
 
-Bedrock 認証情報を使用してサインインするには、以下の [Bedrock でサインイン](#bedrock-でサインイン)に従ってください。チーム全体に Claude Code をデプロイするには、[手動でセットアップ](#手動でセットアップ)の手順を使用し、ロールアウト前に[モデルバージョンをピン留め](#4-モデルバージョンをピン留め)してください。
+Bedrock 認証情報を使用してサインインするには、以下の [Bedrock でサインイン](#sign-in-with-bedrock)に従ってください。チーム全体に Claude Code をデプロイするには、[手動でセットアップ](#set-up-manually)の手順を使用し、ロールアウト前に[モデルバージョンをピン留め](#4-pin-model-versions)してください。
 
-## Bedrock でサインイン
+<h2 id="sign-in-with-bedrock">
+  Bedrock でサインイン
+</h2>
 
 AWS 認証情報を持っていて、Bedrock を通じて Claude Code の使用を開始したい場合、ログインウィザードがそれをガイドします。AWS 側の前提条件はアカウントごとに 1 回完了します。ウィザードは Claude Code 側を処理します。
@@ -96,5 +100,5 @@ AWS 認証情報を持っていて、Bedrock を通じて Claude Code の使用
 <Steps>
   <Step title="AWS アカウントで Anthropic モデルを有効にする">
-    [Amazon Bedrock コンソール](https://console.aws.amazon.com/bedrock/)で、モデルカタログを開き、Anthropic モデルを選択して、ユースケースフォームを送信します。送信直後にアクセスが付与されます。AWS Organizations については[ユースケースの詳細を送信](#1-ユースケースの詳細を送信)を、権限については [IAM 設定](#iam-設定)を参照してください。
+    [Amazon Bedrock コンソール](https://console.aws.amazon.com/bedrock/)で、モデルカタログを開き、Anthropic モデルを選択して、ユースケースフォームを送信します。送信直後にアクセスが付与されます。AWS Organizations については[ユースケースの詳細を送信](#1-submit-use-case-details)を、権限については [IAM 設定](#iam-configuration)を参照してください。
```

</details>

<details>
<summary>analytics-ja.md</summary>

```diff
diff --git a/docs-ja/pages/analytics-ja.md b/docs-ja/pages/analytics-ja.md
index 0d03426..741d0b1 100644
--- a/docs-ja/pages/analytics-ja.md
+++ b/docs-ja/pages/analytics-ja.md
@@ -150,5 +150,5 @@ PR は、Claude Code セッション中に記述された少なくとも 1 行
 </h4>
 
-プルリクエストがマージされるとき。
+プルリクエストがマージされるとき：
 
 1. 追加された行が PR diff から抽出されます
```

</details>

*...以降省略*

</details>


<details>
<summary>2026-06-17</summary>

**変更ファイル:**

```
 docs-ja/pages/advisor-en.md | 11 ++++++++---
 docs-ja/pages/changelog.md  | 13 +++++++++++++
 2 files changed, 21 insertions(+), 3 deletions(-)
```

<details>
<summary>advisor-en.md</summary>

```diff
diff --git a/docs-ja/pages/advisor-en.md b/docs-ja/pages/advisor-en.md
index 4ccf636..c4853ca 100644
--- a/docs-ja/pages/advisor-en.md
+++ b/docs-ja/pages/advisor-en.md
@@ -36,5 +36,5 @@ If any of these sets an advisor model, the advisor is enabled for sessions whose
 
 <Note>
-  To use Fable 5 as the advisor, you need Claude Code v2.1.170 or later and [Fable 5 access](/en/model-config#work-with-fable-5) for your organization. Fable does not appear in the picker that `/advisor` opens, so pass it directly as `/advisor fable`, `--advisor fable`, or `"advisorModel": "fable"`.
+  To use Fable 5 as the advisor, you need Claude Code v2.1.170 or later and [Fable 5 access](/en/model-config#work-with-fable-5) for your organization.
 </Note>
 
@@ -80,9 +80,14 @@ The advisor must be at least as capable as the main model. The accepted advisors
 | Fable 5 ({/* min-version: 2.1.170 */}v2.1.170+) | Fable                                            | An Opus or Sonnet advisor is rejected                 |
 
-Fable 5 requires Claude Code v2.1.170 or later and Fable 5 access, whether it acts as the main model or the advisor. The `fable` option does not appear in the `/advisor` picker.
+Fable 5 requires Claude Code v2.1.170 or later and Fable 5 access, whether it acts as the main model or the advisor.
 
 Set the advisor as `opus`, `sonnet`, or `fable`. These aliases resolve to the latest version of each model. You can also pass a full model ID such as `claude-opus-4-8`.
 
-The API enforces the pairing, not Claude Code. Setting a rejected pairing succeeds, then surfaces as a `cannot be used as an advisor when the request model is` error on the next request.
+Subagents inherit the configured advisor and apply the same pairing check against their own model.
+
+Claude Code validates the pairing before sending a request:
+
+* If the advisor is less capable than the main model, the advisor is not attached to the main model's requests. The `/advisor` command output and a notification show this. Subagents whose own model satisfies the pairing may still use the advisor.
+* If the main model or the advisor is a model Claude Code does not recognize, the advisor is not attached.
 
 ### Common model pairings
```

</details>

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index 30a4251..862d9f9 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,16 @@
 # Changelog
 
+## 2.1.179
+
+- Fixed mid-stream connection drops: partial responses are now preserved instead of showing a raw error, and the spinner no longer gets stuck at "running tool"
+- Fixed mouse-wheel scrolling in WSL2 under Windows Terminal and VS Code (regression in 2.1.172)
+- Fixed a sandbox `denyRead`/`allowRead` glob over a large directory tree making the Bash tool description enormous and the session unusable on Linux
+- Fixed the feedback survey capturing a single-digit reply as a session rating immediately after a turn completes
+- Fixed the welcome screen stacking multiple promotional banners — at most one promo now shows per session
+- Fixed Ctrl+O not showing the subagent's transcript when viewing a subagent
+- Fixed clicking the prompt input not returning focus from the subagent/footer panel
+- Fixed remote session background tasks appearing stuck as "still running" between turns
+- Improved plugin loading performance in remote sessions
+
 ## 2.1.178
 
@@ -20,4 +32,5 @@
 - Fixed model requests continuing to fail with auth errors after credentials were refreshed outside the session, due to a stale cached request configuration
 - Fixed background sessions created with `/bg` or `←←` after a turn finished showing "Working" forever in the agents list
+- Fixed Linux sandbox failing to start when `.claude/skills` or `.claude/hooks` is a symlink
 - Fixed `CLAUDE_CODE_PLUGIN_KEEP_MARKETPLACE_ON_FAILURE=1` preventing fresh marketplace installs from cloning
 - Fixed MCP server-level specs (`mcp__server`, `mcp__server__*`, `mcp__*`) in subagent `disallowedTools` being silently ignored
```

</details>

</details>


<details>
<summary>2026-06-16</summary>

**変更ファイル:**

```
 docs-ja/pages/authentication-ja.md        |  4 ----
 docs-ja/pages/changelog.md                | 25 +++++++++++++++++++++++++
 docs-ja/pages/data-usage-ja.md            |  2 +-
 docs-ja/pages/features-overview-ja.md     |  2 +-
 docs-ja/pages/headless-ja.md              |  4 ----
 docs-ja/pages/hooks-ja.md                 |  2 +-
 docs-ja/pages/how-claude-code-works-ja.md |  4 ++--
 docs-ja/pages/legal-and-compliance-ja.md  |  4 ----
 8 files changed, 30 insertions(+), 17 deletions(-)
```

<details>
<summary>authentication-ja.md</summary>

```diff
diff --git a/docs-ja/pages/authentication-ja.md b/docs-ja/pages/authentication-ja.md
index d916202..726dda9 100644
--- a/docs-ja/pages/authentication-ja.md
+++ b/docs-ja/pages/authentication-ja.md
@@ -160,8 +160,4 @@ Claude Code は認証情報を安全に管理します。
 </h3>
 
-<Note>
-  Starting June 15, 2026, Agent SDK and `claude -p` usage on subscription plans will draw from a new monthly Agent SDK credit, separate from your interactive usage limits. See [Use the Claude Agent SDK with your Claude plan](https://support.claude.com/en/articles/15036540-use-the-claude-agent-sdk-with-your-claude-plan) for details.
-</Note>
-
 CI パイプライン、スクリプト、または対話的なブラウザログインが利用できない他の環境の場合、`claude setup-token` で 1 年間の OAuth トークンを生成します。
 
```

</details>

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index 478b0ad..30a4251 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,29 @@
 # Changelog
 
+## 2.1.178
+
+- Added `Tool(param:value)` syntax for permission rules to match a tool's input parameters (with `*` wildcard), e.g. `Agent(model:opus)` to block Opus subagents
+- Skills in nested `.claude/skills` directories now load when working on files there; on a name clash, the nested skill appears as `<dir>:<name>` so both stay available
+- Nested `.claude/` directories: the agent, workflow, and output-style closest to the working directory now wins when names collide; project-scope workflow saves now target the closest existing `.claude/workflows/`
+- Improved auto mode: subagent spawns are now evaluated by the classifier before launch, closing a gap where a subagent could request a blocked action without review
+- Improved `/doctor` with consistent flat tree layout across all sections, clearer section status icons, and highlighted command names
+- Improved the skill listing truncation warning to show how many skill descriptions are affected
+- Changed the workflow prompt keyword to use a purple shimmer highlight and trigger only on explicit phrases like "run a workflow" or "workflow:", not on any mention of the word
+- Improved Remote Control error messages: connection failures now show a persistent red "/rc failed" indicator in the footer, and the "not yet enabled" error now explains whether it's a gate, a check failure, stale entitlement, or org policy
+- `/bug` now requires a description before submitting, and no longer uses model-refusal text as the GitHub issue title
+- Fixed a crash (out-of-memory) when the CLI inherits a stale websocket/OAuth file-descriptor environment variable from a parent process
+- Fixed Claude in Chrome silently failing to connect when the OAuth token belongs to a different account than the Claude Code login
+- Fixed nested `.claude/skills` skills with directory-qualified names being blocked by permission prompts in non-interactive runs
+- Fixed several subagent issues: viewing a subagent's transcript now shows tool results and live progress, messages sent while it finishes its turn are no longer dropped, and backgrounding a running subagent (ctrl+b) no longer restarts it from scratch
+- Fixed `claude agents` workers failing with `401 Invalid bearer token` when the daemon was started from a shell with a custom API gateway via `ANTHROPIC_BASE_URL` and `ANTHROPIC_AUTH_TOKEN`
+- Fixed compaction not honoring `--fallback-model`: compaction now falls back to the configured fallback model chain on overload or model-availability errors
+- Fixed model requests continuing to fail with auth errors after credentials were refreshed outside the session, due to a stale cached request configuration
+- Fixed background sessions created with `/bg` or `←←` after a turn finished showing "Working" forever in the agents list
+- Fixed `CLAUDE_CODE_PLUGIN_KEEP_MARKETPLACE_ON_FAILURE=1` preventing fresh marketplace installs from cloning
+- Fixed MCP server-level specs (`mcp__server`, `mcp__server__*`, `mcp__*`) in subagent `disallowedTools` being silently ignored
+- Fixed vim mode undo: `u` now steps through NORMAL/VISUAL-mode commands one at a time instead of merging commands in quick succession into a single undo step
+- Fixed statusline links with custom URI schemes (e.g. `vscode://`) not opening when clicked in `claude agents`
```

</details>

<details>
<summary>data-usage-ja.md</summary>

```diff
diff --git a/docs-ja/pages/data-usage-ja.md b/docs-ja/pages/data-usage-ja.md
index 9f2487c..b3f1205 100644
--- a/docs-ja/pages/data-usage-ja.md
+++ b/docs-ja/pages/data-usage-ja.md
@@ -84,5 +84,5 @@ Web 上の個別の Claude Code セッションはいつでも削除できます
 以下の図は、インストール中および通常の操作中に Claude Code が外部サービスにどのように接続するかを示しています。実線は必須の接続を示し、破線はオプションまたはユーザーが開始したデータフローを表します。
 
-<img src="https://mintcdn.com/claude-code/RcOyXc06Ja8cuvMZ/images/claude-code-data-flow.svg?fit=max&auto=format&n=RcOyXc06Ja8cuvMZ&q=85&s=b5be40abf333defe984993af89546c19" alt="Claude Code の外部接続を示す図：インストール/更新は配布サーバーに接続し、ユーザーリクエストは Console 認証、public-api、およびオプションでメトリクス、Sentry、バグレポートを含む Anthropic サービスに接続します" width="720" height="520" data-path="images/claude-code-data-flow.svg" />
+<img src="https://mintcdn.com/claude-code/ikqp3_70mqIahteV/images/claude-code-data-flow.svg?fit=max&auto=format&n=ikqp3_70mqIahteV&q=85&s=5b1131530bdfdd415700a0cb4d4070c4" alt="Claude Code の外部接続を示す図：インストール/更新は配布サーバーに接続し、ユーザーリクエストは Console 認証、public-api、およびオプションでメトリクス、Sentry、バグレポートを含む Anthropic サービスに接続します" width="720" height="520" data-path="images/claude-code-data-flow.svg" />
 
 Claude Code はローカルで実行されます。LLM と対話するために、Claude Code はネットワーク経由でデータを送信します。このデータには、すべてのユーザープロンプトとモデル出力が含まれます。データは TLS 1.2 以上で転送中に暗号化されます。Claude Code はほとんどの一般的な VPN および LLM プロキシと互換性があります。
```

</details>

<details>
<summary>features-overview-ja.md</summary>

```diff
diff --git a/docs-ja/pages/features-overview-ja.md b/docs-ja/pages/features-overview-ja.md
index afa3d37..e59ac8f 100644
--- a/docs-ja/pages/features-overview-ja.md
+++ b/docs-ja/pages/features-overview-ja.md
@@ -248,5 +248,5 @@ Claude Code は、コードについて推論するモデルと、ファイル
 各機能はセッション内の異なるポイントでロードされます。以下のタブは、各機能がいつロードされるか、およびコンテキストに何が入るかを説明しています。
 
-<img src="https://mintcdn.com/claude-code/6yTCYq1p37ZB8-CQ/images/context-loading.svg?fit=max&auto=format&n=6yTCYq1p37ZB8-CQ&q=85&s=5a58ce953a35a2412892015e2ad6cb67" alt="コンテキストロード：CLAUDE.md はセッション開始時にロードされ、すべてのリクエストに留まります。MCP ツール名は開始時にロードされ、完全なスキーマは使用時に遅延されます。スキルは開始時に説明をロードし、呼び出し時に完全なコンテンツをロードします。Subagents は独立したコンテキストを取得します。Hooks は外部で実行されます。" width="720" height="410" data-path="images/context-loading.svg" />
+<img src="https://mintcdn.com/claude-code/ikqp3_70mqIahteV/images/context-loading.svg?fit=max&auto=format&n=ikqp3_70mqIahteV&q=85&s=aab139e750494a237ae2e0c8f9139b0a" alt="コンテキストロード：CLAUDE.md はセッション開始時にロードされ、すべてのリクエストに留まります。MCP ツール名は開始時にロードされ、完全なスキーマは使用時に遅延されます。スキルは開始時に説明をロードし、呼び出し時に完全なコンテンツをロードします。Subagents は独立したコンテキストを取得します。Hooks は外部で実行されます。" width="720" height="382" data-path="images/context-loading.svg" />
 
 <Tabs>
```

</details>

<details>
<summary>headless-ja.md</summary>

```diff
diff --git a/docs-ja/pages/headless-ja.md b/docs-ja/pages/headless-ja.md
index ec6dbed..5e2d4e1 100644
--- a/docs-ja/pages/headless-ja.md
+++ b/docs-ja/pages/headless-ja.md
@@ -7,8 +7,4 @@
 > Agent SDK を使用して、CLI、Python、または TypeScript からプログラムで Claude Code を実行します。
 
-<Note>
-  Starting June 15, 2026, Agent SDK and `claude -p` usage on subscription plans will draw from a new monthly Agent SDK credit, separate from your interactive usage limits. See [Use the Claude Agent SDK with your Claude plan](https://support.claude.com/en/articles/15036540-use-the-claude-agent-sdk-with-your-claude-plan) for details.
-</Note>
-
 [Agent SDK](/ja/agent-sdk/overview) は、Claude Code を支える同じツール、エージェントループ、およびコンテキスト管理を提供します。スクリプトと CI/CD 用の CLI として、または完全なプログラムによる制御のための [Python](/ja/agent-sdk/python) および [TypeScript](/ja/agent-sdk/typescript) パッケージとして利用できます。
 
```

</details>

<details>
<summary>hooks-ja.md</summary>

```diff
diff --git a/docs-ja/pages/hooks-ja.md b/docs-ja/pages/hooks-ja.md
index 26e7444..3f99680 100644
--- a/docs-ja/pages/hooks-ja.md
+++ b/docs-ja/pages/hooks-ja.md
@@ -109,5 +109,5 @@ fi
 
 <Frame>
-  <img src="https://mintcdn.com/claude-code/-tYw1BD_DEqfyyOZ/images/hook-resolution.svg?fit=max&auto=format&n=-tYw1BD_DEqfyyOZ&q=85&s=c73ebc1eeda2037570427d7af1e0a891" alt="フック解決フロー：PreToolUse イベントが発火し、マッチャーが Bash マッチをチェックし、if 条件が Bash(rm *) マッチをチェックし、フック ハンドラーが実行され、結果が Claude Code に返される" width="930" height="290" data-path="images/hook-resolution.svg" />
+  <img src="https://mintcdn.com/claude-code/ikqp3_70mqIahteV/images/hook-resolution.svg?fit=max&auto=format&n=ikqp3_70mqIahteV&q=85&s=be0bf3053550c26de5f54cd64674c197" alt="フック解決フロー：PreToolUse イベントが発火し、マッチャーが Bash マッチをチェックし、if 条件が Bash(rm *) マッチをチェックし、フック ハンドラーが実行され、結果が Claude Code に返される" width="930" height="270" data-path="images/hook-resolution.svg" />
 </Frame>
 
```

</details>

<details>
<summary>how-claude-code-works-ja.md</summary>

```diff
diff --git a/docs-ja/pages/how-claude-code-works-ja.md b/docs-ja/pages/how-claude-code-works-ja.md
index 4f8ec8e..02352f8 100644
--- a/docs-ja/pages/how-claude-code-works-ja.md
+++ b/docs-ja/pages/how-claude-code-works-ja.md
@@ -17,5 +17,5 @@ Claude Code はターミナルで実行される agentic アシスタントで
 Claude にタスクを与えると、3 つのフェーズを通じて作業します。**コンテキストの収集**、**アクションの実行**、**結果の検証** です。これらのフェーズは相互に融合します。Claude はツールを使用して、コードを理解するためのファイル検索、変更を加えるための編集、作業を確認するためのテスト実行など、様々な場面で活用します。
 
-<img src="https://mintcdn.com/claude-code/c5r9_6tjPMzFdDDT/images/agentic-loop.svg?fit=max&auto=format&n=c5r9_6tjPMzFdDDT&q=85&s=5f1827dec8539f38adee90ead3a85a38" alt="agentic ループ：プロンプトから Claude がコンテキストを収集し、アクションを実行し、結果を検証し、タスク完了まで繰り返します。任意の時点で中断できます。" width="720" height="280" data-path="images/agentic-loop.svg" />
+<img src="https://mintcdn.com/claude-code/ikqp3_70mqIahteV/images/agentic-loop.svg?fit=max&auto=format&n=ikqp3_70mqIahteV&q=85&s=4a30fb7ce2815012a9f27c955e2c6bb0" alt="agentic ループ：プロンプトから Claude がコンテキストを収集し、アクションを実行し、結果を検証し、タスク完了まで繰り返します。任意の時点で中断できます。" width="720" height="280" data-path="images/agentic-loop.svg" />
 
 ループは、あなたが何を求めるかに応じて適応します。コードベースに関する質問は、コンテキスト収集だけで済むかもしれません。バグ修正は 3 つのフェーズすべてを繰り返し循環します。リファクタリングは広範な検証を伴うかもしれません。Claude は前のステップから学んだことに基づいて各ステップが何を必要とするかを判断し、数十のアクションを連鎖させ、途中で軌道修正します。
@@ -131,5 +131,5 @@ Claude は現在のブランチのファイルを見ます。ブランチを切
 `claude --continue` または `claude --resume` でセッションを再開すると、同じセッション ID を使用して中断したところから再開し、新しいメッセージを既存の会話に追加します。`--fork-session` または `/branch` でフォークすると、履歴を新しいセッション ID にコピーし、元のセッションは変更されません。
 
-<img src="https://mintcdn.com/claude-code/c5r9_6tjPMzFdDDT/images/session-continuity.svg?fit=max&auto=format&n=c5r9_6tjPMzFdDDT&q=85&s=fa41d12bfb57579cabfeece907151d30" alt="セッション継続性：再開は同じセッションを続行し、フォークは新しい ID で新しいブランチを作成します。" width="560" height="280" data-path="images/session-continuity.svg" />
+<img src="https://mintcdn.com/claude-code/ikqp3_70mqIahteV/images/session-continuity.svg?fit=max&auto=format&n=ikqp3_70mqIahteV&q=85&s=04ed0984a58e4127e05b3640265241a3" alt="セッション継続性：再開は同じセッションを続行し、フォークは新しい ID で新しいブランチを作成します。" width="560" height="280" data-path="images/session-continuity.svg" />
 
 再開フラグ、`/resume` ピッカー、命名、同じセッションが 2 つのターミナルで開いている場合の動作については、[セッションを管理する](/ja/sessions) を参照してください。
```

</details>

<details>
<summary>legal-and-compliance-ja.md</summary>

```diff
diff --git a/docs-ja/pages/legal-and-compliance-ja.md b/docs-ja/pages/legal-and-compliance-ja.md
index 95ca6ae..2402304 100644
--- a/docs-ja/pages/legal-and-compliance-ja.md
+++ b/docs-ja/pages/legal-and-compliance-ja.md
@@ -7,8 +7,4 @@
 > Claude Code の法的契約、規制認証、およびセキュリティ情報。
 
-<Note>
-  Starting June 15, 2026, Agent SDK and `claude -p` usage on subscription plans will draw from a new monthly Agent SDK credit, separate from your interactive usage limits. See [Use the Claude Agent SDK with your Claude plan](https://support.claude.com/en/articles/15036540-use-the-claude-agent-sdk-with-your-claude-plan) for details.
-</Note>
-
 <h2 id="legal-agreements">
   法的契約
```

</details>

</details>


<details>
<summary>2026-06-13</summary>

**変更ファイル:**

```
 docs-ja/pages/changelog.md | 45 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 45 insertions(+)
```

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index 3aa61b1..478b0ad 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,49 @@
 # Changelog
 
+## 2.1.176
+
+- Session titles are now generated in the language of your conversation (set the `language` setting to pin a specific language)
+- Added `footerLinksRegexes` setting for regex-matched link badges in the footer row, configurable via user or managed settings
+- Improved Bedrock credential caching: credentials from `awsCredentialExport` are now cached until their `Expiration` instead of a fixed 1 hour
+- Fixed `availableModels` enforcement: alias model picks can no longer be redirected to a blocked model via `ANTHROPIC_DEFAULT_*_MODEL` environment variables, and `/fast` now refuses to toggle when it would switch to a model outside the allowlist
+- Fixed auto mode failing on Fable 5 for organizations without Opus 4.8 enabled — the classifier now falls back to the best available Opus model
+- Fixed hook `if` conditions for Read/Edit/Write tool paths: documented patterns like `Edit(src/**)`, `Read(~/.ssh/**)`, and `Read(.env)` now match correctly
+- Fixed Linux sandbox failing to start when `.claude/settings.json` is a symlink with an absolute target
+- Fixed `/copy` and mouse-selection copy not reaching the system clipboard inside tmux over SSH, and tmux paste buffer not loading on versions older than 3.2
+- Fixed Remote Control connecting from web/mobile silently switching the session's model
+- Fixed Remote Control disconnect notifications showing a bare numeric code instead of a human-readable reason, and connection failures adding a duplicate line to the conversation transcript
+- Fixed Remote Control sessions not disconnecting when you sign in to a different account
+- Fixed `/cd` and worktree moves leaving the session reporting the previous directory's git branch
+- Fixed `claude agents`: pressing back in one window no longer detaches other windows attached to the same session
+- Fixed backgrounded sessions showing "Working" forever when `/bg` mid-turn had nothing left to continue
+- Fixed background agent search by PR URL: PRs opened during scheduled wakeups or while a job was blocked now appear in `claude agents` search
+- Fixed the agents view input showing no text cursor on Windows
+- Fixed `claude --bg -cn <name>` not seeding the session name
+- Fixed background sessions to neutralize Windows network paths in persisted state before respawn
+- Fixed background-session respawn rejecting malformed resume IDs from corrupted state files
+- Fixed the Windows background-service daemon not starting when `~/.claude/daemon` has the ReadOnly attribute set
+- Fixed cloud sessions failing with "Could not resolve authentication method" when idle for too long before being claimed
```

</details>

</details>


<details>
<summary>2026-06-12</summary>

**変更ファイル:**

```
 docs-ja/pages/amazon-bedrock-ja.md           |   72 ++
 docs-ja/pages/changelog.md                   |    5 +
 docs-ja/pages/claude-directory-ja.md         | 1426 +++++++++++++++++++++++
 docs-ja/pages/claude-platform-on-aws-ja.md   |  182 +++
 docs-ja/pages/context-window-ja.md           | 1564 ++++++++++++++++++++++++++
 docs-ja/pages/google-vertex-ai-ja.md         |   72 ++
 docs-ja/pages/microsoft-foundry-ja.md        |   72 ++
 docs-ja/pages/prompt-library-ja.md           | 1319 ++++++++++++++++++++++
 docs-ja/pages/third-party-integrations-ja.md |   72 ++
 9 files changed, 4784 insertions(+)
```

<details>
<summary>amazon-bedrock-ja.md</summary>

```diff
diff --git a/docs-ja/pages/amazon-bedrock-ja.md b/docs-ja/pages/amazon-bedrock-ja.md
index 6eac9dc..c411db1 100644
--- a/docs-ja/pages/amazon-bedrock-ja.md
+++ b/docs-ja/pages/amazon-bedrock-ja.md
@@ -7,4 +7,76 @@
 > Amazon Bedrock を通じた Claude Code の設定方法（セットアップ、IAM 設定、トラブルシューティングを含む）について学習します。
 
+export const ContactSalesCard = ({surface}) => {
+  const utm = content => `utm_source=claude_code&utm_medium=docs&utm_content=${surface}_${content}`;
+  const iconArrowRight = (size = 13) => <svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">
+      <line x1="5" y1="12" x2="19" y2="12" />
+      <polyline points="12 5 19 12 12 19" />
+    </svg>;
+  const STYLES = `
+.cc-cs {
+  --cs-slate: #141413;
+  --cs-clay: #d97757;
+  --cs-clay-deep: #c6613f;
+  --cs-gray-000: #ffffff;
+  --cs-gray-700: #3d3d3a;
+  --cs-border-default: rgba(31, 30, 29, 0.15);
+  font-family: inherit;
+}
+.dark .cc-cs {
+  --cs-slate: #f0eee6;
+  --cs-gray-000: #262624;
+  --cs-gray-700: #bfbdb4;
+  --cs-border-default: rgba(240, 238, 230, 0.14);
+}
+.cc-cs-card {
```

</details>

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index f1d4f8d..3aa61b1 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,9 @@
 # Changelog
 
+## 2.1.173
+
+- Fixed Fable 5 model names with a `[1m]` suffix not being normalized — Fable 5 includes 1M context by default, so the suffix is now stripped automatically
+- Fixed a spurious "sandbox dependencies missing" startup warning on Windows when sandbox was enabled in settings
+
 ## 2.1.172
 
```

</details>

<details>
<summary>claude-directory-ja.md</summary>

```diff
diff --git a/docs-ja/pages/claude-directory-ja.md b/docs-ja/pages/claude-directory-ja.md
index 0ab4439..467b49d 100644
--- a/docs-ja/pages/claude-directory-ja.md
+++ b/docs-ja/pages/claude-directory-ja.md
@@ -7,4 +7,1428 @@
 > Claude Code が CLAUDE.md、settings.json、hooks、skills、commands、subagents、workflows、rules、auto memory を読み込む場所。プロジェクト内の .claude ディレクトリとホームディレクトリの ~/.claude を探索します。
 
+export const ClaudeExplorer = () => {
+  const A = useMemo(() => ({href, children}) => <a href={href} style={{
+    color: 'var(--ce-accent)',
+    textDecoration: 'none',
+    borderBottom: '1px dotted var(--ce-accent)'
+  }}>{children}</a>, []);
+  const C = useMemo(() => ({children}) => <code style={{
+    fontFamily: 'var(--ce-mono)',
+    fontSize: '0.92em',
+    padding: '1px 4px',
+    borderRadius: '3px',
+    background: 'var(--ce-surface)',
+    border: '0.5px solid var(--ce-border-subtle)'
+  }}>{children}</code>, []);
+  const commandsNote = useMemo(() => <>Commands and skills are now the same mechanism. For new workflows, use <A href="/en/skills">skills/</A> instead: same <C>/name</C> invocation, plus you can bundle supporting files.</>, []);
+  const FILE_TREE = useMemo(() => ({
+    project: {
+      label: 'your-project/',
+      children: [{
+        id: 'claude-md',
+        label: 'CLAUDE.md',
+        type: 'file',
+        icon: 'md',
```

</details>

<details>
<summary>claude-platform-on-aws-ja.md</summary>

```diff
diff --git a/docs-ja/pages/claude-platform-on-aws-ja.md b/docs-ja/pages/claude-platform-on-aws-ja.md
index ada8273..1c2ff61 100644
--- a/docs-ja/pages/claude-platform-on-aws-ja.md
+++ b/docs-ja/pages/claude-platform-on-aws-ja.md
@@ -7,4 +7,186 @@
 > AWS 認証、IAM アクセス制御、AWS Marketplace 請求を使用して、Anthropic が運営する Claude API を使用するように Claude Code を設定します。
 
+export const ContactSalesCard = ({surface}) => {
+  const utm = content => `utm_source=claude_code&utm_medium=docs&utm_content=${surface}_${content}`;
+  const iconArrowRight = (size = 13) => <svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">
+      <line x1="5" y1="12" x2="19" y2="12" />
+      <polyline points="12 5 19 12 12 19" />
+    </svg>;
+  const STYLES = `
+.cc-cs {
+  --cs-slate: #141413;
+  --cs-clay: #d97757;
+  --cs-clay-deep: #c6613f;
+  --cs-gray-000: #ffffff;
+  --cs-gray-700: #3d3d3a;
+  --cs-border-default: rgba(31, 30, 29, 0.15);
+  font-family: inherit;
+}
+.dark .cc-cs {
+  --cs-slate: #f0eee6;
+  --cs-gray-000: #262624;
+  --cs-gray-700: #bfbdb4;
+  --cs-border-default: rgba(240, 238, 230, 0.14);
+}
+.cc-cs-card {
```

</details>

<details>
<summary>context-window-ja.md</summary>

```diff
diff --git a/docs-ja/pages/context-window-ja.md b/docs-ja/pages/context-window-ja.md
index 17cb163..04ca98c 100644
--- a/docs-ja/pages/context-window-ja.md
+++ b/docs-ja/pages/context-window-ja.md
@@ -7,6 +7,1570 @@
 > Claude Code のコンテキストウィンドウがセッション中にどのように満たされるかのインタラクティブなシミュレーション。自動的に読み込まれるもの、各ファイル読み込みのコスト、ルールとフックが発火するタイミングを確認できます。
 
+export const ContextWindow = () => {
+  const MAX = 200000;
+  const STARTUP_END = 0.2;
+  {}
+  const EVENTS = useMemo(() => [{}, {
+    t: 0.015,
+    kind: 'auto',
+    label: 'System prompt',
+    tokens: 4200,
+    color: '#6B6964',
+    vis: 'hidden',
+    desc: 'Core instructions for behavior, tool use, and response formatting. Always loaded first. You never see it.',
+    link: null
+  }, {
+    t: 0.035,
+    kind: 'auto',
+    label: 'Auto memory (MEMORY.md)',
+    tokens: 680,
+    color: '#E8A45C',
+    vis: 'hidden',
+    desc: "Claude's notes to itself from previous sessions: build commands it learned, patterns it noticed, mistakes to avoid. The first 200 lines or 25KB, whichever comes first, are loaded into the conversation context.",
+    link: '/en/memory#auto-memory'
+  }, {
```

</details>

<details>
<summary>google-vertex-ai-ja.md</summary>

```diff
diff --git a/docs-ja/pages/google-vertex-ai-ja.md b/docs-ja/pages/google-vertex-ai-ja.md
index 2575a95..608eab8 100644
--- a/docs-ja/pages/google-vertex-ai-ja.md
+++ b/docs-ja/pages/google-vertex-ai-ja.md
@@ -7,4 +7,76 @@
 > Google Vertex AI を通じた Claude Code の設定方法について学びます。セットアップ、IAM 設定、トラブルシューティングを含みます。
 
+export const ContactSalesCard = ({surface}) => {
+  const utm = content => `utm_source=claude_code&utm_medium=docs&utm_content=${surface}_${content}`;
+  const iconArrowRight = (size = 13) => <svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">
+      <line x1="5" y1="12" x2="19" y2="12" />
+      <polyline points="12 5 19 12 12 19" />
+    </svg>;
+  const STYLES = `
+.cc-cs {
+  --cs-slate: #141413;
+  --cs-clay: #d97757;
+  --cs-clay-deep: #c6613f;
+  --cs-gray-000: #ffffff;
+  --cs-gray-700: #3d3d3a;
+  --cs-border-default: rgba(31, 30, 29, 0.15);
+  font-family: inherit;
+}
+.dark .cc-cs {
+  --cs-slate: #f0eee6;
+  --cs-gray-000: #262624;
+  --cs-gray-700: #bfbdb4;
+  --cs-border-default: rgba(240, 238, 230, 0.14);
+}
+.cc-cs-card {
```

</details>

*...以降省略*

</details>


<details>
<summary>2026-06-11</summary>

**変更ファイル:**

```
 docs-ja/pages/amazon-bedrock-ja.md           |   72 --
 docs-ja/pages/changelog.md                   |   33 +
 docs-ja/pages/claude-directory-ja.md         | 1426 -----------------------
 docs-ja/pages/claude-platform-on-aws-ja.md   |  182 ---
 docs-ja/pages/context-window-ja.md           | 1564 --------------------------
 docs-ja/pages/google-vertex-ai-ja.md         |   72 --
 docs-ja/pages/microsoft-foundry-ja.md        |   72 --
 docs-ja/pages/prompt-library-ja.md           | 1319 ----------------------
 docs-ja/pages/third-party-integrations-ja.md |   72 --
 9 files changed, 33 insertions(+), 4779 deletions(-)
```

<details>
<summary>amazon-bedrock-ja.md</summary>

```diff
diff --git a/docs-ja/pages/amazon-bedrock-ja.md b/docs-ja/pages/amazon-bedrock-ja.md
index c411db1..6eac9dc 100644
--- a/docs-ja/pages/amazon-bedrock-ja.md
+++ b/docs-ja/pages/amazon-bedrock-ja.md
@@ -7,76 +7,4 @@
 > Amazon Bedrock を通じた Claude Code の設定方法（セットアップ、IAM 設定、トラブルシューティングを含む）について学習します。
 
-export const ContactSalesCard = ({surface}) => {
-  const utm = content => `utm_source=claude_code&utm_medium=docs&utm_content=${surface}_${content}`;
-  const iconArrowRight = (size = 13) => <svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">
-      <line x1="5" y1="12" x2="19" y2="12" />
-      <polyline points="12 5 19 12 12 19" />
-    </svg>;
-  const STYLES = `
-.cc-cs {
-  --cs-slate: #141413;
-  --cs-clay: #d97757;
-  --cs-clay-deep: #c6613f;
-  --cs-gray-000: #ffffff;
-  --cs-gray-700: #3d3d3a;
-  --cs-border-default: rgba(31, 30, 29, 0.15);
-  font-family: inherit;
-}
-.dark .cc-cs {
-  --cs-slate: #f0eee6;
-  --cs-gray-000: #262624;
-  --cs-gray-700: #bfbdb4;
-  --cs-border-default: rgba(240, 238, 230, 0.14);
-}
-.cc-cs-card {
```

</details>

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index 5b4fcd8..f1d4f8d 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,37 @@
 # Changelog
 
+## 2.1.172
+
+- Sub-agents can now spawn their own sub-agents (up to 5 levels deep)
+- Amazon Bedrock now reads the AWS region from `~/.aws` config files when `AWS_REGION` isn't set, matching AWS SDK precedence; `/status` shows where the region came from
+- Added a search bar when browsing a marketplace's plugins in `/plugin`
+- Added `model` attribute to the `claude_code.lines_of_code.count` OTEL metric
+- Fixed sessions using 1M context without usage credits getting permanently stuck — the session now automatically compacts back under the standard context limit
+- Fixed a repeating "an image in the conversation could not be processed and was removed" error when the conversation contained multiple images
+- Fixed the agents view keeping a session under Working with a busy spinner for up to 30 seconds after the worker replied
+- Fixed background agents potentially reading another directory's project settings (`.mcp.json` approvals, trust) when dispatched onto a pre-warmed worker
+- Fixed background-session attach failing with EAUTH for sessions started on an older version after the daemon auto-updated
+- Fixed a background sub-agent staying stuck as "active" in the agent panel after a nested agent it spawned was stopped
+- Fixed `/model` suggestions in the `claude agents` dispatch input rendering with a misleading slash prefix and showing models disabled for your org
+- Fixed `availableModels` restrictions not being applied to subagent model overrides, the agent dispatch model picker, and the advisor model
+- Fixed `availableModels` allowlists hiding the `/model` picker's Opus and Sonnet 1M rows when entries use version-specific IDs like `claude-opus-4-8`
+- Fixed the `/model` picker on Bedrock offering models the provider doesn't serve — selecting one silently switched the session model and lit the selection marker on multiple rows
+- Fixed model IDs getting a doubled 1M-context suffix (e.g. `[1M][1m]`) when `ANTHROPIC_DEFAULT_OPUS_MODEL` already includes one
+- Fixed `opusplan` model setting not shipping with 1M context in plan mode for entitled users; the `opusplan[1m]` workaround now also correctly switches to Opus in plan mode
+- Fixed `WebFetch(domain:*.example.com)` wildcard domain rules never matching subdomains in allow, deny, and ask position, and file permission rules with mid-pattern wildcards (e.g. `Read(secrets-*/config.json)`) being rejected at startup
+- Fixed up-arrow prompt history showing the main agent's prompts while a subagent's chat tab is open
+- Fixed memory recall not finding mounted team memory stores (`CLAUDE_MEMORY_STORES`) in remote sessions
+- Fixed workflow validation rejecting scripts whose prompt strings or comments merely mention `Date.now()`/`Math.random()`
+- Disable mouse tracking on Windows consoles that don't fully support it
```

</details>

<details>
<summary>claude-directory-ja.md</summary>

```diff
diff --git a/docs-ja/pages/claude-directory-ja.md b/docs-ja/pages/claude-directory-ja.md
index 467b49d..0ab4439 100644
--- a/docs-ja/pages/claude-directory-ja.md
+++ b/docs-ja/pages/claude-directory-ja.md
@@ -7,1428 +7,4 @@
 > Claude Code が CLAUDE.md、settings.json、hooks、skills、commands、subagents、workflows、rules、auto memory を読み込む場所。プロジェクト内の .claude ディレクトリとホームディレクトリの ~/.claude を探索します。
 
-export const ClaudeExplorer = () => {
-  const A = useMemo(() => ({href, children}) => <a href={href} style={{
-    color: 'var(--ce-accent)',
-    textDecoration: 'none',
-    borderBottom: '1px dotted var(--ce-accent)'
-  }}>{children}</a>, []);
-  const C = useMemo(() => ({children}) => <code style={{
-    fontFamily: 'var(--ce-mono)',
-    fontSize: '0.92em',
-    padding: '1px 4px',
-    borderRadius: '3px',
-    background: 'var(--ce-surface)',
-    border: '0.5px solid var(--ce-border-subtle)'
-  }}>{children}</code>, []);
-  const commandsNote = useMemo(() => <>Commands and skills are now the same mechanism. For new workflows, use <A href="/en/skills">skills/</A> instead: same <C>/name</C> invocation, plus you can bundle supporting files.</>, []);
-  const FILE_TREE = useMemo(() => ({
-    project: {
-      label: 'your-project/',
-      children: [{
-        id: 'claude-md',
-        label: 'CLAUDE.md',
-        type: 'file',
-        icon: 'md',
```

</details>

<details>
<summary>claude-platform-on-aws-ja.md</summary>

```diff
diff --git a/docs-ja/pages/claude-platform-on-aws-ja.md b/docs-ja/pages/claude-platform-on-aws-ja.md
index 1c2ff61..ada8273 100644
--- a/docs-ja/pages/claude-platform-on-aws-ja.md
+++ b/docs-ja/pages/claude-platform-on-aws-ja.md
@@ -7,186 +7,4 @@
 > AWS 認証、IAM アクセス制御、AWS Marketplace 請求を使用して、Anthropic が運営する Claude API を使用するように Claude Code を設定します。
 
-export const ContactSalesCard = ({surface}) => {
-  const utm = content => `utm_source=claude_code&utm_medium=docs&utm_content=${surface}_${content}`;
-  const iconArrowRight = (size = 13) => <svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">
-      <line x1="5" y1="12" x2="19" y2="12" />
-      <polyline points="12 5 19 12 12 19" />
-    </svg>;
-  const STYLES = `
-.cc-cs {
-  --cs-slate: #141413;
-  --cs-clay: #d97757;
-  --cs-clay-deep: #c6613f;
-  --cs-gray-000: #ffffff;
-  --cs-gray-700: #3d3d3a;
-  --cs-border-default: rgba(31, 30, 29, 0.15);
-  font-family: inherit;
-}
-.dark .cc-cs {
-  --cs-slate: #f0eee6;
-  --cs-gray-000: #262624;
-  --cs-gray-700: #bfbdb4;
-  --cs-border-default: rgba(240, 238, 230, 0.14);
-}
-.cc-cs-card {
```

</details>

<details>
<summary>context-window-ja.md</summary>

```diff
diff --git a/docs-ja/pages/context-window-ja.md b/docs-ja/pages/context-window-ja.md
index 04ca98c..17cb163 100644
--- a/docs-ja/pages/context-window-ja.md
+++ b/docs-ja/pages/context-window-ja.md
@@ -7,1570 +7,6 @@
 > Claude Code のコンテキストウィンドウがセッション中にどのように満たされるかのインタラクティブなシミュレーション。自動的に読み込まれるもの、各ファイル読み込みのコスト、ルールとフックが発火するタイミングを確認できます。
 
-export const ContextWindow = () => {
-  const MAX = 200000;
-  const STARTUP_END = 0.2;
-  {}
-  const EVENTS = useMemo(() => [{}, {
-    t: 0.015,
-    kind: 'auto',
-    label: 'System prompt',
-    tokens: 4200,
-    color: '#6B6964',
-    vis: 'hidden',
-    desc: 'Core instructions for behavior, tool use, and response formatting. Always loaded first. You never see it.',
-    link: null
-  }, {
-    t: 0.035,
-    kind: 'auto',
-    label: 'Auto memory (MEMORY.md)',
-    tokens: 680,
-    color: '#E8A45C',
-    vis: 'hidden',
-    desc: "Claude's notes to itself from previous sessions: build commands it learned, patterns it noticed, mistakes to avoid. The first 200 lines or 25KB, whichever comes first, are loaded into the conversation context.",
-    link: '/en/memory#auto-memory'
-  }, {
```

</details>

<details>
<summary>google-vertex-ai-ja.md</summary>

```diff
diff --git a/docs-ja/pages/google-vertex-ai-ja.md b/docs-ja/pages/google-vertex-ai-ja.md
index 608eab8..2575a95 100644
--- a/docs-ja/pages/google-vertex-ai-ja.md
+++ b/docs-ja/pages/google-vertex-ai-ja.md
@@ -7,76 +7,4 @@
 > Google Vertex AI を通じた Claude Code の設定方法について学びます。セットアップ、IAM 設定、トラブルシューティングを含みます。
 
-export const ContactSalesCard = ({surface}) => {
-  const utm = content => `utm_source=claude_code&utm_medium=docs&utm_content=${surface}_${content}`;
-  const iconArrowRight = (size = 13) => <svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">
-      <line x1="5" y1="12" x2="19" y2="12" />
-      <polyline points="12 5 19 12 12 19" />
-    </svg>;
-  const STYLES = `
-.cc-cs {
-  --cs-slate: #141413;
-  --cs-clay: #d97757;
-  --cs-clay-deep: #c6613f;
-  --cs-gray-000: #ffffff;
-  --cs-gray-700: #3d3d3a;
-  --cs-border-default: rgba(31, 30, 29, 0.15);
-  font-family: inherit;
-}
-.dark .cc-cs {
-  --cs-slate: #f0eee6;
-  --cs-gray-000: #262624;
-  --cs-gray-700: #bfbdb4;
-  --cs-border-default: rgba(240, 238, 230, 0.14);
-}
-.cc-cs-card {
```

</details>

*...以降省略*

</details>


<details>
<summary>2026-06-10</summary>

**変更ファイル:**

```
 docs-ja/pages/agent-view-ja.md               | 148 +++++--
 docs-ja/pages/agents-ja.md                   |  12 +-
 docs-ja/pages/analytics-ja.md                |  88 +++--
 docs-ja/pages/authentication-ja.md           |  32 +-
 docs-ja/pages/auto-mode-config-ja.md         |  24 +-
 docs-ja/pages/best-practices-ja.md           | 124 ++++--
 docs-ja/pages/champion-kit-ja.md             |  64 ++-
 docs-ja/pages/changelog.md                   |   6 +
 docs-ja/pages/channels-ja.md                 |  36 +-
 docs-ja/pages/channels-reference-ja.md       |  60 ++-
 docs-ja/pages/checkpointing-ja.md            |  40 +-
 docs-ja/pages/chrome-ja.md                   |  80 +++-
 docs-ja/pages/claude-code-on-the-web-ja.md   | 172 ++++++--
 docs-ja/pages/claude-directory-ja.md         |  44 ++-
 docs-ja/pages/claude-platform-on-aws-ja.md   |  48 ++-
 docs-ja/pages/cli-reference-ja.md            |  16 +-
 docs-ja/pages/common-workflows-ja.md         |  84 +++-
 docs-ja/pages/communications-kit-ja.md       |  72 +++-
 docs-ja/pages/costs-ja.md                    |  76 +++-
 docs-ja/pages/data-usage-ja.md               |  48 ++-
 docs-ja/pages/debug-your-config-ja.md        |  28 +-
 docs-ja/pages/deep-links-ja.md               |  60 ++-
 docs-ja/pages/desktop-ja.md                  | 268 +++++++++----
 docs-ja/pages/desktop-quickstart-ja.md       |  20 +-
 docs-ja/pages/desktop-scheduled-tasks-ja.md  |  32 +-
 docs-ja/pages/devcontainer-ja.md             |  28 +-
 docs-ja/pages/env-vars-ja.md                 |  24 +-
 docs-ja/pages/fast-mode-ja.md                |  40 +-
 docs-ja/pages/features-overview-ja.md        |  40 +-
 docs-ja/pages/fullscreen-ja.md               |  48 ++-
 docs-ja/pages/github-enterprise-server-ja.md |  64 ++-
 docs-ja/pages/glossary-ja.md                 | 236 ++++++++---
 docs-ja/pages/goal-ja.md                     |  44 ++-
 docs-ja/pages/google-vertex-ai-ja.md         |  60 ++-
 docs-ja/pages/headless-ja.md                 |  48 ++-
 docs-ja/pages/hooks-guide-ja.md              | 124 ++++--
 docs-ja/pages/hooks-ja.md                    | 564 ++++++++++++++++++++-------
 docs-ja/pages/how-claude-code-works-ja.md    | 100 +++--
 docs-ja/pages/interactive-mode-ja.md         | 104 +++--
 docs-ja/pages/keybindings-ja.md              | 144 +++++--
 docs-ja/pages/large-codebases-ja.md          |  80 +++-
 docs-ja/pages/legal-and-compliance-ja.md     |  44 ++-
 docs-ja/pages/llm-gateway-ja.md              |  64 ++-
 docs-ja/pages/managed-mcp-ja.md              |  60 ++-
 docs-ja/pages/mcp-quickstart-ja.md           |  56 ++-
 docs-ja/pages/microsoft-foundry-ja.md        |  40 +-
 docs-ja/pages/model-config-ja.md             | 100 +++--
 docs-ja/pages/monitoring-usage-ja.md         | 280 +++++++++----
 docs-ja/pages/network-config-ja.md           |  32 +-
 docs-ja/pages/output-styles-ja.md            |  28 +-
 docs-ja/pages/overview-ja.md                 |  16 +-
 docs-ja/pages/permission-modes-ja.md         |  60 ++-
 docs-ja/pages/permissions-ja.md              | 104 +++--
 docs-ja/pages/platforms-ja.md                |  28 +-
 docs-ja/pages/plugin-dependencies-ja.md      |  36 +-
 docs-ja/pages/plugin-hints-ja.md             |  32 +-
 docs-ja/pages/plugin-marketplaces-ja.md      | 196 +++++++---
 docs-ja/pages/plugins-ja.md                  |  88 +++--
 docs-ja/pages/plugins-reference-ja.md        | 208 +++++++---
 docs-ja/pages/prompt-caching-ja.md           | 112 ++++--
 docs-ja/pages/prompt-library-ja.md           |  12 +-
 docs-ja/pages/quickstart-ja.md               |  52 ++-
 docs-ja/pages/routines-ja.md                 | 100 +++--
 docs-ja/pages/sandbox-environments-ja.md     |  44 ++-
 docs-ja/pages/sandboxing-ja.md               |  84 +++-
 docs-ja/pages/scheduled-tasks-ja.md          |  60 ++-
 docs-ja/pages/security-guidance-ja.md        |  72 +++-
 docs-ja/pages/security-ja.md                 |  68 +++-
 docs-ja/pages/server-managed-settings-ja.md  |  64 ++-
 docs-ja/pages/sessions-ja.md                 |  32 +-
 docs-ja/pages/settings-ja.md                 | 136 +++++--
 docs-ja/pages/setup-ja.md                    | 108 +++--
 docs-ja/pages/skills-ja.md                   | 124 ++++--
 docs-ja/pages/slack-ja.md                    | 108 +++--
 docs-ja/pages/sub-agents-ja.md               | 176 ++++++---
 docs-ja/pages/terminal-config-ja.md          |  72 +++-
 docs-ja/pages/third-party-integrations-ja.md |  52 ++-
 docs-ja/pages/tools-reference-ja.md          |  76 +++-
 docs-ja/pages/troubleshoot-install-ja.md     | 144 +++++--
 docs-ja/pages/troubleshooting-ja.md          |  32 +-
 docs-ja/pages/ultraplan-ja.md                |  24 +-
 docs-ja/pages/ultrareview-ja.md              |  24 +-
 docs-ja/pages/voice-dictation-ja.md          |  36 +-
 docs-ja/pages/web-quickstart-ja.md           |  68 +++-
 docs-ja/pages/workflows-ja.md                |  68 +++-
 docs-ja/pages/worktrees-ja.md                |  32 +-
 docs-ja/pages/zero-data-retention-ja.md      |  24 +-
 87 files changed, 5181 insertions(+), 1725 deletions(-)
```

**新規追加:**


<details>
<summary>agent-view-ja.md</summary>

```diff
diff --git a/docs-ja/pages/agent-view-ja.md b/docs-ja/pages/agent-view-ja.md
index 0e8451a..c57f9c8 100644
--- a/docs-ja/pages/agent-view-ja.md
+++ b/docs-ja/pages/agent-view-ja.md
@@ -31,5 +31,7 @@ Claude が複数の独立したタスクに対して、あなたが毎ステッ
 * [バックグラウンドセッションがどのようにホストされるか](#how-background-sessions-are-hosted)。スーパーバイザープロセスによって
 
-## クイックスタート
+<h2 id="quick-start">
+  クイックスタート
+</h2>
 
 このチュートリアルでは、コアエージェントビューループについて説明します。タスクをディスパッチし、Claude が作業する際に行が更新されるのを見守り、ピークして確認して返信し、フル会話にアタッチします。ディスパッチしたセッションはエージェントビューを閉じた後も実行し続けるため、離れて後で戻ることができます。
@@ -69,5 +71,7 @@ Claude が複数の独立したタスクに対して、あなたが毎ステッ
 `claude agents` を `claude` の代わりにプライマリエントリーポイントとして使用できます。エージェントビューからすべてのタスクをディスパッチし、フル会話が必要な場合はアタッチし、`←` を押してテーブルに戻ります。
 
-## エージェントビューでセッションを監視する
+<h2 id="monitor-sessions-with-agent-view">
+  エージェントビューでセッションを監視する
+</h2>
 
 `claude agents` を実行してエージェントビューを開きます。ターミナル全体を占有し、状態でグループ化されたすべてのセッションをリストします。ピン留めされたセッションと入力が必要なセッションが上部に表示されます。各行はセッションの名前、現在のアクティビティ、最後に変更されてからの経過時間を表示します。
@@ -103,5 +107,7 @@ Completed
 ```
 
-### セッション状態を読む
+<h3 id="read-session-state">
+  セッション状態を読む
+</h3>
 
```

</details>

<details>
<summary>agents-ja.md</summary>

```diff
diff --git a/docs-ja/pages/agents-ja.md b/docs-ja/pages/agents-ja.md
index 5984b05..4d18871 100644
--- a/docs-ja/pages/agents-ja.md
+++ b/docs-ja/pages/agents-ja.md
@@ -33,5 +33,7 @@
 </Note>
 
-## アプローチを選択する
+<h2 id="choose-an-approach">
+  アプローチを選択する
+</h2>
 
 適切なアプローチは、誰が作業を調整するか、ワーカーが通信する必要があるかどうか、および同じファイルを編集するかどうかによって異なります。
@@ -45,5 +47,7 @@
 * **タスクが同じファイルに触れるか？** [ワークツリー](/ja/worktrees)で作業を分離します。サブエージェントと自分で実行するセッションは、それぞれ個別のワークツリーを使用できます。エージェントチームはチームメイトをワークツリーで分離しないため、[作業を分割](/ja/agent-teams#avoid-file-conflicts)して、各チームメイトが異なるファイルセットを所有するようにします。
 
-## 実行中の作業を確認する
+<h2 id="check-on-running-work">
+  実行中の作業を確認する
+</h2>
 
 実行中の作業を確認するコマンドは、使用したアプローチによって異なります。
@@ -56,5 +60,7 @@
 すべてのセッションのデスクトップビューについては、[デスクトップアプリでのセッションの並列実行](/ja/desktop#work-in-parallel-with-sessions) を参照してください。
 
-## 詳細情報
+<h2 id="learn-more">
+  詳細情報
+</h2>
 
```

</details>

<details>
<summary>analytics-ja.md</summary>

```diff
diff --git a/docs-ja/pages/analytics-ja.md b/docs-ja/pages/analytics-ja.md
index 4c7149d..0d03426 100644
--- a/docs-ja/pages/analytics-ja.md
+++ b/docs-ja/pages/analytics-ja.md
@@ -14,5 +14,7 @@ Claude Code は、組織が開発者の使用パターンを理解し、貢献
 | API（Claude Console）           | [platform.claude.com/claude-code](https://platform.claude.com/claude-code) | 使用メトリクス、支出追跡、チームインサイト                         | [詳細](#access-analytics-for-api-customers)       |
 
-## Team と Enterprise の分析にアクセスする
+<h2 id="access-analytics-for-team-and-enterprise">
+  Team と Enterprise の分析にアクセスする
+</h2>
 
 [claude.ai/analytics/claude-code](https://claude.ai/analytics/claude-code) に移動してください。管理者とオーナーがダッシュボードを表示できます。
@@ -27,5 +29,7 @@ Team と Enterprise ダッシュボードには以下が含まれます。
 ユーザーごとのトークン数とコスト推定については、[OpenTelemetry エクスポート](/ja/monitoring-usage)を構成してください。
 
-### 貢献メトリクスを有効にする
+<h3 id="enable-contribution-metrics">
+  貢献メトリクスを有効にする
+</h3>
 
 <Note>
@@ -66,5 +70,7 @@ Team と Enterprise ダッシュボードには以下が含まれます。
 貢献メトリクスは GitHub Cloud と GitHub Enterprise Server をサポートしています。
 
-### サマリーメトリクスを確認する
+<h3 id="review-summary-metrics">
+  サマリーメトリクスを確認する
+</h3>
 
```

</details>

<details>
<summary>authentication-ja.md</summary>

```diff
diff --git a/docs-ja/pages/authentication-ja.md b/docs-ja/pages/authentication-ja.md
index e8c9bd5..d916202 100644
--- a/docs-ja/pages/authentication-ja.md
+++ b/docs-ja/pages/authentication-ja.md
@@ -9,5 +9,7 @@
 Claude Code は、セットアップに応じて複数の認証方法をサポートしています。個人ユーザーは Claude.ai アカウントでログインでき、チームは Claude for Teams または Enterprise、Claude Console、または Amazon Bedrock、Google Vertex AI、Microsoft Foundry などのクラウドプロバイダーを使用できます。
 
-## Claude Code にログインする
+<h2 id="log-in-to-claude-code">
+  Claude Code にログインする
+</h2>
 
 [Claude Code をインストール](/ja/setup#install-claude-code)した後、ターミナルで `claude` を実行します。初回起動時に、Claude Code はログインするためのブラウザウィンドウを開きます。
@@ -28,5 +30,7 @@ Claude Code は、セットアップに応じて複数の認証方法をサポ
 ログインに問題がある場合は、[認証のトラブルシューティング](/ja/troubleshoot-install#login-and-authentication)を参照してください。
 
-## チーム認証を設定する
+<h2 id="set-up-team-authentication">
+  チーム認証を設定する
+</h2>
 
 チームと組織の場合、Claude Code アクセスを以下のいずれかの方法で設定できます。
@@ -38,5 +42,7 @@ Claude Code は、セットアップに応じて複数の認証方法をサポ
 * [Microsoft Foundry](/ja/microsoft-foundry)
 
-### Claude for Teams または Enterprise
+<h3 id="claude-for-teams-or-enterprise">
+  Claude for Teams または Enterprise
+</h3>
 
```

</details>

<details>
<summary>auto-mode-config-ja.md</summary>

```diff
diff --git a/docs-ja/pages/auto-mode-config-ja.md b/docs-ja/pages/auto-mode-config-ja.md
index cc485a3..d63f4f7 100644
--- a/docs-ja/pages/auto-mode-config-ja.md
+++ b/docs-ja/pages/auto-mode-config-ja.md
@@ -25,5 +25,7 @@
 * [拒否を確認する](#review-denials)（次に何を追加するかを知るため）
 
-## 分類器が設定を読み込む場所
+<h2 id="where-the-classifier-reads-configuration">
+  分類器が設定を読み込む場所
+</h2>
 
 分類器は Claude 自体が読み込む同じ [CLAUDE.md](/ja/memory) コンテンツを読み込むため、プロジェクトの CLAUDE.md の「force push を絶対にしない」のような指示は、Claude と分類器の両方を同時に制御します。プロジェクト規約と動作ルールはここから始めてください。
@@ -46,5 +48,7 @@
 </Note>
 
-## 信頼できるインフラストラクチャを定義する
+<h2 id="define-trusted-infrastructure">
+  信頼できるインフラストラクチャを定義する
+</h2>
 
 ほとんどの組織では、`autoMode.environment` が設定する必要がある唯一のフィールドです。これは、分類器に、どのリポジトリ、バケット、ドメインが信頼できるかを指定します。分類器はこれを使用して「外部」が何を意味するかを決定するため、リストに記載されていない宛先は潜在的な流出ターゲットです。
@@ -98,5 +102,7 @@
 すべてを一度に入力する必要はありません。合理的なロールアウト。デフォルトから始めて、ソース管理組織と主要な内部サービスを追加します。これにより、独自のリポジトリへのプッシュなど、最も一般的な誤検知が解決されます。次に信頼できるドメインとクラウドバケットを追加します。ブロックが発生したら残りを入力します。
 
-## ブロックルールと許可ルールをオーバーライドする
+<h2 id="override-the-block-and-allow-rules">
+  ブロックルールと許可ルールをオーバーライドする
+</h2>
 
```

</details>

<details>
<summary>best-practices-ja.md</summary>

```diff
diff --git a/docs-ja/pages/best-practices-ja.md b/docs-ja/pages/best-practices-ja.md
index c480d8b..e548ab6 100644
--- a/docs-ja/pages/best-practices-ja.md
+++ b/docs-ja/pages/best-practices-ja.md
@@ -25,5 +25,7 @@ LLM のパフォーマンスはコンテキストが満杯になるにつれて
 ***
 
-## Claude に自分の作業を検証する方法を与える
+<h2 id="give-claude-a-way-to-verify-its-work">
+  Claude に自分の作業を検証する方法を与える
+</h2>
 
 <Tip>
@@ -54,5 +56,7 @@ Claude に成功を主張するのではなく、証拠を示すよう指示し
 ***
 
-## 最初に探索し、次に計画し、その後コーディングする
+<h2 id="explore-first-then-plan-then-code">
+  最初に探索し、次に計画し、その後コーディングする
+</h2>
 
 <Tip>
@@ -113,5 +117,7 @@ Claude が直接コーディングにジャンプさせると、間違った問
 ***
 
-## プロンプトで具体的なコンテキストを提供する
+<h2 id="provide-specific-context-in-your-prompts">
+  プロンプトで具体的なコンテキストを提供する
+</h2>
 
```

</details>

*...以降省略*

</details>


<details>
<summary>2026-06-09</summary>

**変更ファイル:**

```
 docs-ja/pages/changelog.md | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)
```

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index d840d7f..a52cc67 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,37 @@
 # Changelog
 
+## 2.1.169
+
+- Added `--safe-mode` flag (and `CLAUDE_CODE_SAFE_MODE`) to start Claude Code with all customizations (CLAUDE.md, plugins, skills, hooks, MCP servers) disabled for troubleshooting
+- Added `/cd` command to move a session to a new working directory without breaking the prompt cache mid-session
+- Added a `disableBundledSkills` setting and `CLAUDE_CODE_DISABLE_BUNDLED_SKILLS` environment variable to hide bundled skills, workflows, and built-in slash commands from the model
+- Fixed Up/Down arrows jumping to command history past the wrapped rows of a long input line — they now move through each visual row first, and history recall enters at the near edge
+- Fixed enterprise managed MCP policies (`allowedMcpServers`/`deniedMcpServers`) not being enforced on reconnect, IDE-typed configs, `--mcp-config` servers during the first session after install, or before remote settings loaded; also fixed slow cold starts for orgs without remote settings
+- Fixed a ~30-50ms UI stall at the start of each turn for macOS users logged in with claude.ai credentials
+- Fixed `claude -p` being slow or appearing to hang on Windows while waiting for the slash-command/skill scan (regression in 2.1.161)
+- Fixed Remote Control getting stuck on "reconnecting" after resuming a session when an OAuth token refresh happened at the same time
+- Fixed Git Credential Manager's "Connect to GitHub" popup appearing on Windows at startup when background git commands ran without cached credentials
+- Fixed footer hints (e.g. "esc to interrupt") not showing for users with a custom statusline
+- Fixed stale permission and dialog prompts reappearing every time you reattached to a remote session whose worker had died while waiting on them
+- Fixed `claude agents --json` omitting blocked and just-dispatched background sessions; added `--all` to include completed sessions, plus new `id` and `state` fields
+- Fixed agents view leaving a stale/garbled frame after navigating back from an agent on WSL in Windows Terminal
+- Fixed background agents ignoring project-level settings `env` values (e.g. `ANTHROPIC_MODEL`) when dispatched onto a pre-warmed worker
+- Fixed MCPB plugin cache being spuriously invalidated on Windows, causing unnecessary re-extraction
+- Fixed plugin `.in_use` PID lock files accumulating without bound; stale markers from crashed sessions are now swept once per day
+- Fixed untrusted project settings being able to set OTEL client-certificate paths without trust confirmation
+- `/workflows` now opens immediately even while a turn is in progress
+- Improved `TaskCreate` reliability: malformed inputs are repaired automatically and validation errors for unloaded tools include the schema
+- Improved the error message shown when your organization has disabled API key authentication, with guidance based on where the active API key comes from
+- Reduced CPU usage while responses stream and during spinner animations
```

</details>

</details>


<details>
<summary>2026-06-07</summary>

**変更ファイル:**

```
 docs-ja/pages/changelog.md | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)
```

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index b475a37..d840d7f 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,36 @@
 # Changelog
 
+## 2.1.168
+
+- Bug fixes and reliability improvements
+
+## 2.1.167
+
+- Bug fixes and reliability improvements
+
+## 2.1.166
+
+- Added `fallbackModel` setting to configure up to three fallback models tried in order when the primary model is overloaded or unavailable; `--fallback-model` now also applies to interactive sessions
+- Added glob pattern support in deny rule tool-name position (`"*"` denies all tools); allow rules reject non-MCP globs, and unknown tool names in deny rules warn at startup
+- Hardened cross-session messaging: messages relayed via `SendMessage` from other Claude sessions no longer carry user authority — receivers refuse relayed permission requests, and auto mode blocks them
+- `MAX_THINKING_TOKENS=0`, `--thinking disabled`, and the per-model thinking toggle now disable thinking on models that think by default via the Claude API (3P providers unchanged)
+- Claude Code now retries a turn once on the fallback model when the API rejects an unexpected non-retryable error; auth, rate-limit, request-size, and transport errors still surface immediately
+- `claude update` now announces the target version before downloading instead of going silent
+- `claude agents`: typing a URL into the list now filters to the session whose first prompt contained it
+- Fixed a recurring "image could not be processed" error and extra token usage when an unprocessable image was sent in a session
+- Fixed remote sessions becoming permanently stuck when a brief backend disruption occurred during worker registration at startup
+- Fixed flickering in JetBrains IDE terminals (IntelliJ, PyCharm, WebStorm, etc.) on 2026.1+ by enabling synchronized output
+- Fixed Shift+non-ASCII characters (e.g. Shift+ä → Ä) being dropped in terminals using the Kitty keyboard protocol (WezTerm, Ghostty, kitty)
+- Fixed PowerShell command validation occasionally hanging far past its time budget on Windows when a killed process's children held its output pipes
+- Fixed orphaned `claude --bg-pty-host` processes spinning at 100% CPU after the daemon dies while connected on macOS
```

</details>

</details>


<details>
<summary>2026-06-06</summary>

**変更ファイル:**

```
 docs-ja/pages/changelog.md | 4 ++++
 1 file changed, 4 insertions(+)
```

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index f877eb7..b475a37 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,8 @@
 # Changelog
 
+## 2.1.165
+
+- Bug fixes and reliability improvements
+
 ## 2.1.163
 
```

</details>

</details>


<details>
<summary>2026-06-05</summary>

**変更ファイル:**

```
 docs-ja/pages/changelog.md             |  25 ++
 docs-ja/pages/channels-reference-ja.md | 782 +++++++++++++++++++++++++++++++--
 docs-ja/pages/troubleshooting-ja.md    | 150 +++++--
 3 files changed, 907 insertions(+), 50 deletions(-)
```

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index e02bb2e..f877eb7 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,29 @@
 # Changelog
 
+## 2.1.163
+
+- Added `requiredMinimumVersion` and `requiredMaximumVersion` managed settings — Claude Code refuses to start if its version is outside the allowed range and directs the user to an approved version
+- Added `/plugin list` command to list installed plugins, with `--enabled`/`--disabled` filters
+- Added a "c to copy" shortcut to `/btw` that copies the raw markdown answer to the clipboard, preserving formatting when pasted elsewhere
+- Hooks: Stop and SubagentStop hooks can now return `hookSpecificOutput.additionalContext` to give Claude feedback and keep the turn going without being labeled a hook error
+- Skills: added `\$` escape syntax to include a literal `$` before a digit in command bodies
+- stdio MCP servers now receive the same `CLAUDE_CODE_SESSION_ID` as hooks/Bash on `--resume`
+- Fixed `claude -p` hanging forever after its final result when a backgrounded command never exits — background shells are now stopped ~5s after the result once stdin closes
+- Fixed `claude -p` failing with "ANTHROPIC_API_KEY required" on Bedrock/Vertex/Foundry when `CI=true` and no Anthropic API key is set
+- Fixed bash commands failing under bazel and EDR-protected Go workflows: `$TMPDIR` was overridden to `/tmp/claude-{uid}` for all commands instead of only sandboxed ones (regression in 2.1.154)
+- Fixed Bash commands failing on Windows with "EEXIST: file already exists" on the session-env directory when it has the read-only attribute or is inside OneDrive
+- Fixed org-managed permission rules not applying for the entire session when the managed settings fetch completed during startup on a fresh config directory
+- Fixed background sessions in `claude agents` losing their running background tasks when reattached after a Claude Code update
+- Fixed terminal misalignment and a multi-second hang when exiting the agent view by pressing Esc
+- Fixed clicking Stop on a background-task chip in the desktop app not clearing the chip when the underlying process was already gone
+- Fixed keyboard input becoming permanently unresponsive after a paste operation whose end marker is dropped by the terminal
+- Fixed hook `if: "Bash(...)"` conditions firing on every Bash command containing `$()` or `$VAR`; the pattern now matches against commands inside subshells and backticks too
+- Fixed deny rules on home-directory paths (e.g. `Read(~/Desktop/**)`) not blocking Bash commands that reference the path via `$HOME`
+- Fixed a stray "(no content)" line left in the transcript after closing panel dialogs like /mcp and /plugins
+- Background agent sessions now update to a new Claude Code version in the background, so opening a session after an update no longer waits on a cold restart
+- Clearer descriptions for built-in commands and skills in the / menu
+- The subscription-switch suggestion now shows in the startup announcement slot instead of a toast
```

</details>

<details>
<summary>channels-reference-ja.md</summary>

```diff
diff --git a/docs-ja/pages/channels-reference-ja.md b/docs-ja/pages/channels-reference-ja.md
index 7d00277..d3e6664 100644
--- a/docs-ja/pages/channels-reference-ja.md
+++ b/docs-ja/pages/channels-reference-ja.md
@@ -1,25 +1,757 @@
-<!DOCTYPE html><html lang="en" class="dark"><head><meta charSet="utf-8" data-next-head=""/><meta name="viewport" content="width=device-width" data-next-head=""/><link rel="preload" href="/docs/_next/static/media/f67ad414ed34149c-s.p.84166d94.woff2" as="font" type="font/woff2" crossorigin="anonymous" data-next-font="size-adjust"/><link rel="preload" href="/docs/_next/static/media/83afe278b6a6bb3c-s.p.3a6ba036.woff2" as="font" type="font/woff2" crossorigin="anonymous" data-next-font="size-adjust"/><link rel="preload" href="/docs/_next/static/media/70bc3e132a0a741e-s.p.15008bfb.woff2" as="font" type="font/woff2" crossorigin="anonymous" data-next-font="size-adjust"/><link rel="preload" href="/docs/_next/static/chunks/a55e453750c2a7fa.css?dpl=dpl_BhwhCYBiuV3ekjQKzo1MLMxFFZrj" as="style"/><link rel="preload" href="/docs/_next/static/chunks/b652b64e1051c665.css?dpl=dpl_BhwhCYBiuV3ekjQKzo1MLMxFFZrj" as="style"/><link rel="stylesheet" href="/docs/_next/static/chunks/a55e453750c2a7fa.css?dpl=dpl_BhwhCYBiuV3ekjQKzo1MLMxFFZrj" data-n-g=""/><link rel="stylesheet" href="/docs/_next/static/chunks/b652b64e1051c665.css?dpl=dpl_BhwhCYBiuV3ekjQKzo1MLMxFFZrj" data-n-g=""/><noscript data-n-css=""></noscript><script defer="" noModule="" src="/docs/_next/static/chunks/a6dad97d9634a72d.js?dpl=dpl_BhwhCYBiuV3ekjQKzo1MLMxFFZrj"></script><script src="/docs/_next/static/chunks/43c19863fe36e93b.js?dpl=dpl_BhwhCYBiuV3ekjQKzo1MLMxFFZrj" defer=""></script><script src="/docs/_next/static/chunks/3c928de4ba7be83b.js?dpl=dpl_BhwhCYBiuV3ekjQKzo1MLMxFFZrj" defer=""></script><script src="/docs/_next/static/chunks/86fe569cdc737c49.js?dpl=dpl_BhwhCYBiuV3ekjQKzo1MLMxFFZrj" defer=""></script><script src="/docs/_next/static/chunks/turbopack-75fb6b56b8755fe3.js?dpl=dpl_BhwhCYBiuV3ekjQKzo1MLMxFFZrj" defer=""></script><script src="/docs/_next/static/chunks/fbb6cc5da66f86ca.js?dpl=dpl_BhwhCYBiuV3ekjQKzo1MLMxFFZrj" defer=""></script><script src="/docs/_next/static/chunks/c1fce75d7b81c8aa.js?dpl=dpl_BhwhCYBiuV3ekjQKzo1MLMxFFZrj" defer=""></script><script src="/docs/_next/static/chunks/45693c1bc90a75b9.js?dpl=dpl_BhwhCYBiuV3ekjQKzo1MLMxFFZrj" defer=""></script><script src="/docs/_next/static/chunks/c769afa446170645.js?dpl=dpl_BhwhCYBiuV3ekjQKzo1MLMxFFZrj" defer=""></script><script src="/docs/_next/static/chunks/26355f534f6eb1e7.js?dpl=dpl_BhwhCYBiuV3ekjQKzo1MLMxFFZrj" defer=""></script><script src="/docs/_next/static/chunks/d1708a2f7646f126.js?dpl=dpl_BhwhCYBiuV3ekjQKzo1MLMxFFZrj" defer=""></script><script src="/docs/_next/static/chunks/turbopack-7384b69b884e7e5a.js?dpl=dpl_BhwhCYBiuV3ekjQKzo1MLMxFFZrj" defer=""></script><script src="/docs/_next/static/ss5xJB33E-HAu6QQpydoa/_ssgManifest.js?dpl=dpl_BhwhCYBiuV3ekjQKzo1MLMxFFZrj" defer=""></script><script src="/docs/_next/static/ss5xJB33E-HAu6QQpydoa/_buildManifest.js?dpl=dpl_BhwhCYBiuV3ekjQKzo1MLMxFFZrj" defer=""></script></head><div id="__next"><main class="inter_8e83f138-module__et_h3a__variable jetbrains_mono_8f10fcc1-module__2Oizva__variable"><script>((e,i,s,u,m,a,l,h)=>{let d=document.documentElement,w=["light","dark"];function p(n){(Array.isArray(e)?e:[e]).forEach(y=>{let k=y==="class",S=k&&a?m.map(f=>a[f]||f):m;k?(d.classList.remove(...S),d.classList.add(a&&a[n]?a[n]:n)):d.setAttribute(y,n)}),R(n)}function R(n){h&&w.includes(n)&&(d.style.colorScheme=n)}function c(){return window.matchMedia("(prefers-color-scheme: dark)").matches?"dark":"light"}if(u)p(u);else try{let n=localStorage.getItem(i)||s,y=l&&n==="system"?c():n;p(y)}catch(n){}})("class","isDarkMode","system",null,["dark","light","true","false","system"],{"true":"dark","false":"light","dark":"dark","light":"light"},true,false)</script><style>:root {
-    --primary: 22 163 74;
-    --primary-light: 74 222 128;
-    --primary-dark: 22 101 52;
-    --tooltip-foreground: 255 255 255;
-    --background-light: 255 255 255;
-    --background-dark: 10 13 13;
-    --gray-50: 243 247 245;
-    --gray-100: 238 242 240;
-    --gray-200: 223 227 224;
-    --gray-300: 206 211 208;
-    --gray-400: 159 163 160;
-    --gray-500: 112 116 114;
-    --gray-600: 80 84 82;
-    --gray-700: 63 67 64;
-    --gray-800: 38 42 39;
-    --gray-900: 23 27 25;
-    --gray-950: 10 15 12;
-  }</style><style>:root {
-  --primary: 17 120 102;
-  --primary-light: 74 222 128;
-  --primary-dark: 22 101 52;
-  --background-light: 255 255 255;
-  --background-dark: 15 17 23;
-}</style><main class="h-screen bg-background-light dark:bg-background-dark text-left"><article class="bg-custom bg-fixed bg-center bg-cover relative flex flex-col items-center justify-center h-full"><div class="w-full max-w-xl px-10"><span class="inline-flex mb-6 rounded-full px-3 py-1 text-sm font-semibold mr-4 text-white p-1 bg-primary">Error <!-- -->500</span><h1 class="font-semibold mb-3 text-3xl">Page not found!</h1><p class="text-lg text-gray-600 dark:text-gray-400 mb-6">An unexpected error occurred. Please <a class="font-medium text-gray-700 dark:text-gray-100 border-b hover:border-b-[2px] border-primary-dark dark:border-primary-light" href="mailto:support@mintlify.com">contact support</a> to get help.</p></div></article></main></main></div><script id="__NEXT_DATA__" type="application/json">{"props":{"pageProps":{}},"page":"/500","query":{},"buildId":"ss5xJB33E-HAu6QQpydoa","assetPrefix":"/docs","nextExport":true,"autoExport":true,"isFallback":false,"scriptLoader":[]}</script></html>
```

</details>

<details>
<summary>troubleshooting-ja.md</summary>

```diff
diff --git a/docs-ja/pages/troubleshooting-ja.md b/docs-ja/pages/troubleshooting-ja.md
index 7d00277..b49f307 100644
--- a/docs-ja/pages/troubleshooting-ja.md
+++ b/docs-ja/pages/troubleshooting-ja.md
@@ -1,25 +1,125 @@
-<!DOCTYPE html><html lang="en" class="dark"><head><meta charSet="utf-8" data-next-head=""/><meta name="viewport" content="width=device-width" data-next-head=""/><link rel="preload" href="/docs/_next/static/media/f67ad414ed34149c-s.p.84166d94.woff2" as="font" type="font/woff2" crossorigin="anonymous" data-next-font="size-adjust"/><link rel="preload" href="/docs/_next/static/media/83afe278b6a6bb3c-s.p.3a6ba036.woff2" as="font" type="font/woff2" crossorigin="anonymous" data-next-font="size-adjust"/><link rel="preload" href="/docs/_next/static/media/70bc3e132a0a741e-s.p.15008bfb.woff2" as="font" type="font/woff2" crossorigin="anonymous" data-next-font="size-adjust"/><link rel="preload" href="/docs/_next/static/chunks/a55e453750c2a7fa.css?dpl=dpl_BhwhCYBiuV3ekjQKzo1MLMxFFZrj" as="style"/><link rel="preload" href="/docs/_next/static/chunks/b652b64e1051c665.css?dpl=dpl_BhwhCYBiuV3ekjQKzo1MLMxFFZrj" as="style"/><link rel="stylesheet" href="/docs/_next/static/chunks/a55e453750c2a7fa.css?dpl=dpl_BhwhCYBiuV3ekjQKzo1MLMxFFZrj" data-n-g=""/><link rel="stylesheet" href="/docs/_next/static/chunks/b652b64e1051c665.css?dpl=dpl_BhwhCYBiuV3ekjQKzo1MLMxFFZrj" data-n-g=""/><noscript data-n-css=""></noscript><script defer="" noModule="" src="/docs/_next/static/chunks/a6dad97d9634a72d.js?dpl=dpl_BhwhCYBiuV3ekjQKzo1MLMxFFZrj"></script><script src="/docs/_next/static/chunks/43c19863fe36e93b.js?dpl=dpl_BhwhCYBiuV3ekjQKzo1MLMxFFZrj" defer=""></script><script src="/docs/_next/static/chunks/3c928de4ba7be83b.js?dpl=dpl_BhwhCYBiuV3ekjQKzo1MLMxFFZrj" defer=""></script><script src="/docs/_next/static/chunks/86fe569cdc737c49.js?dpl=dpl_BhwhCYBiuV3ekjQKzo1MLMxFFZrj" defer=""></script><script src="/docs/_next/static/chunks/turbopack-75fb6b56b8755fe3.js?dpl=dpl_BhwhCYBiuV3ekjQKzo1MLMxFFZrj" defer=""></script><script src="/docs/_next/static/chunks/fbb6cc5da66f86ca.js?dpl=dpl_BhwhCYBiuV3ekjQKzo1MLMxFFZrj" defer=""></script><script src="/docs/_next/static/chunks/c1fce75d7b81c8aa.js?dpl=dpl_BhwhCYBiuV3ekjQKzo1MLMxFFZrj" defer=""></script><script src="/docs/_next/static/chunks/45693c1bc90a75b9.js?dpl=dpl_BhwhCYBiuV3ekjQKzo1MLMxFFZrj" defer=""></script><script src="/docs/_next/static/chunks/c769afa446170645.js?dpl=dpl_BhwhCYBiuV3ekjQKzo1MLMxFFZrj" defer=""></script><script src="/docs/_next/static/chunks/26355f534f6eb1e7.js?dpl=dpl_BhwhCYBiuV3ekjQKzo1MLMxFFZrj" defer=""></script><script src="/docs/_next/static/chunks/d1708a2f7646f126.js?dpl=dpl_BhwhCYBiuV3ekjQKzo1MLMxFFZrj" defer=""></script><script src="/docs/_next/static/chunks/turbopack-7384b69b884e7e5a.js?dpl=dpl_BhwhCYBiuV3ekjQKzo1MLMxFFZrj" defer=""></script><script src="/docs/_next/static/ss5xJB33E-HAu6QQpydoa/_ssgManifest.js?dpl=dpl_BhwhCYBiuV3ekjQKzo1MLMxFFZrj" defer=""></script><script src="/docs/_next/static/ss5xJB33E-HAu6QQpydoa/_buildManifest.js?dpl=dpl_BhwhCYBiuV3ekjQKzo1MLMxFFZrj" defer=""></script></head><div id="__next"><main class="inter_8e83f138-module__et_h3a__variable jetbrains_mono_8f10fcc1-module__2Oizva__variable"><script>((e,i,s,u,m,a,l,h)=>{let d=document.documentElement,w=["light","dark"];function p(n){(Array.isArray(e)?e:[e]).forEach(y=>{let k=y==="class",S=k&&a?m.map(f=>a[f]||f):m;k?(d.classList.remove(...S),d.classList.add(a&&a[n]?a[n]:n)):d.setAttribute(y,n)}),R(n)}function R(n){h&&w.includes(n)&&(d.style.colorScheme=n)}function c(){return window.matchMedia("(prefers-color-scheme: dark)").matches?"dark":"light"}if(u)p(u);else try{let n=localStorage.getItem(i)||s,y=l&&n==="system"?c():n;p(y)}catch(n){}})("class","isDarkMode","system",null,["dark","light","true","false","system"],{"true":"dark","false":"light","dark":"dark","light":"light"},true,false)</script><style>:root {
-    --primary: 22 163 74;
-    --primary-light: 74 222 128;
-    --primary-dark: 22 101 52;
-    --tooltip-foreground: 255 255 255;
-    --background-light: 255 255 255;
-    --background-dark: 10 13 13;
-    --gray-50: 243 247 245;
-    --gray-100: 238 242 240;
-    --gray-200: 223 227 224;
-    --gray-300: 206 211 208;
-    --gray-400: 159 163 160;
-    --gray-500: 112 116 114;
-    --gray-600: 80 84 82;
-    --gray-700: 63 67 64;
-    --gray-800: 38 42 39;
-    --gray-900: 23 27 25;
-    --gray-950: 10 15 12;
-  }</style><style>:root {
-  --primary: 17 120 102;
-  --primary-light: 74 222 128;
-  --primary-dark: 22 101 52;
-  --background-light: 255 255 255;
-  --background-dark: 15 17 23;
-}</style><main class="h-screen bg-background-light dark:bg-background-dark text-left"><article class="bg-custom bg-fixed bg-center bg-cover relative flex flex-col items-center justify-center h-full"><div class="w-full max-w-xl px-10"><span class="inline-flex mb-6 rounded-full px-3 py-1 text-sm font-semibold mr-4 text-white p-1 bg-primary">Error <!-- -->500</span><h1 class="font-semibold mb-3 text-3xl">Page not found!</h1><p class="text-lg text-gray-600 dark:text-gray-400 mb-6">An unexpected error occurred. Please <a class="font-medium text-gray-700 dark:text-gray-100 border-b hover:border-b-[2px] border-primary-dark dark:border-primary-light" href="mailto:support@mintlify.com">contact support</a> to get help.</p></div></article></main></main></div><script id="__NEXT_DATA__" type="application/json">{"props":{"pageProps":{}},"page":"/500","query":{},"buildId":"ss5xJB33E-HAu6QQpydoa","assetPrefix":"/docs","nextExport":true,"autoExport":true,"isFallback":false,"scriptLoader":[]}</script></html>
```

</details>

</details>


<details>
<summary>2026-06-04</summary>

**変更ファイル:**

```
 docs-ja/pages/amazon-bedrock-ja.md     |   1 +
 docs-ja/pages/changelog.md             |  31 ++
 docs-ja/pages/channels-reference-ja.md | 782 ++-------------------------------
 docs-ja/pages/chrome-ja.md             |   4 +-
 docs-ja/pages/claude-directory-ja.md   |   2 +-
 docs-ja/pages/env-vars-ja.md           |  15 +-
 docs-ja/pages/fast-mode-ja.md          |   2 +-
 docs-ja/pages/headless-ja.md           |  22 +-
 docs-ja/pages/hooks-guide-ja.md        |  36 +-
 docs-ja/pages/hooks-ja.md              |  50 +--
 docs-ja/pages/mcp-ja.md                |   2 +
 docs-ja/pages/monitoring-usage-ja.md   |  40 +-
 docs-ja/pages/prompt-caching-ja.md     |  11 +
 docs-ja/pages/settings-ja.md           | 190 ++++----
 docs-ja/pages/sub-agents-ja.md         |   7 +-
 docs-ja/pages/troubleshooting-ja.md    | 146 ++----
 16 files changed, 282 insertions(+), 1059 deletions(-)
```

<details>
<summary>amazon-bedrock-ja.md</summary>

```diff
diff --git a/docs-ja/pages/amazon-bedrock-ja.md b/docs-ja/pages/amazon-bedrock-ja.md
index 90046f9..c411db1 100644
--- a/docs-ja/pages/amazon-bedrock-ja.md
+++ b/docs-ja/pages/amazon-bedrock-ja.md
@@ -225,4 +225,5 @@ Claude Code で Bedrock を有効にする場合は、以下に注意してく
 * `AWS_REGION` は必須の環境変数です。Claude Code はこの設定について `.aws` 設定ファイルから読み込みません。
 * Bedrock を使用する場合、`/logout` コマンドは無効になります。認証は AWS 認証情報を通じて処理されるためです。
+* WebSearch ツールは Bedrock では利用できません。[WebSearch ツールの動作](/ja/tools-reference#websearch-tool-behavior)を参照してください。
 * 他のプロセスに漏らしたくない `AWS_PROFILE` などの環境変数に設定ファイルを使用できます。詳細については [Settings](/ja/settings) を参照してください。
 
```

</details>

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index d4dab2e..e02bb2e 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,35 @@
 # Changelog
 
+## 2.1.162
+
+- `claude agents --json` now includes `waitingFor` showing what a waiting session is blocked on (e.g. permission prompt)
+- `--tools`: explicitly listing Grep/Glob now provides the dedicated search tools on native builds with embedded search (previously these names were silently ignored)
+- `/effort` now confirms when your chosen level will persist as the default for new sessions
+- Clicking a slash command in the autocomplete menu now fills it into your prompt instead of running it immediately; press Enter to run
+- Remote Control now shows as a persistent footer pill (with a link to the session) instead of a startup message
+- Renamed Windsurf to Devin Desktop in the `/ide` menu, `/terminal-setup`, and `/scroll-speed`, following the editor's rebrand
+- Fixed a silent startup hang when the config directory is read-only or unwritable — Claude Code now starts with in-memory config and surfaces startup errors instead of showing a blank screen
+- Fixed WebFetch permission rules not being applied to built-in preapproved domains; explicit `WebFetch(domain:...)` deny/ask/allow rules now take precedence over the preapproved-host auto-allow
+- Fixed Windows permission rules never matching when spelled with backslashes (`~\`, `\\server\share`) or case-variant paths, and Read deny rules not hiding files from Glob/Grep results
+- Fixed an interrupt (Esc) sent at the very start of a turn being silently dropped in stream-json/SDK sessions, leaving the turn running with no "Interrupted" feedback
+- Fixed API 400 `no low surrogate in string` errors for classifier side-queries and MCP server descriptions containing emoji near a truncation boundary
+- Fixed MCP per-server `timeout` config values below 1000 ms being floored to a 1-second watchdog that aborted every tool call; sub-1000 ms values are now ignored (falling back to `MCP_TOOL_TIMEOUT` or default), and `claude mcp get` annotates them accordingly
+- Fixed the LSP tool's `workspaceSymbol` operation returning no results; it now accepts a `query` parameter and passes it to the language server
+- Fixed `claude agents` cutting live status text (tool args, replies, prompts, exec output) at 60–120 columns on wide terminals; the status detail now uses the full terminal width
+- Fixed `claude agents` truncating long session names at 40 columns; the name column now grows with terminal width
+- Fixed `claude agents` attach occasionally bouncing straight back to the session list on the first try after a background-service restart
+- Fixed `claude agents` Ctrl+V image paste doing nothing in the dispatch input and the session reply box; pasting with no image now shows a hint
+- Fixed backgrounding a session with ← silently losing the conversation when the background service cannot start; the session stays in the list as a failed row you can wake with Enter
+- Fixed replies from the agents view that fail to send being lost; they are now queued for delivery on the next session start
+- Fixed cross-session messaging (`SendMessage`) silently breaking when `CLAUDE_CODE_TMPDIR` or `$TMPDIR` points at a deep directory
+- Fixed opening a running background session from `claude agents` stalling for 5 seconds before attaching
```

</details>

<details>
<summary>channels-reference-ja.md</summary>

```diff
diff --git a/docs-ja/pages/channels-reference-ja.md b/docs-ja/pages/channels-reference-ja.md
index d3e6664..7d00277 100644
--- a/docs-ja/pages/channels-reference-ja.md
+++ b/docs-ja/pages/channels-reference-ja.md
@@ -1,757 +1,25 @@
-> ## Documentation Index
-> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
-> Use this file to discover all available pages before exploring further.
-
-# チャネルリファレンス
-
-> webhook、アラート、チャットメッセージを Claude Code セッションにプッシュする MCP サーバーを構築します。チャネルコントラクトのリファレンス：機能宣言、通知イベント、返信ツール、送信者ゲーティング、権限リレー。
-
-<Note>
-  チャネルは[リサーチプレビュー](/ja/channels#research-preview)段階にあり、Claude Code v2.1.80 以降が必要です。Team および Enterprise 組織は[明示的に有効化](/ja/channels#enterprise-controls)する必要があります。
-</Note>
-
-チャネルは、Claude Code セッションにイベントをプッシュする MCP サーバーで、Claude がターミナルの外で発生していることに反応できるようにします。
-
-一方向または双方向のチャネルを構築できます。一方向チャネルは、アラート、webhook、または監視イベントを転送して Claude が対応できるようにします。チャットブリッジのような双方向チャネルは、Claude がメッセージを返送できるように[返信ツールを公開](#expose-a-reply-tool)することもできます。信頼できる送信者パスを持つチャネルは、[権限プロンプトをリレー](#relay-permission-prompts)することを選択して、ツール使用をリモートで承認または拒否できます。
-
-このページでは以下をカバーしています：
-
-* [概要](#overview)：チャネルの仕組み
-* [必要なもの](#what-you-need)：要件と一般的な手順
-* [例：webhook レシーバーを構築](#example-build-a-webhook-receiver)：最小限の一方向ウォークスルー
-* [サーバーオプション](#server-options)：コンストラクタフィールド
-* [通知フォーマット](#notification-format)：イベントペイロードと配信動作
-* [返信ツールを公開](#expose-a-reply-tool)：Claude がメッセージを返送できるようにする
-* [インバウンドメッセージをゲート](#gate-inbound-messages)：プロンプトインジェクションを防ぐための送信者チェック
```

</details>

<details>
<summary>chrome-ja.md</summary>

```diff
diff --git a/docs-ja/pages/chrome-ja.md b/docs-ja/pages/chrome-ja.md
index c7091f7..cba3951 100644
--- a/docs-ja/pages/chrome-ja.md
+++ b/docs-ja/pages/chrome-ja.md
@@ -69,5 +69,5 @@ VS Code については、[VS Code でのブラウザ自動化](/ja/vs-code#auto
 ### Chrome をデフォルトで有効にする
 
-各セッションで `--chrome` を渡すことを避けるには、`/chrome` を実行して「Enabled by default」を選択します。
+各セッションで `--chrome` を渡すことを避けるには、`/chrome` を実行して「デフォルトで有効」を選択します。
 
 [VS Code 拡張機能](/ja/vs-code#automate-browser-tasks-with-chrome) では、Chrome 拡張機能がインストールされている場合、Chrome はいつでも利用可能です。追加のフラグは必要ありません。
@@ -169,5 +169,5 @@ Claude はインタラクションシーケンスを記録し、GIF ファイル
 ### 拡張機能が検出されない
 
-Claude Code が「Chrome extension not detected」を表示する場合：
+Claude Code の setup-issues 行に `chrome` がリストされている場合：
 
 1. Chrome 拡張機能が `chrome://extensions` にインストールされ、有効になっていることを確認します
```

</details>

<details>
<summary>claude-directory-ja.md</summary>

```diff
diff --git a/docs-ja/pages/claude-directory-ja.md b/docs-ja/pages/claude-directory-ja.md
index 3347c46..931e4cd 100644
--- a/docs-ja/pages/claude-directory-ja.md
+++ b/docs-ja/pages/claude-directory-ja.md
@@ -1557,5 +1557,5 @@ Windows では、`~/.claude` は `%USERPROFILE%\.claude` に解決されます
 ### ローカルデータをクリアする
 
-`claude project purge` を実行して、1 つのプロジェクトに対して Claude Code が保持する状態を削除します：
+`claude project purge` を実行して、1 つのプロジェクトに対して Claude Code が保持する状態を削除します。このコマンドには Claude Code v2.1.124 以降が必要です。以下を削除します：
 
 * `projects/` の下のトランスクリプトと自動メモリ
```

</details>

<details>
<summary>env-vars-ja.md</summary>

```diff
diff --git a/docs-ja/pages/env-vars-ja.md b/docs-ja/pages/env-vars-ja.md
index 988c1ea..ab6707c 100644
--- a/docs-ja/pages/env-vars-ja.md
+++ b/docs-ja/pages/env-vars-ja.md
@@ -151,5 +151,5 @@ Claude Code は起動時に環境変数を読み取るため、変更は `claude
 | `CLAUDE_CODE_DEBUG_LOG_LEVEL`                           | デバッグログファイルに書き込まれる最小ログレベル。値：`verbose`、`debug`（デフォルト）、`info`、`warn`、`error`。フルステータスラインコマンド出力などの大量の診断を含めるには `verbose` に設定するか、ノイズを減らすには `error` に上げます                                                                                                                                                                                                                                                                              |
 | `CLAUDE_CODE_DISABLE_1M_CONTEXT`                        | [1M コンテキストウィンドウ](/ja/model-config#extended-context) サポートを無効にするには `1` に設定します。設定すると、1M モデルバリアントはモデルピッカーで利用できなくなります。コンプライアンス要件のあるエンタープライズ環境に役立ちます                                                                                                                                                                                                                                                                                 |
-| `CLAUDE_CODE_DISABLE_ADAPTIVE_THINKING`                 | Opus 4.6 と Sonnet 4.6 の [適応的推論](/ja/model-config#adjust-effort-level) を無効にするには `1` に設定します。`MAX_THINKING_TOKENS` で制御される固定思考予算にフォールバックします。{/* min-version: 2.1.111 */}Opus 4.7 以降では効果がなく、常に適応的推論を使用します                                                                                                                                                                                                                           |
+| `CLAUDE_CODE_DISABLE_ADAPTIVE_THINKING`                 | Opus 4.6 と Sonnet 4.6 の [適応的推論](/ja/model-config#adjust-effort-level) を無効にするには `1` に設定します。`MAX_THINKING_TOKENS` で制御される固定思考予算にフォールバックします。{/* min-version: 2.1.111 */}v2.1.111 以降、Opus 4.7 以降では効果がなく、常に適応的推論を使用します                                                                                                                                                                                                               |
 | `CLAUDE_CODE_DISABLE_AGENT_VIEW`                        | [バックグラウンドエージェントとエージェントビュー](/ja/agent-view) をオフにするには `1` に設定します：`claude agents`、`--bg`、`/background`、およびオンデマンドスーパーバイザー。[`disableAgentView`](/ja/settings#available-settings) 設定と同等です                                                                                                                                                                                                                                            |
 | `CLAUDE_CODE_DISABLE_ALTERNATE_SCREEN`                  | [フルスクリーンレンダリング](/ja/fullscreen) を無効にするには `1` に設定します。クラシックなメインスクリーンレンダラーを使用します。会話はターミナルのネイティブなスクロールバックに留まるため、`Cmd+f` と tmux コピーモードが通常通り機能します。`CLAUDE_CODE_NO_FLICKER` と [`tui`](/ja/settings#available-settings) 設定より優先されます。`/tui default` で切り替えることもできます。バックグラウンドセッションから開かれた [エージェントビュー](/ja/agent-view) には適用されません。これらは常にフルスクリーンレンダリングを使用します                                                                                    |
@@ -175,5 +175,5 @@ Claude Code は起動時に環境変数を読み取るため、変更は `claude
 | `CLAUDE_CODE_DISABLE_WORKFLOWS`                         | [ワークフロー](/ja/workflows#turn-workflows-off) を無効にするには `1` に設定します。[`disableWorkflows`](/ja/settings#available-settings) 設定と同等です                                                                                                                                                                                                                                                                                                   |
 | `CLAUDE_CODE_EFFORT_LEVEL`                              | サポートされているモデルの努力レベルを設定します。値：`low`、`medium`、`high`、`xhigh`、`max`、または `auto`（モデルのデフォルトを使用）。利用可能なレベルはモデルによって異なります。`/effort` および `effortLevel` 設定より優先されます。[努力レベルを調整](/ja/model-config#adjust-effort-level) を参照してください                                                                                                                                                                                                                |
-| `CLAUDE_CODE_ENABLE_AUTO_MODE`                          | {/* min-version: 2.1.158 */}Amazon Bedrock、Google Cloud Vertex AI、Microsoft Foundry で [自動モード](/ja/permission-modes#eliminate-prompts-with-auto-mode) を利用可能にするには `1` に設定します。Anthropic API では効果がなく、自動モードはデフォルトで利用可能です。[Bedrock、Vertex AI、または Foundry で自動モードを有効にする](/ja/permission-modes#enable-auto-mode-on-bedrock-vertex-ai-or-foundry) を参照してください                                                                              |
+| `CLAUDE_CODE_ENABLE_AUTO_MODE`                          | {/* min-version: 2.1.158 */}Amazon Bedrock、Google Cloud Vertex AI、Microsoft Foundry で [自動モード](/ja/permission-modes#eliminate-prompts-with-auto-mode) を利用可能にするには `1` に設定します。Claude Code v2.1.158 以降が必須です。Anthropic API では効果がなく、自動モードはデフォルトで利用可能です。[Bedrock、Vertex AI、または Foundry で自動モードを有効にする](/ja/permission-modes#enable-auto-mode-on-bedrock-vertex-ai-or-foundry) を参照してください                                                 |
 | `CLAUDE_CODE_ENABLE_AWAY_SUMMARY`                       | [セッションリキャップ](/ja/interactive-mode#session-recap) の利用可能性をオーバーライドします。`/config` トグルに関係なくリキャップを強制的にオフにするには `0` に設定します。[`awaySummaryEnabled`](/ja/settings#available-settings) が `false` の場合にリキャップを強制的にオンにするには `1` に設定します。設定と `/config` トグルより優先されます                                                                                                                                                                                 |
 | `CLAUDE_CODE_ENABLE_BACKGROUND_PLUGIN_REFRESH`          | [非対話モード](/ja/headless) でバックグラウンドインストールが完了した後、ターン境界でプラグイン状態をリフレッシュするには `1` に設定します。リフレッシュはセッション中にシステムプロンプトを変更するため、デフォルトではオフです。これにより、そのターンの [プロンプトキャッシング](/ja/prompt-caching) が無効になります                                                                                                                                                                                                                                            |
@@ -190,5 +190,5 @@ Claude Code は起動時に環境変数を読み取るため、変更は `claude
 | `CLAUDE_CODE_FILE_READ_MAX_OUTPUT_TOKENS`               | ファイル読み取りのデフォルトトークン制限をオーバーライドします。より大きなファイルを完全に読み取る必要がある場合に役立ちます                                                                                                                                                                                                                                                                                                                                                                 |
 | `CLAUDE_CODE_FORCE_SYNC_OUTPUT`                         | ターミナルがサポートしているが自動検出されていない場合、DEC プライベートモード 2026 [同期出力](https://gist.github.com/christianparpart/d8a62cc1ab659194337d73e399004036) を強制的に有効にするには `1` に設定します。Emacs `eat` などのエミュレーターで役立ちます。これは BSU/ESU を実装していますが、機能プローブに応答しません。tmux では効果がありません                                                                                                                                                                                      |
-| `CLAUDE_CODE_FORK_SUBAGENT`                             | [フォークされた subagent](/ja/sub-agents#fork-the-current-conversation) を有効にするには `1` に設定します。フォークされた subagent は、最初から開始する代わりに、メインセッションから完全な会話コンテキストを継承します。有効にすると、`/fork` は [`/branch`](/ja/commands) のエイリアスとして機能する代わりに、フォークされた subagent をスポーンします。すべての subagent スポーンはバックグラウンドで実行されます。対話モードと SDK または `claude -p` を通じて                                                                                                                     |
+| `CLAUDE_CODE_FORK_SUBAGENT`                             | [フォークされた subagent](/ja/sub-agents#fork-the-current-conversation) をモデルのデフォルトにするには `1` に設定します：Claude は、一般的な subagent を使用する代わりにフォークをスポーンします。フォークは、最初から開始する代わりに、完全な会話コンテキストを継承する subagent です。すべての subagent スポーンはバックグラウンドで実行されます。明示的な [`/fork`](/ja/commands) コマンドはこの変数なしで機能します。対話モードと SDK または `claude -p` を通じて機能します                                                                                                                |
 | `CLAUDE_CODE_GIT_BASH_PATH`                             | Windows のみ：Git Bash 実行可能ファイル（`bash.exe`）へのパス。Git Bash がインストールされているが PATH にない場合に使用します。[Windows セットアップ](/ja/setup#set-up-on-windows) を参照してください                                                                                                                                                                                                                                                                                   |
 | `CLAUDE_CODE_GLOB_HIDDEN`                               | Claude が [Glob ツール](/ja/tools-reference#glob-tool-behavior) を呼び出すときに結果からドットファイルを除外するには `false` に設定します。デフォルトで含まれます。`@` ファイルオートコンプリート、`ls`、Grep、または Read には影響しません                                                                                                                                                                                                                                                                |
@@ -223,5 +223,5 @@ Claude Code は起動時に環境変数を読み取るため、変更は `claude
 | `CLAUDE_CODE_PLUGIN_SEED_DIR`                           | 1 つ以上の読み取り専用プラグインシードディレクトリへのパス。Unix では `:` で、Windows では `;` で区切られます。事前入力されたプラグインディレクトリをコンテナイメージにバンドルするために使用します。Claude Code はこれらのディレクトリからマーケットプレイスを登録し、再クローンなしで事前キャッシュされたプラグインを使用します。[コンテナ用のプラグインを事前入力](/ja/plugin-marketplaces#pre-populate-plugins-for-containers) を参照してください                                                                                                                                                  |
 | `CLAUDE_CODE_POWERSHELL_RESPECT_EXECUTION_POLICY`       | Claude Code が PowerShell をスポーンするときに `-ExecutionPolicy Bypass` を渡すことを停止するには `1` に設定します。ツール呼び出し、フック、ステータスラインコマンドの場合、マシンの有効な実行ポリシーを尊重します。デフォルトでは Claude Code はプロセススコープでバイパスを実行するため、`.ps1` スクリプトとモジュールインポートはデフォルト制限 Windows インストールで機能します。プロセススコープバイパスは、この設定に関係なく、グループポリシー `MachinePolicy` または `UserPolicy` をオーバーライドしません                                                                                                            |
-| `CLAUDE_CODE_PROPAGATE_TRACEPARENT`                     | {/* min-version: 2.1.152 */}カスタムプロキシを指す場合、W3C トレースコンテキストを伝播するには `1` に設定します。`ANTHROPIC_BASE_URL` が指しています。伝播は、モデルと HTTP MCP リクエストの `traceparent` ヘッダーと、Bash、PowerShell、フックサブプロセスの `TRACEPARENT` 環境変数をカバーします。デフォルトでは、伝播は Anthropic API に直接接続されている場合にのみ有効になります。[トレース（ベータ）](/ja/monitoring-usage#traces-beta) を参照してください                                                                                                             |
+| `CLAUDE_CODE_PROPAGATE_TRACEPARENT`                     | {/* min-version: 2.1.152 */}カスタムプロキシを指す場合、W3C トレースコンテキストを伝播するには `1` に設定します。`ANTHROPIC_BASE_URL` が指しています。伝播は、モデルと HTTP MCP リクエストの `traceparent` ヘッダーと、Bash、PowerShell、フックサブプロセスの `TRACEPARENT` 環境変数をカバーします。デフォルトでは、伝播は Anthropic API に直接接続されている場合にのみ有効になります。v2.1.152 で追加されました。[トレース（ベータ）](/ja/monitoring-usage#traces-beta) を参照してください                                                                                           |
```

</details>

<details>
<summary>fast-mode-ja.md</summary>

```diff
diff --git a/docs-ja/pages/fast-mode-ja.md b/docs-ja/pages/fast-mode-ja.md
index fd997e8..90d5579 100644
--- a/docs-ja/pages/fast-mode-ja.md
+++ b/docs-ja/pages/fast-mode-ja.md
@@ -65,5 +65,5 @@ Opus 4.8 は Claude Code v2.1.154 以降の高速モードのデフォルトで
 高速モード価格は完全な 1M トークンコンテキストウィンドウ全体で一定です。比較対象となる標準 Opus レートについては、[Claude 価格リファレンス](https://platform.claude.com/docs/ja/about-claude/pricing)を参照してください。
 
-会話の途中で高速モードに切り替えると、会話コンテキスト全体に対して完全な高速モードキャッシュなし入力トークン価格を支払います。これは最初から高速モードを有効にした場合よりもコストが高くなります。
+会話で初めて高速モードを有効にすると、会話コンテキスト全体に対して完全な高速モードキャッシュなし入力トークン価格を支払います。会話が進むほど、このコストは高くなるため、最初から高速モードを有効にする方が安くなります。コストは会話ごとに 1 回適用されるため、後で高速モードをオフにしてからオンに切り替えても、再度請求されることはありません。メカニズムについては、[高速モードがプロンプトキャッシュとどのように相互作用するか](/ja/prompt-caching#turning-on-fast-mode)を参照してください。
 
 ## 高速モードの使用時期を判断する
```

</details>

<details>
<summary>headless-ja.md</summary>

```diff
diff --git a/docs-ja/pages/headless-ja.md b/docs-ja/pages/headless-ja.md
index 2d91423..cfda9d0 100644
--- a/docs-ja/pages/headless-ja.md
+++ b/docs-ja/pages/headless-ja.md
@@ -153,15 +153,15 @@ claude -p "Write a poem" --output-format stream-json --verbose --include-partial
 API リクエストが再試行可能なエラーで失敗すると、Claude Code は再試行前に `system/api_retry` イベントを発行します。これを使用して、再試行の進行状況を表示したり、カスタムバックオフロジックを実装したりできます。
 
-| フィールド            | 型             | 説明                                                                                                                                                                        |
-| ---------------- | ------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
-| `type`           | `"system"`    | メッセージタイプ                                                                                                                                                                  |
-| `subtype`        | `"api_retry"` | これが再試行イベントであることを識別します                                                                                                                                                     |
-| `attempt`        | 整数            | 現在の試行番号（1 から開始）                                                                                                                                                           |
-| `max_retries`    | 整数            | 許可される再試行の合計                                                                                                                                                               |
-| `retry_delay_ms` | 整数            | 次の試行までのミリ秒                                                                                                                                                                |
-| `error_status`   | 整数または null    | HTTP ステータスコード、または HTTP レスポンスのない接続エラーの場合は `null`                                                                                                                           |
-| `error`          | 文字列           | エラーカテゴリ：`authentication_failed`、`oauth_org_not_allowed`、`billing_error`、`rate_limit`、`invalid_request`、`model_not_found`、`server_error`、`max_output_tokens`、または `unknown` |
-| `uuid`           | 文字列           | 一意のイベント識別子                                                                                                                                                                |
-| `session_id`     | 文字列           | イベントが属するセッション                                                                                                                                                             |
+| フィールド            | 型             | 説明                                                                                                                                                                                     |
+| ---------------- | ------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
+| `type`           | `"system"`    | メッセージタイプ                                                                                                                                                                               |
+| `subtype`        | `"api_retry"` | これが再試行イベントであることを識別します                                                                                                                                                                  |
+| `attempt`        | 整数            | 現在の試行番号（1 から開始）                                                                                                                                                                        |
+| `max_retries`    | 整数            | 許可される再試行の合計                                                                                                                                                                            |
+| `retry_delay_ms` | 整数            | 次の試行までのミリ秒                                                                                                                                                                             |
+| `error_status`   | 整数または null    | HTTP ステータスコード、または HTTP レスポンスのない接続エラーの場合は `null`                                                                                                                                        |
+| `error`          | 文字列           | エラーカテゴリ：`authentication_failed`、`oauth_org_not_allowed`、`billing_error`、`rate_limit`、`overloaded`、`invalid_request`、`model_not_found`、`server_error`、`max_output_tokens`、または `unknown` |
+| `uuid`           | 文字列           | 一意のイベント識別子                                                                                                                                                                             |
+| `session_id`     | 文字列           | イベントが属するセッション                                                                                                                                                                          |
 
```

</details>

*...以降省略*

</details>


<details>
<summary>2026-06-03</summary>

**変更ファイル:**

```
 docs-ja/pages/admin-setup-ja.md            |    3 +-
 docs-ja/pages/agent-view-ja.md             |    6 +-
 docs-ja/pages/agents-ja.md                 |    4 +-
 docs-ja/pages/amazon-bedrock-ja.md         |    6 +-
 docs-ja/pages/analytics-ja.md              |   16 +-
 docs-ja/pages/auto-mode-config-ja.md       |    2 +-
 docs-ja/pages/changelog.md                 |   55 ++
 docs-ja/pages/channels-ja.md               |   25 +-
 docs-ja/pages/chrome-ja.md                 |    2 +-
 docs-ja/pages/claude-code-on-the-web-ja.md |    2 +
 docs-ja/pages/code-review-ja.md            |    2 +-
 docs-ja/pages/commands-ja.md               |    5 +-
 docs-ja/pages/common-workflows-ja.md       |    2 +
 docs-ja/pages/computer-use-ja.md           |   11 +-
 docs-ja/pages/desktop-ja.md                |    4 +-
 docs-ja/pages/env-vars-ja.md               |    9 +-
 docs-ja/pages/errors-ja.md                 |   10 +-
 docs-ja/pages/fast-mode-ja.md              |    2 +-
 docs-ja/pages/fullscreen-ja.md             |    2 +
 docs-ja/pages/github-actions-ja.md         |    2 +-
 docs-ja/pages/glossary-ja.md               |    2 +-
 docs-ja/pages/google-vertex-ai-ja.md       |    8 +-
 docs-ja/pages/interactive-mode-ja.md       |    2 +-
 docs-ja/pages/jetbrains-ja.md              |    2 +-
 docs-ja/pages/mcp-ja.md                    |    4 +-
 docs-ja/pages/microsoft-foundry-ja.md      |    4 +-
 docs-ja/pages/model-config-ja.md           |   59 +-
 docs-ja/pages/network-config-ja.md         |   25 +-
 docs-ja/pages/overview-ja.md               |    2 +-
 docs-ja/pages/permission-modes-ja.md       |   48 +-
 docs-ja/pages/permissions-ja.md            |    2 +-
 docs-ja/pages/plugin-dependencies-ja.md    |    2 +
 docs-ja/pages/plugins-reference-ja.md      |    2 -
 docs-ja/pages/prompt-library-en.md         | 1389 ----------------------------
 docs-ja/pages/settings-ja.md               |    4 +-
 docs-ja/pages/slack-ja.md                  |   47 +-
 docs-ja/pages/sub-agents-ja.md             |    2 +-
 docs-ja/pages/terminal-config-ja.md        |    6 +-
 docs-ja/pages/tools-reference-ja.md        |    4 +-
 docs-ja/pages/troubleshooting-ja.md        |    6 +-
 docs-ja/pages/vs-code-ja.md                |   44 +-
 docs-ja/pages/web-quickstart-ja.md         |   12 +-
 docs-ja/pages/workflows-ja.md              |   22 +-
 43 files changed, 323 insertions(+), 1545 deletions(-)
```

**新規追加:**


**削除:**


<details>
<summary>admin-setup-ja.md</summary>

```diff
diff --git a/docs-ja/pages/admin-setup-ja.md b/docs-ja/pages/admin-setup-ja.md
index 0c9936a..ab983f9 100644
--- a/docs-ja/pages/admin-setup-ja.md
+++ b/docs-ja/pages/admin-setup-ja.md
@@ -133,4 +133,5 @@ Team、Enterprise、Claude API、およびクラウドプロバイダープラ
 * [Server-managed settings](/ja/server-managed-settings): Claude 管理コンソールからマネージドポリシーを配信する
 * [Settings reference](/ja/settings): すべての設定キー、ファイルの場所、優先度ルール
-* [Amazon Bedrock](/ja/amazon-bedrock)、[Google Vertex AI](/ja/google-vertex-ai)、[Microsoft Foundry](/ja/microsoft-foundry): プロバイダー固有の展開
+* [Monorepos and large repos](/ja/large-codebases): 大規模リポジトリをデプロイする組織向けのディレクトリごとの設定パターン
+* [Amazon Bedrock](/ja/amazon-bedrock)、[Google Vertex AI](/ja/google-vertex-ai)、[Microsoft Foundry](/ja/microsoft-foundry): プロバイダー固有のデプロイメント
 * [Claude Enterprise Administrator Guide](https://claude.com/resources/tutorials/claude-enterprise-administrator-guide): SSO、SCIM、シート管理、ロールアウトプレイブック
```

</details>

<details>
<summary>agent-view-ja.md</summary>

```diff
diff --git a/docs-ja/pages/agent-view-ja.md b/docs-ja/pages/agent-view-ja.md
index 5d38ff9..0e8451a 100644
--- a/docs-ja/pages/agent-view-ja.md
+++ b/docs-ja/pages/agent-view-ja.md
@@ -59,5 +59,5 @@ Claude が複数の独立したタスクに対して、あなたが毎ステッ
 
   <Step title="アタッチとデタッチ">
-    フル会話が必要な場合は、行で `Enter` または `→` を押してアタッチします。セッションは `claude` を実行した場合と同じようにターミナルを引き継ぎます。空のプロンプトで `←` を押してデタッチし、テーブルに戻ります。
+    フル会話が必要な場合は、行で `Enter` または `→` を押してアタッチします。セッションはターミナルを引き継ぎ、フルインタラクティブな Claude Code セッションになります。空のプロンプトで `←` を押してデタッチし、テーブルに戻ります。
   </Step>
 
@@ -167,8 +167,10 @@ Completed
 ### セッションにアタッチする
 
-選択した行で `Enter` または `→` を押してアタッチします。エージェントビューはフルインタラクティブセッションに置き換えられ、そのディレクトリで `claude` を実行した場合と同じです。アタッチすると、Claude は不在中に何が起こったかの短い要約を投稿します。
+選択した行で `Enter` または `→` を押してアタッチします。エージェントビューはフルインタラクティブセッションに置き換えられます。アタッチすると、Claude は不在中に何が起こったかの短い要約を投稿します。
 
 アタッチ中、セッションは他の Claude Code セッションのように動作します。すべての [コマンド](/ja/commands)、キーボードショートカット、および機能が機能します。
 
+アタッチされたセッションは、`tui` 設定に関係なく、常に [フルスクリーンモード](/ja/fullscreen) でレンダリングされます。バックグラウンドセッションには追加するターミナルスクロールバックがないためです。`PgUp`、`PgDn`、またはマウスホイールでスクロールし、トランスクリプトモードの場合は `Ctrl+O` を押します。ターミナルのネイティブスクロールと tmux コピーモードは現在のビューポートのみを表示します。これはフルスクリーンアプリケーションを実行するときと同じです。
+
 空のプロンプトで `←` を押してデタッチし、エージェントビューに戻ります。ダイアログがフォーカスを持っており、`←` に応答していない場合は、`Ctrl+Z` を押して直ちにデタッチします。
 
```

</details>

<details>
<summary>agents-ja.md</summary>

```diff
diff --git a/docs-ja/pages/agents-ja.md b/docs-ja/pages/agents-ja.md
index f296684..5984b05 100644
--- a/docs-ja/pages/agents-ja.md
+++ b/docs-ja/pages/agents-ja.md
@@ -41,7 +41,7 @@
   * 独立したタスクを引き継いで後で確認する場合：[エージェントビュー](/ja/agent-view)
   * Claude がワーカーのグループを計画、割り当て、監督する場合：[エージェントチーム](/ja/agent-teams)（実験的で、デフォルトでは無効）
-  * スクリプトが Claude のターンバイターン判断の代わりに調整を行う場合：[動的ワークフロー](/ja/workflows)
+  * スクリプトが Claude のターンバイターン判断の代わりに計画を保持する場合：[動的ワークフロー](/ja/workflows)。[ワークフローがサブエージェントとスキルとどのように比較されるか](/ja/workflows#when-to-use-a-workflow)を参照してください
 * **ワーカーが互いに通信する必要があるか？** サブエージェントは結果をそれらを生成した会話に報告し、エージェントビューセッションはあなたにのみ報告します。エージェントチームのチームメイトはタスクリストを共有し、互いに直接メッセージを送信します。
-* **タスクが同じファイルに触れるか？** [ワークツリー](/ja/worktrees) で作業を分離します。サブエージェントと自分で実行するセッションは、それぞれ個別のワークツリーを使用できます。エージェントチームはチームメイトをワークツリーで分離しないため、[作業を分割](/ja/agent-teams#avoid-file-conflicts) して、各チームメイトが異なるファイルセットを所有するようにします。
+* **タスクが同じファイルに触れるか？** [ワークツリー](/ja/worktrees)で作業を分離します。サブエージェントと自分で実行するセッションは、それぞれ個別のワークツリーを使用できます。エージェントチームはチームメイトをワークツリーで分離しないため、[作業を分割](/ja/agent-teams#avoid-file-conflicts)して、各チームメイトが異なるファイルセットを所有するようにします。
 
 ## 実行中の作業を確認する
```

</details>

<details>
<summary>amazon-bedrock-ja.md</summary>

```diff
diff --git a/docs-ja/pages/amazon-bedrock-ja.md b/docs-ja/pages/amazon-bedrock-ja.md
index 2f5b379..90046f9 100644
--- a/docs-ja/pages/amazon-bedrock-ja.md
+++ b/docs-ja/pages/amazon-bedrock-ja.md
@@ -235,8 +235,8 @@ Claude Code で Bedrock を有効にする場合は、以下に注意してく
 これらの環境変数を特定の Bedrock モデル ID に設定します。
 
-`ANTHROPIC_DEFAULT_OPUS_MODEL` なしでは、Bedrock の `opus` エイリアスは Opus 4.6 に解決されます。最新モデルを使用するには、Opus 4.7 ID に設定します。
+`ANTHROPIC_DEFAULT_OPUS_MODEL` なしでは、Bedrock の `opus` エイリアスは Opus 4.6 に解決されます。最新モデルを使用するには、Opus 4.8 ID に設定します。
 
 ```bash theme={null}
-export ANTHROPIC_DEFAULT_OPUS_MODEL='us.anthropic.claude-opus-4-7'
+export ANTHROPIC_DEFAULT_OPUS_MODEL='us.anthropic.claude-opus-4-8'
 export ANTHROPIC_DEFAULT_SONNET_MODEL='us.anthropic.claude-sonnet-4-6'
 export ANTHROPIC_DEFAULT_HAIKU_MODEL='us.anthropic.claude-haiku-4-5-20251001-v1:0'
@@ -357,5 +357,5 @@ Claude Code に必要な権限を持つ IAM ポリシーを作成します。
 ## 1M トークンコンテキストウィンドウ
 
-Claude Opus 4.7、Opus 4.6、および Sonnet 4.6 は、Amazon Bedrock で [1M トークンコンテキストウィンドウ](https://platform.claude.com/docs/en/build-with-claude/context-windows#1m-token-context-window)をサポートしています。Claude Code は、1M モデルバリアントを選択すると、拡張コンテキストウィンドウを自動的に有効にします。
+Claude Opus 4.6 以降および Sonnet 4.6 は、Amazon Bedrock で [1M トークンコンテキストウィンドウ](https://platform.claude.com/docs/ja/build-with-claude/context-windows#1m-token-context-window)をサポートしています。Claude Code は、1M モデルバリアントを選択すると、拡張コンテキストウィンドウを自動的に有効にします。
 
 [セットアップウィザード](#bedrock-でサインイン)は、モデルをピン留めするときに 1M コンテキストオプションを提供します。手動でピン留めされたモデルの代わりに有効にするには、モデル ID に `[1m]` を追加します。詳細については、[Pin models for third-party deployments](/ja/model-config#pin-models-for-third-party-deployments) を参照してください。
```

</details>

<details>
<summary>analytics-ja.md</summary>

```diff
diff --git a/docs-ja/pages/analytics-ja.md b/docs-ja/pages/analytics-ja.md
index ef46769..4c7149d 100644
--- a/docs-ja/pages/analytics-ja.md
+++ b/docs-ja/pages/analytics-ja.md
@@ -9,14 +9,14 @@
 Claude Code は、組織が開発者の使用パターンを理解し、貢献メトリクスを追跡し、Claude Code がエンジニアリング速度にどのような影響を与えるかを測定するのに役立つ分析ダッシュボードを提供します。お客様のプランに応じたダッシュボードにアクセスしてください。
 
-| プラン                           | ダッシュボード URL                                                                | 含まれる内容                                        | 詳細                                               |
-| ----------------------------- | -------------------------------------------------------------------------- | --------------------------------------------- | ------------------------------------------------ |
-| Claude for Teams / Enterprise | [claude.ai/analytics/claude-code](https://claude.ai/analytics/claude-code) | 使用メトリクス、GitHub 統合による貢献メトリクス、リーダーボード、データエクスポート | [詳細](#access-analytics-for-teams-and-enterprise) |
-| API（Claude Console）           | [platform.claude.com/claude-code](https://platform.claude.com/claude-code) | 使用メトリクス、支出追跡、チームインサイト                         | [詳細](#access-analytics-for-api-customers)        |
+| プラン                           | ダッシュボード URL                                                                | 含まれる内容                                        | 詳細                                              |
+| ----------------------------- | -------------------------------------------------------------------------- | --------------------------------------------- | ----------------------------------------------- |
+| Claude for Teams / Enterprise | [claude.ai/analytics/claude-code](https://claude.ai/analytics/claude-code) | 使用メトリクス、GitHub 統合による貢献メトリクス、リーダーボード、データエクスポート | [詳細](#access-analytics-for-team-and-enterprise) |
+| API（Claude Console）           | [platform.claude.com/claude-code](https://platform.claude.com/claude-code) | 使用メトリクス、支出追跡、チームインサイト                         | [詳細](#access-analytics-for-api-customers)       |
 
-## Teams と Enterprise の分析にアクセスする
+## Team と Enterprise の分析にアクセスする
 
 [claude.ai/analytics/claude-code](https://claude.ai/analytics/claude-code) に移動してください。管理者とオーナーがダッシュボードを表示できます。
 
-Teams と Enterprise ダッシュボードには以下が含まれます。
+Team と Enterprise ダッシュボードには以下が含まれます。
 
 * **使用メトリクス**：受け入れられたコード行数、提案受け入れ率、日次アクティブユーザー数とセッション数
@@ -25,8 +25,10 @@ Teams と Enterprise ダッシュボードには以下が含まれます。
 * **データエクスポート**：カスタムレポート用に貢献データを CSV としてダウンロード
 
+ユーザーごとのトークン数とコスト推定については、[OpenTelemetry エクスポート](/ja/monitoring-usage)を構成してください。
+
```

</details>

<details>
<summary>auto-mode-config-ja.md</summary>

```diff
diff --git a/docs-ja/pages/auto-mode-config-ja.md b/docs-ja/pages/auto-mode-config-ja.md
index 5dd6a62..cc485a3 100644
--- a/docs-ja/pages/auto-mode-config-ja.md
+++ b/docs-ja/pages/auto-mode-config-ja.md
@@ -10,5 +10,5 @@
 
 <Note>
-  オートモードは、Anthropic API を通じてすべてのユーザーが利用できます。Bedrock、Vertex、Foundry では利用できません。Claude Code がアカウントでオートモードが利用不可と報告する場合は、[完全な要件](/ja/permission-modes#eliminate-prompts-with-auto-mode)を確認してください。これには、サポートされているモデルと Team および Enterprise プランの管理者有効化も含まれます。
+  オートモードは、Anthropic API を通じてすべてのユーザーが利用できます。Amazon Bedrock、Google Cloud Vertex AI、Microsoft Foundry では、まず [`CLAUDE_CODE_ENABLE_AUTO_MODE`](/ja/permission-modes#enable-auto-mode-on-bedrock-vertex-ai-or-foundry) を[設定](/ja/permission-modes#enable-auto-mode-on-bedrock-vertex-ai-or-foundry)する必要があります。Claude Code がアカウントでオートモードが利用不可と報告する場合は、[完全な要件](/ja/permission-modes#eliminate-prompts-with-auto-mode)を確認してください。これには、サポートされているモデルと Team および Enterprise プランの管理者有効化も含まれます。
 </Note>
 
```

</details>

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index efa9d13..d4dab2e 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,59 @@
 # Changelog
 
+## 2.1.161
+
+- `OTEL_RESOURCE_ATTRIBUTES` values are now included as labels on metric datapoints, so you can slice usage metrics by custom dimensions like team or repo
+- `claude agents` rows now show `done/total` before the detail when work is fanned out; peek shows the longest-running item
+- `/mcp` now collapses claude.ai connectors you've never signed in to behind a "Show unused connectors" row
+- Parallel tool calls: a failed Bash command no longer cancels other calls in the same batch — each tool returns its own result independently
+- Fullscreen mode: clipboard now uses `wl-copy`/`xclip`/`xsel` on Linux when available, copies to both the clipboard and PRIMARY selection for middle-click paste, and the "hold {key} for native selection" hint now shows the correct key per terminal
+- Fixed the `/effort` dialog, workflow animations, and prompt keyword shimmer not honoring the "Reduce motion" setting
+- Fixed `forceLoginOrgUUID`/`forceLoginMethod` managed-settings policies blocking third-party provider sessions (Bedrock, Vertex, Foundry, Mantle) alongside the org pin (regression in 2.1.146)
+- Fixed background subagent output corrupting `claude -p` stdout when using `--output-format text` or `json`
+- Fixed `/usage-credits` starting a re-login for Team and Enterprise admins instead of pointing to the organization's usage settings page
+- Fixed `/autofix-pr` reporting "cannot run on the default branch" when the session is inside a git worktree or another repository
+- Fixed `--resume` picker not showing sessions from the current directory when it isn't a git worktree (e.g., jj workspaces)
+- Fixed Windows hooks that invoke bash explicitly (e.g., `/usr/bin/bash script.sh`) failing with "command not found" or "cannot execute binary file"
+- Fixed OpenTelemetry log events (`user_prompt`, `api_request`, `tool_result`, `tool_decision`) being silently dropped when emitted before telemetry initialization completed
+- Fixed `claude mcp` list/get/add printing secrets to the terminal: `${VAR}` references are no longer expanded, and credential headers and URL secrets are redacted
+- Fixed Workflow agents spawned with `isolation: "worktree"` in background sessions being blocked from editing files inside their own worktree
+- Fixed background sessions dispatched from `claude agents` booting on a stale model from the daemon's environment instead of the model in `settings.json`
+- Fixed a potential crash when rendering Write tool results after resuming a session
+- Fixed completed subagents getting stuck showing as running when an error occurs while finalizing their result
+- Fixed `EADDRINUSE` errors from tools that bind Unix sockets under `$TMPDIR` when `CLAUDE_CODE_TMPDIR` is set to a deep path
+- Improved terminal rendering performance by stabilizing the layout engine's JIT compilation profile
+- Improved rendering performance for large file writes
```

</details>

<details>
<summary>channels-ja.md</summary>

```diff
diff --git a/docs-ja/pages/channels-ja.md b/docs-ja/pages/channels-ja.md
index 77478b3..58acc7a 100644
--- a/docs-ja/pages/channels-ja.md
+++ b/docs-ja/pages/channels-ja.md
@@ -8,5 +8,5 @@
 
 <Note>
-  チャネルは[リサーチプレビュー](#research-preview)段階にあり、Claude Code v2.1.80 以降が必要です。claude.ai ログインが必要です。Console と API キー認証はサポートされていません。Team および Enterprise 組織は[明示的に有効にする](#enterprise-controls)必要があります。
+  チャネルは[リサーチプレビュー](#research-preview)段階にあり、Claude Code v2.1.80 以降が必要です。Anthropic 認証が claude.ai または Console API キーを通じて必要で、Amazon Bedrock、Google Vertex AI、Microsoft Foundry では利用できません。Team および Enterprise 組織は[明示的に有効にする](#enterprise-controls)必要があります。
 </Note>
 
@@ -226,7 +226,7 @@ Fakechat をインストールして有効にすると、ブラウザで入力
 Fakechat デモを試すには、以下が必要です。
 
-* Claude Code が[インストールされ、認証されている](/ja/quickstart#step-1-install-claude-code)（claude.ai アカウント）
+* Claude Code が[インストールされ、認証されている](/ja/quickstart#step-1-install-claude-code)（claude.ai アカウントまたは Claude Console API キー）
 * [Bun](https://bun.sh) がインストールされている。事前構築されたチャネルプラグインは Bun スクリプトです。`bun --version` で確認します。失敗する場合は、[Bun をインストール](https://bun.sh/docs/installation)します。
-* **Team/Enterprise ユーザー**：組織管理者が管理設定で[チャネルを有効にする](#enterprise-controls)必要があります。
+* **Team、Enterprise、または管理 Console 組織**：管理者が[チャネルを有効にする](#enterprise-controls)必要があります。
 
 <Steps>
@@ -268,4 +268,6 @@ Fakechat デモを試すには、以下が必要です。
 Claude がターミナルから離れている間にパーミッションプロンプトにヒットした場合、セッションは応答するまで一時停止します。[パーミッションリレー機能](/ja/channels-reference#relay-permission-prompts)を宣言するチャネルサーバーは、これらのプロンプトをあなたに転送して、リモートで承認または拒否できるようにします。無人使用の場合、[`--dangerously-skip-permissions`](/ja/permission-modes#skip-all-checks-with-bypasspermissions-mode) はプロンプトを完全にバイパスしますが、信頼できる環境でのみ使用してください。
 
+非対話型モードで `-p` でチャネルを実行する場合、複数選択質問や Plan Mode 承認など、ターミナル入力が必要なツールは無効になるため、セッションは入力を待つことで停止することはありません。
+
 ## セキュリティ
 
@@ -281,5 +283,5 @@ Telegram と Discord はペアリングでリストをブートストラップ
 iMessage は異なります。自分自身にテキストを送信するとゲートを自動的にバイパスし、`/imessage:access allow` でハンドルを使用して他の連絡先を追加します。
```

</details>

*...以降省略*

</details>


<details>
<summary>2026-06-02</summary>

**変更ファイル:**

```
 docs-ja/pages/agent-view-ja.md       |  56 +++--
 docs-ja/pages/cli-reference-ja.md    |   1 +
 docs-ja/pages/desktop-ja.md          |   4 +-
 docs-ja/pages/discover-plugins-ja.md |   4 +-
 docs-ja/pages/glossary-ja.md         |   6 +-
 docs-ja/pages/goal-ja.md             |   4 +-
 docs-ja/pages/hooks-guide-ja.md      |   4 +-
 docs-ja/pages/hooks-ja.md            |  96 ++++++-
 docs-ja/pages/large-codebases-en.md  | 471 -----------------------------------
 docs-ja/pages/permission-modes-ja.md |   2 +-
 docs-ja/pages/plugins-ja.md          |  10 +-
 docs-ja/pages/prompt-caching-ja.md   |  34 ++-
 docs-ja/pages/voice-dictation-ja.md  |   6 +-
 docs-ja/pages/workflows-ja.md        |  38 +--
 14 files changed, 202 insertions(+), 534 deletions(-)
```

**新規追加:**


**削除:**


<details>
<summary>agent-view-ja.md</summary>

```diff
diff --git a/docs-ja/pages/agent-view-ja.md b/docs-ja/pages/agent-view-ja.md
index 69b1115..5d38ff9 100644
--- a/docs-ja/pages/agent-view-ja.md
+++ b/docs-ja/pages/agent-view-ja.md
@@ -81,5 +81,5 @@ claude agents --cwd ~/projects/my-app
 これはそのディレクトリの下で開始されたセッションのみを表示します。`~/projects/my-app/.claude/worktrees/` の下の [ワークツリーに移動した](#how-file-edits-are-isolated) セッションは、`~/projects/my-app` に属するものとしてカウントされます。
 
-他のターミナルで開いているインタラクティブセッションは、[バックグラウンドにする](#from-inside-a-session)までは表示されません。[Subagents](/ja/sub-agents) と [teammates](/ja/agent-teams) はセッションが生成しても個別の行としてリストされません。
+他のターミナルで開いているインタラクティブセッションは、[バックグラウンドにする](#from-inside-a-session) までは表示されません。[Subagents](/ja/sub-agents) と [teammates](/ja/agent-teams) はセッションが生成しても個別の行としてリストされません。
 
 ```text theme={null}
@@ -136,5 +136,5 @@ Completed
 各行の 1 行の概要は [Haiku クラスモデル](/ja/model-config) によって生成されるため、行はトランスクリプトを開かずにセッションが何をしているか、何が必要か、または何を生成したかを伝えることができます。セッションがアクティブに作業している間、概要は最大 15 秒ごとに 1 回、および各ターンが終了したときに 1 回更新されます。
 
-各更新は通常のプロバイダーを通じた 1 つの短い Haiku クラスリクエストであり、セッション自体と同じ [データ使用条件](/ja/data-usage) の下で請求および処理されます。
+各更新は通常のプロバイダーを通じた 1 つの短い Haiku クラスリクエストであり、セッション自体と同じ [データ使用条件](/ja/data-usage) の下で請求および処理されます。Bedrock、Vertex AI、Microsoft Foundry、カスタムゲートウェイなどのサードパーティプロバイダーでは、Haiku モデルが設定されていない場合、リクエストはセッションのメインモデルにフォールバックします。これらのプロバイダーでこれらの概要のモデルを選択するには、[`ANTHROPIC_DEFAULT_HAIKU_MODEL`](/ja/model-config#environment-variables) を設定します。
 
 ### プルリクエストステータス
@@ -161,4 +161,6 @@ Completed
 ピークパネルに返信を入力して `Enter` を押すと、そのセッションに送信されます。セッションが複数選択肢の質問をしている場合、ピークパネルはオプションを表示し、数字キーを押して 1 つを選択できます。他のブロックされたセッションの場合は、`Tab` を押して入力に提案された返信を入力し、送信前に編集できます。返信の前に `!` を付けて Bash コマンドを代わりに送信します。
 
+[音声ディクテーション](/ja/voice-dictation) が有効な場合、返信入力がフォーカスされている間、プッシュトゥトークキーを押したままにするか、タップして返信をディクテーションします。これはエージェントビューの下部のディスパッチ入力でも同じように機能します。
+
 `↑` と `↓` を使用してパネルを閉じずに隣接するセッションをピーク表示するか、`→` を使用してアタッチします。
 
@@ -249,4 +251,6 @@ Completed
 | `Shift+Enter`                    | ディスパッチして新しいセッションに直ちにアタッチ                                                                                 |
 
+エージェントビュー自体で実行される少数のコマンドがあります。ディスパッチの代わりに：`/exit` および `/quit` はエージェントビューを閉じ、`/logout` はサインアウトします。その他のすべてのコマンドとスキルは、新しいバックグラウンドセッションにその最初のプロンプトとして送信されます。
+
```

</details>

<details>
<summary>cli-reference-ja.md</summary>

```diff
diff --git a/docs-ja/pages/cli-reference-ja.md b/docs-ja/pages/cli-reference-ja.md
index e9f1326..e48963f 100644
--- a/docs-ja/pages/cli-reference-ja.md
+++ b/docs-ja/pages/cli-reference-ja.md
@@ -29,4 +29,5 @@
 | `claude auto-mode defaults`     | 組み込み [auto mode](/ja/permission-modes#eliminate-prompts-with-auto-mode) 分類器ルールを JSON として出力します。`claude auto-mode config` を使用して、設定が適用された有効な設定を確認してください                                                                                                                                                                                                                                                                                           | `claude auto-mode defaults > rules.json`                    |
 | `claude daemon status`          | バックグラウンドセッション [スーパーバイザー](/ja/agent-view#the-supervisor-process) の状態、バージョン、ソケットディレクトリ、および診断用のワーカー数を出力します。スーパーバイザーが実行されていない場合は 1 で終了します                                                                                                                                                                                                                                                                                                          | `claude daemon status`                                      |
+| `claude daemon stop --any`      | バックグラウンドセッション [スーパーバイザー](/ja/agent-view#the-supervisor-process) とそれがホストするセッションを停止します。`--keep-workers` を渡して、バックグラウンドセッションを実行したままにして、次のスーパーバイザーが再接続できるようにします。`--any` はオンデマンドスーパーバイザーの停止を確認します。これはデフォルトです。これを使用して、[応答しないスーパーバイザー](/ja/agent-view#agent-view-says-the-background-service-did-not-respond) から回復します                                                                                                                                  | `claude daemon stop --any --keep-workers`                   |
 | `claude logs <id>`              | [バックグラウンドセッション](/ja/agent-view#manage-sessions-from-the-shell) からの最近の出力を出力します                                                                                                                                                                                                                                                                                                                                                                  | `claude logs 7c5dcf5d`                                      |
 | `claude mcp`                    | Model Context Protocol（MCP）サーバーを設定                                                                                                                                                                                                                                                                                                                                                                                                             | [Claude Code MCP ドキュメント](/ja/mcp) を参照してください。                |
```

</details>

<details>
<summary>desktop-ja.md</summary>

```diff
diff --git a/docs-ja/pages/desktop-ja.md b/docs-ja/pages/desktop-ja.md
index ecba628..74b9b84 100644
--- a/docs-ja/pages/desktop-ja.md
+++ b/docs-ja/pages/desktop-ja.md
@@ -677,5 +677,7 @@ Desktop と CLI は同じ設定ファイルを読み取るため、セットア
 
 <Note>
-  **MCP サーバー：デスクトップチャットアプリと Claude Code**：Claude Desktop チャットアプリの `claude_desktop_config.json` で設定された MCP サーバーは Claude Code とは別であり、Code タブに表示されません。Claude Code で MCP サーバーを使用するには、`~/.claude.json` またはプロジェクトの `.mcp.json` ファイルで設定します。詳細については、[MCP 設定](/ja/mcp#installing-mcp-servers)を参照してください。
+  **Claude Desktop チャットアプリからの MCP サーバー**：Desktop アプリは `claude_desktop_config.json` から MCP サーバーを Code タブセッションに読み込みます。これは `~/.claude.json` および `.mcp.json` からのサーバーと並行して行われます。`claude_desktop_config.json` で定義されたサーバーは Desktop チャットサーフェスと Code タブの両方で利用可能です。
+
+  スタンドアロン CLI は `claude_desktop_config.json` を読み取りません。macOS と WSL では、`claude mcp add-from-claude-desktop` を実行して、これらのサーバーを `~/.claude.json` にコピーします。[Claude Desktop から MCP サーバーをインポート](/ja/mcp#import-mcp-servers-from-claude-desktop)を参照して、インポートフローとスコープオプションを確認してください。
 </Note>
 
```

</details>

<details>
<summary>discover-plugins-ja.md</summary>

```diff
diff --git a/docs-ja/pages/discover-plugins-ja.md b/docs-ja/pages/discover-plugins-ja.md
index 22daccd..47388c1 100644
--- a/docs-ja/pages/discover-plugins-ja.md
+++ b/docs-ja/pages/discover-plugins-ja.md
@@ -150,5 +150,5 @@ Anthropic は、プラグインシステムで何が可能かを示す例プラ
     * **Errors**: プラグイン読み込みエラーを表示
 
-    **Discover** タブに移動して、追加したばかりのマーケットプレイスからプラグインを確認してください。
+    **Discover** タブに移動して、追加したばかりのマーケットプレイスからプラグインを確認してください。{/* min-version: 2.1.154 */}現在の作業ディレクトリに関連するとマークされたプラグインは、**suggested for this directory** ラベル付きで上部に固定されます。
   </Step>
 
@@ -334,4 +334,6 @@ claude plugin uninstall formatter@your-org --scope project
 Claude Code はすべてのアクティブなプラグインをリロードし、プラグイン、スキル、エージェント、フック、プラグイン MCP サーバー、プラグイン LSP サーバーのカウントを表示します。
 
+リロードには次のリクエストでトークンコストがあります。新しくロードされたコンポーネントは会話に追加されたコンテンツで自身を発表し、既存の履歴はプロンプトキャッシュから読み込まれたままです。MCP サーバーを提供するプラグインは、そのツールが [tool search](/ja/mcp#scale-with-mcp-tool-search) によって遅延されていない場合、より多くのコストがかかります。変更はキャッシュを無効にし、次のリクエストは会話全体を再度読み込みます。詳細については、[プラグインの有効化または無効化](/ja/prompt-caching#enabling-or-disabling-a-plugin) を参照してください。
+
 ## マーケットプレイスを管理する
 
```

</details>

<details>
<summary>glossary-ja.md</summary>

```diff
diff --git a/docs-ja/pages/glossary-ja.md b/docs-ja/pages/glossary-ja.md
index 5fe8ae3..fa01c0b 100644
--- a/docs-ja/pages/glossary-ja.md
+++ b/docs-ja/pages/glossary-ja.md
@@ -83,7 +83,7 @@ Claude Code がプロジェクトスコープの設定を読み取るディレ
 ### CLAUDE.md
 
-Claude のために書く永続的な指示のマークダウンファイル。システムプロンプトの後、ユーザーメッセージとしてすべてのセッションの開始時にロードされます。プロジェクト規約、アーキテクチャノート、「常に X を行う」ルールをここに配置します。CLAUDE.md は [compaction](#compaction) を生き残り、その後ディスクから新しく再読み込みされます。
+Claude のために書く永続的な指示のマークダウンファイル。システムプロンプトの後、ユーザーメッセージとしてすべてのセッションの開始時にロードされます。プロジェクト規約、アーキテクチャノート、「常に X を行う」ルールをここに配置します。プロジェクトルート CLAUDE.md は [compaction](#compaction) を生き残り、その後ディスクから新しく再読み込みされます。
 
-CLAUDE.md は `./CLAUDE.md` または `./.claude/CLAUDE.md` のプロジェクトスコープに、`~/.claude/CLAUDE.md` のユーザースコープに、または組織の [managed policy](#managed-settings) として配置できます。より具体的な場所が優先されます。
+CLAUDE.md は `./CLAUDE.md` または `./.claude/CLAUDE.md` のプロジェクトスコープに、`~/.claude/CLAUDE.md` のユーザースコープに、または組織の [managed policy](#managed-settings) として配置できます。検出されたすべてのファイルは、互いにオーバーライドするのではなく、最も広いスコープから最も具体的なスコープへの順序で、コンテキストに連結されます。
 
 詳細情報: [CLAUDE.md files](/ja/memory#claude-md-files)
@@ -119,5 +119,5 @@ CLAUDE.md は `./CLAUDE.md` または `./.claude/CLAUDE.md` のプロジェク
 ### Effort level
 
-各ターンで Claude が適応的推論思考予算をどの程度使用するかを制御する設定。より高い努力はより多くの思考トークンとより深い推論を意味し、より低い努力はより速く、より安価です。Effort は Opus 4.7、Opus 4.6、Sonnet 4.6 でサポートされています。
+各ターンで Claude が適応的推論思考予算をどの程度使用するかを制御する設定。より高い努力はより多くの思考トークンとより深い推論を意味し、より低い努力はより速く、より安価です。Effort は Opus 4.6 以降、および Sonnet 4.6 でサポートされています。
 
 詳細情報: [Adjust effort level](/ja/model-config#adjust-effort-level)
```

</details>

<details>
<summary>goal-ja.md</summary>

```diff
diff --git a/docs-ja/pages/goal-ja.md b/docs-ja/pages/goal-ja.md
index 08f2780..d930f47 100644
--- a/docs-ja/pages/goal-ja.md
+++ b/docs-ja/pages/goal-ja.md
@@ -22,10 +22,10 @@
 このページでは以下について説明します。
 
-* [自律的なワークフロー アプローチの比較](#compare-to-other-autonomous-workflows)：`/loop`、Stop hook、および自動モード
+* [セッションを実行し続ける方法の比較](#compare-ways-to-keep-a-session-running)：`/loop`、Stop hook、および自動モード
 * [ゴールの設定](#set-a-goal)と[効果的な条件の作成](#write-an-effective-condition)
 * [ステータスの確認](#check-status)、[早期クリア](#clear-a-goal)、および[非対話的な実行](#run-non-interactively)
 * [評価の仕組み](#how-evaluation-works)と[要件](#requirements)を確認
 
-## 他の自律的なワークフロー アプローチとの比較
+## セッションを実行し続ける方法の比較
 
 3 つのアプローチが、プロンプト間で現在のセッションを実行し続けます。次のターンを開始するべき内容に基づいて選択します。
```

</details>

<details>
<summary>hooks-guide-ja.md</summary>

```diff
diff --git a/docs-ja/pages/hooks-guide-ja.md b/docs-ja/pages/hooks-guide-ja.md
index 99b44f6..41acb2d 100644
--- a/docs-ja/pages/hooks-guide-ja.md
+++ b/docs-ja/pages/hooks-guide-ja.md
@@ -3,5 +3,5 @@
 > Use this file to discover all available pages before exploring further.
 
-# hooks でワークフローを自動化する
+# hooks でアクションを自動化する
 
 > Claude Code がファイルを編集したり、タスクを完了したり、入力が必要になったりしたときに、シェルコマンドを自動的に実行します。コードをフォーマットし、通知を送信し、コマンドを検証し、プロジェクトルールを適用します。
@@ -870,5 +870,5 @@ HTTP hooks は、Web サーバー、クラウド関数、または外部サー
 * コマンド hooks は stdout、stderr、および終了コードを通じてのみ通信します。これらは `/` コマンドまたはツール呼び出しをトリガーできません。`additionalContext` を通じて返されたテキストは、Claude が平文として読むシステムリマインダーとして注入されます。HTTP hooks はレスポンスボディを通じて通信します。
 * Hook タイムアウトはタイプによって異なります。`timeout` フィールド（秒単位）で hook ごとにオーバーライドできます。
-  * `command`、`http`、`mcp_tool`：10 分。`UserPromptSubmit` はこれらを 30 秒に短縮します。
+  * `command`、`http`、`mcp_tool`：10 分。`UserPromptSubmit` はこれらを 30 秒に短縮し、`MessageDisplay` はこれらを 10 秒に短縮します。
   * `prompt`：30 秒。
   * `agent`：60 秒。
```

</details>

<details>
<summary>hooks-ja.md</summary>

```diff
diff --git a/docs-ja/pages/hooks-ja.md b/docs-ja/pages/hooks-ja.md
index 92824ae..44a0ef4 100644
--- a/docs-ja/pages/hooks-ja.md
+++ b/docs-ja/pages/hooks-ja.md
@@ -299,5 +299,5 @@ MCP ツールは `mcp__<server>__<tool>` という命名パターンに従いま
 | `type`          | はい  | `"command"`、`"http"`、`"mcp_tool"`、`"prompt"`、または `"agent"`                                                                                                                                                                                                                                                               |
 | `if`            | いいえ | `"Bash(git *)"` または `"Edit(*.ts)"` などの権限ルール構文を使用してこのフックが実行されるタイミングをフィルタリングします。ツール呼び出しがパターンにマッチする場合のみ、フックが生成されます。または Bash コマンドが解析するには複雑すぎる場合。ツール イベントでのみ評価されます。`PreToolUse`、`PostToolUse`、`PostToolUseFailure`、`PermissionRequest`、`PermissionDenied`。他のイベントでは、`if` が設定されたフックは実行されません。[権限ルール](/ja/permissions)と同じ構文を使用します |
-| `timeout`       | いいえ | キャンセルまでの秒数。デフォルト: `command`、`http`、`mcp_tool` は 600、`prompt` は 30、`agent` は 60。[`UserPromptSubmit`](#userpromptsubmit) は `command`、`http`、`mcp_tool` のデフォルトを 30 に低下させます                                                                                                                                                  |
+| `timeout`       | いいえ | キャンセルまでの秒数。デフォルト: `command`、`http`、`mcp_tool` は 600、`prompt` は 30、`agent` は 60。[`UserPromptSubmit`](#userpromptsubmit) は `command`、`http`、`mcp_tool` のデフォルトを 30 に低下させ、[`MessageDisplay`](#messagedisplay) はそれを 10 に低下させます                                                                                                |
 | `statusMessage` | いいえ | フックの実行中に表示されるカスタム スピナー メッセージ                                                                                                                                                                                                                                                                                             |
 | `once`          | いいえ | `true` の場合、セッションごとに 1 回だけ実行してから削除されます。[スキル フロントマター](#hooks-in-skills-and-agents)でのみ尊重されます。設定ファイルとエージェント フロントマターでは無視されます                                                                                                                                                                                                  |
@@ -735,5 +735,5 @@ Claude を完全に停止するには、イベント タイプに関係なく。
 input=$(cat)
 title="Claude Code'
-body=$(jq -r '.message // "Needs your attention"' <<<"$input")
+body=$(jq -r '.message // 'Needs your attention'' <<<"$input")
 seq=$(printf '\033]777;notify;%s;%s\007' "$title" "$body")
 jq -nc --arg seq "$seq" '{terminalSequence: $seq}'
@@ -1151,7 +1151,13 @@ InstructionsLoaded フックは決定制御がありません。命令ロード
 ### MessageDisplay
 
-アシスタント メッセージが画面にストリーミングされている間に実行されます。Claude Code はメッセージを増分で表示します。新しく完了した行のバッチがレンダリング準備ができるたびに、フックはそれらの行で 1 回実行され、Claude Code はフックの置換テキストをその場所にレンダリングします。長いメッセージは複数の呼び出しを生成します。短いメッセージは 1 つだけ生成する可能性があります。これを使用して Claude の応答を画面に表示されるときに再フォーマット、編集、または圧縮します。
+アシスタント メッセージが画面にストリーミングされている間に実行されます。Claude Code はメッセージを増分で表示します。新しく完了した行のバッチがレンダリング準備ができるたびに、フックはそれらの行で 1 回実行され、Claude Code はフックの置換テキストをその場所にレンダリングします。長いメッセージは複数の呼び出しを生成します。短いメッセージは 1 つだけ生成する可能性があります。
 
-MessageDisplay は表示のみです。置換テキストは画面にレンダリングされるものだけを変更します。トランスクリプトと Claude が見るものは元のテキストを保持するため、Claude は置換を見ず、詳細モードは元のテキストを表示します。MessageDisplay はマッチャーをサポートせず、テキストをストリーミングするすべてのアシスタント メッセージに対して発火します。テキストなしのメッセージ（ツール呼び出しのみの応答など）はそれをトリガーしません。
+MessageDisplay を使用して Claude の応答を画面に表示されるときに再フォーマット、編集、または圧縮します。
+
+Claude Code は各バッチをフックが返されるまで保持するため、フックを高速に保ちます。フックが失敗またはタイムアウトした場合、Claude Code は元のテキストを表示します。このイベントのデフォルト タイムアウトは 10 秒です。フックにより多くの時間が必要な場合は、フック エントリで `timeout` フィールドを設定します。
+
+MessageDisplay は表示のみです。置換テキストは画面にレンダリングされるものだけを変更します。トランスクリプトと Claude が見るものは元のテキストを保持するため、Claude は置換を見ず、詳細モードは元のテキストを表示します。フックはアシスタント メッセージ テキストのみを受け取るため、ツール結果とユーザーが入力したテキストは変更されずにレンダリングされます。
```

</details>

<details>
<summary>permission-modes-ja.md</summary>

```diff
diff --git a/docs-ja/pages/permission-modes-ja.md b/docs-ja/pages/permission-modes-ja.md
index 7fd7415..05894b8 100644
--- a/docs-ja/pages/permission-modes-ja.md
+++ b/docs-ja/pages/permission-modes-ja.md
@@ -227,5 +227,5 @@ Claude Code が自動モードを利用不可と報告する場合、これら
     各アクションは固定の決定順序を通過します。最初に一致するステップが勝ちます。
 
-    1. [allow または deny ルール](/ja/permissions#manage-permissions) に一致するアクションは即座に解決されます
+    1. [allow または deny ルール](/ja/permissions#manage-permissions) に一致するアクションは即座に解決されます。ただし、[保護されたパス](#protected-paths) への書き込みは、allow ルールが一致する場合でも分類器にルーティングされます
     2. 読み取り専用アクションと作業ディレクトリ内のファイル編集は自動承認されます。[保護されたパス](#protected-paths) への書き込みを除く
     3. その他すべては分類器に送られます
```

</details>

*...以降省略*

</details>


<details>
<summary>2026-06-01</summary>

**変更ファイル:**

```
 docs-ja/pages/changelog.md | 4 ++++
 1 file changed, 4 insertions(+)
```

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index b2d6dea..efa9d13 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,8 @@
 # Changelog
 
+## 2.1.159
+
+- Internal infrastructure improvements (no user-facing changes)
+
 ## 2.1.158
 
```

</details>

</details>


<details>
<summary>2026-05-31</summary>

**変更ファイル:**

```
 docs-ja/pages/agent-view-ja.md        |  53 ++++++++++----
 docs-ja/pages/changelog.md            |   4 +
 docs-ja/pages/cli-reference-ja.md     |  62 ++++++++--------
 docs-ja/pages/errors-ja.md            |   5 +-
 docs-ja/pages/interactive-mode-ja.md  |  42 +++++------
 docs-ja/pages/keybindings-ja.md       |   8 +-
 docs-ja/pages/mcp-ja.md               |   2 +
 docs-ja/pages/memory-ja.md            |   4 +-
 docs-ja/pages/monitoring-usage-ja.md  |  61 ++++++++++------
 docs-ja/pages/permission-modes-ja.md  |   3 +-
 docs-ja/pages/permissions-ja.md       |   2 +-
 docs-ja/pages/plugins-ja.md           |  12 +++
 docs-ja/pages/plugins-reference-ja.md | 133 +++++++++++++++++++++++++++++++---
 docs-ja/pages/settings-ja.md          |   7 +-
 docs-ja/pages/skills-ja.md            |   8 ++
 docs-ja/pages/sub-agents-ja.md        |   6 +-
 docs-ja/pages/terminal-config-ja.md   |   4 +-
 docs-ja/pages/tools-reference-ja.md   |   2 +-
 docs-ja/pages/workflows-ja.md         |   2 +-
 docs-ja/pages/worktrees-ja.md         |  10 ++-
 20 files changed, 308 insertions(+), 122 deletions(-)
```

<details>
<summary>agent-view-ja.md</summary>

```diff
diff --git a/docs-ja/pages/agent-view-ja.md b/docs-ja/pages/agent-view-ja.md
index 6e99095..69b1115 100644
--- a/docs-ja/pages/agent-view-ja.md
+++ b/docs-ja/pages/agent-view-ja.md
@@ -175,5 +175,5 @@ Completed
 デタッチはバックグラウンドセッションを停止しません。`←`、`Ctrl+Z`、`/exit`、および二重 `Ctrl+C` または二重 `Ctrl+D` はすべてセッションを実行し続けます。セッション内からセッションを終了するには、`/stop` を実行します。
 
-ディスパッチまたはバックグラウンドにしたセッションの後、空のプロンプトで `←` を押すと、アタッチしたセッションだけでなく、任意の Claude Code セッションから機能します。現在のセッションをバックグラウンドにし、そのセッションが事前に選択された状態でエージェントビューを開くため、ターミナルを離れずにセッションを切り替えることができます。行は会話履歴がない新しいセッションからでも作成されるため、`→` はそれに戻ります。その行が唯一の行である場合、エージェントビューはその下にオンボーディングヒントを表示します。このショートカットは `/config` でオフにできます（`leftArrowOpensAgents` 設定）。
+空のプロンプトで `←` を押すと、エージェントビューからアタッチしたセッションだけでなく、任意の Claude Code セッションから機能します。現在のセッションをバックグラウンドにし、そのセッションが事前に選択された状態でエージェントビューを開くため、ターミナルを離れずにセッションを切り替えることができます。行は会話履歴がない新しいセッションからでも作成されるため、`→` はそれに戻ります。その行が唯一の行である場合、エージェントビューはその下にオンボーディングヒントを表示します。このショートカットは `/config` でオフにできます（`leftArrowOpensAgents` 設定）。
 
 ### リストを整理する
@@ -239,12 +239,13 @@ Completed
 プロンプトの一部をプレフィックスまたは言及してセッションの開始方法を制御します：
 
-| 入力                      | 効果                                                                                                       |
-| :---------------------- | :------------------------------------------------------------------------------------------------------- |
-| `<agent-name> <prompt>` | 最初の単語がカスタム [subagent](/ja/sub-agents) 名と一致する場合、その subagent はセッションのメインエージェントとして実行され、frontmatter の設定を使用します |
-| `@<agent-name>`         | プロンプト内の任意の場所でカスタム subagent を言及してメインエージェントとして実行                                                           |
-| `@<repo>`               | エージェントビューを開いたディレクトリの下のリポジトリを言及してセッションをそこで実行                                                              |
-| `/<command>`            | [skills](/ja/skills) および [commands](/ja/commands) をディスパッチプロンプトとして提案                                      |
-| `#<number>` または PR URL  | セッションが既にその PR で作業している場合は、ディスパッチの代わりに選択                                                                   |
-| `Shift+Enter`           | ディスパッチして新しいセッションに直ちにアタッチ                                                                                 |
+| 入力                               | 効果                                                                                                       |
+| :------------------------------- | :------------------------------------------------------------------------------------------------------- |
+| `<agent-name> <prompt>`          | 最初の単語がカスタム [subagent](/ja/sub-agents) 名と一致する場合、その subagent はセッションのメインエージェントとして実行され、frontmatter の設定を使用します |
+| `@<agent-name>`                  | プロンプト内の任意の場所でカスタム subagent を言及してメインエージェントとして実行                                                           |
+| `@<repo>`                        | エージェントビューを開いたディレクトリの下のリポジトリを言及してセッションをそこで実行                                                              |
+| `/<command>`                     | [skills](/ja/skills) および [commands](/ja/commands) をディスパッチプロンプトとして提案                                      |
+| `! <command>`                    | Claude セッションを開始する代わりに、シェルコマンドをバックグラウンドジョブとして実行します。ジョブは行として表示され、アタッチ、監視、デタッチできます                          |
+| `#<number>` または pull request URL | セッションが既にその PR で作業している場合は、ディスパッチの代わりに選択                                                                   |
```

</details>

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index c29830e..b2d6dea 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,8 @@
 # Changelog
 
+## 2.1.158
+
+- Auto mode is now available on Bedrock, Vertex, and Foundry for Opus 4.7 and Opus 4.8. Opt in by setting `CLAUDE_CODE_ENABLE_AUTO_MODE=1`
+
 ## 2.1.157
 
```

</details>

<details>
<summary>cli-reference-ja.md</summary>

```diff
diff --git a/docs-ja/pages/cli-reference-ja.md b/docs-ja/pages/cli-reference-ja.md
index dca521a..e9f1326 100644
--- a/docs-ja/pages/cli-reference-ja.md
+++ b/docs-ja/pages/cli-reference-ja.md
@@ -11,32 +11,32 @@
 これらのコマンドを使用して、セッションを開始し、コンテンツをパイプし、会話を再開し、更新を管理できます。
 
-| コマンド                            | 説明                                                                                                                                                                                                                                                                                                                                                                                                                                   | 例                                                           |
-| :------------------------------ | :----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :---------------------------------------------------------- |
-| `claude`                        | インタラクティブセッションを開始                                                                                                                                                                                                                                                                                                                                                                                                                     | `claude`                                                    |
-| `claude "query"`                | 初期プロンプト付きでインタラクティブセッションを開始                                                                                                                                                                                                                                                                                                                                                                                                           | `claude "explain this project"`                             |
-| `claude -p "query"`             | SDK 経由でクエリを実行してから終了                                                                                                                                                                                                                                                                                                                                                                                                                  | `claude -p "explain this function"`                         |
-| `cat file \| claude -p "query"` | パイプされたコンテンツを処理                                                                                                                                                                                                                                                                                                                                                                                                                       | `cat logs.txt \| claude -p "explain"`                       |
-| `claude -c`                     | 現在のディレクトリで最新の会話を続行                                                                                                                                                                                                                                                                                                                                                                                                                   | `claude -c`                                                 |
-| `claude -c -p "query"`          | SDK 経由で続行                                                                                                                                                                                                                                                                                                                                                                                                                            | `claude -c -p "Check for type errors"`                      |
-| `claude -r "<session>" "query"` | セッション ID または名前でセッションを再開                                                                                                                                                                                                                                                                                                                                                                                                              | `claude -r "auth-refactor" "Finish this PR"`                |
-| `claude update`                 | 最新バージョンに更新                                                                                                                                                                                                                                                                                                                                                                                                                           | `claude update`                                             |
-| `claude install [version]`      | ネイティブバイナリをインストールまたは再インストールします。`2.1.118` のようなバージョン、または `stable` または `latest` を受け入れます。[特定のバージョンをインストール](/ja/setup#install-a-specific-version) を参照してください                                                                                                                                                                                                                                                                                | `claude install stable`                                     |
-| `claude auth login`             | Anthropic アカウントにサインインします。`--email` を使用してメールアドレスを事前入力し、`--sso` を使用して SSO 認証を強制し、`--console` を使用して Claude サブスクリプションの代わりに Anthropic Console で API 使用料金をサインインできます                                                                                                                                                                                                                                                                        | `claude auth login --console`                               |
-| `claude auth logout`            | Anthropic アカウントからログアウト                                                                                                                                                                                                                                                                                                                                                                                                               | `claude auth logout`                                        |
-| `claude auth status`            | 認証ステータスを JSON として表示します。`--text` を使用して人間が読める形式で表示できます。ログイン済みの場合はコード 0 で終了し、ログインしていない場合は 1 で終了します                                                                                                                                                                                                                                                                                                                                      | `claude auth status`                                        |
-| `claude agents`                 | [エージェントビュー](/ja/agent-view) を開いて、並列バックグラウンドセッションを監視およびディスパッチします。`--cwd <path>` を使用して、そのディレクトリの下で開始されたセッションのみを表示するか、`--json` を使用してライブセッションを JSON 配列として出力してスクリプト作成用にします。`--permission-mode`、`--model`、または `--effort` を渡して、[ディスパッチされたセッションのデフォルト](/ja/agent-view#permission-mode-model-and-effort) を設定します。トップレベルの `claude` コマンドと同様に `--settings`、`--add-dir`、`--plugin-dir`、および `--mcp-config` を受け入れます。エージェントビューを開くにはインタラクティブターミナルが必要です | `claude agents --json`                                      |
-| `claude attach <id>`            | このターミナルで [バックグラウンドセッション](/ja/agent-view#manage-sessions-from-the-shell) に接続します                                                                                                                                                                                                                                                                                                                                                       | `claude attach 7c5dcf5d`                                    |
-| `claude auto-mode defaults`     | 組み込み [auto mode](/ja/permission-modes#eliminate-prompts-with-auto-mode) 分類器ルールを JSON として出力します。`claude auto-mode config` を使用して、設定が適用された有効な設定を確認してください                                                                                                                                                                                                                                                                                 | `claude auto-mode defaults > rules.json`                    |
-| `claude daemon status`          | バックグラウンドセッション [スーパーバイザー](/ja/agent-view#the-supervisor-process) の状態、バージョン、ソケットディレクトリ、および診断用のワーカー数を出力します。スーパーバイザーが実行されていない場合は 1 で終了します                                                                                                                                                                                                                                                                                                | `claude daemon status`                                      |
-| `claude logs <id>`              | [バックグラウンドセッション](/ja/agent-view#manage-sessions-from-the-shell) からの最近の出力を出力します                                                                                                                                                                                                                                                                                                                                                        | `claude logs 7c5dcf5d`                                      |
-| `claude mcp`                    | Model Context Protocol（MCP）サーバーを設定                                                                                                                                                                                                                                                                                                                                                                                                   | [Claude Code MCP ドキュメント](/ja/mcp) を参照してください。                |
-| `claude plugin`                 | Claude Code [plugins](/ja/plugins) を管理します。エイリアス：`claude plugins`。サブコマンドについては [plugin reference](/ja/plugins-reference#cli-commands-reference) を参照してください                                                                                                                                                                                                                                                                              | `claude plugin install code-review@claude-plugins-official` |
-| `claude project purge [path]`   | プロジェクトのすべてのローカル Claude Code 状態を削除します：トランスクリプト、タスクリスト、デバッグログ、ファイル編集履歴、プロンプト履歴行、および `~/.claude.json` 内のプロジェクトエントリ。`[path]` を省略して、インタラクティブリストから選択します。フラグ：`--dry-run` でプレビュー、`-y`/`--yes` で確認をスキップ、`-i`/`--interactive` で各項目を確認、`--all` ですべてのプロジェクト。[ローカルデータをクリア](/ja/claude-directory#clear-local-data) を参照してください                                                                                                                       | `claude project purge ~/work/repo --dry-run`                |
-| `claude remote-control`         | [Remote Control](/ja/remote-control) サーバーを開始して、Claude.ai または Claude アプリから Claude Code を制御します。サーバーモード（ローカルインタラクティブセッションなし）で実行されます。[サーバーモードフラグ](/ja/remote-control#start-a-remote-control-session) を参照してください                                                                                                                                                                                                                           | `claude remote-control --name "My Project"`                 |
```

</details>

<details>
<summary>errors-ja.md</summary>

```diff
diff --git a/docs-ja/pages/errors-ja.md b/docs-ja/pages/errors-ja.md
index 96510d9..19be8c5 100644
--- a/docs-ja/pages/errors-ja.md
+++ b/docs-ja/pages/errors-ja.md
@@ -570,5 +570,5 @@ Claude Opus is not available with the Claude Pro plan · Select a different mode
 ### thinking.type.enabled is not supported for this model
 
-Claude Code バージョンが Opus 4.7 の最小値より古いです。CLI は、モデルが受け入れなくなった思考設定を送信しました。
+Claude Code バージョンが Opus 4.7 または Opus 4.8 の最小値より古いです。CLI は、モデルが受け入れなくなった思考設定を送信しました。
 
 ```text theme={null}
@@ -578,5 +578,5 @@ API Error: 400 ... "thinking.type.enabled" is not supported for this model. Use
 **対応方法：**
 
-* `claude update` を実行して v2.1.111 以降にアップグレードしてから、Claude Code を再起動してください
+* `claude update` を実行して Claude Code を再起動してください。Opus 4.7 は v2.1.111 以降が必要です。Opus 4.8 は v2.1.154 以降が必要です
 * アップグレードできない場合は、`/model` を実行して Opus 4.6 または Sonnet を選択してください
 * Agent SDK でこれに遭遇した場合は、[SDK トラブルシューティング](/ja/agent-sdk/quickstart#troubleshooting)を参照してください
@@ -611,4 +611,5 @@ API Error: 400 ... thinking blocks ... cannot be modified
 **対応方法：**
 
+* {/* max-version: 2.1.155 */}Opus 4.7 または Opus 4.8 を使用している場合は、まず `claude update` を実行してください。v2.1.156 より前のバージョンは、通常のツール使用中にこのエラーをトリガーでき、`/rewind` はそれをクリアしません。
 * `/rewind` を実行するか、Esc を 2 回押して、破損したターンの前のチェックポイントに戻り、そこから続行してください。[チェックポイント](/ja/checkpointing)を参照して、チェックポイントがどのように作成および復元されるかを確認してください。
 
```

</details>

<details>
<summary>interactive-mode-ja.md</summary>

```diff
diff --git a/docs-ja/pages/interactive-mode-ja.md b/docs-ja/pages/interactive-mode-ja.md
index fbf44d3..21d766f 100644
--- a/docs-ja/pages/interactive-mode-ja.md
+++ b/docs-ja/pages/interactive-mode-ja.md
@@ -23,24 +23,24 @@
 ### 一般的なコントロール
 
-| ショートカット                                          | 説明                                                                                                                | コンテキスト                                                                                                                                                                                 |
-| :----------------------------------------------- | :---------------------------------------------------------------------------------------------------------------- | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
-| `Ctrl+C`                                         | 割り込み、または入力をクリア                                                                                                    | 実行中の操作を割り込みます。何も実行されていない場合、最初の押下でプロンプト入力をクリアし、2 回目の押下で Claude Code を終了します                                                                                                              |
-| `Ctrl+X Ctrl+K`                                  | このセッション内のすべてのバックグラウンド [サブエージェント](/ja/sub-agents#run-subagents-in-foreground-or-background) を終了します。3 秒以内に 2 回押して確認 | サブエージェント制御                                                                                                                                                                             |
-| `Ctrl+D`                                         | Claude Code セッションを終了                                                                                              | EOF シグナル                                                                                                                                                                               |
-| `Ctrl+G` または `Ctrl+X Ctrl+E`                     | デフォルトテキストエディタで開く                                                                                                  | プロンプトまたはカスタム応答をデフォルトテキストエディタで編集します。`Ctrl+X Ctrl+E` は readline ネイティブバインディングです。`/config` で「外部エディタで最後の応答を表示」をオンにすると、Claude の前の応答を `#` でコメント化されたコンテキストとしてプロンプトの上に追加します。保存時にコメントブロックは削除されます |
-| `Ctrl+L`                                         | 画面を再描画                                                                                                            | 完全なターミナル再描画を強制します。入力と会話履歴は保持されます。ディスプレイが破損したり部分的に空白になった場合に、これを使用して復旧します                                                                                                                |
-| `Ctrl+O`                                         | トランスクリプトビューアを切り替え                                                                                                 | 詳細なツール使用と実行を表示します。また MCP 呼び出しを展開します。デフォルトでは「Slack を 3 回呼び出し」のような 1 行に折りたたまれます                                                                                                          |
-| `Ctrl+R`                                         | コマンド履歴を逆順検索                                                                                                       | 前のコマンドをインタラクティブに検索                                                                                                                                                                     |
-| `Ctrl+V` または `Cmd+V`（iTerm2）または `Alt+V`（Windows） | クリップボードから画像を貼り付け                                                                                                  | カーソルに `[Image #N]` チップを挿入して、プロンプト内で位置的に参照できます                                                                                                                                          |
-| `Ctrl+B`                                         | バックグラウンドで実行中のタスク                                                                                                  | bash コマンドとエージェントをバックグラウンドで実行します。Tmux ユーザーは 2 回押す                                                                                                                                       |
-| `Ctrl+T`                                         | タスクリストを切り替え                                                                                                       | ターミナルステータス領域の [タスクリスト](#task-list) を表示または非表示                                                                                                                                           |
-| `Left/Right 矢印`                                  | ダイアログタブを循環                                                                                                        | 権限ダイアログとメニューのタブ間を移動                                                                                                                                                                    |
-| `Up/Down 矢印` または `Ctrl+P`/`Ctrl+N`               | カーソルを移動またはコマンド履歴を移動                                                                                               | 複数行入力では、最初にカーソルをプロンプト内で移動します。カーソルが既に上端または下端にある場合、もう一度押すとコマンド履歴を移動します                                                                                                                   |
-| `Esc`                                            | Claude を割り込み                                                                                                      | 現在の応答またはツール呼び出しを途中で停止して、リダイレクトできます。Claude はこれまでの作業を保持します                                                                                                                               |
-| `Esc` + `Esc`                                    | 入力ドラフトをクリア、または巻き戻し                                                                                                | プロンプト入力にテキストが含まれている場合、ダブル `Esc` でクリアし、ドラフトを履歴に保存して `Up` で呼び出せます。入力が空の場合、ダブル `Esc` で [巻き戻しメニュー](/ja/checkpointing) を開き、前の時点からコードと会話を復元または要約できます                                         |
-| `Shift+Tab` または `Alt+M`（一部の設定）                   | 権限モードを切り替え                                                                                                        | `default`、`acceptEdits`、`plan`、および `auto` や `bypassPermissions` などの有効にしたモード間を循環します。[権限モード](/ja/permission-modes) を参照してください。                                                            |
-| `Option+P`（macOS）または `Alt+P`（Windows/Linux）      | モデルを切り替え                                                                                                          | プロンプトをクリアせずにモデルを切り替え                                                                                                                                                                   |
-| `Option+T`（macOS）または `Alt+T`（Windows/Linux）      | 拡張思考を切り替え                                                                                                         | 拡張思考モードを有効または無効にします。{/* min-version: 2.1.132 */}v2.1.132 以降、このショートカットは macOS で Option を Meta として設定しなくても機能します                                                                           |
-| `Option+O`（macOS）または `Alt+O`（Windows/Linux）      | 高速モードを切り替え                                                                                                        | [高速モード](/ja/fast-mode) を有効または無効にします                                                                                                                                                    |
+| ショートカット                                                  | 説明                                                                                                                | コンテキスト                                                                                                                                                                                 |
+| :------------------------------------------------------- | :---------------------------------------------------------------------------------------------------------------- | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
+| `Ctrl+C`                                                 | 割り込み、または入力をクリア                                                                                                    | 実行中の操作を割り込みます。何も実行されていない場合、最初の押下でプロンプト入力をクリアし、2 回目の押下で Claude Code を終了します                                                                                                              |
```

</details>

<details>
<summary>keybindings-ja.md</summary>

```diff
diff --git a/docs-ja/pages/keybindings-ja.md b/docs-ja/pages/keybindings-ja.md
index c5e304b..3fc87cf 100644
--- a/docs-ja/pages/keybindings-ja.md
+++ b/docs-ja/pages/keybindings-ja.md
@@ -115,5 +115,5 @@ Claude Code はカスタマイズ可能なキーボードショートカット
 | `chat:externalEditor` | Ctrl+G、Ctrl+X Ctrl+E     | 外部エディタで開く                                                                                                 |
 | `chat:stash`          | Ctrl+S                   | 現在のプロンプトを保存                                                                                               |
-| `chat:imagePaste`     | Ctrl+V（Windows では Alt+V） | 画像を貼り付け                                                                                                   |
+| `chat:imagePaste`     | Ctrl+V（Windows では Alt+V） | クリップボードから画像を貼り付けます。WSL では、両方のショートカットがデフォルトでバインドされています                                                     |
 
 \*VT モードなし（Node \<24.2.0/\<22.17.0、Bun \<1.2.23）の Windows では、デフォルトは Meta+M です。
@@ -150,7 +150,7 @@ Claude Code はカスタマイズ可能なキーボードショートカット
 権限ダイアログの `Confirmation` コンテキストで利用可能なアクション：
 
-| アクション                    | デフォルト    | 説明                                                                             |
-| :----------------------- | :------- | :----------------------------------------------------------------------------- |
-| `permission:toggleDebug` | （アンバインド） | 権限デバッグ情報を切り替え。Ctrl+D の以前のデフォルトは v2.1.146 で削除されました。これは `app:exit` をシャドウしていたためです |
+| アクション                    | デフォルト    | 説明                                                                               |
+| :----------------------- | :------- | :------------------------------------------------------------------------------- |
+| `permission:toggleDebug` | （アンバインド） | 権限デバッグ情報を切り替えます。Ctrl+D の以前のデフォルトは v2.1.146 で削除されました。これは `app:exit` をシャドウしていたためです |
 
 ### トランスクリプトアクション
```

</details>

<details>
<summary>mcp-ja.md</summary>

```diff
diff --git a/docs-ja/pages/mcp-ja.md b/docs-ja/pages/mcp-ja.md
index 5137c41..9d13b27 100644
--- a/docs-ja/pages/mcp-ja.md
+++ b/docs-ja/pages/mcp-ja.md
@@ -481,4 +481,6 @@ orders テーブルのスキーマを表示してください
 Claude Code は、サーバーが `401 Unauthorized` または `403 Forbidden` で応答するときに、リモートサーバーが認証を必要とするとマークします。どちらのステータスコードでも、サーバーは `/mcp` でフラグが立てられ、OAuth フローを完了できます。認可サーバーを指す `WWW-Authenticate` ヘッダーを返すカスタムサーバーは、他のリモートサーバーと同じ自動検出を取得します。
 
+`headers.Authorization` をサーバー用に設定し、サーバーがそのヘッダーを拒否する場合、Claude Code は OAuth にフォールバックするのではなく、接続が失敗したと報告します。トークンが MCP エンドポイント用に有効であることを確認するか、OAuth フローを使用するためにヘッダーを削除してください。
+
 <Steps>
   <Step title="認証が必要なサーバーを追加する">
```

</details>

*...以降省略*

</details>


<!-- UPDATE_LOG_END -->
