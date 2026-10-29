> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# すべての設定

> Claude Code の settings.json キーの完全なリファレンス：各キーの場所、型とデフォルト値、貼り付け可能な例、およびすべてのキーのインデックス。

[Back to index](#all-settings)

このリファレンスページでは、Claude Code が設定ファイルから読み込む各キーと、代わりに `~/.claude.json` に保持する[短いキーグループ](#global-config-settings)を一覧表示しています。ファイルを選択するか、優先順位を確認するには、[設定ファイルと優先順位](https://code.claude.com/docs/ja/settings.md)から始めてください。

## 設定インデックス

以下の各キーは、それぞれの項目にリンクしています。Scope 列には、そのキーを記述できる[ファイル](https://code.claude.com/docs/ja/settings.md#settings-files-and-who-they-affect)が示されています。`User` は `~/.claude/settings.json`、`Project` は `.claude/settings.json`、`Local` は `.claude/settings.local.json`、`Managed` は[組織がデプロイするもの](https://code.claude.com/docs/ja/managed-settings.md)です。`Any file` はこの 4 つすべてを意味し、`Global config` は [`~/.claude.json`](#global-config-settings) を意味します。

| Key | Description | Topic | Scope |
| :- | :- | :- | :- |
| [`advisorModel`](#advisormodel) | Claude が [advisor ツール](https://code.claude.com/docs/ja/advisor.md)に問い合わせたときに応答するモデルを選択します | モデルと応答 | Any file |
| [`agent`](#agent) | すべてのセッションを、そのプロンプト、ツール、モデルを備えた名前付き[サブエージェント](https://code.claude.com/docs/ja/sub-agents.md)として開始します | エージェント、セッション、worktree | Any file |
| [`agentPushNotifEnabled`](#agentpushnotifenabled) | Claude が判断したときに[スマートフォンへのプッシュ通知](https://code.claude.com/docs/ja/remote-control.md#mobile-push-notifications)を送信できるようにします | リモート、デスクトップ、通知 | Any file |
| [`allowAllClaudeAiMcps`](#allowallclaudeaimcps) | デプロイされた [`managed-mcp.json`](https://code.claude.com/docs/ja/managed-mcp#exclusive-control-with-managed-mcp-json) と並行して、Claude Code が自ら取得する [claude.ai コネクタ](https://code.claude.com/docs/ja/mcp.md)を読み込みます | MCP | Managed |
| [`allowClaudeInChromeWithManagedMcp`](#allowclaudeinchromewithmanagedmcp) | デプロイされた [`managed-mcp.json`](https://code.claude.com/docs/ja/managed-mcp#exclusive-control-with-managed-mcp-json) と並行して、組み込みの [Claude in Chrome](https://code.claude.com/docs/ja/chrome.md) サーバーを実行できるようにします | MCP | Managed |
| [`allowedChannelPlugins`](#allowedchannelplugins) | メッセージをプッシュできる[チャネルプラグイン](https://code.claude.com/docs/ja/channels.md#restrict-which-channel-plugins-can-run)のデフォルトの許可リストを置き換えます | プラグインとスキル | Managed |
| [`allowedHttpHookUrls`](#allowedhttphookurls) | [HTTP フック](https://code.claude.com/docs/ja/hooks.md)が送信先にできる URL を制限します | フックと自動化 | Any file |
| [`allowedMcpServers`](#allowedmcpservers) | ユーザーが追加できる [MCP サーバー](https://code.claude.com/docs/ja/mcp.md)の許可リストを指定します | MCP | Any file |
| [`allowedProviders`](#allowedproviders) | マシンが使用できる [API プロバイダー](https://code.claude.com/docs/ja/third-party-integrations.md)を制限します | 認証とプロバイダー | Managed |
| [`allowManagedHooksOnly`](#allowmanagedhooksonly) | 組織がデプロイした[フック](https://code.claude.com/docs/ja/hooks.md)のみを実行します | フックと自動化 | Managed |
| [`allowManagedMcpServersOnly`](#allowmanagedmcpserversonly) | 管理された [MCP](https://code.claude.com/docs/ja/mcp.md) 許可リストのみが適用されるようにします | MCP | Managed |
| [`allowManagedPermissionRulesOnly`](#allowmanagedpermissionrulesonly) | [管理設定](https://code.claude.com/docs/ja/managed-settings.md)を[権限ルール](https://code.claude.com/docs/ja/permissions.md#managed-settings)の唯一の設定ソースにします | 権限設定 | Managed |
| [`alwaysThinkingEnabled`](#alwaysthinkingenabled) | すべてのセッションで[拡張思考](https://code.claude.com/docs/ja/model-config.md#extended-thinking)をオフにします | モデルと応答 | Any file |
| [`apiKeyHelper`](#apikeyhelper) | 独自のコマンドで [API 認証情報](https://code.claude.com/docs/ja/authentication.md#credential-management)を生成します | 認証とプロバイダー | Any file |
| [`askUserQuestionTimeout`](#askuserquestiontimeout) | 回答されていない質問が、アイドル時間の経過後に[自動的に続行](https://code.claude.com/docs/ja/tools-reference.md#question-auto-continue-timeout)されるようにします | インターフェースとターミナル | User or managed |
| [`appendPlugins`](#appendplugins) | ユーザーがインストールしたすべての mod の後に、組織の [mod](https://code.claude.com/docs/ja/plugins/mods/admin.md) を実行します | プラグインとスキル | User or managed |
| [`attribution`](#attribution) | Claude Code がコミットとプルリクエストに追加する帰属表示をカスタマイズします | Git と帰属表示 | Any file |
| [`attribution.commit`](#attribution-commit) | Claude Code がコミットに追加するトレーラーを変更または非表示にします | Git と帰属表示 | Any file |
| [`attribution.pr`](#attribution-pr) | プルリクエストの説明にある帰属表示行を変更または非表示にします | Git と帰属表示 | Any file |
| [`attribution.sessionUrl`](#attribution-sessionurl) | [クラウド](https://code.claude.com/docs/ja/claude-code-on-the-web.md)および [Remote Control](https://code.claude.com/docs/ja/remote-control.md) のコミットから claude.ai のセッションリンクを省きます | Git と帰属表示 | Any file |
| [`autoCompactEnabled`](#autocompactenabled) | [自動圧縮](https://code.claude.com/docs/ja/context-window.md)をオフまたはオンにします | メモリとコンテキスト | Any file |
| [`autoCompactWindow`](#autocompactwindow) | Claude Code が[圧縮](https://code.claude.com/docs/ja/context-window.md)を行う前にコンテキストがどの程度埋まるかを設定します | メモリとコンテキスト | Any file |
| [`autoConnectIde`](#autoconnectide) | 外部ターミナルから、実行中の [VS Code](https://code.claude.com/docs/ja/vs-code.md) または [JetBrains](https://code.claude.com/docs/ja/jetbrains.md#from-external-terminals) IDE に自動的に接続します | グローバル設定 | Global config |
| [`autoContinueAtUsageLimit`](#autocontinueatusagelimit) | 開いているセッションで待機し、claude.ai の使用制限がリセットされた後に[タスクを自動的に続行](https://code.claude.com/docs/ja/interactive-mode.md#wait-for-a-usage-limit-to-reset)します | インターフェースとターミナル | User or managed |
| [`autoInstallIdeExtension`](#autoinstallideextension) | VS Code のターミナルからの [IDE 拡張機能](https://code.claude.com/docs/ja/vs-code.md#install-the-extension)の自動インストールをオフにします | グローバル設定 | Global config |
| [`autoMemoryDirectory`](#automemorydirectory) | [自動メモリ](https://code.claude.com/docs/ja/memory.md#auto-memory)を任意のディレクトリに保存します | メモリとコンテキスト | Any file |
| [`autoMemoryEnabled`](#automemoryenabled) | [自動メモリ](https://code.claude.com/docs/ja/memory.md#auto-memory)をオフまたはオンにします | メモリとコンテキスト | Any file |
| [`autoMode`](#automode) | [auto モード](https://code.claude.com/docs/ja/permission-modes.md#eliminate-prompts-with-auto-mode)の分類器に独自の許可ルールと拒否ルールを追加します | 権限設定 | User or managed |
| [`autoMode.classifyAllShell`](#automode-classifyallshell) | 限定的な許可ルールに一致するものも含め、すべてのシェルコマンドを [auto モードの分類器](https://code.claude.com/docs/ja/permission-modes.md#what-the-classifier-blocks-by-default)に送ります | 権限設定 | User or managed |
| [`autoScrollEnabled`](#autoscrollenabled) | フルスクリーンレンダリングで[新しい出力に追従](https://code.claude.com/docs/ja/fullscreen.md#auto-follow)して最下部までスクロールします | インターフェースとターミナル | Any file |
| [`autoUpdatesChannel`](#autoupdateschannel) | latest ではなく stable の[リリースチャネル](https://code.claude.com/docs/ja/setup.md#configure-release-channel)に従います | 更新とバージョン管理 | Any file |
| [`availableModels`](#availablemodels) | ユーザーが選択できる[モデルを制限](https://code.claude.com/docs/ja/model-config.md#restrict-model-selection)します | モデルと応答 | Any file |
| [`availableModelsMatch`](#availablemodelsmatch) | `availableModels` の各モデル ID エントリが、[その名前が示すバージョンのみを許可](https://code.claude.com/docs/ja/model-config.md#block-specific-models-or-versions)するようにします | モデルと応答 | Managed |
| [`awaySummaryEnabled`](#awaysummaryenabled) | ターミナルに戻ったときに表示される[セッションの要約](https://code.claude.com/docs/ja/interactive-mode.md#session-recap)をオフにします | リモート、デスクトップ、通知 | Any file |
| [`awsAuthRefresh`](#awsauthrefresh) | 独自のコマンドで、`.aws` 内の期限切れの [Bedrock 認証情報](https://code.claude.com/docs/ja/amazon-bedrock.md#advanced-credential-configuration)を更新します | 認証とプロバイダー | Any file |
| [`awsCredentialExport`](#awscredentialexport) | 独自のコマンドから [Bedrock 認証情報](https://code.claude.com/docs/ja/amazon-bedrock.md#advanced-credential-configuration)を JSON として提供します | 認証とプロバイダー | Any file |
| [`axScreenReader`](#axscreenreader) | [スクリーンリーダーに適した出力](https://code.claude.com/docs/ja/accessibility.md)をレンダリングします | インターフェースとターミナル | User or managed |
| [`bashEditDiffEnabled`](#basheditdiffenabled) | すべての権限モードで、[Bash コマンドの実行中に変更されたファイル](https://code.claude.com/docs/ja/hooks.md#bash)を記録します | インターフェースとターミナル | User or managed |
| [`bashOutputMaxChars`](#bashoutputmaxchars) | 成功したコマンドの[出力](https://code.claude.com/docs/ja/tools-reference.md#output-limits)のうち、Claude がインラインで受け取る量を設定します | メモリとコンテキスト | Any file |
| [`blockedMarketplaces`](#blockedmarketplaces) | 組織に対して[プラグインマーケットプレイス](https://code.claude.com/docs/ja/plugins/overview.md)のソースをブロックします | プラグインとスキル | Managed |
| [`browserExternalPageTools`](#browserexternalpagetools) | [デスクトップ](https://code.claude.com/docs/ja/desktop.md)の Browser ペインで、Claude のツールが外部ページで動作しないようにします | ツール | Managed |
| [`channelsEnabled`](#channelsenabled) | 組織で[チャネル](https://code.claude.com/docs/ja/channels.md#enable-channels-for-your-organization)を許可します | プラグインとスキル | Managed |
| [`claudeInChromeDefaultEnabled`](#claudeinchromedefaultenabled) | 対話型 CLI と VS Code 拡張機能で、セッションの開始時に [Chrome 統合](https://code.claude.com/docs/ja/chrome.md)をオンにします | グローバル設定 | Global config |
| [`claudeMd`](#claudemd) | 管理設定から組織全体の [CLAUDE.md](https://code.claude.com/docs/ja/memory.md#deploy-organization-wide-claude-md) の指示を注入します | メモリとコンテキスト | Managed |
| [`claudeMdExcludes`](#claudemdexcludes) | メモリの読み込み時に特定の [CLAUDE.md](https://code.claude.com/docs/ja/memory.md#exclude-specific-claude-md-files) ファイルをスキップします | メモリとコンテキスト | Any file |
| [`cleanupPeriodDays`](#cleanupperioddays) | Claude Code が[トランスクリプト](https://code.claude.com/docs/ja/data-usage.md#data-retention)を削除するまで保持する日数を選択します | プライバシーとテレメトリ | Any file |
| [`companyAnnouncements`](#companyannouncements) | 起動時に組織のお知らせを表示します | インターフェースとターミナル | Any file |
| [`copyFullResponse`](#copyfullresponse) | [`/copy`](https://code.claude.com/docs/ja/commands) がピッカーを表示せずに応答全体をコピーするようにします | グローバル設定 | Global config |
| [`copyOnSelect`](#copyonselect) | [フルスクリーンレンダリング](https://code.claude.com/docs/ja/fullscreen.md#use-the-mouse)とエージェントビューで、マウスで選択したテキストの自動コピーをオフにします | グローバル設定 | Global config |
| [`crossSessionInbound`](#crosssessioninbound) | Claude Code が[他のセッションからのメッセージ](https://code.claude.com/docs/ja/cross-session-messaging.md#control-inbound-messages)を配信するか、配信せずに通知を表示するか、拒否するかを選択します | エージェント、セッション、worktree | Any file |
| [`defaultShell`](#defaultshell) | [`!` プレフィックス](https://code.claude.com/docs/ja/interactive-mode#shell-mode-with-prefix)で入力したシェルコマンドを Bash と PowerShell のどちらで実行するかを選択します | インターフェースとターミナル | Any file |
| [`defaultToAgentsView`](#defaulttoagentsview) | 引数なしで `claude` を実行したときに、新しい会話ではなく[エージェントビュー](https://code.claude.com/docs/ja/agent-view.md)を開きます | グローバル設定 | Global config |
| [`deniedMcpServers`](#deniedmcpservers) | URL、コマンド、または名前で特定の [MCP サーバー](https://code.claude.com/docs/ja/mcp.md)をブロックします | MCP | Any file |
| [`deniedModels`](#deniedmodels) | `availableModels` で許可されているものも含め、[特定のモデルをブロック](https://code.claude.com/docs/ja/model-config.md#block-specific-models-or-versions)します | モデルと応答 | Managed |
| [`desktopSessionCleanupPeriodDays`](#desktopsessioncleanupperioddays) | [Claude Desktop と Cowork のトランスクリプト](https://code.claude.com/docs/ja/claude-directory.md#cleaned-up-automatically)の保持期間の上限を日数で設定します | プライバシーとテレメトリ | User or managed |
| [`dialogExpiry`](#dialogexpiry) | 転送されたダイアログに [Remote Control](https://code.claude.com/docs/ja/remote-control.md) または SDK ホストが応答するまで、Claude Code がダイアログをキャンセルせずに待機する時間を設定します | インターフェースとターミナル | User or managed |
| [`diffTool`](#difftool) | Claude が提案するファイル変更を [VS Code](https://code.claude.com/docs/ja/vs-code.md) または [JetBrains](https://code.claude.com/docs/ja/jetbrains.md#features) の差分ビューアーで開くか、ターミナルに表示したままにするかを選択します | グローバル設定 | Global config |
| [`disableAgentView`](#disableagentview) | バックグラウンドエージェントと[エージェントビュー](https://code.claude.com/docs/ja/agent-view.md)をオフにします | エージェント、セッション、worktree | Any file |
| [`disableAllHooks`](#disableallhooks) | [フック](https://code.claude.com/docs/ja/hooks.md)、カスタム[ステータスライン](https://code.claude.com/docs/ja/statusline.md)、カスタム [`@` ファイル候補](https://code.claude.com/docs/ja/interactive-mode#quick-commands)コマンドをまとめてオフにします | フックと自動化 | Any file |
| [`disableArtifact`](#disableartifact) | 非推奨です。[Artifact ツール](https://code.claude.com/docs/ja/artifacts.md)をオフにするには `enableArtifact` を使用してください | リモート、デスクトップ、通知 | Any file |
| [`disableAutoMode`](#disableautomode) | 権限モードの切り替えサイクルから [auto モード](https://code.claude.com/docs/ja/permission-modes.md#eliminate-prompts-with-auto-mode)を除外します | 権限設定 | Any file |
| [`disableBrowserExternalNavigation`](#disablebrowserexternalnavigation) | [デスクトップ](https://code.claude.com/docs/ja/desktop.md)の Browser ペインを、ユーザーと Claude の両方について localhost に制限します | ツール | Managed |
| [`disableBundledSkills`](#disablebundledskills) | Claude Code に含まれる[スキル](https://code.claude.com/docs/ja/skills.md#bundled-skills)と[ワークフロー](https://code.claude.com/docs/ja/workflows.md)をオフにします | プラグインとスキル | Any file |
| [`disableClaudeAiConnectors`](#disableclaudeaiconnectors) | [claude.ai コネクタ](https://code.claude.com/docs/ja/mcp.md#disable-claude-ai-connectors)をオフにし、Claude Code がそれらを取得しないようにします | MCP | Any file |
| [`disableCommandPluginSources`](#disablecommandpluginsources) | マーケットプレイスで宣言されたコマンドを実行してインストールする[プラグイン](https://code.claude.com/docs/ja/plugins/overview.md)をブロックします | プラグインとスキル | Managed |
| [`disableDeepLinkRegistration`](#disabledeeplinkregistration) | Claude Code が [`claude-cli://` ハンドラー](https://code.claude.com/docs/ja/deep-links)を登録しないようにします | リモート、デスクトップ、通知 | Any file |
| [`disableDesktopLocalSessions`](#disabledesktoplocalsessions) | デバイス上で実行される [Desktop の Code セッション](https://code.claude.com/docs/ja/desktop.md#local-sessions-on-managed-devices)をオフにし、他のホストへの SSH とクラウドのみを残します | リモート、デスクトップ、通知 | Managed |
| [`disabledMcpjsonServers`](#disabledmcpjsonservers) | プロジェクトの [`.mcp.json`](https://code.claude.com/docs/ja/mcp#project-scope) にある特定のサーバーを拒否します | MCP | Any file |
| [`disableMobileSimulatorTools`](#disablemobilesimulatortools) | [デスクトップ](https://code.claude.com/docs/ja/desktop.md)の iOS Simulator ペインで Claude のツールをブロックします | ツール | Managed |
| [`disableRemoteControl`](#disableremotecontrol) | [Remote Control](https://code.claude.com/docs/ja/remote-control.md) を、起動可能なすべての場所でオフにします | リモート、デスクトップ、通知 | Any file |
| [`disableSideloadFlags`](#disablesideloadflags) | [プラグイン](https://code.claude.com/docs/ja/plugins/overview.md)、[サブエージェント](https://code.claude.com/docs/ja/sub-agents.md)、[MCP サーバー](https://code.claude.com/docs/ja/mcp.md)をサイドロードする CLI フラグを拒否します | エンタープライズと管理設定 | Managed |
| [`disableSkillShellExecution`](#disableskillshellexecution) | [スキル](https://code.claude.com/docs/ja/skills.md)とカスタムコマンドがインラインでシェルを実行しないようにします | プラグインとスキル | Any file |
| [`disableWorkflows`](#disableworkflows) | [動的ワークフロー](https://code.claude.com/docs/ja/workflows.md)を全員に対してオフにします。自分だけに適用するには `enableWorkflows` を使用してください | フックと自動化 | Any file |
| [`editorMode`](#editormode) | 入力プロンプトで [vim キーバインド](https://code.claude.com/docs/ja/interactive-mode.md#vim-editor-mode)を使用します | インターフェースとターミナル | Any file |
| [`effortLevel`](#effortlevel) | 独自に保存されたレベルを持たないモデルに対して、デフォルトの [effort レベル](https://code.claude.com/docs/ja/model-config.md#adjust-effort-level)を設定します | モデルと応答 | Any file |
| [`emojiCompletionEnabled`](#emojicompletionenabled) | プロンプト入力での [`:shortcode:` 絵文字の候補表示と置換](https://code.claude.com/docs/ja/interactive-mode#emoji-shortcodes)をオフにします | インターフェースとターミナル | Any file |
| [`enableAllProjectMcpServers`](#enableallprojectmcpservers) | プロジェクトの [`.mcp.json`](https://code.claude.com/docs/ja/mcp#project-server-approvals-and-workspace-trust) ファイル内のすべてのサーバーを、プロンプトなしで承認します | MCP | Any file |
| [`enableArtifact`](#enableartifact) | いずれかのファイルで `false` を指定すると [Artifact ツール](https://code.claude.com/docs/ja/artifacts.md)をオフにします。どのファイルからも再びオンにすることはできません | リモート、デスクトップ、通知 | Any file |
| [`enabledMcpjsonServers`](#enabledmcpjsonservers) | プロジェクトの [`.mcp.json`](https://code.claude.com/docs/ja/mcp#project-server-approvals-and-workspace-trust) にある特定のサーバーを承認します | MCP | Any file |
| [`enabledPlugins`](#enabledplugins) | 個々の[プラグイン](https://code.claude.com/docs/ja/plugins/overview.md)をスコープごとにオンまたはオフにします | プラグインとスキル | Any file |
| [`enableWorkflows`](#enableworkflows) | プランのデフォルトに対して[動的ワークフロー](https://code.claude.com/docs/ja/workflows.md)をオンまたはオフにします | フックと自動化 | Any file |
| [`enforceAvailableModels`](#enforceavailablemodels) | [`/model` の Default の選択肢](https://code.claude.com/docs/ja/model-config#enforce-the-allowlist-for-the-default-model)を `availableModels` 許可リストの範囲内に保ちます | モデルと応答 | Any file |
| [`env`](#env) | すべてのセッションとそのサブプロセスに対して[環境変数](https://code.claude.com/docs/ja/env-vars.md#in-settings-files)を設定します | メモリとコンテキスト | Any file |
| [`externalEditorContext`](#externaleditorcontext) | [Ctrl+G](https://code.claude.com/docs/ja/interactive-mode.md#general-controls) を押して編集するときに、Claude の直前の応答をコメントとして表示します | グローバル設定 | Global config |
| [`extraKnownMarketplaces`](#extraknownmarketplaces) | リポジトリまたは組織に対して[マーケットプレイス](https://code.claude.com/docs/ja/plugins/overview.md)を登録します | プラグインとスキル | Any file |
| [`fallbackModel`](#fallbackmodel) | プライマリモデルが過負荷のときに使う[バックアップモデル](https://code.claude.com/docs/ja/model-config.md#fallback-model-chains)を指定します | モデルと応答 | Any file |
| [`fastMode`](#fastmode) | 利用可能なセッションで [fast mode](https://code.claude.com/docs/ja/fast-mode.md) をオンにします | モデルと応答 | Any file |
| [`fastModePerSessionOptIn`](#fastmodepersessionoptin) | セッションごとに [fast mode](https://code.claude.com/docs/ja/fast-mode.md) をオンにすることを必須にします | モデルと応答 | Any file |
| [`feedbackDrafts`](#feedbackdrafts) | Claude がレビュー用の[フィードバックの下書き](https://code.claude.com/docs/ja/tools-reference.md#sendfeedback-tool-behavior)をキューに入れるかどうかを制御します | プライバシーとテレメトリ | User or managed |
| [`feedbackSurveyRate`](#feedbacksurveyrate) | [セッション品質アンケート](https://code.claude.com/docs/ja/data-usage.md#session-quality-surveys)が表示される頻度を変更します | プライバシーとテレメトリ | Any file |
| [`fileCheckpointingEnabled`](#filecheckpointingenabled) | [`/rewind`](https://code.claude.com/docs/ja/checkpointing) が復元するファイルスナップショットをオフまたはオンにします | メモリとコンテキスト | Any file |
| [`fileSuggestion`](#filesuggestion) | 独自のコマンドから [`@` ファイルのオートコンプリート](https://code.claude.com/docs/ja/interactive-mode#quick-commands)を提供します | インターフェースとターミナル | Any file |
| [`footerLinksRegexes`](#footerlinksregexes) | 出力内の issue やレビューの ID を、入力ボックスの下にある[クリック可能なリンク](https://code.claude.com/docs/ja/statusline.md#clickable-links)にします | インターフェースとターミナル | User or managed |
| [`forceLoginGatewayUrl`](#forcelogingatewayurl) | ログイン画面が接続する[ゲートウェイ URL](https://code.claude.com/docs/ja/claude-apps-gateway#set-the-gateway-url) を設定します | 認証とプロバイダー | User or managed |
| [`forceLoginMethod`](#forceloginmethod) | [ログインを](https://code.claude.com/docs/ja/authentication.md#restrict-login-to-your-organization) claude.ai、Claude Console、または[クラウドゲートウェイ](https://code.claude.com/docs/ja/claude-apps-gateway)に制限します | 認証とプロバイダー | Any file |
| [`forceLoginOrgUUID`](#forceloginorguuid) | [claude.ai のログインを組織に固定](https://code.claude.com/docs/ja/authentication.md#restrict-login-to-your-organization)します。これを強制できるのは管理ソースのみです | 認証とプロバイダー | Any file |
| [`forceRemoteSettingsRefresh`](#forceremotesettingsrefresh) | [サーバー管理設定](https://code.claude.com/docs/ja/server-managed-settings.md)が新たに取得されるまで起動をブロックします | エンタープライズと管理設定 | Managed |
| [`gatewayInternalNetworks`](#gatewayinternalnetworks) | 組織が内部で使用しているパブリック IPv4 空間上の[クラウドゲートウェイ](https://code.claude.com/docs/ja/claude-apps-gateway#allow-a-gateway-on-public-address-space-you-own)に `/login` が到達できるようにします | 認証とプロバイダー | Managed |
| [`gcpAuthRefresh`](#gcpauthrefresh) | 独自のコマンドで [Google Cloud の認証情報](https://code.claude.com/docs/ja/google-vertex-ai.md#advanced-credential-configuration)を更新します | 認証とプロバイダー | Any file |
| [`hooks`](#hooks) | Claude Code のライフサイクルの各時点で、独自のコマンドを[フック](https://code.claude.com/docs/ja/hooks.md)として実行します | フックと自動化 | Any file |
| [`httpHookAllowedEnvVars`](#httphookallowedenvvars) | [HTTP フック](https://code.claude.com/docs/ja/hooks.md)がヘッダーに含められる環境変数を制限します | フックと自動化 | Any file |
| [`idleCompaction`](#idlecompaction) | 席を外している間に、Claude Code が長い会話を圧縮しないようにします | メモリとコンテキスト | Any file |
| [`includeCoAuthoredBy`](#includecoauthoredby) | 非推奨です。コミットと PR の帰属表示を非表示にしたり変更したりするには `attribution` を使用してください | Git と帰属表示 | Any file |
| [`includeGitInstructions`](#includegitinstructions) | 組み込みのコミットおよび PR の指示を Claude のコンテキストから除外します | Git と帰属表示 | Any file |
| [`inputNeededNotifEnabled`](#inputneedednotifenabled) | Claude がユーザーの入力を待っているときに[プッシュ通知](https://code.claude.com/docs/ja/remote-control.md#mobile-push-notifications)を受け取ります | リモート、デスクトップ、通知 | Any file |
| [`isolatePeerMachines`](#isolatepeermachines) | Claude が[別のマシン上の自分のセッションにメッセージを送る](https://code.claude.com/docs/ja/cross-session-messaging.md#require-approval-for-cross-machine-messages)前に確認を求めます | エージェント、セッション、worktree | Any file |
| [`keybindingFlavor`](#keybindingflavor) | 非推奨で、効果はありません。単語編集のショートカットは常に [readline の規則に従います](https://code.claude.com/docs/ja/interactive-mode.md#make-ctrl-w-delete-back-to-whitespace) | インターフェースとターミナル | Any file |
| [`language`](#language) | Claude に英語以外の言語で応答させます | モデルと応答 | Any file |
| [`leftArrowOpensAgents`](#leftarrowopensagents) | [セッションをバックグラウンドに移してエージェントビューを開く](https://code.claude.com/docs/ja/agent-view.md#switch-sessions-without-leaving-the-terminal) `←` ショートカットをオフにします | グローバル設定 | Global config |
| [`managedMcpServers`](#managedmcpservers) | ユーザーが追加するものに加えて、すべてのユーザーにリモート [MCP サーバー](https://code.claude.com/docs/ja/managed-mcp.md#provide-servers-through-managed-settings)を提供します | MCP | Managed |
| [`managedSourcesBehavior`](#managedsourcesbehavior) | 優先度が最も高いものだけを使うのではなく、デプロイしたすべての[管理ソース](https://code.claude.com/docs/ja/managed-settings.md#how-claude-code-combines-managed-sources)を組み合わせます | エンタープライズと管理設定 | Managed |
| [`maxEffortLevel`](#maxeffortlevel) | すべてのプロバイダーで、すべてのモデルまたはモデルごとに [effort レベル](https://code.claude.com/docs/ja/model-config.md#adjust-effort-level)の上限を設定します | モデルと応答 | Any file |
| [`maxProseWidth`](#maxprosewidth) | 幅の広いターミナルで、Claude の応答の文章部分の幅に上限を設定します | インターフェースとターミナル | Any file |
| [`minimumVersion`](#minimumversion) | [自動更新](https://code.claude.com/docs/ja/setup.md#pin-a-minimum-version)で指定バージョン未満のものがインストールされないようにします | 更新とバージョン管理 | Any file |
| [`model`](#model) | Claude Code の起動時に使用する[モデル](https://code.claude.com/docs/ja/model-config.md#set-a-default-model-for-new-sessions)を変更します | モデルと応答 | Any file |
| [`modelOverrides`](#modeloverrides) | [モデル ID を](https://code.claude.com/docs/ja/model-config.md#override-model-ids-per-version) Bedrock の ARN などのプロバイダーの ID に対応付けます | モデルと応答 | Any file |
| [`modelPicker`](#modelpicker) | [`/model` ピッカー](https://code.claude.com/docs/ja/model-config#available-models)に表示するモデルを、独自の順序とラベルで選択します | モデルと応答 | User or managed |
| [`modelPricing`](#modelpricing) | 定価ではなく、組織の契約料金で支出を報告します | モデルと応答 | Managed |
| [`modelSettings`](#modelsettings) | モデルごとに保存された [effort レベル](https://code.claude.com/docs/ja/model-config.md#adjust-effort-level)または[自動圧縮ウィンドウ](https://code.claude.com/docs/ja/model-config.md#set-the-auto-compact-window)を保持するか、特定のモデルの effort に上限を設定します | モデルと応答 | Any file |
| [`otelHeadersHelper`](#otelheadershelper) | 独自のコマンドで、ローテーションする [OpenTelemetry](https://code.claude.com/docs/ja/monitoring-usage.md#dynamic-headers) ヘッダーを生成します | 認証とプロバイダー | Any file |
| [`outputStyle`](#outputstyle) | [出力スタイル](https://code.claude.com/docs/ja/output-styles.md)で Claude の役割、トーン、出力形式を変更します | モデルと応答 | Any file |
| [`parentSettingsBehavior`](#parentsettingsbehavior) | [管理設定](https://code.claude.com/docs/ja/managed-settings.md)をデプロイする際に、[SDK または IDE ホスト](https://code.claude.com/docs/ja/managed-settings.md#let-an-embedding-host-add-policy)が渡す制限を適用するか破棄するかを指定します | エンタープライズと管理設定 | Managed |
| [`permissionExplainerEnabled`](#permissionexplainerenabled) | v2.1.257 で、シェルの権限プロンプトにおける `Ctrl+E` のコマンド説明とともに削除されました | グローバル設定 | Global config |
| [`permissions`](#permissions) | 許可ルール、確認ルール、拒否ルールと、開始時の[権限モード](https://code.claude.com/docs/ja/permission-modes.md)を設定します | 権限設定 | Any file |
| [`permissions.additionalDirectories`](#permissions-additionaldirectories) | [現在のディレクトリ以外のディレクトリ](https://code.claude.com/docs/ja/permissions.md#working-directories)へのファイルアクセスを Claude に与えます | 権限設定 | Any file |
| [`permissions.allow`](#permissions-allow) | 列挙した[ツールの使用](https://code.claude.com/docs/ja/permissions.md#permission-rule-syntax)をプロンプトなしで承認します | 権限設定 | Any file |
| [`permissions.ask`](#permissions-ask) | 列挙した[ツールの使用](https://code.claude.com/docs/ja/permissions.md#permission-rule-syntax)の前に常にプロンプトを表示します | 権限設定 | Any file |
| [`permissions.blockReadsOutsideWorkingDirectories`](#permissions-blockreadsoutsideworkingdirectories) | すべての権限モードで、ファイルツールが[作業ディレクトリ](https://code.claude.com/docs/ja/permissions.md#working-directories)外の読み取りを拒否するようにします | 権限設定 | Any file |
| [`permissions.defaultMode`](#permissions-defaultmode) | 新しいセッションの開始時の[権限モード](https://code.claude.com/docs/ja/permission-modes.md#which-mode-a-session-starts-in)を設定します | 権限設定 | Any file |
| [`permissions.deny`](#permissions-deny) | シークレットを保持するファイルの読み取りを含め、列挙した[ツールの使用](https://code.claude.com/docs/ja/permissions.md#permission-rule-syntax)をブロックします | 権限設定 | Any file |
| [`permissions.disableBypassPermissionsMode`](#permissions-disablebypasspermissionsmode) | 誰も [bypassPermissions モード](https://code.claude.com/docs/ja/permission-modes.md#skip-all-checks-with-bypasspermissions-mode)に入れないようにします | 権限設定 | Any file |
| [`plansDirectory`](#plansdirectory) | [plan モード](https://code.claude.com/docs/ja/permission-modes.md#analyze-before-you-edit-with-plan-mode)がプランファイルを書き込む場所を選択します | メモリとコンテキスト | Any file |
| [`pluginConfigs`](#pluginconfigs) | [プラグイン](https://code.claude.com/docs/ja/plugins/overview.md)の設定ダイアログで入力した回答を保存します | プラグインとスキル | User or managed |
| [`pluginSuggestionMarketplaces`](#pluginsuggestionmarketplaces) | `/plugin` でプラグインのインストール候補を表示できる[マーケットプレイス](https://code.claude.com/docs/ja/plugins/org.md#restrict-what-users-can-install)を選択します | プラグインとスキル | Managed |
| [`pluginTrustMessage`](#plugintrustmessage) | [プラグイン](https://code.claude.com/docs/ja/plugins/overview.md)の信頼に関する警告に独自のテキストを追加します | プラグインとスキル | Managed |
| [`policyHelper`](#policyhelper) | 起動時に[管理設定](https://code.claude.com/docs/ja/managed-settings.md#compute-the-policy-with-a-helper-program)を算出する実行ファイルを実行します | エンタープライズと管理設定 | Managed |
| [`policyHelper.path`](#policyhelper-path) | Claude Code が実行する[ヘルパー実行ファイル](https://code.claude.com/docs/ja/managed-settings.md#compute-the-policy-with-a-helper-program)を指定します | エンタープライズと管理設定 | Managed |
| [`policyHelper.refreshIntervalMs`](#policyhelper-refreshintervalms) | [ヘルパー](https://code.claude.com/docs/ja/managed-settings.md#compute-the-policy-with-a-helper-program)をバックグラウンドで一定間隔ごとに再実行します | エンタープライズと管理設定 | Managed |
| [`policyHelper.timeoutMs`](#policyhelper-timeoutms) | Claude Code が[ヘルパー](https://code.claude.com/docs/ja/managed-settings.md#compute-the-policy-with-a-helper-program)を待機する時間を設定します | エンタープライズと管理設定 | Managed |
| [`preferredNotifChannel`](#preferrednotifchannel) | タスク完了時の通知として、[ターミナルベルまたはデスクトップ通知](https://code.claude.com/docs/ja/terminal-config.md#get-a-terminal-bell-or-notification)を選択します | リモート、デスクトップ、通知 | Any file |
| [`prefersReducedMotion`](#prefersreducedmotion) | スピナー、シマー、フラッシュのアニメーションを[抑えるかオフにします](https://code.claude.com/docs/ja/accessibility.md#accessibility-settings) | インターフェースとターミナル | Any file |
| [`prependPlugins`](#prependplugins) | ユーザーがインストールしたすべての mod の前に、組織の [mod](https://code.claude.com/docs/ja/plugins/mods/admin.md) を実行します | プラグインとスキル | User or managed |
| [`processWrapper`](#processwrapper) | macOS と Linux で、Claude Code のバックグラウンドプロセスを[企業ランチャー](https://code.claude.com/docs/ja/corporate-launcher.md)経由で実行します | エージェント、セッション、worktree | User or managed |
| [`promptCacheTtl`](#promptcachettl) | メインの会話の[プロンプトキャッシュの有効期間](https://code.claude.com/docs/ja/prompt-caching.md#cache-lifetime)を選択します | モデルと応答 | Any file |
| [`promptSuggestionEnabled`](#promptsuggestionenabled) | 入力ボックスにグレー表示される[プロンプト候補](https://code.claude.com/docs/ja/interactive-mode.md#prompt-suggestions)を非表示にします | インターフェースとターミナル | Any file |
| [`prStatusFooterEnabled`](#prstatusfooterenabled) | プロンプトフッターの [PR レビューステータス](https://code.claude.com/docs/ja/interactive-mode.md#pr-review-status)バッジと、その背後にあるプルリクエストのチェックをオフにします | グローバル設定 | Global config |
| [`prUrlTemplate`](#prurltemplate) | PR リンクの参照先を github.com ではなく社内のコードレビューツールにします | Git と帰属表示 | Any file |
| [`remote.defaultEnvironmentId`](#remote-defaultenvironmentid) | `claude --cloud` のデフォルトの[クラウド環境](https://code.claude.com/docs/ja/cloud-environments.md)を選択します。セルフホストの `ccpool_` ID は、ユーザー設定、管理設定、`--settings` からのみ読み取られます | リモート、デスクトップ、通知 | Any file |
| [`remoteControlAtStartup`](#remotecontrolatstartup) | セッションの開始時に [Remote Control](https://code.claude.com/docs/ja/remote-control.md#enable-remote-control-for-all-sessions) に自動的に接続します | リモート、デスクトップ、通知 | Any file |
| [`requiredMaximumVersion`](#requiredmaximumversion) | 組織が許可するバージョンより新しいバージョンでは[起動を拒否](https://code.claude.com/docs/ja/setup.md#pin-a-minimum-version)します | 更新とバージョン管理 | Managed |
| [`requiredMinimumVersion`](#requiredminimumversion) | 組織が要求するバージョンより古いバージョンでは[起動を拒否](https://code.claude.com/docs/ja/setup.md#pin-a-minimum-version)します | 更新とバージョン管理 | Managed |
| [`respectGitignore`](#respectgitignore) | gitignore されたファイルを [`@` ファイルピッカー](https://code.claude.com/docs/ja/interactive-mode#quick-commands)から除外します | インターフェースとターミナル | Any file |
| [`respondToBashCommands`](#respondtobashcommands) | [`!` シェルコマンド](https://code.claude.com/docs/ja/interactive-mode#shell-mode-with-prefix)の実行後に Claude が応答しないようにします | インターフェースとターミナル | Any file |
| [`sandbox`](#sandbox) | macOS、Linux、WSL2 で、[Bash コマンドを](https://code.claude.com/docs/ja/sandboxing.md)ファイルシステムやネットワークから隔離します | サンドボックス設定 | Any file |
| [`sandbox.allowAppleEvents`](#sandbox-allowappleevents) | macOS で、[サンドボックス化](https://code.claude.com/docs/ja/sandboxing.md)されたコマンドが Apple Events を送信できるようにします | サンドボックス設定 | User or managed |
| [`sandbox.allowNestedUserNamespaces`](#sandbox-allownestedusernamespaces) | Linux と WSL2 で、[サンドボックス化](https://code.claude.com/docs/ja/sandboxing.md#chromium-or-rootless-podman-fails-inside-the-sandbox-on-linux)されたコマンドがユーザー名前空間を作成できるようにします | サンドボックス設定 | User or managed |
| [`sandbox.allowUnsandboxedCommands`](#sandbox-allowunsandboxedcommands) | ブロックされたコマンドを Claude が[サンドボックス](https://code.claude.com/docs/ja/sandboxing.md#the-unsandboxed-retry-escape-hatch)外で再試行できるようにするか、禁止します | サンドボックス設定 | Any file |
| [`sandbox.autoAllowBashIfSandboxed`](#sandbox-autoallowbashifsandboxed) | [サンドボックス化](https://code.claude.com/docs/ja/sandboxing.md#auto-allow-mode)されたコマンドを権限プロンプトなしで実行します | サンドボックス設定 | Any file |
| [`sandbox.bwrapPath`](#sandbox-bwrappath) | [サンドボックス](https://code.claude.com/docs/ja/sandboxing.md)が `PATH` 外にある bubblewrap バイナリを使用するよう指定します | サンドボックス設定 | Managed |
| [`sandbox.credentials`](#sandbox-credentials) | [サンドボックス](https://code.claude.com/docs/ja/sandboxing.md#protect-credentials)内で認証情報ファイルや変数を非表示にするかマスクします | サンドボックス設定 | Any file |
| [`sandbox.credentials.allowPlaintextInject`](#sandbox-credentials-allowplaintextinject) | 信頼できるテストネットワーク上で、[マスクされた認証情報](https://code.claude.com/docs/ja/sandboxing.md#mask-credentials)がプレーンな HTTP サービスに届くようにします | サンドボックス設定 | User or managed |
| [`sandbox.credentials.awsPairs`](#sandbox-credentials-awspairs) | カスタム名の AWS キー変数を、[再署名](https://code.claude.com/docs/ja/sandboxing.md#re-sign-aws-requests)用に 1 つの認証情報として関連付けます | サンドボックス設定 | User or managed |
| [`sandbox.credentials.envVars`](#sandbox-credentials-envvars) | [サンドボックス](https://code.claude.com/docs/ja/sandboxing.md#mask-environment-variables)内で環境変数を未設定にするかマスクします | サンドボックス設定 | Any file |
| [`sandbox.credentials.files`](#sandbox-credentials-files) | [サンドボックス](https://code.claude.com/docs/ja/sandboxing.md#mask-credential-files)内で認証情報ファイルの読み取りをブロックするかマスクします | サンドボックス設定 | Any file |
| [`sandbox.credentials.sigv4`](#sandbox-credentials-sigv4) | ストリーミング、署名付き、または [SigV4A の AWS リクエスト](https://code.claude.com/docs/ja/sandboxing.md#re-sign-aws-requests)を失敗させるか通過させるかを選択します | サンドボックス設定 | User or managed |
| [`sandbox.enabled`](#sandbox-enabled) | macOS、Linux、WSL2 で [Bash のサンドボックス化](https://code.claude.com/docs/ja/sandboxing.md#get-started)をオンにします | サンドボックス設定 | Any file |
| [`sandbox.enableWeakerNestedSandbox`](#sandbox-enableweakernestedsandbox) | 非特権コンテナ内で Linux の[サンドボックス](https://code.claude.com/docs/ja/sandboxing.md)を実行します | サンドボックス設定 | Any file |
| [`sandbox.enableWeakerNetworkIsolation`](#sandbox-enableweakernetworkisolation) | macOS の[サンドボックス](https://code.claude.com/docs/ja/sandboxing.md#go-based-clis-fail-tls-verification-on-macos)内で、`gh`、`gcloud`、`terraform` が MITM プロキシ経由で TLS を検証できるようにします | サンドボックス設定 | Any file |
| [`sandbox.excludedCommands`](#sandbox-excludedcommands) | Claude Code が[サンドボックス](https://code.claude.com/docs/ja/sandboxing.md)外で実行できるコマンドを指定します | サンドボックス設定 | Any file |
| [`sandbox.failIfUnavailable`](#sandbox-failifunavailable) | [サンドボックス](https://code.claude.com/docs/ja/sandboxing.md)を開始できない場合、サンドボックスなしで実行するのではなく起動を拒否します | サンドボックス設定 | Any file |
| [`sandbox.filesystem`](#sandbox-filesystem) | [サンドボックス化](https://code.claude.com/docs/ja/sandboxing.md#filesystem-isolation)されたコマンドが読み書きできるパスを制御します | サンドボックス設定 | Any file |
| [`sandbox.filesystem.allowManagedReadPathsOnly`](#sandbox-filesystem-allowmanagedreadpathsonly) | [組織がブロックした読み取りパス](https://code.claude.com/docs/ja/sandboxing.md#keep-developers-from-widening-the-policy)を開発者が再び開けないようにします | サンドボックス設定 | Managed |
| [`sandbox.filesystem.allowRead`](#sandbox-filesystem-allowread) | [`denyRead`](#sandbox-filesystem-denyread) がブロックする領域内で読み取りを再び許可します | サンドボックス設定 | Any file |
| [`sandbox.filesystem.allowWrite`](#sandbox-filesystem-allowwrite) | [サンドボックス化](https://code.claude.com/docs/ja/sandboxing.md)されたコマンドが書き込めるパスを追加します | サンドボックス設定 | Any file |
| [`sandbox.filesystem.denyRead`](#sandbox-filesystem-denyread) | [サンドボックス化](https://code.claude.com/docs/ja/sandboxing.md)されたコマンドが特定のパスを読み取らないようブロックします | サンドボックス設定 | Any file |
| [`sandbox.filesystem.denyWrite`](#sandbox-filesystem-denywrite) | [サンドボックス化](https://code.claude.com/docs/ja/sandboxing.md)されたコマンドが特定のパスに書き込まないようブロックします | サンドボックス設定 | Any file |
| [`sandbox.filesystem.disabled`](#sandbox-filesystem-disabled) | ネットワークの隔離を維持したまま、[ファイルシステムの隔離をオフにします](https://code.claude.com/docs/ja/sandboxing.md#disable-filesystem-isolation) | サンドボックス設定 | User or managed |
| [`sandbox.ignoreViolations`](#sandbox-ignoreviolations) | コマンドが調べることが想定されているパスについて、違反レポートを抑制します | サンドボックス設定 | Any file |
| [`sandbox.network`](#sandbox-network) | [サンドボックス化](https://code.claude.com/docs/ja/sandboxing.md#network-isolation)されたコマンドが到達できるホスト、ポート、ソケットを制御します | サンドボックス設定 | Any file |
| [`sandbox.network.allowAllUnixSockets`](#sandbox-network-allowallunixsockets) | [サンドボックス化](https://code.claude.com/docs/ja/sandboxing.md)されたコマンドがすべての Unix ソケットに接続できるようにします | サンドボックス設定 | Any file |
| [`sandbox.network.allowedDomains`](#sandbox-network-alloweddomains) | ドメインを事前に許可し、[サンドボックス化](https://code.claude.com/docs/ja/sandboxing.md)されたコマンドがそれらについてプロンプトを表示しないようにします | サンドボックス設定 | Any file |
| [`sandbox.network.allowLocalBinding`](#sandbox-network-allowlocalbinding) | macOS で、[サンドボックス化](https://code.claude.com/docs/ja/sandboxing.md)されたコマンドがネットワークポートでリッスンし、localhost に接続できるようにします | サンドボックス設定 | Any file |
| [`sandbox.network.allowMachLookup`](#sandbox-network-allowmachlookup) | iOS Simulator や Playwright などの macOS の[サンドボックス化](https://code.claude.com/docs/ja/sandboxing.md)されたツールが、それぞれの XPC サービスに到達できるようにします | サンドボックス設定 | Any file |
| [`sandbox.network.allowManagedDomainsOnly`](#sandbox-network-allowmanageddomainsonly) | ネットワークの許可リストを[管理設定](https://code.claude.com/docs/ja/sandboxing.md#keep-developers-from-widening-the-policy)に固定します | サンドボックス設定 | Managed |
| [`sandbox.network.allowUnixSockets`](#sandbox-network-allowunixsockets) | macOS で、[サンドボックス化](https://code.claude.com/docs/ja/sandboxing.md)されたコマンドが使用できる Unix ソケットのパスを列挙します | サンドボックス設定 | Any file |
| [`sandbox.network.deniedDomains`](#sandbox-network-denieddomains) | 許可されたワイルドカード内であっても、[サンドボックス化](https://code.claude.com/docs/ja/sandboxing.md)されたコマンドに対してドメインをブロックします | サンドボックス設定 | Any file |
| [`sandbox.network.httpProxyPort`](#sandbox-network-httpproxyport) | [サンドボックス](https://code.claude.com/docs/ja/sandboxing.md#custom-proxy-configuration)の HTTP トラフィックを独自のプロキシ経由でルーティングします | サンドボックス設定 | Any file |
| [`sandbox.network.socksProxyPort`](#sandbox-network-socksproxyport) | [サンドボックス](https://code.claude.com/docs/ja/sandboxing.md#custom-proxy-configuration)の SOCKS トラフィックを独自のプロキシ経由でルーティングします | サンドボックス設定 | Any file |
| [`sandbox.network.strictAllowlist`](#sandbox-network-strictallowlist) | [許可リスト](https://code.claude.com/docs/ja/sandboxing.md#network-isolation)外のホストを、プロンプトを表示せずに拒否します | サンドボックス設定 | User or managed |
| [`sandbox.network.tlsTerminate`](#sandbox-network-tlsterminate) | [サンドボックス](https://code.claude.com/docs/ja/sandboxing.md#network-isolation)のプロキシで TLS を終端し、HTTPS リクエストを読み取れるようにします | サンドボックス設定 | User or managed |
| [`sandbox.ripgrep`](#sandbox-ripgrep) | [サンドボックス](https://code.claude.com/docs/ja/sandboxing.md)内で独自の ripgrep バイナリを使用します | サンドボックス設定 | User or managed |
| [`sandbox.socatPath`](#sandbox-socatpath) | [サンドボックス](https://code.claude.com/docs/ja/sandboxing.md)のプロキシが `PATH` 外にある `socat` バイナリを使用するよう指定します | サンドボックス設定 | Managed |
| [`showClearContextOnPlanAccept`](#showclearcontextonplanaccept) | [プランの承認画面](https://code.claude.com/docs/ja/permission-modes.md#review-and-approve-a-plan)に「コンテキストをクリア」オプションを表示します | インターフェースとターミナル | Any file |
| [`showThinkingSummaries`](#showthinkingsummaries) | 折りたたまれた表示ではなく、Claude の[思考](https://code.claude.com/docs/ja/model-config.md#extended-thinking)の要約を表示します | モデルと応答 | Any file |
| [`showTurnDuration`](#showturnduration) | 各応答の後に表示される「Cooked for」の所要時間を非表示にします | インターフェースとターミナル | Any file |
| [`skillListingBudgetFraction`](#skilllistingbudgetfraction) | [スキル一覧](https://code.claude.com/docs/ja/skills.md#skill-descriptions-are-cut-short)に確保するコンテキストを増減します | メモリとコンテキスト | Any file |
| [`skillListingMaxDescChars`](#skilllistingmaxdescchars) | [スキル一覧](https://code.claude.com/docs/ja/skills.md#skill-descriptions-are-cut-short)における各スキルの説明の長さに上限を設定します | メモリとコンテキスト | Any file |
| [`skillOverrides`](#skilloverrides) | SKILL.md を編集せずに[スキルを非表示にするか折りたたみます](https://code.claude.com/docs/ja/skills.md#override-skill-visibility-from-settings) | プラグインとスキル | Any file |
| [`skipAutoPermissionPrompt`](#skipautopermissionprompt) | 組み込みのデフォルトではなく自分で初めて [auto モード](https://code.claude.com/docs/ja/permission-modes.md#eliminate-prompts-with-auto-mode)に入ったときに Claude Code が表示する 1 回限りの通知をスキップします | 権限設定 | User or managed |
| [`skipDangerousModePermissionPrompt`](#skipdangerousmodepermissionprompt) | [bypassPermissions モード](https://code.claude.com/docs/ja/permission-modes.md#skip-all-checks-with-bypasspermissions-mode)に入る前の確認ダイアログをスキップします | 権限設定 | User, local, or managed |
| [`skipWebFetchPreflight`](#skipwebfetchpreflight) | Anthropic に到達できない場合に、[WebFetch のホスト名チェック](https://code.claude.com/docs/ja/tools-reference.md#webfetch-tool-behavior)をスキップします | プライバシーとテレメトリ | Any file |
| [`spellcheck`](#spellcheck) | インストールした[スペルチェッカー](https://code.claude.com/docs/ja/interactive-mode.md#check-spelling-as-you-type)で、プロンプト入力内のスペルミスに下線を引きます | インターフェースとターミナル | User or managed |
| [`spinnerTipsEnabled`](#spinnertipsenabled) | Claude の作業中にスピナーに表示されるヒントを非表示にします | インターフェースとターミナル | Any file |
| [`spinnerTipsOverride`](#spinnertipsoverride) | スピナーのローテーションに独自のヒントを追加するか、組み込みのヒントを置き換えます | インターフェースとターミナル | Any file |
| [`spinnerVerbs`](#spinnerverbs) | ターンの実行中に表示される動詞を追加または置き換えます | インターフェースとターミナル | Any file |
| [`sshConfigs`](#sshconfigs) | Desktop の環境セレクターに [SSH 接続](https://code.claude.com/docs/ja/desktop.md#pre-configure-ssh-connections-for-your-team)を追加します | リモート、デスクトップ、通知 | User or managed |
| [`sshHostAllowlist`](#sshhostallowlist) | [Desktop の SSH セッション](https://code.claude.com/docs/ja/desktop.md#restrict-which-ssh-hosts-users-can-connect-to)が到達できるホストを制限します | リモート、デスクトップ、通知 | Managed |
| [`sshHostCommands`](#sshhostcommands) | Desktop の環境セレクターに、[ホストをコマンドから取得する SSH 接続](https://code.claude.com/docs/ja/desktop.md#create-an-ssh-connection-from-a-command)を追加します | リモート、デスクトップ、通知 | User or managed |
| [`statusLine`](#statusline) | 独自のコマンドを実行して、プロンプトの下に[ステータスライン](https://code.claude.com/docs/ja/statusline.md)を表示します | インターフェースとターミナル | Any file |
| [`strictKnownMarketplaces`](#strictknownmarketplaces) | ユーザーが追加およびインストール元として使用できる[マーケットプレイス](https://code.claude.com/docs/ja/plugins/overview.md)のソースの許可リストを指定します | プラグインとスキル | Managed |
| [`strictPluginOnlyCustomization`](#strictpluginonlycustomization) | ユーザーおよびプロジェクトのソースからの[スキル](https://code.claude.com/docs/ja/skills.md)、[エージェント](https://code.claude.com/docs/ja/sub-agents.md)、[フック](https://code.claude.com/docs/ja/hooks.md)、[MCP サーバー](https://code.claude.com/docs/ja/mcp.md)をブロックします | プラグインとスキル | Managed |
| [`strictPluginOnlyCustomization.agents`](#strictpluginonlycustomization-agents) | [エージェント](https://code.claude.com/docs/ja/sub-agents.md)をプラグインと管理ソースに限定します | プラグインとスキル | Managed |
| [`strictPluginOnlyCustomization.hooks`](#strictpluginonlycustomization-hooks) | [フック](https://code.claude.com/docs/ja/hooks.md)をプラグインと管理ソースに限定します | プラグインとスキル | Managed |
| [`strictPluginOnlyCustomization.mcp`](#strictpluginonlycustomization-mcp) | [MCP サーバー](https://code.claude.com/docs/ja/mcp.md)をプラグインと管理ソースに限定します | プラグインとスキル | Managed |
| [`strictPluginOnlyCustomization.skills`](#strictpluginonlycustomization-skills) | [スキル](https://code.claude.com/docs/ja/skills.md)をプラグインと管理ソースに限定します | プラグインとスキル | Managed |
| [`subagentPromptCacheTtl`](#subagentpromptcachettl) | サブエージェントおよびメインの会話以外のリクエストについて、[プロンプトキャッシュの有効期間](https://code.claude.com/docs/ja/prompt-caching.md#cache-lifetime)を選択します | モデルと応答 | Any file |
| [`subagentStatusLine`](#subagentstatusline) | 独自のコマンドで、[サブエージェント](https://code.claude.com/docs/ja/sub-agents.md)のタスク表示の行を書き換えます | インターフェースとターミナル | Any file |
| [`switchModelsOnFlag`](#switchmodelsonflag) | [安全性分類器](https://code.claude.com/docs/ja/model-config.md#ask-before-switching)がリクエストを警告したときに、モデルを自動的に切り替えるか一時停止します | モデルと応答 | Any file |
| [`syncClaudeAiPlugins`](#syncclaudeaiplugins) | [claude.ai アカウントで有効になっているプラグイン](https://code.claude.com/docs/ja/plugins/loading.md#synced-plugins)の読み込みと、新しいプラグインのダウンロードを停止します | プラグインとスキル | User, local, or managed |
| [`syncClaudeAiSkills`](#syncclaudeaiskills) | [claude.ai アカウントで有効になっているスキル](https://code.claude.com/docs/ja/skills.md#how-synced-skills-behave)の読み込みと、新しいスキルのダウンロードを停止します | プラグインとスキル | User, local, or managed |
| [`syntaxHighlightingDisabled`](#syntaxhighlightingdisabled) | 差分とコードブロックのシンタックスハイライトをオフにします | インターフェースとターミナル | Any file |
| [`taskOutputMaxChars`](#taskoutputmaxchars) | v2.1.277 で、サイズ指定の対象だった `TaskOutput` ツールとともに削除されました | メモリとコンテキスト | Any file |
| [`teammateDefaultModel`](#teammatedefaultmodel) | v2.1.234 で削除されました。Claude Code がチームメイトのモデルを選択する方法については、[チームメイトとモデルを指定する](https://code.claude.com/docs/ja/agent-teams.md#specify-teammates-and-models)を参照してください | グローバル設定 | Global config |
| [`teammateMode`](#teammatemode) | [エージェントチームのチームメイトの表示方法](https://code.claude.com/docs/ja/agent-teams.md#choose-a-display-mode)を選択します | エージェント、セッション、worktree | Any file |
| [`terminalProgressBarEnabled`](#terminalprogressbarenabled) | 対応しているターミナルで、ターミナルのプログレスバーを非表示にします | インターフェースとターミナル | Any file |
| [`terminalTitleFromRename`](#terminaltitlefromrename) | [`/rename`](https://code.claude.com/docs/ja/sessions#name-your-sessions) と `--name` がターミナルのタブタイトルを変更しないようにします | インターフェースとターミナル | Any file |
| [`theme`](#theme) | 組み込みまたはカスタムのインターフェースの[カラーテーマ](https://code.claude.com/docs/ja/terminal-config.md#match-the-color-theme)を選択します | インターフェースとターミナル | Any file |
| [`timeFormat`](#timeformat) | インターフェース内の時刻を、12 時間制、24 時間制、UTC、または strftime パターンで表示します | インターフェースとターミナル | Any file |
| [`timeZone`](#timezone) | インターフェース内の時刻を、システムとは異なるタイムゾーンで表示します | インターフェースとターミナル | Any file |
| [`tui`](#tui) | [フルスクリーン](https://code.claude.com/docs/ja/fullscreen.md)またはクラシックのターミナルレンダラーを選択します | インターフェースとターミナル | Any file |
| [`ultracode`](#ultracode) | 指示がなくても、実質的なタスクごとに Claude に[ワークフロー](https://code.claude.com/docs/ja/workflows.md#let-claude-decide-with-ultracode)を計画させます | モデルと応答 | Any file |
| [`useAutoModeDuringPlan`](#useautomodeduringplan) | [plan モード](https://code.claude.com/docs/ja/permission-modes.md#analyze-before-you-edit-with-plan-mode)で [auto モード](https://code.claude.com/docs/ja/permission-modes.md#eliminate-prompts-with-auto-mode)の分類器がシェルコマンドをレビューできるようにします。代わりにプロンプトを表示するには `false` を設定します | 権限設定 | User, local, or managed |
| [`verbose`](#verbose) | 切り詰められた要約ではなく[ツールの完全な出力](https://code.claude.com/docs/ja/cli-reference.md#cli-flags)を表示します。両方が設定されている場合は `viewMode` が優先されます | インターフェースとターミナル | Any file |
| [`viewMode`](#viewmode) | すべてのセッションを [default、verbose、または focus ビュー](https://code.claude.com/docs/ja/cli-reference.md#cli-flags)で開始します | インターフェースとターミナル | Any file |
| [`vimInsertModeRemaps`](#viminsertmoderemaps) | `jj` などの 2 キーの [INSERT モードのシーケンス](https://code.claude.com/docs/ja/interactive-mode.md#remap-insert-mode-key-sequences)を Escape に割り当てます | インターフェースとターミナル | User or managed |
| [`voice`](#voice) | [音声入力](https://code.claude.com/docs/ja/voice-dictation.md)をオンにし、長押しモードまたはタップモードを選択します | インターフェースとターミナル | Any file |
| [`voiceEnabled`](#voiceenabled) | 旧来の単一キー形式で[音声入力](https://code.claude.com/docs/ja/voice-dictation.md)をオンにします | インターフェースとターミナル | Any file |
| [`wheelScrollAccelerationEnabled`](#wheelscrollaccelerationenabled) | フルスクリーンレンダリングで[マウスホイールの加速](https://code.claude.com/docs/ja/fullscreen.md#mouse-wheel-scrolling)をオフにします | インターフェースとターミナル | Any file |
| [`workflowKeywordTriggerEnabled`](#workflowkeywordtriggerenabled) | プロンプト内の `ultracode` という語で[ワークフロー](https://code.claude.com/docs/ja/workflows.md)を開始できるようにします。ワークフローを開始せずにこの語を入力するには `false` を設定します | フックと自動化 | Any file |
| [`workflowSizeGuideline`](#workflowsizeguideline) | [動的ワークフロー](https://code.claude.com/docs/ja/workflows.md)で Claude が目標とするエージェント数を設定します | フックと自動化 | Any file |
| [`worktree`](#worktree) | Claude Code が git の [worktree](https://code.claude.com/docs/ja/worktrees.md) を作成する方法を設定します | エージェント、セッション、worktree | Any file |
| [`worktree.baseRef`](#worktree-baseref) | 新しい [worktree](https://code.claude.com/docs/ja/worktrees.md) を、リモートのデフォルトブランチまたはローカルの HEAD から分岐させます | エージェント、セッション、worktree | Any file |
| [`worktree.bgIsolation`](#worktree-bgisolation) | バックグラウンドセッションが [worktree](https://code.claude.com/docs/ja/worktrees.md) を使わずに作業コピーを編集できるようにします | エージェント、セッション、worktree | Any file |
| [`worktree.location`](#worktree-location) | [Desktop の SSH セッション](https://code.claude.com/docs/ja/desktop.md#ssh-sessions)がリモートマシン上で worktree を作成する場所を選択します | エージェント、セッション、worktree | User |
| [`worktree.sparsePaths`](#worktree-sparsepaths) | 各 [worktree](https://code.claude.com/docs/ja/worktrees.md) で必要なディレクトリのみをチェックアウトします | エージェント、セッション、worktree | Any file |
| [`worktree.symlinkDirectories`](#worktree-symlinkdirectories) | 大きなディレクトリを複製する代わりに、各 [worktree](https://code.claude.com/docs/ja/worktrees.md) にシンボリックリンクします | エージェント、セッション、worktree | Any file |
| [`wslInheritsWindowsSettings`](#wslinheritswindowssettings) | WSL が Windows のポリシーチェーンから[管理設定](https://code.claude.com/docs/ja/managed-settings.md)を読み取るようにします | エンタープライズと管理設定 | Managed |

## モデルと応答

Claude Code が使用するモデルと、その応答のしかたを選択します。これらの設定が `/model` コマンドや環境変数とどのように相互作用するかについては、[モデル設定](https://code.claude.com/docs/ja/model-config.md)を参照してください。

### `advisorModel`

Claude がサーバー側の [advisor ツール](https://code.claude.com/docs/ja/advisor.md)を呼び出したときに応答するモデルを選択します。設定を解除すると advisor はオフになります。advisor はメインモデルと同等以上の能力を持つ必要があります。受け入れられる組み合わせと、受け入れられない組み合わせを選択した場合の動作については、[advisor モデルを選択する](https://code.claude.com/docs/ja/advisor.md#choose-an-advisor-model)を参照してください。

通常、このキーを手動で編集することはありません。`/advisor` を実行すると、現在の選択、advisor として使用できるモデル、および **No advisor** を表示するピッカーが開きます。Claude Code は選択内容を `~/.claude/settings.json` のこのキーに保存します。[Remote Control](https://code.claude.com/docs/ja/remote-control.md) クライアントから選択した場合や、リモートワーカーに接続されたセッションで選択した場合、その選択はそのセッションにのみ適用され、このキーは変更されません。

アカウントで[使用クレジットへの同意](https://code.claude.com/docs/ja/advisor.md#fable-advisor-and-usage-credits)が必要な場合は、まず `/model fable` を実行して同意してください。同意するまでは、`/advisor` で Fable を選択しても何も保存されず、Claude Code は先に `/model fable` を実行するよう案内します。

* **スコープ**: [`Any file`](#scopes)
* **型**: 文字列。エイリアス `"fable"`、`"opus"`、`"sonnet"` のいずれか（Claude Code におけるそのモデルファミリーの現在のデフォルトバージョンに解決されます）、または `"claude-opus-5-5"` のような完全なモデル ID
* **デフォルト**: 未設定。advisor はオフです
* **セッションごとの上書き**: `--advisor` は、1 つのセッションに限りこのキーよりも優先されます。[`CLAUDE_CODE_DISABLE_ADVISOR_TOOL`](https://code.claude.com/docs/ja/env-vars) は advisor をオフにし、このキーで再びオンにすることはできません

```json settings.json theme={null}
{
  "advisorModel": "opus"
}
```

このキーは、Amazon Bedrock や Claude Platform on AWS など、advisor が[利用できない](https://code.claude.com/docs/ja/advisor.md#requirements)プロバイダーでは効果がありません。`"fable"` には [Fable へのアクセス](https://code.claude.com/docs/ja/advisor.md#choose-an-advisor-model)が必要です。

### `alwaysThinkingEnabled`

これを `false` に設定すると、すべてのセッションで[拡張思考](https://code.claude.com/docs/ja/model-config.md#extended-thinking)がオフになります。思考はデフォルトでオンのため、`true` にしても何も変わりません。ほとんどのユーザーは、ファイルを編集するのではなく `/config` からこれを設定します。

Opus 5.5、Sonnet 5.5、Haiku 5.5、Fable モデルなど、常に思考するモデルでは `false` は効果がありません。[サードパーティプロバイダー](https://code.claude.com/docs/ja/third-party-integrations.md)では、Claude Code は思考をオフにする代わりに `thinking` パラメータを省略するため、適応型推論モデルは引き続き思考する場合があります。Anthropic API で思考をオフにした場合、Claude Code は、Opus 5 など[その組み合わせを受け付けない](https://code.claude.com/docs/ja/errors.md#effort-isnt-available-with-thinking-turned-off)ことが分かっているモデルに対して、より高いレベルではなく effort `high` を送信します。

* **スコープ**: [`Any file`](#scopes)
* **型**: Boolean
  * `true`: 効果なし。思考はすでにオンです
  * `false`: Claude Code はすべてのセッションで拡張思考をオフにします
* **デフォルト**: 未設定。思考をサポートするモデルでは思考がオンになります
* **セッションごとの上書き**: [`MAX_THINKING_TOKENS`](https://code.claude.com/docs/ja/env-vars) は、1 つのセッションに限りこのキーよりも優先されます。`0` は `false` と同じモデルおよびプロバイダーの制限のもとで思考をオフにし、正の値はこのキーが `false` の場合でも思考をオンにします。適応型推論モデルでは、数値そのものは無視されます

```json settings.json theme={null}
{
  "alwaysThinkingEnabled": false
}
```

### `availableModels`

メインセッション、[サブエージェント](https://code.claude.com/docs/ja/sub-agents.md)、[スキル](https://code.claude.com/docs/ja/skills.md)、[advisor](https://code.claude.com/docs/ja/advisor.md) でユーザーが選択できるモデルを制限します。管理されたリストは、`/model`、`--model`、および開発者自身のファイル内の `model` キーを制約し、リスト外のモデルは選択できません。デフォルトのプレフィックス一致では、これだけでは Default オプションには影響しません。Default オプションも制限するには、[`enforceAvailableModels`](#enforceavailablemodels) と組み合わせてください。

* **スコープ**: [`Any file`](#scopes)。組織全体に適用するには、管理設定でデプロイします。
* **型**: モデルのエイリアスまたは ID の配列
* **デフォルト**: 未設定。すべてのモデルが利用可能です

この例では、Sonnet と Haiku のモデルのみを選択できるようにします。

```json settings.json theme={null}
{
  "availableModels": ["sonnet", "haiku"]
}
```

`"claude-opus-5"` のようなモデル ID のエントリは、Opus 5.5 など、それを拡張する後続のバージョンも許可します。それらのバージョンのいずれかをブロックするには、[`deniedModels`](#deniedmodels) を使用します。各モデル ID のエントリが指定したバージョンのみを許可するようにするには、[`availableModelsMatch`](#availablemodelsmatch) を使用します。[モデル選択を制限する](https://code.claude.com/docs/ja/model-config.md#restrict-model-selection)を参照してください。サードパーティプロバイダーの ID については、[サードパーティデプロイ向けにモデルを固定する](https://code.claude.com/docs/ja/model-config.md#pin-models-for-third-party-deployments)を参照してください。

### `availableModelsMatch`

[`availableModels`](#availablemodels) のエントリをモデル ID とどのように照合するかを選択します。デフォルトでは、モデル ID のエントリはそれを拡張する後続のバージョンも許可するため、`"claude-opus-5"` は Opus 5.5 を許可します。`"exact"` を指定すると、各モデル ID のエントリは指定したバージョンのみを許可するため、そのモデルの新しいバージョンは、リストに追加するまでブロックされたままになります。Claude Code v2.1.283 以降が必要です。

* **スコープ**: [`Managed`](#scopes)。Claude Code は、ユーザー設定、プロジェクト設定、ローカル設定、および `--settings` 内のこのキーを警告付きで無視します
* **型**: 文字列。次のいずれか:
  * `"prefix"`: モデル ID のエントリは、そのバージョンと、別のセグメントでそれを拡張するすべてのモデル ID を許可します
  * `"exact"`: モデル ID のエントリは指定したバージョンのみを許可するため、`"claude-opus-5"` は Opus 5 を許可しますが、`claude-opus-5-5` は許可しません。`"claude-opus-4-5"` のようなエントリは、日付付きの Anthropic モデル ID `claude-opus-4-5-20251101` も許可します。`"opus"` のようなファミリーエイリアスは引き続きファミリー全体を許可し、`best`、`opusplan`、`default` のエントリは無視されます
* **デフォルト**: `"prefix"`

この例では、Opus 5 と Sonnet 5 を許可し、いずれの後続リリースも許可しません。

```json managed-settings.json theme={null}
{
  "availableModels": ["claude-opus-5", "claude-sonnet-5"],
  "availableModelsMatch": "exact"
}
```

`"exact"` を指定した場合、リストに少なくとも 1 つのモデルまたはファミリーが指定されていれば、Default オプションもリスト内のモデルに制限されます。[特定のモデルまたはバージョンをブロックする](https://code.claude.com/docs/ja/model-config.md#block-specific-models-or-versions)を参照してください。

### `deniedModels`

[`availableModels`](#availablemodels) 許可リストの有無にかかわらず、またそのリストで許可されている場合でも、特定のモデルをブロックします。Claude Code はブロックされたモデルを `/model` ピッカーに表示せず、`availableModels` が適用されるあらゆる場所でそのモデルを選択できなくなります。[特定のモデルまたはバージョンをブロックする](https://code.claude.com/docs/ja/model-config.md#block-specific-models-or-versions)で説明しているとおり、Default オプションのセッションでもブロックされたモデルは実行されません。Claude Code v2.1.283 以降が必要です。

* **スコープ**: [`Managed`](#scopes)。Claude Code は、ユーザー設定、プロジェクト設定、ローカル設定、および `--settings` 内のこのキーを警告付きで無視します
* **型**: モデルのエイリアスまたは ID の配列
  * `"opus"` のようなファミリーエイリアスは、そのファミリーのすべてのモデルをブロックします
  * `"claude-opus-5-5"` のようなモデル ID は、日付付き ID やプロバイダー固有の ID を含む、あらゆる表記のそのバージョンをブロックします
  * `"claude-opus-5"` のようにマイナーバージョンのないモデル ID は、Opus 5.5 など後続のマイナーバージョンもブロックします。Opus 5 のみをブロックするには `"claude-opus-5-0"` と記述します
  * `best`、`opusplan`、`default` のエントリは無視されます
* **デフォルト**: 未設定。ブロックされるモデルはありません

この例では、Opus と Sonnet のモデルを許可し、Opus 5.5 をブロックします。

```json managed-settings.json theme={null}
{
  "availableModels": ["opus", "sonnet"],
  "deniedModels": ["claude-opus-5-5"]
}
```

[特定のモデルまたはバージョンをブロックする](https://code.claude.com/docs/ja/model-config.md#block-specific-models-or-versions)を参照してください。

### `effortLevel`

レベルを保存していないモデルに対して、デフォルトの [effort レベル](https://code.claude.com/docs/ja/model-config.md#adjust-effort-level)を設定します。低いレベルは単純なタスクでより高速かつ低コストになり、高いレベルは複雑な問題に対してより深く推論します。

自分のマシン上の対話セッションで `/effort low`、`medium`、`high`、`xhigh` を実行すると、Claude Code はこのキーに書き込むのではなく、アクティブなモデルのレベルを [`modelSettings`](#modelsettings) の下に保存します。v2.1.251 より前は、`/effort` はこのキーに書き込んでいました。

同じ設定ファイル内では、Claude Code はこのキーよりもモデルごとに保存されたレベルを使用します。ファイル間の優先順位については [`modelSettings`](#modelsettings) に記載しています。

リモートワーカーに接続されたセッション、`-p` の実行、および Agent SDK では、`/effort` はそのセッションにのみ適用されます。同様にそのセッションにのみ適用される対話的な選択については、[effort レベルを調整する](https://code.claude.com/docs/ja/model-config.md#adjust-effort-level)に記載しています。`/effort` が出力するメッセージに、どちらになったかが示されます。

* **スコープ**: [`Any file`](#scopes)
* **型**: 文字列。次のいずれか:
  * `"low"`: 推論が最も少なく、知能をあまり必要としない、短く範囲の限られたレイテンシー重視のタスク向け
  * `"medium"`: ある程度の知能と引き換えにできる、コスト重視の作業でトークン使用量を削減します
  * `"high"`: トークン使用量と知能のバランスを取ります
  * `"xhigh"`: より多くのトークンを消費して、より深く推論します
* **デフォルト**: 未設定
* **セッションごとの上書き**: `--effort` は 1 つのセッションに限りこのキーよりも優先され、[`CLAUDE_CODE_EFFORT_LEVEL`](https://code.claude.com/docs/ja/env-vars) はその両方よりも優先されます

```json settings.json theme={null}
{
  "effortLevel": "xhigh"
}
```

ユーザー設定ファイル `~/.claude/settings.json` では、このキーは `/effort` がモデルごとにレベルを保存するようになる前に書き込んでいた古い形式であり、以前と同じ範囲、つまり Opus 5、Fable 5.1、およびそれ以前のモデルに引き続き適用されます。Opus 5.5 とそれ以降にリリースされたモデルはこのキーを無視し、レベルを保存するまでは独自のデフォルトで開始します。レベルは `/effort` によって [`modelSettings`](#modelsettings) の下に書き込まれます。プロジェクト設定、ローカル設定、管理設定、および `--settings` では、このキーはすべてのモデルに適用されます。

### `enforceAvailableModels`

`/model` ピッカーには **Default** オプションがあり、それが解決されるモデルについては [`default` モデル設定](https://code.claude.com/docs/ja/model-config#default-model-setting)で説明しています。[`availableModels`](#availablemodels) 許可リストは指定できるモデルを制限しますが、デフォルトの[プレフィックス一致](#availablemodelsmatch)ではアカウントタイプのデフォルトを再マッピングしないため、**Default** がリスト外のモデルに解決される場合があります。このキーはそのギャップを埋めます。Claude Code v2.1.175 以降が必要です。

組織が何らかの管理設定をデプロイしている場合、Claude Code はこのキーを管理ソースからのみ読み取り、他のファイル内のこのキーは無視します。

起動時のモデルチェックにこのキーがどのように適用されるかについては、[Amazon Bedrock](https://code.claude.com/docs/ja/amazon-bedrock.md#when-your-organization-enforces-a-model-allowlist) および [Google Cloud's Agent Platform](https://code.claude.com/docs/ja/google-vertex-ai.md#when-your-organization-enforces-a-model-allowlist) を参照してください。

* **スコープ**: [`Any file`](#scopes)
* **型**: Boolean
  * `true`: **Default** が `availableModels` 外のモデルに解決される場合、Claude Code はそれをリスト内で最初に利用可能なモデルに解決します
  * `false`: このキーは **Default** の解決方法を変更しません
* **デフォルト**: `false`

この例では、名前による選択を Sonnet と Haiku のモデルに制限し、**Default** がそれらのうち最初に利用可能なものに解決されるようにします。

```json settings.json theme={null}
{
  "availableModels": ["sonnet", "haiku"],
  "enforceAvailableModels": true
}
```

`availableModels` が未設定または空の場合、このキーは効果がありません。[Default モデルに許可リストを適用する](https://code.claude.com/docs/ja/model-config.md#enforce-the-allowlist-for-the-default-model)を参照してください。Claude Code v2.1.175 以降が必要です。

### `fallbackModel`

プライマリモデルが過負荷または利用できない場合に Claude Code が順番に試すバックアップモデルを指定します。Claude Code はそのターンの残りの間、チェーン内で次に利用可能なモデルに切り替え、通知を表示します。チェーンがない場合、Claude Code は同じモデルで再試行した後にサーバーのエラーを表示し、ユーザーが自分で再試行するかモデルを切り替えることになります。

切り替えが発生すると、フォールバックモデルでは 1 ターンの間[プロンプトキャッシュ](https://code.claude.com/docs/ja/prompt-caching.md#switching-models)がコールドの状態になります。次のメッセージでは再びプライマリモデルが最初に試されます。

* **スコープ**: [`Any file`](#scopes)
* **型**: モデルのエイリアスまたは ID の配列。`"default"` はデフォルトモデルに展開されます
* **デフォルト**: 未設定。失敗したリクエストは別のモデルで再試行されません
* **セッションごとの上書き**: `--fallback-model` は、1 つのセッションに限りこのキーよりも優先されます

この例では、プライマリモデルが失敗した場合に、まず Sonnet 5、次に Haiku 4.5 を試します。

```json settings.json theme={null}
{
  "fallbackModel": ["claude-sonnet-5", "claude-haiku-4-5"]
}
```

ほとんどの配列設定とは異なり、このキーは設定ファイル間でマージされません。このキーを定義している最も優先順位の高いファイルがチェーン全体を提供します。プロジェクトファイルで `["claude-sonnet-5"]` を設定し、ユーザーファイルで `["claude-haiku-4-5"]` を設定した場合、チェーンは `["claude-sonnet-5"]` のみになります。Claude Code はリストから最大 3 つの異なる許可されたモデルを保持し、残りは無視します。[フォールバックモデルチェーン](https://code.claude.com/docs/ja/model-config.md#fallback-model-chains)を参照してください。

### `fastMode`

利用可能なセッションで [fast mode](https://code.claude.com/docs/ja/fast-mode.md) をオンにします。トークンあたりのコストが高くても速度を優先したい、迅速な反復作業やライブデバッグなどの対話的な作業向けです。通常、このキーを手動で編集することはありません。`/fast` を実行すると `~/.claude/settings.json` に `fastMode: true` が書き込まれ、もう一度実行して fast mode をオフにするとキーが削除されます。fast mode は Opus 5.5、Opus 5、Opus 4.8 でのみ動作します。他のモデルからオンにすると Opus に切り替わり、サポートされていないモデルに切り替えるとオフになります。[fast mode がオンの状態でモデルを切り替える](https://code.claude.com/docs/ja/fast-mode.md#switch-models-while-fast-mode-is-on)を参照してください。

* **スコープ**: [`Any file`](#scopes)
* **型**: Boolean
  * `true`: Claude Code は、利用可能なセッションで fast mode をオンにします
  * `false`: fast mode はオフのままです
* **デフォルト**: 未設定。fast mode はオフです
* **セッションごとの上書き**: [`CLAUDE_CODE_DISABLE_FAST_MODE`](https://code.claude.com/docs/ja/env-vars) は 1 つのセッションに限り fast mode をオフにし、このキーで再びオンにすることはできません

```json settings.json theme={null}
{
  "fastMode": true
}
```

### `fastModePerSessionOptIn`

通常、`/fast` を実行すると [`fastMode`](#fastmode) がユーザー設定に保存されるため、以降のすべてのセッションの開始時に fast mode がオンになります。このキーを `true` に設定するとこれを止められます。保存された `fastMode: true` はセッション開始時に fast mode をオンにしなくなり、各ユーザーは fast mode を使いたいセッションごとに `/fast` を実行する必要があります。Claude Code はユーザーのファイル内の `fastMode` キーを残すため、このキーをオフにすると以前の動作に戻ります。

Team プランまたは Enterprise プランのオーナーは、[サーバー管理設定](https://code.claude.com/docs/ja/server-managed-settings.md)を通じて組織全体にデプロイできます。管理設定でこのキーが設定されている場合、対話型ターミナルセッション以外では `/fast on` が拒否され、組織によって fast mode が無効化されていることが通知されます。これには、[非対話モード](https://code.claude.com/docs/ja/headless.md)、[VS Code 拡張機能](https://code.claude.com/docs/ja/vs-code.md)、[クラウドセッション](https://code.claude.com/docs/ja/claude-code-on-the-web.md)が含まれます。

* **スコープ**: [`Any file`](#scopes)
* **型**: Boolean
  * `true`: 保存された `fastMode: true` はセッション開始時に fast mode をオンにしなくなるため、各ユーザーは fast mode を使いたいセッションごとに `/fast` を実行します。`--settings` で渡された `fastMode: true` は、管理設定でこのキーが設定されていない限り、そのセッションでは引き続き有効です
  * `false`: 保存された `fastMode: true` は、以降のすべてのセッションの開始時に fast mode をオンにします
* **デフォルト**: `false`

```json settings.json theme={null}
{
  "fastModePerSessionOptIn": true
}
```

[セッションごとのオプトインを必須にする](https://code.claude.com/docs/ja/fast-mode.md#require-per-session-opt-in)を参照してください。

### `language`

Claude がデフォルトで英語以外の言語で応答するようにします。応答に使える言語の固定リストはありません。Claude Code はこの値を、常にその言語で応答するという指示としてそのまま Claude に渡すため、Claude が読み取れる言語名であれば何でも機能します。Claude Code は値をチェックしないため、スペルを誤った名前はエラーにならず、記述したとおりに Claude に渡されます。同じ値は、[音声入力](https://code.claude.com/docs/ja/voice-dictation.md#change-the-dictation-language)（こちらには[サポートされている音声入力言語](https://code.claude.com/docs/ja/voice-dictation.md#change-the-dictation-language)の固定リストがあります）と、自動生成されるセッションタイトルの言語も設定します。

* **スコープ**: [`Any file`](#scopes)
* **型**: 文字列。`"japanese"`、`"spanish"`、`"french"` など任意の言語名。Claude Code は検証しません
* **デフォルト**: 未設定。その場合、セッションタイトルは会話の言語に合わせられます

```json settings.json theme={null}
{
  "language": "japanese"
}
```

### `maxEffortLevel`

セッションで使用できる [effort レベル](https://code.claude.com/docs/ja/model-config.md#adjust-effort-level)に上限を設け、それより低いレベルは使用可能なままにします。それより高いレベルは、`/effort`、`/model` ピッカー、`--effort`、[`CLAUDE_CODE_EFFORT_LEVEL`](https://code.claude.com/docs/ja/env-vars)、スキルやサブエージェントの `effort` フロントマター、またはモデル自体のデフォルトから指定されたものを含め、すべて上限のレベルで実行されます。Claude Code は各リクエストの前に自ら上限を適用するため、Amazon Bedrock、Google Cloud's Agent Platform、Microsoft Foundry を含むすべてのプロバイダーで上限が維持されます。Claude Code v2.1.267 以降が必要です。

* **スコープ**: [`Any file`](#scopes)。組織全体に適用するには、管理設定でデプロイします。複数のスコープで上限が設定されている場合は最も低いものが適用されるため、あるスコープで設定された上限を別のスコープから引き上げることはできません
* **型**: 文字列。`"low"`、`"medium"`、`"high"`、`"xhigh"`、`"max"` のいずれか。`"max"` を指定すると上限は設定されません
* **デフォルト**: 未設定。上限は適用されません
* **モデルごとの上限**: モデルの [`modelSettings`](#modelsettings) エントリに `maxEffortLevel` を追加します。そのエントリは、ユーザー設定や 1 つの[管理ソース](https://code.claude.com/docs/ja/managed-settings.md#how-claude-code-combines-managed-sources)など、両方を設定している設定ソース内に限り、そのモデルについてこのキーを置き換えます。そこで `"max"` を設定すると、そのモデルをそのソースの上限から除外できます。ただし、Claude Code は他のソースからの上限を引き続き適用します

この例では、すべてのモデルの上限を `medium` に設定し、Sonnet 4.6 を除外します。

```json settings.json theme={null}
{
  "maxEffortLevel": "medium",
  "modelSettings": {
    "claude-sonnet-4-6": {
      "maxEffortLevel": "max"
    }
  }
}
```

組織がモデルに対して [effort の制限](https://code.claude.com/docs/ja/model-config.md#organization-effort-limits)も設定している場合は、2 つの上限のうち低い方が適用されます。

### `model`

新しいセッションごとに使用するモデルを設定し、毎回 `/model` で選択しなくて済むようにします。ここで設定しても、セッションの途中で切り替えることはできます。管理者がユーザーの選択を上書きする[組織のデフォルトモデル](https://code.claude.com/docs/ja/model-config.md#organization-default-model)を設定している場合は、ユーザー設定、プロジェクト設定、ローカル設定でこのキーを設定していても、そのモデルが使用されます。

* **スコープ**: [`Any file`](#scopes)
* **型**: 文字列。モデルのエイリアスまたは完全なモデル ID
* **デフォルト**: 未設定。Claude Code はアカウントのデフォルトモデルを使用します
* **セッションごとの上書き**: `--model` は [`ANTHROPIC_MODEL`](https://code.claude.com/docs/ja/env-vars) よりも優先され、どちらも 1 つのセッションに限り、管理された `model` を含めてこのキーよりも優先されます。ただし、[`availableModels`](#availablemodels) リストは引き続き選択に適用されます

```json settings.json theme={null}
{
  "model": "claude-sonnet-5"
}
```

ここで設定した値は、[`ANTHROPIC_DEFAULT_MODEL`](https://code.claude.com/docs/ja/model-config#set-a-default-model-for-new-sessions) よりも優先されます。Claude Code が `ANTHROPIC_DEFAULT_MODEL` を使用するのは、他に何もモデルを選択していない場合のみです。

### `modelOverrides`

Anthropic のモデル ID を、Amazon Bedrock の推論プロファイル ARN などのプロバイダー固有のモデル ID にマッピングします。これにより、モデルピッカーの各エントリは、プロバイダー API を呼び出す際にマッピングされた値を使用します。管理者は [Amazon Bedrock、Google Cloud's Agent Platform、Microsoft Foundry](https://code.claude.com/docs/ja/model-config.md#override-model-ids-per-version) でこれを使用して、ガバナンス、コスト配分、リージョンルーティングのために、各モデルバージョンを特定の推論プロファイル、バージョン名、またはデプロイにルーティングします。

* **スコープ**: [`Any file`](#scopes)
* **型**: モデル ID をプロバイダーのモデル ID にマッピングするオブジェクト
* **デフォルト**: 未設定

この例では、Opus 4.6 へのすべての呼び出しを指定した Bedrock 推論プロファイルにルーティングします。

```json settings.json theme={null}
{
  "modelOverrides": {
    "claude-opus-4-6": "arn:aws:bedrock:us-east-1:123456789012:inference-profile/example"
  }
}
```

[バージョンごとにモデル ID を上書きする](https://code.claude.com/docs/ja/model-config.md#override-model-ids-per-version)を参照してください。

### `modelPicker`

`/model` ピッカーに表示するモデルを、記述した順序と選択したラベルで一覧にします。これにより、ピッカーには組織で実行しているモデルが、組み込みのラインナップの後に、またはその代わりに表示されます。各行の `model` はそのまま使用されるため、`--model` が受け付けるものは何でも指定できます。`opus` のようなエイリアス、Anthropic のモデル ID、または Amazon Bedrock、Google Cloud's Agent Platform、Microsoft Foundry、LLM ゲートウェイ向けのプロバイダー形式の ID です。Claude Code v2.1.242 以降が必要です。

* **スコープ**: [`User or managed`](#scopes)。Claude Code はこのキーを管理設定、`--settings`、ユーザー設定から読み取り、プロジェクト設定とローカル設定では無視します。これにより、クローンしたリポジトリがピッカーのラベルを変更することはできません。これら 3 つのうちこのキーを設定している最も優先順位の高いものがラインナップ全体を提供し、Claude Code が 2 つのソースのラインナップを組み合わせることはありません。
* **型**: 行の配列である `options` と、省略可能な Boolean の `replaceBuiltInOptions` を持つオブジェクト
* **デフォルト**: 未設定。ピッカーには組み込みのラインナップが表示されます

この例では、チームが認識できる名前で、組み込みのラインナップの後に 2 つの Bedrock デプロイを追加します。

```json managed-settings.json theme={null}
{
  "modelPicker": {
    "options": [
      { "model": "us.anthropic.claude-opus-4-8", "label": "Opus (production)" },
      {
        "model": "us.anthropic.claude-sonnet-4-6",
        "label": "Sonnet (production)",
        "description": "Day-to-day work"
      }
    ]
  }
}
```

#### `modelPicker` のフィールド

このキーは 2 つのフィールドを受け取ります。1 つは行そのもの用、もう 1 つはそれらの行が組み込みのラインナップを置き換えるか、追加されるかを指定するものです。

| フィールド | 型 | 機能 |
| :- | :- | :- |
| `options` | 行の配列。各行には必須の `model` と、省略可能な `label`、`description`、`behavesAs` があります | ピッカーに表示される行で、この順序で表示されます。ただし、グレーアウトされた行は一番下に移動します。`label` がない場合、Claude Code は既知のモデルであれば組み込みの名前を、それ以外の場合はモデル ID を行のタイトルとし、`description` がない場合は汎用的な 2 行目を記述します |
| `replaceBuiltInOptions` | Boolean、デフォルトは `false` | `true` に設定すると、これらの行、**Default**、およびセッションですでに使用しているモデルの行のみが表示されます。未設定のままにすると、これらの行は組み込みのラインナップの後に追加されます |

`options` 内のエントリには、`model` と並んで省略可能な `behavesAs` 文字列を含めることもでき、これには v2.1.257 以降が必要です。`model` が使用中のバージョンより新しいエントリに対して、`claude-opus-4-8` など、使用中の Claude Code バージョンがすでに認識しているモデルの ID を設定します。すると Claude Code は、そのモデルを不明なモデルとして扱う代わりに、既知のモデルの機能と effort のデフォルトをそのエントリに適用します。エントリのラベルと、Claude Code がリクエストで送信するモデル ID は変わりません。

`replaceBuiltInOptions` がオンの場合、Claude Code は他のすべての行を非表示にします。対象は、組み込みのラインナップ、[`availableModels`](#availablemodels) のエントリに対して追加される行、[ゲートウェイ検出](https://code.claude.com/docs/ja/llm-gateway-protocol.md#model-discovery)で見つかったモデル、および [`ANTHROPIC_CUSTOM_MODEL_OPTION`](https://code.claude.com/docs/ja/model-config#add-a-custom-model-option) です。オフの場合、Claude Code は組み込みのラインナップですでにカバーされているリスト内のモデルをスキップします。ラベルはピッカーの表示を変えるだけで、Claude Code が実行するモデルは変わりません。

[`availableModels`](#availablemodels) 許可リストは、これらの行にも引き続き適用されます。リスト内のモデルを許可リストに追加する前に、[マージの動作](https://code.claude.com/docs/ja/model-config.md#merge-behavior)を読んでください。特定のモデル ID は、そのファミリーのワイルドカードエントリを絞り込みます。Claude Code は、ピッカーを表示する前に各行をセッションに照らしてチェックすることも行います。

* **削除**: 廃止されたモデルや組織がアクセスできないモデルなど、Claude Code が提供できない行
* **グレーアウト**: まだ選択できない行。理由とともに表示されます
* **残る行がない場合**: Claude Code は組み込みのラインナップを保持し、通常どおり許可リストで絞り込みます

Claude Code は解析できない行を削除し、残りを保持します。[壊れた設定ファイルを修正する](https://code.claude.com/docs/ja/settings.md#fix-a-broken-settings-file)を参照してください。

### `modelPricing`

表示価格ではなく、組織が実際に支払っている料金で支出を報告します。組織に契約料金がある場合に設定すると、開発者が目にする金額が請求額と一致するようになります。Claude Code はこの料金を、`/usage`、[ステータスライン](https://code.claude.com/docs/ja/statusline.md)、Agent SDK の `total_cost_usd`、[`--max-budget-usd`](https://code.claude.com/docs/ja/cli-reference) の上限、および [OpenTelemetry](https://code.claude.com/docs/ja/monitoring-usage.md) のコストメトリクスとイベントに適用します。料金はユーザーが指定します。Claude Code が契約や Claude Console から料金を読み取ることはありません。Claude Code v2.1.242 以降が必要です。

* **スコープ**: [`Managed`](#scopes)。このキーは、サーバー管理設定、MDM ポリシー、`managed-settings.json` ファイル、または[ポリシーヘルパー](https://code.claude.com/docs/ja/managed-settings.md#compute-the-policy-with-a-helper-program)を通じてデプロイします。Claude Code は、ユーザー設定、プロジェクト設定、ローカル設定、`--settings`、および Windows ではユーザーが書き込み可能な [HKCU レジストリ](https://code.claude.com/docs/ja/managed-settings.md#where-each-mechanism-stores-the-policy)内のこのキーを無視します。サーバー管理設定を使用する場合、各セッションは、そのセッションの[設定の取得](https://code.claude.com/docs/ja/server-managed-settings.md#fetch-and-caching-behavior)で設定が確認されるまで、表示価格でコストを報告します。Claude Code を組み込み、[`CLAUDE_CODE_PROVIDER_MANAGED_BY_HOST`](https://code.claude.com/docs/ja/env-vars) を設定しているホストアプリケーションは、SDK の [`managedSettings`](https://code.claude.com/docs/ja/agent-sdk/typescript#options) オプションを通じて独自の料金表を提供できます。Claude Code がこれを使用するのは、どの管理ソースもこのキーを設定していない場合のみで、Claude Code v2.1.246 以降に限られます。
* **型**: 省略可能な `multiplier` と省略可能な `overrides` マップを持つオブジェクト
* **デフォルト**: 未設定。ホストアプリケーションが料金表を提供しない限り、Claude Code は表示価格で報告します

一律の割引または上乗せには `multiplier` のみを、モデルごとの料金には `overrides` のみを設定するか、両方を設定します。

この例では、Sonnet 4.6 の契約料金を設定したうえで、Sonnet の行を含むすべての金額を 15% 引き下げます。

```json managed-settings.json theme={null}
{
  "modelPricing": {
    "multiplier": 0.85,
    "overrides": {
      "claude-sonnet-4-6": {
        "input": 2.4,
        "output": 12,
        "cacheRead": 0.24,
        "cacheWrite": 3
      }
    }
  }
}
```

すべての金額を上乗せするには、`multiplier` を 1 より大きく 10 以下の値に設定します。上乗せには Claude Code v2.1.271 以降が必要です。それより前のバージョンでは、1 より大きい `multiplier` は警告付きで無視され、設定の残りは保持されます。

料金が有効になっていることを確認する方法を含む手順については、[契約料金で支出を報告する](https://code.claude.com/docs/ja/costs.md#report-spend-at-your-contracted-rates)を参照してください。

#### `modelPricing` のフィールド

| フィールド | 型 | 機能 |
| :- | :- | :- |
| `multiplier` | 0 より大きく 10 以下の数値 | `overrides` の行が対象としているかどうかにかかわらず、Claude Code が計算するすべてのコストをスケーリングします。1 未満は割引、1 より大きい値は上乗せです |
| `overrides` | モデル ID から、`input`、`output`、`cacheRead`、`cacheWrite`（それぞれ 0 から 10000）を持つ料金オブジェクトへのマップ | そのモデルの 100 万トークンあたりの USD 料金で、4 つすべてが必須です。`cacheWrite` は 5 分と 1 時間の両方のキャッシュ書き込みを対象とします。[`modelPricing` の行が適用されるモデル](#which-models-a-modelpricing-row-applies-to)を参照してください |

Claude Code は、fast mode の追加料金や[米国内のみでの推論の料金](https://platform.claude.com/docs/en/about-claude/pricing)を加算せず、行の料金を記述したとおりに使用します。`multiplier` も設定している場合、Claude Code はそれを行の料金に重ねて適用します。Claude Code は、解析できない料金を持つ行や、解析できない `multiplier` を削除し、残りを保持します。[壊れた設定ファイルを修正する](https://code.claude.com/docs/ja/settings.md#fix-a-broken-settings-file)を参照してください。

#### `modelPricing` の行が適用されるモデル

Claude Code は、行のキーからその行がどのモデルに適用されるかを判断します。

* **組み込みモデルの ID**: Claude Code 自身が組み込みモデルに使用するキーで、`claude-sonnet-4-6` のようなモデル自体の ID であるか、Bedrock、Agent Platform、Foundry の ID であるかは問いません。Claude Code は、そのモデルのすべての日付付きスナップショット ID とプロバイダー固有の ID にその行を適用します。
* **その他のキー**: ゲートウェイのモデルエイリアスなど、組み込みモデルの ID ではないキー。Claude Code はその 1 つの ID にのみ行を適用します。モデル ID がいずれかのキーに完全に一致し、かつ組み込みモデルの ID をキーとする行にも該当する場合、Claude Code は完全一致を使用します。
* **Bedrock のアプリケーション推論プロファイル**: Claude Code が [`modelOverrides`](#modeloverrides) マップまたは [`bedrock:GetInferenceProfile` による検索](https://code.claude.com/docs/ja/amazon-bedrock#iam-configuration)を通じて、プロファイルをルーティング先のモデルに解決すると、Claude Code はそのモデルの行をプロファイルに適用します。

### `modelSettings`

使用するモデルごとに [effort レベル](https://code.claude.com/docs/ja/model-config.md#adjust-effort-level)を保存します。Claude Code v2.1.251 以降が必要です。

自分のマシン上の対話セッションで、`/effort` または `/model` ピッカーの effort スライダーを使って `low`、`medium`、`high`、`xhigh` をデフォルトとして保存すると、Claude Code は使用中のモデルの下にそのレベルをここに書き込むため、このキーを自分で編集することはほとんどありません。[VS Code 拡張機能のモデルピッカー](https://code.claude.com/docs/ja/vs-code.md#use-the-prompt-box)でこれらのレベルのいずれかを選択した場合も、Claude Code は同じようにここに保存します。`/effort` がそのセッションにのみ適用されるセッションについては、[`effortLevel`](#effortlevel) のエントリに記載しています。

保存したレベルを変更または削除するには、このキーを手動で編集します。

ここでのモデルの `effortLevel` は、同じ設定ファイル内のトップレベルの [`effortLevel`](#effortlevel) よりも優先されます。ファイル間では、Claude Code はモデルごとに個別に解決します。そのモデルの `effortLevel`、または[そのモデルに適用される](#effortlevel)トップレベルの `effortLevel` のいずれかを設定している、最も優先順位の高い[設定ファイル](https://code.claude.com/docs/ja/settings.md#settings-precedence)が決定するため、管理設定の `effortLevel` はユーザー設定に保存したレベルよりも優先されます。起動時の `--effort` など、保存されたレベルを上書きできるその他の要素については、[effort レベルを調整する](https://code.claude.com/docs/ja/model-config.md#adjust-effort-level)に記載しています。

1 つのモデルのレベルを設定するのではなく effort に上限を設けるには、そのモデルのエントリに [`maxEffortLevel`](#maxeffortlevel) フィールドを追加します。このフィールドには Claude Code v2.1.267 以降が必要です。

* **スコープ**: [`Any file`](#scopes)
* **型**: モデル名を、次のいずれかのフィールドを持つオブジェクトにマッピングするオブジェクト:
  * `effortLevel`: `"low"`、`"medium"`、`"high"`、`"xhigh"` のいずれか
  * [`maxEffortLevel`](#maxeffortlevel): モデルが実行できる最も高い effort レベル
  * `autoCompactWindow`: `100000` から `1000000` までのトークン数、またはモデル向けに調整されたウィンドウを表す `"auto"`。[`/autocompact`](https://code.claude.com/docs/ja/model-config#set-the-auto-compact-window) はここに保存します。そのモデルについては、この値が同じ設定ファイル内のトップレベルの [`autoCompactWindow`](#autocompactwindow) よりも優先されます。Claude Code v2.1.288 以降が必要です
* **デフォルト**: 未設定

Claude Code は各エントリを `claude-opus-5-5` のようなモデルの正規名の下に書き込み、そのモデルのエイリアス、日付サフィックス付き、`[1m]`、および認識されたプロバイダー固有の ID を同じエントリに照合します。

この例では、他のモデルがそれぞれ保存済みまたはデフォルトのレベルを使用する一方で、Opus 5.5 を `high` に保ちます。

```json settings.json theme={null}
{
  "modelSettings": {
    "claude-opus-5-5": {
      "effortLevel": "high"
    }
  }
}
```

使用中のモデルについて保存したレベルをクリアするには、`/effort auto` を実行します。Claude Code は、他のエントリとトップレベルの `effortLevel` をそのまま残します。

### `outputStyle`

名前で[出力スタイル](https://code.claude.com/docs/ja/output-styles.md)を選択します。出力スタイルとは、Claude の役割、トーン、出力形式を変更する指示の保存済みセットで、組み込みの Explanatory スタイルや Learning スタイル、または自分で作成したスタイルなどがあります。

セッション中にこのキーを変更すると、Claude は次のメッセージから新しいスタイルを使用します。そのメッセージのプロンプトキャッシュにおけるコストについては、[出力スタイルの変更](https://code.claude.com/docs/ja/prompt-caching.md#changing-output-style)を参照してください。v2.1.251 より前は、変更は `/clear` を実行するか新しいセッションを開始した後にのみ適用されていました。

* **スコープ**: [`Any file`](#scopes)
* **型**: 文字列。[組み込み](https://code.claude.com/docs/ja/output-styles.md#built-in-output-styles)または[カスタム](https://code.claude.com/docs/ja/output-styles.md#create-a-custom-output-style)の出力スタイルの名前
* **デフォルト**: 未設定。Claude Code はデフォルトのスタイルを使用します

この例では、タスクの合間に教育的な解説を追加する組み込みの Explanatory スタイルを選択します。

```json settings.json theme={null}
{
  "outputStyle": "Explanatory"
}
```

### `promptCacheTtl`

[プロンプトキャッシュ](https://code.claude.com/docs/ja/prompt-caching.md)がメインの会話を保持する期間を選択します。このキーは、対話、`-p`、および Agent SDK のターンと、それらとインラインで Claude Code が実行するヘルパーに適用されます。1 時間の有効期間では、長めの休憩をはさんでもキャッシュがウォームな状態に保たれますが、API は 5 分の有効期間よりも[高い料金で各キャッシュ書き込みを請求](https://platform.claude.com/docs/en/build-with-claude/prompt-caching#pricing)します。Claude Code v2.1.242 以降が必要です。

* **スコープ**: [`Any file`](#scopes)
* **型**: 文字列。次のいずれか:
  * `"5m"`: キャッシュは 5 分間保持されます
  * `"1h"`: キャッシュは 1 時間保持されます
* **デフォルト**: 未設定。メインの会話の各リクエストには[デフォルトの有効期間](https://code.claude.com/docs/ja/prompt-caching.md#which-ttl-each-request-gets)が適用されます
* **セッションごとの上書き**: [`FORCE_PROMPT_CACHING_5M`](https://code.claude.com/docs/ja/env-vars) が他のすべてよりも優先され、次に [`CLAUDE_CODE_PROMPT_CACHE_TTL`](https://code.claude.com/docs/ja/env-vars)、次にこのキー、最後に [`ENABLE_PROMPT_CACHING_1H`](https://code.claude.com/docs/ja/env-vars) の順になります

この例では、メインの会話を 1 時間の有効期間に保ち、サブエージェントは 5 分のままにします。

```json settings.json theme={null}
{
  "promptCacheTtl": "1h",
  "subagentPromptCacheTtl": "5m"
}
```

各有効期間のコストについては、[キャッシュの有効期間](https://code.claude.com/docs/ja/prompt-caching.md#cache-lifetime)を参照してください。

### `showThinkingSummaries`

対話セッションで Claude の[拡張思考](https://code.claude.com/docs/ja/model-config.md#extended-thinking)の要約を表示します。`Ctrl+O` で思考を展開したときに完全な要約を表示したい場合に設定します。未設定または `false` の場合、Anthropic API は思考ブロックを編集済み（非表示）にし、Claude Code は折りたたまれたスタブを表示します。

* **スコープ**: [`Any file`](#scopes)
* **型**: Boolean
  * `true`: `Ctrl+O` で思考を展開すると、完全な思考の要約が表示されます
  * `false`: Anthropic API は思考ブロックを編集済み（非表示）にし、Claude Code は折りたたまれたスタブを表示します
* **デフォルト**: `false`

```json settings.json theme={null}
{
  "showThinkingSummaries": true
}
```

編集による非表示化で変わるのは表示内容だけであり、モデルが生成する内容は変わりません。思考の費用を削減するには、代わりに[予算を下げるか思考を無効にします](https://code.claude.com/docs/ja/model-config.md#extended-thinking)。

### `subagentPromptCacheTtl`

Claude Code がメインの会話の外で行うリクエストを[プロンプトキャッシュ](https://code.claude.com/docs/ja/prompt-caching.md)が保持する期間を選択します。このキーは、[サブエージェント](https://code.claude.com/docs/ja/sub-agents.md)、[ワークフロー](https://code.claude.com/docs/ja/workflows.md)、およびコンテキスト圧縮やセッションタイトルなど、Claude Code 自身のバックグラウンドリクエストとヘルパーリクエストに適用されます。1 時間の有効期間では、長めの休憩をはさんでもキャッシュがウォームな状態に保たれますが、API は 5 分の有効期間よりも[高い料金で各キャッシュ書き込みを請求](https://platform.claude.com/docs/en/build-with-claude/prompt-caching#pricing)します。Claude Code v2.1.242 以降が必要です。

* **スコープ**: [`Any file`](#scopes)
* **型**: 文字列。次のいずれか:
  * `"5m"`: キャッシュは 5 分間保持されます
  * `"1h"`: キャッシュは 1 時間保持されます
* **デフォルト**: 未設定。これらの各リクエストには[デフォルトの有効期間](https://code.claude.com/docs/ja/prompt-caching.md#which-ttl-each-request-gets)が適用されます
* **セッションごとの上書き**: [`FORCE_PROMPT_CACHING_5M`](https://code.claude.com/docs/ja/env-vars) が他のすべてよりも優先され、次に [`CLAUDE_CODE_SUBAGENT_PROMPT_CACHE_TTL`](https://code.claude.com/docs/ja/env-vars)、次にこのキー、次にすべてのリクエストに 1 時間の有効期間を求める [`ENABLE_PROMPT_CACHING_1H`](https://code.claude.com/docs/ja/env-vars) の順になります。サブエージェント自身のフロントマターの値の優先順位については、[TTL を自分で選択する](https://code.claude.com/docs/ja/prompt-caching.md#choose-the-ttl-yourself)を参照してください

この例では、サブエージェントとメインの会話の外で行われるその他のリクエストに 1 時間の有効期間を与えます。

```json settings.json theme={null}
{
  "subagentPromptCacheTtl": "1h"
}
```

このキーは [`promptCacheTtl`](#promptcachettl) が対象としないリクエストをカバーするため、両方を設定すると Claude Code が行うすべてのリクエストの有効期間を選択できます。サブエージェントのキャッシュがメインの会話のキャッシュとどのように異なるかについては、[サブエージェントとキャッシュ](https://code.claude.com/docs/ja/prompt-caching.md#subagents-and-the-cache)を参照してください。

### `switchModelsOnFlag`

[安全性分類器がリクエストを警告した](https://code.claude.com/docs/ja/model-config.md#automatic-model-fallback)ときの動作を選択します。フォールバックモデルに切り替えて続行するか、一時停止して切り替えるかプロンプトを編集するかを選べるようにするかのいずれかです。

* **スコープ**: [`Any file`](#scopes)。`/config` では **Switch models when a message is flagged** として表示され、オプションは **Switch automatically** と **Ask each time** です。
* **型**: Boolean
  * `true`: Claude Code はフォールバックモデルに切り替えて続行します
  * `false`: 対話セッションでは、Claude Code は一時停止し、切り替えるかプロンプトを編集するかを選べるようにします。`-p` の実行など、ダイアログを表示できない場合は、警告されたリクエストはエラーとして終了します
* **デフォルト**: 未設定。Claude Code は自動的に切り替えますが、対話セッションでは[先に確認する](https://code.claude.com/docs/ja/model-config.md#ask-before-switching)場合があります

```json settings.json theme={null}
{
  "switchModelsOnFlag": false
}
```

[切り替える前に確認する](https://code.claude.com/docs/ja/model-config.md#ask-before-switching)を参照してください。

### `ultracode`

[ultracode](https://code.claude.com/docs/ja/workflows.md#let-claude-decide-with-ultracode) をオンにした状態でセッションを開始します。オンにすると、Claude はユーザーからの依頼を待たずに、実質的なタスクごとにワークフローを計画します。Claude がワークフローを計画するのは、ユーザーに対して[動的ワークフロー](https://code.claude.com/docs/ja/workflows.md)が有効で、かつモデルが `xhigh` の effort をサポートしている場合のみです。このキーはセッションの effort レベルを変更しません。ultracode はセッションが使用しているレベルで実行されます。Claude Code はこのキーを読み取りますが、書き込むことはありません。`/effort ultracode` は現在のセッションに限り ultracode をオンにします。

* **スコープ**: [`Any file`](#scopes)
* **型**: Boolean
  * `true`: ユーザーに対して動的ワークフローが有効で、かつモデルが `xhigh` をサポートしている場合、セッションは ultracode がオンの状態で開始します
  * `false`: セッションは ultracode がオフの状態で開始します
* **デフォルト**: 未設定。ultracode はオフです
* **セッションごとの上書き**: `/effort ultracode` はこのキーなしで 1 つのセッションに限り ultracode をオンにし、`/effort ultracode off` はこのキーが `true` の場合に 1 つのセッションに限りオフにします。`--effort ultracode` フラグも、1 つのセッションに限り `xhigh` の effort で ultracode をオンにします

```json settings.json theme={null}
{
  "ultracode": true
}
```

セッションの effort レベルは、[`effortLevel`](#effortlevel)、[`modelSettings`](#modelsettings)、およびその他の [effort のソース](https://code.claude.com/docs/ja/model-config.md#adjust-effort-level)から決まります。[`maxEffortLevel`](#maxeffortlevel) などの [effort の上限](https://code.claude.com/docs/ja/model-config.md#organization-effort-limits)は、ultracode をオフにすることなくそのレベルを引き下げます。この動作と `/effort ultracode off` の形式には Claude Code v2.1.284 以降が必要です。v2.1.284 より前は、`ultracode: true` はセッションを `xhigh` の effort で実行し、`xhigh` 未満の effort の上限があると ultracode はオフのままでした。Agent SDK の `apply_flag_settings` コントロールリクエストもこのキーを受け付けます。

## 権限設定

Claude が何を確認なしで実行できるか、セッションがどの権限モードで開始するか、auto モードの分類器が何を許可するかを決定します。ルール構文と権限モデルについては、[権限を設定する](https://code.claude.com/docs/ja/permissions.md)を参照してください。

### `allowManagedPermissionRulesOnly`

管理設定を権限ルールの唯一の設定ソースにします。Claude Code はユーザー、プロジェクト、ローカル、および `--settings` ファイル内の `allow`、`ask`、`deny` ルールを無視し、`--allowedTools` を無視し、権限プロンプトで常に許可する選択肢を非表示にし、新しいルールの保存を停止します。

[埋め込みホストからの親設定](https://code.claude.com/docs/ja/managed-settings.md#let-an-embedding-host-add-policy)が適用される場合、Claude Code はそれらを管理層の一部として扱います。それらの `allow` ルールと `additionalDirectories` を削除し、`deny` および `ask` ルールは保持します。ただし、パターンが `!` で始まる `Read` および `Edit` ルールは除きます。このキーを設定しているかどうかに関わらず、ホストは `!` ルールで管理ルールからパスを除外することはできません。

`--disallowedTools` ルールと現在のセッションの `deny` および `ask` ルールは、Claude Code が設定をセッション中に再度読み込んだ後を含めて、引き続き適用されます。これらは制限のみを行うため、管理ルールが付与するものを拡大することはできません。v2.1.257 より前では、Claude Code は最初の設定再度読み込み時にそれらのコマンドラインおよびセッションルールを削除していました。

`--disallowedTools` またはセッションルール内の `!` パターンが除外できるものについては、[Read および Edit ルール](https://code.claude.com/docs/ja/permissions.md#read-and-edit)を参照してください。

このキーを設定すると、Claude Code v2.1.282 以降では、次のソースにあるスキルおよび `.claude/commands/` ファイルの [`allowed-tools`](https://code.claude.com/docs/ja/skills#pre-approve-tools-for-a-skill) フロントマターも無視されます。

* リポジトリの `.claude/` ディレクトリ
* `~/.claude/skills/` および `~/.claude/commands/` ディレクトリ（[claude.ai から同期されたスキル](https://code.claude.com/docs/ja/skills.md#where-synced-skills-load)を含む）
* `--add-dir` ディレクトリ
* `~/.claude/skills/` またはプロジェクトの `.claude/skills/` 内で [`.claude-plugin` マニフェストにより宣言されたプラグイン](https://code.claude.com/docs/ja/plugins/loading#plugins-shared-through-a-repository)
* 1 つのセッションに対してのみ読み込まれ、ID が [`@inline`](https://code.claude.com/docs/ja/plugins/loading#find-where-a-plugin-came-from) で終わるプラグイン（次のすべてが満たされる場合）
  * セッションが、Claude Desktop アプリ自体が Claude Code を起動する [Code セッション](https://code.claude.com/docs/ja/desktop.md#environment-configuration)または [Cowork セッション](https://code.claude.com/docs/ja/managed-settings.md#where-and-when-a-policy-applies)である（クラウドセッションを除く）
  * 埋め込みホストの[親設定](https://code.claude.com/docs/ja/managed-settings.md#let-an-embedding-host-add-policy)だけでなく、管理設定がこのキーを設定している
  * セッションが Claude Code v2.1.305 以降で実行されている

管理設定からのスキルとバンドルスキルは `allowed-tools` を保持します。これらの Desktop セッション外の `@inline` プラグインも、[`anthropic-skills`](https://code.claude.com/docs/ja/skills#names-reserved-for-synced-skills) という名前のものを除き、それを保持します。スキルの `disallowed-tools` は引き続き適用されます。Claude Code がこのフィールドを無視したときに開発者に何が表示されるかについては、[管理権限ルールのみが適用される場合](https://code.claude.com/docs/ja/skills.md#when-only-managed-permission-rules-apply)を参照してください。

* **スコープ**: [`Managed`](#scopes)
* **タイプ**: ブール値
  * `true`: 管理設定が権限ルールの唯一の設定ソースになります
  * `false`: Claude Code は管理ルールに加えて、ユーザー、プロジェクト、ローカル、および `--settings` ファイルから権限ルールを適用します
* **デフォルト**: 未設定。Claude Code はユーザー、プロジェクト、ローカル設定、および `--settings` から権限ルールを管理ルールに加えて適用します

```json managed-settings.json theme={null}
{
  "allowManagedPermissionRulesOnly": true
}
```

このキーは MCP サーバーの許可リストをロックダウンしません。そのためには、[`allowManagedMcpServersOnly`](#allowmanagedmcpserversonly)を設定してください。[管理のみの設定](https://code.claude.com/docs/ja/managed-settings.md#managed-only-settings)を参照してください。

### `autoMode`

[auto モード](https://code.claude.com/docs/ja/permission-modes.md#eliminate-prompts-with-auto-mode)の分類器がブロックおよび許可するものに独自のルールを追加します。これを使用して、分類器に組織が信頼するリポジトリ、バケット、ドメインを伝え、日常的な内部操作のブロックを停止させます。分類器には[組み込みの許可および拒否ルール](https://code.claude.com/docs/ja/auto-mode-config.md#inspect-the-defaults-and-your-effective-config)が付属しています。リテラル文字列 `"$defaults"` を配列に含めて、それらの組み込みルールをその位置に保持し、その周りに独自のルールを追加します。省略すると、それらを独自のルールに置き換えます。

* **スコープ**: [`User or managed`](#scopes)
* **タイプ**: `environment`、`allow`、`soft_deny`、`hard_deny` の散文ルール配列、および [`classifyAllShell`](#automode-classifyallshell) ブール値を含むオブジェクト
* **デフォルト**: 未設定。分類器は[組み込みルール](https://code.claude.com/docs/ja/auto-mode-config.md#inspect-the-defaults-and-your-effective-config)のみを使用します

この例は、`"$defaults"` を通じて組み込みの `soft_deny` ルールを保持し、`terraform apply` をブロックするルールを 1 つ追加します。

```json settings.json theme={null}
{
  "autoMode": {
    "soft_deny": ["$defaults", "Never run terraform apply"]
  }
}
```

これらのファイルの複数が同じ配列を設定する場合、Claude Code はエントリを連結します。ルール形式と各配列の適用方法については、[auto モードを設定する](https://code.claude.com/docs/ja/auto-mode-config.md)を参照してください。

### `autoMode.classifyAllShell`

auto モードがアクティブな間、すべての Bash および PowerShell コマンドを auto モードの分類器に通します。デフォルトでは、auto モードは任意のコードを実行できる許可ルールのみを一時停止します。具体的には、`Bash(*)` などのツール全体およびワイルドカードのルールと、`Bash(python *)` などのインタープリタまたはシェルラッパーのプレフィックスです。`Bash(npm test)` など、それ以外の許可ルールに一致するコマンドは、[コマンドごとの許可ドメイン](https://code.claude.com/docs/ja/sandboxing.md#per-command-allowed-domains-in-auto-mode)を持たない限り分類器をスキップします。スキップした場合、ルールのプレフィックスが想定していなかった破壊的な引数が見過ごされたまま通過する可能性があります。このキーを設定すると、セッションのすべてのシェル許可ルールが一時停止され、分類器がすべてのコマンドを確認します。Claude Code v2.1.193 以降が必要です。

* **スコープ**: [`User or managed`](#scopes)。[`autoMode`](#automode)が読み取られる場所で読み取られます。
* **タイプ**: ブール値
  * `true`: auto モードがアクティブな間、Claude Code はすべての Bash および PowerShell コマンドを分類器に通し、シェル許可ルールを一時停止します。auto モード外では、ルールは引き続き適用されます
  * `false`: auto モードは `Bash(*)` や `Bash(python *)` など、任意のコードを実行できる許可ルールのみを一時停止します。それ以外の許可ルールに一致するコマンドは、[コマンドごとの許可ドメイン](https://code.claude.com/docs/ja/sandboxing.md#per-command-allowed-domains-in-auto-mode)を持たない限り分類器をスキップし、その他すべてのシェルコマンドは分類器を通ります
* **デフォルト**: `false`

```json settings.json theme={null}
{
  "autoMode": {
    "classifyAllShell": true
  }
}
```

[すべてのシェルコマンドを分類器にルーティングする](https://code.claude.com/docs/ja/auto-mode-config.md#route-all-shell-commands-through-the-classifier)を参照してください。

### `disableAutoMode`

[auto モード](https://code.claude.com/docs/ja/permission-modes.md#eliminate-prompts-with-auto-mode)を `Shift+Tab` サイクルから削除します。`--permission-mode auto`、設定ファイル、または組み込みデフォルトから[auto モードで開始](https://code.claude.com/docs/ja/permission-modes.md#which-mode-a-session-starts-in)する可能性があるセッションは、代わりに `default` で開始します。管理者は管理設定で設定して、組織内の開発者が auto モードを使用するのを防ぎます。

* **スコープ**: [`Any file`](#scopes)。[管理設定](https://code.claude.com/docs/ja/managed-settings.md)で最も有用です。ユーザーはそれを上書きできません。`permissions` の下で `permissions.disableAutoMode` としても受け入れられます。
* **タイプ**: 文字列 `"disable"`
* **デフォルト**: 未設定

```json settings.json theme={null}
{
  "disableAutoMode": "disable"
}
```

### `permissions`

Claude が確認なしで使用できるツール、常にプロンプトを表示するツール、ブロックされるツールを制御し、セッションが開始する[権限モード](https://code.claude.com/docs/ja/permission-modes.md)を設定します。以下のすべての `permissions.*` キーはこのオブジェクトの下にネストされます。

* **スコープ**: [`Any file`](#scopes)
* **タイプ**: `allow`、`ask`、`deny`、`additionalDirectories`、`blockReadsOutsideWorkingDirectories`、`defaultMode`、`disableBypassPermissionsMode`、`disableAutoMode` を含むオブジェクト
* **デフォルト**: 未設定

この例は `npm run` コマンドを確認なしで承認し、`git push` の前にプロンプトを表示し、`.env` の読み取りをブロックし、セッションを `acceptEdits` で開始します。

```json settings.json theme={null}
{
  "permissions": {
    "allow": ["Bash(npm run *)"],
    "ask": ["Bash(git push *)"],
    "deny": ["Read(./.env)"],
    "defaultMode": "acceptEdits"
  }
}
```

3 つのルール配列は 1 つの構文を共有します。`permissions.allow` の下の[権限ルール構文](#permission-rule-syntax)を参照してください。異なるファイルからの権限ルールがどのように結合されるかについては、[スコープ全体での権限ルールのマージ方法](https://code.claude.com/docs/ja/permissions.md#settings-precedence)を参照してください。一般的に設定キーがどのように結合されるかについては、設定ガイドの[設定の優先順位](https://code.claude.com/docs/ja/settings.md#settings-precedence)を参照してください。

### `useAutoModeDuringPlan`

Claude Code が plan モード中にシェルコマンドを確認するために auto モードの分類器を使用するかどうかを選択します。デフォルトの `true` では、auto モードが利用可能な場合、分類器は計画中に各コマンドを確認し、プロンプトは表示されません。ただし、[重要パスの削除](https://code.claude.com/docs/ja/permission-modes.md#critical-paths)を除きます。`false` に設定すると、組み込みの読み取り専用セット外のすべてのコマンドに対して権限プロンプトが表示されます。`/config` に **Use auto mode during plan** として表示されます。

* **スコープ**: [`User, local, or managed`](#scopes)。リポジトリがこれをオフにすることはできません。
* **タイプ**: ブール値
  * `true`: 未設定と同じです。auto モードが利用可能な場合、分類器は計画中に各シェルコマンドを確認し、プロンプトを表示しません。ただし、[重要パスの削除](https://code.claude.com/docs/ja/permission-modes.md#critical-paths)を除きます。これらのファイルのいずれかで `false` が設定されていれば、引き続きオフになります
  * `false`: 組み込みの読み取り専用セット外のすべてのコマンドに対して権限プロンプトが表示されます
* **デフォルト**: `true`

```json settings.json theme={null}
{
  "useAutoModeDuringPlan": false
}
```

### `permissions.allow`

Claude Code が確認なしで承認するツール使用をリストします。MCP ルールでは、`*` はツール名内の `mcp__<server>__` プレフィックスの後にのみ使用できます（例：`mcp__github__get_*`）。サーバー名には使用できません。

* **スコープ**: [`Any file`](#scopes)
* **タイプ**: 権限ルール文字列の配列
* **デフォルト**: 未設定
* **セッションごとの上書き**: `--allowedTools` は 1 つのセッションに許可ルールを追加しますが、任意の設定ファイルからの拒否ルールは、それが指定するツールを引き続きブロックします

この例は `git diff` を承認し、Claude Code が確認なしに `.zshrc` を読み取ることを許可します。

```json settings.json theme={null}
{
  "permissions": {
    "allow": ["Bash(git diff *)", "Read(~/.zshrc)"]
  }
}
```

Claude Code はプロジェクトの `.claude/settings.json` から `allow` ルールを適用するのは、そのフォルダの[ワークスペース信頼ダイアログ](https://code.claude.com/docs/ja/permissions.md#project-allow-rules-and-workspace-trust)を受け入れた後のみです。

#### 権限ルール構文

権限ルールは `Tool` または `Tool(specifier)` の形式に従います。Claude Code は `deny` ルールを最初に評価し、次に `ask`、次に `allow` を評価し、各ルールの具体性に関係なく最初に一致したものが結果を決定します。[権限ルール評価順序](https://code.claude.com/docs/ja/permissions.md#manage-permissions)を参照してください。

各行は 1 つのルール形状とそれが一致するものを示します。

| ルール | 一致するもの |
| :- | :- |
| `Bash` | すべての Bash コマンド |
| `Bash(npm run *)` | `npm run` で始まるコマンド |
| `Read(./.env)` | `.env` ファイルの読み取り |
| `WebFetch(domain:example.com)` | example.com へのフェッチリクエスト |

ワイルドカード動作、Read、Edit、WebFetch、MCP、Agent ルールのツール固有パターン、および Bash パターンのセキュリティ制限を含む完全なルール構文については、[権限ルール構文](https://code.claude.com/docs/ja/permissions.md#permission-rule-syntax)を参照してください。

### `permissions.ask`

`acceptEdits` や `bypassPermissions` など、本来であれば承認される権限モードであっても確認を求めるツール使用をリストします。`dontAsk` モードでは、Claude Code は一致するツール使用に対してプロンプトを表示する代わりに拒否します。

* **スコープ**: [`Any file`](#scopes)
* **タイプ**: 権限ルール文字列の配列
* **デフォルト**: 未設定

```json settings.json theme={null}
{
  "permissions": {
    "ask": ["Bash(git push *)"]
  }
}
```

### `permissions.deny`

Claude Code がブロックするツール使用をリストします。API キー、シークレット、または環境値を保持するファイルに使用します。Claude Code は一致するファイルをファイル検出と検索結果から除外し、それらの読み取りを拒否し、一致するパスの[Edit および Write ツール](https://code.claude.com/docs/ja/permissions.md#read-and-edit)をブロックします。

Read および Edit 拒否ルールは Claude の組み込みファイルツール、Claude Code が Bash で認識するファイルコマンド（`cat`、`head`、`tail`、`sed`、`tee` など）、および `> file` や `< file` などの Bash [リダイレクション](https://code.claude.com/docs/ja/permissions.md#redirections)のターゲットに適用されます。ファイル名を指定せずにファイルを読み取るコマンド（`grep -r pattern .` など）や任意のサブプロセスには適用されないため、OS レベルで強制するには[サンドボックスを有効にして](https://code.claude.com/docs/ja/sandboxing.md)ください。

* **スコープ**: [`Any file`](#scopes)
* **タイプ**: 権限ルール文字列の配列
* **デフォルト**: 未設定
* **セッションごとの上書き**: `--disallowedTools` はこのキーと並行して 1 つのセッションに拒否ルールを追加します

この例は `.env` ファイル、`secrets` ディレクトリ、認証情報ファイルの読み取りを拒否し、`curl` コマンドをブロックします。

```json settings.json theme={null}
{
  "permissions": {
    "deny": [
      "Read(./.env)",
      "Read(./.env.*)",
      "Read(./secrets/**)",
      "Read(./config/credentials.json)",
      "Bash(curl *)"
    ]
  }
}
```

ツール名はグロブパターンを受け入れるため、`"*"` はすべてのツールを拒否し、`"mcp__*"` はすべての MCP ツールを拒否します。Claude Code は、他のツールがまだ Claude で利用可能である限り、[`EndConversation`](https://code.claude.com/docs/ja/tools-reference#endconversation-tool-behavior)ツールの拒否ルールを無視します。`Bash` 拒否ルールは Claude が書いたコマンドと一致するため、`Bash(curl *)` は `/usr/bin/curl` や `sh -c 'curl …'` を停止しません。[Bash ルールが一致しないもの](https://code.claude.com/docs/ja/permissions.md#bash-rule-limits)を参照してください。このキーは非推奨の `ignorePatterns` 設定に置き換わるものです。

### `permissions.additionalDirectories`

Claude に開始したディレクトリ外のディレクトリへのファイルアクセスを付与し、追加の[作業ディレクトリ](https://code.claude.com/docs/ja/permissions.md#working-directories)として使用します。ほとんどの `.claude/` 設定は、これらのディレクトリから[検出されません](https://code.claude.com/docs/ja/permissions.md#additional-directories-grant-file-access-not-configuration)。

* **スコープ**: [`Any file`](#scopes)。ただし、プロジェクトおよびローカルのエントリが付与するサンドボックスの書き込みアクセスには[制限](https://code.claude.com/docs/ja/sandboxing.md#repository-settings-under-an-admin-required-sandbox)があります
* **タイプ**: ディレクトリパスの配列
* **デフォルト**: 未設定
* **セッションごとの上書き**: `--add-dir` および `/add-dir` はこのキーと並行して 1 つのセッションにディレクトリを追加します

```json settings.json theme={null}
{
  "permissions": {
    "additionalDirectories": ["../docs/"]
  }
}
```

`allow` ルールと同様に、プロジェクトの `.claude/settings.json` のエントリは、そのフォルダの[ワークスペース信頼ダイアログ](https://code.claude.com/docs/ja/permissions.md#project-allow-rules-and-workspace-trust)を受け入れた後にのみ有効になります。

### `permissions.blockReadsOutsideWorkingDirectories`

`bypassPermissions` を含むすべての権限モードで、Claude のファイルツールが[作業ディレクトリ](https://code.claude.com/docs/ja/permissions.md#working-directories)外の読み取りを拒否するようにします。Claude Code はそれらのパスに対する `Read`、`Grep`、`Glob`、`LSP` の呼び出しを拒否し、`/add-dir` でディレクトリを追加するようユーザーに求めるよう Claude に指示します。Claude Code 自体が必要とするファイル（`~/.claude/` の下のスキル、プラグイン、ルール、エージェント、コマンド、`CLAUDE.md` メモリファイルなど）は読み取り可能なままです。Claude Code v2.1.257 以降が必要です。

Claude Code はシェルコマンドを同じ方法では拒否しません。

* [どのモードでも自動承認されないアクション](https://code.claude.com/docs/ja/permission-modes.md#actions-no-mode-auto-approves)では、そのようなパスを読み取るシェルコマンドがいつプロンプトを表示するかを説明しています
* [ブロック下のサンドボックス化されたコマンド](#sandboxed-commands-under-the-block)では、サンドボックス化されたコマンドが何を読み取れるかを説明しています

シェルパーサーが追跡できない Bash コマンド（複数回ディレクトリを変更するものやサブシェルを実行するものなど）は、auto モードおよび `bypassPermissions` モードでもプロンプトを表示します。プロンプトは、コマンドが作業ディレクトリ外のパスを指定していない場合でも表示されます。このプロンプトは、コマンドが[サンドボックス](https://code.claude.com/docs/ja/sandboxing.md)で実行され、サンドボックスがブロックを強制する場合には適用されません。

また、[作業ディレクトリ外の最初の読み取り前に表示される auto モードのプロンプト](https://code.claude.com/docs/ja/permission-modes.md#first-read-outside-the-working-directories)でそのような読み取りをブロックすることを選択した場合も、Claude Code はここに `true` を書き込みます。

* **スコープ**: [`Any file`](#scopes)。いずれかのファイルの `true` が適用されるため、リポジトリは自身に対してブロックをオンにできますが、ユーザーが設定したブロックを解除することはできません。
* **タイプ**: ブール値
  * `true`: Claude のファイルツールは作業ディレクトリ外の読み取りを拒否します
  * `false`: 未設定と同じです。別のファイルが `true` を設定している場合、ブロックは引き続き適用されます
* **デフォルト**: 未設定。作業ディレクトリ外の読み取りは[権限モード](https://code.claude.com/docs/ja/permission-modes.md)に従います

```json settings.json theme={null}
{
  "permissions": {
    "blockReadsOutsideWorkingDirectories": true
  }
}
```

`--add-dir`、`/add-dir`、またはユーザー設定や管理設定の `additionalDirectories` で追加したディレクトリは、ブロックにおいて作業ディレクトリとしてカウントされます。リポジトリ設定でのみ追加されたディレクトリはカウントされません。該当するのは `.claude/settings.json` のディレクトリと、git がそのファイルを未追跡として報告する場合を除く `.claude/settings.local.json` のディレクトリです。git リポジトリではないディレクトリ、または git がそのファイルを追跡している場合、Claude Code は `.claude/settings.local.json` をリポジトリ設定として扱うため、読み取り可能にしておきたいディレクトリは代わりにユーザー設定に配置してください。

[`autoMemoryDirectory`](#automemorydirectory)がプロジェクトの `.claude/settings.json` から、または[リポジトリ提供として扱われる](https://code.claude.com/docs/ja/permissions.md#when-your-local-settings-file-needs-trust)`.claude/settings.local.json` から来る場合、Claude Code はそのディレクトリから[自動メモリ](https://code.claude.com/docs/ja/memory.md#storage-location)を読み込まず、そこに保存もしません。

ブロックを解除するには、それを設定しているすべての設定ファイルからキーを削除し、新しいセッションを開始します。

#### ブロック下のサンドボックス化されたコマンド

[サンドボックス化](https://code.claude.com/docs/ja/sandboxing.md)がオンの場合、ブロックはサンドボックス化されたコマンドにも適用されます。Claude Code はホームディレクトリおよびユーザーファイルを保持する他のルート（`/Users`、`/home`、`/root`、`/Volumes`、`/mnt`、`/media`、`/run/media`、`/srv`）への読み取りアクセスを拒否します。その後、作業ディレクトリ、Claude Code がセッション中に作成する [worktree](https://code.claude.com/docs/ja/worktrees.md)、セッションの一時ディレクトリ、およびコマンドが必要とする `~/.claude` の部分（スキルやプラグインなど）を再度開きます。ブロックが有効な間、リポジトリ設定からの `allowRead` および `allowWrite` エントリはカウントされません。

セッションの作業ディレクトリがリンクされた [git worktree](https://code.claude.com/docs/ja/worktrees.md) である場合（Claude Code がセッション中に入ったものを含む）、リポジトリの共通 `.git` ディレクトリはサンドボックス化されたコマンドに対して読み取り可能および書き込み可能なままなので、git はそこで引き続き機能します。

次の場合、ブロックはサンドボックス化されたコマンドには及びませんが、Claude のファイルツールは引き続きそれを強制します。

* ファイルシステム分離が [`sandbox.filesystem.disabled`](#sandbox-filesystem-disabled) によってオフになっている
* [`allowManagedReadPathsOnly`](#sandbox-filesystem-allowmanagedreadpathsonly) が設定されている
* Claude Code を開始したディレクトリのパスに `*`、`?`、`[` などのグロブ文字が含まれている

ブロック下で、Claude Code はサンドボックス化されたコマンドに対してグローバル git 設定ファイルを再度開くため、`git` はユーザーのアイデンティティと設定を保持します。

* `~/.gitconfig`
* `$XDG_CONFIG_HOME/git` の下の `config`、`ignore`、`attributes` ファイル（デフォルトは `~/.config/git`）
* グローバル git 設定が `[include]`、`[includeIf]`、`core.excludesFile`、`core.attributesFile` を通じて指定するファイル

Claude Code は各ファイルを個別に判断します。ファイルが、サンドボックス化されたコマンドが直接またはシンボリックリンクを通じて書き込める場所にある場合、Claude Code はそのファイルが指定するファイルを再度開きません。

Linux および WSL2 では、シンボリックリンクである設定ファイルはそれ自身のパスで読み取り不可のままになることがあり、その場合 `git` はそのファイルなしで実行されます。`~/.git-credentials` および `$XDG_CONFIG_HOME/git/credentials` はブロックされたままです。

再度開いたファイルがシークレット（`http.extraHeader` トークンなど）を保持する場合、そのパスを [`sandbox.filesystem.denyRead`](#sandbox-filesystem-denyread) に追加してください。ファイルをカバーする `denyRead` エントリは、常にこの再度開く処理より優先されます。

### `permissions.defaultMode`

新しいセッションが開始する[権限モード](https://code.claude.com/docs/ja/permission-modes.md)を設定します。未設定のままにすると、セッションは使用しているサーフェスの[組み込みデフォルト](https://code.claude.com/docs/ja/permission-modes.md#which-mode-a-session-starts-in)で開始します。

* **スコープ**: [`Any file`](#scopes)。`auto` および `bypassPermissions` はプロジェクトまたはローカル設定からは有効にならないため、代わりに `~/.claude/settings.json` で設定してください。v2.1.257 より前では、`bypassPermissions` は任意のファイルから有効になりました。VS Code 拡張機能が開始する会話の場合、Claude Code はユーザー、管理、および `--settings` の値のみを読み取ります。
* **タイプ**: 文字列。次のいずれか：
  * `"default"`: Claude Code は確認なしで読み取りのみを実行します
  * `"acceptEdits"`: Claude Code は確認なしでファイル編集と `mkdir` や `mv` などの一般的なファイルシステムコマンドも実行します
  * `"plan"`: Claude Code は読み取りと計画を行いますが、計画を承認するまで編集をブロックします
  * `"auto"`: Claude Code は日常的なプロンプトなしで実行します。シェルコマンドやネットワークリクエストなどのアクションが実行される前に、バックグラウンドの分類器がそれらがユーザーのリクエストに沿っているかを確認します
  * `"dontAsk"`: Claude Code はプロンプトを表示するはずのすべての呼び出しを自動的に拒否します。ただし、インストールした [mod](https://code.claude.com/docs/ja/plugins/mods/overview.md) は[それらの呼び出しの一部](https://code.claude.com/docs/ja/permissions.md#precedence-among-rules-hooks-and-mods)を引き続き承認できます。作業ディレクトリ内のファイル読み取り、承認が不要な他のアクション、事前承認されたツールは引き続き実行されます。ただし、[ネットワークパス](https://code.claude.com/docs/ja/permissions.md#network-paths)からの読み取りは除きます
  * `"bypassPermissions"`: Claude Code はすべてを確認なしで実行します
  * `"manual"`: `"default"` のエイリアス
* **デフォルト**: 未設定
* **セッションごとの上書き**: `--permission-mode`、および `bypassPermissions` に相当する `--dangerously-skip-permissions` は、1 つのセッションにおいてこのキーより優先されます

```json settings.json theme={null}
{
  "permissions": {
    "defaultMode": "acceptEdits"
  }
}
```

権限ルールはすべてのモードの上に重ねて適用されます。`deny` ルールは `bypassPermissions` を含むすべてのモードでブロックします。[権限モード](https://code.claude.com/docs/ja/permission-modes.md)を参照してください。クラウドセッションでは、Claude Code はこのキーのうち `acceptEdits`、`plan`、`default`、`auto` のみを尊重します。VS Code 拡張機能が開始する会話については、[拡張機能が開始権限モードとして読み取る設定](https://code.claude.com/docs/ja/permission-modes.md#switch-permission-modes)を参照してください。

### `permissions.disableBypassPermissionsMode`

誰も `bypassPermissions` モードに入れないようにします。Claude Code は `--dangerously-skip-permissions` フラグを拒否し、[エージェント定義](https://code.claude.com/docs/ja/sub-agents.md#permission-modes)の `permissionMode: bypassPermissions` を無視するため、サブエージェントは親セッションの権限モードで実行されます。

* **スコープ**: [`Any file`](#scopes)。通常、組織のポリシーを強制するために[管理設定](https://code.claude.com/docs/ja/managed-settings.md)で設定します。
* **タイプ**: 文字列 `"disable"`
* **デフォルト**: 未設定
* **セッションごとの上書き**: このキーは `--dangerously-skip-permissions` より優先されます。キーが設定されている間、Claude Code はそのフラグを拒否します

```json settings.json theme={null}
{
  "permissions": {
    "disableBypassPermissionsMode": "disable"
  }
}
```

v2.1.223 より前では、Claude Code はバイパスが無効になっていてもフロントマターの権限モードを適用していました。

### `skipAutoPermissionPrompt`

組み込みデフォルトによってセッションが auto モードで開始された場合ではなく、ユーザー自身の設定やモードセレクターなどを通じて初めて auto モードに入ったときに Claude Code が表示する、[auto モード](https://code.claude.com/docs/ja/permission-modes.md#eliminate-prompts-with-auto-mode)を説明する 1 回限りの通知をスキップします。Claude Code はその通知を 1 回表示した後、表示済みであることを記録するため、このキーは通知がまだ表示されていない場合にのみ意味を持ちます。

* **スコープ**: [`User or managed`](#scopes)。リポジトリがこれを設定することはできません。
* **タイプ**: ブール値
  * `true`: Claude Code は通知をスキップします
  * `false`: 未設定と同じです。これらのファイルのいずれかが `true` を設定しない限り、通知が 1 回表示されます
* **デフォルト**: 未設定。通知が 1 回表示されます

```json settings.json theme={null}
{
  "skipAutoPermissionPrompt": true
}
```

### `skipDangerousModePermissionPrompt`

`--dangerously-skip-permissions` からか `defaultMode: "bypassPermissions"` からかに関わらず、セッションが `bypassPermissions` モードに入る前に Claude Code が表示する確認ダイアログをスキップします。そのダイアログを一度受け入れると、Claude Code はユーザー設定のこのキーに `true` を書き込みます。

* **スコープ**: [`User, local, or managed`](#scopes)。信頼されていないリポジトリがダイアログをスキップさせることはできません。
* **タイプ**: ブール値
  * `true`: Claude Code はセッションが `bypassPermissions` モードに入る前の確認ダイアログをスキップします
  * `false`: 未設定と同じです。これらのファイルのいずれかが `true` を設定しない限り、ダイアログが表示されます
* **デフォルト**: 未設定。ダイアログが表示されます

```json settings.json theme={null}
{
  "skipDangerousModePermissionPrompt": true
}
```

## サンドボックス設定

Claude が実行するコマンドをファイルシステム、ネットワーク、認証情報から分離します。サンドボックスの仕組みとプラットフォーム要件については、[サンドボックス](https://code.claude.com/docs/ja/sandboxing.md)を参照してください。

### `sandbox`

[サンドボックス](https://code.claude.com/docs/ja/sandboxing.md)を使用して、Claude が実行する Bash コマンドをファイルシステムとネットワークから分離します。`enabled` でサンドボックスをオンにしてから、`filesystem`、`network`、`credentials` サブオブジェクトを使用して、サンドボックス化されたコマンドが何にアクセスできるかを制限または拡大します。サンドボックスは macOS、Linux、WSL2 で実行されます。

* **Scope**: [`Any file`](#scopes)
* **型**: `enabled`、`failIfUnavailable`、`autoAllowBashIfSandboxed`、`excludedCommands`、`allowUnsandboxedCommands`、`enableWeakerNestedSandbox`、`enableWeakerNetworkIsolation`、`allowAppleEvents`、`allowNestedUserNamespaces`、`bwrapPath`、`socatPath`、`ignoreViolations`、`ripgrep` に加え、`filesystem`、`network`、`credentials` の各オブジェクトを持つオブジェクト
* **Default**: 未設定。Claude Code はサンドボックスなしでコマンドを実行します

これはサンドボックスをオンにし、サンドボックス化されたコマンドの権限プロンプトをスキップし、`docker` をサンドボックスの外で実行し、2 つの追加の書き込みパスを開き、AWS 認証情報ファイルを非表示にし、GitHub と npm を事前に許可します：

```json settings.json theme={null}
{
  "sandbox": {
    "enabled": true,
    "autoAllowBashIfSandboxed": true,
    "excludedCommands": ["docker *"],
    "filesystem": {
      "allowWrite": ["/tmp/build", "~/.kube"],
      "denyRead": ["~/.aws/credentials"]
    },
    "network": {
      "allowedDomains": ["github.com", "*.npmjs.org"]
    }
  }
}
```

管理設定が `enabled` や `failIfUnavailable` などのブール値キーを設定した場合、その値は開発者が設定したものをすべて上書きします。Claude Code は配列キーをセッションが読み込む設定スコープ全体でマージするため、開発者はエントリを追加できます。管理設定専用のロックについては、[ポリシーの拡大を開発者に防止させる](https://code.claude.com/docs/ja/sandboxing.md#keep-developers-from-widening-the-policy)を参照してください。組織に対してサンドボックスを必須にするには、[管理設定でサンドボックスを強制する](https://code.claude.com/docs/ja/sandboxing.md#enforce-sandboxing-with-managed-settings)を参照してください。

### `sandbox.enabled`

Bash コマンドの[サンドボックス](https://code.claude.com/docs/ja/sandboxing.md)をオンにします。`/sandbox` パネルでモードを選択すると、Claude Code はこのキーを現在のプロジェクトの `.claude/settings.local.json` に書き込みます。`~/.claude/settings.json` に設定して、すべてのプロジェクトをサンドボックス化します。

* **Scope**: [`Any file`](#scopes)（[プロジェクト設定とローカル設定には制限あり](https://code.claude.com/docs/ja/sandboxing.md#repository-settings-under-an-admin-required-sandbox)）
* **Type**: ブール値
  * `true`: Claude Code は Bash コマンドをサンドボックス化します
  * `false`: Bash コマンドはサンドボックスなしで実行されます
* **Default**: `false`

```json settings.json theme={null}
{
  "sandbox": {
    "enabled": true
  }
}
```

Linux と WSL2 では、サンドボックスは `bubblewrap` と `socat` が必要です。[Linux と WSL2 をセットアップする](https://code.claude.com/docs/ja/sandboxing.md#set-up-linux-and-wsl2)を参照してください。サンドボックスが起動できない場合、[`failIfUnavailable`](#sandbox-failifunavailable) も設定していない限り、Claude Code はコマンドをサンドボックスなしで実行します。

### `sandbox.failIfUnavailable`

`sandbox.enabled` が `true` であるにもかかわらず、依存関係の不足やプラットフォームの非対応によりサンドボックスが起動できない場合に、Claude Code がスタートアップ時にエラーで終了するようにします。このキーがない場合、Claude Code はコマンドをサンドボックスなしで実行します。セキュリティゲートとしてサンドボックスを必須とする管理対象のデプロイでは、この設定を使用できます。

サンドボックスがサポートしていないプラットフォームでは、このキーがオンの場合、Claude Code は起動しません。[管理設定でサンドボックスを強制する](https://code.claude.com/docs/ja/sandboxing.md#enforce-sandboxing-with-managed-settings)を参照してください。

* **Scope**: [`Any file`](#scopes)（[プロジェクト設定とローカル設定には制限あり](https://code.claude.com/docs/ja/sandboxing.md#repository-settings-under-an-admin-required-sandbox)）
* **型**: ブール値
  * `true`: `sandbox.enabled` が `true` でもサンドボックスを起動できない場合、Claude Code は起動時にエラーで終了します。サンドボックスがこのチェックを通過した後に初期化に失敗した場合、セッションは実行を続け、Claude Code は[サンドボックス化された各コマンドを拒否します](https://code.claude.com/docs/ja/sandboxing.md#commands-refused-with-sandbox-is-required)
  * `false`: サンドボックスを起動できない場合、Claude Code はサンドボックスなしでコマンドを実行します
* **Default**: `false`

次の例では、管理対象のマシンでサンドボックスをオンにし、`failIfUnavailable` を `true` に設定します。

```json managed-settings.json theme={null}
{
  "sandbox": {
    "enabled": true,
    "failIfUnavailable": true
  }
}
```

[管理設定でサンドボックスを強制する](https://code.claude.com/docs/ja/sandboxing.md#enforce-sandboxing-with-managed-settings)を参照してください。

### `sandbox.autoAllowBashIfSandboxed`

Claude Code がサンドボックス化された Bash コマンドを権限プロンプトなしで実行できるようにします。サンドボックスで実行できないコマンドは通常の権限フローを通過し、`deny` ルールと `Bash(git push *)` などのコンテンツスコープ付き `ask` ルールは引き続き適用されます。ベアの `Bash` ask ルールはサンドボックス化されたコマンドではスキップされます。これを `false` に設定して、サンドボックス化されたコマンドも通常の権限フローを通すようにします。これは `/sandbox` **Mode** タブが通常権限モードと呼ぶものです。

* **Scope**: [`Any file`](#scopes)
* **Type**: ブール値
  * `true`: Claude Code はサンドボックス化された Bash コマンドを権限プロンプトなしで実行します。ただし、[自動許可モード](https://code.claude.com/docs/ja/sandboxing.md#auto-allow-mode)で説明されているケースを除きます。`CLAUDE_CODE_SUBPROCESS_ENV_SCRUB` は自動許可をオフにします
  * `false`: サンドボックス化されたコマンドは通常の権限フローを通過するため、許可ルールと権限モードが決定します。`/sandbox` **Mode** タブはこれを通常権限モードと呼びます
* **Default**: `true`

これはサンドボックスをオンに保ち、サンドボックス化されたコマンドを通常の権限フローを通します：

```json settings.json theme={null}
{
  "sandbox": {
    "enabled": true,
    "autoAllowBashIfSandboxed": false
  }
}
```

自動許可モードで引き続きプロンプトが表示される操作と、plan モードでの動作については、[自動許可モード](https://code.claude.com/docs/ja/sandboxing.md#auto-allow-mode)を参照してください。

### `sandbox.excludedCommands`

Claude Code がサンドボックスの外で実行するコマンド（サンドボックスで動作しないツールなど）に名前を付けます。各エントリは、`Bash(...)` [権限ルール](https://code.claude.com/docs/ja/permissions.md#permission-rule-syntax)の内容と同じ構文を使用します：正確なコマンド、`docker *` などのプレフィックス、またはワイルドカードパターン。ワイルドカードを含まないパターンは完全一致となるため、`docker` は引数なしの `docker` にのみ一致します。

エントリは、Bash 呼び出しのすべてのコマンドをカバーする場合にのみ、Bash 呼び出しをサンドボックスから外します。一部の呼び出し形式はそれでもサンドボックス化されたままです。`docker *` エントリだけでは、`npm ci && docker build .` をサンドボックスから外しません。

* **Scope**: [`Any file`](#scopes)（[プロジェクト設定とローカル設定には制限あり](https://code.claude.com/docs/ja/sandboxing.md#repository-settings-under-an-admin-required-sandbox)）
* **Type**: コマンドパターンの配列
* **Default**: 未設定。コマンドは除外されません

```json settings.json theme={null}
{
  "sandbox": {
    "excludedCommands": ["docker *"]
  }
}
```

Claude Code は、Bash 呼び出しが以下のような形状のいずれかを持つ場合、その呼び出しをサンドボックス化したままにします：

* `sudo`、`eval`、または `xargs` で始まるコマンド
* `cd`、`pushd`、または `popd`（呼び出しのどこにでも出現）
* コマンド置換、サブシェル、または `if` や `for` などの制御フロー ブロック
* `docker build . > build.log` や `<<EOF` ヒアドキュメントなどのリダイレクト（ただし `2>&1` のようにファイルディスクリプタを複製するだけのものを除く）
* 変数から来るコマンド名
* パス引数が絶対パスである、`~` で始まる、または `..` セグメントを含む `git clone`、`git init`、`git worktree add`、`git worktree move`、または `git bundle create`

たとえば、`cd build && docker compose up` は `docker *` エントリの下でサンドボックス化されたままであり、`cd` エントリを追加してもそれは変わりません。`git *` エントリの下では、`git clone <url> vendor/lib` はサンドボックスの外で実行されますが、`git clone <url> ~/tools` はサンドボックス化されたままです。クローンは、宛先パスが指す場所に、実行可能なものを含む可能性のあるファイルツリー全体を書き込みます。

除外されたコマンドも通常の権限フローを通過します。除外は便宜的なものであり、セキュリティ境界ではありません。ツールが特定の場所にのみ書き込む必要がある場合は、[`filesystem.allowWrite`](#sandbox-filesystem-allowwrite) を使えばサンドボックス化されたままにできます。

サンドボックスが[管理者必須](https://code.claude.com/docs/ja/sandboxing.md#repository-settings-under-an-admin-required-sandbox)でない限り、セッションが読み込む設定スコープのエントリは 1 つのリストに結合されます。管理者必須の間、Claude Code は `.claude/settings.json` と `.claude/settings.local.json` のエントリを無視するため、クローンしたリポジトリがコマンドをサンドボックスの外に出すことはできません。管理設定、`--settings`、および `~/.claude/settings.json` のエントリは引き続き適用され、このリストに対する管理設定専用のロックはありません。

### `sandbox.allowUnsandboxedCommands`

サンドボックスによってブロックされた後、Claude が `dangerouslyDisableSandbox` パラメータを使用してコマンドをサンドボックスの外で再試行できるようにします。`false` の場合、Claude Code はそのパラメータを無視します。その結果、サンドボックスの実行中は、Claude が実行するコマンドは [`excludedCommands`](#sandbox-excludedcommands) のエントリに一致しない限りサンドボックス化されます。`/sandbox` **Overrides** タブはその状態を**厳密なサンドボックスモード**として表示します。管理設定で `false` にすると、その対象となる開発者に対して厳密なサンドボックスモードがオンになります。

* **Scope**: [`Any file`](#scopes)（[プロジェクト設定とローカル設定には制限あり](https://code.claude.com/docs/ja/sandboxing.md#turn-off-the-retry-with-strict-sandbox-mode)）
* **Type**: ブール値
  * `true`: Claude がサンドボックスによってブロックされた後、`dangerouslyDisableSandbox` パラメータを使用してコマンドをサンドボックスの外で再試行できます
  * `false`: Claude Code はそのパラメータを無視するため、サンドボックスの実行中は、Claude が実行するコマンドは `excludedCommands` のエントリに一致しない限りサンドボックス化されます
* **Default**: `true`

これにより、管理設定がカバーするすべてのユーザーに対して厳密なサンドボックスモードが強制されます：

```json managed-settings.json theme={null}
{
  "sandbox": {
    "enabled": true,
    "allowUnsandboxedCommands": false
  }
}
```

管理設定または `--settings` からの `false` は、サンドボックスを[管理者必須](https://code.claude.com/docs/ja/sandboxing.md#repository-settings-under-an-admin-required-sandbox)にもします。ユーザー設定の `false` はプロジェクトの `true` よりも優先されますが、サンドボックスを管理者必須にはしません。プロジェクトの値よりも優先させるには Claude Code v2.1.285 以降が必要です。

サンドボックスなしの再試行を誰が承認するかは、権限モードと許可ルールによって決まります。[サンドボックスなしの再試行エスケープハッチ](https://code.claude.com/docs/ja/sandboxing.md#the-unsandboxed-retry-escape-hatch)を参照してください。

[`!` シェルモードプロンプト](https://code.claude.com/docs/ja/interactive-mode#shell-mode-with-prefix)で自分で入力するコマンドがサンドボックス化されるときを確認するには、[厳密なサンドボックスモード](https://code.claude.com/docs/ja/sandboxing.md#turn-off-the-retry-with-strict-sandbox-mode)を参照してください。

### `sandbox.filesystem`

サンドボックス化されたコマンドが読み取りおよび書き込みできるパスを制御します。デフォルトでは、作業ディレクトリ、ユーザーごとの一時ディレクトリ、`--add-dir`、`/add-dir`、または `permissions.additionalDirectories` で追加したディレクトリに書き込むことができ、認証情報ファイルを含むファイルシステムの残りの部分を読み取ることができます。4 つのパスリストで制限または拡大するか、`disabled` でファイルシステムレイヤーをオフにします。[ファイルシステム分離](https://code.claude.com/docs/ja/sandboxing.md#filesystem-isolation)のデフォルト境界を参照してください。

* **Scope**: [`Any file`](#scopes)
* **Type**: `allowWrite`、`denyWrite`、`denyRead`、`allowRead` 配列を含むオブジェクト、および `allowManagedReadPathsOnly` と `disabled` ブール値
* **Default**: 未設定。デフォルトの読み取りおよび書き込み境界が適用されます

これにより、サンドボックス化されたコマンドはビルドディレクトリと kubeconfig に書き込むことができ、AWS 認証情報ファイルを非表示にします：

```json settings.json theme={null}
{
  "sandbox": {
    "filesystem": {
      "allowWrite": ["/tmp/build", "~/.kube"],
      "denyRead": ["~/.aws/credentials"]
    }
  }
}
```

Claude Code はこれらのリストを OS サンドボックス境界で強制するため、`kubectl`、`terraform`、`npm` などのサンドボックス化されたコマンドが開始するすべてのサブプロセスに適用されます。Claude Code は[権限ルール](https://code.claude.com/docs/ja/sandboxing.md#permission-rules)を同じリストに追加します：`Edit` 許可および拒否ルールを `allowWrite` および `denyWrite` に、`Read` 拒否ルールを `denyRead` に、`WebFetch(domain:...)` 許可および拒否ルールを[`network`](#sandbox-network)ドメインリストに追加します。

ロックが適用されない限り、Claude Code はセッションが読み込む設定ファイル全体でこれらのリストをマージします。[`allowManagedReadPathsOnly`](#sandbox-filesystem-allowmanagedreadpathsonly)は `allowRead` を管理設定からのエントリに制限し、[`allowManagedDomainsOnly`](#sandbox-network-allowmanageddomainsonly)は許可されたドメインに対して同じことを行います。[リポジトリロック](https://code.claude.com/docs/ja/sandboxing.md#repository-settings-under-an-admin-required-sandbox)は、リポジトリの設定ファイルからのエントリを除外します。

[サンドボックスを設定する](https://code.claude.com/docs/ja/sandboxing.md#configure-sandboxing)は、`--setting-sources` で除外するソースをカバーしています。セッション中にリストを編集すると、Claude Code は[実行中のセッションに変更を適用](https://code.claude.com/docs/ja/settings.md#when-edits-take-effect)します。

#### サンドボックスパスプレフィックス

`allowWrite`、`denyWrite`、`denyRead`、`allowRead`、および [`credentials.files`](#sandbox-credentials-files) のパスはプレフィックスで解決されます：

| プレフィックス | 意味 | 例 |
| :- | :- | :- |
| `/` | ファイルシステムルートからの絶対パス | `/tmp/build` は `/tmp/build` のままです |
| `~/` | ホームディレクトリに相対 | `~/.kube` は `$HOME/.kube` になります |
| `./` またはプレフィックスなし | プロジェクト設定ではプロジェクトルートに相対、ユーザー設定では `~/.claude` に相対 | `.claude/settings.json` の `./output` は `<project-root>/output` に解決されます |

絶対パスの `//path` プレフィックスも機能します。プロジェクト相対解決を期待して単一スラッシュ `/path` を使用する場合は、`./path` に切り替えます。この構文は、`//path` を絶対パスに、`/path` をプロジェクト相対に使用する[Read および Edit 権限ルール](https://code.claude.com/docs/ja/permissions.md#read-and-edit)とは異なります。サンドボックスファイルシステムパスは標準規則を使用するため、`/tmp/build` は絶対パスです。

Claude Code はディレクトリパスから末尾のスラッシュを削除するため、`~/.aws` と `~/.aws/` は同じディレクトリと一致します。v2.1.224 より前では、Claude Code は末尾のスラッシュをサンドボックスに渡していたため、末尾のスラッシュ付きで記述された `denyRead` または `denyWrite` エントリの下のパスを、Claude が引き続き読み取りまたは書き込みできました。

##### サンドボックスパスでワイルドカードが機能する場所

ワイルドカード `*`、`?`、`**` は、macOS では 4 つの `sandbox.filesystem` パスリストすべてで機能しますが、Linux と WSL2 では機能する場所が限られます：

| `sandbox.filesystem` リスト | Linux と WSL2 で機能するもの | Linux と WSL2 で機能しない例 | 代わりに記述するもの |
| :- | :- | :- | :- |
| `denyRead`、`allowRead` | 末尾の `/**` は機能するため、`~/build/**` は `~/build` と同じディレクトリを対象とします。その他のワイルドカードは、エントリの[フルパス](#sandbox-path-prefixes)の最初のディレクトリ名より後でのみ機能します。 | `denyRead` 内の `/**/*.pem` は何も対象としないため、読み取りをブロックしません | `/srv/**/*.pem` のように、トップレベルディレクトリごとに 1 つのエントリ |
| `allowWrite`、`denyWrite` | 末尾の `/**` のみが機能するため、`~/build/**` は `~/build` と同じディレクトリを対象とします | `./src/*` は `src` 内にある `*` という名前のファイルまたはディレクトリのみを対象とし、それが存在しない場合は何も対象としません | `src` 配下のすべてを対象とする `./src`、またはパスごとに 1 つのエントリ |

`~/keys/*.pem` では、ワイルドカードは最初のディレクトリ名より後にあります。ホームディレクトリが `/home/alice` の場合、最初のディレクトリ名は `home` です：

```text theme={null}
~/keys/*.pem              the entry
/home/alice/keys/*.pem    its full path
 ^^^^                     the first directory name, home
```

Linux と WSL2 では、セッション内の `/sandbox` の **Config** タブに、末尾の `/**` 以外のワイルドカードを含む `Edit` 権限ルールについての警告が表示されます。それらのワイルドカードは、サンドボックス化されたコマンドには機能しません。ルールが対象とすべき各パス、またはそれらを含むディレクトリを、許可ルールの場合は `allowWrite` に、拒否ルールの場合は `denyWrite` に追加してください。

##### 角括弧、波括弧、丸括弧を含むディレクトリ名

名前に角括弧を含むディレクトリを許可またはブロックするには、`./app/[slug]` のように名前をそのまま記述します。このエントリでは、`[slug]` は角括弧を含めてディレクトリの実際の名前です：

```text theme={null}
app/
└── [slug]/
    └── page.tsx
```

このエントリはディレクトリ配下のすべてを対象とするため、末尾の `/**` は付けないでください。macOS、Linux、WSL2 では、サンドボックス化されたコマンドの起動時に `app/[slug]` ディレクトリが存在している必要があります。

* **`[slug]` のような角括弧**: macOS ではすべてのリストで、Linux と WSL2 では `denyRead` と `allowRead` で、`./app/[slug]` の角括弧はパターンとしても扱われます。その場合、このエントリは `app/s` や `app/g` など、`app` 配下にある、`slug` のうち 1 文字を名前とするパスにも一致します。このエントリが `allowRead` にある場合、または macOS で `allowWrite` にある場合、サンドボックス化されたコマンドはそれらのパスにもアクセスできます。アクセスさせるべきでないものは名前を変更してください。
* **`[user-id]` や `[post-id]` のように、ハイフンの左側の文字が右側の文字より後にソートされる角括弧**: `./app/[user-id]` は、すべてのプラットフォームのすべてのリストで、その名前と完全に一致するディレクトリのみを対象とします。v2.1.304 より前は、`denyRead` または `allowRead` にそのようなエントリがあると、Linux と WSL2 でサンドボックス化されたコマンドの起動に失敗していました。
* **波括弧と丸括弧**: これらは通常の文字であるため、`~/data/{keys,tokens}` は 2 つの選択肢ではなく、`{keys,tokens}` という名前の 1 つのディレクトリを対象とします。`~/data/keys` と `~/data/tokens` を対象とするには、それぞれを個別のエントリとして追加してください。

### `sandbox.filesystem.allowWrite`

作業ディレクトリ、ユーザーごとの一時ディレクトリ、`--add-dir`、`/add-dir`、または `permissions.additionalDirectories` で追加したディレクトリを超えて、サンドボックス化されたコマンドが書き込むことができるパスを追加します。`kubectl` やビルドツールなどのサブプロセスがプロジェクト外に書き込む必要がある場合に使用します。

* **Scope**: [`Any file`](#scopes)（[プロジェクト設定とローカル設定には制限あり](https://code.claude.com/docs/ja/sandboxing.md#repository-settings-under-an-admin-required-sandbox)）
* **Type**: [サンドボックスパスプレフィックス](#sandbox-path-prefixes)を使用するパス文字列の配列
* **Default**: 未設定。サンドボックス化されたコマンドは、作業ディレクトリ、ユーザーごとの一時ディレクトリ、`--add-dir` または `/add-dir` で追加したディレクトリ、および [`permissions.additionalDirectories`](#permissions-additionaldirectories) のディレクトリに書き込むことができます

これにより、ビルドは `/tmp/build` の下に書き込むことができ、`kubectl` は kubeconfig を更新できます：

```json settings.json theme={null}
{
  "sandbox": {
    "filesystem": {
      "allowWrite": ["/tmp/build", "~/.kube"]
    }
  }
}
```

Claude Code は `allowWrite` エントリと `Edit(...)` 許可権限ルールからのパスをセッションが読み込むすべての設定スコープ全体でマージし、[`permissions.blockReadsOutsideWorkingDirectories`](#sandboxed-commands-under-the-block)がオンの間、リポジトリ設定からのものを除外します。[リポジトリロック](https://code.claude.com/docs/ja/sandboxing.md#repository-settings-under-an-admin-required-sandbox)によってリポジトリのエントリが除外されることもあります。`allowWrite` エントリは[保護されたパス](https://code.claude.com/docs/ja/sandboxing.md#protected-paths)を解除できません。

### `sandbox.filesystem.denyWrite`

サンドボックス化されたコマンドが特定のパスへの書き込みをブロックします。これには、別の方法で書き込み可能なディレクトリ内のパスが含まれます。

* **Scope**: [`Any file`](#scopes)
* **Type**: [サンドボックスパスプレフィックス](#sandbox-path-prefixes)を使用するパス文字列の配列
* **Default**: 未設定

これにより、サンドボックス化されたコマンドがシステム設定を変更したり、バイナリをインストールしたりするのを防ぎます：

```json settings.json theme={null}
{
  "sandbox": {
    "filesystem": {
      "denyWrite": ["/etc", "/usr/local/bin"]
    }
  }
}
```

Claude Code はセッションが読み込むすべての設定スコープ全体でエントリをマージし、`Edit(...)` 拒否権限ルールからのパスを追加します。

### `sandbox.filesystem.denyRead`

サンドボックス化されたコマンドが特定のパス（デフォルトの読み取りポリシーが公開する認証情報ファイルなど）の読み取りをブロックします。認証情報ファイルを保護し、サンドボックスプロキシを通じて使用可能に保つには、代わりに [`sandbox.credentials`](#sandbox-credentials) を参照してください。

* **Scope**: [`Any file`](#scopes)
* **Type**: [サンドボックスパスプレフィックス](#sandbox-path-prefixes)を使用するパス文字列の配列
* **Default**: 未設定。サンドボックス化されたコマンドは[デフォルト読み取りアクセス](https://code.claude.com/docs/ja/sandboxing.md#filesystem-isolation)を保持します。これには `~/.aws/credentials` などの認証情報ファイルが含まれます

```json settings.json theme={null}
{
  "sandbox": {
    "filesystem": {
      "denyRead": ["~/.aws/credentials"]
    }
  }
}
```

Claude Code はセッションが読み込むすべての設定スコープ全体でエントリをマージし、`Read(...)` 拒否権限ルールからのパスを追加します。[`filesystem.disabled`](#sandbox-filesystem-disabled)が `true` の場合、Claude Code はこれらのエントリを強制しません。

### `sandbox.filesystem.allowRead`

[`denyRead`](#sandbox-filesystem-denyread)がブロックする領域内の特定のパスの読み取りを再度開き、ワークスペースのみの読み取りアクセスを構築します。正確またはワイルドカード `denyRead` エントリは、より広い `allowRead` 内でブロックされたままです。[重複テーブル](https://code.claude.com/docs/ja/sandboxing.md#configure-sandboxing)が示すとおりです。ワイルドカード `denyRead` エントリ（`~/**/.env` など）がディレクトリと一致する場合、Claude Code はその内容の読み取りもブロックします。v2.1.236 より前の macOS では、Claude Code はワイルドカード `denyRead` エントリが一致したパスを、より広い `allowRead` エントリがカバーしている場所で再度開き、一致したディレクトリの内容を読み取り可能なままにしました。

* **Scope**: [`Any file`](#scopes)（[プロジェクト設定とローカル設定には制限あり](https://code.claude.com/docs/ja/sandboxing.md#repository-settings-under-an-admin-required-sandbox)）
* **Type**: [サンドボックスパスプレフィックス](#sandbox-path-prefixes)を使用するパス文字列の配列
* **Default**: 未設定

これにより、プロジェクト自体を除くホームディレクトリの読み取りがブロックされます：

```json settings.json theme={null}
{
  "sandbox": {
    "filesystem": {
      "denyRead": ["~/"],
      "allowRead": ["."]
    }
  }
}
```

Claude Code は `.` エントリをプロジェクト設定ではプロジェクトルートに、ユーザー設定では `~/.claude` に解決します。[`allowManagedReadPathsOnly`](#sandbox-filesystem-allowmanagedreadpathsonly) が設定されていない限り、Claude Code はセッションが読み込む設定ファイル全体でエントリをマージし、[`permissions.blockReadsOutsideWorkingDirectories`](#sandboxed-commands-under-the-block) がオンの間はリポジトリ設定からのエントリを除外します。[リポジトリロック](https://code.claude.com/docs/ja/sandboxing.md#repository-settings-under-an-admin-required-sandbox)によってリポジトリのエントリが除外されることもあります。

### `sandbox.filesystem.allowManagedReadPathsOnly`

管理設定から来る [`allowRead`](#sandbox-filesystem-allowread) エントリのみを尊重するため、開発者は組織がブロックしたパスへの読み取りアクセスを再度開くことができません。Claude Code は引き続きセッションが読み込むすべての設定スコープから `denyRead` エントリをマージします。

* **Scope**: [`Managed`](#scopes)
* **Type**: ブール値
  * `true`: Claude Code は管理設定からの `allowRead` エントリのみを尊重します
  * `false`: 他の設定ファイルからの `allowRead` エントリもマージされます
* **Default**: `false`

これにより、ホームディレクトリの読み取りがブロックされ、`~/work` が再度開かれ、開発者が他のものを再度開くのが停止されます：

```json managed-settings.json theme={null}
{
  "sandbox": {
    "filesystem": {
      "denyRead": ["~/"],
      "allowRead": ["~/work"],
      "allowManagedReadPathsOnly": true
    }
  }
}
```

[ポリシーの拡大を開発者に防止させる](https://code.claude.com/docs/ja/sandboxing.md#keep-developers-from-widening-the-policy)を参照してください。

### `sandbox.filesystem.disabled`

ネットワークの隔離を維持したまま、ファイルシステムの隔離をスキップします。サンドボックス化されたコマンドはホストのファイルシステムへの無制限の読み取りおよび書き込みアクセスを得ますが、ネットワークの送信先は [`network.allowedDomains`](#sandbox-network-alloweddomains) に限定されたままです。コマンドが何を書き込むかではなく、どこに接続するかを制御するためにサンドボックスを使用する場合に使用します。

* **Scope**: [`User or managed`](#scopes)。管理設定が `sandbox.filesystem` を何らかの形で設定する場合、または `"mode": "deny"` を持つ `sandbox.credentials.files` エントリをリストする場合、管理設定のみがそれを設定できます。
* **Type**: ブール値
  * `true`: Claude Code はファイルシステム分離をスキップし、ネットワーク分離を保持します
  * `false`: ファイルシステム分離は有効なままです
* **Default**: `false`。ファイルシステム分離は有効なままです

これにより、ファイルシステムが開かれ、ネットワーク出力が GitHub と npm に限定されます：

```json settings.json theme={null}
{
  "sandbox": {
    "enabled": true,
    "filesystem": {
      "disabled": true
    },
    "network": {
      "allowedDomains": ["github.com", "*.npmjs.org"]
    }
  }
}
```

このレイヤーがオフの場合、Claude Code は `denyRead` や `credentials.files` の `deny` エントリを適用しませんが、`credentials.envVars` エントリと適用済みの `mask` エントリは引き続き機能します。[`autoAllowBashIfSandboxed`](#sandbox-autoallowbashifsandboxed) のデフォルトは引き続き `true` であるため、プロンプトを表示し続けるには `false` に設定してください。これを設定できるソースの一覧と、隔離がオフのときに何が変わるかについては、[ファイルシステムの隔離を無効にする](https://code.claude.com/docs/ja/sandboxing.md#disable-filesystem-isolation)を参照してください。

### `sandbox.ignoreViolations`

コマンドがプローブして拒否されることが予想されるパスのサンドボックス違反レポートを沈黙させます（例えば、スタートアップ時に `/etc/hosts` をチェックするツール）。これらの拒否は違反として表示されず、Claude が見るものにも表示されません。サンドボックスはアクセスをブロックしたままです。レポートのみが抑制されます。キーはコマンドに対して一致するサブストリング（`*` はすべてのコマンドに一致）で、値はそのコマンドで無視する違反のサブストリング（ファイルシステムパスなど）です。

* **Scope**: [`Any file`](#scopes)（[プロジェクト設定とローカル設定には制限あり](https://code.claude.com/docs/ja/sandboxing.md#repository-settings-under-an-admin-required-sandbox)）
* **Type**: コマンドサブストリングを違反サブストリングの配列にマップするオブジェクト（通常はパス）
* **Default**: 未設定。すべての違反が報告されます

```json settings.json theme={null}
{
  "sandbox": {
    "ignoreViolations": {
      "*": ["/etc/hosts"]
    }
  }
}
```

### `sandbox.enableWeakerNestedSandbox`

Linux サンドボックスを非特権 Docker コンテナ内で実行します。bubblewrap は新しい `/proc` をマウントできません。代わりに、内部サンドボックスはコンテナの既存の `/proc` をバインドマウントします。これにより、新しいマウントが非表示にするプロセス情報が公開されます。これはセキュリティを低下させます。外部コンテナが既に必要な分離を提供する場合にのみ使用します。

* **Scope**: [`Any file`](#scopes)（[プロジェクト設定とローカル設定には制限あり](https://code.claude.com/docs/ja/sandboxing.md#repository-settings-under-an-admin-required-sandbox)）
* **Type**: ブール値
  * `true`: 内部サンドボックスは新しい `/proc` をマウントする代わりに、コンテナの既存の `/proc` をバインドマウントします
  * `false`: サンドボックスは新しい `/proc` をマウントします。これは非特権 Docker コンテナでは機能しません
* **Default**: `false`

```json settings.json theme={null}
{
  "sandbox": {
    "enabled": true,
    "enableWeakerNestedSandbox": true
  }
}
```

Linux と WSL2 のみ。[Bubblewrap がコンテナ内で起動に失敗する](https://code.claude.com/docs/ja/sandboxing.md#bubblewrap-fails-to-start-inside-a-container)を参照してください。

### `sandbox.enableWeakerNetworkIsolation`

macOS でサンドボックス化されたコマンドがシステム TLS トラストサービス `com.apple.trustd.agent` に到達できるようにします。`gh`、`gcloud`、`terraform` などの Go ベースのツールは、[`network.httpProxyPort`](#sandbox-network-httpproxyport)を MITM プロキシとカスタム CA で使用する場合、TLS 証明書を検証するために必要です。これはトラストサービスを通じた潜在的なデータ流出パスを開くことでセキュリティを低下させます。

* **Scope**: [`Any file`](#scopes)（[プロジェクト設定とローカル設定には制限あり](https://code.claude.com/docs/ja/sandboxing.md#repository-settings-under-an-admin-required-sandbox)）
* **Type**: ブール値
  * `true`: macOS でサンドボックス化されたコマンドは `com.apple.trustd.agent` に到達できます
  * `false`: macOS でサンドボックス化されたコマンドはシステム TLS トラストサービスに到達できません
* **Default**: `false`

```json settings.json theme={null}
{
  "sandbox": {
    "enabled": true,
    "enableWeakerNetworkIsolation": true
  }
}
```

MITM プロキシを使用しない場合は、代わりに失敗するツールを [`excludedCommands`](#sandbox-excludedcommands) にリストします。[Go ベースの CLI が macOS で TLS 検証に失敗する](https://code.claude.com/docs/ja/sandboxing.md#go-based-clis-fail-tls-verification-on-macos)を参照してください。

### `sandbox.allowAppleEvents`

macOS でサンドボックス化されたコマンドが Apple Events を送信できるようにします。`open`、`osascript`、およびブラウザで URL を開くツールはこれが必要です。これがないと、エラー `-600` で失敗します。これはコード実行分離を削除します。サンドボックス化されたコマンドはユーザープロンプトなしで他のアプリケーションを非サンドボックス化で起動でき、Terminal などの実行中のアプリケーションに AppleScript コマンドを送信できます。これはアプリごとの macOS オートメーション同意プロンプト（TCC）の対象です。

* **Scope**: [`User or managed`](#scopes)
* **Type**: ブール値
  * `true`: macOS でサンドボックス化されたコマンドは Apple Events を送信できます
  * `false`: macOS でサンドボックス化されたコマンドは Apple Events を送信できないため、`open` と `osascript` はエラー `-600` で失敗します
* **Default**: `false`

```json settings.json theme={null}
{
  "sandbox": {
    "enabled": true,
    "allowAppleEvents": true
  }
}
```

分離を保持しながら 1 つのそのようなツールを実行するには、代わりに [`excludedCommands`](#sandbox-excludedcommands) に追加します。[macOS の Apple Events](https://code.claude.com/docs/ja/sandboxing.md#security-limitations)を参照してください。

### `sandbox.allowNestedUserNamespaces`

Linux と WSL2 上のサンドボックス化されたコマンドがユーザー名前空間を作成できるようにします。Chromium や Electron 独自のサンドボックス、入れ子の bubblewrap、`unshare` はこれを必要とします。このキーを `true` に設定すると、セキュリティ境界がオフになります。サンドボックス化されたコマンドのコードが、サンドボックスの外で実行される可能性があります。rootless の Podman や Buildah については、サンドボックスは他の方法でもそれらを停止させるため、代わりに [`excludedCommands`](#sandbox-excludedcommands) を使用してください。Claude Code v2.1.305 以降が必要です。

* **スコープ**: [`User or managed`](#scopes)。`true` は、`~/.claude/settings.json`、`--settings` で渡された JSON、または[管理設定](https://code.claude.com/docs/ja/managed-settings.md)からのものが有効になります。Claude Code は、プロジェクトの `.claude/settings.json` または `.claude/settings.local.json` にある `true` を無視します。[`CLAUDE_CODE_SUBPROCESS_ENV_SCRUB`](https://code.claude.com/docs/ja/env-vars#variables) が `1` に設定されたセッションでは、Claude Code はすべてのソースからの `true` を無視します。`false` は、[設定の優先順位](https://code.claude.com/docs/ja/settings.md#settings-precedence)に従い、任意のファイルからのものが有効になります。
* **型**: ブール値
  * `true`: サンドボックス化されたコマンドはユーザー名前空間を作成できます
  * `false`: このキーによって追加で許可されるものはなく、サンドボックスのデフォルトが適用されます
* **デフォルト**: `false`

```json settings.json theme={null}
{
  "sandbox": {
    "enabled": true,
    "allowNestedUserNamespaces": true
  }
}
```

このキーがオンの場合、悪意のあるコマンドを止めるために、[保護されたパス](https://code.claude.com/docs/ja/sandboxing.md#protected-paths)や [`credentials.files`](#sandbox-credentials-files) エントリを含むサンドボックスのいかなる制限にも頼らないでください。[自動許可モード](https://code.claude.com/docs/ja/sandboxing.md#auto-allow-mode)では、そのようなコマンドが権限プロンプトなしで実行される可能性があります。組織にセキュリティチームがある場合は、このキーをオンにする前に相談してください。

お使いのツールの解決方法については、[Linux のサンドボックス内で Chromium または rootless Podman が失敗する](https://code.claude.com/docs/ja/sandboxing.md#chromium-or-rootless-podman-fails-inside-the-sandbox-on-linux)を参照してください。

### `sandbox.ripgrep`

Claude Code が使用するものの代わりに、独自の ripgrep バイナリをサンドボックスに指定します。たとえば、プラットフォームが異なる方法でビルドされた `rg` を必要とする場合です。

* **Scope**: [`User or managed`](#scopes)
* **Type**: ripgrep バイナリへのパスである `command` を含むオブジェクト、および前置する引数の配列である optional `args`
* **Default**: 未設定。サンドボックスは Claude Code と同じ ripgrep バイナリを使用します。[`USE_BUILTIN_RIPGREP`](https://code.claude.com/docs/ja/env-vars)を `0` に設定しない限り、これはバンドルされたバイナリです

```json settings.json theme={null}
{
  "sandbox": {
    "ripgrep": {
      "command": "/usr/local/bin/rg"
    }
  }
}
```

### `sandbox.bwrapPath`

`PATH` の外にインストールされた bubblewrap バイナリ（エアギャップホスト上のベンダー版など）をサンドボックスに指定します。Claude Code はスタートアップ依存関係チェックと、サンドボックス化された各コマンドをラップするときの両方でパスを使用します。

* **Scope**: [`Managed`](#scopes)。Claude Code はユーザー、プロジェクト、またはローカルファイルがサンドボックスを別のバイナリに指定できないように、管理設定からのみ読み取ります。
* **Type**: 文字列。絶対パス。Claude Code は相対パスを削除し、`PATH` ルックアップにフォールバックします
* **Default**: 未設定。Claude Code は `PATH` で `bwrap` を見つけます

```json managed-settings.json theme={null}
{
  "sandbox": {
    "enabled": true,
    "bwrapPath": "/opt/admin/bwrap"
  }
}
```

Linux と WSL2 のみ。

### `sandbox.socatPath`

`PATH` の外にインストールされた `socat` バイナリをサンドボックスネットワークプロキシに指定します。

* **Scope**: [`Managed`](#scopes)
* **Type**: 文字列。絶対パス。Claude Code は相対パスを削除し、`PATH` ルックアップにフォールバックします
* **Default**: 未設定。Claude Code は `PATH` で `socat` を見つけます

```json managed-settings.json theme={null}
{
  "sandbox": {
    "enabled": true,
    "socatPath": "/opt/admin/socat"
  }
}
```

Linux と WSL2 のみ。

### `sandbox.credentials`

[サンドボックス化されたコマンドから保護する](https://code.claude.com/docs/ja/sandboxing.md#protect-credentials)認証情報ファイルと環境変数を宣言します。各エントリはファイル `path` または変数 `name` と `mode` に名前を付けます：`deny` はサンドボックス内の認証情報を非表示にし、`mask` はサンドボックス化されたコマンドにプレースホルダーを表示します。[サンドボックスプロキシ](https://code.claude.com/docs/ja/sandboxing.md#mask-credentials)は送信リクエストで実際の値を置き換えます。Claude Code はリストしたエントリのみを保護します。組み込みの認証情報拒否リストはありません。

* **Scope**: [`Any file`](#scopes)。Claude Code は `mask` エントリ、`allowPlaintextInject`、`awsPairs`、`sigv4` をユーザー設定、管理設定、`--settings` フラグからのみ尊重します。
* **Type**: `files`、`envVars`、`allowPlaintextInject`、`awsPairs`、`sigv4` を含むオブジェクト
* **Default**: 未設定。認証情報は保護されません

これにより、AWS 認証情報ファイルが非表示になり、`GITHUB_TOKEN` がサンドボックス化されたコマンドから削除されます：

```json settings.json theme={null}
{
  "sandbox": {
    "credentials": {
      "files": [{ "path": "~/.aws/credentials", "mode": "deny" }],
      "envVars": [{ "name": "GITHUB_TOKEN", "mode": "deny" }]
    }
  }
}
```

`deny` ファイル保護はファイルシステムレイヤーの一部であるため、[ファイルシステム分離を無効にする](https://code.claude.com/docs/ja/sandboxing.md#disable-filesystem-isolation)場合は適用されません。環境変数保護は引き続き適用されます。

#### 管理設定の無効な認証情報エントリ

管理対象の `sandbox.credentials` エントリが検証に失敗した場合、Claude Code は可能な限り認証情報を保護し続けます：

* `files` または `envVars` のエントリで、有効な `path` または `name` と `mask` または `deny` の `mode` を持つもの（キャプチャグループがない `extract` パターンなど）は、警告とともに `mode: "deny"` に低下されるため、認証情報はマスクされず、エントリを修正するまでブロックされたままです。低下した `files` エントリは、明示的な `deny` エントリのように [`filesystem.disabled`](https://code.claude.com/docs/ja/sandboxing#disable-filesystem-isolation) をピンします。警告は、管理設定がファイルシステム分離をオフにする場合、その読み取りブロックが強制されないことを記します。
* 不明な `mode` または無効な `path` または `name` を持つエントリは削除されます。
* 各ケースは警告します。エントリが低下または削除されるかどうかに関わらず、残りの有効なエントリは引き続き強制されます。

v2.1.191 以降に適用されます。v2.1.221 より前では、すべての無効なエントリが削除されました。フィールドごとの処理を持つ他の管理キーについては、[管理設定の無効なエントリ](https://code.claude.com/docs/ja/managed-settings.md#invalid-entries-in-managed-settings)を参照してください。

### `sandbox.credentials.files`

認証情報ファイルまたはディレクトリをサンドボックス化されたコマンドから保護します。`"mode": "deny"` の場合、Claude Code はサンドボックス内のパスの読み取りをブロックします。これは [`sandbox.filesystem.denyRead`](#sandbox-filesystem-denyread) と同じ読み取りブロックです。`"mode": "mask"` の場合、Linux と WSL2 でサンドボックス化されたコマンドはファイルのセンチネルコピーを読み取り、サンドボックスプロキシはそのエントリの `injectHosts` への送信リクエストで実際の値を置き換えます。macOS ではファイルはサンドボックス内で読み取り不可です。`"mode": "mask"` には Claude Code v2.1.221 以降が必要です。

* **Scope**: [`Any file`](#scopes)。Claude Code はプロジェクト `.claude/settings.json` とローカル `.claude/settings.local.json` から `mask` エントリを削除します。
* **Type**: オブジェクトの配列。各オブジェクトは `path` と `"deny"` または `"mask"` の `mode`、および optional [ファイルのマスクフィールド](#mask-fields-for-files)を含みます
* **Default**: 未設定。認証情報ファイルは保護されません

これにより、AWS 認証情報ファイルが非表示になり、`gh` ホストファイルがマスクされ、`api.github.com` へのリクエストでのみ実際の値が置き換えられます：

```json settings.json theme={null}
{
  "sandbox": {
    "credentials": {
      "files": [
        { "path": "~/.aws/credentials", "mode": "deny" },
        { "path": "~/.config/gh/hosts.yml", "mode": "mask", "injectHosts": ["api.github.com"] }
      ]
    }
  }
}
```

パスは `sandbox.filesystem.*` 設定と同じ[プレフィックス](#sandbox-path-prefixes)を使用し、Claude Code はセッションが読み込むすべての設定スコープから配列をマージします。[認証情報を保護する](https://code.claude.com/docs/ja/sandboxing.md#protect-credentials)は、`--setting-sources` で除外するソースから何が引き続き適用されるかをカバーしています。`mask` エントリには Claude Code v2.1.221 以降が必要です。

`mask` 置換はサンドボックスプロキシを通じてのみ実行されるため、[`sandbox.network.tlsTerminate`](#sandbox-network-tlsterminate)、または プレーン HTTP テストネットワークの場合は [`allowPlaintextInject`](#sandbox-credentials-allowplaintextinject) を設定します。`mask` は単一ファイルに適用されるため、各認証情報ファイルを個別にリストします。Claude Code は `deny` エントリの `mask` フィールドを受け入れますが、無視します。[認証情報をマスクする](https://code.claude.com/docs/ja/sandboxing.md#mask-credentials)はどの設定ソースが尊重されるかを、[認証情報ファイルをマスクする](https://code.claude.com/docs/ja/sandboxing.md#mask-credential-files)はエントリが `deny` にフォールバックするときをカバーしています。

#### ファイルのマスクフィールド

`mask` エントリはこれらの optional フィールドを受け入れます。`extract` または `decode` がない場合、Claude Code はファイル全体の内容を 1 つのセンチネルで置き換えます。ファイルシステム分離がオンの macOS では、Claude Code は `extract` または `decode` が実行される前に `mask` エントリを `deny` として適用します。[認証情報ファイルをマスクする](https://code.claude.com/docs/ja/sandboxing.md#mask-credential-files)を参照してください。

| フィールド | 型 | 何をするか |
| :- | :- | :- |
| `extract` | 文字列。少なくとも 1 つのキャプチャグループを持つ正規表現 | 各一致のグループ 1 でキャプチャされたテキストのみをマスクするため、ファイルの残りは解析可能なままです。`decode` も設定されている場合、Claude Code は各キャプチャを置き換える前に、可能な JWT として確認します。v2.1.221 以降が必要です |
| `onExtractNoMatch` | `"warn"`、`"deny"`、または `"error"`。デフォルト `"warn"` | `extract` または `decode` がマスクするものを見つけられない場合に何が起こるか。`warn` はファイルをサンドボックス内で読み取り可能なままにし、`deny` は読み取り不可にし、`error` は設定を修正するまでサンドボックスセットアップを停止します。Claude Code は、読み取りブロックが強制されない場合、`deny` を `error` として扱います。[ファイルシステム分離を無効にする](https://code.claude.com/docs/ja/sandboxing.md#disable-filesystem-isolation)か、[`sandbox.filesystem.allowRead`](#sandbox-filesystem-allowread)エントリがパスを再度開く場合です。v2.1.221 以降が必要です。`decode` ケースには v2.1.224 以降が必要です |
| `decode` | 文字列 `"jwt"` | ファイル内の JSON Web Token（JWT）を見つけます。組み込みパターンまたは設定されている場合は `extract` を使用して、各候補を検証し、構造的に有効な偽のトークンで置き換えます。サンドボックス内のコードがトークンをデコードし続けるようにします。候補が検証されない場合、`onExtractNoMatch` が結果を管理します。v2.1.224 以降が必要です |
| `maskClaims` | 文字列の配列。少なくとも 1 つのクレーム名。`decode` が必要 | 各検証済み JWT 内の名前付きトップレベルペイロードクレームのみをマスクし、変更されたペイロードの周りにトークンを再構築します。他のクレームは読み取り可能なままです。名前付きクレームが一致しない場合、`onExtractNoMatch` が結果を管理します。v2.1.224 以降が必要です |
| `maskDuplicates` | ブール値。デフォルト `false` | 各マスクされた値の逐語的なコピーをファイル内の他の場所でも置き換えます。例えば、コメントに貼り付けられたシークレット。Claude Code は生のサブストリングと一致するため、長く、高エントロピーのシークレット用に予約します。`extract` または `decode` が設定されている場合にのみ参照されます。v2.1.221 以降が必要です |
| `injectHosts` | 文字列の配列。各ホストは [`sandbox.network.allowedDomains`](#sandbox-network-alloweddomains) も認めます | サンドボックスプロキシが実際の値を置き換えるホストを絞ります。未設定の場合、プロキシは `sandbox.network.allowedDomains` のすべてのホストへのリクエストで置き換えます。v2.1.221 以降が必要です |

これにより、`gh` ホストファイル内の `oauth_token` 値のみがマスクされ、ファイル内のそれぞれの他のコピーが置き換えられ、パターンが何も一致しない場合はファイルが読み取り不可になり、実際のトークンは `api.github.com` へのリクエストでのみ置き換えられます：

```json settings.json theme={null}
{
  "sandbox": {
    "credentials": {
      "files": [
        {
          "path": "~/.config/gh/hosts.yml",
          "mode": "mask",
          "extract": "oauth_token:\\s*(\\S+)",
          "maskDuplicates": true,
          "onExtractNoMatch": "deny",
          "injectHosts": ["api.github.com"]
        }
      ]
    }
  }
}
```

### `sandbox.credentials.envVars`

環境変数をサンドボックス化されたコマンドから保護します。`"mode": "deny"` の場合、Claude Code はサンドボックス化されたコマンドの環境から変数を削除します。`"mode": "mask"` の場合、サンドボックス化されたコマンドはセッションごとのセンチネル値を見て、サンドボックスプロキシはそのエントリの `injectHosts` への送信リクエストで実際の値を置き換えます。`gh` や `npm` などのツールは実際の認証情報を保持することなく認証を続けます。

* **Scope**: [`Any file`](#scopes)。Claude Code はプロジェクト `.claude/settings.json` とローカル `.claude/settings.local.json` から `mask` エントリを削除します。
* **Type**: オブジェクトの配列。各オブジェクトは `name` と `"deny"` または `"mask"` の `mode`、および optional [環境変数のマスクフィールド](#mask-fields-for-environment-variables)を含みます
* **Default**: 未設定。環境変数は保護されません

これにより、`NPM_TOKEN` がサンドボックス化されたコマンドから削除され、`GITHUB_TOKEN` がマスクされ、実際の値は `api.github.com` へのリクエストでのみ置き換えられます：

```json settings.json theme={null}
{
  "sandbox": {
    "credentials": {
      "envVars": [
        { "name": "NPM_TOKEN", "mode": "deny" },
        { "name": "GITHUB_TOKEN", "mode": "mask", "injectHosts": ["api.github.com"] }
      ]
    }
  }
}
```

`name` は文字または下線で始まり、文字、数字、下線のみを含む必要があります。Claude Code はセッションが読み込むすべての設定スコープから配列をマージし、同じ変数が両方のモードで表示される場合は `deny` を適用します。[認証情報を保護する](https://code.claude.com/docs/ja/sandboxing.md#protect-credentials)は、`--setting-sources` で除外するソースから何が引き続き適用されるかをカバーしています。

`mask` 置換はサンドボックスプロキシを通じてのみ実行されるため、[`sandbox.network.tlsTerminate`](#sandbox-network-tlsterminate)、または プレーン HTTP テストネットワークの場合は [`allowPlaintextInject`](#sandbox-credentials-allowplaintextinject) を設定します。[認証情報をマスクする](https://code.claude.com/docs/ja/sandboxing.md#mask-credentials)を参照してください。Claude Code は `deny` エントリの `mask` フィールドを受け入れますが、無視します。

#### 環境変数のマスクフィールド

`mask` エントリはこれらの optional フィールドを受け入れます。`extract` または `decode` がない場合、Claude Code は全体の値を 1 つのセンチネルで置き換えます。`extract` と `decode` は同じエントリで組み合わせることはできません。

| フィールド | 型 | 何をするか |
| :- | :- | :- |
| `extract` | 文字列。少なくとも 1 つのキャプチャグループを持つ正規表現 | 各一致のグループ 1 でキャプチャされたテキストのみをマスクします。例えば、`DATABASE_URL` 接続文字列内のパスワード。値の残りは解析可能なままです。v2.1.224 以降が必要です |
| `onExtractNoMatch` | `"warn"`、`"deny"`、または `"error"`。デフォルト `"warn"`。`decode` を持つエントリでは、`"warn"` のみが受け入れられます | `extract` が何も一致しない場合に何が起こるか。`warn` は変数をマスクなしで渡し、`deny` はサンドボックス内でそれをアンセットし、`error` は設定を修正するまでサンドボックスセットアップを停止します。v2.1.224 以降が必要です |
| `decode` | 文字列 `"jwt"` | 全体の値が JWT であることを検証し、構造的に有効な偽のトークンで置き換えます。サンドボックス内のコードがトークンをデコードし続けるようにします。プロキシは出力時に全体の実際のトークンを置き換えます。検証されない値は警告とともにマスクなしで渡されます。v2.1.224 以降が必要です |
| `maskClaims` | 文字列の配列。少なくとも 1 つのクレーム名。`decode` が必要 | デコードされた JWT 内の名前付きトップレベルペイロードクレームのみをマスクし、変更されたペイロードの周りにトークンを再構築します。他のクレームは読み取り可能なままです。名前付きクレームが一致しない場合、変数は警告とともにマスクなしで渡されます。v2.1.224 以降が必要です |
| `injectHosts` | 文字列の配列。各ホストは [`sandbox.network.allowedDomains`](#sandbox-network-alloweddomains) も認めます | サンドボックスプロキシが実際の値を置き換えるホストを絞ります。未設定の場合、プロキシは `sandbox.network.allowedDomains` のすべてのホストへのリクエストで置き換えます。IPv6 宛先を裸の圧縮アドレスとして書き込みます。例えば、`"::1"`。括弧形式ではなく。[`injectHosts` の IPv6 宛先](https://code.claude.com/docs/ja/sandboxing#ipv6-destinations-in-injecthosts)を参照してください |

これにより、`DATABASE_URL` 内のパスワードのみがマスクされ、パターンが何も一致しない場合は変数がアンセットされ、`SERVICE_JWT` の JWT がマスクされます。`api_key` を除くすべてのクレームは読み取り可能なままです：

```json settings.json theme={null}
{
  "sandbox": {
    "credentials": {
      "envVars": [
        {
          "name": "DATABASE_URL",
          "mode": "mask",
          "extract": "://[^:]+:([^@]+)@",
          "onExtractNoMatch": "deny"
        },
        {
          "name": "SERVICE_JWT",
          "mode": "mask",
          "decode": "jwt",
          "maskClaims": ["api_key"]
        }
      ]
    }
  }
}
```

### `sandbox.credentials.allowPlaintextInject`

TLS 終了 HTTPS だけでなく、プレーン HTTP リクエストでも `mask` 置換を許可します。プレーン HTTP では、アップストリーム ID は検証されず、認証情報はクリアテキストで移動するため、信頼できるテストネットワーク外ではこれをオフのままにします。

* **Scope**: [`User or managed`](#scopes)
* **Type**: ブール値
  * `true`: Claude Code はプレーン HTTP リクエストと TLS 終了 HTTPS の両方で `mask` 置換を許可します
  * `false`: Claude Code は TLS 終了 HTTPS でのみ `mask` 置換を許可します
* **Default**: `false`

```json settings.json theme={null}
{
  "sandbox": {
    "credentials": {
      "allowPlaintextInject": true
    }
  }
}
```

### `sandbox.credentials.awsPairs`

マスクされた環境変数をグループ化して、認証情報が非標準の名前の変数に存在する場合、[SigV4 再署名](https://code.claude.com/docs/ja/sandboxing.md#re-sign-aws-requests)用に 1 つの AWS 認証情報を形成します。Claude Code は、従来の `AWS_ACCESS_KEY_ID`、`AWS_SECRET_ACCESS_KEY`、`AWS_SESSION_TOKEN` トリオを全体の値をマスクする場合、自動的にリンクするため、他の名前の場合にのみこのキーが必要です。Claude Code v2.1.224 以降が必要です。

* **Scope**: [`User or managed`](#scopes)
* **Type**: オブジェクトの配列。各オブジェクトは `accessKeyIdVar`、`secretAccessKeyVar`、および optional `sessionTokenVar` を含み、`sandbox.credentials.envVars` エントリに名前を付けます
* **Default**: 未設定。従来のトリオのみがペアになります

これにより、3 つのカスタム名の変数が 1 つの AWS 認証情報にリンクされ、再署名されます：

```json settings.json theme={null}
{
  "sandbox": {
    "credentials": {
      "awsPairs": [
        {
          "accessKeyIdVar": "MY_KEY_ID",
          "secretAccessKeyVar": "MY_SECRET_KEY",
          "sessionTokenVar": "MY_SESSION_TOKEN"
        }
      ]
    }
  }
}
```

各名前付き変数は [`sandbox.credentials.envVars`](#sandbox-credentials-envvars) の全体値 `mask` エントリである必要があり、`extract` または `decode` なしで、すべてのペアで 1 つのスロットのみを埋めることができます。以下のルールも適用されます：

* プロキシは、アクセスキー ID エントリの `injectHosts` にリストされたホストでリクエストを再署名します
* `sessionTokenVar` が設定されている場合、プロキシは再署名されたリクエストで実際のトークンを `x-amz-security-token` として送信します
* ペアで従来の変数のいずれかを指定すると、自動ペアリングが置き換えられます

### `sandbox.credentials.sigv4`

サンドボックスプロキシが [再署名できない](https://code.claude.com/docs/ja/sandboxing.md#re-sign-aws-requests)AWS リクエスト形式で何をするかを選択します：`streaming` は aws-chunked ストリーミングアップロード、`presigned` は事前署名 URL、`sigv4a` は SigV4A 非対称署名です。これは、マスクされたペアのプレースホルダーアクセスキー ID で署名されたリクエストにのみ適用されます。Claude Code v2.1.224 以降が必要です。

* **Scope**: [`User or managed`](#scopes)
* **Type**: `streaming`、`presigned`、`sigv4a` を含むオブジェクト。各オブジェクトは以下のいずれかです：
  * `"deny"`: プロキシはリクエストを失敗させます
  * `"passthrough"`: プロキシはマスクされたプレースホルダーで署名されたリクエストを転送するため、ツールは AWS 自体の拒否を受け取ります
* **Default**: 未設定。すべての形式は `"deny"` です

これにより、ストリーミングアップロードはプロキシで失敗する代わりに転送されます：

```json settings.json theme={null}
{
  "sandbox": {
    "credentials": {
      "sigv4": {
        "streaming": "passthrough"
      }
    }
  }
}
```

`deny` の場合、プロキシはリクエストを失敗させます。`passthrough` の場合、プロキシはマスクされたプレースホルダーから計算された署名でリクエストを転送するため、AWS はそれを拒否し、呼び出しツールはプロキシエラーの代わりに AWS 自体のレスポンスを受け取ります。

### `sandbox.network`

サンドボックス化されたコマンドが到達できるホスト、ポート、ソケットを制御します。サンドボックスは送信トラフィックをプロキシを通じてルーティングし、これらのリストを強制します。[ネットワーク分離](https://code.claude.com/docs/ja/sandboxing.md#network-isolation)を参照して、プロキシがどのように決定するか、およびいつプロンプトするかを確認してください。

* **Scope**: [`Any file`](#scopes)。`strictAllowlist`、`allowManagedDomainsOnly`、`tlsTerminate` は、それらのエントリが言うように、より少ないソースから読み取られます。
* **Type**: 以下のサブキーを含むオブジェクト
* **Default**: 未設定。ドメインは事前に許可されず、[新しい各ホストをどう扱うか](https://code.claude.com/docs/ja/sandboxing.md#hosts-outside-your-allowed-domains)は権限モードによって決まります

これにより、GitHub と npm が事前に許可され、`uploads.github.com` がブロックされ、コマンドが localhost にバインドできます：

```json settings.json theme={null}
{
  "sandbox": {
    "network": {
      "allowedDomains": ["github.com", "*.npmjs.org"],
      "deniedDomains": ["uploads.github.com"],
      "allowLocalBinding": true
    }
  }
}
```

Claude Code は配列サブキーを設定スコープ全体でマージするため、[リポジトリロック](https://code.claude.com/docs/ja/sandboxing.md#repository-settings-under-an-admin-required-sandbox)が適用されない限り、プロジェクトはユーザーリストにドメインを追加できます。`WebFetch(domain:...)` 許可および拒否[権限ルール](https://code.claude.com/docs/ja/sandboxing.md#permission-rules)は同じ許可および拒否リストをフィードします。

### `sandbox.network.allowUnixSockets`

macOS でサンドボックス化されたコマンドが接続できる Unix ソケットパスをリストします。Claude Code は Linux と WSL2 でこのリストを無視します。seccomp フィルタはソケットパスを検査できません。代わりに [`allowAllUnixSockets`](#sandbox-network-allowallunixsockets) を使用します。

* **Scope**: [`Any file`](#scopes)（[プロジェクト設定とローカル設定には制限あり](https://code.claude.com/docs/ja/sandboxing.md#repository-settings-under-an-admin-required-sandbox)）
* **Type**: 文字列の配列。各ソケットパス
* **Default**: 未設定。macOS サンドボックスはすべての Unix ソケットをブロックします

```json settings.json theme={null}
{
  "sandbox": {
    "network": {
      "allowUnixSockets": ["~/.ssh/agent-socket"]
    }
  }
}
```

ソケットパスは広いアクセスを許可できます。たとえば、`/var/run/docker.sock` を許可すると、サンドボックス化されたコマンドが Docker デーモンを制御できます。[セキュリティ制限](https://code.claude.com/docs/ja/sandboxing.md#security-limitations)を参照してください。

### `sandbox.network.allowAllUnixSockets`

サンドボックス化されたコマンドがすべての Unix ソケットに接続できるようにします。Linux と WSL2 では、サンドボックスの [seccomp フィルタ](https://code.claude.com/docs/ja/sandboxing.md#set-up-linux-and-wsl2) は `socket(AF_UNIX, ...)` 呼び出しをブロックするため、これは Unix ソケットを許可する唯一の方法です。フィルタが不足している場合（`/sandbox` がその Dependencies タブで報告する場合）、サンドボックスは Unix ソケット呼び出しをブロックしません。[Linux と WSL2 をセットアップする](https://code.claude.com/docs/ja/sandboxing.md#set-up-linux-and-wsl2)を参照して、フィルタがどこから来るかを確認してください。

* **Scope**: [`Any file`](#scopes)（[プロジェクト設定とローカル設定には制限あり](https://code.claude.com/docs/ja/sandboxing.md#repository-settings-under-an-admin-required-sandbox)）
* **型**: ブール値
  * `true`: サンドボックス化されたコマンドはすべての Unix ソケットに接続できます。Linux と WSL2 では、VM ソケット（`AF_VSOCK` アドレスファミリー）にも接続できます
  * `false`: サンドボックスは Unix ソケットの接続をブロックします。macOS では `allowUnixSockets` 内のパスを除いてブロックし、Linux と WSL2 では seccomp フィルターが存在する場合にそれを通じてブロックします
* **Default**: `false`

```json settings.json theme={null}
{
  "sandbox": {
    "network": {
      "allowAllUnixSockets": true
    }
  }
}
```

WSL2 では、`true` は `cmd.exe` や `powershell.exe` などの Windows バイナリを起動する相互運用ソケットも再度開きます。

### `sandbox.network.allowLocalBinding`

macOS でサンドボックス化されたコマンドがネットワークポートでリッスンし（開発サーバーの起動など）、localhost の任意のポートに接続できるようにします。ループバック以外のアドレスでリッスンするコマンドは、他のマシンからの接続を受け付けます。Linux と WSL2 では各サンドボックス化されたコマンドが独自のループバックインターフェースを持つため、このキーは効果がありません。Linux または WSL2 からホスト上のサーバーに到達するには、[コマンドが localhost 上のサーバーに到達できない](https://code.claude.com/docs/ja/sandboxing.md#a-command-fails-to-reach-a-server-on-localhost)を参照してください。

* **Scope**: [`Any file`](#scopes)（[プロジェクト設定とローカル設定には制限あり](https://code.claude.com/docs/ja/sandboxing.md#repository-settings-under-an-admin-required-sandbox)）
* **Type**: ブール値
  * `true`: macOS でサンドボックス化されたコマンドは任意のローカルアドレスでリッスンし、localhost の任意のポートに接続できます
  * `false`: macOS でサンドボックス化されたコマンドはポートでリッスンすることも、localhost 上のサーバーに直接接続することもできません
* **Default**: `false`

```json settings.json theme={null}
{
  "sandbox": {
    "network": {
      "allowLocalBinding": true
    }
  }
}
```

### `sandbox.network.allowMachLookup`

macOS サンドボックスが検索できる追加の XPC および Mach サービス名をリストします。iOS Simulator や Playwright などの XPC を通じて通信するツールは、ここにサービスをリストする必要があります。

* **Scope**: [`Any file`](#scopes)（[プロジェクト設定とローカル設定には制限あり](https://code.claude.com/docs/ja/sandboxing.md#repository-settings-under-an-admin-required-sandbox)）
* **Type**: 文字列の配列。各サービス名。単一の末尾 `*` はプレフィックスと一致し、`"*"` だけはすべてのサービスと一致します
* **Default**: 未設定

次の例では、`com.apple.CoreSimulator.` プレフィックス配下のすべてのサービスを許可します。

```json settings.json theme={null}
{
  "sandbox": {
    "network": {
      "allowMachLookup": ["com.apple.CoreSimulator.*"]
    }
  }
}
```

### `sandbox.network.allowedDomains`

サンドボックス化されたコマンドからの送信トラフィック用にドメインを事前に許可するため、サンドボックスはそれらについてプロンプトしません。`*.example.com` などのワイルドカードはサブドメインと一致し、optional `:port` サフィックスはエントリを 1 つのポートに制限します。ポートなしのエントリはすべてのポートと一致します。

* **Scope**: [`Any file`](#scopes)（[プロジェクト設定とローカル設定には制限あり](https://code.claude.com/docs/ja/sandboxing.md#repository-settings-under-an-admin-required-sandbox)）。[`allowManagedDomainsOnly`](#sandbox-network-allowmanageddomainsonly)が設定されている場合、管理設定のみ。
* **Type**: 文字列の配列。各ドメイン、ワイルドカードパターン、または IP リテラル。optional `:port` サフィックス付き
* **Default**: 未設定。[新しい各ホストをどう扱うか](https://code.claude.com/docs/ja/sandboxing.md#hosts-outside-your-allowed-domains)は権限モードによって決まります

これにより、GitHub がすべてのポートで事前に許可され、すべての npm サブドメイン、および 1 つの API ホストがポート 443 でのみ許可されます：

```json settings.json theme={null}
{
  "sandbox": {
    "network": {
      "allowedDomains": ["github.com", "*.npmjs.org", "api.example.com:443"]
    }
  }
}
```

IPv6 リテラルを括弧で囲んで書き込みます。optional ポート付き：`"[::1]"` はすべてのポートを許可し、`"[::1]:443"` は 1 つのポートを許可します。括弧形式には Claude Code v2.1.229 以降が必要です。[ドメインリストの IPv6 アドレス](https://code.claude.com/docs/ja/sandboxing.md#ipv6-addresses-in-domain-lists)を参照してください。

### `sandbox.network.deniedDomains`

[`allowedDomains`](#sandbox-network-alloweddomains)と同じワイルドカード、ポート、IPv6 構文を使用して、サンドボックス化されたコマンドからの送信トラフィック用にドメインをブロックします。拒否されたドメインは、`allowedDomains` エントリも一致する場合でもブロックされたままです。

* **Scope**: [`Any file`](#scopes)
* **Type**: 文字列の配列。各ドメイン、ワイルドカードパターン、または IP リテラル。optional `:port` サフィックス付き
* **Default**: 未設定

```json settings.json theme={null}
{
  "sandbox": {
    "network": {
      "deniedDomains": ["sensitive.cloud.example.com"]
    }
  }
}
```

Claude Code はセッションが読み込むすべての設定ソースからこのリストをマージします。`allowManagedDomainsOnly` が設定されている場合でも、開発者は常に拒否リストを厳しくできます。IPv6 リテラルについては、[ドメインリストの IPv6 アドレス](https://code.claude.com/docs/ja/sandboxing.md#ipv6-addresses-in-domain-lists)を参照してください。

完全修飾ドメイン名をマークする末尾ドット（`example.com.` など）で書き込まれたエントリは、`example.com` と同じ接続をブロックします。

### `sandbox.network.strictAllowlist`

許可リスト外のホストへのサンドボックス化されたコマンドのアクセスを、承認を求めるプロンプトを表示する代わりに拒否します。許可リストは [`allowedDomains`](#sandbox-network-alloweddomains) と `WebFetch(domain:...)` 許可ルールからのドメイン、または [`allowManagedDomainsOnly`](#sandbox-network-allowmanageddomainsonly) が設定されている場合は管理設定エントリのみです。リポジトリのエントリについては、[管理者必須のサンドボックスなしで適用されるロック](https://code.claude.com/docs/ja/sandboxing.md#locks-that-apply-without-an-admin-required-sandbox)を参照してください。Claude Code v2.1.219 以降が必要です。

* **Scope**: [`User or managed`](#scopes)。リポジトリはそれをオンまたはオフにできません。
* **Type**: ブール値
  * `true`: Claude Code は許可リスト外のホストへのサンドボックス化されたコマンドアクセスを拒否します
  * `false`: 別の信頼できる設定ファイルが `true` を設定しない限り、Claude Code は許可リスト外のホストを即座に拒否するのではなく、権限モードに応じて判断します：auto モードではコマンドの[コマンドごとの許可ドメイン](https://code.claude.com/docs/ja/sandboxing.md#per-command-allowed-domains-in-auto-mode)に対してホストをチェックし、`dontAsk` モードでは拒否し、`bypassPermissions` モードおよびバイパスが利用可能なインタラクティブターミナルの plan モードセッションでは許可し、それ以外の場合はユーザーに確認します
* **Default**: `false`

```json settings.json theme={null}
{
  "sandbox": {
    "network": {
      "strictAllowlist": true
    }
  }
}
```

Claude Code はサンドボックス化されたコマンドのみに対してこれを強制します。`WebFetch` などのインプロセスツールは引き続き[権限ルール](https://code.claude.com/docs/ja/sandboxing.md#permission-rules)に従います。尊重されるソースのいずれかが `true` に設定する場合、それはオンのままです。[ネットワーク分離](https://code.claude.com/docs/ja/sandboxing.md#network-isolation)を参照してください。Claude Code v2.1.219 以降が必要です。

### `sandbox.network.allowManagedDomainsOnly`

ネットワーク許可リストを管理設定が定義するものにロックします。Claude Code は管理設定からの `allowedDomains` と `WebFetch(domain:...)` 許可ルールのみを尊重し、ユーザー、プロジェクト、ローカル、`--settings` 設定からのドメインを無視し、許可されていないドメインをプロンプトする代わりに自動的にブロックします。

* **Scope**: [`Managed`](#scopes)
* **Type**: ブール値
  * `true`: Claude Code は管理設定からの `allowedDomains` と `WebFetch(domain:...)` 許可ルールのみを尊重し、許可されていないドメインをプロンプトする代わりにブロックします
  * `false`: 他の設定ファイルからのドメインも許可リストにマージされます
* **Default**: `false`

これにより、許可リストが GitHub と npm にロックされ、開発者が追加するドメインが無視されます：

```json managed-settings.json theme={null}
{
  "sandbox": {
    "network": {
      "allowManagedDomainsOnly": true,
      "allowedDomains": ["github.com", "*.npmjs.org"]
    }
  }
}
```

キーが `true` の間、サンドボックスは[管理者必須](https://code.claude.com/docs/ja/sandboxing.md#repository-settings-under-an-admin-required-sandbox)となり、[プロキシポート](#sandbox-network-httpproxyport)を設定できるのは管理設定のみになります。

拒否されたドメインは引き続きセッションが読み込むすべてのソースからマージされます。[ポリシーの拡大を開発者に防止させる](https://code.claude.com/docs/ja/sandboxing.md#keep-developers-from-widening-the-policy)を参照してください。

### `sandbox.network.httpProxyPort`

Claude Code が実行するものの代わりに、独自の HTTP プロキシをサンドボックスに指定します。組織はこれを使用して、HTTPS トラフィックを検査したり、独自のフィルタリングルールを適用したり、リクエストをログに記録したりします。フィルタリングは独自のプロキシが引き継ぎ、Claude Code はそこに送信されるトラフィックにドメインリストとネットワークプロンプトを適用しなくなります。未設定の場合、Claude Code は HTTP トラフィック用に独自のプロキシを起動します。

* **Scope**: [`Any file`](#scopes)。ただし、[他のサンドボックス設定によってポートを設定できるファイルが制限される](https://code.claude.com/docs/ja/sandboxing.md#custom-proxy-configuration)場合を除きます
* **Type**: 数値。ローカル TCP ポート
* **Default**: 未設定。Claude Code は独自のプロキシを実行します

```json settings.json theme={null}
{
  "sandbox": {
    "network": {
      "httpProxyPort": 8080
    }
  }
}
```

プロキシで SOCKS トラフィックも扱う場合は、[`socksProxyPort`](#sandbox-network-socksproxyport) も設定します。2 つのうち一方のみを設定した場合、Claude Code はもう一方のプロトコル用に引き続き独自のプロキシを実行します。[カスタムプロキシ設定](https://code.claude.com/docs/ja/sandboxing.md#custom-proxy-configuration)を参照してください。

### `sandbox.network.socksProxyPort`

Claude Code が実行するものの代わりに、独自の SOCKS5 プロキシをサンドボックスに指定します。フィルタリングは独自のプロキシが引き継ぎ、Claude Code はそこに送信されるトラフィックにドメインリストとネットワークプロンプトを適用しなくなります。未設定の場合、Claude Code は SOCKS トラフィック用に独自のプロキシを起動します。

* **Scope**: [`Any file`](#scopes)。ただし、[他のサンドボックス設定によってポートを設定できるファイルが制限される](https://code.claude.com/docs/ja/sandboxing.md#custom-proxy-configuration)場合を除きます
* **Type**: 数値。ローカル TCP ポート
* **Default**: 未設定。Claude Code は独自のプロキシを実行します

```json settings.json theme={null}
{
  "sandbox": {
    "network": {
      "socksProxyPort": 8081
    }
  }
}
```

[カスタムプロキシ設定](https://code.claude.com/docs/ja/sandboxing.md#custom-proxy-configuration)を参照してください。

### `sandbox.network.tlsTerminate`

サンドボックスプロキシが TLS を終了して、HTTPS リクエストの内容を読み取ることができるようにします。これは実験的であり、`mask` [認証情報置換](https://code.claude.com/docs/ja/sandboxing.md#mask-credentials)はそれを必要とします。`{}` を設定してセッション用に一時的な認証局を生成するか、`caCertPath` と `caKeyPath` を設定して独自のものを使用します。

* **Scope**: [`User or managed`](#scopes)。リポジトリはそれをオンにするか、認証局を提供できません。
* **Type**: optional `caCertPath` と `caKeyPath` 文字列を含むオブジェクト。各ファイルパス
* **Default**: 未設定。プロキシは TLS を終了または検査しません

```json settings.json theme={null}
{
  "sandbox": {
    "network": {
      "tlsTerminate": {}
    }
  }
}
```

複数の尊重されるソースがそれを設定する場合、Claude Code は最も優先度の高いソースからの値を使用します：管理設定、次に `--settings` フラグ、次にユーザー設定。

## メモリとコンテキスト

Claude Code がコンテキストに読み込む内容、コンテキスト圧縮の方法、メモリとプランの保存場所を制御します。[コンテキストの管理](https://code.claude.com/docs/ja/context-window.md)と[メモリ](https://code.claude.com/docs/ja/memory.md)を参照してください。

### `autoCompactEnabled`

コンテキストが上限に近づいたときに、Claude Code が[会話を自動的に圧縮する](https://code.claude.com/docs/ja/context-window.md#when-your-context-fills-up)ようにします。`/config` では **Auto-compact** として表示され、そこで切り替えるとこのキーがユーザー設定に書き込まれます。

* **スコープ**: [`Any file`](#scopes)
* **型**: ブール値
  * `true`: コンテキストが上限に近づくと、Claude Code は会話を自動的に圧縮します
  * `false`: Claude Code は自動的に圧縮しません
* **デフォルト**: `true`
* **セッションごとの上書き**: [`DISABLE_AUTO_COMPACT`](https://code.claude.com/docs/ja/env-vars) は 1 つのセッションで自動圧縮をオフにします。2 つのうちどちらかがオフにした場合、もう一方でオンに戻すことはできません

```json settings.json theme={null}
{
  "autoCompactEnabled": false
}
```

自動圧縮がオフの間も、手動の `/compact` コマンドは引き続き機能します。自動圧縮をオフにすると、[アイドル時のコンテキスト圧縮](#idlecompaction)もオフになります。

### `autoCompactWindow`

Claude Code が[自動的に圧縮する](https://code.claude.com/docs/ja/context-window.md#when-your-context-fills-up)前に、コンテキストウィンドウがどこまで埋まるかを設定します。

* **スコープ**: [`Any file`](#scopes)
* **型**: トークン数、`100000` から `1000000` まで。Claude Code はこの値をモデルのコンテキストウィンドウで上限設定します。各モデルのウィンドウは[モデルの概要](https://platform.claude.com/docs/en/about-claude/models/overview)に記載されています
* **デフォルト**: 未設定。この場合、Claude Code はモデルに合わせて調整されたウィンドウを選択します
* **セッションごとの上書き**: [`--autocompact`](https://code.claude.com/docs/ja/cli-reference#cli-flags) は 1 つのセッションでこのキーより優先されます。また、Claude Code が[変数の値を無視する](https://code.claude.com/docs/ja/model-config.md#claude_code_auto_compact_window-values)場合を除き、[`CLAUDE_CODE_AUTO_COMPACT_WINDOW`](https://code.claude.com/docs/ja/env-vars) は両方より優先されます

```json settings.json theme={null}
{
  "autoCompactWindow": 500000
}
```

[`/autocompact`](https://code.claude.com/docs/ja/commands#all-commands) コマンドは、現在のモデル用のウィンドウを [`modelSettings`](#modelsettings) の下に保存します。これは、そのモデルについて同じファイル内のこのキーより優先されます。コマンド、フラグ、変数、設定がどのように相互作用するかについては、[自動圧縮ウィンドウを設定する](https://code.claude.com/docs/ja/model-config.md#set-the-auto-compact-window)で説明しています。

### `autoMemoryDirectory`

[自動メモリ](https://code.claude.com/docs/ja/memory.md#storage-location)を、プロジェクトごとのデフォルトではなく任意のディレクトリに保存します。

* **スコープ**: [`Any file`](#scopes)
* **型**: 文字列。絶対パス、または `~/` で始まるディレクトリパス
* **デフォルト**: 未設定。この場合、Claude Code は `~/.claude/projects/<project>/memory/` を使用します

```json settings.json theme={null}
{
  "autoMemoryDirectory": "~/my-memory-dir"
}
```

クローンしたリポジトリがプロジェクト設定やローカル設定のファイルを提供できるため、これらの設定では、Claude Code は[フックと同じワークスペース信頼ルール](https://code.claude.com/docs/ja/permissions.md#what-runs-before-you-trust-a-folder)に従ってこのキーを適用します。

### `autoMemoryEnabled`

[自動メモリ](https://code.claude.com/docs/ja/memory.md#enable-or-disable-auto-memory)をオンまたはオフにします。`false` の場合、Claude は自動メモリディレクトリの読み取りも書き込みも行いません。セッション中に `/memory` で切り替えることもでき、その場合はこのキーがユーザー設定に書き込まれます。

* **スコープ**: [`Any file`](#scopes)
* **型**: ブール値
  * `true`: 未設定と同じです。`--bare`、セーフモード、`CLAUDE_CODE_DISABLE_AUTO_MEMORY` など、このキーより優先されるものがセッションでオフにしない限り、自動メモリはオンのままです
  * `false`: Claude は自動メモリディレクトリの読み取りも書き込みも行いません
* **デフォルト**: `true`
* **セッションごとの上書き**: [`CLAUDE_CODE_DISABLE_AUTO_MEMORY`](https://code.claude.com/docs/ja/env-vars) は、どちらの方向でも 1 つのセッションでこのキーより優先されます

```json settings.json theme={null}
{
  "autoMemoryEnabled": false
}
```

### `bashOutputMaxChars`

成功した Bash または PowerShell コマンドの[出力のうち、Claude がインラインで受け取る](https://code.claude.com/docs/ja/tools-reference.md#output-limits)文字数を設定します。出力が上限を超えると、Claude Code はそれをファイルに保存し、Claude は短いプレビューとファイルのパスを受け取ります。詳細なビルドやテストスイート全体のログなど、コマンドの出力がデフォルトを日常的に超え、Claude にファイルを開かずに読ませたい場合は、上限を引き上げてください。Claude Code v2.1.261 以降が必要です。

* **スコープ**: [`Any file`](#scopes)
* **型**: 文字数、正の整数。Claude Code は値を `4000` から `128000` の範囲に収めます
* **デフォルト**: 未設定。この場合、Claude はインラインで最大 30,000 文字を受け取ります

```json settings.json theme={null}
{
  "bashOutputMaxChars": 100000
}
```

このキーを設定すると、Claude Code は [`BASH_MAX_OUTPUT_LENGTH`](https://code.claude.com/docs/ja/env-vars) 環境変数を無視します。

### `claudeMd`

別のファイルをデプロイせずに、CLAUDE.md 形式の指示を組織管理のメモリとして挿入します。Claude Code は、このテキストを管理メモリのエントリとして、ユーザーおよびプロジェクトの CLAUDE.md ファイルより先に読み込みます。

* **スコープ**: [`Managed`](#scopes)
* **型**: 文字列。CLAUDE.md ファイルのテキストです。markdown を含め、ファイルと同じように記述し、改行は `\n` とします
* **デフォルト**: 未設定

この例では、2 つのルールを短い markdown のリストとしてデプロイします。

```json managed-settings.json theme={null}
{
  "claudeMd": "# Engineering rules\n\n- Always run make lint before committing.\n- Never push directly to main."
}
```

[組織全体の CLAUDE.md をデプロイする](https://code.claude.com/docs/ja/memory.md#deploy-organization-wide-claude-md)を参照してください。

### `claudeMdExcludes`

Claude Code が[メモリ](https://code.claude.com/docs/ja/memory.md#exclude-specific-claude-md-files)を読み込む際に、特定の `CLAUDE.md` ファイルをスキップします。大規模なモノレポでは、自分の作業に関係のない他チームの CLAUDE.md ファイルをスキップするために使用します。大規模コードベースのガイドの[関係のない CLAUDE.md ファイルを除外する](https://code.claude.com/docs/ja/large-codebases.md#exclude-irrelevant-claude-md-files)で、このケースを詳しく説明しています。パターンは絶対ファイルパスに対してマッチします。

* **スコープ**: [`Any file`](#scopes)
* **型**: 文字列の配列。各要素は glob パターンまたは絶対パスです
* **デフォルト**: 未設定。この場合、Claude Code は見つかったすべての CLAUDE.md を読み込みます

```json settings.json theme={null}
{
  "claudeMdExcludes": ["**/vendor/**/CLAUDE.md"]
}
```

除外はユーザー、プロジェクト、ローカルのメモリファイルにのみ適用されます。管理ポリシーの CLAUDE.md ファイルは除外できません。

### `env`

すべてのセッションと、そのセッションから Claude Code が起動するサブプロセスに環境変数を設定します。[環境変数リファレンス](https://code.claude.com/docs/ja/env-vars.md)にあるほとんどの変数はここに記述でき、これによって変数をすべてのセッションに適用したり、チームに展開したりできます。プロジェクト設定とローカル設定では、[一部の変数](#variables-claude-code-ignores-in-env)を設定できません。

* **スコープ**: [`Any file`](#scopes)
* **型**: 変数名を文字列値にマッピングするオブジェクト
* **デフォルト**: 未設定

この例では、自動圧縮をオフにし、API リクエストをプロキシ経由でルーティングします。

```json settings.json theme={null}
{
  "env": {
    "DISABLE_AUTO_COMPACT": "1",
    "ANTHROPIC_BASE_URL": "https://proxy.example.com"
  }
}
```

#### `env` の値とシェルの相互作用

* ここで指定した値は、シェルでエクスポートされた同じ変数を上書きします。複数の設定ファイルが同じ変数を設定している場合は、[優先順位が最も高い](https://code.claude.com/docs/ja/settings.md#settings-precedence)ものが適用されます。プロジェクト設定とローカル設定の例外は、[Claude Code が `env` で無視する変数](#variables-claude-code-ignores-in-env)に記載しています。
* Claude Desktop アプリまたは[セルフホスト環境](https://code.claude.com/docs/ja/self-hosted-environments)のランナーがセッションを開始する場合は、代わりにそれが構築する起動環境が優先されます。起動環境がすでに設定している変数については、Claude Code はどの設定ファイルの `env` の値も無視します。無視された各変数は[デバッグログ](https://code.claude.com/docs/ja/debug-your-config.md)に記載されます。
* シェルのエクスポートを取り消すには、変数を `""` に設定します。Claude Code はプロバイダーの選択において空の値を未設定として扱い、サブプロセスは空の値を継承します。
* ここで設定した `NO_COLOR` と `FORCE_COLOR` は、サブプロセスにのみ反映されます。Claude Code 自体のインターフェースのカラーを変更するには、`claude` を起動する前にシェルで設定してください。
* ここに記述した値は設定ファイル内のプレーンテキストであり、Claude Code が起動するすべてのサブプロセスに渡されます。ローテーションする OTLP ベアラートークンには [`otelHeadersHelper`](#otelheadershelper) を、API の認証情報には [`apiKeyHelper`](#apikeyhelper) を使用してください。

#### Claude Code が `env` の値を適用するタイミング

* ユーザー設定、`--settings`、管理設定からの値: 起動時、および保存された変更によってマージ後の `env` が変わったときに実行中のセッションで再度適用されます。
* プロジェクト設定とローカル設定からの値: ワークスペースを信頼した後、または信頼ダイアログを表示しない `-p` モードでは起動時に適用され、保存された変更によってマージ後の `env` が変わったときに再度適用されます。
* モデルの選択、タイムアウトと制限、機能の切り替えなど、Claude Code が安全と分類する変数: [プロジェクト設定とローカル設定で設定できない変数](#variables-claude-code-ignores-in-env)を除き、起動時にすべての設定ファイルから適用されます。
* v2.1.246 以降で [`/cd` でセッションを移動した](https://code.claude.com/docs/ja/permissions#move-the-session-to-another-directory)後: 以前のディレクトリの値に加えて、新しいディレクトリのプロジェクトとローカルの `env` の値が適用されます。

#### Claude Code が `env` で無視する変数

* プロジェクト設定とローカル設定では、チェックアウトしたリポジトリが制御すべきでない変数を設定できません。これらはシェル、ユーザー設定、または管理設定で設定してください。テレメトリをオフにするいくつかの値を除き、Claude Code はこれらをそれぞれ破棄し、`claude --debug` で確認できる警告をログに記録します。対象には次のものが含まれます。

  * Claude Code が自身のファイルを保存または書き込む場所を選択する変数: `CLAUDE_CONFIG_DIR`、`CLAUDE_CODE_TMPDIR`、およびオペレーティングシステムのディレクトリ変数（`HOME`、`TMPDIR`、`TMP`、`TEMP`、`XDG_*` ファミリーなど）。
  * Claude Code が起動するプロセスのプログラムやマシン全体の設定を選択する Windows の変数（`SystemRoot`、`ComSpec`、`ProgramData`、`LOCALAPPDATA`、`PATHEXT`、`PSModulePath`、`ProgramFiles` ファミリーなど）。
  * セッションの内容をエクスポートする変数: [`OTEL_LOG_RAW_API_BODIES`](https://code.claude.com/docs/ja/env-vars#variables)、および詳細なベータトレースのペアである `ENABLE_BETA_TRACING_DETAILED` と `BETA_TRACING_ENDPOINT`。
  * テレメトリをオンにする、送信先を選択する、またはキャプチャする内容を選択する [OpenTelemetry エクスポーター](https://code.claude.com/docs/ja/monitoring-usage.md)の変数:

    * `CLAUDE_CODE_ENABLE_TELEMETRY`、および拡張テレメトリのベータのペアである `CLAUDE_CODE_ENHANCED_TELEMETRY_BETA` と `ENABLE_ENHANCED_TELEMETRY_BETA`
    * エクスポーターのセレクターである `OTEL_LOGS_EXPORTER`、`OTEL_METRICS_EXPORTER`、`OTEL_TRACES_EXPORTER`
    * 内容に関する変数である `OTEL_LOG_USER_PROMPTS`、`OTEL_LOG_ASSISTANT_RESPONSES`、`OTEL_LOG_TOOL_CONTENT`、`OTEL_LOG_TOOL_DETAILS`
    * 名前が `_ENDPOINT`、`_HEADERS`、`_PROTOCOL`、`_CERTIFICATE`、`_CLIENT_KEY`、または `_INSECURE` で終わる `OTEL_EXPORTER_OTLP_*` 変数（汎用形式とシグナルごとの形式の両方。`OTEL_EXPORTER_OTLP_ENDPOINT` や `OTEL_EXPORTER_OTLP_METRICS_HEADERS` など）
    * `OTEL_EXPORTER_PROMETHEUS_HOST` と `OTEL_EXPORTER_PROMETHEUS_PORT`

    プロジェクト設定とローカル設定から引き続き適用されるのは、何かをオフにする次の値のみです。3 つのエクスポーターセレクターに対する `none`、および `OTEL_LOG_USER_PROMPTS`、`OTEL_LOG_TOOL_CONTENT`、`OTEL_LOG_TOOL_DETAILS` に対する `0` などのオフの値です。このような値はユーザー設定にある同じ変数を上書きしますが、Claude Code を起動した環境、`--settings` ファイル、または管理設定で設定された変数は上書きしません。

    プロジェクトまたはローカルの設定ファイルがこのグループの変数を設定している場合、ローカルの対話型セッションでは起動時に通知が表示されます。`/status` または `claude doctor` を実行すると、Claude Code がどの変数を無視し、どの変数がテレメトリをオフにしたかを確認できます。どちらも名前のみを表示し、値は表示しません。`-p` による非対話型の実行や Agent SDK のセッションでは通知が表示されないため、アップグレード後にコレクターが引き続きデータを受信していることを確認してください。受信していない場合は、ユーザー設定、管理設定、ジョブの環境、または `--settings` で渡すファイルで変数を設定してください。

    プロジェクト設定とローカル設定でこのグループを無視する動作には、Claude Code v2.1.282 以降が必要です。
  * Claude Code の起動方法や同期方法を変更する変数（`CLAUDE_CODE_PROCESS_WRAPPER`、`CLAUDE_CODE_SYNC_SKILLS`、`CLAUDE_CODE_SYNC_PLUGINS`、`CLAUDE_CODE_PLUGIN_CACHE_DIR`、`CLAUDE_CODE_PLUGIN_SEED_DIR` など）。
  * [スクリーンリーダーモード](https://code.claude.com/docs/ja/accessibility.md)の変数 `CLAUDE_AX_SCREEN_READER`、および名前が `CLAUDE_AX_` で始まるその他の変数（[`CLAUDE_AX_STARTUP_QUIET_MS`](https://code.claude.com/docs/ja/env-vars#variables) など）。
  * 応答のないダイアログのタイマーを設定する [`CLAUDE_CODE_USER_DIALOG_TIMEOUT_MS`](https://code.claude.com/docs/ja/env-vars#variables)。
  * 添付ファイルの処理をオフにする [`CLAUDE_CODE_DISABLE_ATTACHMENTS`](https://code.claude.com/docs/ja/env-vars#variables)。
  * Claude Code がファイルやディレクトリの `@` メンションを展開しないようにする [`CLAUDE_CODE_DISABLE_FILE_MENTIONS`](https://code.claude.com/docs/ja/env-vars#variables)。

  v2.1.251 より前は、プロジェクト設定とローカル設定でも、このリストのうち Claude Code がファイルを書き込む場所を選択する変数やセッションの内容をエクスポートする変数を設定できました（`HOME` と `XDG_CONFIG_HOME` を除く）。v2.1.290 より前は、ダイアログのタイマー変数と `CLAUDE_CODE_DISABLE_ATTACHMENTS` も設定できました。
* `CLAUDE_CODE_REMOTE` や `CLAUDE_CODE_ACCOUNT_UUID` など、Claude Code のホスティング環境が所有する ID 変数は、すべてのファイルで無視されます。
* Claude Code 自身がエクスポートする [`CLAUDE_CODE_MESSAGING_SOCKET` と `CLAUDE_CODE_MESSAGING_TOKEN`](https://code.claude.com/docs/ja/env-vars#variables) は、すべてのファイルで無視されます。ソケット変数を無視する動作には Claude Code v2.1.224 以降が、トークンを無視する動作には v2.1.228 以降が必要です。
* Claude Code が起動環境からのみ読み取る [`CLAUDE_CODE_PROJECT_DIR_NAME`](https://code.claude.com/docs/ja/sessions#name-the-project-directory-yourself) は、すべてのファイルで無視されます。v2.1.234 以降が必要です。
* Claude Code が起動環境からのみ読み取る [`CLAUDE_CODE_RESTRICTED`](https://code.claude.com/docs/ja/env-vars#variables) は、すべてのファイルで無視されます。
* Claude Code が起動環境からのみ読み取る [`CLAUDE_CODE_DISABLE_POWERSHELL_CMD_RM_DENY`](https://code.claude.com/docs/ja/env-vars#variables) は、すべてのファイルで無視されます。この変数には Claude Code v2.1.283 以降が必要です。
* Claude Code が起動環境からのみ読み取る [`CLAUDE_CODE_DISABLE_DANGEROUS_RM_TIMEOUT`、`CLAUDE_CODE_DISABLE_SUBSTITUTION_RM_PROMPT`、`CLAUDE_CODE_DISABLE_INLINE_SHELL_RM_PROMPT`、`CLAUDE_CODE_DISABLE_MOUNTED_DRIVE_RM_PROMPT`](https://code.claude.com/docs/ja/env-vars#variables) は、すべてのファイルで無視されます。
* Claude Code が起動環境からのみ読み取る [`CLAUDE_CODE_EVEN_MORE_DANGEROUSLY_SKIP_PERMISSIONS`](https://code.claude.com/docs/ja/env-vars#variables) は、すべてのファイルで無視されます。
* Claude Code が起動環境からのみ読み取る [`CLAUDE_CODE_WARN_DISK_FREE_GIB` と `CLAUDE_CODE_WARN_MEMORY_FREE_GIB`](https://code.claude.com/docs/ja/env-vars#variables) は、すべてのファイルで無視されます。これらの変数には Claude Code v2.1.304 以降が必要です。

### `fileCheckpointingEnabled`

[`/rewind`](https://code.claude.com/docs/ja/checkpointing) で復元できるよう、Claude Code が各編集の前にファイルのスナップショットを取るようにします。`/config` では **Rewind code (checkpoints)** として表示され、そこで切り替えるとこのキーがユーザー設定に書き込まれます。

* **スコープ**: [`Any file`](#scopes)
* **型**: ブール値
  * `true`: `/rewind` で復元できるよう、Claude Code は各編集の前にファイルのスナップショットを取ります
  * `false`: Claude Code はファイルのスナップショットを取らないため、`/rewind` で復元できません
* **デフォルト**: `true`
* **セッションごとの上書き**: [`CLAUDE_CODE_DISABLE_FILE_CHECKPOINTING`](https://code.claude.com/docs/ja/env-vars) は 1 つのセッションでチェックポイント機能をオフにします。2 つのうちどちらかがオフにした場合、もう一方でオンに戻すことはできません

```json settings.json theme={null}
{
  "fileCheckpointingEnabled": false
}
```

`-p` の実行や Agent SDK のセッションでは、Claude Code はこのキーを無視します。SDK では `enableFileCheckpointing` オプションでチェックポイント機能をオンにし、単純な `-p` の実行では `CLAUDE_CODE_ENABLE_SDK_FILE_CHECKPOINTING=true` が必要です。[Agent SDK のファイルチェックポイント機能](https://code.claude.com/docs/ja/agent-sdk/file-checkpointing.md)を参照してください。

### `idleCompaction`

アイドル時のコンテキスト圧縮は、ユーザーが離席している長い会話を[圧縮](https://code.claude.com/docs/ja/context-window.md#what-survives-compaction)します。これにより、次のメッセージでは会話全体ではなく要約が送信されます。圧縮されると、会話に次の通知が表示されます。

* **ターミナル**: `Compacted while idle, before the prompt cache expired` で始まる行
* **[VS Code のチャットパネル](#idle-compaction-in-vs-code-and-the-desktop-app)**: `a summary written while you were away` を含む通知
* **[デスクトップアプリ](#idle-compaction-in-vs-code-and-the-desktop-app)**: 同じ通知が、ラベルに `Claude Code notice` を含む行の中に表示されます。その行やテキストが表示されない場合は、[Verbose 表示モード](https://code.claude.com/docs/ja/desktop.md#switch-view-modes)に切り替えてください。

アイドル時のコンテキスト圧縮は、次のすべての条件を満たす会話に対してデフォルトでオンになっています。

* **セッション**: 対話型のターミナルセッション、VS Code 拡張機能のチャットパネル、またはデスクトップアプリの Code タブ（セッションがローカルマシン上または SSH 経由で実行される場合）を使用している
* **自動圧縮**: [`autoCompactEnabled`](#autocompactenabled) がオンになっている
* **プロンプトキャッシュ**: 会話が [1 時間のプロンプトキャッシュ TTL](https://code.claude.com/docs/ja/prompt-caching.md#which-ttl-each-request-gets) を使用している
* **機能フラグ**: Claude Code が [Anthropic から機能フラグを取得](https://code.claude.com/docs/ja/env-vars.md#features-that-need-feature-flag-fetching)できる
* **サイズ**: 会話のコンテキストがトークンのしきい値に達している。しきい値はデフォルトの 200,000 から[変更](#change-the-idle-compaction-threshold)できます
* **アイドル時間**: 最後のリクエストから約 1 時間が経過しており、その時点までコンピューターがスリープしていない

アイドル時のコンテキスト圧縮をオフにするには、このキーを `false` に設定します。

* **スコープ**: [`Any file`](#scopes)
* **型**: ブール値
  * `true`: Claude Code は条件を満たすアイドル状態の会話を圧縮します
  * `false`: セッションがアイドル状態の間、Claude Code は圧縮しません
* **デフォルト**: `true`
* **セッションごとの上書き**: [`DISABLE_AUTO_COMPACT`](https://code.claude.com/docs/ja/env-vars) は、自動圧縮とともにアイドル時のコンテキスト圧縮もオフにします

```json settings.json theme={null}
{
  "idleCompaction": false
}
```

ターミナルセッション内からアイドル時のコンテキスト圧縮をオフまたはオンにするには、`/config` を実行して **Idle compaction** の行を変更します。選択内容はユーザー設定に保存され、すぐに適用されます。この行には Claude Code v2.1.302 以降が必要です。これらのバージョンを実行していて `/config` にこの行が表示されない場合は、次の原因を確認してください。

* **別の設定ソースがキーを設定している**: 管理設定、`--settings` フラグ、またはプロジェクトやローカルの設定ファイルの値がユーザー設定を上書きしています。代わりにそのソースでキーを変更してください
* **機能フラグが利用できない**: Claude Code が [Anthropic から機能フラグを取得](https://code.claude.com/docs/ja/env-vars.md#features-that-need-feature-flag-fetching)できない場合、アイドル時のコンテキスト圧縮は実行されないため、オフにする対象がありません

このキーには Claude Code v2.1.290 以降が必要です。このキーを無視する以前のバージョンでは、[`autoCompactEnabled`](#autocompactenabled) をオフにしてアイドル時のコンテキスト圧縮を停止してください。

#### アイドル時のコンテキスト圧縮のしきい値を変更する

[`CLAUDE_CODE_IDLE_COMPACT_MIN_TOKENS`](https://code.claude.com/docs/ja/env-vars) に、アイドル時のコンテキスト圧縮が適用されるまでに会話のコンテキストが到達する必要のあるトークン数を設定します。正の整数を使用してください。`100000` 未満の値は、最小のしきい値である `100000` に引き上げられます。

デフォルトでは、200K のコンテキストウィンドウを使用する会話は 200,000 トークンに達する前に自動圧縮されます。この例では、しきい値を 150,000 に下げて、そうした会話が対象になるようにします。

```json settings.json theme={null}
{
  "env": {
    "CLAUDE_CODE_IDLE_COMPACT_MIN_TOKENS": "150000"
  }
}
```

#### VS Code とデスクトップアプリでのアイドル時のコンテキスト圧縮

次のような通知は、Claude Code が[以前の会話を要約に置き換え](https://code.claude.com/docs/ja/context-window.md#what-survives-compaction)、Claude が現在その要約をもとに作業していることを意味します。

```text theme={null}
Compacted using a summary written while you were away · turn off with "idleCompaction": false in settings.json
```

特に操作は必要ありません。アイドル時のコンテキスト圧縮をオフにするには、セッションが実行されるマシンまたは WSL ディストリビューション上の `~/.claude/settings.json`、または別の[設定ファイル](https://code.claude.com/docs/ja/settings.md#settings-files-and-who-they-affect)で `idleCompaction` を `false` に設定します。

### `plansDirectory`

[plan モード](https://code.claude.com/docs/ja/permission-modes.md#analyze-before-you-edit-with-plan-mode)で Claude Code が書き込むプランファイルの保存場所を選択します。Claude Code はプロジェクトルートを基準にパスを解決します。

* **スコープ**: [`Any file`](#scopes)
* **型**: 文字列。プロジェクトルートからの相対パス
* **デフォルト**: 未設定。この場合、Claude Code は `~/.claude/plans` を使用します

```json settings.json theme={null}
{
  "plansDirectory": "./plans"
}
```

次のような場合、Claude Code は設定したディレクトリではなく `~/.claude/plans` にプランを保存します。

* **プロジェクトルートの外**: `"../plans"` のように、パスがプロジェクトルートの外に解決される場合。
* **macOS、Linux、WSL でのバックスラッシュ**: Windows 形式の `"docs\\plans"` のように、解決されたパスにバックスラッシュが含まれる場合。Windows でも機能する `"docs/plans"` と記述してください。

### `skillListingBudgetFraction`

Claude は各ターンで、説明付きの[スキルの一覧](https://code.claude.com/docs/ja/skills.md#skill-descriptions-are-cut-short)を参照します。Claude Code はその一覧をコンテキストウィンドウの一定割合に制限します。一覧が上限を超えると、Claude Code はすべてのスキルの名前を保持しつつ、使用頻度の低いスキルの説明を削除します。そのため、Claude はそれらのスキルを引き続き呼び出せますが、自発的に選択する可能性は低くなります。ターンごとのコンテキスト消費が増える代わりに、より多くの説明を表示し続けたい場合は、このキーの値を引き上げてください。

* **スコープ**: [`Any file`](#scopes)
* **型**: 数値。`0` より大きく `1` 以下の割合
* **デフォルト**: `0.01`。コンテキストウィンドウの 1% を確保します

```json settings.json theme={null}
{
  "skillListingBudgetFraction": 0.02
}
```

一覧が使用するコンテキストの量と、最も多くを占めているスキルを確認するには、`/doctor` を実行してください。

### `skillListingMaxDescChars`

Claude は各ターンで、各スキルの `description` と `when_to_use` のテキストを示す[スキルの一覧](https://code.claude.com/docs/ja/skills.md#skill-descriptions-are-cut-short)を参照します。このキーは、Claude Code がスキルごとに表示するそのテキストの文字数を制限します。これより長いテキストは上限で切り詰められます。

* **スコープ**: [`Any file`](#scopes)
* **型**: 文字数、正の整数
* **デフォルト**: `1536`

```json settings.json theme={null}
{
  "skillListingMaxDescChars": 2048
}
```

ターンごとのコンテキスト消費が増える代わりに長い説明をそのまま保持したい場合は値を引き上げ、[`skillListingBudgetFraction`](#skilllistingbudgetfraction) の範囲内により多くのスキルを収めたい場合は値を引き下げてください。

### `taskOutputMaxChars`

> [!WARNING]
>
> v2.1.277 で、このキーがサイズを決めていた `TaskOutput` ツールとともに削除されました。現在のバージョンでは設定しても効果はありません。Claude は代わりに `Read` でバックグラウンドタスクの[出力ファイル](https://code.claude.com/docs/ja/tools-reference.md#background-commands)を読み取ります。

v2.1.276 までは、Claude が `TaskOutput` ツールでタスクを読み取る際にインラインで受け取る[バックグラウンドタスクの](https://code.claude.com/docs/ja/tools-reference.md#background-commands)出力の文字数を、このキーに設定していました。

## インターフェースとターミナル

ターミナルでの Claude Code の見た目と動作を変更します。テーマ、エディターモード、ステータスライン、スピナー、セッション内の通知、アクセシビリティが対象です。[ターミナル設定](https://code.claude.com/docs/ja/terminal-config.md)を参照してください。

### `askUserQuestionTimeout`

応答のない [`AskUserQuestion`](https://code.claude.com/docs/ja/tools-reference) ダイアログを、一定のアイドル時間の後に自動で続行させ、その時点までに選択していたオプションを送信します。席を外している間も Claude に作業を続けさせたい場合に設定します。デフォルトでは、質問は回答するまで待機します。タイマーが一時停止する場合や開始しない場合については、[Question auto-continue timeout](https://code.claude.com/docs/ja/tools-reference.md#question-auto-continue-timeout) を参照してください。

* **スコープ**: [`User or managed`](#scopes)
* **型**: 文字列。`"60s"`、`"5m"`、`"10m"`、`"never"` のいずれか
* **デフォルト**: `"never"`

```json settings.json theme={null}
{
  "askUserQuestionTimeout": "5m"
}
```

`/config` では **Question auto-continue timeout** として表示され、このキーをユーザー設定に書き込みます。管理設定または `--settings` フラグがこのキーを設定している間、Claude Code はこの行を非表示にします。

### `autoContinueAtUsageLimit`

claude.ai の使用制限によってセッションが停止した後、開いたままのセッションで待機し、リセット後にタスクを自動的に続行します。[自動続行をオフにする](https://code.claude.com/docs/ja/interactive-mode.md#turn-automatic-continue-off)を参照してください。Claude Code v2.1.234 以降が必要です。

* **スコープ**: [`User or managed`](#scopes)。ユーザー設定、`--settings`、管理設定からのみ読み取られます。これらのいずれもキーを設定していない場合、キーを設定しているプロジェクト設定ファイルやローカル設定ファイルは無視されるのではなく、この機能をオフにします。
* **型**: Boolean
  * `true`: claude.ai の使用制限によってセッションが停止した後、Claude Code は開いたままのセッションで待機し、リセット後にタスクを自動的に続行します
  * `false`: Claude Code は自分から待機を開始しません。使用制限のオプションメニューから[自分で待機を開始する](https://code.claude.com/docs/ja/interactive-mode.md#start-a-wait-yourself)ことは引き続き可能です
* **デフォルト**: `true`

```json settings.json theme={null}
{
  "autoContinueAtUsageLimit": false
}
```

`/config` では **Continue automatically at usage limit** として表示され、このキーをユーザー設定に書き込みます。管理設定または `--settings` フラグがこのキーを設定している間、Claude Code はこの行を非表示にします。

### `autoScrollEnabled`

[フルスクリーンレンダリング](https://code.claude.com/docs/ja/fullscreen.md)で、新しい出力に合わせて会話の末尾まで追従します。オフにすると、Claude が作業を続けている間もスクロールした位置にとどまります。権限プロンプトは引き続きスクロールして表示されます。

* **スコープ**: [`Any file`](#scopes)
* **型**: Boolean
  * `true`: 会話が新しい出力に合わせて末尾まで追従します
  * `false`: Claude が作業を続けている間もスクロールした位置にとどまります。権限プロンプトは引き続きトランスクリプトの下に表示されます
* **デフォルト**: `true`

```json settings.json theme={null}
{
  "autoScrollEnabled": false
}
```

フルスクリーンレンダリングがオンのとき、`/config` に **Auto-scroll** として表示され、このキーをユーザー設定に書き込みます。

### `axScreenReader`

スクリーンリーダー向けの出力をレンダリングします。装飾的な枠線やアニメーションのないフラットなテキストです。スクリーンリーダーモードはクラシックレンダラーを使用するため、有効な間は `tui` 設定は効果がありません。アタッチされた[バックグラウンドセッション](https://code.claude.com/docs/ja/agent-view.md)は引き続きフルスクリーンでレンダリングされます。

* **スコープ**: [`User or managed`](#scopes)。`--settings` で渡すファイルでもキーを設定できます。Claude Code はプロジェクト設定とローカル設定のキーを無視するため、リポジトリも自分の `.claude/settings.local.json` もスクリーンリーダーモードをオンまたはオフにすることはできません。
* **型**: Boolean
  * `true`: Claude Code はクラシックレンダラーを使用して、装飾的な枠線やアニメーションのないフラットなテキストをレンダリングします
  * `false`: Claude Code は通常どおりレンダリングします
* **デフォルト**: 未設定のため、スクリーンリーダーモードはオフです
* **セッションごとの上書き**: 1 つのセッションに対して、[`--ax-screen-reader`](https://code.claude.com/docs/ja/cli-reference#cli-flags) は [`CLAUDE_AX_SCREEN_READER`](https://code.claude.com/docs/ja/env-vars) より優先され、どちらもこのキーより優先されます

```json settings.json theme={null}
{
  "axScreenReader": true
}
```

### `bashEditDiffEnabled`

Bash コマンドの実行中に Git リポジトリ内で変更されたファイルを Claude Code が記録するかどうかを選択します。記録される場合、コマンドの後にターミナルでその差分が表示され、[PostToolUse Bash フック](https://code.claude.com/docs/ja/hooks.md#bash)は変更されたファイルのリストを受け取ります。

リストに含まれるファイルが、必ずしもそのコマンドによって変更されたものとは限りません。コマンドの実行中に別のプログラムや別の Bash 呼び出しが行った変更も含まれることがあります。

すべての権限モードで記録するには、キーを `true` に設定します。Claude Code v2.1.269 以降が必要です。

* **スコープ**: [`User or managed`](#scopes)。`true` はユーザー設定、`--settings` で渡された JSON、または[管理設定](https://code.claude.com/docs/ja/managed-settings.md)からのものだけが有効になるため、リポジトリの `.claude/settings.json` や `.claude/settings.local.json` にある `true` では記録をオンにできません。ただし、どちらかのリポジトリファイルにある `false` は、[優先順位の高い](https://code.claude.com/docs/ja/settings.md#settings-precedence)ファイルが `true` を設定していない限り、記録をオフにします。
* **型**: Boolean
* **デフォルト**: 未設定。この場合、Claude Code は auto モードと `bypassPermissions` モードで、Bash を通じてファイルを編集するよう Claude に指示したときに変更を記録します
* **セッションごとの上書き**: 1 つのセッションに対して、[`CLAUDE_CODE_BASH_EDIT_DIFF`](https://code.claude.com/docs/ja/env-vars) はこのキーより優先されます

```json settings.json theme={null}
{
  "bashEditDiffEnabled": true
}
```

### `companyAnnouncements`

起動時に組織のお知らせをユーザーに表示します。複数を指定した場合、Claude Code はセッションごとに 1 つをランダムに選びます。ユーザーが初めて起動したときは、最初のエントリを表示します。

* **スコープ**: [`Any file`](#scopes)
* **型**: 文字列の配列
* **デフォルト**: 未設定のため、お知らせは表示されません

```json settings.json theme={null}
{
  "companyAnnouncements": [
    "Welcome to Acme Corp! Review our code guidelines at docs.example.com"
  ]
}
```

### `defaultShell`

入力ボックスで [`!` プレフィックス](https://code.claude.com/docs/ja/interactive-mode#shell-mode-with-prefix)を付けて入力したシェルコマンド、つまり Claude Code が直接実行してセッションに追加するコマンドを、Bash と PowerShell のどちらで実行するかを選択します。

`"powershell"` は [PowerShell ツール](https://code.claude.com/docs/ja/tools-reference.md#powershell-tool)がオンの場合にのみ機能します。このツールは、Git Bash のない Windows ではデフォルトでオンになり、Git Bash のある Windows では claude.ai アカウントと Console アカウントでオンになります。Amazon Bedrock、Google Cloud の Agent Platform、Microsoft Foundry のセッション、および macOS、Linux、WSL では、`CLAUDE_CODE_USE_POWERSHELL_TOOL=1` を設定するとツールがオンになります。この変数を `0` に設定するとツールがオフになります。

* **スコープ**: [`Any file`](#scopes)
* **型**: 文字列。次のいずれか:
  * `"bash"`: Claude Code は `!` コマンドを Bash で実行します
  * `"powershell"`: Claude Code は `!` コマンドを PowerShell で実行します
* **デフォルト**: `"bash"`。Bash が利用できない Windows では `"powershell"`

```json settings.json theme={null}
{
  "defaultShell": "powershell"
}
```

指定したシェルが利用できない場合、Claude Code はもう一方を使用します。PowerShell ツールがオフの場合、`"powershell"` は Bash にフォールバックし、Bash がインストールされていない場合、`"bash"` は PowerShell にフォールバックします。

### `dialogExpiry`

Remote Control や SDK ホストなど、Claude Code が[リモートクライアントに転送する](https://code.claude.com/docs/ja/remote-control.md#limitations)ダイアログ、および[保留中のセッション間メッセージ](https://code.claude.com/docs/ja/cross-session-messaging.md#control-inbound-messages)の承認ダイアログの期限を設定します。Claude Code v2.1.236 以降では、ターミナルに誰もいない可能性のあるセッションにおいて、セッション途中の [Fable 使用クレジットの同意プロンプト](https://code.claude.com/docs/ja/model-config.md#fable-and-usage-credits)にも同じ期限が適用されます。期限までに回答がない場合、Claude Code はダイアログをキャンセルし、何もしないというデフォルトで続行します。Claude Code v2.1.224 以降が必要です。

* **スコープ**: [`User or managed`](#scopes)
* **型**: 文字列。`"60s"`、`"5m"`、`"10m"`、または期限を無効にする `"never"` のいずれか
* **デフォルト**: `"5m"`
* **セッションごとの上書き**: 1 つのセッションに対して、[`CLAUDE_CODE_USER_DIALOG_TIMEOUT_MS`](https://code.claude.com/docs/ja/env-vars) はこのキーより優先されます

```json settings.json theme={null}
{
  "dialogExpiry": "10m"
}
```

権限プロンプトと [`AskUserQuestion`](https://code.claude.com/docs/ja/tools-reference#askuserquestion-tool-behavior) の質問は独自のフローを使用するため、この期限の対象にはなりません。`/config` では **Dialog expiry** として表示され、このキーをユーザー設定に書き込みます。この行には Claude Code v2.1.232 以降が必要で、管理設定または `--settings` フラグがこのキーを設定している間、Claude Code はこの行を非表示にします。

### `editorMode`

入力プロンプトのキーバインドモードを選択します。

* **スコープ**: [`Any file`](#scopes)
* **型**: 文字列。次のいずれか:
  * `"normal"`: プロンプト入力での標準キーバインド
  * `"vim"`: NORMAL、INSERT、VISUAL モードを備えた vim スタイルの編集
* **デフォルト**: `"normal"`

```json settings.json theme={null}
{
  "editorMode": "vim"
}
```

`/config` では **Editor mode** として表示され、このキーをユーザー設定に書き込みます。

### `emojiCompletionEnabled`

プロンプト入力で `:` に続けてショートコードを入力すると絵文字の候補を表示し、`:heart:` のような完成したショートコードを対応する絵文字に置き換えます。両方をオフにするには `false` に設定します。

* **スコープ**: [`Any file`](#scopes)
* **型**: Boolean
  * `true`: Claude Code は `:` の後に絵文字の候補を表示し、完成したショートコードを絵文字に置き換えます
  * `false`: Claude Code は絵文字を候補表示せず、ショートコードも置き換えません
* **デフォルト**: `true`

```json settings.json theme={null}
{
  "emojiCompletionEnabled": false
}
```

[絵文字ショートコード](https://code.claude.com/docs/ja/interactive-mode.md#emoji-shortcodes)を参照してください。

### `fileSuggestion`

組み込みのファイル候補の代わりに独自のコマンドを実行して、`@` によるファイルパスのオートコンプリートを提供します。組み込みの候補は高速なファイルシステム走査を使用しますが、大規模なモノレポでは、事前構築されたファイルインデックスなどのプロジェクト固有のインデックスの方が適している場合があります。

* **スコープ**: [`Any file`](#scopes)。[ステータスラインとファイル候補のゲート](#status-line-and-file-suggestion-gates)のもとでは、Claude Code はコマンドをオフにするか管理設定の値のみを実行し、ユーザーの値は警告なしにスキップします。
* **型**: 常に `"command"` である `type` と、実行するシェルコマンドである `command` を持つオブジェクト
* **デフォルト**: 未設定のため、Claude Code は組み込みのファイル候補を使用します

```json settings.json theme={null}
{
  "fileSuggestion": {
    "type": "command",
    "command": "~/.claude/file-suggestion.sh"
  }
}
```

これを保存した後、プロンプトで `@` に続けてパスの一部を入力すると、候補はコマンドの出力から取得されます。

#### コマンドの入力と出力

Claude Code は、`CLAUDE_PROJECT_DIR` を含め、[フック](https://code.claude.com/docs/ja/hooks.md)と同じ環境変数でコマンドを実行し、5 秒経過すると待機をやめます。コマンドは stdin で JSON を受け取り、その `query` フィールドにはそれまでに入力された内容が入っています:

```json theme={null}
{"query": "src/comp"}
```

改行区切りのファイルパスを stdout に出力します。Claude Code は最大 15 件を表示します:

```text theme={null}
src/components/Button.tsx
src/components/Modal.tsx
src/components/Form.tsx
```

次のスクリプトはクエリを読み取り、リポジトリのファイルインデックスに渡します:

```bash theme={null}
#!/bin/bash
query=$(cat | jq -r '.query')
# Replace your-repo-file-index with your own file search command
your-repo-file-index --query "$query" | head -20
```

### `footerLinksRegexes`

正規表現がターンの出力（ファイルの内容や取得したページを含むツール結果、および Claude 自身の応答）に一致したとき、入力ボックスの下のフッターにクリック可能な追加バッジをレンダリングします。レビューツールや課題トラッカーなど、プロジェクトの CLI が出力する ID をセッション内のリンクに変えるために使用します。

* **スコープ**: [`User or managed`](#scopes)
* **型**: オブジェクトの配列。各オブジェクトは `"regex"` に設定された `type`、正規表現の `pattern`、`url` テンプレート、およびオプションの `label` を持ちます。`url` と `label` 内の `{name}` プレースホルダーは、`pattern` の名前付きキャプチャグループから埋められます
* **デフォルト**: 未設定のため、バッジはレンダリングされません

この例では `PROJ-1234` のような課題キーに一致させ、キャプチャしたキーから各リンクを作成します:

```json settings.json theme={null}
{
  "footerLinksRegexes": [
    {
      "type": "regex",
      "pattern": "\\b(?<key>PROJ-\\d+)\\b",
      "url": "https://issues.example.com/browse/{key}",
      "label": "{key}"
    }
  ]
}
```

これを設定すると、ツール結果や Claude の応答に `PROJ-1234` が現れたとき、`https://issues.example.com/browse/PROJ-1234` にリンクする `PROJ-1234` バッジがフッターに表示されます。

#### バッジの制約

各エントリの URL、ラベル、バッジ数には次の制限があります:

| 制約 | 動作 |
| :- | :- |
| URL のオリジン | キャプチャされた値は URL エンコードされ、作成された URL はテンプレートのリテラルなオリジンと同じでなければなりません。キャプチャはパスセグメントやクエリ値を埋めることはできますが、リンク先を変更することはできません |
| URL の長さ | 2048 文字を超える作成された URL は破棄されます |
| URL スキーム | `https`、`http`、または認識されたエディターやワークスペースのディープリンクスキーム（`vscode`、`vscode-insiders`、`cursor`、`windsurf`、`zed`、`jetbrains`、`idea`、`slack`、`linear`、`notion`、`figma`）である必要があります |
| ラベル | デフォルトは一致したテキストで、表示幅 28 カラムに切り詰められます |
| バッジ数 | レンダリングされるバッジは最大 5 個です。新しい一致によって最も古いものが押し出され、`/clear` で削除されます |

ターンが完了すると、Claude Code はメインスレッドで各エントリの `pattern` 正規表現をターンの出力と照合するため、遅い正規表現は完了するまで UI をブロックします。`(a+)+$` のようなネストした量指定子は、特定の入力に対して指数関数的に時間がかかり、セッションをフリーズさせる可能性があるため、各 `pattern` は線形に保ち、`+` や `*` のネストは避けてください。

[カスタムステータスライン](https://code.claude.com/docs/ja/statusline.md)が設定されている場合、フッターバッジはそれと並んでレンダリングされ、どちらも他方を置き換えることはありません。セッションデータから独自にコンテンツを計算するスクリプト駆動の行にはステータスラインを使用し、スクリプトなしで会話中の ID をリンクに変えるにはフッターバッジを使用します。

### `keybindingFlavor`

> [!WARNING]
>
> v2.1.261 以降は非推奨で、効果はありません。プロンプトの単語編集キーは、Bash と同様に常に [readline の慣例に従います](https://code.claude.com/docs/ja/interactive-mode.md#make-ctrl-w-delete-back-to-whitespace)。Claude Code は引き続き `keybindingFlavor` を受け付けるため、これを設定している設定ファイルは有効なままです。

v2.1.238 から v2.1.260 では、これを `"readline"` に設定すると、`Ctrl+W` は直前の単語だけを削除するのではなく、直前の空白まで戻って削除するようになりました。

* **スコープ**: [`Any file`](#scopes)
* **型**: 文字列。`"classic"` または `"readline"`
* **デフォルト**: 未設定

### `maxProseWidth`

Claude の応答に含まれる文章の幅に上限を設け、幅の広いターミナルでも行を読みやすく保ちます。段落、見出し、リスト、引用ブロックはこのカラム数の範囲内で折り返され、テーブルとコードブロックはターミナルの全幅を維持します。Claude Code v2.1.282 以降が必要です。

* **スコープ**: [`Any file`](#scopes)
* **型**: ターミナルのカラム数。整数で、最小値は `40` です。Claude Code はそれ以外の値を無視します
* **デフォルト**: 未設定のため、文章はターミナルの端で折り返されます

```json settings.json theme={null}
{
  "maxProseWidth": 80
}
```

### `prefersReducedMotion`

スピナー、シマー、フラッシュ効果などのインターフェースのアニメーションを減らすか、オフにします。`/config` では **Reduce motion** として表示されます。

* **スコープ**: [`Any file`](#scopes)
* **型**: Boolean
  * `true`: Claude Code はスピナー、シマー、フラッシュ効果などのインターフェースのアニメーションを減らすか、オフにします
  * `false`: 未設定と同じです。Claude Code はアニメーションを表示します
* **デフォルト**: `false`

```json settings.json theme={null}
{
  "prefersReducedMotion": true
}
```

### `promptSuggestionEnabled`

プロンプト入力に表示されるグレーアウトされた予測である[プロンプト候補](https://code.claude.com/docs/ja/interactive-mode.md#prompt-suggestions)の表示・非表示を切り替えます。非表示にするには、`false` に設定するか、`/config` で **Prompt suggestions** をオフにします。

* **スコープ**: [`Any file`](#scopes)
* **型**: Boolean
  * `true`: プロンプト入力にプロンプト候補が表示されます
  * `false`: Claude Code はプロンプト候補を非表示にします
* **デフォルト**: `true`
* **セッションごとの上書き**: 1 つのセッションに対して、[`CLAUDE_CODE_ENABLE_PROMPT_SUGGESTION`](https://code.claude.com/docs/ja/env-vars) はこのキーより優先されます

```json settings.json theme={null}
{
  "promptSuggestionEnabled": false
}
```

プロンプト候補には、テレメトリがオンになっている claude.ai アカウントまたは Console アカウントが必要です。Amazon Bedrock、Google Cloud の Agent Platform、Microsoft Foundry を使用している場合や、[`DISABLE_TELEMETRY`](https://code.claude.com/docs/ja/env-vars) などでテレメトリがオフになっている場合、このキーは効果がなく、`CLAUDE_CODE_ENABLE_PROMPT_SUGGESTION=1` のみがプロンプト候補をオンにします。

### `respectGitignore`

`@` ファイルピッカーが `.gitignore` のパターンに一致するファイルを除外するかどうかを制御します。`/config` では **Respect .gitignore in file picker** として表示されます。

* **スコープ**: [`Any file`](#scopes)。どの設定ファイルもこれを設定していない場合、Claude Code は `/config` のトグルが書き込む `~/.claude.json` の `respectGitignore` にフォールバックします。
* **型**: Boolean
  * `true`: `@` ファイルピッカーは `.gitignore` のパターンに一致するファイルを除外します
  * `false`: `@` ファイルピッカーは `.gitignore` のパターンに一致するファイルを含めます
* **デフォルト**: `true`

```json settings.json theme={null}
{
  "respectGitignore": false
}
```

### `respondToBashCommands`

入力ボックスで [`!` プレフィックス](https://code.claude.com/docs/ja/interactive-mode#shell-mode-with-prefix)を付けてシェルコマンドを実行した後に Claude が応答するかどうかを選択します。デフォルトでは、Claude Code はコマンドの出力を会話に追加し、Claude がそれに応答します。このキーを `false` に設定すると、応答なしで出力がコンテキストに追加されるため、複数のコマンドを実行してからまとめて質問できます。

* **スコープ**: [`Any file`](#scopes)
* **型**: Boolean
  * `true`: Claude Code はコマンドの出力を会話に追加し、Claude がそれに応答します
  * `false`: Claude Code は応答なしで出力をコンテキストに追加します
* **デフォルト**: `true`

```json settings.json theme={null}
{
  "respondToBashCommands": false
}
```

[`!` プレフィックスによるシェルモード](https://code.claude.com/docs/ja/interactive-mode#shell-mode-with-prefix)を参照してください。

### `showClearContextOnPlanAccept`

[plan モード](https://code.claude.com/docs/ja/permission-modes.md#review-and-approve-a-plan)で Claude がプランを完成させると、承認メニューが表示されます。プランの作成には多くのコンテキストを使用することがあるため、このキーはそのメニューに最初のオプションとして **Yes, clear context and …** を追加します。このオプションはプランを承認し、会話のコンテキストをクリアして、プランのみから実装を開始します。ラベルの残りの部分には、セッションが継続する権限モードの名前と、プランの作成に使用したコンテキストの量が表示されます。

* **スコープ**: [`Any file`](#scopes)
* **型**: Boolean
  * `true`: プラン承認メニューに、プランを承認して会話のコンテキストをクリアする最初のオプション **Yes, clear context and …** が追加されます
  * `false`: プラン承認メニューにコンテキストをクリアするオプションは表示されません
* **デフォルト**: `false`

```json settings.json theme={null}
{
  "showClearContextOnPlanAccept": true
}
```

### `showTurnDuration`

各応答の後に表示される「Cooked for 1m 6s · done 6:05 PM」のようなターン所要時間メッセージの表示・非表示を切り替えます。「done」の後の時刻はターンが終了した時刻を示し、[`timeFormat`](#timeformat) と [`timeZone`](#timezone) がその形式とタイムゾーンを制御します。`/config` では **Show turn duration** として表示されます。

* **スコープ**: [`Any file`](#scopes)。どの設定ファイルもこれを設定していない場合、古いバージョンの `~/.claude.json` にある値が適用されます。
* **型**: Boolean
  * `true`: 各応答の後にターン所要時間メッセージが表示されます
  * `false`: Claude Code はターン所要時間メッセージを非表示にします
* **デフォルト**: `true`

```json settings.json theme={null}
{
  "showTurnDuration": false
}
```

### `spellcheck`

インストールしたスペルチェッカーを使用して、入力中にプロンプト入力内のスペルミスに下線を引きます。Claude Code は入力ボックス内のテキストのみをチェックします。aspell、hunspell、ispell のインストール方法とチェッカーの対象範囲については、[入力中のスペルチェック](https://code.claude.com/docs/ja/interactive-mode.md#check-spelling-as-you-type)で説明しています。Claude Code v2.1.235 以降が必要です。

* **スコープ**: [`User or managed`](#scopes)。これを設定している最上位の階層のブロックが全体として適用されます。
* **型**: `enabled`（Boolean）、`checker`（`"aspell"`、`"hunspell"`、`"ispell"`、または `"auto"`）、`language`（文字列。辞書名としてチェッカーに渡されます）、`color`（文字列。ターミナルのカラー名、`#rrggbb`、`rgb(r,g,b)`、`ansi256(n)`、または `ansi:<name>`）を持つオブジェクト
* **デフォルト**: 未設定のため、スペルチェックはオフです。`checker` のデフォルトは `"auto"` で、`PATH` 上で最初に見つかった 3 つのうちのいずれかです。`language` のデフォルトはチェッカー自身の辞書です。`color` のデフォルトはテーマのエラーカラーです

```json settings.json theme={null}
{
  "spellcheck": { "enabled": true, "language": "en_GB" }
}
```

### `spinnerTipsEnabled`

Claude が作業している間、スピナーの行には「Use Plan Mode to prepare for a complex request before making changes. Press Shift+Tab twice to enable.」のような Claude Code の機能に関する短いヒントが順番に表示されます。非表示にするには、このキーを `false` に設定します。`/config` では **Show tips** として表示されます。

* **スコープ**: [`Any file`](#scopes)
* **型**: Boolean
  * `true`: Claude の作業中にスピナーにヒントが表示されます
  * `false`: Claude Code はスピナーのヒントを非表示にします
* **デフォルト**: `true`

```json settings.json theme={null}
{
  "spinnerTipsEnabled": false
}
```

### `spinnerTipsOverride`

Claude の作業中に Claude Code が表示する[スピナーのヒント](#spinnertipsenabled)に独自のヒントを追加するか、組み込みのヒントを独自のものに置き換えます。Claude Code は独自のヒントを組み込みのヒントと同じローテーションに入れます。

[`spinnerTipsEnabled`](#spinnertipsenabled) を `false` に設定すると、Claude Code は独自のものを含むすべてのヒントを非表示にします。

* **スコープ**: [`Any file`](#scopes)。Claude Code は、ユーザー設定、`--settings` フラグ、管理設定からのヒントオブジェクト、`tipsFile`、`label`、`excludeDefault` を受け付けます。プロジェクト設定とローカル設定からはプレーンな文字列のヒントのみを読み取ります。
* **型**: `tips`、`tipsFile`、`label`、`excludeDefault` フィールドを持つオブジェクト。各フィールドはオプションです
* **デフォルト**: 未設定のため、Claude Code は組み込みのヒントのみを表示します

ヒントオブジェクト、`tipsFile`、`label`、およびプロジェクト設定とローカル設定はプレーンな文字列のみを提供するというスコープ行のルールには、Claude Code v2.1.247 以降が必要です。

各 `tips` エントリは、プレーンな文字列か、次のフィールドを持つオブジェクトです:

| フィールド | 必須 | 説明 |
| :- | :- | :- |
| `id` | はい | 英字、数字、`.`、`_`、`-` で最大 64 文字。Claude Code はこれをキーとしてヒントの表示履歴を管理するため、リストを並べ替えてもヒントのクールダウンは維持されます。同じ id を持つ 2 つのエントリがある場合、Claude Code は最初のものを使用します |
| `text` | はい | ヒント本文。最大 500 文字の 1 行です。Claude Code は ANSI エスケープと制御文字を取り除き、空白を 1 つにまとめます |
| `cooldownSessions` | いいえ | Claude Code がヒントを再び表示するまでに待つセッション数。`0` から `1000`、デフォルトは `0` |
| `priority` | いいえ | 未表示の期間が同じヒント間での順序。高いものが先で、`-10` から `10`、デフォルトは `0` |

Claude Code はプレーンな文字列を、これらのデフォルト値と位置に基づく id を持つヒントとして読み取るため、リストを並べ替えるとその表示履歴はリセットされます。編集しても履歴を維持するには、ヒントに `id` を付けてください。

Claude Code は `tips` と `tipsFile` を合わせて最大 200 個のヒントを読み取り、無効なエントリは設定ファイルを拒否するのではなく、デバッグ警告を出して破棄します。

残りのフィールドを使用して、ヒントファイルの指定、プレフィックスの設定、組み込みヒントの非表示を行います:

* `tipsFile`: 同じエントリの配列、または `tips` 配列を持つオブジェクトを含むローカル JSON ファイルへの絶対パスまたは `~/` パス。最大 256 KB です。Claude Code はプロセスごとに 1 回ファイルを読み取るため、編集内容は次回の起動時に読み込まれます。[サーバー管理設定](https://code.claude.com/docs/ja/server-managed-settings.md)では設定できません。そこではインラインの `tips` をデプロイするか、ディスク上の `managed-settings.json` にパスをデプロイしてください。
* `label`: ユーザー設定、`--settings`、管理設定からのヒントの前に Claude Code が表示するプレフィックス。最大 40 文字です。デフォルトは組み込みヒントと同じプレフィックスである `Tip` で、プロジェクト設定とローカル設定からのヒントは常にこれを使用します。
* `excludeDefault`: 組み込みヒントを非表示にして独自のヒントのみを表示するには、`true` に設定します。`tipsFile` が存在しない、またはすべてのエントリが無効であるなどの理由で Claude Code が独自のヒントを 1 つも読み込めない場合は、スピナーを空にするのではなく、組み込みのローテーションを維持します。

複数の設定ファイルがこのキーを設定している場合、Claude Code はそれらすべてのヒントを表示し、`tipsFile`、`label`、`excludeDefault` については、管理設定、`--settings` フラグ、ユーザー設定のうち、それぞれを設定している最も優先順位の高いものから取得します。

ユーザー設定に記述したこの例では、プレーンな文字列のヒントとオブジェクトのヒントを `Acme tip` プレフィックスでローテーションに追加します:

```json settings.json theme={null}
{
  "spinnerTipsOverride": {
    "label": "Acme tip",
    "tips": [
      "Run /review before opening a PR",
      {
        "id": "gateway-errors",
        "text": "Seeing 5xx errors? Check the gateway status page first",
        "cooldownSessions": 5,
        "priority": 2
      }
    ]
  }
}
```

例の各フィールドは、Claude Code によるヒントの表示方法をそれぞれ 1 点ずつ変更します:

* `label`: Claude Code は両方のヒントを `Tip: ...` ではなく `Acme tip: ...` として表示します。
* プレーンな文字列: Claude Code はデフォルト値を与えるため、すぐ次のセッションで再び表示されることがあります。
* `id`: Claude Code は 2 つ目のヒントの表示履歴を `gateway-errors` をキーとして管理するため、ヒントを追加したり並べ替えたりしてもクールダウンは引き続き適用されます。
* `cooldownSessions`: Claude Code は `gateway-errors` ヒントを表示した後、5 セッション後まで再び表示しません。
* `priority`: `gateway-errors` ヒントと別のヒントが同じセッション数だけ未表示である場合（たとえばどちらもまだ表示されていない場合）、Claude Code は `gateway-errors` を先に表示します。プレーンな文字列はデフォルトの優先度 `0` を持ちます。

Claude の作業中、Claude Code は `Acme tip: Run /review before opening a PR` のように、独自のプレフィックス付きでヒントをスピナーに表示します。

### `spinnerVerbs`

ターンの進行中、スピナーには「Accomplishing」「Architecting」「Baking」などの動詞が順番に表示されます。このキーを使用して、そのローテーションに独自の動詞を追加するか、組み込みのリストを独自のものに置き換えます。

* **スコープ**: [`Any file`](#scopes)
* **型**: 文字列の `verbs` 配列と `mode` を持つオブジェクト。`mode` は次のいずれか:
  * `"append"`: Claude Code は独自の動詞を組み込みのセットに追加します
  * `"replace"`: Claude Code は独自の動詞のみを表示します
* **デフォルト**: 未設定のため、Claude Code は組み込みの動詞を使用します

この例では、組み込みのセットに 2 つの動詞を追加します:

```json settings.json theme={null}
{
  "spinnerVerbs": {
    "mode": "append",
    "verbs": ["Pondering", "Crafting"]
  }
}
```

`"replace"` モードで `verbs` 配列が空の場合、Claude Code は組み込みの動詞を維持します。

### `statusLine`

独自のコマンドを実行して、モデル、コスト、git ブランチなどのコンテキストを含む[ステータスライン](https://code.claude.com/docs/ja/statusline.md)をプロンプトの下にレンダリングします。オプションのフィールドで、間隔の調整、定期的な再実行の追加、スクリプト自身が `vim.mode` をレンダリングする場合の組み込み vim モードインジケーターの非表示を行えます。

* **スコープ**: [`Any file`](#scopes)。[`allowManagedHooksOnly`](#allowmanagedhooksonly) がオンの場合、または管理設定以外で [`disableAllHooks`](#disableallhooks) が設定されている場合は、管理設定の値のみが実行されます。
* **型**: `"command"` に設定された `type` と `command` 文字列、およびオプションで文字数を表す数値の `padding`、秒数を表す数値（最小 `1`）の `refreshInterval`、Boolean の `hideVimModeIndicator` を持つオブジェクト
* **デフォルト**: 未設定のため、ステータスラインはありません

この例では、モデル名とコンテキスト使用量を出力し、水平方向に 2 文字分の間隔を追加します:

```json settings.json theme={null}
{
  "statusLine": {
    "type": "command",
    "command": "jq -r '\"[\\(.model.display_name)] \\(.context_window.used_percentage // 0)% context\"'",
    "padding": 2
  }
}
```

この例には [`jq`](https://jqlang.org/) のインストールが必要で、シェルで実行されます。PowerShell と Git Bash での同等の設定については、[Windows での設定](https://code.claude.com/docs/ja/statusline.md#windows-configuration)を参照してください。セットアップ全体については、[ステータスラインを手動で設定する](https://code.claude.com/docs/ja/statusline.md#manually-configure-a-status-line)を参照してください。

### `subagentStatusLine`

Claude が[サブエージェント](https://code.claude.com/docs/ja/sub-agents.md)を実行すると、Claude Code はプロンプトの下のタスク表示にそれらを一覧表示し、サブエージェントごとに `name · description · token count` を示す行を 1 つずつ表示します。このキーを使用すると、独自のコマンドを実行してそれらの行を書き換えることができます。たとえば、各サブエージェントのコンテキスト使用量をパーセンテージで表示できます。更新のたびに、Claude Code は表示中の行を 1 つの JSON オブジェクトとして stdin に送信します。このオブジェクトの `tasks` 配列には、各サブエージェントの `id`、`name`、`status`、`model`、`tokenCount` などが含まれます。Claude Code は、`{"id", "content"}` 行として書き戻した各 `id` の行を置き換えます。書き戻さなかった行はデフォルトのレンダリングのままです。

* **スコープ**: [`Any file`](#scopes)。[`allowManagedHooksOnly`](#allowmanagedhooksonly) がオンの場合、または管理設定以外で [`disableAllHooks`](#disableallhooks) が設定されている場合は、管理設定の値のみが実行されます。
* **型**: `"command"` に設定された `type` と `command` 文字列を持つオブジェクト
* **デフォルト**: 未設定のため、Claude Code はデフォルトの行をレンダリングします

```json settings.json theme={null}
{
  "subagentStatusLine": {
    "type": "command",
    "command": "jq -c '.tasks[] | {id, content: \"\\(.name): \\(.tokenCount) tokens\"}'"
  }
}
```

[サブエージェントのステータスライン](https://code.claude.com/docs/ja/statusline.md#subagent-status-lines)を参照してください。

### `syntaxHighlightingDisabled`

Claude Code は、ターミナルに表示する差分、コードブロック、ファイルプレビューのコードを、組み込みのハイライターで言語ごとに色分けします。プラグインや言語サーバーは関与しません。代わりにプレーンテキストとして表示するには、このキーを `true` に設定します。たとえば、色がターミナルのテーマと合わない場合や、スクリーンリーダーの動作が遅くなる場合に使用します。

* **スコープ**: [`Any file`](#scopes)
* **型**: Boolean
  * `true`: Claude Code は差分、コードブロック、ファイルプレビューのシンタックスハイライトをオフにします
  * `false`: Claude Code はシンタックスハイライトを行います
* **デフォルト**: `false`

```json settings.json theme={null}
{
  "syntaxHighlightingDisabled": true
}
```

### `terminalProgressBarEnabled`

一部のターミナルでは、内部で実行中のプログラムについて、タブやタスクバーに進行状況インジケーターを表示できます。Claude が作業している間、Claude Code は進行中の状態をターミナルに報告するため、別のタブやウィンドウからセッションがまだ処理中かどうかを確認できます。インジケーターは、ターンの終了後も[バックグラウンドサブエージェント](https://code.claude.com/docs/ja/sub-agents.md#run-subagents-in-foreground-or-background)や[動的ワークフロー](https://code.claude.com/docs/ja/workflows.md)がまだ実行中であれば表示されたままになり、セッションがアイドル状態になると消えます。

Claude Code は、インジケーターをサポートするターミナル（ConEmu、Ghostty 1.2.0 以降、iTerm2 3.6.6 以降）でのみこれを報告します。Claude Code による報告を停止するには、このキーを `false` に設定します。`/config` では **Terminal progress bar** として表示されます。

* **スコープ**: [`Any file`](#scopes)。どの設定ファイルもこれを設定していない場合、古いバージョンの `~/.claude.json` にある値が適用されます。
* **型**: Boolean
  * `true`: サポートしているターミナルでターミナルのプログレスバーが表示されます
  * `false`: Claude Code はターミナルのプログレスバーを非表示にします
* **デフォルト**: `true`

```json settings.json theme={null}
{
  "terminalProgressBarEnabled": false
}
```

### `terminalTitleFromRename`

Claude Code はターミナルタブのタイトルを設定します。デフォルトでは会話から生成したタイトルを使用し、`/rename` または `--name` でセッションに[名前](https://code.claude.com/docs/ja/sessions.md#name-your-sessions)を付けると、タブには代わりにその名前が表示されます。セッションに名前を付けた後も生成されたタイトルをタブに残すには、このキーを `false` に設定します。名前自体は引き続き適用されるため、`/resume <name>` やセッションピッカーで見つけられます。

* **スコープ**: [`Any file`](#scopes)
* **型**: Boolean
  * `true`: ターミナルタブのタイトルに、設定したセッション名が表示されます
  * `false`: タブには Claude Code が会話から生成したタイトルが残ります
* **デフォルト**: `true`

```json settings.json theme={null}
{
  "terminalTitleFromRename": false
}
```

Claude Code によるターミナルタイトルの更新を完全に停止するには、代わりに [`CLAUDE_CODE_DISABLE_TERMINAL_TITLE`](https://code.claude.com/docs/ja/env-vars) を `1` に設定します。

### `theme`

インターフェースのカラーテーマを選択します。`/config` では **Theme** として表示されます。

* **スコープ**: [`Any file`](#scopes)。どの設定ファイルもこれを設定していない場合、古いバージョンの `~/.claude.json` にある値が適用されます。
* **型**: 文字列。次のいずれか:
  * `"auto"`: ターミナルの明るい背景または暗い背景に合わせます
  * `"dark"`: ダークテーマ
  * `"light"`: ライトテーマ
  * `"dark-daltonized"`: 色覚多様性に配慮した色を使用するダークテーマ
  * `"light-daltonized"`: 色覚多様性に配慮した色を使用するライトテーマ
  * `"dark-ansi"`: ターミナルの ANSI カラーパレットのみを使用するダークテーマ
  * `"light-ansi"`: ターミナルの ANSI カラーパレットのみを使用するライトテーマ
  * `"custom:<slug>"` または `"custom:<plugin-name>:<slug>"`: `~/.claude/themes/` またはプラグインのカスタムテーマ
* **デフォルト**: `"dark"`

```json settings.json theme={null}
{
  "theme": "light-daltonized"
}
```

[カスタムテーマを作成する](https://code.claude.com/docs/ja/terminal-config.md#create-a-custom-theme)を参照してください。

### `timeFormat`

各ターン所要時間メッセージの末尾にある `done 6:05 PM` や[トランスクリプトビューアー](https://code.claude.com/docs/ja/interactive-mode.md#transcript-viewer)のタイムスタンプなど、Claude Code がインターフェースに表示する時刻の書式を選択します。プリセットを選ぶには、`/config` を実行して **Time format** を設定します。Claude Code v2.1.257 以降が必要です。

* **スコープ**: [`Any file`](#scopes)
* **型**: 文字列。次のいずれか:
  * `"auto"`: 未設定と同じです。各時刻は組み込みの書式を維持し、ターン所要時間メッセージではロケールに従います
  * `"12-hour"`: 12 時間制
  * `"24-hour"`: 24 時間制
  * `"24-hour-utc"`: `18:05Z` のように分の後に `Z` を付けた UTC の 24 時間制。このプリセットでは Claude Code は [`timeZone`](#timezone) を無視します
  * `"%H:%M"` のような strftime パターン: Claude Code は各時刻をそのパターンで書き出します。`%` を含む値はすべてパターンとして扱われ、プリセット以外のその他の値は `"auto"` として扱われます
* **デフォルト**: `"auto"`

```json settings.json theme={null}
{
  "timeFormat": "24-hour"
}
```

`/config` ではプリセットのみが提供されるため、strftime パターンを使用するには、設定ファイルにキーを追加します。この例では、各時刻を 2 桁の 24 時間制で表示します:

```json settings.json theme={null}
{
  "timeFormat": "%H:%M"
}
```

すると、ターン所要時間メッセージとトランスクリプトビューアーには `18:05` のような時刻が表示されます。トランスクリプトビューアーではパターンがタイムスタンプ全体になるため、日付を表示したい場合は日付のディレクティブを追加します。この例では、時刻の前に日付を置きます:

```json settings.json theme={null}
{
  "timeFormat": "%Y-%m-%d %H:%M"
}
```

すると、同じ箇所に `2026-09-01 18:05` のような時刻が表示されます。

### `timeZone`

インターフェースの時刻を、システムとは異なるタイムゾーンで表示します。`"UTC"` や `"Europe/Dublin"` のような [IANA タイムゾーン名](https://www.iana.org/time-zones)を設定します。すると、[`timeFormat`](#timeformat) が制御する時刻がこのタイムゾーンで表示されます。`timeFormat` が `"24-hour-utc"` の場合、時刻は UTC のままで、Claude Code はこのキーを無視します。`/config` にはこのキーの行がないため、設定ファイルで設定してください。Claude Code v2.1.257 以降が必要です。

* **スコープ**: [`Any file`](#scopes)
* **型**: 文字列。IANA タイムゾーン名です。Claude Code が名前を認識できない場合は、システムのタイムゾーンを使用します
* **デフォルト**: 未設定のため、時刻はシステムのタイムゾーンで表示されます

```json settings.json theme={null}
{
  "timeZone": "Europe/Dublin"
}
```

### `tui`

ターミナル UI のレンダラーを選択します。仮想化されたスクロールバックを備えたちらつきのない[代替画面レンダラー](https://code.claude.com/docs/ja/fullscreen.md)には `"fullscreen"` を、クラシックなメイン画面レンダラーには `"default"` を使用します。`/tui fullscreen` または `/tui default` を実行すると、このキーが自動的に書き込まれます。

* **スコープ**: [`Any file`](#scopes)
* **型**: 文字列。次のいずれか:
  * `"default"`: クラシックなメイン画面レンダラー
  * `"fullscreen"`: 仮想化されたスクロールバックを備えた、ちらつきのない代替画面レンダラー
* **デフォルト**: 未設定のため、Claude Code が[レンダラーを選択します](https://code.claude.com/docs/ja/fullscreen.md#fullscreen-by-default)
* **セッションごとの上書き**: 1 つのセッションに対して、[`CLAUDE_CODE_NO_FLICKER`](https://code.claude.com/docs/ja/env-vars) と [`CLAUDE_CODE_DISABLE_ALTERNATE_SCREEN`](https://code.claude.com/docs/ja/env-vars) はこのキーより優先されます。`CLAUDE_CODE_NO_FLICKER=1` はフルスクリーンをオンにし、`CLAUDE_CODE_NO_FLICKER=0` または `CLAUDE_CODE_DISABLE_ALTERNATE_SCREEN=1` はオフにします。両方が設定されている場合、Claude Code はオフにします

```json settings.json theme={null}
{
  "tui": "fullscreen"
}
```

tmux `-CC` 環境下や、Windows への SSH 接続時には、`CLAUDE_CODE_NO_FLICKER=1` を設定しない限り、Claude Code はクラシックレンダラーを維持します。[エージェントビュー](https://code.claude.com/docs/ja/agent-view.md)から開いたバックグラウンドセッションは、この設定にかかわらず常にフルスクリーンレンダラーを使用します。

### `verbose`

デフォルトでは、トランスクリプトは各ツール呼び出しを、Claude が実行したコマンドやその出力の行数などの短い概要に折りたたみます。詳細を見たいときは `Ctrl+O` を押すと、トランスクリプト全体が展開表示に切り替わります。このキーを `true` に設定すると、すべてのツール呼び出しの完全な入力と出力が発生と同時にインラインで表示されます。これは、フック、MCP サーバー、または長いシェルコマンドをデバッグするときに便利です。`/config` では **Verbose output** として表示されます。

* **スコープ**: [`Any file`](#scopes)。どの設定ファイルもこれを設定していない場合、古いバージョンの `~/.claude.json` にある値が適用されます。
* **型**: Boolean
  * `true`: ツールの完全な出力が表示されます
  * `false`: ツール出力の切り詰められた概要が表示されます
* **デフォルト**: `false`
* **セッションごとの上書き**: 1 つのセッションに対して、[`--verbose`](https://code.claude.com/docs/ja/cli-reference#cli-flags) はこのキーより優先されます

```json settings.json theme={null}
{
  "verbose": true
}
```

[`viewMode`](#viewmode) の値、または保持された `/focus` の選択は、すべてのセッションでこのキーを上書きします。

### `viewMode`

Claude Code が起動時に使用するトランスクリプトビューを `"default"`、`"verbose"`、`"focus"` のいずれかに設定します。設定すると、保持された `/focus` の選択と [`verbose`](#verbose) 設定の両方を上書きします。

* **スコープ**: [`Any file`](#scopes)
* **型**: 文字列。次のいずれか:
  * `"default"`: ツール出力が切り詰められた通常のトランスクリプト
  * `"verbose"`: ツールの完全な出力を含むトランスクリプト
  * `"focus"`: 最後のプロンプト、編集の diffstat を含むツール呼び出しの 1 行の概要、および最終的な応答のみ。フォーカスビューには[フルスクリーンレンダラー](#tui)が必要です
* **デフォルト**: 未設定のため、`verbose` 設定と最後の `/focus` の選択が適用されます
* **セッションごとの上書き**: 1 つのセッションに対して、[`--verbose`](https://code.claude.com/docs/ja/cli-reference#cli-flags) はこのキーより優先されます

```json settings.json theme={null}
{
  "viewMode": "focus"
}
```

### `vimInsertModeRemaps`

[vim エディターモード](https://code.claude.com/docs/ja/interactive-mode.md#vim-editor-mode)で、2 キーの INSERT モードのシーケンスを Escape にマッピングします。各キーは順に入力されるちょうど 2 つの印字可能文字で、サポートされるターゲットは `"<Esc>"` のみです。Claude Code はその他のエントリを無視します。

* **スコープ**: [`User or managed`](#scopes)。リポジトリがユーザーのキー入力を再マッピングすることはできません。
* **型**: 2 文字のシーケンスを `"<Esc>"` にマッピングするオブジェクト
* **デフォルト**: 未設定

```json settings.json theme={null}
{
  "vimInsertModeRemaps": {
    "jj": "<Esc>"
  }
}
```

`editorMode` が `"vim"` でない限り、効果はありません。[INSERT モードのキーシーケンスを再マッピングする](https://code.claude.com/docs/ja/interactive-mode.md#remap-insert-mode-key-sequences)を参照してください。

### `voice`

[音声入力](https://code.claude.com/docs/ja/voice-dictation.md)をオンにし、音声入力キーの動作を選択します。`/voice` を実行すると、Claude Code がこのオブジェクトを自動的に書き込みます。

* **スコープ**: [`Any file`](#scopes)
* **型**: Boolean の `enabled`、ホールドモードでのみ適用される Boolean の `autoSubmit`、および `mode` を持つオブジェクト。`mode` は次のいずれか:
  * `"hold"`: 話している間は音声入力キーを押し続け、離すと停止します
  * `"tap"`: キーを 1 回タップすると録音を開始し、もう一度タップすると送信します
* **デフォルト**: 未設定のため、音声入力はオフです。`enabled` が `true` で `mode` が未設定の場合、Claude Code は `"hold"` を使用します

この例では、音声入力をオンにし、キーを 1 回タップすると録音を開始し、もう一度タップすると送信するようにします:

```json settings.json theme={null}
{
  "voice": {
    "enabled": true,
    "mode": "tap"
  }
}
```

`autoSubmit` は、ホールドモードでキーを離したときにプロンプトを送信します。音声入力には claude.ai アカウントが必要です。

### `voiceEnabled`

> [!WARNING]
>
> v2.1.92 で [`voice`](#voice) オブジェクトに置き換えられて以降、非推奨です。古い設定ファイルが引き続き機能するよう Claude Code はこれを読み取りますが、新しい設定では `voice.enabled` を設定してください。

`voice` オブジェクトより前からある単一の Boolean 形式で、音声入力をオンにします。両方が設定されている場合は、`voice.enabled` が適用されます。

* **スコープ**: [`Any file`](#scopes)
* **型**: Boolean
  * `true`: `voice.enabled` が設定されていない限り、claude.ai アカウントでログインしていて組織のポリシーが音声を許可している場合に、音声入力がオンになります
  * `false`: `voice.enabled` が設定されていない限り、音声入力はオフです
* **デフォルト**: 未設定

```json settings.json theme={null}
{
  "voiceEnabled": true
}
```

### `wheelScrollAccelerationEnabled`

[フルスクリーンレンダリング](https://code.claude.com/docs/ja/fullscreen.md#mouse-wheel-scrolling)で、高速スクロール時にマウスホイールのスクロール速度を加速します。ホイールのノッチごとに一定のスクロール量にするには、`false` に設定します。

* **スコープ**: [`Any file`](#scopes)
* **型**: Boolean
  * `true`: Claude Code は高速スクロール時にマウスホイールのスクロール速度を加速します
  * `false`: Claude Code はホイールのノッチごとに一定の量でスクロールします
* **デフォルト**: `true`

```json settings.json theme={null}
{
  "wheelScrollAccelerationEnabled": false
}
```

## Git とアトリビューション

Claude Code がコミットとプルリクエストに追加するアトリビューションを制御し、git との連携方法を設定します。

### `attribution`

Claude Code が git コミットとプルリクエストに追加するアトリビューションをカスタマイズします。コミットはデフォルトで `Co-Authored-By` などの [git トレーラー](https://git-scm.com/docs/git-interpret-trailers) を取得します。プルリクエストの説明はプレーンテキストを取得します。以下のサブキーを使用して各部分を個別に設定します。

* **スコープ**: [`Any file`](#scopes)
* **タイプ**: `commit` と `pr` 文字列および `sessionUrl` ブール値を含むオブジェクト、または全てのアトリビューションを非表示にする `false`。`false` 値には Claude Code v2.1.281 以降が必要です。それより前のバージョンはこれを拒否し、[それを含むユーザー、プロジェクト、またはローカル設定ファイル全体をスキップします](https://code.claude.com/docs/ja/settings.md#fix-a-broken-settings-file)
* **デフォルト**: 未設定。Claude Code は各サブキーの下に表示される標準アトリビューションを使用します

全てのアトリビューションを非表示にするには、`attribution` を `false` に設定します。それより前のバージョンも読み込む設定ファイルでは、[`commit`](#attribution-commit) と [`pr`](#attribution-pr) を空の文字列に設定し、[`sessionUrl`](#attribution-sessionurl) を `false` に設定してください。

この例はコミットアトリビューションを置き換え、プルリクエストアトリビューションを削除し、セッションリンクを削除します。

```json settings.json theme={null}
{
  "attribution": {
    "commit": "Generated with AI\n\nCo-Authored-By: AI <ai@example.com>",
    "pr": "",
    "sessionUrl": false
  }
}
```

`commit` または `pr` を設定すると、Claude Code は非推奨の `includeCoAuthoredBy` 設定を無視し、設定しなかった方のデフォルトテキストを使用します。

Claude Code は、CLAUDE.md または [memory](https://code.claude.com/docs/ja/memory.md) ルールなど、アトリビューションに関するカスタマー独自の命令が、[managed settings](https://code.claude.com/docs/ja/managed-settings.md) で設定されている場合を除き、これらのコミットおよび PR 行より優先されることを Claude に伝えます。

### `includeCoAuthoredBy`

> [!WARNING]
>
> v2.0.62 以降非推奨。[`attribution`](#attribution) に置き換えられました。Claude Code はまだこれを読み込みますが、新しい設定は `attribution` を設定する必要があります。

このキーを置き換える [`attribution`](#attribution) を代わりに使用してください。これにより、コミットトレーラー、プルリクエストテキスト、セッションリンクを個別に変更または非表示にできます。Claude Code は `attribution` より前の設定ファイルからの `includeCoAuthoredBy: false` を引き続き尊重しますが、`attribution.commit` または `attribution.pr` を設定すると無視します。

* **スコープ**: [`Any file`](#scopes)
* **タイプ**: ブール値
  * `true`: 未設定と同じ。Claude Code はコミットトレーラーとプルリクエストアトリビューションテキストを追加します
  * `false`: Claude Code はコミットトレーラーとプルリクエストアトリビューションテキストの両方を省略します。ただし、`attribution` が `commit` または `pr` を設定する場合は、[`attribution`](#attribution) ルールが適用されます
* **デフォルト**: `true`

```json settings.json theme={null}
{
  "includeCoAuthoredBy": false
}
```

全てのアトリビューションを非表示にするには、[`attribution`](#attribution) を参照してください。

### `includeGitInstructions`

Claude Code は git 関連の 2 つの部分をコンテキストとして Claude に提供します。Bash ツールの説明にあるコミットとプルリクエストの書き方に関する組み込み命令と、リポジトリの git ステータススナップショット（現在のブランチ、メインブランチ、`git status` 出力、最近のコミット）です。Claude Code はコンバーセーション開始時にスナップショットを読み込みます。

このキーを `false` に設定して両方を除外します。例えば、独自の git ワークフロースキルを使用する場合などです。

* **スコープ**: [`Any file`](#scopes)
* **タイプ**: ブール値
  * `true`: Claude Code は組み込みのコミットおよびプルリクエストワークフロー命令と git ステータススナップショットを含めます。クラウドセッションはスナップショットを含めません
  * `false`: Claude Code は両方を除外します
* **デフォルト**: `true`
* **セッションごとのオーバーライド**: [`CLAUDE_CODE_DISABLE_GIT_INSTRUCTIONS`](https://code.claude.com/docs/ja/env-vars) はこのキーより優先されます（1 セッション）

```json settings.json theme={null}
{
  "includeGitInstructions": false
}
```

[非対話モード](https://code.claude.com/docs/ja/headless.md) または Agent SDK でシステムプロンプトを置き換えると、このキーが `true` の場合でも、セッションはスナップショットなしで開始されます。

* **`-p` 実行**: [`--system-prompt`](https://code.claude.com/docs/ja/cli-reference#system-prompt-flags) または `--system-prompt-file` を渡すと、プロンプトが置き換えられます。[`--agent`](https://code.claude.com/docs/ja/sub-agents#invoke-subagents-explicitly) または [`agent`](#agent) 設定で選択した、独自のプロンプトを持つカスタムエージェントを実行した場合も、プロンプトが置き換えられます。[bare モード](https://code.claude.com/docs/ja/headless.md#start-faster-with-bare-mode) 以外でスナップショットを保持するには、カスタムエージェントなしで実行し、プロンプトを置き換える代わりに [`--append-system-prompt`](https://code.claude.com/docs/ja/cli-reference#system-prompt-flags) で指示を追加してください。
* **[Agent SDK](https://code.claude.com/docs/ja/agent-sdk/modifying-system-prompts.md)**: カスタムシステムプロンプトまたはカスタムのメインスレッドエージェントを使用すると、プロンプトが置き換えられます。システムプロンプトを設定しない場合、SDK は最小限のデフォルトを使用し、この場合もセッションはスナップショットなしで開始されます。[bare モード](https://code.claude.com/docs/ja/headless.md#start-faster-with-bare-mode) 以外でスナップショットを保持するには、カスタム `agent` なしで `claude_code` プリセットを使用してください。

### `prUrlTemplate`

Claude Code がレンダリングする PR リンク（フッターバッジとツール結果サマリー内）を `github.com` の代わりに内部コードレビューツールに指定します。Claude Code は PR URL から `{host}`、`{owner}`、`{repo}`、`{number}`、`{url}` を置き換えます。両方のサーフェス上の [GitLab マージリクエスト](https://code.claude.com/docs/ja/interactive-mode.md#gitlab-merge-requests) リンクは GitLab URL を保持します。

* **スコープ**: [`Any file`](#scopes)
* **タイプ**: 文字列。5 つのプレースホルダーのいずれかを使用する URL テンプレート
* **デフォルト**: 未設定

```json settings.json theme={null}
{
  "prUrlTemplate": "https://reviews.example.com/{owner}/{repo}/pull/{number}"
}
```

Claude Code はそれ自体がレンダリングするリンクにのみテンプレートを適用します。Claude がメッセージに書き込む PR 番号（`#123` など）は Claude が書き込んだままです。`/pull/<number>` の形状を持たない URL は変更されません。

### `attribution.commit`

Claude Code が git コミットに追加するアトリビューションテキスト（トレーラーを含む）を設定します。コミットアトリビューションを非表示にするには、空の文字列に設定します。

* **スコープ**: [`Any file`](#scopes)
* **タイプ**: 文字列
* **デフォルト**: 未設定。Claude Code は `Co-Authored-By: <name> <noreply@anthropic.com>` を追加します。名前はコミットが作成されるときに使用されているモデル（`Claude Sonnet 5` など）です。[subagent](https://code.claude.com/docs/ja/sub-agents.md) がコミットを作成する場合、トレーラーは subagent のモデルに名前を付けます。
  * Claude Code がモデルを Claude モデルとして認識しているが、その正確なバージョンを確認できない場合、`Claude` のみを書き込みます。
  * モデル ID をカスタム [`ANTHROPIC_BASE_URL`](https://code.claude.com/docs/ja/env-vars) を通じて提供されるサードパーティモデルなど、Claude モデルと一致させることができない場合、`Claude Code` を書き込みます。

この例はデフォルトトレーラーをカスタム行とカスタム `Co-Authored-By` トレーラーに置き換えます。

```json settings.json theme={null}
{
  "attribution": {
    "commit": "Generated with AI\n\nCo-Authored-By: AI <ai@example.com>"
  }
}
```

### `attribution.pr`

Claude Code がプルリクエストの説明に追加するアトリビューションテキストを設定します。プルリクエストアトリビューションを非表示にするには、空の文字列に設定します。

* **スコープ**: [`Any file`](#scopes)
* **タイプ**: 文字列
* **デフォルト**: 未設定。Claude Code は `🤖 Generated with [Claude Code](https://claude.com/claude-code)` を追加します

```json settings.json theme={null}
{
  "attribution": {
    "pr": ""
  }
}
```

### `attribution.sessionUrl`

Claude Code が [クラウド](https://code.claude.com/docs/ja/claude-code-on-the-web.md) または [Remote Control](https://code.claude.com/docs/ja/remote-control.md) セッションからコミットするか、プルリクエストを開くときに claude.ai セッションリンクを追加するかどうかを選択します。Claude Code はコミット上に `Claude-Session` トレーラーとしてリンクを追加し、プルリクエストの説明にリンクとして追加します。リンクを省略するには `false` に設定します。

* **スコープ**: [`Any file`](#scopes)
* **タイプ**: ブール値
  * `true`: Claude Code はクラウドまたは Remote Control セッションからコミットするか、プルリクエストを開くときに claude.ai セッションリンクを追加します
  * `false`: Claude Code はリンクを省略します
* **デフォルト**: `true`

```json settings.json theme={null}
{
  "attribution": {
    "sessionUrl": false
  }
}
```

## フックと自動化

フックを登録し、実行するフックを制限し、ワークフローを制御します。フックイベントとペイロードについては、[フックリファレンス](https://code.claude.com/docs/ja/hooks.md)を参照してください。

### `allowedHttpHookUrls`

[HTTP フック](https://code.claude.com/docs/ja/hooks.md#http-hook-fields)がターゲットできる URL を制限します。このキーを定義すると、Claude Code は HTTP フックを実行するのはその URL がパターンの 1 つと一致する場合のみで、残りはブロックして実行しません。空の配列はすべての HTTP フックをブロックします。

* **スコープ**: [`Any file`](#scopes)。配列は設定ファイル全体でマージされます。
* **型**: URL パターンの配列。ワイルドカードとして `*` を使用
* **デフォルト**: 未設定。任意の URL が許可されます

この例は `https://hooks.example.com/` 下のすべての URL と任意の `http://localhost` URL を許可します:

```json settings.json theme={null}
{
  "allowedHttpHookUrls": ["https://hooks.example.com/*", "http://localhost:*"]
}
```

ホスト名マッチングは大文字と小文字を区別せず、完全修飾ドメイン名を示す末尾のドット付きの `hooks.example.com.` を `hooks.example.com` と同じように扱います。これは DNS の扱い方と同じです。許可リストはすべてのソースからのフック（管理設定を含む）に適用されます。

Agent SDK の `managedSettings` オプションでは、リストにエントリがある場合、Claude Code はこのキーを無視するため、代わりに SDK の [`settings` オプション](https://code.claude.com/docs/ja/agent-sdk/typescript#options)でリストを渡してください。[親設定で空のリストがどのように動作するか](https://code.claude.com/docs/ja/claude-apps-gateway#how-hook-and-skill-keys-in-parent-settings-take-effect)を参照してください。

### `allowManagedHooksOnly`

フック実行を組織がデプロイするフックに制限します。

* **スコープ**: [`Managed`](#scopes)
* **型**: ブール値
  * `true`: 管理フックのみが実行され、Agent SDK フックと管理設定が強制有効にするプラグインからのフックも実行されます。[`allowManagedHooksOnly` 下で実行されるもの](#what-runs-under-allowmanagedhooksonly)を参照してください
  * `false`: すべての設定スコープとプラグインからのフックが実行されます
* **デフォルト**: 未設定。すべての設定スコープとプラグインからのフックが実行されます

```json managed-settings.json theme={null}
{
  "allowManagedHooksOnly": true
}
```

#### `allowManagedHooksOnly` 下で実行されるもの

これを `true` に設定すると、Claude Code はどのフックとフック類似コマンドをロードするかを変更します:

* **管理フックと SDK フックが実行されます**: 管理設定からのフックと [Agent SDK](https://code.claude.com/docs/ja/agent-sdk/overview.md) がプロセス内で登録するフック
* **強制有効プラグインフックが実行されます**: 管理設定が [`enabledPlugins`](#enabledplugins) を通じて強制有効にするプラグインからのフック。Claude Code は完全な `plugin@marketplace` ID でマッチするため、別のマーケットプレイスからの同じ名前のプラグインはブロックされたままです。これにより、組織マーケットプレイスを通じて検証済みフックを配布しながら、その他すべてをブロックできます。このようなプラグイン内の [mod](https://code.claude.com/docs/ja/plugins/mods/overview.md) は、[組織のものとしてカウント](https://code.claude.com/docs/ja/plugins/mods/admin.md#install-your-organizations-mods)される場合のみロードされます
* **他のプラグインのモニターはブロックされます**: プラグインの[モニター](https://code.claude.com/docs/ja/plugins/components.md#monitors)は、そのプラグインが強制有効にされていない限り起動しません。Claude Code v2.1.310 以降が必要です
* **その他すべてはブロックされます**: ユーザー、プロジェクト、ローカルフック、他のインストール済みプラグインからのフックと mod、エージェントのフロントマターで宣言されたフック。[Claude Code に組み込まれた mod](https://code.claude.com/docs/ja/plugins/mods/overview.md#mods-built-into-claude-code) は実行し続けます。ユーザーの mod のみをブロックするには、代わりに [`allowManagedModsOnly`](https://code.claude.com/docs/ja/plugins/mods/admin#set-options-on-the-built-in-guard) を設定してください。
* **コマンドソースプラグインは無効になります**: Claude Code は [`command` ソース](https://code.claude.com/docs/ja/plugins/marketplace-reference#command-plugin-source)を持つプラグイン（管理 `enabledPlugins` で強制有効にされたプラグインを含む）も無効にします。ただし、[`disableCommandPluginSources`](#disablecommandpluginsources) を明示的に `false` に設定した場合を除きます
* **マーケットプレイス `headersHelper` コマンドはブロックされます**: Claude Code はマーケットプレイス [`headersHelper` コマンド](https://code.claude.com/docs/ja/plugins/host-marketplace#authenticate-archive-downloads)もブロックします。ただし、[`disableCommandPluginSources`](#disablecommandpluginsources) が明示的に `false` に設定されている場合、または管理設定自体が宣言するマーケットプレイスの場合を除きます。Claude Code v2.1.238 以降が必要です
* **ステータスラインとファイル提案は管理設定に絞られます**: Claude Code は [`statusLine`](https://code.claude.com/docs/ja/statusline)、[`fileSuggestion`](#filesuggestion)、[`subagentStatusLine`](https://code.claude.com/docs/ja/statusline#subagent-status-lines) を管理設定からのみ読み込みます。[ステータスラインとファイル提案ゲート](#status-line-and-file-suggestion-gates)に従います

このキーが設定されている間、[`/goal`](https://code.claude.com/docs/ja/goal) コマンドは実行できません。これはフックに依存しているためです。

### `disableAllHooks`

[フック](https://code.claude.com/docs/ja/hooks.md#disable-or-remove-hooks)、カスタム [ステータスライン](https://code.claude.com/docs/ja/statusline.md)、カスタム [ファイル提案](#filesuggestion) コマンドをオフにします。これらを設定から削除せずに一時的にオフにするために使用します。

* **スコープ**: [`Any file`](#scopes)。管理設定のみが管理フックを無効にできます。
* **型**: ブール値
  * `true`: Claude Code はフック、カスタムステータスライン、カスタムファイル提案コマンドをオフにします
  * `false`: フック、ステータスライン、ファイル提案コマンドが実行されます
* **デフォルト**: 未設定。フックが実行されます

```json settings.json theme={null}
{
  "disableAllHooks": true
}
```

到達範囲はキーを持つファイルによって異なります:

* **管理設定内**: Claude Code はすべての設定済みフック（管理フックを含む）を無効にし、[Agent SDK](https://code.claude.com/docs/ja/agent-sdk/overview.md) がプロセス内で登録するフックは実行し続けます
* **Agent SDK の `managedSettings` オプション内**: 管理者が管理設定をデプロイしているマシンでは、管理者が[埋め込みホストによるポリシーの追加を許可](https://code.claude.com/docs/ja/managed-settings.md#let-an-embedding-host-add-policy)していない限り、Claude Code はこのキーを無視します。キーが有効になる場合、ユーザー、プロジェクト、ローカル、プラグインのフックが停止し、SDK の `settings` オプション内のフックも停止します。管理者の管理フック、[強制有効](#enabledplugins)にされたプラグインのフック、および [SDK フックコールバック](https://code.claude.com/docs/ja/agent-sdk/hooks.md)は実行し続けます。Claude Code v2.1.309 以降が必要です。
* **他の設定ファイル内**: Claude Code はユーザー、プロジェクト、ローカル、プラグインフックを無効にします。管理フック、Agent SDK フック、管理 [`enabledPlugins`](#enabledplugins) で強制有効にされたプラグインからのフックは実行し続けます

このキーは、コードがフックを登録するプラグインである [mod](https://code.claude.com/docs/ja/plugins/mods/overview.md) も停止します:

* **管理設定内**: 組織のものを含め、インストール済みのすべてのプラグイン内の mod が停止します
* **他の設定ファイル内**: ユーザーがインストールした mod が停止し、[組織の mod](https://code.claude.com/docs/ja/plugins/mods/admin.md#install-your-organizations-mods) は実行し続けます

Claude Code に組み込まれた mod は、どちらの場合も実行し続けます。それぞれに[独自のスイッチ](https://code.claude.com/docs/ja/plugins/mods/overview.md#mods-built-into-claude-code)があります。

管理設定がこのキーを設定している場合に Agent SDK フックを実行し続けるには、Claude Code v2.1.242 以降が必要です。

フックが無効な間、[`/goal`](https://code.claude.com/docs/ja/goal) コマンドは実行できず、`/hooks` メニューはフックの代わりに通知を表示します。

#### ステータスラインとファイル提案ゲート

Claude Code は `statusLine`、`fileSuggestion`、`subagentStatusLine` について、この順序で 2 つの決定を行います:

* **完全にオフ**: 管理設定が `disableAllHooks` を設定している場合、またはフォルダが設定ファイル内のフックと同じ [ワークスペーストラストルール](https://code.claude.com/docs/ja/permissions.md#what-runs-before-you-trust-a-folder)の下で信頼されていない場合
* **管理設定に絞られます**: [`allowManagedHooksOnly`](#allowmanagedhooksonly) が設定されている場合、[設定の優先順位](https://code.claude.com/docs/ja/hooks.md#disable-or-remove-hooks)が適用された後に管理設定外で `disableAllHooks` が `true` である場合、または `--safe-mode` で Claude Code を起動した場合

絞られた場合、Claude Code はデプロイされた管理値があれば実行します。そうでない場合は警告なしにユーザーの値をスキップします: ステータスラインは無効になり、`@` オートコンプリートは組み込みファイル提案にフォールバックします。

### `disableWorkflows`

[動的ワークフロー](https://code.claude.com/docs/ja/workflows.md#turn-workflows-off)と、管理設定を通じた組織など、設定が到達するすべてのユーザーのためのバンドルワークフローコマンドをオフにします。自分自身のためだけにワークフローをオンまたはオフにするには、代わりに [`enableWorkflows`](#enableworkflows) を使用してください。これは `/config` の **Dynamic workflows** トグルがユーザー設定に書き込みます。

* **スコープ**: [`Any file`](#scopes)
* **型**: ブール値
  * `true`: Claude Code は動的ワークフローと、設定が到達するすべてのユーザーのためのバンドルワークフローコマンドをオフにします
  * `false`: 未設定と同じです。ワークフローがオンかどうかは [`enableWorkflows`](#enableworkflows) とプランのデフォルトに従います
* **デフォルト**: `false`
* **セッションごとの上書き**: [`CLAUDE_CODE_DISABLE_WORKFLOWS`](https://code.claude.com/docs/ja/env-vars) は 1 つのセッションのワークフローをオフにします。2 つのうちどちらがオフにするかに関わらず、もう一方はオンに戻すことはできません

```json settings.json theme={null}
{
  "disableWorkflows": true
}
```

### `enableWorkflows`

プランのデフォルトが望むものでない場合、自分自身のために [動的ワークフロー](https://code.claude.com/docs/ja/workflows.md)をオンまたはオフにします。`/config` に **Dynamic workflows** として表示され、このキーをユーザー設定に書き込み、プランのデフォルトに戻すときに再度削除します。管理設定からすべてのユーザーのためにワークフローをオフにするには、代わりに [`disableWorkflows`](#disableworkflows) を使用してください。

* **スコープ**: [`Any file`](#scopes)
* **型**: ブール値
  * `true`: Claude Code は自分自身の動的ワークフローをオンにします
  * `false`: Claude Code は自分自身の動的ワークフローをオフにします
* **デフォルト**: 未設定。ワークフローはオンです。ただし Pro プランではオフです
* **セッションごとの上書き**: [`CLAUDE_CODE_DISABLE_WORKFLOWS`](https://code.claude.com/docs/ja/env-vars) は 1 つのセッションのワークフローをオフにし、ここで `true` はそれが設定されている間はワークフローをオンに戻すことはできません

```json settings.json theme={null}
{
  "enableWorkflows": true
}
```

[`disableWorkflows`](#disableworkflows) と組織のワークフローポリシーも優先されます: `enableWorkflows: true` はいずれかのソースがワークフローをオフにしている間はワークフローをオンに戻すことはできません。Claude Code は、ユーザー設定以外のソースが `enableWorkflows` を設定している場合、または `disableWorkflows` を `true` に設定している場合、`/config` 行を非表示にします。

### `hooks`

Claude Code のライフサイクルの特定の時点（ツール呼び出しの前やセッション開始時など）で、[フック](https://code.claude.com/docs/ja/hooks.md)として独自のコマンド、プロンプト、エージェント、HTTP リクエスト、または MCP ツールを実行します。[フックリファレンス](https://code.claude.com/docs/ja/hooks.md#hook-events)はすべてのイベント、ペイロード、終了コードをリストします。各イベントは matcher グループのリストにマップされ、各グループは matcher が適用されるときに実行するハンドラーをリストします。

* **スコープ**: [`Any file`](#scopes)。フックは互いに置き換えられるのではなくファイル全体でマージされ、管理設定からのフックは他のファイルから削除できません。
* **型**: [フックイベント](https://code.claude.com/docs/ja/hooks.md#hook-events)でキー付けされたオブジェクト。各値は `"command"`、`"prompt"`、`"agent"`、`"http"`、または `"mcp_tool"` の `type` を持つ `{ "matcher", "hooks" }` グループの配列
* **デフォルト**: 未設定。フックは実行されません

この例はすべての Bash ツール呼び出しの前にスクリプトを実行します:

```json settings.json theme={null}
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          { "type": "command", "command": "~/.claude/hooks/check-bash.sh" }
        ]
      }
    ]
  }
}
```

すべてのイベント、matcher パターン、ハンドラーフィールドについては、[フックリファレンス](https://code.claude.com/docs/ja/hooks.md#configuration)を参照してください。フックをオフにするには、[`disableAllHooks`](#disableallhooks)を参照してください。フックを組織がデプロイするものに制限するには、[`allowManagedHooksOnly`](#allowmanagedhooksonly)を参照してください。

### `httpHookAllowedEnvVars`

[HTTP フック](https://code.claude.com/docs/ja/hooks.md#http-hook-fields)は環境変数の値をリクエストヘッダーに入れることができます。例えば `Authorization: Bearer $HOOK_TOKEN` ヘッダーですが、フックが独自の `allowedEnvVars` でリストしている変数のみです。このキーはすべての HTTP フックのそのリストに外側の制限を設定します: フックは変数を使用できるのは、独自の `allowedEnvVars` とこのキーの両方がそれを名前付けしている場合のみです。フックの定義がそれを要求している場合でも、フックが読むべきではないシークレットを読むのを防ぐために使用します。

* **スコープ**: [`Any file`](#scopes)。配列は設定ファイル全体でマージされます。
* **型**: 環境変数名の配列
* **デフォルト**: 未設定。各フック独自の `allowedEnvVars` リストが適用されます

この例はヘッダー補間を `MY_TOKEN` と `HOOK_SECRET` に制限します:

```json settings.json theme={null}
{
  "httpHookAllowedEnvVars": ["MY_TOKEN", "HOOK_SECRET"]
}
```

許可リストはすべてのソースからのフック（管理設定を含む）に適用されます。

Agent SDK の `managedSettings` オプションでは、リストにエントリがある場合、Claude Code はこのキーを無視するため、代わりに SDK の [`settings` オプション](https://code.claude.com/docs/ja/agent-sdk/typescript#options)でリストを渡してください。[親設定で空のリストがどのように動作するか](https://code.claude.com/docs/ja/claude-apps-gateway#how-hook-and-skill-keys-in-parent-settings-take-effect)を参照してください。

### `workflowKeywordTriggerEnabled`

プロンプトでキーワード `ultracode` を入力することが [動的ワークフロー](https://code.claude.com/docs/ja/workflows.md#ask-for-a-workflow-in-your-prompt)をトリガーするかどうかを選択します。`false` に設定して、トリガーなしで単語を入力します。

* **スコープ**: [`Any file`](#scopes)。`/config` に **Ultracode keyword trigger** として表示されます。
* **型**: ブール値
  * `true`: プロンプトで `ultracode` を入力すると動的ワークフローがトリガーされます
  * `false`: トリガーなしで単語を入力できます
* **デフォルト**: `true`

```json settings.json theme={null}
{
  "workflowKeywordTriggerEnabled": false
}
```

`ultracode` 努力設定、`/workflows`、保存されたワークフローコマンドは影響を受けません。

### `workflowSizeGuideline`

Claude が書き込む動的ワークフローで [Claude が目指すエージェント数](https://code.claude.com/docs/ja/workflows.md#set-a-size-guideline)を設定します。Claude Code は値を Claude に助言として送信します。強制的な上限ではありません: `"small"` は 5 未満のエージェントを要求し、`"medium"` は 10 未満、`"large"` は 50 未満です。ワークフローが費やすものを制限したい場合は `"small"` を選択します。

* **スコープ**: [`Any file`](#scopes)。そこの値は `/config` の **Dynamic workflow size** 選択肢より優先されます。Claude Code は `~/.claude.json` に保存します。設定ファイルがキーを設定している間、Claude Code はその行を非表示にします。
* **型**: 文字列。以下のいずれか:
  * `"unrestricted"`: ガイドラインなし。Claude はタスクに合わせてワークフローの規模を決めます
  * `"small"`: Claude は 5 未満のエージェントを目指します
  * `"medium"`: Claude は 10 未満のエージェントを目指します
  * `"large"`: Claude は 50 未満のエージェントを目指します
* **デフォルト**: `"medium"`、または Pro プランで Claude Code v2.1.271 以降にサインインしている場合は `"small"`

```json settings.json theme={null}
{
  "workflowSizeGuideline": "small"
}
```

## プラグインとスキル

プラグインの有効化、マーケットプレイスの登録、組織で許可するプラグインソースの制限、読み込むスキルの制御を行います。プラグインのインストールと作成については、[プラグイン](https://code.claude.com/docs/ja/plugins/overview.md)を参照してください。

### `disableBundledSkills`

Claude Code に同梱されている[スキル](https://code.claude.com/docs/ja/skills.md)とワークフローをオフにします。Claude Code はバンドルスキルとワークフローを完全に削除しますが、`/init` などの組み込みコマンドは引き続き入力できる一方でモデルからは非表示になります。

* **スコープ**: [`任意のファイル`](#scopes)
* **型**: Boolean
  * `true`: Claude Code はバンドルスキルとワークフローを削除し、`/init` などの組み込みコマンドをモデルから非表示にします
  * `false`: バンドルスキルが読み込まれます
* **デフォルト**: 未設定。バンドルスキルが読み込まれます
* **セッション単位の上書き**: [`CLAUDE_CODE_DISABLE_BUNDLED_SKILLS`](https://code.claude.com/docs/ja/env-vars) を `1` に設定すると、1 つのセッションでバンドルスキルがオフになります。2 つのうちどちらでオフにした場合でも、もう一方でオンに戻すことはできません

```json settings.json theme={null}
{
  "disableBundledSkills": true
}
```

プラグイン、`.claude/skills/`、`.claude/commands/` からのスキルは影響を受けません。`/doctor` は組み込みコマンドと同様に引き続き入力できます。非表示にするには、代わりに [`DISABLE_DOCTOR_COMMAND`](https://code.claude.com/docs/ja/env-vars) を設定してください。

### `disableSkillShellExecution`

ユーザー、プロジェクト、プラグイン、または追加ディレクトリのソースからの[スキル](https://code.claude.com/docs/ja/skills.md)とカスタムコマンドにおける `` !`...` `` ブロックと ` ```! ` ブロックのインラインシェル実行をオフにします。Claude Code は各コマンドを実行する代わりに `[shell command execution disabled by policy]` に置き換えます。

* **スコープ**: [`任意のファイル`](#scopes)。管理設定の `true` は、他の場所の `false` で上書きできません。
* **型**: Boolean
  * `true`: Claude Code は各インラインシェルコマンドを実行する代わりに `[shell command execution disabled by policy]` に置き換えます
  * `false`: インラインシェルが実行されます
* **デフォルト**: 未設定。インラインシェルが実行されます

```json settings.json theme={null}
{
  "disableSkillShellExecution": true
}
```

バンドルスキルと管理設定を通じてデプロイされたスキルは影響を受けません。

### `skillOverrides`

`SKILL.md` を編集せずに[スキル](https://code.claude.com/docs/ja/skills.md#override-skill-visibility-from-settings)を非表示にしたり折りたたんだりします。Claude Code は各スキル名の下の値を、Claude が参照するスキル一覧と `/` のオートコンプリートに適用します。

* **スコープ**: [`任意のファイル`](#scopes)。`/skills` メニューは `.claude/settings.local.json` に書き込みます。
* **型**: スキル名を次のいずれかにマッピングするオブジェクト:
  * `"on"`: Claude はスキルを参照でき、`/name` を入力できます
  * `"name-only"`: Claude はスキルを説明なしで名前のみ参照します
  * `"user-invocable-only"`: Claude はスキルを参照しませんが、`/name` は引き続き入力できます
  * `"off"`: Claude はスキルを参照せず、`/name` はオートコンプリートから非表示になります
* **デフォルト**: 未設定。すべてのスキルが `"on"` になります

この例では、`legacy-context` を Claude に名前のみで提示し、`deploy` を Claude と `/` のオートコンプリートの両方から非表示にします。

```json settings.json theme={null}
{
  "skillOverrides": {
    "legacy-context": "name-only",
    "deploy": "off"
  }
}
```

上書きはプラグインスキルには適用されません。プラグインスキルは `/plugin` で管理します。

管理設定と `--settings` で渡されたファイルでは、`/doctor` に対する `checkup` のようなバンドルスキルのエイリアスに設定したキーもそのスキルに適用されます。[エイリアスのキーとスキル自体の名前のキーがどのように組み合わされるか](https://code.claude.com/docs/ja/skills.md#override-skill-visibility-from-settings)を参照してください。

### `syncClaudeAiSkills`

[claude.ai アカウントで有効になっているスキル](https://code.claude.com/docs/ja/skills.md#how-synced-skills-behave)のダウンロードをオフにします。Claude Code は、[claude.ai アカウントでサインインしているターミナルセッション](https://code.claude.com/docs/ja/skills.md#where-synced-skills-load)（対話型・非対話型を問わず）、および Cowork セッションとクラウドセッションで、それらを `~/.claude/skills/synced/` にダウンロードします。`false` を設定すると、そのダウンロードが停止し、すでに同期されたスキルの読み込みも停止します。Claude Code が反映するのは `false` のみです。`true` は未設定と同じであり、他の理由でオフになっている場所で同期をオンにすることはありません。

* **スコープ**: [`ユーザー、ローカル、または管理`](#scopes)、および `--settings` で渡されたファイル。リポジトリがユーザーに代わってこれをオフにすることはできません。
* **型**: Boolean
  * `false`: Claude Code は同期スキルのダウンロードを停止し、`~/.claude/skills/synced/` にすでにあるスキルの読み込みも停止します。ユーザー設定または管理設定では、それらを `~/.claude/skills/.trash/` に移動することもします
  * `true`: 未設定と同じです
* **デフォルト**: 未設定。claude.ai アカウントでサインインしたセッションでスキルが同期されます

この例では、どのセッションでもマシンがアカウントのスキルをダウンロードしないようにします。

```json settings.json theme={null}
{
  "syncClaudeAiSkills": false
}
```

### `syncClaudeAiPlugins`

[claude.ai アカウントで有効になっているプラグイン](https://code.claude.com/docs/ja/plugins/loading.md#synced-plugins)のダウンロードをオフにします。Claude Code は、claude.ai アカウントでサインインしているターミナルセッションの開始時と Cowork セッションで、それらを `~/.claude/plugins/synced/` にダウンロードし、それぞれを `<name>@synced` として読み込みます。`false` を設定すると、そのダウンロードが停止し、すでに同期されたプラグインの読み込みも停止します。Claude Code が反映するのは `false` のみです。`true` は未設定と同じであり、他の理由でオフになっている場所で同期をオンにすることはありません。Claude Code v2.1.273 以降が必要です。

* **スコープ**: [`ユーザー、ローカル、または管理`](#scopes)、および `--settings` で渡されたファイル。リポジトリがユーザーに代わってこれをオフにすることはできません。
* **型**: Boolean
  * `false`: Claude Code は同期プラグインのダウンロードを停止し、`~/.claude/plugins/synced/` にすでにあるプラグインの読み込みも停止します。ユーザー設定または管理設定では、それらを `~/.claude/plugins/.trash/` に移動することもします
  * `true`: 未設定と同じです
* **デフォルト**: 未設定。claude.ai アカウントでサインインしたセッションでプラグインが同期されます

すべてではなく 1 つの同期プラグインだけをオフにするには、[`enabledPlugins`](#enabledplugins) で `"<name>@synced": false` を設定します。

この例では、どのセッションでもマシンがアカウントのプラグインをダウンロードしないようにします。

```json settings.json theme={null}
{
  "syncClaudeAiPlugins": false
}
```

### `allowedChannelPlugins`

組織内でセッションにメッセージをプッシュできる[チャネル](https://code.claude.com/docs/ja/channels.md)プラグインを選択します。これを設定すると、Claude Code はデフォルトの Anthropic 許可リストの代わりに指定したリストを使用します。各エントリは、プラグインとその提供元のマーケットプレイスを指定します。

* **スコープ**: [`管理`](#scopes)
* **型**: `marketplace` と `plugin` の文字列をそれぞれ持つオブジェクトの配列。エントリは代わりに `"telegram@claude-plugins-official"` のような `"plugin@marketplace"` 文字列にすることもでき、Claude Code はこれを同等のオブジェクトとして扱います。文字列形式には Claude Code v2.1.267 以降が必要です。それより前のバージョンでは、文字列形式を含む場合に `allowedChannelPlugins` の値全体が拒否されます
* **デフォルト**: 未設定。Claude Code はデフォルトの Anthropic 許可リストを使用します

この例では、チャネルをオンにし、公式 Anthropic マーケットプレイスの Telegram プラグインのみを許可します。

```json managed-settings.json theme={null}
{
  "channelsEnabled": true,
  "allowedChannelPlugins": [
    { "marketplace": "claude-plugins-official", "plugin": "telegram" }
  ]
}
```

空の配列はすべてのチャネルプラグインをブロックします。

このキーは、アカウントでチャネルが [`channelsEnabled`](#channelsenabled) のゲートを通過した時点で有効になります。Team プランと Enterprise プラン、および管理設定のある Console アカウントでは、`channelsEnabled: true` がそれに該当します。[実行できるチャネルプラグインを制限する](https://code.claude.com/docs/ja/channels.md#restrict-which-channel-plugins-can-run)を参照してください。

### `blockedMarketplaces`

組織のプラグインマーケットプレイスソースをブロックします。Claude Code は、マーケットプレイスの追加時と、プラグインのインストール、更新、リフレッシュ、自動更新の際にブロックリストを確認するため、ポリシーを設定する前に誰かが追加したマーケットプレイスもプラグインの取得に使用できなくなります。ブロックされたソースはダウンロード前に確認されるため、ファイルシステムに触れることはありません。

このキーを [claude.ai 管理コンソール](https://code.claude.com/docs/ja/server-managed-settings.md)で設定した場合、[制限の仕組み](https://code.claude.com/docs/ja/plugins/org.md#restrict-what-users-can-install)で説明しているとおり、組織内の誰かが claude.ai で git リポジトリからマーケットプレイスを追加するときにも claude.ai がこれを適用します。

* **スコープ**: [`管理`](#scopes)
* **型**: マーケットプレイスソースオブジェクトの配列。形式は [`strictKnownMarketplaces`](#allowed-source-types) と同じです
* **デフォルト**: 未設定。ブロックされるマーケットプレイスはありません

この例では、1 つの GitHub リポジトリをマーケットプレイスソースとしてブロックします。

```json managed-settings.json theme={null}
{
  "blockedMarketplaces": [
    { "source": "github", "repo": "untrusted/plugins" }
  ]
}
```

`github` エントリでは [owner ワイルドカード形式](#owner-wildcards) `"owner/*"` を使用して、その GitHub オーナー配下のすべてのリポジトリをブロックできます。これには Claude Code v2.1.223 以降が必要です。`{ "source": "skills-dir" }` を追加すると、マーケットプレイスを制限することなく、Claude Code が `~/.claude/skills/` とプロジェクトの `.claude/skills/` の両方から [`@skills-dir` プラグイン](https://code.claude.com/docs/ja/plugins/loading#plugins-shared-through-a-repository)を読み込むのを停止できます。[管理対象のマーケットプレイス制限](https://code.claude.com/docs/ja/plugins/org.md#restrict-what-users-can-install)を参照してください。

### `channelsEnabled`

組織で[チャネル](https://code.claude.com/docs/ja/channels.md)を許可します。claude.ai の Team プランと Enterprise プランでは、これを `true` に設定するまで Claude Code はチャネルをブロックします。API キーで認証する [Anthropic Console](https://code.claude.com/docs/ja/authentication.md#claude-console-authentication) アカウントでは、チャネルはデフォルトで許可されます。組織が管理設定をデプロイしている場合は、このキーを `true` に設定するまで、Claude Code はそれらのアカウントでもチャネルをブロックします。

* **スコープ**: [`管理`](#scopes)
* **型**: Boolean
  * `true`: Claude Code は組織でチャネルを許可します
  * `false`: 未設定と同じです。チャネルがブロックされるかどうかは、「デフォルト」に記載のとおりプランによって異なります
* **デフォルト**: 未設定。Team プランと Enterprise プラン、および管理設定のある Console アカウントではチャネルがブロックされ、Pro プランと Max プラン、および管理設定のない Console アカウントでは許可されます

```json managed-settings.json theme={null}
{
  "channelsEnabled": true
}
```

チャネルを有効にした後、チャネルとして登録できるプラグインを制限するには、[`allowedChannelPlugins`](#allowedchannelplugins) を設定します。[エンタープライズ向けの制御](https://code.claude.com/docs/ja/channels.md#enterprise-controls)を参照してください。

### `disableCommandPluginSources`

[`command` プラグインソース](https://code.claude.com/docs/ja/plugins/marketplace-reference#command-plugin-source)をブロックします。これは、マーケットプレイスが宣言したコマンドをユーザーのマシンで実行してプラグインをインストールするソースです。`true` に設定すると、Claude Code はそのコマンドを実行せず、command ソースのプラグインをインストールも更新もせず、すでにインストールされているものの読み込みも停止します。`false` に設定すると明示的に許可します。command ソースをブロックする場合は常に（`true` に設定した場合でも、[`allowManagedHooksOnly`](#allowmanagedhooksonly) のもとで未設定のままにした場合でも）、マーケットプレイスの [`headersHelper` コマンド](https://code.claude.com/docs/ja/plugins/host-marketplace#authenticate-archive-downloads)もブロックします。ただし、管理設定自体が宣言しているマーケットプレイスは除きます。Claude Code v2.1.229 以降が必要で、`headersHelper` のブロックには v2.1.238 以降が必要です。

* **スコープ**: [`管理`](#scopes)
* **型**: Boolean
  * `true`: Claude Code はマーケットプレイスが宣言したコマンドを実行せず、command ソースのプラグインをインストールも更新もせず、すでにインストールされているものの読み込みも停止します
  * `false`: Claude Code は command ソースのプラグインを明示的に許可します
* **デフォルト**: 未設定。Claude Code は [`allowManagedHooksOnly`](#allowmanagedhooksonly) に従います。フックの実行を管理設定に制限している組織では、command ソースも無効になります。Agent SDK の `managedSettings` オプションで [`disableAllHooks: true`](#disableallhooks) を渡すアプリケーションは、それだけでは command ソースを無効にしません。

```json managed-settings.json theme={null}
{
  "disableCommandPluginSources": true
}
```

Claude Code v2.1.229 以降が必要です。

### `pluginSuggestionMarketplaces`

プラグインがコンテキストに応じたインストール候補として、スピナーのヒントや `/plugin` の **Discover** タブ上部へのピン留めに表示されるマーケットプレイスを指定します。組み込みのファーストパーティの frontend-design ヒントは影響を受けません。候補は、マーケットプレイスエントリ内の各プラグインの `relevance` 宣言から得られます。

* **スコープ**: [`管理`](#scopes)
* **型**: マーケットプレイス名の配列
* **デフォルト**: 未設定。マーケットプレイスが宣言した候補は表示されません

```json managed-settings.json theme={null}
{
  "pluginSuggestionMarketplaces": ["acme-corp-plugins"]
}
```

名前が有効になるのは、そのマーケットプレイスがマシンに登録されており、かつ登録されたソースが同じ管理設定内で、その名前の [`extraKnownMarketplaces`](#extraknownmarketplaces) エントリ、または [`strictKnownMarketplaces`](#strictknownmarketplaces) のエントリとしても宣言されている場合のみです。許可リストにある名前で別のソースから登録されたマーケットプレイスは、Claude Code によって無視されます。公式マーケットプレイスはソースの要件から除外されており、その名前を許可リストに入れるだけで十分です。その名前は公式 Anthropic ソースからしか登録できないためです。[コンテキストに応じてプラグインを提案する](https://code.claude.com/docs/ja/plugins/relevance.md)を参照してください。

### `pluginTrustMessage`

インストール前に Claude Code が表示するプラグインの信頼に関する警告に、組織独自のテキストを追加します。たとえば、社内マーケットプレイスのプラグインが審査済みであることを確認するために使用します。

* **スコープ**: [`管理`](#scopes)
* **型**: string
* **デフォルト**: 未設定。Claude Code は標準の警告のみを表示します

```json managed-settings.json theme={null}
{
  "pluginTrustMessage": "All plugins from our marketplace are approved by IT"
}
```

### `strictKnownMarketplaces`

組織内のユーザーが追加し、プラグインをインストールできるプラグインマーケットプレイスソースを制限します。Claude Code は、マーケットプレイスの追加時と、プラグインのインストール、更新、リフレッシュ、自動更新の際に、ネットワーク操作やファイルシステム操作の前に許可リストを適用します。そのため、ポリシーを設定する前に誰かが追加したマーケットプレイスも、そのソースが一致しなくなった時点でプラグインの取得に使用できなくなります。ブロックされたユーザーには、管理ポリシーを示すエラーが表示されます。

このキーを [claude.ai 管理コンソール](https://code.claude.com/docs/ja/server-managed-settings.md)で設定した場合、[制限の仕組み](https://code.claude.com/docs/ja/plugins/org.md#restrict-what-users-can-install)で説明しているとおり、組織内の誰かが claude.ai で git リポジトリからマーケットプレイスを追加するときにも claude.ai がこれを適用します。

* **スコープ**: [`管理`](#scopes)
* **型**: マーケットプレイスソースオブジェクトの配列。[許可されるソースタイプ](#allowed-source-types)を参照してください
* **デフォルト**: 未設定。ユーザーは任意のマーケットプレイスを追加できます。空の配列は、公式 Anthropic マーケットプレイスを含むすべてのマーケットプレイスソースをブロックする完全なロックダウンになります

この例では、2 つの GitHub リポジトリ（うち 1 つは `v2.0` の ref に固定）と、ホストされた 1 つの `marketplace.json` URL を許可します。

```json managed-settings.json theme={null}
{
  "strictKnownMarketplaces": [
    { "source": "github", "repo": "acme-corp/approved-plugins" },
    { "source": "github", "repo": "acme-corp/security-tools", "ref": "v2.0" },
    { "source": "url", "url": "https://plugins.example.com/marketplace.json" }
  ]
}
```

このキーは `allowedMarketplaces` と記述することもできます。Claude Code がエイリアスをどのように扱うか、どのバージョンがそれを受け付けるかについては、[マーケットプレイスキーのエイリアス](#marketplace-key-aliases)で説明しています。このキーはポリシーゲートです。ユーザーが追加できるものを制御しますが、何も登録しません。1 つのファイルで制限と事前登録を行うには、[`extraKnownMarketplaces` と組み合わせる](#combine-with-extraknownmarketplaces)を参照してください。ユーザー側から見た内容については、[管理対象のマーケットプレイス制限](https://code.claude.com/docs/ja/plugins/org.md#restrict-what-users-can-install)を参照してください。

#### 許可されるソースタイプ

以下の各行は、ソースタイプごとの許可リストエントリの例と、受け付けるフィールドを示しています。ほとんどのタイプは完全一致で照合されます。`hostPattern` と `pathPattern` は正規表現で照合され、`github` エントリでは [owner ワイルドカード](#owner-wildcards)を使用できます。

| ソース | エントリの例 | フィールド |
| :- | :- | :- |
| `github` | `{ "source": "github", "repo": "acme-corp/plugins", "ref": "main", "path": "marketplace" }` | `repo` は必須。`ref` はブランチまたはタグ。`path` はサブディレクトリ |
| `git` | `{ "source": "git", "url": "https://gitlab.example.com/tools/plugins.git", "ref": "production" }` | `url` は必須。`ref` と `path` は `github` と同じ |
| `url` | `{ "source": "url", "url": "https://plugins.example.com/marketplace.json", "headers": { "Authorization": "Bearer ${TOKEN}" } }` | `url` は必須。`headers` は認証付きアクセス用の HTTP ヘッダーを追加します |
| `file` | `{ "source": "file", "path": "/opt/acme-corp/plugins/marketplace.json" }` | `path` は必須。`marketplace.json` ファイルへの絶対パス |
| `directory` | `{ "source": "directory", "path": "/opt/acme-corp/approved-marketplaces" }` | `path` は必須。`.claude-plugin/marketplace.json` を含むディレクトリへの絶対パス |
| `hostPattern` | `{ "source": "hostPattern", "hostPattern": "^github\\.example\\.com$" }` | `hostPattern` は必須。マーケットプレイスのホスト内の任意の位置に一致する正規表現。ホスト全体に一致させるには `^` と `$` で固定します |
| `pathPattern` | `{ "source": "pathPattern", "pathPattern": "^/opt/approved/" }` | `pathPattern` は必須。`file` ソースと `directory` ソースの `path` 内の任意の位置に一致する正規表現。プレフィックスを固定するには `^` で始めます |
| `skills-dir` | `{ "source": "skills-dir" }` | フィールドなし |

一部のソースタイプには、表の内容に加えて次のルールがあります。

* **`url`**: URL マーケットプレイスは `marketplace.json` ファイルのみをダウンロードし、Claude Code はそのサーバーから相対パスでプラグインファイルを取得しません。そのため、そのプラグインは相対パス以外の[プラグインソース](https://code.claude.com/docs/ja/plugins/marketplace-reference.md#plugin-sources)（同じホスト上に置くことができるアーカイブ URL など）を使用する必要があります。相対パスを使用するプラグインには、代わりに Git ベースのマーケットプレイスを使用してください。[URL ベースのマーケットプレイスで相対パスを使用するプラグインが失敗する](https://code.claude.com/docs/ja/plugins/troubleshooting.md#plugins-with-relative-paths-fail-in-url-based-marketplaces)を参照してください。
* **`hostPattern`**: 各リポジトリを列挙せずに、社内の GitHub Enterprise または GitLab サーバー上のすべてのマーケットプレイスを許可するために使用します。Claude Code は `github` ソースを `github.com` と照合し、`url` ソースからはホスト名を取得し、`git` ソースからは [git URL](https://git-scm.com/docs/git-clone#_git_urls) の形式に応じてホスト名を取得します。

  * `https://` や `ssh://` などのスキームを持つ URL: URL 内のホスト名。
  * スキームのない、git の `user@host:path` 形式の SSH アドレス（`git@git.example.com:tools/plugins.git` など）: `@` と `:` の間のホスト。これは git が接続するホストです。
  * スキームのないその他の形式: ホストがないため、`strictKnownMarketplaces` の `hostPattern` エントリには一致しません。`blockedMarketplaces` の `hostPattern` では、Claude Code はより広い範囲の形式からホストを取得するため、ブロックリストのエントリはそのような形式にも一致する場合があります。v2.1.234 より前は、`strictKnownMarketplaces` の `hostPattern` は git が SSH アドレスとして扱わない一部の形式にも一致していました。

  `file` ソースと `directory` ソースにはホストがなく、`hostPattern` エントリに一致することはありません。
* **`pathPattern`**: ネットワークソース用の `hostPattern` エントリと併せて、ファイルシステムのマーケットプレイスを許可するために使用します。`".*"` はすべてのローカルパスを許可します。`"^/opt/approved/"` のようなより狭いパターンは、特定のディレクトリに制限します。
* **`skills-dir`**: 許可リストは、空であっても、Claude Code が `~/.claude/skills/` とプロジェクトの `.claude/skills/` の両方から [`@skills-dir` プラグイン](https://code.claude.com/docs/ja/plugins/loading#plugins-shared-through-a-repository)を読み込むことを停止させます。引き続き読み込むには、`{ "source": "skills-dir" }` エントリを追加し、[`strictPluginOnlyCustomization`](#strictpluginonlycustomization) を未設定のままにしてください。このエントリは、このキーと `blockedMarketplaces` 以外では意味を持ちません。

#### Owner ワイルドカード

`repo` の値が `"<owner>/*"` である `github` エントリは、その GitHub オーナー配下のすべてのリポジトリに一致します。owner ワイルドカードには Claude Code v2.1.223 以降が必要で、`strictKnownMarketplaces` と `blockedMarketplaces` でのみ機能します。`extraKnownMarketplaces` や `/plugin marketplace add` など、`github` ソースが現れるそれ以外の場所では、`repo` の値は単一のリポジトリを指定する必要があります。v2.1.223 より前は、Claude Code はエントリを文字どおりに比較していたため、許可リストのエントリはどのリポジトリにも一致せず、ブロックリストのエントリは何もブロックしませんでした。単一リポジトリのエントリはすべてのバージョンで適用されます。

このエントリは、`acme-corp` 組織内の任意のマーケットプレイスリポジトリを許可します。

```json managed-settings.json theme={null}
{
  "strictKnownMarketplaces": [
    { "source": "github", "repo": "acme-corp/*" }
  ]
}
```

ワイルドカードにできるのは、リポジトリ名の位置全体のみです。`*`、`*/plugins`、`acme-corp/tools-*` のようなエントリは無効として Claude Code に無視されるため、どのリポジトリにも一致しません。

照合ルールは 2 つの設定で異なります。

| ルール | `strictKnownMarketplaces` | `blockedMarketplaces` |
| - | - | - |
| 一致するソースの表記 | `owner/repo` 形式のみ。同じリポジトリをクローンする git URL は一致しません | 同じ github.com リポジトリに解決される git URL を含む、任意の表記 |
| オーナーの大文字と小文字 | 区別する | 区別しない |
| `ref` | 完全一致エントリのルールに従います。`ref` を持つエントリはその ref と完全に一致するソースにのみ一致し、持たないエントリは ref を指定していないソースにのみ一致します | `ref` を持たないエントリは、一致するリポジトリのすべての ref をブロックします |
| `path` | 完全一致エントリのルールより緩やかです。`path` を持つエントリはその値との完全一致を要求しますが、持たないエントリはリポジトリ内の任意のパスに一致します | `path` を持たないエントリは、一致するリポジトリのすべてのパスをブロックします |

#### 完全一致

owner ワイルドカードの `github` エントリと、正規表現で照合される `hostPattern` および `pathPattern` エントリを除くすべてのソースタイプについて、Claude Code はマーケットプレイスソースがエントリと完全に一致する場合にのみユーザーによる追加を許可します。git ベースのソースである `github` と `git` では、完全一致の対象にオプションのフィールドも含まれます。

* `repo` または `url` が完全に一致する必要があります
* `ref` フィールドが完全に一致するか、両方とも未定義である必要があります
* `path` フィールドが完全に一致するか、両方とも未定義である必要があります

たとえば、Claude Code は以下の各ペアを 2 つの異なるソースとして扱います。

* `{ "source": "github", "repo": "acme-corp/plugins" }` と `{ "source": "github", "repo": "acme-corp/plugins", "ref": "main" }`
* `{ "source": "github", "repo": "acme-corp/plugins", "path": "marketplace" }` と `{ "source": "github", "repo": "acme-corp/plugins" }`

#### 公式マーケットプレイスのみを許可する

公式 Anthropic マーケットプレイスのみを許可し、それ以外を許可しないようにするには、そのリポジトリを記載します。

```json managed-settings.json theme={null}
{
  "strictKnownMarketplaces": [
    { "source": "github", "repo": "anthropics/claude-plugins-official" }
  ]
}
```

このエントリがある場合、Claude Code はすでに登録されている公式マーケットプレイスを引き続き利用可能にし、新しいマシンでは、初めて対話型ターミナルセッションを開始したときにマーケットプレイスを自動的に登録します。自動登録が行われないことが最も多いのは次の場合です。

* マシンで最初の対話型ターミナルセッションより前に実行される非対話型環境。
* Claude Code が VS Code 拡張機能経由でのみ実行されたマシン。
* 空配列によるロックダウンなど、マーケットプレイスをブロックするポリシーのもとで Claude Code がすでに対話型ターミナルセッションを実行したマシン。Claude Code はブロックされた試行を記録し、ポリシーが変更された後も再試行しません。

これらのマシンでは、同じ `managed-settings.json` の [`extraKnownMarketplaces`](#extraknownmarketplaces) にマーケットプレイスを追加して Claude Code に自動登録させるか、`claude plugin marketplace add anthropics/claude-plugins-official` を実行してください。

#### `extraKnownMarketplaces` と組み合わせる

2 つのキーは異なる役割を担います。次の表で両者を比較します。

| 観点 | `strictKnownMarketplaces` | `extraKnownMarketplaces` |
| - | - | - |
| 目的 | 組織のポリシーの適用 | チームの利便性 |
| 設定ファイル | 管理設定のみ | 任意の設定ファイル |
| 動作 | 許可リストにない追加をブロックする | 未登録のマーケットプレイスを登録する |
| 適用のタイミング | ネットワーク操作とファイルシステム操作の前 | ユーザー設定または管理設定からは即時。リポジトリのファイルの場合はワークスペースの信頼ダイアログの後 |
| 上書きの可否 | 不可。優先順位が最も高い | 可。より優先順位の高い設定により上書きされる |
| ソースの形式 | ソースオブジェクトを直接指定 | ネストされた `source` オブジェクトを持つ名前付きマーケットプレイス |

すべてのユーザーに対してマーケットプレイスの制限と事前登録の両方を行うには、`managed-settings.json` で両方を設定します。

```json managed-settings.json theme={null}
{
  "strictKnownMarketplaces": [
    { "source": "github", "repo": "acme-corp/plugins" }
  ],
  "extraKnownMarketplaces": {
    "acme-tools": {
      "source": { "source": "github", "repo": "acme-corp/plugins" }
    }
  }
}
```

`strictKnownMarketplaces` のみを設定した場合でも、ユーザーは `/plugin marketplace add` で許可されたマーケットプレイスを自分で追加できます。Claude Code が自動的に登録するのは公式 Anthropic マーケットプレイスのみであり、それも許可リストが許可している場合に限られます。自動登録が行われないマシンについては、[公式マーケットプレイスのみを許可する](#allow-only-the-official-marketplace)に記載しています。

### `strictPluginOnlyCustomization`

ユーザーソースとプロジェクトソースからのスキル、エージェント、フック、MCP サーバーをブロックし、それらがプラグインまたは管理設定からのみ提供されるようにします。[`strictKnownMarketplaces`](#strictknownmarketplaces) と組み合わせると、カスタマイズのサプライチェーン全体を制御できます。マーケットプレイスの許可リストは、ユーザーがインストールできるプラグインを制御します。

* **スコープ**: [`管理`](#scopes)
* **型**: 4 種類のカスタマイズすべてをロックする場合は `true`、またはロックする種類を `"skills"`、`"agents"`、`"hooks"`、`"mcp"` から指定する配列
* **デフォルト**: 未設定。何もロックされません

この例では、スキルとフックをロックし、エージェントと MCP サーバーはロックしません。

```json managed-settings.json theme={null}
{
  "strictPluginOnlyCustomization": ["skills", "hooks"]
}
```

いずれかのサーフェスをロックすると、Claude Code は[スキルディレクトリプラグイン](https://code.claude.com/docs/ja/plugins/loading.md#skills-directory-plugins-blocked-by-managed-settings)（ユーザーが `~/.claude/skills/` または `.claude/skills/` の下に置いているプラグインフォルダ）の読み込みも停止します。これらのフォルダはマーケットプレイスからインストールされるのではなくユーザー自身が配置するものであるため、Claude Code はこの設定においてそれらをユーザーによるカスタマイズとして扱います。

以下の 4 つのサブキーの項目では、各サーフェスが他にブロックするものと、引き続き読み込まれるものを記載しています。Claude Code は認識できないサーフェス名を、設定ファイルをエラーにするのではなく無視します。そのため、すべてのクライアントが更新される前に新しいサーフェス名を追加できます。

### `strictPluginOnlyCustomization.skills`

`skills` サーフェスをロックします。Claude Code は、`~/.claude/skills/` と `.claude/skills/` からのスキル、`~/.claude/commands/` と `.claude/commands/` からのカスタムコマンド、`--add-dir` ディレクトリ配下のスキルとコマンド、および claude.ai アカウントから同期されたスキルの読み込みを停止します。バンドルスキル、管理ポリシーディレクトリ内のスキル、および[スキルディレクトリプラグイン](https://code.claude.com/docs/ja/plugins/loading.md#skills-directory-plugins-blocked-by-managed-settings)以外のプラグインからのスキルは引き続き読み込みます。

* **スコープ**: [`管理`](#scopes)
* **型**: [`strictPluginOnlyCustomization`](#strictpluginonlycustomization) 配列内の文字列 `"skills"`
* **デフォルト**: ロックされない

```json managed-settings.json theme={null}
{
  "strictPluginOnlyCustomization": ["skills"]
}
```

### `strictPluginOnlyCustomization.agents`

`agents` サーフェスをロックします。Claude Code は、`~/.claude/agents/`、`.claude/agents/`、および `--add-dir` ディレクトリからのエージェントの読み込みを停止します。組み込みエージェント、管理ポリシーディレクトリ内のエージェント、および[スキルディレクトリプラグイン](https://code.claude.com/docs/ja/plugins/loading.md#skills-directory-plugins-blocked-by-managed-settings)以外のプラグインからのエージェントは引き続き読み込みます。

* **スコープ**: [`管理`](#scopes)
* **型**: [`strictPluginOnlyCustomization`](#strictpluginonlycustomization) 配列内の文字列 `"agents"`
* **デフォルト**: ロックされない

```json managed-settings.json theme={null}
{
  "strictPluginOnlyCustomization": ["agents"]
}
```

### `strictPluginOnlyCustomization.hooks`

`hooks` サーフェスをロックします。

* **実行を停止するもの**:
  * ユーザー、プロジェクト、ローカルの `settings.json` からのフック
  * [`skills`](#strictpluginonlycustomization-skills) または [`agents`](#strictpluginonlycustomization-agents) のロックがブロックするソースからの、スキル、カスタムコマンド、エージェント内のフロントマターフック
* **引き続き実行するもの**: 管理設定内のフック、および[スキルディレクトリプラグイン](https://code.claude.com/docs/ja/plugins/loading.md#skills-directory-plugins-blocked-by-managed-settings)以外のプラグインからのフック

フロントマターフックの実行が停止されたスキル、カスタムコマンド、エージェントも、それ自体のサーフェスがロックされていない限り引き続き読み込まれます。

フロントマターで `hooks` を宣言している個人またはプロジェクトの[スキル](https://code.claude.com/docs/ja/skills.md#where-skills-live)は、[`allowed-tools`](https://code.claude.com/docs/ja/skills#pre-approve-tools-for-a-skill) による事前承認も失うため、ユーザーにはそのフィールドに記載されたツールについて権限プロンプトが表示されます。そのようなスキルが [`context: fork`](https://code.claude.com/docs/ja/skills#run-skills-in-a-subagent) によってサブエージェントで実行される場合は、事前承認が維持されます。`hooks` を宣言していないスキルも事前承認を維持します。

* **スコープ**: [`管理`](#scopes)
* **型**: [`strictPluginOnlyCustomization`](#strictpluginonlycustomization) 配列内の文字列 `"hooks"`
* **デフォルト**: ロックされない

```json managed-settings.json theme={null}
{
  "strictPluginOnlyCustomization": ["hooks"]
}
```

### `strictPluginOnlyCustomization.mcp`

`mcp` サーフェスをロックします。Claude Code は、`~/.claude.json` と `.mcp.json` からの MCP サーバーの読み込みを停止します。[`managed-mcp.json`](https://code.claude.com/docs/ja/managed-mcp) のサーバー、[`managedMcpServers`](#managedmcpservers) のサーバー、および[スキルディレクトリプラグイン](https://code.claude.com/docs/ja/plugins/loading.md#skills-directory-plugins-blocked-by-managed-settings)以外のプラグインからの MCP サーバーは引き続き読み込みます。

* **スコープ**: [`管理`](#scopes)
* **型**: [`strictPluginOnlyCustomization`](#strictpluginonlycustomization) 配列内の文字列 `"mcp"`
* **デフォルト**: ロックされない

```json managed-settings.json theme={null}
{
  "strictPluginOnlyCustomization": ["mcp"]
}
```

### `enabledPlugins`

個々の[プラグイン](https://code.claude.com/docs/ja/plugins/overview.md)を `plugin-name@marketplace-name` をキーとしてオンまたはオフにします。どのスコープにもエントリがないプラグインは、その [`defaultEnabled`](https://code.claude.com/docs/ja/plugins/manifest-reference#fields) の値にフォールバックします。`/plugin` または `claude plugin enable` でプラグインを有効化または無効化すると、Claude Code がこのキーを自動的に書き込みます。

* **スコープ**: [`任意のファイル`](#scopes)
* **型**: `plugin-name@marketplace-name` を Boolean にマッピングするオブジェクト
* **デフォルト**: 未設定。各プラグインはその `defaultEnabled` の値に従います

この例では、`team-tools` マーケットプレイスの 2 つのプラグインを有効にし、`personal` の 1 つを無効にします。

```json settings.json theme={null}
{
  "enabledPlugins": {
    "code-formatter@team-tools": true,
    "deployment-tools@team-tools": true,
    "experimental-features@personal": false
  }
}
```

各スコープはそれぞれ異なる目的を持ちます。

* **ユーザー設定**: 個人のプラグインの設定
* **プロジェクト設定**: リポジトリの全員と共有するプラグイン
* **ローカル設定**: マシンごとの上書き。Claude Code がここに設定を保存するときに gitignore されます
* **管理設定**: 組織全体のポリシー。ここで `false` に設定されたプラグインは、すべてのスコープでインストールがブロックされ、マーケットプレイスから非表示になります

プロジェクト設定はユーザー設定より優先されるため、`~/.claude/settings.json` でプラグインを `false` に設定しても、プロジェクトの `.claude/settings.json` で有効にされているプラグインは無効になりません。自分のマシンでプロジェクトが有効にしたプラグインを使わないようにするには、代わりに `.claude/settings.local.json` で `false` に設定してください。管理設定によって強制的に有効にされたプラグインは、管理設定がローカル設定を上書きするため、この方法では無効にできません。

プロジェクトの `.claude/settings.json` で GitHub リポジトリや npm パッケージなどの外部ソースのプラグインを有効にしても、他のユーザーにはインストールされません。プラグインを読み込むすべての経路で、各ユーザーが[自分でインストールする](https://code.claude.com/docs/ja/plugins/org.md#require-plugins-per-repository)まで、Claude Code はそのプラグインを未インストールとして報告します。

### `extraKnownMarketplaces`

追加のプラグインマーケットプレイスを名前で登録し、リポジトリを開いたユーザーや管理設定が届くすべてのユーザーが、自分で追加しなくてもマーケットプレイスを利用できるようにします。Claude Code は、まだ認識していない各マーケットプレイスを登録します。そこから [`enabledPlugins`](#enabledplugins) が指定したプラグインがインストールされるかどうかは、プラグインのソースとそれを有効にしているファイルによって異なります。ルールについてはそのエントリを参照してください。

* **スコープ**: [`任意のファイル`](#scopes)。Claude Code は、リポジトリの `.claude/settings.json` または `.claude/settings.local.json` のエントリを、そのフォルダのワークスペースの信頼ダイアログを承認した後にのみ反映します。信頼していないフォルダ（そこでの `-p` 実行を含む）では、メッセージを表示せずにそれらを無視します。
* **型**: マーケットプレイス名を、`source` オブジェクトとオプションの `autoUpdate` Boolean を持つオブジェクトにマッピングするオブジェクト
* **デフォルト**: 未設定

この例では、GitHub マーケットプレイスと、セルフホストの git URL からのマーケットプレイスを登録します。

```json settings.json theme={null}
{
  "extraKnownMarketplaces": {
    "acme-tools": {
      "source": {
        "source": "github",
        "repo": "acme-corp/claude-plugins"
      }
    },
    "security-plugins": {
      "source": {
        "source": "git",
        "url": "https://git.example.com/security/plugins.git"
      }
    }
  }
}
```

[フォルダを信頼する前に実行されるもの](https://code.claude.com/docs/ja/permissions.md#what-runs-before-you-trust-a-folder)では、信頼ゲートとリポジトリが提供できるその他のコンテンツを比較しています。このキーは `additionalMarketplaces` と記述することもできます。[マーケットプレイスキーのエイリアス](#marketplace-key-aliases)を参照してください。

`source` と併せて `"autoUpdate": true` を設定すると、Claude Code は起動後にバックグラウンドでそのマーケットプレイスをリフレッシュし、インストール済みのプラグインを更新します。省略した場合、`claude-plugins-official` とその他の大半の公式 Anthropic マーケットプレイスはデフォルトで `true` になり、サードパーティのマーケットプレイスはデフォルトで `false` になります。[自動更新を設定する](https://code.claude.com/docs/ja/plugins/install.md#keep-plugins-updated)を参照してください。

複数の設定ファイルが同じ名前でマーケットプレイスのエントリを定義している場合、Claude Code は[優先順位が最も高いファイル](https://code.claude.com/docs/ja/settings.md#settings-precedence)のエントリ全体を使用します。そのエントリは優先順位の低いエントリを置き換え、そのフィールドを一切継承しないため、再定義によって、あるファイルの `source.headers` の認証情報を別のファイルが制御する URL と組み合わせることはできません。v2.1.228 より前は、Claude Code は同名のエントリをフィールドごとにマージしていたため、優先順位の高いファイルのエントリが、別のファイルの `headers` を含め、自身で設定していないフィールドを継承することがありました。

#### マーケットプレイスのソースタイプ

`source` オブジェクトは次のいずれかの形式をとります。

* **`github`**: GitHub リポジトリ。`repo` を指定します
* **`git`**: 任意の git URL。`url` を指定します
* **`url`**: `marketplace.json` ファイルへの直接 URL。`url` と、認証付きアクセス用のオプションの `headers` および `headersHelper` を指定します。`headersHelper` は、`headers` に記載するには有効期間が短すぎる値を持つヘッダーを出力するコマンドを指定するもので、Claude Code v2.1.238 以降が必要です
* **`file`**: `marketplace.json` ファイルへのローカルパス。`path` を指定します
* **`directory`**: ローカルファイルシステムのパス。`path` を指定します。開発用、または組織が[各マシンにデプロイする](https://code.claude.com/docs/ja/plugins/mods/admin.md#install-your-organizations-mods)マーケットプレイスに使用します。
* **`settings`**: ホストされたリポジトリなしで設定ファイル内に直接宣言されたインラインマーケットプレイス。`name` と `plugins` を指定します

`git` ソースタイプは、セルフホストの GitLab や Bitbucket を含む任意の git ホスティングサービスで機能します。Claude Code は、そのマシン上で `git clone` が使用するのと同じ認証、つまり設定済みの認証情報ヘルパーまたは SSH キーでリポジトリをクローンします。`GITHUB_TOKEN` などのプロバイダートークンは、それを読み取る認証情報ヘルパーを通じて有効になります。セットアップの詳細については、[プライベートリポジトリ](https://code.claude.com/docs/ja/plugins/host-marketplace.md#grant-access-to-a-private-marketplace)を参照してください。

`github` ソースと `git` ソースでは、Claude Code はマーケットプレイスリポジトリを追加または更新のためにクローンする際、[Git LFS](https://git-lfs.com) のコンテンツを一切ダウンロードしません。LFS で追跡されているファイルはポインターファイルとしてチェックアウトされ、追加または更新の出力にその数が表示されます。

`source` オブジェクト内の `skipLfs` フィールドは受け付けられますが、効果はありません。v2.1.274 より前は、`"skipLfs": true` を設定しない限り、Claude Code は LFS コンテンツをダウンロードしていました。

`url` ソースでは、`headers` 内の認証情報に有効期限があり、新しい認証情報をコマンドで生成する必要がある場合に、`source` オブジェクト内で `headersHelper` を設定します。Claude Code v2.1.238 以降が必要です。コマンドが出力すべき内容と Claude Code がそれを実行する場所については、[headersHelper コマンドを作成する](https://code.claude.com/docs/ja/plugins/host-marketplace.md#write-the-headershelper-command)を、Claude Code がそれを実行しないケースについては、[Claude Code が headersHelper コマンドをスキップする場合](https://code.claude.com/docs/ja/plugins/host-marketplace.md#when-claude-code-skips-a-headershelper-command-or-drops-its-output)を参照してください。`https://` のマーケットプレイス URL に `headersHelper` を設定すると、Claude Code は次の 2 つのタイミングでコマンドを実行し、1 回の実行の出力を最大 60 秒間再利用します。

* そのマーケットプレイスの `marketplace.json` を取得する前（後のリフレッシュを含む）。Claude Code は出力されたヘッダーをその取得リクエストとともに送信します。
* マーケットプレイス URL のオリジン（同じスキーム、ホスト、ポート）上の各プラグインアーカイブをダウンロードする前。Claude Code は出力をそのダウンロードとともに送信し、それ以外のダウンロードにはヘッダーは付与されません。

[`--add-dir`](https://code.claude.com/docs/ja/permissions#what-runs-before-you-trust-a-folder) で追加したディレクトリの `.claude/settings.json` または `.claude/settings.local.json` に設定された `headersHelper` は、`url` ソースでもインラインプラグインエントリでも Claude Code によって無視され、そのファイルに設定された固定の `headers` のみが送信されます。その他の設定ファイルについては、[ユーザーが headersHelper コマンドを承認する方法](https://code.claude.com/docs/ja/plugins/host-marketplace.md#how-users-accept-a-headershelper-command)で説明しています。

`settings` ソースに記載するプラグインは GitHub や npm などの外部ソースを参照する必要があり、`name` はマーケットプレイスのキーと一致する必要があります。各プラグインは引き続き `enabledPlugins` で個別に有効にします。この例では、1 つのプラグインをインラインで宣言します。

```json settings.json theme={null}
{
  "extraKnownMarketplaces": {
    "team-tools": {
      "source": {
        "source": "settings",
        "name": "team-tools",
        "plugins": [
          {
            "name": "code-formatter",
            "source": {
              "source": "github",
              "repo": "acme-corp/code-formatter"
            }
          }
        ]
      }
    }
  }
}
```

`source: 'settings'` 配下のプラグインエントリで、自身の `source` が [`archive`](https://code.claude.com/docs/ja/plugins/marketplace-reference#archive-plugin-source) であるものは、アーカイブのダウンロード用に `headers` を設定できます。`headers` に指定する値の有効期間が短い場合（レジストリがリクエストに応じて発行するトークンなど）は、代わりに `headersHelper` コマンドを設定してください。エントリでは両方を設定することもできます。どちらのフィールドにも Claude Code v2.1.238 以降が必要です。

Claude Code は、エントリの `headers` とコマンドが出力した内容を、そのプラグインのアーカイブのダウンロードとともに送信し、それ以外のダウンロードには送信しません。Claude Code がコマンドを実行するのは、ユーザーが[そのプラグイン 1 つだけを単独でインストールまたは更新する](https://code.claude.com/docs/ja/plugins/host-marketplace.md#how-users-accept-a-headershelper-command)場合のみです。さらに、エントリがどのファイルにあるかによって次の 3 つのルールが適用されます。

* **`strict`**: マーケットプレイスの `marketplace.json` 内のエントリとは異なり、設定内のエントリには `"strict": false` は不要です。設定ファイルにはインライン化するマニフェストフィールドがないためです。[Strict モード](https://code.claude.com/docs/ja/plugins/marketplace-reference.md#strict-mode)を参照してください。
* **フォルダの信頼**: プロジェクトの `.claude/settings.json` または `.claude/settings.local.json` 内のエントリについては、ユーザーが[そのフォルダを信頼](https://code.claude.com/docs/ja/permissions.md#what-runs-before-you-trust-a-folder)した後にのみ、Claude Code はコマンドを実行します。
* **ヘッダーフィルター**: リポジトリがプロジェクトの `.claude/settings.json` や `.claude/settings.local.json` を提供できるため、Claude Code はそれらのファイル内のエントリから[リクエストのルーティングやクライアントの識別に関するヘッダー名](https://code.claude.com/docs/ja/plugins/host-marketplace.md#when-claude-code-skips-a-headershelper-command-or-drops-its-output)を削除します。Claude Code はカタログエントリと `--add-dir` ディレクトリの設定内のエントリにも同じフィルターを適用し、ユーザー設定、`--settings` ファイル、管理設定内のエントリにはフィルターを適用しません。

#### マーケットプレイスキーのエイリアス

Claude Code v2.1.232 以降では、`extraKnownMarketplaces` を `additionalMarketplaces` と、`strictKnownMarketplaces` を `allowedMarketplaces` と記述できます。Claude Code は各エイリアスを次のように扱います。

* それより前のバージョンはエイリアスを無視します。そのため、Claude Code のバージョンが混在するフリート向けの管理設定ファイルなど、古いバージョンも読み込むファイルでは正規の表記を使用してください。
* 正規のキーを受け付ける任意の設定ファイルで、Claude Code はエイリアスを正規のキーとまったく同じように読み込みます。
* Claude Code はファイルを更新する際に、`additionalMarketplaces` を `extraKnownMarketplaces` に書き換えることがあります。
* 1 つのファイルで両方の表記を設定した場合、Claude Code は正規のキーの値を使用し、エイリアスを無視します。

### `pluginConfigs`

プラグインの [`userConfig`](https://code.claude.com/docs/ja/plugins/manifest-reference#user-configuration) 設定ダイアログで入力した機密性のない回答を、プラグイン ID をキーとして保存します。ダイアログに入力すると Claude Code がこのキーをユーザー設定に書き込むため、手動で編集する必要はありません。機密性のあるオプションは Claude Code が代わりに macOS キーチェーンに保存し、キーチェーンが書き込みを拒否した場合は `~/.claude/.credentials.json` にフォールバックします。サポートされているキーチェーンがないプラットフォームでは、`~/.claude/.credentials.json` に保存します。

* **スコープ**: [`ユーザーまたは管理`](#scopes)
* **型**: プラグイン ID を、`options` フィールド（各オプション名を文字列、数値、Boolean、または文字列の配列にマッピング）と、同じ形式でサーバーごとのユーザー設定値を保持するオプションの `mcpServers` フィールドを持つオブジェクトにマッピングするオブジェクト
* **デフォルト**: 未設定

この例では、`acme-tools` の `deployer` プラグインの `api_endpoint` オプションを保存します。

```json settings.json theme={null}
{
  "pluginConfigs": {
    "deployer@acme-tools": {
      "options": {
        "api_endpoint": "https://api.example.com"
      }
    }
  }
}
```

組み込みプラグインは、`@builtin` サフィックスを付けた同じキーの下にオプションを保存します。たとえば、Claude Code が `AGENTS.md` ファイルを読み込むかどうかを制御する [**Project instructions**](https://code.claude.com/docs/ja/memory.md#choose-which-instruction-files-load) 設定は `pluginConfigs["cc-plugin-agents-md@builtin"].options.instructionFiles` です。v2.1.285 より前は、このプラグインの ID は `agents-md@builtin` でした。それ以降のバージョンは、どちらの ID のエントリも読み込みます。

Claude Code はプロジェクトとローカルのエントリを無視します。これらの値はプラグインのフック、MCP、LSP の設定に代入されるため、クローンしたリポジトリがそれらを提供できてはならないからです。

### `prependPlugins`

ユーザーがインストールしたすべての mod より前に、記載順で [mod](https://code.claude.com/docs/ja/plugins/mods/overview.md) が実行される管理対象プラグインを列挙します。このキーを管理設定で設定する場合は、組み込みガードを維持するためにリストに `sec-default@builtin` を含めてください。管理設定では、Claude Code は組織のものとみなされないプラグインの id をスキップします。その条件と、2 つの順序指定キーがどのように連携するかについては、[組織の mod をインストールして順序を設定する](https://code.claude.com/docs/ja/plugins/mods/admin.md#install-your-organizations-mods)を参照してください。

* **スコープ**: [`ユーザーまたは管理`](#scopes)。Claude Code は管理設定からこのキーを読み込みます。ユーザー設定からこのキーを読み込むのは、管理設定のないマシンで、認証情報が Team または Enterprise の `/login` ではないセッションの場合のみです。プロジェクト設定、ローカル設定、および `--settings` ファイル内のこのキーは無視します。
* **型**: `plugin-name@marketplace-name` 文字列の配列
* **デフォルト**: 未設定

```json managed-settings.json theme={null}
{
  "extraKnownMarketplaces": {
    "acme-tools": {
      "source": { "source": "directory", "path": "/opt/acme/claude-plugins" }
    }
  },
  "enabledPlugins": { "acme-guard@acme-tools": true },
  "prependPlugins": ["acme-guard@acme-tools", "sec-default@builtin"]
}
```

### `appendPlugins`

ユーザーがインストールしたすべての mod の後に、記載順で [mod](https://code.claude.com/docs/ja/plugins/mods/overview.md) が実行される管理対象プラグインを列挙します。`prependPlugins` と `appendPlugins` の両方に記載された id は先頭に追加されます。管理設定では、Claude Code は[組織のものとみなされない](https://code.claude.com/docs/ja/plugins/mods/admin.md#install-your-organizations-mods)プラグインの id をスキップします。

* **スコープ**: [`ユーザーまたは管理`](#scopes)。Claude Code は管理設定からこのキーを読み込みます。ユーザー設定からこのキーを読み込むのは、管理設定のないマシンで、認証情報が Team または Enterprise の `/login` ではないセッションの場合のみです。プロジェクト設定、ローカル設定、および `--settings` ファイル内のこのキーは無視します。
* **型**: `plugin-name@marketplace-name` 文字列の配列
* **デフォルト**: 未設定

```json managed-settings.json theme={null}
{
  "extraKnownMarketplaces": {
    "acme-tools": {
      "source": { "source": "directory", "path": "/opt/acme/claude-plugins" }
    }
  },
  "enabledPlugins": { "acme-audit@acme-tools": true },
  "appendPlugins": ["acme-audit@acme-tools"]
}
```

## MCP

Claude Code が接続する MCP サーバーと、組織が許可する MCP サーバーを制御します。[MCP で外部ツールに接続する](https://code.claude.com/docs/ja/mcp.md)と[管理対象 MCP 設定](https://code.claude.com/docs/ja/managed-mcp.md)を参照してください。

### `allowAllClaudeAiMcps`

Claude Code が自身で取得する[claude.ai コネクタ](https://code.claude.com/docs/ja/mcp.md#use-mcp-servers-from-claude-ai)を、デプロイされた `managed-mcp.json` と一緒に読み込みます。このキーがない場合、`managed-mcp.json` は MCP サーバーを排他的に制御し、これらのコネクタを抑制します。

* **スコープ**: [`Managed`](#scopes)。ユーザーは排他的制御によって抑制されたコネクタを再度有効にすることはできません。
* **タイプ**: ブール値
  * `true`: Claude Code は、デプロイされた `managed-mcp.json` と一緒に claude.ai コネクタを読み込みます
  * `false`: デプロイされた `managed-mcp.json` は MCP サーバーを排他的に制御し、Claude Code が自身で取得する[claude.ai コネクタ](https://code.claude.com/docs/ja/mcp.md#how-connectors-reach-claude-code)を抑制します
* **デフォルト**: `false`。デプロイされた `managed-mcp.json` は Claude Code が自身で取得する claude.ai コネクタを抑制します

```json managed-settings.json theme={null}
{
  "allowAllClaudeAiMcps": true
}
```

[`allowedMcpServers`](#allowedmcpservers)と[`deniedMcpServers`](#deniedmcpservers)は、このキーが読み込むコネクタにも適用されます。`managed-mcp.json` を持つホスト（自己ホスト型ランナーなど）の[クラウドセッション](https://code.claude.com/docs/ja/claude-code-on-the-web.md)に配信されるコネクタは、抑制されたままです。[管理対象セットと一緒に claude.ai コネクタを許可する](https://code.claude.com/docs/ja/managed-mcp.md#allow-claude-ai-connectors-alongside-the-managed-set)を参照してください。

### `allowClaudeInChromeWithManagedMcp`

デプロイされた `managed-mcp.json` と一緒に、組み込みの[Claude in Chrome](https://code.claude.com/docs/ja/chrome.md)サーバーを実行できるようにします。このキーがない場合、デプロイされた `managed-mcp.json` はターミナルセッションで Claude in Chrome をブロックします。Claude Code v2.1.282 以降が必要です。

* **スコープ**: [`Managed`](#scopes)。デバイス自身の管理設定からのみ。MDM でデプロイされた plist または HKLM レジストリキー、またはシステム `managed-settings.json` ファイル。Claude Code はサーバー管理設定、ユーザー書き込み可能な HKCU レジストリ、およびユーザーまたはプロジェクト設定では無視します。
* **タイプ**: ブール値
  * `true`: 組み込みの Claude in Chrome サーバーは、デプロイされた `managed-mcp.json` と一緒に実行できます
  * `false`: デプロイされた `managed-mcp.json` はターミナルセッションで Claude in Chrome をブロックします
* **デフォルト**: `false`。デプロイされた `managed-mcp.json` はターミナルセッションで Claude in Chrome をブロックします

```json managed-settings.json theme={null}
{
  "allowClaudeInChromeWithManagedMcp": true
}
```

`claude-in-chrome` の[`deniedMcpServers`](#deniedmcpservers)エントリは、このキーがオンの場合でもサーバーをブロックします。[管理対象セットと一緒に Claude in Chrome を許可する](https://code.claude.com/docs/ja/managed-mcp.md#allow-claude-in-chrome-alongside-the-managed-set)を参照してください。

### `allowedMcpServers`

ユーザーが追加できる MCP サーバーをホワイトリストに登録します。Claude Code は、プラグインサーバー、`--mcp-config` で渡されたサーバー、claude.ai からのサーバーを含め、どこで定義されていても、エントリに一致しないサーバーをブロックします。

Claude in Chrome、実行中の[VS Code](https://code.claude.com/docs/ja/vs-code.md#the-built-in-ide-mcp-server)または[JetBrains](https://code.claude.com/docs/ja/jetbrains.md#the-built-in-ide-mcp-server) IDE に Claude Code が接続する `ide` サーバー、CLI 自体が設定するサーバーなどの組み込みサーバーは、ホワイトリストから除外され、デニーリストは引き続きこれらに適用されます。Claude Code v2.1.268 以降では、[Claude Tag](https://code.claude.com/docs/ja/claude-tag.md)セッションの Slack ツールもホワイトリストから除外され、デニーリストは引き続きこれらに適用されます。インプロセス `type: "sdk"` サーバーは両方のリストから除外されます。[セッションを開始したアプリ](https://code.claude.com/docs/ja/mcp.md#how-connectors-reach-claude-code)がこれらを登録します。

組織が配信するサーバーも許可リストから除外され、拒否リストは引き続きこれらに適用されます。この除外は、すべての[`managedMcpServers`](#managedmcpservers)エントリと、値が[`env` 以外で `${VAR}` 展開を使用しない](https://code.claude.com/docs/ja/managed-mcp#how-allowlists-and-denylists-apply-to-the-managed-set)[`managed-mcp.json`](https://code.claude.com/docs/ja/managed-mcp#exclusive-control-with-managed-mcp-json)エントリをカバーします。完全なチェック順序については、[サーバーの評価方法](https://code.claude.com/docs/ja/managed-mcp.md#how-a-server-is-evaluated)を参照してください。v2.1.259 より前では、`managed-mcp.json` からのサーバーも一致する必要がありました。

* **スコープ**: [`Any file`](#scopes)。[`allowManagedMcpServersOnly`](#allowmanagedmcpserversonly)が設定されていない限り、すべてのファイルからのエントリが 1 つのホワイトリストにマージされます。管理設定にデプロイして、これを強制します。
* **型**: オブジェクトの配列で、各オブジェクトはキーを 1 つだけ持ちます。英字、数字、ハイフン、アンダースコアのみで構成される文字列の `serverName`、コマンドとその引数を完全一致で照合する配列の `serverCommand`、または `*` ワイルドカードを使用する URL パターンの `serverUrl` のいずれかを使用します
* **デフォルト**: 未設定。すべてのサーバーが許可されます。空の配列は、ユーザーが追加するすべてのサーバーをブロックします

この例は、リストされた `npx` コマンドが開始する stdio サーバーのみを許可します。

```json settings.json theme={null}
{
  "allowedMcpServers": [
    { "serverCommand": ["npx", "-y", "@modelcontextprotocol/server-filesystem"] }
  ]
}
```

[`deniedMcpServers`](#deniedmcpservers)エントリが優先されるため、両方のリストにあるサーバーはブロックされます。リストに `serverCommand` エントリが含まれると、stdio サーバーは `serverCommand` エントリと一致する必要があり、`serverUrl` エントリが含まれると、リモートサーバーは `serverUrl` エントリと一致する必要があります。`serverName` の一致は、その種類のサーバーをもはや許可しません。[ホワイトリストとデニーリストを使用したポリシーベースの制御](https://code.claude.com/docs/ja/managed-mcp.md#policy-based-control-with-allowlists-and-denylists)を参照してください。

### `allowManagedMcpServersOnly`

管理対象の許可リストのみを適用対象にします。Claude Code は、管理設定からのみ [`allowedMcpServers`](#allowedmcpservers) を読み込み、ユーザー、プロジェクト、ローカル設定の許可リストを無視します。[`deniedMcpServers`](#deniedmcpservers)は引き続きすべての設定スコープからマージされるため、ユーザーは自分自身のためにサーバーをブロックできます。管理者は、ユーザー自身の設定が管理対象の許可リストが許可するものを拡大できないようにするために、これを設定します。

* **スコープ**: [`Managed`](#scopes)
* **タイプ**: ブール値
  * `true`: Claude Code は管理設定からのみ `allowedMcpServers` を読み込み、ユーザー、プロジェクト、ローカル設定のホワイトリストを無視します
  * `false`: すべての設定スコープのホワイトリストがマージされます
* **デフォルト**: `false`。すべての設定スコープのホワイトリストがマージされます

この例は、ホワイトリストを管理設定にロックし、`github` という名前のサーバーのみを許可します。

```json managed-settings.json theme={null}
{
  "allowManagedMcpServersOnly": true,
  "allowedMcpServers": [
    { "serverName": "github" }
  ]
}
```

ユーザーは引き続き独自の MCP サーバーを追加できます。管理対象ホワイトリストと一致するサーバーのみが読み込まれます。[ホワイトリストを管理設定のみに制限する](https://code.claude.com/docs/ja/managed-mcp.md#restrict-the-allowlist-to-managed-settings-only)を参照してください。

### `deniedMcpServers`

特定の MCP サーバーをブロックします。Claude Code は、プラグインサーバー、`--mcp-config` で渡されたサーバー、`managed-mcp.json` からのサーバー、[`managedMcpServers`](#managedmcpservers)からのサーバー、および[自身で取得する](https://code.claude.com/docs/ja/mcp.md#how-connectors-reach-claude-code)claude.ai コネクタを含め、どこで定義されていても、一致するサーバーの読み込みを拒否します。インプロセス `type: "sdk"` サーバーは除外されます。セッションを開始したアプリがこれらを登録します。

* **スコープ**: [`Any file`](#scopes)。すべてのファイルからのエントリが 1 つのデニーリストにマージされ、[`allowManagedMcpServersOnly`](#allowmanagedmcpserversonly)はこれを変更しません。管理設定にデプロイして、これを強制します。
* **タイプ**: オブジェクトの配列。各オブジェクトは正確に 1 つのキーを持ちます。`serverName` は文字列です。`"claude.ai Slack"` などの claude.ai コネクタの表示名が機能します。`serverCommand` は、コマンドとその引数を正確に一致させた配列です。または `serverUrl` は、`*` ワイルドカードを含む URL パターンです
* **デフォルト**: 未設定。サーバーはブロックされません。空の配列も何もブロックしません

```json settings.json theme={null}
{
  "deniedMcpServers": [
    { "serverName": "filesystem" }
  ]
}
```

デニーリストは[`allowedMcpServers`](#allowedmcpservers)より優先されるため、両方のリストにあるサーバーはブロックされます。[ホワイトリストとデニーリストを使用したポリシーベースの制御](https://code.claude.com/docs/ja/managed-mcp.md#policy-based-control-with-allowlists-and-denylists)を参照してください。

### `disableClaudeAiConnectors`

[Claude Code が自身で取得する](https://code.claude.com/docs/ja/mcp.md#how-connectors-reach-claude-code)[claude.ai MCP コネクタ](https://code.claude.com/docs/ja/mcp.md#use-mcp-servers-from-claude-ai)をオフにして、取得も接続もしません。任意の設定ファイルで `true` が適用されます。チェックインされたプロジェクト `.claude/settings.json` はリポジトリをこれらのコネクタから除外できますが、プロジェクトレベルの `false` はユーザーレベルまたは管理レベルの `true` をオーバーライドできません。

* **スコープ**: [`Any file`](#scopes)
* **タイプ**: ブール値
  * `true`: Claude Code はこれらのコネクタを取得も接続もしません
  * `false`: 未設定と同じです。別の設定ファイルまたは `ENABLE_CLAUDEAI_MCP_SERVERS` がこれらをオフにしない限り、Claude Code はコネクタを取得します
* **デフォルト**: `false`。Claude Code はコネクタを取得します
* **セッションごとのオーバーライド**: [`ENABLE_CLAUDEAI_MCP_SERVERS`](https://code.claude.com/docs/ja/env-vars)を `false` に設定すると、1 つのセッションのコネクタがオフになります。2 つのうちどちらがオフにしても、もう一方はオンに戻すことはできません

```json settings.json theme={null}
{
  "disableClaudeAiConnectors": true
}
```

`--mcp-config` で明示的に渡すサーバーは影響を受けません。すべてのコネクタをブロックする代わりに個別のコネクタをブロックするには、[`deniedMcpServers`](#deniedmcpservers)を使用します。[claude.ai コネクタを無効にする](https://code.claude.com/docs/ja/mcp.md#disable-claude-ai-connectors)を参照してください。

### `disabledMcpjsonServers`

プロジェクトの `.mcp.json` ファイルで定義された特定のサーバーを拒否して、Claude Code がこれらに接続したり、承認を求めたりしないようにします。任意の設定ファイルでの拒否が適用されます。リポジトリにチェックインされたプロジェクト `.claude/settings.json` を含みます。

* **スコープ**: [`Any file`](#scopes)
* **タイプ**: 文字列の配列。`.mcp.json` に表示されるサーバー名
* **デフォルト**: 未設定

```json settings.json theme={null}
{
  "disabledMcpjsonServers": ["filesystem"]
}
```

Claude Code は、承認ダイアログでサーバーを拒否すると、このキーを `.claude/settings.local.json` に書き込みます。`claude mcp get <name>` は、拒否されたサーバーを `✘ Rejected (see disabledMcpjsonServers in settings)` として表示します。拒否は[`enabledMcpjsonServers`](#enabledmcpjsonservers)と[`enableAllProjectMcpServers`](#enableallprojectmcpservers)より優先されます。

### `enableAllProjectMcpServers`

プロジェクト `.mcp.json` ファイルで定義されたすべての MCP サーバーをプロンプトなしで承認します。Claude Code は、承認ダイアログですべてのサーバーを承認することを選択すると、このキーを `.claude/settings.local.json` に書き込みます。

* **スコープ**: [`Any file`](#scopes)。信頼ダイアログを受け入れていないフォルダでは、Claude Code はユーザー設定、管理設定、`--settings` からこれを尊重し、共有プロジェクトファイルではセッション内と `claude mcp list` および `claude mcp get` で無視します。[プロジェクトサーバーの承認とワークスペースの信頼](https://code.claude.com/docs/ja/mcp.md#project-server-approvals-and-workspace-trust)は、追跡されていない `.claude/settings.local.json` がいつカウントされるかを説明しています。
* **タイプ**: ブール値
  * `true`: Claude Code はプロジェクト `.mcp.json` ファイルで定義されたすべての MCP サーバーをプロンプトなしで承認します
  * `false`: Claude Code は各サーバーの承認を求めます。信頼されたフォルダでは、優先度の高いファイルの `false` は優先度の低いファイルの `true` をオーバーライドします。信頼していないフォルダでは、尊重されるファイルの `true` で十分です
* **デフォルト**: 未設定。Claude Code は各サーバーの承認を求めます

```json settings.json theme={null}
{
  "enableAllProjectMcpServers": true
}
```

[`disabledMcpjsonServers`](#disabledmcpjsonservers)エントリはサーバーを拒否します。

### `enabledMcpjsonServers`

プロジェクト `.mcp.json` ファイルで定義された特定のサーバーを承認して、Claude Code が質問なしにこれらに接続します。Claude Code は、承認ダイアログでサーバーを承認すると、このキーを `.claude/settings.local.json` に書き込みます。

* **スコープ**: [`Any file`](#scopes)。信頼ダイアログを受け入れていないフォルダでは、Claude Code はユーザー設定、管理設定、`--settings` からこれを尊重し、共有プロジェクトファイルではセッション内と `claude mcp list` および `claude mcp get` で無視します。[プロジェクトサーバーの承認とワークスペースの信頼](https://code.claude.com/docs/ja/mcp.md#project-server-approvals-and-workspace-trust)は、追跡されていない `.claude/settings.local.json` がいつカウントされるかを説明しています。
* **タイプ**: 文字列の配列。`.mcp.json` に表示されるサーバー名
* **デフォルト**: 未設定

この例は、プロジェクトの `.mcp.json` から `memory` および `github` サーバーを承認します。

```json settings.json theme={null}
{
  "enabledMcpjsonServers": ["memory", "github"]
}
```

[`disabledMcpjsonServers`](#disabledmcpjsonservers)エントリはサーバーを拒否します。

### `managedMcpServers`

管理設定からすべてのユーザーにリモート MCP サーバーを提供します。ユーザーは自分たちが追加したサーバーを保持し、提供されたサーバーを編集または削除することはできません。Claude Code v2.1.259 以降が必要です。

* **スコープ**: [`Managed`](#scopes)。Claude Code はユーザー、プロジェクト、ローカル設定でキーを警告とともにドロップし、Claude Desktop アプリのコードタブでサードパーティデプロイメント上で、またはアプリの Cowork セッションで読み込みません。Claude Desktop はこれらのセッションの MCP サーバーを供給してロックします。
* **タイプ**: サーバー名でキー付けされたオブジェクト。各エントリは `http` または `sse` サーバーの `.mcp.json` 形状を持ちます。必須の `https://` `url` と、オプションで `headers`、`oauth`、その他の HTTP および SSE オプション。Claude Code は検証に失敗したエントリをドロップし、[エントリに含まれる内容](https://code.claude.com/docs/ja/managed-mcp.md#what-an-entry-can-contain)は条件をリストします
* **デフォルト**: 未設定。管理設定はサーバーを提供しません

この例は、`search` という名前の 1 つの HTTP サーバーを提供します。

```json managed-settings.json theme={null}
{
  "managedMcpServers": {
    "search": {
      "type": "http",
      "url": "https://search.example.com/mcp"
    }
  }
}
```

優先度、提供されたサーバーが `managed-mcp.json` および許可リストと拒否リストとどのように組み合わされるか、およびユーザーが何を見るかについては、[管理設定を通じてサーバーを提供する](https://code.claude.com/docs/ja/managed-mcp.md#provide-servers-through-managed-settings)を参照してください。

## エージェント、セッション、worktree

デフォルトエージェントを設定し、チームメイトとクロスセッションメッセージングを制御し、worktree を設定します。[サブエージェント](https://code.claude.com/docs/ja/sub-agents.md)と [worktree](https://code.claude.com/docs/ja/worktrees.md) を参照してください。

### `agent`

メインスレッドを名前付き[サブエージェント](https://code.claude.com/docs/ja/sub-agents.md#invoke-subagents-explicitly)として実行し、Claude Code がそのサブエージェントのシステムプロンプト、ツール制限、およびモデルをセッションに適用するようにします。同じキーは `claude agents` からディスパッチするセッションのデフォルトエージェントも設定します。

* **スコープ**: [`任意のファイル`](#scopes)
* **タイプ**: 文字列、組み込みまたはカスタムエージェントの名前
* **デフォルト**: 未設定。メインスレッドは Claude Code のデフォルトエージェントとして実行されます
* **セッションごとの上書き**: `--agent` はこのキーより優先され、1 つのセッションに適用されます

```json settings.json theme={null}
{
  "agent": "code-reviewer"
}
```

プラグイン独自の `settings.json` もこのキーを提供できます。[プラグインでデフォルト設定を配布する](https://code.claude.com/docs/ja/plugins/components.md#default-settings)を参照してください。

### `crossSessionInbound`

このセッションが[他の Claude Code セッションから到着するメッセージ](https://code.claude.com/docs/ja/cross-session-messaging.md#control-inbound-messages)に対して何を行うかを選択します。値が適用されない場合、Claude Code は 2 つのセッションの権限モードクラスからメッセージごとに決定します。Claude Code v2.1.224 以降が必要です。

* **スコープ**: [`任意のファイル`](#scopes)。プロジェクトまたはローカル値は、管理設定、`--settings` フラグ、またはユーザー設定が提供する値より厳密な場合にのみ適用されます。
* **タイプ**: 文字列、以下のいずれか：
  * `"accept"`: Claude Code はメッセージを Claude に配信します
  * `"hold"`: Claude Code はメッセージの通知を表示しますが、配信しません
  * `"refuse"`: Claude Code はメッセージを破棄します
* **デフォルト**: 未設定。Claude Code はメッセージごとに決定します

```json settings.json theme={null}
{
  "crossSessionInbound": "hold"
}
```

Claude Code は管理設定を最初に読み込み、次に `--settings` フラグ、その後ユーザー設定を読み込み、最初に見つかった値を適用します。`refuse` は `hold` より厳密で、`hold` は `accept` より厳密です。信頼できるソースのいずれもが値を設定しない場合、プロジェクトまたはローカルの `hold` または `refuse` は依然として適用され、メッセージごとのデフォルトを置き換えます。クロスセッションメッセージングを使用するセッションでは、このキーは `/config` に**他のセッションからのメッセージ**として表示され、ユーザー設定に書き込まれます。この行には Claude Code v2.1.232 以降が必要で、`--settings` フラグまたは管理設定がキーを設定している間、Claude Code はそれを非表示にします。

Claude Code は、認識しない値を設定すると[警告](https://code.claude.com/docs/ja/errors.md#crosssessioninbound-must-be-one-of-accept-hold-refuse)します。その値がユーザー、プロジェクト、ローカル、または `--settings` ファイルに存在する間、Claude Code は受信メッセージを保留します。優先されるソースが `accept` を設定している場合でも、です。別のソースが設定する `refuse` は依然として適用されます。値を修正または削除して保留をクリアします。

認識しない値が[管理設定](https://code.claude.com/docs/ja/managed-settings.md)にある場合、Claude Code は代わりに管理者が修正するまで `refuse` として扱います。v2.1.248 より前では、Claude Code は警告なしに認識しない値を無視していました。

### `disableAgentView`

[バックグラウンドエージェントとエージェントビュー](https://code.claude.com/docs/ja/agent-view.md)をオフにします：`claude agents`、`--bg`、`/background`、およびオンデマンドスーパーバイザー。[管理設定](https://code.claude.com/docs/ja/managed-settings.md)で設定して、組織に対して強制します。

* **スコープ**: [`任意のファイル`](#scopes)
* **タイプ**: ブール値
  * `true`: Claude Code は `claude agents`、`--bg`、`/background`、およびオンデマンドスーパーバイザーをオフにします
  * `false`: エージェントビューが利用可能です
* **デフォルト**: 未設定。エージェントビューが利用可能です
* **セッションごとの上書き**: [`CLAUDE_CODE_DISABLE_AGENT_VIEW`](https://code.claude.com/docs/ja/env-vars) は 1 つのセッションのエージェントビューをオフにします。2 つのいずれかがそれをオフにすると、もう一方はそれをオンに戻すことはできません

```json settings.json theme={null}
{
  "disableAgentView": true
}
```

### `isolatePeerMachines`

Claude の `SendMessage` がこのマシンを超えたセッションの 1 つに到達する前に、明示的な承認を要求します。[クロスマシンメッセージの承認を要求する](https://code.claude.com/docs/ja/cross-session-messaging.md#require-approval-for-cross-machine-messages)を参照してください。承認プロンプトは [`bypassPermissions` モード](https://code.claude.com/docs/ja/permission-modes#skip-all-checks-with-bypasspermissions-mode)でも表示されます。

* **スコープ**: [`任意のファイル`](#scopes)。任意のスコープからの `true` が適用されるため、チェックインされたプロジェクトファイルは要件をオンにできますがオフにはできません。
* **タイプ**: ブール値
  * `true`: Claude Code は Claude の `SendMessage` がこのマシンを超えたセッションの 1 つに到達する前に承認を求めます
  * `false`: クロスマシンメッセージはプロンプトを表示しません
* **デフォルト**: 未設定。クロスマシンメッセージはプロンプトを表示しません

```json settings.json theme={null}
{
  "isolatePeerMachines": true
}
```

クロスマシン `SendMessage` 承認には Claude Code v2.1.224 以降が必要です。

### `processWrapper`

macOS と Linux では、[Claude Code が開始するバックグラウンドプロセス](https://code.claude.com/docs/ja/corporate-launcher.md#what-the-launcher-covers)の前に企業ランチャーコマンドを配置します。Claude Code はランチャーを独自のコマンドラインを追加して実行するため、ランチャーは Claude Code に exec する必要があります。[企業ランチャーの背後で Claude Code を実行する](https://code.claude.com/docs/ja/corporate-launcher.md)を参照してランチャーコントラクトを確認してください。Claude Code v2.1.210 以降が必要です。

* **スコープ**: [`ユーザーまたは管理`](#scopes)
* **タイプ**: 文字列、argv プレフィックスとしてのランチャーコマンド（絶対パスとオプション引数など）
* **デフォルト**: 未設定。バックグラウンドプロセスはラップされずに開始されます
* **セッションごとの上書き**: [`CLAUDE_CODE_PROCESS_WRAPPER`](https://code.claude.com/docs/ja/env-vars) はこのキーより優先され、1 つのセッションに適用されます

```json settings.json theme={null}
{
  "processWrapper": "/opt/corp/launcher --profile claude"
}
```

Claude Code は Windows でランチャーを無視し、すべてのプロセスをラップされずに開始します。Claude Code v2.1.210 以降が必要です。

### `teammateMode`

Claude Code が[エージェントチーム](https://code.claude.com/docs/ja/agent-teams.md)のチームメイトを表示する場所を選択します：メインターミナルペイン内、またはターミナルがサポートしている場合は分割ペイン内。[表示モードを選択する](https://code.claude.com/docs/ja/agent-teams.md#choose-a-display-mode)を参照してください。

* **スコープ**: [`任意のファイル`](#scopes)。Claude Code は古いバージョンによって `~/.claude.json` に残された値も読み込みます。
* **タイプ**: 文字列、以下のいずれか：
  * `"in-process"`: チームメイトはメインターミナルペイン内で実行されます
  * `"auto"`: tmux 内で実行している場合、または `PATH` に `it2` がある iTerm2 内で実行している場合、または tmux がインストールされている場合は分割ペイン。それ以外の場合はインプロセス
  * `"tmux"`: ターミナルから検出された tmux または iTerm2 を使用して分割ペイン
  * `"iterm2"`: `it2` CLI を通じた iTerm2 ネイティブ分割ペイン
* **デフォルト**: `"in-process"`
* **セッションごとの上書き**: `--teammate-mode` はこのキーより優先され、1 つのセッションに適用されます

```json settings.json theme={null}
{
  "teammateMode": "auto"
}
```

### `worktree`

Claude Code が `--worktree`、`EnterWorktree` ツール、および分離されたサブエージェントとバックグラウンドセッションの [git worktree](https://code.claude.com/docs/ja/worktrees.md) を作成および管理する方法を設定します。

* **スコープ**: [`任意のファイル`](#scopes)
* **タイプ**: `baseRef`、`symlinkDirectories`、`sparsePaths`、および `bgIsolation` を含むオブジェクト
* **デフォルト**: 未設定

この例は、現在の `HEAD` から新しい worktree をブランチし、各 worktree に `node_modules` をシンボリックリンクします：

```json settings.json theme={null}
{
  "worktree": {
    "baseRef": "head",
    "symlinkDirectories": ["node_modules"]
  }
}
```

`.env` のような gitignore されたファイルを新しい worktree にコピーするには、設定の代わりに [`.worktreeinclude` ファイル](https://code.claude.com/docs/ja/worktrees#copy-gitignored-files-into-worktrees)をプロジェクトルートに追加します。

### `worktree.baseRef`

新しい worktree がブランチする ref を選択します。`"fresh"` は `origin/<default-branch>` からブランチして、リモートと一致するクリーンツリーを取得します。`"head"` は現在のローカル `HEAD` からブランチするため、プッシュされていないコミットとフィーチャーブランチの状態が worktree に存在します。

* **スコープ**: [`任意のファイル`](#scopes)
* **タイプ**: 文字列、以下のいずれか：
  * `"fresh"`: 新しい worktree は `origin/<default-branch>` からブランチします
  * `"head"`: 新しい worktree は現在のローカル `HEAD` からブランチします（プッシュされていないコミットを含む）
* **デフォルト**: `"fresh"`

```json settings.json theme={null}
{
  "worktree": {
    "baseRef": "head"
  }
}
```

リンクされた worktree 内では、`"head"` はメインチェックアウトの `HEAD` ではなく、その worktree の `HEAD` に解決されます。

### `worktree.symlinkDirectories`

メインリポジトリからディレクトリを各 worktree にシンボリックリンクして、ディスク上の大きなディレクトリを複製しないようにします。

* **スコープ**: [`任意のファイル`](#scopes)
* **タイプ**: 文字列の配列、リポジトリルートに相対的なディレクトリパス
* **デフォルト**: 未設定。Claude Code はディレクトリをシンボリックリンクしません

この例は、メインリポジトリから `node_modules` と `.cache` をすべての新しい worktree にシンボリックリンクします：

```json settings.json theme={null}
{
  "worktree": {
    "symlinkDirectories": ["node_modules", ".cache"]
  }
}
```

### `worktree.sparsePaths`

git sparse-checkout を通じて各 worktree にリストされたディレクトリのみをチェックアウトします。Claude Code はそれらのディレクトリとルートレベルのファイルのみをディスクに書き込みます。これは大規模なモノレポでより高速です。[必要なディレクトリのみをチェックアウトする](https://code.claude.com/docs/ja/large-codebases.md#check-out-only-the-directories-you-need)を参照してください。

* **スコープ**: [`任意のファイル`](#scopes)
* **タイプ**: 文字列の配列、リポジトリルートに相対的なディレクトリパス
* **デフォルト**: 未設定。各 worktree はツリー全体をチェックアウトします

リストに `.claude` を含めると、各 worktree にもリポジトリの `.claude/settings.json` と `.claude/rules/` が含まれるようになります。この例は、各 worktree で `.claude`、`packages/my-app`、`shared/utils` のみをチェックアウトします（ルートレベルのファイルを含む）：

```json settings.json theme={null}
{
  "worktree": {
    "sparsePaths": [".claude", "packages/my-app", "shared/utils"]
  }
}
```

スパース worktree が存在する間、git はリポジトリの共有 `.git/config` で `extensions.worktreeConfig` を有効にします。

### `worktree.bgIsolation`

[バックグラウンドセッション](https://code.claude.com/docs/ja/agent-view.md#how-file-edits-are-isolated)がファイル編集を分離する方法を選択します。`←` または `/background` でセッションをバックグラウンドに移動した場合、このキーの値にかかわらず、そのセッションはファイルをその場で編集します。`"worktree"` では、Claude Code はセッションが `EnterWorktree` を呼び出すまでメインチェックアウトで `Edit` と `Write` をブロックします。`"none"` では、バックグラウンドジョブはワーキングコピーを直接編集します。git worktree が実用的でないリポジトリの場合は `"none"` を設定します。

* **スコープ**: [`任意のファイル`](#scopes)
* **タイプ**: 文字列、以下のいずれか：
  * `"worktree"`: Claude Code はセッションが `EnterWorktree` を呼び出すまでメインチェックアウトで `Edit` と `Write` をブロックします
  * `"none"`: バックグラウンドジョブはワーキングコピーを直接編集します
* **デフォルト**: `"worktree"`

```json settings.json theme={null}
{
  "worktree": {
    "bgIsolation": "none"
  }
}
```

git リポジトリの外では、失敗する [`WorktreeCreate` フック](https://code.claude.com/docs/ja/worktrees#non-git-version-control)がブロックを解放し、セッションが作業ディレクトリをその場で編集できるようにします。

### `worktree.location`

[Desktop の SSH セッション](https://code.claude.com/docs/ja/desktop.md#choose-where-ssh-session-worktrees-go)が worktree を作成するリモートマシン上のフォルダーを、`<project-root>/.claude/worktrees/` の代わりに選択します。このキーを読み込むのはデスクトップアプリのみです。`--worktree`、`EnterWorktree` ツール、分離されたサブエージェント、およびバックグラウンドセッションはこのキーを無視します。Claude Desktop v1.44121.0 以降が必要です。

* **スコープ**: [`ユーザー`](#scopes)、リモートマシン上の `~/.claude/settings.json` 内
* **タイプ**: 文字列、絶対パスまたは `~/` で始まるパス
* **デフォルト**: 未設定。worktree はプロジェクト内に作成されます

この例はフォルダーを `~/worktrees` に設定します：

```json settings.json theme={null}
{
  "worktree": {
    "location": "~/worktrees"
  }
}
```

Desktop で SSH 接続に設定された **Worktree folder** が優先されます。組織がセッションで使用できるフォルダーを制限している場合、Desktop は worktree をプロジェクト内に保持します。

## リモート、デスクトップ、および通知

Remote Control、クラウド環境、デスクトップアプリ、および Claude Code が必要な場合に送信する通知を設定します。[Remote Control](https://code.claude.com/docs/ja/remote-control.md) を参照してください。

### `agentPushNotifEnabled`

Claude が送信する価値があると判断した場合（たとえば、長いタスクが完了した場合など）に、電話にプッシュ通知を送信することを Claude に許可します。Claude は [Remote Control](https://code.claude.com/docs/ja/remote-control.md) が接続されている間に通知を送信できます。`/config` では **Push when Claude decides** として表示されます。そこで変更すると、Claude Code はその値をアカウントにも保存します。

* **Scope**: [`Any file`](#scopes)。Claude Code は古いバージョンによって `~/.claude.json` に残された値も読み取ります。
* **Type**: Boolean
  * `true`: Claude は価値があると判断した場合に電話にプッシュ通知を送信できます
  * `false`: Claude はそれらの通知を送信しません
* **Default**: `false`

```json settings.json theme={null}
{
  "agentPushNotifEnabled": true
}
```

[`claude remote-control`](https://code.claude.com/docs/ja/remote-control#start-a-remote-control-session) サーバーの下でセッションを実行する場合、それらのセッションはこのキーではなく、アカウントに保存された値に従います。その値を変更するには、ターミナルの Claude Code セッションで `/config` を実行し、**Push when Claude decides** をオンまたはオフにします。トグルがすでに目的の値を示している場合は、一度切り替えてから元に戻し、Claude Code がその値をアカウントに保存するようにします。

[Mobile push notifications](https://code.claude.com/docs/ja/remote-control.md#mobile-push-notifications) を参照してください。

### `awaySummaryEnabled`

数分間離れた後にターミナルに戻ったときに、1 行のセッション要約を表示します。`false` に設定するか、`/config` で **Session recap** をオフにして、要約を停止します。

* **Scope**: [`Any file`](#scopes)
* **Type**: Boolean
  * `true`: 数分間離れた後に戻ったときに、1 行のセッション要約が表示されます
  * `false`: Claude Code は要約を表示しません
* **Default**: 未設定なので、要約はオンです
* **Per-session overrides**: [`CLAUDE_CODE_ENABLE_AWAY_SUMMARY`](https://code.claude.com/docs/ja/env-vars) はこのキーより優先され、どちらの方向でも 1 セッションに適用されます

```json settings.json theme={null}
{
  "awaySummaryEnabled": false
}
```

Claude Code は非対話モードでは要約を表示しません。

### `disableArtifact`

> [!WARNING]
>
> 非推奨であり、[`enableArtifact`](#enableartifact) に置き換えられました。Claude Code は `disableArtifact: true` を `enableArtifact: false` と同等として引き続き尊重し、`disableArtifact: false` は無視します。

代わりに [`enableArtifact`](#enableartifact) を使用して、セッション出力を claude.ai 上のプライベート Web ページとして公開する [Artifact](https://code.claude.com/docs/ja/artifacts.md) ツールをオフにします。`/config` で **Artifacts** 行をオフにすると、Claude Code はユーザー設定に `enableArtifact` を書き込み、このキーをクリアします。

* **Scope**: [`Any file`](#scopes)
* **Type**: Boolean
  * `true`: Claude Code はファイルが適用されるすべてのセッションに対して Artifact ツールをオフにし、他のファイルはそれをオンに戻しません
  * `false`: 無視されます。ツールをオンのままにするには、キーを削除します
* **Default**: 未設定なので、ツールはアカウントの [availability](https://code.claude.com/docs/ja/artifacts.md#availability) に従います
* **Per-session overrides**: [`CLAUDE_CODE_DISABLE_ARTIFACT`](https://code.claude.com/docs/ja/env-vars) を `1` に設定すると、1 つのセッションのツールがオフになります

```json settings.json theme={null}
{
  "disableArtifact": true
}
```

[Disable artifacts](https://code.claude.com/docs/ja/artifacts.md#disable-artifacts) はツールをオフにするすべての方法を一覧表示します。

### `disableDeepLinkRegistration`

Claude Code が `claude-cli://` プロトコルハンドラーをオペレーティングシステムに登録することを停止します。通常、対話セッションの最初のプロンプトを送信した後に登録されます。[Deep links](https://code.claude.com/docs/ja/deep-links.md) により、外部ツールは事前入力されたプロンプトで Claude Code セッションを開くことができます。プロトコルハンドラー登録が制限されているか、別途管理されている環境でこれを設定します。

* **Scope**: [`Any file`](#scopes)
* **Type**: 文字列 `"disable"`
* **Default**: 未設定なので、Claude Code はハンドラーを登録します

```json settings.json theme={null}
{
  "disableDeepLinkRegistration": "disable"
}
```

### `disableDesktopLocalSessions`

開発者が SSH 経由でリモートマシンで作業する必要があるデプロイ向けに、[デスクトップアプリ](https://code.claude.com/docs/ja/desktop.md#local-sessions-on-managed-devices) でデバイス上で実行される Code セッションをオフにします。キーを `true` に設定すると、ユーザーには Code タブで次のように表示されます：

* **環境セレクター**: ユーザーのコンピューターのエントリはグレーアウトされて選択できなくなり、ツールチップ **Disabled by your organization** が表示されます。Windows では WSL エントリも同じようにグレーアウトされますが、WSL セッションが管理対象デバイスで実行されるかどうか自体は [別途管理されます](https://code.claude.com/docs/ja/admin-setup.md#wsl-sessions-in-claude-code-desktop)。
* **新しいセッション**: 設定されている場合は、最初の [SSH 接続](https://code.claude.com/docs/ja/desktop.md#ssh-sessions) がデフォルトになります
* **デバイス上のセッション**: アプリは、同じマシンへの SSH 接続を含め、デバイス上でのセッションの開始または再開を拒否します
* **他のホストへの SSH セッションとクラウドセッション**: 影響を受けません

デスクトップアプリはこのキーを読み取ります。ターミナル CLI は無視します。Claude Desktop v1.37937.0 以降が必要です。

* **Scope**: [`Managed`](#scopes)。デフォルトでは、デスクトップアプリは [1 つの管理ソース](https://code.claude.com/docs/ja/managed-settings.md#how-claude-code-combines-managed-sources) からキーを読み取ります。
* **Type**: Boolean。JSON Boolean `true` のみが有効です
  * `true`: デスクトップアプリはオンデバイスコードセッションを提供しません。既存のローカルセッションはリストに残りますが、続行できません
  * `false`: ローカルセッションは利用可能なままです
* **Default**: 未設定なので、ローカルセッションは利用可能です

```json managed-settings.json theme={null}
{
  "disableDesktopLocalSessions": true
}
```

デスクトップアプリは他の値を無視し、文字列 `"true"` や `1` などの Boolean ではない値も警告をログに記録します。[`sshConfigs`](#sshconfigs) とペアにして、ユーザーが機能する接続にアクセスし、[`sshHostAllowlist`](#sshhostallowlist) とペアにして、到達できるホストを制限します。[Local sessions on managed devices](https://code.claude.com/docs/ja/desktop.md#local-sessions-on-managed-devices) を参照してください。

Claude Desktop は、デスクトップ設定から派生したポリシー（たとえば、エグレス許可リスト、ファイルシステムサンドボックス、サードパーティデプロイメント内の MCP 制限など）を使用して Code セッションを提供します。Claude Code は、[管理ソース](https://code.claude.com/docs/ja/managed-settings.md#how-claude-code-combines-managed-sources) が存在する場合（サーバー管理設定、MDM または OS レベルのポリシー、またはマネージド設定ファイル）、常にそれらの親設定を無視します。サードパーティデプロイメントのように、以前にないデバイスにこのキーをデプロイすると、デスクトップ派生ポリシーが適用されなくなります。[Let an embedding host add policy](https://code.claude.com/docs/ja/managed-settings.md#let-an-embedding-host-add-policy) は、親設定がまだマージできる場合をカバーしています。これは、このキーだけでなく、その方法でデプロイするすべてのキーに適用されます。

### `disableRemoteControl`

[Remote Control](https://code.claude.com/docs/ja/remote-control.md) をオフにします。Claude Code は `claude remote-control`、`--remote-control` フラグ、自動開始、およびセッション内トグルを拒否し、組織のポリシーがそれを無効にしたことを報告します。[マネージド設定](https://code.claude.com/docs/ja/managed-settings.md) に配置して、デバイスごとの MDM 強制を行います。

* **Scope**: [`Any file`](#scopes)
* **Type**: Boolean
  * `true`: Claude Code は `claude remote-control`、`--remote-control` フラグ、自動開始、およびセッション内トグルを拒否します
  * `false`: Remote Control は利用可能なままです
* **Default**: `false`

```json settings.json theme={null}
{
  "disableRemoteControl": true
}
```

### `enableArtifact`

セッション出力を claude.ai 上のプライベート Web ページとして公開する [Artifact](https://code.claude.com/docs/ja/artifacts.md) ツールをオフにします。`/config` で **Artifacts** 行をオフにすると、Claude Code はこのキーをユーザー設定に書き込むため、通常は手動で編集しません。

* **Scope**: [`Any file`](#scopes)。すべてのファイルはツールをオフにでき、どのファイルもそれをオンに戻すことはできません。
* **Type**: Boolean
  * `false`: Claude Code はファイルが適用されるすべてのセッションに対して Artifact ツールをオフにします
  * `true`: キーを未設定のままにするのと同じです。別のファイルからの `false`、[`CLAUDE_CODE_DISABLE_ARTIFACT`](https://code.claude.com/docs/ja/env-vars)、または組織の [管理設定](https://code.claude.com/docs/ja/artifacts.md#manage-artifacts-for-your-organization) をオーバーライドしないためです
* **Default**: 未設定なので、ツールはアカウントの [availability](https://code.claude.com/docs/ja/artifacts.md#availability) に従います

```json settings.json theme={null}
{
  "enableArtifact": false
}
```

ユーザー設定以外のソースがツールをオフのままにしている間、Claude Code は `/config` で **Artifacts** 行を非表示にします。そこでオンにしても何も変わらないためです。[Disable artifacts](https://code.claude.com/docs/ja/artifacts.md#disable-artifacts) はツールをオフにするすべての方法を一覧表示します。

### `inputNeededNotifEnabled`

権限プロンプトまたは質問が入力を待っているときに、電話にプッシュ通知を取得します。Claude Code はこれらを [Remote Control](https://code.claude.com/docs/ja/remote-control.md) が接続されている間のみ送信します。`/config` では **Push when actions required** として表示されます。

* **Scope**: [`Any file`](#scopes)。Claude Code は古いバージョンによって `~/.claude.json` に残された値も読み取ります。
* **Type**: Boolean
  * `true`: Remote Control が接続されている間、権限プロンプトまたは質問が入力を待っているときに、電話にプッシュ通知が届きます
  * `false`: Claude Code はそのような通知を送信しません
* **Default**: `false`

```json settings.json theme={null}
{
  "inputNeededNotifEnabled": true
}
```

[Mobile push notifications](https://code.claude.com/docs/ja/remote-control.md#mobile-push-notifications) を参照してください。

### `preferredNotifChannel`

タスクが完了したときまたは権限プロンプトが待機しているときに Claude Code が通知する方法を選択します。[mod の通知](https://code.claude.com/docs/ja/plugins/mods/api.md#show-something-without-starting-a-turn) も同じ設定を使用します。`/config` では **Local notifications** として表示されます。

* **Scope**: [`Any file`](#scopes)。Claude Code は古いバージョンによって `~/.claude.json` に残された値も読み取ります。
* **Type**: 文字列、以下のいずれか：
  * `"auto"`: Claude Code は iTerm2、Ghostty、Kitty でデスクトップ通知を送信し、Terminal.app でのみ可聴ベルがオフの場合にベルを鳴らし、他の場所では何もしません
  * `"terminal_bell"`: Claude Code は任意のターミナルでベル文字を鳴らします
  * `"iterm2"`: Claude Code は iTerm2 デスクトップ通知を送信します
  * `"iterm2_with_bell"`: Claude Code は iTerm2 デスクトップ通知を送信し、ベルを鳴らします
  * `"kitty"`: Claude Code は Kitty デスクトップ通知を送信します
  * `"ghostty"`: Claude Code は Ghostty デスクトップ通知を送信します
  * `"notifications_disabled"`: Claude Code は通知を送信しません
* **Default**: `"auto"`

```json settings.json theme={null}
{
  "preferredNotifChannel": "terminal_bell"
}
```

`"auto"` では、Claude Code は iTerm2、Ghostty、Kitty でデスクトップ通知を送信します。Terminal.app では、Terminal の可聴ベルをオフにした場合のみベル文字を鳴らし、他のターミナルでは何もしません。任意のターミナルでベル文字を鳴らすには `"terminal_bell"` を設定します。[Get a terminal bell or notification](https://code.claude.com/docs/ja/terminal-config.md#get-a-terminal-bell-or-notification) を参照してください。

### `remote.defaultEnvironmentId`

`claude --cloud` などの CLI から作成するクラウドセッション用のデフォルト [クラウド環境](https://code.claude.com/docs/ja/cloud-environments.md) を選択します。Claude Code は [`/remote-env`](https://code.claude.com/docs/ja/cloud-environments#select-an-environment-from-the-cli) で環境を選択するときに、このキーをユーザー設定に書き込みます。

* **Scope**: [`Any file`](#scopes)。自己ホスト環境 ID の場合、ユーザーまたはマネージド設定、または `--settings` フラグのみ。
* **Type**: 文字列、`env_...` または `ccpool_...` などの環境 ID
* **Default**: 未設定なので、Claude Code はリストに Anthropic ホスト環境がある場合はそれを使用し、そうでない場合は [Remote Control ブリッジ環境](https://code.claude.com/docs/ja/cloud-environments.md#the-default-environment) ではないリスト内の最初の環境を使用するか、すべてがブリッジ環境の場合は最初の環境を使用します
* **Per-session overrides**: `--environment` はこのキーより優先され、作成する 1 つのクラウドセッションに適用されます

```json settings.json theme={null}
{
  "remote": {
    "defaultEnvironmentId": "env_0123abcd"
  }
}
```

`env_` で始まる Anthropic ホスト環境 ID は標準設定の優先度に従うため、リポジトリのプロジェクト設定の値がユーザーレベルの選択をオーバーライドします。`ccpool_` で始まる [自己ホスト環境](https://code.claude.com/docs/ja/self-hosted-environments) ID は、ユーザー設定、マネージド設定、および `--settings` フラグからのみ尊重されます。Claude Code はリポジトリのプロジェクトまたはローカル設定のものを無視し、`/remote-env` は無視した値を表示するため、チェックインされたファイルは選択しなかった自己ホスト環境にセッションをステアリングできません。

### `remoteControlAtStartup`

各対話セッションの開始時に [Remote Control](https://code.claude.com/docs/ja/remote-control.md) を自動的に接続します。`/remote-control` を待つ代わりに。自動接続をオンにするには `true` に設定し、オフにするには `false` に設定します。`/config` では **Enable Remote Control for all sessions** として表示されます。

* **Scope**: [`Any file`](#scopes)。Claude Code は古いバージョンによって `~/.claude.json` に残された値も読み取ります。
* **Type**: Boolean
  * `true`: Claude Code は各対話セッションの開始時に Remote Control を自動的に接続します
  * `false`: Claude Code は `/remote-control` を待ちます
* **Default**: 未設定なので、[自動接続デフォルト](https://code.claude.com/docs/ja/remote-control.md#enable-remote-control-for-all-sessions) が適用されます
* **Per-session overrides**: `--remote-control` はこのキーが `false` の場合でも 1 つのセッションに対して Remote Control をオンにし、フラグは 1 つのセッションに対してそれをオフにしません

```json settings.json theme={null}
{
  "remoteControlAtStartup": true
}
```

Claude Code はプロジェクトまたはローカル設定からの `true` を無視するため、リポジトリはそのチェックアウトの自動接続をオフにできますが、オンにすることはできません。完全なスコープごとの動作については、[Enable Remote Control for all sessions](https://code.claude.com/docs/ja/remote-control.md#enable-remote-control-for-all-sessions) および [より厳密な値が適用されるセキュリティキー](https://code.claude.com/docs/ja/settings.md#security-keys-where-the-stricter-value-applies) を参照してください。

### `sshConfigs`

[Desktop](https://code.claude.com/docs/ja/desktop.md#pre-configure-ssh-connections-for-your-team) の環境セレクターに SSH 接続を追加します。管理者は `sshConfigs` を使用して、共有接続をチームに配布します。ユーザーは管理対象の接続を選択し、それに対して [独自の **Worktree folder** を設定](https://code.claude.com/docs/ja/desktop.md#set-the-worktree-folder-on-an-existing-connection) できます。アプリでそれ以外のフィールドを編集したり、接続を削除したりすることはできません。

* **Scope**: [`User or managed`](#scopes)。デスクトップアプリはこのキーを読み取ります。デフォルトでは、管理対象の接続を [1 つの管理ソース](https://code.claude.com/docs/ja/managed-settings.md#how-claude-code-combines-managed-sources) から読み取ります。
* **Type**: オブジェクトの配列。各オブジェクトは必須の `id`、`name`、`sshHost` と、オプションの `sshPort` および `sshIdentityFile` を持ちます
* **Default**: 未設定

この例は、`user@dev.example.com` に接続する `Dev VM` という名前の 1 つの接続を追加します：

```json settings.json theme={null}
{
  "sshConfigs": [
    {
      "id": "dev-vm",
      "name": "Dev VM",
      "sshHost": "user@dev.example.com"
    }
  ]
}
```

### `sshHostAllowlist`

[Desktop SSH セッション](https://code.claude.com/docs/ja/desktop.md#restrict-which-ssh-hosts-users-can-connect-to) が接続できるホストを制限します。デスクトップアプリのみがこのキーを読み取ります。CLI は読み取りません。パターンは大文字と小文字を区別しません。`*` は任意のホストに一致し、`*.example.com` は `example.com` とすべてのサブドメインに一致し、その他は `~/.ssh/config` 解決後のホスト名に対する完全一致です。空の配列は SSH セッションをオフにします。

Claude Desktop v3.1623.0 以降では、セッションの [ジャンプホスト](https://code.claude.com/docs/ja/desktop.md#allow-jump-hosts) もパターンに一致する必要があります。

* **Scope**: [`Managed`](#scopes)。デフォルトでは、Desktop は [1 つの管理ソース](https://code.claude.com/docs/ja/managed-settings.md#how-claude-code-combines-managed-sources) からキーを読み取ります。
* **Type**: ホスト名パターンの配列
* **Default**: 未設定なので、任意のホストが許可されます

この例は、`devboxes.example.com` とそのサブドメイン、および正確なホスト `bastion.example.com` を許可します：

```json managed-settings.json theme={null}
{
  "sshHostAllowlist": ["*.devboxes.example.com", "bastion.example.com"]
}
```

`true` やオブジェクトなど、Desktop がホストのリストとして読み取れない値は、修正するまで空の配列として扱われます。ただし `null` は未設定として扱われます。Claude Desktop v2.26454.0 以降が必要です。

最上位のソースで [`managedSourcesBehavior`](#managedsourcesbehavior) を `"merge"` に設定すると、Desktop はすべての [管理ソース](https://code.claude.com/docs/ja/managed-settings.md#how-claude-code-combines-managed-sources) のリストを結合し、いずれかに一致するホストを許可します。あるソースで空の配列を設定しても、別のソースがリストしているホストに対しては SSH セッションはオンのままです。

### `sshHostCommands`

コマンドからホストを取得する SSH 接続を [Desktop](https://code.claude.com/docs/ja/desktop.md#create-an-ssh-connection-from-a-command) の環境セレクターに追加します。接続を作成するとき、またはそのホストを置き換えるとき、Desktop はエントリのコマンドをコンピューター上で実行し、コマンドが出力したホストに接続します。macOS または Linux 上で Claude アカウントにサインインした状態の Claude Desktop v3.6556.0 以降が必要です。

* **Scope**: [`User or managed`](#scopes)。このキーを読み取るのはデスクトップアプリのみです。管理対象のエントリはコンピューター上の [1 つの管理設定ファイルまたは MDM ポリシー](https://code.claude.com/docs/ja/desktop.md#distribute-commands-to-your-team) から読み取り、[サーバー管理設定](https://code.claude.com/docs/ja/server-managed-settings.md) 内のこのキーは無視します。
* **Type**: オブジェクトの配列。各オブジェクトは必須の `id`、`name`、`command` と、オプションの `sshIdentityFile` および `startDirectory` を持ちます。Desktop は `command` をシェルなしで起動するため、[プログラムとプレーンな引数として記述してください](https://code.claude.com/docs/ja/desktop.md#write-the-command)。
* **Default**: 未設定

この例は、`Dev box` という名前の 1 つの接続を追加します。`acme-dev create` は独自のツールを表します：

```json settings.json theme={null}
{
  "sshHostCommands": [
    {
      "id": "devbox",
      "name": "Dev box",
      "command": "acme-dev create"
    }
  ]
}
```

Claude Code v2.1.307 より前は、Edit ツールは有効な設定ファイルにこのキーを追加する変更を拒否し、エラー `Unrecognized field: sshHostCommands` を表示していました。これらのバージョンでは、代わりにテキストエディターでキーを追加してください。Claude Code はこのキーを含むファイルを読み込みます。Desktop で対象となるバージョンは、ターミナルのバージョンではなく [Code タブの Claude Code バージョン](https://code.claude.com/docs/ja/desktop.md#claude-code-version-in-the-code-tab) です。

## 認証とプロバイダー

ヘルパースクリプトを通じて認証情報を提供し、組織の場合はログイン方法または組織を強制します。[認証](https://code.claude.com/docs/ja/authentication.md)を参照してください。

### `allowedProviders`

マシンが Claude に到達できるサービス（Anthropic API、Amazon Bedrock、LLM ゲートウェイなど）をリストアップします。リストに記載されていないプロバイダー上のセッションは、スタートアップ時、ログイン時、および次に API に接続するときに拒否されるため、セッション中にリストに記載されていないプロバイダーに切り替えることも拒否されます。[拒否メッセージ](https://code.claude.com/docs/ja/errors.md#managed-settings-dont-allow-this-api-provider)には、プロバイダーを選択したものと続行するためのステップが記載されています。Claude Code v2.1.285 以降が必要です。

* **スコープ**: [`Managed`](#scopes)。マシン自身の管理者ソース（MDM ポリシーおよび管理設定ファイル）が設定したリストは、サーバー管理設定もリストを配信する場合でも適用され続けます。その場合、セッションは両方のリスト上のプロバイダーのみを使用できるため、サーバー管理リストはマシンが許可するものを狭めることはできますが、広げることはできません。マシンソースの `allowedProviders` のどれが数えられるかは、[Claude Code が管理ソースを組み合わせる方法](https://code.claude.com/docs/ja/managed-settings.md#how-claude-code-combines-managed-sources)に従います。サーバー管理設定のみを通じて配信されたリストは、[サーバー管理設定を取得する](https://code.claude.com/docs/ja/server-managed-settings.md#platform-availability)セッションのみに到達します。
* **タイプ**: 文字列の配列。各要素は以下のいずれか：
  * `"anthropic"`: claude.ai または Console サインイン、または API キーを通じた Anthropic 独自のホスト上の Anthropic API。[`forceLoginMethod`](#forceloginmethod) または [`forceLoginOrgUUID`](#forceloginorguuid) と組み合わせてサインインも制限します
  * `"bedrock"`: [Amazon Bedrock](https://code.claude.com/docs/ja/amazon-bedrock.md)
  * `"vertex"`: [Google Cloud の Agent Platform](https://code.claude.com/docs/ja/google-vertex-ai.md)（旧 Vertex AI）
  * `"foundry"`: [Microsoft Foundry](https://code.claude.com/docs/ja/microsoft-foundry.md)
  * `"anthropicAws"`: [AWS 上の Claude Platform](https://code.claude.com/docs/ja/claude-platform-on-aws.md)
  * `"mantle"`: Amazon Bedrock [Mantle エンドポイント](https://code.claude.com/docs/ja/amazon-bedrock.md#use-the-mantle-endpoint)。[Invoke API と並行して Mantle を実行する](https://code.claude.com/docs/ja/amazon-bedrock.md#run-mantle-alongside-the-invoke-api)セッションは両方のプロバイダーを使用するため、`"bedrock"` と `"mantle"` をまとめてリストアップします
  * `"customEndpoint"`: 別のホストに送信される Anthropic API またはクラウドプロバイダーの API。`ANTHROPIC_BASE_URL` や、`ANTHROPIC_BEDROCK_BASE_URL` などのプロバイダーのエンドポイント変数で指定された [LLM ゲートウェイ](https://code.claude.com/docs/ja/llm-gateway)などです。Claude Code はそれを管理 [`env`](#env) ブロックがピンで留めた正確な値に対してのみ許可します
  * `"gateway"`: [Cloud ゲートウェイ](https://code.claude.com/docs/ja/claude-apps-gateway)サインイン
* **デフォルト**: 未設定。任意のプロバイダーを使用できます

```json managed-settings.json theme={null}
{
  "allowedProviders": ["anthropic", "bedrock"]
}
```

各クラウドプロバイダーのエントリは、そのプロバイダー独自のサービス（地域、FIPS、プライベートエンドポイントを含む）を意味します。

Claude Code がプロバイダー名として認識しないエントリは削除され、報告され、リストの残りは強制されます。空のリスト、またはすべてのエントリが認識されないリストの場合、Claude Code はすべてのプロバイダーを拒否し、マシン上で起動しません。

#### 管理 `env` でピンが必要なエンドポイント

ピンは、管理 [`env`](#env) ブロックで設定されたエンドポイント変数の値です。セッションがプロバイダーのトラフィックをそのプロバイダー独自のサービス以外の場所に送信する場合、Claude Code はセッションの値がピンと同じ場合にのみそれを許可します。これらのエンドポイントには 1 つが必要です：

* **`"customEndpoint"` セッション**: ホストを指定する変数（`ANTHROPIC_BASE_URL` など）
* **Amazon Bedrock**: AWS SDK の `AWS_ENDPOINT_URL`、`AWS_ENDPOINT_URL_BEDROCK`、および `AWS_ENDPOINT_URL_BEDROCK_RUNTIME` 変数が Bedrock 独自のサービス外を指す場合。セッションは `"customEndpoint"` ではなく `"bedrock"` の下に留まります
* **ゲートウェイサインイン URL**: セッションは `"gateway"` の下に留まり、[`forceLoginGatewayUrl`](#forcelogingatewayurl) もピンとしてカウントされます

どの `env` ブロックがピンとしてカウントされるかは、リストが設定されている場所によって異なります：

* **マシン上の管理者ソースがリストを設定**: マシン独自の管理者ソースの `env` ブロックのみがカウントされます
* **サーバー管理設定のみがリストを設定**: これらのサーバー管理設定の `env` 値もカウントされます

リストは、クラウドプロバイダーの認証情報とテナンシー変数、または `HTTPS_PROXY` と証明書設定などのネットワークパスを判定しません。管理 `env` ブロックでフリート用にそれらを設定します。

### `apiKeyHelper`

Claude Code がモデルリクエストで送信する認証情報を生成するために独自のコマンドを実行します。Claude Code はコマンドをシステムシェル（macOS と Linux では `/bin/sh`、Windows では `cmd`）を通じて実行し、その出力を `X-Api-Key` ヘッダーと `Authorization: Bearer` ヘッダーの両方として送信します。ボールトから取得した短期トークンなど、動的または回転する認証情報に使用します。

* **スコープ**: [`Any file`](#scopes)
* **タイプ**: 文字列、シェルコマンドライン
* **デフォルト**: 未設定。Claude Code はヘルパーを実行しません

```json settings.json theme={null}
{
  "apiKeyHelper": "/bin/generate_temp_api_key.sh"
}
```

Claude Code はこれらの場合に値をキャッシュし、コマンドを再実行します。

* キャッシュの有効期限後。デフォルトは 5 分、または [`CLAUDE_CODE_API_KEY_HELPER_TTL_MS`](https://code.claude.com/docs/ja/env-vars) で設定した間隔
* Anthropic API へのリクエスト（直接または [LLM ゲートウェイ](https://code.claude.com/docs/ja/llm-gateway)経由）が `401` または `403` で失敗した場合
* Anthropic API へのリクエスト（直接または LLM ゲートウェイ経由）を送信する前に、キャッシュされた出力がヘルパーが生成した後に期限切れになった JWT である場合。Claude Code v2.1.246 以降が必要です。

最後の 2 つのケースは、ヘルパーの出力が Claude Code が送信する認証情報であり、`ANTHROPIC_AUTH_TOKEN` が設定されていない場合にのみ適用されます。

インタラクティブセッションでは、コマンドがプロジェクトまたはローカル設定から来ている場合、Claude Code はワークスペーストラストプロンプトを受け入れるまでコマンドを実行しません。[認証情報管理](https://code.claude.com/docs/ja/authentication.md#credential-management)を参照してください。

### `awsAuthRefresh`

`aws sso login` などの独自のコマンドを実行して、Claude Code が [Amazon Bedrock](https://code.claude.com/docs/ja/amazon-bedrock.md) に対して持つ認証情報が機能しなくなったときに `.aws` ディレクトリの認証情報をリフレッシュします。Claude Code は最初に現在の認証情報を STS に対してチェックし、そのチェックが失敗した場合にのみコマンドを実行してから、リフレッシュされた `.aws` ディレクトリを読み取ります。

同じコマンドと認証情報を使用する複数の Claude Code プロセス（別々のターミナルや IDE ウィンドウなど）で同時にチェックが失敗した場合、1 つのプロセスがコマンドを実行し、残りのプロセスは独自に実行を開始する代わりにその実行を待機します。リクエストを保留したまま 60 秒間待機したプロセスは、自らコマンドを実行します。この動作をオフにするには、[`CLAUDE_CODE_DISABLE_AUTH_REFRESH_LOCK`](https://code.claude.com/docs/ja/env-vars) を `1` に設定します。

* **スコープ**: [`Any file`](#scopes)
* **タイプ**: 文字列、シェルコマンドライン
* **デフォルト**: 未設定。Claude Code は AWS 認証情報をリフレッシュしません

```json settings.json theme={null}
{
  "awsAuthRefresh": "aws sso login --profile myprofile"
}
```

リフレッシュフローが `.aws` に書き込む場合はこのキーを使用します。代わりに認証情報を出力する場合は [`awsCredentialExport`](#awscredentialexport) を使用します。[高度な認証情報設定](https://code.claude.com/docs/ja/amazon-bedrock.md#advanced-credential-configuration)を参照してください。

### `awsCredentialExport`

AWS 認証情報を JSON として出力する独自のコマンドを実行して、Claude Code が `.aws` ディレクトリに存在しない認証情報で [Amazon Bedrock](https://code.claude.com/docs/ja/amazon-bedrock.md) を呼び出すことができるようにします。Claude Code は `aws sts` 出力形式とフラットな `aws configure export-credentials` 形式を受け入れ、認証情報を独自の Bedrock クライアントにスコープするため、Claude Code が実行するシェルコマンドは引き続き環境の認証情報を参照します。

* **スコープ**: [`Any file`](#scopes)
* **タイプ**: 文字列、シェルコマンドライン
* **デフォルト**: 未設定。Claude Code は環境の AWS 認証情報チェーンを使用します

```json settings.json theme={null}
{
  "awsCredentialExport": "/bin/generate_aws_grant.sh"
}
```

[`awsAuthRefresh`](#awsauthrefresh) とは異なり、Claude Code はこのコマンドが設定されている場合、環境の認証情報を最初にチェックせずに常に実行します。[高度な認証情報設定](https://code.claude.com/docs/ja/amazon-bedrock.md#advanced-credential-configuration)を参照してください。

### `forceLoginMethod`

ユーザーがログインできるアカウントの種類を制限します。`"claudeai"` を設定して claude.ai アカウントのみを許可するか、`"console"` を設定して Claude Console アカウントのみを許可するか、`"gateway"` を設定してファーストパーティログインの代わりに [クラウドゲートウェイ](https://code.claude.com/docs/ja/claude-apps-gateway)にユーザーを送信します。管理者は管理設定で設定し、[`forceLoginOrgUUID`](#forceloginorguuid) と組み合わせて開発者の claude.ai ログインを 1 つの組織内に保つことができます。

任意の設定ファイルで `"claudeai"` に設定した場合、Claude Code はそのファイルが適用されるセッションで [キーレス Console サインイン](https://code.claude.com/docs/ja/authentication.md#sign-in-without-an-api-key)の提供も停止します。`"console"` のみの場合、ユーザーはログインに失敗した後も引き続きキーレスサインインに到達できます。Claude Code による提供を停止するには、[管理対象マシンでキーレスサインインの提供を停止する](https://code.claude.com/docs/ja/authentication.md#stop-offering-the-keyless-sign-in-on-managed-machines)を参照してください。このセクションには、`forceLoginOrgUUID` が他に何を変更するかも記載されています。

* **スコープ**: [`Any file`](#scopes)。Claude Code は `"gateway"` を [`forceLoginGatewayUrl`](#forcelogingatewayurl) と同じソースからのみ受け入れ、それ以外の場所では未設定として扱います。
* **タイプ**: 文字列、以下のいずれか：
  * `"claudeai"`: claude.ai アカウントのみがログインできます
  * `"console"`: Claude Console アカウントのみがログインできます
  * `"gateway"`: Claude Code はユーザーをファーストパーティログインの代わりにクラウドゲートウェイに送信します
* **デフォルト**: 未設定。ユーザーはログイン方法を選択します

```json settings.json theme={null}
{
  "forceLoginMethod": "claudeai"
}
```

すべてのファーストパーティログインパスが制限を適用します。[VS Code 拡張機能](https://code.claude.com/docs/ja/vs-code.md)、Agent SDK、`claude setup-token`、および `/install-github-app` を含みます。ただし、ターミナルのインタラクティブログイン画面（`/login` または初回実行オンボーディングで到達）は、メソッドを事前選択しますが強制しません。v2.1.212 より前は、ターミナルログインのみが適用されていました。[ログインを組織に制限する](https://code.claude.com/docs/ja/authentication.md#restrict-login-to-your-organization)を参照して、各ログインパス、環境認証情報、およびサードパーティプロバイダーがどのように処理されるかを確認してください。

マシン上の管理ソースが `"gateway"` を設定する場合、Claude Code は残されたログイン、API キー、または `apiKeyHelper` 認証情報を使用しません。各メッセージについては [管理者ポリシーがクラウドゲートウェイサインインを必要とします](https://code.claude.com/docs/ja/errors.md#administrator-policy-requires-a-cloud-gateway-sign-in)を参照してください。`CLAUDE_CODE_USE_BEDROCK` または同様の環境変数を通じてクラウドプロバイダーを選択する場合、セッションはゲートウェイサインインを必要としません。v2.1.261 より前は、Claude Code はこれらのマシンで残されたログインを使用していました。

### `forceLoginGatewayUrl`

`/login` クラウドゲートウェイ画面が接続するゲートウェイ URL を設定して、ユーザーがアドレスを入力せずに [クラウドゲートウェイ](https://code.claude.com/docs/ja/claude-apps-gateway)に到達できるようにします。画面には URL フィールドがありません。このキーが設定されている場合、ゲートウェイ URL を表示し、ユーザーが Enter キーを押すと接続します。設定されていない場合、IT 管理者に連絡するよう指示します。

管理設定では、このキーまたは `forceLoginMethod: "gateway"` のいずれかにより、`CLAUDE_CODE_USE_*` でクラウドプロバイダーを選択するセッションを除き、マシンはゲートウェイのみになります。その場合、`/login` はログイン方法ピッカーなしでクラウドゲートウェイ画面で開きます。残されたファーストパーティログインまたは API キーに何が起こるかについては、[管理者ポリシーがクラウドゲートウェイサインインを必要とします](https://code.claude.com/docs/ja/errors.md#administrator-policy-requires-a-cloud-gateway-sign-in)を参照してください。画面がエラーを表示する代わりに接続するように、両方のキーを設定します。

* **スコープ**: [`User or managed`](#scopes)。マシン上の管理ソースから読み取ります。`managed-settings.json`、macOS plist または Windows HKLM レジストリ、またはポリシーヘルパー。これらのいずれもないマシンでは、Claude Code v2.1.295 以降は [ユーザー設定](https://code.claude.com/docs/ja/claude-apps-gateway#set-the-gateway-url-in-user-settings)からも読み取ります。Claude Code は HKCU およびサーバー管理設定では無視します。
* **タイプ**: 文字列、スキームを含む完全な URL
* **デフォルト**: 未設定。クラウドゲートウェイ画面は IT 管理者に連絡するよう指示するエラーを表示します

```json managed-settings.json theme={null}
{
  "forceLoginGatewayUrl": "https://claude-gateway.example.com"
}
```

値が有効な URL でない場合、サインイン画面はそれを報告し、管理設定ファイルの残りは引き続き適用されます。[ゲートウェイ URL を設定する](https://code.claude.com/docs/ja/claude-apps-gateway#set-the-gateway-url)を参照してください。

### `forceLoginOrgUUID`

管理ソースから、claude.ai アカウントログインが 1 つの Anthropic 組織（単一の UUID として指定）または複数の組織（配列として指定）に属することを要求します。任意の設定ファイルから、Claude Code は単一の UUID を使用して claude.ai または Claude Console ログイン中にその組織を事前選択し、配列の場合は何も事前選択しません。任意の設定ファイルでキーを設定する場合、Claude Code はそのファイルが適用されるセッションで [キーレス Console サインイン](https://code.claude.com/docs/ja/authentication.md#sign-in-without-an-api-key)の提供も停止し、代わりに API キーを作成します。

* **スコープ**: [`Any file`](#scopes)。管理ソースのみが制限を強制します。他の設定ファイルの単一の UUID は、制限なしにログイン中に組織を事前選択します。
* **タイプ**: 文字列、1 つの UUID、または文字列の配列、複数の UUID
* **デフォルト**: 未設定。任意の組織がログインできます

この例は、1 つを事前選択せずに 2 つの組織のいずれかからのログインを受け入れます。

```json managed-settings.json theme={null}
{
  "forceLoginOrgUUID": ["xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx", "yyyyyyyy-yyyy-yyyy-yyyy-yyyyyyyyyyyy"]
}
```

管理ソースが空の配列、または文字列でも文字列の配列でもない値を設定した場合、Anthropic アカウントでサインインするユーザーは Claude Code を起動することもログインを完了することもできません。ユーザーには、`forceLoginOrgUUID` を名指しし、管理者に連絡するよう指示するメッセージが表示されます。誤った型の値を出力する [`policyHelper`](#policyhelper) の場合は、代わりに[その実行が失敗します](#helper-failures)。

[ログインを組織に制限する](https://code.claude.com/docs/ja/authentication.md#restrict-login-to-your-organization)を参照して、Claude Code が Claude Console ログイン、他のログインパス、および環境認証情報をどのように扱うかを確認してください。

### `gatewayInternalNetworks`

組織が内部ネットワークに番号を付ける公開 IPv4 ブロックを宣言して、`/login` が [クラウドゲートウェイ](https://code.claude.com/docs/ja/claude-apps-gateway)をそこで受け入れるようにします。Claude Code v2.1.268 以降が必要です。

このキーがない場合、`/login` はプライベートアドレス上のゲートウェイのみに接続し、それ以外には接続しません。このキーがある場合、`/login` はリストされたブロック内のゲートウェイも受け入れます。直接接続のみです。その接続上のマシン自身のアドレスも同じブロック内にある必要があります。

* **スコープ**: [`Managed`](#scopes)。マシン上のソースからのみ読み取ります。`managed-settings.json`、macOS plist または Windows HKLM レジストリ、またはポリシーヘルパー。Claude Code は HKCU およびサーバー管理設定では無視します。
* **タイプ**: 文字列の配列、最大 4 つの IPv4 CIDR ブロック、各 `/8` から `/32`、互いに重複しない、およびプライベートスペースと重複しない
* **デフォルト**: 未設定。`/login` はプライベートアドレス上のゲートウェイのみを受け入れます

```json managed-settings.json theme={null}
{
  "gatewayInternalNetworks": ["203.0.113.0/24"]
}
```

例のドキュメンテーション範囲を独自のブロックに置き換えます。Claude Code はドキュメンテーション範囲、VPN と NAT64 クライアントがローカルで使用する範囲、およびマルチキャストなどのネットワークが番号を付けられていない予約スペースを拒否します。

エントリが無効であるか、値が文字列のリストでない場合、`/login` は問題を名前で指定し、値を修正するまでマシン上のすべての新しいゲートウェイサインインを拒否します。既存のサインインは機能し続けます。完全なルールと開発者が見るものについては、[所有する公開アドレススペース上のゲートウェイを許可する](https://code.claude.com/docs/ja/claude-apps-gateway#allow-a-gateway-on-public-address-space-you-own)を参照してください。

### `gcpAuthRefresh`

Claude Code が Google Cloud Application Default Credentials の有効期限が切れているか読み込めないことを検出したときにリフレッシュするために独自のコマンドを実行して、[Google Cloud の Agent Platform](https://code.claude.com/docs/ja/google-vertex-ai.md) リクエストが手動で再認証することなく機能し続けるようにします。

同じコマンドと認証情報を使用する複数の Claude Code プロセス（別々のターミナルや IDE ウィンドウなど）が同時に認証情報の期限切れを検出した場合、1 つのプロセスがコマンドを実行し、残りのプロセスは独自に実行を開始する代わりにその実行を待機します。リクエストを保留したまま 60 秒間待機したプロセスは、自らコマンドを実行します。この動作をオフにするには、[`CLAUDE_CODE_DISABLE_AUTH_REFRESH_LOCK`](https://code.claude.com/docs/ja/env-vars) を `1` に設定します。

* **スコープ**: [`Any file`](#scopes)
* **タイプ**: 文字列、シェルコマンドライン
* **デフォルト**: 未設定。Claude Code の認証情報エラーは `gcloud auth application-default login` を自分で実行するよう指示します

```json settings.json theme={null}
{
  "gcpAuthRefresh": "gcloud auth application-default login"
}
```

[高度な認証情報設定](https://code.claude.com/docs/ja/google-vertex-ai.md#advanced-credential-configuration)を参照してください。

### `otelHeadersHelper`

Claude Code が OpenTelemetry エクスポートで送信するヘッダーを生成するために独自のコマンドを実行します。トークンが回転するバックエンド用です。Claude Code はスタートアップ時と定期的にその後実行し、stdout で文字列ヘッダー値の JSON オブジェクトを期待します。

* **スコープ**: [`Any file`](#scopes)
* **タイプ**: 文字列、実行可能パスまたはシェルコマンドライン
* **デフォルト**: 未設定。Claude Code はヘルパー生成ヘッダーを追加しません

```json settings.json theme={null}
{
  "otelHeadersHelper": "/bin/generate_otel_headers.sh"
}
```

[`CLAUDE_CODE_OTEL_HEADERS_HELPER_DEBOUNCE_MS`](https://code.claude.com/docs/ja/env-vars) でリフレッシュ間隔を設定します。スクリプトの要件とヘルパーが失敗した場合の動作については、[動的ヘッダー](https://code.claude.com/docs/ja/monitoring-usage.md#dynamic-headers)を参照してください。

## アップデートとバージョン管理

アップデートチャネルを選択し、組織の場合はユーザーが実行できるバージョンをピン留めします。[Claude Code を更新](https://code.claude.com/docs/ja/setup.md#update-claude-code)を参照してください。

### `autoUpdatesChannel`

[リリースチャネル](https://code.claude.com/docs/ja/setup.md#configure-release-channel)をバックグラウンド自動更新と `claude update` が従うかを選択します。通常約 1 週間前のバージョンで、大きな回帰を含むリリースをスキップする `"stable"` を設定するか、最新リリースの `"latest"` を設定します。

* **スコープ**: [`Any file`](#scopes)。組織全体で 1 つのチャネルを強制するために、管理設定で設定します。
* **タイプ**: 文字列、以下のいずれか：
  * `"latest"`：更新は最新リリースに従う
  * `"stable"`：更新は通常約 1 週間前のバージョンに従い、大きな回帰を含むリリースをスキップする
* **デフォルト**: 未設定の場合、Claude Code は `"latest"` に従う

```json settings.json theme={null}
{
  "autoUpdatesChannel": "stable"
}
```

Claude Code は `/config` の **Auto-update channel** で選択すると、ユーザー設定に `"stable"` を書き込み、そこで最新に戻すとキーを削除します。`claude install stable` と `claude install latest` も、指定したチャネルを保存します。`/config` で `"latest"` から `"stable"` に切り替えると、ダウングレードを許可するか現在のバージョンにとどまるかを尋ねます。とどまることを選択すると、[`minimumVersion`](#minimumversion) が設定されます。Homebrew インストールはこのキーを無視します：`claude-code` cask は stable を追跡し、`claude-code@latest` は latest を追跡し、`claude update` は `brew upgrade` に従います。自動更新を完全に無効にするには、`env` で [`DISABLE_AUTOUPDATER`](https://code.claude.com/docs/ja/setup#disable-auto-updates) を設定します。

### `minimumVersion`

バックグラウンド自動更新と `claude update` がこれより下のバージョンをインストールするのを防ぎます。これにより、`"stable"` チャネルに移動しても、より新しい `"latest"` ビルドからダウングレードされません。Claude Code は `/config` でチャネルを切り替えながら現在のバージョンにとどまることを選択すると、このキーを書き込み、`"latest"` に戻すと削除します。

* **スコープ**: [`Any file`](#scopes)。ユーザーおよびプロジェクト設定が低下させることができない、組織全体の最小値をピン留めするために、管理設定で設定します。
* **タイプ**: 文字列、`"2.1.100"` などのバージョン番号。有効なバージョンではない値は無視されます
* **デフォルト**: 未設定の場合、更新はチャネルが提供するすべてのバージョンをインストールできる

この例は stable チャネルに従い、2.1.100 より下のバージョンをインストールするのを拒否します：

```json settings.json theme={null}
{
  "autoUpdatesChannel": "stable",
  "minimumVersion": "2.1.100"
}
```

このキーは更新のみを制約します。Claude Code がバージョン以下で起動するのを拒否させるには、代わりに [`requiredMinimumVersion`](#requiredminimumversion) を使用します。[最小バージョンをピン留めする](https://code.claude.com/docs/ja/setup.md#pin-a-minimum-version)を参照してください。

### `requiredMaximumVersion`

組織が起動を許可する最新の Claude Code バージョンを設定します。実行中のバージョンがより新しい場合、Claude Code は起動時に終了し、ユーザーに組織の承認された方法を通じて承認されたバージョンをインストールするよう指示します。`claude install <version>` も機能する場合があります。Claude Code v2.1.163 以降が必要です。

* **スコープ**: [`Managed`](#scopes)。Claude Code は他の場所でキーを無視するときに警告を表示しません。
* **タイプ**: 文字列、`"2.1.150"` などのバージョン番号。有効なバージョンではない値は無視されます
* **デフォルト**: 未設定の場合、上限は適用されません

```json managed-settings.json theme={null}
{
  "requiredMaximumVersion": "2.1.150"
}
```

バックグラウンド自動更新と `claude update` は上限より上のバージョンをスキップするため、範囲内のインストールは範囲内にとどまります。`claude update`、`claude install`、および `claude doctor` は、ユーザーが復旧できるように上限より上で機能し続けます。[`requiredMinimumVersion`](#requiredminimumversion) とペアにして、範囲を強制します。

### `requiredMinimumVersion`

組織が起動を許可する最も古い Claude Code バージョンを設定します。実行中のバージョンがより古い場合、Claude Code は起動時に終了し、ユーザーに組織の承認された方法を通じて更新するよう指示します。チェックは起動時のみ実行されるため、既に実行中のセッションは続行されます。Claude Code v2.1.163 以降が必要です。

* **スコープ**: [`Managed`](#scopes)。Claude Code は他の場所でキーを無視するときに警告を表示しません。
* **タイプ**: 文字列、`"2.1.150"` などのバージョン番号。有効なバージョンではない値は無視されます
* **デフォルト**: 未設定の場合、下限は適用されません

```json managed-settings.json theme={null}
{
  "requiredMinimumVersion": "2.1.150"
}
```

`claude update`、`claude install`、および `claude doctor` は、ユーザーが復旧できるように下限より下で機能し続けます。ダウングレードのみを防ぐ [`minimumVersion`](#minimumversion) とは異なり、このキーは起動をブロックします。[`requiredMaximumVersion`](#requiredmaximumversion) とペアにして、範囲を強制します。

## ツール

[Claude Code デスクトップアプリ](https://code.claude.com/docs/ja/desktop.md)で特定のツールをオフにします。ターミナル CLI はこれらのキーを無視します。ツール自体については、[Claude が利用可能なツール](https://code.claude.com/docs/ja/tools-reference.md)を参照してください。

### `browserExternalPageTools`

デスクトップアプリの[ブラウザペイン](https://code.claude.com/docs/ja/desktop.md#browse-external-sites)で、Claude がそのツールを使用して外部ページを読み取ったり、外部ページに対して操作したりするのを停止します。組織内のユーザーは引き続き外部サイトを自分で開くことができ、ローカル開発サーバープレビューは Claude のツールで引き続き機能します。デスクトップアプリはこのキーを読み取ります。ターミナル CLI は無視します。

* **スコープ**: [`Managed`](#scopes)
* **タイプ**: 文字列、`"disabled"`。デスクトップアプリは`"disable"`も受け入れます。どちらの場合でも同じです
* **デフォルト**: 未設定。Claude のツールは外部ページで機能します

```json managed-settings.json theme={null}
{
  "browserExternalPageTools": "disabled"
}
```

その他の値を指定すると Claude のツールはオンのままになり、受け入れられた 2 つの値のいずれでもない空でない文字列は警告をログに記録します。ユーザーと Claude の両方に対して外部サイトをブロックするには、代わりに[`disableBrowserExternalNavigation`](#disablebrowserexternalnavigation)を設定してください。[組織の外部ブラウジングを制限する](https://code.claude.com/docs/ja/desktop.md#restrict-external-browsing-for-your-organization)を参照してください。

### `disableBrowserExternalNavigation`

デスクトップアプリの[ブラウザペイン](https://code.claude.com/docs/ja/desktop.md#browse-external-sites)で、ユーザーと Claude の両方に対して外部ブラウジングをオフにします。Localhost 開発サーバープレビューは引き続き機能します。デスクトップアプリはこのキーを読み取ります。ターミナル CLI は無視します。

* **スコープ**: [`Managed`](#scopes)
* **タイプ**: ブール値。JSON ブール値`true`のみが有効です
  * `true`: デスクトップアプリは、ブラウザペインでユーザーと Claude の両方に対して外部ブラウジングをオフにします。localhost プレビューは引き続き機能します
  * `false`: 外部ブラウジングはオンのままです
* **デフォルト**: 未設定。外部ブラウジングはオンです

```json managed-settings.json theme={null}
{
  "disableBrowserExternalNavigation": true
}
```

デスクトップアプリはその他の値を無視し、文字列`"true"`や`1`などのブール値ではない値も警告をログに記録します。外部ブラウジングはオンのままにしておきたいが、Claude のツールを外部ページでオフにしたい場合は、代わりに[`browserExternalPageTools`](#browserexternalpagetools)を設定してください。[組織の外部ブラウジングを制限する](https://code.claude.com/docs/ja/desktop.md#restrict-external-browsing-for-your-organization)を参照してください。

### `disableMobileSimulatorTools`

デスクトップアプリの[iOS シミュレータペイン](https://code.claude.com/docs/ja/desktop-ios-simulator.md#turn-off-simulator-access)に対する Claude のツールをブロックします。ユーザーはペインの手動使用を継続できます。Claude のアクセスのみが削除され、アプリ内から誰もそれを再度オンにすることはできません。デスクトップアプリはこのキーを読み取ります。ターミナル CLI は無視します。

* **スコープ**: [`Managed`](#scopes)
* **タイプ**: ブール値。JSON ブール値`true`のみが有効です
  * `true`: デスクトップアプリは iOS シミュレータペインに対する Claude のツールをブロックします
  * `false`: Claude のシミュレータツールは、デスクトップアプリ内の各ユーザーの設定トグルに従います
* **デフォルト**: 未設定。Claude のシミュレータツールは、デスクトップアプリ内の各ユーザーの設定トグルに従います

```json managed-settings.json theme={null}
{
  "disableMobileSimulatorTools": true
}
```

デスクトップアプリはその他の値を無視し、文字列`"true"`や`1`などのブール値ではない値も警告をログに記録します。

## プライバシーとテレメトリ

Claude Code がセッションデータをどのくらいの期間保持し、何を送信するかを制御します。使用メトリクスとエラーレポートをオフにするスイッチは、設定キーではなく環境変数です。[`env`](#env) キーまたはシェルで `DISABLE_TELEMETRY`、`DISABLE_ERROR_REPORTING`、または `CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC` を設定します。[テレメトリサービス](https://code.claude.com/docs/ja/data-usage.md#telemetry-services) では、各環境変数が何を停止するかについて説明しています。2 つの例外は設定ファイルからオフになります。以下の [`feedbackDrafts`](#feedbackdrafts) は Claude が作成したフィードバック用、および以下の [`feedbackSurveyRate`](#feedbacksurveyrate) はセッションサーベイ用です。

### `cleanupPeriodDays`

Claude Code が [セッショントランスクリプトおよび他のアプリケーションデータ](https://code.claude.com/docs/ja/claude-directory.md#cleaned-up-automatically) を削除する前に保持する日数を設定します。Claude Code はセッション開始後にバックグラウンド削除を実行します。保持期間を安全に判定できる限り実行されます。削除スイープはメッセージを表示せずにトランスクリプトを削除するため、保持期間より長く使用していないセッションは [`/resume`](https://code.claude.com/docs/ja/sessions#resume-a-session) ピッカーに表示されなくなります。

* **スコープ**: [`Any file`](#scopes)
* **タイプ**: 日数、整数、最小値 `1`
* **デフォルト**: `30`

```json settings.json theme={null}
{
  "cleanupPeriodDays": 20
}
```

`0` を設定するとバリデーションが失敗するため、長期保持の場合は `3650` などの大きな値を選択してください。Claude Code がトランスクリプトを書き込まないようにするには、[プレーンテキストストレージ](https://code.claude.com/docs/ja/claude-directory.md#plaintext-storage) を参照してください。

### `desktopSessionCleanupPeriodDays`

Claude Desktop または Cowork で開始または最後に続行したセッションのトランスクリプトに対して、日数での年齢制限を設定します。このキーがない場合、Claude Code は [それらのトランスクリプトを任意の年齢で保持します](https://code.claude.com/docs/ja/claude-directory.md#cleaned-up-automatically)。Claude Code は各トランスクリプトが、この制限と [`cleanupPeriodDays`](#cleanupperioddays) の両方より古い場合に削除します。したがって、`cleanupPeriodDays` がデフォルトの 30 の場合、`7` の値でも 30 日間保持されます。[自動クリーンアップ](https://code.claude.com/docs/ja/claude-directory.md#cleaned-up-automatically) には、代わりに `cleanupPeriodDays` が適用され、Claude Code がこのキーを無視するケースが記載されています。Claude Code v2.1.248 以降が必要です。

* **スコープ**: [`User or managed`](#scopes)。Claude Code は `--settings` で渡すファイルからキーを読み込み、プロジェクトおよびローカル設定では無視します。
* **タイプ**: 日数、整数、最小値 `0`
* **デフォルト**: `0`。年齢制限を設定しません

```json settings.json theme={null}
{
  "desktopSessionCleanupPeriodDays": 90
}
```

### `feedbackDrafts`

[Claude が作成したフィードバック](https://code.claude.com/docs/ja/tools-reference.md#sendfeedback-tool-behavior) を制御します。Claude がレビュー用のフィードバックドラフトをキューに入れることができるかどうか、および Claude Code が Claude がドラフトをキューに入れたときにカードを表示するかどうかを制御します。

* **スコープ**: [`User or managed`](#scopes)
* **タイプ**: 文字列。`"notify"`、`"quiet"`、または `"off"` のいずれか
  * `"notify"`：Claude Code は Claude がドラフトをキューに入れたときにプロンプトの上にカードを表示します。デフォルトではセッションあたり [最大 3 枚のカード](https://code.claude.com/docs/ja/tools-reference.md#what-you-see-when-claude-drafts)
  * `"quiet"`：Claude はカードなしでドラフトを作成します。プロンプトフッターでキューに入れられたドラフトの数を確認し、`/feedback` でレビューします
  * `"off"`：Claude Code は SendFeedback ツールを削除するため、Claude はドラフトをキューに入れることができません
* **デフォルト**: `"notify"`
* **セッションごとのオーバーライド**: [`CLAUDE_CODE_SEND_FEEDBACK`](https://code.claude.com/docs/ja/env-vars) を `0` に設定すると、1 つのセッションでこの機能がオフになります

```json settings.json theme={null}
{
  "feedbackDrafts": "quiet"
}
```

`/config` に **Claude-drafted feedback** として表示されます。これはこのキーをユーザー設定に書き込みます。`/config` 行は [Claude がフィードバックドラフトを作成できるセッション](https://code.claude.com/docs/ja/tools-reference.md#sessions-without-claude-drafted-feedback) でのみ表示されます。`"off"` を設定してもこれは非表示にならないため、同じ行から機能を再度オンにできます。管理設定の値はユーザー設定より優先されるため、管理者がこのキーを設定すると、行は管理値を表示し、変更しても効果がありません。Claude Code はプロジェクトおよびローカル設定でこのキーを無視します。

### `feedbackSurveyRate`

[セッション品質サーベイ](https://code.claude.com/docs/ja/data-usage.md#session-quality-surveys) がセッションがそれに適格である場合に表示される確率を設定します。`0` を設定してサーベイが表示されないようにします。

* **スコープ**: [`Any file`](#scopes)
* **タイプ**: `0` から `1` の間の数値
* **デフォルト**: 未設定。Claude Code は Anthropic がリモートで設定する率を使用するか、Amazon Bedrock、Google Cloud の Agent Platform、および Microsoft Foundry でのビルトイン率 `0.005` を使用します。これらはリモート設定を受け取りません
* **セッションごとのオーバーライド**: [`CLAUDE_CODE_DISABLE_FEEDBACK_SURVEY`](https://code.claude.com/docs/ja/env-vars) を `1` に設定すると、このキーが設定する率に関係なく、1 つのセッションでサーベイがオフになります

```json settings.json theme={null}
{
  "feedbackSurveyRate": 0.05
}
```

同じ率が VS Code 拡張機能のサーベイに適用されます。

### `skipWebFetchPreflight`

[WebFetch ドメイン安全性チェック](https://code.claude.com/docs/ja/data-usage.md#webfetch-domain-safety-check) をスキップします。このチェックは、フェッチする前に各リクエストされたホスト名を `api.anthropic.com` に送信します。Amazon Bedrock、Google Cloud の Agent Platform、または Microsoft Foundry デプロイメント（制限的な出力を持つ）など、Anthropic へのトラフィックをブロックする環境で `true` を設定します。

* **スコープ**: [`Any file`](#scopes)
* **タイプ**: ブール値
  * `true`：Claude Code は WebFetch ドメイン安全性チェックをスキップします
  * `false`：チェックはセッション内の各ホスト名への最初のフェッチの前に実行され、以前のチェックがブロックされたか失敗したホスト名に対して再度実行されます
* **デフォルト**: 未設定。チェックはセッション内の各ホスト名への最初のフェッチの前に実行されます

```json settings.json theme={null}
{
  "skipWebFetchPreflight": true
}
```

チェックがスキップされた場合、WebFetch はブロックリストを参照せずに任意の URL を試行するため、Claude が到達できるドメインを制限する必要がある場合は [`WebFetch` 権限ルール](https://code.claude.com/docs/ja/permissions#webfetch) と組み合わせてください。

## エンタープライズ設定と管理設定

組織が管理設定の算出、更新、組み合わせに使用するキーです。[管理設定をセットアップする](https://code.claude.com/docs/ja/admin-setup.md)を参照してください。

### `disableSideloadFlags`

起動時に `--plugin-dir`、`--plugin-url`、`--agents`、`--mcp-config` の CLI フラグを拒否します。これらのフラグを使うと、ユーザーは 1 回の実行に限り [`strictKnownMarketplaces`](#strictknownmarketplaces) を回避できてしまいます。Claude Code は拒否したフラグを示すエラーを出して終了します。[クラウドセッション](https://code.claude.com/docs/ja/claude-code-on-the-web.md)では、Claude Code は代わりにセッションを開始し、サーバーから配信された `--mcp-config` エントリのうち、インプロセスの `type: "sdk"` エントリと [Claude Tag](https://code.claude.com/docs/ja/claude-tag.md) セッションの Slack ツールを除くすべてを破棄します。Claude Code v2.1.193 以降が必要です。

* **スコープ**: [`Managed`](#scopes)
* **型**: Boolean
  * `true`: Claude Code は起動時に `--plugin-dir`、`--plugin-url`、`--agents`、`--mcp-config` を拒否し、それらを示すエラーを出して終了します。クラウドセッションでは、代わりにセッションを開始し、サーバーから配信された `--mcp-config` エントリのうち、インプロセスの `type: "sdk"` エントリと Claude Tag セッションの Slack ツールを除くすべてを破棄します
  * `false`: Claude Code はこれらのフラグを受け入れます
* **デフォルト**: `false`

```json managed-settings.json theme={null}
{
  "disableSideloadFlags": true
}
```

サーバーがすべてインプロセスの `type: "sdk"` エントリである `--mcp-config` は引き続き受け入れられるため、Agent SDK と VS Code 拡張機能は引き続き動作します。ユーザーは引き続き `claude mcp add` や `.mcp.json` ファイルでサーバーを追加できます。サーバーごとに制御するには、[`allowedMcpServers`](https://code.claude.com/docs/ja/managed-mcp) もあわせて設定してください。Claude Code v2.1.193 以降が必要です。

`disableSideloadFlags` は、次のソースからのプラグインフォルダーも拒否します。

* **[`CLAUDE_CODE_PLUGIN_DIRS`](https://code.claude.com/docs/ja/env-vars#variables) 環境変数**: この変数がプラグインフォルダーを指定している場合、Claude Code は起動時に、この変数名を示して設定解除を求めるエラーを出して終了します。Claude Code v2.1.280 以降が必要です
* **Agent SDK の [`addPlugins`](https://code.claude.com/docs/ja/agent-sdk/typescript#load-more-plugin-folders-with-addplugins) オプション**: アプリケーションが `addPlugins` で `reloadPlugins()` にプラグインフォルダーを渡すと、その呼び出しはエラーで失敗します。セッションは既存のプラグインのまま実行を続けます。Claude Code v2.1.301 以降が必要です

クラウドセッションでは、Claude Code はサーバーから配信されるセッション途中の MCP 更新も無視します。これは、クラウドセッションの設定や、それらのセッションに届く SDK の `setMcpServers()` 呼び出しが使う経路です。ここでも、インプロセスの `type: "sdk"` エントリと Claude Tag セッションの Slack ツールは対象外です。v2.1.268 より前では、この破棄と起動時の破棄の両方で Claude Tag セッションの Slack ツールも削除されていました。v2.1.239 より前では、サーバーから配信された `--mcp-config` によってクラウドセッションの開始がブロックされていました。

デスクトップアプリは、claude.ai から同期されたプラグインや、組織がアプリを通じてデプロイしたプラグインなど、一部のプラグインを自身で管理します。MDM、OS レベルのポリシー、または管理設定ファイルを通じてこのキーをデバイスにデプロイすると、デスクトップアプリはそのデバイス上の次のセッションにそれらのプラグインを渡しません。

* **[ユーザーのマシン上の Code セッション](https://code.claude.com/docs/ja/desktop.md#environment-configuration)**: これらのセッションは、ユーザーの claude.ai アカウントで有効になっているスキルも読み込まれない状態で開始されます。管理設定内のマーケットプレイスから Claude Code がインストールするプラグインは引き続き読み込まれます。[Claude Desktop on 3P](https://claude.com/docs/third-party/claude-desktop/overview) では、デバイスの `org-plugins` ディレクトリにデプロイしたプラグインの MCP サーバーも引き続き利用できます。デスクトップアプリがそれらに直接接続するためです。Claude Desktop v1.37937.0 より前では、これらのセッションは代わりに起動時に失敗していました。
* **[ユーザーのマシン上の Cowork セッション](https://code.claude.com/docs/ja/managed-settings.md#where-and-when-a-policy-applies)**: それらのプラグイン内のスキルと、ユーザーの claude.ai アカウントで有効になっているスキルは引き続き利用できます。[Claude Desktop on 3P](https://claude.com/docs/third-party/claude-desktop/overview) では、デバイスの `org-plugins` ディレクトリにデプロイしたプラグインの MCP サーバーも引き続き利用できます。デスクトップアプリがそれらに直接接続するためです。Claude Desktop v1.44121.0 より前では、これらのセッションは代わりに起動時に失敗していました。

### `forceRemoteSettingsRefresh`

Claude Code が[サーバー管理設定](https://code.claude.com/docs/ja/server-managed-settings.md)を新たに取得するまで CLI の起動をブロックします。取得に失敗した場合、Claude Code はキャッシュされた設定や設定なしで続行せずに終了します。セッションが管理ポリシーなしで実行される時間がわずかでも許容できない環境で設定してください。

このキーが未設定の場合、Claude Code は取得のために起動をブロックしませんが、開発者が起動時にサインインする場合は取得を最大 5 秒待ちます。Cloud ゲートウェイセッションは常に待機し、ゲートウェイに到達できない場合は終了します。

* **スコープ**: [`Managed`](#scopes)。Claude Code は、管理者が制御する任意の管理ソースからの `true` を、最も優先度の高いソースでなくても尊重します。
* **型**: Boolean
  * `true`: Claude Code はサーバー管理設定を新たに取得するまで起動をブロックし、取得に失敗した場合は終了します
  * `false`: Claude Code は取得のために起動をブロックしませんが、サインインを伴う起動では取得を最大 5 秒待ちます
* **デフォルト**: `false`

```json managed-settings.json theme={null}
{
  "forceRemoteSettingsRefresh": true
}
```

最初のサーバーペイロードが届く前にフェイルクローズの起動を強制するには、MDM プロファイルまたは管理設定ファイルで設定してください。Claude Code はサーバー管理設定を取得するセッションでのみこのチェックを適用するため、[それらを取得しない](https://code.claude.com/docs/ja/server-managed-settings.md#platform-availability)セッションは待機せずに開始されます。`claude auth` サブコマンドは対象外なので、認証情報の期限切れが取得失敗の原因である場合でも、ユーザーは再認証できます。[フェイルクローズの起動を強制する](https://code.claude.com/docs/ja/server-managed-settings.md#enforce-fail-closed-startup)を参照してください。

### `managedSourcesBehavior`

組織が配信する[管理ソース](https://code.claude.com/docs/ja/managed-settings.md#how-claude-code-combines-managed-sources)のうち最も優先度の高いものだけを Claude Code が適用するか、配信されるすべての管理ソースを組み合わせるかを選択します。デフォルトでは、Claude Code は[ポリシーキー](https://code.claude.com/docs/ja/managed-settings.md#how-claude-code-combines-managed-sources)を含む最も優先度の高いソースを採用し、残りは無視します。ポリシーキーとは、このキーと `wslInheritsWindowsSettings` 以外の任意の設定キーです。このデフォルトでは、サーバー管理設定または MDM ポリシーがポリシーキーを配信すると、`managed-settings.json` ファイルは[Claude Code がすべての管理ソースから読み取るキー](https://code.claude.com/docs/ja/managed-settings.md#keys-read-from-every-admin-source)のみを提供します。`"merge"` を指定すると、配信されるすべての管理ソースがそれぞれのキーを 1 つの組み合わされたポリシーに提供します。Claude Code v2.1.242 以降が必要です。

`"merge"` は、最も優先度の高いソースより下位に[ランク付けされる](https://code.claude.com/docs/ja/managed-settings.md#how-claude-code-combines-managed-sources)すべてのソースが管理者の制御下にある場合にのみ設定してください。その場合、Claude Code は `permissions.allow` ルールなど、下位のソースのエントリをポリシーに追加するためです。

* **スコープ**: [`Managed`](#scopes)。Claude Code は、このキーまたはポリシーキーのいずれかを含む最も優先度の高いソースからこのキーを読み取り、それより下位のすべてのソースにあるこのキーを無視します。そのため、下位のソースが自らを上位のソースとの組み合わせに参加させることはできません。Windows HKCU レジストリと[埋め込みホストからの親設定](https://code.claude.com/docs/ja/managed-settings.md#let-an-embedding-host-add-policy)は、どちらもマージに参加しません。
* **型**: 文字列。次のいずれか:
  * `"first-wins"`: ポリシーキーを含む最も優先度の高いソースがポリシーを提供し、下位のソースは[Claude Code がすべての管理ソースから読み取るキー](https://code.claude.com/docs/ja/managed-settings.md#keys-read-from-every-admin-source)のみを提供します
  * `"merge"`: 配信されるすべての管理ソースがそれぞれのキーを提供し、以下のルールで組み合わされます
* **デフォルト**: `"first-wins"`

このキーは、デプロイする中で最も優先度の高いソースで配信してください。サーバー管理設定を一度も受け取らないマシンでは、MDM プロファイルにもこのキーが必要です。Claude Code は、このキーまたはポリシーキーを含む最も優先度の高いソースからこのキーを読み取るためです。`managed-settings.json` ファイルは最も低くランク付けされる管理ソースなので、そこで `"merge"` を設定しても、組み合わせる下位のソースがありません。サーバー管理設定では、このキーは次のようになります。

```json theme={null}
{
  "managedSourcesBehavior": "merge"
}
```

`"merge"` では、Claude Code は各キーをその種類に応じて組み合わせます。次の表は種類ごとのルールを示しています。制限許可リスト、値全体の採用、最上位ソースのみの行は対象となるすべてのキーを挙げており、その他の行は例を示しています。

| キーの種類 | Claude Code による組み合わせ方 | キー |
| :- | :- | :- |
| リスト | すべてのソースのエントリを組み合わせます | [`permissions.allow`](#permissions-allow)、[`sandbox.network.allowedDomains`](#sandbox-network-alloweddomains)、その他のリストキー |
| ロック | いずれかのソースが設定する最も厳しい値を適用します。厳しい値を設定するソースがない場合は、最上位のソースからのみ緩い値を適用します | [`allowManagedPermissionRulesOnly`](#allowmanagedpermissionrulesonly)、[`permissions.disableBypassPermissionsMode`](#permissions-disablebypasspermissionsmode)、その他の Boolean または列挙型のロック |
| 制限許可リスト | リストを設定している最上位のソースからリスト全体を採用し、下位のソースのエントリは追加しません。最上位のソースが設定していない場合は、次の下位のソースから全体を採用します | [`availableModels`](#availablemodels)、[`allowedMcpServers`](#allowedmcpservers)、[`allowedProviders`](#allowedproviders)、[`strictKnownMarketplaces`](#strictknownmarketplaces)、[`allowedChannelPlugins`](#allowedchannelplugins)、[`fallbackModel`](#fallbackmodel) チェーン |
| 値全体の採用 | 値を設定している最上位のソースから値全体を採用し、下位のソースのエントリやフィールドは組み合わせません。最上位のソースが設定していない場合は、次の下位のソースから全体を採用します | [`sandbox.credentials.awsPairs`](#sandbox-credentials-awspairs)、[`sandbox.ripgrep`](#sandbox-ripgrep) |
| 提供される MCP サーバー | すべてのソースのサーバー名を組み合わせます。2 つのソースが同じ名前を設定している場合は、上位のソースのエントリ全体を適用します | [`managedMcpServers`](#managedmcpservers) |
| 最も優先度の高いソースからのみ読み取り | ポリシーキーを含む最も優先度の高いソースからのみキーを読み取るため、最上位のソースが何も設定していない場合でも下位のソースの値は無視されます | [`apiKeyHelper`](#apikeyhelper)、[`awsAuthRefresh`](#awsauthrefresh)、[`awsCredentialExport`](#awscredentialexport)、[`gcpAuthRefresh`](#gcpauthrefresh)、[`otelHeadersHelper`](#otelheadershelper)、`proxyAuthHelper`、[`parentSettingsBehavior`](#parentsettingsbehavior)、[`modelPicker`](#modelpicker)、[`policyHelper`](#policyhelper)、[`permissions.defaultMode`](#permissions-defaultmode) |
| `env` | `"first-wins"` と `"merge"` のどちらでも、[管理ソース間で変数ごとにマージします](https://code.claude.com/docs/ja/managed-settings.md#keys-read-from-every-admin-source) | [`env`](#env) |
| その他すべてのキー | 値を設定している最上位のソースから値を採用します | [`cleanupPeriodDays`](#cleanupperioddays)、[`model`](#model) |

`sandbox.credentials.awsPairs` と `sandbox.ripgrep` を全体として採用するには、Claude Code v2.1.257 以降が必要です。

いくつかのキーには、表に示されていない条件が加わります。

* **[`policyHelper`](#policyhelper)**: Claude Code は、ポリシーキーを含む最上位のソースが MDM ポリシーまたは管理設定ファイルである場合にのみこれを尊重するため、サーバー管理設定のもとでは適用されません。
* **[`modelOverrides`](#modeloverrides)**: `availableModels` と対になります。Claude Code は `modelOverrides` を設定している最上位のソースから採用しますが、上位のソースが `modelOverrides` なしで `availableModels` を設定している場合は例外です。その場合、すべてのソースの `modelOverrides` を無視します。
* **[`forceLoginGatewayUrl`](#forcelogingatewayurl)、[`gatewayInternalNetworks`](#gatewayinternalnetworks)、[`forceLoginMethod`](#forceloginmethod) の `"gateway"` の値**: Claude Code はこれらをサーバー管理設定から読み取ることはないため、そこにある値は適用されず、MDM ポリシーや管理設定ファイルで設定された値を隠すこともありません。マシン上の管理ソースのうち、ポリシーキーを含む最上位のものだけがこれらを提供します。これはサーバー管理設定も存在するかどうかに関係ありません。
* **[`forceLoginOrgUUID`](#forceloginorguuid) と [`forceLoginMethod`](#forceloginmethod) の `"claudeai"` と `"console"` の値**: どの値が適用されるかは、表ではなく[ログインキーを提供する管理ソース](https://code.claude.com/docs/ja/managed-settings.md#which-managed-source-supplies-login-keys)で確認してください。
* **[`allowedProviders`](#allowedproviders)**: 表のルールを適用した後も、そのエントリのスコープの注記にあるとおり、マシン自身のリストが結果を引き続き制限します。

マシン上でどのソースが組み合わされたかを確認するには、`/status` を実行して [`Setting sources` 行を確認してください](https://code.claude.com/docs/ja/managed-settings#read-the-source-in-/status)。

### `parentSettingsBehavior`

管理者がデプロイした管理ティアも存在する場合に、Agent SDK や IDE 拡張機能などの埋め込みホストプロセスが提供する管理設定を Claude Code が適用するかどうかを選択します。`"first-wins"` では、Claude Code はホストが提供する設定を破棄します。`"merge"` では、制限方向のみのフィルターを通して、管理ティアの下位にそれらを適用します。ホストが起動するセッションに独自の制限を渡す必要がある場合、たとえば Claude Desktop がゲートウェイの送信許可リストを配信する場合に `"merge"` を設定してください。

* **スコープ**: [`Managed`](#scopes)。Claude Code は、管理者が制御する最も優先度の高い管理ソースからこれを読み取ります。
* **型**: 文字列。次のいずれか:
  * `"first-wins"`: 管理者がデプロイした管理ティアが存在する場合、Claude Code はホストが提供する設定を破棄します
  * `"merge"`: Claude Code は、制限方向のみのフィルターを通して、ホストが提供する設定を管理ティアの下位に適用します
* **デフォルト**: `"first-wins"`

```json managed-settings.json theme={null}
{
  "parentSettingsBehavior": "merge"
}
```

管理者がデプロイした管理ティアが存在しない場合、このキーは効果がありません。その場合、ホストの設定が唯一の管理ティアとして適用され、引き続き制限方向の値にフィルタリングされます。フィルターの制限と管理ソース間の相互作用については、[埋め込みホストからの親設定](https://code.claude.com/docs/ja/managed-settings.md#parent-settings-from-embedding-hosts)と[親設定を制限する](https://code.claude.com/docs/ja/claude-apps-gateway#restrict-parent-settings)を参照してください。

### `policyHelper`

起動時に管理設定を算出する、ユーザーがデプロイした実行ファイルを実行します。これにより、静的なファイルではなく、デバイスの状態、ID、またはリモートサービスからポリシーを導出できます。Claude Code は最初のプロンプトを受け付ける前にヘルパーを実行し、ヘルパーが出力する設定をそのセッションの管理設定として扱います。

* **スコープ**: [`Managed`](#scopes)。macOS plist、Windows HKLM レジストリ、または管理設定ファイルから読み取られます。Claude Code は、[ポリシーキー](https://code.claude.com/docs/ja/managed-settings.md#how-claude-code-combines-managed-sources)を含む最も優先度の高い管理ソースからこのキーを読み取り、そのソースがこれら 3 つのいずれかである場合にのみヘルパーを実行します。サーバー管理設定、HKCU レジストリ、ホストが提供する親設定にあるこのキーは無視されます。
* **型**: `path`、`timeoutMs`、`refreshIntervalMs` を持つオブジェクト
* **デフォルト**: 未設定。ヘルパーは実行されません

起動時にサーバー管理設定がポリシーを配信する場合、それがヘルパーのソースより優先され、ヘルパーは実行されません。

その後の設定取得でサーバー管理設定が削除されたと報告された場合、Claude Code は次回の起動を待たずにその時点でヘルパーを実行します。その出力がセッションの残りを制御し、実行が失敗した場合は[起動時の実行の失敗](#helper-failures)と同じメッセージでセッションが終了します。

この例では、5 秒のタイムアウトでヘルパーを実行し、5 分ごとに再実行します。

```json managed-settings.json theme={null}
{
  "policyHelper": {
    "path": "/usr/local/bin/claude-policy",
    "timeoutMs": 5000,
    "refreshIntervalMs": 300000
  }
}
```

#### ヘルパーの出力を記述する

Claude Code は引数なしでヘルパーを実行し、その環境に `CLAUDE_CODE_VERSION` を設定して、stdout から JSON エンベロープを読み取ります。上限は 1 MiB です。

設定は `managedSettings` キーの下に置いてください。`managedSettings` キーのない裸の設定オブジェクトは、`managedSettings` が未定義の状態でパースされて何も適用されず、Claude Code はエラーを報告しません。

```json theme={null}
{
  "managedSettings": {
    "permissions": { "deny": ["Read(//etc/secrets/**)"] }
  }
}
```

ヘルパーが `managedSettings` を出力すると、そのオブジェクトがその実行における唯一の管理設定ソースになります。Claude Code は MDM、ファイル、HKCU のソースを無視し、[ソース横断キー](https://code.claude.com/docs/ja/managed-settings.md#keys-read-from-every-admin-source)をヘルパーの出力のみから読み取り、[親設定](https://code.claude.com/docs/ja/managed-settings.md#parent-settings-from-embedding-hosts)をマージすることはありません。

起動時の `forceRemoteSettingsRefresh` チェックはヘルパーより前に実行され、任意の管理ソースを読み取ります。`managedSettings` を省略したエンベロープで `0` で終了するヘルパーは管理設定を提供せず、他のソースが通常どおり適用されます。

#### ヘルパーの失敗

次の場合、ヘルパーの実行は失敗します。

* `path` が [`policyHelper.path`](#policyhelper-path) のルールに違反している。
* `path` に通常ファイルが存在しない。Claude Code はヘルパーを起動する前に、同じ `timeoutMs` の予算内でファイルを確認するため、応答しないネットワークマウントによって実行が失敗する場合があります。
* ヘルパーが 0 以外で終了した、`timeoutMs` が経過してもまだ実行中である、または実行可能でないなどの理由でまったく起動しない。
* ヘルパーが stdout または stderr に 1 MiB を超えて書き込んだ。
* stdout が単一の JSON オブジェクトではない、またはその `managedSettings` に [Claude Code が修復できないスキーマ違反](https://code.claude.com/docs/ja/managed-settings.md#find-entries-claude-code-dropped)がある。

起動時の実行が失敗すると、Claude Code は理由を出力して起動を拒否します。0 以外で終了した場合、理由にはヘルパーの stderr が含まれ、stderr が空の場合は stdout が含まれます。タイムアウトした場合、理由には `timeoutMs` の上限が示され、ヘルパーの出力は含まれません。この拒否は、対話型セッション、`claude -p`、Agent SDK セッション、[バックグラウンドセッション](https://code.claude.com/docs/ja/agent-view.md)、およびほとんどのサブコマンドに適用されます。

この拒否は意図的なものです。そのため、障害への耐性が必要なヘルパーは、自身のキャッシュから応答して `0` で終了するようにしてください。

バックグラウンドでの更新が失敗した場合、Claude Code は最後に成功したポリシーを有効なまま維持し、更新が成功するまで `/status` に失敗した更新とその理由を表示します。各更新は、起動時の実行と同じ `timeoutMs` と失敗のルールのもとで実行されます。

`--debug` を指定すると、Claude Code はすべての実行におけるヘルパーの stderr を[デバッグログ](https://code.claude.com/docs/ja/debug-your-config.md)に書き込みます。

Claude Code は、無効な `policyHelper` の値を[破棄されたエントリ](https://code.claude.com/docs/ja/managed-settings.md#find-entries-claude-code-dropped)として報告し、ヘルパーを実行せずに残りの管理設定でセッションを開始します。無効な値には、裸のパス文字列や、[最小値](#policyhelper-timeoutms)を下回る `timeoutMs` などがあります。

ヘルパーをオフにするには、このキーを設定しているソースからキーを削除してください。

### `policyHelper.path`

Claude Code が実行するヘルパー実行ファイルを指定します。パスが以下のルールに違反した場合の動作については、[ヘルパーの失敗](#helper-failures)を参照してください。

* **スコープ**: [`Managed`](#scopes)。[`policyHelper`](#policyhelper) が読み取られる場所、つまり macOS plist、Windows HKLM レジストリ、または管理設定ファイルから読み取られます。
* **型**: 文字列。`.` や `..` のセグメントを含まない、正規化された形式の絶対パス。Windows では、`.exe` で終わるドライブレターパスまたは UNC パス
* **デフォルト**: なし。`policyHelper` を設定する場合は必須

```json managed-settings.json theme={null}
{
  "policyHelper": {
    "path": "/usr/local/bin/claude-policy"
  }
}
```

### `policyHelper.timeoutMs`

Claude Code が実行を失敗として扱うまでにヘルパーを待つ時間を設定します。タイムアウトした実行は 0 以外での終了と同じように失敗するため、起動時には Claude Code は起動を拒否します。

* **スコープ**: [`Managed`](#scopes)。[`policyHelper`](#policyhelper) が読み取られる場所、つまり macOS plist、Windows HKLM レジストリ、または管理設定ファイルから読み取られます。
* **型**: 整数。ミリ秒、最小値は `1000`
* **デフォルト**: `10000`

```json managed-settings.json theme={null}
{
  "policyHelper": {
    "path": "/usr/local/bin/claude-policy",
    "timeoutMs": 5000
  }
}
```

### `policyHelper.refreshIntervalMs`

Claude Code にバックグラウンドで一定間隔ごとにヘルパーを再実行させ、ポリシーの変更が実行中のセッションに反映されるようにします。更新が成功すると、その出力が再起動なしで以前の管理設定を置き換えます。更新が失敗すると、Claude Code は既存のポリシーを維持します。

* **スコープ**: [`Managed`](#scopes)。[`policyHelper`](#policyhelper) が読み取られる場所、つまり macOS plist、Windows HKLM レジストリ、または管理設定ファイルから読み取られます。
* **型**: 整数。ミリ秒。`0` で更新を無効化し、それ以外は `60000` 以上
* **デフォルト**: 未設定。Claude Code は起動時に 1 回だけヘルパーを実行します

この例では、5 分ごとにヘルパーを再実行します。

```json managed-settings.json theme={null}
{
  "policyHelper": {
    "path": "/usr/local/bin/claude-policy",
    "refreshIntervalMs": 300000
  }
}
```

### `wslInheritsWindowsSettings`

WSL 上の Claude Code に Windows のポリシーチェーンから管理設定を読み取らせます。このチェーンでは、HKLM と Windows の管理設定ファイルが `/etc/claude-code` より優先され、その下位に HKCU が置かれます。チェーンがオンの間、Claude Code は、HKLM レジストリの値または `C:\Program Files\ClaudeCode\` フォルダーに [Windows の管理ドキュメントが存在しない](https://code.claude.com/docs/ja/managed-settings.md#present-admin-documents)場合にのみ `/etc/claude-code` を読み取ります。Windows ですでにデプロイしているポリシーを同じマシン上の WSL セッションにも拡張し、ホストのセッションと同じルールに従わせる場合に設定してください。Claude Code は、HKLM レジストリキー、または `C:\Program Files\ClaudeCode\` 配下の管理設定ファイルやドロップインで設定されている場合にのみこれを尊重します。どちらも書き込みに Windows の管理者権限が必要です。

* **スコープ**: [`Managed`](#scopes)。管理者が制御する Windows ソース内。
* **型**: Boolean
  * `true`: WSL 上の Claude Code は Windows のポリシーチェーンから管理設定を読み取り、Windows の管理ドキュメントが存在しない場合にのみ `/etc/claude-code` を読み取ります
  * `false`: WSL は `/etc/claude-code` のみを読み取ります
* **デフォルト**: `false`。WSL は `/etc/claude-code` のみを読み取ります

```json managed-settings.json theme={null}
{
  "wslInheritsWindowsSettings": true
}
```

管理ソースがチェーンをオンにすると、WSL 上で HKCU のポリシーがチェーンに加わるのは、HKCU もこのキーを `true` に設定している場合に限られます。HKCU のこの設定だけでチェーンがオンになることはありません。このキーのみを含む Windows ソースは、`true` と `false` のどちらに設定されていてもポリシーソースとして扱われないため、下位のソースが引き続きポリシーを提供します。このキーはネイティブの Windows には影響しません。

Claude Code は、`true` と `false` を引用符の有無にかかわらず読み取り、`null` をキーの削除として読み取ります。管理者が制御する Windows ソースがそれ以外の値を持つ場合、チェーンがオンになった[存在する管理ドキュメント](https://code.claude.com/docs/ja/managed-settings.md#present-admin-documents)として扱われます。この場合、`/etc/claude-code` と HKCU のどちらも適用されず、起動時の警告でこのキーが示されます。存在するものの読み取れない HKLM の値や Windows フォルダーのファイルも、チェーンがオンかどうかにかかわらず `/etc/claude-code` が適用されないようにします。Claude Code v2.1.282 以降が必要です。

## グローバル設定

これらのキーを `~/.claude.json` に保存してください。設定ファイルには保存しないでください。Claude Code はそれ以外の場所ではこれらを無視します。Claude Code と `/config` はほとんどのキーを自動的に書き込みます。また、手動で編集することもできます。

### `autoConnectIde`

外部ターミナルから Claude Code を起動するときに、実行中の IDE に自動的に接続します。VS Code または JetBrains ターミナルの外で Claude Code を実行する場合、`/config` に **Auto-connect to IDE (external terminal)** として表示されます。

* **スコープ**: [`グローバル設定`](#scopes)
* **タイプ**: ブール値
  * `true`: Claude Code は外部ターミナルから起動するときに、実行中の IDE に自動的に接続します
  * `false`: Claude Code は外部ターミナルから自動的に接続しません。ただし、VS Code または JetBrains ターミナル内、または `--ide` を使用する場合は接続します
* **デフォルト**: `false`
* **セッションごとのオーバーライド**: [`CLAUDE_CODE_AUTO_CONNECT_IDE`](https://code.claude.com/docs/ja/env-vars) はこのキーより優先され、1 つのセッションでどちらの方向でも機能します

```json ~/.claude.json theme={null}
{
  "autoConnectIde": true
}
```

Claude Code は `settings.json` でこのキーを無視します。

### `autoInstallIdeExtension`

VS Code ターミナルから Claude Code を実行するときに、Claude Code IDE 拡張機能を自動的にインストールします。VS Code または JetBrains ターミナル内で Claude Code を実行する場合、`/config` に **Auto-install IDE extension** として表示されます。

* **スコープ**: [`グローバル設定`](#scopes)
* **タイプ**: ブール値
  * `true`: Claude Code は VS Code ターミナルから実行するときに IDE 拡張機能を自動的にインストールします
  * `false`: Claude Code は拡張機能を自動的にインストールしません
* **デフォルト**: `true`
* **セッションごとのオーバーライド**: [`CLAUDE_CODE_IDE_SKIP_AUTO_INSTALL`](https://code.claude.com/docs/ja/env-vars) を `1` に設定すると、このキーが `true` の場合でも 1 つのセッションのインストールをスキップします

```json ~/.claude.json theme={null}
{
  "autoInstallIdeExtension": false
}
```

Claude Code は `settings.json` でこのキーを無視します。

### `claudeInChromeDefaultEnabled`

[Chrome 統合](https://code.claude.com/docs/ja/chrome.md)をオンにして、毎回 `--chrome` を渡さずにすべてのインタラクティブ CLI セッションを開始します。[`claude remote-control`](https://code.claude.com/docs/ja/remote-control) を実行する場合、[プロジェクト](https://code.claude.com/docs/ja/claude-projects.md)スレッドの 1 つに対して開始するセッションもこのキーに従います。ただし、`bypassPermissions` モードの場合は除きます。Claude Code v2.1.287 以降では、このキーは [VS Code 拡張機能](https://code.claude.com/docs/ja/vs-code.md#automate-browser-tasks-with-chrome)のセッションにも適用されます。詳しくは [Chrome をデフォルトで有効にする](https://code.claude.com/docs/ja/chrome.md#enable-chrome-by-default)を参照してください。

`/chrome` を実行して **Enabled by default** を選択すると、このキーが設定されます。`/config` に **Claude in Chrome enabled by default** として表示されます。

* **スコープ**: [`グローバル設定`](#scopes)
* **タイプ**: ブール値
  * `true`: Claude Code は `--chrome` を渡すときと同様に、インタラクティブ CLI セッションが開始するときに Chrome 統合をオンにします。VS Code 拡張機能では、セッションは開始時にブラウザに接続します
  * `false`: インタラクティブ CLI セッションは Chrome 統合をオフで開始し、Claude Code は[セットアップを提案するのを停止](https://code.claude.com/docs/ja/chrome.md#install-the-extension-when-claude-asks)します。1 つのインタラクティブセッションでオンにするには `--chrome` を渡してください。VS Code 拡張機能では、キーが未設定の場合と同様に、`@browser` と入力したときにセッションが接続します
* **デフォルト**: 未設定。Chrome 統合はオフで、Claude Code はセットアップを提案できます
* **セッションごとのオーバーライド**: `--chrome` と [`--no-chrome`](https://code.claude.com/docs/ja/cli-reference) はこのキーより優先され、1 つのインタラクティブセッションで機能します

```json ~/.claude.json theme={null}
{
  "claudeInChromeDefaultEnabled": true
}
```

Claude Code は `settings.json` でこのキーを無視します。

### `copyFullResponse`

[`/copy`](https://code.claude.com/docs/ja/commands) がピッカーを表示せずに、毎回完全な応答をコピーするようにします。そのピッカーで **Always copy full response** を選択すると、このキーが `true` に設定されます。`/config` に **Skip the /copy picker** として表示されます。

* **スコープ**: [`グローバル設定`](#scopes)
* **タイプ**: ブール値
  * `true`: `/copy` はピッカーを表示せずに完全な応答をコピーします
  * `false`: 応答にコードブロックまたは引用ブロックが含まれている場合、`/copy` はピッカーを表示し、1 つのブロックまたは完全な応答を選択できます
* **デフォルト**: `false`

```json ~/.claude.json theme={null}
{
  "copyFullResponse": true
}
```

Claude Code は `settings.json` でこのキーを無視します。

### `copyOnSelect`

[フルスクリーンレンダリング](https://code.claude.com/docs/ja/fullscreen.md#use-the-mouse)または[エージェントビュー](https://code.claude.com/docs/ja/agent-view.md)でマウスで選択を終了したときに、テキストをクリップボードに自動的にコピーします。フルスクリーンレンダリングがオンの場合、`/config` に **Copy on select** として表示されます。

* **スコープ**: [`グローバル設定`](#scopes)
* **タイプ**: ブール値
  * `true`: Claude Code は選択を終了したときにテキストをクリップボードにコピーします
  * `false`: テキストを選択してもクリップボードは変わらず、代わりに[キーボードショートカットで選択をコピー](https://code.claude.com/docs/ja/fullscreen.md#use-the-mouse)します
* **デフォルト**: `true`

```json ~/.claude.json theme={null}
{
  "copyOnSelect": false
}
```

Claude Code は `settings.json` でこのキーを無視します。

### `defaultToAgentsView`

引数なしで `claude` を実行するときに、新しい会話の代わりに[エージェントビュー](https://code.claude.com/docs/ja/agent-view.md)を開きます。エージェントビューが[オフ](#disableagentview)になっていない限り、`/config` に **Open agents view by default** として表示されます。

* **スコープ**: [`グローバル設定`](#scopes)
* **タイプ**: ブール値
  * `true`: 引数なしの `claude` はエージェントビューを開きます。ただし、エージェントビューが[オフ](#disableagentview)になっている場合は除きます
  * `false`: 引数なしの `claude` は新しい会話を開始します
* **デフォルト**: `false`

```json ~/.claude.json theme={null}
{
  "defaultToAgentsView": true
}
```

Claude Code は `settings.json` でこのキーを無視します。

### `diffTool`

[VS Code](https://code.claude.com/docs/ja/vs-code.md)または[JetBrains](https://code.claude.com/docs/ja/jetbrains.md#features) IDE が接続されているときに、Claude Code が提案する `Edit` または `Write` 変更の差分を表示する場所を選択します。`"auto"` は IDE の差分ビューアで開き、`"terminal"` はターミナルに保持します。Claude Code が VS Code または JetBrains IDE に接続されている場合のみ、`/config` に **Diff tool** として表示されます。

* **スコープ**: [`グローバル設定`](#scopes)
* **タイプ**: 文字列、以下のいずれか：
  * `"auto"`: Claude Code は VS Code または JetBrains IDE が接続されているときに IDE の差分ビューアで差分を開きます
  * `"terminal"`: Claude Code は差分をターミナルに保持します
* **デフォルト**: `"auto"`

```json ~/.claude.json theme={null}
{
  "diffTool": "terminal"
}
```

Claude Code は `settings.json` でこのキーを無視します。

### `externalEditorContext`

`Ctrl+G` を押すと、Claude Code は入力中のプロンプトを[外部エディタ](https://code.claude.com/docs/ja/interactive-mode.md#general-controls)で開きます。このキーをオンにすると、エディタバッファは Claude の前の応答で `#` コメント行として開始されるため、書き込み中に読むことができ、Claude Code は保存時にこれらの行を削除します。`/config` に **Show last response in external editor** として表示されます。

* **スコープ**: [`グローバル設定`](#scopes)
* **タイプ**: ブール値
  * `true`: エディタバッファは Claude の前の応答で `#` コメント行として開始され、Claude Code は保存時にこれらを削除します
  * `false`: エディタバッファはプロンプトのみで開きます
* **デフォルト**: `false`

```json ~/.claude.json theme={null}
{
  "externalEditorContext": true
}
```

オンにすると、Claude Code が開くバッファは次のようになり、マーカー行の下のテキストのみがプロンプトとして送信されます：

```text theme={null}
# ─── Claude's last response (for reference; removed on save) ───
# I added the retry loop to fetchUser in src/api.ts and a test
# for the timeout case. Want me to wire the same retry into
# fetchOrders?
# ─── Write your reply below this line ──────────────────────────

Yes, and cap it at three attempts.
```

Claude Code は応答の最後の 50 行を保持し、カットを `# … (earlier output truncated)` でマークします。

Claude Code は `settings.json` でこのキーを無視します。

### `leftArrowOpensAgents`

空のプロンプトで `←` を押して、[セッションをバックグラウンドにしてエージェントビューを開き](https://code.claude.com/docs/ja/agent-view.md#switch-sessions-without-leaving-the-terminal)ます。このキーを `false` に設定してショートカットをオフにします。エージェントビューが利用可能な場合、`/config` に **← opens agents** として表示されます。

* **スコープ**: [`グローバル設定`](#scopes)
* **タイプ**: ブール値
  * `true`: ターミナルで開始したセッションの空のプロンプトで `←` を押すと、セッションがバックグラウンドになり、エージェントビューが開きます
  * `false`: Claude Code はショートカットをオフにします。[エージェントビューから接続した](https://code.claude.com/docs/ja/agent-view.md#attach-to-a-session)セッションでは、空のプロンプトで `←` を押すと切断されます
* **デフォルト**: `true`

```json ~/.claude.json theme={null}
{
  "leftArrowOpensAgents": false
}
```

Claude Code は `settings.json` でこのキーを無視します。

### `permissionExplainerEnabled`

> [!WARNING]
>
> v2.1.257 で削除されました。Bash および PowerShell 権限プロンプトの `Ctrl+E` コマンド説明と一緒に削除されました。現在のバージョンでこれを設定しても効果はありません。

v2.1.256 まで、Bash または PowerShell 権限プロンプトで `Ctrl+E` を押してコマンドのモデル生成説明を表示でき、このキーを `false` に設定してそのショートカットをオフにできました。

* **スコープ**: [`グローバル設定`](#scopes)。v2.1.256 以前。
* **タイプ**: ブール値
* **デフォルト**: `true`

### `prStatusFooterEnabled`

現在のブランチのオープンなプルリクエストまたはマージリクエストのバッジをプロンプトフッターに表示し、その[ステータス](https://code.claude.com/docs/ja/interactive-mode.md#pr-review-status)を示す色付きの下線を表示します。`/config` に **Show PR status footer** として表示されます。

* **スコープ**: [`グローバル設定`](#scopes)
* **タイプ**: ブール値
  * `true`: フッターは [PR レビューステータス](https://code.claude.com/docs/ja/interactive-mode.md#pr-review-status)の条件下でバッジを表示します
  * `false`: Claude Code はフッターのプルリクエストおよびマージリクエストチェックをスキップし、そのバッジを表示しません。[エージェントビューから接続した](https://code.claude.com/docs/ja/agent-view.md#attach-to-a-session)セッションは、[リンクされた](https://code.claude.com/docs/ja/agent-view.md#pull-request-status)プルリクエストへのプレーンリンクを表示できます
* **デフォルト**: `true`

```json ~/.claude.json theme={null}
{
  "prStatusFooterEnabled": false
}
```

Claude Code は `settings.json` でこのキーを無視します。

### `teammateDefaultModel`

> [!WARNING]
>
> v2.1.234 で削除されました。その `/config` 行 **Default teammate model** と一緒に削除されました。現在のバージョンでこれを設定しても効果はありません。

v2.1.233 まで、このキーを[エージェントチーム](https://code.claude.com/docs/ja/agent-teams.md#specify-teammates-and-models)のチームメイトのモデルに設定しました。プロンプトがモデルを指定しなかったチームメイト用：`"sonnet"` などのエイリアス、または `null` でリードのモデルに従う。Claude Code が現在そのようなチームメイト用に選択するモデルについては、[チームメイトとモデルを指定](https://code.claude.com/docs/ja/agent-teams.md#specify-teammates-and-models)を参照してください。

* **スコープ**: [`グローバル設定`](#scopes)。v2.1.233 以前。
* **タイプ**: 文字列、モデルエイリアスまたは完全なモデル ID、または `null`
* **デフォルト**: 未設定

## 関連項目

* [権限を設定する](https://code.claude.com/docs/ja/permissions.md)：ルール構文、権限モード、ワークスペース信頼
* [環境変数](https://code.claude.com/docs/ja/env-vars.md)：Claude Code が読み込むすべての `CLAUDE_*`、`ANTHROPIC_*`、およびプロバイダー変数
* [Claude で利用可能なツール](https://code.claude.com/docs/ja/tools-reference.md)：組み込みツールと承認が必要なツール
* [設定ファイルの例](https://code.claude.com/docs/ja/settings-example.md)：個人用ファイル、チームファイル、および組織の管理ファイル
* [管理設定をセットアップする](https://code.claude.com/docs/ja/admin-setup.md)：組織が何を強制するかを決定する方法
* [管理設定をデプロイする](https://code.claude.com/docs/ja/managed-settings.md)：配信メカニズム、管理層内の優先順位、および管理設定の無効なエントリ
* [設定をデバッグする](https://code.claude.com/docs/ja/debug-your-config.md)：`claude doctor` と設定エラーダイアログ
