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

<details>
<summary>claude-code-on-the-web-ja.md</summary>

```diff
diff --git a/docs-ja/pages/claude-code-on-the-web-ja.md b/docs-ja/pages/claude-code-on-the-web-ja.md
index 4582fd1..4cc0884 100644
--- a/docs-ja/pages/claude-code-on-the-web-ja.md
+++ b/docs-ja/pages/claude-code-on-the-web-ja.md
@@ -8,5 +8,5 @@
 
 <Note>
-  ウェブ上の Claude Code は現在リサーチプレビュー中です。
+  ウェブ上の Claude Code は現在リサーチプレビュー段階です。
 </Note>
 
@@ -16,12 +16,12 @@
 
 * **質問への回答**：コードアーキテクチャと機能の実装方法について質問する
-* **バグ修正とルーチンタスク**：頻繁なステアリングを必要としない明確に定義されたタスク
+* **バグ修正とルーチンタスク**：頻繁な操舵が不要な明確に定義されたタスク
 * **並列作業**：複数のバグ修正を並列で処理する
 * **ローカルマシンにないリポジトリ**：ローカルにチェックアウトしていないコードで作業する
 * **バックエンド変更**：Claude Code がテストを作成してからそのテストに合格するコードを作成できる場所
 
-Claude Code は Claude iOS アプリでも利用可能で、移動中にタスクを開始したり、進行中の作業を監視したりできます。
+Claude Code は Claude アプリの [iOS](https://apps.apple.com/us/app/claude-by-anthropic/id6473753684) および [Android](https://play.google.com/store/apps/details?id=com.anthropic.claude) でも利用可能で、移動中にタスクを開始し、進行中の作業を監視できます。
 
-ローカルとリモート開発の間を移動できます：`&` プレフィックスで[ターミナルからウェブへタスクを送信](#from-terminal-to-web)して実行するか、[ウェブセッションをターミナルにテレポート](#from-web-to-terminal)してローカルで続行します。
+ローカルとリモート開発の間を移動できます：`&` プレフィックスで [ターミナルからウェブで実行するタスクを送信](#from-terminal-to-web)するか、[ウェブセッションをターミナルにテレポート](#from-web-to-terminal)してローカルで続行します。クラウドインフラストラクチャの代わりに自分のマシンで Claude Code を実行しながらウェブインターフェースを使用するには、[リモートコントロール](/ja/remote-control) を参照してください。
 
 ## ウェブ上の Claude Code は誰が使用できますか？
@@ -31,6 +31,6 @@ Claude Code は Claude iOS アプリでも利用可能で、移動中にタス
 * **Pro ユーザー**
 * **Max ユーザー**
```

</details>

<details>
<summary>cli-reference-ja.md</summary>

```diff
diff --git a/docs-ja/pages/cli-reference-ja.md b/docs-ja/pages/cli-reference-ja.md
index c8ee375..4c3f3d1 100644
--- a/docs-ja/pages/cli-reference-ja.md
+++ b/docs-ja/pages/cli-reference-ja.md
@@ -9,73 +9,80 @@
 ## CLI コマンド
 
-| コマンド                            | 説明                                 | 例                                            |
-| :------------------------------ | :--------------------------------- | :------------------------------------------- |
-| `claude`                        | インタラクティブ REPL を開始                  | `claude`                                     |
-| `claude "query"`                | 初期プロンプト付きで REPL を開始                | `claude "explain this project"`              |
-| `claude -p "query"`             | SDK 経由でクエリを実行してから終了                | `claude -p "explain this function"`          |
-| `cat file \| claude -p "query"` | パイプされたコンテンツを処理                     | `cat logs.txt \| claude -p "explain"`        |
-| `claude -c`                     | 現在のディレクトリで最新の会話を続行                 | `claude -c`                                  |
-| `claude -c -p "query"`          | SDK 経由で続行                          | `claude -c -p "Check for type errors"`       |
-| `claude -r "<session>" "query"` | セッション ID または名前でセッションを再開            | `claude -r "auth-refactor" "Finish this PR"` |
-| `claude update`                 | 最新バージョンに更新                         | `claude update`                              |
-| `claude mcp`                    | Model Context Protocol（MCP）サーバーを設定 | [Claude Code MCP ドキュメント](/ja/mcp)を参照してください。  |
+| コマンド                            | 説明                                                                                                                                                              | 例                                            |
+| :------------------------------ | :-------------------------------------------------------------------------------------------------------------------------------------------------------------- | :------------------------------------------- |
+| `claude`                        | インタラクティブ REPL を開始                                                                                                                                               | `claude`                                     |
+| `claude "query"`                | 初期プロンプト付きで REPL を開始                                                                                                                                             | `claude "explain this project"`              |
+| `claude -p "query"`             | SDK 経由でクエリを実行してから終了                                                                                                                                             | `claude -p "explain this function"`          |
+| `cat file \| claude -p "query"` | パイプされたコンテンツを処理                                                                                                                                                  | `cat logs.txt \| claude -p "explain"`        |
+| `claude -c`                     | 現在のディレクトリで最新の会話を続行                                                                                                                                              | `claude -c`                                  |
+| `claude -c -p "query"`          | SDK 経由で続行                                                                                                                                                       | `claude -c -p "Check for type errors"`       |
+| `claude -r "<session>" "query"` | セッション ID または名前でセッションを再開                                                                                                                                         | `claude -r "auth-refactor" "Finish this PR"` |
+| `claude update`                 | 最新バージョンに更新                                                                                                                                                      | `claude update`                              |
+| `claude auth login`             | Anthropic アカウントにサインイン                                                                                                                                           | `claude auth login`                          |
+| `claude auth logout`            | Anthropic アカウントからログアウト                                                                                                                                          | `claude auth logout`                         |
```

</details>

<details>
<summary>data-usage-ja.md</summary>

```diff
diff --git a/docs-ja/pages/data-usage-ja.md b/docs-ja/pages/data-usage-ja.md
index 1f3e885..4f4746c 100644
--- a/docs-ja/pages/data-usage-ja.md
+++ b/docs-ja/pages/data-usage-ja.md
@@ -5,5 +5,5 @@
 # データ使用
 
-> Anthropic の Claude のデータ使用ポリシーについて学習します
+> Anthropic の Claude のデータ使用ポリシーについて学びます
 
 ## データポリシー
@@ -44,7 +44,7 @@ Anthropic は、アカウントタイプと設定に基づいて Claude Code デ
 * 標準：30 日間の保持期間
 * ゼロデータ保持：適切に設定された API キーで利用可能 - Claude Code はサーバーにチャットトランスクリプトを保持しません
-* ローカルキャッシング：Claude Code クライアントは、セッション再開を有効にするために、セッションをローカルに最大 30 日間保存できます（設定可能）
+* ローカルキャッシング：Claude Code クライアントはセッション再開を有効にするために、セッションをローカルに最大 30 日間保存できます（設定可能）
 
-データ保持慣行の詳細については、[Privacy Center](https://privacy.anthropic.com/) をご覧ください。
+[Privacy Center](https://privacy.anthropic.com/) でデータ保持慣行の詳細をご覧ください。
 
 詳細については、[Commercial Terms of Service](https://www.anthropic.com/legal/commercial-terms)（Team、Enterprise、API ユーザー向け）または [Consumer Terms](https://www.anthropic.com/legal/consumer-terms)（Free、Pro、Max ユーザー向け）および [Privacy Policy](https://www.anthropic.com/legal/privacy) をご確認ください。
@@ -52,7 +52,7 @@ Anthropic は、アカウントタイプと設定に基づいて Claude Code デ
 ## データアクセス
 
-すべてのファーストパーティユーザーの場合、[local Claude Code](#local-claude-code-data-flow-and-dependencies) および [remote Claude Code](#cloud-execution-data-flow-and-dependencies) でログされるデータについて詳しく知ることができます。リモート Claude Code の場合、Claude は Claude Code セッションを開始したリポジトリにアクセスします。Claude は接続したが、セッションを開始していないリポジトリにはアクセスしません。
+すべてのファーストパーティユーザーの場合、[ローカル Claude Code](#local-claude-code-data-flow-and-dependencies) および [リモート Claude Code](#cloud-execution-data-flow-and-dependencies) でログされるデータについて詳しく知ることができます。[Remote Control](/ja/remote-control) セッションはすべての実行がマシン上で行われるため、ローカルデータフローに従います。リモート Claude Code の場合、Claude は Claude Code セッションを開始したリポジトリにアクセスします。Claude は接続したが、セッションを開始していないリポジトリにはアクセスしません。
 
-## Local Claude Code：データフローと依存関係
+## ローカル Claude Code：データフローと依存関係
 
```

</details>

*...以降省略*

</details>


<details>
<summary>2026-02-21</summary>

**変更ファイル:**

```
 docs-ja/pages/changelog.md                  | 29 ++++++++++++++++++++++++++++
 docs-ja/pages/desktop-quickstart-en.md      | 30 +++++++++++++++++------------
 docs-ja/pages/server-managed-settings-en.md |  2 ++
 3 files changed, 49 insertions(+), 12 deletions(-)
```

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index a6a92ad..20d264b 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,6 +1,35 @@
 # Changelog
 
+## 2.1.50
+
+- Added support for `startupTimeout` configuration for LSP servers
+- Added `WorktreeCreate` and `WorktreeRemove` hook events, enabling custom VCS setup and teardown when agent worktree isolation creates or removes worktrees.
+- Fixed a bug where resumed sessions could be invisible when the working directory involved symlinks, because the session storage path was resolved at different times during startup. Also fixed session data loss on SSH disconnect by flushing session data before hooks and analytics in the graceful shutdown sequence.
+- Linux: Fixed native modules not loading on systems with glibc older than 2.30 (e.g., RHEL 8)
+- Fixed memory leak in agent teams where completed teammate tasks were never garbage collected from session state
+- Fixed `CLAUDE_CODE_SIMPLE` to fully strip down skills, session memory, custom agents, and CLAUDE.md token counting
+- Fixed `/mcp reconnect` freezing the CLI when given a server name that doesn't exist
+- Fixed memory leak where completed task state objects were never removed from AppState
+- Added support for `isolation: worktree` in agent definitions, allowing agents to declaratively run in isolated git worktrees.
+- `CLAUDE_CODE_SIMPLE` mode now also disables MCP tools, attachments, hooks, and CLAUDE.md file loading for a fully minimal experience.
+- Fixed bug where MCP tools were not discovered when tool search is enabled and a prompt is passed in as a launch argument
+- Improved memory usage during long sessions by clearing internal caches after compaction
+- Added `claude agents` CLI command to list all configured agents
+- Improved memory usage during long sessions by clearing large tool results after they have been processed
+- Fixed a memory leak where LSP diagnostic data was never cleaned up after delivery, causing unbounded memory growth in long sessions
+- Fixed a memory leak where completed task output was not freed from memory, reducing memory usage in long sessions with many tasks
+- Improved startup performance for headless mode (`-p` flag) by deferring Yoga WASM and UI component imports
+- Fixed prompt suggestion cache regression that reduced cache hit rates
+- Fixed unbounded memory growth in long sessions by capping file history snapshots
+- Added `CLAUDE_CODE_DISABLE_1M_CONTEXT` environment variable to disable 1M context window support
+- Opus 4.6 (fast mode) now includes the full 1M context window
```

</details>

<details>
<summary>desktop-quickstart-en.md</summary>

```diff
diff --git a/docs-ja/pages/desktop-quickstart-en.md b/docs-ja/pages/desktop-quickstart-en.md
index 42083d2..317c582 100644
--- a/docs-ja/pages/desktop-quickstart-en.md
+++ b/docs-ja/pages/desktop-quickstart-en.md
@@ -7,12 +7,12 @@
 > Install Claude Code on desktop and start your first coding session
 
-The desktop app gives you Claude Code with a graphical interface: visual diff review, parallel sessions with Git worktree isolation, file attachments, and the ability to run long-running tasks remotely. Work with local files, connect to remote machines over SSH, or run sessions in the cloud. No terminal required.
+The desktop app gives you Claude Code with a graphical interface: visual diff review, live app preview, GitHub PR monitoring with auto-merge, parallel sessions with Git worktree isolation, and the ability to run tasks remotely. No terminal required.
 
-If you're already set up, see [Use Claude Code Desktop](/en/desktop) for the full reference.
+This page walks through installing the app and starting your first session. If you're already set up, see [Use Claude Code Desktop](/en/desktop) for the full reference.
 
 <Frame>
-  <img src="https://mintcdn.com/claude-code/CNLUpFGiXoc9mhvD/images/desktop-code-tab-light.png?fit=max&auto=format&n=CNLUpFGiXoc9mhvD&q=85&s=9a36a7a27b9f4c6f2e1c83bdb34f69ce" className="block dark:hidden" alt="The Claude Code Desktop interface showing the Code tab selected, with a prompt box, permission mode selector set to Ask, model picker, folder selector, and Local environment option" data-og-width="2500" width="2500" data-og-height="1376" height="1376" data-path="images/desktop-code-tab-light.png" data-optimize="true" data-opv="3" srcset="https://mintcdn.com/claude-code/CNLUpFGiXoc9mhvD/images/desktop-code-tab-light.png?w=280&fit=max&auto=format&n=CNLUpFGiXoc9mhvD&q=85&s=b4d1408a312d3ff3ac96dd133e4ef32b 280w, https://mintcdn.com/claude-code/CNLUpFGiXoc9mhvD/images/desktop-code-tab-light.png?w=560&fit=max&auto=format&n=CNLUpFGiXoc9mhvD&q=85&s=c2d9f668767d4de33696b3de190c0024 560w, https://mintcdn.com/claude-code/CNLUpFGiXoc9mhvD/images/desktop-code-tab-light.png?w=840&fit=max&auto=format&n=CNLUpFGiXoc9mhvD&q=85&s=89a78335d513c0ec2131feb11eeef6dc 840w, https://mintcdn.com/claude-code/CNLUpFGiXoc9mhvD/images/desktop-code-tab-light.png?w=1100&fit=max&auto=format&n=CNLUpFGiXoc9mhvD&q=85&s=0ef93540eafcedd2fb0ad718553325f4 1100w, https://mintcdn.com/claude-code/CNLUpFGiXoc9mhvD/images/desktop-code-tab-light.png?w=1650&fit=max&auto=format&n=CNLUpFGiXoc9mhvD&q=85&s=e7923c583f632de9f8a7e0e0da4f8c84 1650w, https://mintcdn.com/claude-code/CNLUpFGiXoc9mhvD/images/desktop-code-tab-light.png?w=2500&fit=max&auto=format&n=CNLUpFGiXoc9mhvD&q=85&s=38d64bdceaba941a73446f258be336ea 2500w" />
+  <img src="https://mintcdn.com/claude-code/CNLUpFGiXoc9mhvD/images/desktop-code-tab-light.png?fit=max&auto=format&n=CNLUpFGiXoc9mhvD&q=85&s=9a36a7a27b9f4c6f2e1c83bdb34f69ce" className="block dark:hidden" alt="The Claude Code Desktop interface showing the Code tab selected, with a prompt box, permission mode selector set to Ask permissions, model picker, folder selector, and Local environment option" data-og-width="2500" width="2500" data-og-height="1376" height="1376" data-path="images/desktop-code-tab-light.png" data-optimize="true" data-opv="3" srcset="https://mintcdn.com/claude-code/CNLUpFGiXoc9mhvD/images/desktop-code-tab-light.png?w=280&fit=max&auto=format&n=CNLUpFGiXoc9mhvD&q=85&s=b4d1408a312d3ff3ac96dd133e4ef32b 280w, https://mintcdn.com/claude-code/CNLUpFGiXoc9mhvD/images/desktop-code-tab-light.png?w=560&fit=max&auto=format&n=CNLUpFGiXoc9mhvD&q=85&s=c2d9f668767d4de33696b3de190c0024 560w, https://mintcdn.com/claude-code/CNLUpFGiXoc9mhvD/images/desktop-code-tab-light.png?w=840&fit=max&auto=format&n=CNLUpFGiXoc9mhvD&q=85&s=89a78335d513c0ec2131feb11eeef6dc 840w, https://mintcdn.com/claude-code/CNLUpFGiXoc9mhvD/images/desktop-code-tab-light.png?w=1100&fit=max&auto=format&n=CNLUpFGiXoc9mhvD&q=85&s=0ef93540eafcedd2fb0ad718553325f4 1100w, https://mintcdn.com/claude-code/CNLUpFGiXoc9mhvD/images/desktop-code-tab-light.png?w=1650&fit=max&auto=format&n=CNLUpFGiXoc9mhvD&q=85&s=e7923c583f632de9f8a7e0e0da4f8c84 1650w, https://mintcdn.com/claude-code/CNLUpFGiXoc9mhvD/images/desktop-code-tab-light.png?w=2500&fit=max&auto=format&n=CNLUpFGiXoc9mhvD&q=85&s=38d64bdceaba941a73446f258be336ea 2500w" />
 
-  <img src="https://mintcdn.com/claude-code/CNLUpFGiXoc9mhvD/images/desktop-code-tab-dark.png?fit=max&auto=format&n=CNLUpFGiXoc9mhvD&q=85&s=5463defe81c459fb9b1f91f6a958cfb8" className="hidden dark:block" alt="The Claude Code Desktop interface in dark mode showing the Code tab selected, with a prompt box, permission mode selector set to Ask, model picker, folder selector, and Local environment option" data-og-width="2504" width="2504" data-og-height="1374" height="1374" data-path="images/desktop-code-tab-dark.png" data-optimize="true" data-opv="3" srcset="https://mintcdn.com/claude-code/CNLUpFGiXoc9mhvD/images/desktop-code-tab-dark.png?w=280&fit=max&auto=format&n=CNLUpFGiXoc9mhvD&q=85&s=f2a6322688262feb9d680b99c24817ab 280w, https://mintcdn.com/claude-code/CNLUpFGiXoc9mhvD/images/desktop-code-tab-dark.png?w=560&fit=max&auto=format&n=CNLUpFGiXoc9mhvD&q=85&s=ffe9a3d1c4260fb12c66f533fdedc02e 560w, https://mintcdn.com/claude-code/CNLUpFGiXoc9mhvD/images/desktop-code-tab-dark.png?w=840&fit=max&auto=format&n=CNLUpFGiXoc9mhvD&q=85&s=867b7997a910af3ffac1101559564dd7 840w, https://mintcdn.com/claude-code/CNLUpFGiXoc9mhvD/images/desktop-code-tab-dark.png?w=1100&fit=max&auto=format&n=CNLUpFGiXoc9mhvD&q=85&s=976c9049c9e4cea2b02d4b6a1ef55142 1100w, https://mintcdn.com/claude-code/CNLUpFGiXoc9mhvD/images/desktop-code-tab-dark.png?w=1650&fit=max&auto=format&n=CNLUpFGiXoc9mhvD&q=85&s=d8f3792ddadf66f61306dc41680aaa34 1650w, https://mintcdn.com/claude-code/CNLUpFGiXoc9mhvD/images/desktop-code-tab-dark.png?w=2500&fit=max&auto=format&n=CNLUpFGiXoc9mhvD&q=85&s=88d049488f547e483e8c4f59ea8b2fd8 2500w" />
+  <img src="https://mintcdn.com/claude-code/CNLUpFGiXoc9mhvD/images/desktop-code-tab-dark.png?fit=max&auto=format&n=CNLUpFGiXoc9mhvD&q=85&s=5463defe81c459fb9b1f91f6a958cfb8" className="hidden dark:block" alt="The Claude Code Desktop interface in dark mode showing the Code tab selected, with a prompt box, permission mode selector set to Ask permissions, model picker, folder selector, and Local environment option" data-og-width="2504" width="2504" data-og-height="1374" height="1374" data-path="images/desktop-code-tab-dark.png" data-optimize="true" data-opv="3" srcset="https://mintcdn.com/claude-code/CNLUpFGiXoc9mhvD/images/desktop-code-tab-dark.png?w=280&fit=max&auto=format&n=CNLUpFGiXoc9mhvD&q=85&s=f2a6322688262feb9d680b99c24817ab 280w, https://mintcdn.com/claude-code/CNLUpFGiXoc9mhvD/images/desktop-code-tab-dark.png?w=560&fit=max&auto=format&n=CNLUpFGiXoc9mhvD&q=85&s=ffe9a3d1c4260fb12c66f533fdedc02e 560w, https://mintcdn.com/claude-code/CNLUpFGiXoc9mhvD/images/desktop-code-tab-dark.png?w=840&fit=max&auto=format&n=CNLUpFGiXoc9mhvD&q=85&s=867b7997a910af3ffac1101559564dd7 840w, https://mintcdn.com/claude-code/CNLUpFGiXoc9mhvD/images/desktop-code-tab-dark.png?w=1100&fit=max&auto=format&n=CNLUpFGiXoc9mhvD&q=85&s=976c9049c9e4cea2b02d4b6a1ef55142 1100w, https://mintcdn.com/claude-code/CNLUpFGiXoc9mhvD/images/desktop-code-tab-dark.png?w=1650&fit=max&auto=format&n=CNLUpFGiXoc9mhvD&q=85&s=d8f3792ddadf66f61306dc41680aaa34 1650w, https://mintcdn.com/claude-code/CNLUpFGiXoc9mhvD/images/desktop-code-tab-dark.png?w=2500&fit=max&auto=format&n=CNLUpFGiXoc9mhvD&q=85&s=88d049488f547e483e8c4f59ea8b2fd8 2500w" />
 </Frame>
 
@@ -45,5 +45,5 @@ Chat and Cowork are covered in the [Claude Desktop support articles](https://sup
     </CardGroup>
 
-    For Windows ARM64, [download here](https://claude.ai/api/desktop/win32/arm64/exe/latest/redirect?utm_source=claude_code\&utm_medium=docs). Local sessions are not available on ARM64 devices, so use remote sessions instead. See [ARM64 limitations](/en/desktop#windows-specific-issues) for details.
+    For Windows ARM64, [download here](https://claude.ai/api/desktop/win32/arm64/exe/latest/redirect?utm_source=claude_code\&utm_medium=docs).
 
     Linux is not currently supported.
@@ -59,4 +59,6 @@ Chat and Cowork are covered in the [Claude Desktop support articles](https://sup
 </Steps>
```

</details>

<details>
<summary>server-managed-settings-en.md</summary>

```diff
diff --git a/docs-ja/pages/server-managed-settings-en.md b/docs-ja/pages/server-managed-settings-en.md
index e80d0e7..61b3565 100644
--- a/docs-ja/pages/server-managed-settings-en.md
+++ b/docs-ja/pages/server-managed-settings-en.md
@@ -151,4 +151,6 @@ Server-managed settings provide centralized policy enforcement, but they operate
 | User sets a non-default `ANTHROPIC_BASE_URL`     | Server-managed settings are bypassed when using third-party API providers                                       |
 
+To detect runtime configuration changes, use [`ConfigChange` hooks](/en/hooks#configchange) to log modifications or block unauthorized changes before they take effect.
+
 For stronger enforcement guarantees, use [endpoint-managed settings](/en/permissions#managed-settings) on devices enrolled in an MDM solution.
 
```

</details>

</details>


<details>
<summary>2026-02-20</summary>

**変更ファイル:**

```
 docs-ja/pages/changelog.md                | 29 +++++++++++++++++++++++++++++
 docs-ja/pages/data-usage-ja.md            |  2 +-
 docs-ja/pages/features-overview-ja.md     |  2 +-
 docs-ja/pages/how-claude-code-works-ja.md |  4 ++--
 4 files changed, 33 insertions(+), 4 deletions(-)
```

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index 43a16ff..a6a92ad 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,33 @@
 # Changelog
 
+## 2.1.49
+
+- Added `--worktree` (`-w`) flag to start Claude in an isolated git worktree
+- Subagents support `isolation: "worktree"` for working in a temporary git worktree
+- Added Ctrl+F keybinding to kill background agents (two-press confirmation)
+- Agent definitions support `background: true` to always run as a background task
+- Plugins can ship `settings.json` for default configuration
+- Fixed file-not-found errors to suggest corrected paths when the model drops the repo folder
+- Fixed Ctrl+C and ESC being silently ignored when background agents are running and the main thread is idle. Pressing twice within 3 seconds now kills all background agents.
+- Fixed prompt suggestion cache regression that reduced cache hit rates.
+- Fixed `plugin enable` and `plugin disable` to auto-detect the correct scope when `--scope` is not specified, instead of always defaulting to user scope
+- Simple mode (`CLAUDE_CODE_SIMPLE`) now includes the file edit tool in addition to the Bash tool, allowing direct file editing in simple mode.
+- Permission suggestions are now populated when safety checks trigger an ask response, enabling SDK consumers to display permission options
+- Sonnet 4.5 with 1M context is being removed from the Max plan in favor of our frontier Sonnet 4.6 model, which now has 1M context. Please switch in /model.
+- Fixed verbose mode not updating thinking block display when toggled via `/config` — memo comparators now correctly detect verbose changes
+- Fixed unbounded WASM memory growth during long sessions by periodically resetting the tree-sitter parser
+- Fixed potential rendering issues caused by stale yoga layout references
+- Improved performance in non-interactive mode (`-p`) by skipping unnecessary API calls during startup
+- Improved performance by caching authentication failures for HTTP and SSE MCP servers, avoiding repeated connection attempts to servers requiring auth
+- Fixed unbounded memory growth during long-running sessions caused by Yoga WASM linear memory never shrinking
+- SDK model info now includes `supportsEffort`, `supportedEffortLevels`, and `supportsAdaptiveThinking` fields so consumers can discover model capabilities.
+- Added `ConfigChange` hook event that fires when configuration files change during a session, enabling enterprise security auditing and optional blocking of settings changes.
+- Improved startup performance by caching MCP auth failures to avoid redundant connection attempts
```

</details>

<details>
<summary>data-usage-ja.md</summary>

```diff
diff --git a/docs-ja/pages/data-usage-ja.md b/docs-ja/pages/data-usage-ja.md
index a135b1d..1f3e885 100644
--- a/docs-ja/pages/data-usage-ja.md
+++ b/docs-ja/pages/data-usage-ja.md
@@ -58,5 +58,5 @@ Anthropic は、アカウントタイプと設定に基づいて Claude Code デ
 以下の図は、インストール中および通常の操作中に Claude Code が外部サービスにどのように接続するかを示しています。実線は必須の接続を示し、破線はオプションまたはユーザーが開始したデータフローを表します。
 
-<img src="https://mintcdn.com/claude-code/I9Dpo7RZuIbc86cX/images/claude-code-data-flow.svg?fit=max&auto=format&n=I9Dpo7RZuIbc86cX&q=85&s=9e77f476347e7c9983f6e211d27cf6a9" alt="Claude Code の外部接続を示す図：インストール/更新は NPM に接続し、ユーザーリクエストは Console 認証、public-api、およびオプションで Statsig、Sentry、バグレポートを含む Anthropic サービスに接続します" data-og-width="720" width="720" data-og-height="520" height="520" data-path="images/claude-code-data-flow.svg" data-optimize="true" data-opv="3" srcset="https://mintcdn.com/claude-code/I9Dpo7RZuIbc86cX/images/claude-code-data-flow.svg?w=280&fit=max&auto=format&n=I9Dpo7RZuIbc86cX&q=85&s=94c033b9b6db3d10b9e2d7c6d681d9dc 280w, https://mintcdn.com/claude-code/I9Dpo7RZuIbc86cX/images/claude-code-data-flow.svg?w=560&fit=max&auto=format&n=I9Dpo7RZuIbc86cX&q=85&s=430aaaf77c28c501d5753ffa456ee227 560w, https://mintcdn.com/claude-code/I9Dpo7RZuIbc86cX/images/claude-code-data-flow.svg?w=840&fit=max&auto=format&n=I9Dpo7RZuIbc86cX&q=85&s=63c3c3f160b522220a8291fe2f93f970 840w, https://mintcdn.com/claude-code/I9Dpo7RZuIbc86cX/images/claude-code-data-flow.svg?w=1100&fit=max&auto=format&n=I9Dpo7RZuIbc86cX&q=85&s=a7f6e838482f4a1a0a0b4683439369ea 1100w, https://mintcdn.com/claude-code/I9Dpo7RZuIbc86cX/images/claude-code-data-flow.svg?w=1650&fit=max&auto=format&n=I9Dpo7RZuIbc86cX&q=85&s=5fbf749c2f94babb3ef72edfb7aba1e9 1650w, https://mintcdn.com/claude-code/I9Dpo7RZuIbc86cX/images/claude-code-data-flow.svg?w=2500&fit=max&auto=format&n=I9Dpo7RZuIbc86cX&q=85&s=7a1babbdccc4986957698d9c5c30c4a8 2500w" />
+<img src="https://mintcdn.com/claude-code/TBPmHzr19mDCuhZi/images/claude-code-data-flow.svg?fit=max&auto=format&n=TBPmHzr19mDCuhZi&q=85&s=e0239c69a0bbae485b726338e50f1082" alt="Claude Code の外部接続を示す図：インストール/更新は NPM に接続し、ユーザーリクエストは Console 認証、public-api、およびオプションで Statsig、Sentry、バグレポートを含む Anthropic サービスに接続します" data-og-width="720" width="720" data-og-height="520" height="520" data-path="images/claude-code-data-flow.svg" data-optimize="true" data-opv="3" srcset="https://mintcdn.com/claude-code/TBPmHzr19mDCuhZi/images/claude-code-data-flow.svg?w=280&fit=max&auto=format&n=TBPmHzr19mDCuhZi&q=85&s=06435e080df22e66a454e99af1b6040b 280w, https://mintcdn.com/claude-code/TBPmHzr19mDCuhZi/images/claude-code-data-flow.svg?w=560&fit=max&auto=format&n=TBPmHzr19mDCuhZi&q=85&s=8261c15b4ffc12504e0a6e3f0ccd8c7d 560w, https://mintcdn.com/claude-code/TBPmHzr19mDCuhZi/images/claude-code-data-flow.svg?w=840&fit=max&auto=format&n=TBPmHzr19mDCuhZi&q=85&s=163bfaa8d4727a1bbb492cb086e5f083 840w, https://mintcdn.com/claude-code/TBPmHzr19mDCuhZi/images/claude-code-data-flow.svg?w=1100&fit=max&auto=format&n=TBPmHzr19mDCuhZi&q=85&s=ea3c2f801dfa5ad956b18b5f72df5c50 1100w, https://mintcdn.com/claude-code/TBPmHzr19mDCuhZi/images/claude-code-data-flow.svg?w=1650&fit=max&auto=format&n=TBPmHzr19mDCuhZi&q=85&s=91d743def7a8d074c93001b351f23037 1650w, https://mintcdn.com/claude-code/TBPmHzr19mDCuhZi/images/claude-code-data-flow.svg?w=2500&fit=max&auto=format&n=TBPmHzr19mDCuhZi&q=85&s=df68b2dd6de83316f70fd7f61c3a3bbd 2500w" />
 
 Claude Code は [NPM](https://www.npmjs.com/package/@anthropic-ai/claude-code) からインストールされます。Claude Code はローカルで実行されます。LLM と対話するために、Claude Code はネットワーク経由でデータを送信します。このデータには、すべてのユーザープロンプトとモデル出力が含まれます。データは TLS を介して転送中に暗号化され、保存時には暗号化されません。Claude Code はほとんどの一般的な VPN および LLM プロキシと互換性があります。
```

</details>

<details>
<summary>features-overview-ja.md</summary>

```diff
diff --git a/docs-ja/pages/features-overview-ja.md b/docs-ja/pages/features-overview-ja.md
index f896028..f699edc 100644
--- a/docs-ja/pages/features-overview-ja.md
+++ b/docs-ja/pages/features-overview-ja.md
@@ -173,5 +173,5 @@ Claude Code は、コードについて推論するモデルと、ファイル
 各機能はセッションの異なるポイントで読み込まれます。以下のタブは、各機能がいつ読み込まれるか、およびコンテキストに何が入るかを説明しています。
 
-<img src="https://mintcdn.com/claude-code/ELkJZG54dIaeldDC/images/context-loading.svg?fit=max&auto=format&n=ELkJZG54dIaeldDC&q=85&s=bd2e24b8e6a99b31ecfffb63f5b23bf5" alt="コンテキスト読み込み：CLAUDE.md と MCP はセッション開始時に読み込まれ、すべてのリクエストに留まります。Skill は開始時に説明を読み込み、呼び出し時に完全なコンテンツを読み込みます。Subagent は分離されたコンテキストを取得します。Hook は外部で実行されます。" data-og-width="720" width="720" data-og-height="410" height="410" data-path="images/context-loading.svg" data-optimize="true" data-opv="3" srcset="https://mintcdn.com/claude-code/ELkJZG54dIaeldDC/images/context-loading.svg?w=280&fit=max&auto=format&n=ELkJZG54dIaeldDC&q=85&s=aebaadd1f484f285dd9cb4e0ea6d49b9 280w, https://mintcdn.com/claude-code/ELkJZG54dIaeldDC/images/context-loading.svg?w=560&fit=max&auto=format&n=ELkJZG54dIaeldDC&q=85&s=030c9b46126d750de315612560082727 560w, https://mintcdn.com/claude-code/ELkJZG54dIaeldDC/images/context-loading.svg?w=840&fit=max&auto=format&n=ELkJZG54dIaeldDC&q=85&s=6c73f8b0389da4f3190843140c810fe9 840w, https://mintcdn.com/claude-code/ELkJZG54dIaeldDC/images/context-loading.svg?w=1100&fit=max&auto=format&n=ELkJZG54dIaeldDC&q=85&s=9844c55d08d2c386672447f2e8518669 1100w, https://mintcdn.com/claude-code/ELkJZG54dIaeldDC/images/context-loading.svg?w=1650&fit=max&auto=format&n=ELkJZG54dIaeldDC&q=85&s=21a9522d0e4bd10ced146aab850ede76 1650w, https://mintcdn.com/claude-code/ELkJZG54dIaeldDC/images/context-loading.svg?w=2500&fit=max&auto=format&n=ELkJZG54dIaeldDC&q=85&s=d318525915aee1a1a6a4215cfaa61fb9 2500w" />
+<img src="https://mintcdn.com/claude-code/TBPmHzr19mDCuhZi/images/context-loading.svg?fit=max&auto=format&n=TBPmHzr19mDCuhZi&q=85&s=43114d93ae62bdc1ab6aa64660e2ba3b" alt="コンテキスト読み込み：CLAUDE.md と MCP はセッション開始時に読み込まれ、すべてのリクエストに留まります。Skill は開始時に説明を読み込み、呼び出し時に完全なコンテンツを読み込みます。Subagent は分離されたコンテキストを取得します。Hook は外部で実行されます。" data-og-width="720" width="720" data-og-height="410" height="410" data-path="images/context-loading.svg" data-optimize="true" data-opv="3" srcset="https://mintcdn.com/claude-code/TBPmHzr19mDCuhZi/images/context-loading.svg?w=280&fit=max&auto=format&n=TBPmHzr19mDCuhZi&q=85&s=cc37ac2b6b486c75dea4cf64add648ec 280w, https://mintcdn.com/claude-code/TBPmHzr19mDCuhZi/images/context-loading.svg?w=560&fit=max&auto=format&n=TBPmHzr19mDCuhZi&q=85&s=22394bf8452988091802c6bc471a3153 560w, https://mintcdn.com/claude-code/TBPmHzr19mDCuhZi/images/context-loading.svg?w=840&fit=max&auto=format&n=TBPmHzr19mDCuhZi&q=85&s=aaf0301abbd63349b3f5ecf27f3bc4c5 840w, https://mintcdn.com/claude-code/TBPmHzr19mDCuhZi/images/context-loading.svg?w=1100&fit=max&auto=format&n=TBPmHzr19mDCuhZi&q=85&s=f262d974340400cfd964c555b523808a 1100w, https://mintcdn.com/claude-code/TBPmHzr19mDCuhZi/images/context-loading.svg?w=1650&fit=max&auto=format&n=TBPmHzr19mDCuhZi&q=85&s=430b76391f55ba65a0a3da569a52a450 1650w, https://mintcdn.com/claude-code/TBPmHzr19mDCuhZi/images/context-loading.svg?w=2500&fit=max&auto=format&n=TBPmHzr19mDCuhZi&q=85&s=46522043165b15cfef464d5f63c70f7c 2500w" />
 
 <Tabs>
```

</details>

<details>
<summary>how-claude-code-works-ja.md</summary>

```diff
diff --git a/docs-ja/pages/how-claude-code-works-ja.md b/docs-ja/pages/how-claude-code-works-ja.md
index 9824e57..123718d 100644
--- a/docs-ja/pages/how-claude-code-works-ja.md
+++ b/docs-ja/pages/how-claude-code-works-ja.md
@@ -15,5 +15,5 @@ Claude Code はターミナルで実行される agentic アシスタントで
 Claude にタスクを与えると、3 つのフェーズを通じて作業します。**コンテキストの収集**、**アクションの実行**、**結果の検証** です。これらのフェーズは相互に融合します。Claude はツールを使用して、コードを理解するためのファイル検索、変更を加えるための編集、作業を確認するためのテスト実行など、様々な場面で活用します。
 
-<img src="https://mintcdn.com/claude-code/ELkJZG54dIaeldDC/images/agentic-loop.svg?fit=max&auto=format&n=ELkJZG54dIaeldDC&q=85&s=e30acfc80d6ff01ec877dd19c7af58b2" alt="agentic ループ：プロンプトから Claude がコンテキストを収集し、アクションを実行し、結果を検証し、タスク完了まで繰り返します。任意の時点で中断できます。" data-og-width="720" width="720" data-og-height="280" height="280" data-path="images/agentic-loop.svg" data-optimize="true" data-opv="3" srcset="https://mintcdn.com/claude-code/ELkJZG54dIaeldDC/images/agentic-loop.svg?w=280&fit=max&auto=format&n=ELkJZG54dIaeldDC&q=85&s=8620f6ebce761a1e8bbf7f0a0255cc15 280w, https://mintcdn.com/claude-code/ELkJZG54dIaeldDC/images/agentic-loop.svg?w=560&fit=max&auto=format&n=ELkJZG54dIaeldDC&q=85&s=7b46b5ff4454aa4a03725eee625b39a0 560w, https://mintcdn.com/claude-code/ELkJZG54dIaeldDC/images/agentic-loop.svg?w=840&fit=max&auto=format&n=ELkJZG54dIaeldDC&q=85&s=7fa0397bc37d147e3bf3bb6296c6477f 840w, https://mintcdn.com/claude-code/ELkJZG54dIaeldDC/images/agentic-loop.svg?w=1100&fit=max&auto=format&n=ELkJZG54dIaeldDC&q=85&s=73b2a7040c4c93821c4d5bbee9f4a2d4 1100w, https://mintcdn.com/claude-code/ELkJZG54dIaeldDC/images/agentic-loop.svg?w=1650&fit=max&auto=format&n=ELkJZG54dIaeldDC&q=85&s=17703cbeb6f59b40a00ab24f56d5f8f9 1650w, https://mintcdn.com/claude-code/ELkJZG54dIaeldDC/images/agentic-loop.svg?w=2500&fit=max&auto=format&n=ELkJZG54dIaeldDC&q=85&s=20dedb60b95d45a1bd60a0cccaf3e1ff 2500w" />
+<img src="https://mintcdn.com/claude-code/TBPmHzr19mDCuhZi/images/agentic-loop.svg?fit=max&auto=format&n=TBPmHzr19mDCuhZi&q=85&s=9d9cdb2102f397a0f57450ca5ca2a969" alt="agentic ループ：プロンプトから Claude がコンテキストを収集し、アクションを実行し、結果を検証し、タスク完了まで繰り返します。任意の時点で中断できます。" data-og-width="720" width="720" data-og-height="280" height="280" data-path="images/agentic-loop.svg" data-optimize="true" data-opv="3" srcset="https://mintcdn.com/claude-code/TBPmHzr19mDCuhZi/images/agentic-loop.svg?w=280&fit=max&auto=format&n=TBPmHzr19mDCuhZi&q=85&s=9c6a590754c1c1b281d40fc9f10fed0d 280w, https://mintcdn.com/claude-code/TBPmHzr19mDCuhZi/images/agentic-loop.svg?w=560&fit=max&auto=format&n=TBPmHzr19mDCuhZi&q=85&s=9fb2f2fc174e285797cad25a9ca2a326 560w, https://mintcdn.com/claude-code/TBPmHzr19mDCuhZi/images/agentic-loop.svg?w=840&fit=max&auto=format&n=TBPmHzr19mDCuhZi&q=85&s=3a1b68dd7b861e8ff25391773d8ab60c 840w, https://mintcdn.com/claude-code/TBPmHzr19mDCuhZi/images/agentic-loop.svg?w=1100&fit=max&auto=format&n=TBPmHzr19mDCuhZi&q=85&s=e64edf9f5cbc62464617945cf08ef134 1100w, https://mintcdn.com/claude-code/TBPmHzr19mDCuhZi/images/agentic-loop.svg?w=1650&fit=max&auto=format&n=TBPmHzr19mDCuhZi&q=85&s=3bf3319e76669f11513c6bcc5bf86feb 1650w, https://mintcdn.com/claude-code/TBPmHzr19mDCuhZi/images/agentic-loop.svg?w=2500&fit=max&auto=format&n=TBPmHzr19mDCuhZi&q=85&s=9413880a191409ff3c81bafc8f7ab977 2500w" />
 
 ループは、あなたが何を求めるかに応じて適応します。コードベースに関する質問は、コンテキスト収集だけで済むかもしれません。バグ修正は 3 つのフェーズすべてを繰り返し循環します。リファクタリングは広範な検証を伴うかもしれません。Claude は前のステップから学んだことに基づいて、各ステップが何を必要とするかを判断し、数十のアクションを連鎖させ、途中で軌道修正します。
@@ -92,5 +92,5 @@ Claude は現在のブランチのファイルを見ます。ブランチを切
 `claude --continue` または `claude --resume` でセッションを再開すると、同じセッション ID を使用して中断したところから再開します。新しいメッセージは既存の会話に追加されます。完全な会話履歴が復元されますが、セッションスコープの権限は復元されません。それらを再度承認する必要があります。
 
-<img src="https://mintcdn.com/claude-code/ELkJZG54dIaeldDC/images/session-continuity.svg?fit=max&auto=format&n=ELkJZG54dIaeldDC&q=85&s=f671b603cc856119c95475b9084ebfef" alt="セッション継続性：再開は同じセッションを続行し、フォークは新しい ID で新しいブランチを作成します。" data-og-width="560" width="560" data-og-height="280" height="280" data-path="images/session-continuity.svg" data-optimize="true" data-opv="3" srcset="https://mintcdn.com/claude-code/ELkJZG54dIaeldDC/images/session-continuity.svg?w=280&fit=max&auto=format&n=ELkJZG54dIaeldDC&q=85&s=bddf1f33d419a27d7427acdf06058804 280w, https://mintcdn.com/claude-code/ELkJZG54dIaeldDC/images/session-continuity.svg?w=560&fit=max&auto=format&n=ELkJZG54dIaeldDC&q=85&s=417478eb9b86003b8eebaac058a8618a 560w, https://mintcdn.com/claude-code/ELkJZG54dIaeldDC/images/session-continuity.svg?w=840&fit=max&auto=format&n=ELkJZG54dIaeldDC&q=85&s=1d89d26e2c0487f067d187c3fa5f7170 840w, https://mintcdn.com/claude-code/ELkJZG54dIaeldDC/images/session-continuity.svg?w=1100&fit=max&auto=format&n=ELkJZG54dIaeldDC&q=85&s=8ea739a1f7860e4edbbcf74d444e37b2 1100w, https://mintcdn.com/claude-code/ELkJZG54dIaeldDC/images/session-continuity.svg?w=1650&fit=max&auto=format&n=ELkJZG54dIaeldDC&q=85&s=9cb5095d6a8920f04c3b78d31a69c809 1650w, https://mintcdn.com/claude-code/ELkJZG54dIaeldDC/images/session-continuity.svg?w=2500&fit=max&auto=format&n=ELkJZG54dIaeldDC&q=85&s=d67e1744e4878813d20c6c3f39d9459d 2500w" />
+<img src="https://mintcdn.com/claude-code/TBPmHzr19mDCuhZi/images/session-continuity.svg?fit=max&auto=format&n=TBPmHzr19mDCuhZi&q=85&s=808da1b213c731bf98874c75981d688b" alt="セッション継続性：再開は同じセッションを続行し、フォークは新しい ID で新しいブランチを作成します。" data-og-width="560" width="560" data-og-height="280" height="280" data-path="images/session-continuity.svg" data-optimize="true" data-opv="3" srcset="https://mintcdn.com/claude-code/TBPmHzr19mDCuhZi/images/session-continuity.svg?w=280&fit=max&auto=format&n=TBPmHzr19mDCuhZi&q=85&s=ba75f64bc571f3ef84a3237ef795bf22 280w, https://mintcdn.com/claude-code/TBPmHzr19mDCuhZi/images/session-continuity.svg?w=560&fit=max&auto=format&n=TBPmHzr19mDCuhZi&q=85&s=343ad422a171a2b909c87ed01c768745 560w, https://mintcdn.com/claude-code/TBPmHzr19mDCuhZi/images/session-continuity.svg?w=840&fit=max&auto=format&n=TBPmHzr19mDCuhZi&q=85&s=afce54d5e3b08cdb54d506332462b74c 840w, https://mintcdn.com/claude-code/TBPmHzr19mDCuhZi/images/session-continuity.svg?w=1100&fit=max&auto=format&n=TBPmHzr19mDCuhZi&q=85&s=28648c0a04cf7aef2de02d1c98491965 1100w, https://mintcdn.com/claude-code/TBPmHzr19mDCuhZi/images/session-continuity.svg?w=1650&fit=max&auto=format&n=TBPmHzr19mDCuhZi&q=85&s=a5287882beedaea54af606f682e4818d 1650w, https://mintcdn.com/claude-code/TBPmHzr19mDCuhZi/images/session-continuity.svg?w=2500&fit=max&auto=format&n=TBPmHzr19mDCuhZi&q=85&s=f392dbe67b63eead4a2aae67adfbfdbe 2500w" />
 
 元のセッションに影響を与えずに別のアプローチを試すためにブランチを分岐させるには、`--fork-session` フラグを使用します。
```

</details>

</details>


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

<!-- UPDATE_LOG_END -->
