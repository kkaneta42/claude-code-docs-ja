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
<summary>2026-08-19</summary>

**変更ファイル:**

```
 docs-ja/pages/changelog.md                  | 22 ++++++++++++++++++++++
 docs-ja/pages/cross-session-messaging-en.md |  3 ++-
 2 files changed, 24 insertions(+), 1 deletion(-)
```

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index d4b7b0d..17b8091 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,26 @@
 # Changelog
 
+## 2.1.235
+
+- Added an optional `spellcheck` setting that underlines misspelled words in the prompt input as you type, using your installed `aspell`, `hunspell`, or `ispell`
+- Fixed whole-prompt-cache invalidation when a language server disconnected or reconnected mid-session
+- Fixed nested markdown list items misaligning at depth 3+ and added a hanging indent to wrapped list items in the terminal UI
+- Fixed prompt input highlights (slash commands, keywords, mentions) appearing shifted by one or more characters in some multi-line prompts
+- Fixed Shift+Tab inside the permission prompt's comment field approving the edit and granting session-wide edit permission instead of closing the field
+- Fixed the Agent tool advertising a general-purpose default in sessions where that agent is unavailable: an omitted `subagent_type` there now gets a clear error listing the available agents
+- Fixed notebook cell delete/replace approval dialogs silently omitting the existing cell content when the notebook or cell could not be read; the dialog now says why
+- Fixed slash commands run while Claude is responding showing HTML entities instead of the actual characters
+- Fixed the prompt footer not showing the "Update installed" restart notice after a background auto-update
+- Fixed the expanded task list (`ctrl+t`) always starting collapsed when resuming or relaunching into a session that still has open tasks
+- Improved memory and CPU usage while cloud sessions such as `/ultrareview` or `/autofix-pr` run in the background — their event streams are no longer re-scanned and re-rendered on every update
+- Improved permission dialogs: display text and "don't ask again" options now always match what a grant would cover, and "don't ask again" is withheld when contents cannot be fully displayed
+- Improved the embedded `grep` in native macOS/Linux builds: pathological patterns now fail fast instead of exhausting memory, and `-m N` with `-A/-C` prints correct context
+- Improved the context-limit error to say when auto-compact is off and point to `/config` to re-enable it
+- Vim mode: NORMAL mode and cursor position are now preserved when toggling the detailed transcript (ctrl+o) or closing a panel
+- Dialogs: arrow keys and Enter pressed in quick succession now select the option you navigated to instead of the previously highlighted one
+- `SendMessage` now refuses messages too large for cross-session delivery up front instead of silently dropping them
+- Remote Control: `claude rc` now applies the same enterprise-gateway availability check as interactive startup
+- [VSCode] Fixed focus jumping between open Claude tabs on its own when a window with several Claude panels is restored or reloaded
+
 ## 2.1.234
```

</details>

<details>
<summary>cross-session-messaging-en.md</summary>

```diff
diff --git a/docs-ja/pages/cross-session-messaging-en.md b/docs-ja/pages/cross-session-messaging-en.md
index 42ae59c..65e69b5 100644
--- a/docs-ja/pages/cross-session-messaging-en.md
+++ b/docs-ja/pages/cross-session-messaging-en.md
@@ -64,5 +64,5 @@ For what the message Claude writes looks like when it arrives, including an exam
 The receiving Claude reads the message between tool calls during an active turn, so a running tool is never interrupted. When the receiving session is idle, Claude Code starts a new turn with the message.
 
-Between two ordinary interactive sessions with default settings, Claude Code delivers the message. Delivery isn't guaranteed in every configuration, though. The receiving session checks each arriving message against its own [inbound controls](#control-inbound-messages), and the check ends in one of three outcomes:
+Between two ordinary interactive sessions with default settings, Claude Code delivers the message. Delivery isn't guaranteed in every configuration, though. Claude Code refuses a message [over the size cap](#limitations) in the sending session, before it leaves. The receiving session checks each arriving message against its own [inbound controls](#control-inbound-messages), and the check ends in one of three outcomes:
 
 * **Delivered**: Claude Code passes the message to the receiving Claude.
@@ -266,4 +266,5 @@ The limits here are properties of the messaging channel itself and apply whereve
 
 * **Plain text only**: Claude sends only plain text across sessions. Structured [agent team](/docs/en/agent-teams) protocol messages stay within a team.
+* **Same-machine message size is capped**: Claude Code refuses a message to a session on this machine once its serialized form passes about a million characters. The refusal [names the exact sizes](/docs/en/errors#message-too-large-for-cross-session-delivery). Nothing reaches the receiving session.
 * **Message loops are throttled**: Claude Code rate-limits repeated messages per sender, drops identical repeats arriving within a short window, and caps accepted messages waiting for Claude to read them at 50 per session. A message loop between two sessions therefore stops on its own.
 
```

</details>

</details>


<details>
<summary>2026-08-18</summary>

**変更ファイル:**

```
 docs-ja/pages/changelog.md | 54 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 54 insertions(+)
```

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index eaf481e..d4b7b0d 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,58 @@
 # Changelog
 
+## 2.1.234
+
+- Added the optional `CLAUDE_CODE_PROJECT_DIR_NAME` environment variable: hosts that give each session its own config directory can choose a short name for the per-project transcript directory
+- Added the `selection:clear` keybinding action, so a key can be bound to clear an in-app text selection; also works in the agents view
+- Added a GitLab merge request badge to the footer and statusline: repos with a GitLab remote and an authenticated glab CLI show MR !N with draft/pending/green states
+- Claude Code now continues your session automatically when a claude.ai usage limit resets; turn it off in `/config` ("Continue automatically at usage limit")
+- Claude is now told to use your account email only to identify you, and not to send it to unrelated services unless you ask
+- Security: remote file reads, session restore, CLAUDE.md includes, workflow scripts and file uploads now reject Windows NT-namespace (`\??\`) paths, hardening the remaining pre-approval file accesses against the NTLM credential-leak vector
+- Fixed auto mode in very long sessions repeatedly re-checking and denying sandboxed commands' network access after the conversation had been compacted
+- Fixed session-scoped permission answers (including denies) being dropped when answering background subagent tool permission prompts
+- Fixed a crash when an API response on the non-streaming fallback path (typically via third-party gateways) contained a thinking block missing its thinking field or a text block missing its text field
+- Fixed markdown rendering becoming extremely slow for some messages containing unusual Unicode sequences
+- Fixed `SendMessage` rejecting a recipient copied from `ListAgents` when the session name is at the 200-character cap or emoji-heavy
+- Fixed repository detection mis-reading the host of git remotes with unusual userinfo, producing links and repo-specific behavior for the wrong host
+- Fixed MCP diagnostics printing resolved secrets: scope-conflict warnings now show the configured `${VAR}` form, and connection-failure details show only the server origin
+- Fixed `strictKnownMarketplaces` allowlists accepting SCP-style git marketplace sources whose host differs from the one git would actually connect to
+- Fixed modal text such as the `/login` OAuth URL losing characters when copied in fullscreen
+- Fixed a `---` horizontal rule in rendered markdown running into the line after it
+- Fixed consecutive shell commands splitting into multiple "Ran 1 shell command" rows when todo/task updates were interleaved between them
+- Fixed dialogs like `/permissions` opened while a `!` shell command was running being dismissed when the command finished
+- Fixed a queued `!` shell command being sent to the model as plain text after pressing up-arrow to edit the queued input
+- Fixed queued messages reappearing in the prompt history while still queued, Esc while selecting a queued message no longer interrupts the turn, and `!` mode no longer sticks after a mid-turn submit
+- Fixed accepting the "Try the new fullscreen renderer?" prompt restarting the session without its permission mode (e.g. `--dangerously-skip-permissions`), tool allow/deny rules, model or effort flags
```

</details>

</details>


<details>
<summary>2026-08-17</summary>

**変更ファイル:**

```
 docs-ja/pages/self-hosted-environments-deploy-en.md | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
```

<details>
<summary>self-hosted-environments-deploy-en.md</summary>

```diff
diff --git a/docs-ja/pages/self-hosted-environments-deploy-en.md b/docs-ja/pages/self-hosted-environments-deploy-en.md
index fecb58d..a13a8fb 100644
--- a/docs-ja/pages/self-hosted-environments-deploy-en.md
+++ b/docs-ja/pages/self-hosted-environments-deploy-en.md
@@ -327,5 +327,5 @@ The following are the limitations in this release, with workarounds where one ex
 ### Connector traffic leaves your network
 
-Connector tools, such as GitHub, Slack, Linear, and the other claude.ai connectors, are called from Anthropic's side rather than from your runner, so when a self-hosted session uses a connector, that traffic routes through `api.anthropic.com`, not from inside your network boundary. To keep a connector out of self-hosted sessions, filter it like any other MCP server with the [`allowedMcpServers` and `deniedMcpServers` policy settings](/docs/en/managed-mcp#policy-based-control-with-allowlists-and-denylists), which apply to server-delivered connectors too. An allowlist you deploy for other servers also blocks delivered connectors. To keep connectors available alongside a URL-based allowlist, add entries that match the Anthropic proxy paths for server-delivered MCP servers:
+Anthropic calls connector tools, such as GitHub, Slack, Linear, and the other claude.ai connectors, from its own infrastructure rather than from your runner, so when Claude uses a connector in a self-hosted session, that traffic goes through `api.anthropic.com` rather than originating inside your network boundary. To keep a connector out of self-hosted sessions, filter it like any other MCP server with the [`allowedMcpServers` and `deniedMcpServers` policy settings](/docs/en/managed-mcp#policy-based-control-with-allowlists-and-denylists). Claude Code applies these settings to the connectors Anthropic delivers as well as to the servers you configure, so if you deploy an allowlist for other servers, Claude Code blocks delivered connectors too. To keep connectors available alongside a URL-based allowlist, add entries that match the Anthropic proxy paths for delivered connectors:
 
 * `https://api.anthropic.com/v2/ccr-sessions/*`
```

</details>

</details>


<details>
<summary>2026-08-16</summary>

**変更ファイル:**

```
 docs-ja/pages/self-hosted-environments-deploy-en.md | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)
```

<details>
<summary>self-hosted-environments-deploy-en.md</summary>

```diff
diff --git a/docs-ja/pages/self-hosted-environments-deploy-en.md b/docs-ja/pages/self-hosted-environments-deploy-en.md
index 505f1d2..fecb58d 100644
--- a/docs-ja/pages/self-hosted-environments-deploy-en.md
+++ b/docs-ja/pages/self-hosted-environments-deploy-en.md
@@ -327,5 +327,11 @@ The following are the limitations in this release, with workarounds where one ex
 ### Connector traffic leaves your network
 
-Connector tools, such as GitHub, Slack, Linear, and the other claude.ai connectors, are called from Anthropic's side rather than from your runner, so when a self-hosted session uses a connector, that traffic routes through `api.anthropic.com`, not from inside your network boundary. To keep a connector out of self-hosted sessions, filter it like any other MCP server with the [`allowedMcpServers` and `deniedMcpServers` policy settings](/docs/en/managed-mcp#policy-based-control-with-allowlists-and-denylists), which apply to server-delivered connectors too. An allowlist you deploy for other servers also blocks delivered connectors. To keep connectors available alongside a URL-based allowlist, add an entry matching the session proxy URL, such as `https://api.anthropic.com/v2/ccr-sessions/*`. If tool traffic must stay inside your network, run the equivalent tools as local MCP servers on the runner image instead. See [MCP servers](/docs/en/self-hosted-environments-configuration#mcp-servers).
+Connector tools, such as GitHub, Slack, Linear, and the other claude.ai connectors, are called from Anthropic's side rather than from your runner, so when a self-hosted session uses a connector, that traffic routes through `api.anthropic.com`, not from inside your network boundary. To keep a connector out of self-hosted sessions, filter it like any other MCP server with the [`allowedMcpServers` and `deniedMcpServers` policy settings](/docs/en/managed-mcp#policy-based-control-with-allowlists-and-denylists), which apply to server-delivered connectors too. An allowlist you deploy for other servers also blocks delivered connectors. To keep connectors available alongside a URL-based allowlist, add entries that match the Anthropic proxy paths for server-delivered MCP servers:
+
+* `https://api.anthropic.com/v2/ccr-sessions/*`
+* `https://api.anthropic.com/v1/code/sessions/*`
+* `https://api.anthropic.com/v1/code/mcp/*`
+
+If tool traffic must stay inside your network, run the equivalent tools as local MCP servers on the runner image instead. See [MCP servers](/docs/en/self-hosted-environments-configuration#mcp-servers).
 
 ### Some sessions don't count as idle
```

</details>

</details>


<details>
<summary>2026-08-15</summary>

**変更ファイル:**

```
 docs-ja/pages/changelog.md                         | 23 ++++++++++++++++++++++
 .../self-hosted-environments-configuration-en.md   |  2 +-
 2 files changed, 24 insertions(+), 1 deletion(-)
```

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index bf6c837..eaf481e 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,27 @@
 # Changelog
 
+## 2.1.233
+
+- Added GitLab merge request URL support to the `--worktree` flag and the `claude agents` view (where MRs display as `!N`)
+- Added an opt-in `forward_user_identity` apps gateway setting on Anthropic upstreams that sends the signed-in user's identity as headers, so a proxy behind the gateway can attribute spend per user
+- Added opt-in memory cgroup support for Bash tool commands on Linux (`CLAUDE_CODE_TOOL_MEMORY_LIMIT`) so a runaway build can't stall the session
+- Added `CLAUDE_CODE_WEBFETCH_CACHE_TTL_MS` environment variable to configure the WebFetch session URL cache TTL (default unchanged: 15 minutes)
+- Fixed cloud sessions occasionally being marked as lost when the environment shut down while Claude was waiting on a permission prompt
+- Fixed MCP v2 connections endlessly reopening the subscriptions/listen stream against servers that terminate long-held streams on a fixed timeout (e.g. serverless hosts)
+- Fixed Notification hooks not firing for permission prompts when running under Claude Desktop or VS Code
+- Fixed idle sessions on Linux sometimes keeping one CPU core at 100% when sandboxing is enabled
+- Fixed bundled skill aliases like `/checkup` and `/review` reporting "Unknown command" in `-p` mode or with plugins/MCP loaded when a user or project skill shadows the bundled skill
+- Fixed skill/command argument substitution to prevent argument values from being re-expanded as template markers
+- Fixed Windows paths spelled with the NT `\??\` device prefix bypassing UNC path validation, closing an NTLM credential-leak vector
+- Improved `claude self-hosted-runner` session start time: the session branch is now created without rewriting the working tree, and two server round trips no longer block the agent's launch
+- Improved apps gateway error forwarding: 400/413 errors from Vertex, Foundry, and Claude Platform on AWS upstreams now carry the upstream's own message; fixes a bug with auto-compact on apps gateway
+- Improved `claude plugin validate` to check a bare `.claude/skills` directory, reporting SKILL.md files whose frontmatter fails to parse
+- Improved screen reader mode: the `/effort` selector renders as a numbered list with a typed-number prompt, and hint and dialog text is no longer clipped
+- Improved print mode diagnostics: a `[claude-code:unrecognized_model]` line is written to stderr when a request goes out for a model ID Claude Code doesn't recognize; map it with `modelOverrides` to silence
+- Changed the GitHub app setup tip to no longer appear in repositories whose origin remote is on gitlab.com or bitbucket.org; the enterprise marketplace tip now covers non-GitHub internal git hosts
+- Todo/task-tracking tools (TaskCreate/Get/Update/List, TodoWrite) are no longer available on Opus 4.8, Sonnet 5, Fable 5, Mythos 5, and newer models; set `CLAUDE_CODE_ENABLE_TODO_TOOLS=1` to bring them back
+- Windows: fixed auto mode repeatedly stopping for manual approval on ordinary `cd <dir> && <command> > file` Bash commands (a 2.1.232 regression)
+- Reverted the 2.1.232 Bash permission changes for Cygwin-style symlinks on Windows and for input redirections (`< file`); a narrower version will return in a later release
+
```

</details>

<details>
<summary>self-hosted-environments-configuration-en.md</summary>

```diff
diff --git a/docs-ja/pages/self-hosted-environments-configuration-en.md b/docs-ja/pages/self-hosted-environments-configuration-en.md
index 3ceedc1..735eae8 100644
--- a/docs-ja/pages/self-hosted-environments-configuration-en.md
+++ b/docs-ja/pages/self-hosted-environments-configuration-en.md
@@ -354,5 +354,5 @@ A self-hosted session has no terminal attached, so an unanswered permission prom
 
 <Note>
-  Only enable auto mode on an environment whose session containers run with [default-deny network egress](/docs/en/self-hosted-environments-deploy#default-deny-egress) and the rest of the [hardening section](/docs/en/self-hosted-environments-deploy#harden-your-deployment) in place. Routine tool calls, including `Bash` network requests, run without a human in the loop on both the default pre-approved tool set and in auto mode, so the network boundary is what limits where those calls can reach.
+  Only pin auto mode on an environment whose session containers run with [default-deny network egress](/docs/en/self-hosted-environments-deploy#default-deny-egress) and the rest of the [hardening section](/docs/en/self-hosted-environments-deploy#harden-your-deployment) in place. Routine tool calls, including `Bash` network requests, run without a human in the loop on both the default pre-approved tool set and in auto mode, so the network boundary is what limits where those calls can reach.
 </Note>
 
```

</details>

</details>


<details>
<summary>2026-08-14</summary>

**変更ファイル:**

```
 docs-ja/pages/changelog.md                         | 56 ++++++++++++++++
 docs-ja/pages/cross-session-messaging-en.md        | 21 ++++--
 .../self-hosted-environments-configuration-en.md   | 78 ++++++++++++----------
 .../pages/self-hosted-environments-deploy-en.md    | 11 ++-
 .../pages/self-hosted-environments-reference-en.md | 60 ++++++++---------
 5 files changed, 157 insertions(+), 69 deletions(-)
```

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index a18a9d3..bf6c837 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,60 @@
 # Changelog
 
+## 2.1.232
+
+- Subagent forking is now on by default: a `subagent_type: "fork"` subagent inherits the full conversation and prompt cache, and non-teammate agent spawns in interactive sessions now run in the background by default
+- Type `@` in the prompt to mention another Claude session by name; Claude then uses `SendMessage` to reach that session directly
+- `SendMessage` now delivers to a bare name that exactly matches one live session, instead of asking to confirm with a ref first
+- Interactive sessions on one machine now keep unique names: starting or renaming a session to a name another live session already uses gives it a `name-word-word` variant and tells you
+- Added `/config` rows for "Dialog expiry" and "Messages from your other sessions" (cross-session inbound accept/hold/refuse)
+- Added secret redaction for GitLab token families (`glrt-`, `gloas-`, `glptt-`, `glagent-`, `glimt-`, `glsoat-`, `glcbt-`, `glft-`, `glffct-`) and full redaction of routable `glpat-`/`gldt-` tokens; the `glab` CLI config store gets the same sandbox and credential-path protection as `gh`
+- Added GitLab support to plugin marketplaces: bare `gitlab.com` repo URLs (including nested subgroups) now clone like `github.com` URLs, and clone auth-failure hints name your actual git host
+- Settings: `additionalMarketplaces` and `allowedMarketplaces` are now accepted as friendlier aliases for `extraKnownMarketplaces` and `strictKnownMarketplaces`
+- Enterprise policy: a url-typed `blockedMarketplaces` entry for a bare repo URL keeps blocking that URL when the CLI classifies it as a git clone
+- Gateway: the `desktop:` overlay now accepts every released Desktop setting (was 11 hand-listed keys), validated at boot against Desktop's own schema; unknown or invalid keys fail boot
+- Gateway: empty `managed.policies[].match.groups`/`admin.admin_groups` entries and malformed `email_domain` values (empty, or containing `@`, whitespace, or commas) now fail at boot instead of silently matching no one or granting admin access
+- Fable 5 is offered as an advisor in `/advisor` again for organizations with Fable access, with usage-credits consent set up through `/model fable`
+- Fixed a PowerShell permission bypass where variable-writing parameters could silently overwrite `$PSDefaultParameterValues` and redirect later commands' file access
+- Fixed a Windows permission bypass where Git Bash followed Cygwin-style symlinks that path validation saw as regular files; writes through them now require permission approval
+- Fixed nested git repositories inheriting trust from a parent directory; each repository now requires its own trust confirmation
+- Fixed MCP connections hanging for the full 30-second connect timeout when a server fails to answer or sends a malformed reply to the protocol-version probe
+- Fixed Remote Control sessions hosted by a bridge inside a cloud session inheriting that session's transcript or credentials
+- Fixed Remote Control sessions started from Claude Desktop or an IDE appearing as a new claude.ai session each time the local session was resumed; they now reattach to the existing one
+- Fixed Remote Control sessions appearing unreachable to newly attached clients while idle
+- Fixed Remote Control bridge sessions not restoring conversation history when the session worker restarts
+- Remote Control: resuming a conversation whose session was deleted from claude.ai or the app now starts a replacement instead of failing with a message about your login (regressed in v2.1.227)
```

</details>

<details>
<summary>cross-session-messaging-en.md</summary>

```diff
diff --git a/docs-ja/pages/cross-session-messaging-en.md b/docs-ja/pages/cross-session-messaging-en.md
index 893889f..42ae59c 100644
--- a/docs-ja/pages/cross-session-messaging-en.md
+++ b/docs-ja/pages/cross-session-messaging-en.md
@@ -50,4 +50,12 @@ Explain what we just did to the session working on the payments API
 ```
 
+To name the target yourself, mention the session in your prompt: type `@` followed by the first letters of the session's name and pick the session from the typeahead, the same way you [@-mention a subagent](/docs/en/sub-agents#invoke-subagents-explicitly). Requires Claude Code v2.1.232 or later. Claude Code inserts the mention, such as `@api-worker`, and tells Claude which session it names, so Claude can message that session without listing your sessions first. This prompt names the target with a mention:
+
+```text wrap theme={null}
+Let @api-worker know the schema migration finished
+```
+
+Once you type at least one letter after the `@`, Claude Code suggests your other live sessions on this machine; after a bare `@`, session rows don't appear. A cloud or Remote Control session appears in the suggestions only after Claude has already listed or messaged your sessions beyond this machine. You can also type the mention without the picker. When more than one live session answers to the mentioned name, Claude asks you which one you mean before sending.
+
 For what the message Claude writes looks like when it arrives, including an example of one, see [what a message looks like](#what-a-message-looks-like).
 
@@ -72,12 +80,15 @@ Claude finds a message's target on its own, so you don't need to run anything be
 * **Subagents**: agents running inside the current session. [Agent team](/docs/en/agent-teams) teammates aren't listed; Claude messages them through the team's own roster.
 * **Your other local sessions**: Claude Code sessions running on the same machine, including [background sessions](/docs/en/agent-view). A session appears only when it binds an [inbox socket](#the-sessions-inbox-socket).
-* **Your cloud sessions**: your [Claude Code on the web](/docs/en/claude-code-on-the-web) sessions, shown while this session is connected to [Remote Control](/docs/en/remote-control).
-* **Your Remote Control sessions on other machines**: shown while this session is connected to [Remote Control](/docs/en/remote-control), and labeled `Remote Control`.
+* **Your cloud sessions**: your [Claude Code on the web](/docs/en/claude-code-on-the-web) sessions, shown while this session is connected to [Remote Control](/docs/en/remote-control). Claude Code labels them `cloud` in the listing.
+* **Your Remote Control sessions on other machines**: shown while this session is connected to [Remote Control](/docs/en/remote-control), and labeled `Remote Control`. Claude Code shows `offline` as the status of a session whose Remote Control connection has dropped.
 
 Claude addresses a session beyond this machine by name, the same as a local session. See [Message sessions on other machines](#message-sessions-on-other-machines) for how those messages travel.
 
-A session answers to the name you set with the [`/rename`](/docs/en/commands) command or the [`--name`](/docs/en/cli-reference#cli-flags) flag. When you don't set one, Claude Code names the session itself. An interactive session gets a name derived from its working directory's folder name, such as `myapp-3f`.
+A session answers to the name you set with the [`/rename`](/docs/en/commands) command or the [`--name`](/docs/en/cli-reference#cli-flags) flag. When you don't set one, Claude Code names the session itself. For an interactive session, Claude Code derives the name from the working directory's folder name, such as `my-app-3f` in a `my-app` directory.
+
```

</details>

<details>
<summary>self-hosted-environments-configuration-en.md</summary>

```diff
diff --git a/docs-ja/pages/self-hosted-environments-configuration-en.md b/docs-ja/pages/self-hosted-environments-configuration-en.md
index 5dea269..3ceedc1 100644
--- a/docs-ja/pages/self-hosted-environments-configuration-en.md
+++ b/docs-ja/pages/self-hosted-environments-configuration-en.md
@@ -31,4 +31,5 @@ The runner sets the following in the wrapper's environment:
 | `CLAUDE_CODE_SESSION_ACCESS_TOKEN`  | The session JWT, prefixed `sk-ant-cc-`. Its `act` claim identifies the session creator, with the creator's email and upstream identity-provider subject when the creating surface recorded them. The value is the token at spawn time; refreshes arrive over the child's stdin, so a wrapper sees only the initial value. See [Verify session identity](/docs/en/self-hosted-environments-identity).                                                                                                                                                                                                                              |
 | `CCR_SESSION_ACCOUNT_EMAIL`         | The session creator's email, pre-extracted by the runner from the token's `act.email` claim without signature verification. Suitable for labelling, such as commit trailers. When the email gates credential issuance, verify the token and read the claim from it instead; see [Provision credentials scoped to the session creator](#provision-credentials-scoped-to-the-session-creator). Unset when the token carries no creator email. Treat as personally identifiable information.                                                                                                                                    |
+| `CLAUDE_RUNNER_CLIENT_PLATFORM`     | The client surface that created the session, such as `web_claude_ai`, `desktop_app`, `ios`, `claude_code_cli`, or `scheduled_trigger`. Anthropic records the value once at session creation, so the wrapper and every lifecycle hook see the same value. Use it for adoption analytics and labelling only, not as an authorization signal. Unset when the session has no recorded or recognized surface, so reference it as `${CLAUDE_RUNNER_CLIENT_PLATFORM:-}` under `set -u`. Requires Claude Code v2.1.229 or later.                                                                                                     |
 | `CLAUDE_RUNNER_CLAUDE_BIN`          | Absolute path to the runner's own Claude Code binary. End your wrapper with `exec "$CLAUDE_RUNNER_CLAUDE_BIN" "$@"` to hand off to the pinned binary without hardcoding an install path.                                                                                                                                                                                                                                                                                                                                                                                                                                     |
 | `CLAUDE_CODE_REMOTE_SESSION_ID`     | Session ID in the tagged `cse_...` form. This is the same session the [lifecycle hooks](#lifecycle-hooks) see as `CLAUDE_RUNNER_SESSION_ID` in `session_...` form; the UUID variables match across both, and substituting the `cse_` prefix with `session_` yields the ID shown in the session URL.                                                                                                                                                                                                                                                                                                                          |
@@ -87,13 +88,14 @@ These hooks are distinct from [Claude Code hooks](/docs/en/hooks), which run ins
 Runs once per repository, in place of the runner's built-in clone and fetch. Use the hook to clone from a read-through mirror, seed a working tree from an archive, or apply per-session git auth. The runner sets:
 
-| Variable                           | Description                                                                                                                 |
-| :--------------------------------- | :-------------------------------------------------------------------------------------------------------------------------- |
-| `CLAUDE_RUNNER_REPO_URL`           | Repository URL to clone, after any `--git-host-rewrite` and `--git-ssh-rewrite` have been applied                           |
-| `CLAUDE_RUNNER_REPO_REF`           | Revision to check out: branch, tag, or commit SHA as the session requested it. Empty means the repository's default branch. |
-| `CLAUDE_RUNNER_CHECKOUT_PATH`      | Absolute path where the working tree must be left                                                                           |
-| `CLAUDE_RUNNER_SESSION_ID`         | Session ID in the tagged `session_...` form, for logging and correlation                                                    |
-| `CLAUDE_RUNNER_SESSION_UUID`       | The same session ID in canonical UUID form                                                                                  |
-| `CLAUDE_RUNNER_API_BASE_URL`       | Anthropic API base URL for session-scoped calls                                                                             |
-| `CLAUDE_CODE_SESSION_ACCESS_TOKEN` | The session access token, for session-scoped API calls                                                                      |
+| Variable                           | Description                                                                                                                                                  |
+| :--------------------------------- | :----------------------------------------------------------------------------------------------------------------------------------------------------------- |
+| `CLAUDE_RUNNER_REPO_URL`           | Repository URL to clone, after any `--git-host-rewrite` and `--git-ssh-rewrite` have been applied                                                            |
+| `CLAUDE_RUNNER_REPO_REF`           | Revision to check out: branch, tag, or commit SHA as the session requested it. Empty means the repository's default branch.                                  |
+| `CLAUDE_RUNNER_CHECKOUT_PATH`      | Absolute path where the working tree must be left                                                                                                            |
+| `CLAUDE_RUNNER_SESSION_ID`         | Session ID in the tagged `session_...` form, for logging and correlation                                                                                     |
+| `CLAUDE_RUNNER_SESSION_UUID`       | The same session ID in canonical UUID form                                                                                                                   |
+| `CLAUDE_RUNNER_API_BASE_URL`       | Anthropic API base URL for session-scoped calls                                                                                                              |
```

</details>

<details>
<summary>self-hosted-environments-deploy-en.md</summary>

```diff
diff --git a/docs-ja/pages/self-hosted-environments-deploy-en.md b/docs-ja/pages/self-hosted-environments-deploy-en.md
index dc84067..505f1d2 100644
--- a/docs-ja/pages/self-hosted-environments-deploy-en.md
+++ b/docs-ja/pages/self-hosted-environments-deploy-en.md
@@ -112,4 +112,13 @@ If you must configure push credentials at the image level, for example for a rea
 * `GIT_SSH_COMMAND` pointing at a narrowly-scoped key
 
+Whichever mechanism you configure must work without a prompt, because the runner's built-in clone and fetch disable the prompts that git, SSH, and Git Credential Manager would otherwise show:
+
+* The runner sets `GIT_TERMINAL_PROMPT=0`, so git doesn't ask for a username or password.
+* The runner runs SSH with `BatchMode=yes`, appended to your `GIT_SSH_COMMAND` if you set one, so SSH doesn't ask for a passphrase or host confirmation.
+* The runner sets `GCM_INTERACTIVE=never`, so Git Credential Manager doesn't open a sign-in dialog.
+* The runner clears `core.askPass`, so if you use an askpass helper, set it through the `GIT_ASKPASS` environment variable instead.
+
+If your git host rejects the credential, or you didn't configure one, the runner retries a few times and then fails repository preparation. The runner doesn't pass these settings into the session's environment.
+
 If checkout directories are owned by a different uid than the runner process, git refuses to operate on them; add `safe.directory`:
 
@@ -282,5 +291,5 @@ If a runner dies mid-session, the server requeues the session and another runner
 Use the same `--base-dir` and `--capacity` on every runner in an environment, and don't use a per-host value such as an instance ID or hostname.
 
-The base directory defaults to `/workspace`. The runner needs write access to it. At startup, before registering, the runner creates the directory and confirms it can write to it, and exits with `cannot create or write to base directory` when it can't. A runner started as root creates the default `/workspace` itself. For a non-root runner, create the directory and give the runner's user ownership before starting the runner, or point `--base-dir` at a directory that user already owns.
+The base directory defaults to `/workspace`, with the exception the [`--base-dir` reference row](/docs/en/self-hosted-environments-reference#runner-cli-flags) records. The runner needs write access to it. At startup, before registering, the runner creates the directory and confirms it can write to it, and exits with `cannot create or write to base directory` when it can't. A runner started as root creates the default `/workspace` itself. For a non-root runner, create the directory and give the runner's user ownership before starting the runner, or point `--base-dir` at a directory that user already owns.
 
 ## Reuse a pre-warmed checkout
```

</details>

<details>
<summary>self-hosted-environments-reference-en.md</summary>

```diff
diff --git a/docs-ja/pages/self-hosted-environments-reference-en.md b/docs-ja/pages/self-hosted-environments-reference-en.md
index c033b5f..ecb3e25 100644
--- a/docs-ja/pages/self-hosted-environments-reference-en.md
+++ b/docs-ja/pages/self-hosted-environments-reference-en.md
@@ -19,33 +19,33 @@ Metric series and a few API fields still use `pool` for what these pages call an
 Most flags have a corresponding environment variable. When both are set, the flag takes precedence. Duration flags take minutes or seconds on the CLI, but the paired environment variable is always in milliseconds, indicated by the `_MS` suffix, and the Default column shows the flag's unit: `--exit-if-unused-min 10` is equivalent to `SELF_HOSTED_RUNNER_IDLE_SHUTDOWN_MS=600000`, and a Helm value like `SELF_HOSTED_RUNNER_STARTUP_TIMEOUT_MS: "15"` means 15 milliseconds, not the 15-minute default.
 
-| Flag                                  | Env var                                           | Default                     | Description                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
-| :------------------------------------ | :------------------------------------------------ | :-------------------------- | :-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
-| `--api-url <url>`                     | none                                              | `https://api.anthropic.com` | API base URL. Override only for testing.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
-| `--base-dir <path>`                   | `SELF_HOSTED_RUNNER_BASE_DIR`                     | `/workspace`                | Directory for repository checkouts and per-session working directories. The runner needs write access to this path or its parent. The runner creates the directory at startup and exits with `cannot create or write to base directory` when it can't create or write to it. Before v2.1.225, the runner created the directory when the first session started, so an unusable path failed sessions rather than startup. Use the same value on every runner in an environment. See [Keep the base directory and capacity identical across runners](/docs/en/self-hosted-environments-deploy#keep-the-base-directory-and-capacity-identical-across-runners).                                                                                                           |
-| `--capacity <n>`                      | none                                              | `1`                         | Maximum concurrent sessions this runner handles. All sessions belong to the same locked account. Use the same value on every runner in an environment; see [Keep the base directory and capacity identical across runners](/docs/en/self-hosted-environments-deploy#keep-the-base-directory-and-capacity-identical-across-runners).                                                                                                                                                                                                                                                                                                                                                                                                                                  |
-| `--configure-git`                     | `SELF_HOSTED_RUNNER_CONFIGURE_GIT=1`              | off                         | Write global git identity and enable Anthropic commit signing at startup. See [Configure git](/docs/en/self-hosted-environments-deploy#configure-git).                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
-| `--confine-repo-settings <mode>`      | `SELF_HOSTED_RUNNER_CONFINE_REPO_SETTINGS`        | `warn`                      | Sets the mode of the guard that flags a session when a repository's committed settings try to grant write or read access outside that session's own workspace, set environment variables, or override the operator's sandbox or hooks posture, such as `sandbox.enabled: false` or `disableAllHooks`. The default `warn` logs the violation and still starts the session, `enforce` refuses the session, and `off` disables the scan. See [Harden your deployment](/docs/en/self-hosted-environments-deploy#harden-your-deployment).                                                                                                                                                                                                                                 |
-| `--debug-token-dir <path>`            | `SELF_HOSTED_RUNNER_DEBUG_TOKEN_DIR`              | unset                       | Write live tokens to disk for inspection. Debug only; don't use in production.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
-| `--drain-grace-sec <n>`               | `SELF_HOSTED_RUNNER_DRAIN_GRACE_MS`               | `0`                         | Controls when the runner exits after its active sessions finish: `0` exits immediately without polling for more, and a positive value keeps the runner alive and re-polling the locked account's queue for that many seconds first, at the cost of the per-session container isolation described in the [hardening section](/docs/en/self-hosted-environments-deploy#harden-your-deployment)                                                                                                                                                                                                                                                                                                                                                                         |
-| `--drain-wait-sec <n>`                | `SELF_HOSTED_RUNNER_DRAIN_WAIT_MS`                | `0`                         | On `SIGTERM`, wait up to N seconds for each session's in-flight turn and background tasks to finish before terminating the child. During this wait, the runner counts a background task that has just finished as still running until the follow-up turn that reads its result starts, for at most the [`SELF_HOSTED_RUNNER_BG_RESULT_GRACE_MS`](#environment-variable-only-settings) window.                                                                                                                                                                                                                                                                                                                                                                   |
-| `--environment-secret-file <path>`    | `SELF_HOSTED_RUNNER_ENVIRONMENT_SECRET`           | required                    | Path to a file containing the environment secret, or, for runners spawned by the [orchestrator](/docs/en/self-hosted-environments-configuration#on-demand-runners), the single-use work-order JWT. `SELF_HOSTED_RUNNER_ENVIRONMENT_SECRET` carries the secret value directly, not a file path. The older `--pool-secret-file` flag and `SELF_HOSTED_RUNNER_POOL_SECRET` variable still work and print a deprecation notice to stderr; preview-program runner builds older than 2.1.216 only recognize those older names.                                                                                                                                                                                                                                             |
-| `--exec-path <path>`                  | `SELF_HOSTED_RUNNER_EXEC_PATH`                    | own binary                  | Binary or wrapper script to spawn for each session. See [Wrapper scripts](/docs/en/self-hosted-environments-configuration#wrapper-scripts).                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
-| `--exit-if-unused-min <n>`            | `SELF_HOSTED_RUNNER_IDLE_SHUTDOWN_MS`             | `0`                         | Exit after N minutes of polling with no work ever assigned, for autoscaler scale-down. `0` disables.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
-| `--git-host-rewrite <from>=<to>`      | none                                              | unset                       | Rewrite `https://<from>/...` source URLs to `https://<to>/...` before cloning, for split-horizon DNS. Repeatable; flag only.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
-| `--git-ssh-rewrite <host>`            | none                                              | unset                       | Rewrite `https://<host>/...` source URLs to `git@<host>:...` before cloning, for SSH-only git hosts. Repeatable; flag only.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
-| `--health-port <port>`                | `SELF_HOSTED_RUNNER_HEALTH_PORT`                  | `8080`                      | Port for the `/healthz` and `/metrics` listener. Set `0` to disable.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
-| `--hooks-dir <path>`                  | `SELF_HOSTED_RUNNER_HOOKS_DIR`                    | unset                       | Directory of lifecycle hook scripts. See [Lifecycle hooks](/docs/en/self-hosted-environments-configuration#lifecycle-hooks).                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
-| `--kill-session-after-min <n>`        | `SELF_HOSTED_RUNNER_MAX_LIFETIME_MS`              | `0`                         | Terminate a session child once it has lived N minutes wall-clock, as a safety limit for stuck sessions. A kill that falls mid-turn is deferred until the turn finishes, bounded by a grace window. `0` disables.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
-| `--lock-to-account <id>`              | `SELF_HOSTED_RUNNER_LOCK_TO_ACCOUNT`              | unset                       | Pre-lock the runner to a specific account at startup instead of locking on first session. Accepts an email address or `user_...` ID in the environment's organization.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
-| `--log-file <path>`                   | `SELF_HOSTED_RUNNER_LOG_FILE`                     | unset                       | Mirror runner logs to a file in addition to stdout and stderr, created with `0600` permissions. Required for `self-hosted-runner doctor` to tail logs locally.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
-| `--log-level <level>`                 | none                                              | `info`                      | `info` or `debug`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
-| `--post-session-hook-timeout-sec <n>` | `SELF_HOSTED_RUNNER_POST_SESSION_HOOK_TIMEOUT_MS` | `60`                        | Budget for the [`post-session` hook](/docs/en/self-hosted-environments-configuration#post-session) on every session end, including runner shutdown                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
-| `--push-outcome-on-release`           | `SELF_HOSTED_RUNNER_PUSH_OUTCOME_ON_RELEASE`      | off                         | On a runner-initiated session end such as a drain or idle release, push tracked outcome branches to `origin` before deleting the workspace, so in-flight commits survive a restart. Best-effort; adds 30 seconds to the shutdown budget, and requires git 2.29 or newer to resume from the pushed branch. Restrict push access to `claude/*` refs before enabling; see [Resumed sessions lose unpushed work](/docs/en/self-hosted-environments-deploy#additional-limitations). Repositories checked out via a `checkout` lifecycle hook aren't pushed; snapshot those from the [`post-session` hook](/docs/en/self-hosted-environments-configuration#post-session) instead.                                                                                               |
```

</details>

</details>


<details>
<summary>2026-08-13</summary>

**変更ファイル:**

```
 docs-ja/pages/changelog.md                         | 35 ++++++++++
 docs-ja/pages/cross-session-messaging-en.md        | 24 +++++--
 docs-ja/pages/hooks-guide-ja.md                    | 66 +++++++++----------
 docs-ja/pages/hooks-ja.md                          | 66 +++++++++----------
 docs-ja/pages/plugins-reference-ja.md              | 66 +++++++++----------
 .../self-hosted-environments-configuration-en.md   | 13 +++-
 .../pages/self-hosted-environments-deploy-en.md    | 11 ++--
 docs-ja/pages/self-hosted-environments-en.md       |  6 +-
 .../pages/self-hosted-environments-reference-en.md | 77 +++++++++++-----------
 9 files changed, 211 insertions(+), 153 deletions(-)
```

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index 0b73c3b..a18a9d3 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,39 @@
 # Changelog
 
+## 2.1.229
+
+- Documented `claude remote-control --continue` for resuming the most recent Remote Control session
+- Added server-supplied Claude Code hook support for self-hosted runner sessions, matching managed-environment behavior
+- Added SSE keepalive pings to gateway streaming responses during long thinking pauses, preventing idle-timeout disconnects on Vertex and Bedrock upstreams
+- Added plugin marketplace `command` sources: a local command (e.g. an IDE) prints the plugin directory, which is re-resolved each session and applied without a restart; `mode: "link"` uses it in place
+- `ListAgents` now marks disconnected Remote Control sessions as `offline` and labels your cloud sessions as `cloud`
+- Fixed long responses partly disappearing while streaming and being printed twice in the terminal
+- Fixed a crash to the error screen (including on `--resume` of the affected session) when a tool call had a non-string `glob`, `file_path`, or `command` value
+- Fixed a RangeError crash when a progress bar or markdown table rendered in a very narrow terminal window (could also crash `claude --continue`/`--resume` at startup)
+- Fixed a crash on Windows when a tool call or message referenced a file by an extended-length (`\\?\`) or UNC path
+- Fixed auto mode failing on every tool call for users who disable the attribution header via `CLAUDE_CODE_ATTRIBUTION_HEADER` (direct Anthropic API connections)
+- Fixed `/model` rejecting Sonnet/Opus 1M for claude.ai subscribers using a custom `ANTHROPIC_BASE_URL` gateway
+- Fixed MCP OAuth with strict authorization servers by using `127.0.0.1` instead of `localhost` in the redirect URI
+- Fixed Remote Control clients showing a stuck working spinner after a slash command typed in the laptop terminal
+- Fixed the Claude Code Review workflow generated by `/install-github-app` completing without posting its review on the pull request
+- Fixed multi-second UI stalls after editing a file with thousands of IDE diagnostics while the IDE extension is connected
+- Fixed one-shot `claude plugin` commands leaving a stray liveness file that could prevent cleanup of outdated plugin versions
+- Fixed dynamic workflows inside CPU-limited containers using the host machine's core count instead of the container's CPU limit
+- Fixed a file-watcher handle leak after atomic file replacements, and an uncaught error on Windows when the scheduled-tasks watcher failed on a network or virtual filesystem
+- Fixed SDK and `--input-format stream-json` sessions getting a 400 API error when a whitespace-only message was submitted
+- Fixed conversations whose messages alone exceed the API's 32 MB request limit retrying compaction when no images or documents can be stripped; they now fail once with a clear message
+- Fixed OpenTelemetry export from Claude Desktop sessions being rejected by the Desktop-managed gateway when that gateway is also the telemetry endpoint
```

</details>

<details>
<summary>cross-session-messaging-en.md</summary>

```diff
diff --git a/docs-ja/pages/cross-session-messaging-en.md b/docs-ja/pages/cross-session-messaging-en.md
index 4eeb030..893889f 100644
--- a/docs-ja/pages/cross-session-messaging-en.md
+++ b/docs-ja/pages/cross-session-messaging-en.md
@@ -72,5 +72,5 @@ Claude finds a message's target on its own, so you don't need to run anything be
 * **Subagents**: agents running inside the current session. [Agent team](/docs/en/agent-teams) teammates aren't listed; Claude messages them through the team's own roster.
 * **Your other local sessions**: Claude Code sessions running on the same machine, including [background sessions](/docs/en/agent-view). A session appears only when it binds an [inbox socket](#the-sessions-inbox-socket).
-* **Your cloud sessions**: your [Claude Code on the web](/docs/en/claude-code-on-the-web) sessions. These appear when this session has cloud access: a claude.ai login on the first-party Anthropic API and an organization policy that allows cloud sessions.
+* **Your cloud sessions**: your [Claude Code on the web](/docs/en/claude-code-on-the-web) sessions, shown while this session is connected to [Remote Control](/docs/en/remote-control).
 * **Your Remote Control sessions on other machines**: shown while this session is connected to [Remote Control](/docs/en/remote-control), and labeled `Remote Control`.
 
@@ -95,5 +95,7 @@ Starting a conversation with a session on another of your machines requires Clau
 Same-machine delivery works wherever the feature is enabled. Each session registers itself in files on disk and binds its inbox socket there. When Claude lists or messages your local sessions, Claude Code reads those files to find them, so two sessions can reach each other only when they can see the same files. A container has its own filesystem, so a session inside it and a session on the host can't reach each other. Two sessions inside the same container can still message each other, including on a [self-hosted runner](/docs/en/self-hosted-environments).
 
-A reply needs a [reply address](#what-a-message-looks-like), and almost every message carries one. A message to a session beyond this machine, sent while the sending session isn't connected to Remote Control, still goes through as a direct request to Anthropic servers, but it arrives without a reply address, so the receiver can't answer it. Claude is told as much when it sends.
+While this session is connected to Remote Control, when you message a session on another of your machines, Claude Code shows the message in that session's conversation under this session's Remote Control name. The Claude on that machine can reply to that name. For example, when this session is connected to Remote Control as `laptop-graceful-unicorn` and you message your desktop, you see the message in the desktop session under `laptop-graceful-unicorn`.
+
+If this session isn't connected to Remote Control when Claude sends to a session beyond this machine, the message still goes through, but without a [reply address](#what-a-message-looks-like), so the receiving Claude can't answer it. Claude is told as much when it sends.
 
 To require your approval before any message goes beyond this machine, set [`isolatePeerMachines`](#require-approval-for-cross-machine-messages).
@@ -112,5 +114,5 @@ When session A messages session B, Claude Code tells B's Claude that the message
 </h3>
 
-When the message arrives, it appears in the conversation with its sender, queued while Claude is mid-turn or starting a new turn right away when the session is idle. Once Claude has read it, Claude Code collapses it to a one-line `Message from` row, which `Ctrl+O` expands.
+When the message arrives, it appears in the conversation under the sender's session name and stays there. Claude Code queues it while Claude is mid-turn, or starts a new turn with it right away when the session is idle.
 
 A message is a piece of text one Claude writes to another. Claude receives it with the sender's name and a reply address, except for a [one-way cross-machine message](#message-sessions-on-other-machines), which carries no reply address. You see the name and the text, and the receiving session gets only that text, never the sender's conversation history or files.
@@ -175,9 +177,17 @@ You can find the path in two places:
 
 * `/status` shows it in the `Peer address` row. The path is prefixed with `uds:`.
```

</details>

<details>
<summary>hooks-guide-ja.md</summary>

```diff
diff --git a/docs-ja/pages/hooks-guide-ja.md b/docs-ja/pages/hooks-guide-ja.md
index 630d881..ca3cd7b 100644
--- a/docs-ja/pages/hooks-guide-ja.md
+++ b/docs-ja/pages/hooks-guide-ja.md
@@ -459,37 +459,37 @@ Hook が承認すると、Claude Code は Plan Mode を終了し、Plan Mode に
 Hook イベントは Claude Code のライフサイクルの特定のポイントで発火します。イベントが発火すると、すべてのマッチングする hooks が並列で実行され、同一の hook コマンドは自動的に重複排除されます。以下の表は各イベントとそれがトリガーされるときを示しています：
 
-| Event                 | When it fires                                                                                                                                          |
-| :-------------------- | :----------------------------------------------------------------------------------------------------------------------------------------------------- |
-| `SessionStart`        | When a session begins or resumes                                                                                                                       |
-| `Setup`               | When you start Claude Code with `--init-only`, or with `--init` or `--maintenance` in `-p` mode. For one-time preparation in CI or scripts             |
-| `UserPromptSubmit`    | When you submit a prompt, before Claude processes it                                                                                                   |
-| `UserPromptExpansion` | When a user-typed command expands into a prompt, before it reaches Claude. Can block the expansion                                                     |
-| `PreToolUse`          | Before a tool call executes. Can block it                                                                                                              |
-| `PermissionRequest`   | When a tool call needs a permission decision                                                                                                           |
-| `PermissionDenied`    | When a tool call is denied by the auto mode classifier. Use JSON `hookSpecificOutput.retry: true` to tell the model it may retry the denied tool call  |
-| `PostToolUse`         | After a tool call succeeds                                                                                                                             |
-| `PostToolUseFailure`  | After a tool call fails                                                                                                                                |
-| `PostToolBatch`       | After a full batch of parallel tool calls resolves, before the next model call                                                                         |
-| `Notification`        | When Claude Code sends a notification                                                                                                                  |
-| `MessageDisplay`      | While assistant message text is displayed                                                                                                              |
-| `SubagentStart`       | When a subagent is spawned                                                                                                                             |
-| `SubagentStop`        | When a subagent finishes                                                                                                                               |
-| `TaskCreated`         | When a task is being created via `TaskCreate`                                                                                                          |
-| `TaskCompleted`       | When a task is being marked as completed                                                                                                               |
-| `Stop`                | When Claude finishes responding                                                                                                                        |
-| `StopFailure`         | When the turn ends due to an API error                                                                                                                 |
-| `TeammateIdle`        | When an [agent team](/docs/en/agent-teams) teammate is about to go idle                                                                                     |
-| `InstructionsLoaded`  | When a CLAUDE.md or `.claude/rules/*.md` file is loaded into context. Fires at session start and when files are lazily loaded during a session         |
-| `ConfigChange`        | When a configuration file changes during a session                                                                                                     |
```

</details>

<details>
<summary>hooks-ja.md</summary>

```diff
diff --git a/docs-ja/pages/hooks-ja.md b/docs-ja/pages/hooks-ja.md
index 05ad6a3..8f46884 100644
--- a/docs-ja/pages/hooks-ja.md
+++ b/docs-ja/pages/hooks-ja.md
@@ -33,37 +33,37 @@
 以下の表は、各イベントがいつ発火するかをまとめています。[フック イベント](#hook-events)セクションでは、各イベントの完全な入力スキーマと決定制御オプションについて説明しています。
 
-| Event                 | When it fires                                                                                                                                          |
-| :-------------------- | :----------------------------------------------------------------------------------------------------------------------------------------------------- |
-| `SessionStart`        | When a session begins or resumes                                                                                                                       |
-| `Setup`               | When you start Claude Code with `--init-only`, or with `--init` or `--maintenance` in `-p` mode. For one-time preparation in CI or scripts             |
-| `UserPromptSubmit`    | When you submit a prompt, before Claude processes it                                                                                                   |
-| `UserPromptExpansion` | When a user-typed command expands into a prompt, before it reaches Claude. Can block the expansion                                                     |
-| `PreToolUse`          | Before a tool call executes. Can block it                                                                                                              |
-| `PermissionRequest`   | When a tool call needs a permission decision                                                                                                           |
-| `PermissionDenied`    | When a tool call is denied by the auto mode classifier. Use JSON `hookSpecificOutput.retry: true` to tell the model it may retry the denied tool call  |
-| `PostToolUse`         | After a tool call succeeds                                                                                                                             |
-| `PostToolUseFailure`  | After a tool call fails                                                                                                                                |
-| `PostToolBatch`       | After a full batch of parallel tool calls resolves, before the next model call                                                                         |
-| `Notification`        | When Claude Code sends a notification                                                                                                                  |
-| `MessageDisplay`      | While assistant message text is displayed                                                                                                              |
-| `SubagentStart`       | When a subagent is spawned                                                                                                                             |
-| `SubagentStop`        | When a subagent finishes                                                                                                                               |
-| `TaskCreated`         | When a task is being created via `TaskCreate`                                                                                                          |
-| `TaskCompleted`       | When a task is being marked as completed                                                                                                               |
-| `Stop`                | When Claude finishes responding                                                                                                                        |
-| `StopFailure`         | When the turn ends due to an API error                                                                                                                 |
-| `TeammateIdle`        | When an [agent team](/docs/en/agent-teams) teammate is about to go idle                                                                                     |
-| `InstructionsLoaded`  | When a CLAUDE.md or `.claude/rules/*.md` file is loaded into context. Fires at session start and when files are lazily loaded during a session         |
-| `ConfigChange`        | When a configuration file changes during a session                                                                                                     |
```

</details>

<details>
<summary>plugins-reference-ja.md</summary>

```diff
diff --git a/docs-ja/pages/plugins-reference-ja.md b/docs-ja/pages/plugins-reference-ja.md
index e7cc998..9a064ae 100644
--- a/docs-ja/pages/plugins-reference-ja.md
+++ b/docs-ja/pages/plugins-reference-ja.md
@@ -119,37 +119,37 @@ disallowedTools: Write, Edit
 プラグイン hooks は[ユーザー定義 hooks](/docs/ja/hooks)と同じライフサイクルイベントに応答します:
 
-| Event                 | When it fires                                                                                                                                          |
-| :-------------------- | :----------------------------------------------------------------------------------------------------------------------------------------------------- |
-| `SessionStart`        | When a session begins or resumes                                                                                                                       |
-| `Setup`               | When you start Claude Code with `--init-only`, or with `--init` or `--maintenance` in `-p` mode. For one-time preparation in CI or scripts             |
-| `UserPromptSubmit`    | When you submit a prompt, before Claude processes it                                                                                                   |
-| `UserPromptExpansion` | When a user-typed command expands into a prompt, before it reaches Claude. Can block the expansion                                                     |
-| `PreToolUse`          | Before a tool call executes. Can block it                                                                                                              |
-| `PermissionRequest`   | When a tool call needs a permission decision                                                                                                           |
-| `PermissionDenied`    | When a tool call is denied by the auto mode classifier. Use JSON `hookSpecificOutput.retry: true` to tell the model it may retry the denied tool call  |
-| `PostToolUse`         | After a tool call succeeds                                                                                                                             |
-| `PostToolUseFailure`  | After a tool call fails                                                                                                                                |
-| `PostToolBatch`       | After a full batch of parallel tool calls resolves, before the next model call                                                                         |
-| `Notification`        | When Claude Code sends a notification                                                                                                                  |
-| `MessageDisplay`      | While assistant message text is displayed                                                                                                              |
-| `SubagentStart`       | When a subagent is spawned                                                                                                                             |
-| `SubagentStop`        | When a subagent finishes                                                                                                                               |
-| `TaskCreated`         | When a task is being created via `TaskCreate`                                                                                                          |
-| `TaskCompleted`       | When a task is being marked as completed                                                                                                               |
-| `Stop`                | When Claude finishes responding                                                                                                                        |
-| `StopFailure`         | When the turn ends due to an API error                                                                                                                 |
-| `TeammateIdle`        | When an [agent team](/docs/en/agent-teams) teammate is about to go idle                                                                                     |
-| `InstructionsLoaded`  | When a CLAUDE.md or `.claude/rules/*.md` file is loaded into context. Fires at session start and when files are lazily loaded during a session         |
-| `ConfigChange`        | When a configuration file changes during a session                                                                                                     |
```

</details>

<details>
<summary>self-hosted-environments-configuration-en.md</summary>

```diff
diff --git a/docs-ja/pages/self-hosted-environments-configuration-en.md b/docs-ja/pages/self-hosted-environments-configuration-en.md
index 0a13a4c..5dea269 100644
--- a/docs-ja/pages/self-hosted-environments-configuration-en.md
+++ b/docs-ja/pages/self-hosted-environments-configuration-en.md
@@ -101,5 +101,12 @@ The script must leave a working tree at `CLAUDE_RUNNER_CHECKOUT_PATH` checked ou
 The runner doesn't pass a git credential to the hook. Instead, mint a per-session clone credential from the session's identity: verify `CLAUDE_CODE_SESSION_ACCESS_TOKEN` with a standard JWT library against the JWKS endpoint under `CLAUDE_RUNNER_API_BASE_URL`, as described in [Verify the token from your service](/docs/en/self-hosted-environments-identity#verify-the-token-from-your-service), then have your credential service issue a short-lived clone credential for the identity in the token's `act` claim. `CLAUDE_RUNNER_CLAUDE_BIN` isn't set in the checkout-hook environment, so the `decode-token` subcommand isn't available here. Falling back to whatever git authentication the host already has, such as an SSH agent, credential helper, or `.netrc`, is also an option.
 
-A non-zero exit fails the session, and the tail of the script's stderr is surfaced to the user. The runner removes the checkout path after the session ends.
+When the hook exits non-zero, or exits 0 without leaving a usable checkout behind, what the runner does depends on the repository:
+
+* **A repository the session pushes results to**: the runner fails the session, and on a non-zero exit surfaces the tail of the script's stderr to the user.
+* **A repository the session only reads from**, such as a repository added to a running session: the runner logs a `[runner:warn]` line with the failure detail, posts a `Skipped` step to the session, removes whatever the hook left at the checkout path, and continues with the remaining repositories. When the runner can't remove the path immediately, it retries the removal at session end. If skipping leaves the session with no repository at all, the runner fails the session anyway.
+
+Before v2.1.228, the runner failed the session on a hook failure for any repository, so a read-only repository the hook couldn't serve failed the session again on every fresh runner the session resumed on.
+
+The runner removes the checkout path after the session ends.
 
 ### post-session
@@ -177,5 +184,5 @@ The orchestrator keeps no state between polls, so you can run two or more replic
 ### The spawn-runner hook
 
-The orchestrator runs `${hooks-dir}/spawn-runner` once per spawn request. The hook must submit work asynchronously and return within `--hook-timeout`, 60 seconds by default. It must not wait for the runner to boot. The hook receives:
+The orchestrator runs `${hooks-dir}/spawn-runner` once per spawn request. The hook must submit work asynchronously, without waiting for the runner to boot, and return within `--hook-timeout`, 60 seconds by default. The hook receives:
 
 | Variable                              | Description                                                                                                                                                                                                                                                |
@@ -220,5 +227,5 @@ RUN claude mcp add --scope user --transport http internal http://mcp-gateway.svc
 ```
 
-The runner snapshots the host's config once at startup. The snapshot captures the `mcpServers` key from the host's `.claude.json`, which lives next to rather than inside `~/.claude/`, and the runner seeds only that key into each session's isolated config; account state and project history are dropped. To confirm the servers reached sessions, start a session on the environment and ask Claude to list its MCP tools; the runner also logs a startup warning for any captured entry whose `type` it doesn't recognize and drops the entry, so the drop is visible instead of the server silently failing to load. When `SELF_HOSTED_RUNNER_HOST_CONFIG_DIR` is set, the runner reads `.claude.json` from that directory instead, so pointing the variable at an empty directory disables MCP seeding too.
+The runner snapshots the host's config once at startup. The snapshot captures the `mcpServers` key from the host's `.claude.json`, which lives next to rather than inside `~/.claude/`, and the runner seeds only that key into each session's isolated config; account state and project history are dropped. To confirm the servers reached sessions, start a session on the environment and ask Claude to list its MCP tools; the runner also logs a startup warning for any captured entry whose `type` it doesn't recognize and drops the entry, so you can see why that server is missing from sessions. When `SELF_HOSTED_RUNNER_HOST_CONFIG_DIR` is set, the runner reads `.claude.json` from that directory instead, so pointing the variable at an empty directory disables MCP seeding too.
```

</details>

*...以降省略*

</details>


<details>
<summary>2026-08-12</summary>

**変更ファイル:**

```
 docs-ja/pages/changelog.md                          | 21 +++++++++++++++++++++
 docs-ja/pages/cross-session-messaging-en.md         | 13 ++++++++++---
 docs-ja/pages/hooks-guide-ja.md                     |  4 ++--
 docs-ja/pages/hooks-ja.md                           |  4 ++--
 docs-ja/pages/plugins-reference-ja.md               |  4 ++--
 docs-ja/pages/self-hosted-environments-deploy-en.md | 11 +++++++----
 docs-ja/pages/self-hosted-environments-en.md        |  2 +-
 .../pages/self-hosted-environments-quickstart-en.md |  6 ++----
 .../pages/self-hosted-environments-reference-en.md  |  2 +-
 .../pages/self-hosted-environments-testing-en.md    |  6 ++++++
 10 files changed, 54 insertions(+), 19 deletions(-)
```

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index 0f47adb..0b73c3b 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,25 @@
 # Changelog
 
+## 2.1.228
+
+- Fixed interactive sessions that could stop redrawing entirely, while the process kept running, after a rare internal layout error
+- Fixed `git` / Git Bash not being found on Windows when Claude Code is launched from a parent folder of the git installation
+- Fixed `/tui` reverting the session to an earlier model when `/model` had been changed since the last response
+- Fixed cross-session messaging sometimes starting without an inbox in the first session after install or upgrade
+- Fixed Remote Control `/resume` while connected leaking the resumed conversation's title or history into the connected session
+- Fixed `claude self-hosted-runner` sessions failing on every fresh runner when the `checkout` hook fails for a repository the session doesn't push to; that repository is now skipped with a warning
+- Fixed self-hosted runners ending sessions in the gap between a background task finishing and the follow-up turn starting
+- Fixed session cleanup deleting contents inside a project's memory folder
+- Fixed background plugin-cache cleanup deleting a plugin's cache when its only version is a symlinked development checkout
+- Fixed a settings-merge issue where a marketplace entry redefined in a higher-precedence settings tier could inherit another tier's custom headers; marketplace entries now merge as whole entries
+- Fixed the deferred-tools reminder occasionally being sent to the model twice after a skill invocation
+- Hardened skills synced from claude.ai: they no longer shadow local commands or MCP prompts, their descriptions are sanitized and labeled, and on your machine their bodies don't run `!` commands or expand `@` files
+- Improved cross-session messages: the sender and body now display inline instead of a collapsed line, and messages to Remote Control sessions on other machines show your Remote Control session name as the sender
+- Improved Vertex AI credential handling: expired or missing Google Cloud credentials now fail within seconds instead of retrying for minutes
+- Improved compaction progress: the retry countdown and stall hint now appear during compaction instead of only a progress bar
+- Updated terminal title busy-spinner glyphs to reduce tab-bar jitter on some terminals
+- Changed the Write tool so newer models can overwrite an existing file they haven't read this session, matching the Edit tool's rules; older models still require the read first
+- Removed the outdated note about auto mode sessions costing slightly more from the first-use notice for Pro, Max, and Team plans
+
 ## 2.1.227
 
```

</details>

<details>
<summary>cross-session-messaging-en.md</summary>

```diff
diff --git a/docs-ja/pages/cross-session-messaging-en.md b/docs-ja/pages/cross-session-messaging-en.md
index 71d4945..4eeb030 100644
--- a/docs-ja/pages/cross-session-messaging-en.md
+++ b/docs-ja/pages/cross-session-messaging-en.md
@@ -141,5 +141,5 @@ When the default holds a message, Claude Code opens an approval dialog in the re
 * **Approve** delivers that one message to Claude.
 * **Deny**, or dismissing the dialog, drops it.
-* Left unanswered past the [`dialogExpiry`](/docs/en/settings#available-settings) deadline, the dialog closes and Claude Code drops the message. The deadline defaults to five minutes.
+* When the dialog stays unanswered past the [`dialogExpiry`](/docs/en/settings#available-settings) deadline, Claude Code closes it and drops the message. The deadline defaults to five minutes. While no terminal is attached to a [background session](/docs/en/agent-view), Claude Code leaves the dialog open past the deadline. After you attach, Claude Code closes the dialog and drops the message only if it stays unanswered for a full deadline period.
 * If this session's permission-mode class changes while messages are held, Claude Code re-applies the inbound rules, delivers the messages they now accept, and shows a notice.
 * If a change makes `refuse` apply while messages are held, Claude Code drops every held message and reports a denial to each sender it can reach.
@@ -153,5 +153,12 @@ Claude Code holds at most 100 messages, separately from the delivery queue, and
 Claude Code binds an inbox socket for a [`claude -p`](/docs/en/headless) session like an interactive one, so a long-running `-p` worker can receive messages and appears in the listing. When you start a session in [bare mode](/docs/en/headless#start-faster-with-bare-mode), Claude Code doesn't bind the socket, so that session can't receive messages and doesn't appear in the agent list.
 
-A `-p` session can't show the approval dialog. When the [inbound default](#control-inbound-messages) holds a message there, Claude Code delivers it if a later mode or settings change allows it, and otherwise drops it when the [`dialogExpiry`](/docs/en/settings#available-settings) deadline passes and reports the expiry to the sender. Before v2.1.225, a held message stayed held in a `-p` session, with no sender notice and no expiry.
+A `-p` session can't show the approval dialog. When the [inbound default](#control-inbound-messages) holds a message there, Claude Code keeps it for the same [`dialogExpiry`](/docs/en/settings#available-settings) deadline the dialog uses, five minutes by default:
+
+* **Before the deadline**: if a mode or settings change allows the message, Claude Code delivers it.
+* **Past the deadline**: Claude Code drops the message and reports it as expired to a sender it can reach.
+
+Set `dialogExpiry` to `"never"` to keep default-held messages until the session ends. A message held by an explicit `hold` setting doesn't expire; Claude Code delivers it only when an `accept` later applies.
+
+When the session ends with messages still held, Claude Code reports them as expired to each sender it can reach. Before v2.1.225, no deadline applied in a `-p` session: a held message stayed held unless a permission-mode change during the run delivered it, and a session that ended with held messages reported nothing to their senders.
 
 To let a `-p` worker take messages unattended, start it with `crossSessionInbound` set to `accept` in its `--settings` value. An `accept` in your user settings also works but applies to every session you run.
@@ -189,5 +196,5 @@ Set [`isolatePeerMachines`](/docs/en/settings#available-settings) to `true` to r
 ```
 
-With this set, Claude Code asks for your approval before Claude's message to a session beyond this machine leaves, even in `bypassPermissions` mode, which skips ordinary permission prompts. A `true` from any settings scope applies, so a checked-in project file can turn the requirement on but not off. Messages between sessions on the same machine don't prompt.
+With this set, Claude Code asks for your approval before Claude's message to a session beyond this machine leaves, even in `bypassPermissions` mode, which skips ordinary permission prompts. A `true` from any settings scope applies, so a checked-in project file can turn the requirement on but not off. Claude Code doesn't prompt for messages between sessions on the same machine.
```

</details>

<details>
<summary>hooks-guide-ja.md</summary>

```diff
diff --git a/docs-ja/pages/hooks-guide-ja.md b/docs-ja/pages/hooks-guide-ja.md
index ec8b480..630d881 100644
--- a/docs-ja/pages/hooks-guide-ja.md
+++ b/docs-ja/pages/hooks-guide-ja.md
@@ -467,5 +467,5 @@ Hook イベントは Claude Code のライフサイクルの特定のポイン
 | `PreToolUse`          | Before a tool call executes. Can block it                                                                                                              |
 | `PermissionRequest`   | When a tool call needs a permission decision                                                                                                           |
-| `PermissionDenied`    | When a tool call is denied by the auto mode classifier. Return `{retry: true}` to tell the model it may retry the denied tool call                     |
+| `PermissionDenied`    | When a tool call is denied by the auto mode classifier. Use JSON `hookSpecificOutput.retry: true` to tell the model it may retry the denied tool call  |
 | `PostToolUse`         | After a tool call succeeds                                                                                                                             |
 | `PostToolUseFailure`  | After a tool call fails                                                                                                                                |
@@ -478,5 +478,5 @@ Hook イベントは Claude Code のライフサイクルの特定のポイン
 | `TaskCompleted`       | When a task is being marked as completed                                                                                                               |
 | `Stop`                | When Claude finishes responding                                                                                                                        |
-| `StopFailure`         | When the turn ends due to an API error. Output and exit code are ignored                                                                               |
+| `StopFailure`         | When the turn ends due to an API error                                                                                                                 |
 | `TeammateIdle`        | When an [agent team](/docs/en/agent-teams) teammate is about to go idle                                                                                     |
 | `InstructionsLoaded`  | When a CLAUDE.md or `.claude/rules/*.md` file is loaded into context. Fires at session start and when files are lazily loaded during a session         |
```

</details>

<details>
<summary>hooks-ja.md</summary>

```diff
diff --git a/docs-ja/pages/hooks-ja.md b/docs-ja/pages/hooks-ja.md
index 4d90d15..05ad6a3 100644
--- a/docs-ja/pages/hooks-ja.md
+++ b/docs-ja/pages/hooks-ja.md
@@ -41,5 +41,5 @@
 | `PreToolUse`          | Before a tool call executes. Can block it                                                                                                              |
 | `PermissionRequest`   | When a tool call needs a permission decision                                                                                                           |
-| `PermissionDenied`    | When a tool call is denied by the auto mode classifier. Return `{retry: true}` to tell the model it may retry the denied tool call                     |
+| `PermissionDenied`    | When a tool call is denied by the auto mode classifier. Use JSON `hookSpecificOutput.retry: true` to tell the model it may retry the denied tool call  |
 | `PostToolUse`         | After a tool call succeeds                                                                                                                             |
 | `PostToolUseFailure`  | After a tool call fails                                                                                                                                |
@@ -52,5 +52,5 @@
 | `TaskCompleted`       | When a task is being marked as completed                                                                                                               |
 | `Stop`                | When Claude finishes responding                                                                                                                        |
-| `StopFailure`         | When the turn ends due to an API error. Output and exit code are ignored                                                                               |
+| `StopFailure`         | When the turn ends due to an API error                                                                                                                 |
 | `TeammateIdle`        | When an [agent team](/docs/en/agent-teams) teammate is about to go idle                                                                                     |
 | `InstructionsLoaded`  | When a CLAUDE.md or `.claude/rules/*.md` file is loaded into context. Fires at session start and when files are lazily loaded during a session         |
```

</details>

<details>
<summary>plugins-reference-ja.md</summary>

```diff
diff --git a/docs-ja/pages/plugins-reference-ja.md b/docs-ja/pages/plugins-reference-ja.md
index 122d4dd..e7cc998 100644
--- a/docs-ja/pages/plugins-reference-ja.md
+++ b/docs-ja/pages/plugins-reference-ja.md
@@ -127,5 +127,5 @@ disallowedTools: Write, Edit
 | `PreToolUse`          | Before a tool call executes. Can block it                                                                                                              |
 | `PermissionRequest`   | When a tool call needs a permission decision                                                                                                           |
-| `PermissionDenied`    | When a tool call is denied by the auto mode classifier. Return `{retry: true}` to tell the model it may retry the denied tool call                     |
+| `PermissionDenied`    | When a tool call is denied by the auto mode classifier. Use JSON `hookSpecificOutput.retry: true` to tell the model it may retry the denied tool call  |
 | `PostToolUse`         | After a tool call succeeds                                                                                                                             |
 | `PostToolUseFailure`  | After a tool call fails                                                                                                                                |
@@ -138,5 +138,5 @@ disallowedTools: Write, Edit
 | `TaskCompleted`       | When a task is being marked as completed                                                                                                               |
 | `Stop`                | When Claude finishes responding                                                                                                                        |
-| `StopFailure`         | When the turn ends due to an API error. Output and exit code are ignored                                                                               |
+| `StopFailure`         | When the turn ends due to an API error                                                                                                                 |
 | `TeammateIdle`        | When an [agent team](/docs/en/agent-teams) teammate is about to go idle                                                                                     |
 | `InstructionsLoaded`  | When a CLAUDE.md or `.claude/rules/*.md` file is loaded into context. Fires at session start and when files are lazily loaded during a session         |
```

</details>

<details>
<summary>self-hosted-environments-deploy-en.md</summary>

```diff
diff --git a/docs-ja/pages/self-hosted-environments-deploy-en.md b/docs-ja/pages/self-hosted-environments-deploy-en.md
index 515cb55..2f99e19 100644
--- a/docs-ja/pages/self-hosted-environments-deploy-en.md
+++ b/docs-ja/pages/self-hosted-environments-deploy-en.md
@@ -63,5 +63,5 @@ Whether these hosts are needed depends on your configuration:
 | `*.frame.claudeusercontent.com`      | 443  | Only when the [Artifact tool](/docs/en/artifacts#availability) is available for sessions in your organization; defaults vary by plan, per the availability table there. Set `CLAUDE_CODE_DISABLE_ARTIFACT=1` on the runner to keep the tool disabled regardless of the organization setting. |
 | `raw.githubusercontent.com`          | 443  | Only for the changelog fetch behind `/release-notes` and the release notes shown after a CLI version change. Suppressed by `CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC=1`.                                                                                                                |
-| `registry.npmjs.org`                 | 443  | Only when a session installs a plugin that includes Node.js dependencies, or when an `npx`-launched MCP server runs                                                                                                                                                                     |
+| `registry.npmjs.org`                 | 443  | When a session installs a plugin, both for fetching npm-source plugin packages and for installing a plugin's Node.js dependencies, or when an `npx`-launched MCP server runs                                                                                                            |
 | `http-intake.logs.us5.datadoghq.com` | 443  | Anthropic operational metrics. Only when `CLAUDE_CODE_BYOC_ENABLE_DATADOG=1` is set; off by default in self-hosted environments.                                                                                                                                                        |
 | `browser-intake-us5-datadoghq.com`   | 443  | Anthropic error-report uploads, sent only when [error reporting](/docs/en/data-usage#telemetry-services) is enabled for the session's account. Suppressed by `DISABLE_ERROR_REPORTING=1` or `DISABLE_TELEMETRY=1`.                                                                           |
@@ -277,5 +277,7 @@ On the first `SIGTERM`, and again on a forced exit, the runner logs how many `po
 If a runner dies mid-session, the server requeues the session and another runner in the environment picks it up. That runner derives the checkout path from its own `--base-dir` and `--capacity`: `--capacity 1` checks out directly under `--base-dir`, and a `--capacity` above `1` uses per-session worktrees instead. When runners in the same environment use different values for either flag, the resumed session's working directory changes, and absolute paths the agent recorded earlier, in edits, tool calls, or its own notes, point at a location that no longer exists.
 
-Use the same `--base-dir` and `--capacity` on every runner in an environment, and don't use a per-host value such as an instance ID or hostname. The base directory must be writable by the user the runner runs as: the runner creates per-session directories under it when each session starts and doesn't check it at startup, so a missing or read-only base directory typically shows up as sessions that fail immediately after pickup rather than as a startup error. The default is `/workspace`, which a runner running as root creates on first use; for a non-root runner, create the directory and give that user ownership before starting the runner, or point `--base-dir` at a directory the user already owns.
+Use the same `--base-dir` and `--capacity` on every runner in an environment, and don't use a per-host value such as an instance ID or hostname.
+
+The base directory defaults to `/workspace`. The runner needs write access to it. At startup, before registering, the runner creates the directory and confirms it can write to it, and exits with `cannot create or write to base directory` when it can't. A runner started as root creates the default `/workspace` itself. For a non-root runner, create the directory and give the runner's user ownership before starting the runner, or point `--base-dir` at a directory that user already owns.
 
 ## Reuse a pre-warmed checkout
@@ -340,11 +342,12 @@ Common issues:
 
 * **Runner doesn't appear in the environment**: confirm the host can reach `api.anthropic.com` over HTTPS, the environment secret is current, and the host clock is within five minutes of real time; larger skew causes authentication to fail. The runner logs `[runner:fatal]` with the rejection reason on auth failure.
+* **Runner exits at startup with `cannot create or write to base directory`**: the runner can't create or write to `--base-dir`, which defaults to `/workspace`. Fix the directory's ownership or point `--base-dir` at a writable path, as described in [Keep the base directory and capacity identical across runners](#keep-the-base-directory-and-capacity-identical-across-runners). If the runner instead logs `[runner:fatal]` saying the base directory check timed out, the directory is on a hung NFS or CSI mount. Check mount health rather than permissions. The runner prints both of these startup failures to stderr before it opens `--log-file`, so look for them in the terminal or your platform's container logs rather than the log file. Before v2.1.225, the runner didn't check the base directory at startup, and this misconfiguration failed sessions after pickup instead.
 * **Sessions stay queued**: every online runner may be locked to a different account. Check each runner's `claude_code_self_hosted_runner_locked_account` [metric](/docs/en/self-hosted-environments-reference#prometheus-metrics) or its `Picked up session` log lines to see which account holds it. Add replicas, or wait for an existing runner to drain and restart. If the environment uses on-demand runners, check the orchestrator instead; see [On-demand runners](/docs/en/self-hosted-environments-configuration#on-demand-runners).
-* **Sessions fail immediately after pickup**: open the session in claude.ai/code to see the error. The most common causes are missing [git credentials](#configure-git) in the runner image, build tools that aren't installed, and a base directory the runner's user can't write to. For the last one the error is `EACCES` on a path under `--base-dir`, default `/workspace`; fix the directory's ownership or point `--base-dir` at a writable path, as described in [Keep the base directory and capacity identical across runners](#keep-the-base-directory-and-capacity-identical-across-runners).
+* **Sessions fail immediately after pickup**: open the session in claude.ai/code to see the error. The most common causes are missing [git credentials](#configure-git) in the runner image and build tools that aren't installed. An unwritable base directory stops the runner at startup instead of failing sessions. See the **Runner exits at startup with `cannot create or write to base directory`** entry in this list.
 * **A session's branch no longer exists on the remote**: for a git source the session only reads from, the runner skips that source and continues on the remaining ones. For the source the session pushes results to, a deleted branch, typically because it was merged and auto-deleted, fails the session with an error naming the repository and branch and asking you to restore the branch and retry.
 * **Sessions take minutes to start**: the initial clone usually dominates. Watch the `claude_code_self_hosted_runner_session_init_duration_seconds` [metric](/docs/en/self-hosted-environments-reference#prometheus-metrics) to confirm, and cut the clone with a [pre-warmed checkout](#reuse-a-pre-warmed-checkout) or a smaller `CLAUDE_RUNNER_FETCH_DEPTH`.
 * **Pod is killed mid-drain**: raise `terminationGracePeriodSeconds` to at least the value the runner logs at startup. See [Shutdown timing](#shutdown-timing).
```

</details>

<details>
<summary>self-hosted-environments-en.md</summary>

```diff
diff --git a/docs-ja/pages/self-hosted-environments-en.md b/docs-ja/pages/self-hosted-environments-en.md
index eedefdb..d89f297 100644
--- a/docs-ja/pages/self-hosted-environments-en.md
+++ b/docs-ja/pages/self-hosted-environments-en.md
@@ -44,5 +44,5 @@ Check these before planning a rollout:
 * **Zero Data Retention**: unavailable for organizations with [Zero Data Retention](/docs/en/zero-data-retention) enabled.
 * **Model inference**: sessions use the Anthropic API, and inference can't be routed through [Amazon Bedrock, Google Cloud's Agent Platform, Microsoft Foundry](/docs/en/third-party-integrations), or an [LLM gateway](/docs/en/llm-gateway).
-* **Surfaces**: sessions started from [Claude Code on the web](/docs/en/claude-code-on-the-web), the mobile and desktop apps, [scheduled routines](/docs/en/routines), and the terminal, with [`claude --cloud`](/docs/en/claude-code-on-the-web#from-terminal-to-web) or a scripted [`--environment` dispatch](/docs/en/self-hosted-environments-testing#run-the-test-loop), can run in self-hosted environments. [Claude Tag](https://claude.com/docs/claude-tag/overview), [Claude Security](/docs/en/claude-security), and [Code Review](/docs/en/code-review) sessions don't route to them yet; support for those surfaces follows separately.
+* **Surfaces**: sessions started from [Claude Code on the web](/docs/en/claude-code-on-the-web), the mobile and desktop apps, [scheduled routines](/docs/en/routines), and the terminal, with [`claude --cloud`](/docs/en/claude-code-on-the-web#from-terminal-to-web) or an [`--environment` dispatch](/docs/en/self-hosted-environments-testing#run-the-test-loop), can run in self-hosted environments. [Claude Tag](https://claude.com/docs/claude-tag/overview), [Claude Security](/docs/en/claude-security), and [Code Review](/docs/en/code-review) sessions don't route to them yet. Support for those surfaces follows separately.
 * **Repositories**: sessions check out repositories from GitHub; see [GitHub authentication options](/docs/en/claude-code-on-the-web#github-authentication-options).
 * **Billing**: sessions in a self-hosted environment consume your organization's Claude Code usage the same way sessions in Anthropic-hosted environments do.
```

</details>

<details>
<summary>self-hosted-environments-quickstart-en.md</summary>

```diff
diff --git a/docs-ja/pages/self-hosted-environments-quickstart-en.md b/docs-ja/pages/self-hosted-environments-quickstart-en.md
index c54ec47..6b379b4 100644
--- a/docs-ja/pages/self-hosted-environments-quickstart-en.md
+++ b/docs-ja/pages/self-hosted-environments-quickstart-en.md
@@ -76,9 +76,7 @@ To set up manually instead:
     ```
 
-    Create the base directory, replacing `<writable-dir>` here and in the next command with an absolute path that the user running the runner can write to. The runner checks repositories out and creates per-session directories under this path. Without `--base-dir` it uses `/workspace`, which only works if that directory already exists and is writable or the runner runs as root.
+    Choose a base directory, replacing `<writable-dir>` in the runner command below with an absolute path that the runner can write to or create. The runner creates the directory at startup, then checks repositories out and creates per-session directories under it. Without `--base-dir` it uses `/workspace`, which only works if that directory already exists and is writable or you start the runner as root.
 
-    ```bash theme={null}
-    mkdir -p '<writable-dir>'
-    ```
+    If the runner can't create or write to the path, it exits at startup with an error naming the directory instead of registering. See [Troubleshooting](/docs/en/self-hosted-environments-deploy#troubleshooting).
 
     Then start the runner with `--environment-secret-file` and `--base-dir`. The runner registers with your environment and begins polling for work. If the runner exits, restart it by hand. Production deployments run the runner under an orchestrator that restarts exited runners, normally with a fresh filesystem per restart; [Reuse a pre-warmed checkout](/docs/en/self-hosted-environments-deploy#reuse-a-pre-warmed-checkout) covers the supported persistent-disk setup.
```

</details>

*...以降省略*

</details>


<details>
<summary>2026-08-11</summary>

**変更ファイル:**

```
 docs-ja/pages/changelog.md                  |  8 ++++++
 docs-ja/pages/claude-tag-en.md              |  2 +-
 docs-ja/pages/cross-session-messaging-en.md | 42 ++++++++++++++++++-----------
 3 files changed, 36 insertions(+), 16 deletions(-)
```

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index f22a5fb..0f47adb 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,12 @@
 # Changelog
 
+## 2.1.227
+
+- Fixed feature flags being evaluated without the user's subscription tier when a session started with an expired login token, which could wrongly prompt Max plan users to enable usage credits for Fable
+- Fixed every Bash command failing under `claude-code-action` with `allowed_non_write_users` on GitHub-hosted runners
+- Fixed `/tui` bringing back a conversation that had been rewound to before its first message
+- Improved slash-command menu: blue now marks only the selected row, matched characters are bolded instead of recolored, and emoji or accented names keep their glyphs
+- Improved performance: fewer event-loop stalls on file-not-found suggestions and at-mention size checks
+
 ## 2.1.226
 
```

</details>

<details>
<summary>claude-tag-en.md</summary>

```diff
diff --git a/docs-ja/pages/claude-tag-en.md b/docs-ja/pages/claude-tag-en.md
index 1949ed3..c099d8c 100644
--- a/docs-ja/pages/claude-tag-en.md
+++ b/docs-ja/pages/claude-tag-en.md
@@ -7,5 +7,5 @@
 > Bring Claude into your team's Slack channels with Claude Tag and find its setup and usage documentation on claude.com.
 
-Claude Tag is a Slack integration that runs `@Claude` in your team's channels as your organization's shared identity with admin-configured access. Anyone in a channel can tag `@Claude` into a thread and assign it a task. Read the [Claude Tag documentation](https://claude.com/docs/claude-tag/overview) on claude.com to set it up and start using it.
+[Claude Tag](https://claude.com/product/tag) is a Slack integration that runs `@Claude` in your team's channels as your organization's shared identity with admin-configured access. Anyone in a channel can tag `@Claude` into a thread and assign it a task. Read the [Claude Tag documentation](https://claude.com/docs/claude-tag/overview) on claude.com to set it up and start using it.
 
 Claude Tag is available on Team and Enterprise plans, and is distinct from the earlier [Claude Code in Slack](/docs/en/slack), which runs each session under an individual user's account. On Pro and Max plans, where Claude Tag isn't available, Claude Code in Slack remains the setup path.
```

</details>

<details>
<summary>cross-session-messaging-en.md</summary>

```diff
diff --git a/docs-ja/pages/cross-session-messaging-en.md b/docs-ja/pages/cross-session-messaging-en.md
index 31b5985..71d4945 100644
--- a/docs-ja/pages/cross-session-messaging-en.md
+++ b/docs-ja/pages/cross-session-messaging-en.md
@@ -5,5 +5,5 @@
 # Message your other Claude Code sessions
 
-> Let Claude list and message your other Claude Code sessions on one machine, and reply to your sessions on other machines or on the web through Remote Control.
+> Let Claude list and message your other Claude Code sessions on this machine, and reach your sessions on other machines or on the web.
 
 <Note>
@@ -24,5 +24,5 @@ Use messaging when one of your sessions has something another session needs mid-
 * **Coordinate parallel worktrees**: when sessions work the same repository in separate [worktrees](/docs/en/worktrees), Claude can tell the other sessions what landed.
 * **Get status from long-running work**: have a migration or test run report back to the session you're watching, or ask it yourself from there.
-* **Reply across machines**: answer a message that arrived from one of your sessions on another machine or on the web. Across machines, Claude can only reply. It can't start the exchange.
+* **Message across machines**: reach one of your sessions on another machine or on the web.
 
 Use messaging between independent sessions that you start and steer yourself. Claude Code has a dedicated feature for each of the other ways to run or reach multiple sessions, so use the one built for what you're doing instead:
@@ -72,5 +72,8 @@ Claude finds a message's target on its own, so you don't need to run anything be
 * **Subagents**: agents running inside the current session. [Agent team](/docs/en/agent-teams) teammates aren't listed; Claude messages them through the team's own roster.
 * **Your other local sessions**: Claude Code sessions running on the same machine, including [background sessions](/docs/en/agent-view). A session appears only when it binds an [inbox socket](#the-sessions-inbox-socket).
-* **Sessions beyond this machine**: shown while [Remote Control](/docs/en/remote-control) is connected and labeled `Remote Control`. These are your sessions on other machines and your [Claude Code on the web](/docs/en/claude-code-on-the-web) sessions. Claude can't send a message to start a conversation with one of these sessions. It can only reply to a message that arrived from one of them. See [Message sessions on other machines](#message-sessions-on-other-machines).
+* **Your cloud sessions**: your [Claude Code on the web](/docs/en/claude-code-on-the-web) sessions. These appear when this session has cloud access: a claude.ai login on the first-party Anthropic API and an organization policy that allows cloud sessions.
+* **Your Remote Control sessions on other machines**: shown while this session is connected to [Remote Control](/docs/en/remote-control), and labeled `Remote Control`.
+
+Claude addresses a session beyond this machine by name, the same as a local session. See [Message sessions on other machines](#message-sessions-on-other-machines) for how those messages travel.
 
 A session answers to the name you set with the [`/rename`](/docs/en/commands) command or the [`--name`](/docs/en/cli-reference#cli-flags) flag. When you don't set one, Claude Code names the session itself. An interactive session gets a name derived from its working directory's folder name, such as `myapp-3f`.
@@ -80,15 +83,17 @@ Two sessions can end up with the same name. The `/list-agents` output shows each
 ### Message sessions on other machines
```

</details>

</details>


<details>
<summary>2026-08-09</summary>

**変更ファイル:**

```
 docs-ja/pages/changelog.md | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)
```

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index ac7d9ca..f22a5fb 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,25 @@
 # Changelog
 
+## 2.1.226
+
+- Bug fixes and reliability improvements
+
+## 2.1.225
+
+- Added gateway spend-limit support to Claude Code's usage warning; the limit-reached message now names the cap, its reset time, and the operator's message (requires the gateway on 2.1.225)
+- Added a workspace trust prompt to `claude agents` for untrusted directories, matching the behavior of `claude`
+- Fixed a transient 401 replacing a long-lived `CLAUDE_CODE_OAUTH_TOKEN` with a stored login's short-lived token, breaking headless sessions until restart
+- Fixed MCP OAuth servers on macOS intermittently failing with a burst of 401 errors, as if never authenticated, after a keychain read timed out
+- Fixed auto mode counting a safety-filter refusal of its own permission check toward the consecutive-block limit; the action is still denied, but the model is now told to move on rather than retry
+- Fixed cross-session messages staying parked without a notice or expiry in headless sessions and during startup
+- Fixed conversation history breaking on Remote Control session resume after very large conversations were compacted
+- Fixed hovering over a session in another project in the agents list changing the directory the next agent starts in
+- Fixed `claude self-hosted-runner` registering and then failing every session when `--base-dir` cannot be created or written; it now exits at startup with a clear error
+- Fixed Claude Code on the web sessions being misreported as stuck, re-sending a growing event backlog on every reconnect
+- Improved Remote Control: photos attached from the Claude app are now shown to Claude directly instead of being read from disk with a separate tool call
+- [VSCode] Fixed Focus view folding away the latest to-do list, a pending question's context, and settled answers; thinking-only folds show "Thought for Ns" and re-collapse when their turn completes
+- SendMessage can now start a conversation with your Remote Control sessions on other machines by name (`ListAgents` shows them as `name [ref]`), instead of only replying after they message you first
+- SendMessage: a Remote Control recipient you already confirmed is never swapped for a same-named session on this machine when its own list couldn't be checked
+
 ## 2.1.224
 
```

</details>

</details>


<details>
<summary>2026-08-08</summary>

**変更ファイル:**

```
 docs-ja/pages/changelog.md                  | 34 +++++++++++++++++++++++++++++
 docs-ja/pages/desktop-scheduled-tasks-ja.md | 22 +++++++++----------
 docs-ja/pages/platforms-ja.md               | 15 +++++++------
 docs-ja/pages/remote-control-ja.md          | 15 +++++++------
 docs-ja/pages/scheduled-tasks-ja.md         | 22 +++++++++----------
 5 files changed, 72 insertions(+), 36 deletions(-)
```

**新規追加:**


<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index a903062..ac7d9ca 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,38 @@
 # Changelog
 
+## 2.1.224
+
+- Added self-hosted environments: `claude self-hosted-runner` turns your own machines or containers into a place Claude Code web, mobile, and desktop sessions can run, on Team and Enterprise plans
+- Added `archive` plugin source: install plugins from a zip over HTTPS without git or npm, with optional SHA-256 pinning
+- Added a cancel-and-confirm step when removing an unavailable paste changes a command's text
+- Added `ANTHROPIC_BEDROCK_REGION_PREFIX` env var for Bedrock to prefer a specific cross-region inference profile over the `AWS_REGION`-derived one
+- Added `crossSessionInbound` and `dialogExpiry` settings: cross-session messages sent to a session running with bypassed permissions are held for your approval, and messages to other sessions auto-deliver
+- Added sandbox credential-masking options: `extract` and `onExtractNoMatch` for structured env values, `decode: "jwt"` with `maskClaims` for JWT-aware masking, and `awsPairs`/`sigv4` for AWS SigV4 re-signing; these need `network.tlsTerminate` and are honored only from user, managed, or `--settings` settings
+- Added cross-session `SendMessage`: Claude Code sessions can now message each other, on any of your machines, with `ListAgents` to discover them (macOS and Linux)
+- Fixed long (>200 char) project paths resolving to another project's session directory under a shared sanitized prefix; session list, rename, fork, delete and `/resume` no longer cross projects
+- Fixed `SendMessage` reporting "Message sent" when the write to a teammate's inbox had actually failed; failed deliveries are now reported as errors
+- Fixed sandbox filesystem deny entries written with a trailing slash (e.g. `denyRead: "~/.aws/"`) being silently bypassable on Linux and macOS
+- Fixed sandbox violation details never appearing in Bash tool results; Claude now sees which file or network access was denied and why
+- Fixed MCP tools that connect mid-turn being deferred for tool search without their names announced to the model
+- Fixed plugin install records being silently corrupted when the same plugin is installed in multiple projects
+- Fixed recalled or restored paste content occasionally attaching wrong data or silently losing text when the paste had aged out or placeholder numbers collided
+- Fixed copy-on-select on Wayland sometimes not reaching the clipboard; the two selection writes no longer race
+- Fixed the feedback survey's transcript share silently failing on long sessions; a failed share now shows an error instead of a success message
+- Fixed Remote Control auto-start intermittently failing with "Remote credentials fetch failed" on a cold start with a stale login token
+- Fixed Remote Control and SDK clients showing a blank "(no content)" message after `/clear` and other output-less commands
+- Fixed a Remote Control session recreated after its server session expired uploading prior local conversation history into the new session
+- Improved fullscreen mode to keep the full pre-compaction history in scrollback across repeated compactions, instead of only the most recent interval
+- Improved Remote Control: attached web and mobile clients now see compaction progress and the post-compaction boundary instead of a silent pause; `/clear` resets now propagate to attached clients
```

</details>

<details>
<summary>desktop-scheduled-tasks-ja.md</summary>

```diff
diff --git a/docs-ja/pages/desktop-scheduled-tasks-ja.md b/docs-ja/pages/desktop-scheduled-tasks-ja.md
index c4f67f6..f3a8aea 100644
--- a/docs-ja/pages/desktop-scheduled-tasks-ja.md
+++ b/docs-ja/pages/desktop-scheduled-tasks-ja.md
@@ -17,15 +17,15 @@ Desktop アプリの **Routines** ページでは、ローカルスケジュー
 Claude Code offers three ways to schedule recurring or one-off work:
 
-|                            | [Cloud](/docs/en/routines)          | [Desktop](/docs/en/desktop-scheduled-tasks) | [`/loop`](/docs/en/scheduled-tasks)      |
-| :------------------------- | :----------------------------- | :------------------------------------- | :---------------------------------- |
-| Runs on                    | Anthropic cloud                | Your machine                           | Your machine                        |
-| Requires machine on        | No                             | Yes                                    | Yes                                 |
-| Requires open session      | No                             | No                                     | Yes                                 |
-| Persistent across restarts | Yes                            | Yes                                    | Restored on `--resume` if unexpired |
-| Access to local files      | No (fresh clone)               | Yes                                    | Yes                                 |
-| MCP servers                | Connectors configured per task | [Config files](/docs/en/mcp) and connectors | Inherits from session               |
-| Permission prompts         | No (runs autonomously)         | Configurable per task                  | Inherits from session               |
-| Customizable schedule      | Via `/schedule` in the CLI     | Yes                                    | Yes                                 |
-| Minimum interval           | 1 hour                         | 1 minute                               | 1 minute                            |
+|                            | [Cloud](/docs/en/routines)               | [Desktop](/docs/en/desktop-scheduled-tasks) | [`/loop`](/docs/en/scheduled-tasks)      |
+| :------------------------- | :---------------------------------- | :------------------------------------- | :---------------------------------- |
+| Runs on                    | Cloud, Anthropic-managed by default | Your machine                           | Your machine                        |
+| Requires machine on        | No                                  | Yes                                    | Yes                                 |
+| Requires open session      | No                                  | No                                     | Yes                                 |
+| Persistent across restarts | Yes                                 | Yes                                    | Restored on `--resume` if unexpired |
+| Access to local files      | No (fresh clone)                    | Yes                                    | Yes                                 |
+| MCP servers                | Connectors configured per task      | [Config files](/docs/en/mcp) and connectors | Inherits from session               |
+| Permission prompts         | No (runs autonomously)              | Configurable per task                  | Inherits from session               |
+| Customizable schedule      | Via `/schedule` in the CLI          | Yes                                    | Yes                                 |
+| Minimum interval           | 1 hour                              | 1 minute                               | 1 minute                            |
 
```

</details>

<details>
<summary>platforms-ja.md</summary>

```diff
diff --git a/docs-ja/pages/platforms-ja.md b/docs-ja/pages/platforms-ja.md
index 625631e..0567ebc 100644
--- a/docs-ja/pages/platforms-ja.md
+++ b/docs-ja/pages/platforms-ja.md
@@ -50,11 +50,12 @@ CLI はターミナルネイティブな作業に最も完全なサーフェス
 Claude Code offers several ways to work when you're not at your terminal. They differ in what triggers the work, where Claude runs, and how much you need to set up.
 
-|                                                | Trigger                                                                                        | Claude runs on                                                                               | Setup                                                                                                                                | Best for                                                      |
-| :--------------------------------------------- | :--------------------------------------------------------------------------------------------- | :------------------------------------------------------------------------------------------- | :----------------------------------------------------------------------------------------------------------------------------------- | :------------------------------------------------------------ |
-| [Dispatch](/docs/en/desktop#sessions-from-dispatch) | Message a task from the Claude mobile app                                                      | Your machine (Desktop)                                                                       | [Pair the mobile app with Desktop](https://support.claude.com/en/articles/13947068)                                                  | Delegating work while you're away, minimal setup              |
-| [Remote Control](/docs/en/remote-control)           | Drive a running session from [claude.ai/code](https://claude.ai/code) or the Claude mobile app | Your machine (CLI or VS Code)                                                                | Run `claude remote-control`                                                                                                          | Steering in-progress work from another device                 |
-| [Channels](/docs/en/channels)                       | Push events from a chat app like Telegram or Discord, or your own server                       | Your machine (CLI)                                                                           | [Install a channel plugin](/docs/en/channels#quickstart) or [build your own](/docs/en/channels-reference)                                      | Reacting to external events like CI failures or chat messages |
-| [Slack](/docs/en/slack)                             | Mention `@Claude` in a team channel                                                            | Anthropic cloud                                                                              | [Install the Slack app](/docs/en/slack#setting-up-claude-code-in-slack) with [Claude Code on the web](/docs/en/claude-code-on-the-web) enabled | PRs and reviews from team chat                                |
-| [Scheduled tasks](/docs/en/scheduled-tasks)         | Set a schedule                                                                                 | [CLI](/docs/en/scheduled-tasks), [Desktop](/docs/en/desktop-scheduled-tasks), or [cloud](/docs/en/routines) | Pick a frequency                                                                                                                     | Recurring automation like daily reviews                       |
+|                                                          | Trigger                                                                                        | Claude runs on                                                                               | Setup                                                                                                                                | Best for                                                      |
+| :------------------------------------------------------- | :--------------------------------------------------------------------------------------------- | :------------------------------------------------------------------------------------------- | :----------------------------------------------------------------------------------------------------------------------------------- | :------------------------------------------------------------ |
+| [Dispatch](/docs/en/desktop#sessions-from-dispatch)           | Message a task from the Claude mobile app                                                      | Your machine (Desktop)                                                                       | [Pair the mobile app with Desktop](https://support.claude.com/en/articles/13947068)                                                  | Delegating work while you're away, minimal setup              |
+| [Remote Control](/docs/en/remote-control)                     | Drive a running session from [claude.ai/code](https://claude.ai/code) or the Claude mobile app | Your machine (CLI or VS Code)                                                                | Run `claude remote-control`                                                                                                          | Steering in-progress work from another device                 |
+| [Channels](/docs/en/channels)                                 | Push events from a chat app like Telegram or Discord, or your own server                       | Your machine (CLI)                                                                           | [Install a channel plugin](/docs/en/channels#quickstart) or [build your own](/docs/en/channels-reference)                                      | Reacting to external events like CI failures or chat messages |
+| [Slack](/docs/en/slack)                                       | Mention `@Claude` in a team channel                                                            | Anthropic cloud                                                                              | [Install the Slack app](/docs/en/slack#setting-up-claude-code-in-slack) with [Claude Code on the web](/docs/en/claude-code-on-the-web) enabled | PRs and reviews from team chat                                |
+| [Self-hosted environments](/docs/en/self-hosted-environments) | Start a [cloud session](/docs/en/claude-code-on-the-web) and pick your organization's environment   | Your organization's infrastructure                                                           | [Deploy runners](/docs/en/self-hosted-environments-quickstart), on Team and Enterprise plans                                              | Cloud sessions that must run inside your network              |
+| [Scheduled tasks](/docs/en/scheduled-tasks)                   | Set a schedule                                                                                 | [CLI](/docs/en/scheduled-tasks), [Desktop](/docs/en/desktop-scheduled-tasks), or [cloud](/docs/en/routines) | Pick a frequency                                                                                                                     | Recurring automation like daily reviews                       |
 
 どこから始めるべきか不確かな場合は、[CLI をインストール](/docs/ja/quickstart)してプロジェクトディレクトリで実行します。ターミナルを使用したくない場合は、[Desktop](/docs/ja/desktop-quickstart) がグラフィカルインターフェースで同じエンジンを提供します。
```

</details>

<details>
<summary>remote-control-ja.md</summary>

```diff
diff --git a/docs-ja/pages/remote-control-ja.md b/docs-ja/pages/remote-control-ja.md
index 3eb81ea..6ba1236 100644
--- a/docs-ja/pages/remote-control-ja.md
+++ b/docs-ja/pages/remote-control-ja.md
@@ -386,11 +386,12 @@ v2.1.200 より前では、再接続の失敗により新しい Remote Control 
 Claude Code offers several ways to work when you're not at your terminal. They differ in what triggers the work, where Claude runs, and how much you need to set up.
 
-|                                                | Trigger                                                                                        | Claude runs on                                                                               | Setup                                                                                                                                | Best for                                                      |
-| :--------------------------------------------- | :--------------------------------------------------------------------------------------------- | :------------------------------------------------------------------------------------------- | :----------------------------------------------------------------------------------------------------------------------------------- | :------------------------------------------------------------ |
-| [Dispatch](/docs/en/desktop#sessions-from-dispatch) | Message a task from the Claude mobile app                                                      | Your machine (Desktop)                                                                       | [Pair the mobile app with Desktop](https://support.claude.com/en/articles/13947068)                                                  | Delegating work while you're away, minimal setup              |
-| [Remote Control](/docs/en/remote-control)           | Drive a running session from [claude.ai/code](https://claude.ai/code) or the Claude mobile app | Your machine (CLI or VS Code)                                                                | Run `claude remote-control`                                                                                                          | Steering in-progress work from another device                 |
-| [Channels](/docs/en/channels)                       | Push events from a chat app like Telegram or Discord, or your own server                       | Your machine (CLI)                                                                           | [Install a channel plugin](/docs/en/channels#quickstart) or [build your own](/docs/en/channels-reference)                                      | Reacting to external events like CI failures or chat messages |
-| [Slack](/docs/en/slack)                             | Mention `@Claude` in a team channel                                                            | Anthropic cloud                                                                              | [Install the Slack app](/docs/en/slack#setting-up-claude-code-in-slack) with [Claude Code on the web](/docs/en/claude-code-on-the-web) enabled | PRs and reviews from team chat                                |
-| [Scheduled tasks](/docs/en/scheduled-tasks)         | Set a schedule                                                                                 | [CLI](/docs/en/scheduled-tasks), [Desktop](/docs/en/desktop-scheduled-tasks), or [cloud](/docs/en/routines) | Pick a frequency                                                                                                                     | Recurring automation like daily reviews                       |
+|                                                          | Trigger                                                                                        | Claude runs on                                                                               | Setup                                                                                                                                | Best for                                                      |
+| :------------------------------------------------------- | :--------------------------------------------------------------------------------------------- | :------------------------------------------------------------------------------------------- | :----------------------------------------------------------------------------------------------------------------------------------- | :------------------------------------------------------------ |
+| [Dispatch](/docs/en/desktop#sessions-from-dispatch)           | Message a task from the Claude mobile app                                                      | Your machine (Desktop)                                                                       | [Pair the mobile app with Desktop](https://support.claude.com/en/articles/13947068)                                                  | Delegating work while you're away, minimal setup              |
+| [Remote Control](/docs/en/remote-control)                     | Drive a running session from [claude.ai/code](https://claude.ai/code) or the Claude mobile app | Your machine (CLI or VS Code)                                                                | Run `claude remote-control`                                                                                                          | Steering in-progress work from another device                 |
+| [Channels](/docs/en/channels)                                 | Push events from a chat app like Telegram or Discord, or your own server                       | Your machine (CLI)                                                                           | [Install a channel plugin](/docs/en/channels#quickstart) or [build your own](/docs/en/channels-reference)                                      | Reacting to external events like CI failures or chat messages |
+| [Slack](/docs/en/slack)                                       | Mention `@Claude` in a team channel                                                            | Anthropic cloud                                                                              | [Install the Slack app](/docs/en/slack#setting-up-claude-code-in-slack) with [Claude Code on the web](/docs/en/claude-code-on-the-web) enabled | PRs and reviews from team chat                                |
+| [Self-hosted environments](/docs/en/self-hosted-environments) | Start a [cloud session](/docs/en/claude-code-on-the-web) and pick your organization's environment   | Your organization's infrastructure                                                           | [Deploy runners](/docs/en/self-hosted-environments-quickstart), on Team and Enterprise plans                                              | Cloud sessions that must run inside your network              |
+| [Scheduled tasks](/docs/en/scheduled-tasks)                   | Set a schedule                                                                                 | [CLI](/docs/en/scheduled-tasks), [Desktop](/docs/en/desktop-scheduled-tasks), or [cloud](/docs/en/routines) | Pick a frequency                                                                                                                     | Recurring automation like daily reviews                       |
 
 <h2 id="related-resources">
```

</details>

<details>
<summary>scheduled-tasks-ja.md</summary>

```diff
diff --git a/docs-ja/pages/scheduled-tasks-ja.md b/docs-ja/pages/scheduled-tasks-ja.md
index d9bf144..0f55909 100644
--- a/docs-ja/pages/scheduled-tasks-ja.md
+++ b/docs-ja/pages/scheduled-tasks-ja.md
@@ -17,15 +17,15 @@
 Claude Code offers three ways to schedule recurring or one-off work:
 
-|                            | [Cloud](/docs/en/routines)          | [Desktop](/docs/en/desktop-scheduled-tasks) | [`/loop`](/docs/en/scheduled-tasks)      |
-| :------------------------- | :----------------------------- | :------------------------------------- | :---------------------------------- |
-| Runs on                    | Anthropic cloud                | Your machine                           | Your machine                        |
-| Requires machine on        | No                             | Yes                                    | Yes                                 |
-| Requires open session      | No                             | No                                     | Yes                                 |
-| Persistent across restarts | Yes                            | Yes                                    | Restored on `--resume` if unexpired |
-| Access to local files      | No (fresh clone)               | Yes                                    | Yes                                 |
-| MCP servers                | Connectors configured per task | [Config files](/docs/en/mcp) and connectors | Inherits from session               |
-| Permission prompts         | No (runs autonomously)         | Configurable per task                  | Inherits from session               |
-| Customizable schedule      | Via `/schedule` in the CLI     | Yes                                    | Yes                                 |
-| Minimum interval           | 1 hour                         | 1 minute                               | 1 minute                            |
+|                            | [Cloud](/docs/en/routines)               | [Desktop](/docs/en/desktop-scheduled-tasks) | [`/loop`](/docs/en/scheduled-tasks)      |
+| :------------------------- | :---------------------------------- | :------------------------------------- | :---------------------------------- |
+| Runs on                    | Cloud, Anthropic-managed by default | Your machine                           | Your machine                        |
+| Requires machine on        | No                                  | Yes                                    | Yes                                 |
+| Requires open session      | No                                  | No                                     | Yes                                 |
+| Persistent across restarts | Yes                                 | Yes                                    | Restored on `--resume` if unexpired |
+| Access to local files      | No (fresh clone)                    | Yes                                    | Yes                                 |
+| MCP servers                | Connectors configured per task      | [Config files](/docs/en/mcp) and connectors | Inherits from session               |
+| Permission prompts         | No (runs autonomously)              | Configurable per task                  | Inherits from session               |
+| Customizable schedule      | Via `/schedule` in the CLI          | Yes                                    | Yes                                 |
+| Minimum interval           | 1 hour                              | 1 minute                               | 1 minute                            |
 
```

</details>

</details>


<details>
<summary>2026-08-06</summary>

**変更ファイル:**

```
 docs-ja/pages/changelog.md | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)
```

**新規追加:**


<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index b80eb1e..a903062 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,26 @@
 # Changelog
 
+## 2.1.223
+
+- Added owner wildcard entries (`"owner/*"`) to the `strictKnownMarketplaces` and `blockedMarketplaces` managed settings for allowing or blocking all marketplace repos under a GitHub org
+- Added a warning when workflow agents, forked skills, slash commands, or resumed background agents' requested subagent model is restricted and the parent model runs instead
+- Added a `/teleport` hint in cloud sessions showing how to continue locally with `claude --teleport <session id>`
+- Fixed a Bash permission bypass where a crafted command could hide parts of itself from permission checks
+- Fixed permission prompts so commands padded with tabs or invisible Unicode can no longer hide part of the command from the approval dialog
+- Fixed workflow scripts being able to use dynamic `import()` to run code outside the workflow sandbox
+- Fixed a permission gap where an agent definition's `bypassPermissions` mode ignored the org bypass-permissions disable policy
+- Fixed resuming a session after a mid-session `/cd` coming back empty
+- Fixed gateway model discovery hiding Claude models registered under provider-prefixed IDs such as `vertex_ai/claude-*` or `bedrock/anthropic.claude-*`
+- Fixed `modelOverrides` keys that aren't Anthropic model IDs being treated as the session's canonical model ID; unknown keys are now ignored as documented
+- Fixed managed settings: server-delivered settings no longer disable the env block of a machine-local `managed-settings.json` or MDM profile; admin env now merges per key
+- Fixed sandboxed commands failing to start on Linux when `sandbox.filesystem.denyWrite` covers the working directory
+- Fixed forked background agents getting stuck "already resuming" for the rest of the session when rebuilding the fork's parent prompt failed during resume
+- Fixed a resumed session failing every turn, or leaving the interactive app on an unresponsive error screen, when its history held a malformed diagnostics attachment
+- Fixed a rare hang when parsing unusual `git push` output
+- Changed `CLAUDE_CODE_DISABLE_1M_CONTEXT` to hold every Claude model with a native 1M window to 200K via auto-compaction, not just a fixed list; a startup warning now appears when auto-compaction isn't holding the session to 200K
+- Changed auto-compact to keep sessions on unrecognized model IDs within the assumed context window instead of letting them grow past it; set `CLAUDE_CODE_DISABLE_UNKNOWN_MODEL_WINDOW_ENFORCEMENT=1` to restore the previous behavior
+- Changed `/review` to be an alias of `/code-review`, which reviews the current diff or a PR (`/code-review <level> <pr#>`); use `/code-review ultra` for a deep cloud review
+- Changed `/code-review` with no effort level to reuse the level you typed last; type a level like `/code-review high` to change it
+
 ## 2.1.222
```

</details>

</details>


<details>
<summary>2026-08-05</summary>

**変更ファイル:**

```
 docs-ja/pages/accessibility-ja.md              |   4 +-
 docs-ja/pages/advisor-ja.md                    |  18 +-
 docs-ja/pages/agent-teams-ja.md                |  12 +-
 docs-ja/pages/agent-view-ja.md                 |  72 +--
 docs-ja/pages/agents-ja.md                     |   2 +-
 docs-ja/pages/amazon-bedrock-ja.md             |  20 +-
 docs-ja/pages/artifacts-ja.md                  |   4 -
 docs-ja/pages/authentication-ja.md             |   4 +-
 docs-ja/pages/auto-mode-config-ja.md           |  10 +-
 docs-ja/pages/changelog.md                     |  24 +
 docs-ja/pages/checkpointing-ja.md              |   2 +-
 docs-ja/pages/claude-apps-gateway-deploy-ja.md |   2 +-
 docs-ja/pages/claude-apps-gateway-ja.md        |  22 +-
 docs-ja/pages/claude-apps-gateway-on-aws-en.md | 526 --------------------
 docs-ja/pages/claude-code-on-the-web-ja.md     |  18 +-
 docs-ja/pages/claude-platform-on-aws-ja.md     |   2 +-
 docs-ja/pages/claude-security-en.md            | 148 ------
 docs-ja/pages/cli-reference-ja.md              | 154 +++---
 docs-ja/pages/cloud-environments-en.md         | 663 -------------------------
 docs-ja/pages/code-review-ja.md                |   4 +-
 docs-ja/pages/commands-ja.md                   | 206 ++++----
 docs-ja/pages/computer-use-ja.md               |   2 +-
 docs-ja/pages/context-window-ja.md             |   2 +-
 docs-ja/pages/debug-your-config-ja.md          |   8 +-
 docs-ja/pages/desktop-ios-simulator-en.md      | 147 ------
 docs-ja/pages/desktop-ja.md                    |   4 +-
 docs-ja/pages/discover-plugins-ja.md           |  10 +-
 docs-ja/pages/env-vars-ja.md                   | 594 +++++++++++-----------
 docs-ja/pages/errors-ja.md                     |  78 +--
 docs-ja/pages/fast-mode-ja.md                  |   4 +-
 docs-ja/pages/feature-availability-ja.md       |   2 +-
 docs-ja/pages/fullscreen-ja.md                 |  12 +-
 docs-ja/pages/google-vertex-ai-ja.md           |   2 +-
 docs-ja/pages/headless-ja.md                   |   6 +-
 docs-ja/pages/hooks-ja.md                      |  50 +-
 docs-ja/pages/interactive-mode-ja.md           |  86 ++--
 docs-ja/pages/keybindings-ja.md                |   8 +-
 docs-ja/pages/llm-gateway-connect-ja.md        |   8 +-
 docs-ja/pages/llm-gateway-protocol-ja.md       |   4 +-
 docs-ja/pages/llm-gateway-rollout-ja.md        |   4 +-
 docs-ja/pages/managed-mcp-ja.md                |   2 +-
 docs-ja/pages/mcp-ja.md                        |   6 +-
 docs-ja/pages/memory-ja.md                     |   2 +-
 docs-ja/pages/microsoft-foundry-ja.md          |   2 +-
 docs-ja/pages/mobile-en.md                     |  85 ----
 docs-ja/pages/model-config-ja.md               |  28 +-
 docs-ja/pages/monitoring-usage-ja.md           |  20 +-
 docs-ja/pages/network-config-ja.md             |   2 +-
 docs-ja/pages/output-styles-ja.md              |   4 +-
 docs-ja/pages/permission-modes-ja.md           |  40 +-
 docs-ja/pages/permissions-ja.md                |  42 +-
 docs-ja/pages/plugin-hints-ja.md               |   4 +-
 docs-ja/pages/plugin-marketplaces-ja.md        |  46 +-
 docs-ja/pages/plugin-relevance-ja.md           |  12 +-
 docs-ja/pages/plugins-reference-ja.md          |   6 +-
 docs-ja/pages/prompt-caching-ja.md             |   2 +-
 docs-ja/pages/remote-control-ja.md             |  30 +-
 docs-ja/pages/scheduled-tasks-ja.md            |   2 +-
 docs-ja/pages/security-guidance-ja.md          |   2 +-
 docs-ja/pages/server-managed-settings-ja.md    |  20 +-
 docs-ja/pages/sessions-ja.md                   |   6 +-
 docs-ja/pages/settings-ja.md                   | 378 +++++++-------
 docs-ja/pages/skills-ja.md                     |   2 +-
 docs-ja/pages/statusline-ja.md                 |   2 +-
 docs-ja/pages/sub-agents-ja.md                 |  60 +--
 docs-ja/pages/tools-reference-ja.md            | 110 ++--
 docs-ja/pages/troubleshoot-install-ja.md       |   2 +-
 docs-ja/pages/voice-dictation-ja.md            |   6 +-
 docs-ja/pages/vs-code-ja.md                    |   4 +-
 docs-ja/pages/web-quickstart-ja.md             |   2 +-
 docs-ja/pages/workflows-ja.md                  |   8 +-
 docs-ja/pages/worktrees-ja.md                  |   6 +-
 72 files changed, 1168 insertions(+), 2723 deletions(-)
```

**新規追加:**


**削除:**


<details>
<summary>accessibility-ja.md</summary>

```diff
diff --git a/docs-ja/pages/accessibility-ja.md b/docs-ja/pages/accessibility-ja.md
index 11a5978..06739d2 100644
--- a/docs-ja/pages/accessibility-ja.md
+++ b/docs-ja/pages/accessibility-ja.md
@@ -32,5 +32,5 @@ SSH 経由で Claude Code を使用する場合は、Claude Code が実行され
 
 モードがオンの場合、Claude Code が最初に出力するのは、それをオンにした方法を名前付けする確認行です。`[Screen Reader Mode: on via flag]`、`[Screen Reader Mode: on via env]`、または `[Screen Reader Mode: on via settings]` です。このメソッド命名形式には Claude Code v2.1.206 以降が必要です。Claude Code が自身を再起動する場合（例えば、アップデートのインストールを完了するため）、新しいプロセスは `CLAUDE_AX_SCREEN_READER` 環境変数を通じてモードを継承するため、使用した方法に関係なく、その確認行は `[Screen Reader Mode: on via env]` と表示されます。
-{/* max-version: 2.1.205 */}以前のバージョンは `[Accessible screen reader mode: on]` を出力します。
+以前のバージョンは `[Accessible screen reader mode: on]` を出力します。
 
 <h2 id="turn-off-screen-reader-mode">
@@ -49,5 +49,5 @@ SSH 経由で Claude Code を使用する場合は、Claude Code が実行され
 * 色のみのキューなし
 * 変更されていないコンテンツの再描画なし。プログレススピナーは静的テキストとしてレンダリングされます
-* Claude の返信のテーブルは、ボックス文字グリッドの代わりに `Header: value` 文として読み上げられます。{/* min-version: 2.1.198 */}Claude Code v2.1.198 以降が必要です。以前のバージョンはスクリーンリーダーモードでもテーブルをグリッドとして描画します。
+* Claude の返信のテーブルは、ボックス文字グリッドの代わりに `Header: value` 文として読み上げられます。Claude Code v2.1.198 以降が必要です。以前のバージョンはスクリーンリーダーモードでもテーブルをグリッドとして描画します。
 
 出力はターミナルのスクロールバックに蓄積されるため、スクリーンリーダーのレビューコマンドまたはターミナルの検索を使用して以前のターンを再度読むことができます。
```

</details>

<details>
<summary>advisor-ja.md</summary>

```diff
diff --git a/docs-ja/pages/advisor-ja.md b/docs-ja/pages/advisor-ja.md
index 6c37bae..8a36aeb 100644
--- a/docs-ja/pages/advisor-ja.md
+++ b/docs-ja/pages/advisor-ja.md
@@ -83,12 +83,12 @@ claude --advisor opus
 advisor はメインモデル以上の機能を持つ必要があります。各メインモデルで受け入れられる advisor は次のとおりです。
 
-| メインモデル                                          | 受け入れられる advisor         | 注記                                                                                                                    |
-| ----------------------------------------------- | ----------------------- | --------------------------------------------------------------------------------------------------------------------- |
-| Haiku 4.5                                       | Fable、Opus、Sonnet       | Haiku は advisor を呼び出すことはできますが、advisor として機能することはできません                                                                 |
-| Sonnet 4.6                                      | Fable、Opus、Sonnet       |                                                                                                                       |
-| Sonnet 5                                        | Fable、Opus、Sonnet 5     | Sonnet 4.6 advisor は拒否されます                                                                                            |
-| Opus 4.6                                        | Fable、Opus、Sonnet 5     | Sonnet 5 と Opus 4.6 は同等の機能として評価されるため、Opus 4.6 メインは Sonnet 5 advisor を受け入れます                                           |
-| Opus 4.7 以降                                     | Fable、Opus 4.7、Opus 4.8 | Opus 4.7 と Opus 4.8 は同等の機能として評価されるため、どちらでも他方を advisor として受け入れます。Opus 4.6 または Sonnet 5 advisor を持つ Opus 4.7 メインは拒否されます |
-| Fable 5 ({/* min-version: 2.1.170 */}v2.1.170+) | Fable                   | Opus または Sonnet advisor は拒否されます                                                                                       |
+| メインモデル              | 受け入れられる advisor         | 注記                                                                                                                    |
+| ------------------- | ----------------------- | --------------------------------------------------------------------------------------------------------------------- |
+| Haiku 4.5           | Fable、Opus、Sonnet       | Haiku は advisor を呼び出すことはできますが、advisor として機能することはできません                                                                 |
+| Sonnet 4.6          | Fable、Opus、Sonnet       |                                                                                                                       |
+| Sonnet 5            | Fable、Opus、Sonnet 5     | Sonnet 4.6 advisor は拒否されます                                                                                            |
+| Opus 4.6            | Fable、Opus、Sonnet 5     | Sonnet 5 と Opus 4.6 は同等の機能として評価されるため、Opus 4.6 メインは Sonnet 5 advisor を受け入れます                                           |
+| Opus 4.7 以降         | Fable、Opus 4.7、Opus 4.8 | Opus 4.7 と Opus 4.8 は同等の機能として評価されるため、どちらでも他方を advisor として受け入れます。Opus 4.6 または Sonnet 5 advisor を持つ Opus 4.7 メインは拒否されます |
+| Fable 5 (v2.1.170+) | Fable                   | Opus または Sonnet advisor は拒否されます                                                                                       |
 
 Fable 5 は、メインモデルとして機能するか advisor として機能するかに関わらず、Claude Code v2.1.170 以降と Fable 5 アクセスが必要です。
@@ -161,5 +161,5 @@ advisor ツールには、以下のすべてが必要です。
 
 * **Anthropic API のみ**：advisor はサーバー実行ツールです。Amazon Bedrock、Claude Platform on AWS、Google Cloud の Agent Platform、または Microsoft Foundry では利用できません。[LLM ゲートウェイ](/docs/ja/llm-gateway)を通じて `ANTHROPIC_BASE_URL` で構成されている場合、利用可能性はゲートウェイがリクエストを Anthropic API に完全に転送するかどうかに依存します。
-* **サポートされているメインモデル**：Opus 4.6 以降、Sonnet 4.6 以降、または Haiku 4.5。{/* min-version: 2.1.170 */}Fable 5 も Claude Code v2.1.170 以降で適格です。
+* **サポートされているメインモデル**：Opus 4.6 以降、Sonnet 4.6 以降、または Haiku 4.5。Fable 5 も Claude Code v2.1.170 以降で適格です。
```

</details>

<details>
<summary>agent-teams-ja.md</summary>

```diff
diff --git a/docs-ja/pages/agent-teams-ja.md b/docs-ja/pages/agent-teams-ja.md
index c1ba8ec..79b1162 100644
--- a/docs-ja/pages/agent-teams-ja.md
+++ b/docs-ja/pages/agent-teams-ja.md
@@ -90,5 +90,5 @@ one on UX, one on technical architecture, one playing devil's advocate.
 * **Escape**: 選択したチームメンバーの現在のターンを中断する
 
-{/* min-version: 2.1.199 */}v2.1.199 以降、アイドル状態のチームメンバーの行は、他のチームメンバーまたはサブエージェントがまだ作業中の間、パネルに留まるため、トランスクリプトを確認したり、さらに作業を割り当てたりするために選択できます。パネル内のすべてのエージェントがアイドル状態になると、アイドル行は 30 秒後に非表示になり、チームメンバーの次のターンで再表示されます。チームメンバーは非表示中も実行中で対応可能な状態が続きます。v2.1.181 から v2.1.198 では、アイドル行は他のチームメンバーがまだ作業中であっても、独自のターンが終了してから 30 秒後に非表示になりました。v2.1.181 より前のバージョンではアイドル行は非表示になりません。
+v2.1.199 以降、アイドル状態のチームメンバーの行は、他のチームメンバーまたはサブエージェントがまだ作業中の間、パネルに留まるため、トランスクリプトを確認したり、さらに作業を割り当てたりするために選択できます。パネル内のすべてのエージェントがアイドル状態になると、アイドル行は 30 秒後に非表示になり、チームメンバーの次のターンで再表示されます。チームメンバーは非表示中も実行中で対応可能な状態が続きます。v2.1.181 から v2.1.198 では、アイドル行は他のチームメンバーがまだ作業中であっても、独自のターンが終了してから 30 秒後に非表示になりました。v2.1.181 より前のバージョンではアイドル行は非表示になりません。
 
 3 人以上のチームメンバーが同時にアイドル状態の場合、最初の 3 行を超える行は、折りたたまれたチームメンバーをカウントする単一の行に折りたたまれます。例えば、5 人がアイドル状態の場合は `2 idle agents` のようになります。それを選択して Enter キーを押すと折りたたまれた行が展開され、Esc キーを押すと再び折りたたまれます。作業中のチームメンバー、失敗したチームメンバー、および表示中のチームメンバーは常に独自の行を保持します。
@@ -117,5 +117,5 @@ one on UX, one on technical architecture, one playing devil's advocate.
 デフォルトは `"in-process"` です。v2.1.179 より前は、デフォルトは `"auto"` でした。そのため、以前に分割ペインを開いたアップグレードされたセッションは、モードを明示的に設定しない限り、1 つのターミナルに留まります。`"auto"` を設定して、既に tmux セッション内で実行している場合または使用しているターミナルが iTerm2 の場合は分割ペインを有効にし、それ以外の場合は in-process にフォールバックします。`"tmux"` 設定は分割ペインモードを有効にし、ターミナルに基づいて tmux または iTerm2 を使用するかどうかを自動検出します。
 
-{/* min-version: 2.1.186 */}v2.1.186 以降、`"iterm2"` を設定して iTerm2 ネイティブ分割ペインを明示的に使用してください。このモードは [`it2` CLI](https://github.com/mkusaka/it2) が必要で、`it2` が見つからない場合はインストールコマンド付きでエラーを表示します。`it2` をインストールするか tmux に切り替えるオプションを提供するセットアッププロンプトは、ターミナルが iTerm2 で tmux がフォールバックとして利用可能な場合、`"auto"` または `"tmux"` の下に表示されます。
+v2.1.186 以降、`"iterm2"` を設定して iTerm2 ネイティブ分割ペインを明示的に使用してください。このモードは [`it2` CLI](https://github.com/mkusaka/it2) が必要で、`it2` が見つからない場合はインストールコマンド付きでエラーを表示します。`it2` をインストールするか tmux に切り替えるオプションを提供するセットアッププロンプトは、ターミナルが iTerm2 で tmux がフォールバックとして利用可能な場合、`"auto"` または `"tmux"` の下に表示されます。
 
 オーバーライドするには、`~/.claude/settings.json` で [`teammateMode`](/docs/ja/settings#available-settings) を設定してください。
@@ -151,5 +151,5 @@ each teammate.
 チームメンバーはデフォルトではリーダーの `/model` 選択を継承しません。プロンプトで指定されていない場合に使用されるモデルを変更するには、`/config` で **Default teammate model** を設定してください。チームメンバーがリーダーの現在のモデルに従うようにするには、**Default (leader's model)** を選択してください。
 
-{/* min-version: 2.1.186 */}チームメンバーはリーダーの[努力レベル](/docs/ja/model-config#adjust-effort-level)を継承します。分割ペインモードではこれは v2.1.186 から適用されます。それより前のバージョンではリーダーのセッション努力を分割ペインチームメンバーに渡しませんでした。
+チームメンバーはリーダーの[努力レベル](/docs/ja/model-config#adjust-effort-level)を継承します。分割ペインモードではこれは v2.1.186 から適用されます。それより前のバージョンではリーダーのセッション努力を分割ペインチームメンバーに渡しませんでした。
 
 <h3 id="require-plan-approval-for-teammates">
@@ -179,5 +179,5 @@ Require plan approval before they make any changes.
 In-process チームメンバーを表示している間、プレーンテキストと [skills](/docs/ja/skills) はそのチームメンバーに送信されますが、組み込みコマンドはリーダーのセッションで実行されます。
 
-チームメンバーのモデルと高速モードはそれが生成されるときに固定されるため、`/model` と `/fast` はリーダーの設定のみを変更します。{/* min-version: 2.1.199 */}v2.1.199 以降、チームメンバーを表示している間にいずれかのコマンドを入力すると、変更がリーダーに適用されることを示す通知が表示されます。それより前のバージョンでは、指示なしでリーダーに適用されました。`/effort` はチームメンバーの後続のターンに適用されます。これはチームメンバーがリーダーの[努力レベル](/docs/ja/model-config#adjust-effort-level)に従うためです。
+チームメンバーのモデルと高速モードはそれが生成されるときに固定されるため、`/model` と `/fast` はリーダーの設定のみを変更します。v2.1.199 以降、チームメンバーを表示している間にいずれかのコマンドを入力すると、変更がリーダーに適用されることを示す通知が表示されます。それより前のバージョンでは、指示なしでリーダーに適用されました。`/effort` はチームメンバーの後続のターンに適用されます。これはチームメンバーがリーダーの[努力レベル](/docs/ja/model-config#adjust-effort-level)に従うためです。
```

</details>

<details>
<summary>agent-view-ja.md</summary>

```diff
diff --git a/docs-ja/pages/agent-view-ja.md b/docs-ja/pages/agent-view-ja.md
index e7c7da8..0fed38a 100644
--- a/docs-ja/pages/agent-view-ja.md
+++ b/docs-ja/pages/agent-view-ja.md
@@ -71,5 +71,5 @@ Claude が複数の独立したタスクに対して、あなたが毎ステッ
 `claude agents` を `claude` の代わりにプライマリエントリーポイントとして使用できます。エージェントビューからすべてのタスクをディスパッチし、フル会話が必要な場合はアタッチし、`←` を押してテーブルに戻ります。
 
-{/* min-version: 2.1.205 */}通常の `claude` セッション内では、プロンプトフッターの `←` ヒントは、`← 2 agents` のように入力を待機中のバックグラウンドエージェントの数をカウントし、入力が必要なエージェントがない場合は `← for agents` に戻ります。99 を超えるカウントは `99+` として表示されます。カウントはターミナルがフォーカスされている間は約 10 秒ごとに更新され、フォーカスが戻ると即座に更新されます。カウントが移動したときとエージェントが完了したときに色が一時的に変わります。ただし、[`prefersReducedMotion` 設定](/docs/ja/settings#available-settings)がオンの場合は除きます。また、[スクリーンリーダーモード](/docs/ja/accessibility)では非表示になります。[Amazon Bedrock、Google Cloud の Agent Platform、Microsoft Foundry](/docs/ja/third-party-integrations)では、ヒントはカウントなしの通常の `← for agents` 形式のままです。Claude Code v2.1.205 以降が必要です。
+通常の `claude` セッション内では、プロンプトフッターの `←` ヒントは、`← 2 agents` のように入力を待機中のバックグラウンドエージェントの数をカウントし、入力が必要なエージェントがない場合は `← for agents` に戻ります。99 を超えるカウントは `99+` として表示されます。カウントはターミナルがフォーカスされている間は約 10 秒ごとに更新され、フォーカスが戻ると即座に更新されます。カウントが移動したときとエージェントが完了したときに色が一時的に変わります。ただし、[`prefersReducedMotion` 設定](/docs/ja/settings#available-settings)がオンの場合は除きます。また、[スクリーンリーダーモード](/docs/ja/accessibility)では非表示になります。[Amazon Bedrock、Google Cloud の Agent Platform、Microsoft Foundry](/docs/ja/third-party-integrations)では、ヒントはカウントなしの通常の `← for agents` 形式のままです。Claude Code v2.1.205 以降が必要です。
 
 <h2 id="monitor-sessions-with-agent-view">
@@ -79,5 +79,5 @@ Claude が複数の独立したタスクに対して、あなたが毎ステッ
 `claude agents` を実行してエージェントビューを開きます。ターミナル全体を占有し、状態でグループ化されたすべてのセッションをリストします。ピン留めされたセッションと入力が必要なセッションが上部に表示されます。各行はセッションの名前、現在のアクティビティ、およびセッションが作成されてからの経過時間を表示します。完了したセッションの経過時間は、実行にかかった時間で固定されます。
 
-名前は、そのセッションで [`/color`](/docs/ja/commands) によって設定されたカラーで色付けされます。{/* min-version: 2.1.199 */}v2.1.199 以降、`←` または `/background` で [セッションをバックグラウンドにする](#from-inside-a-session) ときにカラーが引き継がれます。
+名前は、そのセッションで [`/color`](/docs/ja/commands) によって設定されたカラーで色付けされます。v2.1.199 以降、`←` または `/background` で [セッションをバックグラウンドにする](#from-inside-a-session) ときにカラーが引き継がれます。
 
 デフォルトでは、リストはすべてのプロジェクト全体で開始したすべてのバックグラウンドセッションを表示します。1 つのリポジトリで作業しているセッションと別のワークツリーで作業している別のセッションの両方がここに表示されます。エージェントビューを開いたディレクトリに関係なく表示されます。リストを 1 つのプロジェクトに絞り込むには、`--cwd` を渡します：
@@ -235,5 +235,5 @@ v2.1.207 より前では、すべてのピークはステータス文と裸の
 10 秒の制限は [subagents](/docs/ja/sub-agents) が実行されている間は適用されません。Claude Code は待機を続けるため、それらの作業が引き継がれ、待機中に `Still backgrounding after the current tool` 通知が表示されます。代わりに待機せずにすぐにバックグラウンドにするには、`←` を再度押します。これにより subagents が最初から再開されます。v2.1.203 より前では、待機は 10 秒後に終了し、実行中の subagents は警告なしに最初から再開されました。
 
-行は会話履歴がない新しいセッションからでも作成されるため、`→` はそれに戻ります。{/* max-version: 2.1.202 */}v2.1.203 より前では、エージェントビューはその行が唯一の行である場合、その下にオンボーディングヒントを表示していました。
+行は会話履歴がない新しいセッションからでも作成されるため、`→` はそれに戻ります。v2.1.203 より前では、エージェントビューはその行が唯一の行である場合、その下にオンボーディングヒントを表示していました。
 
 このショートカットは `/config` の `leftArrowOpensAgents` 設定でオフにできます。
@@ -318,5 +318,5 @@ v2.1.207 より前では、すべてのピークはステータス文と裸の
 プロンプトに画像を貼り付けて、タスクにスクリーンショットまたは図を含めます。
 
-800 文字を超えるか 2 行以上の貼り付けられたテキストは `[Pasted text #N]` プレースホルダーに折りたたまれるため、入力は 1 行のままです。ディスパッチするときに完全なテキストが送信されます。{/* min-version: 2.1.207 */}ディスパッチする前に折りたたまれたテキストを確認または編集するには、同じテキストを再度貼り付けると、プレースホルダーが入力に展開されます。少なくとも 90 列幅のターミナルでは、貼り付け後数秒間、入力の下に `paste again to expand` リマインダーが表示されます。v2.1.207 より前は、同じテキストを再度貼り付けると、最初のプレースホルダーを展開する代わりに 2 番目のプレースホルダーが追加されていました。
+800 文字を超えるか 2 行以上の貼り付けられたテキストは `[Pasted text #N]` プレースホルダーに折りたたまれるため、入力は 1 行のままです。ディスパッチするときに完全なテキストが送信されます。ディスパッチする前に折りたたまれたテキストを確認または編集するには、同じテキストを再度貼り付けると、プレースホルダーが入力に展開されます。少なくとも 90 列幅のターミナルでは、貼り付け後数秒間、入力の下に `paste again to expand` リマインダーが表示されます。v2.1.207 より前は、同じテキストを再度貼り付けると、最初のプレースホルダーを展開する代わりに 2 番目のプレースホルダーが追加されていました。
```

</details>

<details>
<summary>agents-ja.md</summary>

```diff
diff --git a/docs-ja/pages/agents-ja.md b/docs-ja/pages/agents-ja.md
index d4b308a..929a33a 100644
--- a/docs-ja/pages/agents-ja.md
+++ b/docs-ja/pages/agents-ja.md
@@ -54,5 +54,5 @@
 
 * バックグラウンドセッションの場合、`claude agents` は [エージェントビュー](/docs/ja/agent-view) を開きます。すべてのセッション、その状態、および入力が必要なセッションを表示する 1 つの画面です。
-* 現在のセッション内のサブエージェントの場合、名前付きバックグラウンドサブエージェントは @-メンション入力補完に状態とともに表示されます。{/* min-version: 2.1.198 */}v2.1.198 以降、`/agents` はパネルを開かなくなり、サブエージェントファイルの場所を指すお知らせを出力します。[カスタムサブエージェントを作成および編集](/docs/ja/sub-agents#configure-subagents) するには、Claude に質問するか、ファイルを直接編集してください。名前は似ていますが、`/agents` は `claude agents` とは別です。
+* 現在のセッション内のサブエージェントの場合、名前付きバックグラウンドサブエージェントは @-メンション入力補完に状態とともに表示されます。v2.1.198 以降、`/agents` はパネルを開かなくなり、サブエージェントファイルの場所を指すお知らせを出力します。[カスタムサブエージェントを作成および編集](/docs/ja/sub-agents#configure-subagents) するには、Claude に質問するか、ファイルを直接編集してください。名前は似ていますが、`/agents` は `claude agents` とは別です。
 * 現在のセッションのバックグラウンドで実行されているもの場合、`/tasks` は各項目をリストし、確認、アタッチ、または停止できます。リストには完了したサブエージェントも含まれます。
 * 動的ワークフローの場合、`/workflows` は実行中および完了した実行、各実行がある段階、および完了したエージェント数をリストします。
```

</details>

<details>
<summary>amazon-bedrock-ja.md</summary>

```diff
diff --git a/docs-ja/pages/amazon-bedrock-ja.md b/docs-ja/pages/amazon-bedrock-ja.md
index a9d7bb2..71a1b00 100644
--- a/docs-ja/pages/amazon-bedrock-ja.md
+++ b/docs-ja/pages/amazon-bedrock-ja.md
@@ -163,5 +163,5 @@ export AWS_PROFILE=your-profile-name
 ```
 
-Claude Code は、IAM Identity Center リージョンから役割認証情報をリクエストします。このリージョンはプロファイルの `sso_region` で指定されており、Amazon Bedrock を実行するリージョンと一致する必要はありません。{/* min-version: 2.1.208 */}v2.1.207 では、Amazon Bedrock リージョンが `sso_region` をオーバーライドしていたため、IAM Identity Center インスタンスが別のリージョンにあるプロファイルは `Session token not found or invalid` エラーで認証に失敗しました。
+Claude Code は、IAM Identity Center リージョンから役割認証情報をリクエストします。このリージョンはプロファイルの `sso_region` で指定されており、Amazon Bedrock を実行するリージョンと一致する必要はありません。v2.1.207 では、Amazon Bedrock リージョンが `sso_region` をオーバーライドしていたため、IAM Identity Center インスタンスが別のリージョンにあるプロファイルは `Session token not found or invalid` エラーで認証に失敗しました。
 
 **オプション D：AWS Management Console 認証情報**
@@ -187,9 +187,9 @@ Amazon Bedrock API キーは、完全な AWS 認証情報を必要としない
 Claude Code は AWS デフォルト認証情報プロバイダーチェーンを 1 回解決し、解決された認証情報をメモリに保持します。有効期限の 5 分前まで、または有効期限がない場合は 1 時間の間、それらを再利用するため、SSO バックアップ プロファイルは IAM Identity Center から認証情報を約 1 回リクエストします。API からの認証情報エラーはキャッシュをクリアし、再試行は新しい認証情報を解決します。
 
-{/* min-version: 2.1.207 */}v2.1.207 より前では、Claude Code は API リクエストのたびにチェーンを解決していたため、SSO バックアップ プロファイルは毎回 IAM Identity Center から新しい認証情報をリクエストでき、大規模なデプロイメントでスロットルされる可能性がありました。
+v2.1.207 より前では、Claude Code は API リクエストのたびにチェーンを解決していたため、SSO バックアップ プロファイルは毎回 IAM Identity Center から新しい認証情報をリクエストでき、大規模なデプロイメントでスロットルされる可能性がありました。
 
 キャッシュは上記のすべての認証情報オプションをカバーしていますが、Amazon Bedrock API キーはプロバイダーチェーンを使用しないため除外されます。代わりにすべてのリクエストでチェーンを解決するには、[`CLAUDE_CODE_SKIP_AWS_CRED_CACHE=1`](/docs/ja/env-vars) を設定してください。
 
-{/* min-version: 2.1.207 */}チェーンの各解決は 60 秒後にタイムアウトします。チェーン内のステップが停止した場合、例えば受け取ることができない入力を待つ `credential_process` ヘルパーの場合、リクエストは [`AWS default-chain credential resolve timed out`](/docs/ja/errors#aws-default-chain-credential-resolve-timed-out) で失敗します。チェーンが `aws-vault` などのラッパーを通じた MFA を使用したブラウザベースの SSO など、正当に長い時間が必要な対話的サインインを実行する場合は、[`CLAUDE_CODE_AWS_CHAIN_RESOLVE_TIMEOUT_MS`](/docs/ja/env-vars) でミリ秒単位で制限を上げてください。v2.1.207 より前では、停止した認証情報解決はリクエストを無期限に待機させていました。
+チェーンの各解決は 60 秒後にタイムアウトします。チェーン内のステップが停止した場合、例えば受け取ることができない入力を待つ `credential_process` ヘルパーの場合、リクエストは [`AWS default-chain credential resolve timed out`](/docs/ja/errors#aws-default-chain-credential-resolve-timed-out) で失敗します。チェーンが `aws-vault` などのラッパーを通じた MFA を使用したブラウザベースの SSO など、正当に長い時間が必要な対話的サインインを実行する場合は、[`CLAUDE_CODE_AWS_CHAIN_RESOLVE_TIMEOUT_MS`](/docs/ja/env-vars) でミリ秒単位で制限を上げてください。v2.1.207 より前では、停止した認証情報解決はリクエストを無期限に待機させていました。
 
 <h4 id="advanced-credential-configuration">
@@ -236,7 +236,7 @@ Claude Code は、AWS SSO および企業 ID プロバイダーの自動認証
 ```
 
-{/* min-version: 2.1.181 */}`aws configure export-credentials --format process` からのフラット出力も受け入れられます。`Credentials` の下にネストされるのではなく、同じキーがトップレベルにあります。
+`aws configure export-credentials --format process` からのフラット出力も受け入れられます。`Credentials` の下にネストされるのではなく、同じキーがトップレベルにあります。
 
-`Expiration` はオプションです。{/* min-version: 2.1.176 */}Claude Code v2.1.176 以降では、コマンドが有効な ISO 8601 `Expiration` を返す場合、Claude Code はその時刻の 5 分前までの認証情報をキャッシュします。それがない場合、または以前のバージョンでは、認証情報は 1 時間キャッシュされます。
```

</details>

<details>
<summary>artifacts-ja.md</summary>

```diff
diff --git a/docs-ja/pages/artifacts-ja.md b/docs-ja/pages/artifacts-ja.md
index 1fa0a3a..0585728 100644
--- a/docs-ja/pages/artifacts-ja.md
+++ b/docs-ja/pages/artifacts-ja.md
@@ -7,6 +7,4 @@
 > アーティファクトは Claude Code の作業をライブでインタラクティブなページに変え、claude.ai 上で非公開に保つか、組織と共有するか、公開リンクに公開できます。
 
-{/* plan-availability: feature=artifacts plans=pro,max,team,enterprise providers=anthropic */}
-
 <Note>
   アーティファクトは Pro、Max、Team、および Enterprise プランで利用でき、[`/login`](/docs/ja/setup#authenticate) でサインインしたセッションが必要です。要件の完全なセットについては、[利用可能性](#availability)を参照してください。
@@ -105,6 +103,4 @@ https://claude.ai/code/artifact/5fbea6f3-... を今日の数字で更新して
 </h2>
 
-{/* plan-availability: feature=artifact-mcp plans=pro,max,team,enterprise providers=anthropic */}
-
 アーティファクトは、ページを表示するたびに [MCP コネクタ](/docs/ja/mcp#use-mcp-servers-from-claude-ai) を呼び出すことができるため、ページはセッションで構築されたスナップショットではなく、現在のデータを表示します。アーティファクトからのコネクタ呼び出しは Pro、Max、Team、Enterprise プランで利用可能であり、Claude Code v2.1.209 以降が必要です。以前のバージョンでは、Claude はセッション中に収集されたデータでページを公開します。
 
```

</details>

*...以降省略*

</details>


<details>
<summary>2026-08-04</summary>

**変更ファイル:**

```
 docs-ja/pages/changelog.md                | 42 +++++++++++++++++++++++++++++++
 docs-ja/pages/desktop-ios-simulator-en.md | 17 +++++++++++--
 2 files changed, 57 insertions(+), 2 deletions(-)
```

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index 7ca26b5..389a1ae 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,46 @@
 # Changelog
 
+## 2.1.221
+
+- [VSCode] Added Focus view: a chat-menu toggle that hides tool activity behind an expandable per-turn summary with a live running-tool indicator, toggled with `Ctrl+Alt+F` or the "Claude Code: Toggle Focus view" command
+- Added `mode: "mask"` for sandbox credential files on Linux and WSL — sandboxed commands read a sentinel copy (the whole file, or just the spans captured by an `extract` regex) while the sandbox proxy substitutes the real value on egress; on macOS file masking falls back to `deny`
+- Added warnings to `claude plugin validate` when a marketplace or plugin name would be rejected by Claude Desktop's managed marketplace sync
+- Added a `prompt-audit` subcommand to the `claude-api` skill for auditing prompts and tool descriptions for patterns written for older models
+- Fixed a Bash tool permission-check bypass where zsh could execute hidden commands in `[[ ]]` regex conditionals; affected commands now prompt for permission
+- Fixed PowerShell permission checks mishandling paths containing quote characters on Windows; such paths now prompt for approval
+- Fixed the thinking toggle having no effect for the rest of a session that started with thinking off; disabling an MCP server mid-connect no longer silently reverts
+- Fixed MCP servers from `--mcp-config` not being connected before the first turn in print mode (`-p`), which made the model emit tool calls as literal text
+- Fixed @-mentioned files being silently dropped when pressing Esc to retract a prompt and resubmitting it
+- Fixed a crash when preparing API requests for SDK MCP tools named after built-in object properties such as `constructor`
+- Fixed WebSearch failing with a 400 error at effort `xhigh`/`max` when thinking is disabled
+- Fixed sandboxed large uploads failing with TLS errors through the sandbox proxy
+- Fixed Team and Enterprise spend-limit message incorrectly blaming the org's monthly limit instead of your individual spend limit
+- Fixed Bedrock authentication with AWS SSO named profiles failing in desktop-managed sessions on Windows machines that set a stray `HOME` environment variable
+- Fixed `CLAUDE_CODE_RESUME_INTERRUPTED_TURN=0` not disabling interrupted-turn auto-resume; falsy values are now honored
+- Fixed a rare wake-from-sleep race where two Claude Code processes could both refresh the same MCP connector or WIF OAuth token at once, forcing re-authentication
+- Fixed renaming a session from Claude Code Desktop or claude.ai not updating the CLI's session name; session names from every rename surface are now sanitized
+- Fixed plugin- and org-delivered skills named after terminal-only built-ins (e.g. `/help`, `/feedback`) being un-invocable in non-interactive sessions
+- Fixed the "Plugins changed" notification lingering after plugins were reloaded instead of clearing
+- Fixed Vim mode: the yank register now survives dialogs, history search, and the transcript view instead of being silently emptied
+- Fixed Vim mode: undoing back to an empty prompt now arms the "press ← again" confirm before returning to the agent view
```

</details>

<details>
<summary>desktop-ios-simulator-en.md</summary>

```diff
diff --git a/docs-ja/pages/desktop-ios-simulator-en.md b/docs-ja/pages/desktop-ios-simulator-en.md
index 643eb5d..e662a3d 100644
--- a/docs-ja/pages/desktop-ios-simulator-en.md
+++ b/docs-ja/pages/desktop-ios-simulator-en.md
@@ -22,4 +22,5 @@ The simulator pane uses Apple's simulator tooling, which the desktop app doesn't
 * A Mac, since Apple's iOS Simulator runs only on macOS
 * [Xcode](https://developer.apple.com/xcode/) with the iOS platform installed, which provides the simulator devices. If Xcode lists no simulators yet, see [The simulator pane says no simulators were found](#the-simulator-pane-says-no-simulators-were-found)
+  * Use Xcode 26.x. The pane doesn't yet work with Xcode 27, which replaces the Simulator app with Device Hub. If `xcode-select` points at Xcode 27 on your Mac, see [The simulator pane fails with Xcode 27](#the-simulator-pane-fails-with-xcode-27)
 
 <Note>
@@ -119,5 +120,5 @@ Claude may not have recognized that you wanted to run or test the app, or the si
 
 * State the goal explicitly, for example "run the app in the iOS Simulator and tap through the signup flow".
-* Confirm Xcode and the iOS Simulator are installed by launching the Simulator app on its own.
+* Confirm Xcode and the iOS simulators are installed and that your Xcode version meets the [requirements](#requirements).
 * If your organization manages Claude Code, the [simulator tools may be disabled by policy](#turn-off-simulator-access).
 * The simulator pane requires Claude Desktop v1.24012.0 or later. Open **Claude → Check for Updates**, then restart the app.
@@ -125,5 +126,17 @@ Claude may not have recognized that you wanted to run or test the app, or the si
 ### The simulator pane says no simulators were found
 
-Xcode is installed but has no iOS simulators to list. The simulator pane shows the setup steps to follow and checks them off as each one completes. To install the missing piece manually, download the iOS simulator runtime from Xcode's settings, or run `xcodebuild -downloadPlatform iOS`.
+If `xcode-select` points at Xcode 27, the pane can report no simulators even though devices exist; see [The simulator pane fails with Xcode 27](#the-simulator-pane-fails-with-xcode-27). Otherwise, Xcode is installed but has no iOS simulators to list. The simulator pane shows the setup steps to follow and checks them off as each one completes. To install the missing piece manually, download the iOS simulator runtime from Xcode's settings, or run `xcodebuild -downloadPlatform iOS`.
+
+### The simulator pane fails with Xcode 27
+
+The pane doesn't yet work with Xcode 27, which replaces the Simulator app with Device Hub. With Xcode 27 selected, attaching a device fails, or the pane reports that no simulators were found even though devices exist.
+
+The pane uses whichever Xcode `xcode-select` points at. If Xcode 27 is your only install, install Xcode 26.x alongside it first. Then select the 26.x install by its path. For example, if it's installed as `/Applications/Xcode-26.4.app`:
+
+```bash theme={null}
```

</details>

</details>


<details>
<summary>2026-08-03</summary>

**変更ファイル:**

```
 docs-ja/pages/hooks-guide-ja.md       | 1 +
 docs-ja/pages/hooks-ja.md             | 3 ++-
 docs-ja/pages/plugins-reference-ja.md | 1 +
 3 files changed, 4 insertions(+), 1 deletion(-)
```

<details>
<summary>hooks-guide-ja.md</summary>

```diff
diff --git a/docs-ja/pages/hooks-guide-ja.md b/docs-ja/pages/hooks-guide-ja.md
index d56587d..ec8b480 100644
--- a/docs-ja/pages/hooks-guide-ja.md
+++ b/docs-ja/pages/hooks-guide-ja.md
@@ -483,4 +483,5 @@ Hook イベントは Claude Code のライフサイクルの特定のポイン
 | `ConfigChange`        | When a configuration file changes during a session                                                                                                     |
 | `CwdChanged`          | When the working directory changes, for example when Claude executes a `cd` command. Useful for reactive environment management with tools like direnv |
+| `DirectoryAdded`      | When a working directory is added mid-session via `/add-dir` or the SDK `register_repo_root` control request                                           |
 | `FileChanged`         | When a watched file changes on disk. The `matcher` field specifies which filenames to watch                                                            |
 | `WorktreeCreate`      | When a worktree is being created via `--worktree`, `isolation: "worktree"`, or for a background session. Replaces default git behavior                 |
```

</details>

<details>
<summary>hooks-ja.md</summary>

```diff
diff --git a/docs-ja/pages/hooks-ja.md b/docs-ja/pages/hooks-ja.md
index b71be52..35d4643 100644
--- a/docs-ja/pages/hooks-ja.md
+++ b/docs-ja/pages/hooks-ja.md
@@ -27,5 +27,5 @@
 <div style={{maxWidth: "500px", margin: "0 auto"}}>
   <Frame>
-    <img src="https://mintcdn.com/claude-code/uLsR38F1U_5zPppm/images/hooks-lifecycle.svg?fit=max&auto=format&n=uLsR38F1U_5zPppm&q=85&s=fbdbd78ad9f474da7d344879341341f0" alt="オプションの Setup から SessionStart に流れ込み、その後、UserPromptSubmit、スラッシュ コマンド用の UserPromptExpansion、ネストされた agentic ループ（PreToolUse、PermissionRequest、PostToolUse、PostToolUseFailure、PostToolBatch、SubagentStart/Stop、TaskCreated、TaskCompleted）、Stop または StopFailure を含むターンごとのループ、その後 TeammateIdle、PreCompact、PostCompact、SessionEnd が続き、Elicitation と ElicitationResult は MCP ツール実行内にネストされ、PermissionDenied は PermissionRequest からの副分岐として自動モード拒否のため、WorktreeCreate、WorktreeRemove、Notification、ConfigChange、InstructionsLoaded、CwdChanged、FileChanged はスタンドアロン非同期イベントとして表示されるフック ライフサイクル図" width="520" height="1228" data-path="images/hooks-lifecycle.svg" />
+    <img src="https://mintcdn.com/claude-code/jhXrDR5TrSZ5hgXM/images/hooks-lifecycle.svg?fit=max&auto=format&n=jhXrDR5TrSZ5hgXM&q=85&s=3ca47113d5956460e6e4611b8dbc63b7" alt="オプションの Setup から SessionStart に流れ込み、その後、UserPromptSubmit、スラッシュ コマンド用の UserPromptExpansion、ネストされた agentic ループ（PreToolUse、PermissionRequest、PostToolUse、PostToolUseFailure、PostToolBatch、SubagentStart/Stop、TaskCreated、TaskCompleted）、Stop または StopFailure を含むターンごとのループ、その後 TeammateIdle、PreCompact、PostCompact、SessionEnd が続き、Elicitation と ElicitationResult は MCP ツール実行内にネストされ、PermissionDenied は PermissionRequest からの副分岐として自動モード拒否のため、WorktreeCreate、WorktreeRemove、Notification、ConfigChange、InstructionsLoaded、CwdChanged、FileChanged はスタンドアロン非同期イベントとして表示されるフック ライフサイクル図" width="520" height="1228" data-path="images/hooks-lifecycle.svg" />
   </Frame>
 </div>
@@ -57,4 +57,5 @@
 | `ConfigChange`        | When a configuration file changes during a session                                                                                                     |
 | `CwdChanged`          | When the working directory changes, for example when Claude executes a `cd` command. Useful for reactive environment management with tools like direnv |
+| `DirectoryAdded`      | When a working directory is added mid-session via `/add-dir` or the SDK `register_repo_root` control request                                           |
 | `FileChanged`         | When a watched file changes on disk. The `matcher` field specifies which filenames to watch                                                            |
 | `WorktreeCreate`      | When a worktree is being created via `--worktree`, `isolation: "worktree"`, or for a background session. Replaces default git behavior                 |
```

</details>

<details>
<summary>plugins-reference-ja.md</summary>

```diff
diff --git a/docs-ja/pages/plugins-reference-ja.md b/docs-ja/pages/plugins-reference-ja.md
index 4cb1e94..5ea7ddc 100644
--- a/docs-ja/pages/plugins-reference-ja.md
+++ b/docs-ja/pages/plugins-reference-ja.md
@@ -143,4 +143,5 @@ disallowedTools: Write, Edit
 | `ConfigChange`        | When a configuration file changes during a session                                                                                                     |
 | `CwdChanged`          | When the working directory changes, for example when Claude executes a `cd` command. Useful for reactive environment management with tools like direnv |
+| `DirectoryAdded`      | When a working directory is added mid-session via `/add-dir` or the SDK `register_repo_root` control request                                           |
 | `FileChanged`         | When a watched file changes on disk. The `matcher` field specifies which filenames to watch                                                            |
 | `WorktreeCreate`      | When a worktree is being created via `--worktree`, `isolation: "worktree"`, or for a background session. Replaces default git behavior                 |
```

</details>

</details>


<details>
<summary>2026-07-30</summary>

**変更ファイル:**

```
 docs-ja/pages/devcontainer-ja.md   | 2 +-
 docs-ja/pages/prompt-caching-ja.md | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)
```

**新規追加:**


<details>
<summary>devcontainer-ja.md</summary>

```diff
diff --git a/docs-ja/pages/devcontainer-ja.md b/docs-ja/pages/devcontainer-ja.md
index 7b8062e..e354b12 100644
--- a/docs-ja/pages/devcontainer-ja.md
+++ b/docs-ja/pages/devcontainer-ja.md
@@ -21,5 +21,5 @@
   <img src="https://mintcdn.com/claude-code/YvJyjZfd9yMihr0i/images/devcontainer-architecture.svg?fit=max&auto=format&n=YvJyjZfd9yMihr0i&q=85&s=9017b1d16a446c6cc37ba562f35b9aae" className="dark:hidden" alt="ホスト上のエディタが Docker 開発コンテナに接続する図。Claude Code、ターミナル、ビルドツールはコンテナ内で実行されます。ホストリポジトリはコンテナにバインドマウントされ、ワークスペースとして機能します。" width="640" height="300" data-path="images/devcontainer-architecture.svg" />
 
-  <img src="https://mintcdn.com/claude-code/YvJyjZfd9yMihr0i/images/devcontainer-architecture-dark.svg?fit=max&auto=format&n=YvJyjZfd9yMihr0i&q=85&s=ef00c8e25b1ea7a3a152895f1488831b" className="hidden dark:block" alt="ホスト上のエディタが Docker 開発コンテナに接続する図。Claude Code、ターミナル、ビルドツールはコンテナ内で実行されます。ホストリポジトリはコンテナにバインドマウントされ、ワークスペースとして機能します。" width="640" height="300" data-path="images/devcontainer-architecture-dark.svg" />
+  <img src="https://mintcdn.com/claude-code/_xqph1dUOslCOwsj/images/devcontainer-architecture-dark.svg?fit=max&auto=format&n=_xqph1dUOslCOwsj&q=85&s=a0a340b1f2afc6a590696102c8acaaca" className="hidden dark:block" alt="ホスト上のエディタが Docker 開発コンテナに接続する図。Claude Code、ターミナル、ビルドツールはコンテナ内で実行されます。ホストリポジトリはコンテナにバインドマウントされ、ワークスペースとして機能します。" width="640" height="300" data-path="images/devcontainer-architecture-dark.svg" />
 
   開発コンテナは Docker コンテナとして実行され、マシン上または GitHub Codespaces などのクラウドホスト上で実行されます。Dev Containers 仕様をサポートするエディタ（VS Code、GitHub Codespaces、JetBrains IDE、Cursor など）がそのコンテナに接続します。通常どおりエディタでファイルを参照および編集しますが、統合ターミナル、言語サーバー、ビルドツールはすべてホストではなくコンテナ内で実行されます。プレーン Vim などの開発コンテナをサポートしていないエディタはこのワークフローの対象外です。
```

</details>

<details>
<summary>prompt-caching-ja.md</summary>

```diff
diff --git a/docs-ja/pages/prompt-caching-ja.md b/docs-ja/pages/prompt-caching-ja.md
index 3fb3401..262aef4 100644
--- a/docs-ja/pages/prompt-caching-ja.md
+++ b/docs-ja/pages/prompt-caching-ja.md
@@ -21,5 +21,5 @@ API は、プリフィックスと呼ばれる各リクエストの開始を、
 <img src="https://mintcdn.com/claude-code/VbDJw--l6T9a9Wvm/images/prompt-caching-prefix.svg?fit=max&auto=format&n=VbDJw--l6T9a9Wvm&q=85&s=f2e8f0b8298a50305fe428ca3f1d1594" className="dark:hidden" alt="4 つのターンが成長する水平バーとして表示されます。各ターンのリクエストには、前のターンのすべてと最新の交換が最後に追加されたものが含まれます。ターン 2 と 3 では、変更されていないプリフィックスはキャッシュから読み取られ、新しい交換のみが処理されます。ターン 4 では、システムプロンプトが変更されたため、プリフィックスは一致しなくなり、リクエスト全体が再処理されて書き込まれます。" width="720" height="454" data-path="images/prompt-caching-prefix.svg" />
 
-<img src="https://mintcdn.com/claude-code/VbDJw--l6T9a9Wvm/images/prompt-caching-prefix-dark.svg?fit=max&auto=format&n=VbDJw--l6T9a9Wvm&q=85&s=7434a04e08187edd26ec6c3dd332f624" className="hidden dark:block" alt="4 つのターンが成長する水平バーとして表示されます。各ターンのリクエストには、前のターンのすべてと最新の交換が最後に追加されたものが含まれます。ターン 2 と 3 では、変更されていないプリフィックスはキャッシュから読み取られ、新しい交換のみが処理されます。ターン 4 では、システムプロンプトが変更されたため、プリフィックスは一致しなくなり、リクエスト全体が再処理されて書き込まれます。" width="720" height="454" data-path="images/prompt-caching-prefix-dark.svg" />
+<img src="https://mintcdn.com/claude-code/_xqph1dUOslCOwsj/images/prompt-caching-prefix-dark.svg?fit=max&auto=format&n=_xqph1dUOslCOwsj&q=85&s=297dc1c639f0915cae858d0c4b6f3be5" className="hidden dark:block" alt="4 つのターンが成長する水平バーとして表示されます。各ターンのリクエストには、前のターンのすべてと最新の交換が最後に追加されたものが含まれます。ターン 2 と 3 では、変更されていないプリフィックスはキャッシュから読み取られ、新しい交換のみが処理されます。ターン 4 では、システムプロンプトが変更されたため、プリフィックスは一致しなくなり、リクエスト全体が再処理されて書き込まれます。" width="720" height="454" data-path="images/prompt-caching-prefix-dark.svg" />
 
 プリフィックスマッチングを最大限に活用するために、Claude Code は各リクエストを順序付けして、ターン間で変更されることがめったにないコンテンツが最初に来るようにします。
```

</details>

</details>


<details>
<summary>2026-07-29</summary>

**変更ファイル:**

```
 docs-ja/pages/claude-directory-ja.md  | 6 +++---
 docs-ja/pages/claude-security-en.md   | 7 ++++---
 docs-ja/pages/hooks-guide-ja.md       | 2 +-
 docs-ja/pages/hooks-ja.md             | 2 +-
 docs-ja/pages/mobile-en.md            | 5 +++--
 docs-ja/pages/plugins-reference-ja.md | 2 +-
 6 files changed, 13 insertions(+), 11 deletions(-)
```

**新規追加:**


<details>
<summary>claude-directory-ja.md</summary>

```diff
diff --git a/docs-ja/pages/claude-directory-ja.md b/docs-ja/pages/claude-directory-ja.md
index 3f63d72..d4a46d5 100644
--- a/docs-ja/pages/claude-directory-ja.md
+++ b/docs-ja/pages/claude-directory-ja.md
@@ -103,5 +103,5 @@ config/secrets.json`,
         color: 'var(--ce-accent)',
         oneLiner: 'Project-level configuration, rules, and extensions',
-        description: 'Everything Claude Code reads that is specific to this project. If you use git, commit most files here so your team shares them; a few, like settings.local.json, are automatically gitignored. Each file badge shows which.',
+        description: 'Everything Claude Code reads that is specific to this project. If you use git, commit most files here so your team shares them; a few, like settings.local.json, are gitignored when Claude Code saves settings to them. Each file badge shows which.',
         children: [{
           id: 'settings-json',
@@ -147,6 +147,6 @@ config/secrets.json`,
           oneLiner: 'Your personal settings overrides for this project',
           when: 'Highest of the user-editable settings files; CLI flags and managed settings still take precedence',
-          description: 'Personal settings that take precedence over the project defaults. Same JSON format as settings.json, but not committed. Use this when you need different permissions or defaults than the team config.',
-          tips: [<>Same schema as settings.json. Array settings like <C>permissions.allow</C> combine across scopes; scalar settings like <C>model</C> use the local value</>, <>Claude Code adds this file to <C>~/.config/git/ignore</C> the first time it writes one. If you use a custom <C>core.excludesFile</C>, add the pattern there too. To share the ignore rule with your team, also add it to the project <C>.gitignore</C></>],
+          description: 'Personal settings that take precedence over the project defaults. Same JSON format as settings.json, gitignored when Claude Code saves a setting to it. Use this when you need different permissions or defaults than the team config.',
+          tips: [<>Same schema as settings.json. Array settings like <C>permissions.allow</C> combine across scopes; scalar settings like <C>model</C> use the local value</>, <>When Claude Code saves a setting to this file in a repository that doesn't already ignore it, it adds <C>**/.claude/settings.local.json</C> to your global git excludes file: <C>core.excludesFile</C> from your global git config when it's set to an absolute or <C>~</C>-prefixed path, otherwise <C>$XDG_CONFIG_HOME/git/ignore</C>, or <C>~/.config/git/ignore</C>. To share the ignore rule with your team, also add it to the project <C>.gitignore</C></>],
           exampleIntro: 'This example adds Docker permissions on top of whatever the team settings.json allows.',
           example: `{
```

</details>

<details>
<summary>claude-security-en.md</summary>

```diff
diff --git a/docs-ja/pages/claude-security-en.md b/docs-ja/pages/claude-security-en.md
index 911c523..f98988a 100644
--- a/docs-ja/pages/claude-security-en.md
+++ b/docs-ja/pages/claude-security-en.md
@@ -30,7 +30,8 @@ In a Claude Code session, install from the [official Anthropic marketplace](/doc
 ```
 
-<Note>
-  If Claude Code reports that the marketplace is not found, run `/plugin marketplace add anthropics/claude-plugins-official` first, then retry the install.
-</Note>
+If the install fails, the fix depends on which message Claude Code reports:
+
+* If it reports `Marketplace "claude-plugins-official" not found`, add the marketplace with `/plugin marketplace add anthropics/claude-plugins-official`, then retry the install.
+* If it reports that it can't find the plugin in the marketplace, check the plugin name for a typo, then refresh your local copy of the marketplace with `/plugin marketplace update claude-plugins-official` and retry the install.
 
 Then activate the plugin in the current session with `/reload-plugins`, which applies pending plugin changes without a restart:
```

</details>

<details>
<summary>hooks-guide-ja.md</summary>

```diff
diff --git a/docs-ja/pages/hooks-guide-ja.md b/docs-ja/pages/hooks-guide-ja.md
index d49c8ce..d56587d 100644
--- a/docs-ja/pages/hooks-guide-ja.md
+++ b/docs-ja/pages/hooks-guide-ja.md
@@ -466,5 +466,5 @@ Hook イベントは Claude Code のライフサイクルの特定のポイン
 | `UserPromptExpansion` | When a user-typed command expands into a prompt, before it reaches Claude. Can block the expansion                                                     |
 | `PreToolUse`          | Before a tool call executes. Can block it                                                                                                              |
-| `PermissionRequest`   | When a permission dialog appears                                                                                                                       |
+| `PermissionRequest`   | When a tool call needs a permission decision                                                                                                           |
 | `PermissionDenied`    | When a tool call is denied by the auto mode classifier. Return `{retry: true}` to tell the model it may retry the denied tool call                     |
 | `PostToolUse`         | After a tool call succeeds                                                                                                                             |
```

</details>

<details>
<summary>hooks-ja.md</summary>

```diff
diff --git a/docs-ja/pages/hooks-ja.md b/docs-ja/pages/hooks-ja.md
index ca87be6..b71be52 100644
--- a/docs-ja/pages/hooks-ja.md
+++ b/docs-ja/pages/hooks-ja.md
@@ -40,5 +40,5 @@
 | `UserPromptExpansion` | When a user-typed command expands into a prompt, before it reaches Claude. Can block the expansion                                                     |
 | `PreToolUse`          | Before a tool call executes. Can block it                                                                                                              |
-| `PermissionRequest`   | When a permission dialog appears                                                                                                                       |
+| `PermissionRequest`   | When a tool call needs a permission decision                                                                                                           |
 | `PermissionDenied`    | When a tool call is denied by the auto mode classifier. Return `{retry: true}` to tell the model it may retry the denied tool call                     |
 | `PostToolUse`         | After a tool call succeeds                                                                                                                             |
```

</details>

<details>
<summary>mobile-en.md</summary>

```diff
diff --git a/docs-ja/pages/mobile-en.md b/docs-ja/pages/mobile-en.md
index 02e18b2..627011e 100644
--- a/docs-ja/pages/mobile-en.md
+++ b/docs-ja/pages/mobile-en.md
@@ -53,5 +53,5 @@ Cloud sessions and Remote Control run from the **Code** tab and are covered belo
 Claude Code on the web runs tasks on Anthropic-managed cloud infrastructure, so a session continues after you put your phone away. From the Code tab, select a repository and branch, describe the task, and submit it. Sessions persist across devices: a task you start on your laptop is ready to review from your phone, and one you start from your phone is waiting when you're back at your desk.
 
-Open a session in the app to check progress, answer Claude's questions, or steer it in a new direction. You can also tell Claude to [watch a pull request](/docs/en/claude-code-on-the-web#auto-fix-pull-requests) and fix CI failures or review comments as they arrive. To connect GitHub and create your first environment, follow the [web quickstart](/docs/en/web-quickstart), and see [Claude Code on the web](/docs/en/claude-code-on-the-web) for everything cloud sessions can do.
+Open a session in the app to check progress, answer Claude's questions, or steer it in a new direction. You can also tell Claude to [watch a pull request](/docs/en/claude-code-on-the-web#auto-fix-pull-requests) and fix CI failures or review comments as they arrive. To connect GitHub and set up your environment, follow the [web quickstart](/docs/en/web-quickstart), and see [Claude Code on the web](/docs/en/claude-code-on-the-web) for everything cloud sessions can do.
 
 ### Continue a local session with Remote Control
@@ -78,5 +78,6 @@ The mobile client covers most of what a session needs, with a few limitations:
 
 * [Platforms and integrations](/docs/en/platforms): compare every surface Claude Code runs on
-* [Claude Code on the web](/docs/en/claude-code-on-the-web): how cloud sessions run, network access, and moving work to and from your terminal
+* [Claude Code on the web](/docs/en/claude-code-on-the-web): how cloud sessions run and how to move work to and from your terminal
+* [Configure cloud environments](/docs/en/cloud-environments): network access levels, environment variables, and setup scripts for cloud sessions
 * [Remote Control](/docs/en/remote-control): continue a local session from any device
 * [Sessions from Dispatch](/docs/en/desktop#sessions-from-dispatch): how Dispatch tasks become Code sessions in the Desktop app
```

</details>

<details>
<summary>plugins-reference-ja.md</summary>

```diff
diff --git a/docs-ja/pages/plugins-reference-ja.md b/docs-ja/pages/plugins-reference-ja.md
index 2db4760..4cb1e94 100644
--- a/docs-ja/pages/plugins-reference-ja.md
+++ b/docs-ja/pages/plugins-reference-ja.md
@@ -126,5 +126,5 @@ disallowedTools: Write, Edit
 | `UserPromptExpansion` | When a user-typed command expands into a prompt, before it reaches Claude. Can block the expansion                                                     |
 | `PreToolUse`          | Before a tool call executes. Can block it                                                                                                              |
-| `PermissionRequest`   | When a permission dialog appears                                                                                                                       |
+| `PermissionRequest`   | When a tool call needs a permission decision                                                                                                           |
 | `PermissionDenied`    | When a tool call is denied by the auto mode classifier. Return `{retry: true}` to tell the model it may retry the denied tool call                     |
 | `PostToolUse`         | After a tool call succeeds                                                                                                                             |
```

</details>

</details>


<details>
<summary>2026-07-26</summary>

**変更ファイル:**

```
 docs-ja/pages/changelog.md | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)
```

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index 97c4a8e..7ca26b5 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,8 @@
 # Changelog
 
+## 2.1.220
+
+- Bug fixes and reliability improvements
+
 ## 2.1.219
 
@@ -11,8 +15,5 @@
 - Fixed `claude -p` text output dropping the answer already produced when a turn dies on a mid-stream API error
 - Added HTTP status and error text to `claude mcp list` and `/mcp` when a server fails to connect, and a warning for MCP config values with hidden leading or trailing whitespace
-- Fixed a permission you approved while a self-hosted runner was restarting being dropped when the session resumed, so the approved action now runs
 - Fixed the Fable model row showing "Requires usage credits" for plans that include it, when a stale cache had baked the label in
-- Fixed a SIGTERM arriving while a self-hosted runner was starting up leaving a stale active row until the lease expired; it now deregisters cleanly
-- Added structured failure categories to self-hosted runner spawn and session failures, so hook errors, runner crashes and config errors can be told apart
 - Fixed the `/model` picker showing the merged Opus row as plain "Opus" instead of "Opus (1M context)"
 - Fixed copy-on-select inside GNU screen printing base64 into the terminal instead of copying the selection
@@ -954,5 +955,4 @@
 ## 2.1.169
 
-- Self-hosted runner: added a `post-session` lifecycle hook that runs after the session ends and before the workspace is deleted, so you can snapshot uncommitted work or export logs; also made the child-process SIGTERM→SIGKILL window configurable (default unchanged at 5s)
 - Added `--safe-mode` flag (and `CLAUDE_CODE_SAFE_MODE`) to start Claude Code with all customizations (CLAUDE.md, plugins, skills, hooks, MCP servers) disabled for troubleshooting
 - Added `/cd` command to move a session to a new working directory without breaking the prompt cache mid-session
```

</details>

</details>


<details>
<summary>2026-07-25</summary>

**変更ファイル:**

```
 docs-ja/pages/changelog.md                 | 31 +++++++++++++++++++++++++++++-
 docs-ja/pages/claude-code-on-the-web-ja.md |  2 --
 2 files changed, 30 insertions(+), 3 deletions(-)
```

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index 7b4d63a..97c4a8e 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,34 @@
 # Changelog
 
+## 2.1.219
+
+- Added Claude Opus 5 (`claude-opus-5`), now the default Opus model — 1M context, fast mode at $10/$50 per Mtok
+- Added `sandbox.network.strictAllowlist` setting to deny non-allowlisted hosts for sandboxed commands without prompting
+- Added `DirectoryAdded` hook that fires after `/add-dir` or the SDK `register_repo_root` control request registers a new working directory mid-session
+- Added `mcp_server_errors` to the headless stream-json init event, listing `--mcp-config` entries skipped by config validation; terminal runs print a startup warning
+- Added the `workflowSizeGuideline` settings key so the advisory Dynamic workflow size guideline can be set from any settings file; the `/config` row is hidden while one does
+- Added nested subagent forwarding in stream-json: subagents spawned at depth-2+ now appear when `--forward-subagent-text` is set, keyed by their spawning Agent `tool_use` id
+- Fixed `claude -p` text output dropping the answer already produced when a turn dies on a mid-stream API error
+- Added HTTP status and error text to `claude mcp list` and `/mcp` when a server fails to connect, and a warning for MCP config values with hidden leading or trailing whitespace
+- Fixed a permission you approved while a self-hosted runner was restarting being dropped when the session resumed, so the approved action now runs
+- Fixed the Fable model row showing "Requires usage credits" for plans that include it, when a stale cache had baked the label in
+- Fixed a SIGTERM arriving while a self-hosted runner was starting up leaving a stale active row until the lease expired; it now deregisters cleanly
+- Added structured failure categories to self-hosted runner spawn and session failures, so hook errors, runner crashes and config errors can be told apart
+- Fixed the `/model` picker showing the merged Opus row as plain "Opus" instead of "Opus (1M context)"
+- Fixed copy-on-select inside GNU screen printing base64 into the terminal instead of copying the selection
+- Fixed Remote Control clients keeping a stale fast-mode status after a model switch, reconnect, or failed org check
+- Fixed `CLAUDE_CODE_GIT_BASH_PATH` on Windows exiting or being used as bash when the path isn't a bash/sh binary; it's now ignored with a warning
+- Fixed Vim mode: pressing ← on an empty prompt now returns to the agent view from NORMAL mode, not just INSERT
+- Fixed screen-reader mode rewriting the entire input line on every keystroke instead of echoing only the typed character
+- Improved the "Remote Control is only available via api.anthropic.com" error to name the specific setting that caused it
+- Improved `claude --teleport` to show which repo your current checkout points at when it doesn't match the session's repo
+- Changed dynamic workflows to default to a medium size guideline (aim for fewer than 15 agents); pick another size or unrestricted with Dynamic workflow size in `/config`
```

</details>

<details>
<summary>claude-code-on-the-web-ja.md</summary>

```diff
diff --git a/docs-ja/pages/claude-code-on-the-web-ja.md b/docs-ja/pages/claude-code-on-the-web-ja.md
index ba9465b..a97e97e 100644
--- a/docs-ja/pages/claude-code-on-the-web-ja.md
+++ b/docs-ja/pages/claude-code-on-the-web-ja.md
@@ -215,6 +215,4 @@ Team および Enterprise プランのオーナーと管理者は、組織のす
 共有環境の値はその環境のすべてのメンバーのセッションに到達します。個人環境と同様に、共有環境には専用シークレットストアがないため、シークレットを含めないでください。
 
-セルフホストランナープログラムの組織は、同じページからランナープールも管理します。
-
 <h2 id="setup-scripts">
   セットアップスクリプト
```

</details>

</details>


<details>
<summary>2026-07-24</summary>

**変更ファイル:**

```
 docs-ja/pages/claude-security-en.md       | 2 ++
 docs-ja/pages/desktop-ios-simulator-en.md | 2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)
```

<details>
<summary>claude-security-en.md</summary>

```diff
diff --git a/docs-ja/pages/claude-security-en.md b/docs-ja/pages/claude-security-en.md
index 58b5b3b..911c523 100644
--- a/docs-ja/pages/claude-security-en.md
+++ b/docs-ja/pages/claude-security-en.md
@@ -135,4 +135,6 @@ The plugin doesn't replace your existing source-code security tools. Run it alon
 **The `/claude-security` menu opens with a Python warning.** The plugin needs `python3` 3.9.6 or later on your `PATH`. When it can't find `python3` at all, the menu warns that Claude Security won't work until one is installed; when the first `python3` on your `PATH` is older, the warning names the version it found. Install Python 3, or put a newer `python3` first on your `PATH`, then start a new session.
 
+**You may see "Fable 5's safeguards flagged this message" when using Fable 5.** Due to Fable 5's cybersecurity safety classifiers, certain model activities will be blocked and automatically downgraded to Opus.  This is expected, and the scan should still complete successfully.
+
 ## Related resources
 
```

</details>

<details>
<summary>desktop-ios-simulator-en.md</summary>

```diff
diff --git a/docs-ja/pages/desktop-ios-simulator-en.md b/docs-ja/pages/desktop-ios-simulator-en.md
index 85accff..643eb5d 100644
--- a/docs-ja/pages/desktop-ios-simulator-en.md
+++ b/docs-ja/pages/desktop-ios-simulator-en.md
@@ -104,5 +104,5 @@ You can turn Claude's simulator access off in the desktop app's settings. Organi
 
 * The `disableMobileSimulatorTools` [managed setting](/docs/en/desktop#managed-settings) blocks Claude's simulator tools. The simulator pane stays usable for your own taps, and the setting can't be overridden from within the app.
-* A policy that requires sessions to run inside an isolated virtual machine disables the pane and the tools entirely.
+* The `requireCoworkFullVmSandbox` policy key, which runs Claude's tools inside an isolated virtual machine instead of on your Mac, disables the simulator pane and Claude's simulator tools entirely, so the pane can't attach a device while it's set.
 
 Claude tells you when either applies.
```

</details>

</details>


<details>
<summary>2026-07-23</summary>

**変更ファイル:**

```
 docs-ja/pages/changelog.md | 40 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)
```

**新規追加:**


<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index d0eab90..7b4d63a 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,44 @@
 # Changelog
 
+## 2.1.218
+
+- Changed `/code-review` to run as a background subagent, so review work no longer fills your conversation and keeps stacked slash commands as its review target
+- Added screen-reader announcements of deleted text for word and line deletions (`Option+Delete`, `Ctrl+W`, `Cmd+Backspace`, `Ctrl+U`, `Ctrl+K`) in `--ax-screen-reader` mode
+- Fixed Windows paths with `\u`-prefixed segments (like `C:\Users\unicorn`) being corrupted into CJK characters in tool inputs, which made those files inaccessible
+- Fixed the left arrow key discarding the conversation with no undo: presses right after editing now ask to confirm, and Esc in the agent view returns to the conversation it backgrounded
+- Added HTTP status and error text to `claude mcp list` and `/mcp` when a server fails to connect, and a warning for MCP config values with hidden leading or trailing whitespace
+- Fixed multi-line paste collapsing into one line with `j` in place of newlines in terminals that encode pasted newlines as Ctrl+J
+- Fixed `/context` reporting stale pre-compact token usage after compacting from the message picker
+- Fixed `/ultrareview` failing on descriptive arguments like "review my auth changes" — they now run a review of your current branch with the text applied as a note to the findings
+- Fixed `/code-review ultra` silently running a local review in non-interactive sessions — it now launches the cloud review
+- Fixed gateway spend metering to price Bedrock application-inference-profile ARNs and other config-mapped upstream model IDs at the configured model's rates
+- Fixed mojibake when a long IDE selection was truncated mid-emoji, and a case where a tool executor error could be silently dropped
+- Fixed an engine teardown race that could start and abandon a phantom turn, and made input pushed after close consistently rejected
+- Fixed spurious "[Request interrupted by user]" messages after interrupted tool calls, and an unpaired `tool_use` block left in the transcript when a tool aborted mid-response
+- Fixed VoiceOver reading "new line" instead of echoing the typed space at the end of the input in `--ax-screen-reader` mode
+- Fixed plugin and settings panels not moving the terminal cursor to the focused row, so screen readers and magnifiers can follow arrow-key navigation
+- Fixed crashes (maximum call stack exceeded) when a deeply nested watched directory tree was deleted or moved, and when rendering deeply nested UI trees
+- Fixed pull request events occasionally being lost when a session exited immediately after creating or linking a PR
+- Fixed the Bedrock setup wizard failing profile verification for assume-role profiles in partitioned AWS regions and on proxy-only networks
+- Fixed rare negative or incorrect turn duration measurements after a system clock adjustment by timing turns with a monotonic clock
+- Fixed the "N MCP servers need authentication" startup notice over-counting claude.ai connectors that aren't connected in claude.ai
+- Fixed prompt history entries being dropped or duplicated when history writes raced or failed
```

</details>

</details>


<details>
<summary>2026-07-22</summary>

**変更ファイル:**

```
 docs-ja/pages/accessibility-ja.md                  |  32 +-
 docs-ja/pages/admin-setup-ja.md                    | 104 ++--
 docs-ja/pages/advisor-ja.md                        |  28 +-
 docs-ja/pages/agent-teams-ja.md                    |  52 +-
 docs-ja/pages/agent-view-ja.md                     | 112 ++--
 docs-ja/pages/agents-ja.md                         |  50 +-
 docs-ja/pages/amazon-bedrock-ja.md                 |  42 +-
 docs-ja/pages/analytics-ja.md                      |  10 +-
 docs-ja/pages/artifacts-ja.md                      |  30 +-
 docs-ja/pages/authentication-ja.md                 |  56 +-
 docs-ja/pages/auto-mode-config-ja.md               |  28 +-
 docs-ja/pages/best-practices-ja.md                 |  70 +--
 docs-ja/pages/champion-kit-ja.md                   |  28 +-
 docs-ja/pages/changelog.md                         |  24 +
 docs-ja/pages/channels-ja.md                       |  30 +-
 docs-ja/pages/channels-reference-ja.md             |  22 +-
 docs-ja/pages/checkpointing-ja.md                  |   8 +-
 docs-ja/pages/chrome-ja.md                         |  20 +-
 docs-ja/pages/claude-apps-gateway-config-ja.md     |  60 +-
 docs-ja/pages/claude-apps-gateway-deploy-ja.md     |  54 +-
 docs-ja/pages/claude-apps-gateway-ja.md            |  78 +--
 docs-ja/pages/claude-apps-gateway-on-gcp-ja.md     |  32 +-
 .../pages/claude-apps-gateway-spend-limits-ja.md   |  26 +-
 docs-ja/pages/claude-code-on-the-web-ja.md         |  80 +--
 docs-ja/pages/claude-directory-ja.md               | 108 ++--
 docs-ja/pages/claude-platform-on-aws-ja.md         |  16 +-
 docs-ja/pages/cli-reference-ja.md                  | 126 ++---
 docs-ja/pages/code-review-ja.md                    |  26 +-
 docs-ja/pages/commands-ja.md                       | 154 +++---
 docs-ja/pages/common-workflows-ja.md               |  36 +-
 docs-ja/pages/communications-kit-ja.md             |  18 +-
 docs-ja/pages/computer-use-ja.md                   |  20 +-
 docs-ja/pages/context-window-ja.md                 |  26 +-
 docs-ja/pages/corporate-launcher-ja.md             |  26 +-
 docs-ja/pages/costs-ja.md                          |  50 +-
 docs-ja/pages/data-usage-ja.md                     |  28 +-
 docs-ja/pages/debug-your-config-ja.md              |  58 +-
 docs-ja/pages/deep-links-ja.md                     |   8 +-
 docs-ja/pages/desktop-ja.md                        | 142 ++---
 docs-ja/pages/desktop-linux-ja.md                  |  10 +-
 docs-ja/pages/desktop-quickstart-ja.md             |  56 +-
 docs-ja/pages/desktop-scheduled-tasks-ja.md        |  22 +-
 docs-ja/pages/desktop-wsl-ja.md                    |   2 +-
 docs-ja/pages/devcontainer-ja.md                   |  48 +-
 docs-ja/pages/discover-plugins-ja.md               |  52 +-
 docs-ja/pages/env-vars-ja.md                       | 609 +++++++++++----------
 docs-ja/pages/errors-ja.md                         | 244 ++++-----
 docs-ja/pages/fast-mode-ja.md                      |  20 +-
 docs-ja/pages/feature-availability-ja.md           | 158 +++---
 docs-ja/pages/features-overview-ja.md              | 100 ++--
 docs-ja/pages/fullscreen-ja.md                     |  18 +-
 docs-ja/pages/gateways-ja.md                       |  30 +-
 docs-ja/pages/github-actions-ja.md                 |  12 +-
 docs-ja/pages/github-enterprise-server-ja.md       |  32 +-
 docs-ja/pages/gitlab-ci-cd-ja.md                   |   2 +-
 docs-ja/pages/glossary-ja.md                       |  96 ++--
 docs-ja/pages/goal-ja.md                           |  24 +-
 docs-ja/pages/google-vertex-ai-ja.md               |  16 +-
 docs-ja/pages/headless-ja.md                       |  44 +-
 docs-ja/pages/hooks-guide-ja.md                    | 100 ++--
 docs-ja/pages/hooks-ja.md                          | 124 ++---
 docs-ja/pages/how-claude-code-works-ja.md          |  50 +-
 docs-ja/pages/interactive-mode-ja.md               |  68 +--
 docs-ja/pages/jetbrains-ja.md                      |  14 +-
 docs-ja/pages/keybindings-ja.md                    |  18 +-
 docs-ja/pages/large-codebases-ja.md                |  62 +--
 docs-ja/pages/legal-and-compliance-ja.md           |   6 +-
 docs-ja/pages/llm-gateway-connect-ja.md            |  68 +--
 docs-ja/pages/llm-gateway-ja.md                    |  34 +-
 docs-ja/pages/llm-gateway-protocol-ja.md           |  46 +-
 docs-ja/pages/llm-gateway-rollout-ja.md            |  58 +-
 docs-ja/pages/managed-mcp-ja.md                    |  48 +-
 docs-ja/pages/mcp-ja.md                            |  68 +--
 docs-ja/pages/mcp-quickstart-ja.md                 |  36 +-
 docs-ja/pages/memory-ja.md                         |  42 +-
 docs-ja/pages/microsoft-foundry-ja.md              |   4 +-
 docs-ja/pages/mobile-en.md                         |  40 +-
 docs-ja/pages/model-config-ja.md                   | 130 ++---
 docs-ja/pages/monitoring-usage-ja.md               |  42 +-
 docs-ja/pages/network-config-ja.md                 |  28 +-
 docs-ja/pages/output-styles-ja.md                  |  26 +-
 docs-ja/pages/overview-ja.md                       |  88 +--
 docs-ja/pages/permission-modes-ja.md               | 106 ++--
 docs-ja/pages/permissions-ja.md                    | 108 ++--
 docs-ja/pages/platforms-ja.md                      |  68 +--
 docs-ja/pages/plugin-dependencies-ja.md            |  14 +-
 docs-ja/pages/plugin-hints-ja.md                   |  14 +-
 docs-ja/pages/plugin-marketplaces-ja.md            |  64 +--
 docs-ja/pages/plugin-relevance-ja.md               |  14 +-
 docs-ja/pages/plugins-ja.md                        |  62 +--
 docs-ja/pages/plugins-reference-ja.md              |  90 +--
 docs-ja/pages/prompt-caching-ja.md                 |  74 +--
 docs-ja/pages/prompt-library-ja.md                 |  38 +-
 docs-ja/pages/quickstart-ja.md                     |  28 +-
 docs-ja/pages/remote-control-ja.md                 |  60 +-
 docs-ja/pages/routines-ja.md                       |  40 +-
 docs-ja/pages/sandbox-environments-ja.md           |  54 +-
 docs-ja/pages/sandboxing-ja.md                     |  88 +--
 docs-ja/pages/scheduled-tasks-ja.md                |  34 +-
 docs-ja/pages/security-guidance-ja.md              |  26 +-
 docs-ja/pages/security-ja.md                       |  40 +-
 docs-ja/pages/server-managed-settings-ja.md        |  50 +-
 docs-ja/pages/sessions-ja.md                       |  42 +-
 docs-ja/pages/settings-ja.md                       | 276 +++++-----
 docs-ja/pages/setup-ja.md                          |  64 +--
 docs-ja/pages/skills-ja.md                         |  88 +--
 docs-ja/pages/slack-ja.md                          |   6 +-
 docs-ja/pages/statusline-ja.md                     |  16 +-
 docs-ja/pages/sub-agents-ja.md                     | 142 ++---
 docs-ja/pages/terminal-config-ja.md                |  42 +-
 docs-ja/pages/third-party-integrations-ja.md       |  48 +-
 docs-ja/pages/tools-reference-ja.md                | 122 ++---
 docs-ja/pages/troubleshoot-install-ja.md           |  34 +-
 docs-ja/pages/troubleshooting-ja.md                |  32 +-
 docs-ja/pages/ultraplan-ja.md                      |  16 +-
 docs-ja/pages/ultrareview-ja.md                    |  10 +-
 docs-ja/pages/voice-dictation-ja.md                |  26 +-
 docs-ja/pages/vs-code-ja.md                        |  70 +--
 docs-ja/pages/web-quickstart-ja.md                 |  48 +-
 docs-ja/pages/workflows-ja.md                      |  28 +-
 docs-ja/pages/worktrees-ja.md                      |  42 +-
 docs-ja/pages/zero-data-retention-ja.md            |  16 +-
 122 files changed, 3496 insertions(+), 3457 deletions(-)
```

**新規追加:**


<details>
<summary>accessibility-ja.md</summary>

```diff
diff --git a/docs-ja/pages/accessibility-ja.md b/docs-ja/pages/accessibility-ja.md
index 0e317ee..11a5978 100644
--- a/docs-ja/pages/accessibility-ja.md
+++ b/docs-ja/pages/accessibility-ja.md
@@ -23,8 +23,8 @@ Claude Code には、ビジュアルターミナルインターフェースを
 * 1 つのセッション用：`claude --ax-screen-reader` を実行します。
 * 1 つのシェルから開始されたセッション用：`CLAUDE_AX_SCREEN_READER` 環境変数を `1` に設定します。Bash または Zsh では `export CLAUDE_AX_SCREEN_READER=1` を実行し、PowerShell では `$env:CLAUDE_AX_SCREEN_READER = "1"` を実行します。すべてのシェルをカバーするために、シェルプロファイルに行を追加します。
-* マシン上のすべてのセッション用：ユーザー[設定ファイル](/ja/settings)に `"axScreenReader": true` を追加します。これは VS Code 統合ターミナルを含むすべてのターミナルをカバーします。
+* マシン上のすべてのセッション用：ユーザー[設定ファイル](/docs/ja/settings)に `"axScreenReader": true` を追加します。これは VS Code 統合ターミナルを含むすべてのターミナルをカバーします。
 
 <Note>
-  メソッドは優先順位順にリストされています。[`--ax-screen-reader`](/ja/cli-reference#cli-flags) フラグは [`CLAUDE_AX_SCREEN_READER`](/ja/env-vars) 環境変数をオーバーライドし、これは [`axScreenReader`](/ja/settings#available-settings) 設定をオーバーライドします。
+  メソッドは優先順位順にリストされています。[`--ax-screen-reader`](/docs/ja/cli-reference#cli-flags) フラグは [`CLAUDE_AX_SCREEN_READER`](/docs/ja/env-vars) 環境変数をオーバーライドし、これは [`axScreenReader`](/docs/ja/settings#available-settings) 設定をオーバーライドします。
 </Note>
 
@@ -53,5 +53,5 @@ SSH 経由で Claude Code を使用する場合は、Claude Code が実行され
 出力はターミナルのスクロールバックに蓄積されるため、スクリーンリーダーのレビューコマンドまたはターミナルの検索を使用して以前のターンを再度読むことができます。
 
-スクリーンリーダーモードは、[フルスクリーンレンダリング](/ja/fullscreen)を [`tui` 設定](/ja/settings#available-settings)でオンにしている場合でも、プレーンなスクロールテキストとしてレンダリングされます。モードがアクティブな間、設定は効果がありません。アタッチされたバックグラウンドセッションは引き続きフルスクリーンでレンダリングされます。[既知の制限事項](#known-limitations)を参照してください。
+スクリーンリーダーモードは、[フルスクリーンレンダリング](/docs/ja/fullscreen)を [`tui` 設定](/docs/ja/settings#available-settings)でオンにしている場合でも、プレーンなスクロールテキストとしてレンダリングされます。モードがアクティブな間、設定は効果がありません。アタッチされたバックグラウンドセッションは引き続きフルスクリーンでレンダリングされます。[既知の制限事項](#known-limitations)を参照してください。
 
 トランスクリプト内の各メッセージは、スクリーンリーダーが発表するラベルで始まり、それが何であるかを名前付けします。あなたのメッセージ、Claude の返信、ツールアクティビティ、エラー、プロンプトです。ラベルは検索可能でもあるため、ターミナルのスクロールバックを検索してトランスクリプトのセクション間をジャンプできます。
@@ -65,5 +65,5 @@ SSH 経由で Claude Code を使用する場合は、Claude Code が実行され
 | `error:`               | 失敗した API リクエストなどの会話内のエラー                                        |
 | `Permission Required:` | あなたの回答を待っている権限プロンプト                                             |
-| `Cost:`                | Claude Code が終了するときのセッションコスト概要（アカウントが[コストを表示](/ja/costs)している場合） |
+| `Cost:`                | Claude Code が終了するときのセッションコスト概要（アカウントが[コストを表示](/docs/ja/costs)している場合） |
 
 ターミナルカーソルは入力キャレットに従うため、スクリーンリーダーの現在の行を読むコマンドは「どこにいるのか」に編集しているプロンプトで答えます。
@@ -103,5 +103,5 @@ macOS Terminal はマーカーに作用せず、Claude Code は WezTerm では
```

</details>

<details>
<summary>admin-setup-ja.md</summary>

```diff
diff --git a/docs-ja/pages/admin-setup-ja.md b/docs-ja/pages/admin-setup-ja.md
index ab3ff5b..e4a104e 100644
--- a/docs-ja/pages/admin-setup-ja.md
+++ b/docs-ja/pages/admin-setup-ja.md
@@ -17,9 +17,9 @@ Claude Code は、ローカル開発者設定よりも優先されるマネー
 | 決定                                                        | 選択内容                      | 参照                                                                                                                                                                         |
 | :-------------------------------------------------------- | :------------------------ | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
-| [API プロバイダーを選択する](#choose-your-api-provider)              | Claude Code が認証される場所と課金方法 | [Authentication](/ja/authentication)、[Amazon Bedrock](/ja/amazon-bedrock)、[Google Cloud の Agent Platform](/ja/google-vertex-ai)、[Microsoft Foundry](/ja/microsoft-foundry) |
-| [設定がデバイスに到達する方法を決定する](#decide-how-settings-reach-devices) | マネージドポリシーが開発者マシンに到達する方法   | [Server-managed settings](/ja/server-managed-settings)、[Settings files](/ja/settings#settings-files)                                                                       |
-| [実行する内容を決定する](#decide-what-to-enforce)                    | どのツール、コマンド、統合が許可されるか      | [Permissions](/ja/permissions)、[Sandboxing](/ja/sandboxing)                                                                                                                |
-| [使用状況の可視性をセットアップする](#set-up-usage-visibility)             | 支出と採用を追跡する方法              | [Analytics](/ja/analytics)、[Monitoring](/ja/monitoring-usage)、[Costs](/ja/costs)                                                                                           |
-| [データ処理を確認する](#review-data-handling)                       | データ保持とコンプライアンス体制          | [Data usage](/ja/data-usage)、[Security](/ja/security)                                                                                                                      |
+| [API プロバイダーを選択する](#choose-your-api-provider)              | Claude Code が認証される場所と課金方法 | [Authentication](/docs/ja/authentication)、[Amazon Bedrock](/docs/ja/amazon-bedrock)、[Google Cloud の Agent Platform](/docs/ja/google-vertex-ai)、[Microsoft Foundry](/docs/ja/microsoft-foundry) |
+| [設定がデバイスに到達する方法を決定する](#decide-how-settings-reach-devices) | マネージドポリシーが開発者マシンに到達する方法   | [Server-managed settings](/docs/ja/server-managed-settings)、[Settings files](/docs/ja/settings#settings-files)                                                                       |
+| [実行する内容を決定する](#decide-what-to-enforce)                    | どのツール、コマンド、統合が許可されるか      | [Permissions](/docs/ja/permissions)、[Sandboxing](/docs/ja/sandboxing)                                                                                                                |
+| [使用状況の可視性をセットアップする](#set-up-usage-visibility)             | 支出と採用を追跡する方法              | [Analytics](/docs/ja/analytics)、[Monitoring](/docs/ja/monitoring-usage)、[Costs](/docs/ja/costs)                                                                                           |
+| [データ処理を確認する](#review-data-handling)                       | データ保持とコンプライアンス体制          | [Data usage](/docs/ja/data-usage)、[Security](/docs/ja/security)                                                                                                                      |
 
 <h2 id="choose-your-api-provider">
@@ -37,9 +37,9 @@ Claude Code は複数の API プロバイダーのいずれかを通じて Claud
 | Microsoft Foundry             | 既存の Azure コンプライアンス制御と課金を継承したい場合                                                            |
 
-一部の Claude Code 機能には claude.ai アカウントが必要です。[web 上の Claude Code](/ja/claude-code-on-the-web)、[Routines](/ja/routines)、[Code Review](/ja/code-review)、[Remote Control](/ja/remote-control)、および [Chrome 拡張機能](/ja/chrome) は、Console API キーまたはクラウドプロバイダーの認証情報だけでは利用できません。Amazon Bedrock、Google Cloud の Agent Platform、または Microsoft Foundry を通じてデプロイする場合は、開発者が Claude for Teams または Enterprise シートも必要かどうかを検討してください。各機能ページにはプラン要件が記載されています。
+一部の Claude Code 機能には claude.ai アカウントが必要です。[web 上の Claude Code](/docs/ja/claude-code-on-the-web)、[Routines](/docs/ja/routines)、[Code Review](/docs/ja/code-review)、[Remote Control](/docs/ja/remote-control)、および [Chrome 拡張機能](/docs/ja/chrome) は、Console API キーまたはクラウドプロバイダーの認証情報だけでは利用できません。Amazon Bedrock、Google Cloud の Agent Platform、または Microsoft Foundry を通じてデプロイする場合は、開発者が Claude for Teams または Enterprise シートも必要かどうかを検討してください。各機能ページにはプラン要件が記載されています。
 
-認証、リージョン、機能パリティをカバーする完全なプロバイダー比較については、[エンタープライズ展開概要](/ja/third-party-integrations) を参照してください。各プロバイダーの認証セットアップは [Authentication](/ja/authentication) にあります。
+認証、リージョン、機能パリティをカバーする完全なプロバイダー比較については、[エンタープライズ展開概要](/docs/ja/third-party-integrations) を参照してください。各プロバイダーの認証セットアップは [Authentication](/docs/ja/authentication) にあります。
 
-[ネットワーク設定](/ja/network-config) のプロキシとファイアウォール要件は、プロバイダーに関係なく適用されます。複数のプロバイダーの前に単一のエンドポイントを配置したい場合、または集中化されたリクエストログを記録したい場合は、[LLM gateway](/ja/llm-gateway) を参照してください。
+[ネットワーク設定](/docs/ja/network-config) のプロキシとファイアウォール要件は、プロバイダーに関係なく適用されます。複数のプロバイダーの前に単一のエンドポイントを配置したい場合、または集中化されたリクエストログを記録したい場合は、[LLM gateway](/docs/ja/llm-gateway) を参照してください。
```

</details>

<details>
<summary>advisor-ja.md</summary>

```diff
diff --git a/docs-ja/pages/advisor-ja.md b/docs-ja/pages/advisor-ja.md
index 63997f9..6c37bae 100644
--- a/docs-ja/pages/advisor-ja.md
+++ b/docs-ja/pages/advisor-ja.md
@@ -23,5 +23,5 @@ advisor は Anthropic インフラストラクチャ上でサーバー側で実
 advisor は、ほとんどのターンが定型的であるが、プラン品質が結果を決定する長い複数ステップのタスクに適しています。例としては、大規模なリファクタリング、エラーが繰り返し発生するデバッグセッション、および Claude が完了を宣言する前に独立して確認したいタスクが挙げられます。
 
-計画する必要がほとんどない短いタスク、またはすべてのターンで最強のモデルが必要な作業では、価値が低くなります。その場合は、[メインモデルを切り替える](/ja/model-config#setting-your-model)か、[advisor が opusplan およびサブエージェントとどのように比較されるか](#compare-with-related-features)を参照して、2 番目の意見を得る他の方法を確認してください。
+計画する必要がほとんどない短いタスク、またはすべてのターンで最強のモデルが必要な作業では、価値が低くなります。その場合は、[メインモデルを切り替える](/docs/ja/model-config#setting-your-model)か、[advisor が opusplan およびサブエージェントとどのように比較されるか](#compare-with-related-features)を参照して、2 番目の意見を得る他の方法を確認してください。
 
 <h2 id="enable-the-advisor">
@@ -32,5 +32,5 @@ advisor モデルは 3 つの方法で設定できます。
 
 * **`/advisor` コマンド**：セッション中に advisor を設定または変更し、デフォルトとして保存します
-* **`advisorModel` 設定**：[設定ファイル](/ja/settings)で永続的なデフォルトを構成します
+* **`advisorModel` 設定**：[設定ファイル](/docs/ja/settings)で永続的なデフォルトを構成します
 * **`--advisor` フラグ**：起動時に単一セッションの advisor を設定します
 
@@ -38,5 +38,5 @@ advisor モデルは 3 つの方法で設定できます。
 
 <Note>
-  Fable 5 を advisor として使用するには、Claude Code v2.1.170 以降と、組織の [Fable 5 アクセス](/ja/model-config#work-with-fable-5)が必要です。
+  Fable 5 を advisor として使用するには、Claude Code v2.1.170 以降と、組織の [Fable 5 アクセス](/docs/ja/model-config#work-with-fable-5)が必要です。
 </Note>
 
@@ -51,5 +51,5 @@ advisor モデルは 3 つの方法で設定できます。
 ```
 
-選択は、ユーザー設定の `advisorModel` に保存され、セッション全体で保持されます。組織の [`availableModels`](/ja/model-config#restrict-model-selection)許可リストが保存された advisor モデルを除外している場合、`/advisor` で許可されたモデルを選択するまで advisor は呼び出されません。現在のメインモデルが advisor をサポートしていない場合、選択は引き続き保存され、[`/model`](/ja/model-config#setting-your-model)で[互換性のあるメインモデル](#choose-an-advisor-model)に切り替えるときにアクティブになります。
+選択は、ユーザー設定の `advisorModel` に保存され、セッション全体で保持されます。組織の [`availableModels`](/docs/ja/model-config#restrict-model-selection)許可リストが保存された advisor モデルを除外している場合、`/advisor` で許可されたモデルを選択するまで advisor は呼び出されません。現在のメインモデルが advisor をサポートしていない場合、選択は引き続き保存され、[`/model`](/docs/ja/model-config#setting-your-model)で[互換性のあるメインモデル](#choose-an-advisor-model)に切り替えるときにアクティブになります。
```

</details>

<details>
<summary>agent-teams-ja.md</summary>

```diff
diff --git a/docs-ja/pages/agent-teams-ja.md b/docs-ja/pages/agent-teams-ja.md
index b982eb4..c1ba8ec 100644
--- a/docs-ja/pages/agent-teams-ja.md
+++ b/docs-ja/pages/agent-teams-ja.md
@@ -8,13 +8,13 @@
 
 <Warning>
-  エージェントチームは実験的機能であり、デフォルトでは無効になっています。[settings.json](/ja/settings) または環境に `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS` を追加して有効にしてください。その変数がない場合、セッション開始時にチームが設定されず、チームディレクトリが書き込まれず、Claude はチームメンバーをスポーンまたは提案しません。エージェントチームには、セッション再開、タスク調整、シャットダウン動作に関する[既知の制限](#limitations)があります。
+  エージェントチームは実験的機能であり、デフォルトでは無効になっています。[settings.json](/docs/ja/settings) または環境に `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS` を追加して有効にしてください。その変数がない場合、セッション開始時にチームが設定されず、チームディレクトリが書き込まれず、Claude はチームメンバーをスポーンまたは提案しません。エージェントチームには、セッション再開、タスク調整、シャットダウン動作に関する[既知の制限](#limitations)があります。
 </Warning>
 
 エージェントチームを使用すると、複数の Claude Code インスタンスが連携して動作するように調整できます。1 つのセッションがチームリーダーとして機能し、作業を調整し、タスクを割り当て、結果を統合します。チームメンバーは独立して動作し、それぞれ独自のコンテキストウィンドウで動作し、互いに直接通信します。
 
-[subagents](/ja/sub-agents)（単一セッション内で実行され、メインエージェントにのみ報告できる）とは異なり、リーダーを経由せずに個別のチームメンバーと直接対話することもできます。
+[subagents](/docs/ja/sub-agents)（単一セッション内で実行され、メインエージェントにのみ報告できる）とは異なり、リーダーを経由せずに個別のチームメンバーと直接対話することもできます。
 
 <Note>
-  このページは v2.1.178 時点のエージェントチームについて説明しています。`CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS` が設定されている場合、チームメンバーのスポーンにはセットアップステップが不要になり、セッション終了時にクリーンアップが自動的に行われます。v2.1.178 より前は、最初にチームを作成して名前を付けるよう Claude に依頼し、Claude は `TeamCreate` と `TeamDelete` ツールを使用してセットアップと削除を行いました。両方のツールはもう存在しません。Agent ツールの `team_name` 入力は受け入れられますが無視され、`TaskCreated`、`TaskCompleted`、および `TeammateIdle` [hook ペイロード](/ja/hooks#taskcreated)の `team_name` フィールドはセッション派生名を含み、非推奨です。
+  このページは v2.1.178 時点のエージェントチームについて説明しています。`CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS` が設定されている場合、チームメンバーのスポーンにはセットアップステップが不要になり、セッション終了時にクリーンアップが自動的に行われます。v2.1.178 より前は、最初にチームを作成して名前を付けるよう Claude に依頼し、Claude は `TeamCreate` と `TeamDelete` ツールを使用してセットアップと削除を行いました。両方のツールはもう存在しません。Agent ツールの `team_name` 入力は受け入れられますが無視され、`TaskCreated`、`TaskCompleted`、および `TeammateIdle` [hook ペイロード](/docs/ja/hooks#taskcreated)の `team_name` フィールドはセッション派生名を含み、非推奨です。
 </Note>
 
@@ -30,5 +30,5 @@
 * **クロスレイヤー調整**：フロントエンド、バックエンド、テストにまたがる変更で、それぞれ異なるチームメンバーが担当します
 
-エージェントチームは調整オーバーヘッドを追加し、単一セッションよりも大幅に多くのトークンを使用します。チームメンバーが独立して動作できる場合に最も効果的です。順序付きタスク、同じファイルの編集、または多くの依存関係を持つ作業の場合は、単一セッションまたは [subagents](/ja/sub-agents) がより効果的です。
+エージェントチームは調整オーバーヘッドを追加し、単一セッションよりも大幅に多くのトークンを使用します。チームメンバーが独立して動作できる場合に最も効果的です。順序付きタスク、同じファイルの編集、または多くの依存関係を持つ作業の場合は、単一セッションまたは [subagents](/docs/ja/sub-agents) がより効果的です。
 
 <h3 id="compare-with-subagents">
@@ -36,5 +36,5 @@
 </h3>
```

</details>

<details>
<summary>agent-view-ja.md</summary>

```diff
diff --git a/docs-ja/pages/agent-view-ja.md b/docs-ja/pages/agent-view-ja.md
index 2e85a74..e7c7da8 100644
--- a/docs-ja/pages/agent-view-ja.md
+++ b/docs-ja/pages/agent-view-ja.md
@@ -17,5 +17,5 @@ Claude が複数の独立したタスクに対して、あなたが毎ステッ
 任意のエージェントのセッションでより直接的に作業したい場合は、行にアタッチして完全な会話に入ります。
 
-エージェントビューを subagents、agent teams、worktrees と比較するには、[エージェントを並列で実行する](/ja/agents)を参照してください。
+エージェントビューを subagents、agent teams、worktrees と比較するには、[エージェントを並列で実行する](/docs/ja/agents)を参照してください。
 
 <Note>
@@ -71,5 +71,5 @@ Claude が複数の独立したタスクに対して、あなたが毎ステッ
 `claude agents` を `claude` の代わりにプライマリエントリーポイントとして使用できます。エージェントビューからすべてのタスクをディスパッチし、フル会話が必要な場合はアタッチし、`←` を押してテーブルに戻ります。
 
-{/* min-version: 2.1.205 */}通常の `claude` セッション内では、プロンプトフッターの `←` ヒントは、`← 2 agents` のように入力を待機中のバックグラウンドエージェントの数をカウントし、入力が必要なエージェントがない場合は `← for agents` に戻ります。99 を超えるカウントは `99+` として表示されます。カウントはターミナルがフォーカスされている間は約 10 秒ごとに更新され、フォーカスが戻ると即座に更新されます。カウントが移動したときとエージェントが完了したときに色が一時的に変わります。ただし、[`prefersReducedMotion` 設定](/ja/settings#available-settings)がオンの場合は除きます。また、[スクリーンリーダーモード](/ja/accessibility)では非表示になります。[Amazon Bedrock、Google Cloud の Agent Platform、Microsoft Foundry](/ja/third-party-integrations)では、ヒントはカウントなしの通常の `← for agents` 形式のままです。Claude Code v2.1.205 以降が必要です。
+{/* min-version: 2.1.205 */}通常の `claude` セッション内では、プロンプトフッターの `←` ヒントは、`← 2 agents` のように入力を待機中のバックグラウンドエージェントの数をカウントし、入力が必要なエージェントがない場合は `← for agents` に戻ります。99 を超えるカウントは `99+` として表示されます。カウントはターミナルがフォーカスされている間は約 10 秒ごとに更新され、フォーカスが戻ると即座に更新されます。カウントが移動したときとエージェントが完了したときに色が一時的に変わります。ただし、[`prefersReducedMotion` 設定](/docs/ja/settings#available-settings)がオンの場合は除きます。また、[スクリーンリーダーモード](/docs/ja/accessibility)では非表示になります。[Amazon Bedrock、Google Cloud の Agent Platform、Microsoft Foundry](/docs/ja/third-party-integrations)では、ヒントはカウントなしの通常の `← for agents` 形式のままです。Claude Code v2.1.205 以降が必要です。
 
 <h2 id="monitor-sessions-with-agent-view">
@@ -79,5 +79,5 @@ Claude が複数の独立したタスクに対して、あなたが毎ステッ
 `claude agents` を実行してエージェントビューを開きます。ターミナル全体を占有し、状態でグループ化されたすべてのセッションをリストします。ピン留めされたセッションと入力が必要なセッションが上部に表示されます。各行はセッションの名前、現在のアクティビティ、およびセッションが作成されてからの経過時間を表示します。完了したセッションの経過時間は、実行にかかった時間で固定されます。
 
-名前は、そのセッションで [`/color`](/ja/commands) によって設定されたカラーで色付けされます。{/* min-version: 2.1.199 */}v2.1.199 以降、`←` または `/background` で [セッションをバックグラウンドにする](#from-inside-a-session) ときにカラーが引き継がれます。
+名前は、そのセッションで [`/color`](/docs/ja/commands) によって設定されたカラーで色付けされます。{/* min-version: 2.1.199 */}v2.1.199 以降、`←` または `/background` で [セッションをバックグラウンドにする](#from-inside-a-session) ときにカラーが引き継がれます。
 
 デフォルトでは、リストはすべてのプロジェクト全体で開始したすべてのバックグラウンドセッションを表示します。1 つのリポジトリで作業しているセッションと別のワークツリーで作業している別のセッションの両方がここに表示されます。エージェントビューを開いたディレクトリに関係なく表示されます。リストを 1 つのプロジェクトに絞り込むには、`--cwd` を渡します：
@@ -89,5 +89,5 @@ claude agents --cwd ~/projects/my-app
 これはそのディレクトリの下で開始されたセッションのみを表示します。`~/projects/my-app/.claude/worktrees/` の下の [ワークツリーに移動した](#how-file-edits-are-isolated) セッションは、`~/projects/my-app` に属するものとしてカウントされます。
 
-他のターミナルで開いているインタラクティブセッションは、[バックグラウンドにする](#from-inside-a-session) までは表示されません。[Subagents](/ja/sub-agents) と [teammates](/ja/agent-teams) はセッションが生成しても個別の行としてリストされません。
+他のターミナルで開いているインタラクティブセッションは、[バックグラウンドにする](#from-inside-a-session) までは表示されません。[Subagents](/docs/ja/sub-agents) と [teammates](/docs/ja/agent-teams) はセッションが生成しても個別の行としてリストされません。
```

</details>

<details>
<summary>agents-ja.md</summary>

```diff
diff --git a/docs-ja/pages/agents-ja.md b/docs-ja/pages/agents-ja.md
index 7b0bd36..d4b308a 100644
--- a/docs-ja/pages/agents-ja.md
+++ b/docs-ja/pages/agents-ja.md
@@ -7,28 +7,28 @@
 > Claude Code が複数のタスクを同時に実行する方法を比較します。サブエージェント、エージェントビュー、エージェントチーム、および動的ワークフローについて説明します。
 
-[サブエージェント](/ja/sub-agents)、[エージェントビュー](/ja/agent-view)、[エージェントチーム](/ja/agent-teams)、および [動的ワークフロー](/ja/workflows) は、それぞれ異なる方法で作業を並列化します。どれを選ぶかは、各会話に自分で留まりたいのか、タスクを引き継いで後で確認したいのか、それとも Claude に一群のワーカーを調整させたいのかによって異なります。
+[サブエージェント](/docs/ja/sub-agents)、[エージェントビュー](/docs/ja/agent-view)、[エージェントチーム](/docs/ja/agent-teams)、および [動的ワークフロー](/docs/ja/workflows) は、それぞれ異なる方法で作業を並列化します。どれを選ぶかは、各会話に自分で留まりたいのか、タスクを引き継いで後で確認したいのか、それとも Claude に一群のワーカーを調整させたいのかによって異なります。
 
 | アプローチ                        | 提供内容                                                                    | 使用する場合                                                                      |
 | :--------------------------- | :---------------------------------------------------------------------- | :-------------------------------------------------------------------------- |
-| [サブエージェント](/ja/sub-agents)   | 1 つのセッション内で委任されたワーカーが、独自のコンテキストでサイドタスクを実行し、サマリーを返す                      | サイドタスクが検索結果、ログ、またはファイルコンテンツで主な会話を埋め尽くす場合（再度参照しない）                           |
-| [エージェントビュー](/ja/agent-view)  | `claude agents` で開く、バックグラウンドで実行されているセッションをディスパッチして監視する 1 つの画面。リサーチプレビュー | 複数の独立したタスクがあり、それらを引き継いで、一目で状態を確認し、必要な場合のみ介入したい場合                            |
-| [エージェントチーム](/ja/agent-teams) | 共有タスクリストとエージェント間メッセージングを備えた複数の調整されたセッション。リーダーによって管理される。実験的で、デフォルトでは無効   | Claude にプロジェクトを分割させ、割り当てさせ、ワーカーを同期させたい場合                                    |
-| [動的ワークフロー](/ja/workflows)    | 多くのサブエージェントを実行し、その結果をチェックするスクリプト。1 回のターンで調整するには大きすぎるジョブ向け               | タスクが大きすぎてサブエージェント数個では対応できない場合。コードベース全体の監査、500 ファイルのマイグレーション、または相互検証が必要な調査など |
+| [サブエージェント](/docs/ja/sub-agents)   | 1 つのセッション内で委任されたワーカーが、独自のコンテキストでサイドタスクを実行し、サマリーを返す                      | サイドタスクが検索結果、ログ、またはファイルコンテンツで主な会話を埋め尽くす場合（再度参照しない）                           |
+| [エージェントビュー](/docs/ja/agent-view)  | `claude agents` で開く、バックグラウンドで実行されているセッションをディスパッチして監視する 1 つの画面。リサーチプレビュー | 複数の独立したタスクがあり、それらを引き継いで、一目で状態を確認し、必要な場合のみ介入したい場合                            |
+| [エージェントチーム](/docs/ja/agent-teams) | 共有タスクリストとエージェント間メッセージングを備えた複数の調整されたセッション。リーダーによって管理される。実験的で、デフォルトでは無効   | Claude にプロジェクトを分割させ、割り当てさせ、ワーカーを同期させたい場合                                    |
+| [動的ワークフロー](/docs/ja/workflows)    | 多くのサブエージェントを実行し、その結果をチェックするスクリプト。1 回のターンで調整するには大きすぎるジョブ向け               | タスクが大きすぎてサブエージェント数個では対応できない場合。コードベース全体の監査、500 ファイルのマイグレーション、または相互検証が必要な調査など |
 
-すべてのアプローチにおいて、ワーカーは Claude セッションです。別のツールを関与させるには、それを Claude に [MCP サーバー](/ja/mcp) として公開します。
+すべてのアプローチにおいて、ワーカーは Claude セッションです。別のツールを関与させるには、それを Claude に [MCP サーバー](/docs/ja/mcp) として公開します。
 
 この作業をサポートする 2 つの追加ツールがありますが、エージェント自体を実行する方法ではありません。
 
-* [ワークツリー](/ja/worktrees) は各セッションに個別の git チェックアウトを提供するため、並列セッションが同じファイルを編集することはありません。自分で実行するセッションに使用します。エージェントビューは、ディスパッチされた各セッションを自動的に独自のワークツリーに移動し、スポーンするサブエージェントも各々独自のワークツリーを取得できます。
-* [`/batch`](/ja/commands) は、1 つの大きな変更を 5 ～ 30 個のワークツリー分離サブエージェントに分割し、各エージェントがプルリクエストを開く [skill](/ja/skills) です。これはサブエージェントとワークツリーのパッケージ化された使用法であり、別の調整スタイルではありません。
+* [ワークツリー](/docs/ja/worktrees) は各セッションに個別の git チェックアウトを提供するため、並列セッションが同じファイルを編集することはありません。自分で実行するセッションに使用します。エージェントビューは、ディスパッチされた各セッションを自動的に独自のワークツリーに移動し、スポーンするサブエージェントも各々独自のワークツリーを取得できます。
+* [`/batch`](/docs/ja/commands) は、1 つの大きな変更を 5 ～ 30 個のワークツリー分離サブエージェントに分割し、各エージェントがプルリクエストを開く [skill](/docs/ja/skills) です。これはサブエージェントとワークツリーのパッケージ化された使用法であり、別の調整スタイルではありません。
```

</details>

*...以降省略*

</details>


<!-- UPDATE_LOG_END -->
