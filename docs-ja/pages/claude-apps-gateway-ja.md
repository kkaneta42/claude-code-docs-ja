> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# Amazon Bedrock、Claude Platform on AWS、Google Cloud、Microsoft Foundry 向け Claude アプリゲートウェイ

> SSO サインイン、グループごとのモデルアクセス、OTLP テレメトリを備えた自己ホスト型ゲートウェイを通じて、Amazon Bedrock、Claude Platform on AWS、Google Cloud、または Microsoft Foundry で Claude Code を実行します。

> [!NOTE]
>
> Claude アプリゲートウェイは、[データレジデンシー](https://code.claude.com/docs/ja/claude-apps-gateway-deploy.md#compliance-posture)要件を満たすなど、独自のクラウドプロバイダーを通じて推論をルーティングする必要がある、または希望する組織向けに設計されています。この要件がない場合、SCIM プロビジョニングや web・モバイル上の Claude Code などの他の機能へのアクセスを希望する場合は、Claude Enterprise の方がより適切である可能性があります。すべてのデプロイメント方法の完全な比較については、[機能可用性](https://code.claude.com/docs/ja/feature-availability.md)ページを参照してください。
>
> Claude Code は一度に 1 つのサインインのみを使用します。ゲートウェイへのサインインは、Claude for Teams または Enterprise のログインに代わるものです。ゲートウェイセッションは claude.ai の管理コンソールで設定した[サーバー管理設定](https://code.claude.com/docs/ja/server-managed-settings.md)を取得しないため、ゲートウェイの [`managed` ブロック](https://code.claude.com/docs/ja/claude-apps-gateway-config#managed)から配信してください。そのブロックには `forceLoginMethod` と `forceLoginOrgUUID` を含めないでください。含めると、[サインイン済みの一部のセッションが起動時に終了します](https://code.claude.com/docs/ja/claude-apps-gateway-config.md#client-side-managed-settings)。ゲートウェイセッションで失われるものについては、[可用性と制限事項](#availability-and-limitations)を参照してください。

Claude アプリゲートウェイは、開発者の Claude Code クライアントとモデルプロバイダーの間に位置する自己ホスト型サービスです。開発者は API キーやクラウド認証情報を保持する代わりに、企業の ID プロバイダー（IdP）でサインインします。ゲートウェイはアップストリーム認証情報を保持し、IdP グループによるモデルアクセスと[管理設定](https://code.claude.com/docs/ja/managed-settings.md)を強制し、使用状況テレメトリを独自の可観測性スタックにリレーします。

これは `claude` バイナリに含まれているため、ラップトップで Claude Code を実行する同じ実行ファイルが `claude gateway --config gateway.yaml` でゲートウェイサーバーを実行します。

このページでは以下をカバーしています。

* [Claude アプリゲートウェイを使用する理由](#why-claude-apps-gateway)、独自に実行する場合に何が追加されるか、および他の何かがより適切な場合
* [前提条件](#prerequisites)を含む[クイックスタート](#quickstart)。ゲートウェイをゼロからサインイン済みの開発者まで進めます
* [開発者の接続](#connect-developers)。管理設定を通じてゲートウェイ URL を設定することを含みます
* [可用性と制限事項](#availability-and-limitations)。ゲートウェイを通じてどの Claude Code 機能が機能するか、およびサーバーが何をサポートするかをカバーしています

関連ページはさらに詳しく説明しています。[設定リファレンス](https://code.claude.com/docs/ja/claude-apps-gateway-config.md)はクイックスタートが書き込む YAML ファイルのすべてのオプションをカバーし、[デプロイメントガイド](https://code.claude.com/docs/ja/claude-apps-gateway-deploy.md)は IdP ごとのセットアップ、Kubernetes と Cloud Run デプロイメント、および運用をカバーしています。

## Claude apps gateway を使用する理由

[ゲートウェイの概要](https://code.claude.com/docs/ja/gateways.md)はゲートウェイが何をするか、なぜ実行するかをカバーしています。Claude apps gateway は Anthropic 独自のゲートウェイで、`claude` バイナリに組み込まれており、各 Claude Code リリースと一緒にテストされているため、Claude Code が送信する `anthropic-beta` の値とリクエストフィールドを、オペレーターが個別の許可リストを維持することなく転送します。デプロイされると、以下が得られます。

* **認証情報**：アップストリーム API キーまたはクラウド認証情報は、インフラストラクチャ内にのみ存在します。開発者は企業 SSO で認証し、短期間有効なベアラートークンを受け取るため、オフボーディングは IdP で発生します。ユーザーをプロビジョニング解除すると、ゲートウェイアクセスはセッション有効期間内に期限切れになります。デフォルトは 1 時間です。
* **アクセス制御**：IdP グループはモデル許可リスト、[管理設定](https://code.claude.com/docs/ja/managed-settings.md)ポリシー、および[アップストリーム](https://code.claude.com/docs/ja/claude-apps-gateway-config.md#send-each-team-to-its-own-upstream)にマップされます。ゲートウェイはモデルアクセスをサーバー側で強制し、許可されていないモデルのリクエストを拒否し、各グループの管理設定ポリシーを選択します。CLI は[管理設定層](https://code.claude.com/docs/ja/settings.md#settings-precedence)でこれを適用します。異なるチームは異なるモデル、ツール、および権限を取得し、開発者はポリシーがロックしているものを上書きできません。
* **設定配信**：ゲートウェイは管理設定をサインイン済みクライアント自体に配信し、claude.ai 管理コンソールからの[サーバー管理設定](https://code.claude.com/docs/ja/server-managed-settings.md)の場所を取ります。
* **テレメトリ**：各設定先は、デフォルトではトークン数、モデル、ユーザーアイデンティティ、レイテンシを含む[OpenTelemetry Protocol（OTLP）メトリクス](https://code.claude.com/docs/ja/monitoring-usage.md)を受け取り、ログとトレースは宛先ごとのオプトインです。
* **アップストリームルーティング**：クライアントは Anthropic Messages API をゲートウェイに話しかけ、ゲートウェイは各アップストリーム（Amazon Bedrock、[Claude Platform on AWS](https://code.claude.com/docs/ja/claude-platform-on-aws.md)、Google Cloud の Agent Platform、Microsoft Foundry、または Anthropic API）に対して変換し、それらの間でフェイルオーバーします。開発者が気付いたり再設定したりすることなく、リージョン、プロバイダー、またはフェイルオーバー順序を変更できます。

![Claude Code クライアントと Claude Desktop がベアラートークンを使用して HTTPS 経由でインフラストラクチャ内の自己ホスト型 Claude apps gateway に接続し、ゲートウェイが IdP に対してユーザーをサインインさせ、PostgreSQL に認証状態を保存し、テレメトリを OTLP コレクターにリレーし、Amazon Bedrock、Claude Platform on AWS、Google Cloud、Microsoft Foundry、または Anthropic API に推論を転送する図](https://mintcdn.com/claude-code/VbyXug8hBU9UK6oT/images/claude-gateway-architecture.svg?fit=max\&auto=format\&n=VbyXug8hBU9UK6oT\&q=85\&s=9e4f1190fc56718144190a3db61c63af)

> [!NOTE]
>
> ゲートウェイ独自のデータプレーンは、Anthropic API が設定されたアップストリームでない限り、Anthropic インフラストラクチャに何も送信しません。テレメトリ、監査ログ、管理設定、および開発者の IdP アイデンティティがどこに行くかを制御し、ゲートウェイはそれらのいずれも Anthropic に送信しません。残りのトラフィック CLI プロセスが送信できる方法と、それを閉じる方法については、[コンプライアンスポスチャ](https://code.claude.com/docs/ja/claude-apps-gateway-deploy.md#compliance-posture)を参照してください。

ゲートウェイを通じてどの Claude Code 機能が機能するか、およびサーバー自体が何をサポートするかについては、以下の[可用性と制限](#availability-and-limitations)を参照してください。コスト、バイパス、複数ゲートウェイの実行、サーバーレスプラットフォームなどの決定については、[デプロイメントガイド](https://code.claude.com/docs/ja/claude-apps-gateway-deploy.md#deployment)を参照してください。

### その他のゲートウェイ実装

既に要件を満たす LLM ゲートウェイまたは API ゲートウェイを実行している場合は、それを使い続けてください。[その他の LLM ゲートウェイ](https://code.claude.com/docs/ja/llm-gateway)は Claude Code をそれに対して設定することをカバーしています。

[ゲートウェイ互換性ガイド](https://code.claude.com/docs/ja/llm-gateway-protocol.md)は、Claude Code が任意のゲートウェイから期待するもの、つまり呼び出すエンドポイント、転送するヘッダーとボディフィールド、およびそれらが削除されたときに何が機能しなくなるかを文書化しています。実行中の Claude apps ゲートウェイは、`GET /protocol` で独自のプロトコルリファレンスを提供し、Claude Code クライアントに公開するエンドポイント（SSO サインイン、推論、管理設定配信、モデル検出、テレメトリ）を説明しています。デプロイされたゲートウェイ（例えば、以下の[クイックスタート](#quickstart)が生成するもの）から `curl https://claude-gateway.internal.example.com/protocol` で取得します。

プロトコルへの破壊的な変更は事前に発表されますが、無期限の後方互換性は保証されません。

> [!NOTE]
>
> ゲートウェイのサインイントークンは、サインインを承認した開発者を識別するものであり、それを使用するプログラムを識別するものではありません。Claude Code は独自のクライアント ID やシークレットを持たずにサインインするため、ゲートウェイにはどのプログラムがサインインしているかを検証する方法がありません。任意のクライアントが `User-Agent` やその他のリクエストフィールドを設定できるため、これらはルーティングやメトリクスに使用し、リクエストが Claude Code から送信されたことの証明としては使用しないでください。

## クイックスタート

このクイックスタートは最小限のパスを説明しています。IdP で OAuth クライアントを登録し、`gateway.yaml` を書き、Docker Compose で Postgres と一緒にゲートウェイを実行し、エンドツーエンドでサインインを確認します。Amazon Bedrock アップストリームを使用します。Claude Platform on AWS、Google Cloud の Agent Platform、Microsoft Foundry、および Anthropic API は、[設定リファレンス](https://code.claude.com/docs/ja/claude-apps-gateway-config.md#upstreams)に示されているように `upstreams` ブロックをスワップすることで同様にサポートされます。最後に、開発者が `/login` できるゲートウェイがあります。

> [!NOTE]
>
> **プライベートネットワークにデプロイします。** Claude Code は、アドレスがプライベートであるゲートウェイにのみ接続します。これはセキュリティガードです。信頼されたゲートウェイは開発者マシンでコマンドを実行する設定をプッシュできるためです。ゲートウェイを内部ロードバランサーまたは VPN の背後に配置し、プライベート IP にのみ解決するホスト名を付けます。内部ネットワークが組織が所有するパブリック IPv4 スペースから番号付けされている場合は、[所有するパブリックアドレススペースでゲートウェイを許可する](#allow-a-gateway-on-public-address-space-you-own)を参照してください。

### 前提条件

開始する前に、以下を用意してください。

| 必要なもの | 詳細 |
| - | - |
| Claude Code v2.1.195 以降 | `claude gateway` サブコマンドとゲートウェイサインインフローは v2.1.195 で提供されます。以前のパブリックビルドには含まれていません。ゲートウェイサーバーを実行するマシンと各開発者のマシンの両方が v2.1.195 以降である必要があります。`claude update` を実行して最新リリースを取得します。[Claude Platform on AWS アップストリーム](https://code.claude.com/docs/ja/claude-apps-gateway-config.md#claude-platform-on-aws)はゲートウェイサーバーで Claude Code v2.1.198 以降が必要です。 |
| OpenID Connect（OIDC）ID プロバイダー | Okta、Microsoft Entra ID、Google Workspace、Keycloak、Dex、または PingFederate などの OIDC 準拠の IdP。ゲートウェイは標準 OIDC ディスカバリーと認可コードフローを実行します。SAML と LDAP はサポートされていません。 |
| PostgreSQL 11 以降 | デバイスサインインフローとレート制限カウンターをサポートします。最小層を含むマネージド PostgreSQL サービスが利用できます。[サポートされているデータベース](https://code.claude.com/docs/ja/claude-apps-gateway-deploy.md#postgres)を参照してください。[支出制限](https://code.claude.com/docs/ja/claude-apps-gateway-spend-limits.md)を使用すると、バックアップする必要がある耐久的な支出、監査、およびアイデンティティテーブルも保持します。`?sslmode=require` 経由の TLS が推奨されます。PostgreSQL 11、12、13 には、ゲートウェイサーバーで Claude Code v2.1.290 以降が必要です。PostgreSQL プロジェクトはこれらのバージョンの保守を終了しているため、可能な場合は新しいバージョンを使用してください。 |
| モデルアップストリーム | Amazon Bedrock 認証情報、Claude Platform on AWS 認証情報、Google Cloud 認証情報、Microsoft Foundry リソース、または Anthropic API キー。複数のアップストリームがサポートされ、フェイルオーバーがあります。 |
| HTTPS | ゲートウェイは開発者ラップトップとサインインに使用されるブラウザから `https://` 経由で到達可能である必要があります。ゲートウェイは同じリスナーでデバイス検証ページを提供します。`listen.tls` 経由で TLS 証明書を提供するか、TLS 終了イングレスの背後で実行し、いずれの場合も `listen.public_url` を外部オリジンに設定します。`/login` では、Claude Code はゲートウェイホストがループバック（`localhost`、`127.0.0.1`、または `::1`）の場合にのみプレーン `http://` オリジンを受け入れます。 |
| プライベートネットワークアドレス | `/login` では、Claude Code はゲートウェイのホスト名または IP アドレスがプライベートアドレスのみに解決されることを要求します。プライベートアドレスとは、RFC 1918 およびリンクローカル範囲、CGNAT `100.64.0.0/10`、IPv6 ULA `fc00::/7`、ループバックです。[脅威モデル](https://code.claude.com/docs/ja/claude-apps-gateway-deploy.md#threat-model-summary)を参照してください。内部ネットワークが組織が所有するパブリック IPv4 スペースから番号付けされている場合は、[これらのブロックを宣言](#allow-a-gateway-on-public-address-space-you-own)して、`/login` がそこでゲートウェイを受け入れるようにします。 |
| Linux ランタイム | ゲートウェイサーバーはネイティブ Linux バイナリでのみ実行されます。macOS はローカル開発用に機能します。Windows はサーバープラットフォームとしてサポートされていません。 |

ゲートウェイホストに `HTTPS_PROXY` または `HTTP_PROXY` が適用される場合、サインインには、ホスト名がプライベートアドレスに解決されるプロキシか、開発者マシンの `NO_PROXY` にゲートウェイホストが含まれていることも必要です。これらのマシンで `no_proxy` も設定している場合は、そこにもゲートウェイホストを追加してください。追加しないと、モデルリクエストは引き続きプロキシを経由します。

### ステップ

**1. IdP で OAuth クライアントを登録する**

リダイレクト URI がそれと一致する必要があるため、まずゲートウェイのホスト名を決定します。新しい OIDC ウェブアプリケーションを作成し、リダイレクト URI を `https://claude-gateway.<your-domain>/oauth/callback` に設定します。ホストはステップ 3 で [`listen.public_url`](https://code.claude.com/docs/ja/claude-apps-gateway-config#listen) として設定する値と同じです。`client_id` と `client_secret` をメモします。IdP ごとの手順は[ID プロバイダーセットアップ](https://code.claude.com/docs/ja/claude-apps-gateway-deploy.md#identity-provider-setup)にあります。

**2. PostgreSQL データベースをプロビジョニングする**

PostgreSQL 11 以降を使用します。最小のマネージド層で十分です。ゲートウェイは起動時に独自のスキーママイグレーションを実行するため、データベースロールはテーブルを作成および変更する権限が必要です。[`store`](https://code.claude.com/docs/ja/claude-apps-gateway-config#store)を参照してください。

**3. gateway.yaml を書く**

シークレットは `${ENV_VAR}` 展開経由で読み取られるため、ファイル自体はバージョン管理に存在できます。`/login` がパブリックアドレスを拒否するため、プライベート IP に解決する `public_url` ホスト名を使用します。最小設定には 5 つのセクションがあり、他のすべてのフィールドにはデフォルトがあります。

```yaml gateway.yaml theme={null}
listen:
  host: 0.0.0.0
  port: 8080
  # ホストがループバックアドレスでない限り必須。IdP
  # redirect_uri とディスカバリードキュメントに使用されます。
  public_url: https://claude-gateway.internal.example.com

oidc:
  issuer: https://login.example.com        # /.well-known/openid-configuration を提供する必要があります
  client_id: 0oa1example2
  client_secret: ${OIDC_CLIENT_SECRET}
  allowed_email_domains: [example.com]        # 組織外の id_tokens を拒否します
  userinfo_fallback: true                  # id_token が email/groups を省略する IdP の場合。それ以外の場合は無害です

session:
  jwt_secret: ${GATEWAY_JWT_SECRET}        # openssl rand -base64 32
  ttl_hours: 1                             # IdP プロビジョニング解除時の失効レイテンシもバウンドします

store:
  postgres_url: ${GATEWAY_POSTGRES_URL}    # 管理 Postgres の場合は ?sslmode=require を追加します

upstreams:
  - provider: bedrock
    region: us-east-1
    auth: {} # 空：AWS デフォルト認証情報チェーン
# （IRSA、EC2/ECS タスクロール、環境変数、~/.aws）

# モデルはアップストリームごとに自動的に変換されます。組み込みカタログ
# は claude-opus-4-8 を us.anthropic.claude-opus-4-8 にマップし、
# Bedrock がサポートするすべての Claude モデルに対して同様にマップします。false に設定し、
# `models:` リストを追加して、特定のモデルのみを公開します。
auto_include_builtin_models: true
```

この設定は、デフォルト Amazon Bedrock モデルカタログを使用した動作するサインインループに十分です。実行されたら、[`managed.policies`](https://code.claude.com/docs/ja/claude-apps-gateway-config#managed) 経由でグループごとの RBAC と管理設定を追加し、[`telemetry`](https://code.claude.com/docs/ja/claude-apps-gateway-config#telemetry) 経由でテレメトリファンアウトを追加し、[`models`](https://code.claude.com/docs/ja/claude-apps-gateway-config#models) 経由でマルチアップストリームフェイルオーバー、プロビジョニング済みスループット ARN、または非米国リージョンを追加します。

> [!NOTE]
>
> Amazon Bedrock アップストリームは、`inference-profile/us.anthropic.*` ARN と基礎となる `foundation-model/anthropic.*` ARN の両方に対して `bedrock:InvokeModel` と `bedrock:InvokeModelWithResponseStream` を持つ AWS プリンシパルが必要です。また、そのアカウントについて、Bedrock コンソールのモデルカタログから Anthropic の一度限りのユースケースフォームが提出されている必要もあります。
>
> 静的キーではなく、EKS の IRSA、ECS タスクロール、または EC2 インスタンスプロファイルを使用して認証情報を提供します。[`upstreams` リファレンス](https://code.claude.com/docs/ja/claude-apps-gateway-config#upstreams)には、完全な IAM 詳細、クロスクラウド認証情報マトリックス、および他のプロバイダーの `auth` ブロックがあります。

**4. 実行する**

[イメージ要件](https://code.claude.com/docs/ja/claude-apps-gateway-deploy.md#container-image)を満たす `claude` バイナリの周りにコンテナイメージをビルドし、Postgres と一緒に実行します。Compose ファイルはイメージを `registry.example.com/claude-gateway:2.1.198` として参照します。独自のレジストリとイメージタグに置き換えます。

```yaml docker-compose.yaml theme={null}
services:
  gateway:
    image: registry.example.com/claude-gateway:2.1.198
    ports: ["8080:8080"]
    volumes: ["./gateway.yaml:/etc/claude/gateway.yaml:ro"]
    environment:
      OIDC_CLIENT_SECRET: ${OIDC_CLIENT_SECRET}
      GATEWAY_JWT_SECRET: ${GATEWAY_JWT_SECRET}
      GATEWAY_POSTGRES_URL: postgres://gw:pw@postgres/gateway
      # AWS 認証情報：本番環境では、これらを省略し、インスタンス
      # ロールを使用します。ローカル Compose テストの場合、独自のものを渡します。
      AWS_ACCESS_KEY_ID: ${AWS_ACCESS_KEY_ID}
      AWS_SECRET_ACCESS_KEY: ${AWS_SECRET_ACCESS_KEY}
      AWS_SESSION_TOKEN: ${AWS_SESSION_TOKEN}
    depends_on:
      postgres:
        condition: service_healthy
  postgres:
    image: postgres:16-alpine
    environment: { POSTGRES_USER: gw, POSTGRES_PASSWORD: pw, POSTGRES_DB: gateway }
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U gw"]
      interval: 5s
    volumes: ["pgdata:/var/lib/postgresql/data"]
volumes: { pgdata: }
```

ゲートウェイは、設定を読み取り、Postgres に接続してスキーママイグレーションを適用し、IdP に対して OIDC ディスカバリーを実行し、アップストリームクライアントを構築し、リッスンを開始する単一の Linux バイナリです。

起動は設定、Postgres 接続、OIDC ディスカバリー、およびアップストリームクライアント構築に対して失敗時に閉じられます。これらのいずれかが到達不可能または設定が誤っている場合、ゲートウェイは低下した状態でトラフィックを提供するのではなく、エラーで終了します。

成功した起動は推論パスを検証しません。Amazon Bedrock と Google Cloud の Agent Platform インスタンス認証情報は起動時ではなく最初のリクエストで解決されるためです。

起動シーケンスについて stderr を監視します。デフォルトでは、ログ行は `[gateway] <timestamp> <level> <message>` 形式を使用し、以下では省略されている起動バナーがマイグレーション行とリッスン行の間に出力されます。監査イベントは `evt` フィールド付きの単一行 JSON です。新しいデータベースはスキーママイグレーションごとに 1 行の `migration N applied` を出力します。既にマイグレーションされたデータベースは出力しません。順番に以下が表示されます。

```text theme={null}
{"ts":"2026-06-10T17:03:21.114Z","evt":"config.load","path":"/etc/claude/gateway.yaml","sha256":"…"}
[gateway] 2026-06-10T17:03:21.395Z info waiting for migration lock (another replica may be migrating; check pg_locks for key 6775156 if this persists)
[gateway] 2026-06-10T17:03:21.408Z info migration 1 applied
…
[gateway] 2026-06-10T17:03:21.431Z info migration 6 applied
[gateway] 2026-06-10T17:03:21.512Z info claude gateway listening on http://0.0.0.0:8080
```

ゲートウェイは、`access_control.allow_cidrs` が空であることを示す警告もログに記録します。これはここでは想定どおりです。許可リストを設定するまで、ゲートウェイがサーブするクライアントアドレスを制限するものがないためです。[`access_control` リファレンス](https://code.claude.com/docs/ja/claude-apps-gateway-config#http-tuning)には推奨範囲があります。

起動が `claude gateway listening on` 行の前に終了する場合、stderr の最後の行は問題を名前付けます。

* 到達不可能な Postgres
* DDL 権限のない Postgres ロール
* 到達不可能または無効な OIDC ディスカバリードキュメント
* 違反フィールドパスを含む設定スキーマ違反

修正して再起動します。

既に TLS 終了イングレスがある場合は、Compose をスキップし、`claude gateway --config gateway.yaml` でバイナリを直接実行します。`public_url` をイングレスオリジンに設定し、`listen` をループバックまたはクラスター内アドレスにバインドします。

**5. 認証サーフェスを確認する**

3 つのチェックは、ゲートウェイが開発者に渡す前に実際のユーザーを認証できることを確認します。

例はゲートウェイのパブリック URL を使用します。イングレスのないローカル Compose セットアップの場合、最初の 2 つのチェックで `http://localhost:8080` に置き換えます。3 番目のチェックは `verification_uri_complete` を開きます。これは `public_url` から構築されるため、ローカル Compose の場合は `gateway.yaml` で `public_url: http://localhost:8080` を設定し、ゲートウェイが `public_url` から IdP `redirect_uri` を構築するため、ステップ 1 の OAuth クライアントに 2 番目のリダイレクト URI として `http://localhost:8080/oauth/callback` を追加します。検証リンクはローカルブラウザで開きます。

Windows PowerShell では、`curl.exe` を実行します。ベア `curl` は `Invoke-WebRequest` のエイリアスであり、これらのフラグを拒否します。

まず、ディスカバリードキュメントを取得します。これはゲートウェイが起動し、設定が有効であり、すべての起動チェックが合格したことを確認します。

```bash theme={null}
curl -s https://claude-gateway.internal.example.com/.well-known/oauth-authorization-server | jq
```

```json theme={null}
{
  "issuer": "https://claude-gateway.internal.example.com",
  "device_authorization_endpoint": "…/oauth/device_authorization",
  "token_endpoint": "…/oauth/token",
  "grant_types_supported": ["urn:ietf:params:oauth:grant-type:device_code", "refresh_token"]
}
```

レスポンスには `response_types_supported` や `scopes_supported` などの追加フィールドが含まれます。

次に、デバイス認可をリクエストします。これはデバイスサインインフローが機能し、Postgres が到達可能で書き込み可能であることを確認します。

```bash theme={null}
curl -s -X POST https://claude-gateway.internal.example.com/oauth/device_authorization | jq
```

```json theme={null}
{
  "device_code": "…",
  "user_code": "WDJB-MJHT",
  "verification_uri": "https://claude-gateway.internal.example.com/device",
  "verification_uri_complete": "https://claude-gateway.internal.example.com/device?user_code=WDJB-MJHT",
  "expires_in": 600,
  "interval": 5
}
```

3 番目に、ブラウザで `verification_uri_complete` を開いてコードを確認することでブラウザレッグをテストします。IdP のサインインページにリダイレクトされ、サインイン後、ゲートウェイに戻ってサインイン確認に着地する必要があります。

最初に失敗したチェックを使用して問題を特定します。

* **最初のチェックが失敗**：起動が完了しませんでした。stderr を確認してください
* **2 番目のチェックが失敗**：Postgres がゲートウェイから到達不可能であるか、ロールが書き込みできません。接続文字列と権限を確認してください
* **3 番目のチェックが IdP に到達しない**：IdP のリダイレクト URI が `https://<gateway>/oauth/callback` と正確に一致することを確認してください
* **3 番目のチェックが IdP に到達しますが、エラーで戻ります**：ゲートウェイの監査ログを読みます。これは `email domain not allowed` などの理由を含むすべての認証拒否を記録します

**6. 開発者をログインさせる**

この最後のステップはサーバーではなく開発者マシンで発生します。そのマシンの[管理設定ファイル](https://code.claude.com/docs/ja/managed-settings.md#delivery-mechanisms)で `forceLoginMethod` を `"gateway"` に、`forceLoginGatewayUrl` をゲートウェイの `public_url` に、`parentSettingsBehavior` を `"merge"` に設定し、`/login` を実行し、**Cloud gateway** 画面で Enter キーを押し、ブラウザサインインを完了します。以下の[ゲートウェイ URL を設定](#set-the-gateway-url)では、3 つのキーと、それらをすべての開発者マシンに配布する方法を説明しています。

## 開発者を接続する

開発者は、自分のノートパソコンから企業の業務アカウントを使い、ブラウザで 1 回サインインするだけで接続できます。モデルへのリクエストは組織のアップストリーム認証情報を使ってゲートウェイ経由で送られるため、claude.ai アカウント、API キー、サブスクリプションは必要ありません。接続は MDM で配布する[クライアント側の管理設定](https://code.claude.com/docs/ja/claude-apps-gateway-config.md#client-side-managed-settings)によって制御されます。このセクションでは、管理者が設定する内容を説明します。

CLI は初回接続時にゲートウェイの TLS リーフ証明書のフィンガープリントを取得し、ホスト名ごとにピン留めします。サインイン時、サイレントなセッション更新時、管理設定の取得時にはそのピンを再度チェックしますが、推論リクエストではピンを使わずに標準の TLS 検証を行います。HTTPS プロキシ経由でルーティングされるリクエストではピンのチェックがスキップされるため、ゲートウェイのホストを `NO_PROXY` に追加して直接接続を維持してください。

開発者が照合できるように、想定される SHA-256 フィンガープリントをゲートウェイの URL と一緒に公開してください。`/login` のプロンプトには、フィンガープリントの先頭 16 文字がコロンなしの小文字 16 進数で表示されます。証明書ファイルから同じ形式で完全なフィンガープリントを出力するには、次のコマンドを実行します。

```bash theme={null}
openssl x509 -noout -fingerprint -sha256 -in cert.pem | cut -d= -f2 | tr -d : | tr 'A-F' 'a-f'
```

証明書がローテーションされると、すべての開発者に信頼プロンプトが再び表示されます。そのため、ローテーションは計画的なイベントとして扱い、フィンガープリントを再公開してください。ゲートウェイのポリシーに[承認が必要な設定](https://code.claude.com/docs/ja/server-managed-settings.md#security-approval-dialogs)が含まれている場合、開発者が新しい証明書を受け入れた後、その承認ダイアログも再び表示されます。これは、Claude Code が[承認の記憶](https://code.claude.com/docs/ja/server-managed-settings.md#approval-memory)をピン留めされた証明書に紐付けているためです。

ゲートウェイは、サインインに使われたアカウントを示すために、トークンレスポンスで省略可能な `email` フィールドを返すことができます。このフィールドが返された場合、開発者はアカウントを確認してから Claude Code が認証情報を保存します。確認済みのサインインの後は、`/status` にそのアカウントが表示されます。

この確認には、開発者のマシンに Claude Code v2.1.275 以降が必要です。それより前のバージョンのクライアントは、このフィールドを無視します。`claude` バイナリに含まれるゲートウェイサーバーはこのフィールドを返さないため、そのサーバーへのサインインは確認なしで完了します。

開発者がサインインすると、[モデルピッカー](https://code.claude.com/docs/ja/model-config.md)には `availableModels` 許可リストにあるモデルが表示されます。管理設定は起動時に適用されて 1 時間ごとに更新され、テレメトリは組織のコレクターに送られます。

セッションは `ttl_hours` の期限が切れる前にサイレントに更新されます。IdP でのプロビジョニング解除後に更新が失敗すると、Claude Code は開発者に再ログインを求めます。

### ゲートウェイの URL を設定する

MDM で、またはディスクに直接配置する OS ごとの[管理設定ファイル](https://code.claude.com/docs/ja/managed-settings.md#delivery-mechanisms)に 3 つのキーを記述します。管理設定のないマシンについては、代わりに[ユーザー設定でゲートウェイの URL を設定する](#set-the-gateway-url-in-user-settings)を参照してください。`forceLoginMethod` と `forceLoginGatewayUrl` を設定すると、`/login` が URL の入力済みの **Cloud gateway** 画面で直接開きます。また、`parentSettingsBehavior: "merge"` を設定すると、Claude Desktop が起動する Claude Code セッションにゲートウェイの送信先許可リストを配信できるようになります。これについては [Claude Desktop セッションにポリシーを配信する](#deliver-policy-to-claude-desktop-sessions)で説明します。

```json theme={null}
{
  "forceLoginMethod": "gateway",
  "forceLoginGatewayUrl": "https://claude-gateway.internal.example.com",
  "parentSettingsBehavior": "merge"
}
```

開発者は Enter を押して接続します。[初回接続時の TLS フィンガープリントのプロンプト](#connect-developers)は引き続き表示されます。このファイルがマシンに配置されると、ゲートウェイへのサインインを完了していない開発者には、[Administrator policy requires a Cloud gateway sign-in](https://code.claude.com/docs/ja/errors.md#administrator-policy-requires-a-cloud-gateway-sign-in) で説明されているメッセージのいずれかが表示されます。`CLAUDE_CODE_USE_BEDROCK` などの環境変数でクラウドプロバイダーを選択している開発者は、ゲートウェイへのサインインを必要としません。

ログインピッカーにはゲートウェイの選択肢がありません。また、管理設定で URL なしに `forceLoginMethod` だけを設定すると、開発者には「Contact your IT administrator」というメッセージが表示されたままになります。ログイン用のキーは、マシンに配布するファイルに記述してください。ゲートウェイの `managed.policies[].cli` ブロックはすでに接続済みのクライアントにしか届かないため、そこには記述しないでください。

#### ユーザー設定でゲートウェイの URL を設定する

管理設定のないマシンでは、各開発者に自分のユーザー設定ファイル `~/.claude/settings.json` へ `forceLoginMethod` と `forceLoginGatewayUrl` を追加してもらいます。これには、開発者のマシンに Claude Code v2.1.295 以降が必要です。次の例では、`claude-gateway.internal.example.com` にあるゲートウェイを指定しています。

```json theme={null}
{
  "forceLoginMethod": "gateway",
  "forceLoginGatewayUrl": "https://claude-gateway.internal.example.com"
}
```

開発者が Claude Code のプロンプトで `/login` を実行すると、そのアドレスが入力された **Cloud gateway** 画面が開くので、Enter を押して接続します。[初回接続時の TLS フィンガープリントのプロンプト](#connect-developers)は引き続き表示されます。この方法で設定したキーには、次の制限があります。

* **ユーザー設定のみ**: Claude Code はこの 2 つのキーを `~/.claude/settings.json` から読み取ります。プロジェクトの `.claude/settings.json` や `.claude/settings.local.json` からは読み取りません。
* **管理設定があると無効になる**: 管理者の設定が管理設定ファイル、macOS の plist や Windows の HKLM ポリシー、または[ポリシーヘルパー](https://code.claude.com/docs/ja/settings-reference.md#policyhelper)を通じてマシンに届くと、Claude Code はユーザー設定で指定されたゲートウェイを無視します。

### 自組織が所有するパブリックアドレス空間上のゲートウェイを許可する

組織によっては、通信事業者自身のアドレス空間や従来の `/8` など、自組織が所有するパブリック IPv4 ブロックから内部ネットワークのアドレスを割り当てているため、ゲートウェイにプライベートアドレスがない場合があります。そのようなブロックは `gatewayInternalNetworks` 管理設定に列挙してください。これにより、開発者のマシンが列挙されたブロック内のアドレスから同じブロック内のゲートウェイに接続する場合、`/login` はそのゲートウェイを受け入れます。これには、開発者のマシンに Claude Code v2.1.268 以降が必要です。それより前のバージョンはこのキーを無視し、プライベートアドレスのルールを適用します。

> [!WARNING]
>
> `gatewayInternalNetworks` は、たまたまパブリックアドレス空間からアドレスが割り当てられている内部ネットワーク向けのものです。ゲートウェイをインターネットに公開しても安全になるわけではありません。信頼されたゲートウェイは、開発者のマシン上でコマンドを実行する設定を配信できるためです。
>
> ファイアウォールやロードバランサーのルールで、ネットワーク外部からゲートウェイに到達できないようにしてください。ゲートウェイの [`access_control.allow_cidrs`](https://code.claude.com/docs/ja/claude-apps-gateway-config#http-tuning) には、ここで宣言するものと同じブロックを設定してください。ロードバランサーやイングレスを [`listen.trusted_proxies` に含めるべき](https://code.claude.com/docs/ja/claude-apps-gateway-config#listen)場合は、そこにも列挙してください。そうしないと、ゲートウェイは開発者のアドレスではなくフロントエンド自体のアドレスを `allow_cidrs` と照合します。

このキーは、ログイン用のキーと同じ管理設定ソース（管理設定ファイル、MDM プロファイル、またはレジストリポリシー）に追加してください。ユーザー設定、プロジェクト設定、サーバー管理設定にある場合、Claude Code はこのキーを無視します。

次の例では 1 つのブロックを宣言しています。`203.0.113.0/24` は自組織のブロックに置き換えてください。これはドキュメント用の範囲であり、Claude Code は受け入れません。

```json theme={null}
{
  "gatewayInternalNetworks": ["203.0.113.0/24"]
}
```

Claude Code は、`/login` 時にゲートウェイに接続する前にこのリストを検証します。

* 各エントリは、先頭アドレスと `/8` から `/32` までのプレフィックスで記述した IPv4 ブロックでなければなりません。
* リストに含められるブロックは最大 4 つで、どの 2 つのブロックも互いに重複してはなりません。
* どのブロックもプライベートアドレス空間（`10.0.0.0/8`、`172.16.0.0/12`、`192.168.0.0/16`、`127.0.0.0/8`、`169.254.0.0/16`、`100.64.0.0/10`）と重複してはなりません。これらの範囲にあるゲートウェイは、このキーがなくても `/login` が受け入れます。
* どのブロックも、組織のネットワークになることがない空間と重複してはなりません。これには、VPN や NAT64 クライアントがローカルアドレスとして保持する `198.18.0.0/15` と `192.0.0.0/24`、ドキュメント用の範囲 `192.0.2.0/24`、`198.51.100.0/24`、`203.0.113.0/24`、予約済みの範囲 `0.0.0.0/8`、`192.88.99.0/24`、マルチキャストの `224.0.0.0/4` が含まれます。`240.0.0.0/4` 内のブロックは宣言できます。一部の大規模ネットワークでは、この範囲を内部のユニキャスト空間として使用しています。

`managed-settings.json` とその `managed-settings.d/` ドロップインファイルのブロックは 1 つのリストに結合され、これらの制限は結合後のリストに適用されます。ブロックを絞り込むには、ドロップインで重複する 2 つ目のエントリを追加するのではなく、既存のエントリを置き換えてください。重複があると `/login` は拒否します。

エントリがいずれかのルールに違反している場合、または値が文字列のリストでない場合、Claude Code はそのマシン上での新しいゲートウェイへのサインインをすべて拒否し、メッセージで問題を示します。プライベートアドレス上のゲートウェイへのサインインも失敗しますが、既存のサインインは引き続き機能します。デプロイする前に、1 台のマシンで値を試してください。また、Claude Code は型が誤っている値を、[報告する無効な管理設定](https://code.claude.com/docs/ja/managed-settings.md#keys-that-fail-closed)の一覧に含めます。

リストが有効な場合、`/login` はアドレスが列挙されたブロック内にあるゲートウェイに対して 3 つのチェックを行います。

* ゲートウェイのホスト名が解決されるすべてのアドレスが、その 1 つのブロック内にあること。ブロック外のレコード（プライベートアドレスや IPv6 アドレスを含む）も持つ名前は、Claude Code が拒否します。
* 開発者のマシンが同じブロック内から接続していること。NAT の背後にあるマシン、コンテナや WSL2 内のマシン、アドレスプールがブロック外にある VPN 上のマシンは、Claude Code が拒否し、マシンの接続元アドレスを示します。
* 接続が直接であること。`HTTPS_PROXY` がゲートウェイのホストに適用される場合、`/login` は拒否し、追加すべき `NO_PROXY` のエントリを示します。

3 つのチェックすべてに合格すると、[信頼プロンプト](#connect-developers)に、マシンのアドレス、ゲートウェイのアドレス、その両方を含む宣言済みブロックを示す行が追加されます。

このキーは他のゲートウェイには何の影響も与えません。プライベートアドレス上のゲートウェイへのサインインはこれまでどおり機能し、列挙されたどのブロックにも含まれないパブリックアドレス上のゲートウェイへのサインインはこれまでどおり拒否されます。

宣言したブロックはサインインできる対象を絞り込みますが、マシンの所在を証明するものではありません。そのため、組織が管理しているアドレス空間だけを宣言してください。クラウドプロバイダーのパブリック範囲など、他のテナントと共有しているブロックを宣言すると、そのブロック内の誰もが同じチェックに合格してしまいます。

### Claude Desktop セッションにポリシーを配信する

Claude Desktop は埋め込みの Claude Code セッション上で各タブを実行し、それらのモデルリクエストをゲートウェイ経由で送信します。Claude Desktop は、ゲートウェイが `/user/bootstrap` で提供する設定をもとにポリシーを構築し、それらの各セッションに渡します。この設定には、一致したポリシーの `cli` または `code` ブロックから導出されたモデル許可リスト、無効化されたツール、送信先許可リストに加えて、[`desktop` オーバーレイ](https://code.claude.com/docs/ja/claude-apps-gateway-config#claude-desktop-overlay)が含まれます。

ブロックのその他のキー（フック、`env`、`Bash(npm *)` のようなスコープ付き権限ルールなど）は、`/login` でサインインするクライアントに届きます。`code` の下にある場合は、[Code タブの条件](https://code.claude.com/docs/ja/claude-apps-gateway-config.md#apply-code-settings-in-the-code-tab)を満たすときに Code タブのセッションにも届きます。Cowork や Chat のセッションには届きません。Claude Desktop はゲートウェイの URL を自身の管理設定から読み取り、[ゲートウェイの URL を設定する](#set-the-gateway-url)の `forceLoginMethod` キーや `forceLoginGatewayUrl` キーとは別の、独自のフローでサインインします。

起動元のプロセスから渡される設定を親設定と呼びます。管理者がデプロイした管理ソースがあるマシンでは、[ポリシーを配信するソース](https://code.claude.com/docs/ja/managed-settings.md#which-managed-source-claude-code-uses)が `parentSettingsBehavior: "merge"` を設定している場合を除き、Claude Code は親設定を無視します。

#### オプトインが必要なマシン

Claude Desktop だけを実行するマシンでは、オプトインが必要です。Claude Desktop はモデルリストと無効化ツールのリストを埋め込みセッションに自ら適用しますが、送信先許可リストは `WebFetch` のドメインルールとサンドボックスのネットワークルールという形で、親設定としてのみセッションに届きます。オプトインがないと、それらのセッションは送信先の制限なしで実行され、何の警告も表示されません。ただし、ポリシーで許可されていないモデルへの推論リクエストは、引き続きゲートウェイが拒否します。

プラグインマーケットプレイスの許可リストも、親設定としてのみ埋め込みセッションに届きます。Claude Desktop の管理設定でユーザーが追加したプラグインマーケットプレイスをオフにすると、Claude Desktop 2.16120.0 以降は、組織がプロビジョニングしていないマーケットプレイスを非表示にし、そこからのインストールを拒否します。それらのマーケットプレイスからすでにインストールされているプラグインを埋め込みセッションが読み込まないようにするため、Claude Desktop は `strictKnownMarketplaces` リストを親設定としてセッションに送信します。オプトインがないと、Claude Code はそのリストを無視し、それらのプラグインは引き続き読み込まれます。

開発者が `/login` でサインインするマシンでは、オプトインは必要ありません。各 Claude Code セッションがポリシーをゲートウェイから取得するためです。

[`policyHelper`](https://code.claude.com/docs/ja/settings-reference#policyhelper) が管理設定を提供するフリートでは、オプトインを使用できません。そのようなフリートでは、Claude Code は管理設定をヘルパーの出力だけから読み取るため、親設定を一切マージしません。

#### オプトインを設定する

[ゲートウェイの URL を設定する](#set-the-gateway-url)の管理設定スニペットをデプロイし、そのファイルより優先されるクライアント側のソースにも同じ内容を反映してから、検証します。

**1. 管理設定ファイルでオプトインをデプロイする**

[上記のスニペット](#set-the-gateway-url)にはすでに `parentSettingsBehavior: "merge"` が含まれているため、マシンに配布するファイルにもこの設定が含まれます。

**2. ファイルより優先されるソースにスニペットを反映する**

Claude Code は `parentSettingsBehavior` を[選択されたソース](https://code.claude.com/docs/ja/managed-settings.md#which-managed-source-claude-code-uses)からのみ読み取ります。ソースに何らかのポリシーキーを追加すると、そのソースが選択されたソースになる可能性があります。そのため、クライアント側のソースには `parentSettingsBehavior` だけでなくスニペット全体を反映してください。グループポリシーや構成プロファイルでポリシーを配信するフリートについては、[クライアント側の管理設定](https://code.claude.com/docs/ja/claude-apps-gateway-config.md#client-side-managed-settings)で説明しています。macOS の管理対象設定の plist や Windows の HKLM ポリシーは `managed-settings.json` ファイルより優先され、ゲートウェイ自体のリモート管理設定はその両方より優先されます。そのため、ゲートウェイにサインインするマシンについては、ゲートウェイのポリシーの [`cli` または `code` ブロック](https://code.claude.com/docs/ja/claude-apps-gateway-config#managed)にも `parentSettingsBehavior` を設定してください。

**3. 選択されているソースを確認する**

Claude Desktop だけを実行するマシンで Agent SDK の [`resolveSettings()`](https://code.claude.com/docs/ja/agent-sdk/typescript#resolvesettings) を呼び出し、その `sources` リストにある `managed` エントリの `policyOrigin` を確認します。この値は選択されたクライアント側のソース（`plist`、`hklm`、または `file`）を示しており、これがスニペットを含める必要のあるソースです。

Cowork と Chat のセッションはゲートウェイのポリシーを取得しないため、これらのセッションではゲートウェイのブロックは選択されたソースになりません。

Code タブのセッションは、ポリシーの設定が `code` の下にあり、[Code タブの条件](https://code.claude.com/docs/ja/claude-apps-gateway-config.md#apply-code-settings-in-the-code-tab)を満たす場合にゲートウェイのポリシーを取得します。その場合、ゲートウェイの `code` 設定がそのセッションの選択されたソースになります。

### 親設定を制限する

`parentSettingsBehavior: "merge"` をデプロイすると、Claude Code を起動するあらゆるホストプロセスが親設定を提供できるようになります。これには Claude Desktop だけでなく、Agent SDK アプリケーションや IDE 拡張機能も含まれます。

Claude Code は制限的なキーの許可リストに照らして親設定をフィルタリングしますが、許可されるキーの中には、制限ではなくアクセスを付与できるものもあります。`allowManaged*Only` ロックを設定しない限り、ホストが提供する権限の許可ルールやサンドボックスの許可リストは引き続き適用されます。いずれの場合も、ポリシーの拒否ルールと確認ルールは有効なままです。[これらはどの許可ルールよりも先に評価されます](https://code.claude.com/docs/ja/permissions.md#manage-permissions)。

Claude Code は、親が提供する [`sandbox.credentials`](https://code.claude.com/docs/ja/settings-reference#sandbox-credentials) エントリを、内容を削ぎ落とした形で転送します。

* **`deny` エントリ**: `path` または `name` とモードだけを含めて転送されます。
* **[`mode: mask`](https://code.claude.com/docs/ja/sandboxing#mask-credential-files) のファイルエントリ**: `injectHosts` が空のリストであるファイル全体のマスクとして、センチネルのみの形で転送されます。そのため、どのプラットフォームでも、親が提供したエントリに対してプロキシが実際の値を代入することはありません。構造化マスキングのフィールドもすべて削除されるため、親が提供した抽出パターンによって、別のソースが同じパスに設定したより厳格なマスクが置き換えられることはありません。
* **`mode: mask` の `envVars` エントリ**: 転送されません。親チャネルが `envVars` エントリで表現できる制限は `deny` だけです。
* **[`awsPairs` と `sigv4`](https://code.claude.com/docs/ja/sandboxing#re-sign-aws-requests)**: 制限のみの形で転送されます。`sigv4` からは `deny` の値だけが保持され、親が `sigv4` ブロックを定義している場合は、3 つのリクエスト形式 `streaming`、`presigned`、`sigv4a` すべてが `deny` に固定されます。`awsPairs` のペアが再署名可能な形で転送されることはありません。一般的な AWS 変数のいずれかを指定するペアは、`AWS_ACCESS_KEY_ID`、`AWS_SECRET_ACCESS_KEY`、`AWS_SESSION_TOKEN` の自動ペアリングを抑止したままにする無効なエントリに置き換えられます。

#### ロックをデプロイする

フィルターがサポートする範囲で親設定をできるだけ制限のみに近づけるには、5 つの `allowManaged*Only` ロックすべてと、それらが管理する許可リストを、マージのオプトインと同じソースに追加します。

```json theme={null}
{
  "forceLoginMethod": "gateway",
  "forceLoginGatewayUrl": "https://claude-gateway.internal.example.com",
  "parentSettingsBehavior": "merge",
  "allowManagedPermissionRulesOnly": true,
  "allowManagedMcpServersOnly": true,
  "allowManagedHooksOnly": true,
  "allowedMcpServers": [{ "serverUrl": "https://mcp.internal.example.com/*" }],
  "sandbox": {
    "network": {
      "allowManagedDomainsOnly": true,
      "allowedDomains": ["github.com", "*.npmjs.org"]
    },
    "filesystem": {
      "allowManagedReadPathsOnly": true,
      "denyRead": ["~/"],
      "allowRead": ["~/projects"]
    }
  }
}
```

HKLM のレジストリポリシーや管理対象設定の plist などの OS ポリシーはこのファイルより優先されるため、スニペット全体をファイルではなく OS ポリシーで配信してください。ゲートウェイのリモート管理設定は OS ポリシーやファイルのソースより優先されますが、接続済みのクライアントにしか届きません。ロック、許可リスト、マージのオプトインをポリシーの [`cli` または `code` ブロック](https://code.claude.com/docs/ja/claude-apps-gateway-config#managed)にも反映し、このファイルもデプロイしたままにしてください。一度も接続しないマシンは、ポリシーをこのファイルだけから取得するためです。

#### ソース間でのロックの動作

1 つのロックを設定しても、他のロックが制限されることはありません。各キーについては[設定リファレンス](https://code.claude.com/docs/ja/settings-reference.md#all-settings)を参照してください。

優先されるソースより下位にある管理ソースからでも、2 つのサンドボックスのロックは引き続き適用され、`allowManagedPermissionRulesOnly` は親が提供する許可ルールと `additionalDirectories` を引き続きブロックします。Claude Code v2.1.273 以降では、MCP サーバーのロックも優先されるソースより下位のソースから適用されます。このロックが有効な間、管理対象の `allowedMcpServers` リストは、リストを設定している管理ソースのうち最も優先度の高いものから取得されます。

フックのロックと、開発者自身のルールに対する `allowManagedPermissionRulesOnly` の効果は、デフォルトでは優先されるソースで設定されている必要があります。[Claude Code が管理ソースを組み合わせる方法](https://code.claude.com/docs/ja/managed-settings.md#how-claude-code-combines-managed-sources)で説明されている `managedSourcesBehavior` のマージのオプトインを使用すると、Claude Code はすべてのロックについて、いずれかのソースが設定している最も厳格な値を適用します。[`policyHelper`](https://code.claude.com/docs/ja/settings-reference#policyhelper) のフリートでは、Claude Code はロックをヘルパーの出力だけから読み取ります。

各ロックを設定すると、Claude Code はその設定に関する開発者自身のエントリを無視します。そのため、ロックと併せて組織の許可リストも含めてください。

* **ネットワークドメイン**: 管理対象のドメインリストが空のままロックすると、サンドボックス化されたすべての送信トラフィックがブロックされます。
* **MCP サーバー**: どの管理ソースにも親が提供する設定にも `allowedMcpServers` がないままロックすると、`deniedMcpServers` でブロックされていないすべてのサーバーが読み込まれます。
* **読み取りパス**: `allowRead` エントリは `denyRead` の範囲内にあるパスを再許可するだけなので、管理対象の `denyRead` と組み合わせてください。

#### ロックの対象外となる設定

次の親が提供する設定は、5 つのロックすべてを設定していてもフィルターを通過します。

* **`forceLoginOrgUUID`**: Claude Code は、適用する管理設定が組織 UUID を設定していない場合、親が提供する値に従います。ゲートウェイへのサインインではこのキーはチェックされません。Claude Code が適用する管理設定に組織 UUID があると、親の値はブロックされ、その組織 UUID が Claude Code によって強制されます。フリートで Anthropic の組織を固定している場合、`forceLoginOrgUUID` を設定する場所については[ログイン用のキーを提供する管理ソース](https://code.claude.com/docs/ja/managed-settings.md#which-managed-source-supplies-login-keys)を参照してください。
* **`allowedMcpServers`**: Claude Code は、有効な管理者のリストがない場合、親が提供する許可リストに従います。`allowManagedMcpServersOnly` はこれをブロックしません。このロックは、管理対象の値として優先されるリストを強制するものであり、どの管理ソースもリストを提供していない場合は、親が提供するリストもその対象になるためです。最も優先度の高い管理ソースにあるリストは親のリストをブロックし、Claude Code が強制するリストになります。そのため、`allowedMcpServers` はそのソースにロックと並べて設定してください。v2.1.223 より前は、いずれかの管理ソースにどちらかのキーの値があると、親の値がブロックされていました。
* **`availableModels`**: Claude Code は、優先される管理ソースがモデルリストを設定していない場合、親が提供するモデルリストに従います。フリートでモデルを制限している場合は、優先されるソースに `availableModels` を設定してください。
* **`allowedProviders`**: Claude Code は、優先される管理ソースが API プロバイダーの許可リストを設定していない場合、親が提供する許可リストに従います。フリートで開発者が使用できる API プロバイダーを制限している場合は、優先されるソースに `allowedProviders` を設定してください。Claude Code v2.1.285 以降が必要です。
* **`strictKnownMarketplaces`**: Claude Code は、優先される管理ソースがプラグインマーケットプレイスの許可リストを設定していない場合、親が提供する許可リストに従います。Claude Desktop 2.16120.0 以降は、管理設定でユーザーが追加したプラグインマーケットプレイスがオフになっている場合に、このリストを送信します。フリートでマーケットプレイスを制限している場合は、優先されるソースに `strictKnownMarketplaces` を設定してください。Claude Code v2.1.282 以降が必要です。
* **`blockedMarketplaces`**: 親が提供するマーケットプレイスのブロックリストはフィルターを通過し、管理ソースが設定しているブロックリストに追加されます。ブロックリストは制限をさらに強めることしかできないためです。Claude Code v2.1.282 以降が必要です。
* **`strictPluginOnlyCustomization`**: このキーはどのロックにも関係なくフィルターを通過し、Claude Code に、保護用のフックを含む開発者自身のカスタマイズを無視させます。これをブロックするロックはありません。

`managedSourcesBehavior` を `"merge"` に設定している場合は、[キーの種類ごとにどのソースの値が適用されるか](https://code.claude.com/docs/ja/managed-settings.md#compose-every-managed-source)を確認してください。

#### 親設定のフックとスキルのキーが有効になるしくみ

アプリケーションが Agent SDK の [`managedSettings`](https://code.claude.com/docs/ja/agent-sdk/typescript#options) オプションで渡すキーは親設定です。管理者が管理設定をデプロイしているマシンでは、管理者が[埋め込みホストによるポリシーの追加を許可している](https://code.claude.com/docs/ja/managed-settings.md#let-an-embedding-host-add-policy)場合を除き、Claude Code は親設定を無視します。

`managedSettings` で [`disableAllHooks: true`](https://code.claude.com/docs/ja/settings-reference#disableallhooks) を渡した場合:

* **停止するもの**: ユーザー、プロジェクト、ローカルのフックに加えて、エージェントのフロントマターまたは SDK の [`settings` オプション](https://code.claude.com/docs/ja/agent-sdk/typescript#options)で宣言されたフック。
* **引き続き実行されるもの**: アプリケーションの [SDK フックコールバック](https://code.claude.com/docs/ja/agent-sdk/hooks.md)と、管理設定にある管理者のフック。アプリケーションが管理者のフックをオフにすることはできません。

| 渡すもの | 結果 |
| :- | :- |
| `hooks`、またはエントリを含む `allowedHttpHookUrls` や `httpHookAllowedEnvVars` | Claude Code はそのキーを無視します。代わりに SDK の `settings` オプションを使用してください。 |
| `allowedHttpHookUrls: []` | 管理者が `hooks` を定義しているか、プラグインを有効にしている場合を除き、有効になります。他の設定ソースが列挙している URL を除き、HTTP フックは実行されません。 |
| `httpHookAllowedEnvVars: []` | 管理者が `hooks` を定義しているか、プラグインを有効にしている場合を除き、有効になります。HTTP フックのヘッダーには、他の設定ソースが列挙している環境変数だけを含めることができます。 |
| [`disableSkillShellExecution: true`](https://code.claude.com/docs/ja/settings-reference#disableskillshellexecution) | 有効になります。 |

これらのキーを `managedSettings` で渡すには、Claude Code v2.1.309 以降、または TypeScript Agent SDK v0.3.309 以降が必要です。

### Claude Desktop を接続する

[Claude Desktop](https://code.claude.com/docs/ja/desktop.md) は、別の MDM キーを通じて同じゲートウェイに接続します。Claude Desktop の[管理設定](https://claude.com/docs/third-party/claude-desktop/configuration)で `bootstrapUrl` を `<listen.public_url>/user/bootstrap` に設定し、`desktop` キーでユーザーのポリシーをオプトインさせます。この両方については [Claude Desktop オーバーレイ](https://code.claude.com/docs/ja/claude-apps-gateway-config.md#claude-desktop-overlay)で説明しています。ゲートウェイサーバーに Claude Code v2.1.203 以降が必要です。接続後、Claude Desktop は有効なすべてのタブからのモデルリクエストをゲートウェイ経由で送信します。

Claude Desktop は、同じブラウザ SSO の手順により、ゲートウェイの ID プロバイダーを通じて開発者をサインインさせ、その後 Anthropic ではなくゲートウェイから設定を取得します。モデルへのアクセスとポリシーには、CLI と同じグループごとのルールが適用されます。CLI と Claude Desktop の両方を使用する開発者は、それぞれに個別にサインインします。ゲートウェイのセッションは両者の間で共有されません。

### CI パイプラインとリモートマシン

無人のパイプライン向けのサービストークンフローはありません。ゲートウェイへのサインインでは常にブラウザのデバイスフローが実行されるため、サインインを承認する開発者がいない CI ジョブは認証できません。そのようなジョブはプロバイダーに対して直接設定してください。`forceLoginMethod` と `forceLoginGatewayUrl` は開発者のマシンにデプロイし、CI ランナーには設定しないでください。管理設定でこれらが設定されているマシンでは、`ANTHROPIC_API_KEY`、`ANTHROPIC_AUTH_TOKEN`、または `apiKeyHelper` で認証するセッションは[起動時に終了します](https://code.claude.com/docs/ja/errors.md#administrator-policy-requires-a-cloud-gateway-sign-in)。

開発者がサインインすると、そのマシン上の各 Claude Code セッションは、非対話型の `claude -p` の実行や Agent SDK で開始されたセッションを含め、ゲートウェイのセッションを使用します。Claude Code は、それらの各セッションに[ゲートウェイのポリシー](https://code.claude.com/docs/ja/claude-apps-gateway-config.md#managed)を適用します。

デバイスフローではポーリングする CLI と承認するブラウザが分離されているため、ディスプレイのないリモート開発マシンでも機能します。開発者はリモートマシン上で SSH 経由で `/login` を実行し、ノートパソコンのブラウザで検証リンクを開きます。

### 開発者に適用される制御

これらの保証は、`/login` でサインインしたすべてのセッションに適用されます。Claude Desktop が起動する埋め込みセッションは、[Claude Desktop セッションにポリシーを配信する](#deliver-policy-to-claude-desktop-sessions)で説明されているとおりにポリシーを取得します。それらのエクスポートの送信先については、テレメトリの項目で説明しています。

* **モデルへのアクセス**: ポリシーで許可されていないモデルへのリクエストは 400 を返し、`/model` ピッカーはポリシーの `availableModels` 許可リストに絞り込まれます。これには、開発者がモデルを選ぶ前にセッションが開始時に使用するモデルも含まれます。[ポリシーで許可されたモデルでセッションを開始する](https://code.claude.com/docs/ja/claude-apps-gateway-config.md#start-sessions-on-a-model-the-policy-allows)を参照してください。
* **テレメトリの送信先**: `/login` でサインインしたセッションでは、ポリシーで[コレクターをエンドポイントとして指定している](https://code.claude.com/docs/ja/claude-apps-gateway-config.md#export-directly-to-your-collector)場合を除き、CLI は OTLP/HTTP のエクスポートを、ローカルで設定された `OTEL_EXPORTER_OTLP_ENDPOINT` ではなくゲートウェイに送信します。ゲートウェイは受信したエクスポートを [`telemetry.forward_to`](https://code.claude.com/docs/ja/claude-apps-gateway-config#telemetry) の送信先に中継します。
  * [Claude Desktop が起動する](#connect-claude-desktop)埋め込みセッションでは、CLI はエクスポートを設定済みの `OTEL_EXPORTER_OTLP_ENDPOINT` に送信します。CLI がそれらのエクスポートにゲートウェイのセッショントークンを付加するのは、そのエンドポイントがゲートウェイ自体を指している場合だけです。
  * あるシグナルに送信先が設定されていない場合、ゲートウェイはそのシグナルを受け入れて破棄します。
  * すでに Claude Code のテレメトリを直接収集している場合は、コレクターを `forward_to` の送信先として追加するか、ポリシーでコレクターを指定して中継を省略してください。
* **認証情報**: ゲートウェイのトークンがセッションの唯一の認証情報です。サインイン中は [Anthropic プロファイル](https://code.claude.com/docs/ja/authentication.md#anthropic-profiles-and-federation-credentials)や以前の claude.ai ログインは無視されるため、開発者が先に claude.ai からログアウトする必要はありません。設定済みの `ANTHROPIC_API_KEY`、`ANTHROPIC_AUTH_TOKEN`、`apiKeyHelper` の認証情報、または以前の Claude Console ログインで保存された API キーについては、[Administrator policy requires a Cloud gateway sign-in](https://code.claude.com/docs/ja/errors.md#administrator-policy-requires-a-cloud-gateway-sign-in) を参照してください。
* **管理設定**: ロックされたキーはローカルで上書きできません。CLI は起動時にポリシーを適用し、[次回の起動時にのみ適用される変更](https://code.claude.com/docs/ja/server-managed-settings.md#fetch-and-caching-behavior)を除き、1 時間ごとのポーリングで変更を適用します。
* **ゲートウェイに到達できない場合の起動**: サインイン済みのセッションは、設定なしで起動するのではなく、約 10 秒後にエラーとともに起動時に終了します。
* **ゲートウェイがセッションを終了した後の起動**: ゲートウェイからサインアウトした状態で開く起動と、ゲートウェイが `401` を返したときに終了する起動については、[フェイルクローズの起動を強制する](https://code.claude.com/docs/ja/server-managed-settings.md#enforce-fail-closed-startup)を参照してください。
* **プロビジョニング解除**: IdP でユーザーが無効化されたセッションは、次回の更新が失敗した時点で、`ttl_hours` 以内に期限切れになります。
* **サインアウト**: `/logout` は開発者のマシンからゲートウェイの認証情報を削除します。
  * ゲートウェイのディスカバリードキュメントが、ゲートウェイ URL 自体と同じスキーム、ホスト、ポート上の `revocation_endpoint` を公開している場合、`/logout` はゲートウェイ側でセッションを終了できるよう、保存されているトークンもそのエンドポイントに送信します。このリクエストはベストエフォートであるため、エンドポイントが応答するかどうかにかかわらず、開発者のマシン上のサインアウトは完了します。この失効処理には、開発者のマシンに Claude Code v2.1.275 以降が必要です。
  * `claude` バイナリに含まれるゲートウェイサーバーは失効エンドポイントを公開しないため、そこからのサインアウトは開発者のマシン上のセッションだけを終了します。サーバー側でセッションを強制的に終了させるには、[JWT シークレットのローテーション](https://code.claude.com/docs/ja/claude-apps-gateway-deploy.md#jwt-secret-rotation)を参照してください。

### 組織が確認できる情報

使用状況のテレメトリは、開発者の ID、トークン数、モデル、レイテンシを組織のコレクターに送ります。ゲートウェイはプロンプトや応答の内容をログに記録したり保存したりしません。コマンドやファイルパスを含む可能性のあるログやトレースなど、より詳細なテレメトリを収集するかどうかは、組織が[送信先ごとに選択](https://code.claude.com/docs/ja/claude-apps-gateway-config.md#telemetry)します。

## 利用可能性と制限事項

この表は、開発者がゲートウェイ経由で接続した場合にどの Claude Code の機能が動作するか、およびゲートウェイサーバー自体が何をサポートしているかをまとめたものです。サポートされていない項目については、「注記」列に代替手段を記載しています。

ゲートウェイは、CLI が送信する [`anthropic-beta`](https://platform.claude.com/docs/en/api/beta-headers) の値をすべてのアップストリームに渡すため、運用者がベータの許可リストを管理する必要はありません。Amazon Bedrock はこのヘッダーを無視するため、Amazon Bedrock に対しては、ゲートウェイがこれらの値をリクエストボディの `anthropic_beta` フィールドに移します。その他のアップストリームは、送信されたとおりにヘッダーを受け取ります。

| 機能 | ステータス | 注記 |
| - | - | - |
| 推論の転送（Amazon Bedrock、Claude Platform on AWS、Google Cloud's Agent Platform、Microsoft Foundry、Anthropic） | 利用可能 | アップストリームごとのモデル変換とフェイルオーバーに対応しています。Amazon Bedrock アップストリームは `bedrock-runtime` エンドポイントと AWS のデフォルト認証情報チェーンを使用します。[Amazon Bedrock Mantle アップストリーム](https://code.claude.com/docs/ja/claude-apps-gateway-config.md#amazon-bedrock-mantle-endpoint)にはゲートウェイサーバー上で Claude Code v2.1.283 以降が、[Claude Platform on AWS アップストリーム](https://code.claude.com/docs/ja/claude-apps-gateway-config.md#claude-platform-on-aws)には v2.1.198 以降が必要です。 |
| 100 万トークンのコンテキストウィンドウ | 利用可能 | Fable モデル、Sonnet 5 以降、Opus 4.7 以降は、デフォルトで 100 万トークンのウィンドウで動作します。[拡張コンテキスト](https://code.claude.com/docs/ja/model-config.md#extended-context)を参照してください。Fable モデルと Opus モデルで 100 万トークンをデフォルトにするには、開発者のマシン上で Claude Code v2.1.287 以降が必要です |
| IdP グループごとのモデルアクセスと管理設定 | 利用可能 | モデルアクセスはサーバー側で適用されます。管理設定は IdP グループごとに配信され、CLI によって[管理設定の階層](https://code.claude.com/docs/ja/settings.md#settings-precedence)で適用されます |
| Claude Desktop | オプトインで利用可能 | [`desktop` キー](https://code.claude.com/docs/ja/claude-apps-gateway-config#claude-desktop-overlay)を使用してポリシーをオプトインします。ゲートウェイサーバー上で Claude Code v2.1.203 以降が必要です。 |
| テレメトリのファンアウト（OTLP/HTTP） | 利用可能 | エクスポートごとに ID が付与されます。protobuf と JSON の両方のエンコーディングに対応しています |
| OIDC ID プロバイダー | 利用可能 | OIDC に準拠した任意の IdP に対応しています。ゲートウェイは標準の OIDC ディスカバリーと認可コードフローを実行します。IdP ごとの設定については [ID プロバイダーのセットアップ](https://code.claude.com/docs/ja/claude-apps-gateway-deploy.md#identity-provider-setup)を参照してください |
| ユーザーごとおよびグループごとの支出上限 | 利用可能 | [支出上限](https://code.claude.com/docs/ja/claude-apps-gateway-spend-limits.md)を参照してください |
| サーバー側の Web 検索 | 利用不可 | CLI はゲートウェイがどのアップストリームプロバイダーにルーティングするかを把握できないため、Web 検索のサポートを確認できず、ゲートウェイセッションでは WebSearch を無効にします |
| [Remote Control](https://code.claude.com/docs/ja/remote-control.md) | 利用不可 | CLI は[ゲートウェイを示すエラー](https://code.claude.com/docs/ja/errors.md#remote-control-requires-the-anthropic-api)を表示します |
| [`/design-sync`](https://code.claude.com/docs/ja/commands#all-commands) と `/design-login` | 利用不可 | どちらも claude.ai を必要としますが、CLI はゲートウェイセッションでは claude.ai に接続しないため、どちらのコマンドも表示されません |
| `/import` や `claude import` など、フィーチャーフラグの取得を必要とする機能 | 利用不可 | CLI はゲートウェイセッションではフラグの取得をスキップします。これによって無効になる機能は、[フィーチャーフラグの取得を必要とする機能](https://code.claude.com/docs/ja/env-vars.md#features-that-need-feature-flag-fetching)に記載されています |
| 標準のプロンプトキャッシュ | 利用可能 | ゲートウェイは `cache_control` ブレークポイントをすべてのアップストリームに転送します。CLI がどのブロックにマークを付けるか（会話の途中で追加するシステムコンテキストを含む）については、[キャッシュの保存場所](https://code.claude.com/docs/ja/prompt-caching.md#where-the-cache-lives)で説明しています |
| 1 時間のキャッシュ TTL | オプトインで利用可能 | CLI はゲートウェイセッションではデフォルトで 5 分の TTL を使用します。1 時間の TTL をリクエストするには、[ポリシーで](https://code.claude.com/docs/ja/claude-apps-gateway-config.md#one-hour-prompt-cache)設定してください。アップストリームが TTL を拒否するとリクエストが失敗するため、ゲートウェイが提供するすべてのモデルについてアップストリームが 1 時間の TTL を提供している場合にのみ設定してください |
| auto モード | 利用可能 | [サードパーティプロバイダーのルール](https://code.claude.com/docs/ja/permission-modes.md#enable-auto-mode-on-bedrock-agent-platform-or-foundry)に従います。サードパーティプロバイダーで対象となるモデルのみが使用できます。v2.1.207 より前は、ゲートウェイセッションで auto モードを使用するには `CLAUDE_CODE_ENABLE_AUTO_MODE=1` の設定が必要でした。この設定は管理ポリシーの `env` ブロックで配信できます |
| グローバルキャッシュスコープやトークン効率の高いツールなど、ファーストパーティ専用の最適化 | 利用不可 | CLI はゲートウェイセッションではこれらを有効にしません。上記のベータヘッダーに関する注記を参照してください |
| OTLP/gRPC | サポート対象外 | OTLP over HTTP のみに対応しています |
| SAML、LDAP、その他の OIDC 以外の認証 | サポート対象外 | OIDC のみに対応しています。必要に応じて OIDC ブリッジを前段に配置してください |
| マルチテナント（複数の OIDC 発行者） | サポート対象外 | ゲートウェイごとに発行者は 1 つです。別々のインスタンスを実行してください |
| Windows サーバー | サポート対象外 | Linux にデプロイしてください。macOS はローカル開発専用です |
| Helm チャート | 利用不可 | ゲートウェイは標準のステートレスな Deployment として動作します。[デプロイガイド](https://code.claude.com/docs/ja/claude-apps-gateway-deploy.md#kubernetes)を参照してください |
| 管理 UI | 支出上限のみ | [ゲートウェイに接続した](#connect-claude-desktop) Claude Desktop 4.23118.0 以降では、[`admin.admin_groups`](https://code.claude.com/docs/ja/claude-apps-gateway-config#admin) のメンバーが支出上限を管理できます。その他の設定は YAML ファイルで行います。変更するには再デプロイしてください |

## 次のステップ

クイックスタートは Docker Compose で実行されている最小設定を残します。さらに進めるには。

* グループごとの RBAC、マルチアップストリームフェイルオーバー、またはテレメトリ宛先を追加するなど、最小設定を超えて `gateway.yaml` を拡張します。[設定リファレンス](https://code.claude.com/docs/ja/claude-apps-gateway-config.md)はすべてのオプションをカバーしています。
* Compose から Kubernetes または Cloud Run での本番デプロイメントに移動し、IdP を適切に設定し、セキュリティモデルを確認します。[デプロイメントおよび運用ガイド](https://code.claude.com/docs/ja/claude-apps-gateway-deploy.md)は、IdP ごとのセットアップ、コンテナイメージ要件、ヘルスプローブ、およびトラブルシューティングをカバーしています。
* 個々の開発者またはグループに支出キャップを設定して、暴走ワークロードがコミットメント全体を消費できないようにします。[支出制限](https://code.claude.com/docs/ja/claude-apps-gateway-spend-limits.md)は管理 API と強制がどのように機能するかをカバーしています。
* AWS での完全な実装例については、ECS Fargate または EKS、Amazon RDS、および Secrets Manager を使用して、[AWS にデプロイ](https://code.claude.com/docs/ja/claude-apps-gateway-on-aws.md)を参照してください。
* Google Cloud での完全な実装例については、Cloud Run、Cloud SQL、Secret Manager を使用して、[Google Cloud にデプロイ](https://code.claude.com/docs/ja/claude-apps-gateway-on-gcp.md)を参照してください。
