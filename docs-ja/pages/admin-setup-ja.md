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

## API プロバイダーを選択する

Claude Code は複数の API プロバイダーのいずれかを通じて Claude に接続します。選択は課金、認証、継承するコンプライアンス体制に影響します。

| プロバイダー                        | 選択する場合                                                                                     |
| :---------------------------- | :----------------------------------------------------------------------------------------- |
| Claude for Teams / Enterprise | Claude Code と claude.ai を 1 つのシート単位のサブスクリプションで実行したい場合。実行するインフラストラクチャは不要です。これがデフォルトの推奨事項です。 |
| Claude Console                | API ファーストまたは従量課金を希望する場合                                                                    |
| Amazon Bedrock                | 既存の AWS コンプライアンス制御と課金を継承したい場合                                                              |
| Google Vertex AI              | 既存の GCP コンプライアンス制御と課金を継承したい場合                                                              |
| Microsoft Foundry             | 既存の Azure コンプライアンス制御と課金を継承したい場合                                                            |

認証、リージョン、機能パリティをカバーする完全なプロバイダー比較については、[エンタープライズ展開概要](/ja/third-party-integrations) を参照してください。各プロバイダーの認証セットアップは [Authentication](/ja/authentication) にあります。

[ネットワーク設定](/ja/network-config) のプロキシとファイアウォール要件は、プロバイダーに関係なく適用されます。複数のプロバイダーの前に単一のエンドポイントを配置したい場合、または集中化されたリクエストログを記録したい場合は、[LLM gateway](/ja/llm-gateway) を参照してください。

## 設定がデバイスに到達する方法を決定する

マネージド設定は、ローカル開発者設定よりも優先されるポリシーを定義します。Claude Code は 4 つの場所で設定を探し、特定のデバイスで最初に見つかったものを使用します。

| メカニズム                   | 配信                                                                                                                                                                                                  | 優先度 | プラットフォーム      |
| :---------------------- | :-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :-- | :------------ |
| Server-managed          | Claude.ai 管理コンソール                                                                                                                                                                                   | 最高  | すべて           |
| plist / registry policy | macOS: `com.anthropic.claudecode` plist<br />Windows: `HKLM\SOFTWARE\Policies\ClaudeCode`                                                                                                           | 高   | macOS、Windows |
| File-based managed      | macOS: `/Library/Application Support/ClaudeCode/managed-settings.json`<br />Linux と WSL: `/etc/claude-code/managed-settings.json`<br />Windows: `C:\Program Files\ClaudeCode\managed-settings.json` | 中   | すべて           |
| Windows user registry   | `HKCU\SOFTWARE\Policies\ClaudeCode`                                                                                                                                                                 | 最低  | Windows のみ    |

Server-managed 設定はデバイスが認証されるときに到達し、アクティブなセッション中は 1 時間ごとに更新されます。エンドポイントインフラストラクチャは不要です。Claude for Teams または Enterprise プランが必要なため、他のプロバイダーでの展開は、代わりにファイルベースまたは OS レベルのメカニズムのいずれかが必要です。

組織が複数のプロバイダーを混在させている場合、Claude.ai ユーザー向けに [server-managed settings](/ja/server-managed-settings) を設定し、他のユーザーがマネージドポリシーを受け取るように [ファイルベースまたは plist/registry フォールバック](/ja/settings#settings-files) を設定してください。

plist と HKLM レジストリの場所は任意のプロバイダーで機能し、書き込みに管理者権限が必要なため、改ざんに強いです。HKCU の Windows ユーザーレジストリは昇格なしで書き込み可能なため、実行チャネルではなく便利なデフォルトとして扱ってください。

デフォルトでは WSL は `/etc/claude-code` の Linux ファイルパスのみを読み取ります。同じマシン上の WSL に Windows レジストリと `C:\Program Files\ClaudeCode` ポリシーを拡張するには、これらの管理者のみが使用できる Windows ソースのいずれかで [`wslInheritsWindowsSettings: true`](/ja/settings#available-settings) を設定してください。

どのメカニズムを選択しても、マネージド値はユーザーおよびプロジェクト設定よりも優先されます。`permissions.allow` や `permissions.deny` などの配列設定は、すべてのソースからのエントリをマージするため、開発者はマネージドリストを拡張できますが、削除することはできません。

[Server-managed settings](/ja/server-managed-settings) と [Settings files and precedence](/ja/settings#settings-files) を参照してください。

## 実行する内容を決定する

マネージド設定は、ツール、サンドボックス実行、MCP サーバーとプラグインソースへのアクセスをロックダウンし、実行されるフックを制御できます。各行は、それを駆動する設定キーを持つ制御サーフェスです。

| 制御                                                                                     | 機能                                                              | キー設定                                                                         |
| :------------------------------------------------------------------------------------- | :-------------------------------------------------------------- | :--------------------------------------------------------------------------- |
| [Permission rules](/ja/permissions)                                                    | 特定のツールとコマンドを許可、確認、または拒否する                                       | `permissions.allow`、`permissions.deny`                                       |
| [Permission lockdown](/ja/permissions#managed-only-settings)                           | マネージドパーミッションルールのみが適用される。`--dangerously-skip-permissions` を無効化する | `allowManagedPermissionRulesOnly`、`permissions.disableBypassPermissionsMode` |
| [Sandboxing](/ja/sandboxing)                                                           | ドメイン許可リスト付きの OS レベルのファイルシステムとネットワーク分離                           | `sandbox.enabled`、`sandbox.network.allowedDomains`                           |
| [Managed policy CLAUDE.md](/ja/memory#deploy-organization-wide-claude-md)              | すべてのセッションで読み込まれる組織全体の指示。除外できない                                  | マネージドポリシーパスのファイル                                                             |
| [MCP server control](/ja/mcp#managed-mcp-configuration)                                | ユーザーが追加または接続できる MCP サーバーを制限する                                   | `allowedMcpServers`、`deniedMcpServers`、`allowManagedMcpServersOnly`          |
| [Plugin marketplace control](/ja/plugin-marketplaces#managed-marketplace-restrictions) | ユーザーが追加およびインストールできるマーケットプレイスソースを制限する                            | `strictKnownMarketplaces`、`blockedMarketplaces`                              |
| [Hook restrictions](/ja/settings#hook-configuration)                                   | マネージドフックのみが読み込まれる。HTTP フック URL を制限する                            | `allowManagedHooksOnly`、`allowedHttpHookUrls`                                |
| [Version floor](/ja/settings)                                                          | 自動更新が組織全体の最小値より下にインストールされるのを防ぐ                                  | `minimumVersion`                                                             |

パーミッションルールとサンドボックスは異なるレイヤーをカバーします。WebFetch を拒否すると Claude の fetch ツールがブロックされますが、Bash が許可されている場合、`curl` と `wget` は依然として任意の URL に到達できます。サンドボックスは OS レベルで実行されるネットワークドメイン許可リストでそのギャップを閉じます。

これらの制御が防御する脅威モデルについては、[Security](/ja/security) を参照してください。

## 使用状況の可視性をセットアップする

必要なレポート内容に基づいて監視を選択してください。

| 機能                  | 取得内容                                 | 利用可能性        | 開始場所                                     |
| :------------------ | :----------------------------------- | :----------- | :--------------------------------------- |
| Usage monitoring    | セッション、ツール、トークンの OpenTelemetry エクスポート | すべてのプロバイダー   | [Monitoring usage](/ja/monitoring-usage) |
| Analytics dashboard | ユーザーごとのメトリクス、貢献度追跡、リーダーボード           | Anthropic のみ | [Analytics](/ja/analytics)               |
| Cost tracking       | 支出制限、レート制限、使用状況の属性                   | Anthropic のみ | [Costs](/ja/costs)                       |

クラウドプロバイダーは AWS Cost Explorer、GCP Billing、または Azure Cost Management を通じて支出を公開します。Claude for Teams および Enterprise プランには、[claude.ai/analytics/claude-code](https://claude.ai/analytics/claude-code) での使用状況ダッシュボードが含まれています。

## データ処理を確認する

Team、Enterprise、Claude API、およびクラウドプロバイダープランでは、Anthropic はコードまたはプロンプトでモデルをトレーニングしません。API プロバイダーが保持とコンプライアンス体制を決定します。

| トピック                     | 知っておくべきこと                                      | 開始場所                                           |
| :----------------------- | :--------------------------------------------- | :--------------------------------------------- |
| Data usage policy        | Anthropic が収集する内容、保持期間、トレーニングに使用されない内容         | [Data usage](/ja/data-usage)                   |
| Zero Data Retention（ZDR） | リクエスト完了後は何も保存されません。Claude for Enterprise で利用可能 | [Zero data retention](/ja/zero-data-retention) |
| Security architecture    | ネットワークモデル、暗号化、認証、監査証跡                          | [Security](/ja/security)                       |

リクエストレベルの監査ログが必要な場合、またはデータの機密性によってトラフィックをルーティングしたい場合は、開発者とプロバイダーの間に [LLM gateway](/ja/llm-gateway) を配置してください。規制要件と認定については、[Legal and compliance](/ja/legal-and-compliance) を参照してください。

## 検証とオンボード

マネージド設定を設定した後、開発者に Claude Code 内で `/status` を実行させてください。出力には `Enterprise managed settings` で始まる行が含まれ、その後に括弧内のソースが続きます。`(remote)`、`(plist)`、`(HKLM)`、`(HKCU)`、または `(file)` のいずれかです。[Verify active settings](/ja/settings#verify-active-settings) を参照してください。

開発者が開始するのに役立つこれらのリソースを共有してください。

* [Quickstart](/ja/quickstart): インストールからプロジェクトの操作まで、最初のセッションのウォークスルー
* [Common workflows](/ja/common-workflows): コードレビュー、リファクタリング、デバッグなどの日常的なタスクのパターン
* [Claude 101](https://anthropic.skilljar.com/claude-101) と [Claude Code in Action](https://anthropic.skilljar.com/claude-code-in-action): Anthropic Academy の自習型コース

ログインの問題については、開発者に [authentication troubleshooting](/ja/troubleshooting#authentication-issues) を指してください。最も一般的な修正は次のとおりです。

* `/logout` を実行してから `/login` を実行してアカウントを切り替える
* エンタープライズ認証オプションが見つからない場合は `claude update` を実行する
* 更新後にターミナルを再起動する

開発者が「You haven't been added to your organization yet」というメッセージを見た場合、そのシートには Claude Code アクセスが含まれておらず、管理コンソールで更新する必要があります。

## 次のステップ

プロバイダーと配信メカニズムを選択したら、詳細な設定に進みます。

* [Server-managed settings](/ja/server-managed-settings): Claude 管理コンソールからマネージドポリシーを配信する
* [Settings reference](/ja/settings): すべての設定キー、ファイルの場所、優先度ルール
* [Amazon Bedrock](/ja/amazon-bedrock)、[Google Vertex AI](/ja/google-vertex-ai)、[Microsoft Foundry](/ja/microsoft-foundry): プロバイダー固有の展開
* [Claude Enterprise Administrator Guide](https://claude.com/resources/tutorials/claude-enterprise-administrator-guide): SSO、SCIM、シート管理、ロールアウトプレイブック
