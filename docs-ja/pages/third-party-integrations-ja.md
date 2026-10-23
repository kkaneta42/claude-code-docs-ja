> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# エンタープライズデプロイメント概要

> Claude Code が様々なサードパーティサービスとインフラストラクチャと統合して、エンタープライズデプロイメント要件を満たす方法について学びます。

組織は Anthropic を通じて直接、またはクラウドプロバイダーを通じて Claude Code をデプロイできます。このページは、適切な構成を選択するのに役立ちます。

**Deploying Claude Code across your organization?** Talk to sales about enterprise plans, SSO, and centralized billing.

View plans
Contact sales

## デプロイメントオプションの比較

ほとんどの組織では、Claude for Teams または Claude for Enterprise が最適なエクスペリエンスを提供します。チームメンバーは、単一のサブスクリプション、一元化された請求、インフラストラクチャセットアップが不要で、Claude Code と Web 上の Claude の両方にアクセスできます。

**Claude for Teams** はセルフサービスで、コラボレーション機能、管理ツール、SSO、請求管理、および[サーバー管理設定](/docs/ja/server-managed-settings.md)（組織全体の Claude Code 構成用）が含まれています。迅速に開始する必要がある小規模なチームに最適です。

**Claude for Enterprise** はドメインキャプチャ、ロールベースの権限、およびコンプライアンス API アクセスを追加します。セキュリティとコンプライアンス要件がある大規模な組織に最適です。

[Team プラン](https://support.claude.com/en/articles/9266767-what-is-the-team-plan)と[Enterprise プラン](https://support.claude.com/en/articles/9797531-what-is-the-enterprise-plan)の詳細をご覧ください。

以下で比較されるデプロイメントオプションは、モデル推論が実行される場所をカバーしています。組織が運用するコンピュート上で [Claude Code on the web](/docs/ja/claude-code-on-the-web.md) セッションを実行するには、[セルフホスト環境](/docs/ja/self-hosted-environments)を参照してください。

組織に特定のインフラストラクチャ要件がある場合は、以下のオプションを比較してください。

<table>
  <thead>
    <tr>
      <th>機能</th>
      <th>Claude for Teams/Enterprise</th>
      <th>Anthropic Console</th>
      <th>Amazon Bedrock</th>
      <th>Claude Platform on AWS</th>
      <th>Google Cloud の Agent Platform（旧 Vertex AI）</th>
      <th>Microsoft Foundry</th>
    </tr>
  </thead>

  <tbody>
    <tr>
      <td>最適な用途</td>
      <td>ほとんどの組織（推奨）</td>
      <td>個別開発者</td>
      <td>AWS ネイティブデプロイメント</td>
      <td>Claude API 機能を備えた AWS Marketplace 請求</td>
      <td>GCP ネイティブデプロイメント</td>
      <td>Azure ネイティブデプロイメント</td>
    </tr>

    <tr>
      <td>請求</td>
      <td>**Teams:** シートあたりのサブスクリプション（PAYG 利用可能）、[価格](https://claude.com/pricing?utm_source=claude_code\&utm_medium=docs\&utm_content=third_party_pricing#team-&-enterprise)を参照\
      **Enterprise:** [営業に連絡](https://claude.com/contact-sales?utm_source=claude_code\&utm_medium=docs\&utm_content=third_party_enterprise)</td>
      <td>PAYG</td>
      <td>AWS 経由の PAYG</td>
      <td>AWS Marketplace 経由の PAYG</td>
      <td>GCP 経由の PAYG</td>
      <td>Azure 経由の PAYG</td>
    </tr>

    <tr>
      <td>リージョン</td>
      <td>サポート対象[国](https://www.anthropic.com/supported-countries)</td>
      <td>サポート対象[国](https://www.anthropic.com/supported-countries)</td>
      <td>複数の AWS [リージョン](https://docs.aws.amazon.com/bedrock/latest/userguide/models-regions.html)</td>
      <td>複数の AWS リージョン</td>
      <td>複数の GCP [リージョン](https://cloud.google.com/vertex-ai/generative-ai/docs/learn/locations)</td>
      <td>複数の Azure [リージョン](https://azure.microsoft.com/en-us/explore/global-infrastructure/products-by-region/)</td>
    </tr>

    <tr>
      <td>Prompt caching</td>
      <td>デフォルトで有効</td>
      <td>デフォルトで有効</td>
      <td>デフォルトで有効</td>
      <td>デフォルトで有効</td>
      <td>デフォルトで有効</td>
      <td>デフォルトで有効</td>
    </tr>

    <tr>
      <td>認証</td>
      <td>claude.ai SSO またはメール</td>
      <td>API キーまたは [API キーなしのコンソールサインイン](/docs/ja/authentication.md#sign-in-without-an-api-key)</td>
      <td>API キーまたは AWS 認証情報</td>
      <td>API キーまたは AWS 認証情報</td>
      <td>GCP 認証情報</td>
      <td>API キーまたは Microsoft Entra ID</td>
    </tr>

    <tr>
      <td>コスト追跡</td>
      <td>使用状況ダッシュボード</td>
      <td>使用状況ダッシュボード</td>
      <td>AWS Cost Explorer</td>
      <td>AWS Cost Explorer</td>
      <td>GCP Billing</td>
      <td>Azure Cost Management</td>
    </tr>

    <tr>
      <td>Web 上の Claude を含む</td>
      <td>はい</td>
      <td>いいえ</td>
      <td>いいえ</td>
      <td>いいえ</td>
      <td>いいえ</td>
      <td>いいえ</td>
    </tr>

    <tr>
      <td>エンタープライズ機能</td>
      <td>チーム管理、SSO、使用状況監視</td>
      <td>なし</td>
      <td>IAM ポリシー、CloudTrail</td>
      <td>IAM ポリシー、CloudTrail</td>
      <td>IAM ロール、Cloud Audit Logs</td>
      <td>RBAC ポリシー、Azure Monitor</td>
    </tr>
  </tbody>
</table>

各オプションで利用可能な機能の詳細な比較については、[機能の可用性](/docs/ja/feature-availability.md)を参照してください。

デプロイメントオプションを選択してセットアップ手順を表示します。

* [Claude for Teams または Enterprise](/docs/ja/authentication.md#claude-for-teams-or-enterprise)
* [Anthropic Console](/docs/ja/authentication.md#claude-console-authentication)
* [Claude apps gateway](/docs/ja/claude-apps-gateway)、Amazon Bedrock、Claude Platform on AWS、Google Cloud の Agent Platform、Microsoft Foundry、または Anthropic API の前に IdP サインインを追加するセルフホスト型ゲートウェイ
* [Amazon Bedrock](/docs/ja/amazon-bedrock.md)
* [Claude Platform on AWS](/docs/ja/claude-platform-on-aws.md)
* [Google Cloud の Agent Platform](/docs/ja/google-vertex-ai.md)
* [Microsoft Foundry](/docs/ja/microsoft-foundry.md)

Amazon Bedrock と Google Vertex AI の場合、ログインプロンプトで `claude` を実行して**3rd-party platform** を選択し、インタラクティブセットアップウィザードを起動することもできます。

## プロキシとゲートウェイの構成

ほとんどの組織は、追加の構成なしでクラウドプロバイダーを直接使用できます。ただし、組織に特定のネットワークまたは管理要件がある場合は、企業プロキシまたは LLM ゲートウェイを構成する必要がある場合があります。これらは一緒に使用できる異なる構成です。

* **企業プロキシ**: HTTP/HTTPS プロキシを通じてトラフィックをルーティングします。組織がセキュリティ監視、コンプライアンス、またはネットワークポリシー実装のためにすべての送信トラフィックをプロキシサーバーを通じて渡す必要がある場合に使用します。`HTTPS_PROXY` または `HTTP_PROXY` 環境変数で構成します。[エンタープライズネットワーク構成](/docs/ja/network-config.md)で詳細をご覧ください。
* **LLM ゲートウェイ**: Claude Code とクラウドプロバイダーの間に位置して、認証とルーティングを処理するサービスです。チーム全体の一元化された使用状況追跡、カスタムレート制限または予算、または一元化された認証管理が必要な場合に使用します。`ANTHROPIC_BASE_URL`、`ANTHROPIC_BEDROCK_BASE_URL`、`ANTHROPIC_AWS_BASE_URL`、`ANTHROPIC_VERTEX_BASE_URL`、または `ANTHROPIC_FOUNDRY_BASE_URL` 環境変数で構成します。[LLM ゲートウェイ](/docs/ja/llm-gateway)で詳細をご覧ください。

プロバイダーごとの環境変数で Amazon Bedrock、Microsoft Foundry、または Google Cloud の Agent Platform を LLM ゲートウェイを通じてルーティングする場合は、[ゲートウェイを通じてクラウドプロバイダーにルーティング](/docs/ja/llm-gateway-connect.md#route-to-a-cloud-provider-through-a-gateway)を参照してください。Claude Code で `/status` を実行して、セッションが使用しているプロバイダー、ベース URL、およびプロキシを確認します。

組織が[顧客管理暗号化キー](https://platform.claude.com/docs/en/manage-claude/cmek)（CMEK）を使用し、Claude Code を LLM ゲートウェイまたはカスタム `ANTHROPIC_BASE_URL` を通じてルーティングする場合、CMEK はそれらのセッションの Claude Code の運用テレメトリには適用されません。すべての開発者のテレメトリをオフにするには、[組織のテレメトリをオフにする](/docs/ja/managed-settings.md#turn-telemetry-off-for-your-organization)に示されているように、管理設定を通じて `DISABLE_TELEMETRY` を配信します。

## 組織のベストプラクティス

### ドキュメントとメモリに投資する

Claude Code がコードベースを理解できるように、ドキュメントに投資してください。組織は複数のレベルで CLAUDE.md ファイルをデプロイできます。[CLAUDE.md ファイルをどこに配置できるか](/docs/ja/memory.md#choose-where-to-put-claude-md-files)と[組織全体の CLAUDE.md をデプロイする方法](/docs/ja/memory.md#deploy-organization-wide-claude-md)をご覧ください。

### デプロイメントを簡素化する

カスタム開発環境がある場合は、Claude Code をインストールする「ワンクリック」の方法を作成することが、組織全体での採用を促進するための鍵となります。

### ガイド付き使用から始める

新しいユーザーに Claude Code をコードベースの Q\&A、または小さなバグ修正または機能リクエストで試すことをお勧めします。Claude Code にプランを作成するよう依頼します。Claude の提案を確認し、軌道を外れている場合はフィードバックを提供します。時間が経つにつれて、ユーザーがこの新しいパラダイムをより理解するようになると、Claude Code をより積極的に実行させるのに効果的になります。

### クラウドプロバイダーのモデルバージョンをピン留めする

[Amazon Bedrock](/docs/ja/amazon-bedrock.md)、[Google Cloud の Agent Platform](/docs/ja/google-vertex-ai.md)、[Microsoft Foundry](/docs/ja/microsoft-foundry.md)、または [Claude Platform on AWS](/docs/ja/claude-platform-on-aws.md) を通じてデプロイする場合は、`ANTHROPIC_DEFAULT_FABLE_MODEL`、`ANTHROPIC_DEFAULT_OPUS_MODEL`、`ANTHROPIC_DEFAULT_SONNET_MODEL`、および `ANTHROPIC_DEFAULT_HAIKU_MODEL` を使用して特定のモデルバージョンをピン留めします。ピン留めしない場合、モデルエイリアスは Claude Code のそのプロバイダーの組み込みデフォルトに解決され、最新リリースより遅れる可能性があり、アカウントでまだ有効になっていない可能性があります。ピン留めすることで、ユーザーが新しいモデルに移行するタイミングを制御できます。各プロバイダーがデフォルトが利用できない場合に何を行うかについては、[モデル構成](/docs/ja/model-config.md#pin-models-for-third-party-deployments)を参照してください。

### セキュリティポリシーを構成する

セキュリティチームは、Claude Code が実行できることと実行できないことに対する管理権限を構成できます。これはローカル構成によって上書きされません。[詳細をご覧ください](/docs/ja/security.md)。

これらのデプロイメントオプションのうち、管理対象マシンが使用できるものを制限するには、管理設定で [`allowedProviders`](/docs/ja/settings-reference#allowedproviders) を設定します。たとえば、`["bedrock"]` は Amazon Bedrock のみを許可します。Mantle エンドポイントも有効にする Bedrock フリートは `"mantle"` も一覧に含めます。このエントリは、管理対象の `env` ピン留めも必要なエンドポイント変数を示します。Claude Code v2.1.285 以降が必要です。

### 統合に MCP を活用する

MCP は Claude Code にチケット管理システムやエラーログへの接続など、より多くの情報を提供する優れた方法です。1 つの中央チームが MCP サーバーを構成し、`.mcp.json` 構成をコードベースにチェックインして、すべてのユーザーが恩恵を受けられるようにします。[詳細をご覧ください](/docs/ja/mcp.md)。

## 次のステップ

デプロイメントオプションを選択し、チームのアクセスを構成したら、以下を実行します。

1. **チームにロールアウトする**: インストール手順を共有し、チームメンバーに [Claude Code をインストール](/docs/ja/setup.md)して認証情報で認証するよう依頼します。
2. **共有構成をセットアップする**: リポジトリに [CLAUDE.md ファイル](/docs/ja/memory.md)を作成して、Claude Code がコードベースとコーディング標準を理解するのに役立てます。
3. **権限を構成する**: [セキュリティ設定](/docs/ja/security.md)を確認して、環境内で Claude Code が実行できることと実行できないことを定義します。
