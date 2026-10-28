> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# Claude apps gateway 設定

> gateway.yaml のすべてのオプションのリファレンス：リスナーと TLS、OIDC、セッション、Postgres ストア、Amazon Bedrock、Claude Platform on AWS、Google Cloud の Agent Platform、Microsoft Foundry アップストリーム、モデルルーティング、マネージドポリシー、テレメトリー。

Claude apps gateway デプロイメントは、慣例的に `gateway.yaml` という 1 つの YAML ファイルで設定されます。このファイルは、ゲートウェイが行うすべてのことを定義します：どこでリッスンするか、開発者がどのようにサインインするか、推論がどこに行くか、どのポリシーとテレメトリーが適用されるかです。このページは、そのファイル内のすべてのオプションのリファレンスです。最初のファイルを作成するには、[クイックスタート](https://code.claude.com/docs/ja/claude-apps-gateway#quickstart)から始めてください。これは最小限の動作設定を構築して実行します。設定に満足したら、[デプロイメントガイド](https://code.claude.com/docs/ja/claude-apps-gateway-deploy.md)で、Kubernetes、Cloud Run、または独自のプラットフォームでのコンテナ化とホスティングについて説明しています。

ゲートウェイは、`claude gateway --config /path/to/gateway.yaml` でスタートアップ時にファイルを 1 回読み込みます。すべてのオプションはブート時にスキーマに対して検証されるため、形式が正しくない設定は、最初の使用時ではなく、フィールドレベルのエラーで開始時に失敗します。

このページの最後にある[完全な例](#complete-example)は、すべてのセクションを実行します。

## ファイル構造

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

## シークレット展開

`client_secret`、`jwt_secret`、`postgres_url` などのシークレットを `gateway.yaml` に直接書き込まないでください。以下のいずれかの形式で参照すると、ゲートウェイはブート時に環境変数またはファイルから値を解決します：

| 形式 | 解決先 | 用途 |
| - | - | - |
| `${VAR}` | 環境変数 `VAR`。未定義の場合はブート失敗。 | コンテナ環境変数、env インジェクション経由の AWS Secrets Manager |
| `${file:/path}` | そのパスにあるファイルの内容、トリミング済み。参照はフィールド全体の値である必要があります：`${VAR}` とは異なり、より長い文字列内で展開されないため、データベースパスワードの場合は `postgres_url` に埋め込むのではなく `store.password` を設定してください。 | Kubernetes Secret ボリュームマウント、Vault Agent、SOPS |

## 必須セクション

### `listen`

`listen` ブロックは、ゲートウェイがどこでサービスを提供するかを制御します。バインドアドレスとポート、外部から見えるオリジン、およびオプションの TLS 終端を設定します。

| フィールド | 必須 | 説明 |
| - | - | - |
| `host` | いいえ | バインドアドレス。デフォルトは `0.0.0.0`。 |
| `port` | いいえ | バインドポート。デフォルトは `8080`。 |
| `public_url` | `host` がループバックでない場合 | 外部から見える `https://` オリジンで、IdP の `redirect_uri` とディスカバリメタデータの構築に使用されます。`host` がループバックアドレスでない場合は常に必須です。これは、TLS が ALB、Ingress、Cloud Run などのプロキシで終端される場合も、`tls` を通じてゲートウェイ自体で終端される場合も同様です。ゲートウェイは自身のオリジンを `X-Forwarded-*` ヘッダーから導出することがないためです。これらのヘッダーはクライアントが偽装できます。これがないと起動に失敗します。下記の `trusted_proxies` はクライアント IP の解決のみを制御します。また、ゲートウェイはクライアントにプッシュする OTLP エンドポイントをこの URL から構築するため、[テレメトリ](#telemetry)を有効にする場合にも必須です。 |
| `tls.cert` / `tls.key` | いいえ | ゲートウェイ自体が TLS を終端する場合の PEM パス |
| `trusted_proxies` | いいえ | ゲートウェイの前段にあるロードバランサーの CIDR または IP。設定すると、ゲートウェイはこれらのピアからの `X-Forwarded-For` のみを信頼し、IP ごとのレート制限と監査のために実際のクライアント IP を記録します。nginx の `set_real_ip_from` に相当します。一部のロードバランサーが行うように `ipv4:port` または `[ipv6]:port` の形式で書かれた `X-Forwarded-For` エントリは、ポートを除いて読み取られます。角括弧なしでポートが付加された IPv6 アドレスは、別のアドレスとして読み取られるか、まったく読み取られない可能性があるため、その形式で書き込むプロキシではポートオプションをオフにしてください。 |

### `oidc`

`oidc` ブロックは、ゲートウェイを ID プロバイダーに接続し、誰がサインインできるかを決定します。発行者と OAuth クライアントを指定し、メールアドレスとグループを伝えるクレームをマッピングし、メールドメインまたはグループによってサインインを制限します。

OpenID Connect（OIDC）は、ゲートウェイが ID プロバイダーとの間で使用する SSO プロトコルです。IdP 側で登録する内容については、[ID プロバイダーのセットアップ](https://code.claude.com/docs/ja/claude-apps-gateway-deploy.md#identity-provider-setup)を参照してください。

| フィールド | 必須 | 説明 |
| - | - | - |
| `issuer` | はい | OIDC ディスカバリのベース。`/.well-known/openid-configuration` でディスカバリを提供する必要があります。本番環境では HTTPS を使用してください。ゲートウェイは `http://` の issuer も受け入れます。`http://localhost:8081` のようなループバックの issuer は、ゲートウェイの環境で `CLAUDE_GATEWAY_ALLOW_LOOPBACK=1` が設定されていない限り、[SSRF ガード](https://code.claude.com/docs/ja/claude-apps-gateway-deploy.md#threat-model-summary)によって拒否されます。 |
| `client_id` | はい | OAuth クライアント登録から取得 |
| `client_secret` | `token_endpoint_auth_method` が `private_key_jwt` でない場合 | OAuth クライアント登録から取得。[証明書によるクライアント認証](#certificate-client-authentication)を使用する場合は省略してください。 |
| `allowed_email_domains` | いいえ | `email` クレームがこれらのドメインのいずれにも含まれない id\_token を拒否します（大文字と小文字は区別しません）。マルチテナント IdP の設定ミスに対する多層防御です。この設定とは無関係に、`email_verified` クレームが明示的に `false` である id\_token は常に拒否されます。 |
| `allowed_groups` | いいえ | サインインをこれらの IdP グループのメンバーに制限します。`groups_claim` と照合されます。許可されたメールドメインに属していても、これらのグループのいずれにも属していないユーザーは拒否されます。IdP がグループクレームを発行する必要があります。照合はそのクレーム内の値に対する完全一致かつ大文字と小文字を区別する文字列比較であり、ゲートウェイはネストされたグループを展開しません。サブグループのメンバーを許可するには、ここにサブグループを列挙するか、フラット化されたメンバーシップを発行するように IdP を設定してください。 |
| `groups_claim` | いいえ | グループメンバーシップを伝える id\_token クレーム。デフォルトは `groups`。Microsoft Entra はアプリロールを `roles` の下に発行します。フラットなキー、またはネストされたクレーム用の `/resource_access/gateway/roles` のような RFC 6901 JSON Pointer を受け付けます。 |
| `google_groups` | いいえ | Google の id\_token にはグループクレームが含まれないため、Google Workspace Admin SDK Directory API を通じて、サインインしたユーザーのグループを検索します。`service_account_json_path` には、`https://www.googleapis.com/auth/admin.directory.group.readonly` スコープでドメイン全体の委任が設定されたサービスアカウントのキーファイルを、`admin_email` にはサービスアカウントが偽装する Workspace 管理者を設定します。Directory API では実際の管理者サブジェクトが必要です。各ユーザーのグループのメールアドレスがそのユーザーのグループクレームになるため、`allowed_groups` と `managed.policies.match.groups` はグループのメールアドレスで照合します。 |
| `email_claim` | いいえ | ユーザーのメールアドレスを伝える id\_token クレーム。デフォルトは `email`。ADFS や Entra B2C などの一部の IdP は、代わりに `upn` または `preferred_username` を発行します。フラットなキー、JSON Pointer、またはフォールバックキーのリスト（最初に存在するキーが使用されます）を受け付けます。 |
| `scopes` | いいえ | ゲートウェイが要求する OIDC スコープを完全に上書きします。デフォルトは `[openid, profile, email, offline_access]`。IdP が認識しないスコープを拒否する場合や、グループやメールアドレスを発行するためにカスタムスコープが必要な場合に設定します。`openid` を含める必要があります。`offline_access` を外すとリフレッシュトークンが無効になるため、開発者は `session.ttl_hours` ごとにブラウザログインをやり直すことになります。Google のリフレッシュトークンフローなど、IdP ごとのスコープのレシピについては[ID プロバイダーのセットアップ](https://code.claude.com/docs/ja/claude-apps-gateway-deploy.md#identity-provider-setup)を参照してください。 |
| `scope_on_refresh` | いいえ | ゲートウェイがリフレッシュトークンを交換する際にも、サインインリクエストと同じリストで `scope` を送信します。デフォルトは `false` で、リフレッシュリクエストは `scope` を省略します。ほとんどの IdP はリフレッシュのたびに id\_token を返すため、この設定は不要です。IdP が再度 `openid` を要求された場合にのみリフレッシュ時に id\_token を返す場合は `true` に設定します。Okta はリフレッシュグラントについてこの動作を文書化しています。id\_token がない場合、すべてのリフレッシュは、IdP の userinfo エンドポイントがリフレッシュされたアクセストークンを受け入れるかどうかに依存します。サインインの制限やポリシーの照合にグループを使用しており、IdP のリフレッシュ時の id\_token にグループが含まれない場合は、ゲートウェイが userinfo エンドポイントからグループを補完できるよう `userinfo_fallback: true` も設定してください。要求されたよりも少ないスコープしか付与していない IdP は、`invalid_scope` でリフレッシュを拒否する可能性があります。これには、この設定がオンの間に `scopes` にエントリを追加した場合の既存セッションも含まれます。設定後に `token_endpoint` でリフレッシュが失敗し始めた場合は、このキーを削除してください。ゲートウェイサーバーで Claude Code v2.1.260 以降が必要です。 |
| `extra_auth_params` | いいえ | IdP の認可リクエストにそのまま付加される追加のクエリパラメータ。これは IdP 固有の動作を上書きするための仕組みで、たとえば Google のリフレッシュトークン用の `access_type: offline`、一部の Entra テナント用の `domain_hint`、ステップアップフロー用の `acr_values` などがあります。ゲートウェイが管理するプロトコルパラメータ（`state`、`nonce`、`redirect_uri`、PKCE、`scope`、`response_type`、`response_mode`、`client_id`）は上書きできません。 |
| `userinfo_fallback` | いいえ | id\_token にメールアドレスまたはグループが含まれない場合、`/userinfo` から取得します。Keycloak の軽量アクセストークン、Okta の組織サーバー、ADFS の最小トークンで必要です。id\_token が引き続き正となり、userinfo は欠けている部分を補うだけです。デフォルトは `false`。 |
| `use_pkce` | いいえ | 認可リクエストで PKCE（S256）チャレンジを送信します。デフォルトは `true`。IdP がこのコンフィデンシャルクライアントに対して PKCE を拒否する場合にのみ `false` に設定してください。 |
| `clock_skew_seconds` | いいえ | id\_token の時刻クレームを検証する際に時刻のずれを許容します。デフォルトは `0` で、厳格です。ホストと IdP 間の時刻のずれにより、サインイン直後に "token expired / not yet valid" エラーが表示される場合は値を上げてください。 |
| `token_endpoint_auth_method` | いいえ | ゲートウェイが IdP のトークンエンドポイントに対して認証する方法です。`client_secret_basic`、`client_secret_post`、または[証明書によるクライアント認証](#certificate-client-authentication)用の `private_key_jwt` のいずれかです。デフォルトでは、ゲートウェイは IdP が公開している内容から 2 つの `client_secret` 方式のいずれかを選択します。 |
| `client_assertion` | `private_key_jwt` 使用時 | `private_key_pem` と `certificate_pem` を持つブロック。[証明書によるクライアント認証](#certificate-client-authentication)用の秘密鍵と証明書です。v2.1.284 以降が必要です。 |
| `id_token_signed_response_alg` | いいえ | 想定される id\_token の署名アルゴリズム。デフォルトは `RS256`。ES256、PS256、または EdDSA で署名する IdP の場合に設定します。 |
| `additional_authorized_parties` | いいえ | Keycloak のブローカーフローおよびトークン交換フロー用に、`client_id` 以外に受け入れる追加の `azp` 値 |
| `discovery_url` | いいえ | issuer のホストを書き換えるプロキシの背後にある IdP の場合に、`issuer` から導出する代わりにこの URL からディスカバリドキュメントを取得します。パスには `/.well-known/` を含める必要があります。 |
| `use_proxy` | いいえ | ゲートウェイ自身の IdP リクエストを、`NO_PROXY` に従いつつ `HTTPS_PROXY` または `HTTP_PROXY` のフォワードプロキシ経由で送信します。`false` にするとそれらのリクエストは直接送信されます。v2.1.227 以降が必要です。下記の[フォワードプロキシ経由の IdP リクエスト](#idp-requests-through-a-forward-proxy)を参照してください。 |
| `form_action_origins` | いいえ | `/device` ページの `Content-Security-Policy: form-action` ディレクティブに追加するオリジン。ゲートウェイはすでに `'self'` と検出された `authorization_endpoint` のオリジンを許可していますが、Chrome はリダイレクトチェーン全体に対して `form-action` を適用します。Azure AD から ADFS へのフェデレーション、ハブアンドスポーク型の Okta、企業の SSO インターセプターなど、IdP が 2 つ目のホストを経由してリダイレクトする場合は、認可リクエストがリダイレクトで経由する可能性のあるすべてのオリジンを列挙してください。 |
| `ca_cert_pem` | いいえ | ファイルへのパスではなく、PEM エンコードされた CA 証明書そのもの。IdP リクエストに限り、システムの信頼ストアを置き換えます。マウントされたファイルを読み込むには `${file:/etc/gateway/idp-ca.pem}` と記述します。企業 PKI の背後にある Keycloak や Dex に使用します。 |

#### 証明書によるクライアント認証

Microsoft Entra の証明書の認証情報のように、ID プロバイダーが OAuth クライアントをクライアントシークレットではなく証明書で認証する場合は、`token_endpoint_auth_method: private_key_jwt` を設定します。ゲートウェイサーバーで Claude Code v2.1.284 以降が必要です。

この設定では、ゲートウェイはシークレットを送信しません。開発者がサインインするとき、およびゲートウェイがその開発者のセッションをリフレッシュするたびに、証明書の秘密鍵で署名された短命の JWT を使って IdP のトークンエンドポイントに対して認証します。JWT は RS256 で署名され、`kid` ではなく `x5t` および `x5t#S256` のサムプリントヘッダーで証明書を識別します。IdP は、登録された証明書をサムプリントで見つけられる必要があります。

**1. 鍵と証明書を作成する**

PKCS#8 または PKCS#1 の PEM 形式で、2048 ビット以上の暗号化されていない RSA 秘密鍵と、それに対応する証明書を作成します。ゲートウェイは、これらの条件を満たさない鍵では起動を拒否します。次の `openssl` コマンドは、そのような鍵と、1 年間有効な自己署名証明書を作成します。

```bash theme={null}
openssl req -x509 -newkey rsa:2048 -nodes -keyout idp-client.key -out idp-client.crt -days 365 -subj "/CN=claude-gateway"
```

現在のディレクトリに `idp-client.key` と `idp-client.crt` が書き込まれます。両方のファイルを、ゲートウェイが読み取れる場所にコピーまたはマウントしてください。ステップ 3 の例では `/etc/gateway/` を使用しています。

**2. 証明書を IdP にアップロードする**

秘密鍵ではなく証明書を、IdP 上のゲートウェイのアプリ登録にアップロードします。

**3. 鍵と証明書を gateway.yaml に追加する**

`client_assertion` ブロックで、ゲートウェイに秘密鍵と証明書を渡します。`client_secret` は省略してください。`private_key_jwt` と一緒に設定されていると、ゲートウェイは起動を拒否するためです。次の `oidc` ブロックは、証明書を使用してゲートウェイを Microsoft Entra テナントに対して認証します。

```yaml theme={null}
oidc:
  issuer: https://login.microsoftonline.com/<tenant-id>/v2.0
  client_id: <application-id>
  token_endpoint_auth_method: private_key_jwt
  client_assertion:
    private_key_pem: ${file:/etc/gateway/idp-client.key}
    certificate_pem: ${file:/etc/gateway/idp-client.crt}
```

どちらの値もファイルパスではなく PEM の内容であるため、例のように `${file:/path}` でマウントされたファイルを読み込んでください。`certificate_pem` が、チェーンの残りを含まない単一の PEM 証明書であり、かつその公開鍵が `private_key_pem` と一致するものでなければ、ゲートウェイは起動を拒否します。

**4. ゲートウェイを再起動して起動ログを確認する**

ゲートウェイを再起動し、起動ログで次の行を探します。

```text theme={null}
[gateway] 2026-10-01T23:07:40.512Z info oidc: client authentication private_key_jwt; certificate CN=claude-gateway, SHA-1 thumbprint DE92821854EE8BAA1D98C758FAA04AABE80B9F57, expires Oct  1 23:07:31 2027 GMT
```

SHA-1 サムプリントを、アップロードした証明書について IdP が表示するサムプリントと比較してください。証明書の有効期限が切れている場合や、まだ有効になっていない場合でも、ゲートウェイは起動しますが、証明書を置き換えるまでサインインとリフレッシュが失敗するという警告をログに記録します。IdP が証明書を受け入れることを確認するには、開発者 1 人にゲートウェイ経由でサインインしてもらいます。

#### クライアント証明書をローテーションする

ゲートウェイは起動時に鍵と証明書を一度だけ読み取るため、ファイルの変更は再起動後にのみ有効になります。IdP が持っていない証明書をトークンリクエストが提示することのないよう、次の順序でローテーションしてください。

1. 新しい証明書を、古い証明書と並べて IdP にアップロードします。
2. `gateway.yaml` が読み込む鍵と証明書のファイルを置き換えてから、ゲートウェイを再起動します。複数のレプリカを実行している場合は、古い証明書を削除するまで IdP が両方の証明書を持っているため、[ローリング再起動](https://code.claude.com/docs/ja/claude-apps-gateway-deploy.md#upgrades)が機能します。
3. すべてのレプリカが再起動したら、古い証明書を IdP から削除します。

#### フォワードプロキシ経由の IdP リクエスト

推論のアップストリームは、すべてのバージョンで `HTTPS_PROXY` と `HTTP_PROXY` に従います。ゲートウェイ自身の IdP へのリクエスト（ディスカバリ、JWKS、トークン、userinfo）は、`oidc.use_proxy: true` を設定しない限り直接送信されます。この設定には v2.1.227 以降が必要です。プロキシ変数が設定されていて、`use_proxy` が未設定で、issuer が `NO_PROXY` の対象外である場合、ゲートウェイはそれらのリクエストを直接送信し続け、起動時にどちらかを選択するよう求める通知をログに記録します。`use_proxy: false` にすると直接送信が維持され、通知は表示されなくなります。

`use_proxy: true` の場合、Pod は各 IdP エンドポイントのホスト名を自分で解決し、解決した IP アドレスへの `CONNECT` をプロキシに依頼します。そのため、プロキシは issuer だけでなく、ディスカバリドキュメントに記載されたすべてのホストの IP アドレスへの `CONNECT` を受け入れる必要があります。`http://` のプロキシ URL を使用してください。`ca_cert_pem` と [SSRF ガード](https://code.claude.com/docs/ja/claude-apps-gateway-deploy.md#threat-model-summary)は、プロキシ経由のパスにも適用されます。

[プロキシのみのエグレス](#proxy-only-egress)は、これらの両方を変更します。これが有効な間、IdP リクエストは `use_proxy: false` を設定しない限りプロキシに従い、ゲートウェイは各 IdP ホスト名を事前に解決せずにプロキシに渡します。

#### プロキシのみのエグレス

Pod が他のホストにそのフォワードプロキシ経由でのみ到達でき、自身ではパブリック DNS 名を解決できない場合、またはプロキシが IP アドレスへの `CONNECT` を拒否する場合は、ゲートウェイの環境で `HTTPS_PROXY` と並べて `CLAUDE_GATEWAY_PROXY_IS_EGRESS_BOUNDARY=1` を設定します。v2.1.277 以降が必要です。これが `gateway.yaml` のキーではなく環境変数になっているのは、設定ファイル内のいかなる内容もゲートウェイのアドレスチェックを緩められないようにするためです。

```bash theme={null}
export HTTPS_PROXY=http://proxy.corp.example.com:3128
export NO_PROXY=
export no_proxy=
export CLAUDE_GATEWAY_PROXY_IS_EGRESS_BOUNDARY=1
```

プロキシのみのエグレスが有効な間、ゲートウェイは起動時に `network:` の行を 1 行ログに記録します。

以下の各行は、`HTTPS_PROXY` が設定されたゲートウェイにおける送信リクエストの 1 つの種類について、デフォルト時とプロキシのみのエグレスが有効な時の動作を示しています。

| 送信リクエスト | デフォルト | プロキシのみのエグレスが有効 |
| - | - | - |
| `provider: anthropic` のアップストリーム、Workload Identity Federation のトークン交換、`telemetry.forward_to` のエクスポート | ローカルで解決およびチェックされた後、チェック済みの IP アドレスへプロキシ経由で `CONNECT`。`NO_PROXY` に列挙されたテレメトリコレクターには代わりに直接到達 | ホスト名をプロキシに渡す |
| IdP のディスカバリ、JWKS、トークン、userinfo | [`oidc.use_proxy: true`](#idp-requests-through-a-forward-proxy) でない限り直接。その場合はチェック済みの IP アドレスへ `CONNECT` | ホスト名をプロキシに渡す。ただし `oidc.use_proxy: false` で内部 IdP を直接のままにできる |
| Amazon Bedrock、Claude Platform on AWS、Google Cloud の Agent Platform、Microsoft Foundry のアップストリーム、Google グループの検索 | ホスト名をプロキシに渡す | 変更なし |

プロキシのみのエグレスは、ゲートウェイの環境が次の 3 つの条件をすべて満たさない限りオフのままです。

* `HTTPS_PROXY` または `HTTP_PROXY` が設定されている。
* `NO_PROXY` と `no_proxy` が空である。プラットフォームがいずれかを Pod に注入する場合は、ゲートウェイコンテナで両方を空の値に設定してください。`NO_PROXY` にテレメトリコレクターを列挙すると、プロキシのみのエグレスはオフのままになります。
* `CLAUDE_GATEWAY_ALLOW_LOOPBACK` がオンになっていない。Pod 自身のループバック上にあるコレクターや IdP は、プロキシのみのエグレスと組み合わせることはできません。プロキシに渡されたループバックアドレスはプロキシホスト自身のものになってしまうため、代わりにそれらのサービスにはプロキシが到達できるアドレスを与えてください。同じ理由で、プロキシのみのエグレスが有効な間、ゲートウェイは `localhost` のような名前を一律に拒否します。

これらの条件のいずれかが満たされない場合、ゲートウェイは起動時に、有効化を妨げた変数を示す警告をログに記録し、デフォルトの動作を維持します。

プロキシのみのエグレスが有効になったら、内部コレクターや IP アドレスで設定されたホストを含め、すべての宛先をプロキシで許可してください。[`oidc.use_proxy: false`](#idp-requests-through-a-forward-proxy) を使えば、引き続き内部 IdP を直接のままにできます。

> [!WARNING]
>
> プロキシの許可リストが少なくともゲートウェイ自身のチェックと同程度に厳格である場合にのみ、これをオンにしてください。プロキシは、`169.254.169.254` や `metadata.google.internal` などのクラウドメタデータエンドポイント、リンクローカルアドレス、プロキシホスト自身のループバックを拒否する必要があります。また、名前だけでなく、名前の解決先のアドレスによって拒否する必要があります。ゲートウェイは、それらのいずれかに解決されるホスト名をもはや捕捉しないためです。要求された場所ならどこにでも接続するプロキシは、これらのリクエストについてゲートウェイの [SSRF ガード](https://code.claude.com/docs/ja/claude-apps-gateway-deploy.md#threat-model-summary)を無効にしてしまいます。

### `session`

`session` ブロックは、ゲートウェイがサインイン後に発行するベアラートークンの性質を決めます。トークンに署名するシークレットと、トークンの有効期間です。

| フィールド | 必須 | 説明 |
| - | - | - |
| `jwt_secret` | はい | 少なくとも 32 バイトのエントロピー（例: `openssl rand -base64 32` で生成）。ゲートウェイの HS256 ベアラートークンに署名します。単一の文字列、またはローテーション用の配列を受け付けます。インデックス 0 が署名に使われ、すべてのエントリが検証に使われます。ローテーションするには、新しいシークレットを先頭に追加し、`ttl_hours` 待ってから古いシークレットを削除します。 |
| `ttl_hours` | いいえ | ゲートウェイのベアラートークンの有効期間。デフォルトは `1`。IdP がリフレッシュトークンを発行する場合、CLI は有効期限前にサイレントにリフレッシュします。有効期間を短くするとプロビジョニング解除が速くなり、長くすると IdP とのラウンドトリップが減ります。`offline_access` が利用できず IdP がリフレッシュトークンを発行できない場合、サイレントリフレッシュは行われないため、開発者を 1 時間ごとにブラウザログインに戻さないよう、この値を `8` または `12` に上げてください。 |

### `store`

`store` ブロックは、デバイスグラントとレート制限カウンターを保持する PostgreSQL データベースをゲートウェイに指定します。

| フィールド | 必須 | 説明 |
| - | - | - |
| `postgres_url` | はい | カンマ区切りのリストではなく、ホストが 1 つの `postgres://` または `postgresql://` URL。ゲートウェイは起動時とアップグレード時に独自のスキーママイグレーションを実行するため、ロールには対象スキーマでテーブルを作成および変更する権限が必要です。[アップグレード](https://code.claude.com/docs/ja/claude-apps-gateway-deploy.md#upgrades)と [Postgres](https://code.claude.com/docs/ja/claude-apps-gateway-deploy.md#postgres) を参照してください。 |
| `username` | いいえ | `postgres_url` 内のユーザーを上書きします |
| `password` | いいえ | データベースの認証情報。認証情報が URL に含まれないよう、`postgres_url` ではなくここで設定してください。任意の文字を受け付け、URL の認証情報よりも優先されます。 |
| `max_connections` | いいえ | レプリカごとの Postgres コネクションプールのサイズ。デフォルトは `5` で、控えめな値であり共有データベースに適しています。[支出制限](#admin)を有効にすると、ゲートウェイは推論リクエストごとにいくつかのデータベース操作を行うため、負荷のかかる専用データベースでは、[コネクションプールのサイズを決める](https://code.claude.com/docs/ja/claude-apps-gateway-deploy.md#size-the-connection-pool)で許容される範囲内で値を上げてください。 |
| `connect_timeout_seconds` | いいえ | ゲートウェイが Postgres 接続を開く際に待機する秒数。`1` から `60` までの整数で、デフォルトは `5`。新しいゲートウェイインスタンスの起動時に接続試行がタイムアウトする場合は値を上げてください。ゲートウェイサーバーで Claude Code v2.1.274 以降が必要です。それより前のバージョンでは、このキーが設定されていると起動を拒否します。 |
| `readiness_grace_seconds` | いいえ | Postgres が応答しなくなった後、`/readyz` が ready を報告し続ける秒数。`0` から `3600` までの整数で、デフォルトは `0`。値の選び方については[障害時の動作](https://code.claude.com/docs/ja/claude-apps-gateway-deploy.md#outage-behavior)を参照してください。ゲートウェイサーバーで Claude Code v2.1.282 以降が必要です。それより前のバージョンでは、このキーが設定されていると起動を拒否します。 |

ローカル開発では、`postgres_url` を使い捨ての Postgres コンテナに向けてください。例: `docker run --rm -p 5432:5432 -e POSTGRES_HOST_AUTH_METHOD=trust postgres`。

### `upstreams`

`upstreams` は順序付きリストです。ゲートウェイは、要求されたモデルを解決する最初のアップストリームに推論を転送します。

`5xx`、`429`、`401`、`403`、`404`、またはタイムアウトの場合、ゲートウェイは次のアップストリームにフェイルオーバーします。その他の `4xx` ではフェイルオーバーしません。これらのエラーはアップストリームではなくリクエストに起因するためです。`401` または `403` は、ゲートウェイが使用した認証情報をアップストリームが拒否したか、たとえば要求されたモデルへのアクセスを拒否したことを意味します。`404` は、そのアップストリームが要求されたモデルを提供していないことを意味するため、リスト内の後続のアップストリームが提供できる可能性があります。

アップストリームで `forward_user_identity: true` を設定した場合、開発者のメールアドレスを含むリクエストに対してそのアップストリームが返す `429` はフェイルオーバーしません。[ユーザーごとの制限による拒否が開発者にどのように届くか](#per-user-identity-headers-for-a-proxy-you-run)を参照してください。

`404` でのフェイルオーバーには、ゲートウェイ v2.1.198 以降が必要です。それより前のリリースでは、リスト内の後続のアップストリームがモデルを提供している場合でも、最初の `404` をクライアントに返していました。

同じプロバイダーの複数のアップストリームには、それぞれ異なる `name:` を設定する必要があります。

Amazon Bedrock、Claude Platform on AWS、Google Cloud の Agent Platform、Microsoft Foundry のクライアントは起動時に一度だけ作成され、それらの SDK は内部で認証情報をリフレッシュするため、クラウドの認証情報をローテーションしても再起動は不要です。静的な Anthropic API キーとベアラーは起動時に読み込まれます。[Anthropic API](#anthropic-api) を参照してください。

#### アップストリームのエラーメッセージ

ゲートウェイは、アップストリームがどのように応答したかに応じて、いずれかのアップストリームのエラーレスポンス、またはゲートウェイ独自の `502` を返します。

* **ゲートウェイが[フェイルオーバー](#multiple-upstreams)しないステータスをアップストリームが返した場合**: そのアップストリームのレスポンス。ゲートウェイはそれ以上のアップストリームを試行しません。
* **ゲートウェイが試行したすべてのアップストリームが、[フェイルオーバー対象](#multiple-upstreams)となる形で失敗した場合**: 最後の `429`。`429` を返したものがない場合、ゲートウェイは最後の `401` または `403`、最後の `404`、最後の `501` の順に優先します。いずれも返されなかった場合は、ゲートウェイ独自の `502`、`all upstreams failed (N attempted)` を返します。ここで N は、要求されたモデルを提供していないためにゲートウェイがスキップしたエントリも含め、[`upstreams`](#upstreams) 内のすべてのエントリの数です。

ゲートウェイがアップストリームのレスポンスを返すとき、アップストリームのステータスコードは維持されます。アップストリームのメッセージを維持するかどうかはプロバイダーによって異なります。Anthropic API アップストリームのエラー本文は、変更されずに開発者に届きます。

Amazon Bedrock、Claude Platform on AWS、Google Cloud の Agent Platform、Microsoft Foundry のアップストリームは、エラーテキストにアカウント ID、ロール ARN、プロジェクト ID を含めることがあります。ゲートウェイはその全文を[運用ログ](https://code.claude.com/docs/ja/claude-apps-gateway-deploy.md#logs)に記録します。これらのアップストリームから開発者に表示される内容は、拒否の内容によって異なります。

* Anthropic の標準エラーエンベロープでの `400` または `413`: `prompt is too long` などのアップストリーム自身のメッセージ。Claude Platform on AWS、Agent Platform、Microsoft Foundry は、モデル API の拒否についてこのエンベロープを返します。
* プロバイダー独自の形式での `400` または `413`: `capability_rejected:` トークン。ゲートウェイが拒否を分類できない場合は、`400` では `upstream rejected the request`、`413` では `request too large for this upstream`。
* その他のステータス: `429` での `upstream rate limit exceeded` など、ステータスごとの汎用的な文言。

たとえば、ゲートウェイは Amazon Bedrock の `Input is too long for requested model.` を `capability_rejected: prompt_too_long` に置き換えます。Claude Code は、`prompt is too long` の場合と同様に、このトークンに対して[自動的にコンパクト化](https://code.claude.com/docs/ja/errors.md#prompt-is-too-long)します。

クラウドアップストリームの `400` または `413` のメッセージを維持すること、または `capability_rejected:` トークンに置き換えることには、ゲートウェイ v2.1.233 以降が必要です。

#### Anthropic API

最小構成の Anthropic アップストリームは、[Claude Console](https://platform.claude.com) から取得した API キーです。

```yaml theme={null}
upstreams:
  - provider: anthropic
    auth:
      api_key: ${ANTHROPIC_API_KEY}
    # OR an OAuth bearer (e.g. a Workload-Identity-Federation-exchanged token):
    #   oauth_token: ${file:/var/run/secrets/anthropic-oauth-token}
    # base_url: https://api.anthropic.com   # default; override for a forward proxy
```

2 つの認証情報の形式は、送信するヘッダーが異なります。

* **`api_key`**: `x-api-key` を送信します。Claude Console でローテーションし、環境変数を更新してください。
* **`oauth_token`**: `Authorization: Bearer` を送信します。組織が長期間有効な API キーの代わりに短命のトークンを発行する場合は、ベアラー形式を使用してください。ベアラーは起動時に一度だけ読み込まれるため、シークレットを再マウントして再起動することでリフレッシュします。

静的なキーやベアラーの代わりに、Workload Identity Federation を使用できます。[Workload Identity Federation ガイド](https://platform.claude.com/docs/en/manage-claude/workload-identity-federation)に従ってフェデレーションルールを作成し、Kubernetes の projected サービスアカウントトークンや CI プラットフォームの id-token など、ワークロードの OIDC JWT をファイルとしてマウントします。ゲートウェイは JWT を短命のベアラーと交換し、自動的にリフレッシュします。トークンファイルは交換のたびに再読み込みされるため、ローテーションされた projected トークンは再起動なしで反映されます。

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

##### 自分で運用するプロキシ向けのユーザーごとの ID ヘッダー

`provider: anthropic` アップストリームの `base_url` を、Anthropic API ではなく自分で運用するプロキシに向けることができます。各リクエストをどの開発者が送信したかをそのプロキシに伝えるには、そのアップストリームで `forward_user_identity: true` を設定します。これにより、プロキシは開発者ごとに支出を帰属させることができます。Claude Code v2.1.233 以降を実行しているゲートウェイが必要です。

たとえば、`upstream-gateway.internal.example.com` にあるプロキシの場合は次のようになります。

```yaml theme={null}
upstreams:
  - provider: anthropic
    base_url: https://upstream-gateway.internal.example.com
    auth:
      api_key: ${PROXY_KEY}
    forward_user_identity: true        # default false
```

ゲートウェイは、そのアップストリームに転送するすべてのリクエストに次のヘッダーを追加します。

| ヘッダー | 値 |
| - | - |
| `x-litellm-end-user-id` | IdP が提供した場合の、開発者のメールアドレス。 |
| `x-claude-gateway-user-id` | トークンの `sub` クレームから取得した、開発者の IdP サブジェクト。 |
| `x-claude-gateway-user-email` | IdP が提供した場合の、開発者のメールアドレス。 |

IdP トークンにメールアドレスが含まれない場合、ゲートウェイは `x-claude-gateway-user-id` のみを送信し、2 つのメールヘッダーは省略します。IdP がメールアドレスを別のクレームに格納している場合は、[`oidc.email_claim`](#oidc) をそのクレームに設定してください。

Claude Code が送信する [`x-claude-code-*` ヘッダー](https://code.claude.com/docs/ja/llm-gateway-protocol#request-headers)（`x-claude-code-session-id` など）は、プロキシには届きません。ゲートウェイはこれらをどのアップストリームにも渡さないため、上の表のヘッダーを使用して開発者ごとにリクエストをグループ化してください。

開発者のメールアドレスを含むリクエストに対してプロキシが `429` を返した場合、ゲートウェイは次のアップストリームにフェイルオーバーする代わりに、そのレスポンスをそのまま開発者に返すため、プロキシのユーザーごとの予算やレート制限が維持されます。プロキシのその他のレスポンスは、通常の[フェイルオーバールール](#upstreams)に従います。開発者の IdP トークンにメールアドレスが含まれない場合、ゲートウェイはメールヘッダーなしでその開発者のリクエストを転送するため、そうしたリクエストへの `429` はアップストリームの容量としてカウントされ、フェイルオーバーします。ゲートウェイサーバーが v2.1.267 より前の場合は、すべての `429` がフェイルオーバーしていました。

`forward_user_identity` は、`base_url` が自分で運用するプロキシであるアップストリームでのみ設定してください。ゲートウェイは、その `base_url` が指すサーバーがどこであっても開発者のメールアドレスを送信します。`base_url` がデフォルトである Anthropic API の場合、ゲートウェイは起動を拒否します。

> [!NOTE]
>
> Amazon Bedrock アップストリームで `forward_user_identity` を設定すると、ゲートウェイは起動時に `Unrecognized key(s) in object: 'forward_user_identity'` で終了します。プロキシが Bedrock の前段にある場合は、代わりに `provider: anthropic` アップストリームとして列挙してください。ゲートウェイはそのアップストリームに Anthropic Messages 形式を送信するため、プロキシで [Bedrock 向けにリクエストを変換](https://code.claude.com/docs/ja/llm-gateway-protocol.md#format-mismatch-with-the-upstream)する必要があります。代わりに AWS に対して各開発者を識別させるには、[開発者ごとの AWS コスト帰属](#per-developer-aws-cost-attribution)を参照してください。

#### Amazon Bedrock

ゲートウェイが置き換える、または前段に置くクライアント側の Amazon Bedrock デプロイについては、[Amazon Bedrock での Claude Code](https://code.claude.com/docs/ja/amazon-bedrock.md) を参照してください。ゲートウェイ側のアップストリームは次のとおりです。

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

空の `auth` ブロックは、AWS SDK のデフォルト認証情報チェーン（環境変数、`~/.aws/credentials`、ECS タスクロール、EC2 インスタンスメタデータ、または EKS 上の IRSA）を使用します。本番環境では、コンテナイメージに静的キーを埋め込むのではなく、ゲートウェイ Pod に IAM ロールを付与してください。

明示的な認証情報は完全である必要があります。`aws_access_key_id` と `aws_secret_access_key` が一緒に設定されていない場合、または `aws_session_token` がそれらなしで設定されている場合、ゲートウェイは起動時に失敗します。v2.1.207 より前は、不完全な `auth:` ブロックでも検証を通過していました。

| セットアップ | 方法 |
| - | - |
| IAM 権限 | ゲートウェイのプリンシパルに、推論プロファイル ARN と基盤となる基盤モデル ARN の両方に対する `bedrock:InvokeModel` と `bedrock:InvokeModelWithResponseStream` を付与します。US リージョンの組み込みカタログの場合は `arn:aws:bedrock:<region>:<account>:inference-profile/us.anthropic.*` と `arn:aws:bedrock:*::foundation-model/anthropic.*` です。また、基盤モデル ARN に対する `bedrock:CountTokens` も付与してください。ゲートウェイはこれを使用して、クライアントが中断したリクエストの入力トークン数を無料でカウントし、[支出制限](#admin)を正確に保ちます。これがない場合、ゲートウェイはそのカウントのために 1 トークンの Bedrock リクエストにフォールバックします。 |
| モデルアクセス | Amazon Bedrock は、商用リージョンではデフォルトでモデルアクセスを有効にしています。残るアカウントレベルの関門は、Anthropic の 1 回限りのユースケースフォームです。AWS アカウント内の誰もまだ送信していない場合は、Amazon Bedrock コンソールを開き、Model catalog から Anthropic モデルを選択してフォームに記入してください。AWS Organizations 用のフォームと送信者に必要な権限については、[ユースケースの詳細を送信する](https://code.claude.com/docs/ja/amazon-bedrock.md#1-submit-use-case-details)を参照してください。 |
| EKS（IRSA） | 上記のポリシーと、ゲートウェイのサービスアカウントにスコープを限定した、クラスターの OIDC プロバイダー用の信頼ポリシーを持つ IAM ロールを作成します。サービスアカウントに `eks.amazonaws.com/role-arn: arn:aws:iam::<acct>:role/claude-gateway` のアノテーションを付けます。`auth: {}` がそれを取得します。 |
| ECS / EC2 | IAM ロールをタスク定義またはインスタンスプロファイルにアタッチします。`auth: {}` がそれを取得します。 |
| その他の環境 | `AWS_ACCESS_KEY_ID`、`AWS_SECRET_ACCESS_KEY`、`AWS_SESSION_TOKEN` 環境変数で認証情報を渡すか、`${VAR}` 展開を使用して `auth:` で明示的に設定します |
| リージョン | `region:` は API エンドポイントのリージョンです。クロスリージョン推論プロファイルは、どのリージョンを選んでも地域（US、EU、APAC）内でルーティングされます。US 以外のリージョンやプロビジョンドスループットの ARN の場合は、アップストリームごとの正しい ID を含む [`models:`](#models) ブロックを追加してください。 |

##### Amazon Bedrock ガードレールを適用する

ゲートウェイが Bedrock アップストリーム経由で送信するすべての推論リクエストに Amazon Bedrock ガードレールを適用するには、そのアップストリームに `guardrail` ブロックを追加します。ゲートウェイサーバーで Claude Code v2.1.281 以降が必要です。

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

> [!WARNING]
>
> ゲートウェイはガードレールの入力タグをサポートしていません。プロンプトにガードコンテンツタグを追加しないため、Amazon Bedrock がタグ付きの入力にのみ適用するガードレールフィルターは、ゲートウェイを経由するトラフィックでは実行されません。どのフィルターが入力タグに依存するかについては、Amazon Bedrock ドキュメントの[入力タグ](https://docs.aws.amazon.com/bedrock/latest/userguide/guardrails-tagging.html)を参照してください。

また、このアップストリームのリクエストに署名するプリンシパル（ゲートウェイの AWS プリンシパル、または [`assume_role`](#bedrock-in-another-aws-account) を使用する場合は `role_arn` で指定したロール）に、ガードレールに対する `bedrock:ApplyGuardrail` を付与してください。

`guardrail` は、すべての `bedrock` アップストリームに設定するか、どれにも設定しないかのいずれかにしてください。混在していると、[フェイルオーバー](#multiple-upstreams)によってガードレールのない Bedrock アップストリームにリクエストが送信される可能性があるため、ゲートウェイは起動を拒否します。

ガードレールは Bedrock アップストリームのみを対象とします。`upstreams` に別のプロバイダーを列挙した場合、ゲートウェイはそのプロバイダーにガードレールなしでリクエストを送信します。そのプロバイダーが [`mantle`](#amazon-bedrock-mantle-endpoint) の場合は起動を拒否します。

`amazon-bedrock-guardrailConfig` などの `amazon-bedrock-*` フィールドを本文に含む `/v1/messages` リクエストが、`guardrail` が設定された Bedrock アップストリームに到達した場合、ゲートウェイはそれを転送せずに 400 を返します。

##### 別の AWS アカウントの Bedrock

Bedrock アップストリームで `assume_role` を設定すると、ゲートウェイは自身の AWS ID を、指定したロールに対する `sts:AssumeRole` の呼び出しにのみ使用します。このロールはゲートウェイとは別の AWS アカウントにあってもかまいません。そのアップストリームからのすべての Bedrock リクエストは STS が返す 1 時間有効な認証情報で署名されるため、長期間有効なアクセスキーがアカウントをまたぐことはありません。

Claude Code v2.1.281 以降を実行しているゲートウェイが必要です。それより前のゲートウェイは、このキーを見つけると起動を拒否します。

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

`assume_role` ブロックは 3 つのキーを取ります。

| キー | 意味 |
| - | - |
| `role_arn` | ゲートウェイが引き受ける IAM ロール。`arn:aws:iam::` または `arn:aws-us-gov:iam::` の ARN で指定します。このアップストリームに必要な [Bedrock の権限](#amazon-bedrock)（`bedrock:CountTokens` を含む）に加え、アップストリームで `guardrail` を設定する場合は `bedrock:ApplyGuardrail` を付与してください。 |
| `external_id` | 省略可能。すべての `sts:AssumeRole` 呼び出しで外部 ID として送信されます。ロールの信頼ポリシーで必要な場合に設定し、すべて数字の場合は引用符で囲んでください。 |
| `session_name` | 省略可能。`email` または `sub` を指定すると、開発者ごとに個別のセッションが作られます。[開発者ごとの AWS コスト帰属](#per-developer-aws-cost-attribution)を参照してください。未設定の場合、すべてのリクエストで `claude-apps-gateway` という名前の 1 つのセッションが使用されます。 |

ロールの信頼ポリシーでは、IRSA や ECS タスクロールなど、ゲートウェイ自身のプリンシパルを指定します。そのプリンシパルにはロールに対する `sts:AssumeRole` が必要で、それ自体に Bedrock の権限は不要です。`external_id` を設定しない場合は `Condition` を削除してください。

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

* STS が拒否した場合や到達できない場合、ゲートウェイはアップストリーム自身の認証情報でリクエストを送信しません。確認すべき点とともに STS エラーをログに記録し、列挙した次のアップストリームを試行します。どのアップストリームも成功しなかった場合にクライアントが受け取る内容については、[アップストリームのエラーメッセージ](#upstream-error-messages)で説明しています。`assume_role` のない後続のアップストリームは自身の認証情報でリクエストを処理するため、それを意図する場合にのみ列挙してください。
* ゲートウェイはリージョンの STS エンドポイント `sts.<region>.amazonaws.com` を呼び出すため、ゲートウェイのネットワークからそこに到達できる必要があります。FIPS エンドポイントを使用するには、AWS 設定ファイルの `use_fips_endpoint` ではなく、ゲートウェイの環境で `AWS_USE_FIPS_ENDPOINT=true` を設定してください。
* `assume_role` は `provider: bedrock` にのみ適用され、SigV4 のソース認証情報が必要です。`aws_bearer_token` と並べて設定すると、ゲートウェイは起動を拒否します。
* ゲートウェイが受け入れたすべての開発者がこのアップストリームを使用できます。どの開発者がどのモデルを使用できるかは [`managed`](#managed) で制御します。ロール経由で提供されるモデルが別のアカウントからも提供されないようにするには、`upstream_model` マップにこのアップストリームの名前だけを持つカスタム id をそのモデルに付与してください。そのような id については、ゲートウェイは他のすべてのアップストリームをスキップするため、リクエストも中断されたリクエストのトークンカウントも別のアカウントにフェイルオーバーすることはありません。組み込みのモデル名に対するリクエストは引き続き[このアップストリームに到達する](#multiple-upstreams)可能性があり、ゲートウェイはそれを同じロールで署名します。このアカウントでそれらのモデルも提供すべき場合を除き、このアップストリームは最後に列挙してください。

次の例では、分離されたアップストリームのみが提供するカスタム id を 1 つのモデルに付与しています。

```yaml theme={null}
models:
  - id: claude-opus-restricted          # a custom id, not a built-in model name
    upstream_model:
      bedrock-isolated: us.anthropic.claude-opus-4-8   # the only upstream that serves it
```

##### 開発者ごとの AWS コスト帰属

デフォルトでは、ゲートウェイはすべての Bedrock リクエストに 1 つの認証情報で署名するため、AWS からはすべての開発者のリクエストが単一の IAM プリンシパルによるものに見えます。[`assume_role`](#bedrock-in-another-aws-account) に `session_name: email` を追加すると、ゲートウェイは開発者ごとに 1 時間に 1 回、セッション名をその開発者のメールアドレスに設定して `sts:AssumeRole` を呼び出し、返された認証情報でその開発者のリクエストに署名します。これにより、各開発者のリクエストは、その開発者自身の引き受けたロールのセッションで AWS に届きます。ロールはゲートウェイ自身のアカウントにあってもかまいません。

Claude Code v2.1.281 以降を実行しているゲートウェイが必要です。[AWS でのコスト帰属](https://code.claude.com/docs/ja/claude-apps-gateway-on-aws.md#cost-attribution)では、IAM ロールと、AWS の請求でセッションがどこに表示されるかを説明しています。

```yaml theme={null}
upstreams:
  - provider: bedrock
    region: us-east-1
    auth: {}                           # the gateway's own role: it only calls STS
    assume_role:
      role_arn: arn:aws:iam::123456789012:role/claude-gateway-bedrock-user
      session_name: email              # or sub
```

`session_name` は、どの検証済みクレームを AWS の `RoleSessionName` にするかを選択します（`email` または `sub`）。ゲートウェイは、ASCII の英字、数字、`_+,.@-` 以外の文字を UTF-8 の 1 バイトごとに `=XX` の 16 進数として書き込み、64 文字を超える結果はプレフィックスとハッシュに短縮するため、各開発者のセッション名は有効かつ一意に保たれます。トークンにそのクレームがない開発者からのリクエストはこのアップストリームを経由して送信されず、オペレーターログには `sub` に切り替えるか [`oidc.email_claim`](#oidc) を設定するよう記録されます。

アクティブな開発者 1 人につき、ゲートウェイのレプリカごとに 1 時間あたり 1 回の STS 呼び出しが発生し、同時に発生した最初のリクエストは 1 回の呼び出しを共有します。

ゲートウェイは、このロールで独自の呼び出しも 1 つ行います。[支出制限](https://code.claude.com/docs/ja/claude-apps-gateway-spend-limits.md)を正確に保つための、クライアントが中断したリクエストのトークンカウントです。そのカウントとその [1 トークンのフォールバックリクエスト](#amazon-bedrock)は共有の `claude-apps-gateway` セッションで署名されるため、AWS はフォールバックを開発者ではなく `claude-apps-gateway` に帰属させます。

厳密な開発者ごとの帰属を行うには、列挙するすべての Bedrock アップストリームで `session_name` 付きの `assume_role` を設定してください。これがないアップストリームは、処理するリクエストに自身の認証情報で署名します。

#### Amazon Bedrock Mantle エンドポイント

`mantle` プロバイダーは、Amazon Bedrock の [Mantle エンドポイント](https://code.claude.com/docs/ja/amazon-bedrock.md#use-the-mantle-endpoint)に推論を送信します。ゲートウェイサーバーで Claude Code v2.1.283 以降が必要です。それより前のゲートウェイリリースは起動時にこれを拒否するため、追加する前にすべてのレプリカをアップグレードしてください。

次の例では Mantle を最初に置き、`models` フィールドで除外されたすべてのモデルを提供するために、その後ろに Amazon Bedrock アップストリームを置いています。

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

次の表は、`mantle` アップストリームに固有のフィールドを示しています。

| フィールド | 必須 | 説明 |
| - | - | - |
| `region` | はい | AWS リージョン。ゲートウェイはこれからエンドポイントを `https://bedrock-mantle.<region>.api.aws/anthropic` として導出します。 |
| `models` | はい | AWS アカウントに Mantle で付与されているモデル。`claude-haiku-4-5` のように、クライアントが送信する名前で指定します。これらのモデルのみがこのアップストリームに送信され、その他のモデルはすべて次のアップストリームにスキップされます。 |
| `auth` | いいえ | [Amazon Bedrock](#amazon-bedrock) アップストリームの `auth` ブロックと同じキーを、同じルールで受け付けます。 |
| `base_url` | いいえ | 導出されたエンドポイントを上書きします。末尾の `/anthropic` パスは残してください。 |

アップストリームの AWS ID に、推論とトークンカウント用の Mantle 独自の IAM アクションを付与してください。これらは [Mantle エンドポイントを使用する](https://code.claude.com/docs/ja/amazon-bedrock.md#use-the-mantle-endpoint)に記載されています。

ゲートウェイが認識しない Mantle モデル ID の場合は、トップレベルの [`models:`](#models) ブロックに、`upstream_model` でこのアップストリームの名前をその ID にマッピングするエントリを追加します。その後、そのエントリの `id` をこのアップストリームの `models` フィールドにも追加してください。

`bedrock` アップストリームの `guardrail` と `assume_role` の設定は、Mantle が処理するリクエストには適用されません。

* **`guardrail`**: ゲートウェイは Mantle に送信するリクエストに [Bedrock ガードレール](#apply-an-amazon-bedrock-guardrail)を適用しないため、いずれかの `bedrock` アップストリームで `guardrail` が設定されている状態で `mantle` アップストリームが列挙されていると、起動を拒否します。
* **`assume_role`**: `mantle` アップストリームは [`assume_role`](#bedrock-in-another-aws-account) を受け付けません。Mantle が処理するリクエストは `mantle` アップストリーム自身の `auth` 認証情報で送信され、[開発者ごとに帰属](#per-developer-aws-cost-attribution)されません。

Mantle 自身のエラーレスポンスの意味については、[Mantle エンドポイントのエラー](https://code.claude.com/docs/ja/amazon-bedrock.md#mantle-endpoint-errors)を参照してください。

#### Claude Platform on AWS

Claude Platform on AWS は、AWS インフラストラクチャ上の `aws-external-anthropic.<region>.api.aws` でファーストパーティの Anthropic API を提供します。ファーストパーティのモデル ID を使用し、`anthropic-beta` ヘッダーを送信されたとおりに尊重し、`count_tokens` を提供するため、Bedrock 固有の変換は一切適用されません。`anthropicAws` プロバイダーには Claude Code v2.1.198 以降が必要です。それより前のゲートウェイリリースは起動時にこれを拒否します。

同じプラットフォームのクライアント側のデプロイについては、[Claude Platform on AWS での Claude Code](https://code.claude.com/docs/ja/claude-platform-on-aws.md) を参照してください。ゲートウェイ側のアップストリームは次のとおりです。

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

このプラットフォームは Amazon Bedrock とは別の AWS アカウントで実行され、自身のサービス名 `aws-external-anthropic` で SigV4 リクエストに署名するため、Bedrock にスコープされた IAM ロールでは認可されません。SigV4 の認証情報も設定されている場合は、`auth.api_key` の API キーが優先されます。空の `auth` ブロックは、[Amazon Bedrock](#amazon-bedrock) アップストリームと同じ、AWS SDK のデフォルト認証情報チェーンを使用します。

| フィールド | 必須 | 説明 |
| - | - | - |
| `region` | はい | AWS リージョン（小文字の英字、数字、ハイフン）。ゲートウェイはこれからエンドポイントを `https://aws-external-anthropic.<region>.api.aws` として導出します。 |
| `workspace_id` | はい | すべてのリクエストでヘッダーとして送信されます。プラットフォームで必須です |
| `auth.api_key` | いいえ | プラットフォーム用の API キーで、`x-api-key` として送信されます。ベアラートークンではありません。2 つの認証モードは API キーまたは SigV4 です。 |
| `auth.aws_access_key_id` / `auth.aws_secret_access_key` | いいえ | 明示的な SigV4 認証情報。一方だけを設定すると起動時に失敗します。`auth.aws_session_token` もあわせて受け付けます。 |
| `base_url` | いいえ | 導出されたエンドポイントを上書きします |

このプラットフォームはファーストパーティのモデル ID を解決するため、組み込みカタログは [`models:`](#models) ブロックなしでこのプラットフォームにルーティングされます。`models:` リストを独自に作成する場合は、エントリのキーを `anthropicAws:` にしてファーストパーティの ID を指定してください。

#### Google Cloud Agent Platform

同等のクライアント側のセットアップについては、[Google Cloud での Claude Code](https://code.claude.com/docs/ja/google-vertex-ai.md) を参照してください。ゲートウェイ側のアップストリームは次のとおりです。

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

空の `auth` ブロックは、Application Default Credentials（`GOOGLE_APPLICATION_CREDENTIALS`、GCE メタデータ、または GKE Workload Identity）を使用します。サービスアカウントの JSON キーファイルもサポートされていますが推奨されません。Workload Identity を使用するか、GCE または Cloud Run インスタンスにサービスアカウントをアタッチしてください。

リージョンのエンドポイントではなく [Google Cloud の Agent Platform のグローバルエンドポイント](https://cloud.google.com/vertex-ai/generative-ai/docs/learn/locations)を使用するには、`region: global` を設定します。その場合、Google が各リクエストを利用可能なリージョンにルーティングするため、リージョンごとのモデルの提供状況を追跡する必要はありません。特定のリージョンを設定すると、すべてのリクエストがそのリージョンに固定されます。

| セットアップ | 方法 |
| - | - |
| IAM 権限 | ゲートウェイのサービスアカウントに、プロジェクトに対する `roles/aiplatform.user`、または `aiplatform.endpoints.predict` を含むカスタムロールを付与します。Google Cloud の Agent Platform API（`aiplatform.googleapis.com`）を有効にしてください。 |
| モデルアクセス | Model Garden で、プロジェクトの Claude モデルを有効にします。モデルは特定のリージョンで公開されるため、サポートされているリージョンはモデルカードで確認してください。 |
| GKE（Workload Identity） | GCP サービスアカウントをゲートウェイの Kubernetes サービスアカウントにバインドし、KSA に `iam.gke.io/gcp-service-account: claude-gateway@<proj>.iam.gserviceaccount.com` のアノテーションを付けます。`auth: {}` がそれを取得します。 |
| Cloud Run / GCE | サービスのサービスアカウントを、`roles/aiplatform.user` を持つものに設定します。`auth: {}` がそれを取得します。 |
| その他の環境 | `auth: { service_account_json: /secrets/sa.json }`。シークレットとしてマウントされた JSON キーファイルへのパスです。このフィールドはキーの内容ではなくファイルパスを受け取るため、`${file:…}` 展開は関係しません。 |

#### Microsoft Foundry

クライアント側の Microsoft Foundry デプロイについては、[Microsoft Foundry での Claude Code](https://code.claude.com/docs/ja/microsoft-foundry.md) を参照してください。ゲートウェイ側のアップストリームは次のとおりです。

```yaml theme={null}
upstreams:
  - provider: foundry
    resource: example-foundry              # https://example-foundry.services.ai.azure.com
    auth: { use_azure_ad: true }        # preferred: DefaultAzureCredential / Managed Identity
    # OR an API key:
    # auth:
    #   api_key: ${FOUNDRY_API_KEY}
```

`use_azure_ad: true` は `DefaultAzureCredential` を通じて解決されます（AKS、ACI、App Service 上の Managed Identity、Azure CLI、または環境の認証情報）。API キーも機能しますが、プロジェクト全体に適用され、自動的にローテーションされません。Microsoft Foundry のエンドポイントは `resource:` から導出されます。Azure Government などのソブリンクラウドの場合は、オプションの `base_url` を設定して上書きしてください。

| セットアップ | 方法 |
| - | - |
| RBAC | ゲートウェイの ID に、Microsoft Foundry リソースに対する `Azure AI User` または `Cognitive Services User` を付与します |
| デプロイ | Microsoft Foundry は、正規のモデル ID ではなく管理者が選択したデプロイ名を使用します。各正規 ID をデプロイ名にマッピングする [`models:`](#models) ブロックを追加してください。 |
| AKS（ワークロード ID） | ユーザー割り当てマネージド ID をクラスターの OIDC 発行者とフェデレーションし、ゲートウェイのサービスアカウントにバインドします。`use_azure_ad: true` が `WorkloadIdentityCredential` 経由でそれを取得します。 |
| ACI / App Service | リソースでシステム割り当てまたはユーザー割り当てのマネージド ID を有効にします。`use_azure_ad: true` がそれを取得します。 |
| その他の環境 | `auth: { api_key: "${FOUNDRY_API_KEY}" }`。`{ }` 内の `${…}` は引用符で囲んでください。 |

#### アップストリームリクエストの静的ヘッダー

ゲートウェイが 1 つのアップストリームに送信するリクエストに固定のヘッダーを追加するには、そのアップストリームで `headers:` を設定します。プロバイダーの前段で運用しているプロキシがヘッダーによってトラフィックをルーティングまたは帰属させる場合に使用します。

`headers:` には、ゲートウェイサーバーで Claude Code v2.1.277 以降が必要です。それより前のゲートウェイは、このキーを見つけると起動を拒否します。キーを追加する前にすべてのレプリカをアップグレードし、以前のバージョンにロールバックする前にキーを削除してください。

ヘッダーは `base_url` が指すサーバーに送信されます。`base_url` が未設定の場合はプロバイダー自身のエンドポイントに送信されます。プロキシが削除しない限り、プロバイダーもヘッダーを受け取ります。

この例では、`upstream-proxy.internal.example.com` にあるプロキシを経由して `provider: vertex` アップストリームに到達します。プロキシが読み取る `x-source` ヘッダーを設定し、`PROXY_TOKEN` 環境変数のトークンを `x-proxy-token` として送信します。

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

値は、両端にスペースのない印刷可能な ASCII テキストです。YAML がテキストとして読み取るよう、数値、`true`、`false` は引用符で囲んでください。

設定ファイルにシークレットを含めないようにするには、[シークレット展開](#secret-expansion)を使用して、`${VAR}` で環境変数から、または `${file:/path}` でファイルから値を読み込みます。空の値に解決される `${VAR}` があると、ゲートウェイは起動しません。

`headers:` はすべてのプロバイダーで機能し、各アップストリームは自身のヘッダーのみを送信します。

ゲートウェイがアップストリームに送信するすべてのリクエストにヘッダーが含まれるわけではありません。

| ゲートウェイがこのアップストリームに送信するリクエスト | `headers:` を含むか |
| - | - |
| `/v1/messages`（ストリーミングの有無を問わない）と `/v1/messages/count_tokens` | はい |
| 別のアップストリームからフェイルオーバーしたリクエスト | はい（このアップストリームの `headers:` のみ） |
| クライアントが中断したリクエストに対する Amazon Bedrock の `CountTokens` 呼び出し | いいえ |
| Workload Identity Federation のトークン交換 | いいえ |

AWS SigV4 でリクエストに署名する Amazon Bedrock または Claude Platform on AWS アップストリームでは、これらのヘッダーは署名の一部になるため、プロキシはヘッダーを変更せずに通過させる必要があります。

ゲートウェイが予約している名前を使用すると、ゲートウェイは起動を拒否し、起動エラーにそのヘッダー名が示されます。予約されている名前には次のものがあります。

* `authorization` と `x-api-key`
* `host`、`content-type`、`user-agent`
* `anthropic-`、`x-goog-`、`x-amz-`、`x-amzn-` で始まる名前

#### 複数のアップストリーム

同じプロバイダーを、異なる `name:` を付けて複数回指定できます。これにより、異なるリージョン、異なる認証情報チェーンによる異なるアカウント、プロビジョンドスループットとオンデマンド、プロバイダー間のフォールバックに対応できます。

ゲートウェイはアップストリームを順番に試行します。`5xx`、`429`、`401`、`403`、`404`、タイムアウト、エンドポイントの欠如（`501`）はフェイルオーバーします。その他の `4xx` はフェイルオーバーしません。

`429` はアップストリームごとの容量を表すため、プロビジョンドスループット（PT）を使い切るとオンデマンドにフェイルオーバーします。アップストリームで [`forward_user_identity: true`](#per-user-identity-headers-for-a-proxy-you-run) を設定した場合、開発者のメールアドレスを含むリクエストへの `429` は代わりにユーザーごとの拒否となり、フェイルオーバーしません。

すべてのリクエストは最初のアップストリームから開始します。リクエストが後続のアップストリームに到達するのは、それより前のすべてのアップストリームが失敗したか、要求されたモデルを提供していない場合のみです。

ゲートウェイは失敗したアップストリームの記録を保持しないため、アップストリームがダウンしている間、そこに到達するすべてのリクエストは引き続きそのアップストリームを試行し、失敗するのを待ってから次に進みます。

Anthropic API アップストリームでは、[`timeouts.upstream_ttfb_ms`](#http-tuning) がダウンしたアップストリームでの待機時間の上限を定めます。この設定は他のプロバイダーには適用されず、それらのプロバイダーでは、ゲートウェイはアップストリームが応答を開始するまで最大 1 時間待機します。

`404` はアップストリームごとのモデルの提供状況を表すため、モデルを有効にしていないアップストリームが、そのモデルを提供する後続のアップストリームを妨げることはありません。要求されたモデルを解決できないアップストリームは、ネットワークのラウンドトリップなしでスキップされます。

この例では、プロビジョンドスループットの Amazon Bedrock の割り当てを最初にルーティングし、オンデマンドと 2 つ目のアカウントにオーバーフローさせ、最後に Anthropic API にフォールバックします。

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

| 手段 | 方法 |
| - | - |
| 異なるリージョン | リージョンごとに 1 つの Amazon Bedrock アップストリームを設け、それぞれに独自の `region:` を設定します。[`auto_include_builtin_models: true`](#models) の場合、クロスリージョン推論プロファイルは自動的にルーティングされます。リージョンに固定されたデプロイでは `models:` ブロックを使用してください。 |
| 異なるアカウント | アカウントごとに 1 つの Amazon Bedrock アップストリームを設けます。デフォルトのチェーン（`auth: {}`）は Pod の ID を使用します。2 つ目のアカウントについては、[`assume_role`](#bedrock-in-another-aws-account) を追加して短命の認証情報で到達するか、`auth:` で明示的な認証情報またはベアラートークンを設定してください。 |
| プロビジョンドスループット | `models:` で、そのアップストリームの名前に対してモデルをプロビジョンドスループットの ARN にマッピングします。他のアップストリームはオンデマンドの ID を維持するため、PT の容量を使い切ってからフェイルオーバーします。 |
| VPC / FIPS エンドポイント | アップストリームの `base_url:` を VPC エンドポイントまたは FIPS エンドポイントの URL に設定します |
| モデル単位のルーティング | カスタムモデルの `id`（組み込みの Claude モデルではないもの）の場合のみ、その `upstream_model:` マップにないアップストリームがスキップされます。`mantle` アップストリームは、その [`models` フィールド](#amazon-bedrock-mantle-endpoint)に列挙されたモデルについてのみ試行されます。その他のすべてのアップストリームでは、ゲートウェイは組み込みモデルを順番に試行し、マップにエントリがない場合はプロバイダーのデフォルト ID を使用します。そのため、組み込みモデルでは、マップはアップストリームが試行されるかどうかではなく、アップストリームが受け取る ID を変更します。ID を拒否したアップストリームは、他のアップストリームエラーと同じ[フェイルオーバールール](#upstreams)に従います。 |

クラウドプロバイダー間、または直接の Anthropic API へのフェイルオーバーでは、リクエストに適用される契約、地域、その他の条件が変わります。

CLI は、特定のリクエストをどのアップストリームが処理するかに関係なく、ゲートウェイに同じ機能ゲーティングを適用するため、デフォルトでは、フェイルオーバーによって、アップストリームが拒否するような本文フィールドが送信されることはありません。ポリシーで [1 時間のキャッシュ TTL](#one-hour-prompt-cache) を設定した場合、それはリスト内のすべてのアップストリームに送信されるため、すべてのアップストリームが受け入れる場合にのみ設定してください。

## オプションセクション

### `admin`

オプション。`/v1/organizations/spend_limits` を有効にします。これは Anthropic のパブリック Admin API をミラーリングし、`/v1/messages` でデベロッパーごとの支出強制を行います。キャップの設定と強制方法については [支出制限](https://code.claude.com/docs/ja/claude-apps-gateway-spend-limits.md) を参照してください。このセクションでは、この機能をオンにしてチューニングする `gateway.yaml` キーについて説明します。

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
| `read_keys` | いいえ | `{id, key}` の配列。読み取り専用：すべての `GET` エンドポイント（キャップのリスト、ID による 1 つの取得、[`/effective`](https://code.claude.com/docs/ja/claude-apps-gateway-spend-limits#%2Feffective) と [`/audit`](https://code.claude.com/docs/ja/claude-apps-gateway-spend-limits#%2Faudit) の読み取りを含む）。 |
| `admin_groups` | いいえ | IdP グループ名。`groups` クレームにこれらのいずれかを含むゲートウェイ JWT は、完全な管理者アクセス（読み取りと書き込み）を持ち、`oidc:<sub>` として監査されます。人間の管理者にはこれを使用し、マシンには API キーを使用してください。このリストの空のエントリはブート時にゲートウェイを停止します。[ゲートウェイをブート時に停止させる matcher 値](#matcher-values-that-stop-the-gateway-at-boot) を参照してください。 |
| `blocked_message` | いいえ | ブロックされたデベロッパーが見る `429 billing_error` に逐語的に追加されます。URL や Slack チャンネルなど、完全な指示を記述してください。設定されていない場合、ゲートウェイはデフォルトメッセージのみを送信します。[強制の仕組み](https://code.claude.com/docs/ja/claude-apps-gateway-spend-limits.md#how-enforcement-works) を参照してください。 |
| `audit_retention_days` | いいえ | デフォルト `365`。古い `admin_audit` 行は削除されます。 |
| `spend_retention_months` | いいえ | デフォルト `13`。この期間より古い `spend` カウンター行は削除されます。デフォルトは前年比レポート用に完全な 1 年と現在の部分月を保持します。 |
| `identity_retention_days` | いいえ | デフォルト `90`。`principal_emails` 行の最終確認からの TTL。この行は各デベロッパーのメール、表示名、グループ（PII）を保持します。意図的に支出保持より短くしているため、プロビジョニング解除されたアイデンティティは期限切れになりますが、その匿名支出カウンターは残ります。 |
| `group_limit_mode` | いいえ | `min`（デフォルト）または `max`。デベロッパーがキャップのある複数のグループに属する場合、`min` は最も制限的なものを強制し、`max` は最も制限の緩いものを強制します。強制と `/effective` の両方で使用されます。 |

### `enforcement`

`enforcement` ブロックは、ストアが利用できない場合に支出制限チェックがどのように動作するかを制御します。

| フィールド | 必須 | 説明 |
| - | - | - |
| `fail_closed_on_error` | いいえ | デフォルトは `false`。Postgres の障害時には支出制限の適用はフェイルオープンになり、推論は継続します。フェイルクローズにするには `true` に設定します。上限超過の開発者はブロックされますが、ストアに到達できない場合は他の全員もブロックされます。[`admin:`](#admin) ブロックが必要です。支出制限の適用は `admin` が設定されている場合にのみ実行され、これなしでこの値を `true` に設定するとゲートウェイは起動を拒否します。 |

### `pricing`

`pricing` ブロックは、支出メーターに USD リスト価格の代わりに請求する内容を指示するため、キャップと [`/effective`](https://code.claude.com/docs/ja/claude-apps-gateway-spend-limits#%2Feffective) は契約レートを反映します。金額は USD のままで、請求書ではなく見積もりです。2 つの前提条件があります：

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

* 行は、`upstream`（[`upstreams[].name`](#upstreams)）が `model` に対して処理するリクエストのリスト価格を置き換えます。これには、より高い [fast mode](https://code.claude.com/docs/ja/fast-mode.md#understand-the-cost-tradeoff) レートも含まれるため、fast リクエストと標準リクエストは同じ 4 つのレートでメーターされます。
* `claude-sonnet-4-6` などの組み込み ID（[`models[].id`](#models) と同様にマッチング）は、メーターがそのモデルとして価格設定するすべての日付付き形式、地域の Amazon Bedrock 形式、または Google Cloud の Agent Platform 形式をカバーします。エイリアスや推論プロファイル ARN などの他の文字列は、クライアントが送信した ID または上流に送信された文字列と大文字小文字を区別せずにマッチングします。
* 行が重複する場合、メーターは最初の行ではなく最も具体的な行を選択します：`model` が上流に送信された正確なモデル文字列である行、次にクライアントが送信した正確な ID とマッチングする行、次に組み込みモデルを指定する行。
* 不明な上流名はブート失敗を引き起こし、1 つの上流に対して同じモデルを指定する 2 つの行も同様です（1 つの組み込みモデルの 2 つの表記を含む）。ゲートウェイはブート時に、リクエスト可能なモデルが使用できない行について警告します。
* Web 検索リクエストは \$0.01 のリスト価格のままです。乗数はそれらにも適用されます。

地域ごとのレートについては、各地域に独自の名前付き上流を与え、上流ごとに 1 つの行を与えます。

#### 価格をマークアップする

ゲートウェイサーバー上の v2.1.271 以降では、`multiplier` を 1 より上、最大 10 まで設定して、内部チャージバックレートなど、プロバイダーが請求する以上にメーターできます。この例は、すべてのリクエストを価格の 120% でメーターします：

```yaml theme={null}
pricing:
  multiplier: 1.2
```

[`admin:`](#admin) ブロックを使用すると、マークアップは支出制限にも適用されます。メーターは価格の 120% をカウントするため、デベロッパーはキャップに早く到達します。ゲートウェイはブート時に、そのことを示す警告をログに記録します。

乗数は、上流プロバイダーがリクエストに請求する内容を変更しません。

ゲートウェイが [サインイン済みクライアントにレートを送信](#send-the-rates-to-signed-in-clients) する場合、デベロッパーがマークアップを確認するには Claude Code v2.1.271 以降が必要です。以前のクライアントは 1 より上の `multiplier` を無視し、それなしでコストを表示します。

v2.1.271 より前のゲートウェイサーバーは、`multiplier` を 1 より上に設定した場合、起動を拒否します。

#### サインイン済みクライアントにレートを送信する

ゲートウェイサーバー上の v2.1.268 以降では、ゲートウェイは `pricing` からのレートを、提供する [`managed`](#managed) ポリシーに [`modelPricing`](https://code.claude.com/docs/ja/settings-reference#modelpricing) 管理設定としても入れます。ポリシーにマッチするデベロッパーは、`/usage`、ステータスライン、OpenTelemetry で、各モデル ID を処理する最初の上流の `pricing` レートを確認できます。ポリシーにマッチしないデベロッパーは管理設定を受け取らないため、その数字はリスト価格のままです。クライアントは Claude Code v2.1.242 以降で設定を適用します。

* ゲートウェイが追加するもの：ポリシーの `cli` ブロックが既に `modelPricing` を設定していない限り、ゲートウェイは `multiplier` と、クライアントがリクエストできるすべてのモデル ID について、その ID を処理する最初の上流の上書き行を追加します。フェイルオーバー上流のみが請求するレートはゲートウェイに留まります。
* 1 つのポリシーをオプトアウトする：そのポリシーの `cli` ブロックで `modelPricing` を `{}` に設定すると、そのデベロッパーはリスト価格のままです。
* ポリシー独自のレートを保持する：`cli` ブロックが独自の `multiplier` または `overrides` で `modelPricing` を設定するポリシーは、その `modelPricing` 全体を保持し、ゲートウェイはそれに独自のレートを追加しません。

### `models`

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

### `managed`

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
* **拒否リストとフック配列**：`permissions.deny`、`permissions.ask`、`disabledMcpjsonServers`、`deniedMcpServers`、`blockedMarketplaces`、`deniedModels`、およびすべての `hooks` イベントタイプ配列。これらはベースとポリシーの和集合をとるため、組織全体の拒否や監査フックがロールごとの上書きによって誤って失われることはありません。
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

> [!NOTE]
>
> ゲートウェイは独自のユーザーディレクトリを保持しません。ユーザーの IdP トークンから各リクエストを認可し、トークンの `groups` クレームからグループメンバーシップを読み取り、それに対してポリシーを評価します。列挙するロスターはなく、事前作成するアカウントもなく、したがって SCIM エンドポイントもありません。SCIM が同期する先がないためです。
>
> ユーザーとグループのライフサイクル管理は、信頼できる情報源である IdP のネイティブ SCIM プロビジョニングまたは専用のアイデンティティガバナンスプラットフォームで実行してください。そこで管理されるメンバーシップとプロビジョニング解除は、トークンを通じてゲートウェイに自動的に反映されます。Claude アカウント自体の SCIM プロビジョニングが必要な場合、それは [Claude for Enterprise](https://code.claude.com/docs/ja/admin-setup.md) の機能です。
>
> 2 つの伝播タイミングがあります：
>
> * **ポリシーの内容**：ポリシーを編集して再デプロイすると、接続された Claude Code クライアントの次の管理設定ポーリング時（1 時間以内）に反映されます。ただし [次の起動時にのみ適用される変更](https://code.claude.com/docs/ja/server-managed-settings.md#fetch-and-caching-behavior) は除きます。
> * **グループメンバーシップ**：ユーザーのグループメンバーシップを変更すると、どのポリシーがそのユーザーにマッチするかが変わります。これは次のセッション再発行時、つまり次のサイレントリフレッシュ時に有効になり、`session.ttl_hours` が上限となります。
>
> Claude Desktop は [独自のスケジュール](#when-a-policy-change-reaches-claude-desktop) に従います。

#### ポリシーが許可するモデルでセッションを開始する

`availableModels` に Claude Code のデフォルトモデルが含まれていない場合、デベロッパーが `/model` などでリストにあるモデルを選択するまで、セッションは `400` レスポンスを受け取ります。ゲートウェイセッションでは、デフォルトは `opus` エイリアスが解決される Opus モデルであり、`availableModels` だけではこれは変わりません。

これを解決するには、同じ `cli` ブロックで [`enforceAvailableModels: true`](https://code.claude.com/docs/ja/model-config#enforce-the-allowlist-for-the-default-model) を設定し、リストに含まれるエントリの種類を確認します：

* **`sonnet` などのエイリアス、または `claude-sonnet-4-6` などの組み込み ID**：セッションはそれらのモデルのいずれかで開始し、`/model` の Default オプションはそのモデルに解決されます
* **リストにエイリアスも組み込み ID もない場合**：セッションは引き続き組み込みのデフォルトで開始する可能性があるため、そのポリシーの `cli` ブロックで [`model`](https://code.claude.com/docs/ja/model-config#control-the-model-users-run-on) もリスト内の ID のいずれかに設定してください

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

#### ゲートウェイをブート時に停止させる matcher 値

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

#### `cli` と `code` のどちらを選ぶか

> [!WARNING]
>
> ポリシーで `code` キーを使用する場合、次のいずれかによってゲートウェイが起動しなくなります。
>
> * **ゲートウェイのバージョン**: `code` には、ゲートウェイサーバー上の Claude Code v2.1.296 以降が必要です。それより前のゲートウェイは、このキーを見つけると起動を拒否します。キーを追加する前にすべてのレプリカをアップグレードし、以前のバージョンにロールバックする前に `code` を `cli` に戻してください。
> * **キーの混在**: `code` と `cli`（またはその以前の表記である `settings`）の両方を含むファイルは、起動時にゲートウェイを停止させます。1 回の編集で、すべてのブロックを 1 つのキーの下に置いてください。

`.env` ファイルの読み取りを拒否するルールなど、ポリシーの Claude Code の設定は、`cli` または `code` キーの下のブロックに記述します。`code` が推奨されるキーで、`cli` は従来のキーです。どちらのキーも同じ内容を受け付けます。キーによって、設定が適用される場所が決まります。

* **`cli`**: ターミナル、VS Code と JetBrains の拡張機能、Agent SDK。`cli` の下では、Claude Desktop の Code タブには [派生した設定](#claude-desktop-overlay) が適用されるため、`Read(./.env)` のようなスコープ付きルールはそこでのユーザーの操作を止めません。
* **`code`**: 同じ場所に加え、Claude Desktop の Code タブもカバーできます。

`cli` を使用するファイルは従来どおり動作し、[`desktop`](#claude-desktop-overlay) キーを持つポリシーで `cli` を検出したゲートウェイは、起動時に警告を出しますが起動は続行します。設定が Code タブにも適用されるように、`code` に切り替えてください。

切り替える前に、[Code タブで `code` 設定を適用する](#apply-code-settings-in-the-code-tab) をお読みください。設定がそこで適用されるには、ポリシーに `desktop` キーが必要で、ユーザーのマシンでのセットアップも必要です。また、Claude Desktop では Web 検索がオフになります。

次のポリシーは、拒否ルールを `code` の下に置き、空の `desktop` キーを持っています。

```yaml theme={null}
managed:
  policies:
    - match: {}
      code:
        permissions: { deny: ["Read(./.env)"] }
      desktop: {}
```

切り替える際は、ブロック名を変更するのと同じ編集で、`serve_to_desktop` の行をすべて削除してください。説明で `cli` ブロックに言及している箇所では、`code` ブロックを使用してください。

`serve_to_desktop: true` は、ポリシーの `cli` 設定を Code タブに提供するためのレガシーな方法です。Claude Desktop が [`bootstrapUrl`](#claude-desktop-overlay) を通じて接続する場合は効果がありません。ポリシーで `cli` を使用している間に、このキーを示す起動時の警告が表示された場合、それらの設定は Code タブに届いていません。

* **Code タブを対象にするには**：ユーザーのマシンが [Code タブで `code` の設定を適用する](#apply-code-settings-in-the-code-tab)の条件を満たしたら、`code` に切り替えます
* **`cli` のままにするには**：ポリシーで `cli` の横に `serve_to_desktop: false` を設定して、警告を抑制します

#### `cli` に何を入れるか

各 `code` または `cli` の値は、完全な Claude Code の `managed-settings.json` ドキュメントであり、MDM や `/etc/claude-code/managed-settings.json` でデプロイするものと同じスキーマを、ここでは YAML で表現したものです。CLI は配信されたドキュメントを、ユーザー設定やプロジェクト設定より上位の管理レベルで、サーバー管理設定の代わりに適用します。そのため、`policyHelper` や `wslInheritsWindowsSettings` など、[OS レベルのポリシーソースに限定された](https://code.claude.com/docs/ja/server-managed-settings.md#current-limitations) 設定は無視されます。

ゲートウェイはブート時に各ドキュメントを CLI の設定スキーマに対して検証するため、認識されないトップレベルキーがあるとブートが失敗し、違反するすべてのキーを示すエラーが表示されます。スキーマの意図的にオープンな部分は引き続き任意の値を受け入れます。新しいクライアントが、ゲートウェイのスキーマが認識しないエントリを認識する可能性があるためです。これらのオープンキーには `env`、`pluginConfigs`、`permissions` の下にネストされたキーが含まれます。

検証はゲートウェイのインストール済みバージョンにバンドルされたスキーマを使用するため、新しい Claude Code リリースで導入されたトップレベル設定キーを管理設定に入れるには、まずゲートウェイをアップグレードする必要があります。新しいポリシーはロールアウトする前に 1 つのクライアントでスモークテストしてください。

完全なキーリファレンスは [Claude Code 設定](https://code.claude.com/docs/ja/settings-reference.md#all-settings) にあります。オペレーターが最初に使うことの多いキー：

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
| [`deniedModels`](https://code.claude.com/docs/ja/settings-reference#deniedmodels)、[`availableModelsMatch`](https://code.claude.com/docs/ja/settings-reference#availablemodelsmatch) | ゲートウェイ + CLI | `availableModels` では本来許可される [特定のモデルやバージョンをブロック](https://code.claude.com/docs/ja/model-config.md#block-specific-models-or-versions) します。ブロックされたモデルは `/v1/messages` で `400` により拒否され、`/v1/models` から除外されます。ゲートウェイ自体のチェックには、ゲートウェイサーバー上の Claude Code v2.1.299 以降が必要です。CLI のチェックにはクライアント上の v2.1.283 以降が必要で、それより前のクライアントは両方のキーを無視します。 |
| `permissions.allow` / `.deny` | CLI | ツールとコマンドのルール。[権限](https://code.claude.com/docs/ja/permissions.md)と [Bash ルールが一致しないもの](https://code.claude.com/docs/ja/permissions.md#bash-rule-limits)を参照してください。 |
| `permissions.disableBypassPermissionsMode` | CLI | `disable` に設定すると、[`bypassPermissions`](https://code.claude.com/docs/ja/permission-modes#skip-all-checks-with-bypasspermissions-mode)（権限プロンプトをスキップするモード）と `--dangerously-skip-permissions` フラグをブロックします |
| `allowManagedPermissionRulesOnly` | CLI | `true` の場合、管理設定が権限ルールの唯一の設定ソースになります。[`allowManagedPermissionRulesOnly`](https://code.claude.com/docs/ja/settings-reference#allowmanagedpermissionrulesonly) エントリには、その場合に Claude Code が無視するすべてのソースがリストされています。 |
| `env` | CLI | CLI プロセスにマージされる環境変数。テレメトリ、自動更新、モデル名の上書きに使用します。 |
| `hooks` | CLI | 組織全体の [フック](https://code.claude.com/docs/ja/hooks.md) |
| `managedMcpServers` | CLI | デベロッパーが自分で追加するサーバーとともに [マッチするすべてのデベロッパーに提供される](https://code.claude.com/docs/ja/managed-mcp.md#provide-servers-through-managed-settings) リモート MCP サーバー（`http` と `sse` のみ）。[ポリシー内の MCP サーバー](#mcp-servers-in-a-policy) を参照してください。ゲートウェイサーバーとクライアントの両方で Claude Code v2.1.259 以降が必要です。以前のクライアントはキーを無視します。 |

これらの設定はネットワーク経由で届くため、CLI は以下の設定を適用する前に、各デベロッパーにセキュリティ承認ダイアログを表示します：

* `hooks`
* プロキシやベース URL の変数など、デベロッパーの承認が必要な `env` 変数
* `apiKeyHelper` や `statusLine` などのシェル実行設定
* サンドボックスバイナリ設定 `sandbox.bwrapPath`、`sandbox.socatPath`、`sandbox.ripgrep`
* `sandbox.network.tlsTerminate` やプロキシポート設定など、トラフィックをインターセプトしたり、認証情報を注入したり、分離を弱めたりするサンドボックス設定。[セキュリティ承認ダイアログ](https://code.claude.com/docs/ja/server-managed-settings.md#security-approval-dialogs) にすべてがリストされています。

承認がどのくらい持続し、いつダイアログが再表示されるかについては [承認の記憶](https://code.claude.com/docs/ja/server-managed-settings.md#approval-memory) を参照してください。

Claude Code は、モデル選択の設定や数値の上限など、配信された一部の `env` 変数を、開発者に承認ダイアログを表示せずに適用します。配信されたその他の変数は開発者の承認を必要とする場合があり、空でないプロキシ、ベース URL、または `OTEL_EXPORTER_OTLP_ENDPOINT` の値は常に承認が必要です。配信された変数に承認が必要な場合、ダイアログにその変数名が表示されます。詳細は[環境変数と承認ダイアログ](https://code.claude.com/docs/ja/server-managed-settings.md#environment-variables-and-the-approval-dialog)を参照してください。配信された値によって承認が必要かどうかが決まる 4 つのプライバシー切り替えについても記載されています。

ゲートウェイの [テレメトリ](#telemetry) 設定は `OTEL_EXPORTER_OTLP_ENDPOINT` をプッシュするため、`telemetry.forward_to` を設定すると各インタラクティブクライアントでダイアログが表示されます。このダイアログは、侵害されたゲートウェイや悪意のあるゲートウェイからデベロッパーのマシンを保護するものであり、デベロッパーから組織を保護するものではありません。

`claude -p`、Agent SDK セッション、Claude Desktop の Code タブのセッションなどの[非インタラクティブ実行](https://code.claude.com/docs/ja/server-managed-settings.md#security-approval-dialogs)では、ダイアログを表示できません。その実行に限りプッシュされた設定を適用し、承認済みとして記録しないため、開発者の次のインタラクティブセッションでは引き続きダイアログが表示されます。

デベロッパーが拒否した場合、Claude Code はポリシーを適用せずにそのセッションを終了します。そのため、新しいフックやダイアログが表示される env 変数を広範なポリシーにプッシュすると、マッチするすべてのデベロッパーのインタラクティブセッションでダイアログが表示されます。実行中のインタラクティブセッションでは次の 1 時間ごとのポーリング時に表示され、それ以外の場合はデベロッパーの次のインタラクティブ起動時に表示されます。

`cli` キーは以前のリリースでは `settings` という名前で、ゲートウェイは引き続きその表記をエイリアスとして受け付けます。新しいデプロイでは [`code`](#choose-cli-or-code) を使用してください。

#### デプロイ前にポリシーをテストする

ポリシーの変更をテストするには、使い捨ての Postgres データベースに対してゲートウェイを起動します。ゲートウェイは、`cli`、`code`、`desktop` ブロックの内容をチェックする前に、Postgres に接続してスキーマのマイグレーションを適用します。データベースに到達できない場合、起動は `could not connect to Postgres` で停止し、それらの内容については何も報告されません。

#### ターミナルセッションのコンテキストウィンドウ

`/login` でサインインしたターミナルセッションは、Opus 4.7 以降、Sonnet 5 以降、および Fable モデルで 1M のコンテキストウィンドウを使用します。モデル ID に `[1m]` サフィックスは不要で、セッションは約 967K トークンで圧縮されます。デベロッパーのマシン上の Claude Code v2.1.287 より前では、Claude Code はモデル ID が `[1m]` で終わらない限り、Opus と Fable モデルのウィンドウを 200K として扱っていました。

代わりにターミナルセッションを 200K の境界で圧縮させるには、ポリシーの `env` で [自動圧縮ウィンドウ](https://code.claude.com/docs/ja/model-config.md#set-the-auto-compact-window) を設定します：

```yaml theme={null}
managed:
  policies:
    - match: {}
      cli:
        env:
          CLAUDE_CODE_AUTO_COMPACT_WINDOW: "200000"
```

Claude Code は、デベロッパーに承認ダイアログを表示せずにこの変数を適用します。この変数は、`[1m]` で終わるモデル ID を含むすべてのモデルに適用されます。

代わりに 1M コンテキストをオフにするには、同じ `env` ブロックで [`CLAUDE_CODE_DISABLE_1M_CONTEXT: "1"`](https://code.claude.com/docs/ja/model-config#extended-context) を設定します。すると Claude Code はすべてのモデルのウィンドウを 200K として扱います。インタラクティブセッションでは、この変数が有効になる前に、各デベロッパーが [承認ダイアログ](#what-goes-in-cli) でこれを承認します。

#### 1 時間のプロンプトキャッシュ

デフォルトの 5 分の代わりに 1 時間の [プロンプトキャッシュ TTL](https://code.claude.com/docs/ja/prompt-caching.md#cache-lifetime) をリクエストするには、ポリシーの既存の [`code`、`cli`、または `settings` ブロック](#choose-cli-or-code) にこれらのキーを追加し、ゲートウェイを再起動します。これらのキーには、ゲートウェイサーバーとクライアントの両方で Claude Code v2.1.242 以降が必要です。

`promptCacheTtl` はメインの会話をカバーします。`subagentPromptCacheTtl` はオプションで、サブエージェント、ワークフロー、バックグラウンドリクエストをカバーします。次の例では、`cli` をキーとする `match: {}` ポリシーに両方を追加しています。

```yaml theme={null}
managed:
  policies:
    - match: {}
      cli:
        promptCacheTtl: 1h
        subagentPromptCacheTtl: 1h
```

> [!WARNING]
>
> アップストリームが、ゲートウェイが提供するすべてのモデルで 1 時間の TTL を提供している場合にのみ、これらのキーを設定してください。アップストリームが TTL を拒否した場合、リクエストは失敗し、ゲートウェイも Claude Code も 5 分の TTL で再試行しません。Amazon Bedrock については、[サポートされているモデル、リージョン、制限](https://docs.aws.amazon.com/bedrock/latest/userguide/prompt-caching.html#prompt-caching-models) を確認してください。

`promptCacheTtl` を確認するには、ポリシーが一致するユーザーとしてゲートウェイにサインインし、[キャッシュ書き込みに使用された TTL を確認](https://code.claude.com/docs/ja/prompt-caching.md#choose-the-ttl-yourself) します。`--model` を渡して、ゲートウェイが提供する各モデルについて確認を繰り返してください。

1 時間のキャッシュ書き込みは、5 分の書き込みより [コストが高く](https://code.claude.com/docs/ja/prompt-caching.md#cache-lifetime) なります。[支出上限](https://code.claude.com/docs/ja/claude-apps-gateway-spend-limits.md#how-requests-are-priced) でその高い料金をカウントするには、ゲートウェイサーバーに v2.1.286 以降が必要です。

#### ポリシー内の MCP サーバー

ポリシーがマッチする Claude Code クライアントに MCP サーバーを提供するには、そのポリシーの `cli` ブロックで [`managedMcpServers`](https://code.claude.com/docs/ja/managed-mcp#provide-servers-through-managed-settings) を設定します。ゲートウェイサーバーとクライアントの両方で Claude Code v2.1.259 以降が必要です。

ゲートウェイはブート時に [Claude Code がクライアントで適用するのと同じルール](https://code.claude.com/docs/ja/managed-mcp.md#what-an-entry-can-contain) で各エントリをチェックし、エントリがチェックに失敗した場合は起動を拒否してそのエントリを示します。

`gateway.yaml` に `${VAR}` 参照を記述した場合、ゲートウェイはエントリチェックを実行する前に、ブート時に [シークレット展開](#secret-expansion) を通じて自身の環境から解決します。そのため、マッチするすべてのクライアントはリテラル値を受け取り、それを読むことができます。[提供されるサーバーのヘッダーに関するガイダンス](https://code.claude.com/docs/ja/managed-mcp.md#provide-servers-through-managed-settings) は展開後の値に適用されます。

ゲートウェイは `cli` ブロック内の `.mcp.json` 表記 `mcpServers` を拒否し、そのブートエラーでは使用すべきキーとして `managedMcpServers` を示します。v2.1.259 より前では、ゲートウェイは `cli` ブロック内のすべての MCP サーバー定義を拒否していました。

#### Claude Desktop オーバーレイ

組織が [Claude Desktop](https://code.claude.com/docs/ja/desktop.md) もデプロイしている場合、同じゲートウェイが両方のクライアントに対応します。Claude Desktop の [管理設定](https://claude.com/docs/third-party/claude-desktop/configuration) の `bootstrapUrl` を `<listen.public_url>/user/bootstrap` に向けてください。Claude Desktop はその URL から OAuth 発行者を導出し、このゲートウェイに対して同じデバイスコードサインインを実行し、レスポンスから設定を取得します。

> [!NOTE]
>
> ゲートウェイサーバー上の Claude Code v2.1.203 以降と、明示的なオプトインが必要です：ユーザーにマッチするポリシーが `desktop` キーを持たない限り、`/user/bootstrap` は 404 を返します。空の `desktop: {}` でポリシーをオプトインでき、`match: {}` 基盤層の `desktop` キーはそれを継承するすべてのポリシーをオプトインします。監査ログは各リクエストを `desktop_bootstrap.serve` または `desktop_bootstrap.denied` として記録します。

Claude Desktop をデプロイしない場合は、ポリシーから `desktop` を完全に省略してください。その場合、ゲートウェイはすべてのユーザーに対して `/user/bootstrap` から 404 を返します。

##### ゲートウェイが Claude Desktop 用に導出する設定

ゲートウェイは、ブートストラップレスポンスの大部分を、一致したポリシーの `cli` または `code` ブロックと、トップレベルのゲートウェイ設定から導出します。

* モデルリスト。`availableModels` から導出されます。このリストには、ポリシーが [`deniedModels` または `availableModelsMatch: exact`](#what-goes-in-cli) でブロックしたモデルは含まれません。このフィルターには、ゲートウェイサーバー上の Claude Code v2.1.299 以降が必要です。各モデルの 1M コンテキストオプションについては [Claude Desktop の拡張コンテキスト](#extended-context-in-claude-desktop) で説明しています
* ツール名のみの `permissions.deny` エントリからの無効化されたツール。ポリシーの `desktop` ブロックで `disabledBuiltinTools` を設定した場合、ゲートウェイは指定した値と導出されたリストの和集合を提供します。そのため、この方法でさらにツールを無効化できますが、`permissions.deny` で無効化したツールを再度有効化することはできません
* `sandbox.network.allowedDomains` から導出される送信許可リスト。ポリシーの `desktop` ブロックで `coworkEgressAllowedHosts` を設定すると、ゲートウェイは導出リストの代わりにその値を使用します。ゲートウェイが提供する許可リストに `*` が含まれ、かつゲートウェイが Claude Desktop の [`allowedWorkspaceFolders`](https://claude.com/docs/third-party/claude-desktop/code#applied-as-managed-policy) も提供していない場合、Claude Desktop は Code タブで [Bash サンドボックス](https://code.claude.com/docs/ja/sandboxing.md)をオンにしません
* ゲートウェイ自体を指す OTLP エンドポイントと、サインインしたユーザーのアイデンティティ属性。ゲートウェイはそのエンドポイントで受け取ったエクスポートを `forward_to` の宛先にリレーします。[`telemetry.forward_to`](#telemetry) と `listen.public_url` の両方を設定した場合に、エンドポイントと属性が含まれます。

  Claude Desktop はすべてのシグナルを 1 つのエンコーディングでエクスポートします：`http/protobuf`、またはポリシーの `env` で `OTEL_EXPORTER_OTLP_PROTOCOL` またはそのシグナルごとのバリアントのいずれかを `http/json` に設定した場合は `http/json` です。ゲートウェイサーバー上の Claude Code v2.1.261 より前では、レスポンスは常に `http/json` を設定していたため、protobuf のみを受け入れるコレクターは Claude Desktop のエクスポートを拒否していました

ポリシーの `desktop` ブロックで `disabledBuiltinTools`、`coworkEgressAllowedHosts`、または Claude Desktop 独自の `managedMcpServers` 設定を設定するには、ゲートウェイサーバー上の Claude Code v2.1.232 以降が必要です。Claude Desktop の `managedMcpServers` はオブジェクトではなく配列値を取ります。

ゲートウェイは、`hooks` や `Bash(npm *)` のようなスコープ付き権限ルールなど、Claude Desktop に相当するものがないキーをブートストラップレスポンスから省略します。

##### Code タブで `code` 設定を適用する

ポリシーが [`code`](#choose-cli-or-code) キーの下に持つ Claude Code 設定は、次のすべてが成り立つ場合に Claude Desktop の Code タブで適用されます。

* ポリシーに `desktop` キーもあること（空の `desktop: {}` でもかまいません）
* Claude Desktop がバージョン 2.9939.2 以降であること
* マシン上の Claude Code 管理設定が [このゲートウェイを指定している](#client-side-managed-settings) こと
* そのマシンが、プライベートネットワーク上で HTTPS 経由でゲートウェイに到達できること

最後の 2 つの条件は、セッションで Claude Code を実行するマシンに適用されます。ローカルセッションの場合はユーザー自身のコンピューターです。SSH 経由の Code タブセッションの場合はリモートホストです。

`cli` を `code` に名前変更する前に、それらのマシンに [クライアント側の管理設定](#client-side-managed-settings) をデプロイしてください。最初の 2 つの条件が成り立ち、最後の 2 つのいずれかが成り立たない場合、ポリシーに一致するユーザーには次のいずれかの結果になります。

* **HTTPS 経由で、Claude Desktop に Claude Code v2.1.296 以降がバンドルされている場合**: Code タブは開始されず、ユーザーのプロンプトへの応答でその理由が示されます
* **HTTPS 経由で、Claude Desktop にそれより前のバージョンがバンドルされている場合**: Code タブは `code` 設定なしで開始され、セッション内ではそのことは何も示されません
* **プレーン HTTP 経由の場合**: Claude Desktop にどのバージョンがバンドルされていても、Code タブは `code` 設定なしで開始されます

ゲートウェイの前段にあるプロキシが `/managed/settings` に独自の 404 で応答する場合も、4 つの条件をすべて満たすマシンであっても、Code タブは `code` 設定なしで開始されます。

`desktop` キーを持つポリシーで、設定を含む `code` ブロックがあると、Cowork、Chat、Code タブで WebSearch ツールがオフになります。MCP サーバーについては、[`managedMcpServers` が適用される場所](https://code.claude.com/docs/ja/managed-mcp#where-managedmcpservers-applies) を参照してください。

##### Claude Desktop の設定を直接指定する

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

##### ゲートウェイがブート時に拒否するもの

ゲートウェイはブート時に各 `desktop` ブロックを Claude Desktop 自体が使用する設定スキーマに対して検証するため、間違いは接続されたすべてのデスクトップに届くのではなく、ゲートウェイ起動時にキーを示すエラーとして表面化します。ブロックに以下が含まれる場合、ゲートウェイはブート時に失敗します：

* 不明なキー
* 空の値やネストされたエントリ内のサブキーのスペルミスなど、Claude Desktop が拒否するか黙って破棄する値を持つ認識済みのキー。v2.1.260 より前では、ゲートウェイは `managedMcpServers` または `orgPluginSettings` エントリのネストされたオブジェクト内のスペルミスのあるフィールドを、ブート時に失敗させずに黙って破棄していました。
* ゲートウェイ自身が計算するキー：推論接続、モデルリスト、OTLP リレー。これらは [`upstreams`](#upstreams)、[`models`](#models)、[`telemetry`](#telemetry) セクションの `forward_to` で設定してください。
* 現在のキーのレガシーエイリアス。ブートエラーでは、ゲートウェイは記述すべき正規のキーを示します。

`transport` のない `managedMcpServers` エントリなど、非推奨の値やエントリ形式を使用した場合、ゲートウェイは起動し、代替を示す警告をログに記録します。

v2.1.232 より前では、ゲートウェイは `chatTabEnabled` や `disableAutoUpdates` など 11 個の機能ゲートキーの固定リストを受け入れ、その他のすべてのキーをブート時に拒否していました。v2.1.227 より前では、ゲートウェイは `chatTabEnabled` と `chatAdvancedFileAnalysisEnabled` もブート時に拒否していました。

##### より新しいゲートウェイまたは Claude Desktop のバージョンが必要なキー

ゲートウェイは `cli` ブロックと同様に、インストール済みバージョンにバンドルされたスキーマに対して `desktop` ブロックを検証します。新しい Claude Desktop リリースで導入された設定を配信するには、まずゲートウェイをアップグレードしてください。例えば、`userPluginMarketplacesEnabled` と `userPluginUploadsEnabled` には、ゲートウェイサーバー上の Claude Code v2.1.260 以降と、メンバーのマシン上の Claude Desktop 1.37937.0 以降が必要です。

`blockReadsOutsideWorkingDirectories`、`disableBypassPermissionsMode`、`configRecheckIntervalMinutes`、`sshClientPath` には、ゲートウェイサーバー上の Claude Code v2.1.281 以降が必要です。`microsoftAuthBroker` の `required` 値と、Microsoft 365 `managedMcpServers` エントリの `continuousAccessEvaluation` フィールドも同様です。`required` 値より前の Claude Desktop リリースはそれを `disabled` として読み取るため、すべてのメンバーの Claude Desktop がサポートしてから `required` を設定してください。Claude Desktop の [管理設定リファレンス](https://claude.com/docs/third-party/claude-desktop/configuration) には、各キーを最初に読み取るリリースがリストされています。

ポリシーの `desktop` ブロックで `orgPluginSettings` を設定した場合、ゲートウェイは Claude Desktop 1.15200.0 以降が読み取る配列形式で提供します。古いデスクトップは配列を無視し、プラグインツールポリシーを強制しないため、それに依存する前にメンバーを 1.15200.0 以降に更新してください。

##### ロールポリシーが基盤の `desktop` ブロックを継承する仕組み

ゲートウェイは、ポリシーの `cli` ブロックを基盤から補完するのと同じ方法で、ポリシーの `desktop` ブロックが設定していないキーを `match: {}` キャッチオールの `desktop` ブロックから補完します。基盤とロールポリシーの両方で `disabledBuiltinTools` または `builtinToolPolicy` を設定した場合、ゲートウェイは基盤の制限を維持します：

* `disabledBuiltinTools`：ゲートウェイは基盤のリストとポリシーのリストの和集合を使用します
* `builtinToolPolicy`：基盤でツールを `allow` 以外の値に設定した場合、ロールポリシーで同じツールに `allow` を設定しても、ゲートウェイはその値を維持します

その他のすべてのキーについては、ロールポリシーで設定した場合、ゲートウェイはロールポリシーの値を使用します。ゲートウェイは配列や `banner` などのネストされたオブジェクトを丸ごと置き換えるため、ロールポリシーで `banner.text` を設定すると、ゲートウェイは基盤の `banner.backgroundColor` を破棄します。

##### ポリシーの変更が Claude Desktop に届くタイミング

変更したポリシーでゲートウェイを再デプロイした後、Claude Desktop はほとんどの設定を次回の起動時にのみ適用します：

* **閉じている場合**：Claude Desktop は起動時にブートストラップレスポンスを取得するため、変更は次回の起動から適用されます
* **開いている場合**：Claude Desktop はデフォルトで 10 分ごとにレスポンスの変更を確認し、一部の設定は再起動なしで適用します。[`skillCreationEnabled`](https://claude.com/docs/third-party/claude-desktop/configuration#skillcreationenabled) などのその他の設定については、ユーザーのサイドバーに **Relaunch Claude Desktop** カードが表示され、アプリを再起動するまで以前の設定が維持されます。デフォルトでは 24 時間後に、Claude Desktop は再起動ダイアログを表示し、2 分間操作がないと自動的に再起動します

24 時間を短縮するには、ポリシーの `desktop` ブロックで [`relaunchEnforcementHours`](https://claude.com/docs/third-party/claude-desktop/configuration#relaunchenforcementhours) を設定します。ゲートウェイサーバー上の Claude Code v2.1.260 以降と、メンバーのマシン上の Claude Desktop 1.40609.0 以降が必要です。`0` にすると、Claude Desktop が変更を検出するとすぐにダイアログが表示されます。

#### Claude Desktop の拡張コンテキスト

ゲートウェイから [Claude Desktop](#claude-desktop-overlay) に提供している場合、そのモデルピッカーは、1M のコンテキストウィンドウで実行できるリスト内の各モデルについて 1M コンテキストオプションを提供します。これには Claude Opus 4.6 以降、Claude Sonnet 4.6 以降、および Fable モデルが含まれます。このオプションはモデルの `[1m]` バリアントであり、[拡張コンテキスト](https://code.claude.com/docs/ja/model-config.md#extended-context) で説明されています。ゲートウェイサーバー上の Claude Code v2.1.284 以降が必要です。

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

##### 1M オプションを削除する

ピッカーからオプションを削除するには、ポリシーの `cli` キーの下の `env` ブロックで `CLAUDE_CODE_DISABLE_1M_CONTEXT: "1"` を設定します。`id` が `[1m]` で終わるエントリもリストしていた場合、ゲートウェイは引き続きそれを提供するため、そのエントリも削除してください。

この変数は、ポリシーがマッチするデベロッパーのターミナルセッションにも届きます。そこで何が変わるかについては、[拡張コンテキスト](https://code.claude.com/docs/ja/model-config.md#extended-context) を参照してください。

#### 他の管理ソースとの優先順位

デバイスに MDM で配信されたポリシーやローカルの `managed-settings.json` もある場合、ゲートウェイで配信された設定が最優先になります。管理設定ページの [管理層内の優先順位](https://code.claude.com/docs/ja/managed-settings.md#precedence-within-the-managed-tier) には、ローカルソースが適用される場合と、サンドボックスロックキー、`forceRemoteSettingsRefresh`、変数ごとの `env` マージなど、どのソースを選択したかに関わらず [Claude Code がすべての管理ソースから読み取るキー](https://code.claude.com/docs/ja/managed-settings.md#keys-read-from-every-admin-source) が記載されています。MDM プロファイルまたは管理設定ファイルで設定された [`policyHelper`](https://code.claude.com/docs/ja/settings-reference#policyhelper) は、ゲートウェイが設定を配信しない場合にのみ実行されます。そのエントリには、その出力が何を置き換えるかが記載されています。

[Claude Desktop](https://code.claude.com/docs/ja/desktop.md) などの埋め込みホストは、SDK の `managedSettings` オプションを通じてポリシーを提供できます。[埋め込みホストからの親設定](https://code.claude.com/docs/ja/managed-settings.md#parent-settings-from-embedding-hosts) には Claude Code がそれを適用する場合が、[親設定を制限する](https://code.claude.com/docs/ja/claude-apps-gateway#restrict-parent-settings) には `allowManaged*Only` ロックがなくても適用される許可方向の設定がリストされています。

ゲートウェイポリシーは、非インタラクティブな `claude -p` 実行や Agent SDK によって生成されたセッションを含め、マシン上のすべての Claude Code 呼び出しに適用されます。起動時にゲートウェイに到達できない場合、サインイン済みセッションはポリシーなしで実行されるのではなく、エラーで終了します。

### `telemetry`

CLI はメトリクス、ログ、および有効な場合はトレースをゲートウェイに送信し、ゲートウェイはそれらをそのまま各設定済みの宛先にリレーします。エクスポートは HTTP 上の OpenTelemetry Protocol（OTLP）を使用します。リレーをスキップしてセッションからコレクターに直接エクスポートするには、[ポリシーでコレクターを指定](#export-directly-to-your-collector) します。CLI が出力するメトリクスとイベントについては [使用状況の監視](https://code.claude.com/docs/ja/monitoring-usage.md) を参照してください。

`/login` でサインインしたセッションでは、CLI は各エクスポートに、ゲートウェイが発行した JWT から読み取った認証済みユーザーの ID、つまり `user.id`、`user.email`、`user.groups` 属性を付与します。そのため、開発者側の設定なしで、開発者ごとのコストと使用量の帰属が機能します。開発者がサインインする前に Claude Code がログに記録したイベントには、[この ID は含まれません](https://code.claude.com/docs/ja/monitoring-usage.md#standard-attributes)。開発者のグループが変更されたときにどの属性がそれに追従するかについては、[セッション中のグループの変更](#group-changes-during-an-open-session) を参照してください。

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

> [!WARNING]
>
> 各宛先は `metrics`、`logs`、`traces` に個別にオプトインし、デフォルトはメトリクスのみです。シグナルごとに機密性が異なります：
>
> * **メトリクス**：トークン数、リクエスト数、レイテンシーなどの集計カウンター
> * **ログとトレース**：完全な Bash コマンド、ツール入力、ファイルパスを含むことがあり、Claude Code がデベロッパーのマシンで行うあらゆることをカバーします
>
> ログとトレースは、そのデータに必要なアクセス制御と保持ポリシーを備えた宛先でのみ有効にしてください。

各 `forward_to` URL は `https://` を使用する必要があります。ただし、ゲートウェイ自身のループバックインターフェイス上のコレクターについては 1 つの例外があります：

* `http://localhost:<port>` は設定検証を通過しますが、ゲートウェイの環境で `CLAUDE_GATEWAY_ALLOW_LOOPBACK=1` を設定しない限り、[SSRF ガード](https://code.claude.com/docs/ja/claude-apps-gateway-deploy.md#threat-model-summary) がすべてのエクスポートを `ECONNREFUSED_SSRF` でブロックします
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

[トレース](https://code.claude.com/docs/ja/monitoring-usage.md#traces-beta) には、各クライアントで `CLAUDE_CODE_ENHANCED_TELEMETRY_BETA=1` も必要です。ゲートウェイはこれをプッシュしないため、管理ポリシーの `env` ブロックで設定してください。デベロッパーは、プッシュされたエンドポイントで既に表示される同じ [セキュリティ承認ダイアログ](#managed) でこれを承認します。

トレースしたいグループのポリシーでのみ `1` に設定してください。これを設定しないポリシーは、[マージルール](#managed) に従い、`match: {}` キャッチオールポリシーが値を設定していればその値を継承します。デベロッパーがローカルで変数を設定してもグループのクライアントからトレースが送信されないようにするには、そのグループのポリシーで `0` に設定してください。

protobuf と JSON の両方の OTLP エンコーディングがリレーされ、OpenTelemetry 互換の任意のバックエンドを宛先として使用できます。

#### 累積メトリクスを送信する

コレクターが累積メトリクスのみを受け付ける場合は、[`OTEL_EXPORTER_OTLP_METRICS_TEMPORALITY_PREFERENCE`](https://code.claude.com/docs/ja/monitoring-usage#common-configuration-variables) を `cumulative` に設定します。Claude Code はデフォルトでデルタメトリクスを送信し、ゲートウェイはそれらを変換せずに中継します。各種類のセッションがこの変数を読み取る場所で設定してください。

* **ターミナルセッション**: ポリシーの [`cli` または `code` キー](#choose-cli-or-code) の下の `env` ブロック
* **[ユーザーのマシンで実行される](https://code.claude.com/docs/ja/managed-settings.md#where-and-when-a-policy-applies) Cowork セッション**: そのマシン上の [クライアント側の管理設定](#client-side-managed-settings) の `env` ブロック
* **`code` ポリシーの下の Code タブセッション**: [`code` 設定が適用される条件](#apply-code-settings-in-the-code-tab) を満たしたうえで、ポリシーの `env` ブロック
* **`cli` ポリシーの下の Code タブセッション**: セッションを実行するマシン上のクライアント側の管理設定の `env` ブロック。SSH 経由の場合はリモートホストです。

マシンの管理設定に変数を追加する場合は、そのマシン上の優先順位が最も高いソースで [`parentSettingsBehavior: "merge"`](https://code.claude.com/docs/ja/claude-apps-gateway#set-the-opt-in) も設定してください。これがないと、Cowork セッションと `cli` ポリシーの下の Code タブセッションは、Claude Desktop が親設定として渡すエグレス許可リストやその他のポリシーなしで実行されます。

#### 独自のラベルを追加する

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

Claude Code は各ラベルをすべてのメトリクスデータポイントにもコピーするため、リソース属性をインデックス化しないバックエンドでもラベルでメトリクスをフィルタリングできます。このコピーをオフにするには、[メトリクスのカーディナリティ制御](https://code.claude.com/docs/ja/monitoring-usage.md#metrics-cardinality-control) を参照してください。

#### セッション中のグループの変更

ターミナルセッションは、`user.groups` を OTLP リソースに付与し、さらに各メトリクスのデータポイントとイベントにも付与します。セッション中に開発者のグループが変更された場合、次の[サイレントリフレッシュ](#session)以降の使用に関するデータポイントとイベントには新しいグループが含まれます。リソースは開発者が Claude Code を再起動するまで古いグループを保持するため、データポイントまたはイベント上の属性でグループ化してください。

OpenTelemetry Collector の Prometheus リモート書き込みエクスポーターで `resource_to_telemetry_conversion` をオンにすると、エクスポーターは各データポイントの `user.groups` をリソースのもので置き換えるため、すべてのデータポイントに古いグループが表示されます。データポイントの値を維持するには、そのエクスポーターの前にリソースから `user.groups` を削除してください。

次の OpenTelemetry Collector の `resource` プロセッサーは、それを列挙したパイプラインで属性を削除します。

```yaml theme={null}
processors:
  resource/drop-user-groups:
    attributes:
      - key: user.groups
        action: delete
```

メトリクスパイプラインの `processors` に `resource/drop-user-groups` を追加すると、各系列は自身のデータポイントから `user_groups` ラベルを持つようになります。

#### コレクターに直接エクスポートする

`/login` でサインインしたセッションからリレーを経由せずにコレクターに直接テレメトリを送信するには、[管理ポリシー](#managed) の `env` ブロックで `OTEL_EXPORTER_OTLP_ENDPOINT` をコレクターの `https://` ベース URL に設定します。Claude Code は `https://otel-collector.example.com:4318` のように設定した URL に `/v1/metrics`、`/v1/logs`、または `/v1/traces` を付加し、各シグナルを OTLP/HTTP でそこにエクスポートします。各デベロッパーのマシン上の Claude Code v2.1.265 以降が必要です。以前のクライアントはリレー経由でエクスポートします。

コレクターへの認証には、同じ `env` ブロックで `OTEL_EXPORTER_OTLP_HEADERS` を設定します。セッションは、この方法で指定されたコレクターにデベロッパーのゲートウェイセッショントークンを送信することはありません。

ポリシーでこのエンドポイントを追加または変更すると、Claude Code はインタラクティブセッションで適用する前に、[セキュリティ承認ダイアログ](#managed) で各デベロッパーに承認を求めます。

Claude Code はシグナルを直接エクスポートする前にエンドポイントをチェックし、チェックに失敗した場合はそのシグナルをリレーに残します。チェックには次のものが含まれます：

* エンドポイントがゲートウェイ自体から来ていること。MDM プロファイルやローカルの `managed-settings.json` で同じ変数を設定した場合、エクスポートはリレーに残ります。
* URL が `https://`、またはループバックアドレスへの `http://` を使用していること
* URL が `/v1/<signal>` で終わるパスに解決され、クエリやフラグメントがないこと。Claude Code は汎用変数からこのパスを自身で構築します。`OTEL_EXPORTER_OTLP_METRICS_ENDPOINT` などのシグナルごとの変数は記述どおりに使用するため、そこには完全なパスを含めてください。
* URL がゲートウェイ自身のホストではないこと。ゲートウェイ宛てのエンドポイントはリレーパスとそのセッショントークンを維持します。
* 管理者とデベロッパーのどちらも、いずれの設定ソースでも [`otelHeadersHelper`](https://code.claude.com/docs/ja/settings-reference#otelheadershelper) を設定していないこと。ヘルパーが設定されている場合、すべてのシグナルはリレーに残ります。

指定したエンドポイントによって変わるのはエクスポート先のみです。どのシグナルをエクスポートするかは、引き続き `OTEL_*_EXPORTER` セレクターで選択します。

エンドポイントだけではエクスポートはオンにならないため、ゲートウェイが既にプッシュしていない限り、エクスポートをオンにする変数も設定してください：

* ゲートウェイが既に [テレメトリ変数をプッシュ](#telemetry) している場合、それらが有効化、セレクター、プロトコルをカバーし、明示的に指定したエンドポイントがプッシュされた `<public_url>` 値を上書きします。`OTEL_*_EXPORTER` セレクターを自分で `otlp` に設定するのは、どの `forward_to` 宛先も有効にしていないシグナルについてのみです。
* プッシュしていない場合は、`CLAUDE_CODE_ENABLE_TELEMETRY=1`、`OTEL_*_EXPORTER` セレクター、`OTEL_EXPORTER_OTLP_PROTOCOL=http/protobuf` も設定してください。

デベロッパーがサインアウトするか別のゲートウェイにサインインすると、コレクターへのエクスポートは停止し、Claude Code は残りの各バッチを送信せずに破棄します。

#### 宛先が失敗した場合

ゲートウェイはテレメトリのバッファリング、再試行、保存を行わないため、宛先に届かなかったエクスポートは後から配信されるのではなく破棄されます。各宛先は個別に成功または失敗し、エクスポート元のクライアントはどちらの場合も成功レスポンスを受け取るため、配信の失敗はゲートウェイのログにのみ表示されます。

宛先への配信が 5 回連続で失敗すると、ゲートウェイは配信が成功するまで、その宛先への転送を 30 秒ずつ一時停止し、各一時停止をログに記録します。エラーレスポンス、タイムアウト、接続エラーはいずれも配信失敗としてカウントされます。ただし、`400`、`413`、`415`、`422`、`431` は除きます。これらは、コレクターがそのエクスポートのペイロードを不正な形式または大きすぎるとして拒否したことを意味します。

拒否されたペイロードは失敗カウントを進めることもリセットすることもありません：ゲートウェイはその宛先への転送を続け、宛先の最初の拒否とその後 100 回ごとに、宛先とステータスを示す警告をログに記録します。

### HTTP チューニング

4 つのオプションのトップレベルブロック `access_control`、`limits`、`timeouts`、`rate_limits` で HTTP サーフェスをチューニングします。デフォルトはほとんどのデプロイに適しています。

| ブロック | キー | デフォルト | 説明 |
| - | - | - | - |
| `access_control` | `allow_cidrs` / `deny_cidrs` | 空 | `trusted_proxies` による解決後のクライアントアドレスによるインバウンド IP の許可/拒否。`deny_cidrs` が最初にチェックされ、それにマッチするクライアントは `allow_cidrs` にもマッチしても拒否されます。`allow_cidrs` が空でない場合、ゲートウェイはデフォルト拒否になります。`/healthz` と `/readyz` は `allow_cidrs` の対象外です。信頼されたプロキシが IP アドレスではない `X-Forwarded-For` エントリを送信した場合、実際のクライアントは不明となり、ゲートウェイは確認すべき内容を示す警告を 1 回ログに記録します。いずれかのリストがリクエストに適用される場合は、`403` と監査理由 `xff_unparseable` でリクエストを拒否します。どちらも適用されない場合は、リクエストを処理し、IP ごとのレート制限と監査のクライアント IP としてプロキシ自身のアドレスを使用します。 |
| `limits` | `max_request_bytes` | 32 MiB | インバウンドリクエストボディの最大サイズ。サイズを超えたリクエストはボディがバッファリングされる前に `413` を受け取ります。大きなファイルや画像のリクエストの場合は上げてください。 |
| `limits` | `max_request_header_bytes` | 未設定 | リクエストのヘッダー全体に対するゲートウェイの 256 KiB の制限を引き下げます。制限を超えたリクエストは `431` を返し、256 KiB を超える値は効果がありません。サインイン後にデベロッパーが `431` を受け取る場合は、[サインイン後にリクエストヘッダーが大きすぎる](https://code.claude.com/docs/ja/claude-apps-gateway-deploy.md#request-headers-too-large-after-sign-in) を参照してください。 |
| `limits` | `max_url_length` | 未設定 | 設定されている場合、長すぎる URL は `414` を返します |
| `timeouts` | `upstream_ttfb_ms` | 120000 | 上流のレスポンスヘッダーの最大待機時間（最初のバイトまでの時間）。その後、レスポンスボディは経過時間の上限なしでストリーミングされます。直接 Anthropic 上流パスに適用されます。他のすべてのプロバイダーでは、ゲートウェイはレスポンスが開始されるまで最大 1 時間待機します。 |
| `rate_limits` | `device_authorization.max` / `.window_seconds` | 30 / 600 | 認証されていないデバイス認可エンドポイントの IP ごとのレート制限。共有出力 IP や NAT の背後にある大規模な組織の場合は上げてください。サイズの決め方は [大規模ロールアウト](https://code.claude.com/docs/ja/claude-apps-gateway-deploy.md#large-rollouts) を参照してください。これらの制限はデバイスグラントのサインインフローにのみ適用され、`/v1/messages` の推論には適用されません。[ユーザーコードのブルートフォース耐性](https://code.claude.com/docs/ja/claude-apps-gateway-deploy.md#user-code-brute-force-resistance) を参照してください。 |
| `rate_limits` | `device_verify.max` / `.window_seconds` | 10 / 600 | `/device` での `user_code` 送信の IP ごとのレート制限。他のデベロッパーのコードの推測を防ぐものです。どこまで上げるかについては [大規模ロールアウト](https://code.claude.com/docs/ja/claude-apps-gateway-deploy.md#large-rollouts) を参照してください。 |

デフォルトのように両方の `access_control` リストを空のままにすると、ゲートウェイはすべてのクライアントアドレスにサービスを提供するため、ゲートウェイに到達できるユーザーを制限するのはネットワークのみになります。ゲートウェイはデベロッパーのマシンでコマンドを実行する [管理設定](#managed) をプッシュできるため、これは重要です。

`allow_cidrs` が空の間、ゲートウェイはリクエストへの応答方法を変えずに、2 か所で警告します：

* **ブート時**：運用ログの警告で、プライベート範囲 `10.0.0.0/8`、`172.16.0.0/12`、`192.168.0.0/16`、`100.64.0.0/10`、`127.0.0.0/8`、`::1/128`、`fc00::/7` と、デベロッパーが接続元とするその他の内部範囲のみを許可することを推奨します。ローカル開発のように、ゲートウェイをループバックアドレスにバインドし、`trusted_proxies` も `public_url` も設定していない場合、この警告は表示されません。
* **実行時**：これらのプライベート範囲外のアドレスから初めてリクエストが届いたとき、ゲートウェイは警告をログに記録し、クライアント IP を含む [`access.public_client` 監査イベント](https://code.claude.com/docs/ja/claude-apps-gateway-deploy#logs) を発行します。どちらもプロセスごとに 1 回発生します。リンクローカルアドレス `169.254.0.0/16` と `fe80::/10` はパブリックとしてカウントされません。ゲートウェイはこのチェックの実行前に `/healthz` と `/readyz` に応答するため、パブリック範囲からのヘルスプローブではトリガーされません。

どちらのシグナルも、ゲートウェイが解決したクライアントアドレスを使用します。ロードバランサー、ポートフォワード、またはトンネルがトラフィックをリレーしていて、`listen.trusted_proxies` にリストされていない場合、ゲートウェイにはリレーのアドレス（通常はプライベート）が見えるため、実行時の警告もプライベートの許可リストも、それを経由してリレーされたトラフィックを検出できません。

そのようなフロントエンドの背後では、まず [`listen.trusted_proxies`](#listen) を設定してゲートウェイが実際のクライアントアドレスを見られるようにし、いずれにしてもゲートウェイとその前段にあるすべてのものをパブリックインターネットから到達できないようにしてください。

### `load_test_mode`

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

> [!WARNING]
>
> デベロッパーが使用するゲートウェイでは絶対にこれをオンにしないでください。すべてのリクエストが定型の返信を受け取り、モデルは呼び出されません。モードがオンの間、ゲートウェイはブート時に `load_test_mode is on` 警告をログに記録し、各 `inference` [監査イベント](https://code.claude.com/docs/ja/claude-apps-gateway-deploy.md#logs) に `load_test: true` を付けます。

## 完全な例

この完全なリファレンス設定は、すべてのコアセクションを実行します。[HTTP チューニングブロック](#http-tuning)はデフォルト値を保持します。これをコピーして、不要な部分を削除し、値を入力してください。[クイックスタート](https://code.claude.com/docs/ja/claude-apps-gateway#quickstart)の設定は、これの最小限のバージョンです。

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
          allow: [Read, Grep, Edit]
          deny: ["WebFetch"]
        env: { HTTP_PROXY: http://proxy.example.com:8080 }

telemetry:
  forward_to:
    - url: https://otel.internal.example.com:4318
      headers:
        Authorization: Bearer ${OTEL_TOKEN}
```

## クライアント側で管理される設定

上記のすべてはゲートウェイサーバーを設定します。開発者マシンはゲートウェイに別途ポイントし、各デバイスで Claude Code の[管理設定](https://code.claude.com/docs/ja/managed-settings.md)を通じて設定します。ゲートウェイはログインキー自体をプッシュできません。これらのキーがクライアントにゲートウェイの場所を伝えるためです。

CLI の場合、OS ごとの `managed-settings.json` でこれらのキーを設定します。2 つのログインキーは各開発者の `/login` をゲートウェイにルーティングします。

```json theme={null}
{
  "forceLoginMethod": "gateway",
  "forceLoginGatewayUrl": "https://claude-gateway.internal.example.com",
  "parentSettingsBehavior": "merge"
}
```

`parentSettingsBehavior: "merge"` は Claude Desktop の出力許可リストの配信を埋め込み Claude Code セッションで機能させ続けます。[Claude Desktop セッションにポリシーを配信する](https://code.claude.com/docs/ja/claude-apps-gateway#deliver-policy-to-claude-desktop-sessions)はメカニズムと opt-in が配置される場所を説明しています。

開発者がクラウドプロバイダー変数または独自の `ANTHROPIC_BASE_URL` でゲートウェイをバイパスするのを防ぐには、同じファイルに `"allowedProviders": ["gateway"]` を追加します。Claude Code はその後、マシン上でクラウドゲートウェイ用に設定されていないすべてのセッションを拒否し、`forceLoginGatewayUrl` が指定するゲートウェイ、またはファイルの `env` ブロックが `ANTHROPIC_BASE_URL` として設定する URL を持つゲートウェイのみを認めます。`claude gateway` はこのリストを設定するマシンでの実行を拒否するため、ゲートウェイホストではこのキーをオフのままにしてください。設定リファレンスの [`allowedProviders`](https://code.claude.com/docs/ja/settings-reference#allowedproviders) エントリを参照してください。Claude Code v2.1.285 以降が必要です。

`managed-settings.json` ファイルを各デバイスにデプロイします。通常は MDM プラットフォーム経由です。ファイルパスはプラットフォームによって異なります。[各メカニズムがポリシーを保存する場所](https://code.claude.com/docs/ja/managed-settings.md#where-each-mechanism-stores-the-policy)を参照してください。

デフォルトでは、Windows のレジストリポリシーまたは macOS のマネージドプリファレンス plist は、[上記の例外キーとクロスソースチェック](#precedence-with-other-managed-sources)を除き、`managed-settings.json` ファイルとマージするのではなく置き換えます。このスニペットの 3 つのキーはすべて最優先ソースルールに従うため、Group Policy または設定プロファイルを通じてポリシーを配信するフリートは、代わりにそのメカニズムにすべての 3 つを配置する必要があります。

Claude Desktop の場合、Claude Desktop 独自の[マネージド設定](https://claude.com/docs/third-party/claude-desktop/configuration)で `bootstrapUrl` キーを `<listen.public_url>/user/bootstrap` に設定します。サインインフロー及びグループごとのポリシーは、ポリシーが `desktop` キーでサーバー側で opt-in した後、CLI のものと一致します。opt-in がない場合、`/user/bootstrap` は 404 を返します。[Claude Desktop オーバーレイ](#claude-desktop-overlay)でサーバー側の半分を参照してください。

Claude Code は [`forceLoginGatewayUrl`](https://code.claude.com/docs/ja/settings-reference#forcelogingatewayurl)、[`gatewayInternalNetworks`](https://code.claude.com/docs/ja/settings-reference#gatewayinternalnetworks)、および [`forceLoginMethod`](https://code.claude.com/docs/ja/settings-reference#forceloginmethod) の `"gateway"` 値をマシン上のマネージドソースから認識します。`managed-settings.json`、macOS plist または Windows HKLM レジストリ、またはポリシーヘルパーです。ゲートウェイペイロードでこれらを設定しても、ゲートウェイのサインインは設定されません。開発者自身の `~/.claude/settings.json` については、[ユーザー設定でゲートウェイ URL を設定する](https://code.claude.com/docs/ja/claude-apps-gateway#set-the-gateway-url-in-user-settings)を参照してください。

`forceLoginMethod` と `forceLoginOrgUUID` をペイロードから除外してください。Claude Code はスタートアップ認証情報チェックのためにペイロードから両方のキーを読み込みます。そのため、Anthropic が発行した認証情報をマシンに保持している開発者は、サインイン後でも[管理者ポリシーがクラウドゲートウェイサインインを必要とする](https://code.claude.com/docs/ja/errors.md#administrator-policy-requires-a-cloud-gateway-sign-in)の下で説明されているスタートアップ終了を取得します。

## 関連

* [Claude apps gateway 概要](https://code.claude.com/docs/ja/claude-apps-gateway)：クイックスタートと開発者接続
* [デプロイメントガイド](https://code.claude.com/docs/ja/claude-apps-gateway-deploy.md)：IdP セットアップ、コンテナイメージ、Kubernetes と Cloud Run、運用
* [支出制限](https://code.claude.com/docs/ja/claude-apps-gateway-spend-limits.md)：開発者ごとのキャップと Admin API
