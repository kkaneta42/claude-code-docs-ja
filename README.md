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
<summary>2026-04-02</summary>

**変更ファイル:**

```
 docs-ja/pages/changelog.md            | 77 +++++++++++++++++++++++++++++++++++
 docs-ja/pages/hooks-guide-ja.md       |  1 +
 docs-ja/pages/hooks-ja.md             |  3 +-
 docs-ja/pages/overview-ja.md          |  2 +
 docs-ja/pages/plugins-reference-ja.md |  1 +
 docs-ja/pages/quickstart-ja.md        |  2 +
 docs-ja/pages/setup-ja.md             |  2 +
 7 files changed, 87 insertions(+), 1 deletion(-)
```

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index 700d711..10da815 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,81 @@
 # Changelog
 
+## 2.1.90
+
+- Added `/powerup` — interactive lessons teaching Claude Code features with animated demos
+- Added `CLAUDE_CODE_PLUGIN_KEEP_MARKETPLACE_ON_FAILURE` env var to keep the existing marketplace cache when `git pull` fails, useful in offline environments
+- Added `.husky` to protected directories (acceptEdits mode)
+- Fixed an infinite loop where the rate-limit options dialog would repeatedly auto-open after hitting your usage limit, eventually crashing the session
+- Fixed `--resume` causing a full prompt-cache miss on the first request for users with deferred tools, MCP servers, or custom agents (regression since v2.1.69)
+- Fixed `Edit`/`Write` failing with "File content has changed" when a PostToolUse format-on-save hook rewrites the file between consecutive edits
+- Fixed `PreToolUse` hooks that emit JSON to stdout and exit with code 2 not correctly blocking the tool call
+- Fixed collapsed search/read summary badge appearing multiple times in fullscreen scrollback when a CLAUDE.md file auto-loads during a tool call
+- Fixed auto mode not respecting explicit user boundaries ("don't push", "wait for X before Y") even when the action would otherwise be allowed
+- Fixed click-to-expand hover text being nearly invisible on light terminal themes
+- Fixed UI crash when malformed tool input reached the permission dialog
+- Fixed headers disappearing when scrolling `/model`, `/config`, and other selection screens
+- Hardened PowerShell tool permission checks: fixed trailing `&` background job bypass, `-ErrorAction Break` debugger hang, archive-extraction TOCTOU, and parse-fail fallback deny-rule degradation
+- Improved performance: eliminated per-turn JSON.stringify of MCP tool schemas on cache-key lookup
+- Improved performance: SSE transport now handles large streamed frames in linear time (was quadratic)
+- Improved performance: SDK sessions with long conversations no longer slow down quadratically on transcript writes
+- Improved `/resume` all-projects view to load project sessions in parallel, improving load times for users with many projects
+- Changed `--resume` picker to no longer show sessions created by `claude -p` or SDK invocations
+- Removed `Get-DnsClientCache` and `ipconfig /displaydns` from auto-allow (DNS cache privacy)
+
+## 2.1.89
```

</details>

<details>
<summary>hooks-guide-ja.md</summary>

```diff
diff --git a/docs-ja/pages/hooks-guide-ja.md b/docs-ja/pages/hooks-guide-ja.md
index b7a0444..572a0b6 100644
--- a/docs-ja/pages/hooks-guide-ja.md
+++ b/docs-ja/pages/hooks-guide-ja.md
@@ -385,4 +385,5 @@ Hook イベントは Claude Code のライフサイクルの特定のポイン
 | `PreToolUse`         | Before a tool call executes. Can block it                                                                                                              |
 | `PermissionRequest`  | When a permission dialog appears                                                                                                                       |
+| `PermissionDenied`   | When a tool call is denied by the auto mode classifier. Return `{retry: true}` to tell the model it may retry the denied tool call                     |
 | `PostToolUse`        | After a tool call succeeds                                                                                                                             |
 | `PostToolUseFailure` | After a tool call fails                                                                                                                                |
```

</details>

<details>
<summary>hooks-ja.md</summary>

```diff
diff --git a/docs-ja/pages/hooks-ja.md b/docs-ja/pages/hooks-ja.md
index 3722f65..32dd78a 100644
--- a/docs-ja/pages/hooks-ja.md
+++ b/docs-ja/pages/hooks-ja.md
@@ -19,5 +19,5 @@
 <div style={{maxWidth: "500px", margin: "0 auto"}}>
   <Frame>
-    <img src="https://mintcdn.com/claude-code/1wr0LPds6lVWZkQB/images/hooks-lifecycle.svg?fit=max&auto=format&n=1wr0LPds6lVWZkQB&q=85&s=53a826e7bb64c6bff5f867506c0530ad" alt="SessionStart から agentic ループを経由して SessionEnd までのフックのシーケンスを示すフック ライフサイクル図。agentic ループ内に PreToolUse、PermissionRequest、PostToolUse、SubagentStart/Stop、TaskCreated、TaskCompleted が含まれ、Elicitation と ElicitationResult が MCP ツール実行内にネストされ、WorktreeCreate、WorktreeRemove、Notification、ConfigChange、InstructionsLoaded、CwdChanged、FileChanged がスタンドアロン非同期イベント" width="520" height="1155" data-path="images/hooks-lifecycle.svg" />
+    <img src="https://mintcdn.com/claude-code/WLZtXlltXc8aIoIM/images/hooks-lifecycle.svg?fit=max&auto=format&n=WLZtXlltXc8aIoIM&q=85&s=6a0bf67eeb570a96e36b564721fa2a93" alt="SessionStart から agentic ループを経由して SessionEnd までのフックのシーケンスを示すフック ライフサイクル図。agentic ループ内に PreToolUse、PermissionRequest、PostToolUse、SubagentStart/Stop、TaskCreated、TaskCompleted が含まれ、Elicitation と ElicitationResult が MCP ツール実行内にネストされ、WorktreeCreate、WorktreeRemove、Notification、ConfigChange、InstructionsLoaded、CwdChanged、FileChanged がスタンドアロン非同期イベント" width="520" height="1155" data-path="images/hooks-lifecycle.svg" />
   </Frame>
 </div>
@@ -31,4 +31,5 @@
 | `PreToolUse`         | Before a tool call executes. Can block it                                                                                                              |
 | `PermissionRequest`  | When a permission dialog appears                                                                                                                       |
+| `PermissionDenied`   | When a tool call is denied by the auto mode classifier. Return `{retry: true}` to tell the model it may retry the denied tool call                     |
 | `PostToolUse`        | After a tool call succeeds                                                                                                                             |
 | `PostToolUseFailure` | After a tool call fails                                                                                                                                |
```

</details>

<details>
<summary>overview-ja.md</summary>

```diff
diff --git a/docs-ja/pages/overview-ja.md b/docs-ja/pages/overview-ja.md
index 9791fef..09b7ba9 100644
--- a/docs-ja/pages/overview-ja.md
+++ b/docs-ja/pages/overview-ja.md
@@ -39,4 +39,6 @@ Claude Code は AI を活用したコーディングアシスタントで、機
         ```
 
+        If you see `The token '&&' is not a valid statement separator`, you're in PowerShell, not CMD. Use the PowerShell command above instead. Your prompt shows `PS C:\` when you're in PowerShell.
+
         **Windows requires [Git for Windows](https://git-scm.com/downloads/win).** Install it first if you don't have it.
 
```

</details>

<details>
<summary>plugins-reference-ja.md</summary>

```diff
diff --git a/docs-ja/pages/plugins-reference-ja.md b/docs-ja/pages/plugins-reference-ja.md
index 0f5a4d6..50bed15 100644
--- a/docs-ja/pages/plugins-reference-ja.md
+++ b/docs-ja/pages/plugins-reference-ja.md
@@ -115,4 +115,5 @@ disallowedTools: Write, Edit
 | `PreToolUse`         | Before a tool call executes. Can block it                                                                                                              |
 | `PermissionRequest`  | When a permission dialog appears                                                                                                                       |
+| `PermissionDenied`   | When a tool call is denied by the auto mode classifier. Return `{retry: true}` to tell the model it may retry the denied tool call                     |
 | `PostToolUse`        | After a tool call succeeds                                                                                                                             |
 | `PostToolUseFailure` | After a tool call fails                                                                                                                                |
```

</details>

<details>
<summary>quickstart-ja.md</summary>

```diff
diff --git a/docs-ja/pages/quickstart-ja.md b/docs-ja/pages/quickstart-ja.md
index 85861ff..b90c178 100644
--- a/docs-ja/pages/quickstart-ja.md
+++ b/docs-ja/pages/quickstart-ja.md
@@ -654,4 +654,6 @@ To install Claude Code, use one of the following methods:
     ```
 
+    If you see `The token '&&' is not a valid statement separator`, you're in PowerShell, not CMD. Use the PowerShell command above instead. Your prompt shows `PS C:\` when you're in PowerShell.
+
     **Windows requires [Git for Windows](https://git-scm.com/downloads/win).** Install it first if you don't have it.
 
```

</details>

<details>
<summary>setup-ja.md</summary>

```diff
diff --git a/docs-ja/pages/setup-ja.md b/docs-ja/pages/setup-ja.md
index bdeb83d..7421a3f 100644
--- a/docs-ja/pages/setup-ja.md
+++ b/docs-ja/pages/setup-ja.md
@@ -58,4 +58,6 @@ To install Claude Code, use one of the following methods:
     ```
 
+    If you see `The token '&&' is not a valid statement separator`, you're in PowerShell, not CMD. Use the PowerShell command above instead. Your prompt shows `PS C:\` when you're in PowerShell.
+
     **Windows requires [Git for Windows](https://git-scm.com/downloads/win).** Install it first if you don't have it.
 
```

</details>

</details>


<details>
<summary>2026-04-01</summary>

**変更ファイル:**

```
 docs-ja/pages/changelog.md          |  44 -----
 docs-ja/pages/env-vars-ja.md        | 232 +++++++++++++-------------
 docs-ja/pages/hooks-ja.md           | 317 ++++++++++++++++++++++++------------
 docs-ja/pages/terminal-config-ja.md |  20 ++-
 4 files changed, 352 insertions(+), 261 deletions(-)
```

**新規追加:**


<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index 68dcaad..700d711 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,48 +1,4 @@
 # Changelog
 
-## 2.1.88
-
-- Added `CLAUDE_CODE_NO_FLICKER=1` environment variable to opt into flicker-free alt-screen rendering with virtualized scrollback
-- Added `PermissionDenied` hook that fires after auto mode classifier denials — return `{retry: true}` to tell the model it can retry
-- Added named subagents to `@` mention typeahead suggestions
-- Fixed prompt cache misses in long sessions caused by tool schema bytes changing mid-session
-- Fixed nested CLAUDE.md files being re-injected dozens of times in long sessions that read many files
-- Fixed Edit/Write tools doubling CRLF on Windows and stripping Markdown hard line breaks (two trailing spaces)
-- Fixed `StructuredOutput` schema cache bug causing ~50% failure rate in workflows with multiple schemas
-- Fixed memory leak where large JSON inputs were retained as LRU cache keys in long-running sessions
-- Fixed a potential out-of-memory crash when the Edit tool was used on very large files (>1 GiB)
-- Fixed a crash when removing a message from very large session files (over 50MB)
-- Fixed `--resume` crash when transcript contains a tool result from an older CLI version or interrupted write
-- Fixed misleading "Rate limit reached" message when the API returned an entitlement error — now shows the actual error with actionable hints
-- Fixed LSP server zombie state after crash — server now restarts on next request instead of failing until session restart
-- Fixed hooks `if` condition filtering not matching compound commands (`ls && git push`) or commands with env-var prefixes (`FOO=bar git push`)
-- Fixed prompt history entries containing CJK or emoji being silently dropped when they fall on a 4KB boundary in `~/.claude/history.jsonl`
-- Fixed `/stats` losing historical data beyond 30 days when the stats cache format changes
-- Fixed `/stats` undercounting tokens by excluding subagent/fork usage
-- Fixed scrollback disappearing when scrolling up in long sessions
-- Fixed collapsed search/read group badges duplicating in terminal scrollback during heavy parallel tool use
-- Fixed notification `invalidates` not clearing the currently-displayed notification immediately
-- Fixed prompt briefly disappearing after submit when background messages arrived during processing
```

</details>

<details>
<summary>env-vars-ja.md</summary>

```diff
diff --git a/docs-ja/pages/env-vars-ja.md b/docs-ja/pages/env-vars-ja.md
index 336b660..3baa51c 100644
--- a/docs-ja/pages/env-vars-ja.md
+++ b/docs-ja/pages/env-vars-ja.md
@@ -9,113 +9,127 @@
 Claude Code は、その動作を制御するために以下の環境変数をサポートしています。`claude` を起動する前にシェルで設定するか、[`settings.json`](/ja/settings#available-settings) の `env` キーで設定して、すべてのセッションに適用するか、チーム全体にロールアウトしてください。
 
-| 変数                                             | 目的                                                                                                                                                                                                                                                                                                                                                                               |
-| :--------------------------------------------- | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
-| `ANTHROPIC_API_KEY`                            | `X-Api-Key` ヘッダーとして送信される API キー。設定されている場合、ログインしていても Claude Pro、Max、Team、または Enterprise サブスクリプションの代わりにこのキーが使用されます。非対話モード（`-p`）では、キーが存在する場合は常に使用されます。対話モードでは、キーがサブスクリプションをオーバーライドする前に一度承認するよう求められます。代わりにサブスクリプションを使用するには、`unset ANTHROPIC_API_KEY` を実行してください                                                                                                                       |
-| `ANTHROPIC_AUTH_TOKEN`                         | `Authorization` ヘッダーのカスタム値（ここで設定した値には `Bearer ` が接頭辞として付けられます）                                                                                                                                                                                                                                                                                                                   |
-| `ANTHROPIC_BASE_URL`                           | API エンドポイントをオーバーライドして、プロキシまたはゲートウェイを通じてリクエストをルーティングします。ファーストパーティ以外のホストに設定されている場合、[MCP ツール検索](/ja/mcp#scale-with-mcp-tool-search) はデフォルトで無効になります。プロキシが `tool_reference` ブロックを転送する場合は、`ENABLE_TOOL_SEARCH=true` を設定してください                                                                                                                                                          |
-| `ANTHROPIC_CUSTOM_HEADERS`                     | リクエストに追加するカスタムヘッダー（`Name: Value` 形式、複数のヘッダーの場合は改行で区切られます）                                                                                                                                                                                                                                                                                                                        |
-| `ANTHROPIC_CUSTOM_MODEL_OPTION`                | `/model` ピッカーにカスタムエントリとして追加するモデル ID。組み込みエイリアスを置き換えずに、非標準またはゲートウェイ固有のモデルを選択可能にするために使用します。[モデル設定](/ja/model-config#add-a-custom-model-option) を参照してください                                                                                                                                                                                                                            |
-| `ANTHROPIC_CUSTOM_MODEL_OPTION_DESCRIPTION`    | `/model` ピッカーのカスタムモデルエントリの表示説明。設定されていない場合、デフォルトは `Custom model (<model-id>)` です                                                                                                                                                                                                                                                                                                  |
-| `ANTHROPIC_CUSTOM_MODEL_OPTION_NAME`           | `/model` ピッカーのカスタムモデルエントリの表示名。設定されていない場合、デフォルトはモデル ID です                                                                                                                                                                                                                                                                                                                         |
-| `ANTHROPIC_DEFAULT_HAIKU_MODEL`                | [モデル設定](/ja/model-config#environment-variables) を参照してください                                                                                                                                                                                                                                                                                                                        |
-| `ANTHROPIC_DEFAULT_OPUS_MODEL`                 | [モデル設定](/ja/model-config#environment-variables) を参照してください                                                                                                                                                                                                                                                                                                                        |
-| `ANTHROPIC_DEFAULT_SONNET_MODEL`               | [モデル設定](/ja/model-config#environment-variables) を参照してください                                                                                                                                                                                                                                                                                                                        |
-| `ANTHROPIC_FOUNDRY_API_KEY`                    | Microsoft Foundry 認証用の API キー（[Microsoft Foundry](/ja/microsoft-foundry) を参照してください）                                                                                                                                                                                                                                                                                              |
-| `ANTHROPIC_FOUNDRY_BASE_URL`                   | Foundry リソースの完全なベース URL（例：`https://my-resource.services.ai.azure.com/anthropic`）。`ANTHROPIC_FOUNDRY_RESOURCE` の代替（[Microsoft Foundry](/ja/microsoft-foundry) を参照してください）                                                                                                                                                                                                          |
-| `ANTHROPIC_FOUNDRY_RESOURCE`                   | Foundry リソース名（例：`my-resource`）。`ANTHROPIC_FOUNDRY_BASE_URL` が設定されていない場合は必須（[Microsoft Foundry](/ja/microsoft-foundry) を参照してください）                                                                                                                                                                                                                                                 |
-| `ANTHROPIC_MODEL`                              | 使用するモデル設定の名前（[モデル設定](/ja/model-config#environment-variables) を参照してください）                                                                                                                                                                                                                                                                                                          |
-| `ANTHROPIC_SMALL_FAST_MODEL`                   | \[非推奨] バックグラウンドタスク用の [Haiku クラスモデルの名前](/ja/costs)                                                                                                                                                                                                                                                                                                                                |
-| `ANTHROPIC_SMALL_FAST_MODEL_AWS_REGION`        | Bedrock を使用する場合、Haiku クラスモデルの AWS リージョンをオーバーライドします                                                                                                                                                                                                                                                                                                                               |
-| `AWS_BEARER_TOKEN_BEDROCK`                     | 認証用の Bedrock API キー（[Bedrock API キー](https://aws.amazon.com/blogs/machine-learning/accelerate-ai-development-with-amazon-bedrock-api-keys/) を参照してください）                                                                                                                                                                                                                           |
-| `BASH_DEFAULT_TIMEOUT_MS`                      | 長時間実行される bash コマンドのデフォルトタイムアウト                                                                                                                                                                                                                                                                                                                                                   |
-| `BASH_MAX_OUTPUT_LENGTH`                       | bash 出力が中央で切り詰められる前の最大文字数                                                                                                                                                                                                                                                                                                                                                        |
-| `BASH_MAX_TIMEOUT_MS`                          | 長時間実行される bash コマンドに対してモデルが設定できる最大タイムアウト                                                                                                                                                                                                                                                                                                                                          |
-| `CLAUDECODE`                                   | Claude Code がスポーンするシェル環境（Bash ツール、tmux セッション）で `1` に設定されます。[フック](/ja/hooks) または [ステータスライン](/ja/statusline) コマンドでは設定されません。スクリプトが Claude Code によってスポーンされたシェル内で実行されているかどうかを検出するために使用します                                                                                                                                                                                             |
```

</details>

<details>
<summary>hooks-ja.md</summary>

```diff
diff --git a/docs-ja/pages/hooks-ja.md b/docs-ja/pages/hooks-ja.md
index 59c84e0..3722f65 100644
--- a/docs-ja/pages/hooks-ja.md
+++ b/docs-ja/pages/hooks-ja.md
@@ -19,5 +19,5 @@
 <div style={{maxWidth: "500px", margin: "0 auto"}}>
   <Frame>
-    <img src="https://mintcdn.com/claude-code/1wr0LPds6lVWZkQB/images/hooks-lifecycle.svg?fit=max&auto=format&n=1wr0LPds6lVWZkQB&q=85&s=53a826e7bb64c6bff5f867506c0530ad" alt="SessionStart から agentic ループを経由して SessionEnd までのフックのシーケンスを示すフック ライフサイクル図。agentic ループ内に PreToolUse、PermissionRequest、PostToolUse、SubagentStart/Stop、TaskCompleted が含まれ、Elicitation と ElicitationResult が MCP ツール実行内にネストされ、WorktreeCreate、WorktreeRemove、Notification、ConfigChange、InstructionsLoaded がスタンドアロン非同期イベント" width="520" height="1155" data-path="images/hooks-lifecycle.svg" />
+    <img src="https://mintcdn.com/claude-code/1wr0LPds6lVWZkQB/images/hooks-lifecycle.svg?fit=max&auto=format&n=1wr0LPds6lVWZkQB&q=85&s=53a826e7bb64c6bff5f867506c0530ad" alt="SessionStart から agentic ループを経由して SessionEnd までのフックのシーケンスを示すフック ライフサイクル図。agentic ループ内に PreToolUse、PermissionRequest、PostToolUse、SubagentStart/Stop、TaskCreated、TaskCompleted が含まれ、Elicitation と ElicitationResult が MCP ツール実行内にネストされ、WorktreeCreate、WorktreeRemove、Notification、ConfigChange、InstructionsLoaded、CwdChanged、FileChanged がスタンドアロン非同期イベント" width="520" height="1155" data-path="images/hooks-lifecycle.svg" />
   </Frame>
 </div>
@@ -55,5 +55,5 @@
 ### フックがどのように解決されるか
 
-これらの部分がどのように組み合わさるかを理解するために、破壊的なシェル コマンドをブロックする `PreToolUse` フックを考えてみましょう。このフックは、すべての Bash ツール呼び出しの前に `block-rm.sh` を実行します。
+これらの部分がどのように組み合わさるかを理解するために、破壊的なシェル コマンドをブロックする `PreToolUse` フックを考えてみましょう。`matcher` は Bash ツール呼び出しに絞り込み、`if` 条件は `rm` で始まるコマンドにさらに絞り込むため、`block-rm.sh` は両方のフィルターがマッチするときのみ生成されます。
 
 ```json  theme={null}
@@ -66,5 +66,6 @@
           {
             "type": "command",
-            "command": ".claude/hooks/block-rm.sh"
+            "if": "Bash(rm *)",
+            "command": "\"$CLAUDE_PROJECT_DIR\"/.claude/hooks/block-rm.sh"
           }
         ]
@@ -98,5 +99,5 @@ fi
 
 <Frame>
-  <img src="https://mintcdn.com/claude-code/-tYw1BD_DEqfyyOZ/images/hook-resolution.svg?fit=max&auto=format&n=-tYw1BD_DEqfyyOZ&q=85&s=c73ebc1eeda2037570427d7af1e0a891" alt="フック解決フロー: PreToolUse イベントが発火し、マッチャーが Bash マッチをチェックし、フック ハンドラーが実行され、結果が Claude Code に返される" width="930" height="290" data-path="images/hook-resolution.svg" />
```

</details>

<details>
<summary>terminal-config-ja.md</summary>

```diff
diff --git a/docs-ja/pages/terminal-config-ja.md b/docs-ja/pages/terminal-config-ja.md
index 25693cf..3791a93 100644
--- a/docs-ja/pages/terminal-config-ja.md
+++ b/docs-ja/pages/terminal-config-ja.md
@@ -36,9 +36,13 @@ Claude Code 内で `/terminal-setup` を実行して、VS Code、Alacritty、Zed
 2. 「Option キーを Meta キーとして使用」をチェックする
 
-**iTerm2 および VS Code ターミナルの場合：**
+**iTerm2 の場合：**
 
 1. 設定 → プロファイル → キーを開く
 2. 「一般」で、左右の Option キーを「Esc+」に設定する
 
+**VS Code ターミナルの場合：**
+
+VS Code 設定で `"terminal.integrated.macOptionIsMeta": true` を設定します。
+
 ### 通知設定
 
@@ -55,4 +59,12 @@ Kitty と Ghostty は追加設定なしでデスクトップ通知をサポー
 通知が表示されない場合は、ターミナルアプリが OS 設定で通知権限を持っていることを確認してください。
 
+Claude Code を tmux 内で実行する場合、通知と[ターミナルプログレスバー](/ja/settings#global-config-settings)は、tmux 設定でパススルーを有効にした場合にのみ、iTerm2、Kitty、または Ghostty などの外側のターミナルに到達します。
+
+```
+set -g allow-passthrough on
+```
+
+この設定がない場合、tmux はエスケープシーケンスをインターセプトし、ターミナルアプリケーションに到達しません。
+
```

</details>

</details>


<details>
<summary>2026-03-31</summary>

**変更ファイル:**

```
 docs-ja/pages/changelog.md                 | 44 ++++++++++++++++++++++++++++
 docs-ja/pages/claude-code-on-the-web-ja.md | 46 +++++++++++++++++++++++++++++-
 docs-ja/pages/hooks-ja.md                  |  2 +-
 docs-ja/pages/voice-dictation-en.md        |  2 +-
 4 files changed, 91 insertions(+), 3 deletions(-)
```

**新規追加:**


<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index 700d711..68dcaad 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,48 @@
 # Changelog
 
+## 2.1.88
+
+- Added `CLAUDE_CODE_NO_FLICKER=1` environment variable to opt into flicker-free alt-screen rendering with virtualized scrollback
+- Added `PermissionDenied` hook that fires after auto mode classifier denials — return `{retry: true}` to tell the model it can retry
+- Added named subagents to `@` mention typeahead suggestions
+- Fixed prompt cache misses in long sessions caused by tool schema bytes changing mid-session
+- Fixed nested CLAUDE.md files being re-injected dozens of times in long sessions that read many files
+- Fixed Edit/Write tools doubling CRLF on Windows and stripping Markdown hard line breaks (two trailing spaces)
+- Fixed `StructuredOutput` schema cache bug causing ~50% failure rate in workflows with multiple schemas
+- Fixed memory leak where large JSON inputs were retained as LRU cache keys in long-running sessions
+- Fixed a potential out-of-memory crash when the Edit tool was used on very large files (>1 GiB)
+- Fixed a crash when removing a message from very large session files (over 50MB)
+- Fixed `--resume` crash when transcript contains a tool result from an older CLI version or interrupted write
+- Fixed misleading "Rate limit reached" message when the API returned an entitlement error — now shows the actual error with actionable hints
+- Fixed LSP server zombie state after crash — server now restarts on next request instead of failing until session restart
+- Fixed hooks `if` condition filtering not matching compound commands (`ls && git push`) or commands with env-var prefixes (`FOO=bar git push`)
+- Fixed prompt history entries containing CJK or emoji being silently dropped when they fall on a 4KB boundary in `~/.claude/history.jsonl`
+- Fixed `/stats` losing historical data beyond 30 days when the stats cache format changes
+- Fixed `/stats` undercounting tokens by excluding subagent/fork usage
+- Fixed scrollback disappearing when scrolling up in long sessions
+- Fixed collapsed search/read group badges duplicating in terminal scrollback during heavy parallel tool use
+- Fixed notification `invalidates` not clearing the currently-displayed notification immediately
+- Fixed prompt briefly disappearing after submit when background messages arrived during processing
```

</details>

<details>
<summary>claude-code-on-the-web-ja.md</summary>

```diff
diff --git a/docs-ja/pages/claude-code-on-the-web-ja.md b/docs-ja/pages/claude-code-on-the-web-ja.md
index c2f7bbd..a75d9a7 100644
--- a/docs-ja/pages/claude-code-on-the-web-ja.md
+++ b/docs-ja/pages/claude-code-on-the-web-ja.md
@@ -36,4 +36,8 @@ Claude Code は [iOS](https://apps.apple.com/us/app/claude-by-anthropic/id647375
 ## はじめに
 
+ブラウザまたはターミナルからウェブ上の Claude Code をセットアップします。
+
+### ブラウザから
+
 1. [claude.ai/code](https://claude.ai/code) にアクセスします
 2. GitHub アカウントを接続します
@@ -43,4 +47,16 @@ Claude Code は [iOS](https://apps.apple.com/us/app/claude-by-anthropic/id647375
 6. diff ビューで変更を確認し、コメントで反復処理してから、プルリクエストを作成します
 
+### ターミナルから
+
+Claude Code 内で `/web-setup` を実行して、ローカル `gh` CLI 認証情報を使用して GitHub を接続します。このコマンドは `gh auth token` を Claude Code on the web に同期し、デフォルトクラウド環境を作成し、完了時にブラウザで claude.ai/code を開きます。
+
+このパスには `gh` CLI がインストールされ、`gh auth login` で認証されている必要があります。`gh` が利用できない場合、`/web-setup` は claude.ai/code を開いて、代わりにブラウザから GitHub を接続できます。
+
+`gh` 認証情報により Claude はクローンとプッシュにアクセスできるため、基本的なセッションでは GitHub アプリをスキップできます。後で [Auto-fix](#auto-fix-pull-requests) が必要な場合はアプリをインストールします。これはアプリを使用して PR webhook を受け取ります。
+
+<Note>
+  Team および Enterprise 管理者は [claude.ai/admin-settings/claude-code](https://claude.ai/admin-settings/claude-code) の Quick web setup トグルでターミナルセットアップを無効にできます。
+</Note>
+
 ## 仕組み
 
```

</details>

<details>
<summary>hooks-ja.md</summary>

```diff
diff --git a/docs-ja/pages/hooks-ja.md b/docs-ja/pages/hooks-ja.md
index 4788e56..59c84e0 100644
--- a/docs-ja/pages/hooks-ja.md
+++ b/docs-ja/pages/hooks-ja.md
@@ -98,5 +98,5 @@ fi
 
 <Frame>
-  <img src="https://mintcdn.com/claude-code/c5r9_6tjPMzFdDDT/images/hook-resolution.svg?fit=max&auto=format&n=c5r9_6tjPMzFdDDT&q=85&s=ad667ee6d86ab2276aa48a4e73e220df" alt="フック解決フロー: PreToolUse イベントが発火し、マッチャーが Bash マッチをチェックし、フック ハンドラーが実行され、結果が Claude Code に返される" width="780" height="290" data-path="images/hook-resolution.svg" />
+  <img src="https://mintcdn.com/claude-code/-tYw1BD_DEqfyyOZ/images/hook-resolution.svg?fit=max&auto=format&n=-tYw1BD_DEqfyyOZ&q=85&s=c73ebc1eeda2037570427d7af1e0a891" alt="フック解決フロー: PreToolUse イベントが発火し、マッチャーが Bash マッチをチェックし、フック ハンドラーが実行され、結果が Claude Code に返される" width="930" height="290" data-path="images/hook-resolution.svg" />
 </Frame>
 
```

</details>

<details>
<summary>voice-dictation-en.md</summary>

```diff
diff --git a/docs-ja/pages/voice-dictation-en.md b/docs-ja/pages/voice-dictation-en.md
index 4c253d2..37109c1 100644
--- a/docs-ja/pages/voice-dictation-en.md
+++ b/docs-ja/pages/voice-dictation-en.md
@@ -15,5 +15,5 @@ Hold a key and speak to dictate your prompts. Your speech is transcribed live in
 ## Requirements
 
-Voice dictation uses a streaming speech-to-text service that is only available when you authenticate with a Claude.ai account. It is not available when Claude Code is configured to use an Anthropic API key directly, Amazon Bedrock, Google Vertex AI, or Microsoft Foundry.
+Voice dictation streams your recorded audio to Anthropic's servers for transcription. Audio is not processed locally. The speech-to-text service is only available when you authenticate with a Claude.ai account, and is not available when Claude Code is configured to use an Anthropic API key directly, Amazon Bedrock, Google Vertex AI, or Microsoft Foundry. See [data usage](/en/data-usage) for how Anthropic handles your data.
 
 Voice dictation also needs local microphone access, so it does not work in remote environments such as [Claude Code on the web](/en/claude-code-on-the-web) or SSH sessions. In WSL, voice dictation requires WSLg for audio access, which is included with WSL2 on Windows 11. On Windows 10 or WSL1, run Claude Code in native Windows instead.
```

</details>

</details>


<details>
<summary>2026-03-30</summary>

**変更ファイル:**

```
 docs-ja/pages/changelog.md | 4 ++++
 1 file changed, 4 insertions(+)
```

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index e17ed40..700d711 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,8 @@
 # Changelog
 
+## 2.1.87
+
+- Fixed messages in Cowork Dispatch not getting delivered
+
 ## 2.1.86
 
```

</details>

</details>


<details>
<summary>2026-03-28</summary>

**変更ファイル:**

```
 docs-ja/pages/changelog.md | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)
```

**新規追加:**


<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index 447da9b..e17ed40 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,33 @@
 # Changelog
 
+## 2.1.86
+
+- Added `X-Claude-Code-Session-Id` header to API requests so proxies can aggregate requests by session without parsing the body
+- Added `.jj` and `.sl` to VCS directory exclusion lists so Grep and file autocomplete don't descend into Jujutsu or Sapling metadata
+- Fixed `--resume` failing with "tool_use ids were found without tool_result blocks" on sessions created before v2.1.85
+- Fixed Write/Edit/Read failing on files outside the project root (e.g., `~/.claude/CLAUDE.md`) when conditional skills or rules are configured
+- Fixed unnecessary config disk writes on every skill invocation that could cause performance issues and config corruption on Windows
+- Fixed potential out-of-memory crash when using `/feedback` on very long sessions with large transcript files
+- Fixed `--bare` mode dropping MCP tools in interactive sessions and silently discarding messages enqueued mid-turn
+- Fixed the `c` shortcut copying only ~20 characters of the OAuth login URL instead of the full URL
+- Fixed masked input (e.g., OAuth code paste) leaking the start of the token when wrapping across multiple lines on narrow terminals
+- Fixed official marketplace plugin scripts failing with "Permission denied" on macOS/Linux since v2.1.83
+- Fixed statusline showing another session's model when running multiple Claude Code instances and using `/model` in one of them
+- Fixed scroll not following new messages after wheel scroll or click-to-select at the bottom of a long conversation
+- Fixed `/plugin` uninstall dialog: pressing `n` now correctly uninstalls the plugin while preserving its data directory
+- Fixed a regression where pressing Enter after clicking could leave the transcript blank until the response arrived
+- Fixed `ultrathink` hint lingering after deleting the keyword
+- Fixed memory growth in long sessions from markdown/highlight render caches retaining full content strings
+- Reduced startup event-loop stalls when many claude.ai MCP connectors are configured (macOS keychain cache extended from 5s to 30s)
+- Reduced token overhead when mentioning files with `@` — raw string content no longer JSON-escaped
+- Improved prompt cache hit rate for Bedrock, Vertex, and Foundry users by removing dynamic content from tool descriptions
+- Memory filenames in the "Saved N memories" notice now highlight on hover and open on click
+- Skill descriptions in the `/skills` listing are now capped at 250 characters to reduce context usage
```

</details>

</details>


<details>
<summary>2026-03-27</summary>

**変更ファイル:**

```
 docs-ja/pages/changelog.md            | 76 +++++++++++++++++++++++++++++++++++
 docs-ja/pages/features-overview-ja.md |  2 +-
 docs-ja/pages/hooks-guide-ja.md       |  3 +-
 docs-ja/pages/hooks-ja.md             |  5 ++-
 docs-ja/pages/plugins-reference-ja.md |  3 +-
 5 files changed, 84 insertions(+), 5 deletions(-)
```

**新規追加:**


<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index cdf9941..447da9b 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,80 @@
 # Changelog
 
+## 2.1.85
+
+- Added `CLAUDE_CODE_MCP_SERVER_NAME` and `CLAUDE_CODE_MCP_SERVER_URL` environment variables to MCP `headersHelper` scripts, allowing one helper to serve multiple servers
+- Added conditional `if` field for hooks using permission rule syntax (e.g., `Bash(git *)`) to filter when they run, reducing process spawning overhead
+- Added timestamp markers in transcripts when scheduled tasks (`/loop`, `CronCreate`) fire
+- Added trailing space after `[Image #N]` placeholder when pasting images
+- Deep link queries (`claude-cli://open?q=…`) now support up to 5,000 characters, with a "scroll to review" warning for long pre-filled prompts
+- MCP OAuth now follows RFC 9728 Protected Resource Metadata discovery to find the authorization server
+- Plugins blocked by organization policy (`managed-settings.json`) can no longer be installed or enabled, and are hidden from marketplace views
+- PreToolUse hooks can now satisfy `AskUserQuestion` by returning `updatedInput` alongside `permissionDecision: "allow"`, enabling headless integrations that collect answers via their own UI
+- `tool_parameters` in OpenTelemetry tool_result events are now gated behind `OTEL_LOG_TOOL_DETAILS=1`
+- Fixed `/compact` failing with "context exceeded" when the conversation has grown too large for the compact request itself to fit
+- Fixed `/plugin enable` and `/plugin disable` failing when a plugin's install location differs from where it's declared in settings
+- Fixed `--worktree` exiting with an error in non-git repositories before the `WorktreeCreate` hook could run
+- Fixed `deniedMcpServers` setting not blocking claude.ai MCP servers
+- Fixed `switch_display` in the computer-use tool returning "not available in this session" on multi-monitor setups
+- Fixed crash when `OTEL_LOGS_EXPORTER`, `OTEL_METRICS_EXPORTER`, or `OTEL_TRACES_EXPORTER` is set to `none`
+- Fixed diff syntax highlighting not working in non-native builds
+- Fixed MCP step-up authorization failing when a refresh token exists — servers requesting elevated scopes via `403 insufficient_scope` now correctly trigger the re-authorization flow
+- Fixed memory leak in remote sessions when a streaming response is interrupted
+- Fixed persistent ECONNRESET errors during edge connection churn by using a fresh TCP connection on retry
+- Fixed prompts getting stuck in the queue after running certain slash commands, with up-arrow unable to retrieve them
+- Fixed Python Agent SDK: `type:'sdk'` MCP servers passed via `--mcp-config` are no longer dropped during startup
```

</details>

<details>
<summary>features-overview-ja.md</summary>

```diff
diff --git a/docs-ja/pages/features-overview-ja.md b/docs-ja/pages/features-overview-ja.md
index 929de83..22df0d5 100644
--- a/docs-ja/pages/features-overview-ja.md
+++ b/docs-ja/pages/features-overview-ja.md
@@ -189,5 +189,5 @@ Claude Code は、コードについて推論するモデルと、ファイル
 各機能はセッション内の異なるポイントでロードされます。以下のタブは、各機能がいつロードされるか、およびコンテキストに何が入るかを説明しています。
 
-<img src="https://mintcdn.com/claude-code/c5r9_6tjPMzFdDDT/images/context-loading.svg?fit=max&auto=format&n=c5r9_6tjPMzFdDDT&q=85&s=729b5b634ba831d1d64772c6c9485b30" alt="コンテキストロード：CLAUDE.md と MCP はセッション開始時にロードされ、すべてのリクエストに留まります。スキルは開始時に説明をロードし、呼び出し時に完全なコンテンツをロードします。Subagents は独立したコンテキストを取得します。Hooks は外部で実行されます。" width="720" height="410" data-path="images/context-loading.svg" />
+<img src="https://mintcdn.com/claude-code/6yTCYq1p37ZB8-CQ/images/context-loading.svg?fit=max&auto=format&n=6yTCYq1p37ZB8-CQ&q=85&s=5a58ce953a35a2412892015e2ad6cb67" alt="コンテキストロード：CLAUDE.md と MCP はセッション開始時にロードされ、すべてのリクエストに留まります。スキルは開始時に説明をロードし、呼び出し時に完全なコンテンツをロードします。Subagents は独立したコンテキストを取得します。Hooks は外部で実行されます。" width="720" height="410" data-path="images/context-loading.svg" />
 
 <Tabs>
```

</details>

<details>
<summary>hooks-guide-ja.md</summary>

```diff
diff --git a/docs-ja/pages/hooks-guide-ja.md b/docs-ja/pages/hooks-guide-ja.md
index 6953b0b..b7a0444 100644
--- a/docs-ja/pages/hooks-guide-ja.md
+++ b/docs-ja/pages/hooks-guide-ja.md
@@ -390,8 +390,9 @@ Hook イベントは Claude Code のライフサイクルの特定のポイン
 | `SubagentStart`      | When a subagent is spawned                                                                                                                             |
 | `SubagentStop`       | When a subagent finishes                                                                                                                               |
+| `TaskCreated`        | When a task is being created via `TaskCreate`                                                                                                          |
+| `TaskCompleted`      | When a task is being marked as completed                                                                                                               |
 | `Stop`               | When Claude finishes responding                                                                                                                        |
 | `StopFailure`        | When the turn ends due to an API error. Output and exit code are ignored                                                                               |
 | `TeammateIdle`       | When an [agent team](/en/agent-teams) teammate is about to go idle                                                                                     |
-| `TaskCompleted`      | When a task is being marked as completed                                                                                                               |
 | `InstructionsLoaded` | When a CLAUDE.md or `.claude/rules/*.md` file is loaded into context. Fires at session start and when files are lazily loaded during a session         |
 | `ConfigChange`       | When a configuration file changes during a session                                                                                                     |
```

</details>

<details>
<summary>hooks-ja.md</summary>

```diff
diff --git a/docs-ja/pages/hooks-ja.md b/docs-ja/pages/hooks-ja.md
index 2e96b22..4788e56 100644
--- a/docs-ja/pages/hooks-ja.md
+++ b/docs-ja/pages/hooks-ja.md
@@ -19,5 +19,5 @@
 <div style={{maxWidth: "500px", margin: "0 auto"}}>
   <Frame>
-    <img src="https://mintcdn.com/claude-code/JCMefyZyaJwkJgv-/images/hooks-lifecycle.svg?fit=max&auto=format&n=JCMefyZyaJwkJgv-&q=85&s=f004f3fc7324fa2a4630e8d6559cf6dd" alt="SessionStart から agentic ループを経由して SessionEnd までのフックのシーケンスを示すフック ライフサイクル図。agentic ループ内に PreToolUse、PermissionRequest、PostToolUse、SubagentStart/Stop、TaskCompleted が含まれ、Elicitation と ElicitationResult が MCP ツール実行内にネストされ、WorktreeCreate、WorktreeRemove、Notification、ConfigChange、InstructionsLoaded がスタンドアロン非同期イベント" width="520" height="1100" data-path="images/hooks-lifecycle.svg" />
+    <img src="https://mintcdn.com/claude-code/1wr0LPds6lVWZkQB/images/hooks-lifecycle.svg?fit=max&auto=format&n=1wr0LPds6lVWZkQB&q=85&s=53a826e7bb64c6bff5f867506c0530ad" alt="SessionStart から agentic ループを経由して SessionEnd までのフックのシーケンスを示すフック ライフサイクル図。agentic ループ内に PreToolUse、PermissionRequest、PostToolUse、SubagentStart/Stop、TaskCompleted が含まれ、Elicitation と ElicitationResult が MCP ツール実行内にネストされ、WorktreeCreate、WorktreeRemove、Notification、ConfigChange、InstructionsLoaded がスタンドアロン非同期イベント" width="520" height="1155" data-path="images/hooks-lifecycle.svg" />
   </Frame>
 </div>
@@ -36,8 +36,9 @@
 | `SubagentStart`      | When a subagent is spawned                                                                                                                             |
 | `SubagentStop`       | When a subagent finishes                                                                                                                               |
+| `TaskCreated`        | When a task is being created via `TaskCreate`                                                                                                          |
+| `TaskCompleted`      | When a task is being marked as completed                                                                                                               |
 | `Stop`               | When Claude finishes responding                                                                                                                        |
 | `StopFailure`        | When the turn ends due to an API error. Output and exit code are ignored                                                                               |
 | `TeammateIdle`       | When an [agent team](/en/agent-teams) teammate is about to go idle                                                                                     |
-| `TaskCompleted`      | When a task is being marked as completed                                                                                                               |
 | `InstructionsLoaded` | When a CLAUDE.md or `.claude/rules/*.md` file is loaded into context. Fires at session start and when files are lazily loaded during a session         |
 | `ConfigChange`       | When a configuration file changes during a session                                                                                                     |
```

</details>

<details>
<summary>plugins-reference-ja.md</summary>

```diff
diff --git a/docs-ja/pages/plugins-reference-ja.md b/docs-ja/pages/plugins-reference-ja.md
index 5781b4b..0f5a4d6 100644
--- a/docs-ja/pages/plugins-reference-ja.md
+++ b/docs-ja/pages/plugins-reference-ja.md
@@ -120,8 +120,9 @@ disallowedTools: Write, Edit
 | `SubagentStart`      | When a subagent is spawned                                                                                                                             |
 | `SubagentStop`       | When a subagent finishes                                                                                                                               |
+| `TaskCreated`        | When a task is being created via `TaskCreate`                                                                                                          |
+| `TaskCompleted`      | When a task is being marked as completed                                                                                                               |
 | `Stop`               | When Claude finishes responding                                                                                                                        |
 | `StopFailure`        | When the turn ends due to an API error. Output and exit code are ignored                                                                               |
 | `TeammateIdle`       | When an [agent team](/en/agent-teams) teammate is about to go idle                                                                                     |
-| `TaskCompleted`      | When a task is being marked as completed                                                                                                               |
 | `InstructionsLoaded` | When a CLAUDE.md or `.claude/rules/*.md` file is loaded into context. Fires at session start and when files are lazily loaded during a session         |
 | `ConfigChange`       | When a configuration file changes during a session                                                                                                     |
```

</details>

</details>


<details>
<summary>2026-03-26</summary>

**変更ファイル:**

```
 docs-ja/pages/changelog.md             |  79 ++++
 docs-ja/pages/channels-ja.md           |  33 +-
 docs-ja/pages/channels-reference-en.md | 749 ---------------------------------
 docs-ja/pages/cli-reference-ja.md      |  35 +-
 docs-ja/pages/commands-ja.md           |  14 +-
 docs-ja/pages/desktop-ja.md            |   6 +-
 docs-ja/pages/env-vars-ja.md           |  31 +-
 docs-ja/pages/hooks-guide-ja.md        | 125 ++++--
 docs-ja/pages/hooks-ja.md              | 195 ++++++---
 docs-ja/pages/interactive-mode-ja.md   |  20 +-
 docs-ja/pages/keybindings-ja.md        |  41 +-
 docs-ja/pages/mcp-ja.md                |  67 ++-
 docs-ja/pages/memory-ja.md             |  32 +-
 docs-ja/pages/model-config-ja.md       |  27 +-
 docs-ja/pages/monitoring-usage-ja.md   |  43 +-
 docs-ja/pages/plugins-reference-ja.md  | 178 ++++++--
 docs-ja/pages/quickstart-ja.md         | 608 ++++++++++++++++++++++++++
 docs-ja/pages/sandboxing-ja.md         |   2 +
 docs-ja/pages/settings-ja.md           |  12 +-
 docs-ja/pages/skills-ja.md             |  33 +-
 docs-ja/pages/sub-agents-ja.md         |  28 +-
 docs-ja/pages/tools-reference-ja.md    |   2 +-
 docs-ja/pages/vs-code-ja.md            |  25 ++
 23 files changed, 1388 insertions(+), 997 deletions(-)
```

**新規追加:**


**削除:**


<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index 4b18ccc..cdf9941 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,83 @@
 # Changelog
 
+## 2.1.83
+
+- Added `managed-settings.d/` drop-in directory alongside `managed-settings.json`, letting separate teams deploy independent policy fragments that merge alphabetically
+- Added `CwdChanged` and `FileChanged` hook events for reactive environment management (e.g., direnv)
+- Added `sandbox.failIfUnavailable` setting to exit with an error when sandbox is enabled but cannot start, instead of running unsandboxed
+- Added `disableDeepLinkRegistration` setting to prevent `claude-cli://` protocol handler registration
+- Added `CLAUDE_CODE_SUBPROCESS_ENV_SCRUB=1` to strip Anthropic and cloud provider credentials from subprocess environments (Bash tool, hooks, MCP stdio servers)
+- Added transcript search — press `/` in transcript mode (`Ctrl+O`) to search, `n`/`N` to step through matches
+- Added `Ctrl+X Ctrl+E` as an alias for opening the external editor (readline-native binding; `Ctrl+G` still works)
+- Pasted images now insert an `[Image #N]` chip at the cursor so you can reference them positionally in your prompt
+- Agents can now declare `initialPrompt` in frontmatter to auto-submit a first turn
+- `chat:killAgents` and `chat:fastMode` are now rebindable via `~/.claude/keybindings.json`
+- Fixed mouse tracking escape sequences leaking to shell prompt after exit
+- Fixed Claude Code hanging on exit on macOS
+- Fixed screen flashing blank after being idle for a few seconds
+- Fixed a hang when diffing very large files with few common lines — diffs now time out after 5 seconds and fall back gracefully
+- Fixed a 1–8 second UI freeze on startup when voice input was enabled, caused by eagerly loading the native audio module
+- Fixed a startup regression where Claude Code would wait ~3s for claude.ai MCP config fetch before proceeding
+- Fixed `--mcp-config` CLI flag bypassing `allowedMcpServers`/`deniedMcpServers` managed policy enforcement
+- Fixed claude.ai MCP connectors (Slack, Gmail, etc.) not being available in single-turn `--print` mode
+- Fixed `caffeinate` process not properly terminating when Claude Code exits, preventing Mac from sleeping
+- Fixed bash mode not activating when tab-accepting `!`-prefixed command suggestions
+- Fixed stale slash command selection showing wrong highlighted command after navigating suggestions
```

</details>

<details>
<summary>channels-ja.md</summary>

```diff
diff --git a/docs-ja/pages/channels-ja.md b/docs-ja/pages/channels-ja.md
index 8bf5ac7..c9f89ed 100644
--- a/docs-ja/pages/channels-ja.md
+++ b/docs-ja/pages/channels-ja.md
@@ -289,10 +289,12 @@ iMessage は異なります。自分自身にテキストを送信するとゲ
 ## Enterprise コントロール
 
-チャネルは[管理設定](/ja/settings)の `channelsEnabled` 設定で制御されます。
+Team および Enterprise プランでは、チャネルはデフォルトでオフです。管理者は、ユーザーがオーバーライドできない 2 つの[管理設定](/ja/settings)を通じて可用性を制御します。
 
-| プランタイプ            | デフォルト動作                                     |
-| :---------------- | :------------------------------------------ |
-| Pro / Max、組織なし    | チャネルが利用可能。ユーザーは `--channels` でセッションごとにオプトイン |
-| Team / Enterprise | 管理者が明示的に有効にするまでチャネルは無効                      |
+| 設定                      | 目的                                                                                                                                                                      | 設定されていない場合                |
+| :---------------------- | :---------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :------------------------ |
+| `channelsEnabled`       | マスタースイッチ。チャネルがメッセージを配信するには `true` である必要があります。[claude.ai Admin console](https://claude.ai/admin-settings/claude-code) トグルまたは管理設定で直接設定します。オフの場合、開発フラグを含むすべてのチャネルをブロックします。 | チャネルがブロックされます             |
+| `allowedChannelPlugins` | チャネルが有効になったら、どのプラグインが登録できるか。設定されている場合、Anthropic が管理するリストを置き換えます。`channelsEnabled` が `true` の場合のみ適用されます。                                                                 | Anthropic デフォルトリストが適用されます |
+
+組織のない Pro および Max ユーザーはこれらのチェックを完全にスキップします。チャネルが利用可能で、ユーザーは `--channels` でセッションごとにオプトインします。
 
 ### 組織のチャネルを有効にする
@@ -302,9 +304,28 @@ iMessage は異なります。自分自身にテキストを送信するとゲ
 有効にすると、組織内のユーザーは `--channels` を使用して個別のセッションにチャネルサーバーをオプトインできます。設定が無効または未設定の場合、MCP サーバーは接続され、そのツールは機能しますが、チャネルメッセージは到着しません。スタートアップ警告は、ユーザーに管理者が設定を有効にするよう指示します。
 
+### チャネルプラグインが実行できるものを制限する
+
+デフォルトでは、Anthropic が管理する許可リスト上のプラグインはチャネルとして登録できます。Team および Enterprise プランの管理者は、管理設定で `allowedChannelPlugins` を設定することで、その許可リストを独自のものに置き換えることができます。これを使用して、許可されている公式プラグインを制限したり、独自の内部マーケットプレイスからチャネルを承認したり、その両方を行ったりします。各エントリは、プラグインとそれが由来するマーケットプレイスに名前を付けます。
+
+```json  theme={null}
```

</details>

<details>
<summary>cli-reference-ja.md</summary>

```diff
diff --git a/docs-ja/pages/cli-reference-ja.md b/docs-ja/pages/cli-reference-ja.md
index 1be5d21..a13d6f6 100644
--- a/docs-ja/pages/cli-reference-ja.md
+++ b/docs-ja/pages/cli-reference-ja.md
@@ -11,21 +11,22 @@
 これらのコマンドを使用して、セッションを開始し、コンテンツをパイプし、会話を再開し、更新を管理できます。
 
-| コマンド                            | 説明                                                                                                                                                                                      | 例                                            |
-| :------------------------------ | :-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :------------------------------------------- |
-| `claude`                        | インタラクティブセッションを開始                                                                                                                                                                        | `claude`                                     |
-| `claude "query"`                | 初期プロンプト付きでインタラクティブセッションを開始                                                                                                                                                              | `claude "explain this project"`              |
-| `claude -p "query"`             | SDK 経由でクエリを実行してから終了                                                                                                                                                                     | `claude -p "explain this function"`          |
-| `cat file \| claude -p "query"` | パイプされたコンテンツを処理                                                                                                                                                                          | `cat logs.txt \| claude -p "explain"`        |
-| `claude -c`                     | 現在のディレクトリで最新の会話を続行                                                                                                                                                                      | `claude -c`                                  |
-| `claude -c -p "query"`          | SDK 経由で続行                                                                                                                                                                               | `claude -c -p "Check for type errors"`       |
-| `claude -r "<session>" "query"` | セッション ID または名前でセッションを再開                                                                                                                                                                 | `claude -r "auth-refactor" "Finish this PR"` |
-| `claude update`                 | 最新バージョンに更新                                                                                                                                                                              | `claude update`                              |
-| `claude auth login`             | Anthropic アカウントにサインインします。`--email` を使用してメールアドレスを事前入力し、`--sso` を使用して SSO 認証を強制し、`--console` を使用して Claude サブスクリプションの代わりに Anthropic Console で API 使用料金をサインインできます                           | `claude auth login --console`                |
-| `claude auth logout`            | Anthropic アカウントからログアウト                                                                                                                                                                  | `claude auth logout`                         |
-| `claude auth status`            | 認証ステータスを JSON として表示します。`--text` を使用して人間が読める形式で表示できます。ログイン済みの場合はコード 0 で終了し、ログインしていない場合は 1 で終了します                                                                                         | `claude auth status`                         |
-| `claude agents`                 | すべての設定済み [subagents](/ja/sub-agents) をソース別にグループ化して一覧表示                                                                                                                                  | `claude agents`                              |
-| `claude auto-mode defaults`     | 組み込み [auto mode](/ja/permission-modes#eliminate-prompts-with-auto-mode) 分類器ルールを JSON として出力します。`claude auto-mode config` を使用して、設定が適用された有効な設定を確認してください                                    | `claude auto-mode defaults > rules.json`     |
-| `claude mcp`                    | Model Context Protocol（MCP）サーバーを設定                                                                                                                                                      | [Claude Code MCP ドキュメント](/ja/mcp) を参照してください。 |
-| `claude remote-control`         | [Remote Control](/ja/remote-control) サーバーを開始して、Claude.ai または Claude アプリから Claude Code を制御します。サーバーモード（ローカルインタラクティブセッションなし）で実行されます。[サーバーモードフラグ](/ja/remote-control#server-mode) を参照してください | `claude remote-control --name "My Project"`  |
+| コマンド                            | 説明                                                                                                                                                                                      | 例                                                           |
+| :------------------------------ | :-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :---------------------------------------------------------- |
+| `claude`                        | インタラクティブセッションを開始                                                                                                                                                                        | `claude`                                                    |
+| `claude "query"`                | 初期プロンプト付きでインタラクティブセッションを開始                                                                                                                                                              | `claude "explain this project"`                             |
+| `claude -p "query"`             | SDK 経由でクエリを実行してから終了                                                                                                                                                                     | `claude -p "explain this function"`                         |
+| `cat file \| claude -p "query"` | パイプされたコンテンツを処理                                                                                                                                                                          | `cat logs.txt \| claude -p "explain"`                       |
```

</details>

<details>
<summary>commands-ja.md</summary>

```diff
diff --git a/docs-ja/pages/commands-ja.md b/docs-ja/pages/commands-ja.md
index ddb6f88..1ae56e8 100644
--- a/docs-ja/pages/commands-ja.md
+++ b/docs-ja/pages/commands-ja.md
@@ -9,5 +9,5 @@
 Claude Code で `/` と入力すると、利用可能なすべてのコマンドが表示されます。または `/` の後に任意の文字を入力してフィルタリングできます。すべてのコマンドがすべてのユーザーに表示されるわけではありません。プラットフォーム、プラン、または環境によって異なります。たとえば、`/desktop` は macOS と Windows にのみ表示され、`/upgrade` と `/privacy-settings` は Pro プランと Max プランでのみ利用可能で、`/terminal-setup` はターミナルがネイティブにキーバインディングをサポートしている場合は非表示になります。
 
-Claude Code には、`/` と入力したときに組み込みコマンドと一緒に表示される `/simplify`、`/batch`、`/debug` などの[バンドルされたスキル](/ja/skills#bundled-skills)も含まれています。独自のコマンドを作成するには、[スキル](/ja/skills)を参照してください。
+Claude Code には、`/` と入力したときに組み込みコマンドと一緒に表示される `/simplify`、`/batch`、`/debug`、`/loop` などの[バンドルされたスキル](/ja/skills#bundled-skills)も含まれています。独自のコマンドを作成するには、[スキル](/ja/skills)を参照してください。
 
 以下の表では、`<arg>` は必須引数を示し、`[arg]` はオプション引数を示します。
@@ -24,5 +24,5 @@ Claude Code には、`/` と入力したときに組み込みコマンドと一
 | `/config`                                | [設定](/ja/settings)インターフェースを開いて、テーマ、モデル、[出力スタイル](/ja/output-styles)、およびその他の設定を調整。エイリアス: `/settings`                                                                                         |
 | `/context`                               | 現在のコンテキスト使用状況をカラーグリッドとして視覚化。コンテキストが多いツール、メモリ肥大化、容量警告の最適化提案を表示                                                                                                                              |
-| `/copy`                                  | 最後のアシスタント応答をクリップボードにコピー。コードブロックが存在する場合、個別ブロックまたは完全な応答を選択するインタラクティブピッカーを表示                                                                                                                  |
+| `/copy [N]`                              | 最後のアシスタント応答をクリップボードにコピー。数字 `N` を渡して N 番目に新しい応答をコピー: `/copy 2` は 2 番目に新しい応答をコピー。コードブロックが存在する場合、個別ブロックまたは完全な応答を選択するインタラクティブピッカーを表示。ピッカーで `w` を押して、クリップボードの代わりにファイルに選択内容を書き込み。SSH 経由で便利       |
 | `/cost`                                  | トークン使用統計を表示。サブスクリプション固有の詳細については、[コスト追跡ガイド](/ja/costs#using-the-cost-command)を参照                                                                                                            |
 | `/desktop`                               | 現在のセッションを Claude Code デスクトップアプリで続行。macOS と Windows のみ。エイリアス: `/app`                                                                                                                        |
@@ -35,9 +35,9 @@ Claude Code には、`/` と入力したときに組み込みコマンドと一
 | `/fast [on\|off]`                        | [高速モード](/ja/fast-mode)のオン/オフを切り替え                                                                                                                                                          |
 | `/feedback [report]`                     | Claude Code に関するフィードバックを送信。エイリアス: `/bug`                                                                                                                                                   |
-| `/fork [name]`                           | この時点で現在の会話のフォークを作成                                                                                                                                                                         |
+| `/branch [name]`                         | この時点で現在の会話のブランチを作成。エイリアス: `/fork`                                                                                                                                                          |
 | `/help`                                  | ヘルプと利用可能なコマンドを表示                                                                                                                                                                           |
 | `/hooks`                                 | ツールイベント用の[フック](/ja/hooks)設定を表示                                                                                                                                                             |
 | `/ide`                                   | IDE 統合を管理し、ステータスを表示                                                                                                                                                                        |
-| `/init`                                  | `CLAUDE.md` ガイドでプロジェクトを初期化                                                                                                                                                                 |
+| `/init`                                  | `CLAUDE.md` ガイドでプロジェクトを初期化。スキル、フック、個人メモリファイルをウォークスルーするインタラクティブフローについては、`CLAUDE_CODE_NEW_INIT=true` を設定                                                                                     |
 | `/insights`                              | Claude Code セッションを分析するレポートを生成。プロジェクト領域、相互作用パターン、および摩擦点を含む                                                                                                                                  |
 | `/install-github-app`                    | リポジトリ用の [Claude GitHub Actions](/ja/github-actions) アプリをセットアップ。リポジトリを選択して統合を構成するプロセスをガイド                                                                                                   |
```

</details>

<details>
<summary>desktop-ja.md</summary>

```diff
diff --git a/docs-ja/pages/desktop-ja.md b/docs-ja/pages/desktop-ja.md
index 489b955..4ba625d 100644
--- a/docs-ja/pages/desktop-ja.md
+++ b/docs-ja/pages/desktop-ja.md
@@ -52,5 +52,5 @@ Claude に実行させたいことを入力して**Enter**キーを押して送
 プロンプトボックスは外部コンテキストを取り込む 2 つの方法をサポートしています：
 
-* **@mention ファイル**：`@`の後にファイル名を入力して、ファイルを会話コンテキストに追加します。Claude はそのファイルを読み取り、参照できます。
+* **@mention ファイル**：`@`の後にファイル名を入力して、ファイルを会話コンテキストに追加します。Claude はそのファイルを読み取り、参照できます。@mention はリモートセッションでは利用できません。
 * **ファイルを添付**：添付ボタンを使用するか、ファイルをプロンプトに直接ドラッグアンドドロップして、画像、PDF、およびその他のファイルをプロンプトに添付します。これはバグのスクリーンショット、デザインモックアップ、または参照ドキュメントを共有するのに便利です。
 
@@ -547,5 +547,5 @@ Teams または Enterprise プランの組織は、管理コンソールコン
 ### デバイス管理ポリシー
 
-IT チームは、macOS の MDM またはWindows のグループポリシーを通じてデスクトップアプリを管理できます。利用可能なポリシーには、Claude Code 機能の有効化または無効化、自動更新の制御、およびカスタムデプロイメント URL の設定が含まれます。
+IT チームは、macOS の MDM または Windows のグループポリシーを通じてデスクトップアプリを管理できます。利用可能なポリシーには、Claude Code 機能の有効化または無効化、自動更新の制御、およびカスタムデプロイメント URL の設定が含まれます。
 
 * **macOS**：Jamf または Kandji などのツールを使用して`com.anthropic.Claude`プリファレンスドメインを通じて設定します
@@ -623,5 +623,5 @@ Desktop と CLI は同じ設定ファイルを読み取るため、セットア
 | [MCP サーバー](/ja/mcp)                           | 設定ファイルで設定                                                | ローカルおよび SSH セッションの Connectors UI、または設定ファイル                                             |
 | [プラグイン](/ja/plugins)                          | `/plugin`コマンド                                            | プラグインマネージャー UI                                                                         |
-| @mention ファイル                                 | テキストベース                                                  | オートコンプリート付き                                                                            |
+| @mention ファイル                                 | テキストベース                                                  | オートコンプリート付き；ローカルおよび SSH セッションのみ                                                        |
 | ファイル添付                                        | 利用できません                                                  | 画像、PDF                                                                                 |
 | セッション分離                                       | [`--worktree`](/ja/cli-reference)フラグ                     | 自動 worktrees                                                                           |
```

</details>

<details>
<summary>env-vars-ja.md</summary>

```diff
diff --git a/docs-ja/pages/env-vars-ja.md b/docs-ja/pages/env-vars-ja.md
index b0c912a..336b660 100644
--- a/docs-ja/pages/env-vars-ja.md
+++ b/docs-ja/pages/env-vars-ja.md
@@ -11,7 +11,11 @@ Claude Code は、その動作を制御するために以下の環境変数を
 | 変数                                             | 目的                                                                                                                                                                                                                                                                                                                                                                               |
 | :--------------------------------------------- | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
-| `ANTHROPIC_API_KEY`                            | API キーは `X-Api-Key` ヘッダーとして送信されます。通常は Claude SDK 用です（対話的な使用の場合は、`/login` を実行してください）                                                                                                                                                                                                                                                                                              |
+| `ANTHROPIC_API_KEY`                            | `X-Api-Key` ヘッダーとして送信される API キー。設定されている場合、ログインしていても Claude Pro、Max、Team、または Enterprise サブスクリプションの代わりにこのキーが使用されます。非対話モード（`-p`）では、キーが存在する場合は常に使用されます。対話モードでは、キーがサブスクリプションをオーバーライドする前に一度承認するよう求められます。代わりにサブスクリプションを使用するには、`unset ANTHROPIC_API_KEY` を実行してください                                                                                                                       |
 | `ANTHROPIC_AUTH_TOKEN`                         | `Authorization` ヘッダーのカスタム値（ここで設定した値には `Bearer ` が接頭辞として付けられます）                                                                                                                                                                                                                                                                                                                   |
+| `ANTHROPIC_BASE_URL`                           | API エンドポイントをオーバーライドして、プロキシまたはゲートウェイを通じてリクエストをルーティングします。ファーストパーティ以外のホストに設定されている場合、[MCP ツール検索](/ja/mcp#scale-with-mcp-tool-search) はデフォルトで無効になります。プロキシが `tool_reference` ブロックを転送する場合は、`ENABLE_TOOL_SEARCH=true` を設定してください                                                                                                                                                          |
 | `ANTHROPIC_CUSTOM_HEADERS`                     | リクエストに追加するカスタムヘッダー（`Name: Value` 形式、複数のヘッダーの場合は改行で区切られます）                                                                                                                                                                                                                                                                                                                        |
+| `ANTHROPIC_CUSTOM_MODEL_OPTION`                | `/model` ピッカーにカスタムエントリとして追加するモデル ID。組み込みエイリアスを置き換えずに、非標準またはゲートウェイ固有のモデルを選択可能にするために使用します。[モデル設定](/ja/model-config#add-a-custom-model-option) を参照してください                                                                                                                                                                                                                            |
+| `ANTHROPIC_CUSTOM_MODEL_OPTION_DESCRIPTION`    | `/model` ピッカーのカスタムモデルエントリの表示説明。設定されていない場合、デフォルトは `Custom model (<model-id>)` です                                                                                                                                                                                                                                                                                                  |
+| `ANTHROPIC_CUSTOM_MODEL_OPTION_NAME`           | `/model` ピッカーのカスタムモデルエントリの表示名。設定されていない場合、デフォルトはモデル ID です                                                                                                                                                                                                                                                                                                                         |
 | `ANTHROPIC_DEFAULT_HAIKU_MODEL`                | [モデル設定](/ja/model-config#environment-variables) を参照してください                                                                                                                                                                                                                                                                                                                        |
 | `ANTHROPIC_DEFAULT_OPUS_MODEL`                 | [モデル設定](/ja/model-config#environment-variables) を参照してください                                                                                                                                                                                                                                                                                                                        |
@@ -27,4 +31,5 @@ Claude Code は、その動作を制御するために以下の環境変数を
 | `BASH_MAX_OUTPUT_LENGTH`                       | bash 出力が中央で切り詰められる前の最大文字数                                                                                                                                                                                                                                                                                                                                                        |
 | `BASH_MAX_TIMEOUT_MS`                          | 長時間実行される bash コマンドに対してモデルが設定できる最大タイムアウト                                                                                                                                                                                                                                                                                                                                          |
+| `CLAUDECODE`                                   | Claude Code がスポーンするシェル環境（Bash ツール、tmux セッション）で `1` に設定されます。[フック](/ja/hooks) または [ステータスライン](/ja/statusline) コマンドでは設定されません。スクリプトが Claude Code によってスポーンされたシェル内で実行されているかどうかを検出するために使用します                                                                                                                                                                                             |
 | `CLAUDE_AUTOCOMPACT_PCT_OVERRIDE`              | オートコンパクションがトリガーされるコンテキスト容量のパーセンテージ（1～100）を設定します。デフォルトでは、オートコンパクションは約 95% の容量でトリガーされます。`50` などの低い値を使用して、より早くコンパクトします。デフォルトの閾値より高い値は効果がありません。メインの会話と subagent の両方に適用されます。このパーセンテージは、[ステータスライン](/ja/statusline) で利用可能な `context_window.used_percentage` フィールドと一致します                                                                                                                 |
 | `CLAUDE_BASH_MAINTAIN_PROJECT_WORKING_DIR`     | 各 Bash コマンドの後に元の作業ディレクトリに戻ります                                                                                                                                                                                                                                                                                                                                                    |
@@ -39,11 +44,12 @@ Claude Code は、その動作を制御するために以下の環境変数を
 | `CLAUDE_CODE_DISABLE_ADAPTIVE_THINKING`        | Opus 4.6 と Sonnet 4.6 の [適応的推論](/ja/model-config#adjust-effort-level) を無効にするには `1` に設定します。無効にすると、これらのモデルは `MAX_THINKING_TOKENS` で制御される固定思考予算にフォールバックします                                                                                                                                                                                                                          |
 | `CLAUDE_CODE_DISABLE_AUTO_MEMORY`              | [自動メモリ](/ja/memory#auto-memory) を無効にするには `1` に設定します。段階的なロールアウト中に自動メモリを強制的にオンにするには `0` に設定します。無効にすると、Claude は自動メモリファイルを作成または読み込みません                                                                                                                                                                                                                                               |
-| `CLAUDE_CODE_DISABLE_GIT_INSTRUCTIONS`         | Claude のシステムプロンプトから組み込みのコミットと PR ワークフロー命令を削除するには `1` に設定します。独自の git ワークフロースキルを使用する場合に役立ちます。設定されている場合、[`includeGitInstructions`](/ja/settings#available-settings) 設定よりも優先されます                                                                                                                                                                                                     |
+| `CLAUDE_CODE_DISABLE_GIT_INSTRUCTIONS`         | Claude のシステムプロンプトから組み込みのコミットと PR ワークフロー命令と git ステータススナップショットを削除するには `1` に設定します。独自の git ワークフロースキルを使用する場合に役立ちます。設定されている場合、[`includeGitInstructions`](/ja/settings#available-settings) 設定よりも優先されます                                                                                                                                                                                  |
 | `CLAUDE_CODE_DISABLE_BACKGROUND_TASKS`         | Bash と subagent ツールの `run_in_background` パラメータ、自動バックグラウンド化、Ctrl+B ショートカットを含む、すべてのバックグラウンドタスク機能を無効にするには `1` に設定します                                                                                                                                                                                                                                                                |
 | `CLAUDE_CODE_DISABLE_CRON`                     | [スケジュール済みタスク](/ja/scheduled-tasks) を無効にするには `1` に設定します。`/loop` スキルと cron ツールが利用できなくなり、既にスケジュール済みのタスクはすべて実行を停止します。これには既にセッション中に実行中のタスクも含まれます                                                                                                                                                                                                                                      |
```

</details>

*...以降省略*

</details>


<details>
<summary>2026-03-25</summary>

**変更ファイル:**

```
 docs-ja/pages/best-practices-ja.md          |  25 ++-
 docs-ja/pages/channels-en.md                | 286 ----------------------------
 docs-ja/pages/channels-reference-en.md      |   6 +-
 docs-ja/pages/cli-reference-ja.md           | 145 +++++++-------
 docs-ja/pages/desktop-ja.md                 | 152 ++++++++++++---
 docs-ja/pages/hooks-ja.md                   | 154 +++++++++------
 docs-ja/pages/how-claude-code-works-ja.md   |   7 +-
 docs-ja/pages/interactive-mode-ja.md        |  43 +++--
 docs-ja/pages/llm-gateway-ja.md             |  24 ++-
 docs-ja/pages/overview-ja.md                |  35 ++--
 docs-ja/pages/permissions-ja.md             | 153 +++++++++++++--
 docs-ja/pages/platforms-en.md               |  78 --------
 docs-ja/pages/plugin-marketplaces-ja.md     |  64 +++++--
 docs-ja/pages/remote-control-ja.md          |  60 +++++-
 docs-ja/pages/sandboxing-ja.md              |  43 ++++-
 docs-ja/pages/scheduled-tasks-ja.md         |  36 +++-
 docs-ja/pages/server-managed-settings-ja.md |  37 +++-
 docs-ja/pages/settings-ja.md                | 220 ++++++++++++---------
 docs-ja/pages/sub-agents-ja.md              |  86 +++++++--
 docs-ja/pages/vs-code-ja.md                 |  55 ++++--
 docs-ja/pages/web-scheduled-tasks-en.md     | 154 ---------------
 21 files changed, 962 insertions(+), 901 deletions(-)
```

**新規追加:**


**削除:**


<details>
<summary>best-practices-ja.md</summary>

```diff
diff --git a/docs-ja/pages/best-practices-ja.md b/docs-ja/pages/best-practices-ja.md
index e0bbedd..7d20cff 100644
--- a/docs-ja/pages/best-practices-ja.md
+++ b/docs-ja/pages/best-practices-ja.md
@@ -201,19 +201,14 @@ CLAUDE.md ファイルはいくつかの場所に配置できます。
 
 <Tip>
-  `/permissions` を使用して安全なコマンドをホワイトリストに登録するか、`/sandbox` を使用して OS レベルの分離を行います。これにより、制御を保ちながら中断を減らします。
+  [auto mode](/ja/permission-modes#eliminate-prompts-with-auto-mode) を使用して分類器に承認を処理させるか、`/permissions` を使用して特定のコマンドをホワイトリストに登録するか、`/sandbox` を使用して OS レベルの分離を行います。各方法は中断を減らしながら制御を保ちます。
 </Tip>
 
-デフォルトでは、Claude Code はシステムを変更する可能性のあるアクション（ファイル書き込み、Bash コマンド、MCP ツールなど）の許可をリクエストします。これは安全ですが、面倒です。10 回目の承認後、あなたは本当にレビューしていません。クリックしているだけです。これらの中断を減らすには 2 つの方法があります。
+デフォルトでは、Claude Code はシステムを変更する可能性のあるアクション（ファイル書き込み、Bash コマンド、MCP ツールなど）の許可をリクエストします。これは安全ですが、面倒です。10 回目の承認後、あなたは本当にレビューしていません。クリックしているだけです。これらの中断を減らすには 3 つの方法があります。
 
+* **Auto mode**：別の分類器モデルがコマンドをレビューし、スコープエスカレーション、未知のインフラストラクチャ、または敵対的なコンテンツ駆動のアクションのみをブロックします。タスクの一般的な方向を信頼しているが、すべてのステップをクリックしたくない場合に最適です
 * **パーミッションホワイトリスト**：安全であることがわかっているツール（`npm run lint` や `git commit` など）を許可します
 * **サンドボックス**：OS レベルの分離を有効にして、ファイルシステムとネットワークアクセスを制限し、Claude が定義された境界内でより自由に動作できるようにします
 
-または、`--dangerously-skip-permissions` を使用して、lint エラーの修正やボイラープレートの生成などの含まれたワークフローのすべてのパーミッションチェックをバイパスします。
-
-<Warning>
-  Claude に任意のコマンドを実行させると、プロンプトインジェクションを介したデータ損失、システム破損、またはデータ流出が発生する可能性があります。`--dangerously-skip-permissions` はインターネットアクセスのないサンドボックスでのみ使用します。
-</Warning>
-
-[パーミッションの設定](/ja/permissions)と[サンドボックスの有効化](/ja/sandboxing)の詳細をお読みください。
+[パーミッションモード](/ja/permission-modes)、[パーミッションルール](/ja/permissions)、[サンドボックス](/ja/sandboxing)の詳細をお読みください。
 
 ### CLI ツールを使用する
@@ -243,5 +238,5 @@ Claude は、それが既に知らない CLI ツールを学ぶのにも効果
 [フック](/ja/hooks-guide)は Claude のワークフロー内の特定のポイントで自動的にスクリプトを実行します。CLAUDE.md の指示とは異なり、フックは決定論的であり、アクションが発生することを保証します。
```

</details>

<details>
<summary>channels-reference-en.md</summary>

```diff
diff --git a/docs-ja/pages/channels-reference-en.md b/docs-ja/pages/channels-reference-en.md
index f1565a4..a71e141 100644
--- a/docs-ja/pages/channels-reference-en.md
+++ b/docs-ja/pages/channels-reference-en.md
@@ -26,5 +26,5 @@ This page covers:
 * [Relay permission prompts](#relay-permission-prompts): forward tool approval prompts to remote channels
 
-To use an existing channel instead of building one, see [Channels](/en/channels). Telegram, Discord, and fakechat are included in the research preview.
+To use an existing channel instead of building one, see [Channels](/en/channels). Telegram, Discord, iMessage, and fakechat are included in the research preview.
 
 ## Overview
@@ -422,5 +422,5 @@ await mcp.notification({ ... })
 Gate on the sender's identity, not the chat or room identity: `message.from.id` in the example, not `message.chat.id`. In group chats, these differ, and gating on the room would let anyone in an allowlisted group inject messages into the session.
 
-The [Telegram](https://github.com/anthropics/claude-plugins-official/tree/main/external_plugins/telegram) and [Discord](https://github.com/anthropics/claude-plugins-official/tree/main/external_plugins/discord) channels gate on a sender allowlist the same way. They bootstrap the list by pairing: the user DMs the bot, the bot replies with a pairing code, the user approves it in their Claude Code session, and their platform ID is added. See either implementation for the full pairing flow.
+The [Telegram](https://github.com/anthropics/claude-plugins-official/tree/main/external_plugins/telegram) and [Discord](https://github.com/anthropics/claude-plugins-official/tree/main/external_plugins/discord) channels gate on a sender allowlist the same way. They bootstrap the list by pairing: the user DMs the bot, the bot replies with a pairing code, the user approves it in their Claude Code session, and their platform ID is added. See either implementation for the full pairing flow. The [iMessage](https://github.com/anthropics/claude-plugins-official/tree/main/external_plugins/imessage) channel takes a different approach: it detects the user's own addresses from the Messages database at startup and lets them through automatically, with other senders added by handle.
 
 ## Relay permission prompts
@@ -744,5 +744,5 @@ A channel published to your own marketplace still needs `--dangerously-load-deve
 ## See also
 
-* [Channels](/en/channels) to install and use Telegram, Discord, or the fakechat demo, and to enable channels for a Team or Enterprise org
+* [Channels](/en/channels) to install and use Telegram, Discord, iMessage, or the fakechat demo, and to enable channels for a Team or Enterprise org
 * [Working channel implementations](https://github.com/anthropics/claude-plugins-official/tree/main/external_plugins) for complete server code with pairing flows, reply tools, and file attachments
 * [MCP](/en/mcp) for the underlying protocol that channel servers implement
```

</details>

<details>
<summary>cli-reference-ja.md</summary>

```diff
diff --git a/docs-ja/pages/cli-reference-ja.md b/docs-ja/pages/cli-reference-ja.md
index 4b4f42b..1be5d21 100644
--- a/docs-ja/pages/cli-reference-ja.md
+++ b/docs-ja/pages/cli-reference-ja.md
@@ -11,20 +11,21 @@
 これらのコマンドを使用して、セッションを開始し、コンテンツをパイプし、会話を再開し、更新を管理できます。
 
-| コマンド                            | 説明                                                                                                                                                                                      | 例                                                  |
-| :------------------------------ | :-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :------------------------------------------------- |
-| `claude`                        | インタラクティブセッションを開始                                                                                                                                                                        | `claude`                                           |
-| `claude "query"`                | 初期プロンプト付きでインタラクティブセッションを開始                                                                                                                                                              | `claude "explain this project"`                    |
-| `claude -p "query"`             | SDK 経由でクエリを実行してから終了                                                                                                                                                                     | `claude -p "explain this function"`                |
-| `cat file \| claude -p "query"` | パイプされたコンテンツを処理                                                                                                                                                                          | `cat logs.txt \| claude -p "explain"`              |
-| `claude -c`                     | 現在のディレクトリで最新の会話を続行                                                                                                                                                                      | `claude -c`                                        |
-| `claude -c -p "query"`          | SDK 経由で続行                                                                                                                                                                               | `claude -c -p "Check for type errors"`             |
-| `claude -r "<session>" "query"` | セッション ID または名前でセッションを再開                                                                                                                                                                 | `claude -r "auth-refactor" "Finish this PR"`       |
-| `claude update`                 | 最新バージョンに更新                                                                                                                                                                              | `claude update`                                    |
-| `claude auth login`             | Anthropic アカウントにサインインします。`--email` を使用してメールアドレスを事前入力し、`--sso` を使用して SSO 認証を強制できます                                                                                                       | `claude auth login --email user@example.com --sso` |
-| `claude auth logout`            | Anthropic アカウントからログアウト                                                                                                                                                                  | `claude auth logout`                               |
-| `claude auth status`            | 認証ステータスを JSON として表示します。`--text` を使用して人間が読める形式で表示できます。ログイン済みの場合はコード 0 で終了し、ログインしていない場合は 1 で終了します                                                                                         | `claude auth status`                               |
-| `claude agents`                 | すべての設定済み [subagents](/ja/sub-agents) をソース別にグループ化して一覧表示                                                                                                                                  | `claude agents`                                    |
-| `claude mcp`                    | Model Context Protocol（MCP）サーバーを設定                                                                                                                                                      | [Claude Code MCP ドキュメント](/ja/mcp) を参照してください。       |
-| `claude remote-control`         | [Remote Control](/ja/remote-control) サーバーを開始して、Claude.ai または Claude アプリから Claude Code を制御します。サーバーモード（ローカルインタラクティブセッションなし）で実行されます。[サーバーモードフラグ](/ja/remote-control#server-mode) を参照してください | `claude remote-control --name "My Project"`        |
+| コマンド                            | 説明                                                                                                                                                                                      | 例                                            |
+| :------------------------------ | :-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :------------------------------------------- |
+| `claude`                        | インタラクティブセッションを開始                                                                                                                                                                        | `claude`                                     |
+| `claude "query"`                | 初期プロンプト付きでインタラクティブセッションを開始                                                                                                                                                              | `claude "explain this project"`              |
+| `claude -p "query"`             | SDK 経由でクエリを実行してから終了                                                                                                                                                                     | `claude -p "explain this function"`          |
+| `cat file \| claude -p "query"` | パイプされたコンテンツを処理                                                                                                                                                                          | `cat logs.txt \| claude -p "explain"`        |
+| `claude -c`                     | 現在のディレクトリで最新の会話を続行                                                                                                                                                                      | `claude -c`                                  |
```

</details>

<details>
<summary>desktop-ja.md</summary>

```diff
diff --git a/docs-ja/pages/desktop-ja.md b/docs-ja/pages/desktop-ja.md
index 00fa47e..489b955 100644
--- a/docs-ja/pages/desktop-ja.md
+++ b/docs-ja/pages/desktop-ja.md
@@ -5,5 +5,5 @@
 # Claude Code Desktop を使用する
 
-> Claude Code Desktop をさらに活用する：Git 分離による並列セッション、ビジュアル diff レビュー、アプリプレビュー、PR 監視、権限モード、コネクタ、エンタープライズ設定。
+> Claude Code Desktop をさらに活用する：コンピュータ使用、電話から Dispatch セッションを送信、Git 分離による並列セッション、ビジュアル diff レビュー、アプリプレビュー、PR 監視、コネクタ、エンタープライズ設定。
 
 Claude Desktop アプリ内の Code タブを使用すると、ターミナルではなくグラフィカルインターフェイスを通じて Claude Code を使用できます。
@@ -13,6 +13,8 @@ Desktop は標準的な Claude Code エクスペリエンスに以下の機能
 * [ビジュアル diff レビュー](#review-changes-with-diff-view)（インラインコメント付き）
 * [ライブアプリプレビュー](#preview-your-app)（dev サーバー付き）
+* [コンピュータ使用](#let-claude-use-your-computer)（macOS でアプリを開いてスクリーンを制御）
 * [GitHub PR 監視](#monitor-pull-request-status)（自動修正と自動マージ付き）
 * [並列セッション](#work-in-parallel-with-sessions)（自動 Git worktree 分離付き）
+* [Dispatch](#sessions-from-dispatch) 統合：電話からタスクを送信し、ここでセッションを取得
 * [スケジュール済みタスク](#schedule-recurring-tasks)（定期的に Claude を実行）
 * [コネクタ](#connect-external-tools)（GitHub、Slack、Linear など）
@@ -23,5 +25,5 @@ Desktop は標準的な Claude Code エクスペリエンスに以下の機能
 </Tip>
 
-このページでは、[コードの操作](#work-with-code)、[セッションの管理](#manage-sessions)、[Claude Code の拡張](#extend-claude-code)、[スケジュール済みタスク](#schedule-recurring-tasks)、および[設定](#environment-configuration)について説明します。また、[CLI 比較](#coming-from-the-cli)と[トラブルシューティング](#troubleshooting)も含まれています。
+このページでは、[コードの操作](#work-with-code)、[コンピュータ使用](#let-claude-use-your-computer)、[セッションの管理](#manage-sessions)、[Claude Code の拡張](#extend-claude-code)、[スケジュール済みタスク](#schedule-recurring-tasks)、および[設定](#environment-configuration)について説明します。また、[CLI 比較](#coming-from-the-cli)と[トラブルシューティング](#troubleshooting)も含まれています。
 
 ## セッションを開始する
@@ -57,12 +59,13 @@ Claude に実行させたいことを入力して**Enter**キーを押して送
 権限モードは、セッション中に Claude がどの程度の自律性を持つかを制御します：ファイルの編集、コマンドの実行、またはその両方の前に確認するかどうかです。送信ボタンの横のモードセレクタを使用して、いつでもモードを切り替えることができます。Ask permissions で開始して Claude が実行する内容を正確に確認してから、慣れてきたら Auto accept edits または Plan mode に移動します。
 
```

</details>

<details>
<summary>hooks-ja.md</summary>

```diff
diff --git a/docs-ja/pages/hooks-ja.md b/docs-ja/pages/hooks-ja.md
index 2e7d3df..da46cb2 100644
--- a/docs-ja/pages/hooks-ja.md
+++ b/docs-ja/pages/hooks-ja.md
@@ -167,15 +167,19 @@ fi
 `matcher` フィールドは、フックが発火するタイミングをフィルタリングする正規表現文字列です。`"*"`、`""`、または `matcher` を完全に省略して、すべての出現にマッチします。各イベント タイプは異なるフィールドでマッチします。
 
-| イベント                                                                                                            | マッチャーがフィルタリングするもの | マッチャー値の例                                                                       |
-| :-------------------------------------------------------------------------------------------------------------- | :---------------- | :----------------------------------------------------------------------------- |
-| `PreToolUse`、`PostToolUse`、`PostToolUseFailure`、`PermissionRequest`                                             | ツール名              | `Bash`、`Edit\|Write`、`mcp__.*`                                                 |
-| `SessionStart`                                                                                                  | セッションの開始方法        | `startup`、`resume`、`clear`、`compact`                                           |
-| `SessionEnd`                                                                                                    | セッションが終了した理由      | `clear`、`logout`、`prompt_input_exit`、`bypass_permissions_disabled`、`other`     |
-| `Notification`                                                                                                  | 通知タイプ             | `permission_prompt`、`idle_prompt`、`auth_success`、`elicitation_dialog`          |
-| `SubagentStart`                                                                                                 | エージェント タイプ        | `Bash`、`Explore`、`Plan`、またはカスタム エージェント名                                        |
-| `PreCompact`                                                                                                    | コンパクションをトリガーしたもの  | `manual`、`auto`                                                                |
-| `SubagentStop`                                                                                                  | エージェント タイプ        | `SubagentStart` と同じ値                                                           |
-| `ConfigChange`                                                                                                  | 設定ソース             | `user_settings`、`project_settings`、`local_settings`、`policy_settings`、`skills` |
-| `UserPromptSubmit`、`Stop`、`TeammateIdle`、`TaskCompleted`、`WorktreeCreate`、`WorktreeRemove`、`InstructionsLoaded` | マッチャー サポートなし      | すべての出現で常に発火                                                                    |
+| イベント                                                                                       | マッチャーがフィルタリングするもの | マッチャー値の例                                                                                                            |
+| :----------------------------------------------------------------------------------------- | :---------------- | :------------------------------------------------------------------------------------------------------------------ |
+| `PreToolUse`、`PostToolUse`、`PostToolUseFailure`、`PermissionRequest`                        | ツール名              | `Bash`、`Edit\|Write`、`mcp__.*`                                                                                      |
+| `SessionStart`                                                                             | セッションの開始方法        | `startup`、`resume`、`clear`、`compact`                                                                                |
+| `SessionEnd`                                                                               | セッションが終了した理由      | `clear`、`resume`、`logout`、`prompt_input_exit`、`bypass_permissions_disabled`、`other`                                 |
+| `Notification`                                                                             | 通知タイプ             | `permission_prompt`、`idle_prompt`、`auth_success`、`elicitation_dialog`                                               |
+| `SubagentStart`                                                                            | エージェント タイプ        | `Bash`、`Explore`、`Plan`、またはカスタム エージェント名                                                                             |
+| `PreCompact`、`PostCompact`                                                                 | コンパクションをトリガーしたもの  | `manual`、`auto`                                                                                                     |
+| `SubagentStop`                                                                             | エージェント タイプ        | `SubagentStart` と同じ値                                                                                                |
+| `ConfigChange`                                                                             | 設定ソース             | `user_settings`、`project_settings`、`local_settings`、`policy_settings`、`skills`                                      |
+| `StopFailure`                                                                              | エラー タイプ           | `rate_limit`、`authentication_failed`、`billing_error`、`invalid_request`、`server_error`、`max_output_tokens`、`unknown` |
+| `InstructionsLoaded`                                                                       | ロード理由             | `session_start`、`nested_traversal`、`path_glob_match`、`include`、`compact`                                            |
```

</details>

<details>
<summary>how-claude-code-works-ja.md</summary>

```diff
diff --git a/docs-ja/pages/how-claude-code-works-ja.md b/docs-ja/pages/how-claude-code-works-ja.md
index 8abfc32..31d499e 100644
--- a/docs-ja/pages/how-claude-code-works-ja.md
+++ b/docs-ja/pages/how-claude-code-works-ja.md
@@ -125,5 +125,5 @@ claude --continue --fork-session
 ### コンテキストウィンドウ
 
-Claude のコンテキストウィンドウは、会話履歴、ファイルコンテンツ、コマンド出力、[CLAUDE.md](/ja/memory)、読み込まれたスキル、システム指示を保持します。作業を進めると、コンテキストが満杯になります。Claude は自動的にコンパクト化しますが、会話の早い段階からの指示が失われる可能性があります。永続的なルールを CLAUDE.md に入れ、`/context` を実行してスペースを使用しているものを確認してください。
+Claude のコンテキストウィンドウは、会話履歴、ファイルコンテンツ、コマンド出力、[CLAUDE.md](/ja/memory)、[自動メモリ](/ja/memory#auto-memory)、読み込まれたスキル、システム指示を保持します。作業を進めると、コンテキストが満杯になります。Claude は自動的にコンパクト化しますが、会話の早い段階からの指示が失われる可能性があります。永続的なルールを CLAUDE.md に入れ、`/context` を実行してスペースを使用しているものを確認してください。
 
 #### コンテキストが満杯になったとき
@@ -161,5 +161,6 @@ Claude には 2 つの安全メカニズムがあります。チェックポイ
 * **デフォルト**：Claude はファイル編集とシェルコマンドの前に求めます
 * **自動受け入れ編集**：Claude はファイルを編集するよう求めず、コマンドは求めます
-* **プランモード**：Claude は読み取り専用ツールのみを使用し、実行前に承認できるプランを作成します
+* **Plan Mode**：Claude は読み取り専用ツールのみを使用し、実行前に承認できるプランを作成します
+* **Auto mode**：Claude はバックグラウンド安全チェック付きですべてのアクションを評価します。現在は研究プレビューです
 
 `.claude/settings.json` で特定のコマンドを許可することもできます。これにより、Claude は毎回求めません。これは `npm test` や `git status` などの信頼できるコマンドに便利です。設定は組織全体のポリシーから個人的な設定までスコープできます。詳細については、[権限](/ja/permissions) を参照してください。
@@ -228,5 +229,5 @@ validateEmail を実装します。テストケース：'user@example.com' → t
 ### 実装する前に探索する
 
-複雑な問題の場合、研究とコーディングを分離します。プランモード（`Shift+Tab` を 2 回）を使用してコードベースを最初に分析します。
+複雑な問題の場合、研究とコーディングを分離します。Plan Mode（`Shift+Tab` を 2 回）を使用してコードベースを最初に分析します。
 
 ```text  theme={null}
```

</details>

*...以降省略*

</details>


<details>
<summary>2026-03-24</summary>

**変更ファイル:**

```
 docs-ja/pages/authentication-en.md           | 134 -------
 docs-ja/pages/checkpointing-ja.md            |  70 ++--
 docs-ja/pages/cli-reference-ja.md            | 177 +++------
 docs-ja/pages/code-review-ja.md              |  97 +++--
 docs-ja/pages/commands-en.md                 |  89 -----
 docs-ja/pages/common-workflows-ja.md         | 200 ++++++----
 docs-ja/pages/costs-ja.md                    |   4 +-
 docs-ja/pages/data-usage-ja.md               |  16 +-
 docs-ja/pages/desktop-ja.md                  | 242 ++++++------
 docs-ja/pages/desktop-quickstart-ja.md       |  30 +-
 docs-ja/pages/discover-plugins-ja.md         |   8 +-
 docs-ja/pages/env-vars-en.md                 | 123 ------
 docs-ja/pages/fast-mode-ja.md                |  32 +-
 docs-ja/pages/features-overview-ja.md        |   4 +-
 docs-ja/pages/google-vertex-ai-ja.md         |  88 +++--
 docs-ja/pages/headless-ja.md                 |  10 +-
 docs-ja/pages/hooks-guide-ja.md              | 225 ++++++-----
 docs-ja/pages/hooks-ja.md                    | 568 ++++++++++++++++++---------
 docs-ja/pages/how-claude-code-works-ja.md    |  92 ++---
 docs-ja/pages/interactive-mode-ja.md         | 226 ++++-------
 docs-ja/pages/legal-and-compliance-ja.md     |  39 +-
 docs-ja/pages/mcp-ja.md                      |  22 +-
 docs-ja/pages/memory-ja.md                   |  82 ++--
 docs-ja/pages/model-config-ja.md             | 127 +++---
 docs-ja/pages/monitoring-usage-ja.md         | 119 ++++--
 docs-ja/pages/network-config-ja.md           |   8 +-
 docs-ja/pages/overview-ja.md                 |  72 ++--
 docs-ja/pages/plugin-marketplaces-ja.md      |  18 +-
 docs-ja/pages/plugins-ja.md                  |   4 +-
 docs-ja/pages/quickstart-ja.md               |  86 ++--
 docs-ja/pages/remote-control-ja.md           |  68 ++--
 docs-ja/pages/scheduled-tasks-ja.md          |  24 +-
 docs-ja/pages/server-managed-settings-ja.md  |  40 +-
 docs-ja/pages/settings-ja.md                 | 568 ++++++++++-----------------
 docs-ja/pages/setup-ja.md                    | 355 +++++++++--------
 docs-ja/pages/skills-ja.md                   | 160 ++++----
 docs-ja/pages/statusline-ja.md               |  82 ++--
 docs-ja/pages/sub-agents-ja.md               | 240 ++++++-----
 docs-ja/pages/terminal-config-ja.md          |  63 +--
 docs-ja/pages/third-party-integrations-ja.md | 336 ++++++++--------
 docs-ja/pages/tools-reference-en.md          |  59 ---
 docs-ja/pages/troubleshooting-ja.md          | 254 ++++++------
 docs-ja/pages/vs-code-ja.md                  |  74 ++--
 43 files changed, 2565 insertions(+), 2770 deletions(-)
```

**新規追加:**


**削除:**


<details>
<summary>checkpointing-ja.md</summary>

```diff
diff --git a/docs-ja/pages/checkpointing-ja.md b/docs-ja/pages/checkpointing-ja.md
index 32f841d..705d6ec 100644
--- a/docs-ja/pages/checkpointing-ja.md
+++ b/docs-ja/pages/checkpointing-ja.md
@@ -3,37 +3,57 @@
 > Use this file to discover all available pages before exploring further.
 
-# Checkpointing
+# チェックポイント
 
-> Claude の編集を自動的に追跡し、不要な変更から素早く復旧するために以前の状態に巻き戻します。
+> Claude のエディット内容と会話を追跡、巻き戻し、要約してセッション状態を管理します。
 
-Claude Code は、作業中に Claude のファイル編集を自動的に追跡し、何か問題が発生した場合に変更を素早く取り消し、以前の状態に巻き戻すことができます。
+Claude Code は、作業中に Claude が行ったファイルエディットを自動的に追跡し、変更をすばやく取り消したり、問題が発生した場合に以前の状態に巻き戻したりできます。
 
-## Checkpointing の仕組み
+## チェックポイントの仕組み
 
-Claude と作業する際、checkpointing は各編集の前にコードの状態を自動的にキャプチャします。このセーフティネットにより、野心的で大規模なタスクを実行する際に、いつでも以前のコード状態に戻ることができるという安心感を持って作業できます。
+Claude で作業する際、チェックポイント機能は各エディット前のコード状態を自動的にキャプチャします。このセーフティネットにより、野心的で大規模なタスクを実行する際に、いつでも以前のコード状態に戻ることができるという安心感を持って作業できます。
 
 ### 自動追跡
 
-Claude Code は、ファイル編集ツールによって行われたすべての変更を追跡します：
+Claude Code は、ファイル編集ツールで行われたすべての変更を追跡します。
 
-* ユーザープロンプトごとに新しい checkpoint が作成されます
-* Checkpoint はセッション間で保持されるため、再開された会話でアクセスできます
-* セッションとともに 30 日後に自動的にクリーンアップされます（設定可能）
```

</details>

<details>
<summary>cli-reference-ja.md</summary>

```diff
diff --git a/docs-ja/pages/cli-reference-ja.md b/docs-ja/pages/cli-reference-ja.md
index 8572d76..4b4f42b 100644
--- a/docs-ja/pages/cli-reference-ja.md
+++ b/docs-ja/pages/cli-reference-ja.md
@@ -11,20 +11,20 @@
 これらのコマンドを使用して、セッションを開始し、コンテンツをパイプし、会話を再開し、更新を管理できます。
 
-| コマンド                            | 説明                                                                                                                                                               | 例                                                  |
-| :------------------------------ | :--------------------------------------------------------------------------------------------------------------------------------------------------------------- | :------------------------------------------------- |
-| `claude`                        | インタラクティブセッションを開始                                                                                                                                                 | `claude`                                           |
-| `claude "query"`                | 初期プロンプト付きでインタラクティブセッションを開始                                                                                                                                       | `claude "explain this project"`                    |
-| `claude -p "query"`             | SDK 経由でクエリを実行してから終了                                                                                                                                              | `claude -p "explain this function"`                |
-| `cat file \| claude -p "query"` | パイプされたコンテンツを処理                                                                                                                                                   | `cat logs.txt \| claude -p "explain"`              |
-| `claude -c`                     | 現在のディレクトリで最新の会話を続行                                                                                                                                               | `claude -c`                                        |
-| `claude -c -p "query"`          | SDK 経由で続行                                                                                                                                                        | `claude -c -p "Check for type errors"`             |
-| `claude -r "<session>" "query"` | ID または名前でセッションを再開                                                                                                                                                | `claude -r "auth-refactor" "Finish this PR"`       |
-| `claude update`                 | 最新バージョンに更新                                                                                                                                                       | `claude update`                                    |
-| `claude auth login`             | Anthropic アカウントにサインイン。`--email` を使用してメールアドレスを事前入力し、`--sso` を使用して SSO 認証を強制します                                                                                    | `claude auth login --email user@example.com --sso` |
-| `claude auth logout`            | Anthropic アカウントからログアウト                                                                                                                                           | `claude auth logout`                               |
-| `claude auth status`            | 認証ステータスを JSON として表示。`--text` を使用して人間が読める形式で表示。ログイン済みの場合はコード 0 で終了、ログインしていない場合は 1 で終了                                                                             | `claude auth status`                               |
-| `claude agents`                 | すべての設定済み [subagents](/ja/sub-agents) をソース別にグループ化して一覧表示                                                                                                           | `claude agents`                                    |
-| `claude mcp`                    | Model Context Protocol（MCP）サーバーを設定                                                                                                                               | [Claude Code MCP ドキュメント](/ja/mcp) を参照してください。       |
-| `claude remote-control`         | [Remote Control セッション](/ja/remote-control) を開始して、ローカルで実行中の Claude Code を Claude.ai または Claude アプリから制御します。フラグについては [Remote Control](/ja/remote-control) を参照してください | `claude remote-control`                            |
+| コマンド                            | 説明                                                                                                                                                                                      | 例                                                  |
+| :------------------------------ | :-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :------------------------------------------------- |
+| `claude`                        | インタラクティブセッションを開始                                                                                                                                                                        | `claude`                                           |
+| `claude "query"`                | 初期プロンプト付きでインタラクティブセッションを開始                                                                                                                                                              | `claude "explain this project"`                    |
+| `claude -p "query"`             | SDK 経由でクエリを実行してから終了                                                                                                                                                                     | `claude -p "explain this function"`                |
+| `cat file \| claude -p "query"` | パイプされたコンテンツを処理                                                                                                                                                                          | `cat logs.txt \| claude -p "explain"`              |
+| `claude -c`                     | 現在のディレクトリで最新の会話を続行                                                                                                                                                                      | `claude -c`                                        |
```

</details>

<details>
<summary>code-review-ja.md</summary>

```diff
diff --git a/docs-ja/pages/code-review-ja.md b/docs-ja/pages/code-review-ja.md
index c19eb81..815c1b8 100644
--- a/docs-ja/pages/code-review-ja.md
+++ b/docs-ja/pages/code-review-ja.md
@@ -3,7 +3,7 @@
 > Use this file to discover all available pages before exploring further.
 
-# コードレビュー
+# Code Review
 
-> マルチエージェント分析を使用してフルコードベースを検査し、ロジックエラー、セキュリティ脆弱性、リグレッションを検出する自動化された PR レビューをセットアップします
+> マルチエージェント分析を使用してコードベース全体を検査し、ロジックエラー、セキュリティ脆弱性、リグレッションを検出する自動化された PR レビューを設定します
 
 <Note>
@@ -11,9 +11,9 @@
 </Note>
 
-Code Review は GitHub プルリクエストを分析し、問題が見つかったコード行にインラインコメントとして結果を投稿します。特化したエージェントのフリートがフルコードベースのコンテキストでコード変更を検査し、ロジックエラー、セキュリティ脆弱性、壊れたエッジケース、微妙なリグレッションを探します。
+Code Review は GitHub プルリクエストを分析し、コードの問題が見つかった行にインラインコメントとして結果を投稿します。特化したエージェントのフリートがコード変更をコードベース全体のコンテキストで検査し、ロジックエラー、セキュリティ脆弱性、壊れたエッジケース、微妙なリグレッションを探します。
 
-結果は重大度でタグ付けされ、PR を承認またはブロックしないため、既存のレビューワークフローはそのまま機能します。リポジトリに `CLAUDE.md` または `REVIEW.md` ファイルを追加することで、Claude がフラグを立てる内容をチューニングできます。
+結果は重大度でタグ付けされ、PR を承認またはブロックしないため、既存のレビューワークフローはそのまま機能します。リポジトリに `CLAUDE.md` または `REVIEW.md` ファイルを追加することで、Claude がフラグを立てる内容をカスタマイズできます。
 
-独自の CI インフラストラクチャでこのマネージドサービスの代わりに Claude を実行する場合は、[GitHub Actions](/ja/github-actions) または [GitLab CI/CD](/ja/gitlab-ci-cd) を参照してください。
+Claude を管理サービスではなく独自の CI インフラストラクチャで実行する場合は、[GitHub Actions](/ja/github-actions) または [GitLab CI/CD](/ja/gitlab-ci-cd) を参照してください。
 
 このページでは以下をカバーしています：
@@ -21,10 +21,12 @@ Code Review は GitHub プルリクエストを分析し、問題が見つかっ
 * [レビューの仕組み](#how-reviews-work)
 * [セットアップ](#set-up-code-review)
```

</details>

<details>
<summary>common-workflows-ja.md</summary>

```diff
diff --git a/docs-ja/pages/common-workflows-ja.md b/docs-ja/pages/common-workflows-ja.md
index 0ddb41f..5ab0cf8 100644
--- a/docs-ja/pages/common-workflows-ja.md
+++ b/docs-ja/pages/common-workflows-ja.md
@@ -16,5 +16,5 @@
 
 <Steps>
-  <Step title="プロジェクトのルートディレクトリに移動する">
+  <Step title="プロジェクトルートディレクトリに移動する">
     ```bash  theme={null}
     cd /path/to/project 
@@ -28,5 +28,5 @@
   </Step>
 
-  <Step title="高レベルの概要を要求する">
+  <Step title="高レベルの概要をリクエストする">
     ```text  theme={null}
     give me an overview of this codebase
@@ -102,5 +102,5 @@
   </Step>
 
-  <Step title="修正の推奨事項を要求する">
+  <Step title="修正の推奨事項をリクエストする">
     ```text  theme={null}
     suggest a few ways to fix the @ts-ignore in user.ts
@@ -159,5 +159,5 @@
 
   * Claude に最新のアプローチの利点を説明するよう依頼する
-  * 必要に応じて、変更が後方互換性を維持することをリクエストする
+  * 必要に応じて変更が後方互換性を維持することをリクエストする
```

</details>

<details>
<summary>costs-ja.md</summary>

```diff
diff --git a/docs-ja/pages/costs-ja.md b/docs-ja/pages/costs-ja.md
index 7dca18d..0a6cbcc 100644
--- a/docs-ja/pages/costs-ja.md
+++ b/docs-ja/pages/costs-ja.md
@@ -160,5 +160,5 @@ Sonnet はほとんどのコーディングタスクをうまく処理し、Opus
 </Tabs>
 
-### CLAUDE.md から スキルに指示を移動する
+### CLAUDE.md からスキルに指示を移動する
 
 [CLAUDE.md](/ja/memory) ファイルはセッション開始時にコンテキストに読み込まれます。PR レビューやデータベース移行などの特定のワークフロー用の詳細な指示が含まれている場合、関連のない作業を行っている場合でもそれらのトークンが存在します。[スキル](/ja/skills) はオンデマンドでのみ呼び出されたときに読み込まれるため、特殊な指示をスキルに移動することで、ベースコンテキストを小さく保ちます。CLAUDE.md を約 500 行以下に保つことを目指し、必須のみを含めます。
@@ -166,5 +166,5 @@ Sonnet はほとんどのコーディングタスクをうまく処理し、Opus
 ### 拡張思考を調整する
 
-拡張思考はデフォルトで有効になっており、予算は 31,999 トークンです。これは複雑な計画と推論タスクのパフォーマンスを大幅に向上させるためです。ただし、思考トークンは出力トークンとして課金されるため、深い推論が必要ない単純なタスクの場合、`/model` で Opus 4.6 の [努力レベル](/ja/model-config#adjust-effort-level) を低下させるか、`/config` で思考を無効にするか、予算を低下させることでコストを削減できます（たとえば、`MAX_THINKING_TOKENS=8000`）。
+拡張思考はデフォルトで有効になっており、予算は 31,999 トークンです。これは複雑な計画と推論タスクのパフォーマンスを大幅に向上させるためです。ただし、思考トークンは出力トークンとして課金されるため、深い推論が必要ない単純なタスクの場合、`/effort` で [努力レベル](/ja/model-config#adjust-effort-level) を低下させるか、`/model` で、`/config` で思考を無効にするか、予算を低下させることでコストを削減できます（たとえば、`MAX_THINKING_TOKENS=8000`）。
 
 ### 詳細な操作を subagent に委任する
```

</details>

<details>
<summary>data-usage-ja.md</summary>

```diff
diff --git a/docs-ja/pages/data-usage-ja.md b/docs-ja/pages/data-usage-ja.md
index 4eb7ed1..6aa6f3f 100644
--- a/docs-ja/pages/data-usage-ja.md
+++ b/docs-ja/pages/data-usage-ja.md
@@ -28,5 +28,5 @@
 Claude Code で「How is Claude doing this session?」プロンプトが表示されたときに、この調査に応答する場合（「Dismiss」を選択する場合を含む）、数値評価（1、2、3、または dismiss）のみが記録されます。この調査の一部として、会話トランスクリプト、入力、出力、またはその他のセッションデータは収集または保存されません。サムズアップ/ダウンフィードバックまたは `/bug` レポートとは異なり、このセッション品質調査は単純な製品満足度メトリックです。この調査への応答は、データトレーニング設定に影響を与えず、AI モデルをトレーニングするために使用することはできません。
 
-これらの調査を無効にするには、`CLAUDE_CODE_DISABLE_FEEDBACK_SURVEY=1` を設定します。サードパーティプロバイダー（Bedrock、Vertex、Foundry）を使用する場合、またはテレメトリが無効になっている場合、調査は自動的に無効になります。
+これらの調査を無効にするには、`CLAUDE_CODE_DISABLE_FEEDBACK_SURVEY=1` を設定します。調査は、`DISABLE_TELEMETRY` または `CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC` が設定されている場合にも無効になります。頻度を制御する代わりに無効にするには、設定ファイルで [`feedbackSurveyRate`](/ja/settings#available-settings) を `0` から `1` の間の確率に設定します。
 
 ### データ保持
@@ -87,12 +87,12 @@ Claude Code は、ユーザーのマシンから Sentry に接続して、運用
 ## API プロバイダーのデフォルト動作
 
-デフォルトでは、Bedrock、Vertex、または Foundry を使用する場合、すべての非必須トラフィック（エラーレポート、テレメトリ、バグレポート機能、セッション品質調査を含む）を無効にします。`CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC` 環境変数を設定することで、これらすべてを一度にオプトアウトすることもできます。以下は完全なデフォルト動作です：
+デフォルトでは、Bedrock、Vertex、または Foundry を使用する場合、エラーレポート、テレメトリ、およびバグレポートは無効になります。セッション品質調査は例外であり、プロバイダーに関係なく表示されます。`CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC` を設定することで、調査を含むすべての非必須トラフィックをオプトアウトできます。以下は完全なデフォルト動作です：
 
-| サービス                        | Claude API                                                     | Vertex API                                             | Bedrock API                                             | Foundry API                                             |
-| --------------------------- | -------------------------------------------------------------- | ------------------------------------------------------ | ------------------------------------------------------- | ------------------------------------------------------- |
-| **Statsig（メトリクス）**          | デフォルトオン。<br />`DISABLE_TELEMETRY=1` で無効にします。                   | デフォルトオフ。<br />`CLAUDE_CODE_USE_VERTEX` は 1 である必要があります。 | デフォルトオフ。<br />`CLAUDE_CODE_USE_BEDROCK` は 1 である必要があります。 | デフォルトオフ。<br />`CLAUDE_CODE_USE_FOUNDRY` は 1 である必要があります。 |
-| **Sentry（エラー）**             | デフォルトオン。<br />`DISABLE_ERROR_REPORTING=1` で無効にします。             | デフォルトオフ。<br />`CLAUDE_CODE_USE_VERTEX` は 1 である必要があります。 | デフォルトオフ。<br />`CLAUDE_CODE_USE_BEDROCK` は 1 である必要があります。 | デフォルトオフ。<br />`CLAUDE_CODE_USE_FOUNDRY` は 1 である必要があります。 |
-| **Claude API（`/bug` レポート）** | デフォルトオン。<br />`DISABLE_BUG_COMMAND=1` で無効にします。                 | デフォルトオフ。<br />`CLAUDE_CODE_USE_VERTEX` は 1 である必要があります。 | デフォルトオフ。<br />`CLAUDE_CODE_USE_BEDROCK` は 1 である必要があります。 | デフォルトオフ。<br />`CLAUDE_CODE_USE_FOUNDRY` は 1 である必要があります。 |
-| **セッション品質調査**               | デフォルトオン。<br />`CLAUDE_CODE_DISABLE_FEEDBACK_SURVEY=1` で無効にします。 | デフォルトオフ。<br />`CLAUDE_CODE_USE_VERTEX` は 1 である必要があります。 | デフォルトオフ。<br />`CLAUDE_CODE_USE_BEDROCK` は 1 である必要があります。 | デフォルトオフ。<br />`CLAUDE_CODE_USE_FOUNDRY` は 1 である必要があります。 |
+| サービス                        | Claude API                                                     | Vertex API                                                     | Bedrock API                                                    | Foundry API                                                    |
+| --------------------------- | -------------------------------------------------------------- | -------------------------------------------------------------- | -------------------------------------------------------------- | -------------------------------------------------------------- |
+| **Statsig（メトリクス）**          | デフォルトオン。<br />`DISABLE_TELEMETRY=1` で無効にします。                   | デフォルトオフ。<br />`CLAUDE_CODE_USE_VERTEX` は 1 である必要があります。         | デフォルトオフ。<br />`CLAUDE_CODE_USE_BEDROCK` は 1 である必要があります。        | デフォルトオフ。<br />`CLAUDE_CODE_USE_FOUNDRY` は 1 である必要があります。        |
+| **Sentry（エラー）**             | デフォルトオン。<br />`DISABLE_ERROR_REPORTING=1` で無効にします。             | デフォルトオフ。<br />`CLAUDE_CODE_USE_VERTEX` は 1 である必要があります。         | デフォルトオフ。<br />`CLAUDE_CODE_USE_BEDROCK` は 1 である必要があります。        | デフォルトオフ。<br />`CLAUDE_CODE_USE_FOUNDRY` は 1 である必要があります。        |
+| **Claude API（`/bug` レポート）** | デフォルトオン。<br />`DISABLE_BUG_COMMAND=1` で無効にします。                 | デフォルトオフ。<br />`CLAUDE_CODE_USE_VERTEX` は 1 である必要があります。         | デフォルトオフ。<br />`CLAUDE_CODE_USE_BEDROCK` は 1 である必要があります。        | デフォルトオフ。<br />`CLAUDE_CODE_USE_FOUNDRY` は 1 である必要があります。        |
+| **セッション品質調査**               | デフォルトオン。<br />`CLAUDE_CODE_DISABLE_FEEDBACK_SURVEY=1` で無効にします。 | デフォルトオン。<br />`CLAUDE_CODE_DISABLE_FEEDBACK_SURVEY=1` で無効にします。 | デフォルトオン。<br />`CLAUDE_CODE_DISABLE_FEEDBACK_SURVEY=1` で無効にします。 | デフォルトオン。<br />`CLAUDE_CODE_DISABLE_FEEDBACK_SURVEY=1` で無効にします。 |
 
```

</details>

*...以降省略*

</details>


<details>
<summary>2026-03-23</summary>

**変更ファイル:**

```
 docs-ja/pages/channels-en.md           |   4 +-
 docs-ja/pages/channels-reference-en.md | 376 +++++++++++++++++++++++++++++++--
 docs-ja/pages/env-vars-en.md           |   2 +-
 3 files changed, 365 insertions(+), 17 deletions(-)
```

<details>
<summary>channels-en.md</summary>

```diff
diff --git a/docs-ja/pages/channels-en.md b/docs-ja/pages/channels-en.md
index 88b2740..ef64b59 100644
--- a/docs-ja/pages/channels-en.md
+++ b/docs-ja/pages/channels-en.md
@@ -218,5 +218,5 @@ To try the fakechat demo, you'll need:
 </Steps>
 
-If Claude hits a permission prompt while you're away from the terminal, the session pauses until you approve locally. For unattended use, [`--dangerously-skip-permissions`](/en/permissions#permission-modes) bypasses prompts, but only use it in environments you trust.
+If Claude hits a permission prompt while you're away from the terminal, the session pauses until you respond. Channel servers that declare the [permission relay capability](/en/channels-reference#relay-permission-prompts) can forward these prompts to you so you can approve or deny remotely. For unattended use, [`--dangerously-skip-permissions`](/en/permissions#permission-modes) bypasses prompts entirely, but only use it in environments you trust.
 
 ## Security
@@ -235,4 +235,6 @@ On top of that, you control which servers are enabled each session with `--chann
 Being in `.mcp.json` isn't enough to push messages: a server also has to be named in `--channels`.
 
+The allowlist also gates [permission relay](/en/channels-reference#relay-permission-prompts) if the channel declares it. Anyone who can reply through the channel can approve or deny tool use in your session, so only allowlist senders you trust with that authority.
+
 ## Enterprise controls
 
```

</details>

<details>
<summary>channels-reference-en.md</summary>

```diff
diff --git a/docs-ja/pages/channels-reference-en.md b/docs-ja/pages/channels-reference-en.md
index e1bc59a..f1565a4 100644
--- a/docs-ja/pages/channels-reference-en.md
+++ b/docs-ja/pages/channels-reference-en.md
@@ -5,5 +5,5 @@
 # Channels reference
 
-> Build an MCP server that pushes webhooks, alerts, and chat messages into a Claude Code session. Reference for the channel contract: capability declaration, notification events, reply tools, and sender gating.
+> Build an MCP server that pushes webhooks, alerts, and chat messages into a Claude Code session. Reference for the channel contract: capability declaration, notification events, reply tools, sender gating, and permission relay.
 
 <Note>
@@ -13,5 +13,5 @@
 A channel is an MCP server that pushes events into a Claude Code session so Claude can react to things happening outside the terminal.
 
-You can build a one-way or two-way channel. One-way channels forward alerts, webhooks, or monitoring events for Claude to act on. Two-way channels like chat bridges also [expose a reply tool](#expose-a-reply-tool) so Claude can send messages back.
+You can build a one-way or two-way channel. One-way channels forward alerts, webhooks, or monitoring events for Claude to act on. Two-way channels like chat bridges also [expose a reply tool](#expose-a-reply-tool) so Claude can send messages back. A channel with a trusted sender path can also opt in to [relay permission prompts](#relay-permission-prompts) so you can approve or deny tool use remotely.
 
 This page covers:
@@ -24,4 +24,5 @@ This page covers:
 * [Expose a reply tool](#expose-a-reply-tool): let Claude send messages back
 * [Gate inbound messages](#gate-inbound-messages): sender checks to prevent prompt injection
+* [Relay permission prompts](#relay-permission-prompts): forward tool approval prompts to remote channels
 
 To use an existing channel instead of building one, see [Channels](/en/channels). Telegram, Discord, and fakechat are included in the research preview.
@@ -153,4 +154,9 @@ This example uses [Bun](https://bun.sh) as the runtime for its built-in HTTP ser
 
     In your Claude Code terminal, you'll see Claude receive the message and start responding: reading files, running commands, or whatever the message calls for. This is a one-way channel, so Claude acts in your session but doesn't send anything back through the webhook. To add replies, see [Expose a reply tool](#expose-a-reply-tool).
+
+    If the event doesn't arrive, the diagnosis depends on what `curl` returned:
+
```

</details>

<details>
<summary>env-vars-en.md</summary>

```diff
diff --git a/docs-ja/pages/env-vars-en.md b/docs-ja/pages/env-vars-en.md
index 0bdcb34..fa55c70 100644
--- a/docs-ja/pages/env-vars-en.md
+++ b/docs-ja/pages/env-vars-en.md
@@ -71,5 +71,5 @@ Claude Code supports the following environment variables to control its behavior
 | `CLAUDE_CODE_SHELL`                            | Override automatic shell detection. Useful when your login shell differs from your preferred working shell (for example, `bash` vs `zsh`)                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
 | `CLAUDE_CODE_SHELL_PREFIX`                     | Command prefix to wrap all bash commands (for example, for logging or auditing). Example: `/path/to/logger.sh` will execute `/path/to/logger.sh <command>`                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
-| `CLAUDE_CODE_SIMPLE`                           | Set to `1` to run with a minimal system prompt and only the Bash, file read, and file edit tools. Disables MCP tools, attachments, hooks, and CLAUDE.md files                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
+| `CLAUDE_CODE_SIMPLE`                           | Set to `1` to run with a minimal system prompt and only the Bash, file read, and file edit tools. Disables auto-discovery of hooks, skills, plugins, MCP servers, auto memory, and CLAUDE.md. The [`--bare`](/en/headless#start-faster-with-bare-mode) CLI flag sets this                                                                                                                                                                                                                                                                                                                                        |
 | `CLAUDE_CODE_SKIP_BEDROCK_AUTH`                | Skip AWS authentication for Bedrock (for example, when using an LLM gateway)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
 | `CLAUDE_CODE_SKIP_FAST_MODE_NETWORK_ERRORS`    | Set to `1` to allow [fast mode](/en/fast-mode) when the organization status check fails due to a network error. Useful when a corporate proxy blocks the status endpoint. The API still enforces organization-level disable separately                                                                                                                                                                                                                                                                                                                                                                           |
```

</details>

</details>


<details>
<summary>2026-03-22</summary>

**変更ファイル:**

```
 docs-ja/pages/channels-en.md | 10 +++++++---
 docs-ja/pages/env-vars-en.md |  2 +-
 2 files changed, 8 insertions(+), 4 deletions(-)
```

<details>
<summary>channels-en.md</summary>

```diff
diff --git a/docs-ja/pages/channels-en.md b/docs-ja/pages/channels-en.md
index 4f3279d..88b2740 100644
--- a/docs-ja/pages/channels-en.md
+++ b/docs-ja/pages/channels-en.md
@@ -49,5 +49,7 @@ Each supported channel is a plugin that requires [Bun](https://bun.sh). For a ha
         ```
 
-        If Claude Code reports that the plugin is not found in any marketplace, run `/plugin marketplace add anthropics/claude-plugins-official` first and retry the install.
+        If Claude Code reports that the plugin is not found in any marketplace, your marketplace is either missing or outdated. Run `/plugin marketplace update claude-plugins-official` to refresh it, or `/plugin marketplace add anthropics/claude-plugins-official` if you haven't added it before. Then retry the install.
+
+        After installing, run `/reload-plugins` to activate the plugin's configure command.
       </Step>
 
@@ -122,5 +124,7 @@ Each supported channel is a plugin that requires [Bun](https://bun.sh). For a ha
         ```
 
-        If Claude Code reports that the plugin is not found in any marketplace, run `/plugin marketplace add anthropics/claude-plugins-official` first and retry the install.
+        If Claude Code reports that the plugin is not found in any marketplace, your marketplace is either missing or outdated. Run `/plugin marketplace update claude-plugins-official` to refresh it, or `/plugin marketplace add anthropics/claude-plugins-official` if you haven't added it before. Then retry the install.
+
+        After installing, run `/reload-plugins` to activate the plugin's configure command.
       </Step>
 
@@ -186,5 +190,5 @@ To try the fakechat demo, you'll need:
     ```
 
-    If Claude Code reports that the plugin is not found in any marketplace, run `/plugin marketplace add anthropics/claude-plugins-official` first and retry the install.
+    If Claude Code reports that the plugin is not found in any marketplace, your marketplace is either missing or outdated. Run `/plugin marketplace update claude-plugins-official` to refresh it, or `/plugin marketplace add anthropics/claude-plugins-official` if you haven't added it before. Then retry the install.
   </Step>
 
```

</details>

<details>
<summary>env-vars-en.md</summary>

```diff
diff --git a/docs-ja/pages/env-vars-en.md b/docs-ja/pages/env-vars-en.md
index ccd33be..0bdcb34 100644
--- a/docs-ja/pages/env-vars-en.md
+++ b/docs-ja/pages/env-vars-en.md
@@ -44,5 +44,5 @@ Claude Code supports the following environment variables to control its behavior
 | `CLAUDE_CODE_DISABLE_ADAPTIVE_THINKING`        | Set to `1` to disable [adaptive reasoning](/en/model-config#adjust-effort-level) for Opus 4.6 and Sonnet 4.6. When disabled, these models fall back to the fixed thinking budget controlled by `MAX_THINKING_TOKENS`                                                                                                                                                                                                                                                                                                                                                                                             |
 | `CLAUDE_CODE_DISABLE_AUTO_MEMORY`              | Set to `1` to disable [auto memory](/en/memory#auto-memory). Set to `0` to force auto memory on during the gradual rollout. When disabled, Claude does not create or load auto memory files                                                                                                                                                                                                                                                                                                                                                                                                                      |
-| `CLAUDE_CODE_DISABLE_GIT_INSTRUCTIONS`         | Set to `1` to remove built-in commit and PR workflow instructions from Claude's system prompt. Useful when using your own git workflow skills. Takes precedence over the [`includeGitInstructions`](/en/settings#available-settings) setting when set                                                                                                                                                                                                                                                                                                                                                            |
+| `CLAUDE_CODE_DISABLE_GIT_INSTRUCTIONS`         | Set to `1` to remove built-in commit and PR workflow instructions and the git status snapshot from Claude's system prompt. Useful when using your own git workflow skills. Takes precedence over the [`includeGitInstructions`](/en/settings#available-settings) setting when set                                                                                                                                                                                                                                                                                                                                |
 | `CLAUDE_CODE_DISABLE_BACKGROUND_TASKS`         | Set to `1` to disable all background task functionality, including the `run_in_background` parameter on Bash and subagent tools, auto-backgrounding, and the Ctrl+B shortcut                                                                                                                                                                                                                                                                                                                                                                                                                                     |
 | `CLAUDE_CODE_DISABLE_CRON`                     | Set to `1` to disable [scheduled tasks](/en/scheduled-tasks). The `/loop` skill and cron tools become unavailable and any already-scheduled tasks stop firing, including tasks that are already running mid-session                                                                                                                                                                                                                                                                                                                                                                                              |
```

</details>

</details>


<details>
<summary>2026-03-21</summary>

**変更ファイル:**

```
 docs-ja/pages/changelog.md             | 30 ++++++++++++++++++++++++++++++
 docs-ja/pages/channels-en.md           | 29 ++++++++++++++++++++++++++---
 docs-ja/pages/channels-reference-en.md |  6 +++---
 docs-ja/pages/env-vars-en.md           |  4 ++--
 4 files changed, 61 insertions(+), 8 deletions(-)
```

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index 208e49f..4b18ccc 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,34 @@
 # Changelog
 
+## 2.1.81
+
+- Added `--bare` flag for scripted `-p` calls — skips hooks, LSP, plugin sync, and skill directory walks; requires `ANTHROPIC_API_KEY` or an `apiKeyHelper` via `--settings` (OAuth and keychain auth disabled); auto-memory fully disabled
+- Added `--channels` permission relay — channel servers that declare the permission capability can forward tool approval prompts to your phone
+- Fixed multiple concurrent Claude Code sessions requiring repeated re-authentication when one session refreshes its OAuth token
+- Fixed voice mode silently swallowing retry failures and showing a misleading "check your network" message instead of the actual error
+- Fixed voice mode audio not recovering when the server silently drops the WebSocket connection
+- Fixed `CLAUDE_CODE_DISABLE_EXPERIMENTAL_BETAS` not suppressing the structured-outputs beta header, causing 400 errors on proxy gateways forwarding to Vertex/Bedrock
+- Fixed `--channels` bypass for Team/Enterprise orgs with no other managed settings configured
+- Fixed a crash on Node.js 18
+- Fixed unnecessary permission prompts for Bash commands containing dashes in strings
+- Fixed plugin hooks blocking prompt submission when the plugin directory is deleted mid-session
+- Fixed a race condition where background agent task output could hang indefinitely when the task completed between polling intervals
+- Resuming a session that was in a worktree now switches back to that worktree
+- Fixed `/btw` not including pasted text when used during an active response
+- Fixed a race where fast Cmd+Tab followed by paste could beat the clipboard copy under tmux
+- Fixed terminal tab title not updating with an auto-generated session description
+- Fixed invisible hook attachments inflating the message count in transcript mode
+- Fixed Remote Control sessions showing a generic title instead of deriving from the first prompt
+- Fixed `/rename` not syncing the title for Remote Control sessions
+- Fixed Remote Control `/exit` not reliably archiving the session
+- Improved MCP read/search tool calls to collapse into a single "Queried {server}" line (expand with Ctrl+O)
+- Improved `!` bash mode discoverability — Claude now suggests it when you need to run an interactive command
```

</details>

<details>
<summary>channels-en.md</summary>

```diff
diff --git a/docs-ja/pages/channels-en.md b/docs-ja/pages/channels-en.md
index 7c4a580..4f3279d 100644
--- a/docs-ja/pages/channels-en.md
+++ b/docs-ja/pages/channels-en.md
@@ -13,4 +13,6 @@
 A channel is an MCP server that pushes events into your running Claude Code session, so Claude can react to things that happen while you're not at the terminal. Channels can be two-way: Claude reads the event and replies back through the same channel, like a chat bridge. Events only arrive while the session is open, so for an always-on setup you run Claude in a background process or persistent terminal.
 
+Unlike integrations that spawn a fresh cloud session or wait to be polled, the event arrives in the session you already have open: see [how channels compare](#how-channels-compare).
+
 You install a channel as a plugin and configure it with your own credentials. Telegram and Discord are included in the research preview.
 
@@ -23,4 +25,5 @@ This page covers:
 * [Who can push messages](#security): sender allowlists and how you pair
 * [Enable channels for your organization](#enterprise-controls) on Team and Enterprise
+* [How channels compare](#how-channels-compare) to web sessions, Slack, MCP, and Remote Control
 
 To build your own channel, see the [Channels reference](/en/channels-reference).
@@ -45,4 +48,6 @@ Each supported channel is a plugin that requires [Bun](https://bun.sh). For a ha
         /plugin install telegram@claude-plugins-official
         ```
+
+        If Claude Code reports that the plugin is not found in any marketplace, run `/plugin marketplace add anthropics/claude-plugins-official` first and retry the install.
       </Step>
 
@@ -54,5 +59,5 @@ Each supported channel is a plugin that requires [Bun](https://bun.sh). For a ha
         ```
 
-        This saves it to `.claude/channels/telegram/.env` in your project. You can also set `TELEGRAM_BOT_TOKEN` in your shell environment before launching Claude Code.
+        This saves it to `~/.claude/channels/telegram/.env`. You can also set `TELEGRAM_BOT_TOKEN` in your shell environment before launching Claude Code.
       </Step>
```

</details>

<details>
<summary>channels-reference-en.md</summary>

```diff
diff --git a/docs-ja/pages/channels-reference-en.md b/docs-ja/pages/channels-reference-en.md
index e83851a..e1bc59a 100644
--- a/docs-ja/pages/channels-reference-en.md
+++ b/docs-ja/pages/channels-reference-en.md
@@ -116,5 +116,5 @@ This example uses [Bun](https://bun.sh) as the runtime for its built-in HTTP ser
 
   <Step title="Register your server with Claude Code">
-    Add the server to `.mcp.json` so Claude Code knows how to start it. If you're adding it to a project-level `.mcp.json` in the same directory, use a relative path. If you're adding it to your user-level `~/.mcp.json`, use the full absolute path:
+    Add the server to your MCP config so Claude Code knows how to start it. For a project-level `.mcp.json` in the same directory, use a relative path. For user-level config in `~/.claude.json`, use the full absolute path so the server can be found from any project:
 
     ```json title=".mcp.json" theme={null}
@@ -126,5 +126,5 @@ This example uses [Bun](https://bun.sh) as the runtime for its built-in HTTP ser
     ```
 
-    Claude Code reads `.mcp.json` at startup and spawns each server as a subprocess.
+    Claude Code reads your MCP config at startup and spawns each server as a subprocess.
   </Step>
 
@@ -136,5 +136,5 @@ This example uses [Bun](https://bun.sh) as the runtime for its built-in HTTP ser
     ```
 
-    When Claude Code starts, it reads `.mcp.json`, spawns your `webhook.ts` as a subprocess, and the HTTP listener starts automatically on the port you configured (8788 in this example). You don't need to run the server yourself.
+    When Claude Code starts, it reads your MCP config, spawns your `webhook.ts` as a subprocess, and the HTTP listener starts automatically on the port you configured (8788 in this example). You don't need to run the server yourself.
 
     If you see "blocked by org policy," your Team or Enterprise admin needs to [enable channels](/en/channels#enterprise-controls) first.
```

</details>

<details>
<summary>env-vars-en.md</summary>

```diff
diff --git a/docs-ja/pages/env-vars-en.md b/docs-ja/pages/env-vars-en.md
index c033c39..ccd33be 100644
--- a/docs-ja/pages/env-vars-en.md
+++ b/docs-ja/pages/env-vars-en.md
@@ -59,5 +59,5 @@ Claude Code supports the following environment variables to control its behavior
 | `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS`         | Set to `1` to enable [agent teams](/en/agent-teams). Agent teams are experimental and disabled by default                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
 | `CLAUDE_CODE_FILE_READ_MAX_OUTPUT_TOKENS`      | Override the default token limit for file reads. Useful when you need to read larger files in full                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
-| `CLAUDE_CODE_IDE_SKIP_AUTO_INSTALL`            | Skip auto-installation of IDE extensions                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
+| `CLAUDE_CODE_IDE_SKIP_AUTO_INSTALL`            | Skip auto-installation of IDE extensions. Equivalent to setting [`autoInstallIdeExtension`](/en/settings#global-config-settings) to `false`                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
 | `CLAUDE_CODE_MAX_OUTPUT_TOKENS`                | Set the maximum number of output tokens for most requests. Defaults and caps vary by model; see [max output tokens](https://platform.claude.com/docs/en/about-claude/models/overview#latest-models-comparison). Increasing this value reduces the effective context window available before [auto-compaction](/en/costs#reduce-token-usage) triggers.                                                                                                                                                                                                                                                            |
 | `CLAUDE_CODE_NEW_INIT`                         | Set to `true` to make `/init` run an interactive setup flow. The flow asks which files to generate, including CLAUDE.md, skills, and hooks, before exploring the codebase and writing them. Without this variable, `/init` generates a CLAUDE.md automatically without prompting.                                                                                                                                                                                                                                                                                                                                |
@@ -68,5 +68,5 @@ Claude Code supports the following environment variables to control its behavior
 | `CLAUDE_CODE_PLUGIN_SEED_DIR`                  | Path to one or more read-only plugin seed directories, separated by `:` on Unix or `;` on Windows. Use this to bundle a pre-populated plugins directory into a container image. Claude Code registers marketplaces from these directories at startup and uses pre-cached plugins without re-cloning. See [Pre-populate plugins for containers](/en/plugin-marketplaces#pre-populate-plugins-for-containers)                                                                                                                                                                                                      |
 | `CLAUDE_CODE_PROXY_RESOLVES_HOSTS`             | Set to `true` to allow the proxy to perform DNS resolution instead of the caller. Opt-in for environments where the proxy should handle hostname resolution                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
-| `CLAUDE_CODE_SESSIONEND_HOOKS_TIMEOUT_MS`      | Maximum time in milliseconds for [SessionEnd](/en/hooks#sessionend) hooks to complete (default: `1500`). Applies to both session exit and `/clear`. Per-hook `timeout` values are also capped by this budget                                                                                                                                                                                                                                                                                                                                                                                                     |
+| `CLAUDE_CODE_SESSIONEND_HOOKS_TIMEOUT_MS`      | Maximum time in milliseconds for [SessionEnd](/en/hooks#sessionend) hooks to complete (default: `1500`). Applies to session exit, `/clear`, and switching sessions via interactive `/resume`. Per-hook `timeout` values are also capped by this budget                                                                                                                                                                                                                                                                                                                                                           |
 | `CLAUDE_CODE_SHELL`                            | Override automatic shell detection. Useful when your login shell differs from your preferred working shell (for example, `bash` vs `zsh`)                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
 | `CLAUDE_CODE_SHELL_PREFIX`                     | Command prefix to wrap all bash commands (for example, for logging or auditing). Example: `/path/to/logger.sh` will execute `/path/to/logger.sh <command>`                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
```

</details>

</details>


<details>
<summary>2026-03-20</summary>

**変更ファイル:**

```
 docs-ja/pages/changelog.md | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)
```

**新規追加:**


<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index 28b120f..208e49f 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,24 @@
 # Changelog
 
+## 2.1.80
+
+- Added `rate_limits` field to statusline scripts for displaying Claude.ai rate limit usage (5-hour and 7-day windows with `used_percentage` and `resets_at`)
+- Added `source: 'settings'` plugin marketplace source — declare plugin entries inline in settings.json
+- Added CLI tool usage detection to plugin tips, in addition to file pattern matching
+- Added `effort` frontmatter support for skills and slash commands to override the model effort level when invoked
+- Added `--channels` (research preview) — allow MCP servers to push messages into your session
+- Fixed `--resume` dropping parallel tool results — sessions with parallel tool calls now restore all tool_use/tool_result pairs instead of showing `[Tool result missing]` placeholders
+- Fixed voice mode WebSocket failures caused by Cloudflare bot detection on non-browser TLS fingerprints
+- Fixed 400 errors when using fine-grained tool streaming through API proxies, Bedrock, or Vertex
+- Fixed `/remote-control` appearing for gateway and third-party provider deployments where it cannot function
+- Fixed `/sandbox` tab switching not responding to Tab or arrow keys
+- Improved responsiveness of `@` file autocomplete in large git repositories
+- Improved `/effort` to show what auto currently resolves to, matching the status bar indicator
+- Improved `/permissions` — Tab and arrow keys now switch tabs from within a list
+- Improved background tasks panel — left arrow now closes from the list view
+- Simplified plugin install tips to use a single `/plugin install` command instead of a two-step flow
+- Reduced memory usage on startup in large repositories (~80 MB saved on 250k-file repos)
+- Fixed managed settings (`enabledPlugins`, `permissions.defaultMode`, policy-set env vars) not being applied at startup when `remote-settings.json` was cached from a prior session
+
 ## 2.1.79
 
```

</details>

</details>


<details>
<summary>2026-03-19</summary>

**変更ファイル:**

```
 docs-ja/pages/authentication-en.md | 16 +++++++++++++++-
 docs-ja/pages/changelog.md         | 21 +++++++++++++++++++++
 docs-ja/pages/env-vars-en.md       | 12 ++++++++----
 docs-ja/pages/hooks-guide-ja.md    |  1 +
 docs-ja/pages/hooks-ja.md          |  3 ++-
 5 files changed, 47 insertions(+), 6 deletions(-)
```

<details>
<summary>authentication-en.md</summary>

```diff
diff --git a/docs-ja/pages/authentication-en.md b/docs-ja/pages/authentication-en.md
index ae370b0..61799a5 100644
--- a/docs-ja/pages/authentication-en.md
+++ b/docs-ja/pages/authentication-en.md
@@ -112,5 +112,5 @@ For teams using Amazon Bedrock, Google Vertex AI, or Microsoft Foundry:
 Claude Code securely manages your authentication credentials:
 
-* **Storage location**: on macOS, credentials are stored in the encrypted macOS Keychain.
+* **Storage location**: on macOS, credentials are stored in the encrypted macOS Keychain. On Linux and Windows, credentials are stored in `~/.claude/.credentials.json`, or under `$CLAUDE_CONFIG_DIR` if that variable is set. On Linux, the file is written with mode `0600`; on Windows, it inherits the access controls of your user profile directory.
 * **Supported authentication types**: Claude.ai credentials, Claude API credentials, Azure Auth, Bedrock Auth, and Vertex Auth.
 * **Custom credential scripts**: the [`apiKeyHelper`](/en/settings#available-settings) setting can be configured to run a shell script that returns an API key.
@@ -119,2 +119,16 @@ Claude Code securely manages your authentication credentials:
 
 `apiKeyHelper`, `ANTHROPIC_API_KEY`, and `ANTHROPIC_AUTH_TOKEN` apply to terminal CLI sessions only. Claude Desktop and remote sessions use OAuth exclusively and do not call `apiKeyHelper` or read API key environment variables.
+
+### Authentication precedence
+
+When multiple credentials are present, Claude Code chooses one in this order:
+
+1. Cloud provider credentials, when `CLAUDE_CODE_USE_BEDROCK`, `CLAUDE_CODE_USE_VERTEX`, or `CLAUDE_CODE_USE_FOUNDRY` is set. See [third-party integrations](/en/third-party-integrations) for setup.
+2. `ANTHROPIC_AUTH_TOKEN` environment variable. Sent as the `Authorization: Bearer` header. Use this when routing through an [LLM gateway or proxy](/en/llm-gateway) that authenticates with bearer tokens rather than Anthropic API keys.
+3. `ANTHROPIC_API_KEY` environment variable. Sent as the `X-Api-Key` header. Use this for direct Anthropic API access with a key from the [Claude Console](https://platform.claude.com). In interactive mode, you are prompted once to approve or decline the key, and your choice is remembered. To change it later, use the "Use custom API key" toggle in `/config`. In non-interactive mode (`-p`), the key is always used when present.
+4. [`apiKeyHelper`](/en/settings#available-settings) script output. Use this for dynamic or rotating credentials, such as short-lived tokens fetched from a vault.
+5. Subscription OAuth credentials from `/login`. This is the default for Claude Pro, Max, Team, and Enterprise users.
+
+If you have an active Claude subscription but also have `ANTHROPIC_API_KEY` set in your environment, the API key takes precedence once approved. This can cause authentication failures if the key belongs to a disabled or expired organization. Run `unset ANTHROPIC_API_KEY` to fall back to your subscription, and check `/status` to confirm which method is active.
+
+[Claude Code on the Web](/en/claude-code-on-the-web) always uses your subscription credentials. `ANTHROPIC_API_KEY` and `ANTHROPIC_AUTH_TOKEN` in the sandbox environment do not override them.
```

</details>

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index 9f68539..28b120f 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,25 @@
 # Changelog
 
+## 2.1.79
+
+- Added `--console` flag to `claude auth login` for Anthropic Console (API billing) authentication
+- Added "Show turn duration" toggle to the `/config` menu
+- Fixed `claude -p` hanging when spawned as a subprocess without explicit stdin (e.g. Python `subprocess.run`)
+- Fixed Ctrl+C not working in `-p` (print) mode
+- Fixed `/btw` returning the main agent's output instead of answering the side question when triggered during streaming
+- Fixed voice mode not activating correctly on startup when `voiceEnabled: true` is set
+- Fixed left/right arrow tab navigation in `/permissions`
+- Fixed `CLAUDE_CODE_DISABLE_TERMINAL_TITLE` not preventing terminal title from being set on startup
+- Fixed custom status line showing nothing when workspace trust is blocking it
+- Fixed enterprise users being unable to retry on rate limit (429) errors
+- Fixed `SessionEnd` hooks not firing when using interactive `/resume` to switch sessions
+- Improved startup memory usage by ~18MB across all scenarios
+- Improved non-streaming API fallback with a 2-minute per-attempt timeout, preventing sessions from hanging indefinitely
+- `CLAUDE_CODE_PLUGIN_SEED_DIR` now supports multiple seed directories separated by the platform path delimiter (`:` on Unix, `;` on Windows)
+- [VSCode] Added `/remote-control` — bridge your session to claude.ai/code to continue from a browser or phone
+- [VSCode] Session tabs now get AI-generated titles based on your first message
+- [VSCode] Fixed the thinking pill showing "Thinking" instead of "Thought for Ns" after a response completes
+- [VSCode] Fixed missing session diff button when opening sessions from the left sidebar
+
 ## 2.1.78
 
```

</details>

<details>
<summary>env-vars-en.md</summary>

```diff
diff --git a/docs-ja/pages/env-vars-en.md b/docs-ja/pages/env-vars-en.md
index 96c8bc6..c033c39 100644
--- a/docs-ja/pages/env-vars-en.md
+++ b/docs-ja/pages/env-vars-en.md
@@ -11,7 +11,11 @@ Claude Code supports the following environment variables to control its behavior
 | Variable                                       | Purpose                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
 | :--------------------------------------------- | :--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
-| `ANTHROPIC_API_KEY`                            | API key sent as `X-Api-Key` header, typically for the Claude SDK (for interactive usage, run `/login`)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
+| `ANTHROPIC_API_KEY`                            | API key sent as `X-Api-Key` header. When set, this key is used instead of your Claude Pro, Max, Team, or Enterprise subscription even if you are logged in. In non-interactive mode (`-p`), the key is always used when present. In interactive mode, you are prompted to approve the key once before it overrides your subscription. To use your subscription instead, run `unset ANTHROPIC_API_KEY`                                                                                                                                                                                                            |
 | `ANTHROPIC_AUTH_TOKEN`                         | Custom value for the `Authorization` header (the value you set here will be prefixed with `Bearer `)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
+| `ANTHROPIC_BASE_URL`                           | Override the API endpoint to route requests through a proxy or gateway. When set to a non-first-party host, [MCP tool search](/en/mcp#scale-with-mcp-tool-search) is disabled by default. Set `ENABLE_TOOL_SEARCH=true` if your proxy forwards `tool_reference` blocks                                                                                                                                                                                                                                                                                                                                           |
 | `ANTHROPIC_CUSTOM_HEADERS`                     | Custom headers to add to requests (`Name: Value` format, newline-separated for multiple headers)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
+| `ANTHROPIC_CUSTOM_MODEL_OPTION`                | Model ID to add as a custom entry in the `/model` picker. Use this to make a non-standard or gateway-specific model selectable without replacing built-in aliases. See [Model configuration](/en/model-config#add-a-custom-model-option)                                                                                                                                                                                                                                                                                                                                                                         |
+| `ANTHROPIC_CUSTOM_MODEL_OPTION_DESCRIPTION`    | Display description for the custom model entry in the `/model` picker. Defaults to `Custom model (<model-id>)` when not set                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
+| `ANTHROPIC_CUSTOM_MODEL_OPTION_NAME`           | Display name for the custom model entry in the `/model` picker. Defaults to the model ID when not set                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
 | `ANTHROPIC_DEFAULT_HAIKU_MODEL`                | See [Model configuration](/en/model-config#environment-variables)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
 | `ANTHROPIC_DEFAULT_OPUS_MODEL`                 | See [Model configuration](/en/model-config#environment-variables)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
@@ -46,5 +50,5 @@ Claude Code supports the following environment variables to control its behavior
 | `CLAUDE_CODE_DISABLE_FAST_MODE`                | Set to `1` to disable [fast mode](/en/fast-mode)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
 | `CLAUDE_CODE_DISABLE_FEEDBACK_SURVEY`          | Set to `1` to disable the "How is Claude doing?" session quality surveys. Surveys are also disabled when `DISABLE_TELEMETRY` or `CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC` is set. See [Session quality surveys](/en/data-usage#session-quality-surveys)                                                                                                                                                                                                                                                                                                                                                         |
-| `CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC`     | Equivalent of setting `DISABLE_AUTOUPDATER`, `DISABLE_BUG_COMMAND`, `DISABLE_ERROR_REPORTING`, and `DISABLE_TELEMETRY`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
+| `CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC`     | Equivalent of setting `DISABLE_AUTOUPDATER`, `DISABLE_FEEDBACK_COMMAND`, `DISABLE_ERROR_REPORTING`, and `DISABLE_TELEMETRY`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
 | `CLAUDE_CODE_DISABLE_TERMINAL_TITLE`           | Set to `1` to disable automatic terminal title updates based on conversation context                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
 | `CLAUDE_CODE_EFFORT_LEVEL`                     | Set the effort level for supported models. Values: `low`, `medium`, `high`, `max` (Opus 4.6 only), or `auto` to use the model default. Takes precedence over `/effort` and the `effortLevel` setting. See [Adjust effort level](/en/model-config#adjust-effort-level)                                                                                                                                                                                                                                                                                                                                            |
@@ -62,5 +66,5 @@ Claude Code supports the following environment variables to control its behavior
 | `CLAUDE_CODE_PLAN_MODE_REQUIRED`               | Auto-set to `true` on [agent team](/en/agent-teams) teammates that require plan approval. Read-only: set by Claude Code when spawning teammates. See [require plan approval](/en/agent-teams#require-plan-approval-for-teammates)                                                                                                                                                                                                                                                                                                                                                                                |
 | `CLAUDE_CODE_PLUGIN_GIT_TIMEOUT_MS`            | Timeout in milliseconds for git operations when installing or updating plugins (default: 120000). Increase this value for large repositories or slow network connections. See [Git operations time out](/en/plugin-marketplaces#git-operations-time-out)                                                                                                                                                                                                                                                                                                                                                         |
-| `CLAUDE_CODE_PLUGIN_SEED_DIR`                  | Path to a read-only plugin seed directory. Use this to bundle a pre-populated plugins directory into a container image. Claude Code registers marketplaces from this directory at startup and uses pre-cached plugins without re-cloning. See [Pre-populate plugins for containers](/en/plugin-marketplaces#pre-populate-plugins-for-containers)                                                                                                                                                                                                                                                                 |
+| `CLAUDE_CODE_PLUGIN_SEED_DIR`                  | Path to one or more read-only plugin seed directories, separated by `:` on Unix or `;` on Windows. Use this to bundle a pre-populated plugins directory into a container image. Claude Code registers marketplaces from these directories at startup and uses pre-cached plugins without re-cloning. See [Pre-populate plugins for containers](/en/plugin-marketplaces#pre-populate-plugins-for-containers)                                                                                                                                                                                                      |
 | `CLAUDE_CODE_PROXY_RESOLVES_HOSTS`             | Set to `true` to allow the proxy to perform DNS resolution instead of the caller. Opt-in for environments where the proxy should handle hostname resolution                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
```

</details>

<details>
<summary>hooks-guide-ja.md</summary>

```diff
diff --git a/docs-ja/pages/hooks-guide-ja.md b/docs-ja/pages/hooks-guide-ja.md
index 8941fdd..c695d7b 100644
--- a/docs-ja/pages/hooks-guide-ja.md
+++ b/docs-ja/pages/hooks-guide-ja.md
@@ -306,4 +306,5 @@ Hook イベントは Claude Code のライフサイクルの特定のポイン
 | `SubagentStop`       | When a subagent finishes                                                                                                                       |
 | `Stop`               | When Claude finishes responding                                                                                                                |
+| `StopFailure`        | When the turn ends due to an API error. Output and exit code are ignored                                                                       |
 | `TeammateIdle`       | When an [agent team](/en/agent-teams) teammate is about to go idle                                                                             |
 | `TaskCompleted`      | When a task is being marked as completed                                                                                                       |
```

</details>

<details>
<summary>hooks-ja.md</summary>

```diff
diff --git a/docs-ja/pages/hooks-ja.md b/docs-ja/pages/hooks-ja.md
index 55bc144..9e1426b 100644
--- a/docs-ja/pages/hooks-ja.md
+++ b/docs-ja/pages/hooks-ja.md
@@ -19,5 +19,5 @@
 <div style={{maxWidth: "500px", margin: "0 auto"}}>
   <Frame>
-    <img src="https://mintcdn.com/claude-code/lBsitdsGyD9caWJQ/images/hooks-lifecycle.svg?fit=max&auto=format&n=lBsitdsGyD9caWJQ&q=85&s=be3486ef2cf2563eb213b6cbbce93982" alt="SessionStart から agentic ループを経由して SessionEnd までのフックのシーケンスを示すフック ライフサイクル図。WorktreeCreate、WorktreeRemove、InstructionsLoaded はスタンドアロン非同期イベント" width="520" height="1100" data-path="images/hooks-lifecycle.svg" />
+    <img src="https://mintcdn.com/claude-code/2YzYcIR7V1VggfgF/images/hooks-lifecycle.svg?fit=max&auto=format&n=2YzYcIR7V1VggfgF&q=85&s=3004e6c5dc95c4fe7fa3eb40fdc4176c" alt="SessionStart から agentic ループを経由して SessionEnd までのフックのシーケンスを示すフック ライフサイクル図。WorktreeCreate、WorktreeRemove、InstructionsLoaded はスタンドアロン非同期イベント" width="520" height="1100" data-path="images/hooks-lifecycle.svg" />
   </Frame>
 </div>
@@ -37,4 +37,5 @@
 | `SubagentStop`       | When a subagent finishes                                                                                                                       |
 | `Stop`               | When Claude finishes responding                                                                                                                |
+| `StopFailure`        | When the turn ends due to an API error. Output and exit code are ignored                                                                       |
 | `TeammateIdle`       | When an [agent team](/en/agent-teams) teammate is about to go idle                                                                             |
 | `TaskCompleted`      | When a task is being marked as completed                                                                                                       |
```

</details>

</details>


<details>
<summary>2026-03-18</summary>

**変更ファイル:**

```
 docs-ja/pages/authentication-en.md |  3 ++
 docs-ja/pages/changelog.md         | 76 ++++++++++++++++++++++++++++++++++++++
 docs-ja/pages/commands-en.md       |  7 ++--
 docs-ja/pages/env-vars-en.md       |  8 ++--
 4 files changed, 88 insertions(+), 6 deletions(-)
```

**新規追加:**


<details>
<summary>authentication-en.md</summary>

```diff
diff --git a/docs-ja/pages/authentication-en.md b/docs-ja/pages/authentication-en.md
index 3177c4c..ae370b0 100644
--- a/docs-ja/pages/authentication-en.md
+++ b/docs-ja/pages/authentication-en.md
@@ -116,2 +116,5 @@ Claude Code securely manages your authentication credentials:
 * **Custom credential scripts**: the [`apiKeyHelper`](/en/settings#available-settings) setting can be configured to run a shell script that returns an API key.
 * **Refresh intervals**: by default, `apiKeyHelper` is called after 5 minutes or on HTTP 401 response. Set `CLAUDE_CODE_API_KEY_HELPER_TTL_MS` environment variable for custom refresh intervals.
+* **Slow helper notice**: if `apiKeyHelper` takes longer than 10 seconds to return a key, Claude Code displays a warning notice in the prompt bar showing the elapsed time. If you see this notice regularly, check whether your credential script can be optimized.
+
+`apiKeyHelper`, `ANTHROPIC_API_KEY`, and `ANTHROPIC_AUTH_TOKEN` apply to terminal CLI sessions only. Claude Desktop and remote sessions use OAuth exclusively and do not call `apiKeyHelper` or read API key environment variables.
```

</details>

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index 82d5e22..9f68539 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,80 @@
 # Changelog
 
+## 2.1.78
+
+- Added `StopFailure` hook event that fires when the turn ends due to an API error (rate limit, auth failure, etc.)
+- Added `${CLAUDE_PLUGIN_DATA}` variable for plugin persistent state that survives plugin updates; `/plugin uninstall` prompts before deleting it
+- Added `effort`, `maxTurns`, and `disallowedTools` frontmatter support for plugin-shipped agents
+- Terminal notifications (iTerm2/Kitty/Ghostty popups, progress bar) now reach the outer terminal when running inside tmux with `set -g allow-passthrough on`
+- Response text now streams line-by-line as it's generated
+- Fixed `git log HEAD` failing with "ambiguous argument" inside sandboxed Bash on Linux, and stub files polluting `git status` in the working directory
+- Fixed `cc log` and `--resume` silently truncating conversation history on large sessions (>5 MB) that used subagents
+- Fixed infinite loop when API errors triggered stop hooks that re-fed blocking errors to the model
+- Fixed `deny: ["mcp__servername"]` permission rules not removing MCP server tools before sending to the model, allowing it to see and attempt blocked tools
+- Fixed `sandbox.filesystem.allowWrite` not working with absolute paths (previously required `//` prefix)
+- Fixed `/sandbox` Dependencies tab showing Linux prerequisites on macOS instead of macOS-specific info
+- **Security:** Fixed silent sandbox disable when `sandbox.enabled: true` is set but dependencies are missing — now shows a visible startup warning
+- Fixed `.git`, `.claude`, and other protected directories being writable without a prompt in `bypassPermissions` mode
+- Fixed ctrl+u in normal mode scrolling instead of readline kill-line (ctrl+u/ctrl+d half-page scroll moved to transcript mode only)
+- Fixed voice mode modifier-combo push-to-talk keybindings (e.g. ctrl+k) requiring a hold instead of activating immediately
+- Fixed voice mode not working on WSL2 with WSLg (Windows 11); WSL1/Win10 users now get a clear error
+- Fixed `--worktree` flag not loading skills and hooks from the worktree directory
+- Fixed `CLAUDE_CODE_DISABLE_GIT_INSTRUCTIONS` and `includeGitInstructions` setting not suppressing the git status section in the system prompt
+- Fixed Bash tool not finding Homebrew and other PATH-dependent binaries when VS Code is launched from Dock/Spotlight
+- Fixed washed-out Claude orange color in VS Code/Cursor/code-server terminals that don't advertise truecolor support
+- Added `ANTHROPIC_CUSTOM_MODEL_OPTION` env var to add a custom entry to the `/model` picker, with optional `_NAME` and `_DESCRIPTION` suffixed vars for display
```

</details>

<details>
<summary>commands-en.md</summary>

```diff
diff --git a/docs-ja/pages/commands-en.md b/docs-ja/pages/commands-en.md
index 5514c94..5f9c182 100644
--- a/docs-ja/pages/commands-en.md
+++ b/docs-ja/pages/commands-en.md
@@ -24,5 +24,5 @@ In the table below, `<arg>` indicates a required argument and `[arg]` indicates
 | `/config`                                | Open the [Settings](/en/settings) interface to adjust theme, model, [output style](/en/output-styles), and other preferences. Alias: `/settings`                                                                                                                                                                                                        |
 | `/context`                               | Visualize current context usage as a colored grid. Shows optimization suggestions for context-heavy tools, memory bloat, and capacity warnings                                                                                                                                                                                                          |
-| `/copy`                                  | Copy the last assistant response to clipboard. When code blocks are present, shows an interactive picker to select individual blocks or the full response                                                                                                                                                                                               |
+| `/copy [N]`                              | Copy the last assistant response to clipboard. Pass a number `N` to copy the Nth-latest response: `/copy 2` copies the second-to-last. When code blocks are present, shows an interactive picker to select individual blocks or the full response                                                                                                       |
 | `/cost`                                  | Show token usage statistics. See [cost tracking guide](/en/costs#using-the-cost-command) for subscription-specific details                                                                                                                                                                                                                              |
 | `/desktop`                               | Continue the current session in the Claude Code Desktop app. macOS and Windows only. Alias: `/app`                                                                                                                                                                                                                                                      |
@@ -35,9 +35,9 @@ In the table below, `<arg>` indicates a required argument and `[arg]` indicates
 | `/fast [on\|off]`                        | Toggle [fast mode](/en/fast-mode) on or off                                                                                                                                                                                                                                                                                                             |
 | `/feedback [report]`                     | Submit feedback about Claude Code. Alias: `/bug`                                                                                                                                                                                                                                                                                                        |
-| `/fork [name]`                           | Create a fork of the current conversation at this point                                                                                                                                                                                                                                                                                                 |
+| `/branch [name]`                         | Create a branch of the current conversation at this point. Alias: `/fork`                                                                                                                                                                                                                                                                               |
 | `/help`                                  | Show help and available commands                                                                                                                                                                                                                                                                                                                        |
 | `/hooks`                                 | View [hook](/en/hooks) configurations for tool events                                                                                                                                                                                                                                                                                                   |
 | `/ide`                                   | Manage IDE integrations and show status                                                                                                                                                                                                                                                                                                                 |
-| `/init`                                  | Initialize project with `CLAUDE.md` guide                                                                                                                                                                                                                                                                                                               |
+| `/init`                                  | Initialize project with a `CLAUDE.md` guide. Set `CLAUDE_CODE_NEW_INIT=true` for an interactive flow that also walks through skills, hooks, and personal memory files                                                                                                                                                                                   |
 | `/insights`                              | Generate a report analyzing your Claude Code sessions, including project areas, interaction patterns, and friction points                                                                                                                                                                                                                               |
 | `/install-github-app`                    | Set up the [Claude GitHub Actions](/en/github-actions) app for a repository. Walks you through selecting a repo and configuring the integration                                                                                                                                                                                                         |
@@ -77,4 +77,5 @@ In the table below, `<arg>` indicates a required argument and `[arg]` indicates
 | `/usage`                                 | Show plan usage limits and rate limit status                                                                                                                                                                                                                                                                                                            |
 | `/vim`                                   | Toggle between Vim and Normal editing modes                                                                                                                                                                                                                                                                                                             |
+| `/voice`                                 | Toggle push-to-talk [voice dictation](/en/voice-dictation). Requires a Claude.ai account                                                                                                                                                                                                                                                                |
 
 ## MCP prompts
```

</details>

<details>
<summary>env-vars-en.md</summary>

```diff
diff --git a/docs-ja/pages/env-vars-en.md b/docs-ja/pages/env-vars-en.md
index ef104b3..96c8bc6 100644
--- a/docs-ja/pages/env-vars-en.md
+++ b/docs-ja/pages/env-vars-en.md
@@ -43,5 +43,5 @@ Claude Code supports the following environment variables to control its behavior
 | `CLAUDE_CODE_DISABLE_BACKGROUND_TASKS`         | Set to `1` to disable all background task functionality, including the `run_in_background` parameter on Bash and subagent tools, auto-backgrounding, and the Ctrl+B shortcut                                                                                                                                                                                                                                                                                                                                                                                                                                     |
 | `CLAUDE_CODE_DISABLE_CRON`                     | Set to `1` to disable [scheduled tasks](/en/scheduled-tasks). The `/loop` skill and cron tools become unavailable and any already-scheduled tasks stop firing, including tasks that are already running mid-session                                                                                                                                                                                                                                                                                                                                                                                              |
-| `CLAUDE_CODE_DISABLE_EXPERIMENTAL_BETAS`       | Set to `1` to disable Anthropic API-specific `anthropic-beta` headers. Use this if experiencing issues like "Unexpected value(s) for the `anthropic-beta` header" when using an LLM gateway with third-party providers                                                                                                                                                                                                                                                                                                                                                                                           |
+| `CLAUDE_CODE_DISABLE_EXPERIMENTAL_BETAS`       | Set to `1` to strip Anthropic-specific `anthropic-beta` request headers and beta tool-schema fields (such as `defer_loading` and `eager_input_streaming`) from API requests. Use this when a proxy gateway rejects requests with errors like "Unexpected value(s) for the `anthropic-beta` header" or "Extra inputs are not permitted". Standard fields (`name`, `description`, `input_schema`, `cache_control`) are preserved.                                                                                                                                                                                  |
 | `CLAUDE_CODE_DISABLE_FAST_MODE`                | Set to `1` to disable [fast mode](/en/fast-mode)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
 | `CLAUDE_CODE_DISABLE_FEEDBACK_SURVEY`          | Set to `1` to disable the "How is Claude doing?" session quality surveys. Surveys are also disabled when `DISABLE_TELEMETRY` or `CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC` is set. See [Session quality surveys](/en/data-usage#session-quality-surveys)                                                                                                                                                                                                                                                                                                                                                         |
@@ -56,9 +56,11 @@ Claude Code supports the following environment variables to control its behavior
 | `CLAUDE_CODE_FILE_READ_MAX_OUTPUT_TOKENS`      | Override the default token limit for file reads. Useful when you need to read larger files in full                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
 | `CLAUDE_CODE_IDE_SKIP_AUTO_INSTALL`            | Skip auto-installation of IDE extensions                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
-| `CLAUDE_CODE_MAX_OUTPUT_TOKENS`                | Set the maximum number of output tokens for most requests. Default: 32,000. Maximum: 64,000. Increasing this value reduces the effective context window available before [auto-compaction](/en/costs#reduce-token-usage) triggers.                                                                                                                                                                                                                                                                                                                                                                               |
+| `CLAUDE_CODE_MAX_OUTPUT_TOKENS`                | Set the maximum number of output tokens for most requests. Defaults and caps vary by model; see [max output tokens](https://platform.claude.com/docs/en/about-claude/models/overview#latest-models-comparison). Increasing this value reduces the effective context window available before [auto-compaction](/en/costs#reduce-token-usage) triggers.                                                                                                                                                                                                                                                            |
+| `CLAUDE_CODE_NEW_INIT`                         | Set to `true` to make `/init` run an interactive setup flow. The flow asks which files to generate, including CLAUDE.md, skills, and hooks, before exploring the codebase and writing them. Without this variable, `/init` generates a CLAUDE.md automatically without prompting.                                                                                                                                                                                                                                                                                                                                |
 | `CLAUDE_CODE_ORGANIZATION_UUID`                | Organization UUID for the authenticated user. Used by SDK callers to provide account information synchronously. Requires `CLAUDE_CODE_ACCOUNT_UUID` and `CLAUDE_CODE_USER_EMAIL` to also be set                                                                                                                                                                                                                                                                                                                                                                                                                  |
 | `CLAUDE_CODE_OTEL_HEADERS_HELPER_DEBOUNCE_MS`  | Interval for refreshing dynamic OpenTelemetry headers in milliseconds (default: 1740000 / 29 minutes). See [Dynamic headers](/en/monitoring-usage#dynamic-headers)                                                                                                                                                                                                                                                                                                                                                                                                                                               |
 | `CLAUDE_CODE_PLAN_MODE_REQUIRED`               | Auto-set to `true` on [agent team](/en/agent-teams) teammates that require plan approval. Read-only: set by Claude Code when spawning teammates. See [require plan approval](/en/agent-teams#require-plan-approval-for-teammates)                                                                                                                                                                                                                                                                                                                                                                                |
 | `CLAUDE_CODE_PLUGIN_GIT_TIMEOUT_MS`            | Timeout in milliseconds for git operations when installing or updating plugins (default: 120000). Increase this value for large repositories or slow network connections. See [Git operations time out](/en/plugin-marketplaces#git-operations-time-out)                                                                                                                                                                                                                                                                                                                                                         |
+| `CLAUDE_CODE_PLUGIN_SEED_DIR`                  | Path to a read-only plugin seed directory. Use this to bundle a pre-populated plugins directory into a container image. Claude Code registers marketplaces from this directory at startup and uses pre-cached plugins without re-cloning. See [Pre-populate plugins for containers](/en/plugin-marketplaces#pre-populate-plugins-for-containers)                                                                                                                                                                                                                                                                 |
 | `CLAUDE_CODE_PROXY_RESOLVES_HOSTS`             | Set to `true` to allow the proxy to perform DNS resolution instead of the caller. Opt-in for environments where the proxy should handle hostname resolution                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
 | `CLAUDE_CODE_SESSIONEND_HOOKS_TIMEOUT_MS`      | Maximum time in milliseconds for [SessionEnd](/en/hooks#sessionend) hooks to complete (default: `1500`). Applies to both session exit and `/clear`. Per-hook `timeout` values are also capped by this budget                                                                                                                                                                                                                                                                                                                                                                                                     |
@@ -97,5 +99,5 @@ Claude Code supports the following environment variables to control its behavior
 | `IS_DEMO`                                      | Set to `true` to enable demo mode: hides email and organization from the UI, skips onboarding, and hides internal commands. Useful for streaming or recording sessions                                                                                                                                                                                                                                                                                                                                                                                                                                           |
 | `MAX_MCP_OUTPUT_TOKENS`                        | Maximum number of tokens allowed in MCP tool responses. Claude Code displays a warning when output exceeds 10,000 tokens (default: 25000)                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
-| `MAX_THINKING_TOKENS`                          | Override the [extended thinking](https://platform.claude.com/docs/en/build-with-claude/extended-thinking) token budget. Thinking is enabled at max budget (31,999 tokens) by default. Use this to limit the budget (for example, `MAX_THINKING_TOKENS=10000`) or disable thinking entirely (`MAX_THINKING_TOKENS=0`). For Opus 4.6, thinking depth is controlled by [effort level](/en/model-config#adjust-effort-level) instead, and this variable is ignored unless set to `0` to disable thinking.                                                                                                            |
+| `MAX_THINKING_TOKENS`                          | Override the [extended thinking](https://platform.claude.com/docs/en/build-with-claude/extended-thinking) token budget. The ceiling is the model's [max output tokens](https://platform.claude.com/docs/en/about-claude/models/overview#latest-models-comparison) minus one. Set to `0` to disable thinking entirely. On models with adaptive reasoning (Opus 4.6, Sonnet 4.6), the budget is ignored unless adaptive reasoning is disabled via `CLAUDE_CODE_DISABLE_ADAPTIVE_THINKING`                                                                                                                          |
 | `MCP_CLIENT_SECRET`                            | OAuth client secret for MCP servers that require [pre-configured credentials](/en/mcp#use-pre-configured-oauth-credentials). Avoids the interactive prompt when adding a server with `--client-secret`                                                                                                                                                                                                                                                                                                                                                                                                           |
```

</details>

</details>


<details>
<summary>2026-03-17</summary>

**変更ファイル:**

```
 docs-ja/pages/commands-en.md | 2 +-
 docs-ja/pages/env-vars-en.md | 4 +++-
 2 files changed, 4 insertions(+), 2 deletions(-)
```

<details>
<summary>commands-en.md</summary>

```diff
diff --git a/docs-ja/pages/commands-en.md b/docs-ja/pages/commands-en.md
index 6ab1c2e..5514c94 100644
--- a/docs-ja/pages/commands-en.md
+++ b/docs-ja/pages/commands-en.md
@@ -57,5 +57,5 @@ In the table below, `<arg>` indicates a required argument and `[arg]` indicates
 | `/privacy-settings`                      | View and update your privacy settings. Only available for Pro and Max plan subscribers                                                                                                                                                                                                                                                                  |
 | `/release-notes`                         | View the full changelog, with the most recent version closest to your prompt                                                                                                                                                                                                                                                                            |
-| `/reload-plugins`                        | Reload all active [plugins](/en/plugins) to apply pending changes without restarting. Reports what was loaded and notes any changes that require a restart                                                                                                                                                                                              |
+| `/reload-plugins`                        | Reload all active [plugins](/en/plugins) to apply pending changes without restarting. Reports counts for each reloaded component and flags any load errors                                                                                                                                                                                              |
 | `/remote-control`                        | Make this session available for [remote control](/en/remote-control) from claude.ai. Alias: `/rc`                                                                                                                                                                                                                                                       |
 | `/remote-env`                            | Configure the default remote environment for [web sessions started with `--remote`](/en/claude-code-on-the-web#environment-configuration)                                                                                                                                                                                                               |
```

</details>

<details>
<summary>env-vars-en.md</summary>

```diff
diff --git a/docs-ja/pages/env-vars-en.md b/docs-ja/pages/env-vars-en.md
index 147b8b4..ef104b3 100644
--- a/docs-ja/pages/env-vars-en.md
+++ b/docs-ja/pages/env-vars-en.md
@@ -27,4 +27,5 @@ Claude Code supports the following environment variables to control its behavior
 | `BASH_MAX_OUTPUT_LENGTH`                       | Maximum number of characters in bash outputs before they are middle-truncated                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
 | `BASH_MAX_TIMEOUT_MS`                          | Maximum timeout the model can set for long-running bash commands                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
+| `CLAUDECODE`                                   | Set to `1` in shell environments Claude Code spawns (Bash tool, tmux sessions). Not set in [hooks](/en/hooks) or [status line](/en/statusline) commands. Use to detect when a script is running inside a shell spawned by Claude Code                                                                                                                                                                                                                                                                                                                                                                            |
 | `CLAUDE_AUTOCOMPACT_PCT_OVERRIDE`              | Set the percentage of context capacity (1-100) at which auto-compaction triggers. By default, auto-compaction triggers at approximately 95% capacity. Use lower values like `50` to compact earlier. Values above the default threshold have no effect. Applies to both main conversations and subagents. This percentage aligns with the `context_window.used_percentage` field available in [status line](/en/statusline)                                                                                                                                                                                      |
 | `CLAUDE_BASH_MAINTAIN_PROJECT_WORKING_DIR`     | Return to the original working directory after each Bash command                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
@@ -44,5 +45,5 @@ Claude Code supports the following environment variables to control its behavior
 | `CLAUDE_CODE_DISABLE_EXPERIMENTAL_BETAS`       | Set to `1` to disable Anthropic API-specific `anthropic-beta` headers. Use this if experiencing issues like "Unexpected value(s) for the `anthropic-beta` header" when using an LLM gateway with third-party providers                                                                                                                                                                                                                                                                                                                                                                                           |
 | `CLAUDE_CODE_DISABLE_FAST_MODE`                | Set to `1` to disable [fast mode](/en/fast-mode)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
-| `CLAUDE_CODE_DISABLE_FEEDBACK_SURVEY`          | Set to `1` to disable the "How is Claude doing?" session quality surveys. Also disabled when using third-party providers or when telemetry is disabled. See [Session quality surveys](/en/data-usage#session-quality-surveys)                                                                                                                                                                                                                                                                                                                                                                                    |
+| `CLAUDE_CODE_DISABLE_FEEDBACK_SURVEY`          | Set to `1` to disable the "How is Claude doing?" session quality surveys. Surveys are also disabled when `DISABLE_TELEMETRY` or `CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC` is set. See [Session quality surveys](/en/data-usage#session-quality-surveys)                                                                                                                                                                                                                                                                                                                                                         |
 | `CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC`     | Equivalent of setting `DISABLE_AUTOUPDATER`, `DISABLE_BUG_COMMAND`, `DISABLE_ERROR_REPORTING`, and `DISABLE_TELEMETRY`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
 | `CLAUDE_CODE_DISABLE_TERMINAL_TITLE`           | Set to `1` to disable automatic terminal title updates based on conversation context                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
@@ -66,4 +67,5 @@ Claude Code supports the following environment variables to control its behavior
 | `CLAUDE_CODE_SIMPLE`                           | Set to `1` to run with a minimal system prompt and only the Bash, file read, and file edit tools. Disables MCP tools, attachments, hooks, and CLAUDE.md files                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
 | `CLAUDE_CODE_SKIP_BEDROCK_AUTH`                | Skip AWS authentication for Bedrock (for example, when using an LLM gateway)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
+| `CLAUDE_CODE_SKIP_FAST_MODE_NETWORK_ERRORS`    | Set to `1` to allow [fast mode](/en/fast-mode) when the organization status check fails due to a network error. Useful when a corporate proxy blocks the status endpoint. The API still enforces organization-level disable separately                                                                                                                                                                                                                                                                                                                                                                           |
 | `CLAUDE_CODE_SKIP_FOUNDRY_AUTH`                | Skip Azure authentication for Microsoft Foundry (for example, when using an LLM gateway)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
 | `CLAUDE_CODE_SKIP_VERTEX_AUTH`                 | Skip Google authentication for Vertex (for example, when using an LLM gateway)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
```

</details>

</details>


<details>
<summary>2026-03-15</summary>

**変更ファイル:**

```
 docs-ja/pages/changelog.md      |  38 ++++++++++++
 docs-ja/pages/commands-en.md    | 127 ++++++++++++++++++++--------------------
 docs-ja/pages/env-vars-en.md    |   2 +-
 docs-ja/pages/hooks-guide-ja.md |   3 +
 docs-ja/pages/hooks-ja.md       |   5 +-
 5 files changed, 110 insertions(+), 65 deletions(-)
```

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index d39b179..82d5e22 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,42 @@
 # Changelog
 
+## 2.1.76
+
+- Added MCP elicitation support — MCP servers can now request structured input mid-task via an interactive dialog (form fields or browser URL)
+- Added new `Elicitation` and `ElicitationResult` hooks to intercept and override responses before they're sent back
+- Added `-n` / `--name <name>` CLI flag to set a display name for the session at startup
+- Added `worktree.sparsePaths` setting for `claude --worktree` in large monorepos to check out only the directories you need via git sparse-checkout
+- Added `PostCompact` hook that fires after compaction completes
+- Added `/effort` slash command to set model effort level
+- Added session quality survey — enterprise admins can configure the sample rate via the `feedbackSurveyRate` setting
+- Fixed deferred tools (loaded via `ToolSearch`) losing their input schemas after conversation compaction, causing array and number parameters to be rejected with type errors
+- Fixed slash commands showing "Unknown skill"
+- Fixed plan mode asking for re-approval after the plan was already accepted
+- Fixed voice mode swallowing keypresses while a permission dialog or plan editor was open
+- Fixed `/voice` not working on Windows when installed via npm
+- Fixed spurious "Context limit reached" when invoking a skill with `model:` frontmatter on a 1M-context session
+- Fixed "adaptive thinking is not supported on this model" error when using non-standard model strings
+- Fixed `Bash(cmd:*)` permission rules not matching when a quoted argument contains `#`
+- Fixed "don't ask again" in the Bash permission dialog showing the full raw command for pipes and compound commands
+- Fixed auto-compaction retrying indefinitely after consecutive failures — a circuit breaker now stops after 3 attempts
+- Fixed MCP reconnect spinner persisting after successful reconnection
+- Fixed LSP plugins not registering servers when the LSP Manager initialized before marketplaces were reconciled
+- Fixed clipboard copying in tmux over SSH — now attempts both direct terminal write and tmux clipboard integration
+- Fixed `/export` showing only the filename instead of the full file path in the success message
```

</details>

<details>
<summary>commands-en.md</summary>

```diff
diff --git a/docs-ja/pages/commands-en.md b/docs-ja/pages/commands-en.md
index 3e4b9bc..6ab1c2e 100644
--- a/docs-ja/pages/commands-en.md
+++ b/docs-ja/pages/commands-en.md
@@ -13,67 +13,68 @@ Claude Code also includes [bundled skills](/en/skills#bundled-skills) like `/sim
 In the table below, `<arg>` indicates a required argument and `[arg]` indicates an optional one.
 
-| Command                   | Purpose                                                                                                                                                                                                                                 |
-| :------------------------ | :-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
-| `/add-dir <path>`         | Add a new working directory to the current session                                                                                                                                                                                      |
-| `/agents`                 | Manage [agent](/en/sub-agents) configurations                                                                                                                                                                                           |
-| `/btw <question>`         | Ask a quick [side question](/en/interactive-mode#side-questions-with-btw) without adding to the conversation                                                                                                                            |
-| `/chrome`                 | Configure [Claude in Chrome](/en/chrome) settings                                                                                                                                                                                       |
-| `/clear`                  | Clear conversation history and free up context. Aliases: `/reset`, `/new`                                                                                                                                                               |
-| `/color [color\|default]` | Set the prompt bar color for the current session. Available colors: `red`, `blue`, `green`, `yellow`, `purple`, `orange`, `pink`, `cyan`. Use `default` to reset                                                                        |
-| `/compact [instructions]` | Compact conversation with optional focus instructions                                                                                                                                                                                   |
-| `/config`                 | Open the [Settings](/en/settings) interface to adjust theme, model, [output style](/en/output-styles), and other preferences. Alias: `/settings`                                                                                        |
-| `/context`                | Visualize current context usage as a colored grid. Shows optimization suggestions for context-heavy tools, memory bloat, and capacity warnings                                                                                          |
-| `/copy`                   | Copy the last assistant response to clipboard. When code blocks are present, shows an interactive picker to select individual blocks or the full response                                                                               |
-| `/cost`                   | Show token usage statistics. See [cost tracking guide](/en/costs#using-the-cost-command) for subscription-specific details                                                                                                              |
-| `/desktop`                | Continue the current session in the Claude Code Desktop app. macOS and Windows only. Alias: `/app`                                                                                                                                      |
-| `/diff`                   | Open an interactive diff viewer showing uncommitted changes and per-turn diffs. Use left/right arrows to switch between the current git diff and individual Claude turns, and up/down to browse files                                   |
-| `/doctor`                 | Diagnose and verify your Claude Code installation and settings                                                                                                                                                                          |
-| `/exit`                   | Exit the CLI. Alias: `/quit`                                                                                                                                                                                                            |
-| `/export [filename]`      | Export the current conversation as plain text. With a filename, writes directly to that file. Without, opens a dialog to copy to clipboard or save to a file                                                                            |
-| `/extra-usage`            | Configure extra usage to keep working when rate limits are hit                                                                                                                                                                          |
-| `/fast [on\|off]`         | Toggle [fast mode](/en/fast-mode) on or off                                                                                                                                                                                             |
-| `/feedback [report]`      | Submit feedback about Claude Code. Alias: `/bug`                                                                                                                                                                                        |
-| `/fork [name]`            | Create a fork of the current conversation at this point                                                                                                                                                                                 |
-| `/help`                   | Show help and available commands                                                                                                                                                                                                        |
```

</details>

<details>
<summary>env-vars-en.md</summary>

```diff
diff --git a/docs-ja/pages/env-vars-en.md b/docs-ja/pages/env-vars-en.md
index d109653..147b8b4 100644
--- a/docs-ja/pages/env-vars-en.md
+++ b/docs-ja/pages/env-vars-en.md
@@ -47,5 +47,5 @@ Claude Code supports the following environment variables to control its behavior
 | `CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC`     | Equivalent of setting `DISABLE_AUTOUPDATER`, `DISABLE_BUG_COMMAND`, `DISABLE_ERROR_REPORTING`, and `DISABLE_TELEMETRY`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
 | `CLAUDE_CODE_DISABLE_TERMINAL_TITLE`           | Set to `1` to disable automatic terminal title updates based on conversation context                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
-| `CLAUDE_CODE_EFFORT_LEVEL`                     | Set the effort level for supported models. Values: `low`, `medium`, `high`. Lower effort is faster and cheaper, higher effort provides deeper reasoning. Supported on Opus 4.6 and Sonnet 4.6. See [Adjust effort level](/en/model-config#adjust-effort-level)                                                                                                                                                                                                                                                                                                                                                   |
+| `CLAUDE_CODE_EFFORT_LEVEL`                     | Set the effort level for supported models. Values: `low`, `medium`, `high`, `max` (Opus 4.6 only), or `auto` to use the model default. Takes precedence over `/effort` and the `effortLevel` setting. See [Adjust effort level](/en/model-config#adjust-effort-level)                                                                                                                                                                                                                                                                                                                                            |
 | `CLAUDE_CODE_ENABLE_PROMPT_SUGGESTION`         | Set to `false` to disable prompt suggestions (the "Prompt suggestions" toggle in `/config`). These are the grayed-out predictions that appear in your prompt input after Claude responds. See [Prompt suggestions](/en/interactive-mode#prompt-suggestions)                                                                                                                                                                                                                                                                                                                                                      |
 | `CLAUDE_CODE_ENABLE_TASKS`                     | Set to `true` to enable the task tracking system in non-interactive mode (the `-p` flag). Tasks are on by default in interactive mode. See [Task list](/en/interactive-mode#task-list)                                                                                                                                                                                                                                                                                                                                                                                                                           |
```

</details>

<details>
<summary>hooks-guide-ja.md</summary>

```diff
diff --git a/docs-ja/pages/hooks-guide-ja.md b/docs-ja/pages/hooks-guide-ja.md
index 1f2c61f..8941fdd 100644
--- a/docs-ja/pages/hooks-guide-ja.md
+++ b/docs-ja/pages/hooks-guide-ja.md
@@ -313,4 +313,7 @@ Hook イベントは Claude Code のライフサイクルの特定のポイン
 | `WorktreeRemove`     | When a worktree is being removed, either at session exit or when a subagent finishes                                                           |
 | `PreCompact`         | Before context compaction                                                                                                                      |
+| `PostCompact`        | After context compaction completes                                                                                                             |
+| `Elicitation`        | When an MCP server requests user input during a tool call                                                                                      |
+| `ElicitationResult`  | After a user responds to an MCP elicitation, before the response is sent back to the server                                                    |
 | `SessionEnd`         | When a session terminates                                                                                                                      |
 
```

</details>

<details>
<summary>hooks-ja.md</summary>

```diff
diff --git a/docs-ja/pages/hooks-ja.md b/docs-ja/pages/hooks-ja.md
index c5fbb95..55bc144 100644
--- a/docs-ja/pages/hooks-ja.md
+++ b/docs-ja/pages/hooks-ja.md
@@ -19,5 +19,5 @@
 <div style={{maxWidth: "500px", margin: "0 auto"}}>
   <Frame>
-    <img src="https://mintcdn.com/claude-code/c5r9_6tjPMzFdDDT/images/hooks-lifecycle.svg?fit=max&auto=format&n=c5r9_6tjPMzFdDDT&q=85&s=996ed41d03e106ab6bc9a8fdd4ebcf26" alt="SessionStart から agentic ループを経由して SessionEnd までのフックのシーケンスを示すフック ライフサイクル図。WorktreeCreate、WorktreeRemove、InstructionsLoaded はスタンドアロン非同期イベント" width="520" height="1020" data-path="images/hooks-lifecycle.svg" />
+    <img src="https://mintcdn.com/claude-code/lBsitdsGyD9caWJQ/images/hooks-lifecycle.svg?fit=max&auto=format&n=lBsitdsGyD9caWJQ&q=85&s=be3486ef2cf2563eb213b6cbbce93982" alt="SessionStart から agentic ループを経由して SessionEnd までのフックのシーケンスを示すフック ライフサイクル図。WorktreeCreate、WorktreeRemove、InstructionsLoaded はスタンドアロン非同期イベント" width="520" height="1100" data-path="images/hooks-lifecycle.svg" />
   </Frame>
 </div>
@@ -44,4 +44,7 @@
 | `WorktreeRemove`     | When a worktree is being removed, either at session exit or when a subagent finishes                                                           |
 | `PreCompact`         | Before context compaction                                                                                                                      |
+| `PostCompact`        | After context compaction completes                                                                                                             |
+| `Elicitation`        | When an MCP server requests user input during a tool call                                                                                      |
+| `ElicitationResult`  | After a user responds to an MCP elicitation, before the response is sent back to the server                                                    |
 | `SessionEnd`         | When a session terminates                                                                                                                      |
 
```

</details>

</details>


<details>
<summary>2026-03-14</summary>

**変更ファイル:**

```
 docs-ja/pages/authentication-en.md |  6 +++---
 docs-ja/pages/changelog.md         | 22 ++++++++++++++++++++++
 2 files changed, 25 insertions(+), 3 deletions(-)
```

**新規追加:**


<details>
<summary>authentication-en.md</summary>

```diff
diff --git a/docs-ja/pages/authentication-en.md b/docs-ja/pages/authentication-en.md
index 25b933c..3177c4c 100644
--- a/docs-ja/pages/authentication-en.md
+++ b/docs-ja/pages/authentication-en.md
@@ -17,5 +17,5 @@ If the browser doesn't open automatically, press `c` to copy the login URL to yo
 You can authenticate with any of these account types:
 
-* **Claude Pro or Max subscription**: log in with your Claude.ai account. Subscribe at [claude.com/pricing](https://claude.com/pricing).
+* **Claude Pro or Max subscription**: log in with your Claude.ai account. Subscribe at [claude.com/pricing](https://claude.com/pricing?utm_source=claude_code\&utm_medium=docs\&utm_content=authentication_pro_max).
 * **Claude for Teams or Enterprise**: log in with the Claude.ai account your team admin invited you to.
 * **Claude Console**: log in with your Console credentials. Your admin must have [invited you](#claude-console-authentication) first.
@@ -38,5 +38,5 @@ For teams and organizations, you can configure Claude Code access in one of thes
 ### Claude for Teams or Enterprise
 
-[Claude for Teams](https://claude.com/pricing#team-&-enterprise) and [Claude for Enterprise](https://anthropic.com/contact-sales) provide the best experience for organizations using Claude Code. Team members get access to both Claude Code and Claude on the web with centralized billing and team management.
+[Claude for Teams](https://claude.com/pricing?utm_source=claude_code\&utm_medium=docs\&utm_content=authentication_teams#team-&-enterprise) and [Claude for Enterprise](https://anthropic.com/contact-sales?utm_source=claude_code\&utm_medium=docs\&utm_content=authentication_enterprise) provide the best experience for organizations using Claude Code. Team members get access to both Claude Code and Claude on the web with centralized billing and team management.
 
 * **Claude for Teams**: self-service plan with collaboration features, admin tools, and billing management. Best for smaller teams.
@@ -45,5 +45,5 @@ For teams and organizations, you can configure Claude Code access in one of thes
 <Steps>
   <Step title="Subscribe">
-    Subscribe to [Claude for Teams](https://claude.com/pricing#team-&-enterprise) or contact sales for [Claude for Enterprise](https://anthropic.com/contact-sales).
+    Subscribe to [Claude for Teams](https://claude.com/pricing?utm_source=claude_code\&utm_medium=docs\&utm_content=authentication_teams_step#team-&-enterprise) or contact sales for [Claude for Enterprise](https://anthropic.com/contact-sales?utm_source=claude_code\&utm_medium=docs\&utm_content=authentication_enterprise_step).
   </Step>
 
```

</details>

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index f230235..d39b179 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,26 @@
 # Changelog
 
+## 2.1.75
+
+- Added 1M context window for Opus 4.6 by default for Max, Team, and Enterprise plans (previously required extra usage)
+- Added `/color` command for all users to set a prompt-bar color for your session
+- Added session name display on the prompt bar when using `/rename`
+- Added last-modified timestamps to memory files, helping Claude reason about which memories are fresh vs. stale
+- Added hook source display (settings/plugin/skill) in permission prompts when a hook requires confirmation
+- Fixed voice mode not activating correctly on fresh installs without toggling `/voice` twice
+- Fixed the Claude Code header not updating the displayed model name after switching models with `/model` or Option+P
+- Fixed session crash when an attachment message computation returns undefined values
+- Fixed Bash tool mangling `!` in piped commands (e.g., `jq 'select(.x != .y)'` now works correctly)
+- Fixed managed-disabled plugins showing up in the `/plugin` Installed tab — plugins force-disabled by your organization are now hidden
+- Fixed token estimation over-counting for thinking and `tool_use` blocks, preventing premature context compaction
+- Fixed corrupted marketplace config path handling
+- Fixed `/resume` losing session names after resuming a forked or continued session
+- Fixed Esc not closing the `/status` dialog after visiting the Config tab
+- Fixed input handling when accepting or rejecting a plan
+- Fixed footer hint in agent teams showing "↓ to expand" instead of the correct "shift + ↓ to expand"
+- Improved startup performance on macOS non-MDM machines by skipping unnecessary subprocess spawns
+- Suppressed async hook completion messages by default (visible with `--verbose` or transcript mode)
+- Breaking change: Removed deprecated Windows managed settings fallback at `C:\ProgramData\ClaudeCode\managed-settings.json` — use `C:\Program Files\ClaudeCode\managed-settings.json`
+
 ## 2.1.74
```

</details>

</details>


<details>
<summary>2026-03-13</summary>

**変更ファイル:**

```
 docs-ja/pages/agent-teams-ja.md             | 278 +++++++-------
 docs-ja/pages/amazon-bedrock-ja.md          | 112 +++---
 docs-ja/pages/best-practices-ja.md          | 171 ++++-----
 docs-ja/pages/changelog.md                  |  20 +
 docs-ja/pages/claude-code-on-the-web-ja.md  | 174 +++++----
 docs-ja/pages/cli-reference-ja.md           | 158 ++++----
 docs-ja/pages/code-review-en.md             | 168 ---------
 docs-ja/pages/common-workflows-ja.md        | 303 +++++++--------
 docs-ja/pages/data-usage-ja.md              |   2 +-
 docs-ja/pages/desktop-ja.md                 | 352 +++++++++++-------
 docs-ja/pages/desktop-quickstart-en.md      | 139 -------
 docs-ja/pages/discover-plugins-ja.md        |  90 +++--
 docs-ja/pages/fast-mode-ja.md               |  56 +--
 docs-ja/pages/features-overview-ja.md       |  78 ++--
 docs-ja/pages/github-actions-ja.md          | 148 ++++----
 docs-ja/pages/hooks-ja.md                   | 493 +++++++++++++-----------
 docs-ja/pages/how-claude-code-works-ja.md   | 194 +++++-----
 docs-ja/pages/interactive-mode-ja.md        | 225 ++++++-----
 docs-ja/pages/jetbrains-ja.md               | 111 +++---
 docs-ja/pages/keybindings-ja.md             |  46 +--
 docs-ja/pages/mcp-ja.md                     | 557 +++++++++++++++-------------
 docs-ja/pages/memory-ja.md                  | 119 +++---
 docs-ja/pages/model-config-ja.md            |  88 +++--
 docs-ja/pages/output-styles-ja.md           |  32 +-
 docs-ja/pages/overview-ja.md                |  71 ++--
 docs-ja/pages/permissions-ja.md             |  56 +--
 docs-ja/pages/plugin-marketplaces-ja.md     | 274 ++++++++------
 docs-ja/pages/plugins-ja.md                 |  54 +--
 docs-ja/pages/remote-control-ja.md          |  77 ++--
 docs-ja/pages/sandboxing-ja.md              |  58 +--
 docs-ja/pages/scheduled-tasks-en.md         | 129 -------
 docs-ja/pages/server-managed-settings-ja.md |  28 +-
 docs-ja/pages/settings-ja.md                | 329 ++++++++--------
 docs-ja/pages/skills-ja.md                  | 135 +++----
 docs-ja/pages/statusline-ja.md              | 125 ++++---
 docs-ja/pages/sub-agents-ja.md              | 234 ++++++------
 docs-ja/pages/troubleshooting-ja.md         |  94 ++---
 docs-ja/pages/vs-code-ja.md                 | 217 +++++------
 38 files changed, 3011 insertions(+), 2984 deletions(-)
```

**新規追加:**


**削除:**


<details>
<summary>agent-teams-ja.md</summary>

```diff
diff --git a/docs-ja/pages/agent-teams-ja.md b/docs-ja/pages/agent-teams-ja.md
index 3257876..2f461f7 100644
--- a/docs-ja/pages/agent-teams-ja.md
+++ b/docs-ja/pages/agent-teams-ja.md
@@ -5,31 +5,35 @@
 # Claude Code セッションのチームを調整する
 
-> 複数の Claude Code インスタンスがチームとして連携して動作するように調整します。共有タスク、エージェント間メッセージング、一元管理を備えています。
+> 複数の Claude Code インスタンスがチームとして連携して動作するように調整し、共有タスク、エージェント間メッセージング、および一元管理を実現します。
 
 <Warning>
-  エージェントチームは実験的機能であり、デフォルトでは無効です。`CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS` を [settings.json](/ja/settings) または環境に追加して有効にしてください。エージェントチームには、セッション再開、タスク調整、シャットダウン動作に関する [既知の制限](#limitations) があります。
+  エージェントチームは実験的機能であり、デフォルトでは無効になっています。[settings.json](/ja/settings) または環境に `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS` を追加して有効にしてください。エージェントチームには、セッション再開、タスク調整、シャットダウン動作に関する[既知の制限](#limitations)があります。
 </Warning>
 
-エージェントチームを使用すると、複数の Claude Code インスタンスが連携して動作するように調整できます。1 つのセッションがチームリーダーとして機能し、作業を調整し、タスクを割り当て、結果を統合します。チームメイトは独立して動作し、それぞれ独自のコンテキストウィンドウで動作し、互いに直接通信します。
+エージェントチームを使用すると、複数の Claude Code インスタンスが連携して動作するように調整できます。1 つのセッションがチームリーダーとして機能し、作業を調整し、タスクを割り当て、結果を統合します。チームメンバーは独立して動作し、それぞれ独自のコンテキストウィンドウで動作し、互いに直接通信します。
 
-単一セッション内で実行され、メインエージェントにのみ報告できる [subagents](/ja/sub-agents) とは異なり、リーダーを経由せずに個別のチームメイトと直接対話することもできます。
+[subagents](/ja/sub-agents)（単一セッション内で実行され、メインエージェントにのみ報告できる）とは異なり、リーダーを経由せずに個別のチームメンバーと直接対話することもできます。
+
+<Note>
+  エージェントチームには Claude Code v2.1.32 以降が必要です。`claude --version` でバージョンを確認してください。
+</Note>
 
 このページでは、以下について説明します。
 
-* [エージェントチームを使用する場合](#when-to-use-agent-teams)。ベストユースケースと subagents との比較を含みます
+* [エージェントチームを使用する場合](#when-to-use-agent-teams)（ユースケースと subagents との比較を含む）
 * [チームを開始する](#start-your-first-agent-team)
```

</details>

<details>
<summary>amazon-bedrock-ja.md</summary>

```diff
diff --git a/docs-ja/pages/amazon-bedrock-ja.md b/docs-ja/pages/amazon-bedrock-ja.md
index 294e952..20dbef7 100644
--- a/docs-ja/pages/amazon-bedrock-ja.md
+++ b/docs-ja/pages/amazon-bedrock-ja.md
@@ -12,8 +12,12 @@ Claude Code を Bedrock で設定する前に、以下を確認してくださ
 
 * Bedrock アクセスが有効になっている AWS アカウント
-* Bedrock で目的の Claude モデル（例：Claude Sonnet 4.5）へのアクセス
-* AWS CLI がインストールされ、設定されていること（オプション - 別の認証情報取得メカニズムがない場合のみ必要）
+* Bedrock で目的の Claude モデル（例：Claude Sonnet 4.6）へのアクセス
+* AWS CLI がインストールされ、設定されていること（オプション - 認証情報を取得する別のメカニズムがない場合のみ必要）
 * 適切な IAM 権限
 
+<Note>
+  Claude Code を複数のユーザーにデプロイする場合は、[モデルバージョンをピン留めして](#4-pin-model-versions)、Anthropic が新しいモデルをリリースしたときの破損を防いでください。
+</Note>
+
 ## セットアップ
 
@@ -22,8 +26,8 @@ Claude Code を Bedrock で設定する前に、以下を確認してくださ
 Anthropic モデルの初回ユーザーは、モデルを呼び出す前にユースケースの詳細を送信する必要があります。これはアカウントごとに 1 回行われます。
 
-1. 適切な IAM 権限があることを確認してください（詳細は以下を参照）
+1. 適切な IAM 権限があることを確認してください（以下を参照）
 2. [Amazon Bedrock コンソール](https://console.aws.amazon.com/bedrock/)に移動します
 3. **Chat/Text playground** を選択します
-4. 任意の Anthropic モデルを選択すると、ユースケースフォームの入力を求められます
+4. Anthropic モデルを選択すると、ユースケースフォームの入力を求められます
 
 ### 2. AWS 認証情報を設定
```

</details>

<details>
<summary>best-practices-ja.md</summary>

```diff
diff --git a/docs-ja/pages/best-practices-ja.md b/docs-ja/pages/best-practices-ja.md
index 0c3296d..e0bbedd 100644
--- a/docs-ja/pages/best-practices-ja.md
+++ b/docs-ja/pages/best-practices-ja.md
@@ -9,5 +9,5 @@
 Claude Code は agentic coding 環境です。質問に答えて待つチャットボットとは異なり、Claude Code はファイルを読み取り、コマンドを実行し、変更を加え、あなたが見守ったり、方向を変えたり、完全に任せたりしながら、自律的に問題を解決できます。
 
-これはあなたの作業方法を変えます。自分でコードを書いて Claude にレビューしてもらう代わりに、何をしたいかを説明すると、Claude がそれをどのように構築するかを考え出します。Claude は探索し、計画し、実装します。
+これはあなたの作業方法を変えます。自分でコードを書いて Claude にレビューしてもらう代わりに、やりたいことを説明すると Claude がそれをどのように構築するかを考え出します。Claude は探索し、計画し、実装します。
 
 しかし、この自律性にも学習曲線があります。Claude は理解する必要がある特定の制約の中で動作します。
@@ -19,7 +19,7 @@ Claude Code は agentic coding 環境です。質問に答えて待つチャッ
 ほとんどのベストプラクティスは 1 つの制約に基づいています。Claude のコンテキストウィンドウはすぐにいっぱいになり、満杯になるにつれてパフォーマンスが低下します。
 
-Claude のコンテキストウィンドウは、すべてのメッセージ、Claude が読み取ったすべてのファイル、およびすべてのコマンド出力を含む、会話全体を保持します。ただし、これはすぐにいっぱいになる可能性があります。単一のデバッグセッションまたはコードベース探索でも、数万トークンを生成および消費する可能性があります。
+Claude のコンテキストウィンドウは、すべてのメッセージ、Claude が読み取ったすべてのファイル、およびすべてのコマンド出力を含む、会話全体を保持します。ただし、これはすぐにいっぱいになる可能性があります。単一のデバッグセッションまたはコードベース探索でも、数万のトークンを生成および消費する可能性があります。
 
-LLM のパフォーマンスはコンテキストが満杯になるにつれて低下するため、これは重要です。コンテキストウィンドウがいっぱいになると、Claude は以前の指示を「忘れる」か、より多くの間違いを犯す可能性があります。コンテキストウィンドウは管理する最も重要なリソースです。[カスタムステータスライン](/ja/statusline)でコンテキスト使用量を継続的に追跡し、[トークン使用量を削減](/ja/costs#reduce-token-usage)でトークン使用量を削減するための戦略を参照してください。
+LLM のパフォーマンスはコンテキストが満杯になるにつれて低下するため、これは重要です。コンテキストウィンドウがいっぱいになると、Claude は以前の指示を「忘れる」か、より多くの間違いを犯す可能性があります。コンテキストウィンドウは管理する最も重要なリソースです。[カスタムステータスライン](/ja/statusline)でコンテキスト使用量を継続的に追跡し、トークン使用量を削減するための戦略については[トークン使用量を削減](/ja/costs#reduce-token-usage)を参照してください。
 
 ***
@@ -50,5 +50,5 @@ UI の変更は [Chrome 拡張機能の Claude](/ja/chrome) を使用して検
 
 <Tip>
-  間違った問題を解決することを避けるために、研究と計画を実装から分離します。
+  研究と計画を実装から分離して、間違った問題を解決することを避けます。
 </Tip>
 
@@ -75,5 +75,5 @@ Claude が直接コーディングにジャンプさせると、間違った問
     ```
```

</details>

<!-- UPDATE_LOG_END -->
