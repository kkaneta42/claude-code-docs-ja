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

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index 6730210..40d8022 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,143 @@
 # Changelog
 
+## 2.1.285
+
+- Added `CLAUDE_CODE_DISABLE_WEB_FETCH` environment variable to turn off the WebFetch tool
+- Added `claude --desktop` to open the Claude desktop app on the current directory, or on a session with `--continue` / `--resume <id>`
+- Added `claude plugin configure <plugin>` to show a plugin's options and which are unset, or save new values read from stdin with `--values-stdin`
+- Added `<server>.<key>=<value>` to `claude plugin install --config`, so a bundled `.mcpb` MCP server's own settings can be set at install time and it starts without visiting `/plugin` → Configure
+- Added `allowedProviders` managed setting to limit which API providers a machine may use (Anthropic API, a custom endpoint, Bedrock, Mantle, Vertex AI, Foundry, Claude Platform on AWS, or a Cloud gateway)
+- Added `CLAUDE_CODE_NONSTREAMING_TIMEOUT_RETRIES` environment variable to cap re-sends of a non-streaming fallback request that timed out
+- Fixed `claude -p` with `CLAUDE_CODE_FORK_SUBAGENT=1`: a subagent's own Agent call now runs in the foreground, so the subagent gets the child's result
+- Fixed plugin and marketplace installs and updates over SSH ignoring the ssh program set in `GIT_SSH` or in your git config's `core.sshCommand`
+- Fixed Claude Code refusing to start when the OS denies reading the managed settings file; it now warns and starts without that file's policies. Other read errors and unparseable files stop every session
+- Fixed cloud sessions that restarted after their conversation was compacted refusing the next update to an artifact the session had already read or published
+- Fixed `claude plugin disable` and `enable` with a full `name@marketplace` id changing a settings entry in another letter case instead of the installed plugin's own
+- Fixed files attached to a message sent over Remote Control being left out after a single failed download; a network error, timeout or server error is now retried up to twice
+- Fixed switching models mid-session with a `set_model` request (such as the Agent SDK's `setModel`) leaving the new model on the built-in output-token limit and auto-compact window until restart
+- Fixed redacted logs and transcripts showing part of a URL password that contains `@`, or all of it when the URL writes its `@` as `%40`
+- Fixed SSH passphrase and new-host prompts from worktree and `/teleport` fetches taking over the terminal; these fetches now fail fast instead of asking
+- Fixed switching off an MCP server added mid-session in SDK and `-p` sessions leaving its tools available
+- Fixed `claude -p --permission-prompt-tool`: a background subagent's permission request now goes to the prompt tool instead of being auto-denied
+- Fixed `claude mcp list` and `claude mcp get`, and the not-found error of `claude mcp remove`, `login` and `logout`, printing line breaks and terminal escape sequences from MCP server names and values
+- Fixed sandbox auto-allow asking for approval on every run of many inline scripts (`python3 -c`, `node -e`) just because they contain `=`
+- Fixed fork subagents not keeping the session's plan mode or `dontAsk` mode: a fork now runs under its parent's permission mode and cannot exit plan mode
+- Fixed `claude remote-control --help` saying `--[no-]chrome` defaults to the machine's `/chrome` setting; spawned sessions keep Claude in Chrome off unless `--chrome` is passed
```

</details>

<details>
<summary>channels-reference-ja.md</summary>

```diff
diff --git a/docs-ja/pages/channels-reference-ja.md b/docs-ja/pages/channels-reference-ja.md
index 2d797ed..9f399e6 100644
--- a/docs-ja/pages/channels-reference-ja.md
+++ b/docs-ja/pages/channels-reference-ja.md
@@ -164,5 +164,7 @@
 
     ```text theme={null}
-    <channel source="webhook" path="/" method="POST">build failed on main: https://ci.example.com/run/1234</channel>
+    <channel source="webhook" path="/" method="POST">
+    build failed on main: https://ci.example.com/run/1234
+    </channel>
     ```
 
```

</details>

<details>
<summary>claude-apps-gateway-ja.md</summary>

```diff
diff --git a/docs-ja/pages/claude-apps-gateway-ja.md b/docs-ja/pages/claude-apps-gateway-ja.md
index 93c5686..88c90b7 100644
--- a/docs-ja/pages/claude-apps-gateway-ja.md
+++ b/docs-ja/pages/claude-apps-gateway-ja.md
@@ -361,4 +361,6 @@ hooks、`env`、および `Bash(npm *)` のようなスコープ付き権限ル
 Claude Desktop のみを実行するマシンはそれを必要とします。Claude Desktop は埋め込みセッションにモデルリストと無効化されたツールリストを適用しますが、出力許可リストは親設定としてのみそれらに到達します。`WebFetch` ドメインルールとサンドボックスネットワークルールの形式です。オプトインなしでは、これらのセッションは出力制限なしで実行され、何も警告しません。ゲートウェイはポリシーが許可しないモデルの推論リクエストを引き続き拒否します。
 
+プラグインマーケットプレイス許可リストも埋め込みセッションにのみ親設定として到達します。Claude Desktop の管理設定でユーザーが追加したプラグインマーケットプレイスをオフにすると、Claude Desktop 2.16120.0 以降は組織がプロビジョニングしなかったマーケットプレイスを非表示にし、それらからのインストールを拒否します。埋め込みセッションがそれらのマーケットプレイスから既にインストールされているプラグインの読み込みを停止するために、親設定として `strictKnownMarketplaces` リストを送信します。オプトインなしでは、Claude Code はそのリストを無視し、それらのプラグインは読み込み続けます。
+
 `/login` を通じてサインインする開発者のマシンはそれを必要としません。各 Claude Code セッションはゲートウェイからポリシーをフェッチします。
 
@@ -454,5 +456,5 @@ hooks ロックと `allowManagedPermissionRulesOnly` の開発者独自のルー
 * **`allowedMcpServers`**：最優先の管理ソースが設定しない場合、Claude Code は親が提供した許可リストを尊重します。`allowManagedMcpServersOnly` はそれをブロックしません。ロックは勝者の許可リストを管理値として強制するため、最優先の管理ソースが設定しない場合は親が提供した許可リストを含みます。最優先の管理ソースのリストは親のリストをブロックし、Claude Code が強制するリストです。ロックの隣にそこに `allowedMcpServers` を設定します。v2.1.223 より前では、任意の管理ソースのいずれかのキーの値は親のリストをブロックしました。
 * **`availableModels`**：勝者の管理ソースが設定しない場合、Claude Code は親が提供したモデルリストを尊重します。フリートがモデルを制限する場合、勝者ソースに `availableModels` を設定します。
-* **`strictKnownMarketplaces`**：勝者の管理ソースが設定しない場合、Claude Code は親が提供したプラグインマーケットプレイス許可リストを尊重します。フリートがマーケットプレイスを制限する場合、勝者ソースに `strictKnownMarketplaces` を設定します。Claude Code v2.1.282 以降が必要です。
+* **`strictKnownMarketplaces`**：勝者の管理ソースが設定しない場合、Claude Code は親が提供したプラグインマーケットプレイス許可リストを尊重します。Claude Desktop 2.16120.0 以降は、その管理設定でユーザーが追加したプラグインマーケットプレイスをオフにするときに 1 つを送信します。フリートがマーケットプレイスを制限する場合、勝者ソースに `strictKnownMarketplaces` を設定します。Claude Code v2.1.282 以降が必要です。
 * **`blockedMarketplaces`**：親が提供したマーケットプレイスブロックリストは通過し、管理ソースが設定するブロックリストに追加されます。ブロックリストはさらに制限することのみができるためです。Claude Code v2.1.282 以降が必要です。
 * **`strictPluginOnlyCustomization`**：このキーはロックに関係なくフィルターを通過し、Claude Code が開発者独自のカスタマイズ（保護フックを含む）を無視するようにします。ロックはそれをブロックしません。
```

</details>

<details>
<summary>cloud-environments-ja.md</summary>

```diff
diff --git a/docs-ja/pages/cloud-environments-ja.md b/docs-ja/pages/cloud-environments-ja.md
index 4104586..ffc18e1 100644
--- a/docs-ja/pages/cloud-environments-ja.md
+++ b/docs-ja/pages/cloud-environments-ja.md
@@ -79,5 +79,5 @@ DATABASE_URL=postgres://localhost:5432/myapp
 ```
 
-各セッションは起動時に環境の値を 1 回コピーして、Claude が実行するコマンドが読み取ることができる通常の環境変数にします。実行中のセッションは設定を再度読み取らないため、変数を編集または追加すると、その後に開始するセッションに影響します。既に実行中のセッションは開始時の値を保持します。
+各セッションは起動時に環境の値を 1 回コピーして、Claude が実行するコマンドが読み取ることができる通常の環境変数にします。ただし、`OTEL_*` 変数は除きます。Claude Code はそれらを独自の [テレメトリエクスポート](/docs/ja/monitoring-usage#telemetry-from-cloud-sessions-and-claude-tag) に使用し、実行するコマンドに渡しません。実行中のセッションは設定を再度読み取らないため、変数を編集または追加すると、その後に開始するセッションに影響します。既に実行中のセッションは開始時の値を保持します。
 
 クラウドセッションは起動時に自身でいくつかの変数も設定します。[`CLAUDE_AUTOCOMPACT_PCT_OVERRIDE`](/docs/ja/claude-code-on-the-web#manage-context) の場合、セッションが設定する値はここで追加した値をオーバーライドするため、ここでそのキーを追加しても効果がありません。
@@ -150,4 +150,5 @@ API 認証情報は Pro および Max プランで利用可能です。Team お
 * **Anthropic API およびパブリックパッケージレジストリ**: `api.anthropic.com`、`registry.npmjs.org`、`jsr.io`、`npm.jsr.io`、`pypi.org`、`files.pythonhosted.org`、`index.crates.io`、および `proxy.golang.org`
 * **セットアップスクリプトリクエスト**: Claude Code は [セットアップスクリプト](#setup-scripts) が実行された後、起動時にエージェントプロキシに接続します
+* **Claude Code のテレメトリエクスポート**: Claude Code は [テレメトリエクスポート](/docs/ja/monitoring-usage#telemetry-from-cloud-sessions-and-claude-tag) を実行するコマンドではなく自身で送信し、そのリクエストはエージェントプロキシを通過しません
 
 <h3 id="select-an-environment-from-the-cli">
@@ -204,10 +205,10 @@ Owner は [claude.ai/admin-settings/claude-code](https://claude.ai/admin-setting
 </h2>
 
-各環境は 1 つのネットワークアクセスレベルを設定し、セッションが行える送信接続を制御します。デフォルトレベルの **Trusted** はパッケージレジストリおよび他の [許可リストドメイン](#default-allowed-domains) を許可します。**Custom** は独自のドメインリストを取ります。
+各環境は 1 つのネットワークアクセスレベルを設定します。これは、セッションが行える送信接続を制御します。デフォルトレベルの **Trusted** は、パッケージレジストリおよび他の [許可リストに登録されたドメイン](#default-allowed-domains) を許可します。**Custom** はカスタムドメインリストを使用します。
 
-環境のネットワークアクセスを変更するには、[編集用に開いて](#configure-your-environment) ダイアログの **Network access** セレクタを使用します。[共有環境](#organization-shared-environments) は読み取り専用で開くため、Owner は [admin settings](https://claude.ai/admin-settings) の **Cloud environments** ページからそのネットワークアクセスを変更します。セレクタを開くクラウドアイコンは、[Default 環境](#the-default-environment) の下にリストされたアプリサーフェスおよび [ルーチンエディタ](/docs/ja/routines#environments-and-network-access) に表示されます。個人環境は claude.ai アカウント設定に別のページを持ちません。
+環境のネットワークアクセスを変更するには、[編集用に開き](#configure-your-environment)、ダイアログの **Network access** セレクターを使用します。[共有環境](#organization-shared-environments) はそこで読み取り専用で開くため、Owner は [admin settings](https://claude.ai/admin-settings) の **Cloud environments** ページからネットワークアクセスを変更します。クラウドアイコンはセレクターを開き、[The Default environment](#the-default-environment) に記載されているアプリサーフェスと [routine editor](/docs/ja/routines#environments-and-network-access) に表示されます。個人環境は claude.ai アカウント設定に別ページを持ちません。
 
 <Note>
-  セッションまたはルーチンで有効にする MCP コネクタは、コネクタホストを **Allowed domains** に追加しなくても機能します。コネクタトラフィックはセッションのネットワークではなく Anthropic のサーバーを通じて移動するためです。これは [セキュリティと分離](/docs/ja/claude-code-on-the-web#security-and-isolation) の下に記載されている同じ Anthropic バウンドチャネルに依存します。Claude が到達できるツールを制限するために不要なコネクタをオフにします。
+  セッションまたはルーチンで有効にした MCP コネクターは、**Allowed domains** にホストを追加しなくても機能します。コネクタートラフィックはセッションのネットワークではなく Anthropic のサーバーを通じて移動するためです。これは [Security and isolation](/docs/ja/claude-code-on-the-web#security-and-isolation) に記載されている同じ Anthropic バウンドチャネルに依存しています。不要なコネクターをオフにして、Claude が到達できるツールを制限します。
 </Note>
```

</details>

<details>
<summary>code-review-ja.md</summary>

```diff
diff --git a/docs-ja/pages/code-review-ja.md b/docs-ja/pages/code-review-ja.md
index 5bb5fe0..cce39dd 100644
--- a/docs-ja/pages/code-review-ja.md
+++ b/docs-ja/pages/code-review-ja.md
@@ -49,5 +49,5 @@ Claude を管理サービスではなく独自の CI インフラストラクチ
 | 🟣 | Pre-existing | コードベースに存在するが、この PR で導入されなかったバグ |
 
-結果には、展開可能な拡張推論セクションが含まれており、Claude がなぜ問題をフラグ立てしたのか、どのように問題を検証したのかを理解するために展開できます。
+結果には、展開可能な **Why this was flagged** セクションが含まれており、Claude がなぜ問題をフラグ立てしたのか、どのように問題を検証したのかを理解するために展開できます。
 
 <h3 id="rate-and-reply-to-findings">
@@ -382,5 +382,5 @@ Claude が後でセッションで報告された結果を修正すると、そ
 努力レベルとフラグの後、Claude Code は行の残りを 2 つの方法のいずれかで読み取ります：
 
-* **`ultra` なし**：残りのすべてはレビュータ​​ーゲットです。別のコマンド名で始まる場合でも同様です。`/code-review /fix-issue 123` は `/fix-issue 123` をターゲットテキストとしてレビューし、`/fix-issue` を 2 番目の[スタックされたスキル](/docs/ja/skills#pass-arguments-to-skills)として読み込みません。v2.1.218 より前は、`/code-review` の後にスタックされたコマンドは独自のスキルとして展開されました。
+* **`ultra` なし**：残りのすべてはレビューターゲットです。別のコマンド名で始まる場合でも同様です。`/code-review /fix-issue 123` は `/fix-issue 123` をターゲットテキストとしてレビューし、`/fix-issue` を 2 番目の[スタックされたスキル](/docs/ja/skills#pass-arguments-to-skills)として読み込みません。v2.1.218 より前は、`/code-review` の後にスタックされたコマンドは独自のスキルとして展開されました。
 * **`ultra` あり**：Claude Code は単一の単語をベースブランチまたは PR 番号として読み取り、ブランチまたは PR に名前を付けない長いテキストを[レビューに添付されたノート](/docs/ja/ultrareview#pass-a-request-in-plain-words)に変換します。`/code-review ultra check my auth changes` は現在のブランチをレビューし、Claude は結果をノートに関連付けます。
 
```

</details>

*...以降省略*

</details>


<details>
<summary>2026-09-29</summary>

**変更ファイル:**

```
 docs-ja/pages/accessibility-ja.md                  |   46 +-
 docs-ja/pages/admin-setup-ja.md                    |   98 +-
 docs-ja/pages/advisor-ja.md                        |   63 +-
 docs-ja/pages/agent-teams-ja.md                    |   28 +-
 docs-ja/pages/agent-view-ja.md                     |  532 ++++----
 docs-ja/pages/agents-ja.md                         |   14 +-
 docs-ja/pages/amazon-bedrock-ja.md                 |   36 +-
 docs-ja/pages/analytics-ja.md                      |    6 +-
 docs-ja/pages/artifacts-ja.md                      |   90 +-
 docs-ja/pages/authentication-ja.md                 |   48 +-
 docs-ja/pages/auto-mode-config-ja.md               |   64 +-
 docs-ja/pages/best-practices-ja.md                 |   58 +-
 docs-ja/pages/champion-kit-ja.md                   |   98 +-
 docs-ja/pages/changelog.md                         |  103 ++
 docs-ja/pages/channels-ja.md                       |   22 +-
 docs-ja/pages/channels-reference-ja.md             |   32 +-
 docs-ja/pages/checkpointing-ja.md                  |    2 +-
 docs-ja/pages/chrome-ja.md                         |   12 +-
 docs-ja/pages/claude-apps-gateway-config-ja.md     |  240 ++--
 docs-ja/pages/claude-apps-gateway-deploy-ja.md     |  118 +-
 docs-ja/pages/claude-apps-gateway-ja.md            |   64 +-
 docs-ja/pages/claude-apps-gateway-on-aws-ja.md     |   21 +-
 docs-ja/pages/claude-apps-gateway-on-gcp-ja.md     |   38 +-
 .../pages/claude-apps-gateway-spend-limits-ja.md   |   50 +-
 docs-ja/pages/claude-code-on-the-web-ja.md         |   51 +-
 docs-ja/pages/claude-directory-ja.md               |  254 ++--
 docs-ja/pages/claude-projects-ja.md                |  134 +-
 docs-ja/pages/claude-security-ja.md                |   16 +-
 docs-ja/pages/claude-tag-ja.md                     |    2 +-
 docs-ja/pages/cli-reference-ja.md                  |  248 ++--
 docs-ja/pages/cloud-environments-ja.md             |   93 +-
 docs-ja/pages/code-review-ja.md                    |   40 +-
 docs-ja/pages/commands-ja.md                       |  231 ++--
 docs-ja/pages/common-workflows-ja.md               |   12 +-
 docs-ja/pages/communications-kit-ja.md             |   66 +-
 docs-ja/pages/computer-use-ja.md                   |   24 +-
 docs-ja/pages/context-window-ja.md                 |   30 +-
 docs-ja/pages/costs-ja.md                          |   41 +-
 docs-ja/pages/cross-session-messaging-ja.md        |   87 +-
 docs-ja/pages/data-usage-ja.md                     |   30 +-
 docs-ja/pages/debug-your-config-ja.md              |   62 +-
 docs-ja/pages/deep-links-ja.md                     |   20 +-
 docs-ja/pages/desktop-ja.md                        |  174 +--
 docs-ja/pages/desktop-quickstart-ja.md             |   15 +-
 docs-ja/pages/desktop-scheduled-tasks-ja.md        |   34 +-
 docs-ja/pages/devcontainer-ja.md                   |    8 +-
 docs-ja/pages/env-vars-ja.md                       |  774 +++++------
 docs-ja/pages/errors-ja.md                         | 1431 +++++++++++++-------
 docs-ja/pages/fast-mode-ja.md                      |   16 +-
 docs-ja/pages/feature-availability-ja.md           |   36 +-
 docs-ja/pages/features-overview-ja.md              |  140 +-
 docs-ja/pages/fullscreen-ja.md                     |  120 +-
 docs-ja/pages/github-actions-cloud-providers-ja.md |   20 +-
 docs-ja/pages/github-actions-ja.md                 |   52 +-
 docs-ja/pages/github-enterprise-server-ja.md       |   58 +-
 docs-ja/pages/glossary-ja.md                       |   41 +-
 docs-ja/pages/goal-ja.md                           |   58 +-
 docs-ja/pages/google-vertex-ai-ja.md               |    6 +-
 docs-ja/pages/headless-ja.md                       |  120 +-
 docs-ja/pages/hooks-guide-ja.md                    |  174 +--
 docs-ja/pages/hooks-ja.md                          |  880 ++++++------
 docs-ja/pages/how-claude-code-works-ja.md          |   53 +-
 docs-ja/pages/interactive-mode-ja.md               |  312 ++---
 docs-ja/pages/jetbrains-ja.md                      |   12 +-
 docs-ja/pages/keybindings-ja.md                    |  501 +++----
 docs-ja/pages/large-codebases-ja.md                |   44 +-
 docs-ja/pages/llm-gateway-connect-ja.md            |   52 +-
 docs-ja/pages/llm-gateway-ja.md                    |    2 +-
 docs-ja/pages/llm-gateway-protocol-ja.md           |   97 +-
 docs-ja/pages/llm-gateway-rollout-ja.md            |   52 +-
 docs-ja/pages/managed-mcp-ja.md                    |  166 +--
 docs-ja/pages/managed-settings-ja.md               |  253 ++--
 docs-ja/pages/mcp-ja.md                            |  107 +-
 docs-ja/pages/mcp-quickstart-ja.md                 |   26 +-
 docs-ja/pages/memory-ja.md                         |   97 +-
 docs-ja/pages/mobile-ja.md                         |   12 +-
 docs-ja/pages/model-config-ja.md                   |  144 +-
 docs-ja/pages/monitoring-usage-ja.md               |  420 +++---
 docs-ja/pages/network-config-ja.md                 |   52 +-
 docs-ja/pages/output-styles-ja.md                  |   40 +-
 docs-ja/pages/overview-ja.md                       |   26 +-
 docs-ja/pages/permission-modes-ja.md               |  431 +++---
 docs-ja/pages/permissions-ja.md                    |  219 +--
 docs-ja/pages/platforms-ja.md                      |   46 +-
 docs-ja/pages/plugin-evals-ja.md                   |  203 +--
 docs-ja/pages/prompt-caching-ja.md                 |  154 ++-
 docs-ja/pages/quickstart-ja.md                     |   30 +-
 docs-ja/pages/remote-control-ja.md                 |  418 +++---
 docs-ja/pages/routines-ja.md                       |   33 +-
 docs-ja/pages/sandbox-environments-ja.md           |   38 +-
 docs-ja/pages/sandboxing-ja.md                     |  203 +--
 docs-ja/pages/scheduled-tasks-ja.md                |   60 +-
 docs-ja/pages/security-guidance-ja.md              |   66 +-
 docs-ja/pages/security-ja.md                       |    3 +-
 .../self-hosted-environments-configuration-ja.md   |   96 +-
 .../pages/self-hosted-environments-deploy-ja.md    |   40 +-
 .../pages/self-hosted-environments-identity-ja.md  |   48 +-
 docs-ja/pages/self-hosted-environments-ja.md       |   12 +-
 .../pages/self-hosted-environments-reference-ja.md |  202 +--
 docs-ja/pages/server-managed-settings-ja.md        |   41 +-
 docs-ja/pages/sessions-ja.md                       |  105 +-
 docs-ja/pages/settings-ja.md                       |   34 +-
 docs-ja/pages/settings-reference-ja.md             | 1294 ++++++++++--------
 docs-ja/pages/setup-ja.md                          |   16 +-
 docs-ja/pages/skills-ja.md                         |  203 +--
 docs-ja/pages/slack-ja.md                          |   40 +-
 docs-ja/pages/statusline-ja.md                     |  116 +-
 docs-ja/pages/sub-agents-ja.md                     |  300 ++--
 docs-ja/pages/terminal-config-ja.md                |  112 +-
 docs-ja/pages/tools-reference-ja.md                |  134 +-
 docs-ja/pages/troubleshoot-install-ja.md           |  126 +-
 docs-ja/pages/troubleshooting-ja.md                |   25 +-
 docs-ja/pages/ultrareview-ja.md                    |   38 +-
 docs-ja/pages/voice-dictation-ja.md                |   56 +-
 docs-ja/pages/vs-code-ja.md                        |  155 ++-
 docs-ja/pages/web-quickstart-ja.md                 |   32 +-
 docs-ja/pages/workflows-ja.md                      |  110 +-
 docs-ja/pages/zero-data-retention-ja.md            |   24 +-
 118 files changed, 8185 insertions(+), 7027 deletions(-)
```

<details>
<summary>accessibility-ja.md</summary>

```diff
diff --git a/docs-ja/pages/accessibility-ja.md b/docs-ja/pages/accessibility-ja.md
index c79d6f1..4477579 100644
--- a/docs-ja/pages/accessibility-ja.md
+++ b/docs-ja/pages/accessibility-ja.md
@@ -39,15 +39,15 @@ Claude Code が最初に出力する行がモードを確認します。`[Screen
 次の表は、各アクセシビリティオプション、フラグ、環境変数、または設定として設定するかどうか、および何を変更するかを示しています。
 
-| オプション                                                                   | タイプ  | 変更内容                                                                                                                                               |
-| :---------------------------------------------------------------------- | :--- | :------------------------------------------------------------------------------------------------------------------------------------------------- |
-| [`--ax-screen-reader`](/docs/ja/cli-reference#cli-flags)                     | フラグ  | 1 つのセッションのスクリーンリーダーモード。                                                                                                                            |
-| [`CLAUDE_AX_SCREEN_READER`](/docs/ja/env-vars#variables)                     | 環境変数 | それを設定したシェルから開始されたセッションのスクリーンリーダーモード。                                                                                                               |
-| [`axScreenReader`](/docs/ja/settings-reference#axscreenreader)               | 設定   | `true` の場合、すべてのセッションのスクリーンリーダーモード。                                                                                                                 |
-| [`CLAUDE_AX_STARTUP_QUIET_MS`](/docs/ja/env-vars#variables)                  | 環境変数 | Claude Code が確認行の後、スクリーンリーダーモードで最初のプロンプトを描画する前に待機する時間。Claude Code v2.1.217 以降が必要です。                                                                |
-| [`CLAUDE_AX_PREPARK_MS`](/docs/ja/env-vars#variables)                        | 環境変数 | Claude Code が行の開始時にカーソルを置いて、スクリーンリーダーモードで新しい行または変更された行を書き込む前に待機する時間。Claude Code v2.1.233 以降が必要です。                                                  |
-| [`CLAUDE_CODE_ACCESSIBILITY`](/docs/ja/env-vars#variables)                   | 環境変数 | `1` に設定した場合、macOS Zoom などのスクリーン拡大鏡に対して表示されたままのターミナルカーソル。カーソルは入力キャレットに従い、Claude Code v2.1.218 以降では、`/config` や `/plugin` などのメニューとパネルの強調表示された行に従います。 |
-| [`prefersReducedMotion`](/docs/ja/settings-reference#prefersreducedmotion)   | 設定   | `true` の場合、スピナー、シマー、およびその他のアニメーションが削減または非表示になります。                                                                                                  |
-| [`theme`](/docs/ja/settings-reference#theme)                                 | 設定   | 色覚異常対応の `dark-daltonized` および `light-daltonized` テーマを含むインターフェースカラー。[`/theme`](/docs/ja/commands#all-commands) で選択することもできます。                             |
-| [`preferredNotifChannel`](/docs/ja/settings-reference#preferrednotifchannel) | 設定   | 値を `"terminal_bell"` にすると、Claude があなたを待機している場合、スクリーンリーダーモード外でターミナルベルが鳴ります。                                                                         |
+| オプション | タイプ | 変更内容 |
+| :- | :- | :- |
+| [`--ax-screen-reader`](/docs/ja/cli-reference#cli-flags) | フラグ | 1 つのセッションのスクリーンリーダーモード。 |
+| [`CLAUDE_AX_SCREEN_READER`](/docs/ja/env-vars#variables) | 環境変数 | それを設定したシェルから開始されたセッションのスクリーンリーダーモード。 |
+| [`axScreenReader`](/docs/ja/settings-reference#axscreenreader) | 設定 | `true` の場合、すべてのセッションのスクリーンリーダーモード。 |
+| [`CLAUDE_AX_STARTUP_QUIET_MS`](/docs/ja/env-vars#variables) | 環境変数 | Claude Code が確認行の後、スクリーンリーダーモードで最初のプロンプトを描画する前に待機する時間。Claude Code v2.1.217 以降が必要です。 |
+| [`CLAUDE_AX_PREPARK_MS`](/docs/ja/env-vars#variables) | 環境変数 | Claude Code が行の開始時にカーソルを置いて、スクリーンリーダーモードで新しい行または変更された行を書き込む前に待機する時間。Claude Code v2.1.233 以降が必要です。 |
+| [`CLAUDE_CODE_ACCESSIBILITY`](/docs/ja/env-vars#variables) | 環境変数 | `1` に設定した場合、macOS Zoom などのスクリーン拡大鏡に対して表示されたままのターミナルカーソル。カーソルは入力キャレットに従い、Claude Code v2.1.218 以降では、`/config` や `/plugin` などのメニューとパネルの強調表示された行に従います。 |
+| [`prefersReducedMotion`](/docs/ja/settings-reference#prefersreducedmotion) | 設定 | `true` の場合、スピナー、シマー、およびその他のアニメーションが削減または非表示になります。 |
+| [`theme`](/docs/ja/settings-reference#theme) | 設定 | 色覚異常対応の `dark-daltonized` および `light-daltonized` テーマを含むインターフェースカラー。[`/theme`](/docs/ja/commands#all-commands) で選択することもできます。 |
+| [`preferredNotifChannel`](/docs/ja/settings-reference#preferrednotifchannel) | 設定 | 値を `"terminal_bell"` にすると、Claude があなたを待機している場合、スクリーンリーダーモード外でターミナルベルが鳴ります。 |
 
```

</details>

<details>
<summary>admin-setup-ja.md</summary>

```diff
diff --git a/docs-ja/pages/admin-setup-ja.md b/docs-ja/pages/admin-setup-ja.md
index 8b44218..25bc825 100644
--- a/docs-ja/pages/admin-setup-ja.md
+++ b/docs-ja/pages/admin-setup-ja.md
@@ -15,11 +15,11 @@ Claude Code は、ローカル開発者設定よりも優先されるマネー
 </Note>
 
-| 決定                                                        | 選択内容                      | 参照                                                                                                                                                                         |
-| :-------------------------------------------------------- | :------------------------ | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
-| [API プロバイダーを選択する](#choose-your-api-provider)              | Claude Code が認証される場所と課金方法 | [Authentication](/docs/ja/authentication)、[Amazon Bedrock](/docs/ja/amazon-bedrock)、[Google Cloud の Agent Platform](/docs/ja/google-vertex-ai)、[Microsoft Foundry](/docs/ja/microsoft-foundry) |
-| [設定がデバイスに到達する方法を決定する](#decide-how-settings-reach-devices) | マネージドポリシーが開発者マシンに到達する方法   | [Server-managed settings](/docs/ja/server-managed-settings)、[Delivery mechanisms](/docs/ja/managed-settings#delivery-mechanisms)                                                     |
-| [実行する内容を決定する](#decide-what-to-enforce)                    | どのツール、コマンド、統合が許可されるか      | [Permissions](/docs/ja/permissions)、[Sandboxing](/docs/ja/sandboxing)                                                                                                                |
-| [使用状況の可視性をセットアップする](#set-up-usage-visibility)             | 支出と採用を追跡する方法              | [Analytics](/docs/ja/analytics)、[Monitoring](/docs/ja/monitoring-usage)、[Costs](/docs/ja/costs)                                                                                           |
-| [データ処理を確認する](#review-data-handling)                       | データ保持とコンプライアンス体制          | [Data usage](/docs/ja/data-usage)、[Security](/docs/ja/security)                                                                                                                      |
+| 決定 | 選択内容 | 参照 |
+| :- | :- | :- |
+| [API プロバイダーを選択する](#choose-your-api-provider) | Claude Code が認証される場所と課金方法 | [Authentication](/docs/ja/authentication)、[Amazon Bedrock](/docs/ja/amazon-bedrock)、[Google Cloud の Agent Platform](/docs/ja/google-vertex-ai)、[Microsoft Foundry](/docs/ja/microsoft-foundry) |
+| [設定がデバイスに到達する方法を決定する](#decide-how-settings-reach-devices) | マネージドポリシーが開発者マシンに到達する方法 | [Server-managed settings](/docs/ja/server-managed-settings)、[Delivery mechanisms](/docs/ja/managed-settings#delivery-mechanisms) |
+| [実行する内容を決定する](#decide-what-to-enforce) | どのツール、コマンド、統合が許可されるか | [Permissions](/docs/ja/permissions)、[Sandboxing](/docs/ja/sandboxing) |
+| [使用状況の可視性をセットアップする](#set-up-usage-visibility) | 支出と採用を追跡する方法 | [Analytics](/docs/ja/analytics)、[Monitoring](/docs/ja/monitoring-usage)、[Costs](/docs/ja/costs) |
+| [データ処理を確認する](#review-data-handling) | データ保持とコンプライアンス体制 | [Data usage](/docs/ja/data-usage)、[Security](/docs/ja/security) |
 
 <h2 id="choose-your-api-provider">
@@ -29,11 +29,11 @@ Claude Code は、ローカル開発者設定よりも優先されるマネー
 Claude Code は複数の API プロバイダーのいずれかを通じて Claude に接続します。選択は課金、認証、継承するコンプライアンス体制、および開発者が使用できる Claude Code 機能に影響します。
 
-| プロバイダー                        | 選択する場合                                                                                     |
-| :---------------------------- | :----------------------------------------------------------------------------------------- |
+| プロバイダー | 選択する場合 |
+| :- | :- |
```

</details>

<details>
<summary>advisor-ja.md</summary>

```diff
diff --git a/docs-ja/pages/advisor-ja.md b/docs-ja/pages/advisor-ja.md
index 391e629..ff1a045 100644
--- a/docs-ja/pages/advisor-ja.md
+++ b/docs-ja/pages/advisor-ja.md
@@ -96,16 +96,16 @@ Claude Code はそのセッションの `advisorModel` 設定の代わりにフ
 </h2>
 
-アドバイザーはメインモデル以上の能力を持つ必要があります。各メインモデルで受け入れられるアドバイザーは以下の通りです。
-
-| メインモデル                | 受け入れられるアドバイザー              | 注記                                                                       |
-| --------------------- | -------------------------- | ------------------------------------------------------------------------ |
-| Haiku 4.5             | Fable、Opus、Sonnet          | Haiku はアドバイザーを呼び出すことはできますが、アドバイザーとして機能することはできません                         |
-| Sonnet 4.6            | Fable、Opus、Sonnet          |                                                                          |
-| Sonnet 5              | Fable、Opus 4.7 以降、Sonnet 5 | Sonnet 4.6 アドバイザーは拒否され、Opus 4.6 アドバイザーを使用したリクエストは API エラーで失敗します          |
-| Opus 4.6              | Fable、Opus、Sonnet 5        | Sonnet 4.6 アドバイザーは拒否されます                                                 |
-| Opus 4.7 または Opus 4.8 | Fable、および Opus 4.7 以降      | Opus 4.6 または Sonnet アドバイザーは拒否されます                                        |
-| Opus 5.5 または Opus 5   | Fable、および Opus 5 以降        | Opus 4.6 または Sonnet アドバイザーは拒否され、API は Opus 4.7 または Opus 4.8 アドバイザーを拒否します |
-| Fable 5               | Fable 5.1 または Fable 5      | Opus または Sonnet アドバイザーは拒否されます                                            |
-| Fable 5.1             | Fable 5.1                  | Opus または Sonnet アドバイザーは拒否され、Fable 5 アドバイザーを使用したリクエストは API エラーで失敗します      |
+アドバイザーは、メインモデル以上の能力を持つ必要があります。各メインモデルで受け入れられるアドバイザーは以下の通りです。
+
+| メインモデル | 受け入れられるアドバイザー | 注記 |
+| - | - | - |
+| Haiku 4.5 | Fable、Opus、Sonnet | Haiku はアドバイザーを呼び出すことはできますが、アドバイザーとして機能することはできません |
+| Sonnet 4.6 | Fable、Opus、Sonnet | |
+| Sonnet 5.5 または Sonnet 5 | Fable、Opus 4.7 以降、Sonnet 5 以降 | Sonnet 4.6 アドバイザーは拒否され、API は Opus 4.6 アドバイザーを拒否します |
+| Opus 4.6 | Fable、Opus、Sonnet 5 以降 | Sonnet 4.6 アドバイザーは拒否されます |
+| Opus 4.7 または Opus 4.8 | Fable、および Opus 4.7 以降 | Opus 4.6 または Sonnet アドバイザーは拒否されます |
+| Opus 5.5 または Opus 5 | Fable、および Opus 5 以降 | Opus 4.6 または Sonnet アドバイザーは拒否され、API は Opus 4.7 または Opus 4.8 アドバイザーを拒否します |
+| Fable 5 | Fable 5.1 または Fable 5 | Opus または Sonnet アドバイザーは拒否されます |
```

</details>

<details>
<summary>agent-teams-ja.md</summary>

```diff
diff --git a/docs-ja/pages/agent-teams-ja.md b/docs-ja/pages/agent-teams-ja.md
index 8aa560b..004be47 100644
--- a/docs-ja/pages/agent-teams-ja.md
+++ b/docs-ja/pages/agent-teams-ja.md
@@ -40,11 +40,11 @@
 </Frame>
 
-|             | Subagents                                                                                                   | エージェントチーム                                                                                     |
-| :---------- | :---------------------------------------------------------------------------------------------------------- | :-------------------------------------------------------------------------------------------- |
-| **コンテキスト**  | 独自のコンテキストウィンドウ。結果は呼び出し元に返される                                                                                | 独自のコンテキストウィンドウ。完全に独立                                                                          |
-| **通信**      | 呼び出し元に結果を返します。Claude が生成した際に名前を付けた Subagents は、[互いにメッセージを送信](/docs/ja/sub-agents#what-loads-at-startup)することもできます | チームメンバーが互いに直接メッセージを送信                                                                         |
-| **調整**      | メインエージェントがすべての作業を管理                                                                                         | メッセージを通じた自己調整、および [Task ツールを持つエージェント](/docs/ja/tools-reference#task-tool-availability)のための共有タスクリスト |
-| **最適な用途**   | 結果のみが重要な焦点を絞ったタスク                                                                                           | 議論と協力が必要な複雑な作業                                                                                |
-| **トークンコスト** | 低い：結果がメインコンテキストに要約されて返される                                                                                   | 高い：各チームメンバーが個別の Claude インスタンス                                                                 |
+| | Subagents | エージェントチーム |
+| :- | :- | :- |
+| **コンテキスト** | 独自のコンテキストウィンドウ。結果は呼び出し元に返される | 独自のコンテキストウィンドウ。完全に独立 |
+| **通信** | 呼び出し元に結果を返します。Claude が生成した際に名前を付けた Subagents は、[互いにメッセージを送信](/docs/ja/sub-agents#what-loads-at-startup)することもできます | チームメンバーが互いに直接メッセージを送信 |
+| **調整** | メインエージェントがすべての作業を管理 | メッセージを通じた自己調整、および [Task ツールを持つエージェント](/docs/ja/tools-reference#task-tool-availability)のための共有タスクリスト |
+| **最適な用途** | 結果のみが重要な焦点を絞ったタスク | 議論と協力が必要な複雑な作業 |
+| **トークンコスト** | 低い：結果がメインコンテキストに要約されて返される | 高い：各チームメンバーが個別の Claude インスタンス |
 
 結果を報告する必要がある迅速で焦点を絞ったワーカーが必要な場合は subagents を使用してください。チームメンバーが調査結果を共有し、互いに検証し、独立して調整する必要がある場合は、エージェントチームを使用してください。
@@ -259,10 +259,10 @@ Claude は通常の subagent にも独自に名前を付けるため、後でメ
 エージェントチームは以下で構成されています。
 
-| コンポーネント     | 役割                                       |
-| :---------- | :--------------------------------------- |
+| コンポーネント | 役割 |
+| :- | :- |
```

</details>

<details>
<summary>agent-view-ja.md</summary>

```diff
diff --git a/docs-ja/pages/agent-view-ja.md b/docs-ja/pages/agent-view-ja.md
index c4bb971..ca92a56 100644
--- a/docs-ja/pages/agent-view-ja.md
+++ b/docs-ja/pages/agent-view-ja.md
@@ -113,20 +113,20 @@ Completed
 各行は、セッションの状態を示すアイコンで始まります。アイコンの色とアニメーションはセッションの状態を示します：
 
-| 状態    | アイコン表示  | 意味                                                                                                                                                                                                                                                                                                 |
-| :---- | :------ | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
-| 作業中   | アニメーション | Claude がアクティブにツールを実行しているか、応答を生成しています                                                                                                                                                                                                                                                               |
-| 入力が必要 | 黄色      | Claude は特定の質問または許可決定をあなたから待機しています。あなたのみが提供できる答え、許可決定、または別のプロンプト。例えば [サンドボックス](/docs/ja/sandboxing) プロンプトでネットワークホストを許可するか、MCP サーバーの [入力リクエストに応答する](/docs/ja/mcp#respond-to-mcp-elicitation-requests)。アタッチされたターミナルが必要なコマンド。例えば `/install-github-app` または `/mcp` 設定リスト。[ここで無人セッションを保持します](#attach-to-a-session) |
-| アイドル  | 薄い      | セッションはすることがなく、次のプロンプトの準備ができています                                                                                                                                                                                                                                                                    |
-| 完了    | 緑       | タスクが正常に完了しました                                                                                                                                                                                                                                                                                      |
-| 失敗    | 赤       | タスクがエラーで終了しました                                                                                                                                                                                                                                                                                     |
-| 停止    | グレー     | セッションは `Ctrl+X` または `claude stop` で停止されました。[そのプロセスは Claude Code の外から終了されました](#the-supervisor-process)。または [バックグラウンドサービスがオフの間に終了しました](#sessions-show-as-failed-after-shutdown)                                                                                                                      |
+| 状態 | アイコン表示 | 意味 |
+| :- | :- | :- |
+| 作業中 | アニメーション | Claude がアクティブにツールを実行しているか、応答を生成しています |
+| 入力が必要 | 黄色 | Claude は特定の質問または許可決定をあなたから待機しています。あなたのみが提供できる答え、許可決定、または別のプロンプト。例えば [サンドボックス](/docs/ja/sandboxing) プロンプトでネットワークホストを許可するか、MCP サーバーの [入力リクエストに応答する](/docs/ja/mcp#respond-to-mcp-elicitation-requests)。アタッチされたターミナルが必要なコマンド。例えば `/install-github-app` または `/mcp` 設定リスト。[ここで無人セッションを保持します](#attach-to-a-session) |
+| アイドル | 薄い | セッションはすることがなく、次のプロンプトの準備ができています |
+| 完了 | 緑 | タスクが正常に完了しました |
+| 失敗 | 赤 | タスクがエラーで終了しました |
+| 停止 | グレー | セッションは `Ctrl+X` または `claude stop` で停止されました。[そのプロセスは Claude Code の外から終了されました](#the-supervisor-process)。または [バックグラウンドサービスがオフの間に終了しました](#sessions-show-as-failed-after-shutdown) |
 
 別に、アイコンの形状は基盤となるプロセスが実行しているかどうかを示します：
 
-| 形状                 | 意味                                                                           |
-| :----------------- | :--------------------------------------------------------------------------- |
-| `✻` またはアニメーション `✽` | セッションプロセスは生きており、すぐに返信します                                                     |
-| `∙`                | プロセスは終了しました。ピーク表示、返信、またはアタッチはできます。Claude は中断したところから再開します                     |
```

</details>

<details>
<summary>agents-ja.md</summary>

```diff
diff --git a/docs-ja/pages/agents-ja.md b/docs-ja/pages/agents-ja.md
index 688cc7a..3200061 100644
--- a/docs-ja/pages/agents-ja.md
+++ b/docs-ja/pages/agents-ja.md
@@ -9,11 +9,11 @@
 Claude Code には、複数のタスクを同時に処理する 5 つの方法があります。[サブエージェント](/docs/ja/sub-agents)、[エージェントビュー](/docs/ja/agent-view)、[エージェントチーム](/docs/ja/agent-teams)、[動的ワークフロー](/docs/ja/workflows)、および [プロジェクト](/docs/ja/claude-projects) です。これらは、各会話に自分で留まるのか、Claude にワーカーのグループを調整させるのかという関与の度合いや、作業がマシン上で実行されるのかクラウドで実行されるのかという点で異なります。
 
-| アプローチ                         | 提供内容                                                                                                                                                               | 使用する場合                                                                                                         |
-| :---------------------------- | :----------------------------------------------------------------------------------------------------------------------------------------------------------------- | :------------------------------------------------------------------------------------------------------------- |
-| [サブエージェント](/docs/ja/sub-agents)    | 1 つのセッション内で委任されたワーカーが、独自のコンテキストでサイドタスクを実行し、サマリーを返す                                                                                                                 | サイドタスクが検索結果、ログ、またはファイルコンテンツで主な会話を埋め尽くす場合（再度参照しない）                                                              |
-| [エージェントビュー](/docs/ja/agent-view)   | `claude agents` で開く、バックグラウンドで実行されているセッションをディスパッチして監視する 1 つの画面。リサーチプレビュー                                                                                            | 複数の独立したタスクがあり、それらを引き継いで、一目で状態を確認し、必要な場合のみ介入したい場合                                                               |
-| [エージェントチーム](/docs/ja/agent-teams)  | 共有タスクリストとエージェント間メッセージングを備えた複数の調整されたセッション。リーダーによって管理される。実験的で、デフォルトでは無効                                                                                              | Claude にプロジェクトを分割させ、割り当てさせ、ワーカーを同期させたい場合                                                                       |
-| [プロジェクト](/docs/ja/claude-projects) | claude.ai/code またはデスクトップアプリでの 1 つの継続的な会話。Claude は threads と呼ばれる並列クラウドセッションを開始し、各セッションにプロジェクトのリポジトリ、指示、およびメモリを提供し、どのセッションがあなたを必要としているかを表示します。Pro および Max でのパブリックベータ | 作業が数日または数週間にわたる多くのタスクに及び、マシンがオフの場合でも実行を続け、各セッションをディスパッチして追跡するのではなく、一度説明したい場合                                   |
-| [動的ワークフロー](/docs/ja/workflows)     | 多くのサブエージェントを実行し、その結果をチェックするスクリプト。1 回のターンで調整するには大きすぎるジョブ向け                                                                                                          | タスクが大きすぎてサブエージェント数個では対応できない場合、または検出結果を相互に検証したい場合。コードベース全体の監査、500 ファイルのマイグレーション、相互検証が必要な調査、または複数の角度から作成されたプランなど |
+| アプローチ | 提供内容 | 使用する場合 |
+| :- | :- | :- |
+| [サブエージェント](/docs/ja/sub-agents) | 1 つのセッション内で委任されたワーカーが、独自のコンテキストでサイドタスクを実行し、サマリーを返す | サイドタスクが検索結果、ログ、またはファイルコンテンツで主な会話を埋め尽くす場合（再度参照しない） |
+| [エージェントビュー](/docs/ja/agent-view) | `claude agents` で開く、バックグラウンドで実行されているセッションをディスパッチして監視する 1 つの画面。リサーチプレビュー | 複数の独立したタスクがあり、それらを引き継いで、一目で状態を確認し、必要な場合のみ介入したい場合 |
+| [エージェントチーム](/docs/ja/agent-teams) | 共有タスクリストとエージェント間メッセージングを備えた複数の調整されたセッション。リーダーによって管理される。実験的で、デフォルトでは無効 | Claude にプロジェクトを分割させ、割り当てさせ、ワーカーを同期させたい場合 |
+| [プロジェクト](/docs/ja/claude-projects) | claude.ai/code またはデスクトップアプリでの 1 つの継続的な会話。Claude は threads と呼ばれる並列セッションを開始し、クラウドで、またはリモートコントロール経由でコンピューターで実行し、各セッションにプロジェクトの指示を提供し、どのセッションがあなたを必要としているかを表示します。Pro および Max でのパブリックベータ | 作業が数日または数週間にわたる多くのタスクに及び、マシンがオフの場合でも実行を続け、各セッションをディスパッチして追跡するのではなく、一度説明したい場合 |
+| [動的ワークフロー](/docs/ja/workflows) | 多くのサブエージェントを実行し、その結果をチェックするスクリプト。1 回のターンで調整するには大きすぎるジョブ向け | タスクが大きすぎてサブエージェント数個では対応できない場合、または検出結果を相互に検証したい場合。コードベース全体の監査、500 ファイルのマイグレーション、相互検証が必要な調査、または複数の角度から作成されたプランなど |
 
 すべてのアプローチにおいて、ワーカーは Claude セッションです。別のツールを関与させるには、それを Claude に [MCP サーバー](/docs/ja/mcp) として公開します。
```

</details>

*...以降省略*

</details>


<details>
<summary>2026-09-28</summary>

**変更ファイル:**

```
 docs-ja/pages/claude-tag-ja.md | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
```

<details>
<summary>claude-tag-ja.md</summary>

```diff
diff --git a/docs-ja/pages/claude-tag-ja.md b/docs-ja/pages/claude-tag-ja.md
index e589491..5b50621 100644
--- a/docs-ja/pages/claude-tag-ja.md
+++ b/docs-ja/pages/claude-tag-ja.md
@@ -1 +1 @@
-<!DOCTYPE html><html lang="en-US"><head><title>Just a moment...</title><meta http-equiv="Content-Type" content="text/html; charset=UTF-8"><meta http-equiv="X-UA-Compatible" content="IE=Edge"><meta name="robots" content="noindex,nofollow"><meta name="viewport" content="width=device-width,initial-scale=1"><meta http-equiv="content-security-policy" content="default-src &#39;none&#39;; script-src &#39;nonce-tR6BKjYD9x0BybboKCb5Xc&#39; &#39;unsafe-eval&#39; https://challenges.cloudflare.com; script-src-attr &#39;none&#39;; style-src &#39;unsafe-inline&#39;; img-src &#39;self&#39; https://challenges.cloudflare.com; connect-src &#39;self&#39; https://challenges.cloudflare.com; frame-src &#39;self&#39; https://challenges.cloudflare.com blob:; child-src &#39;self&#39; https://challenges.cloudflare.com blob:; worker-src blob:; form-action http: https:; base-uri &#39;self&#39;"><style>*{box-sizing:border-box;margin:0;padding:0}html{line-height:1.15;-webkit-text-size-adjust:100%;color:#313131;font-family:system-ui,-apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,"Helvetica Neue",Arial,"Noto Sans",sans-serif,"Apple Color Emoji","Segoe UI Emoji","Segoe UI Symbol","Noto Color Emoji"}body{display:flex;flex-direction:column;height:100vh;min-height:100vh}.main-content{margin:8rem auto;padding-left:1.5rem;max-width:60rem}@media (width <= 720px){.main-content{margin-top:4rem}}#challenge-error-text{background-image:url("data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIzMiIgaGVpZ2h0PSIzMiIgZmlsbD0ibm9uZSI+PHBhdGggZmlsbD0iI0IyMEYwMyIgZD0iTTE2IDNhMTMgMTMgMCAxIDAgMTMgMTNBMTMuMDE1IDEzLjAxNSAwIDAgMCAxNiAzbTAgMjRhMTEgMTEgMCAxIDEgMTEtMTEgMTEuMDEgMTEuMDEgMCAwIDEtMTEgMTEiLz48cGF0aCBmaWxsPSIjQjIwRjAzIiBkPSJNMTcuMDM4IDE4LjYxNUgxNC44N0wxNC41NjMgOS41aDIuNzgzem0tMS4wODQgMS40MjdxLjY2IDAgMS4wNTcuMzg4LjQwNy4zODkuNDA3Ljk5NCAwIC41OTYtLjQwNy45ODQtLjM5Ny4zOS0xLjA1Ny4zODktLjY1IDAtMS4wNTYtLjM4OS0uMzk4LS4zODktLjM5OC0uOTg0IDAtLjU5Ny4zOTgtLjk4NS40MDYtLjM5NyAxLjA1Ni0uMzk3Ii8+PC9zdmc+");background-repeat:no-repeat;background-size:contain;padding-left:34px}</style><meta http-equiv="refresh" content="360"></head><body><div class="main-wrapper" role="main"><div class="main-content"><noscript><div class="h2"><span id="challenge-error-text">Enable JavaScript and cookies to continue</span></div></noscript></div></div><script nonce="tR6BKjYD9x0BybboKCb5Xc">(function(){window._cf_chl_opt = {cFPWv: 'b',cH: 'mqPZrUsGLExF1TJdnG0sBliDcG1lLjQeSpnaLZlzXwQ-1790475476-1.2.1.1-wWe_cRbqwVu7KmokQL.m1p0x6Lktm3WertPBdLamPAEYUMImI5Ow.wNUO641NMwh',cITimeS: '1790475476',cN: 'tR6BKjYD9x0BybboKCb5Xc',cRay: 'a41703cda8b515e5',cTplB: '0',cTplC:0,cTplO:0,cTplV:5,cType: 'managed',cUPMDTk:"/?redirect=claude.com\u0026__cf_chl_tk=4oEuvT07_RlrOvDZF8exwKJxl0rxBQrCqnxOdITZdyA-1790475476-1.0.1.1-sRmtNrRFtwnFx1gksgmmZb6rH0loVLlrMSWyhW7ceM0",cvId: '3',cZone: 'claude.ai',fa:"/?redirect=claude.com\u0026__cf_chl_f_tk=4oEuvT07_RlrOvDZF8exwKJxl0rxBQrCqnxOdITZdyA-1790475476-1.0.1.1-sRmtNrRFtwnFx1gksgmmZb6rH0loVLlrMSWyhW7ceM0",md: 'K2ohU4NEakNy8bIEDteIqqcPfsFCJhcnqTgt0EFSgOY-1790475476-1.2.1.1-yITIewvFlh470ABl.YmIb6sonz9btRSRzgQJ62T2VPx3v0KihkUOJaZ_cdWbwW5wG.zn8lmx3Bzv8sQBa4rmNcgoD1SxM6vCVHyKLUNdzsPPWFKkWNTaGqLdLNp3kubqw1CU0oPr1p3eGibwqioWaZ4YvW6BWYYeaKA79xNigu5HK3GytGFDdI1pNDvfp6rfxeyZS1gHMimQPnNtYdFNKaBeqgkchf_i_P4_jJL9Ek7KVlsF4B7t52E_wMcReRkkiSTplwBZQ8cMt77XQVEh1Vtti.rxoDQ9RyacDIb0NEVNGIYIdzNZe6YTF50BFzEZtIAof2pW0KbDVmyrmnVIHusMy.oKABlnBzlVsIEit5akpGZ1KPmnL10AsjXAgGSJBn.ZPsPdcO6H0DtdK8bYlKHIJZo17RZM14vYKe2Kmrb73XsMtgoMHKpLPmf2yEUL4X5B6KpY45i.PighPNb4ssNJjkP_UUAVbvN1VeK8Xa8WzIc5PG4FVg8TNhTvSPbk200eP4Pas1MmPxZs138OsV3dPYICUI027WxC1fPMSF0bw.cO_jpwbAHMjpXcp0uOtTWJX.fKYcdh6q2l64CwlEDwygc2Fcr1egGGb4lCluBHett2CqhHx971Q35WPHTzTI_tVFbiR8tX9xgwolf1UcwhVf9LxzY9vTKCA9lWNF7i6JzBQ1A0huvuGfJ.kqdzK57ckWdoyxWg0pyNpBmP7QcRcu1JxeP7LXwYRJuOqeGQerjO02OAHCpNCJ7m.8n4B36VFMVqyeJf1EkOGkAQ6p6GfgWNjPgBWtYraANwTw3pXJRJ549AGkTbD2_i7HA_Eq7A55gTTfNYzhRDpJg2U6HldSl9paLKc9z2g2C2q.0eoijvp2_s5IMOww1JzLs82VDx1LRniygCCUNzS7TKfERuf5Lm1X0luhrTTjjqyc54XmqPdm1_eD.KE7GzvZVFTwRudcY1urCQuPPy.JlgV2DddDkLVJGMcEfRZsRqRMnoXa9HvjMERLnPZMBHMroTy0Z.n_sj0LOW3.EK82LV4mlOkxYQWhYZ1pbhAFZCmek',mdrd: 'lxlB2uVCdnEXyr4Sp_E_dc5mcFWtqi7lBxVc0Fxm2xc-1790475476-1.2.1.1-Ds_hMMMtqLXVlr7jntlXILUMcqeFD3CYrSo3QUgiqrOI7zf8eDkIkyvIeBV0l6QysexMmbbSiIIAqnOi4kK8_0nMAUVKwmhEk4tI2xMRceV5UvaBCADW9Yhu6CfHOa0WxRfbPe71ctCto7Cw5W9mwGWj4_PVKvyfqhuklfiOGygK8zEfWJR3msCSZhIhSXaVvJrsTFv5gErw6xM_MflVkXZLLV5GCZlVaub10jNqz8q_HZ_roDa3AD1O5WxKO1JUNJYJ6G263kcda22kH46kJMRi1Cw57uLMdQZ237SbbPeUGCrUW6fjbAa0mweHwrQsrZIGauTY2cpe6DChxxmwhrfpFUqnsyo0fKsDb.kHApomy3grEKJIPHYBf2lLKNqYQYGRyHNKEc9E81kFtbnT1mT6LZR_PxeNSebbJHzzhLAP2dZBwULb3gjnkXq8whBF',};var a = document.createElement('script');a.nonce = 'tR6BKjYD9x0BybboKCb5Xc';a.src = '/cdn-cgi/challenge-platform/h/b/orchestrate/chl_page/v1?ray=a41703cda8b515e5';window._cf_chl_opt.cOgUHash = location.hash === '' && location.href.indexOf('#') !== -1 ? '#' : location.hash;window._cf_chl_opt.cOgUQuery = location.search === '' && location.href.slice(0, location.href.length - window._cf_chl_opt.cOgUHash.length).indexOf('?') !== -1 ? '?' : location.search;if (window.history && window.history.replaceState) {var ogU = location.pathname + window._cf_chl_opt.cOgUQuery + window._cf_chl_opt.cOgUHash;history.replaceState(null, null,"/?redirect=claude.com\u0026__cf_chl_rt_tk=4oEuvT07_RlrOvDZF8exwKJxl0rxBQrCqnxOdITZdyA-1790475476-1.0.1.1-sRmtNrRFtwnFx1gksgmmZb6rH0loVLlrMSWyhW7ceM0"+ window._cf_chl_opt.cOgUHash);a.onload = function() {history.replaceState(null, null, ogU);}}document.getElementsByTagName('head')[0].appendChild(a);}());</script></body></html>
\ No newline at end of file
+<!DOCTYPE html><html lang="en-US"><head><title>Just a moment...</title><meta http-equiv="Content-Type" content="text/html; charset=UTF-8"><meta http-equiv="X-UA-Compatible" content="IE=Edge"><meta name="robots" content="noindex,nofollow"><meta name="viewport" content="width=device-width,initial-scale=1"><meta http-equiv="content-security-policy" content="default-src &#39;none&#39;; script-src &#39;nonce-E2y3O62FTJNX2aSdP151lw&#39; &#39;unsafe-eval&#39; https://challenges.cloudflare.com; script-src-attr &#39;none&#39;; style-src &#39;unsafe-inline&#39;; img-src &#39;self&#39; https://challenges.cloudflare.com; connect-src &#39;self&#39; https://challenges.cloudflare.com; frame-src &#39;self&#39; https://challenges.cloudflare.com blob:; child-src &#39;self&#39; https://challenges.cloudflare.com blob:; worker-src blob:; form-action http: https:; base-uri &#39;self&#39;"><style>*{box-sizing:border-box;margin:0;padding:0}html{line-height:1.15;-webkit-text-size-adjust:100%;color:#313131;font-family:system-ui,-apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,"Helvetica Neue",Arial,"Noto Sans",sans-serif,"Apple Color Emoji","Segoe UI Emoji","Segoe UI Symbol","Noto Color Emoji"}body{display:flex;flex-direction:column;height:100vh;min-height:100vh}.main-content{margin:8rem auto;padding-left:1.5rem;max-width:60rem}@media (width <= 720px){.main-content{margin-top:4rem}}#challenge-error-text{background-image:url("data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIzMiIgaGVpZ2h0PSIzMiIgZmlsbD0ibm9uZSI+PHBhdGggZmlsbD0iI0IyMEYwMyIgZD0iTTE2IDNhMTMgMTMgMCAxIDAgMTMgMTNBMTMuMDE1IDEzLjAxNSAwIDAgMCAxNiAzbTAgMjRhMTEgMTEgMCAxIDEgMTEtMTEgMTEuMDEgMTEuMDEgMCAwIDEtMTEgMTEiLz48cGF0aCBmaWxsPSIjQjIwRjAzIiBkPSJNMTcuMDM4IDE4LjYxNUgxNC44N0wxNC41NjMgOS41aDIuNzgzem0tMS4wODQgMS40MjdxLjY2IDAgMS4wNTcuMzg4LjQwNy4zODkuNDA3Ljk5NCAwIC41OTYtLjQwNy45ODQtLjM5Ny4zOS0xLjA1Ny4zODktLjY1IDAtMS4wNTYtLjM4OS0uMzk4LS4zODktLjM5OC0uOTg0IDAtLjU5Ny4zOTgtLjk4NS40MDYtLjM5NyAxLjA1Ni0uMzk3Ii8+PC9zdmc+");background-repeat:no-repeat;background-size:contain;padding-left:34px}</style><meta http-equiv="refresh" content="360"></head><body><div class="main-wrapper" role="main"><div class="main-content"><noscript><div class="h2"><span id="challenge-error-text">Enable JavaScript and cookies to continue</span></div></noscript></div></div><script nonce="E2y3O62FTJNX2aSdP151lw">(function(){window._cf_chl_opt = {cFPWv: 'b',cH: 'U6z6m.MJ37NJPqIqUWLYU.t9Y9g3jHfauZ8DQ7E4pfU-1790562110-1.2.1.1-KNsHmE.iSwJIDMIm642CTHnWCdeXGqLwpxxVVyQcioIkcbYRhZFq8_bvxN4dI1WO',cITimeS: '1790562110',cN: 'E2y3O62FTJNX2aSdP151lw',cRay: 'a41f46e51fa86b84',cTplB: '0',cTplC:0,cTplO:0,cTplV:5,cType: 'managed',cUPMDTk:"/?redirect=claude.com\u0026__cf_chl_tk=W1gZLLoUQrMQSAGLo2r2m7K58F5mIMzEUr9kTF_W_9U-1790562110-1.0.1.1-w6tKWQXZNth.8fGKleFejNVCHet.ghb16nOKO0mSfGA",cvId: '3',cZone: 'claude.ai',fa:"/?redirect=claude.com\u0026__cf_chl_f_tk=W1gZLLoUQrMQSAGLo2r2m7K58F5mIMzEUr9kTF_W_9U-1790562110-1.0.1.1-w6tKWQXZNth.8fGKleFejNVCHet.ghb16nOKO0mSfGA",md: '5TISfKR0eAn7qSL41KTrlCDXbcsQ4PHBwAayE1iygzA-1790562110-1.2.1.1-1cin6EqaRRChja3CCwFR3TDqrHQ2U8H022uQBMjduDfapqIQ8Ft0iDOETILmgq34LgP9m6Jgku6lrQboyfbdoo0HZHmntufaoG0_t3G35PKVeILueEu1V1pFKSNBscB5.p130gnR77DAS1phHlUl5WEgChP2wEuAiSEa0iMovCS5XeNfRwBhrJQYmXeHowVT2qprZBDka9P7cg15RxC3pzJmVLn2rlHtJc3PGkeY3jiIJ981jp1Bvy7hr1D84arUWzkWz0VifwkATl5XMYMa9xzpoKtwojfKUe8IuWsTgUipYhc57.A9JvItL7qlWrBF085BzqMPWWePH5Xah71HZtSV_UBDMs1O6mVxFhjEqyX8cwPWA_f9v23Gt58H9kfkBilqxCrc3S9qOfXKgHdNVIjG7QTstO.IsBFUTdVnzWEGu30a7OAr1xLkvgvBEyMS85hQ65PLBMP5ioE3DZ0O7.8.oHBy76oOjhx4o88POdDLVaIz2.Kbj3FmWns_tVgBLxW0nrs4g6xqWgbTWaHap3objmB9epEziuFxT.UqcFUNLady.V7cMAWp_FQ5oUWaxbKAYd4Y6DkC9xZplTyBzhY0rV5f0lRwxfevvlZ6fbolTH_kEswDqyPVcGZqRjxw.5MAvMqLDyl3mN9JkbmlQC7bWW36IU93HSs9CR4OuDwk_X.hGXXKvSk0edJX7be0W.eekAAoeqvAdhLHN0Jk6FxWTvGhcm.OurxEe0h3HfSSG_wY6EG9rUdh1m5JaSB4.7TcQQ3s0dqDDn2E8WJ6WR7123aAZkWb7Fno2Z.RcYmQ7FcAZg7NSUbKYLcE917gPTEaY_b_dJ9Y_s9hZo9xTnIstlBy6P47TvdtRmI3krTKrKY.m6SZ5KeBrGv8khyhWsVI5DtYAzxQDXeh2ISRSxvmnp7avWuH7C_Dqrk68ZFctuMWv6eRz6kUnuJn.WqE2cxBLRCpVhJZc.CLnnhAdPDx3_k.KgGoQ4iVOjqOZoU1umP0XxbqRgh3.KR6VM_.xIvJH82bHki2aZtBRE26C37Mr6pbbeGm6h42_YpXwQ25kzvkKg0ZfnAQSxKGKkp4',mdrd: 'DygGteHz2PZkHMqJzx63UK9OoqXImsOfNU2te94_USo-1790562110-1.2.1.1-vBPezzBtqhFa97BBDxdMdCn26_QFa80F1IDSNCObhMZkd9B2z6wgpcNnQ_skhgRaI10LG5_tILVdyJPcgphqPK9Aym4z7fFN49ogKYuFjhpGUTkl_juN69pF.5emxUgbGq37potgUscECmMKvzB3430yBDaQ_65f2tOoWZ8vJWXdK.cNYOb4nKdWupWggLxXqOpPR_LUmK.BfDzsxsCgZqo0WcHk5gDQ3rvhvJLy1R4_S7aWtxSwhaxj6vugQR1JC9bbXuynEyJvUGQnZyEZhqdgK7UiGHjMuNyueuG2CK9yDkMh5zRrDw5_rl72TOMgaXhUrvn6OTQF6f6lVQtA9HCJ2d_4DGEkftF3Bq_9tS2ghirD17SaYceQ7bnLAfhQffcVeBdkav2ruU4XSVMrQIcbmE2i8FYB_b6rWiqLZqqftZaDViRp1BDI8RoDohVG',};var a = document.createElement('script');a.nonce = 'E2y3O62FTJNX2aSdP151lw';a.src = '/cdn-cgi/challenge-platform/h/b/orchestrate/chl_page/v1?ray=a41f46e51fa86b84';window._cf_chl_opt.cOgUHash = location.hash === '' && location.href.indexOf('#') !== -1 ? '#' : location.hash;window._cf_chl_opt.cOgUQuery = location.search === '' && location.href.slice(0, location.href.length - window._cf_chl_opt.cOgUHash.length).indexOf('?') !== -1 ? '?' : location.search;if (window.history && window.history.replaceState) {var ogU = location.pathname + window._cf_chl_opt.cOgUQuery + window._cf_chl_opt.cOgUHash;history.replaceState(null, null,"/?redirect=claude.com\u0026__cf_chl_rt_tk=W1gZLLoUQrMQSAGLo2r2m7K58F5mIMzEUr9kTF_W_9U-1790562110-1.0.1.1-w6tKWQXZNth.8fGKleFejNVCHet.ghb16nOKO0mSfGA"+ window._cf_chl_opt.cOgUHash);a.onload = function() {history.replaceState(null, null, ogU);}}document.getElementsByTagName('head')[0].appendChild(a);}());</script></body></html>
\ No newline at end of file
```

</details>

</details>


<details>
<summary>2026-09-27</summary>

**変更ファイル:**

```
 docs-ja/pages/claude-tag-ja.md | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
```

<details>
<summary>claude-tag-ja.md</summary>

```diff
diff --git a/docs-ja/pages/claude-tag-ja.md b/docs-ja/pages/claude-tag-ja.md
index f3b7b2e..e589491 100644
--- a/docs-ja/pages/claude-tag-ja.md
+++ b/docs-ja/pages/claude-tag-ja.md
@@ -1 +1 @@
-<!DOCTYPE html><html lang="en-US"><head><title>Just a moment...</title><meta http-equiv="Content-Type" content="text/html; charset=UTF-8"><meta http-equiv="X-UA-Compatible" content="IE=Edge"><meta name="robots" content="noindex,nofollow"><meta name="viewport" content="width=device-width,initial-scale=1"><meta http-equiv="content-security-policy" content="default-src &#39;none&#39;; script-src &#39;nonce-38bE91Pcji4a3djuAeGw8J&#39; &#39;unsafe-eval&#39; https://challenges.cloudflare.com; script-src-attr &#39;none&#39;; style-src &#39;unsafe-inline&#39;; img-src &#39;self&#39; https://challenges.cloudflare.com; connect-src &#39;self&#39; https://challenges.cloudflare.com; frame-src &#39;self&#39; https://challenges.cloudflare.com blob:; child-src &#39;self&#39; https://challenges.cloudflare.com blob:; worker-src blob:; form-action http: https:; base-uri &#39;self&#39;"><style>*{box-sizing:border-box;margin:0;padding:0}html{line-height:1.15;-webkit-text-size-adjust:100%;color:#313131;font-family:system-ui,-apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,"Helvetica Neue",Arial,"Noto Sans",sans-serif,"Apple Color Emoji","Segoe UI Emoji","Segoe UI Symbol","Noto Color Emoji"}body{display:flex;flex-direction:column;height:100vh;min-height:100vh}.main-content{margin:8rem auto;padding-left:1.5rem;max-width:60rem}@media (width <= 720px){.main-content{margin-top:4rem}}#challenge-error-text{background-image:url("data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIzMiIgaGVpZ2h0PSIzMiIgZmlsbD0ibm9uZSI+PHBhdGggZmlsbD0iI0IyMEYwMyIgZD0iTTE2IDNhMTMgMTMgMCAxIDAgMTMgMTNBMTMuMDE1IDEzLjAxNSAwIDAgMCAxNiAzbTAgMjRhMTEgMTEgMCAxIDEgMTEtMTEgMTEuMDEgMTEuMDEgMCAwIDEtMTEgMTEiLz48cGF0aCBmaWxsPSIjQjIwRjAzIiBkPSJNMTcuMDM4IDE4LjYxNUgxNC44N0wxNC41NjMgOS41aDIuNzgzem0tMS4wODQgMS40MjdxLjY2IDAgMS4wNTcuMzg4LjQwNy4zODkuNDA3Ljk5NCAwIC41OTYtLjQwNy45ODQtLjM5Ny4zOS0xLjA1Ny4zODktLjY1IDAtMS4wNTYtLjM4OS0uMzk4LS4zODktLjM5OC0uOTg0IDAtLjU5Ny4zOTgtLjk4NS40MDYtLjM5NyAxLjA1Ni0uMzk3Ii8+PC9zdmc+");background-repeat:no-repeat;background-size:contain;padding-left:34px}</style><meta http-equiv="refresh" content="360"></head><body><div class="main-wrapper" role="main"><div class="main-content"><noscript><div class="h2"><span id="challenge-error-text">Enable JavaScript and cookies to continue</span></div></noscript></div></div><script nonce="38bE91Pcji4a3djuAeGw8J">(function(){window._cf_chl_opt = {cFPWv: 'b',cH: 'oTtPYH3mNwM2UxvaNLdxsBpxW7dpBK19G3J7Tdj7Scc-1790389329-1.2.1.1-R2.rdMet2iYOB71KMACq8C.tuF_VSUJQ27vKiLI99xNwQC2gEOdVyvNPi0UIE_78',cITimeS: '1790389329',cN: '38bE91Pcji4a3djuAeGw8J',cRay: 'a40ecc9adae9ba7a',cTplB: '0',cTplC:0,cTplO:0,cTplV:5,cType: 'managed',cUPMDTk:"/?redirect=claude.com\u0026__cf_chl_tk=Gf9qmsJR_9DseyOWj4Lg_7foTABQaNYGMoq0qlQMypM-1790389329-1.0.1.1-9v5i7SgD11u5ba5ak92kYw55bZa6n6VMXOCO5oPPvRc",cvId: '3',cZone: 'claude.ai',fa:"/?redirect=claude.com\u0026__cf_chl_f_tk=Gf9qmsJR_9DseyOWj4Lg_7foTABQaNYGMoq0qlQMypM-1790389329-1.0.1.1-9v5i7SgD11u5ba5ak92kYw55bZa6n6VMXOCO5oPPvRc",md: 'qJhmzfAM6kQyi28LYr5SEixsP0baxid1plnIiAIIL1k-1790389329-1.2.1.1-cQ0ggEaSVHxMJr8qwcrCuPaFzZgyx9XtdEDR4CxUN2cwEjQNacLd6NIBI_3MmOvZCF5GtkHlo5jDH5j13Pc6KSTNzBHleST2tIVGitNbRFyDtcDjse5H1FK5J3MB2qLKTKKh2DRqwgSztsF49I_PyMHE6NUe1iHT7BW1ZgCfFb4n2gkKwvey4C5C_qamN_RGtkRR50a2dqa4IM6CKu9coSreegiDw7Ua1wIn8WZBuhXyrzYBqoF2c1atWklgz_TFw_Is9cYgcVtwxkZQNFs1js4GhBAI2nSHNUCinWlvUeE6v5vfRk.APxc2XKTNvdk_k.PMbQy1.8PoCnz7tHDaCTSQ2xW2oBW_TPfuCd6pK1eW2nAWXXFqFqXSX37ppF6LyxSFvDkePRLjeHvzrH.qKX_OTE5TL_ZS1CzRMDtP.RigsmvLxjiQQgp37xd9StCJFKR0anDDxdxhuOnzCWnf8.Ky.eDiXlpoxm_Q7.PxN.h_Qz_gyeBgTlP8dPwhtYiGFbeaFWVEcyYXPv7X8tdkqR9s46K5tKjRHXZ78e9EBya3i1AN5m.UVz96hOS7o1bXOOBwqGZVz_xhdLFguWZurVRff0AaXgZgiiLSDbpIh9ONxfG2M6vArSWEsafmMNV0BTXjCidYq7.lGSEjbPPRe8tEN9PKq1PC2HJOlqm8cbQClD_y1IverFRwqasrpjx9ywNAc_Rm3.Qd3EjzpWsS3U4mX4rga0p1iUDmgmWt7BC.6U6WCKYGkfD6F_ETp_zletrS5rnVnDOsWJlUB7Xn_5tg1ie_pK6UB3Ho8_bjoc6Ag8oGc2Gy5_RHPfwyNNZaHzbsm_jOYPmCuSMzkOaNUgjgMH846Z6N_97NbU1t2VykgdYMUGA83Tuja1ivxaVNco62qprxWEozLMZ93KpvAeHrzb0X0bfzba0rtcE.d1XjAXnFoVmO_5GzbSQnoxFXGu5cq70XBAblKLjRyL0UY9DkUOg6IvveRN3vS.z2Qc5ooMIDjEQAInvLQqwli1KP3pjzN1C3sri1s8uGbyqMTpmWb0XokGTtgx0kvXHWtns',mdrd: 'vgMvrTIItakA5phRP4D9NBI5GohDWMJQGwq3AKHdYwY-1790389329-1.2.1.1-Uu_LycAgkBWZm_D8XBtTwy0nxR12SC1OCNUPomONVZIgnBR_OSzKjq1lLjH2QRae5DwVYrzNTxEvTgydBdtpmFblyeVx1ne.IwBP_rO_8MArU5iuGgwEh2JUzORFHD.XP4S9W5vciPaFJqnt9eVX6YnE1qo98ok8xaQUq_OMt_jo7sErv8ch.Vi6Sn20vgJCccJn0AG5ef26c3Aqphkh4tEzzFLAUpjplGppwTcq0nLeNcV9_OqQP7M01yrLlRMRtvvCprSxm4s2.7al8qqcJGVkyCakkRqn0j55GrIOrTjw5Wq6eTJhLEAUNp.rM.9YzPQKTtdEYeN2uLyTGQALj8fqswJFYdgZAnyzpEglwQjIQiIC.w_JSRH_QYOHnut20lwLSkP31BJMITVqLBX9bsgbj6JYLwt_yTZgJFV9XZXmpWJckq0nZy_TJZGYOOq1',};var a = document.createElement('script');a.nonce = '38bE91Pcji4a3djuAeGw8J';a.src = '/cdn-cgi/challenge-platform/h/b/orchestrate/chl_page/v1?ray=a40ecc9adae9ba7a';window._cf_chl_opt.cOgUHash = location.hash === '' && location.href.indexOf('#') !== -1 ? '#' : location.hash;window._cf_chl_opt.cOgUQuery = location.search === '' && location.href.slice(0, location.href.length - window._cf_chl_opt.cOgUHash.length).indexOf('?') !== -1 ? '?' : location.search;if (window.history && window.history.replaceState) {var ogU = location.pathname + window._cf_chl_opt.cOgUQuery + window._cf_chl_opt.cOgUHash;history.replaceState(null, null,"/?redirect=claude.com\u0026__cf_chl_rt_tk=Gf9qmsJR_9DseyOWj4Lg_7foTABQaNYGMoq0qlQMypM-1790389329-1.0.1.1-9v5i7SgD11u5ba5ak92kYw55bZa6n6VMXOCO5oPPvRc"+ window._cf_chl_opt.cOgUHash);a.onload = function() {history.replaceState(null, null, ogU);}}document.getElementsByTagName('head')[0].appendChild(a);}());</script></body></html>
\ No newline at end of file
+<!DOCTYPE html><html lang="en-US"><head><title>Just a moment...</title><meta http-equiv="Content-Type" content="text/html; charset=UTF-8"><meta http-equiv="X-UA-Compatible" content="IE=Edge"><meta name="robots" content="noindex,nofollow"><meta name="viewport" content="width=device-width,initial-scale=1"><meta http-equiv="content-security-policy" content="default-src &#39;none&#39;; script-src &#39;nonce-tR6BKjYD9x0BybboKCb5Xc&#39; &#39;unsafe-eval&#39; https://challenges.cloudflare.com; script-src-attr &#39;none&#39;; style-src &#39;unsafe-inline&#39;; img-src &#39;self&#39; https://challenges.cloudflare.com; connect-src &#39;self&#39; https://challenges.cloudflare.com; frame-src &#39;self&#39; https://challenges.cloudflare.com blob:; child-src &#39;self&#39; https://challenges.cloudflare.com blob:; worker-src blob:; form-action http: https:; base-uri &#39;self&#39;"><style>*{box-sizing:border-box;margin:0;padding:0}html{line-height:1.15;-webkit-text-size-adjust:100%;color:#313131;font-family:system-ui,-apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,"Helvetica Neue",Arial,"Noto Sans",sans-serif,"Apple Color Emoji","Segoe UI Emoji","Segoe UI Symbol","Noto Color Emoji"}body{display:flex;flex-direction:column;height:100vh;min-height:100vh}.main-content{margin:8rem auto;padding-left:1.5rem;max-width:60rem}@media (width <= 720px){.main-content{margin-top:4rem}}#challenge-error-text{background-image:url("data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIzMiIgaGVpZ2h0PSIzMiIgZmlsbD0ibm9uZSI+PHBhdGggZmlsbD0iI0IyMEYwMyIgZD0iTTE2IDNhMTMgMTMgMCAxIDAgMTMgMTNBMTMuMDE1IDEzLjAxNSAwIDAgMCAxNiAzbTAgMjRhMTEgMTEgMCAxIDEgMTEtMTEgMTEuMDEgMTEuMDEgMCAwIDEtMTEgMTEiLz48cGF0aCBmaWxsPSIjQjIwRjAzIiBkPSJNMTcuMDM4IDE4LjYxNUgxNC44N0wxNC41NjMgOS41aDIuNzgzem0tMS4wODQgMS40MjdxLjY2IDAgMS4wNTcuMzg4LjQwNy4zODkuNDA3Ljk5NCAwIC41OTYtLjQwNy45ODQtLjM5Ny4zOS0xLjA1Ny4zODktLjY1IDAtMS4wNTYtLjM4OS0uMzk4LS4zODktLjM5OC0uOTg0IDAtLjU5Ny4zOTgtLjk4NS40MDYtLjM5NyAxLjA1Ni0uMzk3Ii8+PC9zdmc+");background-repeat:no-repeat;background-size:contain;padding-left:34px}</style><meta http-equiv="refresh" content="360"></head><body><div class="main-wrapper" role="main"><div class="main-content"><noscript><div class="h2"><span id="challenge-error-text">Enable JavaScript and cookies to continue</span></div></noscript></div></div><script nonce="tR6BKjYD9x0BybboKCb5Xc">(function(){window._cf_chl_opt = {cFPWv: 'b',cH: 'mqPZrUsGLExF1TJdnG0sBliDcG1lLjQeSpnaLZlzXwQ-1790475476-1.2.1.1-wWe_cRbqwVu7KmokQL.m1p0x6Lktm3WertPBdLamPAEYUMImI5Ow.wNUO641NMwh',cITimeS: '1790475476',cN: 'tR6BKjYD9x0BybboKCb5Xc',cRay: 'a41703cda8b515e5',cTplB: '0',cTplC:0,cTplO:0,cTplV:5,cType: 'managed',cUPMDTk:"/?redirect=claude.com\u0026__cf_chl_tk=4oEuvT07_RlrOvDZF8exwKJxl0rxBQrCqnxOdITZdyA-1790475476-1.0.1.1-sRmtNrRFtwnFx1gksgmmZb6rH0loVLlrMSWyhW7ceM0",cvId: '3',cZone: 'claude.ai',fa:"/?redirect=claude.com\u0026__cf_chl_f_tk=4oEuvT07_RlrOvDZF8exwKJxl0rxBQrCqnxOdITZdyA-1790475476-1.0.1.1-sRmtNrRFtwnFx1gksgmmZb6rH0loVLlrMSWyhW7ceM0",md: 'K2ohU4NEakNy8bIEDteIqqcPfsFCJhcnqTgt0EFSgOY-1790475476-1.2.1.1-yITIewvFlh470ABl.YmIb6sonz9btRSRzgQJ62T2VPx3v0KihkUOJaZ_cdWbwW5wG.zn8lmx3Bzv8sQBa4rmNcgoD1SxM6vCVHyKLUNdzsPPWFKkWNTaGqLdLNp3kubqw1CU0oPr1p3eGibwqioWaZ4YvW6BWYYeaKA79xNigu5HK3GytGFDdI1pNDvfp6rfxeyZS1gHMimQPnNtYdFNKaBeqgkchf_i_P4_jJL9Ek7KVlsF4B7t52E_wMcReRkkiSTplwBZQ8cMt77XQVEh1Vtti.rxoDQ9RyacDIb0NEVNGIYIdzNZe6YTF50BFzEZtIAof2pW0KbDVmyrmnVIHusMy.oKABlnBzlVsIEit5akpGZ1KPmnL10AsjXAgGSJBn.ZPsPdcO6H0DtdK8bYlKHIJZo17RZM14vYKe2Kmrb73XsMtgoMHKpLPmf2yEUL4X5B6KpY45i.PighPNb4ssNJjkP_UUAVbvN1VeK8Xa8WzIc5PG4FVg8TNhTvSPbk200eP4Pas1MmPxZs138OsV3dPYICUI027WxC1fPMSF0bw.cO_jpwbAHMjpXcp0uOtTWJX.fKYcdh6q2l64CwlEDwygc2Fcr1egGGb4lCluBHett2CqhHx971Q35WPHTzTI_tVFbiR8tX9xgwolf1UcwhVf9LxzY9vTKCA9lWNF7i6JzBQ1A0huvuGfJ.kqdzK57ckWdoyxWg0pyNpBmP7QcRcu1JxeP7LXwYRJuOqeGQerjO02OAHCpNCJ7m.8n4B36VFMVqyeJf1EkOGkAQ6p6GfgWNjPgBWtYraANwTw3pXJRJ549AGkTbD2_i7HA_Eq7A55gTTfNYzhRDpJg2U6HldSl9paLKc9z2g2C2q.0eoijvp2_s5IMOww1JzLs82VDx1LRniygCCUNzS7TKfERuf5Lm1X0luhrTTjjqyc54XmqPdm1_eD.KE7GzvZVFTwRudcY1urCQuPPy.JlgV2DddDkLVJGMcEfRZsRqRMnoXa9HvjMERLnPZMBHMroTy0Z.n_sj0LOW3.EK82LV4mlOkxYQWhYZ1pbhAFZCmek',mdrd: 'lxlB2uVCdnEXyr4Sp_E_dc5mcFWtqi7lBxVc0Fxm2xc-1790475476-1.2.1.1-Ds_hMMMtqLXVlr7jntlXILUMcqeFD3CYrSo3QUgiqrOI7zf8eDkIkyvIeBV0l6QysexMmbbSiIIAqnOi4kK8_0nMAUVKwmhEk4tI2xMRceV5UvaBCADW9Yhu6CfHOa0WxRfbPe71ctCto7Cw5W9mwGWj4_PVKvyfqhuklfiOGygK8zEfWJR3msCSZhIhSXaVvJrsTFv5gErw6xM_MflVkXZLLV5GCZlVaub10jNqz8q_HZ_roDa3AD1O5WxKO1JUNJYJ6G263kcda22kH46kJMRi1Cw57uLMdQZ237SbbPeUGCrUW6fjbAa0mweHwrQsrZIGauTY2cpe6DChxxmwhrfpFUqnsyo0fKsDb.kHApomy3grEKJIPHYBf2lLKNqYQYGRyHNKEc9E81kFtbnT1mT6LZR_PxeNSebbJHzzhLAP2dZBwULb3gjnkXq8whBF',};var a = document.createElement('script');a.nonce = 'tR6BKjYD9x0BybboKCb5Xc';a.src = '/cdn-cgi/challenge-platform/h/b/orchestrate/chl_page/v1?ray=a41703cda8b515e5';window._cf_chl_opt.cOgUHash = location.hash === '' && location.href.indexOf('#') !== -1 ? '#' : location.hash;window._cf_chl_opt.cOgUQuery = location.search === '' && location.href.slice(0, location.href.length - window._cf_chl_opt.cOgUHash.length).indexOf('?') !== -1 ? '?' : location.search;if (window.history && window.history.replaceState) {var ogU = location.pathname + window._cf_chl_opt.cOgUQuery + window._cf_chl_opt.cOgUHash;history.replaceState(null, null,"/?redirect=claude.com\u0026__cf_chl_rt_tk=4oEuvT07_RlrOvDZF8exwKJxl0rxBQrCqnxOdITZdyA-1790475476-1.0.1.1-sRmtNrRFtwnFx1gksgmmZb6rH0loVLlrMSWyhW7ceM0"+ window._cf_chl_opt.cOgUHash);a.onload = function() {history.replaceState(null, null, ogU);}}document.getElementsByTagName('head')[0].appendChild(a);}());</script></body></html>
\ No newline at end of file
```

</details>

</details>


<details>
<summary>2026-09-26</summary>

**変更ファイル:**

```
 docs-ja/pages/admin-setup-ja.md                |  40 ++--
 docs-ja/pages/agent-teams-ja.md                |   2 +-
 docs-ja/pages/agents-ja.md                     |   2 +-
 docs-ja/pages/amazon-bedrock-ja.md             |   9 +-
 docs-ja/pages/best-practices-ja.md             |  14 +-
 docs-ja/pages/changelog.md                     | 100 ++++++++-
 docs-ja/pages/channels-ja.md                   |  26 +--
 docs-ja/pages/channels-reference-ja.md         |   8 +-
 docs-ja/pages/checkpointing-ja.md              |   2 +-
 docs-ja/pages/claude-apps-gateway-deploy-ja.md |   2 +-
 docs-ja/pages/claude-code-on-the-web-ja.md     |  14 +-
 docs-ja/pages/claude-directory-ja.md           |  52 ++---
 docs-ja/pages/claude-platform-on-aws-ja.md     |   2 +-
 docs-ja/pages/claude-projects-ja.md            | 208 +++++++++---------
 docs-ja/pages/claude-security-ja.md            |  20 +-
 docs-ja/pages/claude-tag-ja.md                 |  12 +-
 docs-ja/pages/cli-reference-ja.md              |  12 +-
 docs-ja/pages/cloud-environments-ja.md         |   4 +-
 docs-ja/pages/commands-ja.md                   |  14 +-
 docs-ja/pages/common-workflows-ja.md           |   2 +-
 docs-ja/pages/costs-ja.md                      |   2 +-
 docs-ja/pages/debug-your-config-ja.md          |   2 +-
 docs-ja/pages/desktop-ja.md                    |  12 +-
 docs-ja/pages/env-vars-ja.md                   |   2 +-
 docs-ja/pages/errors-ja.md                     |  46 ++--
 docs-ja/pages/feature-availability-ja.md       |   2 +-
 docs-ja/pages/features-overview-ja.md          |  34 +--
 docs-ja/pages/fullscreen-ja.md                 |   3 +-
 docs-ja/pages/github-actions-ja.md             |   4 +-
 docs-ja/pages/github-enterprise-server-ja.md   |  26 +--
 docs-ja/pages/glossary-ja.md                   |   6 +-
 docs-ja/pages/headless-ja.md                   |   2 +-
 docs-ja/pages/hooks-guide-ja.md                |  22 +-
 docs-ja/pages/how-claude-code-works-ja.md      |  14 +-
 docs-ja/pages/interactive-mode-ja.md           |  15 +-
 docs-ja/pages/keybindings-ja.md                |  52 +++--
 docs-ja/pages/large-codebases-ja.md            |  10 +-
 docs-ja/pages/managed-mcp-ja.md                |   2 +-
 docs-ja/pages/managed-settings-ja.md           | 228 ++++++++++----------
 docs-ja/pages/mcp-ja.md                        |  34 +--
 docs-ja/pages/monitoring-usage-ja.md           |  12 +-
 docs-ja/pages/network-config-ja.md             |   2 +-
 docs-ja/pages/output-styles-ja.md              |   4 +-
 docs-ja/pages/permission-modes-ja.md           |  17 +-
 docs-ja/pages/permissions-ja.md                |  22 +-
 docs-ja/pages/platforms-ja.md                  |  18 +-
 docs-ja/pages/plugin-evals-ja.md               |  91 +++++---
 docs-ja/pages/prompt-caching-ja.md             |  16 +-
 docs-ja/pages/prompt-library-ja.md             |   7 +-
 docs-ja/pages/remote-control-ja.md             |  12 +-
 docs-ja/pages/sandboxing-ja.md                 | 283 +++++++++++++------------
 docs-ja/pages/security-guidance-ja.md          |  10 +-
 docs-ja/pages/server-managed-settings-ja.md    |   4 +-
 docs-ja/pages/sessions-ja.md                   |   2 +-
 docs-ja/pages/settings-example-ja.md           |  16 +-
 docs-ja/pages/settings-ja.md                   | 128 +++++------
 docs-ja/pages/settings-reference-ja.md         | 126 ++++++-----
 docs-ja/pages/skills-ja.md                     |  44 ++--
 docs-ja/pages/statusline-ja.md                 |   2 +-
 docs-ja/pages/sub-agents-ja.md                 |  40 ++--
 docs-ja/pages/terminal-config-ja.md            |   2 +-
 docs-ja/pages/tools-reference-ja.md            |  14 +-
 docs-ja/pages/vs-code-ja.md                    |   4 +-
 docs-ja/pages/workflows-ja.md                  |   2 +-
 docs-ja/pages/zero-data-retention-ja.md        |   2 +-
 65 files changed, 1073 insertions(+), 870 deletions(-)
```

<details>
<summary>admin-setup-ja.md</summary>

```diff
diff --git a/docs-ja/pages/admin-setup-ja.md b/docs-ja/pages/admin-setup-ja.md
index 86f1c19..8b44218 100644
--- a/docs-ja/pages/admin-setup-ja.md
+++ b/docs-ja/pages/admin-setup-ja.md
@@ -94,24 +94,24 @@ WSL 2 ユーティリティ VM 内のプロセスは、Windows 側のエンド
 マネージド設定は、ツール、サンドボックス実行、MCP サーバーとプラグインソース、および実行するフック を制限できます。各行は、それを駆動する設定キーを持つ制御サーフェスです。
 
-| 制御                                                                           | 機能                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           | キー設定                                                                                                                                |
-| :--------------------------------------------------------------------------- | :----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :---------------------------------------------------------------------------------------------------------------------------------- |
-| [権限ルール](/docs/ja/permissions)                                                     | 特定のツールとコマンドを許可、確認、または拒否する                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | `permissions.allow`、`permissions.deny`                                                                                              |
-| [権限ロックダウン](/docs/ja/permissions#managed-only-settings)                            | マネージド設定を[権限ルールの唯一の設定ソース](/docs/ja/settings-reference#allowmanagedpermissionrulesonly)にします。`--dangerously-skip-permissions` を無効にする                                                                                                                                                                                                                                                                                                                                                                                 | `allowManagedPermissionRulesOnly`、`permissions.disableBypassPermissionsMode`                                                        |
-| [開始権限モード](/docs/ja/permission-modes#which-mode-a-session-starts-in)               | 組み込みの開始権限モードの代わりに、開発者のターミナルセッションが開始する権限モードを選択するか、自動モードを削除します。VS Code 拡張機能は、Pro、Max、Team プランでのみ設定した `defaultMode` を読み取ります。[権限モードの切り替え](/docs/ja/permission-modes#switch-permission-modes)は、拡張機能が読み取る内容を一覧表示します                                                                                                                                                                                                                                                                                                     | `permissions.defaultMode`、`permissions.disableAutoMode`                                                                             |
-| [サンドボックス](/docs/ja/sandboxing)                                                    | ドメイン許可リスト付きの OS レベルのファイルシステムとネットワーク分離                                                                                                                                                                                                                                                                                                                                                                                                                                                                        | `sandbox.enabled`、`sandbox.network.allowedDomains`                                                                                  |
-| [マネージドポリシー CLAUDE.md](/docs/ja/memory#deploy-organization-wide-claude-md)         | すべてのセッションで読み込まれる組織全体の指示。除外できません                                                                                                                                                                                                                                                                                                                                                                                                                                                                              | マネージドポリシーパスのファイル                                                                                                                    |
-| [MCP サーバー制御](/docs/ja/managed-mcp)                                                | ユーザーが追加または接続できる MCP サーバーを制限し、固定セットをデプロイするか、リモートサーバーをすべてのユーザーに提供します                                                                                                                                                                                                                                                                                                                                                                                                                                           | `allowedMcpServers`、`deniedMcpServers`、`allowManagedMcpServersOnly`、`managedMcpServers`、またはデプロイされた `managed-mcp.json` ファイル          |
-| [プラグインマーケットプレイス制御](/docs/ja/plugin-marketplaces#managed-marketplace-restrictions) | ユーザーが追加およびインストールできるマーケットプレイスソースを制限し、単一実行のためにプラグイン、エージェント、MCP サーバーをサイドロードする CLI フラグを拒否し、[`command` プラグインソース](/docs/ja/plugin-marketplaces#command-sources)をブロックし、どのマーケットプレイスのプラグインを提案できるかをホワイトリストに登録します                                                                                                                                                                                                                                                                                                            | `strictKnownMarketplaces`、`blockedMarketplaces`、`disableSideloadFlags`、`disableCommandPluginSources`、`pluginSuggestionMarketplaces` |
-| [カスタマイズロックダウン](/docs/ja/settings-reference#strictpluginonlycustomization)         | スキル、エージェント、フック、MCP サーバーをユーザーおよびプロジェクトソースからブロックし、プラグインまたはマネージド設定からのみ取得できるようにします。スキルをロックすると、開発者が claude.ai で有効にした[スキル](/docs/ja/skills#where-synced-skills-load)の同期も停止します                                                                                                                                                                                                                                                                                                                                           | `strictPluginOnlyCustomization`                                                                                                     |
-| [claude.ai 同期を無効にする](/docs/ja/settings-reference#syncclaudeaiskills)              | Claude Code が開発者が claude.ai で有効にした[スキル](/docs/ja/skills#how-synced-skills-behave)と[プラグイン](/docs/ja/plugins-reference#synced-plugins)を読み込むのを停止します。組織の claude.ai でスキルをオフにすると、Claude Code は両方の同期を停止します。v2.1.273 以降では、既に同期したものも削除します。スキルをオフにせずにどちらか一方を停止するには、マネージド設定でそのキーを `false` に設定します                                                                                                                                                                                                                                  | `syncClaudeAiSkills`、`syncClaudeAiPlugins`                                                                                          |
-| [フック制限](/docs/ja/settings-reference#allowmanagedhooksonly)                        | 実行するフックを制限し、HTTP フック URL を制限します。[`allowManagedHooksOnly` で実行される内容](/docs/ja/settings-reference#what-runs-under-allowmanagedhooksonly)の完全な効果リストを参照してください                                                                                                                                                                                                                                                                                                                                                           | `allowManagedHooksOnly`、`allowedHttpHookUrls`                                                                                       |
-| [ログイン強制](/docs/ja/settings-reference#forceloginmethod)                            | ログインを特定の方法または Anthropic 組織に制限します。メソッド制限は VS Code 拡張機能、Agent SDK、`claude setup-token`、`/install-github-app` 全体に適用され、ターミナルのインタラクティブログイン画面（`/login` または初回オンボーディングで到達）はメソッドを事前選択しますが強制しません。Claude Code は、ターミナル、VS Code 拡張機能、Agent SDK での claude.ai アカウントログインの組織を検証し、Claude Console ログインまたは[ゲートウェイ](/docs/ja/claude-apps-gateway)サインインではチェックしません。v2.1.212 より前は、ターミナルログインのみが両方のキーを適用していました。設定すると、`ANTHROPIC_API_KEY`、`ANTHROPIC_AUTH_TOKEN`、または `apiKeyHelper` によって認証されたセッションはスタートアップでブロックされます。クラウドプロバイダーセッションは影響を受けません | `forceLoginMethod`、`forceLoginOrgUUID`                                                                                              |
-| [エージェントビューを無効にする](/docs/ja/agent-view#how-background-sessions-are-hosted)         | `claude agents`、`--bg`、`/background`、およびオンデマンドスーパーバイザーをオフにします                                                                                                                                                                                                                                                                                                                                                                                                                                                | `disableAgentView`                                                                                                                  |
-| [企業ランチャーを構成する](/docs/ja/corporate-launcher)                                       | [バックグラウンドエージェントスーパーバイザー](/docs/ja/agent-view#how-background-sessions-are-hosted)、そのワーカー、および[その他のカバーされたバックグラウンドプロセス](/docs/ja/corporate-launcher#what-the-launcher-covers)に、エージェントビューをオフにする代わりに、必須の企業ランチャーをプレフィックスします                                                                                                                                                                                                                                                                                                   | `processWrapper`                                                                                                                    |
-| [モデル制限](/docs/ja/model-config#restrict-model-selection)                           | `availableModels` はピッカーに表示されるモデルをフィルタリングします。`enforceAvailableModels` を追加すると、自動選択されたデフォルトモデルも制限されます。このセッティングが CLI、ウェブ、IDE にどのように到達するかについては、[サーフェスカバレッジ](/docs/ja/model-config#surface-coverage)を参照してください                                                                                                                                                                                                                                                                                                           | `availableModels`、`enforceAvailableModels`                                                                                          |
-| [エフォートキャップ](/docs/ja/settings-reference#maxeffortlevel)                           | すべてのモデルまたはモデルごとに、すべてのプロバイダーで[エフォートレベル](/docs/ja/model-config#adjust-effort-level)をキャップします                                                                                                                                                                                                                                                                                                                                                                                                                         | `maxEffortLevel`                                                                                                                    |
-| [バージョンフロア](/docs/ja/settings-reference#minimumversion)                            | 自動更新が組織全体の最小値以下をインストールするのを防ぎます                                                                                                                                                                                                                                                                                                                                                                                                                                                                               | `minimumVersion`                                                                                                                    |
-| [必須バージョン範囲](/docs/ja/settings-reference#requiredminimumversion)                   | 実行中のバージョンが組織承認範囲外の場合、まったく起動を拒否します。ダウングレードのみをブロックする `minimumVersion` より強力です                                                                                                                                                                                                                                                                                                                                                                                                                                   | `requiredMinimumVersion`、`requiredMaximumVersion`                                                                                   |
-| [テレメトリオプトアウト](/docs/ja/data-usage#telemetry-services)                             | すべてのデバイスで Anthropic バウンドの使用メトリクス、エラーレポート、およびサーベイをオフにします                                                                                                                                                                                                                                                                                                                                                                                                                                                      | `env` に `CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC` を `1` に設定します。リンクされたセクションはカテゴリごとの変数を一覧表示します                                       |
+| 制御                                                                   | 機能                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           | キー設定                                                                                                                                |
+| :------------------------------------------------------------------- | :----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :---------------------------------------------------------------------------------------------------------------------------------- |
+| [権限ルール](/docs/ja/permissions)                                             | 特定のツールとコマンドを許可、確認、または拒否する                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | `permissions.allow`、`permissions.deny`                                                                                              |
```

</details>

<details>
<summary>agent-teams-ja.md</summary>

```diff
diff --git a/docs-ja/pages/agent-teams-ja.md b/docs-ja/pages/agent-teams-ja.md
index 7974b36..8aa560b 100644
--- a/docs-ja/pages/agent-teams-ja.md
+++ b/docs-ja/pages/agent-teams-ja.md
@@ -119,5 +119,5 @@ v2.1.199 以降、アイドル状態のチームメンバーの行は、他の
 デフォルトは `"in-process"` です。`"auto"` を設定して、既に tmux セッション内で実行している場合または使用しているターミナルが iTerm2 で `it2` CLI がインストールされている場合は分割ペインを有効にし、それ以外の場合は in-process にフォールバックします。`"tmux"` 設定は分割ペインモードを有効にし、ターミナルに基づいて tmux または iTerm2 を使用するかどうかを自動検出します。
 
-v2.1.186 以降、`"iterm2"` を設定して iTerm2 ネイティブ分割ペインを明示的に使用してください。このモードは [`it2` CLI](https://github.com/mkusaka/it2) が必要で、`it2` が見つからない場合はインストールコマンド付きでエラーを表示します。`it2` をインストールするか tmux に切り替えるオプションを提供するセットアッププロンプトは、ターミナルが iTerm2 で tmux がフォールバックとして利用可能な場合、`"auto"` または `"tmux"` の下に表示されます。
+`"iterm2"` を設定して iTerm2 ネイティブ分割ペインを明示的に使用してください。このモードは [`it2` CLI](https://github.com/mkusaka/it2) が必要で、`it2` が見つからない場合はインストールコマンド付きでエラーを表示します。`it2` をインストールするか tmux に切り替えるオプションを提供するセットアッププロンプトは、ターミナルが iTerm2 で tmux がフォールバックとして利用可能な場合、`"auto"` または `"tmux"` の下に表示されます。
 
 デフォルトをオーバーライドするには、`~/.claude/settings.json` で [`teammateMode`](/docs/ja/settings-reference#teammatemode) を設定してください。
```

</details>

<details>
<summary>agents-ja.md</summary>

```diff
diff --git a/docs-ja/pages/agents-ja.md b/docs-ja/pages/agents-ja.md
index 6faf8f2..688cc7a 100644
--- a/docs-ja/pages/agents-ja.md
+++ b/docs-ja/pages/agents-ja.md
@@ -23,5 +23,5 @@ Claude Code には、複数のタスクを同時に処理する 5 つの方法
 * [ワークツリー](/docs/ja/worktrees) は各セッションに個別の git チェックアウトを提供するため、並列セッションが同じファイルを編集することはありません。自分で実行するセッションに使用します。エージェントビューからディスパッチされたセッションは、[ファイルを編集する前に独自のワークツリーに移動](/docs/ja/agent-view#how-file-edits-are-isolated) し、スポーンするサブエージェントも各々独自のワークツリーを取得できます。
 * [クロスセッションメッセージング](/docs/ja/cross-session-messaging) により、Claude はこのマシン上、別のマシン上、または [クラウド](/docs/ja/claude-code-on-the-web) 上の他の Claude Code セッションをリストして、メッセージを送信できます。自分で実行するセッションは、検出結果とステータスを相互に渡すことができます。
-* [`/batch`](/docs/ja/commands) は、1 つの大きな変更を 5 ～ 30 個のワークツリー分離サブエージェントに分割し、各エージェントがプルリクエストを開く [skill](/docs/ja/skills) です。これはサブエージェントとワークツリーのパッケージ化された使用法であり、別の調整スタイルではありません。
+* [`/batch`](/docs/ja/commands) は、1 つの大きな変更を 5 ～ 30 個のワークツリー分離サブエージェントに分割する [skill](/docs/ja/skills) です。これはサブエージェントとワークツリーのパッケージ化された使用法であり、別の調整スタイルではありません。
 
 他にも Claude を各ステップで駆動することなく実行する機能がいくつかありますが、これらはエージェント間で作業を分割することとは異なる問題を解決します。
```

</details>

<details>
<summary>amazon-bedrock-ja.md</summary>

```diff
diff --git a/docs-ja/pages/amazon-bedrock-ja.md b/docs-ja/pages/amazon-bedrock-ja.md
index ec20931..e4551ab 100644
--- a/docs-ja/pages/amazon-bedrock-ja.md
+++ b/docs-ja/pages/amazon-bedrock-ja.md
@@ -520,5 +520,7 @@ Claude Code は、各リクエストで `X-Amzn-Bedrock-Service-Tier` ヘッダ
 </h2>
 
-Mantle は、Bedrock Invoke API ではなく、ネイティブ Anthropic API シェイプを通じて Claude モデルを提供する Amazon Bedrock エンドポイントです。同じ [AWS 認証情報](#2-configure-aws-credentials)、[IAM 権限](#iam-configuration)、および [`awsAuthRefresh` 設定](#advanced-credential-configuration) を使用します。
+Mantle は、Bedrock Invoke API ではなく、ネイティブ Anthropic API シェイプを通じて Claude モデルを提供する Amazon Bedrock エンドポイントです。同じ [AWS 認証情報](#2-configure-aws-credentials) と [`awsAuthRefresh` 設定](#advanced-credential-configuration) を使用します。
+
+Mantle は `bedrock-mantle:` プレフィックスの下に独自の IAM アクションを持つため、[IAM 設定](#iam-configuration) の `bedrock:` アクションはこれをカバーしていません。推論用に `bedrock-mantle:CreateInference` と、トークンカウント用に `bedrock-mantle:CountTokens` を IAM アイデンティティに付与します。AWS ドキュメントの [推論リクエストの実行](https://docs.aws.amazon.com/bedrock/latest/userguide/inference.html) と [トークンのカウント](https://docs.aws.amazon.com/bedrock/latest/userguide/count-tokens.html)、および [サービス認可リファレンス](https://docs.aws.amazon.com/service-authorization/latest/reference/list_amazonbedrockpoweredbyawsmantle.html) を参照して、すべての Mantle アクションを確認してください。
 
 <h3 id="enable-mantle">
@@ -672,5 +674,8 @@ v2.1.196 以降に更新してください。
 `CLAUDE_CODE_USE_MANTLE` を設定した後、`/status` が `Amazon Bedrock (Mantle)` を表示しない場合、変数がプロセスに到達していません。Claude Code を起動したシェルでエクスポートされているか、[settings file](/docs/ja/settings) の `env` ブロックで設定されていることを確認してください。
 
-有効な認証情報を持つ Mantle エンドポイントからの `403` は、AWS アカウントがリクエストしたモデルへのアクセスを許可されていないことを意味します。AWS アカウントチームに連絡してアクセスをリクエストしてください。
+Mantle エンドポイントからの `403` が何を意味するかは、エラーが IAM アクションを名前付けるかどうかによって異なります：
+
+* エラーが `bedrock-mantle:` アクションを名前付ける場合は、IAM アイデンティティにそのアクションを付与してください。
+* エラーがアクションを名前付けず、認証情報が有効な場合は、AWS アカウントがリクエストしたモデルへのアクセスを許可されていません。AWS アカウントチームに連絡してアクセスをリクエストしてください。
 
 モデル ID を名前付ける `400` は、そのモデルが Mantle で提供されていないことを意味します。Mantle は標準 Amazon Bedrock カタログとは別の独自のモデルラインアップを持っているため、`us.anthropic.claude-sonnet-4-6` などの推論プロファイル ID は機能しません。Mantle 形式の ID を使用するか、[両方のエンドポイントを有効にして](#run-mantle-alongside-the-invoke-api)、Claude Code が各リクエストをモデルが利用可能なエンドポイントにルーティングするようにしてください。
```

</details>

<details>
<summary>best-practices-ja.md</summary>

```diff
diff --git a/docs-ja/pages/best-practices-ja.md b/docs-ja/pages/best-practices-ja.md
index c4d77a4..b173ddb 100644
--- a/docs-ja/pages/best-practices-ja.md
+++ b/docs-ja/pages/best-practices-ja.md
@@ -203,5 +203,5 @@ CLAUDE.md ファイルは `@path/to/import` 構文を使用して追加ファイ
 
 <h3 id="configure-permissions">
-  パーミッションを設定する
+  権限モードを設定する
 </h3>
 
@@ -210,12 +210,12 @@ CLAUDE.md ファイルは `@path/to/import` 構文を使用して追加ファイ
 </Tip>
 
-Pro、Max、Team プランでは、auto mode は対話型ターミナルと VS Code セッションの[組み込みの開始パーミッションモード](/docs/ja/permission-modes#eliminate-prompts-with-auto-mode)です。別の分類器モデルがほとんどのアクションをレビューし、スコープエスカレーション、未知のインフラストラクチャ、敵対的なコンテンツ駆動のアクションなど、リスクがあるように見えるものだけをブロックします。
+Pro、Max、Team プランでは、auto mode は対話型ターミナルと VS Code セッションの[組み込みの開始権限モード](/docs/ja/permission-modes#eliminate-prompts-with-auto-mode)です。別の分類器モデルがほとんどのアクションをレビューし、スコープエスカレーション、未知のインフラストラクチャ、敵対的なコンテンツ駆動のアクションなど、リスクがあるように見えるものだけをブロックします。
 
-Manual モード（他のプランの組み込みの開始パーミッションモード）では、Claude Code はシステムを変更する可能性のあるアクション（ファイル書き込み、Bash コマンド、MCP ツール）の前に尋ねます。これは安全ですが、面倒です。10 回目の承認後、あなたはクリックしているだけで、本当にレビューしていません。これらの中断を減らす 2 つのツールがあり、Manual モードで適用され、auto mode でも同様に適用されます。
+Manual モード（他のプランの組み込みの開始権限モード）では、Claude Code はシステムを変更する可能性のあるアクション（ファイル書き込み、Bash コマンド、MCP ツール）の前に尋ねます。これは安全ですが、面倒です。10 回目の承認後、あなたはクリックしているだけで、本当にレビューしていません。これらの中断を減らす 2 つのツールがあり、Manual モードで適用され、auto mode でも同様に適用されます。
 
-* **パーミッションホワイトリスト**：`npm run lint` や `git commit` など、安全であることがわかっているツールを許可します
+* **権限ホワイトリスト**：`npm run lint` や `git commit` など、安全であることがわかっているツールを許可します
 * **サンドボックス**：OS レベルの分離を有効にして、ファイルシステムとネットワークアクセスを制限し、Claude が定義された境界内でより自由に動作できるようにします
 
-[パーミッションモード](/docs/ja/permission-modes)、[パーミッションルール](/docs/ja/permissions)、[サンドボックス](/docs/ja/sandboxing)の詳細をお読みください。
+[権限モード](/docs/ja/permission-modes)、[権限ルール](/docs/ja/permissions)、[サンドボックス](/docs/ja/sandboxing)の詳細をお読みください。
 
 <h3 id="use-cli-tools">
@@ -335,5 +335,5 @@ Claude に明示的にサブエージェントを使用するよう指示しま
 </Tip>
```

</details>

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index 92e3505..b6c326f 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,101 @@
 # Changelog
 
+## 2.1.283
+
+- Added `x-claude-code-prompt-id` to the gateway hint headers so LLM gateways can group the requests that serve one user prompt; opt in with `CLAUDE_CODE_GATEWAY_HINT_HEADERS=1`
+- Added `availableModelsMatch` managed setting: with `"exact"`, an `availableModels` entry allows only the model version it names, so new releases stay blocked until listed
+- Added `deniedModels` managed setting to block specific models, even when `availableModels` allows them
+- Added MCP tool, WebFetch and WebSearch outputs to the `tool.output` OpenTelemetry span event when `OTEL_LOG_TOOL_CONTENT=1`
+- Added `/doctor prompt-audit` (also `/checkup prompt-audit`) to audit your CLAUDE.md files, skills, agents and commands for prompting patterns written for older models
+- Added click-to-expand for truncated messages from your other sessions in fullscreen mode
+- Added `path` to `--plugin-dir` load-failure entries in the stream-json `system/init` `plugin_errors`, naming the directory that did not load
+- Added an opt-in `load_test_mode` block to the Claude apps gateway config: requests are built and signed but not sent upstream, and clients get a canned reply, so a deployment can be load tested
+- Added a `mantle` upstream provider to the Claude apps gateway for Amazon Bedrock's Mantle endpoint
+- Fixed SDK sessions losing a deferred tool call or finished tool result when a turn ended early, a held approval prompt after a worker restart, and a non-streaming fallback's `result.usage`
+- Fixed MCP progress notifications being discarded once a long-running tool call moved to the background; the background task now shows the latest progress
+- Fixed stdio MCP servers being left running when the session ended while they were still starting
+- Fixed a brief HTTP 404 from a stateless remote MCP server (for example a proxy mid-redeploy) leaving that server unusable for the rest of the session while still shown as connected
+- Fixed MCP sign-in for a server with no valid URL failing with an opaque SDK error; `/mcp` no longer offers Authenticate for such servers
+- Fixed the weekly Fable limit not appearing in `/usage` and the VS Code usage meters when telemetry is disabled
+- Fixed `/model` accepting Sonnet 4.6 or Sonnet 5 with `[1m]` when the id carried a date or `-v1:0` suffix, in the cases where the plain id was refused
+- Fixed `/model` picker showing a hardcoded Haiku version and price when `ANTHROPIC_DEFAULT_HAIKU_MODEL` pins a different model
+- Fixed dynamic workflows started during a model fallback running every agent on the fallback model instead of retrying the configured model
+- Fixed `DISABLE_PROMPT_CACHING_HAIKU` having no effect when Haiku is the session's main model
+- Fixed `claude plugin validate` saying Claude Code accepts a plugin or marketplace name it cannot install; such names in `marketplace.json` now fail validation
+- Fixed `claude plugin validate` passing plugins whose `outputStyles`, `themes`, `monitors`, or `lspServers` paths are missing or point outside the plugin directory
```

</details>

<details>
<summary>channels-ja.md</summary>

```diff
diff --git a/docs-ja/pages/channels-ja.md b/docs-ja/pages/channels-ja.md
index 6defd50..426efb3 100644
--- a/docs-ja/pages/channels-ja.md
+++ b/docs-ja/pages/channels-ja.md
@@ -46,7 +46,7 @@ Team、Enterprise、または Console 組織を管理している場合は、[
 
         * `Marketplace "claude-plugins-official" not found`：`/plugin marketplace add anthropics/claude-plugins-official` でマーケットプレイスを追加してから、インストールを再試行してください。
-        * プラグインが[マーケットプレイスで見つかりません](/docs/ja/discover-plugins#install-plugins)：プラグイン名を確認してください。
+        * プラグインが[マーケットプレイスで見つかりません](/docs/ja/plugins/install#install-a-plugin)：プラグイン名を確認してください。
 
-        インストールがインストールスコープを求めるとき、ユーザースコープオプションを選択して、プラグインがすべてのプロジェクト全体で利用可能になるようにしてください。インストール概要を確認してください。`Run /reload-plugins to activate.` と報告されている場合は、[プラグイン変更を再起動なしで適用する](/docs/ja/discover-plugins#apply-plugin-changes-without-restarting)を参照して、プラグインの設定コマンドを利用可能にしてください。
+        インストールがインストールスコープを求めるとき、ユーザースコープオプションを選択して、プラグインがすべてのプロジェクト全体で利用可能になるようにしてください。インストール概要を確認してください。`Run /reload-plugins to activate.` と報告されている場合は、[プラグイン変更を再起動なしで適用する](/docs/ja/plugins/cli-reference#reload-plugins)を参照して、プラグインの設定コマンドを利用可能にしてください。
       </Step>
 
@@ -124,7 +124,7 @@ Team、Enterprise、または Console 組織を管理している場合は、[
 
         * `Marketplace "claude-plugins-official" not found`：`/plugin marketplace add anthropics/claude-plugins-official` でマーケットプレイスを追加してから、インストールを再試行してください。
-        * プラグインが[マーケットプレイスで見つかりません](/docs/ja/discover-plugins#install-plugins)：プラグイン名を確認してください。
+        * プラグインが[マーケットプレイスで見つかりません](/docs/ja/plugins/install#install-a-plugin)：プラグイン名を確認してください。
 
-        インストールがインストールスコープを求めるとき、ユーザースコープオプションを選択して、プラグインがすべてのプロジェクト全体で利用可能になるようにしてください。インストール概要を確認してください。`Run /reload-plugins to activate.` と報告されている場合は、[プラグイン変更を再起動なしで適用する](/docs/ja/discover-plugins#apply-plugin-changes-without-restarting)を参照して、プラグインの設定コマンドを利用可能にしてください。
+        インストールがインストールスコープを求めるとき、ユーザースコープオプションを選択して、プラグインがすべてのプロジェクト全体で利用可能になるようにしてください。インストール概要を確認してください。`Run /reload-plugins to activate.` と報告されている場合は、[プラグイン変更を再起動なしで適用する](/docs/ja/plugins/cli-reference#reload-plugins)を参照して、プラグインの設定コマンドを利用可能にしてください。
       </Step>
 
@@ -189,7 +189,9 @@ Team、Enterprise、または Console 組織を管理している場合は、[
 
         * `Marketplace "claude-plugins-official" not found`：`/plugin marketplace add anthropics/claude-plugins-official` でマーケットプレイスを追加してから、インストールを再試行してください。
-        * プラグインが[マーケットプレイスで見つかりません](/docs/ja/discover-plugins#install-plugins)：プラグイン名を確認してください。
+        * プラグインが[マーケットプレイスで見つかりません](/docs/ja/plugins/install#install-a-plugin)：プラグイン名を確認してください。
 
```

</details>

*...以降省略*

</details>


<details>
<summary>2026-09-25</summary>

**変更ファイル:**

```
 docs-ja/pages/changelog.md                  |  89 +++++++++++
 docs-ja/pages/claude-apps-gateway-ja.md     |   4 +-
 docs-ja/pages/costs-ja.md                   |   2 +
 docs-ja/pages/env-vars-ja.md                |   6 +-
 docs-ja/pages/errors-ja.md                  | 223 ++++++++++++++++++++++------
 docs-ja/pages/interactive-mode-ja.md        |   2 +-
 docs-ja/pages/managed-settings-ja.md        |   2 +-
 docs-ja/pages/memory-ja.md                  |  12 +-
 docs-ja/pages/plugin-evals-ja.md            |  28 ++--
 docs-ja/pages/server-managed-settings-ja.md |   2 +-
 docs-ja/pages/settings-reference-ja.md      |   4 +
 11 files changed, 304 insertions(+), 70 deletions(-)
```

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index 288b140..92e3505 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,93 @@
 # Changelog
 
+## 2.1.282
+
+- Added a `maxProseWidth` setting that caps the width of Claude's prose in wide terminals while tables and code blocks keep the full width
+- Added a startup notice, and `/status` and `claude doctor` entries, listing telemetry variables in a project's settings files that were ignored or that turned telemetry off
+- Added the `allowClaudeInChromeWithManagedMcp` managed setting to let `claude --chrome` run alongside an exclusive `managed-mcp.json`; the error shown when Chrome is blocked now names it
+- Added `store.readiness_grace_seconds` to the Claude apps gateway so `/readyz` can stay ready through a short Postgres outage such as a database failover
+- Added a scrollbar to the `/feedback` drafts list in fullscreen mode; it appears while the mouse is over the list
+- Fixed every request failing with a 400 error in conversations whose history holds web search results the API cannot decrypt (for example, from a turn answered through a third-party gateway)
+- Fixed more cases of continued or resumed sessions (`--continue`, `--resume`) re-sending earlier messages in a changed form, which could make the API drop Claude's earlier reasoning
+- Fixed earlier extended thinking being dropped when `/model`, `/rename`, `/artifacts` or another immediate slash command was used while Claude was working
+- Fixed continued or resumed conversations losing earlier extended thinking when relaunched with a `--tools` list that leaves out a built-in tool offered earlier in the conversation
+- Fixed sessions failing on every turn with an "Invalid `data` in `redacted_thinking` block" API error; Claude Code now drops the conversation's thinking blocks and retries once
+- Fixed compaction failing when the summarization request is refused; it now retries on a fallback model
+- Fixed a failed turn ("Effort 'xhigh' isn't available with thinking turned off") after a safety-related model switch in sessions with thinking off and effort above high
+- Fixed an unanswered Fable usage-credits prompt switching models in SDK-hosted sessions such as Claude Desktop; the turn now ends instead, and Remote Control clients now see the model-switch notice
+- Fixed `/model` with a full Fable model id stopping at an API error instead of opening the usage-credits prompt when the plan needs usage credits that aren't turned on yet
+- Fixed requests failing for up to a minute with an "another Claude Code process is refreshing it" login error after that other process was closed or killed mid-refresh
+- Fixed sessions started while another Claude Code window was refreshing the sign-in (common with several VS Code windows) not retrying their organization policy fetch
+- Fixed CLAUDE.md and rules being read at startup through a repository symlink reaching macOS's `/Network` via `..` or a `/.vol`-style kernel path, or a rules link to macOS's `/home` being listed
+- Fixed Bash permission rules with a mid-pattern `:*` being skipped in settings files while `--allowedTools` honored them; they now work from every source, with a startup warning on how they match
+- Fixed a command approved on a restored permission prompt running twice when a remote session's worker restarted
+- Fixed managed settings ignoring a mistyped value for boolean lock keys such as `disableClaudeAiConnectors` or `allowManagedPermissionRulesOnly`; the lock now applies and startup names the key
+- Fixed managed `permissions`, `autoMode`, `worktree` and `attribution` settings being ignored entirely when one nested value was invalid; the rest of the block now still applies
```

</details>

<details>
<summary>claude-apps-gateway-ja.md</summary>

```diff
diff --git a/docs-ja/pages/claude-apps-gateway-ja.md b/docs-ja/pages/claude-apps-gateway-ja.md
index 2dbc080..be5bd8a 100644
--- a/docs-ja/pages/claude-apps-gateway-ja.md
+++ b/docs-ja/pages/claude-apps-gateway-ja.md
@@ -449,9 +449,11 @@ hooks ロックと `allowManagedPermissionRulesOnly` の開発者独自のルー
 </h4>
 
-5 つのロックすべてが設定されていても、4 つの親が提供した設定がフィルターを通過します。デフォルトの最初の勝ちの設定の下で、親をブロックする管理値は最優先の管理ソースにあるものです。ただし、[MCP サーバーロック](#lock-behavior-across-sources)がオンの間は `allowedMcpServers` を除きます。`managedSourcesBehavior` マージオプトインの下で、[Claude Code が管理ソースを組み合わせる方法](/docs/ja/managed-settings#how-claude-code-combines-managed-sources)は代わりにどのソースの値が適用されるかを示します。
+5 つのロックすべてが設定されていても、6 つの親が提供した設定がフィルターを通過します。デフォルトの最初の勝ちの設定の下で、親をブロックする管理値は最優先の管理ソースにあるものです。ただし、[MCP サーバーロック](#lock-behavior-across-sources)がオンの間は `allowedMcpServers` を除きます。`managedSourcesBehavior` マージオプトインの下で、[Claude Code が管理ソースを組み合わせる方法](/docs/ja/managed-settings#how-claude-code-combines-managed-sources)は代わりにどのソースの値が適用されるかを示します。
 
 * **`forceLoginOrgUUID`**：最優先の管理ソースが組織 UUID を設定しない場合、Claude Code は親が提供した値を尊重します。ゲートウェイサインインはこのキーをチェックしないため、最初の当事者 Anthropic ログインも使用するフリートにのみ重要です。最優先の管理ソースの組織 UUID は親の値をブロックし、Claude Code が強制するものです。そこに `forceLoginOrgUUID` を設定します。
 * **`allowedMcpServers`**：最優先の管理ソースが設定しない場合、Claude Code は親が提供した許可リストを尊重します。`allowManagedMcpServersOnly` はそれをブロックしません。ロックは勝者の許可リストを管理値として強制するため、最優先の管理ソースが設定しない場合は親が提供した許可リストを含みます。最優先の管理ソースのリストは親のリストをブロックし、Claude Code が強制するリストです。ロックの隣にそこに `allowedMcpServers` を設定します。v2.1.223 より前では、任意の管理ソースのいずれかのキーの値は親のリストをブロックしました。
 * **`availableModels`**：勝者の管理ソースが設定しない場合、Claude Code は親が提供したモデルリストを尊重します。フリートがモデルを制限する場合、勝者ソースに `availableModels` を設定します。
+* **`strictKnownMarketplaces`**：勝者の管理ソースが設定しない場合、Claude Code は親が提供したプラグインマーケットプレイス許可リストを尊重します。フリートがマーケットプレイスを制限する場合、勝者ソースに `strictKnownMarketplaces` を設定します。Claude Code v2.1.282 以降が必要です。
+* **`blockedMarketplaces`**：親が提供したマーケットプレイスブロックリストは通過し、管理ソースが設定するブロックリストに追加されます。ブロックリストはさらに制限することのみができるためです。Claude Code v2.1.282 以降が必要です。
 * **`strictPluginOnlyCustomization`**：このキーはロックに関係なくフィルターを通過し、Claude Code が開発者独自のカスタマイズ（保護フックを含む）を無視するようにします。ロックはそれをブロックしません。
 
```

</details>

<details>
<summary>costs-ja.md</summary>

```diff
diff --git a/docs-ja/pages/costs-ja.md b/docs-ja/pages/costs-ja.md
index 0086a69..f9a1153 100644
--- a/docs-ja/pages/costs-ja.md
+++ b/docs-ja/pages/costs-ja.md
@@ -408,4 +408,6 @@ Claude Code はアイドル状態でも、バックグラウンド機能にト
 これらのバックグラウンドプロセスは、アクティブなインタラクションがなくても、少量のトークン（通常はセッションあたり \$0.04 未満）を消費します。
 
+プロンプト提案がオンの場合、Claude Code は Claude が応答した後、セッションが使用しているモデルに短いリクエストを送信して、[次のプロンプトを提案](/docs/ja/interactive-mode#prompt-suggestions)します。そのリクエストは会話のプロンプトキャッシュを再利用するため、ほぼキャッシュ読み取りと少数の出力トークンです。Claude Code は[アカウントが使用量制限に近い、または達している場合、提案をスキップ](/docs/ja/interactive-mode#when-claude-code-skips-suggestions)します。これらのリクエストを停止するには、[プロンプト提案をオフにしてください](/docs/ja/interactive-mode#turn-prompt-suggestions-off)。
+
 <h2 id="why-usage-climbs-in-a-long-session">
   長いセッションで使用量が増加する理由
```

</details>

<details>
<summary>env-vars-ja.md</summary>

```diff
diff --git a/docs-ja/pages/env-vars-ja.md b/docs-ja/pages/env-vars-ja.md
index 46a24e8..18f81da 100644
--- a/docs-ja/pages/env-vars-ja.md
+++ b/docs-ja/pages/env-vars-ja.md
@@ -350,5 +350,5 @@ Claude Code はスタートアップ時にシェル環境変数を読み込む
 | `CLAUDE_CODE_PRINT_BG_WAIT_CEILING_MS`                  | [非対話モード](/docs/ja/headless#background-tasks-at-exit) で `-p` フラグを使用した最終ターン後、バックグラウンドサブエージェントとワークフローを待機するアイドル待機の上限（ミリ秒単位）。アイドル待機は Claude がバックグラウンド結果を処理するターンを取るたびに再開されます。デフォルト：`600000`、または 10 分。アイドル待機が上限に達すると、Claude Code は残りのバックグラウンドタスクの待機を停止して終了します。`0` に設定して無期限に待機します。このキャップは、プレーンバックグラウンドシェルに適用される 5 秒の猶予期間とは別です。Claude Code v2.1.182 以降が必要です                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
 | `CLAUDE_CODE_PROCESS_WRAPPER`                           | Claude Code が独自のバイナリから開始するプロセス（[エージェントビュー](/docs/ja/agent-view) セッションをホストするバックグラウンドサービスなど）を、`/opt/corp/launcher` などの argv プレフィックスとして指定されたコーポレートランチャーを通じて起動します。ユーザーまたは [管理設定](/docs/ja/managed-settings) の `env` ブロックで設定します。プロジェクトおよびローカル設定では設定できません。デタッチされたバックグラウンドサービスがそれを継承するため。[`processWrapper` 設定](/docs/ja/settings-reference#processwrapper) と同等です。Claude Code v2.1.210 以降が必要です。この変数は両方が設定されている場合に優先されます。VS Code 拡張機能は `claudeProcessWrapper` 設定を通じて独自のランチャーを個別に設定します。Windows では無視されます。値の形式、ランチャーがカバーするもの、ランチャーが満たす必要があるコントラクトについては、[コーポレートランチャーの背後で Claude Code を実行](/docs/ja/corporate-launcher) を参照してください。Claude Code v2.1.208 以降が必要です                                                                                                                                                                                                                                                                                                      |
-| `CLAUDE_CODE_PROJECT_DIR_NAME`                          | `CLAUDE_CONFIG_DIR` と一緒に設定して、Claude Code がそのセッションのトランスクリプトと自動メモリを保存する `projects/` ディレクトリ名を選択します。作業ディレクトリパスから派生したものの代わりに。例えば、`CLAUDE_CONFIG_DIR=/srv/tenant-a CLAUDE_CODE_PROJECT_DIR_NAME=work claude` で開始すると、`/srv/tenant-a/projects/work/` の下に保存されます。`CLAUDE_CONFIG_DIR` が設定されていない場合、Claude Code はこの変数を無視し、`claude` を開始する環境からのみ読み取ります。設定ファイル `env` ブロックからは読み取りません。[プロジェクトディレクトリを自分で名前付け](/docs/ja/sessions#name-your-project-directory-yourself) を参照してください。Claude Code v2.1.234 以降が必要です                                                                                                                                                                                                                                                                                                                                                                                                                                              |
+| `CLAUDE_CODE_PROJECT_DIR_NAME`                          | `CLAUDE_CONFIG_DIR` と一緒に設定して、Claude Code がそのセッションのトランスクリプトと自動メモリを保存する `projects/` ディレクトリ名を選択します。作業ディレクトリパスから派生したものの代わりに。例えば、`CLAUDE_CONFIG_DIR=/srv/tenant-a CLAUDE_CODE_PROJECT_DIR_NAME=work claude` で開始すると、`/srv/tenant-a/projects/work/` の下に保存されます。`CLAUDE_CONFIG_DIR` が設定されていない場合、Claude Code はこの変数を無視します。また、この変数は `claude` を開始する環境からのみ読み取り、[設定ファイル `env` ブロック](#in-settings-files)からは読み取りません。[プロジェクトディレクトリを自分で名前付け](/docs/ja/sessions#name-the-project-directory-yourself) を参照してください。Claude Code v2.1.234 以降が必要です                                                                                                                                                                                                                                                                                                                                                                                                                |
 | `CLAUDE_CODE_PROMPT_CACHE_TTL`                          | `5m` または `1h` に設定します。Claude Code が受け入れる唯一の値。メイン会話の [プロンプトキャッシュ TTL](/docs/ja/prompt-caching#cache-lifetime) を選択します：対話的、`-p`、SDK ターン、およびそれらと一緒に実行されるヘルパー。`promptCacheTtl` 設定および `ENABLE_PROMPT_CACHING_1H` より優先されます。`FORCE_PROMPT_CACHING_5M` がそれをオーバーライドします。API は 1 時間のキャッシュ書き込みをより高いレートで請求します。Claude Code v2.1.242 以降が必要です                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
 | `CLAUDE_CODE_PROPAGATE_TRACEPARENT`                     | `ANTHROPIC_BASE_URL` がカスタムプロキシを指している場合、W3C トレースコンテキストを伝播するには `1` に設定します。伝播はモデルおよび HTTP MCP リクエストの `traceparent` ヘッダーと、Bash、PowerShell、フックサブプロセスの `TRACEPARENT` 環境変数をカバーします。デフォルトでは、伝播は Anthropic API への直接接続に接続されている場合にのみ有効になります。v2.1.152 で追加されました。[トレース（ベータ）](/docs/ja/monitoring-usage#traces-beta) を参照してください                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
@@ -462,5 +462,5 @@ Claude Code はスタートアップ時にシェル環境変数を読み込む
 | `MAX_MCP_OUTPUT_TOKENS`                                 | MCP ツール応答で許可される最大トークン数。Claude Code は出力が 10,000 トークンを超える場合に警告を表示します。[`anthropic/maxResultSizeChars`](/docs/ja/mcp#raise-the-limit-for-a-specific-tool) を宣言するツールは、テキストコンテンツにはその文字制限を使用しますが、それらのツールからの画像コンテンツはこの変数の対象です（デフォルト：25000）                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
 | `MAX_STRUCTURED_OUTPUT_RETRIES`                         | 非対話モードで `-p` フラグを使用して、モデルの応答が [`--json-schema`](/docs/ja/cli-reference#cli-flags) に対する検証に失敗した場合、Claude Code が許可する試行回数。その後、有効な出力がない場合、実行は失敗します。[ワークフロー](/docs/ja/workflows) サブエージェントの構造化出力が検証に失敗した場合にも同じキャップが適用されます。デフォルト 5。最初の試行と 4 回の再試行                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
-| `MAX_THINKING_TOKENS`                                   | [拡張思考](https://platform.claude.com/docs/en/build-with-claude/extended-thinking) の固定トークン予算。Claude Code はそれを要求の最大出力トークンの 1 トークン下でキャップし、1,024 未満にはしません。[`CLAUDE_CODE_MAX_OUTPUT_TOKENS`](/docs/ja/model-config#adjust-effort-level) でそのリミットを設定する方法を参照してください。設定されていない場合、[適応的推論](/docs/ja/model-config#adjust-effort-level) を持つモデルは独自の思考深度を選択し、他のモデルはキャップを使用します。Anthropic API で思考を無効にするには `0` に設定します。Opus 5.5 および Fable モデルを除き、思考をオフにすることはできません。[サードパーティプロバイダー](/docs/ja/third-party-integrations) では、`0` は代わりに `thinking` パラメーターを省略します。Anthropic API で思考がオフの場合、Claude Code は、Opus 5 などの [その組み合わせを受け入れないモデル](/docs/ja/errors#effort-isnt-available-with-thinking-turned-off) に努力 `high` を送信します。Claude Code は、適応的推論モデルの非ゼロ値を無視します。ただし、`CLAUDE_CODE_DISABLE_ADAPTIVE_THINKING` が適応的推論をオフにするモデルを除きます                                                                                                                                                          |
+| `MAX_THINKING_TOKENS`                                   | [拡張思考](https://platform.claude.com/docs/en/build-with-claude/extended-thinking) の固定トークン予算。Claude Code はそれを要求の最大出力トークンの 1 トークン下でキャップし、1,024 未満にはしません。そのリミットの設定方法については、`CLAUDE_CODE_MAX_OUTPUT_TOKENS` を参照してください。設定されておらず思考が有効な場合、[適応的推論](/docs/ja/model-config#adjust-effort-level) を持つモデルは独自の思考深度を選択し、他のモデルはキャップを使用します。Anthropic API で思考を無効にするには `0` に設定します。ただし、思考をオフにできない Opus 5.5 および Fable モデルは除きます。[サードパーティプロバイダー](/docs/ja/third-party-integrations) では、`0` は代わりに `thinking` パラメーターを省略します。Anthropic API で思考がオフの場合、Claude Code は、Opus 5 など、[その組み合わせを受け入れない](/docs/ja/errors#effort-isnt-available-with-thinking-turned-off) とわかっているモデルに、より高いレベルではなく努力 `high` を送信します。Claude Code は、適応的推論モデルの非ゼロ値を無視します。ただし、`CLAUDE_CODE_DISABLE_ADAPTIVE_THINKING` が適応的推論をオフにするモデルを除きます                                                                                                                                                                       |
 | `MCP_CLIENT_SECRET`                                     | [事前設定された認証情報](/docs/ja/mcp#use-pre-configured-oauth-credentials) が必要な MCP サーバーの OAuth クライアントシークレット。`--client-secret` でサーバーを追加するときに対話的なプロンプトを回避します                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
 | `MCP_CONNECTION_NONBLOCKING`                            | MCP サーバーが最初のクエリの前に接続するのを待機するかどうかを制御します。MCP スタートアップはデフォルトで非ブロッキングです：サーバーはバックグラウンドで接続し、完了するとそれらのツールが利用可能になります。最初のクエリの前にサーバーが接続するのを待機するには `0` に設定します。[`alwaysLoad: true`](/docs/ja/mcp#exempt-a-server-from-deferral) で設定されたサーバーは、[検出キャッシュ](/docs/ja/mcp#server-status-detail) から提供される場合を除き、関係なくスタートアップを待機させます。ツールは最初のプロンプトが構築されるときに存在する必要があります。非対話モード（`-p`）で `--input-format stream-json` がない場合、Claude Code は最初のターンの前に保留中のサーバーを待機します。[`--mcp-config`](/docs/ja/cli-reference#cli-flags) を明示的に渡すと、待機にはより長いデッドラインがあります。キャッシュされたサーバーの例外については、そのフラグのエントリを参照してください                                                                                                                                                                                                                                                                                                                                                                                      |
@@ -471,5 +471,5 @@ Claude Code はスタートアップ時にシェル環境変数を読み込む
 | `MCP_DISCOVERY_CACHE_TTL_S`                             | Claude Code が [検出キャッシュ](/docs/ja/mcp#server-status-detail) エントリをリフレッシュせずに使用する秒数（デフォルト：900）。エントリがそれより古い開始では、Claude Code は引き続きそれを使用しますが、バックグラウンドでリフレッシュします。エントリが `MCP_DISCOVERY_CACHE_MAX_STALE_S` より古い場合、Claude Code は代わりに破棄します。Claude Code は値を `MCP_DISCOVERY_CACHE_MAX_STALE_S`（デフォルト 4 時間）でキャップします。v2.1.238 より前は、Claude Code は値をキャップしませんでした                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
 | `MCP_OAUTH_CALLBACK_PORT`                               | [事前設定された認証情報](/docs/ja/mcp#use-pre-configured-oauth-credentials) を使用して MCP サーバーを追加するときの OAuth リダイレクトコールバック用の固定ポート。`--callback-port` の代替                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
-| `MCP_PROTOCOL_NEGOTIATION`                              | [v2 MCP クライアントランタイム](/docs/ja/mcp#mcp-client-runtimes) でのみ、Claude Code が MCP プロトコルリビジョン 2026-07-28 のサーバーをプローブするかどうか。HTTP、claude.ai コネクター、stdio サーバーをプローブするには `auto` に設定します。プローブに応答しないサーバーは以前のプロトコルで接続します。SSE および WebSocket サーバーは常にそうします。すべてのサーバーのプローブをスキップするには `legacy` に設定します。変数がない場合、Claude Code は HTTP サーバーをプローブし、[機能フラグを取得](/docs/ja/mcp#mcp-client-runtimes) するセッションで claude.ai コネクターサーバーもプローブします。その他の値は警告で無視されます。Claude Code v2.1.221 以降が必要です                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
+| `MCP_PROTOCOL_NEGOTIATION`                              | [v2 MCP クライアントランタイム](/docs/ja/mcp#mcp-client-runtimes) でのみ、Claude Code が MCP プロトコルリビジョン 2026-07-28 のサーバーをプローブするかどうか。HTTP、claude.ai コネクター、stdio サーバーをプローブするには `auto` に設定します。プローブに応答しないサーバーは以前のプロトコルで接続します。SSE および WebSocket サーバーは常にそうします。すべてのサーバーのプローブをスキップするには `legacy` に設定します。変数がない場合、Claude Code は HTTP サーバーをプローブし、[機能フラグを取得](#features-that-need-feature-flag-fetching) するセッションで claude.ai コネクターサーバーもプローブします。その他の値は無視され、デバッグログに警告が書き込まれます。Claude Code v2.1.221 以降が必要です                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
 | `MCP_REMOTE_SERVER_CONNECTION_BATCH_SIZE`               | スタートアップ中に並列で接続するリモート MCP サーバー（HTTP/SSE）の最大数（デフォルト：20）                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
 | `MCP_SDK_GENERATION`                                    | このプロセスが MCP サーバーに接続する [MCP クライアントランタイム](/docs/ja/mcp#mcp-client-runtimes) をピン留めします：`v1`（MCP TypeScript SDK 1.x に基づく）または `v2`（[MCP TypeScript SDK 2.0](https://ts.sdk.modelcontextprotocol.io/v2/) に基づく）。変数がない場合、Claude Code は v2 を使用します。そのセクションにリストされているバージョンから開始。Claude Code v2.1.221 以降では、v2 ランタイムは MCP OAuth サーバーが認可応答で返す発行者をチェックし、一致しない場合、`Issuer mismatch in authorization response` で始まるエラーでサインインに失敗します。v1 ランタイムはこのチェックを実行しません。認識されない値を設定すると、Claude Code はそれを無視し、デバッグログに警告を書き込みます。Claude Code はプロセスごとに値を 1 回読み取ります。Claude Code v2.1.218 以降が必要です                                                                                                                                                                                                                                                                                                                                                                                  |
```

</details>

<details>
<summary>errors-ja.md</summary>

```diff
diff --git a/docs-ja/pages/errors-ja.md b/docs-ja/pages/errors-ja.md
index 6282f10..a53f8b1 100644
--- a/docs-ja/pages/errors-ja.md
+++ b/docs-ja/pages/errors-ja.md
@@ -37,4 +37,6 @@
 | `Auto mode classifier transcript exceeded context window`                                                                                                                                                                                                            | [サーバーエラー](#auto-mode-cannot-determine-the-safety-of-an-action)                                    |
 | `Agent aborted: auto mode classifier request refused by the safety safeguard`                                                                                                                                                                                        | [サーバーエラー](#auto-mode-cannot-determine-the-safety-of-an-action)                                    |
+| `The server-side auto mode classifier gave no verdict`                                                                                                                                                                                                               | [サーバーエラー](#the-server-returned-no-safety-verdict)                                                 |
+| `Auto mode is unavailable — the server returned no safety verdict for the last 10 responses`                                                                                                                                                                         | [サーバーエラー](#the-server-returned-no-safety-verdict)                                                 |
 | `Agent terminated early due to an API error`                                                                                                                                                                                                                         | [サーバーエラー](#agent-terminated-early-due-to-an-api-error)                                            |
 | `You've hit your session limit` / `You've hit your weekly limit` / `You've hit your Opus limit` / `You've hit your Sonnet limit`                                                                                                                                     | [使用制限](#youve-hit-your-session-limit)                                                             |
@@ -155,4 +157,6 @@
 | `API Error: 400 duplicate tool_use ID in conversation history`                                                                                                                                                                                                       | [リクエストエラー](#tool-use-or-thinking-block-mismatch)                                                  |
 | `[Unsupported tool content removed]`                                                                                                                                                                                                                                 | [リクエストエラー](#unsupported-tool-content-removed)                                                     |
+| `role 'system' must precede an 'assistant' message`                                                                                                                                                                                                                  | [リクエストエラー](#role-system-must-precede-an-assistant-message)                                        |
+| `Invalid encrypted_content in search_result block` / `Invalid encrypted_index in text block` / `Failed to decrypt web search result content`                                                                                                                         | [リクエストエラー](#invalid-encrypted-content-in-search-result-block)                                     |
 | `server_tool_use.name: Input should be` on every turn of a resumed session                                                                                                                                                                                           | [リクエストエラー](#unsupported-tool-content-removed)                                                     |
 | `<model> can't help with this. Start a new session to continue`                                                                                                                                                                                                      | [リクエストエラー](#usage-policy-refusal)                                                                 |
@@ -172,4 +176,5 @@
 | `Error: Settings file exceeds the 2MiB limit`                                                                                                                                                                                                                        | [コマンドラインエラー](#settings-file-exceeds-the-2mib-limit)                                               |
 | `The current directory no longer exists (it was deleted or moved)` / `Can't read the current directory`                                                                                                                                                              | [コマンドラインエラー](#the-current-directory-no-longer-exists)                                             |
+| `Temp directory <dir> ... Refusing to use it` / `ENOSPC: no space left on device, mkdir '<dir>'`                                                                                                                                                                     | [コマンドラインエラー](#temp-directory-refused-or-cannot-be-created)                                        |
 | `couldn't be resolved to a real location, so its skills, commands, and agents weren't loaded`                                                                                                                                                                        | [コマンドラインエラー](#directory-couldnt-be-resolved-to-a-real-location)                                   |
 | `Error: Workspace not trusted` when starting Remote Control                                                                                                                                                                                                          | [コマンドラインエラー](#workspace-not-trusted-when-starting-remote-control)                                 |
@@ -215,4 +220,5 @@
 | `Marketplace "<name>" is registered from an untrusted source`                                                                                                                                                                                                        | [プラグインエラー](#marketplace-is-registered-from-an-untrusted-source)                                   |
 | `Marketplace "<name>" is already added from a different source`                                                                                                                                                                                                      | [プラグインエラー](#marketplace-is-already-added-from-a-different-source)                                 |
+| `"<name>" is another spelling of "<reserved>", a reserved marketplace name`                                                                                                                                                                                          | [プラグインエラー](#marketplace-name-is-another-spelling-of-a-reserved-name)                              |
 | `references ${user_config.*} in a shell-form command`                                                                                                                                                                                                                | [プラグインエラー](#plugin-command-references-user-config)                                                |
 | `Monitor "<name>" from plugin <plugin> references ${user_config.*} in its command`                                                                                                                                                                                   | [プラグインエラー](#plugin-command-references-user-config)                                                |
```

</details>

<details>
<summary>interactive-mode-ja.md</summary>

```diff
diff --git a/docs-ja/pages/interactive-mode-ja.md b/docs-ja/pages/interactive-mode-ja.md
index 0be1131..fc9dd03 100644
--- a/docs-ja/pages/interactive-mode-ja.md
+++ b/docs-ja/pages/interactive-mode-ja.md
@@ -440,5 +440,5 @@ Claude が応答した後、Claude Code は会話履歴に基づいて次のプ
 * 入力を開始して提案を閉じます
 
-Claude Code は、これらの次のプロンプト提案を、会話のプロンプトキャッシュを再利用するバックグラウンドリクエストで生成するため、追加コストは最小限です。
+Claude Code は、これらの次のプロンプト提案を、セッションが使用しているのと同じモデルへのバックグラウンドリクエストで生成します。このリクエストはプランの使用制限または API コストにカウントされます。会話のプロンプトキャッシュを再利用するため、主にキャッシュ読み取りと少数の出力トークンで構成されるため、追加コストは最小限です。
 
 <h3 id="when-claude-code-skips-suggestions">
```

</details>

<details>
<summary>managed-settings-ja.md</summary>

```diff
diff --git a/docs-ja/pages/managed-settings-ja.md b/docs-ja/pages/managed-settings-ja.md
index 3817b63..89f0621 100644
--- a/docs-ja/pages/managed-settings-ja.md
+++ b/docs-ja/pages/managed-settings-ja.md
@@ -96,5 +96,5 @@ Jamf、Iru、Intune、グループポリシーのスターターテンプレー
   * **リモート Cowork セッション**: これらは Anthropic 管理 VM 上で実行され、Claude Code はデバイスポリシーを読み取ることができません。
 
-  [サーフェスカバレッジ](/docs/ja/model-config#surface-coverage) テーブルは Cowork と他のサーフェスを比較しています。
+  セッションが実行される場所に関係なく、claude.ai は管理コンソールの [`strictKnownMarketplaces`](/docs/ja/settings-reference#strictknownmarketplaces) および [`blockedMarketplaces`](/docs/ja/settings-reference#blockedmarketplaces) リストを、誰かが claude.ai 上の git リポジトリからマーケットプレイスを追加するか、Cowork タブの **Customize** から追加する場合に自動的に適用します。[制限がどのように機能するか](/docs/ja/plugin-marketplaces#how-restrictions-work) はそのチェックについて説明しています。[サーフェスカバレッジ](/docs/ja/model-config#surface-coverage) テーブルは Cowork と他のサーフェスを比較しています。
 * **実行中のセッション**: ほとんどの変更は、[配信メカニズムテーブル](#choose-a-delivery-mechanism) のスケジュールに従って、再起動なしで実行中のセッションに到達します。
   * [`forceRemoteSettingsRefresh`](/docs/ja/settings-reference#forceremotesettingsrefresh)、[`requiredMinimumVersion`](/docs/ja/settings-reference#requiredminimumversion)、および [いくつかのユーザー編集可能キー](/docs/ja/settings#when-edits-take-effect) への変更は、次のセッション開始時に有効になります。
```

</details>

<details>
<summary>memory-ja.md</summary>

```diff
diff --git a/docs-ja/pages/memory-ja.md b/docs-ja/pages/memory-ja.md
index 593320a..fbff3ad 100644
--- a/docs-ja/pages/memory-ja.md
+++ b/docs-ja/pages/memory-ja.md
@@ -380,5 +380,5 @@ Claude Code は [`AGENTS.md`](/docs/ja/glossary#agents-md) をプロジェクト
 
 <Note>
-  `AGENTS.md` を直接読み込むには Claude Code v2.1.277 以降が必要です。Amazon Bedrock 上のセッションやテレメトリが無効になっているセッションなど、一部のセッションでは Claude が [`AGENTS.md` を読み込むことができない](#when-agents-md-support-is-unavailable) ため、代わりに [`CLAUDE.md` からインポート](#share-one-file-with-other-coding-tools) してください。
+  `AGENTS.md` を直接読み込むには Claude Code v2.1.277 以降が必要です。一部のセッションでは Claude が [`AGENTS.md` を読み込むことができない](#when-agents-md-support-is-unavailable) ため、代わりに [`CLAUDE.md` からインポート](#share-one-file-with-other-coding-tools) してください。
 </Note>
 
@@ -437,9 +437,8 @@ Claude が読み込むファイルを変更するには、Claude Code セッシ
 
 * Claude Code v2.1.277 より前のバージョンを使用している
-* セッション が Anthropic から [フィーチャーフラグをフェッチしない](/docs/ja/env-vars#features-that-need-feature-flag-fetching)（例えば Amazon Bedrock または別のサードパーティプロバイダーを使用している、またはテレメトリを無効にしている）。リンク先のセクションに完全なリストがあります
-* `AGENTS.md` サポート付きのバージョンに [インストールまたはアップグレード](/docs/ja/env-vars#first-session-after-an-install-or-upgrade) した後の最初のセッションです。次のセッションから Claude は `AGENTS.md` を読み込みます
 * 組み込み `agents-md` プラグインを `/plugin` で無効にしました
+* 一部の場合、v2.1.276 以前から [アップグレード](/docs/ja/env-vars#first-session-after-an-install-or-upgrade) した後の最初のセッションです。次のセッションから Claude は `AGENTS.md` を読み込みます
 
-これらのセッションで Claude に `AGENTS.md` を提供するには、[`CLAUDE.md` からインポート](#share-one-file-with-other-coding-tools) してください。
+v2.1.281 より前では、Amazon Bedrock 上のセッションやテレメトリが無効になっているセッションなど、一部のセッションは `CLAUDE.md` ファイルのみを読み込みます。これらのバージョンでは Claude Code を更新してください。これらのセッションのいずれかで Claude に `AGENTS.md` を提供するには、[`CLAUDE.md` からインポート](#share-one-file-with-other-coding-tools) してください。
 
 <h3 id="where-agents-md-differs-from-claude-md">
@@ -638,7 +637,6 @@ CLAUDE.md のコンテンツは、システムプロンプト自体の一部で
 
 1. 作業ディレクトリまたはそれより上のディレクトリ（`~/.claude/CLAUDE.md` を除く）で `CLAUDE.md`、`.claude/CLAUDE.md`、または `CLAUDE.local.md` を探します。見つかった場合、**Project instructions** を `claude-md-and-agents-md` に設定しない限り、Claude はそれを `AGENTS.md` の代わりに読み込みます。
-2. `claude --version` を実行し、v2.1.277 以降であることを確認します。
-3. セッションが [AGENTS.md を読み込むことができない](#when-agents-md-support-is-unavailable) セッション（サードパーティプロバイダーのセッションやテレメトリが無効なセッションなど）であるかどうかを確認します。
-4. セッションで `/config` を入力して設定パネルを開き、**Project instructions** が `claude-md` または `managed-only` に設定されていないことを確認します。そこに設定が表示されない場合、セッションは [AGENTS.md を読み込むことができない](#when-agents-md-support-is-unavailable) セッションです。
+2. `claude --version` を実行し、v2.1.277 以降であることを確認します。v2.1.281 より前では、Amazon Bedrock 上のセッションやテレメトリが無効なセッションなど、一部のセッションは [AGENTS.md を読み込むことができない](#when-agents-md-support-is-unavailable) ため、これらのバージョンでは v2.1.281 以降に更新してください。
```

</details>

*...以降省略*

</details>


<details>
<summary>2026-09-24</summary>

**変更ファイル:**

```
 docs-ja/pages/artifacts-ja.md              |  22 ++--
 docs-ja/pages/changelog.md                 | 179 +++++++++++++++++++++++++++++
 docs-ja/pages/claude-code-on-the-web-ja.md |   2 +-
 docs-ja/pages/cloud-environments-ja.md     |   2 +-
 docs-ja/pages/env-vars-ja.md               |   9 +-
 docs-ja/pages/feature-availability-ja.md   |   1 -
 docs-ja/pages/glossary-ja.md               |   2 +-
 docs-ja/pages/mcp-ja.md                    |   4 +-
 docs-ja/pages/monitoring-usage-ja.md       |   5 +
 docs-ja/pages/plugin-marketplaces-ja.md    |  38 ++----
 docs-ja/pages/plugins-ja.md                |   2 +
 docs-ja/pages/skills-ja.md                 |  10 ++
 docs-ja/pages/ultrareview-ja.md            |  22 ++--
 docs-ja/pages/voice-dictation-ja.md        |  14 ++-
 docs-ja/pages/vs-code-ja.md                |  27 ++++-
 docs-ja/pages/web-quickstart-ja.md         |   2 +-
 16 files changed, 284 insertions(+), 57 deletions(-)
```

<!-- UPDATE_LOG_END -->
