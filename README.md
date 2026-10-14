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

<details>
<summary>desktop-ja.md</summary>

```diff
diff --git a/docs-ja/pages/desktop-ja.md b/docs-ja/pages/desktop-ja.md
index 79f334a..9e8e84a 100644
--- a/docs-ja/pages/desktop-ja.md
+++ b/docs-ja/pages/desktop-ja.md
@@ -47,5 +47,5 @@ Code タブでは、各会話は **セッション** です：独自のチャッ
 最初のメッセージを送信する前に、プロンプト領域で 4 つのことを設定してください：
 
-* **環境**：Claude が実行される場所を選択します。ローカルマシンの場合は**Local**、[クラウドセッション](#cloud-sessions)の場合は**Cloud**、管理するリモートマシンの場合は[**SSH 接続**](#ssh-sessions)を選択するか、Windows の場合は[**WSL ディストリビューション**](/docs/ja/desktop-wsl)を選択します。[環境設定](#environment-configuration)を参照してください。
+* **環境**：Claude が実行される場所を選択します。ローカルマシンの場合は**Local**、アプリを閉じた後も継続する[クラウドセッション](#cloud-sessions)の場合は**Cloud**、管理するリモートマシンの場合は[**SSH 接続**](#ssh-sessions)を選択するか、Windows の場合は[**WSL ディストリビューション**](/docs/ja/desktop-wsl)を選択します。SSH セッション内のタスクは [Desktop が切断されている間も継続できます](#keep-a-task-running-while-desktop-is-disconnected)が、Claude アカウントを使用している場合は、サインインの有効期限が切れると停止することがあります。[環境設定](#environment-configuration)を参照してください。
 * **プロジェクトフォルダ**：Claude が作業するフォルダまたはリポジトリを選択します。クラウドセッションの場合、[複数のリポジトリ](#run-long-running-tasks-in-the-cloud)を追加できます。
 * **モデル**：送信ボタンの横のドロップダウンから[モデル](/docs/ja/model-config#available-models)を選択します。セッション中にこれを変更できます。
@@ -237,5 +237,7 @@ Code タブはペインを任意のレイアウトで配置できるように構
 </h3>
 
-統合ターミナルを使用すると、別のアプリに切り替えることなく、セッションと並行してコマンドを実行できます。セッションのタイトルバーにある**Terminal**をクリックするか、macOS または Windows で**Ctrl+\`**を押します。ターミナルはセッションの作業ディレクトリで開き、Claude と同じ環境を共有するため、`npm test`や`git status`などのコマンドは Claude が編集しているのと同じファイルを見ます。2 番目のターミナルタブを開くには、ターミナルペインヘッダーの**+**をクリックするか、チャットのフォルダを右クリックして**Open in terminal**を選択します。ターミナルはローカルおよび [SSH](#ssh-sessions) セッションで利用可能です。
+統合ターミナルを使用すると、別のアプリに切り替えることなく、セッションと並行してコマンドを実行できます。セッションのタイトルバーにある**Terminal**をクリックするか、macOS または Windows で**Ctrl+\`**を押します。ターミナルはセッションの作業ディレクトリで開き、Claude と同じ環境を共有するため、`npm test`や`git status`などのコマンドは Claude が編集しているのと同じファイルを見ます。2 番目のターミナルタブを開くには、ターミナルペインヘッダーの**+**をクリックするか、チャットのフォルダを右クリックして**Open in terminal**を選択します。
+
+ターミナルはローカルおよび [SSH](#ssh-sessions) セッションで利用可能ですが、[Windows リモートマシン](#windows-remote-machines)では制限があります。
 
 <h3 id="open-and-edit-files">
@@ -469,4 +471,8 @@ Claude は新しいセッションを提案することもできます。現在
 クラウドセッションがどのように機能するかについての詳細については、[クラウドで Claude Code を使用する](/docs/ja/claude-code-on-the-web)を参照してください。1 つの作業本体が多くのクラウドセッションを必要とする場合、サイドバーで**Projects**を選択して[プロジェクト](/docs/ja/claude-projects)を作成します。Claude はそこから 1 つの会話でセッションを開始して追跡します。
 
+<Note>
+  [SSH セッション](#ssh-sessions)のタスクも [Desktop が切断されている間も実行を続ける](#keep-a-task-running-while-desktop-is-disconnected)ことができますが、Claude アカウントを使用している場合は、サインインの有効期限が切れると停止することがあります。
+</Note>
+
 <h3 id="continue-in-another-surface">
   別のサーフェスで続行する
@@ -773,5 +779,5 @@ Claude が別のポートを選択すると、割り当てられたポートを
```

</details>

<details>
<summary>desktop-quickstart-ja.md</summary>

```diff
diff --git a/docs-ja/pages/desktop-quickstart-ja.md b/docs-ja/pages/desktop-quickstart-ja.md
index 6d861ef..f60dec4 100644
--- a/docs-ja/pages/desktop-quickstart-ja.md
+++ b/docs-ja/pages/desktop-quickstart-ja.md
@@ -73,5 +73,5 @@ Code タブを開いた状態で、プロジェクトを選択し、Claude に
 
     * **Cloud**: アプリを閉じても続行するクラウドセッションを実行します。クラウドセッションの動作方法については [Claude Code in the cloud](/docs/ja/claude-code-on-the-web) を参照してください。
-    * **SSH**: SSH 経由でリモートマシン（独自のサーバー、クラウド VM、dev コンテナなど）に接続します。Desktop は初回接続時にリモートマシンに Claude Code を自動的にインストールします。
+    * **SSH**: SSH 経由でリモートマシン（独自のサーバー、クラウド VM、dev コンテナなど）に接続します。Desktop は初回接続時にリモートマシンに Claude Code を自動的にインストールします。実行中のタスクは [Desktop が切断されている間も続行できます](/docs/ja/desktop#keep-a-task-running-while-desktop-is-disconnected)が、Claude アカウントを使用している場合は、サインインの有効期限が切れると停止することがあります。
     * **WSL**（Windows）: [WSL 2 distribution](/docs/ja/desktop-wsl) 内でセッションを実行します。Claude Code、ツール、git は Linux 側でネイティブパスで実行されます。
   </Step>
```

</details>

<details>
<summary>env-vars-ja.md</summary>

```diff
diff --git a/docs-ja/pages/env-vars-ja.md b/docs-ja/pages/env-vars-ja.md
index 1260237..28ab4f7 100644
--- a/docs-ja/pages/env-vars-ja.md
+++ b/docs-ja/pages/env-vars-ja.md
@@ -221,5 +221,5 @@ Claude Code はスタートアップ時にシェル環境変数を読み込む
 | `CLAUDE_CODE_ADDITIONAL_DIRECTORIES_CLAUDE_MD` | `1` に設定すると、`--add-dir` で指定したディレクトリからメモリファイルを読み込みます。`CLAUDE.md`、`.claude/CLAUDE.md`、`.claude/rules/*.md`、`CLAUDE.local.md` を読み込みます。デフォルトでは、追加ディレクトリからメモリファイルは読み込まれません |
 | `CLAUDE_CODE_ALT_SCREEN_FULL_REPAINT` | `1` に設定すると、[フルスクリーンレンダリング](/docs/ja/fullscreen)で増分更新を送信する代わりに、フレームごとに画面全体を再描画します。フルスクリーンモードで古いテキストの断片や位置のずれたテキストの断片が表示される場合に使用します。Claude Code は、Windows のバックグラウンドセッションと[エージェントビュー](/docs/ja/agent-view)でこれを自動的に有効にします |
-| `CLAUDE_CODE_ALWAYS_ENABLE_EFFORT` | `1` に設定すると、Claude Code がモデル ID を effort 対応として認識しない場合でも、すべてのリクエストで [effort](/docs/ja/model-config#adjust-effort-level) パラメーターを送信します。カスタム識別子でモデルを提供する [LLM ゲートウェイ](/docs/ja/llm-gateway)やサードパーティプロバイダー経由でルーティングする場合に使用します。Claude 3 モデル、Sonnet 4.0 と 4.5、Opus 4.0 と 4.1、Haiku 4.5 など、API で effort パラメーターを拒否するモデルは引き続き除外されるため、リクエストは失敗しません |
+| `CLAUDE_CODE_ALWAYS_ENABLE_EFFORT` | `1` に設定すると、Claude Code がモデル ID を effort 対応として認識しない場合でも、すべてのリクエストで [effort](/docs/ja/model-config#adjust-effort-level) パラメータを送信します。カスタム識別子でモデルを提供する [LLM ゲートウェイ](/docs/ja/llm-gateway)やサードパーティプロバイダー経由でルーティングする場合に使用します。Claude Opus 4.1、Claude Sonnet 4.5、Claude Haiku 4.5 およびそれ以前のモデルなど、API で effort パラメータを拒否するモデルは、リクエストが失敗しないよう引き続き除外されます |
 | `CLAUDE_CODE_API_KEY_HELPER_TTL_MS` | 認証情報を更新する間隔（ミリ秒）（[`apiKeyHelper`](/docs/ja/settings-reference#apikeyhelper) を使用する場合） |
 | `CLAUDE_CODE_ARTIFACT_AUTO_OPEN` | `0` に設定すると、新しい[アーティファクト](/docs/ja/artifacts#create-an-artifact)が公開されたときに Claude Code がブラウザを自動的に開かないようにします |
@@ -271,5 +271,5 @@ Claude Code はスタートアップ時にシェル環境変数を読み込む
 | `CLAUDE_CODE_DISABLE_GIT_INSTRUCTIONS` | `1` に設定すると、組み込みのコミットおよび PR ワークフローの指示と git ステータスのスナップショットを Claude のコンテキストから削除します。独自の git ワークフロースキルを使用する場合に便利です。設定すると、[`includeGitInstructions`](/docs/ja/settings-reference#includegitinstructions) 設定より優先されます |
 | `CLAUDE_CODE_DISABLE_INLINE_SHELL_RM_PROMPT` | `1` に設定すると、`bash -c 'rm -rf ~'` のように `-c` でシェルに渡されるスクリプトを、Claude Code が[クリティカルパス](/docs/ja/permission-modes#removals-inside-nested-commands-and-inline-scripts)の削除について読み取らないようにします。Claude Code はそれらのスクリプト内のシェル変数と位置パラメーターの対象は引き続きチェックし、その他のクリティカルパスのチェックも引き続き実行されます。Claude Code は設定の `env` ブロックを通じて配信されたコピーを無視するため、Claude Code を起動する環境で設定してください。Claude Code v2.1.288 以降が必要です |
-| `CLAUDE_CODE_DISABLE_LEGACY_MODEL_REMAP` | `1` に設定すると、Anthropic API で Opus 4.0 と 4.1 が現在の Opus バージョンに自動的に再マッピングされないようにします。意図的に古いモデルに固定したい場合に使用します。再マッピングは Amazon Bedrock、Google Cloud's Agent Platform、Microsoft Foundry では実行されません |
+| `CLAUDE_CODE_DISABLE_LEGACY_MODEL_REMAP` | `1` に設定すると、Anthropic API で Opus 4 と Opus 4.1 が現在の Opus バージョンに自動的に再マッピングされるのを防ぎます。意図的に古いモデルを固定したい場合に使用します。再マッピングは Amazon Bedrock、Google Cloud's Agent Platform、Microsoft Foundry では実行されません |
 | `CLAUDE_CODE_DISABLE_MODEL_ACCESS_FALLBACK` | `1` に設定すると、[Amazon Bedrock](/docs/ja/amazon-bedrock#when-a-model-is-disabled-mid-session) および [Google Cloud's Agent Platform](/docs/ja/google-vertex-ai#when-a-model-is-disabled-mid-session) 上の Claude Code で、セッション中にアカウントがセッションのモデルへのアクセス権を失った場合に、古いモデルへ切り替えないようにします。代わりに、拒否されたリクエストは即座に失敗します。設定した[フォールバックモデルチェーン](/docs/ja/model-config#fallback-model-chains)はその拒否時にも引き続き切り替わり、[起動時のモデルチェック](/docs/ja/amazon-bedrock#startup-model-checks)も起動時に引き続きフォールバックします。Claude Code v2.1.285 以降が必要です |
 | `CLAUDE_CODE_DISABLE_MOUSE` | `1` に設定すると、[フルスクリーンレンダリング](/docs/ja/fullscreen)でマウストラッキングを無効にします。`PgUp` と `PgDn` によるキーボードスクロールは引き続き機能します。ターミナルのネイティブな選択時コピーの動作を維持するために使用します |
@@ -329,4 +329,5 @@ Claude Code はスタートアップ時にシェル環境変数を読み込む
 | `CLAUDE_CODE_IDE_SKIP_AUTO_INSTALL` | `1` に設定すると、IDE 拡張機能の自動インストールをスキップします。[`autoInstallIdeExtension`](/docs/ja/settings-reference#autoinstallideextension) を `false` に設定するのと同等です |
 | `CLAUDE_CODE_IDE_SKIP_VALID_CHECK` | `1` に設定すると、接続時の IDE ロックファイルエントリの検証をスキップします。IDE が実行中にもかかわらず、自動接続で IDE が見つからない場合に使用します |
+| `CLAUDE_CODE_IDLE_COMPACT_MIN_TOKENS` | [アイドル時のコンテキスト圧縮](/docs/ja/settings-reference#idlecompaction)が会話に適用されるコンテキストサイズ（トークン数）（デフォルト: `200000`）。正の整数を受け付け、それ以外は無視されます。`100000` 未満の値は、最小しきい値である `100000` に引き上げられます。アイドル時の圧縮は、条件を満たす会話ではデフォルトでオンです。オフにするには、`idleCompaction` を `false` に設定してください。Claude Code v2.1.290 以降が必要です |
 | `CLAUDE_CODE_MAX_CONCURRENT_SUBAGENTS` | Agent ツールが新たな生成を拒否するまでに、1 つのセッションで同時に実行できる [サブエージェント](/docs/ja/sub-agents#concurrent-subagent-limit) の数（デフォルト: 20）。正の整数を数字のみで受け付けます。それ以外の値は無視されるため、この変数で上限を調整することはできますが、無効にすることはできません。Claude Code v2.1.217 以降が必要です |
 | `CLAUDE_CODE_MAX_CONTEXT_TOKENS` | Claude Code がアクティブなモデルについて想定するコンテキストウィンドウのサイズを上書きします。v2.1.193 以降、適用方法は Claude Code がモデル ID をどのように解決するかによって異なります。[ゲートウェイまたはカスタムモデル ID のウィンドウを修正する](/docs/ja/model-config#correct-the-window-for-a-gateway-or-custom-model-id) を参照してください。`ANTHROPIC_BASE_URL` を介してルーティングするモデルのコンテキストウィンドウが、その名前に対応する組み込みのサイズと一致しない場合に使用します |
@@ -453,5 +454,5 @@ Claude Code はスタートアップ時にシェル環境変数を読み込む
 | `DEBUG` | `1` に設定するとデバッグモードを有効にします。[`--debug`](/docs/ja/cli-reference#cli-flags) で起動するのと同等です。デバッグログは `~/.claude/debug/<session-id>.txt`、または `CLAUDE_CODE_DEBUG_LOGS_DIR` で設定されたパスに書き込まれます。デバッグモードを有効にするのは真の値 `1`、`true`、`yes`、`on` のみであるため、他のツール向けに設定された `DEBUG=express:*` のような名前空間パターンではトリガーされません |
 | `DISABLE_AUTOUPDATER` | `1` に設定すると、バックグラウンドでの自動更新を無効にします。手動の `claude update` は引き続き機能します。両方をブロックするには `DISABLE_UPDATES` を使用します |
-| `DISABLE_AUTO_COMPACT` | `1` に設定すると、コンテキストの上限に近づいたときの自動圧縮を無効にします。手動の `/compact` コマンドは引き続き使用できます。コンテキスト圧縮を行うタイミングを明示的に制御したい場合に使用します。[`autoCompactEnabled`](/docs/ja/settings-reference#autocompactenabled) 設定を上書きします |
+| `DISABLE_AUTO_COMPACT` | `1` に設定すると、コンテキストの上限に近づいたときの自動的なコンテキスト圧縮を、[アイドル時の圧縮](/docs/ja/settings-reference#idlecompaction)とともに無効にします。手動の `/compact` コマンドは引き続き使用できます。圧縮が行われるタイミングを明示的に制御したい場合に使用します。[`autoCompactEnabled`](/docs/ja/settings-reference#autocompactenabled) 設定を上書きします |
 | `DISABLE_COMPACT` | `1` に設定すると、自動圧縮と手動の `/compact` コマンドの両方を含む、すべてのコンテキスト圧縮を無効にします |
```

</details>

<details>
<summary>feature-availability-ja.md</summary>

```diff
diff --git a/docs-ja/pages/feature-availability-ja.md b/docs-ja/pages/feature-availability-ja.md
index e0adcef..107088d 100644
--- a/docs-ja/pages/feature-availability-ja.md
+++ b/docs-ja/pages/feature-availability-ja.md
@@ -39,5 +39,5 @@ Claude Code CLI とローカルで実行されるすべてのものは、すべ
 これらにはプロバイダー固有の違いがあります：
 
-* **MCP サーバー**：[claude.ai からのコネクタ](/docs/ja/mcp#use-mcp-servers-from-claude-ai)は、claude.ai サブスクリプションがアクティブな認証方法である場合にのみロードされます。[ツール検索](/docs/ja/mcp#configure-tool-search)は `ANTHROPIC_BASE_URL` がファーストパーティ以外のホストを指している場合、デフォルトでオフになり、Google Cloud の Agent Platform の Claude 4.5 世代より前のモデルまたは Microsoft Foundry の [Azure でホストされているデプロイメント](https://platform.claude.com/docs/en/build-with-claude/claude-in-microsoft-foundry#hosting-options)ではサポートされていません
+* **MCP サーバー**：[claude.ai からのコネクタ](/docs/ja/mcp#use-mcp-servers-from-claude-ai)は、claude.ai サブスクリプションがアクティブな認証方法である場合にのみロードされます。[ツール検索](/docs/ja/mcp#configure-tool-search)は `ANTHROPIC_BASE_URL` がファーストパーティ以外のホストを指している場合、デフォルトでオフになります。また、Claude Opus 4.5、Claude Sonnet 4.5、Claude Haiku 4.5 より前の Google Cloud の Agent Platform のモデル、および Microsoft Foundry の [Azure でホストされているデプロイ](https://platform.claude.com/docs/en/build-with-claude/claude-in-microsoft-foundry#hosting-options)ではサポートされていません
 * **Subagents**：メイン会話で Fable を実行している場合、組み込みの [Explore subagent](/docs/ja/sub-agents#built-in-subagents) は、Claude サブスクリプション、Anthropic Console アカウント、または `ANTHROPIC_BASE_URL` 経由で接続する [LLM ゲートウェイ](/docs/ja/llm-gateway)では Opus で実行されます。Claude Platform on AWS を含む他のプロバイダーでは Fable で実行されます
 * **[Commands](/docs/ja/commands#all-commands)**：
@@ -220,5 +220,5 @@ Desktop は部分的な例外です：[ゲートウェイルーティングは
 </table>
 
-<span id="fn1" style={{display: 'block', position: 'relative', top: '-120px'}} /><sup>1</sup> Google Cloud の Agent Platform では、Claude 4 モデル以降で Web 検索が利用可能です。<br />
+<span id="fn1" style={{display: 'block', position: 'relative', top: '-120px'}} /><sup>1</sup> Google Cloud の Agent Platform では、Opus 4、Sonnet 4、Haiku 4.5 以降のモデルで Web 検索が利用可能です。<br />
 <span id="fn2" style={{display: 'block', position: 'relative', top: '-120px'}} /><sup>2</sup> これらのプロバイダーでは、Auto mode は Claude Sonnet 5 以降、Opus 4.7 以降、Haiku 5.5、および Fable モデルのみをサポートしています。[Auto mode 設定](/docs/ja/auto-mode-config)を参照してください。これらのプロバイダーのセッションが開始される権限モードについては、[セッションが開始される権限モード](/docs/ja/permission-modes#which-mode-a-session-starts-in)を参照してください。v2.1.158 から v2.1.206 では、これらのプロバイダーの Auto mode は `CLAUDE_CODE_ENABLE_AUTO_MODE=1` の設定も必要でしたが、v2.1.207 でその要件が削除されました。<br />
 <span id="fn3" style={{display: 'block', position: 'relative', top: '-120px'}} /><sup>3</sup> クラウドプロバイダーとの契約に従います。<br />
@@ -270,5 +270,5 @@ Desktop は部分的な例外です：[ゲートウェイルーティングは
 
     * [Desktop](/docs/ja/desktop)：[管理設定](https://claude.com/docs/third-party/claude-desktop/configuration)または [Claude Desktop on 3P](https://claude.com/docs/third-party/claude-desktop/overview) 経由
-    * [Web 検索](/docs/ja/tools-reference#websearch-tool-behavior)：Claude 4 モデル以降
+    * [Web 検索](/docs/ja/tools-reference#websearch-tool-behavior)：Opus 4、Sonnet 4、Haiku 4.5 以降のモデル
     * [Auto mode](/docs/ja/auto-mode-config)：Sonnet 5 以降、Opus 4.7 以降、Haiku 5.5、および Fable モデルのみ
     * [クロスセッションメッセージング](/docs/ja/cross-session-messaging)：このマシン上のセッション間のみ <sup><a href="#fn5">5</a></sup>
```

</details>

<details>
<summary>google-vertex-ai-ja.md</summary>

```diff
diff --git a/docs-ja/pages/google-vertex-ai-ja.md b/docs-ja/pages/google-vertex-ai-ja.md
index 5411c71..2639440 100644
--- a/docs-ja/pages/google-vertex-ai-ja.md
+++ b/docs-ja/pages/google-vertex-ai-ja.md
@@ -225,5 +225,5 @@ Claude Code は [MCP tool search](/docs/ja/mcp#scale-with-mcp-tool-search)と事
 
 * **Claude Opus 4.5、Sonnet 4.5、Haiku 4.5、およびそれ以降**：Claude Code はデフォルトでツール検索を有効にします。
-* **Claude 3.x モデルを含む以前のモデル**：Claude Code は MCP ツール定義を事前にロードします。これは、Agent Platform サービングスタックが必要なベータヘッダーを拒否するためです。`ENABLE_TOOL_SEARCH=true` を設定してもこれをオーバーライドしません。
+* **以前のモデル**：Claude Code は MCP ツール定義を事前にロードします。これは、これらのモデルの Agent Platform サービングスタックが必要なベータヘッダーを拒否するためです。`ENABLE_TOOL_SEARCH=true` を設定してもこれを上書きしません。
 
 すべてのモデルでツール検索を無効にするには、`ENABLE_TOOL_SEARCH=false` を設定します。v2.1.221 より前は、Claude Code は `ENABLE_TOOL_SEARCH=true` を設定しない限り、Google Cloud の Agent Platform 上のすべてのモデルでツール検索を無効にしていました。
```

</details>

<details>
<summary>interactive-mode-ja.md</summary>

```diff
diff --git a/docs-ja/pages/interactive-mode-ja.md b/docs-ja/pages/interactive-mode-ja.md
index c1b696e..61a3457 100644
--- a/docs-ja/pages/interactive-mode-ja.md
+++ b/docs-ja/pages/interactive-mode-ja.md
@@ -719,5 +719,5 @@ Claude は補足質問に対して、会話に既に含まれている内容か
 タスクリストは Claude のやることリストです。複数ステップの作業を計画するために Claude が作成したアイテムで、保留中、進行中、完了を示すインジケーターが付いています。バックグラウンドタスクビューとは別です。実行中のシェルとサブエージェントを確認するには、代わりに [`/tasks`](/docs/ja/commands) を使用してください。
 
-リストは、タスク追跡ツールを持つセッションにのみ入力されます。Claude Code は [Claude 3.x モデル、Opus 4 から 4.7、Sonnet 4 から 4.6、Haiku 4.5](/docs/ja/tools-reference#task-tool-availability) でデフォルトでこれらのツールを提供します。他のモデル（Claude Code が認識しないモデル ID を含む）では、`CLAUDE_CODE_ENABLE_TODO_TOOLS=1` でオプトインするか、[タスクツールの利用可能性](/docs/ja/tools-reference#task-tool-availability) の下にある他の方法のいずれかを使用しない限り、リストは空のままです。セッションにツールがある場合、タスクリストは次のように機能します。
+リストは、タスク追跡ツールを持つセッションにのみ入力されます。Claude Code は [Opus 4.7、Sonnet 4.6、Haiku 4.5、およびそれ以前のモデル](/docs/ja/tools-reference#task-tool-availability) でデフォルトでこれらのツールを提供します。他のモデル（Claude Code が認識しないモデル ID を含む）では、`CLAUDE_CODE_ENABLE_TODO_TOOLS=1` でオプトインするか、[タスクツールの利用可能性](/docs/ja/tools-reference#task-tool-availability) の下にある他の方法のいずれかを使用しない限り、リストは空のままです。セッションにツールがある場合、タスクリストは次のように機能します。
 
 * `Ctrl+T` を押してタスクリストビューを切り替えます。表示は一度に最大 5 つのタスクを表示します。Claude がまだチェックリストアイテムを作成していない場合、表示するものがないため、切り替えは目に見える効果がありません
```

</details>

<details>
<summary>llm-gateway-connect-ja.md</summary>

```diff
diff --git a/docs-ja/pages/llm-gateway-connect-ja.md b/docs-ja/pages/llm-gateway-connect-ja.md
index 68cdbc9..7d5139f 100644
--- a/docs-ja/pages/llm-gateway-connect-ja.md
+++ b/docs-ja/pages/llm-gateway-connect-ja.md
@@ -593,5 +593,5 @@ AWS auth skipped
 | `API returned an empty or malformed response (HTTP 200)` | ゲートウェイまたは中間プロキシが非 API レスポンス（多くの場合 HTML エラーまたはログインページ）を返しました | 上記の [curl リクエスト](#verify-the-connection)でテストします。Claude API レスポンス以外で応答するゲートウェイルートを修正します。[エラーリファレンス](/docs/ja/errors#api-returned-an-empty-or-malformed-response)はメッセージが報告する詳細を説明しています |
 | `context_management`、`Extra inputs are not permitted`、または他の認識されないフィールドという名前の `400` エラー | ゲートウェイは Anthropic 形式エンドポイントに Claude Code が送信するフィールドを拒否する上流にリクエストを転送します | `CLAUDE_CODE_DISABLE_EXPERIMENTAL_BETAS=1` を設定します。これはほとんどのプレリリースフィールドを抑制します。[機能パススルー](/docs/ja/llm-gateway-protocol#feature-pass-through)を参照してください。一部のベータはこのフラグでゲートされていません。それらについては、一致する `CLAUDE_CODE_USE_*` プロバイダー変数を設定して、Claude Code がそのプロバイダーが受け入れるもののみを送信するようにします |
-| `thinking` または `adaptive` という名前の `400` エラー（`Input tag 'adaptive' found` など） | 上流モデルビルドは Claude Code が Claude 4.6 以降のモデルに要求する適応推論を受け入れません | ゲートウェイの上流をアップグレードします。Opus 4.6 と Sonnet 4.6 では、代わりに `CLAUDE_CODE_DISABLE_ADAPTIVE_THINKING=1` が機能します。[モデル設定](/docs/ja/model-config)機能変数は、`CLAUDE_CODE_USE_BEDROCK` や `CLAUDE_CODE_USE_VERTEX` などのプロバイダー設定にのみ適用され、`ANTHROPIC_BASE_URL` ゲートウェイの背後には適用されません |
+| `thinking` または `adaptive` という名前の `400` エラー（`Input tag 'adaptive' found` など） | 上流モデルビルドは、Claude Code が Claude Opus 4.6、Claude Sonnet 4.6、Claude Haiku 5.5、Claude Fable 5 以降のモデルに要求する適応推論を受け入れません | ゲートウェイの上流をアップグレードします。Opus 4.6 と Sonnet 4.6 では、代わりに `CLAUDE_CODE_DISABLE_ADAPTIVE_THINKING=1` が機能します。[モデル設定](/docs/ja/model-config)機能変数は、`CLAUDE_CODE_USE_BEDROCK` や `CLAUDE_CODE_USE_VERTEX` などのプロバイダー設定にのみ適用され、`ANTHROPIC_BASE_URL` ゲートウェイの背後には適用されません |
 | ゲートウェイ独自の言葉でコンテキストまたはトークン制限を述べる `400` エラー（`ContextWindowExceededError` または `prompt token count of N exceeds the limit of M` など） | ゲートウェイはモデルのネイティブウィンドウより小さいコンテキストを強制し、上流エラーを書き直すため、Claude Code は[長すぎるエラー](/docs/ja/errors#prompt-is-too-long)として認識せず、自動的にコンパクト化して再試行しません | `/compact` を実行してセッションを復旧します。防ぐには、`CLAUDE_CODE_AUTO_COMPACT_WINDOW` をゲートウェイの制限に設定します。Claude Code は値を少なくとも 100,000 トークン、最大でもモデルのコンテキストウィンドウにクランプするため、100,000 未満のゲートウェイ制限は一致できず、`/compact` はそこでの復旧のままです。また、`CLAUDE_CODE_MAX_OUTPUT_TOKENS` をゲートウェイモデルの出力制限より下に設定します |
 | Claude Code v2.1.265 から v2.1.267 で、ツールの入力スキーマまたはその `pattern` を拒否するゲートウェイ独自の言葉での `400` エラー | これらのバージョンでの段階的なロールアウトで、[Artifact ツール](/docs/ja/artifacts#availability)スキーマは `\p{...}` Unicode 文字クラスを持つ正規表現を含みます。Anthropic API はそれを受け入れますが、各ツールスキーマの `pattern` を独自の正規表現エンジンでチェックするゲートウェイまたは上流は、リクエスト全体を拒否します | v2.1.268 以降に更新します。これは正規表現を送信しません。影響を受けるバージョンでは、[アーティファクトをオフにします](/docs/ja/artifacts#disable-artifacts)。これはツールとそのスキーマをリクエストから削除します |
```

</details>

*...以降省略*

</details>


<details>
<summary>2026-10-12</summary>

**変更ファイル:**

```
 docs-ja/pages/agent-view-ja.md         |  4 +-
 docs-ja/pages/authentication-ja.md     |  6 +--
 docs-ja/pages/costs-ja.md              | 13 +++++++
 docs-ja/pages/debug-your-config-ja.md  | 68 +++++++++++++++++++++++++++-------
 docs-ja/pages/desktop-ja.md            | 53 ++++++++++++++++++++++++++
 docs-ja/pages/env-vars-ja.md           |  2 +-
 docs-ja/pages/errors-ja.md             | 33 +++++++++++------
 docs-ja/pages/hooks-ja.md              | 30 +++++++++++++--
 docs-ja/pages/permission-modes-ja.md   |  2 +-
 docs-ja/pages/permissions-ja.md        | 25 +++++++------
 docs-ja/pages/remote-control-ja.md     |  2 +-
 docs-ja/pages/sandboxing-ja.md         | 12 +++++-
 docs-ja/pages/scheduled-tasks-ja.md    | 19 ++++++----
 docs-ja/pages/settings-reference-ja.md |  4 +-
 docs-ja/pages/statusline-ja.md         |  2 +-
 docs-ja/pages/workflows-ja.md          | 10 +++++
 docs-ja/pages/worktrees-ja.md          |  2 +-
 17 files changed, 227 insertions(+), 60 deletions(-)
```

<details>
<summary>agent-view-ja.md</summary>

```diff
diff --git a/docs-ja/pages/agent-view-ja.md b/docs-ja/pages/agent-view-ja.md
index 9b9eeae..6a80356 100644
--- a/docs-ja/pages/agent-view-ja.md
+++ b/docs-ja/pages/agent-view-ja.md
@@ -291,5 +291,5 @@ Claude Code が会話を再度開けない場合は、終了して会話を再
 `←` を押した元の行は、矢印キーまたはマウスで選択を移動した後も、太字で薄くない名前を保持するため、どのセッションから来たかがわかります。
 
-`←` を押したときにツールが実行中の場合、Claude Code はバックグラウンドにする前にその完了を待ち、Claude はバックグラウンドセッションで応答を続けます。待たずにすぐにバックグラウンドにするには、`←` を再度押します。進行中の作業をバックグラウンドセッションに引き継げない場合、Claude Code は [`/background`](#from-inside-a-session) と同様に、まず `Background this session?` ダイアログを表示します。
+`←` を押したときにツールが実行中の場合、Claude Code はバックグラウンドにする前にその完了を待ち、Claude はバックグラウンドセッションで応答を続けます。待たずにすぐにバックグラウンドにするには、`←` を再度押します。進行中のバックグラウンド作業をバックグラウンドセッションに引き継げない場合、Claude Code は [`/background`](#from-inside-a-session) と同様に、まず `Background this session?` ダイアログを表示します。
 
 約 10 秒経過すると、Claude Code はそれ以上待たずにセッションをバックグラウンドにします。ただし、次のようなケースは例外です：
@@ -301,4 +301,6 @@ Claude Code が会話を再度開けない場合は、終了して会話を再
 * **キューに入れたメッセージを移動できない**：[Claude の作業中にキューに入れた](/docs/ja/interactive-mode#queue-messages-while-claude-works) メッセージは、会話とともにバックグラウンドセッションに移動します。そのいずれかを移動できない場合、セッションはフォアグラウンドに留まり、Claude Code は `Cannot open agents — 1 queued message can't move to the background. Press ← again once Claude has read it.` のような通知を表示します。
 
+Claude Code がセッションをバックグラウンドにすると（約 10 秒経過後、または `←` を再度押した後）、Claude がフォアグラウンドでまだ実行中のシェルコマンドは停止されます。Claude Code はそのコマンドについて `Background this session?` ダイアログを表示しません。バックグラウンドセッションでは、Claude はそのコマンドが開始されたという記録を持たないため、コマンドを再度実行する場合があります。セッションの移動時にコマンドを実行し続けるには、Claude Code がまだ待機している間に `Ctrl+B` を押して [バックグラウンドコマンドに切り替えます](/docs/ja/interactive-mode#background-bash-commands)。
+
 `←` を押すと、会話にまだメッセージがない場合でもセッションの行が作成されるため、`→` でその行に戻れます。
 
```

</details>

<details>
<summary>authentication-ja.md</summary>

```diff
diff --git a/docs-ja/pages/authentication-ja.md b/docs-ja/pages/authentication-ja.md
index 49d8dfe..60c4103 100644
--- a/docs-ja/pages/authentication-ja.md
+++ b/docs-ja/pages/authentication-ja.md
@@ -259,5 +259,5 @@ Claude Code は認証情報を安全に管理します。
 3. `ANTHROPIC_API_KEY` 環境変数。`X-Api-Key` ヘッダーとして送信されます。[Claude Console](https://platform.claude.com) からのキーを使用して Anthropic API に直接アクセスする場合に使用します。対話モードでは、キーを承認または拒否するよう 1 回プロンプトが表示され、選択が記憶されます。後で変更するには、`/config` の「Use custom API key」トグルを使用します。トグルは `ANTHROPIC_API_KEY` が環境に設定されている間のみ表示されます。非対話モード（`-p`）では、キーが存在する場合は常に使用されます。
 4. [`apiKeyHelper`](/docs/ja/settings-reference#apikeyhelper) スクリプト出力。動的または回転する認証情報（ボルトから取得した短期トークンなど）に使用します。
-5. `CLAUDE_CODE_OAUTH_TOKEN` 環境変数。[`claude setup-token`](#generate-a-long-lived-token) によって生成された長期 OAuth トークン。ブラウザログインが利用できない CI パイプラインとスクリプトに使用します。`CLAUDE_CODE_OAUTH_TOKEN` が設定されている間に `/login` を実行すると、Claude Code は現在のセッションを新しいログインに切り替えますが、新しいセッションのたびに変数を再度読み込みます。シェルプロファイルまたは [設定ファイル](/docs/ja/settings)の `env` ブロックから変数を削除するまで。
+5. `CLAUDE_CODE_OAUTH_TOKEN` 環境変数。[`claude setup-token`](#generate-a-long-lived-token) によって生成された長期 OAuth トークン。ブラウザログインが利用できない CI パイプラインとスクリプトに使用します。この変数が設定されている間に `/login` を実行すると、Claude Code は現在のセッションを新しいログインに切り替えますが、シェルプロファイルまたは[設定ファイル](/docs/ja/settings)の `env` ブロックから変数を削除するまで、新しいセッションのたびに変数を再度読み込みます。
 6. Anthropic プロファイルおよびフェデレーション認証情報。`ant` CLI および Workload Identity Federation が使用する認証情報。`ant auth login` が書き込んだプロファイルは、`ANTHROPIC_PROFILE` で名前を付けた場合にのみここにランク付けされます。そうでない場合は `/login` より下にランク付けされます。[Anthropic プロファイルおよびフェデレーション認証情報](#anthropic-profiles-and-federation-credentials)を参照してください。
 7. `/login` からのサブスクリプション OAuth 認証情報。これは Claude Pro、Max、Team、および Enterprise ユーザーのデフォルトです。
@@ -265,5 +265,5 @@ Claude Code は認証情報を安全に管理します。
 署名済みの [Claude apps gateway](/docs/ja/claude-apps-gateway) セッションはこのリストの外に位置します。これは Amazon Bedrock または Google Cloud の Agent Platform のようなプロバイダー選択であり、それらより優先されます。ゲートウェイセッションが存在する場合、CLI は `CLAUDE_CODE_USE_BEDROCK`、`CLAUDE_CODE_USE_VERTEX`、または `CLAUDE_CODE_USE_FOUNDRY` が設定されていても、ゲートウェイトークンで認証され、ベアラートークン、API キー、`apiKeyHelper`、およびプロファイルなどの上記の認証情報ソースは使用されません。
 
-マシンの [管理設定](/docs/ja/managed-settings)が [`forceLoginMethod`](/docs/ja/settings-reference#forceloginmethod) を `"gateway"` に設定するか、[`forceLoginGatewayUrl`](/docs/ja/settings-reference#forcelogingatewayurl) を設定し、`CLAUDE_CODE_USE_BEDROCK` または `CLAUDE_CODE_USE_VERTEX` などの変数を通じてクラウドプロバイダーを選択しない場合、セッションはゲートウェイサインインのみを使用します。Claude Code は他の認証情報ソースをスキップし、`/login` でサインインするよう求めます。残りの各認証情報で表示される内容については、[Administrator policy requires a Cloud gateway sign-in](/docs/ja/errors#administrator-policy-requires-a-cloud-gateway-sign-in) を参照してください。Claude Code v2.1.261 以降、またはゲートウェイサインインのみを設定するマシンの v2.1.265 以降が必要です。
+マシンの[管理設定](/docs/ja/managed-settings)が [`forceLoginMethod`](/docs/ja/settings-reference#forceloginmethod) を `"gateway"` に設定するか、[`forceLoginGatewayUrl`](/docs/ja/settings-reference#forcelogingatewayurl) を設定しており、`CLAUDE_CODE_USE_BEDROCK` や `CLAUDE_CODE_USE_VERTEX` などの変数を通じてクラウドプロバイダーを選択していない場合、セッションはゲートウェイサインインのみを使用します。Claude Code は他の認証情報ソースをスキップし、`/login` でサインインするよう求めます。残っている各認証情報で表示される内容については、[Administrator policy requires a Cloud gateway sign-in](/docs/ja/errors#administrator-policy-requires-a-cloud-gateway-sign-in) を参照してください。Claude Code v2.1.261 以降が必要です。`forceLoginGatewayUrl` のみを設定するマシンでは v2.1.265 以降が必要です。
 
 アクティブな Claude サブスクリプションがあり、環境に `ANTHROPIC_API_KEY` も設定されている場合、API キーは承認されると優先されます。キーが無効または期限切れの組織に属している場合、これは認証エラーを引き起こす可能性があります。
@@ -293,5 +293,5 @@ Claude Code は 3 つのソースをこの順序でチェックし、設定さ
 Claude Code が選択したソースを確認するには、`/status` を実行してください。`Profile` 行は `Login method` 行の代わりにソースを名前で表示し、プロファイルが使用中の認証情報である場合、`Organization` および `Email` 行はそのアカウントを表示します。
 
-`user_oauth` プロファイルのログインが期限切れになり、Claude Code がそれを更新できない場合、リクエストは [Anthropic profile login expired](/docs/ja/errors#anthropic-profile-login-expired) で失敗します。
+`user_oauth` プロファイルのログインが期限切れになり、Claude Code がそれを更新できない場合、リクエストは[プロファイルログインの期限切れエラー](/docs/ja/errors#anthropic-profile-login-expired)で失敗します。
 
 [claude.ai コネクタ](/docs/ja/mcp#use-mcp-servers-from-claude-ai)および [`/schedule`](/docs/ja/routines)などの claude.ai ログインが必要な機能は、これらのソースの 1 つが選択されている間は利用できません。Claude Code がソースを選択するのを停止するには、以下を実行してください。
```

</details>

<details>
<summary>costs-ja.md</summary>

```diff
diff --git a/docs-ja/pages/costs-ja.md b/docs-ja/pages/costs-ja.md
index 5b9d11a..546e79f 100644
--- a/docs-ja/pages/costs-ja.md
+++ b/docs-ja/pages/costs-ja.md
@@ -93,4 +93,17 @@ Pro、Max、Team、または Enterprise プランでは、`/usage` はプラン
 プラン制限のリクエストが失敗した場合（ほとんどの場合、使用量エンドポイントがレート制限されているため）、`/usage` は過去 60 分以内にこのマシンで読み込んだ最後の使用量バーを表示し、そのデータがいつ取得されたかを示す `Showing last-known usage` ノートが表示されます。`r` を押して再試行します。再試行が成功すると、最後に認識されたバーが新しいデータに置き換わります。過去 60 分以内のスナップショットがない場合、`/usage` は使用量エンドポイントがレート制限されていることを報告し、同じ再試行ショートカットを提供します。v2.1.208 より前では、使用量をまだ読み込んでいないセッションでレート制限されたリクエストは常にバーなしでエラーを表示していました。
 
+<h3 id="read-the-token-count-beside-the-spinner">
+  スピナー横のトークン数を読む
+</h3>
+
+Claude がメイン会話で作業している間、スピナー横の行の末尾に経過時間とトークン数が表示されることがあります（例: `Deciphering… (10m 27s · ↓ 5.5k tokens)`）。これは、現在のターンでこれまでに生成された出力のリアルタイムの概算カウントです。出力の受信中やツールの実行中は、カウント横の矢印が下を向きます。
+
+* **対象となるもの**: ターンが生成する出力。Claude がストリーミングで返すテキストやツール呼び出し、思考、[フォアグラウンド](/docs/ja/sub-agents#run-subagents-in-foreground-or-background) で実行されるサブエージェントの出力など
+* **対象外のもの**: Claude Code がモデルに送信する内容。そのため、プロンプト、会話履歴、その他のコンテキストはこのカウントに影響しません
+* **リセットされるタイミング**: 各ターンの開始時と、Claude Code が [会話を圧縮する](/docs/ja/prompt-caching#compacting-the-conversation) とき
+* **非表示になる場合**: 出力が届き始めるまでの間、行の幅が狭すぎて収まらない場合、および [スクリーンリーダーモード](/docs/ja/accessibility) の場合
+
+このカウントは、`/usage` セッションブロックの `Usage by model` の出力数値とは一致しません。後者は 1 ターンではなくセッション全体を合計するためです。また、[詳細モードで追加される](/docs/ja/statusline#notifications-share-the-status-line-row) トークン数とも異なります。そちらは 1 ターンの出力ではなくコンテキストのサイズを測定するためです。
+
 <h3 id="analyze-your-usage-patterns">
   使用パターンを分析する
```

</details>

<details>
<summary>debug-your-config-ja.md</summary>

```diff
diff --git a/docs-ja/pages/debug-your-config-ja.md b/docs-ja/pages/debug-your-config-ja.md
index faf8f73..1519883 100644
--- a/docs-ja/pages/debug-your-config-ja.md
+++ b/docs-ja/pages/debug-your-config-ja.md
@@ -99,16 +99,58 @@ Claude が指示を無視したり、設定した機能が表示されない場
 セーフモードでも、組織からの管理フックと設定ポリシーは引き続き適用されます。管理対象のプラグイン、スキル、`CLAUDE.md`、MCP サーバーはオフになります。
 
-セーフモードで問題が続く場合、または設定自体が疑わしい場合は、通常のセットアップから何も読み込まないセッションと比較してください。[`CLAUDE_CONFIG_DIR`](/docs/ja/env-vars) を空のディレクトリに指定して `~/.claude` の下のすべてをバイパスし、`.claude` フォルダ、`.mcp.json`、または `CLAUDE.md` がないディレクトリから起動して、プロジェクト設定もスキップします。
-
-```bash theme={null}
-cd /tmp && CLAUDE_CONFIG_DIR=/tmp/claude-clean claude
-```
-
-クリーンセッションには、ユーザーまたはプロジェクト設定、hooks、MCP サーバー、plugins、またはメモリがありません。最初の起動時には、テーマ選択から始まる最初の実行セットアップ画面が表示されることを想定してください。それらが表示される場合、クリーン設定ディレクトリが有効です。同じディレクトリでの後続の起動では、Claude Code がそこにオンボーディング状態を保存するため、これらの画面はスキップされます。
-
-* 組織がそれらをデプロイする場合、マネージド設定は引き続き適用されます。Claude Code は MDM プロファイル、レジストリポリシー、および設定ディレクトリの外の場所から `managed-settings.json` を読み取り、クリーンセッションが認証情報を取得した後、[サーバーマネージド設定を再度取得](/docs/ja/server-managed-settings#fetch-and-caching-behavior)します
-* ログインするよう再度促されます
-
-問題がここで消える場合、原因は実際の `~/.claude` またはプロジェクト `.claude` ファイルのどこかにあります。ファイルを一度に 1 つずつ再導入します。ファイルを一時ディレクトリにコピーするか、プロジェクトから起動して、どれが原因かを見つけます。クリーンセッションで問題が続く場合、原因はユーザーおよびプロジェクト設定の外にあります。`/status` を実行してマネージド設定が有効かどうかを確認し、Claude Code に影響を与える[環境変数](/docs/ja/env-vars)を探してから、[トラブルシューティング](/docs/ja/troubleshooting)を参照してください。
+セーフモードで問題が続く場合、または設定自体が疑わしい場合は、自分の設定を一切使わないセッションを開始し、問題が再現するかどうかを確認してください。
+
+<Steps>
+  <Step title="空のディレクトリを作成して移動する">
+    Claude Code のセッションを実行していない状態のシェルで、ディレクトリを作成して移動します。
+
+    <Tabs>
+      <Tab title="Bash または Zsh">
+        ```bash theme={null}
+        mkdir -p ~/claude-clean/empty && cd ~/claude-clean/empty
+        ```
```

</details>

<details>
<summary>desktop-ja.md</summary>

```diff
diff --git a/docs-ja/pages/desktop-ja.md b/docs-ja/pages/desktop-ja.md
index 99f1021..79f334a 100644
--- a/docs-ja/pages/desktop-ja.md
+++ b/docs-ja/pages/desktop-ja.md
@@ -914,4 +914,6 @@ Desktop はリンクを開いたときに、未送信のテキストを置き換
 各エントリには `id`、`name`、および `sshHost` が必要です。`sshPort` および `sshIdentityFile` フィールドはオプションです。ユーザーは、自分の `~/.claude/settings.json` に `sshConfigs` を追加することもできます。
 
+`sshHost` から `user@` を省略した場合、Desktop は各開発者の `~/.ssh/config` がそのホストに対して設定している `User` として接続し、設定がない場合は開発者自身のコンピューター上のユーザー名で接続します。
+
 <h4 id="restrict-which-ssh-hosts-users-can-connect-to">
   ユーザーが接続できる SSH ホストを制限する
@@ -938,4 +940,55 @@ Desktop はリンクを開いたときに、未送信のテキストを置き換
 `sshHostAllowlist` は管理設定からのみ読み取られます。ユーザーまたはプロジェクト設定の値は無視されます。Claude Desktop アプリのみがこの設定を尊重します。Claude Code CLI と IDE 拡張機能はこれを読み取らず、Bash ツールを通じて実行される `ssh` コマンドを制限しません。これは Desktop アプリが接続するホストを管理し、ネットワーク出力ではないため、ハード境界が必要な場合は組織のネットワークまたはゼロトラストコントロールと組み合わせてください。
 
+<h4 id="turn-off-local-sessions-and-distribute-ssh-connections">
+  ローカルセッションをオフにして SSH 接続を配布する
+</h4>
+
+ローカルセッションをオフにし、SSH セッションを選択したホストに制限するには、[`disableDesktopLocalSessions`](/docs/ja/settings-reference#disabledesktoplocalsessions)、[`sshConfigs`](#pre-configure-ssh-connections-for-your-team)、[`sshHostAllowlist`](#restrict-which-ssh-hosts-users-can-connect-to) を一緒にデプロイします。
+
+<Note>
+  この構成は、Claude アカウントでサインインするユーザー向けです。[サードパーティプロバイダー](/docs/ja/third-party-integrations)を使用する場合、SSH セッションはデフォルトでオフになっており、`sshHostAllowlist` を設定するとオンにできます。これらのキーをデプロイする前に、[SSH remote sessions in Claude Desktop on 3P](https://claude.com/docs/third-party/claude-desktop/ssh-remote-sessions) をお読みください。
+</Note>
+
+次の例は、ローカルセッションをオフにし、1 つの接続を追加して、SSH セッションをその接続のホストに制限します：
+
+```json managed-settings.json theme={null}
+{
+  "disableDesktopLocalSessions": true,
+  "sshConfigs": [
```

</details>

<details>
<summary>env-vars-ja.md</summary>

```diff
diff --git a/docs-ja/pages/env-vars-ja.md b/docs-ja/pages/env-vars-ja.md
index 00302a9..1260237 100644
--- a/docs-ja/pages/env-vars-ja.md
+++ b/docs-ja/pages/env-vars-ja.md
@@ -257,5 +257,5 @@ Claude Code はスタートアップ時にシェル環境変数を読み込む
 | `CLAUDE_CODE_DISABLE_BEDROCK_CONTENT_TYPE_DEFAULT` | `1` に設定すると、`Content-Type` ヘッダーが欠落しているか空の [Amazon Bedrock](/docs/ja/amazon-bedrock) ストリーミングレスポンスを、Claude Code が Amazon Bedrock のバイナリイベントストリームとして扱わないようにします。デフォルトでは、Claude Code は、ゲートウェイがそれ以外は変更されていないレスポンスからヘッダーを削除したと想定してボディをデコードするため、ストリーミングは引き続き機能します。ストリームをサーバー送信イベントとして再送出するゲートウェイの場合にのみ設定してください。その場合、Claude Code はヘッダーのないボディをサーバー送信イベントとして読み取ります。Claude Code v2.1.239 以降が必要です |
 | `CLAUDE_CODE_DISABLE_BEDROCK_CONTENT_TYPE_GUARD` | `1` に設定すると、[Amazon Bedrock](/docs/ja/amazon-bedrock) のストリーミングレスポンスが `application/vnd.amazon.eventstream` の content-type を持つかどうかのチェックをスキップします。この変数がない場合、レスポンスが異なる content-type を持つと、Claude Code はその type を示すエラーでリクエストを失敗させます。これは[ゲートウェイまたはプロキシがレスポンスを変換している](/docs/ja/amazon-bedrock#streaming-errors-behind-a-gateway-or-proxy)ことを意味します。この変数を設定するのではなく、`Content-Type` ヘッダーとボディを変更せずに転送するようゲートウェイを設定してください。Claude Code v2.1.208 以降が必要です |
-| `CLAUDE_CODE_DISABLE_BG_EXIT_HANDOFF` | `1` に設定すると、[スーパーバイザー](/docs/ja/agent-view#the-supervisor-process)が[バックグラウンドセッション](/docs/ja/agent-view)のプロセスを停止、再起動、または更新するときに、そのセッションで実行中のバックグラウンドシェルコマンド、動的ワークフロー、および v2.1.198 以降ではバックグラウンドサブエージェントを、セッションの次のプロセスに引き渡す代わりに停止します。影響するのはその引き渡しのみです。`←` または [`/background`](/docs/ja/agent-view#from-inside-a-session) でセッションをバックグラウンド化する場合は引き続き処理中の作業が引き継がれ、`CLAUDE_DISABLE_ADOPT` は両方をオフにします。Claude Code v2.1.196 以降が必要です |
+| `CLAUDE_CODE_DISABLE_BG_EXIT_HANDOFF` | `1` に設定すると、[スーパーバイザー](/docs/ja/agent-view#the-supervisor-process)が[バックグラウンドセッション](/docs/ja/agent-view)のプロセスを停止、再起動、または更新したときに、そのセッションで実行中のバックグラウンドシェルコマンド、動的ワークフロー、および v2.1.198 以降ではバックグラウンドサブエージェントを、セッションの次のプロセスに引き渡すのではなく停止します。影響するのはこの引き渡しのみです。`←` または [`/background`](/docs/ja/agent-view#from-inside-a-session) でセッションをバックグラウンド化した場合は、進行中のバックグラウンド作業は引き続き引き継がれます。`CLAUDE_DISABLE_ADOPT` は両方をオフにします。Claude Code v2.1.196 以降が必要です |
 | `CLAUDE_CODE_DISABLE_BG_SHELL_PRESSURE_REAP` | `1` に設定すると、メモリ逼迫時に Claude Code が[バックグラウンドシェルコマンド](/docs/ja/interactive-mode#background-bash-commands)を終了しないようにします。デフォルトでは、macOS と Linux で、オペレーティングシステムが深刻なメモリ逼迫を報告し、かつセッションがターンやサブエージェントの実行なしで 30 分間アイドル状態だった場合、Claude Code はバックグラウンドシェルを終了します。Windows にはメモリ逼迫のシグナルがないため、この変数は効果がありません。Claude Code v2.1.193 以降が必要です |
 | `CLAUDE_CODE_DISABLE_BUNDLED_SKILLS` | `1` に設定すると、Claude Code に含まれる[スキル](/docs/ja/skills)とワークフローを無効にします。バンドルスキルとワークフローは完全に削除され、`/init` などの組み込みコマンドは入力可能なままですが、モデルからは隠されます。`/doctor` は組み込みコマンドと同様に入力可能なままです。隠すには、代わりに `DISABLE_DOCTOR_COMMAND` を使用します。プラグイン、`.claude/skills/`、`.claude/commands/` のスキルは影響を受けません。[`disableBundledSkills`](/docs/ja/settings-reference#disablebundledskills) 設定と同等です |
```

</details>

<details>
<summary>errors-ja.md</summary>

```diff
diff --git a/docs-ja/pages/errors-ja.md b/docs-ja/pages/errors-ja.md
index b457010..5b0eaba 100644
--- a/docs-ja/pages/errors-ja.md
+++ b/docs-ja/pages/errors-ja.md
@@ -95,4 +95,5 @@
 | `Your account is on hold and can't sign in to Claude Code. View details or appeal: https://claude.ai/restricted` | [認証](#your-account-is-on-hold) |
 | `Anthropic profile login expired · Re-authenticate your Anthropic profile` | [認証](#anthropic-profile-login-expired) |
+| `Login expired · Run /login to sign in again, or re-authenticate your Anthropic profile` | [認証](#anthropic-profile-login-expired) |
 | `Anthropic profile login expired · Run /login to use your claude.ai account instead, or re-authenticate the profile` | [認証](#anthropic-profile-login-expired) |
 | `does not meet scope requirement user:profile` | [認証](#oauth-scope-requirement) |
@@ -1304,4 +1305,6 @@ Failed to authenticate: OAuth session expired and could not be refreshed
 ```
 
+`or re-authenticate your Anthropic profile` で終わる `Login expired` メッセージについては、[Anthropic profile login expired](#anthropic-profile-login-expired) を参照してください。
+
 これは [OAuth トークンが取り消された、または期限切れです](#oauth-token-revoked-or-expired)とは異なる状態です。そちらのメッセージは API が返した拒否を報告します。`Login expired` は、すでに更新に失敗したログインに対して Claude Code 自身が生成するものであり、リクエストは送信されません。ログインが古くなったのではなくアカウント自体が停止されているために更新が失敗した場合、Claude Code は代わりに[アカウントが保留中です](#your-account-is-on-hold)を表示します。
 
@@ -1469,25 +1472,27 @@ Your account is on hold and can't sign in to Claude Code. View details or appeal
 </h3>
 
-Claude Code は Anthropic 認証情報プロファイルを通じて認証していますが、そのプロファイルに保存されたログイン認証情報の有効期限が切れており、プロファイルには Claude Code が更新に使用できるリフレッシュ用の認証情報がありません。再試行しても同じ期限切れの認証情報を読み取るだけなので、Claude Code は再試行せずに各リクエストをローカルで停止します。
+Claude Code は Anthropic の認証情報プロファイルを通じて認証していますが、保存されているログイン認証情報の有効期限が切れており、プロファイルには Claude Code が更新に使用できるリフレッシュ用の認証情報がありません。Claude Code は再試行せずに、各リクエストをローカルで停止します。
 
 ```text theme={null}
 Anthropic profile login expired · Re-authenticate your Anthropic profile
-Anthropic profile login expired · Run /login to use your claude.ai account instead, or re-authenticate the profile
+Login expired · Run /login to sign in again, or re-authenticate your Anthropic profile
 ```
 
-このメッセージは、有効な認証情報が Anthropic 認証情報プロファイルから取得される場合にのみ表示されます。対象となるのは、`ANTHROPIC_PROFILE` 環境変数で選択したプロファイル、Claude Code が Anthropic 設定ディレクトリ内でアクティブなプロファイルとして検出したプロファイル、または [API キーなしでサインイン](/docs/ja/authentication#sign-in-without-an-api-key)したときに Claude Code が書き込んだプロファイルです。API キー、`ANTHROPIC_AUTH_TOKEN` などのベアラートークン、またはサードパーティプロバイダーで認証するセッションでは、このメッセージは表示されません。
```

</details>

*...以降省略*

</details>


<details>
<summary>2026-10-11</summary>

**変更ファイル:**

```
 docs-ja/pages/agent-view-ja.md                     | 32 +++++----
 docs-ja/pages/analytics-ja.md                      |  2 +-
 docs-ja/pages/authentication-ja.md                 |  6 +-
 docs-ja/pages/auto-mode-config-ja.md               |  4 +-
 docs-ja/pages/checkpointing-ja.md                  |  4 +-
 docs-ja/pages/claude-apps-gateway-config-ja.md     |  2 +-
 docs-ja/pages/claude-apps-gateway-deploy-ja.md     |  2 +-
 docs-ja/pages/claude-apps-gateway-ja.md            | 24 ++++++-
 docs-ja/pages/cli-reference-ja.md                  | 10 +--
 docs-ja/pages/code-review-ja.md                    |  8 +--
 docs-ja/pages/commands-ja.md                       |  4 +-
 docs-ja/pages/corporate-launcher-ja.md             | 11 ++-
 docs-ja/pages/cross-session-messaging-ja.md        | 10 +--
 docs-ja/pages/desktop-ja.md                        | 34 +++++++--
 docs-ja/pages/env-vars-ja.md                       |  8 +--
 docs-ja/pages/errors-ja.md                         | 38 ++++++++--
 docs-ja/pages/github-enterprise-server-ja.md       | 10 +--
 docs-ja/pages/headless-ja.md                       |  8 +--
 docs-ja/pages/hooks-guide-ja.md                    | 22 ++++--
 docs-ja/pages/hooks-ja.md                          | 51 +++++++++----
 docs-ja/pages/interactive-mode-ja.md               |  4 +-
 docs-ja/pages/llm-gateway-connect-ja.md            |  2 +-
 docs-ja/pages/mcp-ja.md                            | 10 +--
 docs-ja/pages/monitoring-usage-ja.md               | 38 +++++++++-
 docs-ja/pages/network-config-ja.md                 |  4 +-
 docs-ja/pages/permission-modes-ja.md               | 23 ++++--
 docs-ja/pages/permissions-ja.md                    | 55 ++++++++++----
 docs-ja/pages/routines-ja.md                       |  6 +-
 docs-ja/pages/sandboxing-ja.md                     |  1 +
 .../self-hosted-environments-configuration-ja.md   |  8 ++-
 .../pages/self-hosted-environments-deploy-ja.md    |  2 +
 docs-ja/pages/sessions-ja.md                       | 84 +++++++++++-----------
 docs-ja/pages/settings-ja.md                       |  4 +-
 docs-ja/pages/settings-reference-ja.md             | 49 +++++++++----
 docs-ja/pages/skills-ja.md                         | 12 ++--
 docs-ja/pages/sub-agents-ja.md                     | 12 ++--
 docs-ja/pages/terminal-config-ja.md                | 13 ++++
 docs-ja/pages/tools-reference-ja.md                | 43 ++++++++---
 docs-ja/pages/troubleshoot-install-ja.md           |  2 +-
 docs-ja/pages/vs-code-ja.md                        |  3 +-
 docs-ja/pages/workflows-ja.md                      |  2 +-
 docs-ja/pages/worktrees-ja.md                      |  4 +-
 42 files changed, 460 insertions(+), 211 deletions(-)
```

**新規追加:**


<details>
<summary>agent-view-ja.md</summary>

```diff
diff --git a/docs-ja/pages/agent-view-ja.md b/docs-ja/pages/agent-view-ja.md
index 16b716c..9b9eeae 100644
--- a/docs-ja/pages/agent-view-ja.md
+++ b/docs-ja/pages/agent-view-ja.md
@@ -153,5 +153,5 @@ Completed
 | :- | :- |
 | `✻` またはアニメーション `✽` | セッションプロセスが実行中であるか、セッションがユーザーの入力を必要としています |
-| `∙` | プロセスは終了しています。行のピーク表示は引き続き可能で、返信またはアタッチすると、Claude は中断したところから再開します |
+| `∙` | プロセスは終了しています。行のピーク表示は引き続き可能で、返信またはアタッチすると、Claude は保存された会話からセッションを再起動します |
 | `✢` | イテレーション間でスリープしている [`/loop`](/docs/ja/scheduled-tasks) セッションです。行は実行回数とカウントダウンを表示します |
 
@@ -257,4 +257,6 @@ Completed
 バックグラウンドセッションには追記先となるターミナルのスクロールバックがないため、アタッチされたセッションは `tui` 設定に関係なく、常に [フルスクリーンモード](/docs/ja/fullscreen) でレンダリングされます。`PgUp`、`PgDn`、またはマウスホイールでスクロールし、トランスクリプトモードには `Ctrl+O` を押します。ターミナルのネイティブスクロールと tmux のコピーモードは現在のビューポートのみを表示します。これはフルスクリーンアプリケーションを実行するときと同じです。
 
+アタッチされたセッションは [ターミナルにステータスを報告しません](/docs/ja/terminal-config#see-session-status-in-your-terminal)。
+
 空のプロンプトで `←` を押すか、`/exit` を実行してデタッチし、エージェントビューに戻ります。エージェントビューからセッションを開いたか、シェルから `claude attach <id>` を実行したかに関係なく機能します。
 
@@ -265,7 +267,7 @@ Windows では、アタッチしてから約 0.5 秒以内に `←` を押すと
 `Ctrl+Z` もデタッチしますが、開始した場所に戻ります。エージェントビューからアタッチした場合はエージェントビュー、`claude attach` を実行した場合はシェルです。ダイアログがフォーカスを持っていて `←` に応答しない場合は `Ctrl+Z` を使用します。
 
-`Ctrl+C` はアタッチ中も標準的な割り込み動作を保持します。デタッチするのではなく、実行中の応答または `!` シェルコマンドをキャンセルします。空のプロンプトで `Ctrl+C` を 2 回押すとデタッチします。これは他のセッションと同じです。
+`Ctrl+C` はアタッチ中も標準的な割り込み動作を保持します。デタッチするのではなく、実行中の応答または `!` シェルコマンドをキャンセルします。空のプロンプトで `Ctrl+C` を 2 回押すとデタッチします。
 
-デタッチしてもバックグラウンドセッションは停止しません。`←`、`Ctrl+Z`、`/exit`、および `Ctrl+C` または `Ctrl+D` の 2 回押しは、いずれもセッションを実行したままにします。セッション内からセッションを終了するには、`/stop` を実行します。
+デタッチしてもバックグラウンドセッションは停止しません。`←`、`Ctrl+Z`、`/exit`、および `Ctrl+C` または `Ctrl+D` の 2 回押しは、いずれもセッションを実行したままにします。`/loop` が次のイテレーションを待っている間にデタッチすると、ループは実行を続け、そのイテレーションはユーザーがいなくてもスケジュールどおりに開始されます。デタッチする前にループを停止するには、[ループを停止する](/docs/ja/scheduled-tasks#stop-a-loop) を参照してください。セッション内からセッションを終了するには、`/stop` を実行します。
 
 <h4 id="switch-sessions-without-leaving-the-terminal">
@@ -294,6 +296,7 @@ Claude Code が会話を再度開けない場合は、終了して会話を再
 
```

</details>

<details>
<summary>analytics-ja.md</summary>

```diff
diff --git a/docs-ja/pages/analytics-ja.md b/docs-ja/pages/analytics-ja.md
index 28b9c09..e44434a 100644
--- a/docs-ja/pages/analytics-ja.md
+++ b/docs-ja/pages/analytics-ja.md
@@ -68,5 +68,5 @@ Team と Enterprise ダッシュボードには以下が含まれます。
 * **「Data processing in progress」**：数日後に確認し、データが表示されない場合は GitHub アプリがインストールされていることを確認してください
 
-貢献メトリクスは GitHub Cloud と GitHub Enterprise Server をサポートしています。
+貢献メトリクスは github.com でホストされているリポジトリを対象とします。[GitHub Enterprise Server](/docs/ja/github-enterprise-server) 上のリポジトリについては、分析ダッシュボードは使用メトリクスのみを表示します。
 
 <h3 id="review-summary-metrics">
```

</details>

<details>
<summary>authentication-ja.md</summary>

```diff
diff --git a/docs-ja/pages/authentication-ja.md b/docs-ja/pages/authentication-ja.md
index 43e1d73..49d8dfe 100644
--- a/docs-ja/pages/authentication-ja.md
+++ b/docs-ja/pages/authentication-ja.md
@@ -97,5 +97,5 @@ API ベースの請求を希望する組織の場合、Claude Console を通じ
     以下のいずれかの方法でユーザーを追加できます。
 
-    * Console 内からユーザーを一括招待します。Settings -> Members -> Invite
+    * [platform.claude.com/settings/members](https://platform.claude.com/settings/members) にある Console の Members ページからユーザーを一括招待します。**Invite** をクリックします
     * [SSO を設定](https://support.claude.com/en/articles/13132885-setting-up-single-sign-on-sso)
   </Step>
@@ -124,6 +124,6 @@ API ベースの請求を希望する組織の場合、Claude Console を通じ
 API キーを作成しなくても Console アカウントにサインインできます。組織が開発者による API キーの作成を許可していない場合でも可能です。`/login` プロンプトで Anthropic Console アカウントを選択すると、Claude Code はサインイン方法を尋ねます。Claude Code v2.1.242 以降が必要です。両方のルートは Console にブラウザーでサインインしますが、Claude Code がその後に保存する内容が異なります。
 
-* **Console アカウントでサインイン**（`（推奨）` とラベル付け）: Claude Code はそのサインインから OAuth トークンを保持し、[Anthropic プロファイル](#anthropic-profiles-and-federation-credentials)として保存します。API キーは作成されません
-* **API キーを作成**（`（レガシー）` とラベル付け）: Claude Code は Console API キーを作成し、他の認証情報と一緒に保存します
+* **Console アカウントでサインイン**（`(recommended)` とラベル付け）: Claude Code はそのサインインから OAuth トークンを保持し、[Anthropic プロファイル](#anthropic-profiles-and-federation-credentials)として保存します。API キーは作成されません
+* **API キーを作成**（`(legacy)` とラベル付け）: Claude Code は Console API キーを作成し、他の認証情報と一緒に保存します
 
 実際には、プロファイルは OAuth ログインを保存し、API キーは静的な認証情報です。Claude Code はプロファイルのログインを自動的に更新し、更新に失敗すると、再度サインインするまで [Anthropic プロファイルログイン期限切れ](/docs/ja/errors#anthropic-profile-login-expired) でリクエストが失敗します。
```

</details>

<details>
<summary>auto-mode-config-ja.md</summary>

```diff
diff --git a/docs-ja/pages/auto-mode-config-ja.md b/docs-ja/pages/auto-mode-config-ja.md
index 7d4dab9..539c6cd 100644
--- a/docs-ja/pages/auto-mode-config-ja.md
+++ b/docs-ja/pages/auto-mode-config-ja.md
@@ -384,5 +384,7 @@ claude auto-mode reset
 画面上の拒否を報告する他の 2 つの場所では、コマンドまたは URL が省略されています。入力ボックスの近くの通知（`bash denied by auto mode · [Data Exfiltration] · /permissions` など）はツールと理由を示し、**Recently denied** タブはシェルコマンドを Claude が記述した説明で一覧表示します。これらの拒否の正確な入力をプログラムで取得するには、[`PermissionDenied` フック](/docs/ja/hooks#permissiondenied)を追加します。これは `tool_input` として受け取ります。
 
-呼び出しの下のテキストは、修正すべきことがあるかどうかを示します。分類器自体の問題を報告するテキスト（`is temporarily unavailable` のようなモデルや分類器エラーなど）は、Claude Code が分類器からの最終判定なしに呼び出しをブロックしたことを意味します。詳細は[オートモードがアクションの安全性を判定できない](/docs/ja/errors#auto-mode-cannot-determine-the-safety-of-an-action)を参照してください。それ以外の場合、`Denied by auto mode classifier` と `[Production Deploy]` または `Blocked by classifier` などの理由が記載された行は、分類器が呼び出しを安全でないと判定したことを意味するため、呼び出しが何に到達しようとしていたか、または何をしようとしていたかから修正を選択します。
+呼び出しの下のテキストは、修正すべきことがあるかどうかを示します。薄く表示された `Not run · auto mode's check had no usable answer` の行、または分類器自体の問題を報告するテキスト（`Auto mode could not evaluate this action` など）は、Claude Code が分類器からの判定なしに呼び出しをブロックしたことを意味します。`Not run` の行の場合は、`Ctrl+O` を押してメッセージ全文を読み、対処方法については[auto モードがアクションの安全性を判定できない](/docs/ja/errors#auto-mode-cannot-determine-the-safety-of-an-action)または[サーバーが安全性の判定を返さなかった](/docs/ja/errors#the-server-returned-no-safety-verdict)を参照してください。
+
+それ以外の場合、`Denied by auto mode classifier` と `[Production Deploy]` または `Blocked by classifier` などの理由が記載された行は、分類器が呼び出しを安全でないと判定したことを意味するため、呼び出しが何に到達しようとしていたか、または何をしようとしていたかから修正を選択します。
 
 * タスク全体を通じて Claude が必要とする宛先（パッケージレジストリ、内部ドメイン、リポジトリホストなど）：`autoMode.environment` に追加します。
```

</details>

<details>
<summary>checkpointing-ja.md</summary>

```diff
diff --git a/docs-ja/pages/checkpointing-ja.md b/docs-ja/pages/checkpointing-ja.md
index 9c4190a..13c072c 100644
--- a/docs-ja/pages/checkpointing-ja.md
+++ b/docs-ja/pages/checkpointing-ja.md
@@ -115,7 +115,7 @@ cp source.txt dest.txt
 </h3>
 
-[Claude が作業中にキューに入れたメッセージ](/docs/ja/interactive-mode#queue-messages-while-claude-works)が実行中のターン内に Claude に到達すると、新しいターンを開始する代わりにそのターンに参加します。メッセージは会話に表示されますが、Claude Code はそれのチェックポイントを作成しません。Claude Code が新しいターンの一部として送信するキューに入れたメッセージは、通常どおりチェックポイントを取得します。複数のキューに入れたメッセージが[そのターンを共有](/docs/ja/interactive-mode#when-claude-code-sends-what-you-queued)する場合も含まれます。
+巻き戻しメニューでは、[Claude がまだ作業中に入力した](/docs/ja/interactive-mode#queue-messages-while-claude-works)メッセージに **No code restore**（コードの復元なし）と表示されることがあります。Claude はそのメッセージをターンの終了前に読み取っています。[チェックポイントはターンを開始するプロンプトに対して作成される](#how-checkpoints-work)ため、このメッセージ自体にはチェックポイントがありません。Claude がそのメッセージを読んだ後に行った編集は、ターンを開始したプロンプトに含まれます。
 
-そのようなメッセージの後に Claude が行った編集を取り消すには、ターンを開始したプロンプトに巻き戻します。これにより、メッセージが到達する前に Claude が行った作業を含む、ターン全体が巻き戻されます。
+メッセージ自体について何かをする必要はありません。セッションのその部分でのファイル変更を取り消すには、ターンを開始したプロンプトを選択し、**Restore code**（コードを復元）または **Restore code and conversation**（コードと会話を復元）を選択します。これにより、メッセージが到達する前の編集を含め、ターン全体での Claude のファイル編集が元に戻されます。マークされたメッセージを選択した場合も **Restore conversation**（会話を復元）は利用でき、会話をそのメッセージまで巻き戻し、ファイルはそのまま残します。
 
 <h3 id="symlinked-and-hard-linked-paths-not-restored">
```

</details>

<details>
<summary>claude-apps-gateway-config-ja.md</summary>

```diff
diff --git a/docs-ja/pages/claude-apps-gateway-config-ja.md b/docs-ja/pages/claude-apps-gateway-config-ja.md
index 4410b7c..eb58671 100644
--- a/docs-ja/pages/claude-apps-gateway-config-ja.md
+++ b/docs-ja/pages/claude-apps-gateway-config-ja.md
@@ -1712,5 +1712,5 @@ CLI の場合、OS ごとの `managed-settings.json` でこれらのキーを設
 Claude Desktop の場合、Claude Desktop 独自の[マネージド設定](https://claude.com/docs/third-party/claude-desktop/configuration)で `bootstrapUrl` キーを `<listen.public_url>/user/bootstrap` に設定します。サインインフロー及びグループごとのポリシーは、ポリシーが `desktop` キーでサーバー側で opt-in した後、CLI のものと一致します。opt-in がない場合、`/user/bootstrap` は 404 を返します。[Claude Desktop オーバーレイ](#claude-desktop-overlay)でサーバー側の半分を参照してください。
 
-Claude Code は [`forceLoginGatewayUrl`](/docs/ja/settings-reference#forcelogingatewayurl)、[`gatewayInternalNetworks`](/docs/ja/settings-reference#gatewayinternalnetworks)、および [`forceLoginMethod`](/docs/ja/settings-reference#forceloginmethod) の `"gateway"` 値をマシン上のマネージドソースからのみ認識します。`managed-settings.json`、macOS plist または Windows HKLM レジストリ、またはポリシーヘルパーです。開発者が独自の `~/.claude/settings.json` でこれらを設定しても効果がなく、ゲートウェイペイロードで設定しても同様です。
+Claude Code は [`forceLoginGatewayUrl`](/docs/ja/settings-reference#forcelogingatewayurl)、[`gatewayInternalNetworks`](/docs/ja/settings-reference#gatewayinternalnetworks)、および [`forceLoginMethod`](/docs/ja/settings-reference#forceloginmethod) の `"gateway"` 値をマシン上のマネージドソースから認識します。`managed-settings.json`、macOS plist または Windows HKLM レジストリ、またはポリシーヘルパーです。ゲートウェイペイロードでこれらを設定しても、ゲートウェイのサインインは設定されません。開発者自身の `~/.claude/settings.json` については、[ユーザー設定でゲートウェイ URL を設定する](/docs/ja/claude-apps-gateway#set-the-gateway-url-in-user-settings)を参照してください。
 
 `forceLoginMethod` と `forceLoginOrgUUID` をペイロードから除外してください。Claude Code はスタートアップ認証情報チェックのためにペイロードから両方のキーを読み込みます。そのため、Anthropic が発行した認証情報をマシンに保持している開発者は、サインイン後でも[管理者ポリシーがクラウドゲートウェイサインインを必要とする](/docs/ja/errors#administrator-policy-requires-a-cloud-gateway-sign-in)の下で説明されているスタートアップ終了を取得します。
```

</details>

<details>
<summary>claude-apps-gateway-deploy-ja.md</summary>

```diff
diff --git a/docs-ja/pages/claude-apps-gateway-deploy-ja.md b/docs-ja/pages/claude-apps-gateway-deploy-ja.md
index 5f4dde6..f96925e 100644
--- a/docs-ja/pages/claude-apps-gateway-deploy-ja.md
+++ b/docs-ja/pages/claude-apps-gateway-deploy-ja.md
@@ -136,5 +136,5 @@ Google Cloud での完全な実装例（Cloud Run または GKE、Cloud SQL、Se
 </h3>
 
-ゲートウェイがサービスを提供したら、MDM を通じて、または OS ごとの `managed-settings.json` を直接書き込むことで、管理設定を通じて各開発者のマシンに `forceLoginMethod`、`forceLoginGatewayUrl`、および `parentSettingsBehavior: "merge"` をプッシュします。これなしでは、`/login` はゲートウェイオプションなしで標準アカウントピッカーを表示します。
+ゲートウェイが稼働したら、MDM を通じて、または OS ごとの `managed-settings.json` を直接書き込むことで、管理設定を通じて各開発者のマシンに `forceLoginMethod`、`forceLoginGatewayUrl`、および `parentSettingsBehavior: "merge"` をプッシュします。
 
 キーをデプロイしたら、Claude Code はマシン上の残存する API キーまたは claude.ai ログインの使用を停止するため、サインイン指示と一緒にプッシュを計画します。[Administrator policy requires a Cloud gateway sign-in](/docs/ja/errors#administrator-policy-requires-a-cloud-gateway-sign-in) は開発者が見るメッセージについて説明しています。
```

</details>

<details>
<summary>claude-apps-gateway-ja.md</summary>

```diff
diff --git a/docs-ja/pages/claude-apps-gateway-ja.md b/docs-ja/pages/claude-apps-gateway-ja.md
index ecb62b5..b677d77 100644
--- a/docs-ja/pages/claude-apps-gateway-ja.md
+++ b/docs-ja/pages/claude-apps-gateway-ja.md
@@ -264,5 +264,5 @@ Claude アプリゲートウェイは、開発者の Claude Code クライアン
 </h2>
 
-開発者は独自のラップトップから 1 つのブラウザサインインで接続し、企業の仕事用アカウントを使用します。claude.ai アカウント、API キー、またはサブスクリプションは必要ありません。モデルへのリクエストは組織のアップストリーム認証情報を使用してゲートウェイを通じて行くためです。接続は、MDM 経由でプッシュする[クライアント側管理設定](/docs/ja/claude-apps-gateway-config#client-side-managed-settings)によって駆動されるため、開発者側に手動セットアップはありません。このセクションは管理者が設定するものをカバーしています。
+開発者は独自のラップトップから 1 つのブラウザサインインで接続し、企業の仕事用アカウントを使用します。claude.ai アカウント、API キー、またはサブスクリプションは必要ありません。モデルへのリクエストは組織のアップストリーム認証情報を使用してゲートウェイを通じて行くためです。接続は、MDM 経由でプッシュする[クライアント側管理設定](/docs/ja/claude-apps-gateway-config#client-side-managed-settings)によって駆動されます。このセクションは管理者が設定するものをカバーしています。
 
 CLI はゲートウェイの TLS リーフ証明書を最初の接続時にフィンガープリントし、ホスト名ごとにピン留めします。サインイン時、サイレントセッション更新時、および管理設定フェッチ時にそのピンを再度チェックしますが、推論リクエストはピンなしで標準 TLS 検証を使用します。HTTPS プロキシを通じてルーティングされたリクエストはピンチェックをスキップするため、ゲートウェイホストを `NO_PROXY` に追加して直接接続を保つようにします。
@@ -288,5 +288,5 @@ openssl x509 -noout -fingerprint -sha256 -in cert.pem | cut -d= -f2 | tr -d : |
 </h3>
 
-MDM 経由またはディスク上で直接デプロイする OS ごとの[管理設定ファイル](/docs/ja/managed-settings#delivery-mechanisms)に 3 つのキーが入ります。`forceLoginMethod` と `forceLoginGatewayUrl` は `/login` を **Cloud gateway** 画面で URL が入力された状態で直接開き、`parentSettingsBehavior: "merge"` は Claude Desktop がゲートウェイの出力許可リストを起動する Claude Code セッションに配信できるようにします。これは[Claude Desktop セッションにポリシーを配信する](#deliver-policy-to-claude-desktop-sessions)で説明されています。
+MDM 経由またはディスク上で直接デプロイする OS ごとの[管理設定ファイル](/docs/ja/managed-settings#delivery-mechanisms)に 3 つのキーが入ります。管理設定のないマシンについては、代わりに[ユーザー設定でゲートウェイ URL を設定する](#set-the-gateway-url-in-user-settings)を参照してください。`forceLoginMethod` と `forceLoginGatewayUrl` は `/login` を **Cloud gateway** 画面で URL が入力された状態で直接開き、`parentSettingsBehavior: "merge"` は Claude Desktop がゲートウェイの出力許可リストを起動する Claude Code セッションに配信できるようにします。これは[Claude Desktop セッションにポリシーを配信する](#deliver-policy-to-claude-desktop-sessions)で説明されています。
 
 ```json theme={null}
@@ -300,5 +300,23 @@ MDM 経由またはディスク上で直接デプロイする OS ごとの[管
 開発者は Enter キーを押して接続します。[最初の接続 TLS フィンガープリントプロンプト](#connect-developers)は引き続き表示されます。ファイルがマシンに配置されると、ゲートウェイサインインを完了していない開発者は、[Administrator policy requires a Cloud gateway sign-in](/docs/ja/errors#administrator-policy-requires-a-cloud-gateway-sign-in)で説明されているメッセージの 1 つを見ます。`CLAUDE_CODE_USE_BEDROCK` などの環境変数を通じてクラウドプロバイダーを選択する開発者はゲートウェイサインインを必要としません。
 
-開発者はこれを手動で設定することはできません。ログインピッカーにはゲートウェイオプションがなく、`forceLoginGatewayUrl` は開発者独自の設定ファイルでは無視されます。URL なしの `forceLoginMethod` のみでは、開発者を「IT 管理者に連絡してください」メッセージのままにします。ログインキーは、マシンにプッシュするファイルに属し、ゲートウェイの `managed.policies[].cli` ブロックには属しません。このブロックは既に接続されているクライアントにのみ到達します。
+ログインピッカーにはゲートウェイオプションがなく、管理設定で URL なしの `forceLoginMethod` のみを設定すると、開発者は「IT 管理者に連絡してください」メッセージのままになります。ログインキーは、マシンにプッシュするファイルに属し、ゲートウェイの `managed.policies[].cli` ブロックには属しません。このブロックは既に接続されているクライアントにのみ到達します。
+
+<h4 id="set-the-gateway-url-in-user-settings">
+  ユーザー設定でゲートウェイ URL を設定する
+</h4>
+
+管理設定のないマシンでは、各開発者に `forceLoginMethod` と `forceLoginGatewayUrl` を自分のユーザー設定ファイル `~/.claude/settings.json` に追加してもらいます。これには開発者マシンで Claude Code v2.1.295 以降が必要です。この例では `claude-gateway.internal.example.com` のゲートウェイを指定しています。
+
```

</details>

<details>
<summary>cli-reference-ja.md</summary>

```diff
diff --git a/docs-ja/pages/cli-reference-ja.md b/docs-ja/pages/cli-reference-ja.md
index ca87c35..07a3fb0 100644
--- a/docs-ja/pages/cli-reference-ja.md
+++ b/docs-ja/pages/cli-reference-ja.md
@@ -29,5 +29,5 @@
 | `claude auth status` | 認証ステータスを JSON として表示します。`--text` を使用して人間が読める形式で表示できます。ログイン済みの場合はコード 0 で終了し、ログインしていない場合は 1 で終了します。JSON には、CLI が使用する [設定ディレクトリ](/docs/ja/claude-directory) の名前を付ける `configDirectory` フィールドが含まれます。このフィールドには Claude Code v2.1.268 以降が必要です。JSON の `authMethod` フィールドは、`none`、`claude.ai`、`oauth_token`、`api_key`、`api_key_helper`、または `third_party` のいずれかです | `claude auth status` |
 | `claude agents` | [エージェントビュー](/docs/ja/agent-view) を開いて、並列バックグラウンドセッションを監視およびディスパッチします。`--cwd <path>` を使用して、そのディレクトリの下で開始されたセッションのみを表示するか、`--json` を使用してアクティブなセッションを JSON 配列として出力してスクリプト作成用にします（`--json --all` は完了したバックグラウンドセッションも含みます）。`--permission-mode`、`--model`、`--effort`、または `--agent` を渡して、[ディスパッチされたセッションのデフォルト](/docs/ja/agent-view#permission-mode-model-and-effort) を設定します。トップレベルの `claude` コマンドと同様に `--settings`、`--add-dir`、`--plugin-dir`、および `--mcp-config` を受け入れます。エージェントビューを開くにはインタラクティブターミナルが必要です | `claude agents --json` |
-| `claude attach <id\|name>` | このターミナルで [バックグラウンドセッション](/docs/ja/agent-view#manage-sessions-from-the-shell) に接続します。ID の代わりにセッション名の一部を渡すには、Claude Code v2.1.290 以降が必要です | `claude attach 7c5dcf5d` |
+| `claude attach <id\|name>` | このターミナルで [バックグラウンドセッション](/docs/ja/agent-view#manage-sessions-from-the-shell) に接続します。ID の代わりに実行中のセッション名の一部を渡すには、Claude Code v2.1.290 以降が必要です | `claude attach 7c5dcf5d` |
 | `claude auto-mode defaults` | 組み込み [auto モード](/docs/ja/permission-modes#eliminate-prompts-with-auto-mode) 分類器ルールを JSON として出力します。`claude auto-mode config` を使用して、設定が適用された有効な設定を確認してください。`--label <prefix>` は、ラベルがそのプレフィックスで始まるルールのみを出力します。大文字と小文字を区別しません。Claude Code v2.1.208 以降が必要です | `claude auto-mode defaults --label 'Git Destructive'` |
 | `claude auto-mode reset` | ユーザー設定ファイルから `autoMode` セクションを削除して、デフォルト [auto モード](/docs/ja/permission-modes#eliminate-prompts-with-auto-mode) 設定を復元します。書き込み前に確認を求めます。`-y`/`--yes` を渡してプロンプトをスキップします。[管理設定](/docs/ja/server-managed-settings) または `--settings` フラグからのルールは引き続き適用されます。Claude Code v2.1.212 以降が必要です。[デフォルトと有効な設定を検査](/docs/ja/auto-mode-config#inspect-the-defaults-and-your-effective-config) を参照してください | `claude auto-mode reset --yes` |
@@ -69,5 +69,5 @@
 | `--agents` | JSON を使用してカスタムサブエージェントを動的に定義します。[CLI で定義されたサブエージェントのリストされたフィールド](/docs/ja/sub-agents#choose-the-subagent-scope)を受け入れます。`--print` を使用する場合、値は代わりに JSON オブジェクトを保持するファイルへのパスになります。ファイル形式には Claude Code v2.1.281 以降が必要です。Claude Code は起動時に値を検証し、無効な値で終了します。メッセージについては [`Invalid --agents configuration`](/docs/ja/errors#invalid-agents-configuration) を参照してください。また、検証をスキップするフラグと環境変数についても参照してください。検証には Claude Code v2.1.242 以降が必要です | `claude --agents '{"reviewer":{"description":"Reviews code","prompt":"You are a code reviewer"}}'` |
 | `--allow-dangerously-skip-permissions` | `Shift+Tab` モードサイクルに `bypassPermissions` を追加します。ただし、それで開始しません。`plan` などの別のモードで開始し、後で `bypassPermissions` に切り替えることができます。[権限モード](/docs/ja/permission-modes#skip-all-checks-with-bypasspermissions-mode)を参照してください | `claude --permission-mode plan --allow-dangerously-skip-permissions` |
-| `--allowedTools`, `--allowed-tools` | 権限を求めずに実行するツール。パターンマッチングについては[権限ルール構文](/docs/ja/settings-reference#permission-rule-syntax)を参照してください。利用可能なツールを制限するには、代わりに `--tools` を使用してください。[タスク追跡ツール](/docs/ja/tools-reference#task-tool-availability)の 1 つをここで名前を付けた場合、Claude Code もセッションをオプトインします | `"Bash(git log *)" "Bash(git diff *)" "Read"` |
+| `--allowedTools`, `--allowed-tools` | 権限を求めずに実行するツール。ただし、[ネットワークパス](/docs/ja/permissions#network-paths)からの読み取りは除きます。パターンマッチングについては[権限ルール構文](/docs/ja/settings-reference#permission-rule-syntax)を参照してください。利用可能なツールを制限するには、代わりに `--tools` を使用してください。[タスク追跡ツール](/docs/ja/tools-reference#task-tool-availability)の 1 つをここで名前を付けた場合、Claude Code もセッションをオプトインします | `"Bash(git log *)" "Bash(git diff *)" "Read"` |
 | `--append-subagent-system-prompt` | すべての[サブエージェント](/docs/ja/sub-agents)のシステムプロンプトの末尾にカスタムテキストを追加します。ネストされたサブエージェントを含みますが、[フォークされたサブエージェント](/docs/ja/sub-agents#fork-the-current-conversation)は除きます。フォークされたサブエージェントは会話独自のプロンプトを再利用します。`-p` を使用した非対話モードでのみ適用されます。Claude Code v2.1.205 以降が必要です | `claude -p --append-subagent-system-prompt "Cite file paths in every answer" "query"` |
 | `--append-subagent-system-prompt-file` | ファイルからテキストを読み込み、[サブエージェント](/docs/ja/sub-agents)システムプロンプトに追加します。コマンドラインで渡すには長すぎるテキストの場合、`--append-subagent-system-prompt` の代替です。2 つのフラグを組み合わせることはできません。`-p` を使用した非対話モードでのみ適用されます。Claude Code v2.1.261 以降が必要です | `claude -p --append-subagent-system-prompt-file ./subagent-rules.txt "query"` |
@@ -82,5 +82,5 @@
 | `--chrome` | [Chrome ブラウザ統合](/docs/ja/chrome)を有効にして、Web 自動化とテストを行います | `claude --chrome` |
 | `--cloud` | タスク説明を使用して、新しい[クラウドセッション](/docs/ja/claude-code-on-the-web)を作成します。セッション ID（`session_...` または `cse_...`）または claude.ai/code URL を使用して、`-p` でそのセッションに代わりにメッセージをキューに入れます。[フォローアップメッセージを送信](/docs/ja/claude-code-on-the-web#send-follow-ups-from-the-cli)を参照してください。 | `claude --cloud "Fix the login bug"` |
-| `--continue`, `-c` | 現在のディレクトリで最新の会話を読み込みます。[終了したバックグラウンドセッション](/docs/ja/sessions#resume-a-session)を含みます。終了したバックグラウンドセッションを開くには Claude Code v2.1.257 以降が必要です。`claude -p` またはエージェント SDK で作成されたセッション、および最初のプロンプトが `/loop` だったセッションをスキップします。`claude -p --continue` には `-p`、SDK、`/loop` セッションが含まれます。このディレクトリを `/add-dir` で追加したセッションを含みます | `claude --continue` |
+| `--continue`, `-c` | 現在のディレクトリで最新の会話を読み込みます。[終了したバックグラウンドセッション](/docs/ja/sessions#where-the-session-picker-looks)を含みます。終了したバックグラウンドセッションを開くには Claude Code v2.1.257 以降が必要です。`claude -p` または Agent SDK で作成されたセッション、および最初のプロンプトが `/loop` だったセッションをスキップします。`claude -p --continue` には `-p`、SDK、`/loop` セッションが含まれます。このディレクトリを `/add-dir` で追加したセッションを含みます | `claude --continue` |
 | `--dangerously-load-development-channels` | 承認済みの許可リストにない[チャネル](/docs/ja/channels-reference#test-during-the-research-preview)を有効にして、ローカル開発を行います。`plugin:<name>@<marketplace>` および `server:<name>` エントリを受け入れます。確認を求めるため、対話セッションで有効になります。`-p` を使用すると、Claude Code はこのフラグを無視します | `claude --dangerously-load-development-channels server:webhook` |
 | `--dangerously-skip-permissions` | 権限プロンプトをスキップします。`--permission-mode bypassPermissions` と同等です。[権限モード](/docs/ja/permission-modes#skip-all-checks-with-bypasspermissions-mode)でこれが何をスキップし、何をスキップしないかを参照してください。`--bg` で開始されたセッションの場合、モードは[スーパーバイザーがセッションを再開するときに保持](/docs/ja/agent-view#permission-mode-model-and-effort)されます | `claude --dangerously-skip-permissions` |
@@ -111,9 +111,9 @@
 | `--mcp-config` | JSON ファイルまたは文字列から MCP サーバーを読み込みます（スペース区切り）。このフラグを `-p` で渡すと、Claude Code は最初のターンを実行する前に、まだ保留中のサーバーが接続されるまで待機します。デフォルトでは [`MCP_TIMEOUT`](/docs/ja/env-vars) スタートアップタイムアウト 30 秒まで待機します。[キャッシュされたツールリスト](/docs/ja/mcp#managing-your-servers)を持つサーバーは待機をスキップし、最初の使用時に接続します。[自己ホスト環境](/docs/ja/self-hosted-environments-configuration#connection-timing)では、代わりにより短い待機時間が適用されます。待機には Claude Code v2.1.221 以降が必要です | `claude --mcp-config ./mcp.json` |
 | `--model` | `sonnet`、`opus`、`haiku`、`fable` などの[モデルエイリアス](/docs/ja/model-config#model-aliases)またはモデルの完全な名前を使用して、現在のセッションのモデルを設定します。[`model`](/docs/ja/settings-reference#model) 設定と [`ANTHROPIC_MODEL`](/docs/ja/model-config#environment-variables) をオーバーライドします | `claude --model claude-sonnet-5` |
-| `--name`, `-n` | セッションの表示名を設定します。`/resume` とターミナルタイトルに表示されます。`claude --resume <name>` で名前付きセッションを再開できます。対話型セッションで、このマシン上の別のライブセッションが既に名前を使用している場合、Claude Code は[その変種を適用](/docs/ja/sessions#name-your-sessions)します。<br /><br />[`/rename`](/docs/ja/commands)はセッション中に名前を変更し、プロンプトバーにも表示します | `claude -n "my-feature-work"` |
+| `--name`, `-n` | セッションの表示名を設定します。`/resume` とターミナルタイトルに表示されます。`claude --resume <name>` で名前付きセッションを再開できます。<br /><br />[`/rename`](/docs/ja/commands)はセッション中に名前を変更し、プロンプトバーにも表示します | `claude -n "my-feature-work"` |
```

</details>

*...以降省略*

</details>


<details>
<summary>2026-10-10</summary>

**変更ファイル:**

```
 docs-ja/pages/agent-view-ja.md                     |  31 +-
 docs-ja/pages/changelog.md                         |  82 +++
 docs-ja/pages/chrome-ja.md                         |  48 +-
 docs-ja/pages/claude-apps-gateway-config-ja.md     |  88 ++-
 docs-ja/pages/claude-apps-gateway-deploy-ja.md     |   2 +-
 docs-ja/pages/claude-apps-gateway-ja.md            |  16 +-
 docs-ja/pages/claude-apps-gateway-on-aws-ja.md     |   2 +-
 docs-ja/pages/claude-code-on-the-web-ja.md         |  14 +-
 docs-ja/pages/claude-projects-ja.md                |  16 +-
 docs-ja/pages/cli-reference-ja.md                  |   8 +-
 docs-ja/pages/cloud-environments-ja.md             |   2 +-
 docs-ja/pages/commands-ja.md                       |   2 +-
 docs-ja/pages/env-vars-ja.md                       | 612 ++++++++++----------
 docs-ja/pages/errors-ja.md                         | 630 ++++++++++-----------
 docs-ja/pages/glossary-ja.md                       |   2 +-
 docs-ja/pages/goal-ja.md                           |   2 +-
 docs-ja/pages/headless-ja.md                       | 141 +++--
 docs-ja/pages/hipaa-setup-ja.md                    |   3 +
 docs-ja/pages/hooks-guide-ja.md                    |  25 +-
 docs-ja/pages/hooks-ja.md                          | 132 ++++-
 docs-ja/pages/interactive-mode-ja.md               |  11 +-
 docs-ja/pages/jetbrains-ja.md                      |  12 +-
 docs-ja/pages/managed-settings-ja.md               |  90 +--
 docs-ja/pages/mcp-ja.md                            |  28 +-
 docs-ja/pages/monitoring-usage-ja.md               |  28 +-
 docs-ja/pages/remote-control-ja.md                 |  75 ++-
 docs-ja/pages/scheduled-tasks-ja.md                |  25 +-
 docs-ja/pages/security-guidance-ja.md              |  18 +-
 .../self-hosted-environments-configuration-ja.md   | 152 ++++-
 .../pages/self-hosted-environments-deploy-ja.md    | 189 +++++--
 .../pages/self-hosted-environments-identity-ja.md  |   4 +-
 docs-ja/pages/self-hosted-environments-ja.md       |   8 +-
 .../self-hosted-environments-quickstart-ja.md      |  52 +-
 .../pages/self-hosted-environments-reference-ja.md |  32 +-
 .../pages/self-hosted-environments-testing-ja.md   |  32 +-
 docs-ja/pages/setup-ja.md                          |  30 +-
 docs-ja/pages/skills-ja.md                         |   2 +-
 docs-ja/pages/sub-agents-ja.md                     |   2 +-
 docs-ja/pages/troubleshoot-install-ja.md           | 236 ++++++--
 docs-ja/pages/troubleshooting-ja.md                |   2 +-
 docs-ja/pages/vs-code-ja.md                        |   4 +-
 41 files changed, 1866 insertions(+), 1024 deletions(-)
```

<details>
<summary>agent-view-ja.md</summary>

```diff
diff --git a/docs-ja/pages/agent-view-ja.md b/docs-ja/pages/agent-view-ja.md
index 4302f8e..16b716c 100644
--- a/docs-ja/pages/agent-view-ja.md
+++ b/docs-ja/pages/agent-view-ja.md
@@ -392,6 +392,8 @@ Claude Code v2.1.212 以降でセッションを戻すには、ディスパッ
 エージェントビューから新しいバックグラウンドセッションをディスパッチしたり、既存のインタラクティブセッションをバックグラウンドに送信またはコピーしたり、シェルから直接開始したりできます。
 
-<h3 id="from-agent-view">
-  エージェントビューから
+<span id="from-agent-view" />
+
+<h3 id="dispatch-an-agent-from-agent-view">
+  エージェントビューからエージェントをディスパッチする
 </h3>
 
@@ -447,6 +449,8 @@ Claude Code v2.1.212 以降でセッションを戻すには、ディスパッ
 エージェントビューがディレクトリでグループ化されている場合、ディスパッチは選択した行のディレクトリにプロンプトを送信するため、パスを再入力することなくグループを選択してそこにディスパッチできます。
 
-<h3 id="from-inside-a-session">
-  セッション内から
+<span id="from-inside-a-session" />
+
+<h3 id="send-or-copy-a-session-to-the-background">
+  セッションをバックグラウンドに送信またはコピーする
 </h3>
 
@@ -512,6 +516,8 @@ Claude Code は、実行中の [モニター](/docs/ja/tools-reference#monitor-t
 セッション中に [`/add-dir`](/docs/ja/permissions#additional-directories-grant-file-access-not-configuration) で追加したディレクトリも引き継がれます。`--allow-dangerously-skip-permissions` を引き継ぐと、バックグラウンド化されたセッションでも `bypassPermissions` に切り替えられる状態が維持されますが、新たに何かを付与するわけではありません。このモードには引き続き、[権限モード、モデル、effort](#permission-mode-model-and-effort) で説明されている 1 回限りのインタラクティブな同意が必要です。
 
-<h3 id="from-your-shell">
```

</details>

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index bf5498e..e0d7e4b 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,86 @@
 # Changelog
 
+## 2.1.296
+
+- Added a `code` key to the Claude apps gateway's `managed.policies[]`: the same settings as `cli`, also applied in Claude Desktop's Code tab; beside `desktop`, it turns on Claude Desktop's gateway mode
+- Added `autoCompactWindow` to subagent frontmatter and `--agents` definitions, so a subagent can auto-compact earlier than the main conversation's window
+- Added `CLAUDE_CODE_WORKFLOW_SUBAGENT_MODEL` to run every workflow agent on one model while other subagents keep theirs
+- Added `CLAUDE_CODE_OVERLOADED_RETRY_MAX_DELAY_MS` environment variable to set a longer maximum delay for the backoff when retrying an overloaded (529) request
+- Added a note in `/plugin` on a plugin whose hooks are left out because another enabled plugin has the same name
+- Added an `allow_large` option to the Read tool so Claude can read a text file past the usual size limits in one call when it needs the whole file and the context has room
+- Fixed managed-settings `PreToolUse` hooks that deny a tool call with `"continue": false`, and managed `prompt` hooks that block one, refusing the call but not ending the turn
+- Fixed PostToolUse hooks in managed settings not applying `updatedMCPToolOutput` in some sessions
+- Fixed headless sessions starting a folder's `.mcp.json` or plugin MCP server that was switched off for that folder, after changing directory or reloading plugins
+- Fixed a Claude apps gateway that serves `allowedProviders` with `"gateway"` locking out laptops that name that gateway in user settings
+- Fixed a saved Claude apps gateway sign-in being ignored on machines whose managed settings set `forceLoginMethod` to `gateway` with no `forceLoginGatewayUrl` (regression in 2.1.295)
+- Fixed `--teleport` opening an empty conversation when the session's history could not be read
+- Fixed token counts for Haiku 5.5 and other models that take only adaptive thinking, which failed behind some gateways and were counted with budget thinking elsewhere
+- Fixed resumed subagents being told that the user rejected a tool call that a session shutdown had interrupted
+- Fixed hook output being altered when it contained text resembling a plugin hint tag
+- Fixed secret redaction in shared transcripts and debug logs missing some values that follow a key with no value, including in JSON written inside a shell string
+- Fixed a stray `52;c;…` escape sequence printed on screen after copying in older VTE-based terminals such as MATE Terminal
+- Fixed toasts and notifications waiting unseen for as long as the `/diff` panel or dialog was open
+- Fixed Esc or an interrupt during a `UserPromptSubmit` hook or a mod's `prompt.submit` hook ending headless sessions, clearing the typed prompt, or letting the unchecked prompt through
+- Fixed SessionStart hooks of a plugin loaded after a headless session starts being skipped when a different plugin with the same name, or another spelling of it, had already run
+- Fixed `claude self-hosted-runner` printing misleading errors when registration is refused: it now names the org admin setting, or says a restarted on-demand runner needs a fresh work order
```

</details>

<details>
<summary>chrome-ja.md</summary>

```diff
diff --git a/docs-ja/pages/chrome-ja.md b/docs-ja/pages/chrome-ja.md
index 343adcf..ab6190b 100644
--- a/docs-ja/pages/chrome-ja.md
+++ b/docs-ja/pages/chrome-ja.md
@@ -130,8 +130,7 @@ Chrome が実行されていない場合でも、Claude Code は通常どおり
 </h3>
 
-VS Code セッションでは、ブラウザアクションの前に Claude Code が確認するかどうかは、セッションがブラウザに接続した方法によって異なります。
+VS Code セッションでは、ブラウザアクションの前に Claude Code が確認する場合、プロンプトはチャットパネルにカードとして表示されます。アクションの対象が許可していないサイトである場合、カードにはそのサイトを許可するオプションも表示されます。
 
-* **`@browser` と入力した場合**: Claude Code が通常であれば確認するブラウザアクションを、拡張機能がそれぞれ承認します。
-* **[デフォルトで有効](#enable-chrome-by-default)設定によって開始時に接続された場合**: そのセッションで `@browser` と入力するまで、Claude Code は Manual、Edit automatically、Auto、Bypass permissions の各モードで、許可していないサイトでのブラウザアクションの前に確認します。
+[デフォルトで有効](#enable-chrome-by-default)がオンになっているために開始時にブラウザに接続したセッションでは、Claude Code は Manual、Edit automatically、Auto、Bypass permissions の各モードで、許可していないサイトでのブラウザアクションの前に確認します。Auto モードと Bypass permissions モードでは、これはそのセッションで `@browser` と入力するまで適用されます。
 
 <h3 id="browser-tools-in-plan-mode">
@@ -139,5 +138,5 @@ VS Code セッションでは、ブラウザアクションの前に Claude Code
 </h3>
 
-[plan モード](/docs/ja/permission-modes#analyze-before-you-edit-with-plan-mode)では、Claude が GIF を記録する、新しいタブを開く、またはショートカットを実行する前に権限プロンプトが表示されます。ただし、[`@browser`](#permission-prompts-in-vs-code-sessions) と入力した VS Code セッションは除きます。対話型 CLI セッションでは、[bypassPermissions モードが利用可能](/docs/ja/permission-modes#skip-all-checks-with-bypasspermissions-mode)で、かつ[機能フラグの取得](/docs/ja/env-vars#features-that-need-feature-flag-fetching)がオフの場合、これらの呼び出しはプロンプトなしで実行されます。
+[plan モード](/docs/ja/permission-modes#analyze-before-you-edit-with-plan-mode)では、Claude が GIF を記録する、新しいタブを開く、またはショートカットを実行する前に権限プロンプトが表示されます。対話型 CLI セッションでは、[bypassPermissions モードが利用可能](/docs/ja/permission-modes#skip-all-checks-with-bypasspermissions-mode)で、かつ[機能フラグの取得](/docs/ja/env-vars#features-that-need-feature-flag-fetching)がオフの場合、これらの呼び出しはプロンプトなしで実行されます。
 
 `createIfEmpty` を設定する `tabs_context_mcp` 呼び出しや、これらのアクションのいずれかを含む `browser_batch` 呼び出しでもプロンプトが表示されます。
@@ -203,9 +202,10 @@ and attach logs/session.log to it
 ```
 
-アップロードには次の 3 つの制限が適用されます。
+Claude がファイルの添付を拒否した場合やアップロードが失敗した場合は、次の原因を確認してください。
 
 * **権限**: Claude がファイルをアップロードできるのは、セッションがそのファイルの読み取りを許可されている場合のみです。そのため、ファイルへの `Read` アクセスを拒否する[権限ルール](/docs/ja/settings-reference#permission-settings)は、そのファイルのアップロードもブロックします。
 * **サイズ**: 1 回のアップロードに含められるファイルは合計 10 MB までです。
```

</details>

<details>
<summary>claude-apps-gateway-config-ja.md</summary>

```diff
diff --git a/docs-ja/pages/claude-apps-gateway-config-ja.md b/docs-ja/pages/claude-apps-gateway-config-ja.md
index ef45f6b..4410b7c 100644
--- a/docs-ja/pages/claude-apps-gateway-config-ja.md
+++ b/docs-ja/pages/claude-apps-gateway-config-ja.md
@@ -969,9 +969,42 @@ v2.1.232 より前では、ゲートウェイはこれらの値で起動しま
 * `groups` または `admin_groups` の空のエントリ：そのユーザーの IdP `groups` クレームにも空のエントリが含まれている場合にのみ、エントリはユーザーにマッチしました。`admin_groups` では、そのマッチにより管理者アクセスが付与されました。`admin_groups` リストに空のエントリが一度も含まれていなかった場合、この方法で管理者アクセスを得た人はいません。
 
+<h4 id="choose-cli-or-code">
+  `cli` と `code` のどちらを選ぶか
+</h4>
+
+<Warning>
+  ポリシーで `code` キーを使用する場合、次のいずれかによってゲートウェイが起動しなくなります。
+
+  * **ゲートウェイのバージョン**: `code` には、ゲートウェイサーバー上の Claude Code v2.1.296 以降が必要です。それより前のゲートウェイは、このキーを見つけると起動を拒否します。キーを追加する前にすべてのレプリカをアップグレードし、以前のバージョンにロールバックする前に `code` を `cli` に戻してください。
+  * **キーの混在**: `code` と `cli`（またはその以前の表記である `settings`）の両方を含むファイルは、起動時にゲートウェイを停止させます。1 回の編集で、すべてのブロックを 1 つのキーの下に置いてください。
+</Warning>
+
+`.env` ファイルの読み取りを拒否するルールなど、ポリシーの Claude Code の設定は、`cli` または `code` キーの下のブロックに記述します。`code` が推奨されるキーで、`cli` は従来のキーです。どちらのキーも同じ内容を受け付けます。キーによって、設定が適用される場所が決まります。
+
+* **`cli`**: ターミナル、VS Code と JetBrains の拡張機能、Agent SDK。`cli` の下では、Claude Desktop の Code タブには [派生した設定](#claude-desktop-overlay) が適用されるため、`Read(./.env)` のようなスコープ付きルールはそこでのユーザーの操作を止めません。
+* **`code`**: 同じ場所に加え、Claude Desktop の Code タブもカバーできます。
+
+`cli` を使用するファイルは従来どおり動作し、[`desktop`](#claude-desktop-overlay) キーを持つポリシーで `cli` を検出したゲートウェイは、起動時に警告を出しますが起動は続行します。設定が Code タブにも適用されるように、`code` に切り替えてください。
+
+切り替える前に、[Code タブで `code` 設定を適用する](#apply-code-settings-in-the-code-tab) をお読みください。設定がそこで適用されるには、ポリシーに `desktop` キーが必要で、ユーザーのマシンでのセットアップも必要です。また、Claude Desktop では Web 検索がオフになります。
+
+次のポリシーは、拒否ルールを `code` の下に置き、空の `desktop` キーを持っています。
+
+```yaml theme={null}
```

</details>

<details>
<summary>claude-apps-gateway-deploy-ja.md</summary>

```diff
diff --git a/docs-ja/pages/claude-apps-gateway-deploy-ja.md b/docs-ja/pages/claude-apps-gateway-deploy-ja.md
index 03bbceb..5f4dde6 100644
--- a/docs-ja/pages/claude-apps-gateway-deploy-ja.md
+++ b/docs-ja/pages/claude-apps-gateway-deploy-ja.md
@@ -385,5 +385,5 @@ Claude Code は、プラグインマーケットプレイスをゲートウェ
 * **環境変数**：管理設定の [`env` ブロック](/docs/ja/plugins/org#turn-updates-off-for-the-whole-fleet) で `CLAUDE_CODE_DISABLE_OFFICIAL_MARKETPLACE_AUTOINSTALL` を `"1"` に設定
 
-最初の登録は、開発者がゲートウェイにサインインする前、つまりゲートウェイポリシーがまだ届いていない時点で実行される場合があります。この最初の起動にも対応するには、ゲートウェイポリシーの [`cli` ブロック](/docs/ja/claude-apps-gateway-config#what-goes-in-cli) に加えて、[クライアント側管理設定](/docs/ja/claude-apps-gateway-config#client-side-managed-settings) でも選択した設定を配信してください。
+最初の登録は、開発者がゲートウェイにサインインする前、つまりゲートウェイポリシーがまだ届いていない時点で実行される場合があります。この最初の起動にも対応するには、ゲートウェイポリシーの [`cli` または `code` ブロック](/docs/ja/claude-apps-gateway-config#what-goes-in-cli) に加えて、[クライアント側管理設定](/docs/ja/claude-apps-gateway-config#client-side-managed-settings) でも選択した設定を配信してください。
 
 <h2 id="troubleshooting">
```

</details>

<details>
<summary>claude-apps-gateway-ja.md</summary>

```diff
diff --git a/docs-ja/pages/claude-apps-gateway-ja.md b/docs-ja/pages/claude-apps-gateway-ja.md
index f367883..ecb62b5 100644
--- a/docs-ja/pages/claude-apps-gateway-ja.md
+++ b/docs-ja/pages/claude-apps-gateway-ja.md
@@ -256,5 +256,5 @@ Claude アプリゲートウェイは、開発者の Claude Code クライアン
 
   <Step title="開発者をログインさせる">
-    この最後のステップはサーバーではなく開発者マシンで発生します。そのマシンの[管理設定ファイル](/docs/ja/managed-settings#delivery-mechanisms)で `forceLoginMethod` を `"gateway"` に、`forceLoginGatewayUrl` をゲートウェイの `public_url` に設定し、`/login` を実行し、**Cloud gateway** 画面で Enter キーを押し、ブラウザサインインを完了します。以下の[ゲートウェイ URL を設定](#set-the-gateway-url)では、両方のキーをすべての開発者マシンに配布する方法を説明しています。
+    この最後のステップはサーバーではなく開発者マシンで発生します。そのマシンの[管理設定ファイル](/docs/ja/managed-settings#delivery-mechanisms)で `forceLoginMethod` を `"gateway"` に、`forceLoginGatewayUrl` をゲートウェイの `public_url` に、`parentSettingsBehavior` を `"merge"` に設定し、`/login` を実行し、**Cloud gateway** 画面で Enter キーを押し、ブラウザサインインを完了します。以下の[ゲートウェイ URL を設定](#set-the-gateway-url)では、3 つのキーと、それらをすべての開発者マシンに配布する方法を説明しています。
   </Step>
 </Steps>
@@ -351,7 +351,7 @@ Claude Code はゲートウェイに接続する前に `/login` でリストを
 </h3>
 
-Claude Desktop は Cowork タブと Code タブ、および有効にした場合は Chat タブを、埋め込み Claude Code セッションで実行し、それらのモデルリクエストをゲートウェイを通じて送信します。ゲートウェイが `/user/bootstrap` で提供する設定から構築されたポリシーを各セッションに渡します。モデル許可リスト、無効化されたツール、および一致したポリシーの `cli` ブロックから派生した出力許可リスト、および[`desktop` オーバーレイ](/docs/ja/claude-apps-gateway-config#claude-desktop-overlay)です。
+Claude Desktop は Cowork タブと Code タブ、および有効にした場合は Chat タブを、埋め込み Claude Code セッションで実行し、それらのモデルリクエストをゲートウェイを通じて送信します。ゲートウェイが `/user/bootstrap` で提供する設定から構築されたポリシーを各セッションに渡します。モデル許可リスト、無効化されたツール、および一致したポリシーの `cli` または `code` ブロックから派生した出力許可リスト、および[`desktop` オーバーレイ](/docs/ja/claude-apps-gateway-config#claude-desktop-overlay)です。
 
-フック、`env`、および `Bash(npm *)` のようなスコープ付き権限ルールなどの他の `cli` キーは、`/login` を通じてサインインするクライアントにのみ到達します。Claude Desktop はゲートウェイ URL を独自の管理設定から読み取り、[ゲートウェイ URL を設定する](#set-the-gateway-url)の `forceLoginMethod` と `forceLoginGatewayUrl` キーとは別の独自のフローでサインインします。
+フック、`env`、および `Bash(npm *)` のようなスコープ付き権限ルールなど、ブロックの他のキーは、`/login` を通じてサインインするクライアントに到達します。`code` の下にある場合、[Code タブの条件](/docs/ja/claude-apps-gateway-config#apply-code-settings-in-the-code-tab)が満たされていれば、Code タブのセッションにも到達します。Cowork セッションや Chat セッションには到達しません。Claude Desktop はゲートウェイ URL を独自の管理設定から読み取り、[ゲートウェイ URL を設定する](#set-the-gateway-url)の `forceLoginMethod` と `forceLoginGatewayUrl` キーとは別の独自のフローでサインインします。
 
 起動プロセスによって渡される設定は親設定です。Claude Code は、管理者がデプロイした管理ソースを持つマシンで親設定を無視します。ただし、[ポリシーを配信するソース](/docs/ja/managed-settings#which-managed-source-claude-code-uses)が `parentSettingsBehavior: "merge"` を設定する場合を除きます。
@@ -381,9 +381,13 @@ Claude Desktop のみを実行するマシンはそれを必要とします。Cl
 
   <Step title="ファイルを上回るソースにスニペットをミラーリングする">
-    Claude Code は `parentSettingsBehavior` を[選択されたソース](/docs/ja/managed-settings#which-managed-source-claude-code-uses)からのみ読み取ります。ソースにポリシーキーを追加すると、そのソースが選択されたものになる可能性があるため、クライアント側ソースでは `parentSettingsBehavior` のみではなくスニペット全体をミラーリングします。[クライアント側管理設定](/docs/ja/claude-apps-gateway-config#client-side-managed-settings)は Group Policy または設定プロファイルを通じてポリシーを配信するフリートをカバーしています。macOS の管理設定プリストまたは Windows の HKLM ポリシーは `managed-settings.json` ファイルを上回り、ゲートウェイ独自のリモート管理設定は両方を上回るため、ゲートウェイにサインインするマシンでは、ゲートウェイポリシーの [`cli` ブロック](/docs/ja/claude-apps-gateway-config#managed)にも `parentSettingsBehavior` を設定します。
+    Claude Code は `parentSettingsBehavior` を[選択されたソース](/docs/ja/managed-settings#which-managed-source-claude-code-uses)からのみ読み取ります。ソースにポリシーキーを追加すると、そのソースが選択されたものになる可能性があるため、クライアント側ソースでは `parentSettingsBehavior` のみではなくスニペット全体をミラーリングします。[クライアント側管理設定](/docs/ja/claude-apps-gateway-config#client-side-managed-settings)は Group Policy または設定プロファイルを通じてポリシーを配信するフリートをカバーしています。macOS の管理設定プリストまたは Windows の HKLM ポリシーは `managed-settings.json` ファイルを上回り、ゲートウェイ独自のリモート管理設定は両方を上回るため、ゲートウェイにサインインするマシンでは、ゲートウェイポリシーの [`cli` または `code` ブロック](/docs/ja/claude-apps-gateway-config#managed)にも `parentSettingsBehavior` を設定します。
   </Step>
 
   <Step title="どのソースが選択されているかを確認する">
-    Claude Desktop のみを実行するマシンで、Agent SDK の [`resolveSettings()`](/docs/ja/agent-sdk/typescript#resolvesettings) を呼び出し、その `sources` リストの `managed` エントリで `policyOrigin` を読み取ります。値は選択されたクライアント側ソース `plist`、`hklm`、または `file` に名前を付けます。これはスニペットを含む必要があるソースです。Claude Desktop の埋め込みセッションはゲートウェイポリシーをフェッチしないため、ゲートウェイの `cli` ブロックは選択されたソースとしてカウントされません。
```

</details>

*...以降省略*

</details>


<details>
<summary>2026-10-09</summary>

**変更ファイル:**

```
 docs-ja/pages/agent-view-ja.md                     |    8 +-
 docs-ja/pages/amazon-bedrock-ja.md                 |   61 +-
 docs-ja/pages/artifacts-ja.md                      |   48 +-
 docs-ja/pages/authentication-ja.md                 |    2 -
 docs-ja/pages/changelog.md                         |  151 +++
 docs-ja/pages/claude-apps-gateway-config-ja.md     |    2 +-
 docs-ja/pages/claude-apps-gateway-deploy-ja.md     |   29 +-
 docs-ja/pages/claude-apps-gateway-ja.md            |   47 +-
 docs-ja/pages/claude-apps-gateway-on-aws-ja.md     |    2 +-
 docs-ja/pages/claude-code-on-the-web-ja.md         |    6 +-
 docs-ja/pages/claude-platform-on-aws-ja.md         |   11 +-
 docs-ja/pages/claude-projects-ja.md                |    2 +-
 docs-ja/pages/cli-reference-ja.md                  |    2 +-
 docs-ja/pages/cloud-environments-ja.md             |    6 +-
 docs-ja/pages/commands-ja.md                       |    2 +-
 docs-ja/pages/common-workflows-ja.md               |    3 +-
 docs-ja/pages/context-window-ja.md                 |    2 -
 docs-ja/pages/debug-your-config-ja.md              |   13 +-
 docs-ja/pages/desktop-ja.md                        |   14 +-
 docs-ja/pages/env-vars-ja.md                       |  632 +++++------
 docs-ja/pages/errors-ja.md                         |  199 ++--
 docs-ja/pages/feature-availability-ja.md           |    4 +-
 docs-ja/pages/glossary-ja.md                       |    4 +-
 docs-ja/pages/google-vertex-ai-ja.md               |    6 +-
 docs-ja/pages/headless-ja.md                       |   13 +-
 docs-ja/pages/hooks-ja.md                          | 1094 ++++++++++++--------
 docs-ja/pages/managed-settings-ja.md               |    6 +-
 docs-ja/pages/mcp-ja.md                            |   38 +-
 docs-ja/pages/memory-ja.md                         |    8 +-
 docs-ja/pages/microsoft-foundry-ja.md              |   56 +-
 docs-ja/pages/model-config-ja.md                   |   83 +-
 docs-ja/pages/monitoring-usage-ja.md               |    6 +-
 docs-ja/pages/network-config-ja.md                 |    2 +-
 docs-ja/pages/output-styles-ja.md                  |    4 +-
 docs-ja/pages/overview-ja.md                       |    2 +-
 docs-ja/pages/permissions-ja.md                    |    2 +-
 docs-ja/pages/plugin-evals-ja.md                   |   31 +-
 docs-ja/pages/quickstart-ja.md                     |   30 +-
 docs-ja/pages/sandbox-environments-ja.md           |    6 +-
 docs-ja/pages/sandboxing-ja.md                     |    2 +-
 .../self-hosted-environments-configuration-ja.md   |   19 +-
 docs-ja/pages/server-managed-settings-ja.md        |   11 +-
 docs-ja/pages/settings-ja.md                       |   70 +-
 docs-ja/pages/settings-reference-ja.md             |    8 +-
 docs-ja/pages/setup-ja.md                          |   20 +-
 docs-ja/pages/skills-ja.md                         |   17 +
 docs-ja/pages/statusline-ja.md                     |   90 +-
 docs-ja/pages/sub-agents-ja.md                     |   16 +-
 docs-ja/pages/tools-reference-ja.md                |   28 +-
 docs-ja/pages/ultrareview-ja.md                    |   12 +-
 docs-ja/pages/vs-code-ja.md                        |    2 +-
 docs-ja/pages/web-quickstart-ja.md                 |    2 +-
 docs-ja/pages/workflows-ja.md                      |   28 +-
 docs-ja/pages/worktrees-ja.md                      |    2 +-
 54 files changed, 1815 insertions(+), 1149 deletions(-)
```

<details>
<summary>agent-view-ja.md</summary>

```diff
diff --git a/docs-ja/pages/agent-view-ja.md b/docs-ja/pages/agent-view-ja.md
index 9ad0030..4302f8e 100644
--- a/docs-ja/pages/agent-view-ja.md
+++ b/docs-ja/pages/agent-view-ja.md
@@ -239,5 +239,5 @@ Completed
 [`PermissionRequest`](/docs/ja/hooks#permissionrequest) または [`PreToolUse`](/docs/ja/hooks#pretooluse) フックが、セッションが尋ねている呼び出しについて Claude Code が検証できない出力を返した場合、行には保留中のリクエストのテキストの前に、フックイベントと `hook output invalid:` および検証エラーが表示されます。別の形で失敗したフックの場合、行にはフックが失敗したことが表示されます。セッションは引き続き同じリクエストで待機します。
 
-バックグラウンドサービスに到達できない、または送信に失敗したために配信できなかった返信は保存され、そのプロセスが再び起動したときにセッションの次のプロンプトとして送信されます。エラーメッセージには返信が保存されたことが示されます。`!` を先頭に付けた返信は保存されません。保存されたテキストは Bash コマンドとして実行されるのではなく、通常のプロンプトとしてセッションに届いてしまうためです。
+返信を配信できなかった場合、エラーメッセージには返信が保存されたかどうかが示されます。`!` または `/` を先頭に付けた返信は保存されません。Claude Code は、次にセッションを再起動したときに、保存された返信をセッションの次のプロンプトとして送信します。それ以外の返信は再度送信してください。
 
 [音声ディクテーション](/docs/ja/voice-dictation) を [ホールドモード](/docs/ja/voice-dictation#hold-to-record) で有効にしている場合、返信入力がフォーカスされている間にプッシュトゥトークキーを押し続けると、入力する代わりに返信をディクテーションできます。エージェントビュー下部のディスパッチ入力でも同じように機能します。
@@ -296,4 +296,5 @@ Claude Code が会話を再度開けない場合は、終了して会話を再
 * **権限プロンプトまたは質問が回答を待っている**：権限プロンプトまたは Claude が尋ねた質問が待機している間、Claude Code は待機を続け、`Still backgrounding after the current tool — a question is waiting for your answer.` を表示します。
 * **プロンプト入力に入力した**：未送信のテキストはターミナルの入力ボックスに残り、バックグラウンドセッションには移動しないため、Claude Code は切り替えをキャンセルします。`Backgrounding cancelled — you have unsent text in the input. Send it or clear it, then press ← again.` と表示されます。
+* **キューに入れたメッセージを移動できない**：[Claude の作業中にキューに入れた](/docs/ja/interactive-mode#queue-messages-while-claude-works) メッセージは、会話とともにバックグラウンドセッションに移動します。そのいずれかを移動できない場合、セッションはフォアグラウンドに留まり、Claude Code は `Cannot open agents — 1 queued message can't move to the background. Press ← again once Claude has read it.` のような通知を表示します。
 
 `←` を押すと、会話にまだメッセージがない場合でもセッションの行が作成されるため、`→` でその行に戻れます。
@@ -603,5 +604,5 @@ git worktree が実用的でないリポジトリで worktree 分離をオフに
 git リポジトリの外では、セッションは作業ディレクトリに直接書き込み、互いに分離されないため、同じファイルを編集する並列セッションのディスパッチは避けてください。別のバージョン管理システムを使用している場合は、[`WorktreeCreate` フック](/docs/ja/worktrees#non-git-version-control) を設定すると、Claude は git の場合と同じ方法で編集を分離します。
 
-git リポジトリではないディレクトリでフックが失敗した場合、Claude はそのディレクトリの分離をスキップし、作業ディレクトリをその場で編集します。git リポジトリ内では、編集前に Claude が worktree に移動させるセッションは、その移動が行われるまで共有チェックアウト内のファイルを編集できません。
+git リポジトリではないディレクトリでフックが失敗した場合、Claude はそのディレクトリの分離をスキップし、作業ディレクトリをその場で編集します。git リポジトリ内では、編集前に Claude が worktree に移動させるセッションは、その移動が行われるまで共有チェックアウトに対して `Edit`、`Write`、`NotebookEdit` ツールを使用できません。
 
 セッションの worktree のパスを確認するには、アタッチしてその作業ディレクトリを確認します。
@@ -973,5 +974,5 @@ Claude Code は、エージェントビューに表示されているすべて
 * 別の非インタラクティブ Claude Code プロセス（例えば、同じ会話のバックグラウンドセッションプロセスがまだ終了していない）：行を開くと `This conversation is already open in another running Claude session` が表示されます。そのプロセスを使用するか、終了するまで待機して行を再度開きます。
 
-Claude Code は拒否された試みで入力した返信を保存し、セッションが次に開始するときに送信します。
+Claude Code は拒否された試みで入力した返信を保存し（`!` または `/` で始まる返信を除く）、セッションが次に開始するときに送信します。
 
```

</details>

<details>
<summary>amazon-bedrock-ja.md</summary>

```diff
diff --git a/docs-ja/pages/amazon-bedrock-ja.md b/docs-ja/pages/amazon-bedrock-ja.md
index 23344f4..28dc65f 100644
--- a/docs-ja/pages/amazon-bedrock-ja.md
+++ b/docs-ja/pages/amazon-bedrock-ja.md
@@ -137,7 +137,19 @@ AWS Organizations を使用している場合、[`PutUseCaseForModelAccess` API]
 </h3>
 
-Claude Code は AWS SDK のデフォルト認証情報チェーンを使用します。以下のいずれかの方法を使用して認証情報を設定してください。
+Claude Code は AWS SDK のデフォルト認証情報チェーンを使用します。Amazon EC2 インスタンスプロファイルや Amazon ECS タスク認証情報など、マシンがすでにそのチェーンに認証情報を提供している場合は、[ステップ 3](#3-configure-claude-code) に進んでください。
 
-**オプション A: AWS CLI 設定**
+AWS は、専用ソフトウェアを開発する場合や実データを扱う場合に [IAM ユーザーのアクセスキーを使用しないよう警告しています](https://docs.aws.amazon.com/cli/latest/userguide/cli-authentication-user.html)。以下のいずれかの方法で認証情報を設定してください。
+
+* [`aws configure`](#use-aws-configure): IAM ユーザーのアクセスキーを `~/.aws` ディレクトリ内のプロファイルに保存します
+* [アクセスキーの環境変数](#export-an-access-key): アクセスキー、またはセッショントークン付きの一時的な認証情報を、現在のシェルでのみ設定します
+* [SSO プロファイル](#use-an-sso-profile): ブラウザで IAM Identity Center を通じてサインインし、一時的な認証情報を取得します。IAM Identity Center を通じて AWS アカウントにアクセスしている場合は、この方法を使用してください。
+* [AWS Management Console 認証情報](#use-aws-management-console-credentials): AWS Management Console の認証情報を使ってブラウザでサインインし、一時的な認証情報を取得します。ルートユーザー、IAM ユーザー、または IAM とのフェデレーションを通じて AWS アカウントにアクセスしている場合、AWS は[この方法を推奨しています](https://docs.aws.amazon.com/signin/latest/userguide/command-line-sign-in.html)。
+* [Amazon Bedrock API キー](#use-an-amazon-bedrock-api-key): AWS 認証情報の代わりに、Amazon Bedrock でのみ機能するベアラートークンで認証します
+
+<h4 id="use-aws-configure">
+  `aws configure` を使用する
+</h4>
+
+`aws configure` を実行し、プロンプトが表示されたらアクセスキー ID、シークレットアクセスキー、デフォルトリージョンを入力します。
 
 ```bash theme={null}
@@ -145,5 +157,11 @@ aws configure
 ```
 
-**オプション B: 環境変数（アクセスキー）**
```

</details>

<details>
<summary>artifacts-ja.md</summary>

```diff
diff --git a/docs-ja/pages/artifacts-ja.md b/docs-ja/pages/artifacts-ja.md
index b279042..5329b71 100644
--- a/docs-ja/pages/artifacts-ja.md
+++ b/docs-ja/pages/artifacts-ja.md
@@ -52,17 +52,33 @@ Build a dashboard artifact of last week's deploy failures by service and keep it
 ```
 
-場所を指定しない限り、Claude はページを HTML または Markdown ファイルとしてプロジェクト外の一時ディレクトリに書き込み、公開します。[Plan Mode](/docs/ja/permission-modes#analyze-before-you-edit-with-plan-mode) 以外では、入力したプロンプトに応じて Claude が公開する新しいアーティファクトは、権限プロンプトまたは分類器レビューなしで処理されます。ただし、その公開が[コネクタ呼び出し](#pull-live-data-with-mcp-connectors)や[ファイルダウンロード](#offer-a-file-download)などのページのランタイム機能を宣言する場合は除きます。Plan Mode では、Claude Code は各アーティファクトの最初の公開前にあなたに確認を求めます。
+場所を指定しない限り、Claude はページを HTML または Markdown ファイルとしてプロジェクト外の一時ディレクトリに書き込み、公開します。アーティファクトは[共有](#share-an-artifact)するまで、ユーザー本人だけが見られるプライベートな状態のままです。
 
-アーティファクトは[共有](#share-an-artifact)するまでプライベートなままです。公開共有した後、Claude Code は会話ごとに 1 回変更前に承認を求めるか、[auto mode](/docs/ja/permission-modes#eliminate-prompts-with-auto-mode) では分類器に変更をレビューさせます。
+最初の公開後、Claude は URL を出力し、ブラウザで新しいページが開きます。
 
-[機能フラグ取得](/docs/ja/env-vars#features-that-need-feature-flag-fetching)をオフにした場合、Claude Code は各アーティファクトの最初の公開前に確認を求めるか、auto mode では分類器にレビューさせます。
+* **ページを再度開く**：任意の時点で `Ctrl+]` を押すと、セッションの最新のアーティファクトを再度開けます
+* **このセッションのアーティファクトを確認する**：プロンプトの下にある `⧉` ピルに、アーティファクトの名前、またはセッションに複数ある場合はその数が表示されます。[フルスクリーンレンダリング](/docs/ja/fullscreen)では、これをクリックすると [`/artifacts`](#find-an-artifact-again) の一覧が開きます
+* **ブラウザが開かないようにする**：環境で `CLAUDE_CODE_ARTIFACT_AUTO_OPEN=0` を設定します
+* **Remote Control**：claude.ai、Claude Desktop、または Claude モバイルアプリから [Remote Control](/docs/ja/remote-control) 経由でプロンプトを送信した場合、セッションを実行しているマシンではタブが開きません。ブラウザは、ターミナルで入力したプロンプトから Claude が次にアーティファクトを公開したときに開きます
 
-最初の公開後、Claude は URL を出力し、ブラウザが新しいページに開きます。[Remote Control](/docs/ja/remote-control)から claude.ai、Claude Desktop、または Claude モバイルアプリを通じてプロンプトを送信した場合、セッションを実行しているマシンではタブが開きません。ブラウザは、Claude がターミナルで入力したプロンプトからアーティファクトを再度公開する次回に開きます。任意の時点で `Ctrl+]` を押して、セッションの最新アーティファクトを再度開きます。
+Claude はアーティファクトのタイトルと、チャートやカレンダーなどページの内容に合ったブラウザタブアイコンを選択します。タイトルは claude.ai の[アーティファクトギャラリー](#share-an-artifact)と共有リンクに表示されます。特定のタイトルやタブアイコンを使いたい場合は、Claude に依頼してください。
 
-Claude はアーティファクトのタイトルと絵文字を選択し、両方が claude.ai の[アーティファクトギャラリー](#share-an-artifact)と共有リンクに表示されます。Claude はまた、チャートやカレンダーなど、ページが何であるかに一致するブラウザタブアイコンを選択することもできます。特定のタイトル、絵文字、またはタブアイコンが必要な場合は、Claude に要求してください。
+Claude が公開できないと応答した場合、またはリンクなしでローカル HTML ファイルを書き込んだ場合、セッションでアーティファクトが有効になっていません。[利用可能性](#availability)の要件を確認してください。ターミナルに `Artifacts need a claude.ai login` と表示された場合は、サインイン方法について[該当するエラーの項目](/docs/ja/errors#artifacts-need-a-claude-ai-login)を参照してください。
 
-新しいアーティファクトが公開されたときにブラウザが自動的に開くのを停止するには、環境で `CLAUDE_CODE_ARTIFACT_AUTO_OPEN=0` を設定します。
+<h3 id="when-claude-code-asks-before-publishing">
+  公開前に Claude Code が確認する場合
+</h3>
+
```

</details>

<details>
<summary>authentication-ja.md</summary>

```diff
diff --git a/docs-ja/pages/authentication-ja.md b/docs-ja/pages/authentication-ja.md
index 7d6b628..43e1d73 100644
--- a/docs-ja/pages/authentication-ja.md
+++ b/docs-ja/pages/authentication-ja.md
@@ -143,6 +143,4 @@ API キーを作成しなくても Console アカウントにサインインで
 * **元に戻す方法**: `/logout` を実行します。これにより、このサインインが書き込んだ認証情報が削除および取り消されます
 
-組織が [サーバー管理設定](/docs/ja/server-managed-settings)を使用している場合、Claude Code v2.1.257 以降でこのサインインに適用されます。
-
 プロファイルに関するその他すべてのことがこのサインインに適用されます。これには、他の認証情報に対するランク付け、`/status` で取得される `Profile` 行、および claude.ai ログインが必要な機能が含まれます。[Anthropic プロファイルとフェデレーション認証情報](#anthropic-profiles-and-federation-credentials)を参照してください。
 
```

</details>

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index 43185dc..bf5498e 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,155 @@
 # Changelog
 
+## 2.1.295
+
+- Added `onFailure: "block"` for command and HTTP hooks: a hook that can't start, times out, or exits with an unexpected code blocks the action instead of letting it through
+- Added Program Status Protocol (OSC 7501) support: terminals that implement it can show whether Claude Code is working, waiting on you, or done
+- Added quoted text to the `/copy` picker, so a drafted message copies without its `>` markers
+- Added a warning to `claude plugin install`, `enable`, `disable` and `marketplace add` when the settings file they write to does not load
+- Added a line on stderr, when it is a terminal, that says what a `claude -p` run is waiting for when it stays open after its last turn
+- Added support for `timeouts.upstream_ttfb_ms` on the Claude apps gateway's Bedrock, Vertex, Foundry and other cloud upstreams: a value you set now limits how long a stream may take to start there, after which it fails over or gets a 502
+- Added a "Backgrounding cancelled" message when you stop the turn while `←` is waiting for the current tool to finish
+- Added an optional `models` list to every Claude apps gateway upstream: only the listed models are sent there, on failover too, and one `*` in an entry is a wildcard
+- Added support for `forceLoginMethod: "gateway"` and `forceLoginGatewayUrl` in your own user settings on machines with no managed settings, so `/login` opens on that Claude apps gateway
+- Added advice to `claude plugin validate` when a plugin's README has no install line: it prints the line to paste and never changes the exit code, even with `--strict`
+- Added `upstream_request_id` to the Claude apps gateway's `inference` audit event: the request ID from Amazon Bedrock, the Anthropic API or another upstream, for support cases
+- Added `$.ui.notify` for mods: raises a native notification through your own notification setting and says which channel sent it
+- Added children to a mod's `Button`: strings and `Text`, so a row of a list is one pressable with a chip or a dim detail inside
+- Added `CLAUDE_CODE_RETRY_WATCHDOG_MAX_WAIT_MS` to limit how long unattended retry mode (`CLAUDE_CODE_RETRY_WATCHDOG`) waits out 429 and 529 errors
+- Added a `request-id` header to the Claude apps gateway's successful inference responses, so `request_id` in Claude Code telemetry matches the gateway's audit log
+- Fixed every request failing on a `[1m]` model when a gateway, Bedrock, Vertex or Foundry refuses the context-1m beta; Claude Code now resends without it
+- Fixed `claude -p` text output dropping earlier responses when background work started another turn; each turn's response now prints when the turn ends
+- Fixed remote MCP servers in headless and SDK sessions staying disconnected after an outage longer than 15 seconds, or reconnecting in a tight loop to a server that drops each connection right after it connects; repeated drops now back off, up to 30s
+- Fixed remote MCP connections being dropped when a server's error reply happened to contain a network error name
+- Fixed MCP servers that repeat a pagination cursor being asked for the same page up to 20 times at every connect
+- Fixed CSS, JavaScript and XML files returned by MCP tools being saved as .bin, which the Read tool refuses; font and icon files now get their own extension too
```

</details>

<details>
<summary>claude-apps-gateway-config-ja.md</summary>

```diff
diff --git a/docs-ja/pages/claude-apps-gateway-config-ja.md b/docs-ja/pages/claude-apps-gateway-config-ja.md
index 2b9aee0..ef45f6b 100644
--- a/docs-ja/pages/claude-apps-gateway-config-ja.md
+++ b/docs-ja/pages/claude-apps-gateway-config-ja.md
@@ -1236,5 +1236,5 @@ managed:
 CLI はメトリクス、ログ、および有効な場合はトレースをゲートウェイに送信し、ゲートウェイはそれらをそのまま各設定済みの宛先にリレーします。エクスポートは HTTP 上の OpenTelemetry Protocol（OTLP）を使用します。リレーをスキップしてセッションからコレクターに直接エクスポートするには、[ポリシーでコレクターを指定](#export-directly-to-your-collector) します。CLI が出力するメトリクスとイベントについては [使用状況の監視](/docs/ja/monitoring-usage) を参照してください。
 
-`/login` でサインインしたセッションでは、CLI はゲートウェイが発行した JWT から読み取った認証済みユーザーのアイデンティティ（`user.id`、`user.email`、`user.groups` 属性）を各エクスポートに付与します。そのため、デベロッパー側の設定なしで、デベロッパーごとのコストと使用状況の帰属が機能します。
+`/login` でサインインしたセッションでは、CLI はゲートウェイが発行した JWT から読み取った認証済みユーザーのアイデンティティ（`user.id`、`user.email`、`user.groups` 属性）を各エクスポートに付与します。そのため、デベロッパー側の設定なしで、デベロッパーごとのコストと使用状況の帰属が機能します。デベロッパーがサインインする前に Claude Code がログに記録するイベントには、[このアイデンティティは含まれません](/docs/ja/monitoring-usage#standard-attributes)。
 
 ゲートウェイでサインインした [Claude Desktop](#claude-desktop-overlay) と Cowork のセッションは、テレメトリに `enduser.id` とともに `user.email` と `user.groups` を付与するため、`user.email` または `user.groups` に対する 1 つのクエリでターミナル、Desktop、Cowork の使用状況をカバーできます。`user.groups` はコンマ区切りの IdP グループリストです。
```

</details>

<details>
<summary>claude-apps-gateway-deploy-ja.md</summary>

```diff
diff --git a/docs-ja/pages/claude-apps-gateway-deploy-ja.md b/docs-ja/pages/claude-apps-gateway-deploy-ja.md
index 92aa1a8..03bbceb 100644
--- a/docs-ja/pages/claude-apps-gateway-deploy-ja.md
+++ b/docs-ja/pages/claude-apps-gateway-deploy-ja.md
@@ -7,4 +7,12 @@
 > IdP にゲートウェイを登録し、コンテナをビルドして Kubernetes または Cloud Run にデプロイし、ヘルスチェック、シークレットローテーション、アップグレード、セキュリティを運用します。
 
+<Info>
+  **まずゲートウェイのネットワークを計画してください。** サインイン時、Claude Code は、ホスト名がパブリック IP アドレスに解決される Claude apps gateway を拒否します。インターネットから到達できないアドレスであっても同様です。
+
+  Claude apps gateway は、シェルコマンドを実行するフックを含む設定をユーザーのマシンにプッシュできます。このチェックは、ユーザーがパブリックインターネット上の悪意のあるゲートウェイに誤ってサインインするのを防ぐのに役立ちます。自社のゲートウェイもインターネットから切り離しておいてください。
+
+  ゲートウェイを実行する場所を選ぶ前に、ゲートウェイのアドレスを選んでください。通常は、ユーザーが内部ネットワーク上または VPN 経由でアクセスするプライベートアドレスです。内部ネットワークがパブリック IPv4 範囲を使用している場合は、ゲートウェイとユーザーのマシンの両方を含む範囲を 1 つ指定できます。Claude Code は、その一致をゲートウェイが内部ネットワーク上にあることを示すものとみなします。[ゲートウェイのアドレスを選択する](#choose-an-address-for-the-gateway) を参照してください。どちらもネットワークに合わない場合は、Anthropic のアカウントチームにお問い合わせください。
+</Info>
+
 このページでは、[Claude apps gateway](/docs/ja/claude-apps-gateway) の運用側について説明します。ID プロバイダー（IdP）で OAuth クライアントを登録し、ゲートウェイをコンテナとしてデプロイし、日々運用します。ゲートウェイが起動時に読み込む `gateway.yaml` ファイルのすべてのオプションについては、[設定リファレンス](/docs/ja/claude-apps-gateway-config) を参照してください。
 
@@ -18,8 +26,4 @@
 サインインまたはブート中に失敗が発生した場合は、[トラブルシューティング](#troubleshooting) に直接進んでください。これは表示されるエラーに基づいてキー付けされています。
 
-<Note>
-  **プライベートネットワークにデプロイします。** Claude Code は、アドレスがプライベートであるゲートウェイにのみ接続します。これはセキュリティガードです。信頼されたゲートウェイは、開発者マシンでコマンドを実行する設定をプッシュできるためです。ゲートウェイを内部ロードバランサーまたは VPN の背後に配置し、プライベート IP にのみ解決するホスト名を付与します。内部ネットワークが組織が所有するパブリック IPv4 スペースから番号付けされている場合は、[所有するパブリックアドレススペースでゲートウェイを許可する](/docs/ja/claude-apps-gateway#allow-a-gateway-on-public-address-space-you-own) を参照してください。
-</Note>
-
 <h2 id="identity-provider-setup">
   ID プロバイダーのセットアップ
@@ -52,5 +56,5 @@
 </h2>
 
-ゲートウェイは単一のステートレス Linux バイナリで、Postgres を通じて調整されるため、環境内でステートレスサービスをデプロイする方法でデプロイします。ネットワーク内に保持し、開発者と IdP が HTTPS 経由で到達でき、本番認証情報を保持する他のサービスと同様に扱います。
```

</details>

*...以降省略*

</details>


<details>
<summary>2026-10-08</summary>

**変更ファイル:**

```
 docs-ja/pages/admin-setup-ja.md                    |  14 +-
 docs-ja/pages/advisor-ja.md                        |  16 +-
 docs-ja/pages/agent-teams-ja.md                    |   2 +
 docs-ja/pages/agent-view-ja.md                     |  14 +-
 docs-ja/pages/agents-ja.md                         |   2 +-
 docs-ja/pages/amazon-bedrock-ja.md                 |   4 +-
 docs-ja/pages/authentication-ja.md                 |   2 +-
 docs-ja/pages/auto-mode-config-ja.md               |   2 +-
 docs-ja/pages/changelog.md                         |  59 ++
 docs-ja/pages/chrome-ja.md                         |   2 +-
 docs-ja/pages/claude-apps-gateway-config-ja.md     |  51 +-
 docs-ja/pages/claude-code-on-the-web-ja.md         |   8 +-
 docs-ja/pages/claude-directory-ja.md               |  22 +-
 docs-ja/pages/claude-projects-ja.md                |  16 +-
 docs-ja/pages/cli-reference-ja.md                  |   4 +-
 docs-ja/pages/cloud-environments-ja.md             |  98 ++--
 docs-ja/pages/code-review-ja.md                    |   2 +-
 docs-ja/pages/common-workflows-ja.md               |   2 +-
 docs-ja/pages/context-window-ja.md                 |  20 +-
 docs-ja/pages/corporate-launcher-ja.md             |   1 +
 docs-ja/pages/costs-ja.md                          |  38 +-
 docs-ja/pages/deep-links-ja.md                     |   8 +-
 docs-ja/pages/desktop-ios-simulator-ja.md          |   2 +-
 docs-ja/pages/desktop-ja.md                        | 159 ++++--
 docs-ja/pages/env-vars-ja.md                       | 636 +++++++++++----------
 docs-ja/pages/errors-ja.md                         |   9 +-
 docs-ja/pages/fast-mode-ja.md                      |   2 +-
 docs-ja/pages/feature-availability-ja.md           |  13 +-
 docs-ja/pages/github-actions-ja.md                 |   2 +
 docs-ja/pages/glossary-ja.md                       |  48 +-
 docs-ja/pages/google-vertex-ai-ja.md               |   4 +-
 docs-ja/pages/headless-ja.md                       |  29 +-
 docs-ja/pages/hooks-guide-ja.md                    |   2 +-
 docs-ja/pages/hooks-ja.md                          |  14 +-
 docs-ja/pages/how-claude-code-works-ja.md          |   2 +-
 docs-ja/pages/interactive-mode-ja.md               |   2 +-
 docs-ja/pages/keybindings-ja.md                    |  54 +-
 docs-ja/pages/llm-gateway-connect-ja.md            |   9 +-
 docs-ja/pages/llm-gateway-protocol-ja.md           |   2 +-
 docs-ja/pages/managed-mcp-ja.md                    |  22 +-
 docs-ja/pages/mcp-ja.md                            |  10 +-
 docs-ja/pages/memory-ja.md                         |   4 +-
 docs-ja/pages/mobile-ja.md                         |   2 +-
 docs-ja/pages/model-config-ja.md                   |  66 ++-
 docs-ja/pages/monitoring-usage-ja.md               |   2 +-
 docs-ja/pages/overview-ja.md                       |  10 +-
 docs-ja/pages/permission-modes-ja.md               |  16 +-
 docs-ja/pages/plugin-evals-ja.md                   |   8 +-
 docs-ja/pages/prompt-caching-ja.md                 |  76 +--
 docs-ja/pages/prompt-library-ja.md                 |   8 +-
 docs-ja/pages/quickstart-ja.md                     | 176 +++---
 docs-ja/pages/remote-control-ja.md                 |   6 +-
 docs-ja/pages/routines-ja.md                       |   2 +-
 .../pages/self-hosted-environments-testing-ja.md   |   2 +-
 docs-ja/pages/server-managed-settings-ja.md        |  48 +-
 docs-ja/pages/sessions-ja.md                       |  78 +--
 docs-ja/pages/settings-ja.md                       |  30 +-
 docs-ja/pages/settings-reference-ja.md             |  19 +-
 docs-ja/pages/setup-ja.md                          |   8 +-
 docs-ja/pages/skills-ja.md                         |   9 +-
 docs-ja/pages/statusline-ja.md                     |  29 +-
 docs-ja/pages/sub-agents-ja.md                     |  10 +-
 docs-ja/pages/tools-reference-ja.md                |   6 +-
 docs-ja/pages/vs-code-ja.md                        |  30 +-
 docs-ja/pages/web-quickstart-ja.md                 |  34 +-
 docs-ja/pages/workflows-ja.md                      |   7 +-
 docs-ja/pages/worktrees-ja.md                      |   4 +-
 67 files changed, 1228 insertions(+), 870 deletions(-)
```

<details>
<summary>admin-setup-ja.md</summary>

```diff
diff --git a/docs-ja/pages/admin-setup-ja.md b/docs-ja/pages/admin-setup-ja.md
index 0cd347d..f3a18fe 100644
--- a/docs-ja/pages/admin-setup-ja.md
+++ b/docs-ja/pages/admin-setup-ja.md
@@ -47,5 +47,5 @@ Claude Code は複数の API プロバイダーのいずれかを通じて Claud
 </h2>
 
-マネージド設定は、組織ポリシーを定義します。Claude Code は以下の表に示す 4 つのソースを優先順位順にチェックします。[Claude Code がマネージドソースを組み合わせる方法](/docs/ja/managed-settings#precedence-within-the-managed-tier)は、どのソースが適用されるか、ポリシーヘルパーが何を変更するか、およびすべてのソースを構成する方法を説明しています。この表は決定マップです。
+管理設定は、組織ポリシーを定義します。Claude Code は以下の表に示す 4 つのソースを優先順位順にチェックします。[Claude Code がマネージドソースを組み合わせる方法](/docs/ja/managed-settings#precedence-within-the-managed-tier)は、どのソースが適用されるか、ポリシーヘルパーが何を変更するか、およびすべてのソースを構成する方法を説明しています。この表は決定マップです。
 
 | メカニズム | 配信 | 優先度 | プラットフォーム |
@@ -56,5 +56,5 @@ Claude Code は複数の API プロバイダーのいずれかを通じて Claud
 | Windows user registry | `HKCU\SOFTWARE\Policies\ClaudeCode` | 最低 | Windows のみ |
 
-Claude Code はスタートアップ時に server-managed 設定をフェッチし、セッション中は 1 時間ごとに更新します。デプロイするエンドポイントインフラストラクチャはありません。claude.ai 管理コンソール経由の配信には Claude for Teams または Enterprise プランが必要です。Amazon Bedrock、Google Cloud の Agent Platform、または Microsoft Foundry でのデプロイメントは、[Claude apps gateway](/docs/ja/claude-apps-gateway) を実行することで同じリモート配信を取得できます。または、ファイルベースまたは OS レベルのメカニズムのいずれかを代わりに使用してください。
+Claude Code はスタートアップ時に server-managed 設定をフェッチし、セッション中は 1 時間ごとに更新します。デプロイするエンドポイントインフラストラクチャはありません。claude.ai 管理コンソール経由の配信には Claude for Teams または Enterprise プランが必要です。Amazon Bedrock、Google Cloud の Agent Platform、または Microsoft Foundry でのデプロイは、[Claude apps gateway](/docs/ja/claude-apps-gateway) を実行することで同じリモート配信を取得できます。または、ファイルベースまたは OS レベルのメカニズムのいずれかを代わりに使用してください。
 
 組織が複数のプロバイダーを混在させている場合、claude.ai ユーザー向けに [server-managed settings](/docs/ja/server-managed-settings) を設定し、他のユーザーがマネージドポリシーを受け取るように [ファイルベースまたは plist/registry フォールバック](/docs/ja/managed-settings#delivery-mechanisms)を設定してください。
@@ -70,16 +70,16 @@ plist と HKLM レジストリの場所は任意のプロバイダーで機能
 </h3>
 
-Windows では、[Claude Code Desktop は WSL 2 ディストリビューション内で Code セッションを実行できます](/docs/ja/desktop-wsl)。セッションの Claude Code プロセスはディストリビューション内で実行されるため、上記の WSL 検出パスを通じてマネージド設定を解決します。`wslInheritsWindowsSettings: true` が展開されていない限り、Windows のみのソースはそれに到達しません。
+Windows では、[Claude Code Desktop は WSL 2 ディストリビューション内で Code セッションを実行できます](/docs/ja/desktop-wsl)。セッションの Claude Code プロセスはディストリビューション内で実行されるため、上記の WSL 検出パスを通じて管理設定を解決します。`wslInheritsWindowsSettings: true` がデプロイされていない限り、Windows のみのソースはそれに到達しません。
 
-Claude Desktop は、`C:\Program Files\ClaudeCode\managed-settings.json` が存在する場合など、組織がマネージドしているデバイスとして検出されるデバイスでは、デフォルトで WSL セッションをオフにします。それらをオンにするには、Windows レジストリポリシーをデプロイします。これには Claude Desktop v1.19367.0 以降が必要です。
+Claude Desktop は、`C:\Program Files\ClaudeCode\managed-settings.json` が存在する場合など、組織が管理しているデバイスとして検出されるデバイスでは、デフォルトで WSL セッションをオフにします。それらをオンにするには、Windows レジストリポリシーをデプロイします。これには Claude Desktop v1.19367.0 以降が必要です。
 
-* `HKLM\SOFTWARE\Policies\Claude` の下に `disableWslSessions` という名前の値を作成し、`REG_SZ` 文字列 `false` または `REG_DWORD` `0` に設定します。この値は Claude Desktop ポリシーキーの下にあり、マネージド設定を含む `ClaudeCode` キーとは別です。HKLM の下に値をデプロイします。これには管理者権限が必要です。HKCU の下の値は WSL セッションを有効にしません。
+* `HKLM\SOFTWARE\Policies\Claude` の下に `disableWslSessions` という名前の値を作成し、`REG_SZ` 文字列 `false` または `REG_DWORD` `0` に設定します。この値は Claude Desktop ポリシーキーの下にあり、管理設定を含む `ClaudeCode` キーとは別です。HKLM の下に値をデプロイします。これには管理者権限が必要です。HKCU の下の値は WSL セッションを有効にしません。
 * `C:\Program Files\ClaudeCode\managed-settings.json` をデプロイする場合は、そのままにしておいてください。`disableWslSessions` が HKLM の下で `false` になると、そのファイルが存在していても Desktop は WSL セッションを許可します。
```

</details>

<details>
<summary>advisor-ja.md</summary>

```diff
diff --git a/docs-ja/pages/advisor-ja.md b/docs-ja/pages/advisor-ja.md
index 6070a48..dd69937 100644
--- a/docs-ja/pages/advisor-ja.md
+++ b/docs-ja/pages/advisor-ja.md
@@ -88,5 +88,5 @@ Claude Code はそのセッションの `advisorModel` 設定の代わりにフ
 
 * セッションのメインモデルが advisor をサポートしていない
-* Haiku などのリクエストされたモデルが advisor として機能できない
+* Haiku 4.5 などのリクエストされたモデルが advisor として機能できない
 * 組織の [`availableModels`](/docs/ja/model-config#restrict-model-selection) 許可リストがリクエストされたモデルを除外している
 * Fable をリクエストし、アカウントがまだ[使用クレジット同意](#fable-advisor-and-usage-credits)を必要としている
@@ -104,8 +104,8 @@ Claude Code はアドバイザーの役割における能力に基づいてモ
 | メインモデル | 受け入れられるアドバイザー |
 | - | - |
-| Haiku 4.5 | Fable、Opus、Sonnet |
-| Sonnet 4.6 | Fable、Opus、Sonnet |
-| Opus 4.6 | Fable、Opus、Sonnet 5 以降 |
-| Sonnet 5 | Fable、Opus 4.7 以降、Sonnet 5 以降 |
+| Haiku 4.5 | Fable、Opus、Sonnet、Haiku 5.5 |
+| Sonnet 4.6 | Fable、Opus、Sonnet、Haiku 5.5 |
+| Opus 4.6 | Fable、Opus、Sonnet 5 以降、Haiku 5.5 |
+| Sonnet 5 または Haiku 5.5 | Fable、Opus 4.7 以降、Sonnet 5 以降、Haiku 5.5 |
 | Opus 4.7 または Opus 4.8 | Fable、Opus 4.7 以降、Sonnet 5.5 |
 | Sonnet 5.5 | Fable、Opus 5 以降、Sonnet 5.5 |
@@ -114,7 +114,7 @@ Claude Code はアドバイザーの役割における能力に基づいてモ
 | Fable 5.1 | Fable 5.1 |
 
-Fable 5.1 には Claude Code v2.1.257 以降が必要です。Fable モデルには [Fable アクセス](/docs/ja/model-config#work-with-fable) が必要です。Opus 4.7 または Opus 4.8 のメインモデルに対して Sonnet 5.5 をアドバイザーとして使用するには、Claude Code v2.1.287 以降が必要です。
+Fable 5.1 には Claude Code v2.1.257 以降が必要です。Fable モデルには [Fable アクセス](/docs/ja/model-config#work-with-fable) が必要です。Opus 4.7 または Opus 4.8 のメインモデルに対して Sonnet 5.5 をアドバイザーとして使用するには、Claude Code v2.1.287 以降が必要です。Haiku 5.5 をメインモデルまたはアドバイザーとして使用するには、Claude Code v2.1.293 以降が必要です。
 
```

</details>

<details>
<summary>agent-teams-ja.md</summary>

```diff
diff --git a/docs-ja/pages/agent-teams-ja.md b/docs-ja/pages/agent-teams-ja.md
index a91adb6..7f4436f 100644
--- a/docs-ja/pages/agent-teams-ja.md
+++ b/docs-ja/pages/agent-teams-ja.md
@@ -160,4 +160,6 @@ Claude Code は各チームメンバーのモデルを、以下の最初に適
 4. リーダーの現在のモデル。
 
+インストールされている [mod](/docs/ja/plugins/mods/overview) が [`agent.spawn`](/docs/ja/plugins/mods/reference#subagents) フックでモデルを設定している場合、Claude Code は最初のソースの代わりにそのモデルを使用します。
+
 [`CLAUDE_CODE_SUBAGENT_MODEL_FORCE=1`](/docs/ja/sub-agents#run-every-subagent-on-one-model) を設定した場合、最初の 2 つのソースは適用されません。Claude Code は `CLAUDE_CODE_SUBAGENT_MODEL` が `inherit` 以外に設定されている場合はそこからすべてのチームメンバーのモデルを選択し、それ以外の場合はリーダーの現在のモデルから選択します。Claude Code v2.1.257 以降が必要です。
 
```

</details>

<details>
<summary>agent-view-ja.md</summary>

```diff
diff --git a/docs-ja/pages/agent-view-ja.md b/docs-ja/pages/agent-view-ja.md
index 16af107..9ad0030 100644
--- a/docs-ja/pages/agent-view-ja.md
+++ b/docs-ja/pages/agent-view-ja.md
@@ -227,5 +227,5 @@ Completed
 ピークパネルに返信を入力して `Enter` を押すと、そのセッションに送信されます。返信の先頭に `!` を付けると、代わりに Bash コマンドを送信します。返信がどう扱われるかは、セッションと送信する内容によって異なります：
 
-* 作業中のセッション：返信は応答を中断せずにセッションの [メッセージキュー](/docs/ja/interactive-mode#queue-messages-while-claude-works) に追加され、[キューに入れた入力が反映されるタイミング](/docs/ja/interactive-mode#when-claude-code-sends-what-you-queued) で反映されます。[コマンド](/docs/ja/commands) は、セッション自体のプロンプトで入力するとすぐに実行されるものであっても、ターンが終了するまで待機します
+* 作業中のセッション：`/model`、`/effort`、`/rename`、`/usage` はすぐに実行されます。その他の返信は応答を中断せずにセッションの [メッセージキュー](/docs/ja/interactive-mode#queue-messages-while-claude-works) に追加され、[キューに入れた入力が反映されるタイミング](/docs/ja/interactive-mode#when-claude-code-sends-what-you-queued) で反映されます。その他の [コマンド](/docs/ja/commands) は、セッション自体のプロンプトで入力するとすぐに実行されるものであっても、ターンが終了するまで待機します
 * `/stop` だけの返信：セッションに届けられるのではなく、セッションが作業中でもユーザーを待っている状態でも、その場でセッションを停止します
 * [シェルジョブ](#run-a-shell-command)：返信は `/stop` も含め、入力としてコマンドのターミナルに送られます
@@ -289,9 +289,11 @@ Claude Code が会話を再度開けない場合は、終了して会話を再
 `←` を押した元の行は、矢印キーまたはマウスで選択を移動した後も、太字で薄くない名前を保持するため、どのセッションから来たかがわかります。
 
-`←` を押したときにツールが実行中の場合、Claude Code はバックグラウンドにする前に最大約 10 秒間その完了を待ち、Claude はバックグラウンドセッションで応答を続けます。待たずにすぐにバックグラウンドにするには、`←` を再度押します。進行中の作業をバックグラウンドセッションに引き継げない場合、Claude Code は [`/background`](#from-inside-a-session) と同様に、まず `Background this session?` ダイアログを表示します。
+`←` を押したときにツールが実行中の場合、Claude Code はバックグラウンドにする前にその完了を待ち、Claude はバックグラウンドセッションで応答を続けます。待たずにすぐにバックグラウンドにするには、`←` を再度押します。進行中の作業をバックグラウンドセッションに引き継げない場合、Claude Code は [`/background`](#from-inside-a-session) と同様に、まず `Background this session?` ダイアログを表示します。
 
-Claude が会話で開始した [フォアグラウンドのサブエージェント](/docs/ja/sub-agents#run-subagents-in-foreground-or-background) がまだ実行中の間は、10 秒の制限は適用されません。Claude Code はそれらの作業が引き継がれるよう待機を続け、待機中は `Still backgrounding after the current tool` 通知を表示します。待たずにバックグラウンドにするには `←` を再度押しますが、その場合それらのサブエージェントは最初からやり直しになります。Claude Code は [動的ワークフロー](/docs/ja/workflows) が実行しているサブエージェントは待ちません。ワークフローでサブエージェントが実行中の場合、Claude Code は代わりに `Background this session?` ダイアログを表示します。
+約 10 秒経過すると、Claude Code はそれ以上待たずにセッションをバックグラウンドにします。ただし、次のようなケースは例外です：
 
-プロンプト入力に未送信のテキストがある間、Claude Code はセッションをバックグラウンドにしません。そのテキストはターミナルの入力ボックスに残り、バックグラウンドセッションには移動しないためです。Claude Code がセッションをバックグラウンドにするのを待っている間に入力欄に入力すると、`Backgrounding cancelled — you have unsent text in the input. Send it or clear it, then press ← again.` と表示されて切り替えがキャンセルされます。
+* **フォアグラウンドのサブエージェントがまだ実行中**：Claude が開始した [フォアグラウンドのサブエージェント](/docs/ja/sub-agents#run-subagents-in-foreground-or-background) の作業が引き継がれるよう、Claude Code は待機を続け、`Still backgrounding after the current tool` を表示します。待たずにバックグラウンドにするには `←` を再度押しますが、その場合それらのサブエージェントは最初からやり直しになります。
+* **権限プロンプトまたは質問が回答を待っている**：権限プロンプトまたは Claude が尋ねた質問が待機している間、Claude Code は待機を続け、`Still backgrounding after the current tool — a question is waiting for your answer.` を表示します。
+* **プロンプト入力に入力した**：未送信のテキストはターミナルの入力ボックスに残り、バックグラウンドセッションには移動しないため、Claude Code は切り替えをキャンセルします。`Backgrounding cancelled — you have unsent text in the input. Send it or clear it, then press ← again.` と表示されます。
 
 `←` を押すと、会話にまだメッセージがない場合でもセッションの行が作成されるため、`→` でその行に戻れます。
@@ -820,4 +822,5 @@ claude agents --settings ./ci-settings.json --add-dir ../shared-lib
 | `claude rm <id> --force-remove-worktree <worktree-id>` | git または `WorktreeRemove` フックが worktree を削除できなかったために削除が拒否されたセッションを削除し、worktree ディレクトリを削除してそのブランチをリポジトリに残します。拒否が出力した正確な値を渡します。[セッションの削除で何が削除されるか](#what-deleting-a-session-removes)を参照してください。v2.1.268 以降が必要です |
 | `claude daemon status` | [supervisor](#the-supervisor-process) の状態、バージョン、ソケットディレクトリ、およびワーカー数を出力する |
+| `claude daemon logs` | supervisor のログファイル [`~/.claude/daemon.log`](#where-state-is-stored) を追跡し、`Ctrl+C` を押すまで新しい行を到着次第出力する |
```

</details>

<details>
<summary>agents-ja.md</summary>

```diff
diff --git a/docs-ja/pages/agents-ja.md b/docs-ja/pages/agents-ja.md
index 236184e..7858ede 100644
--- a/docs-ja/pages/agents-ja.md
+++ b/docs-ja/pages/agents-ja.md
@@ -21,5 +21,5 @@ Claude Code には、複数のタスクを同時に処理する 5 つの方法
 この作業をサポートする 3 つの追加ツールがありますが、エージェント自体を実行する方法ではありません。
 
-* [ワークツリー](/docs/ja/worktrees) は各セッションに個別の git チェックアウトを提供するため、並列セッションが同じファイルを編集することはありません。自分で実行するセッションに使用します。エージェントビューからディスパッチされたセッションは、[ファイルを編集する前に独自のワークツリーに移動](/docs/ja/agent-view#how-file-edits-are-isolated) し、スポーンするサブエージェントも各々独自のワークツリーを取得できます。
+* [Worktree](/docs/ja/worktrees) は各セッションに個別の git チェックアウトを提供するため、並列セッションはそれぞれ自分のファイルのコピーを編集します。自分で実行するセッションに使用します。エージェントビューからディスパッチしたセッションは、[ファイルを編集する前に専用の worktree に移動](/docs/ja/agent-view#how-file-edits-are-isolated) し、スポーンするサブエージェントもそれぞれ worktree を取得できます。
 * [クロスセッションメッセージング](/docs/ja/cross-session-messaging) により、Claude はこのマシン上、別のマシン上、または [クラウド](/docs/ja/claude-code-on-the-web) 上の他の Claude Code セッションをリストして、メッセージを送信できます。自分で実行するセッションは、検出結果とステータスを相互に渡すことができます。
 * [`/batch`](/docs/ja/commands) は、1 つの大きな変更を 5 ～ 30 個のワークツリー分離サブエージェントに分割する [skill](/docs/ja/skills) です。これはサブエージェントとワークツリーのパッケージ化された使用法であり、別の調整スタイルではありません。
```

</details>

<details>
<summary>amazon-bedrock-ja.md</summary>

```diff
diff --git a/docs-ja/pages/amazon-bedrock-ja.md b/docs-ja/pages/amazon-bedrock-ja.md
index f9a2444..23344f4 100644
--- a/docs-ja/pages/amazon-bedrock-ja.md
+++ b/docs-ja/pages/amazon-bedrock-ja.md
@@ -189,5 +189,5 @@ Claude Code は AWS デフォルト認証情報プロバイダーチェーンを
 キャッシュは上記のすべての認証情報オプションをカバーしていますが、Amazon Bedrock API キーはプロバイダーチェーンを使用しないため除外されます。代わりにすべてのリクエストでチェーンを解決するには、[`CLAUDE_CODE_SKIP_AWS_CRED_CACHE=1`](/docs/ja/env-vars) を設定してください。
 
-チェーンの各解決は 60 秒後にタイムアウトします。チェーン内のステップが停止した場合（例えば、受け取ることができない入力を待つ `credential_process` ヘルパー）、リクエストは [`AWS default-chain credential resolve timed out`](/docs/ja/errors#aws-default-chain-credential-resolve-timed-out) で失敗します。チェーンが正当に長い時間が必要なインタラクティブサインイン（`aws-vault` のようなラッパーを使用した MFA 付きブラウザベースの SSO など）を実行する場合、[`CLAUDE_CODE_AWS_CHAIN_RESOLVE_TIMEOUT_MS`](/docs/ja/env-vars) でミリ秒単位で制限を引き上げてください。v2.1.207 より前では、停止した認証情報解決はリクエストを無期限に待機させていました。
+キャッシュを埋める解決は 60 秒後にタイムアウトします。チェーン内のステップが停止した場合（例えば、受け取ることができない入力を待つ `credential_process` ヘルパー）、リクエストは [`AWS default-chain credential resolve timed out`](/docs/ja/errors#aws-default-chain-credential-resolve-timed-out) で失敗します。チェーンが正当に長い時間を必要とするインタラクティブサインイン（`aws-vault` のようなラッパーを使用した MFA 付きブラウザベースの SSO など）を実行する場合、[`CLAUDE_CODE_AWS_CHAIN_RESOLVE_TIMEOUT_MS`](/docs/ja/env-vars) でミリ秒単位で制限を引き上げてください。`CLAUDE_CODE_SKIP_AWS_CRED_CACHE=1` を設定している場合、各 API リクエストはこの制限なしでチェーンを解決します。
 
 Amazon Bedrock API キーで認証する場合を除き、[セットアップウィザード](#sign-in-with-bedrock)は認証情報を検証する際に行う各 AWS 呼び出しに同じ制限を適用し、各モデルチェック前の認証情報ルックアップにも適用します。認証情報検証中に、制限を超えるチェックは [`Timed out after 60s waiting for AWS`](/docs/ja/errors#bedrock-setup-verification-timed-out-waiting-for-aws) で失敗します。
@@ -683,5 +683,5 @@ Claude Code は Amazon Bedrock [Invoke API](https://docs.aws.amazon.com/bedrock/
 Amazon Bedrock は `InvokeModelWithResponseStream` レスポンスをバイナリイベントストリーム形式でストリーミングし、ヘッダー `Content-Type: application/vnd.amazon.eventstream` を含みます。Claude Code と Amazon Bedrock の間のゲートウェイまたはプロキシは、Amazon Bedrock が送信したレスポンスボディとそのヘッダー（`Content-Type` を含む）を変更されずに転送する必要があります。
 
-ゲートウェイが `Content-Type` を別の値に書き換える場合、Claude Code は `Bedrock streaming response has content-type` で始まるエラーでレスポンスを拒否し、受け取った値を名前付けます。一般的な書き換えは `text/event-stream` で、ストリームをサーバー送信イベントとして再発行する統合からのものです。
+ゲートウェイが `Content-Type` を別の値に書き換える場合、Claude Code は `Bedrock streaming response has content-type` で始まるエラーでレスポンスを拒否し、受け取った値を名前付けます。一般的な書き換えは `text/event-stream` で、ストリームをサーバー送信イベントとして再発行する統合からのものです。エラーメッセージに示される `CLAUDE_CODE_DISABLE_BEDROCK_CONTENT_TYPE_GUARD` 変数については、[Bedrock streaming response has an unexpected content-type](/docs/ja/errors#bedrock-streaming-response-has-an-unexpected-content-type) を参照してください。
 
 ゲートウェイがヘッダーをドロップまたは空白にする代わりに、Claude Code は本体が Amazon Bedrock のイベントストリームであると仮定してデコードするため、ゲートウェイが変更されずに通した本体はストリーミングを続けます。
```

</details>

<details>
<summary>authentication-ja.md</summary>

```diff
diff --git a/docs-ja/pages/authentication-ja.md b/docs-ja/pages/authentication-ja.md
index 5d12dde..7d6b628 100644
--- a/docs-ja/pages/authentication-ja.md
+++ b/docs-ja/pages/authentication-ja.md
@@ -13,5 +13,5 @@ Claude Code は、セットアップに応じて複数の認証方法をサポ
 </h2>
 
-[Claude Code をインストール](/docs/ja/setup#install-claude-code)した後、ターミナルで `claude` を実行します。初回起動時に、Claude Code はログインするためのブラウザウィンドウを開きます。`ANTHROPIC_API_KEY` 環境変数を設定している場合、Claude Code はログインプロンプトをスキップし、代わりにキーを承認するよう求めます。
+[Claude Code をインストール](/docs/ja/setup#install-claude-code)した後、ターミナルで `claude` を実行します。初回起動時に、Claude Code はログインするためのブラウザウィンドウを開きます。`ANTHROPIC_API_KEY` 環境変数を設定していて、そのキーを使用するかどうかを Claude Code に尋ねられたときにキーを承認した場合、Claude Code はログインプロンプトをスキップします。
 
 ブラウザが自動的に開かない場合は、`c` を押してログイン URL をクリップボードにコピーし、ブラウザに貼り付けます。
```

</details>

<details>
<summary>auto-mode-config-ja.md</summary>

```diff
diff --git a/docs-ja/pages/auto-mode-config-ja.md b/docs-ja/pages/auto-mode-config-ja.md
index 29cf65e..7d4dab9 100644
--- a/docs-ja/pages/auto-mode-config-ja.md
+++ b/docs-ja/pages/auto-mode-config-ja.md
@@ -352,5 +352,5 @@ claude auto-mode config
 ```
 
-カスタム `allow`、`soft_deny`、`hard_deny` ルールについて AI からのフィードバックを取得します：
+カスタムの `allow`、`soft_deny`、`hard_deny`、`environment` エントリについて AI からのフィードバックを取得します：
 
 ```bash theme={null}
```

</details>

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index a4eabce..43185dc 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,63 @@
 # Changelog
 
+## 2.1.293
+
+- Added Claude Haiku 5.5 (`claude-haiku-5-5`), now the default Haiku model on the Anthropic API — 1M context, $0.10/$0.50 per Mtok ($0.50/$2.50 for prompts over 100K)
+- Added `agentType` to the `subagentStatusLine` payload, so scripts can tell custom subagent types apart
+- Added `isDeferred` to `$.tool.register` for mods: `false` lists the tool's schema in the prompt from the start instead of behind tool search
+- Fixed Claude sometimes treating its own last actions before a context compaction as done after it, and retracting or redoing finished work
+- Fixed a memory leak where an HTTP MCP connection kept every request it had sent until it closed
+- Fixed a message sent while Claude was working being lost when `←` moved the session to the background; if a queued message can't move, `←` now stays put and says so
+- Fixed `/model` effort ←/→ wrapping past the highest or lowest level, which could accidentally save Low as a model's default effort
+- Fixed `/tui` disconnecting Claude in Chrome in a session started with `--chrome`, and ignoring `--no-chrome`
+- Fixed Claude being told to continue or message subagents with `SendMessage` in sessions, including resumed ones, where a host, a permission rule or a `--tools` list removed that tool
+- Fixed subagents and `--agent` sessions being told a built-in tool was disabled for the whole session when only their own tool list left it out
+- Fixed a claude.ai-synced skill's edited description sometimes not reaching the model until a new conversation or `/clear`
+- Fixed `claude logs`, `stop`, `kill`, `rm` and `claude daemon status`, `stop`, `uninstall` sometimes signing you out when your login had expired or was about to
+- Fixed the footer's agents count disappearing after a momentary failure to read the sessions folder (for example, too many open files)
+- Fixed a custom agent named `worker` being shown as "Agent" when it starts, and the agent detail dialog's title losing the agent type once the agent finishes
+- Fixed the Artifact tool's transcript row briefly reading `Artifact("(unprintable path)")` while a publish call was still streaming in
+- Fixed the `/ultrareview` upload on Linux wrongly refusing some repositories, such as one inside another checkout, over a settings file that "could not be parsed" while a sandboxed command was running
+- Fixed the `/ultrareview` upload's refusal over split-index files advising a git command that could leave git unable to read its index
+- Fixed replies in very long Remote Control and cloud sessions that could still appear a block at a time instead of streaming in
+- Fixed Remote Control uploading a session's starting history again after every credential recovery
+- Fixed PushNotification reporting "Remote Control inactive" in sessions started with `claude remote-control`
+- Fixed a mod's hooks on `classic.*` events being skipped while the plugin hooks worker restarts, which left settings hooks to answer without them
```

</details>

*...以降省略*

</details>


<details>
<summary>2026-10-07</summary>

**変更ファイル:**

```
 docs-ja/pages/admin-setup-ja.md                    |   2 +-
 docs-ja/pages/amazon-bedrock-ja.md                 |   4 +-
 docs-ja/pages/best-practices-ja.md                 |   2 +-
 docs-ja/pages/changelog.md                         | 100 +++++++++++++++++++++
 docs-ja/pages/claude-apps-gateway-config-ja.md     |   6 +-
 docs-ja/pages/claude-apps-gateway-deploy-ja.md     |   8 +-
 docs-ja/pages/claude-apps-gateway-ja.md            |  20 +++--
 docs-ja/pages/claude-apps-gateway-on-aws-ja.md     |  68 +++++++-------
 docs-ja/pages/claude-directory-ja.md               |   6 +-
 docs-ja/pages/common-workflows-ja.md               |   2 +-
 docs-ja/pages/costs-ja.md                          |   4 +-
 docs-ja/pages/deep-links-ja.md                     |   2 +-
 docs-ja/pages/desktop-scheduled-tasks-ja.md        |   2 +-
 docs-ja/pages/env-vars-ja.md                       |   6 +-
 docs-ja/pages/errors-ja.md                         |   2 +-
 docs-ja/pages/github-actions-ja.md                 |   2 +-
 docs-ja/pages/glossary-ja.md                       |   2 +-
 docs-ja/pages/headless-ja.md                       |   2 +-
 docs-ja/pages/hipaa-setup-ja.md                    |   2 +-
 docs-ja/pages/hooks-ja.md                          |   6 +-
 docs-ja/pages/llm-gateway-protocol-ja.md           |   2 +
 docs-ja/pages/llm-gateway-rollout-ja.md            |  13 +++
 docs-ja/pages/monitoring-usage-ja.md               |  49 +++++++++-
 docs-ja/pages/permission-modes-ja.md               |  16 ++++
 docs-ja/pages/quickstart-ja.md                     |  12 +--
 docs-ja/pages/remote-control-ja.md                 |   4 +
 docs-ja/pages/sandboxing-ja.md                     |   4 +-
 docs-ja/pages/security-ja.md                       |   2 +-
 .../pages/self-hosted-environments-deploy-ja.md    |  64 +++++++------
 docs-ja/pages/sessions-ja.md                       |  11 +--
 docs-ja/pages/settings-ja.md                       |   2 +-
 docs-ja/pages/skills-ja.md                         |   2 +-
 docs-ja/pages/statusline-ja.md                     |   2 +-
 docs-ja/pages/sub-agents-ja.md                     |   2 +-
 docs-ja/pages/third-party-integrations-ja.md       |   6 +-
 35 files changed, 329 insertions(+), 110 deletions(-)
```

<details>
<summary>admin-setup-ja.md</summary>

```diff
diff --git a/docs-ja/pages/admin-setup-ja.md b/docs-ja/pages/admin-setup-ja.md
index d7363b6..0cd347d 100644
--- a/docs-ja/pages/admin-setup-ja.md
+++ b/docs-ja/pages/admin-setup-ja.md
@@ -179,5 +179,5 @@ Team、Enterprise、Claude API、およびクラウドプロバイダープラ
 | Security architecture | ネットワークモデル、暗号化、認証、監査証跡 | [Security](/docs/ja/security) |
 
-リクエストレベルの監査ログが必要な場合、またはデータの機密性によってトラフィックをルーティングしたい場合は、開発者とプロバイダーの間にゲートウェイを配置することをお勧めします。セルフホスト型の [Claude apps gateway](/docs/ja/claude-apps-gateway) は IdP の ID とともにリクエストごとの監査ログを記録します。または、別の [LLM ゲートウェイ](/docs/ja/llm-gateway)を使用することもできます。ゲートウェイを経由するセッションは HIPAA 設定の対象外です。対象となる接続については、[開発者のサインイン方法と接続方法を確認する](/docs/ja/hipaa-setup#check-how-developers-sign-in-and-connect)に記載されています。規制要件と認定については、[Legal and compliance](/docs/ja/legal-and-compliance) を参照してください。
+リクエストレベルの監査ログが必要な場合、またはデータの機密性によってトラフィックをルーティングしたい場合は、開発者とプロバイダーの間にゲートウェイを配置することをお勧めします。セルフホスト型の [Claude apps gateway](/docs/ja/claude-apps-gateway) は IdP の ID とともにリクエストごとの監査ログを記録します。または、別の [LLM ゲートウェイ](/docs/ja/llm-gateway)を使用することもできます。ゲートウェイを経由するセッションは HIPAA 設定の対象外です。対象となるサインイン方法と接続方法については、[開発者のサインイン方法と接続方法を確認する](/docs/ja/hipaa-setup#check-how-developers-sign-in-and-connect)に記載されています。規制要件と認定については、[Legal and compliance](/docs/ja/legal-and-compliance) を参照してください。
 
 <h2 id="verify-and-onboard">
```

</details>

<details>
<summary>amazon-bedrock-ja.md</summary>

```diff
diff --git a/docs-ja/pages/amazon-bedrock-ja.md b/docs-ja/pages/amazon-bedrock-ja.md
index 8a4a587..f9a2444 100644
--- a/docs-ja/pages/amazon-bedrock-ja.md
+++ b/docs-ja/pages/amazon-bedrock-ja.md
@@ -638,5 +638,7 @@ export ANTHROPIC_BEDROCK_MANTLE_BASE_URL=https://your-gateway.example.com
 </h3>
 
-AWS SSO を使用する場合にブラウザタブが繰り返し生成される場合は、[settings file](/docs/ja/settings) から `awsAuthRefresh` 設定を削除してください。これは、企業 VPN または TLS 検査プロキシが SSO ブラウザフローを中断した場合に発生する可能性があります。Claude Code は中断された接続を認証失敗として扱い、`awsAuthRefresh` を再実行し、無限ループします。
+AWS SSO を使用しているときにブラウザのサインインタブが繰り返し開く場合は、[settings file](/docs/ja/settings) から `awsAuthRefresh` 設定を削除してください。
+
+このループは、企業 VPN または TLS 検査プロキシが SSO ブラウザフローを中断した場合に発生する可能性があります。Claude Code は中断された接続を認証失敗として扱います。後続のリクエストで認証情報がまだ期限切れであることが判明すると、Claude Code は `awsAuthRefresh` を再実行し、別のタブが開きます。
 
 ネットワーク環境が自動ブラウザベースの SSO フローに干渉する場合は、`awsAuthRefresh` に依存する代わりに、Claude Code を開始する前に手動で `aws sso login` を使用してください。
```

</details>

<details>
<summary>best-practices-ja.md</summary>

```diff
diff --git a/docs-ja/pages/best-practices-ja.md b/docs-ja/pages/best-practices-ja.md
index 04b4edc..8564824 100644
--- a/docs-ja/pages/best-practices-ja.md
+++ b/docs-ja/pages/best-practices-ja.md
@@ -148,5 +148,5 @@ Claude にリッチデータを提供するにはいくつかの方法があり
 * **`@` でファイルを参照する** コードがどこにあるかを説明する代わりに。Claude は応答する前にファイルを読み取ります。
 * **画像を直接貼り付ける**。画像をコピー/貼り付けまたはドラッグアンドドロップしてプロンプトに入れます。
-* **ドキュメントと API リファレンスの URL を指定する**。`/permissions` を使用して、頻繁に使用されるドメインをホワイトリストに登録します。
+* **ドキュメントと API リファレンスの URL を指定する**。`/permissions` を使用して、頻繁に使用されるドメインを許可リストに登録します。
 * **データをパイプする** `cat error.log | claude -p "explain this error"` を実行してファイルの内容を直接送信します。
 * **Claude に必要なものを取得させる**。Bash コマンド、MCP ツール、またはファイルを読み取ることを使用して、Claude 自身がコンテキストをプルするよう指示します。
```

</details>

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index 5aac4b2..a4eabce 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,104 @@
 # Changelog
 
+## 2.1.292
+
+- Added `--marketplace <source>` to `claude plugin install`: adds the marketplace if needed, under the same policy checks as `claude plugin marketplace add`, then installs the plugin from it
+- Added an `effort` parameter to the Agent tool, so Claude runs a sub-agent at the effort level you ask for
+- Added `CLAUDE_CODE_OVERLOADED_RETRY_BASE_DELAY_MS` environment variable to set a longer base delay for the backoff when retrying an overloaded (529) request
+- Added `prompt.autocomplete`, an event a mod hooks to add its own rows to the prompt box's autocomplete list
+- Added prompt caching to `$.model.complete` for mods: `prompt` and `system` take blocks of text, and `cache: true` on a block caches the request up to it
+- Added workflow agents to the `agent.spawn` mod hook, with their run and index, so a mod can refuse them
+- Fixed subagent definitions with `permissionMode: auto` entering auto mode when auto mode is unavailable (disabled by settings, circuit breaker, or a model that doesn't support it)
+- Fixed sandboxed commands being able to read the staged file copies of `/ultrareview` uploads under `~/.claude/seed-admin`
+- Fixed a managed sandbox read-deny path (and user ones beside it) that appears or re-points mid-session not dropping project grants inside it or ending credential injection from files it covers
+- Fixed a notebook or PDF read on macOS and Windows being able to return a file outside what was approved, through a link swapped in mid-read
+- Fixed a tampered on-disk cache of server-managed settings being able to switch off or unseat the built-in policy plugin while the settings fetch failed
+- Fixed `rm -rf` on the 8.3 short name or another alternate Windows spelling of the home folder or a drive not being treated as removing it
+- Security: Fixed PreToolUse hook approvals and auto mode bypassing the permission prompt for file reads from network (UNC) paths
+- Fixed a skill's or slash command's `allowed-tools` rule coming back in a later turn when you leave auto mode or plan mode partway through that turn
+- Fixed `NO_PROXY` being ignored for Claude Code's own API requests (sign-in, policy, feedback, artifacts) when `HTTPS_PROXY` is set
+- Fixed an MCP tool with a name longer than 128 characters making every request fail; that tool is now left out and an MCP error names it
+- Fixed `claude plugin` commands such as `marketplace add` and `install` running before an organization's managed settings had loaded on a first run
+- Fixed one-shot `claude -p` and Agent SDK runs stopping a background command 5 seconds after the final result, and one-shot `claude -p` runs dropping a scheduled wakeup; both are now waited for
+- Fixed plan mode not being restored when resuming a session from the `claude --resume` session picker or with `/resume`
+- Fixed saved scheduled tasks created after `/resume`, `/branch` or `/clear` never firing, and saved tasks ignoring later creates and deletes after two writes to the tasks file milliseconds apart
+- Fixed a background session's `/loop` silently stopping when the session's process restarted (for example after a crash), because its pending wakeup was lost
```

</details>

<details>
<summary>claude-apps-gateway-config-ja.md</summary>

```diff
diff --git a/docs-ja/pages/claude-apps-gateway-config-ja.md b/docs-ja/pages/claude-apps-gateway-config-ja.md
index b09533e..ed909d4 100644
--- a/docs-ja/pages/claude-apps-gateway-config-ja.md
+++ b/docs-ja/pages/claude-apps-gateway-config-ja.md
@@ -157,6 +157,6 @@ Microsoft Entra が証明書の認証情報で行うように、アイデンテ
 
 1. 新しい証明書を、古い証明書と並べて IdP にアップロードします。
-2. `gateway.yaml` が読み込む鍵と証明書のファイルを置き換えてから、ゲートウェイを再起動します。
-3. 古い証明書を IdP から削除します。
+2. `gateway.yaml` が読み込む鍵と証明書のファイルを置き換えてから、ゲートウェイを再起動します。複数のレプリカを実行している場合は、[ローリング再起動](/docs/ja/claude-apps-gateway-deploy#upgrades)で問題ありません。古い証明書を削除するまで、IdP は両方の証明書を保持しているためです。
+3. すべてのレプリカが再起動した後、古い証明書を IdP から削除します。
 
 <h4 id="idp-requests-through-a-forward-proxy">
@@ -226,5 +226,5 @@ export CLAUDE_GATEWAY_PROXY_IS_EGRESS_BOUNDARY=1
 | フィールド | 必須 | 説明 |
 | - | - | - |
-| `postgres_url` | はい | `postgres://` または `postgresql://` URL。必須：ブラウザコールバックが書き込み、ポーリング中の CLI が読み込むデバイスグラントのランデブーには、レプリカ間の状態が必要です。ゲートウェイはブート時およびアップグレード時に独自のスキーママイグレーションを実行するため、ロールはターゲットスキーマでテーブルを作成および変更する権限が必要です。[アップグレード](/docs/ja/claude-apps-gateway-deploy#upgrades)および [Postgres](/docs/ja/claude-apps-gateway-deploy#postgres) を参照してください。 |
+| `postgres_url` | はい | `postgres://` または `postgresql://` URL。カンマ区切りのリストではなく、ホストを 1 つだけ指定します。ゲートウェイはブート時およびアップグレード時に独自のスキーママイグレーションを実行するため、ロールはターゲットスキーマでテーブルを作成および変更する権限が必要です。[アップグレード](/docs/ja/claude-apps-gateway-deploy#upgrades)および [Postgres](/docs/ja/claude-apps-gateway-deploy#postgres) を参照してください。 |
 | `username` | いいえ | `postgres_url` のユーザーを上書きします |
 | `password` | いいえ | データベース認証情報。`postgres_url` ではなくここに設定して、認証情報を URL から外します。任意の文字を受け入れ、URL 認証情報よりも優先されます。 |
```

</details>

<details>
<summary>claude-apps-gateway-deploy-ja.md</summary>

```diff
diff --git a/docs-ja/pages/claude-apps-gateway-deploy-ja.md b/docs-ja/pages/claude-apps-gateway-deploy-ja.md
index 9587871..92aa1a8 100644
--- a/docs-ja/pages/claude-apps-gateway-deploy-ja.md
+++ b/docs-ja/pages/claude-apps-gateway-deploy-ja.md
@@ -250,4 +250,9 @@ readiness プローブを `/healthz` に指定する場合、レプリカは障
 </h3>
 
+ゲートウェイは状態を PostgreSQL データベースに保存します：
+
+* **データベース**：セルフホストまたはマネージドの PostgreSQL 本体で、[最小バージョン](/docs/ja/claude-apps-gateway#prerequisites) 以降であること。分散 SQL データベースなど、Postgres プロトコルを実装しているだけのデータベースはサポートされていません。
+* **アドレス**：`store.postgres_url` は 1 つのホストを受け取ります。データベースに複数のノードがある場合は、マネージドサービスのエンドポイント、ロードバランサー、仮想 IP など、それらの前段にあるアドレスを使用します。フェイルオーバーにかかる時間より長い [readiness グレースピリオド](#readiness-grace-period) を設定します。
+
 ゲートウェイは 5 つのデータテーブルと `_migrations` テーブルを保持し、すべてはブート時マイグレーションで作成されます：
 
@@ -397,8 +402,9 @@ gateway の stderr には監査イベントストリームが含まれ、監査
 | CLI `/login`: `Could not resolve gateway host <host>` | マシンが gateway の内部 DNS 名を解決できない。通常、企業ネットワーク上にないため | 開発者にネットワークまたは VPN に接続させてから、`/login` を再試行してください |
 | ブート時に `store.postgres_url` という名前の設定検証エラーで終了する | Postgres が設定されていない。gateway は Postgres を必要とします | `store.postgres_url` を設定してください。ローカル開発の場合、使い捨てコンテナを使用してください: `docker run --rm -p 5432:5432 -e POSTGRES_HOST_AUTH_METHOD=trust postgres`。 |
+| ブート時に終了: `store.postgres_url in <path> is not a URL the gateway can read`、または v2.1.290 より前では単に `Invalid URL` または `URI error` | URL を解析できない。例えば、複数のホストが列挙されている、またはパスワードにエンコードされていない `/`、`?`、`#`、`%` が含まれている | [ホストを 1 つ](#postgres)指定し、パスワードを [`store.password`](/docs/ja/claude-apps-gateway-config#store) に移動してください |
 | ブート時に終了: `requires the native binary` | ネイティブバイナリではなく Node で実行されている | Claude Code を[スタンドアロンインストール方法](/docs/ja/setup)のいずれかでインストールしてください |
 | ブート時に `config.load` の後に OIDC ディスカバリーエラーで終了する | `oidc.issuer` に到達できない、または TLS チェーンが信頼されていない | 発行者がポッドから到達可能で、`/.well-known/openid-configuration` を提供していることを確認してください。プライベート PKI の場合は `ca_cert_pem` を設定してください。ポッドが IdP にフォワードプロキシ経由でのみ到達する場合、[`oidc.use_proxy: true`](/docs/ja/claude-apps-gateway-config#idp-requests-through-a-forward-proxy)を設定してください。v2.1.227 より前のバージョンでは、代わりに IdP の各エンドポイントへの直接ルートをポッドに提供してください。ポッドが IdP のホスト名を解決できない場合、またはプロキシが IP アドレスへの `CONNECT` を拒否する場合、[プロキシのみの出口](/docs/ja/claude-apps-gateway-config#proxy-only-egress)を参照してください。これには v2.1.277 以降が必要です。 |
 | ブート時に Postgres 権限エラーで終了する | データベースロールがそのスキーマに対する DDL 権限を持たない | ロールに gateway のスキーマに対する `CREATE` を付与して、ブート時にテーブルを作成・変更できるようにしてください |
-| ログ: `could not connect to Postgres at boot, attempt 1 of 3` | gateway が起動したときにデータベースがまだ到達可能ではなかった。例えば、ネットワークがまだ起動中のコールドインスタンス | その後 gateway がブートを完了する場合、アクションは不要です。データベースに到達できない場合、gateway は終了する前に 2 秒間隔で接続を 3 回試行します。`could not connect to Postgres` で終了する場合、`store.postgres_url` とデータベースへのネットワークパスを確認してください。試行が拒否されるのではなくタイムアウトする場合、[`store.connect_timeout_seconds`](/docs/ja/claude-apps-gateway-config#store)を上げて各試行に長い時間を与えてください。 |
+| ログ: `could not connect to Postgres at boot, attempt 1 of 3` | gateway が起動したときにデータベースがまだ到達可能ではなかった。例えば、ネットワークがまだ起動中のコールドインスタンス | その後 gateway がブートを完了する場合、アクションは不要です。データベースに到達できない場合、gateway は終了する前に 2 秒間隔で接続を 3 回試行します。`could not connect to Postgres` で終了する場合、`store.postgres_url`（ホストを 1 つだけ指定していることを含む）とデータベースへのネットワークパスを確認してください。試行が拒否されるのではなくタイムアウトする場合、[`store.connect_timeout_seconds`](/docs/ja/claude-apps-gateway-config#store)を上げて各試行に長い時間を与えてください。 |
 | `/oauth/callback` が「Sign-in could not be completed」を表示する | メールドメインが拒否された、id\_token 検証が失敗した、または `email_verified` が明示的に `false` である。gateway は上書きの手段なしで常にこれを拒否します | `allowed_email_domains` を確認し、IdP が検証済みの `email` クレームを返していることを確認してください。`email_verified: false` の場合、IdP 側の検証を修正してください。IdP がメールを別のクレーム名で発行する場合、`oidc.email_claim` を設定してください。 |
 | ログ: `token exchange failed request_id=<id>: id_token missing email claim` | IdP がデフォルトで id\_token に `email` を含めていない。この拒否は `allowed_email_domains` が設定されている場合にのみ発火します。設定されていない場合、メールがないとメールなしのセッションが作成されます | IdP を設定して id\_token に `email` を発行させてください。Okta: カスタム認可サーバーの ID トークンクレームに `email` を追加してください。Entra: アプリ登録でオプションクレームとして `email` を追加してください。PingFederate: `email` を発行する OpenID Connect ポリシーを有効にしてください。IdP が userinfo エンドポイントから `email` を提供するが id\_token に含めない場合（Okta org 認可サーバーなど）、`oidc.userinfo_fallback: true` を設定してください。 |
```

</details>

<details>
<summary>claude-apps-gateway-ja.md</summary>

```diff
diff --git a/docs-ja/pages/claude-apps-gateway-ja.md b/docs-ja/pages/claude-apps-gateway-ja.md
index 186bb1d..41ab75e 100644
--- a/docs-ja/pages/claude-apps-gateway-ja.md
+++ b/docs-ja/pages/claude-apps-gateway-ja.md
@@ -76,8 +76,8 @@ Claude アプリゲートウェイは、開発者の Claude Code クライアン
 | Claude Code v2.1.195 以降 | `claude gateway` サブコマンドとゲートウェイサインインフローは v2.1.195 で提供されます。以前のパブリックビルドには含まれていません。ゲートウェイサーバーを実行するマシンと各開発者のマシンの両方が v2.1.195 以降である必要があります。`claude update` を実行して最新リリースを取得します。[Claude Platform on AWS アップストリーム](/docs/ja/claude-apps-gateway-config#claude-platform-on-aws)はゲートウェイサーバーで Claude Code v2.1.198 以降が必要です。 |
 | OpenID Connect（OIDC）ID プロバイダー | Okta、Microsoft Entra ID、Google Workspace、Keycloak、Dex、または PingFederate などの OIDC 準拠の IdP。ゲートウェイは標準 OIDC ディスカバリーと認可コードフローを実行します。SAML と LDAP はサポートされていません。 |
-| PostgreSQL 14 以降 | デバイスサインインフロー（ブラウザコールバックが書き込み、ポーリング CLI が読み取る）とレート制限カウンターをサポートします。最小層を含む任意の管理 Postgres が機能します。支出制限が設定されていない場合、ゲートウェイは数 KB の短期間有効な認証状態を保存します。[支出制限](/docs/ja/claude-apps-gateway-spend-limits)を使用すると、バックアップする必要がある耐久的な支出、監査、およびアイデンティティテーブルも保持します。`?sslmode=require` 経由の TLS が推奨されます。 |
+| PostgreSQL 11 以降 | デバイスサインインフローとレート制限カウンターをサポートします。最小層を含むマネージド PostgreSQL サービスが利用できます。[サポートされているデータベース](/docs/ja/claude-apps-gateway-deploy#postgres)を参照してください。[支出制限](/docs/ja/claude-apps-gateway-spend-limits)を使用すると、バックアップする必要がある耐久的な支出、監査、およびアイデンティティテーブルも保持します。`?sslmode=require` 経由の TLS が推奨されます。PostgreSQL 11、12、13 には、ゲートウェイサーバーで Claude Code v2.1.290 以降が必要です。PostgreSQL プロジェクトはこれらのバージョンの保守を終了しているため、可能な場合は新しいバージョンを使用してください。 |
 | モデルアップストリーム | Amazon Bedrock 認証情報、Claude Platform on AWS 認証情報、Google Cloud 認証情報、Microsoft Foundry リソース、または Anthropic API キー。複数のアップストリームがサポートされ、フェイルオーバーがあります。 |
-| HTTPS | ゲートウェイは開発者ラップトップとサインインに使用されるブラウザから `https://` 経由で到達可能である必要があります。ゲートウェイは同じリスナーでデバイス検証ページを提供します。`listen.tls` 経由で TLS 証明書を提供するか、TLS 終了イングレスの背後で実行し、`listen.public_url` を外部オリジンに設定します。プレーン `http://` オリジンはゲートウェイホストがループバック（`localhost`、`127.0.0.1`、または `::1`）の場合にのみ受け入れられます。 |
-| プライベートネットワークアドレス | `/login` では、Claude Code はゲートウェイのホスト名または IP アドレスがプライベートアドレスのみに解決されることを要求します。RFC 1918、リンクローカル、CGNAT `100.64.0.0/10`、IPv6 ULA `fc00::/7`、またはループバック。ホストするゲートウェイの場合、宣言するブロック外のパブリックアドレスは拒否されます。デプロイメントガイドの[脅威モデル](/docs/ja/claude-apps-gateway-deploy#threat-model-summary)を参照してください。開発者マシンが HTTPS を企業プロキシ経由でルーティングする場合、サインインはプロキシホストもプライベートアドレスに解決されることを要求します。そうでない場合は、ゲートウェイホストを `NO_PROXY` に追加して、CLI が直接接続するようにします。内部ネットワークが組織が所有するパブリック IPv4 スペースから番号付けされている場合は、[これらのブロックを宣言](#allow-a-gateway-on-public-address-space-you-own)して、`/login` がそこでゲートウェイを受け入れるようにします。 |
+| HTTPS | ゲートウェイは開発者ラップトップとサインインに使用されるブラウザから `https://` 経由で到達可能である必要があります。ゲートウェイは同じリスナーでデバイス検証ページを提供します。`listen.tls` 経由で TLS 証明書を提供するか、TLS 終了イングレスの背後で実行し、いずれの場合も `listen.public_url` を外部オリジンに設定します。`/login` では、Claude Code はゲートウェイホストがループバック（`localhost`、`127.0.0.1`、または `::1`）の場合にのみプレーン `http://` オリジンを受け入れます。 |
+| プライベートネットワークアドレス | `/login` では、Claude Code はゲートウェイのホスト名または IP アドレスがプライベートアドレスのみに解決されることを要求します。RFC 1918、リンクローカル、CGNAT `100.64.0.0/10`、IPv6 ULA `fc00::/7`、またはループバック。ホストするゲートウェイの場合、宣言するブロック外のパブリックアドレスは拒否されます。デプロイガイドの[脅威モデル](/docs/ja/claude-apps-gateway-deploy#threat-model-summary)を参照してください。開発者マシンが HTTPS を企業プロキシ経由でルーティングする場合、サインインはプロキシホストもプライベートアドレスに解決されることを要求します。そうでない場合は、ゲートウェイホストを `NO_PROXY` に追加して、CLI が直接接続するようにします。内部ネットワークが組織が所有するパブリック IPv4 スペースから番号付けされている場合は、[これらのブロックを宣言](#allow-a-gateway-on-public-address-space-you-own)して、`/login` がそこでゲートウェイを受け入れるようにします。 |
 | Linux ランタイム | ゲートウェイサーバーはネイティブ Linux バイナリでのみ実行されます。macOS はローカル開発用に機能します。Windows はサーバープラットフォームとしてサポートされていません。 |
 
@@ -92,5 +92,5 @@ Claude アプリゲートウェイは、開発者の Claude Code クライアン
 
   <Step title="PostgreSQL データベースをプロビジョニングする">
-    最小管理層を含む任意の Postgres 14 以降が機能します。ゲートウェイは起動時に独自のスキーママイグレーションを実行するため、データベースロールはテーブルを作成および変更する権限が必要です。[`store`](/docs/ja/claude-apps-gateway-config#store)を参照してください。
+    PostgreSQL 11 以降を使用します。最小のマネージド層で十分です。ゲートウェイは起動時に独自のスキーママイグレーションを実行するため、データベースロールはテーブルを作成および変更する権限が必要です。[`store`](/docs/ja/claude-apps-gateway-config#store)を参照してください。
   </Step>
 
@@ -143,5 +143,5 @@ Claude アプリゲートウェイは、開発者の Claude Code クライアン
 
   <Step title="実行する">
-    [イメージ要件](/docs/ja/claude-apps-gateway-deploy#container-image)を満たす `claude` バイナリの周りにコンテナイメージを構築し、Postgres と一緒に実行します。Compose ファイルはイメージを `registry.example.com/claude-gateway:2.1.198` として参照します。独自のレジストリとイメージタグに置き換えます。
+    [イメージ要件](/docs/ja/claude-apps-gateway-deploy#container-image)を満たす `claude` バイナリの周りにコンテナイメージをビルドし、Postgres と一緒に実行します。Compose ファイルはイメージを `registry.example.com/claude-gateway:2.1.198` として参照します。独自のレジストリとイメージタグに置き換えます。
 
     ```yaml docker-compose.yaml theme={null}
```

</details>

<details>
<summary>claude-apps-gateway-on-aws-ja.md</summary>

```diff
diff --git a/docs-ja/pages/claude-apps-gateway-on-aws-ja.md b/docs-ja/pages/claude-apps-gateway-on-aws-ja.md
index 78986e0..383344b 100644
--- a/docs-ja/pages/claude-apps-gateway-on-aws-ja.md
+++ b/docs-ja/pages/claude-apps-gateway-on-aws-ja.md
@@ -170,5 +170,5 @@ export PRIVATE_SUBNETS="<subnet-id-a> <subnet-id-b>"
 
   <Step title="Amazon RDS for PostgreSQL をプロビジョニングする">
-    インスタンスはプライベートサブネットで実行され、パブリックアドレスがなく、ストレージ暗号化がオンです。エンジンバージョンは Postgres 16 に固定されており、ゲートウェイがサポートする PostgreSQL 14 の下限を満たし、以下のパラメータグループファミリーがインスタンスが実行するエンジンと一致することを保証します。
+    インスタンスはプライベートサブネットで Postgres 16 を実行し、パブリックアドレスを持たず、ストレージ暗号化が有効です。
 
     まず、プライベートサブネットにデータベースを配置するサブネットグループと、`rds.force_ssl=1` を使用してサーバーがプレーンテキスト接続を拒否するパラメータグループを作成します。エンジンバージョンは 1 回固定されます。パラメータグループのファミリーはインスタンスが実行するエンジンのメジャーバージョンと一致する必要があるためです。
@@ -202,5 +202,5 @@ export PRIVATE_SUBNETS="<subnet-id-a> <subnet-id-b>"
     ```
 
-    リテラル `--master-user-password` 引数は、コマンド実行中のプロセステーブルおよび監査/EDR ログに表示されます。これは、シークレットステップのメモがカバーする同じ露出です。共有またはモニタリングされたホストでは、代わりに `0600` ファイルを介して `--cli-input-json` でパスワードを渡してください。バンドルの `setup.sh` は、`0600` 一時ファイルを `--cli-input-json` に渡すことで、同じ方法でシークレット値をプロセス argv から保ちます。
+    リテラル `--master-user-password` 引数は、コマンド実行中のプロセステーブルおよび監査/EDR ログに表示されます。これは、シークレットステップのメモがカバーする同じ露出です。共有またはモニタリングされたホストでは、バンドルの `setup.sh` と同様に、代わりに `0600` ファイルから `--cli-input-json` を介してパスワードを渡してください。
 
     インスタンスが起動するのを待ちます。これには数分かかる場合があります。その後、プライベートエンドポイントを読み取り、ゲートウェイが使用する接続文字列を組み立てます。
@@ -213,7 +213,7 @@ export PRIVATE_SUBNETS="<subnet-id-a> <subnet-id-b>"
     ```
 
-    `sslmode=verify-full` は、ゲートウェイが RDS サーバー証明書のチェーンとホスト名を検証し、暗号化するだけでなく検証することを確認します。トラストアンカーは [AWS RDS 証明書バンドル](https://truststore.pki.rds.amazonaws.com/global/global-bundle.pem)です。これは、以下のイメージビルドステップで `/etc/claude/rds-global-bundle.pem` にコピーされ、`NODE_EXTRA_CA_CERTS` を介して信頼されます。libpq スタイルの `sslrootcert=` パラメータを URL に追加しないでください。ゲートウェイのドライバーはクエリ文字列から `sslmode` のみを読み取り、`sslrootcert` を Postgres スタートアップパラメータとして転送します。サーバーはこれを拒否します。
+    `sslmode=verify-full` により、ゲートウェイは暗号化するだけでなく、RDS サーバー証明書のチェーンとホスト名も検証します。トラストアンカーは [AWS RDS 証明書バンドル](https://truststore.pki.rds.amazonaws.com/global/global-bundle.pem)です。これは、以下のイメージビルドステップで `/etc/claude/rds-global-bundle.pem` にコピーされ、`NODE_EXTRA_CA_CERTS` を介して信頼されます。libpq スタイルの `sslrootcert=` パラメータを URL に追加しないでください。ゲートウェイのドライバーはクエリ文字列から `sslmode` のみを読み取り、`sslrootcert` を Postgres スタートアップパラメータとして転送します。サーバーはこれを拒否します。
 
-    ECS サービスまたは EKS ポッドはこの VPC で実行され、インスタンスのプライベートエンドポイントに到達でき、`claude-gateway-db` セキュリティグループはゲートウェイのセキュリティグループのみを許可します。
+    ECS サービスまたは EKS ポッドは、インスタンスのプライベートエンドポイントに到達できるように、この VPC で実行する必要があります。また、`claude-gateway-db` セキュリティグループはゲートウェイのセキュリティグループのみを許可します。
   </Step>
 
@@ -221,8 +221,8 @@ export PRIVATE_SUBNETS="<subnet-id-a> <subnet-id-b>"
     `upstreams` ブロックは `auth: {}` で Bedrock を指します。ゲートウェイは ECS のタスクロールまたは EKS の IRSA ロールから AWS デフォルト認証情報チェーンを介して認証します。すべてのフィールドについては、[設定リファレンス](/docs/ja/claude-apps-gateway-config)を参照してください。
```

</details>

*...以降省略*

</details>


<details>
<summary>2026-10-06</summary>

**変更ファイル:**

```
 docs-ja/pages/admin-setup-ja.md                    |  11 +-
 docs-ja/pages/agent-view-ja.md                     | 607 +++++++++++----------
 docs-ja/pages/changelog.md                         | 193 +++++++
 docs-ja/pages/channels-ja.md                       |   8 +-
 docs-ja/pages/channels-reference-ja.md             |   2 +
 docs-ja/pages/checkpointing-ja.md                  |   6 +-
 docs-ja/pages/chrome-ja.md                         |   2 +
 docs-ja/pages/claude-code-on-the-web-ja.md         |   2 +-
 docs-ja/pages/claude-directory-ja.md               |  11 +-
 docs-ja/pages/claude-security-ja.md                |   2 +-
 docs-ja/pages/cli-reference-ja.md                  |   8 +-
 docs-ja/pages/code-review-ja.md                    |   6 +-
 docs-ja/pages/commands-ja.md                       |   4 +-
 docs-ja/pages/context-window-ja.md                 |   4 +-
 docs-ja/pages/costs-ja.md                          |   2 +-
 docs-ja/pages/debug-your-config-ja.md              |   4 +-
 docs-ja/pages/desktop-ios-simulator-ja.md          |   2 +-
 docs-ja/pages/desktop-ja.md                        |  81 +--
 docs-ja/pages/desktop-quickstart-ja.md             |   2 +-
 docs-ja/pages/env-vars-ja.md                       |   6 +-
 docs-ja/pages/errors-ja.md                         |  26 +
 docs-ja/pages/feature-availability-ja.md           |   5 +-
 docs-ja/pages/fullscreen-ja.md                     |   9 +-
 docs-ja/pages/github-enterprise-server-ja.md       |  17 +-
 docs-ja/pages/hooks-ja.md                          |   6 +-
 docs-ja/pages/interactive-mode-ja.md               |  10 +-
 docs-ja/pages/keybindings-ja.md                    |  10 +-
 docs-ja/pages/large-codebases-ja.md                |  20 +-
 docs-ja/pages/legal-and-compliance-ja.md           |   7 +-
 docs-ja/pages/mcp-ja.md                            |   2 +-
 docs-ja/pages/memory-ja.md                         |  35 +-
 docs-ja/pages/monitoring-usage-ja.md               |  10 +-
 docs-ja/pages/network-config-ja.md                 |   2 +-
 docs-ja/pages/permission-modes-ja.md               |  20 +-
 docs-ja/pages/permissions-ja.md                    |   4 +-
 docs-ja/pages/platforms-ja.md                      |   6 +-
 docs-ja/pages/prompt-caching-ja.md                 |   2 +-
 docs-ja/pages/prompt-library-ja.md                 |  42 +-
 docs-ja/pages/remote-control-ja.md                 |  64 +--
 docs-ja/pages/security-guidance-ja.md              |   2 +-
 .../pages/self-hosted-environments-deploy-ja.md    |   2 +-
 docs-ja/pages/self-hosted-environments-ja.md       |   2 +-
 docs-ja/pages/settings-reference-ja.md             |  12 +-
 docs-ja/pages/skills-ja.md                         |   4 +-
 docs-ja/pages/slack-ja.md                          |  44 +-
 docs-ja/pages/statusline-ja.md                     |   2 +-
 docs-ja/pages/sub-agents-ja.md                     |   4 +-
 docs-ja/pages/tools-reference-ja.md                |  16 +-
 docs-ja/pages/troubleshoot-install-ja.md           |   6 +-
 docs-ja/pages/ultrareview-ja.md                    |   2 +-
 docs-ja/pages/voice-dictation-ja.md                |   2 +-
 docs-ja/pages/web-quickstart-ja.md                 |   4 +-
 docs-ja/pages/workflows-ja.md                      |  10 +-
 docs-ja/pages/zero-data-retention-ja.md            |   8 +-
 54 files changed, 833 insertions(+), 547 deletions(-)
```

**新規追加:**


<details>
<summary>admin-setup-ja.md</summary>

```diff
diff --git a/docs-ja/pages/admin-setup-ja.md b/docs-ja/pages/admin-setup-ja.md
index cbf96c5..d7363b6 100644
--- a/docs-ja/pages/admin-setup-ja.md
+++ b/docs-ja/pages/admin-setup-ja.md
@@ -128,5 +128,5 @@ WSL 2 ユーティリティ VM 内のプロセスは、Windows 側のエンド
 * **クラウド環境ページ**：オーナーは[組織共有環境](/docs/ja/cloud-environments#organization-shared-environments)を作成し、メンバーのクラウドセッションの[ネットワークアクセスレベル](/docs/ja/cloud-environments#network-access)、環境変数、セットアップスクリプトを設定します。
 * **デフォルト環境**：オーナーは、[claude.ai/admin-settings/claude-code](https://claude.ai/admin-settings/claude-code) で組織のデフォルト環境を別途選択します。
-* **GitHub ページ**：組織にリンクされている GitHub アカウントについては、[接続された GitHub アカウント](#connected-github-accounts)を参照してください。
+* **Git providers ページ**：組織にリンクされている GitHub アカウントについては、[接続された GitHub アカウント](#connected-github-accounts)を参照してください。
 
 権限ルールとサンドボックスは異なるレイヤーをカバーします。WebFetch を拒否すると Claude のフェッチツールがブロックされますが、Bash が許可されている場合、`curl` と `wget` は依然として任意の URL に到達できます。サンドボックスは、OS レベルで強制されるネットワークドメイン許可リストでそのギャップを閉じます。
@@ -138,9 +138,9 @@ WSL 2 ユーティリティ VM 内のプロセスは、Windows 側のエンド
 </h3>
 
-Team プランと Enterprise プランでは、[**Organization settings > GitHub**](https://claude.ai/admin-settings/github) に、[Claude GitHub App](https://github.com/apps/claude) を通じて Claude 組織にリンクされている GitHub 組織と個人アカウントが一覧表示されます。Claude Code、[Claude Tag](https://claude.com/docs/claude-tag/admins/configure-github)、Claude Security はこのリストを共有します。このページを開くには、Claude 組織での管理者ロールが必要です。
+Team プランと Enterprise プランでは、[**Organization settings > Git providers**](https://claude.ai/admin-settings/source-control) の GitHub セクションに、[Claude GitHub App](https://github.com/apps/claude) を通じて Claude 組織にリンクされている GitHub 組織と個人アカウントが一覧表示されます。Claude Code、[Claude Tag](https://claude.com/docs/claude-tag/admins/configure-github)、Claude Security はこのリストを共有します。このページを開くには、Claude 組織での管理者ロールが必要です。
 
 アカウントは管理者またはメンバーがリンクできます。
 
-* **管理者による接続**：管理者がこのページで **Connect** をクリックし、GitHub 組織に Claude GitHub App をインストールします。この方法で組織をリンクするには、GitHub 組織のオーナーであり、かつ Claude 組織の管理者でもある人物が必要です。
+* **管理者による接続**：管理者がこのセクションで **Connect** をクリックするか、アカウントが接続済みの場合は **Add organization** をクリックして、GitHub 組織に Claude GitHub App をインストールします。この方法で組織をリンクするには、GitHub 組織のオーナーであり、かつ Claude 組織の管理者でもある人物が必要です。
 * **メンバーによる接続**：メンバーが GitHub アカウントを Claude に接続すると（たとえば[クラウドセッションのセットアップ](/docs/ja/web-quickstart#connect-github)中など）、Claude は、そのメンバーが所有し、Claude GitHub App が既にインストールされている GitHub アカウントをリンクします。これには、メンバーの個人アカウントや、メンバーが所有する GitHub 組織が含まれる場合があります。
 
@@ -175,8 +175,9 @@ Team、Enterprise、Claude API、およびクラウドプロバイダープラ
 | :- | :- | :- |
 | Data usage policy | Anthropic が収集する内容、保持期間、トレーニングに使用されない内容 | [Data usage](/docs/ja/data-usage) |
-| Zero Data Retention（ZDR） | リクエスト完了後は何も保存されません。Claude for Enterprise で利用可能 | [Zero data retention](/docs/ja/zero-data-retention) |
+| Zero Data Retention（ZDR） | リクエスト完了後は何も保存されません。Claude for Enterprise の適格なアカウントで利用可能 | [Zero data retention](/docs/ja/zero-data-retention) |
+| HIPAA 設定 | HIPAA が有効になっている Claude for Enterprise の組織向け。Claude Code（ローカルモード）の一部の機能は無効になり、その他の機能はデフォルトで無効になります | [HIPAA 対応組織向けに Claude Code（ローカルモード）をセットアップする](/docs/ja/hipaa-setup) |
 | Security architecture | ネットワークモデル、暗号化、認証、監査証跡 | [Security](/docs/ja/security) |
```

</details>

<details>
<summary>agent-view-ja.md</summary>

```diff
diff --git a/docs-ja/pages/agent-view-ja.md b/docs-ja/pages/agent-view-ja.md
index 8a6ee49..16af107 100644
--- a/docs-ja/pages/agent-view-ja.md
+++ b/docs-ja/pages/agent-view-ja.md
@@ -101,7 +101,7 @@ Claude が複数の独立したタスクに対して、あなたが毎ステッ
 `claude agents` を実行してエージェントビューを開きます。ターミナル全体を占有し、状態でグループ化されたすべてのセッションをリストします。ピン留めされたセッションと入力が必要なセッションが上部に表示されます。各行はセッションの名前、現在のアクティビティ、およびセッションが作成されてからの経過時間を表示します。完了したセッションの経過時間は、実行にかかった時間で固定されます。
 
-名前は、そのセッションで [`/color`](/docs/ja/commands) によって設定されたカラーで色付けされます。`←` または `/background` で [セッションをバックグラウンドにする](#from-inside-a-session) ときにカラーが引き継がれます。
+名前は、そのセッションで [`/color`](/docs/ja/commands) によって設定されたカラーで色付けされます。`←` または `/background` で [セッションをバックグラウンドにする](#from-inside-a-session) 場合も同様です。
 
-デフォルトでは、リストはすべてのプロジェクト全体で開始したすべてのバックグラウンドセッションを表示します。1 つのリポジトリで作業しているセッションと別のワークツリーで作業している別のセッションの両方がここに表示されます。エージェントビューを開いたディレクトリに関係なく表示されます。リストを 1 つのプロジェクトに絞り込むには、`--cwd` を渡します：
+デフォルトでは、リストはすべてのプロジェクト全体で開始したすべてのバックグラウンドセッションを表示します。1 つのリポジトリで作業しているセッションと別の worktree で作業している別のセッションの両方がここに表示されます。エージェントビューを開いたディレクトリに関係なく表示されます。リストを 1 つのプロジェクトに絞り込むには、`--cwd` を渡します：
 
 ```bash theme={null}
@@ -109,7 +109,7 @@ claude agents --cwd ~/projects/my-app
 ```
 
-これはそのディレクトリの下で開始されたセッションのみを表示します。`~/projects/my-app/.claude/worktrees/` の下の [ワークツリーに移動した](#how-file-edits-are-isolated) セッションは、`~/projects/my-app` に属するものとしてカウントされます。
+これはそのディレクトリの下で開始されたセッションのみを表示します。`~/projects/my-app/.claude/worktrees/` の下の [worktree に移動した](#how-file-edits-are-isolated) セッションも引き続き表示されます。
 
-他のターミナルで開いているインタラクティブセッションは、[バックグラウンドにする](#from-inside-a-session) までは表示されません。[Subagents](/docs/ja/sub-agents) と [teammates](/docs/ja/agent-teams) はセッションが生成しても個別の行としてリストされません。
+他のターミナルで開いているインタラクティブセッションは、[バックグラウンドにする](#from-inside-a-session) までは表示されません。セッションが生成する [サブエージェント](/docs/ja/sub-agents) と [チームメイト](/docs/ja/agent-teams) は、個別の行としてはリストされません。
 
 ```text theme={null}
@@ -125,9 +125,9 @@ Needs input
 Working
   ✽ collision detection       Adding swept-AABB checks to CollisionSystem   2m
-  ✢ playtest level 3          run 12 · all checkpoints cleared           in 4m
+  ✢ playtest level 3          all checkpoints cleared ×12                in 4m
 
```

</details>

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index 0185085..5aac4b2 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,197 @@
 # Changelog
 
+## 2.1.290
+
+- Added `serverToolUses` to the result of a mod's `turn.step` hook: the tool calls the API ran itself (the advisor), each with its id, name, input, start and end
+- Added `agentId` to the `tool.check` event of plugin hooks, so a hook can tell a subagent's permission check from the main session's
+- Added `ceiling` to the question and verdict a mod's `tool.check` hook reads, naming the approval an organization requires for a tool
+- Added `ThemeKey` and `Color` types to the plugin hooks typings, so an editor lists the theme colors a mod's drawing can name
+- Added to `claude plugin validate`: each hook a mod registers at a gating site is listed with whether it has a `.catch` (`gatingHooks` under `--json`)
+- Added a Deny button to the Claude apps gateway's sign-in approval page: it ends the pending sign-in, so the waiting terminal stops within seconds
+- Added `claude attach <name>` and `claude logs <name>`: part of a session name works in place of the id
+- Added `/claude-api managed-agents-onboard <url>` to set up the Managed Agents pattern a page describes as `ant apply` files
+- Added `/claude-api managed-agents-onboard <quickstart-name>` to build a Console quickstart template, such as `deep-researcher`, with the `ant` CLI
+- Added a warning when a managed settings file is a link to a file outside the managed settings folder
+- Added a /status and doctor warning when managed settings ignore user-configured sandbox allowRead paths or allowed domains
+- Fixed requests failing behind proxies and gateways that reject one of Claude Code's beta headers with a status other than 400, or together with a second beta
+- Fixed long sessions with hundreds of images getting stuck on "Request rejected as unprocessable by the model" errors
+- Fixed a turn ending at once when the API's output content filter stopped a reply while Claude was still thinking; the request is now retried once before the error is shown
+- Fixed resumed subagents and teammates losing their earlier thinking and prompt cache after receiving a message mid-run
+- Fixed WebFetch silently dropping page text past 100,000 characters; it now says how much was unread and takes an `offset` to read on
+- Fixed a crash ("Maximum call stack size exceeded") when a response nested lists or quotes thousands of levels deep
+- Fixed `/rewind` not listing a prompt sent while Claude was still working
+- Fixed scheduled tasks (`/loop` with an interval, reminders) silently not coming back on resume once the conversation was compacted; covers compactions made from this version on
+- Fixed scheduled tasks set in the foreground never firing after a ← or `/background` hand-off, and recurring ones firing an extra run on every resume, respawn or fork
+- Fixed headless `--json-schema` runs exiting non-zero with `is_error: true` on a `success` result when the connection dropped after the structured output was already delivered
```

</details>

<details>
<summary>channels-ja.md</summary>

```diff
diff --git a/docs-ja/pages/channels-ja.md b/docs-ja/pages/channels-ja.md
index 4f8f24b..db5ab09 100644
--- a/docs-ja/pages/channels-ja.md
+++ b/docs-ja/pages/channels-ja.md
@@ -48,5 +48,5 @@ Team、Enterprise、または Console 組織を管理している場合は、[
         * プラグインが[マーケットプレイスで見つかりません](/docs/ja/plugins/install#install-a-plugin)：プラグイン名を確認してください。
 
-        インストールがインストールスコープを求めるとき、ユーザースコープオプションを選択して、プラグインがすべてのプロジェクト全体で利用可能になるようにしてください。インストール概要を確認してください。`Run /reload-plugins to activate.` と報告されている場合は、[プラグイン変更を再起動なしで適用する](/docs/ja/plugins/cli-reference#reload-plugins)を参照して、プラグインの設定コマンドを利用可能にしてください。
+        インストールがインストールスコープを求めるとき、ユーザースコープオプションを選択して、プラグインがすべてのプロジェクト全体で利用可能になるようにしてください。インストール概要を確認してください。`Run /reload-plugins to apply.` と報告されている場合は、[プラグイン変更を再起動なしで適用する](/docs/ja/plugins/cli-reference#reload-plugins)を参照して、プラグインの設定コマンドを利用可能にしてください。
       </Step>
 
@@ -126,5 +126,5 @@ Team、Enterprise、または Console 組織を管理している場合は、[
         * プラグインが[マーケットプレイスで見つかりません](/docs/ja/plugins/install#install-a-plugin)：プラグイン名を確認してください。
 
-        インストールがインストールスコープを求めるとき、ユーザースコープオプションを選択して、プラグインがすべてのプロジェクト全体で利用可能になるようにしてください。インストール概要を確認してください。`Run /reload-plugins to activate.` と報告されている場合は、[プラグイン変更を再起動なしで適用する](/docs/ja/plugins/cli-reference#reload-plugins)を参照して、プラグインの設定コマンドを利用可能にしてください。
+        インストールがインストールスコープを求めるとき、ユーザースコープオプションを選択して、プラグインがすべてのプロジェクト全体で利用可能になるようにしてください。インストール概要を確認してください。`Run /reload-plugins to apply.` と報告されている場合は、[プラグイン変更を再起動なしで適用する](/docs/ja/plugins/cli-reference#reload-plugins)を参照して、プラグインの設定コマンドを利用可能にしてください。
       </Step>
 
@@ -193,5 +193,5 @@ Team、Enterprise、または Console 組織を管理している場合は、[
         インストールがインストールスコープを求めるとき、ユーザースコープオプションを選択して、プラグインがすべてのプロジェクト全体で利用可能になるようにしてください。
 
-        インストール概要が `Run /reload-plugins to activate.` と報告されている場合は、次のステップで再起動するため、ここではスキップできます。
+        インストール概要で `Run /reload-plugins to apply.` と報告された場合でも、次のステップで再起動するとプラグインが読み込まれるため、ここで対応する必要はありません。
       </Step>
 
@@ -252,5 +252,5 @@ Fakechat デモを試すには、以下が必要です。
     インストールがインストールスコープを求めるとき、ユーザースコープオプションを選択して、プラグインがすべてのプロジェクト全体で利用可能になるようにしてください。
 
-    インストール概要が `Run /reload-plugins to activate.` を報告する場合、ここで対応する必要はありません。次のステップで再起動するときにプラグインが取得されるためです。
+    インストール概要が `Run /reload-plugins to apply.` を報告する場合、ここで対応する必要はありません。次のステップで再起動するときにプラグインが取得されるためです。
```

</details>

<details>
<summary>channels-reference-ja.md</summary>

```diff
diff --git a/docs-ja/pages/channels-reference-ja.md b/docs-ja/pages/channels-reference-ja.md
index 9f399e6..97490a7 100644
--- a/docs-ja/pages/channels-reference-ja.md
+++ b/docs-ja/pages/channels-reference-ja.md
@@ -194,4 +194,6 @@ claude --dangerously-load-development-channels server:webhook
 ```
 
+開発フラグは、Claude Code が確認プロンプトを表示できる対話セッションで実行してください。`-p` を使用した非対話モードや Agent SDK 経由でフラグを渡した場合、Claude Code はフラグを無視し、チャネルは登録されません。
+
 バイパスはエントリごとです。このフラグを `--channels` と組み合わせても、バイパスは `--channels` エントリに拡張されません。リサーチプレビュー中、あなたのチャネルは承認許可リストにないため、構築とテスト中は開発フラグに留まります。
 
```

</details>

<details>
<summary>checkpointing-ja.md</summary>

```diff
diff --git a/docs-ja/pages/checkpointing-ja.md b/docs-ja/pages/checkpointing-ja.md
index 1d40140..9c4190a 100644
--- a/docs-ja/pages/checkpointing-ja.md
+++ b/docs-ja/pages/checkpointing-ja.md
@@ -36,5 +36,5 @@ Claude Code は、ファイル編集ツールで行われたすべての変更
 </Note>
 
-巻き戻しメニューには、セッション中に送信した各プロンプトが表示されます。ただし、[ターン中に送信されたメッセージ](#messages-sent-mid-turn-not-checkpointed)は除外されます。操作したいポイントを選択してから、アクションを選択します。
+巻き戻しメニューには、セッション中に送信したプロンプトが一覧表示されます。操作したいポイントを選択してから、アクションを選択します。
 
 * **コードと会話を復元**: コードと会話の両方をそのポイントに戻します
@@ -115,7 +115,7 @@ cp source.txt dest.txt
 </h3>
 
-[Claude が作業中にキューに入れたメッセージ](/docs/ja/interactive-mode#queue-messages-while-claude-works)が実行中のターン内に Claude に到達すると、新しいターンを開始する代わりにそのターンに参加します。メッセージは会話に表示されますが、Claude Code はそれのチェックポイントを作成せず、巻き戻しメニューにはリストされません。Claude Code が独自のターンとして送信するキューに入れたメッセージは、通常どおりチェックポイントを取得します。複数のキューに入れたメッセージが[そのターンを共有](/docs/ja/interactive-mode#when-claude-code-sends-what-you-queued)する場合も含まれます。
+[Claude が作業中にキューに入れたメッセージ](/docs/ja/interactive-mode#queue-messages-while-claude-works)が実行中のターン内に Claude に到達すると、新しいターンを開始する代わりにそのターンに参加します。メッセージは会話に表示されますが、Claude Code はそれのチェックポイントを作成しません。Claude Code が新しいターンの一部として送信するキューに入れたメッセージは、通常どおりチェックポイントを取得します。複数のキューに入れたメッセージが[そのターンを共有](/docs/ja/interactive-mode#when-claude-code-sends-what-you-queued)する場合も含まれます。
 
-そのようなメッセージを削除するか、メッセージの後に Claude が行った編集を取り消すには、ターンを開始したプロンプトに巻き戻します。これにより、メッセージが到達する前に Claude が行った作業を含む、ターン全体が巻き戻されます。
+そのようなメッセージの後に Claude が行った編集を取り消すには、ターンを開始したプロンプトに巻き戻します。これにより、メッセージが到達する前に Claude が行った作業を含む、ターン全体が巻き戻されます。
 
 <h3 id="symlinked-and-hard-linked-paths-not-restored">
```

</details>

<details>
<summary>chrome-ja.md</summary>

```diff
diff --git a/docs-ja/pages/chrome-ja.md b/docs-ja/pages/chrome-ja.md
index 94b8452..bbb883c 100644
--- a/docs-ja/pages/chrome-ja.md
+++ b/docs-ja/pages/chrome-ja.md
@@ -46,4 +46,6 @@ Claude Code を Chrome で使用する前に、以下が必要です。
 * 直接 Anthropic プラン（Pro、Max、Team、または Enterprise）
 
+HIPAA が有効になっている Enterprise 組織では、Claude in Chrome はデフォルトでオフになっており、[Owner](/docs/ja/server-managed-settings#access-control) が [**Organization settings > Claude in Chrome**](https://claude.ai/admin-settings/browser-extension) でオンにできます。Anthropic との事業提携契約（BAA）は、Claude in Chrome を通じてサードパーティのサイトに送信されるデータを対象としていません。対象サービス（Eligible Services）の一覧については、[実装ガイド](https://trust.anthropic.com/resources?s=l1wrssd9hsbi4gak0tp5a6\&name=%5Banthropic%5D-hipaa-ready-offering-implementation-guide)を参照してください。
+
 Chrome 統合を使用するには、`/login` でサインインする必要もあります。API キーまたは [`claude setup-token`](/docs/ja/authentication#generate-a-long-lived-token) で発行した長期間有効なトークンで認証している場合、ブラウザ拡張機能はこれらの認証情報では認証できないため、`--chrome` を渡しても Claude Code は Chrome 統合を無効のままにします。v2.1.216 より前のバージョンでは、これらのセッションでも Chrome 統合を有効にできましたが、ブラウザ拡張機能への接続はすべて 403 エラーで失敗していました。
 
```

</details>

*...以降省略*

</details>


<details>
<summary>2026-10-05</summary>

**変更ファイル:**

```
 docs-ja/pages/admin-setup-ja.md                    |   4 +-
 docs-ja/pages/agent-view-ja.md                     |   7 +-
 docs-ja/pages/amazon-bedrock-ja.md                 |  17 +
 docs-ja/pages/artifacts-ja.md                      |   4 +-
 docs-ja/pages/best-practices-ja.md                 |  35 +-
 docs-ja/pages/channels-ja.md                       |   2 +-
 docs-ja/pages/claude-apps-gateway-config-ja.md     | 256 +++++---
 docs-ja/pages/claude-apps-gateway-deploy-ja.md     |   9 +-
 docs-ja/pages/claude-apps-gateway-ja.md            |  41 +-
 docs-ja/pages/claude-code-on-the-web-ja.md         | 166 +++--
 docs-ja/pages/claude-directory-ja.md               |   8 +-
 docs-ja/pages/cloud-environments-ja.md             |   2 +-
 docs-ja/pages/costs-ja.md                          |   2 +-
 docs-ja/pages/cross-session-messaging-ja.md        |   1 +
 docs-ja/pages/desktop-ios-simulator-ja.md          |   2 +-
 docs-ja/pages/desktop-ja.md                        |  32 +-
 docs-ja/pages/desktop-quickstart-ja.md             |   2 +-
 docs-ja/pages/env-vars-ja.md                       | 729 +++++++++++----------
 docs-ja/pages/errors-ja.md                         |  20 +-
 docs-ja/pages/fast-mode-ja.md                      |   8 +-
 docs-ja/pages/features-overview-ja.md              |   6 +-
 docs-ja/pages/fullscreen-ja.md                     |   2 +-
 docs-ja/pages/google-vertex-ai-ja.md               |  17 +
 docs-ja/pages/headless-ja.md                       |   2 +-
 docs-ja/pages/hooks-guide-ja.md                    |   2 +-
 docs-ja/pages/hooks-ja.md                          |  60 +-
 docs-ja/pages/interactive-mode-ja.md               |   4 +-
 docs-ja/pages/keybindings-ja.md                    |   6 +-
 docs-ja/pages/llm-gateway-protocol-ja.md           |  14 +-
 docs-ja/pages/managed-mcp-ja.md                    |  96 ++-
 docs-ja/pages/managed-settings-ja.md               |   4 +-
 docs-ja/pages/mcp-ja.md                            |  17 +-
 docs-ja/pages/model-config-ja.md                   |   3 +-
 docs-ja/pages/monitoring-usage-ja.md               |  45 +-
 docs-ja/pages/permission-modes-ja.md               |  13 +-
 docs-ja/pages/sandboxing-ja.md                     |   2 +-
 .../pages/self-hosted-environments-deploy-ja.md    |  19 +
 .../self-hosted-environments-quickstart-ja.md      |   2 +-
 docs-ja/pages/server-managed-settings-ja.md        |   8 +-
 docs-ja/pages/sessions-ja.md                       |   1 +
 docs-ja/pages/settings-reference-ja.md             |   6 +-
 docs-ja/pages/skills-ja.md                         |  19 +-
 docs-ja/pages/sub-agents-ja.md                     |   2 +-
 docs-ja/pages/tools-reference-ja.md                |  13 +
 docs-ja/pages/web-quickstart-ja.md                 |   8 +-
 45 files changed, 1052 insertions(+), 666 deletions(-)
```

<details>
<summary>admin-setup-ja.md</summary>

```diff
diff --git a/docs-ja/pages/admin-setup-ja.md b/docs-ja/pages/admin-setup-ja.md
index c7c0245..cbf96c5 100644
--- a/docs-ja/pages/admin-setup-ja.md
+++ b/docs-ja/pages/admin-setup-ja.md
@@ -138,5 +138,5 @@ WSL 2 ユーティリティ VM 内のプロセスは、Windows 側のエンド
 </h3>
 
-Team プランと Enterprise プランでは、[**Admin settings > GitHub**](https://claude.ai/admin-settings/github) に、[Claude GitHub App](https://github.com/apps/claude) を通じて Claude 組織にリンクされている GitHub 組織と個人アカウントが一覧表示されます。Claude Code、[Claude Tag](https://claude.com/docs/claude-tag/admins/configure-github)、Claude Security はこのリストを共有します。このページを開くには、Claude 組織での管理者ロールが必要です。
+Team プランと Enterprise プランでは、[**Organization settings > GitHub**](https://claude.ai/admin-settings/github) に、[Claude GitHub App](https://github.com/apps/claude) を通じて Claude 組織にリンクされている GitHub 組織と個人アカウントが一覧表示されます。Claude Code、[Claude Tag](https://claude.com/docs/claude-tag/admins/configure-github)、Claude Security はこのリストを共有します。このページを開くには、Claude 組織での管理者ロールが必要です。
 
 アカウントは管理者またはメンバーがリンクできます。
@@ -162,5 +162,5 @@ Enterprise プランでは、リンクおよびリンク解除に対応する [C
 | Analytics dashboard | Teams / Enterprise でのリーダーボード付き採用度と貢献度メトリクス、Console でのユーザーごとの使用状況と支出メトリクス | Teams / Enterprise は [claude.ai/analytics](https://claude.ai/analytics/claude-code)、Console は [platform.claude.com/claude-code](https://platform.claude.com/claude-code) | [Analytics](/docs/ja/analytics) |
 | Programmatic reporting | API を通じたユーザーごとの使用状況とコストデータ | Enterprise 向け [Enterprise Analytics API](https://platform.claude.com/docs/en/api/admin/analytics)、Console 向け [Claude Code Analytics API](https://platform.claude.com/docs/en/build-with-claude/claude-code-analytics-api) | [Costs](/docs/ja/costs#manage-costs-for-your-organization) |
-| Spend controls | 支出制限とレート制限 | Teams / Enterprise の管理者設定、Console のワークスペース制限、サードパーティクラウドではクラウド予算管理またはユーザーごとの [支出制限](/docs/ja/claude-apps-gateway-spend-limits) を備えた [Claude apps gateway](/docs/ja/claude-apps-gateway) | [Costs](/docs/ja/costs#manage-costs-for-your-organization) |
+| Spend controls | 支出制限とレート制限 | Teams / Enterprise の組織設定、Console のワークスペース制限、サードパーティクラウドではクラウド予算管理またはユーザーごとの [支出制限](/docs/ja/claude-apps-gateway-spend-limits) を備えた [Claude apps gateway](/docs/ja/claude-apps-gateway) | [Costs](/docs/ja/costs#manage-costs-for-your-organization) |
 
 Teams および Enterprise では、ユーザーごとの使用状況と支出の数値は分析ダッシュボードではなく、組織の分析設定の [支出レポート](https://support.claude.com/en/articles/12883420-view-usage-analytics-for-team-and-enterprise-plans) から取得されます。クラウドプロバイダーは AWS Cost Explorer、GCP Billing、または Azure Cost Management を通じて支出を公開します。Claude チャット、Claude Code、Cowork 全体にわたるエンタープライズ予算計画については、[Claude Enterprise 消費ガイド](https://support.claude.com/en/articles/14782391-claude-enterprise-consumption-guide) を参照してください。
```

</details>

<details>
<summary>agent-view-ja.md</summary>

```diff
diff --git a/docs-ja/pages/agent-view-ja.md b/docs-ja/pages/agent-view-ja.md
index 11b08b8..8a6ee49 100644
--- a/docs-ja/pages/agent-view-ja.md
+++ b/docs-ja/pages/agent-view-ja.md
@@ -348,5 +348,5 @@ Claude Code v2.1.212 以降でセッションを戻すには、ディスパッ
 フィルターを組み合わせるには、`a:`、`s:`、`n:`、または `o:` で始め、スペースで区切って追加します。リストには、そのすべてに一致するセッションが表示されます。たとえば、`s:blocked a:reviewer` は、ユーザーを待っている `reviewer` セッションを表示します。
 
-フィルターが有効な間は、折りたたんだグループが展開されて一致するセッションが表示され、最初の一致が選択されるため、`Enter` を押すとそのセッションが開きます。入力をクリアするとフィルターが解除され、それらのグループは再び折りたたまれます。
+フィルターが有効な間は、折りたたんだグループが展開されて一致するセッションが表示され、一致するセッションが選択されるため、`Enter` を押すとそのセッションが開きます。入力をクリアするとフィルターが解除され、それらのグループは再び折りたたまれます。
 
 <h3 id="keyboard-shortcuts">
@@ -370,4 +370,6 @@ Claude Code v2.1.212 以降でセッションを戻すには、ディスパッ
 | `Ctrl+S` | グループ化を状態とディレクトリの間で切り替え |
 | `Ctrl+T` | 選択したセッションをピン留めまたはピン留め解除 |
+| `Ctrl+F` | [`n:` フィルター](#filter-sessions) を使って名前でセッションを検索 |
+| `Alt+↑` / `Alt+↓` | 前または次のグループヘッダーにジャンプ |
 | `Ctrl+R` | 選択したセッションの名前を変更 |
 | `Ctrl+G` | `$VISUAL` または `$EDITOR` でディスパッチプロンプトを開く |
@@ -379,5 +381,5 @@ Claude Code v2.1.212 以降でセッションを戻すには、ディスパッ
 | `?` | すべてのショートカットを表示 |
 
-`Ctrl+S`、`Ctrl+T`、および `Ctrl+G` は [`keybindings.json`](/docs/ja/keybindings) に従います。`Ctrl+S` と `Ctrl+T` を [`Agents` コンテキスト](/docs/ja/keybindings#agents-actions) の `agents:switchView` と `agents:togglePin` アクションで再バインドまたはアンバインドし、`Ctrl+G` を `Chat` コンテキストの `chat:externalEditor` バインディングを通じて再バインドします。テーブル内の他のショートカットは再バインドできません。
+[`Agents` コンテキスト](/docs/ja/keybindings#agents-actions) にアクションがあるショートカットは、[`keybindings.json`](/docs/ja/keybindings) に従います。`Ctrl+G` も、`Chat` コンテキストの `chat:externalEditor` バインディングを通じて同様に従います。
 
 <h2 id="dispatch-new-agents">
@@ -1088,4 +1090,5 @@ Agent view はリサーチプレビュー中に急速に進化しました。古
 | バージョン | 変更 |
 | - | - |
+| v2.1.288 | `Ctrl+F` は名前でセッションを検索し、`Alt+↑` / `Alt+↓` はグループヘッダー間を移動します。これらのキーと `Ctrl+R` は[再割り当て](/docs/ja/keybindings#agents-actions)できます。 |
 | v2.1.287 | [`n:<text>` フィルター](#filter-sessions)は、名前または最初のプロンプトでセッションを検索します。いずれかのフィルターが有効な間は、折りたたんだグループが展開されて一致するセッションが表示され、最初の一致が選択されるため、`Enter` でそれを開けます。 |
```

</details>

<details>
<summary>amazon-bedrock-ja.md</summary>

```diff
diff --git a/docs-ja/pages/amazon-bedrock-ja.md b/docs-ja/pages/amazon-bedrock-ja.md
index 24ad7d6..8a4a587 100644
--- a/docs-ja/pages/amazon-bedrock-ja.md
+++ b/docs-ja/pages/amazon-bedrock-ja.md
@@ -387,4 +387,21 @@ Claude Code が Amazon Bedrock で設定されて起動する場合、使用予
 これらのチェックがアカウントが呼び出せないモデルを見つけた場合、Claude Code はこのマシンで最大 1 日間その拒否を記憶し、その時間中は Amazon Bedrock に再度問い合わせることなく記憶されたモデルをスキップして起動します。Claude Code は、現在のデフォルトモデルの記憶された拒否を、最後のチェック以降 10 分が経過すると起動時に再度チェックするため、管理者が再度有効にしたデフォルトが戻ります。メモリをオフにするには、[`CLAUDE_CODE_SKIP_MODEL_ACCESS_MEMORY=1`](/docs/ja/env-vars)を設定してください。
 
+<h3 id="when-your-organization-enforces-a-model-allowlist">
+  組織がモデルの許可リストを強制する場合
+</h3>
+
+管理設定で [`enforceAvailableModels`](/docs/ja/model-config#enforce-the-allowlist-for-the-default-model) を設定すると、スタートアップモデルチェックは `availableModels` リストで許可されたモデルのみを使用します。これは Amazon Bedrock Invoke API に適用され、Claude Code v2.1.287 以降が必要です。`enforceAvailableModels` のないリストでは、これらのチェックは制限されません。
+
+チェックは各エントリを、送信する推論プロファイル ID（[リージョンプレフィックス](#cross-region-inference-profile-prefixes)を含む）と比較するため、リストはそれらの ID で記述してください。この例では、モデルが `us.` プロファイルに解決されるデプロイに対して Opus 4.8 と Sonnet 4.5 を許可します。
+
+```json theme={null}
+{
+  "availableModels": ["us.anthropic.claude-opus-4-8", "us.anthropic.claude-sonnet-4-5-20250929-v1:0"],
+  "enforceAvailableModels": true
+}
+```
+
+エイリアス、バージョンプレフィックス、`modelOverrides` エントリについては、[サードパーティデプロイ用にモデルをピン留めする](/docs/ja/model-config#pin-models-for-third-party-deployments)を参照してください。
+
 <h3 id="when-a-model-is-disabled-mid-session">
   モデルがセッション中に無効化される場合
```

</details>

<details>
<summary>artifacts-ja.md</summary>

```diff
diff --git a/docs-ja/pages/artifacts-ja.md b/docs-ja/pages/artifacts-ja.md
index d02baa9..b279042 100644
--- a/docs-ja/pages/artifacts-ja.md
+++ b/docs-ja/pages/artifacts-ja.md
@@ -157,5 +157,5 @@ Claude がコメントを読めないと言う場合は、バージョン、セ
 </h3>
 
-セッションがアーティファクトを公開した後、Claude Code はセッションが実行されている限り、そのアーティファクトのコメントを監視します。アーティファクトを編集できるユーザーが Claude にコメントを送信すると、すぐにセッションに到達し、Claude はスレッドを読んで、あなたに尋ねることなく返信できます。
+セッションがアーティファクトを公開した後、Claude Code はそのアーティファクトのコメントを監視します。アーティファクトを編集できるユーザーが Claude にコメントを送信すると、すぐにセッションに到達し、Claude はスレッドを読んで、ユーザーが依頼しなくても返信できます。
 
 Claude Code v2.1.228 以降が必要です。[フィーチャーフラグ取得](/docs/ja/env-vars#features-that-need-feature-flag-fetching)をオフにした場合、Claude Code はコメントを監視しません。
@@ -175,4 +175,6 @@ Claude は、1 時間以内にそのアーティファクトで 60 件の送信
 * **3 秒以内に `Ctrl+X Ctrl+K` を 2 回押す**：[すべての実行中のバックグラウンドサブエージェントを停止](/docs/ja/interactive-mode#general-controls)するコードは、セッションの残りの間、Claude がすべてのアーティファクトに返信するのも停止します。Claude に返信を再開するよう求めても、この停止は元に戻りません。
 
+Claude Code が自動で開始した監視は、アーティファクトで数時間アクティビティがない状態が続くと終了することがあります。監視を再開するには、アーティファクトを再度公開するか、Claude に監視するよう依頼してください。
+
 コメントを配信するサービスが利用できなくなるか、応答を停止した場合、Claude Code はしばらく再接続を試み、その後、セッションが監視していた各アーティファクトの監視を停止します。
 
```

</details>

<details>
<summary>best-practices-ja.md</summary>

```diff
diff --git a/docs-ja/pages/best-practices-ja.md b/docs-ja/pages/best-practices-ja.md
index fde9194..04b4edc 100644
--- a/docs-ja/pages/best-practices-ja.md
+++ b/docs-ja/pages/best-practices-ja.md
@@ -480,8 +480,8 @@ Claude Code は会話をローカルに保存するため、タスクが複数
 </h2>
 
-1 つの Claude で効果的になったら、並列セッション、非対話型モード、ファンアウトパターンで出力を乗算します。
+1 つの Claude で効果的になったら、並列セッション、非対話モード、ファンアウトパターンで出力を乗算します。
 
 <h3 id="run-non-interactive-mode">
-  非対話型モードを実行する
+  非対話モードを実行する
 </h3>
 
@@ -490,5 +490,5 @@ Claude Code は会話をローカルに保存するため、タスクが複数
 </Tip>
 
-`claude -p "your prompt"` を使用すると、対話型プロンプトなしで Claude を非対話的に実行できます。実行は `--no-session-persistence` を渡さない限り、再開可能なセッションを作成します。[非対話型モード](/docs/ja/headless)は、Claude を CI パイプライン、プリコミットフック、または自動化されたワークフローに統合する方法です。出力形式を使用すると、結果をプログラムで解析できます。プレーンテキスト、JSON、またはストリーミング JSON です。
+`claude -p "your prompt"` を使用すると、対話的なプロンプトなしで Claude を非対話的に実行できます。実行は `--no-session-persistence` を渡さない限り、再開可能なセッションを作成します。[非対話モード](/docs/ja/headless)は、Claude を CI パイプライン、プリコミットフック、または自動化されたワークフローに統合する方法です。出力形式を使用すると、結果をプログラムで解析できます。プレーンテキスト、JSON、またはストリーミング JSON です。
 
 ```bash theme={null}
@@ -517,7 +517,7 @@ claude -p "Analyze this log file" --output-format stream-json --verbose
 * [Worktrees](/docs/ja/worktrees)：分離された git チェックアウトで個別の CLI セッションを実行して、編集が衝突しないようにします
 * [クロスセッションメッセージング](/docs/ja/cross-session-messaging)：自分で実行するセッションが相互に検出結果を渡すことができます
-* [デスクトップアプリ](/docs/ja/desktop#work-in-parallel-with-sessions)：複数のローカルセッションを視覚的に管理します。各セッションは独自の worktree にあります
-* [Web 上の Claude Code](/docs/ja/claude-code-on-the-web)：デフォルトで Anthropic が管理するインフラストラクチャ上のクラウドでセッションを実行します
-* [エージェントビュー](/docs/ja/agent-view)：研究プレビュー。`claude agents` を実行して、バックグラウンドで実行し続けるセッションをディスパッチし、1 つの画面から監視します
+* [デスクトップアプリ](/docs/ja/desktop#work-in-parallel-with-sessions)：複数のローカルセッションを視覚的に管理します。必要に応じて、各セッションを独自の worktree で実行できます
+* [クラウドで Claude Code を使用する](/docs/ja/claude-code-on-the-web)：デフォルトで Anthropic が管理するインフラストラクチャ上でセッションを実行します
```

</details>

<details>
<summary>channels-ja.md</summary>

```diff
diff --git a/docs-ja/pages/channels-ja.md b/docs-ja/pages/channels-ja.md
index ab6f59f..4f8f24b 100644
--- a/docs-ja/pages/channels-ja.md
+++ b/docs-ja/pages/channels-ja.md
@@ -327,5 +327,5 @@ iMessage は異なります。自分自身にテキストを送信するとゲ
 </h3>
 
-[**claude.ai → Admin settings → Claude Code → Channels**](https://claude.ai/admin-settings/claude-code) から組織のチャネルを有効にします。これには Owner ロールが必要です。または、管理設定で `channelsEnabled` を `true` に設定します。
+[**Organization settings > Claude Code > Channels**](https://claude.ai/admin-settings/claude-code) から組織のチャネルを有効にします。これには Owner ロールが必要です。または、管理設定で `channelsEnabled` を `true` に設定します。
 
 有効にすると、組織内のユーザーは `--channels` を使用して個別のセッションにチャネルサーバーをオプトインできます。設定が無効または未設定の場合、MCP サーバーは接続され、そのツールは機能しますが、チャネルメッセージは到着しません。スタートアップ警告は、ユーザーに管理者が設定を有効にするよう指示します。
```

</details>

<details>
<summary>claude-apps-gateway-config-ja.md</summary>

```diff
diff --git a/docs-ja/pages/claude-apps-gateway-config-ja.md b/docs-ja/pages/claude-apps-gateway-config-ja.md
index 8589a75..b09533e 100644
--- a/docs-ja/pages/claude-apps-gateway-config-ja.md
+++ b/docs-ja/pages/claude-apps-gateway-config-ja.md
@@ -83,10 +83,10 @@ OpenID Connect（OIDC）はゲートウェイがアイデンティティプロ
 | `allowed_groups` | いいえ | サインインをこれらの IdP グループのメンバーに制限します。`groups_claim` に対してマッチングされます。許可されたメールドメイン内にいるが、これらのグループのいずれにも属していないユーザーは拒否されます。IdP がグループクレームを発行する必要があります。マッチングは、そのクレーム内の値に対する正確で大文字と小文字を区別する文字列比較です。ゲートウェイはネストされたグループを展開しません。サブグループのメンバーを許可するには、ここにサブグループをリストするか、IdP を設定してフラット化されたメンバーシップを発行してください。 |
 | `groups_claim` | いいえ | グループメンバーシップを含む id\_token クレーム。デフォルト `groups`。Microsoft Entra はアプリロールを `roles` の下に発行します。フラットキーまたは `/resource_access/gateway/roles` などのネストされたクレーム用の RFC 6901 JSON ポインタを受け入れます。 |
-| `google_groups` | いいえ | Google Workspace Admin SDK Directory API を通じてサインインしたユーザーのグループを検索します。Google の id\_token はグループクレームを含まないためです。`service_account_json_path` を `https://www.googleapis.com/auth/admin.directory.group.readonly` スコープでドメイン全体の委任を持つサービスアカウントキーファイルに設定し、`admin_email` を Workspace 管理者に設定します。サービスアカウントが偽装します。Directory API は実際の管理者サブジェクトが必要です。各ユーザーのグループメールアドレスがそのグループクレームになるため、`allowed_groups` と `managed.policies.match.groups` はグループメールでマッチングします。 |
+| `google_groups` | いいえ | Google Workspace Admin SDK Directory API を通じてサインインしたユーザーのグループを検索します。Google の id\_token はグループクレームを含まないためです。`service_account_json_path` を `https://www.googleapis.com/auth/admin.directory.group.readonly` スコープでドメイン全体の委任を持つサービスアカウントキーファイルに設定し、`admin_email` をサービスアカウントが偽装する Workspace 管理者に設定します。Directory API は実際の管理者サブジェクトを必要とします。各ユーザーのグループメールアドレスがそのグループクレームになるため、`allowed_groups` と `managed.policies.match.groups` はグループメールでマッチングします。 |
 | `email_claim` | いいえ | ユーザーのメールを含む id\_token クレーム。デフォルト `email`。ADFS や Entra B2C などの一部の IdP は、代わりに `upn` または `preferred_username` を発行します。フラットキー、JSON ポインタ、または最初に存在するキーが使用されるフォールバックキーのリストを受け入れます。 |
-| `scopes` | いいえ | ゲートウェイが要求する OIDC スコープの完全なオーバーライド。デフォルト `[openid, profile, email, offline_access]`。IdP が認識しないスコープを拒否する場合、またはグループまたはメールを発行するためにカスタムスコープが必要な場合に設定します。`openid` を含める必要があります。`offline_access` を削除するとリフレッシュトークンが無効になるため、開発者は `session.ttl_hours` ごとにブラウザログインを再実行します。IdP ごとのスコープレシピ（Google のリフレッシュトークンフローなど）については、[アイデンティティプロバイダーのセットアップ](/docs/ja/claude-apps-gateway-deploy#identity-provider-setup)を参照してください。 |
-| `scope_on_refresh` | いいえ | リフレッシュトークンを交換するときに、サインインリクエストと同じリストで `scope` も送信します。デフォルト `false`：リフレッシュリクエストは `scope` を省略します。ほとんどの IdP はすべてのリフレッシュで id\_token を返し、これを必要としません。IdP がリフレッシュ時に id\_token を返す場合にのみ `true` に設定します。`openid` を再度要求された場合。Okta はそのリフレッシュグラントについてこれを文書化しています。id\_token がない場合、すべてのリフレッシュは IdP の userinfo エンドポイントが更新されたアクセストークンを受け入れることに依存します。サインインをゲートしたり、グループのポリシーをマッチングしたりする場合、IdP のリフレッシュ時 id\_token がそれらを省略する場合は、`userinfo_fallback: true` も設定して、ゲートウェイが userinfo エンドポイントからそれらを入力するようにしてください。要求されたスコープより少ないスコープを付与した IdP は、これがオンの場合、既存のセッションの場合でも `invalid_scope` でリフレッシュを拒否できます。`token_endpoint` でリフレッシュが失敗し始めた場合は、キーを設定した後、キーを設定解除してください。ゲートウェイサーバーで Claude Code v2.1.260 以降が必要です。 |
-| `extra_auth_params` | いいえ | IdP 認可リクエストに逐語的に追加される追加クエリパラメータ。これは、Google リフレッシュトークンの `access_type: offline`、一部の Entra テナントの `domain_hint`、またはステップアップフローの `acr_values` など、IdP 固有の動作のオーバーライドメカニズムです。ゲートウェイが管理するプロトコルパラメータはオーバーライドできません：`state`、`nonce`、`redirect_uri`、PKCE、`scope`、`response_type`、`response_mode`、および `client_id`。 |
-| `userinfo_fallback` | いいえ | id\_token がメールまたはグループを省略する場合、`/userinfo` からそれらを取得します。Keycloak 軽量アクセストークン、Okta org サーバー、および ADFS 最小トークンに必要です。id\_token は権限のままです。userinfo はギャップのみを埋めます。デフォルト `false`。 |
+| `scopes` | いいえ | ゲートウェイが要求する OIDC スコープの完全な上書き。デフォルト `[openid, profile, email, offline_access]`。IdP が認識しないスコープを拒否する場合、またはグループまたはメールを発行するためにカスタムスコープが必要な場合に設定します。`openid` を含める必要があります。`offline_access` を削除するとリフレッシュトークンが無効になるため、開発者は `session.ttl_hours` ごとにブラウザログインを再実行します。IdP ごとのスコープレシピ（Google のリフレッシュトークンフローなど）については、[アイデンティティプロバイダーのセットアップ](/docs/ja/claude-apps-gateway-deploy#identity-provider-setup)を参照してください。 |
+| `scope_on_refresh` | いいえ | ゲートウェイがリフレッシュトークンを交換するときに、サインインリクエストと同じリストで `scope` も送信します。デフォルト `false`：リフレッシュリクエストは `scope` を省略します。ほとんどの IdP はリフレッシュのたびに id\_token を返すため、この設定は不要です。IdP が再度 `openid` を要求された場合にのみリフレッシュ時に id\_token を返す場合（Okta はリフレッシュグラントについてこれを文書化しています）は `true` に設定します。id\_token がない場合、すべてのリフレッシュは、IdP の userinfo エンドポイントがリフレッシュされたアクセストークンを受け入れることに依存します。グループに基づいてサインインを制限したりポリシーをマッチングしたりしていて、IdP のリフレッシュ時の id\_token にグループが含まれない場合は、`userinfo_fallback: true` も設定して、ゲートウェイが userinfo エンドポイントからグループを補完するようにしてください。要求より少ないスコープを付与した IdP は、`invalid_scope` でリフレッシュを拒否することがあります。これがオンの間に `scopes` にエントリを追加した場合は、既存のセッションも対象になります。設定後に `token_endpoint` でリフレッシュが失敗し始めた場合は、このキーを削除してください。ゲートウェイサーバーで Claude Code v2.1.260 以降が必要です。 |
+| `extra_auth_params` | いいえ | IdP 認可リクエストに逐語的に追加される追加クエリパラメータ。これは、Google リフレッシュトークンの `access_type: offline`、一部の Entra テナントの `domain_hint`、またはステップアップフローの `acr_values` など、IdP 固有の動作を上書きするための仕組みです。ゲートウェイが管理するプロトコルパラメータは上書きできません：`state`、`nonce`、`redirect_uri`、PKCE、`scope`、`response_type`、`response_mode`、および `client_id`。 |
+| `userinfo_fallback` | いいえ | id\_token がメールまたはグループを省略する場合、`/userinfo` からそれらを取得します。Keycloak 軽量アクセストークン、Okta org サーバー、および ADFS 最小トークンに必要です。id\_token が引き続き正とされ、userinfo は不足分のみを補完します。デフォルト `false`。 |
 | `use_pkce` | いいえ | 認可リクエストで PKCE（S256）チャレンジを送信します。デフォルト `true`。IdP がこの機密クライアントの PKCE を拒否する場合のみ `false` に設定します。 |
 | `clock_skew_seconds` | いいえ | id\_token 時間クレームを検証するときにクロックドリフトを許容します。デフォルト `0`（厳密）。サインイン直後にホスト/IdP クロックスキューのため「トークン期限切れ/まだ有効でない」エラーが表示される場合は、これを上げてください。 |
@@ -164,7 +164,7 @@ Microsoft Entra が証明書の認証情報で行うように、アイデンテ
 </h4>
 
-推論アップストリームはすべてのバージョンで `HTTPS_PROXY` と `HTTP_PROXY` を尊重します。ゲートウェイ独自の IdP、検出、JWKS、トークン、および userinfo へのリクエストは、`oidc.use_proxy: true` を設定しない限り直接です。v2.1.227 以降が必要です。プロキシ変数が設定され、`use_proxy` が設定解除され、発行者が `NO_PROXY` でカバーされていない場合、ゲートウェイはそれらのリクエストを直接に保ち、ブート時に選択するよう求める通知をログに記録します。`use_proxy: false` はそれらを直接に保ち、通知をサイレンスします。
+推論アップストリームはすべてのバージョンで `HTTPS_PROXY` と `HTTP_PROXY` を尊重します。ゲートウェイ独自の IdP、検出、JWKS、トークン、および userinfo へのリクエストは、`oidc.use_proxy: true` を設定しない限り直接です。これには v2.1.227 以降が必要です。プロキシ変数が設定され、`use_proxy` が設定されておらず、発行者が `NO_PROXY` でカバーされていない場合、ゲートウェイはそれらのリクエストを直接に保ち、ブート時に選択するよう求める通知をログに記録します。`use_proxy: false` はそれらを直接に保ち、通知を抑止します。
 
-`use_proxy: true` の場合、ポッドは各 IdP エンドポイントのホスト名を自身で解決し、プロキシに解決された IP アドレスへの `CONNECT` を要求します。プロキシは、発行者だけでなく、検出ドキュメントが名前を付けるすべてのホストの IP アドレスへの `CONNECT` を受け入れる必要があります。`http://` プロキシ URL を使用します。`ca_cert_pem` と[SSRF ガード](/docs/ja/claude-apps-gateway-deploy#threat-model-summary)はプロキシされたパスにも適用されます。
+`use_proxy: true` の場合、ポッドは各 IdP エンドポイントのホスト名を自身で解決し、プロキシに解決された IP アドレスへの `CONNECT` を要求します。プロキシは、発行者だけでなく、検出ドキュメントが名前を付けるすべてのホストの IP アドレスへの `CONNECT` を受け入れる必要があります。`http://` プロキシ URL を使用します。`ca_cert_pem` と [SSRF ガード](/docs/ja/claude-apps-gateway-deploy#threat-model-summary)はプロキシされたパスにも適用されます。
 
 [プロキシのみのエグレス](#proxy-only-egress)はこれらの両方を変更します。アクティブな場合、IdP リクエストは `use_proxy: false` を設定しない限りプロキシに従い、ゲートウェイは最初にそれを解決せずにプロキシに各 IdP ホスト名を渡します。
```

</details>

*...以降省略*

</details>


<details>
<summary>2026-10-04</summary>

**変更ファイル:**

```
 docs-ja/pages/agent-teams-ja.md             |  8 +++++---
 docs-ja/pages/changelog.md                  | 30 +++++++++++++++++++++++++++++
 docs-ja/pages/channels-ja.md                |  2 +-
 docs-ja/pages/code-review-ja.md             | 11 +++++++----
 docs-ja/pages/computer-use-ja.md            |  2 +-
 docs-ja/pages/desktop-ja.md                 |  4 ++--
 docs-ja/pages/desktop-scheduled-tasks-ja.md |  2 +-
 docs-ja/pages/env-vars-ja.md                |  4 ++--
 docs-ja/pages/hooks-guide-ja.md             |  2 +-
 docs-ja/pages/hooks-ja.md                   | 16 +++++++++++----
 docs-ja/pages/llm-gateway-protocol-ja.md    |  2 +-
 docs-ja/pages/mcp-ja.md                     |  6 ++++--
 docs-ja/pages/monitoring-usage-ja.md        |  2 +-
 docs-ja/pages/voice-dictation-ja.md         |  3 ++-
 docs-ja/pages/vs-code-ja.md                 |  7 +++++++
 15 files changed, 77 insertions(+), 24 deletions(-)
```

<details>
<summary>agent-teams-ja.md</summary>

```diff
diff --git a/docs-ja/pages/agent-teams-ja.md b/docs-ja/pages/agent-teams-ja.md
index ad7c199..a91adb6 100644
--- a/docs-ja/pages/agent-teams-ja.md
+++ b/docs-ja/pages/agent-teams-ja.md
@@ -173,5 +173,5 @@ Claude Code は、チームメンバーに対して選択したモデルを、
 * **プロバイダー固有のモデル ID を持つプロバイダーで代替が動作しないファミリーエイリアス、またはそのファミリーに許可されたバージョンがないもの、またはその他のブロックされた値**：Claude Code はチームメンバーをリーダーのモデルで実行します。`CLAUDE_CODE_SUBAGENT_MODEL` を設定した場合、Claude Code はそのモデルを最初に試し、これらの同じルールの下で実行します。
 
-チームメンバーはリーダーの[努力レベル](/docs/ja/model-config#adjust-effort-level)を継承します。分割ペインモードではこれは v2.1.186 から適用されます。それより前のバージョンではリーダーのセッション努力を分割ペインチームメンバーに渡しませんでした。
+デフォルトでは、チームメンバーはリーダーの [effort レベル](/docs/ja/model-config#adjust-effort-level)を継承します。分割ペインモードではこれは v2.1.186 から適用されます。それより前のバージョンではリーダーのセッションの effort を分割ペインのチームメンバーに渡していませんでした。
 
 <h3 id="have-teammates-plan-before-implementing">
@@ -201,5 +201,5 @@ In-process チームメイトを表示している間、プレーンテキスト
 * `/model` と `/fast` はチームメイトではなくリーダーのモデルと fast mode を設定するため、このビューからは実行されません。その理由を示す通知が表示されます。
 
-チームメイトのモデルと fast mode は、スポーン時に固定されます。`/effort` は引き続き表示中のチームメイトの後続のターンに適用されます。これはチームメイトがリーダーの [effort レベル](/docs/ja/model-config#adjust-effort-level)に従うためです。
+チームメイトのモデルと fast mode は、スポーン時に固定されます。
 
 <h3 id="assign-and-claim-tasks">
@@ -294,5 +294,5 @@ Claude Code はセッション起動時にこれらの両方を自動的に生
 </h3>
 
-どちらの表示モードでもチームメンバーを生成するときに、プロジェクト、ユーザー、または管理対象の [subagent スコープ](/docs/ja/sub-agents#choose-the-subagent-scope) から [subagent](/docs/ja/sub-agents) タイプを参照できます。これにより、セキュリティレビュアーやテストランナーなどのロールを 1 回定義し、委任された subagent とエージェントチームチームメンバーの両方として再利用できます。
+どちらの表示モードでもチームメイトを生成するときに、プロジェクト、ユーザー、管理対象、またはプラグインの [サブエージェントスコープ](/docs/ja/sub-agents#choose-the-subagent-scope) から [サブエージェント](/docs/ja/sub-agents) タイプを参照できます。これにより、セキュリティレビュアーやテストランナーなどのロールを 1 回定義し、委任されたサブエージェントとエージェントチームのチームメイトの両方として再利用できます。
 
 subagent 定義を使用するには、Claude にチームメンバーを生成するよう指示するときに名前で言及してください。
@@ -306,4 +306,6 @@ Claude Code は名前を付けた subagent 定義を読み取り、これらの
 * **`tools`**：Claude Code はチームメンバーを定義の `tools` リスト内のツールに制限します。インプロセスチームメンバーの場合、Claude Code はそのリストに `SendMessage` を追加し、[Task ツールを持つセッション](/docs/ja/tools-reference#task-tool-availability) では `TaskCreate`、`TaskGet`、`TaskList`、および `TaskUpdate` も追加します。
 * **`model`**：Claude Code は、生成プロンプトが 1 つを名前で指定しない場合、どちらの表示モードでも定義の `model` を使用します。[Claude Code がチームメンバーのモデルを選択する方法](#specify-teammates-and-models) を参照してください。
+* **`disallowedTools`**：インプロセスのチームメイトの場合、Claude Code は定義の `disallowedTools` にあるツールをチームメイトのツールセットから削除します。`SendMessage` と Claude Code が追加する Task ツールは、リストに記載されていても引き続き使用できます。
+* **`effort`**：インプロセスのチームメイトの場合、Claude Code は [フロントマターの effort ルール](/docs/ja/model-config#set-the-effort-level) に従って定義の [`effort`](/docs/ja/sub-agents#supported-frontmatter-fields) を適用します。
```

</details>

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index 26c998f..0185085 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,34 @@
 # Changelog
 
+## 2.1.289
+
+- Fixed a deny or ask rule on a nested part of a compound shell command not holding over a user-installed mod's approval on managed machines
+- Fixed the terminal freezing on short code blocks with many unclosed `<script>` tags or deeply nested `${` substitutions
+- Fixed `Read` deny rules not applying to files @-mentioned, changed, or selected in the IDE through a symlink
+- [VSCode] Reverted a 2.1.288 change to `claude auth status` that may have made sign-outs more frequent
+- Improved how quickly large files open in a plugin code pane by laying the highlighted view out once at its final width
+- Fixed `plugin list`, `plugin eval` and `plugin update` showing a stale copy of a plugin installed from a local folder marketplace, and hot reload for a symlinked `--plugin-dir`
+- Fixed installed mods not loading in the first session after an upgrade
+- Fixed a plugin's rows above the prompt showing a stale row while the Background tasks dialog was open in fullscreen
+- Fixed plugin panes drawing nothing when a link used a localhost address, an `@` in its path, an uppercase host or a `file:` path
+- Fixed a user-installed plugin being able to rewrite the descriptions of an organization-managed MCP server's sign-in tools
+- Fixed a freeze or forced quit at launch when a plugin drew a Box with a border style the terminal does not know
+- Fixed supervised and background sessions ending when a plugin's on-screen handler threw asynchronously
+- Fixed sessions ending with an interface error when a plugin region with no height kept growing
+- Fixed Bash deny and ask rules missing a command behind an environment variable prefix with an expanded value (e.g. `TZ="$HOME" rm -rf build`) when the sandbox auto-allows commands
+- Fixed a Bash deny or ask rule being skipped under sandbox auto-allow when a bare variable assignment came before the command
+- Fixed `claude plugin validate` skipping the plugin when the folder also holds a marketplace manifest
+- Added `agent.spawn` for teammates, one agent id across plugin hook events, and idle and waiting states in `$.agent.list()`
+- Fixed sessions ending with "unrecoverable interface error" when a value a mod's `ui.render` hook wrote made a row throw while drawn; the engine now draws its own row instead
+- Fixed text with a tab, a stray escape and a C1 control, or a short text with a tab and CRLF line endings, drawing over the rows below it
+- Fixed right-aligned content in a mod's pane or band drawing under the close mark or `[-]`, which now also keep one column in from the terminal's edge
+- Fixed a mod's `Client` that fails while drawn taking down everything the mod drew around it; it now fails alone and raises `ui.fault`
```

</details>

<details>
<summary>channels-ja.md</summary>

```diff
diff --git a/docs-ja/pages/channels-ja.md b/docs-ja/pages/channels-ja.md
index 1aa2b27..ab6f59f 100644
--- a/docs-ja/pages/channels-ja.md
+++ b/docs-ja/pages/channels-ja.md
@@ -350,5 +350,5 @@ iMessage は異なります。自分自身にテキストを送信するとゲ
 空の配列を設定すると、許可リストからすべてのチャネルプラグインをブロックしますが、`--dangerously-load-development-channels` はローカルテストのためにそのブロックをバイパスできます。開発フラグを含むチャネルを完全にブロックするには、代わりに `channelsEnabled` を設定されていないままにします。
 
-この設定には `channelsEnabled: true` が必要です。ユーザーが `--channels` にリストにないプラグインを渡す場合、Claude Code は通常起動しますが、チャネルは登録されず、スタートアップ通知はプラグインが組織の承認リストにないことを説明します。v2 MCP クライアントランタイムで `MCP_PROTOCOL_NEGOTIATION` を `auto` に設定した場合、Claude Code が[プロトコルリビジョン 2026-07-28 をネゴシエートするチャネルサーバーを登録しない](/docs/ja/mcp#push-messages-with-channels)ため、チャネルも登録に失敗する可能性があります。
+この設定には `channelsEnabled: true` が必要です。ユーザーが `--channels` にリストにないプラグインを渡す場合、Claude Code は通常起動しますが、チャネルは登録されず、スタートアップ通知はプラグインが組織の承認リストにないことを説明します。v2 MCP クライアントランタイムでは、Claude Code が[プロトコルリビジョン 2026-07-28 をネゴシエートするチャネルサーバーを登録しない](/docs/ja/mcp#push-messages-with-channels)ため、チャネルが登録に失敗することもあります。
 
 <h2 id="research-preview">
```

</details>

<details>
<summary>code-review-ja.md</summary>

```diff
diff --git a/docs-ja/pages/code-review-ja.md b/docs-ja/pages/code-review-ja.md
index 5224636..ae1276f 100644
--- a/docs-ja/pages/code-review-ja.md
+++ b/docs-ja/pages/code-review-ja.md
@@ -303,9 +303,12 @@ PR 作成後に 1 回または手動モードでは、`@claude review always` 
 レビューを再度実行するには、PR で `@claude review` とコメントしてください。これは PR を今後のプッシュにサブスクライブせずに新しいレビューを開始します。PR が [フォークから](#review-pull-requests-from-forks) のものでない場合、GitHub の Checks タブの **Claude Code Review** チェックで **Re-run** をクリックすることもできます。再実行も PR をサブスクライブせずに新しいレビューを開始します。
 
-<h3 id="review-didn’t-run-and-the-pr-shows-a-spend-cap-message">
-  レビューが実行されず、PR が支出上限メッセージを表示する
+<h3 id="review-didn’t-run-and-the-pr-shows-a-budget-message">
+  レビューが実行されず、PR に予算に関するメッセージが表示される
 </h3>
 
-組織の月次支出上限に達すると、Code Review は PR に単一のコメントを投稿し、レビューがスキップされたことを説明します。レビューは次の請求期間の開始時に自動的に再開されるか、管理者が [claude.ai/admin-settings/usage](https://claude.ai/admin-settings/usage) で上限を引き上げるとすぐに再開されます。
+組織の Code Review の月次支出上限に達した場合、または使用クレジットの残高を使い切った場合、Code Review はレビューをスキップし、PR に単一のコメントを投稿します。コメントとチェック実行カードの両方に原因が示され、管理者が問題を解決するための管理ページへのリンクが記載されます：
+
+* **支出上限に達した場合**: レビューは次の請求期間の開始時に再開されるか、管理者が [claude.ai/admin-settings/usage](https://claude.ai/admin-settings/usage) で上限を引き上げるとすぐに再開されます
+* **使用クレジットを使い切った場合**: 管理者が [claude.ai/admin-settings/usage](https://claude.ai/admin-settings/usage) で [使用クレジット](https://support.claude.com/en/articles/12429409-extra-usage-for-paid-claude-plans) を追加すると、レビューが再開されます
 
 <h3 id="find-issues-that-aren’t-showing-as-inline-comments">
@@ -323,5 +326,5 @@ PR 作成後に 1 回または手動モードでは、`@claude review always` 
 </h2>
 
-[`/code-review` コマンド](/docs/ja/commands)はターミナルで差分をレビューし、GitHub App をインストールせずに実行します。正確性バグと再利用、簡素化、効率化のクリーンアップを報告します。
+[`/code-review` コマンド](/docs/ja/commands)はターミナルで差分をレビューし、GitHub App をインストールせずに実行します。正確性バグを報告します。モデルと effort レベルによっては、レビューは再利用、簡素化、効率化のクリーンアップも対象にします。
 
 `/review` は `/code-review` のエイリアスです。v2.1.223 より前は、GitHub プルリクエストの単一パス読み取り専用レビューを実行する別のコマンドでした。
```

</details>

<details>
<summary>computer-use-ja.md</summary>

```diff
diff --git a/docs-ja/pages/computer-use-ja.md b/docs-ja/pages/computer-use-ja.md
index b07cd49..8c1e2b4 100644
--- a/docs-ja/pages/computer-use-ja.md
+++ b/docs-ja/pages/computer-use-ja.md
@@ -211,5 +211,5 @@ CLI と Desktop サーフェスは同じコンピュータ使用エンジンを
 | :- | :- | :- |
 | プラットフォーム | macOS と Windows | macOS のみ |
-| 有効化 | **Settings > General** のトグル（**Desktop app** の下） | `/mcp` で `computer-use` を有効化 |
+| 有効化 | **Settings > This computer > System** のトグル | `/mcp` で `computer-use` を有効化 |
 | 拒否されたアプリリスト | 設定で設定可能 | まだ利用できません |
 | 自動非表示トグル | オプション | 常にオン |
```

</details>

<details>
<summary>desktop-ja.md</summary>

```diff
diff --git a/docs-ja/pages/desktop-ja.md b/docs-ja/pages/desktop-ja.md
index d37bd0c..c670439 100644
--- a/docs-ja/pages/desktop-ja.md
+++ b/docs-ja/pages/desktop-ja.md
@@ -333,5 +333,5 @@ Claude はアプリまたはサービスと対話するための複数の方法
 
   <Step title="トグルをオンにする">
-    デスクトップアプリで、**Settings > General**（**Desktop app**の下）に移動します。**Computer use**トグルを見つけてオンにします。Windows では、トグルはすぐに有効になり、セットアップは完了です。macOS では、次のステップに進みます。
+    デスクトップアプリで、**Settings > This computer > System** に移動します。**Computer use** の下で **Enable computer use** をオンにします。Windows では、トグルはすぐに有効になり、セットアップは完了です。macOS では、次のステップに進みます。
 
     トグルが表示されない場合は、macOS または Windows で Pro または Max プランを使用していることを確認してから、アプリを更新して再起動します。
@@ -364,5 +364,5 @@ Claude が初めてアプリを使用する必要がある場合、セッショ
 Terminal、Finder または File Explorer、System Settings または Settings などの広範なリーチを持つアプリは、承認が何を付与するかを知るようにプロンプトに追加の警告を表示します。
 
-**Settings > General**（**Desktop app**の下）で 2 つの設定を設定できます：
+**Settings > This computer > System** の **Computer use** セクションには、次のオプションがあります：
 
 * **Denied apps**：ここにアプリを追加して、プロンプトなしで拒否します。Claude は許可されたアプリのアクションを通じて拒否されたアプリに間接的に影響を与える可能性がありますが、拒否されたアプリと直接対話することはできません。
```

</details>

<details>
<summary>desktop-scheduled-tasks-ja.md</summary>

```diff
diff --git a/docs-ja/pages/desktop-scheduled-tasks-ja.md b/docs-ja/pages/desktop-scheduled-tasks-ja.md
index c75fb7a..f989b9b 100644
--- a/docs-ja/pages/desktop-scheduled-tasks-ja.md
+++ b/docs-ja/pages/desktop-scheduled-tasks-ja.md
@@ -76,5 +76,5 @@ Schedule コントロールからプリセットを選択します。
 タスクが実行されると、デスクトップ通知が表示され、新しいセッションがサイドバーの **Scheduled** セクションの下に表示されます。それを開いて、Claude が何をしたかを確認し、変更をレビューするか、権限プロンプトに応答します。Claude はファイルを編集し、コマンドを実行し、コミットを作成し、プルリクエストを開くことができます。これはセッションを自分で開始する場合と同じですが、Desktop アプリのセッション表面を通じて [デスクトップセッション間でメッセージを送受信](/docs/ja/desktop#work-across-sessions) することはできません。
 
-タスクは Desktop アプリが実行されていて、コンピュータが起動している場合にのみ実行されます。コンピュータがスケジュール設定された時刻を通じてスリープ状態になった場合、実行はスキップされます。アイドルスリープを防ぐには、Settings の **Desktop app → General** で **Keep computer awake** を有効にします。ラップトップのふたを閉じるとスリープ状態になります。コンピュータがオフの場合でも実行する必要があるタスク、または API 呼び出しや GitHub イベントでトリガーする必要があるタスクの場合は、代わりにリモート [routine](/docs/ja/routines) を作成します。
+タスクは Desktop アプリが実行されていて、コンピュータが起動している場合にのみ実行されます。コンピュータがスケジュール設定された時刻を通じてスリープ状態になった場合、実行はスキップされます。アイドルスリープを防ぐには、**Settings > This computer > System** で **Keep computer awake** をオンにします。ラップトップのふたを閉じるとスリープ状態になります。コンピュータがオフの場合でも実行する必要があるタスク、または API 呼び出しや GitHub イベントでトリガーする必要があるタスクの場合は、代わりにリモート [ルーティン](/docs/ja/routines) を作成します。
 
 <h2 id="missed-runs">
```

</details>

<details>
<summary>env-vars-ja.md</summary>

```diff
diff --git a/docs-ja/pages/env-vars-ja.md b/docs-ja/pages/env-vars-ja.md
index 1463652..4e32964 100644
--- a/docs-ja/pages/env-vars-ja.md
+++ b/docs-ja/pages/env-vars-ja.md
@@ -480,5 +480,5 @@ Claude Code はスタートアップ時にシェル環境変数を読み込む
 | `MCP_DISCOVERY_CACHE_TTL_S` | Claude Code が[ディスカバリーキャッシュ](/docs/ja/mcp#server-status-detail)エントリを更新せずに使用する秒数（デフォルト: 900）。エントリがそれより古い状態で起動すると、Claude Code はそのエントリを引き続き使用しますが、バックグラウンドで更新します。エントリが `MCP_DISCOVERY_CACHE_MAX_STALE_S` より古くなると、Claude Code は代わりにそのエントリを破棄します。Claude Code は値の上限を `MCP_DISCOVERY_CACHE_MAX_STALE_S`（デフォルトは 4 時間）とします。v2.1.238 より前は、Claude Code は値に上限を設けていませんでした |
 | `MCP_OAUTH_CALLBACK_PORT` | OAuth リダイレクトコールバック用の固定ポート。[事前設定された認証情報](/docs/ja/mcp#use-pre-configured-oauth-credentials)で MCP サーバーを追加する際の `--callback-port` の代替です |
-| `MCP_PROTOCOL_NEGOTIATION` | [v2 MCP クライアントランタイム](/docs/ja/mcp#mcp-client-runtimes)でのみ、Claude Code がサーバーに対して MCP プロトコルリビジョン 2026-07-28 をプローブするかどうかを指定します。`auto` に設定すると、HTTP、claude.ai コネクタ、stdio サーバーをプローブします。プローブに応答しないサーバーは、SSE および WebSocket サーバーが常にそうであるように、代わりに以前のプロトコルで接続します。`legacy` に設定すると、すべてのサーバーでプローブをスキップします。この変数がない場合、Claude Code は HTTP サーバーをプローブし、[機能フラグを取得する](#features-that-need-feature-flag-fetching)セッションでは claude.ai コネクタサーバーもプローブします。その他の値は、デバッグログに警告を出して無視されます。Claude Code v2.1.221 以降が必要です |
+| `MCP_PROTOCOL_NEGOTIATION` | [v2 MCP クライアントランタイム](/docs/ja/mcp#mcp-client-runtimes)でのみ有効で、Claude Code が MCP プロトコルリビジョン 2026-07-28 についてサーバーをプローブするかどうかを指定します。HTTP、claude.ai コネクタ、stdio サーバーをプローブするには `auto`、どれもプローブしないようにするには `legacy` に設定します。変数が未設定の場合、Claude Code は [MCP クライアントランタイム](/docs/ja/mcp#mcp-client-runtimes)で説明されているサーバーをプローブします。その他の値は、デバッグログに警告を出力したうえで無視されます。Claude Code v2.1.221 以降が必要です |
 | `MCP_REMOTE_SERVER_CONNECTION_BATCH_SIZE` | 起動時に並行して接続するリモート MCP サーバー（HTTP/SSE）の最大数（デフォルト: 20） |
 | `MCP_SDK_GENERATION` | このプロセスが MCP サーバーへの接続に使用する [MCP クライアントランタイム](/docs/ja/mcp#mcp-client-runtimes)を固定します。MCP TypeScript SDK 1.x 上に構築された `v1`、または [MCP TypeScript SDK 2.0](https://ts.sdk.modelcontextprotocol.io/v2/) 上に構築された `v2` を指定します。この変数がない場合、Claude Code はそのセクションに記載されているバージョン以降で v2 を使用します。Claude Code v2.1.221 以降では、v2 ランタイムは MCP OAuth サーバーが認可レスポンスで返す発行者を確認し、一致しない場合は `Issuer mismatch in authorization response` で始まるエラーでサインインを失敗させます。v1 ランタイムはこの確認を行いません。認識されない値を設定した場合、Claude Code はそれを無視し、デバッグログに警告を書き込みます。Claude Code はプロセスごとに 1 回だけ値を読み取ります。Claude Code v2.1.218 以降が必要です |
@@ -548,5 +548,5 @@ Claude Code は Anthropic から取得するフィーチャーフラグを通じ
 * [アーティファクトのコメント](/docs/ja/artifacts#collect-comments-on-an-artifact) を読むか返信すること
 * Claude に [別の組織の公開アーティファクト](/docs/ja/artifacts#read-an-artifact-shared-with-you) を読ませること
-* `MCP_PROTOCOL_NEGOTIATION=auto` を設定していない限り、Claude Code が claude.ai コネクタサーバーに [MCP プロトコルリビジョン 2026-07-28](/docs/ja/mcp#mcp-client-runtimes) をプローブさせること
+* `MCP_PROTOCOL_NEGOTIATION=auto` を設定していない限り、Claude Code に claude.ai コネクタサーバーまたは stdio サーバーに対して [MCP プロトコルリビジョン 2026-07-28](/docs/ja/mcp#mcp-client-runtimes) をプローブさせること
 * Git Bash がインストールされている Windows 上の claude.ai および Console アカウント用に、デフォルトで [PowerShell ツール](/docs/ja/tools-reference#powershell-tool) を取得すること。Claude Code は `CLAUDE_CODE_USE_POWERSHELL_TOOL=1` を設定していない限り、シェルコマンドを Git Bash 経由でルーティングします。Git Bash がない Windows では、ツールはオンのままです
 * [Claude が作成したフィードバック](/docs/ja/tools-reference#sendfeedback-tool-behavior) を取得すること。Claude Code はこれを取得されたフラグを通じてオンにします
```

</details>

<details>
<summary>hooks-guide-ja.md</summary>

```diff
diff --git a/docs-ja/pages/hooks-guide-ja.md b/docs-ja/pages/hooks-guide-ja.md
index 7205b42..e4c43dc 100644
--- a/docs-ja/pages/hooks-guide-ja.md
+++ b/docs-ja/pages/hooks-guide-ja.md
@@ -504,5 +504,5 @@ Claude Code は、ライフサイクルの特定のポイントで hook イベ
 | `SessionStart` | セッションが開始または再開されたとき |
 | `Setup` | `--init-only` で Claude Code を起動するとき、または `-p` モードで `--init` または `--maintenance` を使用するとき。CI またはスクリプトでの 1 回限りの準備用 |
-| `UserPromptSubmit` | プロンプトを送信するとき、Claude が処理する前 |
+| `UserPromptSubmit` | プロンプトを送信するとき、Claude が処理する前。[Claude Code が独自に開始するターン](/docs/ja/hooks#userpromptsubmit)でも発火します |
 | `UserPromptExpansion` | ユーザーが入力したコマンドがプロンプトに展開されるとき、Claude に到達する前。展開をブロックできます |
 | `PreToolUse` | ツール呼び出しが実行される前。ブロックできます |
```

</details>

*...以降省略*

</details>


<details>
<summary>2026-10-03</summary>

**変更ファイル:**

```
 docs-ja/pages/accessibility-ja.md                  |   10 +-
 docs-ja/pages/admin-setup-ja.md                    |    2 +-
 docs-ja/pages/advisor-ja.md                        |   42 +-
 docs-ja/pages/agent-teams-ja.md                    |    2 +-
 docs-ja/pages/agent-view-ja.md                     |    7 +-
 docs-ja/pages/agents-ja.md                         |    2 +-
 docs-ja/pages/amazon-bedrock-ja.md                 |    2 +-
 docs-ja/pages/artifacts-ja.md                      |   10 +
 docs-ja/pages/best-practices-ja.md                 |    2 +-
 docs-ja/pages/champion-kit-ja.md                   |   14 +-
 docs-ja/pages/changelog.md                         |   92 +
 docs-ja/pages/channels-ja.md                       |    8 +-
 docs-ja/pages/chrome-ja.md                         |   19 +-
 docs-ja/pages/claude-apps-gateway-config-ja.md     |  532 +++---
 docs-ja/pages/claude-apps-gateway-deploy-ja.md     |   76 +-
 .../pages/claude-apps-gateway-spend-limits-ja.md   |   15 +-
 docs-ja/pages/claude-code-on-the-web-ja.md         |   22 +-
 docs-ja/pages/claude-directory-ja.md               |   20 +-
 docs-ja/pages/claude-platform-on-aws-ja.md         |    2 +-
 docs-ja/pages/claude-projects-ja.md                |    2 +-
 docs-ja/pages/claude-security-ja.md                |    2 +-
 docs-ja/pages/cli-reference-ja.md                  |    6 +-
 docs-ja/pages/cloud-environments-ja.md             |    6 +-
 docs-ja/pages/code-review-ja.md                    |    3 +-
 docs-ja/pages/commands-ja.md                       |   11 +-
 docs-ja/pages/communications-kit-ja.md             |   29 +-
 docs-ja/pages/cross-session-messaging-ja.md        |   23 +-
 docs-ja/pages/debug-your-config-ja.md              |   30 +-
 docs-ja/pages/desktop-ja.md                        |   14 +-
 docs-ja/pages/desktop-linux-ja.md                  |    2 +-
 docs-ja/pages/env-vars-ja.md                       |  749 ++++----
 docs-ja/pages/errors-ja.md                         | 1829 +++++++++++---------
 docs-ja/pages/feature-availability-ja.md           |    2 +-
 docs-ja/pages/fullscreen-ja.md                     |    2 +-
 docs-ja/pages/glossary-ja.md                       |    2 +-
 docs-ja/pages/goal-ja.md                           |    4 +-
 docs-ja/pages/hooks-guide-ja.md                    |    8 +-
 docs-ja/pages/hooks-ja.md                          |  906 +++++-----
 docs-ja/pages/interactive-mode-ja.md               |   72 +-
 docs-ja/pages/keybindings-ja.md                    |   48 +-
 docs-ja/pages/large-codebases-ja.md                |    2 +-
 docs-ja/pages/llm-gateway-connect-ja.md            |    2 +-
 docs-ja/pages/llm-gateway-protocol-ja.md           |   21 +-
 docs-ja/pages/managed-mcp-ja.md                    |    1 +
 docs-ja/pages/managed-settings-ja.md               |   17 +-
 docs-ja/pages/mcp-ja.md                            |  111 +-
 docs-ja/pages/memory-ja.md                         |   13 +-
 docs-ja/pages/microsoft-foundry-ja.md              |   24 +-
 docs-ja/pages/model-config-ja.md                   |   34 +-
 docs-ja/pages/monitoring-usage-ja.md               | 1117 ++++++------
 docs-ja/pages/network-config-ja.md                 |    6 +
 docs-ja/pages/permission-modes-ja.md               |  316 ++--
 docs-ja/pages/permissions-ja.md                    |   12 +-
 docs-ja/pages/plugin-evals-ja.md                   |   12 +-
 docs-ja/pages/prompt-library-ja.md                 |  339 +++-
 docs-ja/pages/remote-control-ja.md                 |    6 +-
 docs-ja/pages/routines-ja.md                       |    8 +-
 docs-ja/pages/sandbox-environments-ja.md           |    2 +-
 docs-ja/pages/sandboxing-ja.md                     |  255 ++-
 docs-ja/pages/security-ja.md                       |    2 +-
 .../self-hosted-environments-configuration-ja.md   |  169 +-
 .../pages/self-hosted-environments-deploy-ja.md    |   11 +-
 .../pages/self-hosted-environments-identity-ja.md  |   10 +-
 docs-ja/pages/self-hosted-environments-ja.md       |   82 +-
 docs-ja/pages/sessions-ja.md                       |   17 +-
 docs-ja/pages/settings-reference-ja.md             |  582 ++++---
 docs-ja/pages/setup-ja.md                          |   25 +-
 docs-ja/pages/skills-ja.md                         |   11 +-
 docs-ja/pages/statusline-ja.md                     |   46 +-
 docs-ja/pages/sub-agents-ja.md                     |  133 +-
 docs-ja/pages/tools-reference-ja.md                |   38 +-
 docs-ja/pages/troubleshoot-install-ja.md           |   11 +
 docs-ja/pages/ultrareview-ja.md                    |   12 +-
 docs-ja/pages/vs-code-ja.md                        |   64 +-
 docs-ja/pages/workflows-ja.md                      |    4 +-
 docs-ja/pages/worktrees-ja.md                      |    4 +-
 76 files changed, 4628 insertions(+), 3520 deletions(-)
```

<!-- UPDATE_LOG_END -->
