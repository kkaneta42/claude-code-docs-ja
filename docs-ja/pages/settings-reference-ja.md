> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# すべての設定

> Claude Code の settings.json キーの完全なリファレンス：各キーの場所、型とデフォルト値、貼り付け可能な例、およびすべてのキーのインデックス。

[Back to index](#all-settings)

このリファレンスページでは、Claude Code が設定ファイルから読み込む各キーと、代わりに `~/.claude.json` に保持する[短いキーグループ](#global-config-settings)を一覧表示しています。ファイルを選択するか、優先順位を確認するには、[設定ファイルと優先順位](/docs/ja/settings)から始めてください。

## 設定インデックス

以下の各キーは、それぞれの項目にリンクしています。Scope 列には、そのキーを記述できる[ファイル](/docs/ja/settings#settings-files-and-who-they-affect)が示されています。`User` は `~/.claude/settings.json`、`Project` は `.claude/settings.json`、`Local` は `.claude/settings.local.json`、`Managed` は[組織がデプロイするもの](/docs/ja/managed-settings)です。`Any file` はこの 4 つすべてを意味し、`Global config` は [`~/.claude.json`](#global-config-settings) を意味します。

| Key | Description | Topic | Scope |
| :- | :- | :- | :- |
| [`advisorModel`](#advisormodel) | Claude が [advisor ツール](/docs/ja/advisor)に問い合わせたときに応答するモデルを選択します | モデルと応答 | Any file |
| [`agent`](#agent) | すべてのセッションを、そのプロンプト、ツール、モデルを備えた名前付き[サブエージェント](/docs/ja/sub-agents)として開始します | エージェント、セッション、worktree | Any file |
| [`agentPushNotifEnabled`](#agentpushnotifenabled) | Claude が判断したときに[スマートフォンへのプッシュ通知](/docs/ja/remote-control#mobile-push-notifications)を送信できるようにします | リモート、デスクトップ、通知 | Any file |
| [`allowAllClaudeAiMcps`](#allowallclaudeaimcps) | デプロイされた [`managed-mcp.json`](/docs/ja/managed-mcp#exclusive-control-with-managed-mcp-json) と並行して、Claude Code が自ら取得する [claude.ai コネクタ](/docs/ja/mcp)を読み込みます | MCP | Managed |
| [`allowClaudeInChromeWithManagedMcp`](#allowclaudeinchromewithmanagedmcp) | デプロイされた [`managed-mcp.json`](/docs/ja/managed-mcp#exclusive-control-with-managed-mcp-json) と並行して、組み込みの [Claude in Chrome](/docs/ja/chrome) サーバーを実行できるようにします | MCP | Managed |
| [`allowedChannelPlugins`](#allowedchannelplugins) | メッセージをプッシュできる[チャネルプラグイン](/docs/ja/channels#restrict-which-channel-plugins-can-run)のデフォルトの許可リストを置き換えます | プラグインとスキル | Managed |
| [`allowedHttpHookUrls`](#allowedhttphookurls) | [HTTP フック](/docs/ja/hooks)が送信先にできる URL を制限します | フックと自動化 | Any file |
| [`allowedMcpServers`](#allowedmcpservers) | ユーザーが追加できる [MCP サーバー](/docs/ja/mcp)の許可リストを指定します | MCP | Any file |
| [`allowedProviders`](#allowedproviders) | マシンが使用できる [API プロバイダー](/docs/ja/third-party-integrations)を制限します | 認証とプロバイダー | Managed |
| [`allowManagedHooksOnly`](#allowmanagedhooksonly) | 組織がデプロイした[フック](/docs/ja/hooks)のみを実行します | フックと自動化 | Managed |
| [`allowManagedMcpServersOnly`](#allowmanagedmcpserversonly) | 管理された [MCP](/docs/ja/mcp) 許可リストのみが適用されるようにします | MCP | Managed |
| [`allowManagedPermissionRulesOnly`](#allowmanagedpermissionrulesonly) | [管理設定](/docs/ja/managed-settings)を[権限ルール](/docs/ja/permissions#managed-settings)の唯一の設定ソースにします | 権限設定 | Managed |
| [`alwaysThinkingEnabled`](#alwaysthinkingenabled) | すべてのセッションで[拡張思考](/docs/ja/model-config#extended-thinking)をオフにします | モデルと応答 | Any file |
| [`apiKeyHelper`](#apikeyhelper) | 独自のコマンドで [API 認証情報](/docs/ja/authentication#credential-management)を生成します | 認証とプロバイダー | Any file |
| [`askUserQuestionTimeout`](#askuserquestiontimeout) | 回答されていない質問が、アイドル時間の経過後に[自動的に続行](/docs/ja/tools-reference#question-auto-continue-timeout)されるようにします | インターフェースとターミナル | User or managed |
| [`appendPlugins`](#appendplugins) | ユーザーがインストールしたすべての mod の後に、組織の [mod](/docs/ja/plugins/mods/admin) を実行します | プラグインとスキル | User or managed |
| [`attribution`](#attribution) | Claude Code がコミットとプルリクエストに追加する帰属表示をカスタマイズします | Git と帰属表示 | Any file |
| [`attribution.commit`](#attribution-commit) | Claude Code がコミットに追加するトレーラーを変更または非表示にします | Git と帰属表示 | Any file |
| [`attribution.pr`](#attribution-pr) | プルリクエストの説明にある帰属表示行を変更または非表示にします | Git と帰属表示 | Any file |
| [`attribution.sessionUrl`](#attribution-sessionurl) | [クラウド](/docs/ja/claude-code-on-the-web)および [Remote Control](/docs/ja/remote-control) のコミットから claude.ai のセッションリンクを省きます | Git と帰属表示 | Any file |
| [`autoCompactEnabled`](#autocompactenabled) | [自動圧縮](/docs/ja/context-window)をオフまたはオンにします | メモリとコンテキスト | Any file |
| [`autoCompactWindow`](#autocompactwindow) | Claude Code が[圧縮](/docs/ja/context-window)を行う前にコンテキストがどの程度埋まるかを設定します | メモリとコンテキスト | Any file |
| [`autoConnectIde`](#autoconnectide) | 外部ターミナルから、実行中の [VS Code](/docs/ja/vs-code) または [JetBrains](/docs/ja/jetbrains#from-external-terminals) IDE に自動的に接続します | グローバル設定 | Global config |
| [`autoContinueAtUsageLimit`](#autocontinueatusagelimit) | 開いているセッションで待機し、claude.ai の使用制限がリセットされた後に[タスクを自動的に続行](/docs/ja/interactive-mode#wait-for-a-usage-limit-to-reset)します | インターフェースとターミナル | User or managed |
| [`autoInstallIdeExtension`](#autoinstallideextension) | VS Code のターミナルからの [IDE 拡張機能](/docs/ja/vs-code#install-the-extension)の自動インストールをオフにします | グローバル設定 | Global config |
| [`autoMemoryDirectory`](#automemorydirectory) | [自動メモリ](/docs/ja/memory#auto-memory)を任意のディレクトリに保存します | メモリとコンテキスト | Any file |
| [`autoMemoryEnabled`](#automemoryenabled) | [自動メモリ](/docs/ja/memory#auto-memory)をオフまたはオンにします | メモリとコンテキスト | Any file |
| [`autoMode`](#automode) | [auto モード](/docs/ja/permission-modes#eliminate-prompts-with-auto-mode)の分類器に独自の許可ルールと拒否ルールを追加します | 権限設定 | User or managed |
| [`autoMode.classifyAllShell`](#automode-classifyallshell) | 限定的な許可ルールに一致するものも含め、すべてのシェルコマンドを [auto モードの分類器](/docs/ja/permission-modes#what-the-classifier-blocks-by-default)に送ります | 権限設定 | User or managed |
| [`autoScrollEnabled`](#autoscrollenabled) | フルスクリーンレンダリングで[新しい出力に追従](/docs/ja/fullscreen#auto-follow)して最下部までスクロールします | インターフェースとターミナル | Any file |
| [`autoUpdatesChannel`](#autoupdateschannel) | latest ではなく stable の[リリースチャネル](/docs/ja/setup#configure-release-channel)に従います | 更新とバージョン管理 | Any file |
| [`availableModels`](#availablemodels) | ユーザーが選択できる[モデルを制限](/docs/ja/model-config#restrict-model-selection)します | モデルと応答 | Any file |
| [`availableModelsMatch`](#availablemodelsmatch) | `availableModels` の各モデル ID エントリが、[その名前が示すバージョンのみを許可](/docs/ja/model-config#block-specific-models-or-versions)するようにします | モデルと応答 | Managed |
| [`awaySummaryEnabled`](#awaysummaryenabled) | ターミナルに戻ったときに表示される[セッションの要約](/docs/ja/interactive-mode#session-recap)をオフにします | リモート、デスクトップ、通知 | Any file |
| [`awsAuthRefresh`](#awsauthrefresh) | 独自のコマンドで、`.aws` 内の期限切れの [Bedrock 認証情報](/docs/ja/amazon-bedrock#advanced-credential-configuration)を更新します | 認証とプロバイダー | Any file |
| [`awsCredentialExport`](#awscredentialexport) | 独自のコマンドから [Bedrock 認証情報](/docs/ja/amazon-bedrock#advanced-credential-configuration)を JSON として提供します | 認証とプロバイダー | Any file |
| [`axScreenReader`](#axscreenreader) | [スクリーンリーダーに適した出力](/docs/ja/accessibility)をレンダリングします | インターフェースとターミナル | Any file |
| [`bashEditDiffEnabled`](#basheditdiffenabled) | すべての権限モードで、[Bash コマンドの実行中に変更されたファイル](/docs/ja/hooks#bash)を記録します | インターフェースとターミナル | User or managed |
| [`bashOutputMaxChars`](#bashoutputmaxchars) | 成功したコマンドの[出力](/docs/ja/tools-reference#output-limits)のうち、Claude がインラインで受け取る量を設定します | メモリとコンテキスト | Any file |
| [`blockedMarketplaces`](#blockedmarketplaces) | 組織に対して[プラグインマーケットプレイス](/docs/ja/plugins/overview)のソースをブロックします | プラグインとスキル | Managed |
| [`browserExternalPageTools`](#browserexternalpagetools) | [デスクトップ](/docs/ja/desktop)の Browser ペインで、Claude のツールが外部ページで動作しないようにします | ツール | Managed |
| [`channelsEnabled`](#channelsenabled) | 組織で[チャネル](/docs/ja/channels#enable-channels-for-your-organization)を許可します | プラグインとスキル | Managed |
| [`claudeInChromeDefaultEnabled`](#claudeinchromedefaultenabled) | 対話型 CLI と VS Code 拡張機能で、セッションの開始時に [Chrome 統合](/docs/ja/chrome)をオンにします | グローバル設定 | Global config |
| [`claudeMd`](#claudemd) | 管理設定から組織全体の [CLAUDE.md](/docs/ja/memory#deploy-organization-wide-claude-md) の指示を注入します | メモリとコンテキスト | Managed |
| [`claudeMdExcludes`](#claudemdexcludes) | メモリの読み込み時に特定の [CLAUDE.md](/docs/ja/memory#exclude-specific-claude-md-files) ファイルをスキップします | メモリとコンテキスト | Any file |
| [`cleanupPeriodDays`](#cleanupperioddays) | Claude Code が[トランスクリプト](/docs/ja/data-usage#data-retention)を削除するまで保持する日数を選択します | プライバシーとテレメトリ | Any file |
| [`companyAnnouncements`](#companyannouncements) | 起動時に組織のお知らせを表示します | インターフェースとターミナル | Any file |
| [`copyFullResponse`](#copyfullresponse) | [`/copy`](/docs/ja/commands) がピッカーを表示せずに応答全体をコピーするようにします | グローバル設定 | Global config |
| [`copyOnSelect`](#copyonselect) | [フルスクリーンレンダリング](/docs/ja/fullscreen#use-the-mouse)とエージェントビューで、マウスで選択したテキストの自動コピーをオフにします | グローバル設定 | Global config |
| [`crossSessionInbound`](#crosssessioninbound) | Claude Code が[他のセッションからのメッセージ](/docs/ja/cross-session-messaging#control-inbound-messages)を配信するか、配信せずに通知を表示するか、拒否するかを選択します | エージェント、セッション、worktree | Any file |
| [`defaultShell`](#defaultshell) | [`!` プレフィックス](/docs/ja/interactive-mode#shell-mode-with-prefix)で入力したシェルコマンドを Bash と PowerShell のどちらで実行するかを選択します | インターフェースとターミナル | Any file |
| [`defaultToAgentsView`](#defaulttoagentsview) | 引数なしで `claude` を実行したときに、新しい会話ではなく[エージェントビュー](/docs/ja/agent-view)を開きます | グローバル設定 | Global config |
| [`deniedMcpServers`](#deniedmcpservers) | URL、コマンド、または名前で特定の [MCP サーバー](/docs/ja/mcp)をブロックします | MCP | Any file |
| [`deniedModels`](#deniedmodels) | `availableModels` で許可されているものも含め、[特定のモデルをブロック](/docs/ja/model-config#block-specific-models-or-versions)します | モデルと応答 | Managed |
| [`desktopSessionCleanupPeriodDays`](#desktopsessioncleanupperioddays) | [Claude Desktop と Cowork のトランスクリプト](/docs/ja/claude-directory#cleaned-up-automatically)の保持期間の上限を日数で設定します | プライバシーとテレメトリ | User or managed |
| [`dialogExpiry`](#dialogexpiry) | 転送されたダイアログに [Remote Control](/docs/ja/remote-control) または SDK ホストが応答するまで、Claude Code がダイアログをキャンセルせずに待機する時間を設定します | インターフェースとターミナル | User or managed |
| [`diffTool`](#difftool) | Claude が提案するファイル変更を [VS Code](/docs/ja/vs-code) または [JetBrains](/docs/ja/jetbrains#features) の差分ビューアーで開くか、ターミナルに表示したままにするかを選択します | グローバル設定 | Global config |
| [`disableAgentView`](#disableagentview) | バックグラウンドエージェントと[エージェントビュー](/docs/ja/agent-view)をオフにします | エージェント、セッション、worktree | Any file |
| [`disableAllHooks`](#disableallhooks) | [フック](/docs/ja/hooks)、カスタム[ステータスライン](/docs/ja/statusline)、カスタム [`@` ファイル候補](/docs/ja/interactive-mode#quick-commands)コマンドをまとめてオフにします | フックと自動化 | Any file |
| [`disableArtifact`](#disableartifact) | 非推奨です。[Artifact ツール](/docs/ja/artifacts)をオフにするには `enableArtifact` を使用してください | リモート、デスクトップ、通知 | Any file |
| [`disableAutoMode`](#disableautomode) | 権限モードの切り替えサイクルから [auto モード](/docs/ja/permission-modes#eliminate-prompts-with-auto-mode)を除外します | 権限設定 | Any file |
| [`disableBrowserExternalNavigation`](#disablebrowserexternalnavigation) | [デスクトップ](/docs/ja/desktop)の Browser ペインを、ユーザーと Claude の両方について localhost に制限します | ツール | Managed |
| [`disableBundledSkills`](#disablebundledskills) | Claude Code に含まれる[スキル](/docs/ja/skills#bundled-skills)と[ワークフロー](/docs/ja/workflows)をオフにします | プラグインとスキル | Any file |
| [`disableClaudeAiConnectors`](#disableclaudeaiconnectors) | [claude.ai コネクタ](/docs/ja/mcp#disable-claude-ai-connectors)をオフにし、Claude Code がそれらを取得しないようにします | MCP | Any file |
| [`disableCommandPluginSources`](#disablecommandpluginsources) | マーケットプレイスで宣言されたコマンドを実行してインストールする[プラグイン](/docs/ja/plugins/overview)をブロックします | プラグインとスキル | Managed |
| [`disableDeepLinkRegistration`](#disabledeeplinkregistration) | Claude Code が [`claude-cli://` ハンドラー](/docs/ja/deep-links)を登録しないようにします | リモート、デスクトップ、通知 | Any file |
| [`disableDesktopLocalSessions`](#disabledesktoplocalsessions) | デバイス上で実行される [Desktop の Code セッション](/docs/ja/desktop#local-sessions-on-managed-devices)をオフにし、他のホストへの SSH とクラウドのみを残します | リモート、デスクトップ、通知 | Managed |
| [`disabledMcpjsonServers`](#disabledmcpjsonservers) | プロジェクトの [`.mcp.json`](/docs/ja/mcp#project-scope) にある特定のサーバーを拒否します | MCP | Any file |
| [`disableMobileSimulatorTools`](#disablemobilesimulatortools) | [デスクトップ](/docs/ja/desktop)の iOS Simulator ペインで Claude のツールをブロックします | ツール | Managed |
| [`disableRemoteControl`](#disableremotecontrol) | [Remote Control](/docs/ja/remote-control) を、起動可能なすべての場所でオフにします | リモート、デスクトップ、通知 | Any file |
| [`disableSideloadFlags`](#disablesideloadflags) | [プラグイン](/docs/ja/plugins/overview)、[サブエージェント](/docs/ja/sub-agents)、[MCP サーバー](/docs/ja/mcp)をサイドロードする CLI フラグを拒否します | エンタープライズと管理設定 | Managed |
| [`disableSkillShellExecution`](#disableskillshellexecution) | [スキル](/docs/ja/skills)とカスタムコマンドがインラインでシェルを実行しないようにします | プラグインとスキル | Any file |
| [`disableWorkflows`](#disableworkflows) | [動的ワークフロー](/docs/ja/workflows)を全員に対してオフにします。自分だけに適用するには `enableWorkflows` を使用してください | フックと自動化 | Any file |
| [`editorMode`](#editormode) | 入力プロンプトで [vim キーバインド](/docs/ja/interactive-mode#vim-editor-mode)を使用します | インターフェースとターミナル | Any file |
| [`effortLevel`](#effortlevel) | 独自に保存されたレベルを持たないモデルに対して、デフォルトの [effort レベル](/docs/ja/model-config#adjust-effort-level)を設定します | モデルと応答 | Any file |
| [`emojiCompletionEnabled`](#emojicompletionenabled) | プロンプト入力での [`:shortcode:` 絵文字の候補表示と置換](/docs/ja/interactive-mode#emoji-shortcodes)をオフにします | インターフェースとターミナル | Any file |
| [`enableAllProjectMcpServers`](#enableallprojectmcpservers) | プロジェクトの [`.mcp.json`](/docs/ja/mcp#project-server-approvals-and-workspace-trust) ファイル内のすべてのサーバーを、プロンプトなしで承認します | MCP | Any file |
| [`enableArtifact`](#enableartifact) | いずれかのファイルで `false` を指定すると [Artifact ツール](/docs/ja/artifacts)をオフにします。どのファイルからも再びオンにすることはできません | リモート、デスクトップ、通知 | Any file |
| [`enabledMcpjsonServers`](#enabledmcpjsonservers) | プロジェクトの [`.mcp.json`](/docs/ja/mcp#project-server-approvals-and-workspace-trust) にある特定のサーバーを承認します | MCP | Any file |
| [`enabledPlugins`](#enabledplugins) | 個々の[プラグイン](/docs/ja/plugins/overview)をスコープごとにオンまたはオフにします | プラグインとスキル | Any file |
| [`enableWorkflows`](#enableworkflows) | プランのデフォルトに対して[動的ワークフロー](/docs/ja/workflows)をオンまたはオフにします | フックと自動化 | Any file |
| [`enforceAvailableModels`](#enforceavailablemodels) | [`/model` の Default の選択肢](/docs/ja/model-config#enforce-the-allowlist-for-the-default-model)を `availableModels` 許可リストの範囲内に保ちます | モデルと応答 | Any file |
| [`env`](#env) | すべてのセッションとそのサブプロセスに対して[環境変数](/docs/ja/env-vars#in-settings-files)を設定します | メモリとコンテキスト | Any file |
| [`externalEditorContext`](#externaleditorcontext) | [Ctrl+G](/docs/ja/interactive-mode#general-controls) を押して編集するときに、Claude の直前の応答をコメントとして表示します | グローバル設定 | Global config |
| [`extraKnownMarketplaces`](#extraknownmarketplaces) | リポジトリまたは組織に対して[マーケットプレイス](/docs/ja/plugins/overview)を登録します | プラグインとスキル | Any file |
| [`fallbackModel`](#fallbackmodel) | プライマリモデルが過負荷のときに使う[バックアップモデル](/docs/ja/model-config#fallback-model-chains)を指定します | モデルと応答 | Any file |
| [`fastMode`](#fastmode) | 利用可能なセッションで [fast mode](/docs/ja/fast-mode) をオンにします | モデルと応答 | Any file |
| [`fastModePerSessionOptIn`](#fastmodepersessionoptin) | セッションごとに [fast mode](/docs/ja/fast-mode) をオンにすることを必須にします | モデルと応答 | Any file |
| [`feedbackDrafts`](#feedbackdrafts) | Claude がレビュー用の[フィードバックの下書き](/docs/ja/tools-reference#sendfeedback-tool-behavior)をキューに入れるかどうかを制御します | プライバシーとテレメトリ | User or managed |
| [`feedbackSurveyRate`](#feedbacksurveyrate) | [セッション品質アンケート](/docs/ja/data-usage#session-quality-surveys)が表示される頻度を変更します | プライバシーとテレメトリ | Any file |
| [`fileCheckpointingEnabled`](#filecheckpointingenabled) | [`/rewind`](/docs/ja/checkpointing) が復元するファイルスナップショットをオフまたはオンにします | メモリとコンテキスト | Any file |
| [`fileSuggestion`](#filesuggestion) | 独自のコマンドから [`@` ファイルのオートコンプリート](/docs/ja/interactive-mode#quick-commands)を提供します | インターフェースとターミナル | Any file |
| [`footerLinksRegexes`](#footerlinksregexes) | 出力内の issue やレビューの ID を、入力ボックスの下にある[クリック可能なリンク](/docs/ja/statusline#clickable-links)にします | インターフェースとターミナル | User or managed |
| [`forceLoginGatewayUrl`](#forcelogingatewayurl) | ログイン画面が接続する[ゲートウェイ URL](/docs/ja/claude-apps-gateway#set-the-gateway-url) を設定します | 認証とプロバイダー | User or managed |
| [`forceLoginMethod`](#forceloginmethod) | [ログインを](/docs/ja/authentication#restrict-login-to-your-organization) claude.ai、Claude Console、または[クラウドゲートウェイ](/docs/ja/claude-apps-gateway)に制限します | 認証とプロバイダー | Any file |
| [`forceLoginOrgUUID`](#forceloginorguuid) | [claude.ai のログインを組織に固定](/docs/ja/authentication#restrict-login-to-your-organization)します。これを強制できるのは管理ソースのみです | 認証とプロバイダー | Any file |
| [`forceRemoteSettingsRefresh`](#forceremotesettingsrefresh) | [サーバー管理設定](/docs/ja/server-managed-settings)が新たに取得されるまで起動をブロックします | エンタープライズと管理設定 | Managed |
| [`gatewayInternalNetworks`](#gatewayinternalnetworks) | 組織が内部で使用しているパブリック IPv4 空間上の[クラウドゲートウェイ](/docs/ja/claude-apps-gateway#allow-a-gateway-on-public-address-space-you-own)に `/login` が到達できるようにします | 認証とプロバイダー | Managed |
| [`gcpAuthRefresh`](#gcpauthrefresh) | 独自のコマンドで [Google Cloud の認証情報](/docs/ja/google-vertex-ai#advanced-credential-configuration)を更新します | 認証とプロバイダー | Any file |
| [`hooks`](#hooks) | Claude Code のライフサイクルの各時点で、独自のコマンドを[フック](/docs/ja/hooks)として実行します | フックと自動化 | Any file |
| [`httpHookAllowedEnvVars`](#httphookallowedenvvars) | [HTTP フック](/docs/ja/hooks)がヘッダーに含められる環境変数を制限します | フックと自動化 | Any file |
| [`idleCompaction`](#idlecompaction) | ターミナルセッションがアイドル状態の間に、Claude Code が長い会話を圧縮しないようにします | メモリとコンテキスト | Any file |
| [`includeCoAuthoredBy`](#includecoauthoredby) | 非推奨です。コミットと PR の帰属表示を非表示にしたり変更したりするには `attribution` を使用してください | Git と帰属表示 | Any file |
| [`includeGitInstructions`](#includegitinstructions) | 組み込みのコミットおよび PR の指示を Claude のコンテキストから除外します | Git と帰属表示 | Any file |
| [`inputNeededNotifEnabled`](#inputneedednotifenabled) | Claude がユーザーの入力を待っているときに[プッシュ通知](/docs/ja/remote-control#mobile-push-notifications)を受け取ります | リモート、デスクトップ、通知 | Any file |
| [`isolatePeerMachines`](#isolatepeermachines) | Claude が[別のマシン上の自分のセッションにメッセージを送る](/docs/ja/cross-session-messaging#require-approval-for-cross-machine-messages)前に確認を求めます | エージェント、セッション、worktree | Any file |
| [`keybindingFlavor`](#keybindingflavor) | 非推奨で、効果はありません。単語編集のショートカットは常に [readline の規則に従います](/docs/ja/interactive-mode#make-ctrl-w-delete-back-to-whitespace) | インターフェースとターミナル | Any file |
| [`language`](#language) | Claude に英語以外の言語で応答させます | モデルと応答 | Any file |
| [`leftArrowOpensAgents`](#leftarrowopensagents) | [セッションをバックグラウンドに移してエージェントビューを開く](/docs/ja/agent-view#switch-sessions-without-leaving-the-terminal) `←` ショートカットをオフにします | グローバル設定 | Global config |
| [`managedMcpServers`](#managedmcpservers) | ユーザーが追加するものに加えて、すべてのユーザーにリモート [MCP サーバー](/docs/ja/managed-mcp#provide-servers-through-managed-settings)を提供します | MCP | Managed |
| [`managedSourcesBehavior`](#managedsourcesbehavior) | 優先度が最も高いものだけを使うのではなく、デプロイしたすべての[管理ソース](/docs/ja/managed-settings#how-claude-code-combines-managed-sources)を組み合わせます | エンタープライズと管理設定 | Managed |
| [`maxEffortLevel`](#maxeffortlevel) | すべてのプロバイダーで、すべてのモデルまたはモデルごとに [effort レベル](/docs/ja/model-config#adjust-effort-level)の上限を設定します | モデルと応答 | Any file |
| [`maxProseWidth`](#maxprosewidth) | 幅の広いターミナルで、Claude の応答の文章部分の幅に上限を設定します | インターフェースとターミナル | Any file |
| [`minimumVersion`](#minimumversion) | [自動更新](/docs/ja/setup#pin-a-minimum-version)で指定バージョン未満のものがインストールされないようにします | 更新とバージョン管理 | Any file |
| [`model`](#model) | Claude Code の起動時に使用する[モデル](/docs/ja/model-config#set-a-default-model-for-new-sessions)を変更します | モデルと応答 | Any file |
| [`modelOverrides`](#modeloverrides) | [モデル ID を](/docs/ja/model-config#override-model-ids-per-version) Bedrock の ARN などのプロバイダーの ID に対応付けます | モデルと応答 | Any file |
| [`modelPicker`](#modelpicker) | [`/model` ピッカー](/docs/ja/model-config#available-models)に表示するモデルを、独自の順序とラベルで選択します | モデルと応答 | User or managed |
| [`modelPricing`](#modelpricing) | 定価ではなく、組織の契約料金で支出を報告します | モデルと応答 | Managed |
| [`modelSettings`](#modelsettings) | モデルごとに保存された [effort レベル](/docs/ja/model-config#adjust-effort-level)または[自動圧縮ウィンドウ](/docs/ja/model-config#set-the-auto-compact-window)を保持するか、特定のモデルの effort に上限を設定します | モデルと応答 | Any file |
| [`otelHeadersHelper`](#otelheadershelper) | 独自のコマンドで、ローテーションする [OpenTelemetry](/docs/ja/monitoring-usage#dynamic-headers) ヘッダーを生成します | 認証とプロバイダー | Any file |
| [`outputStyle`](#outputstyle) | [出力スタイル](/docs/ja/output-styles)で Claude の役割、トーン、出力形式を変更します | モデルと応答 | Any file |
| [`parentSettingsBehavior`](#parentsettingsbehavior) | [管理設定](/docs/ja/managed-settings)をデプロイする際に、[SDK または IDE ホスト](/docs/ja/managed-settings#let-an-embedding-host-add-policy)が渡す制限を適用するか破棄するかを指定します | エンタープライズと管理設定 | Managed |
| [`permissionExplainerEnabled`](#permissionexplainerenabled) | v2.1.257 で、シェルの権限プロンプトにおける `Ctrl+E` のコマンド説明とともに削除されました | グローバル設定 | Global config |
| [`permissions`](#permissions) | 許可ルール、確認ルール、拒否ルールと、開始時の[権限モード](/docs/ja/permission-modes)を設定します | 権限設定 | Any file |
| [`permissions.additionalDirectories`](#permissions-additionaldirectories) | [現在のディレクトリ以外のディレクトリ](/docs/ja/permissions#working-directories)へのファイルアクセスを Claude に与えます | 権限設定 | Any file |
| [`permissions.allow`](#permissions-allow) | 列挙した[ツールの使用](/docs/ja/permissions#permission-rule-syntax)をプロンプトなしで承認します | 権限設定 | Any file |
| [`permissions.ask`](#permissions-ask) | 列挙した[ツールの使用](/docs/ja/permissions#permission-rule-syntax)の前に常にプロンプトを表示します | 権限設定 | Any file |
| [`permissions.blockReadsOutsideWorkingDirectories`](#permissions-blockreadsoutsideworkingdirectories) | すべての権限モードで、ファイルツールが[作業ディレクトリ](/docs/ja/permissions#working-directories)外の読み取りを拒否するようにします | 権限設定 | Any file |
| [`permissions.defaultMode`](#permissions-defaultmode) | 新しいセッションの開始時の[権限モード](/docs/ja/permission-modes#which-mode-a-session-starts-in)を設定します | 権限設定 | Any file |
| [`permissions.deny`](#permissions-deny) | シークレットを保持するファイルの読み取りを含め、列挙した[ツールの使用](/docs/ja/permissions#permission-rule-syntax)をブロックします | 権限設定 | Any file |
| [`permissions.disableBypassPermissionsMode`](#permissions-disablebypasspermissionsmode) | 誰も [bypassPermissions モード](/docs/ja/permission-modes#skip-all-checks-with-bypasspermissions-mode)に入れないようにします | 権限設定 | Any file |
| [`plansDirectory`](#plansdirectory) | [plan モード](/docs/ja/permission-modes#analyze-before-you-edit-with-plan-mode)がプランファイルを書き込む場所を選択します | メモリとコンテキスト | Any file |
| [`pluginConfigs`](#pluginconfigs) | [プラグイン](/docs/ja/plugins/overview)の設定ダイアログで入力した回答を保存します | プラグインとスキル | User or managed |
| [`pluginSuggestionMarketplaces`](#pluginsuggestionmarketplaces) | `/plugin` でプラグインのインストール候補を表示できる[マーケットプレイス](/docs/ja/plugins/org#restrict-what-users-can-install)を選択します | プラグインとスキル | Managed |
| [`pluginTrustMessage`](#plugintrustmessage) | [プラグイン](/docs/ja/plugins/overview)の信頼に関する警告に独自のテキストを追加します | プラグインとスキル | Managed |
| [`policyHelper`](#policyhelper) | 起動時に[管理設定](/docs/ja/managed-settings#compute-the-policy-with-a-helper-program)を算出する実行ファイルを実行します | エンタープライズと管理設定 | Managed |
| [`policyHelper.path`](#policyhelper-path) | Claude Code が実行する[ヘルパー実行ファイル](/docs/ja/managed-settings#compute-the-policy-with-a-helper-program)を指定します | エンタープライズと管理設定 | Managed |
| [`policyHelper.refreshIntervalMs`](#policyhelper-refreshintervalms) | [ヘルパー](/docs/ja/managed-settings#compute-the-policy-with-a-helper-program)をバックグラウンドで一定間隔ごとに再実行します | エンタープライズと管理設定 | Managed |
| [`policyHelper.timeoutMs`](#policyhelper-timeoutms) | Claude Code が[ヘルパー](/docs/ja/managed-settings#compute-the-policy-with-a-helper-program)を待機する時間を設定します | エンタープライズと管理設定 | Managed |
| [`preferredNotifChannel`](#preferrednotifchannel) | タスク完了時の通知として、[ターミナルベルまたはデスクトップ通知](/docs/ja/terminal-config#get-a-terminal-bell-or-notification)を選択します | リモート、デスクトップ、通知 | Any file |
| [`prefersReducedMotion`](#prefersreducedmotion) | スピナー、シマー、フラッシュのアニメーションを[抑えるかオフにします](/docs/ja/accessibility#accessibility-settings) | インターフェースとターミナル | Any file |
| [`prependPlugins`](#prependplugins) | ユーザーがインストールしたすべての mod の前に、組織の [mod](/docs/ja/plugins/mods/admin) を実行します | プラグインとスキル | User or managed |
| [`processWrapper`](#processwrapper) | macOS と Linux で、Claude Code のバックグラウンドプロセスを[企業ランチャー](/docs/ja/corporate-launcher)経由で実行します | エージェント、セッション、worktree | User or managed |
| [`promptCacheTtl`](#promptcachettl) | メインの会話の[プロンプトキャッシュの有効期間](/docs/ja/prompt-caching#cache-lifetime)を選択します | モデルと応答 | Any file |
| [`promptSuggestionEnabled`](#promptsuggestionenabled) | 入力ボックスにグレー表示される[プロンプト候補](/docs/ja/interactive-mode#prompt-suggestions)を非表示にします | インターフェースとターミナル | Any file |
| [`prStatusFooterEnabled`](#prstatusfooterenabled) | プロンプトフッターの [PR レビューステータス](/docs/ja/interactive-mode#pr-review-status)バッジと、その背後にあるプルリクエストのチェックをオフにします | グローバル設定 | Global config |
| [`prUrlTemplate`](#prurltemplate) | PR リンクの参照先を github.com ではなく社内のコードレビューツールにします | Git と帰属表示 | Any file |
| [`remote.defaultEnvironmentId`](#remote-defaultenvironmentid) | `claude --cloud` のデフォルトの[クラウド環境](/docs/ja/cloud-environments)を選択します。セルフホストの `ccpool_` ID は、ユーザー設定、管理設定、`--settings` からのみ読み取られます | リモート、デスクトップ、通知 | Any file |
| [`remoteControlAtStartup`](#remotecontrolatstartup) | セッションの開始時に [Remote Control](/docs/ja/remote-control#enable-remote-control-for-all-sessions) に自動的に接続します | リモート、デスクトップ、通知 | Any file |
| [`requiredMaximumVersion`](#requiredmaximumversion) | 組織が許可するバージョンより新しいバージョンでは[起動を拒否](/docs/ja/setup#pin-a-minimum-version)します | 更新とバージョン管理 | Managed |
| [`requiredMinimumVersion`](#requiredminimumversion) | 組織が要求するバージョンより古いバージョンでは[起動を拒否](/docs/ja/setup#pin-a-minimum-version)します | 更新とバージョン管理 | Managed |
| [`respectGitignore`](#respectgitignore) | gitignore されたファイルを [`@` ファイルピッカー](/docs/ja/interactive-mode#quick-commands)から除外します | インターフェースとターミナル | Any file |
| [`respondToBashCommands`](#respondtobashcommands) | [`!` シェルコマンド](/docs/ja/interactive-mode#shell-mode-with-prefix)の実行後に Claude が応答しないようにします | インターフェースとターミナル | Any file |
| [`sandbox`](#sandbox) | macOS、Linux、WSL2 で、[Bash コマンドを](/docs/ja/sandboxing)ファイルシステムやネットワークから隔離します | サンドボックス設定 | Any file |
| [`sandbox.allowAppleEvents`](#sandbox-allowappleevents) | macOS で、[サンドボックス化](/docs/ja/sandboxing)されたコマンドが Apple Events を送信できるようにします | サンドボックス設定 | User or managed |
| [`sandbox.allowUnsandboxedCommands`](#sandbox-allowunsandboxedcommands) | ブロックされたコマンドを Claude が[サンドボックス](/docs/ja/sandboxing#the-unsandboxed-retry-escape-hatch)外で再試行できるようにするか、禁止します | サンドボックス設定 | Any file |
| [`sandbox.autoAllowBashIfSandboxed`](#sandbox-autoallowbashifsandboxed) | [サンドボックス化](/docs/ja/sandboxing#auto-allow-mode)されたコマンドを権限プロンプトなしで実行します | サンドボックス設定 | Any file |
| [`sandbox.bwrapPath`](#sandbox-bwrappath) | [サンドボックス](/docs/ja/sandboxing)が `PATH` 外にある bubblewrap バイナリを使用するよう指定します | サンドボックス設定 | Managed |
| [`sandbox.credentials`](#sandbox-credentials) | [サンドボックス](/docs/ja/sandboxing#protect-credentials)内で認証情報ファイルや変数を非表示にするかマスクします | サンドボックス設定 | Any file |
| [`sandbox.credentials.allowPlaintextInject`](#sandbox-credentials-allowplaintextinject) | 信頼できるテストネットワーク上で、[マスクされた認証情報](/docs/ja/sandboxing#mask-credentials)がプレーンな HTTP サービスに届くようにします | サンドボックス設定 | User or managed |
| [`sandbox.credentials.awsPairs`](#sandbox-credentials-awspairs) | カスタム名の AWS キー変数を、[再署名](/docs/ja/sandboxing#re-sign-aws-requests)用に 1 つの認証情報として関連付けます | サンドボックス設定 | User or managed |
| [`sandbox.credentials.envVars`](#sandbox-credentials-envvars) | [サンドボックス](/docs/ja/sandboxing#mask-environment-variables)内で環境変数を未設定にするかマスクします | サンドボックス設定 | Any file |
| [`sandbox.credentials.files`](#sandbox-credentials-files) | [サンドボックス](/docs/ja/sandboxing#mask-credential-files)内で認証情報ファイルの読み取りをブロックするかマスクします | サンドボックス設定 | Any file |
| [`sandbox.credentials.sigv4`](#sandbox-credentials-sigv4) | ストリーミング、署名付き、または [SigV4A の AWS リクエスト](/docs/ja/sandboxing#re-sign-aws-requests)を失敗させるか通過させるかを選択します | サンドボックス設定 | User or managed |
| [`sandbox.enabled`](#sandbox-enabled) | macOS、Linux、WSL2 で [Bash のサンドボックス化](/docs/ja/sandboxing#get-started)をオンにします | サンドボックス設定 | Any file |
| [`sandbox.enableWeakerNestedSandbox`](#sandbox-enableweakernestedsandbox) | 非特権コンテナ内で Linux の[サンドボックス](/docs/ja/sandboxing)を実行します | サンドボックス設定 | Any file |
| [`sandbox.enableWeakerNetworkIsolation`](#sandbox-enableweakernetworkisolation) | macOS の[サンドボックス](/docs/ja/sandboxing#go-based-clis-fail-tls-verification-on-macos)内で、`gh`、`gcloud`、`terraform` が MITM プロキシ経由で TLS を検証できるようにします | サンドボックス設定 | Any file |
| [`sandbox.excludedCommands`](#sandbox-excludedcommands) | Claude Code が[サンドボックス](/docs/ja/sandboxing)外で実行できるコマンドを指定します | サンドボックス設定 | Any file |
| [`sandbox.failIfUnavailable`](#sandbox-failifunavailable) | [サンドボックス](/docs/ja/sandboxing)を開始できない場合、サンドボックスなしで実行するのではなく起動を拒否します | サンドボックス設定 | Any file |
| [`sandbox.filesystem`](#sandbox-filesystem) | [サンドボックス化](/docs/ja/sandboxing#filesystem-isolation)されたコマンドが読み書きできるパスを制御します | サンドボックス設定 | Any file |
| [`sandbox.filesystem.allowManagedReadPathsOnly`](#sandbox-filesystem-allowmanagedreadpathsonly) | [組織がブロックした読み取りパス](/docs/ja/sandboxing#keep-developers-from-widening-the-policy)を開発者が再び開けないようにします | サンドボックス設定 | Managed |
| [`sandbox.filesystem.allowRead`](#sandbox-filesystem-allowread) | [`denyRead`](#sandbox-filesystem-denyread) がブロックする領域内で読み取りを再び許可します | サンドボックス設定 | Any file |
| [`sandbox.filesystem.allowWrite`](#sandbox-filesystem-allowwrite) | [サンドボックス化](/docs/ja/sandboxing)されたコマンドが書き込めるパスを追加します | サンドボックス設定 | Any file |
| [`sandbox.filesystem.denyRead`](#sandbox-filesystem-denyread) | [サンドボックス化](/docs/ja/sandboxing)されたコマンドが特定のパスを読み取らないようブロックします | サンドボックス設定 | Any file |
| [`sandbox.filesystem.denyWrite`](#sandbox-filesystem-denywrite) | [サンドボックス化](/docs/ja/sandboxing)されたコマンドが特定のパスに書き込まないようブロックします | サンドボックス設定 | Any file |
| [`sandbox.filesystem.disabled`](#sandbox-filesystem-disabled) | ネットワークの隔離を維持したまま、[ファイルシステムの隔離をオフにします](/docs/ja/sandboxing#disable-filesystem-isolation) | サンドボックス設定 | User or managed |
| [`sandbox.ignoreViolations`](#sandbox-ignoreviolations) | コマンドが調べることが想定されているパスについて、違反レポートを抑制します | サンドボックス設定 | Any file |
| [`sandbox.network`](#sandbox-network) | [サンドボックス化](/docs/ja/sandboxing#network-isolation)されたコマンドが到達できるホスト、ポート、ソケットを制御します | サンドボックス設定 | Any file |
| [`sandbox.network.allowAllUnixSockets`](#sandbox-network-allowallunixsockets) | [サンドボックス化](/docs/ja/sandboxing)されたコマンドがすべての Unix ソケットに接続できるようにします | サンドボックス設定 | Any file |
| [`sandbox.network.allowedDomains`](#sandbox-network-alloweddomains) | ドメインを事前に許可し、[サンドボックス化](/docs/ja/sandboxing)されたコマンドがそれらについてプロンプトを表示しないようにします | サンドボックス設定 | Any file |
| [`sandbox.network.allowLocalBinding`](#sandbox-network-allowlocalbinding) | macOS で、[サンドボックス化](/docs/ja/sandboxing)されたコマンドがネットワークポートでリッスンし、localhost に接続できるようにします | サンドボックス設定 | Any file |
| [`sandbox.network.allowMachLookup`](#sandbox-network-allowmachlookup) | iOS Simulator や Playwright などの macOS の[サンドボックス化](/docs/ja/sandboxing)されたツールが、それぞれの XPC サービスに到達できるようにします | サンドボックス設定 | Any file |
| [`sandbox.network.allowManagedDomainsOnly`](#sandbox-network-allowmanageddomainsonly) | ネットワークの許可リストを[管理設定](/docs/ja/sandboxing#keep-developers-from-widening-the-policy)に固定します | サンドボックス設定 | Managed |
| [`sandbox.network.allowUnixSockets`](#sandbox-network-allowunixsockets) | macOS で、[サンドボックス化](/docs/ja/sandboxing)されたコマンドが使用できる Unix ソケットのパスを列挙します | サンドボックス設定 | Any file |
| [`sandbox.network.deniedDomains`](#sandbox-network-denieddomains) | 許可されたワイルドカード内であっても、[サンドボックス化](/docs/ja/sandboxing)されたコマンドに対してドメインをブロックします | サンドボックス設定 | Any file |
| [`sandbox.network.httpProxyPort`](#sandbox-network-httpproxyport) | [サンドボックス](/docs/ja/sandboxing#custom-proxy-configuration)の HTTP トラフィックを独自のプロキシ経由でルーティングします | サンドボックス設定 | Any file |
| [`sandbox.network.socksProxyPort`](#sandbox-network-socksproxyport) | [サンドボックス](/docs/ja/sandboxing#custom-proxy-configuration)の SOCKS トラフィックを独自のプロキシ経由でルーティングします | サンドボックス設定 | Any file |
| [`sandbox.network.strictAllowlist`](#sandbox-network-strictallowlist) | [許可リスト](/docs/ja/sandboxing#network-isolation)外のホストを、プロンプトを表示せずに拒否します | サンドボックス設定 | User or managed |
| [`sandbox.network.tlsTerminate`](#sandbox-network-tlsterminate) | [サンドボックス](/docs/ja/sandboxing#network-isolation)のプロキシで TLS を終端し、HTTPS リクエストを読み取れるようにします | サンドボックス設定 | User or managed |
| [`sandbox.ripgrep`](#sandbox-ripgrep) | [サンドボックス](/docs/ja/sandboxing)内で独自の ripgrep バイナリを使用します | サンドボックス設定 | User or managed |
| [`sandbox.socatPath`](#sandbox-socatpath) | [サンドボックス](/docs/ja/sandboxing)のプロキシが `PATH` 外にある `socat` バイナリを使用するよう指定します | サンドボックス設定 | Managed |
| [`showClearContextOnPlanAccept`](#showclearcontextonplanaccept) | [プランの承認画面](/docs/ja/permission-modes#review-and-approve-a-plan)に「コンテキストをクリア」オプションを表示します | インターフェースとターミナル | Any file |
| [`showThinkingSummaries`](#showthinkingsummaries) | 折りたたまれた表示ではなく、Claude の[思考](/docs/ja/model-config#extended-thinking)の要約を表示します | モデルと応答 | Any file |
| [`showTurnDuration`](#showturnduration) | 各応答の後に表示される「Cooked for」の所要時間を非表示にします | インターフェースとターミナル | Any file |
| [`skillListingBudgetFraction`](#skilllistingbudgetfraction) | [スキル一覧](/docs/ja/skills#skill-descriptions-are-cut-short)に確保するコンテキストを増減します | メモリとコンテキスト | Any file |
| [`skillListingMaxDescChars`](#skilllistingmaxdescchars) | [スキル一覧](/docs/ja/skills#skill-descriptions-are-cut-short)における各スキルの説明の長さに上限を設定します | メモリとコンテキスト | Any file |
| [`skillOverrides`](#skilloverrides) | SKILL.md を編集せずに[スキルを非表示にするか折りたたみます](/docs/ja/skills#override-skill-visibility-from-settings) | プラグインとスキル | Any file |
| [`skipAutoPermissionPrompt`](#skipautopermissionprompt) | 組み込みのデフォルトではなく自分で初めて [auto モード](/docs/ja/permission-modes#eliminate-prompts-with-auto-mode)に入ったときに Claude Code が表示する 1 回限りの通知をスキップします | 権限設定 | User or managed |
| [`skipDangerousModePermissionPrompt`](#skipdangerousmodepermissionprompt) | [bypassPermissions モード](/docs/ja/permission-modes#skip-all-checks-with-bypasspermissions-mode)に入る前の確認ダイアログをスキップします | 権限設定 | User, local, or managed |
| [`skipWebFetchPreflight`](#skipwebfetchpreflight) | Anthropic に到達できない場合に、[WebFetch のホスト名チェック](/docs/ja/tools-reference#webfetch-tool-behavior)をスキップします | プライバシーとテレメトリ | Any file |
| [`spellcheck`](#spellcheck) | インストールした[スペルチェッカー](/docs/ja/interactive-mode#check-spelling-as-you-type)で、プロンプト入力内のスペルミスに下線を引きます | インターフェースとターミナル | User or managed |
| [`spinnerTipsEnabled`](#spinnertipsenabled) | Claude の作業中にスピナーに表示されるヒントを非表示にします | インターフェースとターミナル | Any file |
| [`spinnerTipsOverride`](#spinnertipsoverride) | スピナーのローテーションに独自のヒントを追加するか、組み込みのヒントを置き換えます | インターフェースとターミナル | Any file |
| [`spinnerVerbs`](#spinnerverbs) | ターンの実行中に表示される動詞を追加または置き換えます | インターフェースとターミナル | Any file |
| [`sshConfigs`](#sshconfigs) | Desktop の環境セレクターに [SSH 接続](/docs/ja/desktop#pre-configure-ssh-connections-for-your-team)を追加します | リモート、デスクトップ、通知 | User or managed |
| [`sshHostAllowlist`](#sshhostallowlist) | [Desktop の SSH セッション](/docs/ja/desktop#restrict-which-ssh-hosts-users-can-connect-to)が到達できるホストを制限します | リモート、デスクトップ、通知 | Managed |
| [`statusLine`](#statusline) | 独自のコマンドを実行して、プロンプトの下に[ステータスライン](/docs/ja/statusline)を表示します | インターフェースとターミナル | Any file |
| [`strictKnownMarketplaces`](#strictknownmarketplaces) | ユーザーが追加およびインストール元として使用できる[マーケットプレイス](/docs/ja/plugins/overview)のソースの許可リストを指定します | プラグインとスキル | Managed |
| [`strictPluginOnlyCustomization`](#strictpluginonlycustomization) | ユーザーおよびプロジェクトのソースからの[スキル](/docs/ja/skills)、[エージェント](/docs/ja/sub-agents)、[フック](/docs/ja/hooks)、[MCP サーバー](/docs/ja/mcp)をブロックします | プラグインとスキル | Managed |
| [`strictPluginOnlyCustomization.agents`](#strictpluginonlycustomization-agents) | [エージェント](/docs/ja/sub-agents)をプラグインと管理ソースに限定します | プラグインとスキル | Managed |
| [`strictPluginOnlyCustomization.hooks`](#strictpluginonlycustomization-hooks) | [フック](/docs/ja/hooks)をプラグインと管理ソースに限定します | プラグインとスキル | Managed |
| [`strictPluginOnlyCustomization.mcp`](#strictpluginonlycustomization-mcp) | [MCP サーバー](/docs/ja/mcp)をプラグインと管理ソースに限定します | プラグインとスキル | Managed |
| [`strictPluginOnlyCustomization.skills`](#strictpluginonlycustomization-skills) | [スキル](/docs/ja/skills)をプラグインと管理ソースに限定します | プラグインとスキル | Managed |
| [`subagentPromptCacheTtl`](#subagentpromptcachettl) | サブエージェントおよびメインの会話以外のリクエストについて、[プロンプトキャッシュの有効期間](/docs/ja/prompt-caching#cache-lifetime)を選択します | モデルと応答 | Any file |
| [`subagentStatusLine`](#subagentstatusline) | 独自のコマンドで、[サブエージェント](/docs/ja/sub-agents)のタスク表示の行を書き換えます | インターフェースとターミナル | Any file |
| [`switchModelsOnFlag`](#switchmodelsonflag) | [安全性分類器](/docs/ja/model-config#ask-before-switching)がリクエストを警告したときに、モデルを自動的に切り替えるか一時停止します | モデルと応答 | Any file |
| [`syncClaudeAiPlugins`](#syncclaudeaiplugins) | [claude.ai アカウントで有効になっているプラグイン](/docs/ja/plugins/loading#synced-plugins)の読み込みと、新しいプラグインのダウンロードを停止します | プラグインとスキル | User, local, or managed |
| [`syncClaudeAiSkills`](#syncclaudeaiskills) | [claude.ai アカウントで有効になっているスキル](/docs/ja/skills#how-synced-skills-behave)の読み込みと、新しいスキルのダウンロードを停止します | プラグインとスキル | User, local, or managed |
| [`syntaxHighlightingDisabled`](#syntaxhighlightingdisabled) | 差分とコードブロックのシンタックスハイライトをオフにします | インターフェースとターミナル | Any file |
| [`taskOutputMaxChars`](#taskoutputmaxchars) | v2.1.277 で、サイズ指定の対象だった `TaskOutput` ツールとともに削除されました | メモリとコンテキスト | Any file |
| [`teammateDefaultModel`](#teammatedefaultmodel) | v2.1.234 で削除されました。Claude Code がチームメイトのモデルを選択する方法については、[チームメイトとモデルを指定する](/docs/ja/agent-teams#specify-teammates-and-models)を参照してください | グローバル設定 | Global config |
| [`teammateMode`](#teammatemode) | [エージェントチームのチームメイトの表示方法](/docs/ja/agent-teams#choose-a-display-mode)を選択します | エージェント、セッション、worktree | Any file |
| [`terminalProgressBarEnabled`](#terminalprogressbarenabled) | 対応しているターミナルで、ターミナルのプログレスバーを非表示にします | インターフェースとターミナル | Any file |
| [`terminalTitleFromRename`](#terminaltitlefromrename) | [`/rename`](/docs/ja/sessions#name-your-sessions) と `--name` がターミナルのタブタイトルを変更しないようにします | インターフェースとターミナル | Any file |
| [`theme`](#theme) | 組み込みまたはカスタムのインターフェースの[カラーテーマ](/docs/ja/terminal-config#match-the-color-theme)を選択します | インターフェースとターミナル | Any file |
| [`timeFormat`](#timeformat) | インターフェース内の時刻を、12 時間制、24 時間制、UTC、または strftime パターンで表示します | インターフェースとターミナル | Any file |
| [`timeZone`](#timezone) | インターフェース内の時刻を、システムとは異なるタイムゾーンで表示します | インターフェースとターミナル | Any file |
| [`tui`](#tui) | [フルスクリーン](/docs/ja/fullscreen)またはクラシックのターミナルレンダラーを選択します | インターフェースとターミナル | Any file |
| [`ultracode`](#ultracode) | 指示がなくても、実質的なタスクごとに Claude に[ワークフロー](/docs/ja/workflows#let-claude-decide-with-ultracode)を計画させます | モデルと応答 | Any file |
| [`useAutoModeDuringPlan`](#useautomodeduringplan) | [plan モード](/docs/ja/permission-modes#analyze-before-you-edit-with-plan-mode)で [auto モード](/docs/ja/permission-modes#eliminate-prompts-with-auto-mode)の分類器がシェルコマンドをレビューできるようにします。代わりにプロンプトを表示するには `false` を設定します | 権限設定 | User, local, or managed |
| [`verbose`](#verbose) | 切り詰められた要約ではなく[ツールの完全な出力](/docs/ja/cli-reference#cli-flags)を表示します。両方が設定されている場合は `viewMode` が優先されます | インターフェースとターミナル | Any file |
| [`viewMode`](#viewmode) | すべてのセッションを [default、verbose、または focus ビュー](/docs/ja/cli-reference#cli-flags)で開始します | インターフェースとターミナル | Any file |
| [`vimInsertModeRemaps`](#viminsertmoderemaps) | `jj` などの 2 キーの [INSERT モードのシーケンス](/docs/ja/interactive-mode#remap-insert-mode-key-sequences)を Escape に割り当てます | インターフェースとターミナル | User or managed |
| [`voice`](#voice) | [音声入力](/docs/ja/voice-dictation)をオンにし、長押しモードまたはタップモードを選択します | インターフェースとターミナル | Any file |
| [`voiceEnabled`](#voiceenabled) | 旧来の単一キー形式で[音声入力](/docs/ja/voice-dictation)をオンにします | インターフェースとターミナル | Any file |
| [`wheelScrollAccelerationEnabled`](#wheelscrollaccelerationenabled) | フルスクリーンレンダリングで[マウスホイールの加速](/docs/ja/fullscreen#mouse-wheel-scrolling)をオフにします | インターフェースとターミナル | Any file |
| [`workflowKeywordTriggerEnabled`](#workflowkeywordtriggerenabled) | プロンプト内の `ultracode` という語で[ワークフロー](/docs/ja/workflows)を開始できるようにします。ワークフローを開始せずにこの語を入力するには `false` を設定します | フックと自動化 | Any file |
| [`workflowSizeGuideline`](#workflowsizeguideline) | [動的ワークフロー](/docs/ja/workflows)で Claude が目標とするエージェント数を設定します | フックと自動化 | Any file |
| [`worktree`](#worktree) | Claude Code が git の [worktree](/docs/ja/worktrees) を作成する方法を設定します | エージェント、セッション、worktree | Any file |
| [`worktree.baseRef`](#worktree-baseref) | 新しい [worktree](/docs/ja/worktrees) を、リモートのデフォルトブランチまたはローカルの HEAD から分岐させます | エージェント、セッション、worktree | Any file |
| [`worktree.bgIsolation`](#worktree-bgisolation) | バックグラウンドセッションが [worktree](/docs/ja/worktrees) を使わずに作業コピーを編集できるようにします | エージェント、セッション、worktree | Any file |
| [`worktree.location`](#worktree-location) | [Desktop の SSH セッション](/docs/ja/desktop#ssh-sessions)がリモートマシン上で worktree を作成する場所を選択します | エージェント、セッション、worktree | User |
| [`worktree.sparsePaths`](#worktree-sparsepaths) | 各 [worktree](/docs/ja/worktrees) で必要なディレクトリのみをチェックアウトします | エージェント、セッション、worktree | Any file |
| [`worktree.symlinkDirectories`](#worktree-symlinkdirectories) | 大きなディレクトリを複製する代わりに、各 [worktree](/docs/ja/worktrees) にシンボリックリンクします | エージェント、セッション、worktree | Any file |
| [`wslInheritsWindowsSettings`](#wslinheritswindowssettings) | WSL が Windows のポリシーチェーンから[管理設定](/docs/ja/managed-settings)を読み取るようにします | エンタープライズと管理設定 | Managed |

## モデルと応答

Claude Code が使用するモデルと応答方法を選択します。これらの設定が `/model` コマンドと環境変数とどのように相互作用するかについては、[モデル設定](/docs/ja/model-config)を参照してください。

### `advisorModel`

Claude がサーバー側の[アドバイザーツール](/docs/ja/advisor)を呼び出すときに回答するモデルを選択します。これを設定解除するとアドバイザーがオフになります。アドバイザーはメインモデル以上の能力を持つ必要があります。受け入れられるペアリングと受け入れられないペアリングを選択した場合の動作については、[アドバイザーモデルを選択](/docs/ja/advisor#choose-an-advisor-model)を参照してください。

通常、このキーを手動で編集することはありません。`/advisor` を実行して、現在の選択、アドバイザーができるモデル、および**アドバイザーなし**を表示するピッカーを開きます。Claude Code は選択を `~/.claude/settings.json` のこのキーに保存します。[リモートコントロール](/docs/ja/remote-control)クライアントから、またはリモートワーカーに接続されたセッションで選択した場合、その選択はそのセッションのみに適用され、このキーは変更されません。

アカウントが[使用クレジット同意](/docs/ja/advisor#fable-advisor-and-usage-credits)を必要とする場合は、`/model fable` を実行して最初に同意を受け入れます。これを行うまで、`/advisor` で Fable を選択しても何も保存されず、Claude Code は最初に `/model fable` を実行するよう指示します。

* **スコープ**: [`任意のファイル`](#scopes)
* **タイプ**: 文字列、エイリアス `"fable"`、`"opus"`、または `"sonnet"` のいずれか。これらは Claude Code の現在のデフォルトバージョンのそのモデルファミリーに解決されます。または、`"claude-opus-5-5"` などの完全なモデル ID
* **デフォルト**: 設定解除されているため、アドバイザーはオフです
* **セッションごとのオーバーライド**: `--advisor` はこのキーより優先されます。[`CLAUDE_CODE_DISABLE_ADVISOR_TOOL`](/docs/ja/env-vars)はアドバイザーをオフにし、このキーはそれをオンに戻すことはできません

```json settings.json theme={null}
{
  "advisorModel": "opus"
}
```

このキーは、Amazon Bedrock や Claude Platform on AWS など、アドバイザーが[利用できない](/docs/ja/advisor#requirements)プロバイダーには影響しません。`"fable"` には[Fable アクセス](/docs/ja/advisor#choose-an-advisor-model)が必要です。

### `alwaysThinkingEnabled`

このキーを `false` に設定して、すべてのセッションで[拡張思考](/docs/ja/model-config#extended-thinking)をオフにします。思考はデフォルトでオンなので、`true` は何も変わりません。ほとんどの人はファイルを編集するのではなく `/config` を通じてこれを設定します。

Opus 5.5、Sonnet 5.5、Haiku 5.5、Fable モデルなど、常に思考するモデルでは、`false` は効果がありません。[サードパーティプロバイダー](/docs/ja/third-party-integrations)では、Claude Code は思考をオフにする代わりに `thinking` パラメータを省略するため、適応推論モデルは引き続き思考する可能性があります。Anthropic API で思考をオフにした場合、Claude Code は、Opus 5 など[その組み合わせを受け付けない](/docs/ja/errors#effort-isnt-available-with-thinking-turned-off)ことが分かっているモデルに対して、より高いレベルの代わりに effort `high` を送信します。

* **スコープ**: [`任意のファイル`](#scopes)
* **タイプ**: ブール値
  * `true`: 効果なし。思考は既にオンです
  * `false`: Claude Code はすべてのセッションで拡張思考をオフにします
* **デフォルト**: 設定解除されているため、思考はそれをサポートするモデルではオンです
* **セッションごとのオーバーライド**: [`MAX_THINKING_TOKENS`](/docs/ja/env-vars)はこのキーより優先されます。`0` は `false` と同じモデルおよびプロバイダーの制限の下で思考をオフにし、正の値は、このキーが `false` の場合でも思考をオンにします。適応推論モデルでは、数値自体は無視されます

```json settings.json theme={null}
{
  "alwaysThinkingEnabled": false
}
```

### `availableModels`

メインセッション、[サブエージェント](/docs/ja/sub-agents)、[スキル](/docs/ja/skills)、および[アドバイザー](/docs/ja/advisor)で選択できるモデルを制限します。管理リストは `/model`、`--model`、および開発者自身のファイルの `model` キーを制限します。リスト外のモデルは選択できません。デフォルトのプレフィックスマッチングでは、これは Default オプション自体には影響しません。[`enforceAvailableModels`](#enforceavailablemodels)とペアにしてください。

* **スコープ**: [`任意のファイル`](#scopes)。組織に対して強制するために、管理設定にデプロイします。
* **タイプ**: モデルエイリアスまたは ID の配列
* **デフォルト**: 設定解除されているため、すべてのモデルが利用可能です

この例では、Sonnet と Haiku モデルのみを選択できます:

```json settings.json theme={null}
{
  "availableModels": ["sonnet", "haiku"]
}
```

`"claude-opus-5"` などのモデル ID エントリは、Opus 5.5 などそれを拡張する後のバージョンも許可します。これらのバージョンのいずれかをブロックするには、[`deniedModels`](#deniedmodels)を使用します。各モデル ID エントリが名前を付けたバージョンのみを許可するようにするには、[`availableModelsMatch`](#availablemodelsmatch)を使用します。[モデル選択を制限](/docs/ja/model-config#restrict-model-selection)を参照してください。

### `availableModelsMatch`

[`availableModels`](#availablemodels)エントリがモデル ID とどのように一致するかを選択します。デフォルトでは、モデル ID エントリはそれを拡張する後のバージョンも許可するため、`"claude-opus-5"` は Opus 5.5 を許可します。`"exact"` では、各モデル ID エントリは名前を付けたバージョンのみを許可するため、そのモデルの新しいバージョンはリストに追加されるまでブロックされたままです。Claude Code v2.1.283 以降が必要です。

* **スコープ**: [`管理`](#scopes)。Claude Code はユーザー、プロジェクト、ローカル設定および `--settings` のキーを無視し、警告を表示します
* **タイプ**: 文字列、以下のいずれか:
  * `"prefix"`: モデル ID エントリはそのバージョンと、別のセグメントで拡張するモデル ID を許可します
  * `"exact"`: モデル ID エントリは名前を付けたバージョンのみを許可します。日付付き ID を含むため、`"claude-opus-5"` は Opus 5 を許可しますが `claude-opus-5-5` は許可しません。`"opus"` などのファミリーエイリアスは依然としてファミリー全体を許可し、`best`、`opusplan`、および `default` エントリは無視されます
* **デフォルト**: `"prefix"`

この例は Opus 5 と Sonnet 5 を許可し、どちらの後のリリースも許可しません:

```json managed-settings.json theme={null}
{
  "availableModels": ["claude-opus-5", "claude-sonnet-5"],
  "availableModelsMatch": "exact"
}
```

`"exact"` では、リストが少なくとも 1 つのモデルまたはファミリーを名前付けするときはいつでも、Default オプションもリストされたモデルに制限されます。[特定のモデルまたはバージョンをブロック](/docs/ja/model-config#block-specific-models-or-versions)を参照してください。

### `deniedModels`

[`availableModels`](#availablemodels)許可リストの有無にかかわらず、特定のモデルをブロックし、そのリストがそれらを許可する場合でもブロックします。Claude Code はブロックされたモデルを `/model` ピッカーから非表示にし、`availableModels` が強制される場所ではどこでもモデルを選択できません。Default オプションのセッションは、[特定のモデルまたはバージョンをブロック](/docs/ja/model-config#block-specific-models-or-versions)で説明されているように、ブロックされたモデルも実行しません。Claude Code v2.1.283 以降が必要です。

* **スコープ**: [`管理`](#scopes)。Claude Code はユーザー、プロジェクト、ローカル設定および `--settings` のキーを無視し、警告を表示します
* **タイプ**: モデルエイリアスまたは ID の配列
  * `"opus"` などのファミリーエイリアスはそのファミリーのすべてのモデルをブロックします
  * `"claude-opus-5-5"` などのモデル ID は、日付付きおよびプロバイダー固有の ID を含むすべてのスペルでそのバージョンをブロックします
  * `"claude-opus-5"` などのマイナーバージョンなしのモデル ID は、Opus 5.5 などの後のマイナーバージョンもブロックします。Opus 5 のみをブロックするには `"claude-opus-5-0"` を記述します
  * `best`、`opusplan`、および `default` エントリは無視されます
* **デフォルト**: 設定解除されているため、モデルはブロックされません

この例は Opus と Sonnet モデルを許可し、Opus 5.5 をブロックします:

```json managed-settings.json theme={null}
{
  "availableModels": ["opus", "sonnet"],
  "deniedModels": ["claude-opus-5-5"]
}
```

[特定のモデルまたはバージョンをブロック](/docs/ja/model-config#block-specific-models-or-versions)を参照してください。

### `effortLevel`

保存していないモデルのデフォルト[努力レベル](/docs/ja/model-config#adjust-effort-level)を設定します。低いレベルは単純なタスクではより高速で安価であり、高いレベルは複雑な問題でより深く推論します。

マシン上のインタラクティブセッションで `/effort low`、`medium`、`high`、または `xhigh` を実行すると、Claude Code はレベルをファイルを編集するのではなく [`modelSettings`](#modelsettings)の下のアクティブなモデルに保存します。v2.1.251 より前では、`/effort` はこのキーを書き込みました。

同じ設定ファイル内で、Claude Code はこのキーではなくモデルの保存されたレベルを使用します。[`modelSettings`](#modelsettings)はクロスファイルの優先順位を述べています。

リモートワーカーに接続されたセッション、`-p` 実行、および Agent SDK では、`/effort` はそのセッションのみに適用されます。[努力レベルを調整](/docs/ja/model-config#adjust-effort-level)はそのセッションのみに適用されるインタラクティブな選択肢もリストします。`/effort` が出力するメッセージは、どちらが起こったかを示します。

* **スコープ**: [`任意のファイル`](#scopes)
* **タイプ**: 文字列、以下のいずれか:
  * `"low"`: 最小限の推論。短く、スコープが限定され、レイテンシに敏感で、インテリジェンスに敏感ではないタスク用
  * `"medium"`: コスト敏感な作業のトークン使用量を削減します。インテリジェンスをいくらか取引できます
  * `"high"`: トークン使用量とインテリジェンスのバランスを取ります
  * `"xhigh"`: より高いトークン支出でより深い推論
* **デフォルト**: 設定解除されています
* **セッションごとのオーバーライド**: `--effort` はこのキーより優先されます。[`CLAUDE_CODE_EFFORT_LEVEL`](/docs/ja/env-vars)は両方より優先されます

```json settings.json theme={null}
{
  "effortLevel": "xhigh"
}
```

ユーザー設定ファイル `~/.claude/settings.json` では、このキーは `/effort` が保存する前の古い形式です。モデルごとにレベルを保存し、以前に適用された場所に適用され続けます。Opus 5、Fable 5.1、および以前のモデルで。Opus 5.5 およびそれ以降にリリースされたモデルはそれを無視し、[`modelSettings`](#modelsettings)の下でレベルを保存するまで独自のデフォルトで開始します。これは `/effort` が書き込みます。プロジェクト、ローカル、管理設定、および `--settings` では、このキーはすべてのモデルに適用されます。

### `enforceAvailableModels`

`/model` ピッカーには**Default**オプションがあり、[`default` モデル設定](/docs/ja/model-config#default-model-setting)はそれが解決するモデルを説明します。[`availableModels`](#availablemodels)許可リストは名前を付けることができるモデルを制限しますが、デフォルト[プレフィックスマッチング](#availablemodelsmatch)では、アカウントタイプのデフォルトを再マップしないため、**Default**はリスト外のモデルに解決できます。このキーはそのギャップを閉じます。Claude Code v2.1.175 以降が必要です。

組織が管理設定をデプロイすると、Claude Code はこのキーを管理ソースからのみ読み取り、他のファイルでは無視します。

起動時のモデルチェックにこのキーがどのように適用されるかについては、[Amazon Bedrock](/docs/ja/amazon-bedrock#when-your-organization-enforces-a-model-allowlist) および [Google Cloud の Agent Platform](/docs/ja/google-vertex-ai#when-your-organization-enforces-a-model-allowlist) を参照してください。

* **スコープ**: [`任意のファイル`](#scopes)
* **タイプ**: ブール値
  * `true`: **Default**が `availableModels` 外のモデルに解決される場合、Claude Code はそれをリスト内の最初の利用可能なモデルに解決します
  * `false`: このキーは**Default**の解決方法を変更しません
* **デフォルト**: `false`

この例は、名前付き選択を Sonnet と Haiku モデルに制限し、**Default**を利用可能なそれらの最初のものに解決します:

```json settings.json theme={null}
{
  "availableModels": ["sonnet", "haiku"],
  "enforceAvailableModels": true
}
```

このキーは `availableModels` が設定解除されているか空の場合は効果がありません。[Default モデルの許可リストを強制](/docs/ja/model-config#enforce-the-allowlist-for-the-default-model)を参照してください。Claude Code v2.1.175 以降が必要です。

### `fallbackModel`

プライマリモデルがオーバーロードされているか利用できない場合に、Claude Code が順番に試すバックアップモデルに名前を付けます。Claude Code はターンの残りの間、チェーン内の次の利用可能なモデルに切り替え、通知を表示します。チェーンがない場合、Claude Code は同じモデルを再試行してからサーバーのエラーを表示し、再試行するか自分でモデルを切り替えます。

切り替えは、フォールバックモデルでコールド[プロンプトキャッシュ](/docs/ja/prompt-caching#switching-models)を使用した 1 ターンを意味します。次のメッセージはプライマリモデルを最初に再度試します。

* **スコープ**: [`任意のファイル`](#scopes)
* **タイプ**: モデルエイリアスまたは ID の配列。`"default"` はデフォルトモデルに展開されます
* **デフォルト**: 設定解除されているため、失敗したリクエストは別のモデルで再試行されません
* **セッションごとのオーバーライド**: `--fallback-model` はこのキーより優先されます

この例は、プライマリモデルが失敗したときに最初に Sonnet 5 を試し、次に Haiku 4.5 を試します:

```json settings.json theme={null}
{
  "fallbackModel": ["claude-sonnet-5", "claude-haiku-4-5"]
}
```

ほとんどの配列設定とは異なり、このキーは設定ファイル全体でマージされません。最も優先度の高いファイルがそれを定義すると、チェーン全体が供給されます。プロジェクトファイルが `["claude-sonnet-5"]` を設定し、ユーザーファイルが `["claude-haiku-4-5"]` を設定する場合、チェーンは `["claude-sonnet-5"]` のみです。Claude Code はリストから最大 3 つの異なる許可されたモデルを保持し、残りを無視します。[フォールバックモデルチェーン](/docs/ja/model-config#fallback-model-chains)を参照してください。

### `fastMode`

利用可能なセッションで[高速モード](/docs/ja/fast-mode)をオンにします。高速反復やライブデバッグなどのインタラクティブな作業用で、トークンあたりのコストが高い速度が必要な場合。通常、このキーを手動で編集することはありません。`/fast` を実行すると `fastMode: true` が `~/.claude/settings.json` に書き込まれ、再度実行すると高速モードをオフにするキーが削除されます。高速モードは Opus 5.5、Opus 5、および Opus 4.8 でのみ実行されます。別のモデルからオンにするとあなたを Opus に切り替え、サポートされていないモデルに切り替えるとオフになります。[高速モードがオンの間にモデルを切り替え](/docs/ja/fast-mode#switch-models-while-fast-mode-is-on)を参照してください。

* **スコープ**: [`任意のファイル`](#scopes)
* **タイプ**: ブール値
  * `true`: Claude Code は利用可能なセッションで高速モードをオンにします
  * `false`: 高速モードはオフのままです
* **デフォルト**: 設定解除されているため、高速モードはオフです
* **セッションごとのオーバーライド**: [`CLAUDE_CODE_DISABLE_FAST_MODE`](/docs/ja/env-vars)は 1 つのセッションで高速モードをオフにし、このキーはそれをオンに戻すことはできません

```json settings.json theme={null}
{
  "fastMode": true
}
```

### `fastModePerSessionOptIn`

通常、`/fast` を実行すると [`fastMode`](#fastmode)がユーザー設定に保存されるため、高速モードは後のすべてのセッションの開始時にオンになります。このキーを `true` に設定して、それを停止します。保存された `fastMode: true` はセッション開始時に高速モードをオンにしなくなり、各ユーザーは必要な各セッションで `/fast` を実行する必要があります。Claude Code は `fastMode` キーをファイルに残すため、このキーをオフにすると古い動作が復元されます。

Team または Enterprise プランのオーナーは、[サーバー管理設定](/docs/ja/server-managed-settings)を通じて組織全体にデプロイできます。管理設定がキーを設定すると、`/fast on` はインタラクティブターミナルセッション外で拒否され、組織が高速モードを無効にしたことを報告します。これは[非インタラクティブモード](/docs/ja/headless)、[VS Code 拡張機能](/docs/ja/vs-code)、および[クラウドセッション](/docs/ja/claude-code-on-the-web)をカバーします。

* **スコープ**: [`任意のファイル`](#scopes)
* **タイプ**: ブール値
  * `true`: 保存された `fastMode: true` はセッション開始時に高速モードをオンにしなくなるため、各ユーザーは必要な各セッションで `/fast` を実行します。`--settings` で渡された `fastMode: true` は、管理設定がこのキーを設定しない限り、そのセッションでもカウントされます
  * `false`: 保存された `fastMode: true` は後のすべてのセッションの開始時に高速モードをオンにします
* **デフォルト**: `false`

```json settings.json theme={null}
{
  "fastModePerSessionOptIn": true
}
```

[セッションごとのオプトインを必須にする](/docs/ja/fast-mode#require-per-session-opt-in)を参照してください。

### `language`

Claude がデフォルトで英語以外の言語で応答するようにします。応答の固定リストはありません。Claude Code は値を Claude に逐語的に、常にその言語で応答するという指示として渡すため、Claude が読むことができる言語名は機能します。Claude Code は値をチェックしないため、スペルが間違った名前はエラーを生成するのではなく、書かれたとおりに Claude に到達します。同じ値は[音声ディクテーション](/docs/ja/voice-dictation#change-the-dictation-language)の言語を設定します。これは[サポートされているディクテーション言語](/docs/ja/voice-dictation#change-the-dictation-language)の固定リストを持ち、自動生成されたセッションタイトルも設定します。

* **スコープ**: [`任意のファイル`](#scopes)
* **タイプ**: 文字列、`"japanese"`、`"spanish"`、`"french"` などの言語名。Claude Code はそれを検証しません
* **デフォルト**: 設定解除されています。セッションタイトルは会話の言語と一致します

```json settings.json theme={null}
{
  "language": "japanese"
}
```

### `maxEffortLevel`

セッションが使用できる[努力レベル](/docs/ja/model-config#adjust-effort-level)をキャップし、低いレベルを利用可能なままにします。より高いレベルはキャップで実行されます。`/effort`、`/model` ピッカー、`--effort`、[`CLAUDE_CODE_EFFORT_LEVEL`](/docs/ja/env-vars)、スキルまたはサブエージェントの `effort` frontmatter、またはモデル自体のデフォルトから。Claude Code はリクエストの前にキャップ自体を適用するため、Amazon Bedrock、Google Cloud の Agent Platform、Microsoft Foundry を含むすべてのプロバイダーで保持されます。Claude Code v2.1.267 以降が必要です。

* **スコープ**: [`任意のファイル`](#scopes)。組織に対して強制するために、管理設定にデプロイします。複数のスコープがキャップを設定する場合、最も低いものが適用されるため、1 つのスコープで設定されたキャップを別のスコープから上げることはできません
* **タイプ**: 文字列、`"low"`、`"medium"`、`"high"`、`"xhigh"`、または `"max"` のいずれか。`"max"` 値はキャップを設定しません
* **デフォルト**: 設定解除されているため、キャップは適用されません
* **モデルごとのキャップ**: モデルの [`modelSettings`](#modelsettings)エントリに `maxEffortLevel` を追加します。そのエントリは、ユーザー設定や 1 つの[管理ソース](/docs/ja/managed-settings#how-claude-code-combines-managed-sources)など、両方を設定する設定ソース内でのみこのキーを置き換えます。そこで `"max"` を設定して、そのソースのキャップからモデルを除外します。Claude Code は他のソースからのキャップを依然として適用します

この例はすべてのモデルを `medium` でキャップし、Sonnet 4.6 を除外します:

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

組織がモデルの[努力制限](/docs/ja/model-config#organization-effort-limits)も設定する場合、2 つのキャップの低い方が適用されます。

### `model`

すべての新しいセッションが使用するモデルを設定するため、毎回 `/model` で 1 つを選択する必要はありません。ここで設定してもセッション中に切り替えることは止まりません。管理者が[組織デフォルトモデル](/docs/ja/model-config#organization-default-model)を設定してユーザー選択をオーバーライドした場合、ユーザー、プロジェクト、またはローカル設定でこのキーを設定しても、そのモデルを取得します。

* **スコープ**: [`任意のファイル`](#scopes)
* **タイプ**: 文字列、モデルエイリアスまたは完全なモデル ID
* **デフォルト**: 設定解除されているため、Claude Code はアカウントのデフォルトモデルを使用します
* **セッションごとのオーバーライド**: `--model` は [`ANTHROPIC_MODEL`](/docs/ja/env-vars)より優先され、両方は 1 つのセッションでこのキーより優先されます。管理 `model` を含む。[`availableModels`](#availablemodels)リストは依然として選択に適用されます

```json settings.json theme={null}
{
  "model": "claude-sonnet-5"
}
```

ここの値は [`ANTHROPIC_DEFAULT_MODEL`](/docs/ja/model-config#set-a-default-model-for-new-sessions)をランク付けし、Claude Code は他に何もモデルを選択しない場合にのみ使用します。

### `modelOverrides`

Anthropic モデル ID をプロバイダー固有のモデル ID (Amazon Bedrock 推論プロファイル ARN など)にマップします。各モデルピッカーエントリは、プロバイダー API を呼び出すときにマップされた値を使用します。管理者は[Amazon Bedrock、Google Cloud の Agent Platform、Microsoft Foundry](/docs/ja/model-config#override-model-ids-per-version)でこれを使用して、各モデルバージョンを特定の推論プロファイル、バージョン名、またはガバナンス、コスト配分、または地域ルーティングのためのデプロイメントにルーティングします。

* **スコープ**: [`任意のファイル`](#scopes)
* **タイプ**: モデル ID をプロバイダーモデル ID にマップするオブジェクト
* **デフォルト**: 設定解除されています

この例は、Opus 4.6 のすべての呼び出しを名前付き Bedrock 推論プロファイルにルーティングします:

```json settings.json theme={null}
{
  "modelOverrides": {
    "claude-opus-4-6": "arn:aws:bedrock:us-east-1:123456789012:inference-profile/example"
  }
}
```

[モデル ID をバージョンごとにオーバーライド](/docs/ja/model-config#override-model-ids-per-version)を参照してください。

### `modelPicker`

`/model` ピッカーが提供するモデルを、書き込む順序で、選択するラベルの下にリストします。ピッカーは組織が実行するモデルをリストします。組み込みラインアップの後または代わりに。各行の `model` は逐語的に取得されるため、`--model` が受け入れるもの、`opus` などのエイリアス、Anthropic モデル ID、または Amazon Bedrock、Google Cloud の Agent Platform、Microsoft Foundry、または LLM ゲートウェイのプロバイダー形式 ID を受け入れます。Claude Code v2.1.242 以降が必要です。

* **スコープ**: [`ユーザーまたは管理`](#scopes)。Claude Code は管理設定、`--settings`、およびユーザー設定からキーを読み取り、プロジェクトおよびローカル設定では無視するため、クローンするリポジトリはピッカーを再ラベルできません。これら 3 つの最も高いものがキーを設定すると、ラインアップ全体が供給され、Claude Code は 2 つのソースからラインアップをマージしません。
* **タイプ**: `options` 配列と行とオプションの `replaceBuiltInOptions` ブール値を持つオブジェクト
* **デフォルト**: 設定解除されているため、ピッカーは組み込みラインアップを表示します

この例は、組み込みラインアップの後に 2 つの Bedrock デプロイメントを追加し、チームが認識する名前の下に:

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

キーは 2 つのフィールドを取ります。1 つは行自体用で、もう 1 つは組み込みラインアップを置き換えるか追加するかです。

| フィールド | タイプ | 動作 |
| :- | :- | :- |
| `options` | 必須の `model` とオプションの `label`、`description`、および `behavesAs` を持つ行の配列 | ピッカーが表示する行。この順序で。グレーアウトされた行は下部に移動します。`label` がない場合、Claude Code は既知のモデルの組み込み名でタイトルを付けるか、モデル ID でタイトルを付けます。`description` がない場合は、一般的な 2 行目を書き込みます |
| `replaceBuiltInOptions` | ブール値、デフォルト `false` | これらの行のみ、**Default**、およびセッションが既に使用しているモデルの行を表示するには `true` に設定します。これらの行を組み込みラインアップの後に追加するには、設定解除のままにします |

`options` のエントリは、その `model` の横にオプションの `behavesAs` 文字列を持つこともできます。これには v2.1.257 以降が必要です。Claude Code バージョンが既に知っている `claude-opus-4-8` などのモデルの ID に設定します。`model` が バージョンより新しいエントリで。Claude Code はそれ以降、既知のモデルの機能と努力デフォルトをエントリに適用し、そのモデルを不明として扱いません。エントリのラベルと Claude Code がリクエストで送信するモデル ID は変わりません。

`replaceBuiltInOptions` がオンの場合、Claude Code はすべての他の行を非表示にします。組み込みラインアップ、[`availableModels`](#availablemodels)エントリ用に追加する行、[ゲートウェイディスカバリー](/docs/ja/llm-gateway-protocol#model-discovery)が見つけたモデル、および [`ANTHROPIC_CUSTOM_MODEL_OPTION`](/docs/ja/model-config#add-a-custom-model-option)。オフの場合、Claude Code は組み込みラインアップが既にカバーするリストされたモデルをスキップします。ラベルはピッカーが表示するものを変更し、Claude Code が実行するモデルではありません。

[`availableModels`](#availablemodels)許可リストはこれらの行に依然として適用されます。リストされたモデルを許可リストに追加する前に、[マージ動作](/docs/ja/model-config#merge-behavior)を読んでください。特定のモデル ID はそのファミリーのワイルドカード エントリを絞ります。Claude Code はピッカーを表示する前に各行をセッションに対してチェックします:

* **削除**: Claude Code が提供できない行。廃止されたモデルや組織がアクセスできないモデルなど
* **グレーアウト**: まだ選択できない行。理由を示して表示されます
* **行が生き残らない**: Claude Code は通常どおり許可リストでフィルタリングされた組み込みラインアップを保持します

Claude Code は解析できない行を削除し、残りを保持します。[壊れた設定ファイルを修正](/docs/ja/settings#fix-a-broken-settings-file)を参照してください。

### `modelPricing`

組織が支払うレートでリスト価格の代わりに支出を報告します。組織が契約レートを持っている場合に設定するため、開発者が見るドル数字は請求書と一致します。Claude Code は `/usage`、[ステータスライン](/docs/ja/statusline)、Agent SDK の `total_cost_usd`、[`--max-budget-usd`](/docs/ja/cli-reference)制限、および[OpenTelemetry](/docs/ja/monitoring-usage)コストメトリックとイベントのレートを適用します。レートを供給します。Claude Code は契約またはClaude Console から読み取りません。Claude Code v2.1.242 以降が必要です。

* **スコープ**: [`管理`](#scopes)。サーバー管理設定、MDM ポリシー、`managed-settings.json` ファイル、または[ポリシーヘルパー](/docs/ja/managed-settings#compute-the-policy-with-a-helper-program)を通じてキーをデプロイします。Claude Code はユーザー、プロジェクト、ローカル設定、`--settings`、および Windows のユーザー書き込み可能な[HKCU レジストリ](/docs/ja/managed-settings#where-each-mechanism-stores-the-policy)では無視します。サーバー管理設定では、各セッションはそのセッションの[設定フェッチ](/docs/ja/server-managed-settings#fetch-and-caching-behavior)が設定を確認するまでリスト価格でコストを報告します。Claude Code を埋め込み、[`CLAUDE_CODE_PROVIDER_MANAGED_BY_HOST`](/docs/ja/env-vars)を設定するホストアプリケーションは、SDK [`managedSettings`](/docs/ja/agent-sdk/typescript#options)オプションを通じて独自のテーブルを供給でき、Claude Code はマネージドソースがキーを設定しない場合にのみ使用し、Claude Code v2.1.246 以降でのみ使用します。
* **タイプ**: オプションの `multiplier` とオプションの `overrides` マップを持つオブジェクト
* **デフォルト**: 設定解除されているため、Claude Code はリスト価格を報告します。ホストアプリケーションがテーブルを供給しない限り

`multiplier` のみを設定して定額割引またはマークアップ、`overrides` のみをモデルごとのレート、または両方を設定します。

この例は Sonnet 4.6 の契約レートを設定し、すべての数字を 15% 削減します。Sonnet 行を含む:

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

1 より上、最大 10 までマークアップするには `multiplier` を設定します。マークアップには Claude Code v2.1.271 以降が必要です。以前のバージョンは警告付きで 1 より上の `multiplier` を無視し、設定の残りを保持します。

手順を含む、レートが有効であることを確認する方法については、[契約レートで支出を報告](/docs/ja/costs#report-spend-at-your-contracted-rates)を参照してください。

#### `modelPricing` のフィールド

| フィールド | タイプ | 動作 |
| :- | :- | :- |
| `multiplier` | 0 より大きく最大 10 の数値 | Claude Code が計算するすべてのコストをスケーリングします。`overrides` 行がカバーするかどうかに関わらず。1 未満は割引、1 より上はマークアップです |
| `overrides` | モデル ID をそれぞれ 0 から 10000 の `input`、`output`、`cacheRead`、および `cacheWrite` を持つレートオブジェクトにマップします | そのモデルの USD-per-million-token レート。すべて 4 つが必要です。`cacheWrite` は 5 分と 1 時間のキャッシュ書き込みの両方をカバーします。[どのモデルが行に適用されるか](#which-models-a-modelpricing-row-applies-to)を参照してください |

Claude Code はレートを書き込んだとおりに使用し、高速モード割増料金または[US のみの推論レート](https://platform.claude.com/docs/en/about-claude/pricing)を追加しません。`multiplier` も設定する場合、Claude Code はそれを行のレートの上に適用します。Claude Code は解析できないレートを持つ行、または解析できない `multiplier` を削除し、残りを保持します。[壊れた設定ファイルを修正](/docs/ja/settings#fix-a-broken-settings-file)を参照してください。

#### どのモデルが `modelPricing` 行に適用されるか

Claude Code は行のキーから行が適用されるモデルを決定します:

* **組み込みモデルの ID**: Claude Code 自体がモデルの独自の ID (例: `claude-sonnet-4-6`) またはその Bedrock、Agent Platform、または Foundry ID であるかどうかに関わらず、組み込みモデルに使用するキー。Claude Code はそのモデルのすべての日付スナップショット ID とプロバイダー固有の ID に行を適用します。
* **その他のキー**: 組み込みモデルの ID ではないキー。ゲートウェイモデルエイリアスなど。Claude Code はそのキーのみに行を適用します。モデル ID がキーの 1 つと正確に一致し、組み込みモデルの ID でキーされた行の下にも該当する場合、Claude Code は正確な一致を使用します。
* **Bedrock アプリケーション推論プロファイル**: Claude Code がプロファイルを [`modelOverrides`](#modeloverrides)マップまたは [`bedrock:GetInferenceProfile` ルックアップ](/docs/ja/amazon-bedrock#iam-configuration)を通じてルーティングするモデルに解決した後、Claude Code はそのモデルの行をプロファイルに適用します。

### `modelSettings`

使用する各モデルの[努力レベル](/docs/ja/model-config#adjust-effort-level)を保存します。Claude Code v2.1.251 以降が必要です。

マシン上のインタラクティブセッションで、`/effort` または `/model` ピッカーの努力スライダーで `low`、`medium`、`high`、または `xhigh` をデフォルトとして保存すると、Claude Code はそれを使用しているモデルの下にここにそのレベルを書き込むため、このキーを自分で編集することはめったにありません。[VS Code 拡張機能のモデルピッカー](/docs/ja/vs-code#use-the-prompt-box)でこれらのレベルのいずれかを選択すると、Claude Code は同じ方法でここに保存します。[`effortLevel`](#effortlevel)エントリは `/effort` がそのセッションのみに適用されるセッションをリストします。

レベルを変更または削除するには、キーを手動で編集します。

ここで指定するモデルの `effortLevel` は、同じ設定ファイルの最上位 [`effortLevel`](#effortlevel)より優先されます。ファイル間では、Claude Code は各モデルを個別に解決します。そのモデルの `effortLevel` または[そのモデルに適用される](#effortlevel)最上位 `effortLevel` のいずれかを設定する最も優先度の高い[設定ファイル](/docs/ja/settings#settings-precedence)が決定するため、管理設定の `effortLevel` はユーザー設定で保存されたレベルより優先されます。[努力レベルを調整](/docs/ja/model-config#adjust-effort-level)は、起動時の `--effort` など、保存されたレベルをオーバーライドできるその他のものをリストします。

1 つのモデルの努力レベルを設定するのではなくキャップするには、そのモデルのエントリに [`maxEffortLevel`](#maxeffortlevel)フィールドを追加します。フィールドには Claude Code v2.1.267 以降が必要です。

* **スコープ**: [`任意のファイル`](#scopes)
* **タイプ**: モデル名を、以下のいずれかのフィールドを持つオブジェクトにマッピングするオブジェクト:
  * `effortLevel`: `"low"`、`"medium"`、`"high"`、`"xhigh"` のいずれか
  * [`maxEffortLevel`](#maxeffortlevel): モデルが実行できる最も高い effort レベル
  * `autoCompactWindow`: `100000` から `1000000` までのトークン数、またはモデルに合わせて調整されたウィンドウを使う `"auto"`。[`/autocompact`](/docs/ja/model-config#set-the-auto-compact-window) はここに保存します。そのモデルについては、この値が同じ設定ファイル内の最上位の [`autoCompactWindow`](#autocompactwindow) より優先されます。Claude Code v2.1.288 以降が必要です
* **デフォルト**: 設定解除されています

Claude Code は各エントリを `claude-opus-5-5` などのモデルの正規名の下に書き込み、そのモデルのエイリアス、日付サフィックス、`[1m]`、および認識されたプロバイダー固有の ID を同じエントリと一致させます。

この例は Opus 5.5 を `high` に保ちながら、他のモデルは独自の保存またはデフォルトレベルを使用します:

```json settings.json theme={null}
{
  "modelSettings": {
    "claude-opus-5-5": {
      "effortLevel": "high"
    }
  }
}
```

`/effort auto` を実行して、使用しているモデルの保存されたレベルをクリアします。Claude Code は他のエントリと最上位の `effortLevel` をそのままにします。

### `outputStyle`

[出力スタイル](/docs/ja/output-styles)を名前で選択します。出力スタイルは、Claude の役割、トーン、出力形式を変更する保存された指示のセットです。組み込みの Explanatory および Learning スタイルや自分で書いたものなど。

セッション中にこのキーを変更すると、Claude は次のメッセージから新しいスタイルを使用します。そのメッセージがプロンプトキャッシュでコストするものについては、[出力スタイルを変更](/docs/ja/prompt-caching#changing-output-style)を参照してください。v2.1.251 より前では、編集は `/clear` を実行した後またはセッションを開始した後にのみ適用されました。

* **スコープ**: [`任意のファイル`](#scopes)
* **タイプ**: 文字列。[組み込み](/docs/ja/output-styles#built-in-output-styles)または[カスタム](/docs/ja/output-styles#create-a-custom-output-style)出力スタイルの名前
* **デフォルト**: 設定解除されているため、Claude Code はデフォルトスタイルを使用します

この例は、タスク間に教育的な洞察を追加する組み込みの Explanatory スタイルを選択します:

```json settings.json theme={null}
{
  "outputStyle": "Explanatory"
}
```

### `promptCacheTtl`

[プロンプトキャッシュ](/docs/ja/prompt-caching)がメイン会話を保持する期間を選択します。このキーはインタラクティブ、`-p`、および Agent SDK ターンに適用されます。Claude Code がインラインで実行するヘルパーと一緒に。1 時間のライフタイムはより長い休憩全体でキャッシュを温かく保ち、API は[各キャッシュ書き込みを 5 分のライフタイムより高いレートで請求します](https://platform.claude.com/docs/en/build-with-claude/prompt-caching#pricing)。Claude Code v2.1.242 以降が必要です。

* **スコープ**: [`任意のファイル`](#scopes)
* **タイプ**: 文字列、以下のいずれか:
  * `"5m"`: キャッシュは 5 分間保持されます
  * `"1h"`: キャッシュは 1 時間保持されます
* **デフォルト**: 設定解除されているため、各メイン会話リクエストは[そのデフォルトライフタイム](/docs/ja/prompt-caching#which-ttl-each-request-gets)を取得します
* **セッションごとのオーバーライド**: [`FORCE_PROMPT_CACHING_5M`](/docs/ja/env-vars)はすべてを優先し、次に [`CLAUDE_CODE_PROMPT_CACHE_TTL`](/docs/ja/env-vars)、次にこのキー、最後に [`ENABLE_PROMPT_CACHING_1H`](/docs/ja/env-vars)

この例はメイン会話を 1 時間のライフタイムに保ち、サブエージェントを 5 分のままにします:

```json settings.json theme={null}
{
  "promptCacheTtl": "1h",
  "subagentPromptCacheTtl": "5m"
}
```

各ライフタイムのコストについては、[キャッシュライフタイム](/docs/ja/prompt-caching#cache-lifetime)を参照してください。

### `showThinkingSummaries`

対話セッションで Claude の[拡張思考](/docs/ja/model-config#extended-thinking)の要約を表示します。`Ctrl+O` で思考を展開したときに完全な要約を見たい場合に設定します。設定解除または `false` の場合、Anthropic API は思考ブロックを秘匿し、Claude Code は折りたたまれたスタブを表示します。

* **スコープ**: [`任意のファイル`](#scopes)
* **タイプ**: ブール値
  * `true`: `Ctrl+O` で思考を展開するときに完全な思考概要が表示されます
  * `false`: Anthropic API は思考ブロックを編集し、Claude Code は折りたたまれたスタブを表示します
* **デフォルト**: `false`

```json settings.json theme={null}
{
  "showThinkingSummaries": true
}
```

編集は、モデルが生成するものではなく、表示するものだけを変更します。思考支出を削減するには、代わりに[予算を低下させるか思考を無効にします](/docs/ja/model-config#extended-thinking)。

### `subagentPromptCacheTtl`

[プロンプトキャッシュ](/docs/ja/prompt-caching)がメイン会話外で Claude Code が行うリクエストを保持する期間を選択します。このキーは[サブエージェント](/docs/ja/sub-agents)、[ワークフロー](/docs/ja/workflows)、および Claude Code 独自のバックグラウンドおよびヘルパーリクエスト (圧縮やセッションタイトルなど)に適用されます。1 時間のライフタイムはより長い休憩全体でキャッシュを温かく保ち、API は[各キャッシュ書き込みを 5 分のライフタイムより高いレートで請求します](https://platform.claude.com/docs/en/build-with-claude/prompt-caching#pricing)。Claude Code v2.1.242 以降が必要です。

* **スコープ**: [`任意のファイル`](#scopes)
* **タイプ**: 文字列、以下のいずれか:
  * `"5m"`: キャッシュは 5 分間保持されます
  * `"1h"`: キャッシュは 1 時間保持されます
* **デフォルト**: 設定解除されているため、これらの各リクエストは[そのデフォルトライフタイム](/docs/ja/prompt-caching#which-ttl-each-request-gets)を取得します
* **セッションごとのオーバーライド**: [`FORCE_PROMPT_CACHING_5M`](/docs/ja/env-vars)はすべてを優先し、次に [`CLAUDE_CODE_SUBAGENT_PROMPT_CACHE_TTL`](/docs/ja/env-vars)、次にこのキー、次に [`ENABLE_PROMPT_CACHING_1H`](/docs/ja/env-vars)。サブエージェント独自の frontmatter 値がランク付けされる場所については、[TTL を自分で選択](/docs/ja/prompt-caching#choose-the-ttl-yourself)を参照してください

この例はサブエージェントとメイン会話外の他のリクエストに 1 時間のライフタイムを与えます:

```json settings.json theme={null}
{
  "subagentPromptCacheTtl": "1h"
}
```

このキーは [`promptCacheTtl`](#promptcachettl)がカバーしないリクエストをカバーするため、Claude Code が行うすべてのリクエストのライフタイムを選択するには両方を設定します。サブエージェントのキャッシュがメイン会話のキャッシュとどのように異なるかについては、[サブエージェントとキャッシュ](/docs/ja/prompt-caching#subagents-and-the-cache)を参照してください。

### `switchModelsOnFlag`

[安全分類器がリクエストにフラグを立てた](/docs/ja/model-config#automatic-model-fallback)場合に何が起こるかを選択します。フォールバックモデルに切り替えて続行するか、切り替えるかプロンプトを編集するかを選択できるように一時停止します。

* **スコープ**: [`任意のファイル`](#scopes)。`/config` には **メッセージが警告対象となったときにモデルを切り替える** として表示され、選択肢は **自動的に切り替える** と **毎回確認する** です。
* **タイプ**: ブール値
  * `true`: Claude Code はフォールバックモデルに切り替えて続行します
  * `false`: インタラクティブセッションで Claude Code は一時停止して、切り替えるかプロンプトを編集するかを選択できます。ダイアログが表示できない場所 (`-p` 実行など)では、フラグされたリクエストはエラーで終了します
* **デフォルト**: 設定解除されています。Claude Code は自動的に切り替えますが、対話セッションでは[先に確認する](/docs/ja/model-config#ask-before-switching)場合があります

```json settings.json theme={null}
{
  "switchModelsOnFlag": false
}
```

[切り替える前に確認](/docs/ja/model-config#ask-before-switching)を参照してください。

### `ultracode`

セッションを[ultracode](/docs/ja/workflows#let-claude-decide-with-ultracode)でオンで開始します。オンの場合、Claude は、あなたが尋ねるのを待つのではなく、各実質的なタスクのワークフローを計画します。Claude は[動的ワークフロー](/docs/ja/workflows)が有効になっており、モデルが `xhigh` 努力をサポートする場合にのみワークフローを計画します。キーはセッションの努力レベルを変更しません。ultracode はセッションが使用するレベルで実行されます。Claude Code はこのキーを読み取りますが、決して書き込みません。`/effort ultracode` は現在のセッションのみで ultracode をオンにします。

* **スコープ**: [`任意のファイル`](#scopes)
* **タイプ**: ブール値
  * `true`: 動的ワークフローが有効になっており、モデルが `xhigh` をサポートする場合、セッションは ultracode でオンで開始されます
  * `false`: セッションは ultracode でオフで開始されます
* **デフォルト**: 設定解除されているため、ultracode はオフです
* **セッションごとの上書き**: `/effort ultracode` はこのキーなしで 1 つのセッションの ultracode をオンにし、`/effort ultracode off` はこのキーが `true` の場合に 1 つのセッションの ultracode をオフにします。`--effort ultracode` フラグも、1 つのセッションで `xhigh` effort にして ultracode をオンにします

```json settings.json theme={null}
{
  "ultracode": true
}
```

セッションの努力レベルは [`effortLevel`](#effortlevel)、[`modelSettings`](#modelsettings)、および他の[努力ソース](/docs/ja/model-config#adjust-effort-level)から来ます。[`maxEffortLevel`](#maxeffortlevel)などの[努力キャップ](/docs/ja/model-config#organization-effort-limits)はそのレベルを低下させますが、ultracode をオフにしません。これと `/effort ultracode off` フォームには Claude Code v2.1.284 以降が必要です。v2.1.284 より前では、`ultracode: true` はセッションを `xhigh` 努力で実行し、`xhigh` より下の努力キャップは ultracode をオフに保ちました。Agent SDK `apply_flag_settings` コントロールリクエストもキーを受け入れます。

## 権限設定

Claude が何を確認なしで実行できるか、セッションがどの権限モードで開始するか、auto モードの分類器が何を許可するかを決定します。ルール構文と権限モデルについては、[権限を設定する](/docs/ja/permissions)を参照してください。

### `allowManagedPermissionRulesOnly`

管理設定を権限ルールの唯一の設定ソースにします。Claude Code はユーザー、プロジェクト、ローカル、および `--settings` ファイル内の `allow`、`ask`、`deny` ルールを無視し、`--allowedTools` を無視し、権限プロンプトで常に許可する選択肢を非表示にし、新しいルールの保存を停止します。

[埋め込みホストからの親設定](/docs/ja/managed-settings#let-an-embedding-host-add-policy)が適用される場合、Claude Code はそれらを管理層の一部として扱います。それらの `allow` ルールと `additionalDirectories` を削除し、`deny` および `ask` ルールは保持します。ただし、パターンが `!` で始まる `Read` および `Edit` ルールは除きます。このキーを設定しているかどうかに関わらず、ホストは `!` ルールで管理ルールからパスを除外することはできません。

`--disallowedTools` ルールと現在のセッションの `deny` および `ask` ルールは、Claude Code が設定をセッション中に再度読み込んだ後を含めて、引き続き適用されます。これらは制限のみを行うため、管理ルールが付与するものを拡大することはできません。v2.1.257 より前では、Claude Code は最初の設定再度読み込み時にそれらのコマンドラインおよびセッションルールを削除していました。

`--disallowedTools` またはセッションルール内の `!` パターンが除外できるものについては、[Read および Edit ルール](/docs/ja/permissions#read-and-edit)を参照してください。

このキーを設定すると、Claude Code v2.1.282 以降では、次のソースにあるスキルおよび `.claude/commands/` ファイルの [`allowed-tools`](/docs/ja/skills#pre-approve-tools-for-a-skill) フロントマターも無視されます。

* リポジトリの `.claude/` ディレクトリ
* `~/.claude/skills/` および `~/.claude/commands/` ディレクトリ（[claude.ai から同期されたスキル](/docs/ja/skills#where-synced-skills-load)を含む）
* `--add-dir` ディレクトリ
* `~/.claude/skills/` またはプロジェクトの `.claude/skills/` 内で [`.claude-plugin` マニフェストにより宣言されたプラグイン](/docs/ja/plugins/loading#plugins-shared-through-a-repository)

管理設定からのスキルとバンドルスキルは `allowed-tools` を保持します。スキルの `disallowed-tools` は引き続き適用されます。Claude Code がこのフィールドを無視したときに開発者に何が表示されるかについては、[管理権限ルールのみが適用される場合](/docs/ja/skills#when-only-managed-permission-rules-apply)を参照してください。

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

このキーは MCP サーバーの許可リストをロックダウンしません。そのためには、[`allowManagedMcpServersOnly`](#allowmanagedmcpserversonly)を設定してください。[管理のみの設定](/docs/ja/managed-settings#managed-only-settings)を参照してください。

### `autoMode`

[auto モード](/docs/ja/permission-modes#eliminate-prompts-with-auto-mode)の分類器がブロックおよび許可するものに独自のルールを追加します。これを使用して、分類器に組織が信頼するリポジトリ、バケット、ドメインを伝え、日常的な内部操作のブロックを停止させます。分類器には[組み込みの許可および拒否ルール](/docs/ja/auto-mode-config#inspect-the-defaults-and-your-effective-config)が付属しています。リテラル文字列 `"$defaults"` を配列に含めて、それらの組み込みルールをその位置に保持し、その周りに独自のルールを追加します。省略すると、それらを独自のルールに置き換えます。

* **スコープ**: [`User or managed`](#scopes)
* **タイプ**: `environment`、`allow`、`soft_deny`、`hard_deny` の散文ルール配列、および [`classifyAllShell`](#automode-classifyallshell) ブール値を含むオブジェクト
* **デフォルト**: 未設定。分類器は[組み込みルール](/docs/ja/auto-mode-config#inspect-the-defaults-and-your-effective-config)のみを使用します

この例は、`"$defaults"` を通じて組み込みの `soft_deny` ルールを保持し、`terraform apply` をブロックするルールを 1 つ追加します。

```json settings.json theme={null}
{
  "autoMode": {
    "soft_deny": ["$defaults", "Never run terraform apply"]
  }
}
```

これらのファイルの複数が同じ配列を設定する場合、Claude Code はエントリを連結します。ルール形式と各配列の適用方法については、[auto モードを設定する](/docs/ja/auto-mode-config)を参照してください。

### `autoMode.classifyAllShell`

auto モードがアクティブな間、すべての Bash および PowerShell コマンドを auto モードの分類器に通します。デフォルトでは、auto モードは任意のコードを実行できる許可ルールのみを一時停止します。具体的には、`Bash(*)` などのツール全体およびワイルドカードのルールと、`Bash(python *)` などのインタープリタまたはシェルラッパーのプレフィックスです。`Bash(npm test)` など、それ以外の許可ルールに一致するコマンドは、[コマンドごとの許可ドメイン](/docs/ja/sandboxing#per-command-allowed-domains-in-auto-mode)を持たない限り分類器をスキップします。スキップした場合、ルールのプレフィックスが想定していなかった破壊的な引数が見過ごされたまま通過する可能性があります。このキーを設定すると、セッションのすべてのシェル許可ルールが一時停止され、分類器がすべてのコマンドを確認します。Claude Code v2.1.193 以降が必要です。

* **スコープ**: [`User or managed`](#scopes)。[`autoMode`](#automode)が読み取られる場所で読み取られます。
* **タイプ**: ブール値
  * `true`: auto モードがアクティブな間、Claude Code はすべての Bash および PowerShell コマンドを分類器に通し、シェル許可ルールを一時停止します。auto モード外では、ルールは引き続き適用されます
  * `false`: auto モードは `Bash(*)` や `Bash(python *)` など、任意のコードを実行できる許可ルールのみを一時停止します。それ以外の許可ルールに一致するコマンドは、[コマンドごとの許可ドメイン](/docs/ja/sandboxing#per-command-allowed-domains-in-auto-mode)を持たない限り分類器をスキップし、その他すべてのシェルコマンドは分類器を通ります
* **デフォルト**: `false`

```json settings.json theme={null}
{
  "autoMode": {
    "classifyAllShell": true
  }
}
```

[すべてのシェルコマンドを分類器にルーティングする](/docs/ja/auto-mode-config#route-all-shell-commands-through-the-classifier)を参照してください。

### `disableAutoMode`

[auto モード](/docs/ja/permission-modes#eliminate-prompts-with-auto-mode)を `Shift+Tab` サイクルから削除します。`--permission-mode auto`、設定ファイル、または組み込みデフォルトから[auto モードで開始](/docs/ja/permission-modes#which-mode-a-session-starts-in)する可能性があるセッションは、代わりに `default` で開始します。管理者は管理設定で設定して、組織内の開発者が auto モードを使用するのを防ぎます。

* **スコープ**: [`Any file`](#scopes)。[管理設定](/docs/ja/managed-settings)で最も有用です。ユーザーはそれを上書きできません。`permissions` の下で `permissions.disableAutoMode` としても受け入れられます。
* **タイプ**: 文字列 `"disable"`
* **デフォルト**: 未設定

```json settings.json theme={null}
{
  "disableAutoMode": "disable"
}
```

### `permissions`

Claude が確認なしで使用できるツール、常にプロンプトを表示するツール、ブロックされるツールを制御し、セッションが開始する[権限モード](/docs/ja/permission-modes)を設定します。以下のすべての `permissions.*` キーはこのオブジェクトの下にネストされます。

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

3 つのルール配列は 1 つの構文を共有します。`permissions.allow` の下の[権限ルール構文](#permission-rule-syntax)を参照してください。異なるファイルからの権限ルールがどのように結合されるかについては、[スコープ全体での権限ルールのマージ方法](/docs/ja/permissions#settings-precedence)を参照してください。一般的に設定キーがどのように結合されるかについては、設定ガイドの[設定の優先順位](/docs/ja/settings#settings-precedence)を参照してください。

### `useAutoModeDuringPlan`

Claude Code が plan モード中にシェルコマンドを確認するために auto モードの分類器を使用するかどうかを選択します。デフォルトの `true` では、auto モードが利用可能な場合、分類器は計画中に各コマンドを確認し、プロンプトは表示されません。ただし、[重要パスの削除](/docs/ja/permission-modes#critical-paths)を除きます。`false` に設定すると、組み込みの読み取り専用セット外のすべてのコマンドに対して権限プロンプトが表示されます。`/config` に**プラン中に auto モードを使用**として表示されます。

* **スコープ**: [`User, local, or managed`](#scopes)。リポジトリがこれをオフにすることはできません。
* **タイプ**: ブール値
  * `true`: 未設定と同じです。auto モードが利用可能な場合、分類器は計画中に各シェルコマンドを確認し、プロンプトを表示しません。ただし、[重要パスの削除](/docs/ja/permission-modes#critical-paths)を除きます。これらのファイルのいずれかで `false` が設定されていれば、引き続きオフになります
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

Claude Code はプロジェクトの `.claude/settings.json` から `allow` ルールを適用するのは、そのフォルダの[ワークスペース信頼ダイアログ](/docs/ja/permissions#project-allow-rules-and-workspace-trust)を受け入れた後のみです。

#### 権限ルール構文

権限ルールは `Tool` または `Tool(specifier)` の形式に従います。Claude Code は `deny` ルールを最初に評価し、次に `ask`、次に `allow` を評価し、各ルールの具体性に関係なく最初に一致したものが結果を決定します。[権限ルール評価順序](/docs/ja/permissions#manage-permissions)を参照してください。

各行は 1 つのルール形状とそれが一致するものを示します。

| ルール | 一致するもの |
| :- | :- |
| `Bash` | すべての Bash コマンド |
| `Bash(npm run *)` | `npm run` で始まるコマンド |
| `Read(./.env)` | `.env` ファイルの読み取り |
| `WebFetch(domain:example.com)` | example.com へのフェッチリクエスト |

ワイルドカード動作、Read、Edit、WebFetch、MCP、Agent ルールのツール固有パターン、および Bash パターンのセキュリティ制限を含む完全なルール構文については、[権限ルール構文](/docs/ja/permissions#permission-rule-syntax)を参照してください。

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

Claude Code がブロックするツール使用をリストします。API キー、シークレット、または環境値を保持するファイルに使用します。Claude Code は一致するファイルをファイル検出と検索結果から除外し、それらの読み取りを拒否し、一致するパスの[Edit および Write ツール](/docs/ja/permissions#read-and-edit)をブロックします。

Read および Edit 拒否ルールは Claude の組み込みファイルツール、Claude Code が Bash で認識するファイルコマンド（`cat`、`head`、`tail`、`sed`、`tee` など）、および `> file` や `< file` などの Bash [リダイレクション](/docs/ja/permissions#redirections)のターゲットに適用されます。ファイル名を指定せずにファイルを読み取るコマンド（`grep -r pattern .` など）や任意のサブプロセスには適用されないため、OS レベルで強制するには[サンドボックスを有効にして](/docs/ja/sandboxing)ください。

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

ツール名はグロブパターンを受け入れるため、`"*"` はすべてのツールを拒否し、`"mcp__*"` はすべての MCP ツールを拒否します。Claude Code は、他のツールがまだ Claude で利用可能である限り、[`EndConversation`](/docs/ja/tools-reference#endconversation-tool-behavior)ツールの拒否ルールを無視します。`Bash` 拒否ルールは Claude が書いたコマンドと一致するため、`Bash(curl *)` は `/usr/bin/curl` や `sh -c 'curl …'` を停止しません。[Bash ルールが一致しないもの](/docs/ja/permissions#bash-rule-limits)を参照してください。このキーは非推奨の `ignorePatterns` 設定に置き換わるものです。

### `permissions.additionalDirectories`

Claude に開始したディレクトリ外のディレクトリへのファイルアクセスを付与し、追加の[作業ディレクトリ](/docs/ja/permissions#working-directories)として使用します。ほとんどの `.claude/` 設定は、これらのディレクトリから[検出されません](/docs/ja/permissions#additional-directories-grant-file-access-not-configuration)。

* **スコープ**: [`Any file`](#scopes)。ただし、プロジェクトおよびローカルのエントリが付与するサンドボックスの書き込みアクセスには[制限](/docs/ja/sandboxing#repository-settings-under-an-admin-required-sandbox)があります
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

`allow` ルールと同様に、プロジェクトの `.claude/settings.json` のエントリは、そのフォルダの[ワークスペース信頼ダイアログ](/docs/ja/permissions#project-allow-rules-and-workspace-trust)を受け入れた後にのみ有効になります。

### `permissions.blockReadsOutsideWorkingDirectories`

`bypassPermissions` を含むすべての権限モードで、Claude のファイルツールが[作業ディレクトリ](/docs/ja/permissions#working-directories)外の読み取りを拒否するようにします。Claude Code はそれらのパスに対する `Read`、`Grep`、`Glob`、`LSP` の呼び出しを拒否し、`/add-dir` でディレクトリを追加するようユーザーに求めるよう Claude に指示します。Claude Code 自体が必要とするファイル（`~/.claude/` の下のスキル、プラグイン、ルール、エージェント、コマンド、`CLAUDE.md` メモリファイルなど）は読み取り可能なままです。Claude Code v2.1.257 以降が必要です。

Claude Code はシェルコマンドを同じ方法では拒否しません。

* [どのモードでも自動承認されないアクション](/docs/ja/permission-modes#actions-no-mode-auto-approves)では、そのようなパスを読み取るシェルコマンドがいつプロンプトを表示するかを説明しています
* [ブロック下のサンドボックス化されたコマンド](#sandboxed-commands-under-the-block)では、サンドボックス化されたコマンドが何を読み取れるかを説明しています

シェルパーサーが追跡できない Bash コマンド（複数回ディレクトリを変更するものやサブシェルを実行するものなど）は、auto モードおよび `bypassPermissions` モードでもプロンプトを表示します。プロンプトは、コマンドが作業ディレクトリ外のパスを指定していない場合でも表示されます。このプロンプトは、コマンドが[サンドボックス](/docs/ja/sandboxing)で実行され、サンドボックスがブロックを強制する場合には適用されません。

また、[作業ディレクトリ外の最初の読み取り前に表示される auto モードのプロンプト](/docs/ja/permission-modes#first-read-outside-the-working-directories)でそのような読み取りをブロックすることを選択した場合も、Claude Code はここに `true` を書き込みます。

* **スコープ**: [`Any file`](#scopes)。いずれかのファイルの `true` が適用されるため、リポジトリは自身に対してブロックをオンにできますが、ユーザーが設定したブロックを解除することはできません。
* **タイプ**: ブール値
  * `true`: Claude のファイルツールは作業ディレクトリ外の読み取りを拒否します
  * `false`: 未設定と同じです。別のファイルが `true` を設定している場合、ブロックは引き続き適用されます
* **デフォルト**: 未設定。作業ディレクトリ外の読み取りは[権限モード](/docs/ja/permission-modes)に従います

```json settings.json theme={null}
{
  "permissions": {
    "blockReadsOutsideWorkingDirectories": true
  }
}
```

`--add-dir`、`/add-dir`、またはユーザー設定や管理設定の `additionalDirectories` で追加したディレクトリは、ブロックにおいて作業ディレクトリとしてカウントされます。リポジトリ設定でのみ追加されたディレクトリはカウントされません。該当するのは `.claude/settings.json` のディレクトリと、git がそのファイルを未追跡として報告する場合を除く `.claude/settings.local.json` のディレクトリです。git リポジトリではないディレクトリ、または git がそのファイルを追跡している場合、Claude Code は `.claude/settings.local.json` をリポジトリ設定として扱うため、読み取り可能にしておきたいディレクトリは代わりにユーザー設定に配置してください。

[`autoMemoryDirectory`](#automemorydirectory)がプロジェクトの `.claude/settings.json` から、または[リポジトリ提供として扱われる](/docs/ja/permissions#when-your-local-settings-file-needs-trust)`.claude/settings.local.json` から来る場合、Claude Code はそのディレクトリから[自動メモリ](/docs/ja/memory#storage-location)を読み込まず、そこに保存もしません。

ブロックを解除するには、それを設定しているすべての設定ファイルからキーを削除し、新しいセッションを開始します。

#### ブロック下のサンドボックス化されたコマンド

[サンドボックス化](/docs/ja/sandboxing)がオンの場合、ブロックはサンドボックス化されたコマンドにも適用されます。Claude Code はホームディレクトリおよびユーザーファイルを保持する他のルート（`/Users`、`/home`、`/root`、`/Volumes`、`/mnt`、`/media`、`/run/media`、`/srv`）への読み取りアクセスを拒否します。その後、作業ディレクトリ、Claude Code がセッション中に作成する [worktree](/docs/ja/worktrees)、セッションの一時ディレクトリ、およびコマンドが必要とする `~/.claude` の部分（スキルやプラグインなど）を再度開きます。ブロックが有効な間、リポジトリ設定からの `allowRead` および `allowWrite` エントリはカウントされません。

セッションの作業ディレクトリがリンクされた [git worktree](/docs/ja/worktrees) である場合（Claude Code がセッション中に入ったものを含む）、リポジトリの共通 `.git` ディレクトリはサンドボックス化されたコマンドに対して読み取り可能および書き込み可能なままなので、git はそこで引き続き機能します。

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

新しいセッションが開始する[権限モード](/docs/ja/permission-modes)を設定します。未設定のままにすると、セッションは使用しているサーフェスの[組み込みデフォルト](/docs/ja/permission-modes#which-mode-a-session-starts-in)で開始します。

* **スコープ**: [`Any file`](#scopes)。`auto` および `bypassPermissions` はプロジェクトまたはローカル設定からは有効にならないため、代わりに `~/.claude/settings.json` で設定してください。v2.1.257 より前では、`bypassPermissions` は任意のファイルから有効になりました。VS Code 拡張機能が開始する会話の場合、Claude Code はユーザー、管理、および `--settings` の値のみを読み取ります。
* **タイプ**: 文字列。次のいずれか：
  * `"default"`: Claude Code は確認なしで読み取りのみを実行します
  * `"acceptEdits"`: Claude Code は確認なしでファイル編集と `mkdir` や `mv` などの一般的なファイルシステムコマンドも実行します
  * `"plan"`: Claude Code は読み取りと計画を行いますが、計画を承認するまで編集をブロックします
  * `"auto"`: Claude Code は日常的なプロンプトなしで実行します。シェルコマンドやネットワークリクエストなどのアクションが実行される前に、バックグラウンドの分類器がそれらがユーザーのリクエストに沿っているかを確認します
  * `"dontAsk"`: Claude Code はプロンプトを表示するはずのすべての呼び出しを自動的に拒否します。ただし、インストールした [mod](/docs/ja/plugins/mods/overview) は[それらの呼び出しの一部](/docs/ja/permissions#precedence-among-rules-hooks-and-mods)を引き続き承認できます。作業ディレクトリ内のファイル読み取り、承認が不要な他のアクション、事前承認されたツールは引き続き実行されます。ただし、[ネットワークパス](/docs/ja/permissions#network-paths)からの読み取りは除きます
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

権限ルールはすべてのモードの上に重ねて適用されます。`deny` ルールは `bypassPermissions` を含むすべてのモードでブロックします。[権限モード](/docs/ja/permission-modes)を参照してください。クラウドセッションでは、Claude Code はこのキーのうち `acceptEdits`、`plan`、`default`、`auto` のみを尊重します。VS Code 拡張機能が開始する会話については、[拡張機能が開始権限モードとして読み取る設定](/docs/ja/permission-modes#switch-permission-modes)を参照してください。

### `permissions.disableBypassPermissionsMode`

誰も `bypassPermissions` モードに入れないようにします。Claude Code は `--dangerously-skip-permissions` フラグを拒否し、[エージェント定義](/docs/ja/sub-agents#permission-modes)の `permissionMode: bypassPermissions` を無視するため、サブエージェントは親セッションの権限モードで実行されます。

* **スコープ**: [`Any file`](#scopes)。通常、組織のポリシーを強制するために[管理設定](/docs/ja/managed-settings)で設定します。
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

組み込みデフォルトによってセッションが auto モードで開始された場合ではなく、ユーザー自身の設定やモードセレクターなどを通じて初めて auto モードに入ったときに Claude Code が表示する、[auto モード](/docs/ja/permission-modes#eliminate-prompts-with-auto-mode)を説明する 1 回限りの通知をスキップします。Claude Code はその通知を 1 回表示した後、表示済みであることを記録するため、このキーは通知がまだ表示されていない場合にのみ意味を持ちます。

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

Claude が実行するコマンドをファイルシステム、ネットワーク、認証情報から分離します。サンドボックスの仕組みとプラットフォーム要件については、[サンドボックス](/docs/ja/sandboxing)を参照してください。

### `sandbox`

[サンドボックス](/docs/ja/sandboxing)を使用して、Claude が実行する Bash コマンドをファイルシステムとネットワークから分離します。`enabled` でサンドボックスをオンにしてから、`filesystem`、`network`、`credentials` サブオブジェクトを使用して、サンドボックス化されたコマンドが何にアクセスできるかを制限または拡大します。サンドボックスは macOS、Linux、WSL2 で実行されます。

* **Scope**: [`Any file`](#scopes)
* **Type**: `enabled`、`failIfUnavailable`、`autoAllowBashIfSandboxed`、`excludedCommands`、`allowUnsandboxedCommands`、`enableWeakerNestedSandbox`、`enableWeakerNetworkIsolation`、`allowAppleEvents`、`bwrapPath`、`socatPath`、`ignoreViolations`、`ripgrep` を含むオブジェクト、および `filesystem`、`network`、`credentials` オブジェクト
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

管理設定が `enabled` や `failIfUnavailable` などのブール値キーを設定した場合、その値は開発者が設定したものをすべて上書きします。Claude Code は配列キーをセッションが読み込む設定スコープ全体でマージするため、開発者はエントリを追加できます。管理設定専用のロックについては、[ポリシーの拡大を開発者に防止させる](/docs/ja/sandboxing#keep-developers-from-widening-the-policy)を参照してください。組織に対してサンドボックスを必須にするには、[管理設定でサンドボックスを強制する](/docs/ja/sandboxing#enforce-sandboxing-with-managed-settings)を参照してください。

### `sandbox.enabled`

Bash コマンドの[サンドボックス](/docs/ja/sandboxing)をオンにします。`/sandbox` パネルでモードを選択すると、Claude Code はこのキーを現在のプロジェクトの `.claude/settings.local.json` に書き込みます。`~/.claude/settings.json` に設定して、すべてのプロジェクトをサンドボックス化します。

* **Scope**: [`Any file`](#scopes)（[プロジェクト設定とローカル設定には制限あり](/docs/ja/sandboxing#repository-settings-under-an-admin-required-sandbox)）
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

Linux と WSL2 では、サンドボックスは `bubblewrap` と `socat` が必要です。[Linux と WSL2 をセットアップする](/docs/ja/sandboxing#set-up-linux-and-wsl2)を参照してください。サンドボックスが起動できない場合、[`failIfUnavailable`](#sandbox-failifunavailable) も設定していない限り、Claude Code はコマンドをサンドボックスなしで実行します。

### `sandbox.failIfUnavailable`

`sandbox.enabled` が `true` であるにもかかわらず、依存関係の不足やプラットフォームの非対応によりサンドボックスが起動できない場合に、Claude Code がスタートアップ時にエラーで終了するようにします。このキーがない場合、Claude Code はコマンドをサンドボックスなしで実行します。セキュリティゲートとしてサンドボックスを必須とする管理対象のデプロイでは、この設定を使用できます。

サンドボックスがサポートしていないプラットフォームでは、このキーがオンの場合、Claude Code は起動しません。[管理設定でサンドボックスを強制する](/docs/ja/sandboxing#enforce-sandboxing-with-managed-settings)を参照してください。

* **Scope**: [`Any file`](#scopes)（[プロジェクト設定とローカル設定には制限あり](/docs/ja/sandboxing#repository-settings-under-an-admin-required-sandbox)）
* **Type**: ブール値
  * `true`: `sandbox.enabled` が `true` であるにもかかわらずサンドボックスが起動できない場合、Claude Code はスタートアップ時にエラーで終了します
  * `false`: サンドボックスが起動できない場合、Claude Code はコマンドをサンドボックスなしで実行します
* **Default**: `false`

これにより、すべての管理対象マシンがコマンドをサンドボックス化するか、起動を拒否します：

```json managed-settings.json theme={null}
{
  "sandbox": {
    "enabled": true,
    "failIfUnavailable": true
  }
}
```

[管理設定でサンドボックスを強制する](/docs/ja/sandboxing#enforce-sandboxing-with-managed-settings)を参照してください。

### `sandbox.autoAllowBashIfSandboxed`

Claude Code がサンドボックス化された Bash コマンドを権限プロンプトなしで実行できるようにします。サンドボックスで実行できないコマンドは通常の権限フローを通過し、`deny` ルールと `Bash(git push *)` などのコンテンツスコープ付き `ask` ルールは引き続き適用されます。ベアの `Bash` ask ルールはサンドボックス化されたコマンドではスキップされます。これを `false` に設定して、サンドボックス化されたコマンドも通常の権限フローを通すようにします。これは `/sandbox` **Mode** タブが通常権限モードと呼ぶものです。

* **Scope**: [`Any file`](#scopes)
* **Type**: ブール値
  * `true`: Claude Code はサンドボックス化された Bash コマンドを権限プロンプトなしで実行します。ただし、[自動許可モード](/docs/ja/sandboxing#auto-allow-mode)で説明されているケースを除きます。`CLAUDE_CODE_SUBPROCESS_ENV_SCRUB` は自動許可をオフにします
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

自動許可モードで引き続きプロンプトが表示される操作と、plan モードでの動作については、[自動許可モード](/docs/ja/sandboxing#auto-allow-mode)を参照してください。

### `sandbox.excludedCommands`

Claude Code がサンドボックスの外で実行するコマンド（サンドボックスで動作しないツールなど）に名前を付けます。各エントリは、`Bash(...)` [権限ルール](/docs/ja/permissions#permission-rule-syntax)の内容と同じ構文を使用します：正確なコマンド、`docker *` などのプレフィックス、またはワイルドカードパターン。ワイルドカードを含まないパターンは完全一致となるため、`docker` は引数なしの `docker` にのみ一致します。

エントリは、Bash 呼び出しのすべてのコマンドをカバーする場合にのみ、Bash 呼び出しをサンドボックスから外します。一部の呼び出し形式はそれでもサンドボックス化されたままです。`docker *` エントリだけでは、`npm ci && docker build .` をサンドボックスから外しません。

* **Scope**: [`Any file`](#scopes)（[プロジェクト設定とローカル設定には制限あり](/docs/ja/sandboxing#repository-settings-under-an-admin-required-sandbox)）
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
* `docker build . > build.log` など、ファイル記述子を複製するもの以外のリダイレクト（`2>&1` など）
* 変数から来るコマンド名
* パス引数が絶対パスである、`~` で始まる、または `..` セグメントを含む `git clone`、`git init`、`git worktree add`、`git worktree move`、または `git bundle create`

たとえば、`cd build && docker compose up` は `docker *` エントリの下でサンドボックス化されたままであり、`cd` エントリを追加してもそれは変わりません。`git *` エントリの下では、`git clone <url> vendor/lib` はサンドボックスの外で実行されますが、`git clone <url> ~/tools` はサンドボックス化されたままです。クローンは、宛先パスが指す場所に、実行可能なものを含む可能性のあるファイルツリー全体を書き込みます。

除外されたコマンドも通常の権限フローを通過します。除外は便宜的なものであり、セキュリティ境界ではありません。ツールが特定の場所にのみ書き込む必要がある場合は、[`filesystem.allowWrite`](#sandbox-filesystem-allowwrite) を使えばサンドボックス化されたままにできます。

サンドボックスが[管理者必須](/docs/ja/sandboxing#repository-settings-under-an-admin-required-sandbox)でない限り、セッションが読み込む設定スコープのエントリは 1 つのリストに結合されます。管理者必須の間、Claude Code は `.claude/settings.json` と `.claude/settings.local.json` のエントリを無視するため、クローンしたリポジトリがコマンドをサンドボックスの外に出すことはできません。管理設定、`--settings`、および `~/.claude/settings.json` のエントリは引き続き適用され、このリストに対する管理設定専用のロックはありません。

### `sandbox.allowUnsandboxedCommands`

サンドボックスによってブロックされた後、Claude が `dangerouslyDisableSandbox` パラメータを使用してコマンドをサンドボックスの外で再試行できるようにします。`false` の場合、Claude Code はそのパラメータを無視します。その結果、サンドボックスの実行中は、Claude が実行するコマンドは [`excludedCommands`](#sandbox-excludedcommands) のエントリに一致しない限りサンドボックス化されます。`/sandbox` **Overrides** タブはその状態を**厳密なサンドボックスモード**として表示します。管理設定で `false` にすると、その対象となる開発者に対して厳密なサンドボックスモードがオンになります。

* **Scope**: [`Any file`](#scopes)（[プロジェクト設定とローカル設定には制限あり](/docs/ja/sandboxing#turn-off-the-retry-with-strict-sandbox-mode)）
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

管理設定または `--settings` からの `false` は、サンドボックスを[管理者必須](/docs/ja/sandboxing#repository-settings-under-an-admin-required-sandbox)にもします。ユーザー設定の `false` はプロジェクトの `true` よりも優先されますが、サンドボックスを管理者必須にはしません。プロジェクトの値よりも優先させるには Claude Code v2.1.285 以降が必要です。

サンドボックスなしの再試行を誰が承認するかは、権限モードと許可ルールによって決まります。[サンドボックスなしの再試行エスケープハッチ](/docs/ja/sandboxing#the-unsandboxed-retry-escape-hatch)を参照してください。

[`!` シェルモードプロンプト](/docs/ja/interactive-mode#shell-mode-with-prefix)で自分で入力するコマンドがサンドボックス化されるときを確認するには、[厳密なサンドボックスモード](/docs/ja/sandboxing#turn-off-the-retry-with-strict-sandbox-mode)を参照してください。

### `sandbox.filesystem`

サンドボックス化されたコマンドが読み取りおよび書き込みできるパスを制御します。デフォルトでは、作業ディレクトリ、ユーザーごとの一時ディレクトリ、`--add-dir`、`/add-dir`、または `permissions.additionalDirectories` で追加したディレクトリに書き込むことができ、認証情報ファイルを含むファイルシステムの残りの部分を読み取ることができます。4 つのパスリストで制限または拡大するか、`disabled` でファイルシステムレイヤーをオフにします。[ファイルシステム分離](/docs/ja/sandboxing#filesystem-isolation)のデフォルト境界を参照してください。

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

Claude Code はこれらのリストを OS サンドボックス境界で強制するため、`kubectl`、`terraform`、`npm` などのサンドボックス化されたコマンドが開始するすべてのサブプロセスに適用されます。Claude Code は[権限ルール](/docs/ja/sandboxing#permission-rules)を同じリストに追加します：`Edit` 許可および拒否ルールを `allowWrite` および `denyWrite` に、`Read` 拒否ルールを `denyRead` に、`WebFetch(domain:...)` 許可および拒否ルールを[`network`](#sandbox-network)ドメインリストに追加します。

ロックが適用されない限り、Claude Code はセッションが読み込む設定ファイル全体でこれらのリストをマージします。[`allowManagedReadPathsOnly`](#sandbox-filesystem-allowmanagedreadpathsonly)は `allowRead` を管理設定からのエントリに制限し、[`allowManagedDomainsOnly`](#sandbox-network-allowmanageddomainsonly)は許可されたドメインに対して同じことを行います。[リポジトリロック](/docs/ja/sandboxing#repository-settings-under-an-admin-required-sandbox)は、リポジトリの設定ファイルからのエントリを除外します。

[サンドボックスを設定する](/docs/ja/sandboxing#configure-sandboxing)は、`--setting-sources` で除外するソースをカバーしています。セッション中にリストを編集すると、Claude Code は[実行中のセッションに変更を適用](/docs/ja/settings#when-edits-take-effect)します。

#### サンドボックスパスプレフィックス

`allowWrite`、`denyWrite`、`denyRead`、`allowRead`、および [`credentials.files`](#sandbox-credentials-files) のパスはプレフィックスで解決されます：

| プレフィックス | 意味 | 例 |
| :- | :- | :- |
| `/` | ファイルシステムルートからの絶対パス | `/tmp/build` は `/tmp/build` のままです |
| `~/` | ホームディレクトリに相対 | `~/.kube` は `$HOME/.kube` になります |
| `./` またはプレフィックスなし | プロジェクト設定ではプロジェクトルートに相対、ユーザー設定では `~/.claude` に相対 | `.claude/settings.json` の `./output` は `<project-root>/output` に解決されます |

絶対パスの `//path` プレフィックスも機能します。プロジェクト相対解決を期待して単一スラッシュ `/path` を使用する場合は、`./path` に切り替えます。この構文は、`//path` を絶対パスに、`/path` をプロジェクト相対に使用する[Read および Edit 権限ルール](/docs/ja/permissions#read-and-edit)とは異なります。サンドボックスファイルシステムパスは標準規則を使用するため、`/tmp/build` は絶対パスです。

Claude Code はディレクトリパスから末尾のスラッシュを削除するため、`~/.aws` と `~/.aws/` は同じディレクトリと一致します。v2.1.224 より前では、Claude Code は末尾のスラッシュをサンドボックスに渡していたため、末尾のスラッシュ付きで記述された `denyRead` または `denyWrite` エントリの下のパスを、Claude が引き続き読み取りまたは書き込みできました。

Claude Code は末尾の `/**` も削除するため、`~/build/**` と `~/build` は同じディレクトリをカバーします。`*` などのワイルドカードが機能するかどうかは、エントリがどのリストにあるか、およびプラットフォームに依存します：

* **`allowWrite` および `denyWrite`**: macOS ではワイルドカードが機能します。Linux と WSL2 では、サンドボックスは具体的なパスをマウントするため、Claude Code は末尾の `/**` を削除した後に `*`、`?`、または `[` を含むエントリをスキップし、そのエントリは効果がありません。Claude Code は `Edit` 権限ルールからパスを追加するため、同じ制限が適用され、`/sandbox` の **Config** タブはワイルドカードを含む `Edit` および `Read` 権限ルールについて警告します。
* **`denyRead` および `allowRead`**: ワイルドカードはすべてのプラットフォームで機能します。Linux と WSL2 では、Claude Code は読み取りエントリを、それが一致する具体的なパスに展開します。これは書き込みリストでは行いません。

波括弧は名前の中で通常の文字として一致するため、`~/data/{keys,tokens}` は 2 つの選択肢ではなく、文字どおり `{keys,tokens}` という名前のディレクトリをカバーします。`~/data/keys` と `~/data/tokens` をカバーするには、それぞれを個別のエントリとして追加します。

### `sandbox.filesystem.allowWrite`

作業ディレクトリ、ユーザーごとの一時ディレクトリ、`--add-dir`、`/add-dir`、または `permissions.additionalDirectories` で追加したディレクトリを超えて、サンドボックス化されたコマンドが書き込むことができるパスを追加します。`kubectl` やビルドツールなどのサブプロセスがプロジェクト外に書き込む必要がある場合に使用します。

* **Scope**: [`Any file`](#scopes)（[プロジェクト設定とローカル設定には制限あり](/docs/ja/sandboxing#repository-settings-under-an-admin-required-sandbox)）
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

Claude Code は `allowWrite` エントリと `Edit(...)` 許可権限ルールからのパスをセッションが読み込むすべての設定スコープ全体でマージし、[`permissions.blockReadsOutsideWorkingDirectories`](#sandboxed-commands-under-the-block)がオンの間、リポジトリ設定からのものを除外します。[リポジトリロック](/docs/ja/sandboxing#repository-settings-under-an-admin-required-sandbox)によってリポジトリのエントリが除外されることもあります。`allowWrite` エントリは[保護されたパス](/docs/ja/sandboxing#protected-paths)を解除できません。

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
* **Default**: 未設定。サンドボックス化されたコマンドは[デフォルト読み取りアクセス](/docs/ja/sandboxing#filesystem-isolation)を保持します。これには `~/.aws/credentials` などの認証情報ファイルが含まれます

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

[`denyRead`](#sandbox-filesystem-denyread)がブロックする領域内の特定のパスの読み取りを再度開き、ワークスペースのみの読み取りアクセスを構築します。正確またはワイルドカード `denyRead` エントリは、より広い `allowRead` 内でブロックされたままです。[重複テーブル](/docs/ja/sandboxing#configure-sandboxing)が示すとおりです。ワイルドカード `denyRead` エントリ（`~/**/.env` など）がディレクトリと一致する場合、Claude Code はその内容の読み取りもブロックします。v2.1.236 より前の macOS では、Claude Code はワイルドカード `denyRead` エントリが一致したパスを、より広い `allowRead` エントリがカバーしている場所で再度開き、一致したディレクトリの内容を読み取り可能なままにしました。

* **Scope**: [`Any file`](#scopes)（[プロジェクト設定とローカル設定には制限あり](/docs/ja/sandboxing#repository-settings-under-an-admin-required-sandbox)）
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

Claude Code は `.` エントリをプロジェクト設定ではプロジェクトルートに、ユーザー設定では `~/.claude` に解決します。[`allowManagedReadPathsOnly`](#sandbox-filesystem-allowmanagedreadpathsonly) が設定されていない限り、Claude Code はセッションが読み込む設定ファイル全体でエントリをマージし、[`permissions.blockReadsOutsideWorkingDirectories`](#sandboxed-commands-under-the-block) がオンの間はリポジトリ設定からのエントリを除外します。[リポジトリロック](/docs/ja/sandboxing#repository-settings-under-an-admin-required-sandbox)によってリポジトリのエントリが除外されることもあります。

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

[ポリシーの拡大を開発者に防止させる](/docs/ja/sandboxing#keep-developers-from-widening-the-policy)を参照してください。

### `sandbox.filesystem.disabled`

ネットワーク分離を保持しながらファイルシステム分離をスキップします。サンドボックス化されたコマンドはホストファイルシステムへの無制限の読み取りおよび書き込みアクセスを取得し、それらのネットワーク出力は [`network.allowedDomains`](#sandbox-network-alloweddomains) に限定されたままです。コマンドが何を書き込むかではなく、どこに接続するかを制御するためにサンドボックスを使用する場合に使用します。Claude Code v2.1.216 以降が必要です。

* **Scope**: [`User or managed`](#scopes)。管理設定が `sandbox.filesystem` をまったく設定する場合、または `"mode": "deny"` を持つ `sandbox.credentials.files` エントリをリストする場合、管理設定のみがそれを設定できます。
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

レイヤーがオフの場合、Claude Code は `denyRead` または `credentials.files` `deny` エントリを強制しませんが、`credentials.envVars` エントリと適用された `mask` エントリは引き続き機能します。[`autoAllowBashIfSandboxed`](#sandbox-autoallowbashifsandboxed)は引き続き `true` にデフォルト設定されるため、プロンプトを続けるには `false` に設定します。[ファイルシステム分離を無効にする](/docs/ja/sandboxing#disable-filesystem-isolation)を参照して、それを設定できるソースの完全なリストと、分離がオフの場合に何が変わるかを確認してください。Claude Code v2.1.216 以降が必要です。

### `sandbox.ignoreViolations`

コマンドがプローブして拒否されることが予想されるパスのサンドボックス違反レポートを沈黙させます（例えば、スタートアップ時に `/etc/hosts` をチェックするツール）。これらの拒否は違反として表示されず、Claude が見るものにも表示されません。サンドボックスはアクセスをブロックしたままです。レポートのみが抑制されます。キーはコマンドに対して一致するサブストリング（`*` はすべてのコマンドに一致）で、値はそのコマンドで無視する違反のサブストリング（ファイルシステムパスなど）です。

* **Scope**: [`Any file`](#scopes)（[プロジェクト設定とローカル設定には制限あり](/docs/ja/sandboxing#repository-settings-under-an-admin-required-sandbox)）
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

* **Scope**: [`Any file`](#scopes)（[プロジェクト設定とローカル設定には制限あり](/docs/ja/sandboxing#repository-settings-under-an-admin-required-sandbox)）
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

Linux と WSL2 のみ。[Bubblewrap がコンテナ内で起動に失敗する](/docs/ja/sandboxing#bubblewrap-fails-to-start-inside-a-container)を参照してください。

### `sandbox.enableWeakerNetworkIsolation`

macOS でサンドボックス化されたコマンドがシステム TLS トラストサービス `com.apple.trustd.agent` に到達できるようにします。`gh`、`gcloud`、`terraform` などの Go ベースのツールは、[`network.httpProxyPort`](#sandbox-network-httpproxyport)を MITM プロキシとカスタム CA で使用する場合、TLS 証明書を検証するために必要です。これはトラストサービスを通じた潜在的なデータ流出パスを開くことでセキュリティを低下させます。

* **Scope**: [`Any file`](#scopes)（[プロジェクト設定とローカル設定には制限あり](/docs/ja/sandboxing#repository-settings-under-an-admin-required-sandbox)）
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

MITM プロキシを使用しない場合は、代わりに失敗するツールを [`excludedCommands`](#sandbox-excludedcommands) にリストします。[Go ベースの CLI が macOS で TLS 検証に失敗する](/docs/ja/sandboxing#go-based-clis-fail-tls-verification-on-macos)を参照してください。

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

分離を保持しながら 1 つのそのようなツールを実行するには、代わりに [`excludedCommands`](#sandbox-excludedcommands) に追加します。[macOS の Apple Events](/docs/ja/sandboxing#security-limitations)を参照してください。

### `sandbox.ripgrep`

Claude Code が使用するものの代わりに、独自の ripgrep バイナリをサンドボックスに指定します。たとえば、プラットフォームが異なる方法でビルドされた `rg` を必要とする場合です。

* **Scope**: [`User or managed`](#scopes)
* **Type**: ripgrep バイナリへのパスである `command` を含むオブジェクト、および前置する引数の配列である optional `args`
* **Default**: 未設定。サンドボックスは Claude Code と同じ ripgrep バイナリを使用します。[`USE_BUILTIN_RIPGREP`](/docs/ja/env-vars)を `0` に設定しない限り、これはバンドルされたバイナリです

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

[サンドボックス化されたコマンドから保護する](/docs/ja/sandboxing#protect-credentials)認証情報ファイルと環境変数を宣言します。各エントリはファイル `path` または変数 `name` と `mode` に名前を付けます：`deny` はサンドボックス内の認証情報を非表示にし、`mask` はサンドボックス化されたコマンドにプレースホルダーを表示します。[サンドボックスプロキシ](/docs/ja/sandboxing#mask-credentials)は送信リクエストで実際の値を置き換えます。Claude Code はリストしたエントリのみを保護します。組み込みの認証情報拒否リストはありません。

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

`deny` ファイル保護はファイルシステムレイヤーの一部であるため、[ファイルシステム分離を無効にする](/docs/ja/sandboxing#disable-filesystem-isolation)場合は適用されません。環境変数保護は引き続き適用されます。

#### 管理設定の無効な認証情報エントリ

管理対象の `sandbox.credentials` エントリが検証に失敗した場合、Claude Code は可能な限り認証情報を保護し続けます：

* `files` または `envVars` のエントリで、有効な `path` または `name` と `mask` または `deny` の `mode` を持つもの（キャプチャグループがない `extract` パターンなど）は、警告とともに `mode: "deny"` に低下されるため、認証情報はマスクされず、エントリを修正するまでブロックされたままです。低下した `files` エントリは、明示的な `deny` エントリのように [`filesystem.disabled`](/docs/ja/sandboxing#disable-filesystem-isolation) をピンします。警告は、管理設定がファイルシステム分離をオフにする場合、その読み取りブロックが強制されないことを記します。
* 不明な `mode` または無効な `path` または `name` を持つエントリは削除されます。
* 各ケースは警告します。エントリが低下または削除されるかどうかに関わらず、残りの有効なエントリは引き続き強制されます。

v2.1.191 以降に適用されます。v2.1.221 より前では、すべての無効なエントリが削除されました。フィールドごとの処理を持つ他の管理キーについては、[管理設定の無効なエントリ](/docs/ja/managed-settings#invalid-entries-in-managed-settings)を参照してください。

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

パスは `sandbox.filesystem.*` 設定と同じ[プレフィックス](#sandbox-path-prefixes)を使用し、Claude Code はセッションが読み込むすべての設定スコープから配列をマージします。[認証情報を保護する](/docs/ja/sandboxing#protect-credentials)は、`--setting-sources` で除外するソースから何が引き続き適用されるかをカバーしています。`mask` エントリには Claude Code v2.1.221 以降が必要です。

`mask` 置換はサンドボックスプロキシを通じてのみ実行されるため、[`sandbox.network.tlsTerminate`](#sandbox-network-tlsterminate)、または プレーン HTTP テストネットワークの場合は [`allowPlaintextInject`](#sandbox-credentials-allowplaintextinject) を設定します。`mask` は単一ファイルに適用されるため、各認証情報ファイルを個別にリストします。Claude Code は `deny` エントリの `mask` フィールドを受け入れますが、無視します。[認証情報をマスクする](/docs/ja/sandboxing#mask-credentials)はどの設定ソースが尊重されるかを、[認証情報ファイルをマスクする](/docs/ja/sandboxing#mask-credential-files)はエントリが `deny` にフォールバックするときをカバーしています。

#### ファイルのマスクフィールド

`mask` エントリはこれらの optional フィールドを受け入れます。`extract` または `decode` がない場合、Claude Code はファイル全体の内容を 1 つのセンチネルで置き換えます。ファイルシステム分離がオンの macOS では、Claude Code は `extract` または `decode` が実行される前に `mask` エントリを `deny` として適用します。[認証情報ファイルをマスクする](/docs/ja/sandboxing#mask-credential-files)を参照してください。

| フィールド | 型 | 何をするか |
| :- | :- | :- |
| `extract` | 文字列。少なくとも 1 つのキャプチャグループを持つ正規表現 | 各一致のグループ 1 でキャプチャされたテキストのみをマスクするため、ファイルの残りは解析可能なままです。`decode` も設定されている場合、Claude Code は各キャプチャを置き換える前に、可能な JWT として確認します。v2.1.221 以降が必要です |
| `onExtractNoMatch` | `"warn"`、`"deny"`、または `"error"`。デフォルト `"warn"` | `extract` または `decode` がマスクするものを見つけられない場合に何が起こるか。`warn` はファイルをサンドボックス内で読み取り可能なままにし、`deny` は読み取り不可にし、`error` は設定を修正するまでサンドボックスセットアップを停止します。Claude Code は、読み取りブロックが強制されない場合、`deny` を `error` として扱います。[ファイルシステム分離を無効にする](/docs/ja/sandboxing#disable-filesystem-isolation)か、[`sandbox.filesystem.allowRead`](#sandbox-filesystem-allowread)エントリがパスを再度開く場合です。v2.1.221 以降が必要です。`decode` ケースには v2.1.224 以降が必要です |
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

`name` は文字または下線で始まり、文字、数字、下線のみを含む必要があります。Claude Code はセッションが読み込むすべての設定スコープから配列をマージし、同じ変数が両方のモードで表示される場合は `deny` を適用します。[認証情報を保護する](/docs/ja/sandboxing#protect-credentials)は、`--setting-sources` で除外するソースから何が引き続き適用されるかをカバーしています。

`mask` 置換はサンドボックスプロキシを通じてのみ実行されるため、[`sandbox.network.tlsTerminate`](#sandbox-network-tlsterminate)、または プレーン HTTP テストネットワークの場合は [`allowPlaintextInject`](#sandbox-credentials-allowplaintextinject) を設定します。[認証情報をマスクする](/docs/ja/sandboxing#mask-credentials)を参照してください。Claude Code は `deny` エントリの `mask` フィールドを受け入れますが、無視します。

#### 環境変数のマスクフィールド

`mask` エントリはこれらの optional フィールドを受け入れます。`extract` または `decode` がない場合、Claude Code は全体の値を 1 つのセンチネルで置き換えます。`extract` と `decode` は同じエントリで組み合わせることはできません。

| フィールド | 型 | 何をするか |
| :- | :- | :- |
| `extract` | 文字列。少なくとも 1 つのキャプチャグループを持つ正規表現 | 各一致のグループ 1 でキャプチャされたテキストのみをマスクします。例えば、`DATABASE_URL` 接続文字列内のパスワード。値の残りは解析可能なままです。v2.1.224 以降が必要です |
| `onExtractNoMatch` | `"warn"`、`"deny"`、または `"error"`。デフォルト `"warn"`。`decode` を持つエントリでは、`"warn"` のみが受け入れられます | `extract` が何も一致しない場合に何が起こるか。`warn` は変数をマスクなしで渡し、`deny` はサンドボックス内でそれをアンセットし、`error` は設定を修正するまでサンドボックスセットアップを停止します。v2.1.224 以降が必要です |
| `decode` | 文字列 `"jwt"` | 全体の値が JWT であることを検証し、構造的に有効な偽のトークンで置き換えます。サンドボックス内のコードがトークンをデコードし続けるようにします。プロキシは出力時に全体の実際のトークンを置き換えます。検証されない値は警告とともにマスクなしで渡されます。v2.1.224 以降が必要です |
| `maskClaims` | 文字列の配列。少なくとも 1 つのクレーム名。`decode` が必要 | デコードされた JWT 内の名前付きトップレベルペイロードクレームのみをマスクし、変更されたペイロードの周りにトークンを再構築します。他のクレームは読み取り可能なままです。名前付きクレームが一致しない場合、変数は警告とともにマスクなしで渡されます。v2.1.224 以降が必要です |
| `injectHosts` | 文字列の配列。各ホストは [`sandbox.network.allowedDomains`](#sandbox-network-alloweddomains) も認めます | サンドボックスプロキシが実際の値を置き換えるホストを絞ります。未設定の場合、プロキシは `sandbox.network.allowedDomains` のすべてのホストへのリクエストで置き換えます。IPv6 宛先を裸の圧縮アドレスとして書き込みます。例えば、`"::1"`。括弧形式ではなく。[`injectHosts` の IPv6 宛先](/docs/ja/sandboxing#ipv6-destinations-in-injecthosts)を参照してください |

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

マスクされた環境変数をグループ化して、認証情報が非標準の名前の変数に存在する場合、[SigV4 再署名](/docs/ja/sandboxing#re-sign-aws-requests)用に 1 つの AWS 認証情報を形成します。Claude Code は、従来の `AWS_ACCESS_KEY_ID`、`AWS_SECRET_ACCESS_KEY`、`AWS_SESSION_TOKEN` トリオを全体の値をマスクする場合、自動的にリンクするため、他の名前の場合にのみこのキーが必要です。Claude Code v2.1.224 以降が必要です。

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

サンドボックスプロキシが [再署名できない](/docs/ja/sandboxing#re-sign-aws-requests)AWS リクエスト形式で何をするかを選択します：`streaming` は aws-chunked ストリーミングアップロード、`presigned` は事前署名 URL、`sigv4a` は SigV4A 非対称署名です。これは、マスクされたペアのプレースホルダーアクセスキー ID で署名されたリクエストにのみ適用されます。Claude Code v2.1.224 以降が必要です。

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

サンドボックス化されたコマンドが到達できるホスト、ポート、ソケットを制御します。サンドボックスは送信トラフィックをプロキシを通じてルーティングし、これらのリストを強制します。[ネットワーク分離](/docs/ja/sandboxing#network-isolation)を参照して、プロキシがどのように決定するか、およびいつプロンプトするかを確認してください。

* **Scope**: [`Any file`](#scopes)。`strictAllowlist`、`allowManagedDomainsOnly`、`tlsTerminate` は、それらのエントリが言うように、より少ないソースから読み取られます。
* **Type**: 以下のサブキーを含むオブジェクト
* **Default**: 未設定。ドメインは事前に許可されず、[新しい各ホストをどう扱うか](/docs/ja/sandboxing#hosts-outside-your-allowed-domains)は権限モードによって決まります

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

Claude Code は配列サブキーを設定スコープ全体でマージするため、[リポジトリロック](/docs/ja/sandboxing#repository-settings-under-an-admin-required-sandbox)が適用されない限り、プロジェクトはユーザーリストにドメインを追加できます。`WebFetch(domain:...)` 許可および拒否[権限ルール](/docs/ja/sandboxing#permission-rules)は同じ許可および拒否リストをフィードします。

### `sandbox.network.allowUnixSockets`

macOS でサンドボックス化されたコマンドが接続できる Unix ソケットパスをリストします。Claude Code は Linux と WSL2 でこのリストを無視します。seccomp フィルタはソケットパスを検査できません。代わりに [`allowAllUnixSockets`](#sandbox-network-allowallunixsockets) を使用します。

* **Scope**: [`Any file`](#scopes)（[プロジェクト設定とローカル設定には制限あり](/docs/ja/sandboxing#repository-settings-under-an-admin-required-sandbox)）
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

ソケットパスは広いアクセスを許可できます。たとえば、`/var/run/docker.sock` を許可すると、サンドボックス化されたコマンドが Docker デーモンを制御できます。[セキュリティ制限](/docs/ja/sandboxing#security-limitations)を参照してください。

### `sandbox.network.allowAllUnixSockets`

サンドボックス化されたコマンドがすべての Unix ソケットに接続できるようにします。Linux と WSL2 では、サンドボックスの [seccomp フィルタ](/docs/ja/sandboxing#set-up-linux-and-wsl2) は `socket(AF_UNIX, ...)` 呼び出しをブロックするため、これは Unix ソケットを許可する唯一の方法です。フィルタが不足している場合（`/sandbox` がその Dependencies タブで報告する場合）、サンドボックスは Unix ソケット呼び出しをブロックしません。[Linux と WSL2 をセットアップする](/docs/ja/sandboxing#set-up-linux-and-wsl2)を参照して、フィルタがどこから来るかを確認してください。

* **Scope**: [`Any file`](#scopes)（[プロジェクト設定とローカル設定には制限あり](/docs/ja/sandboxing#repository-settings-under-an-admin-required-sandbox)）
* **Type**: ブール値
  * `true`: サンドボックス化されたコマンドはすべての Unix ソケットに接続できます
  * `false`: サンドボックスは Unix ソケット接続をブロックします：macOS では `allowUnixSockets` のパスを除き、Linux と WSL2 ではフィルタが存在する場合は seccomp フィルタを通じて
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

macOS でサンドボックス化されたコマンドがネットワークポートでリッスンし（開発サーバーの起動など）、localhost の任意のポートに接続できるようにします。ループバック以外のアドレスでリッスンするコマンドは、他のマシンからの接続を受け付けます。Linux と WSL2 では各サンドボックス化されたコマンドが独自のループバックインターフェースを持つため、このキーは効果がありません。Linux または WSL2 からホスト上のサーバーに到達するには、[コマンドが localhost 上のサーバーに到達できない](/docs/ja/sandboxing#a-command-fails-to-reach-a-server-on-localhost)を参照してください。

* **Scope**: [`Any file`](#scopes)（[プロジェクト設定とローカル設定には制限あり](/docs/ja/sandboxing#repository-settings-under-an-admin-required-sandbox)）
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

* **Scope**: [`Any file`](#scopes)（[プロジェクト設定とローカル設定には制限あり](/docs/ja/sandboxing#repository-settings-under-an-admin-required-sandbox)）
* **Type**: 文字列の配列。各サービス名。単一の末尾 `*` はプレフィックスと一致し、`"*"` だけはすべてのサービスと一致します
* **Default**: 未設定

これにより、`com.apple.coresimulator.` プレフィックスの下のすべてのサービスが許可されます：

```json settings.json theme={null}
{
  "sandbox": {
    "network": {
      "allowMachLookup": ["com.apple.coresimulator.*"]
    }
  }
}
```

### `sandbox.network.allowedDomains`

サンドボックス化されたコマンドからの送信トラフィック用にドメインを事前に許可するため、サンドボックスはそれらについてプロンプトしません。`*.example.com` などのワイルドカードはサブドメインと一致し、optional `:port` サフィックスはエントリを 1 つのポートに制限します。ポートなしのエントリはすべてのポートと一致します。

* **Scope**: [`Any file`](#scopes)（[プロジェクト設定とローカル設定には制限あり](/docs/ja/sandboxing#repository-settings-under-an-admin-required-sandbox)）。[`allowManagedDomainsOnly`](#sandbox-network-allowmanageddomainsonly)が設定されている場合、管理設定のみ。
* **Type**: 文字列の配列。各ドメイン、ワイルドカードパターン、または IP リテラル。optional `:port` サフィックス付き
* **Default**: 未設定。[新しい各ホストをどう扱うか](/docs/ja/sandboxing#hosts-outside-your-allowed-domains)は権限モードによって決まります

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

IPv6 リテラルを括弧で囲んで書き込みます。optional ポート付き：`"[::1]"` はすべてのポートを許可し、`"[::1]:443"` は 1 つのポートを許可します。括弧形式には Claude Code v2.1.229 以降が必要です。[ドメインリストの IPv6 アドレス](/docs/ja/sandboxing#ipv6-addresses-in-domain-lists)を参照してください。

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

Claude Code はセッションが読み込むすべての設定ソースからこのリストをマージします。`allowManagedDomainsOnly` が設定されている場合でも、開発者は常に拒否リストを厳しくできます。IPv6 リテラルについては、[ドメインリストの IPv6 アドレス](/docs/ja/sandboxing#ipv6-addresses-in-domain-lists)を参照してください。

完全修飾ドメイン名をマークする末尾ドット（`example.com.` など）で書き込まれたエントリは、`example.com` と同じ接続をブロックします。

### `sandbox.network.strictAllowlist`

許可リスト外のホストへのサンドボックス化されたコマンドのアクセスを、承認を求めるプロンプトを表示する代わりに拒否します。許可リストは [`allowedDomains`](#sandbox-network-alloweddomains) と `WebFetch(domain:...)` 許可ルールからのドメイン、または [`allowManagedDomainsOnly`](#sandbox-network-allowmanageddomainsonly) が設定されている場合は管理設定エントリのみです。リポジトリのエントリについては、[管理者必須のサンドボックスなしで適用されるロック](/docs/ja/sandboxing#locks-that-apply-without-an-admin-required-sandbox)を参照してください。Claude Code v2.1.219 以降が必要です。

* **Scope**: [`User or managed`](#scopes)。リポジトリはそれをオンまたはオフにできません。
* **Type**: ブール値
  * `true`: Claude Code は許可リスト外のホストへのサンドボックス化されたコマンドアクセスを拒否します
  * `false`: 別の信頼できる設定ファイルが `true` を設定しない限り、Claude Code は許可リスト外のホストを即座に拒否するのではなく、権限モードに応じて判断します：auto モードではコマンドの[コマンドごとの許可ドメイン](/docs/ja/sandboxing#per-command-allowed-domains-in-auto-mode)に対してホストをチェックし、`dontAsk` モードでは拒否し、`bypassPermissions` モードおよびバイパスが利用可能なインタラクティブターミナルの plan モードセッションでは許可し、それ以外の場合はユーザーに確認します
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

Claude Code はサンドボックス化されたコマンドのみに対してこれを強制します。`WebFetch` などのインプロセスツールは引き続き[権限ルール](/docs/ja/sandboxing#permission-rules)に従います。尊重されるソースのいずれかが `true` に設定する場合、それはオンのままです。[ネットワーク分離](/docs/ja/sandboxing#network-isolation)を参照してください。Claude Code v2.1.219 以降が必要です。

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

キーが `true` の間、サンドボックスは[管理者必須](/docs/ja/sandboxing#repository-settings-under-an-admin-required-sandbox)となり、[プロキシポート](#sandbox-network-httpproxyport)を設定できるのは管理設定のみになります。

拒否されたドメインは引き続きセッションが読み込むすべてのソースからマージされます。[ポリシーの拡大を開発者に防止させる](/docs/ja/sandboxing#keep-developers-from-widening-the-policy)を参照してください。

### `sandbox.network.httpProxyPort`

Claude Code が実行するものの代わりに、独自の HTTP プロキシをサンドボックスに指定します。組織はこれを使用して、HTTPS トラフィックを検査したり、独自のフィルタリングルールを適用したり、リクエストをログに記録したりします。フィルタリングは独自のプロキシが引き継ぎ、Claude Code はそこに送信されるトラフィックにドメインリストとネットワークプロンプトを適用しなくなります。未設定の場合、Claude Code は HTTP トラフィック用に独自のプロキシを起動します。

* **Scope**: [`Any file`](#scopes)。ただし、[他のサンドボックス設定によってポートを設定できるファイルが制限される](/docs/ja/sandboxing#custom-proxy-configuration)場合を除きます
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

プロキシで SOCKS トラフィックも扱う場合は、[`socksProxyPort`](#sandbox-network-socksproxyport) も設定します。2 つのうち一方のみを設定した場合、Claude Code はもう一方のプロトコル用に引き続き独自のプロキシを実行します。[カスタムプロキシ設定](/docs/ja/sandboxing#custom-proxy-configuration)を参照してください。

### `sandbox.network.socksProxyPort`

Claude Code が実行するものの代わりに、独自の SOCKS5 プロキシをサンドボックスに指定します。フィルタリングは独自のプロキシが引き継ぎ、Claude Code はそこに送信されるトラフィックにドメインリストとネットワークプロンプトを適用しなくなります。未設定の場合、Claude Code は SOCKS トラフィック用に独自のプロキシを起動します。

* **Scope**: [`Any file`](#scopes)。ただし、[他のサンドボックス設定によってポートを設定できるファイルが制限される](/docs/ja/sandboxing#custom-proxy-configuration)場合を除きます
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

[カスタムプロキシ設定](/docs/ja/sandboxing#custom-proxy-configuration)を参照してください。

### `sandbox.network.tlsTerminate`

サンドボックスプロキシが TLS を終了して、HTTPS リクエストの内容を読み取ることができるようにします。これは実験的であり、`mask` [認証情報置換](/docs/ja/sandboxing#mask-credentials)はそれを必要とします。`{}` を設定してセッション用に一時的な認証局を生成するか、`caCertPath` と `caKeyPath` を設定して独自のものを使用します。

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

Claude Code がコンテキストに読み込む内容、コンテキスト圧縮の方法、メモリとプランの保存場所を制御します。[コンテキストの管理](/docs/ja/context-window)と[メモリ](/docs/ja/memory)を参照してください。

### `autoCompactEnabled`

コンテキストが上限に近づいたときに、Claude Code が[会話を自動的に圧縮する](/docs/ja/context-window#when-your-context-fills-up)ようにします。`/config` では **Auto-compact** として表示され、そこで切り替えるとこのキーがユーザー設定に書き込まれます。

* **スコープ**: [`Any file`](#scopes)
* **型**: ブール値
  * `true`: コンテキストが上限に近づくと、Claude Code は会話を自動的に圧縮します
  * `false`: Claude Code は自動的に圧縮しません
* **デフォルト**: `true`
* **セッションごとの上書き**: [`DISABLE_AUTO_COMPACT`](/docs/ja/env-vars) は 1 つのセッションで自動圧縮をオフにします。2 つのうちどちらかがオフにした場合、もう一方でオンに戻すことはできません

```json settings.json theme={null}
{
  "autoCompactEnabled": false
}
```

自動圧縮がオフの間も、手動の `/compact` コマンドは引き続き機能します。自動圧縮をオフにすると、[アイドル時のコンテキスト圧縮](#idlecompaction)もオフになります。

### `autoCompactWindow`

Claude Code が[自動的に圧縮する](/docs/ja/context-window#when-your-context-fills-up)前に、コンテキストウィンドウがどこまで埋まるかを設定します。

* **スコープ**: [`Any file`](#scopes)
* **型**: トークン数、`100000` から `1000000` まで。Claude Code はこの値をモデルのコンテキストウィンドウで上限設定します。各モデルのウィンドウは[モデルの概要](https://platform.claude.com/docs/en/about-claude/models/overview)に記載されています
* **デフォルト**: 未設定。この場合、Claude Code はモデルに合わせて調整されたウィンドウを選択します
* **セッションごとの上書き**: [`--autocompact`](/docs/ja/cli-reference#cli-flags) は 1 つのセッションでこのキーより優先されます。また、Claude Code が[変数の値を無視する](/docs/ja/model-config#claude_code_auto_compact_window-values)場合を除き、[`CLAUDE_CODE_AUTO_COMPACT_WINDOW`](/docs/ja/env-vars) は両方より優先されます

```json settings.json theme={null}
{
  "autoCompactWindow": 500000
}
```

[`/autocompact`](/docs/ja/commands#all-commands) コマンドは、現在のモデル用のウィンドウを [`modelSettings`](#modelsettings) の下に保存します。これは、そのモデルについて同じファイル内のこのキーより優先されます。コマンド、フラグ、変数、設定がどのように相互作用するかについては、[自動圧縮ウィンドウを設定する](/docs/ja/model-config#set-the-auto-compact-window)で説明しています。

### `autoMemoryDirectory`

[自動メモリ](/docs/ja/memory#storage-location)を、プロジェクトごとのデフォルトではなく任意のディレクトリに保存します。

* **スコープ**: [`Any file`](#scopes)
* **型**: 文字列。絶対パス、または `~/` で始まるディレクトリパス
* **デフォルト**: 未設定。この場合、Claude Code は `~/.claude/projects/<project>/memory/` を使用します

```json settings.json theme={null}
{
  "autoMemoryDirectory": "~/my-memory-dir"
}
```

クローンしたリポジトリがプロジェクト設定やローカル設定のファイルを提供できるため、これらの設定では、Claude Code は[フックと同じワークスペース信頼ルール](/docs/ja/permissions#what-runs-before-you-trust-a-folder)に従ってこのキーを適用します。

### `autoMemoryEnabled`

[自動メモリ](/docs/ja/memory#enable-or-disable-auto-memory)をオンまたはオフにします。`false` の場合、Claude は自動メモリディレクトリの読み取りも書き込みも行いません。セッション中に `/memory` で切り替えることもでき、その場合はこのキーがユーザー設定に書き込まれます。

* **スコープ**: [`Any file`](#scopes)
* **型**: ブール値
  * `true`: 未設定と同じです。`--bare`、セーフモード、`CLAUDE_CODE_DISABLE_AUTO_MEMORY` など、このキーより優先されるものがセッションでオフにしない限り、自動メモリはオンのままです
  * `false`: Claude は自動メモリディレクトリの読み取りも書き込みも行いません
* **デフォルト**: `true`
* **セッションごとの上書き**: [`CLAUDE_CODE_DISABLE_AUTO_MEMORY`](/docs/ja/env-vars) は、どちらの方向でも 1 つのセッションでこのキーより優先されます

```json settings.json theme={null}
{
  "autoMemoryEnabled": false
}
```

### `bashOutputMaxChars`

成功した Bash または PowerShell コマンドの[出力のうち、Claude がインラインで受け取る](/docs/ja/tools-reference#output-limits)文字数を設定します。出力が上限を超えると、Claude Code はそれをファイルに保存し、Claude は短いプレビューとファイルのパスを受け取ります。詳細なビルドやテストスイート全体のログなど、コマンドの出力がデフォルトを日常的に超え、Claude にファイルを開かずに読ませたい場合は、上限を引き上げてください。Claude Code v2.1.261 以降が必要です。

* **スコープ**: [`Any file`](#scopes)
* **型**: 文字数、正の整数。Claude Code は値を `4000` から `128000` の範囲に収めます
* **デフォルト**: 未設定。この場合、Claude はインラインで最大 30,000 文字を受け取ります

```json settings.json theme={null}
{
  "bashOutputMaxChars": 100000
}
```

このキーを設定すると、Claude Code は [`BASH_MAX_OUTPUT_LENGTH`](/docs/ja/env-vars) 環境変数を無視します。

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

[組織全体の CLAUDE.md をデプロイする](/docs/ja/memory#deploy-organization-wide-claude-md)を参照してください。

### `claudeMdExcludes`

Claude Code が[メモリ](/docs/ja/memory#exclude-specific-claude-md-files)を読み込む際に、特定の `CLAUDE.md` ファイルをスキップします。大規模なモノレポでは、自分の作業に関係のない他チームの CLAUDE.md ファイルをスキップするために使用します。大規模コードベースのガイドの[関係のない CLAUDE.md ファイルを除外する](/docs/ja/large-codebases#exclude-irrelevant-claude-md-files)で、このケースを詳しく説明しています。パターンは絶対ファイルパスに対してマッチします。

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

すべてのセッションと、そのセッションから Claude Code が起動するサブプロセスに環境変数を設定します。[環境変数リファレンス](/docs/ja/env-vars)にあるほとんどの変数はここに記述でき、これによって変数をすべてのセッションに適用したり、チームに展開したりできます。プロジェクト設定とローカル設定では、[一部の変数](#variables-claude-code-ignores-in-env)を設定できません。

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

* ここで指定した値は、シェルでエクスポートされた同じ変数を上書きします。複数の設定ファイルが同じ変数を設定している場合は、[優先順位が最も高い](/docs/ja/settings#settings-precedence)ものが適用されます。プロジェクト設定とローカル設定の例外は、[Claude Code が `env` で無視する変数](#variables-claude-code-ignores-in-env)に記載しています。
* Claude Desktop アプリまたは[セルフホスト環境](/docs/ja/self-hosted-environments)のランナーがセッションを開始する場合は、代わりにそれが構築する起動環境が優先されます。起動環境がすでに設定している変数については、Claude Code はどの設定ファイルの `env` の値も無視します。無視された各変数は[デバッグログ](/docs/ja/debug-your-config)に記載されます。
* シェルのエクスポートを取り消すには、変数を `""` に設定します。Claude Code はプロバイダーの選択において空の値を未設定として扱い、サブプロセスは空の値を継承します。
* ここで設定した `NO_COLOR` と `FORCE_COLOR` は、サブプロセスにのみ反映されます。Claude Code 自体のインターフェースのカラーを変更するには、`claude` を起動する前にシェルで設定してください。
* ここに記述した値は設定ファイル内のプレーンテキストであり、Claude Code が起動するすべてのサブプロセスに渡されます。ローテーションする OTLP ベアラートークンには [`otelHeadersHelper`](#otelheadershelper) を、API の認証情報には [`apiKeyHelper`](#apikeyhelper) を使用してください。

#### Claude Code が `env` の値を適用するタイミング

* ユーザー設定、`--settings`、管理設定からの値: 起動時、および保存された変更によってマージ後の `env` が変わったときに実行中のセッションで再度適用されます。
* プロジェクト設定とローカル設定からの値: ワークスペースを信頼した後、または信頼ダイアログを表示しない `-p` モードでは起動時に適用され、保存された変更によってマージ後の `env` が変わったときに再度適用されます。
* モデルの選択、タイムアウトと制限、機能の切り替えなど、Claude Code が安全と分類する変数: [プロジェクト設定とローカル設定で設定できない変数](#variables-claude-code-ignores-in-env)を除き、起動時にすべての設定ファイルから適用されます。
* v2.1.246 以降で [`/cd` でセッションを移動した](/docs/ja/permissions#move-the-session-to-another-directory)後: 以前のディレクトリの値に加えて、新しいディレクトリのプロジェクトとローカルの `env` の値が適用されます。

#### Claude Code が `env` で無視する変数

* プロジェクト設定とローカル設定では、チェックアウトしたリポジトリが制御すべきでない変数を設定できません。これらはシェル、ユーザー設定、または管理設定で設定してください。テレメトリをオフにするいくつかの値を除き、Claude Code はこれらをそれぞれ破棄し、`claude --debug` で確認できる警告をログに記録します。対象には次のものが含まれます。

  * Claude Code が自身のファイルを保存または書き込む場所を選択する変数: `CLAUDE_CONFIG_DIR`、`CLAUDE_CODE_TMPDIR`、およびオペレーティングシステムのディレクトリ変数（`HOME`、`TMPDIR`、`TMP`、`TEMP`、`XDG_*` ファミリーなど）。
  * Claude Code が起動するプロセスのプログラムやマシン全体の設定を選択する Windows の変数（`SystemRoot`、`ComSpec`、`ProgramData`、`LOCALAPPDATA`、`PATHEXT`、`PSModulePath`、`ProgramFiles` ファミリーなど）。
  * セッションの内容をエクスポートする変数: [`OTEL_LOG_RAW_API_BODIES`](/docs/ja/env-vars#variables)、および詳細なベータトレースのペアである `ENABLE_BETA_TRACING_DETAILED` と `BETA_TRACING_ENDPOINT`。
  * テレメトリをオンにする、送信先を選択する、またはキャプチャする内容を選択する [OpenTelemetry エクスポーター](/docs/ja/monitoring-usage)の変数:

    * `CLAUDE_CODE_ENABLE_TELEMETRY`、および拡張テレメトリのベータのペアである `CLAUDE_CODE_ENHANCED_TELEMETRY_BETA` と `ENABLE_ENHANCED_TELEMETRY_BETA`
    * エクスポーターのセレクターである `OTEL_LOGS_EXPORTER`、`OTEL_METRICS_EXPORTER`、`OTEL_TRACES_EXPORTER`
    * 内容に関する変数である `OTEL_LOG_USER_PROMPTS`、`OTEL_LOG_ASSISTANT_RESPONSES`、`OTEL_LOG_TOOL_CONTENT`、`OTEL_LOG_TOOL_DETAILS`
    * 名前が `_ENDPOINT`、`_HEADERS`、`_PROTOCOL`、`_CERTIFICATE`、`_CLIENT_KEY`、または `_INSECURE` で終わる `OTEL_EXPORTER_OTLP_*` 変数（汎用形式とシグナルごとの形式の両方。`OTEL_EXPORTER_OTLP_ENDPOINT` や `OTEL_EXPORTER_OTLP_METRICS_HEADERS` など）
    * `OTEL_EXPORTER_PROMETHEUS_HOST` と `OTEL_EXPORTER_PROMETHEUS_PORT`

    プロジェクト設定とローカル設定から引き続き適用されるのは、何かをオフにする次の値のみです。3 つのエクスポーターセレクターに対する `none`、および `OTEL_LOG_USER_PROMPTS`、`OTEL_LOG_TOOL_CONTENT`、`OTEL_LOG_TOOL_DETAILS` に対する `0` などのオフの値です。このような値はユーザー設定にある同じ変数を上書きしますが、Claude Code を起動した環境、`--settings` ファイル、または管理設定で設定された変数は上書きしません。

    プロジェクトまたはローカルの設定ファイルがこのグループの変数を設定している場合、ローカルの対話型セッションでは起動時に通知が表示されます。`/status` または `claude doctor` を実行すると、Claude Code がどの変数を無視し、どの変数がテレメトリをオフにしたかを確認できます。どちらも名前のみを表示し、値は表示しません。`-p` による非対話型の実行や Agent SDK のセッションでは通知が表示されないため、アップグレード後にコレクターが引き続きデータを受信していることを確認してください。受信していない場合は、ユーザー設定、管理設定、ジョブの環境、または `--settings` で渡すファイルで変数を設定してください。

    プロジェクト設定とローカル設定でこのグループを無視する動作には、Claude Code v2.1.282 以降が必要です。
  * Claude Code の起動方法や同期方法を変更する変数（`CLAUDE_CODE_PROCESS_WRAPPER`、`CLAUDE_CODE_SYNC_SKILLS`、`CLAUDE_CODE_SYNC_PLUGINS`、`CLAUDE_CODE_PLUGIN_CACHE_DIR`、`CLAUDE_CODE_PLUGIN_SEED_DIR` など）。
  * 応答のないダイアログのタイマーを設定する [`CLAUDE_CODE_USER_DIALOG_TIMEOUT_MS`](/docs/ja/env-vars#variables)。
  * 添付ファイルの処理をオフにする [`CLAUDE_CODE_DISABLE_ATTACHMENTS`](/docs/ja/env-vars#variables)。
  * Claude Code がファイルやディレクトリの `@` メンションを展開しないようにする [`CLAUDE_CODE_DISABLE_FILE_MENTIONS`](/docs/ja/env-vars#variables)。

  v2.1.251 より前は、プロジェクト設定とローカル設定でも、このリストのうち Claude Code がファイルを書き込む場所を選択する変数やセッションの内容をエクスポートする変数を設定できました（`HOME` と `XDG_CONFIG_HOME` を除く）。v2.1.290 より前は、ダイアログのタイマー変数と `CLAUDE_CODE_DISABLE_ATTACHMENTS` も設定できました。
* `CLAUDE_CODE_REMOTE` や `CLAUDE_CODE_ACCOUNT_UUID` など、Claude Code のホスティング環境が所有する ID 変数は、すべてのファイルで無視されます。
* Claude Code 自身がエクスポートする [`CLAUDE_CODE_MESSAGING_SOCKET` と `CLAUDE_CODE_MESSAGING_TOKEN`](/docs/ja/env-vars#variables) は、すべてのファイルで無視されます。ソケット変数を無視する動作には Claude Code v2.1.224 以降が、トークンを無視する動作には v2.1.228 以降が必要です。
* Claude Code が起動環境からのみ読み取る [`CLAUDE_CODE_PROJECT_DIR_NAME`](/docs/ja/sessions#name-the-project-directory-yourself) は、すべてのファイルで無視されます。v2.1.234 以降が必要です。
* Claude Code が起動環境からのみ読み取る [`CLAUDE_CODE_RESTRICTED`](/docs/ja/env-vars#variables) は、すべてのファイルで無視されます。
* Claude Code が起動環境からのみ読み取る [`CLAUDE_CODE_DISABLE_POWERSHELL_CMD_RM_DENY`](/docs/ja/env-vars#variables) は、すべてのファイルで無視されます。この変数には Claude Code v2.1.283 以降が必要です。
* Claude Code が起動環境からのみ読み取る [`CLAUDE_CODE_DISABLE_DANGEROUS_RM_TIMEOUT`、`CLAUDE_CODE_DISABLE_SUBSTITUTION_RM_PROMPT`、`CLAUDE_CODE_DISABLE_INLINE_SHELL_RM_PROMPT`、`CLAUDE_CODE_DISABLE_MOUNTED_DRIVE_RM_PROMPT`](/docs/ja/env-vars#variables) は、すべてのファイルで無視されます。

### `fileCheckpointingEnabled`

[`/rewind`](/docs/ja/checkpointing) で復元できるよう、Claude Code が各編集の前にファイルのスナップショットを取るようにします。`/config` では **Rewind code (checkpoints)** として表示され、そこで切り替えるとこのキーがユーザー設定に書き込まれます。

* **スコープ**: [`Any file`](#scopes)
* **型**: ブール値
  * `true`: `/rewind` で復元できるよう、Claude Code は各編集の前にファイルのスナップショットを取ります
  * `false`: Claude Code はファイルのスナップショットを取らないため、`/rewind` で復元できません
* **デフォルト**: `true`
* **セッションごとの上書き**: [`CLAUDE_CODE_DISABLE_FILE_CHECKPOINTING`](/docs/ja/env-vars) は 1 つのセッションでチェックポイント機能をオフにします。2 つのうちどちらかがオフにした場合、もう一方でオンに戻すことはできません

```json settings.json theme={null}
{
  "fileCheckpointingEnabled": false
}
```

`-p` の実行や Agent SDK のセッションでは、Claude Code はこのキーを無視します。SDK では `enableFileCheckpointing` オプションでチェックポイント機能をオンにし、単純な `-p` の実行では `CLAUDE_CODE_ENABLE_SDK_FILE_CHECKPOINTING=true` が必要です。[Agent SDK のファイルチェックポイント機能](/docs/ja/agent-sdk/file-checkpointing)を参照してください。

### `idleCompaction`

アイドル時のコンテキスト圧縮は、ユーザーが離席している長い会話を、そのプロンプトキャッシュの有効期限が切れる少し前に[圧縮](/docs/ja/context-window#what-survives-compaction)します。これにより、次のメッセージでは会話全体ではなく要約が送信されます。戻ってくると、会話に `Compacted while idle, before the prompt cache expired` で始まる行が表示されます。

アイドル時のコンテキスト圧縮は、次のすべての条件を満たす会話に対してデフォルトでオンになっています。

* **セッション**: 対話型のターミナルセッションを使用している
* **プロンプトキャッシュ**: 会話が [1 時間のプロンプトキャッシュ TTL](/docs/ja/prompt-caching#which-ttl-each-request-gets) を使用している
* **機能フラグ**: Claude Code が [Anthropic から機能フラグを取得](/docs/ja/env-vars#features-that-need-feature-flag-fetching)できる
* **サイズ**: 会話のコンテキストがトークンのしきい値に達している。しきい値はデフォルトの 200,000 から[変更](#change-the-idle-compaction-threshold)できます
* **アイドル時間**: 最後のリクエストから約 54 分が経過しており、その時点でコンピューターがスリープしていない

アイドル時のコンテキスト圧縮をオフにするには、このキーを `false` に設定します。

* **スコープ**: [`Any file`](#scopes)
* **型**: ブール値
  * `true`: Claude Code は条件を満たすアイドル状態の会話を圧縮します
  * `false`: セッションがアイドル状態の間、Claude Code は圧縮しません
* **デフォルト**: `true`
* **セッションごとの上書き**: [`DISABLE_AUTO_COMPACT`](/docs/ja/env-vars) は、自動圧縮とともにアイドル時のコンテキスト圧縮もオフにします

```json settings.json theme={null}
{
  "idleCompaction": false
}
```

セッション内からアイドル時のコンテキスト圧縮をオフまたはオンにするには、`/config` を実行して **Idle compaction** の行を変更します。選択内容はユーザー設定に保存され、すぐに適用されます。この行には Claude Code v2.1.302 以降が必要です。これらのバージョンを実行していて `/config` にこの行が表示されない場合は、次の原因を確認してください。

* **別の設定ソースがキーを設定している**: 管理設定、`--settings` フラグ、またはプロジェクトやローカルの設定ファイルの値がユーザー設定を上書きしています。代わりにそのソースでキーを変更してください
* **機能フラグが利用できない**: Claude Code が [Anthropic から機能フラグを取得](/docs/ja/env-vars#features-that-need-feature-flag-fetching)できない場合、アイドル時のコンテキスト圧縮は実行されないため、オフにする対象がありません

このキーには Claude Code v2.1.290 以降が必要です。このキーを無視する以前のバージョンでは、[`autoCompactEnabled`](#autocompactenabled) をオフにしてアイドル時のコンテキスト圧縮を停止してください。

#### アイドル時のコンテキスト圧縮のしきい値を変更する

[`CLAUDE_CODE_IDLE_COMPACT_MIN_TOKENS`](/docs/ja/env-vars) に、アイドル時のコンテキスト圧縮が適用されるまでに会話のコンテキストが到達する必要のあるトークン数を設定します。正の整数を使用してください。`100000` 未満の値は、最小のしきい値である `100000` に引き上げられます。

デフォルトでは、200K のコンテキストウィンドウを使用する会話は 200,000 トークンに達する前に自動圧縮されます。この例では、しきい値を 150,000 に下げて、そうした会話が対象になるようにします。

```json settings.json theme={null}
{
  "env": {
    "CLAUDE_CODE_IDLE_COMPACT_MIN_TOKENS": "150000"
  }
}
```

### `plansDirectory`

[plan モード](/docs/ja/permission-modes#analyze-before-you-edit-with-plan-mode)で Claude Code が書き込むプランファイルの保存場所を選択します。Claude Code はプロジェクトルートを基準にパスを解決します。

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

Claude は各ターンで、説明付きの[スキルの一覧](/docs/ja/skills#skill-descriptions-are-cut-short)を参照します。Claude Code はその一覧をコンテキストウィンドウの一定割合に制限します。一覧が上限を超えると、Claude Code はすべてのスキルの名前を保持しつつ、使用頻度の低いスキルの説明を削除します。そのため、Claude はそれらのスキルを引き続き呼び出せますが、自発的に選択する可能性は低くなります。ターンごとのコンテキスト消費が増える代わりに、より多くの説明を表示し続けたい場合は、このキーの値を引き上げてください。

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

Claude は各ターンで、各スキルの `description` と `when_to_use` のテキストを示す[スキルの一覧](/docs/ja/skills#skill-descriptions-are-cut-short)を参照します。このキーは、Claude Code がスキルごとに表示するそのテキストの文字数を制限します。これより長いテキストは上限で切り詰められます。

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
> v2.1.277 で、このキーがサイズを決めていた `TaskOutput` ツールとともに削除されました。現在のバージョンでは設定しても効果はありません。Claude は代わりに `Read` でバックグラウンドタスクの[出力ファイル](/docs/ja/tools-reference#background-commands)を読み取ります。

v2.1.276 までは、Claude が `TaskOutput` ツールでタスクを読み取る際にインラインで受け取る[バックグラウンドタスクの](/docs/ja/tools-reference#background-commands)出力の文字数を、このキーに設定していました。

## インターフェースとターミナル

ターミナルでの Claude Code の見た目と動作を変更します。テーマ、エディターモード、ステータスライン、スピナー、セッション内の通知、アクセシビリティが対象です。[ターミナル設定](/docs/ja/terminal-config)を参照してください。

### `askUserQuestionTimeout`

回答されていない [`AskUserQuestion`](/docs/ja/tools-reference) ダイアログを、一定時間操作がなかった後に自動で続行させ、その時点で選択済みのオプションを送信します。席を外している間も Claude に作業を続けさせたい場合に設定します。デフォルトでは、質問は回答されるまで待機します。タイマーが一時停止する場合や開始しない場合については、[質問の自動続行タイムアウト](/docs/ja/tools-reference#question-auto-continue-timeout)を参照してください。

* **スコープ**: [`User or managed`](#scopes)
* **型**: 文字列。`"60s"`、`"5m"`、`"10m"`、`"never"` のいずれか
* **デフォルト**: `"never"`

```json settings.json theme={null}
{
  "askUserQuestionTimeout": "5m"
}
```

`/config` では **Question auto-continue timeout** として表示され、このキーをユーザー設定に書き込みます。管理設定または `--settings` フラグでこのキーが設定されている間、Claude Code はこの行を非表示にします。

### `autoContinueAtUsageLimit`

claude.ai の使用制限によってセッションが停止した後、開いているセッションで待機し、リセット後にタスクを自動的に続行します。[自動続行をオフにする](/docs/ja/interactive-mode#turn-automatic-continue-off)を参照してください。Claude Code v2.1.234 以降が必要です。

* **スコープ**: [`User or managed`](#scopes)。ユーザー設定、`--settings`、管理設定からのみ読み取られます。これらのいずれでもキーが設定されていない場合、プロジェクト設定ファイルまたはローカル設定ファイルでこのキーを設定すると、無視されるのではなく機能がオフになります。
* **型**: Boolean
  * `true`: claude.ai の使用制限によってセッションが停止した後、Claude Code は開いているセッションで待機し、リセット後にタスクを自動的に続行します
  * `false`: Claude Code は自動的には待機を開始しません。使用制限のオプションメニューから[自分で待機を開始する](/docs/ja/interactive-mode#start-a-wait-yourself)ことは引き続き可能です
* **デフォルト**: `true`

```json settings.json theme={null}
{
  "autoContinueAtUsageLimit": false
}
```

`/config` では **Continue automatically at usage limit** として表示され、このキーをユーザー設定に書き込みます。管理設定または `--settings` フラグでこのキーが設定されている間、Claude Code はこの行を非表示にします。

### `autoScrollEnabled`

[フルスクリーンレンダリング](/docs/ja/fullscreen)で、新しい出力に追従して会話の末尾までスクロールします。オフにすると、Claude が作業を続けている間もスクロールした位置にとどまります。権限プロンプトは引き続きスクロールして表示領域に入ります。

* **スコープ**: [`Any file`](#scopes)
* **型**: Boolean
  * `true`: 会話は新しい出力に追従して末尾までスクロールします
  * `false`: Claude が作業を続けている間も、スクロールした位置にとどまります。権限プロンプトは引き続きトランスクリプトの下に表示されます
* **デフォルト**: `true`

```json settings.json theme={null}
{
  "autoScrollEnabled": false
}
```

フルスクリーンレンダリングがオンの場合、`/config` では **Auto-scroll** として表示され、このキーをユーザー設定に書き込みます。

### `axScreenReader`

スクリーンリーダーに適した出力、つまり装飾的な枠線やアニメーションのないフラットなテキストをレンダリングします。スクリーンリーダーモードはクラシックレンダラーを使用するため、有効な間は `tui` 設定は効果がありません。アタッチされた[バックグラウンドセッション](/docs/ja/agent-view)は引き続きフルスクリーンでレンダリングされます。

* **スコープ**: [`Any file`](#scopes)
* **型**: Boolean
  * `true`: Claude Code はクラシックレンダラーを使用し、装飾的な枠線やアニメーションのないフラットなテキストをレンダリングします
  * `false`: Claude Code は通常どおりレンダリングします
* **デフォルト**: 未設定。スクリーンリーダーモードはオフです
* **セッションごとの上書き**: 1 つのセッションについては、[`--ax-screen-reader`](/docs/ja/cli-reference#cli-flags) が [`CLAUDE_AX_SCREEN_READER`](/docs/ja/env-vars) より優先され、どちらもこのキーより優先されます

```json settings.json theme={null}
{
  "axScreenReader": true
}
```

### `bashEditDiffEnabled`

Bash コマンドの実行中に Git リポジトリ内のどのファイルが変更されたかを Claude Code が記録するかどうかを選択します。記録する場合、コマンドの後にターミナルでその差分が表示され、[PostToolUse Bash フック](/docs/ja/hooks#bash)は変更されたファイルのリストを受け取ります。

リストに含まれるファイルが、必ずしもそのコマンドによって変更されたものとは限りません。コマンドの実行中に別のプログラムや別の Bash 呼び出しが行った変更も含まれることがあります。

すべての権限モードで記録するには、キーを `true` に設定します。Claude Code v2.1.269 以降が必要です。

* **スコープ**: [`User or managed`](#scopes)。`true` はユーザー設定、`--settings` で渡された JSON、または[管理設定](/docs/ja/managed-settings)からのものだけが有効になるため、リポジトリの `.claude/settings.json` や `.claude/settings.local.json` にある `true` では記録をオンにできません。いずれかのリポジトリファイルにある `false` は、[優先順位のより高い](/docs/ja/settings#settings-precedence)ファイルで `true` が設定されていない限り、記録をオフにします。
* **型**: Boolean
* **デフォルト**: 未設定。Claude Code は、auto モードと `bypassPermissions` モードにおいて、Bash を通じてファイルを編集するよう Claude に指示した場合に変更を記録します
* **セッションごとの上書き**: 1 つのセッションについては、[`CLAUDE_CODE_BASH_EDIT_DIFF`](/docs/ja/env-vars) がこのキーより優先されます

```json settings.json theme={null}
{
  "bashEditDiffEnabled": true
}
```

### `companyAnnouncements`

起動時に組織からのお知らせをユーザーに表示します。複数指定した場合、Claude Code はセッションごとにランダムに 1 つを選びます。ユーザーが初めて起動したときは最初のエントリを表示します。

* **スコープ**: [`Any file`](#scopes)
* **型**: 文字列の配列
* **デフォルト**: 未設定。お知らせは表示されません

```json settings.json theme={null}
{
  "companyAnnouncements": [
    "Welcome to Acme Corp! Review our code guidelines at docs.example.com"
  ]
}
```

### `defaultShell`

入力ボックスで [`!` プレフィックス](/docs/ja/interactive-mode#shell-mode-with-prefix)を付けて入力したシェルコマンド、つまり Claude Code が直接実行してセッションに追加するコマンドを、Bash と PowerShell のどちらで実行するかを選択します。

`"powershell"` は [PowerShell ツール](/docs/ja/tools-reference#powershell-tool)がオンの場合にのみ機能します。このツールは、Git Bash のない Windows ではデフォルトでオンになり、Git Bash のある Windows では claude.ai アカウントと Console アカウントの場合にデフォルトでオンになります。Amazon Bedrock、Google Cloud の Agent Platform、Microsoft Foundry のセッション、および macOS、Linux、WSL では、`CLAUDE_CODE_USE_POWERSHELL_TOOL=1` を設定してツールをオンにします。この変数を `0` に設定するとツールがオフになります。

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

指定したシェルが利用できない場合、Claude Code はもう一方を使用します。PowerShell ツールがオフの場合 `"powershell"` は Bash にフォールバックし、Bash がインストールされていない場合 `"bash"` は PowerShell にフォールバックします。

### `dialogExpiry`

Claude Code が Remote Control や SDK ホストなどの[リモートクライアントに転送する](/docs/ja/remote-control#limitations)ダイアログ、および[保留されたクロスセッションメッセージ](/docs/ja/cross-session-messaging#control-inbound-messages)の承認ダイアログの期限を設定します。Claude Code v2.1.236 以降では、ターミナルに誰もいない可能性のあるセッションにおいて、セッション途中の [Fable 使用クレジットの同意プロンプト](/docs/ja/model-config#fable-and-usage-credits)にも同じ期限が適用されます。期限までに回答がない場合、Claude Code はダイアログをキャンセルし、何もしないデフォルトの動作で続行します。Claude Code v2.1.224 以降が必要です。

* **スコープ**: [`User or managed`](#scopes)
* **型**: 文字列。`"60s"`、`"5m"`、`"10m"`、または期限を無効にする `"never"` のいずれか
* **デフォルト**: `"5m"`
* **セッションごとの上書き**: 1 つのセッションについては、[`CLAUDE_CODE_USER_DIALOG_TIMEOUT_MS`](/docs/ja/env-vars) がこのキーより優先されます

```json settings.json theme={null}
{
  "dialogExpiry": "10m"
}
```

権限プロンプトと [`AskUserQuestion`](/docs/ja/tools-reference#askuserquestion-tool-behavior) の質問は独自のフローを使用するため、この期限の対象にはなりません。`/config` では **Dialog expiry** として表示され、このキーをユーザー設定に書き込みます。この行には Claude Code v2.1.232 以降が必要で、管理設定または `--settings` フラグでこのキーが設定されている間、Claude Code はこの行を非表示にします。

### `editorMode`

入力プロンプトのキーバインドモードを選択します。

* **スコープ**: [`Any file`](#scopes)
* **型**: 文字列。次のいずれか:
  * `"normal"`: プロンプト入力での標準的なキーバインド
  * `"vim"`: NORMAL、INSERT、VISUAL モードを備えた vim スタイルの編集
* **デフォルト**: `"normal"`

```json settings.json theme={null}
{
  "editorMode": "vim"
}
```

`/config` では **Editor mode** として表示され、このキーをユーザー設定に書き込みます。

### `emojiCompletionEnabled`

プロンプト入力で `:` に続けてショートコードを入力したときに絵文字の候補を表示し、`:heart:` のような完成したショートコードを対応する絵文字に置き換えます。両方をオフにするには `false` に設定します。

* **スコープ**: [`Any file`](#scopes)
* **型**: Boolean
  * `true`: Claude Code は `:` の後に絵文字の候補を表示し、完成したショートコードを絵文字に置き換えます
  * `false`: Claude Code は絵文字の候補を表示せず、ショートコードの置き換えも行いません
* **デフォルト**: `true`

```json settings.json theme={null}
{
  "emojiCompletionEnabled": false
}
```

[絵文字ショートコード](/docs/ja/interactive-mode#emoji-shortcodes)を参照してください。Claude Code v2.1.217 以降が必要です。

### `fileSuggestion`

組み込みのファイル候補の代わりに、独自のコマンドを実行して `@` ファイルパスのオートコンプリートを提供します。組み込みの候補は高速なファイルシステム走査を使用しますが、大規模なモノレポでは、事前にビルドされたファイルインデックスのようなプロジェクト固有のインデックスを使用したほうがうまくいく場合があります。

* **スコープ**: [`Any file`](#scopes)。[ステータスラインとファイル候補のゲート](#status-line-and-file-suggestion-gates)の下では、Claude Code はコマンドをオフにするか管理設定の値のみを実行し、ユーザーのコマンドは警告なしにスキップします。
* **型**: 常に `"command"` である `type` と、実行するシェルコマンドである `command` を持つオブジェクト
* **デフォルト**: 未設定。Claude Code は組み込みのファイル候補を使用します

```json settings.json theme={null}
{
  "fileSuggestion": {
    "type": "command",
    "command": "~/.claude/file-suggestion.sh"
  }
}
```

これを保存した後、プロンプトで `@` に続けてパスの一部を入力すると、コマンドの出力から候補が表示されます。

#### コマンドの入力と出力

Claude Code は、`CLAUDE_PROJECT_DIR` を含め、[フック](/docs/ja/hooks)と同じ環境変数でコマンドを実行し、5 秒後に待機を打ち切ります。コマンドは、それまでに入力された内容を保持する `query` フィールドを含む JSON を stdin で受け取ります。

```json theme={null}
{"query": "src/comp"}
```

改行区切りのファイルパスを stdout に出力します。Claude Code が表示するのは最大 15 件です。

```text theme={null}
src/components/Button.tsx
src/components/Modal.tsx
src/components/Form.tsx
```

次のスクリプトはクエリを読み取り、リポジトリのファイルインデックスに渡します。

```bash theme={null}
#!/bin/bash
query=$(cat | jq -r '.query')
# Replace your-repo-file-index with your own file search command
your-repo-file-index --query "$query" | head -20
```

### `footerLinksRegexes`

正規表現がターンの出力（ファイルの内容や取得したページを含むツールの結果、および Claude 自身の応答）に一致したとき、入力ボックスの下のフッターにクリック可能なバッジを追加でレンダリングします。レビューツールや課題トラッカーなどのプロジェクトの CLI が出力する ID を、セッション内のリンクに変換するために使用します。

* **スコープ**: [`User or managed`](#scopes)
* **型**: オブジェクトの配列。各オブジェクトは `"regex"` に設定された `type`、正規表現の `pattern`、`url` テンプレート、およびオプションの `label` を持ちます。`url` と `label` 内の `{name}` プレースホルダーは、`pattern` の名前付きキャプチャグループから埋められます
* **デフォルト**: 未設定。バッジはレンダリングされません

この例では `PROJ-1234` のような課題キーに一致させ、キャプチャしたキーから各リンクを構築します。

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

この設定では、ツールの結果または Claude の応答に `PROJ-1234` が現れると、`https://issues.example.com/browse/PROJ-1234` にリンクする `PROJ-1234` バッジがフッターに表示されます。

#### バッジの制約

各エントリの URL、ラベル、バッジの数には次の制限があります。

| 制約 | 動作 |
| :- | :- |
| URL のオリジン | キャプチャされた値は URL エンコードされ、構築された URL はテンプレートのリテラルのオリジンと同じでなければなりません。キャプチャはパスセグメントやクエリ値を埋めることはできますが、リンク先を変更することはできません |
| URL の長さ | 2048 文字を超える構築された URL は破棄されます |
| URL スキーム | `https`、`http`、または認識されるエディターやワークスペースのディープリンクスキーム（`vscode`、`vscode-insiders`、`cursor`、`windsurf`、`zed`、`jetbrains`、`idea`、`slack`、`linear`、`notion`、`figma`）でなければなりません |
| ラベル | デフォルトは一致したテキストで、表示幅 28 カラムに切り詰められます |
| バッジの数 | レンダリングされるバッジは最大 5 個です。新しい一致によって最も古いものが置き換えられ、`/clear` でバッジは削除されます |

ターンが完了すると、Claude Code はメインスレッド上で各エントリの `pattern` 正規表現をターンの出力に照合するため、遅い正規表現は完了するまで UI をブロックします。`(a+)+$` のようなネストされた量指定子は、特定の入力に対して指数関数的に時間がかかり、セッションをフリーズさせることがあるため、各 `pattern` は線形に保ち、`+` や `*` のネストは避けてください。

[カスタムステータスライン](/docs/ja/statusline)が設定されている場合、フッターバッジはそれと並んでレンダリングされ、どちらも他方を置き換えることはありません。セッションデータから独自に内容を計算するスクリプト駆動の行にはステータスラインを使用し、スクリプトなしで会話中の ID をリンクに変換するにはフッターバッジを使用します。

### `keybindingFlavor`

> [!WARNING]
>
> v2.1.261 以降は非推奨となり、効果はありません。プロンプトの単語編集キーは、Bash と同様に常に [readline の慣例に従います](/docs/ja/interactive-mode#make-ctrl-w-delete-back-to-whitespace)。Claude Code は引き続き `keybindingFlavor` を受け付けるため、これを設定している設定ファイルは有効なままです。

v2.1.238 から v2.1.260 では、これを `"readline"` に設定すると、`Ctrl+W` が直前の単語だけでなく直前の空白までを削除するようになりました。

* **スコープ**: [`Any file`](#scopes)
* **型**: 文字列。`"classic"` または `"readline"`
* **デフォルト**: 未設定

### `maxProseWidth`

Claude の応答に含まれる文章の幅に上限を設け、幅の広いターミナルでも行を読みやすく保ちます。段落、見出し、リスト、引用ブロックはこのカラム数の範囲内で折り返され、表とコードブロックはターミナルの全幅を維持します。Claude Code v2.1.282 以降が必要です。

* **スコープ**: [`Any file`](#scopes)
* **型**: ターミナルのカラム数。整数で、最小値は `40`。Claude Code はそれ以外の値を無視します
* **デフォルト**: 未設定。文章はターミナルの端で折り返されます

```json settings.json theme={null}
{
  "maxProseWidth": 80
}
```

### `prefersReducedMotion`

スピナー、シマー、フラッシュ効果などのインターフェースのアニメーションを抑えるか、オフにします。`/config` では **Reduce motion** として表示されます。

* **スコープ**: [`Any file`](#scopes)
* **型**: Boolean
  * `true`: Claude Code はスピナー、シマー、フラッシュ効果などのインターフェースのアニメーションを抑えるか、オフにします
  * `false`: 未設定と同じです。Claude Code はアニメーションを表示します
* **デフォルト**: `false`

```json settings.json theme={null}
{
  "prefersReducedMotion": true
}
```

### `promptSuggestionEnabled`

プロンプト入力に表示されるグレーアウトされた予測である[プロンプト候補](/docs/ja/interactive-mode#prompt-suggestions)の表示・非表示を切り替えます。非表示にするには、`false` に設定するか、`/config` で **Prompt suggestions** をオフにします。

* **スコープ**: [`Any file`](#scopes)
* **型**: Boolean
  * `true`: プロンプト入力にプロンプト候補が表示されます
  * `false`: Claude Code はプロンプト候補を非表示にします
* **デフォルト**: `true`
* **セッションごとの上書き**: 1 つのセッションについては、[`CLAUDE_CODE_ENABLE_PROMPT_SUGGESTION`](/docs/ja/env-vars) がこのキーより優先されます

```json settings.json theme={null}
{
  "promptSuggestionEnabled": false
}
```

プロンプト候補には、テレメトリがオンになっている claude.ai アカウントまたは Console アカウントが必要です。Amazon Bedrock、Google Cloud の Agent Platform、Microsoft Foundry の場合、または [`DISABLE_TELEMETRY`](/docs/ja/env-vars) などでテレメトリがオフになっている場合、このキーは効果がなく、`CLAUDE_CODE_ENABLE_PROMPT_SUGGESTION=1` でのみオンにできます。

### `respectGitignore`

`@` ファイルピッカーが `.gitignore` のパターンに一致するファイルを除外するかどうかを制御します。`/config` では **Respect .gitignore in file picker** として表示されます。

* **スコープ**: [`Any file`](#scopes)。どの設定ファイルでも設定されていない場合、Claude Code は `/config` のトグルが書き込む `~/.claude.json` 内の `respectGitignore` にフォールバックします。
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

入力ボックスで [`!` プレフィックス](/docs/ja/interactive-mode#shell-mode-with-prefix)を付けてシェルコマンドを実行した後に、Claude が応答するかどうかを選択します。デフォルトでは、Claude Code はコマンドの出力を会話に追加し、Claude がそれに応答します。このキーを `false` に設定すると、応答なしで出力がコンテキストに追加されるため、複数のコマンドを実行してからまとめて質問できます。

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

[`!` プレフィックスによるシェルモード](/docs/ja/interactive-mode#shell-mode-with-prefix)を参照してください。

### `showClearContextOnPlanAccept`

[plan モード](/docs/ja/permission-modes#review-and-approve-a-plan)で Claude が計画を完成させると、承認メニューが表示されます。計画には多くのコンテキストが使われることがあるため、このキーはそのメニューに最初のオプションとして **Yes, clear context and …** を追加します。このオプションは計画を承認し、会話のコンテキストをクリアして、計画のみに基づいて実装を開始します。ラベルの残りの部分には、セッションが続行する権限モードと、計画にどれだけのコンテキストが使われたかが表示されます。

* **スコープ**: [`Any file`](#scopes)
* **型**: Boolean
  * `true`: 計画の承認メニューに、計画を承認して会話のコンテキストをクリアする最初のオプション **Yes, clear context and …** が追加されます
  * `false`: 計画の承認メニューにコンテキストをクリアするオプションは表示されません
* **デフォルト**: `false`

```json settings.json theme={null}
{
  "showClearContextOnPlanAccept": true
}
```

### `showTurnDuration`

各応答の後に表示されるターンの所要時間メッセージ（「Cooked for 1m 6s · done 6:05 PM」など）の表示・非表示を切り替えます。「done」の後の時刻はターンが終了した時刻を示し、その形式とタイムゾーンは [`timeFormat`](#timeformat) と [`timeZone`](#timezone) で制御します。`/config` では **Show turn duration** として表示されます。

* **スコープ**: [`Any file`](#scopes)。どの設定ファイルでも設定されていない場合、古いバージョンによる `~/.claude.json` 内の値が適用されます。
* **型**: Boolean
  * `true`: 各応答の後にターンの所要時間メッセージが表示されます
  * `false`: Claude Code はターンの所要時間メッセージを非表示にします
* **デフォルト**: `true`

```json settings.json theme={null}
{
  "showTurnDuration": false
}
```

### `spellcheck`

インストールしたスペルチェッカーを使用して、入力中のプロンプト入力内のスペルミスに下線を引きます。Claude Code がチェックするのは入力ボックス内のテキストのみです。aspell、hunspell、ispell のインストール方法とチェッカーの対象範囲については、[入力中にスペルをチェックする](/docs/ja/interactive-mode#check-spelling-as-you-type)を参照してください。Claude Code v2.1.235 以降が必要です。

* **スコープ**: [`User or managed`](#scopes)。これを設定している最上位の階層のブロック全体が適用されます。
* **型**: `enabled`（Boolean）、`checker`（`"aspell"`、`"hunspell"`、`"ispell"`、または `"auto"`）、`language`（文字列。辞書名としてチェッカーに渡されます）、`color`（文字列。ターミナルのカラー名、`#rrggbb`、`rgb(r,g,b)`、`ansi256(n)`、または `ansi:<name>`）を持つオブジェクト
* **デフォルト**: 未設定。スペルチェックはオフです。`checker` のデフォルトは `"auto"` で、`PATH` 上で最初に見つかった 3 つのうちのいずれかです。`language` のデフォルトはチェッカー自身の辞書です。`color` のデフォルトはテーマのエラーカラーです

```json settings.json theme={null}
{
  "spellcheck": { "enabled": true, "language": "en_GB" }
}
```

### `spinnerTipsEnabled`

Claude の作業中、スピナーの行には Claude Code の機能に関する短いヒント（「Use Plan Mode to prepare for a complex request before making changes. Press Shift+Tab twice to enable.」など）が順に表示されます。これらを非表示にするには、このキーを `false` に設定します。`/config` では **Show tips** として表示されます。

* **スコープ**: [`Any file`](#scopes)
* **型**: Boolean
  * `true`: Claude の作業中、スピナーにヒントが表示されます
  * `false`: Claude Code はスピナーのヒントを非表示にします
* **デフォルト**: `true`

```json settings.json theme={null}
{
  "spinnerTipsEnabled": false
}
```

### `spinnerTipsOverride`

Claude の作業中に Claude Code が表示する[スピナーのヒント](#spinnertipsenabled)に独自のヒントを追加するか、組み込みのヒントを独自のものに置き換えます。Claude Code は独自のヒントを組み込みのヒントと同じローテーションに入れます。

[`spinnerTipsEnabled`](#spinnertipsenabled) を `false` に設定すると、Claude Code は独自のヒントも含めてすべてのヒントを非表示にします。

* **スコープ**: [`Any file`](#scopes)。Claude Code は、ユーザー設定、`--settings` フラグ、管理設定からのヒントオブジェクト、`tipsFile`、`label`、`excludeDefault` を受け入れます。プロジェクト設定とローカル設定からは、プレーンな文字列のヒントのみを読み取ります。
* **型**: `tips`、`tipsFile`、`label`、`excludeDefault` フィールドを持つオブジェクト。各フィールドはオプションです
* **デフォルト**: 未設定。Claude Code は組み込みのヒントのみを表示します

ヒントオブジェクト、`tipsFile`、`label`、およびプロジェクト設定とローカル設定はプレーンな文字列のみを提供するというスコープの規則には、Claude Code v2.1.247 以降が必要です。

各 `tips` エントリは、プレーンな文字列か、次のフィールドを持つオブジェクトです。

| フィールド | 必須 | 説明 |
| :- | :- | :- |
| `id` | はい | 最大 64 文字の英字、数字、`.`、`_`、`-`。Claude Code はこれをキーとしてヒントの表示履歴を管理するため、リストの順序を変更してもヒントのクールダウンは維持されます。同じ id を持つエントリが 2 つある場合、Claude Code は最初のものを使用します |
| `text` | はい | ヒント。最大 500 文字の 1 行です。Claude Code は ANSI エスケープと制御文字を取り除き、空白をまとめます |
| `cooldownSessions` | いいえ | Claude Code がヒントを再表示するまでに待機するセッション数。`0` から `1000`、デフォルトは `0` |
| `priority` | いいえ | 表示されていない期間が同じヒント同士の順序。値が大きいほど先に表示されます。`-10` から `10`、デフォルトは `0` |

Claude Code はプレーンな文字列を、これらのデフォルト値と位置に基づく id を持つヒントとして読み取るため、リストの順序を変更するとその表示履歴はリセットされます。編集をまたいで履歴を保持するには、ヒントに `id` を付けてください。

Claude Code が読み取るヒントは `tips` と `tipsFile` を合わせて最大 200 件で、無効なエントリは設定ファイルを拒否するのではなく、デバッグ警告とともに破棄します。

残りのフィールドを使用して、ヒントファイルの指定、プレフィックスの設定、組み込みのヒントの非表示を行います。

* `tipsFile`: 同じエントリの配列、または `tips` 配列を持つオブジェクトを保持するローカル JSON ファイルへの絶対パスまたは `~/` パス。最大 256 KB です。Claude Code はファイルをプロセスごとに 1 回読み取るため、編集内容は次回の起動時に読み込まれます。[サーバー管理設定](/docs/ja/server-managed-settings)では設定できません。サーバー管理設定ではインラインの `tips` をデプロイするか、ディスク上の `managed-settings.json` でパスをデプロイしてください。
* `label`: ユーザー設定、`--settings`、管理設定からのヒントの前に Claude Code が表示するプレフィックス。最大 40 文字です。デフォルトは組み込みのヒントと同じプレフィックスの `Tip` で、プロジェクト設定とローカル設定からのヒントには常にこれが使われます。
* `excludeDefault`: `true` に設定すると、組み込みのヒントを非表示にして独自のヒントのみを表示します。`tipsFile` が存在しない、またはすべてのエントリが無効であるなどの理由で Claude Code が独自のヒントを 1 つも読み込めない場合、空のスピナーではなく組み込みのローテーションを維持します。

複数の設定ファイルでこのキーが設定されている場合、Claude Code はそれらすべてのヒントを表示し、`tipsFile`、`label`、`excludeDefault` はそれぞれ、管理設定、`--settings` フラグ、ユーザー設定のうち、それを設定している最も優先順位の高いものから取得します。

この例はユーザー設定に記述するもので、`Acme tip` プレフィックスの下で、プレーンな文字列のヒントとオブジェクトのヒントをローテーションに追加します。

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

例の各フィールドは、Claude Code によるヒントの表示方法をそれぞれ 1 点ずつ変更します。

* `label`: Claude Code は両方のヒントを `Tip: ...` ではなく `Acme tip: ...` として表示します。
* プレーンな文字列: Claude Code はデフォルト値を適用するため、直後のセッションで再び表示されることがあります。
* `id`: Claude Code は 2 つ目のヒントの表示履歴を `gateway-errors` をキーとして管理するため、ヒントを追加したり順序を変更したりした後もクールダウンが適用されます。
* `cooldownSessions`: Claude Code は `gateway-errors` ヒントを表示した後、5 セッション後までそのヒントを再表示しません。
* `priority`: `gateway-errors` ヒントと別のヒントが同じセッション数だけ表示されていない場合（たとえば、どちらもまだ表示されていない場合）、Claude Code は `gateway-errors` を先に表示します。プレーンな文字列はデフォルトの優先度 `0` を持ちます。

Claude の作業中、Claude Code は `Acme tip: Run /review before opening a PR` のように、スピナーに独自のプレフィックス付きでヒントを表示します。

### `spinnerVerbs`

ターンの進行中、スピナーには「Accomplishing」、「Architecting」、「Baking」などの動詞が順に表示されます。このキーを使用すると、そのローテーションに独自の動詞を追加したり、組み込みのリストを独自のものに置き換えたりできます。

* **スコープ**: [`Any file`](#scopes)
* **型**: 文字列の `verbs` 配列と、次のいずれかである `mode` を持つオブジェクト:
  * `"append"`: Claude Code は組み込みのセットに独自の動詞を追加します
  * `"replace"`: Claude Code は独自の動詞のみを表示します
* **デフォルト**: 未設定。Claude Code は組み込みの動詞を使用します

この例では、組み込みのセットに 2 つの動詞を追加します。

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

独自のコマンドを実行して、モデル、コスト、git ブランチなどのコンテキストを含む[ステータスライン](/docs/ja/statusline)をプロンプトの下にレンダリングします。オプションのフィールドで、間隔の調整、定期的な再実行の追加、スクリプト自体が `vim.mode` をレンダリングする場合の組み込みの vim モードインジケーターの非表示を行えます。

* **スコープ**: [`Any file`](#scopes)。[`allowManagedHooksOnly`](#allowmanagedhooksonly) がオンの場合、または [`disableAllHooks`](#disableallhooks) が管理設定以外で設定されている場合、管理設定の値のみが実行されます。
* **型**: `"command"` に設定された `type` と `command` 文字列を持つオブジェクト。加えて、文字数を表すオプションの `padding`、秒数を表すオプションの `refreshInterval`（最小値 `1`）、Boolean であるオプションの `hideVimModeIndicator` を持ちます
* **デフォルト**: 未設定。ステータスラインは表示されません

この例では、モデル名とコンテキストの使用量を出力し、2 文字分の水平方向の間隔を追加します。

```json settings.json theme={null}
{
  "statusLine": {
    "type": "command",
    "command": "jq -r '\"[\\(.model.display_name)] \\(.context_window.used_percentage // 0)% context\"'",
    "padding": 2
  }
}
```

この例では [`jq`](https://jqlang.org/) がインストールされている必要があり、シェルで実行されます。PowerShell と Git Bash での同等の設定については [Windows での設定](/docs/ja/statusline#windows-configuration)を、完全な設定手順については[ステータスラインを手動で設定する](/docs/ja/statusline#manually-configure-a-status-line)を参照してください。

### `subagentStatusLine`

Claude が[サブエージェント](/docs/ja/sub-agents)を実行すると、Claude Code はプロンプトの下のタスク表示にそれらを一覧表示し、サブエージェントごとに `name · description · token count` を示す行を 1 行ずつ表示します。このキーを使用すると、独自のコマンドを実行してそれらの行を書き換えられます。たとえば、各サブエージェントのコンテキスト使用量をパーセンテージで表示できます。更新のたびに、Claude Code は表示中の行を 1 つの JSON オブジェクトとして stdin に送信します。このオブジェクトには、各サブエージェントの `id`、`name`、`status`、`model`、`tokenCount` などを含む `tasks` 配列が含まれます。Claude Code は、`{"id", "content"}` 行として書き戻された各 `id` の行を置き換えます。書き戻さなかった行はデフォルトのレンダリングのままです。

* **スコープ**: [`Any file`](#scopes)。[`allowManagedHooksOnly`](#allowmanagedhooksonly) がオンの場合、または [`disableAllHooks`](#disableallhooks) が管理設定以外で設定されている場合、管理設定の値のみが実行されます。
* **型**: `"command"` に設定された `type` と `command` 文字列を持つオブジェクト
* **デフォルト**: 未設定。Claude Code はデフォルトの行をレンダリングします

```json settings.json theme={null}
{
  "subagentStatusLine": {
    "type": "command",
    "command": "jq -c '.tasks[] | {id, content: \"\\(.name): \\(.tokenCount) tokens\"}'"
  }
}
```

[サブエージェントのステータスライン](/docs/ja/statusline#subagent-status-lines)を参照してください。

### `syntaxHighlightingDisabled`

Claude Code は、ターミナルに表示する差分、コードブロック、ファイルプレビュー内のコードを、組み込みのハイライターで言語ごとに色分けします。プラグインや言語サーバーは関与しません。このキーを `true` に設定すると、代わりにプレーンテキストとして表示します。たとえば、色がターミナルのテーマと合わない場合や、スクリーンリーダーの動作が遅くなる場合に使用します。

* **スコープ**: [`Any file`](#scopes)
* **型**: Boolean
  * `true`: Claude Code は差分、コードブロック、ファイルプレビューでシンタックスハイライトをオフにします
  * `false`: Claude Code はシンタックスハイライトを行います
* **デフォルト**: `false`

```json settings.json theme={null}
{
  "syntaxHighlightingDisabled": true
}
```

### `terminalProgressBarEnabled`

一部のターミナルでは、その中で実行されているプログラムの進行状況インジケーターをタブやタスクバーに表示できます。Claude の作業中、Claude Code はターミナルに進行中の状態を報告するため、別のタブやウィンドウからセッションがまだビジーかどうかを確認できます。ターンの終了後も、[バックグラウンドサブエージェント](/docs/ja/sub-agents#run-subagents-in-foreground-or-background)や[動的ワークフロー](/docs/ja/workflows)がまだ実行中の間はインジケーターが表示されたままになり、セッションがアイドル状態になるとクリアされます。

Claude Code がこれを報告するのは、インジケーターをサポートするターミナル（ConEmu、Ghostty 1.2.0 以降、iTerm2 3.6.6 以降）のみです。Claude Code による報告を停止するには、このキーを `false` に設定します。`/config` では **Terminal progress bar** として表示されます。

* **スコープ**: [`Any file`](#scopes)。どの設定ファイルでも設定されていない場合、古いバージョンによる `~/.claude.json` 内の値が適用されます。
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

Claude Code はターミナルのタブのタイトルを設定します。デフォルトでは会話から生成したタイトルを使用し、`/rename` または `--name` でセッションに[名前](/docs/ja/sessions#name-your-sessions)を付けると、タブには代わりにその名前が表示されます。セッションに名前を付けた後も生成されたタイトルをタブに表示し続けるには、このキーを `false` に設定します。名前自体は引き続き適用されるため、`/resume <name>` やセッションピッカーで見つけることができます。

* **スコープ**: [`Any file`](#scopes)
* **型**: Boolean
  * `true`: ターミナルのタブのタイトルに、設定したセッション名が表示されます
  * `false`: タブには Claude Code が会話から生成したタイトルが表示されたままになります
* **デフォルト**: `true`

```json settings.json theme={null}
{
  "terminalTitleFromRename": false
}
```

Claude Code によるターミナルのタイトルの更新を完全に停止するには、代わりに [`CLAUDE_CODE_DISABLE_TERMINAL_TITLE`](/docs/ja/env-vars) を `1` に設定します。

### `theme`

インターフェースのカラーテーマを選択します。`/config` では **Theme** として表示されます。

* **スコープ**: [`Any file`](#scopes)。どの設定ファイルでも設定されていない場合、古いバージョンによる `~/.claude.json` 内の値が適用されます。
* **型**: 文字列。次のいずれか:
  * `"auto"`: ターミナルのライトまたはダークの背景に合わせます
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

[カスタムテーマを作成する](/docs/ja/terminal-config#create-a-custom-theme)を参照してください。

### `timeFormat`

各ターンの所要時間メッセージの末尾にある `done 6:05 PM` や、[トランスクリプトビューアー](/docs/ja/interactive-mode#transcript-viewer)のタイムスタンプなど、Claude Code がインターフェースに表示する時刻の書式を選択します。プリセットを選ぶには、`/config` を実行して **Time format** を設定します。Claude Code v2.1.257 以降が必要です。

* **スコープ**: [`Any file`](#scopes)
* **型**: 文字列。次のいずれか:
  * `"auto"`: 未設定と同じです。各時刻は組み込みの書式を維持し、ターンの所要時間メッセージではロケールに従います
  * `"12-hour"`: 12 時間制
  * `"24-hour"`: 24 時間制
  * `"24-hour-utc"`: UTC の 24 時間制で、`18:05Z` のように分の後に `Z` が付きます。このプリセットでは Claude Code は [`timeZone`](#timezone) を無視します
  * `"%H:%M"` のような strftime パターン: Claude Code は各時刻をそのパターンで書き出します。`%` を含む値はすべてパターンとして扱われ、プリセット以外のそれ以外の値は `"auto"` とみなされます
* **デフォルト**: `"auto"`

```json settings.json theme={null}
{
  "timeFormat": "24-hour"
}
```

`/config` ではプリセットのみが選択できるため、strftime パターンを使用するには、設定ファイルにキーを追加します。この例では、各時刻を 2 桁の 24 時間制で表示します。

```json settings.json theme={null}
{
  "timeFormat": "%H:%M"
}
```

すると、ターンの所要時間メッセージとトランスクリプトビューアーに `18:05` のような時刻が表示されます。トランスクリプトビューアーではパターンがタイムスタンプ全体となるため、日付も表示したい場合は日付のディレクティブを追加します。この例では時刻の前に日付を付けます。

```json settings.json theme={null}
{
  "timeFormat": "%Y-%m-%d %H:%M"
}
```

すると、同じ箇所に `2026-09-01 18:05` のような時刻が表示されます。

### `timeZone`

インターフェースの時刻を、システムのタイムゾーン以外のタイムゾーンで表示します。`"UTC"` や `"Europe/Dublin"` などの [IANA タイムゾーン名](https://www.iana.org/time-zones)を設定します。これにより、[`timeFormat`](#timeformat) が制御する時刻がこのタイムゾーンで表示されます。`timeFormat` が `"24-hour-utc"` の場合、時刻は UTC のままとなり、Claude Code はこのキーを無視します。`/config` にはこのキーの行がないため、設定ファイルで設定してください。Claude Code v2.1.257 以降が必要です。

* **スコープ**: [`Any file`](#scopes)
* **型**: 文字列。IANA タイムゾーン名です。Claude Code が名前を認識できない場合は、システムのタイムゾーンを使用します
* **デフォルト**: 未設定。時刻はシステムのタイムゾーンで表示されます

```json settings.json theme={null}
{
  "timeZone": "Europe/Dublin"
}
```

### `tui`

ターミナル UI のレンダラーを選択します。仮想化されたスクロールバックを備えたちらつきのない[代替スクリーンレンダラー](/docs/ja/fullscreen)には `"fullscreen"` を、クラシックなメインスクリーンレンダラーには `"default"` を使用します。`/tui fullscreen` または `/tui default` を実行すると、このキーが自動で書き込まれます。

* **スコープ**: [`Any file`](#scopes)
* **型**: 文字列。次のいずれか:
  * `"default"`: クラシックなメインスクリーンレンダラー
  * `"fullscreen"`: 仮想化されたスクロールバックを備えた、ちらつきのない代替スクリーンレンダラー
* **デフォルト**: 未設定。Claude Code が[レンダラーを自動で選択します](/docs/ja/fullscreen#fullscreen-by-default)
* **セッションごとの上書き**: 1 つのセッションについては、[`CLAUDE_CODE_NO_FLICKER`](/docs/ja/env-vars) と [`CLAUDE_CODE_DISABLE_ALTERNATE_SCREEN`](/docs/ja/env-vars) がこのキーより優先されます。`CLAUDE_CODE_NO_FLICKER=1` はフルスクリーンをオンにし、`CLAUDE_CODE_NO_FLICKER=0` または `CLAUDE_CODE_DISABLE_ALTERNATE_SCREEN=1` はオフにします。両方が設定されている場合、Claude Code はオフにします

```json settings.json theme={null}
{
  "tui": "fullscreen"
}
```

tmux `-CC` の下や、Windows への SSH 接続では、`CLAUDE_CODE_NO_FLICKER=1` を設定しない限り、Claude Code はクラシックレンダラーを維持します。[エージェントビュー](/docs/ja/agent-view)から開いたバックグラウンドセッションは、この設定にかかわらず常にフルスクリーンレンダラーを使用します。

### `verbose`

デフォルトでは、トランスクリプトは各ツール呼び出しを、Claude が実行したコマンドとその出力の行数などの短い要約に折りたたみます。詳細を見たいときは `Ctrl+O` を押して、トランスクリプト全体を展開ビューに切り替えます。このキーを `true` に設定すると、すべてのツール呼び出しの入力と出力の全体が発生時にインラインで表示されます。これは、フック、MCP サーバー、長いシェルコマンドをデバッグする際に便利です。`/config` では **Verbose output** として表示されます。

* **スコープ**: [`Any file`](#scopes)。どの設定ファイルでも設定されていない場合、古いバージョンによる `~/.claude.json` 内の値が適用されます。
* **型**: Boolean
  * `true`: ツールの出力全体が表示されます
  * `false`: ツールの出力の切り詰められた要約が表示されます
* **デフォルト**: `false`
* **セッションごとの上書き**: 1 つのセッションについては、[`--verbose`](/docs/ja/cli-reference#cli-flags) がこのキーより優先されます

```json settings.json theme={null}
{
  "verbose": true
}
```

[`viewMode`](#viewmode) の値または保持された `/focus` の選択は、すべてのセッションでこのキーを上書きします。

### `viewMode`

Claude Code が開始時に使用するトランスクリプトビューを `"default"`、`"verbose"`、`"focus"` から設定します。設定すると、保持された `/focus` の選択と [`verbose`](#verbose) 設定の両方を上書きします。

* **スコープ**: [`Any file`](#scopes)
* **型**: 文字列。次のいずれか:
  * `"default"`: ツールの出力が切り詰められた通常のトランスクリプト
  * `"verbose"`: ツールの出力全体を含むトランスクリプト
  * `"focus"`: 最後のプロンプト、編集の diffstat を含むツール呼び出しの 1 行の要約、最終的な応答のみ。フォーカスビューには[フルスクリーンレンダラー](#tui)が必要です
* **デフォルト**: 未設定。`verbose` 設定と最後の `/focus` の選択が適用されます
* **セッションごとの上書き**: 1 つのセッションについては、[`--verbose`](/docs/ja/cli-reference#cli-flags) がこのキーより優先されます

```json settings.json theme={null}
{
  "viewMode": "focus"
}
```

### `vimInsertModeRemaps`

[vim エディターモード](/docs/ja/interactive-mode#vim-editor-mode)で、2 キーの INSERT モードのシーケンスを Escape にマッピングします。各キーは続けて入力する印字可能な文字ちょうど 2 文字で、サポートされるターゲットは `"<Esc>"` のみです。Claude Code はそれ以外のエントリを無視します。

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

`editorMode` が `"vim"` でない限り効果はありません。[INSERT モードのキーシーケンスを再マッピングする](/docs/ja/interactive-mode#remap-insert-mode-key-sequences)を参照してください。

### `voice`

[音声入力](/docs/ja/voice-dictation)をオンにし、音声入力キーの動作を選択します。`/voice` を実行すると、Claude Code がこのオブジェクトを自動で書き込みます。

* **スコープ**: [`Any file`](#scopes)
* **型**: Boolean である `enabled`、ホールドモードでのみ適用される Boolean である `autoSubmit`、および次のいずれかである `mode` を持つオブジェクト:
  * `"hold"`: 話している間は音声入力キーを押し続け、離すと停止します
  * `"tap"`: キーを 1 回タップすると録音が開始され、もう 1 回タップすると送信されます
* **デフォルト**: 未設定。音声入力はオフです。`enabled` が `true` で `mode` が未設定の場合、Claude Code は `"hold"` を使用します

この例では、音声入力をオンにし、キーを 1 回タップすると録音を開始し、もう 1 回タップすると送信するようにします。

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
> v2.1.92 で [`voice`](#voice) オブジェクトに置き換えられて以降、非推奨です。古い設定ファイルが引き続き機能するように Claude Code は引き続きこれを読み取りますが、新しい設定では `voice.enabled` を設定してください。

`voice` オブジェクトより前から存在する単一の Boolean 形式で、音声入力をオンにします。両方が設定されている場合は `voice.enabled` が適用されます。

* **スコープ**: [`Any file`](#scopes)
* **型**: Boolean
  * `true`: `voice.enabled` が設定されていない限り、claude.ai アカウントでログインしていて組織のポリシーで音声が許可されている場合に、音声入力がオンになります
  * `false`: `voice.enabled` が設定されていない限り、音声入力はオフです
* **デフォルト**: 未設定

```json settings.json theme={null}
{
  "voiceEnabled": true
}
```

### `wheelScrollAccelerationEnabled`

[フルスクリーンレンダリング](/docs/ja/fullscreen#mouse-wheel-scrolling)で、高速スクロール時にマウスホイールのスクロール速度を加速します。ホイールの 1 ノッチごとに一定の速度でスクロールさせるには、`false` に設定します。

* **スコープ**: [`Any file`](#scopes)
* **型**: Boolean
  * `true`: Claude Code は高速スクロール時にマウスホイールのスクロール速度を加速します
  * `false`: Claude Code はホイールの 1 ノッチごとに一定の速度でスクロールします
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
* **タイプ**: `commit` と `pr` 文字列および `sessionUrl` ブール値を含むオブジェクト、または全てのアトリビューションを非表示にする `false`。`false` 値には Claude Code v2.1.281 以降が必要です。それより前のバージョンはこれを拒否し、[それを含むユーザー、プロジェクト、またはローカル設定ファイル全体をスキップします](/docs/ja/settings#fix-a-broken-settings-file)
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

Claude Code は、CLAUDE.md または [memory](/docs/ja/memory) ルールなど、アトリビューションに関するカスタマー独自の命令が、[managed settings](/docs/ja/managed-settings) で設定されている場合を除き、これらのコミットおよび PR 行より優先されることを Claude に伝えます。

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
* **セッションごとのオーバーライド**: [`CLAUDE_CODE_DISABLE_GIT_INSTRUCTIONS`](/docs/ja/env-vars) はこのキーより優先されます（1 セッション）

```json settings.json theme={null}
{
  "includeGitInstructions": false
}
```

[非対話モード](/docs/ja/headless) または Agent SDK でシステムプロンプトを置き換えると、このキーが `true` の場合でも、セッションはスナップショットなしで開始されます。

* **`-p` 実行**: [`--system-prompt`](/docs/ja/cli-reference#system-prompt-flags) または `--system-prompt-file` を渡すと、プロンプトが置き換えられます。[`--agent`](/docs/ja/sub-agents#invoke-subagents-explicitly) または [`agent`](#agent) 設定で選択した、独自のプロンプトを持つカスタムエージェントを実行した場合も、プロンプトが置き換えられます。[bare モード](/docs/ja/headless#start-faster-with-bare-mode) 以外でスナップショットを保持するには、カスタムエージェントなしで実行し、プロンプトを置き換える代わりに [`--append-system-prompt`](/docs/ja/cli-reference#system-prompt-flags) で指示を追加してください。
* **[Agent SDK](/docs/ja/agent-sdk/modifying-system-prompts)**: カスタムシステムプロンプトまたはカスタムのメインスレッドエージェントを使用すると、プロンプトが置き換えられます。システムプロンプトを設定しない場合、SDK は最小限のデフォルトを使用し、この場合もセッションはスナップショットなしで開始されます。[bare モード](/docs/ja/headless#start-faster-with-bare-mode) 以外でスナップショットを保持するには、カスタム `agent` なしで `claude_code` プリセットを使用してください。

### `prUrlTemplate`

Claude Code がレンダリングする PR リンク（フッターバッジとツール結果サマリー内）を `github.com` の代わりに内部コードレビューツールに指定します。Claude Code は PR URL から `{host}`、`{owner}`、`{repo}`、`{number}`、`{url}` を置き換えます。両方のサーフェス上の [GitLab マージリクエスト](/docs/ja/interactive-mode#gitlab-merge-requests) リンクは GitLab URL を保持します。

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
* **デフォルト**: 未設定。Claude Code は `Co-Authored-By: <name> <noreply@anthropic.com>` を追加します。名前はコミットが作成されるときに使用されているモデル（`Claude Sonnet 5` など）です。[subagent](/docs/ja/sub-agents) がコミットを作成する場合、トレーラーは subagent のモデルに名前を付けます。
  * Claude Code がモデルを Claude モデルとして認識しているが、その正確なバージョンを確認できない場合、`Claude` のみを書き込みます。
  * モデル ID をカスタム [`ANTHROPIC_BASE_URL`](/docs/ja/env-vars) を通じて提供されるサードパーティモデルなど、Claude モデルと一致させることができない場合、`Claude Code` を書き込みます。

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

Claude Code が [クラウド](/docs/ja/claude-code-on-the-web) または [Remote Control](/docs/ja/remote-control) セッションからコミットするか、プルリクエストを開くときに claude.ai セッションリンクを追加するかどうかを選択します。Claude Code はコミット上に `Claude-Session` トレーラーとしてリンクを追加し、プルリクエストの説明にリンクとして追加します。リンクを省略するには `false` に設定します。

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

フックを登録し、実行するフックを制限し、ワークフローを制御します。フックイベントとペイロードについては、[フックリファレンス](/docs/ja/hooks)を参照してください。

### `allowedHttpHookUrls`

[HTTP フック](/docs/ja/hooks#http-hook-fields)がターゲットできる URL を制限します。このキーを定義すると、Claude Code は HTTP フックを実行するのはその URL がパターンの 1 つと一致する場合のみで、残りはブロックして実行しません。空の配列はすべての HTTP フックをブロックします。

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

* **管理フックと SDK フックが実行されます**: 管理設定からのフックと [Agent SDK](/docs/ja/agent-sdk/overview) がプロセス内で登録するフック
* **強制有効プラグインフックが実行されます**: 管理設定が [`enabledPlugins`](#enabledplugins) を通じて強制有効にするプラグインからのフック。Claude Code は完全な `plugin@marketplace` ID でマッチするため、別のマーケットプレイスからの同じ名前のプラグインはブロックされたままです。これにより、組織マーケットプレイスを通じて検証済みフックを配布しながら、その他すべてをブロックできます。このようなプラグイン内の [mod](/docs/ja/plugins/mods/overview) は、[組織のものとしてカウント](/docs/ja/plugins/mods/admin#install-your-organizations-mods)される場合のみロードされます
* **その他すべてはブロックされます**: ユーザー、プロジェクト、ローカルフック、他のインストール済みプラグインからのフックと mod、エージェントのフロントマターで宣言されたフック。[Claude Code に組み込まれた mod](/docs/ja/plugins/mods/overview#mods-built-into-claude-code) は実行し続けます。ユーザーの mod のみをブロックするには、代わりに [`allowManagedModsOnly`](/docs/ja/plugins/mods/admin#set-options-on-the-built-in-guard) を設定してください。
* **コマンドソースプラグインは無効になります**: Claude Code は [`command` ソース](/docs/ja/plugins/marketplace-reference#command-plugin-source)を持つプラグイン（管理 `enabledPlugins` で強制有効にされたプラグインを含む）も無効にします。ただし、[`disableCommandPluginSources`](#disablecommandpluginsources) を明示的に `false` に設定した場合を除きます
* **マーケットプレイス `headersHelper` コマンドはブロックされます**: Claude Code はマーケットプレイス [`headersHelper` コマンド](/docs/ja/plugins/host-marketplace#authenticate-archive-downloads)もブロックします。ただし、[`disableCommandPluginSources`](#disablecommandpluginsources) が明示的に `false` に設定されている場合、または管理設定自体が宣言するマーケットプレイスの場合を除きます。Claude Code v2.1.238 以降が必要です
* **ステータスラインとファイル提案は管理設定に絞られます**: Claude Code は [`statusLine`](/docs/ja/statusline)、[`fileSuggestion`](#filesuggestion)、[`subagentStatusLine`](/docs/ja/statusline#subagent-status-lines) を管理設定からのみ読み込みます。[ステータスラインとファイル提案ゲート](#status-line-and-file-suggestion-gates)に従います

このキーが設定されている間、[`/goal`](/docs/ja/goal) コマンドは実行できません。これはフックに依存しているためです。

### `disableAllHooks`

[フック](/docs/ja/hooks#disable-or-remove-hooks)、カスタム [ステータスライン](/docs/ja/statusline)、カスタム [ファイル提案](#filesuggestion) コマンドをオフにします。これらを設定から削除せずに一時的にオフにするために使用します。

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

* **管理設定内**: Claude Code はすべての設定済みフック（管理フックを含む）を無効にし、[Agent SDK](/docs/ja/agent-sdk/overview) がプロセス内で登録するフックは実行し続けます
* **他の設定ファイル内**: Claude Code はユーザー、プロジェクト、ローカル、プラグインフックを無効にします。管理フック、Agent SDK フック、管理 [`enabledPlugins`](#enabledplugins) で強制有効にされたプラグインからのフックは実行し続けます

このキーは、コードがフックを登録するプラグインである [mod](/docs/ja/plugins/mods/overview) も停止します:

* **管理設定内**: 組織のものを含め、インストール済みのすべてのプラグイン内の mod が停止します
* **他の設定ファイル内**: ユーザーがインストールした mod が停止し、[組織の mod](/docs/ja/plugins/mods/admin#install-your-organizations-mods) は実行し続けます

Claude Code に組み込まれた mod は、どちらの場合も実行し続けます。それぞれに[独自のスイッチ](/docs/ja/plugins/mods/overview#mods-built-into-claude-code)があります。

管理設定がこのキーを設定している場合に Agent SDK フックを実行し続けるには、Claude Code v2.1.242 以降が必要です。

フックが無効な間、[`/goal`](/docs/ja/goal) コマンドは実行できず、`/hooks` メニューはフックの代わりに通知を表示します。

#### ステータスラインとファイル提案ゲート

Claude Code は `statusLine`、`fileSuggestion`、`subagentStatusLine` について、この順序で 2 つの決定を行います:

* **完全にオフ**: 管理設定が `disableAllHooks` を設定している場合、またはフォルダが設定ファイル内のフックと同じ [ワークスペーストラストルール](/docs/ja/permissions#what-runs-before-you-trust-a-folder)の下で信頼されていない場合
* **管理設定に絞られます**: [`allowManagedHooksOnly`](#allowmanagedhooksonly) が設定されている場合、[設定の優先順位](/docs/ja/hooks#disable-or-remove-hooks)が適用された後に管理設定外で `disableAllHooks` が `true` である場合、または `--safe-mode` で Claude Code を起動した場合

絞られた場合、Claude Code はデプロイされた管理値があれば実行します。そうでない場合は警告なしにユーザーの値をスキップします: ステータスラインは無効になり、`@` オートコンプリートは組み込みファイル提案にフォールバックします。

### `disableWorkflows`

[動的ワークフロー](/docs/ja/workflows#turn-workflows-off)と、管理設定を通じた組織など、設定が到達するすべてのユーザーのためのバンドルワークフローコマンドをオフにします。自分自身のためだけにワークフローをオンまたはオフにするには、代わりに [`enableWorkflows`](#enableworkflows) を使用してください。これは `/config` の **Dynamic workflows** トグルがユーザー設定に書き込みます。

* **スコープ**: [`Any file`](#scopes)
* **型**: ブール値
  * `true`: Claude Code は動的ワークフローと、設定が到達するすべてのユーザーのためのバンドルワークフローコマンドをオフにします
  * `false`: 未設定と同じです。ワークフローがオンかどうかは [`enableWorkflows`](#enableworkflows) とプランのデフォルトに従います
* **デフォルト**: `false`
* **セッションごとの上書き**: [`CLAUDE_CODE_DISABLE_WORKFLOWS`](/docs/ja/env-vars) は 1 つのセッションのワークフローをオフにします。2 つのうちどちらがオフにするかに関わらず、もう一方はオンに戻すことはできません

```json settings.json theme={null}
{
  "disableWorkflows": true
}
```

### `enableWorkflows`

プランのデフォルトが望むものでない場合、自分自身のために [動的ワークフロー](/docs/ja/workflows)をオンまたはオフにします。`/config` に **Dynamic workflows** として表示され、このキーをユーザー設定に書き込み、プランのデフォルトに戻すときに再度削除します。管理設定からすべてのユーザーのためにワークフローをオフにするには、代わりに [`disableWorkflows`](#disableworkflows) を使用してください。

* **スコープ**: [`Any file`](#scopes)
* **型**: ブール値
  * `true`: Claude Code は自分自身の動的ワークフローをオンにします
  * `false`: Claude Code は自分自身の動的ワークフローをオフにします
* **デフォルト**: 未設定。ワークフローはオンです。ただし Pro プランではオフです
* **セッションごとの上書き**: [`CLAUDE_CODE_DISABLE_WORKFLOWS`](/docs/ja/env-vars) は 1 つのセッションのワークフローをオフにし、ここで `true` はそれが設定されている間はワークフローをオンに戻すことはできません

```json settings.json theme={null}
{
  "enableWorkflows": true
}
```

[`disableWorkflows`](#disableworkflows) と組織のワークフローポリシーも優先されます: `enableWorkflows: true` はいずれかのソースがワークフローをオフにしている間はワークフローをオンに戻すことはできません。Claude Code は、ユーザー設定以外のソースが `enableWorkflows` を設定している場合、または `disableWorkflows` を `true` に設定している場合、`/config` 行を非表示にします。

### `hooks`

Claude Code のライフサイクルの特定の時点（ツール呼び出しの前やセッション開始時など）で、[フック](/docs/ja/hooks)として独自のコマンド、プロンプト、エージェント、HTTP リクエスト、または MCP ツールを実行します。[フックリファレンス](/docs/ja/hooks#hook-events)はすべてのイベント、ペイロード、終了コードをリストします。各イベントは matcher グループのリストにマップされ、各グループは matcher が適用されるときに実行するハンドラーをリストします。

* **スコープ**: [`Any file`](#scopes)。フックは互いに置き換えられるのではなくファイル全体でマージされ、管理設定からのフックは他のファイルから削除できません。
* **型**: [フックイベント](/docs/ja/hooks#hook-events)でキー付けされたオブジェクト。各値は `"command"`、`"prompt"`、`"agent"`、`"http"`、または `"mcp_tool"` の `type` を持つ `{ "matcher", "hooks" }` グループの配列
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

すべてのイベント、matcher パターン、ハンドラーフィールドについては、[フックリファレンス](/docs/ja/hooks#configuration)を参照してください。フックをオフにするには、[`disableAllHooks`](#disableallhooks)を参照してください。フックを組織がデプロイするものに制限するには、[`allowManagedHooksOnly`](#allowmanagedhooksonly)を参照してください。

### `httpHookAllowedEnvVars`

[HTTP フック](/docs/ja/hooks#http-hook-fields)は環境変数の値をリクエストヘッダーに入れることができます。例えば `Authorization: Bearer $HOOK_TOKEN` ヘッダーですが、フックが独自の `allowedEnvVars` でリストしている変数のみです。このキーはすべての HTTP フックのそのリストに外側の制限を設定します: フックは変数を使用できるのは、独自の `allowedEnvVars` とこのキーの両方がそれを名前付けしている場合のみです。フックの定義がそれを要求している場合でも、フックが読むべきではないシークレットを読むのを防ぐために使用します。

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

### `workflowKeywordTriggerEnabled`

プロンプトでキーワード `ultracode` を入力することが [動的ワークフロー](/docs/ja/workflows#ask-for-a-workflow-in-your-prompt)をトリガーするかどうかを選択します。`false` に設定して、トリガーなしで単語を入力します。

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

Claude が書き込む動的ワークフローで [Claude が目指すエージェント数](/docs/ja/workflows#set-a-size-guideline)を設定します。Claude Code は値を Claude に助言として送信します。強制的な上限ではありません: `"small"` は 5 未満のエージェントを要求し、`"medium"` は 10 未満、`"large"` は 50 未満です。ワークフローが費やすものを制限したい場合は `"small"` を選択します。Claude Code v2.1.219 以降が必要です。

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

Claude Code v2.1.219 以降が必要です。v2.1.202 から v2.1.218 では、代わりに `/config` でガイドラインを設定します。

## プラグインとスキル

プラグインの有効化、マーケットプレイスの登録、組織で許可するプラグインソースの制限、読み込むスキルの制御を行います。プラグインのインストールと作成については、[プラグイン](/docs/ja/plugins/overview)を参照してください。

### `disableBundledSkills`

Claude Code に同梱されている[スキル](/docs/ja/skills)とワークフローをオフにします。Claude Code はバンドルスキルとワークフローを完全に削除しますが、`/init` などの組み込みコマンドは引き続き入力できる一方でモデルからは非表示になります。

* **スコープ**: [`任意のファイル`](#scopes)
* **型**: Boolean
  * `true`: Claude Code はバンドルスキルとワークフローを削除し、`/init` などの組み込みコマンドをモデルから非表示にします
  * `false`: バンドルスキルが読み込まれます
* **デフォルト**: 未設定。バンドルスキルが読み込まれます
* **セッション単位の上書き**: [`CLAUDE_CODE_DISABLE_BUNDLED_SKILLS`](/docs/ja/env-vars) を `1` に設定すると、1 つのセッションでバンドルスキルがオフになります。2 つのうちどちらでオフにした場合でも、もう一方でオンに戻すことはできません

```json settings.json theme={null}
{
  "disableBundledSkills": true
}
```

プラグイン、`.claude/skills/`、`.claude/commands/` からのスキルは影響を受けません。`/doctor` は組み込みコマンドと同様に引き続き入力できます。非表示にするには、代わりに [`DISABLE_DOCTOR_COMMAND`](/docs/ja/env-vars) を設定してください。

### `disableSkillShellExecution`

ユーザー、プロジェクト、プラグイン、または追加ディレクトリのソースからの[スキル](/docs/ja/skills)とカスタムコマンドにおける `` !`...` `` ブロックと ` ```! ` ブロックのインラインシェル実行をオフにします。Claude Code は各コマンドを実行する代わりに `[shell command execution disabled by policy]` に置き換えます。

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

`SKILL.md` を編集せずに[スキル](/docs/ja/skills#override-skill-visibility-from-settings)を非表示にしたり折りたたんだりします。Claude Code は各スキル名の下の値を、Claude が参照するスキル一覧と `/` のオートコンプリートに適用します。

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

管理設定と `--settings` で渡されたファイルでは、`/doctor` に対する `checkup` のようなバンドルスキルのエイリアスに設定したキーもそのスキルに適用されます。[エイリアスのキーとスキル自体の名前のキーがどのように組み合わされるか](/docs/ja/skills#override-skill-visibility-from-settings)を参照してください。

### `syncClaudeAiSkills`

[claude.ai アカウントで有効になっているスキル](/docs/ja/skills#how-synced-skills-behave)のダウンロードをオフにします。Claude Code は、[claude.ai アカウントでサインインしているターミナルセッション](/docs/ja/skills#where-synced-skills-load)（対話型・非対話型を問わず）、および Cowork セッションとクラウドセッションで、それらを `~/.claude/skills/synced/` にダウンロードします。`false` を設定すると、そのダウンロードが停止し、すでに同期されたスキルの読み込みも停止します。Claude Code が反映するのは `false` のみです。`true` は未設定と同じであり、他の理由でオフになっている場所で同期をオンにすることはありません。

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

[claude.ai アカウントで有効になっているプラグイン](/docs/ja/plugins/loading#synced-plugins)のダウンロードをオフにします。Claude Code は、claude.ai アカウントでサインインしているターミナルセッションの開始時と Cowork セッションで、それらを `~/.claude/plugins/synced/` にダウンロードし、それぞれを `<name>@synced` として読み込みます。`false` を設定すると、そのダウンロードが停止し、すでに同期されたプラグインの読み込みも停止します。Claude Code が反映するのは `false` のみです。`true` は未設定と同じであり、他の理由でオフになっている場所で同期をオンにすることはありません。Claude Code v2.1.273 以降が必要です。

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

組織内でセッションにメッセージをプッシュできる[チャネル](/docs/ja/channels)プラグインを選択します。これを設定すると、Claude Code はデフォルトの Anthropic 許可リストの代わりに指定したリストを使用します。各エントリは、プラグインとその提供元のマーケットプレイスを指定します。

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

このキーは、アカウントでチャネルが [`channelsEnabled`](#channelsenabled) のゲートを通過した時点で有効になります。Team プランと Enterprise プラン、および管理設定のある Console アカウントでは、`channelsEnabled: true` がそれに該当します。[実行できるチャネルプラグインを制限する](/docs/ja/channels#restrict-which-channel-plugins-can-run)を参照してください。

### `blockedMarketplaces`

組織のプラグインマーケットプレイスソースをブロックします。Claude Code は、マーケットプレイスの追加時と、プラグインのインストール、更新、リフレッシュ、自動更新の際にブロックリストを確認するため、ポリシーを設定する前に誰かが追加したマーケットプレイスもプラグインの取得に使用できなくなります。ブロックされたソースはダウンロード前に確認されるため、ファイルシステムに触れることはありません。

このキーを [claude.ai 管理コンソール](/docs/ja/server-managed-settings)で設定した場合、[制限の仕組み](/docs/ja/plugins/org#restrict-what-users-can-install)で説明しているとおり、組織内の誰かが claude.ai で git リポジトリからマーケットプレイスを追加するときにも claude.ai がこれを適用します。

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

`github` エントリでは [owner ワイルドカード形式](#owner-wildcards) `"owner/*"` を使用して、その GitHub オーナー配下のすべてのリポジトリをブロックできます。これには Claude Code v2.1.223 以降が必要です。`{ "source": "skills-dir" }` を追加すると、マーケットプレイスを制限することなく、Claude Code が `~/.claude/skills/` から [`@skills-dir` プラグイン](/docs/ja/plugins/loading#plugins-shared-through-a-repository)を読み込むのを停止できます。[管理対象のマーケットプレイス制限](/docs/ja/plugins/org#restrict-what-users-can-install)を参照してください。

### `channelsEnabled`

組織で[チャネル](/docs/ja/channels)を許可します。claude.ai の Team プランと Enterprise プランでは、これを `true` に設定するまで Claude Code はチャネルをブロックします。API キーで認証する [Anthropic Console](/docs/ja/authentication#claude-console-authentication) アカウントでは、チャネルはデフォルトで許可されます。組織が管理設定をデプロイしている場合は、このキーを `true` に設定するまで、Claude Code はそれらのアカウントでもチャネルをブロックします。

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

チャネルを有効にした後、チャネルとして登録できるプラグインを制限するには、[`allowedChannelPlugins`](#allowedchannelplugins) を設定します。[エンタープライズ向けの制御](/docs/ja/channels#enterprise-controls)を参照してください。

### `disableCommandPluginSources`

[`command` プラグインソース](/docs/ja/plugins/marketplace-reference#command-plugin-source)をブロックします。これは、マーケットプレイスが宣言したコマンドをユーザーのマシンで実行してプラグインをインストールするソースです。`true` に設定すると、Claude Code はそのコマンドを実行せず、command ソースのプラグインをインストールも更新もせず、すでにインストールされているものの読み込みも停止します。`false` に設定すると明示的に許可します。command ソースをブロックする場合は常に（`true` に設定した場合でも、[`allowManagedHooksOnly`](#allowmanagedhooksonly) のもとで未設定のままにした場合でも）、マーケットプレイスの [`headersHelper` コマンド](/docs/ja/plugins/host-marketplace#authenticate-archive-downloads)もブロックします。ただし、管理設定自体が宣言しているマーケットプレイスは除きます。Claude Code v2.1.229 以降が必要で、`headersHelper` のブロックには v2.1.238 以降が必要です。

* **スコープ**: [`管理`](#scopes)
* **型**: Boolean
  * `true`: Claude Code はマーケットプレイスが宣言したコマンドを実行せず、command ソースのプラグインをインストールも更新もせず、すでにインストールされているものの読み込みも停止します
  * `false`: Claude Code は command ソースのプラグインを明示的に許可します
* **デフォルト**: 未設定。Claude Code は [`allowManagedHooksOnly`](#allowmanagedhooksonly) に従います。フックの実行を管理設定に制限している組織では、command ソースも無効になります

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

名前が有効になるのは、そのマーケットプレイスがマシンに登録されており、かつ登録されたソースが同じ管理設定内で、その名前の [`extraKnownMarketplaces`](#extraknownmarketplaces) エントリ、または [`strictKnownMarketplaces`](#strictknownmarketplaces) のエントリとしても宣言されている場合のみです。許可リストにある名前で別のソースから登録されたマーケットプレイスは、Claude Code によって無視されます。公式マーケットプレイスはソースの要件から除外されており、その名前を許可リストに入れるだけで十分です。その名前は公式 Anthropic ソースからしか登録できないためです。[コンテキストに応じてプラグインを提案する](/docs/ja/plugins/relevance)を参照してください。

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

このキーを [claude.ai 管理コンソール](/docs/ja/server-managed-settings)で設定した場合、[制限の仕組み](/docs/ja/plugins/org#restrict-what-users-can-install)で説明しているとおり、組織内の誰かが claude.ai で git リポジトリからマーケットプレイスを追加するときにも claude.ai がこれを適用します。

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

このキーは `allowedMarketplaces` と記述することもできます。Claude Code がエイリアスをどのように扱うか、どのバージョンがそれを受け付けるかについては、[マーケットプレイスキーのエイリアス](#marketplace-key-aliases)で説明しています。このキーはポリシーゲートです。ユーザーが追加できるものを制御しますが、何も登録しません。1 つのファイルで制限と事前登録を行うには、[`extraKnownMarketplaces` と組み合わせる](#combine-with-extraknownmarketplaces)を参照してください。ユーザー側から見た内容については、[管理対象のマーケットプレイス制限](/docs/ja/plugins/org#restrict-what-users-can-install)を参照してください。

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
| `skills-dir` | `{ "source": "skills-dir" }` | フィールドなし。`~/.claude/skills/` のプラグインスキャンを再び有効にします |

3 つのソースタイプには、表の内容に加えて次のルールがあります。

* **`url`**: URL マーケットプレイスは `marketplace.json` ファイルのみをダウンロードし、Claude Code はそのサーバーから相対パスでプラグインファイルを取得しません。そのため、そのプラグインは相対パス以外の[プラグインソース](/docs/ja/plugins/marketplace-reference#plugin-sources)（同じホスト上に置くことができるアーカイブ URL など）を使用する必要があります。相対パスを使用するプラグインには、代わりに Git ベースのマーケットプレイスを使用してください。[URL ベースのマーケットプレイスで相対パスを使用するプラグインが失敗する](/docs/ja/plugins/troubleshooting#plugins-with-relative-paths-fail-in-url-based-marketplaces)を参照してください。
* **`hostPattern`**: 各リポジトリを列挙せずに、社内の GitHub Enterprise または GitLab サーバー上のすべてのマーケットプレイスを許可するために使用します。Claude Code は `github` ソースを `github.com` と照合し、`url` ソースからはホスト名を取得し、`git` ソースからは [git URL](https://git-scm.com/docs/git-clone#_git_urls) の形式に応じてホスト名を取得します。

  * `https://` や `ssh://` などのスキームを持つ URL: URL 内のホスト名。
  * スキームのない、git の `user@host:path` 形式の SSH アドレス（`git@git.example.com:tools/plugins.git` など）: `@` と `:` の間のホスト。これは git が接続するホストです。
  * スキームのないその他の形式: ホストがないため、`strictKnownMarketplaces` の `hostPattern` エントリには一致しません。`blockedMarketplaces` の `hostPattern` では、Claude Code はより広い範囲の形式からホストを取得するため、ブロックリストのエントリはそのような形式にも一致する場合があります。v2.1.234 より前は、`strictKnownMarketplaces` の `hostPattern` は git が SSH アドレスとして扱わない一部の形式にも一致していました。

  `file` ソースと `directory` ソースにはホストがなく、`hostPattern` エントリに一致することはありません。
* **`pathPattern`**: ネットワークソース用の `hostPattern` エントリと併せて、ファイルシステムのマーケットプレイスを許可するために使用します。`".*"` はすべてのローカルパスを許可します。`"^/opt/approved/"` のようなより狭いパターンは、特定のディレクトリに制限します。

許可リストは、空であっても、Claude Code が `~/.claude/skills/` から [`@skills-dir` プラグイン](/docs/ja/plugins/loading#plugins-shared-through-a-repository)を読み込むことも停止させます。引き続き読み込むには、`{ "source": "skills-dir" }` エントリを追加してください。このエントリは、このキーと `blockedMarketplaces` 以外では意味を持ちません。

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

以下の 4 つのサブキーの項目では、各サーフェスがブロックするものと、引き続き読み込まれるものを記載しています。Claude Code は認識できないサーフェス名を、設定ファイルをエラーにするのではなく無視します。そのため、すべてのクライアントが更新される前に新しいサーフェス名を追加できます。

### `strictPluginOnlyCustomization.skills`

`skills` サーフェスをロックします。Claude Code は、`~/.claude/skills/` と `.claude/skills/` からのスキル、`~/.claude/commands/` と `.claude/commands/` からのカスタムコマンド、`--add-dir` ディレクトリ配下のスキルとコマンド、および claude.ai アカウントから同期されたスキルの読み込みを停止します。プラグインスキル、バンドルスキル、管理ポリシーディレクトリ内のスキルは引き続き読み込みます。

* **スコープ**: [`管理`](#scopes)
* **型**: [`strictPluginOnlyCustomization`](#strictpluginonlycustomization) 配列内の文字列 `"skills"`
* **デフォルト**: ロックされない

```json managed-settings.json theme={null}
{
  "strictPluginOnlyCustomization": ["skills"]
}
```

### `strictPluginOnlyCustomization.agents`

`agents` サーフェスをロックします。Claude Code は、`~/.claude/agents/`、`.claude/agents/`、および `--add-dir` ディレクトリからのエージェントの読み込みを停止します。プラグインエージェント、組み込みエージェント、管理ポリシーディレクトリ内のエージェントは引き続き読み込みます。

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
* **引き続き実行するもの**: プラグインフックと管理設定内のフック

フロントマターフックの実行が停止されたスキル、カスタムコマンド、エージェントも、それ自体のサーフェスがロックされていない限り引き続き読み込まれます。

* **スコープ**: [`管理`](#scopes)
* **型**: [`strictPluginOnlyCustomization`](#strictpluginonlycustomization) 配列内の文字列 `"hooks"`
* **デフォルト**: ロックされない

```json managed-settings.json theme={null}
{
  "strictPluginOnlyCustomization": ["hooks"]
}
```

### `strictPluginOnlyCustomization.mcp`

`mcp` サーフェスをロックします。Claude Code は、`~/.claude.json` と `.mcp.json` からの MCP サーバーの読み込みを停止し、プラグインの MCP サーバー、[`managed-mcp.json`](/docs/ja/managed-mcp) のサーバー、[`managedMcpServers`](#managedmcpservers) のサーバーは引き続き読み込みます。

* **スコープ**: [`管理`](#scopes)
* **型**: [`strictPluginOnlyCustomization`](#strictpluginonlycustomization) 配列内の文字列 `"mcp"`
* **デフォルト**: ロックされない

```json managed-settings.json theme={null}
{
  "strictPluginOnlyCustomization": ["mcp"]
}
```

### `enabledPlugins`

個々の[プラグイン](/docs/ja/plugins/overview)を `plugin-name@marketplace-name` をキーとしてオンまたはオフにします。どのスコープにもエントリがないプラグインは、その [`defaultEnabled`](/docs/ja/plugins/manifest-reference#fields) の値にフォールバックします。`/plugin` または `claude plugin enable` でプラグインを有効化または無効化すると、Claude Code がこのキーを自動的に書き込みます。

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

プロジェクトの `.claude/settings.json` で GitHub リポジトリや npm パッケージなどの外部ソースのプラグインを有効にしても、他のユーザーにはインストールされません。プラグインを読み込むすべての経路で、各ユーザーが[自分でインストールする](/docs/ja/plugins/org#require-plugins-per-repository)まで、Claude Code はそのプラグインを未インストールとして報告します。

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

[フォルダを信頼する前に実行されるもの](/docs/ja/permissions#what-runs-before-you-trust-a-folder)では、信頼ゲートとリポジトリが提供できるその他のコンテンツを比較しています。このキーは `additionalMarketplaces` と記述することもできます。[マーケットプレイスキーのエイリアス](#marketplace-key-aliases)を参照してください。

`source` と併せて `"autoUpdate": true` を設定すると、Claude Code は起動後にバックグラウンドでそのマーケットプレイスをリフレッシュし、インストール済みのプラグインを更新します。省略した場合、`claude-plugins-official` とその他の大半の公式 Anthropic マーケットプレイスはデフォルトで `true` になり、サードパーティのマーケットプレイスはデフォルトで `false` になります。[自動更新を設定する](/docs/ja/plugins/install#keep-plugins-updated)を参照してください。

複数の設定ファイルが同じ名前でマーケットプレイスのエントリを定義している場合、Claude Code は[優先順位が最も高いファイル](/docs/ja/settings#settings-precedence)のエントリ全体を使用します。そのエントリは優先順位の低いエントリを置き換え、そのフィールドを一切継承しないため、再定義によって、あるファイルの `source.headers` の認証情報を別のファイルが制御する URL と組み合わせることはできません。v2.1.228 より前は、Claude Code は同名のエントリをフィールドごとにマージしていたため、優先順位の高いファイルのエントリが、別のファイルの `headers` を含め、自身で設定していないフィールドを継承することがありました。

#### マーケットプレイスのソースタイプ

`source` オブジェクトは次のいずれかの形式をとります。

* **`github`**: GitHub リポジトリ。`repo` を指定します
* **`git`**: 任意の git URL。`url` を指定します
* **`url`**: `marketplace.json` ファイルへの直接 URL。`url` と、認証付きアクセス用のオプションの `headers` および `headersHelper` を指定します。`headersHelper` は、`headers` に記載するには有効期間が短すぎる値を持つヘッダーを出力するコマンドを指定するもので、Claude Code v2.1.238 以降が必要です
* **`file`**: `marketplace.json` ファイルへのローカルパス。`path` を指定します
* **`directory`**: ローカルファイルシステムのパス。`path` を指定します。開発用、または組織が[各マシンにデプロイする](/docs/ja/plugins/mods/admin#install-your-organizations-mods)マーケットプレイスに使用します。
* **`settings`**: ホストされたリポジトリなしで設定ファイル内に直接宣言されたインラインマーケットプレイス。`name` と `plugins` を指定します

`git` ソースタイプは、セルフホストの GitLab や Bitbucket を含む任意の git ホスティングサービスで機能します。Claude Code は、そのマシン上で `git clone` が使用するのと同じ認証、つまり設定済みの認証情報ヘルパーまたは SSH キーでリポジトリをクローンします。`GITHUB_TOKEN` などのプロバイダートークンは、それを読み取る認証情報ヘルパーを通じて有効になります。セットアップの詳細については、[プライベートリポジトリ](/docs/ja/plugins/host-marketplace#grant-access-to-a-private-marketplace)を参照してください。

`github` ソースと `git` ソースでは、Claude Code はマーケットプレイスリポジトリを追加または更新のためにクローンする際、[Git LFS](https://git-lfs.com) のコンテンツを一切ダウンロードしません。LFS で追跡されているファイルはポインターファイルとしてチェックアウトされ、追加または更新の出力にその数が表示されます。

`source` オブジェクト内の `skipLfs` フィールドは受け付けられますが、効果はありません。v2.1.274 より前は、`"skipLfs": true` を設定しない限り、Claude Code は LFS コンテンツをダウンロードしていました。

`url` ソースでは、`headers` 内の認証情報に有効期限があり、新しい認証情報をコマンドで生成する必要がある場合に、`source` オブジェクト内で `headersHelper` を設定します。Claude Code v2.1.238 以降が必要です。コマンドが出力すべき内容と Claude Code がそれを実行する場所については、[headersHelper コマンドを作成する](/docs/ja/plugins/host-marketplace#write-the-headershelper-command)を、Claude Code がそれを実行しないケースについては、[Claude Code が headersHelper コマンドをスキップする場合](/docs/ja/plugins/host-marketplace#when-claude-code-skips-a-headershelper-command-or-drops-its-output)を参照してください。`https://` のマーケットプレイス URL に `headersHelper` を設定すると、Claude Code は次の 2 つのタイミングでコマンドを実行し、1 回の実行の出力を最大 60 秒間再利用します。

* そのマーケットプレイスの `marketplace.json` を取得する前（後のリフレッシュを含む）。Claude Code は出力されたヘッダーをその取得リクエストとともに送信します。
* マーケットプレイス URL のオリジン（同じスキーム、ホスト、ポート）上の各プラグインアーカイブをダウンロードする前。Claude Code は出力をそのダウンロードとともに送信し、それ以外のダウンロードにはヘッダーは付与されません。

[`--add-dir`](/docs/ja/permissions#what-runs-before-you-trust-a-folder) で追加したディレクトリの `.claude/settings.json` または `.claude/settings.local.json` に設定された `headersHelper` は、`url` ソースでもインラインプラグインエントリでも Claude Code によって無視され、そのファイルに設定された固定の `headers` のみが送信されます。その他の設定ファイルについては、[ユーザーが headersHelper コマンドを承認する方法](/docs/ja/plugins/host-marketplace#how-users-accept-a-headershelper-command)で説明しています。

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

`source: 'settings'` 配下のプラグインエントリで、自身の `source` が [`archive`](/docs/ja/plugins/marketplace-reference#archive-plugin-source) であるものは、アーカイブのダウンロード用に `headers` を設定できます。`headers` に指定する値の有効期間が短い場合（レジストリがリクエストに応じて発行するトークンなど）は、代わりに `headersHelper` コマンドを設定してください。エントリでは両方を設定することもできます。どちらのフィールドにも Claude Code v2.1.238 以降が必要です。

Claude Code は、エントリの `headers` とコマンドが出力した内容を、そのプラグインのアーカイブのダウンロードとともに送信し、それ以外のダウンロードには送信しません。Claude Code がコマンドを実行するのは、ユーザーが[そのプラグイン 1 つだけを単独でインストールまたは更新する](/docs/ja/plugins/host-marketplace#how-users-accept-a-headershelper-command)場合のみです。さらに、エントリがどのファイルにあるかによって次の 3 つのルールが適用されます。

* **`strict`**: マーケットプレイスの `marketplace.json` 内のエントリとは異なり、設定内のエントリには `"strict": false` は不要です。設定ファイルにはインライン化するマニフェストフィールドがないためです。[Strict モード](/docs/ja/plugins/marketplace-reference#strict-mode)を参照してください。
* **フォルダの信頼**: プロジェクトの `.claude/settings.json` または `.claude/settings.local.json` 内のエントリについては、ユーザーが[そのフォルダを信頼](/docs/ja/permissions#what-runs-before-you-trust-a-folder)した後にのみ、Claude Code はコマンドを実行します。
* **ヘッダーフィルター**: リポジトリがプロジェクトの `.claude/settings.json` や `.claude/settings.local.json` を提供できるため、Claude Code はそれらのファイル内のエントリから[リクエストのルーティングやクライアントの識別に関するヘッダー名](/docs/ja/plugins/host-marketplace#when-claude-code-skips-a-headershelper-command-or-drops-its-output)を削除します。Claude Code はカタログエントリと `--add-dir` ディレクトリの設定内のエントリにも同じフィルターを適用し、ユーザー設定、`--settings` ファイル、管理設定内のエントリにはフィルターを適用しません。

#### マーケットプレイスキーのエイリアス

Claude Code v2.1.232 以降では、`extraKnownMarketplaces` を `additionalMarketplaces` と、`strictKnownMarketplaces` を `allowedMarketplaces` と記述できます。Claude Code は各エイリアスを次のように扱います。

* それより前のバージョンはエイリアスを無視します。そのため、Claude Code のバージョンが混在するフリート向けの管理設定ファイルなど、古いバージョンも読み込むファイルでは正規の表記を使用してください。
* 正規のキーを受け付ける任意の設定ファイルで、Claude Code はエイリアスを正規のキーとまったく同じように読み込みます。
* Claude Code はファイルを更新する際に、`additionalMarketplaces` を `extraKnownMarketplaces` に書き換えることがあります。
* 1 つのファイルで両方の表記を設定した場合、Claude Code は正規のキーの値を使用し、エイリアスを無視します。

### `pluginConfigs`

プラグインの [`userConfig`](/docs/ja/plugins/manifest-reference#user-configuration) 設定ダイアログで入力した機密性のない回答を、プラグイン ID をキーとして保存します。ダイアログに入力すると Claude Code がこのキーをユーザー設定に書き込むため、手動で編集する必要はありません。機密性のあるオプションは Claude Code が代わりに macOS キーチェーンに保存し、キーチェーンが書き込みを拒否した場合は `~/.claude/.credentials.json` にフォールバックします。サポートされているキーチェーンがないプラットフォームでは、`~/.claude/.credentials.json` に保存します。

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

組み込みプラグインは、`@builtin` サフィックスを付けた同じキーの下にオプションを保存します。たとえば、Claude Code が `AGENTS.md` ファイルを読み込むかどうかを制御する [**Project instructions**](/docs/ja/memory#choose-which-instruction-files-load) 設定は `pluginConfigs["cc-plugin-agents-md@builtin"].options.instructionFiles` です。v2.1.285 より前は、このプラグインの ID は `agents-md@builtin` でした。それ以降のバージョンは、どちらの ID のエントリも読み込みます。

Claude Code はプロジェクトとローカルのエントリを無視します。これらの値はプラグインのフック、MCP、LSP の設定に代入されるため、クローンしたリポジトリがそれらを提供できてはならないからです。

### `prependPlugins`

ユーザーがインストールしたすべての mod より前に、記載順で [mod](/docs/ja/plugins/mods/overview) が実行される管理対象プラグインを列挙します。このキーを管理設定で設定する場合は、組み込みガードを維持するためにリストに `sec-default@builtin` を含めてください。管理設定では、Claude Code は組織のものとみなされないプラグインの id をスキップします。その条件と、2 つの順序指定キーがどのように連携するかについては、[組織の mod をインストールして順序を設定する](/docs/ja/plugins/mods/admin#install-your-organizations-mods)を参照してください。

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

ユーザーがインストールしたすべての mod の後に、記載順で [mod](/docs/ja/plugins/mods/overview) が実行される管理対象プラグインを列挙します。`prependPlugins` と `appendPlugins` の両方に記載された id は先頭に追加されます。管理設定では、Claude Code は[組織のものとみなされない](/docs/ja/plugins/mods/admin#install-your-organizations-mods)プラグインの id をスキップします。

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

Claude Code が接続する MCP サーバーと、組織が許可する MCP サーバーを制御します。[MCP で外部ツールに接続する](/docs/ja/mcp)と[管理対象 MCP 設定](/docs/ja/managed-mcp)を参照してください。

### `allowAllClaudeAiMcps`

Claude Code が自身で取得する[claude.ai コネクタ](/docs/ja/mcp#use-mcp-servers-from-claude-ai)を、デプロイされた `managed-mcp.json` と一緒に読み込みます。このキーがない場合、`managed-mcp.json` は MCP サーバーを排他的に制御し、これらのコネクタを抑制します。

* **スコープ**: [`Managed`](#scopes)。ユーザーは排他的制御によって抑制されたコネクタを再度有効にすることはできません。
* **タイプ**: ブール値
  * `true`: Claude Code は、デプロイされた `managed-mcp.json` と一緒に claude.ai コネクタを読み込みます
  * `false`: デプロイされた `managed-mcp.json` は MCP サーバーを排他的に制御し、Claude Code が自身で取得する[claude.ai コネクタ](/docs/ja/mcp#how-connectors-reach-claude-code)を抑制します
* **デフォルト**: `false`。デプロイされた `managed-mcp.json` は Claude Code が自身で取得する claude.ai コネクタを抑制します

```json managed-settings.json theme={null}
{
  "allowAllClaudeAiMcps": true
}
```

[`allowedMcpServers`](#allowedmcpservers)と[`deniedMcpServers`](#deniedmcpservers)は、このキーが読み込むコネクタにも適用されます。`managed-mcp.json` を持つホスト（自己ホスト型ランナーなど）の[クラウドセッション](/docs/ja/claude-code-on-the-web)に配信されるコネクタは、抑制されたままです。[管理対象セットと一緒に claude.ai コネクタを許可する](/docs/ja/managed-mcp#allow-claude-ai-connectors-alongside-the-managed-set)を参照してください。

### `allowClaudeInChromeWithManagedMcp`

デプロイされた `managed-mcp.json` と一緒に、組み込みの[Claude in Chrome](/docs/ja/chrome)サーバーを実行できるようにします。このキーがない場合、デプロイされた `managed-mcp.json` はターミナルセッションで Claude in Chrome をブロックします。Claude Code v2.1.282 以降が必要です。

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

`claude-in-chrome` の[`deniedMcpServers`](#deniedmcpservers)エントリは、このキーがオンの場合でもサーバーをブロックします。[管理対象セットと一緒に Claude in Chrome を許可する](/docs/ja/managed-mcp#allow-claude-in-chrome-alongside-the-managed-set)を参照してください。

### `allowedMcpServers`

ユーザーが追加できる MCP サーバーをホワイトリストに登録します。Claude Code は、プラグインサーバー、`--mcp-config` で渡されたサーバー、claude.ai からのサーバーを含め、どこで定義されていても、エントリに一致しないサーバーをブロックします。

Claude in Chrome、実行中の[VS Code](/docs/ja/vs-code#the-built-in-ide-mcp-server)または[JetBrains](/docs/ja/jetbrains#the-built-in-ide-mcp-server) IDE に Claude Code が接続する `ide` サーバー、CLI 自体が設定するサーバーなどの組み込みサーバーは、ホワイトリストから除外され、デニーリストは引き続きこれらに適用されます。Claude Code v2.1.268 以降では、[Claude Tag](/docs/ja/claude-tag)セッションの Slack ツールもホワイトリストから除外され、デニーリストは引き続きこれらに適用されます。インプロセス `type: "sdk"` サーバーは両方のリストから除外されます。[セッションを開始したアプリ](/docs/ja/mcp#how-connectors-reach-claude-code)がこれらを登録します。

組織が配信するサーバーもホワイトリストから除外され、デニーリストは引き続きこれらに適用されます。この除外は、すべての[`managedMcpServers`](#managedmcpservers)エントリと、`${VAR}` 展開を使用しない値を持つ[`managed-mcp.json`](/docs/ja/managed-mcp#exclusive-control-with-managed-mcp-json)エントリをカバーします。完全なチェック順序については、[サーバーの評価方法](/docs/ja/managed-mcp#how-a-server-is-evaluated)を参照してください。v2.1.259 より前では、`managed-mcp.json` からのサーバーも一致する必要がありました。

* **スコープ**: [`Any file`](#scopes)。[`allowManagedMcpServersOnly`](#allowmanagedmcpserversonly)が設定されていない限り、すべてのファイルからのエントリが 1 つのホワイトリストにマージされます。管理設定にデプロイして、これを強制します。
* **タイプ**: オブジェクトの配列。各オブジェクトは正確に 1 つのキーを持ちます。`serverName` は、文字、数字、ハイフン、アンダースコアに限定された文字列です。`serverCommand` は、コマンドとその引数を正確に一致させた配列です。または `serverUrl` は、`*` ワイルドカードを含む URL パターンです
* **デフォルト**: 未設定。すべてのサーバーが許可されます。空の配列は、ユーザーが追加するすべてのサーバーをブロックします

この例は、リストされた `npx` コマンドが開始する stdio サーバーのみを許可します。

```json settings.json theme={null}
{
  "allowedMcpServers": [
    { "serverCommand": ["npx", "-y", "@modelcontextprotocol/server-filesystem"] }
  ]
}
```

[`deniedMcpServers`](#deniedmcpservers)エントリが優先されるため、両方のリストにあるサーバーはブロックされます。リストに `serverCommand` エントリが含まれると、stdio サーバーは `serverCommand` エントリと一致する必要があり、`serverUrl` エントリが含まれると、リモートサーバーは `serverUrl` エントリと一致する必要があります。`serverName` の一致は、その種類のサーバーをもはや許可しません。[ホワイトリストとデニーリストを使用したポリシーベースの制御](/docs/ja/managed-mcp#policy-based-control-with-allowlists-and-denylists)を参照してください。

### `allowManagedMcpServersOnly`

管理対象ホワイトリストのみを適用対象にします。Claude Code は、ユーザー、プロジェクト、ローカル設定の `allowedMcpServers` を無視し、管理設定からのみ [`allowedMcpServers`](#allowedmcpservers) を読み込みます。[`deniedMcpServers`](#deniedmcpservers)は引き続きすべての設定スコープからマージされるため、ユーザーは自分自身のためにサーバーをブロックできます。管理者は、ユーザー自身の設定が管理対象ホワイトリストが許可するものを拡大できないようにするために、これを設定します。

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

ユーザーは引き続き独自の MCP サーバーを追加できます。管理対象ホワイトリストと一致するサーバーのみが読み込まれます。[ホワイトリストを管理設定のみに制限する](/docs/ja/managed-mcp#restrict-the-allowlist-to-managed-settings-only)を参照してください。

### `deniedMcpServers`

特定の MCP サーバーをブロックします。Claude Code は、プラグインサーバー、`--mcp-config` で渡されたサーバー、`managed-mcp.json` からのサーバー、[`managedMcpServers`](#managedmcpservers)からのサーバー、および[自身で取得する](/docs/ja/mcp#how-connectors-reach-claude-code)claude.ai コネクタを含め、どこで定義されていても、一致するサーバーの読み込みを拒否します。インプロセス `type: "sdk"` サーバーは除外されます。セッションを開始したアプリがこれらを登録します。

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

デニーリストは[`allowedMcpServers`](#allowedmcpservers)より優先されるため、両方のリストにあるサーバーはブロックされます。[ホワイトリストとデニーリストを使用したポリシーベースの制御](/docs/ja/managed-mcp#policy-based-control-with-allowlists-and-denylists)を参照してください。

### `disableClaudeAiConnectors`

[Claude Code が自身で取得する](/docs/ja/mcp#how-connectors-reach-claude-code)[claude.ai MCP コネクタ](/docs/ja/mcp#use-mcp-servers-from-claude-ai)をオフにして、取得も接続もしません。任意の設定ファイルで `true` が適用されます。チェックインされたプロジェクト `.claude/settings.json` はリポジトリをこれらのコネクタから除外できますが、プロジェクトレベルの `false` はユーザーレベルまたは管理レベルの `true` をオーバーライドできません。

* **スコープ**: [`Any file`](#scopes)
* **タイプ**: ブール値
  * `true`: Claude Code はこれらのコネクタを取得も接続もしません
  * `false`: 未設定と同じです。別の設定ファイルまたは `ENABLE_CLAUDEAI_MCP_SERVERS` がこれらをオフにしない限り、Claude Code はコネクタを取得します
* **デフォルト**: `false`。Claude Code はコネクタを取得します
* **セッションごとのオーバーライド**: [`ENABLE_CLAUDEAI_MCP_SERVERS`](/docs/ja/env-vars)を `false` に設定すると、1 つのセッションのコネクタがオフになります。2 つのうちどちらがオフにしても、もう一方はオンに戻すことはできません

```json settings.json theme={null}
{
  "disableClaudeAiConnectors": true
}
```

`--mcp-config` で明示的に渡すサーバーは影響を受けません。すべてのコネクタをブロックする代わりに個別のコネクタをブロックするには、[`deniedMcpServers`](#deniedmcpservers)を使用します。[claude.ai コネクタを無効にする](/docs/ja/mcp#disable-claude-ai-connectors)を参照してください。

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

* **スコープ**: [`Any file`](#scopes)。信頼ダイアログを受け入れていないフォルダでは、Claude Code はユーザー設定、管理設定、`--settings` からこれを尊重し、共有プロジェクトファイルではセッション内と `claude mcp list` および `claude mcp get` で無視します。[プロジェクトサーバーの承認とワークスペースの信頼](/docs/ja/mcp#project-server-approvals-and-workspace-trust)は、追跡されていない `.claude/settings.local.json` がいつカウントされるかを説明しています。
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

* **スコープ**: [`Any file`](#scopes)。信頼ダイアログを受け入れていないフォルダでは、Claude Code はユーザー設定、管理設定、`--settings` からこれを尊重し、共有プロジェクトファイルではセッション内と `claude mcp list` および `claude mcp get` で無視します。[プロジェクトサーバーの承認とワークスペースの信頼](/docs/ja/mcp#project-server-approvals-and-workspace-trust)は、追跡されていない `.claude/settings.local.json` がいつカウントされるかを説明しています。
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
* **タイプ**: サーバー名でキー付けされたオブジェクト。各エントリは `http` または `sse` サーバーの `.mcp.json` 形状を持ちます。必須の `https://` `url` と、オプションで `headers`、`oauth`、その他の HTTP および SSE オプション。Claude Code は検証に失敗したエントリをドロップし、[エントリに含まれる内容](/docs/ja/managed-mcp#what-an-entry-can-contain)は条件をリストします
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

優先度、提供されたサーバーが `managed-mcp.json` および許可リストと拒否リストとどのように組み合わされるか、およびユーザーが何を見るかについては、[管理設定を通じてサーバーを提供する](/docs/ja/managed-mcp#provide-servers-through-managed-settings)を参照してください。

## エージェント、セッション、worktree

デフォルトエージェントを設定し、チームメイトとクロスセッションメッセージングを制御し、worktree を設定します。[サブエージェント](/docs/ja/sub-agents)と [worktree](/docs/ja/worktrees) を参照してください。

### `agent`

メインスレッドを名前付き[サブエージェント](/docs/ja/sub-agents#invoke-subagents-explicitly)として実行し、Claude Code がそのサブエージェントのシステムプロンプト、ツール制限、およびモデルをセッションに適用するようにします。同じキーは `claude agents` からディスパッチするセッションのデフォルトエージェントも設定します。

* **スコープ**: [`任意のファイル`](#scopes)
* **タイプ**: 文字列、組み込みまたはカスタムエージェントの名前
* **デフォルト**: 未設定。メインスレッドは Claude Code のデフォルトエージェントとして実行されます
* **セッションごとの上書き**: `--agent` はこのキーより優先され、1 つのセッションに適用されます

```json settings.json theme={null}
{
  "agent": "code-reviewer"
}
```

プラグイン独自の `settings.json` もこのキーを提供できます。[プラグインでデフォルト設定を配布する](/docs/ja/plugins/components#default-settings)を参照してください。

### `crossSessionInbound`

このセッションが[他の Claude Code セッションから到着するメッセージ](/docs/ja/cross-session-messaging#control-inbound-messages)に対して何を行うかを選択します。値が適用されない場合、Claude Code は 2 つのセッションの権限モードクラスからメッセージごとに決定します。Claude Code v2.1.224 以降が必要です。

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

Claude Code は、認識しない値を設定すると[警告](/docs/ja/errors#crosssessioninbound-must-be-one-of-accept-hold-refuse)します。その値がユーザー、プロジェクト、ローカル、または `--settings` ファイルに存在する間、Claude Code は受信メッセージを保留します。優先されるソースが `accept` を設定している場合でも、です。別のソースが設定する `refuse` は依然として適用されます。値を修正または削除して保留をクリアします。

認識しない値が[管理設定](/docs/ja/managed-settings)にある場合、Claude Code は代わりに管理者が修正するまで `refuse` として扱います。v2.1.248 より前では、Claude Code は警告なしに認識しない値を無視していました。

### `disableAgentView`

[バックグラウンドエージェントとエージェントビュー](/docs/ja/agent-view)をオフにします：`claude agents`、`--bg`、`/background`、およびオンデマンドスーパーバイザー。[管理設定](/docs/ja/managed-settings)で設定して、組織に対して強制します。

* **スコープ**: [`任意のファイル`](#scopes)
* **タイプ**: ブール値
  * `true`: Claude Code は `claude agents`、`--bg`、`/background`、およびオンデマンドスーパーバイザーをオフにします
  * `false`: エージェントビューが利用可能です
* **デフォルト**: 未設定。エージェントビューが利用可能です
* **セッションごとの上書き**: [`CLAUDE_CODE_DISABLE_AGENT_VIEW`](/docs/ja/env-vars) は 1 つのセッションのエージェントビューをオフにします。2 つのいずれかがそれをオフにすると、もう一方はそれをオンに戻すことはできません

```json settings.json theme={null}
{
  "disableAgentView": true
}
```

### `isolatePeerMachines`

Claude の `SendMessage` がこのマシンを超えたセッションの 1 つに到達する前に、明示的な承認を要求します。[クロスマシンメッセージの承認を要求する](/docs/ja/cross-session-messaging#require-approval-for-cross-machine-messages)を参照してください。承認プロンプトは [`bypassPermissions` モード](/docs/ja/permission-modes#skip-all-checks-with-bypasspermissions-mode)でも表示されます。

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

macOS と Linux では、[Claude Code が開始するバックグラウンドプロセス](/docs/ja/corporate-launcher#what-the-launcher-covers)の前に企業ランチャーコマンドを配置します。Claude Code はランチャーを独自のコマンドラインを追加して実行するため、ランチャーは Claude Code に exec する必要があります。[企業ランチャーの背後で Claude Code を実行する](/docs/ja/corporate-launcher)を参照してランチャーコントラクトを確認してください。Claude Code v2.1.210 以降が必要です。

* **スコープ**: [`ユーザーまたは管理`](#scopes)
* **タイプ**: 文字列、argv プレフィックスとしてのランチャーコマンド（絶対パスとオプション引数など）
* **デフォルト**: 未設定。バックグラウンドプロセスはラップされずに開始されます
* **セッションごとの上書き**: [`CLAUDE_CODE_PROCESS_WRAPPER`](/docs/ja/env-vars) はこのキーより優先され、1 つのセッションに適用されます

```json settings.json theme={null}
{
  "processWrapper": "/opt/corp/launcher --profile claude"
}
```

Claude Code は Windows でランチャーを無視し、すべてのプロセスをラップされずに開始します。Claude Code v2.1.210 以降が必要です。

### `teammateMode`

Claude Code が[エージェントチーム](/docs/ja/agent-teams)のチームメイトを表示する場所を選択します：メインターミナルペイン内、またはターミナルがサポートしている場合は分割ペイン内。[表示モードを選択する](/docs/ja/agent-teams#choose-a-display-mode)を参照してください。

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

Claude Code が `--worktree`、`EnterWorktree` ツール、および分離されたサブエージェントとバックグラウンドセッションの [git worktree](/docs/ja/worktrees) を作成および管理する方法を設定します。

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

`.env` のような gitignore されたファイルを新しい worktree にコピーするには、設定の代わりに [`.worktreeinclude` ファイル](/docs/ja/worktrees#copy-gitignored-files-into-worktrees)をプロジェクトルートに追加します。

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

git sparse-checkout を通じて各 worktree にリストされたディレクトリのみをチェックアウトします。Claude Code はそれらのディレクトリとルートレベルのファイルのみをディスクに書き込みます。これは大規模なモノレポでより高速です。[必要なディレクトリのみをチェックアウトする](/docs/ja/large-codebases#check-out-only-the-directories-you-need)を参照してください。

* **スコープ**: [`任意のファイル`](#scopes)
* **タイプ**: 文字列の配列、リポジトリルートに相対的なディレクトリパス
* **デフォルト**: 未設定。各 worktree はツリー全体をチェックアウトします

この例は、各 worktree で `packages/my-app` と `shared/utils` のみをチェックアウトします（ルートレベルのファイルを含む）：

```json settings.json theme={null}
{
  "worktree": {
    "sparsePaths": ["packages/my-app", "shared/utils"]
  }
}
```

スパース worktree が存在する間、git はリポジトリの共有 `.git/config` で `extensions.worktreeConfig` を有効にします。

### `worktree.bgIsolation`

[バックグラウンドセッション](/docs/ja/agent-view#how-file-edits-are-isolated)がファイル編集を分離する方法を選択します。`←` または `/background` でセッションをバックグラウンドに移動した場合、このキーの値にかかわらず、そのセッションはファイルをその場で編集します。`"worktree"` では、Claude Code はセッションが `EnterWorktree` を呼び出すまでメインチェックアウトで `Edit` と `Write` をブロックします。`"none"` では、バックグラウンドジョブはワーキングコピーを直接編集します。git worktree が実用的でないリポジトリの場合は `"none"` を設定します。

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

git リポジトリの外では、失敗する [`WorktreeCreate` フック](/docs/ja/worktrees#non-git-version-control)がブロックを解放し、セッションが作業ディレクトリをその場で編集できるようにします。

### `worktree.location`

[Desktop の SSH セッション](/docs/ja/desktop#choose-where-ssh-session-worktrees-go)が worktree を作成するリモートマシン上のフォルダーを、`<project-root>/.claude/worktrees/` の代わりに選択します。このキーを読み込むのはデスクトップアプリのみです。`--worktree`、`EnterWorktree` ツール、分離されたサブエージェント、およびバックグラウンドセッションはこのキーを無視します。Claude Desktop v1.44121.0 以降が必要です。

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

Remote Control、クラウド環境、デスクトップアプリ、および Claude Code が必要な場合に送信する通知を設定します。[Remote Control](/docs/ja/remote-control) を参照してください。

### `agentPushNotifEnabled`

Claude が価値があると判断した場合（たとえば、長いタスクが完了した場合など）に、電話にプッシュ通知を送信することを許可します。Claude Code はこの選択をアカウントに同期し、[Remote Control](/docs/ja/remote-control) が接続されている間にプッシュが到着します。`/config` では **Push when Claude decides** として表示されます。

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

[Mobile push notifications](/docs/ja/remote-control#mobile-push-notifications) を参照してください。

### `awaySummaryEnabled`

数分間離れた後にターミナルに戻ったときに、1 行のセッション要約を表示します。`false` に設定するか、`/config` で **Session recap** をオフにして、要約を停止します。

* **Scope**: [`Any file`](#scopes)
* **Type**: Boolean
  * `true`: 数分間離れた後に戻ったときに、1 行のセッション要約が表示されます
  * `false`: Claude Code は要約を表示しません
* **Default**: 未設定なので、要約はオンです
* **Per-session overrides**: [`CLAUDE_CODE_ENABLE_AWAY_SUMMARY`](/docs/ja/env-vars) はこのキーより優先され、どちらの方向でも 1 セッションに適用されます

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

代わりに [`enableArtifact`](#enableartifact) を使用して、セッション出力を claude.ai 上のプライベート Web ページとして公開する [Artifact](/docs/ja/artifacts) ツールをオフにします。`/config` で **Artifacts** 行をオフにすると、Claude Code はユーザー設定に `enableArtifact` を書き込み、このキーをクリアします。

* **Scope**: [`Any file`](#scopes)
* **Type**: Boolean
  * `true`: Claude Code はファイルが適用されるすべてのセッションに対して Artifact ツールをオフにし、他のファイルはそれをオンに戻しません
  * `false`: 無視されます。ツールをオンのままにするには、キーを削除します
* **Default**: 未設定なので、ツールはアカウントの [availability](/docs/ja/artifacts#availability) に従います
* **Per-session overrides**: [`CLAUDE_CODE_DISABLE_ARTIFACT`](/docs/ja/env-vars) を `1` に設定すると、1 つのセッションのツールがオフになります

```json settings.json theme={null}
{
  "disableArtifact": true
}
```

[Disable artifacts](/docs/ja/artifacts#disable-artifacts) はツールをオフにするすべての方法を一覧表示します。

### `disableDeepLinkRegistration`

Claude Code が `claude-cli://` プロトコルハンドラーをオペレーティングシステムに登録することを停止します。通常、対話セッションの最初のプロンプトを送信した後に登録されます。[Deep links](/docs/ja/deep-links) により、外部ツールは事前入力されたプロンプトで Claude Code セッションを開くことができます。プロトコルハンドラー登録が制限されているか、別途管理されている環境でこれを設定します。

* **Scope**: [`Any file`](#scopes)
* **Type**: 文字列 `"disable"`
* **Default**: 未設定なので、Claude Code はハンドラーを登録します

```json settings.json theme={null}
{
  "disableDeepLinkRegistration": "disable"
}
```

### `disableDesktopLocalSessions`

開発者が SSH 経由でリモートマシンで作業する必要があるデプロイ向けに、[デスクトップアプリ](/docs/ja/desktop#local-sessions-on-managed-devices) でデバイス上で実行される Code セッションをオフにします。キーを `true` に設定すると、ユーザーには Code タブで次のように表示されます：

* **環境セレクター**: ユーザーのコンピューターのエントリはグレーアウトされて選択できなくなり、ツールチップ **Disabled by your organization** が表示されます。Windows では WSL エントリも同じようにグレーアウトされますが、WSL セッションが管理対象デバイスで実行されるかどうか自体は [別途管理されます](/docs/ja/admin-setup#wsl-sessions-in-claude-code-desktop)。
* **新しいセッション**: 設定されている場合は、最初の [SSH 接続](/docs/ja/desktop#ssh-sessions) がデフォルトになります
* **デバイス上のセッション**: アプリは、同じマシンへの SSH 接続を含め、デバイス上でのセッションの開始または再開を拒否します
* **他のホストへの SSH セッションとクラウドセッション**: 影響を受けません

デスクトップアプリはこのキーを読み取ります。ターミナル CLI は無視します。Claude Desktop v1.37937.0 以降が必要です。

* **Scope**: [`Managed`](#scopes)。デフォルトでは、デスクトップアプリは [1 つの管理ソース](/docs/ja/managed-settings#how-claude-code-combines-managed-sources) からキーを読み取ります。
* **Type**: Boolean。JSON Boolean `true` のみが有効です
  * `true`: デスクトップアプリはオンデバイスコードセッションを提供しません。既存のローカルセッションはリストに残りますが、続行できません
  * `false`: ローカルセッションは利用可能なままです
* **Default**: 未設定なので、ローカルセッションは利用可能です

```json managed-settings.json theme={null}
{
  "disableDesktopLocalSessions": true
}
```

デスクトップアプリは他の値を無視し、文字列 `"true"` や `1` などの Boolean ではない値も警告をログに記録します。[`sshConfigs`](#sshconfigs) とペアにして、ユーザーが機能する接続にアクセスし、[`sshHostAllowlist`](#sshhostallowlist) とペアにして、到達できるホストを制限します。[Local sessions on managed devices](/docs/ja/desktop#local-sessions-on-managed-devices) を参照してください。

Claude Desktop は、デスクトップ設定から派生したポリシー（たとえば、エグレス許可リスト、ファイルシステムサンドボックス、サードパーティデプロイメント内の MCP 制限など）を使用して Code セッションを提供します。Claude Code は、[管理ソース](/docs/ja/managed-settings#how-claude-code-combines-managed-sources) が存在する場合（サーバー管理設定、MDM または OS レベルのポリシー、またはマネージド設定ファイル）、常にそれらの親設定を無視します。サードパーティデプロイメントのように、以前にないデバイスにこのキーをデプロイすると、デスクトップ派生ポリシーが適用されなくなります。[Let an embedding host add policy](/docs/ja/managed-settings#let-an-embedding-host-add-policy) は、親設定がまだマージできる場合をカバーしています。これは、このキーだけでなく、その方法でデプロイするすべてのキーに適用されます。

### `disableRemoteControl`

[Remote Control](/docs/ja/remote-control) をオフにします。Claude Code は `claude remote-control`、`--remote-control` フラグ、自動開始、およびセッション内トグルを拒否し、組織のポリシーがそれを無効にしたことを報告します。[マネージド設定](/docs/ja/managed-settings) に配置して、デバイスごとの MDM 強制を行います。

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

セッション出力を claude.ai 上のプライベート Web ページとして公開する [Artifact](/docs/ja/artifacts) ツールをオフにします。`/config` で **Artifacts** 行をオフにすると、Claude Code はこのキーをユーザー設定に書き込むため、通常は手動で編集しません。

* **Scope**: [`Any file`](#scopes)。すべてのファイルはツールをオフにでき、どのファイルもそれをオンに戻すことはできません。
* **Type**: Boolean
  * `false`: Claude Code はファイルが適用されるすべてのセッションに対して Artifact ツールをオフにします
  * `true`: キーを未設定のままにするのと同じです。別のファイルからの `false`、[`CLAUDE_CODE_DISABLE_ARTIFACT`](/docs/ja/env-vars)、または組織の [管理設定](/docs/ja/artifacts#manage-artifacts-for-your-organization) をオーバーライドしないためです
* **Default**: 未設定なので、ツールはアカウントの [availability](/docs/ja/artifacts#availability) に従います

```json settings.json theme={null}
{
  "enableArtifact": false
}
```

ユーザー設定以外のソースがツールをオフのままにしている間、Claude Code は `/config` で **Artifacts** 行を非表示にします。そこでオンにしても何も変わらないためです。[Disable artifacts](/docs/ja/artifacts#disable-artifacts) はツールをオフにするすべての方法を一覧表示します。

### `inputNeededNotifEnabled`

権限プロンプトまたは質問が入力を待っているときに、電話にプッシュ通知を取得します。Claude Code はこれらを [Remote Control](/docs/ja/remote-control) が接続されている間のみ送信します。`/config` では **Push when actions required** として表示されます。

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

[Mobile push notifications](/docs/ja/remote-control#mobile-push-notifications) を参照してください。

### `preferredNotifChannel`

タスクが完了したときまたは権限プロンプトが待機しているときに Claude Code が通知する方法を選択します。[mod の通知](/docs/ja/plugins/mods/api#show-something-without-starting-a-turn) も同じ設定を使用します。`/config` では **Local notifications** として表示されます。

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

`"auto"` では、Claude Code は iTerm2、Ghostty、Kitty でデスクトップ通知を送信します。Terminal.app では、Terminal の可聴ベルをオフにした場合のみベル文字を鳴らし、他のターミナルでは何もしません。任意のターミナルでベル文字を鳴らすには `"terminal_bell"` を設定します。[Get a terminal bell or notification](/docs/ja/terminal-config#get-a-terminal-bell-or-notification) を参照してください。

### `remote.defaultEnvironmentId`

`claude --cloud` などの CLI から作成するクラウドセッション用のデフォルト [クラウド環境](/docs/ja/cloud-environments) を選択します。Claude Code は [`/remote-env`](/docs/ja/cloud-environments#select-an-environment-from-the-cli) で環境を選択するときに、このキーをユーザー設定に書き込みます。

* **Scope**: [`Any file`](#scopes)。自己ホスト環境 ID の場合、ユーザーまたはマネージド設定、または `--settings` フラグのみ。
* **Type**: 文字列、`env_...` または `ccpool_...` などの環境 ID
* **Default**: 未設定なので、Claude Code はリストに Anthropic ホスト環境がある場合はそれを使用し、そうでない場合は [Remote Control ブリッジ環境](/docs/ja/cloud-environments#the-default-environment) ではないリスト内の最初の環境を使用するか、すべてがブリッジ環境の場合は最初の環境を使用します
* **Per-session overrides**: `--environment` はこのキーより優先され、作成する 1 つのクラウドセッションに適用されます

```json settings.json theme={null}
{
  "remote": {
    "defaultEnvironmentId": "env_0123abcd"
  }
}
```

`env_` で始まる Anthropic ホスト環境 ID は標準設定の優先度に従うため、リポジトリのプロジェクト設定の値がユーザーレベルの選択をオーバーライドします。`ccpool_` で始まる [自己ホスト環境](/docs/ja/self-hosted-environments) ID は、ユーザー設定、マネージド設定、および `--settings` フラグからのみ尊重されます。Claude Code はリポジトリのプロジェクトまたはローカル設定のものを無視し、`/remote-env` は無視した値を表示するため、チェックインされたファイルは選択しなかった自己ホスト環境にセッションをステアリングできません。

### `remoteControlAtStartup`

各対話セッションの開始時に [Remote Control](/docs/ja/remote-control) を自動的に接続します。`/remote-control` を待つ代わりに。自動接続をオンにするには `true` に設定し、オフにするには `false` に設定します。`/config` では **Enable Remote Control for all sessions** として表示されます。

* **Scope**: [`Any file`](#scopes)。Claude Code は古いバージョンによって `~/.claude.json` に残された値も読み取ります。
* **Type**: Boolean
  * `true`: Claude Code は各対話セッションの開始時に Remote Control を自動的に接続します
  * `false`: Claude Code は `/remote-control` を待ちます
* **Default**: 未設定なので、[自動接続デフォルト](/docs/ja/remote-control#enable-remote-control-for-all-sessions) が適用されます
* **Per-session overrides**: `--remote-control` はこのキーが `false` の場合でも 1 つのセッションに対して Remote Control をオンにし、フラグは 1 つのセッションに対してそれをオフにしません

```json settings.json theme={null}
{
  "remoteControlAtStartup": true
}
```

Claude Code はプロジェクトまたはローカル設定からの `true` を無視するため、リポジトリはそのチェックアウトの自動接続をオフにできますが、オンにすることはできません。完全なスコープごとの動作については、[Enable Remote Control for all sessions](/docs/ja/remote-control#enable-remote-control-for-all-sessions) および [より厳密な値が適用されるセキュリティキー](/docs/ja/settings#security-keys-where-the-stricter-value-applies) を参照してください。

### `sshConfigs`

[Desktop](/docs/ja/desktop#pre-configure-ssh-connections-for-your-team) の環境セレクターに SSH 接続を追加します。管理者は `sshConfigs` を使用して、共有接続をチームに配布します。ユーザーは管理対象の接続を選択し、それに対して [独自の **Worktree folder** を設定](/docs/ja/desktop#set-the-worktree-folder-on-an-existing-connection) できます。アプリでそれ以外のフィールドを編集したり、接続を削除したりすることはできません。

* **Scope**: [`User or managed`](#scopes)。デスクトップアプリはこのキーを読み取ります。デフォルトでは、管理対象の接続を [1 つの管理ソース](/docs/ja/managed-settings#how-claude-code-combines-managed-sources) から読み取ります。
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

[Desktop SSH セッション](/docs/ja/desktop#restrict-which-ssh-hosts-users-can-connect-to) が接続できるホストを制限します。デスクトップアプリのみがこのキーを読み取ります。CLI は読み取りません。パターンは大文字と小文字を区別しません。`*` は任意のホストに一致し、`*.example.com` は `example.com` とすべてのサブドメインに一致し、その他は `~/.ssh/config` 解決後のホスト名に対する完全一致です。空の配列は SSH セッションをオフにします。

* **Scope**: [`Managed`](#scopes)。デフォルトでは、Desktop は [1 つの管理ソース](/docs/ja/managed-settings#how-claude-code-combines-managed-sources) からキーを読み取ります。
* **Type**: ホスト名パターンの配列
* **Default**: 未設定なので、任意のホストが許可されます

この例は、`devboxes.example.com` とそのサブドメイン、および正確なホスト `bastion.example.com` を許可します：

```json managed-settings.json theme={null}
{
  "sshHostAllowlist": ["*.devboxes.example.com", "bastion.example.com"]
}
```

`true` やオブジェクトなど、Desktop がホストのリストとして読み取れない値は、修正するまで空の配列として扱われます。ただし `null` は未設定として扱われます。Claude Desktop v2.26454.0 以降が必要です。

最上位のソースで [`managedSourcesBehavior`](#managedsourcesbehavior) を `"merge"` に設定すると、Desktop はすべての [管理ソース](/docs/ja/managed-settings#how-claude-code-combines-managed-sources) のリストを結合し、いずれかに一致するホストを許可します。あるソースで空の配列を設定しても、別のソースがリストしているホストに対しては SSH セッションはオンのままです。

## 認証とプロバイダー

ヘルパースクリプトを通じて認証情報を提供し、組織の場合はログイン方法または組織を強制します。[認証](/docs/ja/authentication)を参照してください。

### `allowedProviders`

マシンが Claude に到達できるサービス（Anthropic API、Amazon Bedrock、LLM ゲートウェイなど）をリストアップします。リストに記載されていないプロバイダー上のセッションは、スタートアップ時、ログイン時、および次に API に接続するときに拒否されるため、セッション中にリストに記載されていないプロバイダーに切り替えることも拒否されます。[拒否メッセージ](/docs/ja/errors#managed-settings-dont-allow-this-api-provider)には、プロバイダーを選択したものと続行するためのステップが記載されています。Claude Code v2.1.285 以降が必要です。

* **スコープ**: [`Managed`](#scopes)。マシン自身の管理者ソース（MDM ポリシーおよび管理設定ファイル）が設定したリストは、サーバー管理設定もリストを配信する場合でも適用され続けます。その場合、セッションは両方のリスト上のプロバイダーのみを使用できるため、サーバー管理リストはマシンが許可するものを狭めることはできますが、広げることはできません。マシンソースの `allowedProviders` のどれが数えられるかは、[Claude Code が管理ソースを組み合わせる方法](/docs/ja/managed-settings#how-claude-code-combines-managed-sources)に従います。サーバー管理設定のみを通じて配信されたリストは、[サーバー管理設定を取得する](/docs/ja/server-managed-settings#platform-availability)セッションのみに到達します。
* **タイプ**: 文字列の配列。各要素は以下のいずれか：
  * `"anthropic"`: claude.ai または Console サインイン、または API キーを通じた Anthropic 独自のホスト上の Anthropic API。[`forceLoginMethod`](#forceloginmethod) または [`forceLoginOrgUUID`](#forceloginorguuid) と組み合わせてサインインも制限します
  * `"bedrock"`: [Amazon Bedrock](/docs/ja/amazon-bedrock)
  * `"vertex"`: [Google Cloud の Agent Platform](/docs/ja/google-vertex-ai)（旧 Vertex AI）
  * `"foundry"`: [Microsoft Foundry](/docs/ja/microsoft-foundry)
  * `"anthropicAws"`: [AWS 上の Claude Platform](/docs/ja/claude-platform-on-aws)
  * `"mantle"`: Amazon Bedrock [Mantle エンドポイント](/docs/ja/amazon-bedrock#use-the-mantle-endpoint)。[Invoke API と並行して Mantle を実行する](/docs/ja/amazon-bedrock#run-mantle-alongside-the-invoke-api)セッションは両方のプロバイダーを使用するため、`"bedrock"` と `"mantle"` をまとめてリストアップします
  * `"customEndpoint"`: 別のホストに送信される Anthropic API またはクラウドプロバイダーの API。`ANTHROPIC_BASE_URL` や、`ANTHROPIC_BEDROCK_BASE_URL` などのプロバイダーのエンドポイント変数で指定された [LLM ゲートウェイ](/docs/ja/llm-gateway)などです。Claude Code はそれを管理 [`env`](#env) ブロックがピンで留めた正確な値に対してのみ許可します
  * `"gateway"`: [Cloud ゲートウェイ](/docs/ja/claude-apps-gateway)サインイン
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

* キャッシュの有効期限後。デフォルトは 5 分、または [`CLAUDE_CODE_API_KEY_HELPER_TTL_MS`](/docs/ja/env-vars) で設定した間隔
* Anthropic API へのリクエスト（直接または [LLM ゲートウェイ](/docs/ja/llm-gateway)経由）が `401` または `403` で失敗した場合
* Anthropic API へのリクエスト（直接または LLM ゲートウェイ経由）を送信する前に、キャッシュされた出力がヘルパーが生成した後に期限切れになった JWT である場合。Claude Code v2.1.246 以降が必要です。

最後の 2 つのケースは、ヘルパーの出力が Claude Code が送信する認証情報であり、`ANTHROPIC_AUTH_TOKEN` が設定されていない場合にのみ適用されます。

インタラクティブセッションでは、コマンドがプロジェクトまたはローカル設定から来ている場合、Claude Code はワークスペーストラストプロンプトを受け入れるまでコマンドを実行しません。[認証情報管理](/docs/ja/authentication#credential-management)を参照してください。

### `awsAuthRefresh`

`aws sso login` などの独自のコマンドを実行して、Claude Code が [Amazon Bedrock](/docs/ja/amazon-bedrock) に対して持つ認証情報が機能しなくなったときに `.aws` ディレクトリの認証情報をリフレッシュします。Claude Code は最初に現在の認証情報を STS に対してチェックし、そのチェックが失敗した場合にのみコマンドを実行してから、リフレッシュされた `.aws` ディレクトリを読み取ります。

同じコマンドと認証情報を使用する複数の Claude Code プロセス（別々のターミナルや IDE ウィンドウなど）で同時にチェックが失敗した場合、1 つのプロセスがコマンドを実行し、残りのプロセスは独自に実行を開始する代わりにその実行を待機します。リクエストを保留したまま 60 秒間待機したプロセスは、自らコマンドを実行します。この動作をオフにするには、[`CLAUDE_CODE_DISABLE_AUTH_REFRESH_LOCK`](/docs/ja/env-vars) を `1` に設定します。

* **スコープ**: [`Any file`](#scopes)
* **タイプ**: 文字列、シェルコマンドライン
* **デフォルト**: 未設定。Claude Code は AWS 認証情報をリフレッシュしません

```json settings.json theme={null}
{
  "awsAuthRefresh": "aws sso login --profile myprofile"
}
```

リフレッシュフローが `.aws` に書き込む場合はこのキーを使用します。代わりに認証情報を出力する場合は [`awsCredentialExport`](#awscredentialexport) を使用します。[高度な認証情報設定](/docs/ja/amazon-bedrock#advanced-credential-configuration)を参照してください。

### `awsCredentialExport`

AWS 認証情報を JSON として出力する独自のコマンドを実行して、Claude Code が `.aws` ディレクトリに存在しない認証情報で [Amazon Bedrock](/docs/ja/amazon-bedrock) を呼び出すことができるようにします。Claude Code は `aws sts` 出力形式とフラットな `aws configure export-credentials` 形式を受け入れ、認証情報を独自の Bedrock クライアントにスコープするため、Claude Code が実行するシェルコマンドは引き続き環境の認証情報を参照します。

* **スコープ**: [`Any file`](#scopes)
* **タイプ**: 文字列、シェルコマンドライン
* **デフォルト**: 未設定。Claude Code は環境の AWS 認証情報チェーンを使用します

```json settings.json theme={null}
{
  "awsCredentialExport": "/bin/generate_aws_grant.sh"
}
```

[`awsAuthRefresh`](#awsauthrefresh) とは異なり、Claude Code はこのコマンドが設定されている場合、環境の認証情報を最初にチェックせずに常に実行します。[高度な認証情報設定](/docs/ja/amazon-bedrock#advanced-credential-configuration)を参照してください。

### `forceLoginMethod`

ユーザーがログインできるアカウントの種類を制限します。`"claudeai"` を設定して claude.ai アカウントのみを許可するか、`"console"` を設定して Claude Console アカウントのみを許可するか、`"gateway"` を設定してファーストパーティログインの代わりに [クラウドゲートウェイ](/docs/ja/claude-apps-gateway)にユーザーを送信します。管理者は管理設定で設定し、[`forceLoginOrgUUID`](#forceloginorguuid) と組み合わせて開発者の claude.ai ログインを 1 つの組織内に保つことができます。任意の設定ファイルで `"claudeai"` または `"console"` に設定した場合、Claude Code はそのファイルが適用されるセッションで [キーレス Console サインイン](/docs/ja/authentication#sign-in-without-an-api-key)の提供も停止します。

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

すべてのファーストパーティログインパスが制限を適用します。[VS Code 拡張機能](/docs/ja/vs-code)、Agent SDK、`claude setup-token`、および `/install-github-app` を含みます。ただし、ターミナルのインタラクティブログイン画面（`/login` または初回実行オンボーディングで到達）は、メソッドを事前選択しますが強制しません。v2.1.212 より前は、ターミナルログインのみが適用されていました。[ログインを組織に制限する](/docs/ja/authentication#restrict-login-to-your-organization)を参照して、各ログインパス、環境認証情報、およびサードパーティプロバイダーがどのように処理されるかを確認してください。

マシン上の管理ソースが `"gateway"` を設定する場合、Claude Code は残されたログイン、API キー、または `apiKeyHelper` 認証情報を使用しません。各メッセージについては [管理者ポリシーがクラウドゲートウェイサインインを必要とします](/docs/ja/errors#administrator-policy-requires-a-cloud-gateway-sign-in)を参照してください。`CLAUDE_CODE_USE_BEDROCK` または同様の環境変数を通じてクラウドプロバイダーを選択する場合、セッションはゲートウェイサインインを必要としません。v2.1.261 より前は、Claude Code はこれらのマシンで残されたログインを使用していました。

### `forceLoginGatewayUrl`

`/login` クラウドゲートウェイ画面が接続するゲートウェイ URL を設定して、ユーザーがアドレスを入力せずに [クラウドゲートウェイ](/docs/ja/claude-apps-gateway)に到達できるようにします。画面には URL フィールドがありません。このキーが設定されている場合、ゲートウェイ URL を表示し、ユーザーが Enter キーを押すと接続します。設定されていない場合、IT 管理者に連絡するよう指示します。

管理設定では、このキーまたは `forceLoginMethod: "gateway"` のいずれかにより、`CLAUDE_CODE_USE_*` でクラウドプロバイダーを選択するセッションを除き、マシンはゲートウェイのみになります。その場合、`/login` はログイン方法ピッカーなしでクラウドゲートウェイ画面で開きます。残されたファーストパーティログインまたは API キーに何が起こるかについては、[管理者ポリシーがクラウドゲートウェイサインインを必要とします](/docs/ja/errors#administrator-policy-requires-a-cloud-gateway-sign-in)を参照してください。画面がエラーを表示する代わりに接続するように、両方のキーを設定します。

* **スコープ**: [`User or managed`](#scopes)。マシン上の管理ソースから読み取ります。`managed-settings.json`、macOS plist または Windows HKLM レジストリ、またはポリシーヘルパー。これらのいずれもないマシンでは、Claude Code v2.1.295 以降は [ユーザー設定](/docs/ja/claude-apps-gateway#set-the-gateway-url-in-user-settings)からも読み取ります。Claude Code は HKCU およびサーバー管理設定では無視します。
* **タイプ**: 文字列、スキームを含む完全な URL
* **デフォルト**: 未設定。クラウドゲートウェイ画面は IT 管理者に連絡するよう指示するエラーを表示します

```json managed-settings.json theme={null}
{
  "forceLoginGatewayUrl": "https://claude-gateway.example.com"
}
```

値が有効な URL でない場合、サインイン画面はそれを報告し、管理設定ファイルの残りは引き続き適用されます。[ゲートウェイ URL を設定する](/docs/ja/claude-apps-gateway#set-the-gateway-url)を参照してください。

### `forceLoginOrgUUID`

管理ソースから、claude.ai アカウントログインが 1 つの Anthropic 組織（単一の UUID として指定）または複数の組織（配列として指定）に属することを要求します。任意の設定ファイルから、Claude Code は単一の UUID を使用して claude.ai または Claude Console ログイン中にその組織を事前選択し、配列の場合は何も事前選択しません。任意の設定ファイルでキーを設定する場合、Claude Code はそのファイルが適用されるセッションで [キーレス Console サインイン](/docs/ja/authentication#sign-in-without-an-api-key)の提供も停止し、代わりに API キーを作成します。

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

[ログインを組織に制限する](/docs/ja/authentication#restrict-login-to-your-organization)を参照して、Claude Code が Claude Console ログイン、他のログインパス、および環境認証情報をどのように扱うかを確認してください。

### `gatewayInternalNetworks`

組織が内部ネットワークに番号を付ける公開 IPv4 ブロックを宣言して、`/login` が [クラウドゲートウェイ](/docs/ja/claude-apps-gateway)をそこで受け入れるようにします。Claude Code v2.1.268 以降が必要です。

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

エントリが無効であるか、値が文字列のリストでない場合、`/login` は問題を名前で指定し、値を修正するまでマシン上のすべての新しいゲートウェイサインインを拒否します。既存のサインインは機能し続けます。完全なルールと開発者が見るものについては、[所有する公開アドレススペース上のゲートウェイを許可する](/docs/ja/claude-apps-gateway#allow-a-gateway-on-public-address-space-you-own)を参照してください。

### `gcpAuthRefresh`

Claude Code が Google Cloud Application Default Credentials の有効期限が切れているか読み込めないことを検出したときにリフレッシュするために独自のコマンドを実行して、[Google Cloud の Agent Platform](/docs/ja/google-vertex-ai) リクエストが手動で再認証することなく機能し続けるようにします。

同じコマンドと認証情報を使用する複数の Claude Code プロセス（別々のターミナルや IDE ウィンドウなど）が同時に認証情報の期限切れを検出した場合、1 つのプロセスがコマンドを実行し、残りのプロセスは独自に実行を開始する代わりにその実行を待機します。リクエストを保留したまま 60 秒間待機したプロセスは、自らコマンドを実行します。この動作をオフにするには、[`CLAUDE_CODE_DISABLE_AUTH_REFRESH_LOCK`](/docs/ja/env-vars) を `1` に設定します。

* **スコープ**: [`Any file`](#scopes)
* **タイプ**: 文字列、シェルコマンドライン
* **デフォルト**: 未設定。Claude Code の認証情報エラーは `gcloud auth application-default login` を自分で実行するよう指示します

```json settings.json theme={null}
{
  "gcpAuthRefresh": "gcloud auth application-default login"
}
```

[高度な認証情報設定](/docs/ja/google-vertex-ai#advanced-credential-configuration)を参照してください。

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

[`CLAUDE_CODE_OTEL_HEADERS_HELPER_DEBOUNCE_MS`](/docs/ja/env-vars) でリフレッシュ間隔を設定します。スクリプトの要件とヘルパーが失敗した場合の動作については、[動的ヘッダー](/docs/ja/monitoring-usage#dynamic-headers)を参照してください。

## アップデートとバージョン管理

アップデートチャネルを選択し、組織の場合はユーザーが実行できるバージョンをピン留めします。[Claude Code を更新](/docs/ja/setup#update-claude-code)を参照してください。

### `autoUpdatesChannel`

[リリースチャネル](/docs/ja/setup#configure-release-channel)をバックグラウンド自動更新と `claude update` が従うかを選択します。通常約 1 週間前のバージョンで、大きな回帰を含むリリースをスキップする `"stable"` を設定するか、最新リリースの `"latest"` を設定します。

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

Claude Code は `/config` の **Auto-update channel** で選択すると、ユーザー設定に `"stable"` を書き込み、そこで最新に戻すとキーを削除します。`claude install stable` と `claude install latest` も、指定したチャネルを保存します。`/config` で `"latest"` から `"stable"` に切り替えると、ダウングレードを許可するか現在のバージョンにとどまるかを尋ねます。とどまることを選択すると、[`minimumVersion`](#minimumversion) が設定されます。Homebrew インストールはこのキーを無視します：`claude-code` cask は stable を追跡し、`claude-code@latest` は latest を追跡し、`claude update` は `brew upgrade` に従います。自動更新を完全に無効にするには、`env` で [`DISABLE_AUTOUPDATER`](/docs/ja/setup#disable-auto-updates) を設定します。

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

このキーは更新のみを制約します。Claude Code がバージョン以下で起動するのを拒否させるには、代わりに [`requiredMinimumVersion`](#requiredminimumversion) を使用します。[最小バージョンをピン留めする](/docs/ja/setup#pin-a-minimum-version)を参照してください。

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

[Claude Code デスクトップアプリ](/docs/ja/desktop)で特定のツールをオフにします。ターミナル CLI はこれらのキーを無視します。ツール自体については、[Claude が利用可能なツール](/docs/ja/tools-reference)を参照してください。

### `browserExternalPageTools`

デスクトップアプリの[ブラウザペイン](/docs/ja/desktop#browse-external-sites)で、Claude がそのツールを使用して外部ページを読み取ったり、外部ページに対して操作したりするのを停止します。組織内のユーザーは引き続き外部サイトを自分で開くことができ、ローカル開発サーバープレビューは Claude のツールで引き続き機能します。デスクトップアプリはこのキーを読み取ります。ターミナル CLI は無視します。

* **スコープ**: [`Managed`](#scopes)
* **タイプ**: 文字列、`"disabled"`。デスクトップアプリは`"disable"`も受け入れます。どちらの場合でも同じです
* **デフォルト**: 未設定。Claude のツールは外部ページで機能します

```json managed-settings.json theme={null}
{
  "browserExternalPageTools": "disabled"
}
```

その他の値を指定すると Claude のツールはオンのままになり、受け入れられた 2 つの値のいずれでもない空でない文字列は警告をログに記録します。ユーザーと Claude の両方に対して外部サイトをブロックするには、代わりに[`disableBrowserExternalNavigation`](#disablebrowserexternalnavigation)を設定してください。[組織の外部ブラウジングを制限する](/docs/ja/desktop#restrict-external-browsing-for-your-organization)を参照してください。

### `disableBrowserExternalNavigation`

デスクトップアプリの[ブラウザペイン](/docs/ja/desktop#browse-external-sites)で、ユーザーと Claude の両方に対して外部ブラウジングをオフにします。Localhost 開発サーバープレビューは引き続き機能します。デスクトップアプリはこのキーを読み取ります。ターミナル CLI は無視します。

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

デスクトップアプリはその他の値を無視し、文字列`"true"`や`1`などのブール値ではない値も警告をログに記録します。外部ブラウジングはオンのままにしておきたいが、Claude のツールを外部ページでオフにしたい場合は、代わりに[`browserExternalPageTools`](#browserexternalpagetools)を設定してください。[組織の外部ブラウジングを制限する](/docs/ja/desktop#restrict-external-browsing-for-your-organization)を参照してください。

### `disableMobileSimulatorTools`

デスクトップアプリの[iOS シミュレータペイン](/docs/ja/desktop-ios-simulator#turn-off-simulator-access)に対する Claude のツールをブロックします。ユーザーはペインの手動使用を継続できます。Claude のアクセスのみが削除され、アプリ内から誰もそれを再度オンにすることはできません。デスクトップアプリはこのキーを読み取ります。ターミナル CLI は無視します。

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

Claude Code がセッションデータをどのくらいの期間保持し、何を送信するかを制御します。使用メトリクスとエラーレポートをオフにするスイッチは、設定キーではなく環境変数です。[`env`](#env) キーまたはシェルで `DISABLE_TELEMETRY`、`DISABLE_ERROR_REPORTING`、または `CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC` を設定します。[テレメトリサービス](/docs/ja/data-usage#telemetry-services) では、各環境変数が何を停止するかについて説明しています。2 つの例外は設定ファイルからオフになります。以下の [`feedbackDrafts`](#feedbackdrafts) は Claude が作成したフィードバック用、および以下の [`feedbackSurveyRate`](#feedbacksurveyrate) はセッションサーベイ用です。

### `cleanupPeriodDays`

Claude Code が [セッショントランスクリプトおよび他のアプリケーションデータ](/docs/ja/claude-directory#cleaned-up-automatically) を削除する前に保持する日数を設定します。Claude Code はセッション開始後にバックグラウンド削除を実行します。保持期間を安全に判定できる限り実行されます。削除スイープはメッセージを表示せずにトランスクリプトを削除するため、保持期間より長く使用していないセッションは [`/resume`](/docs/ja/sessions#resume-a-session) ピッカーに表示されなくなります。

* **スコープ**: [`Any file`](#scopes)
* **タイプ**: 日数、整数、最小値 `1`
* **デフォルト**: `30`

```json settings.json theme={null}
{
  "cleanupPeriodDays": 20
}
```

`0` を設定するとバリデーションが失敗するため、長期保持の場合は `3650` などの大きな値を選択してください。Claude Code がトランスクリプトを書き込まないようにするには、[プレーンテキストストレージ](/docs/ja/claude-directory#plaintext-storage) を参照してください。

### `desktopSessionCleanupPeriodDays`

Claude Desktop または Cowork で開始または最後に続行したセッションのトランスクリプトに対して、日数での年齢制限を設定します。このキーがない場合、Claude Code は [それらのトランスクリプトを任意の年齢で保持します](/docs/ja/claude-directory#cleaned-up-automatically)。Claude Code は各トランスクリプトが、この制限と [`cleanupPeriodDays`](#cleanupperioddays) の両方より古い場合に削除します。したがって、`cleanupPeriodDays` がデフォルトの 30 の場合、`7` の値でも 30 日間保持されます。[自動クリーンアップ](/docs/ja/claude-directory#cleaned-up-automatically) には、代わりに `cleanupPeriodDays` が適用され、Claude Code がこのキーを無視するケースが記載されています。Claude Code v2.1.248 以降が必要です。

* **スコープ**: [`User or managed`](#scopes)。Claude Code は `--settings` で渡すファイルからキーを読み込み、プロジェクトおよびローカル設定では無視します。
* **タイプ**: 日数、整数、最小値 `0`
* **デフォルト**: `0`。年齢制限を設定しません

```json settings.json theme={null}
{
  "desktopSessionCleanupPeriodDays": 90
}
```

### `feedbackDrafts`

[Claude が作成したフィードバック](/docs/ja/tools-reference#sendfeedback-tool-behavior) を制御します。Claude がレビュー用のフィードバックドラフトをキューに入れることができるかどうか、および Claude Code が Claude がドラフトをキューに入れたときにカードを表示するかどうかを制御します。

* **スコープ**: [`User or managed`](#scopes)
* **タイプ**: 文字列。`"notify"`、`"quiet"`、または `"off"` のいずれか
  * `"notify"`：Claude Code は Claude がドラフトをキューに入れたときにプロンプトの上にカードを表示します。デフォルトではセッションあたり [最大 3 枚のカード](/docs/ja/tools-reference#what-you-see-when-claude-drafts)
  * `"quiet"`：Claude はカードなしでドラフトを作成します。プロンプトフッターでキューに入れられたドラフトの数を確認し、`/feedback` でレビューします
  * `"off"`：Claude Code は SendFeedback ツールを削除するため、Claude はドラフトをキューに入れることができません
* **デフォルト**: `"notify"`
* **セッションごとのオーバーライド**: [`CLAUDE_CODE_SEND_FEEDBACK`](/docs/ja/env-vars) を `0` に設定すると、1 つのセッションでこの機能がオフになります

```json settings.json theme={null}
{
  "feedbackDrafts": "quiet"
}
```

`/config` に **Claude-drafted feedback** として表示されます。これはこのキーをユーザー設定に書き込みます。`/config` 行は [Claude がフィードバックドラフトを作成できるセッション](/docs/ja/tools-reference#sessions-without-claude-drafted-feedback) でのみ表示されます。`"off"` を設定してもこれは非表示にならないため、同じ行から機能を再度オンにできます。管理設定の値はユーザー設定より優先されるため、管理者がこのキーを設定すると、行は管理値を表示し、変更しても効果がありません。Claude Code はプロジェクトおよびローカル設定でこのキーを無視します。

### `feedbackSurveyRate`

[セッション品質サーベイ](/docs/ja/data-usage#session-quality-surveys) がセッションがそれに適格である場合に表示される確率を設定します。`0` を設定してサーベイが表示されないようにします。

* **スコープ**: [`Any file`](#scopes)
* **タイプ**: `0` から `1` の間の数値
* **デフォルト**: 未設定。Claude Code は Anthropic がリモートで設定する率を使用するか、Amazon Bedrock、Google Cloud の Agent Platform、および Microsoft Foundry でのビルトイン率 `0.005` を使用します。これらはリモート設定を受け取りません
* **セッションごとのオーバーライド**: [`CLAUDE_CODE_DISABLE_FEEDBACK_SURVEY`](/docs/ja/env-vars) を `1` に設定すると、このキーが設定する率に関係なく、1 つのセッションでサーベイがオフになります

```json settings.json theme={null}
{
  "feedbackSurveyRate": 0.05
}
```

同じ率が VS Code 拡張機能のサーベイに適用されます。

### `skipWebFetchPreflight`

[WebFetch ドメイン安全性チェック](/docs/ja/data-usage#webfetch-domain-safety-check) をスキップします。このチェックは、フェッチする前に各リクエストされたホスト名を `api.anthropic.com` に送信します。Amazon Bedrock、Google Cloud の Agent Platform、または Microsoft Foundry デプロイメント（制限的な出力を持つ）など、Anthropic へのトラフィックをブロックする環境で `true` を設定します。

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

チェックがスキップされた場合、WebFetch はブロックリストを参照せずに任意の URL を試行するため、Claude が到達できるドメインを制限する必要がある場合は [`WebFetch` 権限ルール](/docs/ja/permissions#webfetch) と組み合わせてください。

## エンタープライズおよび管理設定

組織が管理設定を計算、更新、および組み合わせるために使用するキー。[管理設定の設定](/docs/ja/admin-setup)を参照してください。

### `disableSideloadFlags`

起動時に `--plugin-dir`、`--plugin-url`、`--agents`、および `--mcp-config` CLI フラグを拒否します。これらのフラグは、ユーザーが [`strictKnownMarketplaces`](#strictknownmarketplaces) を単一実行でバイパスするために渡す可能性があります。Claude Code はエラーで終了し、拒否されたフラグを名前で指定します。[クラウドセッション](/docs/ja/claude-code-on-the-web)では、Claude Code はセッションを開始し、サーバーが配信した `--mcp-config` エントリをドロップします。ただし、プロセス内 `type: "sdk"` エントリと [Claude Tag](/docs/ja/claude-tag) セッションの Slack ツールは除きます。Claude Code v2.1.193 以降が必要です。

* **スコープ**: [`Managed`](#scopes)
* **タイプ**: ブール値
  * `true`: Claude Code は起動時に `--plugin-dir`、`--plugin-url`、`--agents`、および `--mcp-config` を拒否し、エラーで終了して名前を指定します。クラウドセッションでは、セッションを開始し、サーバーが配信した `--mcp-config` エントリをドロップします。ただし、プロセス内 `type: "sdk"` エントリと Claude Tag セッションの Slack ツールは除きます
  * `false`: Claude Code はこれらのフラグを受け入れます
* **デフォルト**: `false`

```json managed-settings.json theme={null}
{
  "disableSideloadFlags": true
}
```

Claude Code は、サーバーがすべてプロセス内 `type: "sdk"` エントリである `--mcp-config` を受け入れます。これにより、Agent SDK と VS Code 拡張機能は動作し続けます。ユーザーは `claude mcp add` またはファイル `.mcp.json` でサーバーを追加できます。サーバーごとの制御については、[`allowedMcpServers`](/docs/ja/managed-mcp) も設定してください。Claude Code v2.1.193 以降が必要です。

同じチェックは、[`CLAUDE_CODE_PLUGIN_DIRS`](/docs/ja/env-vars#variables) 環境変数で名前が付けられたプラグインフォルダをカバーします。これには Claude Code v2.1.280 以降が必要です。変数がフォルダを名前で指定する場合、Claude Code は同じエラーで終了し、エラーは変数をアンセットするように指示します。

クラウドセッションでは、Claude Code はセッション中の MCP 更新も無視します。これは、クラウドセッション構成と SDK `setMcpServers()` 呼び出しの背後にあるパスです。プロセス内 `type: "sdk"` エントリと Claude Tag セッションの Slack ツールはそこでも除外されたままです。v2.1.268 より前では、このドロップと起動ドロップの両方も Claude Tag セッションの Slack ツールを削除していました。v2.1.239 より前では、サーバーが配信した `--mcp-config` はクラウドセッションの開始をブロックしていました。

デスクトップアプリは、claude.ai から同期されたプラグインや、組織がアプリを通じてデプロイするプラグインを含む、いくつかのプラグインを自身で管理します。MDM、OS レベルのポリシー、または管理設定ファイルを通じてこのキーをデバイスにデプロイする場合、デスクトップアプリはそれらのプラグインを、そのデバイス上の以下のセッションに渡しません:

* **[ユーザーのマシン上のコードセッション](/docs/ja/desktop#environment-configuration)**: ユーザーの claude.ai アカウントに対して有効になっているスキルなしでも開始します。Claude Code が管理設定のマーケットプレイスからインストールするプラグインは引き続きロードされます。[Claude Desktop on 3P](https://claude.com/docs/third-party/claude-desktop/overview) では、デバイスの `org-plugins` ディレクトリにデプロイするプラグインからの MCP サーバーは利用可能なままです。デスクトップアプリが自身でそれらに接続するため。Claude Desktop v1.37937.0 より前では、これらのセッションは起動時に失敗していました。
* **[ユーザーのマシン上の Cowork セッション](/docs/ja/managed-settings#where-and-when-a-policy-applies)**: それらのプラグイン内のスキルとユーザーの claude.ai アカウントに対して有効になっているスキルは利用可能なままです。[Claude Desktop on 3P](https://claude.com/docs/third-party/claude-desktop/overview) では、デバイスの `org-plugins` ディレクトリにデプロイするプラグインからの MCP サーバーは利用可能なままです。デスクトップアプリが自身でそれらに接続するため。Claude Desktop v1.44121.0 より前では、これらのセッションは起動時に失敗していました。

### `forceRemoteSettingsRefresh`

Claude Code が [サーバー管理設定](/docs/ja/server-managed-settings) を新たに取得するまで CLI 起動をブロックします。取得に失敗した場合、Claude Code はキャッシュされた設定または設定なしで続行する代わりに終了します。環境が管理ポリシーなしでセッションが実行される短い時間枠を受け入れられない場合に設定します。

キーが設定されていない場合、Claude Code は取得時に起動をブロックしません。ただし、開発者が起動時にサインインする場合、取得を最大 5 秒間待機します。Cloud ゲートウェイセッションは常に待機し、ゲートウェイに到達できない場合は終了します。

* **スコープ**: [`Managed`](#scopes)。Claude Code は、最優先度のソースでなくても、管理者が制御する管理ソースからの `true` を尊重します。
* **タイプ**: ブール値
  * `true`: Claude Code は起動をブロックして、サーバー管理設定を新たに取得するまで待機し、取得に失敗した場合は終了します
  * `false`: Claude Code は取得時に起動をブロックしません。ただし、サインイン起動では最大 5 秒間待機します
* **デフォルト**: `false`

```json managed-settings.json theme={null}
{
  "forceRemoteSettingsRefresh": true
}
```

MDM プロファイルまたは管理設定ファイルで設定して、最初のサーバーペイロードが到着する前に失敗時閉鎖起動を強制します。Claude Code は、サーバー管理設定を取得するセッションでのみチェックを適用します。[それらを取得しないセッション](/docs/ja/server-managed-settings#platform-availability)は待機なしで開始します。`claude auth` サブコマンドは除外されるため、ユーザーは期限切れの認証情報が取得に失敗する理由である場合に再認証できます。[失敗時閉鎖起動を強制する](/docs/ja/server-managed-settings#enforce-fail-closed-startup)を参照してください。

### `managedSourcesBehavior`

Claude Code が、組織が配信する最優先度の [管理ソース](/docs/ja/managed-settings#how-claude-code-combines-managed-sources) のみを適用するか、配信するすべての管理者ソースを組み合わせるかを選択します。デフォルトでは、Claude Code は [ポリシーキー](/docs/ja/managed-settings#how-claude-code-combines-managed-sources) を含む最優先度のソースを取得し、残りを無視します。ポリシーキーは、このキーと `wslInheritsWindowsSettings` 以外の設定キーです。そのデフォルトでは、サーバー管理設定または MDM ポリシーがポリシーキーを配信すると、`managed-settings.json` ファイルは [Claude Code がすべての管理ソースから読み取るキー](/docs/ja/managed-settings#keys-read-from-every-admin-source) のみを提供します。`"merge"` を使用すると、配信するすべての管理ソースがそのキーを 1 つの組み合わせたポリシーに提供します。Claude Code v2.1.242 以降が必要です。

`"merge"` は、[ランク付けされた](/docs/ja/managed-settings#how-claude-code-combines-managed-sources) 最優先度のソースの下のすべてのソースが管理者の制御下にある場合にのみ設定してください。Claude Code は、`permissions.allow` ルールなどの下位ソースからのエントリをポリシーに追加します。

* **スコープ**: [`Managed`](#scopes)。Claude Code はこのキーを、このキーまたはポリシーキーを含む最優先度のソースから読み取り、ランク付けされた下位のすべてのソースでこのキーを無視します。下位ソースは、上位のソースとの組み合わせにオプトインできません。Windows HKCU レジストリも [埋め込みホストからの親設定](/docs/ja/managed-settings#let-an-embedding-host-add-policy) も、マージに参加しません。
* **タイプ**: 文字列、次のいずれか:
  * `"first-wins"`: ポリシーキーを含む最優先度のソースがポリシーを提供し、下位ソースは [Claude Code がすべての管理ソースから読み取るキー](/docs/ja/managed-settings#keys-read-from-every-admin-source) のみを提供します
  * `"merge"`: 配信するすべての管理ソースがそのキーを提供し、以下のルールで組み合わせられます
* **デフォルト**: `"first-wins"`

デプロイする最優先度のソースでキーを配信します。サーバー管理設定を受け取らないマシンは、Claude Code がこのキーまたはポリシーキーを含む最優先度のソースからキーを読み取るため、MDM プロファイルにもキーが必要です。`managed-settings.json` ファイルは最下位の管理ソースであるため、そこに設定された `"merge"` は、それと組み合わせる下位ソースがありません。サーバー管理設定では、キーは次のようになります:

```json theme={null}
{
  "managedSourcesBehavior": "merge"
}
```

`"merge"` では、Claude Code は各キーをそのタイプで組み合わせます。このテーブルは各タイプのルールを示します。制限許可リスト、値全体取得、および最優先度ソースのみの行は、カバーするすべてのキーを名前で指定し、他の行は例を示します:

| キーのタイプ | Claude Code がそれを組み合わせる方法 | キー |
| :- | :- | :- |
| リスト | すべてのソースからのエントリを組み合わせます | [`permissions.allow`](#permissions-allow)、[`sandbox.network.allowedDomains`](#sandbox-network-alloweddomains)、およびその他のリストキー |
| ロック | ソースが設定する最も厳密な値を適用します。ソースが厳密な値を設定しない場合、最優先度のソースからのみより緩い値を適用します | [`allowManagedPermissionRulesOnly`](#allowmanagedpermissionrulesonly)、[`permissions.disableBypassPermissionsMode`](#permissions-disablebypasspermissionsmode)、およびその他のブール値または列挙型ロック |
| 制限許可リスト | 下位ソースからのエントリを追加せずに、それを設定する最優先度のソースから全体を取得します。最優先度のソースが設定しない場合、次のソースから全体を取得します | [`availableModels`](#availablemodels)、[`allowedMcpServers`](#allowedmcpservers)、[`allowedProviders`](#allowedproviders)、[`strictKnownMarketplaces`](#strictknownmarketplaces)、[`allowedChannelPlugins`](#allowedchannelplugins)、および [`fallbackModel`](#fallbackmodel) チェーン |
| 値全体取得 | 下位ソースからのエントリまたはフィールドを組み合わせずに、それを設定する最優先度のソースから全体を取得します。最優先度のソースが設定しない場合、次のソースから全体を取得します | [`sandbox.credentials.awsPairs`](#sandbox-credentials-awspairs)、[`sandbox.ripgrep`](#sandbox-ripgrep) |
| 提供される MCP サーバー | すべてのソースからサーバー名を組み合わせます。2 つのソースが同じ名前を設定する場合、上位ソースの全体エントリを適用します | [`managedMcpServers`](#managedmcpservers) |
| 最優先度のソースからのみ読み取ります | ポリシーキーを含む最優先度のソースからのみキーを読み取るため、最優先度のソースが何も設定しない場合でも、下位ソースの値は無視されます | [`apiKeyHelper`](#apikeyhelper)、[`awsAuthRefresh`](#awsauthrefresh)、[`awsCredentialExport`](#awscredentialexport)、[`gcpAuthRefresh`](#gcpauthrefresh)、[`otelHeadersHelper`](#otelheadershelper)、`proxyAuthHelper`、[`forceLoginOrgUUID`](#forceloginorguuid)、[`forceLoginMethod`](#forceloginmethod) の `"claudeai"` および `"console"` 値、[`parentSettingsBehavior`](#parentsettingsbehavior)、[`modelPicker`](#modelpicker)、[`policyHelper`](#policyhelper)、[`permissions.defaultMode`](#permissions-defaultmode) |
| `env` | [管理ソース全体で変数ごとにマージします](/docs/ja/managed-settings#keys-read-from-every-admin-source)。`"first-wins"` と `"merge"` の両方で | [`env`](#env) |
| その他のすべてのキー | それを設定する最優先度のソースから値を取得します | [`cleanupPeriodDays`](#cleanupperioddays)、[`model`](#model) |

`sandbox.credentials.awsPairs` と `sandbox.ripgrep` を全体で取得するには、Claude Code v2.1.257 以降が必要です。

いくつかのキーは、テーブルが示さない条件を追加します:

* **[`policyHelper`](#policyhelper)**: Claude Code は、ポリシーキーを含む最優先度のソースが MDM ポリシーまたは管理設定ファイルである場合にのみそれを尊重します。サーバー管理設定では適用されません。
* **[`modelOverrides`](#modeloverrides)**: `availableModels` とペアになります。Claude Code は、それを設定する最優先度のソースから `modelOverrides` を取得します。ただし、上位ソースが `modelOverrides` なしで `availableModels` を設定する場合は除きます。その場合、すべてのソースから `modelOverrides` を無視します。
* **[`forceLoginGatewayUrl`](#forcelogingatewayurl)、[`gatewayInternalNetworks`](#gatewayinternalnetworks)、および [`forceLoginMethod`](#forceloginmethod) の `"gateway"` 値**: Claude Code はサーバー管理設定からそれらのいずれも読み取りません。そのため、そこでの値は適用されず、MDM ポリシーまたは管理設定ファイルで設定されたものを隠しません。マシン上の管理ソースの中で、ポリシーキーを含む最優先度のソースのみがそれらを提供します。サーバー管理設定も存在するかどうかに関わらず。
* **[`allowedProviders`](#allowedproviders)**: テーブルのルールの後、マシン自体のリストは結果を制限し続けます。そのエントリの Scope ノートが述べているように。

マシンで組み合わせたソースを確認するには、`/status` を実行し、[`Setting sources` 行を読んでください](/docs/ja/managed-settings#read-the-source-in-/status)。

### `parentSettingsBehavior`

Claude Code が、Agent SDK または IDE 拡張機能などの埋め込みホストプロセスによって提供される管理設定を適用するかどうかを選択します。管理者がデプロイした管理層も存在する場合。`"first-wins"` では、Claude Code はホスト提供の設定をドロップします。`"merge"` では、制限のみのフィルターを通じて管理層の下で適用します。ホストが起動するセッションに独自の制限を渡す必要がある場合、`"merge"` を設定します。たとえば、Claude Desktop がゲートウェイの出力許可リストを配信する場合。

* **スコープ**: [`Managed`](#scopes)。Claude Code はそれを最優先度の管理者制御管理ソースから読み取ります。
* **タイプ**: 文字列、次のいずれか:
  * `"first-wins"`: Claude Code は、管理者がデプロイした管理層が存在する場合、ホスト提供の設定をドロップします
  * `"merge"`: Claude Code は、制限のみのフィルターを通じて管理層の下でホスト提供の設定を適用します
* **デフォルト**: `"first-wins"`

```json managed-settings.json theme={null}
{
  "parentSettingsBehavior": "merge"
}
```

管理者がデプロイした管理層が存在しない場合、このキーは効果がありません。ホストの設定は、唯一の管理層として適用されます。制限値にフィルターされたままです。フィルターの制限と管理ソースの相互作用については、[埋め込みホストからの親設定](/docs/ja/managed-settings#parent-settings-from-embedding-hosts) および [親設定を制限する](/docs/ja/claude-apps-gateway#restrict-parent-settings) を参照してください。

### `policyHelper`

起動時に管理設定を計算するためにデプロイする実行可能ファイルを実行します。デバイスの状態、ID、またはリモートサービスから静的ファイルの代わりにポリシーを導出できます。Claude Code はヘルパーを実行してから最初のプロンプトを受け入れ、それが出力する設定をセッションの管理設定として扱います。

* **スコープ**: [`Managed`](#scopes)。macOS plist、Windows HKLM レジストリ、または管理設定ファイルから読み取ります。Claude Code は、[ポリシーキー](/docs/ja/managed-settings#how-claude-code-combines-managed-sources) を含む最優先度の管理ソースからキーを読み取り、そのソースが 3 つのうちの 1 つである場合にのみヘルパーを実行します。サーバー管理設定、HKCU レジストリ、およびホスト提供の親設定ではキーを無視します。
* **タイプ**: `path`、`timeoutMs`、および `refreshIntervalMs` を含むオブジェクト
* **デフォルト**: 設定されていないため、ヘルパーは実行されません

サーバー管理設定が起動時にポリシーを配信する場合、ヘルパーのソースより優先され、ヘルパーは実行されません。

後の設定取得がサーバー管理設定が削除されたことを報告する場合、Claude Code はその時点でヘルパーを実行します。次の起動を待つ代わりに。その出力はセッションの残りを管理し、失敗した実行は [失敗した起動実行](#helper-failures) と同じメッセージでセッションを終了します。

この例は、5 秒のタイムアウトでヘルパーを実行し、5 分ごとに再実行します:

```json managed-settings.json theme={null}
{
  "policyHelper": {
    "path": "/usr/local/bin/claude-policy",
    "timeoutMs": 5000,
    "refreshIntervalMs": 300000
  }
}
```

#### ヘルパー出力を書き込む

Claude Code はヘルパーを引数なしで実行し、その環境に `CLAUDE_CODE_VERSION` を設定し、stdout から JSON エンベロープを読み取ります。1 MiB でキャップされます。

設定を `managedSettings` キーの下に配置します。`managedSettings` キーのない裸の設定オブジェクトは、`managedSettings` が未定義で何も適用されず、Claude Code はエラーを報告しません:

```json theme={null}
{
  "managedSettings": {
    "permissions": { "deny": ["Read(//etc/secrets/**)"] }
  }
}
```

ヘルパーが `managedSettings` を出力する場合、そのオブジェクトは実行の唯一の管理設定ソースになります。Claude Code は MDM、ファイル、および HKCU ソースを無視し、[クロスソースキー](/docs/ja/managed-settings#keys-read-from-every-admin-source) をヘルパーの出力からのみ読み取り、[親設定](/docs/ja/managed-settings#parent-settings-from-embedding-hosts) をマージしません。

起動 `forceRemoteSettingsRefresh` チェックはヘルパーの前に実行され、任意の管理ソースを読み取ります。ヘルパーが `managedSettings` を省略するエンベロープで `0` で終了する場合、管理設定を提供しません。他のソースは通常どおり適用されます。

#### ヘルパーの失敗

ヘルパー実行は次の場合に失敗します:

* `path` は [`policyHelper.path`](#policyhelper-path) のルールを破ります。
* `path` に通常ファイルがありません。Claude Code は、同じ `timeoutMs` 予算内でヘルパーを開始する前にファイルをチェックするため、応答しないネットワークマウントは実行を失敗させる可能性があります。
* ヘルパーが 0 以外で終了し、`timeoutMs` が経過してもまだ実行中であるか、まったく開始しません。たとえば、実行可能でないため。
* ヘルパーが stdout または stderr に 1 MiB 以上を書き込みます。
* stdout は単一の JSON オブジェクトではないか、その `managedSettings` に [Claude Code が修復できないスキーマ違反](/docs/ja/managed-settings#find-entries-claude-code-dropped) があります。

起動実行が失敗する場合、Claude Code は理由を出力し、起動を拒否します。0 以外の終了後、理由にはヘルパーの stderr が含まれます。stderr が空の場合は stdout が含まれます。タイムアウト後、理由は `timeoutMs` 制限を名前で指定し、ヘルパーの出力は含まれません。拒否は、対話型セッション、`claude -p`、Agent SDK セッション、[バックグラウンドセッション](/docs/ja/agent-view)、およびほとんどのサブコマンドをカバーします。

拒否は意図的なため、停止復旧が必要なヘルパーは独自のキャッシュから提供し、`0` で終了する必要があります。

バックグラウンド更新が失敗する場合、Claude Code は最後に成功したポリシーを有効に保ち、`/status` は失敗した更新をその理由とともに表示します。更新が成功するまで。各更新は、起動実行と同じ `timeoutMs` および失敗ルールの下で実行されます。

`--debug` を使用すると、Claude Code はすべての実行からヘルパーの stderr を [デバッグログ](/docs/ja/debug-your-config) に書き込みます。

Claude Code は無効な `policyHelper` 値を [ドロップされたエントリ](/docs/ja/managed-settings#find-entries-claude-code-dropped) として報告し、残りの管理設定でセッションを開始します。ヘルパーを実行しません。無効な値には、裸のパス文字列と [その最小値](#policyhelper-timeoutms) より低い `timeoutMs` が含まれます。

ヘルパーをオフにするには、それを設定するソースからキーを削除します。

### `policyHelper.path`

Claude Code が実行するヘルパー実行可能ファイルに名前を付けます。パスがルールを破る場合に何が起こるかについては、[ヘルパーの失敗](#helper-failures) を参照してください。

* **スコープ**: [`Managed`](#scopes)。macOS plist、Windows HKLM レジストリ、または管理設定ファイルから読み取ります。[`policyHelper`](#policyhelper) が読み取られる場所。
* **タイプ**: 文字列、正規化された形式の絶対パス。`.` または `..` セグメントなし。Windows では、`.exe` で終わるドライブレターまたは UNC パス
* **デフォルト**: なし。`policyHelper` が設定されている場合は必須

```json managed-settings.json theme={null}
{
  "policyHelper": {
    "path": "/usr/local/bin/claude-policy"
  }
}
```

### `policyHelper.timeoutMs`

Claude Code がヘルパーを待機する時間を設定してから、実行を失敗として扱います。タイムアウトした実行は 0 以外の終了と同じ方法で失敗するため、起動時に Claude Code は起動を拒否します。

* **スコープ**: [`Managed`](#scopes)。macOS plist、Windows HKLM レジストリ、または管理設定ファイルから読み取ります。[`policyHelper`](#policyhelper) が読み取られる場所。
* **タイプ**: 整数、ミリ秒、最小 `1000`
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

Claude Code がバックグラウンドでヘルパーを間隔で再実行するようにして、ポリシーの変更が実行中のセッションに到達するようにします。更新が成功する場合、その出力は前の管理設定を再起動なしで置き換えます。更新が失敗する場合、Claude Code は既に持っているポリシーを保ちます。

* **スコープ**: [`Managed`](#scopes)。macOS plist、Windows HKLM レジストリ、または管理設定ファイルから読み取ります。[`policyHelper`](#policyhelper) が読み取られる場所。
* **タイプ**: 整数、ミリ秒: 更新を無効にするには `0`。それ以外の場合は最小 `60000`
* **デフォルト**: 設定されていないため、Claude Code はヘルパーを起動時に 1 回実行します

この例は、5 分ごとにヘルパーを再実行します:

```json managed-settings.json theme={null}
{
  "policyHelper": {
    "path": "/usr/local/bin/claude-policy",
    "refreshIntervalMs": 300000
  }
}
```

### `wslInheritsWindowsSettings`

WSL 上の Claude Code が Windows ポリシーチェーンから管理設定を読み取るようにします。HKLM と Windows 管理設定ファイルが `/etc/claude-code` と下の HKCU より優先されます。チェーンがオンの間、Claude Code は [Windows 管理ドキュメントが存在しない](/docs/ja/managed-settings#present-admin-documents) 場合にのみ `/etc/claude-code` を読み取ります。HKLM レジストリ値または `C:\Program Files\ClaudeCode\` フォルダ内。Windows に既にデプロイしているポリシーを WSL セッションに拡張するために設定します。同じマシン上で、ホストセッションと同じルールに従うようにします。Claude Code は、HKLM レジストリキーまたは管理設定ファイルまたは `C:\Program Files\ClaudeCode\` の下のドロップインで設定されている場合にのみそれを尊重します。どちらも Windows 管理者が書き込む必要があります。

* **スコープ**: [`Managed`](#scopes)。管理者制御の Windows ソースで。
* **タイプ**: ブール値
  * `true`: WSL 上の Claude Code は Windows ポリシーチェーンから管理設定を読み取り、Windows 管理ドキュメントが存在しない場合にのみ `/etc/claude-code` を読み取ります
  * `false`: WSL は `/etc/claude-code` のみを読み取ります
* **デフォルト**: `false`。WSL は `/etc/claude-code` のみを読み取ります

```json managed-settings.json theme={null}
{
  "wslInheritsWindowsSettings": true
}
```

管理ソースがチェーンをオンにすると、HKCU ポリシーは HKCU もキーを `true` に設定する場合にのみ WSL に参加します。そのコピーはチェーンをそれ自体でオンにしません。このキーのみを含む Windows ソース。`true` または `false` に設定されている場合、ポリシーソースとしてカウントされません。下位優先度のソースはまだポリシーを提供します。このキーはネイティブ Windows に効果がありません。

Claude Code は `true` と `false` を引用符の有無にかかわらず読み取り、`null` をキーの削除として読み取ります。他の値を保持する管理者制御の Windows ソースは、[存在する管理ドキュメント](/docs/ja/managed-settings#present-admin-documents) としてカウントされます。チェーンがオンの場合: `/etc/claude-code` も HKCU も適用されず、起動警告がキーを名前で指定します。読み取ることができない HKLM 値または Windows フォルダファイルも、チェーンがオンかどうかに関わらず `/etc/claude-code` が適用されるのを防ぎます。Claude Code v2.1.282 以降が必要です。

## グローバル設定

これらのキーを `~/.claude.json` に保存してください。設定ファイルには保存しないでください。Claude Code はそれ以外の場所ではこれらを無視します。Claude Code と `/config` はほとんどのキーを自動的に書き込みます。また、手動で編集することもできます。

### `autoConnectIde`

外部ターミナルから Claude Code を起動するときに、実行中の IDE に自動的に接続します。VS Code または JetBrains ターミナルの外で Claude Code を実行する場合、`/config` に **Auto-connect to IDE (external terminal)** として表示されます。

* **スコープ**: [`グローバル設定`](#scopes)
* **タイプ**: ブール値
  * `true`: Claude Code は外部ターミナルから起動するときに、実行中の IDE に自動的に接続します
  * `false`: Claude Code は外部ターミナルから自動的に接続しません。ただし、VS Code または JetBrains ターミナル内、または `--ide` を使用する場合は接続します
* **デフォルト**: `false`
* **セッションごとのオーバーライド**: [`CLAUDE_CODE_AUTO_CONNECT_IDE`](/docs/ja/env-vars) はこのキーより優先され、1 つのセッションでどちらの方向でも機能します

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
* **セッションごとのオーバーライド**: [`CLAUDE_CODE_IDE_SKIP_AUTO_INSTALL`](/docs/ja/env-vars) を `1` に設定すると、このキーが `true` の場合でも 1 つのセッションのインストールをスキップします

```json ~/.claude.json theme={null}
{
  "autoInstallIdeExtension": false
}
```

Claude Code は `settings.json` でこのキーを無視します。

### `claudeInChromeDefaultEnabled`

[Chrome 統合](/docs/ja/chrome)をオンにして、毎回 `--chrome` を渡さずにすべてのインタラクティブ CLI セッションを開始します。[`claude remote-control`](/docs/ja/remote-control) を実行する場合、[プロジェクト](/docs/ja/claude-projects)スレッドの 1 つに対して開始するセッションもこのキーに従います。ただし、`bypassPermissions` モードの場合は除きます。Claude Code v2.1.287 以降では、このキーは [VS Code 拡張機能](/docs/ja/vs-code#automate-browser-tasks-with-chrome)のセッションにも適用されます。詳しくは [Chrome をデフォルトで有効にする](/docs/ja/chrome#enable-chrome-by-default)を参照してください。

`/chrome` を実行して **Enabled by default** を選択すると、このキーが設定されます。`/config` に **Claude in Chrome enabled by default** として表示されます。

* **スコープ**: [`グローバル設定`](#scopes)
* **タイプ**: ブール値
  * `true`: Claude Code は `--chrome` を渡すときと同様に、インタラクティブ CLI セッションが開始するときに Chrome 統合をオンにします。VS Code 拡張機能では、セッションは開始時にブラウザに接続します
  * `false`: インタラクティブ CLI セッションは Chrome 統合をオフで開始し、Claude Code は[セットアップを提案するのを停止](/docs/ja/chrome#install-the-extension-when-claude-asks)します。1 つのインタラクティブセッションでオンにするには `--chrome` を渡してください。VS Code 拡張機能では、キーが未設定の場合と同様に、`@browser` と入力したときにセッションが接続します
* **デフォルト**: 未設定。Chrome 統合はオフで、Claude Code はセットアップを提案できます
* **セッションごとのオーバーライド**: `--chrome` と [`--no-chrome`](/docs/ja/cli-reference) はこのキーより優先され、1 つのインタラクティブセッションで機能します

```json ~/.claude.json theme={null}
{
  "claudeInChromeDefaultEnabled": true
}
```

Claude Code は `settings.json` でこのキーを無視します。

### `copyFullResponse`

[`/copy`](/docs/ja/commands) がピッカーを表示せずに、毎回完全な応答をコピーするようにします。そのピッカーで **Always copy full response** を選択すると、このキーが `true` に設定されます。`/config` に **Skip the /copy picker** として表示されます。

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

[フルスクリーンレンダリング](/docs/ja/fullscreen#use-the-mouse)または[エージェントビュー](/docs/ja/agent-view)でマウスで選択を終了したときに、テキストをクリップボードに自動的にコピーします。フルスクリーンレンダリングがオンの場合、`/config` に **Copy on select** として表示されます。

* **スコープ**: [`グローバル設定`](#scopes)
* **タイプ**: ブール値
  * `true`: Claude Code は選択を終了したときにテキストをクリップボードにコピーします
  * `false`: テキストを選択してもクリップボードは変わらず、代わりに[キーボードショートカットで選択をコピー](/docs/ja/fullscreen#use-the-mouse)します
* **デフォルト**: `true`

```json ~/.claude.json theme={null}
{
  "copyOnSelect": false
}
```

Claude Code は `settings.json` でこのキーを無視します。

### `defaultToAgentsView`

引数なしで `claude` を実行するときに、新しい会話の代わりに[エージェントビュー](/docs/ja/agent-view)を開きます。エージェントビューが[オフ](#disableagentview)になっていない限り、`/config` に **Open agents view by default** として表示されます。

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

[VS Code](/docs/ja/vs-code)または[JetBrains](/docs/ja/jetbrains#features) IDE が接続されているときに、Claude Code が提案する `Edit` または `Write` 変更の差分を表示する場所を選択します。`"auto"` は IDE の差分ビューアで開き、`"terminal"` はターミナルに保持します。Claude Code が VS Code または JetBrains IDE に接続されている場合のみ、`/config` に **Diff tool** として表示されます。

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

`Ctrl+G` を押すと、Claude Code は入力中のプロンプトを[外部エディタ](/docs/ja/interactive-mode#general-controls)で開きます。このキーをオンにすると、エディタバッファは Claude の前の応答で `#` コメント行として開始されるため、書き込み中に読むことができ、Claude Code は保存時にこれらの行を削除します。`/config` に **Show last response in external editor** として表示されます。

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

空のプロンプトで `←` を押して、[セッションをバックグラウンドにしてエージェントビューを開き](/docs/ja/agent-view#switch-sessions-without-leaving-the-terminal)ます。このキーを `false` に設定してショートカットをオフにします。エージェントビューが利用可能な場合、`/config` に **← opens agents** として表示されます。

* **スコープ**: [`グローバル設定`](#scopes)
* **タイプ**: ブール値
  * `true`: ターミナルで開始したセッションの空のプロンプトで `←` を押すと、セッションがバックグラウンドになり、エージェントビューが開きます
  * `false`: Claude Code はショートカットをオフにします。[エージェントビューから接続した](/docs/ja/agent-view#attach-to-a-session)セッションでは、空のプロンプトで `←` を押すと切断されます
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

現在のブランチのオープンなプルリクエストまたはマージリクエストのバッジをプロンプトフッターに表示し、その[ステータス](/docs/ja/interactive-mode#pr-review-status)を示す色付きの下線を表示します。`/config` に **Show PR status footer** として表示されます。

* **スコープ**: [`グローバル設定`](#scopes)
* **タイプ**: ブール値
  * `true`: フッターは [PR レビューステータス](/docs/ja/interactive-mode#pr-review-status)の条件下でバッジを表示します
  * `false`: Claude Code はフッターのプルリクエストおよびマージリクエストチェックをスキップし、そのバッジを表示しません。[エージェントビューから接続した](/docs/ja/agent-view#attach-to-a-session)セッションは、[リンクされた](/docs/ja/agent-view#pull-request-status)プルリクエストへのプレーンリンクを表示できます
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

v2.1.233 まで、このキーを[エージェントチーム](/docs/ja/agent-teams#specify-teammates-and-models)のチームメイトのモデルに設定しました。プロンプトがモデルを指定しなかったチームメイト用：`"sonnet"` などのエイリアス、または `null` でリードのモデルに従う。Claude Code が現在そのようなチームメイト用に選択するモデルについては、[チームメイトとモデルを指定](/docs/ja/agent-teams#specify-teammates-and-models)を参照してください。

* **スコープ**: [`グローバル設定`](#scopes)。v2.1.233 以前。
* **タイプ**: 文字列、モデルエイリアスまたは完全なモデル ID、または `null`
* **デフォルト**: 未設定

## 関連項目

* [権限を設定する](/docs/ja/permissions)：ルール構文、権限モード、ワークスペース信頼
* [環境変数](/docs/ja/env-vars)：Claude Code が読み込むすべての `CLAUDE_*`、`ANTHROPIC_*`、およびプロバイダー変数
* [Claude で利用可能なツール](/docs/ja/tools-reference)：組み込みツールと承認が必要なツール
* [設定ファイルの例](/docs/ja/settings-example)：個人用ファイル、チームファイル、および組織の管理ファイル
* [管理設定をセットアップする](/docs/ja/admin-setup)：組織が何を強制するかを決定する方法
* [管理設定をデプロイする](/docs/ja/managed-settings)：配信メカニズム、管理層内の優先順位、および管理設定の無効なエントリ
* [設定をデバッグする](/docs/ja/debug-your-config)：`claude doctor` と設定エラーダイアログ
