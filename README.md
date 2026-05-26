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
<summary>2026-05-26</summary>

**変更ファイル:**

```
 docs-ja/pages/claude-directory-ja.md  |  4 ++--
 docs-ja/pages/commands-ja.md          |  2 +-
 docs-ja/pages/costs-ja.md             |  8 +++++--
 docs-ja/pages/features-overview-ja.md |  2 --
 docs-ja/pages/keybindings-ja.md       | 29 +++++++++++++++-------
 docs-ja/pages/managed-mcp-ja.md       | 25 ++++++++++++-------
 docs-ja/pages/monitoring-usage-ja.md  | 16 +++++++++----
 docs-ja/pages/output-styles-ja.md     |  2 ++
 docs-ja/pages/permissions-ja.md       |  3 ++-
 docs-ja/pages/prompt-caching-ja.md    | 13 ++++++----
 docs-ja/pages/remote-control-ja.md    |  2 +-
 docs-ja/pages/settings-ja.md          |  1 +
 docs-ja/pages/skills-ja.md            | 17 ++++++++++++-
 docs-ja/pages/sub-agents-ja.md        | 45 ++++++++++++++++++++---------------
 docs-ja/pages/tools-reference-ja.md   |  4 ++--
 15 files changed, 117 insertions(+), 56 deletions(-)
```

<details>
<summary>claude-directory-ja.md</summary>

```diff
diff --git a/docs-ja/pages/claude-directory-ja.md b/docs-ja/pages/claude-directory-ja.md
index cc41673..2b3cba4 100644
--- a/docs-ja/pages/claude-directory-ja.md
+++ b/docs-ja/pages/claude-directory-ja.md
@@ -1509,4 +1509,5 @@ Windows では、`~/.claude` は `%USERPROFILE%\.claude` に解決されます
 | `backups/`                                   | 設定マイグレーション前に取得された `~/.claude.json` のタイムスタンプ付きコピー                                     |
 | `feedback-bundles/`                          | `/feedback` によってサードパーティプロバイダーに書き込まれた編集済みトランスクリプトアーカイブ。Anthropic アカウントチームに送信するため      |
+| `todos/`、`statsig/`、`logs/`                  | 古いバージョンのレガシーディレクトリ。現在は書き込まれません。スイープはコンテンツを削除してから空のディレクトリを削除します。                      |
 
 ### 削除するまで保持される
@@ -1519,5 +1520,4 @@ Windows では、`~/.claude` は `%USERPROFILE%\.claude` に解決されます
 | `stats-cache.json`     | `/usage` で表示される集計トークンおよびコスト数                                                           |
 | `remote-settings.json` | 組織の[サーバー管理設定](/ja/server-managed-settings)のキャッシュコピー。組織が設定を構成している場合のみ存在します。各起動時に更新されます。 |
-| `todos/`               | レガシーセッションごとのタスクリスト。現在のバージョンでは書き込まれません。削除しても安全です。                                       |
 
 その他の小さなキャッシュおよびロックファイルは、使用する機能に応じて表示され、削除しても安全です。
@@ -1576,5 +1576,5 @@ claude project purge ~/work/my-repo --yes
 | `~/.claude/remote-settings.json`                                                                                                                                                      | なし。次の起動時に再取得されます。               |
 | `~/.claude/debug/`、`~/.claude/plans/`、`~/.claude/paste-cache/`、`~/.claude/image-cache/`、`~/.claude/session-env/`、`~/.claude/tasks/`、`~/.claude/shell-snapshots/`、`~/.claude/backups/` | ユーザー向けのもの                       |
-| `~/.claude/todos/`                                                                                                                                                                    | なし。現在のバージョンでは書き込まれないレガシーディレクトリ。 |
+| `~/.claude/todos/`、`~/.claude/statsig/`、`~/.claude/logs/`                                                                                                                             | なし。現在のバージョンでは書き込まれないレガシーディレクトリ。 |
 
 `~/.claude.json`、`~/.claude/settings.json`、または `~/.claude/plugins/` は削除しないでください。これらは認証、設定、インストール済みプラグインを保持しています。
```

</details>

<details>
<summary>commands-ja.md</summary>

```diff
diff --git a/docs-ja/pages/commands-ja.md b/docs-ja/pages/commands-ja.md
index 29bd6dc..e0f52f1 100644
--- a/docs-ja/pages/commands-ja.md
+++ b/docs-ja/pages/commands-ja.md
@@ -125,5 +125,5 @@
 | `/ultrareview [PR]`                                                 | [ultrareview](/ja/ultrareview) を使用してクラウドサンドボックスで深い複数エージェントコードレビューを実行します。Pro と Max に 3 つの無料実行が含まれ、その後は [usage credits](https://support.claude.com/en/articles/12429409-extra-usage-for-paid-claude-plans) が必要です                                                                                                                                                                                                                                                                                                 |
 | `/upgrade`                                                          | アップグレードページを開いて、より高いプランティアに切り替えます                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
-| `/usage`                                                            | セッションコスト、プラン使用制限、およびアクティビティ統計を表示します。サブスクリプション固有の詳細については、[コスト追跡ガイド](/ja/costs#using-the-%2Fusage-command)を参照してください。`/cost` と `/stats` はエイリアスです                                                                                                                                                                                                                                                                                                                                                                  |
+| `/usage`                                                            | セッションコスト、プラン使用制限、およびアクティビティ統計を表示します。Pro、Max、Team、または Enterprise プランの場合、スキル、サブエージェント、プラグイン、MCP サーバーごとの使用状況の内訳が含まれます。詳細については、[コスト追跡ガイド](/ja/costs#using-the-%2Fusage-command)を参照してください。`/cost` と `/stats` はエイリアスです                                                                                                                                                                                                                                                                                               |
 | `/usage-credits`                                                    | 制限に達したときに作業を続行するための usage credits を構成します。以前は `/extra-usage`                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
 | `/verify`                                                           | **[スキル](/ja/skills#bundled-skills)。** プロジェクトのアプリをビルドして実行し、結果を観察することで、コード変更が期待通りに機能することを確認します。テストまたは型チェックに依存するのではなく。[アプリを実行して検証](/ja/skills#run-and-verify-your-app)を参照してください。{/* min-version: 2.1.145 */}Claude Code v2.1.145 以降が必要です                                                                                                                                                                                                                                                                          |
```

</details>

<details>
<summary>costs-ja.md</summary>

```diff
diff --git a/docs-ja/pages/costs-ja.md b/docs-ja/pages/costs-ja.md
index 9739f2d..9064823 100644
--- a/docs-ja/pages/costs-ja.md
+++ b/docs-ja/pages/costs-ja.md
@@ -18,8 +18,8 @@ Claude Code は API トークン消費によって課金されます。サブス
 
 <Note>
-  `/usage` のセッションブロックは API トークン使用量を表示し、API ユーザーを対象としています。Claude Max および Pro サブスクライバーはサブスクリプションに使用量が含まれているため、セッションコスト数値は請求目的では関連がありません。サブスクライバーは同じ画面でプラン使用量バーとアクティビティ統計を表示します。
+  `/usage` のセッションブロックは API トークン使用量を表示し、API ユーザーを対象としています。Claude Max および Pro サブスクライバーはサブスクリプションに使用量が含まれているため、セッションコスト数値は請求目的では関連がありません。サブスクライバーは同じ画面でプラン使用量バー、アクティビティ統計、および使用量の内訳を表示します。
 </Note>
 
-`/usage` コマンドは現在のセッションの詳細なトークン使用統計を提供します。ドル数値はトークン数から局所的に計算された推定値であり、実際の請求書と異なる場合があります。権限のある請求については、[Claude Console](https://platform.claude.com/usage) の使用量ページを参照してください。
+`/usage` の上部のセッションブロックは、現在のセッションの詳細なトークン使用統計を表示します。ドル数値はトークン数から局所的に計算された推定値であり、実際の請求書と異なる場合があります。権限のある請求については、[Claude Console](https://platform.claude.com/usage) の使用量ページを参照してください。
 
 ```text theme={null}
@@ -30,8 +30,12 @@ Total code changes:    0 lines added, 0 lines removed
 ```
 
+Pro、Max、Team、または Enterprise プランでは、`/usage` はプラン制限に対してカウントされるものの内訳も表示します。最近の使用量をスキル、サブエージェント、プラグイン、および個別の MCP サーバーに属性付けし、それぞれが合計のパーセンテージとして表示されます。`d` または `w` を押して、過去 24 時間と過去 7 日間を切り替えることができます。数値は概算であり、このマシン上のローカルセッション履歴から計算されるため、他のデバイスまたは claude.ai からの使用量は含まれていません。
+
 ## チームのコストを管理する
 
 Claude API を使用する場合、Claude Code ワークスペース支出の合計に対して [ワークスペース支出制限を設定](https://platform.claude.com/docs/ja/build-with-claude/workspaces#workspace-limits) できます。管理者は Console で [コストと使用状況レポートを表示](https://platform.claude.com/docs/ja/build-with-claude/workspaces#usage-and-cost-tracking) できます。
 
+Pro および Max プランでは、`/usage-credits` コマンドを使用して使用クレジットの月間支出制限を設定できます。その制限に達しても使用クレジットがまだ利用可能な場合、Claude Code はプロンプトを表示して、制限を引き上げるか削除するよう促し、CLI を離れることなく続行できるようにします。制限の変更にはアカウントの請求アクセスが必要です。
+
 <Note>
   Claude Code を Claude Console アカウントで初めて認証すると、「Claude Code」というワークスペースが自動的に作成されます。このワークスペースは、組織内のすべての Claude Code 使用量の一元化されたコスト追跡と管理を提供します。このワークスペースの API キーを作成することはできません。これは Claude Code 認証と使用量専用です。
```

</details>

<details>
<summary>features-overview-ja.md</summary>

```diff
diff --git a/docs-ja/pages/features-overview-ja.md b/docs-ja/pages/features-overview-ja.md
index 85ae42e..88093dd 100644
--- a/docs-ja/pages/features-overview-ja.md
+++ b/docs-ja/pages/features-overview-ja.md
@@ -266,6 +266,4 @@ Claude Code は、コードについて推論するモデルと、ファイル
     **コンテキストコスト：** [ツール検索](/ja/mcp#scale-with-mcp-tool-search) はデフォルトで有効になっているため、アイドル MCP ツールは最小限のコンテキストを消費します。
 
-    **信頼性に関する注記：** MCP 接続はセッション中に静かに失敗する可能性があります。サーバーが切断されると、そのツールは警告なく消えます。Claude は以前アクセスできたツールを使用しようとする可能性があります。Claude が以前アクセスできた MCP ツールを使用できなくなったことに気付いた場合は、`/mcp` で接続を確認してください。
-
     <Tip>`/mcp` を実行してサーバーごとのトークンコストを確認します。積極的に使用していないサーバーを切断します。</Tip>
   </Tab>
```

</details>

<details>
<summary>keybindings-ja.md</summary>

```diff
diff --git a/docs-ja/pages/keybindings-ja.md b/docs-ja/pages/keybindings-ja.md
index 186e886..df5334f 100644
--- a/docs-ja/pages/keybindings-ja.md
+++ b/docs-ja/pages/keybindings-ja.md
@@ -248,13 +248,24 @@ Claude Code はカスタマイズ可能なキーボードショートカット
 `DiffDialog` コンテキストで利用可能なアクション：
 
-| アクション                 | デフォルト      | 説明            |
-| :-------------------- | :--------- | :------------ |
-| `diff:dismiss`        | Escape     | Diff ビューアを閉じる |
-| `diff:previousSource` | Left       | 前の Diff ソース   |
-| `diff:nextSource`     | Right      | 次の Diff ソース   |
-| `diff:previousFile`   | Up         | Diff の前のファイル  |
-| `diff:nextFile`       | Down       | Diff の次のファイル  |
-| `diff:viewDetails`    | Enter      | Diff の詳細を表示   |
-| `diff:back`           | （コンテキスト固有） | Diff ビューアで戻る  |
+| アクション                 | デフォルト      | 説明                               |
+| :-------------------- | :--------- | :------------------------------- |
+| `diff:dismiss`        | Escape     | Diff ビューアを閉じる                    |
+| `diff:previousSource` | Left       | 前の Diff ソース                      |
+| `diff:nextSource`     | Right      | 次の Diff ソース                      |
+| `diff:previousFile`   | Up、K       | ファイルリストの前のファイル。詳細ビューで 1 行上にスクロール |
+| `diff:nextFile`       | Down、J     | ファイルリストの次のファイル。詳細ビューで 1 行下にスクロール |
+| `diff:viewDetails`    | Enter      | Diff の詳細を表示                      |
+| `diff:back`           | （コンテキスト固有） | Diff ビューアで戻る                     |
+
+Diff 詳細ビューは、ページャースタイルのキーを標準的な[スクロールアクション](#scroll-actions)にバインドします。これらのバインディングは `DiffDialog` コンテキストの一部であり、詳細ビューにのみ適用されます。[スクロールアクション](#scroll-actions)の下に記載されている `Scroll` コンテキストのデフォルトは変わりません。
+
+| アクション                 | デフォルト         | 説明                 |
+| :-------------------- | :------------ | :----------------- |
```

</details>

<details>
<summary>managed-mcp-ja.md</summary>

```diff
diff --git a/docs-ja/pages/managed-mcp-ja.md b/docs-ja/pages/managed-mcp-ja.md
index 98936f3..b2ea6fb 100644
--- a/docs-ja/pages/managed-mcp-ja.md
+++ b/docs-ja/pages/managed-mcp-ja.md
@@ -41,5 +41,5 @@ Claude Code は、さまざまな制限レベルをサポートしています
 ## managed-mcp.json による排他的制御
 
-`managed-mcp.json` ファイルをデプロイすると、Claude Code はそのファイルで定義されたサーバーのみを読み込みます。ユーザーは、プラグイン提供のサーバーや claude.ai コネクターを含む、他の MCP サーバーを追加、変更、または使用することはできません。
+`managed-mcp.json` ファイルをデプロイすると、Claude Code はそのファイルで定義されたサーバーのみを読み込みます。ユーザーは、プラグイン提供のサーバーを含む他の MCP サーバーを追加、変更、または使用することはできません。また、このファイルは [管理対象セットと共に許可する](#allow-claude-ai-connectors-alongside-the-managed-set)場合を除き、claude.ai コネクターも抑制します。
 
 2 つの他の設定は、管理対象セットをさらにフィルタリングできます。
@@ -110,4 +110,12 @@ Claude Code は、さまざまな制限レベルをサポートしています
 ユーザーは `/mcp` に MCP サーバーを表示しません。`claude mcp add` は上記のエンタープライズポリシーエラーで失敗します。ユーザーが以前に設定したサーバーは、次回セッションを開始するときに読み込みを停止します。ポリシーが理由であることについて警告はありません。
 
+### 管理対象セットと共に claude.ai コネクターを許可する
+
+`managed-mcp.json` をデプロイすると、デフォルトでは [claude.ai コネクター](/ja/mcp#use-mcp-servers-from-claude-ai)が抑制されます。これには、管理者が claude.ai 管理コンソールで組織向けに設定したコネクターも含まれます。これらのコネクターを `managed-mcp.json` 内のサーバーと共に読み込むには、[管理設定ソース](/ja/admin-setup#decide-how-settings-reach-devices)で `"allowAllClaudeAiMcps": true` を設定します。Claude Code v2.1.149 以降が必要です。
+
+この設定が有効になると、Claude Code は `managed-mcp.json` がデプロイされていない場合に読み込むのと同じ claude.ai コネクターを読み込みます。[許可リストと拒否リスト](#policy-based-control-with-allowlists-and-denylists)は引き続きこれらのコネクターに適用されるため、`deniedMcpServers` で特定のコネクターをブロックできます。この設定は claude.ai コネクターのみに影響します。プラグイン提供のサーバーは抑制されたままです。
+
+Claude Code は、この設定を管理者制御のポリシー層からのみ読み取ります。サーバー管理設定、MDM デプロイされた plist または HKLM レジストリキー、またはシステム `managed-settings.json` ファイルです。これをユーザーまたはプロジェクト設定に配置しても効果がないため、ユーザーは排他的制御が抑制したコネクターを再度有効にすることはできません。
+
 ## 許可リストとブロックリストによるポリシーベースの制御
 
@@ -322,12 +330,13 @@ Claude Code は、さまざまな制限レベルをサポートしています
 ## 設定の概要
 
-このページで説明するすべてのファイルと設定、それが制御するもの、および配信方法。
+このページで説明するすべてのファイルと設定、それが制御するもの、および配信方法：
 
```

</details>

<details>
<summary>monitoring-usage-ja.md</summary>

```diff
diff --git a/docs-ja/pages/monitoring-usage-ja.md b/docs-ja/pages/monitoring-usage-ja.md
index a625b86..96ee86b 100644
--- a/docs-ja/pages/monitoring-usage-ja.md
+++ b/docs-ja/pages/monitoring-usage-ja.md
@@ -263,4 +263,6 @@ Agent SDK および `claude -p` セッションでは、`TRACEPARENT` が環境
 ```
 
+値は、スペースを含むパスを含む実行可能ファイルへのパス、またはシェルコマンドラインと引数です。Windows では、値は常にシェルを通じて実行されるため、JSON 値内にスペースを含むパスをクォートで囲みます。
+
 #### スクリプト要件
 
@@ -273,4 +275,10 @@ echo "{\"Authorization\": \"Bearer $(get-token.sh)\", \"X-API-Key\": \"$(get-api
 ```
 
+ヘルパーが失敗するか、これらの要件を満たさない出力を出力する場合、Claude Code は以下のエラーを報告します:
+
+* `/doctor` 出力
+* [`--debug`](/ja/cli-reference#cli-flags) で実行するか、セッション内で `/debug` を実行した後のデバッグログ
+* stderr、`-p` で開始された非対話型セッション内
+
 #### リフレッシュ動作
 
@@ -530,5 +538,5 @@ Claude Code は、OpenTelemetry ログ/イベント経由で以下のイベン
 #### ツール結果イベント
 
-ツールが実行を完了するときにログされます。
+ツールが実行を完了するときにログされます。ツール呼び出しが拒否された場合は出力されません。[ツール決定イベント](#tool-decision-event)を参照してください。
 
 **イベント名**: `claude_code.tool_result`
@@ -546,6 +554,6 @@ Claude Code は、OpenTelemetry ログ/イベント経由で以下のイベン
```

</details>

*...以降省略*

</details>


<details>
<summary>2026-05-25</summary>

**変更ファイル:**

```
 docs-ja/pages/code-review-ja.md     |  6 +++++-
 docs-ja/pages/quickstart-ja.md      | 10 +++++-----
 docs-ja/pages/sandboxing-ja.md      |  1 +
 docs-ja/pages/tools-reference-ja.md |  3 ++-
 4 files changed, 13 insertions(+), 7 deletions(-)
```

<details>
<summary>code-review-ja.md</summary>

```diff
diff --git a/docs-ja/pages/code-review-ja.md b/docs-ja/pages/code-review-ja.md
index eacd4b1..2750b92 100644
--- a/docs-ja/pages/code-review-ja.md
+++ b/docs-ja/pages/code-review-ja.md
@@ -26,4 +26,8 @@ Claude を管理サービスではなく独自の CI インフラストラクチ
 * [トラブルシューティング](#troubleshooting)失敗した実行と欠落したコメント
 
+<Note>
+  GitHub アプリをインストールせずにターミナルでローカルに差分をレビューするには、任意の Claude Code セッションで [`/code-review` コマンド](/ja/commands)を実行してください。選択した努力レベルで現在の差分の正確性バグを報告し、`--comment` で結果をインライン PR コメントとして投稿できます。このコマンドは v2.1.147 より前は `/simplify` という名前でした。
+</Note>
+
 ## レビューの仕組み
 
@@ -268,5 +272,5 @@ GitHub の Checks タブの **Re-run** ボタンは Code Review を再トリガ
 Code Review は Claude Code の残りの部分と連携するように設計されています。PR を開く前にローカルでレビューを実行したい場合、自己ホスト型セットアップが必要な場合、または `CLAUDE.md` がツール全体で Claude の動作をどのように形成するかについてさらに詳しく知りたい場合、これらのページは次の良い停止点です：
 
-* [Plugins](/ja/discover-plugins): プッシュ前にローカルでオンデマンドレビューを実行するための `code-review` プラグインを含むプラグインマーケットプレイスを参照
+* [Commands](/ja/commands): ローカルの Claude Code セッションで `/code-review` を実行して、プッシュ前に差分をチェック
 * [GitHub Actions](/ja/github-actions): コードレビューを超えたカスタム自動化のための独自の GitHub Actions ワークフローで Claude を実行
 * [GitLab CI/CD](/ja/gitlab-ci-cd): GitLab パイプライン用の自己ホスト型 Claude 統合
```

</details>

<details>
<summary>quickstart-ja.md</summary>

```diff
diff --git a/docs-ja/pages/quickstart-ja.md b/docs-ja/pages/quickstart-ja.md
index ba1a22a..45f226e 100644
--- a/docs-ja/pages/quickstart-ja.md
+++ b/docs-ja/pages/quickstart-ja.md
@@ -82,14 +82,14 @@ You can also install with [apt, dnf, or apk](/en/setup#install-with-linux-packag
 ## ステップ 2：アカウントにログインする
 
-Claude Code を使用するにはアカウントが必要です。`claude` コマンドでインタラクティブセッションを開始すると、ログインが必要になります：
+Claude Code を使用するにはアカウントが必要です。`claude` コマンドでインタラクティブセッションを開始すると、初回使用時にログインするよう求められます：
 
 ```bash theme={null}
 claude
-# 初回使用時にログインするよう求められます
 ```
 
-```bash theme={null}
+Claude サブスクリプションまたは Console アカウントの場合は、プロンプトに従ってブラウザで認証を完了してください。後でアカウントを切り替えるか再認証するには、実行中のセッション内で `/login` と入力します：
+
+```text theme={null}
 /login
-# プロンプトに従ってアカウントでログインします
 ```
 
@@ -100,5 +100,5 @@ claude
 * [Amazon Bedrock、Google Vertex AI、または Microsoft Foundry](/ja/third-party-integrations)（エンタープライズクラウドプロバイダー）
 
-ログイン後、認証情報がシステムに保存され、再度ログインする必要はありません。後でアカウントを切り替えるには、`/login` コマンドを使用します。
+ログイン後、認証情報が保存され、再度ログインする必要はありません。
 
 ## ステップ 3：最初のセッションを開始する
```

</details>

<details>
<summary>sandboxing-ja.md</summary>

```diff
diff --git a/docs-ja/pages/sandboxing-ja.md b/docs-ja/pages/sandboxing-ja.md
index 920238d..bdb8acd 100644
--- a/docs-ja/pages/sandboxing-ja.md
+++ b/docs-ja/pages/sandboxing-ja.md
@@ -201,4 +201,5 @@ Claude Code は 2 つのサンドボックスモードを提供します。
 * **デフォルトの読み取り動作**：特定の拒否ディレクトリを除く、コンピュータ全体への読み取りアクセス。このデフォルトは `~/.aws/credentials` や `~/.ssh/` などの認証情報ファイルの読み取りを許可することに注意してください。これらをブロックするには、`denyRead` に追加してください。
 * **ブロックされたアクセス**：明示的な許可なしに現在の作業ディレクトリ外のファイルを変更できません。これには `~/.bashrc` などのシェル設定ファイルと `/bin/` のシステムバイナリが含まれます。
+* **Git worktrees**：作業ディレクトリが[リンクされた git worktree](/ja/worktrees)の場合、サンドボックスはメインリポジトリの共有 `.git` ディレクトリへの書き込みも許可するため、`git commit` などのコマンドが refs とインデックスを更新できます。そのディレクトリ内の `hooks/` と `config` への書き込みは引き続き拒否されます。
 * **設定可能**：設定を通じてカスタム許可パスと拒否パスを定義します
 
```

</details>

<details>
<summary>tools-reference-ja.md</summary>

```diff
diff --git a/docs-ja/pages/tools-reference-ja.md b/docs-ja/pages/tools-reference-ja.md
index f65f794..94a262f 100644
--- a/docs-ja/pages/tools-reference-ja.md
+++ b/docs-ja/pages/tools-reference-ja.md
@@ -112,6 +112,7 @@ Bash ツールは、次の永続化動作で各コマンドを別々のプロセ
   * この引き継ぎを無効にして、すべての Bash コマンドがプロジェクト ディレクトリで開始されるようにするには、`CLAUDE_BASH_MAINTAIN_PROJECT_WORKING_DIR=1` を設定します。
 * 環境変数は永続化されません。1 つのコマンドの `export` は次のコマンドでは利用できません。
+* シェル スタートアップ ファイルで定義されたエイリアスとシェル関数は利用できます。セッション開始時に、Claude Code はシェルに応じて `~/.zshrc`、`~/.bashrc`、または `~/.profile` をソースし、結果のエイリアス、関数、およびシェル オプションをキャプチャして、すべての Bash コマンドに適用します。
 
-Claude Code を起動する前に virtualenv または conda 環境をアクティブ化してください。Bash コマンド間で環境変数を永続化するには、Claude Code を起動する前に [`CLAUDE_ENV_FILE`](/ja/env-vars)をシェル スクリプトに設定するか、[SessionStart フック](/ja/hooks#persist-environment-variables)を使用して動的に設定します。
+Claude Code を起動する前に virtualenv または conda 環境をアクティブ化してください。Bash コマンド間で環境変数を永続化するには、Claude Code を起動する前に [`CLAUDE_ENV_FILE`](/ja/env-vars) をシェル スクリプトに設定するか、[SessionStart フック](/ja/hooks#persist-environment-variables)を使用して動的に設定します。
 
 2 つの制限が各コマンドを制限します：
```

</details>

</details>


<details>
<summary>2026-05-24</summary>

**変更ファイル:**

```
 docs-ja/pages/changelog.md | 4 ++++
 1 file changed, 4 insertions(+)
```

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index 1f55984..20cadc6 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,8 @@
 # Changelog
 
+## 2.1.150
+
+- Internal infrastructure improvements (no user-facing changes)
+
 ## 2.1.149
 
```

</details>

</details>


<details>
<summary>2026-05-23</summary>

**変更ファイル:**

```
 docs-ja/pages/agent-view-ja.md           |  10 +-
 docs-ja/pages/changelog.md               |  33 ++++++
 docs-ja/pages/commands-ja.md             | 186 +++++++++++++++----------------
 docs-ja/pages/env-vars-ja.md             |   2 +-
 docs-ja/pages/errors-ja.md               |  19 ++++
 docs-ja/pages/features-overview-ja.md    |   2 +-
 docs-ja/pages/glossary-ja.md             |   2 +-
 docs-ja/pages/interactive-mode-ja.md     |   1 +
 docs-ja/pages/keybindings-ja.md          |   6 +-
 docs-ja/pages/mcp-ja.md                  |   3 +
 docs-ja/pages/model-config-ja.md         |  12 +-
 docs-ja/pages/plugin-marketplaces-ja.md  |   2 +-
 docs-ja/pages/settings-ja.md             |   5 +-
 docs-ja/pages/setup-ja.md                |  35 +++---
 docs-ja/pages/skills-ja.md               |   4 +-
 docs-ja/pages/tools-reference-ja.md      |   2 +
 docs-ja/pages/troubleshoot-install-ja.md |  22 ++--
 17 files changed, 209 insertions(+), 137 deletions(-)
```

<details>
<summary>agent-view-ja.md</summary>

```diff
diff --git a/docs-ja/pages/agent-view-ja.md b/docs-ja/pages/agent-view-ja.md
index 927081d..db305cf 100644
--- a/docs-ja/pages/agent-view-ja.md
+++ b/docs-ja/pages/agent-view-ja.md
@@ -177,5 +177,5 @@ Completed
 グループ内で：
 
-* `Ctrl+T` を押してセッションをトップにピン留めします
+* `Ctrl+T` を押してセッションをトップにピン留めし、[アイドル中にそのプロセスを実行し続けます](#the-supervisor-process)
 * `Shift+↑` または `Shift+↓` を押してセッションを並べ替えます
 * `Ctrl+R` を押してセッションの名前を変更します
@@ -422,7 +422,9 @@ claude agents --settings ./ci-settings.json --add-dir ../shared-lib
 各バックグラウンドセッションは独自の Claude Code プロセスであり、ターミナルではなくスーパーバイザーによって管理されます。アクティブに作業しているセッション、入力を待機しているセッション、またはターミナルが接続されているセッションはプロセスを実行し続けます。実行中のバックグラウンドシェルコマンド、サブエージェント、ワークフロー、またはモニターはアクティブな作業としてカウントされるため、開発サーバーなどの長時間実行プロセスはセッションを生かし続けます。
 
-セッションが完了し、約 1 時間アタッチされていない状態で待機すると、スーパーバイザーはリソースを解放するためにプロセスを停止します。トランスクリプトと状態はディスク上に残り、次回アタッチ、ピーク表示、または返信するときに、スーパーバイザーは中断したところから新しいプロセスを開始します。すべてのセッションが完了し、ターミナルが接続されていない場合、スーパーバイザー自体が終了し、次回セッションをバックグラウンド化するか、エージェントビューを開くときに再度開始します。
+セッションが完了し、約 1 時間アタッチされていない状態で待機すると、スーパーバイザーはリソースを解放するためにプロセスを停止します。[`Ctrl+T`](#organize-the-list) でピン留めしたセッションは除外され、アイドル状態でもプロセスを実行し続けます。トランスクリプトと状態はディスク上に残り、次回アタッチ、ピーク表示、または返信するときに、スーパーバイザーは中断したところから新しいプロセスを開始します。すべてのセッションが完了し、ターミナルが接続されていない場合、スーパーバイザー自体が終了し、次回セッションをバックグラウンド化するか、エージェントビューを開くときに再度開始します。
 
-スーパーバイザーはディスク上にインストールされた Claude Code バイナリを監視し、通常の [自動更新プログラム](/ja/setup#auto-updates) がそれを置き換えた後、新しいバージョンに再開します。これはネットワークチェックではなく、ローカルファイルウォッチです。バックグラウンドセッションはデタッチされたプロセスであるため、再開を通じて実行し続け、新しいスーパーバイザーはそれらに再接続します。
+ホストのメモリが不足している場合、スーパーバイザーはアイドル状態の非ピン留めセッションを最初に停止し、何も解放されない場合のみアイドル状態のピン留めセッションを停止します。
+
+スーパーバイザーはディスク上にインストールされた Claude Code バイナリを監視し、通常の [自動更新プログラム](/ja/setup#auto-updates) がそれを置き換えた後、新しいバージョンに再開します。これはネットワークチェックではなく、ローカルファイルウォッチです。バックグラウンドセッションはデタッチされたプロセスであるため、再開を通じて実行し続け、新しいスーパーバイザーはそれらに再接続します。アイドル状態のピン留めセッションも新しいバージョンに再開されるため、再度アタッチすることなく更新を取得します。
 
 ### 状態が保存される場所
@@ -470,5 +472,5 @@ claude agents --settings ./ci-settings.json --add-dir ../shared-lib
 ### セッションがアタッチ後に応答が遅い
 
-セッションが完了し、約 1 時間アタッチされていない状態で待機すると、スーパーバイザーはリソースを解放するためにプロセスを停止します。アタッチすると、中断したところから新しいプロセスが開始され、少し時間がかかります。作業中または入力を待機しているセッションはこの方法で停止されることはありません。
+セッションが完了し、約 1 時間アタッチされていない状態で待機すると、スーパーバイザーはリソースを解放するためにプロセスを停止します。アタッチすると、中断したところから新しいプロセスが開始され、少し時間がかかります。作業中または入力を待機しているセッション、または[ピン留めされた](#organize-the-list)セッションはこの方法で停止されることはありません。セッションを `Ctrl+T` でピン留めして、応答性を保つことができます。
 
 ### `.claude/worktrees/` が満杯になっている
```

</details>

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index 7c01af0..1f55984 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,37 @@
 # Changelog
 
+## 2.1.149
+
+- `/usage` now shows a per-category breakdown of what's driving your limits usage — skills, subagents, plugins, and per-MCP-server cost
+- `/diff` detail view can now be scrolled with the keyboard (arrows, `j`/`k`, `PgUp`/`PgDn`, `Space`, `Home`/`End`)
+- Markdown output now renders GFM task list checkboxes (`- [ ] todo` / `- [x] done`) instead of plain bullets
+- Enterprise: added the `allowAllClaudeAiMcps` managed setting to load claude.ai cloud MCP connectors alongside `managed-mcp.json`
+- Fixed a PowerShell permission bypass: built-in `cd` functions (`cd..`, `cd\`, `cd~`, `X:`) changed the working directory undetected, letting a later command read outside the workspace
+- Fixed the sandbox write allowlist in git worktrees covering the entire main repository root instead of only the shared `.git` directory (with `hooks/` and `config` denied)
+- Fixed PowerShell prefix/wildcard allow rules (e.g. `PowerShell(dotnet.exe build *)`) not pre-approving native executables and scripts
+- Fixed a permission-analysis gap where the parser trusted stale variable-tracking values for `PWD`/`OLDPWD`/`DIRSTACK` across `cd`/`pushd`/`popd`
+- Fixed `find` in the Bash tool exhausting the macOS system file/vnode table and crashing the host on large directory trees
+- Fixed the managed-settings approval dialog leaving the terminal frozen after accepting at startup
+- Fixed `/ultraplan` and remote session creation failing with "Could not capture uncommitted changes" when the working tree has no real changes
+- Fixed `otelHeadersHelper` failing silently when the script path contains spaces; helper failures are now reported in `/doctor` and the debug log
+- Fixed the thinking spinner staying amber across tool calls and onto fresh thinking bursts
+- Fixed collapsed Bash output reporting the wrong hidden-line count for outputs with many short lines
+- Fixed slash-command argument-hint clipping trailing typed characters when the hint overflows the input box
+- Fixed argument-hint and progressive arg suggestions not appearing after Tab-completing a skill whose frontmatter `name:` differs from its directory basename
+- Fixed the status bar showing the user's baseline `/effort` setting instead of the effort level applied by skill/agent `effort:` frontmatter
+- Fixed Ctrl+O transcript view freezing at the moment it was opened instead of tailing new messages
+- Fixed editing a recalled prompt-history entry losing the edit when navigating further up/down with arrow keys
+- Fixed `/config` exit summary reporting phantom changes to auto-compact and theme when toggling unrelated settings
+- Fixed `/insights` crashing when cached session-meta files are missing optional fields
```

</details>

<details>
<summary>commands-ja.md</summary>

```diff
diff --git a/docs-ja/pages/commands-ja.md b/docs-ja/pages/commands-ja.md
index 38144a7..29bd6dc 100644
--- a/docs-ja/pages/commands-ja.md
+++ b/docs-ja/pages/commands-ja.md
@@ -23,5 +23,5 @@
 **並行して作業を実行する。** `/agents` は Claude が副次的なタスクを委譲できる[サブエージェント](/ja/sub-agents)のマネージャーを開き、`/tasks` は現在のセッションのバックグラウンドで実行されているものをリストします。`/background` はセッション全体をデタッチして[バックグラウンドエージェント](/ja/agent-view)として実行し続け、ターミナルを解放します。コードベース全体にまたがる大きな変更の場合、`/batch` はそれを独立したユニットに分解し、各ユニットを独自の[worktree](/ja/worktrees)で実行します。これらのアプローチがどのように関連しているかについては、[エージェントを並行して実行する](/ja/agents)を参照してください。
 
-**リリース前。** `/diff` は変更内容を表示し、`/simplify` は最近のファイルをレビューして品質と効率の修正を適用し、`/review` または `/security-review` はより深い読み取り専用パスを提供します。
+**リリース前。** `/diff` は変更内容を表示し、`/code-review` は diff の正確性のバグをチェックし、`/review` または `/security-review` はより深い読み取り専用パスを提供します。
 
 **セッション間。** `/clear` は新しいタスクで新しく開始しながらプロジェクトメモリを保持します。`/resume` と `/branch` を使用して、以前の会話に戻るか、フォークできます。`/teleport` はウェブセッションをこのターミナルに引き込み、`/remote-control` を使用してこのローカルセッションを別のデバイスから続行できます。
@@ -39,96 +39,96 @@
 </Note>
 
-| コマンド                                            | 目的                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
-| :---------------------------------------------- | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
-| `/add-dir <path>`                               | 現在のセッション中にファイルアクセス用の作業ディレクトリを追加します。ほとんどの `.claude/` 設定は追加されたディレクトリから[検出されません](/ja/permissions#additional-directories-grant-file-access-not-configuration)。後で `--continue` または `--resume` を使用して、追加されたディレクトリからセッションを再開できます                                                                                                                                                                                                                                                                                       |
-| `/agents`                                       | [エージェント](/ja/sub-agents)設定を管理します                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
-| `/autofix-pr [prompt]`                          | 現在のブランチの PR を監視し、CI が失敗するか、レビュアーがコメントを残したときに修正をプッシュする [Claude Code on the web](/ja/claude-code-on-the-web#auto-fix-pull-requests) セッションを生成します。`gh pr view` で開いている PR を検出します。別の PR を監視するには、最初にそのブランチをチェックアウトしてください。デフォルトでは、リモートセッションはすべての CI 失敗とレビューコメントを修正するよう指示されます。プロンプトを渡して異なる指示を与えることができます。例えば `/autofix-pr only fix lint and type errors`。`gh` CLI と [Claude Code on the web](/ja/claude-code-on-the-web#who-can-use-claude-code-on-the-web) へのアクセスが必要です                                                  |
-| `/batch <instruction>`                          | **[スキル](/ja/skills#bundled-skills)。** コードベース全体にわたる大規模な変更を並列で調整します。コードベースを調査し、作業を 5 ～ 30 個の独立したユニットに分解し、計画を提示します。承認されると、分離された [git worktree](/ja/worktrees) 内の各ユニットごとに 1 つのバックグラウンドサブエージェントを生成します。各サブエージェントはそのユニットを実装し、テストを実行し、プルリクエストを開きます。git リポジトリが必要です。例: `/batch migrate src/ from Solid to React`                                                                                                                                                                                                         |
-| `/branch [name]`                                | この時点で現在の会話のブランチを作成します。ブランチに切り替え、元の会話を保持します。`/resume` で戻ることができます。エイリアス: `/fork`。[`CLAUDE_CODE_FORK_SUBAGENT`](/ja/env-vars) が設定されている場合、`/fork` は代わりに[フォークされたサブエージェント](/ja/sub-agents#fork-the-current-conversation)を生成し、このコマンドのエイリアスではなくなります                                                                                                                                                                                                                                                                    |
-| `/btw <question>`                               | 会話に追加せずに[サイドクエスチョン](/ja/interactive-mode#side-questions-with-%2Fbtw)として素早く質問します                                                                                                                                                                                                                                                                                                                                                                                                                                |
-| `/chrome`                                       | [Chrome の Claude](/ja/chrome) 設定を構成します                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
-| `/claude-api [migrate\|managed-agents-onboard]` | **[スキル](/ja/skills#bundled-skills)。** プロジェクトの言語（Python、TypeScript、Java、Go、Ruby、C#、PHP、または cURL）と Managed Agents リファレンス用の Claude API リファレンス資料を読み込みます。ツール使用、ストリーミング、バッチ、構造化出力、および一般的な落とし穴をカバーしています。また、コードが `anthropic` または `@anthropic-ai/sdk` をインポートするときに自動的にアクティブになります。`/claude-api migrate` を実行して、既存の Claude API コードを新しいモデルにアップグレードします。Claude はスキャンするファイルとターゲットモデルを尋ね、モデル ID、思考設定、およびバージョン間で変更されたその他のパラメータを更新します。`/claude-api managed-agents-onboard` を実行して、新しい Managed Agent をゼロから作成するインタラクティブなウォークスルーを実施します |
-| `/clear [name]`                                 | 空のコンテキストで新しい会話を開始します。前の会話は `/resume` で利用可能なままです。前の会話にラベルを付けるために名前を渡します。`/resume` ピッカーで。同じ会話を続けながらコンテキストを解放するには、代わりに `/compact` を使用してください。エイリアス: `/reset`、`/new`                                                                                                                                                                                                                                                                                                                                                |
-| `/color [color\|default]`                       | 現在のセッションのプロンプトバーの色を設定します。利用可能な色: `red`、`blue`、`green`、`yellow`、`purple`、`orange`、`pink`、`cyan`。`default` を使用してリセットするか、引数なしで実行するとランダムな色を選択します。[リモートコントロール](/ja/remote-control)が接続されている場合、色は claude.ai/code に同期されます                                                                                                                                                                                                                                                                                              |
-| `/compact [instructions]`                       | 会話をここまで要約してコンテキストを解放します。オプションで要約のフォーカス指示を渡します。[コンパクション時にルール、スキル、メモリファイルがどのように処理されるか](/ja/context-window#what-survives-compaction)を参照してください                                                                                                                                                                                                                                                                                                                                                                     |
-| `/config`                                       | [設定](/ja/settings)インターフェースを開いて、テーマ、モデル、[出力スタイル](/ja/output-styles)、およびその他の設定を調整します。エイリアス: `/settings`                                                                                                                                                                                                                                                                                                                                                                                                          |
-| `/context [all]`                                | 現在のコンテキスト使用状況をカラーグリッドとして視覚化します。コンテキストが多いツール、メモリ肥大化、容量警告の最適化提案を表示します。[フルスクリーンモード](/ja/fullscreen)では、項目ごとの内訳はグリッドを表示したままにするために折りたたまれます。`all` を渡して展開します                                                                                                                                                                                                                                                                                                                                                           |
-| `/copy [N]`                                     | 最後のアシスタント応答をクリップボードにコピーします。数字 `N` を渡して N 番目に新しい応答をコピーします。`/copy 2` は 2 番目に新しい応答をコピーします。コードブロックが存在する場合、個別ブロックまたは完全な応答を選択するインタラクティブピッカーを表示します。ピッカーで `w` を押して、クリップボードの代わりにファイルに選択内容を書き込みます。SSH 経由で便利です                                                                                                                                                                                                                                                                                                            |
```

</details>

<details>
<summary>env-vars-ja.md</summary>

```diff
diff --git a/docs-ja/pages/env-vars-ja.md b/docs-ja/pages/env-vars-ja.md
index ecd7046..c8ddfea 100644
--- a/docs-ja/pages/env-vars-ja.md
+++ b/docs-ja/pages/env-vars-ja.md
@@ -309,5 +309,5 @@ Claude Code は起動時に環境変数を読み取るため、変更は `claude
 | `MCP_SERVER_CONNECTION_BATCH_SIZE`                      | スタートアップ中に並列接続するローカル MCP サーバー（stdio）の最大数（デフォルト：3）                                                                                                                                                                                                                                                                                                                                                                               |
 | `MCP_TIMEOUT`                                           | MCP サーバー起動のタイムアウト（ミリ秒）（デフォルト：30000、または 30 秒）                                                                                                                                                                                                                                                                                                                                                                                   |
-| `MCP_TOOL_TIMEOUT`                                      | MCP ツール実行のタイムアウト（ミリ秒）（デフォルト：100000000、約 28 時間）                                                                                                                                                                                                                                                                                                                                                                                 |
+| `MCP_TOOL_TIMEOUT`                                      | MCP ツール実行のタイムアウト（ミリ秒）（デフォルト：100000000、約 28 時間）。`.mcp.json` のサーバーごとの `timeout` フィールドはそのサーバーのこれをオーバーライドします。1000 未満の値は 1 秒にフロアされます                                                                                                                                                                                                                                                                                                |
 | `NO_PROXY`                                              | リクエストが直接発行されるドメインと IP のリスト。プロキシをバイパスします                                                                                                                                                                                                                                                                                                                                                                                        |
 | `OTEL_LOG_RAW_API_BODIES`                               | Anthropic Messages API リクエストとレスポンス JSON を `api_request_body` / `api_response_body` ログイベントとして出力します。60 KB で切り詰められたインラインボディの場合は `1` に設定するか、切り詰められていないボディをディスクに書き込み、`body_ref` パスを出力する場合は `file:<dir>` に設定します。デフォルトでは無効です。ボディには会話履歴全体が含まれます。[監視](/ja/monitoring-usage#api-request-body-event) を参照してください                                                                                                                            |
```

</details>

<details>
<summary>errors-ja.md</summary>

```diff
diff --git a/docs-ja/pages/errors-ja.md b/docs-ja/pages/errors-ja.md
index 25db665..843f4b0 100644
--- a/docs-ja/pages/errors-ja.md
+++ b/docs-ja/pages/errors-ja.md
@@ -45,4 +45,5 @@
 | `Request too large`                                                                           | [リクエストエラー](#request-too-large)                                                                |
 | `Image was too large`                                                                         | [リクエストエラー](#image-was-too-large)                                                              |
+| `Unable to resize image`                                                                      | [リクエストエラー](#unable-to-resize-image)                                                           |
 | `PDF too large` / `PDF is password protected`                                                 | [リクエストエラー](#pdf-errors)                                                                       |
 | `Extra inputs are not permitted`                                                              | [リクエストエラー](#extra-inputs-are-not-permitted)                                                   |
@@ -488,4 +489,22 @@ API Error: 400 ... image dimensions exceed max allowed size
 * 全画面ではなく、関連する領域のより厳密なスクリーンショットを撮ってください
 
+### Unable to resize image
+
+Claude Code は、API に送信する前に添付された画像をダウンスケールできませんでした。
+
+```text theme={null}
+Unable to resize image — image processing is unavailable and dimensions could not be read from the file header. Please convert the image to PNG, JPEG, GIF, or WebP.
+Unable to resize image — dimensions exceed the 2000x2000px limit and image processing failed. Please resize the image to reduce its pixel dimensions.
+Unable to resize image (… raw, … base64). The image exceeds the … API limit and compression failed. Please resize the image manually or use a smaller image.
+Unable to resize image — could not verify image dimensions are within the 2000x2000px API limit.
+```
+
+Claude Code は通常、大きな画像を自動的にリサイズします。これらのエラーは、ネイティブ画像プロセッサーがロードに失敗したか、エラーを返したため、画像を API 制限内に収まるようにリサイズできなかったことを意味します。
+
+**対応方法：**
+
+* メッセージが画像の変換を求めている場合は、PNG、JPEG、GIF、または WebP に変換して、再度添付してください。Claude Code はこれらの形式の寸法を画像プロセッサーなしで検証できます。
+* メッセージが寸法またはサイズ制限を報告している場合は、その制限以下に画像をリサイズまたは再圧縮してから添付してください。
```

</details>

<details>
<summary>features-overview-ja.md</summary>

```diff
diff --git a/docs-ja/pages/features-overview-ja.md b/docs-ja/pages/features-overview-ja.md
index 8e42a08..85ae42e 100644
--- a/docs-ja/pages/features-overview-ja.md
+++ b/docs-ja/pages/features-overview-ja.md
@@ -244,5 +244,5 @@ Claude Code は、コードについて推論するモデルと、ファイル
 
   <Tab title="Skills">
-    スキルは Claude のツールキットの追加機能です。リファレンスマテリアル（API スタイルガイドなど）または `/<name>` でトリガーする呼び出し可能なワークフロー（`/deploy` など）です。Claude Code は `/simplify`、`/batch`、`/debug` などの[バンドルされたスキル](/ja/commands) を備えており、すぐに機能します。独自のスキルを作成することもできます。Claude は適切な場合にスキルを使用するか、直接呼び出すことができます。
+    スキルは Claude のツールキットの追加機能です。リファレンスマテリアル（API スタイルガイドなど）または `/<name>` でトリガーする呼び出し可能なワークフロー（`/deploy` など）です。Claude Code は `/code-review`、`/batch`、`/debug` などの[バンドルされたスキル](/ja/commands) を備えており、すぐに機能します。独自のスキルを作成することもできます。Claude は適切な場合にスキルを使用するか、直接呼び出すことができます。
 
     **時期：** スキルの設定によって異なります。デフォルトでは、説明はセッション開始時にロードされ、完全なコンテンツは使用時にロードされます。ユーザーのみのスキル（`disable-model-invocation: true`）の場合、呼び出すまで何もロードされません。
```

</details>

<details>
<summary>glossary-ja.md</summary>

```diff
diff --git a/docs-ja/pages/glossary-ja.md b/docs-ja/pages/glossary-ja.md
index 6bb76d8..af1005e 100644
--- a/docs-ja/pages/glossary-ja.md
+++ b/docs-ja/pages/glossary-ja.md
@@ -57,5 +57,5 @@ Claude が自分自身のために書いたメモ。あなたの修正と設定
 ### Bundled skills
 
-Claude Code に含まれるプロンプトベースのプレイブック。`/batch`、`/simplify`、`/debug`、`/loop` など。固定ロジックを実行する組み込みコマンドとは異なり、bundled skills は Claude に詳細なプロンプトを与え、作業をオーケストレーションさせるため、エージェントを生成し、ファイルを読み取り、コードベースに適応できます。
+Claude Code に含まれるプロンプトベースのプレイブック。`/batch`、`/code-review`、`/debug`、`/loop` など。固定ロジックを実行する組み込みコマンドとは異なり、bundled skills は Claude に詳細なプロンプトを与え、作業をオーケストレーションさせるため、エージェントを生成し、ファイルを読み取り、コードベースに適応できます。
 
 詳細情報: [Bundled skills](/ja/skills#bundled-skills)
```

</details>

<details>
<summary>interactive-mode-ja.md</summary>

```diff
diff --git a/docs-ja/pages/interactive-mode-ja.md b/docs-ja/pages/interactive-mode-ja.md
index 7905e12..b70d474 100644
--- a/docs-ja/pages/interactive-mode-ja.md
+++ b/docs-ja/pages/interactive-mode-ja.md
@@ -215,4 +215,5 @@ Claude Code は現在のセッションのコマンド履歴を保持します
 * 入力履歴は作業ディレクトリごとに保存されます
 * `/clear` を実行して新しいセッションを開始すると、入力履歴がリセットされます。前のセッションの会話は保持され、再開できます。
+* 同じプロンプトを 2 回連続で送信すると、1 つの履歴エントリが記録されるため、Up キーを押すと前の異なるプロンプトにステップします
 * Up/Down 矢印を使用して移動します（上記のキーボードショートカットを参照）
 * **注記**: 履歴展開（`!`）はデフォルトで無効です
```

</details>

*...以降省略*

</details>


<details>
<summary>2026-05-22</summary>

**変更ファイル:**

```
 docs-ja/pages/admin-setup-ja.md             |  27 +-
 docs-ja/pages/auto-mode-config-ja.md        |   2 +-
 docs-ja/pages/changelog.md                  |  36 +++
 docs-ja/pages/desktop-ja.md                 |   2 +-
 docs-ja/pages/devcontainer-ja.md            |   1 +
 docs-ja/pages/errors-ja.md                  |  23 +-
 docs-ja/pages/glossary-ja.md                |   2 +-
 docs-ja/pages/hooks-guide-ja.md             |   6 +-
 docs-ja/pages/hooks-ja.md                   |  60 +++--
 docs-ja/pages/mcp-ja.md                     | 228 +----------------
 docs-ja/pages/permission-modes-ja.md        |   4 +-
 docs-ja/pages/permissions-ja.md             |  29 +--
 docs-ja/pages/sandboxing-ja.md              | 376 ++++++++++++++++------------
 docs-ja/pages/scheduled-tasks-ja.md         |   4 +-
 docs-ja/pages/security-ja.md                |  11 +-
 docs-ja/pages/server-managed-settings-ja.md |   2 +-
 docs-ja/pages/settings-ja.md                |  36 ++-
 17 files changed, 379 insertions(+), 470 deletions(-)
```

**新規追加:**


<details>
<summary>admin-setup-ja.md</summary>

```diff
diff --git a/docs-ja/pages/admin-setup-ja.md b/docs-ja/pages/admin-setup-ja.md
index 463883e..0c9936a 100644
--- a/docs-ja/pages/admin-setup-ja.md
+++ b/docs-ja/pages/admin-setup-ja.md
@@ -66,17 +66,18 @@ plist と HKLM レジストリの場所は任意のプロバイダーで機能
 ## 実行する内容を決定する
 
-マネージド設定は、ツール、サンドボックス実行、MCP サーバーとプラグインソースへのアクセスをロックダウンし、実行されるフック を制御できます。各行は、それを駆動する設定キーを持つ制御サーフェスです。
-
-| 制御                                                                                     | 機能                                                              | キー設定                                                                         |
-| :------------------------------------------------------------------------------------- | :-------------------------------------------------------------- | :--------------------------------------------------------------------------- |
-| [Permission rules](/ja/permissions)                                                    | 特定のツールとコマンドを許可、確認、または拒否する                                       | `permissions.allow`、`permissions.deny`                                       |
-| [Permission lockdown](/ja/permissions#managed-only-settings)                           | マネージドパーミッションルールのみが適用される。`--dangerously-skip-permissions` を無効化する | `allowManagedPermissionRulesOnly`、`permissions.disableBypassPermissionsMode` |
-| [Sandboxing](/ja/sandboxing)                                                           | ドメイン許可リスト付きの OS レベルのファイルシステムとネットワーク分離                           | `sandbox.enabled`、`sandbox.network.allowedDomains`                           |
-| [Managed policy CLAUDE.md](/ja/memory#deploy-organization-wide-claude-md)              | すべてのセッションで読み込まれる組織全体の指示。除外できない                                  | マネージドポリシーパスのファイル                                                             |
-| [MCP server control](/ja/mcp#managed-mcp-configuration)                                | ユーザーが追加または接続できる MCP サーバーを制限する                                   | `allowedMcpServers`、`deniedMcpServers`、`allowManagedMcpServersOnly`          |
-| [Plugin marketplace control](/ja/plugin-marketplaces#managed-marketplace-restrictions) | ユーザーが追加およびインストールできるマーケットプレイスソースを制限する                            | `strictKnownMarketplaces`、`blockedMarketplaces`                              |
-| [Hook restrictions](/ja/settings#hook-configuration)                                   | マネージドフックのみが読み込まれる。HTTP フック URL を制限する                            | `allowManagedHooksOnly`、`allowedHttpHookUrls`                                |
-| [Disable agent view](/ja/agent-view#how-background-sessions-are-hosted)                | `claude agents`、`--bg`、`/background`、およびオンデマンドスーパーバイザーをオフにする    | `disableAgentView`                                                           |
-| [Version floor](/ja/settings)                                                          | 自動更新が組織全体の最小値より下にインストールされるのを防ぐ                                  | `minimumVersion`                                                             |
+マネージド設定は、ツール、サンドボックス実行、MCP サーバーとプラグインソースへのアクセスをロックダウンし、実行されるフックを制御できます。各行は、それを駆動する設定キーを持つ制御サーフェスです。
+
+| 制御                                                                                     | 機能                                                                                | キー設定                                                                                                   |
+| :------------------------------------------------------------------------------------- | :-------------------------------------------------------------------------------- | :----------------------------------------------------------------------------------------------------- |
+| [Permission rules](/ja/permissions)                                                    | 特定のツールとコマンドを許可、確認、または拒否する                                                         | `permissions.allow`、`permissions.deny`                                                                 |
+| [Permission lockdown](/ja/permissions#managed-only-settings)                           | マネージドパーミッションルールのみが適用される。`--dangerously-skip-permissions` を無効化する                   | `allowManagedPermissionRulesOnly`、`permissions.disableBypassPermissionsMode`                           |
+| [Sandboxing](/ja/sandboxing)                                                           | ドメイン許可リスト付きの OS レベルのファイルシステムとネットワーク分離                                             | `sandbox.enabled`、`sandbox.network.allowedDomains`                                                     |
+| [Managed policy CLAUDE.md](/ja/memory#deploy-organization-wide-claude-md)              | すべてのセッションで読み込まれる組織全体の指示。除外できない                                                    | マネージドポリシーパスのファイル                                                                                       |
+| [MCP server control](/ja/managed-mcp)                                                  | ユーザーが追加または接続できる MCP サーバーを制限するか、固定セットをデプロイする                                       | `allowedMcpServers`、`deniedMcpServers`、`allowManagedMcpServersOnly`、またはデプロイされた `managed-mcp.json` ファイル |
+| [Plugin marketplace control](/ja/plugin-marketplaces#managed-marketplace-restrictions) | ユーザーが追加およびインストールできるマーケットプレイスソースを制限する                                              | `strictKnownMarketplaces`、`blockedMarketplaces`                                                        |
```

</details>

<details>
<summary>auto-mode-config-ja.md</summary>

```diff
diff --git a/docs-ja/pages/auto-mode-config-ja.md b/docs-ja/pages/auto-mode-config-ja.md
index 88d9241..5dd6a62 100644
--- a/docs-ja/pages/auto-mode-config-ja.md
+++ b/docs-ja/pages/auto-mode-config-ja.md
@@ -10,5 +10,5 @@
 
 <Note>
-  オートモードは、Anthropic API を通じて Max、Team、Enterprise、API プランで利用可能です。Pro プランでは利用できず、Bedrock、Vertex、Foundry でも利用できません。Claude Code がアカウントでオートモードが利用不可と報告する場合は、[完全な要件](/ja/permission-modes#eliminate-prompts-with-auto-mode)を確認してください。これには、サポートされているモデルと Team および Enterprise プランの管理者有効化も含まれます。
+  オートモードは、Anthropic API を通じてすべてのユーザーが利用できます。Bedrock、Vertex、Foundry では利用できません。Claude Code がアカウントでオートモードが利用不可と報告する場合は、[完全な要件](/ja/permission-modes#eliminate-prompts-with-auto-mode)を確認してください。これには、サポートされているモデルと Team および Enterprise プランの管理者有効化も含まれます。
 </Note>
 
```

</details>

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index f476a24..7c01af0 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,40 @@
 # Changelog
 
+## 2.1.147
+
+- Pinned background sessions (`Ctrl+T` in `claude agents`) now stay alive when idle, are restarted in place to apply Claude Code updates, and are shed under memory pressure only after non-pinned sessions
+- Renamed `/simplify` to `/code-review`. It now reports correctness bugs at a chosen effort level (e.g., `/code-review high`); pass `--comment` to post findings as inline GitHub PR comments. The old cleanup-and-fix behavior has been removed
+- Improved auto-updater: retries transient network failures, reports specific error categories and OS error codes on failure, and shows the current version when an update fails
+- Improved diff rendering performance for large file edits
+- Prompt history no longer records consecutive duplicate entries — recalling a prompt with arrow-up and submitting it again won't add another copy
+- Fixed enterprise login restrictions (`forceLoginOrgUUID` and `forceLoginMethod` managed-settings) not being enforced against third-party-provider and API-key sessions
+- Fixed `&` in `!` command output displaying as `&amp;`, which broke copy-pasting URLs from commands like `gcloud auth login` on headless machines
+- Fixed unknown slash commands silently doing nothing in headless/SDK mode — they now show an error message
+- Fixed `/help` rendering a broken tab header and showing only one command per page on small terminals when not in fullscreen mode
+- Fixed shell snapshot dropping user functions whose names start with a single underscore, which broke aliases referencing them
+- Fixed plugin agents that declare multiple `Agent(...)` types in `tools:` frontmatter dropping all but the last entry
+- Fixed hook `if` conditions like `PowerShell(git push*)` never matching — only `PowerShell(*)` worked
+- Fixed PowerShell tool dropping output for commands that rely on the default formatter
+- Fixed: on Windows, "Yes, and don't ask again" for a PowerShell script invocation now writes a rule that actually matches on subsequent runs
+- Fixed PowerShell tool failing on Windows with exit code 1 when `pwsh` is installed via winget or the Microsoft Store
+- Fixed `/effort` opening with the slider on the wrong level — it now starts at your current effort
+- Fixed paginating MCP servers dropping resources, templates, and prompts past page 1
+- Fixed full-screen strobing in attached background sessions on Windows Terminal while Claude is streaming
+- Fixed: on Windows, removing a background-job worktree no longer follows NTFS junctions into the main repo
+- Fixed `/background` refusing sessions whose only typed input was a skill or custom slash command
+- Fixed auto mode suppressing `AskUserQuestion` when the user or a skill explicitly relies on it; the auto-mode classifier now sees the user's answers as intent signal
```

</details>

<details>
<summary>desktop-ja.md</summary>

```diff
diff --git a/docs-ja/pages/desktop-ja.md b/docs-ja/pages/desktop-ja.md
index 6e08268..e605625 100644
--- a/docs-ja/pages/desktop-ja.md
+++ b/docs-ja/pages/desktop-ja.md
@@ -79,5 +79,5 @@ Claude に実行させたいことを入力して**Enter**キーを押して送
 <span id="auto-mode-availability" />
 
-Auto mode は Max、Team、Enterprise、および API プランで利用可能な研究プレビューです。Pro プランまたはサードパーティプロバイダーでは利用できません。Team、Enterprise、および API プランでは Claude Sonnet 4.6、Opus 4.6、または Opus 4.7 が必要です。Max プランでは Claude Opus 4.7 が必要です。
+Auto mode は Anthropic API のすべてのユーザーが利用できる研究プレビューです。サードパーティプロバイダーでは利用できません。Claude Sonnet 4.6、Opus 4.6、または Opus 4.7 が必要です。
 
 <Tip title="ベストプラクティス">
```

</details>

<details>
<summary>devcontainer-ja.md</summary>

```diff
diff --git a/docs-ja/pages/devcontainer-ja.md b/docs-ja/pages/devcontainer-ja.md
index bbeeb37..2f9c6e5 100644
--- a/docs-ja/pages/devcontainer-ja.md
+++ b/docs-ja/pages/devcontainer-ja.md
@@ -191,4 +191,5 @@ Claude Code が開発コンテナで実行されたら、以下のページは
 * [テレメトリサービスとオプトアウト](/ja/data-usage#telemetry-services)：Claude Code がデフォルトで送信するもの、およびそれを無効にする環境変数
 * [`.claude` ディレクトリを探索する](/ja/claude-directory)：ボリュームマウントが保持するもの（認証情報、設定、セッション履歴を含む）
+* [サンドボックス環境](/ja/sandbox-environments)：開発コンテナと組み込み Bash サンドボックス、カスタムコンテナ、VM を比較します
 * [セキュリティモデル](/ja/security)：Claude Code の権限システム、サンドボックス、プロンプトインジェクション保護がどのように組み合わさるか
 * [権限モード](/ja/permission-modes)：プランモードから自動モードからバイパスまでの完全な範囲、および各モードを使用する場合
```

</details>

<details>
<summary>errors-ja.md</summary>

```diff
diff --git a/docs-ja/pages/errors-ja.md b/docs-ja/pages/errors-ja.md
index ba9250c..25db665 100644
--- a/docs-ja/pages/errors-ja.md
+++ b/docs-ja/pages/errors-ja.md
@@ -21,5 +21,5 @@
 | メッセージ                                                                                         | セクション                                                                                         |
 | :-------------------------------------------------------------------------------------------- | :-------------------------------------------------------------------------------------------- |
-| `API Error: 500 ... Internal server error`                                                    | [サーバーエラー](#api-error-500-internal-server-error)                                               |
+| `API Error: 500 Internal server error`                                                        | [サーバーエラー](#api-error-500-internal-server-error)                                               |
 | `API Error: Repeated 529 Overloaded errors`                                                   | [サーバーエラー](#api-error-repeated-529-overloaded-errors)                                          |
 | `Request timed out`                                                                           | [サーバーエラー](#request-timed-out)、またはメッセージがインターネット接続に言及している場合は[ネットワーク](#unable-to-connect-to-api) |
@@ -34,4 +34,5 @@
 | `Invalid API key`                                                                             | [認証](#invalid-api-key)                                                                        |
 | `This organization has been disabled`                                                         | [認証](#this-organization-has-been-disabled)                                                    |
+| `Your organization has disabled Claude subscription access`                                   | [認証](#your-organization-has-disabled-claude-subscription-access)                              |
 | `Routines are disabled by your organization's policy`                                         | [認証](#routines-are-disabled-by-your-organizations-policy)                                     |
 | `OAuth token revoked` / `OAuth token has expired`                                             | [認証](#oauth-token-revoked-or-expired)                                                         |
@@ -67,19 +68,21 @@ Claude Code は、エラーを表示する前に一時的な障害をリトラ
 ## サーバーエラー
 
-これらのエラーは、アカウントまたはリクエストではなく、Anthropic インフラストラクチャから発生します。
+これらのエラーは、アカウントまたはリクエストではなく、推論プロバイダーから発生します。Anthropic API では Anthropic インフラストラクチャを意味します。Bedrock、Vertex AI、Foundry、またはカスタムゲートウェイでは、そのプロバイダーのインフラストラクチャを意味します。
 
 ### API Error: 500 Internal server error
 
-Claude Code は、5xx ステータスの生の API レスポンスボディを表示します。以下の例は 500 レスポンスを示しています。
+Claude Code は、5xx レスポンスに対してステータスコードと API のエラーメッセージを表示します。以下の例は Anthropic API での 500 レスポンスを示しています：
 
 ```text theme={null}
-API Error: 500 {"type":"error","error":{"type":"api_error","message":"Internal server error"}} · check status.claude.com
```

</details>

<details>
<summary>glossary-ja.md</summary>

```diff
diff --git a/docs-ja/pages/glossary-ja.md b/docs-ja/pages/glossary-ja.md
index 40d7b70..6bb76d8 100644
--- a/docs-ja/pages/glossary-ja.md
+++ b/docs-ja/pages/glossary-ja.md
@@ -43,5 +43,5 @@ Claude が自分自身のために書いたメモ。あなたの修正と設定
 ### Auto mode
 
-[permission mode](#permission-mode) の一種。承認プロンプトを表示する代わりに、別の分類器モデルがバックグラウンドで各アクションをレビューします。分類器はスコープエスカレーション、信頼されていないインフラストラクチャ、および [prompt injection](#prompt-injection) をブロックします。ツール結果を見ることはないため、注入された指示がその決定に影響を与えることはできません。Auto mode は Max、Team、Enterprise、API プランで利用可能な研究プレビューです。
+[permission mode](#permission-mode) の一種。承認プロンプトを表示する代わりに、別の分類器モデルがバックグラウンドで各アクションをレビューします。分類器はスコープエスカレーション、信頼されていないインフラストラクチャ、および [prompt injection](#prompt-injection) をブロックします。ツール結果を見ることはないため、注入された指示がその決定に影響を与えることはできません。Auto mode は Anthropic API のすべてのユーザーが利用可能な研究プレビューです。
 
 詳細情報: [Eliminate prompts with auto mode](/ja/permission-modes#eliminate-prompts-with-auto-mode)
```

</details>

<details>
<summary>hooks-guide-ja.md</summary>

```diff
diff --git a/docs-ja/pages/hooks-guide-ja.md b/docs-ja/pages/hooks-guide-ja.md
index d954ddd..eef1196 100644
--- a/docs-ja/pages/hooks-guide-ja.md
+++ b/docs-ja/pages/hooks-guide-ja.md
@@ -546,10 +546,10 @@ if echo "$COMMAND" | grep -q "drop table"; then
 fi
 
-exit 0  # exit 0 = 続行させる
+exit 0  # exit 0 = 決定なし。通常の許可フローが適用されます
 ```
 
 終了コードは次に何が起こるかを決定します：
 
-* **終了 0**：アクションが続行されます。`UserPromptSubmit`、`UserPromptExpansion`、および `SessionStart` hooks の場合、stdout に書き込むすべてのものが Claude のコンテキストに追加されます。
+* **終了 0**：hook は異議を報告せず、アクションは通常どおり進行します。`PreToolUse` hook の場合、これはツール呼び出しを承認しません：通常の [許可フロー](/ja/permissions) が引き続き適用されます。`UserPromptSubmit`、`UserPromptExpansion`、および `SessionStart` hooks の場合、stdout に書き込むすべてのものが Claude のコンテキストに追加されます。
 * **終了 2**：アクションがブロックされます。stderr に理由を書き込み、Claude はそれをフィードバックとして受け取るため、調整できます。一部のイベントはブロックできません：`SessionStart`、`Setup`、`Notification` などの場合、終了 2 は stderr をユーザーに表示し、実行は続行されます。[イベントごとの終了コード 2 の動作](/ja/hooks#exit-code-2-behavior-per-event) で完全なリストを参照してください。
 * **その他の終了コード**：アクションが続行されます。トランスクリプトは `<hook name> hook error` 通知を表示し、その後 stderr の最初の行が続きます。完全な stderr は [デバッグログ](/ja/hooks#debug-hooks) に記録されます。
@@ -557,5 +557,5 @@ exit 0  # exit 0 = 続行させる
 #### 構造化 JSON 出力
 
-終了コードは 2 つのオプションを提供します：許可またはブロック。より多くの制御のために、終了 0 して stdout に JSON オブジェクトを出力します。
+終了コードはブロックするか沈黙するかのみを許可します。より多くの制御のために、終了 0 して stdout に JSON オブジェクトを出力します。
 
 <Note>
```

</details>

<details>
<summary>hooks-ja.md</summary>

```diff
diff --git a/docs-ja/pages/hooks-ja.md b/docs-ja/pages/hooks-ja.md
index fd66b90..87e96a6 100644
--- a/docs-ja/pages/hooks-ja.md
+++ b/docs-ja/pages/hooks-ja.md
@@ -97,5 +97,5 @@ if echo "$COMMAND" | grep -q 'rm -rf'; then
   }'
 else
-  exit 0  # allow the command
+  exit 0  # no decision; normal permission flow applies
 fi
 ```
@@ -137,5 +137,5 @@ fi
     ```
 
-    コマンドが安全だった場合（`rm file.txt` など）、スクリプトは代わりに `exit 0` に到達し、これは Claude Code にツール呼び出しを許可するよう指示します。
+    コマンドが安全な `rm` バリアント（`rm file.txt` など）だった場合、スクリプトは代わりに `exit 0` に到達します。出力なしの終了コード 0 は、フックが報告する決定がないことを意味するため、ツール呼び出しは通常の[権限フロー](/ja/permissions)を通じて続行されます。フックは呼び出しを拒否できますが、沈黙を保つことは承認を意味しません。
   </Step>
 
@@ -733,6 +733,6 @@ Claude を完全に停止するには、イベント タイプに関係なく。
 input=$(cat)
 title="Claude Code'
-body=$(jq -r '.message // 'Needs your attention'' <<<'$input')
-seq=$(printf '\033]777;notify;%s;%s\007' '$title" "$body")
+body=$(jq -r '.message // "Needs your attention"' <<<"$input")
+seq=$(printf '\033]777;notify;%s;%s\007' "$title" "$body")
 jq -nc --arg seq "$seq" '{terminalSequence: $seq}'
 ```
@@ -783,15 +783,16 @@ Claude が現在の環境の状態または実行されたばかりの操作に
 すべてのイベントが JSON を通じたブロッキングまたは動作制御をサポートしているわけではありません。サポートするイベントは、その決定を表現するために異なるフィールド セットを使用します。フックを書く前に、このテーブルをクイック リファレンスとして使用してください。
 
```

</details>

*...以降省略*

</details>


<details>
<summary>2026-05-21</summary>

**変更ファイル:**

```
 docs-ja/pages/agent-view-ja.md            |  3 ++
 docs-ja/pages/checkpointing-ja.md         |  8 ++-
 docs-ja/pages/cli-reference-ja.md         | 56 ++++++++++----------
 docs-ja/pages/commands-ja.md              |  7 ++-
 docs-ja/pages/desktop-ja.md               |  4 +-
 docs-ja/pages/desktop-quickstart-ja.md    | 14 ++---
 docs-ja/pages/discover-plugins-ja.md      |  8 ++-
 docs-ja/pages/env-vars-ja.md              |  2 +-
 docs-ja/pages/fullscreen-ja.md            |  3 +-
 docs-ja/pages/hooks-ja.md                 | 58 +++++++++++++++++++--
 docs-ja/pages/how-claude-code-works-ja.md |  5 +-
 docs-ja/pages/interactive-mode-ja.md      | 11 ++--
 docs-ja/pages/monitoring-usage-ja.md      | 20 ++++----
 docs-ja/pages/output-styles-ja.md         |  8 +--
 docs-ja/pages/permission-modes-ja.md      |  2 +-
 docs-ja/pages/plugin-marketplaces-ja.md   | 22 ++++----
 docs-ja/pages/plugins-reference-ja.md     | 14 +++++
 docs-ja/pages/scheduled-tasks-ja.md       |  6 ++-
 docs-ja/pages/skills-ja.md                | 20 +++++++-
 docs-ja/pages/statusline-ja.md            | 19 ++++++-
 docs-ja/pages/tools-reference-ja.md       | 85 ++++++++++++++++---------------
 21 files changed, 249 insertions(+), 126 deletions(-)
```

**新規追加:**


<details>
<summary>agent-view-ja.md</summary>

```diff
diff --git a/docs-ja/pages/agent-view-ja.md b/docs-ja/pages/agent-view-ja.md
index a47438b..927081d 100644
--- a/docs-ja/pages/agent-view-ja.md
+++ b/docs-ja/pages/agent-view-ja.md
@@ -126,4 +126,6 @@ Completed
 行の右端に表示される `●` は [プルリクエストステータス](#pull-request-status) インジケーターであり、状態アイコンの一部ではありません。その前の数字はセッションが開いたプルリクエストの数です。
 
+ターミナルタブのタイトルは、エージェントビューが開いている間、待機中の入力カウントを表示します。セッションが入力を必要とする場合は `2 awaiting input · claude agents`、そうでない場合は `claude agents` です。
+
 バックグラウンドセッションは作業を続けるためにターミナルを開く必要がありません。別の [スーパーバイザープロセス](#the-supervisor-process) がセッションを実行するため、エージェントビューを閉じたり、シェルを閉じたり、新しいインタラクティブセッションを開始したりしても、ディスパッチされた作業は続きます。
 
@@ -399,4 +401,5 @@ claude agents --settings ./ci-settings.json --add-dir ../shared-lib
 | `claude agents`              | エージェントビューを開く                                                                                                                                                                                          |
 | `claude agents --cwd <path>` | `<path>` の下で開始されたセッションにスコープされたエージェントビューを開く                                                                                                                                                            |
+| `claude agents --json`       | ライブセッションを JSON 配列として出力して終了します。各エントリには `pid`、`cwd`、`kind`、`startedAt` が含まれ、設定されている場合は `sessionId`、`name`、`status` も含まれます。`--cwd <path>` と組み合わせてフィルタリングします                                              |
 | `claude attach <id>`         | このターミナルでセッションにアタッチする                                                                                                                                                                                  |
 | `claude logs <id>`           | セッションの最新出力を出力する                                                                                                                                                                                       |
```

</details>

<details>
<summary>checkpointing-ja.md</summary>

```diff
diff --git a/docs-ja/pages/checkpointing-ja.md b/docs-ja/pages/checkpointing-ja.md
index 5fca0e3..5f25f1f 100644
--- a/docs-ja/pages/checkpointing-ja.md
+++ b/docs-ja/pages/checkpointing-ja.md
@@ -23,5 +23,11 @@ Claude Code は、ファイル編集ツールで行われたすべての変更
 ### 巻き戻しと要約
 
-`Esc` キーを 2 回（`Esc` + `Esc`）押すか、`/rewind` コマンドを使用して巻き戻しメニューを開きます。スクロール可能なリストにセッションからの各プロンプトが表示されます。操作したいポイントを選択してから、アクションを選択します。
+`/rewind` を実行するか、プロンプト入力が空の状態で `Esc` キーを 2 回押して、巻き戻しメニューを開きます。
+
+<Note>
+  プロンプト入力にテキストが含まれている場合、ダブル `Esc` はメニューを開く代わりにテキストをクリアします。クリアされたテキストは入力履歴に保存されるため、巻き戻しメニューを終了した後に `Up` キーを押して呼び出すことができます。
+</Note>
+
+巻き戻しメニューには、セッション中に送信した各プロンプトが表示されます。操作したいポイントを選択してから、アクションを選択します。
 
 * **コードと会話を復元**: コードと会話の両方をそのポイントに戻します
```

</details>

<details>
<summary>cli-reference-ja.md</summary>

```diff
diff --git a/docs-ja/pages/cli-reference-ja.md b/docs-ja/pages/cli-reference-ja.md
index 7f876e7..14ddc5f 100644
--- a/docs-ja/pages/cli-reference-ja.md
+++ b/docs-ja/pages/cli-reference-ja.md
@@ -11,32 +11,32 @@
 これらのコマンドを使用して、セッションを開始し、コンテンツをパイプし、会話を再開し、更新を管理できます。
 
-| コマンド                            | 説明                                                                                                                                                                                                                                                                                                                                                                  | 例                                                           |
-| :------------------------------ | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | :---------------------------------------------------------- |
-| `claude`                        | インタラクティブセッションを開始                                                                                                                                                                                                                                                                                                                                                    | `claude`                                                    |
-| `claude "query"`                | 初期プロンプト付きでインタラクティブセッションを開始                                                                                                                                                                                                                                                                                                                                          | `claude "explain this project"`                             |
-| `claude -p "query"`             | SDK 経由でクエリを実行してから終了                                                                                                                                                                                                                                                                                                                                                 | `claude -p "explain this function"`                         |
-| `cat file \| claude -p "query"` | パイプされたコンテンツを処理                                                                                                                                                                                                                                                                                                                                                      | `cat logs.txt \| claude -p "explain"`                       |
-| `claude -c`                     | 現在のディレクトリで最新の会話を続行                                                                                                                                                                                                                                                                                                                                                  | `claude -c`                                                 |
-| `claude -c -p "query"`          | SDK 経由で続行                                                                                                                                                                                                                                                                                                                                                           | `claude -c -p "Check for type errors"`                      |
-| `claude -r "<session>" "query"` | セッション ID または名前でセッションを再開                                                                                                                                                                                                                                                                                                                                             | `claude -r "auth-refactor" "Finish this PR"`                |
-| `claude update`                 | 最新バージョンに更新                                                                                                                                                                                                                                                                                                                                                          | `claude update`                                             |
-| `claude install [version]`      | ネイティブバイナリをインストールまたは再インストールします。`2.1.118` のようなバージョン、または `stable` または `latest` を受け入れます。[特定のバージョンをインストール](/ja/setup#install-a-specific-version) を参照してください                                                                                                                                                                                                               | `claude install stable`                                     |
-| `claude auth login`             | Anthropic アカウントにサインインします。`--email` を使用してメールアドレスを事前入力し、`--sso` を使用して SSO 認証を強制し、`--console` を使用して Claude サブスクリプションの代わりに Anthropic Console で API 使用料金をサインインできます                                                                                                                                                                                                       | `claude auth login --console`                               |
-| `claude auth logout`            | Anthropic アカウントからログアウト                                                                                                                                                                                                                                                                                                                                              | `claude auth logout`                                        |
-| `claude auth status`            | 認証ステータスを JSON として表示します。`--text` を使用して人間が読める形式で表示できます。ログイン済みの場合はコード 0 で終了し、ログインしていない場合は 1 で終了します                                                                                                                                                                                                                                                                     | `claude auth status`                                        |
-| `claude agents`                 | [エージェントビュー](/ja/agent-view) を開いて、並列バックグラウンドセッションを監視およびディスパッチします。`--cwd <path>` を使用して、そのディレクトリの下で開始されたセッションのみを表示します。`--permission-mode`、`--model`、または `--effort` を渡して、[ディスパッチされたセッションのデフォルト](/ja/agent-view#permission-mode-model-and-effort) を設定します。トップレベルの `claude` コマンドと同様に `--settings`、`--add-dir`、`--plugin-dir`、および `--mcp-config` を受け入れます。インタラクティブターミナルが必要です | `claude agents --cwd ~/projects/my-app`                     |
-| `claude attach <id>`            | このターミナルで [バックグラウンドセッション](/ja/agent-view#manage-sessions-from-the-shell) に接続します                                                                                                                                                                                                                                                                                      | `claude attach 7c5dcf5d`                                    |
-| `claude auto-mode defaults`     | 組み込み [auto mode](/ja/permission-modes#eliminate-prompts-with-auto-mode) 分類器ルールを JSON として出力します。`claude auto-mode config` を使用して、設定が適用された有効な設定を確認してください                                                                                                                                                                                                                | `claude auto-mode defaults > rules.json`                    |
-| `claude daemon status`          | バックグラウンドセッション [スーパーバイザー](/ja/agent-view#the-supervisor-process) の状態、バージョン、ソケットディレクトリ、および診断用のワーカー数を出力します。スーパーバイザーが実行されていない場合は 1 で終了します                                                                                                                                                                                                                               | `claude daemon status`                                      |
-| `claude logs <id>`              | [バックグラウンドセッション](/ja/agent-view#manage-sessions-from-the-shell) からの最近の出力を出力します                                                                                                                                                                                                                                                                                       | `claude logs 7c5dcf5d`                                      |
-| `claude mcp`                    | Model Context Protocol（MCP）サーバーを設定                                                                                                                                                                                                                                                                                                                                  | [Claude Code MCP ドキュメント](/ja/mcp) を参照してください。                |
-| `claude plugin`                 | Claude Code [plugins](/ja/plugins) を管理します。エイリアス：`claude plugins`。サブコマンドについては [plugin reference](/ja/plugins-reference#cli-commands-reference) を参照してください                                                                                                                                                                                                             | `claude plugin install code-review@claude-plugins-official` |
-| `claude project purge [path]`   | プロジェクトのすべてのローカル Claude Code 状態を削除します：トランスクリプト、タスクリスト、デバッグログ、ファイル編集履歴、プロンプト履歴行、および `~/.claude.json` 内のプロジェクトエントリ。`[path]` を省略して、インタラクティブリストから選択します。フラグ：`--dry-run` でプレビュー、`-y`/`--yes` で確認をスキップ、`-i`/`--interactive` で各項目を確認、`--all` ですべてのプロジェクト。[ローカルデータをクリア](/ja/claude-directory#clear-local-data) を参照してください                                                      | `claude project purge ~/work/repo --dry-run`                |
-| `claude remote-control`         | [Remote Control](/ja/remote-control) サーバーを開始して、Claude.ai または Claude アプリから Claude Code を制御します。サーバーモード（ローカルインタラクティブセッションなし）で実行されます。[サーバーモードフラグ](/ja/remote-control#start-a-remote-control-session) を参照してください                                                                                                                                                          | `claude remote-control --name "My Project"`                 |
```

</details>

<details>
<summary>commands-ja.md</summary>

```diff
diff --git a/docs-ja/pages/commands-ja.md b/docs-ja/pages/commands-ja.md
index 11b3094..38144a7 100644
--- a/docs-ja/pages/commands-ja.md
+++ b/docs-ja/pages/commands-ja.md
@@ -36,5 +36,5 @@
 
 <Note>
-  すべてのコマンドがすべてのユーザーに表示されるわけではありません。可用性はプラットフォーム、プラン、環境によって異なります。たとえば、`/desktop` は macOS と Windows にのみ表示され、`/upgrade` は Pro プランと Max プランにのみ表示されます。
+  すべてのコマンドがすべてのユーザーに表示されるわけではありません。可用性はプラットフォーム、プラン、環境によって異なります。たとえば、`/desktop` は macOS と Windows にのみ表示され、Claude サブスクリプションでサインインしている場合のみ表示されます。また、`/upgrade` は Pro プランと Max プランにのみ表示されます。
 </Note>
 
@@ -57,5 +57,5 @@
 | `/cost`                                         | `/usage` のエイリアス                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
 | `/debug [description]`                          | **[スキル](/ja/skills#bundled-skills)。** 現在のセッションのデバッグログを有効にし、セッションデバッグログを読むことで問題をトラブルシューティングします。デバッグログはデフォルトではオフです。`claude --debug` で開始した場合を除き、セッション中に `/debug` を実行するとその時点からログのキャプチャを開始します。オプションで問題を説明して分析にフォーカスを当てます                                                                                                                                                                                                                                                                                            |
-| `/desktop`                                      | 現在のセッションを Claude Code デスクトップアプリで続行します。macOS と Windows のみ。エイリアス: `/app`                                                                                                                                                                                                                                                                                                                                                                                                                                         |
+| `/desktop`                                      | 現在のセッションを Claude Code デスクトップアプリで続行します。macOS と Windows が必要で、Claude サブスクリプションが必要です。エイリアス: `/app`                                                                                                                                                                                                                                                                                                                                                                                                                 |
 | `/diff`                                         | コミットされていない変更と各ターンの diff を表示するインタラクティブ diff ビューアを開きます。左右矢印を使用して現在の git diff と個別の Claude ターンを切り替え、上下矢印でファイルをブラウズします                                                                                                                                                                                                                                                                                                                                                                                              |
 | `/doctor`                                       | Claude Code のインストールと設定を診断および検証します。結果はステータスアイコン付きで表示されます。`f` を押して Claude に報告された問題を修正させます                                                                                                                                                                                                                                                                                                                                                                                                                        |
@@ -101,4 +101,6 @@
 | `/review [PR]`                                  | 現在のセッションでプルリクエストをローカルでレビューします。より深いクラウドベースのレビューについては、[`/ultrareview`](/ja/ultrareview)を参照してください                                                                                                                                                                                                                                                                                                                                                                                                                 |
 | `/rewind`                                       | 会話またはコードを前の時点に巻き戻すか、選択したメッセージから要約します。[チェックポイント](/ja/checkpointing)を参照してください。エイリアス: `/checkpoint`、`/undo`                                                                                                                                                                                                                                                                                                                                                                                                       |
+| `/run`                                          | **[スキル](/ja/skills#bundled-skills)。** プロジェクトのアプリを起動して実行し、テストだけでなく実行中のアプリで変更が機能しているのを確認します。[アプリを実行して検証](/ja/skills#run-and-verify-your-app)を参照してください。{/* min-version: 2.1.145 */}Claude Code v2.1.145 以降が必要です                                                                                                                                                                                                                                                                                                   |
+| `/run-skill-generator`                          | **[スキル](/ja/skills#bundled-skills)。** クリーンな環境からプロジェクトのアプリをビルド、起動、実行する方法を `/run` と `/verify` に教えるために、プロジェクトごとの[スキル](/ja/skills#run-and-verify-your-app)を作成します。{/* min-version: 2.1.145 */}Claude Code v2.1.145 以降が必要です                                                                                                                                                                                                                                                                                          |
 | `/sandbox`                                      | [サンドボックスモード](/ja/sandboxing)を切り替えます。サポートされているプラットフォームでのみ利用可能です                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
 | `/schedule [description]`                       | [ルーチン](/ja/routines)を作成、更新、リスト表示、または実行します。Claude がセットアップを会話形式でガイドします。エイリアス: `/routines`                                                                                                                                                                                                                                                                                                                                                                                                                        |
@@ -125,4 +127,5 @@
 | `/usage`                                        | セッションコスト、プラン使用制限、およびアクティビティ統計を表示します。サブスクリプション固有の詳細については、[コスト追跡ガイド](/ja/costs#using-the-%2Fusage-command)を参照してください。`/cost` と `/stats` はエイリアスです                                                                                                                                                                                                                                                                                                                                                                  |
 | `/usage-credits`                                | 制限に達したときに作業を続行するための usage credits を構成します。以前は `/extra-usage`                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
+| `/verify`                                       | **[スキル](/ja/skills#bundled-skills)。** プロジェクトのアプリをビルドして実行し、結果を観察することで、コード変更が期待通りに機能することを確認します。テストまたは型チェックに依存するのではなく。[アプリを実行して検証](/ja/skills#run-and-verify-your-app)を参照してください。{/* min-version: 2.1.145 */}Claude Code v2.1.145 以降が必要です                                                                                                                                                                                                                                                                          |
 | `/vim`                                          | {/* max-version: 2.1.91 */}v2.1.92 で削除。Vim と通常編集モード間を切り替えるには、`/config` → エディタモードを使用してください                                                                                                                                                                                                                                                                                                                                                                                                                      |
```

</details>

<details>
<summary>desktop-ja.md</summary>

```diff
diff --git a/docs-ja/pages/desktop-ja.md b/docs-ja/pages/desktop-ja.md
index be82d69..6e08268 100644
--- a/docs-ja/pages/desktop-ja.md
+++ b/docs-ja/pages/desktop-ja.md
@@ -643,5 +643,5 @@ Desktop はエンタープライズデプロイメントツールを通じて配
 既に Claude Code CLI を使用している場合、Desktop は同じ基盤となるエンジンをグラフィカルインターフェイスで実行します。同じマシン上で、同じプロジェクト上でも、両方を同時に実行できます。各々は個別のセッション履歴を保持しますが、CLAUDE.md ファイルを通じて設定とプロジェクトメモリを共有します。
 
-CLI セッションを Desktop に移動するには、ターミナルで `/desktop` を実行します。Claude はセッションを保存し、デスクトップアプリで開いてから CLI を終了します。このコマンドは macOS と Windows でのみ利用可能です。
+CLI セッションを Desktop に移動するには、ターミナルで `/desktop` を実行します。Claude はセッションを保存し、デスクトップアプリで開いてから CLI を終了します。このコマンドは macOS と Windows でのみ利用可能です。Claude サブスクリプションでサインインしている場合に利用できます。API キー認証では利用できず、Bedrock、Vertex、Foundry でも利用できません。
 
 <Tip>
@@ -660,5 +660,5 @@ CLI セッションを Desktop に移動するには、ターミナルで `/desk
 | `--dangerously-skip-permissions`     | Bypass permissions モード。Settings → Claude Code → 「Allow bypass permissions mode」で有効にします。エンタープライズ管理者はこの設定を無効にできます。 |
 | `--add-dir`                          | リモートセッションで **+** ボタンで複数のリポジトリを追加                                                                                 |
-| `--allowedTools`、`--disallowedTools` | [設定ファイル](/ja/settings)の権限ルールは引き続き適用されます。Desktop の同等物はありません。                                                      |
+| `--allowedTools`、`--disallowedTools` | セッションごとの同等物はありません。[設定ファイル](/ja/settings)の権限ルールは引き続き適用されます。                                                       |
 | `--verbose`                          | [Verbose ビューモード](#switch-view-modes)（Transcript view ドロップダウン）                                                    |
 | `--print`、`--output-format`          | 利用できません。Desktop はインタラクティブのみです。                                                                                   |
```

</details>

<details>
<summary>desktop-quickstart-ja.md</summary>

```diff
diff --git a/docs-ja/pages/desktop-quickstart-ja.md b/docs-ja/pages/desktop-quickstart-ja.md
index cb22f4a..cbff9f9 100644
--- a/docs-ja/pages/desktop-quickstart-ja.md
+++ b/docs-ja/pages/desktop-quickstart-ja.md
@@ -58,15 +58,15 @@ Code タブを開いた状態で、プロジェクトを選択して Claude に
 
     <Tip>
-      よく知っている小さなプロジェクトから始めてください。Claude Code が何ができるかを見るための最速の方法です。Windows では、ローカルセッションが機能するために [Git](https://git-scm.com/downloads/win)がインストールされている必要があります。ほとんどの Mac にはデフォルトで Git が含まれています。
+      よく知っている小さなプロジェクトから始めてください。Claude Code が何ができるかを見るための最速の方法です。Windows では、ローカルセッションが機能するために [Git](https://git-scm.com/downloads/win) がインストールされている必要があります。ほとんどの Mac にはデフォルトで Git が含まれています。
     </Tip>
 
     以下も選択できます。
 
-    * **Remote**: Anthropic のクラウドインフラストラクチャでセッションを実行します。アプリを閉じても続行します。リモートセッションは [Claude Code on the web](/ja/claude-code-on-the-web)と同じインフラストラクチャを使用します。
-    * **SSH**: SSH 経由でリモートマシンに接続します（独自のサーバー、クラウド VM、または dev コンテナー）。Claude Code はリモートマシンにインストールされている必要があります。
+    * **Remote**: Anthropic のクラウドインフラストラクチャでセッションを実行します。アプリを閉じても続行します。リモートセッションは [Claude Code on the web](/ja/claude-code-on-the-web) と同じインフラストラクチャを使用します。
+    * **SSH**: SSH 経由でリモートマシンに接続します（独自のサーバー、クラウド VM、または dev コンテナー）。Desktop は初回接続時にリモートマシンに Claude Code を自動的にインストールします。
   </Step>
 
   <Step title="モデルを選択する">
-    送信ボタンの横のドロップダウンからモデルを選択します。Opus、Sonnet、Haiku の比較については、[モデル](/ja/model-config#available-models)を参照してください。後でこのドロップダウンから同じモデルを変更できます。
+    送信ボタンの横のドロップダウンからモデルを選択します。Opus、Sonnet、Haiku の比較については、[モデル](/ja/model-config#available-models) を参照してください。後でこのドロップダウンから同じモデルを変更できます。
   </Step>
 
@@ -78,9 +78,9 @@ Code タブを開いた状態で、プロジェクトを選択して Claude に
     * `このコードベースの指示を含む CLAUDE.md を作成する`
 
-    [セッション](/ja/desktop#work-in-parallel-with-sessions)は、コードについて Claude との会話です。各セッションは独自のコンテキストと変更を追跡するため、複数のタスクに取り組む際に相互に干渉することなく作業できます。
+    [セッション](/ja/desktop#work-in-parallel-with-sessions) は、コードについて Claude との会話です。各セッションは独自のコンテキストと変更を追跡するため、複数のタスクに取り組む際に相互に干渉することなく作業できます。
   </Step>
```

</details>

<details>
<summary>discover-plugins-ja.md</summary>

```diff
diff --git a/docs-ja/pages/discover-plugins-ja.md b/docs-ja/pages/discover-plugins-ja.md
index 39dd8fc..db5547c 100644
--- a/docs-ja/pages/discover-plugins-ja.md
+++ b/docs-ja/pages/discover-plugins-ja.md
@@ -150,5 +150,9 @@ Anthropic は、プラグインシステムで何が可能かを示す例プラ
 
   <Step title="プラグインをインストールする">
-    プラグインを選択してその詳細を表示します。{/* min-version: 2.1.143 */}Claude Code v2.1.143 以降では、詳細ペインに **Context cost** の推定値が含まれており、インストール前に、プラグインが毎ターン [コンテキストウィンドウ](/ja/features-overview#understand-context-costs) に追加するトークン数を確認できます。{/* min-version: 2.1.144 */}v2.1.144 以降では、ペインにプラグインの **Last updated** 日付も表示されます。
+    プラグインを選択してその詳細を表示します。詳細ペインには、プラグインに含まれるもの、およびそのコストが表示されます：
+
+    * {/* min-version: 2.1.143 */}**Context cost** の推定値。毎ターン [コンテキストウィンドウ](/ja/features-overview#understand-context-costs) にプラグインが追加するトークン数を確認できます（Claude Code v2.1.143 以降）
+    * {/* min-version: 2.1.144 */}プラグインの **Last updated** 日付（v2.1.144 以降）
+    * {/* min-version: 2.1.145 */}プラグインのコマンド、エージェント、スキル、フック、MCP および LSP サーバーをリストアップする **Will install** セクション。インストール前に正確に何が追加されるかを確認できます（v2.1.145 以降）
 
     インストールスコープを選択します：
@@ -180,5 +184,5 @@ Anthropic は、プラグインシステムで何が可能かを示す例プラ
     これにより、変更がステージされ、コミットメッセージが生成され、コミットが作成されます。
 
-    各プラグインは異なる方法で機能します。**Discover** タブのプラグインの説明またはそのホームページをチェックして、提供されるスキルと機能を確認してください。
+    各プラグインは異なる方法で機能します。**Discover** タブのプラグインの詳細を確認して、提供されるコマンドとスキルを確認するか、使用方法のガイダンスについてそのホームページにアクセスしてください。
   </Step>
 </Steps>
```

</details>

*...以降省略*

</details>


<details>
<summary>2026-05-20</summary>

**変更ファイル:**

```
 docs-ja/pages/agent-view-ja.md             |   40 +-
 docs-ja/pages/amazon-bedrock-ja.md         |    4 +-
 docs-ja/pages/changelog.md                 |   76 ++
 docs-ja/pages/channels-reference-ja.md     |   16 +-
 docs-ja/pages/claude-platform-on-aws-ja.md |    4 +-
 docs-ja/pages/cli-reference-ja.md          |    6 +-
 docs-ja/pages/commands-ja.md               |    6 +-
 docs-ja/pages/context-window-en.md         | 1614 ----------------------------
 docs-ja/pages/costs-ja.md                  |    4 +-
 docs-ja/pages/discover-plugins-ja.md       |   45 +-
 docs-ja/pages/env-vars-ja.md               |   86 +-
 docs-ja/pages/errors-ja.md                 |   99 +-
 docs-ja/pages/features-overview-ja.md      |   64 +-
 docs-ja/pages/glossary-ja.md               |   12 +-
 docs-ja/pages/google-vertex-ai-ja.md       |    2 +-
 docs-ja/pages/headless-ja.md               |   22 +-
 docs-ja/pages/hooks-guide-ja.md            |   36 +-
 docs-ja/pages/hooks-ja.md                  |   50 +-
 docs-ja/pages/keybindings-ja.md            |    9 +-
 docs-ja/pages/mcp-ja.md                    |    2 +
 docs-ja/pages/microsoft-foundry-ja.md      |    2 +-
 docs-ja/pages/model-config-ja.md           |   28 +-
 docs-ja/pages/monitoring-usage-ja.md       |   18 +
 docs-ja/pages/output-styles-ja.md          |    4 +-
 docs-ja/pages/permissions-ja.md            |    6 +-
 docs-ja/pages/plugins-ja.md                |   17 +-
 docs-ja/pages/routines-ja.md               |   11 +
 docs-ja/pages/security-ja.md               |    1 +
 docs-ja/pages/settings-ja.md               |   17 +-
 docs-ja/pages/statusline-ja.md             |    2 +
 docs-ja/pages/sub-agents-ja.md             |    2 +-
 docs-ja/pages/tools-reference-ja.md        |    6 +-
 docs-ja/pages/voice-dictation-ja.md        |    2 +-
 33 files changed, 494 insertions(+), 1819 deletions(-)
```

**新規追加:**


**削除:**


<details>
<summary>agent-view-ja.md</summary>

```diff
diff --git a/docs-ja/pages/agent-view-ja.md b/docs-ja/pages/agent-view-ja.md
index 9c0d473..a47438b 100644
--- a/docs-ja/pages/agent-view-ja.md
+++ b/docs-ja/pages/agent-view-ja.md
@@ -182,5 +182,5 @@ Completed
 セッションをリストから削除するには、`Ctrl+X` を押して停止し、2 秒以内に `Ctrl+X` を再度押して削除します。グループヘッダーで `Ctrl+X` を押すと、確認後、そのグループ内のすべてのセッションが削除されます。
 
-削除するとセッションがエージェントビューから削除され、その会話トランスクリプトが削除されます。Claude が [ワークツリーを作成した](#how-file-edits-are-isolated) 場合、削除するとそのワークツリーも削除されます。コミットされていない変更を含みます。保持したい作業をプッシュまたはコミットしてから削除します。自分で作成したワークツリーとセッションを開始した場合は、そのままにしておきます。
+削除するとセッションがエージェントビューから削除されます。Claude が [ワークツリーを作成した](#how-file-edits-are-isolated) 場合、削除するとそのワークツリーも削除されます。コミットされていない変更を含みます。保持したい作業をプッシュまたはコミットしてから削除します。自分で作成したワークツリーとセッションを開始した場合は、そのままにしておきます。会話トランスクリプトはローカルマシンに残り、`claude --resume` を通じて利用可能です。
 
 古い完了したセッションは「… N more」行に折りたたまれ、リストを短く保ちます。失敗とオープンなプルリクエストを持つセッションは常に表示されます。
@@ -229,5 +229,5 @@ Completed
 プロンプトに画像を貼り付けて、タスクにスクリーンショットまたは図を含めます。
 
-プロンプトの一部をプレフィックスまたは言及してセッションの開始方法を制御します。
+プロンプトの一部をプレフィックスまたは言及してセッションの開始方法を制御します：
 
 | 入力                      | 効果                                                                                                       |
@@ -269,4 +269,6 @@ Completed
 * `--allow-dangerously-skip-permissions`
 
+セッション中に [`/add-dir`](/ja/permissions#additional-directories-grant-file-access-not-configuration) で追加したディレクトリも引き継がれます。
+
 `--allow-dangerously-skip-permissions` を引き継ぐことで、バックグラウンド化されたセッションで `bypassPermissions` に到達可能になりますが、新しい権限は付与されません。このモードは、セッションが監視していない状態で承認なしに動作することを許可するため、[パーミッションモード、モデル、および努力](#permission-mode-model-and-effort) で説明されているのと同じ 1 回限りのインタラクティブな受け入れが必要です。
 
@@ -291,8 +293,8 @@ claude --bg --name "flaky-test-fix" "investigate the flaky SettingsChangeDetecto
 ```
 
-バックグラウンド化の後、Claude はセッションの短い ID とセッションを管理するためのコマンドを出力します：
+バックグラウンド化の後、Claude はセッションの短い ID とセッションを管理するためのコマンドを出力します。`--name` を渡すと、短い ID の後に名前が表示されます：
```

</details>

<details>
<summary>amazon-bedrock-ja.md</summary>

```diff
diff --git a/docs-ja/pages/amazon-bedrock-ja.md b/docs-ja/pages/amazon-bedrock-ja.md
index 2665a7e..fa88d72 100644
--- a/docs-ja/pages/amazon-bedrock-ja.md
+++ b/docs-ja/pages/amazon-bedrock-ja.md
@@ -271,5 +271,7 @@ export ENABLE_PROMPT_CACHING_1H=1
 ```
 
-<Note>[プロンプトキャッシング](https://platform.claude.com/docs/en/build-with-claude/prompt-caching)は、すべてのリージョンで利用できない場合があります。1 時間の TTL でのキャッシュ書き込みは、5 分の書き込みよりも高いレートで課金されます。</Note>
+1 時間のキャッシュ TTL は、5 分のデフォルトよりも高いレートで課金されます。[キャッシュライフタイム](/ja/prompt-caching#cache-lifetime)を参照してください。
+
+<Note>プロンプトキャッシングは、すべての Bedrock リージョンで利用できない場合があります。キャッシュトークンカウントがゼロのままの場合は、Bedrock ドキュメントの[サポートされているモデル、リージョン、および制限](https://docs.aws.amazon.com/bedrock/latest/userguide/prompt-caching.html#prompt-caching-models)を確認してください。</Note>
 
 #### 各モデルバージョンを推論プロファイルにマップ
```

</details>

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index 8c6909b..f476a24 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,80 @@
 # Changelog
 
+## 2.1.145
+
+- Added `claude agents --json` to list live Claude sessions as JSON for scripting (tmux-resurrect, status bars, session pickers)
+- Added `agent_id` and `parent_agent_id` attributes to `claude_code.tool` OTEL spans, and fixed trace parenting so background subagent spans nest under the dispatching Agent tool span
+- Status line JSON input now includes GitHub repo and PR information when detected
+- `/plugin` Discover and Browse screens now show a plugin's commands, agents, skills, hooks, and MCP/LSP servers before installation
+- `claude agents` terminal tab title now shows the awaiting-input count so an alt-tabbed window tells you when an agent needs attention
+- Slash command and @-mention suggestion list now supports mouse hover and click in fullscreen mode
+- Stop and SubagentStop hook input now includes `background_tasks` and `session_crons` fields
+- Fixed a permission-prompt bypass where bare variable assignments to non-allowlisted environment variables in Bash commands were auto-approved
+- Fixed MCP prompt slash commands showing raw server validation errors when a required argument is omitted — the error now names the missing argument and shows expected usage
+- Fixed the spinner and elapsed-time display freezing until a keypress after the terminal was resized or refocused
+- Fixed the cross-project resume hint failing in default Windows PowerShell 5.1 — Windows now uses `;` as the command separator
+- Fixed voice push-to-talk not working in the agent view's reply pane
+- Fixed task lists rendering in random order when several tasks are created at once
+- Fixed stale "Failed to install Anthropic marketplace" banner showing when the marketplace is already installed
+- Fixed the PR badge in the footer not updating immediately after `gh pr create` and other PR-state-changing commands run in-session
+- Fixed Agent Teams teammates with non-ASCII names failing every API call due to invalid header encoding
+- Fixed `/review` using a deprecated `projectCards` GraphQL query that errored on repos with Classic Projects
+- Fixed `claude plugin validate` not flagging `skills:` entries that point at a file instead of a directory — the error now suggests the parent directory
+- Fixed an infinite loop where a skill using `context: fork` could repeatedly re-invoke itself instead of running
+- Improved the Read tool to return a truncated first page with a "PARTIAL view" notice instead of a hard error when a whole-file read exceeds the token limit
+
```

</details>

<details>
<summary>channels-reference-ja.md</summary>

```diff
diff --git a/docs-ja/pages/channels-reference-ja.md b/docs-ja/pages/channels-reference-ja.md
index 0fcdb31..d3e6664 100644
--- a/docs-ja/pages/channels-reference-ja.md
+++ b/docs-ja/pages/channels-reference-ja.md
@@ -8,5 +8,5 @@
 
 <Note>
-  チャネルは[リサーチプレビュー](/ja/channels#research-preview)段階にあり、Claude Code v2.1.80 以降が必要です。claude.ai ログインが必要です。Console と API キー認証はサポートされていません。Team および Enterprise 組織は[明示的に有効化](/ja/channels#enterprise-controls)する必要があります。
+  チャネルは[リサーチプレビュー](/ja/channels#research-preview)段階にあり、Claude Code v2.1.80 以降が必要です。Team および Enterprise 組織は[明示的に有効化](/ja/channels#enterprise-controls)する必要があります。
 </Note>
 
@@ -21,5 +21,5 @@
 * [例：webhook レシーバーを構築](#example-build-a-webhook-receiver)：最小限の一方向ウォークスルー
 * [サーバーオプション](#server-options)：コンストラクタフィールド
-* [通知フォーマット](#notification-format)：イベントペイロード
+* [通知フォーマット](#notification-format)：イベントペイロードと配信動作
 * [返信ツールを公開](#expose-a-reply-tool)：Claude がメッセージを返送できるようにする
 * [インバウンドメッセージをゲート](#gate-inbound-messages)：プロンプトインジェクションを防ぐための送信者チェック
@@ -139,5 +139,5 @@
     Claude Code が起動すると、MCP 設定を読み込み、`webhook.ts` をサブプロセスとして生成し、HTTP リスナーは設定したポート（この例では 8788）で自動的に開始されます。サーバーを自分で実行する必要はありません。
 
-    'ブロックされた組織ポリシー'が表示される場合は、Team または Enterprise 管理者が最初に[チャネルを有効化](/ja/channels#enterprise-controls)する必要があります。
+    'ブロックされた組織ポリシー'が表示される場合は、組織管理者が最初に[チャネルを有効化](/ja/channels#enterprise-controls)する必要があります。
 
     別のターミナルで、HTTP POST でメッセージを送信して webhook をシミュレートします。この例は、CI 失敗アラートをポート 8788（または設定したポート）に送信します：
@@ -242,4 +242,10 @@ build failed on main: https://ci.example.com/run/1234
 ```
 
+通知は確認されません。`mcp.notification()` の `await` は、メッセージがトランスポートに書き込まれるときに解決され、Claude が処理したときではありません。セッションがチャネルとしてサーバーを読み込んでいない場合、または組織ポリシーがそれをブロックしている場合、イベントはサーバーにエラーが返されることなくサイレントにドロップされます。
+
```

</details>

<details>
<summary>claude-platform-on-aws-ja.md</summary>

```diff
diff --git a/docs-ja/pages/claude-platform-on-aws-ja.md b/docs-ja/pages/claude-platform-on-aws-ja.md
index 796145a..c8092a0 100644
--- a/docs-ja/pages/claude-platform-on-aws-ja.md
+++ b/docs-ja/pages/claude-platform-on-aws-ja.md
@@ -275,7 +275,7 @@ export ANTHROPIC_DEFAULT_HAIKU_MODEL=claude-haiku-4-5
 ```
 
-モデル ID とエイリアスの完全なリストについては、[モデル概要](https://platform.claude.com/docs/en/about-claude/models/overview)を参照してください。その他のモデル関連の変数については、[モデル設定](/ja/model-config)を参照してください。
+モデル ID とエイリアスの完全なリストについては、[モデル概要](https://platform.claude.com/docs/en/about-claude/models/overview) を参照してください。その他のモデル関連の変数については、[モデル設定](/ja/model-config) を参照してください。
 
-[プロンプトキャッシング](https://platform.claude.com/docs/en/build-with-claude/prompt-caching)は自動的に有効になります。1 時間のキャッシュ書き込みは 5 分の書き込みよりも高いレートで請求されます。5 分のデフォルトの代わりに 1 時間のキャッシュ TTL をリクエストするには、`ENABLE_PROMPT_CACHING_1H=1` を設定します。
+[プロンプトキャッシング](/ja/prompt-caching) は自動的に有効になります。5 分のデフォルトの代わりに 1 時間のキャッシュ TTL をリクエストするには、`ENABLE_PROMPT_CACHING_1H=1` を設定します。API は 1 時間のキャッシュ書き込みをより高いレートで請求します。レートについては、[プロンプトキャッシング価格](https://platform.claude.com/docs/en/build-with-claude/prompt-caching#pricing) を参照してください。
 
 ## Agent SDK を使用する
```

</details>

<details>
<summary>cli-reference-ja.md</summary>

```diff
diff --git a/docs-ja/pages/cli-reference-ja.md b/docs-ja/pages/cli-reference-ja.md
index 963b558..7f876e7 100644
--- a/docs-ja/pages/cli-reference-ja.md
+++ b/docs-ja/pages/cli-reference-ja.md
@@ -35,5 +35,5 @@
 | `claude remote-control`         | [Remote Control](/ja/remote-control) サーバーを開始して、Claude.ai または Claude アプリから Claude Code を制御します。サーバーモード（ローカルインタラクティブセッションなし）で実行されます。[サーバーモードフラグ](/ja/remote-control#start-a-remote-control-session) を参照してください                                                                                                                                                          | `claude remote-control --name "My Project"`                 |
 | `claude respawn <id>`           | 会話を保持したまま、[バックグラウンドセッション](/ja/agent-view#manage-sessions-from-the-shell) を再開します。実行中または停止中。`--all` を使用してすべての実行中セッションを再開します。たとえば、更新された Claude Code バイナリを取得するため                                                                                                                                                                                                        | `claude respawn 7c5dcf5d`                                   |
-| `claude rm <id>`                | [バックグラウンドセッション](/ja/agent-view#manage-sessions-from-the-shell) をリストから削除します                                                                                                                                                                                                                                                                                          | `claude rm 7c5dcf5d`                                        |
+| `claude rm <id>`                | [バックグラウンドセッション](/ja/agent-view#manage-sessions-from-the-shell) をリストから削除します。会話トランスクリプトはローカルマシンに残り、`claude --resume` を通じて利用可能です                                                                                                                                                                                                                                       | `claude rm 7c5dcf5d`                                        |
 | `claude setup-token`            | CI とスクリプト用の長期間有効な OAuth トークンを生成します。ターミナルにトークンを出力し、保存しません。Claude サブスクリプションが必要です。[長期間有効なトークンを生成](/ja/authentication#generate-a-long-lived-token) を参照してください                                                                                                                                                                                                            | `claude setup-token`                                        |
 | `claude stop <id>`              | [バックグラウンドセッション](/ja/agent-view#manage-sessions-from-the-shell) を停止します。`claude kill` も受け入れます                                                                                                                                                                                                                                                                         | `claude stop 7c5dcf5d`                                      |
@@ -66,5 +66,5 @@
 | `--debug-file <path>`                           | デバッグログを特定のファイルパスに書き込みます。暗黙的にデバッグモードを有効にします。`CLAUDE_CODE_DEBUG_LOGS_DIR` より優先されます                                                                                                                                                                                                                                            | `claude --debug-file /tmp/claude-debug.log`                                                        |
 | `--disable-slash-commands`                      | このセッションのすべてのスキルとコマンドを無効にします                                                                                                                                                                                                                                                                                                 | `claude --disable-slash-commands`                                                                  |
-| `--disallowedTools`                             | モデルのコンテキストから削除され、使用できないツール                                                                                                                                                                                                                                                                                                  | `"Bash(git log *)" "Bash(git diff *)" "Edit"`                                                      |
+| `--disallowedTools`                             | 拒否ルール。ベアツール名はそのツールをモデルのコンテキストから削除します。`Bash(rm *)` のようなスコープ付きルールはツールを利用可能なままにし、一致する呼び出しのみを拒否します                                                                                                                                                                                                                              | `"Bash(git log *)" "Bash(git diff *)" "Edit"`                                                      |
 | `--effort`                                      | 現在のセッションの [努力レベル](/ja/model-config#adjust-effort-level) を設定します。オプション：`low`、`medium`、`high`、`xhigh`、`max`。利用可能なレベルはモデルによって異なります。[`effortLevel`](/ja/settings#available-settings) 設定をこのセッションでオーバーライドし、永続化されません                                                                                                                | `claude --effort high`                                                                             |
 | `--enable-auto-mode`                            | {/* max-version: 2.1.110 */}v2.1.111 で削除されました。Auto mode は現在 `Shift+Tab` サイクルにデフォルトで含まれています。`--permission-mode auto` を使用して開始してください                                                                                                                                                                                           | `claude --permission-mode auto`                                                                    |
@@ -98,5 +98,5 @@
 | `--remote-control-session-name-prefix <prefix>` | 明示的な名前が設定されていない場合、自動生成される [Remote Control](/ja/remote-control) セッション名のプレフィックス。デフォルトはマシンのホスト名で、`myhost-graceful-unicorn` のような名前が生成されます。同じ効果を得るには `CLAUDE_REMOTE_CONTROL_SESSION_NAME_PREFIX` を設定してください                                                                                                                       | `claude remote-control --remote-control-session-name-prefix dev-box`                               |
 | `--replay-user-messages`                        | stdin からのユーザーメッセージを stdout に再発行して確認します。`--input-format stream-json` と `--output-format stream-json` が必要です                                                                                                                                                                                                                   | `claude -p --input-format stream-json --output-format stream-json --replay-user-messages`          |
-| `--resume`, `-r`                                | ID または名前で特定のセッションを再開するか、セッションを選択するためのインタラクティブピッカーを表示します。このディレクトリを `/add-dir` で追加したセッションを含みます                                                                                                                                                                                                                                | `claude --resume auth-refactor`                                                                    |
+| `--resume`, `-r`                                | ID または名前で特定のセッションを再開するか、セッションを選択するためのインタラクティブピッカーを表示します。このディレクトリを `/add-dir` で追加したセッションを含みます。v2.1.144 以降、[バックグラウンドセッション](/ja/agent-view) はピッカーに `bg` でマークされて表示されます                                                                                                                                                          | `claude --resume auth-refactor`                                                                    |
 | `--session-id`                                  | 会話に特定のセッション ID を使用します（有効な UUID である必要があります）                                                                                                                                                                                                                                                                                  | `claude --session-id "550e8400-e29b-41d4-a716-446655440000"`                                       |
 | `--setting-sources`                             | 読み込む設定ソースのカンマ区切りリスト（`user`、`project`、`local`）                                                                                                                                                                                                                                                                               | `claude --setting-sources user,project`                                                            |
```

</details>

<details>
<summary>commands-ja.md</summary>

```diff
diff --git a/docs-ja/pages/commands-ja.md b/docs-ja/pages/commands-ja.md
index a5efe68..11b3094 100644
--- a/docs-ja/pages/commands-ja.md
+++ b/docs-ja/pages/commands-ja.md
@@ -64,5 +64,5 @@
 | `/export [filename]`                            | 現在の会話をプレーンテキストとしてエクスポートします。ファイル名を指定すると、そのファイルに直接書き込みます。指定しない場合、クリップボードにコピーするか、ファイルに保存するダイアログを開きます                                                                                                                                                                                                                                                                                                                                                                                                              |
 | `/fast [on\|off]`                               | [高速モード](/ja/fast-mode)のオン/オフを切り替えます                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
-| `/feedback [report]`                            | Claude Code に関するフィードバックを送信します。エイリアス: `/bug`                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
+| `/feedback [report]`                            | フィードバックを送信し、バグを報告するか、会話を共有します。エイリアス: `/bug`、`/share`                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
 | `/fewer-permission-prompts`                     | **[スキル](/ja/skills#bundled-skills)。** トランスクリプトで一般的な読み取り専用 Bash と MCP ツール呼び出しをスキャンし、プロジェクト `.claude/settings.json` に優先度付きの許可リストを追加して権限プロンプトを削減します                                                                                                                                                                                                                                                                                                                                                               |
 | `/focus`                                        | フォーカスビューを切り替えます。最後のプロンプト、編集 diffstats を含む 1 行のツール呼び出し要約、および最終応答のみを表示します。選択は複数セッション間で保持されます。設定で [`viewMode`](/ja/settings#available-settings) を設定してオーバーライドします。[フルスクリーンレンダリング](/ja/fullscreen)でのみ利用可能です                                                                                                                                                                                                                                                                                                          |
@@ -83,5 +83,5 @@
 | `/memory`                                       | `CLAUDE.md` メモリファイルを編集し、[自動メモリ](/ja/memory#auto-memory)を有効または無効にし、自動メモリエントリを表示します                                                                                                                                                                                                                                                                                                                                                                                                                              |
 | `/mobile`                                       | Claude モバイルアプリをダウンロードするための QR コードを表示します。エイリアス: `/ios`、`/android`                                                                                                                                                                                                                                                                                                                                                                                                                                               |
-| `/model [model]`                                | AI モデルを選択または変更します。サポートしているモデルの場合、左右矢印を使用して[努力レベルを調整](/ja/model-config#adjust-effort-level)します。引数なしで、会話に前の出力がある場合に確認を求めるピッカーを開きます。次の応答はキャッシュされたコンテキストなしで完全な履歴を再読み込みするためです。確認されると、現在の応答の完了を待たずに変更が適用されます                                                                                                                                                                                                                                                                                                         |
+| `/model [model]`                                | 現在のセッションの AI モデルを設定します。サポートしているモデルの場合、左右矢印を使用して[努力レベルを調整](/ja/model-config#adjust-effort-level)します。引数なしで、ピッカーを開きます。ピッカーで `d` を押して、そのモデルを新しいセッションのデフォルトとして保存することもできます。会話に前の出力がある場合、ピッカーは確認を求めます。次の応答はキャッシュされたコンテキストなしで完全な履歴を再読み込みするためです。確認されると、現在の応答の完了を待たずに変更が適用されます                                                                                                                                                                                                                                           |
 | `/passes`                                       | Claude Code の無料 1 週間を友人と共有します。アカウントが対象の場合のみ表示されます                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
 | `/permissions`                                  | ツール権限のアクセス許可、確認、および拒否ルールを管理します。スコープ別にルールを表示し、ルールを追加または削除し、作業ディレクトリを管理し、[最近の自動モード拒否](/ja/auto-mode-config#review-denials)を確認できるインタラクティブダイアログを開きます。エイリアス: `/allowed-tools`                                                                                                                                                                                                                                                                                                                                       |
@@ -98,5 +98,5 @@
 | `/remote-env`                                   | [`--remote` で開始されたウェブセッション](/ja/claude-code-on-the-web#configure-your-environment)のデフォルトリモート環境を構成します                                                                                                                                                                                                                                                                                                                                                                                                           |
 | `/rename [name]`                                | 現在のセッションの名前を変更してプロンプトバーに名前を表示します。名前を指定しない場合、会話履歴から自動生成されます                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
-| `/resume [session]`                             | ID または名前で会話を再開するか、セッションピッカーを開きます。エイリアス: `/continue`                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
+| `/resume [session]`                             | ID または名前で会話を再開するか、セッションピッカーを開きます。v2.1.144 以降、[バックグラウンドセッション](/ja/agent-view)はピッカーに `bg` とマークされて表示されます。エイリアス: `/continue`                                                                                                                                                                                                                                                                                                                                                                                       |
 | `/review [PR]`                                  | 現在のセッションでプルリクエストをローカルでレビューします。より深いクラウドベースのレビューについては、[`/ultrareview`](/ja/ultrareview)を参照してください                                                                                                                                                                                                                                                                                                                                                                                                                 |
 | `/rewind`                                       | 会話またはコードを前の時点に巻き戻すか、選択したメッセージから要約します。[チェックポイント](/ja/checkpointing)を参照してください。エイリアス: `/checkpoint`、`/undo`                                                                                                                                                                                                                                                                                                                                                                                                       |
```

</details>

*...以降省略*

</details>


<details>
<summary>2026-05-19</summary>

**変更ファイル:**

```
 docs-ja/pages/agent-view-ja.md          | 115 +++++++++++++++++++++++---------
 docs-ja/pages/cli-reference-ja.md       |  57 ++++++++--------
 docs-ja/pages/code-review-ja.md         |   4 +-
 docs-ja/pages/commands-ja.md            |   6 +-
 docs-ja/pages/debug-your-config-ja.md   |  36 +++++-----
 docs-ja/pages/desktop-ja.md             |   3 +-
 docs-ja/pages/discover-plugins-ja.md    |   4 +-
 docs-ja/pages/env-vars-ja.md            |  21 +++---
 docs-ja/pages/errors-ja.md              |  16 +++--
 docs-ja/pages/fast-mode-ja.md           |  56 +++-------------
 docs-ja/pages/features-overview-ja.md   |   4 +-
 docs-ja/pages/hooks-guide-ja.md         |   8 ++-
 docs-ja/pages/hooks-ja.md               |   4 +-
 docs-ja/pages/mcp-ja.md                 |   4 +-
 docs-ja/pages/model-config-ja.md        |  54 +++++++--------
 docs-ja/pages/overview-ja.md            |   2 +-
 docs-ja/pages/permission-modes-ja.md    |  26 ++++----
 docs-ja/pages/plugin-dependencies-ja.md |  24 +++++++
 docs-ja/pages/plugin-marketplaces-ja.md |   3 +-
 docs-ja/pages/plugins-reference-ja.md   |  13 ++--
 docs-ja/pages/remote-control-ja.md      |   2 +-
 docs-ja/pages/routines-ja.md            |   2 +-
 docs-ja/pages/scheduled-tasks-ja.md     |   2 +-
 docs-ja/pages/settings-ja.md            |  33 ++++-----
 docs-ja/pages/skills-ja.md              |  10 +--
 docs-ja/pages/statusline-ja.md          |   1 +
 docs-ja/pages/sub-agents-ja.md          |  32 ++++++++-
 docs-ja/pages/tools-reference-ja.md     |   3 +-
 docs-ja/pages/ultrareview-ja.md         |   2 +-
 29 files changed, 322 insertions(+), 225 deletions(-)
```

<details>
<summary>agent-view-ja.md</summary>

```diff
diff --git a/docs-ja/pages/agent-view-ja.md b/docs-ja/pages/agent-view-ja.md
index bbb89ed..9c0d473 100644
--- a/docs-ja/pages/agent-view-ja.md
+++ b/docs-ja/pages/agent-view-ja.md
@@ -73,7 +73,13 @@ Claude が複数の独立したタスクに対して、あなたが毎ステッ
 `claude agents` を実行してエージェントビューを開きます。ターミナル全体を占有し、状態でグループ化されたすべてのセッションをリストします。ピン留めされたセッションと入力が必要なセッションが上部に表示されます。各行はセッションの名前、現在のアクティビティ、最後に変更されてからの経過時間を表示します。
 
-リストはすべてのプロジェクト全体で開始したすべてのバックグラウンドセッションを表示します。1 つのリポジトリで作業しているセッションと別のワークツリーで作業している別のセッションの両方がここに表示されます。エージェントビューを開いたディレクトリに関係なく表示されます。他のターミナルで開いているインタラクティブセッションは、[バックグラウンドにする](#from-inside-a-session)までは表示されません。[Subagents](/ja/sub-agents) と [teammates](/ja/agent-teams) はセッションが生成しても個別の行としてリストされません。
+デフォルトでは、リストはすべてのプロジェクト全体で開始したすべてのバックグラウンドセッションを表示します。1 つのリポジトリで作業しているセッションと別のワークツリーで作業している別のセッションの両方がここに表示されます。エージェントビューを開いたディレクトリに関係なく表示されます。リストを 1 つのプロジェクトに絞り込むには、`--cwd` を渡します（Claude Code v2.1.141 以降が必要です）。
 
-ビューを 1 つのプロジェクトにスコープするには、`claude agents --cwd <path>` で起動します。そのディレクトリの下で開始されたセッションのみが表示されます。これには、そこからディスパッチされた [ワークツリー](/ja/worktrees) で実行されているセッションも含まれます。
+```bash theme={null}
+claude agents --cwd ~/projects/my-app
+```
+
+これはそのディレクトリの下で開始されたセッションのみを表示します。`~/projects/my-app/.claude/worktrees/` の下の [ワークツリーに移動した](#how-file-edits-are-isolated) セッションは、`~/projects/my-app` に属するものとしてカウントされます。
+
+他のターミナルで開いているインタラクティブセッションは、[バックグラウンドにする](#from-inside-a-session)までは表示されません。[Subagents](/ja/sub-agents) と [teammates](/ja/agent-teams) はセッションが生成しても個別の行としてリストされません。
 
 ```text theme={null}
@@ -118,7 +124,9 @@ Completed
 | `✢`                | [`/loop`](/ja/scheduled-tasks) セッションはイテレーション間でスリープしています。行は実行回数とカウントダウンを表示します |
 
+行の右端に表示される `●` は [プルリクエストステータス](#pull-request-status) インジケーターであり、状態アイコンの一部ではありません。その前の数字はセッションが開いたプルリクエストの数です。
+
 バックグラウンドセッションは作業を続けるためにターミナルを開く必要がありません。別の [スーパーバイザープロセス](#the-supervisor-process) がセッションを実行するため、エージェントビューを閉じたり、シェルを閉じたり、新しいインタラクティブセッションを開始したりしても、ディスパッチされた作業は続きます。
 
-セッション状態はディスク上に永続化され、自動更新とスーパーバイザー再起動を通じて保存されます。マシンがスリープまたはシャットダウンした場合、実行中のセッションは停止します。`claude respawn --all` で再開します。
+セッション状態はディスク上に永続化され、自動更新とスーパーバイザー再起動を通じて保存されます。セッションはマシンがスリープするときも保存されます。プロセスはウェイク時に再開され、スーパーバイザーはアイドルとして時間ギャップを扱う代わりにそれらに再接続します。シャットダウンはまだ実行中のセッションを停止します。[シャットダウン後にセッションが失敗として表示される](#sessions-show-as-failed-after-shutdown) を参照して、それらを復旧する方法を確認してください。
 
```

</details>

<details>
<summary>cli-reference-ja.md</summary>

```diff
diff --git a/docs-ja/pages/cli-reference-ja.md b/docs-ja/pages/cli-reference-ja.md
index 438c1b0..963b558 100644
--- a/docs-ja/pages/cli-reference-ja.md
+++ b/docs-ja/pages/cli-reference-ja.md
@@ -11,31 +11,32 @@
 これらのコマンドを使用して、セッションを開始し、コンテンツをパイプし、会話を再開し、更新を管理できます。
 
-| コマンド                            | 説明                                                                                                                                                                                                                                                                                                             | 例                                                           |
-| :------------------------------ | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :---------------------------------------------------------- |
-| `claude`                        | インタラクティブセッションを開始                                                                                                                                                                                                                                                                                               | `claude`                                                    |
-| `claude "query"`                | 初期プロンプト付きでインタラクティブセッションを開始                                                                                                                                                                                                                                                                                     | `claude "explain this project"`                             |
-| `claude -p "query"`             | SDK 経由でクエリを実行してから終了                                                                                                                                                                                                                                                                                            | `claude -p "explain this function"`                         |
-| `cat file \| claude -p "query"` | パイプされたコンテンツを処理                                                                                                                                                                                                                                                                                                 | `cat logs.txt \| claude -p "explain"`                       |
-| `claude -c`                     | 現在のディレクトリで最新の会話を続行                                                                                                                                                                                                                                                                                             | `claude -c`                                                 |
-| `claude -c -p "query"`          | SDK 経由で続行                                                                                                                                                                                                                                                                                                      | `claude -c -p "Check for type errors"`                      |
-| `claude -r "<session>" "query"` | セッション ID または名前でセッションを再開                                                                                                                                                                                                                                                                                        | `claude -r "auth-refactor" "Finish this PR"`                |
-| `claude update`                 | 最新バージョンに更新                                                                                                                                                                                                                                                                                                     | `claude update`                                             |
-| `claude install [version]`      | ネイティブバイナリをインストールまたは再インストールします。`2.1.118` のようなバージョン、または `stable` または `latest` を受け入れます。[特定のバージョンをインストール](/ja/setup#install-a-specific-version) を参照してください                                                                                                                                                          | `claude install stable`                                     |
-| `claude auth login`             | Anthropic アカウントにサインインします。`--email` を使用してメールアドレスを事前入力し、`--sso` を使用して SSO 認証を強制し、`--console` を使用して Claude サブスクリプションの代わりに Anthropic Console で API 使用料金をサインインできます                                                                                                                                                  | `claude auth login --console`                               |
-| `claude auth logout`            | Anthropic アカウントからログアウト                                                                                                                                                                                                                                                                                         | `claude auth logout`                                        |
-| `claude auth status`            | 認証ステータスを JSON として表示します。`--text` を使用して人間が読める形式で表示できます。ログイン済みの場合はコード 0 で終了し、ログインしていない場合は 1 で終了します                                                                                                                                                                                                                | `claude auth status`                                        |
-| `claude agents`                 | [エージェントビュー](/ja/agent-view) を開いて、並列バックグラウンドセッションを監視およびディスパッチします。`--cwd <path>` を使用して、そのディレクトリの下で開始されたセッションのみを表示します                                                                                                                                                                                             | `claude agents`                                             |
-| `claude attach <id>`            | このターミナルで [バックグラウンドセッション](/ja/agent-view#manage-sessions-from-the-shell) に接続します                                                                                                                                                                                                                                 | `claude attach 7c5dcf5d`                                    |
-| `claude auto-mode defaults`     | 組み込み [auto mode](/ja/permission-modes#eliminate-prompts-with-auto-mode) 分類器ルールを JSON として出力します。`claude auto-mode config` を使用して、設定が適用された有効な設定を確認してください                                                                                                                                                           | `claude auto-mode defaults > rules.json`                    |
-| `claude logs <id>`              | [バックグラウンドセッション](/ja/agent-view#manage-sessions-from-the-shell) からの最近の出力を出力します                                                                                                                                                                                                                                  | `claude logs 7c5dcf5d`                                      |
-| `claude mcp`                    | Model Context Protocol（MCP）サーバーを設定                                                                                                                                                                                                                                                                             | [Claude Code MCP ドキュメント](/ja/mcp) を参照してください。                |
-| `claude plugin`                 | Claude Code [plugins](/ja/plugins) を管理します。エイリアス：`claude plugins`。サブコマンドについては [plugin reference](/ja/plugins-reference#cli-commands-reference) を参照してください                                                                                                                                                        | `claude plugin install code-review@claude-plugins-official` |
-| `claude project purge [path]`   | プロジェクトのすべてのローカル Claude Code 状態を削除します：トランスクリプト、タスクリスト、デバッグログ、ファイル編集履歴、プロンプト履歴行、および `~/.claude.json` 内のプロジェクトエントリ。`[path]` を省略して、インタラクティブリストから選択します。フラグ：`--dry-run` でプレビュー、`-y`/`--yes` で確認をスキップ、`-i`/`--interactive` で各項目を確認、`--all` ですべてのプロジェクト。[ローカルデータをクリア](/ja/claude-directory#clear-local-data) を参照してください | `claude project purge ~/work/repo --dry-run`                |
-| `claude remote-control`         | [Remote Control](/ja/remote-control) サーバーを開始して、Claude.ai または Claude アプリから Claude Code を制御します。サーバーモード（ローカルインタラクティブセッションなし）で実行されます。[サーバーモードフラグ](/ja/remote-control#start-a-remote-control-session) を参照してください                                                                                                     | `claude remote-control --name "My Project"`                 |
-| `claude respawn <id>`           | 会話を保持したまま、停止した [バックグラウンドセッション](/ja/agent-view#manage-sessions-from-the-shell) を再開します。`--all` を使用してすべての停止したセッションを再開します                                                                                                                                                                                          | `claude respawn 7c5dcf5d`                                   |
```

</details>

<details>
<summary>code-review-ja.md</summary>

```diff
diff --git a/docs-ja/pages/code-review-ja.md b/docs-ja/pages/code-review-ja.md
index 080d8e9..eacd4b1 100644
--- a/docs-ja/pages/code-review-ja.md
+++ b/docs-ja/pages/code-review-ja.md
@@ -30,5 +30,5 @@ Claude を管理サービスではなく独自の CI インフラストラクチ
 管理者が組織の Code Review を[有効にする](#set-up-code-review)と、リポジトリの設定された動作に応じて、PR が開かれたとき、すべてのプッシュ時、または手動でリクエストされたときにレビューがトリガーされます。PR で `@claude review` と[コメントすると](#manually-trigger-reviews)、任意のモードでレビューが開始されます。
 
-レビューが実行されると、複数のエージェントが Anthropic インフラストラクチャ上で並行して diff と周囲のコードを分析します。各エージェントは異なるクラスの問題を探し、その後、検証ステップが候補を実際のコード動作に対してチェックして、偽陽性を除外します。結果は重複排除され、重大度でランク付けされ、問題が見つかった特定の行にインラインコメントとして投稿されます。問題が見つからない場合、Claude は PR に短い確認コメントを投稿します。
+レビューが実行されると、複数のエージェントが Anthropic インフラストラクチャ上で並行して diff と周囲のコードを分析します。各エージェントは異なるクラスの問題を探し、その後、検証ステップが候補を実際のコード動作に対してチェックして、偽陽性を除外します。結果は重複排除され、重大度でランク付けされ、問題が見つかった特定の行にインラインコメントとして投稿され、レビュー本文に概要が記載されます。問題が見つからない場合、Code Review は GitHub チェック実行を更新して、問題が検出されなかったことを表示します。Claude は PR に短い確認コメントを投稿することもあります。
 
 レビューはコストが PR のサイズと複雑さに応じてスケーリングされ、平均 20 分で完了します。管理者は[分析ダッシュボード](#view-usage)を通じてレビューアクティビティと支出を監視できます。
@@ -226,5 +226,5 @@ Important は、動作を壊す、データをリークする、またはロー
 ## 料金
 
-Code Review はトークン使用量に基づいて請求されます。各レビューは平均 \$15～25 のコストで、PR サイズ、コードベースの複雑さ、検証が必要な問題の数に応じてスケーリングされます。Code Review の使用は[extra usage](https://support.claude.com/en/articles/12429409-extra-usage-for-paid-claude-plans)を通じて個別に請求され、プランの含まれた使用量にはカウントされません。
+Code Review はトークン使用量に基づいて請求されます。各レビューは平均 \$15～25 のコストで、PR サイズ、コードベースの複雑さ、検証が必要な問題の数に応じてスケーリングされます。Code Review の使用は[usage credits](https://support.claude.com/ja/articles/12429409-extra-usage-for-paid-claude-plans)を通じて個別に請求され、プランの含まれた使用量にはカウントされません。
 
 選択するレビュートリガーは総コストに影響します：
```

</details>

<details>
<summary>commands-ja.md</summary>

```diff
diff --git a/docs-ja/pages/commands-ja.md b/docs-ja/pages/commands-ja.md
index 38f411a..a5efe68 100644
--- a/docs-ja/pages/commands-ja.md
+++ b/docs-ja/pages/commands-ja.md
@@ -61,7 +61,6 @@
 | `/doctor`                                       | Claude Code のインストールと設定を診断および検証します。結果はステータスアイコン付きで表示されます。`f` を押して Claude に報告された問題を修正させます                                                                                                                                                                                                                                                                                                                                                                                                                        |
 | `/effort [level\|auto]`                         | モデルの[努力レベル](/ja/model-config#adjust-effort-level)を設定します。`low`、`medium`、`high`、`xhigh`、または `max` を受け入れます。利用可能なレベルはモデルに依存し、`max` はセッションのみです。`auto` はモデルのデフォルトにリセットします。引数なしで、インタラクティブスライダーを開きます。左右矢印でレベルを選択し、`Enter` で適用します。現在の応答の完了を待たずに即座に有効になります                                                                                                                                                                                                                                                               |
-| `/exit`                                         | CLI を終了します。エイリアス: `/quit`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
+| `/exit`                                         | CLI を終了します。接続されている[バックグラウンドセッション](/ja/agent-view#attach-to-a-session)では、これはデタッチされ、セッションは実行を続けます。エイリアス: `/quit`                                                                                                                                                                                                                                                                                                                                                                                                 |
 | `/export [filename]`                            | 現在の会話をプレーンテキストとしてエクスポートします。ファイル名を指定すると、そのファイルに直接書き込みます。指定しない場合、クリップボードにコピーするか、ファイルに保存するダイアログを開きます                                                                                                                                                                                                                                                                                                                                                                                                              |
-| `/extra-usage`                                  | レート制限に達したときに作業を続行するための追加使用量を構成します                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
 | `/fast [on\|off]`                               | [高速モード](/ja/fast-mode)のオン/オフを切り替えます                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
 | `/feedback [report]`                            | Claude Code に関するフィードバックを送信します。エイリアス: `/bug`                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
@@ -122,7 +121,8 @@
 | `/tui [default\|fullscreen]`                    | ターミナル UI レンダラーを設定し、会話を保持したまま再起動します。`fullscreen` は[ちらつきなしの alt-screen レンダラー](/ja/fullscreen)を有効にします。引数なしで、アクティブなレンダラーを出力します                                                                                                                                                                                                                                                                                                                                                                                     |
 | `/ultraplan <prompt>`                           | [ultraplan](/ja/ultraplan) セッションで計画を作成し、ブラウザでレビューし、リモートで実行するか、ターミナルに送り返します                                                                                                                                                                                                                                                                                                                                                                                                                                     |
-| `/ultrareview [PR]`                             | [ultrareview](/ja/ultrareview) を使用してクラウドサンドボックスで深い複数エージェントコードレビューを実行します。Pro と Max に 3 つの無料実行が含まれ、その後は [extra usage](https://support.claude.com/en/articles/12429409-extra-usage-for-paid-claude-plans) が必要です                                                                                                                                                                                                                                                                                                   |
+| `/ultrareview [PR]`                             | [ultrareview](/ja/ultrareview) を使用してクラウドサンドボックスで深い複数エージェントコードレビューを実行します。Pro と Max に 3 つの無料実行が含まれ、その後は [usage credits](https://support.claude.com/en/articles/12429409-extra-usage-for-paid-claude-plans) が必要です                                                                                                                                                                                                                                                                                                 |
 | `/upgrade`                                      | アップグレードページを開いて、より高いプランティアに切り替えます                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
 | `/usage`                                        | セッションコスト、プラン使用制限、およびアクティビティ統計を表示します。サブスクリプション固有の詳細については、[コスト追跡ガイド](/ja/costs#using-the-%2Fusage-command)を参照してください。`/cost` と `/stats` はエイリアスです                                                                                                                                                                                                                                                                                                                                                                  |
+| `/usage-credits`                                | 制限に達したときに作業を続行するための usage credits を構成します。以前は `/extra-usage`                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
 | `/vim`                                          | {/* max-version: 2.1.91 */}v2.1.92 で削除。Vim と通常編集モード間を切り替えるには、`/config` → エディタモードを使用してください                                                                                                                                                                                                                                                                                                                                                                                                                      |
 | `/voice [hold\|tap\|off]`                       | [音声ディクテーション](/ja/voice-dictation)を切り替えるか、特定のモードで有効にします。Claude.ai アカウントが必要です                                                                                                                                                                                                                                                                                                                                                                                                                                    |
```

</details>

<details>
<summary>debug-your-config-ja.md</summary>

```diff
diff --git a/docs-ja/pages/debug-your-config-ja.md b/docs-ja/pages/debug-your-config-ja.md
index 846395c..5960e71 100644
--- a/docs-ja/pages/debug-your-config-ja.md
+++ b/docs-ja/pages/debug-your-config-ja.md
@@ -87,22 +87,22 @@ cd /tmp && CLAUDE_CONFIG_DIR=/tmp/claude-clean claude
 ほとんどの設定の問題は、小さな場所とシンタックスルールのセットに遡ります。バグを想定する前にこれらを確認してください：
 
-| 症状                                                         | 原因                                                                       | 修正                                                                                                                                                      |
-| :--------------------------------------------------------- | :----------------------------------------------------------------------- | :------------------------------------------------------------------------------------------------------------------------------------------------------ |
-| フックが発火しない                                                  | `matcher` が JSON 配列ではなく文字列である                                            | 複数のツールをマッチするために `\|` を含む単一の文字列を使用します。例えば `"Edit\|Write"` です。[マッチャーパターン](/ja/hooks#matcher-patterns) を参照してください。                                          |
-| フックが発火しない                                                  | `matcher` 値が小文字です。例えば `"bash"`                                           | マッチングは大文字と小文字を区別します。ツール名は大文字です：`Bash`、`Edit`、`Write`、`Read`。                                                                                            |
-| フックが発火しない                                                  | Hooks がスタンドアロンの `.claude/hooks.json` ファイルにあります                           | スタンドアロンの hooks ファイルはありません。`settings.json` の `"hooks"` キーの下に hooks を定義します。[フック設定](/ja/hooks) を参照してください。                                                  |
-| グローバルに設定された権限、hooks、env が無視されます                            | 設定が `~/.claude.json` に追加されました                                            | `~/.claude.json` はアプリ状態と UI トグルを保持します。`permissions`、`hooks`、`env` は `~/.claude/settings.json` に属します。これらは 2 つの異なるファイルです。                                 |
-| `settings.json` 値が無視されているように見えます                           | 同じキーが `settings.local.json` で設定されています                                    | `settings.local.json` は `settings.json` をオーバーライドし、両方とも `~/.claude/settings.json` をオーバーライドします。[設定の優先順位](/ja/settings#how-scopes-interact) を参照してください。     |
-| スキルが `/skills` に表示されません                                    | スキルファイルがフォルダ内ではなく `.claude/skills/name.md` にあります                         | `SKILL.md` を含むフォルダを使用します：`.claude/skills/name/SKILL.md`。                                                                                                |
-| スキルが `/skills` に表示されますが Claude が呼び出しません                    | スキルのフロントマターに `disable-model-invocation: true` があるか、その説明がリクエストの言い方と一致しません | `/skills` のバッジを確認します：「user-only」ラベルは Claude が独自にトリガーしないことを意味します。[スキル呼び出し](/ja/skills) を参照してください。                                                        |
-| サブディレクトリの `CLAUDE.md` 指示が無視されているように見えます                    | サブディレクトリファイルはセッション開始時ではなくオンデマンドで読み込まれます                                  | Claude が Read ツールでそのディレクトリ内のファイルを読むときに読み込まれます。起動時ではなく、ファイルを書き込みまたは作成するときではありません。[CLAUDE.md ファイルの読み込み方法](/ja/memory#how-claude-md-files-load) を参照してください。 |
-| サブエージェントが `CLAUDE.md` 指示を無視します                             | サブエージェントは常にプロジェクトメモリを継承するわけではありません                                       | 重要なルールをエージェントファイル本体に入れます。これはサブエージェントのシステムプロンプトになります。[サブエージェント設定](/ja/sub-agents) を参照してください。                                                             |
-| クリーンアップロジックがセッション終了時に実行されません                               | `SessionEnd` フックが設定されていません                                               | `settings.json` に `SessionEnd` フックを追加します。[フックイベントリスト](/ja/hooks#hook-events) を参照してください。                                                                 |
-| `.mcp.json` の MCP サーバーが読み込まれません                            | ファイルが `.claude/` の下にあるか、Claude Desktop の設定形式を使用しています                     | プロジェクト MCP 設定はリポジトリルートの `.mcp.json` に置かれます。`.claude/` 内ではありません。[MCP 設定](/ja/mcp) を参照してください。                                                             |
-| `settings.json` の `mcpServers` の下に追加された MCP サーバーが表示されません   | `settings.json` は `mcpServers` キーを読み込みません                                | プロジェクトサーバーをリポジトリルートの `.mcp.json` で定義するか、`claude mcp add --scope user` を実行してユーザースコープサーバーを追加します。[MCP 設定](/ja/mcp) を参照してください。                              |
-| プロジェクト MCP サーバーが追加されても表示されません                              | 1 回限りの承認プロンプトが却下されました                                                    | プロジェクトスコープサーバーは承認が必要です。`/mcp` を実行してステータスを確認し、承認します。                                                                                                     |
-| MCP サーバーが一部のディレクトリから起動に失敗します                               | `command` または `args` が相対ファイルパスを使用しています                                   | ローカルスクリプトには絶対パスを使用します。`npx` または `uvx` のような `PATH` 上の実行可能ファイルはそのまま機能します。                                                                                 |
-| MCP サーバーが予期された環境変数なしで起動します                                 | 変数は `settings.json` `env` にあり、MCP 子プロセスに伝播しません                           | 代わりに `.mcp.json` 内のサーバーごとの `env` を設定します。                                                                                                                |
-| `Bash(rm *)` 拒否ルールが `/bin/rm` または `find -delete` をブロックしません | プレフィックスルールは基になる実行可能ファイルではなく、リテラルコマンド文字列をマッチします                           | 各バリアントの明示的なパターンを追加するか、[PreToolUse フック](/ja/hooks-guide) または [サンドボックス](/ja/sandboxing) を使用して、ハード保証を取得します。                                                |
+| 症状                                                         | 原因                                                                                 | 修正                                                                                                                                                                                           |
+| :--------------------------------------------------------- | :--------------------------------------------------------------------------------- | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
+| フックが発火しない                                                  | `matcher` が JSON 配列ではなく文字列である                                                      | 複数のツールをマッチするために `\|` を含む単一の文字列を使用します。例えば `"Edit\|Write"` です。[マッチャーパターン](/ja/hooks#matcher-patterns) を参照してください。                                                                               |
+| フックが発火しない                                                  | `matcher` 値が小文字です。例えば `"bash"`                                                     | マッチングは大文字と小文字を区別します。ツール名は大文字です：`Bash`、`Edit`、`Write`、`Read`。                                                                                                                                 |
+| フックが発火しない                                                  | Hooks がスタンドアロンファイルではなく `settings.json` に定義されていません                                  | プロジェクトまたはユーザー設定用のスタンドアロン hooks ファイルはありません。`settings.json` の `"hooks"` キーの下に hooks を定義します。[プラグイン](/ja/plugins-reference#hooks) のみが別の `hooks/hooks.json` を読み込みます。[フック設定](/ja/hooks) を参照してください。 |
```

</details>

<details>
<summary>desktop-ja.md</summary>

```diff
diff --git a/docs-ja/pages/desktop-ja.md b/docs-ja/pages/desktop-ja.md
index 1a01545..be82d69 100644
--- a/docs-ja/pages/desktop-ja.md
+++ b/docs-ja/pages/desktop-ja.md
@@ -3,5 +3,5 @@
 > Use this file to discover all available pages before exploring further.
 
-# Claude Code Desktop を使用する
+# Desktop application
 
 > Claude Code Desktop をさらに活用する：Git 分離による並列セッション、ドラッグアンドドロップペインレイアウト、統合ターミナルとファイルエディタ、サイドチャット、コンピュータ使用、電話から Dispatch セッションを送信、ビジュアル diff レビュー、アプリプレビュー、PR 監視、コネクタ、エンタープライズ設定。
@@ -708,4 +708,5 @@ Desktop と CLI は同じ設定ファイルを読み取るため、セットア
 * **インラインコード提案**：Desktop はオートコンプリートスタイルの提案を提供しません。会話型プロンプトと明示的なコード変更を通じて機能します。
 * **エージェントチーム**：マルチエージェントオーケストレーションは [CLI](/ja/agent-teams) および [Agent SDK](/ja/headless) を通じて利用可能であり、Desktop では利用できません。
+* **ターミナルダイアログコマンド**：`/permissions`、`/config`、`/agents`、`/doctor` などのターミナルで対話型パネルを開く組み込みコマンドは、Code タブでは利用できず、`isn't available in this environment` で応答します。[設定ファイル](/ja/settings)を直接編集して権限ルールと設定を管理するか、スタンドアロン CLI からコマンドを実行します。
 
 ## トラブルシューティング
```

</details>

<details>
<summary>discover-plugins-ja.md</summary>

```diff
diff --git a/docs-ja/pages/discover-plugins-ja.md b/docs-ja/pages/discover-plugins-ja.md
index 5116c21..4e24038 100644
--- a/docs-ja/pages/discover-plugins-ja.md
+++ b/docs-ja/pages/discover-plugins-ja.md
@@ -139,5 +139,7 @@ Anthropic は、プラグインシステムで何が可能かを示す例プラ
 
   <Step title="プラグインをインストールする">
-    プラグインを選択してその詳細を表示し、インストール スコープを選択します：
+    プラグインを選択してその詳細を表示します。{/* min-version: 2.1.143 */}Claude Code v2.1.143 以降では、詳細ペインに **Context cost** の推定値が含まれており、インストール前に、プラグインが毎ターン [コンテキストウィンドウ](/ja/features-overview#understand-context-costs) に追加するトークン数を確認できます。
+
+    インストール スコープを選択します：
 
     * **User scope**: すべてのプロジェクト全体で自分用にインストール
```

</details>

*...以降省略*

</details>


<details>
<summary>2026-05-17</summary>

**変更ファイル:**

```
 docs-ja/pages/microsoft-foundry-ja.md | 10 ++++++++++
 docs-ja/pages/model-config-ja.md      |  2 +-
 docs-ja/pages/skills-ja.md            |  2 ++
 3 files changed, 13 insertions(+), 1 deletion(-)
```

<details>
<summary>microsoft-foundry-ja.md</summary>

```diff
diff --git a/docs-ja/pages/microsoft-foundry-ja.md b/docs-ja/pages/microsoft-foundry-ja.md
index 3126d0b..fb2293a 100644
--- a/docs-ja/pages/microsoft-foundry-ja.md
+++ b/docs-ja/pages/microsoft-foundry-ja.md
@@ -174,4 +174,14 @@ export ENABLE_PROMPT_CACHING_1H=1
 ```
 
+### 5. Claude Code を実行する
+
+環境変数を設定したら、プロジェクトディレクトリから Claude Code を起動します：
+
+```bash theme={null}
+claude
+```
+
+Claude Code は環境から `CLAUDE_CODE_USE_FOUNDRY` およびその他の Foundry 変数を読み込み、最初のプロンプトで Azure リソースに接続します。Bedrock および Vertex AI とは異なり、Foundry には対話型セットアップウィザードがないため、ステップ 3 およびステップ 4 の環境変数が唯一の構成パスです。
+
 ## Azure RBAC 構成
 
```

</details>

<details>
<summary>model-config-ja.md</summary>

```diff
diff --git a/docs-ja/pages/model-config-ja.md b/docs-ja/pages/model-config-ja.md
index 7393d92..c98dc3c 100644
--- a/docs-ja/pages/model-config-ja.md
+++ b/docs-ja/pages/model-config-ja.md
@@ -201,5 +201,5 @@ Opus 4.7 を初めて実行する場合、Claude Code は、以前に Opus 4.6 
 * **`--effort` フラグ**：Claude Code を起動する際にレベル名を渡して、単一セッションのレベルを設定
 * **環境変数**：`CLAUDE_CODE_EFFORT_LEVEL` をレベル名または `auto` に設定
-* **設定**：設定ファイルで `effortLevel` を設定
+* **設定**：設定ファイルで `effortLevel` を `low`、`medium`、`high`、`xhigh` に設定します。`max` は [セッションのみ](#adjust-effort-level) であり、ここでは受け入れられません
 * **Skill と subagent frontmatter**：[skill](/ja/skills#frontmatter-reference) または [subagent](/ja/sub-agents#supported-frontmatter-fields) markdown ファイルで `effort` を設定して、その skill または subagent が実行される際の努力レベルをオーバーライド
 
```

</details>

<details>
<summary>skills-ja.md</summary>

```diff
diff --git a/docs-ja/pages/skills-ja.md b/docs-ja/pages/skills-ja.md
index 0ea2ddb..fb7abe6 100644
--- a/docs-ja/pages/skills-ja.md
+++ b/docs-ja/pages/skills-ja.md
@@ -408,4 +408,6 @@ Summarize this pull request...
 これは前処理であり、Claude が実行するものではありません。Claude は最終結果のみを見ます。
 
+置換は元のファイルに対して 1 回実行されます。コマンド出力はプレーンテキストとして挿入され、さらに `` !`<command>` `` プレースホルダーについて再スキャンされないため、コマンドは後のパスで展開するプレースホルダーを発行することはできません。
+
 複数行のコマンドの場合、インラインフォーム `` !`<command>` `` の代わりに、` ```! ` で開かれたフェンスコードブロックを使用します：
 
```

</details>

</details>


<details>
<summary>2026-05-16</summary>

**変更ファイル:**

```
 docs-ja/pages/agent-view-ja.md        |  6 ++++++
 docs-ja/pages/amazon-bedrock-ja.md    |  9 ++++++---
 docs-ja/pages/changelog.md            | 36 +++++++++++++++++++++++++++++++++++
 docs-ja/pages/claude-directory-ja.md  |  1 +
 docs-ja/pages/data-usage-ja.md        |  4 +++-
 docs-ja/pages/env-vars-ja.md          |  5 +++--
 docs-ja/pages/errors-ja.md            | 20 +++++++++----------
 docs-ja/pages/goal-ja.md              |  4 ++++
 docs-ja/pages/google-vertex-ai-ja.md  |  6 ++++--
 docs-ja/pages/hooks-ja.md             | 16 +++++++++++++++-
 docs-ja/pages/mcp-ja.md               | 20 ++++++++++---------
 docs-ja/pages/microsoft-foundry-ja.md |  2 ++
 12 files changed, 101 insertions(+), 28 deletions(-)
```

<details>
<summary>agent-view-ja.md</summary>

```diff
diff --git a/docs-ja/pages/agent-view-ja.md b/docs-ja/pages/agent-view-ja.md
index 4c98b5e..bbb89ed 100644
--- a/docs-ja/pages/agent-view-ja.md
+++ b/docs-ja/pages/agent-view-ja.md
@@ -266,4 +266,10 @@ claude --agent code-reviewer --bg "address review comments on PR 1234"
 ```
 
+`--name` を渡して、自動生成されたセッションの代わりにエージェントビューでセッションの表示名を設定します。
+
+```bash theme={null}
+claude --bg --name "flaky-test-fix" "investigate the flaky SettingsChangeDetector test"
+```
+
 バックグラウンド化の後、Claude はセッションの短い ID とセッションを管理するためのコマンドを出力します。
 
```

</details>

<details>
<summary>amazon-bedrock-ja.md</summary>

```diff
diff --git a/docs-ja/pages/amazon-bedrock-ja.md b/docs-ja/pages/amazon-bedrock-ja.md
index 53f2bea..2665a7e 100644
--- a/docs-ja/pages/amazon-bedrock-ja.md
+++ b/docs-ja/pages/amazon-bedrock-ja.md
@@ -212,6 +212,7 @@ export CLAUDE_CODE_USE_BEDROCK=1
 export AWS_REGION=us-east-1  # または希望するリージョン
 
-# オプション：小型/高速モデル（Haiku）のリージョンをオーバーライド
-# Bedrock Mantle にも適用されます。
+# オプション：小型/高速モデル（Bedrock および Mantle）の AWS リージョンをオーバーライド
+# Bedrock では、ANTHROPIC_DEFAULT_HAIKU_MODEL
+# または非推奨の ANTHROPIC_SMALL_FAST_MODEL が設定されていない場合、効果がありません。
 export ANTHROPIC_SMALL_FAST_MODEL_AWS_REGION=us-west-2
 
@@ -249,5 +250,7 @@ export ANTHROPIC_DEFAULT_HAIKU_MODEL='us.anthropic.claude-haiku-4-5-20251001-v1:
 | :------- | :--------------------------------------------- |
 | プライマリモデル | `us.anthropic.claude-sonnet-4-5-20250929-v1:0` |
-| 小型/高速モデル | `us.anthropic.claude-haiku-4-5-20251001-v1:0`  |
+| 小型/高速モデル | プライマリモデルと同じ                                    |
+
+セッションタイトル生成などのバックグラウンドタスクは、小型/高速モデル（通常は Haiku クラスモデル）を使用します。Bedrock では、すべてのアカウントまたはリージョンで Haiku が有効になっていない可能性があるため、Claude Code はこれをプライマリモデルにデフォルト設定します。バックグラウンドタスクに Haiku を使用するには、`ANTHROPIC_DEFAULT_HAIKU_MODEL` をアカウントで利用可能なモデル ID に設定してください。
 
 モデルをさらにカスタマイズするには、以下のいずれかの方法を使用します。
```

</details>

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index 3fcf5ed..8c6909b 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,40 @@
 # Changelog
 
+## 2.1.143
+
+- Added plugin dependency enforcement: `claude plugin disable` now refuses when another enabled plugin depends on the target (with a copy-pasteable disable-chain hint), and `claude plugin enable` force-enables transitive dependencies
+- Added projected context cost (per-turn and per-invocation token estimates) to the `/plugin` marketplace browse pane
+- Added `worktree.bgIsolation: "none"` setting to let background sessions edit the working copy directly without `EnterWorktree`, for repos where worktrees are impractical
+- PowerShell tool now passes `-ExecutionPolicy Bypass`. Opt out with `CLAUDE_CODE_POWERSHELL_RESPECT_EXECUTION_POLICY=1`
+- Background sessions now preserve the model and effort level you set after waking from idle
+- Shift+Tab in attached agent sessions now includes auto mode in the cycle
+- Fixed a corrupt `.credentials.json` with a non-array `scopes` value hanging the CLI on startup or silently aborting OAuth token refresh
+- Fixed right-click paste in `claude agents` on Windows Terminal and WSL
+- Fixed stop hooks that block repeatedly looping forever — the turn now ends with a warning after 8 consecutive blocks (override via `CLAUDE_CODE_STOP_HOOK_BLOCK_CAP`)
+- Fixed Esc/Ctrl+C not cancelling a pending `/loop` wakeup while Claude is idle between iterations
+- Fixed `/goal` evaluator firing while background shells or delegated subagents are still running
+- Fixed `NO_COLOR`/`FORCE_COLOR` in settings.json `env` stripping Claude Code's own UI colors — they now apply to subprocesses only
+- Fixed agent view spawning repeated PowerShell processes on Windows when listing sessions
+- Fixed `/bg` without a prompt sending "continue" to the forked session — the fork now waits for input
+- Fixed `--agent <name>` not finding plugin-contributed agents without the `plugin:` prefix
+- Fixed deleting a session from agent view not removing its transcript file
+- Fixed stale-fragment rendering when scrolling in attached background sessions on Windows Terminal
+- Fixed background agents false-positive worker-stall detection storm after host sleep or macOS App Nap
+- Fixed 5xx error messages pointing at status.claude.com instead of naming the configured gateway or cloud provider
+- The PowerShell tool is now enabled by default on Windows for Bedrock, Vertex, and Foundry users. Opt out with `CLAUDE_CODE_USE_POWERSHELL_TOOL=0`.
+- `claude agents` now accepts `--add-dir`, `--settings`, `--mcp-config`, and `--plugin-dir` and applies them to the dashboard and to background sessions dispatched from it
```

</details>

<details>
<summary>claude-directory-ja.md</summary>

```diff
diff --git a/docs-ja/pages/claude-directory-ja.md b/docs-ja/pages/claude-directory-ja.md
index 3e1b6a3..cc41673 100644
--- a/docs-ja/pages/claude-directory-ja.md
+++ b/docs-ja/pages/claude-directory-ja.md
@@ -1508,4 +1508,5 @@ Windows では、`~/.claude` は `%USERPROFILE%\.claude` に解決されます
 | `shell-snapshots/`                           | Bash ツールによって使用されるキャプチャされたシェル環境。正常な終了時に削除されます。スイープはクラッシュ後に残されたものをクリアします。              |
 | `backups/`                                   | 設定マイグレーション前に取得された `~/.claude.json` のタイムスタンプ付きコピー                                     |
+| `feedback-bundles/`                          | `/feedback` によってサードパーティプロバイダーに書き込まれた編集済みトランスクリプトアーカイブ。Anthropic アカウントチームに送信するため      |
 
 ### 削除するまで保持される
```

</details>

<details>
<summary>data-usage-ja.md</summary>

```diff
diff --git a/docs-ja/pages/data-usage-ja.md b/docs-ja/pages/data-usage-ja.md
index a165950..69741f4 100644
--- a/docs-ja/pages/data-usage-ja.md
+++ b/docs-ja/pages/data-usage-ja.md
@@ -100,5 +100,7 @@ Claude Code はユーザーのマシンから Anthropic に接続して、レイ
 Claude Code はユーザーのマシンから Sentry に接続して、運用エラーログを記録します。データは TLS を使用して転送中に暗号化され、256 ビット AES 暗号化を使用して保存時に暗号化されます。詳細については、[Sentry security documentation](https://sentry.io/security/) を参照してください。エラーログをオプトアウトするには、`DISABLE_ERROR_REPORTING` 環境変数を設定します。
 
-ユーザーが `/feedback` コマンドを実行すると、コードを含む完全な会話履歴のコピーが Anthropic に送信されます。データは転送中に TLS で暗号化されます。オプションで、公開リポジトリに GitHub イシューが作成されます。オプトアウトするには、`DISABLE_FEEDBACK_COMMAND` 環境変数を `1` に設定します。
+`/feedback` コマンドを実行すると、コードを含む会話履歴のコピーが Anthropic に送信されます。送信前に、含める履歴の量を選択できます。デフォルトは現在のセッションのみですが、同じプロジェクトの過去 24 時間または 7 日間の他のセッションも含めることができます。データは TLS 経由で転送中に暗号化されます。オプションで、公開リポジトリに GitHub イシューが作成されます。オプトアウトするには、`DISABLE_FEEDBACK_COMMAND` 環境変数を `1` に設定します。
+
+Bedrock や Vertex などのサードパーティプロバイダーを使用している場合、または Anthropic 認証情報が設定されていない場合、`/feedback` はレポートを Anthropic に送信する代わりに、`~/.claude/feedback-bundles/` の下のローカルアーカイブに書き込みます。既知の API キーおよびトークンパターンは、アーカイブが書き込まれる前に削除されます。Anthropic アカウント担当者にファイルを送信するか、サポートリクエストに添付するまで、何もマシンから出ません。
 
 ## API プロバイダーのデフォルト動作
```

</details>

<details>
<summary>env-vars-ja.md</summary>

```diff
diff --git a/docs-ja/pages/env-vars-ja.md b/docs-ja/pages/env-vars-ja.md
index 2b295c5..331370d 100644
--- a/docs-ja/pages/env-vars-ja.md
+++ b/docs-ja/pages/env-vars-ja.md
@@ -43,5 +43,5 @@ Claude Code は、その動作を制御するために以下の環境変数を
 | `ANTHROPIC_MODEL`                                       | 使用するモデル設定の名前（[モデル設定](/ja/model-config#environment-variables) を参照してください）                                                                                                                                                                                                                                                                                                                                                        |
 | `ANTHROPIC_SMALL_FAST_MODEL`                            | \[非推奨] バックグラウンドタスク用の [Haiku クラスモデルの名前](/ja/costs)                                                                                                                                                                                                                                                                                                                                                                              |
-| `ANTHROPIC_SMALL_FAST_MODEL_AWS_REGION`                 | Bedrock または Bedrock Mantle を使用する場合、Haiku クラスモデルの AWS リージョンをオーバーライドします                                                                                                                                                                                                                                                                                                                                                          |
+| `ANTHROPIC_SMALL_FAST_MODEL_AWS_REGION`                 | Bedrock または Bedrock Mantle を使用する場合、Haiku クラスモデルの AWS リージョンをオーバーライドします。Bedrock では、`ANTHROPIC_DEFAULT_HAIKU_MODEL` または非推奨の `ANTHROPIC_SMALL_FAST_MODEL` も設定されている場合にのみ有効になります。Bedrock はそれ以外の場合、バックグラウンドタスク用にプライマリモデルを使用するためです                                                                                                                                                                                                     |
 | `ANTHROPIC_VERTEX_BASE_URL`                             | Vertex AI エンドポイント URL をオーバーライドします。カスタム Vertex エンドポイントを使用する場合、または [LLM ゲートウェイ](/ja/llm-gateway) を通じてルーティングする場合に使用します。[Google Vertex AI](/ja/google-vertex-ai) を参照してください                                                                                                                                                                                                                                                         |
 | `ANTHROPIC_VERTEX_PROJECT_ID`                           | Vertex AI リクエスト用の GCP プロジェクト ID。`GCLOUD_PROJECT`、`GOOGLE_CLOUD_PROJECT`、または `GOOGLE_APPLICATION_CREDENTIALS` 認証情報ファイル内のプロジェクトでオーバーライドされます。[Google Vertex AI](/ja/google-vertex-ai) を参照してください                                                                                                                                                                                                                                   |
@@ -70,5 +70,5 @@ Claude Code は、その動作を制御するために以下の環境変数を
 | `CLAUDE_CODE_CLIENT_KEY`                                | mTLS 認証用のクライアント秘密鍵ファイルへのパス                                                                                                                                                                                                                                                                                                                                                                                                     |
 | `CLAUDE_CODE_CLIENT_KEY_PASSPHRASE`                     | 暗号化された CLAUDE\_CODE\_CLIENT\_KEY のパスフレーズ（オプション）                                                                                                                                                                                                                                                                                                                                                                                |
-| `CLAUDE_CODE_DEBUG_LOGS_DIR`                            | デバッグログファイルパスをオーバーライドします。名前に反して、これはディレクトリではなくファイルパスです。デバッグモードを `--debug` または `/debug` で別途有効にする必要があります。この変数を設定するだけではログが有効になりません。[`--debug-file`](/ja/cli-reference#cli-flags) フラグは両方を一度に行います。デフォルトは `~/.claude/debug/<session-id>.txt` です                                                                                                                                                                                        |
+| `CLAUDE_CODE_DEBUG_LOGS_DIR`                            | デバッグログファイルパスをオーバーライドします。名前に反して、これはディレクトリではなくファイルパスです。デバッグモードを `--debug`、`/debug`、または `DEBUG` 環境変数で別途有効にする必要があります。この変数を設定するだけではログが有効になりません。[`--debug-file`](/ja/cli-reference#cli-flags) フラグは両方を一度に行います。デフォルトは `~/.claude/debug/<session-id>.txt` です                                                                                                                                                                            |
 | `CLAUDE_CODE_DEBUG_LOG_LEVEL`                           | デバッグログファイルに書き込まれる最小ログレベル。値：`verbose`、`debug`（デフォルト）、`info`、`warn`、`error`。フルステータスラインコマンド出力などの大量の診断を含めるには `verbose` に設定するか、ノイズを減らすには `error` に上げます                                                                                                                                                                                                                                                                              |
 | `CLAUDE_CODE_DISABLE_1M_CONTEXT`                        | [1M コンテキストウィンドウ](/ja/model-config#extended-context) サポートを無効にするには `1` に設定します。設定すると、1M モデルバリアントはモデルピッカーで利用できなくなります。コンプライアンス要件のあるエンタープライズ環境に役立ちます                                                                                                                                                                                                                                                                                 |
@@ -185,4 +185,5 @@ Claude Code は、その動作を制御するために以下の環境変数を
 | `CLAUDE_REMOTE_CONTROL_SESSION_NAME_PREFIX`             | 明示的な名前が指定されていない場合、自動生成される [Remote Control](/ja/remote-control) セッション名のプレフィックス。デフォルトはマシンのホスト名で、`myhost-graceful-unicorn` のような名前を生成します。`--remote-control-session-name-prefix` CLI フラグは単一の呼び出しに対して同じ値を設定します                                                                                                                                                                                                                       |
 | `CLAUDE_STREAM_IDLE_TIMEOUT_MS`                         | ストリーミングアイドルウォッチドッグが停止した接続を閉じるまでのタイムアウト（ミリ秒）。デフォルトと最小 `300000`（5 分）の両方のバイトレベルとイベントレベルウォッチドッグの場合。低い値は拡張思考の一時停止とプロキシバッファリングを吸収するために自動的にクランプされます。サードパーティプロバイダーの場合、`CLAUDE_ENABLE_STREAM_WATCHDOG=1` が必須です                                                                                                                                                                                                                          |
+| `DEBUG`                                                 | デバッグモードを有効にするには `1` に設定します。[`--debug`](/ja/cli-reference#cli-flags) で起動するのと同等です。デバッグログは `~/.claude/debug/<session-id>.txt` に書き込まれるか、`CLAUDE_CODE_DEBUG_LOGS_DIR` で設定されたパスに書き込まれます。`1`、`true`、`yes`、`on` の真の値のみがデバッグモードを有効にするため、他のツール用に設定された `DEBUG=express:*` などの名前空間パターンはトリガーしません                                                                                                                                             |
 | `DISABLE_AUTOUPDATER`                                   | 自動更新を無効にするには `1` に設定します。手動の `claude update` は引き続き機能します。`DISABLE_UPDATES` を使用して両方をブロックします                                                                                                                                                                                                                                                                                                                                       |
 | `DISABLE_AUTO_COMPACT`                                  | コンテキスト制限に近づいたときの自動コンパクションを無効にするには `1` に設定します。手動の `/compact` コマンドは引き続き利用可能です。コンパクションが発生するタイミングを明示的に制御したい場合に使用します                                                                                                                                                                                                                                                                                                                |
```

</details>

<details>
<summary>errors-ja.md</summary>

```diff
diff --git a/docs-ja/pages/errors-ja.md b/docs-ja/pages/errors-ja.md
index 414f4be..4f2d5d3 100644
--- a/docs-ja/pages/errors-ja.md
+++ b/docs-ja/pages/errors-ja.md
@@ -80,7 +80,7 @@ API Error: 500 {"type":"error","error":{"type":"api_error","message":"Internal s
 **対応方法：**
 
-* [status.claude.com](https://status.claude.com)でアクティブなインシデントを確認してください
+* [status.claude.com](https://status.claude.com) でアクティブなインシデントを確認してください
 * 1 分待ってからメッセージを再度送信してください。元のメッセージはまだ会話に残っているため、長いプロンプトの場合は全体を貼り付ける代わりに `try again` と入力できます。
-* エラーが投稿されたインシデントなしで続く場合は、`/feedback` を実行して、Anthropic がリクエスト詳細で調査できるようにしてください。プロバイダーで `/feedback` が利用できない場合は、[エラーを報告する](#report-an-error)を参照してください。
+* エラーが投稿されたインシデントなしで続く場合は、`/feedback` を実行して、Anthropic がリクエスト詳細で調査できるようにしてください。環境で `/feedback` が利用できない場合は、[エラーを報告する](#report-an-error) を参照してください。
 
 ### API Error: Repeated 529 Overloaded errors
@@ -96,5 +96,5 @@ API Error: Repeated 529 Overloaded errors · check status.claude.com
 **対応方法：**
 
-* [status.claude.com](https://status.claude.com)で容量に関する通知を確認してください
+* [status.claude.com](https://status.claude.com) で容量に関する通知を確認してください
 * 数分後に再度試してください
 * `/model` を実行して別のモデルに切り替えて、容量がモデルごとに追跡されるため、作業を続けてください。Claude Code は、1 つのモデルが特に高い負荷を受けている場合、たとえば `Opus is experiencing high load, please use /model to switch to Sonnet` のようにこれを行うようにプロンプトを表示します。
@@ -114,10 +114,10 @@ Request timed out
 * リクエストを再試行してください
 * 長時間実行されるタスクの場合は、作業をより小さいプロンプトに分割してください
-* 遅いネットワークまたはプロキシが原因の場合は、[自動リトライ](#automatic-retries)で説明されているように `API_TIMEOUT_MS` を上げてください
-* タイムアウトが頻繁で、ネットワークが正常な場合は、以下の[ネットワークと接続エラー](#network-and-connection-errors)を参照してください
+* 遅いネットワークまたはプロキシが原因の場合は、[自動リトライ](#automatic-retries) で説明されているように `API_TIMEOUT_MS` を上げてください
+* タイムアウトが頻繁で、ネットワークが正常な場合は、以下の[ネットワークと接続エラー](#network-and-connection-errors) を参照してください
 
 ### Auto mode cannot determine the safety of an action
```

</details>

<details>
<summary>goal-ja.md</summary>

```diff
diff --git a/docs-ja/pages/goal-ja.md b/docs-ja/pages/goal-ja.md
index 16469b3..08f2780 100644
--- a/docs-ja/pages/goal-ja.md
+++ b/docs-ja/pages/goal-ja.md
@@ -7,4 +7,8 @@
 > /goal でコンプリーション条件を設定すると、Claude はターン間でプロンプトなしに条件が満たされるまで動作し続けます。
 
+<Note>
+  `/goal` には Claude Code v2.1.139 以降が必要です。
+</Note>
+
 `/goal` コマンドはコンプリーション条件を設定し、Claude はあなたが各ステップをプロンプトすることなく、その条件に向かって動作し続けます。各ターンの後、小さく高速なモデルが条件が成立しているかどうかをチェックします。成立していない場合、Claude はあなたに制御を返す代わりに別のターンを開始します。条件が満たされると、ゴールは自動的にクリアされます。
 
```

</details>

*...以降省略*

</details>


<details>
<summary>2026-05-15</summary>

**変更ファイル:**

```
 docs-ja/pages/agent-view-ja.md              |  68 ++++++++++++++----
 docs-ja/pages/amazon-bedrock-ja.md          |  13 ++--
 docs-ja/pages/best-practices-ja.md          |  48 ++++++-------
 docs-ja/pages/changelog.md                  |  27 ++++++++
 docs-ja/pages/checkpointing-ja.md           |  19 ++---
 docs-ja/pages/claude-code-on-the-web-ja.md  |   2 +-
 docs-ja/pages/cli-reference-ja.md           |   2 +-
 docs-ja/pages/commands-ja.md                |   2 +-
 docs-ja/pages/desktop-ja.md                 |  19 ++---
 docs-ja/pages/desktop-scheduled-tasks-en.md | 104 ----------------------------
 docs-ja/pages/env-vars-ja.md                |   4 +-
 docs-ja/pages/github-actions-ja.md          |  32 ++++++---
 docs-ja/pages/glossary-ja.md                |   2 +-
 docs-ja/pages/goal-ja.md                    |   2 +-
 docs-ja/pages/hooks-guide-ja.md             |   5 +-
 docs-ja/pages/hooks-ja.md                   |  68 ++++++++++++++----
 docs-ja/pages/mcp-ja.md                     |   2 +-
 docs-ja/pages/remote-control-ja.md          |  37 +++++-----
 docs-ja/pages/sub-agents-ja.md              |  10 +--
 docs-ja/pages/voice-dictation-ja.md         |  32 +++++----
 20 files changed, 260 insertions(+), 238 deletions(-)
```

**新規追加:**


**削除:**


<details>
<summary>agent-view-ja.md</summary>

```diff
diff --git a/docs-ja/pages/agent-view-ja.md b/docs-ja/pages/agent-view-ja.md
index 9f045f3..4c98b5e 100644
--- a/docs-ja/pages/agent-view-ja.md
+++ b/docs-ja/pages/agent-view-ja.md
@@ -47,5 +47,5 @@ Claude が複数の独立したタスクに対して、あなたが毎ステッ
 
   <Step title="セッションをディスパッチする">
-    タスクを説明するプロンプトを入力して `Enter` を押します。新しいバックグラウンドセッションがそのタスクで開始され、作業中か、入力を待機中か、完了しているかを示す行として表示されます。新しいセッションはエージェントビューヘッダーに表示されているモデルと、そのディレクトリで `claude` を実行する場合と同じ[パーミッションモード](#permission-mode-and-settings)を使用します。
+    タスクを説明するプロンプトを入力して `Enter` を押します。新しいバックグラウンドセッションがそのタスクで開始され、作業中か、入力を待機中か、完了しているかを示す行として表示されます。新しいセッションはエージェントビューヘッダーに表示されているモデルと、そのディレクトリで `claude` を実行する場合と同じ[パーミッションモード](#permission-mode-model-and-effort)を使用します。
 
     ここで入力するすべてのプロンプトは独自の新しいセッションを開始します。別のプロンプトを入力して `Enter` を押すと、最初のセッションへのフォローアップを送信するのではなく、最初のセッションと並行して 2 番目のセッションが起動します。この方法で複数を並行して実行できます。
@@ -55,5 +55,5 @@ Claude が複数の独立したタスクに対して、あなたが毎ステッ
 
   <Step title="ピーク表示と返信">
-    矢印キーで行を選択し、`Space` を押してピークパネルを開きます。フル トランスクリプトではなく、セッションの最新の出力、または待機中の質問が表示されます。返信を入力して `Enter` を押すと、エージェントビューを離れずに送信できます。
+    矢印キーで行を選択し、`Space` を押してピークパネルを開きます。フルトランスクリプトではなく、セッションの最新の出力、または待機中の質問が表示されます。返信を入力して `Enter` を押すと、エージェントビューを離れずに送信できます。
   </Step>
 
@@ -75,4 +75,6 @@ Claude が複数の独立したタスクに対して、あなたが毎ステッ
 リストはすべてのプロジェクト全体で開始したすべてのバックグラウンドセッションを表示します。1 つのリポジトリで作業しているセッションと別のワークツリーで作業している別のセッションの両方がここに表示されます。エージェントビューを開いたディレクトリに関係なく表示されます。他のターミナルで開いているインタラクティブセッションは、[バックグラウンドにする](#from-inside-a-session)までは表示されません。[Subagents](/ja/sub-agents) と [teammates](/ja/agent-teams) はセッションが生成しても個別の行としてリストされません。
 
+ビューを 1 つのプロジェクトにスコープするには、`claude agents --cwd <path>` で起動します。そのディレクトリの下で開始されたセッションのみが表示されます。これには、そこからディスパッチされた [ワークツリー](/ja/worktrees) で実行されているセッションも含まれます。
+
 ```text theme={null}
 Pinned
@@ -286,5 +288,5 @@ subagent が開始方法に関係なく常に独自のワークツリーで実
 ### モデルを設定する
 
-エージェントビューヘッダーに表示されるモデル名はディスパッチのデフォルトです。入力から開始する新しいセッションはこのモデルを使用します。これは任意のセッションで [`/model`](/ja/model-config) が制御するのと同じ設定です。
+エージェントビューヘッダーに表示されるモデル名はディスパッチのデフォルトです。入力から開始する新しいセッションはこのモデルを使用します。これは任意のセッションで [`/model`](/ja/model-config) が制御するのと同じ設定です。エージェントビューセッション全体でオーバーライドするには、エージェントビューを開く際に `--model` を渡します。[パーミッションモード、モデル、および努力](#permission-mode-model-and-effort) を参照してください。
```

</details>

<details>
<summary>amazon-bedrock-ja.md</summary>

```diff
diff --git a/docs-ja/pages/amazon-bedrock-ja.md b/docs-ja/pages/amazon-bedrock-ja.md
index e27a827..53f2bea 100644
--- a/docs-ja/pages/amazon-bedrock-ja.md
+++ b/docs-ja/pages/amazon-bedrock-ja.md
@@ -116,5 +116,5 @@ AWS 認証情報を持っていて、Bedrock を通じて Claude Code の使用
 ### 1. ユースケースの詳細を送信
 
-Anthropic モデルの初回ユーザーは、モデルを呼び出す前にユースケースの詳細を送信する必要があります。これはアカウントごとに 1 回行われます。
+Anthropic モデルの初回ユーザーは、モデルを呼び出す前にユースケースの詳細を送信する必要があります。これは AWS アカウントごとに 1 回行われます。
 
 1. 以下で説明する適切な IAM 権限があることを確認してください
@@ -171,5 +171,8 @@ Bedrock API キーは、完全な AWS 認証情報を必要としない、より
 Claude Code は、AWS SSO および企業 ID プロバイダーの自動認証情報更新をサポートしています。これらの設定を Claude Code 設定ファイルに追加してください（ファイルの場所については [Settings](/ja/settings) を参照）。
 
-Claude Code が AWS 認証情報の有効期限が切れていることを検出した場合（ローカルのタイムスタンプに基づくか、Bedrock が認証情報エラーを返した場合）、設定された `awsAuthRefresh` および/または `awsCredentialExport` コマンドを自動的に実行して、リクエストを再試行する前に新しい認証情報を取得します。
+これら 2 つの設定には異なるトリガー条件があります。
+
+* **`awsAuthRefresh`**：Claude Code がローカルのタイムスタンプに基づくか、Bedrock が認証情報エラーを返した場合に AWS 認証情報の有効期限が切れていることを検出した場合にのみ実行され、更新された認証情報でリクエストを再試行します。
+* **`awsCredentialExport`**：セッション開始時および各認証情報リロード時に実行されます。AWS デフォルト認証情報プロバイダーチェーン内の認証情報がまだ有効な場合でも実行されます。Bedrock アカウントがデフォルトプロバイダーチェーンが解決するものと異なるクロスアカウント認証情報を必要とする場合に使用します。
 
 ##### 設定例
@@ -188,5 +191,5 @@ Claude Code が AWS 認証情報の有効期限が切れていることを検出
 **`awsAuthRefresh`**：`.aws` ディレクトリを変更するコマンド（認証情報、SSO キャッシュ、または設定ファイルの更新など）に使用します。コマンドの出力はユーザーに表示されますが、対話的な入力はサポートされていません。これは、CLI が URL またはコードを表示し、ブラウザで認証を完了するブラウザベースの SSO フローに適しています。
 
-**`awsCredentialExport`**：`.aws` を変更できず、認証情報を直接返す必要がある場合にのみ使用します。出力はサイレントにキャプチャされ、ユーザーに表示されません。コマンドは次の形式で JSON を出力する必要があります。
+**`awsCredentialExport`**：`.aws` を変更できず、認証情報を直接返す必要がある場合にのみ使用します。このコマンドは、認証情報の有効期限が切れた場合だけでなく、認証情報をリフレッシュする必要があるたびに実行されます。出力はサイレントにキャプチャされ、ユーザーに表示されません。コマンドは次の形式で JSON を出力する必要があります。
 
 ```json theme={null}
@@ -226,5 +229,5 @@ Claude Code で Bedrock を有効にする場合は、以下に注意してく
 
```

</details>

<details>
<summary>best-practices-ja.md</summary>

```diff
diff --git a/docs-ja/pages/best-practices-ja.md b/docs-ja/pages/best-practices-ja.md
index dbdc966..181f528 100644
--- a/docs-ja/pages/best-practices-ja.md
+++ b/docs-ja/pages/best-practices-ja.md
@@ -53,5 +53,5 @@ UI の変更は [Chrome 拡張機能の Claude](/ja/chrome) を使用して検
 </Tip>
 
-Claude が直接コーディングにジャンプさせると、間違った問題を解決するコードが生成される可能性があります。[Plan Mode](/ja/common-workflows#use-plan-mode-for-safe-code-analysis) を使用して、探索を実行から分離します。
+Claude が直接コーディングにジャンプさせると、間違った問題を解決するコードが生成される可能性があります。[Plan Mode](/ja/permission-modes#analyze-before-you-edit-with-plan-mode) を使用して、探索を実行から分離します。
 
 推奨されるワークフローには 4 つのフェーズがあります。
@@ -61,5 +61,5 @@ Claude が直接コーディングにジャンプさせると、間違った問
     Plan Mode に入ります。Claude はファイルを読み取り、変更を加えずに質問に答えます。
 
-    ```txt claude (Plan Mode) theme={null}
+    ```txt claude (plan mode) theme={null}
     read /src/auth and understand how we handle sessions and login.
     also look at how we manage environment variables for secrets.
@@ -70,5 +70,5 @@ Claude が直接コーディングにジャンプさせると、間違った問
     Claude に詳細な実装計画を作成するよう依頼します。
 
-    ```txt claude (Plan Mode) theme={null}
+    ```txt claude (plan mode) theme={null}
     I want to add Google OAuth. What files need to change?
     What's the session flow? Create a plan.
@@ -79,7 +79,7 @@ Claude が直接コーディングにジャンプさせると、間違った問
 
   <Step title="実装">
-    Normal Mode に戻り、Claude にコーディングさせ、計画に対して検証します。
+    Plan Mode を終了し、Claude にコーディングさせ、計画に対して検証します。
```

</details>

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index 1a635c8..3fcf5ed 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,31 @@
 # Changelog
 
+## 2.1.142
+
+- Added new `claude agents` flags: `--add-dir`, `--settings`, `--mcp-config`, `--plugin-dir`, `--permission-mode`, `--model`, `--effort`, and `--dangerously-skip-permissions` to configure dispatched background sessions
+- Fast mode now uses Opus 4.7 by default (previously Opus 4.6). Set `CLAUDE_CODE_OPUS_4_6_FAST_MODE_OVERRIDE=1` to pin fast mode to Opus 4.6
+- Plugins with a root-level `SKILL.md` and no `skills/` subdirectory are now surfaced as a skill
+- The `/plugin` details pane and `claude plugin details` now show LSP servers a plugin provides
+- `/web-setup` warns before replacing an existing GitHub App connection
+- Fixed `MCP_TOOL_TIMEOUT` not raising the per-request fetch timeout for remote HTTP and SSE MCP servers, which capped tool calls at 60 seconds regardless of the configured value
+- Fixed background sessions not recognizing pre-existing git worktrees, blocking Edit while EnterWorktree refused to create a duplicate
+- Fixed background sessions disappearing and daemon reconnect failing after macOS sleep/wake — the daemon now detects clock jumps instead of treating them as elapsed idle time
+- Fixed daemon not exiting cleanly after the binary is upgraded (e.g. `brew upgrade`), causing dispatched agents to crash-loop on the deleted path
+- Fixed background agents crash-looping when the Claude-in-Chrome extension is connected without a shared tab
+- Fixed clicking links in an attached `claude agents` session — the background worker's headless browser shim no longer applies while attached
+- Fixed `claude agents` "v to open in editor" using the daemon's default editor instead of your shell's `$EDITOR`/`$VISUAL`
+- Fixed `claude agents` deadlocking on Windows with network-drive working directories; Ctrl+C now works during startup
+- Fixed background-color bleed when attaching to a `claude agents` session from Apple Terminal or other 256-color-only terminals
+- Fixed `claude --bg --dangerously-skip-permissions` not persisting across retire/wake
+- Fixed session titles being derived from the URL when the first message is a link
+- Fixed redundant `set_model` requests from remote clients injecting duplicate `/model` breadcrumbs into the transcript
+- Fixed plugins using `skills: ["./"]` showing a false "path escapes plugin directory" error
+- Fixed plugin cache cleanup deleting the active plugin version directory when no installation metadata is present
+- Fixed `/plugin` browse pane showing "0 installs" for newly published plugins
+- Fixed plugin advisories not naming every `plugin.json` key that shadows a default folder
```

</details>

<details>
<summary>checkpointing-ja.md</summary>

```diff
diff --git a/docs-ja/pages/checkpointing-ja.md b/docs-ja/pages/checkpointing-ja.md
index e30c21b..5fca0e3 100644
--- a/docs-ja/pages/checkpointing-ja.md
+++ b/docs-ja/pages/checkpointing-ja.md
@@ -29,21 +29,22 @@ Claude Code は、ファイル編集ツールで行われたすべての変更
 * **コードを復元**: 会話を保持しながら、ファイルの変更を戻します
 * **ここから要約**: このポイント以降の会話を圧縮して要約し、コンテキストウィンドウスペースを解放します
+* **ここまで要約**: このポイント前の会話を要約に圧縮し、後のメッセージはそのまま保持します
 * **キャンセル**: 変更を加えずにメッセージリストに戻ります
 
-会話を復元または要約した後、選択したメッセージからの元のプロンプトが入力フィールドに復元されるため、再送信または編集できます。
+会話を復元または「ここから要約」を選択した後、選択したメッセージからの元のプロンプトが入力フィールドに復元されるため、再送信または編集できます。
+
+「ここまで要約」を選択すると、会話の最後に留まり、入力フィールドは空になります。
 
 #### 復元と要約の違い
 
-3 つの復元オプションは状態を戻します。コード変更、会話履歴、またはその両方を取り消します。「ここから要約」は異なる動作をします。
+復元オプションは状態を戻します。コード変更、会話履歴、またはその両方を取り消します。要約オプションは、ディスク上のファイルを変更せずに、会話の一部を AI 生成の要約に圧縮します。
 
-* 選択したメッセージより前のメッセージはそのまま保持されます
-* 選択したメッセージとそれ以降のすべてのメッセージは、コンパクトな AI 生成の要約に置き換えられます
-* ディスク上のファイルは変更されません
-* 元のメッセージはセッショントランスクリプトに保持されるため、Claude は必要に応じて詳細を参照できます
+* **ここから要約**: 選択したメッセージより前のメッセージはそのまま保持されます。選択したメッセージとそれ以降のすべてのメッセージは、要約に置き換えられます。サイドディスカッションを破棄しながら、初期コンテキストを完全な詳細で保持する場合に使用します。
+* **ここまで要約**: 選択したメッセージより前のメッセージは、要約に置き換えられます。選択したメッセージとそれ以降のすべてのメッセージはそのまま保持され、会話の最後に留まります。初期セットアップディスカッションを圧縮しながら、最近の作業を完全な詳細で保持する場合に使用します。
 
-これは `/compact` に似ていますが、対象を絞ったものです。会話全体を要約する代わりに、初期コンテキストを完全な詳細で保持し、スペースを使用している部分のみを圧縮します。要約が焦点を当てるべき内容をガイドするためのオプション指示を入力できます。
+どちらの場合も、元のメッセージはセッショントランスクリプトに保持されるため、Claude は必要に応じて詳細を参照できます。要約が焦点を当てるべき内容をガイドするためのオプション指示を入力できます。これは `/compact` に似ていますが、対象を絞ったものです。会話全体を要約する代わりに、選択したメッセージのどちらの側を圧縮するかを選択します。
 
```

</details>

<details>
<summary>claude-code-on-the-web-ja.md</summary>

```diff
diff --git a/docs-ja/pages/claude-code-on-the-web-ja.md b/docs-ja/pages/claude-code-on-the-web-ja.md
index 975ec6e..5dd700b 100644
--- a/docs-ja/pages/claude-code-on-the-web-ja.md
+++ b/docs-ja/pages/claude-code-on-the-web-ja.md
@@ -783,5 +783,5 @@ Claude は PR を解決する際に GitHub のレビューコメントスレッ
 ### Remote Control セッションの有効期限切れまたはアクセス拒否
 
-`--teleport` はクラウドセッションが使用する同じ Remote Control セッションインフラストラクチャを通じて接続するため、認証およびセッション有効期限エラーは Remote Control の表現で表示されます。`Remote Control session has expired` または `Access denied` が表示される場合があります。接続トークンは短命で、アカウントにスコープされています。
+`--teleport` はクラウドセッションが使用する同じ Remote Control セッションインフラストラクチャを通じて接続するため、認証およびセッション有効期限エラーは Remote Control の表現で表示されます。`Remote Control session expired` または `Access denied` が表示される場合があります。接続トークンは短命で、アカウントにスコープされています。
 
 * ローカルで `/login` を実行して認証情報をリフレッシュし、再接続してください
```

</details>

*...以降省略*

</details>


<details>
<summary>2026-05-14</summary>

**変更ファイル:**

```
 docs-ja/pages/admin-setup-ja.md             |   4 +-
 docs-ja/pages/agent-view-ja.md              | 246 ++++++++++++++++++----------
 docs-ja/pages/authentication-ja.md          |   4 +
 docs-ja/pages/changelog.md                  |  64 ++++++++
 docs-ja/pages/claude-code-on-the-web-ja.md  |  28 ++--
 docs-ja/pages/commands-ja.md                |   2 +-
 docs-ja/pages/headless-ja.md                |   8 +-
 docs-ja/pages/hooks-guide-ja.md             |   2 +-
 docs-ja/pages/legal-and-compliance-ja.md    |   4 +
 docs-ja/pages/memory-ja.md                  |   8 +-
 docs-ja/pages/model-config-ja.md            |   2 +-
 docs-ja/pages/output-styles-ja.md           | 102 +++++++-----
 docs-ja/pages/permissions-ja.md             |   2 +-
 docs-ja/pages/server-managed-settings-ja.md |  16 +-
 docs-ja/pages/settings-ja.md                |   6 +-
 docs-ja/pages/ultrareview-ja.md             |  12 +-
 16 files changed, 344 insertions(+), 166 deletions(-)
```

<details>
<summary>admin-setup-ja.md</summary>

```diff
diff --git a/docs-ja/pages/admin-setup-ja.md b/docs-ja/pages/admin-setup-ja.md
index 118bc30..463883e 100644
--- a/docs-ja/pages/admin-setup-ja.md
+++ b/docs-ja/pages/admin-setup-ja.md
@@ -25,5 +25,5 @@ Claude Code は、ローカル開発者設定よりも優先されるマネー
 ## API プロバイダーを選択する
 
-Claude Code は複数の API プロバイダーのいずれかを通じて Claude に接続します。選択は課金、認証、継承するコンプライアンス体制に影響します。
+Claude Code は複数の API プロバイダーのいずれかを通じて Claude に接続します。選択は課金、認証、継承するコンプライアンス体制、および開発者が使用できる Claude Code 機能に影響します。
 
 | プロバイダー                        | 選択する場合                                                                                     |
@@ -35,4 +35,6 @@ Claude Code は複数の API プロバイダーのいずれかを通じて Claud
 | Microsoft Foundry             | 既存の Azure コンプライアンス制御と課金を継承したい場合                                                            |
 
+一部の Claude Code 機能には Claude.ai アカウントが必要です。[web 上の Claude Code](/ja/claude-code-on-the-web)、[Routines](/ja/routines)、[Code Review](/ja/code-review)、[Remote Control](/ja/remote-control)、および [Chrome 拡張機能](/ja/chrome) は、Console API キーまたはクラウドプロバイダーの認証情報だけでは利用できません。Bedrock、Vertex、または Foundry を通じてデプロイする場合は、開発者が Claude for Teams または Enterprise シートも必要かどうかを検討してください。各機能ページにはプラン要件が記載されています。
+
 認証、リージョン、機能パリティをカバーする完全なプロバイダー比較については、[エンタープライズ展開概要](/ja/third-party-integrations) を参照してください。各プロバイダーの認証セットアップは [Authentication](/ja/authentication) にあります。
 
```

</details>

<details>
<summary>agent-view-ja.md</summary>

```diff
diff --git a/docs-ja/pages/agent-view-ja.md b/docs-ja/pages/agent-view-ja.md
index e888f27..9f045f3 100644
--- a/docs-ja/pages/agent-view-ja.md
+++ b/docs-ja/pages/agent-view-ja.md
@@ -7,15 +7,23 @@
 > 1 つの画面から多くの Claude Code セッションをディスパッチして管理します。エージェントビューは、すべてのセッションが何をしているか、どのセッションが入力を必要としているかを表示します。
 
-`claude agents` で開くエージェントビューは、すべてのバックグラウンドセッションの 1 つの画面です。実行中のもの、入力が必要なもの、完了したものが表示されます。新しいセッションをディスパッチし、トランスクリプトをスクロールする代わりに一目でセッションの状態を確認し、セッションが必要とするときだけ介入します。セッションはターミナルが接続されていなくてもバックグラウンドで実行し続けます。
+`claude agents` で開くエージェントビューは、すべてのバックグラウンドセッションの 1 つの画面です。実行中のもの、入力が必要なもの、完了したものが表示されます。新しいセッションをディスパッチし、トランスクリプトをスクロールする代わりに一目でセッションの状態を確認し、セッションが必要とするときだけ介入します。各バックグラウンドセッションは完全な Claude Code の会話であり、ターミナルが接続されていなくてもバックグラウンドで実行し続けるため、いつでも開いて、返信して、去ることができます。
 
-エージェントビューは、Claude が同時に複数の独立したタスク（バグの修正、プルリクエストのレビュー、ログの調査など）に取り組むことができる場合に使用します。問題を一緒に解決したい場合は、セッションにアタッチして、通常どおり Claude Code をインタラクティブに使用します。エージェントビューのセッションは独立して実行され、あなたにのみレポートします。subagents、agent teams、worktrees との比較については、[エージェントを並列で実行する](/ja/agents)を参照してください。
+<img src="https://mintcdn.com/claude-code/1B48Qz2Z9hac4SLG/images/agent-view-light.png?fit=max&auto=format&n=1B48Qz2Z9hac4SLG&q=85&s=7a186c96ed47d6700d084d77e786be65" className="dark:hidden" alt="ターミナルのエージェントビュー：ヘッダーは Claude Code v2.1.140、モデル、作業ディレクトリ、および概要カウントを表示します。セッションは'入力が必要'、'実行中'、'完了'の下にグループ化され、下部にディスパッチ入力とキーボードヒントのフッターがあります。" width="1772" height="780" data-path="images/agent-view-light.png" />
+
+<img src="https://mintcdn.com/claude-code/1B48Qz2Z9hac4SLG/images/agent-view-dark.png?fit=max&auto=format&n=1B48Qz2Z9hac4SLG&q=85&s=a5bed7434bae368faea3a8f023b52aa2" className="hidden dark:block" alt="ターミナルのエージェントビュー：ヘッダーは Claude Code v2.1.140、モデル、作業ディレクトリ、および概要カウントを表示します。セッションは'入力が必要'、'実行中'、'完了'の下にグループ化され、下部にディスパッチ入力とキーボードヒントのフッターがあります。" width="1772" height="780" data-path="images/agent-view-dark.png" />
+
+Claude が複数の独立したタスクに対して、あなたが毎ステップを監視することなく作業できる場合に、エージェントビューを使用します。バグ修正、プルリクエストレビュー、不安定なテストの調査を 3 つの行としてディスパッチし、別のウィンドウで作業を続け、行が入力が必要であることを示すか、結果が得られたときに確認します。
+
+任意のエージェントのセッションでより直接的に作業したい場合は、行にアタッチして完全な会話に入ります。
+
+エージェントビューを subagents、agent teams、worktrees と比較するには、[エージェントを並列で実行する](/ja/agents)を参照してください。
 
 <Note>
-  エージェントビューはリサーチプレビューであり、Claude Code v2.1.139 以降が必要です。`claude --version` でバージョンを確認してください。インターフェースとキーボードショートカットは機能の進化に伴って変更される可能性があり、管理者は [`disableAgentView`](#how-background-sessions-are-hosted) マネージド設定を使用して組織のエージェントビューを無効にできます。
+  エージェントビューはリサーチプレビューであり、Claude Code v2.1.139 以降が必要です。`claude --version` でバージョンを確認してください。インターフェースとキーボードショートカットは機能の進化に伴って変更される可能性があります。
 </Note>
 
 このページでは以下をカバーしています。
 
-* [クイックスタート](#quick-start)
+* [クイックスタート](#quick-start)：Claude にバックグラウンドで作業するタスクを与え、確認し、必要なときに介入する
```

</details>

<details>
<summary>authentication-ja.md</summary>

```diff
diff --git a/docs-ja/pages/authentication-ja.md b/docs-ja/pages/authentication-ja.md
index a34f95d..e8c9bd5 100644
--- a/docs-ja/pages/authentication-ja.md
+++ b/docs-ja/pages/authentication-ja.md
@@ -144,4 +144,8 @@ Claude Code は認証情報を安全に管理します。
 ### 長期トークンを生成する
 
+<Note>
+  Starting June 15, 2026, Agent SDK and `claude -p` usage on subscription plans will draw from a new monthly Agent SDK credit, separate from your interactive usage limits. See [Use the Claude Agent SDK with your Claude plan](https://support.claude.com/en/articles/15036540-use-the-claude-agent-sdk-with-your-claude-plan) for details.
+</Note>
+
 CI パイプライン、スクリプト、または対話的なブラウザログインが利用できない他の環境の場合、`claude setup-token` で 1 年間の OAuth トークンを生成します。
 
```

</details>

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index 8a8624e..1a635c8 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,68 @@
 # Changelog
 
+## 2.1.141
+
+- Added `terminalSequence` field to hook JSON output so hooks can emit desktop notifications, window titles, and bells without a controlling terminal
+- Added `CLAUDE_CODE_PLUGIN_PREFER_HTTPS` to clone GitHub plugin sources over HTTPS instead of SSH, for environments without a GitHub SSH key
+- Added `ANTHROPIC_WORKSPACE_ID` environment variable for workload identity federation — scopes the minted token to a specific workspace when the federation rule covers more than one
+- Added `claude agents --cwd <path>` to scope the session list to a directory
+- `/feedback` can now include recent sessions (last 24 hours or 7 days) for issues spanning more than the current session
+- Rewind menu: added "Summarize up to here" to compress earlier context while keeping recent turns intact
+- Auto mode permission dialog now explains when a `permissions.ask` rule caused the prompt
+- Restored the "view diff in your IDE" option on file-edit permission prompts when an IDE is connected
+- Background agents launched via `/bg` or `←←` now preserve the current permission mode instead of reverting to default
+- `claude agents`: agents that finish work but leave a background shell running now move to Completed instead of staying under Working
+- Improved spinner feedback during long thinking periods — the spinner now warms to amber after 10 seconds to signal Claude is still working
+- Improved plugin menu navigation: `→`/Tab switch tabs, `↑` moves to the tab strip, and tab headers and search box are clickable in fullscreen mode
+- Fixed background side-queries sending an unavailable Haiku model ID on Bedrock/Vertex/Foundry/gateway when no `ANTHROPIC_SMALL_FAST_MODEL` override is set — now falls back to the main-loop model
+- Fixed `claude daemon status` and `/doctor` on Windows throwing when the daemon pipe key file is locked or unreadable — now shows the underlying error instead of an opaque failure
+- Fixed `claude agents` showing the agent-type list instead of the dashboard when launched through a wrapper that adds flags
+- Fixed `claude agents` opening a crashed session firing redundant dispatches when the working directory was deleted
+- Fixed background jobs on a custom `ANTHROPIC_BASE_URL` gateway not getting auto-named — the namer now uses the main model when no Haiku model is configured
+- Fixed `/model` in one session silently changing the autocompact threshold in other concurrent sessions
+- Fixed switching permission mode while a tool-permission prompt is open not auto-dismissing the prompt when the new setting permits the tool
+- Fixed pressing Enter while a permission/dialog prompt is open also submitting text in the input box
+- Fixed hooks receiving a non-existent `transcript_path` after `EnterWorktree` switches the working directory
```

</details>

<details>
<summary>claude-code-on-the-web-ja.md</summary>

```diff
diff --git a/docs-ja/pages/claude-code-on-the-web-ja.md b/docs-ja/pages/claude-code-on-the-web-ja.md
index 73d3404..975ec6e 100644
--- a/docs-ja/pages/claude-code-on-the-web-ja.md
+++ b/docs-ja/pages/claude-code-on-the-web-ja.md
@@ -33,10 +33,14 @@
 クラウドセッションはコードをクローンしてブランチをプッシュするために GitHub リポジトリへのアクセスが必要です。2 つの方法でアクセスを許可できます：
 
-| 方法               | 仕組み                                                                                                | 最適な用途                 |
-| :--------------- | :------------------------------------------------------------------------------------------------- | :-------------------- |
-| **GitHub App**   | [ウェブオンボーディング](/ja/web-quickstart)中に特定のリポジトリに Claude GitHub App をインストールします。アクセスはリポジトリごとにスコープされます。   | リポジトリごとの明示的な認可を望むチーム  |
-| **`/web-setup`** | ターミナルで `/web-setup` を実行して、ローカル `gh` CLI トークンを Claude アカウントに同期します。アクセスは `gh` トークンが見ることができるものと一致します。 | すでに `gh` を使用している個別開発者 |
+| 方法               | 仕組み                                                               | 最適な用途                                                     |
+| :--------------- | :---------------------------------------------------------------- | :-------------------------------------------------------- |
+| **GitHub App**   | [ウェブオンボーディング](/ja/web-quickstart)中に Claude GitHub App を認可します。     | ブラウザオンボーディング；[Auto-fix](#auto-fix-pull-requests) を希望するチーム |
+| **`/web-setup`** | ターミナルで `/web-setup` を実行して、ローカル `gh` CLI トークンを Claude アカウントに同期します。 | すでに `gh` を使用している個別開発者                                     |
 
-どちらの方法でも機能します。[`/schedule`](/ja/routines)は両方の形式のアクセスをチェックし、どちらも設定されていない場合は `/web-setup` を実行するよう促します。[ターミナルから接続](/ja/web-quickstart#connect-from-your-terminal)で `/web-setup` のウォークスルーを参照してください。
+<Note>
+  どちらの方法でも、クラウドセッションは Claude GitHub App がインストールされているリポジトリだけでなく、接続している GitHub アカウントが見ることができるすべてのリポジトリにアクセスできます。App インストールは [Auto-fix](#auto-fix-pull-requests) の PR webhook を有効にします；これはセッションレベルのアクセス制御ではありません。クラウドセッションからチームが到達できるリポジトリを制限するには、GitHub 自体でアクセスを制限してください。たとえば、接続している GitHub アカウントのチームまたはリポジトリメンバーシップを制限することで実現できます。
+</Note>
+
+どちらの方法でも機能します。[`/schedule`](/ja/routines) は両方の形式のアクセスをチェックし、どちらも設定されていない場合は `/web-setup` を実行するよう促します。[ターミナルから接続](/ja/web-quickstart#connect-from-your-terminal)で `/web-setup` のウォークスルーを参照してください。
 
 GitHub App は [Auto-fix](#auto-fix-pull-requests) に必須です。これは App を使用して PR webhook を受け取ります。`/web-setup` で接続し、後で Auto-fix が必要な場合は、それらのリポジトリに App をインストールします。
@@ -740,4 +744,6 @@ PR がどこから来たか、どのデバイスを使用しているかに応
 * **既存の PR**：PR URL をセッションに貼り付けて、Claude に auto-fix するよう指示します
 
+Auto-fix は PR ごとのトグルです。監視を停止するには、ウェブセッションで CI ステータスバーを開き、**Auto-fix** トグルをクリアするか、Claude に PR の監視を停止するよう指示します。
+
 ### Claude が PR アクティビティにどのように応答するか
```

</details>

<details>
<summary>commands-ja.md</summary>

```diff
diff --git a/docs-ja/pages/commands-ja.md b/docs-ja/pages/commands-ja.md
index ff8b82d..a6d1b69 100644
--- a/docs-ja/pages/commands-ja.md
+++ b/docs-ja/pages/commands-ja.md
@@ -122,5 +122,5 @@
 | `/tui [default\|fullscreen]`                    | ターミナル UI レンダラーを設定し、会話を保持したまま再起動します。`fullscreen` は[ちらつきなしの alt-screen レンダラー](/ja/fullscreen)を有効にします。引数なしで、アクティブなレンダラーを出力します                                                                                                                                                                                                                                                                                                                                                                                     |
 | `/ultraplan <prompt>`                           | [ultraplan](/ja/ultraplan) セッションで計画を作成し、ブラウザでレビューし、リモートで実行するか、ターミナルに送り返します                                                                                                                                                                                                                                                                                                                                                                                                                                     |
-| `/ultrareview [PR]`                             | [ultrareview](/ja/ultrareview) を使用してクラウドサンドボックスで深い複数エージェントコードレビューを実行します。Pro と Max に 3 つの無料実行が含まれ、2026 年 5 月 5 日まで、その後は [extra usage](https://support.claude.com/en/articles/12429409-extra-usage-for-paid-claude-plans) が必要です                                                                                                                                                                                                                                                                                  |
+| `/ultrareview [PR]`                             | [ultrareview](/ja/ultrareview) を使用してクラウドサンドボックスで深い複数エージェントコードレビューを実行します。Pro と Max に 3 つの無料実行が含まれ、その後は [extra usage](https://support.claude.com/en/articles/12429409-extra-usage-for-paid-claude-plans) が必要です                                                                                                                                                                                                                                                                                                   |
 | `/upgrade`                                      | アップグレードページを開いて、より高いプランティアに切り替えます                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
 | `/usage`                                        | セッションコスト、プラン使用制限、およびアクティビティ統計を表示します。サブスクリプション固有の詳細については、[コスト追跡ガイド](/ja/costs#using-the-%2Fusage-command)を参照してください。`/cost` と `/stats` はエイリアスです                                                                                                                                                                                                                                                                                                                                                                  |
```

</details>

<details>
<summary>headless-ja.md</summary>

```diff
diff --git a/docs-ja/pages/headless-ja.md b/docs-ja/pages/headless-ja.md
index 9a5267f..24f9538 100644
--- a/docs-ja/pages/headless-ja.md
+++ b/docs-ja/pages/headless-ja.md
@@ -7,11 +7,11 @@
 > Agent SDK を使用して、CLI、Python、または TypeScript からプログラムで Claude Code を実行します。
 
-[Agent SDK](/ja/agent-sdk/overview) は、Claude Code を支える同じツール、エージェントループ、およびコンテキスト管理を提供します。スクリプトと CI/CD 用の CLI として、または完全なプログラムによる制御のための [Python](/ja/agent-sdk/python) および [TypeScript](/ja/agent-sdk/typescript) パッケージとして利用できます。
-
 <Note>
-  CLI は以前「headless mode」と呼ばれていました。`-p` フラグとすべての CLI オプションは同じように機能します。
+  Starting June 15, 2026, Agent SDK and `claude -p` usage on subscription plans will draw from a new monthly Agent SDK credit, separate from your interactive usage limits. See [Use the Claude Agent SDK with your Claude plan](https://support.claude.com/en/articles/15036540-use-the-claude-agent-sdk-with-your-claude-plan) for details.
 </Note>
 
-CLI からプログラムで Claude Code を実行するには、プロンプトと任意の [CLI オプション](/ja/cli-reference) を指定して `-p` を渡します。
+[Agent SDK](/ja/agent-sdk/overview) は、Claude Code を支える同じツール、エージェントループ、およびコンテキスト管理を提供します。スクリプトと CI/CD 用の CLI として、または完全なプログラムによる制御のための [Python](/ja/agent-sdk/python) および [TypeScript](/ja/agent-sdk/typescript) パッケージとして利用できます。
+
+Claude Code を非対話型モードで実行するには、プロンプトと任意の [CLI オプション](/ja/cli-reference) を指定して `-p` を渡します。
 
 ```bash theme={null}
```

</details>

<details>
<summary>hooks-guide-ja.md</summary>

```diff
diff --git a/docs-ja/pages/hooks-guide-ja.md b/docs-ja/pages/hooks-guide-ja.md
index 67479d4..9c17b19 100644
--- a/docs-ja/pages/hooks-guide-ja.md
+++ b/docs-ja/pages/hooks-guide-ja.md
@@ -755,5 +755,5 @@ Hook を追加する場所がそのスコープを決定します：
 | [Skill](/ja/skills) または [agent](/ja/sub-agents) frontmatter | スキルまたはエージェントがアクティブなとき | はい、コンポーネントファイルで定義 |
 
-Claude Code で [`/hooks`](/ja/hooks#the-hooks-menu) を実行して、イベント別にグループ化されたすべての設定済み hooks を参照します。すべての hooks を一度に無効にするには、設定ファイルで `"disableAllHooks": true` を設定します。
+Claude Code で [`/hooks`](/ja/hooks#the-hooks-menu) を実行して、イベント別にグループ化されたすべての設定済み hooks を参照します。すべての hooks を一度に無効にするには、設定ファイルで `"disableAllHooks": true` を設定します。管理設定で設定された Hooks は、`disableAllHooks` がそこにも設定されていない限り、実行されます。
 
 Claude Code が実行中に設定ファイルを直接編集する場合、ファイルウォッチャーは通常、hook の変更を自動的に取得します。
```

</details>

*...以降省略*

</details>


<details>
<summary>2026-05-13</summary>

**変更ファイル:**

```
 docs-ja/pages/agent-teams-ja.md       |   2 +
 docs-ja/pages/agent-view-ja.md        |  15 +-
 docs-ja/pages/changelog.md            |  16 +++
 docs-ja/pages/claude-directory-ja.md  |   3 +-
 docs-ja/pages/cli-reference-ja.md     |   6 +-
 docs-ja/pages/data-usage-ja.md        |   4 +-
 docs-ja/pages/discover-plugins-ja.md  |   2 +
 docs-ja/pages/env-vars-ja.md          |  10 +-
 docs-ja/pages/fast-mode-ja.md         |  73 +++++++---
 docs-ja/pages/goal-ja.md              |   2 +-
 docs-ja/pages/hooks-guide-ja.md       |   2 +-
 docs-ja/pages/hooks-ja.md             |  17 ++-
 docs-ja/pages/mcp-ja.md               | 256 +++++-----------------------------
 docs-ja/pages/monitoring-usage-ja.md  |  18 +++
 docs-ja/pages/output-styles-ja.md     |   8 +-
 docs-ja/pages/permission-modes-ja.md  |   8 ++
 docs-ja/pages/permissions-ja.md       |  24 ++--
 docs-ja/pages/plugins-ja.md           |   6 +
 docs-ja/pages/plugins-reference-ja.md |   4 +-
 docs-ja/pages/routines-ja.md          |   4 +-
 docs-ja/pages/security-ja.md          |   2 +-
 docs-ja/pages/settings-ja.md          |  13 +-
 docs-ja/pages/skills-ja.md            |  10 +-
 23 files changed, 214 insertions(+), 291 deletions(-)
```

<details>
<summary>agent-teams-ja.md</summary>

```diff
diff --git a/docs-ja/pages/agent-teams-ja.md b/docs-ja/pages/agent-teams-ja.md
index 691d350..9e7818b 100644
--- a/docs-ja/pages/agent-teams-ja.md
+++ b/docs-ja/pages/agent-teams-ja.md
@@ -130,4 +130,6 @@ Use Sonnet for each teammate.
 ```
 
+チームメンバーはデフォルトではリーダーの `/model` 選択を継承しません。プロンプトで指定されていない場合に使用されるモデルを変更するには、`/config` で **Default teammate model** を設定してください。チームメンバーがリーダーの現在のモデルに従うようにするには、**Default (leader's model)** を選択してください。
+
 ### チームメンバーのプラン承認を要求する
 
```

</details>

<details>
<summary>agent-view-ja.md</summary>

```diff
diff --git a/docs-ja/pages/agent-view-ja.md b/docs-ja/pages/agent-view-ja.md
index ef45b0a..e888f27 100644
--- a/docs-ja/pages/agent-view-ja.md
+++ b/docs-ja/pages/agent-view-ja.md
@@ -59,5 +59,5 @@
 `claude agents` を実行してエージェントビューを開きます。ターミナル全体を占有し、状態でグループ化されたすべてのセッションをリストします。ピン留めされたセッションと入力が必要なセッションが上部に表示されます。各行はセッションの名前、現在のアクティビティ、最後に変更されてからの経過時間を表示します。
 
-リストはマシンに対してグローバルであり、どのプロジェクトまたはワークツリーで作業しているかに関係なく、[config ディレクトリ](#how-background-sessions-are-hosted)の下にあるすべてのバックグラウンドセッションを含みます。1 つのリポジトリで開始されたセッションと別のワークツリーで開始された別のセッションの両方が一緒に表示されます。他のターミナルで開いているインタラクティブセッションは、[バックグラウンドにする](#from-inside-a-session)までは表示されず、セッション内で実行している [subagents](/ja/sub-agents) は個別の行としてリストされません。
+リストは [config ディレクトリ](#how-background-sessions-are-hosted) の下にあるすべてのバックグラウンドセッションを含み、どのプロジェクトまたはワークツリーで作業しているかに関係なく、マシン全体をカバーします。1 つのリポジトリで開始されたセッションと別のワークツリーで開始された別のセッションの両方が一緒に表示されます。他のターミナルで開いているインタラクティブセッションは、[バックグラウンドにする](#from-inside-a-session)までは表示されず、セッション内で実行している [subagents](/ja/sub-agents) は個別の行としてリストされません。
 
 ```text theme={null}
@@ -66,5 +66,5 @@ Pinned
 
 Ready for review
-  ∙ jump physics              github.com/anthropics/example/pull/2048       2h
+  ∙ jump physics              github.com/anthropics/example/pull/2048    ●  2h
 
 Needs input
@@ -100,5 +100,14 @@ Completed
 各行の 1 行の概要は、設定された [Haiku クラスモデル](/ja/model-config) によって生成されるため、行はセッションが何をしているか、何が必要か、または何を生成したかをトランスクリプトを開かずに伝えることができます。セッションがアクティブに作業している間、概要は最大 15 秒ごとに 1 回、および各ターンが終了したときに 1 回更新されます。各更新は通常のプロバイダーを通じた 1 つの短い Haiku クラスリクエストであり、セッション自体と同じ [データ使用条件](/ja/data-usage) の下で請求および処理されます。
 
-セッションがプルリクエストを開くと、行は PR リンクと CI チェックのステータスインジケーターを表示します。ほとんどのタスクでは、この行が結果を収集する方法です。チェックが成功したときにプルリクエストをレビューしてマージします。
+セッションがプルリクエストを開くと、ステータスドットが行の右端に表示され、ハイパーリンクをサポートするターミナルではプルリクエストにリンクされます。セッションが複数のプルリクエストを開いた場合、カウントはドットの前に表示され、色はどれが最も注意が必要かを反映します。
+
+| ドットの色 | プルリクエストのステータス              |
+| :---- | :------------------------- |
+| 黄色    | チェックまたはレビューを待機中、またはチェックが失敗 |
+| 緑     | チェックが成功し、レビューがブロックされていない   |
+| 紫     | マージ済み                      |
+| グレー   | ドラフトまたはクローズ                |
```

</details>

<!-- UPDATE_LOG_END -->
