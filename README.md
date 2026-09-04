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
<summary>2026-09-04</summary>

**変更ファイル:**

```
 docs-ja/pages/changelog.md                         |  69 +++
 docs-ja/pages/managed-settings-en.md               |  22 +-
 .../pages/self-hosted-environments-deploy-en.md    |   2 +
 .../pages/self-hosted-environments-reference-en.md |   2 +-
 docs-ja/pages/settings-reference-en.md             | 483 +++++++++++----------
 5 files changed, 346 insertions(+), 232 deletions(-)
```

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index b580854..3bd3615 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,73 @@
 # Changelog
 
+## 2.1.260
+
+- Added a diff panel that opens beside the conversation in fullscreen mode and shows your uncommitted changes as Claude edits; toggle it with `/diff`
+- Added a likely cause for prompt-cache misses (e.g. tool definitions or system prompt changed, idle past the TTL) to `/cost` and the status line's `prompt_cache` field
+- Added `/reload-plugins` to headless sessions, so it appears in the Claude Code Desktop and SDK command lists
+- Added a text form of `/advisor` (`/advisor`, `/advisor <model>`, `/advisor off`) for the desktop app, Remote Control, and other headless (`-p`/Agent SDK) sessions
+- Added `oidc.scope_on_refresh` to the Claude apps gateway for IdPs that return an id_token on refresh only when asked for `openid` again
+- Added Claude apps gateway support for newer Claude Desktop keys in `desktop` policy blocks, including `userPluginMarketplacesEnabled` and `userPluginUploadsEnabled`
+- Fixed `Edit`/`Write`/`Read` permission rules whose path contains parentheses being dropped as invalid or ignored by the Bash sandbox, which left "read-only" folders writable
+- Fixed one file permission rule with an uncompilable pattern (e.g. an unclosed `[`) making every file edit fail with `Invalid regular expression`; such a deny rule now guards the literal path it spells
+- Fixed Bash permission checks auto-approving zsh commands that hide a command substitution in a REPORTTIME, REPORTMEMORY or DIRSTACKSIZE assignment; these now prompt for approval
+- Fixed Bedrock model discovery, token counting and AWS SSO/STS credential calls failing with "unable to get local issuer certificate" when the corporate root CA is only in the OS certificate store
+- Fixed `permissions.blockReadsOutsideWorkingDirectories` on macOS hiding the user's git config from sandboxed git and hiding a worktree-isolated sub-agent's own checkout
+- Fixed managed settings not loading for claude.ai Enterprise/Team users who also had a leftover API key from an earlier `/login`
+- Fixed `/status` listing a signed-in claude.ai account and a configured API key as if both were in effect; the credential not in use is now marked
+- Fixed managed `skillOverrides` entries keyed on a bundled skill's alias (e.g. `checkup` for `/doctor`) not applying, and `Skill(name)` deny rules not covering a nested skill listed as `<dir>:name`
+- Fixed `model: fable` agents ignoring the `[1m]` tag on an `ANTHROPIC_DEFAULT_FABLE_MODEL` pin and silently running with a 200K context window
+- Fixed the `/model` picker not showing Fable 5.1 for organizations that can use it, which was only accepted when typed as `/model claude-fable-5-1`
+- Fixed prompt caching on Claude Fable 5.1 not covering the context attached after tool results, so it was re-sent as uncached input on every tool-call turn
+- Fixed model switching staying blocked for the rest of the session after a plugin hook load failure; each switch now re-checks and the refusal names the cause
+- Fixed model switching being blocked for the session when an organization-managed plugin's marketplace could not be loaded
+- Fixed SDK-provided MCP servers (e.g. Desktop connectors) sometimes missing from the first turn and only appearing on the next one
+- Fixed Claude in Chrome tools failing with "Not connected" mid-task in cloud-hosted claude.ai sessions when a connector was added or removed
```

</details>

<details>
<summary>managed-settings-en.md</summary>

```diff
diff --git a/docs-ja/pages/managed-settings-en.md b/docs-ja/pages/managed-settings-en.md
index 7b21823..f396f95 100644
--- a/docs-ja/pages/managed-settings-en.md
+++ b/docs-ja/pages/managed-settings-en.md
@@ -273,5 +273,7 @@ When Claude Code found a managed source on the machine and didn't select it, a s
 When the policy isn't applying, the `Setting sources` line tells you which of two problems you have:
 
-* **The line is missing**: Claude Code found no managed source that delivers a policy key. If you deployed a managed settings file, check that it sits at the path for the OS, that it's valid JSON, and that it contains a [policy key](#how-claude-code-combines-managed-sources) rather than only the control keys.
+* **The line is missing**: Claude Code found no managed source that delivers a policy key.
+
+  If you deployed a managed settings file, check that it sits at the path for the OS and that it contains a [policy key](#how-claude-code-combines-managed-sources) rather than only the control keys. A file that isn't valid JSON doesn't produce this state; Claude Code [refuses to start](#find-entries-claude-code-dropped) instead.
 
   When you deployed through server-managed settings instead, run `claude doctor`, which reports the [fetch outcome](/docs/en/server-managed-settings#verify-settings-delivery).
@@ -282,7 +284,21 @@ When the policy isn't applying, the `Setting sources` line tells you which of tw
 ### Find entries Claude Code dropped
 
-When a managed settings file, MDM profile, registry value, or server-managed payload fails schema validation, Claude Code first skips the individual entries it can repair, such as one invalid permission rule, with a warning for each, then drops any top-level key whose value still fails and keeps enforcing every remaining valid key. Claude Code is stricter with the `managedSettings` a [`policyHelper`](/docs/en/settings-reference#policyhelper) emits: it makes the same entry repairs, but any schema violation that survives fails the whole helper run, and at startup Claude Code refuses to start, the same as for a helper that exits non-zero. A managed settings file or drop-in file that isn't valid JSON contributes no settings at all; Claude Code reports it with the other validation errors and reads the remaining sources as usual.
+When a managed settings file, MDM profile, registry value, or server-managed payload fails schema validation, Claude Code first skips the individual entries it can repair, such as one invalid permission rule, with a warning for each, then drops any top-level key whose value still fails and keeps enforcing every remaining valid key.
+
+Claude Code is stricter with the `managedSettings` a [`policyHelper`](/docs/en/settings-reference#policyhelper) emits: it makes the same entry repairs, but any schema violation that survives fails the whole helper run, and at startup Claude Code refuses to start, the same as for a helper that exits non-zero.
+
+When a managed settings file, drop-in file, MDM plist, or HKLM registry value is present but can't be parsed as a JSON object, Claude Code refuses to start and prints [an error naming the source](/docs/en/errors#managed-settings-document-could-not-be-parsed), even when another admin source delivers a valid policy. Each source fails this way when:
+
+* **Managed settings file or drop-in file**: the file isn't valid JSON, or its top level isn't an object
+* **MDM plist**: macOS's `plutil` reports the plist malformed, or its converted content isn't a JSON object
+* **HKLM registry value**: the `Settings` value isn't a string, is empty, or doesn't hold a JSON object
+
+Three source states don't cause this refusal:
+
+* An absent file, profile, or registry value isn't a failure; Claude Code runs without that source.
```

</details>

<details>
<summary>self-hosted-environments-deploy-en.md</summary>

```diff
diff --git a/docs-ja/pages/self-hosted-environments-deploy-en.md b/docs-ja/pages/self-hosted-environments-deploy-en.md
index 186f418..13c08c3 100644
--- a/docs-ja/pages/self-hosted-environments-deploy-en.md
+++ b/docs-ja/pages/self-hosted-environments-deploy-en.md
@@ -423,4 +423,6 @@ If tool traffic must stay inside your network, run the equivalent tools as local
 A session holding a background task that never finishes doesn't count as idle, so `--release-idle-session-min` won't release that session's slot. A session that's waiting on an approval requested from inside a running tool call also doesn't count as idle. Always set `--kill-session-after-min` alongside it as a hard backstop so no session can hold a slot indefinitely.
 
+`--kill-session-after-min` is a backstop for runaway sessions. The runner terminates any session that reaches the limit, even one someone is still using, so set the flag well above your longest expected session, such as `--kill-session-after-min 480` for 8 hours. To free slots from conversations that go idle, use `--release-idle-session-min` instead.
+
 ### Additional limitations
 
```

</details>

<details>
<summary>self-hosted-environments-reference-en.md</summary>

```diff
diff --git a/docs-ja/pages/self-hosted-environments-reference-en.md b/docs-ja/pages/self-hosted-environments-reference-en.md
index 4d1a4d3..4ee3e7c 100644
--- a/docs-ja/pages/self-hosted-environments-reference-en.md
+++ b/docs-ja/pages/self-hosted-environments-reference-en.md
@@ -38,5 +38,5 @@ Most flags have a corresponding environment variable. When both are set, the fla
 | `--health-port <port>`                    | `SELF_HOSTED_RUNNER_HEALTH_PORT`                  | `8080`                        | Port for the `/healthz` and `/metrics` listener. Set `0` to disable.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
 | `--hooks-dir <path>`                      | `SELF_HOSTED_RUNNER_HOOKS_DIR`                    | unset                         | Directory of lifecycle hook scripts. See [Lifecycle hooks](/docs/en/self-hosted-environments-configuration#lifecycle-hooks).                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
-| `--kill-session-after-min <n>`            | `SELF_HOSTED_RUNNER_MAX_LIFETIME_MS`              | `0`                           | Terminate a session child once it has lived N minutes wall-clock, as a safety limit for stuck sessions. The runner terminates the session's process tree, including any commands the session left running. The runner defers a kill that falls mid-turn until the turn finishes, for at most the [`SELF_HOSTED_RUNNER_MAX_LIFETIME_GRACE_MS`](#environment-variable-only-settings) window. `0` disables.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
+| `--kill-session-after-min <n>`            | `SELF_HOSTED_RUNNER_MAX_LIFETIME_MS`              | `0`                           | Terminate a session child once it has lived N minutes wall-clock, as a safety limit for stuck sessions. The runner terminates the session's process tree, including any commands the session left running. The runner defers a kill that falls mid-turn until the turn finishes, for at most the [`SELF_HOSTED_RUNNER_MAX_LIFETIME_GRACE_MS`](#environment-variable-only-settings) window. To choose a value, see [Some sessions don't count as idle](/docs/en/self-hosted-environments-deploy#some-sessions-don’t-count-as-idle). `0` disables.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
 | `--lock-to-account <id>`                  | `SELF_HOSTED_RUNNER_LOCK_TO_ACCOUNT`              | unset                         | Pre-lock the runner to a specific account at startup instead of locking on first session. Accepts an email address or `user_...` ID in the environment's organization. A pre-locked runner never picks up Claude Tag channel sessions, which have no account.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
 | `--log-file <path>`                       | `SELF_HOSTED_RUNNER_LOG_FILE`                     | unset                         | Mirror runner logs to a file in addition to stdout and stderr, created with `0600` permissions. Required for `self-hosted-runner doctor` to tail logs locally.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
```

</details>

<details>
<summary>settings-reference-en.md</summary>

```diff
diff --git a/docs-ja/pages/settings-reference-en.md b/docs-ja/pages/settings-reference-en.md
index f125a13..1f21e0c 100644
--- a/docs-ja/pages/settings-reference-en.md
+++ b/docs-ja/pages/settings-reference-en.md
@@ -586,228 +586,229 @@ scope: "Which settings files can set the key: user (~/.claude/settings.json), pr
 />
 
-| Key                                                                                             | Description                                                                                                                                                                                                                 | Topic                              | Scope                   |
-| :---------------------------------------------------------------------------------------------- | :-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :--------------------------------- | :---------------------- |
-| [`advisorModel`](#advisormodel)                                                                 | Pick which model answers when Claude asks the [advisor tool](/docs/en/advisor)                                                                                                                                                   | Model and responses                | Any file                |
-| [`agent`](#agent)                                                                               | Start every session as a named [subagent](/docs/en/sub-agents) with its prompt, tools, and model                                                                                                                                 | Agents, sessions, and worktrees    | Any file                |
-| [`agentPushNotifEnabled`](#agentpushnotifenabled)                                               | Let Claude send a [push notification to your phone](/docs/en/remote-control#mobile-push-notifications) when it decides to                                                                                                        | Remote, desktop, and notifications | Any file                |
-| [`allowAllClaudeAiMcps`](#allowallclaudeaimcps)                                                 | Load the [claude.ai connectors](/docs/en/mcp) Claude Code fetches itself alongside a deployed [`managed-mcp.json`](/docs/en/managed-mcp#exclusive-control-with-managed-mcp-json)                                                      | MCP                                | Managed                 |
-| [`allowedChannelPlugins`](#allowedchannelplugins)                                               | Replace the default allowlist of [channel plugins](/docs/en/channels#restrict-which-channel-plugins-can-run) that can push messages                                                                                              | Plugins and skills                 | Managed                 |
-| [`allowedHttpHookUrls`](#allowedhttphookurls)                                                   | Limit which URLs [HTTP hooks](/docs/en/hooks) can target                                                                                                                                                                         | Hooks and automation               | Any file                |
-| [`allowedMcpServers`](#allowedmcpservers)                                                       | Allowlist which [MCP servers](/docs/en/mcp) people can use                                                                                                                                                                       | MCP                                | Any file                |
-| [`allowManagedHooksOnly`](#allowmanagedhooksonly)                                               | Run only the [hooks](/docs/en/hooks) your organization deploys                                                                                                                                                                   | Hooks and automation               | Managed                 |
-| [`allowManagedMcpServersOnly`](#allowmanagedmcpserversonly)                                     | Make the managed [MCP](/docs/en/mcp) allowlist the only one that applies                                                                                                                                                         | MCP                                | Managed                 |
-| [`allowManagedPermissionRulesOnly`](#allowmanagedpermissionrulesonly)                           | Make [managed settings](/docs/en/managed-settings) the only settings source of [permission rules](/docs/en/permissions#managed-settings)                                                                                              | Permission settings                | Managed                 |
-| [`alwaysThinkingEnabled`](#alwaysthinkingenabled)                                               | Turn [extended thinking](/docs/en/model-config#extended-thinking) off for every session                                                                                                                                          | Model and responses                | Any file                |
-| [`apiKeyHelper`](#apikeyhelper)                                                                 | Generate the [API credential](/docs/en/authentication#credential-management) with your own command                                                                                                                               | Authentication and providers       | Any file                |
-| [`askUserQuestionTimeout`](#askuserquestiontimeout)                                             | Let an unanswered question [auto-continue](/docs/en/tools-reference#question-auto-continue-timeout) after idle time                                                                                                              | Interface and terminal             | User or managed         |
-| [`attribution`](#attribution)                                                                   | Customize the attribution Claude Code adds to commits and pull requests                                                                                                                                                     | Git and attribution                | Any file                |
-| [`attribution.commit`](#attribution-commit)                                                     | Change or hide the trailer Claude Code adds to commits                                                                                                                                                                      | Git and attribution                | Any file                |
-| [`attribution.pr`](#attribution-pr)                                                             | Change or hide the attribution line in pull request descriptions                                                                                                                                                            | Git and attribution                | Any file                |
-| [`attribution.sessionUrl`](#attribution-sessionurl)                                             | Omit the claude.ai session link from [cloud](/docs/en/claude-code-on-the-web) and [Remote Control](/docs/en/remote-control) commits                                                                                                   | Git and attribution                | Any file                |
-| [`autoCompactEnabled`](#autocompactenabled)                                                     | Turn [automatic compaction](/docs/en/context-window) off or on                                                                                                                                                                   | Memory and context                 | Any file                |
-| [`autoCompactWindow`](#autocompactwindow)                                                       | Set how full the context gets before Claude Code [compacts](/docs/en/context-window)                                                                                                                                             | Memory and context                 | Any file                |
-| [`autoConnectIde`](#autoconnectide)                                                             | Connect to a running [VS Code](/docs/en/vs-code) or [JetBrains](/docs/en/jetbrains#from-external-terminals) IDE automatically from an external terminal                                                                               | Global config settings             | Global config           |
-| [`autoContinueAtUsageLimit`](#autocontinueatusagelimit)                                         | Wait in the open session and [continue the task automatically](/docs/en/interactive-mode#wait-for-a-usage-limit-to-reset) after a claude.ai usage limit resets                                                                   | Interface and terminal             | User or managed         |
```

</details>

</details>


<details>
<summary>2026-09-03</summary>

**変更ファイル:**

```
 docs-ja/pages/changelog.md                  | 40 +++++++++++++++++++++++++++++
 docs-ja/pages/cross-session-messaging-en.md |  2 +-
 2 files changed, 41 insertions(+), 1 deletion(-)
```

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index b7cc83a..b580854 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,44 @@
 # Changelog
 
+## 2.1.259
+
+- Added `managedMcpServers` managed setting: organizations can provide HTTP/SSE MCP servers to every user (same entry shape as `.mcp.json`); entries that name a command to run are skipped
+- Added `--permission-prompts none` for unattended headless hosts: anything that would prompt is denied automatically while the active permission mode (including auto mode) keeps deciding
+- Added recognition of `glab mr create/merge/close/reopen/note/update` so GitLab merge requests show as `MR !N` in the collapsed tool summary and refresh the footer MR badge
+- Added `--json` to `claude plugin validate` for a machine-readable validation report
+- Fixed concurrent sessions silently reverting each other's `~/.claude.json` changes — workspace trust no longer resets and MCP/project state is no longer lost when running many sessions at once
+- Fixed a conversation whose thinking was rejected once being rejected again on every later turn
+- Fixed Bash `Read()` deny rules not covering files given as option values (`--ignore-revs-file=.env`, `-f.env`, `@file`), `git diff`/`git grep` file operands, or `cd DIR && cat FILE` compounds; `grep -r`/`cp -r` over a directory holding a denied file now asks
+- Fixed the prompt cache being invalidated when the OAuth token refreshed in sessions with telemetry disabled
+- Fixed fullscreen mode showing a blank conversation after a long turn with hundreds of tool calls
+- Fixed auto mode running a turn on a model it doesn't support when a command or skill's frontmatter `model:` named one; the turn now keeps the session model
+- Fixed `CLAUDE_CODE_MAX_CONTEXT_TOKENS` being ignored for Vertex-style model IDs (`@YYYYMMDD` suffix) of model versions Claude Code doesn't recognize
+- Fixed the live output preview of a running shell command hiding its newest lines when an earlier line wrapped
+- Fixed a background GitHub connection check that ran on every launch for claude.ai users; the result is now remembered across launches
+- Fixed `--resume` failing (and `--continue` opening an empty conversation) when a saved session contains an attachment entry with no payload
+- Fixed frontmatter `model:` on custom commands and skills being ignored in interactive sessions
+- Fixed Artifact publishing failing once with an "unexpected parameter `note`" error in conversations continued from an older version
+- Fixed managed `forceRemoteSettingsRefresh` being ignored at startup when a policy helper configured by MDM or the managed settings file had already run
+- Fixed worktree isolation refusing hook-created worktrees on machines where `git rev-parse` fails with a message other than "not a git repository"
+- Fixed OpenTelemetry metrics and events from cloud sessions missing the `user.email`, `organization.id`, and `user.account_uuid` attributes
+- Fixed MCP servers that disconnect while their tools are being listed at startup showing as connected with no tools instead of reporting the error
+- Fixed the file edit permission dialog sometimes showing a changed line cut short with no indication
```

</details>

<details>
<summary>cross-session-messaging-en.md</summary>

```diff
diff --git a/docs-ja/pages/cross-session-messaging-en.md b/docs-ja/pages/cross-session-messaging-en.md
index f9f1019..132778f 100644
--- a/docs-ja/pages/cross-session-messaging-en.md
+++ b/docs-ja/pages/cross-session-messaging-en.md
@@ -123,5 +123,5 @@ Claude finds a message's target on its own, so you don't need to run anything be
 * **Subagents**: agents running inside the current session.
 * **Teammates**: this session's own [agent team](/docs/en/agent-teams) teammates. Before v2.1.239, teammates didn't appear in the listing, though Claude could already message them by name.
-* **Your other local sessions**: Claude Code sessions running on the same machine, including [background sessions](/docs/en/agent-view). A session appears only when it binds an [inbox socket](#the-sessions-inbox-socket). The worker process that the [supervisor process](/docs/en/agent-view#the-supervisor-process) keeps ready for your next background session appears once you dispatch work to it.
+* **Your other local sessions**: Claude Code sessions running on the same machine, including [background sessions](/docs/en/agent-view). A session appears only when it binds an [inbox socket](#the-sessions-inbox-socket).
 * **Your cloud sessions**: your [Claude Code on the web](/docs/en/claude-code-on-the-web) sessions, shown while this session is connected to [Remote Control](/docs/en/remote-control). Claude Code labels them `cloud` in the listing.
 * **Your Remote Control sessions on other machines**: shown while this session is connected to [Remote Control](/docs/en/remote-control), and labeled `Remote Control`. Claude Code shows `offline` as the status of a session whose Remote Control connection has dropped.
```

</details>

</details>


<details>
<summary>2026-09-02</summary>

**変更ファイル:**

```
 docs-ja/pages/changelog.md             | 112 +++++++++++++++++++++++++++++++++
 docs-ja/pages/context-window-ja.md     |   4 +-
 docs-ja/pages/managed-settings-en.md   |   2 +-
 docs-ja/pages/settings-example-en.md   |   4 +-
 docs-ja/pages/settings-reference-en.md | 101 ++++++++++++++++++++++-------
 5 files changed, 194 insertions(+), 29 deletions(-)
```

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index 921b4fb..b7cc83a 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,116 @@
 # Changelog
 
+## 2.1.258
+
+- Fixed Claude Code failing to launch on macOS 12 (Monterey), a regression introduced in 2.1.255
+- Fixed remote and scheduled sessions failing with "user messages must have non-empty content" after a re-sent permission approval could not be applied
+
+## 2.1.257
+
+- Added Claude Fable 5.1 (`claude-fable-5-1`), now the default Fable model — 1M context, $10/$50 per Mtok with $0.25/Mtok cache reads
+- Added "Time format" (`timeFormat`) and `timeZone` settings: 12-hour, 24-hour, 24-hour UTC, or a strftime pattern for the turn-end clock and transcript-view timestamps
+- Added a Containment Escape rule to auto mode so cloud metadata-credential fetches, egress evasion, and cross-tenant reach are no longer auto-approved unless your environment marks them expected
+- Added `CLAUDE_CODE_SUBAGENT_MODEL_FORCE` to apply `CLAUDE_CODE_SUBAGENT_MODEL` (or the main model) to every subagent, ignoring per-spawn and agent-definition model overrides
+- Added `s` in `/effort` to change effort for the current session only, matching `/model`
+- Added a `/doctor` warning for stale sandbox mask files left by a killed session
+- Added a one-time prompt in auto mode before the first file read outside the working directories, with the option to block such reads (`permissions.blockReadsOutsideWorkingDirectories`)
+- Added support for a gateway-supplied `description` on discovered `/model` picker entries (`CLAUDE_CODE_ENABLE_GATEWAY_MODEL_DISCOVERY`); entries without one still read "From gateway"
+- Fixed settings in a `.claude/` folder created after startup not being picked up until restart
+- Fixed sessions dispatched from an agent view opened with `←` always starting in the original session's permission mode, overriding the target directory's `defaultMode` and the agent's `permissionMode`
+- Fixed `keybindings.json` rebinds of Ctrl+G being ignored in `claude agents`; its Ctrl+S / Ctrl+T are now rebindable via the new `Agents` context
+- Fixed background sessions failing to start on macOS npm installs during a self-update, and on Windows when a stale daemon lock file pointed at a reused process id
+- Fixed the working spinner stopping while a response streams behind a slash-command panel
+- Fixed a background session's `state.json` `detail` repeating its own dispatch prompt after a scheduled wake-up
+- Fixed `claude agents` keeping a background session you re-prompted buried in Completed after it finished again; Completed now orders by the latest finish
+- Fixed `claude --bg` from a directory that was just deleted reporting "backgrounded" and leaving a crashed session row; it now prints the reason and exits 1
```

</details>

<details>
<summary>context-window-ja.md</summary>

```diff
diff --git a/docs-ja/pages/context-window-ja.md b/docs-ja/pages/context-window-ja.md
index 860a385..44d79e6 100644
--- a/docs-ja/pages/context-window-ja.md
+++ b/docs-ja/pages/context-window-ja.md
@@ -181,5 +181,5 @@ export const ContextWindow = () => {
     vis: 'hidden',
     desc: 'A PostToolUse hook in `settings.json` runs prettier after every file edit and reports back via `hookSpecificOutput.additionalContext`. That field enters Claude\'s context. Plain stdout on exit 0 does not. It is written to the debug log only.',
-    tip: 'Output JSON with `additionalContext` to send info to Claude. For PostToolUse hooks, exit code 2 surfaces stderr as an error but cannot block since the tool already ran. Keep output concise since it enters context without truncation.',
+    tip: 'Output JSON with `additionalContext` to send info to Claude. For PostToolUse hooks, exit code 2 surfaces stderr as an error but cannot block since the tool already ran. Output over 10,000 characters is saved to a file; Claude gets a preview and the file path instead.',
     link: '/en/hooks-guide'
   }, {
@@ -334,5 +334,5 @@ export const ContextWindow = () => {
     vis: 'full',
     desc: "You ran a shell command with the ! prefix to see which files Claude modified. The command and its output both enter context as part of your message. Useful for grounding Claude in command output without Claude running it.",
-    link: '/en/interactive-mode#bash-mode-with-prefix'
+    link: '/en/interactive-mode#shell-mode-with-prefix'
   }, {
     t: 0.89,
```

</details>

<details>
<summary>managed-settings-en.md</summary>

```diff
diff --git a/docs-ja/pages/managed-settings-en.md b/docs-ja/pages/managed-settings-en.md
index 502de9a..7b21823 100644
--- a/docs-ja/pages/managed-settings-en.md
+++ b/docs-ja/pages/managed-settings-en.md
@@ -329,5 +329,5 @@ The table covers the permission, plugin, and delivery controls. For any key not
 | [`allowManagedHooksOnly`](/docs/en/settings-reference#allowmanagedhooksonly)                                               | When `true`, restricts which hooks run; see [what runs under `allowManagedHooksOnly`](/docs/en/settings-reference#what-runs-under-allowmanagedhooksonly) for the full effect list                                                                                                                                                                                                                                                                                                   |
 | [`allowManagedMcpServersOnly`](/docs/en/settings-reference#allowmanagedmcpserversonly)                                     | When `true`, only `allowedMcpServers` from managed settings are respected. `deniedMcpServers` still merges from all sources. See [Managed MCP configuration](/docs/en/managed-mcp)                                                                                                                                                                                                                                                                                                  |
-| [`allowManagedPermissionRulesOnly`](/docs/en/settings-reference#allowmanagedpermissionrulesonly)                           | Only managed permission rules apply; the entry lists every source it ignores                                                                                                                                                                                                                                                                                                                                                                                                   |
+| [`allowManagedPermissionRulesOnly`](/docs/en/settings-reference#allowmanagedpermissionrulesonly)                           | Makes managed settings the only settings source of permission rules. The entry lists every source it ignores                                                                                                                                                                                                                                                                                                                                                                   |
 | [`blockedMarketplaces`](/docs/en/settings-reference#blockedmarketplaces)                                                   | Blocklist of marketplace sources. Blocked sources are checked before downloading, so they never touch the filesystem. See [managed marketplace restrictions](/docs/en/plugin-marketplaces#managed-marketplace-restrictions)                                                                                                                                                                                                                                                         |
 | [`channelsEnabled`](/docs/en/settings-reference#channelsenabled)                                                           | Allow [channels](/docs/en/channels) for the organization. See [enterprise controls](/docs/en/channels#enterprise-controls) for the default on each plan                                                                                                                                                                                                                                                                                                                                  |
```

</details>

<details>
<summary>settings-example-en.md</summary>

```diff
diff --git a/docs-ja/pages/settings-example-en.md b/docs-ja/pages/settings-example-en.md
index e78fca8..fa6917c 100644
--- a/docs-ja/pages/settings-example-en.md
+++ b/docs-ja/pages/settings-example-en.md
@@ -253,5 +253,5 @@ A `managed-settings.json` file that shows the shape of the managed keys, with on
 * `availableModels` and `enforceAvailableModels` restrict which models sessions can use
 * `permissions.deny` blocks two file reads and `curl`, and `disableBypassPermissionsMode` removes the bypass permission mode
-* `allowManagedPermissionRulesOnly` and `allowManagedMcpServersOnly` make the managed permission and MCP allowlists the only ones that apply
+* [`allowManagedPermissionRulesOnly`](/docs/en/settings-reference#allowmanagedpermissionrulesonly) and [`allowManagedMcpServersOnly`](/docs/en/settings-reference#allowmanagedmcpserversonly) make the managed permission and MCP allowlists the only ones that apply
 * `allowedMcpServers` pins the MCP server by URL
 * `strictKnownMarketplaces` allows one plugin marketplace
@@ -346,5 +346,5 @@ Administrators deploy a file like this as `managed-settings.json`, or the same J
         "disableBypassPermissionsMode": "disable"
       },
-      // Only managed permission rules apply
+      // Ignore permission rules from user, project, and local settings
       "allowManagedPermissionRulesOnly": true,
       // Only the GitHub MCP server, matched by URL rather than by name, since a user can
```

</details>

<details>
<summary>settings-reference-en.md</summary>

```diff
diff --git a/docs-ja/pages/settings-reference-en.md b/docs-ja/pages/settings-reference-en.md
index cf6b752..f125a13 100644
--- a/docs-ja/pages/settings-reference-en.md
+++ b/docs-ja/pages/settings-reference-en.md
@@ -597,5 +597,5 @@ scope: "Which settings files can set the key: user (~/.claude/settings.json), pr
 | [`allowManagedHooksOnly`](#allowmanagedhooksonly)                                               | Run only the [hooks](/docs/en/hooks) your organization deploys                                                                                                                                                                   | Hooks and automation               | Managed                 |
 | [`allowManagedMcpServersOnly`](#allowmanagedmcpserversonly)                                     | Make the managed [MCP](/docs/en/mcp) allowlist the only one that applies                                                                                                                                                         | MCP                                | Managed                 |
-| [`allowManagedPermissionRulesOnly`](#allowmanagedpermissionrulesonly)                           | Make [managed settings](/docs/en/managed-settings) the only source of [permission rules](/docs/en/permissions#managed-settings)                                                                                                       | Permission settings                | Managed                 |
+| [`allowManagedPermissionRulesOnly`](#allowmanagedpermissionrulesonly)                           | Make [managed settings](/docs/en/managed-settings) the only settings source of [permission rules](/docs/en/permissions#managed-settings)                                                                                              | Permission settings                | Managed                 |
 | [`alwaysThinkingEnabled`](#alwaysthinkingenabled)                                               | Turn [extended thinking](/docs/en/model-config#extended-thinking) off for every session                                                                                                                                          | Model and responses                | Any file                |
 | [`apiKeyHelper`](#apikeyhelper)                                                                 | Generate the [API credential](/docs/en/authentication#credential-management) with your own command                                                                                                                               | Authentication and providers       | Any file                |
@@ -693,5 +693,5 @@ scope: "Which settings files can set the key: user (~/.claude/settings.json), pr
 | [`outputStyle`](#outputstyle)                                                                   | Change Claude's role, tone, and output format with an [output style](/docs/en/output-styles)                                                                                                                                     | Model and responses                | Any file                |
 | [`parentSettingsBehavior`](#parentsettingsbehavior)                                             | Apply or drop restrictions an [SDK or IDE host](/docs/en/managed-settings#let-an-embedding-host-add-policy) passes when you deploy [managed settings](/docs/en/managed-settings)                                                      | Enterprise and managed settings    | Managed                 |
-| [`permissionExplainerEnabled`](#permissionexplainerenabled)                                     | Turn off the Ctrl+E command explanation on shell [permission prompts](/docs/en/permissions#permission-system)                                                                                                                    | Global config settings             | Global config           |
+| [`permissionExplainerEnabled`](#permissionexplainerenabled)                                     | Removed in v2.1.257, together with the `Ctrl+E` command explanation on shell permission prompts                                                                                                                             | Global config settings             | Global config           |
 | [`permissions`](#permissions)                                                                   | Set allow, ask, and deny rules and the starting [permission mode](/docs/en/permission-modes)                                                                                                                                     | Permission settings                | Any file                |
 | [`permissions.additionalDirectories`](#permissions-additionaldirectories)                       | Give Claude file access to [directories outside the current one](/docs/en/permissions#working-directories)                                                                                                                       | Permission settings                | Any file                |
@@ -791,4 +791,6 @@ scope: "Which settings files can set the key: user (~/.claude/settings.json), pr
 | [`terminalTitleFromRename`](#terminaltitlefromrename)                                           | Stop [`/rename`](/docs/en/sessions#name-your-sessions) and `--name` from changing the terminal tab title                                                                                                                         | Interface and terminal             | Any file                |
 | [`theme`](#theme)                                                                               | Pick the interface [color theme](/docs/en/terminal-config#match-the-color-theme), built-in or custom                                                                                                                             | Interface and terminal             | Any file                |
+| [`timeFormat`](#timeformat)                                                                     | Show the times in the interface on a 12-hour or 24-hour clock, in UTC, or with a strftime pattern                                                                                                                           | Interface and terminal             | Any file                |
+| [`timeZone`](#timezone)                                                                         | Show the times in the interface in a time zone other than your system's                                                                                                                                                     | Interface and terminal             | Any file                |
 | [`tui`](#tui)                                                                                   | Choose the [fullscreen](/docs/en/fullscreen) or classic terminal renderer                                                                                                                                                        | Interface and terminal             | Any file                |
 | [`ultracode`](#ultracode)                                                                       | Have Claude plan a [workflow](/docs/en/workflows#let-claude-decide-with-ultracode) for each substantive task without being asked                                                                                                 | Model and responses                | Any file                |
@@ -819,5 +821,5 @@ Pick which model answers when Claude calls the server-side [advisor tool](/docs/
 You don't usually edit this key by hand. Run `/advisor` to open a picker that shows the current choice, the models that can advise, and **No advisor**. Claude Code saves your pick to this key in `~/.claude/settings.json`. In a session attached to a remote worker, the pick applies to that session only.
 
-To pick Fable, first accept the [usage-credits consent](/docs/en/advisor#fable-advisor-and-usage-credits) by running `/model fable`. Until you do, picking Fable in `/advisor` saves nothing and Claude Code tells you to run `/model fable` first.
+If your account requires the [usage-credits consent](/docs/en/advisor#fable-advisor-and-usage-credits), accept it first by running `/model fable`. Until you do, picking Fable in `/advisor` saves nothing and Claude Code tells you to run `/model fable` first.
```

</details>

</details>


<details>
<summary>2026-09-01</summary>

**変更ファイル:**

```
 docs-ja/pages/changelog.md                         |  7 ++
 docs-ja/pages/managed-settings-en.md               |  4 +-
 .../pages/self-hosted-environments-testing-en.md   |  6 +-
 docs-ja/pages/settings-example-en.md               |  2 +-
 docs-ja/pages/settings-reference-en.md             | 89 ++++++++++++++++------
 5 files changed, 81 insertions(+), 27 deletions(-)
```

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index b986e00..921b4fb 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,11 @@
 # Changelog
 
+## 2.1.252
+
+- Fixed Bash commands failing with "task output swap refused (tasks dir moved or linked)" on some Macs
+- Fixed "always allow" not saving in a project that has no .claude/settings.local.json yet
+- Fixed Remote Control sessions hosted by Claude Desktop or VS Code stalling for minutes after a tool finished when the connection to claude.ai was degraded
+- Fixed background task notifications with very large failure output (for example git errors on a full disk) making the conversation exceed the API request size limit
+
 ## 2.1.251
 
```

</details>

<details>
<summary>managed-settings-en.md</summary>

```diff
diff --git a/docs-ja/pages/managed-settings-en.md b/docs-ja/pages/managed-settings-en.md
index f9aa752..502de9a 100644
--- a/docs-ja/pages/managed-settings-en.md
+++ b/docs-ja/pages/managed-settings-en.md
@@ -284,4 +284,6 @@ When the policy isn't applying, the `Setting sources` line tells you which of tw
 When a managed settings file, MDM profile, registry value, or server-managed payload fails schema validation, Claude Code first skips the individual entries it can repair, such as one invalid permission rule, with a warning for each, then drops any top-level key whose value still fails and keeps enforcing every remaining valid key. Claude Code is stricter with the `managedSettings` a [`policyHelper`](/docs/en/settings-reference#policyhelper) emits: it makes the same entry repairs, but any schema violation that survives fails the whole helper run, and at startup Claude Code refuses to start, the same as for a helper that exits non-zero. A managed settings file or drop-in file that isn't valid JSON contributes no settings at all; Claude Code reports it with the other validation errors and reads the remaining sources as usual.
 
+If a managed settings file or drop-in file can't be read or parsed and no other admin source supplies a policy, sessions signed in with claude.ai or Claude Console credentials exit at startup with a message to contact an administrator.
+
 To find a dropped entry, look in one of three places:
 
@@ -307,5 +309,5 @@ A few enforcement keys aren't dropped when invalid. Claude Code enforces a stric
 | `sandbox.credentials`         | A recoverable invalid entry is degraded to `mode: "deny"` with a warning; an unrecoverable one is stripped; valid entries stay enforced. See [invalid credential entries](/docs/en/settings-reference#invalid-credential-entries-in-managed-settings)                                   |
 
-`requiredMinimumVersion` and `requiredMaximumVersion` fail open by design: an invalid value is dropped rather than enforced, so a bad policy push can't prevent Claude Code from starting.
+`requiredMinimumVersion` and `requiredMaximumVersion` fail open by design: an invalid value is dropped rather than enforced.
 
 This tolerance applies only to managed settings. User, project, and local settings files remain strict: a file whose JSON or top-level shape fails validation is rejected as a whole and reported, and an individual entry that fails, such as a malformed permission rule, is skipped with a warning while the rest of the file applies.
```

</details>

<details>
<summary>self-hosted-environments-testing-en.md</summary>

```diff
diff --git a/docs-ja/pages/self-hosted-environments-testing-en.md b/docs-ja/pages/self-hosted-environments-testing-en.md
index 6413d48..4271fed 100644
--- a/docs-ja/pages/self-hosted-environments-testing-en.md
+++ b/docs-ja/pages/self-hosted-environments-testing-en.md
@@ -189,5 +189,7 @@ Both `claude -p ... --environment` and `claude -p ... --cloud` authenticate with
 ### Long-lived CI host
 
-Run `claude auth login` once interactively on the machine that executes the script, using a dedicated user account for automation. The token lives in the OS keychain on macOS, or in `~/.claude/.credentials.json` on Linux and Windows. The CLI refreshes the short-lived access token automatically on each invocation, but the underlying refresh-token grant is capped at 30 days from the initial login, so re-run `claude auth login` interactively on that host every 30 days.
+Run `claude auth login` once interactively on the machine that executes the script, using a dedicated user account for automation. Claude Code stores the token in the OS keychain on macOS, or in `~/.claude/.credentials.json` on Linux and Windows. On a macOS host whose Keychain can't be written, as is typical in an SSH session where the login Keychain stays locked, Claude Code stores the token in `~/.claude/.credentials.json` there too. See [Credential management](/docs/en/authentication#credential-management).
+
+The CLI refreshes the short-lived access token automatically on each invocation, but the underlying refresh-token grant is capped at 30 days from the initial login, so re-run `claude auth login` interactively on that host every 30 days.
 
 ### Ephemeral CI runners
@@ -205,5 +207,5 @@ Create and delete environments programmatically so each CI run gets a clean one;
 `$ADMIN_TOKEN` is a claude.ai OAuth access token for an account that holds an Owner role, minted the same way as [Authenticate from CI](#authenticate-from-ci):
 
-* **Mint it**: run `claude auth login` with an account that holds an Owner role, then read the current access token from the OS keychain on macOS or `~/.claude/.credentials.json` on Linux and Windows.
+* **Mint it**: run `claude auth login` with an account that holds an Owner role, then read the current access token from wherever [Long-lived CI host](#long-lived-ci-host) says Claude Code stored it.
 * **Read it fresh each run**: the CLI rotates the access token, and the same 30-day refresh-grant cap applies, so don't store a copy.
 * **Pass it via stdin**: as the example does, so the token never lands in curl's argument list or your build log.
```

</details>

<details>
<summary>settings-example-en.md</summary>

```diff
diff --git a/docs-ja/pages/settings-example-en.md b/docs-ja/pages/settings-example-en.md
index 96e3bfc..e78fca8 100644
--- a/docs-ja/pages/settings-example-en.md
+++ b/docs-ja/pages/settings-example-en.md
@@ -57,5 +57,5 @@ One developer's personal settings. It picks a model and effort, adjusts the term
       // Start every session on Sonnet 5
       "model": "claude-sonnet-5",
-      // Reason more deeply than the default high level; /effort saves a new level, and --effort overrides it for one session
+      // Reason more deeply than the default high level on models without a saved level; /effort saves a level per model, and --effort sets one for a single session
       "effortLevel": "xhigh",
       // Vim keybindings in the prompt
```

</details>

<details>
<summary>settings-reference-en.md</summary>

```diff
diff --git a/docs-ja/pages/settings-reference-en.md b/docs-ja/pages/settings-reference-en.md
index 8f9c399..cf6b752 100644
--- a/docs-ja/pages/settings-reference-en.md
+++ b/docs-ja/pages/settings-reference-en.md
@@ -651,5 +651,5 @@ scope: "Which settings files can set the key: user (~/.claude/settings.json), pr
 | [`disableWorkflows`](#disableworkflows)                                                         | Turn [dynamic workflows](/docs/en/workflows) off for everyone; use `enableWorkflows` for yourself                                                                                                                                | Hooks and automation               | Any file                |
 | [`editorMode`](#editormode)                                                                     | Use [vim key bindings](/docs/en/interactive-mode#vim-editor-mode) in the input prompt                                                                                                                                            | Interface and terminal             | Any file                |
-| [`effortLevel`](#effortlevel)                                                                   | Save the [`/effort` level](/docs/en/model-config#adjust-effort-level) so future sessions reason more or less deeply                                                                                                              | Model and responses                | Any file                |
+| [`effortLevel`](#effortlevel)                                                                   | Set a default [effort level](/docs/en/model-config#adjust-effort-level) for models without a saved level of their own                                                                                                            | Model and responses                | Any file                |
 | [`emojiCompletionEnabled`](#emojicompletionenabled)                                             | Turn off [`:shortcode:` emoji suggestions and replacement](/docs/en/interactive-mode#emoji-shortcodes) in the prompt input                                                                                                       | Interface and terminal             | Any file                |
 | [`enableAllProjectMcpServers`](#enableallprojectmcpservers)                                     | Approve every server in project [`.mcp.json`](/docs/en/mcp#project-server-approvals-and-workspace-trust) files without a prompt                                                                                                  | MCP                                | Any file                |
@@ -689,4 +689,5 @@ scope: "Which settings files can set the key: user (~/.claude/settings.json), pr
 | [`modelPicker`](#modelpicker)                                                                   | Choose which models the [`/model` picker](/docs/en/model-config#available-models) lists, in your own order and with your own labels                                                                                              | Model and responses                | User or managed         |
 | [`modelPricing`](#modelpricing)                                                                 | Report spend at your organization's contracted rates instead of list price                                                                                                                                                  | Model and responses                | Managed                 |
+| [`modelSettings`](#modelsettings)                                                               | Keep a saved [effort level](/docs/en/model-config#adjust-effort-level) per model, which Claude Code writes when you run `/effort`                                                                                                | Model and responses                | Any file                |
 | [`otelHeadersHelper`](#otelheadershelper)                                                       | Generate rotating [OpenTelemetry](/docs/en/monitoring-usage#dynamic-headers) headers with your own command                                                                                                                       | Authentication and providers       | Any file                |
 | [`outputStyle`](#outputstyle)                                                                   | Change Claude's role, tone, and output format with an [output style](/docs/en/output-styles)                                                                                                                                     | Model and responses                | Any file                |
@@ -785,5 +786,5 @@ scope: "Which settings files can set the key: user (~/.claude/settings.json), pr
 | [`syncClaudeAiSkills`](#syncclaudeaiskills)                                                     | Stop downloading the [skills enabled on your claude.ai account](/docs/en/skills#how-synced-skills-behave) and hide the ones already synced                                                                                       | Plugins and skills                 | User, local, or managed |
 | [`syntaxHighlightingDisabled`](#syntaxhighlightingdisabled)                                     | Turn off syntax highlighting in diffs and code blocks                                                                                                                                                                       | Interface and terminal             | Any file                |
-| [`teammateDefaultModel`](#teammatedefaultmodel)                                                 | Removed in v2.1.234; [teammates](/docs/en/agent-teams#specify-teammates-and-models) follow the lead's model                                                                                                                      | Global config settings             | Global config           |
+| [`teammateDefaultModel`](#teammatedefaultmodel)                                                 | Removed in v2.1.234; see [Specify teammates and models](/docs/en/agent-teams#specify-teammates-and-models) for how Claude Code picks a teammate's model                                                                          | Global config settings             | Global config           |
 | [`teammateMode`](#teammatemode)                                                                 | Choose how [agent team teammates display](/docs/en/agent-teams#choose-a-display-mode)                                                                                                                                            | Agents, sessions, and worktrees    | Any file                |
 | [`terminalProgressBarEnabled`](#terminalprogressbarenabled)                                     | Hide the terminal progress bar in terminals that support it                                                                                                                                                                 | Interface and terminal             | Any file                |
@@ -872,5 +873,7 @@ See [Restrict model selection](/docs/en/model-config#restrict-model-selection).
 ### `effortLevel`
 
-Keep an [effort level](/docs/en/model-config#adjust-effort-level) across sessions. Lower levels are faster and cheaper on straightforward tasks, and higher levels reason more deeply on complex problems. Claude Code writes this key to your user settings when you run `/effort low`, `medium`, `high`, or `xhigh` in an interactive session on your machine. In a `-p` run, the Agent SDK, or a session attached to a remote worker, `/effort` applies to that session only. The message `/effort` prints says which happened.
+Set a default [effort level](/docs/en/model-config#adjust-effort-level) for models you haven't saved a level for. Lower levels are faster and cheaper on straightforward tasks, and higher levels reason more deeply on complex problems.
+
```

</details>

</details>


<details>
<summary>2026-08-31</summary>

**変更ファイル:**

```
 docs-ja/pages/managed-settings-en.md   |  2 +-
 docs-ja/pages/settings-reference-en.md | 38 +++++++++++++++++++++++++++-------
 2 files changed, 32 insertions(+), 8 deletions(-)
```

<details>
<summary>managed-settings-en.md</summary>

```diff
diff --git a/docs-ja/pages/managed-settings-en.md b/docs-ja/pages/managed-settings-en.md
index 3b35769..f9aa752 100644
--- a/docs-ja/pages/managed-settings-en.md
+++ b/docs-ja/pages/managed-settings-en.md
@@ -193,5 +193,5 @@ To confirm which sources combined on a machine, [read the `Setting sources` line
 A [`policyHelper`](/docs/en/settings-reference#policyhelper) is an executable your MDM policy or managed settings file names, and Claude Code runs it to compute managed settings at startup. When the selected source configures one and the helper emits a `managedSettings` object, that output changes what Claude Code reads:
 
-* **The emitted `managedSettings` object is the only managed settings for the session**, including for the [keys it otherwise reads from every admin source](#keys-read-from-every-admin-source), apart from `forceRemoteSettingsRefresh`, which Claude Code checks in every admin source at startup before the helper runs. A helper that exits 0 without emitting one contributes nothing, and the sources apply as usual; a helper that fails stops Claude Code from starting, as the [`policyHelper`](/docs/en/settings-reference#policyhelper) entry describes
+* **The emitted `managedSettings` object is the only managed settings for the session**, including for the [keys it otherwise reads from every admin source](#keys-read-from-every-admin-source), apart from `forceRemoteSettingsRefresh`, which Claude Code checks in every admin source at startup before the helper runs. For which helper runs fail, and what Claude Code does when one does, see [Helper failures](/docs/en/settings-reference#helper-failures)
 
 Claude Code selects the source at startup, and that selection decides whether a helper runs. The [`policyHelper`](/docs/en/settings-reference#policyhelper) entry says which sources can configure a helper.
```

</details>

<details>
<summary>settings-reference-en.md</summary>

```diff
diff --git a/docs-ja/pages/settings-reference-en.md b/docs-ja/pages/settings-reference-en.md
index 3860dde..8f9c399 100644
--- a/docs-ja/pages/settings-reference-en.md
+++ b/docs-ja/pages/settings-reference-en.md
@@ -1668,5 +1668,5 @@ An unsandboxed retry goes through the regular permission flow: a prompt in Manua
 ### `sandbox.filesystem`
 
-Control which paths sandboxed commands can read and write. By default they can write to the working directory, any directories you add with `--add-dir`, and the session temp directory, and can read the rest of the filesystem, including credential files. Widen or narrow that with the four path lists, or switch the filesystem layer off with `disabled`. See [Filesystem isolation](/docs/en/sandboxing#filesystem-isolation) for the default boundaries.
+Control which paths sandboxed commands can read and write. By default they can write to the working directory, the session temp directory, and directories you add with `--add-dir`, `/add-dir`, or `permissions.additionalDirectories`, and can read the rest of the filesystem, including credential files. Widen or narrow that with the four path lists, or switch the filesystem layer off with `disabled`. See [Filesystem isolation](/docs/en/sandboxing#filesystem-isolation) for the default boundaries.
 
 * **Scope**: [`Any file`](#scopes)
@@ -1714,9 +1714,9 @@ Claude Code also removes a trailing `/**`, so `~/build/**` and `~/build` cover t
 ### `sandbox.filesystem.allowWrite`
 
-Add paths where sandboxed commands can write, beyond the working directory, the directories you've added with `--add-dir` or `/add-dir`, and the session temp directory. Use it when a subprocess such as `kubectl` or a build tool needs to write outside the project.
+Add paths where sandboxed commands can write, beyond the working directory, the session temp directory, and the directories you've added with `--add-dir`, `/add-dir`, or `permissions.additionalDirectories`. Use it when a subprocess such as `kubectl` or a build tool needs to write outside the project.
 
 * **Scope**: [`Any file`](#scopes)
 * **Type**: array of path strings, using the [sandbox path prefixes](#sandbox-path-prefixes)
-* **Default**: unset, so sandboxed commands can write only to the working directory, any directories you've added with `--add-dir` or `/add-dir`, and the session temp directory
+* **Default**: unset, so sandboxed commands can write to the working directory, the session temp directory, directories you've added with `--add-dir` or `/add-dir`, and directories in [`permissions.additionalDirectories`](#permissions-additionaldirectories)
 
 This lets a build write under `/tmp/build` and lets `kubectl` update your kubeconfig:
@@ -5470,5 +5470,7 @@ This example runs the helper with a 5-second timeout and re-runs it every five m
 #### Write the helper output
 
-Claude Code runs the helper with no arguments, sets `CLAUDE_CODE_VERSION` in its environment, and reads a JSON envelope from stdout, capped at 1 MB. Put the settings under a `managedSettings` key. A bare settings object with no `managedSettings` key parses with `managedSettings` undefined and applies nothing, and Claude Code reports no error:
+Claude Code runs the helper with no arguments, sets `CLAUDE_CODE_VERSION` in its environment, and reads a JSON envelope from stdout, capped at 1 MiB.
+
+Put the settings under a `managedSettings` key. A bare settings object with no `managedSettings` key parses with `managedSettings` undefined and applies nothing, and Claude Code reports no error:
```

</details>

</details>


<details>
<summary>2026-08-30</summary>

**変更ファイル:**

```
 docs-ja/pages/hooks-guide-ja.md                     |  2 ++
 docs-ja/pages/hooks-ja.md                           |  4 +++-
 docs-ja/pages/managed-settings-en.md                | 20 ++++++++++++++++++++
 docs-ja/pages/plugins-reference-ja.md               |  2 ++
 docs-ja/pages/self-hosted-environments-deploy-en.md |  2 +-
 docs-ja/pages/settings-reference-en.md              | 15 +++++++++++++++
 6 files changed, 43 insertions(+), 2 deletions(-)
```

<details>
<summary>hooks-guide-ja.md</summary>

```diff
diff --git a/docs-ja/pages/hooks-guide-ja.md b/docs-ja/pages/hooks-guide-ja.md
index ca3cd7b..bf36e1b 100644
--- a/docs-ja/pages/hooks-guide-ja.md
+++ b/docs-ja/pages/hooks-guide-ja.md
@@ -489,4 +489,6 @@ Hook イベントは Claude Code のライフサイクルの特定のポイン
 | `PreCompact`          | Before context compaction                                                                                                                                                                                                                             |
 | `PostCompact`         | After context compaction completes                                                                                                                                                                                                                    |
+| `PreModelSwitch`      | Before Claude Code applies a model switch that you or a client requested. Can block the switch                                                                                                                                                        |
+| `PostModelSwitch`     | After the session's model changes, including changes Claude Code makes on its own, such as restoring the model when you resume a session                                                                                                              |
 | `Elicitation`         | When an MCP server requests user input during a tool call                                                                                                                                                                                             |
 | `ElicitationResult`   | After a user responds to an MCP elicitation, before the response is sent back to the server                                                                                                                                                           |
```

</details>

<details>
<summary>hooks-ja.md</summary>

```diff
diff --git a/docs-ja/pages/hooks-ja.md b/docs-ja/pages/hooks-ja.md
index 8f46884..8b0e7b7 100644
--- a/docs-ja/pages/hooks-ja.md
+++ b/docs-ja/pages/hooks-ja.md
@@ -27,5 +27,5 @@
 <div style={{maxWidth: "500px", margin: "0 auto"}}>
   <Frame>
-    <img src="https://mintcdn.com/claude-code/jhXrDR5TrSZ5hgXM/images/hooks-lifecycle.svg?fit=max&auto=format&n=jhXrDR5TrSZ5hgXM&q=85&s=3ca47113d5956460e6e4611b8dbc63b7" alt="オプションの Setup から SessionStart に流れ込み、その後、UserPromptSubmit、スラッシュ コマンド用の UserPromptExpansion、ネストされた agentic ループ（PreToolUse、PermissionRequest、PostToolUse、PostToolUseFailure、PostToolBatch、SubagentStart/Stop、TaskCreated、TaskCompleted）、Stop または StopFailure を含むターンごとのループ、その後 TeammateIdle、PreCompact、PostCompact、SessionEnd が続き、Elicitation と ElicitationResult は MCP ツール実行内にネストされ、PermissionDenied は PermissionRequest からの副分岐として自動モード拒否のため、WorktreeCreate、WorktreeRemove、Notification、ConfigChange、InstructionsLoaded、CwdChanged、FileChanged はスタンドアロン非同期イベントとして表示されるフック ライフサイクル図" width="520" height="1228" data-path="images/hooks-lifecycle.svg" />
+    <img src="https://mintcdn.com/claude-code/x7pO8l4XcvAXCoVc/images/hooks-lifecycle.svg?fit=max&auto=format&n=x7pO8l4XcvAXCoVc&q=85&s=81b9256c1bbe8832553485f5d9e9c746" alt="オプションの Setup から SessionStart に流れ込み、その後、UserPromptSubmit、スラッシュ コマンド用の UserPromptExpansion、ネストされた agentic ループ（PreToolUse、PermissionRequest、PostToolUse、PostToolUseFailure、PostToolBatch、SubagentStart/Stop、TaskCreated、TaskCompleted）、Stop または StopFailure を含むターンごとのループ、その後 TeammateIdle、PreCompact、PostCompact、SessionEnd が続き、Elicitation と ElicitationResult は MCP ツール実行内にネストされ、PermissionDenied は PermissionRequest からの副分岐として自動モード拒否のため、WorktreeCreate、WorktreeRemove、Notification、ConfigChange、InstructionsLoaded、CwdChanged、FileChanged はスタンドアロン非同期イベントとして表示されるフック ライフサイクル図" width="520" height="1336" data-path="images/hooks-lifecycle.svg" />
   </Frame>
 </div>
@@ -63,4 +63,6 @@
 | `PreCompact`          | Before context compaction                                                                                                                                                                                                                             |
 | `PostCompact`         | After context compaction completes                                                                                                                                                                                                                    |
+| `PreModelSwitch`      | Before Claude Code applies a model switch that you or a client requested. Can block the switch                                                                                                                                                        |
+| `PostModelSwitch`     | After the session's model changes, including changes Claude Code makes on its own, such as restoring the model when you resume a session                                                                                                              |
 | `Elicitation`         | When an MCP server requests user input during a tool call                                                                                                                                                                                             |
 | `ElicitationResult`   | After a user responds to an MCP elicitation, before the response is sent back to the server                                                                                                                                                           |
```

</details>

<details>
<summary>managed-settings-en.md</summary>

```diff
diff --git a/docs-ja/pages/managed-settings-en.md b/docs-ja/pages/managed-settings-en.md
index 12e6573..3b35769 100644
--- a/docs-ja/pages/managed-settings-en.md
+++ b/docs-ja/pages/managed-settings-en.md
@@ -348,4 +348,24 @@ The table covers the permission, plugin, and delivery controls. For any key not
 </Note>
 
+## Turn telemetry off for your organization
+
+Claude Code sends Anthropic operational [telemetry](/docs/en/data-usage#telemetry-services) by default on sessions that use the Anthropic API, whether directly, through an LLM gateway, or through a custom `ANTHROPIC_BASE_URL`; [Default behaviors by API provider](/docs/en/data-usage#default-behaviors-by-api-provider) says which providers send it. To turn it off for every developer without relying on each person's shell, deliver `DISABLE_TELEMETRY` through the `env` block of your managed settings. This example sets `DISABLE_TELEMETRY` for everyone the policy reaches:
+
+```json theme={null}
+{
+  "env": {
+    "DISABLE_TELEMETRY": "1"
+  }
+}
+```
+
+Claude Code applies a value of `1` without showing the user the [approval dialog](/docs/en/server-managed-settings#environment-variables-and-the-approval-dialog).
+
+If you turn telemetry off, Claude Code stops sending the usage data that feeds your organization's [analytics dashboard](/docs/en/analytics) for the developers the policy reaches. The variable also turns off feature-flag fetching, which makes Remote Control, default auto mode, and the other [features that need feature-flag fetching](/docs/en/env-vars#features-that-need-feature-flag-fetching) unavailable for those developers.
+
+[Where and when a policy applies](#where-and-when-a-policy-applies) says which delivery mechanism reaches each surface, and [Platform availability](/docs/en/server-managed-settings#platform-availability) says which sessions skip the server-managed settings fetch.
+
+If your organization uses customer-managed encryption keys and routes Claude Code through a gateway, [Configure proxies and gateways](/docs/en/third-party-integrations#configure-proxies-and-gateways) says why those sessions need this variable.
+
 ## See also
 
```

</details>

<details>
<summary>plugins-reference-ja.md</summary>

```diff
diff --git a/docs-ja/pages/plugins-reference-ja.md b/docs-ja/pages/plugins-reference-ja.md
index 9a064ae..6ad3607 100644
--- a/docs-ja/pages/plugins-reference-ja.md
+++ b/docs-ja/pages/plugins-reference-ja.md
@@ -149,4 +149,6 @@ disallowedTools: Write, Edit
 | `PreCompact`          | Before context compaction                                                                                                                                                                                                                             |
 | `PostCompact`         | After context compaction completes                                                                                                                                                                                                                    |
+| `PreModelSwitch`      | Before Claude Code applies a model switch that you or a client requested. Can block the switch                                                                                                                                                        |
+| `PostModelSwitch`     | After the session's model changes, including changes Claude Code makes on its own, such as restoring the model when you resume a session                                                                                                              |
 | `Elicitation`         | When an MCP server requests user input during a tool call                                                                                                                                                                                             |
 | `ElicitationResult`   | After a user responds to an MCP elicitation, before the response is sent back to the server                                                                                                                                                           |
```

</details>

<details>
<summary>self-hosted-environments-deploy-en.md</summary>

```diff
diff --git a/docs-ja/pages/self-hosted-environments-deploy-en.md b/docs-ja/pages/self-hosted-environments-deploy-en.md
index 550f7ed..186f418 100644
--- a/docs-ja/pages/self-hosted-environments-deploy-en.md
+++ b/docs-ja/pages/self-hosted-environments-deploy-en.md
@@ -30,5 +30,5 @@ A self-hosted runner executes arbitrary, model-directed code on your infrastruct
   The block applies to your wrapper script and lifecycle hooks too, since they share the container. Authenticate any token exchange with the [session JWT](/docs/en/self-hosted-environments-identity) against your own token service over allowlisted egress, or use a file-based web identity such as IAM Roles for Service Accounts (IRSA) on Amazon EKS.
 * **Per-runner filesystem isolation**: each runner process gets its own working directory that no other process on the host can read or write. Make `--hooks-dir`, the wrapper script, and the host's `~/.claude/` read-only to the session, either built into the image or mounted read-only.
-* **Dispatch has no per-environment access control**: any member of your Anthropic organization can dispatch a session to any of its environments. If an Owner [routes Claude Tag channels to the environment](/docs/en/cloud-environments#organization-shared-environments), anyone the [Claude Tag access setting](https://claude.com/docs/claude-tag/admins/restrict-access#restrict-who-can-use-claude) admits can start channel sessions that run there. By default that's anyone in the connected Slack workspace, with or without a Claude account. Treat every runner host as reachable for code execution by everyone who can dispatch to it, and place on a runner host only data and credentials that all of those people are allowed to read. [`--lock-to-account`](/docs/en/self-hosted-environments-reference#runner-cli-flags) bounds which account's sessions a given host executes, but it doesn't narrow who can dispatch into the environment. To make self-hosted environments the only picker option, an [Owner](/docs/en/cloud-environments#organization-shared-environments) can hide Anthropic-hosted environments for the whole organization from the [**Cloud environments** page](https://claude.ai/admin-settings/cloud-environments).
+* **Dispatch has no per-environment access control**: any member of your Anthropic organization can dispatch a session to any of its environments. If an Owner [routes Claude Tag channels to the environment](/docs/en/cloud-environments#set-the-environment-a-claude-tag-channel-uses), anyone the [Claude Tag access setting](https://claude.com/docs/claude-tag/admins/restrict-access#restrict-who-can-use-claude) admits can start channel sessions that run there. By default that's anyone in the connected Slack workspace, with or without a Claude account. Treat every runner host as reachable for code execution by everyone who can dispatch to it, and place on a runner host only data and credentials that all of those people are allowed to read. [`--lock-to-account`](/docs/en/self-hosted-environments-reference#runner-cli-flags) bounds which account's sessions a given host executes, but it doesn't narrow who can dispatch into the environment. To make self-hosted environments the only picker option, an [Owner](/docs/en/cloud-environments#organization-shared-environments) can hide Anthropic-hosted environments for the whole organization from the [**Cloud environments** page](https://claude.ai/admin-settings/cloud-environments).
 * **Enforce the repo-settings guard**: choose the guard mode with [`--confine-repo-settings`](/docs/en/self-hosted-environments-reference#runner-cli-flags). The default `warn` logs a violation and still spawns the session, `enforce` refuses the session, and `off` disables the scan. The runner scans each repository's committed settings for:
 
```

</details>

<details>
<summary>settings-reference-en.md</summary>

```diff
diff --git a/docs-ja/pages/settings-reference-en.md b/docs-ja/pages/settings-reference-en.md
index eea7069..3860dde 100644
--- a/docs-ja/pages/settings-reference-en.md
+++ b/docs-ja/pages/settings-reference-en.md
@@ -631,4 +631,5 @@ scope: "Which settings files can set the key: user (~/.claude/settings.json), pr
 | [`defaultShell`](#defaultshell)                                                                 | Choose whether Bash or PowerShell runs the shell commands you type with the [`!` prefix](/docs/en/interactive-mode#shell-mode-with-prefix)                                                                                       | Interface and terminal             | Any file                |
 | [`deniedMcpServers`](#deniedmcpservers)                                                         | Block specific [MCP servers](/docs/en/mcp) by URL, command, or name                                                                                                                                                              | MCP                                | Any file                |
+| [`desktopSessionCleanupPeriodDays`](#desktopsessioncleanupperioddays)                           | Set an age limit in days for [Claude Desktop and Cowork transcripts](/docs/en/claude-directory#cleaned-up-automatically)                                                                                                         | Privacy and telemetry              | User or managed         |
 | [`dialogExpiry`](#dialogexpiry)                                                                 | Set how long Claude Code waits for [Remote Control](/docs/en/remote-control) or an SDK host to answer a forwarded dialog before it cancels the dialog                                                                            | Interface and terminal             | User or managed         |
 | [`diffTool`](#difftool)                                                                         | Choose whether Claude's proposed file changes open in the [VS Code](/docs/en/vs-code) or [JetBrains](/docs/en/jetbrains#features) diff viewer or stay in the terminal                                                                 | Global config settings             | Global config           |
@@ -5274,4 +5275,18 @@ Set how many days Claude Code keeps [session transcripts and other application d
 Setting `0` fails validation, so pick a large value such as `3650` for long retention. To stop Claude Code from writing transcripts at all, see [Plaintext storage](/docs/en/claude-directory#plaintext-storage).
 
+### `desktopSessionCleanupPeriodDays`
+
+Set an age limit in days for the transcripts of sessions you started or most recently continued in Claude Desktop or Cowork. Without this key, Claude Code [keeps those transcripts at any age](/docs/en/claude-directory#cleaned-up-automatically). Claude Code deletes each one once it's older than both this limit and [`cleanupPeriodDays`](#cleanupperioddays), so with `cleanupPeriodDays` at its default of 30, a value of `7` still keeps them 30 days. When managed settings set `cleanupPeriodDays`, that period applies instead and this key is ignored. Requires Claude Code v2.1.248 or later.
+
+* **Scope**: [`User or managed`](#scopes). Claude Code also reads the key from a file you pass with `--settings`, and ignores it in project and local settings.
+* **Type**: number of days, a whole number, minimum `0`
+* **Default**: `0`, which sets no age limit
+
+```json settings.json theme={null}
+{
+  "desktopSessionCleanupPeriodDays": 90
+}
+```
+
 ### `feedbackDrafts`
 
```

</details>

</details>


<details>
<summary>2026-08-29</summary>

**変更ファイル:**

```
 docs-ja/pages/changelog.md                         | 74 ++++++++++++++++++++++
 docs-ja/pages/cross-session-messaging-en.md        |  6 +-
 docs-ja/pages/managed-settings-en.md               |  4 +-
 .../self-hosted-environments-configuration-en.md   |  2 +-
 .../pages/self-hosted-environments-deploy-en.md    |  8 ++-
 docs-ja/pages/self-hosted-environments-en.md       |  2 +-
 .../pages/self-hosted-environments-identity-en.md  |  2 +-
 .../pages/self-hosted-environments-reference-en.md |  3 +-
 docs-ja/pages/settings-reference-en.md             | 72 ++++++++++++++++++---
 9 files changed, 152 insertions(+), 21 deletions(-)
```

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index 2ac5610..b986e00 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,78 @@
 # Changelog
 
+## 2.1.251
+
+- Added `PreModelSwitch` and `PostModelSwitch` hook events (block, confirm, or annotate a model switch); `SessionStart` resume hooks now receive session staleness and the estimated re-cache cost
+- Added live streaming of a foreground subagent's tool calls and results to Remote Control clients (background subagents, the default, still show status only)
+- Added a Spend limit bar to `/usage` and a `rate_limits.spend_limit` status line field for developers behind a Claude apps gateway with spend limits
+- Added a per-session prompt-cache line to `/cost` (hit ratio, misses, tokens re-cached, warm/cold) and a matching `prompt_cache` object for status line scripts
+- Added `attach`, `logs`, `stop`, `respawn`, and `rm` to `claude --help`; the `--resume` message for a running background session now names the exact `claude attach <id>` command
+- Fixed file tools (Read, Write, Edit) following a symlink swapped inside the working directory after the permission check, which could read or write outside the approved location
+- Fixed plugin commands declared in a marketplace entry being able to point outside the plugin directory; such paths are now rejected with a path-traversal error
+- Fixed project settings being able to enable detailed beta tracing or raw API body logging, and a lower-scope beta tracing endpoint bypassing an OTLP collector pinned by managed settings or a host app
+- Fixed the Workflow tool reading (and quoting in errors) a `scriptPath` outside what the session may read before the permission check ran
+- Fixed Grep and Glob not applying `Read(...)` deny rules to files reached through a symlinked search path
+- Fixed conversations getting stuck on "text content blocks must be non-empty" errors after a turn where the model produced only thinking
+- Fixed the first launch on a fresh install starting in default mode instead of auto mode for accounts whose startup default is auto mode
+- Fixed Opus 5 requests failing with "effort … is not supported when thinking is disabled" when effort was xhigh/max and thinking was turned off; effort is now sent as `high` in that case
+- Fixed replying to a message Claude Desktop delivered from another session: `SendMessage` to that session id now delivers through Claude Desktop instead of failing with "not reachable"
+- Fixed TUI lag with many parallel subagents: per-second progress ticks now replace their predecessor instead of piling up in the transcript
+- Fixed agent teams: a teammate's final answer not reaching the team lead — it now arrives in the idle notification instead of a content-free "available" notice
+- Fixed background subagents being unable to reply to a message from an unnamed sibling or parent agent (`from` was the agent type, which is not an address)
+- Fixed managed-settings `disableAutoMode` arriving mid-session not moving an already-running auto-mode session back to default mode
+- Fixed a "switch to Opus 1M for 5x more context" tip that appeared even when the current Opus model already has a 1M context window
+- Fixed Claude apps gateway sessions treating a stored Anthropic profile (e.g. a Console sign-in) as active: listing it in `/status` and retrying gateway 401s with it, though requests never use it
+- Fixed cloud sessions telling Claude the model had changed when the host was only setting the session's initial model
```

</details>

<details>
<summary>cross-session-messaging-en.md</summary>

```diff
diff --git a/docs-ja/pages/cross-session-messaging-en.md b/docs-ja/pages/cross-session-messaging-en.md
index 6def44b..f9f1019 100644
--- a/docs-ja/pages/cross-session-messaging-en.md
+++ b/docs-ja/pages/cross-session-messaging-en.md
@@ -69,7 +69,5 @@ For what the message Claude writes looks like when it arrives, including an exam
 The receiving Claude reads the message between tool calls during an active turn, so a running tool is never interrupted. When the receiving session is idle, Claude Code starts a new turn with the message.
 
-When a message that starts a new turn mentions a file as an `@` immediately followed by its path, Claude Code [attaches that file](/docs/en/common-workflows#reference-files-and-directories) as it exists on the receiving machine, resolving a relative path from the receiving session's working directory. The receiving session's [`Read` deny rules](/docs/en/permissions#read-and-edit) apply to that file, as they do to a file you mention with `@` yourself. When such a message mentions an [MCP resource](/docs/en/mcp#use-mcp-resources) with `@`, Claude Code attaches that resource from the receiving session's MCP servers. A path written without the `@` stays plain text and attaches nothing.
-
-A message that Claude reads during an active turn arrives as plain text with nothing attached, even if it mentions files or MCP resources with `@`.
+A message from another session arrives as plain text. If it mentions a file or an [MCP resource](/docs/en/mcp#use-mcp-resources) with `@`, Claude sees the mention as written and Claude Code attaches nothing, whether the message starts a new turn or arrives during one. Claude can still open a mentioned path on the receiving machine with its own tools, subject to that session's permissions. Before v2.1.251, an `@` mention in a message that started a new turn attached the file or MCP resource on the receiving side.
 
 Claude Code refuses a message in the following cases:
@@ -196,5 +194,5 @@ Either of these shows you the full text:
 The preview shortens only what you see. Whether or not you expand it, Claude reads the full message.
 
-Claude receives the message with the sender's name and a reply address, except for a [one-way cross-machine message](#message-sessions-on-other-machines), which carries no reply address. Beyond the name and reply address, the receiving Claude gets the message's text, never the sender's conversation history or files. An `@` mention in the text can still attach a file or MCP resource on the receiving side, as described under [Message delivery](#message-delivery).
+Claude receives the message with the sender's name and a reply address, except for a [one-way cross-machine message](#message-sessions-on-other-machines), which carries no reply address. Beyond the name and reply address, the receiving Claude gets the message's text, never the sender's conversation history or files. [Message delivery](#message-delivery) covers `@` mentions in the text.
 
 A message that a [subagent](/docs/en/sub-agents) wrote arrives under the sending session's name, with the subagent identified in the message text. A reply to it reaches that session's main conversation, not the subagent.
```

</details>

<details>
<summary>managed-settings-en.md</summary>

```diff
diff --git a/docs-ja/pages/managed-settings-en.md b/docs-ja/pages/managed-settings-en.md
index d808cfe..12e6573 100644
--- a/docs-ja/pages/managed-settings-en.md
+++ b/docs-ja/pages/managed-settings-en.md
@@ -274,4 +274,6 @@ When the policy isn't applying, the `Setting sources` line tells you which of tw
 
 * **The line is missing**: Claude Code found no managed source that delivers a policy key. If you deployed a managed settings file, check that it sits at the path for the OS, that it's valid JSON, and that it contains a [policy key](#how-claude-code-combines-managed-sources) rather than only the control keys.
+
+  When you deployed through server-managed settings instead, run `claude doctor`, which reports the [fetch outcome](/docs/en/server-managed-settings#verify-settings-delivery).
 * **The line names a source other than the one you deployed**: a higher-priority source is present and Claude Code ignored yours, and `Skipped sources` lists it. [How Claude Code combines managed sources](#how-claude-code-combines-managed-sources) gives the order.
 
@@ -317,5 +319,5 @@ Claude Code reads the following keys only from a managed source; placing them in
 Most of them are locks: the value a lock governs, such as permission rules or `sandbox.network.allowedDomains`, is an ordinary key that any level can set, and the lock tells Claude Code to honor only the managed value.
 
-The table covers the permission, plugin, and delivery controls. For any key not listed here, the Scope column of the [settings reference](/docs/en/settings-reference#all-settings) index says whether it's managed-only; the remaining managed-only keys there include the gateway login URL, version, browser, mobile-simulator, SSH host, Desktop local-session, sandbox binary path, and CLAUDE.md controls.
+The table covers the permission, plugin, and delivery controls. For any key not listed here, the Scope column of the [settings reference](/docs/en/settings-reference#all-settings) index says whether it's managed-only; the remaining managed-only keys there include the gateway login URL, version, browser, mobile-simulator, SSH host, Desktop local-session, sandbox binary path, model pricing, and CLAUDE.md controls.
 
 | Setting                                                                                                               | Description                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
```

</details>

<details>
<summary>self-hosted-environments-configuration-en.md</summary>

```diff
diff --git a/docs-ja/pages/self-hosted-environments-configuration-en.md b/docs-ja/pages/self-hosted-environments-configuration-en.md
index 20e56bc..1a67b57 100644
--- a/docs-ja/pages/self-hosted-environments-configuration-en.md
+++ b/docs-ja/pages/self-hosted-environments-configuration-en.md
@@ -324,5 +324,5 @@ fi
 #   - clone-based checkouts (origin/* exist)
 #   - the runner default: the child starts on the session's outcome
-#     branch, which the runner creates with checkout -B after checkout
+#     branch, which the runner creates after checkout
 #   - detached HEAD, when a custom setup skips that branch creation
 # With no reference point at all (never fetched), stay silent rather
```

</details>

<details>
<summary>self-hosted-environments-deploy-en.md</summary>

```diff
diff --git a/docs-ja/pages/self-hosted-environments-deploy-en.md b/docs-ja/pages/self-hosted-environments-deploy-en.md
index d4bd500..550f7ed 100644
--- a/docs-ja/pages/self-hosted-environments-deploy-en.md
+++ b/docs-ja/pages/self-hosted-environments-deploy-en.md
@@ -62,5 +62,4 @@ Whether these hosts are needed depends on your configuration:
 | `code.claude.com` and `claude.com`   | 443  | Documentation lookups by the built-in claude-code-guide agent and pre-approved WebFetch requests during sessions. Blocking these hosts only affects documentation lookups.                                                                                                              |
 | `*.frame.claudeusercontent.com`      | 443  | Only when the [Artifact tool](/docs/en/artifacts#availability) is available for sessions in your organization; defaults vary by plan, per the availability table there. Set `CLAUDE_CODE_DISABLE_ARTIFACT=1` on the runner to keep the tool disabled regardless of the organization setting. |
-| `raw.githubusercontent.com`          | 443  | Only for the changelog fetch behind `/release-notes` and the release notes shown after a CLI version change. Suppressed by `CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC=1`.                                                                                                                |
 | `registry.npmjs.org`                 | 443  | When a session installs a plugin, both for fetching npm-source plugin packages and for installing a plugin's Node.js dependencies, or when an `npx`-launched MCP server runs                                                                                                            |
 | `http-intake.logs.us5.datadoghq.com` | 443  | Anthropic operational metrics. Only when `CLAUDE_CODE_BYOC_ENABLE_DATADOG=1` is set; off by default in self-hosted environments.                                                                                                                                                        |
@@ -322,5 +321,7 @@ secrets:
 ## Shutdown timing
 
-On `SIGTERM`, the runner stops taking new work and, unless you set [`--defer-shutdown-max-min`](#defer-the-drain-past-the-first-signal), waits up to `--drain-wait-sec`, zero by default, for in-flight turns to finish, terminates each child process, and runs the [`post-session` lifecycle hook](/docs/en/self-hosted-environments-configuration#post-session). The full drain path needs up to `--session-stop-grace-sec` + `--drain-wait-sec` + `--post-session-hook-timeout-sec`, plus 15 seconds of fixed overhead for process cleanup, plus 30 more seconds when [`--push-outcome-on-release`](/docs/en/self-hosted-environments-reference#runner-cli-flags) is set. That is 80 seconds at defaults, and the runner logs the total at startup. Sessions drain in parallel under this one budget, so the total doesn't grow with `--capacity`.
+On `SIGTERM`, the runner stops taking new work and, unless you set [`--defer-shutdown-max-min`](#defer-the-drain-past-the-first-signal), waits up to `--drain-wait-sec`, zero by default, for in-flight turns to finish, terminates each session's process tree, and runs the [`post-session` lifecycle hook](/docs/en/self-hosted-environments-configuration#post-session). That process tree includes commands Claude was still running in the session.
+
+The full drain path needs up to `--session-stop-grace-sec` + `--drain-wait-sec` + `--post-session-hook-timeout-sec`, plus 15 seconds of fixed overhead for process cleanup, plus 30 more seconds when [`--push-outcome-on-release`](/docs/en/self-hosted-environments-reference#runner-cli-flags) is set. That is 80 seconds at defaults, and the runner logs the total at startup. Sessions drain in parallel under this one budget, so the total doesn't grow with `--capacity`.
 
 At the default `--drain-wait-sec 0`, a rolling restart interrupts in-flight turns; each session resumes on another runner, losing unpushed work as described under [Known issues](#additional-limitations). Set `--drain-wait-sec`, and raise the grace period to match, to let turns finish first.
@@ -434,5 +435,5 @@ For issues with self-hosted environments, contact your Anthropic account team.
 ## Troubleshooting
 
-For guided diagnosis, run the doctor subcommand on the runner host. It starts an interactive Claude Code session with read-only access to the runner's logs and state; the only change it can make is requeuing a stuck session. Sign in with `claude auth login` on that host first so the session can query your environment, its runners, and its queued sessions. Without that sign-in, for example when the host authenticates with an API key, it's limited to the local health endpoint, metrics, and the runner's log, and it reads the log only if you started the runner with `--log-file`.
+For guided diagnosis, run the doctor subcommand on the runner host. The doctor subcommand starts an interactive Claude Code session with the runner's logs and state attached. Sign in with `claude auth login` on that host first so the session can query your environment, its runners, and its queued sessions. Without that sign-in, for example when the host authenticates with an API key, it's limited to the local health endpoint, metrics, and the runner's log, and it reads the log only if you started the runner with `--log-file`.
 
 ```bash theme={null}
@@ -447,4 +448,5 @@ Common issues:
 * **Sessions fail immediately after pickup**: open the session in claude.ai/code to see the error. The most common causes are missing [git credentials](#configure-git) in the runner image and build tools that aren't installed. An unwritable base directory stops the runner at startup instead of failing sessions. See the **Runner exits at startup with `cannot create or write to base directory`** entry in this list.
 * **Sessions can't reach the network through an authenticating egress proxy**: when the source you set with [`--proxy-authorization-command` or `--proxy-authorization-file`](#authenticate-to-an-egress-proxy) fails, times out after 30 seconds, or yields an empty value, the runner answers that connection `502 Bad Gateway` and logs why. The runner redacts the command's stderr in that log and never logs the header value. With `--proxy-authorization-command`, run the command yourself on the host to confirm it prints the whole header value on stdout. If the runner instead exits at startup with `could not start the proxy-authorization listener`, it couldn't open its loopback listener.
+* **Runner logs `Poll failed` lines containing `rejecting the malformed poll response`**: the runner received a work-poll response whose body isn't the queue's expected JSON, most often because something between the runner and `api.anthropic.com`, such as an intercepting proxy or a captive portal, answered with its own page. The runner rejects the response, counts it under the `transport` kind of the `claude_code_self_hosted_runner_poll_errors_total` [metric](/docs/en/self-hosted-environments-reference#prometheus-metrics), and retries on the failed-poll schedule described in [Session lifecycle](/docs/en/self-hosted-environments#session-lifecycle). The runner keeps serving its live sessions. Configure the proxy to pass responses from `api.anthropic.com` through unaltered. Before v2.1.246, the runner read such a response as an empty work queue, which could end its live sessions or make it exit.
```

</details>

<details>
<summary>self-hosted-environments-en.md</summary>

```diff
diff --git a/docs-ja/pages/self-hosted-environments-en.md b/docs-ja/pages/self-hosted-environments-en.md
index b58d654..2f289af 100644
--- a/docs-ja/pages/self-hosted-environments-en.md
+++ b/docs-ja/pages/self-hosted-environments-en.md
@@ -91,5 +91,5 @@ When a developer starts a session and selects your environment, Anthropic's cont
 4. If the runner stops polling for about 60 seconds, the server requeues the session for another runner.
 
-The runner gives each poll request 10 seconds. When a request times out or is lost, the runner retries after a second or two instead of waiting for the next scheduled poll. Each further request that times out or is lost doubles the gap before the next retry, up to 20 seconds, and the runner shortens the gap whenever the lease is close to expiring.
+The runner gives each poll request 10 seconds. When a request times out, is lost, or gets a response the runner can't parse, the runner keeps serving its live sessions and retries after a second or two instead of waiting for the next scheduled poll. For example, an intercepting proxy that answers the poll with its own page produces a response the runner can't parse. Each time another request fails in one of those ways, the runner doubles the gap before the next retry, up to 20 seconds, and shortens the gap whenever the lease is close to expiring.
 
 ### Runner lifecycle
```

</details>

<details>
<summary>self-hosted-environments-identity-en.md</summary>

```diff
diff --git a/docs-ja/pages/self-hosted-environments-identity-en.md b/docs-ja/pages/self-hosted-environments-identity-en.md
index 56ad82b..c866245 100644
--- a/docs-ja/pages/self-hosted-environments-identity-en.md
+++ b/docs-ja/pages/self-hosted-environments-identity-en.md
@@ -11,5 +11,5 @@
 </Note>
 
-A [self-hosted environment](/docs/en/self-hosted-environments) lets [Claude Code on the web](/docs/en/claude-code-on-the-web) sessions run on infrastructure you operate instead of on Anthropic's. Because the session runs inside your network, Claude can call your internal services directly. Those services need a way to confirm that a request really came from a Claude Code session in your environment, and to identify the user or service identity that created that session.
+A [self-hosted environment](/docs/en/self-hosted-environments) lets [Claude Code on the web](/docs/en/claude-code-on-the-web) sessions run on infrastructure you operate instead of on Anthropic's. Because the session runs inside your network, Claude can call your internal services directly. Those services need a way to confirm that a request came from a Claude Code session in your environment, and to identify the user or service identity that created that session.
 
 Every session in a self-hosted environment receives a signed JSON Web Token (JWT) in the `CLAUDE_CODE_SESSION_ACCESS_TOKEN` environment variable. A session presents the token like any bearer credential; for example, a script Claude runs can call your service with `curl -H "Authorization: Bearer $CLAUDE_CODE_SESSION_ACCESS_TOKEN"`. Anthropic signs the token and publishes the verification keys at a public JWKS endpoint. Your services fetch those keys, verify the signature, and read the claims to decide what access to grant.
```

</details>

<details>
<summary>self-hosted-environments-reference-en.md</summary>

```diff
diff --git a/docs-ja/pages/self-hosted-environments-reference-en.md b/docs-ja/pages/self-hosted-environments-reference-en.md
index 8828a22..4d1a4d3 100644
--- a/docs-ja/pages/self-hosted-environments-reference-en.md
+++ b/docs-ja/pages/self-hosted-environments-reference-en.md
@@ -24,4 +24,5 @@ Most flags have a corresponding environment variable. When both are set, the fla
 | `--base-dir <path>`                       | `SELF_HOSTED_RUNNER_BASE_DIR`                     | `/workspace`; none on Windows | Directory for repository checkouts and per-session working directories. The runner needs write access to this path or its parent. The runner creates the directory at startup and exits with `cannot create or write to base directory` when it can't create or write to it. Before v2.1.225, the runner created the directory when the first session started, so an unusable path failed sessions rather than startup. On Windows, which isn't a supported runner host, there is no default: the runner exits at startup unless you pass the flag or set the variable. Use the same value on every runner in an environment. See [Keep the base directory and capacity identical across runners](/docs/en/self-hosted-environments-deploy#keep-the-base-directory-and-capacity-identical-across-runners).                                                                                                                                                                                                                                                        |
 | `--capacity <n>`                          | none                                              | `1`                           | Maximum concurrent sessions this runner handles. All sessions belong to the same locked [owner](/docs/en/self-hosted-environments#key-concepts). Use the same value on every runner in an environment; see [Keep the base directory and capacity identical across runners](/docs/en/self-hosted-environments-deploy#keep-the-base-directory-and-capacity-identical-across-runners).                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
+| `--client-label <label>`                  | `SELF_HOSTED_RUNNER_CLIENT_LABEL`                 | the host's hostname           | Label the runner sends when it registers. The runner also reports it as the `client_label` label of [`claude_code_self_hosted_runner_info`](#prometheus-metrics). Requires Claude Code v2.1.248 or later.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
 | `--configure-git`                         | `SELF_HOSTED_RUNNER_CONFIGURE_GIT=1`              | off                           | Write global git identity and enable Anthropic commit signing at startup. See [Configure git](/docs/en/self-hosted-environments-deploy#configure-git).                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
 | `--confine-repo-settings <mode>`          | `SELF_HOSTED_RUNNER_CONFINE_REPO_SETTINGS`        | `warn`                        | Sets the mode of the guard that flags a session when a repository's committed settings try to grant write or read access outside that session's own workspace, set environment variables, or override the operator's sandbox or hooks posture, such as `sandbox.enabled: false` or `disableAllHooks`. The default `warn` logs the violation and still starts the session, `enforce` refuses the session, and `off` disables the scan. See [Harden your deployment](/docs/en/self-hosted-environments-deploy#harden-your-deployment).                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
@@ -37,5 +38,5 @@ Most flags have a corresponding environment variable. When both are set, the fla
 | `--health-port <port>`                    | `SELF_HOSTED_RUNNER_HEALTH_PORT`                  | `8080`                        | Port for the `/healthz` and `/metrics` listener. Set `0` to disable.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
 | `--hooks-dir <path>`                      | `SELF_HOSTED_RUNNER_HOOKS_DIR`                    | unset                         | Directory of lifecycle hook scripts. See [Lifecycle hooks](/docs/en/self-hosted-environments-configuration#lifecycle-hooks).                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
-| `--kill-session-after-min <n>`            | `SELF_HOSTED_RUNNER_MAX_LIFETIME_MS`              | `0`                           | Terminate a session child once it has lived N minutes wall-clock, as a safety limit for stuck sessions. A kill that falls mid-turn is deferred until the turn finishes, bounded by a grace window. `0` disables.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
+| `--kill-session-after-min <n>`            | `SELF_HOSTED_RUNNER_MAX_LIFETIME_MS`              | `0`                           | Terminate a session child once it has lived N minutes wall-clock, as a safety limit for stuck sessions. The runner terminates the session's process tree, including any commands the session left running. The runner defers a kill that falls mid-turn until the turn finishes, for at most the [`SELF_HOSTED_RUNNER_MAX_LIFETIME_GRACE_MS`](#environment-variable-only-settings) window. `0` disables.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
 | `--lock-to-account <id>`                  | `SELF_HOSTED_RUNNER_LOCK_TO_ACCOUNT`              | unset                         | Pre-lock the runner to a specific account at startup instead of locking on first session. Accepts an email address or `user_...` ID in the environment's organization. A pre-locked runner never picks up Claude Tag channel sessions, which have no account.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
 | `--log-file <path>`                       | `SELF_HOSTED_RUNNER_LOG_FILE`                     | unset                         | Mirror runner logs to a file in addition to stdout and stderr, created with `0600` permissions. Required for `self-hosted-runner doctor` to tail logs locally.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
```

</details>

<details>
<summary>settings-reference-en.md</summary>

```diff
diff --git a/docs-ja/pages/settings-reference-en.md b/docs-ja/pages/settings-reference-en.md
index 0d6654b..eea7069 100644
--- a/docs-ja/pages/settings-reference-en.md
+++ b/docs-ja/pages/settings-reference-en.md
@@ -687,4 +687,5 @@ scope: "Which settings files can set the key: user (~/.claude/settings.json), pr
 | [`modelOverrides`](#modeloverrides)                                                             | [Map model IDs](/docs/en/model-config#override-model-ids-per-version) to your provider's IDs, such as Bedrock ARNs                                                                                                               | Model and responses                | Any file                |
 | [`modelPicker`](#modelpicker)                                                                   | Choose which models the [`/model` picker](/docs/en/model-config#available-models) lists, in your own order and with your own labels                                                                                              | Model and responses                | User or managed         |
+| [`modelPricing`](#modelpricing)                                                                 | Report spend at your organization's contracted rates instead of list price                                                                                                                                                  | Model and responses                | Managed                 |
 | [`otelHeadersHelper`](#otelheadershelper)                                                       | Generate rotating [OpenTelemetry](/docs/en/monitoring-usage#dynamic-headers) headers with your own command                                                                                                                       | Authentication and providers       | Any file                |
 | [`outputStyle`](#outputstyle)                                                                   | Change Claude's role, tone, and output format with an [output style](/docs/en/output-styles)                                                                                                                                     | Model and responses                | Any file                |
@@ -835,5 +836,5 @@ The key has no effect on Amazon Bedrock, Google Cloud's Agent Platform, or Micro
 Turn [extended thinking](/docs/en/model-config#extended-thinking) off for every session by setting this to `false`. Thinking is on by default, so `true` changes nothing. Most people set this through `/config` rather than by editing the file.
 
-On models that always think, such as Fable 5, `false` has no effect. On [third-party providers](/docs/en/third-party-integrations) Claude Code omits the `thinking` parameter instead of turning thinking off, so adaptive-reasoning models may still think.
+On models that always think, such as Fable 5, `false` has no effect. On [third-party providers](/docs/en/third-party-integrations) Claude Code omits the `thinking` parameter instead of turning thinking off, so adaptive-reasoning models may still think. With thinking turned off on the Anthropic API, Claude Code sends effort `high` instead of a higher level to models it knows [don't accept that combination](/docs/en/errors#effort-isnt-available-with-thinking-turned-off), such as Opus 5.
 
 * **Scope**: [`Any file`](#scopes)
@@ -1067,4 +1068,53 @@ An [`availableModels`](#availablemodels) allowlist still applies to these rows.
 Claude Code drops a row it can't parse and keeps the rest. See [Fix a broken settings file](/docs/en/settings#fix-a-broken-settings-file).
 
+### `modelPricing`
+
+Report spend at the rates your organization pays instead of list price. Set it when your organization has contracted rates, so the dollar figures developers see match your bill. Claude Code applies the rates in `/usage`, the [status line](/docs/en/statusline), the Agent SDK's `total_cost_usd`, the [`--max-budget-usd`](/docs/en/cli-reference) limit, and the [OpenTelemetry](/docs/en/monitoring-usage) cost metric and events. You supply the rates: Claude Code doesn't read them from your contract or the Claude Console. Requires Claude Code v2.1.242 or later.
+
+* **Scope**: [`Managed`](#scopes). Deploy the key through server-managed settings, an MDM policy, a `managed-settings.json` file, or a [policy helper](/docs/en/managed-settings#compute-the-policy-with-a-helper-program). Claude Code ignores it in user, project, and local settings, in `--settings`, and on Windows in the user-writable [HKCU registry](/docs/en/managed-settings#where-each-mechanism-stores-the-policy). With server-managed settings, each session reports costs at list price until that session's [settings fetch](/docs/en/server-managed-settings#fetch-and-caching-behavior) has confirmed the setting. A host application that embeds Claude Code and sets [`CLAUDE_CODE_PROVIDER_MANAGED_BY_HOST`](/docs/en/env-vars) can supply a table of its own through the SDK [`managedSettings`](/docs/en/agent-sdk/typescript#options) option, which Claude Code uses only when no managed source sets the key and only in Claude Code v2.1.246 or later.
+* **Type**: object with an optional `multiplier` and an optional `overrides` map
+* **Default**: unset, so Claude Code reports list price unless a host application supplies a table
+
+This example sets contracted rates for Sonnet 4.6 and then reduces every figure, the Sonnet row included, by 15%. Set `multiplier` alone for a flat discount, `overrides` alone for per-model rates, or both:
+
```

</details>

*...以降省略*

</details>


<details>
<summary>2026-08-28</summary>

**変更ファイル:**

```
 docs-ja/pages/changelog.md                         |  56 ++++++++
 docs-ja/pages/claude-directory-ja.md               |   2 +-
 docs-ja/pages/cross-session-messaging-en.md        |  62 +++++++--
 docs-ja/pages/managed-settings-en.md               | 122 ++++++++++++-----
 .../self-hosted-environments-configuration-en.md   |   4 +-
 .../pages/self-hosted-environments-deploy-en.md    |  55 ++++++--
 docs-ja/pages/self-hosted-environments-en.md       |  19 ++-
 .../pages/self-hosted-environments-identity-en.md  |  22 ++--
 .../self-hosted-environments-quickstart-en.md      |   4 +-
 .../pages/self-hosted-environments-reference-en.md |  40 +++---
 .../pages/self-hosted-environments-testing-en.md   |   2 +-
 docs-ja/pages/settings-reference-en.md             | 144 ++++++++++++++-------
 12 files changed, 386 insertions(+), 146 deletions(-)
```

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index 3a9eb16..2ac5610 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,60 @@
 # Changelog
 
+## 2.1.250
+
+- Bug fixes and reliability improvements
+
+## 2.1.248
+
+- Added `--restricted` (or `CLAUDE_CODE_RESTRICTED=1`): removes the built-in tools that run commands or code and `WebFetch` (unless named in `--tools`), keeps file tools inside the working directory, refuses `bypassPermissions`, and ignores user, project and local settings files
+- Added `experimental.cacheTtl` (`"5m"` or `"1h"`) to agent frontmatter: a per-agent prompt cache TTL used when no subagent TTL setting is configured
+- Added `claude self-hosted-runner --client-label <label>` (or `SELF_HOSTED_RUNNER_CLIENT_LABEL`) to override the label the runner registers with (default: hostname)
+- Added server-managed settings diagnostics: a startup warning when the settings fail to load, and a `/doctor` and `/status` line explaining a load failure or why they weren't fetched (Bedrock/Vertex/third-party provider, custom `ANTHROPIC_BASE_URL`)
+- Added a warning in `/web-setup` when the GitHub CLI token lacks the `workflow` scope, since pushes to very large repositories can be rejected without it
+- Added `/usage-credits` for Enterprise organizations billed through AWS Marketplace, self-serve Enterprise, and Enterprise trials, so members can request a higher usage limit from their admin
+- Added cross-session messaging (`SendMessage` / `ListAgents`) between sessions on the same machine on Bedrock, Vertex, and Foundry, and when telemetry is disabled
+- Fixed a prompt-cache miss (and lost extended-thinking context) roughly once an hour in long sessions, caused by tool definitions being re-rendered after an OAuth token refresh
+- Fixed the `ScheduleWakeup` tool definition changing between a session and its `--resume` when the account had entered usage overage, causing a full prompt-cache miss on the resumed session's first turn
+- Fixed Claude Desktop and Cowork sessions disappearing after 30 days: the transcript cleanup now keeps desktop-written sessions while they are in the app (unless org policy manages retention); the new `desktopSessionCleanupPeriodDays` setting caps the exemption
+- Fixed being sent to the login screen when another Claude Code process held the token refresh lock while the session token had expired; the request now fails with a retryable error instead
+- Windows: Fixed the `claude agents` list not responding to the keyboard after detaching from a session, or when launched in a terminal tab left in win32-input-mode
+- Fixed the recommended Console sign-in in `/login` failing with an OAuth error before showing a sign-in URL on machines where it can't be used (for example when `ANTHROPIC_API_KEY` or an API key helper is set); it now falls back to the API-key sign-in
+- Fixed model names in `/model` and fast-mode switch notices to render as code, so suffixes like `[1m]` display literally instead of as a link
+- Fixed `claude agents` skipping the workspace trust prompt when the `CI` environment variable is set
+- Fixed `claude agents` crashing on launch when the PR-status cache held a malformed entry
+- Fixed agent view resurrecting a weeks-old background session after the machine was off: such a session now shows as stopped at its real end, and opening it asks before resuming its saved conversation
```

</details>

<details>
<summary>claude-directory-ja.md</summary>

```diff
diff --git a/docs-ja/pages/claude-directory-ja.md b/docs-ja/pages/claude-directory-ja.md
index e57e910..febde4e 100644
--- a/docs-ja/pages/claude-directory-ja.md
+++ b/docs-ja/pages/claude-directory-ja.md
@@ -642,5 +642,5 @@ type: reference
           when: 'Applied at session start when selected via the outputStyle setting',
           description: [<>Each markdown file defines an output style: a section appended to the system prompt that, by default, also drops the built-in software-engineering task instructions. Use this to adapt Claude Code for uses beyond coding, or to add teaching or review modes.</>, <>Select a built-in or custom style with <C>/config</C> or the <C>outputStyle</C> key in settings. Styles here are available in every project; project-level styles with the same name take precedence.</>],
-          tips: ['Built-in styles Explanatory and Learning are included with Claude Code; custom styles go here', <>Set <C>keep-coding-instructions: true</C> in frontmatter to keep the default task instructions alongside your additions</>, 'Changes take effect on the next session since the system prompt is fixed at startup for caching'],
+          tips: ['Built-in styles Default, Proactive, Concise, Explanatory, and Learning are included with Claude Code; custom styles go here', <>Set <C>keep-coding-instructions: true</C> in frontmatter to keep the default task instructions alongside your additions</>, 'Changes take effect on the next session since the system prompt is fixed at startup for caching'],
           docsLink: '/en/output-styles',
           children: [{
```

</details>

<details>
<summary>cross-session-messaging-en.md</summary>

```diff
diff --git a/docs-ja/pages/cross-session-messaging-en.md b/docs-ja/pages/cross-session-messaging-en.md
index e9f6ce3..6def44b 100644
--- a/docs-ja/pages/cross-session-messaging-en.md
+++ b/docs-ja/pages/cross-session-messaging-en.md
@@ -13,5 +13,5 @@
 Cross-session messaging lets Claude deliver a message from one of your Claude Code sessions to another. When a change in one session breaks what another is building on, Claude can warn that session before you notice. When one session settles a question another is blocked on, Claude can send the answer across.
 
-A message is a piece of text one Claude writes to another, never conversation history or files. To move a whole conversation or its context, [resume the session](/docs/en/sessions#resume-a-session) instead.
+A message is a piece of text one Claude writes to another, never the sender's conversation history or files. To move a whole conversation or its context, [resume the session](/docs/en/sessions#resume-a-session) instead.
 
 Claude uses two tools for this: `ListAgents` to discover which agents it can reach, and `SendMessage` to deliver a message to one of them by name. With the same `SendMessage` tool, Claude can also message [subagents](/docs/en/sub-agents#resume-subagents) and [agent team](/docs/en/agent-teams) teammates within a single session or team. This page covers messages between your independent sessions.
@@ -56,5 +56,10 @@ Let @api-worker know the schema migration finished
 ```
 
-Once you type at least one letter after the `@`, Claude Code suggests your other live sessions on this machine; after a bare `@`, session rows don't appear. A cloud or Remote Control session appears in the suggestions only after Claude has already listed or messaged your sessions beyond this machine. You can also type the mention without the picker. When more than one live session answers to the mentioned name, Claude asks you which one you mean before sending.
+The typeahead lists your other live sessions on this machine. Two cases need more than the first letters of a name:
+
+* **A session beyond this machine**: a cloud or Remote Control session appears in the typeahead only after Claude has listed or messaged your sessions beyond this machine, so ask Claude to list them first.
+* **A name with a space or other characters outside letters, digits, hyphens, and underscores**: type it in double quotes, such as `@"release notes"`. When you pick the session from the typeahead, Claude Code inserts the quotes for you.
+
+You can also type the mention without the picker. When more than one live session answers to the mentioned name, Claude asks you which one you mean before sending.
 
 For what the message Claude writes looks like when it arrives, including an example of one, see [what a message looks like](#what-a-message-looks-like).
@@ -64,4 +69,8 @@ For what the message Claude writes looks like when it arrives, including an exam
 The receiving Claude reads the message between tool calls during an active turn, so a running tool is never interrupted. When the receiving session is idle, Claude Code starts a new turn with the message.
 
+When a message that starts a new turn mentions a file as an `@` immediately followed by its path, Claude Code [attaches that file](/docs/en/common-workflows#reference-files-and-directories) as it exists on the receiving machine, resolving a relative path from the receiving session's working directory. The receiving session's [`Read` deny rules](/docs/en/permissions#read-and-edit) apply to that file, as they do to a file you mention with `@` yourself. When such a message mentions an [MCP resource](/docs/en/mcp#use-mcp-resources) with `@`, Claude Code attaches that resource from the receiving session's MCP servers. A path written without the `@` stays plain text and attaches nothing.
+
+A message that Claude reads during an active turn arrives as plain text with nothing attached, even if it mentions files or MCP resources with `@`.
+
```

</details>

<details>
<summary>managed-settings-en.md</summary>

```diff
diff --git a/docs-ja/pages/managed-settings-en.md b/docs-ja/pages/managed-settings-en.md
index 7c2bfa0..d808cfe 100644
--- a/docs-ja/pages/managed-settings-en.md
+++ b/docs-ja/pages/managed-settings-en.md
@@ -5,5 +5,5 @@
 # Deploy managed settings
 
-> Deploy managed settings to every developer's machine: delivery mechanisms per OS, which managed source Claude Code uses, and how to verify enforcement.
+> Deploy managed settings to every developer's machine: delivery mechanisms per OS, how Claude Code combines managed sources, and how to verify enforcement.
 
 Managed settings are the settings your organization deploys to every developer's machine. Claude Code applies them above every other level, so no user, project, local, or `--settings` value overrides them, apart from a few [security-sensitive exceptions](/docs/en/settings#exceptions-to-managed-settings-precedence) where a stricter value from a lower level still counts.
@@ -56,10 +56,10 @@ This is the quickest way to put a policy on each machine: a `managed-settings.js
 The file in the steps above is one of four ways to get managed settings onto a machine. Every mechanism carries the same policy keys as a `settings.json` file, so the [settings reference](/docs/en/settings-reference) applies to all of them. A few keys are tied to particular sources, and each entry's Scope line says which:
 
-* **Delivery controls**: [`policyHelper`](/docs/en/settings-reference#policyhelper) and [`wslInheritsWindowsSettings`](/docs/en/settings-reference#wslinheritswindowssettings)
+* **Delivery controls**: [`policyHelper`](/docs/en/settings-reference#policyhelper), [`wslInheritsWindowsSettings`](/docs/en/settings-reference#wslinheritswindowssettings), and [`managedSourcesBehavior`](/docs/en/settings-reference#managedsourcesbehavior)
 * **Gateway login keys**: [`forceLoginGatewayUrl`](/docs/en/settings-reference#forcelogingatewayurl) and the `"gateway"` value of [`forceLoginMethod`](/docs/en/settings-reference#forceloginmethod)
 
 A managed settings file, an MDM profile, or the claude.ai console applies one policy to everyone it reaches. To give one group of developers a different policy, deploy a different file or profile to that group; the claude.ai console [can't target a group yet](/docs/en/server-managed-settings#current-limitations), while a self-hosted [Claude apps gateway](/docs/en/claude-apps-gateway) delivers managed settings per IdP group.
 
-When more than one mechanism delivers a policy to the same machine, Claude Code uses one and ignores the others; [Which managed source Claude Code uses](#which-managed-source-claude-code-uses) gives the order.
+When more than one mechanism delivers a policy to the same machine, Claude Code by default uses one and ignores the others. [How Claude Code combines managed sources](#how-claude-code-combines-managed-sources) gives the order and the opt-in that applies every source.
 
 The MDM and file rows are together called endpoint-managed settings, because the policy is stored on the developer's device, as opposed to the server-managed row, where Claude Code fetches it.
@@ -82,6 +82,13 @@ For managed MCP servers, which you deploy alongside any of these through `manage
 A deployed policy reaches the developer's sessions as follows:
 
-* **Surfaces**: every surface that runs Claude Code on the machine reads these sources: the terminal, the VS Code and JetBrains extensions, the desktop app, and [Agent SDK](/docs/en/agent-sdk/typescript) sessions, which load managed settings even when `settingSources` excludes the user, project, and local files.
-* **Cloud sessions**: a session in an Anthropic-hosted environment doesn't read a device's MDM profile or file, so policy for it has to come from server-managed settings. A session in a [self-hosted environment](/docs/en/self-hosted-environments) reads the managed settings file in its runner image only when server-managed settings deliver no keys, apart from the [keys Claude Code reads from every admin source](#keys-read-from-every-admin-source).
+* **Surfaces**: on the developer's machine, the terminal, the VS Code and JetBrains extensions, the desktop app's Code tab, and [Agent SDK](/docs/en/agent-sdk/typescript) sessions read all of these sources. Agent SDK sessions load managed settings even when `settingSources` excludes the user, project, and local files.
```

</details>

<details>
<summary>self-hosted-environments-configuration-en.md</summary>

```diff
diff --git a/docs-ja/pages/self-hosted-environments-configuration-en.md b/docs-ja/pages/self-hosted-environments-configuration-en.md
index b5360a1..20e56bc 100644
--- a/docs-ja/pages/self-hosted-environments-configuration-en.md
+++ b/docs-ja/pages/self-hosted-environments-configuration-en.md
@@ -207,5 +207,5 @@ The orchestrator runs `${hooks-dir}/spawn-runner` once per spawn request. The ho
 | `CLAUDE_RUNNER_ORDER_SERVER_TIME`     | Server time from the poll response's HTTP `Date` header. When the hook verifies the work-order JWT's `exp`, compare against this value instead of the local clock to tolerate skew. Empty when the gateway omitted the header.                                                                                                        |
 | `CLAUDE_RUNNER_POOL_ID`               | The ID of the environment the new runner should join, in `ccpool_...` form                                                                                                                                                                                                                                                            |
-| `CLAUDE_RUNNER_ACCOUNT_ID`            | Tagged ID of the account that enqueued the session, for per-account routing, quota, or chargeback. Empty when unavailable.                                                                                                                                                                                                            |
+| `CLAUDE_RUNNER_ACCOUNT_ID`            | Tagged ID of the account that enqueued the session, for per-account routing, quota, or chargeback. Empty when unavailable, and always empty for Claude Tag channel sessions, which no account enqueues.                                                                                                                               |
 | `CLAUDE_RUNNER_ACCOUNT_EMAIL`         | Email of the account that enqueued the session. Empty when unavailable. Treat the email as personally identifiable information and don't log it.                                                                                                                                                                                      |
 | `CLAUDE_RUNNER_PRIMARY_REPO_URL`      | URL of the session's first git source, for routing to a runner with that repository pre-warmed. Empty when the session has no git sources.                                                                                                                                                                                            |
@@ -379,5 +379,5 @@ To pre-approve specific tools instead, append `--allowed-tools` with your rules,
 The runner gives each session its own config directory, seeded from an in-memory snapshot of the host's `~/.claude/` that the runner captures once at startup: `settings.json`, `CLAUDE.md`, hooks, agents, commands, and skills in your runner image apply to every session as the user-level baseline. Because the snapshot is taken at startup, config changes on a running host take effect only after a runner restart. Set `SELF_HOSTED_RUNNER_HOST_CONFIG_DIR` to seed from a different path, or point it at an empty directory to disable seeding.
 
-Repository-committed `.claude/settings.json` layers on top as project settings. Sessions also read [`managed-settings.json`](/docs/en/settings#where-settings-live) from the standard system path in your runner image, but the managed tier uses one source at a time, and [server-managed settings](/docs/en/server-managed-settings) are checked first: if your organization delivers any server-managed keys, sessions ignore the runner image's managed file except for its cross-source keys. Claude Code still reads the `env` block and the other [keys it reads from every admin source](/docs/en/managed-settings#keys-read-from-every-admin-source) from that file, such as the sandbox locks, the sandbox binary paths, and `forceRemoteSettingsRefresh`. See [settings precedence](/docs/en/settings#settings-precedence).
+Repository-committed `.claude/settings.json` layers on top as project settings. Sessions also read [`managed-settings.json`](/docs/en/settings#where-settings-live) from the standard system path in your runner image. Whether its keys apply alongside [server-managed settings](/docs/en/server-managed-settings) follows [how Claude Code combines managed sources](/docs/en/managed-settings#how-claude-code-combines-managed-sources): by default, when your organization delivers any server-managed keys, sessions ignore the runner image's file apart from the [keys Claude Code reads from every admin source](/docs/en/managed-settings#keys-read-from-every-admin-source), such as the `env` block, the sandbox locks, the sandbox binary paths, and `forceRemoteSettingsRefresh`. See [settings precedence](/docs/en/settings#settings-precedence).
 
 When Anthropic's control plane supplies a session with [Claude Code hooks](/docs/en/hooks), the runner installs them alongside, not over, your own configuration. Requires Claude Code v2.1.229 or later.
```

</details>

<details>
<summary>self-hosted-environments-deploy-en.md</summary>

```diff
diff --git a/docs-ja/pages/self-hosted-environments-deploy-en.md b/docs-ja/pages/self-hosted-environments-deploy-en.md
index 4e41400..d4bd500 100644
--- a/docs-ja/pages/self-hosted-environments-deploy-en.md
+++ b/docs-ja/pages/self-hosted-environments-deploy-en.md
@@ -11,13 +11,13 @@
 </Note>
 
-A [self-hosted environment](/docs/en/self-hosted-environments) runs Claude Code [cloud sessions](/docs/en/claude-code-on-the-web) on runners you deploy inside your network, and in production those sessions execute model-directed code on behalf of anyone in your organization. This page is for the operator taking a working environment to production. It works through the deployment in order: what to lock down before connecting real systems, the egress the fleet needs, how sessions authenticate to your git host, the deployment recipes themselves, and what to check when sessions misbehave.
+A [self-hosted environment](/docs/en/self-hosted-environments) runs Claude Code [cloud sessions](/docs/en/claude-code-on-the-web) on runners you deploy inside your network, and in production those sessions execute model-directed code on behalf of everyone who can dispatch a session to the environment. This page is for the operator taking a working environment to production. It works through the deployment in order: what to lock down before connecting real systems, the egress the fleet needs, how sessions authenticate to your git host, the deployment recipes themselves, and what to check when sessions misbehave.
 
 ## Harden your deployment
 
-A self-hosted runner executes arbitrary, model-directed code on your infrastructure on behalf of any member of your Anthropic organization. Work through each item before you connect an environment to production systems:
+A self-hosted runner executes arbitrary, model-directed code on your infrastructure on behalf of everyone who can dispatch a session to its environment. That's any member of your Anthropic organization, and anyone who can start a [Claude Tag](https://claude.com/docs/claude-tag/overview) channel session in a scope an Owner routed to the environment. Work through each item before you connect an environment to production systems:
 
-* **Ephemeral, per-session containers**: run each runner process in a fresh container or VM that's destroyed when the process exits, with `--capacity 1` and the default `--drain-grace-sec 0` so each container serves exactly one session. At a higher capacity, or with a positive drain grace, one container serves multiple sessions from the same locked account; see [Runner lifecycle](/docs/en/self-hosted-environments#runner-lifecycle). Don't reuse a filesystem between runner restarts, except in the deliberate [pre-warmed checkout](#reuse-a-pre-warmed-checkout) setup, and never across accounts.
+* **Ephemeral, per-session containers**: run each runner process in a fresh container or VM that's destroyed when the process exits, with `--capacity 1` and the default `--drain-grace-sec 0` so each container serves exactly one session. At a higher capacity, or with a positive drain grace, one container serves multiple sessions from the same [locked owner](/docs/en/self-hosted-environments#key-concepts); see [Runner lifecycle](/docs/en/self-hosted-environments#runner-lifecycle). Don't reuse a filesystem between runner restarts, except in the deliberate [pre-warmed checkout](#reuse-a-pre-warmed-checkout) setup, and never across owners.
 * **No broad credentials in the image**: don't include long-lived SSH keys, cloud-provider credentials, or personal access tokens that grant more than a session needs. Mint credentials used during a session, such as push or API tokens, per session from your [wrapper script](/docs/en/self-hosted-environments-configuration#wrapper-scripts). For the initial clone, which happens before the wrapper runs, use a [`checkout` lifecycle hook](/docs/en/self-hosted-environments-configuration#checkout) or [`--use-anthropic-git-proxy`](#use-the-anthropic-git-proxy); see [Configure git](#configure-git).
-* **Keep the environment secret off session-running hosts**: the environment secret can register runners and pick up any org member's queued sessions. On a fixed fleet it lives on every runner host, where any session's code can read the secret file. Prefer [on-demand runners](/docs/en/self-hosted-environments-configuration#on-demand-runners), where the secret stays on the orchestrator host, which never runs user code, and each runner receives a single-use work order that registers exactly one runner. On a fixed fleet, treat the environment-secret file as readable by every session and rotate the secret after any suspected session compromise.
+* **Keep the environment secret off session-running hosts**: the environment secret can register runners and pick up any session queued on the environment. On a fixed fleet it lives on every runner host, where any session's code can read the secret file. Prefer [on-demand runners](/docs/en/self-hosted-environments-configuration#on-demand-runners), where the secret stays on the orchestrator host, which never runs user code, and each runner receives a single-use work order that registers exactly one runner. On a fixed fleet, treat the environment-secret file as readable by every session and rotate the secret after any suspected session compromise.
 * **Default-deny network egress**: restrict runner and session container outbound traffic at your own network boundary on every environment; [Default-deny egress](#default-deny-egress) covers what to allow and why.
 * **Least-privilege host IAM**: the compute identity attached to the runner host, such as an instance profile or node service account, should grant only what the runner itself needs. Sessions should obtain their own credentials through your wrapper script rather than inheriting the host's.
@@ -30,5 +30,5 @@ A self-hosted runner executes arbitrary, model-directed code on your infrastruct
   The block applies to your wrapper script and lifecycle hooks too, since they share the container. Authenticate any token exchange with the [session JWT](/docs/en/self-hosted-environments-identity) against your own token service over allowlisted egress, or use a file-based web identity such as IAM Roles for Service Accounts (IRSA) on Amazon EKS.
 * **Per-runner filesystem isolation**: each runner process gets its own working directory that no other process on the host can read or write. Make `--hooks-dir`, the wrapper script, and the host's `~/.claude/` read-only to the session, either built into the image or mounted read-only.
-* **Dispatch is organization-wide**: any member of your Anthropic organization can dispatch a session to any of its environments, and there's no per-environment access control on dispatch. Treat every runner host as reachable for code execution by every org member, and place data or credentials on a runner host only if every org member is allowed to read them. [`--lock-to-account`](/docs/en/self-hosted-environments-reference#runner-cli-flags) bounds which account's sessions a given host executes, but dispatch into the environment itself stays organization-wide. To make self-hosted environments the only picker option, an [Owner](/docs/en/cloud-environments#organization-shared-environments) can hide Anthropic-hosted environments for the whole organization from the [**Cloud environments** page](https://claude.ai/admin-settings/cloud-environments).
+* **Dispatch has no per-environment access control**: any member of your Anthropic organization can dispatch a session to any of its environments. If an Owner [routes Claude Tag channels to the environment](/docs/en/cloud-environments#organization-shared-environments), anyone the [Claude Tag access setting](https://claude.com/docs/claude-tag/admins/restrict-access#restrict-who-can-use-claude) admits can start channel sessions that run there. By default that's anyone in the connected Slack workspace, with or without a Claude account. Treat every runner host as reachable for code execution by everyone who can dispatch to it, and place on a runner host only data and credentials that all of those people are allowed to read. [`--lock-to-account`](/docs/en/self-hosted-environments-reference#runner-cli-flags) bounds which account's sessions a given host executes, but it doesn't narrow who can dispatch into the environment. To make self-hosted environments the only picker option, an [Owner](/docs/en/cloud-environments#organization-shared-environments) can hide Anthropic-hosted environments for the whole organization from the [**Cloud environments** page](https://claude.ai/admin-settings/cloud-environments).
 * **Enforce the repo-settings guard**: choose the guard mode with [`--confine-repo-settings`](/docs/en/self-hosted-environments-reference#runner-cli-flags). The default `warn` logs a violation and still spawns the session, `enforce` refuses the session, and `off` disables the scan. The runner scans each repository's committed settings for:
 
@@ -133,5 +133,5 @@ RUN git config --system user.name "Claude" && \
```

</details>

<details>
<summary>self-hosted-environments-en.md</summary>

```diff
diff --git a/docs-ja/pages/self-hosted-environments-en.md b/docs-ja/pages/self-hosted-environments-en.md
index 99069ca..b58d654 100644
--- a/docs-ja/pages/self-hosted-environments-en.md
+++ b/docs-ja/pages/self-hosted-environments-en.md
@@ -33,5 +33,5 @@ When a developer starts a cloud session, the session-start UI shows an environme
 </div>
 
-The two Claude Code boxes in the diagram are session processes: one runner executing two sessions at once, up to its configured capacity. A runner serves one user at a time, locking to that user's account when it claims its first session, so checked-out code never mixes between users; [Runner lifecycle](#runner-lifecycle) covers the rule.
+The two Claude Code boxes in the diagram are session processes: one runner executing two sessions at once, up to its configured capacity. A runner serves one [owner](#key-concepts) at a time and locks to that owner when it claims its first session, so checked-out code never mixes between owners; [Runner lifecycle](#runner-lifecycle) covers the rule.
 
 You can start runners yourself and keep them running, or run the [autoscaling orchestrator](/docs/en/self-hosted-environments-configuration#on-demand-runners), a second process you host, which starts runners as sessions queue; each runner exits on its own when its work finishes. Either way, you set the environment up once, and it appears in the picker on every supported surface.
@@ -44,5 +44,5 @@ Check these before planning a rollout:
 * **Zero Data Retention**: unavailable for organizations with [Zero Data Retention](/docs/en/zero-data-retention) enabled.
 * **Model inference**: sessions use the Anthropic API, and inference can't be routed through [Amazon Bedrock, Google Cloud's Agent Platform, Microsoft Foundry](/docs/en/third-party-integrations), or an [LLM gateway](/docs/en/llm-gateway).
-* **Surfaces**: sessions started from [Claude Code on the web](/docs/en/claude-code-on-the-web), the mobile and desktop apps, [scheduled routines](/docs/en/routines), and the terminal, with [`claude --cloud`](/docs/en/claude-code-on-the-web#from-terminal-to-web) or an [`--environment` dispatch](/docs/en/self-hosted-environments-testing#run-the-test-loop), can run in self-hosted environments. [Claude Tag](https://claude.com/docs/claude-tag/overview), [Claude Security](/docs/en/claude-security), and [Code Review](/docs/en/code-review) sessions don't route to them yet. Support for those surfaces follows separately.
+* **Surfaces**: sessions started from [Claude Code on the web](/docs/en/claude-code-on-the-web), the mobile and desktop apps, [scheduled routines](/docs/en/routines), and the terminal, with [`claude --cloud`](/docs/en/claude-code-on-the-web#from-terminal-to-web) or an [`--environment` dispatch](/docs/en/self-hosted-environments-testing#run-the-test-loop), can run in self-hosted environments. [Claude Tag](https://claude.com/docs/claude-tag/overview) sessions can run in them too, but Claude can't use [Access bundles](https://claude.com/docs/claude-tag/concepts/glossary#access-bundle) in those sessions yet. [Claude Security](/docs/en/claude-security) and [Code Review](/docs/en/code-review) sessions don't route to them yet. Support for those two surfaces follows separately.
 * **Repositories**: sessions check out repositories from GitHub; see [GitHub authentication options](/docs/en/claude-code-on-the-web#github-authentication-options).
 * **Billing**: sessions in a self-hosted environment consume your organization's Claude Code usage the same way sessions in Anthropic-hosted environments do.
@@ -75,5 +75,10 @@ These terms appear throughout the self-hosted pages:
 In API fields, token claims, and metric names, the environment appears as `pool`, and the environment ID is the `pool_id`. The [reference](/docs/en/self-hosted-environments-reference) maps the two spellings, including the deprecated `pool` flag names.
 
-A runner serves one user at a time. The first session a runner picks up locks the runner to that user, and the runner then runs sessions only for that user, up to a configured capacity. The minimum fleet size is therefore the number of users you expect to be active at once.
+A runner serves one owner at a time. The first session a runner picks up locks the runner to that session's owner, and the runner then runs sessions only for that owner, up to a configured capacity. Who the owner is depends on how the session started:
+
+* **Sessions a user starts**: the owner is that user's account.
+* **Claude Tag channel sessions**: Claude runs them with no user account attached, so the owner is the [Claude Tag agent](https://claude.com/docs/claude-tag/concepts/glossary#agent-identity) that started the session. Every channel session that agent starts has the same owner, whoever sent the Slack message, so a runner locked to it serves sessions that different people started when you run it at a `--capacity` above one or with a positive `--drain-grace-sec`. A runner locked to a user never picks these up, and a runner locked to a Claude Tag agent never picks up a user's sessions.
+
+The minimum fleet size is therefore the number of owners you expect to be active at once, counting users and Claude Tag agents.
 
 ### Session lifecycle
```

</details>

*...以降省略*

</details>


<details>
<summary>2026-08-27</summary>

**変更ファイル:**

```
 docs-ja/pages/changelog.md             | 36 +++++++++++++++
 docs-ja/pages/settings-reference-en.md | 80 ++++++++++++++++++++++++++++++----
 2 files changed, 108 insertions(+), 8 deletions(-)
```

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index 8862f0c..3a9eb16 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,40 @@
 # Changelog
 
+## 2.1.247
+
+- Added the `SendFeedback` tool: when something goes wrong in a session, Claude can draft a feedback report for you to review and send from `/feedback` (turn off with the `feedbackDrafts` setting)
+- Added `{id, text, cooldownSessions, priority}` entries, `tipsFile`, and `label` to `spinnerTipsOverride`, so organizations can rotate their own tips alongside the built-in ones
+- Added a tip on Bash permission prompts pointing to auto mode, with a one-keystroke "Yes, and switch to auto mode" option
+- Added `/claude-api cost-optimize` to profile an existing project's Claude API spend and work through cost levers (caching, token hygiene, batch, effort, model choice) one measured change at a time
+- Updated the `/claude-api` skill with Admin API coverage (organization members, invites, workspaces, API keys, rate limit reports, workload identity federation, CMEK)
+- Fixed fast arrow-key + Enter sequences acting on the row above the one you navigated to in history search, `/config`, `/mcp`, `/skills`, background tasks, and `/model`
+- Fixed sub-agents dying on a first-call model 404: they now use the session's fallback model chain, and the error returned to the parent includes the error type, status, request id, and model
+- Fixed a hook or background agent that printed megabytes of error output being able to overflow the conversation and wedge the session on "Prompt is too long"
+- Fixed Ctrl keyboard shortcuts not firing under non-Latin (e.g. Cyrillic) keyboard layouts in kitty-protocol terminals
+- Fixed text like `<35;150;7M` being inserted into the prompt when a mouse report arrived split across reads right after the escape prefix
+- Fixed the Bash sandbox's after-command cleanup deleting a dotfile-managed `~/.claude/settings.json` symlink (nix/home-manager, stow) when it is repointed outside the sandbox's writable area
+- Fixed `/terminal-setup` overwriting your entire Zed `keymap.json` instead of merging in its keybinding
+- Fixed `/rename` silently confirming when the session registry could not be updated; it now says other sessions may still show the old name
+- Fixed `/compact` and "Summarize from here" in sessions started with `--agent` summarizing under the default system prompt instead of the conversation's own
+- Fixed a background session showing "opening…" forever in `claude agents` after its terminal host process died; the row now fails within seconds with the reason, and Enter restarts it
+- Fixed unbounded memory growth when a hook's or background task's output file could not be written; the file now notes where output was lost
+- Fixed `/install-github-app` over SSH: the copy shortcut now says how the sign-in URL was copied instead of always claiming success, and the URL appears immediately when no browser can open
+- Fixed shell commands carried over from the foreground logging an internal error or showing a misleading `[exited with code -1]` line when they finish in background sessions
+- Fixed a version-less marketplace plugin's live cache directory being deleted and recreated on a second-scope install, which could disrupt a running session using it
+- Fixed Remote Control sessions started with `/remote-control` not reporting the working-tree diff to connected clients
+- Fixed self-hosted runner sessions reporting `running` before Claude Code had started, which could trigger a premature "Claude is waiting for your input" notification from the Claude desktop app
```

</details>

<details>
<summary>settings-reference-en.md</summary>

```diff
diff --git a/docs-ja/pages/settings-reference-en.md b/docs-ja/pages/settings-reference-en.md
index 4da059b..c0b0c95 100644
--- a/docs-ja/pages/settings-reference-en.md
+++ b/docs-ja/pages/settings-reference-en.md
@@ -663,4 +663,5 @@ scope: "Which settings files can set the key: user (~/.claude/settings.json), pr
 | [`fastMode`](#fastmode)                                                                         | Turn [fast mode](/docs/en/fast-mode) on for sessions where it's available                                                                                                                                                        | Model and responses                | Any file                |
 | [`fastModePerSessionOptIn`](#fastmodepersessionoptin)                                           | Require people to turn [fast mode](/docs/en/fast-mode) on each session                                                                                                                                                           | Model and responses                | Any file                |
+| [`feedbackDrafts`](#feedbackdrafts)                                                             | Control whether Claude queues [feedback drafts](/docs/en/tools-reference#sendfeedback-tool-behavior) for you to review                                                                                                           | Privacy and telemetry              | User or managed         |
 | [`feedbackSurveyRate`](#feedbacksurveyrate)                                                     | Change how often the [session quality survey](/docs/en/data-usage#session-quality-surveys) appears                                                                                                                               | Privacy and telemetry              | Any file                |
 | [`fileCheckpointingEnabled`](#filecheckpointingenabled)                                         | Turn off or on the file snapshots that [`/rewind`](/docs/en/checkpointing) restores                                                                                                                                              | Memory and context                 | Any file                |
@@ -764,5 +765,5 @@ scope: "Which settings files can set the key: user (~/.claude/settings.json), pr
 | [`spellcheck`](#spellcheck)                                                                     | Underline misspelled words in the prompt input with a [spell checker](/docs/en/interactive-mode#check-spelling-as-you-type) you install                                                                                          | Interface and terminal             | User or managed         |
 | [`spinnerTipsEnabled`](#spinnertipsenabled)                                                     | Hide tips in the spinner while Claude works                                                                                                                                                                                 | Interface and terminal             | Any file                |
-| [`spinnerTipsOverride`](#spinnertipsoverride)                                                   | Replace or extend spinner tips with your own strings                                                                                                                                                                        | Interface and terminal             | Any file                |
+| [`spinnerTipsOverride`](#spinnertipsoverride)                                                   | Add your own tips to the spinner rotation, or replace the built-in tips                                                                                                                                                     | Interface and terminal             | Any file                |
 | [`spinnerVerbs`](#spinnerverbs)                                                                 | Add or replace the verbs shown while a turn runs                                                                                                                                                                            | Interface and terminal             | Any file                |
 | [`sshConfigs`](#sshconfigs)                                                                     | Add [SSH connections](/docs/en/desktop#pre-configure-ssh-connections-for-your-team) to the Desktop environment dropdown                                                                                                          | Remote, desktop, and notifications | User or managed         |
@@ -3059,21 +3060,64 @@ While Claude works, the spinner line rotates through short tips about Claude Cod
 ### `spinnerTipsOverride`
 
-Replace or extend the [spinner tips](#spinnertipsenabled), the short hints Claude Code rotates through while Claude works, with your own strings, such as a team reminder to run a review skill. Set `excludeDefault` to `true` and list at least one tip to show only your tips; when it's `false` or absent, or `tips` is empty, Claude Code keeps the built-in tips and adds yours.
+Add your own tips to the [spinner tips](#spinnertipsenabled) that Claude Code shows while Claude works, or replace the built-in tips with yours. Claude Code puts your tips in the same rotation as the built-in ones: it picks the tip that has gone unshown the longest, skips tips still in their cooldown, and breaks ties by priority.
 
-* **Scope**: [`Any file`](#scopes)
-* **Type**: object with a `tips` array of strings and an optional `excludeDefault` Boolean
+If you set [`spinnerTipsEnabled`](#spinnertipsenabled) to `false`, Claude Code hides all tips, yours included.
+
+* **Scope**: [`Any file`](#scopes). Claude Code honors tip objects, `tipsFile`, `label`, and `excludeDefault` from user settings, the `--settings` flag, and managed settings; from project and local settings it reads plain string tips only.
+* **Type**: object with `tips`, `tipsFile`, `label`, and `excludeDefault` fields, each optional
 * **Default**: unset, so Claude Code shows only the built-in tips
```

</details>

</details>


<details>
<summary>2026-08-26</summary>

**変更ファイル:**

```
 docs-ja/pages/changelog.md             | 68 ++++++++++++++++++++++++++++++++++
 docs-ja/pages/managed-settings-en.md   |  4 +-
 docs-ja/pages/settings-reference-en.md | 66 +++++++++++++++++++++++++++++++++
 3 files changed, 136 insertions(+), 2 deletions(-)
```

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index 4728175..8862f0c 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,72 @@
 # Changelog
 
+## 2.1.246
+
+- Added a startup warning for Bash allow rules with a wildcard before the subcommand (e.g. `Bash(git * main)`), since they also match options inserted before the subcommand
+- Added an Auto mode tab to `/permissions` for viewing and editing auto mode classifier rules
+- Added the turn's completion time to the end-of-turn duration line, e.g. `✻ Sautéed for 23s · done 6:05 PM`
+- Fixed fullscreen mode showing a blank transcript after resizing the terminal and jumping to the bottom until the next keypress
+- Fixed a severe transcript slowdown when a diff contained a very long single line (e.g. a base64 string); such lines now render truncated with a marker
+- Fixed erratic fullscreen scrolling when positioned at an earlier message, including jump-to-bottom getting stuck mid-transcript
+- Fixed background sessions failing to open after 45 seconds when Claude Code's starting directory had been deleted, the machine had slept, or the host is slow to start processes
+- Fixed background sessions failing to open with "Couldn't start the background service … EACCES" when another Claude Code process was re-installing the npm package at that moment
+- Fixed markdown rendering being disabled for a whole message when its first 500 characters contained no markdown, and for `+`/`N)` lists and setext headings
+- Fixed MCP tool calls interrupted by an incoming message in headless/remote sessions being reported to the model as "completed with no output" instead of an explicit interrupted error
+- Fixed MCP tool arguments being sent as JSON strings when the parameter's schema is empty (`{}`), instead of their real type
+- Fixed a command interrupted mid-run showing as "Ran 1 shell command" with no sign it was cut
+- Fixed pressing ← or running `/background` during a dynamic workflow restarting its finished subagents; it now asks first and says how many subagents would restart
+- Fixed opening a just-started session in `claude agents` while its worker was still booting (common on Windows) stopping it with "was stopped while the respawn was in flight"
+- Fixed `claude agents` listing a backgrounded named session twice; backgrounding the same conversation again now numbers the new row (e.g. `my-session (2)`)
+- Fixed the background retention sweep removing git worktrees under `.claude/worktrees/` that you created yourself when an old background-session record pointed at them
+- Fixed auto mode tool calls being denied as "temporarily unavailable" on very large sessions by scaling the safety-check deadline with prompt size
+- Fixed the plugin cache creating duplicate SHA-named directories for the same plugin
+- Fixed plugin skills whose frontmatter `name` already includes the `<plugin>:` prefix showing it doubled in the slash menu (e.g. `/plugin:plugin:skill`)
+- Fixed `claude plugin update` failing for an installed plugin given its bare name (only the fully-qualified name worked)
+- Fixed plugin installation failing when `plugin.json` was saved with a UTF-8 byte-order mark (BOM)
```

</details>

<details>
<summary>managed-settings-en.md</summary>

```diff
diff --git a/docs-ja/pages/managed-settings-en.md b/docs-ja/pages/managed-settings-en.md
index 341641a..7c2bfa0 100644
--- a/docs-ja/pages/managed-settings-en.md
+++ b/docs-ja/pages/managed-settings-en.md
@@ -85,5 +85,5 @@ A deployed policy reaches the developer's sessions as follows:
 * **Cloud sessions**: a session in an Anthropic-hosted environment doesn't read a device's MDM profile or file, so policy for it has to come from server-managed settings. A session in a [self-hosted environment](/docs/en/self-hosted-environments) reads the managed settings file in its runner image only when server-managed settings deliver no keys, apart from the [keys Claude Code reads from every admin source](#keys-read-from-every-admin-source).
 * **Running sessions**: a session picks up most changes on the schedule in the table without a restart. Claude Code reads [`forceRemoteSettingsRefresh`](/docs/en/settings-reference#forceremotesettingsrefresh) and [`requiredMinimumVersion`](/docs/en/settings-reference#requiredminimumversion) only at session start, arms a new or changed [`policyHelper`](/docs/en/settings-reference#policyhelper) entry at the next launch, and reads [some user-editable keys once at session start](/docs/en/settings#when-edits-take-effect).
-* **Changes that need approval**: a server-managed change to a setting that [needs approval](/docs/en/server-managed-settings#security-approval-dialogs), such as a hook or an `env` variable, waits for the developer to accept the dialog in an interactive session, and applies for the current run in a session an IDE extension or the Agent SDK hosts. Other server-managed changes apply on the next poll.
+* **Changes that need approval**: apart from the [updates that wait for the next launch](/docs/en/server-managed-settings#fetch-and-caching-behavior), a server-managed change to a setting that [needs approval](/docs/en/server-managed-settings#security-approval-dialogs), such as a hook or an `env` variable, waits for the developer to accept the dialog in an interactive session, and applies for the current run in a session an IDE extension or the Agent SDK hosts. Other server-managed changes apply on the next poll.
 * **Long-lived sessions**: a session left open for weeks can still lag a rollout. [`requiredMinimumVersion`](/docs/en/settings-reference#requiredminimumversion) blocks an outdated binary from starting and doesn't end a session that's already running.
 
@@ -264,5 +264,5 @@ Claude Code reads the following keys only from a managed source; placing them in
 Most of them are locks: the value a lock governs, such as permission rules or `sandbox.network.allowedDomains`, is an ordinary key that any level can set, and the lock tells Claude Code to honor only the managed value.
 
-The table covers the permission, plugin, and delivery controls. For any key not listed here, the Scope column of the [settings reference](/docs/en/settings-reference#all-settings) index says whether it's managed-only; the remaining managed-only keys there include the gateway login URL, version, browser, mobile-simulator, SSH host, sandbox binary path, and CLAUDE.md controls.
+The table covers the permission, plugin, and delivery controls. For any key not listed here, the Scope column of the [settings reference](/docs/en/settings-reference#all-settings) index says whether it's managed-only; the remaining managed-only keys there include the gateway login URL, version, browser, mobile-simulator, SSH host, Desktop local-session, sandbox binary path, and CLAUDE.md controls.
 
 | Setting                                                                                                               | Description                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
```

</details>

<details>
<summary>settings-reference-en.md</summary>

```diff
diff --git a/docs-ja/pages/settings-reference-en.md b/docs-ja/pages/settings-reference-en.md
index 4fce887..4da059b 100644
--- a/docs-ja/pages/settings-reference-en.md
+++ b/docs-ja/pages/settings-reference-en.md
@@ -641,4 +641,5 @@ scope: "Which settings files can set the key: user (~/.claude/settings.json), pr
 | [`disableCommandPluginSources`](#disablecommandpluginsources)                                   | Block [plugins](/docs/en/plugins) that install by running a marketplace-declared command                                                                                                                                         | Plugins and skills                 | Managed                 |
 | [`disableDeepLinkRegistration`](#disabledeeplinkregistration)                                   | Stop Claude Code from registering the [`claude-cli://` handler](/docs/en/deep-links)                                                                                                                                             | Remote, desktop, and notifications | Any file                |
+| [`disableDesktopLocalSessions`](#disabledesktoplocalsessions)                                   | Turn off [Desktop Code sessions](/docs/en/desktop#local-sessions-on-managed-devices) that run on the device, leaving SSH to other hosts and cloud                                                                                | Remote, desktop, and notifications | Managed                 |
 | [`disabledMcpjsonServers`](#disabledmcpjsonservers)                                             | Reject specific servers from a project's [`.mcp.json`](/docs/en/mcp#project-scope)                                                                                                                                               | MCP                                | Any file                |
 | [`disableMobileSimulatorTools`](#disablemobilesimulatortools)                                   | Block Claude's tools in the [desktop](/docs/en/desktop) iOS Simulator pane                                                                                                                                                       | Tools                              | Managed                 |
@@ -705,4 +706,5 @@ scope: "Which settings files can set the key: user (~/.claude/settings.json), pr
 | [`prefersReducedMotion`](#prefersreducedmotion)                                                 | [Reduce or turn off](/docs/en/accessibility#accessibility-settings) spinner, shimmer, and flash animations                                                                                                                       | Interface and terminal             | Any file                |
 | [`processWrapper`](#processwrapper)                                                             | Run Claude Code's background processes through a [corporate launcher](/docs/en/corporate-launcher) on macOS and Linux                                                                                                            | Agents, sessions, and worktrees    | User or managed         |
+| [`promptCacheTtl`](#promptcachettl)                                                             | Choose the [prompt cache lifetime](/docs/en/prompt-caching#cache-lifetime) for the main conversation                                                                                                                             | Model and responses                | Any file                |
 | [`promptSuggestionEnabled`](#promptsuggestionenabled)                                           | Hide the grayed-out [prompt suggestions](/docs/en/interactive-mode#prompt-suggestions) in the input box                                                                                                                          | Interface and terminal             | Any file                |
 | [`prUrlTemplate`](#prurltemplate)                                                               | Point PR links at an internal code-review tool instead of github.com                                                                                                                                                        | Git and attribution                | Any file                |
@@ -773,4 +775,5 @@ scope: "Which settings files can set the key: user (~/.claude/settings.json), pr
 | [`strictPluginOnlyCustomization.mcp`](#strictpluginonlycustomization-mcp)                       | Lock [MCP servers](/docs/en/mcp) to plugin and managed sources                                                                                                                                                                   | Plugins and skills                 | Managed                 |
 | [`strictPluginOnlyCustomization.skills`](#strictpluginonlycustomization-skills)                 | Lock [skills](/docs/en/skills) to plugin and managed sources                                                                                                                                                                     | Plugins and skills                 | Managed                 |
+| [`subagentPromptCacheTtl`](#subagentpromptcachettl)                                             | Choose the [prompt cache lifetime](/docs/en/prompt-caching#cache-lifetime) for subagents and other requests outside the main conversation                                                                                        | Model and responses                | Any file                |
 | [`subagentStatusLine`](#subagentstatusline)                                                     | Rewrite rows in the [subagent](/docs/en/sub-agents) task display with your own command                                                                                                                                           | Interface and terminal             | Any file                |
 | [`switchModelsOnFlag`](#switchmodelsonflag)                                                     | Switch models automatically or pause when a [safety classifier](/docs/en/model-config#ask-before-switching) flags a request                                                                                                      | Model and responses                | Any file                |
@@ -1079,4 +1082,26 @@ This example selects the built-in Explanatory style, which adds educational insi
 ```
 
+### `promptCacheTtl`
+
+Choose how long the [prompt cache](/docs/en/prompt-caching) holds the main conversation. This key applies to your interactive, `-p`, and Agent SDK turns, together with the helpers Claude Code runs inline with them. The one-hour lifetime keeps the cache warm across longer breaks, and the API [bills each cache write at a higher rate](https://platform.claude.com/docs/en/build-with-claude/prompt-caching#pricing) than at the five-minute lifetime. Requires Claude Code v2.1.242 or later.
+
+* **Scope**: [`Any file`](#scopes)
```

</details>

</details>


<details>
<summary>2026-08-25</summary>

**変更ファイル:**

```
 docs-ja/pages/changelog.md             |  63 ++++++++++++++++++++
 docs-ja/pages/context-window-ja.md     |  24 +++++---
 docs-ja/pages/managed-settings-en.md   |  43 +++++++-------
 docs-ja/pages/settings-reference-en.md | 104 ++++++++++++++++++++++++++++++---
 4 files changed, 197 insertions(+), 37 deletions(-)
```

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index 0280e56..4728175 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,67 @@
 # Changelog
 
+## 2.1.243
+
+- Added a Loops breakdown to `/usage`: per-loop run count, total tokens, tokens per run, and last run, so runaway or chatty `/loop` tasks are easy to spot
+- Added `modelPicker` setting: curate the `/model` picker with an ordered, labeled list of models (any id spelling, including Vertex/Bedrock ids), appended to or replacing the built-in lineup
+- Added `promptCacheTtl` and `subagentPromptCacheTtl` settings so API-key and cloud-provider users can keep a 1-hour prompt cache on the main conversation while subagents stay at 5 minutes
+- Added `modelPricing` managed setting so an organization's contracted per-model rates and discount multiplier are used for `/cost`, the status line, and telemetry cost figures instead of list price
+- Added a keyless sign-in under `/login` → Anthropic Console: "Sign in with your Console account" (recommended) alongside creating an API key, so organizations that don't allow API keys can sign in
+- Added a `Skipped sources` line to `/status` that lists managed settings sources (for example `managed-settings.json`) present but not applied because a higher-precedence managed source is active
+- Added a `managed` marker in `/mcp` and `/plugins` on claude.ai connectors whose authentication is managed by your organization
+- Added a tip pointing claude.ai users who haven't connected GitHub for Claude Code on the web to `/web-setup`
+- Added a `/status` line showing whether GitHub is connected for Claude Code on the web (Pro/Max), pointing to `/web-setup` when it isn't
+- Added the model (and effort level) each subagent ran on to `/tasks` and the agent detail dialogs
+- Fixed remote MCP servers in non-interactive (`-p`) and SDK sessions never recovering after a dropped connection; they now reconnect automatically or report as failed
+- Fixed MCP server sign-in started from the desktop app failing with "Invalid redirect URI" on servers that support client ID metadata documents (for example Linear)
+- Fixed auto mode staying unavailable at startup when a temporary server-side disable was cached and later flag fetches failed
+- Fixed auto mode tool calls being denied as "temporarily unavailable" after about a minute of waiting when the API was briefly overloaded and asked the client to retry
+- Fixed the `/model` picker silently ignoring an Ultracode selection; picking Ultracode now applies it to the current session
+- Fixed `/resume` only listing the 50 most recent sessions; the picker now loads more as you scroll
+- Fixed cloud sessions resuming after a mid-turn restart with a pending hook or background-task notification re-sent as the prompt instead of the normal continuation message
+- Fixed cross-session messaging silently turning off inside user namespaces and rootless containers after the 2.1.232 socket-directory hardening
+- Fixed text that hangs outside its container (for example the sign-in URL in `/login`) losing its leading columns when another part of the screen repaints
+- Fixed `spellcheck` not underlining a misspelled word typed directly after an emoji
+- Fixed background subagents not waking when their last background Bash task completes
```

</details>

<details>
<summary>context-window-ja.md</summary>

```diff
diff --git a/docs-ja/pages/context-window-ja.md b/docs-ja/pages/context-window-ja.md
index 1baf15e..860a385 100644
--- a/docs-ja/pages/context-window-ja.md
+++ b/docs-ja/pages/context-window-ja.md
@@ -92,4 +92,5 @@ export const ContextWindow = () => {
     color: '#8A8880',
     vis: 'brief',
+    restoredAfterCompact: true,
     desc: 'Main auth file. You see "Read auth.ts" in your terminal, but the 2,400 tokens of file content only Claude sees.',
     tip: 'File reads dominate context usage. Be specific in prompts ("fix the bug in auth.ts") so Claude reads fewer files. For research-heavy tasks, use a subagent.',
@@ -102,4 +103,5 @@ export const ContextWindow = () => {
     color: '#8A8880',
     vis: 'brief',
+    restoredAfterCompact: true,
     desc: 'Following imports to the token module. Shown as a one-liner in your terminal.',
     link: null
@@ -111,4 +113,5 @@ export const ContextWindow = () => {
     color: '#4A9B8E',
     vis: 'brief',
+    restoredAfterCompact: true,
     desc: 'This rule in `.claude/rules/` has a `paths:` pattern matching `src/api/**`. It loaded automatically when Claude read a file in that directory. You see "Loaded .claude/rules/api-conventions.md" in your terminal, but not the rule content.',
     link: '/en/memory#path-specific-rules'
@@ -120,4 +123,5 @@ export const ContextWindow = () => {
     color: '#8A8880',
     vis: 'brief',
+    restoredAfterCompact: true,
     desc: 'Tracing the auth flow deeper.',
     link: null
@@ -129,4 +133,5 @@ export const ContextWindow = () => {
     color: '#8A8880',
```

</details>

<details>
<summary>managed-settings-en.md</summary>

```diff
diff --git a/docs-ja/pages/managed-settings-en.md b/docs-ja/pages/managed-settings-en.md
index 19f2f2c..341641a 100644
--- a/docs-ja/pages/managed-settings-en.md
+++ b/docs-ja/pages/managed-settings-en.md
@@ -113,4 +113,5 @@ When two files set the same key, Claude Code combines them by these rules:
 * **`fallbackModel`**: the later chain replaces the earlier one whole
 * **[`extraKnownMarketplaces`](/docs/en/settings-reference#extraknownmarketplaces)**: a later entry with the same name replaces the earlier one whole
+* **[`modelPicker`](/docs/en/settings-reference#modelpicker)**: the later lineup replaces the earlier one whole
 
 <span id="precedence-within-the-managed-tier" />
@@ -265,25 +266,25 @@ Most of them are locks: the value a lock governs, such as permission rules or `s
 The table covers the permission, plugin, and delivery controls. For any key not listed here, the Scope column of the [settings reference](/docs/en/settings-reference#all-settings) index says whether it's managed-only; the remaining managed-only keys there include the gateway login URL, version, browser, mobile-simulator, SSH host, sandbox binary path, and CLAUDE.md controls.
 
-| Setting                                                                                                               | Description                                                                                                                                                                                                                                                                                                  |
-| :-------------------------------------------------------------------------------------------------------------------- | :----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
-| [`allowAllClaudeAiMcps`](/docs/en/settings-reference#allowallclaudeaimcps)                                                 | Load the claude.ai connectors alongside a deployed `managed-mcp.json` instead of suppressing them                                                                                                                                                                                                            |
-| [`allowedChannelPlugins`](/docs/en/settings-reference#allowedchannelplugins)                                               | Allowlist of channel plugins that may push messages. Replaces the default Anthropic allowlist when set. Requires `channelsEnabled: true`. See [Restrict which channel plugins can run](/docs/en/channels#restrict-which-channel-plugins-can-run)                                                                  |
-| [`allowManagedHooksOnly`](/docs/en/settings-reference#allowmanagedhooksonly)                                               | When `true`, restricts which hooks run; see [what runs under `allowManagedHooksOnly`](/docs/en/settings-reference#what-runs-under-allowmanagedhooksonly) for the full effect list                                                                                                                                 |
-| [`allowManagedMcpServersOnly`](/docs/en/settings-reference#allowmanagedmcpserversonly)                                     | When `true`, only `allowedMcpServers` from managed settings are respected. `deniedMcpServers` still merges from all sources. See [Managed MCP configuration](/docs/en/managed-mcp)                                                                                                                                |
-| [`allowManagedPermissionRulesOnly`](/docs/en/settings-reference#allowmanagedpermissionrulesonly)                           | Only managed permission rules apply; the entry lists every source it ignores                                                                                                                                                                                                                                 |
-| [`blockedMarketplaces`](/docs/en/settings-reference#blockedmarketplaces)                                                   | Blocklist of marketplace sources. Blocked sources are checked before downloading, so they never touch the filesystem. See [managed marketplace restrictions](/docs/en/plugin-marketplaces#managed-marketplace-restrictions)                                                                                       |
-| [`channelsEnabled`](/docs/en/settings-reference#channelsenabled)                                                           | Allow [channels](/docs/en/channels) for the organization. See [enterprise controls](/docs/en/channels#enterprise-controls) for the default on each plan                                                                                                                                                                |
-| [`disableCommandPluginSources`](/docs/en/settings-reference#disablecommandpluginsources)                                   | When `true`, blocks [`command` plugin sources](/docs/en/plugin-marketplaces#command-sources) entirely, so the marketplace-declared command never runs. When unset, follows `allowManagedHooksOnly`. Requires Claude Code v2.1.229 or later                                                                        |
-| [`disableSideloadFlags`](/docs/en/settings-reference#disablesideloadflags)                                                 | Reject the `--plugin-dir`, `--plugin-url`, `--agents`, and `--mcp-config` flags at startup. In cloud sessions, Claude Code drops the MCP servers the server delivered through `--mcp-config`, other than in-process `type: "sdk"` entries, and starts the session. Requires Claude Code v2.1.193 or later    |
-| [`forceRemoteSettingsRefresh`](/docs/en/settings-reference#forceremotesettingsrefresh)                                     | When `true`, blocks CLI startup until remote managed settings are freshly fetched and exits if the fetch fails. See [fail-closed enforcement](/docs/en/server-managed-settings#enforce-fail-closed-startup)                                                                                                       |
-| [`parentSettingsBehavior`](/docs/en/settings-reference#parentsettingsbehavior)                                             | Whether host-supplied parent settings merge under the managed policy                                                                                                                                                                                                                                         |
-| [`pluginSuggestionMarketplaces`](/docs/en/settings-reference#pluginsuggestionmarketplaces)                                 | Marketplaces whose plugins Claude Code may suggest to users                                                                                                                                                                                                                                                  |
-| [`pluginTrustMessage`](/docs/en/settings-reference#plugintrustmessage)                                                     | Custom message appended to the plugin trust warning shown before installation                                                                                                                                                                                                                                |
-| [`policyHelper`](/docs/en/settings-reference#policyhelper)                                                                 | Executable that computes managed settings at startup; see [Compute managed settings with a policy helper](/docs/en/settings-reference#policyhelper)                                                                                                                                                               |
-| [`sandbox.filesystem.allowManagedReadPathsOnly`](/docs/en/settings-reference#sandbox-filesystem-allowmanagedreadpathsonly) | When `true`, only `filesystem.allowRead` paths from managed settings are respected. `denyRead` still merges from all sources                                                                                                                                                                                 |
```

</details>

<details>
<summary>settings-reference-en.md</summary>

```diff
diff --git a/docs-ja/pages/settings-reference-en.md b/docs-ja/pages/settings-reference-en.md
index 0a73d0a..4fce887 100644
--- a/docs-ja/pages/settings-reference-en.md
+++ b/docs-ja/pages/settings-reference-en.md
@@ -607,4 +607,5 @@ scope: "Which settings files can set the key: user (~/.claude/settings.json), pr
 | [`autoCompactWindow`](#autocompactwindow)                                                       | Set how full the context gets before Claude Code [compacts](/docs/en/context-window)                                                                                                                                             | Memory and context                 | Any file                |
 | [`autoConnectIde`](#autoconnectide)                                                             | Connect to a running [VS Code](/docs/en/vs-code) or [JetBrains](/docs/en/jetbrains#from-external-terminals) IDE automatically from an external terminal                                                                               | Global config settings             | Global config           |
+| [`autoContinueAtUsageLimit`](#autocontinueatusagelimit)                                         | Wait in the open session and [continue the task automatically](/docs/en/interactive-mode#wait-for-a-usage-limit-to-reset) after a claude.ai usage limit resets                                                                   | Interface and terminal             | User or managed         |
 | [`autoInstallIdeExtension`](#autoinstallideextension)                                           | Turn off automatic install of the [IDE extension](/docs/en/vs-code#install-the-extension) from a VS Code terminal                                                                                                                | Global config settings             | Global config           |
 | [`autoMemoryDirectory`](#automemorydirectory)                                                   | Store [auto memory](/docs/en/memory#auto-memory) in a directory you choose                                                                                                                                                       | Memory and context                 | Any file                |
@@ -681,4 +682,5 @@ scope: "Which settings files can set the key: user (~/.claude/settings.json), pr
 | [`model`](#model)                                                                               | Change the [model](/docs/en/model-config#set-a-default-model-for-new-sessions) Claude Code starts with                                                                                                                           | Model and responses                | Any file                |
 | [`modelOverrides`](#modeloverrides)                                                             | [Map model IDs](/docs/en/model-config#override-model-ids-per-version) to your provider's IDs, such as Bedrock ARNs                                                                                                               | Model and responses                | Any file                |
+| [`modelPicker`](#modelpicker)                                                                   | Choose which models the [`/model` picker](/docs/en/model-config#available-models) lists, in your own order and with your own labels                                                                                              | Model and responses                | User or managed         |
 | [`otelHeadersHelper`](#otelheadershelper)                                                       | Generate rotating [OpenTelemetry](/docs/en/monitoring-usage#dynamic-headers) headers with your own command                                                                                                                       | Authentication and providers       | Any file                |
 | [`outputStyle`](#outputstyle)                                                                   | Change Claude's role, tone, and output format with an [output style](/docs/en/output-styles)                                                                                                                                     | Model and responses                | Any file                |
@@ -1011,4 +1013,52 @@ This example routes every call for Opus 4.6 to the named Bedrock inference profi
 See [Override model IDs per version](/docs/en/model-config#override-model-ids-per-version).
 
+### `modelPicker`
+
+List the models the `/model` picker offers, in the order you write them and under labels you choose, so the picker lists the models your organization runs, after the built-in lineup or instead of it. Each row's `model` is taken verbatim, so it accepts anything `--model` accepts: an alias such as `opus`, an Anthropic model ID, or a provider-format ID for Amazon Bedrock, Google Cloud's Agent Platform, Microsoft Foundry, or an LLM gateway. Requires Claude Code v2.1.242 or later.
+
+* **Scope**: [`User or managed`](#scopes). Claude Code reads the key from managed settings, `--settings`, and user settings, and ignores it in project and local settings so a repository you clone can't relabel the picker. The highest of those three that sets the key supplies the whole lineup, and Claude Code never combines lineups from two sources.
+* **Type**: object with an `options` array of rows and an optional `replaceBuiltInOptions` Boolean
+* **Default**: unset, so the picker shows the built-in lineup
+
+This example adds two Bedrock deployments after the built-in lineup, under names your team recognizes:
+
+```json managed-settings.json theme={null}
```

</details>

</details>


<details>
<summary>2026-08-24</summary>

**変更ファイル:**

```
 docs-ja/pages/changelog.md | 4 ++++
 1 file changed, 4 insertions(+)
```

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index e3a480a..0280e56 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,8 @@
 # Changelog
 
+## 2.1.241
+
+- Bug fixes and reliability improvements
+
 ## 2.1.240
 
```

</details>

</details>


<details>
<summary>2026-08-23</summary>

**変更ファイル:**

```
 docs-ja/pages/changelog.md                         |  4 ++
 docs-ja/pages/claude-apps-gateway-ja.md            |  2 +-
 docs-ja/pages/cross-session-messaging-en.md        | 18 +++++----
 docs-ja/pages/managed-settings-en.md               | 44 +++++++++++-----------
 .../self-hosted-environments-configuration-en.md   |  6 +--
 .../pages/self-hosted-environments-deploy-en.md    |  4 +-
 docs-ja/pages/self-hosted-environments-en.md       |  2 +-
 .../pages/self-hosted-environments-identity-en.md  |  2 +-
 .../self-hosted-environments-quickstart-en.md      |  4 +-
 .../pages/self-hosted-environments-reference-en.md |  4 +-
 .../pages/self-hosted-environments-testing-en.md   |  6 +--
 docs-ja/pages/settings-reference-en.md             | 39 +++++++------------
 12 files changed, 66 insertions(+), 69 deletions(-)
```

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index b05c306..e3a480a 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,8 @@
 # Changelog
 
+## 2.1.240
+
+- Bug fixes and reliability improvements
+
 ## 2.1.239
 
```

</details>

<details>
<summary>claude-apps-gateway-ja.md</summary>

```diff
diff --git a/docs-ja/pages/claude-apps-gateway-ja.md b/docs-ja/pages/claude-apps-gateway-ja.md
index f4cd226..79d34a6 100644
--- a/docs-ja/pages/claude-apps-gateway-ja.md
+++ b/docs-ja/pages/claude-apps-gateway-ja.md
@@ -37,5 +37,5 @@ Claude アプリゲートウェイは、開発者の Claude Code クライアン
 
 <Frame>
-  <img src="https://mintcdn.com/claude-code/st9_ZQOFsZa3cKFl/images/claude-gateway-architecture.svg?fit=max&auto=format&n=st9_ZQOFsZa3cKFl&q=85&s=560770d8f49bbd6f1ca7090ed1f13c03" alt="Claude Code クライアントがベアラートークンを使用して HTTPS 経由でインフラストラクチャ内の自己ホスト型 Claude apps ゲートウェイに接続し、IdP に対してユーザーにサインインし、PostgreSQL に認証状態を保存し、テレメトリを OTLP コレクターにリレーし、Amazon Bedrock、Claude Platform on AWS、Google Cloud、Microsoft Foundry、または Anthropic API に推論を転送する図" width="760" height="320" data-path="images/claude-gateway-architecture.svg" />
+  <img src="https://mintcdn.com/claude-code/VbyXug8hBU9UK6oT/images/claude-gateway-architecture.svg?fit=max&auto=format&n=VbyXug8hBU9UK6oT&q=85&s=9e4f1190fc56718144190a3db61c63af" alt="Claude Code クライアントがベアラートークンを使用して HTTPS 経由でインフラストラクチャ内の自己ホスト型 Claude apps ゲートウェイに接続し、IdP に対してユーザーにサインインし、PostgreSQL に認証状態を保存し、テレメトリを OTLP コレクターにリレーし、Amazon Bedrock、Claude Platform on AWS、Google Cloud、Microsoft Foundry、または Anthropic API に推論を転送する図" width="760" height="320" data-path="images/claude-gateway-architecture.svg" />
 </Frame>
 
```

</details>

<details>
<summary>cross-session-messaging-en.md</summary>

```diff
diff --git a/docs-ja/pages/cross-session-messaging-en.md b/docs-ja/pages/cross-session-messaging-en.md
index b476ac6..e9f6ce3 100644
--- a/docs-ja/pages/cross-session-messaging-en.md
+++ b/docs-ja/pages/cross-session-messaging-en.md
@@ -69,4 +69,5 @@ Claude Code refuses a message in the following cases:
 * A rapid burst to a session on this machine has reached [what that session's inbox accepts](#limitations). Claude Code refuses further messages to that session.
 * The reply target on this machine fails a safety check, such as a symlinked target or an endpoint that isn't the expected process. [Refusing to send a cross-session message](/docs/en/errors#refusing-to-send-a-cross-session-message) lists these checks.
+* Claude addresses the message to this session's own name, as described under [See which sessions Claude can reach](#see-which-sessions-claude-can-reach).
 
 The receiving session checks each arriving message against its own [inbound controls](#control-inbound-messages), and the check ends in one of three outcomes:
@@ -111,11 +112,14 @@ Only the Claude in your main conversation can subscribe, and only to your sessio
 ### See which sessions Claude can reach
 
-Claude finds a message's target on its own, so you don't need to run anything before asking it to send. To see for yourself which sessions Claude can reach, run the `/list-agents` command. It lists each session with the name it answers to, and that name is where Claude addresses a message. The listing covers:
+Claude finds a message's target on its own, so you don't need to run anything before asking it to send. To see for yourself which sessions Claude can reach, run the `/list-agents` command. The first line is this session's own name, the one your other sessions use to message it. The rows below it are the sessions Claude can reach, each with the name it answers to:
 
-* **Subagents**: agents running inside the current session. [Agent team](/docs/en/agent-teams) teammates aren't listed; Claude messages them through the team's own roster.
+* **Subagents**: agents running inside the current session.
+* **Teammates**: this session's own [agent team](/docs/en/agent-teams) teammates. Before v2.1.239, teammates didn't appear in the listing, though Claude could already message them by name.
 * **Your other local sessions**: Claude Code sessions running on the same machine, including [background sessions](/docs/en/agent-view). A session appears only when it binds an [inbox socket](#the-sessions-inbox-socket). The worker process that the [supervisor process](/docs/en/agent-view#the-supervisor-process) keeps ready for your next background session appears once you dispatch work to it.
 * **Your cloud sessions**: your [Claude Code on the web](/docs/en/claude-code-on-the-web) sessions, shown while this session is connected to [Remote Control](/docs/en/remote-control). Claude Code labels them `cloud` in the listing.
 * **Your Remote Control sessions on other machines**: shown while this session is connected to [Remote Control](/docs/en/remote-control), and labeled `Remote Control`. Claude Code shows `offline` as the status of a session whose Remote Control connection has dropped.
 
+This session isn't one of the rows. If Claude addresses a message to this session's own name, Claude Code refuses it and tells Claude the target is the current session. Before v2.1.239, the listing didn't show this session's name, and Claude Code reported a message sent to it as an agent it couldn't find.
+
 Claude Code reads your cloud and Remote Control session lists newest first and stops after a bounded number of pages for each. If your account has more of those sessions than fit, Claude Code doesn't list the older ones, and Claude can't message them by name. When this happens, Claude Code says so in the listing, and Claude sees the same note when it sends a message.
 
@@ -133,9 +137,9 @@ When you rename a session, or start or resume an interactive one, with a name an
 How a message travels, and whether it passes through Anthropic servers, depends on where the target session runs:
 
```

</details>

<details>
<summary>managed-settings-en.md</summary>

```diff
diff --git a/docs-ja/pages/managed-settings-en.md b/docs-ja/pages/managed-settings-en.md
index 8b6b232..19f2f2c 100644
--- a/docs-ja/pages/managed-settings-en.md
+++ b/docs-ja/pages/managed-settings-en.md
@@ -83,5 +83,5 @@ A deployed policy reaches the developer's sessions as follows:
 
 * **Surfaces**: every surface that runs Claude Code on the machine reads these sources: the terminal, the VS Code and JetBrains extensions, the desktop app, and [Agent SDK](/docs/en/agent-sdk/typescript) sessions, which load managed settings even when `settingSources` excludes the user, project, and local files.
-* **Cloud sessions**: a session in an Anthropic-hosted environment doesn't read a device's MDM profile or file, so policy for it has to come from server-managed settings. A session in a [self-hosted environment](/docs/en/self-hosted-environments) reads the managed settings file in its runner image only when server-managed settings deliver no keys.
+* **Cloud sessions**: a session in an Anthropic-hosted environment doesn't read a device's MDM profile or file, so policy for it has to come from server-managed settings. A session in a [self-hosted environment](/docs/en/self-hosted-environments) reads the managed settings file in its runner image only when server-managed settings deliver no keys, apart from the [keys Claude Code reads from every admin source](#keys-read-from-every-admin-source).
 * **Running sessions**: a session picks up most changes on the schedule in the table without a restart. Claude Code reads [`forceRemoteSettingsRefresh`](/docs/en/settings-reference#forceremotesettingsrefresh) and [`requiredMinimumVersion`](/docs/en/settings-reference#requiredminimumversion) only at session start, arms a new or changed [`policyHelper`](/docs/en/settings-reference#policyhelper) entry at the next launch, and reads [some user-editable keys once at session start](/docs/en/settings#when-edits-take-effect).
 * **Changes that need approval**: a server-managed change to a setting that [needs approval](/docs/en/server-managed-settings#security-approval-dialogs), such as a hook or an `env` variable, waits for the developer to accept the dialog in an interactive session, and applies for the current run in a session an IDE extension or the Agent SDK hosts. Other server-managed changes apply on the next poll.
@@ -265,25 +265,25 @@ Most of them are locks: the value a lock governs, such as permission rules or `s
 The table covers the permission, plugin, and delivery controls. For any key not listed here, the Scope column of the [settings reference](/docs/en/settings-reference#all-settings) index says whether it's managed-only; the remaining managed-only keys there include the gateway login URL, version, browser, mobile-simulator, SSH host, sandbox binary path, and CLAUDE.md controls.
 
-| Setting                                                                                                               | Description                                                                                                                                                                                                                                 |
-| :-------------------------------------------------------------------------------------------------------------------- | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
-| [`allowAllClaudeAiMcps`](/docs/en/settings-reference#allowallclaudeaimcps)                                                 | Load the claude.ai connectors alongside a deployed `managed-mcp.json` instead of suppressing them                                                                                                                                           |
-| [`allowedChannelPlugins`](/docs/en/settings-reference#allowedchannelplugins)                                               | Allowlist of channel plugins that may push messages. Replaces the default Anthropic allowlist when set. Requires `channelsEnabled: true`. See [Restrict which channel plugins can run](/docs/en/channels#restrict-which-channel-plugins-can-run) |
-| [`allowManagedHooksOnly`](/docs/en/settings-reference#allowmanagedhooksonly)                                               | When `true`, restricts which hooks run; see [what runs under `allowManagedHooksOnly`](/docs/en/settings-reference#what-runs-under-allowmanagedhooksonly) for the full effect list                                                                |
-| [`allowManagedMcpServersOnly`](/docs/en/settings-reference#allowmanagedmcpserversonly)                                     | When `true`, only `allowedMcpServers` from managed settings are respected. `deniedMcpServers` still merges from all sources. See [Managed MCP configuration](/docs/en/managed-mcp)                                                               |
-| [`allowManagedPermissionRulesOnly`](/docs/en/settings-reference#allowmanagedpermissionrulesonly)                           | Only managed permission rules apply; the entry lists every source it ignores                                                                                                                                                                |
-| [`blockedMarketplaces`](/docs/en/settings-reference#blockedmarketplaces)                                                   | Blocklist of marketplace sources. Blocked sources are checked before downloading, so they never touch the filesystem. See [managed marketplace restrictions](/docs/en/plugin-marketplaces#managed-marketplace-restrictions)                      |
-| [`channelsEnabled`](/docs/en/settings-reference#channelsenabled)                                                           | Allow [channels](/docs/en/channels) for the organization. See [enterprise controls](/docs/en/channels#enterprise-controls) for the default on each plan                                                                                               |
-| [`disableCommandPluginSources`](/docs/en/settings-reference#disablecommandpluginsources)                                   | When `true`, blocks [`command` plugin sources](/docs/en/plugin-marketplaces#command-sources) entirely, so the marketplace-declared command never runs. When unset, follows `allowManagedHooksOnly`. Requires Claude Code v2.1.229 or later       |
-| [`disableSideloadFlags`](/docs/en/settings-reference#disablesideloadflags)                                                 | Reject the `--plugin-dir`, `--plugin-url`, `--agents`, and `--mcp-config` flags at startup. Requires Claude Code v2.1.193 or later                                                                                                          |
-| [`forceRemoteSettingsRefresh`](/docs/en/settings-reference#forceremotesettingsrefresh)                                     | When `true`, blocks CLI startup until remote managed settings are freshly fetched and exits if the fetch fails. See [fail-closed enforcement](/docs/en/server-managed-settings#enforce-fail-closed-startup)                                      |
-| [`parentSettingsBehavior`](/docs/en/settings-reference#parentsettingsbehavior)                                             | Whether host-supplied parent settings merge under the managed policy                                                                                                                                                                        |
-| [`pluginSuggestionMarketplaces`](/docs/en/settings-reference#pluginsuggestionmarketplaces)                                 | Marketplaces whose plugins Claude Code may suggest to users                                                                                                                                                                                 |
-| [`pluginTrustMessage`](/docs/en/settings-reference#plugintrustmessage)                                                     | Custom message appended to the plugin trust warning shown before installation                                                                                                                                                               |
-| [`policyHelper`](/docs/en/settings-reference#policyhelper)                                                                 | Executable that computes managed settings at startup; see [Compute managed settings with a policy helper](/docs/en/settings-reference#policyhelper)                                                                                              |
```

</details>

<details>
<summary>self-hosted-environments-configuration-en.md</summary>

```diff
diff --git a/docs-ja/pages/self-hosted-environments-configuration-en.md b/docs-ja/pages/self-hosted-environments-configuration-en.md
index 27ac571..b5360a1 100644
--- a/docs-ja/pages/self-hosted-environments-configuration-en.md
+++ b/docs-ja/pages/self-hosted-environments-configuration-en.md
@@ -8,5 +8,5 @@
 
 <Note>
-  Self-hosted environments are in public beta on Team and Enterprise plans; an [Owner or admin](/docs/en/cloud-environments#organization-shared-environments) enables them by turning on **Allow self-hosted environments** on the [**Cloud environments** admin page](https://claude.ai/admin-settings/cloud-environments). This page assumes a working runner; see the [quickstart](/docs/en/self-hosted-environments-quickstart) for setup and [Deploy to production](/docs/en/self-hosted-environments-deploy) for the fleet recipes.
+  Self-hosted environments are in public beta on Team and Enterprise plans; an [Owner](/docs/en/cloud-environments#organization-shared-environments) enables them by turning on **Allow self-hosted environments** on the [**Cloud environments** admin page](https://claude.ai/admin-settings/cloud-environments). This page assumes a working runner; see the [quickstart](/docs/en/self-hosted-environments-quickstart) for setup and [Deploy to production](/docs/en/self-hosted-environments-deploy) for the fleet recipes.
 </Note>
 
@@ -226,5 +226,5 @@ The contract has four provisioner-agnostic rules:
 1. **Be idempotent on `CLAUDE_RUNNER_ORDER_ID`.** Redelivery of the same request must spawn at most one runner. Derive a deterministic resource name from the ID and let your platform reject the duplicate.
 2. **Don't retry the workload.** One order ID means at most one created workload. If the runner never registers, Anthropic re-requests with a fresh order ID after `--expected-spawn-seconds`.
-3. **Use the exit-code contract.** Exit 0 means submitted. Exit 1 means retryable failure; the session backs off and is re-offered. Exit 2 or higher means non-retryable; the session is blocked from spawning again until an [Owner or admin](/docs/en/cloud-environments#organization-shared-environments) selects **Retry** on it in the environment's **Activity** tab. On non-zero exit, the tail of the hook's stderr appears there as the failure reason, so write the actionable error to stderr and never secrets. For a pre-warming request there is no session to fail: the orchestrator logs a non-zero exit locally only, and the server re-requests the spawn after the lease.
+3. **Use the exit-code contract.** Exit 0 means submitted. Exit 1 means retryable failure; the session backs off and is re-offered. Exit 2 or higher means non-retryable; the session is blocked from spawning again until an [Owner](/docs/en/cloud-environments#organization-shared-environments) selects **Retry** on it in the environment's **Activity** tab. On non-zero exit, the tail of the hook's stderr appears there as the failure reason, so write the actionable error to stderr and never secrets. For a pre-warming request there is no session to fail: the orchestrator logs a non-zero exit locally only, and the server re-requests the spawn after the lease.
 4. **Set `--expected-spawn-seconds` to at least your p99 boot time.** This is the server-side lease. All orchestrator replicas must use the same value.
 
@@ -379,5 +379,5 @@ To pre-approve specific tools instead, append `--allowed-tools` with your rules,
 The runner gives each session its own config directory, seeded from an in-memory snapshot of the host's `~/.claude/` that the runner captures once at startup: `settings.json`, `CLAUDE.md`, hooks, agents, commands, and skills in your runner image apply to every session as the user-level baseline. Because the snapshot is taken at startup, config changes on a running host take effect only after a runner restart. Set `SELF_HOSTED_RUNNER_HOST_CONFIG_DIR` to seed from a different path, or point it at an empty directory to disable seeding.
 
-Repository-committed `.claude/settings.json` layers on top as project settings. Sessions also read [`managed-settings.json`](/docs/en/settings#where-settings-live) from the standard system path in your runner image, but the managed tier uses one source at a time, and [server-managed settings](/docs/en/server-managed-settings) are checked first: if your organization delivers any server-managed keys, sessions ignore the runner image's managed file, except that `env` blocks merge per key across managed sources. See [settings precedence](/docs/en/settings#settings-precedence).
+Repository-committed `.claude/settings.json` layers on top as project settings. Sessions also read [`managed-settings.json`](/docs/en/settings#where-settings-live) from the standard system path in your runner image, but the managed tier uses one source at a time, and [server-managed settings](/docs/en/server-managed-settings) are checked first: if your organization delivers any server-managed keys, sessions ignore the runner image's managed file except for its cross-source keys. Claude Code still reads the `env` block and the other [keys it reads from every admin source](/docs/en/managed-settings#keys-read-from-every-admin-source) from that file, such as the sandbox locks, the sandbox binary paths, and `forceRemoteSettingsRefresh`. See [settings precedence](/docs/en/settings#settings-precedence).
 
 When Anthropic's control plane supplies a session with [Claude Code hooks](/docs/en/hooks), the runner installs them alongside, not over, your own configuration. Requires Claude Code v2.1.229 or later.
```

</details>

<details>
<summary>self-hosted-environments-deploy-en.md</summary>

```diff
diff --git a/docs-ja/pages/self-hosted-environments-deploy-en.md b/docs-ja/pages/self-hosted-environments-deploy-en.md
index de3dca9..4e41400 100644
--- a/docs-ja/pages/self-hosted-environments-deploy-en.md
+++ b/docs-ja/pages/self-hosted-environments-deploy-en.md
@@ -30,5 +30,5 @@ A self-hosted runner executes arbitrary, model-directed code on your infrastruct
   The block applies to your wrapper script and lifecycle hooks too, since they share the container. Authenticate any token exchange with the [session JWT](/docs/en/self-hosted-environments-identity) against your own token service over allowlisted egress, or use a file-based web identity such as IAM Roles for Service Accounts (IRSA) on Amazon EKS.
 * **Per-runner filesystem isolation**: each runner process gets its own working directory that no other process on the host can read or write. Make `--hooks-dir`, the wrapper script, and the host's `~/.claude/` read-only to the session, either built into the image or mounted read-only.
-* **Dispatch is organization-wide**: any member of your Anthropic organization can dispatch a session to any of its environments, and there's no per-environment access control on dispatch. Treat every runner host as reachable for code execution by every org member, and place data or credentials on a runner host only if every org member is allowed to read them. [`--lock-to-account`](/docs/en/self-hosted-environments-reference#runner-cli-flags) bounds which account's sessions a given host executes, but dispatch into the environment itself stays organization-wide. To make self-hosted environments the only picker option, an [Owner or admin](/docs/en/cloud-environments#organization-shared-environments) can hide Anthropic-hosted environments for the whole organization from the [**Cloud environments** page](https://claude.ai/admin-settings/cloud-environments).
+* **Dispatch is organization-wide**: any member of your Anthropic organization can dispatch a session to any of its environments, and there's no per-environment access control on dispatch. Treat every runner host as reachable for code execution by every org member, and place data or credentials on a runner host only if every org member is allowed to read them. [`--lock-to-account`](/docs/en/self-hosted-environments-reference#runner-cli-flags) bounds which account's sessions a given host executes, but dispatch into the environment itself stays organization-wide. To make self-hosted environments the only picker option, an [Owner](/docs/en/cloud-environments#organization-shared-environments) can hide Anthropic-hosted environments for the whole organization from the [**Cloud environments** page](https://claude.ai/admin-settings/cloud-environments).
 * **Enforce the repo-settings guard**: choose the guard mode with [`--confine-repo-settings`](/docs/en/self-hosted-environments-reference#runner-cli-flags). The default `warn` logs a violation and still spawns the session, `enforce` refuses the session, and `off` disables the scan. The runner scans each repository's committed settings for:
 
@@ -59,5 +59,5 @@ Whether these hosts are needed depends on your configuration:
 | :----------------------------------- | :--- | :-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
 | `downloads.claude.ai`                | 443  | At install time, when you install or update Claude Code on the host with the native installer; the `install.sh` script itself is served from `claude.ai`. At session runtime, only when sessions install plugins from the official Anthropic marketplace.                               |
-| `storage.googleapis.com`             | 443  | At session runtime, for marketplace plugin catalog fetches and Artifact publishing when the Artifact tool is enabled; Artifact publishing falls back to `api.anthropic.com` when this host is blocked.                                                                                  |
+| `storage.googleapis.com`             | 443  | At session runtime, for the plugin install counts and metadata shown in `/plugin`.                                                                                                                                                                                                      |
 | `code.claude.com` and `claude.com`   | 443  | Documentation lookups by the built-in claude-code-guide agent and pre-approved WebFetch requests during sessions. Blocking these hosts only affects documentation lookups.                                                                                                              |
 | `*.frame.claudeusercontent.com`      | 443  | Only when the [Artifact tool](/docs/en/artifacts#availability) is available for sessions in your organization; defaults vary by plan, per the availability table there. Set `CLAUDE_CODE_DISABLE_ARTIFACT=1` on the runner to keep the tool disabled regardless of the organization setting. |
```

</details>

<details>
<summary>self-hosted-environments-en.md</summary>

```diff
diff --git a/docs-ja/pages/self-hosted-environments-en.md b/docs-ja/pages/self-hosted-environments-en.md
index b136be1..99069ca 100644
--- a/docs-ja/pages/self-hosted-environments-en.md
+++ b/docs-ja/pages/self-hosted-environments-en.md
@@ -41,5 +41,5 @@ You can start runners yourself and keep them running, or run the [autoscaling or
 Check these before planning a rollout:
 
-* **Plans**: public beta for Team and Enterprise organizations. Self-hosted environments are off by default; an [Owner or admin](/docs/en/cloud-environments#organization-shared-environments) turns on **Allow self-hosted environments** on the [**Cloud environments** admin page](https://claude.ai/admin-settings/cloud-environments), which requires [Claude Code on the web](/docs/en/claude-code-on-the-web) to be enabled for the organization.
+* **Plans**: public beta for Team and Enterprise organizations. Self-hosted environments are off by default; an [Owner](/docs/en/cloud-environments#organization-shared-environments) turns on **Allow self-hosted environments** on the [**Cloud environments** admin page](https://claude.ai/admin-settings/cloud-environments), which requires [Claude Code on the web](/docs/en/claude-code-on-the-web) to be enabled for the organization.
 * **Zero Data Retention**: unavailable for organizations with [Zero Data Retention](/docs/en/zero-data-retention) enabled.
 * **Model inference**: sessions use the Anthropic API, and inference can't be routed through [Amazon Bedrock, Google Cloud's Agent Platform, Microsoft Foundry](/docs/en/third-party-integrations), or an [LLM gateway](/docs/en/llm-gateway).
```

</details>

<details>
<summary>self-hosted-environments-identity-en.md</summary>

```diff
diff --git a/docs-ja/pages/self-hosted-environments-identity-en.md b/docs-ja/pages/self-hosted-environments-identity-en.md
index 6784e5b..a134453 100644
--- a/docs-ja/pages/self-hosted-environments-identity-en.md
+++ b/docs-ja/pages/self-hosted-environments-identity-en.md
@@ -8,5 +8,5 @@
 
 <Note>
-  Self-hosted environments are in public beta on Team and Enterprise plans; an [Owner or admin](/docs/en/cloud-environments#organization-shared-environments) enables them by turning on **Allow self-hosted environments** on the [**Cloud environments** admin page](https://claude.ai/admin-settings/cloud-environments). This page covers session identity verification; see the [quickstart](/docs/en/self-hosted-environments-quickstart) for setup and [Deploy to production](/docs/en/self-hosted-environments-deploy) for the fleet recipes.
+  Self-hosted environments are in public beta on Team and Enterprise plans; an [Owner](/docs/en/cloud-environments#organization-shared-environments) enables them by turning on **Allow self-hosted environments** on the [**Cloud environments** admin page](https://claude.ai/admin-settings/cloud-environments). This page covers session identity verification; see the [quickstart](/docs/en/self-hosted-environments-quickstart) for setup and [Deploy to production](/docs/en/self-hosted-environments-deploy) for the fleet recipes.
 </Note>
 
```

</details>

<details>
<summary>self-hosted-environments-quickstart-en.md</summary>

```diff
diff --git a/docs-ja/pages/self-hosted-environments-quickstart-en.md b/docs-ja/pages/self-hosted-environments-quickstart-en.md
index 6b379b4..82aac37 100644
--- a/docs-ja/pages/self-hosted-environments-quickstart-en.md
+++ b/docs-ja/pages/self-hosted-environments-quickstart-en.md
@@ -21,5 +21,5 @@ By the end you'll have an environment on the [**Cloud environments** admin page]
 The claude.ai side needs:
 
-* **Allow self-hosted environments** turned on by an [Owner or admin](/docs/en/cloud-environments#organization-shared-environments) on the [**Cloud environments** admin page](https://claude.ai/admin-settings/cloud-environments); the **New** button doesn't appear until it is. If you don't hold the role, someone who does can create the environment and hand you its secret; the runner and terminal steps on this page need no claude.ai role, and where a step checks status in the admin UI, the runner's own log lines give you the same signal.
+* **Allow self-hosted environments** turned on by an [Owner](/docs/en/cloud-environments#organization-shared-environments) on the [**Cloud environments** admin page](https://claude.ai/admin-settings/cloud-environments); the **New** button doesn't appear until it is. If you don't hold the role, someone who does can create the environment and hand you its secret; the runner and terminal steps on this page need no claude.ai role, and where a step checks status in the admin UI, the runner's own log lines give you the same signal.
 * A [GitHub connection](/docs/en/claude-code-on-the-web#github-authentication-options) for your organization, so developers can pick repositories when they start sessions.
 
@@ -48,5 +48,5 @@ A ready host prints the runner's usage text, listing flags such as `--environmen
 ## Set up an environment and runner
 
-Claude Code includes a guided setup: an interactive Claude Code session that walks you through creating the environment in the admin UI, starts a local runner with the secret file you save, confirms that the runner registers, and writes a cheat sheet to `./runner-setup/CHEAT-SHEET.md`. Run it on a machine where you've signed in with `claude auth login` using an account that holds an Owner or admin role; it isn't available with API keys or third-party model providers. On hosts where an interactive session isn't possible, use the manual steps below instead. Confirm the [version check](#software-on-the-runner-host) passed first: on versions older than 2.1.224, this command starts an ordinary Claude session with the words as the prompt instead of the guided setup. To start the guided setup, run the setup subcommand and follow the prompts:
+Claude Code includes a guided setup: an interactive Claude Code session that walks you through creating the environment in the admin UI, starts a local runner with the secret file you save, confirms that the runner registers, and writes a cheat sheet to `./runner-setup/CHEAT-SHEET.md`. Run it on a machine where you've signed in with `claude auth login` using an account that holds an Owner role; it isn't available with API keys or third-party model providers. On hosts where an interactive session isn't possible, use the manual steps below instead. Confirm the [version check](#software-on-the-runner-host) passed first: on versions older than 2.1.224, this command starts an ordinary Claude session with the words as the prompt instead of the guided setup. To start the guided setup, run the setup subcommand and follow the prompts:
 
 ```bash theme={null}
```

</details>

*...以降省略*

</details>


<details>
<summary>2026-08-22</summary>

**変更ファイル:**

```
 docs-ja/pages/changelog.md                         | 62 +++++++++++++++++
 docs-ja/pages/claude-directory-ja.md               |  4 +-
 docs-ja/pages/cross-session-messaging-en.md        | 77 ++++++++++++++--------
 .../self-hosted-environments-configuration-en.md   |  4 +-
 .../pages/self-hosted-environments-deploy-en.md    | 57 +++++++++++++++-
 docs-ja/pages/self-hosted-environments-en.md       |  8 ++-
 .../pages/self-hosted-environments-reference-en.md | 61 +++++++++--------
 .../pages/self-hosted-environments-testing-en.md   |  2 +-
 8 files changed, 207 insertions(+), 68 deletions(-)
```

**新規追加:**


<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index e347b6d..b05c306 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,66 @@
 # Changelog
 
+## 2.1.239
+
+- Cost estimates (`/cost`, status line, `--max-budget-usd`) now include the 1.1× US-only-inference premium for data-residency workspaces
+- Added the one-time fullscreen renderer offer on Bedrock, Vertex, Foundry and other previously excluded setups; new installs there now start in fullscreen
+- Added `/claude-api upgrade` to migrate Python projects from `anthropic` 0.x to 1.x, and updated the skill's Python reference for 1.x (timeouts use `anthropic.Timeout`, not `httpx.Timeout`)
+- Cloud sessions: plugins synced from claude.ai now show as `name@synced`, work with `claude plugin enable/disable <name>@synced`, and never override a same-named plugin you installed
+- Alpine/musl builds: native image paste, clipboard, and audio-capture add-ons now load (musl-built binaries instead of glibc ones refused by the runtime)
+- The usage-limit message shown when your monthly spend limit is already used up now also says when your session or weekly limit resets
+- Fixed Bedrock streaming behind proxies that strip the response Content-Type header, which silently doubled billed API calls by re-running every turn non-streaming
+- Fixed Claude Code hanging at startup behind an HTTPS proxy when using Bedrock with an SSO profile and `awsAuthRefresh` — the credential pre-check now honors `HTTPS_PROXY`
+- Fixed a raw crash dump when starting Claude Code from a directory that no longer exists; it now prints a clear message
+- Fixed Edit and Write calls pausing for about 5 seconds in JetBrains IDE terminals when the Claude Code plugin is connected
+- Fixed a race where pressing Esc with a prompt queued could let the next turn finish early, leaving the session idle while Claude was still working and letting a later resubmit repeat actions
+- Fixed WebFetch retaining expired page content in memory for the whole session instead of the intended 15 minutes
+- Fixed cloud sessions (Claude Code on the web, desktop and mobile apps) resuming out of plan mode after an idle worker restart
+- Fixed MCP elicitation forms taller than the terminal being clipped in fullscreen mode: the form now fits the window, with hidden fields reachable by scrolling and Accept/Decline always visible
+- Fixed remote MCP servers staying failed after a transient 5xx on a mid-session reconnect in cloud sessions or via SDK `setMcpServers()`
+- Fixed custom session titles disappearing from `/resume` after more than ~64 KB of conversation was written following the rename
+- Fixed `claude -c`/resume picking up sessions from a different directory whose path differed only by characters like `_`, `-`, or `.`
+- Fixed `/resume` and the agents view showing a session as recently changed (and reordering it) when only its file was touched or it was merely reopened
+- Fixed `/resume` in all-projects mode telling you to `cd` into a deleted directory (e.g. a removed worktree); such sessions now resume in the current directory
+- Fixed the `dark-ansi` theme rendering expanded tool results in fullscreen mode with text the same color as the background
+- Fixed the fullscreen renderer prompt reappearing on every launch when it could never be answered; it now stops after being shown on three launches
```

</details>

<details>
<summary>claude-directory-ja.md</summary>

```diff
diff --git a/docs-ja/pages/claude-directory-ja.md b/docs-ja/pages/claude-directory-ja.md
index d4a46d5..e57e910 100644
--- a/docs-ja/pages/claude-directory-ja.md
+++ b/docs-ja/pages/claude-directory-ja.md
@@ -114,5 +114,5 @@ config/secrets.json`,
           when: <>Overrides global <C>~/.claude/settings.json</C>. Local settings, CLI flags, and managed settings override this</>,
           description: 'Settings that Claude Code applies directly. Permissions control which commands and tools Claude can use; hooks run your scripts at specific points in a session. Unlike CLAUDE.md, which Claude reads as guidance, these are enforced whether Claude follows them or not.',
-          contains: [<><A href="/docs/en/permissions">permissions</A>: allow, deny, or prompt before Claude uses specific tools or commands</>, <><A href="/docs/en/hooks">hooks</A>: run your own scripts on events like before a tool call or after a file edit</>, <><A href="/docs/en/statusline">statusLine</A>: customize the line shown at the bottom while Claude works</>, <><A href="/docs/en/settings#available-settings">model</A>: pick a default model for this project</>, <><A href="/docs/en/settings#environment-variables">env</A>: environment variables set in every session</>, <><A href="/docs/en/output-styles">outputStyle</A>: select a custom system-prompt style from output-styles/</>],
+          contains: [<><A href="/docs/en/permissions">permissions</A>: allow, deny, or prompt before Claude uses specific tools or commands</>, <><A href="/docs/en/hooks">hooks</A>: run your own scripts on events like before a tool call or after a file edit</>, <><A href="/docs/en/statusline">statusLine</A>: customize the line shown at the bottom while Claude works</>, <><A href="/docs/en/settings-reference#available-settings">model</A>: pick a default model for this project</>, <><A href="/docs/en/settings-reference#environment-variables">env</A>: environment variables set in every session</>, <><A href="/docs/en/output-styles">outputStyle</A>: select a custom system-prompt style from output-styles/</>],
           tips: [<>Bash permission patterns support wildcards: <C>Bash(npm test *)</C> matches any command starting with <C>npm test</C></>, <>Array settings like <C>permissions.allow</C> combine across all scopes; scalar settings like <C>model</C> use the most specific value</>],
           exampleIntro: <>This example allows <C>npm test</C> and <C>npm run</C> commands without prompting, blocks <C>rm -rf</C>, and runs Prettier on files after Claude edits or writes them.</>,
@@ -442,5 +442,5 @@ Every finding must include a concrete fix.`
   }
 }`,
-        docsLink: '/en/settings#global-config-settings'
+        docsLink: '/en/settings-reference#global-config-settings'
       }, {
         id: 'global-dot-claude',
```

</details>

<details>
<summary>cross-session-messaging-en.md</summary>

```diff
diff --git a/docs-ja/pages/cross-session-messaging-en.md b/docs-ja/pages/cross-session-messaging-en.md
index b132368..b476ac6 100644
--- a/docs-ja/pages/cross-session-messaging-en.md
+++ b/docs-ja/pages/cross-session-messaging-en.md
@@ -8,5 +8,5 @@
 
 <Note>
-  Cross-session messaging requires Claude Code v2.1.224 or later and runs on macOS and Linux. When a session meets the requirements, messaging is on with nothing to enable. See [Availability](#availability) for provider requirements and how to confirm a session has it.
+  Cross-session messaging requires Claude Code v2.1.224 or later on macOS and Linux, including Linux inside WSL 2. On native Windows, it requires Claude Code v2.1.234 or later. When a session meets the requirements, messaging is on with nothing to enable. See [Availability](#availability) for provider requirements and how to confirm a session has it.
 </Note>
 
@@ -64,5 +64,11 @@ For what the message Claude writes looks like when it arrives, including an exam
 The receiving Claude reads the message between tool calls during an active turn, so a running tool is never interrupted. When the receiving session is idle, Claude Code starts a new turn with the message.
 
-Between two ordinary interactive sessions with default settings, Claude Code delivers the message. Delivery isn't guaranteed in every configuration, though. Claude Code refuses a message [over the size cap](#limitations) in the sending session, before it leaves. The receiving session checks each arriving message against its own [inbound controls](#control-inbound-messages), and the check ends in one of three outcomes:
+Claude Code refuses a message in the following cases:
+
+* The message is [over the size cap](#limitations). Claude Code refuses it in the sending session, before it leaves.
+* A rapid burst to a session on this machine has reached [what that session's inbox accepts](#limitations). Claude Code refuses further messages to that session.
+* The reply target on this machine fails a safety check, such as a symlinked target or an endpoint that isn't the expected process. [Refusing to send a cross-session message](/docs/en/errors#refusing-to-send-a-cross-session-message) lists these checks.
+
+The receiving session checks each arriving message against its own [inbound controls](#control-inbound-messages), and the check ends in one of three outcomes:
 
 * **Delivered**: Claude Code passes the message to the receiving Claude.
@@ -108,11 +114,13 @@ Claude finds a message's target on its own, so you don't need to run anything be
 
 * **Subagents**: agents running inside the current session. [Agent team](/docs/en/agent-teams) teammates aren't listed; Claude messages them through the team's own roster.
-* **Your other local sessions**: Claude Code sessions running on the same machine, including [background sessions](/docs/en/agent-view). A session appears only when it binds an [inbox socket](#the-sessions-inbox-socket).
+* **Your other local sessions**: Claude Code sessions running on the same machine, including [background sessions](/docs/en/agent-view). A session appears only when it binds an [inbox socket](#the-sessions-inbox-socket). The worker process that the [supervisor process](/docs/en/agent-view#the-supervisor-process) keeps ready for your next background session appears once you dispatch work to it.
 * **Your cloud sessions**: your [Claude Code on the web](/docs/en/claude-code-on-the-web) sessions, shown while this session is connected to [Remote Control](/docs/en/remote-control). Claude Code labels them `cloud` in the listing.
```

</details>

<details>
<summary>self-hosted-environments-configuration-en.md</summary>

```diff
diff --git a/docs-ja/pages/self-hosted-environments-configuration-en.md b/docs-ja/pages/self-hosted-environments-configuration-en.md
index a4a947e..27ac571 100644
--- a/docs-ja/pages/self-hosted-environments-configuration-en.md
+++ b/docs-ja/pages/self-hosted-environments-configuration-en.md
@@ -379,5 +379,5 @@ To pre-approve specific tools instead, append `--allowed-tools` with your rules,
 The runner gives each session its own config directory, seeded from an in-memory snapshot of the host's `~/.claude/` that the runner captures once at startup: `settings.json`, `CLAUDE.md`, hooks, agents, commands, and skills in your runner image apply to every session as the user-level baseline. Because the snapshot is taken at startup, config changes on a running host take effect only after a runner restart. Set `SELF_HOSTED_RUNNER_HOST_CONFIG_DIR` to seed from a different path, or point it at an empty directory to disable seeding.
 
-Repository-committed `.claude/settings.json` layers on top as project settings. Sessions also read [`managed-settings.json`](/docs/en/settings#settings-files) from the standard system path in your runner image, but the managed tier uses one source at a time, and [server-managed settings](/docs/en/server-managed-settings) are checked first: if your organization delivers any server-managed keys, sessions ignore the runner image's managed file, except that `env` blocks merge per key across managed sources. See [settings precedence](/docs/en/settings#settings-precedence).
+Repository-committed `.claude/settings.json` layers on top as project settings. Sessions also read [`managed-settings.json`](/docs/en/settings#where-settings-live) from the standard system path in your runner image, but the managed tier uses one source at a time, and [server-managed settings](/docs/en/server-managed-settings) are checked first: if your organization delivers any server-managed keys, sessions ignore the runner image's managed file, except that `env` blocks merge per key across managed sources. See [settings precedence](/docs/en/settings#settings-precedence).
 
 When Anthropic's control plane supplies a session with [Claude Code hooks](/docs/en/hooks), the runner installs them alongside, not over, your own configuration. Requires Claude Code v2.1.229 or later.
@@ -385,5 +385,5 @@ When Anthropic's control plane supplies a session with [Claude Code hooks](/docs
 * **Where they land**: the runner writes each supplied hook script to a reserved `hooks/.ccr-launcher/` subdirectory of the session's config directory and registers the scripts in a separate settings file it passes to the session with `--settings`, leaving the seeded `settings.json` and your own scripts at `hooks/<name>` untouched. The runner recreates the reserved subdirectory for each session and doesn't seed host content at `~/.claude/hooks/.ccr-launcher/` into sessions.
 * **Who authors them**: the control plane populates the scripts from fixed constants in its own deployment, never from per-session or third-party input.
-* **What still governs them**: hooks delivered through `--settings` enter the ordinary merged hook configuration, not the managed tier, so your managed settings still apply. `disableAllHooks` disables them, and they are not among the categories [`allowManagedHooksOnly`](/docs/en/settings#hook-configuration) keeps loaded.
+* **What still governs them**: hooks delivered through `--settings` enter the ordinary merged hook configuration, not the managed tier, so your managed settings still apply. `disableAllHooks` disables them, and they are not among the categories [`allowManagedHooksOnly`](/docs/en/settings-reference#allowmanagedhooksonly) keeps loaded.
 
 ### Repository-committed permission rules
```

</details>

<details>
<summary>self-hosted-environments-deploy-en.md</summary>

```diff
diff --git a/docs-ja/pages/self-hosted-environments-deploy-en.md b/docs-ja/pages/self-hosted-environments-deploy-en.md
index a13a8fb..de3dca9 100644
--- a/docs-ja/pages/self-hosted-environments-deploy-en.md
+++ b/docs-ja/pages/self-hosted-environments-deploy-en.md
@@ -75,4 +75,33 @@ Deploy runner and session containers in a network segment or namespace whose out
 For details on which telemetry each session emits and how to turn it off, see [Telemetry](/docs/en/self-hosted-environments-reference#telemetry).
 
+### Authenticate to an egress proxy
+
+Some corporate egress proxies require a `Proxy-Authorization` header on every connection. The token in that header often rotates too fast to write into the proxy URL you set in `HTTPS_PROXY`. Set `HTTPS_PROXY` or `HTTP_PROXY` to your proxy's URL as usual, then set `--proxy-authorization-command` or `--proxy-authorization-file` to tell the runner where to read the header value from. Both flags require Claude Code v2.1.238 or later.
+
+#### Choose where the `Proxy-Authorization` value comes from
+
+Pick the flag that matches how you produce the `Proxy-Authorization` token:
+
+* **[`--proxy-authorization-command <command>`](/docs/en/self-hosted-environments-reference#runner-cli-flags)**: choose this for a token you generate on demand. The runner runs the shell command and uses its trimmed stdout as the header value, for example `Bearer <token>`.
+* **[`--proxy-authorization-file <path>`](/docs/en/self-hosted-environments-reference#runner-cli-flags)**: choose this for a token another process rotates in place. The runner reads the file and uses its trimmed contents as the header value.
+
+#### Configurations the runner refuses to start with
+
+Each flag also has an environment variable form, listed beside it in the [runner CLI flags reference](/docs/en/self-hosted-environments-reference#runner-cli-flags). Before the runner contacts your proxy or the control plane, it checks the flags and their variables, and refuses to start in three cases:
+
+* **Both flags set**: one flag plus the other flag's environment variable counts as setting both.
+* **No proxy URL**: neither `HTTPS_PROXY` nor `HTTP_PROXY` holds an `http://` or `https://` URL. The runner reads both variables in upper or lower case, and doesn't consult `ALL_PROXY`.
+* **Either flag passed to the orchestrator subcommand**: `self-hosted-runner orchestrator` doesn't accept the flags or their environment variables. Pass the flag to each runner the orchestrator starts instead.
+
+#### What the runner changes while a proxy-authorization flag is set
+
+With either flag set, the runner starts a listener of its own and sends proxy traffic from itself, its lifecycle hooks, and its sessions through that listener. The listener adds the `Proxy-Authorization` header on the way to your proxy.
+
```

</details>

<details>
<summary>self-hosted-environments-en.md</summary>

```diff
diff --git a/docs-ja/pages/self-hosted-environments-en.md b/docs-ja/pages/self-hosted-environments-en.md
index 90f1970..b136be1 100644
--- a/docs-ja/pages/self-hosted-environments-en.md
+++ b/docs-ja/pages/self-hosted-environments-en.md
@@ -86,7 +86,9 @@ When a developer starts a session and selects your environment, Anthropic's cont
 4. If the runner stops polling for about 60 seconds, the server requeues the session for another runner.
 
+The runner gives each poll request 10 seconds. When a request times out or is lost, the runner retries after a second or two instead of waiting for the next scheduled poll. Each further request that times out or is lost doubles the gap before the next retry, up to 20 seconds, and the runner shortens the gap whenever the lease is close to expiring.
+
 ### Runner lifecycle
 
-The first session a runner picks up locks the runner to the account of the user who started that session, and the runner runs up to `--capacity` concurrent sessions for that account. While the runner has active sessions, the runner keeps claiming the locked account's queued work. What happens once they finish depends on [`--drain-grace-sec`](/docs/en/self-hosted-environments-reference#runner-cli-flags):
+The first session a runner picks up locks the runner to the account of the user who started that session, and the runner runs up to `--capacity` concurrent sessions for that account. While the runner has active sessions and hasn't received a shutdown signal or reached its retire time, the runner keeps claiming the locked account's queued work. What happens once they finish depends on [`--drain-grace-sec`](/docs/en/self-hosted-environments-reference#runner-cli-flags):
 
 * **At the default of `0`**: the runner exits as soon as its active sessions finish, without polling for more, so the orchestrator you deploy it under, such as Kubernetes, can restart it with a fresh disk, ready to serve any account.
@@ -95,5 +97,5 @@ The first session a runner picks up locks the runner to the account of the user
 This lifecycle isolates each user's checked-out code without requiring the runner to delete disk state between users.
 
-A kill that delivers `SIGTERM` needs no flag: the runner drains as [Shutdown timing](/docs/en/self-hosted-environments-deploy#shutdown-timing) describes. If your infrastructure instead destroys hosts at a known wall-clock time without a signal, or with a grace period too short to drain, such as a sandbox lifetime cap or spot-instance reclamation, pass `--retire-at <epoch-seconds>` set to a few minutes before that time. At the retire time:
+How your infrastructure stops a runner decides whether you need `--retire-at`. A kill that delivers `SIGTERM` needs no flag: the runner drains as [Shutdown timing](/docs/en/self-hosted-environments-deploy#shutdown-timing) describes, or keeps serving the sessions it already holds when you set [`--defer-shutdown-max-min`](/docs/en/self-hosted-environments-deploy#defer-the-drain-past-the-first-signal). If your infrastructure instead destroys hosts at a known wall-clock time without a signal, or with a grace period too short to drain, such as a sandbox lifetime cap or spot-instance reclamation, pass `--retire-at <epoch-seconds>` set to a few minutes before that time. At the retire time:
 
 1. The runner stops taking new work.
@@ -118,4 +120,6 @@ Model inference uses the Anthropic API. The control plane delivers the API endpo
 Corporate egress proxies are supported. The runner and the optional [autoscaling orchestrator](/docs/en/self-hosted-environments-configuration#on-demand-runners) honor the proxy and mTLS environment variables described in [Network configuration](/docs/en/network-config), such as `HTTPS_PROXY` and `NO_PROXY`; set them in each process's environment. The variables cover control-plane calls, the orchestrator's [SCM connector](/docs/en/self-hosted-environments-reference#scm-connector-flags) WebSocket, and the built-in clone for HTTPS remotes, and sessions inherit them from the runner. Session streaming uses server-sent events over HTTPS, so a proxy in the path must not buffer responses.
 
+If your proxy also requires a `Proxy-Authorization` header, the runner can add it to each connection it opens to the proxy; see [Authenticate to an egress proxy](/docs/en/self-hosted-environments-deploy#authenticate-to-an-egress-proxy).
+
 ## What stays on your infrastructure
 
```

</details>

<details>
<summary>self-hosted-environments-reference-en.md</summary>

```diff
diff --git a/docs-ja/pages/self-hosted-environments-reference-en.md b/docs-ja/pages/self-hosted-environments-reference-en.md
index bfe0a56..38e4cfd 100644
--- a/docs-ja/pages/self-hosted-environments-reference-en.md
+++ b/docs-ja/pages/self-hosted-environments-reference-en.md
@@ -19,33 +19,36 @@ Metric series and a few API fields still use `pool` for what these pages call an
 Most flags have a corresponding environment variable. When both are set, the flag takes precedence. Duration flags take minutes or seconds on the CLI, but the paired environment variable is always in milliseconds, indicated by the `_MS` suffix, and the Default column shows the flag's unit: `--exit-if-unused-min 10` is equivalent to `SELF_HOSTED_RUNNER_IDLE_SHUTDOWN_MS=600000`, and a Helm value like `SELF_HOSTED_RUNNER_STARTUP_TIMEOUT_MS: "15"` means 15 milliseconds, not the 15-minute default.
 
-| Flag                                  | Env var                                           | Default                       | Description                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
-| :------------------------------------ | :------------------------------------------------ | :---------------------------- | :---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
-| `--api-url <url>`                     | none                                              | `https://api.anthropic.com`   | API base URL. Override only for testing.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
-| `--base-dir <path>`                   | `SELF_HOSTED_RUNNER_BASE_DIR`                     | `/workspace`; none on Windows | Directory for repository checkouts and per-session working directories. The runner needs write access to this path or its parent. The runner creates the directory at startup and exits with `cannot create or write to base directory` when it can't create or write to it. Before v2.1.225, the runner created the directory when the first session started, so an unusable path failed sessions rather than startup. On Windows, which isn't a supported runner host, there is no default: the runner exits at startup unless you pass the flag or set the variable. Use the same value on every runner in an environment. See [Keep the base directory and capacity identical across runners](/docs/en/self-hosted-environments-deploy#keep-the-base-directory-and-capacity-identical-across-runners). |
-| `--capacity <n>`                      | none                                              | `1`                           | Maximum concurrent sessions this runner handles. All sessions belong to the same locked account. Use the same value on every runner in an environment; see [Keep the base directory and capacity identical across runners](/docs/en/self-hosted-environments-deploy#keep-the-base-directory-and-capacity-identical-across-runners).                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
-| `--configure-git`                     | `SELF_HOSTED_RUNNER_CONFIGURE_GIT=1`              | off                           | Write global git identity and enable Anthropic commit signing at startup. See [Configure git](/docs/en/self-hosted-environments-deploy#configure-git).                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
-| `--confine-repo-settings <mode>`      | `SELF_HOSTED_RUNNER_CONFINE_REPO_SETTINGS`        | `warn`                        | Sets the mode of the guard that flags a session when a repository's committed settings try to grant write or read access outside that session's own workspace, set environment variables, or override the operator's sandbox or hooks posture, such as `sandbox.enabled: false` or `disableAllHooks`. The default `warn` logs the violation and still starts the session, `enforce` refuses the session, and `off` disables the scan. See [Harden your deployment](/docs/en/self-hosted-environments-deploy#harden-your-deployment).                                                                                                                                                                                                                                                                       |
-| `--debug-token-dir <path>`            | `SELF_HOSTED_RUNNER_DEBUG_TOKEN_DIR`              | unset                         | Write live tokens to disk for inspection. Debug only; don't use in production.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
-| `--drain-grace-sec <n>`               | `SELF_HOSTED_RUNNER_DRAIN_GRACE_MS`               | `0`                           | Controls when the runner exits after its active sessions finish: `0` exits immediately without polling for more, and a positive value keeps the runner alive and re-polling the locked account's queue for that many seconds first, at the cost of the per-session container isolation described in the [hardening section](/docs/en/self-hosted-environments-deploy#harden-your-deployment)                                                                                                                                                                                                                                                                                                                                                                                                               |
-| `--drain-wait-sec <n>`                | `SELF_HOSTED_RUNNER_DRAIN_WAIT_MS`                | `0`                           | On `SIGTERM`, wait up to N seconds for each session's in-flight turn and background tasks to finish before terminating the child. During this wait, the runner counts a background task that has just finished as still running until the follow-up turn that reads its result starts, for at most the [`SELF_HOSTED_RUNNER_BG_RESULT_GRACE_MS`](#environment-variable-only-settings) window.                                                                                                                                                                                                                                                                                                                                                                                                         |
-| `--environment-secret-file <path>`    | `SELF_HOSTED_RUNNER_ENVIRONMENT_SECRET`           | required                      | Path to a file containing the environment secret, or, for runners spawned by the [orchestrator](/docs/en/self-hosted-environments-configuration#on-demand-runners), the single-use work-order JWT. `SELF_HOSTED_RUNNER_ENVIRONMENT_SECRET` carries the secret value directly, not a file path. The older `--pool-secret-file` flag and `SELF_HOSTED_RUNNER_POOL_SECRET` variable still work and print a deprecation notice to stderr; preview-program runner builds older than 2.1.216 only recognize those older names.                                                                                                                                                                                                                                                                                   |
-| `--exec-path <path>`                  | `SELF_HOSTED_RUNNER_EXEC_PATH`                    | own binary                    | Binary or wrapper script to spawn for each session. See [Wrapper scripts](/docs/en/self-hosted-environments-configuration#wrapper-scripts).                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
-| `--exit-if-unused-min <n>`            | `SELF_HOSTED_RUNNER_IDLE_SHUTDOWN_MS`             | `0`                           | Exit after N minutes of polling with no work ever assigned, for autoscaler scale-down. `0` disables.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
-| `--git-host-rewrite <from>=<to>`      | none                                              | unset                         | Rewrite `https://<from>/...` source URLs to `https://<to>/...` before cloning, for split-horizon DNS. Repeatable; flag only.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
-| `--git-ssh-rewrite <host>`            | none                                              | unset                         | Rewrite `https://<host>/...` source URLs to `git@<host>:...` before cloning, for SSH-only git hosts. Repeatable; flag only.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
-| `--health-port <port>`                | `SELF_HOSTED_RUNNER_HEALTH_PORT`                  | `8080`                        | Port for the `/healthz` and `/metrics` listener. Set `0` to disable.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
-| `--hooks-dir <path>`                  | `SELF_HOSTED_RUNNER_HOOKS_DIR`                    | unset                         | Directory of lifecycle hook scripts. See [Lifecycle hooks](/docs/en/self-hosted-environments-configuration#lifecycle-hooks).                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
-| `--kill-session-after-min <n>`        | `SELF_HOSTED_RUNNER_MAX_LIFETIME_MS`              | `0`                           | Terminate a session child once it has lived N minutes wall-clock, as a safety limit for stuck sessions. A kill that falls mid-turn is deferred until the turn finishes, bounded by a grace window. `0` disables.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
-| `--lock-to-account <id>`              | `SELF_HOSTED_RUNNER_LOCK_TO_ACCOUNT`              | unset                         | Pre-lock the runner to a specific account at startup instead of locking on first session. Accepts an email address or `user_...` ID in the environment's organization.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
-| `--log-file <path>`                   | `SELF_HOSTED_RUNNER_LOG_FILE`                     | unset                         | Mirror runner logs to a file in addition to stdout and stderr, created with `0600` permissions. Required for `self-hosted-runner doctor` to tail logs locally.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
-| `--log-level <level>`                 | none                                              | `info`                        | `info` or `debug`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
-| `--post-session-hook-timeout-sec <n>` | `SELF_HOSTED_RUNNER_POST_SESSION_HOOK_TIMEOUT_MS` | `60`                          | Budget for the [`post-session` hook](/docs/en/self-hosted-environments-configuration#post-session) on every session end, including runner shutdown                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
-| `--push-outcome-on-release`           | `SELF_HOSTED_RUNNER_PUSH_OUTCOME_ON_RELEASE`      | off                           | On a runner-initiated session end such as a drain or idle release, push tracked outcome branches to `origin` before deleting the workspace, so in-flight commits survive a restart. Best-effort; adds 30 seconds to the shutdown budget, and requires git 2.29 or newer to resume from the pushed branch. Restrict push access to `claude/*` refs before enabling; see [Resumed sessions lose unpushed work](/docs/en/self-hosted-environments-deploy#additional-limitations). Repositories checked out via a `checkout` lifecycle hook aren't pushed; snapshot those from the [`post-session` hook](/docs/en/self-hosted-environments-configuration#post-session) instead.                                                                                                                                     |
```

</details>

*...以降省略*

</details>


<details>
<summary>2026-08-21</summary>

**変更ファイル:**

```
 docs-ja/pages/changelog.md                         | 47 ++++++++++++++++++++++
 docs-ja/pages/cross-session-messaging-en.md        | 31 +++++++++++++-
 .../self-hosted-environments-configuration-en.md   | 11 ++++-
 .../pages/self-hosted-environments-reference-en.md |  2 +-
 4 files changed, 88 insertions(+), 3 deletions(-)
```

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index a0737ac..e347b6d 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,51 @@
 # Changelog
 
+## 2.1.238
+
+- Added a `keybindingFlavor` setting: set it to `"readline"` to make Ctrl+W in the prompt delete back to the previous whitespace, as in Bash; the default (`"classic"`) is unchanged
+- Plugin marketplaces: `headersHelper` on a url marketplace or a catalog entry runs a command that mints HTTP headers (e.g. a short-lived token) for catalog and same-origin archive fetches
+- A catalog entry's `headersHelper` runs only when you install or update that plugin, after its command is shown; `claude plugin install/update` ask `[y/N]` (or pass `-y`)
+- Added `claude self-hosted-runner --defer-shutdown-max-min <minutes>`: on SIGTERM, keep serving attached sessions, park what is left after that many minutes, then exit
+- Added `claude self-hosted-runner --proxy-authorization-command` / `--proxy-authorization-file` for egress proxies that require a freshly issued `Proxy-Authorization` header on every connection
+- Fixed unbounded memory growth in long interactive sessions: subagent tool results are now released once they leave the recent display window
+- Fixed custom, project, and plugin output styles drifting back to the default voice mid-session
+- Fixed `CLAUDE_CODE_ENABLE_PROMPT_SUGGESTION=true` not keeping prompt suggestions on when your account is near, but not over, its usage limit
+- Fixed worktree-isolation Bash refusals telling you to remove a redirect when the command had none
+- Fixed self-hosted runners occasionally being removed by the server after a single slow or lost poll request, handing their healthy session to another runner
+- Fixed MCP elicitation dialogs showing nothing for URLs longer than 4,096 characters, and permission prompts dropping the "don't ask again" option when the project path didn't fit the terminal width
+- Fixed leftover `/tmp/claude-*-cwd` files when a Bash command is killed, times out, or is interrupted
+- Fixed held Backspace being ignored on terminals that send Ctrl+H for Backspace when keystrokes arrive in large bursts (slow SSH/mosh links)
+- Fixed text-wrapping in permission prompt diffs: lines containing wide multi-code-point characters (such as emoji) or tabs are no longer clipped
+- Fixed killing a suspended (Ctrl+Z) session sometimes leaving the terminal in bracketed-paste mode with the cursor hidden
+- Fixed stdio MCP servers receiving a `server/discover` request before `initialize`, forcing lazy servers to start their backend on every session open
+- Fixed a proxy's refusal of a connection being reported as a generic network error instead of naming the proxy
+- Fixed the `/model` and `/effort` cache-miss warning appearing when the prompt cache had already expired
+- Fixed per-task Stop from the Remote Control tasks panel doing nothing on CLI-hosted sessions
+- Fixed remote sessions exiting when a client delivered a user message without a valid role
+- Fixed Remote Control sessions started by `claude remote-control` inheriting session-scoped environment variables from the launching shell
```

</details>

<details>
<summary>cross-session-messaging-en.md</summary>

```diff
diff --git a/docs-ja/pages/cross-session-messaging-en.md b/docs-ja/pages/cross-session-messaging-en.md
index 65e69b5..b132368 100644
--- a/docs-ja/pages/cross-session-messaging-en.md
+++ b/docs-ja/pages/cross-session-messaging-en.md
@@ -23,5 +23,5 @@ Use messaging when one of your sessions has something another session needs mid-
 * **Hand over a finding**: when one session discovers a breaking change or makes a decision, Claude summarizes it for the session working on the affected area, instead of you re-explaining it there.
 * **Coordinate parallel worktrees**: when sessions work the same repository in separate [worktrees](/docs/en/worktrees), Claude can tell the other sessions what landed.
-* **Get status from long-running work**: have a migration or test run report back to the session you're watching, or ask it yourself from there.
+* **Get status from long-running work**: have a migration or test run report back to the session you're watching, or ask it yourself from there. If that session is on this machine, Claude can also [ask it for one notice when it next goes idle or exits](#get-a-notice-when-another-session-goes-idle).
 * **Message across machines**: reach one of your sessions on another machine or on the web.
 
@@ -74,4 +74,33 @@ Once delivered, the message counts toward [usage](/docs/en/costs) like a prompt
 Permission boundaries stay per-session. Claude is instructed never to ask another session for an action that was denied or blocked in its own session, or that its own permission settings would block, and to route that work back to you instead. On the receiving side, the [receiving session's own permission prompts and rules still apply](#how-a-session-treats-an-incoming-message) to anything the message asks for.
 
+### Get a notice when another session goes idle
+
+Claude can ask one of your sessions on this machine to send back one notice when that session next goes idle or exits. Idle here means the session finished a turn with nothing queued. Use it when you're waiting on a long task in another session and want to hear when it's done instead of checking. Requires Claude Code v2.1.236 or later in both sessions.
+
+#### Ask for a notice
+
+Tell Claude what you're waiting on. This prompt asks for a notice from the migration session:
+
+```text wrap theme={null}
+Tell me when the migration session finishes what it's working on
+```
+
+Claude subscribes with the `SendMessage` tool's `notify_when_idle` input, either attached to a message it's sending anyway or on its own. On its own, Claude Code subscribes without starting a turn or spending tokens in the watched session, and sends the notice right away if that session is already idle. Attached to a message, Claude Code delivers the message first and sends the notice later.
+
+#### What each session shows
+
```

</details>

<details>
<summary>self-hosted-environments-configuration-en.md</summary>

```diff
diff --git a/docs-ja/pages/self-hosted-environments-configuration-en.md b/docs-ja/pages/self-hosted-environments-configuration-en.md
index 735eae8..a4a947e 100644
--- a/docs-ja/pages/self-hosted-environments-configuration-en.md
+++ b/docs-ja/pages/self-hosted-environments-configuration-en.md
@@ -133,5 +133,5 @@ The hook fires on every session end where a child process was spawned, whatever
 * `completed`: a clean exit, including a session archived or deleted while the child was still connected.
 * `failed`: a child crash or a setup failure after spawn.
-* `interrupted`: an idle release, startup timeout, server deassign, drain, watchdog kill, or the [`released=false` backstop](/docs/en/self-hosted-environments-reference#session-lifecycle-counter-semantics).
+* `interrupted`: an idle release, startup timeout, server deassign, drain, or watchdog kill.
 * `abandoned`: reserved for sessions another runner claimed; the hook doesn't currently fire in that case.
 
@@ -163,4 +163,13 @@ done
 The hook pushes with whatever git credentials are available in its own environment on the runner host. Under the [no-credentials-in-the-image posture](/docs/en/self-hosted-environments-deploy#configure-git), including when the built-in clone goes through the Anthropic git proxy, there are none, so mint a short-lived push credential inside the hook before pushing: exchange the session token the hook receives in `CLAUDE_CODE_SESSION_ACCESS_TOKEN` with your own token service, verifying it as [Verify session identity](/docs/en/self-hosted-environments-identity) describes. When the hook holds a credential the session didn't, also pin where it pushes: replace `origin` with an operator-supplied URL and pass `-c credential.helper=` plus your own helper, so repo-local config the session wrote can't redirect the credentialed push.
 
+#### Hook timing when the runner releases a session
+
+A released session can resume on another runner. On a runner on v2.1.236 or later, what the session was doing at release decides whether it can resume before this hook finishes:
+
+* **Idle after a turn, or timed out at startup**: the runner stops the child and runs this hook to completion. Only then does it release the session. A user message sent while the hook runs can't resume the session on another runner before the hook finishes.
+* **Waiting for the user to answer a prompt, such as a permission prompt**: the runner releases the session first, then runs this hook. A user message sent while the hook runs can resume the session on another runner before the hook finishes.
+
+A release at the [`--retire-at`](/docs/en/self-hosted-environments-reference#runner-cli-flags) time follows the same two paths. During a `SIGTERM` drain, the runner holds the session lease until the hook finishes; see [Shutdown timing](/docs/en/self-hosted-environments-deploy#shutdown-timing). Before v2.1.236, the runner released the session first and then ran this hook on both paths.
+
 ### command
 
```

</details>

<details>
<summary>self-hosted-environments-reference-en.md</summary>

```diff
diff --git a/docs-ja/pages/self-hosted-environments-reference-en.md b/docs-ja/pages/self-hosted-environments-reference-en.md
index ecb3e25..bfe0a56 100644
--- a/docs-ja/pages/self-hosted-environments-reference-en.md
+++ b/docs-ja/pages/self-hosted-environments-reference-en.md
@@ -289,5 +289,5 @@ The `sessions_started_total`, `sessions_completed_total`, `sessions_failed_total
 * `completed`: the session ended cleanly. This covers the child exiting on its own with code `0`, the session being archived or deleted while the child was still connected, and the runner releasing the slot as a clean handoff: an idle release, a startup timeout, or a server-side deassign the poll loop noticed before the child exited. Increments `sessions_completed_total`.
 * `failed`: the child exited on its own with a non-zero code, either a crash or a setup failure after spawn. Increments `sessions_failed_total`.
-* `interrupted`: the runner terminated the child for an operational reason that's neither a session success nor a runner fault, such as a drain, for example a Kubernetes rolling restart sending `SIGTERM`, the max-lifetime watchdog `--kill-session-after-min`, or the `released=false` backstop: the runner terminates the child after the control plane declines three consecutive idle-release requests, each because a user message was still waiting to be processed. Increments `sessions_interrupted_total`.
+* `interrupted`: the runner terminated the child for an operational reason that's neither a session success nor a runner fault, such as a drain or the max-lifetime watchdog `--kill-session-after-min`. A Kubernetes rolling restart sending `SIGTERM` is one example of a drain. Increments `sessions_interrupted_total`.
 
 The [`post-session` hook](/docs/en/self-hosted-environments-configuration#post-session)'s `CLAUDE_RUNNER_EXIT_REASON` doesn't use this classification for clean handoffs. The hook reports an idle release, a startup timeout, and a server deassign as `interrupted`, since from the hook's perspective the runner killed the child, while the counters above record those same events as `completed`, since nothing went wrong and the slot was handed back cleanly. If you reconcile hook receipts against `sessions_completed_total` directly, you undercount completions. Use the hook for per-session guarantees and the counters for aggregate rates.
```

</details>

</details>


<details>
<summary>2026-08-20</summary>

**変更ファイル:**

```
 docs-ja/pages/changelog.md | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)
```

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index 17b8091..a0737ac 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,40 @@
 # Changelog
 
+## 2.1.236
+
+- Added `ANTHROPIC_DEFAULT_MODEL` environment variable: sets the model new sessions start on, while a `/model` pick still overrides it and persists across restarts (unlike `ANTHROPIC_MODEL`)
+- Added `notify_when_idle` to cross-session `SendMessage`: ask another Claude Code session on this machine to send one notice when it next goes idle — opt-in, one-shot, no polling (macOS and Linux)
+- Sandbox: on macOS, wildcard read-deny rules (e.g. `**/.env`) now take precedence inside allowed read regions, cover matched directories' contents, and can't be bypassed by renaming the denied file
+- Fixed clipboard copy, background housekeeping, background sessions, and local MCP logs breaking after the directory a session had switched into was removed (since 2.1.229)
+- Fixed the fullscreen renderer failing permanently after a single failed start: it now falls back to the classic renderer instead of exiting on every subsequent launch
+- Fixed the `/model` picker rendering taller than the terminal: it now shows only as many models as fit the window, with the rest reachable by scrolling
+- Fixed `SendMessage` calls being rejected when a malformed closing tag left the message text inside the summary field
+- Fixed unhandled promise rejections when a subprocess fails to start, for example `powershell.exe` on WSL with Windows interop disabled (regression in 2.1.234)
+- Fixed fullscreen mode sometimes not showing a newly sent message until the next update after the terminal was resized
+- Fixed a blank band that could remain above the prompt after clearing a multi-line prompt, and panes not repainting after resizing the terminal away and back, in fullscreen mode
+- Fixed the managed-settings approval prompt sometimes not appearing at startup while still capturing the first keypress as approval
+- Fixed terminal tab titles jumping in tmux (iTerm tmux integration): the title is now written only when its text changes instead of animating every 960ms
+- Fixed an unclear error when the cloud environments list came back empty or malformed
+- Fixed the Fable 5 first-time usage-credits prompt auto-selecting the fallback model after 60 seconds with no answer when using Remote Control
+- Fixed spinner tips never appearing, with a repeated background error, when the cached guest-pass reward in `~/.claude.json` was malformed
+- Fixed skills hot-reload in SDK/VS Code sessions raising an error on every skills change after the session's working directory was deleted (2.1.229+)
+- Fixed self-hosted runner sessions released on idle, retire, or startup timeout occasionally resuming on another runner before the post-session hook had finished
+- Fixed the Clawd mascot's eyes and feet rendering unevenly in iTerm2 at some font sizes
+- Fixed occasional runaway session recaps: recap text (automatic and `/recap`) is now capped at 400 characters, cut at a word boundary
+- Improved startup performance: the session counter is now written in the background
+- Improved auto mode: `Monitor` allow rules are now set aside while auto mode is active, so Monitor commands are reviewed the same way Bash commands are
```

</details>

</details>


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

<!-- UPDATE_LOG_END -->
