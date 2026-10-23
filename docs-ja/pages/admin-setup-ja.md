> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# 組織向けに Claude Code をセットアップする

> Claude Code を展開する管理者向けの決定マップ。API プロバイダー、マネージド設定、ポリシー実行、使用状況監視、データ処理をカバーしています。

Claude Code は、ローカル開発者設定よりも優先されるマネージド設定を通じて組織ポリシーを実行します。これらの設定は Claude 管理コンソール、モバイルデバイス管理（MDM）システム、またはディスク上のファイルから配信します。設定は Claude が到達できるツール、コマンド、サーバー、ネットワーク宛先を制御します。

このページでは、展開の決定を順番に説明します。各行は以下のセクションと、その領域の参照ページにリンクしています。

> [!NOTE]
>
> SSO、SCIM プロビジョニング、シート割り当ては Claude アカウントレベルで設定されます。これらの手順については、[Claude Enterprise Administrator Guide](https://claude.com/resources/tutorials/claude-enterprise-administrator-guide) と [シート割り当て](https://support.claude.com/en/articles/11845131-use-claude-code-with-your-team-or-enterprise-plan) を参照してください。

| 決定 | 選択内容 | 参照 |
| :- | :- | :- |
| [API プロバイダーを選択する](#choose-your-api-provider) | Claude Code が認証される場所と課金方法 | [Authentication](/docs/ja/authentication.md)、[Amazon Bedrock](/docs/ja/amazon-bedrock.md)、[Google Cloud の Agent Platform](/docs/ja/google-vertex-ai.md)、[Microsoft Foundry](/docs/ja/microsoft-foundry.md) |
| [設定がデバイスに到達する方法を決定する](#decide-how-settings-reach-devices) | マネージドポリシーが開発者マシンに到達する方法 | [Server-managed settings](/docs/ja/server-managed-settings.md)、[Delivery mechanisms](/docs/ja/managed-settings.md#delivery-mechanisms) |
| [実行する内容を決定する](#decide-what-to-enforce) | どのツール、コマンド、統合が許可されるか | [Permissions](/docs/ja/permissions.md)、[Sandboxing](/docs/ja/sandboxing.md) |
| [使用状況の可視性をセットアップする](#set-up-usage-visibility) | 支出と採用を追跡する方法 | [Analytics](/docs/ja/analytics.md)、[Monitoring](/docs/ja/monitoring-usage.md)、[Costs](/docs/ja/costs.md) |
| [データ処理を確認する](#review-data-handling) | データ保持とコンプライアンス体制 | [Data usage](/docs/ja/data-usage.md)、[Security](/docs/ja/security.md) |

## API プロバイダーを選択する

Claude Code は複数の API プロバイダーのいずれかを通じて Claude に接続します。選択は課金、認証、継承するコンプライアンス体制、および開発者が使用できる Claude Code 機能に影響します。

| プロバイダー | 選択する場合 |
| :- | :- |
| Claude for Teams / Enterprise | Claude Code と claude.ai を 1 つのシート単位のサブスクリプションで実行したい場合。実行するインフラストラクチャは不要です。これがデフォルトの推奨事項です。 |
| Claude Console | API ファーストまたは従量課金を希望する場合 |
| Amazon Bedrock | 既存の AWS コンプライアンス制御と課金を継承したい場合 |
| Google Cloud の Agent Platform | 既存の GCP コンプライアンス制御と課金を継承したい場合 |
| Microsoft Foundry | 既存の Azure コンプライアンス制御と課金を継承したい場合 |

一部の Claude Code 機能には claude.ai アカウントが必要です。[クラウドセッション](/docs/ja/claude-code-on-the-web.md)、[クラウドのスケジュールタスク](/docs/ja/routines.md)、[Code Review](/docs/ja/code-review.md)、[Remote Control](/docs/ja/remote-control.md)、および [Chrome 拡張機能](/docs/ja/chrome.md) は、Console API キーまたはクラウドプロバイダーの認証情報だけでは利用できません。Amazon Bedrock、Google Cloud の Agent Platform、または Microsoft Foundry を通じてデプロイする場合は、開発者が Claude for Teams または Enterprise シートも必要かどうかを検討してください。各機能ページにはプラン要件が記載されています。

認証、リージョン、機能パリティをカバーする完全なプロバイダー比較については、[エンタープライズ展開概要](/docs/ja/third-party-integrations.md) を参照してください。各プロバイダーの認証セットアップは [Authentication](/docs/ja/authentication.md) にあります。

[ネットワーク設定](/docs/ja/network-config.md) のプロキシとファイアウォール要件は、プロバイダーに関係なく適用されます。複数のプロバイダーの前に単一のエンドポイントを配置したい場合、または集中化されたリクエストログを記録したい場合は、[LLM gateway](/docs/ja/llm-gateway) を参照してください。

## 設定がデバイスに到達する方法を決定する

管理設定は、組織ポリシーを定義します。Claude Code は以下の表に示す 4 つのソースを優先順位順にチェックします。[Claude Code がマネージドソースを組み合わせる方法](/docs/ja/managed-settings.md#precedence-within-the-managed-tier)は、どのソースが適用されるか、ポリシーヘルパーが何を変更するか、およびすべてのソースを構成する方法を説明しています。この表は決定マップです。

| メカニズム | 配信 | 優先度 | プラットフォーム |
| :- | :- | :- | :- |
| Server-managed | claude.ai 管理コンソール、またはゲートウェイサインイン用の自己ホスト型 [Claude apps gateway](/docs/ja/claude-apps-gateway) | 最高 | すべて |
| plist / registry policy | macOS: `com.anthropic.claudecode` plist Windows: `HKLM\SOFTWARE\Policies\ClaudeCode` | 高 | macOS、Windows |
| File-based managed | macOS: `/Library/Application Support/ClaudeCode/managed-settings.json` Linux と WSL: `/etc/claude-code/managed-settings.json` Windows: `C:\Program Files\ClaudeCode\managed-settings.json` | 中 | すべて |
| Windows user registry | `HKCU\SOFTWARE\Policies\ClaudeCode` | 最低 | Windows のみ |

Claude Code はスタートアップ時に server-managed 設定をフェッチし、セッション中は 1 時間ごとに更新します。デプロイするエンドポイントインフラストラクチャはありません。claude.ai 管理コンソール経由の配信には Claude for Teams または Enterprise プランが必要です。Amazon Bedrock、Google Cloud の Agent Platform、または Microsoft Foundry でのデプロイは、[Claude apps gateway](/docs/ja/claude-apps-gateway) を実行することで同じリモート配信を取得できます。または、ファイルベースまたは OS レベルのメカニズムのいずれかを代わりに使用してください。

組織が複数のプロバイダーを混在させている場合、claude.ai ユーザー向けに [server-managed settings](/docs/ja/server-managed-settings.md) を設定し、他のユーザーがマネージドポリシーを受け取るように [ファイルベースまたは plist/registry フォールバック](/docs/ja/managed-settings.md#delivery-mechanisms)を設定してください。

plist と HKLM レジストリの場所は任意のプロバイダーで機能し、書き込みに管理者権限が必要なため、改ざんに強いです。HKCU の Windows ユーザーレジストリは昇格なしで書き込み可能なため、実行チャネルではなく便利なデフォルトとして扱ってください。

デフォルトでは WSL は `/etc/claude-code` の Linux ファイルパスのみを読み取ります。同じマシン上の WSL に Windows レジストリと `C:\Program Files\ClaudeCode` ポリシーを拡張するには、これらの管理者のみが使用できる Windows ソースのいずれかで [`wslInheritsWindowsSettings: true`](/docs/ja/settings-reference#wslinheritswindowssettings) を設定してください。

どのメカニズムを選択しても、マネージド値はユーザーおよびプロジェクト設定よりも優先されます。ただし、セキュリティに関する [例外](/docs/ja/settings.md#exceptions-to-managed-settings-precedence)がいくつかあります。`permissions.allow` や `permissions.deny` などの配列設定は、すべてのソースからのエントリをマージするため、開発者はマネージドリストを拡張できますが、削除することはできません。`fallbackModel`、`availableModels`、および [`modelPicker`](/docs/ja/settings-reference#modelpicker) の場合、マネージド値は下位レイヤーとマージするのではなく、置き換えます。

### Claude Code Desktop の WSL セッション

Windows では、[Claude Code Desktop は WSL 2 ディストリビューション内で Code セッションを実行できます](/docs/ja/desktop-wsl.md)。セッションの Claude Code プロセスはディストリビューション内で実行されるため、上記の WSL 検出パスを通じて管理設定を解決します。`wslInheritsWindowsSettings: true` がデプロイされていない限り、Windows のみのソースはそれに到達しません。

Claude Desktop は、`C:\Program Files\ClaudeCode\managed-settings.json` が存在する場合など、組織が管理しているデバイスとして検出されるデバイスでは、デフォルトで WSL セッションをオフにします。それらをオンにするには、Windows レジストリポリシーをデプロイします。これには Claude Desktop v1.19367.0 以降が必要です。

* `HKLM\SOFTWARE\Policies\Claude` の下に `disableWslSessions` という名前の値を作成し、`REG_SZ` 文字列 `false` または `REG_DWORD` `0` に設定します。この値は Claude Desktop ポリシーキーの下にあり、管理設定を含む `ClaudeCode` キーとは別です。HKLM の下に値をデプロイします。これには管理者権限が必要です。HKCU の下の値は WSL セッションを有効にしません。
* `C:\Program Files\ClaudeCode\managed-settings.json` をデプロイする場合は、そのままにしておいてください。`disableWslSessions` が HKLM の下で `false` になると、そのファイルが存在していても Desktop は WSL セッションを許可します。

Desktop は WSL セッションが開始されるたびにポリシーを読み取るため、デプロイ後にアプリを再起動する必要はありません。

デバイスが依然として WSL セッションを拒否する場合は、そのデバイスの Claude Desktop で **Help > Troubleshooting > Show Logs in File Explorer** を開きます。これにより、ログフォルダのコピーが Downloads に保存されます。そのコピーの `main.log` で `[wslPolicyGate] denying WSL session` を検索してください。拒否の理由は括弧内に続きます。例えば `(cli-file-present)` のようにです。

WSL セッションが有効になった後、管理設定をそれらに拡張します。

* HKLM レジストリまたは `C:\Program Files\ClaudeCode` ファイルを通じて `wslInheritsWindowsSettings: true` をデプロイして、WSL セッションがホストセッションと同じポリシーを継承するようにしてください。
* WSL セッション内で `/status` を実行して検証し、`Setting sources` 行を読んでください。それを解釈する方法については、[/status で出力を読む](/docs/ja/managed-settings.md#read-the-source-in-/status)を参照してください。

WSL 2 ユーティリティ VM 内のプロセスは、Windows 側のエンドポイント検出センサーに表示されません。ディストリビューション内のプロセスとファイルアクティビティを観察するには、エンドポイント検出ベンダーの WSL ガイダンスで、ディストリビューション内で実行できる Linux センサーと、それが必要とする除外を確認してください。Claude Code の [OpenTelemetry ツール実行テレメトリ](/docs/ja/monitoring-usage.md)は WSL とネイティブセッションで同じように出力されます。

## 適用する内容を決める

管理設定では、ツールのロックダウン、実行のサンドボックス化、MCP サーバーやプラグインソースの制限、実行するフックの制御を行えます。各行は制御対象とそれを動かす設定キーを示しています。

| 制御 | 内容 | 主な設定 |
| :- | :- | :- |
| [権限ルール](/docs/ja/permissions.md) | 特定のツールやコマンドを許可、確認、または拒否します | `permissions.allow`、`permissions.deny` |
| [権限のロックダウン](/docs/ja/permissions.md#managed-only-settings) | 管理設定を[権限ルールの唯一の設定ソース](/docs/ja/settings-reference.md#allowmanagedpermissionrulesonly)にします。`--dangerously-skip-permissions` を無効にします | `allowManagedPermissionRulesOnly`、`permissions.disableBypassPermissionsMode` |
| [開始時の権限モード](/docs/ja/permission-modes.md#which-mode-a-session-starts-in) | 組み込みの開始時権限モードの代わりに、開発者のターミナルセッションが開始する権限モードを選択するか、auto モードを削除します。VS Code 拡張機能が設定された `defaultMode` を読み込むタイミングについては、[権限モードの切り替え](/docs/ja/permission-modes.md#switch-permission-modes)を参照してください | `permissions.defaultMode`、`permissions.disableAutoMode` |
| [サンドボックス化](/docs/ja/sandboxing.md) | ドメイン許可リストを使用した OS レベルのファイルシステムおよびネットワークの分離 | `sandbox.enabled`、`sandbox.network.allowedDomains` |
| [管理ポリシーの CLAUDE.md](/docs/ja/memory.md#deploy-organization-wide-claude-md) | クライアントで強制されるルールではなく、組織全体で Claude に与える動作のガイダンス | 管理ポリシーのパスに置くファイル |
| [MCP サーバーの制御](/docs/ja/managed-mcp.md) | ユーザーが追加または接続できる MCP サーバーを制限したり、固定のセットをデプロイしたり、各ユーザー自身のサーバーに加えてリモートサーバーを全ユーザーに提供したりします | `allowedMcpServers`、`deniedMcpServers`、`allowManagedMcpServersOnly`、`managedMcpServers`、またはデプロイされた `managed-mcp.json` ファイル |
| [プラグインマーケットプレイスの制御](/docs/ja/plugins/org.md#restrict-what-users-can-install) | ユーザーが追加およびインストールできるマーケットプレイスソースを制限し、単一の実行のためにプラグイン、エージェント、MCP サーバーをサイドロードする CLI フラグを拒否し、[`command` プラグインソース](/docs/ja/plugins/marketplace-reference#command-plugin-source)をブロックし、どのマーケットプレイスのプラグインを提案できるかを許可リストで指定します | `strictKnownMarketplaces`、`blockedMarketplaces`、`disableSideloadFlags`、`disableCommandPluginSources`、`pluginSuggestionMarketplaces` |
| [カスタマイズのロックダウン](/docs/ja/settings-reference.md#strictpluginonlycustomization) | ユーザーおよびプロジェクトのソースからのスキル、エージェント、フック、MCP サーバーをブロックし、プラグインまたは管理設定からのみ提供されるようにします。スキルをロックすると、[開発者が claude.ai で有効にしたスキル](/docs/ja/skills.md#where-synced-skills-load)の同期も停止します | `strictPluginOnlyCustomization` |
| [claude.ai 同期の無効化](/docs/ja/settings-reference.md#syncclaudeaiskills) | 開発者が claude.ai で有効にした[スキル](/docs/ja/skills.md#how-synced-skills-behave)と[プラグイン](/docs/ja/plugins/loading.md#synced-plugins)を Claude Code が読み込まないようにします。claude.ai で組織の Skills をオフにすると、Claude Code は両方の同期を停止し、v2.1.273 以降では同期済みのものも削除します。Skills をオフにせずにいずれかを停止するには、管理設定でそのキーを `false` に設定します | `syncClaudeAiSkills`、`syncClaudeAiPlugins` |
| [フックの制限](/docs/ja/settings-reference.md#allowmanagedhooksonly) | 実行するフックと HTTP フックの URL を制限します。影響の全一覧は [`allowManagedHooksOnly` で実行されるもの](/docs/ja/settings-reference#what-runs-under-allowmanagedhooksonly)を参照してください | `allowManagedHooksOnly`、`allowedHttpHookUrls` |
| [ログインの強制](/docs/ja/settings-reference.md#forceloginmethod) | ログインを特定の方法または Anthropic 組織に制限します。方法の制限は VS Code 拡張機能、Agent SDK、`claude setup-token`、`/install-github-app` 全体に適用されます。`/login` または初回のオンボーディングで表示されるターミナルの対話型ログイン画面では、その方法が事前に選択されますが、強制はされません。Claude Code は、ターミナル、VS Code 拡張機能、Agent SDK での claude.ai アカウントのログインについて組織を検証しますが、Claude Console のログインや[ゲートウェイ](/docs/ja/claude-apps-gateway)のサインインについては確認しません。v2.1.212 より前は、いずれのキーもターミナルのログインにのみ適用されていました。設定されている場合、`ANTHROPIC_API_KEY`、`ANTHROPIC_AUTH_TOKEN`、または `apiKeyHelper` で認証されたセッションは起動時にブロックされます。クラウドプロバイダーのセッションは影響を受けませんが、これらの認証情報のいずれか、または以前の Claude Console ログインで保存された API キーも存在する場合は例外としてブロックされます | `forceLoginMethod`、`forceLoginOrgUUID` |
| [プロバイダーの制限](/docs/ja/settings-reference.md#allowedproviders) | マシンが使用できる API プロバイダーを制限します。リストにないプロバイダーのセッションは、起動時、ログイン時、および次に API に接続したときに拒否されます。Claude Code v2.1.285 以降が必要です | `allowedProviders` |
| [エージェントビューの無効化](/docs/ja/agent-view.md#how-background-sessions-are-hosted) | `claude agents`、`--bg`、`/background`、およびオンデマンドのスーパーバイザーをオフにします | `disableAgentView` |
| [企業ランチャーの設定](/docs/ja/corporate-launcher.md) | エージェントビューをオフにする代わりに、[バックグラウンドエージェントのスーパーバイザー](/docs/ja/agent-view.md#how-background-sessions-are-hosted)、そのワーカー、および[対象となるその他のバックグラウンドプロセス](/docs/ja/corporate-launcher.md#what-the-launcher-covers)の前に、必須の企業ランチャーを付加します | `processWrapper` |
| [モデルの制限](/docs/ja/model-config.md#restrict-model-selection) | `availableModels` はピッカーに表示されるモデルを絞り込みます。`enforceAvailableModels` を追加すると、自動選択されるデフォルトモデルも制約されます。この設定が CLI、Web、IDE にどのように適用されるかは[サーフェスの対応範囲](/docs/ja/model-config.md#surface-coverage)を参照してください | `availableModels`、`enforceAvailableModels` |
| [effort の上限](/docs/ja/settings-reference.md#maxeffortlevel) | すべてのプロバイダーで、すべてのモデルまたはモデルごとに [effort レベル](/docs/ja/model-config.md#adjust-effort-level)の上限を設定します | `maxEffortLevel` |
| [バージョンの下限](/docs/ja/settings-reference.md#minimumversion) | 組織全体の最小バージョンを下回るバージョンが自動更新でインストールされないようにします | `minimumVersion` |
| [必須バージョン範囲](/docs/ja/settings-reference.md#requiredminimumversion) | 実行中のバージョンが組織で承認された範囲外の場合、起動自体を拒否します。ダウングレードのみをブロックする `minimumVersion` よりも強力です | `requiredMinimumVersion`、`requiredMaximumVersion` |
| [テレメトリのオプトアウト](/docs/ja/data-usage.md#telemetry-services) | すべてのデバイスで、Anthropic に送信される使用状況メトリクス、エラーレポート、アンケートをオフにします | `CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC` を `1` に設定した `env`。カテゴリごとの変数はリンク先のセクションに記載されています |

メンバーが claude.ai または Anthropic API 経由でサインインし、Claude Enterprise プランを利用している場合は、何もデプロイせずに組織の管理設定からモデルを管理することもできます。

* [組織のモデル制限](/docs/ja/model-config.md#organization-model-restrictions)：個々のモデルを無効にします。サーバー側で強制されます。
* [組織のデフォルトモデル](/docs/ja/model-config.md#organization-default-model)：新しいセッションが開始するモデルを設定します。メンバーは引き続きモデルを切り替えられます。起動時にデフォルトに戻すには、そのセクションで説明している上書きをオンにします。メンバーが選択できるモデルを制限するには、[組織のモデル制限](/docs/ja/model-config.md#organization-model-restrictions)を使用します。
* [組織の effort 制限](/docs/ja/model-config.md#organization-effort-limits)：ロールごとに effort レベルの上限を設定します。サーバー側で強制されます。

これらの制御はいずれも、Amazon Bedrock、Google Cloud の Agent Platform、Microsoft Foundry、または [Claude Platform on AWS](/docs/ja/claude-platform-on-aws.md) 上のセッションには適用されません。これらのプロバイダーでは、代わりに管理設定を使用してください。制限には `availableModels`、デフォルトには `model`、effort の上限には [`maxEffortLevel`](/docs/ja/settings-reference#maxeffortlevel) を使用します。

[クラウドセッション](/docs/ja/claude-code-on-the-web.md)には、claude.ai 上に独自の管理画面があります。

* **クラウド環境ページ**：Owner は、メンバーのクラウドセッションの[ネットワークアクセスレベル](/docs/ja/cloud-environments.md#network-access)、環境変数、セットアップスクリプトを設定する[組織共有環境](/docs/ja/cloud-environments.md#organization-shared-environments)を作成します。
* **デフォルト環境**：Owner は、組織のデフォルト環境を [claude.ai/admin-settings/claude-code](https://claude.ai/admin-settings/claude-code) で別途選択します。
* **Git プロバイダーページ**：組織にリンクされた GitHub アカウントについては、[接続された GitHub アカウント](#connected-github-accounts)を参照してください。

権限ルールとサンドボックス化は異なるレイヤーを対象とします。WebFetch を拒否すると Claude のフェッチツールはブロックされますが、Bash が許可されている場合、`curl` や `wget` は引き続き任意の URL にアクセスできます。サンドボックス化は、OS レベルで強制されるネットワークドメインの許可リストによってこのギャップを埋めます。

これらの制御が防御する脅威モデルについては、[セキュリティ](/docs/ja/security.md)を参照してください。

### 接続された GitHub アカウント

Team プランと Enterprise プランでは、[**Organization settings > Git providers**](https://claude.ai/admin-settings/source-control) の GitHub セクションに、[Claude GitHub App](https://github.com/apps/claude) を通じて Claude 組織にリンクされた GitHub 組織と個人アカウントが一覧表示されます。Claude Code、[Claude Tag](https://claude.com/docs/claude-tag/admins/configure-github)、Claude Security はこの一覧を共有します。このページを開くには、Claude 組織の管理者ロールが必要です。

アカウントは管理者またはメンバーがリンクできます。

* **管理者による接続**：管理者がそのセクションで **Connect** をクリックするか、アカウントが接続済みの場合は **Add organization** をクリックし、GitHub 組織に Claude GitHub App をインストールします。この方法で組織をリンクするには、GitHub 組織の Owner であり、かつ Claude 組織の管理者でもあるユーザーが必要です。
* **メンバーによる接続**：メンバーが自分の GitHub アカウントを Claude に接続すると（たとえば[クラウドセッションのセットアップ](/docs/ja/web-quickstart.md#connect-github)中）、Claude は、そのメンバーが所有し、Claude GitHub App がすでにインストールされている GitHub アカウントをリンクします。これには、メンバーの個人アカウントや、メンバーが所有する GitHub 組織が含まれる場合があります。

**Not linked** と表示されている行は、自分自身の GitHub サインインに由来するものです。これは、GitHub 上で自分が参照でき、Claude GitHub App がインストールされているアカウントです。

Claude 組織からアカウントのリンクを解除するには、その行のメニューを開いて **Unlink from this workspace** を選択します。リンクを解除しても Claude GitHub App は GitHub 上にインストールされたままであり、そのアカウントのいずれかの Owner が次に GitHub を Claude に接続すると、アカウントは再びリンクされます。再びリンクされないようにするには、GitHub 上でそのアカウントから Claude GitHub App をアンインストールしてください。

Enterprise プランでは、リンクおよびリンク解除に対応する [Compliance API](https://platform.claude.com/docs/en/api/compliance/activities/list) のアクティビティタイプは `github_app_installation_linked` と `github_app_installation_unlinked` です。

## 使用状況の可視性をセットアップする

必要なレポート内容に基づいて監視を選択してください。ダッシュボード、API、支出管理は Claude for Teams または Enterprise プランと Claude Console 組織で異なるため、機能に基づいてレポートを計画する前に「利用可能性」列を確認してください。

| 機能 | 取得内容 | 利用可能性 | 開始場所 |
| :- | :- | :- | :- |
| Usage monitoring | セッション、ツール、トークンの OpenTelemetry エクスポート | すべてのプロバイダー | [Monitoring usage](/docs/ja/monitoring-usage.md) |
| Analytics dashboard | Teams / Enterprise でのリーダーボード付き採用度と貢献度メトリクス、Console でのユーザーごとの使用状況と支出メトリクス | Teams / Enterprise は [claude.ai/analytics](https://claude.ai/analytics/claude-code)、Console は [platform.claude.com/claude-code](https://platform.claude.com/claude-code) | [Analytics](/docs/ja/analytics.md) |
| Programmatic reporting | API を通じたユーザーごとの使用状況とコストデータ | Enterprise 向け [Enterprise Analytics API](https://platform.claude.com/docs/en/api/admin/analytics)、Console 向け [Claude Code Analytics API](https://platform.claude.com/docs/en/build-with-claude/claude-code-analytics-api) | [Costs](/docs/ja/costs.md#manage-costs-for-your-organization) |
| Spend controls | 支出制限とレート制限 | Teams / Enterprise の組織設定、Console のワークスペース制限、サードパーティクラウドではクラウド予算管理またはユーザーごとの [支出制限](/docs/ja/claude-apps-gateway-spend-limits.md) を備えた [Claude apps gateway](/docs/ja/claude-apps-gateway) | [Costs](/docs/ja/costs.md#manage-costs-for-your-organization) |

Teams および Enterprise では、ユーザーごとの使用状況と支出の数値は分析ダッシュボードではなく、組織の分析設定の [支出レポート](https://support.claude.com/en/articles/12883420-view-usage-analytics-for-team-and-enterprise-plans) から取得されます。クラウドプロバイダーは AWS Cost Explorer、GCP Billing、または Azure Cost Management を通じて支出を公開します。Claude チャット、Claude Code、Cowork 全体にわたるエンタープライズ予算計画については、[Claude Enterprise 消費ガイド](https://support.claude.com/en/articles/14782391-claude-enterprise-consumption-guide) を参照してください。

## データ処理を確認する

Team、Enterprise、Claude API、およびクラウドプロバイダープランでは、Anthropic はコードまたはプロンプトでモデルをトレーニングしません。API プロバイダーが保持とコンプライアンス体制を決定します。

| トピック | 知っておくべきこと | 開始場所 |
| :- | :- | :- |
| Data usage policy | Anthropic が収集する内容、保持期間、トレーニングに使用されない内容 | [Data usage](/docs/ja/data-usage.md) |
| Zero Data Retention（ZDR） | リクエスト完了後は何も保存されません。Claude for Enterprise の適格なアカウントで利用可能 | [Zero data retention](/docs/ja/zero-data-retention.md) |
| HIPAA 設定 | HIPAA が有効になっている Claude for Enterprise の組織向け。Claude Code（ローカルモード）の一部の機能は無効になり、その他の機能はデフォルトで無効になります | [HIPAA 対応組織向けに Claude Code（ローカルモード）をセットアップする](/docs/ja/hipaa-setup.md) |
| Security architecture | ネットワークモデル、暗号化、認証、監査証跡 | [Security](/docs/ja/security.md) |

リクエストレベルの監査ログが必要な場合、またはデータの機密性によってトラフィックをルーティングしたい場合は、開発者とプロバイダーの間にゲートウェイを配置することをお勧めします。セルフホスト型の [Claude apps gateway](/docs/ja/claude-apps-gateway) は IdP の ID とともにリクエストごとの監査ログを記録します。または、別の [LLM ゲートウェイ](/docs/ja/llm-gateway)を使用することもできます。ゲートウェイを経由するセッションは HIPAA 設定の対象外です。対象となるサインイン方法と接続方法については、[開発者のサインイン方法と接続方法を確認する](/docs/ja/hipaa-setup.md#check-how-developers-sign-in-and-connect)に記載されています。規制要件と認定については、[Legal and compliance](/docs/ja/legal-and-compliance.md) を参照してください。

## 検証とオンボード

マネージド設定を設定した後、開発者に Claude Code 内で `/status` を実行させてください。**Status** タブの `Setting sources` 行に `Enterprise managed settings` が表示され、その後に括弧内のソースが続きます。[アクティブな設定を検証](/docs/ja/managed-settings.md#verify-enforcement) にラベルが記載されています。

開発者が開始するのに役立つこれらのリソースを共有してください。

* [クイックスタート](/docs/ja/quickstart.md): インストールからプロジェクトの操作まで、最初のセッションのウォークスルー
* [一般的なワークフロー](/docs/ja/common-workflows.md): コードレビュー、リファクタリング、デバッグなどの日常的なタスクのパターン
* [Claude Code 101](https://academy.claude.com/courses/claude-code-101) と [Claude Code in Action](https://academy.claude.com/courses/claude-code-in-action): [Claude Academy](https://academy.claude.com/) の無料の自習型コース

ログインの問題については、開発者に [認証のトラブルシューティング](/docs/ja/troubleshoot-install.md#login-and-authentication) を指してください。最も一般的な修正は次のとおりです。

* `/logout` を実行してから `/login` を実行してアカウントを切り替える
* エンタープライズ認証オプションが見つからない場合は `claude update` を実行する
* 更新後にターミナルを再起動する

開発者が「You haven't been added to your organization yet」というメッセージを見た場合、そのシートには Claude Code アクセスが含まれておらず、管理コンソールで更新する必要があります。

## 次のステップ

プロバイダーと配信メカニズムを選択したら、詳細な設定に進みます。

* [Server-managed settings](/docs/ja/server-managed-settings.md): Claude 管理コンソールからマネージドポリシーを配信する
* [All settings](/docs/ja/settings-reference.md): すべての設定キー、ファイルの場所、および例
* [Which value Claude Code uses](/docs/ja/settings.md#which-value-claude-code-uses): マネージド、プロジェクト、ローカル、およびユーザー設定全体の優先度ルール
* [Monorepos and large repos](/docs/ja/large-codebases.md): 大規模リポジトリをデプロイする組織向けのディレクトリごとの設定パターン
* [Amazon Bedrock](/docs/ja/amazon-bedrock.md)、[Google Cloud's Agent Platform](/docs/ja/google-vertex-ai.md)、[Microsoft Foundry](/docs/ja/microsoft-foundry.md): プロバイダー固有のデプロイメント
* [Claude Enterprise Administrator Guide](https://claude.com/resources/tutorials/claude-enterprise-administrator-guide): SSO、SCIM、シート管理、ロールアウトプレイブック
