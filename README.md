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

<!-- UPDATE_LOG_END -->
