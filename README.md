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

<!-- UPDATE_LOG_END -->
