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

<details>
<summary>accessibility-ja.md</summary>

```diff
diff --git a/docs-ja/pages/accessibility-ja.md b/docs-ja/pages/accessibility-ja.md
index 8a2fd7a..dcf7f5e 100644
--- a/docs-ja/pages/accessibility-ja.md
+++ b/docs-ja/pages/accessibility-ja.md
@@ -67,9 +67,9 @@ Claude Code は、ターミナルのスクロールバックに印刷するす
 Claude Code は起動時に [確認行](#turn-on-screen-reader-mode) を印刷した後、スクリーンリーダーが行を読み終えられるように、プロンプトを描画する前に 3 秒待機します。任意のキーを押すと待機を終了します。待機の長さを変更するには、[`CLAUDE_AX_STARTUP_QUIET_MS`](/docs/ja/env-vars#variables) を設定します。
 
-トランスクリプト内の各メッセージは、スクリーンリーダーが発表するラベルで始まり、それが何であるかを名前付けします：あなたのメッセージ、Claude の返信と思考、ツールアクティビティ、エラーと警告、およびプロンプト。ラベルは検索可能でもあるため、ターミナルのスクロールバックを検索してトランスクリプトのセクション間をジャンプできます：
+トランスクリプト内の各メッセージは、スクリーンリーダーが発表するラベルで始まり、それが何であるかを名前付けします：ユーザーのメッセージ、Claude の返信と思考、ツールアクティビティ、エラーと警告、およびプロンプト。ラベルは検索可能でもあるため、ターミナルのスクロールバックを検索してトランスクリプトのセクション間をジャンプできます：
 
 | ラベル | 意味 |
 | :- | :- |
-| `you:` | あなたのメッセージ |
+| `you:` | ユーザーのメッセージ |
 | `claude:` | Claude の返信 |
 | `thinking:` | Claude の思考 |
@@ -77,6 +77,6 @@ Claude Code は起動時に [確認行](#turn-on-screen-reader-mode) を印刷
 | `tool error:` | 失敗したツール |
 | `error:` | 失敗した API リクエストなどの会話内のエラー |
-| `warning:` | モデルフォールバックへの切り替えなど、Claude Code からの警告 |
-| `Permission Required:` | あなたの回答を待つ権限プロンプト |
+| `warning:` | フォールバックモデルへの切り替えなど、Claude Code からの警告 |
+| `Permission Required:` | ユーザーの回答を待つ権限プロンプト |
 | `Cost:` | Claude Code が終了するときのセッションコスト概要（アカウントが [コストを表示](/docs/ja/costs) している場合） |
 
@@ -146,5 +146,5 @@ macOS Terminal はマーカーに作用せず、Claude Code は WezTerm では
 
 * スクリーンリーダーモードは、スクリーンリーダーが実行されているときに自動的にオンになりません。
-* Claude Code は `Shift+Tab` でサイクリングする以外の方法で行われた権限モード変更を発表しません。例えば、コマンドから[プランモード](/docs/ja/permission-modes#analyze-before-you-edit-with-plan-mode)に入るなどです。
+* Claude Code は、`/plan` で [plan モード](/docs/ja/permission-modes#analyze-before-you-edit-with-plan-mode)に入るなど、コマンドで行った権限モードの変更を発表しません。
```

</details>

<details>
<summary>admin-setup-ja.md</summary>

```diff
diff --git a/docs-ja/pages/admin-setup-ja.md b/docs-ja/pages/admin-setup-ja.md
index e3c6981..c7c0245 100644
--- a/docs-ja/pages/admin-setup-ja.md
+++ b/docs-ja/pages/admin-setup-ja.md
@@ -119,5 +119,5 @@ WSL 2 ユーティリティ VM 内のプロセスは、Windows 側のエンド
 
 * [組織モデル制限](/docs/ja/model-config#organization-model-restrictions)：個別のモデルを無効にします。サーバー側で強制されます。
-* [組織デフォルトモデル](/docs/ja/model-config#organization-default-model)：新しいセッションが開始するモデルを設定します。ユーザーは、組織がデフォルトを強制しない限り変更できます。これは限定的な組織セットで利用可能です。Anthropic アカウントチームにお問い合わせください。
+* [組織デフォルトモデル](/docs/ja/model-config#organization-default-model)：新しいセッションが開始するモデルを設定します。メンバーは引き続きモデルを切り替えることができます。起動時にメンバーを組織のデフォルトに戻すには、そのセクションで説明されている上書きをオンにします。メンバーが選択できるモデルを制限するには、[組織モデル制限](/docs/ja/model-config#organization-model-restrictions)を使用します。
 * [組織エフォート制限](/docs/ja/model-config#organization-effort-limits)：ロールごとのエフォートレベルをキャップします。サーバー側で強制されます。
 
```

</details>

<details>
<summary>advisor-ja.md</summary>

```diff
diff --git a/docs-ja/pages/advisor-ja.md b/docs-ja/pages/advisor-ja.md
index 7c98a02..6070a48 100644
--- a/docs-ja/pages/advisor-ja.md
+++ b/docs-ja/pages/advisor-ja.md
@@ -51,5 +51,5 @@ advisor モデルは 3 つの方法で設定できます。
 コマンドは `Advisor set to` で確認し、その後に advisor モデル名が続きます。選択はユーザー設定の `advisorModel` に保存され、セッション全体で保持されます。ただし、[`advisorModel` エントリ](/docs/ja/settings-reference#advisormodel)が現在のセッションにのみ適用されるとリストしている場合は除きます。
 
-このコマンドは、ターミナルピッカーがない場所でも機能します。[非対話型モード](/docs/ja/headless)で `-p` を使用する場合、Agent SDK 内、デスクトップアプリ内、および[リモートコントロール](/docs/ja/remote-control)経由です。これには Claude Code v2.1.260 以降が必要です。これらのサーフェスでは、
+このコマンドは、ターミナルピッカーがない場所でも機能します。[非対話モード](/docs/ja/headless)で `-p` を使用する場合、Agent SDK 内、デスクトップアプリ内、および [Remote Control](/docs/ja/remote-control) 経由です。これには Claude Code v2.1.260 以降が必要です。これらのサーフェスでは、
 
 * 引数なしで `/advisor` を実行して、現在の advisor モデルとそれが受け入れるエイリアスを出力します。
@@ -57,5 +57,7 @@ advisor モデルは 3 つの方法で設定できます。
 * `/advisor off` を実行してそれをオフにします。
 
-Claude Code は、組織の [`availableModels`](/docs/ja/model-config#restrict-model-selection)許可リストが除外した保存済み advisor を呼び出しません。advisor を使用するには、`/advisor` で許可されたモデルを選択してください。Claude Code は、現在のメインモデルがサポートしていない advisor を引き続き保存します。その advisor は、[`/model`](/docs/ja/model-config#setting-your-model)で[互換性のあるメインモデル](#choose-an-advisor-model)に切り替えた後にアクティブになります。API がすでに現在の会話で保存済み advisor を拒否した場合、モデルを切り替えた後でも、`/clear` または `/compact` まで、それはオフのままです。
+Claude Code は、組織の [`availableModels`](/docs/ja/model-config#restrict-model-selection) 許可リストが除外した保存済み advisor を呼び出しません。advisor を使用するには、`/advisor` で許可されたモデルを選択してください。
+
+Claude Code は、現在のメインモデルがサポートしていない advisor を引き続き保存します。その advisor は、[`/model`](/docs/ja/model-config#setting-your-model) で[互換性のあるメインモデル](#choose-an-advisor-model)に切り替えた後にアクティブになります。API がすでに現在の会話で保存済み advisor を拒否した場合、モデルを切り替えた後でも、`/clear` または `/compact` まで、それはオフのままです。
 
 一部のプランでは、Fable を advisor として使用する場合、Fable の使用を使用クレジットに請求することへの 1 回限りの[同意](/docs/ja/model-config#fable-and-usage-credits)も必要です。その同意を与える前に `/advisor fable` が何をするかについては、[Fable advisor と使用クレジット](#fable-advisor-and-usage-credits)を参照してください。
@@ -87,30 +89,32 @@ Claude Code はそのセッションの `advisorModel` 設定の代わりにフ
 * セッションのメインモデルが advisor をサポートしていない
 * Haiku などのリクエストされたモデルが advisor として機能できない
-* 組織の [`availableModels`](/docs/ja/model-config#restrict-model-selection)許可リストがリクエストされたモデルを除外している
+* 組織の [`availableModels`](/docs/ja/model-config#restrict-model-selection) 許可リストがリクエストされたモデルを除外している
 * Fable をリクエストし、アカウントがまだ[使用クレジット同意](#fable-advisor-and-usage-credits)を必要としている
 
 `--advisor` で[バックグラウンドセッション](/docs/ja/agent-view)を開始し、これらのいずれかが当てはまる場合、Claude Code は終了する代わりに advisor なしでセッションを開始します。
 
+リクエストされたモデルが advisor として機能できるものの、セッションのメインモデルより[下位にランク付けされている](#choose-an-advisor-model)場合でも、Claude Code はセッションを開始します。バックグラウンドセッション以外では、そのモデルがメインモデルに対して `cannot advise` であるという警告も起動時に表示します。
```

</details>

<details>
<summary>agent-teams-ja.md</summary>

```diff
diff --git a/docs-ja/pages/agent-teams-ja.md b/docs-ja/pages/agent-teams-ja.md
index 88a5cce..ad7c199 100644
--- a/docs-ja/pages/agent-teams-ja.md
+++ b/docs-ja/pages/agent-teams-ja.md
@@ -92,5 +92,5 @@ Claude は時々、チームを作成する代わりに [サブエージェン
 * **Escape**: 選択を解除します。チームメンバーのトランスクリプトを表示している間、Escape はそのチームメンバーの現在のターンを中断します
 
-v2.1.199 以降、アイドル状態のチームメンバーの行は、他のチームメンバーまたはサブエージェントがまだ作業中の間、パネルに留まるため、トランスクリプトを確認したり、さらに作業を割り当てたりするために選択できます。パネル内のすべてのエージェントがアイドル状態になると、アイドル行は 30 秒後に非表示になり、チームメンバーの次のターンで再表示されます。チームメンバーは非表示中も実行中で対応可能な状態が続きます。v2.1.181 から v2.1.198 では、アイドル行は他のチームメンバーがまだ作業中であっても、独自のターンが終了してから 30 秒後に非表示になりました。v2.1.181 より前のバージョンではアイドル行は非表示になりません。
+アイドル状態のチームメイトの行は、いずれかのチームメイトまたはサブエージェントがまだ作業中の間、パネルに留まるため、選択してトランスクリプトを確認したり、さらに作業を割り当てたりできます。パネル内のすべてのエージェントがアイドル状態になると、アイドル行は 30 秒後に非表示になり、チームメイトの次のターンで再表示されます。チームメイトは非表示中も実行中で、引き続き指示を送ることができます。
 
 3 人以上のチームメンバーが同時にアイドル状態の場合、最初の 3 行を超える行は、折りたたまれたチームメンバーをカウントする単一の行に折りたたまれます。例えば、5 人がアイドル状態の場合は `2 idle agents` のようになります。それを選択して Enter キーを押すと折りたたまれた行が展開され、Esc キーを押すと再び折りたたまれます。作業中のチームメンバー、失敗したチームメンバー、および表示中のチームメンバーは常に独自の行を保持します。
```

</details>

<details>
<summary>agent-view-ja.md</summary>

```diff
diff --git a/docs-ja/pages/agent-view-ja.md b/docs-ja/pages/agent-view-ja.md
index f25484a..11b08b8 100644
--- a/docs-ja/pages/agent-view-ja.md
+++ b/docs-ja/pages/agent-view-ja.md
@@ -577,8 +577,9 @@ claude --bg --exec 'pytest -x'
 </h3>
 
-エージェントビュー、`/bg`、または `claude --bg` から開始されたすべてのバックグラウンドセッションは、ワーキングディレクトリで開始されます。ファイルを編集する前に、Claude はセッションを `.claude/worktrees/` の下の分離された [git worktree](/docs/ja/worktrees) に移動するため、並列セッションは同じチェックアウトを読み取ることができますが、それぞれが独自に書き込みます。セッションが worktree に入ると、Claude Code は [worktree 分離を強制します](/docs/ja/worktrees#how-claude-code-enforces-isolation) セッションおよびそれが生成するサブエージェント用。
+エージェントビューからバックグラウンドセッションをディスパッチするか、`claude --bg` で開始すると、セッションは作業ディレクトリで開始されます。ファイルを編集する前に、Claude はセッションを `.claude/worktrees/` の下にある分離された [git worktree](/docs/ja/worktrees) に移動します。これにより、並列セッションは同じチェックアウトを読み取りつつ、それぞれ独自の場所に書き込めます。セッションが worktree に入ると、Claude Code はそのセッションと、セッションが生成するすべてのサブエージェントに対して [worktree 分離を強制します](/docs/ja/worktrees#how-claude-code-enforces-isolation)。
 
 Claude は以下の場合に worktree をスキップします。
 
+* 既に開いていたセッションを `←` または `/background` で [バックグラウンドに移動した](#from-inside-a-session) 場合。そのセッションは、既に作業していた場所でファイルの編集を続けます
 * セッションが既にリンクされた git worktree 内にあります。Claude が `.claude/worktrees/` の下に作成したか、`git worktree add` で他の場所に作成したかに関係なく
 * Claude が編集しているファイルがリンクされた git worktree 内にあります。例えば、セッションまたはそのサブエージェントが `git worktree add` で作成したもの
@@ -598,9 +599,9 @@ git worktrees が実用的でないリポジトリの worktree 分離をオフ
 git リポジトリの外では、セッションはワーキングディレクトリに直接書き込み、互いに分離されていないため、同じファイルを編集する並列セッションのディスパッチを避けてください。別のバージョン管理システムを使用する場合は、[`WorktreeCreate` フック](/docs/ja/worktrees#non-git-version-control) を設定し、Claude は git の場合と同じ方法で編集を分離します。
 
-フックが git リポジトリではないディレクトリで失敗する場合、Claude はそのディレクトリの分離をスキップし、ワーキングディレクトリをインプレースで編集します。git リポジトリ内では、Claude Code は Claude がセッションを worktree に移動するまで、共有チェックアウトへの書き込みをブロックします。
+git リポジトリではないディレクトリでフックが失敗した場合、Claude はそのディレクトリの分離をスキップし、作業ディレクトリをインプレースで編集します。git リポジトリ内では、編集前に Claude が worktree に移動させるセッションは、その移動が行われるまで共有チェックアウト内のファイルを編集できません。
 
 セッションの worktree パスを見つけるには、セッションをピークするか、アタッチしてそのワーキングディレクトリを確認します。
 
-バックグラウンドセッションが生成する [サブエージェント](/docs/ja/sub-agents) はセッションのワーキングディレクトリを継承するため、そのファイル編集はセッションの worktree に着地し、ワーキングコピーではなく。サブエージェントに独自の別の worktree を与えるには、フロントマターで [`isolation: worktree`](/docs/ja/sub-agents#supported-frontmatter-fields) を設定するか、生成時に `isolation: "worktree"` を渡します。
+バックグラウンドセッションが生成する [サブエージェント](/docs/ja/sub-agents) は、セッションの作業ディレクトリを継承します。セッションが worktree に入ると、サブエージェントのファイル編集は作業コピーではなくその worktree に反映されます。代わりにサブエージェントに独自の別の worktree を与えるには、そのフロントマターで [`isolation: worktree`](/docs/ja/sub-agents#supported-frontmatter-fields) を設定するか、生成時に `isolation: "worktree"` を渡します。
 
 バックグラウンドセッションが Claude が入った worktree でコード変更を行った場合、Claude Code は完了前に作業を保存するよう Claude に指示するため、セッションとその worktree を削除しても生き残ります。
```

</details>

<details>
<summary>agents-ja.md</summary>

```diff
diff --git a/docs-ja/pages/agents-ja.md b/docs-ja/pages/agents-ja.md
index 3200061..236184e 100644
--- a/docs-ja/pages/agents-ja.md
+++ b/docs-ja/pages/agents-ja.md
@@ -56,5 +56,5 @@ Claude Code には、複数のタスクを同時に処理する 5 つの方法
 
 * バックグラウンドセッションの場合、`claude agents` は [エージェントビュー](/docs/ja/agent-view) を開きます。すべてのセッション、その状態、および入力が必要なセッションを表示する 1 つの画面です。
-* 現在のセッション内のサブエージェントの場合、名前付きバックグラウンドサブエージェントは @-メンション入力補完に状態とともに表示されます。v2.1.198 以降、`/agents` はパネルを開かなくなり、サブエージェントファイルの場所を指すお知らせを出力します。[カスタムサブエージェントを作成および編集](/docs/ja/sub-agents#configure-subagents) するには、Claude に質問するか、ファイルを直接編集してください。名前は似ていますが、`/agents` は `claude agents` とは別です。
+* 現在のセッション内のサブエージェントの場合、名前付きバックグラウンドサブエージェントは @-メンション入力補完に状態とともに表示されます。`/agents` コマンドは、サブエージェントファイルの場所を指すお知らせを出力します。[カスタムサブエージェントを作成および編集](/docs/ja/sub-agents#configure-subagents) するには、Claude に質問するか、ファイルを直接編集してください。名前は似ていますが、`/agents` は `claude agents` とは別です。
 * 現在のセッションのバックグラウンドで実行されているもの場合、`/tasks` は各項目をリストし、確認、アタッチ、または停止できます。リストには完了したサブエージェントも含まれます。
 * 動的ワークフローの場合、`/workflows` は実行中および完了した実行、各実行がある段階、および完了したエージェント数をリストします。
```

</details>

<details>
<summary>amazon-bedrock-ja.md</summary>

```diff
diff --git a/docs-ja/pages/amazon-bedrock-ja.md b/docs-ja/pages/amazon-bedrock-ja.md
index 2993395..24ad7d6 100644
--- a/docs-ja/pages/amazon-bedrock-ja.md
+++ b/docs-ja/pages/amazon-bedrock-ja.md
@@ -584,5 +584,5 @@ Mantle モデルを `/model` ピッカーに表示するには、[settings file]
 ```
 
-`anthropic.` プレフィックス付きのエントリはカスタムピッカーオプションとして追加され、Mantle にルーティングされます。`anthropic.claude-haiku-4-5` をアカウントに付与されたモデル ID に置き換えます。`availableModels` が他のモデル設定とどのように相互作用するかについては、[Restrict model selection](/docs/ja/model-config#restrict-model-selection) を参照してください。
+`anthropic.` プレフィックス付きのエントリはカスタムピッカーオプションとして追加され、そのうち Mantle 形式に一致するものが Mantle にルーティングされます。`anthropic.claude-haiku-4-5` をアカウントに付与されたモデル ID に置き換えます。`availableModels` が他のモデル設定とどのように相互作用するかについては、[Restrict model selection](/docs/ja/model-config#restrict-model-selection) を参照してください。
 
 両方のプロバイダーがアクティブな場合、`/status` は `Amazon Bedrock + Amazon Bedrock (Mantle)` を表示します。
```

</details>

<details>
<summary>artifacts-ja.md</summary>

```diff
diff --git a/docs-ja/pages/artifacts-ja.md b/docs-ja/pages/artifacts-ja.md
index 56dd1fa..d02baa9 100644
--- a/docs-ja/pages/artifacts-ja.md
+++ b/docs-ja/pages/artifacts-ja.md
@@ -119,4 +119,13 @@ Claude Code で `/artifacts` を実行して、所有しているすべてのア
 Claude は他の人が書いたページを、[WebFetch](/docs/ja/tools-reference#webfetch-tool-behavior) でウェブページを読む方法と同じように読みます。つまり、生のページではなく、質問した内容の要約を取得し、その要約はページに書き込まれた指示を報告しますが、それらを実行する代わりに報告するのです。Claude Code はまた、ページの完全なソースをローカルファイルに保存します。Claude は、アーティファクトを [エディター](#let-someone-edit-with-you) として再発行する場合など、正確なコンテンツが必要な場合にそのファイルを開くことができます。
 
+次の場合、Claude Code は、権限モードやルールによって求められるプロンプトに加えて、Claude がアーティファクトを読む前にユーザーの承認を求めます。
+
+* **ネットワークアクセスのないクラウドセッション**：[クラウド環境](/docs/ja/cloud-environments#access-levels) の場合、**None** レベルがこれに該当します。[auto モード](/docs/ja/permission-modes#eliminate-prompts-with-auto-mode) では代わりに分類器が承認できますが、[Cowork](https://claude.com/product/cowork) セッションでは、承認できるのはユーザー本人だけです。
+* **別の組織の公開アーティファクト**：Claude Code は auto モードであっても、まずユーザーに確認します。`bypassPermissions` モードなど、Claude Code がユーザーに確認できない場合、Claude はそのアーティファクトを読むことができません。Claude がこれらのアーティファクトを読めるのは、[機能フラグの取得](/docs/ja/env-vars#features-that-need-feature-flag-fetching) がオンになっている間だけです。
+* **所有者またはネットワーク設定が未確認**：Claude Code がアーティファクトの作成者を確認できない場合、またはクラウドセッションのネットワーク設定を確認できない場合は確認を求めます。ユーザーの承認はその 1 回のリクエストにのみ適用されます。
+* **plan モード、または機能フラグの取得がオフ**：[plan モード](/docs/ja/permission-modes#analyze-before-you-edit-with-plan-mode) の場合、または [機能フラグの取得](/docs/ja/env-vars#features-that-need-feature-flag-fetching) をオフにしている場合、Claude Code は、組織内の他の人が作成したアーティファクトを Artifact ツールが読む前に確認を求めます。
+
+Claude が WebFetch でアーティファクトを読む場合も、WebFetch 自体の [プロンプトのルール](/docs/ja/tools-reference#webfetch-tool-behavior) は引き続き適用されます。
+
 <h2 id="collect-comments-on-an-artifact">
   アーティファクトのコメントを収集する
@@ -360,4 +369,5 @@ README などのコードベースに属するドキュメントはファイル
 | シングルページ | 相対リンクは解決されません。ページと一緒に何もデプロイされていないためです。マルチセクションコンテンツの場合、Claude は個別ファイルではなくページ内アンカーを使用します。 |
 | ソースファイルタイプ | 公開されるファイルは `.html`、`.htm`、または `.md` である必要があり、UTF-8 として、またはバイトオーダーマークによってリトルエンディアン UTF-16 としてデコードできる必要があります。Markdown ファイルはスタイル付きドキュメントページとしてレンダリングされ、構文強調表示されたコードが含まれます。デコードできないファイル、または置換文字 `U+FFFD` を含むファイルは、[修正する行と列とともに拒否されます](/docs/ja/errors#the-source-file-is-not-valid-utf-8-text)。 |
+| ソースの場所 | ネットワークホストを指すパスにあるファイルは、読み込まれることなく拒否されます。拒否されるパスと、Windows でのマップされたドライブの例外については、[公開されませんでした：そのファイルはネットワーク共有上にあります](/docs/ja/errors#not-published-that-file-is-on-a-network-share)を参照してください。 |
 | レンダリングサイズ | レンダリングされたページは 16 MiB 以下である必要があります。大きな埋め込み画像は、公開が失敗する場合の通常の原因です。 |
 
```

</details>

<details>
<summary>best-practices-ja.md</summary>

```diff
diff --git a/docs-ja/pages/best-practices-ja.md b/docs-ja/pages/best-practices-ja.md
index aa60b6a..fde9194 100644
--- a/docs-ja/pages/best-practices-ja.md
+++ b/docs-ja/pages/best-practices-ja.md
@@ -149,5 +149,5 @@ Claude にリッチデータを提供するにはいくつかの方法があり
 * **画像を直接貼り付ける**。画像をコピー/貼り付けまたはドラッグアンドドロップしてプロンプトに入れます。
 * **ドキュメントと API リファレンスの URL を指定する**。`/permissions` を使用して、頻繁に使用されるドメインをホワイトリストに登録します。
-* **データをパイプする** `cat error.log | claude` を実行してファイルの内容を直接送信します。
+* **データをパイプする** `cat error.log | claude -p "explain this error"` を実行してファイルの内容を直接送信します。
 * **Claude に必要なものを取得させる**。Bash コマンド、MCP ツール、またはファイルを読み取ることを使用して、Claude 自身がコンテキストをプルするよう指示します。
 
```

</details>

*...以降省略*

</details>


<details>
<summary>2026-10-02</summary>

**変更ファイル:**

```
 docs-ja/pages/accessibility-ja.md                  |   16 +-
 docs-ja/pages/admin-setup-ja.md                    |   24 +-
 docs-ja/pages/agent-teams-ja.md                    |    7 +-
 docs-ja/pages/agent-view-ja.md                     |   54 +-
 docs-ja/pages/amazon-bedrock-ja.md                 |   14 +
 docs-ja/pages/artifacts-ja.md                      |    2 +-
 docs-ja/pages/authentication-ja.md                 |   20 +
 docs-ja/pages/auto-mode-config-ja.md               |    8 +-
 docs-ja/pages/changelog.md                         |  109 +
 docs-ja/pages/chrome-ja.md                         |  114 +-
 docs-ja/pages/claude-apps-gateway-config-ja.md     |  820 ++++---
 docs-ja/pages/claude-code-on-the-web-ja.md         |    1 +
 docs-ja/pages/claude-directory-ja.md               |    1 +
 docs-ja/pages/cli-reference-ja.md                  |   22 +-
 docs-ja/pages/cloud-environments-ja.md             |    7 +-
 docs-ja/pages/code-review-ja.md                    |    4 +-
 docs-ja/pages/commands-ja.md                       |  158 +-
 docs-ja/pages/context-window-ja.md                 |    2 +-
 docs-ja/pages/costs-ja.md                          |    5 +-
 docs-ja/pages/debug-your-config-ja.md              |    6 +-
 docs-ja/pages/desktop-ja.md                        |    2 +-
 docs-ja/pages/desktop-linux-ja.md                  |   12 +
 docs-ja/pages/desktop-quickstart-ja.md             |    2 +-
 docs-ja/pages/env-vars-ja.md                       |   16 +-
 docs-ja/pages/errors-ja.md                         | 1804 +++++++--------
 docs-ja/pages/fullscreen-ja.md                     |    2 +
 docs-ja/pages/google-vertex-ai-ja.md               |   12 +
 docs-ja/pages/headless-ja.md                       |   12 +-
 docs-ja/pages/hooks-guide-ja.md                    |  143 +-
 docs-ja/pages/hooks-ja.md                          | 2312 +++++++++++++-------
 docs-ja/pages/interactive-mode-ja.md               |    6 +-
 docs-ja/pages/keybindings-ja.md                    |    4 +-
 docs-ja/pages/llm-gateway-ja.md                    |    2 +
 docs-ja/pages/llm-gateway-protocol-ja.md           |   54 +-
 docs-ja/pages/managed-settings-ja.md               |   32 +-
 docs-ja/pages/mcp-ja.md                            |   12 +-
 docs-ja/pages/mcp-quickstart-ja.md                 |    4 +-
 docs-ja/pages/memory-ja.md                         |   72 +-
 docs-ja/pages/model-config-ja.md                   |  964 +++++---
 docs-ja/pages/monitoring-usage-ja.md               |    1 +
 docs-ja/pages/network-config-ja.md                 |    2 +-
 docs-ja/pages/permission-modes-ja.md               |   11 +-
 docs-ja/pages/permissions-ja.md                    |   19 +-
 docs-ja/pages/plugin-evals-ja.md                   |  160 +-
 docs-ja/pages/remote-control-ja.md                 |   24 +-
 docs-ja/pages/routines-ja.md                       |    2 +-
 docs-ja/pages/sandbox-environments-ja.md           |   28 +-
 docs-ja/pages/sandboxing-ja.md                     |  842 ++++---
 docs-ja/pages/scheduled-tasks-ja.md                |    2 +-
 docs-ja/pages/security-ja.md                       |   32 +-
 .../self-hosted-environments-configuration-ja.md   |   19 +-
 docs-ja/pages/self-hosted-environments-ja.md       |    2 +-
 docs-ja/pages/server-managed-settings-ja.md        |    5 +-
 docs-ja/pages/settings-example-ja.md               |    4 +-
 docs-ja/pages/settings-reference-ja.md             |  877 ++++----
 docs-ja/pages/skills-ja.md                         |   26 +-
 docs-ja/pages/sub-agents-ja.md                     |    7 +-
 docs-ja/pages/third-party-integrations-ja.md       |    2 +
 docs-ja/pages/tools-reference-ja.md                |   41 +-
 docs-ja/pages/troubleshoot-install-ja.md           |   26 +-
 docs-ja/pages/troubleshooting-ja.md                |    5 +
 docs-ja/pages/ultrareview-ja.md                    |   12 +-
 docs-ja/pages/vs-code-ja.md                        |    4 +-
 docs-ja/pages/web-quickstart-ja.md                 |    2 +
 docs-ja/pages/worktrees-ja.md                      |  360 ++-
 65 files changed, 5981 insertions(+), 3395 deletions(-)
```

<details>
<summary>accessibility-ja.md</summary>

```diff
diff --git a/docs-ja/pages/accessibility-ja.md b/docs-ja/pages/accessibility-ja.md
index 4477579..8a2fd7a 100644
--- a/docs-ja/pages/accessibility-ja.md
+++ b/docs-ja/pages/accessibility-ja.md
@@ -45,5 +45,5 @@ Claude Code が最初に出力する行がモードを確認します。`[Screen
 | [`axScreenReader`](/docs/ja/settings-reference#axscreenreader) | 設定 | `true` の場合、すべてのセッションのスクリーンリーダーモード。 |
 | [`CLAUDE_AX_STARTUP_QUIET_MS`](/docs/ja/env-vars#variables) | 環境変数 | Claude Code が確認行の後、スクリーンリーダーモードで最初のプロンプトを描画する前に待機する時間。Claude Code v2.1.217 以降が必要です。 |
-| [`CLAUDE_AX_PREPARK_MS`](/docs/ja/env-vars#variables) | 環境変数 | Claude Code が行の開始時にカーソルを置いて、スクリーンリーダーモードで新しい行または変更された行を書き込む前に待機する時間。Claude Code v2.1.233 以降が必要です。 |
+| [`CLAUDE_AX_PREPARK_MS`](/docs/ja/env-vars#variables) | 環境変数 | 設定した場合、スクリーンリーダーモードで新しい行または変更された行を書き込む前に、Claude Code がターミナルカーソルを現在の行の先頭に保持するミリ秒数。Claude Code v2.1.233 以降が必要です。 |
 | [`CLAUDE_CODE_ACCESSIBILITY`](/docs/ja/env-vars#variables) | 環境変数 | `1` に設定した場合、macOS Zoom などのスクリーン拡大鏡に対して表示されたままのターミナルカーソル。カーソルは入力キャレットに従い、Claude Code v2.1.218 以降では、`/config` や `/plugin` などのメニューとパネルの強調表示された行に従います。 |
 | [`prefersReducedMotion`](/docs/ja/settings-reference#prefersreducedmotion) | 設定 | `true` の場合、スピナー、シマー、およびその他のアニメーションが削減または非表示になります。 |
@@ -61,11 +61,9 @@ Claude Code が最初に出力する行がモードを確認します。`[Screen
 * 変更されていないコンテンツの再描画なし。プログレススピナーは静的テキストとしてレンダリングされます
 * Claude の返信内のテーブルは、ボックス文字グリッドではなく `Header: value` 文として読み込まれます
+* 差分は、追加された行と削除された行を `+` と `-` で示したプレーンテキストとして 1 行ずつ読み上げられるため、ファイル編集の承認プロンプトで回答する前に、提案された変更を聞くことができます
 
 Claude Code は、ターミナルのスクロールバックに印刷するすべてを残すため、スクリーンリーダーのレビューコマンドまたはターミナルの検索を使用して以前のターンを再度読むことができます。Claude Code は、スクリーンリーダーモードで [`tui` 設定](/docs/ja/settings-reference#tui) を無視します。[既知の制限事項](#known-limitations) に記載されている接続されたバックグラウンドセッションを除き、[フルスクリーンレンダリング](/docs/ja/fullscreen) の代わりにスクロールテキストを印刷します。
 
-Claude Code は、スクリーンリーダーが追いつくことができるように 2 つのポイントで待機します：
-
-* Claude Code が確認行を印刷した後、スクリーンリーダーが行を完了できるようにプロンプトを描画する前に 3 秒待機します。任意のキーを押して待機を終了します。待機の長さを変更するには、[`CLAUDE_AX_STARTUP_QUIET_MS`](/docs/ja/env-vars#variables) を設定します。
-* Claude Code が新しい行または変更された行（ヒントや Claude の返信の詳細など）を書き込む前に、カーソルを行の開始位置に移動して 50 ミリ秒待機します。その後、スクリーンリーダーは最初の文字から行を読み込みます。入力行の末尾に入力または削除した文字は直ちに表示されます。待機の長さを変更するには、[`CLAUDE_AX_PREPARK_MS`](/docs/ja/env-vars#variables) を設定します。
+Claude Code は起動時に [確認行](#turn-on-screen-reader-mode) を印刷した後、スクリーンリーダーが行を読み終えられるように、プロンプトを描画する前に 3 秒待機します。任意のキーを押すと待機を終了します。待機の長さを変更するには、[`CLAUDE_AX_STARTUP_QUIET_MS`](/docs/ja/env-vars#variables) を設定します。
 
 トランスクリプト内の各メッセージは、スクリーンリーダーが発表するラベルで始まり、それが何であるかを名前付けします：あなたのメッセージ、Claude の返信と思考、ツールアクティビティ、エラーと警告、およびプロンプト。ラベルは検索可能でもあるため、ターミナルのスクロールバックを検索してトランスクリプトのセクション間をジャンプできます：
@@ -95,4 +93,12 @@ Claude Code はターミナルカーソルを入力キャレットに保つた
 [権限モード](/docs/ja/permission-modes) を `Shift+Tab` でサイクルすると、Claude Code は `[plan mode on]` または `[accept edits on]` などのランディングした権限モードを発表します。Claude Code は発表を 1 回印刷し、後の再描画では繰り返しません。
 
+<h3 id="read-earlier-output-without-losing-your-place">
+  読んでいる位置を失わずに以前の出力を読む
```

</details>

<details>
<summary>admin-setup-ja.md</summary>

```diff
diff --git a/docs-ja/pages/admin-setup-ja.md b/docs-ja/pages/admin-setup-ja.md
index 25bc825..e3c6981 100644
--- a/docs-ja/pages/admin-setup-ja.md
+++ b/docs-ja/pages/admin-setup-ja.md
@@ -107,4 +107,5 @@ WSL 2 ユーティリティ VM 内のプロセスは、Windows 側のエンド
 | [フック制限](/docs/ja/settings-reference#allowmanagedhooksonly) | 実行するフックを制限し、HTTP フック URL を制限します。[`allowManagedHooksOnly` で実行される内容](/docs/ja/settings-reference#what-runs-under-allowmanagedhooksonly)の完全な効果リストを参照してください | `allowManagedHooksOnly`、`allowedHttpHookUrls` |
 | [ログイン強制](/docs/ja/settings-reference#forceloginmethod) | ログインを特定の方法または Anthropic 組織に制限します。メソッド制限は VS Code 拡張機能、Agent SDK、`claude setup-token`、`/install-github-app` 全体に適用され、ターミナルのインタラクティブログイン画面（`/login` または初回オンボーディングで到達）はメソッドを事前選択しますが強制しません。Claude Code は、ターミナル、VS Code 拡張機能、Agent SDK での claude.ai アカウントログインの組織を検証し、Claude Console ログインまたは[ゲートウェイ](/docs/ja/claude-apps-gateway)サインインではチェックしません。v2.1.212 より前は、ターミナルログインのみが両方のキーを適用していました。設定すると、`ANTHROPIC_API_KEY`、`ANTHROPIC_AUTH_TOKEN`、または `apiKeyHelper` によって認証されたセッションはスタートアップでブロックされます。クラウドプロバイダーセッションは影響を受けません | `forceLoginMethod`、`forceLoginOrgUUID` |
+| [プロバイダー制限](/docs/ja/settings-reference#allowedproviders) | マシンが使用できる API プロバイダーを制限します。リストに記載されていないプロバイダー上のセッションはスタートアップ時、ログイン時、および次に API に接続するときに拒否されます。Claude Code v2.1.285 以降が必要です | `allowedProviders` |
 | [エージェントビューを無効にする](/docs/ja/agent-view#how-background-sessions-are-hosted) | `claude agents`、`--bg`、`/background`、およびオンデマンドスーパーバイザーをオフにします | `disableAgentView` |
 | [企業ランチャーを構成する](/docs/ja/corporate-launcher) | [バックグラウンドエージェントスーパーバイザー](/docs/ja/agent-view#how-background-sessions-are-hosted)、そのワーカー、および[その他のカバーされたバックグラウンドプロセス](/docs/ja/corporate-launcher#what-the-launcher-covers)に、エージェントビューをオフにする代わりに、必須の企業ランチャーをプレフィックスします | `processWrapper` |
@@ -123,5 +124,9 @@ WSL 2 ユーティリティ VM 内のプロセスは、Windows 側のエンド
 これらの制御は、Amazon Bedrock、Google Cloud の Agent Platform、Microsoft Foundry、または[AWS 上の Claude Platform](/docs/ja/claude-platform-on-aws)のセッションには到達しません。これらのプロバイダーでは、代わりにマネージド設定を使用してください。制限には `availableModels`、デフォルトには `model`、エフォートキャップには [`maxEffortLevel`](/docs/ja/settings-reference#maxeffortlevel) を使用します。
 
-[Web 上の Claude Code](/docs/ja/claude-code-on-the-web)には独自の管理サーフェスがあります。管理設定のクラウド環境ページで、オーナーは[組織共有環境](/docs/ja/cloud-environments#organization-shared-environments)を作成し、メンバーのクラウドセッションの[ネットワークアクセスレベル](/docs/ja/cloud-environments#network-access)、環境変数、セットアップスクリプトを設定します。オーナーは、[claude.ai/admin-settings/claude-code](https://claude.ai/admin-settings/claude-code) で組織のデフォルト環境を別途選択します。
+[クラウドセッション](/docs/ja/claude-code-on-the-web)には、claude.ai 上に独自の管理サーフェスがあります。
+
+* **クラウド環境ページ**：オーナーは[組織共有環境](/docs/ja/cloud-environments#organization-shared-environments)を作成し、メンバーのクラウドセッションの[ネットワークアクセスレベル](/docs/ja/cloud-environments#network-access)、環境変数、セットアップスクリプトを設定します。
+* **デフォルト環境**：オーナーは、[claude.ai/admin-settings/claude-code](https://claude.ai/admin-settings/claude-code) で組織のデフォルト環境を別途選択します。
+* **GitHub ページ**：組織にリンクされている GitHub アカウントについては、[接続された GitHub アカウント](#connected-github-accounts)を参照してください。
 
 権限ルールとサンドボックスは異なるレイヤーをカバーします。WebFetch を拒否すると Claude のフェッチツールがブロックされますが、Bash が許可されている場合、`curl` と `wget` は依然として任意の URL に到達できます。サンドボックスは、OS レベルで強制されるネットワークドメイン許可リストでそのギャップを閉じます。
@@ -129,4 +134,21 @@ WSL 2 ユーティリティ VM 内のプロセスは、Windows 側のエンド
 これらの制御が防御する脅威モデルについては、[セキュリティ](/docs/ja/security)を参照してください。
 
+<h3 id="connected-github-accounts">
+  接続された GitHub アカウント
+</h3>
+
+Team プランと Enterprise プランでは、[**Admin settings > GitHub**](https://claude.ai/admin-settings/github) に、[Claude GitHub App](https://github.com/apps/claude) を通じて Claude 組織にリンクされている GitHub 組織と個人アカウントが一覧表示されます。Claude Code、[Claude Tag](https://claude.com/docs/claude-tag/admins/configure-github)、Claude Security はこのリストを共有します。このページを開くには、Claude 組織での管理者ロールが必要です。
+
```

</details>

<details>
<summary>agent-teams-ja.md</summary>

```diff
diff --git a/docs-ja/pages/agent-teams-ja.md b/docs-ja/pages/agent-teams-ja.md
index 004be47..88a5cce 100644
--- a/docs-ja/pages/agent-teams-ja.md
+++ b/docs-ja/pages/agent-teams-ja.md
@@ -196,7 +196,10 @@ Spawn an architect teammate to refactor the authentication module.
 * **分割ペインモード**：チームメンバーのペインをクリックして、セッションと直接対話してください。各チームメンバーは独自のターミナルの完全なビューを持っています。
 
-In-process チームメンバーを表示している間、プレーンテキストと [skills](/docs/ja/skills) はそのチームメンバーに送信されますが、組み込みコマンドはリーダーのセッションで実行されます。
+In-process チームメイトを表示している間、プレーンテキストと[スキル](/docs/ja/skills)はそのチームメイトに送信され、組み込みコマンドはリーダーのセッションに送信されます。ただし、次の安全策があります。
 
-チームメンバーのモデルと高速モードはそれが生成されるときに固定されるため、`/model` と `/fast` はリーダーの設定のみを変更します。v2.1.199 以降、チームメンバーを表示している間にいずれかのコマンドを入力すると、変更がリーダーに適用されることを示す通知が表示されます。それより前のバージョンでは、指示なしでリーダーに適用されました。`/effort` はチームメンバーの後続のターンに適用されます。これはチームメンバーがリーダーの[努力レベル](/docs/ja/model-config#adjust-effort-level)に従うためです。
+* `/compact`、`/clear`、`/rewind` はリーダーの会話に作用するため、このビューからいずれかを実行する前に Claude Code が確認を求めます。
+* `/model` と `/fast` はチームメイトではなくリーダーのモデルと fast mode を設定するため、このビューからは実行されません。その理由を示す通知が表示されます。
+
+チームメイトのモデルと fast mode は、スポーン時に固定されます。`/effort` は引き続き表示中のチームメイトの後続のターンに適用されます。これはチームメイトがリーダーの [effort レベル](/docs/ja/model-config#adjust-effort-level)に従うためです。
 
 <h3 id="assign-and-claim-tasks">
```

</details>

<details>
<summary>agent-view-ja.md</summary>

```diff
diff --git a/docs-ja/pages/agent-view-ja.md b/docs-ja/pages/agent-view-ja.md
index ff0f1b3..f25484a 100644
--- a/docs-ja/pages/agent-view-ja.md
+++ b/docs-ja/pages/agent-view-ja.md
@@ -9,7 +9,7 @@
 `claude agents` で開くエージェントビューは、すべてのバックグラウンドセッションの 1 つの画面です。実行中のもの、入力が必要なもの、完了したものが表示されます。新しいセッションをディスパッチし、トランスクリプトをスクロールする代わりに一目でセッションの状態を確認し、セッションが必要とするときだけ介入します。各バックグラウンドセッションは完全な Claude Code の会話であり、ターミナルが接続されていなくてもバックグラウンドで実行し続けるため、いつでも開いて、返信して、去ることができます。
 
-<img src="https://mintcdn.com/claude-code/HDAmBwgbrZVk0pOt/images/agent-view-light.png?fit=max&auto=format&n=HDAmBwgbrZVk0pOt&q=85&s=d6905012bee31f3e6b3920b09c05dd02" className="dark:hidden" alt="ターミナルのエージェントビュー：ヘッダーは Claude Code v2.1.140、モデル、作業ディレクトリ、および概要カウントを表示します。セッションは「入力が必要」、「実行中」、「完了」の下にグループ化され、下部にディスパッチ入力とキーボードヒントのフッターがあります。" width="1872" height="680" data-path="images/agent-view-light.png" />
+<img src="https://mintcdn.com/claude-code/HDAmBwgbrZVk0pOt/images/agent-view-light.png?fit=max&auto=format&n=HDAmBwgbrZVk0pOt&q=85&s=d6905012bee31f3e6b3920b09c05dd02" className="dark:hidden" alt="ターミナルのエージェントビュー。上部の行は、入力を待機しているセッション、実行中のセッション、完了したセッションの数をカウントします。4 つのセッションは「入力が必要」、「実行中」、「完了」の下にグループ化されています。各行はセッションの名前、最新のステータスまたは質問、および時間を表示します。下部には新しいタスクを説明するための入力と、キーボードヒントの行があります。" width="1872" height="680" data-path="images/agent-view-light.png" />
 
-<img src="https://mintcdn.com/claude-code/HDAmBwgbrZVk0pOt/images/agent-view-dark.png?fit=max&auto=format&n=HDAmBwgbrZVk0pOt&q=85&s=fc3c195bfc57e313ced1f1beb36cee93" className="hidden dark:block" alt="ターミナルのエージェントビュー：ヘッダーは Claude Code v2.1.140、モデル、作業ディレクトリ、および概要カウントを表示します。セッションは「入力が必要」、「実行中」、「完了」の下にグループ化され、下部にディスパッチ入力とキーボードヒントのフッターがあります。" width="1872" height="680" data-path="images/agent-view-dark.png" />
+<img src="https://mintcdn.com/claude-code/HDAmBwgbrZVk0pOt/images/agent-view-dark.png?fit=max&auto=format&n=HDAmBwgbrZVk0pOt&q=85&s=fc3c195bfc57e313ced1f1beb36cee93" className="hidden dark:block" alt="ターミナルのエージェントビュー。上部の行は、入力を待機しているセッション、実行中のセッション、完了したセッションの数をカウントします。4 つのセッションは「入力が必要」、「実行中」、「完了」の下にグループ化されています。各行はセッションの名前、最新のステータスまたは質問、および時間を表示します。下部には新しいタスクを説明するための入力と、キーボードヒントの行があります。" width="1872" height="680" data-path="images/agent-view-dark.png" />
 
 Claude が複数の独立したタスクに対して、あなたが毎ステップを監視することなく作業できる場合に、エージェントビューを使用します。バグ修正、プルリクエストレビュー、不安定なテストの調査を 3 つの行としてディスパッチし、別のウィンドウで作業を続け、行が入力が必要であることを示すか、結果が得られたときに確認します。
@@ -225,5 +225,15 @@ Completed
 ほとんどの場合、ピークパネルで十分であり、フルトランスクリプトを開く必要はありません。
 
-ピークパネルに返信を入力して `Enter` を押すと、そのセッションに送信されます。セッションが複数選択肢の質問をしている場合、ピークパネルはオプションを番号付きリストとして表示し、数字キーを押して 1 つを選択できます。許可プロンプトはテキストとして表示され、セッションが実行したいことを説明します。番号付きオプションはありません。返信を入力して答えるか、標準プロンプトで答えるためにアタッチします。他のブロックされたセッションの場合は、`Tab` を押して入力に提案された返信を入力し、送信前に編集できます。返信の前に `!` を付けて Bash コマンドを代わりに送信します。
+ピークパネルに返信を入力して `Enter` を押すと、そのセッションに送信されます。返信の先頭に `!` を付けると、代わりに Bash コマンドを送信します。返信がどう扱われるかは、セッションと送信する内容によって異なります：
+
+* 作業中のセッション：返信は応答を中断せずにセッションの [メッセージキュー](/docs/ja/interactive-mode#queue-messages-while-claude-works) に追加され、[キューに入れた入力が反映されるタイミング](/docs/ja/interactive-mode#when-claude-code-sends-what-you-queued) で反映されます。[コマンド](/docs/ja/commands) は、セッション自体のプロンプトで入力するとすぐに実行されるものであっても、ターンが終了するまで待機します
+* `/stop` だけの返信：セッションに届けられるのではなく、セッションが作業中でもユーザーを待っている状態でも、その場でセッションを停止します
+* [シェルジョブ](#run-a-shell-command)：返信は `/stop` も含め、入力としてコマンドのターミナルに送られます
+
+セッションがユーザーを待っている場合、ピークパネルからの答え方は、セッションが何を待っているかによって異なります：
+
+* 選択肢が用意された質問：パネルには選択肢が番号付きで表示されます。返信入力が空の状態で選択肢の番号を押すと入力され、`Enter` で送信できます。または、代わりに独自の回答を入力します
+* 選択肢のない質問：回答を入力します。空の入力に返信の候補が表示されている場合は、`Tab` を押して入力し、送信前に編集できます
+* 権限プロンプトまたはその他のダイアログ（[サンドボックス](/docs/ja/sandboxing) プロンプトや MCP サーバーの [入力リクエスト](/docs/ja/mcp#respond-to-mcp-elicitation-requests) など）：返信してもダイアログには答えられません。返信はキューで待機します。ダイアログに答えるには、`→` でアタッチします
 
```

</details>

<details>
<summary>amazon-bedrock-ja.md</summary>

```diff
diff --git a/docs-ja/pages/amazon-bedrock-ja.md b/docs-ja/pages/amazon-bedrock-ja.md
index 09f0e05..2993395 100644
--- a/docs-ja/pages/amazon-bedrock-ja.md
+++ b/docs-ja/pages/amazon-bedrock-ja.md
@@ -385,4 +385,16 @@ Claude Code が Amazon Bedrock で設定されて起動する場合、使用予
 `opus` などのモデルエイリアスはピンとして機能せず、Claude Code が認識しないモデル ID（アプリケーション推論プロファイル ARN など）も同様です。
 
+これらのチェックがアカウントが呼び出せないモデルを見つけた場合、Claude Code はこのマシンで最大 1 日間その拒否を記憶し、その時間中は Amazon Bedrock に再度問い合わせることなく記憶されたモデルをスキップして起動します。Claude Code は、現在のデフォルトモデルの記憶された拒否を、最後のチェック以降 10 分が経過すると起動時に再度チェックするため、管理者が再度有効にしたデフォルトが戻ります。メモリをオフにするには、[`CLAUDE_CODE_SKIP_MODEL_ACCESS_MEMORY=1`](/docs/ja/env-vars)を設定してください。
+
+<h3 id="when-a-model-is-disabled-mid-session">
+  モデルがセッション中に無効化される場合
+</h3>
+
+セッションが実行されているモデルへのアカウントアクセスが失われた場合（例えば、管理者が Amazon Bedrock アカウントでそれを無効化した場合）、Claude Code は各リクエストが失敗する代わりにセッションを別のモデルに切り替え、`Switched to <fallback> because <model> is not available` を表示します。スタートアップフォールバックと同じモデルを試します。同じティアの以前のバージョンを最初に試し、Opus セッションで Opus バージョンが利用できない場合、デフォルト Sonnet モデルを試します。
+
+切り替えは、ピン留めしていないティアにのみ適用されます。これはスタートアップフォールバックと同じ条件です。選択した特定のバージョン、または[アプリケーション推論プロファイル ARN](#map-each-model-version-to-an-inference-profile)でセッションを実行している場合、そのモデルを保持し、フォールバックモデルチェーンがないため、リクエストは失敗します。[自動モード](/docs/ja/permission-modes#enable-auto-mode-on-bedrock-agent-platform-or-foundry)では、Claude Code は Amazon Bedrock で自動モードがサポートするモデルにのみ切り替えます。それらのモデルも利用できない場合、リクエストは[AWS 認証失敗](/docs/ja/errors#aws-authentication-failed)で失敗し、モデルを有効にするためのヒントが表示されます。
+
+設定した[フォールバックモデルチェーン](/docs/ja/model-config#fallback-model-chains)はティア切り替えを置き換えます。これらの拒否では Claude Code は設定したフォールバックに切り替えます。拒否されたリクエストが切り替わるのではなく失敗するようにするには、[`CLAUDE_CODE_DISABLE_MODEL_ACCESS_FALLBACK=1`](/docs/ja/env-vars)を設定してください。設定したフォールバックチェーンはこれらの拒否で切り替わります。すべての拒否されたリクエストが失敗するようにしたい場合は、チェーンも削除してください。
+
 <h2 id="cross-region-inference-profile-prefixes">
   クロスリージョン推論プロファイルプレフィックス
@@ -516,4 +528,6 @@ Claude Code は、各リクエストで `X-Amzn-Bedrock-Service-Tier` ヘッダ
 組織が [Claude apps gateway](/docs/ja/claude-apps-gateway) ポリシーを通じて guardrail ヘッダーを配信する場合、それらは [承認が必要な設定](/docs/ja/server-managed-settings#environment-variables-and-the-approval-dialog)としてカウントされます。
 
+guardrail が応答を途中でブロックした場合、それまでにストリーミングされたテキストはそのまま残り、応答はブロックされた応答用に guardrail で設定されたメッセージで終了します。
+
 <h2 id="use-the-mantle-endpoint">
   Mantle エンドポイントを使用する
```

</details>

<details>
<summary>artifacts-ja.md</summary>

```diff
diff --git a/docs-ja/pages/artifacts-ja.md b/docs-ja/pages/artifacts-ja.md
index 9765260..56dd1fa 100644
--- a/docs-ja/pages/artifacts-ja.md
+++ b/docs-ja/pages/artifacts-ja.md
@@ -399,5 +399,5 @@ Artifacts が組織に対して許可されているかどうかは、Claude Cod
 | [権限ルール](/docs/ja/permissions) | `permissions.deny` に `Artifact` を追加します |
 
-[`--settings`](/docs/ja/cli-reference#cli-flags) ファイルで、または `CLAUDE_CODE_DISABLE_ARTIFACT` でアーティファクトをオフにした場合、あるいは管理者が [管理設定](/docs/ja/server-managed-settings) でアーティファクトをオフにした場合、どの設定ファイルもアーティファクトを再度オンにすることはできません。v2.1.242 より前では、[優先度スタック](/docs/ja/settings#settings-precedence) の上位にあるファイルが、下位のファイルで `"enableArtifact": false` が設定されていても、アーティファクトを再度オンにすることができました。
+[`--settings`](/docs/ja/cli-reference#cli-flags) ファイルで、または `CLAUDE_CODE_DISABLE_ARTIFACT` でアーティファクトをオフにした場合、あるいは管理者が [管理設定](/docs/ja/server-managed-settings) でアーティファクトをオフにした場合、どの設定ファイルもアーティファクトを再度オンにすることはできません。
 
 プロジェクトの `.claude/settings.json` または `.claude/settings.local.json` で `"enableArtifact": false` を設定して、そのプロジェクト内のセッションのアーティファクトをオフにすることもできます。どちらのファイルでも `"enableArtifact": true` はアーティファクトを再度オンにしません。プロジェクトおよびローカル設定でこのキーを尊重するには、Claude Code v2.1.242 以降が必要です。
```

</details>

<details>
<summary>authentication-ja.md</summary>

```diff
diff --git a/docs-ja/pages/authentication-ja.md b/docs-ja/pages/authentication-ja.md
index 9e09890..5d12dde 100644
--- a/docs-ja/pages/authentication-ja.md
+++ b/docs-ja/pages/authentication-ja.md
@@ -195,4 +195,24 @@ Claude Code v2.1.212 以降では、ここにリストされているすべて
 * **[Anthropic プロファイルまたはフェデレーション認証情報](#anthropic-profiles-and-federation-credentials)**: `ANTHROPIC_API_KEY`、`ANTHROPIC_AUTH_TOKEN`、または `apiKeyHelper` 認証情報、または以前の Claude Console ログインによって保存された API キーもマシン上に存在する場合を除き、ブロックされません。キーはプロファイルが属する組織を確認しません
 
+<h3 id="restrict-which-api-providers-a-machine-may-use">
+  マシンが使用できる API プロバイダーを制限する
+</h3>
+
+[管理設定](/docs/ja/managed-settings)の [`allowedProviders`](/docs/ja/settings-reference#allowedproviders) は、Anthropic API、Amazon Bedrock、LLM ゲートウェイなど、管理マシンが Claude に到達できるサービスをリストします。これは `forceLoginMethod` と `forceLoginOrgUUID` を補完します。これらは、セッションが Anthropic と通信するときに使用するアカウントを管理します。Claude Code v2.1.285 以降が必要です。
+
+```json managed-settings.json theme={null}
+{
+  "forceLoginMethod": "claudeai",
+  "forceLoginOrgUUID": ["xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"],
+  "allowedProviders": ["anthropic", "bedrock"]
+}
+```
+
+このファイルを使用すると、claude.ai 組織にサインインした開発者または Amazon Bedrock 用に設定された開発者は正常に起動します。他のプロバイダー用に設定されたセッションは起動時に拒否され、実行中のセッションがそのセッションに切り替わると、次のリクエストで拒否されます。[管理設定がこの API プロバイダーを許可していません](/docs/ja/errors#managed-settings-dont-allow-this-api-provider)は各メッセージを表示します。
+
+* **LLM ゲートウェイまたはプロキシを許可する**: `"customEndpoint"` をリストし、同じソースの管理 `env` ブロックでゲートウェイの URL を設定します。[設定リファレンス](/docs/ja/settings-reference#allowedproviders)はすべての値をリストし、どのエンドポイント変数が管理 `env` ピンを必要とするかを示します。
+* **管理マシンにデプロイする**: リストをポリシーの残りを含む管理ソースに配置します。エントリの [スコープ注記](/docs/ja/settings-reference#allowedproviders)は、サーバー管理リストがそれとどのように組み合わされるかを示します。
+* **サーバー管理設定のみ**: [サーバー管理設定](/docs/ja/server-managed-settings)でのみ設定するリストは、組織の設定を取得するセッションにのみ到達するため、デバイス管理で到達できないマシンの利便性として扱い、強制として扱わないでください。[プラットフォーム可用性](/docs/ja/server-managed-settings#platform-availability)はどのセッションがそれらを取得するかをリストします。
+
 <h2 id="credential-management">
   認証情報管理
```

</details>

*...以降省略*

</details>


<details>
<summary>2026-10-01</summary>

**変更ファイル:**

```
 docs-ja/pages/advisor-ja.md                        |   5 +-
 docs-ja/pages/agent-view-ja.md                     |  34 +-
 docs-ja/pages/amazon-bedrock-ja.md                 |   2 +-
 docs-ja/pages/artifacts-ja.md                      |  22 +-
 docs-ja/pages/authentication-ja.md                 |   8 +-
 docs-ja/pages/changelog.md                         |  91 ++++
 docs-ja/pages/claude-apps-gateway-deploy-ja.md     |   2 +-
 docs-ja/pages/claude-apps-gateway-on-aws-ja.md     |  91 +++-
 .../pages/claude-apps-gateway-spend-limits-ja.md   |   2 +-
 docs-ja/pages/claude-directory-ja.md               |   2 +
 docs-ja/pages/claude-projects-ja.md                |  38 +-
 docs-ja/pages/claude-security-ja.md                |  27 +-
 docs-ja/pages/cli-reference-ja.md                  |   7 +-
 docs-ja/pages/cloud-environments-ja.md             |  19 +-
 docs-ja/pages/commands-ja.md                       |  11 +-
 docs-ja/pages/desktop-ja.md                        |  14 +-
 docs-ja/pages/env-vars-ja.md                       | 576 ++++++++++-----------
 docs-ja/pages/errors-ja.md                         | 145 +++++-
 docs-ja/pages/feature-availability-ja.md           |   2 +-
 docs-ja/pages/fullscreen-ja.md                     |   2 +-
 docs-ja/pages/github-enterprise-server-ja.md       |  46 +-
 docs-ja/pages/glossary-ja.md                       |  10 +-
 docs-ja/pages/google-vertex-ai-ja.md               |   2 +-
 docs-ja/pages/interactive-mode-ja.md               |  35 +-
 docs-ja/pages/keybindings-ja.md                    |   7 +-
 docs-ja/pages/llm-gateway-protocol-ja.md           |   2 +-
 docs-ja/pages/managed-mcp-ja.md                    |  47 +-
 docs-ja/pages/mcp-ja.md                            |  21 +-
 docs-ja/pages/memory-ja.md                         | 160 +++---
 docs-ja/pages/monitoring-usage-ja.md               |   6 +-
 docs-ja/pages/network-config-ja.md                 |  26 +-
 docs-ja/pages/permission-modes-ja.md               | 240 +++++----
 docs-ja/pages/permissions-ja.md                    |   6 +-
 docs-ja/pages/prompt-caching-ja.md                 |   6 +-
 docs-ja/pages/remote-control-ja.md                 |   9 +-
 docs-ja/pages/routines-ja.md                       |  22 +-
 docs-ja/pages/sandbox-environments-ja.md           |  32 +-
 docs-ja/pages/scheduled-tasks-ja.md                |   4 +-
 docs-ja/pages/self-hosted-environments-ja.md       |   2 +-
 .../pages/self-hosted-environments-reference-ja.md |  10 +-
 docs-ja/pages/sessions-ja.md                       |  22 +-
 docs-ja/pages/settings-reference-ja.md             |  30 +-
 docs-ja/pages/skills-ja.md                         |  72 ++-
 docs-ja/pages/statusline-ja.md                     |  14 +-
 docs-ja/pages/sub-agents-ja.md                     |   2 -
 docs-ja/pages/third-party-integrations-ja.md       |   2 +-
 docs-ja/pages/tools-reference-ja.md                |  24 +-
 docs-ja/pages/troubleshoot-install-ja.md           |   2 +-
 docs-ja/pages/vs-code-ja.md                        |  26 +-
 49 files changed, 1265 insertions(+), 722 deletions(-)
```

<details>
<summary>advisor-ja.md</summary>

```diff
diff --git a/docs-ja/pages/advisor-ja.md b/docs-ja/pages/advisor-ja.md
index ff1a045..7c98a02 100644
--- a/docs-ja/pages/advisor-ja.md
+++ b/docs-ja/pages/advisor-ja.md
@@ -96,5 +96,5 @@ Claude Code はそのセッションの `advisorModel` 設定の代わりにフ
 </h2>
 
-アドバイザーは、メインモデル以上の能力を持つ必要があります。各メインモデルで受け入れられるアドバイザーは以下の通りです。
+Claude Code と API の両方は、メインモデル以上の能力を持つアドバイザーが必要であり、2 つは一部のモデルを異なる方法でランク付けします。各メインモデルで受け入れられるアドバイザーは以下の通りです。
 
 | メインモデル | 受け入れられるアドバイザー | 注記 |
@@ -102,5 +102,6 @@ Claude Code はそのセッションの `advisorModel` 設定の代わりにフ
 | Haiku 4.5 | Fable、Opus、Sonnet | Haiku はアドバイザーを呼び出すことはできますが、アドバイザーとして機能することはできません |
 | Sonnet 4.6 | Fable、Opus、Sonnet | |
-| Sonnet 5.5 または Sonnet 5 | Fable、Opus 4.7 以降、Sonnet 5 以降 | Sonnet 4.6 アドバイザーは拒否され、API は Opus 4.6 アドバイザーを拒否します |
+| Sonnet 5 | Fable、Opus 4.7 以降、Sonnet 5 以降 | Sonnet 4.6 アドバイザーは拒否され、API は Opus 4.6 アドバイザーを拒否します |
+| Sonnet 5.5 | Fable、Opus 5 以降、Sonnet 5.5 | Sonnet 4.6 アドバイザーは拒否され、API は Sonnet 5、Opus 4.6、Opus 4.7、または Opus 4.8 アドバイザーを拒否します |
 | Opus 4.6 | Fable、Opus、Sonnet 5 以降 | Sonnet 4.6 アドバイザーは拒否されます |
 | Opus 4.7 または Opus 4.8 | Fable、および Opus 4.7 以降 | Opus 4.6 または Sonnet アドバイザーは拒否されます |
```

</details>

<details>
<summary>agent-view-ja.md</summary>

```diff
diff --git a/docs-ja/pages/agent-view-ja.md b/docs-ja/pages/agent-view-ja.md
index ca92a56..ff0f1b3 100644
--- a/docs-ja/pages/agent-view-ja.md
+++ b/docs-ja/pages/agent-view-ja.md
@@ -9,7 +9,7 @@
 `claude agents` で開くエージェントビューは、すべてのバックグラウンドセッションの 1 つの画面です。実行中のもの、入力が必要なもの、完了したものが表示されます。新しいセッションをディスパッチし、トランスクリプトをスクロールする代わりに一目でセッションの状態を確認し、セッションが必要とするときだけ介入します。各バックグラウンドセッションは完全な Claude Code の会話であり、ターミナルが接続されていなくてもバックグラウンドで実行し続けるため、いつでも開いて、返信して、去ることができます。
 
-<img src="https://mintcdn.com/claude-code/1B48Qz2Z9hac4SLG/images/agent-view-light.png?fit=max&auto=format&n=1B48Qz2Z9hac4SLG&q=85&s=7a186c96ed47d6700d084d77e786be65" className="dark:hidden" alt="ターミナルのエージェントビュー：ヘッダーは Claude Code v2.1.140、モデル、作業ディレクトリ、および概要カウントを表示します。セッションは「入力が必要」、「実行中」、「完了」の下にグループ化され、下部にディスパッチ入力とキーボードヒントのフッターがあります。" width="1772" height="780" data-path="images/agent-view-light.png" />
+<img src="https://mintcdn.com/claude-code/HDAmBwgbrZVk0pOt/images/agent-view-light.png?fit=max&auto=format&n=HDAmBwgbrZVk0pOt&q=85&s=d6905012bee31f3e6b3920b09c05dd02" className="dark:hidden" alt="ターミナルのエージェントビュー：ヘッダーは Claude Code v2.1.140、モデル、作業ディレクトリ、および概要カウントを表示します。セッションは「入力が必要」、「実行中」、「完了」の下にグループ化され、下部にディスパッチ入力とキーボードヒントのフッターがあります。" width="1872" height="680" data-path="images/agent-view-light.png" />
 
-<img src="https://mintcdn.com/claude-code/1B48Qz2Z9hac4SLG/images/agent-view-dark.png?fit=max&auto=format&n=1B48Qz2Z9hac4SLG&q=85&s=a5bed7434bae368faea3a8f023b52aa2" className="hidden dark:block" alt="ターミナルのエージェントビュー：ヘッダーは Claude Code v2.1.140、モデル、作業ディレクトリ、および概要カウントを表示します。セッションは「入力が必要」、「実行中」、「完了」の下にグループ化され、下部にディスパッチ入力とキーボードヒントのフッターがあります。" width="1772" height="780" data-path="images/agent-view-dark.png" />
+<img src="https://mintcdn.com/claude-code/HDAmBwgbrZVk0pOt/images/agent-view-dark.png?fit=max&auto=format&n=HDAmBwgbrZVk0pOt&q=85&s=fc3c195bfc57e313ced1f1beb36cee93" className="hidden dark:block" alt="ターミナルのエージェントビュー：ヘッダーは Claude Code v2.1.140、モデル、作業ディレクトリ、および概要カウントを表示します。セッションは「入力が必要」、「実行中」、「完了」の下にグループ化され、下部にディスパッチ入力とキーボードヒントのフッターがあります。" width="1872" height="680" data-path="images/agent-view-dark.png" />
 
 Claude が複数の独立したタスクに対して、あなたが毎ステップを監視することなく作業できる場合に、エージェントビューを使用します。バグ修正、プルリクエストレビュー、不安定なテストの調査を 3 つの行としてディスパッチし、別のウィンドウで作業を続け、行が入力が必要であることを示すか、結果が得られたときに確認します。
@@ -65,8 +65,34 @@ Claude が複数の独立したタスクに対して、あなたが毎ステッ
 </Steps>
 
-`claude agents` を `claude` の代わりにプライマリエントリーポイントとして使用できます。エージェントビューからすべてのタスクをディスパッチし、フル会話が必要な場合はアタッチし、`←` を押してテーブルに戻ります。
-
 通常の `claude` セッション内では、プロンプトフッターの `←` ヒントは、`← 2 agents` のように入力を待機中のバックグラウンドエージェントの数をカウントし、入力が必要なエージェントがない場合は `← for agents` に戻ります。99 を超えるカウントは `99+` として表示されます。カウントはターミナルがフォーカスされている間は約 10 秒ごとに更新され、フォーカスが戻ると即座に更新されます。カウントが移動したときとエージェントが完了したときに色が一時的に変わり、バックグラウンドセッションが完了して入力が必要なエージェントがない場合は、`← 2 done` のように完了した数を一時的に表示します。[`prefersReducedMotion` 設定](/docs/ja/settings-reference#prefersreducedmotion)がオンの場合は両方のフラッシュがオフになり、[スクリーンリーダーモード](/docs/ja/accessibility)ではヒントは非表示になります。
 
+<h3 id="open-agent-view-by-default">
+  デフォルトでエージェントビューを開く
+</h3>
+
+引数なしの `claude` がエージェントビューを新しい会話の代わりに開くようにするには、`/config` 設定をオンにします。
+
+<Steps>
+  <Step title="設定をオンにする">
+    通常の `claude` セッションで `/config` を実行し、**デフォルトでエージェントビューを開く**をオンにします。メニューをスキップするには、[`defaultToAgentsView`](/docs/ja/settings-reference#defaulttoagentsview) キーを直接設定します。
```

</details>

<details>
<summary>amazon-bedrock-ja.md</summary>

```diff
diff --git a/docs-ja/pages/amazon-bedrock-ja.md b/docs-ja/pages/amazon-bedrock-ja.md
index a34cda2..09f0e05 100644
--- a/docs-ja/pages/amazon-bedrock-ja.md
+++ b/docs-ja/pages/amazon-bedrock-ja.md
@@ -484,5 +484,5 @@ Claude Code に必要な権限を持つ IAM ポリシーを作成します。
 Claude Sonnet 5、Opus 4.6 以降、および Sonnet 4.6 は、Amazon Bedrock で [1M トークンコンテキストウィンドウ](https://platform.claude.com/docs/ja/build-with-claude/context-windows#context-window-sizes-by-model)をサポートしています。Sonnet 5 は Invoke API と [Mantle エンドポイント](#use-the-mantle-endpoint)の両方で常に 1M ウィンドウで実行され、選択する `[1m]` バリアントはありません。Invoke API 上の他のモデルについては、Claude Code は 1M モデルバリアントを選択すると、拡張コンテキストウィンドウを自動的に有効にします。
 
-[セットアップウィザード](#sign-in-with-bedrock)は、モデルをピン留めするときに 1M コンテキストオプションを提供します。手動でピン留めされたモデルの代わりに有効にするには、モデル ID に `[1m]` を追加します。詳細については、[サードパーティデプロイメント用のモデルをピン留めする](/docs/ja/model-config#pin-models-for-third-party-deployments)を参照してください。
+[セットアップウィザード](#sign-in-with-bedrock)は、モデルをピン留めするときに 1M コンテキストオプションを提供します。手動でピン留めされたモデルの代わりに有効にするには、モデル ID に `[1m]` を追加します。詳細については、[サードパーティデプロイメント用のモデルをピン留めする](/docs/ja/model-config#pin-models-for-third-party-deployments)を参照してください。1M ウィンドウをピンを変更せずに使用する方法を含みます。
 
 <h2 id="service-tiers">
```

</details>

<details>
<summary>artifacts-ja.md</summary>

```diff
diff --git a/docs-ja/pages/artifacts-ja.md b/docs-ja/pages/artifacts-ja.md
index 9b0331d..9765260 100644
--- a/docs-ja/pages/artifacts-ja.md
+++ b/docs-ja/pages/artifacts-ja.md
@@ -101,5 +101,5 @@ Claude Code で `/artifacts` を実行して、所有しているすべてのア
 
 * **組織内**: Team プランと Enterprise プランでは、組織内の特定のユーザーまたは全員にアクセス権を付与できます。ビューアーは、ページを表示するために claude.ai に組織のメンバーとしてサインインします。
-* **公開**: インターネット上の誰でも開くことができるリンクを共有でき、claude.ai へのサインインは不要です。Pro プランと Max プランでは、公開リンクがアーティファクトを共有する唯一の方法です。Team プランと Enterprise プランでは、Owner が [組織に対して公開共有を有効にする](#control-public-sharing) まで、公開共有はオフになっています。
+* **公開**: インターネット上の誰でも開くことができるリンクを共有でき、claude.ai へのサインインは不要です。Team プランと Enterprise プランでは、Owner が [組織に対して公開共有を有効にする](#control-public-sharing) まで、公開共有はオフになっています。
 
 <h3 id="let-someone-edit-with-you">
@@ -123,5 +123,5 @@ Claude は他の人が書いたページを、[WebFetch](/docs/ja/tools-referenc
 </h2>
 
-組織内でアーティファクトを共有すると、共有相手はページにコメントを残すことができ、Claude がそのコメントを読んで返信することができます。Claude Code v2.1.221 以降と Team または Enterprise プランが必要です。これは、[組織内で共有](#share-an-artifact)したアーティファクトのみがコメントを受け付けるためです。Claude がコメントを読む場合は 2 つあります。
+組織内でアーティファクトを共有すると、共有相手はページにコメントを残すことができ、Claude がそのコメントを読んで返信することができます。Claude Code v2.1.221 以降が必要です。Claude がコメントを読む場合は 2 つあります。
 
 * **Claude に読むよう依頼する場合**：Claude にアーティファクトの URL を提供し、コメントを求めます。Claude は各スレッドをリストアップし、アーティファクトを編集できるユーザーが送信したコメントをマークします。
@@ -130,5 +130,5 @@ Claude は他の人が書いたページを、[WebFetch](/docs/ja/tools-referenc
 Claude は有効になったスレッドにのみ返信または解決できます。その他のスレッドは、ユーザーがページで解決するまで開いたままになります。ビューアーは、各返信が Claude から送信されたものとして表示されます（あなた経由で）。
 
-アーティファクトを公開共有する場合、ビューアーはコメントできません。ページに「`Comments aren't available while this Artifact is shared publicly.`」と表示されます。既にコメントスレッドがあるアーティファクトを公開リンクに切り替えるには、まずスレッドを削除してください。
+アーティファクトを公開共有する場合、公開リンク経由でのみアクセスできるユーザーはコメントを表示できず、追加することもできません。既存のコメントスレッドはアーティファクトに残り、あなたとそのエディターはまだそれらを読んで返信できます。
 
 コメントを自分で読むよう Claude に依頼するには、URL を提供します。
@@ -196,5 +196,5 @@ Claude はページの公開の一部として、ページが呼び出す可能
 コネクタバックアップページを共有する予定がある場合は、Claude に各ライブセクションに必要なコネクタを指定するフォールバックメッセージを含めるよう依頼してください。接続が不足しているビューアには、空のセクションの代わりに接続する内容が表示されます。
 
-コネクタを呼び出すアーティファクトは、どのプランでも公開リンクで共有することはできません。Team および Enterprise プランでは、プライベートに保つか、[組織内で共有](#share-an-artifact) することができます。公開リンクが唯一の共有方法である Pro および Max プランでは、コネクタバックアップアーティファクトはあなたのみにプライベートのままです。
+[アーティファクトを共有](#share-an-artifact) する場合、組織内またはパブリックで共有できます。これはプランと組織の設定によります。コネクタ呼び出しは、claude.ai にサインインせずにパブリックリンクを開いたビューア、または組織外からアクセスしたビューアに対しては実行されません。そのビューアはページをライブセクションなしで表示します。
```

</details>

<details>
<summary>authentication-ja.md</summary>

```diff
diff --git a/docs-ja/pages/authentication-ja.md b/docs-ja/pages/authentication-ja.md
index 57d0fbb..9e09890 100644
--- a/docs-ja/pages/authentication-ja.md
+++ b/docs-ja/pages/authentication-ja.md
@@ -33,4 +33,10 @@ Claude Code は、セットアップに応じて複数の認証方法をサポ
 ログアウトして再認証するには、Claude Code プロンプトで `/logout` と入力します。ログアウトすると、初回起動セットアップ状態もリセットされるため、次回 `claude` を実行するときはログインとセットアップを再度実行します。
 
+ログインに問題がある場合は、[認証のトラブルシューティング](/docs/ja/troubleshoot-install#login-and-authentication)を参照してください。
+
+<h3 id="log-in-with-multiple-accounts">
+  複数のアカウントでログインする
+</h3>
+
 複数のアカウント（仕事用と個人用など）に同時にログインしたままにするには、各アカウントに独自の設定ディレクトリを指定します。`claude` を起動するときに、[`CLAUDE_CONFIG_DIR`](/docs/ja/env-vars#variables) 環境変数を使用するアカウントのディレクトリに設定します。各ディレクトリには、独自の設定、セッション履歴、および claude.ai ログインまたは API キーがあります。たとえば、Bash または Zsh では、`~/.bashrc` または `~/.zshrc` に次のエイリアスを追加して、`claude-work` が仕事用アカウントを使用し、`claude` が個人用アカウントを保持するようにできます。
 
@@ -41,6 +47,4 @@ alias claude-work='CLAUDE_CONFIG_DIR=~/.claude-work claude'
 新しいターミナルを開いて初めて `claude-work` を実行した後、Claude Code は新しいディレクトリのログインとセットアップを実行します。別のディレクトリは、Claude Code がそのような種類のサインインを設定ディレクトリの外に保存するため、2 つの Claude Console サインイン[API キーなし](#sign-in-without-an-api-key)を区別しません。
 
-ログインに問題がある場合は、[認証のトラブルシューティング](/docs/ja/troubleshoot-install#login-and-authentication)を参照してください。
-
 <h2 id="set-up-team-authentication">
   チーム認証を設定する
```

</details>

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index 40d8022..54da060 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,95 @@
 # Changelog
 
+## 2.1.286
+
+- Added a count such as "2 of 5" to the permission prompt when several permission requests stack up
+- Added mouse support for the "N more" rows of lists in fullscreen mode: click one to jump to that end of the list, with hover and pressed states
+- Fixed several Claude Code processes and IDE extensions each opening a login browser when gcpAuthRefresh or awsAuthRefresh credentials expire
+- Fixed `claude --resume` and `--continue` sometimes losing every turn after a batch of parallel tool calls when the earlier session crashed or was killed
+- Fixed API 400 errors after a tool or hook returned an object, number or boolean instead of text, including in resumed sessions
+- Fixed cloud sessions with very large histories never waking up because the container was stopped while the transcript was still loading
+- Fixed the Claude apps gateway's spend meter pricing 1-hour prompt cache writes at the cheaper 5-minute rate, and counting only the first model call's input tokens on streamed turns that run a server-side tool such as web search
+- Fixed macOS sessions still showing "Not logged in" or "Login expired" after `/login` succeeds in another Claude Code window when a leftover `~/.claude/.credentials.json` exists
+- Fixed every turn failing when the Anthropic API refuses the model your default or a model alias resolves to: Claude Code now retries once on the previous model of the same tier
+- Fixed Remote Control sessions (including `claude remote-control`) staying connected after your organization's policy turns Remote Control off; they now disconnect with a notice
+- Fixed refusal and `--fallback-model` retries failing when the fallback model can't run fast; they now run at standard speed, with a one-time notice in interactive sessions
+- Fixed headless sessions repeating the "MCP servers require authentication" reminder after a successful re-authentication when the MCP discovery cache is enabled
+- Fixed `claude auth status` reporting a Console sign-in's stored API key as `claude.ai`; it now reports `api_key`, and the VS Code extension treats that session as an API key session
+- Fixed `/status` listing an Anthropic profile beside an API key as if both were in effect; the profile is now marked as not in use
+- Fixed Claude not being told when a file attached to a message sent over Remote Control did not arrive, and a file sometimes getting only 10 seconds for its last download try
+- Fixed a Remote Control message that arrived while Claude Code was exiting being marked delivered and then never answered; it now stays queued for the session's next run
+- Fixed MCP error messages showing a credential's value when "Bearer" or "Basic" came before its key name
+- Fixed percent-encoded Bearer tokens being only partly masked in error messages
+- Fixed redacted logs and transcripts showing a secret whose key name has an invisible character inside, such as a zero-width space
+- Fixed logs and transcripts showing part of a URL password that contains punctuation such as `)`, quotes, `]`, `&` or a second `@`, or that runs past a `/` to a bracketed host such as `[::1]` in an ssh URL
+- Fixed the session transcript in the zip that `/feedback` saves to disk containing invalid JSON lines after secret redaction
```

</details>

<details>
<summary>claude-apps-gateway-deploy-ja.md</summary>

```diff
diff --git a/docs-ja/pages/claude-apps-gateway-deploy-ja.md b/docs-ja/pages/claude-apps-gateway-deploy-ja.md
index 016fd5a..c2dc23d 100644
--- a/docs-ja/pages/claude-apps-gateway-deploy-ja.md
+++ b/docs-ja/pages/claude-apps-gateway-deploy-ja.md
@@ -304,5 +304,5 @@ readiness プローブを `/healthz` に指定する場合、レプリカは障
 | 推論（プロンプト、完了） | CLI → ゲートウェイ → 上流 | Anthropic API が設定された上流の場合のみ |
 | テレメトリ（OTLP メトリクス、プラス [オプトイン ログとトレース](/docs/ja/claude-apps-gateway-config#telemetry)） | CLI → ゲートウェイ → コレクター | なし |
-| アイデンティティ（メール、グループ、sub） | IdP → ゲートウェイ → JWT → CLI。CLI はそれを OTLP エクスポートにスタンプします。[`forward_user_identity`](/docs/ja/claude-apps-gateway-config#per-user-identity-headers-for-a-proxy-you-run) をオンにすると、ゲートウェイは開発者のメールと IdP サブジェクトをヘッダーとしてプロキシに送信します | なし |
+| アイデンティティ（メール、グループ、sub） | IdP → ゲートウェイ → CLI。CLI はそれを OTLP エクスポートにスタンプします。[`forward_user_identity`](/docs/ja/claude-apps-gateway-config#per-user-identity-headers-for-a-proxy-you-run) をオンにすると、ゲートウェイは開発者のメールと IdP サブジェクトをヘッダーとしてプロキシに送信します | なし |
 | 管理設定 | ゲートウェイ YAML → CLI | なし |
 | 監査ログ | ゲートウェイ stderr → アグリゲーター | なし |
```

</details>

<details>
<summary>claude-apps-gateway-on-aws-ja.md</summary>

```diff
diff --git a/docs-ja/pages/claude-apps-gateway-on-aws-ja.md b/docs-ja/pages/claude-apps-gateway-on-aws-ja.md
index 7e63d36..78986e0 100644
--- a/docs-ja/pages/claude-apps-gateway-on-aws-ja.md
+++ b/docs-ja/pages/claude-apps-gateway-on-aws-ja.md
@@ -513,29 +513,29 @@ export PRIVATE_SUBNETS="<subnet-id-a> <subnet-id-b>"
 </h2>
 
-ゲートウェイは、マシンごとの OTEL 設定なしで開発者ごとの使用メトリクスを提供します。Claude Code は OpenTelemetry（OTLP）メトリクス、ログ、およびオプトインのトレースを発行します。[使用状況の監視](/docs/ja/monitoring-usage)は CLI が報告するすべてをカバーしています。ゲートウェイセッションでは、CLI は各エクスポートに認証された IdP ID 属性 `user.id`、`user.email`、および `user.groups` でスタンプを付けるため、使用状況は `OTEL_RESOURCE_ATTRIBUTES` 配管なしで開発者ごとにロールアップされます。
+ゲートウェイは、マシンごとの OTEL 設定なしで、開発者ごとの使用状況メトリクスを提供します。Claude Code は OpenTelemetry（OTLP）メトリクス、ログ、およびオプトイン トレースを出力します。[使用状況の監視](/docs/ja/monitoring-usage)は、CLI が報告するすべてをカバーしています。`/login` を通じてサインインしたセッションでは、CLI は各エクスポートに認証された IdP ID 属性 `user.id`、`user.email`、および `user.groups` をスタンプし、使用状況は開発者ごとにロールアップされます。
 
-ゲートウェイ自体は認証された OTLP リレーです。[`telemetry.forward_to`](/docs/ja/claude-apps-gateway-config#telemetry) を `listen.public_url` と一緒に設定し、OTEL エクスポーター設定をすべての接続されたクライアントにプッシュし、OTLP トラフィックを逐語的にリストするすべての宛先に転送します。各宛先はメトリクス、ログ、およびトレースを独立して選択し、デフォルトはメトリクスのみです。[`telemetry` リファレンス](/docs/ja/claude-apps-gateway-config#telemetry)を参照してください。シグナルごとのフィールドとそれらの感度トレードオフについて。ゲートウェイはバッファ、集約、またはテレメトリを保存しないため、データが到達する場所は完全にコレクターのエクスポーター設定です。
+ゲートウェイ自体は認証された OTLP リレーです。[`telemetry.forward_to`](/docs/ja/claude-apps-gateway-config#telemetry) を `listen.public_url` と一緒に設定すると、OTEL エクスポーター設定をすべての接続クライアントにプッシュし、OTLP トラフィックを指定した各宛先に逐語的に転送します。各宛先はメトリクス、ログ、およびトレースに独立してオプトインでき、デフォルトはメトリクスのみです。[`telemetry` リファレンス](/docs/ja/claude-apps-gateway-config#telemetry)で、シグナルごとのフィールドとそれらの感度トレードオフを参照してください。ゲートウェイはテレメトリをバッファリング、集約、または保存しないため、データが到達する場所はコレクターのエクスポーター設定に完全に依存します。
 
-クライアントテレメトリはデフォルトでオフです。`telemetry.forward_to` を設定することは、接続された開発者のためにそれをオンにするものです。各インタラクティブクライアントは、[設定リファレンス](/docs/ja/claude-apps-gateway-config#telemetry)で説明されているように、プッシュされた設定の 1 回限りのセキュリティ承認ダイアログを表示します。AWS では、各シグナルは次のように宛先にマップされます。
+クライアント テレメトリはデフォルトでオフです。`telemetry.forward_to` を設定することで、接続された開発者に対してオンになり、各インタラクティブ クライアントはプッシュされた設定に対するセキュリティ承認ダイアログを表示します。これは[設定リファレンス](/docs/ja/claude-apps-gateway-config#telemetry)で説明されています。AWS では、各シグナルは次のように宛先にマップされます。
 
 <h3 id="client-metrics-logs-and-traces">
-  クライアントメトリクス、ログ、およびトレース
+  クライアント メトリクス、ログ、およびトレース
 </h3>
 
-`telemetry.forward_to` を OpenTelemetry コレクター（[AWS Distro for OpenTelemetry（ADOT）コレクター](https://aws-otel.github.io/)など）に指し、Amazon CloudWatch、Amazon Managed Service for Prometheus、または任意の OTLP バックエンドにエクスポートします。
+`telemetry.forward_to` を OpenTelemetry コレクター（[AWS Distro for OpenTelemetry（ADOT）コレクター](https://aws-otel.github.io/)など）にポイントし、そこから Amazon CloudWatch、Amazon Managed Service for Prometheus、または任意の OTLP バックエンドにエクスポートします。
 
-`https://` 経由で到達可能な独自の内部サービスとしてコレクターを実行します。ゲートウェイはループバック URL に対してのみプレーンテキスト `http://` を受け入れ、その場合でも [SSRF ガード](/docs/ja/claude-apps-gateway-deploy#threat-model-summary)はデフォルトで送信時にループバック接続をブロックします。`http://localhost:4318` のサイドカーコレクターは設定検証を渡しますが、トラフィックを受け取りません。エクスポートは `ECONNREFUSED_SSRF` として失敗します。ゲートウェイログで、`CLAUDE_GATEWAY_ALLOW_LOOPBACK=1` がゲートウェイの環境に設定されていない限り。その変数はすべてのオペレーター設定 URL のループバックブロックを緩和し、テレメトリのみではなく、ネットワークが他の方法でロックダウンされているタスクのサイドカープラスフラグセットアップを予約してください。内部サービスパターンを優先します。
+コレクターを `https://` 経由で到達可能な独自の内部サービスとして実行します。[`telemetry` リファレンス](/docs/ja/claude-apps-gateway-config#telemetry)はループバック例外と `CLAUDE_GATEWAY_ALLOW_LOOPBACK` をカバーしています。
 
 <h3 id="gateway-logs">
-  ゲートウェイログ
+  ゲートウェイ ログ
```

</details>

*...以降省略*

</details>


<details>
<summary>2026-09-30</summary>

**変更ファイル:**

```
 docs-ja/pages/artifacts-ja.md                      |  11 +-
 docs-ja/pages/authentication-ja.md                 |  28 +-
 docs-ja/pages/changelog.md                         | 139 ++++
 docs-ja/pages/channels-reference-ja.md             |   4 +-
 docs-ja/pages/claude-apps-gateway-ja.md            |   4 +-
 docs-ja/pages/claude-tag-ja.md                     |   1 -
 docs-ja/pages/cloud-environments-ja.md             |  64 +-
 docs-ja/pages/code-review-ja.md                    |   4 +-
 docs-ja/pages/commands-ja.md                       |   2 +-
 docs-ja/pages/communications-kit-ja.md             |  23 +-
 docs-ja/pages/costs-ja.md                          |   2 +
 docs-ja/pages/cross-session-messaging-ja.md        |   4 +-
 docs-ja/pages/deep-links-ja.md                     |   2 +-
 docs-ja/pages/desktop-ios-simulator-ja.md          |  38 +-
 docs-ja/pages/desktop-ja.md                        |  86 +-
 docs-ja/pages/env-vars-ja.md                       | 552 ++++++-------
 docs-ja/pages/errors-ja.md                         | 209 +++--
 docs-ja/pages/fast-mode-ja.md                      |   2 +
 docs-ja/pages/github-actions-ja.md                 |   2 +
 docs-ja/pages/github-enterprise-server-ja.md       |   2 +-
 docs-ja/pages/hooks-guide-ja.md                    |   2 +-
 docs-ja/pages/keybindings-ja.md                    |  10 +-
 docs-ja/pages/managed-mcp-ja.md                    |  10 +-
 docs-ja/pages/managed-settings-ja.md               |  45 +-
 docs-ja/pages/mcp-ja.md                            |   2 +-
 docs-ja/pages/memory-ja.md                         |   6 +
 docs-ja/pages/monitoring-usage-ja.md               | 908 +++++++++++----------
 docs-ja/pages/permission-modes-ja.md               | 376 +++++----
 docs-ja/pages/permissions-ja.md                    |   1 +
 docs-ja/pages/plugin-evals-ja.md                   |   2 +-
 docs-ja/pages/remote-control-ja.md                 |  13 +-
 docs-ja/pages/routines-ja.md                       |   2 +-
 docs-ja/pages/sandboxing-ja.md                     |   1 +
 docs-ja/pages/scheduled-tasks-ja.md                |   4 +-
 .../self-hosted-environments-configuration-ja.md   |  34 +-
 .../pages/self-hosted-environments-deploy-ja.md    | 109 ++-
 .../self-hosted-environments-quickstart-ja.md      |  24 +-
 docs-ja/pages/sessions-ja.md                       |   4 +-
 docs-ja/pages/settings-ja.md                       |   2 +-
 docs-ja/pages/settings-reference-ja.md             | 300 ++++---
 docs-ja/pages/statusline-ja.md                     |   2 +-
 docs-ja/pages/sub-agents-ja.md                     |   2 +-
 docs-ja/pages/tools-reference-ja.md                |   2 +-
 docs-ja/pages/troubleshoot-install-ja.md           | 151 ++--
 docs-ja/pages/troubleshooting-ja.md                |   2 +-
 docs-ja/pages/vs-code-ja.md                        |   2 +-
 docs-ja/pages/web-quickstart-ja.md                 |   6 +-
 docs-ja/pages/workflows-ja.md                      |   2 +-
 48 files changed, 1848 insertions(+), 1355 deletions(-)
```

**新規追加:**


**削除:**


<details>
<summary>artifacts-ja.md</summary>

```diff
diff --git a/docs-ja/pages/artifacts-ja.md b/docs-ja/pages/artifacts-ja.md
index cadef10..9b0331d 100644
--- a/docs-ja/pages/artifacts-ja.md
+++ b/docs-ja/pages/artifacts-ja.md
@@ -52,14 +52,9 @@ Build a dashboard artifact of last week's deploy failures by service and keep it
 ```
 
-場所を指定しない限り、Claude はページを HTML または Markdown ファイルとしてプロジェクト外の一時ディレクトリに書き込み、公開します。新しいアーティファクトを公開する場合、セッションの[権限モード](/docs/ja/permission-modes)を通じて処理されます。
+場所を指定しない限り、Claude はページを HTML または Markdown ファイルとしてプロジェクト外の一時ディレクトリに書き込み、公開します。[Plan Mode](/docs/ja/permission-modes#analyze-before-you-edit-with-plan-mode) 以外では、入力したプロンプトに応じて Claude が公開する新しいアーティファクトは、権限プロンプトまたは分類器レビューなしで処理されます。ただし、その公開が[コネクタ呼び出し](#pull-live-data-with-mcp-connectors)や[ファイルダウンロード](#offer-a-file-download)などのページのランタイム機能を宣言する場合は除きます。Plan Mode では、Claude Code は各アーティファクトの最初の公開前にあなたに確認を求めます。
 
-* **Auto モード**：分類器がプロンプトの代わりに公開をレビューするため、Claude はプロンプトを表示せずにページを公開できます。セッションが開始される権限モードはプランによって異なります。詳細は[開始時の権限モード](/docs/ja/permission-modes#eliminate-prompts-with-auto-mode)を参照してください。
-* **Manual および Accept edits モード**：Claude Code は権限を要求します。「Claude wants to publish deploy-failures.html, uploading it to claude.ai (Anthropic's servers) to host as the page "Deploy failures by service", private to you until you share it」のようなメッセージが表示される場合があります。**Yes** を選択して公開します。
+アーティファクトは[共有](#share-an-artifact)するまでプライベートなままです。公開共有した後、Claude Code は会話ごとに 1 回変更前に承認を求めるか、[auto mode](/docs/ja/permission-modes#eliminate-prompts-with-auto-mode) では分類器に変更をレビューさせます。
 
-アーティファクトを一度承認すると、Claude Code は再度質問することなく再公開し、以下の場合を含むいくつかのケースで再度質問します。
-
-* Claude がページの[コネクタ呼び出し](#pull-live-data-with-mcp-connectors)や[ファイルダウンロード](#offer-a-file-download)などのランタイム機能を宣言する場合
-* その後、[公開で共有](#share-an-artifact)した場合
-* その後、特定の人またはあなたの組織と共有し、最新バージョンが視聴者が見るバージョンとして選択された場合
+[機能フラグ取得](/docs/ja/env-vars#features-that-need-feature-flag-fetching)をオフにした場合、Claude Code は各アーティファクトの最初の公開前に確認を求めるか、auto mode では分類器にレビューさせます。
 
 最初の公開後、Claude は URL を出力し、ブラウザが新しいページに開きます。[Remote Control](/docs/ja/remote-control)から claude.ai、Claude Desktop、または Claude モバイルアプリを通じてプロンプトを送信した場合、セッションを実行しているマシンではタブが開きません。ブラウザは、Claude がターミナルで入力したプロンプトからアーティファクトを再度公開する次回に開きます。任意の時点で `Ctrl+]` を押して、セッションの最新アーティファクトを再度開きます。
```

</details>

<details>
<summary>authentication-ja.md</summary>

```diff
diff --git a/docs-ja/pages/authentication-ja.md b/docs-ja/pages/authentication-ja.md
index 02b41cc..57d0fbb 100644
--- a/docs-ja/pages/authentication-ja.md
+++ b/docs-ja/pages/authentication-ja.md
@@ -131,5 +131,5 @@ API キーを作成しなくても Console アカウントにサインインで
 * マシン上に管理設定ファイル、MDM プロファイル、キャッシュされたサーバー管理設定などの管理設定ソースが存在しますが、Claude Code が [それを読み取ることができず](/docs/ja/managed-settings#invalid-entries-in-managed-settings)、他の管理ソースがポリシーを提供していない
 
-キーなしでサインインする前に `ANTHROPIC_API_KEY` を設定解除してください。Claude Code 独自の Console サインインまたは Claude Platform CLI の `ant auth login` によって書き込まれたプロファイルは、同じ種類の認証情報であるため、再度サインインするとそれが置き換わります。
+キーなしでサインインする前に `ANTHROPIC_API_KEY` を設定解除してください。
 
 キーなしでサインインした後、保存された API キーの代わりにプロファイルが得られます。
@@ -173,7 +173,9 @@ Claude Console ログインの場合、Claude Code は `forceLoginOrgUUID` を
 任意の設定ファイルで `forceLoginOrgUUID` を設定した場合、Claude Code はそのファイルが適用されるセッションで [キーレス Console サインイン](#sign-in-without-an-api-key)の提供を停止し、代わりに API キーを作成します。開発者を claude.ai サインインに向かわせるには、`forceLoginMethod` を `"claudeai"` に設定します。
 
-開発者は複数のパスからログインできます。ターミナル `/login` フロー、[VS Code 拡張機能](/docs/ja/vs-code)、Agent SDK、`claude setup-token`、`/install-github-app`、およびクラウドゲートウェイを通じてルーティングする組織の [ゲートウェイ](/docs/ja/claude-apps-gateway)サインイン。Claude Code v2.1.212 以降では、すべてのパスが `forceLoginMethod` を適用します。v2.1.212 より前では、ターミナルログインのみが両方のキーを適用していました。ターミナルのインタラクティブログイン画面（`/login` または初回オンボーディングで到達）では、Claude Code は `claudeai` または `console` メソッドを強制せずに事前選択するため、`forceLoginMethod` が `"claudeai"` に設定されている場合でも、開発者は Console ログインをそこで完了できます。パスは `forceLoginOrgUUID` で異なります。
+Claude Code v2.1.212 以降では、ここにリストされているすべてのログインパスが `forceLoginMethod` を適用します。ターミナルのインタラクティブログイン画面（`/login` または初回オンボーディングで到達）では、Claude Code は `claudeai` または `console` メソッドを強制せずに事前選択するため、`forceLoginMethod` が `"claudeai"` に設定されている場合でも、開発者は Console ログインをそこで完了できます。
 
-* **ターミナル、VS Code 拡張機能、および Agent SDK ログイン**: claude.ai アカウントログインの `forceLoginOrgUUID` を確認します
+パスは `forceLoginOrgUUID` で異なります。
+
+* **ターミナル、[VS Code 拡張機能](/docs/ja/vs-code)、および Agent SDK ログイン**: claude.ai アカウントログインの `forceLoginOrgUUID` を確認します
 * **`claude setup-token` および `/install-github-app`**: `forceLoginMethod` のみを強制するため、別の組織でトークンを生成できます
 * **[ゲートウェイ](/docs/ja/claude-apps-gateway)サインイン**: `forceLoginMethod: "gateway"` によって選択され、それによって制限されず、Anthropic 組織に対して認証されないため、`forceLoginOrgUUID` は適用されません。ゲートウェイ ID プロバイダーを使用してアクセスを制限します
@@ -203,7 +205,7 @@ Claude Code は認証情報を安全に管理します。
 * **サポートされている認証タイプ**: claude.ai 認証情報、Claude API 認証情報、Microsoft Foundry Auth、Bedrock Auth、Vertex Auth、Anthropic プロファイルおよび [Workload Identity Federation](https://platform.claude.com/docs/en/manage-claude/workload-identity-federation) 認証情報、および [Claude apps gateway](/docs/ja/claude-apps-gateway) セッショントークン。
 * **カスタム認証情報スクリプト**: [`apiKeyHelper`](/docs/ja/settings-reference#apikeyhelper) 設定を構成して、API キーを返すシェルスクリプトを実行します。
-* **更新間隔**: Claude Code はデフォルトで 5 分後に `apiKeyHelper` を再実行します。カスタム更新間隔の場合は、`CLAUDE_CODE_API_KEY_HELPER_TTL_MS` 環境変数を設定してください。Claude Code がヘルパーを再実行する他のケースについては、[`apiKeyHelper`](/docs/ja/settings-reference#apikeyhelper) を参照してください。
+* **更新間隔**: [`apiKeyHelper`](/docs/ja/settings-reference#apikeyhelper) の場合を参照してください。Claude Code はヘルパーを再実行する場合があります。
 * **遅いヘルパー通知**: `apiKeyHelper` がキーを返すのに 10 秒以上かかる場合、Claude Code はプロンプトバーに経過時間を表示する警告通知を表示します。この通知が定期的に表示される場合は、認証情報スクリプトを最適化できるかどうかを確認してください。
-* **ヘルパーの失敗**: スクリプトがエラーで終了したり、タイムアウトしたり、何も出力しない場合、リクエストは 3 回の試行内に [`Your apiKeyHelper script is failing`](/docs/ja/errors#your-apikeyhelper-script-is-failing) で失敗します。v2.1.208 より前では、ヘルパーの失敗は約 10 回のサイレント再試行後に汎用 401 として表示されていました。
```

</details>

<!-- UPDATE_LOG_END -->
