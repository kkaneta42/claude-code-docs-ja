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

<!-- UPDATE_LOG_END -->
