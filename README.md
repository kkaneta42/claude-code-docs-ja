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
<summary>2026-09-12</summary>

**変更ファイル:**

```
 docs-ja/pages/admin-setup-ja.md                    |   65 +-
 docs-ja/pages/advisor-ja.md                        |   35 +-
 docs-ja/pages/agent-teams-ja.md                    |   41 +-
 docs-ja/pages/agents-ja.md                         |    2 +-
 docs-ja/pages/amazon-bedrock-ja.md                 |   25 +-
 docs-ja/pages/analytics-ja.md                      |    6 -
 docs-ja/pages/authentication-ja.md                 |    6 +-
 docs-ja/pages/auto-mode-config-ja.md               |   12 +-
 docs-ja/pages/changelog.md                         |  101 +
 docs-ja/pages/channels-ja.md                       |    4 +-
 docs-ja/pages/channels-reference-ja.md             |    2 +-
 docs-ja/pages/checkpointing-ja.md                  |   14 +-
 docs-ja/pages/claude-apps-gateway-deploy-ja.md     |   91 +-
 docs-ja/pages/claude-apps-gateway-ja.md            |    9 +-
 docs-ja/pages/claude-apps-gateway-on-aws-ja.md     |    6 +-
 docs-ja/pages/claude-directory-ja.md               |    4 +-
 docs-ja/pages/claude-security-ja.md                |    6 +-
 docs-ja/pages/cli-reference-ja.md                  |  260 +-
 docs-ja/pages/cloud-environments-ja.md             |   90 +-
 docs-ja/pages/commands-ja.md                       |   12 +-
 docs-ja/pages/context-window-ja.md                 |    4 +-
 docs-ja/pages/corporate-launcher-ja.md             |    2 +-
 docs-ja/pages/debug-your-config-ja.md              |   42 +-
 docs-ja/pages/desktop-ja.md                        |   21 +-
 docs-ja/pages/desktop-quickstart-ja.md             |   14 +-
 docs-ja/pages/desktop-scheduled-tasks-ja.md        |   28 +-
 docs-ja/pages/discover-plugins-ja.md               |   21 +-
 docs-ja/pages/env-vars-ja.md                       |  780 ++-
 docs-ja/pages/errors-ja.md                         |  441 +-
 docs-ja/pages/feature-availability-ja.md           |    2 +-
 docs-ja/pages/fullscreen-ja.md                     |    6 +-
 docs-ja/pages/glossary-ja.md                       |   38 +-
 docs-ja/pages/headless-ja.md                       |   15 +-
 docs-ja/pages/hooks-guide-ja.md                    |   79 +-
 docs-ja/pages/interactive-mode-ja.md               |    4 +-
 docs-ja/pages/keybindings-ja.md                    |    6 +-
 docs-ja/pages/large-codebases-ja.md                |   18 +-
 docs-ja/pages/llm-gateway-protocol-ja.md           |   15 +-
 docs-ja/pages/managed-settings-ja.md               |    8 +-
 docs-ja/pages/mcp-ja.md                            |  948 ++-
 docs-ja/pages/network-config-ja.md                 |    1 +
 docs-ja/pages/overview-ja.md                       |   26 +-
 docs-ja/pages/permission-modes-ja.md               |  250 +-
 docs-ja/pages/platforms-ja.md                      |   20 +-
 docs-ja/pages/plugin-dependencies-ja.md            |    2 +
 docs-ja/pages/plugin-hints-ja.md                   |   14 +-
 docs-ja/pages/plugins-ja.md                        |  108 +-
 docs-ja/pages/plugins-reference-ja.md              |  268 +-
 docs-ja/pages/quickstart-ja.md                     |   26 +-
 docs-ja/pages/remote-control-ja.md                 |  255 +-
 docs-ja/pages/sandbox-environments-ja.md           |    2 +-
 docs-ja/pages/sandboxing-ja.md                     |    6 +
 docs-ja/pages/scheduled-tasks-ja.md                |   30 +-
 docs-ja/pages/security-guidance-ja.md              |    6 +-
 .../self-hosted-environments-configuration-ja.md   |  106 +-
 .../pages/self-hosted-environments-deploy-ja.md    |  543 +-
 docs-ja/pages/server-managed-settings-ja.md        |  248 +-
 docs-ja/pages/sessions-ja.md                       |    6 +-
 docs-ja/pages/settings-example-ja.md               |   25 +-
 docs-ja/pages/settings-ja.md                       |    2 +-
 docs-ja/pages/settings-reference-ja.md             | 6510 +++++++++++++++++++-
 docs-ja/pages/setup-ja.md                          |   28 +-
 docs-ja/pages/terminal-config-ja.md                |   18 +-
 docs-ja/pages/third-party-integrations-ja.md       |    7 +-
 docs-ja/pages/tools-reference-ja.md                |   47 +-
 docs-ja/pages/troubleshooting-ja.md                |   13 +
 docs-ja/pages/vs-code-ja.md                        |   53 +-
 docs-ja/pages/web-quickstart-ja.md                 |   74 +-
 docs-ja/pages/workflows-ja.md                      |  166 +-
 69 files changed, 10306 insertions(+), 1837 deletions(-)
```

**新規追加:**


<details>
<summary>admin-setup-ja.md</summary>

```diff
diff --git a/docs-ja/pages/admin-setup-ja.md b/docs-ja/pages/admin-setup-ja.md
index 994e983..ccaada5 100644
--- a/docs-ja/pages/admin-setup-ja.md
+++ b/docs-ja/pages/admin-setup-ja.md
@@ -91,35 +91,42 @@ WSL 2 ユーティリティ VM 内のプロセスは、Windows 側のエンド
 
 <h2 id="decide-what-to-enforce">
-  実行する内容を決定する
+  実装する内容を決定する
 </h2>
 
-マネージド設定は、ツール、サンドボックス実行、MCP サーバーとプラグインソースへのアクセスをロックダウンし、実行されるフックを制御できます。各行は、それを駆動する設定キーを持つ制御サーフェスです。
-
-| 制御                                                                                     | 機能                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                | キー設定                                                                                                                                |
-| :------------------------------------------------------------------------------------- | :---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :---------------------------------------------------------------------------------------------------------------------------------- |
-| [Permission rules](/docs/ja/permissions)                                                    | 特定のツールとコマンドを許可、確認、または拒否する                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         | `permissions.allow`、`permissions.deny`                                                                                              |
-| [Permission lockdown](/docs/ja/permissions#managed-only-settings)                           | マネージド設定を [permission ルールの唯一の設定ソース](/docs/ja/settings-reference#allowmanagedpermissionrulesonly) にする。`--dangerously-skip-permissions` を無効化する                                                                                                                                                                                                                                                                                                                                                                            | `allowManagedPermissionRulesOnly`、`permissions.disableBypassPermissionsMode`                                                        |
-| [Starting permission mode](/docs/ja/permission-modes#which-mode-a-session-starts-in)        | 開発者のターミナルセッションが開始する権限モードを選択するか、組み込みの開始権限モードの代わりに自動モードを削除する。VS Code 拡張機能は、Pro、Max、Team プランでのみ設定した `defaultMode` を読み取ります。[Switch permission modes](/docs/ja/permission-modes#switch-permission-modes) は拡張機能が読み取る内容をリストします                                                                                                                                                                                                                                                                                                | `permissions.defaultMode`、`permissions.disableAutoMode`                                                                             |
-| [Sandboxing](/docs/ja/sandboxing)                                                           | ドメイン許可リスト付きの OS レベルのファイルシステムとネットワーク分離                                                                                                                                                                                                                                                                                                                                                                                                                                                                             | `sandbox.enabled`、`sandbox.network.allowedDomains`                                                                                  |
-| [Managed policy CLAUDE.md](/docs/ja/memory#deploy-organization-wide-claude-md)              | すべてのセッションで読み込まれる組織全体の指示。除外できない                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | マネージドポリシーパスのファイル                                                                                                                    |
-| [MCP server control](/docs/ja/managed-mcp)                                                  | ユーザーが追加または接続できる MCP サーバーを制限するか、固定セットをデプロイするか、すべてのユーザーに独自のサーバーと一緒にリモートサーバーを提供する                                                                                                                                                                                                                                                                                                                                                                                                                                    | `allowedMcpServers`、`deniedMcpServers`、`allowManagedMcpServersOnly`、`managedMcpServers`、またはデプロイされた `managed-mcp.json` ファイル          |
-| [Plugin marketplace control](/docs/ja/plugin-marketplaces#managed-marketplace-restrictions) | ユーザーが追加およびインストールできるマーケットプレイスソースを制限し、単一実行のためにプラグイン、エージェント、MCP サーバーをサイドロードする CLI フラグを拒否し、[`command` プラグインソース](/docs/ja/plugin-marketplaces#command-sources) をブロックし、どのマーケットプレイスのプラグインが提案されるかをホワイトリストに登録する                                                                                                                                                                                                                                                                                                                 | `strictKnownMarketplaces`、`blockedMarketplaces`、`disableSideloadFlags`、`disableCommandPluginSources`、`pluginSuggestionMarketplaces` |
-| [Customization lockdown](/docs/ja/settings-reference#strictpluginonlycustomization)         | スキル、エージェント、フック、および MCP サーバーをユーザーおよびプロジェクトソースからブロックし、プラグインまたはマネージド設定からのみ取得できるようにする                                                                                                                                                                                                                                                                                                                                                                                                                                 | `strictPluginOnlyCustomization`                                                                                                     |
-| [Hook restrictions](/docs/ja/settings-reference#allowmanagedhooksonly)                      | 実行されるフックを制限し、HTTP フック URL を制限する。[`allowManagedHooksOnly` の下で実行される内容](/docs/ja/settings-reference#what-runs-under-allowmanagedhooksonly) を参照して、完全な効果リストを確認してください                                                                                                                                                                                                                                                                                                                                                        | `allowManagedHooksOnly`、`allowedHttpHookUrls`                                                                                       |
-| [Login enforcement](/docs/ja/settings-reference#forceloginmethod)                           | ログインを特定の方法または Anthropic 組織に制限する。メソッド制限は VS Code 拡張機能、Agent SDK、`claude setup-token`、`/install-github-app` 全体に適用され、ターミナルのインタラクティブログイン画面は `/login` または初回オンボーディングで到達し、メソッドを強制せずに事前選択します。Claude Code は、ターミナル、VS Code 拡張機能、Agent SDK での claude.ai アカウントログインの組織を検証し、Claude Console ログインまたは [gateway](/docs/ja/claude-apps-gateway) サインインではチェックしません。v2.1.212 より前は、ターミナルログインのみが両方のキーを適用していました。設定されている場合、`ANTHROPIC_API_KEY`、`ANTHROPIC_AUTH_TOKEN`、または `apiKeyHelper` によって認証されたセッションはスタートアップでブロックされます。クラウドプロバイダーセッションは影響を受けません | `forceLoginMethod`、`forceLoginOrgUUID`                                                                                              |
-| [Disable agent view](/docs/ja/agent-view#how-background-sessions-are-hosted)                | `claude agents`、`--bg`、`/background`、およびオンデマンドスーパーバイザーをオフにする                                                                                                                                                                                                                                                                                                                                                                                                                                                      | `disableAgentView`                                                                                                                  |
-| [Configure the corporate launcher](/docs/ja/corporate-launcher)                             | [バックグラウンドエージェントスーパーバイザー](/docs/ja/agent-view#how-background-sessions-are-hosted)、そのワーカー、および [その他のカバーされたバックグラウンドプロセス](/docs/ja/corporate-launcher#what-the-launcher-covers) に、エージェントビューをオフにする代わりに、必須の企業ランチャーをプレフィックスする                                                                                                                                                                                                                                                                                                       | `processWrapper`                                                                                                                    |
-| [Model restrictions](/docs/ja/model-config#restrict-model-selection)                        | `availableModels` はピッカーに表示されるモデルをフィルタリングします。`enforceAvailableModels` を追加すると、自動選択されるデフォルトモデルも制限されます。この設定が CLI、ウェブ、IDE にどのように到達するかについては、[surface coverage](/docs/ja/model-config#surface-coverage) を参照してください                                                                                                                                                                                                                                                                                                             | `availableModels`、`enforceAvailableModels`                                                                                          |
-| [Version floor](/docs/ja/settings-reference#minimumversion)                                 | 自動更新が組織全体の最小値より下にインストールされるのを防ぐ                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | `minimumVersion`                                                                                                                    |
-| [Required version range](/docs/ja/settings-reference#requiredminimumversion)                | 実行中のバージョンが組織承認の範囲外の場合、まったく起動を拒否する。`minimumVersion` より強力で、ダウングレードのみをブロックする                                                                                                                                                                                                                                                                                                                                                                                                                                         | `requiredMinimumVersion`、`requiredMaximumVersion`                                                                                   |
```

</details>

<details>
<summary>advisor-ja.md</summary>

```diff
diff --git a/docs-ja/pages/advisor-ja.md b/docs-ja/pages/advisor-ja.md
index 949378a..a54c0df 100644
--- a/docs-ja/pages/advisor-ja.md
+++ b/docs-ja/pages/advisor-ja.md
@@ -49,5 +49,11 @@ advisor モデルは 3 つの方法で設定できます。
 ```
 
-コマンドは `Advisor set to` で確認し、その後に advisor モデル名が続きます。選択はユーザー設定の `advisorModel` に保存され、セッション全体で保持されます。
+コマンドは `Advisor set to` で確認し、その後に advisor モデル名が続きます。選択はユーザー設定の `advisorModel` に保存され、セッション全体で保持されます。ただし、[`advisorModel` エントリ](/docs/ja/settings-reference#advisormodel)が現在のセッションにのみ適用されるとリストしている場合は除きます。
+
+このコマンドは、ターミナルピッカーがない場所でも機能します。[非対話型モード](/docs/ja/headless)で `-p` を使用する場合、Agent SDK 内、デスクトップアプリ内、および[リモートコントロール](/docs/ja/remote-control)経由です。これには Claude Code v2.1.260 以降が必要です。これらのサーフェスでは、
+
+* 引数なしで `/advisor` を実行して、現在の advisor モデルとそれが受け入れるエイリアスを出力します。
+* `/advisor opus` などのモデルを使用して `/advisor` を実行して、それを設定します。
+* `/advisor off` を実行してそれをオフにします。
 
 Claude Code は、組織の [`availableModels`](/docs/ja/model-config#restrict-model-selection)許可リストが除外した保存済み advisor を呼び出しません。advisor を使用するには、`/advisor` で許可されたモデルを選択してください。Claude Code は、現在のメインモデルがサポートしていない advisor を引き続き保存します。その advisor は、[`/model`](/docs/ja/model-config#setting-your-model)で[互換性のあるメインモデル](#choose-an-advisor-model)に切り替えた後にアクティブになります。
@@ -92,14 +98,14 @@ Claude Code はそのセッションの `advisorModel` 設定の代わりにフ
 advisor はメインモデル以上の機能を持つ必要があります。各メインモデルで受け入れられる advisor は次のとおりです。
 
-| メインモデル                | 受け入れられる advisor             | 注記                                                                                                                    |
-| --------------------- | --------------------------- | --------------------------------------------------------------------------------------------------------------------- |
-| Haiku 4.5             | Fable、Opus、Sonnet           | Haiku は advisor を呼び出すことはできますが、advisor として機能することはできません                                                                 |
-| Sonnet 4.6            | Fable、Opus、Sonnet           |                                                                                                                       |
-| Sonnet 5              | Fable、Opus、Sonnet 5         | Sonnet 4.6 advisor は拒否されます                                                                                            |
-| Opus 4.6              | Fable、Opus、Sonnet 5         | Sonnet 5 と Opus 4.6 は同等の機能として評価されるため、Opus 4.6 メインは Sonnet 5 advisor を受け入れます                                           |
-| Opus 4.7 以降           | Fable、Opus 4.7 以降           | Opus 4.7 以降の Opus モデルは同等の機能として評価されるため、どれでも他方を advisor として受け入れます。Opus 4.6 または Sonnet 5 advisor を持つ Opus 4.7 メインは拒否されます |
-| Fable 5.1 または Fable 5 | Fable 5.1、または同じ Fable バージョン | Opus または Sonnet advisor は拒否され、Fable 5.1 メインモデルの Fable 5 advisor も拒否されます                                               |
+| メインモデル                | 受け入れられる advisor       | 注記                                                                                                                    |
+| --------------------- | --------------------- | --------------------------------------------------------------------------------------------------------------------- |
```

</details>

<details>
<summary>agent-teams-ja.md</summary>

```diff
diff --git a/docs-ja/pages/agent-teams-ja.md b/docs-ja/pages/agent-teams-ja.md
index 1f6564f..1d7598d 100644
--- a/docs-ja/pages/agent-teams-ja.md
+++ b/docs-ja/pages/agent-teams-ja.md
@@ -121,5 +121,5 @@ v2.1.199 以降、アイドル状態のチームメンバーの行は、他の
 </Note>
 
-デフォルトは `"in-process"` です。v2.1.179 より前は、デフォルトは `"auto"` でした。そのため、以前に分割ペインを開いたアップグレードされたセッションは、モードを明示的に設定しない限り、1 つのターミナルに留まります。`"auto"` を設定して、既に tmux セッション内で実行している場合または使用しているターミナルが iTerm2 の場合は分割ペインを有効にし、それ以外の場合は in-process にフォールバックします。`"tmux"` 設定は分割ペインモードを有効にし、ターミナルに基づいて tmux または iTerm2 を使用するかどうかを自動検出します。
+デフォルトは `"in-process"` です。v2.1.179 より前は、デフォルトは `"auto"` でした。そのため、以前に分割ペインを開いたアップグレードされたセッションは、モードを明示的に設定しない限り、1 つのターミナルに留まります。`"auto"` を設定して、既に tmux セッション内で実行している場合または使用しているターミナルが iTerm2 で `it2` CLI がインストールされている場合は分割ペインを有効にし、それ以外の場合は in-process にフォールバックします。`"tmux"` 設定は分割ペインモードを有効にし、ターミナルに基づいて tmux または iTerm2 を使用するかどうかを自動検出します。
 
 v2.1.186 以降、`"iterm2"` を設定して iTerm2 ネイティブ分割ペインを明示的に使用してください。このモードは [`it2` CLI](https://github.com/mkusaka/it2) が必要で、`it2` が見つからない場合はインストールコマンド付きでエラーを表示します。`it2` をインストールするか tmux に切り替えるオプションを提供するセットアッププロンプトは、ターミナルが iTerm2 で tmux がフォールバックとして利用可能な場合、`"auto"` または `"tmux"` の下に表示されます。
@@ -164,5 +164,5 @@ Claude Code は各チームメンバーのモデルを、以下の最初に適
 4. リーダーの現在のモデル。
 
-[`CLAUDE_CODE_SUBAGENT_MODEL_FORCE`](/docs/ja/sub-agents#run-every-subagent-on-one-model) はチームメンバーとサブエージェントの両方に適用されます。
+[`CLAUDE_CODE_SUBAGENT_MODEL_FORCE=1`](/docs/ja/sub-agents#run-every-subagent-on-one-model) を設定した場合、最初の 2 つのソースは適用されません。Claude Code は `CLAUDE_CODE_SUBAGENT_MODEL` が `inherit` 以外に設定されている場合はそこからすべてのチームメンバーのモデルを選択し、それ以外の場合はリーダーの現在のモデルから選択します。Claude Code v2.1.257 以降が必要です。
 
 v2.1.251 より前は、`CLAUDE_CODE_SUBAGENT_MODEL` がこの順序で最初に来ていました。
@@ -253,7 +253,7 @@ Ask the researcher teammate to shut down
 </h3>
 
-チームを開始するには、Claude にチームメンバーをリクエストしてください。Claude は [Agent ツール](/docs/ja/tools-reference) を呼び出して [`name`](/docs/ja/sub-agents#subagent-names) を指定し、エージェントチームが有効になっている場合、Claude Code があなたに確認を求めないときにチームメンバーを起動します。Claude は通常の subagent にも独自に名前を付けるため、後でメッセージを送信でき、エージェントチームが有効になっている場合、名前付き subagent はチームメンバーとして起動するため、チームメンバーをリクエストしなくてもチームが形成される可能性があります。
+チームを開始するには、Claude にチームメンバーをリクエストしてください。Claude は [Agent ツール](/docs/ja/tools-reference) を呼び出して [`name`](/docs/ja/sub-agents#subagent-names) を指定し、エージェントチームが有効になっている場合にチームメンバーを起動します。ただし、呼び出しが [fork](/docs/ja/sub-agents#fork-the-current-conversation) であるか、呼び出し自体で `isolation` を渡す場合は除きます。Claude Code があなたに確認を求めることはありません。
 
-subagent の代わりに使用したい場合は、[エージェントチームをオフにしてください](#claude-spawns-teammates-instead-of-subagents)。
+Claude は通常の subagent にも独自に名前を付けるため、後でメッセージを送信できます。これらの呼び出しは同じルールに従うため、チームメンバーをリクエストしなくてもチームが形成される可能性があります。subagent の代わりに使用したい場合は、[エージェントチームをオフにしてください](#claude-spawns-teammates-instead-of-subagents)。
 
 <h3 id="architecture">
@@ -295,5 +295,5 @@ Claude Code はセッション起動時にこれらの両方を自動的に生
 </h3>
```

</details>

<details>
<summary>agents-ja.md</summary>

```diff
diff --git a/docs-ja/pages/agents-ja.md b/docs-ja/pages/agents-ja.md
index 25b169f..59ee566 100644
--- a/docs-ja/pages/agents-ja.md
+++ b/docs-ja/pages/agents-ja.md
@@ -20,5 +20,5 @@
 この作業をサポートする 3 つの追加ツールがありますが、エージェント自体を実行する方法ではありません。
 
-* [ワークツリー](/docs/ja/worktrees) は各セッションに個別の git チェックアウトを提供するため、並列セッションが同じファイルを編集することはありません。自分で実行するセッションに使用します。エージェントビューは、ディスパッチされた各セッションを自動的に独自のワークツリーに移動し、スポーンするサブエージェントも各々独自のワークツリーを取得できます。
+* [ワークツリー](/docs/ja/worktrees) は各セッションに個別の git チェックアウトを提供するため、並列セッションが同じファイルを編集することはありません。自分で実行するセッションに使用します。エージェントビューからディスパッチされたセッションは、[ファイルを編集する前に独自のワークツリーに移動](/docs/ja/agent-view#how-file-edits-are-isolated) し、スポーンするサブエージェントも各々独自のワークツリーを取得できます。
 * [クロスセッションメッセージング](/docs/ja/cross-session-messaging) により、Claude はこのマシン上、別のマシン上、または [Claude Code on the web](/docs/ja/claude-code-on-the-web) 上の他の Claude Code セッションをリストして、メッセージを送信できます。自分で実行するセッションは、検出結果とステータスを相互に渡すことができます。
 * [`/batch`](/docs/ja/commands) は、1 つの大きな変更を 5 ～ 30 個のワークツリー分離サブエージェントに分割し、各エージェントがプルリクエストを開く [skill](/docs/ja/skills) です。これはサブエージェントとワークツリーのパッケージ化された使用法であり、別の調整スタイルではありません。
```

</details>

<details>
<summary>amazon-bedrock-ja.md</summary>

```diff
diff --git a/docs-ja/pages/amazon-bedrock-ja.md b/docs-ja/pages/amazon-bedrock-ja.md
index a37fe98..bbb9092 100644
--- a/docs-ja/pages/amazon-bedrock-ja.md
+++ b/docs-ja/pages/amazon-bedrock-ja.md
@@ -191,4 +191,6 @@ Claude Code は AWS デフォルト認証情報プロバイダーチェーンを
 チェーンの各解決は 60 秒後にタイムアウトします。チェーン内のステップが停止した場合（例えば、受け取ることができない入力を待つ `credential_process` ヘルパー）、リクエストは [`AWS default-chain credential resolve timed out`](/docs/ja/errors#aws-default-chain-credential-resolve-timed-out) で失敗します。チェーンが正当に長い時間が必要なインタラクティブサインイン（`aws-vault` のようなラッパーを使用した MFA 付きブラウザベースの SSO など）を実行する場合、[`CLAUDE_CODE_AWS_CHAIN_RESOLVE_TIMEOUT_MS`](/docs/ja/env-vars) でミリ秒単位で制限を引き上げてください。v2.1.207 より前では、停止した認証情報解決はリクエストを無期限に待機させていました。
 
+Amazon Bedrock API キーで認証しない場合を除き、[セットアップウィザード](#sign-in-with-bedrock)は認証情報を検証する際に行う各 AWS 呼び出しに同じ制限を適用し、各モデルチェック前の認証情報ルックアップにも適用します。認証情報検証中に、制限を超えるチェックは [`Timed out after 60s waiting for AWS`](/docs/ja/errors#bedrock-setup-verification-timed-out-waiting-for-aws) で失敗します。
+
 <h4 id="advanced-credential-configuration">
   高度な認証情報設定
@@ -264,5 +266,5 @@ export ANTHROPIC_SMALL_FAST_MODEL_AWS_REGION=us-west-2
 Claude Code で Amazon Bedrock を有効にする場合、以下の点に注意してください。
 
-* v2.1.172 以降、AWS プロファイルのリージョンをオーバーライドする場合、またはプロファイルにリージョンがない場合にのみ `AWS_REGION` を設定する必要があります。Claude Code はこの順序でリージョンを解決します。
+* `AWS_REGION` を設定する必要があるのは、AWS プロファイルのリージョンをオーバーライドする場合、またはプロファイルにリージョンがない場合のみです。Claude Code はこの順序でリージョンを解決します。
 
   * `AWS_REGION`
@@ -275,5 +277,5 @@ Claude Code で Amazon Bedrock を有効にする場合、以下の点に注意
   アクティブなプロファイルは、設定されている場合は `AWS_PROFILE`、そうでない場合は `default` です。`AWS_SHARED_CREDENTIALS_FILE` または `AWS_CONFIG_FILE` を設定して、デフォルト以外のファイルパスを指定してください。
 
-  `/status` を実行して、解決されたリージョンを確認してください。リージョンが AWS 設定ファイルまたはデフォルトフォールバックから来た場合、Claude Code は `/status` 出力でソースも記載します。v2.1.171 以前では、Claude Code は AWS 設定ファイルを読み込まないため、`AWS_REGION` を明示的に設定してください。
+  `/status` を実行して、解決されたリージョンを確認してください。リージョンが AWS 設定ファイルまたはデフォルトフォールバックから来た場合、Claude Code は `/status` 出力でソースも記載します。
 * Amazon Bedrock を使用する場合、認証は AWS 認証情報を通じて処理されるため、`/logout` コマンドは利用できません。
 * WebSearch ツールは Amazon Bedrock では利用できません。[WebSearch ツールの動作](/docs/ja/tools-reference#websearch-tool-behavior)を参照してください。
@@ -531,5 +533,5 @@ export AWS_REGION=us-east-1
 ```
 
-Claude Code は AWS リージョンからエンドポイント URL を構築します。v2.1.172 以降では、リージョンは [上記の Amazon Bedrock](#3-configure-claude-code) と同じ優先順位で解決されます。以前のバージョンは `AWS_REGION` のみを使用します。カスタムエンドポイントまたはゲートウェイの URL をオーバーライドするには、`ANTHROPIC_BEDROCK_MANTLE_BASE_URL` を設定します。
+Claude Code は AWS リージョンからエンドポイント URL を構築します。リージョンは [上記の Amazon Bedrock](#3-configure-claude-code) と同じ優先順位で解決されます。カスタムエンドポイントまたはゲートウェイの URL をオーバーライドするには、`ANTHROPIC_BEDROCK_MANTLE_BASE_URL` を設定します。
```

</details>

<details>
<summary>analytics-ja.md</summary>

```diff
diff --git a/docs-ja/pages/analytics-ja.md b/docs-ja/pages/analytics-ja.md
index 7bf4ef0..7fd67d2 100644
--- a/docs-ja/pages/analytics-ja.md
+++ b/docs-ja/pages/analytics-ja.md
@@ -140,10 +140,4 @@ Team と Enterprise ダッシュボードには以下が含まれます。
 貢献メトリクスが有効になっている場合、Claude Code はマージされたプルリクエストを分析して、Claude Code 支援で記述されたコードを判定します。これは、Claude Code セッションアクティビティを各 PR のコードと照合することで行われます。
 
-<h4 id="tagging-criteria">
-  タグ付け基準
-</h4>
-
-PR は、Claude Code セッション中に記述された少なくとも 1 行のコードを含む場合、「with Claude Code」としてタグ付けされます。システムは保守的なマッチングを使用します。Claude Code の関与に高い信頼度がある場合のみ、支援されたコードとしてカウントされます。
-
 <h4 id="attribution-process">
   属性プロセス
```

</details>

<details>
<summary>authentication-ja.md</summary>

```diff
diff --git a/docs-ja/pages/authentication-ja.md b/docs-ja/pages/authentication-ja.md
index e5067b8..ad06674 100644
--- a/docs-ja/pages/authentication-ja.md
+++ b/docs-ja/pages/authentication-ja.md
@@ -236,5 +236,9 @@ Claude Code は認証情報を安全に管理します。
 署名済みの [Claude apps gateway](/docs/ja/claude-apps-gateway) セッションはこのリストの外に位置します。これは Amazon Bedrock または Google Cloud の Agent Platform のようなプロバイダー選択であり、それらより優先されます。ゲートウェイセッションが存在する場合、CLI は `CLAUDE_CODE_USE_BEDROCK`、`CLAUDE_CODE_USE_VERTEX`、または `CLAUDE_CODE_USE_FOUNDRY` が設定されていても、ゲートウェイトークンで認証され、ベアラートークン、API キー、`apiKeyHelper`、およびプロファイルなどの上記の認証情報ソースは使用されません。
 
-アクティブな Claude サブスクリプションがあり、環境に `ANTHROPIC_API_KEY` も設定されている場合、API キーは承認されると優先されます。キーが無効または期限切れの組織に属している場合、これは認証エラーを引き起こす可能性があります。`unset ANTHROPIC_API_KEY` を実行してサブスクリプションにフォールバックし、`/status` をチェックしてどの方法がアクティブであるかを確認します。`Login method` 行はサブスクリプションアカウントを表示し、API キーが使用中の場合は `API key` 行が表示されます。
+マシンの [管理設定](/docs/ja/managed-settings)が [`forceLoginMethod`](/docs/ja/settings-reference#forceloginmethod) を `"gateway"` に設定するか、[`forceLoginGatewayUrl`](/docs/ja/settings-reference#forcelogingatewayurl) を設定し、`CLAUDE_CODE_USE_BEDROCK` または `CLAUDE_CODE_USE_VERTEX` などの変数を通じてクラウドプロバイダーを選択しない場合、セッションはゲートウェイサインインのみを使用します。Claude Code は他の認証情報ソースをスキップし、`/login` でサインインするよう求めます。残りの各認証情報で表示される内容については、[Administrator policy requires a Cloud gateway sign-in](/docs/ja/errors#administrator-policy-requires-a-cloud-gateway-sign-in) を参照してください。v2.1.261 より前、またはゲートウェイサインインのみを設定するマシンの v2.1.265 より前では、Claude Code はこれらのマシンで残りの保存されたログインを使用していました。
+
+アクティブな Claude サブスクリプションがあり、環境に `ANTHROPIC_API_KEY` も設定されている場合、API キーは承認されると優先されます。キーが無効または期限切れの組織に属している場合、これは認証エラーを引き起こす可能性があります。
+
+`unset ANTHROPIC_API_KEY` を実行してサブスクリプションにフォールバックし、`/status` をチェックしてどの方法がアクティブであるかを確認します。ログインと API キーの両方が設定されている場合、`/status` は使用中でない認証情報をマークします。
 
 [Claude Code on the Web](/docs/ja/claude-code-on-the-web) は常にサブスクリプション認証情報を使用します。サンドボックス環境で `ANTHROPIC_API_KEY` または `ANTHROPIC_AUTH_TOKEN` を設定しても、サブスクリプション認証情報はオーバーライドされません。
```

</details>

*...以降省略*

</details>


<details>
<summary>2026-09-11</summary>

**変更ファイル:**

```
 docs-ja/pages/changelog.md                         |  99 +++++++++++++++++
 docs-ja/pages/claude-apps-gateway-ja.md            |  10 +-
 docs-ja/pages/costs-ja.md                          |  13 ++-
 docs-ja/pages/desktop-scheduled-tasks-ja.md        |  22 ++--
 docs-ja/pages/discover-plugins-ja.md               |   4 +-
 docs-ja/pages/interactive-mode-ja.md               |  39 ++++++-
 docs-ja/pages/overview-ja.md                       |  10 +-
 docs-ja/pages/permission-modes-ja.md               |  50 ++++-----
 docs-ja/pages/permissions-ja.md                    |  65 ++++++++----
 docs-ja/pages/quickstart-ja.md                     |  10 +-
 docs-ja/pages/sandbox-environments-ja.md           |  38 +++----
 docs-ja/pages/sandboxing-ja.md                     |  13 ++-
 docs-ja/pages/scheduled-tasks-ja.md                |  24 ++---
 docs-ja/pages/security-ja.md                       |   4 +-
 .../pages/self-hosted-environments-reference-ja.md |  38 ++++---
 docs-ja/pages/settings-ja.md                       |  15 +--
 docs-ja/pages/setup-ja.md                          |  12 +--
 docs-ja/pages/tools-reference-ja.md                | 118 ++++++++++-----------
 18 files changed, 375 insertions(+), 209 deletions(-)
```

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index 0b4c5e0..44dc4fd 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,103 @@
 # Changelog
 
+## 2.1.268
+
+- Added to the Claude apps gateway: with `pricing:` set in `gateway.yaml`, signed-in Claude Code clients receive the same rates through managed settings, so `/cost` and telemetry match the spend meter
+- Added a startup warning for gateways when `access_control.allow_cidrs` is empty, and a one-time warning the first time a request arrives from a public address
+- Added the `gatewayInternalNetworks` managed setting, letting administrators allow `/login` to a Claude apps gateway on their organization's own public IPv4 block
+- Added `claude self-hosted-runner --remove-session-state` (default off): delete each session's per-session directories under `<base-dir>/_sessions/` when the session ends
+- Added `configDirectory` to the output of `claude auth status --json`
+- Added `--json` to `claude plugin install`, `uninstall`, `update`, `enable` and `disable`, and `errorDetails`/`noteDetails` to each row of `claude plugin list --json`
+- Added browser-tab icons for published artifacts, chosen by Claude to match each page
+- Fixed every turn failing with HTTP 400 on third-party Anthropic-compatible endpoints (`ANTHROPIC_BASE_URL`) since 2.1.265: a regex in the Artifact tool's input schema that those endpoints reject
+- Fixed WebFetch hanging indefinitely on a server that keeps the response open without finishing; a fetch now fails after 300 seconds. Set `CLAUDE_CODE_WEBFETCH_DEADLINE_MS` to override the deadline (0 turns it off)
+- Fixed a respawned in-process teammate picking up tools or a system prompt from a same-named agent file in a folder you have not trusted
+- Fixed sustained high CPU usage: a busy loop in long-running idle sessions no longer pins a CPU core, and rapid terminal focus reports during a session recap no longer keep the CPU high
+- Fixed Claude sometimes replying "your message came through empty" after an MCP tool call
+- Fixed deny and ask permission rules on symlinked directories (`/etc`, `/tmp`, `/var` on macOS; `/bin` on Linux) not applying when a path was given by its real location, and Bash commands ignoring deny rules written on a symlinked path spelling
+- Fixed a case where a Read or Edit deny rule did not apply when an `env -C`, `eval` or similar command the permission checker cannot analyze was on the same line
+- Fixed plugin and marketplace errors showing a token or password from a git source URL
+- Fixed `/mcp` and `/plugin` server details, `claude mcp list`/`get`, and MCP login errors showing secrets resolved from `${VAR}` placeholders in MCP configs
+- Fixed prompt caching and extended thinking breaking mid-session for SDK sessions using `excludeDynamicSections`: the first message is no longer re-rendered each request
+- Fixed entitled users being told a model is restricted after restart or in the Desktop Code tab when a cached model-access denial was stale
+- Fixed a running session silently switching to the organization's default model when another Claude Code process refreshed a stale model-access entry
+- Fixed long-context 429s on Fable models showing the usage-credits consent prompt instead of the 1M-context message on Pro and Team plans
+- Fixed workload identity federation via a profile (as claude-code-action configures it): processes sharing the profile could fail mid-run with `401 … jti reused`
```

</details>

<details>
<summary>claude-apps-gateway-ja.md</summary>

```diff
diff --git a/docs-ja/pages/claude-apps-gateway-ja.md b/docs-ja/pages/claude-apps-gateway-ja.md
index 87b4f21..edb5a6f 100644
--- a/docs-ja/pages/claude-apps-gateway-ja.md
+++ b/docs-ja/pages/claude-apps-gateway-ja.md
@@ -136,5 +136,7 @@ Claude アプリゲートウェイは、開発者の Claude Code クライアン
 
     <Note>
-      Amazon Bedrock アップストリームは、`inference-profile/us.anthropic.*` ARN と基礎となる `foundation-model/anthropic.*` ARN の両方に対して `bedrock:InvokeModel` と `bedrock:InvokeModelWithResponseStream` を持つ AWS プリンシパルが必要であり、Bedrock コンソールのモデルカタログから Anthropic の一度限りのユースケースフォームが提出されています。EKS の IRSA、ECS タスクロール、または EC2 インスタンスプロファイルではなく、静的キーを使用して認証情報を提供します。[`upstreams` リファレンス](/docs/ja/claude-apps-gateway-config#upstreams)には、完全な IAM 詳細、クロスクラウド認証情報マトリックス、および他のプロバイダーの `auth` ブロックがあります。
+      Amazon Bedrock アップストリームは、`inference-profile/us.anthropic.*` ARN と基礎となる `foundation-model/anthropic.*` ARN の両方に対して `bedrock:InvokeModel` と `bedrock:InvokeModelWithResponseStream` を持つ AWS プリンシパルが必要です。また、そのアカウントについて、Bedrock コンソールのモデルカタログから Anthropic の一度限りのユースケースフォームが提出されている必要もあります。
+
+      静的キーではなく、EKS の IRSA、ECS タスクロール、または EC2 インスタンスプロファイルを使用して認証情報を提供します。[`upstreams` リファレンス](/docs/ja/claude-apps-gateway-config#upstreams)には、完全な IAM 詳細、クロスクラウド認証情報マトリックス、および他のプロバイダーの `auth` ブロックがあります。
     </Note>
   </Step>
@@ -288,5 +290,5 @@ MDM 経由またはディスク上で直接デプロイする OS ごとの[管
 ```
 
-開発者は Enter キーを押して接続します。[最初の接続 TLS フィンガープリントプロンプト](#connect-developers)は引き続き表示されます。
+開発者は Enter キーを押して接続します。[最初の接続 TLS フィンガープリントプロンプト](#connect-developers)は引き続き表示されます。ファイルがマシンに配置されると、ゲートウェイサインインを完了していない開発者は、[Administrator policy requires a Cloud gateway sign-in](/docs/ja/errors#administrator-policy-requires-a-cloud-gateway-sign-in)で説明されているメッセージの 1 つを見ます。`CLAUDE_CODE_USE_BEDROCK` などの環境変数を通じてクラウドプロバイダーを選択する開発者はゲートウェイサインインを必要としません。
 
 開発者はこれを手動で設定することはできません。ログインピッカーにはゲートウェイオプションがなく、`forceLoginGatewayUrl` は開発者独自の設定ファイルでは無視されます。URL なしの `forceLoginMethod` のみでは、開発者を「IT 管理者に連絡してください」メッセージのままにします。ログインキーは、マシンにプッシュするファイルに属し、ゲートウェイの `managed.policies[].cli` ブロックには属しません。このブロックは既に接続されているクライアントにのみ到達します。
@@ -425,8 +427,8 @@ Claude Desktop は同じブラウザ SSO ステップでゲートウェイのア
 * **モデルアクセス**：ポリシーが許可しないモデルのリクエストは 400 を返し、`/model` ピッカーはポリシーの `availableModels` 許可リストにフィルタリングされます。ポリシーで [`enforceAvailableModels: true`](/docs/ja/model-config#default-model-behavior) を設定して、Default オプションが Claude Code の組み込みデフォルトではなく `availableModels` 内のモデルに解決されるようにします。なしでは、Default は選択可能なままであり、そのモデルが許可されていない場合、リクエスト時に拒否されます。
 * **テレメトリ宛先**：`/login` を通じてサインインしたセッションでは、CLI はローカルに設定された `OTEL_EXPORTER_OTLP_ENDPOINT` に関係なく、OTLP/HTTP エクスポートをゲートウェイに送信し、ゲートウェイは [`telemetry.forward_to`](/docs/ja/claude-apps-gateway-config#telemetry) の宛先にそれらをリレーします。[Claude Desktop が起動する](#connect-claude-desktop)埋め込みセッションでは、CLI はエクスポートを設定された `OTEL_EXPORTER_OTLP_ENDPOINT` に送信します。CLI はそのエンドポイントがゲートウェイ自体を指す場合にのみ、ゲートウェイセッショントークンをそれらのエクスポートに添付します。信号に設定された宛先がない場合、ゲートウェイはそれを受け入れて破棄するため、既に Claude Code テレメトリを直接収集する場合は、コレクターを `forward_to` 宛先として追加します。
-* **認証情報**：ゲートウェイトークンはセッションの唯一の認証情報です。`ANTHROPIC_AUTH_TOKEN`、`ANTHROPIC_API_KEY`、`apiKeyHelper`、[Anthropic プロファイル](/docs/ja/authentication#anthropic-profiles-and-federation-credentials)、および以前の claude.ai ログインはサインイン中は無視されるため、開発者は最初に claude.ai からログアウトする必要はありません。
+* **認証情報**：ゲートウェイトークンはセッションの唯一の認証情報です。[Anthropic プロファイル](/docs/ja/authentication#anthropic-profiles-and-federation-credentials)および以前の claude.ai ログインはサインイン中は無視されるため、開発者は最初に claude.ai からログアウトする必要はありません。設定された `ANTHROPIC_API_KEY`、`ANTHROPIC_AUTH_TOKEN`、または `apiKeyHelper` 認証情報については、[Administrator policy requires a Cloud gateway sign-in](/docs/ja/errors#administrator-policy-requires-a-cloud-gateway-sign-in)を参照してください。
 * **管理設定**：ロックされたキーはローカルでオーバーライドできません。CLI はポリシーを起動時に適用し、[次の起動時にのみ適用される変更](/docs/ja/server-managed-settings#fetch-and-caching-behavior)を除いて、毎時間のポーリングで変更を適用します。
 * **ゲートウェイが到達不可能な状態での起動**：サインイン済みセッションは、設定なしで起動するのではなく、約 10 秒後に起動時にエラーで終了します。
-* **ゲートウェイがセッションを終了した後の起動**：[起動時の失敗クローズを強制する](/docs/ja/server-managed-settings#enforce-fail-closed-startup)を参照して、どの起動がゲートウェイから署名なしで開き、どの起動がゲートウェイが `401` で応答するときに終了するかを確認します。
+* **ゲートウェイがセッションを終了した後の起動**：[起動時の失敗クローズを強制する](/docs/ja/server-managed-settings#enforce-fail-closed-startup)を参照して、どの起動がゲートウェイからサインアウトした状態で開き、どの起動がゲートウェイが `401` で応答するときに終了するかを確認します。
 * **プロビジョニング解除**：ユーザーが IdP で無効化されたセッションは、次の更新が失敗したときに `ttl_hours` 内に期限切れになります。
```

</details>

<details>
<summary>costs-ja.md</summary>

```diff
diff --git a/docs-ja/pages/costs-ja.md b/docs-ja/pages/costs-ja.md
index d4703c0..fb8b62e 100644
--- a/docs-ja/pages/costs-ja.md
+++ b/docs-ja/pages/costs-ja.md
@@ -111,10 +111,9 @@ Claude Code は最新のレポートを `~/.claude/usage-data/report.html` に
 セルフサービス Enterprise 組織、Enterprise トライアル、および AWS Marketplace を通じて請求される Enterprise 組織では、コマンドには Claude Code v2.1.248 以降が必要です。以前のバージョンは [`Unknown command: /usage-credits`](/docs/ja/errors#unknown-command) で拒否します。開かれるものはロールによって異なります。
 
-| ロール                                                                             | `/usage-credits` の動作                                                                                                                                        |
-| :------------------------------------------------------------------------------ | :---------------------------------------------------------------------------------------------------------------------------------------------------------- |
-| Pro または Max サブスクライバー                                                            | ブラウザで [**Settings > Usage**](https://claude.ai/settings/usage) を claude.ai で開きます。**Usage credits** セクションで、使用量クレジットをオンまたはオフにし、クレジット残高、今月の支出、および月間支出制限を確認できます |
-| 請求アクセス権を持つ Team または Enterprise メンバー                                             | 組織の使用量設定 [**Admin settings > Usage**](https://claude.ai/admin-settings/usage) をブラウザで開きます                                                                    |
-| 請求アクセス権を持たない Team または Enterprise メンバー                                           |                                                                                                                                                             |
-| 確認を求めてから、組織の管理者にリクエストを送信します。v2.1.211 より前では、Claude Code は確認ステップなしでリクエストを送信していました |                                                                                                                                                             |
+| ロール                                   | `/usage-credits` の動作                                                                                                                                        |
+| :------------------------------------ | :---------------------------------------------------------------------------------------------------------------------------------------------------------- |
+| Pro または Max サブスクライバー                  | ブラウザで [**Settings > Usage**](https://claude.ai/settings/usage) を claude.ai で開きます。**Usage credits** セクションで、使用量クレジットをオンまたはオフにし、クレジット残高、今月の支出、および月間支出制限を確認できます |
+| 請求アクセス権を持つ Team または Enterprise メンバー   | 組織の使用量設定 [**Admin settings > Usage**](https://claude.ai/admin-settings/usage) をブラウザで開きます                                                                    |
+| 請求アクセス権を持たない Team または Enterprise メンバー | 確認を求めてから、組織の管理者にリクエストを送信します。v2.1.211 より前では、Claude Code は確認ステップなしでリクエストを送信していました                                                                             |
 
 請求アクセス権を持たない Team および Enterprise メンバーの場合、確認はインタラクティブセッションでのみ表示されます。`-p` フラグを使用した非インタラクティブモードおよび [Remote Control](/docs/ja/remote-control) からは、コマンドはリクエストを送信せず、インタラクティブセッションで実行するよう指示します。
@@ -362,5 +361,5 @@ MCP ツール定義は [デフォルトで遅延](/docs/ja/mcp#scale-with-mcp-to
 </h3>
 
-拡張思考はデフォルトで有効になっています。これは複雑な計画と推論タスクのパフォーマンスを大幅に向上させるためです。思考トークンは出力トークンとして課金され、デフォルト予算はモデルに応じて数万トークンになる場合があります。深い推論が必要ない単純なタスクの場合、`/effort` で [努力レベル](/docs/ja/model-config#adjust-effort-level) を低下させるか、`/model` で、または `/config` で思考を無効にすることでコストを削減できます。[固定思考予算](/docs/ja/model-config#adaptive-reasoning-and-fixed-thinking-budgets) を持つモデルでは、`MAX_THINKING_TOKENS=8000` などの `MAX_THINKING_TOKENS` [環境変数](/docs/ja/env-vars) を設定して予算を低下させることもできます。適応推論モデルはゼロ以外の予算を無視するため、代わりに努力レベルを使用します。
+拡張思考はデフォルトで有効になっています。これは複雑な計画と推論タスクのパフォーマンスを大幅に向上させるためです。思考トークンは出力トークンとして課金され、デフォルト予算はモデルに応じて数万トークンになる場合があります。深い推論が必要ない単純なタスクの場合、`/effort` または `/model` で [努力レベル](/docs/ja/model-config#adjust-effort-level) を低下させるか、`/config` で思考を無効にすることでコストを削減できます。Fable モデルは常に拡張思考を使用するため、思考をオフにすることはできません。[固定思考予算](/docs/ja/model-config#adaptive-reasoning-and-fixed-thinking-budgets) を持つモデルでは、`MAX_THINKING_TOKENS=8000` などの `MAX_THINKING_TOKENS` [環境変数](/docs/ja/env-vars) を設定して予算を低下させることもできます。適応推論モデルはゼロ以外の予算を無視するため、代わりに努力レベルを使用します。
 
 <h3 id="delegate-verbose-operations-to-subagents">
```

</details>

<details>
<summary>desktop-scheduled-tasks-ja.md</summary>

```diff
diff --git a/docs-ja/pages/desktop-scheduled-tasks-ja.md b/docs-ja/pages/desktop-scheduled-tasks-ja.md
index 9903b6b..a8516bb 100644
--- a/docs-ja/pages/desktop-scheduled-tasks-ja.md
+++ b/docs-ja/pages/desktop-scheduled-tasks-ja.md
@@ -17,15 +17,15 @@ Desktop アプリの **Routines** ページでは、ローカルスケジュー
 Claude Code offers three ways to schedule recurring or one-off work:
 
-|                            | [Cloud](/docs/en/routines)               | [Desktop](/docs/en/desktop-scheduled-tasks) | [`/loop`](/docs/en/scheduled-tasks)      |
-| :------------------------- | :---------------------------------- | :------------------------------------- | :---------------------------------- |
-| Runs on                    | Cloud, Anthropic-managed by default | Your machine                           | Your machine                        |
-| Requires machine on        | No                                  | Yes                                    | Yes                                 |
-| Requires open session      | No                                  | No                                     | Yes                                 |
-| Persistent across restarts | Yes                                 | Yes                                    | Restored on `--resume` if unexpired |
-| Access to local files      | No (fresh clone)                    | Yes                                    | Yes                                 |
-| MCP servers                | Connectors configured per task      | [Config files](/docs/en/mcp) and connectors | Inherits from session               |
-| Permission prompts         | No (runs autonomously)              | Configurable per task                  | Inherits from session               |
-| Customizable schedule      | Via `/schedule` in the CLI          | Yes                                    | Yes                                 |
-| Minimum interval           | 1 hour                              | 1 minute                               | 1 minute                            |
+|                            | [Cloud](/docs/en/routines)               | [Desktop](/docs/en/desktop-scheduled-tasks) | [`/loop`](/docs/en/scheduled-tasks)                                             |
+| :------------------------- | :---------------------------------- | :------------------------------------- | :------------------------------------------------------------------------- |
+| Runs on                    | Cloud, Anthropic-managed by default | Your machine                           | Your machine                                                               |
+| Requires machine on        | No                                  | Yes                                    | Yes                                                                        |
+| Requires open session      | No                                  | No                                     | Yes                                                                        |
+| Persistent across restarts | Yes                                 | Yes                                    | Restored on `--resume`, with [exceptions](/docs/en/scheduled-tasks#limitations) |
+| Access to local files      | No (fresh clone)                    | Yes                                    | Yes                                                                        |
+| MCP servers                | Connectors configured per task      | [Config files](/docs/en/mcp) and connectors | Inherits from session                                                      |
+| Permission prompts         | No (runs autonomously)              | Configurable per task                  | Inherits from session                                                      |
+| Customizable schedule      | Via `/schedule` in the CLI          | Yes                                    | Yes                                                                        |
+| Minimum interval           | 1 hour                              | 1 minute                               | 1 minute                                                                   |
 
```

</details>

<details>
<summary>discover-plugins-ja.md</summary>

```diff
diff --git a/docs-ja/pages/discover-plugins-ja.md b/docs-ja/pages/discover-plugins-ja.md
index df5f039..65720aa 100644
--- a/docs-ja/pages/discover-plugins-ja.md
+++ b/docs-ja/pages/discover-plugins-ja.md
@@ -338,10 +338,10 @@ Claude Code はローカル マーケットプレイス カタログのコピー
 
 * **マーケットプレイス名を含む場合**: セッションで `plugin-name@marketplace-name` をインストールするか、`claude plugin install` で実行すると、Claude Code はルックアップの前にそのマーケットプレイスを更新します。Claude Code は、マーケットプレイスの[自動更新](#configure-auto-updates)をオフにしたか、`DISABLE_AUTOUPDATER` を設定した場合でも、更新を実行します。v2.1.232 より前では、Claude Code はルックアップの前にマーケットプレイスを更新しませんでした。Claude Code は以下の場合、この更新をスキップします：
-  * マーケットプレイスが[GitHub、別の Git ホスト、またはリモート URL から追加](/docs/ja/plugin-marketplaces#pre-populate-plugins-for-containers)されていない。
+  * マーケットプレイスが[GitHub、別の Git ホスト、またはリモート URL から追加](#add-marketplaces)されていない。
   * [シード ディレクトリ](/docs/ja/plugin-marketplaces#pre-populate-plugins-for-containers)がマーケットプレイスを提供している。
   * Claude Code が過去 30 秒以内にマーケットプレイスを更新した。
   * [`CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC`](/docs/ja/env-vars)を設定した。
   * [管理設定](/docs/ja/plugin-marketplaces#managed-marketplace-restrictions)がマーケットプレイスをブロックしている。この場合、Claude Code はインストールも拒否します。
-* **プラグイン名のみ**: セッションで `/plugin install plugin-name` を実行すると、Claude Code は[バックグラウンドでも更新](/docs/ja/plugin-marketplaces#configure-auto-updates)するマーケットプレイスのみを更新し、ルックアップが失敗した後のみです。`claude plugin install plugin-name` を実行すると、Claude Code は更新なしでキャッシュされたカタログを読み取ります。最後の更新後に公開されたプラグインをインストールするには、セッションで `/plugin marketplace update <marketplace-name>` を実行するか、シェルで [`claude plugin marketplace update <marketplace-name>`](/docs/ja/plugin-marketplaces#plugin-marketplace-update)を実行してから、インストールを再試行します。
+* **プラグイン名のみ**: セッションで `/plugin install plugin-name` を実行すると、Claude Code は[バックグラウンドでも更新](#configure-auto-updates)するマーケットプレイスのみを更新し、ルックアップが失敗した後のみです。`claude plugin install plugin-name` を実行すると、Claude Code は更新なしでキャッシュされたカタログを読み取ります。最後の更新後に公開されたプラグインをインストールするには、セッションで `/plugin marketplace update <marketplace-name>` を実行するか、シェルで [`claude plugin marketplace update <marketplace-name>`](/docs/ja/plugin-marketplaces#plugin-marketplace-update)を実行してから、インストールを再試行します。
 
 名前付きインストール前の更新が失敗した場合（例えば、オフラインの場合）、Claude Code はキャッシュされたカタログでプラグインを検索します。`claude plugin install` は成功メッセージで `marketplace not refreshed` を報告し、`/plugin install` はプラグインの詳細の上または見つからないメッセージでエラーを表示します。
```

</details>

<details>
<summary>interactive-mode-ja.md</summary>

```diff
diff --git a/docs-ja/pages/interactive-mode-ja.md b/docs-ja/pages/interactive-mode-ja.md
index 061db85..261b95c 100644
--- a/docs-ja/pages/interactive-mode-ja.md
+++ b/docs-ja/pages/interactive-mode-ja.md
@@ -142,4 +142,17 @@ Claude Code で `/` と入力すると、利用可能なコマンドが表示さ
 Claude Code に含まれるコマンドの完全なリストについては、[コマンドリファレンス](/docs/ja/commands) を参照してください。
 
+<h3 id="complete-a-command-mid-prompt">
+  プロンプトの途中でコマンドを完成させる
+</h3>
+
+コマンド補完はプロンプトの途中でも機能します。スペースの後に `/` を入力し、その後に名前の最初の文字を入力します。例えば `run the tests, then /com` のようにします。名前がそれらの文字で始まるコマンドのみが一致するため、`/tmp/notes.md` のようなファイルパスではリストが開いたままになりません。Claude Code がコマンド自体を実行するのは、コマンドが [メッセージを開始する](/docs/ja/commands) 場合のみです。
+
+* **[フルスクリーンレンダリング](/docs/ja/fullscreen) の場合**：入力中に一致するコマンドがリストとして開き、行がハイライトされていないため、`Enter` キーを押すとプロンプトがそのまま送信されます。`Tab` キーを押すと最上位の一致が挿入されます。または矢印キーと `Enter` キーで行を選択します。
+* **フルスクリーン外の場合**：最上位の一致の残りがカーソルでゴーストテキストとして表示され、複数のコマンドが一致する場合は `+2` などのカウントが表示されます。`Tab` キーを押すと唯一の一致が挿入されるか、複数が一致する場合はリストが開き、矢印キーと `Enter` キーで行を選択します。
+
+両方のレンダラーで、プロンプトの途中の裸の `/` で `Tab` キーを押すと、すべてのコマンドがリストされます。
+
+プラグインスキルはその裸の名前でも一致するため、`/deploy` は `myplugin:deploy-app` という名前のスキルを見つけます。一致を挿入すると、Claude Code は完全な `/myplugin:deploy-app` を書き込みます。
+
 <h2 id="vim-editor-mode">
   Vim エディタモード
@@ -337,5 +350,5 @@ Claude Code がコマンドをバックグラウンドで実行する場合、
 * 出力が 5GB を超える場合、バックグラウンドタスクは自動的に終了され、stderr に理由を説明するメモが表示されます
 * macOS と Linux では、セッションが少なくとも 30 分間アイドル状態にあり、ターンまたはサブエージェントが実行されていない場合、Claude Code はオペレーティングシステムがメモリプレッシャーを通知するときに実行中のバックグラウンドタスクを終了します。[`CLAUDE_CODE_DISABLE_BG_SHELL_PRESSURE_REAP`](/docs/ja/env-vars) を `1` に設定してこれをオフにします。Claude Code v2.1.193 以降が必要です
-* [サブエージェント](/docs/ja/sub-agents)が所有するバックグラウンドコマンドには時間制限がありません。ただし、フォアグラウンドで実行されているサブエージェントが所有するコマンドは、そのサブエージェントが最終応答を行うときに終了します。ツール参照の[バックグラウンドコマンド](/docs/ja/tools-reference#background-commands)を参照してください。v2.1.218 より前では、メモリプレッシャーリープも、`Ctrl+B` でバックグラウンドに移動されたコマンドに対する以前の 60 分制限も、サブエージェントコマンドをカバーしていませんでした
+* [サブエージェント](/docs/ja/sub-agents)が所有するバックグラウンドコマンドには時間制限がありません。ただし、フォアグラウンドで実行されているサブエージェントが所有するコマンドは、そのサブエージェントが最終応答を行うときに終了します。ツール参照の[バックグラウンドコマンド](/docs/ja/tools-reference#background-commands)を参照してください。v2.1.218 より前では、メモリプレッシャーリープも、サブエージェントコマンドに対する以前の 60 分制限も、`Ctrl+B` でバックグラウンドに移動されたコマンドをカバーしていませんでした
 
 すべてのバックグラウンドタスク機能を無効にするには、`CLAUDE_CODE_DISABLE_BACKGROUND_TASKS` 環境変数を `1` に設定します。詳細は[環境変数](/docs/ja/env-vars)を参照してください。
@@ -578,4 +591,6 @@ Claude Code がチェッカーを実行し続けることができない場合
```

</details>

*...以降省略*

</details>


<details>
<summary>2026-09-10</summary>

**変更ファイル:**

```
 docs-ja/pages/accessibility-ja.md                  |  138 +-
 docs-ja/pages/admin-setup-ja.md                    |   75 +-
 docs-ja/pages/advisor-ja.md                        |   85 +-
 docs-ja/pages/agent-teams-ja.md                    |  183 +-
 docs-ja/pages/agents-ja.md                         |    9 +-
 docs-ja/pages/amazon-bedrock-ja.md                 |  229 +-
 docs-ja/pages/authentication-ja.md                 |  124 +-
 docs-ja/pages/auto-mode-config-ja.md               |  265 +-
 docs-ja/pages/best-practices-ja.md                 |  101 +-
 docs-ja/pages/champion-kit-ja.md                   |    6 +-
 docs-ja/pages/changelog.md                         |   56 +
 docs-ja/pages/channels-ja.md                       |   54 +-
 docs-ja/pages/channels-reference-ja.md             |   94 +-
 docs-ja/pages/checkpointing-ja.md                  |   46 +-
 docs-ja/pages/claude-apps-gateway-config-ja.md     |  451 ++-
 docs-ja/pages/claude-apps-gateway-deploy-ja.md     |  131 +-
 docs-ja/pages/claude-apps-gateway-ja.md            |  213 +-
 docs-ja/pages/claude-apps-gateway-on-aws-ja.md     |   36 +-
 .../pages/claude-apps-gateway-spend-limits-ja.md   |   66 +-
 docs-ja/pages/claude-code-on-the-web-ja.md         |  761 +---
 docs-ja/pages/claude-directory-ja.md               |  166 +-
 docs-ja/pages/claude-platform-on-aws-ja.md         |   34 +-
 docs-ja/pages/claude-security-ja.md                |   19 +-
 docs-ja/pages/claude-tag-ja.md                     |   13 +-
 docs-ja/pages/cli-reference-ja.md                  |  162 +-
 docs-ja/pages/cloud-environments-ja.md             |  249 +-
 docs-ja/pages/commands-ja.md                       |  262 +-
 docs-ja/pages/common-workflows-ja.md               |  115 +-
 docs-ja/pages/communications-kit-ja.md             |  173 +-
 docs-ja/pages/computer-use-ja.md                   |    6 +-
 docs-ja/pages/context-window-ja.md                 |   35 +-
 docs-ja/pages/corporate-launcher-ja.md             |   41 +-
 docs-ja/pages/costs-ja.md                          |  172 +-
 docs-ja/pages/data-usage-ja.md                     |   38 +-
 docs-ja/pages/debug-your-config-ja.md              |   73 +-
 docs-ja/pages/deep-links-ja.md                     |   40 +-
 docs-ja/pages/desktop-ios-simulator-ja.md          |    5 +-
 docs-ja/pages/desktop-ja.md                        |  303 +-
 docs-ja/pages/desktop-linux-ja.md                  |   73 +-
 docs-ja/pages/desktop-quickstart-ja.md             |   83 +-
 docs-ja/pages/desktop-scheduled-tasks-ja.md        |   14 +-
 docs-ja/pages/devcontainer-ja.md                   |   27 +-
 docs-ja/pages/discover-plugins-ja.md               |  135 +-
 docs-ja/pages/errors-ja.md                         | 3751 ++++++++++++++++----
 docs-ja/pages/fast-mode-ja.md                      |   99 +-
 docs-ja/pages/feature-availability-ja.md           |   94 +-
 docs-ja/pages/features-overview-ja.md              |  110 +-
 docs-ja/pages/fullscreen-ja.md                     |  250 +-
 docs-ja/pages/gateways-ja.md                       |   11 +-
 docs-ja/pages/github-actions-cloud-providers-ja.md |  326 +-
 docs-ja/pages/github-actions-ja.md                 |  850 ++---
 docs-ja/pages/github-enterprise-server-ja.md       |   56 +-
 docs-ja/pages/gitlab-ci-cd-ja.md                   |  333 +-
 docs-ja/pages/glossary-ja.md                       |   46 +-
 docs-ja/pages/goal-ja.md                           |   80 +-
 docs-ja/pages/google-vertex-ai-ja.md               |   64 +-
 docs-ja/pages/headless-ja.md                       |  173 +-
 docs-ja/pages/hooks-guide-ja.md                    |  250 +-
 docs-ja/pages/how-claude-code-works-ja.md          |   88 +-
 docs-ja/pages/interactive-mode-ja.md               |  787 ++--
 docs-ja/pages/jetbrains-ja.md                      |   28 +-
 docs-ja/pages/keybindings-ja.md                    |  243 +-
 docs-ja/pages/large-codebases-ja.md                |  107 +-
 docs-ja/pages/legal-and-compliance-ja.md           |   19 +-
 docs-ja/pages/llm-gateway-ja.md                    |    2 +-
 docs-ja/pages/llm-gateway-protocol-ja.md           |  100 +-
 docs-ja/pages/managed-mcp-ja.md                    |  430 ++-
 docs-ja/pages/managed-settings-ja.md               |  441 ++-
 docs-ja/pages/mcp-quickstart-ja.md                 |   65 +-
 docs-ja/pages/memory-ja.md                         |  111 +-
 docs-ja/pages/microsoft-foundry-ja.md              |    7 +-
 docs-ja/pages/mobile-ja.md                         |   27 +-
 docs-ja/pages/network-config-ja.md                 |  192 +-
 docs-ja/pages/overview-ja.md                       |   55 +-
 docs-ja/pages/permission-modes-ja.md               |  482 ++-
 docs-ja/pages/permissions-ja.md                    |  479 ++-
 docs-ja/pages/platforms-ja.md                      |   24 +-
 docs-ja/pages/plugin-dependencies-ja.md            |   74 +-
 docs-ja/pages/plugin-hints-ja.md                   |   11 +-
 docs-ja/pages/plugin-relevance-ja.md               |   24 +-
 docs-ja/pages/plugins-ja.md                        |  102 +-
 docs-ja/pages/plugins-reference-ja.md              |  921 ++---
 docs-ja/pages/prompt-caching-ja.md                 |  206 +-
 docs-ja/pages/prompt-library-ja.md                 |   16 +-
 docs-ja/pages/quickstart-ja.md                     |  111 +-
 docs-ja/pages/routines-ja.md                       |  120 +-
 docs-ja/pages/sandbox-environments-ja.md           |   74 +-
 docs-ja/pages/sandboxing-ja.md                     |  437 ++-
 docs-ja/pages/scheduled-tasks-ja.md                |   37 +-
 docs-ja/pages/security-guidance-ja.md              |   54 +-
 docs-ja/pages/security-ja.md                       |   34 +-
 .../self-hosted-environments-configuration-ja.md   |  439 ++-
 .../pages/self-hosted-environments-identity-ja.md  |  272 +-
 docs-ja/pages/self-hosted-environments-ja.md       |  166 +-
 .../self-hosted-environments-quickstart-ja.md      |  130 +-
 .../pages/self-hosted-environments-reference-ja.md |  338 +-
 .../pages/self-hosted-environments-testing-ja.md   |  271 +-
 docs-ja/pages/sessions-ja.md                       |  196 +-
 docs-ja/pages/settings-example-ja.md               |  392 +-
 docs-ja/pages/settings-ja.md                       | 1689 ++++-----
 docs-ja/pages/setup-ja.md                          |   67 +-
 docs-ja/pages/slack-ja.md                          |   57 +-
 docs-ja/pages/statusline-ja.md                     |  227 +-
 docs-ja/pages/terminal-config-ja.md                |  231 +-
 docs-ja/pages/third-party-integrations-ja.md       |  121 +-
 docs-ja/pages/tools-reference-ja.md                |  659 +++-
 docs-ja/pages/troubleshoot-install-ja.md           |  469 ++-
 docs-ja/pages/troubleshooting-ja.md                |   55 +-
 docs-ja/pages/ultrareview-ja.md                    |  159 +-
 docs-ja/pages/voice-dictation-ja.md                |   24 +-
 docs-ja/pages/vs-code-ja.md                        |  492 +--
 docs-ja/pages/web-quickstart-ja.md                 |   95 +-
 docs-ja/pages/workflows-ja.md                      |  226 +-
 docs-ja/pages/zero-data-retention-ja.md            |   15 +-
 114 files changed, 16413 insertions(+), 8139 deletions(-)
```

<details>
<summary>accessibility-ja.md</summary>

```diff
diff --git a/docs-ja/pages/accessibility-ja.md b/docs-ja/pages/accessibility-ja.md
index 06739d2..32668f1 100644
--- a/docs-ja/pages/accessibility-ja.md
+++ b/docs-ja/pages/accessibility-ja.md
@@ -7,11 +7,9 @@
 > VoiceOver や NVDA などのスクリーンリーダー、スクリーン拡大鏡、モーション削減、色覚異常対応テーマの設定で Claude Code をセットアップします。
 
-Claude Code には、ビジュアルターミナルインターフェースをプレーンな線形テキストに置き換えるスクリーンリーダーモードがあります。ボックス、プログレスアニメーション、インプレース再描画の代わりに、このモードはラベル付きの行を出力し、VoiceOver や NVDA などのスクリーンリーダーが順番に読み上げるため、完全な会話を保持し、ツール権限を承認し、出力を最後まで確認できます。
+Claude Code には、ビジュアルターミナルインターフェースをプレーンな線形テキストに置き換えるスクリーンリーダーモードがあります。ボックス、プログレスアニメーション、インプレース再描画の代わりに、Claude Code はラベル付きの行を出力し、VoiceOver や NVDA などのスクリーンリーダーが順番に読み上げます。完全な会話を保持し、ツール権限を承認し、出力を最後まで確認できます。
 
-スクリーンリーダーモードはオプトインです。スクリーン拡大鏡、モーション削減、またはスクリーンリーダーの代わりにカラーブラインド対応テーマを使用する場合は、[スクリーンリーダーモード以外のアクセシビリティ設定](#accessibility-settings-beyond-screen-reader-mode)を参照してください。
+スクリーンリーダーモードはオプトインです。スクリーン拡大鏡、モーション削減、またはスクリーンリーダーの代わりにカラーブラインド対応テーマを使用する場合は、[アクセシビリティ設定](#accessibility-settings)テーブルから `CLAUDE_CODE_ACCESSIBILITY`、`prefersReducedMotion`、または `theme` を設定してください。スクリーンリーダーモードはターミナルインターフェースのみを適応させるため、VS Code 拡張機能のチャットパネルではこれを必要としません。Claude Code v2.1.236 以降では、拡張機能は設定なしで[スクリーンリーダーにコンバーセーション活動を通知](/docs/ja/vs-code#use-a-screen-reader)します。
 
-<Note>
-  スクリーンリーダーモードには Claude Code v2.1.181 以降が必要です。以前のバージョンは `--ax-screen-reader` フラグを `error: unknown option '--ax-screen-reader'` で拒否します。
-</Note>
+スクリーンリーダーモードには Claude Code v2.1.181 以降が必要です。以前のバージョンは `--ax-screen-reader` フラグを `error: unknown option '--ax-screen-reader'` で拒否します。
 
 <h2 id="turn-on-screen-reader-mode">
@@ -22,15 +20,12 @@ Claude Code には、ビジュアルターミナルインターフェースを
 
 * 1 つのセッション用：`claude --ax-screen-reader` を実行します。
-* 1 つのシェルから開始されたセッション用：`CLAUDE_AX_SCREEN_READER` 環境変数を `1` に設定します。Bash または Zsh では `export CLAUDE_AX_SCREEN_READER=1` を実行し、PowerShell では `$env:CLAUDE_AX_SCREEN_READER = "1"` を実行します。すべてのシェルをカバーするために、シェルプロファイルに行を追加します。
-* マシン上のすべてのセッション用：ユーザー[設定ファイル](/docs/ja/settings)に `"axScreenReader": true` を追加します。これは VS Code 統合ターミナルを含むすべてのターミナルをカバーします。
+* 1 つのシェルから開始されたセッション用：`CLAUDE_AX_SCREEN_READER` 環境変数を `1` に設定します。Bash または Zsh では `export CLAUDE_AX_SCREEN_READER=1` を実行し、PowerShell では `$env:CLAUDE_AX_SCREEN_READER = "1"` を実行します。シェルプロファイルにその行を追加して、今後のシェルでも保持します。
+* マシン上のすべてのセッション用：ユーザー[設定ファイル](/docs/ja/settings)に `"axScreenReader": true` を追加します。この設定は VS Code 統合ターミナルを含むすべてのターミナルに適用されます。
 
-<Note>
-  メソッドは優先順位順にリストされています。[`--ax-screen-reader`](/docs/ja/cli-reference#cli-flags) フラグは [`CLAUDE_AX_SCREEN_READER`](/docs/ja/env-vars) 環境変数をオーバーライドし、これは [`axScreenReader`](/docs/ja/settings#available-settings) 設定をオーバーライドします。
-</Note>
```

</details>

<details>
<summary>admin-setup-ja.md</summary>

```diff
diff --git a/docs-ja/pages/admin-setup-ja.md b/docs-ja/pages/admin-setup-ja.md
index e4a104e..994e983 100644
--- a/docs-ja/pages/admin-setup-ja.md
+++ b/docs-ja/pages/admin-setup-ja.md
@@ -18,5 +18,5 @@ Claude Code は、ローカル開発者設定よりも優先されるマネー
 | :-------------------------------------------------------- | :------------------------ | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
 | [API プロバイダーを選択する](#choose-your-api-provider)              | Claude Code が認証される場所と課金方法 | [Authentication](/docs/ja/authentication)、[Amazon Bedrock](/docs/ja/amazon-bedrock)、[Google Cloud の Agent Platform](/docs/ja/google-vertex-ai)、[Microsoft Foundry](/docs/ja/microsoft-foundry) |
-| [設定がデバイスに到達する方法を決定する](#decide-how-settings-reach-devices) | マネージドポリシーが開発者マシンに到達する方法   | [Server-managed settings](/docs/ja/server-managed-settings)、[Settings files](/docs/ja/settings#settings-files)                                                                       |
+| [設定がデバイスに到達する方法を決定する](#decide-how-settings-reach-devices) | マネージドポリシーが開発者マシンに到達する方法   | [Server-managed settings](/docs/ja/server-managed-settings)、[Delivery mechanisms](/docs/ja/managed-settings#delivery-mechanisms)                                                     |
 | [実行する内容を決定する](#decide-what-to-enforce)                    | どのツール、コマンド、統合が許可されるか      | [Permissions](/docs/ja/permissions)、[Sandboxing](/docs/ja/sandboxing)                                                                                                                |
 | [使用状況の可視性をセットアップする](#set-up-usage-visibility)             | 支出と採用を追跡する方法              | [Analytics](/docs/ja/analytics)、[Monitoring](/docs/ja/monitoring-usage)、[Costs](/docs/ja/costs)                                                                                           |
@@ -47,5 +47,5 @@ Claude Code は複数の API プロバイダーのいずれかを通じて Claud
 </h2>
 
-マネージド設定は、ローカル開発者設定よりも優先されるポリシーを定義します。Claude Code は以下の 4 つのソースを優先順位順にチェックし、空でない設定を返す最初のものを適用します。ただし 1 つの例外があります。[クロスソースロックキー](/docs/ja/settings#settings-precedence)（サンドボックス許可リストロックなど）の小さなセットは、管理者が制御するソースがそれらを設定する場合に尊重されます。
+マネージド設定は、組織ポリシーを定義します。Claude Code は以下の表に示す 4 つのソースを優先順位順にチェックします。[Claude Code がマネージドソースを組み合わせる方法](/docs/ja/managed-settings#precedence-within-the-managed-tier)は、どのソースが適用されるか、ポリシーヘルパーが何を変更するか、およびすべてのソースを構成する方法を説明しています。この表は決定マップです。
 
 | メカニズム                   | 配信                                                                                                                                                                                                  | 優先度 | プラットフォーム      |
@@ -56,17 +56,13 @@ Claude Code は複数の API プロバイダーのいずれかを通じて Claud
 | Windows user registry   | `HKCU\SOFTWARE\Policies\ClaudeCode`                                                                                                                                                                 | 最低  | Windows のみ    |
 
-設定済みの [`policyHelper`](/docs/ja/settings#compute-managed-settings-with-a-policy-helper) は 4 つのソースすべてに優先します。その出力は実行時のマネージド設定の唯一のものになります。[設定の優先度](/docs/ja/settings#settings-precedence) を参照してください。
+Claude Code はスタートアップ時に server-managed 設定をフェッチし、セッション中は 1 時間ごとに更新します。デプロイするエンドポイントインフラストラクチャはありません。claude.ai 管理コンソール経由の配信には Claude for Teams または Enterprise プランが必要です。Amazon Bedrock、Google Cloud の Agent Platform、または Microsoft Foundry でのデプロイメントは、[Claude apps gateway](/docs/ja/claude-apps-gateway) を実行することで同じリモート配信を取得できます。または、ファイルベースまたは OS レベルのメカニズムのいずれかを代わりに使用してください。
 
-Server-managed 設定はデバイスが認証されるときに到達し、アクティブなセッション中は 1 時間ごとに更新されます。エンドポイントインフラストラクチャは不要です。claude.ai 管理コンソール経由の配信には Claude for Teams または Enterprise プランが必要です。Amazon Bedrock、Google Cloud の Agent Platform、または Microsoft Foundry での展開は、[Claude apps gateway](/docs/ja/claude-apps-gateway) を実行することで同じリモート配信を取得できます。または、代わりにファイルベースまたは OS レベルのメカニズムのいずれかを使用してください。
-
-組織が複数のプロバイダーを混在させている場合、claude.ai ユーザー向けに [server-managed settings](/docs/ja/server-managed-settings) を設定し、他のユーザーがマネージドポリシーを受け取るように [ファイルベースまたは plist/registry フォールバック](/docs/ja/settings#settings-files) を設定してください。
+組織が複数のプロバイダーを混在させている場合、claude.ai ユーザー向けに [server-managed settings](/docs/ja/server-managed-settings) を設定し、他のユーザーがマネージドポリシーを受け取るように [ファイルベースまたは plist/registry フォールバック](/docs/ja/managed-settings#delivery-mechanisms)を設定してください。
 
 plist と HKLM レジストリの場所は任意のプロバイダーで機能し、書き込みに管理者権限が必要なため、改ざんに強いです。HKCU の Windows ユーザーレジストリは昇格なしで書き込み可能なため、実行チャネルではなく便利なデフォルトとして扱ってください。
```

</details>

<details>
<summary>advisor-ja.md</summary>

```diff
diff --git a/docs-ja/pages/advisor-ja.md b/docs-ja/pages/advisor-ja.md
index 8a36aeb..949378a 100644
--- a/docs-ja/pages/advisor-ja.md
+++ b/docs-ja/pages/advisor-ja.md
@@ -35,9 +35,7 @@ advisor モデルは 3 つの方法で設定できます。
 * **`--advisor` フラグ**：起動時に単一セッションの advisor を設定します
 
-これらのいずれかが advisor モデルを設定する場合、advisor はメインモデルが[それをサポートしている](#choose-an-advisor-model)セッションで有効になります。使用を停止するには、[advisor をオフにする](#turn-the-advisor-off)を参照してください。
+これらのいずれかが advisor を有効にするのは、メインモデルが[それをサポートしている](#choose-an-advisor-model)セッションです。セッションが開始されると、Claude Code は `Advisor Tool (experimental) is on and may use more tokens · /advisor` 通知を表示します。advisor の使用を停止するには、[advisor をオフにする](#turn-the-advisor-off)を参照してください。
 
-<Note>
-  Fable 5 を advisor として使用するには、Claude Code v2.1.170 以降と、組織の [Fable 5 アクセス](/docs/ja/model-config#work-with-fable-5)が必要です。
-</Note>
+一部のプランでは、Fable を advisor として使用する場合、Fable の使用を使用クレジットに請求することへの 1 回限りの[同意](/docs/ja/model-config#fable-and-usage-credits)も必要です。その同意を与える前に何が起こるかについては、[Fable advisor と使用クレジット](#fable-advisor-and-usage-credits)を参照してください。
 
 <h3 id="use-the-/advisor-command">
@@ -51,5 +49,9 @@ advisor モデルは 3 つの方法で設定できます。
 ```
 
-選択は、ユーザー設定の `advisorModel` に保存され、セッション全体で保持されます。組織の [`availableModels`](/docs/ja/model-config#restrict-model-selection)許可リストが保存された advisor モデルを除外している場合、`/advisor` で許可されたモデルを選択するまで advisor は呼び出されません。現在のメインモデルが advisor をサポートしていない場合、選択は引き続き保存され、[`/model`](/docs/ja/model-config#setting-your-model)で[互換性のあるメインモデル](#choose-an-advisor-model)に切り替えるときにアクティブになります。
+コマンドは `Advisor set to` で確認し、その後に advisor モデル名が続きます。選択はユーザー設定の `advisorModel` に保存され、セッション全体で保持されます。
+
+Claude Code は、組織の [`availableModels`](/docs/ja/model-config#restrict-model-selection)許可リストが除外した保存済み advisor を呼び出しません。advisor を使用するには、`/advisor` で許可されたモデルを選択してください。Claude Code は、現在のメインモデルがサポートしていない advisor を引き続き保存します。その advisor は、[`/model`](/docs/ja/model-config#setting-your-model)で[互換性のあるメインモデル](#choose-an-advisor-model)に切り替えた後にアクティブになります。
+
+一部のプランでは、Fable を advisor として使用する場合、Fable の使用を使用クレジットに請求することへの 1 回限りの[同意](/docs/ja/model-config#fable-and-usage-credits)も必要です。その同意を与える前に `/advisor fable` が何をするかについては、[Fable advisor と使用クレジット](#fable-advisor-and-usage-credits)を参照してください。
 
 <h3 id="set-advisormodel-in-settings">
@@ -75,5 +77,12 @@ claude --advisor opus
 ```
 
```

</details>

<details>
<summary>agent-teams-ja.md</summary>

```diff
diff --git a/docs-ja/pages/agent-teams-ja.md b/docs-ja/pages/agent-teams-ja.md
index 79b1162..1f6564f 100644
--- a/docs-ja/pages/agent-teams-ja.md
+++ b/docs-ja/pages/agent-teams-ja.md
@@ -8,10 +8,10 @@
 
 <Warning>
-  エージェントチームは実験的機能であり、デフォルトでは無効になっています。[settings.json](/docs/ja/settings) または環境に `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS` を追加して有効にしてください。その変数がない場合、セッション開始時にチームが設定されず、チームディレクトリが書き込まれず、Claude はチームメンバーをスポーンまたは提案しません。エージェントチームには、セッション再開、タスク調整、シャットダウン動作に関する[既知の制限](#limitations)があります。
+  エージェントチームは実験的機能であり、デフォルトでは無効になっています。[settings.json](/docs/ja/settings) または環境に `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1` を設定して有効にしてください。その変数がない場合、セッション開始時にチームが設定されず、チームディレクトリが書き込まれず、Claude はチームメンバーをスポーンまたは提案しません。エージェントチームには、セッション再開、タスク調整、シャットダウン動作に関する[既知の制限](#limitations)があります。
 </Warning>
 
-エージェントチームを使用すると、複数の Claude Code インスタンスが連携して動作するように調整できます。1 つのセッションがチームリーダーとして機能し、作業を調整し、タスクを割り当て、結果を統合します。チームメンバーは独立して動作し、それぞれ独自のコンテキストウィンドウで動作し、互いに直接通信します。
+エージェントチームを使用すると、複数の Claude Code インスタンスが連携して動作するように調整できます。1 つのセッションがチームリーダーとして機能し、作業を調整し、タスクを割り当て、結果を統合します。チームメンバーは独立して動作し、それぞれ独自のコンテキストウィンドウで動作し、互いに直接通信します。リーダーを経由せずに、任意のチームメンバーと直接対話することもできます。
 
-[subagents](/docs/ja/sub-agents)（単一セッション内で実行され、メインエージェントにのみ報告できる）とは異なり、リーダーを経由せずに個別のチームメンバーと直接対話することもできます。
+チームを設定する前に、より軽量なオプションで十分かどうかを確認してください。[Subagents](/docs/ja/sub-agents) は単一セッション内で動作し、[クロスセッションメッセージング](/docs/ja/cross-session-messaging) を使用すると Claude は自分で実行するセッション間で検出結果を渡すことができます。
 
 <Note>
@@ -36,7 +36,7 @@
 </h3>
 
-エージェントチームと [subagents](/docs/ja/sub-agents) の両方を使用すると、作業を並列化できますが、動作方法が異なります。ワーカーが互いに通信する必要があるかどうかに基づいて選択してください。
+エージェントチームと [subagents](/docs/ja/sub-agents) の両方を使用すると、作業を並列化できますが、動作方法が異なります。チームなしでメッセージを相互に渡す別々のセッションについては、[クロスセッションメッセージング](/docs/ja/cross-session-messaging)を参照してください。
 
-<Frame caption="Subagents は結果をメインエージェントに報告するだけで、互いに通信することはありません。エージェントチームでは、チームメンバーがタスクリストを共有し、作業を要求し、互いに直接通信します。">
+<Frame caption="Subagents は結果をメインエージェントに報告します。エージェントチームでは、チームメンバーがタスクリストを共有し、作業を要求し、互いに直接通信します。">
   <img src="https://mintcdn.com/claude-code/nsvRFSDNfpSU5nT7/images/subagents-vs-agent-teams-light.png?fit=max&auto=format&n=nsvRFSDNfpSU5nT7&q=85&s=2f8db9b4f3705dd3ab931fbe2d96e42a" className="dark:hidden" alt="Subagent とエージェントチームのアーキテクチャを比較する図。Subagents はメインエージェントによって生成され、作業を実行し、結果を報告します。エージェントチームは共有タスクリストを通じて調整され、チームメンバーが互いに直接通信します。" width="4245" height="1615" data-path="images/subagents-vs-agent-teams-light.png" />
 
@@ -44,11 +44,11 @@
 </Frame>
```

</details>

<details>
<summary>agents-ja.md</summary>

```diff
diff --git a/docs-ja/pages/agents-ja.md b/docs-ja/pages/agents-ja.md
index 929a33a..25b169f 100644
--- a/docs-ja/pages/agents-ja.md
+++ b/docs-ja/pages/agents-ja.md
@@ -18,7 +18,8 @@
 すべてのアプローチにおいて、ワーカーは Claude セッションです。別のツールを関与させるには、それを Claude に [MCP サーバー](/docs/ja/mcp) として公開します。
 
-この作業をサポートする 2 つの追加ツールがありますが、エージェント自体を実行する方法ではありません。
+この作業をサポートする 3 つの追加ツールがありますが、エージェント自体を実行する方法ではありません。
 
 * [ワークツリー](/docs/ja/worktrees) は各セッションに個別の git チェックアウトを提供するため、並列セッションが同じファイルを編集することはありません。自分で実行するセッションに使用します。エージェントビューは、ディスパッチされた各セッションを自動的に独自のワークツリーに移動し、スポーンするサブエージェントも各々独自のワークツリーを取得できます。
+* [クロスセッションメッセージング](/docs/ja/cross-session-messaging) により、Claude はこのマシン上、別のマシン上、または [Claude Code on the web](/docs/ja/claude-code-on-the-web) 上の他の Claude Code セッションをリストして、メッセージを送信できます。自分で実行するセッションは、検出結果とステータスを相互に渡すことができます。
 * [`/batch`](/docs/ja/commands) は、1 つの大きな変更を 5 ～ 30 個のワークツリー分離サブエージェントに分割し、各エージェントがプルリクエストを開く [skill](/docs/ja/skills) です。これはサブエージェントとワークツリーのパッケージ化された使用法であり、別の調整スタイルではありません。
 
@@ -26,6 +27,6 @@
 
 * [バックグラウンド bash コマンド](/docs/ja/interactive-mode#background-bash-commands) は、会話をブロックすることなく 1 つのシェルコマンドを実行します。エージェントをスポーンしません。
-* [フォークされたサブエージェント](/docs/ja/sub-agents#fork-the-current-conversation) は、新規に開始する代わりに完全な会話コンテキストを継承するサブエージェントです。これはサブエージェントをスポーンする方法であり、別のサーフェスではありません。
-* [ルーチン](/docs/ja/routines) は、マシン上で並列に実行するのではなく、Anthropic のクラウドでスケジュールに従ってセッションを実行します。
+* [フォークされたサブエージェント](/docs/ja/sub-agents#fork-the-current-conversation) は、新規に開始する代わりに完全な会話コンテキストを継承するサブエージェントです。これはサブエージェントをスポーンする方法であり、別のサーフェスではありません。`/subtask` で開始します。Claude は [フォークモード](/docs/ja/sub-agents#turn-fork-mode-on-or-off) がオンの場合、自身でもスポーンします。完全なセッションを、それと並行して実行する新しい [バックグラウンドセッション](/docs/ja/agent-view#from-inside-a-session) にコピーするには、`/fork` を使用します。[エージェントビューがオフ](/docs/ja/agent-view#turn-off-agent-view) の場合、フォークされたサブエージェントコマンドは `/fork` に変わり、`/subtask` は利用できません。
+* [ルーチン](/docs/ja/routines) は、マシン上で並列に実行するのではなく、クラウドでスケジュールに従ってセッションを実行します。
 
 <Note>
@@ -44,5 +45,5 @@
   * Claude がワーカーのグループを計画、割り当て、監督する場合：[エージェントチーム](/docs/ja/agent-teams)（実験的で、デフォルトでは無効）
   * スクリプトが Claude のターンバイターン判断の代わりに計画を保持する場合：[動的ワークフロー](/docs/ja/workflows)。[ワークフローがサブエージェントとスキルとどのように比較されるか](/docs/ja/workflows#when-to-use-a-workflow)を参照してください
-* **ワーカーが互いに通信する必要があるか？** サブエージェントは結果をそれらを生成した会話に報告し、エージェントビューセッションはあなたにのみ報告します。エージェントチームのチームメイトはタスクリストを共有し、互いに直接メッセージを送信します。
+* **ワーカーが互いに通信する必要があるか？** Claude は [クロスセッションメッセージング](/docs/ja/cross-session-messaging)を使用して、自分で実行するセッション（エージェントビューから派遣するセッションを含む）間で調査結果を渡すことができます。サブエージェントは結果をそれらを生成した会話に報告し、エージェントビューセッションはあなたにのみ報告します。エージェントチームのチームメイトは互いに直接メッセージを送信し、[Task ツールを持つ場合](/docs/ja/tools-reference#task-tool-availability)、タスクリストを共有します。
 * **タスクが同じファイルに触れるか？** [ワークツリー](/docs/ja/worktrees)で作業を分離します。サブエージェントと自分で実行するセッションは、それぞれ個別のワークツリーを使用できます。エージェントチームはチームメイトをワークツリーで分離しないため、[作業を分割](/docs/ja/agent-teams#avoid-file-conflicts)して、各チームメイトが異なるファイルセットを所有するようにします。
 
```

</details>

<details>
<summary>amazon-bedrock-ja.md</summary>

```diff
diff --git a/docs-ja/pages/amazon-bedrock-ja.md b/docs-ja/pages/amazon-bedrock-ja.md
index 71a1b00..a37fe98 100644
--- a/docs-ja/pages/amazon-bedrock-ja.md
+++ b/docs-ja/pages/amazon-bedrock-ja.md
@@ -96,48 +96,48 @@ Amazon Bedrock 認証情報を使用してサインインするには、以下
 </h2>
 
-AWS 認証情報を持っていて、Amazon Bedrock を通じて Claude Code の使用を開始したい場合、ログインウィザードがそれをガイドします。AWS 側の前提条件はアカウントごとに 1 回完了します。ウィザードは Claude Code 側を処理します。
+AWS 認証情報を持っていて、Amazon Bedrock を通じて Claude Code の使用を開始したい場合、ログインウィザードがその手順を案内します。AWS 側の前提条件はアカウントごとに 1 回完了します。ウィザードが Claude Code 側を処理します。
 
 <Steps>
   <Step title="AWS アカウントで Anthropic モデルを有効にする">
-    [Amazon Bedrock コンソール](https://console.aws.amazon.com/bedrock/)で、モデルカタログを開き、Anthropic モデルを選択して、ユースケースフォームを送信します。送信直後にアクセスが付与されます。AWS Organizations については[ユースケースの詳細を送信](#1-submit-use-case-details)を、権限については [IAM 設定](#iam-configuration)を参照してください。
+    [Amazon Bedrock コンソール](https://console.aws.amazon.com/bedrock/)で、モデルカタログを開き、Anthropic モデルを選択して、ユースケースフォームを送信します。送信直後にアクセスが許可されます。AWS Organizations については[ユースケースの詳細を送信](#1-submit-use-case-details)を、権限については[IAM 設定](#iam-configuration)を参照してください。
   </Step>
 
-  <Step title="Claude Code を開始して Amazon Bedrock を選択する">
-    `claude` を実行します。ログインプロンプトで、**3rd-party platform**、次に **Amazon Bedrock** を選択します。
+  <Step title="Claude Code を起動して Amazon Bedrock を選択する">
+    `claude` を実行します。ログインプロンプトで、**3rd-party platform** を選択してから、**Amazon Bedrock** を選択します。既にサインインしていてチャットプロンプトが表示されている場合は、`/setup-bedrock` を実行してウィザードを開きます。`CLAUDE_CODE_USE_BEDROCK=1` が設定されるまで、Claude Code は[コマンドメニューからコマンドを非表示にします](/docs/ja/commands#how-the-command-menu-matches-what-you-type)。完全に入力してください。
   </Step>
 
   <Step title="ウィザードプロンプトに従う">
-    AWS に認証する方法を選択します。`~/.aws` ディレクトリから検出された AWS プロファイル、Amazon Bedrock API キー、アクセスキーとシークレット、または環境内に既にある認証情報です。ウィザードはリージョンを取得し、アカウントが呼び出せる Claude モデルを確認し、それらをピン留めできます。結果は [user settings file](/docs/ja/settings) の `env` ブロックに保存されるため、環境変数を自分でエクスポートする必要はありません。
+    AWS への認証方法を選択します。`~/.aws` ディレクトリから検出された AWS プロファイル、Amazon Bedrock API キー、アクセスキーとシークレット、または環境に既に存在する認証情報です。ウィザードはリージョンを要求し、アカウントが呼び出せる Claude モデルを確認し、それらをピン留めできます。結果は[ユーザー設定ファイル](/docs/ja/settings)の `env` ブロックに保存されるため、環境変数を自分でエクスポートする必要はありません。
   </Step>
 </Steps>
 
-サインイン後、いつでも `/setup-bedrock` を実行してウィザードを再度開き、認証情報、リージョン、またはモデルピンを変更できます。モデルピンステップは、現在ピン留めされているモデルから開始されます。ウィザードは `~/.claude/settings.json` に書き込むか、[`CLAUDE_CONFIG_DIR`](/docs/ja/env-vars#variables) が設定されている場合は `$CLAUDE_CONFIG_DIR/settings.json` に書き込みます。
+サインイン後、いつでも `/setup-bedrock` を実行してウィザードを再度開き、認証情報、リージョン、またはモデルピンを変更できます。モデルピンステップは、現在ピン留めされているモデルから開始します。ウィザードは `~/.claude/settings.json` に書き込むか、[`CLAUDE_CONFIG_DIR`](/docs/ja/env-vars#variables) が設定されている場合は `$CLAUDE_CONFIG_DIR/settings.json` に書き込みます。
```

</details>

*...以降省略*

</details>


<details>
<summary>2026-09-09</summary>

**変更ファイル:**

```
 docs-ja/pages/changelog.md                  | 57 +++++++++++++++++++++++++++++
 docs-ja/pages/claude-directory-ja.md        |  6 +--
 docs-ja/pages/cross-session-messaging-ja.md |  2 +-
 docs-ja/pages/managed-settings-ja.md        |  2 +-
 docs-ja/pages/settings-example-ja.md        |  2 +-
 docs-ja/pages/settings-reference-ja.md      |  2 +-
 6 files changed, 64 insertions(+), 7 deletions(-)
```

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index 77bbc03..32c20ac 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,61 @@
 # Changelog
 
+## 2.1.266
+
+- Fixed a 2.1.265 regression affecting LLM-gateway and proxy setups: the undocumented `CLAUDE_CODE_USE_GATEWAY` environment variable, previously ignored unless `ANTHROPIC_BASE_URL` and `ANTHROPIC_AUTH_TOKEN` were both set, began forcing Cloud-gateway sign-in on its own in 2.1.265, so configurations that set it alongside an API key, `apiKeyHelper`, or custom auth headers failed every request with "Not signed in to the Cloud gateway". The variable on its own is ignored again; no configuration change is needed
+
+## 2.1.265
+
+- Added `user.email` and `user.groups` to the telemetry Claude Desktop and Cowork send through a Claude apps gateway, matching terminal sessions
+- Added support for pointing `--plugin-dir` at a folder of plugins: each child folder with a manifest loads, and children added or removed while running are picked up
+- Added a 1 GB cap on tool results saved to disk; the in-conversation preview says when a saved file was truncated
+- Fixed resuming a foreground-spawned subagent changing its tool list and system prompt prefix, which broke prompt-cache reuse for that agent
+- Fixed agent teammates and resumed subagents moving SubagentStart hook context and preloaded skills out of the prompt prefix on later turns, which broke prompt-cache reuse
+- Fixed resume after the previous process died while a tool was running: the last prompt is no longer rewritten, and the interrupted tool call is kept and marked interrupted
+- Fixed `/model opusplan[1m]` being rejected with "Model not found"
+- Fixed syntax-highlighted code in permission prompts and messages sometimes omitting a character after a Ruby `?`, Erlang `$`, or Perl `$` sigil
+- Fixed the fullscreen transcript jumping by one row whenever the slash-command or @-file suggestion list opened or closed
+- Fixed a plugin path containing a backslash bypassing the symlink containment check on macOS and Linux
+- Fixed plugin directories whose names begin with two dots being wrongly refused as outside the plugin root
+- Fixed VS Code and SDK sessions occasionally requiring re-login when a session was closed while refreshing its token
+- Fixed Remote Control sessions sending the end-of-turn signal before the reply's last message, which could show a reply as finished in the Claude app before its last part arrived
+- Fixed background (`--bg`) sessions occasionally being retired mid-turn when a message arrived just before the idle timeout
+- Fixed Claude Code's own git status and diff probes running clean filters configured by a nested repository inside the working tree
+- Fixed the advisor tool and its instructions being re-decided per request from the request's model; the decision is now made once and announced in the conversation when it changes
+- Fixed artifact publish accepting connector tool names the connector doesn't expose; the publish is now refused when none of the declared tools exist, and warned when only some don't
```

</details>

<details>
<summary>claude-directory-ja.md</summary>

```diff
diff --git a/docs-ja/pages/claude-directory-ja.md b/docs-ja/pages/claude-directory-ja.md
index febde4e..8ea2b35 100644
--- a/docs-ja/pages/claude-directory-ja.md
+++ b/docs-ja/pages/claude-directory-ja.md
@@ -323,5 +323,5 @@ Investigate and fix the issue above.
           color: '#5AA7A7',
           oneLiner: 'Project-scoped output styles, if your team shares any',
-          when: 'Applied at session start when selected via the outputStyle setting',
+          when: 'Files read at startup; the style you select with outputStyle is added to the system prompt every turn',
           description: <>Output styles are usually personal, so most live in <C>~/.claude/output-styles/</C>. Put one here if your team shares a style, like a review mode everyone uses. See <A href="#ce-global-output-styles">the Global tab</A> for the full explanation and example.</>,
           docsLink: '/en/output-styles',
@@ -640,7 +640,7 @@ type: reference
           color: '#5AA7A7',
           oneLiner: 'Custom system-prompt sections that adjust how Claude works',
-          when: 'Applied at session start when selected via the outputStyle setting',
+          when: 'Files read at startup; the style you select with outputStyle is added to the system prompt every turn',
           description: [<>Each markdown file defines an output style: a section appended to the system prompt that, by default, also drops the built-in software-engineering task instructions. Use this to adapt Claude Code for uses beyond coding, or to add teaching or review modes.</>, <>Select a built-in or custom style with <C>/config</C> or the <C>outputStyle</C> key in settings. Styles here are available in every project; project-level styles with the same name take precedence.</>],
-          tips: ['Built-in styles Default, Proactive, Concise, Explanatory, and Learning are included with Claude Code; custom styles go here', <>Set <C>keep-coding-instructions: true</C> in frontmatter to keep the default task instructions alongside your additions</>, 'Changes take effect on the next session since the system prompt is fixed at startup for caching'],
+          tips: ['Built-in styles Default, Proactive, Concise, Explanatory, and Learning are included with Claude Code; custom styles go here', <>Set <C>keep-coding-instructions: true</C> in frontmatter to keep the default task instructions alongside your additions</>, 'Switching styles mid-session applies from your next message and rebuilds the prompt cache once; in the terminal, a style file you create or edit mid-session is picked up after a restart'],
           docsLink: '/en/output-styles',
           children: [{
```

</details>

<details>
<summary>cross-session-messaging-ja.md</summary>

```diff
diff --git a/docs-ja/pages/cross-session-messaging-ja.md b/docs-ja/pages/cross-session-messaging-ja.md
index 61b1d4f..82a59e2 100644
--- a/docs-ja/pages/cross-session-messaging-ja.md
+++ b/docs-ja/pages/cross-session-messaging-ja.md
@@ -12,3 +12,3 @@ The requested page could not be found.
 - [Message your other Claude Code sessions](https://code.claude.com/docs/en/cross-session-messaging.md#restrict-cross-session-messaging)
 - [Orchestrate teams of Claude Code sessions](https://code.claude.com/docs/en/agent-teams.md#next-steps)
-- [Claude Code settings reference](https://code.claude.com/docs/en/settings-reference.md#agents-sessions-and-worktrees)
+- [All settings](https://code.claude.com/docs/en/settings-reference.md#agents-sessions-and-worktrees)
```

</details>

<details>
<summary>managed-settings-ja.md</summary>

```diff
diff --git a/docs-ja/pages/managed-settings-ja.md b/docs-ja/pages/managed-settings-ja.md
index 3de9224..5098468 100644
--- a/docs-ja/pages/managed-settings-ja.md
+++ b/docs-ja/pages/managed-settings-ja.md
@@ -12,3 +12,3 @@ The requested page could not be found.
 - [Deploy managed settings](https://code.claude.com/docs/en/managed-settings.md#deploy-a-managed-settings-file)
 - [Configure server-managed settings](https://code.claude.com/docs/en/server-managed-settings.md#choose-between-server-managed-and-endpoint-managed-settings)
-- [Claude Code settings](https://code.claude.com/docs/en/settings.md#exceptions-to-managed-settings-precedence)
+- [All settings](https://code.claude.com/docs/en/settings-reference.md#allowmanagedmcpserversonly)
```

</details>

<details>
<summary>settings-example-ja.md</summary>

```diff
diff --git a/docs-ja/pages/settings-example-ja.md b/docs-ja/pages/settings-example-ja.md
index 52f1ab3..14959bf 100644
--- a/docs-ja/pages/settings-example-ja.md
+++ b/docs-ja/pages/settings-example-ja.md
@@ -11,4 +11,4 @@ The requested page could not be found.
 
 - [Example settings files](https://code.claude.com/docs/en/settings-example.md)
+- [All settings](https://code.claude.com/docs/en/settings-reference.md#sshhostallowlist)
 - [Examples](https://code.claude.com/docs/en/agent-sdk/examples.md)
-- [Claude Code settings reference](https://code.claude.com/docs/en/settings-reference.md#sshhostallowlist)
```

</details>

<details>
<summary>settings-reference-ja.md</summary>

```diff
diff --git a/docs-ja/pages/settings-reference-ja.md b/docs-ja/pages/settings-reference-ja.md
index 613db36..ae8199a 100644
--- a/docs-ja/pages/settings-reference-ja.md
+++ b/docs-ja/pages/settings-reference-ja.md
@@ -10,5 +10,5 @@ The requested page could not be found.
 ## Related topics
 
-- [Claude Code settings reference](https://code.claude.com/docs/en/settings-reference.md)
 - [Hooks reference](https://code.claude.com/docs/en/hooks.md#configchange)
 - [Plugins reference](https://code.claude.com/docs/en/plugins-reference.md#user-configuration)
+- [Error reference](https://code.claude.com/docs/en/errors.md#settings-file-exceeds-the-2mib-limit)
```

</details>

</details>


<details>
<summary>2026-09-07</summary>

**変更ファイル:**

```
 docs-ja/pages/changelog.md                         |    4 +
 docs-ja/pages/claude-tag-en.md                     |   11 -
 docs-ja/pages/cross-session-messaging-en.md        |  365 --
 docs-ja/pages/github-actions-cloud-providers-en.md |  320 --
 docs-ja/pages/managed-settings-en.md               |  396 --
 .../self-hosted-environments-configuration-en.md   |  400 --
 .../pages/self-hosted-environments-deploy-en.md    |  463 --
 docs-ja/pages/self-hosted-environments-en.md       |  144 -
 .../pages/self-hosted-environments-identity-en.md  |  248 -
 .../self-hosted-environments-quickstart-en.md      |  114 -
 .../pages/self-hosted-environments-reference-en.md |  318 --
 .../pages/self-hosted-environments-testing-en.md   |  241 -
 docs-ja/pages/settings-example-en.md               |  393 --
 docs-ja/pages/settings-reference-en.md             | 5861 --------------------
 14 files changed, 4 insertions(+), 9274 deletions(-)
```

**新規追加:**


**削除:**


<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index 8d3f6a0..77bbc03 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,8 @@
 # Changelog
 
+## 2.1.263
+
+- Bug fixes and reliability improvements
+
 ## 2.1.261
 
```

</details>

</details>


<details>
<summary>2026-09-06</summary>

**変更ファイル:**

```
 docs-ja/pages/managed-settings-en.md   |  2 ++
 docs-ja/pages/settings-example-en.md   |  6 ++--
 docs-ja/pages/settings-reference-en.md | 66 ++++++++++++++++++++++++----------
 3 files changed, 53 insertions(+), 21 deletions(-)
```

<details>
<summary>managed-settings-en.md</summary>

```diff
diff --git a/docs-ja/pages/managed-settings-en.md b/docs-ja/pages/managed-settings-en.md
index f396f95..be02788 100644
--- a/docs-ja/pages/managed-settings-en.md
+++ b/docs-ja/pages/managed-settings-en.md
@@ -364,4 +364,6 @@ The table covers the permission, plugin, and delivery controls. For any key not
 <Note>
   On Team and Enterprise plans, an Owner enables or disables [Remote Control](/docs/en/remote-control) and [web sessions](/docs/en/claude-code-on-the-web) organization-wide in [Claude Code admin settings](https://claude.ai/admin-settings/claude-code). Remote Control can additionally be disabled per device with the [`disableRemoteControl`](/docs/en/settings-reference#disableremotecontrol) setting. Web sessions have no per-device managed settings key.
+
+  To check whether these organization settings reached a given machine, run `claude doctor` there and read the `Organization policy` line, which says where Claude Code loaded the policy from or why it didn't load. Requires Claude Code v2.1.261 or later. In a running session, `/status` shows the same line when the policy didn't load.
 </Note>
 
```

</details>

<details>
<summary>settings-example-en.md</summary>

```diff
diff --git a/docs-ja/pages/settings-example-en.md b/docs-ja/pages/settings-example-en.md
index fa6917c..8bfb572 100644
--- a/docs-ja/pages/settings-example-en.md
+++ b/docs-ja/pages/settings-example-en.md
@@ -365,7 +365,7 @@ Administrators deploy a file like this as `managed-settings.json`, or the same J
         }
       ],
-      // Sandbox every command, refuse to start if the sandbox can't be set up, and
-      // never let a blocked command retry outside the sandbox; network limited to
-      // npm and GitHub, and users can't add domains
+      // Sandbox every command Claude runs, refuse to start if the sandbox can't be
+      // set up, and never let a blocked command retry outside the sandbox; network
+      // limited to npm and GitHub, and users can't add domains
       "sandbox": {
         "enabled": true,
```

</details>

<details>
<summary>settings-reference-en.md</summary>

```diff
diff --git a/docs-ja/pages/settings-reference-en.md b/docs-ja/pages/settings-reference-en.md
index 1f21e0c..96e423c 100644
--- a/docs-ja/pages/settings-reference-en.md
+++ b/docs-ja/pages/settings-reference-en.md
@@ -621,4 +621,5 @@ scope: "Which settings files can set the key: user (~/.claude/settings.json), pr
 | [`awsCredentialExport`](#awscredentialexport)                                                         | Supply [Bedrock credentials](/docs/en/amazon-bedrock#advanced-credential-configuration) as JSON from your own command                                                                                                            | Authentication and providers       | Any file                |
 | [`axScreenReader`](#axscreenreader)                                                                   | Render [screen-reader friendly output](/docs/en/accessibility)                                                                                                                                                                   | Interface and terminal             | Any file                |
+| [`bashOutputMaxChars`](#bashoutputmaxchars)                                                           | Set how much of a successful command's [output](/docs/en/tools-reference#output-limits) Claude receives inline                                                                                                                   | Memory and context                 | Any file                |
 | [`blockedMarketplaces`](#blockedmarketplaces)                                                         | Block [plugin marketplace](/docs/en/plugin-marketplaces) sources for your organization                                                                                                                                           | Plugins and skills                 | Managed                 |
 | [`browserExternalPageTools`](#browserexternalpagetools)                                               | Keep Claude's tools off external pages in the [desktop](/docs/en/desktop) Browser pane                                                                                                                                           | Tools                              | Managed                 |
@@ -681,5 +682,5 @@ scope: "Which settings files can set the key: user (~/.claude/settings.json), pr
 | [`inputNeededNotifEnabled`](#inputneedednotifenabled)                                                 | Get a [push notification](/docs/en/remote-control#mobile-push-notifications) when Claude is waiting on you                                                                                                                       | Remote, desktop, and notifications | Any file                |
 | [`isolatePeerMachines`](#isolatepeermachines)                                                         | Ask you before Claude [messages one of your sessions on another machine](/docs/en/cross-session-messaging#require-approval-for-cross-machine-messages)                                                                           | Agents, sessions, and worktrees    | Any file                |
-| [`keybindingFlavor`](#keybindingflavor)                                                               | Make `Ctrl+W` [delete back to the previous whitespace](/docs/en/interactive-mode#make-ctrl-w-delete-back-to-whitespace), as Bash does                                                                                            | Interface and terminal             | Any file                |
+| [`keybindingFlavor`](#keybindingflavor)                                                               | Deprecated and has no effect; the word-editing shortcuts always [follow readline conventions](/docs/en/interactive-mode#make-ctrl-w-delete-back-to-whitespace)                                                                   | Interface and terminal             | Any file                |
 | [`language`](#language)                                                                               | Have Claude respond in a language other than English                                                                                                                                                                        | Model and responses                | Any file                |
 | [`managedSourcesBehavior`](#managedsourcesbehavior)                                                   | Compose every [managed source](/docs/en/managed-settings#how-claude-code-combines-managed-sources) you deploy instead of using the highest-priority one alone                                                                    | Enterprise and managed settings    | Managed                 |
@@ -787,4 +788,5 @@ scope: "Which settings files can set the key: user (~/.claude/settings.json), pr
 | [`syncClaudeAiSkills`](#syncclaudeaiskills)                                                           | Stop downloading the [skills enabled on your claude.ai account](/docs/en/skills#how-synced-skills-behave) and hide the ones already synced                                                                                       | Plugins and skills                 | User, local, or managed |
 | [`syntaxHighlightingDisabled`](#syntaxhighlightingdisabled)                                           | Turn off syntax highlighting in diffs and code blocks                                                                                                                                                                       | Interface and terminal             | Any file                |
+| [`taskOutputMaxChars`](#taskoutputmaxchars)                                                           | Set how much of a [background task's](/docs/en/tools-reference#background-commands) output Claude receives inline                                                                                                                | Memory and context                 | Any file                |
 | [`teammateDefaultModel`](#teammatedefaultmodel)                                                       | Removed in v2.1.234; see [Specify teammates and models](/docs/en/agent-teams#specify-teammates-and-models) for how Claude Code picks a teammate's model                                                                          | Global config settings             | Global config           |
 | [`teammateMode`](#teammatemode)                                                                       | Choose how [agent team teammates display](/docs/en/agent-teams#choose-a-display-mode)                                                                                                                                            | Agents, sessions, and worktrees    | Any file                |
@@ -1441,5 +1443,5 @@ List the tool uses that prompt you for confirmation even in a permission mode th
 ### `permissions.deny`
 
-List the tool uses Claude Code blocks. Use it for files that hold API keys, secrets, or environment values: Claude Code excludes matching files from file discovery and search results, denies reads of them, and blocks the [Edit and Write tools](/docs/en/permissions#read-and-edit) on the matching paths. Read and Edit deny rules apply to Claude's built-in file tools and to file commands Claude Code recognizes in Bash, such as `cat`, `head`, `tail`, and `sed`; they don't apply to arbitrary subprocesses, so for OS-level enforcement [enable the sandbox](/docs/en/sandboxing).
+List the tool uses Claude Code blocks. Use it for files that hold API keys, secrets, or environment values: Claude Code excludes matching files from file discovery and search results, denies reads of them, and blocks the [Edit and Write tools](/docs/en/permissions#read-and-edit) on the matching paths. Read and Edit deny rules apply to Claude's built-in file tools, to file commands Claude Code recognizes in Bash, such as `cat`, `head`, `tail`, and `sed`, and to the targets of Bash [redirections](/docs/en/permissions#redirections) such as `> file` and `< file`; they don't apply to arbitrary subprocesses, so for OS-level enforcement [enable the sandbox](/docs/en/sandboxing).
 
 * **Scope**: [`Any file`](#scopes)
```

</details>

</details>


<details>
<summary>2026-09-05</summary>

**変更ファイル:**

```
 docs-ja/pages/changelog.md | 70 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 70 insertions(+)
```

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index 3bd3615..8d3f6a0 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,74 @@
 # Changelog
 
+## 2.1.261
+
+- Added an "Organization policy" line to `/status` and `claude doctor` that says why your organization's policy could not be loaded, such as a proxy not passing the endpoint through
+- Added `bashOutputMaxChars` and `taskOutputMaxChars` settings to raise how much command and background-task output Claude receives inline before it is saved to a file, up to 128K characters
+- Added `--append-subagent-system-prompt-file` to read the subagent system prompt from a file, for prompts too large to pass on the command line
+- Added `/skill-doctor` to show which loaded skills go unused and what they cost in context, so you can prune them
+- Fixed typed or pasted characters occasionally landing out of order or being dropped during fast input or key repeat
+- Fixed `/add-dir <subdirectory>` printing a false "couldn't be resolved" error when the working directory is on a `/net` automount
+- Fixed the Bedrock setup wizard hanging when AWS or an AWS credential helper never responds (it now times out with a clear error), and its model checks failing behind a TLS-inspecting proxy
+- Fixed cloud sessions discarding a plugin synced from claude.ai when managed settings force-enable it in `enabledPlugins`, then falling back to a marketplace clone that could fail
+- Fixed being unable to delete the character immediately before an inline `[Image #N]` chip in the prompt input
+- Fixed resuming a session losing hook output and other context around parallel tool calls, which changed the resumed request
+- Fixed Remote Control showing a stale permission mode when a phone, browser, or claude.ai app attaches to a terminal session or after the mode changes in the terminal
+- Fixed Remote Control sessions showing as still working (stuck spinner and Stop button) after stopping a turn from a connected phone or browser, or after a local slash command like `/clear`
+- Fixed SDK and cloud sessions ignoring a Stop or interrupt sent just after the first prompt, before the turn had started; the turn now stops instead of running to completion
+- Fixed Remote Control uploading a session pulled with `/teleport` into the connected session, which appeared appended to the original on phone and web
+- Fixed Remote Control's inbound event stream failing behind TLS-inspecting corporate proxies on native Windows
+- Fixed Remote Control sessions showing the default effort level on claude.ai when the effort comes from settings
+- Fixed `gcpAuthRefresh` opening a browser at startup when the Google credential check was slow, even though the credential was still valid
+- Fixed claude.ai connectors staying absent for the whole session when the startup connector fetch timed out — the CLI now retries in the background
+- Fixed sustained high CPU usage when a background agent could not be resumed and its wake-up was retried in a tight loop
+- Fixed feature flags gated to a newer version occasionally applying to an older Claude Code version running on the same machine
+- Fixed `/usage` and the VS Code usage panel dropping a model-specific weekly limit row when the usage endpoint is rate limited or when opened right after startup
```

</details>

</details>


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

<!-- UPDATE_LOG_END -->
