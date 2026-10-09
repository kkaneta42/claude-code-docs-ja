> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# Claude apps gateway 設定

> gateway.yaml のすべてのオプションのリファレンス：リスナーと TLS、OIDC、セッション、Postgres ストア、Amazon Bedrock、Claude Platform on AWS、Google Cloud の Agent Platform、Microsoft Foundry アップストリーム、モデルルーティング、マネージドポリシー、テレメトリー。

Claude apps gateway デプロイメントは、慣例的に `gateway.yaml` という 1 つの YAML ファイルで設定されます。このファイルは、ゲートウェイが行うすべてのことを定義します：どこでリッスンするか、開発者がどのようにサインインするか、推論がどこに行くか、どのポリシーとテレメトリーが適用されるかです。このページは、そのファイル内のすべてのオプションのリファレンスです。最初のファイルを作成するには、[クイックスタート](/docs/ja/claude-apps-gateway#quickstart)から始めてください。これは最小限の動作設定を構築して実行します。設定に満足したら、[デプロイメントガイド](/docs/ja/claude-apps-gateway-deploy)で、Kubernetes、Cloud Run、または独自のプラットフォームでのコンテナ化とホスティングについて説明しています。

ゲートウェイは、`claude gateway --config /path/to/gateway.yaml` でスタートアップ時にファイルを 1 回読み込みます。すべてのオプションはブート時にスキーマに対して検証されるため、形式が正しくない設定は、最初の使用時ではなく、フィールドレベルのエラーで開始時に失敗します。

このページの最後にある[完全な例](#complete-example)は、すべてのセクションを実行します。

<h2 id="file-structure">
  ファイル構造
</h2>

5 つのセクションが[必須](#required-sections)です。その他のセクションはすべて[オプション](#optional-sections)であり、省略されたセクションはデフォルト値を使用します。不明なキーはブート時に失敗するため、タイプミスは設定が無視されるのではなく、名前付きエラーとして表示されます。

**必須セクション：**

* [`listen`](#listen)：バインドアドレス、パブリック URL、TLS ターミネーション
* [`oidc`](#oidc)：ID プロバイダー（IdP）、発行者、クライアント、クレームマッピング、サインイン可能なユーザーを含む
* [`session`](#session)：ゲートウェイが発行するベアラートークン、シークレット、ライフタイム
* [`store`](#store)：デバイスグラント、レート制限カウンター用の PostgreSQL
* [`upstreams`](#upstreams)：推論の送信先、Anthropic、Amazon Bedrock、AWS 上の Claude Platform、Google Cloud の Agent Platform、Microsoft Foundry のいずれか

**オプションセクション：**

* [`admin`](#admin)：Admin API 認証、支出制限の保持
* [`enforcement`](#enforcement)：支出制限のフェイルオープンまたはフェイルクローズ動作
* [`pricing`](#pricing)：契約レート、支出メーター用の乗数、開発者が表示するコスト数値用の乗数
* [`models`](#models) と `auto_include_builtin_models`：管理者がキュレーションしたモデルリスト、アップストリームごとの ID
* [`managed`](#managed)：IdP グループ別の管理設定ポリシー
* [`telemetry`](#telemetry)：オブザーバビリティスタックへの OTLP フォワーディング
* [`access_control`、`limits`、`timeouts`、`rate_limits`](#http-tuning)：IP 許可/拒否、リクエストサイズ上限、アップストリーム初バイト到達時間、IP ごとのサインイン制限
* [`load_test_mode`](#load_test_mode)：モデルプロバイダーを呼び出さずにゲートウェイをロードテストする

<h2 id="secret-expansion">
  シークレット展開
</h2>

`client_secret`、`jwt_secret`、`postgres_url` などのシークレットを `gateway.yaml` に直接書き込まないでください。以下のいずれかの形式で参照すると、ゲートウェイはブート時に環境変数またはファイルから値を解決します：

| 形式 | 解決先 | 用途 |
| - | - | - |
| `${VAR}` | 環境変数 `VAR`。未定義の場合はブート失敗。 | コンテナ環境変数、env インジェクション経由の AWS Secrets Manager |
| `${file:/path}` | そのパスにあるファイルの内容、トリミング済み。参照はフィールド全体の値である必要があります：`${VAR}` とは異なり、より長い文字列内で展開されないため、データベースパスワードの場合は `postgres_url` に埋め込むのではなく `store.password` を設定してください。 | Kubernetes Secret ボリュームマウント、Vault Agent、SOPS |

<h2 id="required-sections">
  必須セクション
</h2>

<h3 id="listen">
  `listen`
</h3>

`listen` ブロックは、ゲートウェイがサービスを提供する場所を制御します。バインドアドレスとポート、外部から見えるオリジン、およびオプションの TLS 終了を指定します。

| フィールド | 必須 | 説明 |
| - | - | - |
| `host` | いいえ | バインドアドレス。デフォルト `0.0.0.0`。 |
| `port` | いいえ | バインドポート。デフォルト `8080`。 |
| `public_url` | `host` がループバックでない場合は必須 | 外部から見える `https://` オリジン。IdP の `redirect_uri` と検出メタデータを構築するために使用されます。`host` がループバックアドレスでない場合は常に必須です。TLS が ALB、Ingress、Cloud Run などのプロキシで終了するか、`tls` を通じてゲートウェイ自体で終了するかに関わらず必須です。ゲートウェイは `X-Forwarded-*` ヘッダーから独自のオリジンを導出することはありません。これらはクライアントがなりすまし可能です。これなしではブート失敗します。以下の `trusted_proxies` はクライアント IP 解決のみを制御します。また、[テレメトリ](#telemetry)を有効にするためにも必須です。ゲートウェイはこの URL からクライアントにプッシュする OTLP エンドポイントを構築するためです。 |
| `tls.cert` / `tls.key` | いいえ | ゲートウェイが TLS を自身で終了する場合の PEM パス |
| `trusted_proxies` | いいえ | ゲートウェイの前にあるロードバランサーの CIDR または IP。設定されている場合、ゲートウェイはこれらのピアからのみ `X-Forwarded-For` を信頼し、IP ごとのレート制限と監査のために実際のクライアント IP を記録します。nginx の `set_real_ip_from` と同等です。`X-Forwarded-For` エントリが `ipv4:port` または `[ipv6]:port` として書かれている場合（一部のロードバランサーがそうするように）、ポートを削除して読み込まれます。ポートが付加されたブラケットなしの IPv6 アドレスは、異なるアドレスとして読み込まれるか、まったく読み込まれない可能性があるため、そのフォームを書き込むプロキシのポートオプションをオフにしてください。 |

<h3 id="oidc">
  `oidc`
</h3>

`oidc` ブロックはゲートウェイをアイデンティティプロバイダーに接続し、誰がサインインできるかを決定します。発行者と OAuth クライアントに名前を付け、メールとグループを含むクレームをマップし、メールドメインまたはグループによるサインインを制限します。

OpenID Connect（OIDC）はゲートウェイがアイデンティティプロバイダーで使用する SSO プロトコルです。IdP 側で登録する内容については、[アイデンティティプロバイダーのセットアップ](/docs/ja/claude-apps-gateway-deploy#identity-provider-setup)を参照してください。

| フィールド | 必須 | 説明 |
| - | - | - |
| `issuer` | はい | OIDC 検出ベース。`/.well-known/openid-configuration` で検出を提供する必要があります。本番環境では HTTPS を使用してください。ゲートウェイは `http://` 発行者を受け入れます。`http://localhost:8081` などのループバック発行者は、[SSRF ガード](/docs/ja/claude-apps-gateway-deploy#threat-model-summary)によって拒否されます。ただし、ゲートウェイの環境で `CLAUDE_GATEWAY_ALLOW_LOOPBACK=1` が設定されている場合を除きます。 |
| `client_id` | はい | OAuth クライアント登録から取得 |
| `client_secret` | `token_endpoint_auth_method` が `private_key_jwt` でない場合は必須 | OAuth クライアント登録から取得。[証明書によるクライアント認証](#certificate-client-authentication)を使用する場合は省略します。 |
| `allowed_email_domains` | いいえ | `email` クレームがこれらのドメインのいずれかに含まれていない id\_token を拒否します。大文字と小文字を区別しません。マルチテナント IdP の設定ミスに対する多層防御です。この設定とは無関係に、`email_verified` クレームが明示的に `false` である id\_token は常に拒否されます。 |
| `allowed_groups` | いいえ | サインインをこれらの IdP グループのメンバーに制限します。`groups_claim` に対してマッチングされます。許可されたメールドメイン内にいるが、これらのグループのいずれにも属していないユーザーは拒否されます。IdP がグループクレームを発行する必要があります。マッチングは、そのクレーム内の値に対する正確で大文字と小文字を区別する文字列比較です。ゲートウェイはネストされたグループを展開しません。サブグループのメンバーを許可するには、ここにサブグループをリストするか、IdP を設定してフラット化されたメンバーシップを発行してください。 |
| `groups_claim` | いいえ | グループメンバーシップを含む id\_token クレーム。デフォルト `groups`。Microsoft Entra はアプリロールを `roles` の下に発行します。フラットキーまたは `/resource_access/gateway/roles` などのネストされたクレーム用の RFC 6901 JSON ポインタを受け入れます。 |
| `google_groups` | いいえ | Google Workspace Admin SDK Directory API を通じてサインインしたユーザーのグループを検索します。Google の id\_token はグループクレームを含まないためです。`service_account_json_path` を `https://www.googleapis.com/auth/admin.directory.group.readonly` スコープでドメイン全体の委任を持つサービスアカウントキーファイルに設定し、`admin_email` をサービスアカウントが偽装する Workspace 管理者に設定します。Directory API は実際の管理者サブジェクトを必要とします。各ユーザーのグループメールアドレスがそのグループクレームになるため、`allowed_groups` と `managed.policies.match.groups` はグループメールでマッチングします。 |
| `email_claim` | いいえ | ユーザーのメールを含む id\_token クレーム。デフォルト `email`。ADFS や Entra B2C などの一部の IdP は、代わりに `upn` または `preferred_username` を発行します。フラットキー、JSON ポインタ、または最初に存在するキーが使用されるフォールバックキーのリストを受け入れます。 |
| `scopes` | いいえ | ゲートウェイが要求する OIDC スコープの完全な上書き。デフォルト `[openid, profile, email, offline_access]`。IdP が認識しないスコープを拒否する場合、またはグループまたはメールを発行するためにカスタムスコープが必要な場合に設定します。`openid` を含める必要があります。`offline_access` を削除するとリフレッシュトークンが無効になるため、開発者は `session.ttl_hours` ごとにブラウザログインを再実行します。IdP ごとのスコープレシピ（Google のリフレッシュトークンフローなど）については、[アイデンティティプロバイダーのセットアップ](/docs/ja/claude-apps-gateway-deploy#identity-provider-setup)を参照してください。 |
| `scope_on_refresh` | いいえ | ゲートウェイがリフレッシュトークンを交換するときに、サインインリクエストと同じリストで `scope` も送信します。デフォルト `false`：リフレッシュリクエストは `scope` を省略します。ほとんどの IdP はリフレッシュのたびに id\_token を返すため、この設定は不要です。IdP が再度 `openid` を要求された場合にのみリフレッシュ時に id\_token を返す場合（Okta はリフレッシュグラントについてこれを文書化しています）は `true` に設定します。id\_token がない場合、すべてのリフレッシュは、IdP の userinfo エンドポイントがリフレッシュされたアクセストークンを受け入れることに依存します。グループに基づいてサインインを制限したりポリシーをマッチングしたりしていて、IdP のリフレッシュ時の id\_token にグループが含まれない場合は、`userinfo_fallback: true` も設定して、ゲートウェイが userinfo エンドポイントからグループを補完するようにしてください。要求より少ないスコープを付与した IdP は、`invalid_scope` でリフレッシュを拒否することがあります。これがオンの間に `scopes` にエントリを追加した場合は、既存のセッションも対象になります。設定後に `token_endpoint` でリフレッシュが失敗し始めた場合は、このキーを削除してください。ゲートウェイサーバーで Claude Code v2.1.260 以降が必要です。 |
| `extra_auth_params` | いいえ | IdP 認可リクエストに逐語的に追加される追加クエリパラメータ。これは、Google リフレッシュトークンの `access_type: offline`、一部の Entra テナントの `domain_hint`、またはステップアップフローの `acr_values` など、IdP 固有の動作を上書きするための仕組みです。ゲートウェイが管理するプロトコルパラメータは上書きできません：`state`、`nonce`、`redirect_uri`、PKCE、`scope`、`response_type`、`response_mode`、および `client_id`。 |
| `userinfo_fallback` | いいえ | id\_token がメールまたはグループを省略する場合、`/userinfo` からそれらを取得します。Keycloak 軽量アクセストークン、Okta org サーバー、および ADFS 最小トークンに必要です。id\_token が引き続き正とされ、userinfo は不足分のみを補完します。デフォルト `false`。 |
| `use_pkce` | いいえ | 認可リクエストで PKCE（S256）チャレンジを送信します。デフォルト `true`。IdP がこの機密クライアントの PKCE を拒否する場合のみ `false` に設定します。 |
| `clock_skew_seconds` | いいえ | id\_token 時間クレームを検証するときにクロックドリフトを許容します。デフォルト `0`（厳密）。サインイン直後にホスト/IdP クロックスキューのため「トークン期限切れ/まだ有効でない」エラーが表示される場合は、これを上げてください。 |
| `token_endpoint_auth_method` | いいえ | ゲートウェイが IdP のトークンエンドポイントに対して認証する方法：`client_secret_basic`、`client_secret_post`、または[証明書によるクライアント認証](#certificate-client-authentication)用の `private_key_jwt`。デフォルトでは、ゲートウェイは IdP が公開している内容から 2 つの `client_secret` 方式のいずれかを選択します。 |
| `client_assertion` | `private_key_jwt` の場合は必須 | `private_key_pem` と `certificate_pem` を含むブロック：[証明書によるクライアント認証](#certificate-client-authentication)用の秘密鍵と証明書。v2.1.284 以降が必要です。 |
| `id_token_signed_response_alg` | いいえ | 予想される id\_token 署名アルゴリズム。デフォルト `RS256`。ES256、PS256、または EdDSA で署名する IdP に設定します。 |
| `additional_authorized_parties` | いいえ | `client_id` を超えて受け入れる追加の `azp` 値。Keycloak ブローカーとトークン交換フロー用 |
| `discovery_url` | いいえ | `issuer` から導出する代わりに、この URL から検出ドキュメントを取得します。発行者ホストを書き換えるプロキシの背後にある IdP の場合。パスは `/.well-known/` を含む必要があります。 |
| `use_proxy` | いいえ | ゲートウェイ独自の IdP リクエストを `HTTPS_PROXY` または `HTTP_PROXY` のフォワードプロキシを通じて送信し、`NO_PROXY` を尊重します。`false` はそれらのリクエストを直接に保ちます。v2.1.227 以降が必要です。以下の[フォワードプロキシを通じた IdP リクエスト](#idp-requests-through-a-forward-proxy)を参照してください。 |
| `form_action_origins` | いいえ | `/device` ページの `Content-Security-Policy: form-action` ディレクティブの追加オリジン。ゲートウェイはすでに `'self'` と検出された `authorization_endpoint` オリジンを許可していますが、Chrome は全リダイレクトチェーンに対して `form-action` を強制します。IdP が Azure AD が ADFS にフェデレーションされている、ハブスポーク Okta、または企業 SSO インターセプターなど、2 番目のホストを通じてリダイレクトする場合、認可リクエストがリダイレクトする可能性があるすべてのオリジンをリストします。 |
| `ca_cert_pem` | いいえ | ファイルへのパスではなく、PEM エンコードされた CA 証明書自体。IdP リクエストのみのシステムトラストストアを置き換えます。マウントされたファイルを読み込むには、`${file:/etc/gateway/idp-ca.pem}` と書きます。企業 PKI の背後にある Keycloak または Dex に使用します。 |

<h4 id="certificate-client-authentication">
  証明書によるクライアント認証
</h4>

Microsoft Entra が証明書の認証情報で行うように、アイデンティティプロバイダーがクライアントシークレットではなく証明書で OAuth クライアントを認証する場合は、`token_endpoint_auth_method: private_key_jwt` を設定します。ゲートウェイサーバーで Claude Code v2.1.284 以降が必要です。

この設定では、ゲートウェイはシークレットを送信しません。開発者がサインインするとき、およびゲートウェイがそのセッションをリフレッシュするたびに、証明書の秘密鍵で署名された短期間有効な JWT を使用して IdP のトークンエンドポイントに対して認証します。JWT は RS256 で署名され、`kid` ではなく `x5t` および `x5t#S256` サムプリントヘッダーによって証明書を識別します。IdP は登録された証明書をサムプリントで検索できる必要があります。

<Steps>
  <Step title="鍵と証明書を作成する">
    PKCS#8 または PKCS#1 PEM 形式の、2048 ビット以上の暗号化されていない RSA 秘密鍵と、それに対応する証明書を作成します。ゲートウェイは、これらの条件を満たさない鍵では起動を拒否します。次の `openssl` コマンドは、そのような鍵と、1 年間有効な自己署名証明書を作成します：

    ```bash theme={null}
    openssl req -x509 -newkey rsa:2048 -nodes -keyout idp-client.key -out idp-client.crt -days 365 -subj "/CN=claude-gateway"
    ```

    これにより、現在のディレクトリに `idp-client.key` と `idp-client.crt` が書き込まれます。両方のファイルを、ゲートウェイが読み取れる場所にコピーまたはマウントします。ステップ 3 の例では `/etc/gateway/` を使用しています。
  </Step>

  <Step title="証明書を IdP にアップロードする">
    秘密鍵ではなく証明書を、IdP 上のゲートウェイのアプリ登録にアップロードします。
  </Step>

  <Step title="鍵と証明書を gateway.yaml に追加する">
    `client_assertion` ブロックで、ゲートウェイに秘密鍵と証明書を渡します。`client_secret` は省略します。`private_key_jwt` と一緒に設定されていると、ゲートウェイは起動を拒否するためです。次の `oidc` ブロックは、証明書を使用してゲートウェイを Microsoft Entra テナントに対して認証します：

    ```yaml theme={null}
    oidc:
      issuer: https://login.microsoftonline.com/<tenant-id>/v2.0
      client_id: <application-id>
      token_endpoint_auth_method: private_key_jwt
      client_assertion:
        private_key_pem: ${file:/etc/gateway/idp-client.key}
        certificate_pem: ${file:/etc/gateway/idp-client.crt}
    ```

    どちらの値もファイルパスではなく PEM の内容であるため、例のように `${file:/path}` でマウントされたファイルを読み込みます。`certificate_pem` がチェーンの残りを含まない単一の PEM 証明書であり、その公開鍵が `private_key_pem` と一致しない限り、ゲートウェイは起動を拒否します。
  </Step>

  <Step title="ゲートウェイを再起動してブートログを確認する">
    ゲートウェイを再起動し、ブートログで次の行を探します：

    ```text theme={null}
    [gateway] 2026-10-01T23:07:40.512Z info oidc: client authentication private_key_jwt; certificate CN=claude-gateway, SHA-1 thumbprint DE92821854EE8BAA1D98C758FAA04AABE80B9F57, expires Oct  1 23:07:31 2027 GMT
    ```

    SHA-1 サムプリントを、アップロードした証明書について IdP が表示するものと比較します。証明書の有効期限が切れている、またはまだ有効でない場合でもゲートウェイは起動しますが、置き換えるまでサインインとリフレッシュが失敗するという警告をログに記録します。IdP が証明書を受け入れることを確認するには、開発者 1 人にゲートウェイを通じてサインインしてもらいます。
  </Step>
</Steps>

<h4 id="rotate-the-client-certificate">
  クライアント証明書のローテーション
</h4>

ゲートウェイは鍵と証明書をブート時に一度だけ読み込むため、ファイルの変更は再起動後にのみ反映されます。IdP が持っていない証明書をトークンリクエストが提示することがないよう、次の順序でローテーションします：

1. 新しい証明書を、古い証明書と並べて IdP にアップロードします。
2. `gateway.yaml` が読み込む鍵と証明書のファイルを置き換えてから、ゲートウェイを再起動します。複数のレプリカを実行している場合は、[ローリング再起動](/docs/ja/claude-apps-gateway-deploy#upgrades)で問題ありません。古い証明書を削除するまで、IdP は両方の証明書を保持しているためです。
3. すべてのレプリカが再起動した後、古い証明書を IdP から削除します。

<h4 id="idp-requests-through-a-forward-proxy">
  フォワードプロキシを通じた IdP リクエスト
</h4>

推論アップストリームはすべてのバージョンで `HTTPS_PROXY` と `HTTP_PROXY` を尊重します。ゲートウェイ独自の IdP、検出、JWKS、トークン、および userinfo へのリクエストは、`oidc.use_proxy: true` を設定しない限り直接です。これには v2.1.227 以降が必要です。プロキシ変数が設定され、`use_proxy` が設定されておらず、発行者が `NO_PROXY` でカバーされていない場合、ゲートウェイはそれらのリクエストを直接に保ち、ブート時に選択するよう求める通知をログに記録します。`use_proxy: false` はそれらを直接に保ち、通知を抑止します。

`use_proxy: true` の場合、ポッドは各 IdP エンドポイントのホスト名を自身で解決し、プロキシに解決された IP アドレスへの `CONNECT` を要求します。プロキシは、発行者だけでなく、検出ドキュメントが名前を付けるすべてのホストの IP アドレスへの `CONNECT` を受け入れる必要があります。`http://` プロキシ URL を使用します。`ca_cert_pem` と [SSRF ガード](/docs/ja/claude-apps-gateway-deploy#threat-model-summary)はプロキシされたパスにも適用されます。

[プロキシのみのエグレス](#proxy-only-egress)はこれらの両方を変更します。アクティブな場合、IdP リクエストは `use_proxy: false` を設定しない限りプロキシに従い、ゲートウェイは最初にそれを解決せずにプロキシに各 IdP ホスト名を渡します。

<h4 id="proxy-only-egress">
  プロキシのみのエグレス
</h4>

ポッドがそのフォワードプロキシを通じてのみ他のホストに到達でき、パブリック DNS 名を自身で解決できない場合、またはプロキシが IP アドレスへの `CONNECT` を拒否する場合は、ゲートウェイの環境で `HTTPS_PROXY` の隣に `CLAUDE_GATEWAY_PROXY_IS_EGRESS_BOUNDARY=1` を設定します。v2.1.277 以降が必要です。これは `gateway.yaml` キーではなく環境変数です。設定ファイルの何もゲートウェイのアドレスチェックを緩和できないようにするためです。

```bash theme={null}
export HTTPS_PROXY=http://proxy.corp.example.com:3128
export NO_PROXY=
export no_proxy=
export CLAUDE_GATEWAY_PROXY_IS_EGRESS_BOUNDARY=1
```

ゲートウェイはプロキシのみのエグレスがアクティブな場合、ブート時に 1 つの `network:` 行をログに記録します。

以下の各行は、`HTTPS_PROXY` が設定されたゲートウェイ上の 1 つのクラスのアウトバウンドリクエストについて、デフォルトの場合とプロキシのみのエグレスがアクティブな場合の動作を示します。

| アウトバウンドリクエスト | デフォルト | プロキシのみのエグレスアクティブ |
| - | - | - |
| `provider: anthropic` アップストリーム、Workload Identity Federation トークン交換、`telemetry.forward_to` エクスポート | ローカルで解決およびチェックされ、その後、プロキシを通じてチェックされた IP アドレスへの `CONNECT`。`NO_PROXY` にリストされたテレメトリコレクターは代わりに直接到達します | ホスト名がプロキシに渡されます |
| IdP 検出、JWKS、トークン、および userinfo | [`oidc.use_proxy: true`](#idp-requests-through-a-forward-proxy) でない限り直接。その場合はチェックされた IP アドレスへの `CONNECT` | ホスト名がプロキシに渡されます。ただし、`oidc.use_proxy: false` は内部 IdP を直接に保ちます |
| Amazon Bedrock、Claude Platform on AWS、Google Cloud の Agent Platform、および Microsoft Foundry アップストリーム。Google グループ検索 | ホスト名がプロキシに渡されます | 変更なし |

プロキシのみのエグレスは、ゲートウェイの環境がこれら 3 つの条件をすべて満たさない限り、オフのままです：

* `HTTPS_PROXY` または `HTTP_PROXY` が設定されています。
* `NO_PROXY` と `no_proxy` は空です。プラットフォームがいずれかをポッドに注入する場合、ゲートウェイコンテナの両方を空の値に設定します。`NO_PROXY` にテレメトリコレクターをリストすると、プロキシのみのエグレスがオフのままです。
* `CLAUDE_GATEWAY_ALLOW_LOOPBACK` がオンになっていません。ポッド独自のループバック上のコレクターまたは IdP は、プロキシのみのエグレスと組み合わせることはできません。ループバックアドレスがプロキシに渡されるとプロキシホスト独自のものになるため、代わりにプロキシが到達できるアドレスをそれらのサービスに与えてください。同じ理由で、ゲートウェイはプロキシのみのエグレスがアクティブな場合、`localhost` スタイルの名前を完全に拒否します。

これらの条件のいずれかが満たされていない場合、ゲートウェイはブート時に警告をログに記録し、それを停止した変数に名前を付け、デフォルトの動作を保ちます。

プロキシのみのエグレスがアクティブになったら、内部コレクターと IP アドレスで設定されたホストを含む、プロキシ内のすべての宛先を許可します。[`oidc.use_proxy: false`](#idp-requests-through-a-forward-proxy) で内部 IdP を直接に保つことは引き続き可能です。

<Warning>
  これをオンにするのは、プロキシの許可リストがゲートウェイ独自のチェック以上に厳密な場合のみです。プロキシは `169.254.169.254` や `metadata.google.internal` などのクラウドメタデータエンドポイント、リンクローカルアドレス、およびプロキシホスト独自のループバックを拒否する必要があります。また、名前だけでなく、名前が解決するアドレスによってそれらを拒否する必要があります。ゲートウェイはもはやそれらのいずれかに解決するホスト名をキャッチしないためです。要求された場所にどこでも接続するプロキシは、これらのリクエストに対するゲートウェイの [SSRF ガード](/docs/ja/claude-apps-gateway-deploy#threat-model-summary)を無効にします。
</Warning>

<h3 id="session">
  `session`
</h3>

`session` ブロックは、ゲートウェイがサインイン後に発行するベアラートークンを定義します。トークンに署名するシークレットと、その有効期間です。

| フィールド | 必須 | 説明 |
| - | - | - |
| `jwt_secret` | はい | 少なくとも 32 バイトのエントロピー。例えば `openssl rand -base64 32` から。ゲートウェイの HS256 ベアラートークンに署名します。単一の文字列またはローテーション用の配列を受け入れます。インデックス 0 が署名し、すべてのエントリが検証します。ローテーションするには、新しいシークレットを先頭に追加し、`ttl_hours` を待ってから古いものを削除します。 |
| `ttl_hours` | いいえ | ゲートウェイベアラートークンの有効期間。デフォルト `1`。IdP がリフレッシュトークンを発行する場合、CLI は有効期限前に自動的にリフレッシュします。有効期間が短いほど、より速くプロビジョニング解除されます。長いほど、IdP ラウンドトリップが少なくなります。IdP が `offline_access` が利用できないためリフレッシュトークンを発行できない場合、サイレントリフレッシュはないため、これを `8` または `12` に上げて、開発者を 1 時間ごとにブラウザログインに戻すのを避けてください。 |

<h3 id="store">
  `store`
</h3>

`store` ブロックはゲートウェイを PostgreSQL データベースに向けます。このデータベースはデバイスグラントとレート制限カウンターを保持します。

| フィールド | 必須 | 説明 |
| - | - | - |
| `postgres_url` | はい | `postgres://` または `postgresql://` URL。カンマ区切りのリストではなく、ホストを 1 つだけ指定します。ゲートウェイはブート時およびアップグレード時に独自のスキーママイグレーションを実行するため、ロールはターゲットスキーマでテーブルを作成および変更する権限が必要です。[アップグレード](/docs/ja/claude-apps-gateway-deploy#upgrades)および [Postgres](/docs/ja/claude-apps-gateway-deploy#postgres) を参照してください。 |
| `username` | いいえ | `postgres_url` のユーザーを上書きします |
| `password` | いいえ | データベース認証情報。`postgres_url` ではなくここに設定して、認証情報を URL から外します。任意の文字を受け入れ、URL 認証情報よりも優先されます。 |
| `max_connections` | いいえ | レプリカあたりの Postgres 接続プールサイズ。デフォルト `5`。保守的で共有データベースに優しいです。[支出制限](#admin)が有効な場合、ホットパスは推論リクエストごとに数回の操作を実行するため、専用データベースが負荷の下にある場合はこれを上げ、レプリカ数 × この値をデータベースの `max_connections` 以下に保ちます。 |
| `connect_timeout_seconds` | いいえ | ゲートウェイが Postgres 接続を開くときに待機する秒数。`1` から `60` の整数。デフォルト `5`。新しいゲートウェイインスタンスが起動するときに接続試行がタイムアウトする場合は、これを上げてください。ゲートウェイサーバーで Claude Code v2.1.274 以降が必要です。以前のバージョンはキーが設定されている場合、起動を拒否します。 |
| `readiness_grace_seconds` | いいえ | Postgres が応答を停止した後、`/readyz` が準備完了を報告し続ける秒数。`0` から `3600` の整数。デフォルト `0`。値を選択する方法については、[停止動作](/docs/ja/claude-apps-gateway-deploy#outage-behavior)を参照してください。ゲートウェイサーバーで Claude Code v2.1.282 以降が必要です。以前のバージョンはキーが設定されている場合、起動を拒否します。 |

ローカル開発の場合、`postgres_url` を使い捨て Postgres コンテナに向けます。例えば `docker run --rm -p 5432:5432 -e POSTGRES_HOST_AUTH_METHOD=trust postgres`。

<h3 id="upstreams">
  `upstreams`
</h3>

`upstreams` は順序付きリストです。ゲートウェイは、要求されたモデルを解決する最初のアップストリームに推論を転送します。

`5xx`、`429`、`401`、`403`、`404`、またはタイムアウト時に、ゲートウェイは次のアップストリームにフェイルオーバーします。他の `4xx` ではフェイルオーバーしません。これらのエラーはアップストリームではなくリクエストに起因するためです。`401` または `403` は、ゲートウェイが使用した認証情報をアップストリームが拒否したか、例えば要求されたモデルへのアクセスを拒否したことを意味します。`404` はそのアップストリームが要求されたモデルを提供しないことを意味するため、リスト内の後のアップストリームがまだ提供できます。

アップストリームで `forward_user_identity: true` を設定する場合、開発者のメールを含むリクエストに対してそのアップストリームが返す `429` はフェイルオーバーしません。[ユーザーごとの制限による拒否が開発者にどう届くか](#per-user-identity-headers-for-a-proxy-you-run)を参照してください。

`404` でのフェイルオーバーにはゲートウェイ v2.1.198 以降が必要です。以前のリリースは、リスト内の後のアップストリームがモデルを提供している場合でも、最初の `404` をクライアントに返しました。

同じプロバイダーの複数のアップストリームは、異なる `name:` を設定する必要があります。

Amazon Bedrock、Claude Platform on AWS、Google Cloud の Agent Platform、および Microsoft Foundry クライアントはスタートアップ時に 1 回構築され、SDK は内部的に認証情報をリフレッシュするため、クラウド認証情報のローテーションは再起動を必要としません。静的 Anthropic API キーとベアラーはスタートアップ時に読み込まれます。[Anthropic API](#anthropic-api) を参照してください。

<h4 id="upstream-error-messages">
  アップストリームエラーメッセージ
</h4>

ゲートウェイは、アップストリームがどのように応答したかに応じて、1 つのアップストリームのエラーレスポンスまたはそれ独自の `502` を返します：

* **ゲートウェイが[フェイルオーバー](#multiple-upstreams)しないステータスをアップストリームが返した**：そのアップストリームのレスポンス。ゲートウェイはそれ以上のアップストリームを試みません。
* **ゲートウェイが試みたすべてのアップストリームが[フェイルオーバー](#multiple-upstreams)する方法で失敗した**：最後の `429`。いずれも `429` を返さなかった場合、ゲートウェイは順に、最後の `401` または `403`、最後の `404`、最後の `501` を優先します。いずれも返さなかった場合、ゲートウェイ独自の `502`。`all upstreams failed (N attempted)`。N は [`upstreams`](#upstreams) のすべてのエントリをカウントします。要求されたモデルを提供しないためゲートウェイがスキップしたエントリを含みます。

ゲートウェイがアップストリームのレスポンスを返す場合、アップストリームのステータスコードを保ちます。アップストリームのメッセージを保つかどうかはプロバイダーに依存します。Anthropic API アップストリームのエラー本体は変更されずに開発者に届きます。

Amazon Bedrock、Claude Platform on AWS、Google Cloud の Agent Platform、および Microsoft Foundry アップストリームは、エラーテキストでアカウント ID、ロール ARN、およびプロジェクト ID に名前を付けることがあります。ゲートウェイはその完全なテキストを[運用ログ](/docs/ja/claude-apps-gateway-deploy#logs)に記録します。開発者がこれらのアップストリームから見るものは、拒否の種類に依存します：

* Anthropic の標準エラーエンベロープの `400` または `413`：`prompt is too long` などのアップストリーム独自のメッセージ。Claude Platform on AWS、Agent Platform、および Microsoft Foundry はモデル API の拒否に対してこのエンベロープを返します。
* プロバイダー独自の形式の `400` または `413`：`capability_rejected:` トークン。ゲートウェイが拒否を分類できない場合、`400` で `upstream rejected the request` または `413` で `request too large for this upstream`。
* その他のステータス：`429` で `upstream rate limit exceeded` などのステータスごとの汎用文言。

例えば、ゲートウェイは Amazon Bedrock の `Input is too long for requested model.` を `capability_rejected: prompt_too_long` に置き換えます。Claude Code は `prompt is too long` と同様に、そのトークンで[自動的にコンパクト](/docs/ja/errors#prompt-is-too-long)にします。

クラウドアップストリームの `400` または `413` メッセージを保つか、`capability_rejected:` トークンで置き換えるには、ゲートウェイ v2.1.233 以降が必要です。

<h4 id="anthropic-api">
  Anthropic API
</h4>

最小限の Anthropic アップストリームは、[Claude Console](https://platform.claude.com) からの API キーです：

```yaml theme={null}
upstreams:
  - provider: anthropic
    auth:
      api_key: ${ANTHROPIC_API_KEY}
    # OR an OAuth bearer (e.g. a Workload-Identity-Federation-exchanged token):
    #   oauth_token: ${file:/var/run/secrets/anthropic-oauth-token}
    # base_url: https://api.anthropic.com   # default; override for a forward proxy
```

2 つの認証情報フォームは、送信するヘッダーが異なります：

* **`api_key`**：`x-api-key` を送信します。Claude Console でローテーションし、環境変数を更新します。
* **`oauth_token`**：`Authorization: Bearer` を送信します。組織が長期 API キーではなく短期トークンを発行する場合、ベアラーフォームを使用します。ベアラーはスタートアップ時に 1 回読み込まれるため、シークレットを再マウントして再起動することでリフレッシュします。

静的キーまたはベアラーの代わりに、Workload Identity Federation を使用できます。[Workload Identity Federation ガイド](https://platform.claude.com/docs/en/manage-claude/workload-identity-federation)に従ってフェデレーションルールを作成し、ワークロードの OIDC JWT をファイルとしてマウントします。例えば、Kubernetes プロジェクトサービスアカウントトークンまたは CI プラットフォームの id-token。ゲートウェイは JWT を短期ベアラーと交換し、自動的にリフレッシュします。トークンファイルはすべての交換で再読み込みされるため、ローテーションされたプロジェクトトークンは再起動なしで取得されます。

```yaml theme={null}
upstreams:
  - provider: anthropic
    auth:
      federation_rule_id: ${ANTHROPIC_FEDERATION_RULE_ID}
      organization_id: ${ANTHROPIC_ORGANIZATION_ID}
      identity_token_file: /var/run/secrets/anthropic/id-token
      # workspace_id: wrkspc_...       # required if the rule covers >1 workspace
      # service_account_id: svac_...   # optional expected-target check
```

<a id="per-user-identity-headers-for-a-proxy-you-run" />

<h5 id="per-user-identity-headers-for-a-proxy-you-run">
  実行するプロキシの per-user アイデンティティヘッダー
</h5>

`provider: anthropic` アップストリームの `base_url` を Anthropic API ではなく実行するプロキシに向けることができます。そのプロキシに各リクエストを送信した開発者を伝えるには、そのアップストリームで `forward_user_identity: true` を設定します。プロキシはその後、開発者ごとに支出を帰属させることができます。Claude Code v2.1.233 以降を実行しているゲートウェイが必要です。

例えば、`upstream-gateway.internal.example.com` のプロキシの場合：

```yaml theme={null}
upstreams:
  - provider: anthropic
    base_url: https://upstream-gateway.internal.example.com
    auth:
      api_key: ${PROXY_KEY}
    forward_user_identity: true        # default false
```

ゲートウェイは、そのアップストリームに転送するすべてのリクエストにこれらのヘッダーを追加します。

| ヘッダー | 値 |
| - | - |
| `x-litellm-end-user-id` | IdP が提供した場合、開発者のメール。 |
| `x-claude-gateway-user-id` | トークンの `sub` クレームからの開発者の IdP サブジェクト。 |
| `x-claude-gateway-user-email` | IdP が提供した場合、開発者のメール。 |

IdP トークンがメールを含まない場合、ゲートウェイは `x-claude-gateway-user-id` のみを送信し、2 つのメールヘッダーを省略します。IdP がメールを別のクレームに入れる場合、[`oidc.email_claim`](#oidc) をそのクレームに設定します。

プロキシが開発者のメールを含むリクエストに `429` で応答する場合、ゲートウェイはそのレスポンスを開発者にそのまま返し、次のアップストリームにフェイルオーバーしません。これにより、プロキシのユーザーごとの予算またはレート制限が維持されます。プロキシの他のレスポンスは通常の[フェイルオーバールール](#upstreams)に従います。開発者の IdP トークンがメールを含まない場合、ゲートウェイはメールヘッダーなしでリクエストを転送するため、そのようなリクエストへの `429` はアップストリーム容量としてカウントされ、フェイルオーバーします。ゲートウェイサーバーの v2.1.267 より前では、すべての `429` がフェイルオーバーしました。

`forward_user_identity` は、`base_url` が運用するプロキシであるアップストリームにのみ設定します。ゲートウェイは開発者メールを、その `base_url` が名前を付けるサーバーに送信します。`base_url` が Anthropic API（デフォルト）の場合、ゲートウェイは起動を拒否します。

<h4 id="amazon-bedrock">
  Amazon Bedrock
</h4>

ゲートウェイが置き換える、または前段に置くクライアント側の Amazon Bedrock デプロイについては、[Claude Code on Amazon Bedrock](/docs/ja/amazon-bedrock) を参照してください。ゲートウェイ側のアップストリーム：

```yaml theme={null}
upstreams:
  - provider: bedrock
    region: us-east-1
    auth: {}                           # preferred: AWS default credential chain
    # OR explicit credentials:
    # auth:
    #   aws_access_key_id: ${AWS_AKID}
    #   aws_secret_access_key: ${AWS_SK}
    #   aws_session_token: ${AWS_ST}
    # OR a Bedrock API bearer token:
    # auth:
    #   aws_bearer_token: ${AWS_BEARER_TOKEN}
    # Override the bedrock-runtime endpoint for FIPS or VPC-endpoint deployments:
    # base_url: https://bedrock-runtime-fips.us-east-1.amazonaws.com
```

空の `auth` ブロックは AWS SDK のデフォルト認証情報チェーンを使用します：環境変数、`~/.aws/credentials`、ECS タスクロール、EC2 インスタンスメタデータ、または EKS 上の IRSA。本番環境では、コンテナイメージに静的キーを埋め込む代わりに、ゲートウェイポッドに IAM ロールを与えます。

明示的な認証情報は完全である必要があります。`aws_access_key_id` と `aws_secret_access_key` が一緒に設定されていない場合、または `aws_session_token` がそれらなしで設定されている場合、ゲートウェイはブート時に失敗します。v2.1.207 より前では、部分的な `auth:` ブロックが検証に合格しました。

| セットアップ | 方法 |
| - | - |
| IAM 権限 | ゲートウェイのプリンシパルに `bedrock:InvokeModel` と `bedrock:InvokeModelWithResponseStream` を推論プロファイル ARN と基礎モデル ARN の両方に付与します。US リージョンの組み込みカタログの場合：`arn:aws:bedrock:<region>:<account>:inference-profile/us.anthropic.*` と `arn:aws:bedrock:*::foundation-model/anthropic.*`。また、基礎モデル ARN に `bedrock:CountTokens` を付与します。ゲートウェイはこれを無料で使用して、クライアントが放棄したリクエストの入力トークンをカウントし、[支出制限](#admin)を正確に保ちます。これがない場合、ゲートウェイはそのカウントのために 1 トークンの Bedrock リクエストにフォールバックします。 |
| モデルアクセス | Amazon Bedrock はデフォルトで商用リージョンでモデルアクセスを有効にします。残りのアカウントレベルのゲートは Anthropic のワンタイムユースケースフォームです。AWS アカウント内の誰もそれを送信していない場合、Amazon Bedrock コンソールを開き、モデルカタログから Anthropic モデルを選択し、フォームを完成させます。AWS Organizations フォームと送信者が必要な権限については、[ユースケース詳細を送信](/docs/ja/amazon-bedrock#1-submit-use-case-details)を参照してください。 |
| EKS（IRSA） | 上記のポリシーと、ゲートウェイのサービスアカウントにスコープされたクラスターの OIDC プロバイダー用の信頼ポリシーを持つ IAM ロールを作成します。サービスアカウントに `eks.amazonaws.com/role-arn: arn:aws:iam::<acct>:role/claude-gateway` で注釈を付けます。`auth: {}` がそれを取得します。 |
| ECS / EC2 | IAM ロールをタスク定義またはインスタンスプロファイルにアタッチします。`auth: {}` がそれを取得します。 |
| その他の場所 | `AWS_ACCESS_KEY_ID`、`AWS_SECRET_ACCESS_KEY`、および `AWS_SESSION_TOKEN` 環境変数を通じて認証情報を渡すか、`${VAR}` 展開で `auth:` に明示的に設定します |
| リージョン | `region:` は API エンドポイントリージョンです。クロスリージョン推論プロファイルは、どれを選択するかに関わらず、地理（US、EU、APAC）全体でルーティングします。US 以外のリージョンまたはプロビジョニングされたスループット ARN の場合、正しい per-upstream ID を持つ [`models:`](#models) ブロックを追加します。 |

<a id="apply-an-amazon-bedrock-guardrail" />

<h5 id="apply-an-amazon-bedrock-guardrail">
  Amazon Bedrock ガードレールを適用
</h5>

ゲートウェイが Bedrock アップストリームを通じて送信するすべての推論リクエストに Amazon Bedrock ガードレールを適用するには、そのアップストリームに `guardrail` ブロックを追加します。ゲートウェイサーバーで Claude Code v2.1.281 以降が必要です。

```yaml theme={null}
upstreams:
  - provider: bedrock
    region: us-east-1
    auth: {}
    guardrail:
      id: gr-abc123                    # guardrail ID or full ARN
      version: "1"                     # a published version number, or DRAFT
 # keep the quotes: a bare 1 fails at boot
```

<Warning>
  ゲートウェイはガードレール入力タグをサポートしていません。プロンプトにガードコンテンツタグを追加しないため、Amazon Bedrock がタグ付き入力にのみ適用するガードレールフィルターはゲートウェイを通じたトラフィックで実行されません。入力タグに依存するフィルターについては、Amazon Bedrock ドキュメントの[入力タグ](https://docs.aws.amazon.com/bedrock/latest/userguide/guardrails-tagging.html)を参照してください。
</Warning>

また、このアップストリームのリクエストに署名するプリンシパル（ゲートウェイの AWS プリンシパル、または [`assume_role`](#bedrock-in-another-aws-account) を使用する場合は `role_arn` で指定したロール）に、そのガードレールに対する `bedrock:ApplyGuardrail` を付与します。

すべての `bedrock` アップストリームで `guardrail` を設定するか、どれにも設定しないでください。ゲートウェイは混在した設定では起動を拒否します。そうしないと、[フェイルオーバー](#multiple-upstreams)によってリクエストがガードレールのない Bedrock アップストリームに送信される可能性があるためです。

ガードレールは Bedrock アップストリームのみをカバーします。`upstreams` に別のプロバイダーをリストする場合、ゲートウェイはガードレールなしでそのプロバイダーにリクエストを送信します。ただし、そのプロバイダーが [`mantle`](#amazon-bedrock-mantle-endpoint) の場合は起動を拒否します。

本体に `amazon-bedrock-guardrailConfig` などの `amazon-bedrock-*` フィールドを含む `/v1/messages` リクエストが、`guardrail` が設定された Bedrock アップストリームに到達すると、ゲートウェイはそれを転送せずに 400 で応答します。

<a id="bedrock-in-another-aws-account" />

<h5 id="bedrock-in-another-aws-account">
  別の AWS アカウントの Bedrock
</h5>

Bedrock アップストリームで `assume_role` を設定すると、ゲートウェイは独自の AWS アイデンティティを、指定したロールに対して `sts:AssumeRole` を呼び出すためだけに使用します。このロールはゲートウェイとは別の AWS アカウントにあってもかまいません。そのアップストリームからのすべての Bedrock リクエストは、STS が返す 1 時間有効の認証情報で署名されるため、長期アクセスキーがアカウント間を行き来することはありません。

Claude Code v2.1.281 以降を実行しているゲートウェイが必要です。以前のゲートウェイはキーを見つけたときに起動を拒否します。

```yaml theme={null}
upstreams:
  - name: bedrock-isolated
    provider: bedrock
    region: us-east-1
    auth: {}                           # the gateway's own role: it only calls STS
    assume_role:
      role_arn: arn:aws:iam::222222222222:role/claude-gateway-bedrock
      # external_id: ${BEDROCK_ROLE_EXTERNAL_ID}   # when the role's trust policy requires one
```

`assume_role` ブロックは 3 つのキーを取ります：

| キー | 意味 |
| - | - |
| `role_arn` | ゲートウェイが引き受ける IAM ロール。`arn:aws:iam::` または `arn:aws-us-gov:iam::` ARN として指定します。このアップストリームが必要とする [Bedrock 権限](#amazon-bedrock)（`bedrock:CountTokens` を含む）と、アップストリームが `guardrail` を設定する場合は `bedrock:ApplyGuardrail` を与えます。 |
| `external_id` | オプション。すべての `sts:AssumeRole` 呼び出しで外部 ID として送信されます。ロールの信頼ポリシーが外部 ID を必要とする場合に設定し、数字のみの場合は引用符で囲みます。 |
| `session_name` | オプション。`email` または `sub` は各開発者に独自のセッションを与えます。[Per-developer AWS コスト属性](#per-developer-aws-cost-attribution)を参照してください。設定されていない場合、すべてのリクエストは `claude-apps-gateway` という名前の 1 つのセッションを使用します。 |

ロールの信頼ポリシーはゲートウェイ独自のプリンシパル（IRSA または ECS タスクロールなど）に名前を付けます。そのプリンシパルはロールに対する `sts:AssumeRole` が必要で、自身の Bedrock 権限は不要です。`external_id` を設定しない場合は `Condition` を削除します。

```json theme={null}
{
  "Version": "2012-10-17",
  "Statement": [{
    "Effect": "Allow",
    "Principal": { "AWS": "arn:aws:iam::111111111111:role/claude-gateway" },
    "Action": "sts:AssumeRole",
    "Condition": { "StringEquals": { "sts:ExternalId": "your-external-id" } }
  }]
}
```

* STS が拒否または到達不可の場合、ゲートウェイはアップストリーム独自の認証情報でリクエストを送信しません。STS エラーを確認すべき点とともにログに記録してから、リストした次のアップストリームを試みます。[アップストリームエラーメッセージ](#upstream-error-messages)は、どのアップストリームも成功しない場合にクライアントが受け取るものをカバーしています。`assume_role` のない後のアップストリームはそれ独自の認証情報でリクエストを処理するため、それが望む動作である場合のみリストしてください。
* ゲートウェイはリージョンの STS エンドポイント `sts.<region>.amazonaws.com` を呼び出すため、ネットワークはそれに到達できる必要があります。FIPS エンドポイントの場合、AWS 設定ファイルの `use_fips_endpoint` ではなく、ゲートウェイの環境で `AWS_USE_FIPS_ENDPOINT=true` を設定します。
* `assume_role` は `provider: bedrock` にのみ適用され、SigV4 ソース認証情報が必要です。ゲートウェイは `aws_bearer_token` と一緒に設定されている場合、起動を拒否します。
* ゲートウェイが許可するすべての開発者はこのアップストリームを使用できます。[`managed`](#managed) はどの開発者がどのモデルを使用できるかを制御します。ロールを通じて提供されるモデルが別のアカウントからも提供されるのを防ぐには、`upstream_model` マップにこのアップストリームの名前のみを持つカスタム id をそのモデルに与えます。そのような id の場合、ゲートウェイは他のすべてのアップストリームをスキップするため、リクエストも、中断されたリクエストのトークンカウントも、別のアカウントにフェイルオーバーすることはありません。組み込みモデル名へのリクエストは引き続き[このアップストリームに到達する](#multiple-upstreams)可能性があり、ゲートウェイはそれを同じロールで署名します。このアカウントでもそれらのモデルを提供する場合を除き、このアップストリームを最後にリストしてください。

この例は、分離されたアップストリームのみが提供するカスタム id を 1 つのモデルに与えます：

```yaml theme={null}
models:
  - id: claude-opus-restricted          # a custom id, not a built-in model name
    upstream_model:
      bedrock-isolated: us.anthropic.claude-opus-4-8   # the only upstream that serves it
```

<a id="per-developer-aws-cost-attribution" />

<h5 id="per-developer-aws-cost-attribution">
  Per-developer AWS コスト属性
</h5>

デフォルトでは、ゲートウェイはすべての Bedrock リクエストに 1 つの認証情報で署名するため、AWS はすべての開発者のリクエストを単一の IAM プリンシパルの下で見ます。[`assume_role`](#bedrock-in-another-aws-account) に `session_name: email` を追加すると、ゲートウェイは開発者ごとに 1 時間に 1 回 `sts:AssumeRole` を呼び出し、セッション名をその開発者のメールに設定し、返された認証情報でリクエストに署名するため、各開発者のリクエストは独自の引き受けたロールセッションの下で AWS に到達します。ロールはゲートウェイ独自のアカウントにあってもかまいません。

Claude Code v2.1.281 以降を実行しているゲートウェイが必要です。[AWS でのコスト属性](/docs/ja/claude-apps-gateway-on-aws#cost-attribution)は IAM ロールと AWS 請求がセッションを表示する場所をカバーしています。

```yaml theme={null}
upstreams:
  - provider: bedrock
    region: us-east-1
    auth: {}                           # the gateway's own role: it only calls STS
    assume_role:
      role_arn: arn:aws:iam::123456789012:role/claude-gateway-bedrock-user
      session_name: email              # or sub
```

`session_name` は、どの検証済みクレームが AWS `RoleSessionName` になるかを選択します：`email` または `sub`。ゲートウェイは ASCII 文字、数字、および `_+,.@-` 以外の任意の文字を UTF-8 バイトごとに `=XX` 16 進数として書き込み、64 文字より長い結果をプレフィックスとハッシュに短縮するため、各開発者のセッション名は有効で一意のままです。トークンがクレームを欠いている開発者からのリクエストはこのアップストリームを通じて送信されず、オペレーターログは `sub` に切り替えるか [`oidc.email_claim`](#oidc) を設定するよう指示します。

アクティブな開発者 1 人あたり、ゲートウェイレプリカごとに 1 時間に 1 回の STS 呼び出しが発生します。同時に発生した最初のリクエストは 1 回の呼び出しを共有します。

ゲートウェイはこのロールで独自の呼び出しも 1 つ行います。[支出制限](/docs/ja/claude-apps-gateway-spend-limits)を正確に保つための、クライアントが放棄したリクエストのトークンカウントです。そのカウントとその[1 トークンフォールバックリクエスト](#amazon-bedrock)は共有の `claude-apps-gateway` セッションで署名されるため、AWS はフォールバックを開発者ではなく `claude-apps-gateway` に帰属させます。

厳密な per-developer 属性の場合、リストするすべての Bedrock アップストリームで `assume_role` を `session_name` とともに設定します。それがないアップストリームは、処理するリクエストに独自の認証情報で署名します。

<h4 id="amazon-bedrock-mantle-endpoint">
  Amazon Bedrock Mantle エンドポイント
</h4>

`mantle` プロバイダーは、推論を Amazon Bedrock の [Mantle エンドポイント](/docs/ja/amazon-bedrock#use-the-mantle-endpoint)に送信します。ゲートウェイサーバーで Claude Code v2.1.283 以降が必要です。それより前のゲートウェイリリースはブート時にこれを拒否するため、追加する前にすべてのレプリカをアップグレードしてください。

以下の例では Mantle を最初に置き、その後ろに Amazon Bedrock アップストリームを置いて、`models` フィールドに含まれないすべてのモデルを提供させます：

```yaml theme={null}
upstreams:
  - provider: mantle
    region: us-east-1
    models: [claude-opus-4-7, claude-haiku-4-5]   # required
    auth: {}                           # AWS default credential chain
  - provider: bedrock
    region: us-east-1
    auth: {}
```

以下の表は、`mantle` アップストリーム固有のフィールドを示しています。

| フィールド | 必須 | 説明 |
| - | - | - |
| `region` | はい | AWS リージョン。ゲートウェイはここからエンドポイントを `https://bedrock-mantle.<region>.api.aws/anthropic` として導出します。 |
| `models` | はい | Mantle で AWS アカウントに付与されているモデル。`claude-haiku-4-5` のように、クライアントが送信する名前で指定します。これらのモデルのみがこのアップストリームに送られ、それ以外のモデルは次のアップストリームにスキップされます。 |
| `auth` | いいえ | [Amazon Bedrock](#amazon-bedrock) アップストリームの `auth` ブロックと同じキーを、同じルールで受け付けます。 |
| `base_url` | いいえ | 導出されたエンドポイントを上書きします。末尾の `/anthropic` パスは残してください。 |

アップストリームの AWS アイデンティティに、推論とトークンカウント用の Mantle 独自の IAM アクションを付与します。これらは [Mantle エンドポイントを使用する](/docs/ja/amazon-bedrock#use-the-mantle-endpoint)に記載されています。

ゲートウェイが認識しない Mantle モデル ID の場合は、最上位の [`models:`](#models) ブロックに、`upstream_model` がこのアップストリームの名前をその ID にマップするエントリを追加します。次に、そのエントリの `id` をこのアップストリームの `models` フィールドにも追加します。

`bedrock` アップストリームの `guardrail` と `assume_role` の設定は、Mantle が処理するリクエストには適用されません：

* **`guardrail`**：ゲートウェイは Mantle に送信するリクエストに [Bedrock ガードレール](#apply-an-amazon-bedrock-guardrail)を適用しないため、いずれかの `bedrock` アップストリームが `guardrail` を設定している状態で `mantle` アップストリームがリストされていると、起動を拒否します。
* **`assume_role`**：`mantle` アップストリームは [`assume_role`](#bedrock-in-another-aws-account) を受け付けません。Mantle が処理するリクエストは `mantle` アップストリーム自身の `auth` 認証情報で送信され、[開発者ごとに帰属](#per-developer-aws-cost-attribution)されません。

Mantle 独自のエラーレスポンスの意味については、[Mantle エンドポイントのエラー](/docs/ja/amazon-bedrock#mantle-endpoint-errors)を参照してください。

<h4 id="claude-platform-on-aws">
  Claude Platform on AWS
</h4>

Claude Platform on AWS は、`aws-external-anthropic.<region>.api.aws` で AWS インフラストラクチャ上のファーストパーティ Anthropic API を提供します。ファーストパーティのモデル ID を使用し、`anthropic-beta` ヘッダーを送信されたとおりに尊重し、`count_tokens` を提供するため、Bedrock 固有の変換は適用されません。`anthropicAws` プロバイダーには Claude Code v2.1.198 以降が必要です。以前のゲートウェイリリースはブート時にそれを拒否します。

同じプラットフォームのクライアント側デプロイについては、[Claude Code on Claude Platform on AWS](/docs/ja/claude-platform-on-aws) を参照してください。ゲートウェイ側のアップストリーム：

```yaml theme={null}
upstreams:
  - provider: anthropicAws
    region: us-east-1
    workspace_id: wrkspc_...
    auth:
      api_key: ${ANTHROPIC_AWS_API_KEY}   # sent as x-api-key
    # OR SigV4 via the AWS default credential chain:
    # auth: {}
    # OR explicit SigV4 credentials:
    # auth:
    #   aws_access_key_id: ${AWS_ACCESS_KEY_ID}
    #   aws_secret_access_key: ${AWS_SECRET_ACCESS_KEY}
    # Override the derived endpoint:
    # base_url: https://aws-external-anthropic.us-east-1.api.aws
```

このプラットフォームは Amazon Bedrock とは別の AWS アカウントで実行され、独自のサービス名 `aws-external-anthropic` で SigV4 リクエストに署名するため、Bedrock スコープの IAM ロールではそれを認可できません。`auth.api_key` の API キーは、SigV4 認証情報も設定されている場合に優先されます。空の `auth` ブロックは AWS SDK のデフォルト認証情報チェーンを使用します。これは [Amazon Bedrock](#amazon-bedrock) アップストリームが使用するのと同じチェーンです。

| フィールド | 必須 | 説明 |
| - | - | - |
| `region` | はい | AWS リージョン。小文字、数字、およびハイフン。ゲートウェイはそれからエンドポイントを `https://aws-external-anthropic.<region>.api.aws` として導出します。 |
| `workspace_id` | はい | すべてのリクエストでヘッダーとして送信されます。プラットフォームはそれを必要とします |
| `auth.api_key` | いいえ | プラットフォームの API キー。`x-api-key` として送信されます。ベアラートークンではありません。2 つの認証モードは API キーまたは SigV4 です。 |
| `auth.aws_access_key_id` / `auth.aws_secret_access_key` | いいえ | 明示的な SigV4 認証情報。一方を他方なしで設定するとブート時に失敗します。`auth.aws_session_token` はそれらと一緒に受け入れられます。 |
| `base_url` | いいえ | 導出されたエンドポイントを上書き |

プラットフォームはファーストパーティのモデル ID を解決するため、組み込みカタログは [`models:`](#models) ブロックなしでそれにルーティングします。`models:` リストをキュレートする場合、エントリのキーを `anthropicAws:` とし、ファーストパーティの ID を指定します。

<h4 id="google-cloud-agent-platform">
  Google Cloud Agent Platform
</h4>

同等のクライアント側セットアップについては、[Claude Code on Google Cloud](/docs/ja/google-vertex-ai) を参照してください。ゲートウェイ側のアップストリーム：

```yaml theme={null}
upstreams:
  - provider: vertex
    region: us-east5
    project_id: example-prod
    auth: {}                           # preferred: Application Default Credentials
    # OR a service account key file:
    # auth: { service_account_json: /secrets/sa.json }
    # Override the aiplatform endpoint for Private Service Connect:
    # base_url: https://us-east5-aiplatform.p.googleapis.com
```

空の `auth` ブロックは Application Default Credentials を使用します：`GOOGLE_APPLICATION_CREDENTIALS`、GCE メタデータ、または GKE Workload Identity。サービスアカウント JSON キーファイルはサポートされていますが、推奨されません。Workload Identity を使用するか、GCE または Cloud Run インスタンスにサービスアカウントをアタッチします。

リージョンエンドポイントの代わりに [Google Cloud の Agent Platform のグローバルエンドポイント](https://cloud.google.com/vertex-ai/generative-ai/docs/learn/locations)を使用するには、`region: global` を設定します。Google が各リクエストを利用可能なリージョンにルーティングするため、リージョンごとのモデル可用性を追跡する必要がありません。特定のリージョンを設定すると、すべてのリクエストがそのリージョンに固定されます。

| セットアップ | 方法 |
| - | - |
| IAM 権限 | ゲートウェイのサービスアカウントにプロジェクトで `roles/aiplatform.user`、または `aiplatform.endpoints.predict` を持つカスタムロールを付与します。Google Cloud の Agent Platform API（`aiplatform.googleapis.com`）を有効にします。 |
| モデルアクセス | Model Garden で、プロジェクトの Claude モデルを有効にします。モデルは特定のリージョンに公開されます。サポートされているリージョンについてはモデルカードを確認してください。 |
| GKE（Workload Identity） | GCP サービスアカウントをゲートウェイの Kubernetes サービスアカウントにバインドし、KSA に `iam.gke.io/gcp-service-account: claude-gateway@<proj>.iam.gserviceaccount.com` で注釈を付けます。`auth: {}` がそれを取得します。 |
| Cloud Run / GCE | サービスのサービスアカウントを `roles/aiplatform.user` を持つものに設定します。`auth: {}` がそれを取得します。 |
| その他の場所 | `auth: { service_account_json: /secrets/sa.json }`。シークレットとしてマウントされた JSON キーファイルへのパスです。このフィールドはキーの内容ではなくファイルパスを取るため、`${file:…}` 展開は関係ありません。 |

<h4 id="microsoft-foundry">
  Microsoft Foundry
</h4>

クライアント側の Microsoft Foundry デプロイについては、[Claude Code on Microsoft Foundry](/docs/ja/microsoft-foundry) を参照してください。ゲートウェイ側のアップストリーム：

```yaml theme={null}
upstreams:
  - provider: foundry
    resource: example-foundry              # https://example-foundry.services.ai.azure.com
    auth: { use_azure_ad: true }        # preferred: DefaultAzureCredential / Managed Identity
    # OR an API key:
    # auth:
    #   api_key: ${FOUNDRY_API_KEY}
```

`use_azure_ad: true` は `DefaultAzureCredential` を通じて解決します：AKS、ACI、または App Service 上の Managed Identity、Azure CLI、または環境認証情報。API キーは機能しますが、プロジェクト全体に適用され、自動的にローテーションしません。Microsoft Foundry のエンドポイントは `resource:` から導出されます。Azure Government などのソブリンクラウドの場合、オプションの `base_url` を設定して上書きします。

| セットアップ | 方法 |
| - | - |
| RBAC | ゲートウェイのアイデンティティに Microsoft Foundry リソースで `Azure AI User` または `Cognitive Services User` を付与 |
| デプロイ | Microsoft Foundry は正規モデル ID ではなく、管理者が選択したデプロイ名を使用します。各正規 ID をデプロイ名にマップする [`models:`](#models) ブロックを追加します。 |
| AKS（ワークロードアイデンティティ） | User-Assigned Managed Identity をクラスターの OIDC 発行者とフェデレーションし、ゲートウェイのサービスアカウントにバインドします。`use_azure_ad: true` は `WorkloadIdentityCredential` を通じてそれを取得します。 |
| ACI / App Service | リソースでシステム割り当てまたはユーザー割り当てマネージドアイデンティティを有効にします。`use_azure_ad: true` がそれを取得します。 |
| その他の場所 | `auth: { api_key: "${FOUNDRY_API_KEY}" }`。`{ }` 内の `${…}` を引用符で囲みます。 |

<h4 id="static-headers-on-upstream-requests">
  アップストリームリクエストの静的ヘッダー
</h4>

ゲートウェイが 1 つのアップストリームに送信するリクエストに固定ヘッダーを追加するには、そのアップストリームで `headers:` を設定します。プロバイダーの前段で実行するプロキシがヘッダーでトラフィックをルーティングまたは帰属させる場合に使用します。

`headers:` にはゲートウェイサーバーで Claude Code v2.1.277 以降が必要です。以前のゲートウェイはキーを見つけたときに起動を拒否します。すべてのレプリカをアップグレードしてからキーを追加し、以前のバージョンにロールバックする前にキーを削除します。

ヘッダーは `base_url` が名前を付けるサーバー、または `base_url` が設定されていない場合はプロバイダー独自のエンドポイントに送られます。プロキシがそれらを削除しない限り、プロバイダーもそれらを受け取ります。

この例は、`upstream-proxy.internal.example.com` のプロキシを通じて `provider: vertex` アップストリームに到達します。プロキシが読み取る `x-source` ヘッダーを設定し、`PROXY_TOKEN` 環境変数からのトークンを `x-proxy-token` として送信します：

```yaml theme={null}
upstreams:
  - provider: vertex
    region: us-east5
    project_id: example-prod
    base_url: https://upstream-proxy.internal.example.com
    auth: {}
    headers:
      x-source: claude-apps-gateway
      x-proxy-token: ${PROXY_TOKEN}
```

値は、どちらの端にもスペースのない印字可能な ASCII テキストです。数字、`true`、または `false` を引用符で囲んで、YAML がそれをテキストとして読むようにします。

シークレットを設定ファイルから外すには、[シークレット展開](#secret-expansion)を使用して、`${VAR}` で環境変数から、または `${file:/path}` でファイルから値を読み込みます。空の値に解決する `${VAR}` はゲートウェイの起動を停止します。

`headers:` はすべてのプロバイダーで機能し、各アップストリームは自身のヘッダーのみを送信します。

ゲートウェイがアップストリームに送信するすべてのリクエストがそれらを含むわけではありません：

| ゲートウェイがこのアップストリームに送信するリクエスト | `headers:` を含む |
| - | - |
| `/v1/messages`（ストリーミングかどうかを問わない）、および `/v1/messages/count_tokens` | はい |
| 別のアップストリームからフェイルオーバーしたリクエスト | はい。このアップストリームの `headers:` のみ |
| クライアントが放棄したリクエストの Amazon Bedrock の `CountTokens` 呼び出し | いいえ |
| Workload Identity Federation トークン交換 | いいえ |

AWS SigV4 でリクエストに署名する Amazon Bedrock または Claude Platform on AWS アップストリームでは、これらのヘッダーは署名の一部であるため、プロキシはそれらを変更せずに通す必要があります。

ゲートウェイが予約する名前を使用すると、ゲートウェイは起動を拒否し、起動エラーにそのヘッダーの名前が表示されます。予約名には以下が含まれます：

* `authorization` と `x-api-key`
* `host`、`content-type`、および `user-agent`
* `anthropic-`、`x-goog-`、`x-amz-`、または `x-amzn-` で始まる任意の名前

<h4 id="multiple-upstreams">
  複数のアップストリーム
</h4>

同じプロバイダーは異なる `name:` で複数回表示できます。これは異なるリージョン、異なるアカウント（異なる認証情報チェーン経由）、プロビジョニングされたスループット対オンデマンド、およびクロスプロバイダーフォールバックをカバーします。

ゲートウェイはアップストリームを順に試みます。`5xx`、`429`、`401`、`403`、`404`、タイムアウト、および欠落エンドポイント（`501`）がフェイルオーバーします。他の `4xx` はフェイルオーバーしません。

`429` はアップストリームごとの容量であるため、プロビジョニングされたスループット（PT）の枯渇はオンデマンドにフェイルオーバーします。アップストリームで [`forward_user_identity: true`](#per-user-identity-headers-for-a-proxy-you-run) を設定する場合、開発者のメールを含むリクエストへの `429` は代わりにユーザーごとの拒否となり、フェイルオーバーしません。

すべてのリクエストは最初のアップストリームで開始されます。リクエストは、それより前のすべてのアップストリームが失敗したか、要求されたモデルを提供しない場合のみ、後のアップストリームに到達します。

ゲートウェイは失敗したアップストリームの記録を保たないため、アップストリームがダウンしている間、それに到達するすべてのリクエストはそれを試み、失敗するのを待ってから先に進みます。

Anthropic API アップストリームの場合、[`timeouts.upstream_ttfb_ms`](#http-tuning) がダウンしたアップストリームでの待機を制限します。その設定は他のプロバイダーには適用されず、ゲートウェイはアップストリームが応答を開始するまで最大 1 時間待機します。

`404` はアップストリームごとのモデル可用性であるため、モデルを有効にしていないアップストリームは、それを提供する後のアップストリームをブロックしません。要求されたモデルを解決できないアップストリームはネットワークラウンドトリップなしでスキップされます。

この例は、プロビジョニングされたスループットの Amazon Bedrock 割り当てを最初にルーティングし、オンデマンドと 2 番目のアカウントにオーバーフローし、最後に Anthropic API にフォールバックします：

```yaml theme={null}
upstreams:
  # Primary: provisioned throughput in your home region.
  - name: bedrock-pt
    provider: bedrock
    region: us-east-1
    auth: {}
  # Overflow: on-demand cross-region.
  - name: bedrock-od
    provider: bedrock
    region: us-west-2
    auth: {}
  # Different account: a separate Bedrock allotment via static keys.
  - name: bedrock-acct2
    provider: bedrock
    region: us-east-1
    auth:
      aws_access_key_id: ${ACCT2_AKID}
      aws_secret_access_key: ${ACCT2_SK}
  # Last resort: direct Anthropic API.
  - name: anthropic-fallback
    provider: anthropic
    auth:
      api_key: ${ANTHROPIC_API_KEY}

# Per-upstream model IDs are keyed on the upstream's `name:`.
models:
  - id: claude-opus-4-8
    label: Claude Opus 4.8
    upstream_model:
      bedrock-pt: arn:aws:bedrock:us-east-1:111111111111:provisioned-model/abcdef
      bedrock-od: us.anthropic.claude-opus-4-8
      bedrock-acct2: us.anthropic.claude-opus-4-8
      anthropic-fallback: claude-opus-4-8
```

| レバー | 方法 |
| - | - |
| 異なるリージョン | リージョンごとに 1 つの Amazon Bedrock アップストリームを置き、それぞれ独自の `region:` を持たせます。[`auto_include_builtin_models: true`](#models) ではクロスリージョン推論プロファイルが自動的にルーティングします。リージョン固定のデプロイの場合、`models:` ブロックを使用します。 |
| 異なるアカウント | アカウントごとに 1 つの Amazon Bedrock アップストリーム。デフォルトチェーン（`auth: {}`）はポッドのアイデンティティを使用します。2 番目のアカウントの場合、短期認証情報でそれに到達するために [`assume_role`](#bedrock-in-another-aws-account) を追加するか、`auth:` で明示的な認証情報またはベアラートークンを設定します。 |
| プロビジョニングされたスループット | そのアップストリームの名前について、`models:` でモデルをプロビジョニングされたスループット ARN にマップします。他のアップストリームはオンデマンド ID を保つため、PT 容量はフェイルオーバーする前に使い切られます。 |
| VPC / FIPS エンドポイント | アップストリームで `base_url:` を VPC エンドポイントまたは FIPS エンドポイント URL に設定 |
| モデルスコープルーティング | 組み込み Claude モデルではないカスタムモデル `id` のみが、その `upstream_model:` マップにないアップストリームをスキップします。`mantle` アップストリームは、その [`models` フィールド](#amazon-bedrock-mantle-endpoint)にリストされたモデルに対してのみ試行されます。他のすべてのアップストリームでは、ゲートウェイは組み込みモデルを順に試み、マップにエントリがない場合はプロバイダーのデフォルト ID を使用するため、組み込みモデルの場合、マップはアップストリームが試みられるかどうかではなく、アップストリームが受け取る ID を変更します。ID を拒否するアップストリームは、他のアップストリームエラーと同じ[フェイルオーバールール](#upstreams)に従います。 |

クラウドプロバイダー間、または直接 Anthropic API へのフェイルオーバーは、リクエストに適用される契約、地理、およびその他の条件を変更します。

CLI は、どのアップストリームが特定のリクエストを処理するかに関わらず、ゲートウェイに同じ機能ゲーティングを適用するため、フェイルオーバーによってアップストリームが拒否する本体フィールドが送信されることはありません。

<h2 id="optional-sections">
  オプションセクション
</h2>

<h3 id="admin">
  `admin`
</h3>

オプション。`/v1/organizations/spend_limits` を有効にします。これは Anthropic のパブリック Admin API をミラーリングし、`/v1/messages` でデベロッパーごとの支出強制を行います。キャップの設定と強制方法については [支出制限](/docs/ja/claude-apps-gateway-spend-limits) を参照してください。このセクションでは、この機能をオンにしてチューニングする `gateway.yaml` キーについて説明します。

```yaml theme={null}
admin:
  # Named static API keys for the admin endpoints, sent as x-api-key.
  # The id appears in the audit log as admin-key:<id> so each key is
  # attributable. Array for rotation: add the new key, roll clients,
  # remove the old.
  write_keys:
    - { id: terraform, key: "${GATEWAY_ADMIN_WRITE_KEY_TF}" }
    - { id: ci,        key: "${GATEWAY_ADMIN_WRITE_KEY_CI}" }
  read_keys:
    - { id: reporting, key: "${GATEWAY_ADMIN_READ_KEY}" }
  # IdP groups granted full admin via the normal gateway JWT (no API key).
  admin_groups: [platform-finops]
  blocked_message: request an increase at https://go.example.com/claude-limits
```

| フィールド | 必須 | 説明 |
| - | - | - |
| `write_keys` | いいえ | `{id, key}` の配列。これらのいずれかと一致する `x-api-key` は、支出制限をリスト、設定、削除できます。キー値は最低 32 文字である必要があります。`id` は `read_keys` と `write_keys` 全体で一意である必要があります。 |
| `read_keys` | いいえ | `{id, key}` の配列。読み取り専用：すべての `GET` エンドポイント（キャップのリスト、ID による 1 つの取得、[`/effective`](/docs/ja/claude-apps-gateway-spend-limits#%2Feffective) と [`/audit`](/docs/ja/claude-apps-gateway-spend-limits#%2Faudit) の読み取りを含む）。 |
| `admin_groups` | いいえ | IdP グループ名。`groups` クレームにこれらのいずれかを含むゲートウェイ JWT は、完全な管理者アクセス（読み取りと書き込み）を持ち、`oidc:<sub>` として監査されます。人間の管理者にはこれを使用し、マシンには API キーを使用してください。このリストの空のエントリはブート時にゲートウェイを停止します。[ゲートウェイをブート時に停止させる matcher 値](#matcher-values-that-stop-the-gateway-at-boot) を参照してください。 |
| `blocked_message` | いいえ | ブロックされたデベロッパーが見る `429 billing_error` に逐語的に追加されます。URL や Slack チャンネルなど、完全な指示を記述してください。設定されていない場合、ゲートウェイはデフォルトメッセージのみを送信します。[強制の仕組み](/docs/ja/claude-apps-gateway-spend-limits#how-enforcement-works) を参照してください。 |
| `audit_retention_days` | いいえ | デフォルト `365`。古い `admin_audit` 行は削除されます。 |
| `spend_retention_months` | いいえ | デフォルト `13`。この期間より古い `spend` カウンター行は削除されます。デフォルトは前年比レポート用に完全な 1 年と現在の部分月を保持します。 |
| `identity_retention_days` | いいえ | デフォルト `90`。`principal_emails` 行の最終確認からの TTL。この行は各デベロッパーのメール、表示名、グループ（PII）を保持します。意図的に支出保持より短くしているため、プロビジョニング解除されたアイデンティティは期限切れになりますが、その匿名支出カウンターは残ります。 |
| `group_limit_mode` | いいえ | `min`（デフォルト）または `max`。デベロッパーがキャップのある複数のグループに属する場合、`min` は最も制限的なものを強制し、`max` は最も制限の緩いものを強制します。強制と `/effective` の両方で使用されます。 |

<h3 id="enforcement">
  `enforcement`
</h3>

`enforcement` ブロックは、ストアが利用できない場合に支出制限チェックがどのように動作するかを制御します。

| フィールド | 必須 | 説明 |
| - | - | - |
| `fail_closed_on_error` | いいえ | デフォルト `false`。支出強制は Postgres 停止時にフェイルオープンするため、推論は稼働し続けます。`true` に設定するとフェイルクローズになります：キャップを超えたデベロッパーはブロックされますが、ストアに到達できない場合は他のすべてのユーザーもブロックされます。[`admin:`](#admin) ブロックが必要です：支出強制は `admin` が設定されている場合にのみ実行され、`admin` ブロックなしでこれを `true` に設定するとゲートウェイは起動を拒否します。 |

<h3 id="pricing">
  `pricing`
</h3>

`pricing` ブロックは、支出メーターに USD リスト価格の代わりに請求する内容を指示するため、キャップと [`/effective`](/docs/ja/claude-apps-gateway-spend-limits#%2Feffective) は契約レートを反映します。金額は USD のままで、請求書ではなく見積もりです。2 つの前提条件があります：

* ゲートウェイサーバー上の Claude Code v2.1.227 以降。以前のバージョンはブート時に不明なキーを拒否します。
* [`admin:`](#admin) ブロック、または v2.1.268 以降では、少なくとも 1 つのポリシーを持つ [`managed:`](#managed) ブロック。`pricing` が設定されていて、どちらのブロックもない場合、それを読むものがないため、ゲートウェイは起動を拒否します。

```yaml theme={null}
pricing:
  multiplier: 0.85
  overrides:
    - upstream: bedrock-eu
      model: claude-sonnet-4-6
      input: 3.30
      output: 16.50
      cache_read: 0.33
      cache_write: 4.125
```

| フィールド | 必須 | 説明 |
| - | - | - |
| `multiplier` | いいえ | デフォルト `1`。メーターはリスト価格か上書きされた価格かに関わらず、すべてのメーター量にこれを乗算するため、`0.85` は価格の 85% を請求します。0 より大きく最大 10 である必要があり、1 より上の値は [マークアップ](#mark-prices-up) です。 |
| `overrides` | いいえ | 100 万トークンあたり USD での `{upstream, model, input, output, cache_read, cache_write}` の行。4 つのレートすべてが必要です。各レートは 0 より大きく最大 10000 である必要があります。 |

メーターが上書き行をどのようにマッチングするか：

* 行は、`upstream`（[`upstreams[].name`](#upstreams)）が `model` に対して処理するリクエストのリスト価格を置き換えます。これには、より高い [fast mode](/docs/ja/fast-mode#understand-the-cost-tradeoff) レートも含まれるため、fast リクエストと標準リクエストは同じ 4 つのレートでメーターされます。
* `claude-sonnet-4-6` などの組み込み ID（[`models[].id`](#models) と同様にマッチング）は、メーターがそのモデルとして価格設定するすべての日付付き形式、地域の Amazon Bedrock 形式、または Google Cloud の Agent Platform 形式をカバーします。エイリアスや推論プロファイル ARN などの他の文字列は、クライアントが送信した ID または上流に送信された文字列と大文字小文字を区別せずにマッチングします。
* 行が重複する場合、メーターは最初の行ではなく最も具体的な行を選択します：`model` が上流に送信された正確なモデル文字列である行、次にクライアントが送信した正確な ID とマッチングする行、次に組み込みモデルを指定する行。
* 不明な上流名はブート失敗を引き起こし、1 つの上流に対して同じモデルを指定する 2 つの行も同様です（1 つの組み込みモデルの 2 つの表記を含む）。ゲートウェイはブート時に、リクエスト可能なモデルが使用できない行について警告します。
* Web 検索リクエストは \$0.01 のリスト価格のままです。乗数はそれらにも適用されます。

地域ごとのレートについては、各地域に独自の名前付き上流を与え、上流ごとに 1 つの行を与えます。

<h4 id="mark-prices-up">
  価格をマークアップする
</h4>

ゲートウェイサーバー上の v2.1.271 以降では、`multiplier` を 1 より上、最大 10 まで設定して、内部チャージバックレートなど、プロバイダーが請求する以上にメーターできます。この例は、すべてのリクエストを価格の 120% でメーターします：

```yaml theme={null}
pricing:
  multiplier: 1.2
```

[`admin:`](#admin) ブロックを使用すると、マークアップは支出制限にも適用されます。メーターは価格の 120% をカウントするため、デベロッパーはキャップに早く到達します。ゲートウェイはブート時に、そのことを示す警告をログに記録します。

乗数は、上流プロバイダーがリクエストに請求する内容を変更しません。

ゲートウェイが [サインイン済みクライアントにレートを送信](#send-the-rates-to-signed-in-clients) する場合、デベロッパーがマークアップを確認するには Claude Code v2.1.271 以降が必要です。以前のクライアントは 1 より上の `multiplier` を無視し、それなしでコストを表示します。

v2.1.271 より前のゲートウェイサーバーは、`multiplier` を 1 より上に設定した場合、起動を拒否します。

<h4 id="send-the-rates-to-signed-in-clients">
  サインイン済みクライアントにレートを送信する
</h4>

ゲートウェイサーバー上の v2.1.268 以降では、ゲートウェイは `pricing` からのレートを、提供する [`managed`](#managed) ポリシーに [`modelPricing`](/docs/ja/settings-reference#modelpricing) 管理設定としても入れます。ポリシーにマッチするデベロッパーは、`/usage`、ステータスライン、OpenTelemetry で、各モデル ID を処理する最初の上流の `pricing` レートを確認できます。ポリシーにマッチしないデベロッパーは管理設定を受け取らないため、その数字はリスト価格のままです。クライアントは Claude Code v2.1.242 以降で設定を適用します。

* ゲートウェイが追加するもの：ポリシーの `cli` ブロックが既に `modelPricing` を設定していない限り、ゲートウェイは `multiplier` と、クライアントがリクエストできるすべてのモデル ID について、その ID を処理する最初の上流の上書き行を追加します。フェイルオーバー上流のみが請求するレートはゲートウェイに留まります。
* 1 つのポリシーをオプトアウトする：そのポリシーの `cli` ブロックで `modelPricing` を `{}` に設定すると、そのデベロッパーはリスト価格のままです。
* ポリシー独自のレートを保持する：`cli` ブロックが独自の `multiplier` または `overrides` で `modelPricing` を設定するポリシーは、その `modelPricing` 全体を保持し、ゲートウェイはそれに独自のレートを追加しません。

<h3 id="models">
  `models`
</h3>

`models` ブロックはオプションの管理者キュレーション済みモデルリストで、`/v1/models` で提供され、上流ごとにモデル ID を変換するために使用されます。これは、米国以外の Amazon Bedrock リージョン、Amazon Bedrock プロビジョニング済みスループット ARN、および Microsoft Foundry のデプロイ名に必須です。

```yaml theme={null}
auto_include_builtin_models: true   # false: expose only the list below
models:
  - id: claude-opus-4-8
    label: Claude Opus 4.8
    # description: optional text shown in clients that surface it
    upstream_model:
      anthropic: claude-opus-4-8
      bedrock: us.anthropic.claude-opus-4-8   # or an inference-profile ARN
      foundry: your-opus-deployment-name
```

`upstream_model` の各キーは、設定された上流の `name` と一致する必要があります。デフォルトはプロバイダー名です。キーが上流と一致しない場合、ブート失敗を引き起こすため、使用しないプロバイダーの行は省略してください。

<h3 id="managed">
  `managed`
</h3>

`managed` ブロックは、IdP グループまたはメールドメインをキーとしたロールベースのアクセスポリシーを定義します。ポリシーは順番に評価され、最初のマッチが選択され、`match: {}` キャッチオール基盤にマージされます。これらは `GET /managed/settings` でユーザーごとに ETag/304 キャッシング付きで提供されます。

```yaml theme={null}
managed:
  policies:
    # Specific groups first.
    - match: { groups: [eng-contractors] }
      cli:
        availableModels: [claude-sonnet-4-6]
        permissions: { deny: ["WebFetch", "WebSearch"] }
    # Default catch-all last: matches everyone who authenticated.
    - match: {}
      cli:
        availableModels: [claude-opus-4-8, claude-sonnet-4-6, claude-haiku-4-5]
        # Make the Default option in /model resolve inside each policy's
        # list. The eng-contractors policy inherits enforceAvailableModels.
        enforceAvailableModels: true
```

`match: {}` キャッチオール（慣例的に最後にリストされる）は基盤層として扱われます。他のすべてのポリシーは、設定しないキーをキャッチオールから継承するため、ロールごとのエントリは組織のデフォルトと異なる内容のみをリストすれば済みます。マージルールはキータイプに依存します：

* **許可リスト**：`availableModels` と `permissions.allow`。特定のポリシーのリストは基盤のリストを完全に置き換えます。
* **拒否リストとフック配列**：`permissions.deny`、`permissions.ask`、`disabledMcpjsonServers`、`deniedMcpServers`、`blockedMarketplaces`、およびすべての `hooks` イベントタイプ配列。これらは基盤とポリシーの和集合を取るため、組織全体の拒否または監査フックがロールごとの上書きで誤って削除されることはありません。
* **レコード型キー**：`env`、`modelOverrides`、`skillOverrides`。これらは浅くマージされるため、ロールごとの `env` ブロックは設定するキーを上書きし、残りを基盤から継承します。

`availableModels` は `/v1/messages` でサーバー側でも強制されるため、拒否されたモデルはクライアントが送信する内容に関わらず `400` を返します。空のリストはすべてのモデルを拒否します。このチェックは、デベロッパーがモデルを選択する前にセッションが開始するモデルにも適用されるため、[ポリシーが許可するモデルでセッションを開始](#start-sessions-on-a-model-the-policy-allows) してください。

ゲートウェイはリクエストを中継する前に `model` 値自体を検証するため、不正な形式の値は上流に到達しません。2 つの場合に `400` でリクエストを拒否します：

* 値が欠落しているか空の場合、ゲートウェイはメッセージ `model is required` でリクエストを拒否します。このチェックには Claude Code v2.1.228 以降を実行しているゲートウェイが必要です。
* 値が存在しているが文字列ではない場合、ゲートウェイはメッセージ `model must be a string` でリクエストを拒否します。Claude Code v2.1.221 以降を実行しているゲートウェイが必要です。

| Matcher | 動作 |
| - | - |
| `match: {}` | すべての認証されたユーザーにマッチします。まずこれで開始し、後でその上にグループスコープのポリシーを追加します。 |
| `match: { groups: [a, b] }` | JWT の `groups` クレームにリストされたグループのいずれかが含まれている場合にマッチします。大文字小文字を区別します：グループは IdP の正確な大文字小文字と一致する必要があります。 |
| `match: { email_domain: example.com }` | JWT の `email` クレームの最後の `@` の後の部分に、大文字小文字を区別せずにマッチします。ポリシーごとに 1 つのドメインを受け入れます。 |
| `match: { groups: [a], email_domain: example.com }` | 両方の条件がマッチする必要があります |

認証されたユーザーがどのポリシーにもマッチしない場合、ゲートウェイのデフォルトが適用されます。これはカタログ内のすべてのモデルが利用でき、管理設定がないことを意味します。確実にデフォルトポリシーを適用したい場合は、最後に `match: {}` キャッチオールを追加してください。

<Note>
  ゲートウェイは独自のユーザーディレクトリを保持しません。ユーザーの IdP トークンから各リクエストを認可し、トークンの `groups` クレームからグループメンバーシップを読み取り、それに対してポリシーを評価します。列挙するロスターはなく、事前作成するアカウントもなく、したがって SCIM エンドポイントもありません。SCIM が同期する先がないためです。

  ユーザーとグループのライフサイクル管理は、信頼できる情報源である IdP のネイティブ SCIM プロビジョニングまたは専用のアイデンティティガバナンスプラットフォームで実行してください。そこで管理されるメンバーシップとプロビジョニング解除は、トークンを通じてゲートウェイに自動的に反映されます。Claude アカウント自体の SCIM プロビジョニングが必要な場合、それは [Claude for Enterprise](/docs/ja/admin-setup) の機能です。

  2 つの伝播タイミングがあります：

  * **ポリシーの内容**：ポリシーを編集して再デプロイすると、接続された Claude Code クライアントの次の管理設定ポーリング時（1 時間以内）に反映されます。ただし [次の起動時にのみ適用される変更](/docs/ja/server-managed-settings#fetch-and-caching-behavior) は除きます。
  * **グループメンバーシップ**：ユーザーのグループメンバーシップを変更すると、どのポリシーがそのユーザーにマッチするかが変わります。これは次のセッション再発行時、つまり次のサイレントリフレッシュ時に有効になり、`session.ttl_hours` が上限となります。

  Claude Desktop は [独自のスケジュール](#when-a-policy-change-reaches-claude-desktop) に従います。
</Note>

<h4 id="start-sessions-on-a-model-the-policy-allows">
  ポリシーが許可するモデルでセッションを開始する
</h4>

`availableModels` に Claude Code のデフォルトモデルが含まれていない場合、デベロッパーが `/model` などでリストにあるモデルを選択するまで、セッションは `400` レスポンスを受け取ります。ゲートウェイセッションでは、デフォルトは `opus` エイリアスが解決される Opus モデルであり、`availableModels` だけではこれは変わりません。

これを解決するには、同じ `cli` ブロックで [`enforceAvailableModels: true`](/docs/ja/model-config#enforce-the-allowlist-for-the-default-model) を設定し、リストに含まれるエントリの種類を確認します：

* **`sonnet` などのエイリアス、または `claude-sonnet-4-6` などの組み込み ID**：セッションはそれらのモデルのいずれかで開始し、`/model` の Default オプションはそのモデルに解決されます
* **リストにエイリアスも組み込み ID もない場合**：セッションは引き続き組み込みのデフォルトで開始する可能性があるため、そのポリシーの `cli` ブロックで [`model`](/docs/ja/model-config#control-the-model-users-run-on) もリスト内の ID のいずれかに設定してください

このポリシーは [`models`](#models) で定義された 1 つのカスタム ID をリストし、その ID でセッションを開始します：

```yaml theme={null}
managed:
  policies:
    - match: { groups: [restricted-projects] }
      cli:
        availableModels: [claude-opus-restricted]
        enforceAvailableModels: true
        model: claude-opus-restricted
```

<h4 id="matcher-values-that-stop-the-gateway-at-boot">
  ゲートウェイをブート時に停止させる matcher 値
</h4>

ブート時に、ゲートウェイはすべてのポリシーの `match` ブロックと [`admin_groups`](#admin) リストをチェックします。以下の値のいずれかがあると、ゲートウェイはそのフィールドを示すエラーで停止します：

* 空の `groups` リスト
* `groups` または `admin_groups` の空のエントリ
* 空の `email_domain`
* `@`、空白、またはコンマを含む `email_domain`。ゲートウェイはこのチェックの前に値をトリミングし、先頭の `@` を 1 つ削除します。`example.com` のように、ドメインのみを 1 つ記述してください。

v2.1.232 より前では、ゲートウェイはこれらの値で起動しました。各値には次の影響がありました：

* 空の `email_domain`：ゲートウェイはドメインチェックをスキップしたため、空の `email_domain` を持ち `groups` リストのないポリシーはすべての認証されたユーザーにマッチしました
* 空の `groups` リスト：ポリシーは誰にもマッチしませんでした
* `@`、空白、またはコンマを含む `email_domain`：ポリシーは誰にもマッチしませんでした
* `groups` または `admin_groups` の空のエントリ：そのユーザーの IdP `groups` クレームにも空のエントリが含まれている場合にのみ、エントリはユーザーにマッチしました。`admin_groups` では、そのマッチにより管理者アクセスが付与されました。`admin_groups` リストに空のエントリが一度も含まれていなかった場合、この方法で管理者アクセスを得た人はいません。

<h4 id="what-goes-in-cli">
  `cli` に何を入れるか
</h4>

各 `cli` 値は完全な Claude Code `managed-settings.json` ドキュメントであり、MDM または `/etc/claude-code/managed-settings.json` を介してデプロイするのと同じスキーマを、ここでは YAML で表現したものです。CLI は配信されたドキュメントを、ユーザー設定とプロジェクト設定より上の管理層で、サーバー管理設定の代わりに適用します。したがって、[OS レベルのポリシーソースに限定される設定](/docs/ja/server-managed-settings#current-limitations)（`policyHelper` や `wslInheritsWindowsSettings` など）は無視されます。

ゲートウェイはブート時に各ドキュメントを CLI の設定スキーマに対して検証するため、認識されないトップレベルキーがあるとブートが失敗し、違反するすべてのキーを示すエラーが表示されます。スキーマの意図的にオープンな部分は引き続き任意の値を受け入れます。新しいクライアントが、ゲートウェイのスキーマが認識しないエントリを認識する可能性があるためです。これらのオープンキーには `env`、`pluginConfigs`、`permissions` の下にネストされたキーが含まれます。

検証はゲートウェイのインストール済みバージョンにバンドルされたスキーマを使用するため、新しい Claude Code リリースで導入されたトップレベル設定キーを管理設定に入れるには、まずゲートウェイをアップグレードする必要があります。新しいポリシーはロールアウトする前に 1 つのクライアントでスモークテストしてください。

完全なキーリファレンスは [Claude Code 設定](/docs/ja/settings-reference#all-settings) にあります。オペレーターが最初に使うことの多いキー：

```yaml theme={null}
managed:
  policies:
    - match: {}
      cli:
        # Model access (also enforced server-side at /v1/messages)
        availableModels: [claude-opus-4-8, claude-sonnet-4-6, claude-haiku-4-5]
        enforceAvailableModels: true              # Default resolves inside the list

        # Permission policy
        permissions:
          deny:
            - "WebFetch"
            - "Read(./.env)"
            - "Read(./secrets/**)"
          disableBypassPermissionsMode: disable   # blocks --dangerously-skip-permissions
        allowManagedPermissionRulesOnly: true     # ignore user/project permission rules

        # Environment pushed into the CLI process. DISABLE_UPDATES blocks
        # background and manual updates; DISABLE_AUTOUPDATER stops only
        # background updates.
        env:
          DISABLE_UPDATES: "1"                    # pin versions via your own distribution

        # Org-wide hooks. Hook commands run on developer machines, not the
        # gateway, so the path must exist on every client OS in the policy.
        hooks:
          PostToolUse:
            - matcher: "Edit|Write"
              hooks:
                - { type: command, command: /usr/local/bin/audit-edit.sh }
```

| キー | 強制元 | 効果 |
| - | - | - |
| `availableModels` | ゲートウェイ + CLI | モデル許可リスト。`/v1/messages` でもチェックされるため、パッチされたクライアントはバイパスできません。 |
| `permissions.allow` / `.deny` | CLI | ツールとコマンドのルール。[権限](/docs/ja/permissions) を参照してください。 |
| `permissions.disableBypassPermissionsMode` | CLI | `disable` に設定すると、[`bypassPermissions`](/docs/ja/permission-modes#skip-all-checks-with-bypasspermissions-mode)（権限プロンプトをスキップするモード）と `--dangerously-skip-permissions` フラグをブロックします |
| `allowManagedPermissionRulesOnly` | CLI | `true` の場合、管理設定が権限ルールの唯一の設定ソースになります。[`allowManagedPermissionRulesOnly`](/docs/ja/settings-reference#allowmanagedpermissionrulesonly) エントリには、その場合に Claude Code が無視するすべてのソースがリストされています。 |
| `env` | CLI | CLI プロセスにマージされる環境変数。テレメトリ、自動更新、モデル名の上書きに使用します。 |
| `hooks` | CLI | 組織全体の [フック](/docs/ja/hooks) |
| `managedMcpServers` | CLI | デベロッパーが自分で追加するサーバーとともに [マッチするすべてのデベロッパーに提供される](/docs/ja/managed-mcp#provide-servers-through-managed-settings) リモート MCP サーバー（`http` と `sse` のみ）。[ポリシー内の MCP サーバー](#mcp-servers-in-a-policy) を参照してください。ゲートウェイサーバーとクライアントの両方で Claude Code v2.1.259 以降が必要です。以前のクライアントはキーを無視します。 |

これらの設定はネットワーク経由で届くため、CLI は以下の設定を適用する前に、各デベロッパーにセキュリティ承認ダイアログを表示します：

* `hooks`
* プロキシやベース URL の変数など、デベロッパーの承認が必要な `env` 変数
* `apiKeyHelper` や `statusLine` などのシェル実行設定
* サンドボックスバイナリ設定 `sandbox.bwrapPath`、`sandbox.socatPath`、`sandbox.ripgrep`
* `sandbox.network.tlsTerminate` やプロキシポート設定など、トラフィックをインターセプトしたり、認証情報を注入したり、分離を弱めたりするサンドボックス設定。[セキュリティ承認ダイアログ](/docs/ja/server-managed-settings#security-approval-dialogs) にすべてがリストされています。

承認がどのくらい持続し、いつダイアログが再表示されるかについては [承認の記憶](/docs/ja/server-managed-settings#approval-memory) を参照してください。

Claude Code は、モデル選択設定や数値制限など、配信された `env` 変数の一部をデベロッパーに承認ダイアログを表示せずに適用します。その他の配信変数は、有効になる前にデベロッパーの承認が必要な場合があります。空でないプロキシ、ベース URL、または `OTEL_EXPORTER_OTLP_ENDPOINT` の値は常に承認が必要です。配信変数に承認が必要な場合、ダイアログにはその変数名が表示されます。

詳細は [環境変数と承認ダイアログ](/docs/ja/server-managed-settings#environment-variables-and-the-approval-dialog) を参照してください。配信値によって承認が必要かどうかが決まる 4 つのプライバシートグルについても記載されています。v2.1.218 より前では、Claude Code がデベロッパーに確認せずに適用する変数が少なかったため、より多くの配信変数でダイアログが表示されていました。

ゲートウェイの [テレメトリ](#telemetry) 設定は `OTEL_EXPORTER_OTLP_ENDPOINT` をプッシュするため、`telemetry.forward_to` を設定すると各インタラクティブクライアントでダイアログが表示されます。このダイアログは、侵害されたゲートウェイや悪意のあるゲートウェイからデベロッパーのマシンを保護するものであり、デベロッパーから組織を保護するものではありません。

`claude -p` や Agent SDK セッションなどの [非インタラクティブ実行](/docs/ja/server-managed-settings#security-approval-dialogs) はダイアログを表示できません。プッシュされた設定をその実行に限り適用し、承認済みとして記録しないため、デベロッパーの次のインタラクティブセッションでは引き続きダイアログが表示されます。v2.1.207 より前では、非インタラクティブ実行が設定を承認済みとして保存したため、以降のインタラクティブセッションではそれらのダイアログが表示されませんでした。

デベロッパーが拒否した場合、Claude Code はポリシーを適用せずにそのセッションを終了します。そのため、新しいフックやダイアログが表示される env 変数を広範なポリシーにプッシュすると、マッチするすべてのデベロッパーのインタラクティブセッションでダイアログが表示されます。実行中のインタラクティブセッションでは次の 1 時間ごとのポーリング時に表示され、それ以外の場合はデベロッパーの次のインタラクティブ起動時に表示されます。

`cli` キーは以前のリリースでは `settings` という名前でした。その表記は引き続きエイリアスとして受け入れられますが、新しいデプロイでは `cli` を使用してください。

<h4 id="context-window-in-terminal-sessions">
  ターミナルセッションのコンテキストウィンドウ
</h4>

`/login` でサインインしたターミナルセッションは、Opus 4.7 以降、Sonnet 5 以降、および Fable モデルで 1M のコンテキストウィンドウを使用します。モデル ID に `[1m]` サフィックスは不要で、セッションは約 967K トークンで圧縮されます。デベロッパーのマシン上の Claude Code v2.1.287 より前では、Claude Code はモデル ID が `[1m]` で終わらない限り、Opus と Fable モデルのウィンドウを 200K として扱っていました。

代わりにターミナルセッションを 200K の境界で圧縮させるには、ポリシーの `env` で [自動圧縮ウィンドウ](/docs/ja/model-config#set-the-auto-compact-window) を設定します：

```yaml theme={null}
managed:
  policies:
    - match: {}
      cli:
        env:
          CLAUDE_CODE_AUTO_COMPACT_WINDOW: "200000"
```

Claude Code は、デベロッパーに承認ダイアログを表示せずにこの変数を適用します。この変数は、`[1m]` で終わるモデル ID を含むすべてのモデルに適用されます。

代わりに 1M コンテキストをオフにするには、同じ `env` ブロックで [`CLAUDE_CODE_DISABLE_1M_CONTEXT: "1"`](/docs/ja/model-config#extended-context) を設定します。すると Claude Code はすべてのモデルのウィンドウを 200K として扱います。インタラクティブセッションでは、この変数が有効になる前に、各デベロッパーが [承認ダイアログ](#what-goes-in-cli) でこれを承認します。

<h4 id="mcp-servers-in-a-policy">
  ポリシー内の MCP サーバー
</h4>

ポリシーがマッチする Claude Code クライアントに MCP サーバーを提供するには、そのポリシーの `cli` ブロックで [`managedMcpServers`](/docs/ja/managed-mcp#provide-servers-through-managed-settings) を設定します。ゲートウェイサーバーとクライアントの両方で Claude Code v2.1.259 以降が必要です。

ゲートウェイはブート時に [Claude Code がクライアントで適用するのと同じルール](/docs/ja/managed-mcp#what-an-entry-can-contain) で各エントリをチェックし、エントリがチェックに失敗した場合は起動を拒否してそのエントリを示します。

`gateway.yaml` に `${VAR}` 参照を記述した場合、ゲートウェイはエントリチェックを実行する前に、ブート時に [シークレット展開](#secret-expansion) を通じて自身の環境から解決します。そのため、マッチするすべてのクライアントはリテラル値を受け取り、それを読むことができます。[提供されるサーバーのヘッダーに関するガイダンス](/docs/ja/managed-mcp#provide-servers-through-managed-settings) は展開後の値に適用されます。

ゲートウェイは `cli` ブロック内の `.mcp.json` 表記 `mcpServers` を拒否し、そのブートエラーでは使用すべきキーとして `managedMcpServers` を示します。v2.1.259 より前では、ゲートウェイは `cli` ブロック内のすべての MCP サーバー定義を拒否していました。

<h4 id="claude-desktop-overlay">
  Claude Desktop オーバーレイ
</h4>

組織が [Claude Desktop](/docs/ja/desktop) もデプロイしている場合、同じゲートウェイが両方のクライアントに対応します。Claude Desktop の [管理設定](https://claude.com/docs/third-party/claude-desktop/configuration) の `bootstrapUrl` を `<listen.public_url>/user/bootstrap` に向けてください。Claude Desktop はその URL から OAuth 発行者を導出し、このゲートウェイに対して同じデバイスコードサインインを実行し、レスポンスから設定を取得します。

<Note>
  ゲートウェイサーバー上の Claude Code v2.1.203 以降と、明示的なオプトインが必要です：ユーザーにマッチするポリシーが `desktop` キーを持たない限り、`/user/bootstrap` は 404 を返します。空の `desktop: {}` でポリシーをオプトインでき、`match: {}` 基盤層の `desktop` キーはそれを継承するすべてのポリシーをオプトインします。監査ログは各リクエストを `desktop_bootstrap.serve` または `desktop_bootstrap.denied` として記録します。
</Note>

Claude Desktop をデプロイしない場合は、ポリシーから `desktop` を完全に省略してください。その場合、ゲートウェイはすべてのユーザーに対して `/user/bootstrap` から 404 を返します。

<h5 id="settings-the-gateway-derives-for-claude-desktop">
  ゲートウェイが Claude Desktop 用に導出する設定
</h5>

ゲートウェイはブートストラップレスポンスの多くを、マッチしたポリシーの `cli` ブロックとトップレベルのゲートウェイ設定から導出します：

* `availableModels` からのモデルリスト。各モデルの 1M コンテキストオプションについては [Claude Desktop の拡張コンテキスト](#extended-context-in-claude-desktop) を参照してください
* ツール名のみの `permissions.deny` エントリからの無効化されたツール。ポリシーの `desktop` ブロックで `disabledBuiltinTools` を設定した場合、ゲートウェイは指定した値と導出されたリストの和集合を提供します。そのため、この方法でさらにツールを無効化できますが、`permissions.deny` で無効化したツールを再度有効化することはできません
* `sandbox.network.allowedDomains` からの出力許可リスト。ポリシーの `desktop` ブロックで `coworkEgressAllowedHosts` を設定した場合、ゲートウェイは導出されたリストの代わりにその値を使用します
* ゲートウェイ自体を指す OTLP エンドポイントと、サインインしたユーザーのアイデンティティ属性。ゲートウェイはそのエンドポイントで受け取ったエクスポートを `forward_to` の宛先にリレーします。[`telemetry.forward_to`](#telemetry) と `listen.public_url` の両方を設定した場合に、エンドポイントと属性が含まれます。

  Claude Desktop はすべてのシグナルを 1 つのエンコーディングでエクスポートします：`http/protobuf`、またはポリシーの `env` で `OTEL_EXPORTER_OTLP_PROTOCOL` またはそのシグナルごとのバリアントのいずれかを `http/json` に設定した場合は `http/json` です。ゲートウェイサーバー上の Claude Code v2.1.261 より前では、レスポンスは常に `http/json` を設定していたため、protobuf のみを受け入れるコレクターは Claude Desktop のエクスポートを拒否していました

ポリシーの `desktop` ブロックで `disabledBuiltinTools`、`coworkEgressAllowedHosts`、または Claude Desktop 独自の `managedMcpServers` 設定を設定するには、ゲートウェイサーバー上の Claude Code v2.1.232 以降が必要です。Claude Desktop の `managedMcpServers` はオブジェクトではなく配列値を取ります。

ゲートウェイは、`hooks` や `Bash(npm *)` のようなスコープ付き権限ルールなど、Claude Desktop に相当するものがないキーをブートストラップレスポンスから省略します。

<h5 id="set-claude-desktop-settings-directly">
  Claude Desktop の設定を直接指定する
</h5>

Claude Desktop の設定を直接指定するには、`cli` と並べてオプションの `desktop` ブロックを追加します。Claude Desktop の [管理設定リファレンス](https://claude.com/docs/third-party/claude-desktop/configuration) にある設定をフラットなキー名で記述してください。`bootstrapUrl` など、Claude Desktop が MDM またはローカルファイルからのみ読み取るキーは省略してください。ゲートウェイはブート時にそれらを拒否します。

この例では、`eng-contractors` グループに対して、その `cli` 設定と並べて 3 つの Claude Desktop キーを設定します：

```yaml theme={null}
managed:
  policies:
    - match: { groups: [eng-contractors] }
      cli:
        availableModels: [claude-sonnet-4-6]
        enforceAvailableModels: true
      desktop:
        isLocalDevMcpEnabled: false
        disableAutoUpdates: true
        banner: { text: "Contractor build: internal use only" }
```

すべてのキーはオプションです。省略したキーには Claude Desktop 独自のデフォルトが適用されます。

<h5 id="what-the-gateway-rejects-at-boot">
  ゲートウェイがブート時に拒否するもの
</h5>

ゲートウェイはブート時に各 `desktop` ブロックを Claude Desktop 自体が使用する設定スキーマに対して検証するため、間違いは接続されたすべてのデスクトップに届くのではなく、ゲートウェイ起動時にキーを示すエラーとして表面化します。ブロックに以下が含まれる場合、ゲートウェイはブート時に失敗します：

* 不明なキー
* 空の値やネストされたエントリ内のサブキーのスペルミスなど、Claude Desktop が拒否するか黙って破棄する値を持つ認識済みのキー。v2.1.260 より前では、ゲートウェイは `managedMcpServers` または `orgPluginSettings` エントリのネストされたオブジェクト内のスペルミスのあるフィールドを、ブート時に失敗させずに黙って破棄していました。
* ゲートウェイ自身が計算するキー：推論接続、モデルリスト、OTLP リレー。これらは [`upstreams`](#upstreams)、[`models`](#models)、[`telemetry`](#telemetry) セクションの `forward_to` で設定してください。
* 現在のキーのレガシーエイリアス。ブートエラーでは、ゲートウェイは記述すべき正規のキーを示します。

`transport` のない `managedMcpServers` エントリなど、非推奨の値やエントリ形式を使用した場合、ゲートウェイは起動し、代替を示す警告をログに記録します。

v2.1.232 より前では、ゲートウェイは `chatTabEnabled` や `disableAutoUpdates` など 11 個の機能ゲートキーの固定リストを受け入れ、その他のすべてのキーをブート時に拒否していました。v2.1.227 より前では、ゲートウェイは `chatTabEnabled` と `chatAdvancedFileAnalysisEnabled` もブート時に拒否していました。

<h5 id="keys-that-need-a-later-gateway-or-claude-desktop-version">
  より新しいゲートウェイまたは Claude Desktop のバージョンが必要なキー
</h5>

ゲートウェイは `cli` ブロックと同様に、インストール済みバージョンにバンドルされたスキーマに対して `desktop` ブロックを検証します。新しい Claude Desktop リリースで導入された設定を配信するには、まずゲートウェイをアップグレードしてください。例えば、`userPluginMarketplacesEnabled` と `userPluginUploadsEnabled` には、ゲートウェイサーバー上の Claude Code v2.1.260 以降と、メンバーのマシン上の Claude Desktop 1.37937.0 以降が必要です。

`blockReadsOutsideWorkingDirectories`、`disableBypassPermissionsMode`、`configRecheckIntervalMinutes`、`sshClientPath` には、ゲートウェイサーバー上の Claude Code v2.1.281 以降が必要です。`microsoftAuthBroker` の `required` 値と、Microsoft 365 `managedMcpServers` エントリの `continuousAccessEvaluation` フィールドも同様です。`required` 値より前の Claude Desktop リリースはそれを `disabled` として読み取るため、すべてのメンバーの Claude Desktop がサポートしてから `required` を設定してください。Claude Desktop の [管理設定リファレンス](https://claude.com/docs/third-party/claude-desktop/configuration) には、各キーを最初に読み取るリリースがリストされています。

ポリシーの `desktop` ブロックで `orgPluginSettings` を設定した場合、ゲートウェイは Claude Desktop 1.15200.0 以降が読み取る配列形式で提供します。古いデスクトップは配列を無視し、プラグインツールポリシーを強制しないため、それに依存する前にメンバーを 1.15200.0 以降に更新してください。

<h5 id="how-a-role-policy-inherits-the-base-desktop-block">
  ロールポリシーが基盤の `desktop` ブロックを継承する仕組み
</h5>

ゲートウェイは、ポリシーの `cli` ブロックを基盤から補完するのと同じ方法で、ポリシーの `desktop` ブロックが設定していないキーを `match: {}` キャッチオールの `desktop` ブロックから補完します。基盤とロールポリシーの両方で `disabledBuiltinTools` または `builtinToolPolicy` を設定した場合、ゲートウェイは基盤の制限を維持します：

* `disabledBuiltinTools`：ゲートウェイは基盤のリストとポリシーのリストの和集合を使用します
* `builtinToolPolicy`：基盤でツールを `allow` 以外の値に設定した場合、ロールポリシーで同じツールに `allow` を設定しても、ゲートウェイはその値を維持します

その他のすべてのキーについては、ロールポリシーで設定した場合、ゲートウェイはロールポリシーの値を使用します。ゲートウェイは配列や `banner` などのネストされたオブジェクトを丸ごと置き換えるため、ロールポリシーで `banner.text` を設定すると、ゲートウェイは基盤の `banner.backgroundColor` を破棄します。

<h5 id="when-a-policy-change-reaches-claude-desktop">
  ポリシーの変更が Claude Desktop に届くタイミング
</h5>

変更したポリシーでゲートウェイを再デプロイした後、Claude Desktop はほとんどの設定を次回の起動時にのみ適用します：

* **閉じている場合**：Claude Desktop は起動時にブートストラップレスポンスを取得するため、変更は次回の起動から適用されます
* **開いている場合**：Claude Desktop はデフォルトで 10 分ごとにレスポンスの変更を確認し、一部の設定は再起動なしで適用します。[`skillCreationEnabled`](https://claude.com/docs/third-party/claude-desktop/configuration#skillcreationenabled) などのその他の設定については、ユーザーのサイドバーに **Relaunch Claude Desktop** カードが表示され、アプリを再起動するまで以前の設定が維持されます。デフォルトでは 24 時間後に、Claude Desktop は再起動ダイアログを表示し、2 分間操作がないと自動的に再起動します

24 時間を短縮するには、ポリシーの `desktop` ブロックで [`relaunchEnforcementHours`](https://claude.com/docs/third-party/claude-desktop/configuration#relaunchenforcementhours) を設定します。ゲートウェイサーバー上の Claude Code v2.1.260 以降と、メンバーのマシン上の Claude Desktop 1.40609.0 以降が必要です。`0` にすると、Claude Desktop が変更を検出するとすぐにダイアログが表示されます。

<h4 id="extended-context-in-claude-desktop">
  Claude Desktop の拡張コンテキスト
</h4>

ゲートウェイから [Claude Desktop](#claude-desktop-overlay) に提供している場合、そのモデルピッカーは、1M のコンテキストウィンドウで実行できるリスト内の各モデルについて 1M コンテキストオプションを提供します。これには Claude Opus 4.6 以降、Claude Sonnet 4.6 以降、および Fable モデルが含まれます。このオプションはモデルの `[1m]` バリアントであり、[拡張コンテキスト](/docs/ja/model-config#extended-context) で説明されています。ゲートウェイサーバー上の Claude Code v2.1.284 以降が必要です。

次の場合、[`models`](#models) エントリには 1M オプションが表示されません：

* エントリを処理できる上流が、1M をサポートしないモデルにエントリをマッピングしている場合。ゲートウェイがフェイルオーバー時にのみ到達する上流も含みます
* `id` も `upstream_model` の値も Claude モデルを指定していない場合。例えば、アプリケーション推論プロファイル ARN にルーティングされるカスタムエイリアスなど

ピッカーに表示される内容を変更するには、次のいずれかを使用します：

* **ユーザーを 1M オプションで開始する**：ポリシーの `desktop` ブロックで `modelPrefer1mContext: true` を設定します。まだモデルを選択していないユーザーは、リストの最初のモデルに 1M オプションがある場合、1M オプションで開始します。既にモデルを選択したユーザーはその選択を維持します。
* **オプションを手動で提供する**：ゲートウェイサーバーが v2.1.284 より古いバージョンを実行している場合や、エントリが Claude モデルを指定していない場合に使用します。`models` にモデルを 2 回リストします。1 回はプレーンな ID で、もう 1 回は `[1m]` を付加して、どちらも同じ `upstream_model` マップを指定します。Claude Desktop はこのペアを 1M オプション付きの 1 つのモデルとして表示します。ゲートウェイは `[1m]` エントリをチェックせずに提供するため、上流が 1M で処理するモデルに対してのみ追加してください。

この例では、アプリケーション推論プロファイルにルーティングされるカスタムエイリアスについてオプションを手動で提供し、新しいユーザーをそのオプションで開始させます：

```yaml theme={null}
models:
  - id: corp-sonnet
    upstream_model:
      bedrock: arn:aws:bedrock:us-east-2:123456789012:application-inference-profile/sonnet-5-prod
  - id: corp-sonnet[1m]
    upstream_model:
      bedrock: arn:aws:bedrock:us-east-2:123456789012:application-inference-profile/sonnet-5-prod

managed:
  policies:
    - match: {}
      desktop:
        modelPrefer1mContext: true
```

<h5 id="remove-the-1m-option">
  1M オプションを削除する
</h5>

ピッカーからオプションを削除するには、ポリシーの `cli` キーの下の `env` ブロックで `CLAUDE_CODE_DISABLE_1M_CONTEXT: "1"` を設定します。`id` が `[1m]` で終わるエントリもリストしていた場合、ゲートウェイは引き続きそれを提供するため、そのエントリも削除してください。

この変数は、ポリシーがマッチするデベロッパーのターミナルセッションにも届きます。そこで何が変わるかについては、[拡張コンテキスト](/docs/ja/model-config#extended-context) を参照してください。

<h4 id="precedence-with-other-managed-sources">
  他の管理ソースとの優先順位
</h4>

デバイスに MDM で配信されたポリシーやローカルの `managed-settings.json` もある場合、ゲートウェイで配信された設定が最優先になります。管理設定ページの [管理層内の優先順位](/docs/ja/managed-settings#precedence-within-the-managed-tier) には、ローカルソースが適用される場合と、サンドボックスロックキー、`forceRemoteSettingsRefresh`、変数ごとの `env` マージなど、どのソースを選択したかに関わらず [Claude Code がすべての管理ソースから読み取るキー](/docs/ja/managed-settings#keys-read-from-every-admin-source) が記載されています。MDM プロファイルまたは管理設定ファイルで設定された [`policyHelper`](/docs/ja/settings-reference#policyhelper) は、ゲートウェイが設定を配信しない場合にのみ実行されます。そのエントリには、その出力が何を置き換えるかが記載されています。

[Claude Desktop](/docs/ja/desktop) などの埋め込みホストは、SDK の `managedSettings` オプションを通じてポリシーを提供できます。[埋め込みホストからの親設定](/docs/ja/managed-settings#parent-settings-from-embedding-hosts) には Claude Code がそれを適用する場合が、[親設定を制限する](/docs/ja/claude-apps-gateway#restrict-parent-settings) には `allowManaged*Only` ロックがなくても適用される許可方向の設定がリストされています。

ゲートウェイポリシーは、非インタラクティブな `claude -p` 実行や Agent SDK によって生成されたセッションを含め、マシン上のすべての Claude Code 呼び出しに適用されます。起動時にゲートウェイに到達できない場合、サインイン済みセッションはポリシーなしで実行されるのではなく、エラーで終了します。

<h3 id="telemetry">
  `telemetry`
</h3>

CLI はメトリクス、ログ、および有効な場合はトレースをゲートウェイに送信し、ゲートウェイはそれらをそのまま各設定済みの宛先にリレーします。エクスポートは HTTP 上の OpenTelemetry Protocol（OTLP）を使用します。リレーをスキップしてセッションからコレクターに直接エクスポートするには、[ポリシーでコレクターを指定](#export-directly-to-your-collector) します。CLI が出力するメトリクスとイベントについては [使用状況の監視](/docs/ja/monitoring-usage) を参照してください。

`/login` でサインインしたセッションでは、CLI はゲートウェイが発行した JWT から読み取った認証済みユーザーのアイデンティティ（`user.id`、`user.email`、`user.groups` 属性）を各エクスポートに付与します。そのため、デベロッパー側の設定なしで、デベロッパーごとのコストと使用状況の帰属が機能します。デベロッパーがサインインする前に Claude Code がログに記録するイベントには、[このアイデンティティは含まれません](/docs/ja/monitoring-usage#standard-attributes)。

ゲートウェイでサインインした [Claude Desktop](#claude-desktop-overlay) と Cowork のセッションは、テレメトリに `enduser.id` とともに `user.email` と `user.groups` を付与するため、`user.email` または `user.groups` に対する 1 つのクエリでターミナル、Desktop、Cowork の使用状況をカバーできます。`user.groups` はコンマ区切りの IdP グループリストです。

Desktop と Cowork のテレメトリには `enduser.sub` も含まれます。これはアイデンティティプロバイダーがユーザーに対して発行する `sub` クレームであり、ユーザーのメールが変わっても同じままです。ターミナルセッションは同じ値を `user.id` として付与するため、`enduser.sub` をターミナルの `user.id` とマッチングするクエリで、1 人のユーザーのターミナル、Desktop、Cowork の使用状況をまとめてカバーできます。Desktop と Cowork のエクスポートでは、`user.id` はサブジェクトではなく匿名の識別子です。

Claude Code からのすべての OpenTelemetry データと同様に、これらの属性は組織が設定した宛先にのみ送信され、Anthropic には送信されません。

ユーザーのグループリストがパーセントエンコード後に 255 文字を超える場合、またはグループ名にコンマや等号が含まれる場合、ゲートウェイは切り詰めるのではなく、そのユーザーの Desktop と Cowork のテレメトリから `user.groups` を除外します。そのユーザーのターミナルセッションには引き続き完全なリストが含まれます。

サブジェクトがパーセントエンコード後に 255 文字を超える場合、またはスペース、印字可能 ASCII 以外の文字、あるいは `,` `;` `=` `\` `"` `%` のいずれかを含む場合、ゲートウェイは `enduser.sub` を除外します。そのユーザーの Desktop と Cowork のテレメトリには他の属性が残ります。

Desktop と Cowork のテレメトリに `user.email` と `user.groups` を付与するにはゲートウェイサーバー上の Claude Code v2.1.265 以降が、`user.groups` には各デベロッパーのマシン上の Claude Desktop 1.24012 以降が必要です。

`enduser.sub` には、ゲートウェイサーバー上の Claude Code v2.1.274 以降が必要です。

```yaml theme={null}
telemetry:
  forward_to:
    - url: https://otel-collector.internal.example.com
      headers:
        Authorization: ${OTLP_TOKEN}
      # Per-signal opt-in. Default: metrics only.
      metrics: true
      logs: false
      traces: false
    - url: https://api.datadoghq.com/api/v2/otlp
      headers:
        DD-API-KEY: ${DD_API_KEY}
```

<Warning>
  各宛先は `metrics`、`logs`、`traces` に個別にオプトインし、デフォルトはメトリクスのみです。シグナルごとに機密性が異なります：

  * **メトリクス**：トークン数、リクエスト数、レイテンシーなどの集計カウンター
  * **ログとトレース**：完全な Bash コマンド、ツール入力、ファイルパスを含むことがあり、Claude Code がデベロッパーのマシンで行うあらゆることをカバーします

  ログとトレースは、そのデータに必要なアクセス制御と保持ポリシーを備えた宛先でのみ有効にしてください。
</Warning>

各 `forward_to` URL は `https://` を使用する必要があります。ただし、ゲートウェイ自身のループバックインターフェイス上のコレクターについては 1 つの例外があります：

* `http://localhost:<port>` は設定検証を通過しますが、ゲートウェイの環境で `CLAUDE_GATEWAY_ALLOW_LOOPBACK=1` を設定しない限り、[SSRF ガード](/docs/ja/claude-apps-gateway-deploy#threat-model-summary) がすべてのエクスポートを `ECONNREFUSED_SSRF` でブロックします
* `http://127.0.0.1:<port>` または `http://[::1]:<port>` は、その変数が設定されていない限りブートが失敗します

クラスター内コレクターの場合は、独自の内部アドレスで HTTPS で公開するか、変数を設定したサイドカーとして実行してください。

`HTTPS_PROXY` が設定されている場合、ゲートウェイはそのプロキシを通じてエクスポートを送信します。

内部コレクターに直接到達するには、ホスト名、または `.internal.example.com` のような先頭にドットを付けたドメインで `NO_PROXY` に追加します。これにはゲートウェイサーバー上の Claude Code v2.1.277 以降が必要です。ゲートウェイがプロキシなしでコレクターに到達できることを確認してください。先頭にドットのないエントリは、その下の名前ではなく、その正確な名前のみにマッチします。CIDR 範囲はマッチしません。

[プロキシのみの出力](#proxy-only-egress) がオンの場合は、代わりにプロキシでコレクターを許可してください。`NO_PROXY` エントリがあるとプロキシのみの出力がオフのままになるためです。

テレメトリは CLI ではデフォルトでオフです。`telemetry.forward_to` と `listen.public_url` の両方を設定すると、ゲートウェイは `/managed/settings` を通じて 6 つの環境変数をプッシュし、接続されたクライアントのテレメトリをオンにします：

* `CLAUDE_CODE_ENABLE_TELEMETRY=1`
* `OTEL_METRICS_EXPORTER`、`OTEL_LOGS_EXPORTER`、`OTEL_TRACES_EXPORTER`。少なくとも 1 つの `forward_to` 宛先がそのシグナルを有効にしている場合は `otlp` に、そうでない場合は `none` に設定されます
* `OTEL_EXPORTER_OTLP_ENDPOINT=<public_url>`
* `OTEL_EXPORTER_OTLP_PROTOCOL=http/protobuf`

[独自のラベルを追加](#add-your-own-labels) した場合、ゲートウェイは `OTEL_RESOURCE_ATTRIBUTES` もプッシュします。

ゲートウェイサーバー上の Claude Code v2.1.265 より前では、ゲートウェイは、どの宛先もオプトインしていないシグナルも含め、3 つのエクスポーターセレクターすべてを `otlp` としてプッシュしていました。

プッシュされるエンドポイントはパブリック URL から構築されるため、メトリクスとログにはデベロッパーやポリシーからの OTEL 設定は不要です。

`/login` でサインインしたデベロッパーは、独自の OTEL 設定でエクスポートをリダイレクトできません：

* **ローカルで設定された変数**：Claude Code はプッシュされた変数を管理層で適用するため、それぞれがデベロッパーがローカルで設定した値を上書きします。
* **ローカルで設定されたエンドポイント**：OTLP/HTTP エクスポートが有効な場合、ゲートウェイがテレメトリ変数をプッシュしたかどうかに関わらず、CLI はローカルで設定されたエンドポイントを無視します。ポリシーが [コレクターをエンドポイントとして指定](#export-directly-to-your-collector) しない限り、エクスポートはゲートウェイに送られます。

シグナルの `forward_to` 宛先がない場合、ゲートウェイはそれを受け入れて破棄します。デベロッパーが既に Claude Code のテレメトリをいずれかのコレクターにエクスポートしている場合は、サインイン後もそのコレクターがデータを受け取り続けるように、それを `forward_to` 宛先として追加し、ログやトレースをエクスポートしている場合はそれらも有効にしてください。代わりにリレーをスキップするには、[ポリシーでコレクターを指定](#export-directly-to-your-collector) します。

[トレース](/docs/ja/monitoring-usage#traces-beta) には、各クライアントで `CLAUDE_CODE_ENHANCED_TELEMETRY_BETA=1` も必要です。ゲートウェイはこれをプッシュしないため、管理ポリシーの `env` ブロックで設定してください。デベロッパーは、プッシュされたエンドポイントで既に表示される同じ [セキュリティ承認ダイアログ](#managed) でこれを承認します。

トレースしたいグループのポリシーでのみ `1` に設定してください。これを設定しないポリシーは、[マージルール](#managed) に従い、`match: {}` キャッチオールポリシーが値を設定していればその値を継承します。デベロッパーがローカルで変数を設定してもグループのクライアントからトレースが送信されないようにするには、そのグループのポリシーで `0` に設定してください。

protobuf と JSON の両方の OTLP エンコーディングがリレーされ、OpenTelemetry 互換の任意のバックエンドを宛先として使用できます。

<h4 id="add-your-own-labels">
  独自のラベルを追加する
</h4>

ゲートウェイでサインインしたセッションのテレメトリに `service.namespace` や `deployment.environment.name` などの固定ラベルを付けるには、`telemetry.resource_attributes` を設定します。各ラベルは OpenTelemetry のリソース属性であり、すべての宛先が同じラベルを受け取ります。

セッションがラベルを受け取るのは、`telemetry.forward_to` と `listen.public_url` も設定している場合のみです。この例では 2 つのラベルを追加します：

```yaml theme={null}
telemetry:
  forward_to:
    - url: https://otel-collector.internal.example.com
  resource_attributes:
    service.namespace: claude
    deployment.environment.name: prod
```

ラベルが次のいずれかのルールに違反すると、ゲートウェイは起動を拒否し、起動エラーでそのラベルを示します：

* 名前には文字、数字、`.`、`_`、`-` のみを使用する
* 名前は予約されていない。大文字小文字を区別せずに比較した場合、予約名は `user.`、`enduser.`、`identity.` で始まるすべての名前と、`service.name`、`service.version`、`claude.deployment_mode`、`host.arch`、`os.type`、`os.version`、`wsl.version` です
* 値は空でない印字可能 ASCII で、スペースと `, ; = \ " %` のいずれも含まない
* 値はゲートウェイがパーセントエンコード後にカウントして最大 255 文字。そのため `/`、`:`、`@` はそれぞれ 3 文字としてカウントされます
* 値はテキストであるため、数値、`true`、`false` は引用符で囲む

`telemetry.resource_attributes` を設定するには、ゲートウェイサーバー上の Claude Code v2.1.281 以降が必要です。以前のゲートウェイはキーを見つけると起動を拒否します。キーを追加する前にすべてのレプリカをアップグレードし、以前のバージョンにロールバックする前にキーを削除してください。

`/login` でサインインしたターミナルセッションは、他の [テレメトリ変数](#telemetry) とともにプッシュされる `OTEL_RESOURCE_ATTRIBUTES` としてラベルを受け取ります。ポリシーの `env` ブロックで `OTEL_RESOURCE_ATTRIBUTES` を設定した場合、そのポリシーがマッチするターミナルセッションはラベルの代わりにその値を受け取ります。Claude Desktop は、`user.email` やその他のアイデンティティ属性とともにゲートウェイからラベルを受け取ります。

Claude Code は各ラベルをすべてのメトリクスデータポイントにもコピーするため、リソース属性をインデックス化しないバックエンドでもラベルでメトリクスをフィルタリングできます。このコピーをオフにするには、[メトリクスのカーディナリティ制御](/docs/ja/monitoring-usage#metrics-cardinality-control) を参照してください。

<h4 id="export-directly-to-your-collector">
  コレクターに直接エクスポートする
</h4>

`/login` でサインインしたセッションからリレーを経由せずにコレクターに直接テレメトリを送信するには、[管理ポリシー](#managed) の `env` ブロックで `OTEL_EXPORTER_OTLP_ENDPOINT` をコレクターの `https://` ベース URL に設定します。Claude Code は `https://otel-collector.example.com:4318` のように設定した URL に `/v1/metrics`、`/v1/logs`、または `/v1/traces` を付加し、各シグナルを OTLP/HTTP でそこにエクスポートします。各デベロッパーのマシン上の Claude Code v2.1.265 以降が必要です。以前のクライアントはリレー経由でエクスポートします。

コレクターへの認証には、同じ `env` ブロックで `OTEL_EXPORTER_OTLP_HEADERS` を設定します。セッションは、この方法で指定されたコレクターにデベロッパーのゲートウェイセッショントークンを送信することはありません。

ポリシーでこのエンドポイントを追加または変更すると、Claude Code はインタラクティブセッションで適用する前に、[セキュリティ承認ダイアログ](#managed) で各デベロッパーに承認を求めます。

Claude Code はシグナルを直接エクスポートする前にエンドポイントをチェックし、チェックに失敗した場合はそのシグナルをリレーに残します。チェックには次のものが含まれます：

* エンドポイントがゲートウェイ自体から来ていること。MDM プロファイルやローカルの `managed-settings.json` で同じ変数を設定した場合、エクスポートはリレーに残ります。
* URL が `https://`、またはループバックアドレスへの `http://` を使用していること
* URL が `/v1/<signal>` で終わるパスに解決され、クエリやフラグメントがないこと。Claude Code は汎用変数からこのパスを自身で構築します。`OTEL_EXPORTER_OTLP_METRICS_ENDPOINT` などのシグナルごとの変数は記述どおりに使用するため、そこには完全なパスを含めてください。
* URL がゲートウェイ自身のホストではないこと。ゲートウェイ宛てのエンドポイントはリレーパスとそのセッショントークンを維持します。
* 管理者とデベロッパーのどちらも、いずれの設定ソースでも [`otelHeadersHelper`](/docs/ja/settings-reference#otelheadershelper) を設定していないこと。ヘルパーが設定されている場合、すべてのシグナルはリレーに残ります。

指定したエンドポイントによって変わるのはエクスポート先のみです。どのシグナルをエクスポートするかは、引き続き `OTEL_*_EXPORTER` セレクターで選択します。

エンドポイントだけではエクスポートはオンにならないため、ゲートウェイが既にプッシュしていない限り、エクスポートをオンにする変数も設定してください：

* ゲートウェイが既に [テレメトリ変数をプッシュ](#telemetry) している場合、それらが有効化、セレクター、プロトコルをカバーし、明示的に指定したエンドポイントがプッシュされた `<public_url>` 値を上書きします。`OTEL_*_EXPORTER` セレクターを自分で `otlp` に設定するのは、どの `forward_to` 宛先も有効にしていないシグナルについてのみです。
* プッシュしていない場合は、`CLAUDE_CODE_ENABLE_TELEMETRY=1`、`OTEL_*_EXPORTER` セレクター、`OTEL_EXPORTER_OTLP_PROTOCOL=http/protobuf` も設定してください。

デベロッパーがサインアウトするか別のゲートウェイにサインインすると、コレクターへのエクスポートは停止し、Claude Code は残りの各バッチを送信せずに破棄します。

<h4 id="when-a-destination-fails">
  宛先が失敗した場合
</h4>

ゲートウェイはテレメトリのバッファリング、再試行、保存を行わないため、宛先に届かなかったエクスポートは後から配信されるのではなく破棄されます。各宛先は個別に成功または失敗し、エクスポート元のクライアントはどちらの場合も成功レスポンスを受け取るため、配信の失敗はゲートウェイのログにのみ表示されます。

宛先への配信が 5 回連続で失敗すると、ゲートウェイは配信が成功するまで、その宛先への転送を 30 秒ずつ一時停止し、各一時停止をログに記録します。エラーレスポンス、タイムアウト、接続エラーはいずれも配信失敗としてカウントされます。ただし、`400`、`413`、`415`、`422`、`431` は除きます。これらは、コレクターがそのエクスポートのペイロードを不正な形式または大きすぎるとして拒否したことを意味します。

拒否されたペイロードは失敗カウントを進めることもリセットすることもありません：ゲートウェイはその宛先への転送を続け、宛先の最初の拒否とその後 100 回ごとに、宛先とステータスを示す警告をログに記録します。

<h3 id="http-tuning">
  HTTP チューニング
</h3>

4 つのオプションのトップレベルブロック `access_control`、`limits`、`timeouts`、`rate_limits` で HTTP サーフェスをチューニングします。デフォルトはほとんどのデプロイに適しています。

| ブロック | キー | デフォルト | 説明 |
| - | - | - | - |
| `access_control` | `allow_cidrs` / `deny_cidrs` | 空 | `trusted_proxies` による解決後のクライアントアドレスによるインバウンド IP の許可/拒否。`deny_cidrs` が最初にチェックされ、それにマッチするクライアントは `allow_cidrs` にもマッチしても拒否されます。`allow_cidrs` が空でない場合、ゲートウェイはデフォルト拒否になります。`/healthz` と `/readyz` は `allow_cidrs` の対象外です。信頼されたプロキシが IP アドレスではない `X-Forwarded-For` エントリを送信した場合、実際のクライアントは不明となり、ゲートウェイは確認すべき内容を示す警告を 1 回ログに記録します。いずれかのリストがリクエストに適用される場合は、`403` と監査理由 `xff_unparseable` でリクエストを拒否します。どちらも適用されない場合は、リクエストを処理し、IP ごとのレート制限と監査のクライアント IP としてプロキシ自身のアドレスを使用します。 |
| `limits` | `max_request_bytes` | 32 MiB | インバウンドリクエストボディの最大サイズ。サイズを超えたリクエストはボディがバッファリングされる前に `413` を受け取ります。大きなファイルや画像のリクエストの場合は上げてください。 |
| `limits` | `max_request_header_bytes` | 未設定 | リクエストのヘッダー全体に対するゲートウェイの 256 KiB の制限を引き下げます。制限を超えたリクエストは `431` を返し、256 KiB を超える値は効果がありません。サインイン後にデベロッパーが `431` を受け取る場合は、[サインイン後にリクエストヘッダーが大きすぎる](/docs/ja/claude-apps-gateway-deploy#request-headers-too-large-after-sign-in) を参照してください。 |
| `limits` | `max_url_length` | 未設定 | 設定されている場合、長すぎる URL は `414` を返します |
| `timeouts` | `upstream_ttfb_ms` | 120000 | 上流のレスポンスヘッダーの最大待機時間（最初のバイトまでの時間）。その後、レスポンスボディは経過時間の上限なしでストリーミングされます。直接 Anthropic 上流パスに適用されます。他のすべてのプロバイダーでは、ゲートウェイはレスポンスが開始されるまで最大 1 時間待機します。 |
| `rate_limits` | `device_authorization.max` / `.window_seconds` | 30 / 600 | 認証されていないデバイス認可エンドポイントの IP ごとのレート制限。共有出力 IP や NAT の背後にある大規模な組織の場合は上げてください。サイズの決め方は [大規模ロールアウト](/docs/ja/claude-apps-gateway-deploy#large-rollouts) を参照してください。これらの制限はデバイスグラントのサインインフローにのみ適用され、`/v1/messages` の推論には適用されません。[ユーザーコードのブルートフォース耐性](/docs/ja/claude-apps-gateway-deploy#user-code-brute-force-resistance) を参照してください。 |
| `rate_limits` | `device_verify.max` / `.window_seconds` | 10 / 600 | `/device` での `user_code` 送信の IP ごとのレート制限。他のデベロッパーのコードの推測を防ぐものです。どこまで上げるかについては [大規模ロールアウト](/docs/ja/claude-apps-gateway-deploy#large-rollouts) を参照してください。 |

デフォルトのように両方の `access_control` リストを空のままにすると、ゲートウェイはすべてのクライアントアドレスにサービスを提供するため、ゲートウェイに到達できるユーザーを制限するのはネットワークのみになります。ゲートウェイはデベロッパーのマシンでコマンドを実行する [管理設定](#managed) をプッシュできるため、これは重要です。

`allow_cidrs` が空の間、ゲートウェイはリクエストへの応答方法を変えずに、2 か所で警告します：

* **ブート時**：運用ログの警告で、プライベート範囲 `10.0.0.0/8`、`172.16.0.0/12`、`192.168.0.0/16`、`100.64.0.0/10`、`127.0.0.0/8`、`::1/128`、`fc00::/7` と、デベロッパーが接続元とするその他の内部範囲のみを許可することを推奨します。ローカル開発のように、ゲートウェイをループバックアドレスにバインドし、`trusted_proxies` も `public_url` も設定していない場合、この警告は表示されません。
* **実行時**：これらのプライベート範囲外のアドレスから初めてリクエストが届いたとき、ゲートウェイは警告をログに記録し、クライアント IP を含む [`access.public_client` 監査イベント](/docs/ja/claude-apps-gateway-deploy#logs) を発行します。どちらもプロセスごとに 1 回発生します。リンクローカルアドレス `169.254.0.0/16` と `fe80::/10` はパブリックとしてカウントされません。ゲートウェイはこのチェックの実行前に `/healthz` と `/readyz` に応答するため、パブリック範囲からのヘルスプローブではトリガーされません。

どちらのシグナルも、ゲートウェイが解決したクライアントアドレスを使用します。ロードバランサー、ポートフォワード、またはトンネルがトラフィックをリレーしていて、`listen.trusted_proxies` にリストされていない場合、ゲートウェイにはリレーのアドレス（通常はプライベート）が見えるため、実行時の警告もプライベートの許可リストも、それを経由してリレーされたトラフィックを検出できません。

そのようなフロントエンドの背後では、まず [`listen.trusted_proxies`](#listen) を設定してゲートウェイが実際のクライアントアドレスを見られるようにし、いずれにしてもゲートウェイとその前段にあるすべてのものをパブリックインターネットから到達できないようにしてください。

<h3 id="load_test_mode">
  `load_test_mode`
</h3>

`load_test_mode` ブロックを使用すると、モデルプロバイダーを呼び出さずにゲートウェイをロードテストできます。このモードがオンの間、ゲートウェイは各プロバイダーリクエストを通常どおり構築して署名しますが、送信せずに破棄し、通常のレスポンスパスを通じて定型の返信をストリーミングで返します。返信は、定型であることを示す文で始まるフィラーテキストです。

ゲートウェイサーバー上の Claude Code v2.1.282 以降が必要です。以前のゲートウェイはキーを見つけると起動を拒否します。ブロックを追加する前にすべてのレプリカをアップグレードし、ロールバックする前にブロックを削除してください。

以下の例は、デフォルト値（約 10 秒かけてストリーミングされる約 750 トークンのテキストの返信）でモードをオンにします：

```yaml theme={null}
load_test_mode:
  enabled: true
  reply_tokens: 750     # roughly how many tokens of text each canned reply carries
  reply_seconds: 9.5    # how long a streamed reply takes
```

| フィールド | 必須 | 説明 |
| - | - | - |
| `enabled` | はい | `true` でモードをオンにします。`false` にすると、モードをオフにしたままファイルに数値を残せます。ブロックがあってこのフィールドがない場合、ゲートウェイは起動を拒否します。 |
| `reply_tokens` | いいえ | デフォルト `750`。各定型返信に含まれるテキストのおおよそのトークン数で、1 から 100000 までの整数です。 |
| `reply_seconds` | いいえ | デフォルト `9.5`。ストリーミング返信にかかる時間で、0 から 600 までです。`0` は返信全体を一度に送信します。非ストリーミングリクエストへの返信は常に一度に返されます。 |

このモードでのロードテストは、ゲートウェイ、Postgres、およびゲートウェイの前段にあるすべてのものをカバーします。プロバイダーの制限、速度、ネットワークパスはカバーしません。

プロバイダーにはモデルリクエストが送信されないため、レプリカのリクエストあたりの CPU は見積もりであり、プロバイダーへのトラフィックも暗号化する本番環境より低く表示されます。レプリカ数は、実際のプロバイダーに対する小規模なパイロットで確認してください。v2.1.283 より前では、見積もりはさらに大幅に低く表示されます。

モードがオンの間、リクエストに最大 7 桁の整数を含む `x-load-test-user` ヘッダーを付けることができます。ゲートウェイは各数値を別々のデベロッパーとしてカウントし、リクエストに付随したトークンのデベロッパーのメールとグループを使用します。

ロードテスト用のデプロイには専用の空のデータベースを用意してください。いずれかのデベロッパーが既に支出しているデータベースに対してモードをオンにすると、ゲートウェイは起動を拒否するためです。

<Warning>
  デベロッパーが使用するゲートウェイでは絶対にこれをオンにしないでください。すべてのリクエストが定型の返信を受け取り、モデルは呼び出されません。モードがオンの間、ゲートウェイはブート時に `load_test_mode is on` 警告をログに記録し、各 `inference` [監査イベント](/docs/ja/claude-apps-gateway-deploy#logs) に `load_test: true` を付けます。
</Warning>

<h2 id="complete-example">
  完全な例
</h2>

この完全なリファレンス設定は、すべてのコアセクションを実行します。[HTTP チューニングブロック](#http-tuning)はデフォルト値を保持します。これをコピーして、不要な部分を削除し、値を入力してください。[クイックスタート](/docs/ja/claude-apps-gateway#quickstart)の設定は、これの最小限のバージョンです。

```yaml gateway.yaml theme={null}
# Run with:
#   claude gateway --config gateway.yaml
#
# Operational log verbosity is controlled by the CLAUDE_GATEWAY_LOG_LEVEL
# environment variable (debug | info | warn | error; default info). debug
# also logs the claim names in each id_token, for groups_claim diagnosis.
# It does not affect audit events, which are always emitted.

listen:
  host: 0.0.0.0
  port: 8080
  public_url: https://claude-gateway.internal.example.com
  # Omit the tls block when running behind a TLS-terminating ingress.
  # tls:
  #   cert: /certs/gateway.crt
  #   key: /certs/gateway.key
  # trusted_proxies:
  #   - 10.0.0.0/8

oidc:
  issuer: https://example.okta.com
  client_id: 0oa1example2
  client_secret: ${OIDC_CLIENT_SECRET}
  allowed_email_domains:
    - example.com
  # Required when the issuer is the Okta org server, whose id_tokens
  # can omit email and groups; the gateway fills them from /userinfo.
  userinfo_fallback: true
  # allowed_groups: [claude-code-users]
  # Okta emits groups only when the `groups` scope is requested and the
  # app's groups claim filter allows them. The contractors policy below
  # matches on groups, so the scope is requested here.
  scopes: [openid, profile, email, offline_access, groups]
  # extra_auth_params: { access_type: offline, prompt: consent }  # Google
  # groups_claim: groups          # Entra app roles: use `roles`
  # email_claim: email

session:
  jwt_secret: ${GATEWAY_JWT_SECRET}   # openssl rand -base64 32
  # ttl_hours: 1

store:
  postgres_url: ${GATEWAY_POSTGRES_URL}
  # max_connections: 5
  # connect_timeout_seconds: 5
  # readiness_grace_seconds: 300   # keep passing the readiness check through a database failover

# Enables /v1/organizations/spend_limits (mirrors the Anthropic Admin API)
# and per-developer spend enforcement on /v1/messages. Omit to disable.
# Caps themselves are set via the admin API, not here.
# admin:
#   write_keys:
#     - { id: terraform, key: "${GATEWAY_ADMIN_WRITE_KEY_TF}" }
#   read_keys:
#     - { id: reporting, key: "${GATEWAY_ADMIN_READ_KEY}" }
#   admin_groups: [platform-finops]
#   blocked_message: request an increase at https://go.example.com/claude-limits
#   # audit_retention_days: 365
#   # spend_retention_months: 13
#   # identity_retention_days: 90
#   # group_limit_mode: min

# enforcement:
#   fail_closed_on_error: false

# Load test this deployment without calling a model provider. Never on a
# gateway that developers use: every request gets a canned reply.
# load_test_mode:
#   enabled: true
#   # reply_tokens: 750
#   # reply_seconds: 9.5

# Meter at contracted rates instead of USD list price. Requires admin: or a
# managed: policy. With managed:, the same rates also go to signed-in clients.
# Rates below are placeholders, not real contract prices.
# pricing:
#   multiplier: 0.85
#   overrides:
#     - { upstream: anthropic, model: claude-sonnet-4-6, input: 3.30, output: 16.50, cache_read: 0.33, cache_write: 4.125 }

upstreams:
  - provider: anthropic
    auth:
      api_key: ${ANTHROPIC_API_KEY}

  # - provider: bedrock
  #   region: us-east-1
  #   auth: {}

  # - provider: mantle
  #   region: us-east-1
  #   models: [claude-opus-4-8, claude-opus-4-7, claude-haiku-4-5]
  #   auth: {}

  # - provider: anthropicAws
  #   region: us-east-1
  #   workspace_id: wrkspc_...
  #   auth:
  #     api_key: ${ANTHROPIC_AWS_API_KEY}

  # - provider: vertex
  #   region: us-east5
  #   project_id: example-prod
  #   auth: {}

  # - provider: foundry
  #   resource: example-foundry
  #   auth: { use_azure_ad: true }

auto_include_builtin_models: true
models:
  - id: claude-opus-4-8
    label: Claude Opus 4.8
    upstream_model:
      anthropic: claude-opus-4-8
      # bedrock: us.anthropic.claude-opus-4-8
      # mantle: anthropic.claude-opus-4-8
      # anthropicAws: claude-opus-4-8
      # vertex: claude-opus-4-8
      # foundry: <your-opus-deployment-name>
  - id: claude-sonnet-4-6
    label: Claude Sonnet 4.6
    upstream_model:
      anthropic: claude-sonnet-4-6
  - id: claude-haiku-4-5
    label: Claude Haiku 4.5
    upstream_model:
      anthropic: claude-haiku-4-5

managed:
  policies:
    - match: { groups: [contractors] }
      cli:
        availableModels: [claude-haiku-4-5]
        # allow auto-approves these tools; it does not block the rest.
        # Add deny rules to restrict tools.
        permissions: { allow: [Read, Grep] }
    - match: {}
      cli:
        availableModels: [claude-opus-4-8, claude-sonnet-4-6, claude-haiku-4-5]
        # Constrain the Default picker option to each policy's availableModels
        # instead of the built-in default, so no role gets a 400 on Default.
        # The contractors policy inherits this key.
        enforceAvailableModels: true
        permissions:
          allow: [Read, Grep, Bash, Edit]
          deny: ["WebFetch"]
        env: { HTTP_PROXY: http://proxy.example.com:8080 }

telemetry:
  forward_to:
    - url: https://otel.internal.example.com:4318
      headers:
        Authorization: Bearer ${OTEL_TOKEN}
```

<h2 id="client-side-managed-settings">
  クライアント側で管理される設定
</h2>

上記のすべてはゲートウェイサーバーを設定します。開発者マシンはゲートウェイに別途ポイントし、各デバイスで Claude Code の[管理設定](/docs/ja/managed-settings)を通じて設定します。ゲートウェイはログインキー自体をプッシュできません。これらのキーがクライアントにゲートウェイの場所を伝えるためです。

CLI の場合、OS ごとの `managed-settings.json` でこれらのキーを設定します。2 つのログインキーは各開発者の `/login` をゲートウェイにルーティングします。

```json theme={null}
{
  "forceLoginMethod": "gateway",
  "forceLoginGatewayUrl": "https://claude-gateway.internal.example.com",
  "parentSettingsBehavior": "merge"
}
```

`parentSettingsBehavior: "merge"` は Claude Desktop の出力許可リストの配信を埋め込み Claude Code セッションで機能させ続けます。[Claude Desktop セッションにポリシーを配信する](/docs/ja/claude-apps-gateway#deliver-policy-to-claude-desktop-sessions)はメカニズムと opt-in が配置される場所を説明しています。

開発者がクラウドプロバイダー変数または独自の `ANTHROPIC_BASE_URL` でゲートウェイをバイパスするのを防ぐには、同じファイルに `"allowedProviders": ["gateway"]` を追加します。Claude Code はその後、マシン上でクラウドゲートウェイ用に設定されていないすべてのセッションを拒否し、`forceLoginGatewayUrl` が指定するゲートウェイ、またはファイルの `env` ブロックが `ANTHROPIC_BASE_URL` として設定する URL を持つゲートウェイのみを認めます。`claude gateway` はこのリストを設定するマシンでの実行を拒否するため、ゲートウェイホストではこのキーをオフのままにしてください。設定リファレンスの [`allowedProviders`](/docs/ja/settings-reference#allowedproviders) エントリを参照してください。Claude Code v2.1.285 以降が必要です。

`managed-settings.json` ファイルを各デバイスにデプロイします。通常は MDM プラットフォーム経由です。ファイルパスはプラットフォームによって異なります。[各メカニズムがポリシーを保存する場所](/docs/ja/managed-settings#where-each-mechanism-stores-the-policy)を参照してください。

デフォルトでは、Windows のレジストリポリシーまたは macOS のマネージドプリファレンス plist は、[上記の例外キーとクロスソースチェック](#precedence-with-other-managed-sources)を除き、`managed-settings.json` ファイルとマージするのではなく置き換えます。このスニペットの 3 つのキーはすべて最優先ソースルールに従うため、Group Policy または設定プロファイルを通じてポリシーを配信するフリートは、代わりにそのメカニズムにすべての 3 つを配置する必要があります。

Claude Desktop の場合、Claude Desktop 独自の[マネージド設定](https://claude.com/docs/third-party/claude-desktop/configuration)で `bootstrapUrl` キーを `<listen.public_url>/user/bootstrap` に設定します。サインインフロー及びグループごとのポリシーは、ポリシーが `desktop` キーでサーバー側で opt-in した後、CLI のものと一致します。opt-in がない場合、`/user/bootstrap` は 404 を返します。[Claude Desktop オーバーレイ](#claude-desktop-overlay)でサーバー側の半分を参照してください。

Claude Code は [`forceLoginGatewayUrl`](/docs/ja/settings-reference#forcelogingatewayurl)、[`gatewayInternalNetworks`](/docs/ja/settings-reference#gatewayinternalnetworks)、および [`forceLoginMethod`](/docs/ja/settings-reference#forceloginmethod) の `"gateway"` 値をマシン上のマネージドソースからのみ認識します。`managed-settings.json`、macOS plist または Windows HKLM レジストリ、またはポリシーヘルパーです。開発者が独自の `~/.claude/settings.json` でこれらを設定しても効果がなく、ゲートウェイペイロードで設定しても同様です。

`forceLoginMethod` と `forceLoginOrgUUID` をペイロードから除外してください。Claude Code はスタートアップ認証情報チェックのためにペイロードから両方のキーを読み込みます。そのため、Anthropic が発行した認証情報をマシンに保持している開発者は、サインイン後でも[管理者ポリシーがクラウドゲートウェイサインインを必要とする](/docs/ja/errors#administrator-policy-requires-a-cloud-gateway-sign-in)の下で説明されているスタートアップ終了を取得します。

<h2 id="related">
  関連
</h2>

* [Claude apps gateway 概要](/docs/ja/claude-apps-gateway)：クイックスタートと開発者接続
* [デプロイメントガイド](/docs/ja/claude-apps-gateway-deploy)：IdP セットアップ、コンテナイメージ、Kubernetes と Cloud Run、運用
* [支出制限](/docs/ja/claude-apps-gateway-spend-limits)：開発者ごとのキャップと Admin API
