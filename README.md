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
<summary>2026-02-19</summary>

**変更ファイル:**

```
 docs-ja/pages/changelog.md |  76 +++++
 docs-ja/pages/mcp-ja.md    | 735 +++++++++++++++++++++++++++------------------
 2 files changed, 518 insertions(+), 293 deletions(-)
```

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index c1b178b..43a16ff 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,80 @@
 # Changelog
 
+## 2.1.47
+
+- Fixed FileWriteTool line counting to preserve intentional trailing blank lines instead of stripping them with `trimEnd()`.
+- Fixed Windows terminal rendering bugs caused by `os.EOL` (`\r\n`) in display code — line counts now show correct values instead of always showing 1 on Windows.
+- Improved VS Code plan preview: auto-updates as Claude iterates, enables commenting only when the plan is ready for review, and keeps the preview open when rejecting so Claude can revise.
+- Fixed a bug where bold and colored text in markdown output could shift to the wrong characters on Windows due to `\r\n` line endings.
+- Fixed compaction failing when conversation contains many PDF documents by stripping document blocks alongside images before sending to the compaction API (anthropics/claude-code#26188)
+- Improved memory usage in long-running sessions by releasing API stream buffers, agent context, and skill state after use
+- Improved startup performance by deferring SessionStart hook execution, reducing time-to-interactive by ~500ms.
+- Fixed an issue where bash tool output was silently discarded on Windows when using MSYS2 or Cygwin shells.
+- Improved performance of `@` file mentions - file suggestions now appear faster by pre-warming the index on startup and using session-based caching with background refresh.
+- Improved memory usage by trimming agent task message history after tasks complete
+- Improved memory usage during long agent sessions by eliminating O(n²) message accumulation in progress updates
+- Fixed the bash permission classifier to validate that returned match descriptions correspond to actual input rules, preventing hallucinated descriptions from incorrectly granting permissions
+- Fixed user-defined agents only loading one file on NFS/FUSE filesystems that report zero inodes (anthropics/claude-code#26044)
+- Fixed plugin agent skills silently failing to load when referenced by bare name instead of fully-qualified plugin name (anthropics/claude-code#25834)
+- Search patterns in collapsed tool results are now displayed in quotes for clarity
+- Windows: Fixed CWD tracking temp files never being cleaned up, causing them to accumulate indefinitely (anthropics/claude-code#17600)
+- Use `ctrl+f` to kill all background agents instead of double-pressing ESC. Background agents now continue running when you press ESC to cancel the main thread, giving you more control over agent lifecycle.
+- Fixed API 400 errors ("thinking blocks cannot be modified") that occurred in sessions with concurrent agents, caused by interleaved streaming content blocks preventing proper message merging.
+- Simplified teammate navigation to use only Shift+Down (with wrapping) instead of both Shift+Up and Shift+Down.
+- Fixed an issue where a single file write/edit error would abort all other parallel file write/edit operations. Independent file mutations now complete even when a sibling fails.
+- Added `last_assistant_message` field to Stop and SubagentStop hook inputs, providing the final assistant response text so hooks can access it without parsing transcript files.
```

</details>

<details>
<summary>mcp-ja.md</summary>

```diff
diff --git a/docs-ja/pages/mcp-ja.md b/docs-ja/pages/mcp-ja.md
index 4a7c600..8ba8a98 100644
--- a/docs-ja/pages/mcp-ja.md
+++ b/docs-ja/pages/mcp-ja.md
@@ -3,7 +3,7 @@
 > Use this file to discover all available pages before exploring further.
 
-# MCPを使用してClaude Codeをツールに接続する
+# MCP を使用して Claude Code をツールに接続する
 
-> Model Context Protocolを使用してClaude Codeをツールに接続する方法を学びます。
+> Model Context Protocol を使用して Claude Code をツールに接続する方法を学びます。
 
 export const MCPServersTable = ({platform = "all"}) => {
@@ -213,24 +213,24 @@ export const MCPServersTable = ({platform = "all"}) => {
 };
 
-Claude Codeは、AI-ツール統合のためのオープンソース標準である[Model Context Protocol (MCP)](https://modelcontextprotocol.io/introduction)を通じて、数百の外部ツールとデータソースに接続できます。MCPサーバーは、Claude Codeにツール、データベース、APIへのアクセスを提供します。
+Claude Code は、AI ツール統合のためのオープンソース標準である [Model Context Protocol (MCP)](https://modelcontextprotocol.io/introduction) を通じて、数百の外部ツールとデータソースに接続できます。MCP サーバーは Claude Code にツール、データベース、API へのアクセスを提供します。
 
-## MCPでできることは何か
+## MCP でできること
 
-MCPサーバーが接続されている場合、Claude Codeに以下を依頼できます：
+MCP サーバーが接続されている場合、Claude Code に以下のことを依頼できます。
 
-* **イシュートラッカーから機能を実装する**: 「JIRA issue ENG-4521に記載されている機能を追加し、GitHubにPRを作成してください。」
-* **監視データを分析する**: 「SentryとStatsigをチェックして、ENG-4521に記載されている機能の使用状況を確認してください。」
-* **データベースをクエリする**: 「PostgreSQLデータベースに基づいて、ENG-4521機能を使用した10人のランダムユーザーのメールアドレスを検索してください。」
-* **デザインを統合する**: 「Slackに投稿された新しいFigmaデザインに基づいて、標準メールテンプレートを更新してください。」
```

</details>

</details>


<details>
<summary>2026-02-18</summary>

**変更ファイル:**

```
 docs-ja/pages/changelog.md | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)
```

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index 17e1909..c1b178b 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,6 +1,25 @@
 # Changelog
 
+## 2.1.45
+
+- Added support for Claude Sonnet 4.6
+- Added support for reading `enabledPlugins` and `extraKnownMarketplaces` from `--add-dir` directories
+- Added `spinnerTipsOverride` setting to customize spinner tips — configure `tips` with an array of custom tip strings, and optionally set `excludeDefault: true` to show only your custom tips instead of the built-in ones
+- Added `SDKRateLimitInfo` and `SDKRateLimitEvent` types to the SDK, enabling consumers to receive rate limit status updates including utilization, reset times, and overage information
+- Fixed Agent Teams teammates failing on Bedrock, Vertex, and Foundry by propagating API provider environment variables to tmux-spawned processes (anthropics/claude-code#23561)
+- Fixed sandbox "operation not permitted" errors when writing temporary files on macOS by using the correct per-user temp directory (anthropics/claude-code#21654)
+- Fixed Task tool (backgrounded agents) crashing with a `ReferenceError` on completion (anthropics/claude-code#22087)
+- Fixed autocomplete suggestions not being accepted on Enter when images are pasted in the input
+- Fixed skills invoked by subagents incorrectly appearing in main session context after compaction
+- Fixed excessive `.claude.json.backup` files accumulating on every startup
+- Fixed plugin-provided commands, agents, and hooks not being available immediately after installation without requiring a restart
+- Improved startup performance by removing eager loading of session history for stats caching
+- Improved memory usage for shell commands that produce large output — RSS no longer grows unboundedly with command output size
+- Improved collapsed read/search groups to show the current file or search pattern being processed beneath the summary line while active
+- [VSCode] Improved permission destination choice (project/user/session) to persist across sessions
+
 ## 2.1.44
 
+- Fixed ENAMETOOLONG errors for deeply-nested directory paths
 - Fixed auth refresh errors
 
```

</details>

</details>


<details>
<summary>2026-02-17</summary>

**変更ファイル:**

```
 docs-ja/pages/changelog.md   |  10 ++
 docs-ja/pages/overview-ja.md | 275 ++++++++++++++++++++++++++-----------------
 2 files changed, 176 insertions(+), 109 deletions(-)
```

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index 2701cfc..17e1909 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,14 @@
 # Changelog
 
+## 2.1.44
+
+- Fixed auth refresh errors
+
+## 2.1.43
+
+- Fixed AWS auth refresh hanging indefinitely by adding a 3-minute timeout
+- Fixed spurious warnings for non-agent markdown files in `.claude/agents/` directory
+- Fixed structured-outputs beta header being sent unconditionally on Vertex/Bedrock
+
 ## 2.1.42
 
```

</details>

<details>
<summary>overview-ja.md</summary>

```diff
diff --git a/docs-ja/pages/overview-ja.md b/docs-ja/pages/overview-ja.md
index db13ab4..d25268c 100644
--- a/docs-ja/pages/overview-ja.md
+++ b/docs-ja/pages/overview-ja.md
@@ -3,159 +3,216 @@
 > Use this file to discover all available pages before exploring further.
 
-# Claude Code 概要
+# Claude Code の概要
 
-> Anthropic の agentic coding ツール Claude Code について学びます。Claude Code はターミナルで動作し、アイデアをコードに変えるのを今までより速く支援します。
+> Claude Code は、コードベースを読み取り、ファイルを編集し、コマンドを実行し、開発ツールと統合する agentic coding ツールです。ターミナル、IDE、デスクトップアプリ、ブラウザで利用できます。
 
-## 30 秒で始める
+Claude Code は、機能の構築、バグの修正、開発タスクの自動化を支援する AI 搭載のコーディングアシスタントです。コードベース全体を理解し、複数のファイルとツール全体で作業して、タスクを完了できます。
 
-前提条件：
+## はじめに
 
-* [システム要件](/ja/setup#system-requirements)を満たしていること
-* [Claude サブスクリプション](https://claude.com/pricing)（Pro、Max、Teams、または Enterprise）または [Claude Console](https://console.anthropic.com/) アカウント
+環境を選択してはじめましょう。ほとんどのサーフェスには、[Claude サブスクリプション](https://claude.com/pricing)または [Anthropic Console](https://console.anthropic.com/) アカウントが必要です。Terminal CLI と VS Code は [サードパーティプロバイダー](/ja/third-party-integrations)もサポートしています。
 
-**Claude Code をインストール：**
+<Tabs>
+  <Tab title="Terminal">
+    ターミナルで Claude Code を直接操作するための機能豊富な CLI です。ファイルを編集し、コマンドを実行し、コマンドラインからプロジェクト全体を管理できます。
 
-To install Claude Code, use one of the following methods:
+    To install Claude Code, use one of the following methods:
```

</details>

</details>


<details>
<summary>2026-02-15</summary>

**新規追加:**


</details>


<details>
<summary>2026-02-14</summary>

**変更ファイル:**

```
 docs-ja/pages/changelog.md         | 32 ++++++++++++++++++++++-----
 docs-ja/pages/network-config-ja.md | 45 +++++++++++++++++++-------------------
 2 files changed, 48 insertions(+), 29 deletions(-)
```

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index e3ed77e..2701cfc 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,5 +1,13 @@
 # Changelog
 
-## 2.1.39
+## 2.1.42
+
+- Improved startup performance by deferring Zod schema construction
+- Improved prompt cache hit rates by moving date out of system prompt
+- Added one-time Opus 4.6 effort callout for eligible users
+- Fixed /resume showing interrupt messages as session titles
+- Fixed image dimension limit errors to suggest /compact
+
+## 2.1.41
 
 - Added guard against launching Claude Code inside another Claude Code session
@@ -11,9 +19,21 @@
 - Fixed hook blocking errors (exit code 2) not showing stderr to the user
 - Added `speed` attribute to OTel events and trace spans for fast mode visibility
-- Fixed /resume showing interrupt messages as session titles
-- Fixed Opus 4.6 launch announcement showing for Bedrock/Vertex/Foundry users
-- Improved error message for many-image dimension limit errors with /compact suggestion
-- Fixed structured-outputs beta header being sent unconditionally on Vertex/Bedrock
-- Fixed spurious warnings for non-agent markdown files in `.claude/agents/` directory
+- Added `claude auth login`, `claude auth status`, and `claude auth logout` CLI subcommands
+- Added Windows ARM64 (win32-arm64) native binary support
+- Improved `/rename` to auto-generate session name from conversation context when called without arguments
```

</details>

<details>
<summary>network-config-ja.md</summary>

```diff
diff --git a/docs-ja/pages/network-config-ja.md b/docs-ja/pages/network-config-ja.md
index 066d6e4..fb62d0c 100644
--- a/docs-ja/pages/network-config-ja.md
+++ b/docs-ja/pages/network-config-ja.md
@@ -3,25 +3,25 @@
 > Use this file to discover all available pages before exploring further.
 
-# エンタープライズネットワーク構成
+# エンタープライズネットワーク設定
 
-> プロキシサーバー、カスタム認証局（CA）、および相互トランスポートレイヤーセキュリティ（mTLS）認証を使用して、エンタープライズ環境向けにClaude Codeを構成します。
+> プロキシサーバー、カスタム認証局（CA）、相互 Transport Layer Security（mTLS）認証を使用して、エンタープライズ環境向けに Claude Code を設定します。
 
-Claude Codeは、環境変数を通じてさまざまなエンタープライズネットワークおよびセキュリティ構成をサポートしています。これには、企業プロキシサーバーを通じたトラフィックのルーティング、カスタム認証局（CA）の信頼、およびセキュリティ強化のための相互トランスポートレイヤーセキュリティ（mTLS）証明書による認証が含まれます。
+Claude Code は、環境変数を通じてさまざまなエンタープライズネットワークおよびセキュリティ設定をサポートしています。これには、企業プロキシサーバーを経由したトラフィックのルーティング、カスタム認証局（CA）の信頼、およびセキュリティ強化のための相互 Transport Layer Security（mTLS）証明書による認証が含まれます。
 
 <Note>
-  このページに表示されているすべての環境変数は、[`settings.json`](/ja/settings)でも構成できます。
+  このページに表示されているすべての環境変数は、[`settings.json`](/ja/settings) でも設定できます。
 </Note>
 
-## プロキシ構成
+## プロキシ設定
 
 ### 環境変数
 
-Claude Codeは標準的なプロキシ環境変数に対応しています：
+Claude Code は標準的なプロキシ環境変数に対応しています。
 
 ```bash  theme={null}
```

</details>

</details>


<details>
<summary>2026-02-13</summary>

**変更ファイル:**

```
 docs-ja/pages/changelog.md | 5 +++++
 1 file changed, 5 insertions(+)
```

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index f6388b1..e3ed77e 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -11,4 +11,9 @@
 - Fixed hook blocking errors (exit code 2) not showing stderr to the user
 - Added `speed` attribute to OTel events and trace spans for fast mode visibility
+- Fixed /resume showing interrupt messages as session titles
+- Fixed Opus 4.6 launch announcement showing for Bedrock/Vertex/Foundry users
+- Improved error message for many-image dimension limit errors with /compact suggestion
+- Fixed structured-outputs beta header being sent unconditionally on Vertex/Bedrock
+- Fixed spurious warnings for non-agent markdown files in `.claude/agents/` directory
 - Improved terminal rendering performance
 - Fixed fatal errors being swallowed instead of displayed
```

</details>

</details>


<details>
<summary>2026-02-12</summary>

**変更ファイル:**

```
 docs-ja/pages/changelog.md                  | 8 ++++++++
 docs-ja/pages/server-managed-settings-en.md | 2 +-
 2 files changed, 9 insertions(+), 1 deletion(-)
```

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index e146ed5..f6388b1 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -3,4 +3,12 @@
 ## 2.1.39
 
+- Added guard against launching Claude Code inside another Claude Code session
+- Fixed Agent Teams using wrong model identifier for Bedrock, Vertex, and Foundry customers
+- Fixed a crash when MCP tools return image content during streaming
+- Fixed /resume session previews showing raw XML tags instead of readable command names
+- Improved model error messages for Bedrock/Vertex/Foundry users with fallback suggestions
+- Fixed plugin browse showing misleading "Space to Toggle" hint for already-installed plugins
+- Fixed hook blocking errors (exit code 2) not showing stderr to the user
+- Added `speed` attribute to OTel events and trace spans for fast mode visibility
 - Improved terminal rendering performance
 - Fixed fatal errors being swallowed instead of displayed
```

</details>

<details>
<summary>server-managed-settings-en.md</summary>

```diff
diff --git a/docs-ja/pages/server-managed-settings-en.md b/docs-ja/pages/server-managed-settings-en.md
index 9e6d316..e80d0e7 100644
--- a/docs-ja/pages/server-managed-settings-en.md
+++ b/docs-ja/pages/server-managed-settings-en.md
@@ -20,5 +20,5 @@ To use server-managed settings, you need:
 
 * Claude for Teams or Claude for Enterprise plan
-* Claude Code version 2.1.30 or later
+* Claude Code version 2.1.38 or later for Claude for Teams, or version 2.1.30 or later for Claude for Enterprise
 * Network access to `api.anthropic.com`
 
```

</details>

</details>


<details>
<summary>2026-02-11</summary>

**変更ファイル:**

```
 docs-ja/pages/changelog.md    | 18 ++++++++++++++++++
 docs-ja/pages/fast-mode-en.md |  2 +-
 2 files changed, 19 insertions(+), 1 deletion(-)
```

**新規追加:**


<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index cfb32b2..e146ed5 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,22 @@
 # Changelog
 
+## 2.1.39
+
+- Improved terminal rendering performance
+- Fixed fatal errors being swallowed instead of displayed
+- Fixed process hanging after session close
+- Fixed character loss at terminal screen boundary
+- Fixed blank lines in verbose transcript view
+
+## 2.1.38
+
+- Fixed VS Code terminal scroll-to-top regression introduced in 2.1.37
+- Fixed Tab key queueing slash commands instead of autocompleting
+- Fixed bash permission matching for commands using environment variable wrappers
+- Fixed text between tool uses disappearing when not using streaming
+- Fixed duplicate sessions when resuming in VS Code extension
+- Improved heredoc delimiter parsing to prevent command smuggling
+- Blocked writes to `.claude/skills` directory in sandbox mode
+
 ## 2.1.37
 
```

</details>

<details>
<summary>fast-mode-en.md</summary>

```diff
diff --git a/docs-ja/pages/fast-mode-en.md b/docs-ja/pages/fast-mode-en.md
index ad273b9..9bd3724 100644
--- a/docs-ja/pages/fast-mode-en.md
+++ b/docs-ja/pages/fast-mode-en.md
@@ -11,5 +11,5 @@
 </Note>
 
-Fast mode delivers faster Opus 4.6 responses at a higher cost per token. Toggle it on with `/fast` when you need speed for interactive work like rapid iteration or live debugging, and toggle it off when cost matters more than latency.
+Fast mode is a high-speed configuration for Claude Opus 4.6, making the model 2.5x faster at a higher cost per token. Toggle it on with `/fast` when you need speed for interactive work like rapid iteration or live debugging, and toggle it off when cost matters more than latency.
 
 Fast mode is not a different model. It uses the same Opus 4.6 with a different API configuration that prioritizes speed over cost efficiency. You get identical quality and capabilities, just faster responses.
```

</details>

</details>


<details>
<summary>2026-02-08</summary>

**変更ファイル:**

```
 docs-ja/pages/changelog.md | 8 ++++++++
 1 file changed, 8 insertions(+)
```

**新規追加:**


<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index d1f1f91..cfb32b2 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,12 @@
 # Changelog
 
+## 2.1.37
+
+- Fixed an issue where /fast was not immediately available after enabling /extra-usage
+
+## 2.1.36
+
+- Fast mode is now available for Opus 4.6. Learn more at https://code.claude.com/docs/en/fast-mode
+
 ## 2.1.34
 
```

</details>

</details>


<details>
<summary>2026-02-06</summary>

**変更ファイル:**

```
 docs-ja/pages/agent-teams-en.md           | 380 ------------------------------
 docs-ja/pages/changelog.md                |  24 ++
 docs-ja/pages/features-overview-en.md     | 278 ----------------------
 docs-ja/pages/how-claude-code-works-en.md | 240 -------------------
 docs-ja/pages/permissions-en.md           | 258 --------------------
 5 files changed, 24 insertions(+), 1156 deletions(-)
```

**削除:**


<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index 287e824..d1f1f91 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,28 @@
 # Changelog
 
+## 2.1.34
+
+- Fixed a crash when agent teams setting changed between renders
+- Fixed a bug where commands excluded from sandboxing (via `sandbox.excludedCommands` or `dangerouslyDisableSandbox`) could bypass the Bash ask permission rule when `autoAllowBashIfSandboxed` was enabled
+
+## 2.1.33
+
+- Fixed agent teammate sessions in tmux to send and receive messages
+- Fixed warnings about agent teams not being available on your current plan
+- Added `TeammateIdle` and `TaskCompleted` hook events for multi-agent workflows
+- Added support for restricting which sub-agents can be spawned via `Task(agent_type)` syntax in agent "tools" frontmatter
+- Added `memory` frontmatter field support for agents, enabling persistent memory with `user`, `project`, or `local` scope
+- Added plugin name to skill descriptions and `/skills` menu for better discoverability
+- Fixed an issue where submitting a new message while the model was in extended thinking would interrupt the thinking phase
+- Fixed an API error that could occur when aborting mid-stream, where whitespace text combined with a thinking block would bypass normalization and produce an invalid request
+- Fixed API proxy compatibility issue where 404 errors on streaming endpoints no longer triggered non-streaming fallback
+- Fixed an issue where proxy settings configured via `settings.json` environment variables were not applied to WebFetch and other HTTP requests on the Node.js build
+- Fixed `/resume` session picker showing raw XML markup instead of clean titles for sessions started with slash commands
+- Improved error messages for API connection failures — now shows specific cause (e.g., ECONNREFUSED, SSL errors) instead of generic "Connection error"
+- Errors from invalid managed settings are now surfaced
+- VSCode: Added support for remote sessions, allowing OAuth users to browse and resume sessions from claude.ai
+- VSCode: Added git branch and message count to the session picker, with support for searching by branch name
+- VSCode: Fixed scroll-to-bottom under-scrolling on initial session load and session switch
```

</details>

</details>


<details>
<summary>2026-02-06</summary>

**変更ファイル:**

```
 docs-ja/pages/best-practices-ja.md      | 338 +++++++++---------
 docs-ja/pages/checkpointing-ja.md       |  50 +--
 docs-ja/pages/cli-reference-ja.md       | 127 +++----
 docs-ja/pages/common-workflows-ja.md    | 138 ++++---
 docs-ja/pages/data-usage-ja.md          |  87 ++---
 docs-ja/pages/headless-ja.md            |  85 +++--
 docs-ja/pages/model-config-ja.md        | 143 +++++---
 docs-ja/pages/output-styles-ja.md       |  44 +--
 docs-ja/pages/plugin-marketplaces-ja.md | 329 ++++++++++-------
 docs-ja/pages/plugins-ja.md             | 208 ++++++-----
 docs-ja/pages/plugins-reference-ja.md   | 460 ++++++++++++------------
 docs-ja/pages/settings-ja.md            | 464 ++++++++++++------------
 docs-ja/pages/sub-agents-ja.md          | 614 +++++++++++++++++---------------
 13 files changed, 1622 insertions(+), 1465 deletions(-)
```

**新規追加:**


<details>
<summary>best-practices-ja.md</summary>

```diff
diff --git a/docs-ja/pages/best-practices-ja.md b/docs-ja/pages/best-practices-ja.md
index 94dcc00..62335da 100644
--- a/docs-ja/pages/best-practices-ja.md
+++ b/docs-ja/pages/best-practices-ja.md
@@ -9,17 +9,17 @@
 Claude Code は agentic coding 環境です。質問に答えて待つチャットボットとは異なり、Claude Code はファイルを読み取り、コマンドを実行し、変更を加え、あなたが見守ったり、方向を変えたり、完全に任せたりしながら、自律的に問題を解決できます。
 
-これはあなたの作業方法を変えます。自分でコードを書いて Claude にレビューしてもらう代わりに、やりたいことを説明すると Claude がそれをどのように構築するかを考え出します。Claude は探索し、計画し、実装します。
+これはあなたの作業方法を変えます。自分でコードを書いて Claude にレビューしてもらう代わりに、何をしたいかを説明すると、Claude がそれをどのように構築するかを考え出します。Claude は探索し、計画し、実装します。
 
 しかし、この自律性にも学習曲線があります。Claude は理解する必要がある特定の制約の中で動作します。
 
-このガイドでは、Anthropic の内部チームと様々なコードベース、言語、環境で Claude Code を使用しているエンジニアの間で効果的であることが証明されたパターンについて説明します。agentic ループがどのように機能するかについては、[Claude Code の仕組み](/ja/how-claude-code-works)を参照してください。
+このガイドでは、Anthropic の内部チームと、様々なコードベース、言語、環境で Claude Code を使用しているエンジニアの間で効果的であることが証明されたパターンについて説明します。agentic ループがどのように機能するかについては、[Claude Code の仕組み](/ja/how-claude-code-works)を参照してください。
 
 ***
 
-ほとんどのベストプラクティスは 1 つの制約に基づいています。Claude のコンテキストウィンドウはすぐにいっぱいになり、満杯になるにつれてパフォーマンスが低下します。
+ほとんどのベストプラクティスは 1 つの制約に基づいています。Claude のコンテキストウィンドウはすぐにいっぱいになり、いっぱいになるにつれてパフォーマンスが低下します。
 
-Claude のコンテキストウィンドウは、すべてのメッセージ、Claude が読み取ったすべてのファイル、すべてのコマンド出力を含む、会話全体を保持します。ただし、これはすぐにいっぱいになる可能性があります。単一のデバッグセッションまたはコードベース探索でも、数万トークンが生成および消費される可能性があります。
+Claude のコンテキストウィンドウは、すべてのメッセージ、Claude が読み取ったすべてのファイル、およびすべてのコマンド出力を含む、会話全体を保持します。ただし、これはすぐにいっぱいになる可能性があります。単一のデバッグセッションまたはコードベース探索でも、数万のトークンを生成および消費する可能性があります。
 
-これは重要です。LLM のパフォーマンスはコンテキストが満杯になるにつれて低下するためです。コンテキストウィンドウがいっぱいになりかけると、Claude は以前の指示を「忘れる」か、より多くの間違いを犯す可能性があります。コンテキストウィンドウは管理する最も重要なリソースです。トークン使用量を削減するための詳細な戦略については、[トークン使用量を削減する](/ja/costs#reduce-token-usage)を参照してください。
+これは重要です。LLM のパフォーマンスはコンテキストがいっぱいになるにつれて低下するためです。コンテキストウィンドウがいっぱいになりかけると、Claude は以前の指示を「忘れる」か、より多くの間違いを犯す可能性があります。コンテキストウィンドウは管理する最も重要なリソースです。トークン使用量を削減するための詳細な戦略については、[トークン使用量を削減する](/ja/costs#reduce-token-usage)を参照してください。
 
 ***
@@ -28,8 +28,8 @@ Claude のコンテキストウィンドウは、すべてのメッセージ、C
 
 <Tip>
```

</details>

<details>
<summary>checkpointing-ja.md</summary>

```diff
diff --git a/docs-ja/pages/checkpointing-ja.md b/docs-ja/pages/checkpointing-ja.md
index fbd5ccb..32f841d 100644
--- a/docs-ja/pages/checkpointing-ja.md
+++ b/docs-ja/pages/checkpointing-ja.md
@@ -3,43 +3,43 @@
 > Use this file to discover all available pages before exploring further.
 
-# チェックポイント
+# Checkpointing
 
-> Claudeの編集を自動的に追跡し、巻き戻して、不要な変更から素早く復旧します。
+> Claude の編集を自動的に追跡し、不要な変更から素早く復旧するために以前の状態に巻き戻します。
 
-Claude Codeは、作業中にClaudeのファイル編集を自動的に追跡し、変更を素早く元に戻したり、問題が発生した場合に以前の状態に巻き戻したりできます。
+Claude Code は、作業中に Claude のファイル編集を自動的に追跡し、何か問題が発生した場合に変更を素早く取り消し、以前の状態に巻き戻すことができます。
 
-## チェックポイントの仕組み
+## Checkpointing の仕組み
 
-Claude Codeで作業する際、チェックポイント機能は各編集の前にコードの状態を自動的にキャプチャします。このセーフティネットにより、野心的で大規模なタスクを実行する際に、いつでも以前のコード状態に戻ることができるという安心感を持って作業できます。
+Claude と作業する際、checkpointing は各編集の前にコードの状態を自動的にキャプチャします。このセーフティネットにより、野心的で大規模なタスクを実行する際に、いつでも以前のコード状態に戻ることができるという安心感を持って作業できます。
 
 ### 自動追跡
 
-Claude Codeはファイル編集ツールによるすべての変更を追跡します：
+Claude Code は、ファイル編集ツールによって行われたすべての変更を追跡します：
 
-* ユーザープロンプトごとに新しいチェックポイントが作成されます
-* チェックポイントはセッション間で保持されるため、再開した会話でアクセスできます
-* セッション後30日で自動的にクリーンアップされます（設定可能）
```

</details>

<details>
<summary>cli-reference-ja.md</summary>

```diff
diff --git a/docs-ja/pages/cli-reference-ja.md b/docs-ja/pages/cli-reference-ja.md
index 4eb24b2..c8ee375 100644
--- a/docs-ja/pages/cli-reference-ja.md
+++ b/docs-ja/pages/cli-reference-ja.md
@@ -23,58 +23,59 @@
 ## CLI フラグ
 
-これらのコマンドラインフラグを使用して Claude Code の動作をカスタマイズします。
-
-| フラグ                                    | 説明                                                                                                                                            | 例                                                                                                  |
-| :------------------------------------- | :-------------------------------------------------------------------------------------------------------------------------------------------- | :------------------------------------------------------------------------------------------------- |
-| `--add-dir`                            | Claude がアクセスできる追加の作業ディレクトリを追加します（各パスがディレクトリとして存在することを検証します）                                                                                   | `claude --add-dir ../apps ../lib`                                                                  |
-| `--agent`                              | 現在のセッション用のエージェントを指定します（`agent` 設定をオーバーライドします）                                                                                                 | `claude --agent my-custom-agent`                                                                   |
-| `--agents`                             | カスタム [subagents](/ja/sub-agents) を JSON 経由で動的に定義します（形式については以下を参照）                                                                             | `claude --agents '{"reviewer":{"description":"Reviews code","prompt":"You are a code reviewer"}}'` |
-| `--allow-dangerously-skip-permissions` | 権限バイパスをオプションとして有効にします。すぐには有効化しません。`--permission-mode` と組み合わせることができます（注意して使用してください）                                                            | `claude --permission-mode plan --allow-dangerously-skip-permissions`                               |
-| `--allowedTools`                       | 権限を求めずに実行するツール。パターンマッチングについては [権限ルール構文](/ja/settings#permission-rule-syntax) を参照してください。利用可能なツールを制限するには、代わりに `--tools` を使用してください               | `"Bash(git log *)" "Bash(git diff *)" "Read"`                                                      |
-| `--append-system-prompt`               | デフォルトシステムプロンプトの末尾にカスタムテキストを追加します（インタラクティブモードと出力モードの両方で機能します）                                                                                  | `claude --append-system-prompt "Always use TypeScript"`                                            |
-| `--append-system-prompt-file`          | ファイルから追加のシステムプロンプトテキストを読み込み、デフォルトプロンプトに追加します（出力モードのみ）                                                                                         | `claude -p --append-system-prompt-file ./extra-rules.txt "query"`                                  |
-| `--betas`                              | API リクエストに含めるベータヘッダー（API キーユーザーのみ）                                                                                                            | `claude --betas interleaved-thinking`                                                              |
-| `--chrome`                             | Web 自動化とテスト用の [Chrome ブラウザ統合](/ja/chrome) を有効にします                                                                                             | `claude --chrome`                                                                                  |
-| `--continue`, `-c`                     | 現在のディレクトリで最新の会話を読み込みます                                                                                                                        | `claude --continue`                                                                                |
-| `--dangerously-skip-permissions`       | すべての権限プロンプトをスキップします（注意して使用してください）                                                                                                             | `claude --dangerously-skip-permissions`                                                            |
-| `--debug`                              | デバッグモードを有効にします。オプションのカテゴリフィルタリング付き（例：`"api,hooks"` または `"!statsig,!file"`）                                                                    | `claude --debug "api,mcp"`                                                                         |
-| `--disable-slash-commands`             | このセッションのすべてのスキルとスラッシュコマンドを無効にします                                                                                                              | `claude --disable-slash-commands`                                                                  |
-| `--disallowedTools`                    | モデルのコンテキストから削除され、使用できないツール                                                                                                                    | `"Bash(git log *)" "Bash(git diff *)" "Edit"`                                                      |
-| `--fallback-model`                     | デフォルトモデルがオーバーロードされた場合、指定されたモデルへの自動フォールバックを有効にします（出力モードのみ）                                                                                     | `claude -p --fallback-model sonnet "query"`                                                        |
-| `--fork-session`                       | 再開時に、元のセッション ID を再利用する代わりに新しいセッション ID を作成します（`--resume` または `--continue` と共に使用）                                                               | `claude --resume abc123 --fork-session`                                                            |
-| `--from-pr`                            | 特定の GitHub PR にリンクされたセッションを再開します。PR 番号または URL を受け入れます。セッションは `gh pr create` 経由で作成されたときに自動的にリンクされます                                            | `claude --from-pr 123`                                                                             |
-| `--ide`                                | スタートアップ時に、正確に 1 つの有効な IDE が利用可能な場合、自動的に IDE に接続します                                                                                            | `claude --ide`                                                                                     |
-| `--init`                               | 初期化フックを実行してインタラクティブモードを開始します                                                                                                                  | `claude --init`                                                                                    |
```

</details>

<details>
<summary>common-workflows-ja.md</summary>

```diff
diff --git a/docs-ja/pages/common-workflows-ja.md b/docs-ja/pages/common-workflows-ja.md
index 6271b9d..ecad25a 100644
--- a/docs-ja/pages/common-workflows-ja.md
+++ b/docs-ja/pages/common-workflows-ja.md
@@ -5,16 +5,16 @@
 # 一般的なワークフロー
 
-> Claude Code でコードベースの探索、バグ修正、リファクタリング、テスト、その他の日常的なタスクを行うためのステップバイステップガイド。
+> Claude Code でコードベースの探索、バグ修正、リファクタリング、テスト、その他の日常的なタスクを実行するためのステップバイステップガイド。
 
-このページでは、日常的な開発のための実践的なワークフローについて説明します。コードベースの探索、デバッグ、リファクタリング、テストの作成、PR の作成、セッション管理などです。各セクションには、自分のプロジェクトに適応できるプロンプトの例が含まれています。より高度なパターンとヒントについては、[ベストプラクティス](/ja/best-practices)を参照してください。
+このページでは、日常的な開発のための実践的なワークフローについて説明します。未知のコードの探索、デバッグ、リファクタリング、テストの作成、PR の作成、セッションの管理などです。各セクションには、自分のプロジェクトに適応させることができるプロンプトの例が含まれています。より高度なパターンとヒントについては、[ベストプラクティス](/ja/best-practices)を参照してください。
 
 ## 新しいコードベースを理解する
 
-### コードベースの概要を素早く取得する
+### コードベースの概要を素早く把握する
 
 新しいプロジェクトに参加したばかりで、その構造を素早く理解する必要があるとします。
 
 <Steps>
-  <Step title="プロジェクトルートディレクトリに移動する">
+  <Step title="プロジェクトのルートディレクトリに移動する">
     ```bash  theme={null}
     cd /path/to/project 
@@ -28,5 +28,5 @@
   </Step>
 
-  <Step title="高レベルの概要をリクエストする">
+  <Step title="高レベルの概要を要求する">
```

</details>

<details>
<summary>data-usage-ja.md</summary>

```diff
diff --git a/docs-ja/pages/data-usage-ja.md b/docs-ja/pages/data-usage-ja.md
index 14660b3..a135b1d 100644
--- a/docs-ja/pages/data-usage-ja.md
+++ b/docs-ja/pages/data-usage-ja.md
@@ -5,5 +5,5 @@
 # データ使用
 
-> Anthropicのデータ使用ポリシーについて学ぶ
+> Anthropic の Claude のデータ使用ポリシーについて学習します
 
 ## データポリシー
@@ -11,83 +11,86 @@
 ### データトレーニングポリシー
 
-**コンシューマーユーザー（Free、Pro、Maxプラン）**：
-将来のClaudeモデルの改善のためにデータを使用することを許可するかどうかを選択できます。この設定がオンの場合、Free、Pro、Maxアカウントからのデータを使用して新しいモデルをトレーニングします（これらのアカウントからClaude Codeを使用する場合を含む）。
+**コンシューマーユーザー（Free、Pro、Max プラン）**：
+将来の Claude モデルの改善のためにデータを使用することを許可するかどうかを選択できます。この設定がオンの場合、Free、Pro、Max アカウントからのデータを使用して新しいモデルをトレーニングします（これらのアカウントから Claude Code を使用する場合を含む）。
 
-**商用ユーザー**：（TeamおよびEnterpriseプラン、API、サードパーティプラットフォーム、およびClaude Gov）既存のポリシーを維持します。Anthropicは、商用条件の下でClaude Codeに送信されたコードまたはプロンプトを使用して生成モデルをトレーニングしません。ただし、顧客がモデル改善のためにデータを提供することを選択した場合は除きます（例えば、[Developer Partner Program](https://support.claude.com/ja/articles/11174108-about-the-development-partner-program)）。
+**商用ユーザー**：（Team および Enterprise プラン、API、サードパーティプラットフォーム、Claude Gov）既存のポリシーを維持します。Anthropic は、商用条件の下で Claude Code に送信されたコードまたはプロンプトを使用して生成モデルをトレーニングしません。ただし、カスタマーがモデル改善のためにデータを提供することを選択した場合は除きます（例えば、[Developer Partner Program](https://support.claude.com/ja/articles/11174108-about-the-development-partner-program)）。
 
 ### Development Partner Program
 
-[Development Partner Program](https://support.claude.com/ja/articles/11174108-about-the-development-partner-program)などを通じて、トレーニング用の資料を提供する方法に明示的にオプトインした場合、提供された資料を使用してモデルをトレーニングする可能性があります。組織の管理者は、組織のDevelopment Partner Programに明示的にオプトインできます。このプログラムはAnthropicファーストパーティAPIでのみ利用可能であり、BedrockまたはVertexユーザーには利用できないことに注意してください。
+[Development Partner Program](https://support.claude.com/ja/articles/11174108-about-the-development-partner-program) などを通じて、トレーニング用の資料を提供する方法に明示的にオプトインした場合、提供された資料を使用してモデルをトレーニングする可能性があります。組織管理者は、組織の Development Partner Program に明示的にオプトインできます。このプログラムは Anthropic ファーストパーティ API でのみ利用可能であり、Bedrock または Vertex ユーザーは利用できないことに注意してください。
 
-### `/bug`コマンドを使用したフィードバック
+### `/bug` コマンドを使用したフィードバック
 
```

</details>

<details>
<summary>headless-ja.md</summary>

```diff
diff --git a/docs-ja/pages/headless-ja.md b/docs-ja/pages/headless-ja.md
index d06b7af..46ffae3 100644
--- a/docs-ja/pages/headless-ja.md
+++ b/docs-ja/pages/headless-ja.md
@@ -3,15 +3,15 @@
 > Use this file to discover all available pages before exploring further.
 
-# Claude Codeをプログラムで実行する
+# Claude Code をプログラムで実行する
 
-> Agent SDKを使用して、CLI、Python、またはTypeScriptからClaudeコードをプログラムで実行します。
+> Agent SDK を使用して、CLI、Python、または TypeScript からプログラムで Claude Code を実行します。
 
-[Agent SDK](https://platform.claude.com/docs/ja/agent-sdk/overview)は、Claude Codeを支える同じツール、エージェントループ、およびコンテキスト管理を提供します。スクリプトとCI/CDのためのCLIとして、または完全なプログラムによる制御のための[Python](https://platform.claude.com/docs/ja/agent-sdk/python)および[TypeScript](https://platform.claude.com/docs/ja/agent-sdk/typescript)パッケージとして利用できます。
+[Agent SDK](https://platform.claude.com/docs/ja/agent-sdk/overview) は、Claude Code を支える同じツール、エージェントループ、およびコンテキスト管理を提供します。スクリプトと CI/CD 用の CLI として、または完全なプログラムによる制御のための [Python](https://platform.claude.com/docs/ja/agent-sdk/python) および [TypeScript](https://platform.claude.com/docs/ja/agent-sdk/typescript) パッケージとして利用できます。
 
 <Note>
-  CLIは以前「ヘッドレスモード」と呼ばれていました。`-p`フラグとすべてのCLIオプションは同じように機能します。
+  CLI は以前「headless mode」と呼ばれていました。`-p` フラグとすべての CLI オプションは同じように機能します。
 </Note>
 
-CLIからClaudeコードをプログラムで実行するには、プロンプトと任意の[CLIオプション](/ja/cli-reference)を指定して`-p`を渡します：
+CLI からプログラムで Claude Code を実行するには、プロンプトと任意の [CLI オプション](/ja/cli-reference) を指定して `-p` を渡します。
 
 ```bash  theme={null}
@@ -19,15 +19,15 @@ claude -p "Find and fix the bug in auth.py" --allowedTools "Read,Edit,Bash"
 ```
 
-このページではCLI（`claude -p`）経由でAgent SDKを使用することについて説明しています。構造化された出力、ツール承認コールバック、およびネイティブメッセージオブジェクトを備えたPythonおよびTypeScript SDKパッケージについては、[完全なAgent SDKドキュメント](https://platform.claude.com/docs/ja/agent-sdk/overview)を参照してください。
+このページでは、CLI（`claude -p`）経由で Agent SDK を使用することについて説明しています。構造化された出力、ツール承認コールバック、およびネイティブメッセージオブジェクトを備えた Python および TypeScript SDK パッケージについては、[完全な Agent SDK ドキュメント](https://platform.claude.com/docs/ja/agent-sdk/overview) を参照してください。
```

</details>

*...以降省略*

</details>

<!-- UPDATE_LOG_END -->
