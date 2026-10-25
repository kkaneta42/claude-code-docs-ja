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

<details>
<summary>agents-ja.md</summary>

```diff
diff --git a/docs-ja/pages/agents-ja.md b/docs-ja/pages/agents-ja.md
index 7858ede..1c1cdc6 100644
--- a/docs-ja/pages/agents-ja.md
+++ b/docs-ja/pages/agents-ja.md
@@ -29,13 +29,11 @@ Claude Code には、複数のタスクを同時に処理する 5 つの方法
 * [バックグラウンド bash コマンド](/docs/ja/interactive-mode#background-bash-commands) は、会話をブロックすることなく 1 つのシェルコマンドを実行します。エージェントをスポーンしません。
 * [フォークされたサブエージェント](/docs/ja/sub-agents#fork-the-current-conversation) は、新規に開始する代わりに完全な会話コンテキストを継承するサブエージェントです。これはサブエージェントをスポーンする方法であり、別のサーフェスではありません。`/subtask` で開始します。Claude は [フォークモード](/docs/ja/sub-agents#turn-fork-mode-on-or-off) がオンの場合、自身でもスポーンします。完全なセッションを、それと並行して実行する新しい [バックグラウンドセッション](/docs/ja/agent-view#from-inside-a-session) にコピーするには、`/fork` を使用します。[エージェントビューがオフ](/docs/ja/agent-view#turn-off-agent-view) の場合、フォークされたサブエージェントコマンドは `/fork` に変わり、`/subtask` は利用できません。
-* [ルーチン](/docs/ja/routines) は、マシン上で並列に実行するのではなく、クラウドでスケジュールに従ってセッションを実行します。
+* [クラウドスケジュールタスク](/docs/ja/routines) は、マシン上で並列に実行するのではなく、クラウドでスケジュールに従ってセッションを実行します。
 
-<Note>
-  複数のセッションまたはサブエージェントを同時に実行すると、トークン使用量が増加します。使用量とレート制限の詳細については、[コスト](/docs/ja/costs) を参照してください。
-</Note>
+> [!NOTE]
+>
+> 複数のセッションまたはサブエージェントを同時に実行すると、トークン使用量が増加します。使用量とレート制限の詳細については、[コスト](/docs/ja/costs) を参照してください。
 
-<h2 id="choose-an-approach">
-  アプローチを選択する
-</h2>
+## アプローチを選択する
 
 適切なアプローチは、誰が作業を調整するか、ワーカーが通信する必要があるかどうか、および同じファイルを編集するかどうかによって異なります。
@@ -49,7 +47,5 @@ Claude Code には、複数のタスクを同時に処理する 5 つの方法
 * **タスクが同じファイルに触れるか？** [ワークツリー](/docs/ja/worktrees)で作業を分離します。サブエージェントと自分で実行するセッションは、それぞれ個別のワークツリーを使用できます。エージェントチームはチームメイトをワークツリーで分離しないため、[作業を分割](/docs/ja/agent-teams#avoid-file-conflicts)して、各チームメイトが異なるファイルセットを所有するようにします。
 
-<h2 id="check-on-running-work">
-  実行中の作業を確認する
-</h2>
+## 実行中の作業を確認する
```

</details>

*...以降省略*

</details>


<details>
<summary>2026-10-20</summary>

**変更ファイル:**

```
 docs-ja/pages/agent-teams-ja.md                    |   2 +-
 docs-ja/pages/agent-view-ja.md                     |  12 +-
 docs-ja/pages/amazon-bedrock-ja.md                 |   4 +-
 docs-ja/pages/artifacts-ja.md                      |   2 +-
 docs-ja/pages/auto-mode-config-ja.md               |   4 +-
 docs-ja/pages/changelog.md                         |  79 +++
 docs-ja/pages/chrome-ja.md                         |   6 +-
 docs-ja/pages/claude-apps-gateway-config-ja.md     | 425 +++++++++--------
 docs-ja/pages/claude-apps-gateway-ja.md            |   2 +-
 docs-ja/pages/claude-directory-ja.md               |   9 +-
 docs-ja/pages/cli-reference-ja.md                  |   2 +-
 docs-ja/pages/code-review-setup-ja.md              |   2 +-
 docs-ja/pages/code-review-troubleshooting-ja.md    |   2 +-
 docs-ja/pages/commands-ja.md                       |  10 +-
 docs-ja/pages/corporate-launcher-ja.md             |  30 +-
 docs-ja/pages/desktop-ios-simulator-ja.md          |   4 +-
 docs-ja/pages/desktop-ja.md                        | 402 +++++++++++++---
 docs-ja/pages/desktop-quickstart-ja.md             |  22 +-
 docs-ja/pages/desktop-scheduled-tasks-ja.md        |   2 +-
 docs-ja/pages/desktop-wsl-ja.md                    |  22 +-
 docs-ja/pages/env-vars-ja.md                       |  18 +-
 docs-ja/pages/errors-ja.md                         |  37 +-
 docs-ja/pages/fast-mode-ja.md                      |   2 +-
 docs-ja/pages/fullscreen-ja.md                     |   8 +-
 docs-ja/pages/headless-ja.md                       |   9 +-
 docs-ja/pages/hooks-guide-ja.md                    |  45 +-
 docs-ja/pages/hooks-ja.md                          |  58 +--
 docs-ja/pages/interactive-mode-ja.md               |  10 +-
 docs-ja/pages/keybindings-ja.md                    |   9 +-
 docs-ja/pages/llm-gateway-connect-ja.md            |   2 +-
 docs-ja/pages/mcp-ja.md                            |  10 +-
 docs-ja/pages/memory-ja.md                         |   6 +-
 docs-ja/pages/model-config-ja.md                   |   3 +-
 docs-ja/pages/monitoring-usage-ja.md               | 109 +++--
 docs-ja/pages/network-config-ja.md                 |   2 +-
 docs-ja/pages/permission-modes-ja.md               | 115 ++++-
 docs-ja/pages/permissions-ja.md                    | 328 ++++++-------
 docs-ja/pages/sandbox-environments-ja.md           |  12 +-
 docs-ja/pages/security-guidance-ja.md              |   2 +-
 .../pages/self-hosted-environments-deploy-ja.md    |  11 +-
 docs-ja/pages/server-managed-settings-ja.md        |   4 +-
 docs-ja/pages/sessions-ja.md                       |   7 +-
 docs-ja/pages/settings-reference-ja.md             | 527 +++++++++++----------
 docs-ja/pages/statusline-ja.md                     |   4 +-
 docs-ja/pages/sub-agents-ja.md                     |  88 ++--
 docs-ja/pages/terminal-config-ja.md                |   2 +-
 docs-ja/pages/tools-reference-ja.md                |  60 +--
 docs-ja/pages/troubleshooting-ja.md                |   1 +
 docs-ja/pages/vs-code-ja.md                        |  34 +-
 docs-ja/pages/workflows-ja.md                      |   6 +-
 docs-ja/pages/worktrees-ja.md                      |   9 +-
 51 files changed, 1596 insertions(+), 985 deletions(-)
```

<details>
<summary>agent-teams-ja.md</summary>

```diff
diff --git a/docs-ja/pages/agent-teams-ja.md b/docs-ja/pages/agent-teams-ja.md
index 9f49b2e..d8d8fc6 100644
--- a/docs-ja/pages/agent-teams-ja.md
+++ b/docs-ja/pages/agent-teams-ja.md
@@ -558,5 +558,5 @@ Agent teams は実験的な機能です。現在の制限事項は以下の通
 * **セッションごとに 1 つのチーム**: セッションは正確に 1 つのチームを持ち、そのセッションにスコープされています。追加の名前付きチームを作成したり、セッション間でチームを共有したりすることはできません。
 * **ネストされたチーム非対応**: teammates は独自の teammates をスポーンできません。lead のみがチームを管理できます。
-* **インプロセス teammates からのバックグラウンド subagents 非対応**: インプロセス teammate 自身の subagents はフォアグラウンドで実行されます。これは teammate のバックグラウンド作業が lead のプロセスより長く存続できないためです。Claude Code は、teammate が `background: true` を設定する定義を持つ subagent をスポーンする場合、エラーを返します。teammate の `run_in_background: true` リクエストも失敗し、[Claude Code がフォアグラウンドまたはバックグラウンドを選択する方法](/docs/ja/sub-agents#run-subagents-in-foreground-or-background)で説明されているようにエラーが発生するか、フォアグラウンドで静かに実行されます。メイン会話から起動された Subagents は[バックグラウンドデフォルト](/docs/ja/sub-agents#run-subagents-in-foreground-or-background)に従います。
+* **インプロセスのチームメイトからのバックグラウンドサブエージェント非対応**: インプロセスのチームメイト自身のサブエージェントはフォアグラウンドで実行されます。これはチームメイトのバックグラウンド作業がチームリーダーのプロセスより長く存続できないためです。Claude Code は、チームメイトが `background: true` を設定する定義を持つサブエージェントをスポーンする場合、エラーを返します。チームメイトの `run_in_background: true` リクエストも失敗し、エラーが発生するか、フォアグラウンドで静かに実行されます。メイン会話から起動されたサブエージェントは[バックグラウンドのデフォルト](/docs/ja/sub-agents#run-subagents-in-foreground-or-background)に従います。
 * **Lead は固定**: メインセッションはその存続期間中、lead です。teammate を lead に昇格させたり、リーダーシップを譲渡したりすることはできません。
 * **権限はスポーン時に設定**: teammates は[権限](#permissions)の下で説明されている権限モードで開始します。スポーン後に個別の teammate の権限モードを変更できますが、スポーン時に teammate ごとの権限モードを設定することはできません。
```

</details>

<details>
<summary>agent-view-ja.md</summary>

```diff
diff --git a/docs-ja/pages/agent-view-ja.md b/docs-ja/pages/agent-view-ja.md
index 6edc82b..64f64e3 100644
--- a/docs-ja/pages/agent-view-ja.md
+++ b/docs-ja/pages/agent-view-ja.md
@@ -480,5 +480,5 @@ Claude Code v2.1.212 以降でセッションを戻すには、ディスパッ
 フォーク後、2 つの会話は独立しています。コピーが行ったことが自動的に元の会話に入ることはありません。ただし、[クロスセッションメッセージング](/docs/ja/cross-session-messaging) が有効なセッションでは、どちらのセッションの Claude も明示的にもう一方にメッセージを送信できます。
 
-セッションのコピーには Claude Code v2.1.212 以降が必要です。v2.1.161 から v2.1.211 では、`/fork` は代わりに [フォークされたサブエージェント](/docs/ja/sub-agents#fork-the-current-conversation) を開始します。これは現在の `/subtask` です。[エージェントビューがオフになっている](#turn-off-agent-view) 場合、`/fork` はフォークされたサブエージェントの動作を維持し、`/subtask` は利用できません。
+[エージェントビューがオフになっている](#turn-off-agent-view) 場合、`/fork` はセッションをコピーする代わりに [フォークされたサブエージェント](/docs/ja/sub-agents#fork-the-current-conversation) を開始します。
 
 `/fork open a draft pull request with the work so far` のようにプロンプトを渡すと、コピーはすぐにその作業を開始します。プロンプトがない場合、コピーは最初の指示を待ちます。`claude agents` でその行を選択して `Space` を押して指示を送信するか、`claude attach <id>` を実行します。待機中、選択された行には `space to send it a prompt` が表示されます。
@@ -956,5 +956,13 @@ Claude Code は、エージェントビューに表示されているすべて
 * **自動アーティファクト返信**：Claude が[アーティファクトのコメントに自動で返信している](/docs/ja/artifacts#let-claude-reply-to-comments-on-its-own)場合があります。これらの返信はバックグラウンドセッションで続行され、ダイアログはそのことを表示します。
 
-`/tasks` を実行してすべての実行中のものを確認し、確認してバックグラウンド化するか、`Stay` を選択して作業が完了するまで待機します。[バックグラウンド化するときに転送されるもの](#what-carries-over-when-you-background)を参照して、どのタスク種が転送され、どのタスク種が Claude Code によって停止されるかを確認してください。
+`/tasks` を実行してすべての実行中のものを確認し、確認してバックグラウンド化するか、`Stay` を選択して作業が完了するまで待機します。[バックグラウンドに移動するときに引き継がれるもの](#what-carries-over-when-you-background)を参照して、どのタスク種が引き継がれ、どのタスク種が Claude Code によって停止されるかを確認してください。
+
+<h3 id="carried-into-this-session-and-not-resumed">
+  会話にバックグラウンドエージェントが `was carried into this session and not resumed` と表示される
+</h3>
+
+この通知は、このセッションで実行されていないバックグラウンドの[サブエージェント](/docs/ja/sub-agents)を示しています。
+
+Claude はこの通知を確認して自動的に返信するため、プロンプトを入力する必要はありません。Claude の返信を読んだ後もそのサブエージェントの作業が必要な場合は、Claude に依頼してください。
 
 <h3 id="prompt-rejected-as-too-short">
```

</details>

<details>
<summary>amazon-bedrock-ja.md</summary>

```diff
diff --git a/docs-ja/pages/amazon-bedrock-ja.md b/docs-ja/pages/amazon-bedrock-ja.md
index e8b0218..1b65a46 100644
--- a/docs-ja/pages/amazon-bedrock-ja.md
+++ b/docs-ja/pages/amazon-bedrock-ja.md
@@ -183,5 +183,5 @@ export AWS_PROFILE=your-profile-name
 ```
 
-Claude Code は、プロファイルの `sso_region` で指定された IAM Identity Center リージョンからロール認証情報をリクエストします。これは Amazon Bedrock を実行するリージョンと一致する必要はありません。v2.1.207 では、Amazon Bedrock リージョンが `sso_region` をオーバーライドしていたため、IAM Identity Center インスタンスが別のリージョンにあるプロファイルは `Session token not found or invalid` エラーで認証に失敗しました。
+Claude Code は、プロファイルの `sso_region` で指定された IAM Identity Center リージョンからロール認証情報をリクエストします。これは Amazon Bedrock を実行するリージョンと一致する必要はありません。
 
 <h4 id="use-aws-management-console-credentials">
@@ -445,5 +445,5 @@ Claude Code が Amazon Bedrock で設定されて起動する場合、使用予
 セッションが実行されているモデルへのアカウントアクセスが失われた場合（例えば、管理者が Amazon Bedrock アカウントでそれを無効化した場合）、Claude Code は各リクエストが失敗する代わりにセッションを別のモデルに切り替え、`Switched to <fallback> because <model> is not available` を表示します。スタートアップフォールバックと同じモデルを試します。同じティアの以前のバージョンを最初に試し、Opus セッションで Opus バージョンが利用できない場合、デフォルト Sonnet モデルを試します。
 
-切り替えは、ピン留めしていないティアにのみ適用されます。これはスタートアップフォールバックと同じ条件です。選択した特定のバージョン、または[アプリケーション推論プロファイル ARN](#map-each-model-version-to-an-inference-profile)でセッションを実行している場合、そのモデルを保持し、フォールバックモデルチェーンがないため、リクエストは失敗します。[自動モード](/docs/ja/permission-modes#enable-auto-mode-on-bedrock-agent-platform-or-foundry)では、Claude Code は Amazon Bedrock で自動モードがサポートするモデルにのみ切り替えます。それらのモデルも利用できない場合、リクエストは[AWS 認証失敗](/docs/ja/errors#aws-authentication-failed)で失敗し、モデルを有効にするためのヒントが表示されます。
+切り替えは、ピン留めしていないティアにのみ適用されます。これはスタートアップフォールバックと同じ条件です。選択した特定のバージョン、または[アプリケーション推論プロファイル ARN](#map-each-model-version-to-an-inference-profile)でセッションを実行している場合、そのモデルを保持し、フォールバックモデルチェーンがないため、リクエストは失敗します。[auto モード](/docs/ja/permission-modes#enable-auto-mode-on-bedrock-agent-platform-or-foundry)では、Claude Code は Amazon Bedrock で auto モードがサポートするモデルにのみ切り替えます。それらのモデルも利用できない場合、リクエストは[AWS 認証失敗](/docs/ja/errors#aws-authentication-failed)で失敗し、モデルを有効にするためのヒントが表示されます。
 
 設定した[フォールバックモデルチェーン](/docs/ja/model-config#fallback-model-chains)はティア切り替えを置き換えます。これらの拒否では Claude Code は設定したフォールバックに切り替えます。拒否されたリクエストが切り替わるのではなく失敗するようにするには、[`CLAUDE_CODE_DISABLE_MODEL_ACCESS_FALLBACK=1`](/docs/ja/env-vars)を設定してください。設定したフォールバックチェーンはこれらの拒否で切り替わります。すべての拒否されたリクエストが失敗するようにしたい場合は、チェーンも削除してください。
```

</details>

<details>
<summary>artifacts-ja.md</summary>

```diff
diff --git a/docs-ja/pages/artifacts-ja.md b/docs-ja/pages/artifacts-ja.md
index 39acf52..9388f2f 100644
--- a/docs-ja/pages/artifacts-ja.md
+++ b/docs-ja/pages/artifacts-ja.md
@@ -106,5 +106,5 @@ https://claude.ai/code/artifact/5fbea6f3-... を本日の数値で更新しま
 </h2>
 
-Claude Code で `/artifacts` を実行すると、所有しているアーティファクトと共有されているアーティファクトが一覧表示されます。現在のセッションのアーティファクトは **This session** の下に最初に表示されます。Claude Code v2.1.208 以降が必要です。
+Claude Code で `/artifacts` を実行すると、所有しているアーティファクトと共有されているアーティファクトが一覧表示されます。現在のセッションのアーティファクトは **This session** の下に最初に表示されます。
 
 アーティファクトを選択し、次のいずれかのキーを押します。
```

</details>

<details>
<summary>auto-mode-config-ja.md</summary>

```diff
diff --git a/docs-ja/pages/auto-mode-config-ja.md b/docs-ja/pages/auto-mode-config-ja.md
index 539c6cd..5ff8e31 100644
--- a/docs-ja/pages/auto-mode-config-ja.md
+++ b/docs-ja/pages/auto-mode-config-ja.md
@@ -322,5 +322,5 @@ claude auto-mode defaults
 ```
 
-`jq` にパイプしなくても 1 つのルールの完全な文言を読むには、`--label` にルールのラベルの開始部分を渡します。例えば `claude auto-mode defaults --label 'Git Destructive'` のようにします。マッチングは各ルールのラベルに対する大文字小文字を区別しないプレフィックスであり、マッチしないセクションは空のリストとして出力されます。Claude Code v2.1.208 以降が必要です。
+`jq` にパイプしなくても 1 つのルールの完全な文言を読むには、`--label` にルールのラベルの開始部分を渡します。例えば `claude auto-mode defaults --label 'Git Destructive'` のようにします。マッチングは各ルールのラベルに対する大文字小文字を区別しないプレフィックスであり、マッチしないセクションは空のリストとして出力されます。
 
 分類器が実際に使用する設定を JSON として出力します。設定が指定されている場合はその設定を、そうでない場合はデフォルトを適用します：
@@ -360,5 +360,5 @@ claude auto-mode critique
 カスタムルールを作成した場合、`claude auto-mode critique` はそれらをレビューし、曖昧、冗長、または偽陽性を引き起こす可能性のあるエントリにフラグを立てます。
 
-カスタマイズを破棄して組み込みデフォルトに戻すには、reset サブコマンドを実行します。Claude Code v2.1.212 以降が必要であり、ユーザー設定ファイルから `autoMode` セクションを削除します：
+カスタマイズを破棄して組み込みデフォルトに戻すには、reset サブコマンドを実行します。このサブコマンドはユーザー設定ファイルから `autoMode` セクションを削除します：
 
 ```bash theme={null}
```

</details>

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index 1da79e6..850c499 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,83 @@
 # Changelog
 
+## 2.1.304
+
+- Added a transcript line when a plugin that runs first skips one of your mod's hooks, naming the event and the plugin
+- Added `decider: "person"` to a mod's `tool.check` answer: only the permission dialog or a host's callback can approve the ask, and it is refused with the mod's reason where nobody can be asked
+- Added `e.isReadOnly` to a mod's `tool.check` event, set when the tool call is read-only
+- Added `/auto-mode-setup`: a guided setup that reads your project and recent sessions to teach auto mode about your environment, now also available on Bedrock, Vertex, Foundry, Claude apps gateway and telemetry-disabled sessions
+- Added `/claude-api managed-agents-secure`, which compares a Managed Agents agent's settings with Anthropic's published security guide, without changing anything
+- Added the names of the tools called earlier to the compaction summary in the transcript view (Ctrl+O)
+- Added a warning on Pro and Max plans when resuming an inactive conversation would use a noticeable share of your 5-hour usage limit: resume anyway, or start a new conversation and Claude can look up the previous one if you refer to it
+- Fixed the organization policy not refreshing until the hourly check after approving an `ANTHROPIC_API_KEY` at startup or switching "Use custom API key" in `/config`
+- Fixed sandboxed commands failing to start on Linux when a `sandbox.filesystem.denyRead` glob contains brackets that are not a character class, such as a `[user-id]` route folder
+- Fixed `rm -r` of a mounted drive or a folder at its top level (`/Volumes`, `/media`, WSL's `/mnt/c`) not getting the safety prompt that `rm -rf /Applications` gets
+- Fixed `CLAUDE_CODE_TRANSCRIPT_LOCAL_GC` dropping messages from the saved transcript when the disk filled up while the file was being trimmed
+- Fixed a plugin keeping a headless run going past `--max-turns`, Stop, or ended input by spawning subagents or re-running a finished one
+- Fixed a failed mod reload removing the tools and commands of the version that stays loaded, and its messages being wrong or silent about whether the previous version is still loaded
+- Fixed a click on a mod's button being lost when buttons with the same label and no `key` were redrawn unchanged
+- Fixed mod sharing in the built-in `plugin-authoring` skill stopping at the secret scan on machines with managed settings and on Team and Enterprise plans
+- Fixed scheduled Cowork cloud sessions waiting five minutes again for each subagent whose WebFetch needed a URL approval that nobody was there to give
+- Fixed Write results and rejected edits showing a file outside the working directory as `../../…`; they now show `~/…` or the full path
+- Fixed a claude.ai Directory plugin's skills not running as commands when picked from the "/" menu in Cowork cloud sessions
+- Fixed Remote Control permanently withholding a desktop conversation's history when a different account was signed in to the terminal
+- Fixed Remote Control failing to start from Claude Desktop when DISABLE_TELEMETRY or DO_NOT_TRACK is set on a paid plan
+- Fixed model switches, messages and interrupts waiting behind a context usage check in SDK and desktop sessions
```

</details>

<details>
<summary>chrome-ja.md</summary>

```diff
diff --git a/docs-ja/pages/chrome-ja.md b/docs-ja/pages/chrome-ja.md
index ab6190b..8026dda 100644
--- a/docs-ja/pages/chrome-ja.md
+++ b/docs-ja/pages/chrome-ja.md
@@ -114,5 +114,5 @@ VS Code については、[VS Code でのブラウザ自動化](/docs/ja/vs-code
 この設定がオンで Claude Code v2.1.287 以降を使用している場合、各 VS Code セッションは開始時にブラウザに接続するため、`@browser` と入力する前から Claude がブラウザを使用できます。それより前のバージョン、または設定がオフの場合、VS Code セッションは `@browser` と入力したときに接続します。
 
-Chrome が実行されていない場合でも、Claude Code は通常どおり起動します。v2.1.211 より前では、Chrome 統合が有効で Chrome が実行されていない場合に、起動が停止することがありました。
+Chrome が実行されていない場合でも、Claude Code は通常どおり起動します。
 
 <Note>
@@ -193,5 +193,5 @@ Claude はローカルファイルを読み取り、Web インターフェース
 </h3>
 
-Claude は、マシン上のファイルをページ上のアップロードフィールドに添付できます。Claude Code がファイルを読み取ってその内容をブラウザに送信するため、アップロードはローカルセッションとリモートセッションの両方で機能します。Claude Code v2.1.211 以降が必要です。
+Claude は、マシン上のファイルをページ上のアップロードフィールドに添付できます。Claude Code がファイルを読み取ってその内容をブラウザに送信するため、アップロードはローカルセッションとリモートセッションの両方で機能します。
 
 この例では、ログファイルをフォームに添付します。
@@ -272,5 +272,5 @@ Take a screenshot of the checkout page and save it to disk
 ```
 
-Claude は画像をディスクに保存し、ファイルパスを報告します。v2.1.211 より前では、スクリーンショットツールの `save_to_disk` オプションはファイルを書き込みませんでした。
+Claude は画像をディスクに保存し、ファイルパスを報告します。
 
 <h2 id="troubleshooting">
```

</details>

<details>
<summary>claude-apps-gateway-config-ja.md</summary>

```diff
diff --git a/docs-ja/pages/claude-apps-gateway-config-ja.md b/docs-ja/pages/claude-apps-gateway-config-ja.md
index 4abfec4..3294c16 100644
--- a/docs-ja/pages/claude-apps-gateway-config-ja.md
+++ b/docs-ja/pages/claude-apps-gateway-config-ja.md
@@ -57,13 +57,13 @@ Claude apps gateway デプロイメントは、慣例的に `gateway.yaml` と
 </h3>
 
-`listen` ブロックは、ゲートウェイがサービスを提供する場所を制御します。バインドアドレスとポート、外部から見えるオリジン、およびオプションの TLS 終了を指定します。
+`listen` ブロックは、ゲートウェイがどこでサービスを提供するかを制御します。バインドアドレスとポート、外部から見えるオリジン、およびオプションの TLS 終端を設定します。
 
 | フィールド | 必須 | 説明 |
 | - | - | - |
-| `host` | いいえ | バインドアドレス。デフォルト `0.0.0.0`。 |
-| `port` | いいえ | バインドポート。デフォルト `8080`。 |
-| `public_url` | `host` がループバックでない場合は必須 | 外部から見える `https://` オリジン。IdP の `redirect_uri` と検出メタデータを構築するために使用されます。`host` がループバックアドレスでない場合は常に必須です。TLS が ALB、Ingress、Cloud Run などのプロキシで終了するか、`tls` を通じてゲートウェイ自体で終了するかに関わらず必須です。ゲートウェイは `X-Forwarded-*` ヘッダーから独自のオリジンを導出することはありません。これらはクライアントがなりすまし可能です。これなしではブート失敗します。以下の `trusted_proxies` はクライアント IP 解決のみを制御します。また、[テレメトリ](#telemetry)を有効にするためにも必須です。ゲートウェイはこの URL からクライアントにプッシュする OTLP エンドポイントを構築するためです。 |
-| `tls.cert` / `tls.key` | いいえ | ゲートウェイが TLS を自身で終了する場合の PEM パス |
-| `trusted_proxies` | いいえ | ゲートウェイの前にあるロードバランサーの CIDR または IP。設定されている場合、ゲートウェイはこれらのピアからのみ `X-Forwarded-For` を信頼し、IP ごとのレート制限と監査のために実際のクライアント IP を記録します。nginx の `set_real_ip_from` と同等です。`X-Forwarded-For` エントリが `ipv4:port` または `[ipv6]:port` として書かれている場合（一部のロードバランサーがそうするように）、ポートを削除して読み込まれます。ポートが付加されたブラケットなしの IPv6 アドレスは、異なるアドレスとして読み込まれるか、まったく読み込まれない可能性があるため、そのフォームを書き込むプロキシのポートオプションをオフにしてください。 |
+| `host` | いいえ | バインドアドレス。デフォルトは `0.0.0.0`。 |
+| `port` | いいえ | バインドポート。デフォルトは `8080`。 |
+| `public_url` | `host` がループバックでない場合 | 外部から見える `https://` オリジンで、IdP の `redirect_uri` とディスカバリメタデータの構築に使用されます。`host` がループバックアドレスでない場合は常に必須です。これは、TLS が ALB、Ingress、Cloud Run などのプロキシで終端される場合も、`tls` を通じてゲートウェイ自体で終端される場合も同様です。ゲートウェイは自身のオリジンを `X-Forwarded-*` ヘッダーから導出することがないためです。これらのヘッダーはクライアントが偽装できます。これがないと起動に失敗します。下記の `trusted_proxies` はクライアント IP の解決のみを制御します。また、ゲートウェイはクライアントにプッシュする OTLP エンドポイントをこの URL から構築するため、[テレメトリ](#telemetry)を有効にする場合にも必須です。 |
+| `tls.cert` / `tls.key` | いいえ | ゲートウェイ自体が TLS を終端する場合の PEM パス |
+| `trusted_proxies` | いいえ | ゲートウェイの前段にあるロードバランサーの CIDR または IP。設定すると、ゲートウェイはこれらのピアからの `X-Forwarded-For` のみを信頼し、IP ごとのレート制限と監査のために実際のクライアント IP を記録します。nginx の `set_real_ip_from` に相当します。一部のロードバランサーが行うように `ipv4:port` または `[ipv6]:port` の形式で書かれた `X-Forwarded-For` エントリは、ポートを除いて読み取られます。角括弧なしでポートが付加された IPv6 アドレスは、別のアドレスとして読み取られるか、まったく読み取られない可能性があるため、その形式で書き込むプロキシではポートオプションをオフにしてください。 |
 
 <h3 id="oidc">
@@ -71,32 +71,32 @@ Claude apps gateway デプロイメントは、慣例的に `gateway.yaml` と
 </h3>
 
-`oidc` ブロックはゲートウェイをアイデンティティプロバイダーに接続し、誰がサインインできるかを決定します。発行者と OAuth クライアントに名前を付け、メールとグループを含むクレームをマップし、メールドメインまたはグループによるサインインを制限します。
+`oidc` ブロックは、ゲートウェイを ID プロバイダーに接続し、誰がサインインできるかを決定します。発行者と OAuth クライアントを指定し、メールアドレスとグループを伝えるクレームをマッピングし、メールドメインまたはグループによってサインインを制限します。
 
```

</details>

*...以降省略*

</details>


<details>
<summary>2026-10-19</summary>

**変更ファイル:**

```
 docs-ja/pages/changelog.md | 4 ++++
 1 file changed, 4 insertions(+)
```

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index 490ea6e..1da79e6 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,8 @@
 # Changelog
 
+## 2.1.303
+
+- Bug fixes and reliability improvements
+
 ## 2.1.302
 
```

</details>

</details>


<details>
<summary>2026-10-18</summary>

**変更ファイル:**

```
 docs-ja/pages/agent-view-ja.md       |  4 +--
 docs-ja/pages/env-vars-ja.md         |  2 +-
 docs-ja/pages/errors-ja.md           |  4 ++-
 docs-ja/pages/hooks-guide-ja.md      | 29 ++++++++++-----
 docs-ja/pages/hooks-ja.md            | 69 +++++++++++++++++++++++++++---------
 docs-ja/pages/monitoring-usage-ja.md |  2 +-
 docs-ja/pages/network-config-ja.md   | 38 +++++++++++---------
 docs-ja/pages/permission-modes-ja.md |  9 +++--
 docs-ja/pages/permissions-ja.md      | 22 ++++++++++--
 docs-ja/pages/sandboxing-ja.md       | 14 ++++++++
 docs-ja/pages/sub-agents-ja.md       | 22 +++++++++---
 11 files changed, 159 insertions(+), 56 deletions(-)
```

<details>
<summary>agent-view-ja.md</summary>

```diff
diff --git a/docs-ja/pages/agent-view-ja.md b/docs-ja/pages/agent-view-ja.md
index 4990e66..6edc82b 100644
--- a/docs-ja/pages/agent-view-ja.md
+++ b/docs-ja/pages/agent-view-ja.md
@@ -739,5 +739,5 @@ Claude Code は、転送したゲートウェイをそのセッションの実
 
 * **`/bg` または `←` でバックグラウンドに移動した場合**: Claude Code はセッションの権限モードを維持するため、`acceptEdits` や `auto` に切り替えていたセッションは、デタッチ後もそのモードのままです
-* **`←` で開いたエージェントビューからディスパッチした場合**: 対象自身の設定が優先され、他に何も設定されていない場合は移動元のセッションの権限モードが適用されます
+* **`←` で開いたエージェントビューからディスパッチした場合**: Claude Code は新しいセッションの権限モードを、まず対象ディレクトリの設定から、次に移動元のセッションから取得します
 * **シェルで開始した `claude agents` から、または `claude --bg` でディスパッチした場合**: [ディスパッチのデフォルト](#dispatch-defaults) を指定して開いたエージェントビューからディスパッチした場合を除き、新しいセッションはそのディレクトリで新しい `claude` セッションを開始した場合と同じように開始されます。順序は [セッションがどの権限モードで開始されるか](/docs/ja/permission-modes#which-mode-a-session-starts-in) に記載されています
 
@@ -747,5 +747,5 @@ Claude Code は、転送したゲートウェイをそのセッションの実
    * `auto` と `bypassPermissions` は、[管理設定、`--settings` ファイル、または `~/.claude/settings.json` からのみ有効になります](/docs/ja/settings-reference#permissions-defaultmode)。
    * Claude Code は、プロジェクトの `.claude/settings.json` または `.claude/settings.local.json` の `defaultMode` が、移動元のセッションのモードより許容度の高いモードを選択している場合、それを拒否します。
-2. 移動元のセッションの権限モード
+2. 移動元のセッションの権限モード。そのセッションが `bypassPermissions` モードだった場合、新しいセッションは代わりに Manual モードで開始され、`Bypass permissions was requested at launch and ignored` という通知が表示されることがあります。これは、バイパスの免責事項への同意が `.claude/settings.local.json` または `--settings` ファイルにのみ記録されている場合に発生します。Manual モードのまま続行するか、[その同意を `~/.claude/settings.json` に追加してください](/docs/ja/permission-modes#bypass-permissions-acceptance)。
 
 Claude Code がある取得元のモードを許容度が高すぎるとして拒否した場合、リストの次の取得元で決まります。たとえば、plan モードのセッションから、チェックインされた設定で `acceptEdits` を要求するディレクトリにディスパッチした場合、新しいセッションは plan モードで開始されます。その `defaultMode` を `~/.claude/settings.json` に移すと、移動元のセッションの権限モードに関係なく適用されます。
```

</details>

<details>
<summary>env-vars-ja.md</summary>

```diff
diff --git a/docs-ja/pages/env-vars-ja.md b/docs-ja/pages/env-vars-ja.md
index 3daf8ff..5c866d7 100644
--- a/docs-ja/pages/env-vars-ja.md
+++ b/docs-ja/pages/env-vars-ja.md
@@ -197,5 +197,5 @@ Claude Code はスタートアップ時にシェル環境変数を読み込む
 | `ANTHROPIC_WORKSPACE_ID` | [ワークロードアイデンティティフェデレーション](https://platform.claude.com/docs/en/manage-claude/workload-identity-federation)のワークスペース ID。フェデレーションルールのスコープが複数のワークスペースにまたがる場合に設定し、トークン交換でどのワークスペースを対象にするかを指定します |
 | `API_FORCE_IDLE_TIMEOUT` | バイトが届かない場合にストリーミングのモデルレスポンスを中止する、5 分間のボディアイドルタイムアウトを上書きします。低速な[ゲートウェイ](/docs/ja/llm-gateway)やローカルモデルがチャンク間で 5 分以上停止する場合などにタイムアウトをオフにするには `0` を、すべてのプロバイダーでオンのままにするには `1` を設定します。設定されていない場合、タイムアウトは Anthropic API への直接接続、[Claude Platform on AWS](/docs/ja/claude-platform-on-aws)、`CLAUDE_ENABLE_BYTE_WATCHDOG_BEDROCK=1` を設定した Amazon Bedrock 以外のプロバイダーで有効です。[ストリームウォッチドッグ](/docs/ja/network-config#streaming-idle-watchdogs)はこれとは独立して動作し、ここで `0` を設定した場合でも、長時間の無応答の停止を中止します |
-| `API_TIMEOUT_MS` | API リクエストのタイムアウト（ミリ秒）（デフォルト：600000、つまり 10 分。最大：2147483647）。低速なネットワークでリクエストがタイムアウトする場合や、プロキシ経由でルーティングする場合に値を増やします。最大値を超える値は基盤となるタイマーをオーバーフローさせ、リクエストが即座に失敗する原因になります |
+| `API_TIMEOUT_MS` | API リクエストのタイムアウト（ミリ秒）（デフォルト：600000、つまり 10 分。最大：2147483647）。ストリーミングリクエストは、この時間内にレスポンスヘッダーを受信する必要があります。低速なネットワークでリクエストがタイムアウトする場合や、プロキシ経由でルーティングする場合は、この値を増やしてください |
 | `AWS_BEARER_TOKEN_BEDROCK` | 認証用の Amazon Bedrock API キー（[Amazon Bedrock API キー](https://aws.amazon.com/blogs/machine-learning/accelerate-ai-development-with-amazon-bedrock-api-keys/)を参照） |
 | `BASH_DEFAULT_TIMEOUT_MS` | フォアグラウンドの Bash または PowerShell ツールコマンドのデフォルトタイムアウト（ミリ秒）（デフォルト：120000、つまり 2 分）。[バックグラウンドコマンドのデフォルトの時間制限](/docs/ja/tools-reference#time-limit-for-background-commands)を超える値を設定すると、無人セッションではそのデフォルトが置き換えられます。バックグラウンドの時間制限には Claude Code v2.1.285 以降が必要です |
```

</details>

<details>
<summary>errors-ja.md</summary>

```diff
diff --git a/docs-ja/pages/errors-ja.md b/docs-ja/pages/errors-ja.md
index 550cd17..7036958 100644
--- a/docs-ja/pages/errors-ja.md
+++ b/docs-ja/pages/errors-ja.md
@@ -347,4 +347,5 @@
 | `This conversation is already open in another running Claude session` | [バックグラウンドセッションエラー](#this-session-is-running-in-another-terminal) |
 | `This session's saved conversation is no longer on disk` | [バックグラウンドセッションエラー](#this-sessions-saved-conversation-is-no-longer-on-disk) |
+| `Bypass permissions was requested at launch and ignored` | [bypassPermissions モードですべてのチェックをスキップする](/docs/ja/permission-modes#bypass-permissions-acceptance) |
 | `kept <id> — its worktree is still at <path>` | [バックグラウンドセッションエラー](#worktree-has-commits-that-are-not-pushed-anywhere) |
 | `kept <id> — <n> unpushed commits on <branch>` | [バックグラウンドセッションエラー](#worktree-has-commits-that-are-not-pushed-anywhere) |
@@ -419,5 +420,5 @@ Claude Code は次の障害を再試行します。
 * リクエストの途中でコンピューターがスリープ状態になったことで切断されたと Claude Code が検出した接続。Claude Code はこれを上記のルールに従い切断された接続として扱います。再試行ラベルが具体的な理由を示すようになると `Connection lost while your computer was asleep` と表示され、Claude が思考を終えた後、テキストやツール呼び出しの前にターンが終了した場合、メッセージは `Your computer went to sleep before a response was produced` となります。
 * 停止した応答ストリーム。レスポンスヘッダーは届いたものの Claude の応答がまったく届いていない場合、または Claude が思考を終えたもののテキストやツール呼び出しを開始していない場合です。Claude Code は停止した接続を中断し、最大 1 回だけリクエストを再度ストリーミングします。Claude が思考を終えた後、テキストやツール呼び出しの前に応答が 2 回目に停止した場合、Claude Code は `The response stalled before a response was produced` でターンを終了します。
-* [ファーストバイトの期限が適用される](/docs/ja/network-config#streaming-idle-watchdogs)接続で、API がレスポンスヘッダーを返さないストリーミングリクエスト。Claude Code は期限の時点でそれを中断し、再試行回数の範囲内で、モデルリクエストごとに最大 1 回だけ再送信します。その試行にも応答がない場合は、[No response from API](#no-response-from-api) でターンを終了します。その他の接続では、リクエストは `API_TIMEOUT_MS` まで待機します。`CLAUDE_CODE_RETRY_WATCHDOG` を設定している場合、1 回の再試行という上限は適用されません。
+* [ファーストバイトの期限が適用される](/docs/ja/network-config#streaming-idle-watchdogs)接続で、API がレスポンスヘッダーを返さないストリーミングリクエスト。Claude Code は期限の時点でそれを中断し、再試行回数の範囲内で、モデルリクエストごとに最大 1 回だけ再送信します。その試行にも応答がない場合は、[No response from API](#no-response-from-api) でターンを終了します。`CLAUDE_CODE_RETRY_WATCHDOG` を設定している場合、1 回の再試行という上限は適用されません。
 * Claude が思考を終えるか、テキストやツール呼び出しを開始する前に、API の出力コンテンツフィルターによって停止されたストリーミングレスポンス。Claude Code は再試行回数の範囲内でリクエストを 1 回再送信し、フィルターが 2 回目の応答も停止した場合は [Output blocked by content filtering policy](#output-blocked-by-content-filtering-policy) を表示します。
 * 一時的な 429 スロットリング。ただし、ゲートウェイの支出上限による `429` はスロットリングではないため含まれません。[Spend limit reached](#spend-limit-reached) を参照してください。
@@ -4553,4 +4554,5 @@ Agent 'code-reviewer' would be spawned with zero tools — refusing. Its tools l
 * エラーが指定する各エントリを [サブエージェントが利用可能なツール](/docs/ja/sub-agents#available-tools) に対して修正します
 * セッションが持たないツールのエントリを削除します。例えば、接続されていないサーバーからの MCP ツール
+* エントリが接続済みの MCP サーバーを指定している場合は、エントリを、そのサーバーの [ツール名](/docs/ja/permissions#mcp) に綴られているサーバー名（例えば `mcp__reports__v2__get_totals` の `reports__v2`）と比較します。そのサーバーには、`mcp__reports__v2__*`、つまり `mcp__` の後に名前全体と `__*` を続けたものを記述します。`reports` という名前のサーバーを指す短い `mcp__reports` では、サブエージェントは `reports__v2` のツールを 1 つも取得しません
 * [バックグラウンドサブエージェントが削除する](/docs/ja/sub-agents#available-tools) ツール（例えば `CronCreate`）の場合、エントリを削除します。ツールを保持するには、[フォークモードをオフにして](/docs/ja/sub-agents#turn-fork-mode-on-or-off) Claude にサブエージェントをフォアグラウンドで実行するよう依頼します
 * `tools` フィールドを削除して、サブエージェントに [サブエージェントが利用可能なすべてのツール](/docs/ja/sub-agents#available-tools) を与えます
```

</details>

<details>
<summary>hooks-guide-ja.md</summary>

```diff
diff --git a/docs-ja/pages/hooks-guide-ja.md b/docs-ja/pages/hooks-guide-ja.md
index 063aef6..7613c2e 100644
--- a/docs-ja/pages/hooks-guide-ja.md
+++ b/docs-ja/pages/hooks-guide-ja.md
@@ -625,5 +625,5 @@ if echo "$COMMAND" | grep -q "drop table"; then
 fi
 
-exit 0  # exit 0 = 決定なし。通常の許可フローが適用されます
+exit 0  # exit 0 = 決定なし。通常の権限フローが適用されます
 ```
 
@@ -634,8 +634,8 @@ exit 0  # exit 0 = 決定なし。通常の許可フローが適用されます
   * `UserPromptSubmit`、`UserPromptExpansion`、`SessionStart`、および `PostModelSwitch` hooks の場合、Claude Code は stdout を [プレーンテキストとして扱い](/docs/ja/hooks#exit-code-0) Claude のコンテキストに追加します。
 * **終了 2**：Claude Code はアクションをブロックします。stderr に理由を書き込みます。それがどこに着地するかはイベントによって異なります：一部のイベントはそれを Claude にフィードバックとして供給するため、調整できます。他のイベントはそれをユーザーに表示し、`ConfigChange` や `Elicitation` などのいくつかはメッセージを表示しません。一部のイベントはブロックできません：`SessionStart` などの場合、終了 2 は stderr をユーザーに表示し、実行は続行されます。[イベントごとの終了コード 2 の動作](/docs/ja/hooks#exit-code-2-behavior-per-event) で完全なリストを参照してください。
-* **その他の終了コード**：ほとんどのイベントでは、結果は hook が stdout に出力したものによって異なります：
-  * スキーマ検証に合格した解析済みオブジェクト：Claude Code は終了コードを無視し、JSON だけが結果を決定し、hook はエラーとして報告されません。`WorktreeCreate` が任意の非ゼロ終了で失敗するなどの例外は、リファレンスの [終了コード出力](/docs/ja/hooks#exit-code-output) セクションにリストされています。
-  * スキーマ検証に失敗した解析済みオブジェクト、または Claude Code が [JSON として解析しようとする](/docs/ja/hooks#exit-code-0) が有効な JSON ではない stdout：ブロックされないエラー。通知は検証またはパースメッセージを含みます。
-  * Claude Code が [プレーンテキストとして扱う](/docs/ja/hooks#exit-code-0) stdout、または空の stdout：アクションはブロックされないエラーとして進行します。トランスクリプトは `<hook name> hook error` 通知を表示し、その後 stderr の最初の行が `Failed with non-blocking status code:` で始まります。完全な stderr をキャプチャするには、`claude --debug` で [デバッグログ](/docs/ja/hooks#debug-hooks) を有効にするか、セッション中に `/debug` を実行してください。
+* **その他の終了コード**：ほとんどのイベントでは、アクションは [ブロックしないエラー](/docs/ja/hooks#exit-code-output) として続行されます。ただし、そのフックが [失敗時にアクションをブロックする](/docs/ja/hooks#block-the-action-when-a-hook-fails) ものである場合や、その JSON 出力が検証に合格した場合は除きます：
+  * スキーマ検証に合格した解析済みオブジェクト：Claude Code は終了コードを無視し、JSON だけが結果を決定し、フックはエラーとして報告されません。`WorktreeCreate` がゼロ以外の終了で失敗するなどのイベントごとの例外は、リファレンスの [終了コード出力](/docs/ja/hooks#exit-code-output) セクションに記載されています。
+  * スキーマ検証に失敗した解析済みオブジェクト、または Claude Code が [JSON として解析しようとする](/docs/ja/hooks#exit-code-0) ものの有効な JSON ではない stdout：ブロックしないエラーになります。通知には検証またはパースのメッセージが含まれます。
+  * Claude Code が [プレーンテキストとして扱う](/docs/ja/hooks#exit-code-0) stdout、または空の stdout：アクションはブロックしないエラーとして続行されます。トランスクリプトには `<hook name> hook error` 通知が表示され、続いて `Failed with non-blocking status code:` を先頭に付けた stderr の最初の行が表示されます。stderr 全体をキャプチャするには、`claude --debug` を使用するか、セッション中に `/debug` を実行して [デバッグログ](/docs/ja/hooks#debug-hooks) を有効にしてください。
 
 <h4 id="structured-json-output">
@@ -665,5 +665,11 @@ exit 0  # exit 0 = 決定なし。通常の許可フローが適用されます
 `PreToolUse` では、Claude Code は各 `permissionDecision` 値を次のように処理します：
 
-* `"allow"`：対話的な権限プロンプトをスキップします。拒否ルールと確認ルール（エンタープライズの管理 deny リストを含む）は引き続き適用されます。また、[ネットワークパス](/docs/ja/permissions#network-paths) からの読み取り、[`requiresUserInteraction`](/docs/ja/mcp#require-approval-for-a-specific-tool) とマークされた MCP ツール、およびその設定が Claude Code に届くセッションで [組織が `ask` に設定した](/docs/ja/mcp#organization-controls-on-connector-tools) コネクタツールに対するプロンプトも引き続き表示されます
+* `"allow"`：対話的な権限プロンプトをスキップします。拒否ルールと確認ルール（エンタープライズの管理 deny リストを含む）は引き続き適用され、次に対するプロンプトも引き続き表示されます：
+
```

</details>

<details>
<summary>hooks-ja.md</summary>

```diff
diff --git a/docs-ja/pages/hooks-ja.md b/docs-ja/pages/hooks-ja.md
index f1f4009..cccb394 100644
--- a/docs-ja/pages/hooks-ja.md
+++ b/docs-ja/pages/hooks-ja.md
@@ -477,5 +477,5 @@ Bash 入力がどのコマンドを実行するかを Claude Code が判断で
 | `asyncRewake` | いいえ | `true` の場合、バックグラウンドで実行され、終了コード 2 で Claude を起動します。フックの stderr、または stderr が空の場合は stdout が [システムリマインダー](/docs/ja/glossary#system-reminder)として Claude に表示されるため、Claude は長時間実行されるバックグラウンドの失敗に対応できます |
 | `shell` | いいえ | このフックに使用するシェル。`"bash"` または `"powershell"` を受け入れます。デフォルトは `"bash"`、または Git Bash がインストールされていない場合は Windows で `"powershell"`。`"powershell"` を設定すると、Windows 上で PowerShell 経由でコマンドが実行されます。フックは PowerShell を直接生成するため、`CLAUDE_CODE_USE_POWERSHELL_TOOL` は不要です。`args` が設定されている場合は無視されます |
-| `onFailure` | いいえ | フックが失敗したときにアクションがどうなるか。`"continue"`（デフォルト）または `"block"`。[フックが失敗したときにアクションをブロックする](#block-the-action-when-a-hook-fails)を参照してください。Claude Code v2.1.295 以降が必要です |
+| `onFailure` | いいえ | フックが失敗したときに、フックをトリガーしたアクションを続行するかどうか。`"continue"` または `"block"`。`"block"` の場合と、このフィールドを未設定のままにした場合については、[フックが失敗したときにアクションをブロックする](#block-the-action-when-a-hook-fails)を参照してください。Claude Code v2.1.295 以降が必要です |
 
 <a id="exec-form-and-shell-form" />
@@ -830,11 +830,11 @@ macOS と Linux では、コマンド フックは制御ターミナルのない
 * **成功**: フックが 0 で終了します。Claude Code はフックが出力した [JSON 出力](#json-output)フィールドを適用し、それらのフィールドがアクションをブロックまたは拒否しない限り、アクションは進行します。例外については[バックグラウンド プロセスを開始するフック](#hooks-that-start-a-background-process)を参照してください。
 * **ブロッキング エラー**: フックが 2 で終了します。[ブロック可能なイベント](#exit-code-2-behavior-per-event)では、Claude Code はアクションを停止します。
-* **非ブロッキング エラー**: フックがその他のコードで終了するか、起動しない、無効な JSON を出力するなど、その他の方法で失敗します。アクションは進行し、`PreToolUse` などのイベントではトランスクリプトに `<hook name> hook error` 通知が表示されます。失敗したフックでアクションをブロックしたい場合は、[`onFailure: "block"`](#block-the-action-when-a-hook-fails) を設定してください。
+* **非ブロッキング エラー**: フックがその他のコードで終了するか、起動しない、無効な JSON を出力するなど、その他の方法で失敗します。アクションは進行します。ただし、`onFailure` を `"block"` に設定したフックなど、[失敗時にアクションをブロックするフック](#block-the-action-when-a-hook-fails)は例外です。`PreToolUse` などのイベントでは、トランスクリプトに `<hook name> hook error` 通知が表示されます。
 
-フックが stdout に出力する内容によって結果が変わることがあります。例えば、`PreToolUse` フックが 1 で終了しても、検証に合格する JSON を出力した場合、実行は成功となり、JSON フィールドが何が起こるかを決定します。`PreToolUse` などのイベントでフックの結果を確認するには、stdout に出力した内容を最初の列で、終了コードを上部の行で照合してください。
+フックが stdout に出力する内容によって結果が変わることがあります。例えば、`PreToolUse` フックが 1 で終了しても、検証に合格する JSON を出力した場合、その JSON によって何が起こるかが決まることがあります。`PreToolUse` などのイベントでフックの結果を確認するには、stdout に出力した内容を最初の列で、終了コードを上部の行で照合してください。
 
 | stdout | 終了 0 | 終了 2 | その他の終了コード |
 | :- | :- | :- | :- |
-| [スキーマ検証](#json-output)に合格する JSON オブジェクト | 成功。フィールドが適用されます | ブロッキング エラー。Claude Code はフィールドを引き続き読み取りますが、それらでブロックを上書きすることはできません | 成功。Claude Code は終了コードを無視し、フィールドのみが結果を決定します。[`onFailure: "block"`](#block-the-action-when-a-hook-fails) を設定している場合、これは失敗としてカウントされます |
+| [スキーマ検証](#json-output)に合格する JSON オブジェクト | 成功。フィールドが適用されます | ブロッキング エラー。Claude Code はフィールドを引き続き読み取りますが、それらでブロックを上書きすることはできません | 成功。Claude Code は終了コードを無視し、フィールドのみが結果を決定します。[失敗時にアクションをブロックするフック](#block-the-action-when-a-hook-fails)の場合は、代わりに失敗としてカウントされます |
 | [解析できない](#exit-code-0)、またはスキーマ検証に失敗する JSON | 非ブロッキング エラー。通知には解析または検証のメッセージが含まれます | ブロッキング エラー。stderr が理由になります | 非ブロッキング エラー。通知には解析または検証のメッセージが含まれます |
 | [プレーン テキスト](#exit-code-0)、または何もなし | 成功 | ブロッキング エラー。stderr が理由になります | 非ブロッキング エラー。通知には stderr の最初の行が含まれます |
@@ -865,5 +865,5 @@ macOS と Linux では、コマンド フックは制御ターミナルのない
 * **`{` で始まり `}` で終わるが有効な JSON ではないその他の出力**: 解析失敗になります。
 
-Claude Code が stdout を JSON として解析しようとして失敗した場合、または解析されたオブジェクトが[スキーマ検証](#json-output)に失敗した場合、実行は[非ブロッキング エラー](#exit-code-output)になります。`<hook name> hook error` 通知には解析または検証のメッセージが含まれます。プレーン テキストの stdout をコンテキストとして追加するイベントでは、Claude Code は解析に失敗した stdout を追加しません。
```

</details>

<details>
<summary>monitoring-usage-ja.md</summary>

```diff
diff --git a/docs-ja/pages/monitoring-usage-ja.md b/docs-ja/pages/monitoring-usage-ja.md
index 65341f0..1c572a0 100644
--- a/docs-ja/pages/monitoring-usage-ja.md
+++ b/docs-ja/pages/monitoring-usage-ja.md
@@ -1092,5 +1092,5 @@ API リクエストが `stop_reason: "refusal"` を返したときにログに
 * `from_mode`: 以前の権限モード。例: `"default"`、`"plan"`、`"acceptEdits"`、`"auto"`、`"bypassPermissions"`
 * `to_mode`: 新しい権限モード
-* `trigger`: 変更の原因。`"shift_tab"`、`"exit_plan_mode"`、`"auto_gate_denied"`、`"auto_opt_in"` のいずれかです。遷移が SDK またはブリッジから発生した場合は含まれません
+* `trigger`: 変更の原因。`"shift_tab"`、`"exit_plan_mode"`、`"auto_gate_denied"`、`"auto_opt_in"` のいずれか。SDK が [`setPermissionMode()`](/docs/ja/agent-sdk/typescript#query-object) を通じて権限モードを設定した場合など、一部の変更では含まれません
 
 <h4 id="auth-event">
```

</details>

<details>
<summary>network-config-ja.md</summary>

```diff
diff --git a/docs-ja/pages/network-config-ja.md b/docs-ja/pages/network-config-ja.md
index 9e5e38f..78b2ee2 100644
--- a/docs-ja/pages/network-config-ja.md
+++ b/docs-ja/pages/network-config-ja.md
@@ -201,31 +201,35 @@ Claude Code がこれらのファイルの 1 つを読み込めない場合、
 
 <h2 id="streaming-idle-watchdogs">
-  ストリーミングアイドルウォッチドッグ
+  ストリーミングのアイドルウォッチドッグ
 </h2>
 
-Claude Code は 4 つの独立したタイマーを実行し、ストリーミングモデルレスポンスが静止状態になるとそれを中止するため、接続が切れた場合はハングするのではなく失敗して再試行されます。最初のバイト期限はレスポンスヘッダーの到着を待つ間をカバーし、レスポンスが到着する前です。他の 3 つのタイマーはそれぞれ、ライブレスポンスの異なるシグナルを監視します。
+Claude Code は、ストリーミング中のモデルの応答が途絶えたときにそれを中止する 4 つの独立したタイマーを実行します。これにより、切断された接続はハングしたままにならず、失敗して再試行されます。レスポンスヘッダーがまったく返されないリクエストは、次の 2 つのいずれかの形で終了します。
 
-| タイマー | 中止する条件 | 実行対象 | デフォルトタイムアウト |
+* **ファーストバイト期限が実行される接続の場合**: 最初の試行はその期限で終了します。期限を変更するには、`CLAUDE_STREAM_FIRST_BYTE_TIMEOUT_MS` を設定します。再試行の待機時間については、[No response from API](/docs/ja/errors#no-response-from-api) を参照してください。
+* **その他の接続の場合**: ボディアイドルタイムアウトが発動する 5〜6 分後にリクエストが終了します（このタイムアウトをオフにしている場合を除く）。より早く終了させるには、`API_TIMEOUT_MS` を小さくします。
+
+| タイマー | 中止する条件 | 実行される接続 | デフォルトのタイムアウト |
 | :- | :- | :- | :- |
-| 最初のバイト期限 | Claude Code がリクエストを送信した後、レスポンスヘッダーが到着しない | 直接 Anthropic API および [Claude Platform on AWS](/docs/ja/claude-platform-on-aws)（HTTPS プロキシを含む）。ただし、`ANTHROPIC_BASE_URL` または `ANTHROPIC_AWS_BASE_URL` が [gateway](/docs/ja/gateways) を経由する場合は除外。Amazon Bedrock では `CLAUDE_ENABLE_BYTE_WATCHDOG_BEDROCK=1` でオプトイン。Google Cloud の Agent Platform または Microsoft Foundry では実行されない | 直接 Anthropic API では 180 秒、その他では 300 秒、加えてリクエストボディの 32KB ごとに 1 秒 |
-| イベントレベルウォッチドッグ | レスポンスイベントが解析されない。バイトレベルウォッチドッグが Amazon Bedrock 以外の接続で実行される場合、キープアライブピングを含む到着バイトもこのウォッチドッグをリセットし、解析されたイベントがない状態で約 5 分間まで実行される | すべてのプロバイダー | 300 秒 |
-| バイトレベルウォッチドッグ | ワイヤー上にバイトが到着しない（SSE キープアライブピングを含む） | 直接 Anthropic API、[Claude Platform on AWS](/docs/ja/claude-platform-on-aws)、および [gateway](/docs/ja/gateways) 接続（カスタム `ANTHROPIC_BASE_URL` を含む）。Amazon Bedrock の `vnd.amazon.eventstream` レスポンスでは `CLAUDE_ENABLE_BYTE_WATCHDOG_BEDROCK=1` でオプトイン。Google Cloud の Agent Platform または Microsoft Foundry では実行されない | 直接 Anthropic API では 180 秒。Claude Platform on AWS、Amazon Bedrock、[Claude apps gateway](/docs/ja/claude-apps-gateway) セッション、およびカスタム `ANTHROPIC_BASE_URL` 経由では 300 秒 |
-| ボディアイドルタイムアウト | 5 分間バイトが到着しない | 直接 Anthropic API、Claude Platform on AWS、および `CLAUDE_ENABLE_BYTE_WATCHDOG_BEDROCK=1` が設定された Amazon Bedrock 以外のプロバイダー。ただし、[`API_FORCE_IDLE_TIMEOUT`](/docs/ja/env-vars) がこれを変更する場合は除外 | 5 分 |
+| ファーストバイト期限 | Claude Code がリクエストを送信した後、レスポンスヘッダーが届かない | 直接の Anthropic API と [Claude Platform on AWS](/docs/ja/claude-platform-on-aws)（HTTPS プロキシ経由を含む）。ただし、`ANTHROPIC_BASE_URL` または `ANTHROPIC_AWS_BASE_URL` によって[ゲートウェイ](/docs/ja/gateways)経由でルーティングされる場合は除く。Amazon Bedrock では `CLAUDE_ENABLE_BYTE_WATCHDOG_BEDROCK=1` でオプトイン。Google Cloud の Agent Platform、Microsoft Foundry、および [Claude apps gateway](/docs/ja/claude-apps-gateway) セッションでは実行されない | 直接の Anthropic API では 180 秒、それ以外では 300 秒。これにリクエストボディ 32KB ごとに 1 秒が加算される |
+| イベントレベルのウォッチドッグ | レスポンスイベントがパースされない。Amazon Bedrock 以外の接続でバイトレベルのウォッチドッグが実行されている場合は、キープアライブの ping を含む到着バイトでもこのウォッチドッグがリセットされる（パースされたイベントがない状態で最大約 5 分まで） | すべてのプロバイダー | 300 秒 |
+| バイトレベルのウォッチドッグ | SSE のキープアライブ ping を含め、ワイヤー上にバイトが届かない | 直接の Anthropic API、[Claude Platform on AWS](/docs/ja/claude-platform-on-aws)、および[ゲートウェイ](/docs/ja/gateways)接続（カスタムの `ANTHROPIC_BASE_URL` を含む）。Amazon Bedrock の `vnd.amazon.eventstream` レスポンスでは `CLAUDE_ENABLE_BYTE_WATCHDOG_BEDROCK=1` でオプトイン。Google Cloud の Agent Platform や Microsoft Foundry では実行されない | 直接の Anthropic API では 180 秒。Claude Platform on AWS、Amazon Bedrock、[Claude apps gateway](/docs/ja/claude-apps-gateway) セッション、およびカスタムの `ANTHROPIC_BASE_URL` 経由では 300 秒 |
+| ボディアイドルタイムアウト | レスポンスヘッダーの待機時間を含め、5 分間バイトが届かない | 直接の Anthropic API、Claude Platform on AWS、`CLAUDE_ENABLE_BYTE_WATCHDOG_BEDROCK=1` が設定された Amazon Bedrock 以外のプロバイダー（[`API_FORCE_IDLE_TIMEOUT`](/docs/ja/env-vars) で変更されない限り） | 5 分 |
 
-`CLAUDE_ENABLE_BYTE_WATCHDOG_BEDROCK=1` を設定した場合、バイトレベルウォッチドッグは Bedrock のボディアイドルタイムアウトを置き換え、並行して実行されるのではなく実行されます。その後、`CLAUDE_STREAM_IDLE_TIMEOUT_MS` は Bedrock ストリームが接続を切断されたものとして扱われるまで静止状態を保つことができる期間も制御し、以下にリストされた制限内です。到着バイトは Bedrock のイベントレベルウォッチドッグをリセットしません。デバッグログが有効な場合、各 Bedrock ストリームは `wire-heartbeat: _chunkTimes absent` で始まるデバッグメッセージをログに記録します。
```

</details>

<details>
<summary>permission-modes-ja.md</summary>

```diff
diff --git a/docs-ja/pages/permission-modes-ja.md b/docs-ja/pages/permission-modes-ja.md
index 01a1053..e10692f 100644
--- a/docs-ja/pages/permission-modes-ja.md
+++ b/docs-ja/pages/permission-modes-ja.md
@@ -628,5 +628,5 @@ claude --permission-mode bypassPermissions
 Claude Code は [`--restricted`](/docs/ja/cli-reference#cli-flags) で開始したセッションで `bypassPermissions` を拒否します。`--restricted` には Claude Code v2.1.248 以降が必要です。
 
-このモードを有効にしてインタラクティブセッションを初めて開始すると、Claude Code は権限チェックなしで実行されたアクションの責任を受け入れるよう求める警告ダイアログを表示します。
+<span id="bypass-permissions-acceptance" />このモードを有効にして対話セッションを初めて開始すると、Claude Code は権限チェックなしで実行されたアクションの責任を受け入れるよう求める警告ダイアログを表示します。
 
 * **受け入れた場合**: Claude Code は `skipDangerousModePermissionPrompt` を `~/.claude/settings.json` の `true` に設定するため、後のセッションではダイアログをスキップします。ダイアログを再度表示するには、そのファイルからキーを削除するか、`false` に設定してください。[`skipDangerousModePermissionPrompt` リファレンス](/docs/ja/settings-reference#skipdangerousmodepermissionprompt)には、ユーザーまたは組織が設定できる他の設定ファイルが記載されています。
@@ -636,7 +636,9 @@ Claude Code は [`--restricted`](/docs/ja/cli-reference#cli-flags) で開始し
 
 * 受け入れが記録されていない場合、`claude --bg --permission-mode bypassPermissions` は対話セッションでダイアログを受け入れるまで拒否されます。
-* `skipDangerousModePermissionPrompt` が `.claude/settings.local.json` でのみ設定されている場合、バックグラウンドセッションはバイパスのリクエストを無視した状態で開始し、通知 `Bypass permissions was requested at launch and ignored · if that was you, ~/.claude/settings.json needs "skipDangerousModePermissionPrompt": true` をピン留めします。バイパスを有効にするには、そのキーを `~/.claude/settings.json` に追加してから、新しいバックグラウンドセッションを開始してください。
+* `skipDangerousModePermissionPrompt` が `.claude/settings.local.json` でのみ設定されている場合、バックグラウンドセッションはバイパスのリクエストを無視した状態で開始し、通知 `Bypass permissions was requested at launch and ignored · if that was you, ~/.claude/settings.json needs "skipDangerousModePermissionPrompt": true` をピン留めします。そのキーを `~/.claude/settings.json` に追加してから、新しいバックグラウンドセッションを開始してください。通知を表示しているセッションは引き続き次のように実行されます。
+  * `--allow-dangerously-skip-permissions` が無視された場合、`bypassPermissions` は `Shift+Tab` のサイクルから除外されます。
+  * `--permission-mode bypassPermissions` または `--dangerously-skip-permissions` が無視された場合、セッションは代わりに Manual モードで開始されます。
 
-Linux と macOS では、Claude Code はこのモードで root として、または `sudo` の下で実行されている場合、起動を拒否します。
+Linux と macOS では、Claude Code は root として、または `sudo` の下で実行されている場合、`bypassPermissions` モードでの起動を拒否します。
 
 ```text theme={null}
@@ -693,4 +695,5 @@ Linux と macOS では、Claude Code はこのモードで root として、ま
   * `--restricted` なしで開始されたセッションにおける、`.claude/agent-memory/` などの[サブエージェントメモリ](/docs/ja/sub-agents#enable-persistent-memory)ディレクトリ内の markdown ファイル
 * [`--plugin-dir`](/docs/ja/plugins/mods/create#change-a-mod-with-claude) で読み込んだディレクトリ。ファイルが変更されると、Claude Code がそこから mod のコードを再読み込みして実行するためです
+* `~/.claude/dev-mods/`、または [`CLAUDE_CONFIG_DIR`](/docs/ja/env-vars) が指すディレクトリ内の `dev-mods/`。Claude が[ユーザーのために作成した mod](/docs/ja/plugins/mods/create#ask-claude-for-a-mod) を保存する場所です
 
 保護されたファイル：
```

</details>

*...以降省略*

</details>


<details>
<summary>2026-10-17</summary>

**変更ファイル:**

```
 docs-ja/pages/agent-teams-ja.md                  |   8 +-
 docs-ja/pages/agent-view-ja.md                   |   2 +-
 docs-ja/pages/auto-mode-classifier-billing-ja.md |   4 +-
 docs-ja/pages/changelog.md                       |  66 ++
 docs-ja/pages/channels-ja.md                     |   8 +-
 docs-ja/pages/claude-directory-ja.md             |   2 +-
 docs-ja/pages/claude-security-ja.md              |   4 +-
 docs-ja/pages/cli-reference-ja.md                |   2 +-
 docs-ja/pages/code-review-local-ja.md            |   2 +-
 docs-ja/pages/commands-ja.md                     |   2 +-
 docs-ja/pages/costs-ja.md                        |   2 +-
 docs-ja/pages/desktop-ja.md                      |  19 +-
 docs-ja/pages/features-overview-ja.md            |   2 +-
 docs-ja/pages/hooks-ja.md                        |   2 +-
 docs-ja/pages/large-codebases-ja.md              |   2 +-
 docs-ja/pages/mcp-ja.md                          |   2 +-
 docs-ja/pages/monitoring-usage-ja.md             |   2 +-
 docs-ja/pages/permissions-ja.md                  |   2 -
 docs-ja/pages/prompt-caching-ja.md               |   4 +-
 docs-ja/pages/sandboxing-ja.md                   |   4 +-
 docs-ja/pages/security-guidance-ja.md            |   2 +-
 docs-ja/pages/security-ja.md                     |   2 +-
 docs-ja/pages/sessions-ja.md                     |  14 -
 docs-ja/pages/skills-ja.md                       |  14 +-
 docs-ja/pages/terminal-config-ja.md              |   3 +-
 docs-ja/pages/vs-code-ja.md                      | 971 ++++++++++++-----------
 docs-ja/pages/zero-data-retention-ja.md          |   1 +
 27 files changed, 635 insertions(+), 513 deletions(-)
```

<details>
<summary>agent-teams-ja.md</summary>

```diff
diff --git a/docs-ja/pages/agent-teams-ja.md b/docs-ja/pages/agent-teams-ja.md
index 54ece75..9f49b2e 100644
--- a/docs-ja/pages/agent-teams-ja.md
+++ b/docs-ja/pages/agent-teams-ja.md
@@ -232,5 +232,5 @@ Ask the researcher teammate to shut down
 リーダーはシャットダウンリクエストを送信します。チームメンバーは承認して適切に終了するか、説明付きで却下できます。
 
-チームの共有ディレクトリは、セッションが終了すると自動的にクリーンアップされるため、別のクリーンアップステップはありません。削除されるディレクトリと、再開されたセッションのために保持されるディレクトリについては、[Architecture](#architecture) を参照してください。
+チームの共有ディレクトリは、セッションが終了すると自動的にクリーンアップされるため、別のクリーンアップステップはありません。削除されるディレクトリと、ディスク上に残るディレクトリについては、[Architecture](#architecture) を参照してください。
 
 <h3 id="enforce-quality-gates-with-hooks">
@@ -279,8 +279,8 @@ Claude Code はタスク依存関係を自動的に管理します。チーム
 チームとタスクはセッション派生名でローカルに保存されます。名前は `session-` の後にセッション ID の最初の 8 文字が続きます。
 
-* **チーム設定**：`~/.claude/teams/{team-name}/config.json`
-* **タスクリスト**：`~/.claude/tasks/{team-name}/`
+* **チーム設定**：`~/.claude/teams/{team-name}/config.json`。Claude Code はセッション終了時にチーム設定ディレクトリを削除します。
+* **タスクリスト**：`~/.claude/tasks/{team-name}/`。このディレクトリはセッション終了後もディスク上に残ります。[Claude Code が保持する期間](/docs/ja/claude-directory#cleaned-up-automatically) を変更するには、[`cleanupPeriodDays`](/docs/ja/settings-reference#cleanupperioddays) を設定してください。
 
-Claude Code はセッション起動時にこれらの両方を自動的に生成し、チームメンバーが参加、アイドル状態になる、または離脱するときに更新します。チーム設定ディレクトリはセッション終了時に削除されます。タスクリストディレクトリはローカルに保持され、アップロードされることはないため、再開されたセッションはタスクを保持します。保持期間は、セッショントランスクリプト用に既に制御している同じ [`cleanupPeriodDays`](/docs/ja/settings-reference#cleanupperioddays) によって管理され、[保持スイープルール](/docs/ja/claude-directory#cleaned-up-automatically) に従います。
+Claude Code はセッション起動時にこれらの両方を自動的に生成し、チームメンバーが参加、アイドル状態になる、または離脱するときに更新します。
 
 チーム設定はセッション ID と tmux ペイン ID などのランタイム状態を保持しているため、手動で編集したり、事前に作成したりしないでください。次の状態更新時に変更が上書きされます。
```

</details>

<details>
<summary>agent-view-ja.md</summary>

```diff
diff --git a/docs-ja/pages/agent-view-ja.md b/docs-ja/pages/agent-view-ja.md
index 9e14f61..4990e66 100644
--- a/docs-ja/pages/agent-view-ja.md
+++ b/docs-ja/pages/agent-view-ja.md
@@ -326,5 +326,5 @@ Claude Code がセッションをバックグラウンドにすると（約 10 
 2 回目の押下は、たとえば [バックグラウンドサービスが応答していない](#agent-view-says-the-background-service-did-not-respond) ために停止の試みが失敗した場合でも、セッションを削除します。確認はさらに 2 秒間有効なままで、削除によってセッションのプロセス自体が終了されます。削除せずに確認を閉じるには `Esc` を押します。
 
-[セッションを削除するときに削除されるもの](#what-deleting-a-session-removes) で説明されている保持されるケースを除き、削除するとセッションはリストから削除され、Claude がそのセッション用に作成した worktree は、削除方法と worktree の内容に応じて、削除、保持、またはそのまま残されます。会話のトランスクリプトは常にローカルマシンに残り、`claude --resume` から利用できます。
+[セッションを削除するときに削除されるもの](#what-deleting-a-session-removes) で説明されている保持されるケースを除き、削除するとセッションはリストから削除され、Claude がそのセッション用に作成した worktree は、削除方法と worktree の内容に応じて、削除、保持、またはそのまま残されます。会話のトランスクリプトはローカルマシンに残り、`claude --resume` から利用できます。
 
 Claude Code v2.1.212 以降でセッションを戻すには、ディスパッチ入力に `/resume` と入力します。ピッカーが開き、エージェントビューを開いたリポジトリの過去のセッションが新しい順に表示されます。リストから削除したセッションも含まれますが、既に行があるセッションは表示されません。`↑`/`↓` で選択を移動し、`Enter` で選択したセッションをバックグラウンドセッションとして再開して行としてリストに戻し、`Esc` でピッカーを閉じます。
```

</details>

<details>
<summary>auto-mode-classifier-billing-ja.md</summary>

```diff
diff --git a/docs-ja/pages/auto-mode-classifier-billing-ja.md b/docs-ja/pages/auto-mode-classifier-billing-ja.md
index 0d4e24e..0171771 100644
--- a/docs-ja/pages/auto-mode-classifier-billing-ja.md
+++ b/docs-ja/pages/auto-mode-classifier-billing-ja.md
@@ -13,5 +13,7 @@ We're changing auto mode to no longer charge for classifier requests in Claude C
 ```
 
-プロンプトで、Claude Code はこのようにチェックする最初のアクションを保留し、回答を待ちます。何も壊れていません：auto mode は動作し続け、その分類器リクエストは以前と同じように請求されます。最も一般的な原因は Claude Code と API の間の LLM ゲートウェイまたはプロキシであり、Claude Code がそれを識別できる場合、通知はそれに名前を付けます。**Enter** キーを押して続行するか、[セッションを対象にする](#make-the-session-eligible)を参照して、新しいセッションに表示されないようにしてください。
+プロンプトで、Claude Code はこのようにチェックする最初のアクションを保留し、回答を待ちます。auto モードは引き続き動作し、その分類器リクエストは以前と同じように課金されます。
+
+最も一般的な原因は Claude Code と API の間の LLM ゲートウェイまたはプロキシであり、Claude Code がそれを識別できる場合、通知はそれに名前を付けます。**Enter** キーを押して続行するか、[セッションを対象にする](#make-the-session-eligible)を参照して、新しいセッションに表示されないようにしてください。
 
 <h2 id="respond-to-the-notice">
```

</details>

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index 4549ebf..490ea6e 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,70 @@
 # Changelog
 
+## 2.1.302
+
+- Added `CLAUDE_CODE_AUTO_MODE_MODEL` to choose the model the client-side auto mode classifier uses; it does not change the model for server-side auto mode
+- Added an `Idle compaction` row to `/config` for turning idle compaction off or back on; the notices shown after an idle compaction now say how to turn it off
+- Added a notice to `/design-sync` and `/design-login` that standalone Claude Design (claude.ai/design) closes by December 14, 2026
+- Fixed a "Prompt is too long" error when stopping a turn while the conversation was being compacted
+- Fixed requests failing with "diagnostics: Extra inputs are not permitted" after switching to Vertex or Bedrock mid-session
+- Fixed the Read tool loading an image file of any size, or a pipe or device named like an image, entirely into memory; image sources over 128 MB are now refused
+- Fixed `/autocompact` and `/effort` saving to the wrong model when a gateway names Opus 4 or 4.1 with a prefix, such as `anthropic/claude-opus-4-1`
+- Fixed a prompt cache miss when a tool added mid-session was loaded again through ToolSearch or after compaction
+- Fixed `claude plugin` and other subcommands sometimes exiting before a queued settings or config write finished, which could lose the change or leave a `.tmp` file behind
+- Fixed plugin marketplaces re-cloning on every refresh, and newly installed git plugins showing version "unknown", when git defaults to the reftable ref format
+- Fixed the PowerShell tool not finding commands in a plugin's `bin/` folder, and reporting an error when a search that finds nothing (rg, grep, findstr, git grep) is piped into `Select-Object` or another formatting cmdlet
+- Fixed Claude in the desktop app pointing you to claude.ai settings or `/mcp` to authorize or reconnect an MCP server where that option isn't available
+- Fixed artifact publishes sometimes failing when Claude sent an empty list of edits, and Claude retrying an artifact update the wrong way after a newer version of the artifact turned it away
+- Fixed `classifier_category` missing from OpenTelemetry `tool_decision` events for most auto mode classifier blocks, and new `tool_decision` attributes pushing out `tool_use_id`, `tool_source` and `tool_parameters` when `OTEL_LOGRECORD_ATTRIBUTE_COUNT_LIMIT` is low
+- Fixed rows in the agents view staying blank after moving down a long list or folding a section
+- Fixed `claude remote-control --help` not printing its usage and exiting when not signed in
+- Fixed `/design consent` and `/design revoke` suggesting `/design-login` when they fail in a cloud session, where it isn't available; the message now points to claude.ai/design/settings
+- Fixed MCP servers showing no tools, or every tool call failing, when the server negotiates protocol version 2026-07-28 but omits `resultType`, `ttlMs` or `cacheScope`
+- Fixed prompt suggestions spending usage credits on models your plan pays for only with credits: they are now skipped after a reply billed to credits
+- Fixed URLs written in backticks being clickable only on their first row when they wrap; the whole URL is now one link in terminals that support hyperlinks
+- Fixed `claude plugin details <name>@builtin` suggesting `claude plugin list`, which never shows built-in plugins, when the plugin isn't found; it now points to `/plugin`
```

</details>

<details>
<summary>channels-ja.md</summary>

```diff
diff --git a/docs-ja/pages/channels-ja.md b/docs-ja/pages/channels-ja.md
index db5ab09..7f02d90 100644
--- a/docs-ja/pages/channels-ja.md
+++ b/docs-ja/pages/channels-ja.md
@@ -46,5 +46,5 @@ Team、Enterprise、または Console 組織を管理している場合は、[
 
         * `Marketplace "claude-plugins-official" not found`：`/plugin marketplace add anthropics/claude-plugins-official` でマーケットプレイスを追加してから、インストールを再試行してください。
-        * プラグインが[マーケットプレイスで見つかりません](/docs/ja/plugins/install#install-a-plugin)：プラグイン名を確認してください。
+        * `Plugin "<name>" not found in marketplace "claude-plugins-official"`：ローカルにあるマーケットプレイスカタログのコピーが古くなっている可能性があります。`/plugin marketplace update claude-plugins-official` で更新してから、インストールを再試行してください。再試行しても同じメッセージが表示される場合は、[Plugin not found in marketplace](/docs/ja/plugins/troubleshooting#plugin-not-found-in-marketplace) を参照してください。
 
         インストールがインストールスコープを求めるとき、ユーザースコープオプションを選択して、プラグインがすべてのプロジェクト全体で利用可能になるようにしてください。インストール概要を確認してください。`Run /reload-plugins to apply.` と報告されている場合は、[プラグイン変更を再起動なしで適用する](/docs/ja/plugins/cli-reference#reload-plugins)を参照して、プラグインの設定コマンドを利用可能にしてください。
@@ -124,5 +124,5 @@ Team、Enterprise、または Console 組織を管理している場合は、[
 
         * `Marketplace "claude-plugins-official" not found`：`/plugin marketplace add anthropics/claude-plugins-official` でマーケットプレイスを追加してから、インストールを再試行してください。
-        * プラグインが[マーケットプレイスで見つかりません](/docs/ja/plugins/install#install-a-plugin)：プラグイン名を確認してください。
+        * `Plugin "<name>" not found in marketplace "claude-plugins-official"`：ローカルにあるマーケットプレイスカタログのコピーが古くなっている可能性があります。`/plugin marketplace update claude-plugins-official` で更新してから、インストールを再試行してください。再試行しても同じメッセージが表示される場合は、[Plugin not found in marketplace](/docs/ja/plugins/troubleshooting#plugin-not-found-in-marketplace) を参照してください。
 
         インストールがインストールスコープを求めるとき、ユーザースコープオプションを選択して、プラグインがすべてのプロジェクト全体で利用可能になるようにしてください。インストール概要を確認してください。`Run /reload-plugins to apply.` と報告されている場合は、[プラグイン変更を再起動なしで適用する](/docs/ja/plugins/cli-reference#reload-plugins)を参照して、プラグインの設定コマンドを利用可能にしてください。
@@ -189,5 +189,5 @@ Team、Enterprise、または Console 組織を管理している場合は、[
 
         * `Marketplace "claude-plugins-official" not found`：`/plugin marketplace add anthropics/claude-plugins-official` でマーケットプレイスを追加してから、インストールを再試行してください。
-        * プラグインが[マーケットプレイスで見つかりません](/docs/ja/plugins/install#install-a-plugin)：プラグイン名を確認してください。
+        * `Plugin "<name>" not found in marketplace "claude-plugins-official"`：ローカルにあるマーケットプレイスカタログのコピーが古くなっている可能性があります。`/plugin marketplace update claude-plugins-official` で更新してから、インストールを再試行してください。再試行しても同じメッセージが表示される場合は、[Plugin not found in marketplace](/docs/ja/plugins/troubleshooting#plugin-not-found-in-marketplace) を参照してください。
 
         インストールがインストールスコープを求めるとき、ユーザースコープオプションを選択して、プラグインがすべてのプロジェクト全体で利用可能になるようにしてください。
@@ -248,5 +248,5 @@ Fakechat デモを試すには、以下が必要です。
 
     * `Marketplace "claude-plugins-official" not found`：`/plugin marketplace add anthropics/claude-plugins-official` でマーケットプレイスを追加してから、インストールを再試行してください。
-    * プラグインが [マーケットプレイスで見つかりません](/docs/ja/plugins/install#install-a-plugin)：プラグイン名を確認してください。
+    * `Plugin "<name>" not found in marketplace "claude-plugins-official"`：ローカルにあるマーケットプレイスカタログのコピーが古くなっている可能性があります。`/plugin marketplace update claude-plugins-official` で更新してから、インストールを再試行してください。再試行しても同じメッセージが表示される場合は、[Plugin not found in marketplace](/docs/ja/plugins/troubleshooting#plugin-not-found-in-marketplace) を参照してください。
```

</details>

<details>
<summary>claude-directory-ja.md</summary>

```diff
diff --git a/docs-ja/pages/claude-directory-ja.md b/docs-ja/pages/claude-directory-ja.md
index 22ffcb9..6a54ef6 100644
--- a/docs-ja/pages/claude-directory-ja.md
+++ b/docs-ja/pages/claude-directory-ja.md
@@ -291,5 +291,5 @@ Report findings with severity ratings and remediation steps.`
           when: <>User types <C>/command-name</C></>,
           description: <>A file at <C>commands/deploy.md</C> creates <C>/deploy</C> the same way a skill at <C>skills/deploy/SKILL.md</C> does, and both can be auto-invoked by Claude. Skills use a directory with SKILL.md, letting you bundle reference docs, templates, or scripts alongside the prompt.</>,
-          tips: [<>Use <C>$ARGUMENTS</C> in the file to accept parameters: <C>/fix-issue 123</C></>, 'If a skill and command share a name, the skill takes precedence', 'New commands should usually be skills instead; commands remain supported'],
+          tips: [<>Use <C>$ARGUMENTS</C> in the file to accept parameters: <C>/fix-issue 123</C></>, 'If a skill and command share a name, the skill takes precedence', 'New commands should usually be skills instead; command files still work'],
           docsLink: '/en/skills',
           children: [{
```

</details>

<details>
<summary>claude-security-ja.md</summary>

```diff
diff --git a/docs-ja/pages/claude-security-ja.md b/docs-ja/pages/claude-security-ja.md
index 1dd7ceb..e491f01 100644
--- a/docs-ja/pages/claude-security-ja.md
+++ b/docs-ja/pages/claude-security-ja.md
@@ -49,8 +49,8 @@ VS Code 拡張機能またはデスクトップアプリでは、[プラグイ
 コマンドはプラグインの詳細を開き、[インストールスコープ](/docs/ja/plugins/install#install-a-plugin)を選択してインストールを開始します。
 
-インストールが失敗した場合、修正は Claude Code が報告するメッセージによって異なります。
+インストールが失敗した場合は、Claude Code が報告するメッセージに応じて対処してください。
 
 * `Marketplace "claude-plugins-official" not found` と報告された場合は、`/plugin marketplace add anthropics/claude-plugins-official` でマーケットプレイスを追加してから、インストールを再試行してください。
-* マーケットプレイスで [プラグインが見つからないと報告された](/docs/ja/plugins/install#install-a-plugin)場合は、プラグイン名のタイプミスを確認してください。
+* `Plugin "claude-security" not found in marketplace "claude-plugins-official"` と報告された場合は、マーケットプレイスカタログのローカルコピーが古くなっている可能性があります。`/plugin marketplace update claude-plugins-official` で更新してから、インストールを再試行してください。再試行しても同じメッセージが表示される場合は、[マーケットプレイスでプラグインが見つからない](/docs/ja/plugins/troubleshooting#plugin-not-found-in-marketplace)を参照してください。
 
 インストール概要を確認してください。`Run /reload-plugins to apply.` と報告された場合は、[プラグインの変更を再起動なしで適用](/docs/ja/plugins/cli-reference#reload-plugins)を参照して、現在のセッションでプラグインをアクティブにしてください。
```

</details>

<details>
<summary>cli-reference-ja.md</summary>

```diff
diff --git a/docs-ja/pages/cli-reference-ja.md b/docs-ja/pages/cli-reference-ja.md
index 07a3fb0..4d28a4c 100644
--- a/docs-ja/pages/cli-reference-ja.md
+++ b/docs-ja/pages/cli-reference-ja.md
@@ -85,5 +85,5 @@
 | `--dangerously-load-development-channels` | 承認済みの許可リストにない[チャネル](/docs/ja/channels-reference#test-during-the-research-preview)を有効にして、ローカル開発を行います。`plugin:<name>@<marketplace>` および `server:<name>` エントリを受け入れます。確認を求めるため、対話セッションで有効になります。`-p` を使用すると、Claude Code はこのフラグを無視します | `claude --dangerously-load-development-channels server:webhook` |
 | `--dangerously-skip-permissions` | 権限プロンプトをスキップします。`--permission-mode bypassPermissions` と同等です。[権限モード](/docs/ja/permission-modes#skip-all-checks-with-bypasspermissions-mode)でこれが何をスキップし、何をスキップしないかを参照してください。`--bg` で開始されたセッションの場合、モードは[スーパーバイザーがセッションを再開するときに保持](/docs/ja/agent-view#permission-mode-model-and-effort)されます | `claude --dangerously-skip-permissions` |
-| `--debug` | デバッグモードを有効にします。オプションのカテゴリフィルタリング（`--debug='mcp,startup'` または `--debug='!1p'` など）を使用します。フィルターは `=` 形式でのみバインドされます。スペース区切りフィルターはフィルタリングなしでデバッグモードを有効にします | `claude --debug='mcp,startup'` |
+| `--debug` | デバッグモードを有効にします。オプションのカテゴリフィルタリング（`--debug='mcp,startup'` または `--debug='!mcp'` など）を使用します。フィルターは `=` 形式でのみバインドされます。スペース区切りフィルターはフィルタリングなしでデバッグモードを有効にします | `claude --debug='mcp,startup'` |
 | `--debug-file <path>` | デバッグログを特定のファイルパスに書き込みます。暗黙的にデバッグモードを有効にします。`CLAUDE_CODE_DEBUG_LOGS_DIR` よりも優先されます | `claude --debug-file /tmp/claude-debug.log` |
 | `--desktop` | [Claude Desktop アプリ](/docs/ja/desktop)を現在のディレクトリで開き、ターミナルでセッションを開始せずに終了します。`--continue` を追加するか、セッション ID を使用して `--resume` を追加して、[代わりに Desktop でそのセッションを開く](/docs/ja/desktop#coming-from-the-cli)ことができます。ここで `--resume` はセッション ID のみを取り、名前またはトランスクリプトパスは取りません。プロンプトと `--verbose` および `--debug` フラグ以外の他のフラグは取りません。アプリがセッション自体を開始するため。macOS および x64 Windows で Claude サブスクリプションでサインインしている場合に利用可能です。Claude Code v2.1.285 以降が必要です | `claude --desktop` |
```

</details>

<details>
<summary>code-review-local-ja.md</summary>

```diff
diff --git a/docs-ja/pages/code-review-local-ja.md b/docs-ja/pages/code-review-local-ja.md
index d47f869..98d8872 100644
--- a/docs-ja/pages/code-review-local-ja.md
+++ b/docs-ja/pages/code-review-local-ja.md
@@ -119,5 +119,5 @@ effort レベルとフラグの後、Claude Code は行の残りをレビュー
 
 * **`ultra` を指定した場合**: Claude Code は単一の単語をベースブランチまたは PR 番号として読み取ります。ブランチや PR を指していない長いテキストは、[レビューに添付されるメモ](/docs/ja/ultrareview#pass-a-request-in-plain-words)になります。`/code-review ultra check my auth changes` は現在のブランチをレビューし、Claude は指摘事項をメモと関連付けます。
-* **`ultra` を指定しない場合**: 残りはすべてレビュー対象になります。これは別のコマンド名で始まる場合も同様です。`/code-review /fix-issue 123` は、`/fix-issue` を 2 つ目の[スタックされたスキル](/docs/ja/skills#pass-arguments-to-skills)として読み込むのではなく、`/fix-issue 123` を対象テキストとしてレビューします。v2.1.218 より前は、`/code-review` の後にスタックされたコマンドは独立したスキルとして展開されていました。
+* **`ultra` を指定しない場合**: 残りはすべてレビュー対象になります。これは別のコマンド名で始まる場合も同様です。`/code-review /fix-issue 123` は、`/fix-issue` を 2 つ目の[スタックされたスキル](/docs/ja/skills#stack-several-skills-in-one-message)として読み込むのではなく、`/fix-issue 123` を対象テキストとしてレビューします。v2.1.218 より前は、`/code-review` の後にスタックされたコマンドは独立したスキルとして展開されていました。
 
 <h2 id="run-in-the-foreground">
```

</details>

<details>
<summary>commands-ja.md</summary>

```diff
diff --git a/docs-ja/pages/commands-ja.md b/docs-ja/pages/commands-ja.md
index d413795..4d40db6 100644
--- a/docs-ja/pages/commands-ja.md
+++ b/docs-ja/pages/commands-ja.md
@@ -11,5 +11,5 @@
 `/` と入力するとご利用いただけるコマンドが表示されます。または `/` の後に文字を入力してフィルタリングできます。[コマンドメニューが入力内容にどのようにマッチするか](#how-the-command-menu-matches-what-you-type)では、ハイライト、タイプミス、および Claude Code がメニューから非表示にするコマンドについて説明しています。これらのコマンドは完全な名前を入力するまで表示されません。
 
-コマンドはメッセージの開始時にのみ認識されます。コマンド名の後に続くテキストがその引数になります。[スキル](/docs/ja/skills#pass-arguments-to-skills)は例外です。スキル呼び出しの後に別のスキルが続く場合（例：`/skill-a /skill-b do XYZ`）、開始時に指定されたスキルが読み込まれ、末尾のテキストが各スキルに引数として渡されます。最大 6 つのスキルをチェーンできます。
+コマンドはメッセージの開始時にのみ認識されます。コマンド名の後に続くテキストがその引数になります。ターミナルのプロンプトでは、1 つのメッセージを複数の[スキル](/docs/ja/skills#stack-several-skills-in-one-message)で始めることができます。`/skill-a /skill-b do XYZ` と入力すると両方のスキルが読み込まれ、末尾のテキストが各スキルに引数として渡されます。最大 6 つのスキルをチェーンできます。
 
 Claude が応答中にコマンドを送信した場合、Claude Code はそれをキューに入れ、現在のターンが終了した後に実行します。Claude Code は `/status`、`/tasks`、`/usage` など、応答を中断せずにすぐに実行するコマンドもあります。[フルスクリーンレンダリング](/docs/ja/fullscreen)では、Claude Code は `/theme` や `/help` などのダイアログコマンドもすぐに開きます。v2.1.234 より前では、Claude Code はこれらのダイアログをターンが終了するまでキューに入れていました。
```

</details>

*...以降省略*

</details>


<details>
<summary>2026-10-16</summary>

**変更ファイル:**

```
 docs-ja/pages/agent-view-ja.md               |  10 +-
 docs-ja/pages/analytics-ja.md                |   2 +
 docs-ja/pages/artifacts-ja.md                |   3 +-
 docs-ja/pages/changelog.md                   |  54 ++
 docs-ja/pages/checkpointing-ja.md            |   2 +-
 docs-ja/pages/claude-code-on-the-web-ja.md   |   2 +-
 docs-ja/pages/claude-projects-ja.md          |   2 +-
 docs-ja/pages/cloud-environments-ja.md       |  25 +-
 docs-ja/pages/code-review-ja.md              | 471 +++-------------
 docs-ja/pages/commands-ja.md                 |   4 +-
 docs-ja/pages/desktop-ja.md                  |  80 ++-
 docs-ja/pages/env-vars-ja.md                 |   3 +-
 docs-ja/pages/errors-ja.md                   | 798 +++++++++++++++++----------
 docs-ja/pages/features-overview-ja.md        |   2 +-
 docs-ja/pages/github-enterprise-server-ja.md |   2 +-
 docs-ja/pages/google-vertex-ai-ja.md         |   2 +-
 docs-ja/pages/interactive-mode-ja.md         |   2 +
 docs-ja/pages/mcp-ja.md                      |   2 +-
 docs-ja/pages/mcp-quickstart-ja.md           |   2 +
 docs-ja/pages/memory-ja.md                   |   1 +
 docs-ja/pages/model-config-ja.md             |  20 +
 docs-ja/pages/remote-control-ja.md           |   1 +
 docs-ja/pages/routines-ja.md                 |   4 +-
 docs-ja/pages/skills-ja.md                   |  10 +-
 docs-ja/pages/ultrareview-ja.md              |   2 +-
 docs-ja/pages/vs-code-ja.md                  |  66 +++
 docs-ja/pages/web-quickstart-ja.md           |   2 +-
 27 files changed, 858 insertions(+), 716 deletions(-)
```

**新規追加:**


<details>
<summary>agent-view-ja.md</summary>

```diff
diff --git a/docs-ja/pages/agent-view-ja.md b/docs-ja/pages/agent-view-ja.md
index 39e4e65..9e14f61 100644
--- a/docs-ja/pages/agent-view-ja.md
+++ b/docs-ja/pages/agent-view-ja.md
@@ -501,9 +501,9 @@ Claude Code v2.1.212 以降でセッションを戻すには、ディスパッ
 </h4>
 
-バックグラウンドへの移動では、保存された会話から再開する新しいプロセスが開始され、進行中の作業はそのプロセスに移動します。実行中のバックグラウンドシェルコマンド、バックグラウンド化されたサブエージェント、動的ワークフロー、[`/loop`](/docs/ja/scheduled-tasks) で作成したスケジュールタスク、および Claude の [アーティファクトコメントへの自動返信](/docs/ja/artifacts#let-claude-reply-to-comments-on-its-own) はすべて引き継がれ、そこで実行を続けます。サブエージェントは自身が開始したすべてのものと一緒に移動するため、その作業のすべてが移動できる場合にのみ引き継がれます。進行中の作業を引き継がずに停止するには、[`CLAUDE_DISABLE_ADOPT=1`](/docs/ja/env-vars#variables) 環境変数を設定します。その場合、Claude Code はバックグラウンドに移動する前に確認を求めます。
+バックグラウンドへの移動では、保存された会話から再開する新しいプロセスが開始され、進行中のバックグラウンド作業はそのプロセスに移動します。実行中のバックグラウンドシェルコマンド、バックグラウンド化されたサブエージェント、動的ワークフロー、[`/loop`](/docs/ja/scheduled-tasks) で作成したスケジュールタスク、および Claude の [アーティファクトコメントへの自動返信](/docs/ja/artifacts#let-claude-reply-to-comments-on-its-own) はすべて引き継がれ、そこで実行を続けます。サブエージェントは自身が開始したすべてのものと一緒に移動するため、その作業のすべてが移動できる場合にのみ引き継がれます。進行中のバックグラウンド作業を引き継がずに停止するには、[`CLAUDE_DISABLE_ADOPT=1`](/docs/ja/env-vars#variables) 環境変数を設定します。その場合、Claude Code はバックグラウンドに移動する前に確認を求めます。
 
 [動的ワークフロー](/docs/ja/workflows) でまだサブエージェントが実行中の場合、Claude Code はバックグラウンドに移動する前に `Background this session?` ダイアログで確認を求め、再起動されるサブエージェントの数を示します。先に完了させるには `Stay` を選択します。確認すると、Claude Code はバックグラウンドセッションで実行を再生します。まだ実行中だったサブエージェントは最初からやり直されるため、それまでに使用したトークンは再度消費されます。完了したサブエージェントのうち、保存された結果を返すものと再実行されるものについては、[一時停止後の再開](/docs/ja/workflows#resume-after-a-pause) を参照してください。
 
-Claude Code は、実行中の [モニター](/docs/ja/tools-reference#monitor-tool) など引き継げない作業を停止し、モニターを所有するバックグラウンド化されたサブエージェントも一緒に停止します。そのような作業が実行中の場合、Claude Code は `Background this session?` ダイアログを表示し、作業を停止する前に確認できるようにします。
+Claude Code は、実行中の [モニター](/docs/ja/tools-reference#monitor-tool) など引き継げないバックグラウンド作業を停止し、モニターを所有するバックグラウンド化されたサブエージェントも一緒に停止します。そのような作業が実行中の場合、Claude Code は `Background this session?` ダイアログを表示し、作業を停止する前に確認できるようにします。
 
 バックグラウンドに移動した後、セッションは新しいサブエージェント、モニター、バックグラウンドコマンドを開始でき、それらはその後のデタッチや再アタッチをまたいで実行を続けます。
@@ -950,7 +950,7 @@ Claude Code は、エージェントビューに表示されているすべて
 </h3>
 
-`←` を押して現在のセッションをバックグラウンドに移すと、Claude Code が `Background this session?` ダイアログを表示する場合、セッションには実行中の作業があり、バックグラウンド化によって停止、再開、または無人で実行されたままになる可能性があり、Claude Code はそれを実行する前に確認します：
+`←` を押して現在のセッションをバックグラウンドに移すと、Claude Code が `Background this session?` ダイアログを表示する場合、セッションには実行中のバックグラウンド作業があり、バックグラウンド化によって停止、再開、または無人で実行されたままになる可能性があり、Claude Code はそれを実行する前に確認します：
 
-* **移動できない作業**：セッションには、実行中の [monitor](/docs/ja/tools-reference#monitor-tool) などのバックグラウンドセッションに移動できない作業があります。ダイアログは Claude Code が停止する作業を名前で表示し、別に転送されるタスクをカウントします。
+* **移動できない作業**：セッションには、実行中の [モニター](/docs/ja/tools-reference#monitor-tool) など、バックグラウンドセッションに移動できない作業があります。ダイアログは Claude Code が停止するバックグラウンド作業を名前で表示し、転送されるタスクは別にカウントします。
 * **実行中のサブエージェントを持つワークフロー**：[動的ワークフロー](/docs/ja/workflows)にはまだ実行中のサブエージェントがあります。ワークフロー自体は転送されますが、実行中のサブエージェントは最初から再開され、ダイアログはその数を表示します。
 * **自動アーティファクト返信**：Claude が[アーティファクトのコメントに自動で返信している](/docs/ja/artifacts#let-claude-reply-to-comments-on-its-own)場合があります。これらの返信はバックグラウンドセッションで続行され、ダイアログはそのことを表示します。
@@ -1176,5 +1176,5 @@ Agent view はリサーチプレビュー中に急速に進化しました。古
 | v2.1.198 | バックグラウンドセッションが入力を必要とするとき、完了したとき、または失敗したときに、agent view は `preferredNotifChannel` を通じて通知を送信し、`agent_needs_input` または `agent_completed` タイプで `Notification` フックを発火します。`claude attach <id>` 内での `←` と `/exit` は、シェルに戻るのではなく agent view に戻ります。`Ctrl+Z` でシェルに戻ります。作業を worktree に分離したバックグラウンドセッションは、完了時に事前に確認することなくコミットし、独自の分離ブランチをプッシュして（`main` や `master` は決してプッシュしません）、ドラフトのプルリクエストを開きます。`/login` は agent view で実行され、サインインダイアログを開きます。`Background work is running` 終了ダイアログは `Move to background and exit` を提供します。終了ハンドオフはバックグラウンドサブエージェントもカバーし、失敗として報告される代わりに次の起動時にトランスクリプトから再開します。`claude --bg` を `-p` または `--print` と組み合わせるとエラーで拒否されます。バックグラウンドセッションホストは、`connect: no route to host` で失敗する代わりに、最初の LAN アクセス時に macOS のローカルネットワーク権限を要求します。 |
 | v2.1.196 | 単一の `←` 押下でフォアグラウンドセッションがバックグラウンド化されます。以前のバージョンでは 2 回の押下が必要で、フッターヒントと確認がありました。`claude agents` に渡された `--dangerously-skip-permissions` は、黙って無視されるのではなく、バイパスの免責事項を表示します。名前を付けていない対話型セッションには、セッション一覧と `claude agents --json` で `my-app-3f` のようなデフォルト名が付きます。バックグラウンドのシェルコマンドと動的ワークフローは、Windows を含め、セッションのプロセスが停止、再起動、または更新されても存続します。このハンドオフをオフにするには `CLAUDE_CODE_DISABLE_BG_EXIT_HANDOFF=1` を設定します。再起動時に空と誤って読み取られたトランスクリプトは、削除されるのではなく `.orphaned-` サフィックス付きの名前に変更されます。 |
-| v2.1.195 | Windows でも、セッションをバックグラウンド化する際に実行中の作業が引き継がれます。代わりに停止させるには `CLAUDE_DISABLE_ADOPT=1` を設定します。`Completed` グループは残りの垂直スペースを埋め、ヘッダーは短いターミナルでコンパクトになります。古い Claude Code バージョンが、新しいセッションの `state.json` フィールドを破棄したり、それらのセッションを `claude agents` から隠したりしなくなりました。停止されたセッションにアタッチすると、最大 5 秒間の空白画面を表示する代わりに直ちに切り替わります。接続を受け入れることができないスーパーバイザーは自ら終了してロックを解放します。 |
```

</details>

<details>
<summary>analytics-ja.md</summary>

```diff
diff --git a/docs-ja/pages/analytics-ja.md b/docs-ja/pages/analytics-ja.md
index e44434a..acea5d5 100644
--- a/docs-ja/pages/analytics-ja.md
+++ b/docs-ja/pages/analytics-ja.md
@@ -14,4 +14,6 @@ Claude Code は、組織が開発者の使用パターンを理解し、貢献
 | API（Claude Console） | [platform.claude.com/claude-code](https://platform.claude.com/claude-code) | 使用メトリクス、支出追跡、チームインサイト | [詳細](#access-analytics-for-api-customers) |
 
+Code Review には専用のダッシュボードがあります。レビューのアクティビティと支出については、[使用状況を表示する](/docs/ja/code-review-costs#view-usage)を参照してください。
+
 <h2 id="access-analytics-for-team-and-enterprise">
   Team と Enterprise の分析にアクセスする
```

</details>

<details>
<summary>artifacts-ja.md</summary>

```diff
diff --git a/docs-ja/pages/artifacts-ja.md b/docs-ja/pages/artifacts-ja.md
index 9b4c658..39acf52 100644
--- a/docs-ja/pages/artifacts-ja.md
+++ b/docs-ja/pages/artifacts-ja.md
@@ -76,5 +76,4 @@ Claude が公開できないと応答した場合、またはリンクなしで
 | 公開が、[コネクタ呼び出し](#pull-live-data-with-mcp-connectors)や[ファイルダウンロード](#offer-a-file-download)など、ページのランタイム機能を宣言している | その公開の前に確認する |
 | アーティファクトを公開共有している | 変更前に会話ごとに 1 回確認する |
-| [機能フラグ取得](/docs/ja/env-vars#features-that-need-feature-flag-fetching)をオフにしている | 各アーティファクトの最初の公開前に確認する |
 | 入力したプロンプトではなく、セッション内で実行された[スケジュールタスク](/docs/ja/scheduled-tasks)によって開始されたターンで Claude が公開する | 各アーティファクトの最初の公開前に確認する |
 | Claude がユーザーの承認なしではファイルを読み取れない | 公開前に確認する。`Artifact` ツールの許可ルールがあっても、このプロンプトはスキップされない |
@@ -153,5 +152,5 @@ Claude は他の人が書いたページを、[WebFetch](/docs/ja/tools-referenc
 * **別の組織の公開アーティファクト**：Claude Code は auto モードであっても、まずユーザーに確認します。`bypassPermissions` モードなど、Claude Code がユーザーに確認できない場合、Claude はそのアーティファクトを読むことができません。Claude がこれらのアーティファクトを読めるのは、[機能フラグの取得](/docs/ja/env-vars#features-that-need-feature-flag-fetching) がオンになっている間だけです。
 * **所有者またはネットワーク設定が未確認**：Claude Code がアーティファクトの作成者を確認できない場合、またはクラウドセッションのネットワーク設定を確認できない場合は確認を求めます。ユーザーの承認はその 1 回のリクエストにのみ適用されます。
-* **plan モード、または機能フラグの取得がオフ**：[plan モード](/docs/ja/permission-modes#analyze-before-you-edit-with-plan-mode) の場合、または [機能フラグの取得](/docs/ja/env-vars#features-that-need-feature-flag-fetching) をオフにしている場合、Claude Code は、組織内の他の人が作成したアーティファクトを Artifact ツールが読む前に確認を求めます。
+* **plan モード**：[plan モード](/docs/ja/permission-modes#analyze-before-you-edit-with-plan-mode) では、Claude Code は、組織内の他の人が作成したアーティファクトを Artifact ツールが読む前に確認を求めます。
 
 Claude が WebFetch でアーティファクトを読む場合も、WebFetch 自体の [プロンプトのルール](/docs/ja/tools-reference#webfetch-tool-behavior) は引き続き適用されます。
```

</details>

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index 9e599aa..4549ebf 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,58 @@
 # Changelog
 
+## 2.1.301
+
+- Added `CLAUDE_CODE_RETRY_WATCHDOG_MAX_USAGE_LIMIT_WAIT_MS` so unattended retry mode (`CLAUDE_CODE_RETRY_WATCHDOG`) ends a request at a usage limit that resets too far away instead of waiting
+- Added OpenTelemetry tracing guidance to the `claude-api` skill, including setting up trace destinations with the `ant` CLI
+- Added the `%` motion to vim mode: jump to the matching bracket, alone or with d/c/y
+- Added `rows` to a mod's `Input`: a text field of several lines in the terminal, where Enter submits and Shift+Enter or a backslash before Enter starts a new line
+- Added `classifier_verdict` and `permission_mode` to OpenTelemetry `tool_decision` events, so auto mode classifier decisions can be told apart from permission rules
+- Added `classifier_category` to OpenTelemetry `tool_decision` events, naming the built-in rule a classifier block matched, when `OTEL_LOG_TOOL_DETAILS=1`
+- Fixed quitting removing a worktree made by a `WorktreeCreate` hook without asking when it may hold unpushed commits
+- Fixed the `fable` (and `best`) model alias erroring on the Anthropic API when the newest Fable model is not available to your organization: Claude Code now retries once on the previous Fable model
+- Fixed a misleading "Please run /login" error when a full disk keeps the login from being refreshed; the error now names the disk and says to delete files
+- Fixed Grep and Glob reporting no matches when the search program failed unexpectedly before returning any results; they now return an error saying the search failed
+- Fixed workflow agents sometimes skipping their step, and the run still reporting success, after reading the harness note that their task text carries no user authority
+- Fixed artifact updates being refused where a PreToolUse hook covers Edit or Write; Claude now edits the file and then republishes instead of changing it in the publish call
+- Fixed skills and commands with very many or very long argument names stalling for seconds when invoked; only the first 64 names, each up to 64 characters, are now filled in
+- Fixed skills, commands and hooks using very large amounts of memory when their arguments fill many placeholders
+- Fixed stray characters such as `>0q` covering the folder trust prompt, and `>4m` before the shell prompt at exit, in terminals built on VTE older than 0.53 such as MATE Terminal on RHEL 8
+- Fixed stray `GOK` text appearing in the prompt at startup in some versions of iTerm2
+- Fixed switching to a model whose name contains `application-inference-profile` running your `awsAuthRefresh` command and delaying model-switch hooks when the provider is not Bedrock
+- Fixed sign-in refresh timeouts and unexpected sign-outs after a short command such as `claude auth status` or `claude plugin list` exited in the middle of a token refresh
+- Fixed a tool call cut off by a message sent mid-turn during its permission check being reported to the model as rejected by the user
+- Fixed a case where switching to a model with a smaller context window could spend usage credits on a summary by the previous model without asking first
+- Fixed conversations being compacted over and over, on a model you didn't pick, behind an LLM gateway whose responses name a different model than the one requested
```

</details>

<details>
<summary>checkpointing-ja.md</summary>

```diff
diff --git a/docs-ja/pages/checkpointing-ja.md b/docs-ja/pages/checkpointing-ja.md
index 13c072c..ddfa313 100644
--- a/docs-ja/pages/checkpointing-ja.md
+++ b/docs-ja/pages/checkpointing-ja.md
@@ -103,5 +103,5 @@ cp source.txt dest.txt
 
 * **フォアグラウンドフォークスキル**：[`context: fork` を持つスキル](/docs/ja/skills#run-skills-in-a-subagent)がフォアグラウンドで実行され、自分のターン中にワーキングツリーを編集するため、巻き戻しは通常どおりその編集を復元します。`background: false` を設定してフォークをフォアグラウンドで実行します。いくつかの状況（[スキルページに記載](/docs/ja/skills#run-skills-in-a-subagent)）では、この設定に関係なくそこで実行されます。
-* **その他のサブエージェント**：巻き戻しは編集を復元しません。git を使用してそれらを元に戻してください。これには、バックグラウンドで実行されるフォークスキル（デフォルト）と、バックグラウンド [`/code-review --fix`](/docs/ja/code-review) 実行が含まれます。
+* **その他のサブエージェント**：巻き戻しで復元されるのは、会話の中で Claude がすでに編集していたファイルのみです。サブエージェントによるその他のファイルへの編集は残るため、git を使用して元に戻してください。これには、バックグラウンドで実行されるフォークスキル（デフォルト）と、バックグラウンド [`/code-review --fix`](/docs/ja/code-review-local) 実行が含まれます。
 
 <h3 id="external-changes-not-tracked">
```

</details>

<details>
<summary>claude-code-on-the-web-ja.md</summary>

```diff
diff --git a/docs-ja/pages/claude-code-on-the-web-ja.md b/docs-ja/pages/claude-code-on-the-web-ja.md
index d84c1de..c904e6e 100644
--- a/docs-ja/pages/claude-code-on-the-web-ja.md
+++ b/docs-ja/pages/claude-code-on-the-web-ja.md
@@ -65,5 +65,5 @@ Anthropic ホスト環境では、GitHub 認証情報は Anthropic のサーバ
 
 <Note>
-  [Zero Data Retention](/docs/ja/zero-data-retention) が有効な組織、または [HIPAA 設定](/docs/ja/hipaa-setup)が適用されている組織は、`/web-setup` またはその他のクラウドセッション機能を使用できません。
+  [Zero Data Retention](/docs/ja/zero-data-retention) が有効な組織、または [HIPAA 設定](/docs/ja/hipaa-setup)が適用されている組織は、`/web-setup` またはその他のクラウドセッション機能を使用できません。[顧客管理の暗号化キー](https://platform.claude.com/docs/en/manage-claude/cmek)（CMEK）を使用している組織も、クラウドセッションを開始できません。
 </Note>
 
```

</details>

<details>
<summary>claude-projects-ja.md</summary>

```diff
diff --git a/docs-ja/pages/claude-projects-ja.md b/docs-ja/pages/claude-projects-ja.md
index 073d7f5..c10fd9b 100644
--- a/docs-ja/pages/claude-projects-ja.md
+++ b/docs-ja/pages/claude-projects-ja.md
@@ -418,5 +418,5 @@ Claude はこのような設定を[プロジェクトメモリ](#give-a-project-
 * コマンドラインツールとパッケージ：環境の [セットアップスクリプト](/docs/ja/cloud-environments#setup-scripts) にインストールします。
 
-実行中のクラウドスレッドが claude.ai/code でどのコネクタを持っているかを確認するには、スレッドを開き、メッセージボックスの横の **+** メニューから **コネクタ** を選択します。コネクタをそこでオフにすると、そのスレッドから削除され、アカウントのデフォルトとして保存されます。そのため、新しいスレッドと claude.ai チャットは、再度オンにするまでそれなしで開始します。クラウドスレッドは、送信後のメッセージで追加または再接続したコネクタを取得します。
+実行中のクラウドスレッドが claude.ai/code でどのコネクタを持っているかを確認するには、スレッドを開き、メッセージボックスの横の **+** メニューから **コネクタ** を選択します。コネクタをそこでオフにすると、そのスレッドから削除され、アカウントのデフォルトとして保存されます。そのため、新しいスレッドと claude.ai チャットは、再度オンにするまでそれなしで開始します。クラウドスレッドは、追加または再接続したコネクタを、次にそのスレッドへメッセージを送信した後に取得します。
 
 <h2 id="project-settings-reference">
```

</details>

<details>
<summary>cloud-environments-ja.md</summary>

```diff
diff --git a/docs-ja/pages/cloud-environments-ja.md b/docs-ja/pages/cloud-environments-ja.md
index 5938fcb..e49a726 100644
--- a/docs-ja/pages/cloud-environments-ja.md
+++ b/docs-ja/pages/cloud-environments-ja.md
@@ -123,5 +123,5 @@ Anthropic ホスト型環境では、セッションは環境の値をセッシ
 <Steps>
   <Step title="環境のネットワークシークレットを開く">
-    [claude.ai/code](https://claude.ai/code) で [環境を編集用に開きます](#configure-your-environment)。**環境を編集** ダイアログで、**ネットワークシークレット** セクションを見つけます。環境に既にあるシークレットが表示され、それぞれが適用されるホストが表示されます。
+    [claude.ai/code](https://claude.ai/code) で [環境を編集用に開きます](#configure-your-environment)。**クラウド環境を編集** ダイアログで、**ネットワークシークレット** セクションを見つけます。環境に既にあるシークレットが表示され、それぞれが適用されるホストが表示されます。
   </Step>
 
@@ -560,5 +560,5 @@ apt update && apt install -y shellcheck
 `matcher` はフックを `startup` および `resume` イベントに制限し、`$CLAUDE_PROJECT_DIR` はリポジトリルートに解決されるため、フックはセッションの作業ディレクトリに関係なくスクリプトを見つけます。
 
-次に、`scripts/install_pkgs.sh` でスクリプトを作成します。クラウドの外では直ちに終了し、依存関係をインストールします。
+次に、`scripts/install_pkgs.sh` でスクリプトを作成します。クラウドの外では直ちに終了し、依存関係をインストールします。`package.json`、`package-lock.json`、およびスクリプト自体が前回のインストール成功以降変更されていない間は、`npm install` をスキップします。
 
 ```bash theme={null}
@@ -569,5 +569,16 @@ if [ "$CLAUDE_CODE_REMOTE" != "true" ]; then
 fi
 
-npm install
+cd "$CLAUDE_PROJECT_DIR" || exit 1
+hashes=node_modules/.install_pkgs.sha256
+
+if ! sha256sum --check --status "$hashes" 2>/dev/null; then
+  # Delete the old hashes first, so a failed install runs again next time
+  rm -f "$hashes"
+  if npm install; then
+    sha256sum scripts/install_pkgs.sh package.json package-lock.json > "$hashes" || rm -f "$hashes"
```

</details>

<details>
<summary>code-review-ja.md</summary>

```diff
diff --git a/docs-ja/pages/code-review-ja.md b/docs-ja/pages/code-review-ja.md
index a2d011d..f6499a5 100644
--- a/docs-ja/pages/code-review-ja.md
+++ b/docs-ja/pages/code-review-ja.md
@@ -5,433 +5,139 @@
 # Code Review
 
-> マルチエージェント分析を使用してコードベース全体を検査し、ロジックエラー、セキュリティ脆弱性、リグレッションを検出する自動化された PR レビューを設定します
+> Code Review で GitHub のプルリクエストのバグを検出します。Claude が各変更をレビューし、結果を検証して、インラインでコメントします。Team および Enterprise プラン向けです
 
-<Note>
-  Code Review はリサーチプレビュー段階であり、[Team および Enterprise](https://claude.ai/admin-settings/claude-code) サブスクリプションで利用可能です。[Zero Data Retention](/docs/ja/zero-data-retention) が有効になっている組織や [HIPAA 設定](/docs/ja/hipaa-setup)が適用されている組織では利用できず、Anthropic の BAA の対象外です。その他のプランでは、`/code-review` コマンドを使用して[ローカルで差分をレビュー](#review-a-diff-locally)することができます。
-</Note>
-
-Code Review は GitHub プルリクエストを分析し、コードの問題が見つかった行にインラインコメントとして結果を投稿します。特化したエージェントのフリートがコード変更をコードベース全体のコンテキストで検査し、ロジックエラー、セキュリティ脆弱性、壊れたエッジケース、微妙なリグレッションを探します。
-
-結果は重大度でタグ付けされ、PR を承認またはブロックしないため、既存のレビューワークフローはそのまま機能します。リポジトリに `CLAUDE.md` または `REVIEW.md` ファイルを追加することで、Claude がフラグを立てる内容をカスタマイズできます。
-
-Claude を管理サービスではなく独自の CI インフラストラクチャで実行する場合は、[GitHub Actions](/docs/ja/github-actions) または [GitLab CI/CD](/docs/ja/gitlab-ci-cd) を参照してください。自己ホスト型 GitHub インスタンス上のリポジトリについては、[GitHub Enterprise Server](/docs/ja/github-enterprise-server) を参照してください。
+Code Review を使用すると、Claude が GitHub リポジトリのプルリクエストをレビューします。複数のエージェントが各変更を周囲のコードとあわせて読み込み、ロジックエラー、セキュリティ脆弱性、壊れたエッジケースなどの問題を探します。検証ステップでは、結果を報告する前にコードと照らし合わせて確認します。
 
-このページでは以下をカバーしています：
+結果は該当する行へのインラインコメントとして届き、[重大度](/docs/ja/code-review-pull-requests#severity-levels)でランク付けされ、プルリクエストには概要とチェック実行が追加されます。レビューがプルリクエストを承認またはブロックすることはないため、マージの判断はチームに委ねられたままです。
 
-* [レビューの仕組み](#how-reviews-work)
-* [セットアップ](#set-up-code-review)
-* [`@claude review` と `@claude review always` を使用した](#manually-trigger-reviews)レビューの手動トリガー
-* [`CLAUDE.md` と `REVIEW.md` を使用した](#customize-reviews)レビューのカスタマイズ
-* [料金](#pricing)
-* [トラブルシューティング](#troubleshooting)失敗した実行と欠落したコメント
```

</details>

*...以降省略*

</details>


<details>
<summary>2026-10-15</summary>

**変更ファイル:**

```
 docs-ja/pages/agent-teams-ja.md                    |    3 +-
 docs-ja/pages/agent-view-ja.md                     |    2 +-
 docs-ja/pages/amazon-bedrock-ja.md                 |    8 +-
 docs-ja/pages/artifacts-ja.md                      |    7 +-
 docs-ja/pages/changelog.md                         |  284 ++++++
 docs-ja/pages/claude-apps-gateway-config-ja.md     |    4 +-
 docs-ja/pages/claude-code-on-the-web-ja.md         |   11 +-
 docs-ja/pages/claude-directory-ja.md               |    2 +-
 docs-ja/pages/claude-platform-on-aws-ja.md         |    2 +-
 docs-ja/pages/claude-projects-ja.md                |    3 +-
 docs-ja/pages/cloud-environments-ja.md             |   60 +-
 docs-ja/pages/commands-ja.md                       |   12 +-
 docs-ja/pages/common-workflows-ja.md               |    4 +-
 docs-ja/pages/context-window-ja.md                 |    2 +-
 docs-ja/pages/corporate-launcher-ja.md             |    1 +
 docs-ja/pages/debug-your-config-ja.md              |    2 +-
 docs-ja/pages/desktop-ja.md                        |  322 +++++-
 docs-ja/pages/env-vars-ja.md                       |   11 +-
 docs-ja/pages/errors-ja.md                         | 1033 +++++++++++--------
 docs-ja/pages/feature-availability-ja.md           |    2 +-
 docs-ja/pages/github-enterprise-server-ja.md       |   36 +-
 docs-ja/pages/google-vertex-ai-ja.md               |    4 +-
 docs-ja/pages/headless-ja.md                       |   12 +-
 docs-ja/pages/hipaa-setup-ja.md                    |    1 +
 docs-ja/pages/hooks-ja.md                          | 1071 ++++++++++----------
 docs-ja/pages/interactive-mode-ja.md               |   62 ++
 docs-ja/pages/large-codebases-ja.md                |    2 +-
 docs-ja/pages/llm-gateway-connect-ja.md            |    4 +-
 docs-ja/pages/llm-gateway-protocol-ja.md           |    5 +-
 docs-ja/pages/mcp-ja.md                            |  137 ++-
 docs-ja/pages/memory-ja.md                         |    8 +-
 docs-ja/pages/microsoft-foundry-ja.md              |    2 +-
 docs-ja/pages/model-config-ja.md                   |    1 +
 docs-ja/pages/monitoring-usage-ja.md               |   10 +-
 docs-ja/pages/network-config-ja.md                 |    2 +-
 docs-ja/pages/permission-modes-ja.md               |   19 +-
 docs-ja/pages/permissions-ja.md                    |   13 +-
 docs-ja/pages/plugin-evals-ja.md                   |   41 +-
 docs-ja/pages/prompt-caching-ja.md                 |    2 +
 docs-ja/pages/remote-control-ja.md                 |    2 +-
 docs-ja/pages/routines-ja.md                       |   36 +-
 docs-ja/pages/scheduled-tasks-ja.md                |    6 +-
 .../self-hosted-environments-configuration-ja.md   |   37 +-
 .../pages/self-hosted-environments-deploy-ja.md    |   18 +-
 docs-ja/pages/self-hosted-environments-ja.md       |    2 +-
 .../self-hosted-environments-quickstart-ja.md      |   26 +-
 .../pages/self-hosted-environments-reference-ja.md |    4 +-
 docs-ja/pages/settings-reference-ja.md             |   26 +-
 docs-ja/pages/setup-ja.md                          |    2 +-
 docs-ja/pages/skills-ja.md                         |  201 ++--
 docs-ja/pages/statusline-ja.md                     |    6 +-
 docs-ja/pages/sub-agents-ja.md                     |   55 +-
 docs-ja/pages/tools-reference-ja.md                |    6 +-
 docs-ja/pages/ultrareview-ja.md                    |    4 +-
 docs-ja/pages/vs-code-ja.md                        |   12 +-
 docs-ja/pages/web-quickstart-ja.md                 |    4 +-
 docs-ja/pages/workflows-ja.md                      |   14 +-
 57 files changed, 2347 insertions(+), 1321 deletions(-)
```

<details>
<summary>agent-teams-ja.md</summary>

```diff
diff --git a/docs-ja/pages/agent-teams-ja.md b/docs-ja/pages/agent-teams-ja.md
index 7f4436f..54ece75 100644
--- a/docs-ja/pages/agent-teams-ja.md
+++ b/docs-ja/pages/agent-teams-ja.md
@@ -271,5 +271,5 @@ Claude は通常の subagent にも独自に名前を付けるため、後でメ
 | **メールボックス** | エージェント間の通信用メッセージングシステム |
 
-各エージェントのメールボックスは `~/.claude/teams/{team-name}/inboxes/{agent-name}.json` にある JSON ファイルです。Claude Code はメールボックスファイルを読み取るときにすべてのエントリを検証します。メッセージ形式と一致しないエントリはエラーとして報告され、ファイルから削除されます。有効なメッセージは引き続き配信されます。v2.1.207 より前では、1 つの不正なメールボックスエントリが毎秒繰り返しエラーを引き起こし、ファイルを手動で削除するまでそのメールボックスの配信をブロックしていました。
+各エージェントのメールボックスは `~/.claude/teams/{team-name}/inboxes/{agent-name}.json` にある JSON ファイルです。Claude Code はメールボックスファイルを読み取るときにすべてのエントリを検証します。メッセージ形式と一致しないエントリはエラーとして報告され、ファイルから削除されます。有効なメッセージは引き続き配信されます。
 
 Claude Code は、メッセージがプレーンテキストであるか、プラン承認やシャットダウンリクエストなどの構造化プロトコルメッセージであるかに関わらず、受信者のメールボックスファイルへの書き込みが成功した場合にのみメッセージを送信済みとして報告します。ディスクがいっぱいであるか、メールボックスディレクトリが書き込み可能でないなど、書き込みが失敗した場合、送信エージェントはエラーを受け取り、何も送信されません。エラーメッセージと復旧手順については、[チームメンバーのインボックスへの書き込みに失敗しました](/docs/ja/errors#failed-to-write-to-a-teammate-inbox) を参照してください。
@@ -310,4 +310,5 @@ Claude Code は名前を付けた subagent 定義を読み取り、これらの
 * **`disallowedTools`**：インプロセスのチームメイトの場合、Claude Code は定義の `disallowedTools` にあるツールをチームメイトのツールセットから削除します。`SendMessage` と Claude Code が追加する Task ツールは、リストに記載されていても引き続き使用できます。
 * **`effort`**：インプロセスのチームメイトの場合、Claude Code は [フロントマターの effort ルール](/docs/ja/model-config#set-the-effort-level) に従って定義の [`effort`](/docs/ja/sub-agents#supported-frontmatter-fields) を適用します。
+* **`autoCompactWindow`**：インプロセスのチームメイトの場合、Claude Code は [そのフィールドのルール](/docs/ja/sub-agents#subagent-auto-compact-window) に従って定義の [`autoCompactWindow`](/docs/ja/sub-agents#supported-frontmatter-fields) を適用します。分割ペインのチームメイトはこのフィールドを無視します。Claude Code v2.1.296 以降が必要です。
 * **本体**：インプロセスチームメンバーの場合、Claude Code は定義の本体をデフォルトシステムプロンプトに追加の指示として追加します。分割ペインチームメンバーの場合、Claude Code はデフォルトシステムプロンプトの代わりに本体を使用します。
 * **`skills`**：Claude Code はどちらの表示モードでもチームメンバーに定義の `skills` を適用しません。チームメンバーはプロジェクトおよびユーザー設定から skills をロードします。
```

</details>

<details>
<summary>agent-view-ja.md</summary>

```diff
diff --git a/docs-ja/pages/agent-view-ja.md b/docs-ja/pages/agent-view-ja.md
index 6a80356..39e4e65 100644
--- a/docs-ja/pages/agent-view-ja.md
+++ b/docs-ja/pages/agent-view-ja.md
@@ -39,5 +39,5 @@ Claude が複数の独立したタスクに対して、あなたが毎ステッ
     まだディレクトリの[ワークスペーストラストダイアログ](/docs/ja/permissions#project-allow-rules-and-workspace-trust)を受け入れていない場合、Claude Code はエージェントビューが開く前にそれを表示します。これは `claude` が表示するのと同じダイアログです。受け入れてワークスペースの信頼を保存して続行します。拒否すると、Claude Code はエージェントビューを開かずに終了します。
 
-    エージェントビューが開き、下部に入力フィールドが表示され、セッションが開始されるとテーブルが埋まります。いつでも `Esc` を押してシェルに戻ります。`←` でセッションをバックグラウンドにして開いた場合、`Esc` はそのセッションの会話に戻ります。セッションは離れている間も実行し続け、次にエージェントビューを開いたときに再度表示されます。
+    エージェントビューが開き、下部に入力フィールドが表示され、セッションが開始されるとテーブルが埋まります。`Esc` を押すとシェルに戻ります。`←` でセッションをバックグラウンドにしてエージェントビューを開いた場合、`Esc` はそのセッションの会話に戻ります。セッションは離れている間も実行し続け、次にエージェントビューを開いたときに再度表示されます。
   </Step>
 
```

</details>

<details>
<summary>amazon-bedrock-ja.md</summary>

```diff
diff --git a/docs-ja/pages/amazon-bedrock-ja.md b/docs-ja/pages/amazon-bedrock-ja.md
index 28dc65f..e8b0218 100644
--- a/docs-ja/pages/amazon-bedrock-ja.md
+++ b/docs-ja/pages/amazon-bedrock-ja.md
@@ -220,5 +220,5 @@ export AWS_BEARER_TOKEN_BEDROCK=your-bedrock-api-key
 </h4>
 
-Claude Code は AWS デフォルト認証情報プロバイダーチェーンを 1 回解決し、解決された認証情報をメモリに保持します。認証情報の有効期限の 5 分前まで、または有効期限がない場合は 1 時間の間、それらを再利用するため、SSO でサポートされたプロファイルは認証情報の有効期間ごとに約 1 回 IAM Identity Center から認証情報をリクエストします。API からの認証情報エラーはキャッシュをクリアし、再試行は新しい認証情報を解決します。Claude Code v2.1.207 以降が必要です。
+Claude Code は AWS デフォルト認証情報プロバイダーチェーンを 1 回解決し、解決された認証情報をメモリに保持します。認証情報の有効期限の 5 分前まで、または有効期限がない場合は 1 時間の間、それらを再利用するため、SSO でサポートされたプロファイルは認証情報の有効期間ごとに約 1 回 IAM Identity Center から認証情報をリクエストします。API からの認証情報エラーはキャッシュをクリアし、再試行は新しい認証情報を解決します。
 
 キャッシュはこのステップの冒頭に挙げたすべての認証情報の方法をカバーしていますが、Amazon Bedrock API キーはプロバイダーチェーンを使用しないため除外されます。代わりにすべてのリクエストでチェーンを解決するには、[`CLAUDE_CODE_SKIP_AWS_CRED_CACHE=1`](/docs/ja/env-vars) を設定してください。
@@ -277,5 +277,5 @@ Claude Code は AWS SSO および企業 ID プロバイダーの自動認証情
 `Expiration` はオプションです。コマンドが有効な ISO 8601 `Expiration` を返すと、Claude Code はその時刻の 5 分前まで認証情報をキャッシュします。それがない場合、認証情報は 1 時間キャッシュされます。
 
-`awsCredentialExport` を `awsAuthRefresh` なしで設定する場合、Claude Code はエクスポートされた認証情報を直接使用し、スタートアップで AWS デフォルト認証情報プロバイダーチェーンを再解決しません。Claude Code v2.1.206 以降が必要です。
+`awsCredentialExport` を `awsAuthRefresh` なしで設定する場合、Claude Code はエクスポートされた認証情報を直接使用し、スタートアップで AWS デフォルト認証情報プロバイダーチェーンを再解決しません。
 
 <h3 id="3-configure-claude-code">
@@ -359,8 +359,8 @@ export ANTHROPIC_DEFAULT_HAIKU_MODEL='us.anthropic.claude-haiku-4-5-20251001-v1:
 
 <Warning>
-  Opus モデルは Sonnet モデルより高いトークンあたりの価格を持つため、プライマリモデルをピンしないデプロイメントは v2.1.207 以降に更新されると Opus レートで請求されます。Sonnet 4.5 をプライマリモデルとして保持するには、`ANTHROPIC_MODEL` をその完全なモデル ID に設定してください。`ANTHROPIC_DEFAULT_SONNET_MODEL` で操舵され、`ANTHROPIC_DEFAULT_OPUS_MODEL` を設定しないデプロイメントは、操舵された Sonnet モデルをデフォルトとして保持します。
+  Opus モデルは Sonnet モデルよりトークンあたりの価格が高いため、プライマリモデルをピンしない場合は Opus のレートで請求されます。Sonnet 4.5 をプライマリモデルとして使用するには、`ANTHROPIC_MODEL` をその完全なモデル ID に設定してください。`ANTHROPIC_DEFAULT_SONNET_MODEL` でデフォルトを指定し、`ANTHROPIC_DEFAULT_OPUS_MODEL` を設定していないデプロイでは、指定した Sonnet モデルがデフォルトとして維持されます。
 </Warning>
 
-v2.1.280 より前では、Amazon Bedrock のプライマリモデルは Opus 5 にデフォルト設定され、`opus` エイリアスは v2.1.219 から Opus 5 に解決されました。v2.1.207 から v2.1.218 では、Amazon Bedrock のプライマリモデルは Opus 4.8 にデフォルト設定され、`opus` エイリアスは Opus 4.8 に解決されました。v2.1.207 より前では、プライマリモデルは Sonnet 4.5 にデフォルト設定され、`opus` エイリアスは Opus 4.6 に解決され、バックグラウンドタスクは常にプライマリモデルを使用していました。
+v2.1.280 より前では、Amazon Bedrock のプライマリモデルは Opus 5 にデフォルト設定され、`opus` エイリアスは v2.1.219 から Opus 5 に解決されました。v2.1.207 から v2.1.218 では、Amazon Bedrock のプライマリモデルは Opus 4.8 にデフォルト設定され、`opus` エイリアスは Opus 4.8 に解決されました。
 
 モデルをさらにカスタマイズするには、以下のいずれかの方法を使用してください。
```

</details>

<details>
<summary>artifacts-ja.md</summary>

```diff
diff --git a/docs-ja/pages/artifacts-ja.md b/docs-ja/pages/artifacts-ja.md
index 5329b71..9b4c658 100644
--- a/docs-ja/pages/artifacts-ja.md
+++ b/docs-ja/pages/artifacts-ja.md
@@ -79,6 +79,9 @@ Claude が公開できないと応答した場合、またはリンクなしで
 | 入力したプロンプトではなく、セッション内で実行された[スケジュールタスク](/docs/ja/scheduled-tasks)によって開始されたターンで Claude が公開する | 各アーティファクトの最初の公開前に確認する |
 | Claude がユーザーの承認なしではファイルを読み取れない | 公開前に確認する。`Artifact` ツールの許可ルールがあっても、このプロンプトはスキップされない |
+| [Manual](/docs/ja/permission-modes) モードまたは `acceptEdits` モードで、Claude がユーザーの承認なしでは編集できないアーティファクトのファイル（Manual モードでのプロジェクトファイルなど）に小さな変更を加える | 変更を公開する前に確認する。ファイルの編集にはユーザーの承認が必要なため、`Artifact` ツールが許可ルールの対象になっていても確認される |
 
-Claude は、セッションの[作業ディレクトリ](/docs/ja/permissions#working-directories)内のファイルと、ページを書き込む一時ディレクトリ内のファイルを確認なしで読み取ります。別のフォルダからプロンプトなしで公開できるようにするには、起動時に [`--add-dir`](/docs/ja/cli-reference#cli-flags) を使用するか、セッション中に `/add-dir` を使用して、そのフォルダを作業ディレクトリとして追加します。
+[作業ディレクトリ](/docs/ja/permissions#working-directories)外のファイルをユーザーの承認なしで Claude が読み取れるようにするには、起動時に [`--add-dir`](/docs/ja/cli-reference#cli-flags) を使用するか、セッション中に `/add-dir` を使用して、そのフォルダを作業ディレクトリとして追加します。Claude は、これらのディレクトリ内のファイルと、ページを書き込む一時ディレクトリ内のファイルを、確認なしですでに読み取ります。
+
+公開のプロンプトに `Also makes 1 edit to that file on disk.` のような文が含まれている場合、Claude はアーティファクトのファイルの変更と公開を 1 つのステップで行います。プロンプトを承認すると、Claude Code はページを公開してから、変更をファイルに書き込みます。
 
 <h2 id="update-an-artifact">
@@ -189,5 +192,5 @@ Claude Code v2.1.228 以降が必要です。[フィーチャーフラグ取得]
 [権限モード](/docs/ja/permission-modes)によって、送信されたコメントが到着したときに Claude が何をするかが決まります。
 
-* **Claude が自動で返信する**：権限モードで Claude が確認を求めずに返信を投稿できる場合、Claude はスレッドを読んで返信し、コメントが変更を求めている場合はアーティファクトを編集します。`Auto-replied to comment thread on Artifact: <name>` または `Auto-edited Artifact: <name> in response to a comment thread` が表示されます。
+* **Claude が自動で返信する**：権限モードで Claude が確認を求めずに返信を投稿できる場合、Claude はスレッドを読んで返信します。`Auto-replied to comment thread on Artifact: <name>` が表示されます。
 * **Claude があなたを待つ**：プランモード外で、返信の投稿に承認が必要な場合、`Comments are waiting on Artifact: <name>` が表示されます。その後、Claude はスレッドを読む承認を求め、返信を投稿する承認を再度求めます。
 * **Claude がプランモードで一時停止する**：`Comments are waiting on Artifact: <name>` が表示され、Claude はプランモードを終了して読んで返信するよう求めるまで返信しません。
```

</details>

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index e0d7e4b..9e599aa 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,288 @@
 # Changelog
 
+## 2.1.300
+
+- Added `virtualText` to a mod's prompt decorations: text drawn in the prompt box that never enters the draft or the submitted prompt
+- Added `cache_creation_5m_tokens` and `cache_creation_1h_tokens` to the OpenTelemetry `api_request` event, splitting cache writes by lifetime
+- Added `$.ui.view({ agentId })` for mods: shows an agent's transcript in the main view when you ask, and `$.ui.view({})` goes back
+- Added a `dir` prop on a mod's `Text` for right-to-left text: on Windows and in VS Code's terminal its rows read in that direction and sit flush right
+- Added `/advisor` on Claude Platform on AWS; no advisor runs until you pick one with `/advisor`, `advisorModel` or `--advisor`, and `CLAUDE_CODE_DISABLE_ADVISOR_TOOL=1` turns it off
+- Added OpenTelemetry GenAI semantic-convention attributes to trace spans, such as `gen_ai.provider.name`, `gen_ai.conversation.id`, `gen_ai.tool.name` and `error.type`
+- Added support for rewriting a workflow agent's `prompt` and `model` in the `agent.spawn` mod hook, which could only refuse workflow agents before
+- Added the `prompt.change` mod hook, raised when the prompt box's text changes without a typed edit: a recalled history entry, a clear, an undo, or a plugin's fill
+- Fixed cloud sessions telling Claude that an organization policy blocked a host when the session's own network settings did
+- Fixed `/autocompact` warning about high token usage when you choose a smaller auto-compact window
+- Fixed SessionEnd hooks sometimes not running when you exit while a background command is still running
+- Fixed `claude --help` naming a removed tool in its description of `--restricted`
+- Fixed `claude agents` not refreshing any pull request's status when the data for one of them came back incomplete
+- Fixed Claude being told a background agent was lost, not resumable, after a cloud session's container was replaced, when the agent had already been resumed once
+- Fixed subagents you had typed messages to disappearing from `/tasks` shortly after finishing, leaving no way back to the conversation
+- Fixed a completed parent agent dropping off the breadcrumb (its child shown re-rooted at top level) while you were viewing the child
+- Fixed the agents view taking a typed word such as "up", "down" or "escape" for that key when input arrived in a burst, which could move the peek mid-reply or clear a draft
+- Fixed automatic tool search (`ENABLE_TOOL_SEARCH=auto`) turning off part-way through a conversation, for example while MCP servers reconnect after a resume
+- Fixed a login refused by `forceLoginOrgUUID` leaving the refused organization's token stored, or live after `/login`
+- Fixed the diff view in Claude Desktop and Remote Control sessions not noticing a conflicted cherry-pick or revert in reftable repositories
+- Fixed the Artifact tool's verbose and ctrl+o line reading `Artifact("(unprintable path)")` while a call's input arrives; its row now shows "Waiting…" and "Running…" as Bash's does
```

</details>

<details>
<summary>claude-apps-gateway-config-ja.md</summary>

```diff
diff --git a/docs-ja/pages/claude-apps-gateway-config-ja.md b/docs-ja/pages/claude-apps-gateway-config-ja.md
index eb58671..4abfec4 100644
--- a/docs-ja/pages/claude-apps-gateway-config-ja.md
+++ b/docs-ja/pages/claude-apps-gateway-config-ja.md
@@ -783,5 +783,5 @@ admin:
 | フィールド | 必須 | 説明 |
 | - | - | - |
-| `fail_closed_on_error` | いいえ | デフォルト `false`。支出強制は Postgres 停止時にフェイルオープンするため、推論は稼働し続けます。`true` に設定するとフェイルクローズになります：キャップを超えたデベロッパーはブロックされますが、ストアに到達できない場合は他のすべてのユーザーもブロックされます。[`admin:`](#admin) ブロックが必要です：支出強制は `admin` が設定されている場合にのみ実行され、`admin` ブロックなしでこれを `true` に設定するとゲートウェイは起動を拒否します。 |
+| `fail_closed_on_error` | いいえ | デフォルトは `false`。Postgres の障害時には支出制限の適用はフェイルオープンになり、推論は継続します。フェイルクローズにするには `true` に設定します。上限超過の開発者はブロックされますが、ストアに到達できない場合は他の全員もブロックされます。[`admin:`](#admin) ブロックが必要です。支出制限の適用は `admin` が設定されている場合にのみ実行され、これなしでこの値を `true` に設定するとゲートウェイは起動を拒否します。 |
 
 <h3 id="pricing">
@@ -1073,5 +1073,5 @@ Claude Code は、モデル選択設定や数値制限など、配信された `
 ゲートウェイの [テレメトリ](#telemetry) 設定は `OTEL_EXPORTER_OTLP_ENDPOINT` をプッシュするため、`telemetry.forward_to` を設定すると各インタラクティブクライアントでダイアログが表示されます。このダイアログは、侵害されたゲートウェイや悪意のあるゲートウェイからデベロッパーのマシンを保護するものであり、デベロッパーから組織を保護するものではありません。
 
-`claude -p`、Agent SDK のセッション、Claude Desktop の Code タブのセッションなどの [非対話型の実行](/docs/ja/server-managed-settings#security-approval-dialogs) では、ダイアログを表示できません。プッシュされた設定はその実行にのみ適用され、承認済みとして記録されないため、開発者の次の対話型セッションでは引き続きダイアログが表示されます。v2.1.207 より前は、非対話型の実行で設定が承認済みとして保存され、以降の対話型セッションでそれらについてダイアログが表示されることはありませんでした。
+`claude -p`、Agent SDK セッション、Claude Desktop の Code タブのセッションなどの[非インタラクティブ実行](/docs/ja/server-managed-settings#security-approval-dialogs)では、ダイアログを表示できません。その実行に限りプッシュされた設定を適用し、承認済みとして記録しないため、開発者の次のインタラクティブセッションでは引き続きダイアログが表示されます。
 
 デベロッパーが拒否した場合、Claude Code はポリシーを適用せずにそのセッションを終了します。そのため、新しいフックやダイアログが表示される env 変数を広範なポリシーにプッシュすると、マッチするすべてのデベロッパーのインタラクティブセッションでダイアログが表示されます。実行中のインタラクティブセッションでは次の 1 時間ごとのポーリング時に表示され、それ以外の場合はデベロッパーの次のインタラクティブ起動時に表示されます。
```

</details>

<details>
<summary>claude-code-on-the-web-ja.md</summary>

```diff
diff --git a/docs-ja/pages/claude-code-on-the-web-ja.md b/docs-ja/pages/claude-code-on-the-web-ja.md
index 0386ffc..d84c1de 100644
--- a/docs-ja/pages/claude-code-on-the-web-ja.md
+++ b/docs-ja/pages/claude-code-on-the-web-ja.md
@@ -168,5 +168,5 @@ CCR_FORCE_BUNDLE=1 claude --cloud "Run the test suite and fix any failures"
 * バンドルされたリポジトリは 100 MB 未満である必要があります。より大きなリポジトリは現在のブランチのみをバンドルすることにフォールバックし、その後ワーキングツリーの単一の圧縮スナップショットにフォールバックし、スナップショットがまだ大きすぎる場合のみ失敗します
 * 追跡されていないファイルは含まれません。クラウドセッションが見るべきファイルで `git add` を実行します
-* macOS、Linux、WSL では、Claude Code は属性ルールがファイルに適用される方法に影響する git 設定（インクルードされた設定ファイルで設定された `core.attributesFile` など）に従うことができない場合、アップロードを拒否します。[拒否メッセージ](/docs/ja/errors#the-repository-upload-cant-follow-a-git-setting)は設定と修正に名前を付けます
+* macOS、Linux、WSL では、Claude Code は属性ルールがファイルに適用される方法に影響する git 設定（インクルードされた設定ファイルで設定された `core.attributesFile` など）に従うことができない場合、アップロードを拒否します。[拒否メッセージ](/docs/ja/errors#the-repository-upload-cant-follow-a-git-setting)は設定と修正方法を示します
 * バンドルから作成されたセッションは、[GitHub 接続](#github-authentication-options)がそのリポジトリへのプッシュアクセスを持つ場合にのみ、GitHub リモートにプッシュバックできます
 
@@ -299,5 +299,5 @@ Claude Code はこれらの差分を raw git blob コンテンツから計算す
 クラウドセッションは[組み込みコマンド](/docs/ja/commands)をサポートしており、テキスト出力を生成します。ターミナルインターフェイスでのみ実行されるコマンド（`/plugin` や `/resume` など）は利用できません。ターミナルでピッカーまたはパネルを開くコマンドはクラウドセッションで異なる動作をします：
 
-* **`/model`、`/effort`、`/color`、`/rename`**：ターミナルピッカーまたはスライダーを開く代わりに、引数として値を渡します。例えば `/model sonnet` のように使用します。引数形式はセッションの環境で Claude Code v2.1.205 以降が必要であり、各コマンドの[利用可能性に関する注記](/docs/ja/commands#all-commands)に従います。
+* **`/model`、`/effort`、`/color`、`/rename`**：ターミナルピッカーまたはスライダーを開く代わりに、引数として値を渡します。例えば `/model sonnet` のように使用します。引数形式は各コマンドの[利用可能性に関する注記](/docs/ja/commands#all-commands)に従います。
 * **`/fast`**：アカウントで[利用可能な場合](/docs/ja/fast-mode#requirements)、セッションの[ファストモード](/docs/ja/fast-mode#use-fast-mode-in-cloud-sessions)を切り替えます。セッションの環境で Claude Code v2.1.271 以降が必要です。
 * **`/config`**：ブラウザの claude.ai/code では、値を設定する代わりに Claude Code セクションの設定を開き、`key=value` を含むコマンド後のテキストは無視されます。クラウドセッションの設定を変更するには、[環境変数](/docs/ja/cloud-environments#set-environment-variables)を環境に設定するか、1 つのリポジトリを持つセッションでキーをそのリポジトリの `.claude/settings.json` にコミットします。[クラウドセッションの設定](/docs/ja/settings#settings-in-cloud-sessions)には各セッションが読み込むものが記載されています。
@@ -421,5 +421,5 @@ Claude は PR を解決する際に GitHub のレビューコメントスレッ
 * <span id="default-allowed-domains" />**ネットワークアクセス制御**：Anthropic ホスト型環境では、ネットワークアクセスはデフォルトで制限され、無効にできます。[ネットワークアクセス](/docs/ja/cloud-environments#network-access)でアクセスレベル、[デフォルト許可ドメイン](/docs/ja/cloud-environments#default-allowed-domains)、および許可リストを通過しないトラフィックを参照してください。セルフホスト型環境では、独自のネットワーク境界でセッション出力を制限します。ネットワークアクセスを無効にして実行する場合、Claude Code は Anthropic API と通信できます。これにより VM からデータが出ることを許可する可能性があります。
 * **認証情報保護**：Anthropic ホスト型環境では、git 認証情報と署名キーはサンドボックスの外に留まり、プロキシはスコープ付き認証情報で認証します。セルフホスト型環境では、デプロイメントが git 認証情報を提供します；[git を設定](/docs/ja/self-hosted-environments-deploy#configure-git)を参照してください
-* **ネットワークシークレット**：Anthropic ホスト型環境の Pro および Max プランでは、[クラウド環境に追加](/docs/ja/cloud-environments#add-network-secrets)したキーも同様にサンドボックスの外に留まり、セッションを離れた後に一致するリクエストに添付されます。セルフホスト型環境にはネットワークシークレットがなく、Team および Enterprise プランではまだ利用できません
+* **ネットワークシークレット**：Anthropic ホスト型環境では、[クラウド環境に追加](/docs/ja/cloud-environments#add-network-secrets)したキーも同様にサンドボックスの外に留まり、セッションを離れた後に一致するリクエストに添付されます。セルフホスト型環境にはネットワークシークレットはありません
 * **セキュアな分析**：コードは PR を作成する前に分離されたセッション環境内で分析および変更されます
 
@@ -473,6 +473,7 @@ v2.1.274 から v2.1.289 までは、サインインメッセージは `Claude C
 | - | - |
 | `Cloud sessions aren't available with <provider>. They run on Anthropic's infrastructure and require an Anthropic account.` | Claude Code がサードパーティプロバイダー向けに設定されています。メッセージには、`Amazon Bedrock` や `Google Vertex AI` など、設定で使用されているラベルでプロバイダー名が示されます。たとえば `CLAUDE_CODE_USE_BEDROCK` の設定を解除するなどしてそのプロバイダーの設定を削除し、Anthropic アカウントでサインインしてください（`claude auth login`）。 |
-| `Cloud sessions are disabled by your organization's policy. Contact your organization admin to enable them.` | `allow_remote_sessions` 組織ポリシーがオフになっています。 |
-| `Couldn't verify your organization's policy for cloud sessions. Check your network connection and try again.` | Claude Code が組織のポリシーを取得できなかったため、クラウドセッションが許可されていると仮定せずに送信を拒否しています。ネットワーク接続を確認して再試行してください。 |
```

</details>

*...以降省略*

</details>


<details>
<summary>2026-10-14</summary>

**変更ファイル:**

```
 docs-ja/pages/cloud-environments-ja.md   |   2 +-
 docs-ja/pages/code-review-ja.md          |   2 -
 docs-ja/pages/context-window-ja.md       |   2 +-
 docs-ja/pages/desktop-ja.md              | 246 ++++++++++++++++++++++++++++++-
 docs-ja/pages/desktop-quickstart-ja.md   |   2 +-
 docs-ja/pages/env-vars-ja.md             |  14 +-
 docs-ja/pages/feature-availability-ja.md |   6 +-
 docs-ja/pages/google-vertex-ai-ja.md     |   2 +-
 docs-ja/pages/interactive-mode-ja.md     |   2 +-
 docs-ja/pages/llm-gateway-connect-ja.md  |   2 +-
 docs-ja/pages/llm-gateway-protocol-ja.md |   2 +-
 docs-ja/pages/mcp-ja.md                  |   2 +-
 docs-ja/pages/model-config-ja.md         |   2 +
 docs-ja/pages/monitoring-usage-ja.md     |   2 +-
 docs-ja/pages/prompt-caching-ja.md       |   2 +-
 docs-ja/pages/remote-control-ja.md       |   8 +-
 docs-ja/pages/routines-ja.md             |   7 +-
 docs-ja/pages/settings-reference-ja.md   |  50 ++++++-
 docs-ja/pages/sub-agents-ja.md           |   2 +-
 docs-ja/pages/tools-reference-ja.md      |   4 +-
 20 files changed, 322 insertions(+), 39 deletions(-)
```

<details>
<summary>cloud-environments-ja.md</summary>

```diff
diff --git a/docs-ja/pages/cloud-environments-ja.md b/docs-ja/pages/cloud-environments-ja.md
index 18b1f3a..4a5212f 100644
--- a/docs-ja/pages/cloud-environments-ja.md
+++ b/docs-ja/pages/cloud-environments-ja.md
@@ -275,5 +275,5 @@ Anthropic ホスト環境では、すべての GitHub 操作は、環境の [acc
 * **API requests**：組み込み GitHub ツールからのリクエスト、および [`proxy-injected` placeholder](#work-with-github-issues-and-pull-requests) の下の `gh` からのリクエストは、実際の認証情報が置き換えられて送信されます。
 * **Push restrictions**：プロキシは、ブランチの削除と、タグなどブランチ以外のもののプッシュを拒否します。プッシュで更新できるブランチは制限しません。それを制限するには、GitHub のブランチ保護ルールまたはルールセットを使用してください。
-* **Repository scope**：プロキシは、セッションに接続されたリポジトリに対する GitHub API リクエストを処理します。他のリポジトリに対する API リクエストは、`GitHub access to` で始まり `is not enabled for this session` を含むメッセージとともに 403 を受け取ります。
+* **Repository scope**：プロキシは、セッションに接続されたリポジトリに対する GitHub API リクエストを処理します。他のリポジトリに対する API リクエストは、`GitHub access to` で始まり `is not enabled for this session` を含むメッセージとともに 403 を受け取ります。`github.com/{owner}/{repo}/archive/` または `codeload.github.com` の URL 経由で取得するソースアーカイブも、リポジトリが接続されていない場合は、パブリックリポジトリであっても同じ 403 を受け取ります。
 * **GraphQL restrictions**：プロキシは GitHub の GraphQL エンドポイントへのリクエストを、`GitHub GraphQL is not available from Claude Code sessions` で始まり REST フォールバック `gh api repos/{owner}/{repo}/...` を示すメッセージとともに 403 で拒否します。`gh pr` や `gh issue` など GraphQL を使用する `gh` サブコマンドも同じ 403 を受け取ります。制限は、提供する認証情報に関係なく、プロキシを通じたすべてのリクエストに適用されるため、設定した `GH_TOKEN` は同じ 403 を取得します。Claude はプロキシを通じて Projects v2 などの GraphQL にのみ存在する GitHub API に到達できません。
 
```

</details>

<details>
<summary>code-review-ja.md</summary>

```diff
diff --git a/docs-ja/pages/code-review-ja.md b/docs-ja/pages/code-review-ja.md
index 68c3fbc..a2d011d 100644
--- a/docs-ja/pages/code-review-ja.md
+++ b/docs-ja/pages/code-review-ja.md
@@ -156,6 +156,4 @@ Manual モードに設定されたリポジトリの高優先度 PR など、PR
 * PR は開いている必要があります
 
-リポジトリが組織に属し、その組織でのメンバーシップが非公開である場合（GitHub のデフォルト）、GitHub は Claude にメンバーとして識別されません。Claude はコメントに 👀 で反応する可能性がありますが、チームまたは組織のベース権限が書き込みアクセスを提供している場合でも、リポジトリに直接コラボレーターとして追加されていない限り、レビューは開始されません。これを修正するには、[組織のメンバーシップを公開](https://docs.github.com/en/account-and-profile/setting-up-and-managing-your-personal-account-on-github/managing-your-membership-in-organizations/publicizing-or-hiding-organization-membership)するか、リポジトリ管理者にリポジトリにコラボレーターとして追加するよう依頼してください。
-
 自動トリガーとは異なり、手動トリガーはドラフト PR で実行されます。明示的なリクエストはドラフトステータスに関係なく、今すぐレビューが必要であることを示すためです。
 
```

</details>

<details>
<summary>context-window-ja.md</summary>

```diff
diff --git a/docs-ja/pages/context-window-ja.md b/docs-ja/pages/context-window-ja.md
index 066136f..508b2d5 100644
--- a/docs-ja/pages/context-window-ja.md
+++ b/docs-ja/pages/context-window-ja.md
@@ -1623,5 +1623,5 @@ Claude Code のコンテキストウィンドウには、セッションにつ
 </h2>
 
-Claude Code はコンテキストウィンドウの制限に近づくと自動的にコンパクションを実行するため、コンテキストウィンドウがいっぱいになってもセッションが終了することはありません。自動パスはタイムラインの `/compact` ステップと同じ方法で機能します。保持される内容については、[コンテキストがいっぱいになるとき](/docs/ja/how-claude-code-works#when-context-fills-up)を参照してください。
+Claude Code はコンテキストウィンドウの制限に近づくと自動的にコンテキスト圧縮を実行するため、コンテキストウィンドウがいっぱいになってもセッションが終了することはありません。自動パスはタイムラインの `/compact` ステップと同じ方法で機能します。保持される内容については、[コンテキストがいっぱいになるとき](/docs/ja/how-claude-code-works#when-context-fills-up)を参照してください。アイドル状態のまま放置した会話を Claude Code が圧縮する場合については、[アイドル時の圧縮](/docs/ja/settings-reference#idlecompaction)を参照してください。
 
 自動パスが実行される前に対応することもできます。
```

</details>

<!-- UPDATE_LOG_END -->
