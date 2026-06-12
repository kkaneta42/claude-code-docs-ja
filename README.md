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
<summary>2026-06-12</summary>

**変更ファイル:**

```
 docs-ja/pages/amazon-bedrock-ja.md           |   72 ++
 docs-ja/pages/changelog.md                   |    5 +
 docs-ja/pages/claude-directory-ja.md         | 1426 +++++++++++++++++++++++
 docs-ja/pages/claude-platform-on-aws-ja.md   |  182 +++
 docs-ja/pages/context-window-ja.md           | 1564 ++++++++++++++++++++++++++
 docs-ja/pages/google-vertex-ai-ja.md         |   72 ++
 docs-ja/pages/microsoft-foundry-ja.md        |   72 ++
 docs-ja/pages/prompt-library-ja.md           | 1319 ++++++++++++++++++++++
 docs-ja/pages/third-party-integrations-ja.md |   72 ++
 9 files changed, 4784 insertions(+)
```

<details>
<summary>amazon-bedrock-ja.md</summary>

```diff
diff --git a/docs-ja/pages/amazon-bedrock-ja.md b/docs-ja/pages/amazon-bedrock-ja.md
index 6eac9dc..c411db1 100644
--- a/docs-ja/pages/amazon-bedrock-ja.md
+++ b/docs-ja/pages/amazon-bedrock-ja.md
@@ -7,4 +7,76 @@
 > Amazon Bedrock を通じた Claude Code の設定方法（セットアップ、IAM 設定、トラブルシューティングを含む）について学習します。
 
+export const ContactSalesCard = ({surface}) => {
+  const utm = content => `utm_source=claude_code&utm_medium=docs&utm_content=${surface}_${content}`;
+  const iconArrowRight = (size = 13) => <svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">
+      <line x1="5" y1="12" x2="19" y2="12" />
+      <polyline points="12 5 19 12 12 19" />
+    </svg>;
+  const STYLES = `
+.cc-cs {
+  --cs-slate: #141413;
+  --cs-clay: #d97757;
+  --cs-clay-deep: #c6613f;
+  --cs-gray-000: #ffffff;
+  --cs-gray-700: #3d3d3a;
+  --cs-border-default: rgba(31, 30, 29, 0.15);
+  font-family: inherit;
+}
+.dark .cc-cs {
+  --cs-slate: #f0eee6;
+  --cs-gray-000: #262624;
+  --cs-gray-700: #bfbdb4;
+  --cs-border-default: rgba(240, 238, 230, 0.14);
+}
+.cc-cs-card {
```

</details>

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index f1d4f8d..3aa61b1 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,9 @@
 # Changelog
 
+## 2.1.173
+
+- Fixed Fable 5 model names with a `[1m]` suffix not being normalized — Fable 5 includes 1M context by default, so the suffix is now stripped automatically
+- Fixed a spurious "sandbox dependencies missing" startup warning on Windows when sandbox was enabled in settings
+
 ## 2.1.172
 
```

</details>

<details>
<summary>claude-directory-ja.md</summary>

```diff
diff --git a/docs-ja/pages/claude-directory-ja.md b/docs-ja/pages/claude-directory-ja.md
index 0ab4439..467b49d 100644
--- a/docs-ja/pages/claude-directory-ja.md
+++ b/docs-ja/pages/claude-directory-ja.md
@@ -7,4 +7,1428 @@
 > Claude Code が CLAUDE.md、settings.json、hooks、skills、commands、subagents、workflows、rules、auto memory を読み込む場所。プロジェクト内の .claude ディレクトリとホームディレクトリの ~/.claude を探索します。
 
+export const ClaudeExplorer = () => {
+  const A = useMemo(() => ({href, children}) => <a href={href} style={{
+    color: 'var(--ce-accent)',
+    textDecoration: 'none',
+    borderBottom: '1px dotted var(--ce-accent)'
+  }}>{children}</a>, []);
+  const C = useMemo(() => ({children}) => <code style={{
+    fontFamily: 'var(--ce-mono)',
+    fontSize: '0.92em',
+    padding: '1px 4px',
+    borderRadius: '3px',
+    background: 'var(--ce-surface)',
+    border: '0.5px solid var(--ce-border-subtle)'
+  }}>{children}</code>, []);
+  const commandsNote = useMemo(() => <>Commands and skills are now the same mechanism. For new workflows, use <A href="/en/skills">skills/</A> instead: same <C>/name</C> invocation, plus you can bundle supporting files.</>, []);
+  const FILE_TREE = useMemo(() => ({
+    project: {
+      label: 'your-project/',
+      children: [{
+        id: 'claude-md',
+        label: 'CLAUDE.md',
+        type: 'file',
+        icon: 'md',
```

</details>

<details>
<summary>claude-platform-on-aws-ja.md</summary>

```diff
diff --git a/docs-ja/pages/claude-platform-on-aws-ja.md b/docs-ja/pages/claude-platform-on-aws-ja.md
index ada8273..1c2ff61 100644
--- a/docs-ja/pages/claude-platform-on-aws-ja.md
+++ b/docs-ja/pages/claude-platform-on-aws-ja.md
@@ -7,4 +7,186 @@
 > AWS 認証、IAM アクセス制御、AWS Marketplace 請求を使用して、Anthropic が運営する Claude API を使用するように Claude Code を設定します。
 
+export const ContactSalesCard = ({surface}) => {
+  const utm = content => `utm_source=claude_code&utm_medium=docs&utm_content=${surface}_${content}`;
+  const iconArrowRight = (size = 13) => <svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">
+      <line x1="5" y1="12" x2="19" y2="12" />
+      <polyline points="12 5 19 12 12 19" />
+    </svg>;
+  const STYLES = `
+.cc-cs {
+  --cs-slate: #141413;
+  --cs-clay: #d97757;
+  --cs-clay-deep: #c6613f;
+  --cs-gray-000: #ffffff;
+  --cs-gray-700: #3d3d3a;
+  --cs-border-default: rgba(31, 30, 29, 0.15);
+  font-family: inherit;
+}
+.dark .cc-cs {
+  --cs-slate: #f0eee6;
+  --cs-gray-000: #262624;
+  --cs-gray-700: #bfbdb4;
+  --cs-border-default: rgba(240, 238, 230, 0.14);
+}
+.cc-cs-card {
```

</details>

<details>
<summary>context-window-ja.md</summary>

```diff
diff --git a/docs-ja/pages/context-window-ja.md b/docs-ja/pages/context-window-ja.md
index 17cb163..04ca98c 100644
--- a/docs-ja/pages/context-window-ja.md
+++ b/docs-ja/pages/context-window-ja.md
@@ -7,6 +7,1570 @@
 > Claude Code のコンテキストウィンドウがセッション中にどのように満たされるかのインタラクティブなシミュレーション。自動的に読み込まれるもの、各ファイル読み込みのコスト、ルールとフックが発火するタイミングを確認できます。
 
+export const ContextWindow = () => {
+  const MAX = 200000;
+  const STARTUP_END = 0.2;
+  {}
+  const EVENTS = useMemo(() => [{}, {
+    t: 0.015,
+    kind: 'auto',
+    label: 'System prompt',
+    tokens: 4200,
+    color: '#6B6964',
+    vis: 'hidden',
+    desc: 'Core instructions for behavior, tool use, and response formatting. Always loaded first. You never see it.',
+    link: null
+  }, {
+    t: 0.035,
+    kind: 'auto',
+    label: 'Auto memory (MEMORY.md)',
+    tokens: 680,
+    color: '#E8A45C',
+    vis: 'hidden',
+    desc: "Claude's notes to itself from previous sessions: build commands it learned, patterns it noticed, mistakes to avoid. The first 200 lines or 25KB, whichever comes first, are loaded into the conversation context.",
+    link: '/en/memory#auto-memory'
+  }, {
```

</details>

<details>
<summary>google-vertex-ai-ja.md</summary>

```diff
diff --git a/docs-ja/pages/google-vertex-ai-ja.md b/docs-ja/pages/google-vertex-ai-ja.md
index 2575a95..608eab8 100644
--- a/docs-ja/pages/google-vertex-ai-ja.md
+++ b/docs-ja/pages/google-vertex-ai-ja.md
@@ -7,4 +7,76 @@
 > Google Vertex AI を通じた Claude Code の設定方法について学びます。セットアップ、IAM 設定、トラブルシューティングを含みます。
 
+export const ContactSalesCard = ({surface}) => {
+  const utm = content => `utm_source=claude_code&utm_medium=docs&utm_content=${surface}_${content}`;
+  const iconArrowRight = (size = 13) => <svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">
+      <line x1="5" y1="12" x2="19" y2="12" />
+      <polyline points="12 5 19 12 12 19" />
+    </svg>;
+  const STYLES = `
+.cc-cs {
+  --cs-slate: #141413;
+  --cs-clay: #d97757;
+  --cs-clay-deep: #c6613f;
+  --cs-gray-000: #ffffff;
+  --cs-gray-700: #3d3d3a;
+  --cs-border-default: rgba(31, 30, 29, 0.15);
+  font-family: inherit;
+}
+.dark .cc-cs {
+  --cs-slate: #f0eee6;
+  --cs-gray-000: #262624;
+  --cs-gray-700: #bfbdb4;
+  --cs-border-default: rgba(240, 238, 230, 0.14);
+}
+.cc-cs-card {
```

</details>

*...以降省略*

</details>


<details>
<summary>2026-06-11</summary>

**変更ファイル:**

```
 docs-ja/pages/amazon-bedrock-ja.md           |   72 --
 docs-ja/pages/changelog.md                   |   33 +
 docs-ja/pages/claude-directory-ja.md         | 1426 -----------------------
 docs-ja/pages/claude-platform-on-aws-ja.md   |  182 ---
 docs-ja/pages/context-window-ja.md           | 1564 --------------------------
 docs-ja/pages/google-vertex-ai-ja.md         |   72 --
 docs-ja/pages/microsoft-foundry-ja.md        |   72 --
 docs-ja/pages/prompt-library-ja.md           | 1319 ----------------------
 docs-ja/pages/third-party-integrations-ja.md |   72 --
 9 files changed, 33 insertions(+), 4779 deletions(-)
```

<details>
<summary>amazon-bedrock-ja.md</summary>

```diff
diff --git a/docs-ja/pages/amazon-bedrock-ja.md b/docs-ja/pages/amazon-bedrock-ja.md
index c411db1..6eac9dc 100644
--- a/docs-ja/pages/amazon-bedrock-ja.md
+++ b/docs-ja/pages/amazon-bedrock-ja.md
@@ -7,76 +7,4 @@
 > Amazon Bedrock を通じた Claude Code の設定方法（セットアップ、IAM 設定、トラブルシューティングを含む）について学習します。
 
-export const ContactSalesCard = ({surface}) => {
-  const utm = content => `utm_source=claude_code&utm_medium=docs&utm_content=${surface}_${content}`;
-  const iconArrowRight = (size = 13) => <svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">
-      <line x1="5" y1="12" x2="19" y2="12" />
-      <polyline points="12 5 19 12 12 19" />
-    </svg>;
-  const STYLES = `
-.cc-cs {
-  --cs-slate: #141413;
-  --cs-clay: #d97757;
-  --cs-clay-deep: #c6613f;
-  --cs-gray-000: #ffffff;
-  --cs-gray-700: #3d3d3a;
-  --cs-border-default: rgba(31, 30, 29, 0.15);
-  font-family: inherit;
-}
-.dark .cc-cs {
-  --cs-slate: #f0eee6;
-  --cs-gray-000: #262624;
-  --cs-gray-700: #bfbdb4;
-  --cs-border-default: rgba(240, 238, 230, 0.14);
-}
-.cc-cs-card {
```

</details>

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index 5b4fcd8..f1d4f8d 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,37 @@
 # Changelog
 
+## 2.1.172
+
+- Sub-agents can now spawn their own sub-agents (up to 5 levels deep)
+- Amazon Bedrock now reads the AWS region from `~/.aws` config files when `AWS_REGION` isn't set, matching AWS SDK precedence; `/status` shows where the region came from
+- Added a search bar when browsing a marketplace's plugins in `/plugin`
+- Added `model` attribute to the `claude_code.lines_of_code.count` OTEL metric
+- Fixed sessions using 1M context without usage credits getting permanently stuck — the session now automatically compacts back under the standard context limit
+- Fixed a repeating "an image in the conversation could not be processed and was removed" error when the conversation contained multiple images
+- Fixed the agents view keeping a session under Working with a busy spinner for up to 30 seconds after the worker replied
+- Fixed background agents potentially reading another directory's project settings (`.mcp.json` approvals, trust) when dispatched onto a pre-warmed worker
+- Fixed background-session attach failing with EAUTH for sessions started on an older version after the daemon auto-updated
+- Fixed a background sub-agent staying stuck as "active" in the agent panel after a nested agent it spawned was stopped
+- Fixed `/model` suggestions in the `claude agents` dispatch input rendering with a misleading slash prefix and showing models disabled for your org
+- Fixed `availableModels` restrictions not being applied to subagent model overrides, the agent dispatch model picker, and the advisor model
+- Fixed `availableModels` allowlists hiding the `/model` picker's Opus and Sonnet 1M rows when entries use version-specific IDs like `claude-opus-4-8`
+- Fixed the `/model` picker on Bedrock offering models the provider doesn't serve — selecting one silently switched the session model and lit the selection marker on multiple rows
+- Fixed model IDs getting a doubled 1M-context suffix (e.g. `[1M][1m]`) when `ANTHROPIC_DEFAULT_OPUS_MODEL` already includes one
+- Fixed `opusplan` model setting not shipping with 1M context in plan mode for entitled users; the `opusplan[1m]` workaround now also correctly switches to Opus in plan mode
+- Fixed `WebFetch(domain:*.example.com)` wildcard domain rules never matching subdomains in allow, deny, and ask position, and file permission rules with mid-pattern wildcards (e.g. `Read(secrets-*/config.json)`) being rejected at startup
+- Fixed up-arrow prompt history showing the main agent's prompts while a subagent's chat tab is open
+- Fixed memory recall not finding mounted team memory stores (`CLAUDE_MEMORY_STORES`) in remote sessions
+- Fixed workflow validation rejecting scripts whose prompt strings or comments merely mention `Date.now()`/`Math.random()`
+- Disable mouse tracking on Windows consoles that don't fully support it
```

</details>

<details>
<summary>claude-directory-ja.md</summary>

```diff
diff --git a/docs-ja/pages/claude-directory-ja.md b/docs-ja/pages/claude-directory-ja.md
index 467b49d..0ab4439 100644
--- a/docs-ja/pages/claude-directory-ja.md
+++ b/docs-ja/pages/claude-directory-ja.md
@@ -7,1428 +7,4 @@
 > Claude Code が CLAUDE.md、settings.json、hooks、skills、commands、subagents、workflows、rules、auto memory を読み込む場所。プロジェクト内の .claude ディレクトリとホームディレクトリの ~/.claude を探索します。
 
-export const ClaudeExplorer = () => {
-  const A = useMemo(() => ({href, children}) => <a href={href} style={{
-    color: 'var(--ce-accent)',
-    textDecoration: 'none',
-    borderBottom: '1px dotted var(--ce-accent)'
-  }}>{children}</a>, []);
-  const C = useMemo(() => ({children}) => <code style={{
-    fontFamily: 'var(--ce-mono)',
-    fontSize: '0.92em',
-    padding: '1px 4px',
-    borderRadius: '3px',
-    background: 'var(--ce-surface)',
-    border: '0.5px solid var(--ce-border-subtle)'
-  }}>{children}</code>, []);
-  const commandsNote = useMemo(() => <>Commands and skills are now the same mechanism. For new workflows, use <A href="/en/skills">skills/</A> instead: same <C>/name</C> invocation, plus you can bundle supporting files.</>, []);
-  const FILE_TREE = useMemo(() => ({
-    project: {
-      label: 'your-project/',
-      children: [{
-        id: 'claude-md',
-        label: 'CLAUDE.md',
-        type: 'file',
-        icon: 'md',
```

</details>

<details>
<summary>claude-platform-on-aws-ja.md</summary>

```diff
diff --git a/docs-ja/pages/claude-platform-on-aws-ja.md b/docs-ja/pages/claude-platform-on-aws-ja.md
index 1c2ff61..ada8273 100644
--- a/docs-ja/pages/claude-platform-on-aws-ja.md
+++ b/docs-ja/pages/claude-platform-on-aws-ja.md
@@ -7,186 +7,4 @@
 > AWS 認証、IAM アクセス制御、AWS Marketplace 請求を使用して、Anthropic が運営する Claude API を使用するように Claude Code を設定します。
 
-export const ContactSalesCard = ({surface}) => {
-  const utm = content => `utm_source=claude_code&utm_medium=docs&utm_content=${surface}_${content}`;
-  const iconArrowRight = (size = 13) => <svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">
-      <line x1="5" y1="12" x2="19" y2="12" />
-      <polyline points="12 5 19 12 12 19" />
-    </svg>;
-  const STYLES = `
-.cc-cs {
-  --cs-slate: #141413;
-  --cs-clay: #d97757;
-  --cs-clay-deep: #c6613f;
-  --cs-gray-000: #ffffff;
-  --cs-gray-700: #3d3d3a;
-  --cs-border-default: rgba(31, 30, 29, 0.15);
-  font-family: inherit;
-}
-.dark .cc-cs {
-  --cs-slate: #f0eee6;
-  --cs-gray-000: #262624;
-  --cs-gray-700: #bfbdb4;
-  --cs-border-default: rgba(240, 238, 230, 0.14);
-}
-.cc-cs-card {
```

</details>

<details>
<summary>context-window-ja.md</summary>

```diff
diff --git a/docs-ja/pages/context-window-ja.md b/docs-ja/pages/context-window-ja.md
index 04ca98c..17cb163 100644
--- a/docs-ja/pages/context-window-ja.md
+++ b/docs-ja/pages/context-window-ja.md
@@ -7,1570 +7,6 @@
 > Claude Code のコンテキストウィンドウがセッション中にどのように満たされるかのインタラクティブなシミュレーション。自動的に読み込まれるもの、各ファイル読み込みのコスト、ルールとフックが発火するタイミングを確認できます。
 
-export const ContextWindow = () => {
-  const MAX = 200000;
-  const STARTUP_END = 0.2;
-  {}
-  const EVENTS = useMemo(() => [{}, {
-    t: 0.015,
-    kind: 'auto',
-    label: 'System prompt',
-    tokens: 4200,
-    color: '#6B6964',
-    vis: 'hidden',
-    desc: 'Core instructions for behavior, tool use, and response formatting. Always loaded first. You never see it.',
-    link: null
-  }, {
-    t: 0.035,
-    kind: 'auto',
-    label: 'Auto memory (MEMORY.md)',
-    tokens: 680,
-    color: '#E8A45C',
-    vis: 'hidden',
-    desc: "Claude's notes to itself from previous sessions: build commands it learned, patterns it noticed, mistakes to avoid. The first 200 lines or 25KB, whichever comes first, are loaded into the conversation context.",
-    link: '/en/memory#auto-memory'
-  }, {
```

</details>

<details>
<summary>google-vertex-ai-ja.md</summary>

```diff
diff --git a/docs-ja/pages/google-vertex-ai-ja.md b/docs-ja/pages/google-vertex-ai-ja.md
index 608eab8..2575a95 100644
--- a/docs-ja/pages/google-vertex-ai-ja.md
+++ b/docs-ja/pages/google-vertex-ai-ja.md
@@ -7,76 +7,4 @@
 > Google Vertex AI を通じた Claude Code の設定方法について学びます。セットアップ、IAM 設定、トラブルシューティングを含みます。
 
-export const ContactSalesCard = ({surface}) => {
-  const utm = content => `utm_source=claude_code&utm_medium=docs&utm_content=${surface}_${content}`;
-  const iconArrowRight = (size = 13) => <svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">
-      <line x1="5" y1="12" x2="19" y2="12" />
-      <polyline points="12 5 19 12 12 19" />
-    </svg>;
-  const STYLES = `
-.cc-cs {
-  --cs-slate: #141413;
-  --cs-clay: #d97757;
-  --cs-clay-deep: #c6613f;
-  --cs-gray-000: #ffffff;
-  --cs-gray-700: #3d3d3a;
-  --cs-border-default: rgba(31, 30, 29, 0.15);
-  font-family: inherit;
-}
-.dark .cc-cs {
-  --cs-slate: #f0eee6;
-  --cs-gray-000: #262624;
-  --cs-gray-700: #bfbdb4;
-  --cs-border-default: rgba(240, 238, 230, 0.14);
-}
-.cc-cs-card {
```

</details>

*...以降省略*

</details>


<details>
<summary>2026-06-10</summary>

**変更ファイル:**

```
 docs-ja/pages/agent-view-ja.md               | 148 +++++--
 docs-ja/pages/agents-ja.md                   |  12 +-
 docs-ja/pages/analytics-ja.md                |  88 +++--
 docs-ja/pages/authentication-ja.md           |  32 +-
 docs-ja/pages/auto-mode-config-ja.md         |  24 +-
 docs-ja/pages/best-practices-ja.md           | 124 ++++--
 docs-ja/pages/champion-kit-ja.md             |  64 ++-
 docs-ja/pages/changelog.md                   |   6 +
 docs-ja/pages/channels-ja.md                 |  36 +-
 docs-ja/pages/channels-reference-ja.md       |  60 ++-
 docs-ja/pages/checkpointing-ja.md            |  40 +-
 docs-ja/pages/chrome-ja.md                   |  80 +++-
 docs-ja/pages/claude-code-on-the-web-ja.md   | 172 ++++++--
 docs-ja/pages/claude-directory-ja.md         |  44 ++-
 docs-ja/pages/claude-platform-on-aws-ja.md   |  48 ++-
 docs-ja/pages/cli-reference-ja.md            |  16 +-
 docs-ja/pages/common-workflows-ja.md         |  84 +++-
 docs-ja/pages/communications-kit-ja.md       |  72 +++-
 docs-ja/pages/costs-ja.md                    |  76 +++-
 docs-ja/pages/data-usage-ja.md               |  48 ++-
 docs-ja/pages/debug-your-config-ja.md        |  28 +-
 docs-ja/pages/deep-links-ja.md               |  60 ++-
 docs-ja/pages/desktop-ja.md                  | 268 +++++++++----
 docs-ja/pages/desktop-quickstart-ja.md       |  20 +-
 docs-ja/pages/desktop-scheduled-tasks-ja.md  |  32 +-
 docs-ja/pages/devcontainer-ja.md             |  28 +-
 docs-ja/pages/env-vars-ja.md                 |  24 +-
 docs-ja/pages/fast-mode-ja.md                |  40 +-
 docs-ja/pages/features-overview-ja.md        |  40 +-
 docs-ja/pages/fullscreen-ja.md               |  48 ++-
 docs-ja/pages/github-enterprise-server-ja.md |  64 ++-
 docs-ja/pages/glossary-ja.md                 | 236 ++++++++---
 docs-ja/pages/goal-ja.md                     |  44 ++-
 docs-ja/pages/google-vertex-ai-ja.md         |  60 ++-
 docs-ja/pages/headless-ja.md                 |  48 ++-
 docs-ja/pages/hooks-guide-ja.md              | 124 ++++--
 docs-ja/pages/hooks-ja.md                    | 564 ++++++++++++++++++++-------
 docs-ja/pages/how-claude-code-works-ja.md    | 100 +++--
 docs-ja/pages/interactive-mode-ja.md         | 104 +++--
 docs-ja/pages/keybindings-ja.md              | 144 +++++--
 docs-ja/pages/large-codebases-ja.md          |  80 +++-
 docs-ja/pages/legal-and-compliance-ja.md     |  44 ++-
 docs-ja/pages/llm-gateway-ja.md              |  64 ++-
 docs-ja/pages/managed-mcp-ja.md              |  60 ++-
 docs-ja/pages/mcp-quickstart-ja.md           |  56 ++-
 docs-ja/pages/microsoft-foundry-ja.md        |  40 +-
 docs-ja/pages/model-config-ja.md             | 100 +++--
 docs-ja/pages/monitoring-usage-ja.md         | 280 +++++++++----
 docs-ja/pages/network-config-ja.md           |  32 +-
 docs-ja/pages/output-styles-ja.md            |  28 +-
 docs-ja/pages/overview-ja.md                 |  16 +-
 docs-ja/pages/permission-modes-ja.md         |  60 ++-
 docs-ja/pages/permissions-ja.md              | 104 +++--
 docs-ja/pages/platforms-ja.md                |  28 +-
 docs-ja/pages/plugin-dependencies-ja.md      |  36 +-
 docs-ja/pages/plugin-hints-ja.md             |  32 +-
 docs-ja/pages/plugin-marketplaces-ja.md      | 196 +++++++---
 docs-ja/pages/plugins-ja.md                  |  88 +++--
 docs-ja/pages/plugins-reference-ja.md        | 208 +++++++---
 docs-ja/pages/prompt-caching-ja.md           | 112 ++++--
 docs-ja/pages/prompt-library-ja.md           |  12 +-
 docs-ja/pages/quickstart-ja.md               |  52 ++-
 docs-ja/pages/routines-ja.md                 | 100 +++--
 docs-ja/pages/sandbox-environments-ja.md     |  44 ++-
 docs-ja/pages/sandboxing-ja.md               |  84 +++-
 docs-ja/pages/scheduled-tasks-ja.md          |  60 ++-
 docs-ja/pages/security-guidance-ja.md        |  72 +++-
 docs-ja/pages/security-ja.md                 |  68 +++-
 docs-ja/pages/server-managed-settings-ja.md  |  64 ++-
 docs-ja/pages/sessions-ja.md                 |  32 +-
 docs-ja/pages/settings-ja.md                 | 136 +++++--
 docs-ja/pages/setup-ja.md                    | 108 +++--
 docs-ja/pages/skills-ja.md                   | 124 ++++--
 docs-ja/pages/slack-ja.md                    | 108 +++--
 docs-ja/pages/sub-agents-ja.md               | 176 ++++++---
 docs-ja/pages/terminal-config-ja.md          |  72 +++-
 docs-ja/pages/third-party-integrations-ja.md |  52 ++-
 docs-ja/pages/tools-reference-ja.md          |  76 +++-
 docs-ja/pages/troubleshoot-install-ja.md     | 144 +++++--
 docs-ja/pages/troubleshooting-ja.md          |  32 +-
 docs-ja/pages/ultraplan-ja.md                |  24 +-
 docs-ja/pages/ultrareview-ja.md              |  24 +-
 docs-ja/pages/voice-dictation-ja.md          |  36 +-
 docs-ja/pages/web-quickstart-ja.md           |  68 +++-
 docs-ja/pages/workflows-ja.md                |  68 +++-
 docs-ja/pages/worktrees-ja.md                |  32 +-
 docs-ja/pages/zero-data-retention-ja.md      |  24 +-
 87 files changed, 5181 insertions(+), 1725 deletions(-)
```

**新規追加:**


<details>
<summary>agent-view-ja.md</summary>

```diff
diff --git a/docs-ja/pages/agent-view-ja.md b/docs-ja/pages/agent-view-ja.md
index 0e8451a..c57f9c8 100644
--- a/docs-ja/pages/agent-view-ja.md
+++ b/docs-ja/pages/agent-view-ja.md
@@ -31,5 +31,7 @@ Claude が複数の独立したタスクに対して、あなたが毎ステッ
 * [バックグラウンドセッションがどのようにホストされるか](#how-background-sessions-are-hosted)。スーパーバイザープロセスによって
 
-## クイックスタート
+<h2 id="quick-start">
+  クイックスタート
+</h2>
 
 このチュートリアルでは、コアエージェントビューループについて説明します。タスクをディスパッチし、Claude が作業する際に行が更新されるのを見守り、ピークして確認して返信し、フル会話にアタッチします。ディスパッチしたセッションはエージェントビューを閉じた後も実行し続けるため、離れて後で戻ることができます。
@@ -69,5 +71,7 @@ Claude が複数の独立したタスクに対して、あなたが毎ステッ
 `claude agents` を `claude` の代わりにプライマリエントリーポイントとして使用できます。エージェントビューからすべてのタスクをディスパッチし、フル会話が必要な場合はアタッチし、`←` を押してテーブルに戻ります。
 
-## エージェントビューでセッションを監視する
+<h2 id="monitor-sessions-with-agent-view">
+  エージェントビューでセッションを監視する
+</h2>
 
 `claude agents` を実行してエージェントビューを開きます。ターミナル全体を占有し、状態でグループ化されたすべてのセッションをリストします。ピン留めされたセッションと入力が必要なセッションが上部に表示されます。各行はセッションの名前、現在のアクティビティ、最後に変更されてからの経過時間を表示します。
@@ -103,5 +107,7 @@ Completed
 ```
 
-### セッション状態を読む
+<h3 id="read-session-state">
+  セッション状態を読む
+</h3>
 
```

</details>

<details>
<summary>agents-ja.md</summary>

```diff
diff --git a/docs-ja/pages/agents-ja.md b/docs-ja/pages/agents-ja.md
index 5984b05..4d18871 100644
--- a/docs-ja/pages/agents-ja.md
+++ b/docs-ja/pages/agents-ja.md
@@ -33,5 +33,7 @@
 </Note>
 
-## アプローチを選択する
+<h2 id="choose-an-approach">
+  アプローチを選択する
+</h2>
 
 適切なアプローチは、誰が作業を調整するか、ワーカーが通信する必要があるかどうか、および同じファイルを編集するかどうかによって異なります。
@@ -45,5 +47,7 @@
 * **タスクが同じファイルに触れるか？** [ワークツリー](/ja/worktrees)で作業を分離します。サブエージェントと自分で実行するセッションは、それぞれ個別のワークツリーを使用できます。エージェントチームはチームメイトをワークツリーで分離しないため、[作業を分割](/ja/agent-teams#avoid-file-conflicts)して、各チームメイトが異なるファイルセットを所有するようにします。
 
-## 実行中の作業を確認する
+<h2 id="check-on-running-work">
+  実行中の作業を確認する
+</h2>
 
 実行中の作業を確認するコマンドは、使用したアプローチによって異なります。
@@ -56,5 +60,7 @@
 すべてのセッションのデスクトップビューについては、[デスクトップアプリでのセッションの並列実行](/ja/desktop#work-in-parallel-with-sessions) を参照してください。
 
-## 詳細情報
+<h2 id="learn-more">
+  詳細情報
+</h2>
 
```

</details>

<details>
<summary>analytics-ja.md</summary>

```diff
diff --git a/docs-ja/pages/analytics-ja.md b/docs-ja/pages/analytics-ja.md
index 4c7149d..0d03426 100644
--- a/docs-ja/pages/analytics-ja.md
+++ b/docs-ja/pages/analytics-ja.md
@@ -14,5 +14,7 @@ Claude Code は、組織が開発者の使用パターンを理解し、貢献
 | API（Claude Console）           | [platform.claude.com/claude-code](https://platform.claude.com/claude-code) | 使用メトリクス、支出追跡、チームインサイト                         | [詳細](#access-analytics-for-api-customers)       |
 
-## Team と Enterprise の分析にアクセスする
+<h2 id="access-analytics-for-team-and-enterprise">
+  Team と Enterprise の分析にアクセスする
+</h2>
 
 [claude.ai/analytics/claude-code](https://claude.ai/analytics/claude-code) に移動してください。管理者とオーナーがダッシュボードを表示できます。
@@ -27,5 +29,7 @@ Team と Enterprise ダッシュボードには以下が含まれます。
 ユーザーごとのトークン数とコスト推定については、[OpenTelemetry エクスポート](/ja/monitoring-usage)を構成してください。
 
-### 貢献メトリクスを有効にする
+<h3 id="enable-contribution-metrics">
+  貢献メトリクスを有効にする
+</h3>
 
 <Note>
@@ -66,5 +70,7 @@ Team と Enterprise ダッシュボードには以下が含まれます。
 貢献メトリクスは GitHub Cloud と GitHub Enterprise Server をサポートしています。
 
-### サマリーメトリクスを確認する
+<h3 id="review-summary-metrics">
+  サマリーメトリクスを確認する
+</h3>
 
```

</details>

<details>
<summary>authentication-ja.md</summary>

```diff
diff --git a/docs-ja/pages/authentication-ja.md b/docs-ja/pages/authentication-ja.md
index e8c9bd5..d916202 100644
--- a/docs-ja/pages/authentication-ja.md
+++ b/docs-ja/pages/authentication-ja.md
@@ -9,5 +9,7 @@
 Claude Code は、セットアップに応じて複数の認証方法をサポートしています。個人ユーザーは Claude.ai アカウントでログインでき、チームは Claude for Teams または Enterprise、Claude Console、または Amazon Bedrock、Google Vertex AI、Microsoft Foundry などのクラウドプロバイダーを使用できます。
 
-## Claude Code にログインする
+<h2 id="log-in-to-claude-code">
+  Claude Code にログインする
+</h2>
 
 [Claude Code をインストール](/ja/setup#install-claude-code)した後、ターミナルで `claude` を実行します。初回起動時に、Claude Code はログインするためのブラウザウィンドウを開きます。
@@ -28,5 +30,7 @@ Claude Code は、セットアップに応じて複数の認証方法をサポ
 ログインに問題がある場合は、[認証のトラブルシューティング](/ja/troubleshoot-install#login-and-authentication)を参照してください。
 
-## チーム認証を設定する
+<h2 id="set-up-team-authentication">
+  チーム認証を設定する
+</h2>
 
 チームと組織の場合、Claude Code アクセスを以下のいずれかの方法で設定できます。
@@ -38,5 +42,7 @@ Claude Code は、セットアップに応じて複数の認証方法をサポ
 * [Microsoft Foundry](/ja/microsoft-foundry)
 
-### Claude for Teams または Enterprise
+<h3 id="claude-for-teams-or-enterprise">
+  Claude for Teams または Enterprise
+</h3>
 
```

</details>

<details>
<summary>auto-mode-config-ja.md</summary>

```diff
diff --git a/docs-ja/pages/auto-mode-config-ja.md b/docs-ja/pages/auto-mode-config-ja.md
index cc485a3..d63f4f7 100644
--- a/docs-ja/pages/auto-mode-config-ja.md
+++ b/docs-ja/pages/auto-mode-config-ja.md
@@ -25,5 +25,7 @@
 * [拒否を確認する](#review-denials)（次に何を追加するかを知るため）
 
-## 分類器が設定を読み込む場所
+<h2 id="where-the-classifier-reads-configuration">
+  分類器が設定を読み込む場所
+</h2>
 
 分類器は Claude 自体が読み込む同じ [CLAUDE.md](/ja/memory) コンテンツを読み込むため、プロジェクトの CLAUDE.md の「force push を絶対にしない」のような指示は、Claude と分類器の両方を同時に制御します。プロジェクト規約と動作ルールはここから始めてください。
@@ -46,5 +48,7 @@
 </Note>
 
-## 信頼できるインフラストラクチャを定義する
+<h2 id="define-trusted-infrastructure">
+  信頼できるインフラストラクチャを定義する
+</h2>
 
 ほとんどの組織では、`autoMode.environment` が設定する必要がある唯一のフィールドです。これは、分類器に、どのリポジトリ、バケット、ドメインが信頼できるかを指定します。分類器はこれを使用して「外部」が何を意味するかを決定するため、リストに記載されていない宛先は潜在的な流出ターゲットです。
@@ -98,5 +102,7 @@
 すべてを一度に入力する必要はありません。合理的なロールアウト。デフォルトから始めて、ソース管理組織と主要な内部サービスを追加します。これにより、独自のリポジトリへのプッシュなど、最も一般的な誤検知が解決されます。次に信頼できるドメインとクラウドバケットを追加します。ブロックが発生したら残りを入力します。
 
-## ブロックルールと許可ルールをオーバーライドする
+<h2 id="override-the-block-and-allow-rules">
+  ブロックルールと許可ルールをオーバーライドする
+</h2>
 
```

</details>

<details>
<summary>best-practices-ja.md</summary>

```diff
diff --git a/docs-ja/pages/best-practices-ja.md b/docs-ja/pages/best-practices-ja.md
index c480d8b..e548ab6 100644
--- a/docs-ja/pages/best-practices-ja.md
+++ b/docs-ja/pages/best-practices-ja.md
@@ -25,5 +25,7 @@ LLM のパフォーマンスはコンテキストが満杯になるにつれて
 ***
 
-## Claude に自分の作業を検証する方法を与える
+<h2 id="give-claude-a-way-to-verify-its-work">
+  Claude に自分の作業を検証する方法を与える
+</h2>
 
 <Tip>
@@ -54,5 +56,7 @@ Claude に成功を主張するのではなく、証拠を示すよう指示し
 ***
 
-## 最初に探索し、次に計画し、その後コーディングする
+<h2 id="explore-first-then-plan-then-code">
+  最初に探索し、次に計画し、その後コーディングする
+</h2>
 
 <Tip>
@@ -113,5 +117,7 @@ Claude が直接コーディングにジャンプさせると、間違った問
 ***
 
-## プロンプトで具体的なコンテキストを提供する
+<h2 id="provide-specific-context-in-your-prompts">
+  プロンプトで具体的なコンテキストを提供する
+</h2>
 
```

</details>

*...以降省略*

</details>


<details>
<summary>2026-06-09</summary>

**変更ファイル:**

```
 docs-ja/pages/changelog.md | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)
```

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index d840d7f..a52cc67 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,37 @@
 # Changelog
 
+## 2.1.169
+
+- Added `--safe-mode` flag (and `CLAUDE_CODE_SAFE_MODE`) to start Claude Code with all customizations (CLAUDE.md, plugins, skills, hooks, MCP servers) disabled for troubleshooting
+- Added `/cd` command to move a session to a new working directory without breaking the prompt cache mid-session
+- Added a `disableBundledSkills` setting and `CLAUDE_CODE_DISABLE_BUNDLED_SKILLS` environment variable to hide bundled skills, workflows, and built-in slash commands from the model
+- Fixed Up/Down arrows jumping to command history past the wrapped rows of a long input line — they now move through each visual row first, and history recall enters at the near edge
+- Fixed enterprise managed MCP policies (`allowedMcpServers`/`deniedMcpServers`) not being enforced on reconnect, IDE-typed configs, `--mcp-config` servers during the first session after install, or before remote settings loaded; also fixed slow cold starts for orgs without remote settings
+- Fixed a ~30-50ms UI stall at the start of each turn for macOS users logged in with claude.ai credentials
+- Fixed `claude -p` being slow or appearing to hang on Windows while waiting for the slash-command/skill scan (regression in 2.1.161)
+- Fixed Remote Control getting stuck on "reconnecting" after resuming a session when an OAuth token refresh happened at the same time
+- Fixed Git Credential Manager's "Connect to GitHub" popup appearing on Windows at startup when background git commands ran without cached credentials
+- Fixed footer hints (e.g. "esc to interrupt") not showing for users with a custom statusline
+- Fixed stale permission and dialog prompts reappearing every time you reattached to a remote session whose worker had died while waiting on them
+- Fixed `claude agents --json` omitting blocked and just-dispatched background sessions; added `--all` to include completed sessions, plus new `id` and `state` fields
+- Fixed agents view leaving a stale/garbled frame after navigating back from an agent on WSL in Windows Terminal
+- Fixed background agents ignoring project-level settings `env` values (e.g. `ANTHROPIC_MODEL`) when dispatched onto a pre-warmed worker
+- Fixed MCPB plugin cache being spuriously invalidated on Windows, causing unnecessary re-extraction
+- Fixed plugin `.in_use` PID lock files accumulating without bound; stale markers from crashed sessions are now swept once per day
+- Fixed untrusted project settings being able to set OTEL client-certificate paths without trust confirmation
+- `/workflows` now opens immediately even while a turn is in progress
+- Improved `TaskCreate` reliability: malformed inputs are repaired automatically and validation errors for unloaded tools include the schema
+- Improved the error message shown when your organization has disabled API key authentication, with guidance based on where the active API key comes from
+- Reduced CPU usage while responses stream and during spinner animations
```

</details>

</details>


<details>
<summary>2026-06-07</summary>

**変更ファイル:**

```
 docs-ja/pages/changelog.md | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)
```

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index b475a37..d840d7f 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,36 @@
 # Changelog
 
+## 2.1.168
+
+- Bug fixes and reliability improvements
+
+## 2.1.167
+
+- Bug fixes and reliability improvements
+
+## 2.1.166
+
+- Added `fallbackModel` setting to configure up to three fallback models tried in order when the primary model is overloaded or unavailable; `--fallback-model` now also applies to interactive sessions
+- Added glob pattern support in deny rule tool-name position (`"*"` denies all tools); allow rules reject non-MCP globs, and unknown tool names in deny rules warn at startup
+- Hardened cross-session messaging: messages relayed via `SendMessage` from other Claude sessions no longer carry user authority — receivers refuse relayed permission requests, and auto mode blocks them
+- `MAX_THINKING_TOKENS=0`, `--thinking disabled`, and the per-model thinking toggle now disable thinking on models that think by default via the Claude API (3P providers unchanged)
+- Claude Code now retries a turn once on the fallback model when the API rejects an unexpected non-retryable error; auth, rate-limit, request-size, and transport errors still surface immediately
+- `claude update` now announces the target version before downloading instead of going silent
+- `claude agents`: typing a URL into the list now filters to the session whose first prompt contained it
+- Fixed a recurring "image could not be processed" error and extra token usage when an unprocessable image was sent in a session
+- Fixed remote sessions becoming permanently stuck when a brief backend disruption occurred during worker registration at startup
+- Fixed flickering in JetBrains IDE terminals (IntelliJ, PyCharm, WebStorm, etc.) on 2026.1+ by enabling synchronized output
+- Fixed Shift+non-ASCII characters (e.g. Shift+ä → Ä) being dropped in terminals using the Kitty keyboard protocol (WezTerm, Ghostty, kitty)
+- Fixed PowerShell command validation occasionally hanging far past its time budget on Windows when a killed process's children held its output pipes
+- Fixed orphaned `claude --bg-pty-host` processes spinning at 100% CPU after the daemon dies while connected on macOS
```

</details>

</details>


<details>
<summary>2026-06-06</summary>

**変更ファイル:**

```
 docs-ja/pages/changelog.md | 4 ++++
 1 file changed, 4 insertions(+)
```

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index f877eb7..b475a37 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,8 @@
 # Changelog
 
+## 2.1.165
+
+- Bug fixes and reliability improvements
+
 ## 2.1.163
 
```

</details>

</details>


<details>
<summary>2026-06-05</summary>

**変更ファイル:**

```
 docs-ja/pages/changelog.md             |  25 ++
 docs-ja/pages/channels-reference-ja.md | 782 +++++++++++++++++++++++++++++++--
 docs-ja/pages/troubleshooting-ja.md    | 150 +++++--
 3 files changed, 907 insertions(+), 50 deletions(-)
```

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index e02bb2e..f877eb7 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,29 @@
 # Changelog
 
+## 2.1.163
+
+- Added `requiredMinimumVersion` and `requiredMaximumVersion` managed settings — Claude Code refuses to start if its version is outside the allowed range and directs the user to an approved version
+- Added `/plugin list` command to list installed plugins, with `--enabled`/`--disabled` filters
+- Added a "c to copy" shortcut to `/btw` that copies the raw markdown answer to the clipboard, preserving formatting when pasted elsewhere
+- Hooks: Stop and SubagentStop hooks can now return `hookSpecificOutput.additionalContext` to give Claude feedback and keep the turn going without being labeled a hook error
+- Skills: added `\$` escape syntax to include a literal `$` before a digit in command bodies
+- stdio MCP servers now receive the same `CLAUDE_CODE_SESSION_ID` as hooks/Bash on `--resume`
+- Fixed `claude -p` hanging forever after its final result when a backgrounded command never exits — background shells are now stopped ~5s after the result once stdin closes
+- Fixed `claude -p` failing with "ANTHROPIC_API_KEY required" on Bedrock/Vertex/Foundry when `CI=true` and no Anthropic API key is set
+- Fixed bash commands failing under bazel and EDR-protected Go workflows: `$TMPDIR` was overridden to `/tmp/claude-{uid}` for all commands instead of only sandboxed ones (regression in 2.1.154)
+- Fixed Bash commands failing on Windows with "EEXIST: file already exists" on the session-env directory when it has the read-only attribute or is inside OneDrive
+- Fixed org-managed permission rules not applying for the entire session when the managed settings fetch completed during startup on a fresh config directory
+- Fixed background sessions in `claude agents` losing their running background tasks when reattached after a Claude Code update
+- Fixed terminal misalignment and a multi-second hang when exiting the agent view by pressing Esc
+- Fixed clicking Stop on a background-task chip in the desktop app not clearing the chip when the underlying process was already gone
+- Fixed keyboard input becoming permanently unresponsive after a paste operation whose end marker is dropped by the terminal
+- Fixed hook `if: "Bash(...)"` conditions firing on every Bash command containing `$()` or `$VAR`; the pattern now matches against commands inside subshells and backticks too
+- Fixed deny rules on home-directory paths (e.g. `Read(~/Desktop/**)`) not blocking Bash commands that reference the path via `$HOME`
+- Fixed a stray "(no content)" line left in the transcript after closing panel dialogs like /mcp and /plugins
+- Background agent sessions now update to a new Claude Code version in the background, so opening a session after an update no longer waits on a cold restart
+- Clearer descriptions for built-in commands and skills in the / menu
+- The subscription-switch suggestion now shows in the startup announcement slot instead of a toast
```

</details>

<details>
<summary>channels-reference-ja.md</summary>

```diff
diff --git a/docs-ja/pages/channels-reference-ja.md b/docs-ja/pages/channels-reference-ja.md
index 7d00277..d3e6664 100644
--- a/docs-ja/pages/channels-reference-ja.md
+++ b/docs-ja/pages/channels-reference-ja.md
@@ -1,25 +1,757 @@
-<!DOCTYPE html><html lang="en" class="dark"><head><meta charSet="utf-8" data-next-head=""/><meta name="viewport" content="width=device-width" data-next-head=""/><link rel="preload" href="/docs/_next/static/media/f67ad414ed34149c-s.p.84166d94.woff2" as="font" type="font/woff2" crossorigin="anonymous" data-next-font="size-adjust"/><link rel="preload" href="/docs/_next/static/media/83afe278b6a6bb3c-s.p.3a6ba036.woff2" as="font" type="font/woff2" crossorigin="anonymous" data-next-font="size-adjust"/><link rel="preload" href="/docs/_next/static/media/70bc3e132a0a741e-s.p.15008bfb.woff2" as="font" type="font/woff2" crossorigin="anonymous" data-next-font="size-adjust"/><link rel="preload" href="/docs/_next/static/chunks/a55e453750c2a7fa.css?dpl=dpl_BhwhCYBiuV3ekjQKzo1MLMxFFZrj" as="style"/><link rel="preload" href="/docs/_next/static/chunks/b652b64e1051c665.css?dpl=dpl_BhwhCYBiuV3ekjQKzo1MLMxFFZrj" as="style"/><link rel="stylesheet" href="/docs/_next/static/chunks/a55e453750c2a7fa.css?dpl=dpl_BhwhCYBiuV3ekjQKzo1MLMxFFZrj" data-n-g=""/><link rel="stylesheet" href="/docs/_next/static/chunks/b652b64e1051c665.css?dpl=dpl_BhwhCYBiuV3ekjQKzo1MLMxFFZrj" data-n-g=""/><noscript data-n-css=""></noscript><script defer="" noModule="" src="/docs/_next/static/chunks/a6dad97d9634a72d.js?dpl=dpl_BhwhCYBiuV3ekjQKzo1MLMxFFZrj"></script><script src="/docs/_next/static/chunks/43c19863fe36e93b.js?dpl=dpl_BhwhCYBiuV3ekjQKzo1MLMxFFZrj" defer=""></script><script src="/docs/_next/static/chunks/3c928de4ba7be83b.js?dpl=dpl_BhwhCYBiuV3ekjQKzo1MLMxFFZrj" defer=""></script><script src="/docs/_next/static/chunks/86fe569cdc737c49.js?dpl=dpl_BhwhCYBiuV3ekjQKzo1MLMxFFZrj" defer=""></script><script src="/docs/_next/static/chunks/turbopack-75fb6b56b8755fe3.js?dpl=dpl_BhwhCYBiuV3ekjQKzo1MLMxFFZrj" defer=""></script><script src="/docs/_next/static/chunks/fbb6cc5da66f86ca.js?dpl=dpl_BhwhCYBiuV3ekjQKzo1MLMxFFZrj" defer=""></script><script src="/docs/_next/static/chunks/c1fce75d7b81c8aa.js?dpl=dpl_BhwhCYBiuV3ekjQKzo1MLMxFFZrj" defer=""></script><script src="/docs/_next/static/chunks/45693c1bc90a75b9.js?dpl=dpl_BhwhCYBiuV3ekjQKzo1MLMxFFZrj" defer=""></script><script src="/docs/_next/static/chunks/c769afa446170645.js?dpl=dpl_BhwhCYBiuV3ekjQKzo1MLMxFFZrj" defer=""></script><script src="/docs/_next/static/chunks/26355f534f6eb1e7.js?dpl=dpl_BhwhCYBiuV3ekjQKzo1MLMxFFZrj" defer=""></script><script src="/docs/_next/static/chunks/d1708a2f7646f126.js?dpl=dpl_BhwhCYBiuV3ekjQKzo1MLMxFFZrj" defer=""></script><script src="/docs/_next/static/chunks/turbopack-7384b69b884e7e5a.js?dpl=dpl_BhwhCYBiuV3ekjQKzo1MLMxFFZrj" defer=""></script><script src="/docs/_next/static/ss5xJB33E-HAu6QQpydoa/_ssgManifest.js?dpl=dpl_BhwhCYBiuV3ekjQKzo1MLMxFFZrj" defer=""></script><script src="/docs/_next/static/ss5xJB33E-HAu6QQpydoa/_buildManifest.js?dpl=dpl_BhwhCYBiuV3ekjQKzo1MLMxFFZrj" defer=""></script></head><div id="__next"><main class="inter_8e83f138-module__et_h3a__variable jetbrains_mono_8f10fcc1-module__2Oizva__variable"><script>((e,i,s,u,m,a,l,h)=>{let d=document.documentElement,w=["light","dark"];function p(n){(Array.isArray(e)?e:[e]).forEach(y=>{let k=y==="class",S=k&&a?m.map(f=>a[f]||f):m;k?(d.classList.remove(...S),d.classList.add(a&&a[n]?a[n]:n)):d.setAttribute(y,n)}),R(n)}function R(n){h&&w.includes(n)&&(d.style.colorScheme=n)}function c(){return window.matchMedia("(prefers-color-scheme: dark)").matches?"dark":"light"}if(u)p(u);else try{let n=localStorage.getItem(i)||s,y=l&&n==="system"?c():n;p(y)}catch(n){}})("class","isDarkMode","system",null,["dark","light","true","false","system"],{"true":"dark","false":"light","dark":"dark","light":"light"},true,false)</script><style>:root {
-    --primary: 22 163 74;
-    --primary-light: 74 222 128;
-    --primary-dark: 22 101 52;
-    --tooltip-foreground: 255 255 255;
-    --background-light: 255 255 255;
-    --background-dark: 10 13 13;
-    --gray-50: 243 247 245;
-    --gray-100: 238 242 240;
-    --gray-200: 223 227 224;
-    --gray-300: 206 211 208;
-    --gray-400: 159 163 160;
-    --gray-500: 112 116 114;
-    --gray-600: 80 84 82;
-    --gray-700: 63 67 64;
-    --gray-800: 38 42 39;
-    --gray-900: 23 27 25;
-    --gray-950: 10 15 12;
-  }</style><style>:root {
-  --primary: 17 120 102;
-  --primary-light: 74 222 128;
-  --primary-dark: 22 101 52;
-  --background-light: 255 255 255;
-  --background-dark: 15 17 23;
-}</style><main class="h-screen bg-background-light dark:bg-background-dark text-left"><article class="bg-custom bg-fixed bg-center bg-cover relative flex flex-col items-center justify-center h-full"><div class="w-full max-w-xl px-10"><span class="inline-flex mb-6 rounded-full px-3 py-1 text-sm font-semibold mr-4 text-white p-1 bg-primary">Error <!-- -->500</span><h1 class="font-semibold mb-3 text-3xl">Page not found!</h1><p class="text-lg text-gray-600 dark:text-gray-400 mb-6">An unexpected error occurred. Please <a class="font-medium text-gray-700 dark:text-gray-100 border-b hover:border-b-[2px] border-primary-dark dark:border-primary-light" href="mailto:support@mintlify.com">contact support</a> to get help.</p></div></article></main></main></div><script id="__NEXT_DATA__" type="application/json">{"props":{"pageProps":{}},"page":"/500","query":{},"buildId":"ss5xJB33E-HAu6QQpydoa","assetPrefix":"/docs","nextExport":true,"autoExport":true,"isFallback":false,"scriptLoader":[]}</script></html>
```

</details>

<details>
<summary>troubleshooting-ja.md</summary>

```diff
diff --git a/docs-ja/pages/troubleshooting-ja.md b/docs-ja/pages/troubleshooting-ja.md
index 7d00277..b49f307 100644
--- a/docs-ja/pages/troubleshooting-ja.md
+++ b/docs-ja/pages/troubleshooting-ja.md
@@ -1,25 +1,125 @@
-<!DOCTYPE html><html lang="en" class="dark"><head><meta charSet="utf-8" data-next-head=""/><meta name="viewport" content="width=device-width" data-next-head=""/><link rel="preload" href="/docs/_next/static/media/f67ad414ed34149c-s.p.84166d94.woff2" as="font" type="font/woff2" crossorigin="anonymous" data-next-font="size-adjust"/><link rel="preload" href="/docs/_next/static/media/83afe278b6a6bb3c-s.p.3a6ba036.woff2" as="font" type="font/woff2" crossorigin="anonymous" data-next-font="size-adjust"/><link rel="preload" href="/docs/_next/static/media/70bc3e132a0a741e-s.p.15008bfb.woff2" as="font" type="font/woff2" crossorigin="anonymous" data-next-font="size-adjust"/><link rel="preload" href="/docs/_next/static/chunks/a55e453750c2a7fa.css?dpl=dpl_BhwhCYBiuV3ekjQKzo1MLMxFFZrj" as="style"/><link rel="preload" href="/docs/_next/static/chunks/b652b64e1051c665.css?dpl=dpl_BhwhCYBiuV3ekjQKzo1MLMxFFZrj" as="style"/><link rel="stylesheet" href="/docs/_next/static/chunks/a55e453750c2a7fa.css?dpl=dpl_BhwhCYBiuV3ekjQKzo1MLMxFFZrj" data-n-g=""/><link rel="stylesheet" href="/docs/_next/static/chunks/b652b64e1051c665.css?dpl=dpl_BhwhCYBiuV3ekjQKzo1MLMxFFZrj" data-n-g=""/><noscript data-n-css=""></noscript><script defer="" noModule="" src="/docs/_next/static/chunks/a6dad97d9634a72d.js?dpl=dpl_BhwhCYBiuV3ekjQKzo1MLMxFFZrj"></script><script src="/docs/_next/static/chunks/43c19863fe36e93b.js?dpl=dpl_BhwhCYBiuV3ekjQKzo1MLMxFFZrj" defer=""></script><script src="/docs/_next/static/chunks/3c928de4ba7be83b.js?dpl=dpl_BhwhCYBiuV3ekjQKzo1MLMxFFZrj" defer=""></script><script src="/docs/_next/static/chunks/86fe569cdc737c49.js?dpl=dpl_BhwhCYBiuV3ekjQKzo1MLMxFFZrj" defer=""></script><script src="/docs/_next/static/chunks/turbopack-75fb6b56b8755fe3.js?dpl=dpl_BhwhCYBiuV3ekjQKzo1MLMxFFZrj" defer=""></script><script src="/docs/_next/static/chunks/fbb6cc5da66f86ca.js?dpl=dpl_BhwhCYBiuV3ekjQKzo1MLMxFFZrj" defer=""></script><script src="/docs/_next/static/chunks/c1fce75d7b81c8aa.js?dpl=dpl_BhwhCYBiuV3ekjQKzo1MLMxFFZrj" defer=""></script><script src="/docs/_next/static/chunks/45693c1bc90a75b9.js?dpl=dpl_BhwhCYBiuV3ekjQKzo1MLMxFFZrj" defer=""></script><script src="/docs/_next/static/chunks/c769afa446170645.js?dpl=dpl_BhwhCYBiuV3ekjQKzo1MLMxFFZrj" defer=""></script><script src="/docs/_next/static/chunks/26355f534f6eb1e7.js?dpl=dpl_BhwhCYBiuV3ekjQKzo1MLMxFFZrj" defer=""></script><script src="/docs/_next/static/chunks/d1708a2f7646f126.js?dpl=dpl_BhwhCYBiuV3ekjQKzo1MLMxFFZrj" defer=""></script><script src="/docs/_next/static/chunks/turbopack-7384b69b884e7e5a.js?dpl=dpl_BhwhCYBiuV3ekjQKzo1MLMxFFZrj" defer=""></script><script src="/docs/_next/static/ss5xJB33E-HAu6QQpydoa/_ssgManifest.js?dpl=dpl_BhwhCYBiuV3ekjQKzo1MLMxFFZrj" defer=""></script><script src="/docs/_next/static/ss5xJB33E-HAu6QQpydoa/_buildManifest.js?dpl=dpl_BhwhCYBiuV3ekjQKzo1MLMxFFZrj" defer=""></script></head><div id="__next"><main class="inter_8e83f138-module__et_h3a__variable jetbrains_mono_8f10fcc1-module__2Oizva__variable"><script>((e,i,s,u,m,a,l,h)=>{let d=document.documentElement,w=["light","dark"];function p(n){(Array.isArray(e)?e:[e]).forEach(y=>{let k=y==="class",S=k&&a?m.map(f=>a[f]||f):m;k?(d.classList.remove(...S),d.classList.add(a&&a[n]?a[n]:n)):d.setAttribute(y,n)}),R(n)}function R(n){h&&w.includes(n)&&(d.style.colorScheme=n)}function c(){return window.matchMedia("(prefers-color-scheme: dark)").matches?"dark":"light"}if(u)p(u);else try{let n=localStorage.getItem(i)||s,y=l&&n==="system"?c():n;p(y)}catch(n){}})("class","isDarkMode","system",null,["dark","light","true","false","system"],{"true":"dark","false":"light","dark":"dark","light":"light"},true,false)</script><style>:root {
-    --primary: 22 163 74;
-    --primary-light: 74 222 128;
-    --primary-dark: 22 101 52;
-    --tooltip-foreground: 255 255 255;
-    --background-light: 255 255 255;
-    --background-dark: 10 13 13;
-    --gray-50: 243 247 245;
-    --gray-100: 238 242 240;
-    --gray-200: 223 227 224;
-    --gray-300: 206 211 208;
-    --gray-400: 159 163 160;
-    --gray-500: 112 116 114;
-    --gray-600: 80 84 82;
-    --gray-700: 63 67 64;
-    --gray-800: 38 42 39;
-    --gray-900: 23 27 25;
-    --gray-950: 10 15 12;
-  }</style><style>:root {
-  --primary: 17 120 102;
-  --primary-light: 74 222 128;
-  --primary-dark: 22 101 52;
-  --background-light: 255 255 255;
-  --background-dark: 15 17 23;
-}</style><main class="h-screen bg-background-light dark:bg-background-dark text-left"><article class="bg-custom bg-fixed bg-center bg-cover relative flex flex-col items-center justify-center h-full"><div class="w-full max-w-xl px-10"><span class="inline-flex mb-6 rounded-full px-3 py-1 text-sm font-semibold mr-4 text-white p-1 bg-primary">Error <!-- -->500</span><h1 class="font-semibold mb-3 text-3xl">Page not found!</h1><p class="text-lg text-gray-600 dark:text-gray-400 mb-6">An unexpected error occurred. Please <a class="font-medium text-gray-700 dark:text-gray-100 border-b hover:border-b-[2px] border-primary-dark dark:border-primary-light" href="mailto:support@mintlify.com">contact support</a> to get help.</p></div></article></main></main></div><script id="__NEXT_DATA__" type="application/json">{"props":{"pageProps":{}},"page":"/500","query":{},"buildId":"ss5xJB33E-HAu6QQpydoa","assetPrefix":"/docs","nextExport":true,"autoExport":true,"isFallback":false,"scriptLoader":[]}</script></html>
```

</details>

</details>


<details>
<summary>2026-06-04</summary>

**変更ファイル:**

```
 docs-ja/pages/amazon-bedrock-ja.md     |   1 +
 docs-ja/pages/changelog.md             |  31 ++
 docs-ja/pages/channels-reference-ja.md | 782 ++-------------------------------
 docs-ja/pages/chrome-ja.md             |   4 +-
 docs-ja/pages/claude-directory-ja.md   |   2 +-
 docs-ja/pages/env-vars-ja.md           |  15 +-
 docs-ja/pages/fast-mode-ja.md          |   2 +-
 docs-ja/pages/headless-ja.md           |  22 +-
 docs-ja/pages/hooks-guide-ja.md        |  36 +-
 docs-ja/pages/hooks-ja.md              |  50 +--
 docs-ja/pages/mcp-ja.md                |   2 +
 docs-ja/pages/monitoring-usage-ja.md   |  40 +-
 docs-ja/pages/prompt-caching-ja.md     |  11 +
 docs-ja/pages/settings-ja.md           | 190 ++++----
 docs-ja/pages/sub-agents-ja.md         |   7 +-
 docs-ja/pages/troubleshooting-ja.md    | 146 ++----
 16 files changed, 282 insertions(+), 1059 deletions(-)
```

<details>
<summary>amazon-bedrock-ja.md</summary>

```diff
diff --git a/docs-ja/pages/amazon-bedrock-ja.md b/docs-ja/pages/amazon-bedrock-ja.md
index 90046f9..c411db1 100644
--- a/docs-ja/pages/amazon-bedrock-ja.md
+++ b/docs-ja/pages/amazon-bedrock-ja.md
@@ -225,4 +225,5 @@ Claude Code で Bedrock を有効にする場合は、以下に注意してく
 * `AWS_REGION` は必須の環境変数です。Claude Code はこの設定について `.aws` 設定ファイルから読み込みません。
 * Bedrock を使用する場合、`/logout` コマンドは無効になります。認証は AWS 認証情報を通じて処理されるためです。
+* WebSearch ツールは Bedrock では利用できません。[WebSearch ツールの動作](/ja/tools-reference#websearch-tool-behavior)を参照してください。
 * 他のプロセスに漏らしたくない `AWS_PROFILE` などの環境変数に設定ファイルを使用できます。詳細については [Settings](/ja/settings) を参照してください。
 
```

</details>

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index d4dab2e..e02bb2e 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,35 @@
 # Changelog
 
+## 2.1.162
+
+- `claude agents --json` now includes `waitingFor` showing what a waiting session is blocked on (e.g. permission prompt)
+- `--tools`: explicitly listing Grep/Glob now provides the dedicated search tools on native builds with embedded search (previously these names were silently ignored)
+- `/effort` now confirms when your chosen level will persist as the default for new sessions
+- Clicking a slash command in the autocomplete menu now fills it into your prompt instead of running it immediately; press Enter to run
+- Remote Control now shows as a persistent footer pill (with a link to the session) instead of a startup message
+- Renamed Windsurf to Devin Desktop in the `/ide` menu, `/terminal-setup`, and `/scroll-speed`, following the editor's rebrand
+- Fixed a silent startup hang when the config directory is read-only or unwritable — Claude Code now starts with in-memory config and surfaces startup errors instead of showing a blank screen
+- Fixed WebFetch permission rules not being applied to built-in preapproved domains; explicit `WebFetch(domain:...)` deny/ask/allow rules now take precedence over the preapproved-host auto-allow
+- Fixed Windows permission rules never matching when spelled with backslashes (`~\`, `\\server\share`) or case-variant paths, and Read deny rules not hiding files from Glob/Grep results
+- Fixed an interrupt (Esc) sent at the very start of a turn being silently dropped in stream-json/SDK sessions, leaving the turn running with no "Interrupted" feedback
+- Fixed API 400 `no low surrogate in string` errors for classifier side-queries and MCP server descriptions containing emoji near a truncation boundary
+- Fixed MCP per-server `timeout` config values below 1000 ms being floored to a 1-second watchdog that aborted every tool call; sub-1000 ms values are now ignored (falling back to `MCP_TOOL_TIMEOUT` or default), and `claude mcp get` annotates them accordingly
+- Fixed the LSP tool's `workspaceSymbol` operation returning no results; it now accepts a `query` parameter and passes it to the language server
+- Fixed `claude agents` cutting live status text (tool args, replies, prompts, exec output) at 60–120 columns on wide terminals; the status detail now uses the full terminal width
+- Fixed `claude agents` truncating long session names at 40 columns; the name column now grows with terminal width
+- Fixed `claude agents` attach occasionally bouncing straight back to the session list on the first try after a background-service restart
+- Fixed `claude agents` Ctrl+V image paste doing nothing in the dispatch input and the session reply box; pasting with no image now shows a hint
+- Fixed backgrounding a session with ← silently losing the conversation when the background service cannot start; the session stays in the list as a failed row you can wake with Enter
+- Fixed replies from the agents view that fail to send being lost; they are now queued for delivery on the next session start
+- Fixed cross-session messaging (`SendMessage`) silently breaking when `CLAUDE_CODE_TMPDIR` or `$TMPDIR` points at a deep directory
+- Fixed opening a running background session from `claude agents` stalling for 5 seconds before attaching
```

</details>

<details>
<summary>channels-reference-ja.md</summary>

```diff
diff --git a/docs-ja/pages/channels-reference-ja.md b/docs-ja/pages/channels-reference-ja.md
index d3e6664..7d00277 100644
--- a/docs-ja/pages/channels-reference-ja.md
+++ b/docs-ja/pages/channels-reference-ja.md
@@ -1,757 +1,25 @@
-> ## Documentation Index
-> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
-> Use this file to discover all available pages before exploring further.
-
-# チャネルリファレンス
-
-> webhook、アラート、チャットメッセージを Claude Code セッションにプッシュする MCP サーバーを構築します。チャネルコントラクトのリファレンス：機能宣言、通知イベント、返信ツール、送信者ゲーティング、権限リレー。
-
-<Note>
-  チャネルは[リサーチプレビュー](/ja/channels#research-preview)段階にあり、Claude Code v2.1.80 以降が必要です。Team および Enterprise 組織は[明示的に有効化](/ja/channels#enterprise-controls)する必要があります。
-</Note>
-
-チャネルは、Claude Code セッションにイベントをプッシュする MCP サーバーで、Claude がターミナルの外で発生していることに反応できるようにします。
-
-一方向または双方向のチャネルを構築できます。一方向チャネルは、アラート、webhook、または監視イベントを転送して Claude が対応できるようにします。チャットブリッジのような双方向チャネルは、Claude がメッセージを返送できるように[返信ツールを公開](#expose-a-reply-tool)することもできます。信頼できる送信者パスを持つチャネルは、[権限プロンプトをリレー](#relay-permission-prompts)することを選択して、ツール使用をリモートで承認または拒否できます。
-
-このページでは以下をカバーしています：
-
-* [概要](#overview)：チャネルの仕組み
-* [必要なもの](#what-you-need)：要件と一般的な手順
-* [例：webhook レシーバーを構築](#example-build-a-webhook-receiver)：最小限の一方向ウォークスルー
-* [サーバーオプション](#server-options)：コンストラクタフィールド
-* [通知フォーマット](#notification-format)：イベントペイロードと配信動作
-* [返信ツールを公開](#expose-a-reply-tool)：Claude がメッセージを返送できるようにする
-* [インバウンドメッセージをゲート](#gate-inbound-messages)：プロンプトインジェクションを防ぐための送信者チェック
```

</details>

<details>
<summary>chrome-ja.md</summary>

```diff
diff --git a/docs-ja/pages/chrome-ja.md b/docs-ja/pages/chrome-ja.md
index c7091f7..cba3951 100644
--- a/docs-ja/pages/chrome-ja.md
+++ b/docs-ja/pages/chrome-ja.md
@@ -69,5 +69,5 @@ VS Code については、[VS Code でのブラウザ自動化](/ja/vs-code#auto
 ### Chrome をデフォルトで有効にする
 
-各セッションで `--chrome` を渡すことを避けるには、`/chrome` を実行して「Enabled by default」を選択します。
+各セッションで `--chrome` を渡すことを避けるには、`/chrome` を実行して「デフォルトで有効」を選択します。
 
 [VS Code 拡張機能](/ja/vs-code#automate-browser-tasks-with-chrome) では、Chrome 拡張機能がインストールされている場合、Chrome はいつでも利用可能です。追加のフラグは必要ありません。
@@ -169,5 +169,5 @@ Claude はインタラクションシーケンスを記録し、GIF ファイル
 ### 拡張機能が検出されない
 
-Claude Code が「Chrome extension not detected」を表示する場合：
+Claude Code の setup-issues 行に `chrome` がリストされている場合：
 
 1. Chrome 拡張機能が `chrome://extensions` にインストールされ、有効になっていることを確認します
```

</details>

<details>
<summary>claude-directory-ja.md</summary>

```diff
diff --git a/docs-ja/pages/claude-directory-ja.md b/docs-ja/pages/claude-directory-ja.md
index 3347c46..931e4cd 100644
--- a/docs-ja/pages/claude-directory-ja.md
+++ b/docs-ja/pages/claude-directory-ja.md
@@ -1557,5 +1557,5 @@ Windows では、`~/.claude` は `%USERPROFILE%\.claude` に解決されます
 ### ローカルデータをクリアする
 
-`claude project purge` を実行して、1 つのプロジェクトに対して Claude Code が保持する状態を削除します：
+`claude project purge` を実行して、1 つのプロジェクトに対して Claude Code が保持する状態を削除します。このコマンドには Claude Code v2.1.124 以降が必要です。以下を削除します：
 
 * `projects/` の下のトランスクリプトと自動メモリ
```

</details>

<details>
<summary>env-vars-ja.md</summary>

```diff
diff --git a/docs-ja/pages/env-vars-ja.md b/docs-ja/pages/env-vars-ja.md
index 988c1ea..ab6707c 100644
--- a/docs-ja/pages/env-vars-ja.md
+++ b/docs-ja/pages/env-vars-ja.md
@@ -151,5 +151,5 @@ Claude Code は起動時に環境変数を読み取るため、変更は `claude
 | `CLAUDE_CODE_DEBUG_LOG_LEVEL`                           | デバッグログファイルに書き込まれる最小ログレベル。値：`verbose`、`debug`（デフォルト）、`info`、`warn`、`error`。フルステータスラインコマンド出力などの大量の診断を含めるには `verbose` に設定するか、ノイズを減らすには `error` に上げます                                                                                                                                                                                                                                                                              |
 | `CLAUDE_CODE_DISABLE_1M_CONTEXT`                        | [1M コンテキストウィンドウ](/ja/model-config#extended-context) サポートを無効にするには `1` に設定します。設定すると、1M モデルバリアントはモデルピッカーで利用できなくなります。コンプライアンス要件のあるエンタープライズ環境に役立ちます                                                                                                                                                                                                                                                                                 |
-| `CLAUDE_CODE_DISABLE_ADAPTIVE_THINKING`                 | Opus 4.6 と Sonnet 4.6 の [適応的推論](/ja/model-config#adjust-effort-level) を無効にするには `1` に設定します。`MAX_THINKING_TOKENS` で制御される固定思考予算にフォールバックします。{/* min-version: 2.1.111 */}Opus 4.7 以降では効果がなく、常に適応的推論を使用します                                                                                                                                                                                                                           |
+| `CLAUDE_CODE_DISABLE_ADAPTIVE_THINKING`                 | Opus 4.6 と Sonnet 4.6 の [適応的推論](/ja/model-config#adjust-effort-level) を無効にするには `1` に設定します。`MAX_THINKING_TOKENS` で制御される固定思考予算にフォールバックします。{/* min-version: 2.1.111 */}v2.1.111 以降、Opus 4.7 以降では効果がなく、常に適応的推論を使用します                                                                                                                                                                                                               |
 | `CLAUDE_CODE_DISABLE_AGENT_VIEW`                        | [バックグラウンドエージェントとエージェントビュー](/ja/agent-view) をオフにするには `1` に設定します：`claude agents`、`--bg`、`/background`、およびオンデマンドスーパーバイザー。[`disableAgentView`](/ja/settings#available-settings) 設定と同等です                                                                                                                                                                                                                                            |
 | `CLAUDE_CODE_DISABLE_ALTERNATE_SCREEN`                  | [フルスクリーンレンダリング](/ja/fullscreen) を無効にするには `1` に設定します。クラシックなメインスクリーンレンダラーを使用します。会話はターミナルのネイティブなスクロールバックに留まるため、`Cmd+f` と tmux コピーモードが通常通り機能します。`CLAUDE_CODE_NO_FLICKER` と [`tui`](/ja/settings#available-settings) 設定より優先されます。`/tui default` で切り替えることもできます。バックグラウンドセッションから開かれた [エージェントビュー](/ja/agent-view) には適用されません。これらは常にフルスクリーンレンダリングを使用します                                                                                    |
@@ -175,5 +175,5 @@ Claude Code は起動時に環境変数を読み取るため、変更は `claude
 | `CLAUDE_CODE_DISABLE_WORKFLOWS`                         | [ワークフロー](/ja/workflows#turn-workflows-off) を無効にするには `1` に設定します。[`disableWorkflows`](/ja/settings#available-settings) 設定と同等です                                                                                                                                                                                                                                                                                                   |
 | `CLAUDE_CODE_EFFORT_LEVEL`                              | サポートされているモデルの努力レベルを設定します。値：`low`、`medium`、`high`、`xhigh`、`max`、または `auto`（モデルのデフォルトを使用）。利用可能なレベルはモデルによって異なります。`/effort` および `effortLevel` 設定より優先されます。[努力レベルを調整](/ja/model-config#adjust-effort-level) を参照してください                                                                                                                                                                                                                |
-| `CLAUDE_CODE_ENABLE_AUTO_MODE`                          | {/* min-version: 2.1.158 */}Amazon Bedrock、Google Cloud Vertex AI、Microsoft Foundry で [自動モード](/ja/permission-modes#eliminate-prompts-with-auto-mode) を利用可能にするには `1` に設定します。Anthropic API では効果がなく、自動モードはデフォルトで利用可能です。[Bedrock、Vertex AI、または Foundry で自動モードを有効にする](/ja/permission-modes#enable-auto-mode-on-bedrock-vertex-ai-or-foundry) を参照してください                                                                              |
+| `CLAUDE_CODE_ENABLE_AUTO_MODE`                          | {/* min-version: 2.1.158 */}Amazon Bedrock、Google Cloud Vertex AI、Microsoft Foundry で [自動モード](/ja/permission-modes#eliminate-prompts-with-auto-mode) を利用可能にするには `1` に設定します。Claude Code v2.1.158 以降が必須です。Anthropic API では効果がなく、自動モードはデフォルトで利用可能です。[Bedrock、Vertex AI、または Foundry で自動モードを有効にする](/ja/permission-modes#enable-auto-mode-on-bedrock-vertex-ai-or-foundry) を参照してください                                                 |
 | `CLAUDE_CODE_ENABLE_AWAY_SUMMARY`                       | [セッションリキャップ](/ja/interactive-mode#session-recap) の利用可能性をオーバーライドします。`/config` トグルに関係なくリキャップを強制的にオフにするには `0` に設定します。[`awaySummaryEnabled`](/ja/settings#available-settings) が `false` の場合にリキャップを強制的にオンにするには `1` に設定します。設定と `/config` トグルより優先されます                                                                                                                                                                                 |
 | `CLAUDE_CODE_ENABLE_BACKGROUND_PLUGIN_REFRESH`          | [非対話モード](/ja/headless) でバックグラウンドインストールが完了した後、ターン境界でプラグイン状態をリフレッシュするには `1` に設定します。リフレッシュはセッション中にシステムプロンプトを変更するため、デフォルトではオフです。これにより、そのターンの [プロンプトキャッシング](/ja/prompt-caching) が無効になります                                                                                                                                                                                                                                            |
@@ -190,5 +190,5 @@ Claude Code は起動時に環境変数を読み取るため、変更は `claude
 | `CLAUDE_CODE_FILE_READ_MAX_OUTPUT_TOKENS`               | ファイル読み取りのデフォルトトークン制限をオーバーライドします。より大きなファイルを完全に読み取る必要がある場合に役立ちます                                                                                                                                                                                                                                                                                                                                                                 |
 | `CLAUDE_CODE_FORCE_SYNC_OUTPUT`                         | ターミナルがサポートしているが自動検出されていない場合、DEC プライベートモード 2026 [同期出力](https://gist.github.com/christianparpart/d8a62cc1ab659194337d73e399004036) を強制的に有効にするには `1` に設定します。Emacs `eat` などのエミュレーターで役立ちます。これは BSU/ESU を実装していますが、機能プローブに応答しません。tmux では効果がありません                                                                                                                                                                                      |
-| `CLAUDE_CODE_FORK_SUBAGENT`                             | [フォークされた subagent](/ja/sub-agents#fork-the-current-conversation) を有効にするには `1` に設定します。フォークされた subagent は、最初から開始する代わりに、メインセッションから完全な会話コンテキストを継承します。有効にすると、`/fork` は [`/branch`](/ja/commands) のエイリアスとして機能する代わりに、フォークされた subagent をスポーンします。すべての subagent スポーンはバックグラウンドで実行されます。対話モードと SDK または `claude -p` を通じて                                                                                                                     |
+| `CLAUDE_CODE_FORK_SUBAGENT`                             | [フォークされた subagent](/ja/sub-agents#fork-the-current-conversation) をモデルのデフォルトにするには `1` に設定します：Claude は、一般的な subagent を使用する代わりにフォークをスポーンします。フォークは、最初から開始する代わりに、完全な会話コンテキストを継承する subagent です。すべての subagent スポーンはバックグラウンドで実行されます。明示的な [`/fork`](/ja/commands) コマンドはこの変数なしで機能します。対話モードと SDK または `claude -p` を通じて機能します                                                                                                                |
 | `CLAUDE_CODE_GIT_BASH_PATH`                             | Windows のみ：Git Bash 実行可能ファイル（`bash.exe`）へのパス。Git Bash がインストールされているが PATH にない場合に使用します。[Windows セットアップ](/ja/setup#set-up-on-windows) を参照してください                                                                                                                                                                                                                                                                                   |
 | `CLAUDE_CODE_GLOB_HIDDEN`                               | Claude が [Glob ツール](/ja/tools-reference#glob-tool-behavior) を呼び出すときに結果からドットファイルを除外するには `false` に設定します。デフォルトで含まれます。`@` ファイルオートコンプリート、`ls`、Grep、または Read には影響しません                                                                                                                                                                                                                                                                |
@@ -223,5 +223,5 @@ Claude Code は起動時に環境変数を読み取るため、変更は `claude
 | `CLAUDE_CODE_PLUGIN_SEED_DIR`                           | 1 つ以上の読み取り専用プラグインシードディレクトリへのパス。Unix では `:` で、Windows では `;` で区切られます。事前入力されたプラグインディレクトリをコンテナイメージにバンドルするために使用します。Claude Code はこれらのディレクトリからマーケットプレイスを登録し、再クローンなしで事前キャッシュされたプラグインを使用します。[コンテナ用のプラグインを事前入力](/ja/plugin-marketplaces#pre-populate-plugins-for-containers) を参照してください                                                                                                                                                  |
 | `CLAUDE_CODE_POWERSHELL_RESPECT_EXECUTION_POLICY`       | Claude Code が PowerShell をスポーンするときに `-ExecutionPolicy Bypass` を渡すことを停止するには `1` に設定します。ツール呼び出し、フック、ステータスラインコマンドの場合、マシンの有効な実行ポリシーを尊重します。デフォルトでは Claude Code はプロセススコープでバイパスを実行するため、`.ps1` スクリプトとモジュールインポートはデフォルト制限 Windows インストールで機能します。プロセススコープバイパスは、この設定に関係なく、グループポリシー `MachinePolicy` または `UserPolicy` をオーバーライドしません                                                                                                            |
-| `CLAUDE_CODE_PROPAGATE_TRACEPARENT`                     | {/* min-version: 2.1.152 */}カスタムプロキシを指す場合、W3C トレースコンテキストを伝播するには `1` に設定します。`ANTHROPIC_BASE_URL` が指しています。伝播は、モデルと HTTP MCP リクエストの `traceparent` ヘッダーと、Bash、PowerShell、フックサブプロセスの `TRACEPARENT` 環境変数をカバーします。デフォルトでは、伝播は Anthropic API に直接接続されている場合にのみ有効になります。[トレース（ベータ）](/ja/monitoring-usage#traces-beta) を参照してください                                                                                                             |
+| `CLAUDE_CODE_PROPAGATE_TRACEPARENT`                     | {/* min-version: 2.1.152 */}カスタムプロキシを指す場合、W3C トレースコンテキストを伝播するには `1` に設定します。`ANTHROPIC_BASE_URL` が指しています。伝播は、モデルと HTTP MCP リクエストの `traceparent` ヘッダーと、Bash、PowerShell、フックサブプロセスの `TRACEPARENT` 環境変数をカバーします。デフォルトでは、伝播は Anthropic API に直接接続されている場合にのみ有効になります。v2.1.152 で追加されました。[トレース（ベータ）](/ja/monitoring-usage#traces-beta) を参照してください                                                                                           |
```

</details>

<details>
<summary>fast-mode-ja.md</summary>

```diff
diff --git a/docs-ja/pages/fast-mode-ja.md b/docs-ja/pages/fast-mode-ja.md
index fd997e8..90d5579 100644
--- a/docs-ja/pages/fast-mode-ja.md
+++ b/docs-ja/pages/fast-mode-ja.md
@@ -65,5 +65,5 @@ Opus 4.8 は Claude Code v2.1.154 以降の高速モードのデフォルトで
 高速モード価格は完全な 1M トークンコンテキストウィンドウ全体で一定です。比較対象となる標準 Opus レートについては、[Claude 価格リファレンス](https://platform.claude.com/docs/ja/about-claude/pricing)を参照してください。
 
-会話の途中で高速モードに切り替えると、会話コンテキスト全体に対して完全な高速モードキャッシュなし入力トークン価格を支払います。これは最初から高速モードを有効にした場合よりもコストが高くなります。
+会話で初めて高速モードを有効にすると、会話コンテキスト全体に対して完全な高速モードキャッシュなし入力トークン価格を支払います。会話が進むほど、このコストは高くなるため、最初から高速モードを有効にする方が安くなります。コストは会話ごとに 1 回適用されるため、後で高速モードをオフにしてからオンに切り替えても、再度請求されることはありません。メカニズムについては、[高速モードがプロンプトキャッシュとどのように相互作用するか](/ja/prompt-caching#turning-on-fast-mode)を参照してください。
 
 ## 高速モードの使用時期を判断する
```

</details>

<details>
<summary>headless-ja.md</summary>

```diff
diff --git a/docs-ja/pages/headless-ja.md b/docs-ja/pages/headless-ja.md
index 2d91423..cfda9d0 100644
--- a/docs-ja/pages/headless-ja.md
+++ b/docs-ja/pages/headless-ja.md
@@ -153,15 +153,15 @@ claude -p "Write a poem" --output-format stream-json --verbose --include-partial
 API リクエストが再試行可能なエラーで失敗すると、Claude Code は再試行前に `system/api_retry` イベントを発行します。これを使用して、再試行の進行状況を表示したり、カスタムバックオフロジックを実装したりできます。
 
-| フィールド            | 型             | 説明                                                                                                                                                                        |
-| ---------------- | ------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
-| `type`           | `"system"`    | メッセージタイプ                                                                                                                                                                  |
-| `subtype`        | `"api_retry"` | これが再試行イベントであることを識別します                                                                                                                                                     |
-| `attempt`        | 整数            | 現在の試行番号（1 から開始）                                                                                                                                                           |
-| `max_retries`    | 整数            | 許可される再試行の合計                                                                                                                                                               |
-| `retry_delay_ms` | 整数            | 次の試行までのミリ秒                                                                                                                                                                |
-| `error_status`   | 整数または null    | HTTP ステータスコード、または HTTP レスポンスのない接続エラーの場合は `null`                                                                                                                           |
-| `error`          | 文字列           | エラーカテゴリ：`authentication_failed`、`oauth_org_not_allowed`、`billing_error`、`rate_limit`、`invalid_request`、`model_not_found`、`server_error`、`max_output_tokens`、または `unknown` |
-| `uuid`           | 文字列           | 一意のイベント識別子                                                                                                                                                                |
-| `session_id`     | 文字列           | イベントが属するセッション                                                                                                                                                             |
+| フィールド            | 型             | 説明                                                                                                                                                                                     |
+| ---------------- | ------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
+| `type`           | `"system"`    | メッセージタイプ                                                                                                                                                                               |
+| `subtype`        | `"api_retry"` | これが再試行イベントであることを識別します                                                                                                                                                                  |
+| `attempt`        | 整数            | 現在の試行番号（1 から開始）                                                                                                                                                                        |
+| `max_retries`    | 整数            | 許可される再試行の合計                                                                                                                                                                            |
+| `retry_delay_ms` | 整数            | 次の試行までのミリ秒                                                                                                                                                                             |
+| `error_status`   | 整数または null    | HTTP ステータスコード、または HTTP レスポンスのない接続エラーの場合は `null`                                                                                                                                        |
+| `error`          | 文字列           | エラーカテゴリ：`authentication_failed`、`oauth_org_not_allowed`、`billing_error`、`rate_limit`、`overloaded`、`invalid_request`、`model_not_found`、`server_error`、`max_output_tokens`、または `unknown` |
+| `uuid`           | 文字列           | 一意のイベント識別子                                                                                                                                                                             |
+| `session_id`     | 文字列           | イベントが属するセッション                                                                                                                                                                          |
 
```

</details>

*...以降省略*

</details>


<details>
<summary>2026-06-03</summary>

**変更ファイル:**

```
 docs-ja/pages/admin-setup-ja.md            |    3 +-
 docs-ja/pages/agent-view-ja.md             |    6 +-
 docs-ja/pages/agents-ja.md                 |    4 +-
 docs-ja/pages/amazon-bedrock-ja.md         |    6 +-
 docs-ja/pages/analytics-ja.md              |   16 +-
 docs-ja/pages/auto-mode-config-ja.md       |    2 +-
 docs-ja/pages/changelog.md                 |   55 ++
 docs-ja/pages/channels-ja.md               |   25 +-
 docs-ja/pages/chrome-ja.md                 |    2 +-
 docs-ja/pages/claude-code-on-the-web-ja.md |    2 +
 docs-ja/pages/code-review-ja.md            |    2 +-
 docs-ja/pages/commands-ja.md               |    5 +-
 docs-ja/pages/common-workflows-ja.md       |    2 +
 docs-ja/pages/computer-use-ja.md           |   11 +-
 docs-ja/pages/desktop-ja.md                |    4 +-
 docs-ja/pages/env-vars-ja.md               |    9 +-
 docs-ja/pages/errors-ja.md                 |   10 +-
 docs-ja/pages/fast-mode-ja.md              |    2 +-
 docs-ja/pages/fullscreen-ja.md             |    2 +
 docs-ja/pages/github-actions-ja.md         |    2 +-
 docs-ja/pages/glossary-ja.md               |    2 +-
 docs-ja/pages/google-vertex-ai-ja.md       |    8 +-
 docs-ja/pages/interactive-mode-ja.md       |    2 +-
 docs-ja/pages/jetbrains-ja.md              |    2 +-
 docs-ja/pages/mcp-ja.md                    |    4 +-
 docs-ja/pages/microsoft-foundry-ja.md      |    4 +-
 docs-ja/pages/model-config-ja.md           |   59 +-
 docs-ja/pages/network-config-ja.md         |   25 +-
 docs-ja/pages/overview-ja.md               |    2 +-
 docs-ja/pages/permission-modes-ja.md       |   48 +-
 docs-ja/pages/permissions-ja.md            |    2 +-
 docs-ja/pages/plugin-dependencies-ja.md    |    2 +
 docs-ja/pages/plugins-reference-ja.md      |    2 -
 docs-ja/pages/prompt-library-en.md         | 1389 ----------------------------
 docs-ja/pages/settings-ja.md               |    4 +-
 docs-ja/pages/slack-ja.md                  |   47 +-
 docs-ja/pages/sub-agents-ja.md             |    2 +-
 docs-ja/pages/terminal-config-ja.md        |    6 +-
 docs-ja/pages/tools-reference-ja.md        |    4 +-
 docs-ja/pages/troubleshooting-ja.md        |    6 +-
 docs-ja/pages/vs-code-ja.md                |   44 +-
 docs-ja/pages/web-quickstart-ja.md         |   12 +-
 docs-ja/pages/workflows-ja.md              |   22 +-
 43 files changed, 323 insertions(+), 1545 deletions(-)
```

**新規追加:**


**削除:**


<details>
<summary>admin-setup-ja.md</summary>

```diff
diff --git a/docs-ja/pages/admin-setup-ja.md b/docs-ja/pages/admin-setup-ja.md
index 0c9936a..ab983f9 100644
--- a/docs-ja/pages/admin-setup-ja.md
+++ b/docs-ja/pages/admin-setup-ja.md
@@ -133,4 +133,5 @@ Team、Enterprise、Claude API、およびクラウドプロバイダープラ
 * [Server-managed settings](/ja/server-managed-settings): Claude 管理コンソールからマネージドポリシーを配信する
 * [Settings reference](/ja/settings): すべての設定キー、ファイルの場所、優先度ルール
-* [Amazon Bedrock](/ja/amazon-bedrock)、[Google Vertex AI](/ja/google-vertex-ai)、[Microsoft Foundry](/ja/microsoft-foundry): プロバイダー固有の展開
+* [Monorepos and large repos](/ja/large-codebases): 大規模リポジトリをデプロイする組織向けのディレクトリごとの設定パターン
+* [Amazon Bedrock](/ja/amazon-bedrock)、[Google Vertex AI](/ja/google-vertex-ai)、[Microsoft Foundry](/ja/microsoft-foundry): プロバイダー固有のデプロイメント
 * [Claude Enterprise Administrator Guide](https://claude.com/resources/tutorials/claude-enterprise-administrator-guide): SSO、SCIM、シート管理、ロールアウトプレイブック
```

</details>

<details>
<summary>agent-view-ja.md</summary>

```diff
diff --git a/docs-ja/pages/agent-view-ja.md b/docs-ja/pages/agent-view-ja.md
index 5d38ff9..0e8451a 100644
--- a/docs-ja/pages/agent-view-ja.md
+++ b/docs-ja/pages/agent-view-ja.md
@@ -59,5 +59,5 @@ Claude が複数の独立したタスクに対して、あなたが毎ステッ
 
   <Step title="アタッチとデタッチ">
-    フル会話が必要な場合は、行で `Enter` または `→` を押してアタッチします。セッションは `claude` を実行した場合と同じようにターミナルを引き継ぎます。空のプロンプトで `←` を押してデタッチし、テーブルに戻ります。
+    フル会話が必要な場合は、行で `Enter` または `→` を押してアタッチします。セッションはターミナルを引き継ぎ、フルインタラクティブな Claude Code セッションになります。空のプロンプトで `←` を押してデタッチし、テーブルに戻ります。
   </Step>
 
@@ -167,8 +167,10 @@ Completed
 ### セッションにアタッチする
 
-選択した行で `Enter` または `→` を押してアタッチします。エージェントビューはフルインタラクティブセッションに置き換えられ、そのディレクトリで `claude` を実行した場合と同じです。アタッチすると、Claude は不在中に何が起こったかの短い要約を投稿します。
+選択した行で `Enter` または `→` を押してアタッチします。エージェントビューはフルインタラクティブセッションに置き換えられます。アタッチすると、Claude は不在中に何が起こったかの短い要約を投稿します。
 
 アタッチ中、セッションは他の Claude Code セッションのように動作します。すべての [コマンド](/ja/commands)、キーボードショートカット、および機能が機能します。
 
+アタッチされたセッションは、`tui` 設定に関係なく、常に [フルスクリーンモード](/ja/fullscreen) でレンダリングされます。バックグラウンドセッションには追加するターミナルスクロールバックがないためです。`PgUp`、`PgDn`、またはマウスホイールでスクロールし、トランスクリプトモードの場合は `Ctrl+O` を押します。ターミナルのネイティブスクロールと tmux コピーモードは現在のビューポートのみを表示します。これはフルスクリーンアプリケーションを実行するときと同じです。
+
 空のプロンプトで `←` を押してデタッチし、エージェントビューに戻ります。ダイアログがフォーカスを持っており、`←` に応答していない場合は、`Ctrl+Z` を押して直ちにデタッチします。
 
```

</details>

<details>
<summary>agents-ja.md</summary>

```diff
diff --git a/docs-ja/pages/agents-ja.md b/docs-ja/pages/agents-ja.md
index f296684..5984b05 100644
--- a/docs-ja/pages/agents-ja.md
+++ b/docs-ja/pages/agents-ja.md
@@ -41,7 +41,7 @@
   * 独立したタスクを引き継いで後で確認する場合：[エージェントビュー](/ja/agent-view)
   * Claude がワーカーのグループを計画、割り当て、監督する場合：[エージェントチーム](/ja/agent-teams)（実験的で、デフォルトでは無効）
-  * スクリプトが Claude のターンバイターン判断の代わりに調整を行う場合：[動的ワークフロー](/ja/workflows)
+  * スクリプトが Claude のターンバイターン判断の代わりに計画を保持する場合：[動的ワークフロー](/ja/workflows)。[ワークフローがサブエージェントとスキルとどのように比較されるか](/ja/workflows#when-to-use-a-workflow)を参照してください
 * **ワーカーが互いに通信する必要があるか？** サブエージェントは結果をそれらを生成した会話に報告し、エージェントビューセッションはあなたにのみ報告します。エージェントチームのチームメイトはタスクリストを共有し、互いに直接メッセージを送信します。
-* **タスクが同じファイルに触れるか？** [ワークツリー](/ja/worktrees) で作業を分離します。サブエージェントと自分で実行するセッションは、それぞれ個別のワークツリーを使用できます。エージェントチームはチームメイトをワークツリーで分離しないため、[作業を分割](/ja/agent-teams#avoid-file-conflicts) して、各チームメイトが異なるファイルセットを所有するようにします。
+* **タスクが同じファイルに触れるか？** [ワークツリー](/ja/worktrees)で作業を分離します。サブエージェントと自分で実行するセッションは、それぞれ個別のワークツリーを使用できます。エージェントチームはチームメイトをワークツリーで分離しないため、[作業を分割](/ja/agent-teams#avoid-file-conflicts)して、各チームメイトが異なるファイルセットを所有するようにします。
 
 ## 実行中の作業を確認する
```

</details>

<details>
<summary>amazon-bedrock-ja.md</summary>

```diff
diff --git a/docs-ja/pages/amazon-bedrock-ja.md b/docs-ja/pages/amazon-bedrock-ja.md
index 2f5b379..90046f9 100644
--- a/docs-ja/pages/amazon-bedrock-ja.md
+++ b/docs-ja/pages/amazon-bedrock-ja.md
@@ -235,8 +235,8 @@ Claude Code で Bedrock を有効にする場合は、以下に注意してく
 これらの環境変数を特定の Bedrock モデル ID に設定します。
 
-`ANTHROPIC_DEFAULT_OPUS_MODEL` なしでは、Bedrock の `opus` エイリアスは Opus 4.6 に解決されます。最新モデルを使用するには、Opus 4.7 ID に設定します。
+`ANTHROPIC_DEFAULT_OPUS_MODEL` なしでは、Bedrock の `opus` エイリアスは Opus 4.6 に解決されます。最新モデルを使用するには、Opus 4.8 ID に設定します。
 
 ```bash theme={null}
-export ANTHROPIC_DEFAULT_OPUS_MODEL='us.anthropic.claude-opus-4-7'
+export ANTHROPIC_DEFAULT_OPUS_MODEL='us.anthropic.claude-opus-4-8'
 export ANTHROPIC_DEFAULT_SONNET_MODEL='us.anthropic.claude-sonnet-4-6'
 export ANTHROPIC_DEFAULT_HAIKU_MODEL='us.anthropic.claude-haiku-4-5-20251001-v1:0'
@@ -357,5 +357,5 @@ Claude Code に必要な権限を持つ IAM ポリシーを作成します。
 ## 1M トークンコンテキストウィンドウ
 
-Claude Opus 4.7、Opus 4.6、および Sonnet 4.6 は、Amazon Bedrock で [1M トークンコンテキストウィンドウ](https://platform.claude.com/docs/en/build-with-claude/context-windows#1m-token-context-window)をサポートしています。Claude Code は、1M モデルバリアントを選択すると、拡張コンテキストウィンドウを自動的に有効にします。
+Claude Opus 4.6 以降および Sonnet 4.6 は、Amazon Bedrock で [1M トークンコンテキストウィンドウ](https://platform.claude.com/docs/ja/build-with-claude/context-windows#1m-token-context-window)をサポートしています。Claude Code は、1M モデルバリアントを選択すると、拡張コンテキストウィンドウを自動的に有効にします。
 
 [セットアップウィザード](#bedrock-でサインイン)は、モデルをピン留めするときに 1M コンテキストオプションを提供します。手動でピン留めされたモデルの代わりに有効にするには、モデル ID に `[1m]` を追加します。詳細については、[Pin models for third-party deployments](/ja/model-config#pin-models-for-third-party-deployments) を参照してください。
```

</details>

<details>
<summary>analytics-ja.md</summary>

```diff
diff --git a/docs-ja/pages/analytics-ja.md b/docs-ja/pages/analytics-ja.md
index ef46769..4c7149d 100644
--- a/docs-ja/pages/analytics-ja.md
+++ b/docs-ja/pages/analytics-ja.md
@@ -9,14 +9,14 @@
 Claude Code は、組織が開発者の使用パターンを理解し、貢献メトリクスを追跡し、Claude Code がエンジニアリング速度にどのような影響を与えるかを測定するのに役立つ分析ダッシュボードを提供します。お客様のプランに応じたダッシュボードにアクセスしてください。
 
-| プラン                           | ダッシュボード URL                                                                | 含まれる内容                                        | 詳細                                               |
-| ----------------------------- | -------------------------------------------------------------------------- | --------------------------------------------- | ------------------------------------------------ |
-| Claude for Teams / Enterprise | [claude.ai/analytics/claude-code](https://claude.ai/analytics/claude-code) | 使用メトリクス、GitHub 統合による貢献メトリクス、リーダーボード、データエクスポート | [詳細](#access-analytics-for-teams-and-enterprise) |
-| API（Claude Console）           | [platform.claude.com/claude-code](https://platform.claude.com/claude-code) | 使用メトリクス、支出追跡、チームインサイト                         | [詳細](#access-analytics-for-api-customers)        |
+| プラン                           | ダッシュボード URL                                                                | 含まれる内容                                        | 詳細                                              |
+| ----------------------------- | -------------------------------------------------------------------------- | --------------------------------------------- | ----------------------------------------------- |
+| Claude for Teams / Enterprise | [claude.ai/analytics/claude-code](https://claude.ai/analytics/claude-code) | 使用メトリクス、GitHub 統合による貢献メトリクス、リーダーボード、データエクスポート | [詳細](#access-analytics-for-team-and-enterprise) |
+| API（Claude Console）           | [platform.claude.com/claude-code](https://platform.claude.com/claude-code) | 使用メトリクス、支出追跡、チームインサイト                         | [詳細](#access-analytics-for-api-customers)       |
 
-## Teams と Enterprise の分析にアクセスする
+## Team と Enterprise の分析にアクセスする
 
 [claude.ai/analytics/claude-code](https://claude.ai/analytics/claude-code) に移動してください。管理者とオーナーがダッシュボードを表示できます。
 
-Teams と Enterprise ダッシュボードには以下が含まれます。
+Team と Enterprise ダッシュボードには以下が含まれます。
 
 * **使用メトリクス**：受け入れられたコード行数、提案受け入れ率、日次アクティブユーザー数とセッション数
@@ -25,8 +25,10 @@ Teams と Enterprise ダッシュボードには以下が含まれます。
 * **データエクスポート**：カスタムレポート用に貢献データを CSV としてダウンロード
 
+ユーザーごとのトークン数とコスト推定については、[OpenTelemetry エクスポート](/ja/monitoring-usage)を構成してください。
+
```

</details>

<details>
<summary>auto-mode-config-ja.md</summary>

```diff
diff --git a/docs-ja/pages/auto-mode-config-ja.md b/docs-ja/pages/auto-mode-config-ja.md
index 5dd6a62..cc485a3 100644
--- a/docs-ja/pages/auto-mode-config-ja.md
+++ b/docs-ja/pages/auto-mode-config-ja.md
@@ -10,5 +10,5 @@
 
 <Note>
-  オートモードは、Anthropic API を通じてすべてのユーザーが利用できます。Bedrock、Vertex、Foundry では利用できません。Claude Code がアカウントでオートモードが利用不可と報告する場合は、[完全な要件](/ja/permission-modes#eliminate-prompts-with-auto-mode)を確認してください。これには、サポートされているモデルと Team および Enterprise プランの管理者有効化も含まれます。
+  オートモードは、Anthropic API を通じてすべてのユーザーが利用できます。Amazon Bedrock、Google Cloud Vertex AI、Microsoft Foundry では、まず [`CLAUDE_CODE_ENABLE_AUTO_MODE`](/ja/permission-modes#enable-auto-mode-on-bedrock-vertex-ai-or-foundry) を[設定](/ja/permission-modes#enable-auto-mode-on-bedrock-vertex-ai-or-foundry)する必要があります。Claude Code がアカウントでオートモードが利用不可と報告する場合は、[完全な要件](/ja/permission-modes#eliminate-prompts-with-auto-mode)を確認してください。これには、サポートされているモデルと Team および Enterprise プランの管理者有効化も含まれます。
 </Note>
 
```

</details>

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index efa9d13..d4dab2e 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,59 @@
 # Changelog
 
+## 2.1.161
+
+- `OTEL_RESOURCE_ATTRIBUTES` values are now included as labels on metric datapoints, so you can slice usage metrics by custom dimensions like team or repo
+- `claude agents` rows now show `done/total` before the detail when work is fanned out; peek shows the longest-running item
+- `/mcp` now collapses claude.ai connectors you've never signed in to behind a "Show unused connectors" row
+- Parallel tool calls: a failed Bash command no longer cancels other calls in the same batch — each tool returns its own result independently
+- Fullscreen mode: clipboard now uses `wl-copy`/`xclip`/`xsel` on Linux when available, copies to both the clipboard and PRIMARY selection for middle-click paste, and the "hold {key} for native selection" hint now shows the correct key per terminal
+- Fixed the `/effort` dialog, workflow animations, and prompt keyword shimmer not honoring the "Reduce motion" setting
+- Fixed `forceLoginOrgUUID`/`forceLoginMethod` managed-settings policies blocking third-party provider sessions (Bedrock, Vertex, Foundry, Mantle) alongside the org pin (regression in 2.1.146)
+- Fixed background subagent output corrupting `claude -p` stdout when using `--output-format text` or `json`
+- Fixed `/usage-credits` starting a re-login for Team and Enterprise admins instead of pointing to the organization's usage settings page
+- Fixed `/autofix-pr` reporting "cannot run on the default branch" when the session is inside a git worktree or another repository
+- Fixed `--resume` picker not showing sessions from the current directory when it isn't a git worktree (e.g., jj workspaces)
+- Fixed Windows hooks that invoke bash explicitly (e.g., `/usr/bin/bash script.sh`) failing with "command not found" or "cannot execute binary file"
+- Fixed OpenTelemetry log events (`user_prompt`, `api_request`, `tool_result`, `tool_decision`) being silently dropped when emitted before telemetry initialization completed
+- Fixed `claude mcp` list/get/add printing secrets to the terminal: `${VAR}` references are no longer expanded, and credential headers and URL secrets are redacted
+- Fixed Workflow agents spawned with `isolation: "worktree"` in background sessions being blocked from editing files inside their own worktree
+- Fixed background sessions dispatched from `claude agents` booting on a stale model from the daemon's environment instead of the model in `settings.json`
+- Fixed a potential crash when rendering Write tool results after resuming a session
+- Fixed completed subagents getting stuck showing as running when an error occurs while finalizing their result
+- Fixed `EADDRINUSE` errors from tools that bind Unix sockets under `$TMPDIR` when `CLAUDE_CODE_TMPDIR` is set to a deep path
+- Improved terminal rendering performance by stabilizing the layout engine's JIT compilation profile
+- Improved rendering performance for large file writes
```

</details>

<details>
<summary>channels-ja.md</summary>

```diff
diff --git a/docs-ja/pages/channels-ja.md b/docs-ja/pages/channels-ja.md
index 77478b3..58acc7a 100644
--- a/docs-ja/pages/channels-ja.md
+++ b/docs-ja/pages/channels-ja.md
@@ -8,5 +8,5 @@
 
 <Note>
-  チャネルは[リサーチプレビュー](#research-preview)段階にあり、Claude Code v2.1.80 以降が必要です。claude.ai ログインが必要です。Console と API キー認証はサポートされていません。Team および Enterprise 組織は[明示的に有効にする](#enterprise-controls)必要があります。
+  チャネルは[リサーチプレビュー](#research-preview)段階にあり、Claude Code v2.1.80 以降が必要です。Anthropic 認証が claude.ai または Console API キーを通じて必要で、Amazon Bedrock、Google Vertex AI、Microsoft Foundry では利用できません。Team および Enterprise 組織は[明示的に有効にする](#enterprise-controls)必要があります。
 </Note>
 
@@ -226,7 +226,7 @@ Fakechat をインストールして有効にすると、ブラウザで入力
 Fakechat デモを試すには、以下が必要です。
 
-* Claude Code が[インストールされ、認証されている](/ja/quickstart#step-1-install-claude-code)（claude.ai アカウント）
+* Claude Code が[インストールされ、認証されている](/ja/quickstart#step-1-install-claude-code)（claude.ai アカウントまたは Claude Console API キー）
 * [Bun](https://bun.sh) がインストールされている。事前構築されたチャネルプラグインは Bun スクリプトです。`bun --version` で確認します。失敗する場合は、[Bun をインストール](https://bun.sh/docs/installation)します。
-* **Team/Enterprise ユーザー**：組織管理者が管理設定で[チャネルを有効にする](#enterprise-controls)必要があります。
+* **Team、Enterprise、または管理 Console 組織**：管理者が[チャネルを有効にする](#enterprise-controls)必要があります。
 
 <Steps>
@@ -268,4 +268,6 @@ Fakechat デモを試すには、以下が必要です。
 Claude がターミナルから離れている間にパーミッションプロンプトにヒットした場合、セッションは応答するまで一時停止します。[パーミッションリレー機能](/ja/channels-reference#relay-permission-prompts)を宣言するチャネルサーバーは、これらのプロンプトをあなたに転送して、リモートで承認または拒否できるようにします。無人使用の場合、[`--dangerously-skip-permissions`](/ja/permission-modes#skip-all-checks-with-bypasspermissions-mode) はプロンプトを完全にバイパスしますが、信頼できる環境でのみ使用してください。
 
+非対話型モードで `-p` でチャネルを実行する場合、複数選択質問や Plan Mode 承認など、ターミナル入力が必要なツールは無効になるため、セッションは入力を待つことで停止することはありません。
+
 ## セキュリティ
 
@@ -281,5 +283,5 @@ Telegram と Discord はペアリングでリストをブートストラップ
 iMessage は異なります。自分自身にテキストを送信するとゲートを自動的にバイパスし、`/imessage:access allow` でハンドルを使用して他の連絡先を追加します。
```

</details>

*...以降省略*

</details>


<details>
<summary>2026-06-02</summary>

**変更ファイル:**

```
 docs-ja/pages/agent-view-ja.md       |  56 +++--
 docs-ja/pages/cli-reference-ja.md    |   1 +
 docs-ja/pages/desktop-ja.md          |   4 +-
 docs-ja/pages/discover-plugins-ja.md |   4 +-
 docs-ja/pages/glossary-ja.md         |   6 +-
 docs-ja/pages/goal-ja.md             |   4 +-
 docs-ja/pages/hooks-guide-ja.md      |   4 +-
 docs-ja/pages/hooks-ja.md            |  96 ++++++-
 docs-ja/pages/large-codebases-en.md  | 471 -----------------------------------
 docs-ja/pages/permission-modes-ja.md |   2 +-
 docs-ja/pages/plugins-ja.md          |  10 +-
 docs-ja/pages/prompt-caching-ja.md   |  34 ++-
 docs-ja/pages/voice-dictation-ja.md  |   6 +-
 docs-ja/pages/workflows-ja.md        |  38 +--
 14 files changed, 202 insertions(+), 534 deletions(-)
```

**新規追加:**


**削除:**


<details>
<summary>agent-view-ja.md</summary>

```diff
diff --git a/docs-ja/pages/agent-view-ja.md b/docs-ja/pages/agent-view-ja.md
index 69b1115..5d38ff9 100644
--- a/docs-ja/pages/agent-view-ja.md
+++ b/docs-ja/pages/agent-view-ja.md
@@ -81,5 +81,5 @@ claude agents --cwd ~/projects/my-app
 これはそのディレクトリの下で開始されたセッションのみを表示します。`~/projects/my-app/.claude/worktrees/` の下の [ワークツリーに移動した](#how-file-edits-are-isolated) セッションは、`~/projects/my-app` に属するものとしてカウントされます。
 
-他のターミナルで開いているインタラクティブセッションは、[バックグラウンドにする](#from-inside-a-session)までは表示されません。[Subagents](/ja/sub-agents) と [teammates](/ja/agent-teams) はセッションが生成しても個別の行としてリストされません。
+他のターミナルで開いているインタラクティブセッションは、[バックグラウンドにする](#from-inside-a-session) までは表示されません。[Subagents](/ja/sub-agents) と [teammates](/ja/agent-teams) はセッションが生成しても個別の行としてリストされません。
 
 ```text theme={null}
@@ -136,5 +136,5 @@ Completed
 各行の 1 行の概要は [Haiku クラスモデル](/ja/model-config) によって生成されるため、行はトランスクリプトを開かずにセッションが何をしているか、何が必要か、または何を生成したかを伝えることができます。セッションがアクティブに作業している間、概要は最大 15 秒ごとに 1 回、および各ターンが終了したときに 1 回更新されます。
 
-各更新は通常のプロバイダーを通じた 1 つの短い Haiku クラスリクエストであり、セッション自体と同じ [データ使用条件](/ja/data-usage) の下で請求および処理されます。
+各更新は通常のプロバイダーを通じた 1 つの短い Haiku クラスリクエストであり、セッション自体と同じ [データ使用条件](/ja/data-usage) の下で請求および処理されます。Bedrock、Vertex AI、Microsoft Foundry、カスタムゲートウェイなどのサードパーティプロバイダーでは、Haiku モデルが設定されていない場合、リクエストはセッションのメインモデルにフォールバックします。これらのプロバイダーでこれらの概要のモデルを選択するには、[`ANTHROPIC_DEFAULT_HAIKU_MODEL`](/ja/model-config#environment-variables) を設定します。
 
 ### プルリクエストステータス
@@ -161,4 +161,6 @@ Completed
 ピークパネルに返信を入力して `Enter` を押すと、そのセッションに送信されます。セッションが複数選択肢の質問をしている場合、ピークパネルはオプションを表示し、数字キーを押して 1 つを選択できます。他のブロックされたセッションの場合は、`Tab` を押して入力に提案された返信を入力し、送信前に編集できます。返信の前に `!` を付けて Bash コマンドを代わりに送信します。
 
+[音声ディクテーション](/ja/voice-dictation) が有効な場合、返信入力がフォーカスされている間、プッシュトゥトークキーを押したままにするか、タップして返信をディクテーションします。これはエージェントビューの下部のディスパッチ入力でも同じように機能します。
+
 `↑` と `↓` を使用してパネルを閉じずに隣接するセッションをピーク表示するか、`→` を使用してアタッチします。
 
@@ -249,4 +251,6 @@ Completed
 | `Shift+Enter`                    | ディスパッチして新しいセッションに直ちにアタッチ                                                                                 |
 
+エージェントビュー自体で実行される少数のコマンドがあります。ディスパッチの代わりに：`/exit` および `/quit` はエージェントビューを閉じ、`/logout` はサインアウトします。その他のすべてのコマンドとスキルは、新しいバックグラウンドセッションにその最初のプロンプトとして送信されます。
+
```

</details>

<details>
<summary>cli-reference-ja.md</summary>

```diff
diff --git a/docs-ja/pages/cli-reference-ja.md b/docs-ja/pages/cli-reference-ja.md
index e9f1326..e48963f 100644
--- a/docs-ja/pages/cli-reference-ja.md
+++ b/docs-ja/pages/cli-reference-ja.md
@@ -29,4 +29,5 @@
 | `claude auto-mode defaults`     | 組み込み [auto mode](/ja/permission-modes#eliminate-prompts-with-auto-mode) 分類器ルールを JSON として出力します。`claude auto-mode config` を使用して、設定が適用された有効な設定を確認してください                                                                                                                                                                                                                                                                                           | `claude auto-mode defaults > rules.json`                    |
 | `claude daemon status`          | バックグラウンドセッション [スーパーバイザー](/ja/agent-view#the-supervisor-process) の状態、バージョン、ソケットディレクトリ、および診断用のワーカー数を出力します。スーパーバイザーが実行されていない場合は 1 で終了します                                                                                                                                                                                                                                                                                                          | `claude daemon status`                                      |
+| `claude daemon stop --any`      | バックグラウンドセッション [スーパーバイザー](/ja/agent-view#the-supervisor-process) とそれがホストするセッションを停止します。`--keep-workers` を渡して、バックグラウンドセッションを実行したままにして、次のスーパーバイザーが再接続できるようにします。`--any` はオンデマンドスーパーバイザーの停止を確認します。これはデフォルトです。これを使用して、[応答しないスーパーバイザー](/ja/agent-view#agent-view-says-the-background-service-did-not-respond) から回復します                                                                                                                                  | `claude daemon stop --any --keep-workers`                   |
 | `claude logs <id>`              | [バックグラウンドセッション](/ja/agent-view#manage-sessions-from-the-shell) からの最近の出力を出力します                                                                                                                                                                                                                                                                                                                                                                  | `claude logs 7c5dcf5d`                                      |
 | `claude mcp`                    | Model Context Protocol（MCP）サーバーを設定                                                                                                                                                                                                                                                                                                                                                                                                             | [Claude Code MCP ドキュメント](/ja/mcp) を参照してください。                |
```

</details>

<details>
<summary>desktop-ja.md</summary>

```diff
diff --git a/docs-ja/pages/desktop-ja.md b/docs-ja/pages/desktop-ja.md
index ecba628..74b9b84 100644
--- a/docs-ja/pages/desktop-ja.md
+++ b/docs-ja/pages/desktop-ja.md
@@ -677,5 +677,7 @@ Desktop と CLI は同じ設定ファイルを読み取るため、セットア
 
 <Note>
-  **MCP サーバー：デスクトップチャットアプリと Claude Code**：Claude Desktop チャットアプリの `claude_desktop_config.json` で設定された MCP サーバーは Claude Code とは別であり、Code タブに表示されません。Claude Code で MCP サーバーを使用するには、`~/.claude.json` またはプロジェクトの `.mcp.json` ファイルで設定します。詳細については、[MCP 設定](/ja/mcp#installing-mcp-servers)を参照してください。
+  **Claude Desktop チャットアプリからの MCP サーバー**：Desktop アプリは `claude_desktop_config.json` から MCP サーバーを Code タブセッションに読み込みます。これは `~/.claude.json` および `.mcp.json` からのサーバーと並行して行われます。`claude_desktop_config.json` で定義されたサーバーは Desktop チャットサーフェスと Code タブの両方で利用可能です。
+
+  スタンドアロン CLI は `claude_desktop_config.json` を読み取りません。macOS と WSL では、`claude mcp add-from-claude-desktop` を実行して、これらのサーバーを `~/.claude.json` にコピーします。[Claude Desktop から MCP サーバーをインポート](/ja/mcp#import-mcp-servers-from-claude-desktop)を参照して、インポートフローとスコープオプションを確認してください。
 </Note>
 
```

</details>

<details>
<summary>discover-plugins-ja.md</summary>

```diff
diff --git a/docs-ja/pages/discover-plugins-ja.md b/docs-ja/pages/discover-plugins-ja.md
index 22daccd..47388c1 100644
--- a/docs-ja/pages/discover-plugins-ja.md
+++ b/docs-ja/pages/discover-plugins-ja.md
@@ -150,5 +150,5 @@ Anthropic は、プラグインシステムで何が可能かを示す例プラ
     * **Errors**: プラグイン読み込みエラーを表示
 
-    **Discover** タブに移動して、追加したばかりのマーケットプレイスからプラグインを確認してください。
+    **Discover** タブに移動して、追加したばかりのマーケットプレイスからプラグインを確認してください。{/* min-version: 2.1.154 */}現在の作業ディレクトリに関連するとマークされたプラグインは、**suggested for this directory** ラベル付きで上部に固定されます。
   </Step>
 
@@ -334,4 +334,6 @@ claude plugin uninstall formatter@your-org --scope project
 Claude Code はすべてのアクティブなプラグインをリロードし、プラグイン、スキル、エージェント、フック、プラグイン MCP サーバー、プラグイン LSP サーバーのカウントを表示します。
 
+リロードには次のリクエストでトークンコストがあります。新しくロードされたコンポーネントは会話に追加されたコンテンツで自身を発表し、既存の履歴はプロンプトキャッシュから読み込まれたままです。MCP サーバーを提供するプラグインは、そのツールが [tool search](/ja/mcp#scale-with-mcp-tool-search) によって遅延されていない場合、より多くのコストがかかります。変更はキャッシュを無効にし、次のリクエストは会話全体を再度読み込みます。詳細については、[プラグインの有効化または無効化](/ja/prompt-caching#enabling-or-disabling-a-plugin) を参照してください。
+
 ## マーケットプレイスを管理する
 
```

</details>

<details>
<summary>glossary-ja.md</summary>

```diff
diff --git a/docs-ja/pages/glossary-ja.md b/docs-ja/pages/glossary-ja.md
index 5fe8ae3..fa01c0b 100644
--- a/docs-ja/pages/glossary-ja.md
+++ b/docs-ja/pages/glossary-ja.md
@@ -83,7 +83,7 @@ Claude Code がプロジェクトスコープの設定を読み取るディレ
 ### CLAUDE.md
 
-Claude のために書く永続的な指示のマークダウンファイル。システムプロンプトの後、ユーザーメッセージとしてすべてのセッションの開始時にロードされます。プロジェクト規約、アーキテクチャノート、「常に X を行う」ルールをここに配置します。CLAUDE.md は [compaction](#compaction) を生き残り、その後ディスクから新しく再読み込みされます。
+Claude のために書く永続的な指示のマークダウンファイル。システムプロンプトの後、ユーザーメッセージとしてすべてのセッションの開始時にロードされます。プロジェクト規約、アーキテクチャノート、「常に X を行う」ルールをここに配置します。プロジェクトルート CLAUDE.md は [compaction](#compaction) を生き残り、その後ディスクから新しく再読み込みされます。
 
-CLAUDE.md は `./CLAUDE.md` または `./.claude/CLAUDE.md` のプロジェクトスコープに、`~/.claude/CLAUDE.md` のユーザースコープに、または組織の [managed policy](#managed-settings) として配置できます。より具体的な場所が優先されます。
+CLAUDE.md は `./CLAUDE.md` または `./.claude/CLAUDE.md` のプロジェクトスコープに、`~/.claude/CLAUDE.md` のユーザースコープに、または組織の [managed policy](#managed-settings) として配置できます。検出されたすべてのファイルは、互いにオーバーライドするのではなく、最も広いスコープから最も具体的なスコープへの順序で、コンテキストに連結されます。
 
 詳細情報: [CLAUDE.md files](/ja/memory#claude-md-files)
@@ -119,5 +119,5 @@ CLAUDE.md は `./CLAUDE.md` または `./.claude/CLAUDE.md` のプロジェク
 ### Effort level
 
-各ターンで Claude が適応的推論思考予算をどの程度使用するかを制御する設定。より高い努力はより多くの思考トークンとより深い推論を意味し、より低い努力はより速く、より安価です。Effort は Opus 4.7、Opus 4.6、Sonnet 4.6 でサポートされています。
+各ターンで Claude が適応的推論思考予算をどの程度使用するかを制御する設定。より高い努力はより多くの思考トークンとより深い推論を意味し、より低い努力はより速く、より安価です。Effort は Opus 4.6 以降、および Sonnet 4.6 でサポートされています。
 
 詳細情報: [Adjust effort level](/ja/model-config#adjust-effort-level)
```

</details>

<details>
<summary>goal-ja.md</summary>

```diff
diff --git a/docs-ja/pages/goal-ja.md b/docs-ja/pages/goal-ja.md
index 08f2780..d930f47 100644
--- a/docs-ja/pages/goal-ja.md
+++ b/docs-ja/pages/goal-ja.md
@@ -22,10 +22,10 @@
 このページでは以下について説明します。
 
-* [自律的なワークフロー アプローチの比較](#compare-to-other-autonomous-workflows)：`/loop`、Stop hook、および自動モード
+* [セッションを実行し続ける方法の比較](#compare-ways-to-keep-a-session-running)：`/loop`、Stop hook、および自動モード
 * [ゴールの設定](#set-a-goal)と[効果的な条件の作成](#write-an-effective-condition)
 * [ステータスの確認](#check-status)、[早期クリア](#clear-a-goal)、および[非対話的な実行](#run-non-interactively)
 * [評価の仕組み](#how-evaluation-works)と[要件](#requirements)を確認
 
-## 他の自律的なワークフロー アプローチとの比較
+## セッションを実行し続ける方法の比較
 
 3 つのアプローチが、プロンプト間で現在のセッションを実行し続けます。次のターンを開始するべき内容に基づいて選択します。
```

</details>

<details>
<summary>hooks-guide-ja.md</summary>

```diff
diff --git a/docs-ja/pages/hooks-guide-ja.md b/docs-ja/pages/hooks-guide-ja.md
index 99b44f6..41acb2d 100644
--- a/docs-ja/pages/hooks-guide-ja.md
+++ b/docs-ja/pages/hooks-guide-ja.md
@@ -3,5 +3,5 @@
 > Use this file to discover all available pages before exploring further.
 
-# hooks でワークフローを自動化する
+# hooks でアクションを自動化する
 
 > Claude Code がファイルを編集したり、タスクを完了したり、入力が必要になったりしたときに、シェルコマンドを自動的に実行します。コードをフォーマットし、通知を送信し、コマンドを検証し、プロジェクトルールを適用します。
@@ -870,5 +870,5 @@ HTTP hooks は、Web サーバー、クラウド関数、または外部サー
 * コマンド hooks は stdout、stderr、および終了コードを通じてのみ通信します。これらは `/` コマンドまたはツール呼び出しをトリガーできません。`additionalContext` を通じて返されたテキストは、Claude が平文として読むシステムリマインダーとして注入されます。HTTP hooks はレスポンスボディを通じて通信します。
 * Hook タイムアウトはタイプによって異なります。`timeout` フィールド（秒単位）で hook ごとにオーバーライドできます。
-  * `command`、`http`、`mcp_tool`：10 分。`UserPromptSubmit` はこれらを 30 秒に短縮します。
+  * `command`、`http`、`mcp_tool`：10 分。`UserPromptSubmit` はこれらを 30 秒に短縮し、`MessageDisplay` はこれらを 10 秒に短縮します。
   * `prompt`：30 秒。
   * `agent`：60 秒。
```

</details>

<details>
<summary>hooks-ja.md</summary>

```diff
diff --git a/docs-ja/pages/hooks-ja.md b/docs-ja/pages/hooks-ja.md
index 92824ae..44a0ef4 100644
--- a/docs-ja/pages/hooks-ja.md
+++ b/docs-ja/pages/hooks-ja.md
@@ -299,5 +299,5 @@ MCP ツールは `mcp__<server>__<tool>` という命名パターンに従いま
 | `type`          | はい  | `"command"`、`"http"`、`"mcp_tool"`、`"prompt"`、または `"agent"`                                                                                                                                                                                                                                                               |
 | `if`            | いいえ | `"Bash(git *)"` または `"Edit(*.ts)"` などの権限ルール構文を使用してこのフックが実行されるタイミングをフィルタリングします。ツール呼び出しがパターンにマッチする場合のみ、フックが生成されます。または Bash コマンドが解析するには複雑すぎる場合。ツール イベントでのみ評価されます。`PreToolUse`、`PostToolUse`、`PostToolUseFailure`、`PermissionRequest`、`PermissionDenied`。他のイベントでは、`if` が設定されたフックは実行されません。[権限ルール](/ja/permissions)と同じ構文を使用します |
-| `timeout`       | いいえ | キャンセルまでの秒数。デフォルト: `command`、`http`、`mcp_tool` は 600、`prompt` は 30、`agent` は 60。[`UserPromptSubmit`](#userpromptsubmit) は `command`、`http`、`mcp_tool` のデフォルトを 30 に低下させます                                                                                                                                                  |
+| `timeout`       | いいえ | キャンセルまでの秒数。デフォルト: `command`、`http`、`mcp_tool` は 600、`prompt` は 30、`agent` は 60。[`UserPromptSubmit`](#userpromptsubmit) は `command`、`http`、`mcp_tool` のデフォルトを 30 に低下させ、[`MessageDisplay`](#messagedisplay) はそれを 10 に低下させます                                                                                                |
 | `statusMessage` | いいえ | フックの実行中に表示されるカスタム スピナー メッセージ                                                                                                                                                                                                                                                                                             |
 | `once`          | いいえ | `true` の場合、セッションごとに 1 回だけ実行してから削除されます。[スキル フロントマター](#hooks-in-skills-and-agents)でのみ尊重されます。設定ファイルとエージェント フロントマターでは無視されます                                                                                                                                                                                                  |
@@ -735,5 +735,5 @@ Claude を完全に停止するには、イベント タイプに関係なく。
 input=$(cat)
 title="Claude Code'
-body=$(jq -r '.message // "Needs your attention"' <<<"$input")
+body=$(jq -r '.message // 'Needs your attention'' <<<"$input")
 seq=$(printf '\033]777;notify;%s;%s\007' "$title" "$body")
 jq -nc --arg seq "$seq" '{terminalSequence: $seq}'
@@ -1151,7 +1151,13 @@ InstructionsLoaded フックは決定制御がありません。命令ロード
 ### MessageDisplay
 
-アシスタント メッセージが画面にストリーミングされている間に実行されます。Claude Code はメッセージを増分で表示します。新しく完了した行のバッチがレンダリング準備ができるたびに、フックはそれらの行で 1 回実行され、Claude Code はフックの置換テキストをその場所にレンダリングします。長いメッセージは複数の呼び出しを生成します。短いメッセージは 1 つだけ生成する可能性があります。これを使用して Claude の応答を画面に表示されるときに再フォーマット、編集、または圧縮します。
+アシスタント メッセージが画面にストリーミングされている間に実行されます。Claude Code はメッセージを増分で表示します。新しく完了した行のバッチがレンダリング準備ができるたびに、フックはそれらの行で 1 回実行され、Claude Code はフックの置換テキストをその場所にレンダリングします。長いメッセージは複数の呼び出しを生成します。短いメッセージは 1 つだけ生成する可能性があります。
 
-MessageDisplay は表示のみです。置換テキストは画面にレンダリングされるものだけを変更します。トランスクリプトと Claude が見るものは元のテキストを保持するため、Claude は置換を見ず、詳細モードは元のテキストを表示します。MessageDisplay はマッチャーをサポートせず、テキストをストリーミングするすべてのアシスタント メッセージに対して発火します。テキストなしのメッセージ（ツール呼び出しのみの応答など）はそれをトリガーしません。
+MessageDisplay を使用して Claude の応答を画面に表示されるときに再フォーマット、編集、または圧縮します。
+
+Claude Code は各バッチをフックが返されるまで保持するため、フックを高速に保ちます。フックが失敗またはタイムアウトした場合、Claude Code は元のテキストを表示します。このイベントのデフォルト タイムアウトは 10 秒です。フックにより多くの時間が必要な場合は、フック エントリで `timeout` フィールドを設定します。
+
+MessageDisplay は表示のみです。置換テキストは画面にレンダリングされるものだけを変更します。トランスクリプトと Claude が見るものは元のテキストを保持するため、Claude は置換を見ず、詳細モードは元のテキストを表示します。フックはアシスタント メッセージ テキストのみを受け取るため、ツール結果とユーザーが入力したテキストは変更されずにレンダリングされます。
```

</details>

<details>
<summary>permission-modes-ja.md</summary>

```diff
diff --git a/docs-ja/pages/permission-modes-ja.md b/docs-ja/pages/permission-modes-ja.md
index 7fd7415..05894b8 100644
--- a/docs-ja/pages/permission-modes-ja.md
+++ b/docs-ja/pages/permission-modes-ja.md
@@ -227,5 +227,5 @@ Claude Code が自動モードを利用不可と報告する場合、これら
     各アクションは固定の決定順序を通過します。最初に一致するステップが勝ちます。
 
-    1. [allow または deny ルール](/ja/permissions#manage-permissions) に一致するアクションは即座に解決されます
+    1. [allow または deny ルール](/ja/permissions#manage-permissions) に一致するアクションは即座に解決されます。ただし、[保護されたパス](#protected-paths) への書き込みは、allow ルールが一致する場合でも分類器にルーティングされます
     2. 読み取り専用アクションと作業ディレクトリ内のファイル編集は自動承認されます。[保護されたパス](#protected-paths) への書き込みを除く
     3. その他すべては分類器に送られます
```

</details>

*...以降省略*

</details>


<details>
<summary>2026-06-01</summary>

**変更ファイル:**

```
 docs-ja/pages/changelog.md | 4 ++++
 1 file changed, 4 insertions(+)
```

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index b2d6dea..efa9d13 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,8 @@
 # Changelog
 
+## 2.1.159
+
+- Internal infrastructure improvements (no user-facing changes)
+
 ## 2.1.158
 
```

</details>

</details>


<details>
<summary>2026-05-31</summary>

**変更ファイル:**

```
 docs-ja/pages/agent-view-ja.md        |  53 ++++++++++----
 docs-ja/pages/changelog.md            |   4 +
 docs-ja/pages/cli-reference-ja.md     |  62 ++++++++--------
 docs-ja/pages/errors-ja.md            |   5 +-
 docs-ja/pages/interactive-mode-ja.md  |  42 +++++------
 docs-ja/pages/keybindings-ja.md       |   8 +-
 docs-ja/pages/mcp-ja.md               |   2 +
 docs-ja/pages/memory-ja.md            |   4 +-
 docs-ja/pages/monitoring-usage-ja.md  |  61 ++++++++++------
 docs-ja/pages/permission-modes-ja.md  |   3 +-
 docs-ja/pages/permissions-ja.md       |   2 +-
 docs-ja/pages/plugins-ja.md           |  12 +++
 docs-ja/pages/plugins-reference-ja.md | 133 +++++++++++++++++++++++++++++++---
 docs-ja/pages/settings-ja.md          |   7 +-
 docs-ja/pages/skills-ja.md            |   8 ++
 docs-ja/pages/sub-agents-ja.md        |   6 +-
 docs-ja/pages/terminal-config-ja.md   |   4 +-
 docs-ja/pages/tools-reference-ja.md   |   2 +-
 docs-ja/pages/workflows-ja.md         |   2 +-
 docs-ja/pages/worktrees-ja.md         |  10 ++-
 20 files changed, 308 insertions(+), 122 deletions(-)
```

<details>
<summary>agent-view-ja.md</summary>

```diff
diff --git a/docs-ja/pages/agent-view-ja.md b/docs-ja/pages/agent-view-ja.md
index 6e99095..69b1115 100644
--- a/docs-ja/pages/agent-view-ja.md
+++ b/docs-ja/pages/agent-view-ja.md
@@ -175,5 +175,5 @@ Completed
 デタッチはバックグラウンドセッションを停止しません。`←`、`Ctrl+Z`、`/exit`、および二重 `Ctrl+C` または二重 `Ctrl+D` はすべてセッションを実行し続けます。セッション内からセッションを終了するには、`/stop` を実行します。
 
-ディスパッチまたはバックグラウンドにしたセッションの後、空のプロンプトで `←` を押すと、アタッチしたセッションだけでなく、任意の Claude Code セッションから機能します。現在のセッションをバックグラウンドにし、そのセッションが事前に選択された状態でエージェントビューを開くため、ターミナルを離れずにセッションを切り替えることができます。行は会話履歴がない新しいセッションからでも作成されるため、`→` はそれに戻ります。その行が唯一の行である場合、エージェントビューはその下にオンボーディングヒントを表示します。このショートカットは `/config` でオフにできます（`leftArrowOpensAgents` 設定）。
+空のプロンプトで `←` を押すと、エージェントビューからアタッチしたセッションだけでなく、任意の Claude Code セッションから機能します。現在のセッションをバックグラウンドにし、そのセッションが事前に選択された状態でエージェントビューを開くため、ターミナルを離れずにセッションを切り替えることができます。行は会話履歴がない新しいセッションからでも作成されるため、`→` はそれに戻ります。その行が唯一の行である場合、エージェントビューはその下にオンボーディングヒントを表示します。このショートカットは `/config` でオフにできます（`leftArrowOpensAgents` 設定）。
 
 ### リストを整理する
@@ -239,12 +239,13 @@ Completed
 プロンプトの一部をプレフィックスまたは言及してセッションの開始方法を制御します：
 
-| 入力                      | 効果                                                                                                       |
-| :---------------------- | :------------------------------------------------------------------------------------------------------- |
-| `<agent-name> <prompt>` | 最初の単語がカスタム [subagent](/ja/sub-agents) 名と一致する場合、その subagent はセッションのメインエージェントとして実行され、frontmatter の設定を使用します |
-| `@<agent-name>`         | プロンプト内の任意の場所でカスタム subagent を言及してメインエージェントとして実行                                                           |
-| `@<repo>`               | エージェントビューを開いたディレクトリの下のリポジトリを言及してセッションをそこで実行                                                              |
-| `/<command>`            | [skills](/ja/skills) および [commands](/ja/commands) をディスパッチプロンプトとして提案                                      |
-| `#<number>` または PR URL  | セッションが既にその PR で作業している場合は、ディスパッチの代わりに選択                                                                   |
-| `Shift+Enter`           | ディスパッチして新しいセッションに直ちにアタッチ                                                                                 |
+| 入力                               | 効果                                                                                                       |
+| :------------------------------- | :------------------------------------------------------------------------------------------------------- |
+| `<agent-name> <prompt>`          | 最初の単語がカスタム [subagent](/ja/sub-agents) 名と一致する場合、その subagent はセッションのメインエージェントとして実行され、frontmatter の設定を使用します |
+| `@<agent-name>`                  | プロンプト内の任意の場所でカスタム subagent を言及してメインエージェントとして実行                                                           |
+| `@<repo>`                        | エージェントビューを開いたディレクトリの下のリポジトリを言及してセッションをそこで実行                                                              |
+| `/<command>`                     | [skills](/ja/skills) および [commands](/ja/commands) をディスパッチプロンプトとして提案                                      |
+| `! <command>`                    | Claude セッションを開始する代わりに、シェルコマンドをバックグラウンドジョブとして実行します。ジョブは行として表示され、アタッチ、監視、デタッチできます                          |
+| `#<number>` または pull request URL | セッションが既にその PR で作業している場合は、ディスパッチの代わりに選択                                                                   |
```

</details>

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index c29830e..b2d6dea 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,8 @@
 # Changelog
 
+## 2.1.158
+
+- Auto mode is now available on Bedrock, Vertex, and Foundry for Opus 4.7 and Opus 4.8. Opt in by setting `CLAUDE_CODE_ENABLE_AUTO_MODE=1`
+
 ## 2.1.157
 
```

</details>

<details>
<summary>cli-reference-ja.md</summary>

```diff
diff --git a/docs-ja/pages/cli-reference-ja.md b/docs-ja/pages/cli-reference-ja.md
index dca521a..e9f1326 100644
--- a/docs-ja/pages/cli-reference-ja.md
+++ b/docs-ja/pages/cli-reference-ja.md
@@ -11,32 +11,32 @@
 これらのコマンドを使用して、セッションを開始し、コンテンツをパイプし、会話を再開し、更新を管理できます。
 
-| コマンド                            | 説明                                                                                                                                                                                                                                                                                                                                                                                                                                   | 例                                                           |
-| :------------------------------ | :----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :---------------------------------------------------------- |
-| `claude`                        | インタラクティブセッションを開始                                                                                                                                                                                                                                                                                                                                                                                                                     | `claude`                                                    |
-| `claude "query"`                | 初期プロンプト付きでインタラクティブセッションを開始                                                                                                                                                                                                                                                                                                                                                                                                           | `claude "explain this project"`                             |
-| `claude -p "query"`             | SDK 経由でクエリを実行してから終了                                                                                                                                                                                                                                                                                                                                                                                                                  | `claude -p "explain this function"`                         |
-| `cat file \| claude -p "query"` | パイプされたコンテンツを処理                                                                                                                                                                                                                                                                                                                                                                                                                       | `cat logs.txt \| claude -p "explain"`                       |
-| `claude -c`                     | 現在のディレクトリで最新の会話を続行                                                                                                                                                                                                                                                                                                                                                                                                                   | `claude -c`                                                 |
-| `claude -c -p "query"`          | SDK 経由で続行                                                                                                                                                                                                                                                                                                                                                                                                                            | `claude -c -p "Check for type errors"`                      |
-| `claude -r "<session>" "query"` | セッション ID または名前でセッションを再開                                                                                                                                                                                                                                                                                                                                                                                                              | `claude -r "auth-refactor" "Finish this PR"`                |
-| `claude update`                 | 最新バージョンに更新                                                                                                                                                                                                                                                                                                                                                                                                                           | `claude update`                                             |
-| `claude install [version]`      | ネイティブバイナリをインストールまたは再インストールします。`2.1.118` のようなバージョン、または `stable` または `latest` を受け入れます。[特定のバージョンをインストール](/ja/setup#install-a-specific-version) を参照してください                                                                                                                                                                                                                                                                                | `claude install stable`                                     |
-| `claude auth login`             | Anthropic アカウントにサインインします。`--email` を使用してメールアドレスを事前入力し、`--sso` を使用して SSO 認証を強制し、`--console` を使用して Claude サブスクリプションの代わりに Anthropic Console で API 使用料金をサインインできます                                                                                                                                                                                                                                                                        | `claude auth login --console`                               |
-| `claude auth logout`            | Anthropic アカウントからログアウト                                                                                                                                                                                                                                                                                                                                                                                                               | `claude auth logout`                                        |
-| `claude auth status`            | 認証ステータスを JSON として表示します。`--text` を使用して人間が読める形式で表示できます。ログイン済みの場合はコード 0 で終了し、ログインしていない場合は 1 で終了します                                                                                                                                                                                                                                                                                                                                      | `claude auth status`                                        |
-| `claude agents`                 | [エージェントビュー](/ja/agent-view) を開いて、並列バックグラウンドセッションを監視およびディスパッチします。`--cwd <path>` を使用して、そのディレクトリの下で開始されたセッションのみを表示するか、`--json` を使用してライブセッションを JSON 配列として出力してスクリプト作成用にします。`--permission-mode`、`--model`、または `--effort` を渡して、[ディスパッチされたセッションのデフォルト](/ja/agent-view#permission-mode-model-and-effort) を設定します。トップレベルの `claude` コマンドと同様に `--settings`、`--add-dir`、`--plugin-dir`、および `--mcp-config` を受け入れます。エージェントビューを開くにはインタラクティブターミナルが必要です | `claude agents --json`                                      |
-| `claude attach <id>`            | このターミナルで [バックグラウンドセッション](/ja/agent-view#manage-sessions-from-the-shell) に接続します                                                                                                                                                                                                                                                                                                                                                       | `claude attach 7c5dcf5d`                                    |
-| `claude auto-mode defaults`     | 組み込み [auto mode](/ja/permission-modes#eliminate-prompts-with-auto-mode) 分類器ルールを JSON として出力します。`claude auto-mode config` を使用して、設定が適用された有効な設定を確認してください                                                                                                                                                                                                                                                                                 | `claude auto-mode defaults > rules.json`                    |
-| `claude daemon status`          | バックグラウンドセッション [スーパーバイザー](/ja/agent-view#the-supervisor-process) の状態、バージョン、ソケットディレクトリ、および診断用のワーカー数を出力します。スーパーバイザーが実行されていない場合は 1 で終了します                                                                                                                                                                                                                                                                                                | `claude daemon status`                                      |
-| `claude logs <id>`              | [バックグラウンドセッション](/ja/agent-view#manage-sessions-from-the-shell) からの最近の出力を出力します                                                                                                                                                                                                                                                                                                                                                        | `claude logs 7c5dcf5d`                                      |
-| `claude mcp`                    | Model Context Protocol（MCP）サーバーを設定                                                                                                                                                                                                                                                                                                                                                                                                   | [Claude Code MCP ドキュメント](/ja/mcp) を参照してください。                |
-| `claude plugin`                 | Claude Code [plugins](/ja/plugins) を管理します。エイリアス：`claude plugins`。サブコマンドについては [plugin reference](/ja/plugins-reference#cli-commands-reference) を参照してください                                                                                                                                                                                                                                                                              | `claude plugin install code-review@claude-plugins-official` |
-| `claude project purge [path]`   | プロジェクトのすべてのローカル Claude Code 状態を削除します：トランスクリプト、タスクリスト、デバッグログ、ファイル編集履歴、プロンプト履歴行、および `~/.claude.json` 内のプロジェクトエントリ。`[path]` を省略して、インタラクティブリストから選択します。フラグ：`--dry-run` でプレビュー、`-y`/`--yes` で確認をスキップ、`-i`/`--interactive` で各項目を確認、`--all` ですべてのプロジェクト。[ローカルデータをクリア](/ja/claude-directory#clear-local-data) を参照してください                                                                                                                       | `claude project purge ~/work/repo --dry-run`                |
-| `claude remote-control`         | [Remote Control](/ja/remote-control) サーバーを開始して、Claude.ai または Claude アプリから Claude Code を制御します。サーバーモード（ローカルインタラクティブセッションなし）で実行されます。[サーバーモードフラグ](/ja/remote-control#start-a-remote-control-session) を参照してください                                                                                                                                                                                                                           | `claude remote-control --name "My Project"`                 |
```

</details>

<details>
<summary>errors-ja.md</summary>

```diff
diff --git a/docs-ja/pages/errors-ja.md b/docs-ja/pages/errors-ja.md
index 96510d9..19be8c5 100644
--- a/docs-ja/pages/errors-ja.md
+++ b/docs-ja/pages/errors-ja.md
@@ -570,5 +570,5 @@ Claude Opus is not available with the Claude Pro plan · Select a different mode
 ### thinking.type.enabled is not supported for this model
 
-Claude Code バージョンが Opus 4.7 の最小値より古いです。CLI は、モデルが受け入れなくなった思考設定を送信しました。
+Claude Code バージョンが Opus 4.7 または Opus 4.8 の最小値より古いです。CLI は、モデルが受け入れなくなった思考設定を送信しました。
 
 ```text theme={null}
@@ -578,5 +578,5 @@ API Error: 400 ... "thinking.type.enabled" is not supported for this model. Use
 **対応方法：**
 
-* `claude update` を実行して v2.1.111 以降にアップグレードしてから、Claude Code を再起動してください
+* `claude update` を実行して Claude Code を再起動してください。Opus 4.7 は v2.1.111 以降が必要です。Opus 4.8 は v2.1.154 以降が必要です
 * アップグレードできない場合は、`/model` を実行して Opus 4.6 または Sonnet を選択してください
 * Agent SDK でこれに遭遇した場合は、[SDK トラブルシューティング](/ja/agent-sdk/quickstart#troubleshooting)を参照してください
@@ -611,4 +611,5 @@ API Error: 400 ... thinking blocks ... cannot be modified
 **対応方法：**
 
+* {/* max-version: 2.1.155 */}Opus 4.7 または Opus 4.8 を使用している場合は、まず `claude update` を実行してください。v2.1.156 より前のバージョンは、通常のツール使用中にこのエラーをトリガーでき、`/rewind` はそれをクリアしません。
 * `/rewind` を実行するか、Esc を 2 回押して、破損したターンの前のチェックポイントに戻り、そこから続行してください。[チェックポイント](/ja/checkpointing)を参照して、チェックポイントがどのように作成および復元されるかを確認してください。
 
```

</details>

<details>
<summary>interactive-mode-ja.md</summary>

```diff
diff --git a/docs-ja/pages/interactive-mode-ja.md b/docs-ja/pages/interactive-mode-ja.md
index fbf44d3..21d766f 100644
--- a/docs-ja/pages/interactive-mode-ja.md
+++ b/docs-ja/pages/interactive-mode-ja.md
@@ -23,24 +23,24 @@
 ### 一般的なコントロール
 
-| ショートカット                                          | 説明                                                                                                                | コンテキスト                                                                                                                                                                                 |
-| :----------------------------------------------- | :---------------------------------------------------------------------------------------------------------------- | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
-| `Ctrl+C`                                         | 割り込み、または入力をクリア                                                                                                    | 実行中の操作を割り込みます。何も実行されていない場合、最初の押下でプロンプト入力をクリアし、2 回目の押下で Claude Code を終了します                                                                                                              |
-| `Ctrl+X Ctrl+K`                                  | このセッション内のすべてのバックグラウンド [サブエージェント](/ja/sub-agents#run-subagents-in-foreground-or-background) を終了します。3 秒以内に 2 回押して確認 | サブエージェント制御                                                                                                                                                                             |
-| `Ctrl+D`                                         | Claude Code セッションを終了                                                                                              | EOF シグナル                                                                                                                                                                               |
-| `Ctrl+G` または `Ctrl+X Ctrl+E`                     | デフォルトテキストエディタで開く                                                                                                  | プロンプトまたはカスタム応答をデフォルトテキストエディタで編集します。`Ctrl+X Ctrl+E` は readline ネイティブバインディングです。`/config` で「外部エディタで最後の応答を表示」をオンにすると、Claude の前の応答を `#` でコメント化されたコンテキストとしてプロンプトの上に追加します。保存時にコメントブロックは削除されます |
-| `Ctrl+L`                                         | 画面を再描画                                                                                                            | 完全なターミナル再描画を強制します。入力と会話履歴は保持されます。ディスプレイが破損したり部分的に空白になった場合に、これを使用して復旧します                                                                                                                |
-| `Ctrl+O`                                         | トランスクリプトビューアを切り替え                                                                                                 | 詳細なツール使用と実行を表示します。また MCP 呼び出しを展開します。デフォルトでは「Slack を 3 回呼び出し」のような 1 行に折りたたまれます                                                                                                          |
-| `Ctrl+R`                                         | コマンド履歴を逆順検索                                                                                                       | 前のコマンドをインタラクティブに検索                                                                                                                                                                     |
-| `Ctrl+V` または `Cmd+V`（iTerm2）または `Alt+V`（Windows） | クリップボードから画像を貼り付け                                                                                                  | カーソルに `[Image #N]` チップを挿入して、プロンプト内で位置的に参照できます                                                                                                                                          |
-| `Ctrl+B`                                         | バックグラウンドで実行中のタスク                                                                                                  | bash コマンドとエージェントをバックグラウンドで実行します。Tmux ユーザーは 2 回押す                                                                                                                                       |
-| `Ctrl+T`                                         | タスクリストを切り替え                                                                                                       | ターミナルステータス領域の [タスクリスト](#task-list) を表示または非表示                                                                                                                                           |
-| `Left/Right 矢印`                                  | ダイアログタブを循環                                                                                                        | 権限ダイアログとメニューのタブ間を移動                                                                                                                                                                    |
-| `Up/Down 矢印` または `Ctrl+P`/`Ctrl+N`               | カーソルを移動またはコマンド履歴を移動                                                                                               | 複数行入力では、最初にカーソルをプロンプト内で移動します。カーソルが既に上端または下端にある場合、もう一度押すとコマンド履歴を移動します                                                                                                                   |
-| `Esc`                                            | Claude を割り込み                                                                                                      | 現在の応答またはツール呼び出しを途中で停止して、リダイレクトできます。Claude はこれまでの作業を保持します                                                                                                                               |
-| `Esc` + `Esc`                                    | 入力ドラフトをクリア、または巻き戻し                                                                                                | プロンプト入力にテキストが含まれている場合、ダブル `Esc` でクリアし、ドラフトを履歴に保存して `Up` で呼び出せます。入力が空の場合、ダブル `Esc` で [巻き戻しメニュー](/ja/checkpointing) を開き、前の時点からコードと会話を復元または要約できます                                         |
-| `Shift+Tab` または `Alt+M`（一部の設定）                   | 権限モードを切り替え                                                                                                        | `default`、`acceptEdits`、`plan`、および `auto` や `bypassPermissions` などの有効にしたモード間を循環します。[権限モード](/ja/permission-modes) を参照してください。                                                            |
-| `Option+P`（macOS）または `Alt+P`（Windows/Linux）      | モデルを切り替え                                                                                                          | プロンプトをクリアせずにモデルを切り替え                                                                                                                                                                   |
-| `Option+T`（macOS）または `Alt+T`（Windows/Linux）      | 拡張思考を切り替え                                                                                                         | 拡張思考モードを有効または無効にします。{/* min-version: 2.1.132 */}v2.1.132 以降、このショートカットは macOS で Option を Meta として設定しなくても機能します                                                                           |
-| `Option+O`（macOS）または `Alt+O`（Windows/Linux）      | 高速モードを切り替え                                                                                                        | [高速モード](/ja/fast-mode) を有効または無効にします                                                                                                                                                    |
+| ショートカット                                                  | 説明                                                                                                                | コンテキスト                                                                                                                                                                                 |
+| :------------------------------------------------------- | :---------------------------------------------------------------------------------------------------------------- | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
+| `Ctrl+C`                                                 | 割り込み、または入力をクリア                                                                                                    | 実行中の操作を割り込みます。何も実行されていない場合、最初の押下でプロンプト入力をクリアし、2 回目の押下で Claude Code を終了します                                                                                                              |
```

</details>

<details>
<summary>keybindings-ja.md</summary>

```diff
diff --git a/docs-ja/pages/keybindings-ja.md b/docs-ja/pages/keybindings-ja.md
index c5e304b..3fc87cf 100644
--- a/docs-ja/pages/keybindings-ja.md
+++ b/docs-ja/pages/keybindings-ja.md
@@ -115,5 +115,5 @@ Claude Code はカスタマイズ可能なキーボードショートカット
 | `chat:externalEditor` | Ctrl+G、Ctrl+X Ctrl+E     | 外部エディタで開く                                                                                                 |
 | `chat:stash`          | Ctrl+S                   | 現在のプロンプトを保存                                                                                               |
-| `chat:imagePaste`     | Ctrl+V（Windows では Alt+V） | 画像を貼り付け                                                                                                   |
+| `chat:imagePaste`     | Ctrl+V（Windows では Alt+V） | クリップボードから画像を貼り付けます。WSL では、両方のショートカットがデフォルトでバインドされています                                                     |
 
 \*VT モードなし（Node \<24.2.0/\<22.17.0、Bun \<1.2.23）の Windows では、デフォルトは Meta+M です。
@@ -150,7 +150,7 @@ Claude Code はカスタマイズ可能なキーボードショートカット
 権限ダイアログの `Confirmation` コンテキストで利用可能なアクション：
 
-| アクション                    | デフォルト    | 説明                                                                             |
-| :----------------------- | :------- | :----------------------------------------------------------------------------- |
-| `permission:toggleDebug` | （アンバインド） | 権限デバッグ情報を切り替え。Ctrl+D の以前のデフォルトは v2.1.146 で削除されました。これは `app:exit` をシャドウしていたためです |
+| アクション                    | デフォルト    | 説明                                                                               |
+| :----------------------- | :------- | :------------------------------------------------------------------------------- |
+| `permission:toggleDebug` | （アンバインド） | 権限デバッグ情報を切り替えます。Ctrl+D の以前のデフォルトは v2.1.146 で削除されました。これは `app:exit` をシャドウしていたためです |
 
 ### トランスクリプトアクション
```

</details>

<details>
<summary>mcp-ja.md</summary>

```diff
diff --git a/docs-ja/pages/mcp-ja.md b/docs-ja/pages/mcp-ja.md
index 5137c41..9d13b27 100644
--- a/docs-ja/pages/mcp-ja.md
+++ b/docs-ja/pages/mcp-ja.md
@@ -481,4 +481,6 @@ orders テーブルのスキーマを表示してください
 Claude Code は、サーバーが `401 Unauthorized` または `403 Forbidden` で応答するときに、リモートサーバーが認証を必要とするとマークします。どちらのステータスコードでも、サーバーは `/mcp` でフラグが立てられ、OAuth フローを完了できます。認可サーバーを指す `WWW-Authenticate` ヘッダーを返すカスタムサーバーは、他のリモートサーバーと同じ自動検出を取得します。
 
+`headers.Authorization` をサーバー用に設定し、サーバーがそのヘッダーを拒否する場合、Claude Code は OAuth にフォールバックするのではなく、接続が失敗したと報告します。トークンが MCP エンドポイント用に有効であることを確認するか、OAuth フローを使用するためにヘッダーを削除してください。
+
 <Steps>
   <Step title="認証が必要なサーバーを追加する">
```

</details>

*...以降省略*

</details>


<details>
<summary>2026-05-30</summary>

**変更ファイル:**

```
 docs-ja/pages/changelog.md              | 40 ++++++++++++++++++
 docs-ja/pages/desktop-ja.md             |  8 ++--
 docs-ja/pages/env-vars-ja.md            | 10 ++---
 docs-ja/pages/hooks-ja.md               | 18 ++++----
 docs-ja/pages/mcp-ja.md                 | 19 ++++++++-
 docs-ja/pages/plugin-marketplaces-ja.md | 39 +++++++++--------
 docs-ja/pages/skills-ja.md              |  2 +-
 docs-ja/pages/statusline-ja.md          | 74 ++++++++++++++++-----------------
 docs-ja/pages/tools-reference-ja.md     |  1 +
 9 files changed, 135 insertions(+), 76 deletions(-)
```

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index 92ea9fb..c29830e 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,44 @@
 # Changelog
 
+## 2.1.157
+
+- Plugins in `.claude/skills` directories are now automatically loaded, no marketplace required
+- Added `claude plugin init <name>` to scaffold a new plugin in `.claude/skills`
+- Added autocomplete for `/plugin` arguments: subcommands, installed plugin names, and plugins from known marketplaces
+- `claude agents`: the `agent` field in `settings.json` is now honored for dispatched sessions, with `--agent <name>` to override it
+- `EnterWorktree` can now switch between Claude-managed worktrees mid-session
+- `tool_decision` telemetry events now include `tool_parameters` (bash commands, MCP/skill names) when `OTEL_LOG_TOOL_DETAILS=1`
+- Worktrees managed by Claude are now left unlocked when the agent finishes, so `git worktree remove`/`prune` can clean them up
+- Fixed unprocessable images (zero-byte, corrupt) attached via paste, MCP, or dialog crashing the request instead of becoming a text placeholder
+- Fixed sandbox network permission prompts appearing in auto and bypass-permissions mode when using the desktop app, IDE extensions, or SDK
+- Fixed `claude agents` completed sessions not retiring when an idle subagent was still parked or had leaked a backgrounded shell
+- Fixed `claude agents` pressing Esc not cancelling a slow "opening…", leaving the list unresponsive
+- Fixed background agent worktrees under `.claude/worktrees/` being orphaned after the 30-day job retention sweep
+- Fixed background sessions re-attached after a sleep/wake not telling the model the correct date
+- Fixed copy-on-select in `claude agents` not reaching the system clipboard inside tmux with `set-clipboard on` (regression in 2.1.153)
+- Fixed `--resume` not reporting background subagents that were running when the previous Claude Code process exited
+- Fixed the `--resume` session picker leaving its contents on the terminal after exiting in fullscreen mode
+- Fixed `--worktree` and `--worktree --tmux` returning to the canonical repo root instead of the current linked worktree
+- Fixed the `/model` picker showing an incorrect "Newer version available" hint when the selected model is already the newest in its family; the pinned-model row now shows the model's description instead of its raw ID
+- Fixed literal markdown markers (backticks, asterisks) appearing in the in-progress message text in fullscreen mode
+- Fixed the terminal freezing after approving the managed-settings security dialog at startup
+- Fixed a rare duplicate line appearing in scrollback after the terminal UI redraws
```

</details>

<details>
<summary>desktop-ja.md</summary>

```diff
diff --git a/docs-ja/pages/desktop-ja.md b/docs-ja/pages/desktop-ja.md
index f6e577d..ecba628 100644
--- a/docs-ja/pages/desktop-ja.md
+++ b/docs-ja/pages/desktop-ja.md
@@ -79,5 +79,5 @@ Claude に実行させたいことを入力して**Enter**キーを押して送
 <span id="auto-mode-availability" />
 
-Auto mode は Anthropic API のすべてのユーザーが利用できる研究プレビューです。サードパーティプロバイダーでは利用できません。Claude Sonnet 4.6、Opus 4.6、または Opus 4.7 が必要です。
+Auto mode は Anthropic API のすべてのユーザーが利用できる研究プレビューです。サードパーティプロバイダーでは利用できません。Claude Opus 4.6 以降、または Sonnet 4.6 が必要です。
 
 <Tip title="ベストプラクティス">
@@ -307,5 +307,5 @@ macOS で\*\*Cmd+;**を、Windows で**Ctrl+;\*\*を押してサイドチャッ
 ### バックグラウンドタスクを監視する
 
-タスクペインは、現在のセッション内で実行されているバックグラウンド作業を表示します：サブエージェント、バックグラウンドシェルコマンド、および動的ワークフロー。**Views**メニューから開くか、レイアウトにドラッグします。
+タスクペインは、現在のセッション内で実行されているバックグラウンド作業を表示します：サブエージェント、バックグラウンドシェルコマンド、および[動的ワークフロー](/ja/workflows)。**Views**メニューから開くか、レイアウトにドラッグします。
 
 任意のエントリをクリックして、サブエージェントペインで出力を確認するか、停止します。他のセッションが何をしているかを確認するには、[サイドバー](#work-in-parallel-with-sessions)を使用します。
@@ -521,5 +521,5 @@ Claude が別のポートを選択すると、割り当てられたポートを`
 ローカルセッションと dev サーバーの環境変数を設定するには、プロンプトボックスの環境ドロップダウンを開き、**Local** にマウスを合わせて、ギアアイコンをクリックしてローカル環境エディタを開きます。ここで保存する変数は、マシンに暗号化されて保存され、開始するすべてのローカルセッションとプレビューサーバーに適用されます。また、`~/.claude/settings.json` ファイルの `env` キーに変数を追加することもできます。ただし、これらは Claude セッションにのみ到達し、dev サーバーには到達しません。サポートされている変数の完全なリストについては、[環境変数](/ja/env-vars)を参照してください。
 
-[拡張思考](/ja/model-config#extended-thinking)はデフォルトで有効になっており、複雑な推論タスクのパフォーマンスを向上させますが、追加のトークンを使用します。思考を完全に無効にするには、ローカル環境エディタで `MAX_THINKING_TOKENS` を `0` に設定します。[適応的推論](/ja/model-config#adjust-effort-level)を持つモデルでは、適応的推論が思考の深さを制御するため、他の `MAX_THINKING_TOKENS` 値は無視されます。Opus 4.6 と Sonnet 4.6 では、固定思考予算を使用するために `CLAUDE_CODE_DISABLE_ADAPTIVE_THINKING` を `1` に設定します。Opus 4.7 は常に適応的推論を使用し、固定予算モードはありません。
+[拡張思考](/ja/model-config#extended-thinking)はデフォルトで有効になっており、複雑な推論タスクのパフォーマンスを向上させますが、追加のトークンを使用します。思考を完全に無効にするには、ローカル環境エディタで `MAX_THINKING_TOKENS` を `0` に設定します。[適応的推論](/ja/model-config#adjust-effort-level)を持つモデルでは、適応的推論が思考の深さを制御するため、他の `MAX_THINKING_TOKENS` 値は無視されます。Opus 4.6 と Sonnet 4.6 では、固定思考予算を使用するために `CLAUDE_CODE_DISABLE_ADAPTIVE_THINKING` を `1` に設定します。Opus 4.7 以降は常に適応的推論を使用し、固定予算モードはありません。
 
 ### リモートセッション
@@ -707,5 +707,5 @@ Desktop と CLI は同じ設定ファイルを読み取るため、セットア
 * **Linux**：デスクトップアプリは macOS と Windows でのみ利用可能です。Linux では、[CLI](/ja/quickstart)を使用します。
 * **インラインコード提案**：Desktop はオートコンプリートスタイルの提案を提供しません。会話型プロンプトと明示的なコード変更を通じて機能します。
-* **エージェントチーム**：マルチエージェントオーケストレーションは [CLI](/ja/agent-teams) および [Agent SDK](/ja/headless) を通じて利用可能であり、Desktop では利用できません。
+* **エージェントチーム**：並列 Claude Code セッションが互いにメッセージを送信するのは [CLI](/ja/agent-teams) で利用可能であり、Desktop では利用できません。1 つのセッション内でマルチエージェント作業を行う場合は、[動的ワークフロー](/ja/workflows)を使用します。これは Desktop で実行されます。
```

</details>

<details>
<summary>env-vars-ja.md</summary>

```diff
diff --git a/docs-ja/pages/env-vars-ja.md b/docs-ja/pages/env-vars-ja.md
index 2eb4ae0..a733204 100644
--- a/docs-ja/pages/env-vars-ja.md
+++ b/docs-ja/pages/env-vars-ja.md
@@ -130,5 +130,5 @@ Claude Code は起動時に環境変数を読み取るため、変更は `claude
 | `BASH_MAX_TIMEOUT_MS`                                   | 長時間実行される bash コマンドに対してモデルが設定できる最大タイムアウト（デフォルト：600000、または 10 分）                                                                                                                                                                                                                                                                                                                                                                 |
 | `CCR_FORCE_BUNDLE`                                      | GitHub アクセスが利用可能な場合でも、[`claude --remote`](/ja/claude-code-on-the-web#send-local-repositories-without-github) がローカルリポジトリをバンドルしてアップロードするよう強制するには `1` に設定します                                                                                                                                                                                                                                                                      |
-| `CLAUDECODE`                                            | Claude Code がスポーンするサブプロセス（Bash と PowerShell ツール、tmux セッション、[フック](/ja/hooks) コマンド、[ステータスライン](/ja/statusline) コマンド）で `1` に設定されます。スクリプトが Claude Code によってスポーンされたサブプロセス内で実行されているかどうかを検出するために使用します                                                                                                                                                                                                                                  |
+| `CLAUDECODE`                                            | Claude Code がスポーンするサブプロセス（Bash と PowerShell ツール、tmux セッション、[フック](/ja/hooks) コマンド、[ステータスライン](/ja/statusline) コマンド、stdio [MCP サーバー](/ja/mcp) サブプロセス）で `1` に設定されます。スクリプトが Claude Code によってスポーンされたサブプロセス内で実行されているかどうかを検出するために使用します                                                                                                                                                                                                 |
 | `CLAUDE_AGENT_SDK_DISABLE_BUILTIN_AGENTS`               | すべての組み込み [subagent](/ja/sub-agents) タイプ（Explore や Plan など）を無効にするには `1` に設定します。非対話モード（`-p` フラグ）でのみ適用されます。SDK ユーザーが白紙の状態を望む場合に役立ちます                                                                                                                                                                                                                                                                                              |
 | `CLAUDE_AGENT_SDK_MCP_NO_PREFIX`                        | SDK で作成された MCP サーバーからのツール名の `mcp__<server>__` プレフィックスをスキップするには `1` に設定します。ツールは元の名前を使用します。SDK 使用のみ                                                                                                                                                                                                                                                                                                                              |
@@ -139,5 +139,5 @@ Claude Code は起動時に環境変数を読み取るため、変更は `claude
 | `CLAUDE_CODE_ACCESSIBILITY`                             | ネイティブターミナルカーソルを表示したままにし、反転テキストカーソルインジケーターを無効にするには `1` に設定します。macOS Zoom などのスクリーンマグニファイアーがカーソル位置を追跡できるようにします                                                                                                                                                                                                                                                                                                                    |
 | `CLAUDE_CODE_ADDITIONAL_DIRECTORIES_CLAUDE_MD`          | `--add-dir` で指定されたディレクトリからメモリファイルを読み込むには `1` に設定します。`CLAUDE.md`、`.claude/CLAUDE.md`、`.claude/rules/*.md`、および `CLAUDE.local.md` を読み込みます。デフォルトでは、追加ディレクトリはメモリファイルを読み込みません                                                                                                                                                                                                                                                        |
-| `CLAUDE_CODE_ALT_SCREEN_FULL_REPAINT`                   | [フルスクリーンレンダリング](/ja/fullscreen) で増分更新を送信する代わりに、すべてのフレームで画面全体を再描画するには `1` に設定します。フルスクリーンモードで古いテキストまたは配置が間違ったテキストフラグメントが表示される場合に使用します。Claude Code は Windows のバックグラウンドセッションでこれを自動的に有効にします                                                                                                                                                                                                                                         |
+| `CLAUDE_CODE_ALT_SCREEN_FULL_REPAINT`                   | [フルスクリーンレンダリング](/ja/fullscreen) で増分更新を送信する代わりに、すべてのフレームで画面全体を再描画するには `1` に設定します。フルスクリーンモードで古いテキストまたは配置が間違ったテキストフラグメントが表示される場合に使用します。Claude Code は Windows のバックグラウンドセッションと [エージェントビュー](/ja/agent-view) でこれを自動的に有効にします                                                                                                                                                                                                           |
 | `CLAUDE_CODE_API_KEY_HELPER_TTL_MS`                     | 認証情報をリフレッシュする間隔（ミリ秒）（[`apiKeyHelper`](/ja/settings#available-settings) を使用する場合）                                                                                                                                                                                                                                                                                                                                                |
 | `CLAUDE_CODE_ATTRIBUTION_HEADER`                        | システムプロンプトの開始から属性ブロック（クライアントバージョンとプロンプトフィンガープリント）を省略するには `0` に設定します。これを無効にすると、[LLM ゲートウェイ](/ja/llm-gateway) を通じてルーティングする場合のプロンプトキャッシュヒット率が向上します。Anthropic API キャッシングは影響を受けません                                                                                                                                                                                                                                                   |
@@ -151,5 +151,5 @@ Claude Code は起動時に環境変数を読み取るため、変更は `claude
 | `CLAUDE_CODE_DEBUG_LOG_LEVEL`                           | デバッグログファイルに書き込まれる最小ログレベル。値：`verbose`、`debug`（デフォルト）、`info`、`warn`、`error`。フルステータスラインコマンド出力などの大量の診断を含めるには `verbose` に設定するか、ノイズを減らすには `error` に上げます                                                                                                                                                                                                                                                                              |
 | `CLAUDE_CODE_DISABLE_1M_CONTEXT`                        | [1M コンテキストウィンドウ](/ja/model-config#extended-context) サポートを無効にするには `1` に設定します。設定すると、1M モデルバリアントはモデルピッカーで利用できなくなります。コンプライアンス要件のあるエンタープライズ環境に役立ちます                                                                                                                                                                                                                                                                                 |
-| `CLAUDE_CODE_DISABLE_ADAPTIVE_THINKING`                 | Opus 4.6 と Sonnet 4.6 の [適応的推論](/ja/model-config#adjust-effort-level) を無効にするには `1` に設定します。`MAX_THINKING_TOKENS` で制御される固定思考予算にフォールバックします。{/* min-version: 2.1.111 */}Opus 4.7 では効果がなく、常に適応的推論を使用します                                                                                                                                                                                                                             |
+| `CLAUDE_CODE_DISABLE_ADAPTIVE_THINKING`                 | Opus 4.6 と Sonnet 4.6 の [適応的推論](/ja/model-config#adjust-effort-level) を無効にするには `1` に設定します。`MAX_THINKING_TOKENS` で制御される固定思考予算にフォールバックします。{/* min-version: 2.1.111 */}Opus 4.7 以降では効果がなく、常に適応的推論を使用します                                                                                                                                                                                                                           |
 | `CLAUDE_CODE_DISABLE_AGENT_VIEW`                        | [バックグラウンドエージェントとエージェントビュー](/ja/agent-view) をオフにするには `1` に設定します：`claude agents`、`--bg`、`/background`、およびオンデマンドスーパーバイザー。[`disableAgentView`](/ja/settings#available-settings) 設定と同等です                                                                                                                                                                                                                                            |
 | `CLAUDE_CODE_DISABLE_ALTERNATE_SCREEN`                  | [フルスクリーンレンダリング](/ja/fullscreen) を無効にするには `1` に設定します。クラシックなメインスクリーンレンダラーを使用します。会話はターミナルのネイティブなスクロールバックに留まるため、`Cmd+f` と tmux コピーモードが通常通り機能します。`CLAUDE_CODE_NO_FLICKER` と [`tui`](/ja/settings#available-settings) 設定より優先されます。`/tui default` で切り替えることもできます                                                                                                                                                                        |
@@ -232,5 +232,5 @@ Claude Code は起動時に環境変数を読み取るため、変更は `claude
 | `CLAUDE_CODE_SCROLL_SPEED`                              | [フルスクリーンレンダリング](/ja/fullscreen) でマウスホイールスクロール乗数を設定します。1～20 の値を受け入れます。ターミナルが増幅なしで 1 ノッチあたり 1 つのホイールイベントを送信する場合、`vim` に一致させるには `3` に設定します。JetBrains IDE ターミナルでは無視されます。Claude Code は独自のスクロール処理を使用します                                                                                                                                                                                                                              |
 | `CLAUDE_CODE_SESSIONEND_HOOKS_TIMEOUT_MS`               | [SessionEnd](/ja/hooks#sessionend) フックの時間予算をオーバーライドします（ミリ秒）。セッション終了、`/clear`、および対話的な `/resume` を通じたセッション切り替えに適用されます。デフォルトでは予算は 1.5 秒で、設定ファイルで設定されたフックごとの最高 `timeout` に自動的に引き上げられます。最大 60 秒。プラグイン提供フックのタイムアウトは予算を引き上げません                                                                                                                                                                                                        |
-| `CLAUDE_CODE_SESSION_ID`                                | Bash と PowerShell ツールサブプロセスで現在のセッション ID に自動的に設定されます。[フック](/ja/hooks) に渡される `session_id` フィールドと一致します。`/clear` で更新されます。スクリプトと外部ツールを Claude Code セッションと相関させるために使用します                                                                                                                                                                                                                                                              |
+| `CLAUDE_CODE_SESSION_ID`                                | Bash と PowerShell ツールサブプロセスで現在のセッション ID に自動的に設定されます。[フック](/ja/hooks) コマンドサブプロセスと stdio [MCP サーバー](/ja/mcp) サブプロセスでも設定されます。フックに渡される `session_id` フィールドと一致します。`/clear` で更新されます。スクリプトと外部ツールを Claude Code セッションと相関させるために使用します                                                                                                                                                                                                      |
```

</details>

<details>
<summary>hooks-ja.md</summary>

```diff
diff --git a/docs-ja/pages/hooks-ja.md b/docs-ja/pages/hooks-ja.md
index 20e405f..92824ae 100644
--- a/docs-ja/pages/hooks-ja.md
+++ b/docs-ja/pages/hooks-ja.md
@@ -446,5 +446,5 @@ MCP ツール フックは、Claude Code が MCP サーバーに接続した後
 フックが実行されるときの作業ディレクトリに関係なく、プロジェクトまたはプラグイン ルートを基準にしてフック スクリプトを参照するには、これらのプレースホルダーを使用します。
 
-* `${CLAUDE_PROJECT_DIR}`: プロジェクト ルート。
+* `${CLAUDE_PROJECT_DIR}`: プロジェクト ルート。Claude Code はこの変数を[stdio MCP サーバー](/ja/mcp#option-3-add-a-local-stdio-server)とプラグイン LSP サーバーの環境にも設定します。
 * `${CLAUDE_PLUGIN_ROOT}`: プラグインのインストール ディレクトリ、[プラグイン](/ja/plugins)にバンドルされたスクリプト用。プラグイン更新時に変更されます。
 * `${CLAUDE_PLUGIN_DATA}`: プラグインの[永続データ ディレクトリ](/ja/plugins-reference#persistent-data-directory)、プラグイン更新を通じて存続すべき依存関係と状態用。
@@ -566,12 +566,12 @@ macOS と Linux では、コマンド フックは v2.1.139 以降、制御端
 フック イベントは、各[フック イベント](#hook-events)セクションで説明されているイベント固有のフィールドに加えて、これらのフィールドを JSON として受け取ります。コマンド フックの場合、この JSON は stdin 経由で到着します。HTTP フックの場合、POST リクエスト本体として到着します。
 
-| フィールド             | 説明                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
-| :---------------- | :-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
-| `session_id`      | 現在のセッション識別子                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
-| `transcript_path` | 会話 JSON へのパス                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
-| `cwd`             | フックが呼び出されるときの現在の作業ディレクトリ                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
-| `permission_mode` | 現在の[権限モード](/ja/permissions#permission-modes): `"default"`、`"plan"`、`"acceptEdits"`、`"auto"`、`"dontAsk"`、または `"bypassPermissions"`。すべてのイベントがこのフィールドを受け取るわけではありません。各イベントの JSON 例を確認してください                                                                                                                                                                                                                                                                                                                                           |
-| `effort`          | アクティブな[努力レベル](/ja/model-config#adjust-effort-level)を保持する `level` フィールドを持つオブジェクト。ターンの場合: `"low"`、`"medium"`、`"high"`、`"xhigh"`、`"max"`、または `"ultra"`。リクエストされたモデル努力が現在のモデルがサポートしているものを超える場合、これはモデルが実際に使用したダウングレードされたレベルです。`"ultra"` は ultracode の保存値であり、モデルが `xhigh` を受け取る場合でもここで報告されます。オブジェクトは[ステータス ライン](/ja/statusline#available-data)の `effort` フィールドと一致します。`PreToolUse`、`PostToolUse`、`Stop`、`SubagentStop` などのツール使用コンテキスト内で発火するイベント、および現在のモデルが努力パラメータをサポートする場合に存在します。レベルは、フック コマンドと Bash ツールに `$CLAUDE_EFFORT` 環境変数として利用可能です。 |
-| `hook_event_name` | 発火したイベントの名前                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
+| フィールド             | 説明                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
+| :---------------- | :-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
+| `session_id`      | 現在のセッション識別子                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
+| `transcript_path` | 会話 JSON へのパス                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
+| `cwd`             | フックが呼び出されるときの現在の作業ディレクトリ                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
+| `permission_mode` | 現在の[権限モード](/ja/permissions#permission-modes): `"default"`、`"plan"`、`"acceptEdits"`、`"auto"`、`"dontAsk"`、または `"bypassPermissions"`。すべてのイベントがこのフィールドを受け取るわけではありません。各イベントの JSON 例を確認してください                                                                                                                                                                                                                                                                                                             |
+| `effort`          | アクティブな[努力レベル](/ja/model-config#adjust-effort-level)を保持する `level` フィールドを持つオブジェクト。ターンの場合: `"low"`、`"medium"`、`"high"`、`"xhigh"`、または `"max"`。リクエストされたモデル努力が現在のモデルがサポートしているものを超える場合、これはモデルが実際に使用したダウングレードされたレベルです。Ultracode は異なるレベルではなく、`"xhigh"` として報告されます。オブジェクトは[ステータス ライン](/ja/statusline#available-data)の `effort` フィールドと一致します。`PreToolUse`、`PostToolUse`、`Stop`、`SubagentStop` などのツール使用コンテキスト内で発火するイベント、および現在のモデルが努力パラメータをサポートする場合に存在します。レベルは、フック コマンドと Bash ツールに `$CLAUDE_EFFORT` 環境変数として利用可能です。 |
+| `hook_event_name` | 発火したイベントの名前                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
```

</details>

<details>
<summary>mcp-ja.md</summary>

```diff
diff --git a/docs-ja/pages/mcp-ja.md b/docs-ja/pages/mcp-ja.md
index cae9faf..5137c41 100644
--- a/docs-ja/pages/mcp-ja.md
+++ b/docs-ja/pages/mcp-ja.md
@@ -56,5 +56,5 @@ MCP サーバーが接続されている場合、Claude Code に以下のこと
 ## MCP サーバーのインストール
 
-MCP サーバーは、ニーズに応じて 3 つの異なる方法で設定できます：
+MCP サーバーは、ニーズに応じて複数の方法で設定できます：
 
 ### オプション 1：リモート HTTP サーバーを追加する
@@ -124,4 +124,17 @@ claude mcp add --transport stdio --env AIRTABLE_API_KEY=YOUR_KEY airtable \
 </Note>
 
+### オプション 4：リモート WebSocket サーバーを追加する
+
+WebSocket サーバーは永続的な双方向接続を保持し、Claude に予期しないイベントをプッシュするリモート MCP サーバーに適しています。サーバーがリクエストにのみ応答する場合は HTTP を使用してください。HTTP は OAuth と `claude mcp add --transport` フラグをサポートしていますが、WebSocket はどちらもサポートしていません。
+
+WebSocket サーバーを `.mcp.json` または `claude mcp add-json` で設定します：
+
+```bash theme={null}
+claude mcp add-json events-server \
+  '{"type":"ws","url":"wss://mcp.example.com/socket","headers":{"Authorization":"Bearer YOUR_TOKEN"}}'
+```
+
+`type: "ws"` エントリは `http` と同じ `url`、`headers`、`headersHelper`、`timeout`、`alwaysLoad` フィールドを受け入れます。認証はヘッダーのみなので、`headers` に静的トークンを渡すか、[`headersHelper`](#use-dynamic-headers-for-custom-authentication) で接続時に生成してください。`claude mcp add --transport` フラグは `ws` を受け入れません。
+
 ### サーバーの管理
 
@@ -142,4 +155,6 @@ claude mcp remove github
```

</details>

<details>
<summary>plugin-marketplaces-ja.md</summary>

```diff
diff --git a/docs-ja/pages/plugin-marketplaces-ja.md b/docs-ja/pages/plugin-marketplaces-ja.md
index 935b10b..32ee49b 100644
--- a/docs-ja/pages/plugin-marketplaces-ja.md
+++ b/docs-ja/pages/plugin-marketplaces-ja.md
@@ -155,9 +155,9 @@
 ### 必須フィールド
 
-| フィールド     | タイプ    | 説明                                                                                                                | 例              |
-| :-------- | :----- | :---------------------------------------------------------------------------------------------------------------- | :------------- |
-| `name`    | string | マーケットプレイス識別子（ケバブケース、スペースなし）。これは公開向けです。ユーザーはプラグインをインストールするときに表示されます（例：`/plugin install my-tool@your-marketplace`）。 | `"acme-tools"` |
-| `owner`   | object | マーケットプレイスメンテナー情報（[以下のフィールドを参照](#owner-fields)）                                                                    |                |
-| `plugins` | array  | 利用可能なプラグインのリスト                                                                                                    | 以下を参照          |
+| フィールド     | タイプ    | 説明                                                                                                                                                                                                                                                                                                                 | 例              |
+| :-------- | :----- | :----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :------------- |
+| `name`    | string | マーケットプレイス識別子（ケバブケース、スペースなし）。これは公開向けです。ユーザーはプラグインをインストールするときに表示されます（例：`/plugin install my-tool@your-marketplace`）。各ユーザーは、マーケットプレイス名ごとに 1 つのマーケットプレイスのみを登録できます。同じ名前の 2 番目のマーケットプレイスを追加すると、最初のマーケットプレイスが置き換わります。1 つのマーケットプレイス名の下に複数のプラグインを公開するには、すべてを [単一の `marketplace.json`](#create-the-marketplace-file) にリストします。 | `"acme-tools"` |
+| `owner`   | object | マーケットプレイスメンテナー情報（[以下のフィールドを参照](#owner-fields)）                                                                                                                                                                                                                                                                     |                |
+| `plugins` | array  | 利用可能なプラグインのリスト                                                                                                                                                                                                                                                                                                     | 以下を参照          |
 
 <Note>
@@ -199,17 +199,18 @@
 **標準メタデータフィールド：**
 
-| フィールド         | タイプ     | 説明                                                                                                                                                                               |
-| :------------ | :------ | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
-| `displayName` | string  | {/* min-version: 2.1.143 */}UI サーフェスに表示される人間が読める名前。省略された場合は `name` にフォールバックします。スペースと任意の大文字小文字を含めることができます。名前空間指定またはルックアップには使用されません。Claude Code v2.1.143 以降が必要です。                  |
-| `description` | string  | プラグインの簡潔な説明                                                                                                                                                                      |
-| `version`     | string  | プラグインバージョン。設定されている場合（ここまたは `plugin.json` で）、プラグインはこの文字列にピン留めされ、ユーザーは変更時にのみ更新を受け取ります。省略すると、git コミット SHA にフォールバックします。[バージョン解決](#version-resolution-and-release-channels)を参照してください。 |
-| `author`      | object  | プラグイン作成者情報（`name` は必須、`email` はオプション）                                                                                                                                            |
-| `homepage`    | string  | プラグインホームページまたはドキュメント URL                                                                                                                                                         |
-| `repository`  | string  | ソースコードリポジトリ URL                                                                                                                                                                  |
```

</details>

*...以降省略*

</details>


<details>
<summary>2026-05-29</summary>

**変更ファイル:**

```
 docs-ja/pages/agent-view-ja.md       | 24 +++++-----
 docs-ja/pages/agents-ja.md           | 36 ++++++++++-----
 docs-ja/pages/best-practices-ja.md   | 15 ++++---
 docs-ja/pages/changelog.md           | 86 ++++++++++++++++++++++++++++++++++++
 docs-ja/pages/claude-directory-ja.md | 82 ++++++++++++++++++++++------------
 docs-ja/pages/commands-ja.md         | 16 +++++--
 docs-ja/pages/desktop-ja.md          |  2 +-
 docs-ja/pages/env-vars-ja.md         | 15 ++++---
 docs-ja/pages/fast-mode-ja.md        | 35 ++++++++-------
 docs-ja/pages/glossary-ja.md         | 26 +++++++----
 docs-ja/pages/hooks-ja.md            | 18 ++++----
 docs-ja/pages/keybindings-ja.md      | 10 ++---
 docs-ja/pages/model-config-ja.md     | 32 +++++++++-----
 docs-ja/pages/monitoring-usage-ja.md |  1 +
 docs-ja/pages/settings-ja.md         |  4 ++
 docs-ja/pages/setup-ja.md            |  6 ++-
 docs-ja/pages/skills-ja.md           |  2 +-
 docs-ja/pages/statusline-ja.md       | 76 ++++++++++++++++---------------
 docs-ja/pages/sub-agents-ja.md       | 10 +++++
 19 files changed, 341 insertions(+), 155 deletions(-)
```

**新規追加:**


<details>
<summary>agent-view-ja.md</summary>

```diff
diff --git a/docs-ja/pages/agent-view-ja.md b/docs-ja/pages/agent-view-ja.md
index 22f28cc..6e99095 100644
--- a/docs-ja/pages/agent-view-ja.md
+++ b/docs-ja/pages/agent-view-ja.md
@@ -88,5 +88,5 @@ Pinned
 
 Ready for review
-  ∙ jump physics              Opened PR with collision fix            ⧉ PR #2048  2h
+  ∙ jump physics              Opened PR with collision fix              PR #2048  2h
 
 Needs input
@@ -124,5 +124,5 @@ Completed
 | `✢`                | [`/loop`](/ja/scheduled-tasks) セッションはイテレーション間でスリープしています。行は実行回数とカウントダウンを表示します |
 
-行の右端に表示される `⧉ PR #N` ラベルは [セッションが開いたプルリクエスト](#pull-request-status) であり、状態アイコンの一部ではありません。セッションが複数のプルリクエストを開いた場合、ラベルは他をカウントする `+N` サフィックスを追加します。
+行の右端に表示される `PR #N` ラベルは [セッションが開いたプルリクエスト](#pull-request-status) であり、状態アイコンの一部ではありません。セッションが複数のプルリクエストを開いた場合、ラベルはカウントを表示します。例えば `3 PRs` のようになります。
 
 ターミナルタブのタイトルは、エージェントビューが開いている間、待機中の入力カウントを表示します。セッションが入力を必要とする場合は `2 awaiting input · claude agents`、そうでない場合は `claude agents` です。
@@ -140,9 +140,9 @@ Completed
 ### プルリクエストステータス
 
-セッションがプルリクエストを開くと、`⧉ PR #1234` ラベルが行の右端に表示され、ハイパーリンクをサポートするターミナルではプルリクエストにリンクされます。セッションにフォローアップを送信するときもラベルは保存されるため、行がライブプログレスに戻るときもプルリクエストは表示されたままです。
+セッションがプルリクエストを開くと、`PR #1234` ラベルが行の右端に表示され、ハイパーリンクをサポートするターミナルではプルリクエストにリンクされます。セッションにフォローアップを送信するときもラベルは保存されるため、行がライブプログレスに戻るときもプルリクエストは表示されたままです。
 
-セッションが複数のプルリクエストを開いた場合、ラベルは最も注意が必要なオープンプルリクエストを表示し、他をカウントする `+N` サフィックスを追加します。[ピークパネル](#peek-and-reply) を開いてすべてを表示します。
+セッションが複数のプルリクエストを開いた場合、ラベルはカウントを表示します。例えば `3 PRs` のようになり、最も注意が必要なオープンプルリクエストで色付けされます。[ピークパネル](#peek-and-reply) を開いてすべてを表示します。
 
-`⧉` アイコンはプルリクエストのステータスで色付けされます。
+プルリクエスト番号はそのステータスで色付けされます。
 
```

</details>

<details>
<summary>agents-ja.md</summary>

```diff
diff --git a/docs-ja/pages/agents-ja.md b/docs-ja/pages/agents-ja.md
index 9ae0ee1..f296684 100644
--- a/docs-ja/pages/agents-ja.md
+++ b/docs-ja/pages/agents-ja.md
@@ -5,19 +5,27 @@
 # エージェントを並列実行する
 
-> Claude Code が複数のタスクを同時に実行する方法を比較します。サブエージェント、エージェントビュー、エージェントチーム、および分離されたワークツリーセッションについて説明します。
+> Claude Code が複数のタスクを同時に実行する方法を比較します。サブエージェント、エージェントビュー、エージェントチーム、および動的ワークフローについて説明します。
 
-[サブエージェント](/ja/sub-agents)、[エージェントビュー](/ja/agent-view)、[エージェントチーム](/ja/agent-teams)、および [ワークツリー](/ja/worktrees) は、それぞれ異なる方法で作業を並列化します。どれを選ぶかは、各会話に自分で留まりたいのか、タスクを引き継いで後で確認したいのか、それとも Claude に一群のワーカーを調整させたいのかによって異なります。
+[サブエージェント](/ja/sub-agents)、[エージェントビュー](/ja/agent-view)、[エージェントチーム](/ja/agent-teams)、および [動的ワークフロー](/ja/workflows) は、それぞれ異なる方法で作業を並列化します。どれを選ぶかは、各会話に自分で留まりたいのか、タスクを引き継いで後で確認したいのか、それとも Claude に一群のワーカーを調整させたいのかによって異なります。
 
-| アプローチ                        | 提供内容                                                                    | 使用する場合                                            |
-| :--------------------------- | :---------------------------------------------------------------------- | :------------------------------------------------ |
-| [サブエージェント](/ja/sub-agents)   | 1 つのセッション内で委任されたワーカーが、独自のコンテキストでサイドタスクを実行し、サマリーを返す                      | サイドタスクが検索結果、ログ、またはファイルコンテンツで主な会話を埋め尽くす場合（再度参照しない） |
-| [エージェントビュー](/ja/agent-view)  | `claude agents` で開く、バックグラウンドで実行されているセッションをディスパッチして監視する 1 つの画面。リサーチプレビュー | 複数の独立したタスクがあり、それらを引き継いで、一目で状態を確認し、必要な場合のみ介入したい場合  |
-| [エージェントチーム](/ja/agent-teams) | 共有タスクリストとエージェント間メッセージングを備えた複数の調整されたセッション。リーダーによって管理される。実験的で、デフォルトでは無効   | Claude にプロジェクトを分割させ、割り当てさせ、ワーカーを同期させたい場合          |
-| [ワークツリー](/ja/worktrees)      | 個別の git チェックアウト。並列セッションが互いのファイルに触れることはない                                | 複数のセッションを自分で実行しているか、サブエージェントが重複するファイルを編集している場合    |
-| [`/batch`](/ja/commands)     | 1 つの大きな変更を 5 ～ 30 個のワークツリー分離サブエージェントに計画的に分割し、各エージェントがプルリクエストを開く         | リポジトリ全体のマイグレーションまたは機械的なリファクタリング。1 つの指示で説明できる場合    |
+| アプローチ                        | 提供内容                                                                    | 使用する場合                                                                       |
+| :--------------------------- | :---------------------------------------------------------------------- | :--------------------------------------------------------------------------- |
+| [サブエージェント](/ja/sub-agents)   | 1 つのセッション内で委任されたワーカーが、独自のコンテキストでサイドタスクを実行し、サマリーを返す                      | サイドタスクが検索結果、ログ、またはファイルコンテンツで主な会話を埋め尽くす場合（再度参照しない）                            |
+| [エージェントビュー](/ja/agent-view)  | `claude agents` で開く、バックグラウンドで実行されているセッションをディスパッチして監視する 1 つの画面。リサーチプレビュー | 複数の独立したタスクがあり、それらを引き継いで、一目で状態を確認し、必要な場合のみ介入したい場合                             |
+| [エージェントチーム](/ja/agent-teams) | 共有タスクリストとエージェント間メッセージングを備えた複数の調整されたセッション。リーダーによって管理される。実験的で、デフォルトでは無効   | Claude にプロジェクトを分割させ、割り当てさせ、ワーカーを同期させたい場合                                     |
+| [動的ワークフロー](/ja/workflows)    | 多くのサブエージェントを実行し、その結果をチェックするスクリプト。1 回のターンで調整するには大きすぎるジョブ向け。リサーチプレビュー     | タスクが大きすぎてサブエージェント数個では対応できない場合。コードベース全体の監査、500 ファイルのマイグレーション、または敵対的検証が必要な調査など |
 
 すべてのアプローチにおいて、ワーカーは Claude セッションです。別のツールを関与させるには、それを Claude に [MCP サーバー](/ja/mcp) として公開します。
 
-これらのアプローチを組み合わせることができます。エージェントビューは、ディスパッチされた各セッションをファイルを編集する必要がある場合に自動的に独自のワークツリーに移動し、作業中のセッションはサブエージェントを生成でき、各サブエージェントは独自のワークツリーを取得します。
```

</details>

<details>
<summary>best-practices-ja.md</summary>

```diff
diff --git a/docs-ja/pages/best-practices-ja.md b/docs-ja/pages/best-practices-ja.md
index 334c33a..c480d8b 100644
--- a/docs-ja/pages/best-practices-ja.md
+++ b/docs-ja/pages/best-practices-ja.md
@@ -28,10 +28,10 @@ LLM のパフォーマンスはコンテキストが満杯になるにつれて
 
 <Tip>
-  テスト、スクリーンショット、または期待される出力を含めて、Claude が自分自身をチェックできるようにします。これはあなたができる最も高いレバレッジのことです。
+  Claude が実行できるチェックを与えてください。テスト、ビルド、比較するスクリーンショットです。これは、あなたが見守るセッションと、あなたが立ち去ることができるセッションの違いです。
 </Tip>
 
-Claude は、テストを実行したり、スクリーンショットを比較したり、出力を検証したりするなど、自分の作業を検証できるときに劇的に良くなります。
+Claude は、作業が完了したように見えるときに停止します。実行できるチェックがないと、「完了したように見える」が唯一の利用可能なシグナルであり、あなたが検証ループになります。すべての間違いはあなたがそれに気付くのを待ちます。Claude が実行できるパスまたはフェイルを生成するものを与えると、ループは自動的に閉じます。Claude は作業を行い、チェックを実行し、結果を読み、チェックが合格するまで反復します。
 
-明確な成功基準がないと、正しく見えるが実際には機能しないものを生成する可能性があります。あなたが唯一のフィードバックループになり、すべての間違いがあなたの注意を必要とします。
+チェックは、会話で Claude が読むことができるシグナルを返すものです。テストスイート、ビルド終了コード、リンター、出力を固定値と比較するスクリプト、またはデザインと比較される[ブラウザスクリーンショット](/ja/chrome)です。
 
 | 戦略                  | 前                        | 後                                                                                                                                                      |
@@ -41,7 +41,12 @@ Claude は、テストを実行したり、スクリーンショットを比較
 | **症状ではなく根本原因に対処する** | *「ビルドが失敗している」*           | *「ビルドがこのエラーで失敗している：\[エラーを貼り付け]。修正して、ビルドが成功することを確認する。根本原因に対処し、エラーを抑制しない」*                                                                               |
 
-UI の変更は [Chrome 拡張機能の Claude](/ja/chrome) を使用して検証できます。これはブラウザで新しいタブを開き、UI をテストし、コードが機能するまで反復します。
+チェックが存在したら、停止をどの程度厳しくゲートするかを決定します。
 
-検証はテストスイート、リンター、または出力をチェックする Bash コマンドにすることもできます。検証を堅牢にすることに投資してください。
+* **1 つのプロンプトで**：Claude にチェックを実行し、同じメッセージ内で反復するよう求めます。上記の表のように。
+* **セッション全体で**：チェックを[`/goal` 条件](/ja/goal)として設定します。別の評価者がすべてのターンの後に再度チェックし、Claude はそれが保持されるまで作業を続けます。
+* **決定論的ゲートとして**：[Stop hook](/ja/hooks#stop) がスクリプトとしてチェックを実行し、合格するまでターンが終了するのをブロックします。Claude Code はフックをオーバーライドし、8 回連続でブロックされた後、ターンを終了します。
+* **第二の意見によって**：[検証サブエージェント](/ja/sub-agents)または[動的ワークフロー](/ja/workflows)が独自の調査結果をチェックし、新しいモデルが結果を反論しようとするため、作業を行っているエージェントがそれを採点しているわけではありません。
+
```

</details>

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index 761d992..92ea9fb 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,90 @@
 # Changelog
 
+## 2.1.154
+
+- Opus 4.8 is here! Now defaults to high effort · /effort xhigh for your hardest tasks
+- Introducing dynamic workflows: ask Claude to create a workflow and it orchestrates work across tens to hundreds of agents in the background, so you can take on larger, more complex tasks. Run `/workflows` to view your runs
+- Fast mode on Opus 4.8 is now available at a fraction of its previous cost: 2x the standard rate for 2.5x the speed
+- The lean system prompt is now the default for all models except Haiku, Sonnet, and Opus 4.7 and earlier
+- Claude now reserves the multiple-choice question prompt for decisions it genuinely cannot make itself, instead of asking when it already has enough context to proceed
+- `/simplify` now runs a cleanup-only review (reuse, simplification, efficiency, altitude) and applies the fixes, instead of running the full `/code-review --fix` bug-hunting review
+- Renamed the `/effort` slider labels from "Speed"/"Intelligence" to "Faster"/"Smarter" for clarity
+- `claude agents`: type `! <command>` to run a shell command as a background session you can attach to and detach from. Also available as `claude --bg --exec '<command>'`
+- `claude agents`: `/logout` now signs you out instead of being sent to a background session
+- `←←` to open the agents view now works on Bedrock, Vertex, Foundry, and with telemetry disabled
+- Claude in Chrome: pick which connected browser to use via `/chrome` → "Select browser…", or in-chat when a browser action runs with multiple connected
+- Plugins can now declare `defaultEnabled: false` in `plugin.json` or a marketplace entry; enable them with `/plugin` or `claude plugin enable`. Dependencies of enabled plugins are still enabled automatically
+- The `/plugin` Discover tab now pins plugins whose relevance signals match the current directory with a "suggested for this directory" annotation
+- Streaming tool execution is now always enabled, including when telemetry is disabled or on Bedrock/Vertex/Foundry (previously behind a feature flag)
+- Stdio MCP server subprocesses now receive `CLAUDE_CODE_SESSION_ID` and `CLAUDECODE=1` in their environment
+- `claude mcp list`/`get` now show unapproved `.mcp.json` servers as `⏸ Pending approval` instead of auto-approving and connecting when output is piped
+- `/remote-control` autocomplete now shows "Disconnect Remote Control" when Remote Control is already active
+- Added Claude Opus 4.8 support and 4.7 → 4.8 migration guidance to the `/claude-api` skill
+- Deprecated `CLAUDE_CODE_OPUS_4_6_FAST_MODE_OVERRIDE` (will be removed on 06/01). To use fast mode on Opus 4.6, switch with `/model claude-opus-4-6[1m]` and then `/fast on`
+- Improved the auto-mode classifier's detection of data exfiltration, particularly bulk transfers of repository contents
+- Fixed `rm -rf $HOME` not being blocked as a dangerous path when `HOME` has a trailing slash
```

</details>

<details>
<summary>claude-directory-ja.md</summary>

```diff
diff --git a/docs-ja/pages/claude-directory-ja.md b/docs-ja/pages/claude-directory-ja.md
index 2b3cba4..3347c46 100644
--- a/docs-ja/pages/claude-directory-ja.md
+++ b/docs-ja/pages/claude-directory-ja.md
@@ -5,5 +5,5 @@
 # .claude ディレクトリを探索する
 
-> Claude Code が CLAUDE.md、settings.json、hooks、skills、commands、subagents、rules、auto memory を読み込む場所。プロジェクト内の .claude ディレクトリとホームディレクトリの ~/.claude を探索します。
+> Claude Code が CLAUDE.md、settings.json、hooks、skills、commands、subagents、workflows、rules、auto memory を読み込む場所。プロジェクト内の .claude ディレクトリとホームディレクトリの ~/.claude を探索します。
 
 export const ClaudeExplorer = () => {
@@ -362,4 +362,15 @@ You are a senior code reviewer. Review for:
 Every finding must include a concrete fix.`
           }]
+        }, {
+          id: 'workflows',
+          label: 'workflows/',
+          type: 'folder',
+          icon: 'folder',
+          color: '#C46686',
+          oneLiner: 'Dynamic workflow scripts that orchestrate many subagents',
+          when: 'Loaded at startup; each file becomes a /<name> command',
+          description: <>Each <C>.js</C> file is a <A href="/en/workflows">dynamic workflow</A>: a script the runtime executes to spawn and coordinate many subagents. Workflows are written by Claude and saved here from <C>/workflows</C> rather than authored from scratch.</>,
+          tips: [<>Save a run from <C>/workflows</C> with <C>s</C> to create one of these</>, <>A project workflow takes precedence over a personal one in <C>~/.claude/workflows/</C> with the same name</>],
+          docsLink: '/en/workflows'
         }, {
           id: 'agent-memory',
@@ -665,4 +676,15 @@ themselves by leaving a TODO(human) marker instead of writing it.`
           docsLink: '/en/sub-agents',
           children: []
```

</details>

<details>
<summary>commands-ja.md</summary>

```diff
diff --git a/docs-ja/pages/commands-ja.md b/docs-ja/pages/commands-ja.md
index abb0c4e..5bf232d 100644
--- a/docs-ja/pages/commands-ja.md
+++ b/docs-ja/pages/commands-ja.md
@@ -31,5 +31,10 @@
 ## すべてのコマンド
 
-以下の表は Claude Code に含まれるすべてのコマンドをリストしています。**[スキル](/ja/skills#bundled-skills)** とマークされたエントリはバンドルされたスキルです。これらは自分で作成するスキルと同じメカニズムを使用します。Claude に渡されるプロンプトであり、Claude は関連する場合に自動的に呼び出すこともできます。その他はすべて、CLI にコード化された動作を持つ組み込みコマンドです。独自のコマンドを追加するには、[スキル](/ja/skills)を参照してください。
+以下の表は Claude Code に含まれるすべてのコマンドをリストしています。ほとんどは CLI にコード化された動作を持つ組み込みコマンドです。2 つの種類のエントリがマークされています。
+
+* **[スキル](/ja/skills#bundled-skills)**: バンドルされたスキル。自分で作成するスキルと同じように機能します。Claude に渡されるプロンプトであり、Claude は関連する場合に自動的に呼び出すこともできます。
+* **[ワークフロー](/ja/workflows#bundled-workflows)**: バンドルされた[動的ワークフロー](/ja/workflows)。多くのサブエージェント間で作業をファンアウトし、バックグラウンドで実行されます。
+
+独自のコマンドを追加するには、[スキル](/ja/skills)を参照してください。
 
 以下の表では、`<arg>` は必須引数を示し、`[arg]` はオプション引数を示します。
@@ -44,5 +49,6 @@
 | `/agents`                                                                          | [エージェント](/ja/sub-agents)設定を管理します                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
 | `/autofix-pr [prompt]`                                                             | 現在のブランチの PR を監視し、CI が失敗するか、レビュアーがコメントを残したときに修正をプッシュする [Claude Code on the web](/ja/claude-code-on-the-web#auto-fix-pull-requests) セッションを生成します。`gh pr view` で開いている PR を検出します。別の PR を監視するには、最初にそのブランチをチェックアウトしてください。デフォルトでは、リモートセッションはすべての CI 失敗とレビューコメントを修正するよう指示されます。プロンプトを渡して異なる指示を与えることができます。例えば `/autofix-pr only fix lint and type errors`。`gh` CLI と [Claude Code on the web](/ja/claude-code-on-the-web#who-can-use-claude-code-on-the-web) へのアクセスが必要です                                                  |
-| `/batch <instruction>`                                                             | **[スキル](/ja/skills#bundled-skills)。** コードベース全体にわたる大規模な変更を並列で調整します。コードベースを調査し、作業を 5 ～ 30 個の独立したユニットに分解し、計画を提示します。承認されると、分離された [git worktree](/ja/worktrees) 内の各ユニットごとに 1 つのバックグラウンドサブエージェントを生成します。各サブエージェントはそのユニットを実装し、テストを実行し、プルリクエストを開きます。git リポジトリが必要です。例: `/batch migrate src/ from Solid to React`                                                                                                                                                                                                         |
+| `/background [prompt]`                                                             | 現在のセッションをデタッチして[バックグラウンドエージェント](/ja/agent-view)として実行し、このターミナルを解放します。デタッチする前に 1 つ以上の指示を送信するためにプロンプトを渡します。`claude agents` でセッションを監視します。エイリアス: `/bg`                                                                                                                                                                                                                                                                                                                                                              |
+| `/batch <instruction>`                                                             | **[スキル](/ja/skills#bundled-skills)。** コードベース全体にわたる大規模な変更を並列で調整します。コードベースを調査し、作業を 5 ～ 30 個の独立したユニットに分解し、計画を提示します。承認されると、分離された [git worktree](/ja/worktrees) 内の各ユニットごとに 1 つの[バックグラウンドサブエージェント](/ja/sub-agents#run-subagents-in-foreground-or-background)を生成します。各サブエージェントはそのユニットを実装し、テストを実行し、プルリクエストを開きます。git リポジトリが必要です。例: `/batch migrate src/ from Solid to React`                                                                                                                                             |
 | `/branch [name]`                                                                   | この時点で現在の会話のブランチを作成します。ブランチに切り替え、元の会話を保持します。`/resume` で戻ることができます。エイリアス: `/fork`。[`CLAUDE_CODE_FORK_SUBAGENT`](/ja/env-vars) が設定されている場合、`/fork` は代わりに[フォークされたサブエージェント](/ja/sub-agents#fork-the-current-conversation)を生成し、このコマンドのエイリアスではなくなります                                                                                                                                                                                                                                                                    |
 | `/btw <question>`                                                                  | 会話に追加せずに[サイドクエスチョン](/ja/interactive-mode#side-questions-with-%2Fbtw)として素早く質問します                                                                                                                                                                                                                                                                                                                                                                                                                                |
@@ -58,8 +64,9 @@
 | `/cost`                                                                            | `/usage` のエイリアス                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
 | `/debug [description]`                                                             | **[スキル](/ja/skills#bundled-skills)。** 現在のセッションのデバッグログを有効にし、セッションデバッグログを読むことで問題をトラブルシューティングします。デバッグログはデフォルトではオフです。`claude --debug` で開始した場合を除き、セッション中に `/debug` を実行するとその時点からログのキャプチャを開始します。オプションで問題を説明して分析にフォーカスを当てます                                                                                                                                                                                                                                                                                            |
+| `/deep-research <question>`                                                        | **[ワークフロー](/ja/workflows#bundled-workflows)。** 質問に関するウェブ検索をファンアウトし、ソースをフェッチして相互検証し、引用されたレポートを合成します                                                                                                                                                                                                                                                                                                                                                                                                             |
 | `/desktop`                                                                         | 現在のセッションを Claude Code デスクトップアプリで続行します。macOS と Windows が必要で、Claude サブスクリプションが必要です。エイリアス: `/app`                                                                                                                                                                                                                                                                                                                                                                                                                 |
 | `/diff`                                                                            | コミットされていない変更と各ターンの diff を表示するインタラクティブ diff ビューアを開きます。左右矢印を使用して現在の git diff と個別の Claude ターンを切り替え、上下矢印でファイルをブラウズします                                                                                                                                                                                                                                                                                                                                                                                              |
```

</details>

*...以降省略*

</details>


<details>
<summary>2026-05-28</summary>

**変更ファイル:**

```
 docs-ja/pages/agent-view-ja.md          |  24 ++--
 docs-ja/pages/changelog.md              |  36 ++++++
 docs-ja/pages/code-review-ja.md         |  13 ++-
 docs-ja/pages/commands-ja.md            | 187 ++++++++++++++++----------------
 docs-ja/pages/env-vars-ja.md            |   2 +
 docs-ja/pages/errors-ja.md              |   6 +-
 docs-ja/pages/headless-ja.md            |   2 +-
 docs-ja/pages/hooks-guide-ja.md         |  37 ++++---
 docs-ja/pages/hooks-ja.md               | 135 ++++++++++++++++-------
 docs-ja/pages/interactive-mode-ja.md    |  12 +-
 docs-ja/pages/keybindings-ja.md         |   1 +
 docs-ja/pages/monitoring-usage-ja.md    |  32 ++++--
 docs-ja/pages/plugin-marketplaces-ja.md |  10 +-
 docs-ja/pages/plugins-reference-ja.md   |   1 +
 docs-ja/pages/settings-ja.md            |   1 +
 docs-ja/pages/skills-ja.md              |   1 +
 docs-ja/pages/ultrareview-ja.md         |  24 ++--
 17 files changed, 333 insertions(+), 191 deletions(-)
```

<details>
<summary>agent-view-ja.md</summary>

```diff
diff --git a/docs-ja/pages/agent-view-ja.md b/docs-ja/pages/agent-view-ja.md
index 7666309..22f28cc 100644
--- a/docs-ja/pages/agent-view-ja.md
+++ b/docs-ja/pages/agent-view-ja.md
@@ -88,5 +88,5 @@ Pinned
 
 Ready for review
-  ∙ jump physics              github.com/example/game/pull/2048          ●  2h
+  ∙ jump physics              Opened PR with collision fix            ⧉ PR #2048  2h
 
 Needs input
@@ -124,5 +124,5 @@ Completed
 | `✢`                | [`/loop`](/ja/scheduled-tasks) セッションはイテレーション間でスリープしています。行は実行回数とカウントダウンを表示します |
 
-行の右端に表示される `●` は [プルリクエストステータス](#pull-request-status) インジケーターであり、状態アイコンの一部ではありません。その前の数字はセッションが開いたプルリクエストの数です。
+行の右端に表示される `⧉ PR #N` ラベルは [セッションが開いたプルリクエスト](#pull-request-status) であり、状態アイコンの一部ではありません。セッションが複数のプルリクエストを開いた場合、ラベルは他をカウントする `+N` サフィックスを追加します。
 
 ターミナルタブのタイトルは、エージェントビューが開いている間、待機中の入力カウントを表示します。セッションが入力を必要とする場合は `2 awaiting input · claude agents`、そうでない場合は `claude agents` です。
@@ -140,14 +140,18 @@ Completed
 ### プルリクエストステータス
 
-セッションがプルリクエストを開くと、ステータスドットが行の右端に表示され、ハイパーリンクをサポートするターミナルではプルリクエストにリンクされます。セッションが複数のプルリクエストを開いた場合、カウントはドットの前に表示され、色はどれが最も注意が必要かを反映します。
+セッションがプルリクエストを開くと、`⧉ PR #1234` ラベルが行の右端に表示され、ハイパーリンクをサポートするターミナルではプルリクエストにリンクされます。セッションにフォローアップを送信するときもラベルは保存されるため、行がライブプログレスに戻るときもプルリクエストは表示されたままです。
 
-| ドットの色 | プルリクエストステータス               |
-| :---- | :------------------------- |
-| 黄色    | チェックまたはレビューを待機中、またはチェックが失敗 |
-| 緑     | チェックが成功し、レビューがブロックされていない   |
-| 紫     | マージ済み                      |
-| グレー   | ドラフトまたはクローズ                |
```

</details>

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index 20cadc6..761d992 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,40 @@
 # Changelog
 
+## 2.1.152
+
+- `/code-review --fix` now applies review findings to your working tree after the review, surfacing reuse, simplification, and efficiency suggestions; `/simplify` now invokes `/code-review --fix`
+- Skills and slash commands can now set `disallowed-tools` in frontmatter to remove tools from the model while the skill is active
+- Added `/reload-skills` command to re-scan skill directories without restarting the session
+- `SessionStart` hooks can now return `reloadSkills: true` to re-scan skill directories, making skills installed by the hook available in the same session
+- `SessionStart` hooks can now set the session title via `hookSpecificOutput.sessionTitle` on startup and resume
+- Added a `MessageDisplay` hook event that lets hooks transform or hide assistant message text as it is displayed
+- Added `pluginSuggestionMarketplaces` managed setting: admins can allowlist org marketplaces whose plugins may be suggested via context-aware tips
+- `claude plugin marketplace remove` now accepts `--scope user|project|local` for symmetry with `marketplace add`, `install`, and `uninstall`
+- Claude Code now switches to your configured `--fallback-model` for the rest of the session when the primary model is not found, instead of failing every request
+- Auto mode no longer requires opt-in consent
+- Vim mode: `/` in NORMAL mode now opens reverse history search (like Ctrl+R), matching bash/zsh vi-mode
+- The `/usage` breakdown now includes large session files; files are scanned with a streaming read so memory usage stays flat
+- Thinking summaries in the collapsed group now stay readable for at least 3 seconds, render as markdown, and cap at 10 lines (`Ctrl+O` shows the full thinking)
+- In fullscreen mode, the "Thinking for Ns" indicator now counts up live while the model is thinking, and keeps its value if you interrupt mid-thought
+- Simplified the Workflow tool's inline progress display — live agent counts now show only in the persistent workflow status row below the prompt
+- The post-response timer now shows "Waiting for N background agents/workflows to finish" when backgrounded agents or workflows are still running, and reports the cumulative time once their results are processed
+- Added the session entrypoint as an OpenTelemetry metric attribute (`app.entrypoint`, opt-in via `OTEL_METRICS_INCLUDE_ENTRYPOINT=true`)
+- Fixed terminal styling degrading in very long sessions by recycling the renderer's style pool
+- Fixed the sandbox-enabled warning not appearing in condensed startup mode — it now shows in every layout
+- Fixed the loading spinner showing "still thinking"/"almost done thinking" while a tool is running, and reset the thinking status to "thinking" after each tool
+- Fixed focus mode showing a spurious "N messages hidden" count on turns with no hidden activity
```

</details>

<details>
<summary>code-review-ja.md</summary>

```diff
diff --git a/docs-ja/pages/code-review-ja.md b/docs-ja/pages/code-review-ja.md
index 2750b92..4cced00 100644
--- a/docs-ja/pages/code-review-ja.md
+++ b/docs-ja/pages/code-review-ja.md
@@ -25,7 +25,8 @@ Claude を管理サービスではなく独自の CI インフラストラクチ
 * [料金](#pricing)
 * [トラブルシューティング](#troubleshooting)失敗した実行と欠落したコメント
+* [ローカルで差分をレビューする](#review-a-diff-locally) `/code-review` コマンドを使用
 
 <Note>
-  GitHub アプリをインストールせずにターミナルでローカルに差分をレビューするには、任意の Claude Code セッションで [`/code-review` コマンド](/ja/commands)を実行してください。選択した努力レベルで現在の差分の正確性バグを報告し、`--comment` で結果をインライン PR コメントとして投稿できます。このコマンドは v2.1.147 より前は `/simplify` という名前でした。
+  GitHub アプリをインストールせずにターミナルでローカルに差分をレビューするには、任意の Claude Code セッションで `/code-review` コマンドを実行してください。[ローカルで差分をレビューする](#review-a-diff-locally)を参照してください。
 </Note>
 
@@ -268,4 +269,14 @@ GitHub の Checks タブの **Re-run** ボタンは Code Review を再トリガ
 * **レビュー本文**: レビューが実行されている間に PR にプッシュした場合、一部の結果は現在の diff に存在しなくなった行を参照する場合があります。これらは、インラインコメントではなく、レビュー本文テキストの **Additional findings** 見出しの下に表示されます。
 
+## ローカルで差分をレビューする
+
+[`/code-review` コマンド](/ja/commands)はターミナルで差分をレビューし、GitHub App をインストールせずに実行します。任意の Claude Code セッションで実行します：現在の差分の正確性バグを報告し、{/* min-version: 2.1.151 */}再利用、簡素化、効率化のクリーンアップを報告します。`--comment` を渡してインライン PR コメントとして結果を投稿するか、`--fix` を渡してレビュー後に結果をワーキングツリーに適用します。
+
+低い[努力レベル](/ja/model-config#adjust-effort-level)は、より少なく、より高い信頼度の結果を返し、`high` から `max` はより広いカバレッジを提供し、不確実な結果を含む場合があります。努力引数がない場合、レビューはセッションの現在の努力を使用します。現在の差分の代わりに特定のターゲットをレビューするためにパスまたは PR 参照を渡します。
+
+`/code-review ultra --fix` はクラウドでより深い[ultrareview](/ja/ultrareview)を実行し、セッションに戻ってきたときに結果をワーキングツリーに適用します。
+
+このコマンドは v2.1.147 より前は `/simplify` という名前で、デフォルトで修正を適用していました。`/simplify` は依然として機能し、`/code-review --fix` と同等です。
+
 ## 関連リソース
 
```

</details>

<details>
<summary>commands-ja.md</summary>

```diff
diff --git a/docs-ja/pages/commands-ja.md b/docs-ja/pages/commands-ja.md
index e0f52f1..abb0c4e 100644
--- a/docs-ja/pages/commands-ja.md
+++ b/docs-ja/pages/commands-ja.md
@@ -23,5 +23,5 @@
 **並行して作業を実行する。** `/agents` は Claude が副次的なタスクを委譲できる[サブエージェント](/ja/sub-agents)のマネージャーを開き、`/tasks` は現在のセッションのバックグラウンドで実行されているものをリストします。`/background` はセッション全体をデタッチして[バックグラウンドエージェント](/ja/agent-view)として実行し続け、ターミナルを解放します。コードベース全体にまたがる大きな変更の場合、`/batch` はそれを独立したユニットに分解し、各ユニットを独自の[worktree](/ja/worktrees)で実行します。これらのアプローチがどのように関連しているかについては、[エージェントを並行して実行する](/ja/agents)を参照してください。
 
-**リリース前。** `/diff` は変更内容を表示し、`/code-review` は diff の正確性のバグをチェックし、`/review` または `/security-review` はより深い読み取り専用パスを提供します。
+**リリース前。** `/diff` は変更内容を表示し、`/code-review` は diff の正確性のバグをチェックし、`--fix` で検出結果を適用できます。`/review` または `/security-review` はより深い読み取り専用パスを提供します。`/code-review ultra` はクラウドでマルチエージェントレビューを実行します。
 
 **セッション間。** `/clear` は新しいタスクで新しく開始しながらプロジェクトメモリを保持します。`/resume` と `/branch` を使用して、以前の会話に戻るか、フォークできます。`/teleport` はウェブセッションをこのターミナルに引き込み、`/remote-control` を使用してこのローカルセッションを別のデバイスから続行できます。
@@ -39,96 +39,97 @@
 </Note>
 
-| コマンド                                                                | 目的                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
-| :------------------------------------------------------------------ | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
-| `/add-dir <path>`                                                   | 現在のセッション中にファイルアクセス用の作業ディレクトリを追加します。ほとんどの `.claude/` 設定は追加されたディレクトリから[検出されません](/ja/permissions#additional-directories-grant-file-access-not-configuration)。後で `--continue` または `--resume` を使用して、追加されたディレクトリからセッションを再開できます                                                                                                                                                                                                                                                                                       |
-| `/agents`                                                           | [エージェント](/ja/sub-agents)設定を管理します                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
-| `/autofix-pr [prompt]`                                              | 現在のブランチの PR を監視し、CI が失敗するか、レビュアーがコメントを残したときに修正をプッシュする [Claude Code on the web](/ja/claude-code-on-the-web#auto-fix-pull-requests) セッションを生成します。`gh pr view` で開いている PR を検出します。別の PR を監視するには、最初にそのブランチをチェックアウトしてください。デフォルトでは、リモートセッションはすべての CI 失敗とレビューコメントを修正するよう指示されます。プロンプトを渡して異なる指示を与えることができます。例えば `/autofix-pr only fix lint and type errors`。`gh` CLI と [Claude Code on the web](/ja/claude-code-on-the-web#who-can-use-claude-code-on-the-web) へのアクセスが必要です                                                  |
-| `/batch <instruction>`                                              | **[スキル](/ja/skills#bundled-skills)。** コードベース全体にわたる大規模な変更を並列で調整します。コードベースを調査し、作業を 5 ～ 30 個の独立したユニットに分解し、計画を提示します。承認されると、分離された [git worktree](/ja/worktrees) 内の各ユニットごとに 1 つのバックグラウンドサブエージェントを生成します。各サブエージェントはそのユニットを実装し、テストを実行し、プルリクエストを開きます。git リポジトリが必要です。例: `/batch migrate src/ from Solid to React`                                                                                                                                                                                                         |
-| `/branch [name]`                                                    | この時点で現在の会話のブランチを作成します。ブランチに切り替え、元の会話を保持します。`/resume` で戻ることができます。エイリアス: `/fork`。[`CLAUDE_CODE_FORK_SUBAGENT`](/ja/env-vars) が設定されている場合、`/fork` は代わりに[フォークされたサブエージェント](/ja/sub-agents#fork-the-current-conversation)を生成し、このコマンドのエイリアスではなくなります                                                                                                                                                                                                                                                                    |
-| `/btw <question>`                                                   | 会話に追加せずに[サイドクエスチョン](/ja/interactive-mode#side-questions-with-%2Fbtw)として素早く質問します                                                                                                                                                                                                                                                                                                                                                                                                                                |
-| `/chrome`                                                           | [Chrome の Claude](/ja/chrome) 設定を構成します                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
-| `/claude-api [migrate\|managed-agents-onboard]`                     | **[スキル](/ja/skills#bundled-skills)。** プロジェクトの言語（Python、TypeScript、Java、Go、Ruby、C#、PHP、または cURL）と Managed Agents リファレンス用の Claude API リファレンス資料を読み込みます。ツール使用、ストリーミング、バッチ、構造化出力、および一般的な落とし穴をカバーしています。また、コードが `anthropic` または `@anthropic-ai/sdk` をインポートするときに自動的にアクティブになります。`/claude-api migrate` を実行して、既存の Claude API コードを新しいモデルにアップグレードします。Claude はスキャンするファイルとターゲットモデルを尋ね、モデル ID、思考設定、およびバージョン間で変更されたその他のパラメータを更新します。`/claude-api managed-agents-onboard` を実行して、新しい Managed Agent をゼロから作成するインタラクティブなウォークスルーを実施します |
-| `/clear [name]`                                                     | 空のコンテキストで新しい会話を開始します。前の会話は `/resume` で利用可能なままです。前の会話にラベルを付けるために名前を渡します。`/resume` ピッカーで。同じ会話を続けながらコンテキストを解放するには、代わりに `/compact` を使用してください。エイリアス: `/reset`、`/new`                                                                                                                                                                                                                                                                                                                                                |
-| `/code-review [low\|medium\|high\|xhigh\|max] [--comment] [target]` | **[スキル](/ja/skills#bundled-skills)。** 現在の diff を正確性バグについてレビューし、ファイルを編集せずに結果を報告します。低い[努力レベル](/ja/model-config#adjust-effort-level)はより少なく、より高い信頼度の結果を返し、`high` から `max` はより広いカバレッジを提供し、不確実な結果を含む場合があります。努力引数がない場合、レビューはセッションの現在の努力を使用します。`--comment` を渡して、現在の GitHub PR にインラインコメントとして結果を投稿します。特定のターゲットをレビューするためにパスまたは PR リファレンスを渡します。以前は `/simplify` でしたが、これはエイリアスとしても機能します                                                                                                                                      |
-| `/color [color\|default]`                                           | 現在のセッションのプロンプトバーの色を設定します。利用可能な色: `red`、`blue`、`green`、`yellow`、`purple`、`orange`、`pink`、`cyan`。`default` を使用してリセットするか、引数なしで実行するとランダムな色を選択します。[リモートコントロール](/ja/remote-control)が接続されている場合、色は claude.ai/code に同期されます                                                                                                                                                                                                                                                                                              |
-| `/compact [instructions]`                                           | 会話をここまで要約してコンテキストを解放します。オプションで要約のフォーカス指示を渡します。[コンパクション時にルール、スキル、メモリファイルがどのように処理されるか](/ja/context-window#what-survives-compaction)を参照してください                                                                                                                                                                                                                                                                                                                                                                     |
-| `/config`                                                           | [設定](/ja/settings)インターフェースを開いて、テーマ、モデル、[出力スタイル](/ja/output-styles)、およびその他の設定を調整します。エイリアス: `/settings`                                                                                                                                                                                                                                                                                                                                                                                                          |
-| `/context [all]`                                                    | 現在のコンテキスト使用状況をカラーグリッドとして視覚化します。コンテキストが多いツール、メモリ肥大化、容量警告の最適化提案を表示します。[フルスクリーンモード](/ja/fullscreen)では、項目ごとの内訳はグリッドを表示したままにするために折りたたまれます。`all` を渡して展開します                                                                                                                                                                                                                                                                                                                                                           |
```

</details>

<details>
<summary>env-vars-ja.md</summary>

```diff
diff --git a/docs-ja/pages/env-vars-ja.md b/docs-ja/pages/env-vars-ja.md
index c8ddfea..4af7768 100644
--- a/docs-ja/pages/env-vars-ja.md
+++ b/docs-ja/pages/env-vars-ja.md
@@ -221,4 +221,5 @@ Claude Code は起動時に環境変数を読み取るため、変更は `claude
 | `CLAUDE_CODE_PLUGIN_SEED_DIR`                           | 1 つ以上の読み取り専用プラグインシードディレクトリへのパス。Unix では `:` で、Windows では `;` で区切られます。事前入力されたプラグインディレクトリをコンテナイメージにバンドルするために使用します。Claude Code はこれらのディレクトリからマーケットプレイスを登録し、再クローンなしで事前キャッシュされたプラグインを使用します。[コンテナ用のプラグインを事前入力](/ja/plugin-marketplaces#pre-populate-plugins-for-containers) を参照してください                                                                                                                                                  |
 | `CLAUDE_CODE_POWERSHELL_RESPECT_EXECUTION_POLICY`       | Claude Code が PowerShell をスポーンするときに `-ExecutionPolicy Bypass` を渡すことを停止するには `1` に設定します。ツール呼び出し、フック、ステータスラインコマンドの場合、マシンの有効な実行ポリシーを尊重します。デフォルトでは Claude Code はプロセススコープでバイパスを実行するため、`.ps1` スクリプトとモジュールインポートはデフォルト制限 Windows インストールで機能します。プロセススコープバイパスは、この設定に関係なく、グループポリシー `MachinePolicy` または `UserPolicy` をオーバーライドしません                                                                                                            |
+| `CLAUDE_CODE_PROPAGATE_TRACEPARENT`                     | {/* min-version: 2.1.152 */}カスタムプロキシを指す場合、W3C トレースコンテキストを伝播するには `1` に設定します。`ANTHROPIC_BASE_URL` が指しています。伝播は、モデルと HTTP MCP リクエストの `traceparent` ヘッダーと、Bash、PowerShell、フックサブプロセスの `TRACEPARENT` 環境変数をカバーします。デフォルトでは、伝播は Anthropic API に直接接続されている場合にのみ有効になります。[トレース（ベータ）](/ja/monitoring-usage#traces-beta) を参照してください                                                                                                             |
 | `CLAUDE_CODE_PROVIDER_MANAGED_BY_HOST`                  | Claude Code を埋め込み、その代わりにモデルプロバイダーのルーティングを管理するホストプラットフォームによって設定されます。設定されている場合、`CLAUDE_CODE_USE_BEDROCK`、`ANTHROPIC_BASE_URL`、`ANTHROPIC_API_KEY` などのプロバイダー選択、エンドポイント、認証変数は設定ファイルで無視されるため、ユーザー設定はホストのルーティングをオーバーライドできません。Bedrock、Vertex、Foundry の自動テレメトリオプトアウトもスキップされるため、テレメトリは標準の `DISABLE_TELEMETRY` オプトアウトに従います。[API プロバイダーごとのデフォルト動作](/ja/data-usage#default-behaviors-by-api-provider) を参照してください                            |
 | `CLAUDE_CODE_PROXY_RESOLVES_HOSTS`                      | プロキシが呼び出し元の代わりに DNS 解決を実行できるようにするには `1` に設定します。プロキシがホスト名解決を処理する必要がある環境でオプトインします                                                                                                                                                                                                                                                                                                                                                |
@@ -316,4 +317,5 @@ Claude Code は起動時に環境変数を読み取るため、変更は `claude
 | `OTEL_LOG_USER_PROMPTS`                                 | ユーザープロンプトテキストを OpenTelemetry トレースとログに含めるには `1` に設定します。デフォルトで無効です（プロンプトは編集されます）。[監視](/ja/monitoring-usage) を参照してください                                                                                                                                                                                                                                                                                                            |
 | `OTEL_METRICS_INCLUDE_ACCOUNT_UUID`                     | メトリクス属性からアカウント UUID を除外するには `false` に設定します（デフォルト：含まれます）。[監視](/ja/monitoring-usage) を参照してください                                                                                                                                                                                                                                                                                                                                   |
+| `OTEL_METRICS_INCLUDE_ENTRYPOINT`                       | {/* min-version: 2.1.152 */}セッションエントリポイントをメトリクス属性に含めるには `true` に設定します（デフォルト：除外）。[監視](/ja/monitoring-usage) を参照してください                                                                                                                                                                                                                                                                                                           |
 | `OTEL_METRICS_INCLUDE_SESSION_ID`                       | メトリクス属性からセッション ID を除外するには `false` に設定します（デフォルト：含まれます）。[監視](/ja/monitoring-usage) を参照してください                                                                                                                                                                                                                                                                                                                                     |
 | `OTEL_METRICS_INCLUDE_VERSION`                          | Claude Code バージョンをメトリクス属性に含めるには `true` に設定します（デフォルト：除外）。[監視](/ja/monitoring-usage) を参照してください                                                                                                                                                                                                                                                                                                                                   |
```

</details>

<details>
<summary>errors-ja.md</summary>

```diff
diff --git a/docs-ja/pages/errors-ja.md b/docs-ja/pages/errors-ja.md
index 843f4b0..96510d9 100644
--- a/docs-ja/pages/errors-ja.md
+++ b/docs-ja/pages/errors-ja.md
@@ -76,5 +76,5 @@ Claude Code は、5xx レスポンスに対してステータスコードと API
 
 ```text theme={null}
-API Error: 500 Internal server error. This is a server-side issue, usually temporary — try again in a moment. If it persists, check status.claude.com.
+API Error: 500 Internal server error. This is a server-side issue, usually temporary — try again in a moment. If it persists, check https://status.claude.com.
 ```
 
@@ -94,5 +94,5 @@ API は、すべてのユーザー全体で一時的に容量に達していま
 
 ```text theme={null}
-API Error: Repeated 529 Overloaded errors. The API is at capacity — this is usually temporary. Try again in a moment. If it persists, check status.claude.com.
+API Error: Repeated 529 Overloaded errors. The API is at capacity — this is usually temporary. Try again in a moment. If it persists, check https://status.claude.com.
 ```
 
@@ -209,5 +209,5 @@ API キー、Amazon Bedrock プロジェクト、または Google Vertex AI プ
 
 ```text theme={null}
-API Error: Request rejected (429) · this may be a temporary capacity issue. If it persists, check status.claude.com.
+API Error: Request rejected (429) · this may be a temporary capacity issue. If it persists, check https://status.claude.com.
 ```
 
```

</details>

*...以降省略*

</details>


<!-- UPDATE_LOG_END -->
