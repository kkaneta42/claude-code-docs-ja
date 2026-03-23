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

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index f53466b..f230235 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,24 @@
 # Changelog
 
+## 2.1.74
+
+- Added actionable suggestions to `/context` command — identifies context-heavy tools, memory bloat, and capacity warnings with specific optimization tips
+- Added `autoMemoryDirectory` setting to configure a custom directory for auto-memory storage
+- Fixed memory leak where streaming API response buffers were not released when the generator was terminated early, causing unbounded RSS growth on the Node.js/npm code path
+- Fixed managed policy `ask` rules being bypassed by user `allow` rules or skill `allowed-tools`
+- Fixed full model IDs (e.g., `claude-opus-4-5`) being silently ignored in agent frontmatter `model:` field and `--agents` JSON config — agents now accept the same model values as `--model`
+- Fixed MCP OAuth authentication hanging when the callback port is already in use
+- Fixed MCP OAuth refresh never prompting for re-auth after the refresh token expires, for OAuth servers that return errors with HTTP 200 (e.g. Slack)
+- Fixed voice mode silently failing on the macOS native binary for users whose terminal had never been granted microphone permission — the binary now includes the `audio-input` entitlement so macOS prompts correctly
+- Fixed `SessionEnd` hooks being killed after 1.5 s on exit regardless of `hook.timeout` — now configurable via `CLAUDE_CODE_SESSIONEND_HOOKS_TIMEOUT_MS`
+- Fixed `/plugin install` failing inside the REPL for marketplace plugins with local sources
+- Fixed marketplace update not syncing git submodules — plugin sources in submodules no longer break after update
+- Fixed unknown slash commands with arguments silently dropping input — now shows your input as a warning
+- Fixed Hebrew, Arabic, and other RTL text not rendering correctly in Windows Terminal, conhost, and VS Code integrated terminal
+- Fixed LSP servers not working on Windows due to malformed file URIs
+- Changed `--plugin-dir` so local dev copies now override installed marketplace plugins with the same name (unless that plugin is force-enabled by managed settings)
+- [VSCode] Fixed delete button not working for Untitled sessions
+- [VSCode] Improved scroll wheel responsiveness in the integrated terminal with terminal-aware acceleration
+
 ## 2.1.73
 
```

</details>

<details>
<summary>claude-code-on-the-web-ja.md</summary>

```diff
diff --git a/docs-ja/pages/claude-code-on-the-web-ja.md b/docs-ja/pages/claude-code-on-the-web-ja.md
index 209f19c..c2f7bbd 100644
--- a/docs-ja/pages/claude-code-on-the-web-ja.md
+++ b/docs-ja/pages/claude-code-on-the-web-ja.md
@@ -16,12 +16,12 @@
 
 * **質問への回答**：コードアーキテクチャと機能の実装方法について質問する
-* **バグ修正とルーチンタスク**：頻繁な操舵が不要な明確に定義されたタスク
+* **バグ修正とルーチンタスク**：頻繁な操舵を必要としない明確に定義されたタスク
 * **並列作業**：複数のバグ修正を並列で処理する
 * **ローカルマシンにないリポジトリ**：ローカルにチェックアウトしていないコードで作業する
 * **バックエンド変更**：Claude Code がテストを作成してからそのテストに合格するコードを作成できる場所
 
-Claude Code は Claude アプリの [iOS](https://apps.apple.com/us/app/claude-by-anthropic/id6473753684) および [Android](https://play.google.com/store/apps/details?id=com.anthropic.claude) でも利用可能で、移動中にタスクを開始し、進行中の作業を監視できます。
+Claude Code は [iOS](https://apps.apple.com/us/app/claude-by-anthropic/id6473753684) および [Android](https://play.google.com/store/apps/details?id=com.anthropic.claude) の Claude アプリでも利用可能で、外出先でタスクを開始し、進行中の作業を監視できます。
 
-ターミナルから `--remote` を使用して[ウェブで新しいタスクを開始](#from-terminal-to-web)したり、[ウェブセッションをターミナルにテレポート](#from-web-to-terminal)してローカルで続行したりできます。クラウドインフラストラクチャの代わりに自分のマシンで Claude Code を実行しながらウェブインターフェースを使用するには、[リモートコントロール](/ja/remote-control)を参照してください。
+[ターミナルから `--remote` でウェブ上で新しいタスクを開始](#from-terminal-to-web)するか、[ウェブセッションをターミナルにテレポートして](#from-web-to-terminal)ローカルで続行できます。クラウドインフラストラクチャの代わりに自分のマシンで Claude Code を実行しながらウェブインターフェースを使用するには、[リモートコントロール](/ja/remote-control)を参照してください。
 
 ## ウェブ上の Claude Code は誰が使用できますか？
@@ -48,7 +48,7 @@ Claude Code は Claude アプリの [iOS](https://apps.apple.com/us/app/claude-b
 
 1. **リポジトリのクローン**：リポジトリが Anthropic 管理の仮想マシンにクローンされます
-2. **環境セットアップ**：Claude がコードを含むセキュアなクラウド環境を準備します
-3. **ネットワーク設定**：設定に基づいてインターネットアクセスが構成されます
-4. **タスク実行**：Claude がコードを分析し、変更を加え、テストを実行し、作業を確認します
+2. **環境セットアップ**：Claude はコードを含むセキュアなクラウド環境を準備し、設定されている場合は[セットアップスクリプト](#setup-scripts)を実行します
+3. **ネットワーク設定**：インターネットアクセスは設定に基づいて構成されます
+4. **タスク実行**：Claude はコードを分析し、変更を加え、テストを実行し、その作業を確認します
 5. **完了**：完了時に通知され、変更を含むプルリクエストを作成できます
```

</details>

<details>
<summary>cli-reference-ja.md</summary>

```diff
diff --git a/docs-ja/pages/cli-reference-ja.md b/docs-ja/pages/cli-reference-ja.md
index 4981774..8572d76 100644
--- a/docs-ja/pages/cli-reference-ja.md
+++ b/docs-ja/pages/cli-reference-ja.md
@@ -23,5 +23,5 @@
 | `claude auth login`             | Anthropic アカウントにサインイン。`--email` を使用してメールアドレスを事前入力し、`--sso` を使用して SSO 認証を強制します                                                                                    | `claude auth login --email user@example.com --sso` |
 | `claude auth logout`            | Anthropic アカウントからログアウト                                                                                                                                           | `claude auth logout`                               |
-| `claude auth status`            | 認証ステータスを JSON として表示。人間が読める形式の場合は `--text` を使用。ログイン済みの場合はコード 0 で終了、ログインしていない場合は 1 で終了                                                                             | `claude auth status`                               |
+| `claude auth status`            | 認証ステータスを JSON として表示。`--text` を使用して人間が読める形式で表示。ログイン済みの場合はコード 0 で終了、ログインしていない場合は 1 で終了                                                                             | `claude auth status`                               |
 | `claude agents`                 | すべての設定済み [subagents](/ja/sub-agents) をソース別にグループ化して一覧表示                                                                                                           | `claude agents`                                    |
 | `claude mcp`                    | Model Context Protocol（MCP）サーバーを設定                                                                                                                               | [Claude Code MCP ドキュメント](/ja/mcp) を参照してください。       |
@@ -32,74 +32,74 @@
 これらのコマンドラインフラグを使用して Claude Code の動作をカスタマイズします。
 
-| フラグ                                    | 説明                                                                                                                                                                     | 例                                                                                                  |
-| :------------------------------------- | :--------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :------------------------------------------------------------------------------------------------- |
-| `--add-dir`                            | Claude がアクセスできる追加の作業ディレクトリを追加（各パスがディレクトリとして存在することを検証）                                                                                                                  | `claude --add-dir ../apps ../lib`                                                                  |
-| `--agent`                              | 現在のセッション用のエージェントを指定（`agent` 設定をオーバーライド）                                                                                                                                | `claude --agent my-custom-agent`                                                                   |
-| `--agents`                             | JSON 経由でカスタム [subagents](/ja/sub-agents) を動的に定義（形式については以下を参照）                                                                                                          | `claude --agents '{"reviewer":{"description":"Reviews code","prompt":"You are a code reviewer"}}'` |
-| `--allow-dangerously-skip-permissions` | 権限バイパスをオプションとして有効にします（すぐには有効化しません）。`--permission-mode` と組み合わせることができます（注意して使用）                                                                                          | `claude --permission-mode plan --allow-dangerously-skip-permissions`                               |
-| `--allowedTools`                       | 権限を求めずに実行するツール。パターンマッチングについては [権限ルール構文](/ja/settings#permission-rule-syntax) を参照してください。利用可能なツールを制限するには、代わりに `--tools` を使用してください                                        | `"Bash(git log *)" "Bash(git diff *)" "Read"`                                                      |
-| `--append-system-prompt`               | カスタムテキストをデフォルトシステムプロンプトの末尾に追加（インタラクティブモードと印刷モードの両方で機能）                                                                                                                 | `claude --append-system-prompt "Always use TypeScript"`                                            |
-| `--append-system-prompt-file`          | ファイルから追加のシステムプロンプトテキストを読み込み、デフォルトプロンプトに追加（印刷モードのみ）                                                                                                                     | `claude -p --append-system-prompt-file ./extra-rules.txt "query"`                                  |
-| `--betas`                              | API リクエストに含める Beta ヘッダー（API キーユーザーのみ）                                                                                                                                  | `claude --betas interleaved-thinking`                                                              |
-| `--chrome`                             | Web 自動化とテスト用の [Chrome ブラウザ統合](/ja/chrome) を有効化                                                                                                                         | `claude --chrome`                                                                                  |
-| `--continue`, `-c`                     | 現在のディレクトリで最新の会話を読み込む                                                                                                                                                   | `claude --continue`                                                                                |
-| `--dangerously-skip-permissions`       | すべての権限プロンプトをスキップ（注意して使用）                                                                                                                                               | `claude --dangerously-skip-permissions`                                                            |
-| `--debug`                              | デバッグモードを有効化（オプションのカテゴリフィルタリング付き。例：`"api,hooks"` または `"!statsig,!file"`）                                                                                                | `claude --debug "api,mcp"`                                                                         |
-| `--disable-slash-commands`             | このセッションのすべてのスキルとコマンドを無効化                                                                                                                                               | `claude --disable-slash-commands`                                                                  |
-| `--disallowedTools`                    | モデルのコンテキストから削除され、使用できないツール                                                                                                                                             | `"Bash(git log *)" "Bash(git diff *)" "Edit"`                                                      |
```

</details>

*...以降省略*

</details>


<details>
<summary>2026-03-12</summary>

**変更ファイル:**

```
 docs-ja/pages/agent-teams-ja.md           |  4 ++--
 docs-ja/pages/changelog.md                | 29 +++++++++++++++++++++++++++++
 docs-ja/pages/data-usage-ja.md            |  2 +-
 docs-ja/pages/desktop-quickstart-en.md    |  4 ++--
 docs-ja/pages/features-overview-ja.md     |  2 +-
 docs-ja/pages/hooks-ja.md                 |  4 ++--
 docs-ja/pages/how-claude-code-works-ja.md |  4 ++--
 docs-ja/pages/statusline-ja.md            | 14 +++++++-------
 docs-ja/pages/vs-code-ja.md               | 10 +++++-----
 9 files changed, 51 insertions(+), 22 deletions(-)
```

<details>
<summary>agent-teams-ja.md</summary>

```diff
diff --git a/docs-ja/pages/agent-teams-ja.md b/docs-ja/pages/agent-teams-ja.md
index cb1edf7..3257876 100644
--- a/docs-ja/pages/agent-teams-ja.md
+++ b/docs-ja/pages/agent-teams-ja.md
@@ -38,7 +38,7 @@
 
 <Frame caption="Subagents は結果をメインエージェントに報告するだけで、互いに話しません。エージェントチームでは、チームメイトがタスクリストを共有し、作業を要求し、互いに直接通信します。">
-  <img src="https://mintcdn.com/claude-code/nsvRFSDNfpSU5nT7/images/subagents-vs-agent-teams-light.png?fit=max&auto=format&n=nsvRFSDNfpSU5nT7&q=85&s=2f8db9b4f3705dd3ab931fbe2d96e42a" className="dark:hidden" alt="Subagent とエージェントチームアーキテクチャを比較する図。Subagent はメインエージェントによって生成され、作業を実行し、結果を報告します。エージェントチームは共有タスクリストを通じて調整し、チームメイトが互いに直接通信します。" data-og-width="4245" width="4245" data-og-height="1615" height="1615" data-path="images/subagents-vs-agent-teams-light.png" data-optimize="true" data-opv="3" srcset="https://mintcdn.com/claude-code/nsvRFSDNfpSU5nT7/images/subagents-vs-agent-teams-light.png?w=280&fit=max&auto=format&n=nsvRFSDNfpSU5nT7&q=85&s=a2cfe413c2084b477be40ac8723d9d40 280w, https://mintcdn.com/claude-code/nsvRFSDNfpSU5nT7/images/subagents-vs-agent-teams-light.png?w=560&fit=max&auto=format&n=nsvRFSDNfpSU5nT7&q=85&s=c642c09a4c211b10b35eee7d7d0d149f 560w, https://mintcdn.com/claude-code/nsvRFSDNfpSU5nT7/images/subagents-vs-agent-teams-light.png?w=840&fit=max&auto=format&n=nsvRFSDNfpSU5nT7&q=85&s=40d286f77c8a4075346b4fcaa2b36248 840w, https://mintcdn.com/claude-code/nsvRFSDNfpSU5nT7/images/subagents-vs-agent-teams-light.png?w=1100&fit=max&auto=format&n=nsvRFSDNfpSU5nT7&q=85&s=923986caa23c0ef2c27d7e45f4dce6d1 1100w, https://mintcdn.com/claude-code/nsvRFSDNfpSU5nT7/images/subagents-vs-agent-teams-light.png?w=1650&fit=max&auto=format&n=nsvRFSDNfpSU5nT7&q=85&s=17a730a070db6d71d029a98b074c68e8 1650w, https://mintcdn.com/claude-code/nsvRFSDNfpSU5nT7/images/subagents-vs-agent-teams-light.png?w=2500&fit=max&auto=format&n=nsvRFSDNfpSU5nT7&q=85&s=e402533fc9e8b5e8d26a835cc4aa1742 2500w" />
+  <img src="https://mintcdn.com/claude-code/nsvRFSDNfpSU5nT7/images/subagents-vs-agent-teams-light.png?fit=max&auto=format&n=nsvRFSDNfpSU5nT7&q=85&s=2f8db9b4f3705dd3ab931fbe2d96e42a" className="dark:hidden" alt="Subagent とエージェントチームアーキテクチャを比較する図。Subagent はメインエージェントによって生成され、作業を実行し、結果を報告します。エージェントチームは共有タスクリストを通じて調整し、チームメイトが互いに直接通信します。" width="4245" height="1615" data-path="images/subagents-vs-agent-teams-light.png" />
 
-  <img src="https://mintcdn.com/claude-code/nsvRFSDNfpSU5nT7/images/subagents-vs-agent-teams-dark.png?fit=max&auto=format&n=nsvRFSDNfpSU5nT7&q=85&s=d573a037540f2ada6a9ae7d8285b46fd" className="hidden dark:block" alt="Subagent とエージェントチームアーキテクチャを比較する図。Subagent はメインエージェントによって生成され、作業を実行し、結果を報告します。エージェントチームは共有タスクリストを通じて調整し、チームメイトが互いに直接通信します。" data-og-width="4245" width="4245" data-og-height="1615" height="1615" data-path="images/subagents-vs-agent-teams-dark.png" data-optimize="true" data-opv="3" srcset="https://mintcdn.com/claude-code/nsvRFSDNfpSU5nT7/images/subagents-vs-agent-teams-dark.png?w=280&fit=max&auto=format&n=nsvRFSDNfpSU5nT7&q=85&s=06ca5b18b232855acc488357d8d01fa7 280w, https://mintcdn.com/claude-code/nsvRFSDNfpSU5nT7/images/subagents-vs-agent-teams-dark.png?w=560&fit=max&auto=format&n=nsvRFSDNfpSU5nT7&q=85&s=3d34daee83994781eb74b74d1ed511c4 560w, https://mintcdn.com/claude-code/nsvRFSDNfpSU5nT7/images/subagents-vs-agent-teams-dark.png?w=840&fit=max&auto=format&n=nsvRFSDNfpSU5nT7&q=85&s=82ea35ac837de7d674002de69689b9cf 840w, https://mintcdn.com/claude-code/nsvRFSDNfpSU5nT7/images/subagents-vs-agent-teams-dark.png?w=1100&fit=max&auto=format&n=nsvRFSDNfpSU5nT7&q=85&s=3653085214a9fc65d1f589044894a296 1100w, https://mintcdn.com/claude-code/nsvRFSDNfpSU5nT7/images/subagents-vs-agent-teams-dark.png?w=1650&fit=max&auto=format&n=nsvRFSDNfpSU5nT7&q=85&s=8e74b42694e428570e876d34f29e6ad6 1650w, https://mintcdn.com/claude-code/nsvRFSDNfpSU5nT7/images/subagents-vs-agent-teams-dark.png?w=2500&fit=max&auto=format&n=nsvRFSDNfpSU5nT7&q=85&s=3be00c56c6a0dcccbe15640020be0128 2500w" />
+  <img src="https://mintcdn.com/claude-code/nsvRFSDNfpSU5nT7/images/subagents-vs-agent-teams-dark.png?fit=max&auto=format&n=nsvRFSDNfpSU5nT7&q=85&s=d573a037540f2ada6a9ae7d8285b46fd" className="hidden dark:block" alt="Subagent とエージェントチームアーキテクチャを比較する図。Subagent はメインエージェントによって生成され、作業を実行し、結果を報告します。エージェントチームは共有タスクリストを通じて調整し、チームメイトが互いに直接通信します。" width="4245" height="1615" data-path="images/subagents-vs-agent-teams-dark.png" />
 </Frame>
 
```

</details>

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index 9030b86..f53466b 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,33 @@
 # Changelog
 
+## 2.1.73
+
+- Added `modelOverrides` setting to map model picker entries to custom provider model IDs (e.g. Bedrock inference profile ARNs)
+- Added actionable guidance when OAuth login or connectivity checks fail due to SSL certificate errors (corporate proxies, `NODE_EXTRA_CA_CERTS`)
+- Fixed freezes and 100% CPU loops triggered by permission prompts for complex bash commands
+- Fixed a deadlock that could freeze Claude Code when many skill files changed at once (e.g. during `git pull` in a repo with a large `.claude/skills/` directory)
+- Fixed Bash tool output being lost when running multiple Claude Code sessions in the same project directory
+- Fixed subagents with `model: opus`/`sonnet`/`haiku` being silently downgraded to older model versions on Bedrock, Vertex, and Microsoft Foundry
+- Fixed background bash processes spawned by subagents not being cleaned up when the agent exits
+- Fixed `/resume` showing the current session in the picker
+- Fixed `/ide` crashing with `onInstall is not defined` when auto-installing the extension
+- Fixed `/loop` not being available on Bedrock/Vertex/Foundry and when telemetry was disabled
+- Fixed SessionStart hooks firing twice when resuming a session via `--resume` or `--continue`
+- Fixed JSON-output hooks injecting no-op system-reminder messages into the model's context on every turn
+- Fixed voice mode session corruption when a slow connection overlaps a new recording
+- Fixed Linux sandbox failing to start with "ripgrep (rg) not found" on native builds
+- Fixed Linux native modules not loading on Amazon Linux 2 and other glibc 2.26 systems
+- Fixed "media_type: Field required" API error when receiving images via Remote Control
+- Fixed `/heapdump` failing on Windows with `EEXIST` error when the Desktop folder already exists
+- Improved Up arrow after interrupting Claude — now restores the interrupted prompt and rewinds the conversation in one step
+- Improved IDE detection speed at startup
+- Improved clipboard image pasting performance on macOS
+- Improved `/effort` to work while Claude is responding, matching `/model` behavior
```

</details>

<details>
<summary>data-usage-ja.md</summary>

```diff
diff --git a/docs-ja/pages/data-usage-ja.md b/docs-ja/pages/data-usage-ja.md
index d10bcf9..da76c70 100644
--- a/docs-ja/pages/data-usage-ja.md
+++ b/docs-ja/pages/data-usage-ja.md
@@ -60,5 +60,5 @@ Web 上の個別の Claude Code セッションはいつでも削除できます
 以下の図は、インストール中および通常の操作中に Claude Code が外部サービスにどのように接続するかを示しています。実線は必須の接続を示し、破線はオプションまたはユーザーが開始したデータフローを表します。
 
-<img src="https://mintcdn.com/claude-code/TBPmHzr19mDCuhZi/images/claude-code-data-flow.svg?fit=max&auto=format&n=TBPmHzr19mDCuhZi&q=85&s=e0239c69a0bbae485b726338e50f1082" alt="Claude Code の外部接続を示す図：インストール/更新は NPM に接続し、ユーザーリクエストは Console 認証、public-api、およびオプションで Statsig、Sentry、バグレポートを含む Anthropic サービスに接続します" data-og-width="720" width="720" data-og-height="520" height="520" data-path="images/claude-code-data-flow.svg" data-optimize="true" data-opv="3" srcset="https://mintcdn.com/claude-code/TBPmHzr19mDCuhZi/images/claude-code-data-flow.svg?w=280&fit=max&auto=format&n=TBPmHzr19mDCuhZi&q=85&s=06435e080df22e66a454e99af1b6040b 280w, https://mintcdn.com/claude-code/TBPmHzr19mDCuhZi/images/claude-code-data-flow.svg?w=560&fit=max&auto=format&n=TBPmHzr19mDCuhZi&q=85&s=8261c15b4ffc12504e0a6e3f0ccd8c7d 560w, https://mintcdn.com/claude-code/TBPmHzr19mDCuhZi/images/claude-code-data-flow.svg?w=840&fit=max&auto=format&n=TBPmHzr19mDCuhZi&q=85&s=163bfaa8d4727a1bbb492cb086e5f083 840w, https://mintcdn.com/claude-code/TBPmHzr19mDCuhZi/images/claude-code-data-flow.svg?w=1100&fit=max&auto=format&n=TBPmHzr19mDCuhZi&q=85&s=ea3c2f801dfa5ad956b18b5f72df5c50 1100w, https://mintcdn.com/claude-code/TBPmHzr19mDCuhZi/images/claude-code-data-flow.svg?w=1650&fit=max&auto=format&n=TBPmHzr19mDCuhZi&q=85&s=91d743def7a8d074c93001b351f23037 1650w, https://mintcdn.com/claude-code/TBPmHzr19mDCuhZi/images/claude-code-data-flow.svg?w=2500&fit=max&auto=format&n=TBPmHzr19mDCuhZi&q=85&s=df68b2dd6de83316f70fd7f61c3a3bbd 2500w" />
+<img src="https://mintcdn.com/claude-code/TBPmHzr19mDCuhZi/images/claude-code-data-flow.svg?fit=max&auto=format&n=TBPmHzr19mDCuhZi&q=85&s=e0239c69a0bbae485b726338e50f1082" alt="Claude Code の外部接続を示す図：インストール/更新は NPM に接続し、ユーザーリクエストは Console 認証、public-api、およびオプションで Statsig、Sentry、バグレポートを含む Anthropic サービスに接続します" width="720" height="520" data-path="images/claude-code-data-flow.svg" />
 
 Claude Code は [NPM](https://www.npmjs.com/package/@anthropic-ai/claude-code) からインストールされます。Claude Code はローカルで実行されます。LLM と対話するために、Claude Code はネットワーク経由でデータを送信します。このデータには、すべてのユーザープロンプトとモデル出力が含まれます。データは TLS 経由で転送中に暗号化され、保存時には暗号化されません。Claude Code はほとんどの一般的な VPN および LLM プロキシと互換性があります。
```

</details>

<details>
<summary>desktop-quickstart-en.md</summary>

```diff
diff --git a/docs-ja/pages/desktop-quickstart-en.md b/docs-ja/pages/desktop-quickstart-en.md
index a0e5f72..1eae904 100644
--- a/docs-ja/pages/desktop-quickstart-en.md
+++ b/docs-ja/pages/desktop-quickstart-en.md
@@ -12,7 +12,7 @@ This page walks through installing the app and starting your first session. If y
 
 <Frame>
-  <img src="https://mintcdn.com/claude-code/CNLUpFGiXoc9mhvD/images/desktop-code-tab-light.png?fit=max&auto=format&n=CNLUpFGiXoc9mhvD&q=85&s=9a36a7a27b9f4c6f2e1c83bdb34f69ce" className="block dark:hidden" alt="The Claude Code Desktop interface showing the Code tab selected, with a prompt box, permission mode selector set to Ask permissions, model picker, folder selector, and Local environment option" data-og-width="2500" width="2500" data-og-height="1376" height="1376" data-path="images/desktop-code-tab-light.png" data-optimize="true" data-opv="3" srcset="https://mintcdn.com/claude-code/CNLUpFGiXoc9mhvD/images/desktop-code-tab-light.png?w=280&fit=max&auto=format&n=CNLUpFGiXoc9mhvD&q=85&s=b4d1408a312d3ff3ac96dd133e4ef32b 280w, https://mintcdn.com/claude-code/CNLUpFGiXoc9mhvD/images/desktop-code-tab-light.png?w=560&fit=max&auto=format&n=CNLUpFGiXoc9mhvD&q=85&s=c2d9f668767d4de33696b3de190c0024 560w, https://mintcdn.com/claude-code/CNLUpFGiXoc9mhvD/images/desktop-code-tab-light.png?w=840&fit=max&auto=format&n=CNLUpFGiXoc9mhvD&q=85&s=89a78335d513c0ec2131feb11eeef6dc 840w, https://mintcdn.com/claude-code/CNLUpFGiXoc9mhvD/images/desktop-code-tab-light.png?w=1100&fit=max&auto=format&n=CNLUpFGiXoc9mhvD&q=85&s=0ef93540eafcedd2fb0ad718553325f4 1100w, https://mintcdn.com/claude-code/CNLUpFGiXoc9mhvD/images/desktop-code-tab-light.png?w=1650&fit=max&auto=format&n=CNLUpFGiXoc9mhvD&q=85&s=e7923c583f632de9f8a7e0e0da4f8c84 1650w, https://mintcdn.com/claude-code/CNLUpFGiXoc9mhvD/images/desktop-code-tab-light.png?w=2500&fit=max&auto=format&n=CNLUpFGiXoc9mhvD&q=85&s=38d64bdceaba941a73446f258be336ea 2500w" />
+  <img src="https://mintcdn.com/claude-code/CNLUpFGiXoc9mhvD/images/desktop-code-tab-light.png?fit=max&auto=format&n=CNLUpFGiXoc9mhvD&q=85&s=9a36a7a27b9f4c6f2e1c83bdb34f69ce" className="block dark:hidden" alt="The Claude Code Desktop interface showing the Code tab selected, with a prompt box, permission mode selector set to Ask permissions, model picker, folder selector, and Local environment option" width="2500" height="1376" data-path="images/desktop-code-tab-light.png" />
 
-  <img src="https://mintcdn.com/claude-code/CNLUpFGiXoc9mhvD/images/desktop-code-tab-dark.png?fit=max&auto=format&n=CNLUpFGiXoc9mhvD&q=85&s=5463defe81c459fb9b1f91f6a958cfb8" className="hidden dark:block" alt="The Claude Code Desktop interface in dark mode showing the Code tab selected, with a prompt box, permission mode selector set to Ask permissions, model picker, folder selector, and Local environment option" data-og-width="2504" width="2504" data-og-height="1374" height="1374" data-path="images/desktop-code-tab-dark.png" data-optimize="true" data-opv="3" srcset="https://mintcdn.com/claude-code/CNLUpFGiXoc9mhvD/images/desktop-code-tab-dark.png?w=280&fit=max&auto=format&n=CNLUpFGiXoc9mhvD&q=85&s=f2a6322688262feb9d680b99c24817ab 280w, https://mintcdn.com/claude-code/CNLUpFGiXoc9mhvD/images/desktop-code-tab-dark.png?w=560&fit=max&auto=format&n=CNLUpFGiXoc9mhvD&q=85&s=ffe9a3d1c4260fb12c66f533fdedc02e 560w, https://mintcdn.com/claude-code/CNLUpFGiXoc9mhvD/images/desktop-code-tab-dark.png?w=840&fit=max&auto=format&n=CNLUpFGiXoc9mhvD&q=85&s=867b7997a910af3ffac1101559564dd7 840w, https://mintcdn.com/claude-code/CNLUpFGiXoc9mhvD/images/desktop-code-tab-dark.png?w=1100&fit=max&auto=format&n=CNLUpFGiXoc9mhvD&q=85&s=976c9049c9e4cea2b02d4b6a1ef55142 1100w, https://mintcdn.com/claude-code/CNLUpFGiXoc9mhvD/images/desktop-code-tab-dark.png?w=1650&fit=max&auto=format&n=CNLUpFGiXoc9mhvD&q=85&s=d8f3792ddadf66f61306dc41680aaa34 1650w, https://mintcdn.com/claude-code/CNLUpFGiXoc9mhvD/images/desktop-code-tab-dark.png?w=2500&fit=max&auto=format&n=CNLUpFGiXoc9mhvD&q=85&s=88d049488f547e483e8c4f59ea8b2fd8 2500w" />
+  <img src="https://mintcdn.com/claude-code/CNLUpFGiXoc9mhvD/images/desktop-code-tab-dark.png?fit=max&auto=format&n=CNLUpFGiXoc9mhvD&q=85&s=5463defe81c459fb9b1f91f6a958cfb8" className="hidden dark:block" alt="The Claude Code Desktop interface in dark mode showing the Code tab selected, with a prompt box, permission mode selector set to Ask permissions, model picker, folder selector, and Local environment option" width="2504" height="1374" data-path="images/desktop-code-tab-dark.png" />
 </Frame>
 
```

</details>

<details>
<summary>features-overview-ja.md</summary>

```diff
diff --git a/docs-ja/pages/features-overview-ja.md b/docs-ja/pages/features-overview-ja.md
index 219f5c6..93f6602 100644
--- a/docs-ja/pages/features-overview-ja.md
+++ b/docs-ja/pages/features-overview-ja.md
@@ -189,5 +189,5 @@ Claude Code は、コードについて推論するモデルと、ファイル
 各機能はセッション内の異なるポイントでロードされます。以下のタブは、各機能がいつロードされるか、およびコンテキストに何が入るかを説明しています。
 
-<img src="https://mintcdn.com/claude-code/TBPmHzr19mDCuhZi/images/context-loading.svg?fit=max&auto=format&n=TBPmHzr19mDCuhZi&q=85&s=43114d93ae62bdc1ab6aa64660e2ba3b" alt="コンテキストロード：CLAUDE.md と MCP はセッション開始時にロードされ、すべてのリクエストに留まります。スキルは開始時に説明をロードし、呼び出し時に完全なコンテンツをロードします。Subagents は独立したコンテキストを取得します。Hooks は外部で実行されます。" data-og-width="720" width="720" data-og-height="410" height="410" data-path="images/context-loading.svg" data-optimize="true" data-opv="3" srcset="https://mintcdn.com/claude-code/TBPmHzr19mDCuhZi/images/context-loading.svg?w=280&fit=max&auto=format&n=TBPmHzr19mDCuhZi&q=85&s=cc37ac2b6b486c75dea4cf64add648ec 280w, https://mintcdn.com/claude-code/TBPmHzr19mDCuhZi/images/context-loading.svg?w=560&fit=max&auto=format&n=TBPmHzr19mDCuhZi&q=85&s=22394bf8452988091802c6bc471a3153 560w, https://mintcdn.com/claude-code/TBPmHzr19mDCuhZi/images/context-loading.svg?w=840&fit=max&auto=format&n=TBPmHzr19mDCuhZi&q=85&s=aaf0301abbd63349b3f5ecf27f3bc4c5 840w, https://mintcdn.com/claude-code/TBPmHzr19mDCuhZi/images/context-loading.svg?w=1100&fit=max&auto=format&n=TBPmHzr19mDCuhZi&q=85&s=f262d974340400cfd964c555b523808a 1100w, https://mintcdn.com/claude-code/TBPmHzr19mDCuhZi/images/context-loading.svg?w=1650&fit=max&auto=format&n=TBPmHzr19mDCuhZi&q=85&s=430b76391f55ba65a0a3da569a52a450 1650w, https://mintcdn.com/claude-code/TBPmHzr19mDCuhZi/images/context-loading.svg?w=2500&fit=max&auto=format&n=TBPmHzr19mDCuhZi&q=85&s=46522043165b15cfef464d5f63c70f7c 2500w" />
+<img src="https://mintcdn.com/claude-code/TBPmHzr19mDCuhZi/images/context-loading.svg?fit=max&auto=format&n=TBPmHzr19mDCuhZi&q=85&s=43114d93ae62bdc1ab6aa64660e2ba3b" alt="コンテキストロード：CLAUDE.md と MCP はセッション開始時にロードされ、すべてのリクエストに留まります。スキルは開始時に説明をロードし、呼び出し時に完全なコンテンツをロードします。Subagents は独立したコンテキストを取得します。Hooks は外部で実行されます。" width="720" height="410" data-path="images/context-loading.svg" />
 
 <Tabs>
```

</details>

<details>
<summary>hooks-ja.md</summary>

```diff
diff --git a/docs-ja/pages/hooks-ja.md b/docs-ja/pages/hooks-ja.md
index 1a35bf4..6714bf6 100644
--- a/docs-ja/pages/hooks-ja.md
+++ b/docs-ja/pages/hooks-ja.md
@@ -19,5 +19,5 @@
 <div style={{maxWidth: "500px", margin: "0 auto"}}>
   <Frame>
-    <img src="https://mintcdn.com/claude-code/JWoaQLhotXStH4d2/images/hooks-lifecycle.svg?fit=max&auto=format&n=JWoaQLhotXStH4d2&q=85&s=9310bd002ef90ca32ac668455f5580a0" alt="SessionStart から agentic ループを経由して SessionEnd までのフックのシーケンスを示すフック ライフサイクル図。WorktreeCreate と WorktreeRemove はスタンドアロンのセットアップおよびティアダウン イベント" data-og-width="520" width="520" data-og-height="1020" height="1020" data-path="images/hooks-lifecycle.svg" data-optimize="true" data-opv="3" srcset="https://mintcdn.com/claude-code/JWoaQLhotXStH4d2/images/hooks-lifecycle.svg?w=280&fit=max&auto=format&n=JWoaQLhotXStH4d2&q=85&s=109982de941b0c53206b6178f4982f64 280w, https://mintcdn.com/claude-code/JWoaQLhotXStH4d2/images/hooks-lifecycle.svg?w=560&fit=max&auto=format&n=JWoaQLhotXStH4d2&q=85&s=9375684c8578b8ffe598d3798a59448c 560w, https://mintcdn.com/claude-code/JWoaQLhotXStH4d2/images/hooks-lifecycle.svg?w=840&fit=max&auto=format&n=JWoaQLhotXStH4d2&q=85&s=ee44a68c8feaabf5e7d09e65f3d653ae 840w, https://mintcdn.com/claude-code/JWoaQLhotXStH4d2/images/hooks-lifecycle.svg?w=1100&fit=max&auto=format&n=JWoaQLhotXStH4d2&q=85&s=4f35067e11e2d1861513ae8faf92cc04 1100w, https://mintcdn.com/claude-code/JWoaQLhotXStH4d2/images/hooks-lifecycle.svg?w=1650&fit=max&auto=format&n=JWoaQLhotXStH4d2&q=85&s=abf63881fb2c5cce211ac8ebb37af504 1650w, https://mintcdn.com/claude-code/JWoaQLhotXStH4d2/images/hooks-lifecycle.svg?w=2500&fit=max&auto=format&n=JWoaQLhotXStH4d2&q=85&s=e804d84b83ff44107fd2195c73e1c2ac 2500w" />
+    <img src="https://mintcdn.com/claude-code/JWoaQLhotXStH4d2/images/hooks-lifecycle.svg?fit=max&auto=format&n=JWoaQLhotXStH4d2&q=85&s=9310bd002ef90ca32ac668455f5580a0" alt="SessionStart から agentic ループを経由して SessionEnd までのフックのシーケンスを示すフック ライフサイクル図。WorktreeCreate と WorktreeRemove はスタンドアロンのセットアップおよびティアダウン イベント" width="520" height="1020" data-path="images/hooks-lifecycle.svg" />
   </Frame>
 </div>
@@ -91,5 +91,5 @@ fi
 
 <Frame>
-  <img src="https://mintcdn.com/claude-code/TBPmHzr19mDCuhZi/images/hook-resolution.svg?fit=max&auto=format&n=TBPmHzr19mDCuhZi&q=85&s=5bb890134390ecd0581477cf41ef730b" alt="フック解決フロー: PreToolUse イベントが発火し、マッチャーが Bash マッチをチェックし、フック ハンドラーが実行され、結果が Claude Code に返される" data-og-width="780" width="780" data-og-height="290" height="290" data-path="images/hook-resolution.svg" data-optimize="true" data-opv="3" srcset="https://mintcdn.com/claude-code/TBPmHzr19mDCuhZi/images/hook-resolution.svg?w=280&fit=max&auto=format&n=TBPmHzr19mDCuhZi&q=85&s=5dcaecd24c260b8a90365d74e2c1fcda 280w, https://mintcdn.com/claude-code/TBPmHzr19mDCuhZi/images/hook-resolution.svg?w=560&fit=max&auto=format&n=TBPmHzr19mDCuhZi&q=85&s=c03d91c279f01d92e58ddd70fdbe66f2 560w, https://mintcdn.com/claude-code/TBPmHzr19mDCuhZi/images/hook-resolution.svg?w=840&fit=max&auto=format&n=TBPmHzr19mDCuhZi&q=85&s=1be57a4819cbb949a5ea9d08a05c9ecd 840w, https://mintcdn.com/claude-code/TBPmHzr19mDCuhZi/images/hook-resolution.svg?w=1100&fit=max&auto=format&n=TBPmHzr19mDCuhZi&q=85&s=0e9dd1807dc7a5c56011d0889b0d5208 1100w, https://mintcdn.com/claude-code/TBPmHzr19mDCuhZi/images/hook-resolution.svg?w=1650&fit=max&auto=format&n=TBPmHzr19mDCuhZi&q=85&s=69496ac02e70fabfece087ba31a1dcfc 1650w, https://mintcdn.com/claude-code/TBPmHzr19mDCuhZi/images/hook-resolution.svg?w=2500&fit=max&auto=format&n=TBPmHzr19mDCuhZi&q=85&s=a012346cb46a33b86580348802055267 2500w" />
+  <img src="https://mintcdn.com/claude-code/TBPmHzr19mDCuhZi/images/hook-resolution.svg?fit=max&auto=format&n=TBPmHzr19mDCuhZi&q=85&s=5bb890134390ecd0581477cf41ef730b" alt="フック解決フロー: PreToolUse イベントが発火し、マッチャーが Bash マッチをチェックし、フック ハンドラーが実行され、結果が Claude Code に返される" width="780" height="290" data-path="images/hook-resolution.svg" />
 </Frame>
 
```

</details>

<details>
<summary>how-claude-code-works-ja.md</summary>

```diff
diff --git a/docs-ja/pages/how-claude-code-works-ja.md b/docs-ja/pages/how-claude-code-works-ja.md
index a94a113..42d1862 100644
--- a/docs-ja/pages/how-claude-code-works-ja.md
+++ b/docs-ja/pages/how-claude-code-works-ja.md
@@ -15,5 +15,5 @@ Claude Code はターミナルで実行される agentic アシスタントで
 Claude にタスクを与えると、3 つのフェーズを通じて作業します。**コンテキストの収集**、**アクションの実行**、**結果の検証** です。これらのフェーズは相互に融合しています。Claude はツールを使用して、コードを理解するためにファイルを検索したり、変更を加えるために編集したり、作業を確認するためにテストを実行したりします。
 
-<img src="https://mintcdn.com/claude-code/TBPmHzr19mDCuhZi/images/agentic-loop.svg?fit=max&auto=format&n=TBPmHzr19mDCuhZi&q=85&s=9d9cdb2102f397a0f57450ca5ca2a969" alt="agentic ループ: プロンプトから Claude がコンテキストを収集し、アクションを実行し、結果を検証し、タスク完了まで繰り返します。任意の時点で中断できます。" data-og-width="720" width="720" data-og-height="280" height="280" data-path="images/agentic-loop.svg" data-optimize="true" data-opv="3" srcset="https://mintcdn.com/claude-code/TBPmHzr19mDCuhZi/images/agentic-loop.svg?w=280&fit=max&auto=format&n=TBPmHzr19mDCuhZi&q=85&s=9c6a590754c1c1b281d40fc9f10fed0d 280w, https://mintcdn.com/claude-code/TBPmHzr19mDCuhZi/images/agentic-loop.svg?w=560&fit=max&auto=format&n=TBPmHzr19mDCuhZi&q=85&s=9fb2f2fc174e285797cad25a9ca2a326 560w, https://mintcdn.com/claude-code/TBPmHzr19mDCuhZi/images/agentic-loop.svg?w=840&fit=max&auto=format&n=TBPmHzr19mDCuhZi&q=85&s=3a1b68dd7b861e8ff25391773d8ab60c 840w, https://mintcdn.com/claude-code/TBPmHzr19mDCuhZi/images/agentic-loop.svg?w=1100&fit=max&auto=format&n=TBPmHzr19mDCuhZi&q=85&s=e64edf9f5cbc62464617945cf08ef134 1100w, https://mintcdn.com/claude-code/TBPmHzr19mDCuhZi/images/agentic-loop.svg?w=1650&fit=max&auto=format&n=TBPmHzr19mDCuhZi&q=85&s=3bf3319e76669f11513c6bcc5bf86feb 1650w, https://mintcdn.com/claude-code/TBPmHzr19mDCuhZi/images/agentic-loop.svg?w=2500&fit=max&auto=format&n=TBPmHzr19mDCuhZi&q=85&s=9413880a191409ff3c81bafc8f7ab977 2500w" />
+<img src="https://mintcdn.com/claude-code/TBPmHzr19mDCuhZi/images/agentic-loop.svg?fit=max&auto=format&n=TBPmHzr19mDCuhZi&q=85&s=9d9cdb2102f397a0f57450ca5ca2a969" alt="agentic ループ: プロンプトから Claude がコンテキストを収集し、アクションを実行し、結果を検証し、タスク完了まで繰り返します。任意の時点で中断できます。" width="720" height="280" data-path="images/agentic-loop.svg" />
 
 ループは、質問の内容に応じて適応します。コードベースに関する質問は、コンテキスト収集のみが必要な場合があります。バグ修正は 3 つのフェーズすべてを繰り返し循環します。リファクタリングは広範な検証を伴う場合があります。Claude は前のステップから学んだことに基づいて各ステップが何を必要とするかを決定し、数十のアクションを連鎖させ、途中で軌道修正します。
@@ -111,5 +111,5 @@ Claude は現在のブランチのファイルを見ます。ブランチを切
 `claude --continue` または `claude --resume` でセッションを再開すると、同じセッション ID を使用して中断したところから再開します。新しいメッセージは既存の会話に追加されます。完全な会話履歴が復元されますが、セッション スコープの権限は復元されません。それらを再度承認する必要があります。
 
-<img src="https://mintcdn.com/claude-code/TBPmHzr19mDCuhZi/images/session-continuity.svg?fit=max&auto=format&n=TBPmHzr19mDCuhZi&q=85&s=808da1b213c731bf98874c75981d688b" alt="セッション継続性: 再開は同じセッションを続行し、フォークは新しい ID で新しいブランチを作成します。" data-og-width="560" width="560" data-og-height="280" height="280" data-path="images/session-continuity.svg" data-optimize="true" data-opv="3" srcset="https://mintcdn.com/claude-code/TBPmHzr19mDCuhZi/images/session-continuity.svg?w=280&fit=max&auto=format&n=TBPmHzr19mDCuhZi&q=85&s=ba75f64bc571f3ef84a3237ef795bf22 280w, https://mintcdn.com/claude-code/TBPmHzr19mDCuhZi/images/session-continuity.svg?w=560&fit=max&auto=format&n=TBPmHzr19mDCuhZi&q=85&s=343ad422a171a2b909c87ed01c768745 560w, https://mintcdn.com/claude-code/TBPmHzr19mDCuhZi/images/session-continuity.svg?w=840&fit=max&auto=format&n=TBPmHzr19mDCuhZi&q=85&s=afce54d5e3b08cdb54d506332462b74c 840w, https://mintcdn.com/claude-code/TBPmHzr19mDCuhZi/images/session-continuity.svg?w=1100&fit=max&auto=format&n=TBPmHzr19mDCuhZi&q=85&s=28648c0a04cf7aef2de02d1c98491965 1100w, https://mintcdn.com/claude-code/TBPmHzr19mDCuhZi/images/session-continuity.svg?w=1650&fit=max&auto=format&n=TBPmHzr19mDCuhZi&q=85&s=a5287882beedaea54af606f682e4818d 1650w, https://mintcdn.com/claude-code/TBPmHzr19mDCuhZi/images/session-continuity.svg?w=2500&fit=max&auto=format&n=TBPmHzr19mDCuhZi&q=85&s=f392dbe67b63eead4a2aae67adfbfdbe 2500w" />
+<img src="https://mintcdn.com/claude-code/TBPmHzr19mDCuhZi/images/session-continuity.svg?fit=max&auto=format&n=TBPmHzr19mDCuhZi&q=85&s=808da1b213c731bf98874c75981d688b" alt="セッション継続性: 再開は同じセッションを続行し、フォークは新しい ID で新しいブランチを作成します。" width="560" height="280" data-path="images/session-continuity.svg" />
 
 元のセッションに影響を与えずに別のアプローチを試すために分岐するには、`--fork-session` フラグを使用します。
```

</details>

<details>
<summary>statusline-ja.md</summary>

```diff
diff --git a/docs-ja/pages/statusline-ja.md b/docs-ja/pages/statusline-ja.md
index 4cf0f42..1df0a79 100644
--- a/docs-ja/pages/statusline-ja.md
+++ b/docs-ja/pages/statusline-ja.md
@@ -19,5 +19,5 @@
 
 <Frame>
-  <img src="https://mintcdn.com/claude-code/nibzesLaJVh4ydOq/images/statusline-multiline.png?fit=max&auto=format&n=nibzesLaJVh4ydOq&q=85&s=60f11387658acc9ff75158ae85f2ac87" alt="最初の行にモデル名、ディレクトリ、git ブランチを表示し、2 番目の行にコンテキスト使用状況プログレスバー、コスト、期間を表示する複数行ステータスライン" data-og-width="776" width="776" data-og-height="212" height="212" data-path="images/statusline-multiline.png" data-optimize="true" data-opv="3" srcset="https://mintcdn.com/claude-code/nibzesLaJVh4ydOq/images/statusline-multiline.png?w=280&fit=max&auto=format&n=nibzesLaJVh4ydOq&q=85&s=2e448b44c332620e6c9c2be4ded992e5 280w, https://mintcdn.com/claude-code/nibzesLaJVh4ydOq/images/statusline-multiline.png?w=560&fit=max&auto=format&n=nibzesLaJVh4ydOq&q=85&s=f796af2db9c68ab2ddbc5136840b9551 560w, https://mintcdn.com/claude-code/nibzesLaJVh4ydOq/images/statusline-multiline.png?w=840&fit=max&auto=format&n=nibzesLaJVh4ydOq&q=85&s=d29c13d6164773198a0b2c47b31f6c09 840w, https://mintcdn.com/claude-code/nibzesLaJVh4ydOq/images/statusline-multiline.png?w=1100&fit=max&auto=format&n=nibzesLaJVh4ydOq&q=85&s=d7720e5f51310185c0c02152f6c10d8b 1100w, https://mintcdn.com/claude-code/nibzesLaJVh4ydOq/images/statusline-multiline.png?w=1650&fit=max&auto=format&n=nibzesLaJVh4ydOq&q=85&s=b4e008cde27990a8d5783e41e5b93246 1650w, https://mintcdn.com/claude-code/nibzesLaJVh4ydOq/images/statusline-multiline.png?w=2500&fit=max&auto=format&n=nibzesLaJVh4ydOq&q=85&s=40ab24813303dc2e4c09f2675f3faf6e 2500w" />
+  <img src="https://mintcdn.com/claude-code/nibzesLaJVh4ydOq/images/statusline-multiline.png?fit=max&auto=format&n=nibzesLaJVh4ydOq&q=85&s=60f11387658acc9ff75158ae85f2ac87" alt="最初の行にモデル名、ディレクトリ、git ブランチを表示し、2 番目の行にコンテキスト使用状況プログレスバー、コスト、期間を表示する複数行ステータスライン" width="776" height="212" data-path="images/statusline-multiline.png" />
 </Frame>
 
@@ -76,5 +76,5 @@
 
 <Frame>
-  <img src="https://mintcdn.com/claude-code/nibzesLaJVh4ydOq/images/statusline-quickstart.png?fit=max&auto=format&n=nibzesLaJVh4ydOq&q=85&s=696445e59ca0059213250651ad23db6b" alt="モデル名、ディレクトリ、コンテキスト使用率を表示するステータスライン" data-og-width="726" width="726" data-og-height="164" height="164" data-path="images/statusline-quickstart.png" data-optimize="true" data-opv="3" srcset="https://mintcdn.com/claude-code/nibzesLaJVh4ydOq/images/statusline-quickstart.png?w=280&fit=max&auto=format&n=nibzesLaJVh4ydOq&q=85&s=728c4bd06c8559cb46ddffffad983373 280w, https://mintcdn.com/claude-code/nibzesLaJVh4ydOq/images/statusline-quickstart.png?w=560&fit=max&auto=format&n=nibzesLaJVh4ydOq&q=85&s=f9d28e0f8f48f695167dd1d632a6cf4f 560w, https://mintcdn.com/claude-code/nibzesLaJVh4ydOq/images/statusline-quickstart.png?w=840&fit=max&auto=format&n=nibzesLaJVh4ydOq&q=85&s=57a2803a18cafe8cf1aa05619444f20c 840w, https://mintcdn.com/claude-code/nibzesLaJVh4ydOq/images/statusline-quickstart.png?w=1100&fit=max&auto=format&n=nibzesLaJVh4ydOq&q=85&s=52cdd52865842f0cda24489dd5310d3b 1100w, https://mintcdn.com/claude-code/nibzesLaJVh4ydOq/images/statusline-quickstart.png?w=1650&fit=max&auto=format&n=nibzesLaJVh4ydOq&q=85&s=f8876ea1f72bf40bd0aeec483ee20164 1650w, https://mintcdn.com/claude-code/nibzesLaJVh4ydOq/images/statusline-quickstart.png?w=2500&fit=max&auto=format&n=nibzesLaJVh4ydOq&q=85&s=6b1524305c7c71122cde65d0c3822374 2500w" />
+  <img src="https://mintcdn.com/claude-code/nibzesLaJVh4ydOq/images/statusline-quickstart.png?fit=max&auto=format&n=nibzesLaJVh4ydOq&q=85&s=696445e59ca0059213250651ad23db6b" alt="モデル名、ディレクトリ、コンテキスト使用率を表示するステータスライン" width="726" height="164" data-path="images/statusline-quickstart.png" />
 </Frame>
 
@@ -265,5 +265,5 @@ Bash の例は [`jq`](https://jqlang.github.io/jq/) を使用して JSON を解
 
 <Frame>
-  <img src="https://mintcdn.com/claude-code/nibzesLaJVh4ydOq/images/statusline-context-window-usage.png?fit=max&auto=format&n=nibzesLaJVh4ydOq&q=85&s=15b58ab3602f036939145dde3165c6f7" alt="モデル名とパーセンテージ付きプログレスバーを表示するステータスライン" data-og-width="448" width="448" data-og-height="152" height="152" data-path="images/statusline-context-window-usage.png" data-optimize="true" data-opv="3" srcset="https://mintcdn.com/claude-code/nibzesLaJVh4ydOq/images/statusline-context-window-usage.png?w=280&fit=max&auto=format&n=nibzesLaJVh4ydOq&q=85&s=a18fecd31f06b16e984b1ab3310acbc0 280w, https://mintcdn.com/claude-code/nibzesLaJVh4ydOq/images/statusline-context-window-usage.png?w=560&fit=max&auto=format&n=nibzesLaJVh4ydOq&q=85&s=2f4b3caff156efede2ded995dbaf167f 560w, https://mintcdn.com/claude-code/nibzesLaJVh4ydOq/images/statusline-context-window-usage.png?w=840&fit=max&auto=format&n=nibzesLaJVh4ydOq&q=85&s=8f6b8c7e7d3a999c570e96ad2ea13d5a 840w, https://mintcdn.com/claude-code/nibzesLaJVh4ydOq/images/statusline-context-window-usage.png?w=1100&fit=max&auto=format&n=nibzesLaJVh4ydOq&q=85&s=d9334e6a08e6f11a253733c8592774a9 1100w, https://mintcdn.com/claude-code/nibzesLaJVh4ydOq/images/statusline-context-window-usage.png?w=1650&fit=max&auto=format&n=nibzesLaJVh4ydOq&q=85&s=e79490da8f62952e4d92837c408e63dc 1650w, https://mintcdn.com/claude-code/nibzesLaJVh4ydOq/images/statusline-context-window-usage.png?w=2500&fit=max&auto=format&n=nibzesLaJVh4ydOq&q=85&s=6f7c9ef8e629a794969c54b24163f92d 2500w" />
+  <img src="https://mintcdn.com/claude-code/nibzesLaJVh4ydOq/images/statusline-context-window-usage.png?fit=max&auto=format&n=nibzesLaJVh4ydOq&q=85&s=15b58ab3602f036939145dde3165c6f7" alt="モデル名とパーセンテージ付きプログレスバーを表示するステータスライン" width="448" height="152" data-path="images/statusline-context-window-usage.png" />
 </Frame>
 
@@ -331,5 +331,5 @@ git ブランチをステージングされたファイルと変更されたフ
 
 <Frame>
-  <img src="https://mintcdn.com/claude-code/nibzesLaJVh4ydOq/images/statusline-git-context.png?fit=max&auto=format&n=nibzesLaJVh4ydOq&q=85&s=e656f34f90d1d9a1d0e220988914345f" alt="モデル、ディレクトリ、git ブランチ、ステージングされたファイルと変更されたファイルのカラーインジケーターを表示するステータスライン" data-og-width="742" width="742" data-og-height="178" height="178" data-path="images/statusline-git-context.png" data-optimize="true" data-opv="3" srcset="https://mintcdn.com/claude-code/nibzesLaJVh4ydOq/images/statusline-git-context.png?w=280&fit=max&auto=format&n=nibzesLaJVh4ydOq&q=85&s=c1bced5f46afdc9aae549702591f8457 280w, https://mintcdn.com/claude-code/nibzesLaJVh4ydOq/images/statusline-git-context.png?w=560&fit=max&auto=format&n=nibzesLaJVh4ydOq&q=85&s=debe46a7a888234ec692751243bba492 560w, https://mintcdn.com/claude-code/nibzesLaJVh4ydOq/images/statusline-git-context.png?w=840&fit=max&auto=format&n=nibzesLaJVh4ydOq&q=85&s=3a069d5c8b0395908e42f0e295fd4854 840w, https://mintcdn.com/claude-code/nibzesLaJVh4ydOq/images/statusline-git-context.png?w=1100&fit=max&auto=format&n=nibzesLaJVh4ydOq&q=85&s=26aff0978865756d5ea299a22e5e9afd 1100w, https://mintcdn.com/claude-code/nibzesLaJVh4ydOq/images/statusline-git-context.png?w=1650&fit=max&auto=format&n=nibzesLaJVh4ydOq&q=85&s=d5ac1d59881e6f2032af053557dc4590 1650w, https://mintcdn.com/claude-code/nibzesLaJVh4ydOq/images/statusline-git-context.png?w=2500&fit=max&auto=format&n=nibzesLaJVh4ydOq&q=85&s=46febbf34b0ee646502d095433132709 2500w" />
+  <img src="https://mintcdn.com/claude-code/nibzesLaJVh4ydOq/images/statusline-git-context.png?fit=max&auto=format&n=nibzesLaJVh4ydOq&q=85&s=e656f34f90d1d9a1d0e220988914345f" alt="モデル、ディレクトリ、git ブランチ、ステージングされたファイルと変更されたファイルのカラーインジケーターを表示するステータスライン" width="742" height="178" data-path="images/statusline-git-context.png" />
```

</details>

<details>
<summary>vs-code-ja.md</summary>

```diff
diff --git a/docs-ja/pages/vs-code-ja.md b/docs-ja/pages/vs-code-ja.md
index 9e7fe13..2c07fc6 100644
--- a/docs-ja/pages/vs-code-ja.md
+++ b/docs-ja/pages/vs-code-ja.md
@@ -7,5 +7,5 @@
 > Claude Code 拡張機能を VS Code にインストールして設定します。インラインの差分表示、@-メンション、プラン確認、キーボードショートカットを使用した AI コーディング支援を取得します。
 
-<img src="https://mintcdn.com/claude-code/-YhHHmtSxwr7W8gy/images/vs-code-extension-interface.jpg?fit=max&auto=format&n=-YhHHmtSxwr7W8gy&q=85&s=300652d5678c63905e6b0ea9e50835f8" alt="VS Code エディターの右側に Claude Code 拡張機能パネルが開いており、Claude との会話が表示されている" data-og-width="2500" width="2500" data-og-height="1155" height="1155" data-path="images/vs-code-extension-interface.jpg" data-optimize="true" data-opv="3" srcset="https://mintcdn.com/claude-code/-YhHHmtSxwr7W8gy/images/vs-code-extension-interface.jpg?w=280&fit=max&auto=format&n=-YhHHmtSxwr7W8gy&q=85&s=87630c671517a3d52e9aee627041696e 280w, https://mintcdn.com/claude-code/-YhHHmtSxwr7W8gy/images/vs-code-extension-interface.jpg?w=560&fit=max&auto=format&n=-YhHHmtSxwr7W8gy&q=85&s=716b093879204beec8d952649ef75292 560w, https://mintcdn.com/claude-code/-YhHHmtSxwr7W8gy/images/vs-code-extension-interface.jpg?w=840&fit=max&auto=format&n=-YhHHmtSxwr7W8gy&q=85&s=c1525d1a01513acd9d83d8b5a8fe2fc8 840w, https://mintcdn.com/claude-code/-YhHHmtSxwr7W8gy/images/vs-code-extension-interface.jpg?w=1100&fit=max&auto=format&n=-YhHHmtSxwr7W8gy&q=85&s=1d90021d58bbb51f871efec13af955c3 1100w, https://mintcdn.com/claude-code/-YhHHmtSxwr7W8gy/images/vs-code-extension-interface.jpg?w=1650&fit=max&auto=format&n=-YhHHmtSxwr7W8gy&q=85&s=7babdd25440099886f193cfa99af88ae 1650w, https://mintcdn.com/claude-code/-YhHHmtSxwr7W8gy/images/vs-code-extension-interface.jpg?w=2500&fit=max&auto=format&n=-YhHHmtSxwr7W8gy&q=85&s=08c92eedfb56fe61a61e480fb63784b6 2500w" />
+<img src="https://mintcdn.com/claude-code/-YhHHmtSxwr7W8gy/images/vs-code-extension-interface.jpg?fit=max&auto=format&n=-YhHHmtSxwr7W8gy&q=85&s=300652d5678c63905e6b0ea9e50835f8" alt="VS Code エディターの右側に Claude Code 拡張機能パネルが開いており、Claude との会話が表示されている" width="2500" height="1155" data-path="images/vs-code-extension-interface.jpg" />
 
 VS Code 拡張機能は、Claude Code のネイティブグラフィカルインターフェースを提供し、IDE に直接統合されています。これは VS Code で Claude Code を使用する推奨方法です。
@@ -41,9 +41,9 @@ IDE のリンクをクリックして直接インストールします。
 <Steps>
   <Step title="Claude Code パネルを開く">
-    VS Code 全体で、Spark アイコンは Claude Code を示します。<img src="https://mintcdn.com/claude-code/mfM-EyoZGnQv8JTc/images/vs-code-spark-icon.svg?fit=max&auto=format&n=mfM-EyoZGnQv8JTc&q=85&s=a734d84e785140016672f08e0abb236c" alt="Spark icon" style={{display: "inline", height: "0.85em", verticalAlign: "middle"}} data-og-width="16" width="16" data-og-height="16" height="16" data-path="images/vs-code-spark-icon.svg" data-optimize="true" data-opv="3" srcset="https://mintcdn.com/claude-code/mfM-EyoZGnQv8JTc/images/vs-code-spark-icon.svg?w=280&fit=max&auto=format&n=mfM-EyoZGnQv8JTc&q=85&s=9a45aad9a84b9fa1701ac99a1f9aa4e9 280w, https://mintcdn.com/claude-code/mfM-EyoZGnQv8JTc/images/vs-code-spark-icon.svg?w=560&fit=max&auto=format&n=mfM-EyoZGnQv8JTc&q=85&s=3f4cb9254c4d4e93989c4b6bf9292f4b 560w, https://mintcdn.com/claude-code/mfM-EyoZGnQv8JTc/images/vs-code-spark-icon.svg?w=840&fit=max&auto=format&n=mfM-EyoZGnQv8JTc&q=85&s=e75ccc9faa3e572db8f291ceb65bb264 840w, https://mintcdn.com/claude-code/mfM-EyoZGnQv8JTc/images/vs-code-spark-icon.svg?w=1100&fit=max&auto=format&n=mfM-EyoZGnQv8JTc&q=85&s=f147bd81a381a62539a4ce361fac41c7 1100w, https://mintcdn.com/claude-code/mfM-EyoZGnQv8JTc/images/vs-code-spark-icon.svg?w=1650&fit=max&auto=format&n=mfM-EyoZGnQv8JTc&q=85&s=78fe68efaee5d6e844bbacab1b442ed5 1650w, https://mintcdn.com/claude-code/mfM-EyoZGnQv8JTc/images/vs-code-spark-icon.svg?w=2500&fit=max&auto=format&n=mfM-EyoZGnQv8JTc&q=85&s=efb8dbe1dfa722d094edc6ad2ad4bedb 2500w" />
+    VS Code 全体で、Spark アイコンは Claude Code を示します。<img src="https://mintcdn.com/claude-code/mfM-EyoZGnQv8JTc/images/vs-code-spark-icon.svg?fit=max&auto=format&n=mfM-EyoZGnQv8JTc&q=85&s=a734d84e785140016672f08e0abb236c" alt="Spark icon" style={{display: "inline", height: "0.85em", verticalAlign: "middle"}} width="16" height="16" data-path="images/vs-code-spark-icon.svg" />
 
     Claude を開く最速の方法は、**エディターツールバー**（エディターの右上隅）の Spark アイコンをクリックすることです。このアイコンは、ファイルが開いている場合にのみ表示されます。
 
-        <img src="https://mintcdn.com/claude-code/mfM-EyoZGnQv8JTc/images/vs-code-editor-icon.png?fit=max&auto=format&n=mfM-EyoZGnQv8JTc&q=85&s=eb4540325d94664c51776dbbfec4cf02" alt="VS Code エディターのエディターツールバーに Spark アイコンが表示されている" data-og-width="2796" width="2796" data-og-height="734" height="734" data-path="images/vs-code-editor-icon.png" data-optimize="true" data-opv="3" srcset="https://mintcdn.com/claude-code/mfM-EyoZGnQv8JTc/images/vs-code-editor-icon.png?w=280&fit=max&auto=format&n=mfM-EyoZGnQv8JTc&q=85&s=56f218d5464359d6480cfe23f70a923e 280w, https://mintcdn.com/claude-code/mfM-EyoZGnQv8JTc/images/vs-code-editor-icon.png?w=560&fit=max&auto=format&n=mfM-EyoZGnQv8JTc&q=85&s=344a8db024b196c795a80dc85cacb8d1 560w, https://mintcdn.com/claude-code/mfM-EyoZGnQv8JTc/images/vs-code-editor-icon.png?w=840&fit=max&auto=format&n=mfM-EyoZGnQv8JTc&q=85&s=f30bf834ee0625b2a4a635d552d87163 840w, https://mintcdn.com/claude-code/mfM-EyoZGnQv8JTc/images/vs-code-editor-icon.png?w=1100&fit=max&auto=format&n=mfM-EyoZGnQv8JTc&q=85&s=81fdf984840e43a9f08ae42729d1484d 1100w, https://mintcdn.com/claude-code/mfM-EyoZGnQv8JTc/images/vs-code-editor-icon.png?w=1650&fit=max&auto=format&n=mfM-EyoZGnQv8JTc&q=85&s=8b60fb32de54717093d512afaa99785c 1650w, https://mintcdn.com/claude-code/mfM-EyoZGnQv8JTc/images/vs-code-editor-icon.png?w=2500&fit=max&auto=format&n=mfM-EyoZGnQv8JTc&q=85&s=893e6bda8f2e9d42c8a294d394f0b736 2500w" />
+        <img src="https://mintcdn.com/claude-code/mfM-EyoZGnQv8JTc/images/vs-code-editor-icon.png?fit=max&auto=format&n=mfM-EyoZGnQv8JTc&q=85&s=eb4540325d94664c51776dbbfec4cf02" alt="VS Code エディターのエディターツールバーに Spark アイコンが表示されている" width="2796" height="734" data-path="images/vs-code-editor-icon.png" />
 
     Claude Code を開く他の方法：
@@ -64,5 +64,5 @@ IDE のリンクをクリックして直接インストールします。
     ファイル内の特定の行について質問する例を次に示します。
 
-        <img src="https://mintcdn.com/claude-code/FVYz38sRY-VuoGHA/images/vs-code-send-prompt.png?fit=max&auto=format&n=FVYz38sRY-VuoGHA&q=85&s=ede3ed8d8d5f940e01c5de636d009cfd" alt="VS Code エディターで Python ファイルの 2 ～ 3 行が選択されており、Claude Code パネルにそれらの行についての質問と @-メンション参照が表示されている" data-og-width="3288" width="3288" data-og-height="1876" height="1876" data-path="images/vs-code-send-prompt.png" data-optimize="true" data-opv="3" srcset="https://mintcdn.com/claude-code/FVYz38sRY-VuoGHA/images/vs-code-send-prompt.png?w=280&fit=max&auto=format&n=FVYz38sRY-VuoGHA&q=85&s=f40bde7b2c245fe8f0f5b784e8106492 280w, https://mintcdn.com/claude-code/FVYz38sRY-VuoGHA/images/vs-code-send-prompt.png?w=560&fit=max&auto=format&n=FVYz38sRY-VuoGHA&q=85&s=fad66a27a9a6faa23b05370aa4f398b2 560w, https://mintcdn.com/claude-code/FVYz38sRY-VuoGHA/images/vs-code-send-prompt.png?w=840&fit=max&auto=format&n=FVYz38sRY-VuoGHA&q=85&s=4539c8a3823ca80a5c8771f6c088ce9e 840w, https://mintcdn.com/claude-code/FVYz38sRY-VuoGHA/images/vs-code-send-prompt.png?w=1100&fit=max&auto=format&n=FVYz38sRY-VuoGHA&q=85&s=fae8ebf300c7853409a562ffa46d9c71 1100w, https://mintcdn.com/claude-code/FVYz38sRY-VuoGHA/images/vs-code-send-prompt.png?w=1650&fit=max&auto=format&n=FVYz38sRY-VuoGHA&q=85&s=22e4462bb8cf0c0ca20f8102bc4c971a 1650w, https://mintcdn.com/claude-code/FVYz38sRY-VuoGHA/images/vs-code-send-prompt.png?w=2500&fit=max&auto=format&n=FVYz38sRY-VuoGHA&q=85&s=739bfd045f70fe7be1a109a53494590e 2500w" />
+        <img src="https://mintcdn.com/claude-code/FVYz38sRY-VuoGHA/images/vs-code-send-prompt.png?fit=max&auto=format&n=FVYz38sRY-VuoGHA&q=85&s=ede3ed8d8d5f940e01c5de636d009cfd" alt="VS Code エディターで Python ファイルの 2 ～ 3 行が選択されており、Claude Code パネルにそれらの行についての質問と @-メンション参照が表示されている" width="3288" height="1876" data-path="images/vs-code-send-prompt.png" />
   </Step>
 
```

</details>

*...以降省略*

</details>


<details>
<summary>2026-03-11</summary>

**変更ファイル:**

```
 docs-ja/pages/changelog.md | 54 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 54 insertions(+)
```

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index 8ab2cf9..9030b86 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,58 @@
 # Changelog
 
+## 2.1.72
+
+- Fixed tool search to activate even with `ANTHROPIC_BASE_URL` as long as `ENABLE_TOOL_SEARCH` is set.
+- Added `w` key in `/copy` to write the focused selection directly to a file, bypassing the clipboard (useful over SSH)
+- Added optional description argument to `/plan` (e.g., `/plan fix the auth bug`) that enters plan mode and immediately starts
+- Added `ExitWorktree` tool to leave an `EnterWorktree` session
+- Added `CLAUDE_CODE_DISABLE_CRON` environment variable to immediately stop scheduled cron jobs mid-session
+- Added `lsof`, `pgrep`, `tput`, `ss`, `fd`, and `fdfind` to the bash auto-approval allowlist, reducing permission prompts for common read-only operations
+- Restored the `model` parameter on the Agent tool for per-invocation model overrides
+- Simplified effort levels to low/medium/high (removed max) with new symbols (○ ◐ ●) and a brief notification instead of a persistent icon. Use `/effort auto` to reset to default
+- Improved `/config` — Escape now cancels changes, Enter saves and closes, Space toggles settings
+- Improved up-arrow history to show current session's messages first when running multiple concurrent sessions
+- Improved voice input transcription accuracy for repo names and common dev terms (regex, OAuth, JSON)
+- Improved bash command parsing by switching to a native module — faster initialization and no memory leak
+- Reduced bundle size by ~510 KB
+- Changed CLAUDE.md HTML comments (`<!-- ... -->`) to be hidden from Claude when auto-injected. Comments remain visible when read with the Read tool
+- Fixed slow exits when background tasks or hooks were slow to respond
+- Fixed agent task progress stuck on "Initializing…"
+- Fixed skill hooks firing twice per event when a hooks-enabled skill is invoked by the model
+- Fixed several voice mode issues: occasional input lag, false "No speech detected" errors after releasing push-to-talk, and stale transcripts re-filling the prompt after submission
+- Fixed `--continue` not resuming from the most recent point after `--compact`
+- Fixed bash security parsing edge cases
+- Added support for marketplace git URLs without `.git` suffix (Azure DevOps, AWS CodeCommit)
```

</details>

</details>


<details>
<summary>2026-03-10</summary>

**新規追加:**


</details>


<details>
<summary>2026-03-08</summary>

**変更ファイル:**

```
 docs-ja/pages/changelog.md | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)
```

**新規追加:**


<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index 6049d50..8ab2cf9 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,35 @@
 # Changelog
 
+## 2.1.71
+
+- Added `/loop` command to run a prompt or slash command on a recurring interval (e.g. `/loop 5m check the deploy`)
+- Added cron scheduling tools for recurring prompts within a session
+- Added `voice:pushToTalk` keybinding to make the voice activation key rebindable in `keybindings.json` (default: space) — modifier+letter combos like `meta+k` have zero typing interference
+- Added `fmt`, `comm`, `cmp`, `numfmt`, `expr`, `test`, `printf`, `getconf`, `seq`, `tsort`, and `pr` to the bash auto-approval allowlist
+- Fixed stdin freeze in long-running sessions where keystrokes stop being processed but the process stays alive
+- Fixed a 5–8 second startup freeze for users with voice mode enabled, caused by CoreAudio initialization blocking the main thread after system wake
+- Fixed startup UI freeze when many claude.ai proxy connectors refresh an expired OAuth token simultaneously
+- Fixed forked conversations (`/fork`) sharing the same plan file, which caused plan edits in one fork to overwrite the other
+- Fixed the Read tool putting oversized images into context when image processing failed, breaking subsequent turns in long image-heavy sessions
+- Fixed false-positive permission prompts for compound bash commands containing heredoc commit messages
+- Fixed plugin installations being lost when running multiple Claude Code instances
+- Fixed claude.ai connectors failing to reconnect after OAuth token refresh
+- Fixed claude.ai MCP connector startup notifications appearing for every org-configured connector instead of only previously connected ones
+- Fixed background agent completion notifications missing the output file path, which made it difficult for parent agents to recover agent results after context compaction
+- Fixed duplicate output in Bash tool error messages when commands exit with non-zero status
+- Fixed Chrome extension auto-detection getting permanently stuck on "not installed" after running on a machine without local Chrome
+- Fixed `/plugin marketplace update` failing with merge conflicts when the marketplace is pinned to a branch/tag ref
+- Fixed `/plugin marketplace add owner/repo@ref` incorrectly parsing `@` — previously only `#` worked as a ref separator, causing undiagnosable errors with `strictKnownMarketplaces`
+- Fixed duplicate entries in `/permissions` Workspace tab when the same directory is added with and without a trailing slash
+- Fixed `--print` hanging forever when team agents are configured — the exit loop no longer waits on long-lived `in_process_teammate` tasks
+- Fixed "❯ Tool loaded." appearing in the REPL after every `ToolSearch` call
```

</details>

</details>


<details>
<summary>2026-03-07</summary>

**変更ファイル:**

```
 docs-ja/pages/changelog.md             | 32 ++++++++++++++++++++++++++++++++
 docs-ja/pages/desktop-quickstart-en.md |  4 +++-
 2 files changed, 35 insertions(+), 1 deletion(-)
```

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index f9232b0..6049d50 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,36 @@
 # Changelog
 
+## 2.1.70
+
+- Fixed API 400 errors when using `ANTHROPIC_BASE_URL` with a third-party gateway — tool search now correctly detects proxy endpoints and disables `tool_reference` blocks
+- Fixed `API Error: 400 This model does not support the effort parameter` when using custom Bedrock inference profiles or other model identifiers not matching standard Claude naming patterns
+- Fixed empty model responses immediately after `ToolSearch` — the server renders tool schemas with system-prompt-style tags at the prompt tail, which could confuse models into stopping early
+- Fixed prompt-cache bust when an MCP server with `instructions` connects after the first turn
+- Fixed Enter inserting a newline instead of submitting when typing over a slow SSH connection
+- Fixed clipboard corrupting non-ASCII text (CJK, emoji) on Windows/WSL by using PowerShell `Set-Clipboard`
+- Fixed extra VS Code windows opening at startup on Windows when running from the VS Code integrated terminal
+- Fixed voice mode failing on Windows native binary with "native audio module could not be loaded"
+- Fixed push-to-talk not activating on session start when `voiceEnabled: true` was set in settings
+- Fixed markdown links containing `#NNN` references incorrectly pointing to the current repository instead of the linked URL
+- Fixed repeated "Model updated to Opus 4.6" notification when a project's `.claude/settings.json` has a legacy Opus model string pinned
+- Fixed plugins showing as inaccurately installed in `/plugin`
+- Fixed plugins showing "not found in marketplace" errors on fresh startup by auto-refreshing after marketplace installation
+- Fixed `/security-review` command failing with `unknown option merge-base` on older git versions
+- Fixed `/color` command having no way to reset back to the default color — `/color default`, `/color gray`, `/color reset`, and `/color none` now restore the default
+- Fixed a performance regression in the `AskUserQuestion` preview dialog that re-ran markdown rendering on every keystroke in the notes input
+- Fixed feature flags read during early startup never refreshing their disk cache, causing stale values to persist across sessions
+- Fixed `permissions.defaultMode` settings values other than `acceptEdits` or `plan` being applied in Claude Code Remote environments — they are now ignored
+- Fixed skill listing being re-injected on every `--resume` (~600 tokens saved per resume)
+- Fixed teleport marker not rendering in VS Code teleported sessions
+- Improved error message when microphone captures silence to distinguish from "no speech detected"
```

</details>

<details>
<summary>desktop-quickstart-en.md</summary>

```diff
diff --git a/docs-ja/pages/desktop-quickstart-en.md b/docs-ja/pages/desktop-quickstart-en.md
index 317c582..a0e5f72 100644
--- a/docs-ja/pages/desktop-quickstart-en.md
+++ b/docs-ja/pages/desktop-quickstart-en.md
@@ -7,5 +7,5 @@
 > Install Claude Code on desktop and start your first coding session
 
-The desktop app gives you Claude Code with a graphical interface: visual diff review, live app preview, GitHub PR monitoring with auto-merge, parallel sessions with Git worktree isolation, and the ability to run tasks remotely. No terminal required.
+The desktop app gives you Claude Code with a graphical interface: visual diff review, live app preview, GitHub PR monitoring with auto-merge, parallel sessions with Git worktree isolation, scheduled tasks, and the ability to run tasks remotely. No terminal required.
 
 This page walks through installing the app and starting your first session. If you're already set up, see [Use Claude Code Desktop](/en/desktop) for the full reference.
@@ -124,4 +124,6 @@ You've made your first edit. For the full reference on everything Desktop can do
 **Track your pull request.** After opening a PR, Claude Code monitors CI check results and can automatically fix failures or merge the PR once all checks pass. See [Monitor pull request status](/en/desktop#monitor-pull-request-status).
 
+**Put Claude on a schedule.** Set up [scheduled tasks](/en/desktop#schedule-recurring-tasks) to run Claude automatically on a recurring basis: a daily code review every morning, a weekly dependency audit, or a briefing that pulls from your connected tools.
+
 **Scale up when you're ready.** Open [parallel sessions](/en/desktop#work-in-parallel-with-sessions) from the sidebar to work on multiple tasks at once, each in its own Git worktree. Send [long-running work to the cloud](/en/desktop#run-long-running-tasks-remotely) so it continues even if you close the app, or [continue a session on the web or in your IDE](/en/desktop#continue-in-another-surface) if a task takes longer than expected. [Connect external tools](/en/desktop#extend-claude-code) like GitHub, Slack, and Linear to bring your workflow together.
 
```

</details>

</details>


<details>
<summary>2026-03-06</summary>

**変更ファイル:**

```
 docs-ja/pages/changelog.md      | 106 ++++++++++++++++++++++++++++++++++++++++
 docs-ja/pages/hooks-guide-ja.md |  39 ++++++++-------
 docs-ja/pages/hooks-ja.md       |  41 ++++++++--------
 3 files changed, 147 insertions(+), 39 deletions(-)
```

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index ee93589..f9232b0 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,110 @@
 # Changelog
 
+## 2.1.69
+
+- Added the `/claude-api` skill for building applications with the Claude API and Anthropic SDK
+- Added Ctrl+U on an empty bash prompt (`!`) to exit bash mode, matching `escape` and `backspace`
+- Added numeric keypad support for selecting options in Claude's interview questions (previously only the number row above QWERTY worked)
+- Added optional name argument to `/remote-control` and `claude remote-control` (`/remote-control My Project` or `--name "My Project"`) to set a custom session title visible in claude.ai/code
+- Added Voice STT support for 10 new languages (20 total) — Russian, Polish, Turkish, Dutch, Ukrainian, Greek, Czech, Danish, Swedish, Norwegian
+- Added effort level display (e.g., "with low effort") to the logo and spinner, making it easier to see which effort setting is active
+- Added agent name display in terminal title when using `claude --agent`
+- Added `sandbox.enableWeakerNetworkIsolation` setting (macOS only) to allow Go programs like `gh`, `gcloud`, and `terraform` to verify TLS certificates when using a custom MITM proxy with `httpProxyPort`
+- Added `includeGitInstructions` setting (and `CLAUDE_CODE_DISABLE_GIT_INSTRUCTIONS` env var) to remove built-in commit and PR workflow instructions from Claude's system prompt
+- Added `/reload-plugins` command to activate pending plugin changes without restarting
+- Added a one-time startup prompt suggesting Claude Code Desktop on macOS and Windows (max 3 showings, dismissible)
+- Added `${CLAUDE_SKILL_DIR}` variable for skills to reference their own directory in SKILL.md content
+- Added `InstructionsLoaded` hook event that fires when CLAUDE.md or `.claude/rules/*.md` files are loaded into context
+- Added `agent_id` (for subagents) and `agent_type` (for subagents and `--agent`) to hook events
+- Added `worktree` field to status line hook commands with name, path, branch, and original repo directory when running in a `--worktree` session
+- Added `pluginTrustMessage` in managed settings to append organization-specific context to the plugin trust warning shown before installation
+- Added policy limit fetching (e.g., remote control restrictions) for Team plan OAuth users, not just Enterprise
+- Added `pathPattern` to `strictKnownMarketplaces` for regex-matching file/directory marketplace sources alongside `hostPattern` restrictions
+- Added plugin source type `git-subdir` to point to a subdirectory within a git repo
+- Added `oauth.authServerMetadataUrl` config option for MCP servers to specify a custom OAuth metadata discovery URL when standard discovery fails
+- Fixed a security issue where nested skill discovery could load skills from gitignored directories like `node_modules`
```

</details>

<details>
<summary>hooks-guide-ja.md</summary>

```diff
diff --git a/docs-ja/pages/hooks-guide-ja.md b/docs-ja/pages/hooks-guide-ja.md
index e6cc40a..1f2c61f 100644
--- a/docs-ja/pages/hooks-guide-ja.md
+++ b/docs-ja/pages/hooks-guide-ja.md
@@ -294,23 +294,24 @@ Claude のコンテキストウィンドウがいっぱいになると、圧縮
 Hook イベントは Claude Code のライフサイクルの特定のポイントで発火します。イベントが発火すると、すべてのマッチングする hooks が並列で実行され、同一の hook コマンドは自動的に重複排除されます。以下の表は各イベントとそれがトリガーされるときを示しています：
 
-| Event                | When it fires                                                                                               |
-| :------------------- | :---------------------------------------------------------------------------------------------------------- |
-| `SessionStart`       | When a session begins or resumes                                                                            |
-| `UserPromptSubmit`   | When you submit a prompt, before Claude processes it                                                        |
-| `PreToolUse`         | Before a tool call executes. Can block it                                                                   |
-| `PermissionRequest`  | When a permission dialog appears                                                                            |
-| `PostToolUse`        | After a tool call succeeds                                                                                  |
-| `PostToolUseFailure` | After a tool call fails                                                                                     |
-| `Notification`       | When Claude Code sends a notification                                                                       |
-| `SubagentStart`      | When a subagent is spawned                                                                                  |
-| `SubagentStop`       | When a subagent finishes                                                                                    |
-| `Stop`               | When Claude finishes responding                                                                             |
-| `TeammateIdle`       | When an [agent team](/en/agent-teams) teammate is about to go idle                                          |
-| `TaskCompleted`      | When a task is being marked as completed                                                                    |
-| `ConfigChange`       | When a configuration file changes during a session                                                          |
-| `WorktreeCreate`     | When a worktree is being created via `--worktree` or `isolation: "worktree"`. Replaces default git behavior |
-| `WorktreeRemove`     | When a worktree is being removed, either at session exit or when a subagent finishes                        |
-| `PreCompact`         | Before context compaction                                                                                   |
-| `SessionEnd`         | When a session terminates                                                                                   |
+| Event                | When it fires                                                                                                                                  |
+| :------------------- | :--------------------------------------------------------------------------------------------------------------------------------------------- |
+| `SessionStart`       | When a session begins or resumes                                                                                                               |
+| `UserPromptSubmit`   | When you submit a prompt, before Claude processes it                                                                                           |
```

</details>

<details>
<summary>hooks-ja.md</summary>

```diff
diff --git a/docs-ja/pages/hooks-ja.md b/docs-ja/pages/hooks-ja.md
index 9eace90..1a35bf4 100644
--- a/docs-ja/pages/hooks-ja.md
+++ b/docs-ja/pages/hooks-ja.md
@@ -19,5 +19,5 @@
 <div style={{maxWidth: "500px", margin: "0 auto"}}>
   <Frame>
-    <img src="https://mintcdn.com/claude-code/rsuu-ovdPNos9Dnn/images/hooks-lifecycle.svg?fit=max&auto=format&n=rsuu-ovdPNos9Dnn&q=85&s=ce5f1225339bbccdfbb52e99205db912" alt="SessionStart から agentic ループを経由して SessionEnd までのフックのシーケンスを示すフック ライフサイクル図。WorktreeCreate と WorktreeRemove はスタンドアロンのセットアップおよびティアダウン イベント" data-og-width="520" width="520" data-og-height="1020" height="1020" data-path="images/hooks-lifecycle.svg" data-optimize="true" data-opv="3" srcset="https://mintcdn.com/claude-code/rsuu-ovdPNos9Dnn/images/hooks-lifecycle.svg?w=280&fit=max&auto=format&n=rsuu-ovdPNos9Dnn&q=85&s=7c7143c65492c1beb6bc66f5d206ba15 280w, https://mintcdn.com/claude-code/rsuu-ovdPNos9Dnn/images/hooks-lifecycle.svg?w=560&fit=max&auto=format&n=rsuu-ovdPNos9Dnn&q=85&s=dafaebf8f789f94edbf6bd66853c69df 560w, https://mintcdn.com/claude-code/rsuu-ovdPNos9Dnn/images/hooks-lifecycle.svg?w=840&fit=max&auto=format&n=rsuu-ovdPNos9Dnn&q=85&s=2caa51d2d95596f1f80b92e3f5f534fa 840w, https://mintcdn.com/claude-code/rsuu-ovdPNos9Dnn/images/hooks-lifecycle.svg?w=1100&fit=max&auto=format&n=rsuu-ovdPNos9Dnn&q=85&s=614def559f34f9b0c1dec93739d96b64 1100w, https://mintcdn.com/claude-code/rsuu-ovdPNos9Dnn/images/hooks-lifecycle.svg?w=1650&fit=max&auto=format&n=rsuu-ovdPNos9Dnn&q=85&s=ca45b85fdd8b2da81c69d12c453230cb 1650w, https://mintcdn.com/claude-code/rsuu-ovdPNos9Dnn/images/hooks-lifecycle.svg?w=2500&fit=max&auto=format&n=rsuu-ovdPNos9Dnn&q=85&s=7fd92d6b9713493f59962c9f295c9d2f 2500w" />
+    <img src="https://mintcdn.com/claude-code/JWoaQLhotXStH4d2/images/hooks-lifecycle.svg?fit=max&auto=format&n=JWoaQLhotXStH4d2&q=85&s=9310bd002ef90ca32ac668455f5580a0" alt="SessionStart から agentic ループを経由して SessionEnd までのフックのシーケンスを示すフック ライフサイクル図。WorktreeCreate と WorktreeRemove はスタンドアロンのセットアップおよびティアダウン イベント" data-og-width="520" width="520" data-og-height="1020" height="1020" data-path="images/hooks-lifecycle.svg" data-optimize="true" data-opv="3" srcset="https://mintcdn.com/claude-code/JWoaQLhotXStH4d2/images/hooks-lifecycle.svg?w=280&fit=max&auto=format&n=JWoaQLhotXStH4d2&q=85&s=109982de941b0c53206b6178f4982f64 280w, https://mintcdn.com/claude-code/JWoaQLhotXStH4d2/images/hooks-lifecycle.svg?w=560&fit=max&auto=format&n=JWoaQLhotXStH4d2&q=85&s=9375684c8578b8ffe598d3798a59448c 560w, https://mintcdn.com/claude-code/JWoaQLhotXStH4d2/images/hooks-lifecycle.svg?w=840&fit=max&auto=format&n=JWoaQLhotXStH4d2&q=85&s=ee44a68c8feaabf5e7d09e65f3d653ae 840w, https://mintcdn.com/claude-code/JWoaQLhotXStH4d2/images/hooks-lifecycle.svg?w=1100&fit=max&auto=format&n=JWoaQLhotXStH4d2&q=85&s=4f35067e11e2d1861513ae8faf92cc04 1100w, https://mintcdn.com/claude-code/JWoaQLhotXStH4d2/images/hooks-lifecycle.svg?w=1650&fit=max&auto=format&n=JWoaQLhotXStH4d2&q=85&s=abf63881fb2c5cce211ac8ebb37af504 1650w, https://mintcdn.com/claude-code/JWoaQLhotXStH4d2/images/hooks-lifecycle.svg?w=2500&fit=max&auto=format&n=JWoaQLhotXStH4d2&q=85&s=e804d84b83ff44107fd2195c73e1c2ac 2500w" />
   </Frame>
 </div>
@@ -25,23 +25,24 @@
 以下の表は、各イベントがいつ発火するかをまとめています。[フック イベント](#hook-events)セクションでは、各イベントの完全な入力スキーマと決定制御オプションについて説明しています。
 
-| Event                | When it fires                                                                                               |
-| :------------------- | :---------------------------------------------------------------------------------------------------------- |
-| `SessionStart`       | When a session begins or resumes                                                                            |
-| `UserPromptSubmit`   | When you submit a prompt, before Claude processes it                                                        |
-| `PreToolUse`         | Before a tool call executes. Can block it                                                                   |
-| `PermissionRequest`  | When a permission dialog appears                                                                            |
-| `PostToolUse`        | After a tool call succeeds                                                                                  |
-| `PostToolUseFailure` | After a tool call fails                                                                                     |
-| `Notification`       | When Claude Code sends a notification                                                                       |
-| `SubagentStart`      | When a subagent is spawned                                                                                  |
-| `SubagentStop`       | When a subagent finishes                                                                                    |
-| `Stop`               | When Claude finishes responding                                                                             |
-| `TeammateIdle`       | When an [agent team](/en/agent-teams) teammate is about to go idle                                          |
-| `TaskCompleted`      | When a task is being marked as completed                                                                    |
-| `ConfigChange`       | When a configuration file changes during a session                                                          |
-| `WorktreeCreate`     | When a worktree is being created via `--worktree` or `isolation: "worktree"`. Replaces default git behavior |
```

</details>

</details>


<details>
<summary>2026-03-05</summary>

**変更ファイル:**

```
 docs-ja/pages/changelog.md                 |  10 +
 docs-ja/pages/claude-code-on-the-web-ja.md |  91 +++--
 docs-ja/pages/cli-reference-ja.md          |  92 ++---
 docs-ja/pages/common-workflows-ja.md       | 131 +++----
 docs-ja/pages/data-usage-ja.md             |  22 +-
 docs-ja/pages/features-overview-ja.md      | 188 ++++-----
 docs-ja/pages/hooks-guide-ja.md            | 155 +++++---
 docs-ja/pages/hooks-ja.md                  | 226 +++++------
 docs-ja/pages/how-claude-code-works-ja.md  |  65 ++--
 docs-ja/pages/interactive-mode-ja.md       | 200 ++++++----
 docs-ja/pages/mcp-ja.md                    | 343 +++++++++--------
 docs-ja/pages/memory-ja.md                 | 404 +++++++++++---------
 docs-ja/pages/model-config-ja.md           |  18 +-
 docs-ja/pages/overview-ja.md               |  39 +-
 docs-ja/pages/permissions-ja.md            | 100 ++---
 docs-ja/pages/remote-control-ja.md         |  26 +-
 docs-ja/pages/sandboxing-ja.md             | 132 ++++---
 docs-ja/pages/settings-ja.md               | 591 +++++++++++++++--------------
 docs-ja/pages/skills-ja.md                 | 328 ++++++++--------
 docs-ja/pages/statusline-ja.md             | 171 ++++++---
 docs-ja/pages/sub-agents-ja.md             | 268 ++++++-------
 docs-ja/pages/vs-code-ja.md                | 134 +++----
 22 files changed, 2012 insertions(+), 1722 deletions(-)
```

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index a1a1615..ee93589 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,14 @@
 # Changelog
 
+## 2.1.68
+
+- Opus 4.6 now defaults to medium effort for Max and Team subscribers. Medium effort works well for most tasks — it's the sweet spot between speed and thoroughness. You can change this anytime with `/model`
+- Re-introduced the "ultrathink" keyword to enable high effort for the next turn
+- Removed Opus 4 and 4.1 from Claude Code on the first-party API — users with these models pinned are automatically moved to Opus 4.6
+
+## 2.1.66
+
+- Reduced spurious error logging
+
 ## 2.1.63
 
```

</details>

<details>
<summary>claude-code-on-the-web-ja.md</summary>

```diff
diff --git a/docs-ja/pages/claude-code-on-the-web-ja.md b/docs-ja/pages/claude-code-on-the-web-ja.md
index b933fc3..209f19c 100644
--- a/docs-ja/pages/claude-code-on-the-web-ja.md
+++ b/docs-ja/pages/claude-code-on-the-web-ja.md
@@ -21,7 +21,7 @@
 * **バックエンド変更**：Claude Code がテストを作成してからそのテストに合格するコードを作成できる場所
 
-Claude Code は [iOS](https://apps.apple.com/us/app/claude-by-anthropic/id6473753684) および [Android](https://play.google.com/store/apps/details?id=com.anthropic.claude) の Claude アプリでも利用可能で、外出先でタスクを開始し、進行中の作業を監視できます。
+Claude Code は Claude アプリの [iOS](https://apps.apple.com/us/app/claude-by-anthropic/id6473753684) および [Android](https://play.google.com/store/apps/details?id=com.anthropic.claude) でも利用可能で、移動中にタスクを開始し、進行中の作業を監視できます。
 
-ターミナルから `--remote` を使用して[ウェブで新しいタスクを開始](/ja/remote-control)したり、[ウェブセッションをターミナルにテレポート](#from-web-to-terminal)してローカルで続行したりできます。クラウドインフラストラクチャの代わりに自分のマシンで Claude Code を実行しながらウェブインターフェースを使用するには、[リモートコントロール](/ja/remote-control)を参照してください。
+ターミナルから `--remote` を使用して[ウェブで新しいタスクを開始](#from-terminal-to-web)したり、[ウェブセッションをターミナルにテレポート](#from-web-to-terminal)してローカルで続行したりできます。クラウドインフラストラクチャの代わりに自分のマシンで Claude Code を実行しながらウェブインターフェースを使用するには、[リモートコントロール](/ja/remote-control)を参照してください。
 
 ## ウェブ上の Claude Code は誰が使用できますか？
@@ -56,5 +56,5 @@ Claude Code は [iOS](https://apps.apple.com/us/app/claude-by-anthropic/id647375
 ## diff ビューで変更を確認する
 
-Diff ビューを使用すると、プルリクエストを作成する前に Claude が何を変更したかを正確に確認できます。GitHub で変更を確認するために「PR を作成」をクリックする代わりに、アプリで diff を直接表示し、変更の準備ができるまで Claude と反復処理します。
+Diff ビューを使用すると、プルリクエストを作成する前に Claude が何を変更したかを正確に確認できます。GitHub でプルリクエストを確認するために「PR を作成」をクリックする代わりに、アプリで diff を直接表示し、変更の準備ができるまで Claude と反復処理できます。
 
 Claude がファイルに変更を加えると、追加および削除された行数を示す diff 統計インジケーター（例：`+12 -1`）が表示されます。このインジケーターを選択して diff ビューアを開くと、左側にファイルリストが表示され、右側に各ファイルの変更が表示されます。
@@ -64,5 +64,5 @@ diff ビューから、以下のことができます：
 * ファイルごとに変更を確認する
 * 特定の変更にコメントして修正をリクエストする
-* 表示内容に基づいて Claude との反復処理を続行する
+* 表示内容に基づいて Claude との反復処理を続ける
 
 これにより、ドラフト PR を作成したり GitHub に切り替えたりすることなく、複数ラウンドのフィードバックを通じて変更を改善できます。
@@ -84,9 +84,9 @@ claude --remote "Fix the authentication bug in src/auth/login.ts"
 ```
```

</details>

<details>
<summary>cli-reference-ja.md</summary>

```diff
diff --git a/docs-ja/pages/cli-reference-ja.md b/docs-ja/pages/cli-reference-ja.md
index 2daa6ce..4981774 100644
--- a/docs-ja/pages/cli-reference-ja.md
+++ b/docs-ja/pages/cli-reference-ja.md
@@ -26,5 +26,5 @@
 | `claude agents`                 | すべての設定済み [subagents](/ja/sub-agents) をソース別にグループ化して一覧表示                                                                                                           | `claude agents`                                    |
 | `claude mcp`                    | Model Context Protocol（MCP）サーバーを設定                                                                                                                               | [Claude Code MCP ドキュメント](/ja/mcp) を参照してください。       |
-| `claude remote-control`         | [Remote Control セッション](/ja/remote-control) を開始して、ローカルで実行中に Claude.ai または Claude アプリから Claude Code を制御します。フラグについては [Remote Control](/ja/remote-control) を参照してください | `claude remote-control`                            |
+| `claude remote-control`         | [Remote Control セッション](/ja/remote-control) を開始して、ローカルで実行中の Claude Code を Claude.ai または Claude アプリから制御します。フラグについては [Remote Control](/ja/remote-control) を参照してください | `claude remote-control`                            |
 
 ## CLI フラグ
@@ -34,42 +34,42 @@
 | フラグ                                    | 説明                                                                                                                                                                     | 例                                                                                                  |
 | :------------------------------------- | :--------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :------------------------------------------------------------------------------------------------- |
-| `--add-dir`                            | Claude がアクセスするための追加の作業ディレクトリを追加（各パスがディレクトリとして存在することを検証）                                                                                                                | `claude --add-dir ../apps ../lib`                                                                  |
-| `--agent`                              | 現在のセッションのエージェントを指定（`agent` 設定をオーバーライド）                                                                                                                                 | `claude --agent my-custom-agent`                                                                   |
+| `--add-dir`                            | Claude がアクセスできる追加の作業ディレクトリを追加（各パスがディレクトリとして存在することを検証）                                                                                                                  | `claude --add-dir ../apps ../lib`                                                                  |
+| `--agent`                              | 現在のセッション用のエージェントを指定（`agent` 設定をオーバーライド）                                                                                                                                | `claude --agent my-custom-agent`                                                                   |
 | `--agents`                             | JSON 経由でカスタム [subagents](/ja/sub-agents) を動的に定義（形式については以下を参照）                                                                                                          | `claude --agents '{"reviewer":{"description":"Reviews code","prompt":"You are a code reviewer"}}'` |
-| `--allow-dangerously-skip-permissions` | `--permission-mode` と組み合わせることを許可する権限バイパスオプションを有効化（注意して使用）                                                                                                              | `claude --permission-mode plan --allow-dangerously-skip-permissions`                               |
-| `--allowedTools`                       | 権限を求めずに実行するツール。パターンマッチングについては [permission rule syntax](/ja/settings#permission-rule-syntax) を参照。利用可能なツールを制限するには、代わりに `--tools` を使用                                     | `"Bash(git log *)" "Bash(git diff *)" "Read"`                                                      |
-| `--append-system-prompt`               | デフォルトシステムプロンプトの末尾にカスタムテキストを追加（インタラクティブモードと印刷モードの両方で機能）                                                                                                                 | `claude --append-system-prompt "Always use TypeScript"`                                            |
+| `--allow-dangerously-skip-permissions` | 権限バイパスをオプションとして有効にします（すぐには有効化しません）。`--permission-mode` と組み合わせることができます（注意して使用）                                                                                          | `claude --permission-mode plan --allow-dangerously-skip-permissions`                               |
+| `--allowedTools`                       | 権限を求めずに実行するツール。パターンマッチングについては [権限ルール構文](/ja/settings#permission-rule-syntax) を参照してください。利用可能なツールを制限するには、代わりに `--tools` を使用してください                                        | `"Bash(git log *)" "Bash(git diff *)" "Read"`                                                      |
+| `--append-system-prompt`               | カスタムテキストをデフォルトシステムプロンプトの末尾に追加（インタラクティブモードと印刷モードの両方で機能）                                                                                                                 | `claude --append-system-prompt "Always use TypeScript"`                                            |
 | `--append-system-prompt-file`          | ファイルから追加のシステムプロンプトテキストを読み込み、デフォルトプロンプトに追加（印刷モードのみ）                                                                                                                     | `claude -p --append-system-prompt-file ./extra-rules.txt "query"`                                  |
 | `--betas`                              | API リクエストに含める Beta ヘッダー（API キーユーザーのみ）                                                                                                                                  | `claude --betas interleaved-thinking`                                                              |
-| `--chrome`                             | Web 自動化とテストのための [Chrome ブラウザ統合](/ja/chrome) を有効化                                                                                                                       | `claude --chrome`                                                                                  |
+| `--chrome`                             | Web 自動化とテスト用の [Chrome ブラウザ統合](/ja/chrome) を有効化                                                                                                                         | `claude --chrome`                                                                                  |
 | `--continue`, `-c`                     | 現在のディレクトリで最新の会話を読み込む                                                                                                                                                   | `claude --continue`                                                                                |
```

</details>

<details>
<summary>common-workflows-ja.md</summary>

```diff
diff --git a/docs-ja/pages/common-workflows-ja.md b/docs-ja/pages/common-workflows-ja.md
index c547806..514a2d4 100644
--- a/docs-ja/pages/common-workflows-ja.md
+++ b/docs-ja/pages/common-workflows-ja.md
@@ -86,5 +86,5 @@
   * 探しているものについて具体的に説明する
   * プロジェクトのドメイン言語を使用する
-  * 言語用の[コード インテリジェンス プラグイン](/ja/discover-plugins#code-intelligence)をインストールして、Claude に正確な'定義に移動'と'参照を検索'のナビゲーション機能を提供する
+  * 言語の[コード インテリジェンス プラグイン](/ja/discover-plugins#code-intelligence)をインストールして、Claude に正確な'定義に移動'と'参照を検索'のナビゲーション機能を提供する
 </Tip>
 
@@ -96,5 +96,5 @@
 
 <Steps>
-  <Step title="エラーを Claude と共有する">
+  <Step title="Claude とエラーを共有する">
     ```
     > I'm seeing an error when I run npm test 
@@ -159,6 +159,6 @@
 
   * Claude に最新のアプローチの利点を説明するよう依頼する
-  * 必要に応じて変更が後方互換性を維持することをリクエストする
-  * リファクタリングを小さくテスト可能な増分で実行する
+  * 必要に応じて、変更が後方互換性を維持することをリクエストする
+  * リファクタリングを小さく、テスト可能な増分で実行する
 </Tip>
 
@@ -219,6 +219,6 @@
   * チーム共有用に `.claude/agents/` にプロジェクト固有の subagent を作成する
   * 自動委譲を有効にするために説明的な `description` フィールドを使用する
```

</details>

<details>
<summary>data-usage-ja.md</summary>

```diff
diff --git a/docs-ja/pages/data-usage-ja.md b/docs-ja/pages/data-usage-ja.md
index db15419..d10bcf9 100644
--- a/docs-ja/pages/data-usage-ja.md
+++ b/docs-ja/pages/data-usage-ja.md
@@ -12,5 +12,5 @@
 
 **コンシューマーユーザー（Free、Pro、Max プラン）**：
-将来の Claude モデルの改善のためにデータを使用することを許可するかどうかを選択できます。この設定がオンの場合、Free、Pro、Max アカウントからのデータを使用して新しいモデルをトレーニングします（これらのアカウントから Claude Code を使用する場合を含む）。
+将来の Claude モデルの改善のためにデータを使用することを許可するかどうかを選択できます。この設定がオンの場合、Free、Pro、Max アカウントからのデータを使用して新しいモデルをトレーニングします（これらのアカウントから Claude Code を使用する場合も含みます）。
 
 **商用ユーザー**：（Team および Enterprise プラン、API、サードパーティプラットフォーム、Claude Gov）既存のポリシーを維持します。Anthropic は、商用条件の下で Claude Code に送信されたコードまたはプロンプトを使用して生成モデルをトレーニングしません。ただし、カスタマーがモデル改善のためにデータを提供することを選択した場合は除きます（例えば、[Developer Partner Program](https://support.claude.com/ja/articles/11174108-about-the-development-partner-program)）。
@@ -46,11 +46,13 @@ Anthropic は、アカウントタイプと設定に基づいて Claude Code デ
 * ローカルキャッシング：Claude Code クライアントは、セッション再開を有効にするために、セッションをローカルに最大 30 日間保存できます（設定可能）
 
-データ保持慣行の詳細については、[Privacy Center](https://privacy.anthropic.com/) をご覧ください。
+Web 上の個別の Claude Code セッションはいつでも削除できます。セッションを削除すると、セッションのイベントデータが永久に削除されます。セッションの削除方法については、[Managing sessions](/ja/claude-code-on-the-web#managing-sessions) を参照してください。
 
-詳細については、[Commercial Terms of Service](https://www.anthropic.com/legal/commercial-terms)（Team、Enterprise、API ユーザー向け）または [Consumer Terms](https://www.anthropic.com/legal/consumer-terms)（Free、Pro、Max ユーザー向け）および [Privacy Policy](https://www.anthropic.com/legal/privacy) をご確認ください。
+データ保持慣行の詳細については、[Privacy Center](https://privacy.anthropic.com/) を参照してください。
+
+詳細については、[Commercial Terms of Service](https://www.anthropic.com/legal/commercial-terms)（Team、Enterprise、API ユーザー向け）または [Consumer Terms](https://www.anthropic.com/legal/consumer-terms)（Free、Pro、Max ユーザー向け）および [Privacy Policy](https://www.anthropic.com/legal/privacy) を確認してください。
 
 ## データアクセス
 
-すべてのファーストパーティユーザーの場合、[ローカル Claude Code](#local-claude-code-data-flow-and-dependencies) および [リモート Claude Code](#cloud-execution-data-flow-and-dependencies) でログされるデータについて詳しく知ることができます。[Remote Control](/ja/remote-control) セッションは、すべての実行がマシン上で行われるため、ローカルデータフローに従います。リモート Claude Code の場合、Claude は Claude Code セッションを開始するリポジトリにアクセスします。Claude は接続したが、セッションを開始していないリポジトリにはアクセスしません。
+すべてのファーストパーティユーザーの場合、[ローカル Claude Code](#local-claude-code-data-flow-and-dependencies) および [リモート Claude Code](#cloud-execution-data-flow-and-dependencies) に対してログされるデータについて詳しく知ることができます。[Remote Control](/ja/remote-control) セッションは、すべての実行がマシン上で行われるため、ローカルデータフローに従います。リモート Claude Code の場合、Claude は Claude Code セッションを開始するリポジトリにアクセスします。Claude は接続したが、セッションを開始していないリポジトリにはアクセスしません。
 
 ## ローカル Claude Code：データフローと依存関係
@@ -68,5 +70,5 @@ Claude Code は Anthropic の API 上に構築されています。API のセキ
 [Claude Code on the web](/ja/claude-code-on-the-web) を使用する場合、セッションはローカルではなく Anthropic が管理する仮想マシンで実行されます。クラウド環境では：
```

</details>

<details>
<summary>features-overview-ja.md</summary>

```diff
diff --git a/docs-ja/pages/features-overview-ja.md b/docs-ja/pages/features-overview-ja.md
index f699edc..219f5c6 100644
--- a/docs-ja/pages/features-overview-ja.md
+++ b/docs-ja/pages/features-overview-ja.md
@@ -27,60 +27,76 @@ Claude Code は、コードについて推論するモデルと、ファイル
 * **[Plugins](/ja/plugins)** と **[marketplaces](/ja/plugin-marketplaces)** はこれらの機能をパッケージ化して配布します
 
-[Skills](/ja/skills) は最も柔軟な拡張機能です。skill は知識、ワークフロー、または指示を含むマークダウンファイルです。`/deploy` のようなスラッシュコマンドで skill を呼び出すことができます。または Claude は関連する場合に自動的にそれらを読み込むことができます。skill は現在の会話で実行することも、subagents を介して分離されたコンテキストで実行することもできます。
+[Skills](/ja/skills) は最も柔軟な拡張機能です。スキルは、知識、ワークフロー、または指示を含むマークダウンファイルです。`/deploy` のようなコマンドでスキルを呼び出すことができます。または Claude は関連する場合に自動的にスキルをロードできます。スキルは現在の会話で実行することも、subagents を介して独立したコンテキストで実行することもできます。
 
 ## 機能をあなたの目標に合わせる
 
-機能は、Claude がすべてのセッションで見る常時オンのコンテキストから、あなたまたは Claude が呼び出すことができるオンデマンド機能、特定のイベントで実行されるバックグラウンド自動化まで、さまざまです。以下の表は、利用可能なものと各機能が意味をなす場合を示しています。
+機能は、Claude がすべてのセッションで見る常時オンのコンテキストから、あなたまたは Claude が呼び出すことができるオンデマンド機能、特定のイベントで実行される背景自動化まで、さまざまです。以下の表は、利用可能なものと各機能が意味をなす場合を示しています。
 
-| 機能                                 | 機能                           | 使用する場合                            | 例                                                               |
-| ---------------------------------- | ---------------------------- | --------------------------------- | --------------------------------------------------------------- |
-| **CLAUDE.md**                      | すべての会話で読み込まれる永続的なコンテキスト      | プロジェクト規約、「常に X を実行する」ルール          | 「npm ではなく pnpm を使用します。コミット前にテストを実行します。」                         |
-| **Skill**                          | Claude が使用できる指示、知識、ワークフロー    | 再利用可能なコンテンツ、リファレンスドキュメント、反復可能なタスク | `/review` はコードレビューチェックリストを実行します。エンドポイントパターンを持つ API ドキュメント skill |
-| **Subagent**                       | 要約された結果を返す分離された実行コンテキスト      | コンテキスト分離、並列タスク、特殊なワーカー            | 多くのファイルを読み取るが、主要な結果のみを返す研究タスク                                   |
-| **[Agent teams](/ja/agent-teams)** | 複数の独立した Claude Code セッションを調整 | 並列研究、新機能開発、競合する仮説でのデバッグ           | セキュリティ、パフォーマンス、テストを同時にチェックするレビュアーをスポーン                          |
-| **MCP**                            | 外部サービスに接続                    | 外部データまたはアクション                     | データベースをクエリ、Slack に投稿、ブラウザを制御                                    |
-| **Hook**                           | イベントで実行される決定論的スクリプト          | 予測可能な自動化、LLM は関与しない               | すべてのファイル編集後に ESLint を実行                                         |
+| 機能                                 | 機能                           | 使用する場合                           | 例                                                            |
+| ---------------------------------- | ---------------------------- | -------------------------------- | ------------------------------------------------------------ |
+| **CLAUDE.md**                      | すべての会話で読み込まれる永続的なコンテキスト      | プロジェクト規約、「常に X を実行する」ルール         | 「pnpm を使用し、npm は使用しない。コミット前にテストを実行する。」                       |
+| **Skill**                          | Claude が使用できる指示、知識、ワークフロー    | 再利用可能なコンテンツ、リファレンスドキュメント、繰り返しタスク | `/review` はコードレビューチェックリストを実行します。エンドポイントパターンを持つ API ドキュメントスキル |
+| **Subagent**                       | サマリー結果を返す独立した実行コンテキスト        | コンテキスト分離、並列タスク、専門的なワーカー          | 多くのファイルを読み取るが、主要な結果のみを返す研究タスク                                |
+| **[Agent teams](/ja/agent-teams)** | 複数の独立した Claude Code セッションを調整 | 並列研究、新機能開発、競合する仮説でのデバッグ          | セキュリティ、パフォーマンス、テストを同時にチェックするレビュアーをスポーン                       |
+| **MCP**                            | 外部サービスに接続                    | 外部データまたはアクション                    | データベースをクエリ、Slack に投稿、ブラウザを制御                                 |
```

</details>

*...以降省略*

</details>


<details>
<summary>2026-03-01</summary>

**変更ファイル:**

```
 docs-ja/pages/changelog.md | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)
```

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index 1782136..a1a1615 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,33 @@
 # Changelog
 
+## 2.1.63
+
+- Added `/simplify` and `/batch` bundled slash commands
+- Fixed local slash command output like /cost appearing as user-sent messages instead of system messages in the UI
+- Project configs & auto memory now shared across git worktrees of the same repository
+- Added `ENABLE_CLAUDEAI_MCP_SERVERS=false` env var to opt out from making claude.ai MCP servers available
+- Improved `/model` command to show the currently active model in the slash command menu
+- Added HTTP hooks, which can POST JSON to a URL and receive JSON instead of running a shell command
+- Fixed listener leak in bridge polling loop
+- Fixed listener leak in MCP OAuth flow cleanup
+- Added manual URL paste fallback during MCP OAuth authentication. If the automatic localhost redirect doesn't work, you can paste the callback URL to complete authentication.
+- Fixed memory leak when navigating hooks configuration menu
+- Fixed listener leak in interactive permission handler during auto-approvals
+- Fixed file count cache ignoring glob ignore patterns
+- Fixed memory leak in bash command prefix cache
+- Fixed MCP tool/resource cache leak on server reconnect
+- Fixed IDE host IP detection cache incorrectly sharing results across ports
+- Fixed WebSocket listener leak on transport reconnect
+- Fixed memory leak in git root detection cache that could cause unbounded growth in long-running sessions
+- Fixed memory leak in JSON parsing cache that grew unbounded over long sessions
+- VSCode: Fixed remote sessions not appearing in conversation history
+- Fixed a race condition in the REPL bridge where new messages could arrive at the server interleaved with historical messages during the initial connection flush, causing message ordering issues.
+- Fixed memory leak where long-running teammates retained all messages in AppState even after conversation compaction
```

</details>

</details>


<details>
<summary>2026-02-28</summary>

**変更ファイル:**

```
 docs-ja/pages/agent-teams-ja.md            |  166 +--
 docs-ja/pages/analytics-ja.md              |  225 +++-
 docs-ja/pages/best-practices-ja.md         |  226 ++--
 docs-ja/pages/changelog.md                 |    4 +
 docs-ja/pages/claude-code-on-the-web-ja.md |  104 +-
 docs-ja/pages/cli-reference-ja.md          |  189 +--
 docs-ja/pages/common-workflows-ja.md       |  312 +++--
 docs-ja/pages/costs-ja.md                  |  210 ++-
 docs-ja/pages/data-usage-ja.md             |   34 +-
 docs-ja/pages/desktop-ja.md                |  154 +--
 docs-ja/pages/discover-plugins-ja.md       |  256 ++--
 docs-ja/pages/fast-mode-en.md              |  131 --
 docs-ja/pages/github-actions-ja.md         |  150 +--
 docs-ja/pages/gitlab-ci-cd-ja.md           |  106 +-
 docs-ja/pages/headless-ja.md               |   35 +-
 docs-ja/pages/hooks-guide-ja.md            |  726 +++++++---
 docs-ja/pages/hooks-ja.md                  | 1988 +++++++++++++++++++---------
 docs-ja/pages/interactive-mode-ja.md       |  205 +--
 docs-ja/pages/keybindings-ja.md            |   58 +-
 docs-ja/pages/memory-ja.md                 |  232 +++-
 docs-ja/pages/model-config-ja.md           |  137 +-
 docs-ja/pages/plugin-marketplaces-ja.md    |  367 +++--
 docs-ja/pages/plugins-ja.md                |  122 +-
 docs-ja/pages/plugins-reference-ja.md      |   64 +-
 docs-ja/pages/quickstart-ja.md             |  276 ++--
 docs-ja/pages/remote-control-ja.md         |   24 +-
 docs-ja/pages/sandboxing-ja.md             |  188 +--
 docs-ja/pages/settings-ja.md               |  517 ++++----
 docs-ja/pages/skills-ja.md                 |  138 +-
 docs-ja/pages/statusline-ja.md             | 1003 +++++++++++---
 docs-ja/pages/sub-agents-ja.md             |  140 +-
 docs-ja/pages/troubleshooting-ja.md        |  791 ++++++++---
 docs-ja/pages/vs-code-ja.md                |  166 ++-
 33 files changed, 6073 insertions(+), 3371 deletions(-)
```

**新規追加:**


**削除:**


<details>
<summary>agent-teams-ja.md</summary>

```diff
diff --git a/docs-ja/pages/agent-teams-ja.md b/docs-ja/pages/agent-teams-ja.md
index 9a5868d..cb1edf7 100644
--- a/docs-ja/pages/agent-teams-ja.md
+++ b/docs-ja/pages/agent-teams-ja.md
@@ -8,10 +8,10 @@
 
 <Warning>
-  エージェントチームは実験的機能であり、デフォルトでは無効です。[settings.json](/ja/settings) または環境に `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS` を追加して有効にしてください。エージェントチームには、セッション再開、タスク調整、シャットダウン動作に関する[既知の制限](#limitations)があります。
+  エージェントチームは実験的機能であり、デフォルトでは無効です。`CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS` を [settings.json](/ja/settings) または環境に追加して有効にしてください。エージェントチームには、セッション再開、タスク調整、シャットダウン動作に関する [既知の制限](#limitations) があります。
 </Warning>
 
 エージェントチームを使用すると、複数の Claude Code インスタンスが連携して動作するように調整できます。1 つのセッションがチームリーダーとして機能し、作業を調整し、タスクを割り当て、結果を統合します。チームメイトは独立して動作し、それぞれ独自のコンテキストウィンドウで動作し、互いに直接通信します。
 
-単一セッション内で実行され、メインエージェントにのみ報告できる[subagents](/ja/sub-agents)とは異なり、リーダーを経由せずに個別のチームメイトと直接対話することもできます。
+単一セッション内で実行され、メインエージェントにのみ報告できる [subagents](/ja/sub-agents) とは異なり、リーダーを経由せずに個別のチームメイトと直接対話することもできます。
 
 このページでは、以下について説明します。
@@ -24,21 +24,21 @@
 ## エージェントチームを使用する場合
 
-エージェントチームは、並列探索が実際の価値を追加するタスクに最も効果的です。完全なシナリオについては、[ユースケース例](#use-case-examples)を参照してください。最も強力なユースケースは以下の通りです。
+エージェントチームは、並列探索が実際の価値を追加するタスクに最も効果的です。完全なシナリオについては、[ユースケース例](#use-case-examples) を参照してください。最も強力なユースケースは以下の通りです。
 
 * **研究とレビュー**: 複数のチームメイトが問題のさまざまな側面を同時に調査し、その後、互いの発見を共有して異議を唱えることができます
 * **新しいモジュールまたは機能**: チームメイトは、互いに干渉することなく、個別のピースを所有できます
 * **競合する仮説でのデバッグ**: チームメイトは異なる理論を並列でテストし、より速く答えに収束します
-* **クロスレイヤー調整**: フロントエンド、バックエンド、テストにまたがる変更。各チームメイトが異なるレイヤーを所有します
+* **クロスレイヤー調整**: フロントエンド、バックエンド、テストにまたがる変更。各チームメイトが異なる部分を所有します
 
-エージェントチームは調整オーバーヘッドを追加し、単一セッションよりも大幅に多くのトークンを使用します。チームメイトが独立して動作できる場合に最適です。順序付きタスク、同じファイルの編集、または多くの依存関係を持つ作業の場合、単一セッションまたは[subagents](/ja/sub-agents)がより効果的です。
```

</details>

<details>
<summary>analytics-ja.md</summary>

```diff
diff --git a/docs-ja/pages/analytics-ja.md b/docs-ja/pages/analytics-ja.md
index 9a53dd2..ef46769 100644
--- a/docs-ja/pages/analytics-ja.md
+++ b/docs-ja/pages/analytics-ja.md
@@ -3,89 +3,222 @@
 > Use this file to discover all available pages before exploring further.
 
-# 分析
+# チームの使用状況を分析で追跡する
 
-> 組織の Claude Code デプロイメントの詳細な使用状況インサイトと生産性メトリクスを表示します。
+> Claude Code の使用メトリクスを表示し、採用状況を追跡し、分析ダッシュボードでエンジニアリング速度を測定します。
 
-Claude Code は、組織が開発者の使用パターンを理解し、生産性メトリクスを追跡し、Claude Code の採用を最適化するのに役立つ分析ダッシュボードを提供します。
+Claude Code は、組織が開発者の使用パターンを理解し、貢献メトリクスを追跡し、Claude Code がエンジニアリング速度にどのような影響を与えるかを測定するのに役立つ分析ダッシュボードを提供します。お客様のプランに応じたダッシュボードにアクセスしてください。
+
+| プラン                           | ダッシュボード URL                                                                | 含まれる内容                                        | 詳細                                               |
+| ----------------------------- | -------------------------------------------------------------------------- | --------------------------------------------- | ------------------------------------------------ |
+| Claude for Teams / Enterprise | [claude.ai/analytics/claude-code](https://claude.ai/analytics/claude-code) | 使用メトリクス、GitHub 統合による貢献メトリクス、リーダーボード、データエクスポート | [詳細](#access-analytics-for-teams-and-enterprise) |
+| API（Claude Console）           | [platform.claude.com/claude-code](https://platform.claude.com/claude-code) | 使用メトリクス、支出追跡、チームインサイト                         | [詳細](#access-analytics-for-api-customers)        |
+
+## Teams と Enterprise の分析にアクセスする
+
+[claude.ai/analytics/claude-code](https://claude.ai/analytics/claude-code) に移動してください。管理者とオーナーがダッシュボードを表示できます。
+
+Teams と Enterprise ダッシュボードには以下が含まれます。
+
+* **使用メトリクス**：受け入れられたコード行数、提案受け入れ率、日次アクティブユーザー数とセッション数
+* **貢献メトリクス**：[GitHub 統合](#enable-contribution-metrics)を使用した Claude Code 支援による PR とシップされたコード行数
+* **リーダーボード**：Claude Code 使用量でランク付けされたトップコントリビューター
```

</details>

<details>
<summary>best-practices-ja.md</summary>

```diff
diff --git a/docs-ja/pages/best-practices-ja.md b/docs-ja/pages/best-practices-ja.md
index 62335da..0c3296d 100644
--- a/docs-ja/pages/best-practices-ja.md
+++ b/docs-ja/pages/best-practices-ja.md
@@ -17,9 +17,9 @@ Claude Code は agentic coding 環境です。質問に答えて待つチャッ
 ***
 
-ほとんどのベストプラクティスは 1 つの制約に基づいています。Claude のコンテキストウィンドウはすぐにいっぱいになり、いっぱいになるにつれてパフォーマンスが低下します。
+ほとんどのベストプラクティスは 1 つの制約に基づいています。Claude のコンテキストウィンドウはすぐにいっぱいになり、満杯になるにつれてパフォーマンスが低下します。
 
-Claude のコンテキストウィンドウは、すべてのメッセージ、Claude が読み取ったすべてのファイル、およびすべてのコマンド出力を含む、会話全体を保持します。ただし、これはすぐにいっぱいになる可能性があります。単一のデバッグセッションまたはコードベース探索でも、数万のトークンを生成および消費する可能性があります。
+Claude のコンテキストウィンドウは、すべてのメッセージ、Claude が読み取ったすべてのファイル、およびすべてのコマンド出力を含む、会話全体を保持します。ただし、これはすぐにいっぱいになる可能性があります。単一のデバッグセッションまたはコードベース探索でも、数万トークンを生成および消費する可能性があります。
 
-これは重要です。LLM のパフォーマンスはコンテキストがいっぱいになるにつれて低下するためです。コンテキストウィンドウがいっぱいになりかけると、Claude は以前の指示を「忘れる」か、より多くの間違いを犯す可能性があります。コンテキストウィンドウは管理する最も重要なリソースです。トークン使用量を削減するための詳細な戦略については、[トークン使用量を削減する](/ja/costs#reduce-token-usage)を参照してください。
+LLM のパフォーマンスはコンテキストが満杯になるにつれて低下するため、これは重要です。コンテキストウィンドウがいっぱいになると、Claude は以前の指示を「忘れる」か、より多くの間違いを犯す可能性があります。コンテキストウィンドウは管理する最も重要なリソースです。[カスタムステータスライン](/ja/statusline)でコンテキスト使用量を継続的に追跡し、[トークン使用量を削減](/ja/costs#reduce-token-usage)でトークン使用量を削減するための戦略を参照してください。
 
 ***
@@ -28,5 +28,5 @@ Claude のコンテキストウィンドウは、すべてのメッセージ、C
 
 <Tip>
-  テスト、スクリーンショット、または期待される出力を含めて、Claude が自分自身をチェックできるようにします。これは実行できる最も高いレバレッジのことです。
+  テスト、スクリーンショット、または期待される出力を含めて、Claude が自分自身をチェックできるようにします。これはあなたができる最も高いレバレッジのことです。
 </Tip>
 
@@ -41,7 +41,7 @@ Claude は、テストを実行したり、スクリーンショットを比較
 | **症状ではなく根本原因に対処する** | *「ビルドが失敗している」*           | *「ビルドがこのエラーで失敗している：\[エラーを貼り付け]。修正して、ビルドが成功することを確認する。根本原因に対処し、エラーを抑制しない」*                                                                               |
 
-UI の変更は、[Chrome 拡張機能の Claude](/ja/chrome)を使用して検証できます。ブラウザで新しいタブを開き、UI をテストし、コードが機能するまで反復します。
+UI の変更は [Chrome 拡張機能の Claude](/ja/chrome) を使用して検証できます。これはブラウザで新しいタブを開き、UI をテストし、コードが機能するまで反復します。
 
```

</details>

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index 2c6f0d5..1782136 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,8 @@
 # Changelog
 
+## 2.1.62
+
+- Fixed prompt suggestion cache regression that reduced cache hit rates
+
 ## 2.1.61
 
```

</details>

<details>
<summary>claude-code-on-the-web-ja.md</summary>

```diff
diff --git a/docs-ja/pages/claude-code-on-the-web-ja.md b/docs-ja/pages/claude-code-on-the-web-ja.md
index 4cc0884..b933fc3 100644
--- a/docs-ja/pages/claude-code-on-the-web-ja.md
+++ b/docs-ja/pages/claude-code-on-the-web-ja.md
@@ -21,7 +21,7 @@
 * **バックエンド変更**：Claude Code がテストを作成してからそのテストに合格するコードを作成できる場所
 
-Claude Code は Claude アプリの [iOS](https://apps.apple.com/us/app/claude-by-anthropic/id6473753684) および [Android](https://play.google.com/store/apps/details?id=com.anthropic.claude) でも利用可能で、移動中にタスクを開始し、進行中の作業を監視できます。
+Claude Code は [iOS](https://apps.apple.com/us/app/claude-by-anthropic/id6473753684) および [Android](https://play.google.com/store/apps/details?id=com.anthropic.claude) の Claude アプリでも利用可能で、外出先でタスクを開始し、進行中の作業を監視できます。
 
-ローカルとリモート開発の間を移動できます：`&` プレフィックスで [ターミナルからウェブで実行するタスクを送信](#from-terminal-to-web)するか、[ウェブセッションをターミナルにテレポート](#from-web-to-terminal)してローカルで続行します。クラウドインフラストラクチャの代わりに自分のマシンで Claude Code を実行しながらウェブインターフェースを使用するには、[リモートコントロール](/ja/remote-control) を参照してください。
+ターミナルから `--remote` を使用して[ウェブで新しいタスクを開始](/ja/remote-control)したり、[ウェブセッションをターミナルにテレポート](#from-web-to-terminal)してローカルで続行したりできます。クラウドインフラストラクチャの代わりに自分のマシンで Claude Code を実行しながらウェブインターフェースを使用するには、[リモートコントロール](/ja/remote-control)を参照してください。
 
 ## ウェブ上の Claude Code は誰が使用できますか？
@@ -70,21 +70,13 @@ diff ビューから、以下のことができます：
 ## ウェブとターミナル間でタスクを移動する
 
-ウェブでタスクを開始してターミナルで続行するか、ターミナルからウェブで実行するタスクを送信できます。ウェブセッションはラップトップを閉じても保持され、Claude iOS アプリを含む任意の場所から監視できます。
+ターミナルからウェブで新しいタスクを開始したり、ウェブセッションをターミナルに取り込んでローカルで続行したりできます。ウェブセッションはラップトップを閉じても保持され、Claude モバイルアプリを含む任意の場所から監視できます。
 
 <Note>
-  セッションハンドオフは一方向です：ウェブセッションをターミナルにプルできますが、既存のターミナルセッションをウェブにプッシュすることはできません。[`&` プレフィックス](#from-terminal-to-web)は現在の会話コンテキストで*新しい*ウェブセッションを作成します。
+  セッションハンドオフは一方向です：ウェブセッションをターミナルに取り込むことはできますが、既存のターミナルセッションをウェブにプッシュすることはできません。`--remote` フラグは現在のリポジトリの*新しい*ウェブセッションを作成します。
 </Note>
 
 ### ターミナルからウェブへ
 
-Claude Code 内のメッセージを `&` で開始して、ウェブで実行するタスクを送信します：
-
-```
```

</details>

<details>
<summary>cli-reference-ja.md</summary>

```diff
diff --git a/docs-ja/pages/cli-reference-ja.md b/docs-ja/pages/cli-reference-ja.md
index 4c3f3d1..2daa6ce 100644
--- a/docs-ja/pages/cli-reference-ja.md
+++ b/docs-ja/pages/cli-reference-ja.md
@@ -9,20 +9,22 @@
 ## CLI コマンド
 
-| コマンド                            | 説明                                                                                                                                                              | 例                                            |
-| :------------------------------ | :-------------------------------------------------------------------------------------------------------------------------------------------------------------- | :------------------------------------------- |
-| `claude`                        | インタラクティブ REPL を開始                                                                                                                                               | `claude`                                     |
-| `claude "query"`                | 初期プロンプト付きで REPL を開始                                                                                                                                             | `claude "explain this project"`              |
-| `claude -p "query"`             | SDK 経由でクエリを実行してから終了                                                                                                                                             | `claude -p "explain this function"`          |
-| `cat file \| claude -p "query"` | パイプされたコンテンツを処理                                                                                                                                                  | `cat logs.txt \| claude -p "explain"`        |
-| `claude -c`                     | 現在のディレクトリで最新の会話を続行                                                                                                                                              | `claude -c`                                  |
-| `claude -c -p "query"`          | SDK 経由で続行                                                                                                                                                       | `claude -c -p "Check for type errors"`       |
-| `claude -r "<session>" "query"` | セッション ID または名前でセッションを再開                                                                                                                                         | `claude -r "auth-refactor" "Finish this PR"` |
-| `claude update`                 | 最新バージョンに更新                                                                                                                                                      | `claude update`                              |
-| `claude auth login`             | Anthropic アカウントにサインイン                                                                                                                                           | `claude auth login`                          |
-| `claude auth logout`            | Anthropic アカウントからログアウト                                                                                                                                          | `claude auth logout`                         |
-| `claude auth status`            | 認証ステータスを表示                                                                                                                                                      | `claude auth status`                         |
-| `claude agents`                 | すべての設定済み [subagents](/ja/sub-agents) をソース別にグループ化して一覧表示                                                                                                          | `claude agents`                              |
-| `claude mcp`                    | Model Context Protocol（MCP）サーバーを設定                                                                                                                              | [Claude Code MCP ドキュメント](/ja/mcp)を参照してください。  |
-| `claude remote-control`         | [Remote Control セッション](/ja/remote-control)を開始して、ローカルで実行中の Claude Code を Claude.ai または Claude アプリから制御します。フラグについては [Remote Control](/ja/remote-control) を参照してください | `claude remote-control`                      |
+これらのコマンドを使用して、セッションを開始し、コンテンツをパイプし、会話を再開し、更新を管理できます。
+
+| コマンド                            | 説明                                                                                                                                                               | 例                                                  |
+| :------------------------------ | :--------------------------------------------------------------------------------------------------------------------------------------------------------------- | :------------------------------------------------- |
+| `claude`                        | インタラクティブセッションを開始                                                                                                                                                 | `claude`                                           |
+| `claude "query"`                | 初期プロンプト付きでインタラクティブセッションを開始                                                                                                                                       | `claude "explain this project"`                    |
+| `claude -p "query"`             | SDK 経由でクエリを実行してから終了                                                                                                                                              | `claude -p "explain this function"`                |
```

</details>

*...以降省略*

</details>


<details>
<summary>2026-02-27</summary>

**変更ファイル:**

```
 docs-ja/pages/changelog.md | 15 +++++++++++++++
 1 file changed, 15 insertions(+)
```

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index 3247963..2c6f0d5 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,19 @@
 # Changelog
 
+## 2.1.61
+
+- Fixed concurrent writes corrupting config file on Windows
+
+## 2.1.59
+
+- Claude automatically saves useful context to auto-memory. Manage with /memory
+- Added `/copy` command to show an interactive picker when code blocks are present, allowing selection of individual code blocks or the full response.
+- Improved "always allow" prefix suggestions for compound bash commands (e.g. `cd /tmp && git fetch && git push`) to compute smarter per-subcommand prefixes instead of treating the whole command as one
+- Improved ordering of short task lists
+- Improved memory usage in multi-agent sessions by releasing completed subagent task state
+- Fixed MCP OAuth token refresh race condition when running multiple Claude Code instances simultaneously
+- Fixed shell commands not showing a clear error message when the working directory has been deleted
+- Fixed config file corruption that could wipe authentication when multiple Claude Code instances ran simultaneously
+
 ## 2.1.58
 
```

</details>

</details>


<details>
<summary>2026-02-26</summary>

**変更ファイル:**

```
 docs-ja/pages/changelog.md | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)
```

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index e14fe79..3247963 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,27 @@
 # Changelog
 
+## 2.1.58
+
+- Expand Remote Control to more users
+
+## 2.1.56
+
+- VS Code: Fixed another cause of "command 'claude-vscode.editor.openLast' not found" crashes
+
+## 2.1.55
+
+- Fixed BashTool failing on Windows with EINVAL error
+
+## 2.1.53
+
+- Fixed a UI flicker where user input would briefly disappear after submission before the message rendered
+- Fixed bulk agent kill (ctrl+f) to send a single aggregate notification instead of one per agent, and to properly clear the command queue
+- Fixed graceful shutdown sometimes leaving stale sessions when using Remote Control by parallelizing teardown network calls
+- Fixed `--worktree` sometimes being ignored on first launch
+- Fixed a panic ("switch on corrupted value") on Windows
+- Fixed a crash that could occur when spawning many processes on Windows
+- Fixed a crash in the WebAssembly interpreter on Linux x64 & Windows x64
+- Fixed a crash that sometimes occurred after 2 minutes on Windows ARM64
+
```

</details>

</details>


<details>
<summary>2026-02-25</summary>

**変更ファイル:**

```
 docs-ja/pages/agent-teams-ja.md             | 261 +++++++------
 docs-ja/pages/authentication-en.md          |  43 +-
 docs-ja/pages/changelog.md                  |  18 +
 docs-ja/pages/claude-code-on-the-web-ja.md  | 115 +++---
 docs-ja/pages/cli-reference-ja.md           | 177 +++++----
 docs-ja/pages/data-usage-ja.md              |  16 +-
 docs-ja/pages/desktop-ja.md                 | 556 +++++++++++++++++++++++---
 docs-ja/pages/how-claude-code-works-ja.md   | 147 +++----
 docs-ja/pages/overview-ja.md                |  50 +--
 docs-ja/pages/permissions-ja.md             | 167 ++++----
 docs-ja/pages/plugins-reference-ja.md       | 227 +++++------
 docs-ja/pages/quickstart-ja.md              |   4 +-
 docs-ja/pages/security-ja.md                | 107 ++---
 docs-ja/pages/server-managed-settings-en.md | 164 --------
 docs-ja/pages/settings-ja.md                | 587 ++++++++++++++--------------
 docs-ja/pages/setup-ja.md                   |  72 ++--
 docs-ja/pages/skills-ja.md                  | 394 ++++++++++---------
 docs-ja/pages/sub-agents-ja.md              | 278 +++++++------
 docs-ja/pages/troubleshooting-ja.md         | 291 +++++++-------
 19 files changed, 2053 insertions(+), 1621 deletions(-)
```

**新規追加:**


**削除:**


<details>
<summary>agent-teams-ja.md</summary>

```diff
diff --git a/docs-ja/pages/agent-teams-ja.md b/docs-ja/pages/agent-teams-ja.md
index 301d8fd..9a5868d 100644
--- a/docs-ja/pages/agent-teams-ja.md
+++ b/docs-ja/pages/agent-teams-ja.md
@@ -8,46 +8,52 @@
 
 <Warning>
-  エージェントチームは実験的機能であり、デフォルトでは無効です。`CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS` を [settings.json](/ja/settings) または環境に追加して有効にしてください。エージェントチームには、セッション再開、タスク調整、シャットダウン動作に関する [既知の制限](#limitations) があります。
+  エージェントチームは実験的機能であり、デフォルトでは無効です。[settings.json](/ja/settings) または環境に `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS` を追加して有効にしてください。エージェントチームには、セッション再開、タスク調整、シャットダウン動作に関する[既知の制限](#limitations)があります。
 </Warning>
 
-エージェントチームを使用すると、複数の Claude Code インスタンスが連携して動作するように調整できます。1 つのセッションがチームリーダーとして機能し、作業を調整し、タスクを割り当て、結果を統合します。チームメンバーは独立して動作し、それぞれ独自のコンテキストウィンドウで作業し、互いに直接通信します。
+エージェントチームを使用すると、複数の Claude Code インスタンスが連携して動作するように調整できます。1 つのセッションがチームリーダーとして機能し、作業を調整し、タスクを割り当て、結果を統合します。チームメイトは独立して動作し、それぞれ独自のコンテキストウィンドウで動作し、互いに直接通信します。
 
-単一セッション内で実行され、メインエージェントにのみ報告できる [subagents](/ja/sub-agents) とは異なり、リーダーを経由せずにチームメンバー個別と直接やり取りすることもできます。
+単一セッション内で実行され、メインエージェントにのみ報告できる[subagents](/ja/sub-agents)とは異なり、リーダーを経由せずに個別のチームメイトと直接対話することもできます。
 
 このページでは、以下について説明します。
 
-* [エージェントチームを使用する場合](#when-to-use-agent-teams)。ユースケースと subagents との比較を含みます
+* [エージェントチームを使用する場合](#when-to-use-agent-teams)。ベストユースケースと subagents との比較を含みます
 * [チームを開始する](#start-your-first-agent-team)
-* [チームメンバーを制御する](#control-your-agent-team)。表示モード、タスク割り当て、委任を含みます
+* [チームメイトを制御する](#control-your-agent-team)。表示モード、タスク割り当て、委任を含みます
 * [並列作業のベストプラクティス](#best-practices)
 
 ## エージェントチームを使用する場合
 
-エージェントチームは、並列探索が実際の価値を追加するタスクに最も効果的です。完全なシナリオについては、[ユースケース例](#use-case-examples) を参照してください。最も強力なユースケースは以下の通りです。
+エージェントチームは、並列探索が実際の価値を追加するタスクに最も効果的です。完全なシナリオについては、[ユースケース例](#use-case-examples)を参照してください。最も強力なユースケースは以下の通りです。
```

</details>

<details>
<summary>authentication-en.md</summary>

```diff
diff --git a/docs-ja/pages/authentication-en.md b/docs-ja/pages/authentication-en.md
index 76a4acc..25b933c 100644
--- a/docs-ja/pages/authentication-en.md
+++ b/docs-ja/pages/authentication-en.md
@@ -5,11 +5,30 @@
 # Authentication
 
-> Learn how to configure user authentication and credential management for Claude Code in your organization.
+> Log in to Claude Code and configure authentication for individuals, teams, and organizations.
 
-## Authentication methods
+Claude Code supports multiple authentication methods depending on your setup. Individual users can log in with a Claude.ai account, while teams can use Claude for Teams or Enterprise, the Claude Console, or a cloud provider like Amazon Bedrock, Google Vertex AI, or Microsoft Foundry.
 
-Setting up Claude Code requires access to Anthropic models. For teams, you can set up Claude Code access in one of these ways:
+## Log in to Claude Code
 
-* [Claude for Teams or Enterprise](#claude-for-teams-or-enterprise) (recommended)
+After [installing Claude Code](/en/setup#install-claude-code), run `claude` in your terminal. On first launch, Claude Code opens a browser window for you to log in.
+
+If the browser doesn't open automatically, press `c` to copy the login URL to your clipboard, then paste it into your browser.
+
+You can authenticate with any of these account types:
+
+* **Claude Pro or Max subscription**: log in with your Claude.ai account. Subscribe at [claude.com/pricing](https://claude.com/pricing).
+* **Claude for Teams or Enterprise**: log in with the Claude.ai account your team admin invited you to.
+* **Claude Console**: log in with your Console credentials. Your admin must have [invited you](#claude-console-authentication) first.
+* **Cloud providers**: if your organization uses [Amazon Bedrock](/en/amazon-bedrock), [Google Vertex AI](/en/google-vertex-ai), or [Microsoft Foundry](/en/microsoft-foundry), set the required environment variables before running `claude`. No browser login is needed.
+
+To log out and re-authenticate, type `/logout` at the Claude Code prompt.
+
```

</details>

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index 20d264b..e14fe79 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,22 @@
 # Changelog
 
+## 2.1.52
+
+- VS Code: Fixed extension crash on Windows ("command 'claude-vscode.editor.openLast' not found")
+
+## 2.1.51
+
+- Added `claude remote-control` subcommand for external builds, enabling local environment serving for all users.
+- Updated plugin marketplace default git timeout from 30s to 120s and added `CLAUDE_CODE_PLUGIN_GIT_TIMEOUT_MS` to configure.
+- Added support for custom npm registries and specific version pinning when installing plugins from npm sources
+- BashTool now skips login shell (`-l` flag) by default when a shell snapshot is available, improving command execution performance. Previously this required setting `CLAUDE_BASH_NO_LOGIN=true`.
+- Fixed a security issue where `statusLine` and `fileSuggestion` hook commands could execute without workspace trust acceptance in interactive mode.
+- Tool results larger than 50K characters are now persisted to disk (previously 100K). This reduces context window usage and improves conversation longevity.
+- Fixed a bug where duplicate `control_response` messages (e.g. from WebSocket reconnects) could cause API 400 errors by pushing duplicate assistant messages into the conversation.
+- Added `CLAUDE_CODE_ACCOUNT_UUID`, `CLAUDE_CODE_USER_EMAIL`, and `CLAUDE_CODE_ORGANIZATION_UUID` environment variables for SDK callers to provide account info synchronously, eliminating a race condition where early telemetry events lacked account metadata.
+- Fixed slash command autocomplete crashing when a plugin's SKILL.md description is a YAML array or other non-string type
+- The `/model` picker now shows human-readable labels (e.g., "Sonnet 4.5") instead of raw model IDs for pinned model versions, with an upgrade hint when a newer version is available.
+- Managed settings can now be set via macOS plist or Windows Registry. Learn more at https://code.claude.com/docs/en/settings#settings-files
+
 ## 2.1.50
 
```

</details>

<!-- UPDATE_LOG_END -->
