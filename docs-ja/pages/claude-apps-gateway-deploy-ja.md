> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# Claude apps gateway のデプロイと運用

> IdP にゲートウェイを登録し、コンテナをビルドして Kubernetes または Cloud Run にデプロイし、ヘルスチェック、シークレットローテーション、アップグレード、セキュリティを運用します。

> [!NOTE]
>
> **まずゲートウェイのネットワークを計画してください。** サインイン時、Claude Code は、ホスト名がパブリック IP アドレスに解決される Claude apps gateway を拒否します。インターネットから到達できないアドレスであっても同様です。
>
> Claude apps gateway は、シェルコマンドを実行するフックを含む設定をユーザーのマシンにプッシュできます。このチェックは、ユーザーがパブリックインターネット上の悪意のあるゲートウェイに誤ってサインインするのを防ぐのに役立ちます。自社のゲートウェイもインターネットから切り離しておいてください。
>
> ゲートウェイを実行する場所を選ぶ前に、ゲートウェイのアドレスを選んでください。通常は、ユーザーが内部ネットワーク上または VPN 経由でアクセスするプライベートアドレスです。内部ネットワークがパブリック IPv4 範囲を使用している場合は、ゲートウェイとユーザーのマシンの両方を含む範囲を 1 つ指定できます。Claude Code は、その一致をゲートウェイが内部ネットワーク上にあることを示すものとみなします。[ゲートウェイのアドレスを選択する](#choose-an-address-for-the-gateway) を参照してください。どちらもネットワークに合わない場合は、Anthropic のアカウントチームにお問い合わせください。

このページでは、[Claude apps gateway](/docs/ja/claude-apps-gateway) の運用側について説明します。ID プロバイダー（IdP）で OAuth クライアントを登録し、ゲートウェイをコンテナとしてデプロイし、日々運用します。ゲートウェイが起動時に読み込む `gateway.yaml` ファイルのすべてのオプションについては、[設定リファレンス](/docs/ja/claude-apps-gateway-config.md) を参照してください。

本番環境のデプロイメントは順序立てた 4 つのステップに従い、以下のセクションがそれに対応しています。最初の 2 つは選択を行う場所です。後の 2 つは、実行中に参照するリファレンス資料です。

1. [ID プロバイダーをセットアップする](#identity-provider-setup)：OAuth クライアントを登録し、Okta、Entra、Google の IdP 固有の注記を確認します
2. [ゲートウェイをデプロイする](#deployment)：ピン留めされたコンテナイメージをビルドし、Kubernetes、Cloud Run、または独自のプラットフォームで実行します。このセクションではコスト、バイパス、複数ゲートウェイ、サーバーレスの決定についても説明します
3. [運用をセットアップする](#operations)：ログ、ヘルスプローブ、障害時の動作、シークレットローテーション、アップグレード。監視とランブックを配線するときに参照するリファレンス
4. [セキュリティ体制を確認する](#security)：データがどこを流れるか、脅威モデル、コンプライアンスの回答。セキュリティレビュー用のリファレンス

サインインまたはブート中に失敗が発生した場合は、[トラブルシューティング](#troubleshooting) に直接進んでください。これは表示されるエラーに基づいてキー付けされています。

## ID プロバイダーのセットアップ

単一のリダイレクト URI `https://<gateway>/oauth/callback` を持つ機密 OAuth/OpenID Connect（OIDC）ウェブアプリケーションを ID プロバイダーに登録し、ゲートウェイアクセスを持つべきユーザーまたはグループに割り当てます。ゲートウェイは、登録のクライアントシークレットを使用して IdP に対して認証します。IdP が代わりに[証明書認証情報](/docs/ja/claude-apps-gateway-config.md#certificate-client-authentication)を使用する場合は、登録にアップロードした証明書を使用して認証します。

任意の OIDC 準拠 IdP が機能します：Okta、Microsoft Entra ID、Google Workspace、Keycloak、Dex、PingFederate など。IdP は 3 つの要件を満たす必要があります：

* `/.well-known/openid-configuration` を提供します。本番環境では HTTPS 経由です。ゲートウェイは [`http://` issuer](/docs/ja/claude-apps-gateway-config#oidc) を受け入れ、ループバック issuer は追加で `CLAUDE_GATEWAY_ALLOW_LOOPBACK=1` が必要です
* 認可コードフローをサポートします。PKCE（Proof Key for Code Exchange）はデフォルトで有効です。サポートしない IdP の場合は `oidc.use_pkce: false` で無効にします
* id\_token で `email` と必要に応じて `groups` を返すか、`oidc.userinfo_fallback: true` で userinfo エンドポイントから提供します

プライベート PKI の場合は、`oidc.ca_cert_pem` を設定します。

いくつかのプロバイダーはメールとグループクレームを異なる方法で処理します：

* **Okta**：`https://example.okta.com` の org 認可サーバーは、`email` と `groups` を省略した薄い id\_token を返すため、issuer として使用する場合は常に `oidc.userinfo_fallback: true` を設定します。`https://example.okta.com/oauth2/default` などのカスタム認可サーバーは、id\_token に `email` と必要に応じて `groups` を含め、直接発行し、フォールバックは不要です。Okta は `oidc.scopes` で `groups` スコープがリクエストされ、アプリのグループクレームフィルターが許可する場合にのみ `groups` を発行します。`userinfo_fallback` は IdP がリクエストされなかったクレームを埋めることはできません。
* **Microsoft Entra ID**：`issuer` = `https://login.microsoftonline.com/<tenant-id>/v2.0`。Entra はグループ名ではなくグループオブジェクト ID を発行するため、`managed.policies.match.groups` で GUID を使用するか、人間が読める名前のためにアプリロールを使用します。テナントが `groups` の代わりに `roles` の下でロールを発行する場合は、`oidc.groups_claim: roles` を設定します。
* **Google Workspace**：`issuer` = `https://accounts.google.com`。Google の id\_token はグループを含みません。Google を IdP として、グループベースの `allowed_groups` または `managed.policies` を使用するには、[`oidc.google_groups`](/docs/ja/claude-apps-gateway-config#oidc) を設定します。これは、ドメイン全体の委任を持つサービスアカウントを使用して Admin SDK Directory API を通じて各ユーザーのグループを検索します。これなしで、メンバーシップゲーティングに `oidc.allowed_email_domains` を使用し、ポリシー割り当てに `managed.policies.match.email_domain` を使用します。Google は標準の `offline_access` スコープも無視します。リフレッシュトークンの場合は、`oidc.scopes: [openid, profile, email]` と `oidc.extra_auth_params: { access_type: offline, prompt: consent }` を設定します。

> [!WARNING]
>
> リフレッシュトークンにより、ゲートウェイは開発者のセッションをサイレントに更新でき、開発者をブラウザに戻す必要がありません。また、IdP がユーザーを無効にすると、次のリフレッシュが失敗し、セッションは `ttl_hours` 内に終了するため、プロビジョニング解除を駆動します。ゲートウェイはデフォルトでリフレッシュトークンを取得するために `offline_access` をリクエストします。IdP がオフラインアクセスに明示的な同意を必要とする場合は、OAuth クライアントを設定してそれを許可します。
>
> IdP がリフレッシュトークンをまったく発行できない場合、ゲートウェイは引き続き機能しますが、サイレント更新がないため、開発者はセッションの有効期限が切れるとブラウザログインを再実行します。これが 1 時間ごとに発生するのを防ぐには、[`session.ttl_hours`](/docs/ja/claude-apps-gateway-config#session) を `8` または `12` に上げます。トレードオフはプロビジョニング解除の遅延です。リフレッシュトークンなしでは、無効にされたユーザーはより長い TTL が経過するまでアクセスを保持します。

## デプロイ

ゲートウェイは単一のステートレス Linux バイナリで、Postgres を通じて調整されるため、環境内で他のステートレスサービスをデプロイするのと同じ方法でデプロイします。ゲートウェイはネットワーク内に置き、開発者が HTTPS 経由で到達でき、ゲートウェイから IdP に到達できるようにします。また、本番認証情報を保持する他のサービスと同様に扱います。

デプロイメントを実行する場所を超えて形作るいくつかの決定があります：

* **コスト**：ゲートウェイの個別ライセンスまたはシートごとの料金はありません。ゲートウェイは `claude` バイナリの一部であるため、既存のコミットメントを通じて推論に対して支払い、実行するコンピュートに対して支払います。
* **バイパス**：ゲートウェイは、モデルへの唯一のルートがそれを通過することを強制しません。独自の認証情報を持つ開発者は引き続きプロバイダーを直接呼び出すことができるため、そのパスを閉じることはネットワークポリシーの決定です。例えば、`api.anthropic.com` へのエグレスをゲートウェイ以外からブロックします。そのエグレスをブロックすると、各開発者のマシンから `api.anthropic.com` を呼び出す [WebFetch ドメインセーフティチェック](/docs/ja/data-usage.md#webfetch-domain-safety-check) も破壊されます。管理ポリシーで `skipWebFetchPreflight: true` を設定して無効にします。
* **複数ゲートウェイ**：各ゲートウェイは独自の設定を持つ個別のデプロイメントで、CLI はゲートウェイホスト名ごとに信頼と認証情報を保存するため、チームは競合なしに異なるゲートウェイを使用できます。複数の OIDC issuer を提供するには、個別のインスタンスを実行します。
* **サーバーレス**：Cloud Run は機能します。`min-instances: 1` を設定して、コールド OIDC ディスカバリーを回避します。Lambda と Cloud Functions は機能しません。ゲートウェイは長時間実行 HTTP サーバーであるためです。

ここのすべての本番トポロジーは、L7 プロキシ（Ingress、Cloud Run のフロントエンド、ALB など）をプレーン HTTP レプリカの前に配置します。[`listen.trusted_proxies`](/docs/ja/claude-apps-gateway-config#listen) をプロキシのソース範囲に設定して、ゲートウェイが `X-Forwarded-For` からクライアント IP を読み込みます。ゲートウェイは TCP ピアが信頼されている場合にのみヘッダーを尊重します。[Google Cloud](/docs/ja/claude-apps-gateway-on-gcp.md) と [AWS](/docs/ja/claude-apps-gateway-on-aws.md) の実装例には、トポロジーごとに具体的な値があります。信頼されたプロキシなしでは、すべてのリクエストはプロキシの IP から来ているように見え、IP ごとのレート制限を 1 つの共有バケットに折りたたみ、監査イベントにプロキシの IP を記録します。

ゲートウェイのデバイス認可とトークンエンドポイントへのリクエストをリダイレクトしないでください。例えば、HTTP から HTTPS へのリダイレクトやホスト正規化の書き換えなどです。Claude Code はこれらのリクエストでリダイレクトに従わないため、ingress ルールがそれらをリダイレクトするとサインインとトークン更新が破壊されます。

プロキシに、ゲートウェイのキープアライブ間隔より長いアイドルタイムアウトを与えます。これは上流に依存します：

* `provider: anthropic` 以外のすべての上流では、ゲートウェイはストリームが約 15 秒間サイレント状態になった後、SSE `ping` を 1 回書き込みます。
* `provider: anthropic` では、ゲートウェイは Anthropic API 独自の ping を含む応答をそのまま渡します。

ALB の 60 秒などのデフォルトは、静かなストリームを開いたままにするのに十分です。[AWS の実装例](/docs/ja/claude-apps-gateway-on-aws.md#troubleshooting) はとにかくそれを 1 時間に引き上げ、トラブルシューティング行は v2.1.229 より古いゲートウェイをカバーしており、現在 ping を取得する上流でサイレント期間中に何も送信しませんでした。

### ゲートウェイのアドレスを選択する

Claude Code は、次の 2 つの方法のいずれかでゲートウェイのアドレスを受け付けます：

* **プライベートアドレス**：ゲートウェイを内部ロードバランサーまたは VPN の背後に配置し、RFC 1918 や CGNAT `100.64.0.0/10` などのプライベートアドレスにのみ解決されるホスト名を使用します。ユーザーのマシンはどのアドレスでもかまいません。[プライベートネットワークの前提条件](/docs/ja/claude-apps-gateway#prerequisites) に、受け付けられる範囲が記載されています。
* **宣言済みブロック**：内部ネットワークが組織所有のパブリック IPv4 空間を使用している場合は、そのブロックを `gatewayInternalNetworks` 管理設定に記載します。ゲートウェイとユーザーのマシンの両方がそのブロック内にある必要があります。[所有するパブリックアドレス空間上のゲートウェイを許可する](/docs/ja/claude-apps-gateway#allow-a-gateway-on-public-address-space-you-own) を参照してください。

両方を含む単一のブロックがない場合は、代わりにゲートウェイにプライベートアドレスを割り当ててください。

### コンテナイメージ

標準 Claude Code リリースのネイティブ `claude` バイナリの周りに独自のイメージをビルドします：

1. ピン留めされたリリースからイメージアーキテクチャの Linux ビルドをダウンロードします。ダウンロード URL については、[特定のバージョンをインストールする](/docs/ja/setup.md#install-a-specific-version) を参照してください。
2. [バイナリの整合性とコード署名](/docs/ja/setup.md#binary-integrity-and-code-signing) で説明されているように、リリースの GPG 署名付き `manifest.json` に対して検証します。
3. ビルドコンテキストにコピーします。

ビルドがリリースホストに到達できない場合は、リリースを内部レジストリにミラーリングし、フロートが実行するバージョンをピン留めします。

バイナリを超えて、イメージは以下が必要です：

* **glibc ベースのイメージ**：glibc ビルドの唯一の動的依存関係は glibc ライブラリです。Musl ベースのイメージは `linux-x64-musl` または `linux-arm64-musl` ビルドと追加パッケージが必要です。[Alpine Linux セットアップ](/docs/ja/setup.md#alpine-linux-and-musl-based-distributions) を参照してください。
* **書き込み可能な状態ディレクトリ**：ゲートウェイは任意のユーザーとして実行されますが、最小限のイメージには書き込み可能なホームがありません。`CLAUDE_CONFIG_DIR` を `/tmp/.claude` などの書き込み可能なパスに設定します。
* **コンテナコマンド**：`claude gateway --config /etc/claude/gateway.yaml`。設定ファイルは読み取り専用でマウントされ、シークレットは環境変数として提供されます。ゲートウェイは `listen.port` でリッスンします。デフォルトは `8080` です。

### Kubernetes

ゲートウェイをデプロイメントとして実行します。他のステートレスサービスと同様です：

* ConfigMap から設定をマウントし、Secret からシークレットをマウントします。YAML で `${file:/path/to/secret}` または環境変数を通じてシークレットを参照します
* Ingress で TLS を終了し、`listen.public_url` を Ingress ホスト名に設定します
* readiness プローブを `GET /readyz` に、liveness プローブを `GET /healthz` に指定します

AWS での完全な実装例（ECS Fargate または EKS、Amazon RDS、AWS Secrets Manager をカバー）については、[AWS にデプロイする](/docs/ja/claude-apps-gateway-on-aws.md) を参照してください。

静的キーよりもプラットフォームのワークロードアイデンティティを優先します。[`upstreams` リファレンス](/docs/ja/claude-apps-gateway-config#upstreams) にはプラットフォームごとのセットアップ詳細があります。クロスクラウドペアリング（例えば GKE 上の Amazon Bedrock 上流）の場合は、上流の `auth` ブロックで明示的な認証情報を設定します。

### Cloud Run

サービスを以下のように設定します：

* `listen.port` をデフォルトの `8080` のままにします。これは Cloud Run のデフォルト `PORT` と一致するか、`port: ${PORT}` を設定します
* `public_url` を外部到達可能なオリジンに設定します。本番環境では、これは通常、内部ロードバランサーのホスト名です。`/login` は [パブリックアドレスを拒否](/docs/ja/claude-apps-gateway#prerequisites) し、`*.run.app` URL はそれに解決するため、Cloud Run URL だけは `curl` またはブラウザスモークテストにのみ機能します。例外は、`*.run.app` が Private Service Connect と Cloud DNS プライベートゾーンを通じてプライベートに解決するネットワークです。そのトポロジーでは、Cloud Run URL は有効な `public_url` です。[Google Cloud の実装例](/docs/ja/claude-apps-gateway-on-gcp.md#deploy-the-gateway) は両方をカバーしています。
* シークレットボリュームとして設定をマウントします
* `min-instances: 1` を設定して、最初のリクエストでコールド OIDC ディスカバリーを回避します

Google Cloud での完全な実装例（Cloud Run または GKE、Cloud SQL、Secret Manager をカバー）については、[Google Cloud にデプロイする](/docs/ja/claude-apps-gateway-on-gcp.md) を参照してください。

### ゲートウェイ URL を開発者マシンにプッシュする

ゲートウェイが稼働したら、MDM を通じて、または OS ごとの `managed-settings.json` を直接書き込むことで、管理設定を通じて各開発者のマシンに `forceLoginMethod`、`forceLoginGatewayUrl`、および `parentSettingsBehavior: "merge"` をプッシュします。

キーをデプロイしたら、Claude Code はマシン上の残存する API キーまたは claude.ai ログインの使用を停止するため、サインイン指示と一緒にプッシュを計画します。[Administrator policy requires a Cloud gateway sign-in](/docs/ja/errors.md#administrator-policy-requires-a-cloud-gateway-sign-in) は開発者が見るメッセージについて説明しています。

各メカニズムがポリシーを保存する場所については [where each mechanism stores the policy](/docs/ja/managed-settings.md#where-each-mechanism-stores-the-policy) を参照し、Claude Desktop `bootstrapUrl` 相当については [Client-side managed settings](/docs/ja/claude-apps-gateway-config.md#client-side-managed-settings) を参照してください。

### 大規模なロールアウト

サインインはクライアント IP アドレスごとにレート制限されており、デフォルトは小規模なチームに適しています。各アドレスは 10 分ごとに 30 回のサインイン開始と 10 回のコード送信を取得します。数千人の開発者へのロールアウトは、次の 2 つの理由のいずれかで、最初の朝にこれらの制限に達する可能性があります：

* **ゲートウェイはロードバランサーを超えて見ることができません。** [`listen.trusted_proxies`](/docs/ja/claude-apps-gateway-config#listen) がない場合、すべての開発者はロードバランサーのアドレスから来ているように見え、1 つの制限を共有します。他の何よりも先にそれを設定します。ゲートウェイは、`X-Forwarded-For` ヘッダーを無視する最初の時間に警告をログに記録します。
* **多くの開発者が少数の NAT または VPN エグレスアドレスを共有しています。** `trusted_proxies` が正しい場合でも、それらのアドレスの制限を共有します。[`rate_limits`](/docs/ja/claude-apps-gateway-config#http-tuning) を引き上げて適合させます。

`max` のサイズを決定するには、開発者をそれらが共有するエグレスアドレスで割ります。1 つの `window_seconds` 期間内にそれらのうち何人がサインインするかを推定します。デフォルトは 10 分です。その後、リトライと Claude Code と Claude Desktop の両方にサインインする開発者をカバーするために 2 倍にします。

例えば、10,000 人の開発者が 4 つのエグレスアドレスの背後にあり、1 時間にわたって均等にサインインします。これは、アドレスごとに 2,500 人の開発者で、各 10 分ごとに約 420 人です。これを 2 倍にして 1,000 に切り上げます。以下の例は両方の制限を 1,000 に設定します：

```yaml theme={null}
rate_limits:
  device_authorization: { max: 1000, window_seconds: 600 }
  device_verify: { max: 1000, window_seconds: 600 }
```

`device_verify` は、別の開発者のサインインコードを推測するのを防ぐものであるため、推定が必要な限りだけそれを引き上げます。これらの制限でも、コードは 20 文字のアルファベットから 8 文字で、10 分後に期限切れになるため、推測は実用的なままです。[User-code brute-force resistance](#user-code-brute-force-resistance) を参照してください。

IdP がリフレッシュトークンを発行する場合、Claude Code はセッションをサイレントに更新するため、ロールアウト後に制限を戻すことができます。リフレッシュトークンがない場合、開発者は [`session.ttl_hours`](/docs/ja/claude-apps-gateway-config#session) ごとに再度サインインします。その定常状態レートの両方の制限のサイズを決定し、それらを引き上げたままにします。

制限に達すると、Claude Code v2.1.274 以降は `The gateway is limiting sign-in attempts right now` を表示します。v2.1.274 以降のゲートウェイは、検証ページに `Too many attempts came from your network address` を表示し、確認する設定を表示します。また、変更する設定に名前を付ける `sign-in refused` ログ行も書き込みます。

## 運用

ゲートウェイがトラフィックを処理するようになると、日々の運用はログの確認、ヘルスチェック、そして自社のスケジュールに沿ったシークレットのローテーションになります。以下の各サブセクションでは、それぞれの作業に加え、Postgres に保存される内容と、アップグレードおよびロールバック時の挙動について説明します。

### ログ

ゲートウェイは 2 種類のストリームを stderr に書き出します。どちらも JSON で扱いやすい形式です。

* **監査イベント**: セキュリティに関わるイベントごとに 1 行の JSON を出力します。stderr をログアグリゲーターにパイプしてください。

  出力されるイベントは `config.load`、`session.mint`、`session.refresh`、`device.authorize`、`device.verify`、`device.callback`、`auth.denied`、`access.denied`、`access.public_client`、`inference`、`managed.serve`、`desktop_bootstrap.serve`、`desktop_bootstrap.denied`、`spend.blocked`、`admin.denied`、`admin.limit.upsert`、`admin.limit.delete` です。フィールドはイベントによって異なります。

  * 成功した mint および refresh イベントには `sub`、`email`、`client_ip`、および結果が含まれます
  * `auth.denied` と `access.denied` には理由とクライアント IP が含まれ、`auth.denied` にはさらにリクエストパスが含まれます。これらの拒否の時点ではユーザー ID が存在しないためです。`access.denied` の理由のうち 2 つは、イベントに含まれる内容を変えます。
    * `xff_unparseable`: 読み取れなかった `X-Forwarded-For` のエントリもイベントに含まれます
    * `client_ip_unknown`: `access_control` リストが設定されている状態で接続にピアアドレスがなかったため、イベントにクライアント IP は含まれません
  * `access.public_client` には、`access_control.allow_cidrs` が空の状態でパブリックアドレスから届いた、プロセスごとの最初のリクエストのクライアント IP が含まれます。ゲートウェイはそのリクエストを通常どおり処理します。このイベントは、ゲートウェイがパブリックインターネットから到達可能である可能性を示します。何がパブリックとみなされるか、および推奨される許可リストについては、[`access_control` リファレンス](/docs/ja/claude-apps-gateway-config#http-tuning)を参照してください。
  * `inference` には、どのアップストリームがリクエストを処理したかと、レスポンスのステータスが記録されます
  * `desktop_bootstrap.denied` には、拒否された Claude Desktop のブートストラップ取得が、理由（`not_configured`、`policy_not_opted_in`、または `no_policy_matched`）およびユーザーの ID とともに記録されます
  * `admin.denied` には、拒否された管理 API の認証試行が、クライアント IP、メソッド、パス、理由とともに記録されます。提示された鍵情報は記録されません。理由は、`x-api-key` が提示されたもののどの設定済みキーとも一致しなかった場合は `invalid_key`、`Authorization` ヘッダーのみが提示され、それが `admin.admin_groups` のゲートウェイセッションとして検証されなかった場合は `bearer_rejected`、どちらのヘッダーも提示されなかった場合は `no_credentials` です
* **運用ログ**: 起動、警告、アップストリームのエラーについて、`[gateway]` というプレフィックスの付いた人間が読める形式の行を出力します。詳細度は `CLAUDE_GATEWAY_LOG_LEVEL` 環境変数で制御し、`debug`、`info`、`warn`、`error` のいずれかを指定できます。デフォルトは `info` です。`debug` では、サインインとリフレッシュのたびに id\_token に含まれるクレームの名前（値ではありません）もログに記録され、`userinfo_fallback` が何らかのクレームを提供した場合は userinfo クレームの名前も記録されます。これにより、PII をログに残さずに `email_claim` と `groups_claim` の設定を診断できます。この設定は監査イベントには影響せず、監査イベントは常に出力されます。

### ヘルスチェック

ゲートウェイは、liveness プローブとして `GET /healthz` を、readiness プローブとして `GET /readyz` を提供します。`/readyz` はストアに到達可能かどうかを検証します。[`store.readiness_grace_seconds`](/docs/ja/claude-apps-gateway-config#store) を設定した場合、ストアが応答しなくなってからその秒数が経過するまで、`/readyz` は ready を報告し続けます。

どちらのエンドポイントも `access_control.allow_cidrs` の対象外であるため、アクセスを制限したリスナーでもプローブは動作し続けます。

`/.well-known/oauth-authorization-server` の OAuth ディスカバリードキュメントも、設定の読み込み、OIDC ディスカバリー、アップストリームクライアントの構築、Postgres のマイグレーションがすべて成功した後にのみ `200` を返すため、エンドツーエンドの起動チェックとしても使えます。

### アップストリームへの同時リクエスト

デフォルトでは、各ゲートウェイレプリカがアップストリームに同時に送信するリクエストは最大 256 件です。ストリーミングレスポンスは、ストリームが終了するまでこの上限にカウントされます。

レプリカが上限に達している間に届いたリクエストは、ゲートウェイ内で空きスロットを待ちます。開発者からは、レスポンスの開始が遅い、またはハングしているように見えます。`provider: anthropic` のアップストリームでは、[`timeouts.upstream_ttfb_ms`](/docs/ja/claude-apps-gateway-config#http-tuning) より長く待ったリクエストはそのアップストリームをあきらめ、後続のアップストリームがそれを処理しない場合は 502 で失敗します。

`upstream requests:` を含む起動時のログ行に、有効な上限が表示されます。レプリカで開いているリクエストが上限を超えている間は、`client requests are open` を含む警告も最大で 1 分に 1 回ログに記録されます。

より多くのリクエストを同時に処理するには、2 つの方法があります。

* レプリカを追加する。
* 各レプリカの上限を引き上げる。ゲートウェイコンテナで `BUN_CONFIG_MAX_HTTP_REQUESTS` 環境変数を 1 から 65535 までの整数に設定し、コンテナを再起動します。

レプリカが上限に達するリクエストレートは、おおよそ上限をリクエストが開いている平均秒数で割った値です。たとえば、リクエストが平均 10 秒間開いている場合、デフォルトの上限 256 のレプリカは毎秒約 26 件のリクエストで上限に達します。

CPU に基づいてオートスケールしている場合、上限に達したレプリカはスケールアウトをトリガーせずにリクエストをキューに入れるため、レプリカが `client requests are open` の警告をログに記録するときの CPU レベルよりも低い値をターゲットに設定してください。

> [!WARNING]
>
> 開いているリクエストはすべて、ストリーミング中および空きスロットの待機中に、ゲートウェイプロセスのメモリを保持します。上限を 256 のままにしていても、待機中のリクエストはリクエストボディを保持するため、過負荷のレプリカのメモリは増え続けます。ピーク時に開いているリクエスト数に合わせてコンテナのメモリを見積もり、上限を変更する際はメモリを監視してください。メモリ不足になったレプリカは強制終了され、保持しているすべてのストリームが切断されます。

### `API_TIMEOUT_MS` をゲートウェイの最初のバイトまでの時間より大きく保つ

応答のないリクエストをより早く再試行するために [`API_TIMEOUT_MS`](/docs/ja/network-config#streaming-idle-watchdogs) を下げる場合は、ゲートウェイがストリーミングレスポンスの最初のバイトを送信するまでにかかる時間より大きい値を保ってください。それより長く待つリクエストはタイムアウトし、同じだけ待つ再試行もそれぞれタイムアウトして、最終的にターンが `Request timed out` で終了します。

* **`provider: anthropic`**: アップストリームが最初のイベントを送信するまでにかかる最長時間より大きい値を `API_TIMEOUT_MS` に設定します。
* **その他すべてのアップストリーム**: アップストリームがレスポンスヘッダーを返すまでにかかる最長時間より 20 秒以上大きい値を設定します。ゲートウェイは、アップストリームの最初のイベントがそれより早く届かない限り、それらのヘッダーの約 15 秒後に最初の [keepalive `ping`](#deployment) を送信します。v2.1.229 より古いゲートウェイは ping を送信しないため、その場合は `provider: anthropic` のルールを使用してください。

その時間に加えて、[空きスロットの待機](#concurrent-upstream-requests)と、[フェイルオーバー](/docs/ja/claude-apps-gateway-config.md#multiple-upstreams)前のダウンしたアップストリームでの待機を考慮してください。また、最も長い[非ストリーミングリクエスト](/docs/ja/network-config.md#streaming-idle-watchdogs)よりも大きい値を保ってください。

### 障害時の挙動

Postgres がダウンした場合、ゲートウェイ自体はサインイン済みの開発者へのサービスを継続し、新規のサインインは失敗します。開発者が実際に作業を続けられるかどうかは、オーケストレーターが readiness をどう扱うかによって決まります。

* **既存のセッション**: ベアラートークンは JWT シークレットでローカルに検証され、セッションのリフレッシュはストアにアクセスせず、ゲートウェイプロセスは引き続き推論を処理できます
* **新規のサインイン**: デバイスフローとそのレート制限カウンターは Postgres に保存されているため、Postgres が復旧するまで失敗します
* **[利用額上限の適用](/docs/ja/claude-apps-gateway-spend-limits.md#postgres-availability)**: デフォルトでは障害中はフェイルオープンになるため、推論は引き続き流れます。計測なしで稼働するよりもブロックしたい場合は、フェイルクローズに切り替えてください
* **Readiness**: デフォルトでは、Postgres に到達できなくなるとすぐに `/readyz` が not-ready を報告するため、すべてのレプリカが同時に readiness チェックに失敗します。チェックに合格したレプリカにのみトラフィックが届く環境では、ゲートウェイがまだ処理できる推論を含むすべてのトラフィックが、Postgres が復旧するまで失敗します。`/healthz` の liveness プローブはその間も合格し続けます。

IdP がダウンした場合、既存のセッションは `ttl_hours` まで機能し、新規のログインは失敗します。セッションのリフレッシュには再試行を求める応答が返され、IdP が復旧すると成功します。IdP のメンテナンス時間が頻繁にある場合は、`ttl_hours` を長めに設定してください。

#### Readiness の猶予期間

データベースのフェイルオーバーのような短時間の Postgres 障害の間もサインイン済みの開発者が作業を続けられるようにするには、[`store.readiness_grace_seconds`](/docs/ja/claude-apps-gateway-config#store) をフェイルオーバーにかかる時間より長い値（たとえば `300`）に設定します。利用額上限が有効でデフォルトのフェイルオープン動作の場合、ready のままのレプリカを経由するリクエストは Postgres が復旧するまで計測されないため、値はフェイルオーバーをカバーできる範囲でできるだけ小さくしてください。[`enforcement.fail_closed_on_error: true`](/docs/ja/claude-apps-gateway-config#enforcement) を設定した場合、レプリカが readiness チェックに合格している間でも、Postgres が復旧するまでゲートウェイはサインイン済みの開発者の推論を `429` の `spend limit unavailable` メッセージで拒否します。

この設定には、ゲートウェイサーバーで Claude Code v2.1.282 以降が必要です。それより前のゲートウェイはこのキーを検出すると起動を拒否するため、キーを追加する前にすべてのレプリカをアップグレードしてください。ロールバックについては[アップグレード](#upgrades)で説明しています。

代わりに readiness プローブを `/healthz` に向けた場合も、障害中にレプリカはプローブに合格し続けますが、`/healthz` は not-ready を報告することがないため、Postgres 接続が復旧しないレプリカも合格し続けます。

### JWT シークレットのローテーション

既存のセッションが有効なままになるよう、署名シークレットは段階的にローテーションします。

1. 新しいシークレットを生成します。それを `session.jwt_secret` 配列の先頭に追加します。
2. デプロイをロールします。新しいトークンは新しいシークレットで署名され、古いトークンも引き続き検証されます。
3. `ttl_hours` に余裕を加えた時間が経過したら、古いシークレットを削除して再度ロールします。

ローテーションは、有効期限前にセッションを強制的に終了させる唯一の方法でもあります。ベアラートークンは JWT シークレットに対してローカルに検証されるため、セッション単位での失効はありません。古いシークレットを配列に残さずにシークレットを完全に置き換えると、未失効のすべてのセッションが一度に無効になります。個々のユーザーのオフボーディングについては、IdP でそのユーザーのプロビジョニングを解除してください。そのユーザーのセッションは `ttl_hours` 以内に終了します。

### Postgres

ゲートウェイは状態を PostgreSQL データベースに保存します。

* **データベース**: PostgreSQL 本体（セルフホストまたはマネージド）で、[最小バージョン](/docs/ja/claude-apps-gateway#prerequisites)以降のもの。分散 SQL データベースなど、Postgres プロトコルを実装しているだけのデータベースはサポートされていません。
* **アドレス**: `store.postgres_url` には 1 つのホストを指定します。データベースに複数のノードがある場合は、マネージドサービスのエンドポイント、ロードバランサー、仮想 IP など、それらの前段にあるアドレスを使用してください。フェイルオーバーにかかる時間より長い [readiness の猶予期間](#readiness-grace-period)を設定してください。

ゲートウェイは 5 つのデータテーブルと `_migrations` テーブルを保持し、いずれも起動時のマイグレーションによって作成されます。

| テーブル | 内容 | 保持期間 |
| - | - | - |
| `kv` | デバイスグラント（10 分の TTL）とレート制限カウンター | 行ごとの TTL |
| `spend` | プリンシパルごとの期間累計の利用額カウンター（セント単位） | `admin.spend_retention_months`、デフォルトは 13 |
| `spend_limits` | 設定された利用額上限 | API で削除されるまで |
| `admin_audit` | 管理 API による変更の記録 | `admin.audit_retention_days`、デフォルトは 365 |
| `principal_emails` | 各プリンシパルの最後に確認されたメールアドレス、表示名、IdP グループ。PII を含みます。 | 最後のアクティビティから `admin.identity_retention_days`、デフォルトは 90 |

30 秒ごとのループが TTL を過ぎた `kv` の行を期限切れにし、1 時間ごとのスイープが利用額テーブルの保持期間を適用するため、無制限に増え続けるものはありません。[利用額上限](/docs/ja/claude-apps-gateway-spend-limits.md)が設定されていない場合、書き込まれるのは `kv` のみです。ゲートウェイは起動時およびアップグレードのたびに独自のスキーママイグレーションを適用するため、そのデータベースロールにはテーブルを作成および変更する権限が必要です。その権限付与の範囲を狭く保つため、ゲートウェイ専用のデータベースまたはスキーマを指定してください。

利用額上限を使用している場合、データベースを失うと開発者の再ログインだけでなく、利用額の追跡と上限も失われるため、定期的にバックアップを取ってください。保持期間を待たずに退職した開発者 1 人のデータを即座に消去するには、`DELETE FROM principal_emails WHERE principal = '<sub>'` を直接実行します。これにより、その開発者のメールアドレス、名前、グループを保持する唯一のテーブルから削除されます。`spend` と `admin_audit` の行は、仮名化された OIDC の `sub` のみを参照します。

#### 接続プールのサイズを決める

各レプリカは最大 [`store.max_connections`](/docs/ja/claude-apps-gateway-config#store) 個の Postgres 接続を開きます。デフォルトは 5 です。レプリカ数 × `store.max_connections` が、データベースがゲートウェイ用に残している接続数以下になるようにしてください。

* **レプリカ数**: 同時に稼働する最大数を数えます。オートスケーリングの最大値（オートスケールしていない場合はレプリカ数）から始め、ローリングアップデートで古いレプリカを停止する前に起動される追加のレプリカを加えます。デフォルト設定の Amazon ECS や Cloud Run では、それが同数に及ぶことがあります。
* **残りの接続数**: データベースの `max_connections` から、データベースが予約している分と他のクライアントが保持している分を差し引きます。PostgreSQL は `superuser_reserved_connections` を予約しており、デフォルトは 3 です。マネージドサービスではさらに多く予約されている場合があるため、そのドキュメントを確認してください。

たとえば、オートスケーリングの最大値が 6、ローリングアップデートで起動される追加のレプリカが最大 2、デフォルトのプールが 5 の場合を考えます。必要な接続数は (6 + 2) × 5 = 40 です。`max_connections` が 50 で、他のクライアントが 2 つの接続を保持しているデータベースでは、残りは 50 − 3 − 2 = 45 となるため、合計は収まります。

合計が収まらない場合は、次のいずれかを変更します。

* **データベース**: `max_connections` を引き上げる
* **レプリカ**: 稼働数を減らすか、ローリングアップデートで起動する追加のレプリカを減らすようオーケストレーターを設定する
* **プール**: `store.max_connections` を下げる。ただし、[利用額上限](/docs/ja/claude-apps-gateway-spend-limits.md)が有効な場合は、各レプリカの負荷に十分な大きさを保ってください。そうしないと、利用額チェックが接続を待つ間に[タイムアウト](/docs/ja/claude-apps-gateway-spend-limits.md#postgres-availability)する可能性があり、ゲートウェイは `spend check failed: spend precheck timed out` をログに記録します。

### アップグレード

レプリカはステートレスであるため、ローリング再起動でゲートウェイの状態が失われることはありません。ゲートウェイは起動時にスキーママイグレーションを実行するため、新しいバイナリをデプロイするとデータベースが自動的にマイグレーションされます。同時に稼働するレプリカは Postgres のアドバイザリーロックで直列化されるため、各マイグレーションを適用するのは 1 つのレプリカのみです。

ローリング再起動やスケールインのように、オーケストレーターが `SIGTERM` でレプリカを停止すると、ゲートウェイは新しい接続の受け付けを停止し、処理中のリクエストとストリームが完了するのを待ってから終了します。最大 25 秒（ドレインウィンドウと呼びます）待機し、その後もまだ開いているものを閉じます。ターミナルでの Ctrl+C のような `SIGINT` でも同じドレインが開始され、ドレイン中に 2 回目のシグナルを受け取ると、開いているリクエストを閉じて直ちに終了します。ドレインにはゲートウェイ v2.1.274 以降が必要です。

長い生成は数分間ストリーミングされることがあります。Kubernetes と Amazon ECS では、それらのストリームにより多くの時間を与えるために、次の 2 つを一緒に引き上げてください。

* **ドレインウィンドウ**: ゲートウェイコンテナで `CLAUDE_GATEWAY_DRAIN_TIMEOUT_MS` 環境変数を、`120000` のようなミリ秒単位の正の整数に設定します。`120s` のような他の形式の値はゲートウェイに無視され、デフォルトの 25 秒が維持されます
* **オーケストレーターの猶予期間**: Kubernetes では `terminationGracePeriodSeconds`、Amazon ECS では `stopTimeout`

猶予期間はどちらのプラットフォームでもデフォルトで 30 秒です。ドレインウィンドウより少なくとも 5 秒長く保ってください。そうしないと、ドレインが完了する前にオーケストレーターがゲートウェイを強制終了します。Kubernetes では、`preStop` フックの所要時間も加えてください。猶予期間のカウントは、ゲートウェイが `SIGTERM` を受け取った時点ではなく、フックが実行される前から始まるためです。

プラットフォームによっては、ドレインを実行できる時間に上限がある場合もあります。

* **Fargate 上の Amazon ECS**: `stopTimeout` は最大 120 秒までです
* **Cloud Run**: `SIGTERM` の 10 秒後にインスタンスを停止するため、ドレインウィンドウの値にかかわらず、開いているストリームに与えられる時間は最大 10 秒です

リクエストが開いたままドレインウィンドウが終了すると、ゲートウェイは `drain window over after` を含む警告をログに記録し、切断したリクエストの数を数え、引き上げるべき 2 つの設定の名前を示します。

マイグレーションは追記のみであるため、認識しているマイグレーションが少ない以前のバイナリへのロールバックは安全です。以前のバイナリは余分な行を無視します。また、ロールバック時には YAML が古いバイナリのスキーマに対して再検証されるため、新しいリリースで導入されたキーを採用した設定は、古いバイナリでの起動に失敗します。ロールバックする前に新しいキーを削除してください。

ゲートウェイのバージョンは自社のイメージで固定するため、新しい Claude Code リリースの修正（セキュリティ修正を含む）がデプロイ環境に反映されるのは、固定バージョンを更新して再デプロイしたときだけです。本番環境の認証情報を保持する他のサービスと同じパッチ適用サイクルにゲートウェイを含めてください。

## セキュリティ

このセクションは、セキュリティレビューが尋ねる質問に答えます：ゲートウェイを通じてどのデータが流れ、どこに行くか、設計が防御する攻撃、コンプライアンスアンケートに属する回答。

### データフロー

| データ | パス | ゲートウェイによって Anthropic に送信 |
| - | - | - |
| 推論（プロンプト、完了） | CLI → ゲートウェイ → 上流 | Anthropic API が設定された上流の場合のみ |
| テレメトリ（OTLP メトリクス、プラス [オプトイン ログとトレース](/docs/ja/claude-apps-gateway-config.md#telemetry)） | CLI → ゲートウェイ → コレクター | なし |
| アイデンティティ（メール、グループ、sub） | IdP → ゲートウェイ → CLI。CLI はそれを OTLP エクスポートにスタンプします。[`forward_user_identity`](/docs/ja/claude-apps-gateway-config#per-user-identity-headers-for-a-proxy-you-run) をオンにすると、ゲートウェイは開発者のメールと IdP サブジェクトをヘッダーとしてプロキシに送信します | なし |
| 管理設定 | ゲートウェイ YAML → CLI | なし |
| 監査ログ | ゲートウェイ stderr → アグリゲーター | なし |

### 脅威モデルの概要

ゲートウェイはネットワーク境界内に位置しますが、個々の開発者ラップトップは信頼されていないと見なされます。設計はこれを 3 つの方法で説明します：

* 開発者は生の上流キーの代わりに短命の JWT を保持します。CLI からゲートウェイへのレッグは RFC 8628 デバイスグラントを使用し、ゲートウェイの IdP との認可コード交換はデフォルト設定で PKCE を実行するため、インターセプトされた IdP 認可コードは無用です。
* デバイス検証ページは同一オリジン POST と RFC 8628 §5.1 ごとの IP ごとのレート制限を実装します。[ユーザーコードブルートフォース耐性](#user-code-brute-force-resistance) を参照してください。
* ゲートウェイの IdP、OTLP コレクター、および `provider: anthropic` 上流へのリクエストは、サーバー側リクエストフォージェリ（SSRF）ガードを通じて行われます。DNS を解決し、リンクローカルとクラウドメタデータアドレスをブロックし、デフォルトではループバックをブロックし、接続を解決された IP にピン留めするため、オペレーター影響 URL はクラウドメタデータエンドポイントにリダイレクトできません。RFC 1918 プライベート範囲は意図的に許可されます。IdP と OTLP コレクターは一般的にプライベート IP に存在するため。その他のプロバイダーの場合、ゲートウェイは設定をロードするときにそれらのアドレスまたはメタデータホスト名を指定する `base_url` を拒否し、プロバイダーの SDK は DNS チェックなしで接続します。

  [プロキシのみのエグレス](/docs/ja/claude-apps-gateway-config.md#proxy-only-egress) をオンにすると、そのアドレスチェックはフォワードプロキシに移動します：ゲートウェイはホスト名を渡し、プロキシのアロウリストはそれらの宛先を拒否する必要があります。

  ゲートウェイが正当に到達する必要があるもの（ローカル開発 IdP やサイドカー OTLP コレクター（`localhost` など））がループバック上に存在する場合にのみ、ゲートウェイの環境で `CLAUDE_GATEWAY_ALLOW_LOOPBACK=1` を設定します。変数はすべてのオペレーター設定 URL のループバックブロックを緩和し、ポッドがクラウドメタデータエンドポイントに到達できるかどうかをチェックするブート時警告もスキップするため、コレクターに独自の内部アドレスを与えることをお勧めします。

独自のエグレス制御を追加する場合、ゲートウェイはワークロードアイデンティティなどのインスタンスメタデータ認証情報を使用するときはいつでもメタデータサーバーに到達する必要があります。

2 つの脅威は、インフラストラクチャを保護するためのものであるため、スコープ外です：

* **侵害されたゲートウェイホスト**：ホストは上流認証情報を保持し、[管理設定](/docs/ja/claude-apps-gateway-config.md#managed) をすべての接続された開発者に配布するため、ゲートウェイの設定の制御は MDM の制御に匹敵します。CLI の [承認ダイアログ](/docs/ja/server-managed-settings.md#approval-memory) はシェル対応設定のサイレント変更を制限しますが、ホストセキュリティに置き換わりません。
* **悪意のある OIDC プロバイダー**：プロバイダーはゲートウェイが信頼する id\_token に署名するため、任意のアイデンティティを主張できます。IdP の検証と保護はあなたの責任です。

### ユーザーコードブルートフォース耐性

開発者が `/device` 検証ページに入力する `user_code` は、20 文字のアルファベットから引き出された 8 文字です。これは 20⁸ または約 2.56×10¹⁰ の組み合わせを生成し、10 分後に期限切れになります。

ゲートウェイは [`rate_limits`](/docs/ja/claude-apps-gateway-config#http-tuning) を通じて設定可能なデバイスグラントエンドポイントに IP ごとのレート制限を適用します。多くの開発者が単一の共有企業 NAT アドレスからサインインする場合は、制限を上げます。[大規模ロールアウト](#large-rollouts) は、それらのサイズを決定する方法を示しています。制限はサインインフローにのみ適用され、推論には適用されません。

### コンプライアンス体制

* **データレジデンシー**：ゲートウェイ自体のデータプレーンは、Anthropic API が設定された上流の場合を除き、Anthropic に何も送信しません。その場合、既存のデータ処理契約が推論パスに適用されます。テレメトリ、監査、アイデンティティ、設定は設定した宛先にのみ行きます。
* **ホストプロセストラフィック**：ホストプロセスは Claude Code CLI です。`claude gateway` は Amazon Bedrock および Google Cloud の Agent Platform デプロイメントと同じサードパーティルールの下で実行され、Anthropic に何も送信しません。v2.1.227 より前では、ホストプロセスは製品バージョンとプラットフォームなどのスタートアップテレメトリを送信していました。これはコンテナ環境で `CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC=1` を設定することでオフにできました。これらのリリースはまた、ボート時に本文または認証情報なしで 1 つの `HEAD` リクエストを `https://api.anthropic.com` の `/api/hello` に送信していました。または環境が `ANTHROPIC_BASE_URL` を設定した場合はそれに、環境が `HTTPS_PROXY` などのプロキシ変数または mTLS クライアント証明書も設定していない限り。彼らは応答を無視したため、エグレスファイアウォールでそのリクエストをブロックしてもゲートウェイに影響しませんでした。
* **クライアント分析**：CLI はゲートウェイにサインインしている間、独自の使用分析とエラー報告を無効にします。最初のサインイン前に、CLI はまだ Anthropic にスタートアップイベントを送信します。これには、管理設定がゲートウェイサインインを強制するマシンも含まれます。これらもオフにするには、ゲートウェイサインインを強制する同じ [クライアント側管理設定](/docs/ja/claude-apps-gateway-config.md#client-side-managed-settings) で [`DISABLE_TELEMETRY`](/docs/ja/managed-settings#turn-telemetry-off-for-your-organization) を配信します。
* **エラー報告**：CLI はモデルリクエストが Anthropic のファーストパーティ API 以外のエンドポイント（Amazon Bedrock やカスタム `ANTHROPIC_BASE_URL` など）に行くときはいつでもエラー報告をオフにします。
* **クライアントマシン**：開発者の CLI は、`CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC=1` と `skipWebFetchPreflight: true` が設定されていない限り、WebFetch ホスト名チェックとバージョンチェックを Anthropic に送信し続けます。[プラグインマーケットプレイスのリクエスト](#plugin-marketplace-requests) には独自のオフスイッチがあります。[データ使用](/docs/ja/data-usage.md) を参照してください。
* **サーベイ評価**：ゲートウェイにサインインしている間、CLI は Anthropic バウンド評価アップロードを分析ストリームと一緒に無効にするため、評価を Anthropic に送信しません。
* **トランスクリプト共有**：サーベイのトランスクリプト共有プロンプトで「はい」を選択すると、Anthropic にアップロードする代わりに `~/.claude/feedback-bundles/` の下にローカルファイルを書き込みます。
* **クライアント更新**：更新チェックはゲートウェイトラフィックとは別です。独自の配布を通じてバージョンをピン留めし、ラップトップがリリースをフェッチしてはいけない場合は `DISABLE_UPDATES` を設定します。`DISABLE_AUTOUPDATER` はバックグラウンド更新のみを停止し、`claude update` は引き続き機能します。
* **TLS**：本番環境で `public_url` を HTTPS 経由で提供します。ゲートウェイ自体のリスナー経由で `listen.tls` を使用するか、プレーン HTTP レプリカの前の TLS 終了 ingress から `listen.public_url` を設定します。どちらの場合でも。ゲートウェイはプレーン HTTP を拒否しません。IdP は本番環境で HTTPS を提供する必要があり、Postgres は `?sslmode=require` をサポートします。ingress で `Strict-Transport-Security` を設定します。
* **脆弱性開示**：[セキュリティ問題の報告](/docs/ja/security.md#reporting-security-issues) に従います

### プラグインマーケットプレイスのリクエスト

Claude Code は、プラグインマーケットプレイスをゲートウェイ経由ではなく、各開発者のマシンから直接取得します。ホストの一覧は [ネットワークアクセス要件](/docs/ja/network-config.md#network-access-requirements) に記載されています。

開発者が初めてインタラクティブなターミナルセッションを開始すると、Claude Code は公式マーケットプレイス `claude-plugins-official` を登録します。カタログは `downloads.claude.ai` からダウンロードされ、それが失敗した場合は `github.com` からクローンされます。その後の更新については [自動更新されるマーケットプレイスとプラグイン](/docs/ja/plugins/loading.md#which-marketplaces-and-plugins-auto-update) で説明しています。

`CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC=1` では最初の登録は止まりません。次のいずれかの管理設定で止めることができます：

* **マーケットプレイスリスト**：そのマーケットプレイスを含まない [`strictKnownMarketplaces`](/docs/ja/plugins/org#allowlist-with-strictknownmarketplaces) 許可リスト、またはそのマーケットプレイスを指定する [`blockedMarketplaces`](/docs/ja/plugins/org#blocklist-with-blockedmarketplaces) エントリ
* **環境変数**：管理設定の [`env` ブロック](/docs/ja/plugins/org#turn-updates-off-for-the-whole-fleet) で `CLAUDE_CODE_DISABLE_OFFICIAL_MARKETPLACE_AUTOINSTALL` を `"1"` に設定

最初の登録は、開発者がゲートウェイにサインインする前、つまりゲートウェイポリシーがまだ届いていない時点で実行される場合があります。この最初の起動にも対応するには、ゲートウェイポリシーの [`cli` または `code` ブロック](/docs/ja/claude-apps-gateway-config#what-goes-in-cli) に加えて、[クライアント側管理設定](/docs/ja/claude-apps-gateway-config.md#client-side-managed-settings) でも選択した設定を配信してください。

## トラブルシューティング

ご質問やフィードバックについては、[Claude Code サポート](https://support.claude.com/en/collections/14445694-claude-code)をご利用いただくか、[Claude Code GitHub リポジトリ](https://github.com/anthropics/claude-code/issues)で issue を開いてください。Anthropic のアカウントチームに問い合わせることもできます。問題を報告する際は、以下の情報を含めてください。

* **Gateway の問題**: gateway の stderr（該当するウィンドウの）、`gateway.yaml`（シークレットは削除）、gateway のバージョン（ランディングページの `/` と `/managed/settings` の `x-cc-gateway-version` レスポンスヘッダーに表示）、および最近の変更内容
* **ログイン問題**: 開発者が `claude --debug-file ./claude-debug.txt` を実行して再現し、そのファイルと同じウィンドウの gateway の監査ログを送信
* **推論の問題**: リクエストされたモデル、設定されたアップストリーム、およびリクエストの gateway 監査ログ（どのアップストリームがそれを処理したか、およびレスポンスステータスを記録）

gateway の stderr には監査イベントストリームが含まれ、監査ログには開発者の ID が記録され、デバッグファイルには開発者のマシンからのフックと MCP サーバーの出力が記録されます。公開 issue に投稿する前に、これらを確認して削除してください。

| 症状 | 原因 | 修正方法 |
| - | - | - |
| 開発者の `/login` が **Cloud gateway** 画面ではなく標準のアカウントピッカーを表示する | そのマシンの管理設定で `forceLoginMethod` または `forceLoginGatewayUrl` が設定されていない | [管理設定ファイル](/docs/ja/claude-apps-gateway#set-the-gateway-url)をデバイスにデプロイしてください。`/login` はそこから gateway URL を読み込みます |
| 開発者のリクエストが `Not signed in to the Cloud gateway — run /login.` で失敗する | マシンの管理設定で `forceLoginMethod: "gateway"` または `forceLoginGatewayUrl` が設定されており、セッションに gateway サインインがない。残っている claude.ai ログインは要件を満たしていません。 | 開発者に `/login` を実行して gateway サインインを完了させてください。[Administrator policy requires a Cloud gateway sign-in](/docs/ja/errors.md#administrator-policy-requires-a-cloud-gateway-sign-in) も参照してください。 |
| Claude Desktop がブートストラップ設定を取得できないと報告する | `/user/bootstrap` が 404 を返した: ユーザーに一致するポリシーが `desktop` キーを持たないか、ポリシーが一致しなかった。gateway の監査ログは各拒否を `desktop_bootstrap.denied` として理由とともに記録します。 | ユーザーに一致するポリシー、または `match: {}` ベースレイヤーに `desktop` ブロックを追加してください。空の `desktop: {}` で十分です。[Claude Desktop overlay](/docs/ja/claude-apps-gateway-config.md#claude-desktop-overlay) を参照してください。 |
| スタートアップが `Gateway login is configured in managed settings, but this Claude Code build does not include Cloud gateway support.` を表示する | インストールされている Claude Code ビルドが gateway サポート前のバージョン | 開発者に Claude Code を Cloud gateway サポートを含むリリースに更新させてください |
| スタートアップが `Administrator policy requires a Cloud gateway sign-in on this machine` で終了する | 開発者の環境が `ANTHROPIC_API_KEY` または `ANTHROPIC_AUTH_TOKEN` を設定しているか、設定が [`apiKeyHelper`](/docs/ja/settings-reference#apikeyhelper) を設定しているか、または以前の Claude Console ログインからの API キーがまだ保存されている | 適用される各項目をクリアするよう開発者に指示してください: 変数を設定解除するか、`apiKeyHelper` エントリを削除するか、`claude auth logout` を実行して保存されたキーを削除してください。`CLAUDE_CODE_USE_*` でクラウドプロバイダーを選択するセッションはサインインなしで開始されます。その他のすべてのセッションについては、開発者に `claude` を起動して `/login` でサインインさせてください。[Administrator policy requires a Cloud gateway sign-in](/docs/ja/errors.md#administrator-policy-requires-a-cloud-gateway-sign-in) も参照してください。 |
| スタートアップまたは `/login` が管理設定ロード時の 403 の後に `Claude Code may not be enabled for your organization` を報告する | gateway、またはその前にあるもの、が `/managed/settings` リクエストに 403 で応答した。gateway 自体の設定ルートは 403 で応答することはありません。ステータスは [`access_control`](/docs/ja/claude-apps-gateway-config#http-tuning) IP チェック、または gateway の前にあるプロキシまたは WAF から来ています。監査ログは IP チェック拒否を `access.denied` として理由とともに記録します。開発者はサインイン状態を保ちます。 | 失敗時の監査ログで `access.denied` を確認し、`access_control` リストまたはフロントエンドを修正してから、開発者に `claude` を再度起動させてください |
| CLI `/login`: `The gateway is limiting sign-in attempts right now`、または古いバージョンで `Request failed with status code 429`。`/device` ページは以前に試したことのない開発者に `Too many attempts` を表示する場合があります | IP ごとのサインインレート制限に達した。`listen.trusted_proxies` がロードバランサーをカバーしていないため、すべての開発者がそのアドレスを共有するか、多くの開発者が NAT または VPN 出口アドレスを共有しています。`result: rate_limited` の監査イベントは同じ 1 つまたは少数の `client_ip` 値を表示します。 | まず `listen.trusted_proxies` をロードバランサーのソース範囲に設定し、開発者がアドレスを共有し続ける場合は `rate_limits` を上げてください。[大規模なロールアウト](#large-rollouts)を参照してください。 |
| CLI `/login`: `Gateway hosts must be on your organization's private network; <host> resolves to the public (or unrecognized) address <ip>` | gateway ホスト名が少なくとも 1 つのパブリック IP アドレスに解決される。Claude Code は各解決されたアドレスをチェックし、すべてがプライベートであることを要求します。一般的な原因は、1 つのファミリーがパブリックアドレスに解決されるデュアルスタック名です。AWS 内部デュアルスタックロードバランサーを含み、パブリック範囲の AAAA アドレスを返します。 | gateway 名が開発者マシン上でプライベートアドレスのみに解決されるようにしてください。デュアルスタック名の場合、パブリック範囲のレコードを削除するか、別の内部専用 DNS 名を提供してください。[プライベートネットワークの前提条件](/docs/ja/claude-apps-gateway#prerequisites)を参照してください。アドレスが組織で所有して内部的に使用するパブリックスペースである場合、代わりに[そのブロックを宣言](/docs/ja/claude-apps-gateway#allow-a-gateway-on-public-address-space-you-own)してください。 |
| CLI `/login`: `Gateway login would go through proxy <proxy>, which is not on a private network` | `HTTPS_PROXY` または `HTTP_PROXY` が gateway ホストに適用され、プロキシのホスト名がパブリックアドレスに解決される。ホストがプライベートアドレスのみに解決されるプロキシは許可され、このエラーをトリガーしません | 開発者のマシンの `NO_PROXY` に gateway ホストを追加して接続を直接にするか、ホスト名がプライベートアドレスに解決されるプロキシを使用してください。メッセージには追加すべき正確な `NO_PROXY` エントリが示されます |
| CLI `/login`: `Claude Code only signs in to <host> from inside its declared network <block> (managed settings), and this machine is connecting from <ip>, outside it` | gateway は [`gatewayInternalNetworks`](/docs/ja/claude-apps-gateway#allow-a-gateway-on-public-address-space-you-own) で宣言されたブロック上にあり、開発者のマシンがそのブロック外のアドレスからそれに到達した: VPN アドレスプール、コンテナまたは WSL2 NAT セグメント、または自組織のものではないネットワーク | 開発者に自組織のネットワーク上のホスト OS から `/login` を実行させてください。表示されたアドレスも自組織のパブリックスペースである場合、gateway のエントリを両方をカバーするブロック（最大 `/8`）に置き換えてください。2 番目の重複するエントリは拒否されます。両方をカバーするブロックがない場合は、[gateway のアドレスを選択する](#choose-an-address-for-the-gateway)を参照してください |
| CLI `/login`: `Every address for gateway host <host> must be inside its declared network <block>, and it also resolves to <ip>` | gateway の名前が [`gatewayInternalNetworks`](/docs/ja/claude-apps-gateway#allow-a-gateway-on-public-address-space-you-own) で宣言されたブロック外のアドレスに解決される: 2 番目のサイト、またはデュアルスタック名上の IPv6 レコード。宣言されたブロックの下では、プライベートおよび IPv6 アドレスを含め、すべてのレコードがその 1 つの IPv4 ブロック内にある必要があります | 開発者マシン上の gateway 名に対してブロック内のレコードのみを公開するか、別の内部専用名を提供してください |
| CLI `/login`: `<host> is on the declared network <block>, which Claude Code checks over a direct connection, not through an HTTP proxy` | `HTTPS_PROXY` または `HTTP_PROXY` が宣言されたブロック上の gateway に適用される | 開発者のマシンで、メッセージに示された `NO_PROXY` エントリを追加してください |
| CLI `/login`: `gatewayInternalNetworks in managed settings` で始まるメッセージ | 値が[検証ルール](/docs/ja/claude-apps-gateway#allow-a-gateway-on-public-address-space-you-own)の 1 つに違反しており、メッセージにどのルールかが示されます。修正するまで、Claude Code はプライベートアドレス上の gateway を含め、マシン上のすべての新しい gateway `/login` を拒否します。既存のサインインは機能し続けます | デプロイする管理設定ソースで、メッセージに示されたエントリを修正してから、`/login` を再実行してください |
| CLI `/login`: `Could not resolve the configured HTTP proxy` | `HTTPS_PROXY` または `HTTP_PROXY` のホスト名が開発者のマシンから解決されない。通常、企業ネットワークに接続されていないため | 開発者にネットワークまたは VPN に接続させて再試行するか、プロキシ URL を修正してください |
| CLI `/login`: `Could not resolve gateway host <host>` | マシンが gateway の内部 DNS 名を解決できない。通常、企業ネットワーク上にないため | 開発者にネットワークまたは VPN に接続させてから、`/login` を再試行してください |
| ブート時に `store.postgres_url` という名前の設定検証エラーで終了する | Postgres が設定されていない。gateway は Postgres を必要とします | `store.postgres_url` を設定してください。ローカル開発の場合、使い捨てコンテナを使用してください: `docker run --rm -p 5432:5432 -e POSTGRES_HOST_AUTH_METHOD=trust postgres`。 |
| ブート時に終了: `store.postgres_url in <path> is not a URL the gateway can read`、または v2.1.290 より前では単に `Invalid URL` または `URI error` | URL を解析できない。例えば、複数のホストが列挙されている、またはパスワードにエンコードされていない `/`、`?`、`#`、`%` が含まれている | [ホストを 1 つ](#postgres)指定し、パスワードを [`store.password`](/docs/ja/claude-apps-gateway-config#store) に移動してください |
| ブート時に終了: `requires the native binary` | ネイティブバイナリではなく Node で実行されている | Claude Code を[スタンドアロンインストール方法](/docs/ja/setup.md)のいずれかでインストールしてください |
| ブート時に `config.load` の後に OIDC ディスカバリーエラーで終了する | `oidc.issuer` に到達できない、または TLS チェーンが信頼されていない | 発行者がポッドから到達可能で、`/.well-known/openid-configuration` を提供していることを確認してください。プライベート PKI の場合は `ca_cert_pem` を設定してください。ポッドが IdP にフォワードプロキシ経由でのみ到達する場合、[`oidc.use_proxy: true`](/docs/ja/claude-apps-gateway-config#idp-requests-through-a-forward-proxy)を設定してください。v2.1.227 より前のバージョンでは、代わりに IdP の各エンドポイントへの直接ルートをポッドに提供してください。ポッドが IdP のホスト名を解決できない場合、またはプロキシが IP アドレスへの `CONNECT` を拒否する場合、[プロキシのみの出口](/docs/ja/claude-apps-gateway-config.md#proxy-only-egress)を参照してください。これには v2.1.277 以降が必要です。 |
| ブート時に Postgres 権限エラーで終了する | データベースロールがそのスキーマに対する DDL 権限を持たない | ロールに gateway のスキーマに対する `CREATE` を付与して、ブート時にテーブルを作成・変更できるようにしてください |
| ログ: PostgreSQL からの `remaining connection slots are reserved` または `sorry, too many clients already`。実行中のレプリカの `postgres connection closed` 警告、または新しいレプリカのブートログに表示されます。ブートログでは、`remaining connection slots are reserved` が `attempt 1 of 3` の後に続くことがあり、それでもレプリカが起動する場合があります。 | レプリカが、データベースがゲートウェイ用に残している接続数よりも多くの接続を要求しており、PostgreSQL が余分な接続を拒否している | [接続プールのサイズを決める](#size-the-connection-pool)で説明しているように、合計が収まるようにしてください: レプリカ数を減らす、`store.max_connections` を下げる、またはデータベースの `max_connections` を上げる。ローリングアップデート中を除けば合計が収まる場合は、オーケストレーターがサポートしていれば、新しいレプリカを起動する前に古いレプリカを停止させる方法もあります。 |
| ログ: `could not connect to Postgres at boot, attempt 1 of 3`（理由が `remaining connection slots are reserved` 以外のもの） | gateway が起動したときにデータベースがまだ到達可能ではなかった。例えば、ネットワークがまだ起動中のコールドインスタンス | その後 gateway がブートを完了する場合、アクションは不要です。データベースに到達できない場合、gateway は終了する前に 2 秒間隔で接続を 3 回試行します。`could not connect to Postgres` で終了する場合、`store.postgres_url`（ホストを 1 つだけ指定していることを含む）とデータベースへのネットワークパスを確認してください。試行が拒否されるのではなくタイムアウトする場合、[`store.connect_timeout_seconds`](/docs/ja/claude-apps-gateway-config#store)を上げて各試行に長い時間を与えてください。 |
| ログ: `Postgres <version> is below the supported floor` | データベースが、使用しているゲートウェイのバージョンがサポートするよりも古い PostgreSQL バージョンで動作している。ゲートウェイは動作を続けます。 | データベースをアップグレードしてください。PostgreSQL 11、12、13 の場合は、代わりにゲートウェイをアップグレードして [PostgreSQL の要件](/docs/ja/claude-apps-gateway#prerequisites)を満たすこともできます。 |
| `/oauth/callback` が「Sign-in could not be completed」を表示する | メールドメインが拒否された、id\_token 検証が失敗した、または `email_verified` が明示的に `false` である。gateway は上書きの手段なしで常にこれを拒否します | `allowed_email_domains` を確認し、IdP が検証済みの `email` クレームを返していることを確認してください。`email_verified: false` の場合、IdP 側の検証を修正してください。IdP がメールを別のクレーム名で発行する場合、`oidc.email_claim` を設定してください。 |
| ログ: `token exchange failed request_id=<id>: id_token missing email claim` | IdP がデフォルトで id\_token に `email` を含めていない。この拒否は `allowed_email_domains` が設定されている場合にのみ発火します。設定されていない場合、メールがないとメールなしのセッションが作成されます | IdP を設定して id\_token に `email` を発行させてください。Okta: カスタム認可サーバーの ID トークンクレームに `email` を追加してください。Entra: アプリ登録でオプションクレームとして `email` を追加してください。PingFederate: `email` を発行する OpenID Connect ポリシーを有効にしてください。IdP が userinfo エンドポイントから `email` を提供するが id\_token に含めない場合（Okta org 認可サーバーなど）、`oidc.userinfo_fallback: true` を設定してください。 |
| ログ: `refresh failed request_id=<id>: invalid_token (…) (at userinfo_no_id_token, …)`、および開発者が `Cloud gateway session expired` を `session.ttl_hours` ごとに見る | IdP がリフレッシュトークンを受け入れたが、それで id\_token を返さなかったため、gateway は IdP の userinfo エンドポイントにユーザーのクレームを求めました。IdP はそこでリフレッシュされたアクセストークンを拒否しました。gateway は `temporarily_unavailable` で応答するため、Claude Code はリフレッシュトークンを保持しますがセッションを更新できません。v2.1.260 より前の gateway バージョンは `(at …)` の詳細なしで同じ行をログに記録します。 | [`oidc.scope_on_refresh: true`](/docs/ja/claude-apps-gateway-config#oidc)を設定してください。gateway v2.1.260 以降で利用可能です。リフレッシュリクエストが再び `openid` を要求するようにします。Okta などの一部の IdP は、要求された場合にのみリフレッシュ時に id\_token を返します。PingFederate では、代わりに **Applications > OAuth > OpenID Connect Policy Management** の下で **Return ID Token On Refresh Grant** を有効にしてください。キーは PingFederate の動作を変更しません。それでも省略する他の IdP の場合、userinfo エンドポイントがリフレッシュによって発行されたアクセストークンを受け入れるかどうかを確認してください。一時的な対応として、[`session.ttl_hours`](/docs/ja/claude-apps-gateway-config#session)を上げてください。[Identity provider setup](#identity-provider-setup) でプロビジョニング解除のトレードオフを参照してください。 |
| 開発者がサインインした後、そのセッションからのすべてのリクエストが `431` エラーで失敗する | すべてのリクエストの `Authorization` ヘッダーにあるセッショントークンには開発者の IdP グループが列挙されるため、多数のグループに所属する開発者では、ヘッダーの合計が gateway の受け入れ上限を超えることがある | どの制限が適用されるか、および何を変更すべきかについては、[サインイン後にリクエストヘッダーが大きすぎる](#request-headers-too-large-after-sign-in)を参照してください |
| すべての Amazon Bedrock リクエストが 502 を返す。ログに `Could not load credentials from any providers` が表示される | EC2 では、IMDSv2 のデフォルトホップリミット 1 がコンテナ内からのインスタンスメタデータリクエストをブロックします。ブートと `/readyz` は AWS SDK がクライアント構築時ではなく最初のリクエストでインスタンス認証情報を解決するため、とにかく成功します | `aws ec2 modify-instance-metadata-options --instance-id <id> --http-put-response-hop-limit 2` でホップリミットを上げるか、起動テンプレートで設定してください。変更はインスタンス上のすべてのコンテナに適用されます。利用可能な場合は ECS タスクロールを優先してください。これは ECS コンテナ認証情報エンドポイントから認証情報を読み込み、変更を完全に回避します。または、変更を専用 gateway インスタンスに適用して露出を制限してください。 |
| ピークロード時に、レスポンスの開始が遅い、またはハングしているように見える、または upstream が健全な場合に 502 `all upstreams failed` で失敗する | レプリカは upstream に一度に送信するよりも多くのリクエストを開いているため、余分なリクエストは gateway 内で待機します。`provider: anthropic` upstream では、`timeouts.upstream_ttfb_ms` より長く待つリクエストはその upstream をあきらめ、後の upstream がそれを処理しない場合は 502 を生成します。ログは `client requests are open` を含む警告を表示します。 | レプリカを追加するか、各レプリカの制限を上げてください。[同時 upstream リクエスト](#concurrent-upstream-requests)を参照してください。 |
| `provider: anthropic` 以外のアップストリームで、長い思考の間を含むターンが失敗する。ゲートウェイの前にあるプロキシが、約 12.5 分間開いたままのリクエストを 1 件記録し、その後 `504` エラーを連続して記録する | Claude Code は、最初のレスポンスイベントを配信した後はキープアライブの ping のみを運んでいたストリームを終了しました。リクエストをストリーミングなしで再送信しましたが、各応答にはプロキシのタイムアウトより長い時間がかかります。 | 開発者向けに `CLAUDE_STREAM_IDLE_TIMEOUT_MS` を上げてください。[長い思考がプロキシのタイムアウトで終わる](#long-thinking-ends-in-proxy-timeouts)を参照してください。 |
| `provider: anthropic` で、長い思考の間を含むターンが失敗する。プロキシが約 20 分間開いたままのリクエストを 1 件記録し、その後 `502` または `504` エラーを記録する | Claude Code は、最初のレスポンスイベントを配信した後はキープアライブの ping のみを運んでいたストリームを終了しました。リクエストをストリーミングなしで再送信しましたが、各応答には、ゲートウェイがアップストリームを待つ時間である `timeouts.upstream_ttfb_ms`、またはプロキシのタイムアウトより長い時間がかかります。 | 開発者向けに `CLAUDE_STREAM_IDLE_TIMEOUT_MS` を上げてください。[Anthropic API アップストリームでの長い思考](#long-thinking-on-an-anthropic-api-upstream)を参照してください。 |
| IdP エラー: unknown or unsupported scope | IdP が認識しないスコープを拒否する | `oidc.scopes` を IdP が受け入れるリストに正確に設定してください。`openid` を含める必要があります。デフォルトは `openid profile email offline_access` です。 |
| `oidc.scopes` を設定した後、セッションが自動的に更新されない | `offline_access` が上書き設定から削除された | IdP がサポートしている場合は `offline_access` を戻してください。リフレッシュトークンがない場合、開発者は `session.ttl_hours` ごとにブラウザログインを再実行します。 |
| ブラウザが「This request came from another site and was blocked」を表示する | クロスサイトフォーム POST。CSRF 保護としてブロックされました。埋め込みまたはプロキシされたページでは予想されます | 検証リンクを直接開いてください |
| Chrome が「Refused to send form data … violates … Content Security Policy directive: form-action」で Approve ボタンをブロックするが、同じページが Safari または Firefox で機能する | Chrome はリダイレクトチェーン全体に対して `form-action` を適用します。IdP が許可リストに登録されていない 2 番目のホストにさらにリダイレクトします。 | リダイレクトチェーン内の各追加オリジンを `oidc.form_action_origins` に追加してください。Approve ページで Chrome DevTools → Console を開いて、どのオリジンがブロックされたかを確認してください。 |
| サインインが IdP で完了するがコールバックが失敗する。Chrome で CSP エラーまたは Safari で「this sign-in link has expired」が表示される | IdP が `response_mode=form_post` 経由でコードを返しました。これは POST 経由で `/oauth/callback` にクロスオリジンで自動送信します。Chrome はこれを厳密な CSP の下でブロックします。Safari は送信を許可しますがコールバックはクエリ文字列のみを読み込みます。 | IdP が `response_mode=query` を尊重していることを確認してください。gateway はコールバックがプレーンリダイレクトになるように明示的にこれをリクエストします |
| ログインはローカルで機能するが ALB の背後では失敗する | `public_url` がまだローカルまたは内部の `http://` オリジンを指しているため、IdP は間違った `redirect_uri` を取得します | `listen.public_url` を外部の `https://` オリジンに設定し、`<public_url>/oauth/callback` を IdP に登録してください |
| 開発者が信頼プロンプトを繰り返し見る | TLS 証明書がレプリカごと、またはリクエストごとにローテーションしている | イングレスで安定した証明書を使用するか、TLS を 1 回終了して、レプリカをプレーン HTTP で内部的に実行してください |
| CLI `/login`: 「Could not verify the gateway's TLS certificate」または `SELF_SIGNED_CERT_IN_CHAIN` | Gateway の TLS チェーンが CLI ホストの信頼ストアにないプライベート CA によって署名されている | Claude Code はネイティブバイナリ上および Node 22.15 以降でデフォルトで OS 信頼ストアを読み込みます。[`CLAUDE_CODE_CERT_STORE`](/docs/ja/network-config#ca-certificate-store) がこの動作を制御します。CA が OS 信頼ストアにインストールされている場合、開発者が現在のランタイムを使用していることを確認してください。そうでない場合、起動前に `NODE_EXTRA_CA_CERTS` を CA 証明書 PEM に設定してください。最初の接続フィンガープリントプロンプトは引き続き適用されます。 |
| CLI `/login` がブラウザサインインを完了してから、セッションが `Cloud gateway sign-in was not completed` と TLS 証明書の不一致で終了する | サインイン後の最初のリクエストで、gateway は Claude Code がピンしたフィンガープリントと一致しない証明書を提示したため、Claude Code は gateway 認証情報を保持しませんでした。通常の原因は、1 つのアドレスの背後にあるレプリカが異なる証明書を提供するか、ネットワークパス上の何かが TLS をインターセプトしています。 | ホスト名に対して 1 つの証明書を提供してください。例えば、イングレスで TLS を 1 回終了してから、開発者に `/login` を再度実行させてください。その証明書がピンされたものと異なる場合、Claude Code は証明書が変更されたという警告とともに[信頼プロンプト](/docs/ja/claude-apps-gateway#connect-developers)を再度表示します。 |
| CLI `/login` が `The gateway's TLS certificate changed during sign-in: it no longer matches the one you trusted` で停止する | サインインリクエストが、開発者が `/login` を開始したときに受け入れた証明書と一致しない証明書を提供するサーバーに到達しました: 1 つのアドレスの背後にあるレプリカが異なる証明書を提供する、パス上の TLS インターセプション、またはサインイン中の証明書ローテーション。 | ホスト名に対して 1 つの証明書を提供してから、開発者にサインインを再度開始させ、[信頼プロンプト](/docs/ja/claude-apps-gateway#connect-developers)で新しい証明書を確認させてください。 |

`Cloud gateway sign-in was not completed` メッセージには gateway ホスト名が示されます。Claude Code がピンされたフィンガープリントと提示されたフィンガープリントの両方を持つ場合、メッセージにはそれぞれの最初の 16 文字も表示されます。

Claude Code がゲートウェイサインイン後に `couldn't load your organization's managed settings` を報告する場合、Claude Code は理由を示し、その場で再起動して、会話を再開します。Claude Code が再起動できない場合（例えば、バックグラウンドセッション）、Claude Code はセッションを終了し、サインインを保持します。

### サインイン後にリクエストヘッダーが大きすぎる

開発者が多数の IdP グループに所属している場合、サインイン後に開発者のリクエストが `431` エラーで失敗することがあります。

gateway は、リクエストのヘッダーの合計が 256 KiB（[`limits.max_request_header_bytes`](/docs/ja/claude-apps-gateway-config#http-tuning) を設定している場合はその値）を超えると `431` で応答します。これらのリクエストについては、ログ行も監査イベントも書き込みません。v2.1.284 より前の gateway バージョンは、16 KiB を超えると `431` で応答します。

以下のうち、gateway に該当する最初の項目から対応してください。

* **v2.1.284 より古い gateway**: gateway をアップグレードしてください
* **`limits.max_request_header_bytes` が設定されている**: 値を上げるか、キーを削除してください
* **いずれにも該当しない、またはその後も `431` が続く**: IdP が発行するグループを減らしてください。Okta、Microsoft Entra ID、Google Workspace がグループを提供する方法については、[Identity provider setup](#identity-provider-setup) を参照してください

groups クレームを削減する際は、以下の設定で指定したグループを残してください。これらの設定は、開発者のアクセス、ポリシー、支出上限を決定します。

* **[`oidc.allowed_groups`](/docs/ja/claude-apps-gateway-config#oidc)**: サインインできるユーザーを決定します
* **[`admin.admin_groups`](/docs/ja/claude-apps-gateway-config#admin)**: gateway セッションで管理 API を呼び出せるユーザーを決定します
* **[`managed.policies`](/docs/ja/claude-apps-gateway-config#managed) 内の `match.groups`**: 開発者に適用されるポリシーを決定します
* **`rbac_group` [支出上限](/docs/ja/claude-apps-gateway-spend-limits.md)**: 開発者に適用されるグループ上限を決定します

### 長い思考がプロキシのタイムアウトで終わる

アップストリームが `provider: anthropic` の場合は、代わりに [Anthropic API アップストリームでの長い思考](#long-thinking-on-an-anthropic-api-upstream)を参照してください。そちらでも `CLAUDE_STREAM_IDLE_TIMEOUT_MS` を上げますが、時間とエラーが異なります。

長い思考の後にターンが失敗し、プロキシが約 12.5 分間開いたままのリクエストを 1 件記録し、その後 `504` エラーを連続して記録する場合は、ゲートウェイのポリシーで [`CLAUDE_STREAM_IDLE_TIMEOUT_MS`](/docs/ja/env-vars) を上げてください。例えば、プロキシのアイドルタイムアウトが 240 秒の場合、連続するのは 10 件のリクエストで、それぞれが 240 秒で切断されます。

* **最初のリクエスト**: 最初のレスポンスイベントである `message_start` を配信した後、Claude が思考している間は ping のみを運ぶストリームです。デフォルト設定では、Claude Code は約 12.5 分後にこのストリームを終了します。
* **残りの 10 件**: 同じリクエストを[ストリーミングなしで](/docs/ja/errors.md#streaming-response-ended-before-any-complete-data-was-received)送信し、その後再試行したもので、デフォルトでは合計 10 回送信されます。これらには ping が届かないため、応答が遅いとプロキシのタイムアウトに達します。

この修正のためにプロキシのタイムアウトを延ばす必要はありません。プロキシのタイムアウトだけを上げた場合、ストリーミングなしのリクエストは、応答が Claude Code 自身の待機時間（デフォルトでは 300 秒）より長くかかった時点で依然として失敗します。

#### 原因を確認する

開発者に `claude --debug-file ./claude-debug.txt` で失敗を再現してもらい、そのファイルで次の行を検索してください。

```text theme={null}
Error streaming, falling back to non-streaming mode: Stream idle timeout - no chunks received
```

開発者がすでに [`CLAUDE_CODE_DISABLE_NONSTREAMING_FALLBACK`](/docs/ja/env-vars) を `1` に設定している場合、ストリーミングなしのリクエストは発生せず、ターンは `API Error: Stream idle timeout - no chunks received` で終了します。同じ修正が適用されます。

#### 値を選ぶ

2 列目が最も長い思考の間をカバーする `CLAUDE_STREAM_IDLE_TIMEOUT_MS` の値を選んでください。それがわからない場合は `1800000` から始めてください。ストリームは、この値より約 7.5 分長く ping のみで維持できます。

| `CLAUDE_STREAM_IDLE_TIMEOUT_MS` | ストリームが ping のみで維持できる時間 |
| - | - |
| `300000`（デフォルト） | 約 12.5 分 |
| `900000` | 約 22.5 分 |
| `1800000` | 約 37.5 分 |

ゲートウェイが ping を送り続けている間にアップストリームがハングした場合、開発者も Claude Code がストリームを諦めるまでそれだけの時間待つことになります。完全に無音になった接続は、[ボディのアイドルタイムアウト](/docs/ja/network-config.md#streaming-idle-watchdogs)がこの変数に従わないため、引き続き 5〜6 分後に終了します。

#### ポリシーで値を配信する

対象とする開発者にすでに Claude Code の設定を配信している `gateway.yaml` 内の各ポリシーに、`env` エントリを追加してください。そのポリシーにすでにある `code`、`cli`、または `settings` キーの下に配置します。まず値を試すには、1 つのグループに一致するポリシーから始めてください。ポリシーの一致と継承の仕組みについては、[`managed`](/docs/ja/claude-apps-gateway-config#managed) を参照してください。この例では、`cli` をキーとする `match: {}` ポリシーにエントリを追加します。

```yaml theme={null}
managed:
  policies:
    - match: {}
      cli:
        env:
          CLAUDE_STREAM_IDLE_TIMEOUT_MS: "1800000"
```

`cli` キーを使うと、ターミナル、IDE 拡張機能、Agent SDK のセッションが対象になります。Claude Desktop の Code タブについては、[`cli` または `code` を選ぶ](/docs/ja/claude-apps-gateway-config#choose-cli-or-code)を参照してください。

編集したファイルを読み込むようにゲートウェイを再起動してください。その後、開発者に Claude Code を再起動してもらい、`CLAUDE_STREAM_IDLE_TIMEOUT_MS` を取得させてください。

### Anthropic API アップストリームでの長い思考

`provider: anthropic` がモデルの唯一のアップストリームで、プロキシが約 20 分間開いたままのリクエストを 1 件記録し、その後 `502` または `504` エラーを記録する場合は、ゲートウェイのポリシーで [`CLAUDE_STREAM_IDLE_TIMEOUT_MS`](/docs/ja/env-vars) を上げてください。

* **長いリクエスト**: `message_start` を配信した後、Claude が思考している間は ping のみを運ぶストリームです。Claude Code はデフォルト設定では約 20 分後にこれを終了し、変数を上げるとそれより後に終了します。
* **エラー**: その後 Claude Code が[ストリーミングなしで](/docs/ja/errors.md#streaming-response-ended-before-any-complete-data-was-received)送信するリクエストです。それぞれがゲートウェイからの `502` で失敗するか、プロキシのタイムアウトがゲートウェイの待機時間より短い場合はプロキシの `504` で失敗します。その待機時間は [`timeouts.upstream_ttfb_ms`](/docs/ja/claude-apps-gateway-config#http-tuning) ですが、この修正のために上げる必要はありません。

原因を確認するには、[原因を確認する](#confirm-the-cause)を参照してください。

最も長い思考の間をカバーする時間の値を選んでください: デフォルトでは約 20 分、`900000` では 30 分、`1800000` では 45 分です。その後、[ポリシーで値を配信する](#deliver-the-value-in-a-policy)の手順に従ってください。

## 関連

* [Claude apps gateway の概要](/docs/ja/claude-apps-gateway)：クイックスタートと開発者接続
* [設定リファレンス](/docs/ja/claude-apps-gateway-config.md)：すべての `gateway.yaml` オプション
