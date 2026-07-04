> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# 組織向けに Claude Code をセットアップする

> Claude Code を展開する管理者向けの決定マップ。API プロバイダー、マネージド設定、ポリシー実行、使用状況監視、データ処理をカバーしています。

Claude Code は、ローカル開発者設定よりも優先されるマネージド設定を通じて組織ポリシーを実行します。これらの設定は Claude 管理コンソール、モバイルデバイス管理（MDM）システム、またはディスク上のファイルから配信します。設定は Claude が到達できるツール、コマンド、サーバー、ネットワーク宛先を制御します。

このページでは、展開の決定を順番に説明します。各行は以下のセクションと、その領域の参照ページにリンクしています。

<Note>
  SSO、SCIM プロビジョニング、シート割り当ては Claude アカウントレベルで設定されます。これらの手順については、[Claude Enterprise Administrator Guide](https://claude.com/resources/tutorials/claude-enterprise-administrator-guide) と [シート割り当て](https://support.claude.com/en/articles/11845131-use-claude-code-with-your-team-or-enterprise-plan) を参照してください。
</Note>

| 決定                                                        | 選択内容                      | 参照                                                                                                                                    |
| :-------------------------------------------------------- | :------------------------ | :------------------------------------------------------------------------------------------------------------------------------------ |
| [API プロバイダーを選択する](#choose-your-api-provider)              | Claude Code が認証される場所と課金方法 | [Authentication](/ja/authentication)、[Bedrock](/ja/amazon-bedrock)、[Vertex AI](/ja/google-vertex-ai)、[Foundry](/ja/microsoft-foundry) |
| [設定がデバイスに到達する方法を決定する](#decide-how-settings-reach-devices) | マネージドポリシーが開発者マシンに到達する方法   | [Server-managed settings](/ja/server-managed-settings)、[Settings files](/ja/settings#settings-files)                                  |
| [実行する内容を決定する](#decide-what-to-enforce)                    | どのツール、コマンド、統合が許可されるか      | [Permissions](/ja/permissions)、[Sandboxing](/ja/sandboxing)                                                                           |
| [使用状況の可視性をセットアップする](#set-up-usage-visibility)             | 支出と採用を追跡する方法              | [Analytics](/ja/analytics)、[Monitoring](/ja/monitoring-usage)、[Costs](/ja/costs)                                                      |
| [データ処理を確認する](#review-data-handling)                       | データ保持とコンプライアンス体制          | [Data usage](/ja/data-usage)、[Security](/ja/security)                                                                                 |

<h2 id="choose-your-api-provider">
  API プロバイダーを選択する
</h2>

Claude Code は複数の API プロバイダーのいずれかを通じて Claude に接続します。選択は課金、認証、継承するコンプライアンス体制、および開発者が使用できる Claude Code 機能に影響します。

| プロバイダー                        | 選択する場合                                                                                     |
| :---------------------------- | :----------------------------------------------------------------------------------------- |
| Claude for Teams / Enterprise | Claude Code と claude.ai を 1 つのシート単位のサブスクリプションで実行したい場合。実行するインフラストラクチャは不要です。これがデフォルトの推奨事項です。 |
| Claude Console                | API ファーストまたは従量課金を希望する場合                                                                    |
| Amazon Bedrock                | 既存の AWS コンプライアンス制御と課金を継承したい場合                                                              |
| Google Vertex AI              | 既存の GCP コンプライアンス制御と課金を継承したい場合                                                              |
| Microsoft Foundry             | 既存の Azure コンプライアンス制御と課金を継承したい場合                                                            |

一部の Claude Code 機能には claude.ai アカウントが必要です。[web 上の Claude Code](/ja/claude-code-on-the-web)、[Routines](/ja/routines)、[Code Review](/ja/code-review)、[Remote Control](/ja/remote-control)、および [Chrome 拡張機能](/ja/chrome) は、Console API キーまたはクラウドプロバイダーの認証情報だけでは利用できません。Bedrock、Vertex、または Foundry を通じてデプロイする場合は、開発者が Claude for Teams または Enterprise シートも必要かどうかを検討してください。各機能ページにはプラン要件が記載されています。

認証、リージョン、機能パリティをカバーする完全なプロバイダー比較については、[エンタープライズ展開概要](/ja/third-party-integrations) を参照してください。各プロバイダーの認証セットアップは [Authentication](/ja/authentication) にあります。

[ネットワーク設定](/ja/network-config) のプロキシとファイアウォール要件は、プロバイダーに関係なく適用されます。複数のプロバイダーの前に単一のエンドポイントを配置したい場合、または集中化されたリクエストログを記録したい場合は、[LLM gateway](/ja/llm-gateway) を参照してください。

<h2 id="decide-how-settings-reach-devices">
  設定がデバイスに到達する方法を決定する
</h2>

マネージド設定は、ローカル開発者設定よりも優先されるポリシーを定義します。Claude Code は以下の 4 つのソースを優先順位順にチェックし、空でない設定を返す最初のものを適用します。ただし 1 つの例外があります。[クロスソースロックキー](/ja/settings#settings-precedence)（サンドボックス許可リストロックなど）の小さなセットは、管理者が制御するソースがそれらを設定する場合に尊重されます。

| メカニズム                   | 配信                                                                                                                                                                                                  | 優先度 | プラットフォーム      |
| :---------------------- | :-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :-- | :------------ |
| Server-managed          | claude.ai 管理コンソール、またはゲートウェイサインイン用の自己ホスト型 [Claude apps gateway](/ja/claude-apps-gateway)                                                                                                             | 最高  | すべて           |
| plist / registry policy | macOS: `com.anthropic.claudecode` plist<br />Windows: `HKLM\SOFTWARE\Policies\ClaudeCode`                                                                                                           | 高   | macOS、Windows |
| File-based managed      | macOS: `/Library/Application Support/ClaudeCode/managed-settings.json`<br />Linux と WSL: `/etc/claude-code/managed-settings.json`<br />Windows: `C:\Program Files\ClaudeCode\managed-settings.json` | 中   | すべて           |
| Windows user registry   | `HKCU\SOFTWARE\Policies\ClaudeCode`                                                                                                                                                                 | 最低  | Windows のみ    |

設定済みの [`policyHelper`](/ja/settings#compute-managed-settings-with-a-policy-helper) は 4 つのソースすべてに優先します。その出力は実行時のマネージド設定の唯一のものになります。[設定の優先度](/ja/settings#settings-precedence) を参照してください。

Server-managed 設定はデバイスが認証されるときに到達し、アクティブなセッション中は 1 時間ごとに更新されます。エンドポイントインフラストラクチャは不要です。claude.ai 管理コンソール経由の配信には Claude for Teams または Enterprise プランが必要です。Bedrock、Vertex AI、または Foundry での展開は、[Claude apps gateway](/ja/claude-apps-gateway) を実行することで同じリモート配信を取得できます。または、代わりにファイルベースまたは OS レベルのメカニズムのいずれかを使用してください。

組織が複数のプロバイダーを混在させている場合、claude.ai ユーザー向けに [server-managed settings](/ja/server-managed-settings) を設定し、他のユーザーがマネージドポリシーを受け取るように [ファイルベースまたは plist/registry フォールバック](/ja/settings#settings-files) を設定してください。

plist と HKLM レジストリの場所は任意のプロバイダーで機能し、書き込みに管理者権限が必要なため、改ざんに強いです。HKCU の Windows ユーザーレジストリは昇格なしで書き込み可能なため、実行チャネルではなく便利なデフォルトとして扱ってください。

デフォルトでは WSL は `/etc/claude-code` の Linux ファイルパスのみを読み取ります。同じマシン上の WSL に Windows レジストリと `C:\Program Files\ClaudeCode` ポリシーを拡張するには、これらの管理者のみが使用できる Windows ソースのいずれかで [`wslInheritsWindowsSettings: true`](/ja/settings#available-settings) を設定してください。

どのメカニズムを選択しても、マネージド値はユーザーおよびプロジェクト設定よりも優先されます。`permissions.allow` や `permissions.deny` などの配列設定は、すべてのソースからのエントリをマージするため、開発者はマネージドリストを拡張できますが、削除することはできません。[2 つの例外](/ja/settings#settings-precedence)（`fallbackModel` と `availableModels`）では、マネージド値は下位レイヤーとマージするのではなく、置き換えます。

[Server-managed settings](/ja/server-managed-settings) と [Settings files and precedence](/ja/settings#settings-files) を参照してください。

<h2 id="decide-what-to-enforce">
  実行する内容を決定する
</h2>

マネージド設定は、ツール、サンドボックス実行、MCP サーバーとプラグインソースへのアクセスをロックダウンし、実行されるフックを制御できます。各行は、それを駆動する設定キーを持つ制御サーフェスです。

| 制御                                                                                     | 機能                                                                                                                                                                                                    | キー設定                                                                                                   |
| :------------------------------------------------------------------------------------- | :---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :----------------------------------------------------------------------------------------------------- |
| [Permission rules](/ja/permissions)                                                    | 特定のツールとコマンドを許可、確認、または拒否する                                                                                                                                                                             | `permissions.allow`、`permissions.deny`                                                                 |
| [Permission lockdown](/ja/permissions#managed-only-settings)                           | マネージドパーミッションルールのみが適用される。`--dangerously-skip-permissions` を無効化する                                                                                                                                       | `allowManagedPermissionRulesOnly`、`permissions.disableBypassPermissionsMode`                           |
| [Sandboxing](/ja/sandboxing)                                                           | ドメイン許可リスト付きの OS レベルのファイルシステムとネットワーク分離                                                                                                                                                                 | `sandbox.enabled`、`sandbox.network.allowedDomains`                                                     |
| [Managed policy CLAUDE.md](/ja/memory#deploy-organization-wide-claude-md)              | すべてのセッションで読み込まれる組織全体の指示。除外できない                                                                                                                                                                        | マネージドポリシーパスのファイル                                                                                       |
| [MCP server control](/ja/managed-mcp)                                                  | ユーザーが追加または接続できる MCP サーバーを制限するか、固定セットをデプロイする                                                                                                                                                           | `allowedMcpServers`、`deniedMcpServers`、`allowManagedMcpServersOnly`、またはデプロイされた `managed-mcp.json` ファイル |
| [Plugin marketplace control](/ja/plugin-marketplaces#managed-marketplace-restrictions) | ユーザーが追加およびインストールできるマーケットプレイスソースを制限し、単一実行のためにプラグイン、エージェント、MCP サーバーをサイドロードする CLI フラグを拒否する                                                                                                               | `strictKnownMarketplaces`、`blockedMarketplaces`、`disableSideloadFlags`                                 |
| [Customization lockdown](/ja/settings#strictpluginonlycustomization)                   | スキル、エージェント、フック、および MCP サーバーをユーザーおよびプロジェクトソースからブロックし、プラグインまたはマネージド設定からのみ取得できるようにする                                                                                                                     | `strictPluginOnlyCustomization`                                                                        |
| [Hook restrictions](/ja/settings#hook-configuration)                                   | マネージドフックのみが読み込まれる。HTTP フック URL を制限する                                                                                                                                                                  | `allowManagedHooksOnly`、`allowedHttpHookUrls`                                                          |
| [Disable agent view](/ja/agent-view#how-background-sessions-are-hosted)                | `claude agents`、`--bg`、`/background`、およびオンデマンドスーパーバイザーをオフにする                                                                                                                                          | `disableAgentView`                                                                                     |
| [Model restrictions](/ja/model-config#restrict-model-selection)                        | `availableModels` はピッカーに表示されるモデルをフィルタリングします。`enforceAvailableModels` を追加すると、自動選択されるデフォルトモデルも制限されます。この設定が CLI、ウェブ、IDE にどのように到達するかについては、[surface coverage](/ja/model-config#surface-coverage) を参照してください | `availableModels`、`enforceAvailableModels`                                                             |
| [Version floor](/ja/settings)                                                          | 自動更新が組織全体の最小値より下にインストールされるのを防ぐ                                                                                                                                                                        | `minimumVersion`                                                                                       |
| [Required version range](/ja/settings)                                                 | 実行中のバージョンが組織承認の範囲外の場合、まったく起動を拒否する。`minimumVersion` より強力で、ダウングレードのみをブロックする                                                                                                                             | `requiredMinimumVersion`、`requiredMaximumVersion`                                                      |

claude.ai または Anthropic API を通じて認証するメンバーを持つ組織は、設定をデプロイせずにモデルを管理することもできます。[organization model restrictions](/ja/model-config#organization-model-restrictions) は個別のモデルを無効化し、[organization default model](/ja/model-config#organization-default-model) は新しいセッションが開始するモデルを設定し、[organization effort limits](/ja/model-config#organization-effort-limits) はロールごとのエフォートレベルを制限します。3 つのコントロールすべてに Claude Enterprise プランが必要です。モデル制限とエフォート制限はサーバー側で実行されます。デフォルトモデルは、組織がそれを実行しない限り、ユーザーが変更できる開始点です。実行は限定的な組織セットで利用可能です。可用性については、Anthropic アカウントチームにお問い合わせください。これらのコントロールのいずれも、Amazon Bedrock、Google Cloud の Agent Platform、Microsoft Foundry、または [Claude Platform on AWS](/ja/claude-platform-on-aws) 上のセッションには到達しません。これらのプロバイダーでは、制限に上記の `availableModels` を使用し、マネージド設定の `model` キーをデフォルトに使用してください。

パーミッションルールとサンドボックスは異なるレイヤーをカバーします。WebFetch を拒否すると Claude の fetch ツールがブロックされますが、Bash が許可されている場合、`curl` と `wget` は依然として任意の URL に到達できます。サンドボックスは OS レベルで実行されるネットワークドメイン許可リストでそのギャップを閉じます。

これらの制御が防御する脅威モデルについては、[Security](/ja/security) を参照してください。

<h2 id="set-up-usage-visibility">
  使用状況の可視性をセットアップする
</h2>

必要なレポート内容に基づいて監視を選択してください。

| 機能                  | 取得内容                                 | 利用可能性                                                                                                                                   | 開始場所                                     |
| :------------------ | :----------------------------------- | :-------------------------------------------------------------------------------------------------------------------------------------- | :--------------------------------------- |
| Usage monitoring    | セッション、ツール、トークンの OpenTelemetry エクスポート | すべてのプロバイダー                                                                                                                              | [Monitoring usage](/ja/monitoring-usage) |
| Analytics dashboard | ユーザーごとのメトリクス、貢献度追跡、リーダーボード           | Anthropic のみ                                                                                                                            | [Analytics](/ja/analytics)               |
| Cost tracking       | 支出制限、レート制限、使用状況の属性                   | Anthropic；サードパーティクラウドでは、[Claude apps gateway](/ja/claude-apps-gateway) が ユーザーごとの属性と [支出制限](/ja/claude-apps-gateway-spend-limits) を提供します | [Costs](/ja/costs)                       |

クラウドプロバイダーは AWS Cost Explorer、GCP Billing、または Azure Cost Management を通じて支出を公開します。Claude for Teams および Enterprise プランには、[claude.ai/analytics/claude-code](https://claude.ai/analytics/claude-code) での使用状況ダッシュボードが含まれています。

<h2 id="review-data-handling">
  データ処理を確認する
</h2>

Team、Enterprise、Claude API、およびクラウドプロバイダープランでは、Anthropic はコードまたはプロンプトでモデルをトレーニングしません。API プロバイダーが保持とコンプライアンス体制を決定します。

| トピック                     | 知っておくべきこと                                      | 開始場所                                           |
| :----------------------- | :--------------------------------------------- | :--------------------------------------------- |
| Data usage policy        | Anthropic が収集する内容、保持期間、トレーニングに使用されない内容         | [Data usage](/ja/data-usage)                   |
| Zero Data Retention（ZDR） | リクエスト完了後は何も保存されません。Claude for Enterprise で利用可能 | [Zero data retention](/ja/zero-data-retention) |
| Security architecture    | ネットワークモデル、暗号化、認証、監査証跡                          | [Security](/ja/security)                       |

リクエストレベルの監査ログが必要な場合、またはデータの機密性によってトラフィックをルーティングしたい場合は、開発者とプロバイダーの間にゲートウェイを配置してください。自ホスト型の [Claude apps gateway](/ja/claude-apps-gateway) は IdP ID を使用してリクエストごとの監査ログを記録するか、別の [LLM gateway](/ja/llm-gateway) を使用してください。規制要件と認定については、[Legal and compliance](/ja/legal-and-compliance) を参照してください。

<h2 id="verify-and-onboard">
  検証とオンボード
</h2>

マネージド設定を設定した後、開発者に Claude Code 内で `/status` を実行させてください。**Status** タブの `Setting sources` 行に `Enterprise managed settings` が表示され、その後に括弧内のソースが続きます。`(remote)`、`(plist)`、`(HKLM)`、`(HKCU)`、または `(file)` のいずれかです。[アクティブな設定を検証](/ja/settings#verify-active-settings) を参照してください。

開発者が開始するのに役立つこれらのリソースを共有してください。

* [クイックスタート](/ja/quickstart): インストールからプロジェクトの操作まで、最初のセッションのウォークスルー
* [一般的なワークフロー](/ja/common-workflows): コードレビュー、リファクタリング、デバッグなどの日常的なタスクのパターン
* [Claude 101](https://anthropic.skilljar.com/claude-101) と [Claude Code in Action](https://anthropic.skilljar.com/claude-code-in-action): Anthropic Academy の自習型コース

ログインの問題については、開発者に [認証のトラブルシューティング](/ja/troubleshoot-install#login-and-authentication) を指してください。最も一般的な修正は次のとおりです。

* `/logout` を実行してから `/login` を実行してアカウントを切り替える
* エンタープライズ認証オプションが見つからない場合は `claude update` を実行する
* 更新後にターミナルを再起動する

開発者が「You haven't been added to your organization yet」というメッセージを見た場合、そのシートには Claude Code アクセスが含まれておらず、管理コンソールで更新する必要があります。

<h2 id="next-steps">
  次のステップ
</h2>

プロバイダーと配信メカニズムを選択したら、詳細な設定に進みます。

* [Server-managed settings](/ja/server-managed-settings): Claude 管理コンソールからマネージドポリシーを配信する
* [Settings reference](/ja/settings): すべての設定キー、ファイルの場所、優先度ルール
* [Monorepos and large repos](/ja/large-codebases): 大規模リポジトリをデプロイする組織向けのディレクトリごとの設定パターン
* [Amazon Bedrock](/ja/amazon-bedrock)、[Google Vertex AI](/ja/google-vertex-ai)、[Microsoft Foundry](/ja/microsoft-foundry): プロバイダー固有のデプロイメント
* [Claude Enterprise Administrator Guide](https://claude.com/resources/tutorials/claude-enterprise-administrator-guide): SSO、SCIM、シート管理、ロールアウトプレイブック
