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
| `client_id` / `client_secret` | はい | OAuth クライアント登録から取得 |
| `allowed_email_domains` | いいえ | `email` クレームがこれらのドメインのいずれかに含まれていない id\_token を拒否します。大文字と小文字を区別しません。マルチテナント IdP の設定ミスに対する多層防御です。この設定とは無関係に、`email_verified` クレームが明示的に `false` である id\_token は常に拒否されます。 |
| `allowed_groups` | いいえ | サインインをこれらの IdP グループのメンバーに制限します。`groups_claim` に対してマッチングされます。許可されたメールドメイン内にいるが、これらのグループのいずれにも属していないユーザーは拒否されます。IdP がグループクレームを発行する必要があります。マッチングは、そのクレーム内の値に対する正確で大文字と小文字を区別する文字列比較です。ゲートウェイはネストされたグループを展開しません。サブグループのメンバーを許可するには、ここにサブグループをリストするか、IdP を設定してフラット化されたメンバーシップを発行してください。 |
| `groups_claim` | いいえ | グループメンバーシップを含む id\_token クレーム。デフォルト `groups`。Microsoft Entra はアプリロールを `roles` の下に発行します。フラットキーまたは `/resource_access/gateway/roles` などのネストされたクレーム用の RFC 6901 JSON ポインタを受け入れます。 |
| `google_groups` | いいえ | Google Workspace Admin SDK Directory API を通じてサインインしたユーザーのグループを検索します。Google の id\_token はグループクレームを含まないためです。`service_account_json_path` を `https://www.googleapis.com/auth/admin.directory.group.readonly` スコープでドメイン全体の委任を持つサービスアカウントキーファイルに設定し、`admin_email` を Workspace 管理者に設定します。サービスアカウントが偽装します。Directory API は実際の管理者サブジェクトが必要です。各ユーザーのグループメールアドレスがそのグループクレームになるため、`allowed_groups` と `managed.policies.match.groups` はグループメールでマッチングします。 |
| `email_claim` | いいえ | ユーザーのメールを含む id\_token クレーム。デフォルト `email`。ADFS や Entra B2C などの一部の IdP は、代わりに `upn` または `preferred_username` を発行します。フラットキー、JSON ポインタ、または最初に存在するキーが使用されるフォールバックキーのリストを受け入れます。 |
| `scopes` | いいえ | ゲートウェイが要求する OIDC スコープの完全なオーバーライド。デフォルト `[openid, profile, email, offline_access]`。IdP が認識しないスコープを拒否する場合、またはグループまたはメールを発行するためにカスタムスコープが必要な場合に設定します。`openid` を含める必要があります。`offline_access` を削除するとリフレッシュトークンが無効になるため、開発者は `session.ttl_hours` ごとにブラウザログインを再実行します。IdP ごとのスコープレシピ（Google のリフレッシュトークンフローなど）については、[アイデンティティプロバイダーのセットアップ](/docs/ja/claude-apps-gateway-deploy#identity-provider-setup)を参照してください。 |
| `scope_on_refresh` | いいえ | リフレッシュトークンを交換するときに、サインインリクエストと同じリストで `scope` も送信します。デフォルト `false`：リフレッシュリクエストは `scope` を省略します。ほとんどの IdP はすべてのリフレッシュで id\_token を返し、これを必要としません。IdP がリフレッシュ時に id\_token を返す場合にのみ `true` に設定します。`openid` を再度要求された場合。Okta はそのリフレッシュグラントについてこれを文書化しています。id\_token がない場合、すべてのリフレッシュは IdP の userinfo エンドポイントが更新されたアクセストークンを受け入れることに依存します。サインインをゲートしたり、グループのポリシーをマッチングしたりする場合、IdP のリフレッシュ時 id\_token がそれらを省略する場合は、`userinfo_fallback: true` も設定して、ゲートウェイが userinfo エンドポイントからそれらを入力するようにしてください。要求されたスコープより少ないスコープを付与した IdP は、これがオンの場合、既存のセッションの場合でも `invalid_scope` でリフレッシュを拒否できます。`token_endpoint` でリフレッシュが失敗し始めた場合は、キーを設定した後、キーを設定解除してください。ゲートウェイサーバーで Claude Code v2.1.260 以降が必要です。 |
| `extra_auth_params` | いいえ | IdP 認可リクエストに逐語的に追加される追加クエリパラメータ。これは、Google リフレッシュトークンの `access_type: offline`、一部の Entra テナントの `domain_hint`、またはステップアップフローの `acr_values` など、IdP 固有の動作のオーバーライドメカニズムです。ゲートウェイが管理するプロトコルパラメータはオーバーライドできません：`state`、`nonce`、`redirect_uri`、PKCE、`scope`、`response_type`、`response_mode`、および `client_id`。 |
| `userinfo_fallback` | いいえ | id\_token がメールまたはグループを省略する場合、`/userinfo` からそれらを取得します。Keycloak 軽量アクセストークン、Okta org サーバー、および ADFS 最小トークンに必要です。id\_token は権限のままです。userinfo はギャップのみを埋めます。デフォルト `false`。 |
| `use_pkce` | いいえ | 認可リクエストで PKCE（S256）チャレンジを送信します。デフォルト `true`。IdP がこの機密クライアントの PKCE を拒否する場合のみ `false` に設定します。 |
| `clock_skew_seconds` | いいえ | id\_token 時間クレームを検証するときにクロックドリフトを許容します。デフォルト `0`（厳密）。サインイン直後にホスト/IdP クロックスキューのため「トークン期限切れ/まだ有効でない」エラーが表示される場合は、これを上げてください。 |
| `token_endpoint_auth_method` | いいえ | トークンエンドポイント認証方法をオーバーライドします。`client_secret_basic` または `client_secret_post` を受け入れます。デフォルトで自動ネゴシエーション。 |
| `id_token_signed_response_alg` | いいえ | 予想される id\_token 署名アルゴリズム。デフォルト `RS256`。ES256、PS256、または EdDSA で署名する IdP に設定します。 |
| `additional_authorized_parties` | いいえ | `client_id` を超えて受け入れる追加の `azp` 値。Keycloak ブローカーとトークン交換フロー用 |
| `discovery_url` | いいえ | `issuer` から導出する代わりに、この URL から検出ドキュメントを取得します。発行者ホストを書き換えるプロキシの背後にある IdP の場合。パスは `/.well-known/` を含む必要があります。 |
| `use_proxy` | いいえ | ゲートウェイ独自の IdP リクエストを `HTTPS_PROXY` または `HTTP_PROXY` のフォワードプロキシを通じて送信し、`NO_PROXY` を尊重します。`false` はそれらのリクエストを直接に保ちます。v2.1.227 以降が必要です。以下の[フォワードプロキシを通じた IdP リクエスト](#idp-requests-through-a-forward-proxy)を参照してください。 |
| `form_action_origins` | いいえ | `/device` ページの `Content-Security-Policy: form-action` ディレクティブの追加オリジン。ゲートウェイはすでに `'self'` と検出された `authorization_endpoint` オリジンを許可していますが、Chrome は全リダイレクトチェーンに対して `form-action` を強制します。IdP が Azure AD が ADFS にフェデレーションされている、ハブスポーク Okta、または企業 SSO インターセプターなど、2 番目のホストを通じてリダイレクトする場合、認可リクエストがリダイレクトする可能性があるすべてのオリジンをリストします。 |
| `ca_cert_pem` | いいえ | ファイルへのパスではなく、PEM エンコードされた CA 証明書自体。IdP リクエストのみのシステムトラストストアを置き換えます。マウントされたファイルを読み込むには、`${file:/etc/gateway/idp-ca.pem}` と書きます。企業 PKI の背後にある Keycloak または Dex に使用します。 |

<h4 id="idp-requests-through-a-forward-proxy">
  フォワードプロキシを通じた IdP リクエスト
</h4>

推論アップストリームはすべてのバージョンで `HTTPS_PROXY` と `HTTP_PROXY` を尊重します。ゲートウェイ独自の IdP、検出、JWKS、トークン、および userinfo へのリクエストは、`oidc.use_proxy: true` を設定しない限り直接です。v2.1.227 以降が必要です。プロキシ変数が設定され、`use_proxy` が設定解除され、発行者が `NO_PROXY` でカバーされていない場合、ゲートウェイはそれらのリクエストを直接に保ち、ブート時に選択するよう求める通知をログに記録します。`use_proxy: false` はそれらを直接に保ち、通知をサイレンスします。

`use_proxy: true` の場合、ポッドは各 IdP エンドポイントのホスト名を自身で解決し、プロキシに解決された IP アドレスへの `CONNECT` を要求します。プロキシは、発行者だけでなく、検出ドキュメントが名前を付けるすべてのホストの IP アドレスへの `CONNECT` を受け入れる必要があります。`http://` プロキシ URL を使用します。`ca_cert_pem` と[SSRF ガード](/docs/ja/claude-apps-gateway-deploy#threat-model-summary)はプロキシされたパスにも適用されます。

[プロキシのみのエグレス](#proxy-only-egress)はこれらの両方を変更します。アクティブな場合、IdP リクエストは `use_proxy: false` を設定しない限りプロキシに従い、ゲートウェイは最初にそれを解決せずにプロキシに各 IdP ホスト名を渡します。

<h4 id="proxy-only-egress">
  プロキシのみのエグレス
</h4>

ゲートウェイの環境で `HTTPS_PROXY` の隣に `CLAUDE_GATEWAY_PROXY_IS_EGRESS_BOUNDARY=1` を設定します。ポッドがそのフォワードプロキシを通じてのみ他のホストに到達でき、パブリック DNS 名を自身で解決できない場合、またはプロキシが IP アドレスへの `CONNECT` を拒否する場合。v2.1.277 以降が必要です。これは `gateway.yaml` キーではなく環境変数です。設定ファイルの何もゲートウェイのアドレスチェックを緩和できないようにするためです。

```bash theme={null}
export HTTPS_PROXY=http://proxy.corp.example.com:3128
export NO_PROXY=
export no_proxy=
export CLAUDE_GATEWAY_PROXY_IS_EGRESS_BOUNDARY=1
```

ゲートウェイはプロキシのみのエグレスがアクティブな場合、ブート時に 1 つの `network:` 行をログに記録します。

以下の各行は、`HTTPS_PROXY` が設定されたゲートウェイ上の 1 つのクラスのアウトバウンドリクエストです。デフォルトおよびプロキシのみのエグレスがアクティブな場合。

| アウトバウンドリクエスト | デフォルト | プロキシのみのエグレスアクティブ |
| - | - | - |
| `provider: anthropic` アップストリーム、Workload Identity Federation トークン交換、`telemetry.forward_to` エクスポート | ローカルで解決およびチェックされ、その後、プロキシを通じてチェックされた IP アドレスへの `CONNECT`。`NO_PROXY` にリストされたテレメトリコレクターは代わりに直接到達します | プロキシに渡されたホスト名 |
| IdP 検出、JWKS、トークン、および userinfo | [`oidc.use_proxy: true`](#idp-requests-through-a-forward-proxy) でない限り直接。その後、チェックされた IP アドレスへの `CONNECT` | ホスト名がプロキシに渡されます。ただし、`oidc.use_proxy: false` は内部 IdP を直接に保ちます |
| Amazon Bedrock、Claude Platform on AWS、Google Cloud の Agent Platform、および Microsoft Foundry アップストリーム。Google グループ検索 | ホスト名がプロキシに渡されます | 変更なし |

プロキシのみのエグレスは、ゲートウェイの環境がこれら 3 つの条件をすべて満たさない限り、オフのままです：

* `HTTPS_PROXY` または `HTTP_PROXY` が設定されています。
* `NO_PROXY` と `no_proxy` は空です。プラットフォームがいずれかをポッドに注入する場合、ゲートウェイコンテナの両方を空の値に設定します。`NO_PROXY` にテレメトリコレクターをリストすると、プロキシのみのエグレスがオフのままです。
* `CLAUDE_GATEWAY_ALLOW_LOOPBACK` がオンになっていません。ポッド独自のループバック上のコレクターまたは IdP は、プロキシのみのエグレスと組み合わせることはできません。ループバックアドレスがプロキシに渡されるとプロキシホスト独自のものになるため、代わりにプロキシが到達できるアドレスをそれらのサービスに与えてください。同じ理由で、ゲートウェイはプロキシのみのエグレスがアクティブな場合、`localhost` スタイルの名前を完全に拒否します。

これらの条件のいずれかが満たされていない場合、ゲートウェイはブート時に警告をログに記録し、それを停止した変数に名前を付け、デフォルトの動作を保ちます。

プロキシのみのエグレスがアクティブになったら、内部コレクターと IP アドレスで設定されたホストを含む、プロキシ内のすべての宛先を許可します。[`oidc.use_proxy: false`](#idp-requests-through-a-forward-proxy) で内部 IdP を直接に保つことができます。

<Warning>
  これをオンにするのは、プロキシのアローリストがゲートウェイ独自のチェック以上に厳密な場合のみです。プロキシは `169.254.169.254` や `metadata.google.internal` などのクラウドメタデータエンドポイント、リンクローカルアドレス、およびプロキシホスト独自のループバックを拒否する必要があります。また、名前だけでなく、名前が解決するアドレスによってそれらを拒否する必要があります。ゲートウェイはもはやそれらのいずれかに解決するホスト名をキャッチしないためです。どこでも接続するプロキシは、これらのリクエストのゲートウェイの[SSRF ガード](/docs/ja/claude-apps-gateway-deploy#threat-model-summary)を削除します。
</Warning>

<h3 id="session">
  `session`
</h3>

`session` ブロックは、ゲートウェイがサインイン後に鋳造するベアラートークンを形成します。それらに署名するシークレットと、どのくらい長く生きるかです。

| フィールド | 必須 | 説明 |
| - | - | - |
| `jwt_secret` | はい | 少なくとも 32 バイトのエントロピー。例えば `openssl rand -base64 32` から。ゲートウェイの HS256 ベアラートークンに署名します。単一の文字列または回転用の配列を受け入れます。インデックス 0 が署名し、すべてのエントリが検証します。回転するには、新しいシークレットを先頭に追加し、`ttl_hours` を待ってから古いものを削除します。 |
| `ttl_hours` | いいえ | ゲートウェイベアラートークンの有効期間。デフォルト `1`。IdP がリフレッシュトークンを発行する場合、CLI は有効期限前に自動的にリフレッシュします。有効期間が短いほど、より速くプロビジョニング解除されます。長いほど、IdP ラウンドトリップが少なくなります。IdP が `offline_access` が利用できないためリフレッシュトークンを発行できない場合、サイレントリフレッシュはないため、これを `8` または `12` に上げて、開発者を 1 時間ごとにブラウザログインに戻すのを避けてください。 |

<h3 id="store">
  `store`
</h3>

`store` ブロックはゲートウェイを PostgreSQL データベースに指します。デバイスグラントとレート制限カウンターを保持します。

| フィールド | 必須 | 説明 |
| - | - | - |
| `postgres_url` | はい | `postgres://` または `postgresql://` URL。必須：デバイスグラント集合。ブラウザコールバックが書き込み、ポーリング CLI が読み込む場所。レプリカ間の状態が必要です。ゲートウェイはブート時およびアップグレード時に独自のスキーママイグレーションを実行するため、ロールはターゲットスキーマでテーブルを作成および変更する権限が必要です。[アップグレード](/docs/ja/claude-apps-gateway-deploy#upgrades)および [Postgres](/docs/ja/claude-apps-gateway-deploy#postgres) を参照してください。 |
| `username` | いいえ | `postgres_url` のユーザーをオーバーライドします |
| `password` | いいえ | データベース認証情報。`postgres_url` ではなくここに設定して、認証情報を URL から外します。任意の文字を受け入れ、URL 認証情報よりも優先されます。 |
| `max_connections` | いいえ | レプリカあたりの Postgres 接続プール サイズ。デフォルト `5`。保守的で共有データベースに優しいです。[支出制限](#admin)が有効な場合、ホットパスは推論リクエストごとに数回の操作を実行するため、専用データベースが負荷の下にある場合はこれを上げ、レプリカ × これをデータベースの `max_connections` 以下に保ちます。 |
| `connect_timeout_seconds` | いいえ | ゲートウェイが Postgres 接続を開くときに待機する秒数。`1` から `60` の整数。デフォルト `5`。新しいゲートウェイインスタンスが起動するときに接続試行がタイムアウトする場合は、これを上げてください。ゲートウェイサーバーで Claude Code v2.1.274 以降が必要です。以前のバージョンはキーが設定されている場合、起動を拒否します。 |
| `readiness_grace_seconds` | いいえ | Postgres が応答を停止した後、`/readyz` が準備完了を報告し続ける秒数。`0` から `3600` の整数。デフォルト `0`。値を選択する方法については、[停止動作](/docs/ja/claude-apps-gateway-deploy#outage-behavior)を参照してください。ゲートウェイサーバーで Claude Code v2.1.282 以降が必要です。以前のバージョンはキーが設定されている場合、起動を拒否します。 |

ローカル開発の場合、`postgres_url` を使い捨て Postgres コンテナに指します。例えば `docker run --rm -p 5432:5432 -e POSTGRES_HOST_AUTH_METHOD=trust postgres`。

<h3 id="upstreams">
  `upstreams`
</h3>

`upstreams` は順序付きリストです。ゲートウェイは、要求されたモデルを解決する最初のアップストリームに推論を転送します。

`5xx`、`429`、`401`、`403`、`404`、またはタイムアウト時に、ゲートウェイは次のアップストリームにフェイルオーバーします。他の `4xx` はそうしません。これらのエラーはリクエストではなくアップストリームに起因するためです。`401` または `403` は、ゲートウェイがそのアップストリームに対して使用した認証情報が失敗したことを意味します。`404` はそのアップストリームが要求されたモデルを提供しないことを意味するため、リスト内の後のアップストリームはまだできます。

アップストリームで `forward_user_identity: true` を設定する場合、開発者のメールを含むリクエストに返す `429` はフェイルオーバーしません。[開発者がどのように per-user 制限拒否に到達するか](#per-user-identity-headers-for-a-proxy-you-run)を参照してください。

`404` でのフェイルオーバーにはゲートウェイ v2.1.198 以降が必要です。以前のリリースは、リスト内の後のアップストリームがモデルを提供している場合でも、最初の `404` をクライアントに返しました。

同じプロバイダーの複数のアップストリームは、異なる `name:` を設定する必要があります。

Amazon Bedrock、Claude Platform on AWS、Google Cloud の Agent Platform、および Microsoft Foundry クライアントはスタートアップ時に 1 回構築され、SDK は内部的に認証情報をリフレッシュするため、クラウド認証情報のローテーションは再起動を必要としません。静的 Anthropic API キーとベアラーはスタートアップ時に読み込まれます。[Anthropic API](#anthropic-api) を参照してください。

<h4 id="upstream-error-messages">
  アップストリームエラーメッセージ
</h4>

ゲートウェイは、アップストリームがどのように応答したかに応じて、1 つのアップストリームのエラー応答またはそれ独自の `502` を返します：

* **ゲートウェイが[フェイルオーバー](#multiple-upstreams)しないステータスをアップストリームが返した**：そのアップストリームの応答。ゲートウェイはさらなるアップストリームを試みません。
* **ゲートウェイが試みたすべてのアップストリームが[フェイルオーバー](#multiple-upstreams)する方法で失敗した**：最後の `429`。いずれも `429` を返さなかった場合、ゲートウェイは順に、最後の `401` または `403`、最後の `404`、最後の `501` を優先します。いずれも返さなかった場合、ゲートウェイ独自の `502`。`all upstreams failed (N attempted)`。N は [`upstreams`](#upstreams) のすべてのエントリをカウントします。要求されたモデルを提供しないためゲートウェイがスキップしたエントリを含みます。

ゲートウェイがアップストリームの応答を返す場合、アップストリームのステータスコードを保ちます。アップストリームのメッセージを保つかどうかはプロバイダーに依存します。Anthropic API アップストリームのエラー本体は開発者に変更されずに到達します。

Amazon Bedrock、Claude Platform on AWS、Google Cloud の Agent Platform、および Microsoft Foundry アップストリームは、エラーテキストでアカウント ID、ロール ARN、およびプロジェクト ID に名前を付けることができます。ゲートウェイはその完全なテキストを[運用ログ](/docs/ja/claude-apps-gateway-deploy#logs)に記録します。開発者がこれらのアップストリームから見るものは、拒否に依存します：

* Anthropic の標準エラーエンベロープの `400` または `413`：`prompt is too long` などのアップストリーム独自のメッセージ。Claude Platform on AWS、Agent Platform、および Microsoft Foundry はモデル API 拒否のためこのエンベロープを返します。
* プロバイダー独自の形状の `400` または `413`：`capability_rejected:` トークン。ゲートウェイが拒否を分類できない場合、`400` で `upstream rejected the request` または `413` で `request too large for this upstream`。
* その他のステータス：`429` で `upstream rate limit exceeded` などのステータスごとの汎用コピー。

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

`provider: anthropic` アップストリームの `base_url` を Anthropic API ではなく実行するプロキシに指すことができます。そのプロキシに各リクエストを送信した開発者を伝えるには、そのアップストリームで `forward_user_identity: true` を設定します。プロキシはその後、開発者ごとに支出を属性付けることができます。Claude Code v2.1.233 以降を実行しているゲートウェイが必要です。

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

プロキシが開発者のメールを含むリクエストに `429` で応答する場合、ゲートウェイはその応答を開発者にそのまま返し、次のアップストリームにフェイルオーバーしません。プロキシの per-user 予算またはレート制限が保持されます。プロキシの他の応答は通常の[フェイルオーバールール](#upstreams)に従います。開発者の IdP トークンがメールを含まない場合、ゲートウェイはメールヘッダーなしでリクエストを転送するため、そのようなリクエストへの `429` はアップストリーム容量としてカウントされ、フェイルオーバーします。ゲートウェイサーバーの v2.1.267 より前では、すべての `429` がフェイルオーバーしました。

`forward_user_identity` は、`base_url` が実行するプロキシであるアップストリームにのみ設定します。ゲートウェイは開発者メールを、その `base_url` が名前を付けるサーバーに送信します。`base_url` が Anthropic API（デフォルト）の場合、ゲートウェイは起動を拒否します。

<h4 id="amazon-bedrock">
  Amazon Bedrock
</h4>

クライアント側の Amazon Bedrock デプロイメント（ゲートウェイが置き換えるか前に置く）については、[Claude Code on Amazon Bedrock](/docs/ja/amazon-bedrock) を参照してください。ゲートウェイ側のアップストリーム：

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

明示的な認証情報は完全である必要があります。`aws_access_key_id` と `aws_secret_access_key` が一緒に設定されていない場合、または `aws_session_token` が設定されていない場合、ゲートウェイはブート時に失敗します。v2.1.207 より前では、部分的な `auth:` ブロックが検証に合格しました。

| セットアップ | 方法 |
| - | - |
| IAM 権限 | ゲートウェイのプリンシパルに `bedrock:InvokeModel` と `bedrock:InvokeModelWithResponseStream` を推論プロファイル ARN と基礎モデル ARN の両方に付与します。US リージョンの組み込みカタログの場合：`arn:aws:bedrock:<region>:<account>:inference-profile/us.anthropic.*` と `arn:aws:bedrock:*::foundation-model/anthropic.*`。また、基礎モデル ARN に `bedrock:CountTokens` を付与します。ゲートウェイはそれを使用して、クライアントが放棄したリクエストの入力トークンをカウントします。無料です。[支出制限](#admin)が正確に保たれるようにするためです。これなしでは、ゲートウェイはそのカウントのための 1 トークン Bedrock リクエストにフォールバックします。 |
| モデルアクセス | Amazon Bedrock はデフォルトで商用リージョンでモデルアクセスを有効にします。残りのアカウントレベルゲートは Anthropic のワンタイムユースケースフォームです。AWS アカウント内の誰もそれを送信していない場合、Amazon Bedrock コンソールを開き、モデルカタログから Anthropic モデルを選択し、フォームを完成させます。AWS Organizations フォームと送信者が必要な権限については、[ユースケース詳細を送信](/docs/ja/amazon-bedrock#1-submit-use-case-details)を参照してください。 |
| EKS（IRSA） | クラスターの OIDC プロバイダーにスコープされたゲートウェイのサービスアカウントの信頼ポリシーを持つ IAM ロールを作成します。サービスアカウントに `eks.amazonaws.com/role-arn: arn:aws:iam::<acct>:role/claude-gateway` で注釈を付けます。`auth: {}` がそれを取得します。 |
| ECS / EC2 | IAM ロールをタスク定義またはインスタンスプロファイルにアタッチします。`auth: {}` がそれを取得します。 |
| その他の場所 | `AWS_ACCESS_KEY_ID`、`AWS_SECRET_ACCESS_KEY`、および `AWS_SESSION_TOKEN` 環境変数を通じて認証情報を渡すか、`${VAR}` 展開で `auth:` に明示的に設定します |
| リージョン | `region:` は API エンドポイントリージョンです。クロスリージョン推論プロファイルは、どれを選択するかに関わらず、地理（US、EU、APAC）全体でルーティングします。US 以外のリージョンまたはプロビジョニングされたスループット ARN の場合、正しい per-upstream ID を持つ [`models:`](#models) ブロックを追加します。 |

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
  ゲートウェイはガードレール入力タグをサポートしていません。プロンプトにガード コンテンツタグを追加しないため、Amazon Bedrock がタグ付き入力にのみ適用するガードレールフィルターはゲートウェイを通じたトラフィックで実行されません。入力タグに依存するフィルターについては、Amazon Bedrock ドキュメントの[入力タグ](https://docs.aws.amazon.com/bedrock/latest/userguide/guardrails-tagging.html)を参照してください。
</Warning>

また、このアップストリームのリクエストに署名するプリンシパル（ゲートウェイの AWS プリンシパル、または [`assume_role`](#bedrock-in-another-aws-account) で `role_arn` に名前を付けたロール）にガードレールで `bedrock:ApplyGuardrail` を付与します。

すべての `bedrock` アップストリームで `guardrail` を設定するか、どれにも設定しないでください。ゲートウェイは混合で起動を拒否します。[フェイルオーバー](#multiple-upstreams)がリクエストをガードレールのない Bedrock アップストリームに送信する可能性があるためです。

ガードレールは Bedrock アップストリームのみをカバーします。`upstreams` に別のプロバイダーをリストする場合、ゲートウェイはガードレールなしでそのプロバイダーにリクエストを送信します。

`/v1/messages` リクエストの本体が `amazon-bedrock-guardrailConfig` などの `amazon-bedrock-*` フィールドを含む場合、ガードレール セットを持つ Bedrock アップストリームに到達すると、ゲートウェイは 400 で応答し、転送しません。

<a id="bedrock-in-another-aws-account" />

<h5 id="bedrock-in-another-aws-account">
  別の AWS アカウントの Bedrock
</h5>

Bedrock アップストリームで `assume_role` を設定し、ゲートウェイは独自の AWS アイデンティティを使用して、名前を付けたロールで `sts:AssumeRole` を呼び出すだけです。別の AWS アカウントにある可能性があります。そのアップストリームからのすべての Bedrock リクエストは、STS が返す 1 時間の認証情報で署名されるため、長期アクセスキーはアカウント間を通過しません。

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
| `role_arn` | ゲートウェイが想定する IAM ロール。`arn:aws:iam::` または `arn:aws-us-gov:iam::` ARN として。このアップストリームが必要とする [Bedrock 権限](#amazon-bedrock)、`bedrock:CountTokens` を含む、およびアップストリームが `guardrail` を設定する場合は `bedrock:ApplyGuardrail` を与えます。 |
| `external_id` | オプション。すべての `sts:AssumeRole` 呼び出しで外部 ID として送信されます。ロールの信頼ポリシーが 1 つを必要とする場合に設定し、すべての数字の場合は引用符で囲みます。 |
| `session_name` | オプション。`email` または `sub` は各開発者に独自のセッションを与えます。[Per-developer AWS コスト属性](#per-developer-aws-cost-attribution)を参照してください。設定解除されている場合、すべてのリクエストは `claude-apps-gateway` という名前の 1 つのセッションを使用します。 |

ロールの信頼ポリシーはゲートウェイ独自のプリンシパル（IRSA または ECS タスクロールなど）に名前を付けます。そのプリンシパルはロールで `sts:AssumeRole` が必要で、Bedrock 権限はありません。`external_id` を設定しない場合は `Condition` を削除します。

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

* STS が拒否または到達不可の場合、ゲートウェイはアップストリーム独自の認証情報でリクエストを送信しません。STS エラーをログに記録し、何をチェックするかを記録してから、リストした次のアップストリームを試みます。[アップストリームエラーメッセージ](#upstream-error-messages)は、アップストリームが成功しない場合にクライアントが受け取るものをカバーしています。`assume_role` のない後のアップストリームはそれ独自の認証情報でリクエストを提供するため、それが望むものの場合のみリストします。
* ゲートウェイは地域 STS エンドポイント `sts.<region>.amazonaws.com` を呼び出します。ネットワークはそれに到達する必要があります。FIPS エンドポイントの場合、AWS 設定ファイルの `use_fips_endpoint` ではなく、ゲートウェイの環境で `AWS_USE_FIPS_ENDPOINT=true` を設定します。
* `assume_role` は `provider: bedrock` にのみ適用され、SigV4 ソース認証情報が必要です。ゲートウェイは `aws_bearer_token` の隣に設定されている場合、起動を拒否します。
* ゲートウェイが許可するすべての開発者はこのアップストリームを使用できます。[`managed`](#managed) はどの開発者がどのモデルを使用できるかを制御します。ロールを通じて提供されるモデルが別のアカウントからも提供されるのを防ぐには、`upstream_model` マップがこのアップストリームの名前のみを持つカスタム id を与えます。そのような id の場合、ゲートウェイはすべての他のアップストリームをスキップするため、リクエストもそれに到達する放棄されたリクエストのトークンカウントも別のアカウントにフェイルオーバーできません。組み込みモデル名はまだすべてのアップストリームで順に試みられます。これを含みます。そのアカウントもそれらを提供する場合を除き、このアップストリームを最後にリストします。

この例は、分離されたアップストリームのみが提供するカスタム id を持つ 1 つのモデルを与えます：

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

デフォルトでは、ゲートウェイはすべての Bedrock リクエストに 1 つの認証情報で署名するため、AWS はすべての開発者のリクエストを単一の IAM プリンシパルの下で見ます。[`assume_role`](#bedrock-in-another-aws-account) に `session_name: email` を追加し、ゲートウェイは開発者ごとに 1 時間ごとに `sts:AssumeRole` を呼び出し、セッション名をその開発者のメールに設定し、返された認証情報でリクエストに署名するため、各開発者のリクエストは独自の想定ロールセッションの下で AWS に到達します。ロールはゲートウェイ独自のアカウントにある可能性があります。

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

`session_name` は、検証されたクレームが AWS `RoleSessionName` になるかを選択します：`email` または `sub`。ゲートウェイは ASCII 文字、数字、および `_+,.@-` 以外の任意の文字を UTF-8 バイトごとに `=XX` 16 進数として書き込み、64 文字より長い結果をプレフィックスとハッシュに短縮するため、各開発者のセッション名は有効で一意のままです。トークンがクレームを欠いている開発者からのリクエストはこのアップストリームを通じて送信されず、オペレーター ログは `sub` に切り替えるか [`oidc.email_claim`](#oidc) を設定するよう指示します。

アクティブな開発者は、ゲートウェイレプリカあたり 1 時間あたり 1 つの STS 呼び出しをコストします。同時最初リクエストは 1 つの呼び出しを共有します。

ゲートウェイはこのロールで 1 つの呼び出しも行います。クライアントが放棄したリクエストのトークンカウント。[支出制限](/docs/ja/claude-apps-gateway-spend-limits)が正確に保たれるようにするためです。そのカウントと[1 トークンフォールバックリクエスト](#amazon-bedrock)は共有 `claude-apps-gateway` セッションで署名されるため、AWS はフォールバックを `claude-apps-gateway` ではなく開発者に属性付けします。

厳密な per-developer 属性の場合、すべての Bedrock アップストリームで `assume_role` を `session_name` で設定します。それなしのアップストリームは独自の認証情報でリクエストに署名します。

<h4 id="claude-platform-on-aws">
  Claude Platform on AWS
</h4>

Claude Platform on AWS は、`aws-external-anthropic.<region>.api.aws` で AWS インフラストラクチャ上の第一者 Anthropic API を提供します。第一者モデル ID を使用し、`anthropic-beta` ヘッダーを送信されたとおりに尊重し、`count_tokens` を提供するため、Bedrock 固有の翻訳は適用されません。`anthropicAws` プロバイダーには Claude Code v2.1.198 以降が必要です。以前のゲートウェイリリースはブート時にそれを拒否します。

同じプラットフォームのクライアント側デプロイメントについては、[Claude Code on Claude Platform on AWS](/docs/ja/claude-platform-on-aws) を参照してください。ゲートウェイ側のアップストリーム：

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

プラットフォームはゲートウェイの環境で Amazon Bedrock とは別の AWS アカウントで実行され、独自のサービス名 `aws-external-anthropic` の SigV4 リクエストに署名するため、Bedrock スコープの IAM ロールはそれを認可しません。`auth.api_key` の API キーは SigV4 認証情報も設定されている場合に優先されます。空の `auth` ブロックは AWS SDK のデフォルト認証情報チェーンを使用します。[Amazon Bedrock](#amazon-bedrock) アップストリームが使用するのと同じチェーン。

| フィールド | 必須 | 説明 |
| - | - | - |
| `region` | はい | AWS リージョン。小文字、数字、およびハイフン。ゲートウェイはそれからエンドポイントを `https://aws-external-anthropic.<region>.api.aws` として導出します。 |
| `workspace_id` | はい | すべてのリクエストでヘッダーとして送信されます。プラットフォームはそれを必要とします |
| `auth.api_key` | いいえ | プラットフォームの API キー。`x-api-key` として送信されます。ベアラートークンではありません。2 つの認証モードは API キーまたは SigV4 です。 |
| `auth.aws_access_key_id` / `auth.aws_secret_access_key` | いいえ | 明示的な SigV4 認証情報。一方を他方なしで設定するとブート時に失敗します。`auth.aws_session_token` はそれらと一緒に受け入れられます。 |
| `base_url` | いいえ | 導出されたエンドポイントをオーバーライド |

プラットフォームは第一者モデル ID を解決するため、組み込みカタログは [`models:`](#models) ブロックなしでそれにルーティングします。`models:` リストをキュレートする場合、エントリを `anthropicAws:` で第一者 ID でキーします。

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

Google Cloud の Agent Platform の[グローバルエンドポイント](https://cloud.google.com/vertex-ai/generative-ai/docs/learn/locations)を使用するには `region: global` を設定します。Google はその後、各リクエストを利用可能なリージョンにルーティングするため、per-region モデル可用性を追跡しません。特定のリージョンを設定するとすべてのリクエストをそれにピンします。

| セットアップ | 方法 |
| - | - |
| IAM 権限 | ゲートウェイのサービスアカウントにプロジェクトで `roles/aiplatform.user` を付与するか、`aiplatform.endpoints.predict` を持つカスタムロール。Google Cloud の Agent Platform API（`aiplatform.googleapis.com`）を有効にします。 |
| モデルアクセス | Model Garden で、プロジェクトの Claude モデルを有効にします。特定のリージョンに公開されます。サポートされているリージョンについてはモデルカードを確認してください。 |
| GKE（Workload Identity） | GCP サービスアカウントをゲートウェイの Kubernetes サービスアカウントにバインドし、KSA に `iam.gke.io/gcp-service-account: claude-gateway@<proj>.iam.gserviceaccount.com` で注釈を付けます。`auth: {}` がそれを取得します。 |
| Cloud Run / GCE | サービスのサービスアカウントを `roles/aiplatform.user` を持つものに設定します。`auth: {}` がそれを取得します。 |
| その他の場所 | `auth: { service_account_json: /secrets/sa.json }`。マウントされたシークレットとしての JSON キーファイルへのパス。フィールドはキーコンテンツではなくファイルパスを取るため、`${file:…}` 展開は関係ありません。 |

<h4 id="microsoft-foundry">
  Microsoft Foundry
</h4>

クライアント側の Microsoft Foundry デプロイメントについては、[Claude Code on Microsoft Foundry](/docs/ja/microsoft-foundry) を参照してください。ゲートウェイ側のアップストリーム：

```yaml theme={null}
upstreams:
  - provider: foundry
    resource: example-foundry              # https://example-foundry.services.ai.azure.com
    auth: { use_azure_ad: true }        # preferred: DefaultAzureCredential / Managed Identity
    # OR an API key:
    # auth:
    #   api_key: ${FOUNDRY_API_KEY}
```

`use_azure_ad: true` は `DefaultAzureCredential` を通じて解決します：AKS、ACI、または App Service 上の Managed Identity。Azure CLI。または環境認証情報。API キーは機能しますが、プロジェクト全体であり、自動的にローテーションしません。Microsoft Foundry のエンドポイントは `resource:` から導出されます。Azure Government などのソブリンクラウドの場合、オプションの `base_url` を設定してオーバーライドします。

| セットアップ | 方法 |
| - | - |
| RBAC | ゲートウェイのアイデンティティに Microsoft Foundry リソースで `Azure AI User` または `Cognitive Services User` を付与 |
| デプロイメント | Microsoft Foundry は正規モデル ID ではなく、管理者が選択したデプロイメント名を使用します。各正規 ID をデプロイメント名にマップする [`models:`](#models) ブロックを追加します。 |
| AKS（ワークロードアイデンティティ） | User-Assigned Managed Identity をクラスターの OIDC 発行者とフェデレーションし、ゲートウェイのサービスアカウントにバインドします。`use_azure_ad: true` は `WorkloadIdentityCredential` を通じてそれを取得します。 |
| ACI / App Service | リソースでシステム割り当てまたはユーザー割り当てマネージドアイデンティティを有効にします。`use_azure_ad: true` がそれを取得します。 |
| その他の場所 | `auth: { api_key: "${FOUNDRY_API_KEY}" }`。`{ }` 内の `${…}` を引用符で囲みます。 |

<h4 id="static-headers-on-upstream-requests">
  アップストリームリクエストの静的ヘッダー
</h4>

ゲートウェイが 1 つのアップストリームに送信するリクエストに固定ヘッダーを追加するには、そのアップストリームで `headers:` を設定します。実行するプロキシがヘッダーでトラフィックをルーティングまたは属性付けする場合に使用します。

`headers:` にはゲートウェイサーバーで Claude Code v2.1.277 以降が必要です。以前のゲートウェイはキーを見つけたときに起動を拒否します。すべてのレプリカをアップグレードしてからキーを追加し、以前のバージョンにロールバックする前にキーを削除します。

ヘッダーは `base_url` が名前を付けるサーバー、または `base_url` が設定されていない場合はプロバイダー独自のエンドポイントに移動します。プロキシがそれらを削除しない限り、プロバイダーもそれらを受け取ります。

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

`headers:` はすべてのプロバイダーで機能し、各アップストリームは独自のみを送信します。

ゲートウェイがアップストリームに送信するすべてのリクエストがそれらを含むわけではありません：

| ゲートウェイがこのアップストリームに送信するリクエスト | `headers:` を含む |
| - | - |
| `/v1/messages`。ストリーミングまたはそうでなく、および `/v1/messages/count_tokens` | はい |
| 別のアップストリームからフェイルオーバーしたリクエスト | はい。このアップストリームの `headers:` のみ |
| クライアントが放棄したリクエストの Amazon Bedrock の `CountTokens` 呼び出し | いいえ |
| Workload Identity Federation トークン交換 | いいえ |

AWS SigV4 でリクエストに署名する Amazon Bedrock または Claude Platform on AWS アップストリームでは、これらのヘッダーは署名の一部であるため、プロキシはそれらを変更されずに通す必要があります。

ゲートウェイが予約するヘッダー名を使用する場合、起動エラーはそのヘッダーに名前を付けて起動を拒否します。予約名には以下が含まれます：

* `authorization` と `x-api-key`
* `host`、`content-type`、および `user-agent`
* `anthropic-`、`x-goog-`、`x-amz-`、または `x-amzn-` で始まる任意の名前

<h4 id="multiple-upstreams">
  複数のアップストリーム
</h4>

同じプロバイダーは異なる `name:` で複数回表示できます。これは異なるリージョン、異なるアカウント（異なる認証情報チェーン経由）、プロビジョニングされたスループット対オンデマンド、およびクロスプロバイダーフェイルバックをカバーします。

ゲートウェイはアップストリームを順に試みます。`5xx`、`429`、`401`、`403`、`404`、タイムアウト、および欠落エンドポイント（`501`）がフェイルオーバーします。他の `4xx` はそうしません。

`429` は per-upstream 容量であるため、プロビジョニングされたスループット（PT）枯渇はオンデマンドにフェイルオーバーします。アップストリームで [`forward_user_identity: true`](#per-user-identity-headers-for-a-proxy-you-run) を設定する場合、開発者のメールを含むリクエストへの `429` は per-user 拒否であり、フェイルオーバーしません。

すべてのリクエストは最初のアップストリームで開始されます。リクエストは、それより前のすべてのアップストリームが失敗したか、要求されたモデルを提供しない場合のみ、後のアップストリームに到達します。

ゲートウェイは失敗したアップストリームの記録を保ちません。アップストリームがダウンしている間、それに到達するすべてのリクエストはそれを試み、失敗するのを待ってから先に進みます。

Anthropic API アップストリームの場合、[`timeouts.upstream_ttfb_ms`](#http-tuning)はダウンアップストリームでの待機を制限します。その設定は他のプロバイダーには適用されません。ゲートウェイはアップストリームが応答を開始するまで最大 1 時間待機します。

`404` は per-upstream モデル可用性であるため、モデルを有効にしていないアップストリームは、それを提供する後のアップストリームをブロックしません。要求されたモデルを解決できないアップストリームはネットワークラウンドトリップなしでスキップされます。

この例は、プロビジョニングされたスループット Amazon Bedrock 割り当てを最初にルーティングし、オンデマンドと 2 番目のアカウントにオーバーフロー、最後に Anthropic API にフォールバックします：

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
| 異なるリージョン | リージョンごとに 1 つの Amazon Bedrock アップストリーム。独自の `region:` を持つ。[`auto_include_builtin_models: true`](#models) でクロスリージョン推論プロファイルは自動的にルーティングします。リージョンピン配置デプロイメントの場合、`models:` ブロックを使用します。 |
| 異なるアカウント | アカウントごとに 1 つの Amazon Bedrock アップストリーム。デフォルトチェーン（`auth: {}`）はポッドのアイデンティティを使用します。2 番目のアカウントの場合、短期認証情報でそれに到達するために [`assume_role`](#bedrock-in-another-aws-account) を追加するか、`auth:` で明示的な認証情報またはベアラートークンを設定します。 |
| プロビジョニングされたスループット | モデルをそのアップストリームの名前の `models:` のプロビジョニングされたスループット ARN にマップします。他のアップストリームはオンデマンド ID を保つため、PT 容量はフェイルオーバーする前に枯渇します。 |
| VPC / FIPS エンドポイント | アップストリームで `base_url:` を VPC エンドポイントまたは FIPS エンドポイント URL に設定 |
| モデルスコープルーティング | カスタムモデル `id` のみ。組み込み Claude モデルではなく、`upstream_model:` マップに存在しないアップストリームをスキップします。ゲートウェイは組み込みモデルをすべてのアップストリームで順に試み、マップに エントリがない場合はプロバイダーのデフォルト ID を使用するため、組み込みモデルの場合、マップはアップストリームが試みられるかどうかではなく、アップストリームが受け取る ID を変更します。ID を拒否するアップストリームは、他のアップストリームエラーと同じ[フェイルオーバールール](#upstreams)に従います。 |

クラウドプロバイダー間、または直接 Anthropic API へのフェイルオーバーは、リクエストを制御する契約、地理、およびその他の条件を変更します。

CLI は、どのアップストリームが特定のリクエストを提供するかに関わらず、ゲートウェイに同じ機能ゲーティングを適用するため、フェイルオーバーはアップストリームが拒否する本体フィールドを送信しません。

<h2 id="optional-sections">
  オプションセクション
</h2>

<h3 id="admin">
  `admin`
</h3>

オプション。`/v1/organizations/spend_limits` を有効にします。これは Anthropic のパブリック Admin API をミラーリングし、`/v1/messages` でデベロッパーごとの支出強制を行います。キャップの設定と強制方法については [支出制限](/docs/ja/claude-apps-gateway-spend-limits) を参照してください。このセクションでは、この機能をオンにしてチューニングする `gateway.yaml` キーについて説明します。

```yaml theme={null}
admin:
  # 管理エンドポイント用の名前付き静的 API キー。x-api-key として送信されます。
  # id は監査ログに admin-key:<id> として表示されるため、各キーは
  # 追跡可能です。ローテーション用の配列：新しいキーを追加し、
  # クライアントをロールし、古いキーを削除します。
  write_keys:
    - { id: terraform, key: "${GATEWAY_ADMIN_WRITE_KEY_TF}" }
    - { id: ci,        key: "${GATEWAY_ADMIN_WRITE_KEY_CI}" }
  read_keys:
    - { id: reporting, key: "${GATEWAY_ADMIN_READ_KEY}" }
  # 通常のゲートウェイ JWT（API キーなし）を介して完全な管理者権限を付与される IdP グループ。
  admin_groups: [platform-finops]
  blocked_message: request an increase at https://go.example.com/claude-limits
```

| フィールド | 必須 | 説明 |
| - | - | - |
| `write_keys` | いいえ | `{id, key}` の配列。これらのいずれかと一致する `x-api-key` は、支出制限をリスト、設定、削除できます。キー値は最低 32 文字である必要があります。`id` は `read_keys` と `write_keys` 全体で一意である必要があります。 |
| `read_keys` | いいえ | `{id, key}` の配列。読み取り専用：すべての `GET` エンドポイント（キャップのリスト、ID による 1 つの取得、[`/effective`](/docs/ja/claude-apps-gateway-spend-limits#%2Feffective) と [`/audit`](/docs/ja/claude-apps-gateway-spend-limits#%2Faudit) の読み取りを含む）。 |
| `admin_groups` | いいえ | IdP グループ名。`groups` クレームにこれらのいずれかを含むゲートウェイ JWT は、完全な管理者アクセス（読み取りと書き込み）を持ち、`oidc:<sub>` として監査されます。人間の管理者にはこれを使用し、マシンには API キーを使用してください。このリストの空のエントリはブート時にゲートウェイを停止します。[ゲートウェイをブート時に停止させるマッチャー値](#matcher-values-that-stop-the-gateway-at-boot) を参照してください。 |
| `blocked_message` | いいえ | ブロックされたデベロッパーが見る `429 billing_error` に逐語的に追加されます。URL や Slack チャネルなど、完全な指示を記述してください。設定されていない場合、ゲートウェイはデフォルトメッセージのみを送信します。[強制の仕組み](/docs/ja/claude-apps-gateway-spend-limits#how-enforcement-works) を参照してください。 |
| `audit_retention_days` | いいえ | デフォルト `365`。古い `admin_audit` 行は削除されます。 |
| `spend_retention_months` | いいえ | デフォルト `13`。この期間より古い `spend` カウンター行は削除されます。デフォルトは前年比レポート用に完全な 1 年と現在の部分月を保持します。 |
| `identity_retention_days` | いいえ | デフォルト `90`。`principal_emails` 行の最後に見た TTL。各デベロッパーのメール、表示名、グループ（PII）を保持します。意図的に支出保持より短いため、プロビジョニング解除されたアイデンティティは古くなりますが、その匿名支出カウンターは残ります。 |
| `group_limit_mode` | いいえ | `min`（デフォルト）または `max`。デベロッパーが複数のグループにキャップがある場合、`min` は最も制限的なものを強制し、`max` は最も制限的でないものを強制します。強制と `/effective` の両方で使用されます。 |

<h3 id="enforcement">
  `enforcement`
</h3>

`enforcement` ブロックは、ストアが利用できない場合に支出制限チェックがどのように動作するかを制御します。

| フィールド | 必須 | 説明 |
| - | - | - |
| `fail_closed_on_error` | いいえ | デフォルト `false`。支出強制は Postgres 停止時にオープンで失敗するため、推論は稼働し続けます。`true` に設定してクローズで失敗させます：キャップを超えたデベロッパーはブロックされますが、ストアに到達できない場合は他のすべてのユーザーもブロックされます。[`admin:`](#admin) ブロックが必要です：支出強制は `admin` が設定されている場合にのみ実行され、これを `true` に設定せずにゲートウェイが起動することを拒否します。 |

<h3 id="pricing">
  `pricing`
</h3>

`pricing` ブロックは、支出メーターに USD リスト価格の代わりに請求する内容を指示するため、キャップと [`/effective`](/docs/ja/claude-apps-gateway-spend-limits#%2Feffective) は契約レートを反映します。金額は USD のままで、請求書ではなく見積もりです。2 つの前提条件があります：

* ゲートウェイサーバー上の Claude Code v2.1.227 以降。以前のバージョンはブート時に不明なキーを拒否します。
* [`admin:`](#admin) ブロック、または v2.1.268 以降では、少なくとも 1 つのポリシーを持つ [`managed:`](#managed) ブロック。ゲートウェイは `pricing` が設定されていて、どちらのブロックもない場合、起動を拒否します。これは何も読まないためです。

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
| `multiplier` | いいえ | デフォルト `1`。メーターはリスト価格またはオーバーライドされたかどうかに関わらず、すべてのメーター量にこれを乗算するため、`0.85` は価格の 85% を請求します。0 より大きく最大 10 である必要があり、1 より上の値は [マークアップ](#mark-prices-up) です。 |
| `overrides` | いいえ | 100 万トークンあたり USD での `{upstream, model, input, output, cache_read, cache_write}` の行。4 つのレートすべてが必要です。各レートは 0 より大きく最大 10000 である必要があります。 |

メーターがオーバーライド行をどのようにマッチングするか：

* 行は、`upstream`（[`upstreams[].name`](#upstreams)）が `model` に対して提供するリクエストのリスト価格を置き換えます。これには、より高い [高速モード](/docs/ja/fast-mode#understand-the-cost-tradeoff) レートが含まれるため、高速リクエストと標準リクエストは同じ 4 つのレートでメーターされます。
* `claude-sonnet-4-6` などの組み込み ID（[`models[].id`](#models) のようにマッチング）は、メーターがそのモデルとして価格設定するすべての日付付き形式、地域の Amazon Bedrock 形式、または Google Cloud の Agent Platform 形式をカバーします。エイリアスや推論プロファイル ARN などの他の文字列は、クライアントが送信した ID または上流に送信された文字列と大文字小文字を区別しないでマッチングします。
* 行が重複する場合、メーターは最初の行ではなく最も具体的な行を選択します：上流に送信された正確なモデル文字列である `model` を持つ行、次にクライアントが送信した正確な ID とマッチングする行、次に組み込みモデルに名前を付ける行。
* 不明な上流名はブート失敗を引き起こし、1 つの上流に対して同じモデルに名前を付ける 2 つの行も同様です（組み込みモデルの 1 つのスペルを含む）。ゲートウェイはブート時に、リクエスト可能なモデルが使用できない行について警告します。
* Web 検索リクエストは \$0.01 リスト価格のままです。乗数はそれらにも適用されます。

地域ごとのレートについては、各地域に独自の名前付き上流を与え、上流ごとに 1 つの行を与えます。

<h4 id="mark-prices-up">
  価格をマークアップする
</h4>

ゲートウェイサーバー上の v2.1.271 以降では、`multiplier` を 1 より上に設定でき、最大 10 まで、プロバイダーが請求する以上にメーターするため、例えば内部チャージバックレートです。この例は、すべてのリクエストを価格の 120% でメーターします：

```yaml theme={null}
pricing:
  multiplier: 1.2
```

[`admin:`](#admin) ブロックを使用すると、マークアップは支出制限にも適用されます。メーターは価格の 120% をカウントするため、デベロッパーはキャップに早く到達します。ゲートウェイはブート時に、そのことを示す警告をログに記録します。

乗数は、上流プロバイダーがリクエストに請求する内容を変更しません。

ゲートウェイが [署名済みクライアントにレートを送信](#send-the-rates-to-signed-in-clients) する場合、デベロッパーは Claude Code v2.1.271 以降を必要とします。以前のクライアントは 1 より上の `multiplier` を無視し、それなしでコストを表示します。

v2.1.271 より前のゲートウェイサーバーは、`multiplier` を 1 より上に設定した場合、起動を拒否します。

<h4 id="send-the-rates-to-signed-in-clients">
  署名済みクライアントにレートを送信する
</h4>

ゲートウェイサーバー上の v2.1.268 以降では、ゲートウェイは `pricing` からのレートを、提供する [`managed`](#managed) ポリシーに [`modelPricing`](/docs/ja/settings-reference#modelpricing) マネージド設定として入れます。ポリシーにマッチするデベロッパーは、`/usage`、ステータス行、OpenTelemetry で各モデル ID を提供する最初の上流の `pricing` レートを見ます。ポリシーにマッチしないデベロッパーはマネージド設定を受け取らないため、その数字はリスト価格のままです。クライアントは Claude Code v2.1.242 以降で設定を適用します。

* ゲートウェイが追加するもの：ポリシーの `cli` ブロックが既に `modelPricing` を設定していない限り、ゲートウェイは `multiplier` と、クライアントがリクエストできるすべてのモデル ID について、それを提供する最初の上流のオーバーライド行を追加します。フェイルオーバー上流のみが請求するレートはゲートウェイに留まります。
* 1 つのポリシーをオプトアウトする：そのポリシーの `cli` ブロックで `modelPricing` を `{}` に設定し、そのデベロッパーはリスト価格のままです。
* ポリシー独自のレートを保持する：`cli` ブロックが独自の `multiplier` または `overrides` で `modelPricing` を設定するポリシーは、その `modelPricing` 全体を保持し、ゲートウェイはそれに独自のレートを追加しません。

<h3 id="models">
  `models`
</h3>

`models` ブロックはオプションの管理者キュレーション済みモデルリストで、`/v1/models` で提供され、上流ごとにモデル ID を変換するために使用されます。これは、米国以外の Amazon Bedrock リージョン、Amazon Bedrock プロビジョニング済みスループット ARN、および Microsoft Foundry デプロイメント名に必須です。

```yaml theme={null}
auto_include_builtin_models: true   # false: 以下のリストのみを公開
models:
  - id: claude-opus-4-8
    label: Claude Opus 4.8
    # description: クライアントで表示されるオプションテキスト
    upstream_model:
      anthropic: claude-opus-4-8
      bedrock: us.anthropic.claude-opus-4-8   # または推論プロファイル ARN
      foundry: your-opus-deployment-name
```

`upstream_model` の各キーは、設定された上流の `name` と一致する必要があります。デフォルトはプロバイダー名です。キーが上流と一致しない場合、ブート失敗を引き起こすため、使用しないプロバイダーの行は省略してください。

<h3 id="managed">
  `managed`
</h3>

`managed` ブロックは、IdP グループまたはメールドメインをキーとしたロールベースのアクセスポリシーを定義します。ポリシーは順序で評価され、最初のマッチが選択され、`match: {}` キャッチオール基盤にマージされます。これらは `GET /managed/settings` でユーザーごとに ETag/304 キャッシング付きで提供されます。

```yaml theme={null}
managed:
  policies:
    # 特定のグループを最初に。
    - match: { groups: [eng-contractors] }
      cli:
        availableModels: [claude-sonnet-4-6]
        permissions: { deny: ["WebFetch", "WebSearch"] }
    # デフォルトキャッチオール最後：認証されたすべてのユーザーにマッチング。
    - match: {}
      cli:
        availableModels: [claude-opus-4-8, claude-sonnet-4-6, claude-haiku-4-5]
```

`match: {}` キャッチオール（慣例的に最後にリストされる）は基盤層として扱われます。他のすべてのポリシーは、設定しないキーについてキャッチオールから継承するため、ロールごとのエントリは組織のデフォルトから異なる内容のみをリストする必要があります。マージルールはキータイプに依存します：

* **許可リスト**：`availableModels` と `permissions.allow`。特定のポリシーのリストは基盤のリストを完全に置き換えます。
* **拒否リストとフック配列**：`permissions.deny`、`permissions.ask`、`disabledMcpjsonServers`、`deniedMcpServers`、`blockedMarketplaces`、およびすべての `hooks` イベントタイプ配列。これらは基盤とポリシーの和集合を取るため、組織全体の拒否または監査フックはロールごとのオーバーライドで誤って削除されることはありません。
* **レコード型キー**：`env`、`modelOverrides`、`skillOverrides`。これらは浅くマージするため、ロールごとの `env` ブロックは設定するキーをオーバーライドし、基盤から残りを継承します。

`availableModels` は `/v1/messages` でサーバー側でも強制されるため、拒否されたモデルはクライアントが送信する内容に関わらず `400` を返します。

ゲートウェイはリクエストを中継する前に `model` 値自体を検証するため、不正な形式の値は上流に到達しません。2 つの場合に `400` でリクエストを拒否します：

* 値が欠落しているか空の場合、ゲートウェイはメッセージ `model is required` でリクエストを拒否します。このチェックには Claude Code v2.1.228 以降を実行しているゲートウェイが必要です。
* 値が存在しているが文字列ではない場合、ゲートウェイはメッセージ `model must be a string` でリクエストを拒否します。Claude Code v2.1.221 以降を実行しているゲートウェイが必要です。

| マッチャー | 動作 |
| - | - |
| `match: {}` | すべての認証されたユーザーにマッチング。これで開始し、後で上にグループスコープのポリシーを追加します。 |
| `match: { groups: [a, b] }` | JWT の `groups` クレームにリストされたグループのいずれかが含まれている場合にマッチング。大文字小文字を区別します：グループは IdP の正確な大文字小文字と一致する必要があります。 |
| `match: { email_domain: example.com }` | JWT の `email` クレームの最後の `@` の後の部分にマッチング。大文字小文字を区別しません。ポリシーごとに 1 つのドメインを受け入れます。 |
| `match: { groups: [a], email_domain: example.com }` | 両方の条件がマッチングする必要があります |

認証されたユーザーがポリシーにマッチしない場合、ゲートウェイのデフォルトを取得します。これはカタログ内のすべてのモデルとマネージド設定なしを意味します。保証されたデフォルトポリシーが必要な場合は、最後に `match: {}` キャッチオールを追加してください。

<Note>
  ゲートウェイは独自のユーザーディレクトリを保持しません。ユーザーの IdP トークンから各リクエストを認可し、トークンの `groups` クレームからグループメンバーシップを読み取り、それに対してポリシーを評価します。列挙するロスターはなく、事前作成するアカウントもなく、したがって SCIM エンドポイントもありません。SCIM が同期するものがないためです。

  ユーザーとグループのライフサイクル管理を、真実の源である IdP のネイティブ SCIM プロビジョニングまたは専用のアイデンティティガバナンスプラットフォームで実行してください。そこで管理されるメンバーシップとプロビジョニング解除は、トークンを通じてゲートウェイに自動的に流れます。Claude アカウント自体の SCIM プロビジョニングが必要な場合、それは [Claude for Enterprise](/docs/ja/admin-setup) 機能です。

  2 つの伝播クロックが適用されます：

  * **ポリシーコンテンツ**：ポリシーを編集して再デプロイすると、接続されたクライアントの次のマネージド設定ポーリング時に到達します。1 時間以内。[次の起動時にのみ適用される変更](/docs/ja/server-managed-settings#fetch-and-caching-behavior) を除きます。
  * **グループメンバーシップ**：ユーザーのグループメンバーシップを変更すると、どのポリシーがそれらにマッチングするかが変わります。これは次のセッション再ミント時に有効になります。つまり、次のサイレントリフレッシュ。`session.ttl_hours` で制限されます。
</Note>

<h4 id="matcher-values-that-stop-the-gateway-at-boot">
  ゲートウェイをブート時に停止させるマッチャー値
</h4>

ブート時に、ゲートウェイはすべてのポリシーの `match` ブロックと [`admin_groups`](#admin) リストをチェックします。これらの値のいずれかがゲートウェイを停止させ、フィールドに名前を付けるエラーが発生します：

* 空の `groups` リスト
* `groups` または `admin_groups` の空のエントリ
* 空の `email_domain`
* `@`、空白、またはコンマを含む `email_domain`。ゲートウェイはこのチェック前に値をトリミングし、1 つの先頭 `@` を削除します。`example.com` などの 1 つの裸のドメインを記述してください。

v2.1.232 より前では、ゲートウェイはこれらの値で起動しました。各値はこの効果を持っていました：

* 空の `email_domain`：ゲートウェイはドメインチェックをスキップしたため、空の `email_domain` と `groups` リストなしのポリシーはすべての認証されたユーザーにマッチングしました。
* 空の `groups` リスト：ポリシーは誰にもマッチングしませんでした。
* `@`、空白、またはコンマを含む `email_domain`：ポリシーは誰にもマッチングしませんでした。
* `groups` または `admin_groups` の空のエントリ：エントリはそのユーザーの IdP `groups` クレームにも空のエントリが含まれている場合にのみユーザーにマッチングしました。`admin_groups` では、そのマッチングは管理者アクセスを付与しました。`admin_groups` リストに空のエントリが含まれていない場合、誰もこの方法で管理者アクセスを取得しませんでした。

<h4 id="what-goes-in-cli">
  `cli` に何を入れるか
</h4>

各 `cli` 値は完全な Claude Code `managed-settings.json` ドキュメント。MDM または `/etc/claude-code/managed-settings.json` を介してデプロイするのと同じスキーマ。YAML として表現されます。CLI は配信されたドキュメントをマネージド層で適用し、ユーザーとプロジェクト設定の上に、サーバーマネージド設定の代わりに適用します。したがって、[OS レベルのポリシーソースに限定される設定](/docs/ja/server-managed-settings#current-limitations)（`policyHelper` や `wslInheritsWindowsSettings` など）を無視します。

ゲートウェイは各ドキュメントをブート時に CLI の設定スキーマに対して検証するため、認識されないトップレベルキーはブート失敗を引き起こし、すべての違反キーに名前を付けるエラーが発生します。スキーマの意図的にオープンな部分はまだ任意の値を受け入れます。新しいクライアントがゲートウェイのスキーマが認識しないエントリを認識する可能性があるためです。これらのオープンキーには `env`、`pluginConfigs`、`permissions` の下にネストされたキーが含まれます。

検証はゲートウェイのインストール済みバージョンにバンドルされたスキーマを使用するため、新しい Claude Code リリースで導入されたトップレベル設定キーをマネージド設定に入れるには、最初にゲートウェイをアップグレードする必要があります。新しいポリシーを 1 つのクライアントでスモークテストしてからロールアウトしてください。

完全なキーリファレンスは [Claude Code 設定](/docs/ja/settings-reference#all-settings) にあります。オペレーターが最初に手を伸ばすキー：

```yaml theme={null}
managed:
  policies:
    - match: {}
      cli:
        # モデルアクセス（/v1/messages でサーバー側でも強制）
        availableModels: [claude-opus-4-8, claude-sonnet-4-6, claude-haiku-4-5]

        # 権限ポリシー
        permissions:
          deny:
            - "WebFetch"
            - "Read(./.env)"
            - "Read(./secrets/**)"
          disableBypassPermissionsMode: disable   # --dangerously-skip-permissions をブロック
        allowManagedPermissionRulesOnly: true     # ユーザー/プロジェクト権限ルールを無視

        # CLI プロセスにプッシュされた環境。DISABLE_UPDATES はバックグラウンドと
        # 手動更新をブロックします。DISABLE_AUTOUPDATER はバックグラウンド更新のみを停止します。
        env:
          DISABLE_UPDATES: "1"                    # 独自の配布を介してバージョンをピン留め

        # 組織全体のフック。フックコマンドはゲートウェイではなく
        # デベロッパーマシンで実行されるため、パスはポリシー内のすべてのクライアント OS に存在する必要があります。
        hooks:
          PostToolUse:
            - matcher: "Edit|Write"
              hooks:
                - { type: command, command: /usr/local/bin/audit-edit.sh }
```

| キー | 強制者 | 効果 |
| - | - | - |
| `availableModels` | ゲートウェイ + CLI | モデル許可リスト。`/v1/messages` でもチェックされるため、パッチされたクライアントはバイパスできません。 |
| `permissions.allow` / `.deny` | CLI | ツールとコマンドルール。[権限](/docs/ja/permissions) を参照してください。 |
| `permissions.disableBypassPermissionsMode` | CLI | `disable` に設定して [`bypassPermissions`](/docs/ja/permission-modes#skip-all-checks-with-bypasspermissions-mode)（権限プロンプトをスキップするモード）と `--dangerously-skip-permissions` フラグをブロックします。 |
| `allowManagedPermissionRulesOnly` | CLI | `true` の場合、マネージド設定は権限ルールの唯一の設定ソースになります。[`allowManagedPermissionRulesOnly`](/docs/ja/settings-reference#allowmanagedpermissionrulesonly) エントリは Claude Code が無視するすべてのソースをリストします。 |
| `env` | CLI | CLI プロセスにマージされた環境変数。テレメトリ、自動更新、モデル名オーバーライドに使用します。 |
| `hooks` | CLI | 組織全体の [フック](/docs/ja/hooks) |
| `managedMcpServers` | CLI | [マッチングするすべてのデベロッパーに提供される](/docs/ja/managed-mcp#provide-servers-through-managed-settings) リモート MCP サーバー。彼ら自身が追加するサーバー、`http` と `sse` のみ。[ポリシー内の MCP サーバー](#mcp-servers-in-a-policy) を参照してください。ゲートウェイサーバー上の Claude Code v2.1.259 以降とクライアント上が必要です。以前のクライアントはキーを無視します。 |

これらの設定はネットワーク経由で到着するため、CLI は以下にリストされた設定を適用する前に、各デベロッパーにセキュリティ承認ダイアログを表示します：

* `hooks`
* プロキシとベース URL 変数など、デベロッパーの承認が必要な `env` 変数
* `apiKeyHelper` や `statusLine` などのシェル実行設定
* サンドボックスバイナリ設定 `sandbox.bwrapPath`、`sandbox.socatPath`、`sandbox.ripgrep`
* `sandbox.network.tlsTerminate` やプロキシポート設定など、トラフィックをインターセプト、認証情報を注入、または分離を弱める Sandbox 設定。[セキュリティ承認ダイアログ](/docs/ja/server-managed-settings#security-approval-dialogs) はすべてをリストします。

[承認メモリ](/docs/ja/server-managed-settings#approval-memory) は承認がどのくらい続くか、ダイアログがいつ再度表示されるかをカバーします。

Claude Code は、モデル選択設定や数値制限など、デベロッパーの承認ダイアログを表示せずに配信された `env` 変数の一部を適用します。他の配信変数はデベロッパーの承認が必要な場合があります。空でないプロキシ、ベース URL、または `OTEL_EXPORTER_OTLP_ENDPOINT` 値は常にそうです。配信変数が承認を必要とする場合、ダイアログはそれに名前を付けます。

[環境変数と承認ダイアログ](/docs/ja/server-managed-settings#environment-variables-and-the-approval-dialog) には詳細があります。配信値がそれらが承認を必要とするかどうかを決定する 4 つのプライバシートグルを含みます。v2.1.218 より前では、Claude Code はより少ない変数をデベロッパーに尋ねずに適用したため、より多くの配信変数がダイアログをトリガーしました。

ゲートウェイの [テレメトリ](#telemetry) 設定は `OTEL_EXPORTER_OTLP_ENDPOINT` をプッシュするため、`telemetry.forward_to` を設定すると各インタラクティブクライアントでダイアログをトリガーします。ダイアログは組織をデベロッパーから保護するのではなく、デベロッパーのマシンを侵害されたまたは敵対的なゲートウェイから保護します。

[非インタラクティブ実行](/docs/ja/server-managed-settings#security-approval-dialogs)（`claude -p` や Agent SDK セッションなど）はダイアログを表示できません。その実行のためにプッシュされた設定を適用し、それらを承認済みとして記録しないため、デベロッパーの次のインタラクティブセッションはまだダイアログを表示します。v2.1.207 より前では、非インタラクティブ実行は設定を承認済みとして保存し、後のインタラクティブセッションはそれらのダイアログを表示しませんでした。

デベロッパーが拒否した場合、Claude Code はポリシーを適用するのではなく、そのセッションを終了します。新しいフック、またはダイアログをトリガーする任意の env 変数を広いポリシーにプッシュする場合、マッチングするすべてのデベロッパーはそのインタラクティブセッションでダイアログを見ます。実行中のインタラクティブセッションは次の時間ごとのポーリングでそれを表示し、そうでなければデベロッパーの次のインタラクティブ起動時に表示されます。

`cli` キーは以前のリリースで `settings` という名前でした。そのスペルはまだエイリアスとして受け入れられていますが、新しいデプロイメントは `cli` を使用する必要があります。

<h4 id="mcp-servers-in-a-policy">
  ポリシー内の MCP サーバー
</h4>

ポリシーが一致する Claude Code クライアントに MCP サーバーを提供するには、そのポリシーの `cli` ブロックで [`managedMcpServers`](/docs/ja/managed-mcp#provide-servers-through-managed-settings) を設定します。ゲートウェイサーバー上の Claude Code v2.1.259 以降とクライアント上が必要です。

ゲートウェイは各エントリをブート時に [Claude Code がクライアントで適用するのと同じルール](/docs/ja/managed-mcp#what-an-entry-can-contain) でチェックし、エントリがチェックに失敗した場合、ゲートウェイは起動を拒否し、エントリに名前を付けます。

`gateway.yaml` に `${VAR}` リファレンスを記述する場合、ゲートウェイは [シークレット展開](#secret-expansion) を通じてブート時にその環境から解決するため、マッチングするすべてのクライアントはリテラル値を受け取り、それを読むことができます。[提供されるサーバーのヘッダーガイダンス](/docs/ja/managed-mcp#provide-servers-through-managed-settings) は展開された値に適用されます。

ゲートウェイは `cli` ブロックの `.mcp.json` スペル `mcpServers` を拒否し、そのブート エラーは `managedMcpServers` を使用するキーに名前を付けます。v2.1.259 より前では、ゲートウェイは `cli` ブロック内の MCP サーバー定義を拒否しました。

<h4 id="claude-desktop-overlay">
  Claude Desktop オーバーレイ
</h4>

組織が [Claude Desktop](/docs/ja/desktop) もデプロイする場合、同じゲートウェイが両方のクライアントを提供します。Claude Desktop の [マネージド設定](https://claude.com/docs/third-party/claude-desktop/configuration) の `bootstrapUrl` を `<listen.public_url>/user/bootstrap` に指します。Claude Desktop はその URL から OAuth 発行者を導出し、このゲートウェイに対して同じデバイスコード サインインを実行し、応答からその設定を取得します。

<Note>
  ゲートウェイサーバー上の Claude Code v2.1.203 以降が必要で、明示的なオプトイン：`/user/bootstrap` はポリシーがユーザーと一致する `desktop` キーを持たない限り 404 を返します。空の `desktop: {}` はポリシーをオプトインし、`match: {}` 基盤層の `desktop` キーはそれを継承するすべてのポリシーをオプトインします。監査ログは各リクエストを `desktop_bootstrap.serve` または `desktop_bootstrap.denied` として記録します。
</Note>

ゲートウェイは応答の多くをマッチングされたポリシーの `cli` ブロックとトップレベルゲートウェイ設定から導出します：

* `availableModels` からのモデルリスト
* 裸のツール名 `permissions.deny` エントリから無効化されたツール。ポリシーの `desktop` ブロックで `disabledBuiltinTools` を設定する場合、ゲートウェイはあなたの値と導出されたリストの和集合を提供するため、この方法でより多くのツールを無効化できますが、`permissions.deny` を通じて無効化したツールを再度有効化することはできません。
* `sandbox.network.allowedDomains` からの出力許可リスト。ポリシーの `desktop` ブロックで `coworkEgressAllowedHosts` を設定する場合、ゲートウェイは導出されたリストの代わりにその値を使用します。
* ゲートウェイ自体を指す OTLP エンドポイント、および署名済みユーザーのアイデンティティ属性。ゲートウェイはそのエンドポイントで受け取るエクスポートを `forward_to` 宛先にリレーします。[`telemetry.forward_to`](#telemetry) と `listen.public_url` の両方を設定する場合、エンドポイントと属性を含めます。

  Claude Desktop はすべてのシグナルを 1 つのエンコーディングでエクスポートします：`http/protobuf`、または `OTEL_EXPORTER_OTLP_PROTOCOL` またはそのシグナルごとのバリアントの 1 つをポリシーの `env` で `http/json` に設定する場合は `http/json`。ゲートウェイサーバー上の Claude Code v2.1.261 より前では、応答は関係なく `http/json` を設定したため、protobuf のみを受け入れるコレクターは Claude Desktop のエクスポートを拒否しました。

ポリシーの `desktop` ブロックで `disabledBuiltinTools`、`coworkEgressAllowedHosts`、または Claude Desktop 独自の `managedMcpServers` 設定を設定するには、ゲートウェイサーバー上の Claude Code v2.1.232 以降が必要です。Claude Desktop の `managedMcpServers` はオブジェクトではなく配列値を取ります。

ゲートウェイは Claude Desktop 相当がないキー（`hooks` やスコープ権限ルール（`Bash(npm *)` など））をブートストラップ応答から省略します。

`cli` の横にオプションの `desktop` ブロックを追加して、Claude Desktop 設定を直接設定します。Claude Desktop の [マネージド設定リファレンス](https://claude.com/docs/third-party/claude-desktop/configuration) からの設定をフラットキー名として記述します。Claude Desktop が MDM またはローカルファイルからのみ読み取るキー（`bootstrapUrl` など）は省略してください。ゲートウェイはブート時にそれらを拒否します。v2.1.232 より前では、ゲートウェイは `chatTabEnabled` や `disableAutoUpdates` などの固定リストの 11 個の機能ゲートキーを受け入れ、他のすべてのキーをブート時に拒否しました。v2.1.227 より前では、ゲートウェイは `chatTabEnabled` と `chatAdvancedFileAnalysisEnabled` もブート時に拒否しました。

```yaml theme={null}
managed:
  policies:
    - match: { groups: [eng-contractors] }
      cli:
        availableModels: [claude-sonnet-4-6]
      desktop:
        isLocalDevMcpEnabled: false
        disableAutoUpdates: true
        banner: { text: "Contractor build: internal use only" }
```

すべてのキーはオプションです。Claude Desktop は省略したキーについて独自のデフォルトを適用します。ゲートウェイは各 `desktop` ブロックをブート時に Claude Desktop 自体が使用する設定スキーマに対して検証するため、間違いはゲートウェイ起動時にエラーとしてキーに名前を付けるのではなく、接続されたすべてのデスクトップに到達します。ゲートウェイはブロックに以下が含まれている場合に失敗します：

* 不明なキー
* Claude Desktop が拒否するか静かにドロップする認識されたキー。空の値やネストされたエントリ内のスペル間違いなど。v2.1.260 より前では、ゲートウェイは `managedMcpServers` または `orgPluginSettings` エントリのネストされたオブジェクト内のスペル間違いフィールドを静かにドロップするのではなく、ブート時に失敗しました。
* ゲートウェイが自身で計算するキー：推論接続、モデルリスト、OTLP リレー。[`upstreams`](#upstreams)、[`models`](#models)、[`telemetry`](#telemetry) セクションの `forward_to` を通じてそれらを設定します。
* 現在のキーのレガシーエイリアス。ブートエラーでは、ゲートウェイは記述する正規キーに名前を付けます。

非推奨の値またはエントリ形状（`transport` なしの `managedMcpServers` エントリなど）を使用する場合、ゲートウェイは起動し、置き換えに名前を付ける警告をログに記録します。

ゲートウェイは `cli` ブロックと同様に、インストール済みバージョンにバンドルされたスキーマに対して `desktop` ブロックを検証します。新しい Claude Desktop リリースで導入された設定を配信するには、最初にゲートウェイをアップグレードしてください。例えば、`userPluginMarketplacesEnabled` と `userPluginUploadsEnabled` には、ゲートウェイサーバー上の Claude Code v2.1.260 以降と、メンバーのマシン上の Claude Desktop 1.37937.0 以降が必要です。

`blockReadsOutsideWorkingDirectories`、`disableBypassPermissionsMode`、`configRecheckIntervalMinutes`、`sshClientPath` には、ゲートウェイサーバー上の Claude Code v2.1.281 以降が必要です。Microsoft 365 `managedMcpServers` エントリの `microsoftAuthBroker` の `required` 値と `continuousAccessEvaluation` フィールドも同様です。Claude Desktop リリースが `required` 値より前の場合、それを `disabled` として読み取るため、すべてのメンバーの Claude Desktop がそれをサポートした後にのみ `required` を設定してください。Claude Desktop の [マネージド設定リファレンス](https://claude.com/docs/third-party/claude-desktop/configuration) は各キーを最初に読むリリースをリストします。

ポリシーの `desktop` ブロックで `orgPluginSettings` を設定する場合、ゲートウェイは Claude Desktop 1.15200.0 以降が読む配列形式で提供します。古いデスクトップは配列を無視し、プラグインツールポリシーを強制しないため、それに依存する前にメンバーを 1.15200.0 以降に更新してください。

ゲートウェイは、ポリシーの `desktop` ブロックが設定しないキーを `match: {}` キャッチオールの `desktop` ブロックから埋めます。ポリシーの `cli` ブロックを基盤から埋めるのと同じ方法です。基盤とロールポリシーの両方で `disabledBuiltinTools` または `builtinToolPolicy` を設定する場合、ゲートウェイは基盤の制限を保持します：

* `disabledBuiltinTools`：ゲートウェイは基盤のリストとポリシーのリストの和集合を使用します。
* `builtinToolPolicy`：基盤でツールを `allow` 以外の値に設定する場合、ロールポリシーで同じツールに `allow` を設定しても、ゲートウェイはその値を保持します。

他のすべてのキーについて、ロールポリシーで設定する場合、ゲートウェイはロールポリシーの値を使用します。ゲートウェイは配列またはネストされたオブジェクト（`banner` など）を全体で置き換えるため、ロールポリシーで `banner.text` を設定する場合、ゲートウェイは基盤の `banner.backgroundColor` をドロップします。

Claude Desktop をデプロイしない場合、ポリシーから `desktop` を完全に省略してください。ゲートウェイはすべてのユーザーに対して `/user/bootstrap` から 404 を返します。

<h4 id="precedence-with-other-managed-sources">
  他のマネージドソースとの優先順位
</h4>

デバイスに MDM 配信ポリシーまたはローカル `managed-settings.json` がある場合、ゲートウェイ配信設定が最初にランクされます。[マネージド層内の優先順位](/docs/ja/managed-settings#precedence-within-the-managed-tier) はマネージド設定ページにあり、ローカルソースが適用される場合、およびサンドボックスロックキー、`forceRemoteSettingsRefresh`、変数ごとの `env` マージなど、どのソースを選択したかに関わらず Claude Code が読むすべての管理ソースの [キー](/docs/ja/managed-settings#keys-read-from-every-admin-source) があります。MDM プロファイルまたはマネージド設定ファイルで設定された [`policyHelper`](/docs/ja/settings-reference#policyhelper) は、ゲートウェイが設定を配信しない場合にのみ実行されます。エントリはその出力が置き換えるものを示します。

[Claude Desktop](/docs/ja/desktop) などの埋め込みホストは SDK `managedSettings` オプションを通じてポリシーを提供できます。[埋め込みホストからの親設定](/docs/ja/managed-settings#parent-settings-from-embedding-hosts) は Claude Code がそれを適用する場合を示し、[親設定を制限する](/docs/ja/claude-apps-gateway#restrict-parent-settings) は `allowManaged*Only` ロックなしでもまだ適用される許可方向設定をリストします。

ゲートウェイポリシーはマシン上のすべての Claude Code 呼び出しに適用されます。非インタラクティブ `claude -p` 実行と Agent SDK によって生成されたセッションを含みます。ゲートウェイが起動時に到達不可能な場合、署名済みセッションはポリシーなしで実行するのではなく、エラーで終了します。

<h3 id="telemetry">
  `telemetry`
</h3>

CLI はメトリクス、ログ、有効な場合はトレースをゲートウェイに送信し、ゲートウェイはそれらを逐語的に各設定された宛先にリレーします。エクスポートは OpenTelemetry Protocol（OTLP）over HTTP を使用します。リレーをスキップして、セッションが直接コレクターにエクスポートするようにするには、[ポリシーでコレクターに名前を付けます](#export-directly-to-your-collector)。[使用状況の監視](/docs/ja/monitoring-usage) については、CLI が発行するメトリクスとイベントを参照してください。

`/login` を通じて署名されたセッションでは、CLI は各エクスポートに認証されたユーザーのアイデンティティをスタンプします。ゲートウェイが発行した JWT から読み取られます：`user.id`、`user.email`、`user.groups` 属性。デベロッパーごとのコスト帰属と使用状況帰属は、デベロッパー側の設定なしで機能します。

[Claude Desktop](#claude-desktop-overlay) と Cowork セッションがゲートウェイを通じて署名されている場合、テレメトリに `user.email` と `user.groups` を `enduser.id` と共にスタンプするため、1 つのクエリで `user.email` または `user.groups` でターミナル、Desktop、Cowork 使用状況をカバーできます。`user.groups` はコンマ区切りの IdP グループリストです。

Desktop と Cowork テレメトリは `enduser.sub` も含みます。ユーザーのメールが変わった場合でも同じままである `sub` クレームをアイデンティティプロバイダーが発行します。ターミナルセッションは同じ値を `user.id` の下にスタンプするため、ターミナル `user.id` に対して `enduser.sub` をマッチングするクエリは、1 人のユーザーのターミナル、Desktop、Cowork 使用状況をカバーします。Desktop と Cowork エクスポートでは、`user.id` は主体ではなく匿名識別子です。

Claude Code からのすべての OpenTelemetry データと同様に、これらの属性は組織が設定する宛先にのみ送信され、Anthropic には送信されません。

ユーザーのグループリストがパーセントエンコード後に 255 文字より長い場合、またはグループ名にコンマまたは等号が含まれている場合、ゲートウェイはそのユーザーの Desktop と Cowork テレメトリから `user.groups` を省略します。そのユーザーのターミナルセッションは完全なリストを含みます。

主体がパーセントエンコード後に 255 文字より長い場合、またはスペース、印字可能 ASCII 外の文字、または `,` `;` `=` `\` `"` `%` のいずれかを含む場合、ゲートウェイは `enduser.sub` を省略します。そのユーザーの Desktop と Cowork テレメトリは他の属性を保持します。

Desktop と Cowork テレメトリで `user.email` と `user.groups` を使用するには、ゲートウェイサーバー上の Claude Code v2.1.265 以降と、各デベロッパーのマシン上の Claude Desktop 1.24012 以降が必要です。

`enduser.sub` を使用するには、ゲートウェイサーバー上の Claude Code v2.1.274 以降が必要です。

```yaml theme={null}
telemetry:
  forward_to:
    - url: https://otel-collector.internal.example.com
      headers:
        Authorization: ${OTLP_TOKEN}
      # シグナルごとのオプトイン。デフォルト：メトリクスのみ。
      metrics: true
      logs: false
      traces: false
    - url: https://api.datadoghq.com/api/v2/otlp
      headers:
        DD-API-KEY: ${DD_API_KEY}
```

<Warning>
  各宛先は `metrics`、`logs`、`traces` に独立してオプトインし、デフォルトはメトリクスのみです。シグナルは感度が異なります：

  * **メトリクス**：トークンカウント、リクエストカウント、レイテンシーなどの集計カウンター
  * **ログとトレース**：完全な Bash コマンド、ツール入力、ファイルパスを含むことができ、Claude Code がデベロッパーのマシンで行うすべてをカバーします。

  ログとトレースは、そのデータが保証するアクセス制御と保持ポリシーを持つ宛先でのみ有効にしてください。
</Warning>

各 `forward_to` URL は `https://` を使用する必要があります。ゲートウェイ独自のループバックインターフェイス上のコレクターの場合は 1 つの例外があります：

* `http://localhost:<port>` は設定検証を通過しますが、[SSRF ガード](/docs/ja/claude-apps-gateway-deploy#threat-model-summary) は `ECONNREFUSED_SSRF` ですべてのエクスポートをブロックします。ゲートウェイの環境で `CLAUDE_GATEWAY_ALLOW_LOOPBACK=1` を設定しない限り。
* `http://127.0.0.1:<port>` または `http://[::1]:<port>` はその変数が設定されていない限りブート失敗します。

クラスター内コレクターの場合、独自の内部アドレスで HTTPS を公開するか、変数が設定されたサイドカーとして実行します。

`HTTPS_PROXY` が設定されている場合、ゲートウェイはそのプロキシを通じてエクスポートを送信します。

内部コレクターに直接到達するには、ホスト名またはドメイン（`.internal.example.com` など）の先頭ドットを持つドメインで `NO_PROXY` に追加します。ゲートウェイサーバー上の Claude Code v2.1.277 以降が必要です。ゲートウェイがプロキシなしでコレクターに到達できることを確認してください。先頭ドットのないエントリは、その下の名前ではなく、その正確な名前のみにマッチングします。CIDR 範囲はマッチングしません。

[プロキシのみの出力](#proxy-only-egress) がオンになっている場合、プロキシでコレクターを許可してください。`NO_PROXY` エントリはプロキシのみの出力をオフにするためです。

テレメトリは CLI ではデフォルトでオフです。`telemetry.forward_to` と `listen.public_url` の両方を設定する場合、ゲートウェイは `/managed/settings` を通じて 6 つの環境変数をプッシュして、接続されたクライアントのテレメトリをオンにします：

* `CLAUDE_CODE_ENABLE_TELEMETRY=1`
* `OTEL_METRICS_EXPORTER`、`OTEL_LOGS_EXPORTER`、`OTEL_TRACES_EXPORTER`。少なくとも 1 つの `forward_to` 宛先がそのシグナルを有効にする場合は `otlp` に設定され、そうでない場合は `none` に設定されます。
* `OTEL_EXPORTER_OTLP_ENDPOINT=<public_url>`
* `OTEL_EXPORTER_OTLP_PROTOCOL=http/protobuf`

[独自のラベルを追加](#add-your-own-labels) する場合、ゲートウェイは `OTEL_RESOURCE_ATTRIBUTES` もプッシュします。

ゲートウェイサーバー上の Claude Code v2.1.265 より前では、ゲートウェイは 3 つのエクスポーターセレクターすべてを `otlp` としてプッシュしました。宛先がオプトインしなかったシグナルを含みます。

プッシュされたエンドポイントはパブリック URL から構築されるため、メトリクスとログはデベロッパーまたはポリシーからの OTEL 設定を必要としません。

`/login` を通じて署名されたデベロッパーは、独自の OTEL 設定でエクスポートをリダイレクトできません：

* **ローカルに設定された変数**：Claude Code はプッシュされた変数をマネージド層で適用するため、各変数はデベロッパーがローカルで設定する値をオーバーライドします。
* **ローカルに設定されたエンドポイント**：OTLP/HTTP エクスポートが有効な場合、CLI はローカルに設定されたエンドポイントを無視します。ゲートウェイがテレメトリ変数をプッシュしたかどうかに関わらず。そのエクスポートはゲートウェイに送信されます。ポリシーが [コレクターをエンドポイントとして名前を付ける](#export-directly-to-your-collector) 場合を除きます。

シグナルの `forward_to` 宛先がない場合、ゲートウェイはそれを受け入れて破棄します。デベロッパーが既に Claude Code テレメトリを 1 つのコレクターにエクスポートしている場合、それを `forward_to` 宛先として追加し、ログまたはトレースを有効にします。サインイン後もデータを受け取り続けるため。リレーをスキップするには、代わりに [ポリシーでコレクターに名前を付けます](#export-directly-to-your-collector)。

[トレース](/docs/ja/monitoring-usage#traces-beta) には各クライアントで `CLAUDE_CODE_ENHANCED_TELEMETRY_BETA=1` も必要です。ゲートウェイはプッシュしないため、マネージドポリシーの `env` ブロックで設定してください。デベロッパーはプッシュされたエンドポイントが既にトリガーする同じ [セキュリティ承認ダイアログ](#managed) で承認します。

トレースしたいグループのみのポリシーで `1` に設定してください。ポリシーが設定しない場合、`match: {}` キャッチオールポリシーがそれを設定する場合、そのポリシーから値を継承します。[マージルール](#managed) に従います。デベロッパーがローカルで変数を設定した場合でも、グループのクライアントがトレースを送信しないようにするには、そのグループのポリシーで `0` に設定してください。

Protobuf と JSON OTLP エンコーディングの両方がリレーされ、OpenTelemetry 互換のバックエンドが宛先として機能します。

<h4 id="add-your-own-labels">
  独自のラベルを追加する
</h4>

ゲートウェイを通じて署名されたセッションのテレメトリに `service.namespace` や `deployment.environment.name` などの固定ラベルを付けるには、`telemetry.resource_attributes` を設定します。各ラベルは OpenTelemetry リソース属性で、すべての宛先は同じラベルを受け取ります。

セッションは `telemetry.forward_to` と `listen.public_url` も設定する場合にのみラベルを取得します。この例は 2 つのラベルを追加します：

```yaml theme={null}
telemetry:
  forward_to:
    - url: https://otel-collector.internal.example.com
  resource_attributes:
    service.namespace: claude
    deployment.environment.name: prod
```

ゲートウェイはラベルがこれらのルールのいずれかを破る場合、起動を拒否し、スタートアップエラーはラベルに名前を付けます：

* 名前は文字、数字、`.`、`_`、`-` のみを使用します。
* 名前は予約されていません。任意の文字ケースで比較すると、予約名は `user.`、`enduser.`、`identity.` で始まるすべてのもの、および `service.name`、`service.version`、`claude.deployment_mode`、`host.arch`、`os.type`、`os.version`、`wsl.version` です。
* 値は空でない印字可能 ASCII で、スペースなし、`,` `;` `=` `\` `"` `%` なし。
* 値はパーセントエンコード後に最大 255 文字です。ゲートウェイがカウントするため、`/`、`:`、`@` は各 3 文字です。
* 値はテキストなので、数字、`true`、`false` をクォートしてください。

ゲートウェイサーバー上の Claude Code v2.1.281 以降が必要です。`telemetry.resource_attributes` を設定するため。以前のゲートウェイはキーを見つけると起動を拒否します。すべてのレプリカをアップグレードしてからキーを追加し、以前のバージョンにロールバックする前にキーを削除してください。

`/login` を通じて署名されたターミナルセッションは、他の [テレメトリ変数](#telemetry) と共にプッシュされた `OTEL_RESOURCE_ATTRIBUTES` としてラベルを受け取ります。ポリシーの `env` ブロックで `OTEL_RESOURCE_ATTRIBUTES` を設定する場合、そのポリシーが一致するターミナルセッションはラベルの代わりにその値を取得します。Claude Desktop はゲートウェイから `user.email` および他のアイデンティティ属性と共にラベルを受け取ります。

Claude Code はすべてのメトリクスデータポイントに各ラベルをコピーするため、リソース属性をインデックス化しないバックエンドでそれでフィルタリングできます。そのコピーをオフにするには、[メトリクスカーディナリティ制御](/docs/ja/monitoring-usage#metrics-cardinality-control) を参照してください。

<h4 id="export-directly-to-your-collector">
  コレクターに直接エクスポートする
</h4>

`/login` を通じて署名されたセッションがリレーを通じてではなくコレクターにテレメトリを直接送信するようにするには、[マネージドポリシー](#managed) の `env` ブロックでコレクターの `https://` ベース URL に `OTEL_EXPORTER_OTLP_ENDPOINT` を設定します。Claude Code は URL に `/v1/metrics`、`/v1/logs`、`/v1/traces` を追加します。例えば `https://otel-collector.example.com:4318`。各シグナルを OTLP/HTTP でそこにエクスポートします。各デベロッパーのマシン上の Claude Code v2.1.265 以降が必要です。以前のクライアントはリレーを通じてエクスポートします。

コレクターに認証するには、同じ `env` ブロックで `OTEL_EXPORTER_OTLP_HEADERS` を設定します。セッションはこの方法で名前を付けられたコレクターにデベロッパーのゲートウェイセッショントークンを送信しません。

ポリシーでこのエンドポイントを追加または変更する場合、Claude Code は各デベロッパーに [セキュリティ承認ダイアログ](#managed) でそれを承認するよう求めます。インタラクティブセッションで適用する前に。

Claude Code はシグナルを直接エクスポートする前にエンドポイントをチェックし、チェックが失敗するとそのシグナルをリレーに保持します。チェックには以下が含まれます：

* エンドポイントはゲートウェイ自体から来ます。MDM プロファイルまたはローカル `managed-settings.json` で同じ変数を設定する場合、エクスポートはリレーに留まります。
* URL は `https://` を使用するか、ループバックアドレスへの `http://` を使用します。
* URL は `/v1/<signal>` で終わるパスに解決され、クエリまたはフラグメントはありません。Claude Code はジェネリック変数からそのパスを自身で構築します。`OTEL_EXPORTER_OTLP_METRICS_ENDPOINT` などのシグナルごとの変数を記述したとおりに使用するため、完全なパスをそこに含めます。
* URL はゲートウェイ独自のホストではありません。ゲートウェイに対処されたエンドポイントはリレーパスとそのセッショントークンを保持します。
* あなたもデベロッパーも、任意の設定ソースで [`otelHeadersHelper`](/docs/ja/settings-reference#otelheadershelper) を設定していません。ヘルパーが設定されている場合、すべてのシグナルはリレーに留まります。

あなたが名前を付けるエンドポイントはエクスポートがどこに行くかのみを変更します。ゲートウェイが既にプッシュしない限り、どのシグナルがエクスポートするかを選択する変数を設定する必要があります：

* ゲートウェイが既に [テレメトリ変数をプッシュ](#telemetry) する場合、それらは有効化、セレクター、プロトコルをカバーし、プッシュされた `<public_url>` 値をあなたの明示的なエンドポイントがオーバーライドします。`forward_to` 宛先がオプトインしないシグナルについてのみ、自分で `OTEL_*_EXPORTER` セレクターを `otlp` に設定してください。
* そうでない場合、`CLAUDE_CODE_ENABLE_TELEMETRY=1`、`OTEL_*_EXPORTER` セレクター、`OTEL_EXPORTER_OTLP_PROTOCOL=http/protobuf` も設定してください。

デベロッパーがサインアウトするか、別のゲートウェイにサインインする場合、コレクターへのエクスポートは停止し、Claude Code は各残りのバッチを遅延配信するのではなく削除します。

<h4 id="when-a-destination-fails">
  宛先が失敗する場合
</h4>

ゲートウェイはバッファリング、再試行、またはテレメトリを保存しないため、宛先に到達しないエクスポートは遅延配信するのではなく削除されます。各宛先は独立して成功または失敗し、エクスポートクライアントはどちらの場合でも成功応答を受け取るため、失敗した配信はゲートウェイのログにのみ表示されます。

5 つの連続した失敗した配信の後、ゲートウェイは 30 秒間隔でそれへの転送を一時停止し、各一時停止をログに記録します。配信が成功するまで。エラー応答、タイムアウト、接続エラーはすべて失敗した配信としてカウントされます。`400`、`413`、`415`、`422`、`431` を除きます。これらはコレクターがそのエクスポートのペイロードを不正な形式または大きすぎるとして拒否したことを意味します。

拒否されたペイロードは失敗カウントを進めたり、リセットしたりしません：ゲートウェイは宛先への転送を続け、最初の拒否と 100 番目ごとに警告をログに記録します。それに名前を付けます。

<h3 id="http-tuning">
  HTTP チューニング
</h3>

4 つのオプションのトップレベルブロック `access_control`、`limits`、`timeouts`、`rate_limits` は HTTP サーフェスをチューニングします。デフォルトはほとんどのデプロイメントに適しています。

| ブロック | キー | デフォルト | 説明 |
| - | - | - | - |
| `access_control` | `allow_cidrs` / `deny_cidrs` | 空 | インバウンド IP は `trusted_proxies` 解決後のクライアントアドレスで許可/拒否します。`deny_cidrs` が最初にチェックされます。クライアントがそれにマッチングする場合、`allow_cidrs` もマッチングしても拒否されます。`allow_cidrs` が空でない場合、ゲートウェイはデフォルト拒否です。`/healthz` と `/readyz` は `allow_cidrs` から除外されます。信頼されたプロキシが IP アドレスではない `X-Forwarded-For` エントリを送信する場合、実際のクライアントは不明で、ゲートウェイは確認する内容に名前を付ける警告を 1 回ログに記録します。リストのいずれかがリクエストに適用される場合、それは `403` と監査理由 `xff_unparseable` で拒否します。どちらも適用されない場合、リクエストを提供し、プロキシ独自のアドレスをクライアント IP として使用します。IP ごとのレート制限と監査用。 |
| `limits` | `max_request_bytes` | 32 MiB | 最大インバウンドリクエストボディ。サイズを超えたリクエストはボディがバッファリングされる前に `413` を取得します。大きなファイルまたは画像リクエストの場合は上げてください。 |
| `limits` | `max_request_header_bytes` | 未設定 | 設定されている場合、サイズを超えたヘッダーは `431` を返します。 |
| `limits` | `max_url_length` | 未設定 | 設定されている場合、長すぎる URL は `414` を返します。 |
| `timeouts` | `upstream_ttfb_ms` | 120000 | 上流のレスポンスヘッダーの最大待機時間（最初のバイトまでの時間）。レスポンスボディはその後、ウォールクロック上限なしでストリーミングされます。直接 Anthropic 上流パスに適用されます。他のすべてのプロバイダーでは、ゲートウェイはレスポンスが開始されるまで最大 1 時間待機します。 |
| `rate_limits` | `device_authorization.max` / `.window_seconds` | 30 / 600 | 認証されていないデバイス認可エンドポイントの IP ごとのレート制限。共有出力 IP または NAT の背後にある大規模な組織の場合は上げてください。[大規模ロールアウト](/docs/ja/claude-apps-gateway-deploy#large-rollouts) はそのサイズ方法を示します。これらの制限はデバイス付与サインインフローにのみ適用され、`/v1/messages` 推論には適用されません。[ユーザーコードブルートフォース耐性](/docs/ja/claude-apps-gateway-deploy#user-code-brute-force-resistance) を参照してください。 |
| `rate_limits` | `device_verify.max` / `.window_seconds` | 10 / 600 | `/device` での `user_code` 送信の IP ごとのレート制限。別のデベロッパーのコードを推測するのを止めるものです。[大規模ロールアウト](/docs/ja/claude-apps-gateway-deploy#large-rollouts) はどこまで上げるかを示します。 |

両方の `access_control` リストを空のままにする場合（デフォルト）、ゲートウェイはクライアントアドレスを提供するため、ネットワークのみがそれに到達できるユーザーを制限します。ゲートウェイは [マネージド設定](#managed) をプッシュできるため、これは重要です。デベロッパーマシンでコマンドを実行します。

`allow_cidrs` が空の間、ゲートウェイは 2 つの場所で警告を記録します。リクエストへの応答方法は変わりません：

* **ブート時**：運用ログの警告は、プライベート範囲 `10.0.0.0/8`、`172.16.0.0/12`、`192.168.0.0/16`、`100.64.0.0/10`、`127.0.0.0/8`、`::1/128`、`fc00::/7` のみを許可することを推奨します。デベロッパーが接続する他の内部範囲も同様です。ゲートウェイをループバックアドレスにバインドし、`trusted_proxies` も `public_url` も設定しない場合（ローカル開発のように）、警告は表示されません。
* **実行時**：リクエストが最初にこれらのプライベート範囲外のアドレスから到着する場合、ゲートウェイは警告をログに記録し、クライアント IP を含む [`access.public_client` 監査イベント](/docs/ja/claude-apps-gateway-deploy#logs) を発行します。両方はプロセスごとに 1 回発火します。リンクローカルアドレス `169.254.0.0/16` と `fe80::/10` はパブリックとしてカウントされません。ゲートウェイは `/healthz` と `/readyz` をこのチェック実行前に応答するため、パブリック範囲からのヘルスプローブはそれをトリガーしません。

両方のシグナルはゲートウェイが解決するクライアントアドレスを使用します。ロードバランサー、ポートフォワード、またはトンネルがトラフィックをリレーし、`listen.trusted_proxies` にリストされていない場合、ゲートウェイはリレーのアドレスを見ます。通常はプライベートなため、実行時警告もプライベート許可リストもそれをキャッチしません。

そのようなフロントエンドの背後で、最初に [`listen.trusted_proxies`](#listen) を設定して、ゲートウェイが実際のクライアントアドレスを見るようにし、ゲートウェイとその前のすべてをパブリックインターネットから到達不可能に保ってください。

<h3 id="load_test_mode">
  `load_test_mode`
</h3>

`load_test_mode` ブロックを使用すると、モデルプロバイダーを呼び出さずにゲートウェイをロードテストできます。オンの間、ゲートウェイは各プロバイダーリクエストを通常どおり構築して署名し、送信する代わりに破棄し、通常のレスポンスパスを通じて缶詰の返信をストリーミングします。返信は、それが缶詰であることを示す文で始まるフィラーテキストです。

ゲートウェイサーバー上の Claude Code v2.1.282 以降が必要です。以前のゲートウェイはキーを見つけると起動を拒否します。すべてのレプリカをアップグレードしてからブロックを追加し、以前のバージョンにロールバックする前にブロックを削除してください。

以下の例はデフォルトでモードをオンにします。約 750 トークンのテキストの返信が約 10 秒でストリーミングされます：

```yaml theme={null}
load_test_mode:
  enabled: true
  reply_tokens: 750     # 大体、各缶詰返信が含むテキストのトークン数
  reply_seconds: 9.5    # ストリーミング返信がどのくらい続くか
```

| フィールド | 必須 | 説明 |
| - | - | - |
| `enabled` | はい | `true` はモードをオンにします。`false` はモードをオフにしてファイルに数字を保持します。ブロックが存在する場合、ゲートウェイはそれなしで起動を拒否します。 |
| `reply_tokens` | いいえ | デフォルト `750`。大体、各缶詰返信が含むテキストのトークン数。1 から 100000 までの整数。 |
| `reply_seconds` | いいえ | デフォルト `9.5`。ストリーミング返信がどのくらい続くか。0 から 600 まで。`0` は返信全体を一度に送信します。非ストリーミングリクエストへの返信は常に一度に来ます。 |

このモードでのロードテストはゲートウェイ、Postgres、ゲートウェイの前のすべてをカバーします。プロバイダーの制限、速度、ネットワークパスはカバーしません。

プロバイダーにモデルリクエストは送信されないため、レプリカの CPU リクエストは見積もりで、本番より低く読み取られます。本番はプロバイダーへのトラフィックも暗号化します。小規模なパイロットで実際のプロバイダーに対してレプリカカウントを確認してください。v2.1.283 より前では、見積もりは非常に低く読み取られます。

モードがオンの間、リクエストは最大 7 桁の整数を保持する `x-load-test-user` ヘッダーを含むことができます。ゲートウェイは各数字を別のデベロッパーとしてカウントします。リクエストと共に来たデベロッパーのメールとグループを使用します。

ロードテストデプロイメントに独自の空のデータベースを与えてください。ゲートウェイはモードがオンで、任意のデベロッパーが既に何かを費やしたデータベースに対して起動を拒否するためです。

<Warning>
  デベロッパーが使用するゲートウェイでこれをオンにしないでください。すべてのリクエストは缶詰の返信を取得し、モデルは呼び出されません。ゲートウェイはブート時に `load_test_mode is on` 警告をログに記録し、モードがオンの間、各 `inference` [監査イベント](/docs/ja/claude-apps-gateway-deploy#logs) を `load_test: true` でマークします。
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
        # Constrain the Default picker option to availableModels instead of
        # the tier default, so contractors don't get a 400 on the default.
        enforceAvailableModels: true
        # allow auto-approves these tools; it does not block the rest.
        # Add deny rules to restrict tools.
        permissions: { allow: [Read, Grep] }
    - match: {}
      cli:
        availableModels: [claude-opus-4-8, claude-sonnet-4-6, claude-haiku-4-5]
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
