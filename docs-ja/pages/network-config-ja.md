> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# エンタープライズネットワーク設定

> プロキシサーバー、カスタム認証局（CA）、相互 Transport Layer Security（mTLS）認証を使用して、エンタープライズ環境向けに Claude Code を設定します。

Claude Code は、環境変数を通じてさまざまなエンタープライズネットワークおよびセキュリティ設定をサポートしています。これには、企業プロキシサーバーを通じたトラフィックのルーティング、カスタム認証局（CA）の信頼、および強化されたセキュリティのための相互 Transport Layer Security（mTLS）証明書による認証が含まれます。

Claude Code を起動する前に、これらの環境変数を設定してください。シェルでエクスポートされた変数は起動時に 1 回読み込まれるため、実行中のセッションはシェル環境への後の変更を取得しません。

> [!NOTE]
>
> このページに表示されているすべての環境変数は、[`settings.json`](/docs/ja/settings) でも設定できます。

## プロキシ設定

### 環境変数

Claude Code は標準的なプロキシ環境変数に対応しています。Claude Desktop セッションでアプリがプロバイダー接続を管理する場合、Claude Code はマネージド設定と `~/.claude/settings.json` からのみこれらを読み込みます。スコープルールについては [mTLS 認証](#mtls-authentication) を参照してください。

```bash theme={null}
# HTTPS プロキシ（推奨）
export HTTPS_PROXY=https://proxy.example.com:8080

# HTTP プロキシ（HTTPS が利用できない場合）
export HTTP_PROXY=http://proxy.example.com:8080

# 特定のリクエストのプロキシをバイパス - スペース区切り形式
export NO_PROXY="localhost 192.168.1.1 example.com .example.com"
# 特定のリクエストのプロキシをバイパス - カンマ区切り形式
export NO_PROXY="localhost,192.168.1.1,example.com,.example.com"
# すべてのリクエストのプロキシをバイパス
export NO_PROXY="*"
```

小文字のバリアントも機能し、Claude Code は `https_proxy`、`HTTPS_PROXY`、`http_proxy`、`HTTP_PROXY` の順序で設定されている最初のものを使用します。

Claude Code は `localhost`、`::1`、または `127.0.0.0/8` への WebSocket 接続をプロキシ経由で送信しないため、`NO_PROXY` でこれらのループバックエントリは不要です。

> [!NOTE]
>
> Claude Code は SOCKS プロキシをサポートしていません。

### 基本認証

プロキシが基本認証を必要とする場合は、プロキシ URL に認証情報を含めます。

```bash theme={null}
export HTTPS_PROXY=http://username:password@proxy.example.com:8080
```

> [!WARNING]
>
> スクリプトにパスワードをハードコーディングすることは避けてください。代わりに環境変数またはセキュアな認証情報ストレージを使用してください。

> [!TIP]
>
> 高度な認証（NTLM、Kerberos など）が必要なプロキシの場合は、認証方法をサポートする LLM Gateway サービスの使用を検討してください。

## CA 証明書ストア

デフォルトでは、Claude Code はバンドルされた Mozilla CA 証明書とオペレーティングシステムの証明書ストアの両方を信頼しています。OS ストアを読み取るには、`tls.getCACertificates` を備えたランタイムが必要です。ネイティブインストーラーは常にこれを備えており、npm インストールは Node 22.15 以降が必要です。古い Node バージョンでは、バンドルされたセットと `NODE_EXTRA_CA_CERTS` のみが適用されます。エンタープライズ TLS インスペクションプロキシは、ルート証明書が OS 信頼ストアにインストールされており、ランタイムがそれを読み取ることができる場合、追加の設定なしで動作します。このようなプロキシが gzip 圧縮されたリクエストボディを正しく処理できない場合は、[`CLAUDE_CODE_GZIP_REQUEST_BODIES=0`](/docs/ja/env-vars) を設定して、Claude API、テレメトリ、およびアーティファクト公開のリクエストの圧縮をオフにしてください。

`CLAUDE_CODE_CERT_STORE` はカンマ区切りのソースリストを受け入れます。認識される値は、Claude Code に付属する Mozilla CA セットの場合は `bundled`、オペレーティングシステムの信頼ストアの場合は `system` です。デフォルトは `bundled,system` です。

バンドルされた Mozilla CA セットのみを信頼するには：

```bash theme={null}
export CLAUDE_CODE_CERT_STORE=bundled
```

OS 証明書ストアのみを信頼するには：

```bash theme={null}
export CLAUDE_CODE_CERT_STORE=system
```

> [!NOTE]
>
> `CLAUDE_CODE_CERT_STORE` には、専用の `settings.json` スキーマキーがありません。`~/.claude/settings.json` の `env` ブロック、またはプロセス環境で直接設定してください。

## カスタム CA 証明書

エンタープライズ環境でカスタム CA を使用している場合は、Claude Code をそれを直接信頼するように設定します。

```bash theme={null}
export NODE_EXTRA_CA_CERTS=/path/to/ca-cert.pem
```

## mTLS 認証

エンタープライズ環境でクライアント証明書認証が必要な場合：

```bash theme={null}
# 認証用のクライアント証明書
export CLAUDE_CODE_CLIENT_CERT=/path/to/client-cert.pem

# クライアント秘密鍵
export CLAUDE_CODE_CLIENT_KEY=/path/to/client-key.pem

# オプション：暗号化された秘密鍵のパスフレーズ
export CLAUDE_CODE_CLIENT_KEY_PASSPHRASE="your-passphrase"
```

Claude Code は起動時に証明書とキーファイルを読み込み、[管理設定](/docs/ja/server-managed-settings)の `env` ブロックを組織が変更する場合など、設定を適用するたびに再度読み込みます。

証明書とキーをローテーションするには、同じパスのファイルを置き換えます。Claude Code は実行中のセッションで再起動なしに置き換えを検出します。接続リセットや TLS ハンドシェイクエラーなどの接続レベルのエラーで API リクエストが失敗した場合、両方のファイルを再度読み込み、新しいペアでリクエストを再試行します。v2.1.232 より前では、Claude Code は接続エラー時に再度読み込まず、次に設定を適用するか再起動するまで既に読み込まれたペアを保持していました。

Claude Code はファイルの変更を監視するのではなく、失敗したリクエストに応答してファイルを再度読み込みます：

* **タイミング**：Claude Code はファイルを置き換えた時点では何もしません。適格な失敗後の再試行時、または設定を適用した後の次のリクエスト時のいずれか早い方で新しいペアを提示します。
* **ゲートウェイの拒否**：Claude Code は、ゲートウェイが古いペアの受け入れを停止した後に接続をリセットするか TLS ハンドシェイクを拒否した場合に再度読み込みます。ゲートウェイがハンドシェイクを完了して HTTP エラーで応答した場合は再度読み込みません。その場合、Claude Code は次に設定を適用するか再起動するときに新しいペアを読み込みます。
* **半分書き込まれたローテーション**：Claude Code がローテーション中に再度読み込む場合（証明書とキーが互いに一致しないなど）、前のペアを保持し、次の失敗時に再度読み込みます。
* **OTLP テレメトリエクスポーター**：Claude Code は[エクスポーター](/docs/ja/monitoring-usage#mtls-authentication)が最初に使用したときに読み込んだ証明書を保持するため、ローテーションされた証明書がテレメトリコレクターに到達するには Claude Code を再起動してください。
* **リロードをオフにする**：[`CLAUDE_CODE_DISABLE_MTLS_RELOAD_ON_STALE_CONNECTION=1`](/docs/ja/env-vars#variables)を設定して接続エラー時の再度読み込みをオフにします。Claude Code はその後、次に設定を適用するか次の起動時にのみローテーションされたファイルを検出します。

Claude Code がローテーションを検出したことを確認するには、[デバッグログで セッションを開始](#verify-your-configuration)し、ログで `Stale connection — reloaded rotated mTLS client material` を探してください。Claude Code は設定を適用する際にローテーションを検出した場合、このラインをログに記録しないため、ラインが見つからないだけではローテーションが失敗したことを意味しません。

Claude Code が次の起動時に既に期限切れのペアを読み込まないように、現在のペアが期限切れになる前にファイルを置き換えてください。

[クラウドセッション](/docs/ja/claude-code-on-the-web)では、ホスティング環境が API への接続を管理するため、Claude Code は設定ファイルの `env` ブロックから来た場合、以下の変数を無視します：

* `CLAUDE_CODE_CLIENT_CERT`
* `CLAUDE_CODE_CLIENT_KEY`
* `CLAUDE_CODE_CLIENT_KEY_PASSPHRASE`
* `NODE_EXTRA_CA_CERTS`
* `NODE_TLS_REJECT_UNAUTHORIZED`
* `CLAUDE_CODE_OAUTH_SCOPES`

Claude Code はセッションのデバッグログで無視された各キーを記録します。

アプリがプロバイダー接続を管理する [Claude Desktop](/docs/ja/desktop) セッション（[サードパーティプロバイダー](/docs/ja/third-party-integrations)の Code タブや Cowork セッションなど）では、Claude Code はこれらの変数とプロキシ変数 `HTTP_PROXY`、`HTTPS_PROXY`、および `NO_PROXY` を [管理設定](/docs/ja/managed-settings) と `~/.claude/settings.json` からのみ読み込みます。リポジトリ独自の設定ファイルではこれらを無視するため、チェックアウトされたリポジトリはアプリから認証情報が来るセッションの TLS またはプロキシパスをリダイレクトできません。claude.ai を通じてサインインしたローカル、SSH、または WSL Code タブセッションでは、アプリは接続を管理せず、Claude Code はすべての設定スコープからこれらの変数を読み込みます（任意のターミナルセッションと同様）。[クラウドセッション](/docs/ja/claude-code-on-the-web)はどこから開始しても上記のクラウドセッションルールに従います。v2.1.217 より前では、アプリが接続を管理していた場合、Claude Code はすべての設定ファイルでこれらの変数を無視していました。

## 設定を確認する

通常、プロキシアドレスが間違っているか、証明書パスが不正かは、後のリクエストで [接続エラーまたは証明書エラー](/docs/ja/errors#network-and-connection-errors) が発生することで判明します。Claude Code はこれらの設定のほとんどを読み込む際に検証しないためです。起動時にチェックされる唯一の設定はプロキシ URL です。`http://` スキームが欠落しているなど、値を解析できない場合、Claude Code は修正する必要がある変数を名前に含むエラーで起動を停止します。

リクエストを送信する前に設定が読み込まれたことを確認するには、デバッグログを有効にして Claude Code を起動します。

```bash theme={null}
claude --debug
```

デバッグ出力はターミナルではなく `~/.claude/debug/<session-id>.txt` に、または `--debug-file <path>` で設定したパスに出力されます。ログで、各ファイルが読み込まれたことを確認する行を探します。

```text theme={null}
CA certs: Appended extra certificates from NODE_EXTRA_CA_CERTS (/etc/ssl/certs/corp-ca.pem)
mTLS: Loaded client certificate from CLAUDE_CODE_CLIENT_CERT
mTLS: Loaded client key from CLAUDE_CODE_CLIENT_KEY
```

Claude Code がこれらのファイルの 1 つを読み込めない場合、ログには代わりに `Failed to read` または `Failed to load` の行と理由が表示されます。

対話型セッションで `/status` を実行して、これらの行を確認することもできます。

* **Proxy**: アクティブなプロキシ URL を表示し、解析できない値を無効で無視とマークします。
* **mTLS client cert** および **mTLS client key**: ファイルが読み込まれた場合にのみ表示されるため、行がない場合は読み込みが失敗し、デバッグログに理由が記載されています。
* **Additional CA cert(s)**: ファイルが読み込まれたことを確認せずに `NODE_EXTRA_CA_CERTS` パスを表示するため、デバッグログでこれを確認します。

## バックグラウンドエージェントにネットワーク設定を適用する

[バックグラウンドエージェント](/docs/ja/agent-view)は、それらをディスパッチしたターミナルの内部では実行されません。ユーザーごとのスーパーバイザープロセスがオンデマンドで起動し、シェルより長く存続し、すべての `claude agents`、`--bg`、および `/background` セッションをホストします。[バックグラウンドセッションがどのようにホストされるか](/docs/ja/agent-view#how-background-sessions-are-hosted)を参照してください。これにより、このページの設定がこれらのセッションに到達する方法が変わります。

### シェルではなく設定でネットワーク変数を設定する

スーパーバイザーはすべてのターミナルで共有される 1 つのプロセスです。これは最初にそれを起動したシェルの環境を継承します。プロキシ、CA パス、または mTLS 変数をシェルにのみエクスポートする場合、そのシェルがスーパーバイザーをコールドスタートしたときはバックグラウンドエージェントに到達しますが、別のシェルが起動した場合は静かに到達しません。

代わりに、`~/.claude/settings.json` の `env` ブロックまたは[マネージド設定](/docs/ja/settings)に同じ変数を配置してください。このページのすべての変数をそこで設定でき、設定はすべてのマシンのすべてのバックグラウンドセッションに到達する唯一の設定です。

### 企業ランチャーを設定として構成する

一部の組織では、すべての Claude Code プロセスが、サンドボックス化、ネットワーク制御、または認証情報インジェクションを適用する企業ランチャーを通じて起動することが必要です。スーパーバイザーとそのワーカーは、`PATH` で `claude` を検索するのではなく、固定パスから Claude Code を起動するため、すべてのバックグラウンドエージェントは `PATH` の前に配置したラッパーをバイパスします。

[`processWrapper`](/docs/ja/settings-reference#processwrapper) 設定を設定して、スーパーバイザー、そのワーカー、および[ランチャーがカバーするもの](/docs/ja/corporate-launcher#what-the-launcher-covers)の下にリストされている他のバックグラウンドプロセスをランチャーでプレフィックスします。同等の [`CLAUDE_CODE_PROCESS_WRAPPER`](/docs/ja/env-vars) 環境変数は、両方が設定されている場合に優先され、同じルールの対象となります。マネージド設定または `~/.claude/settings.json` を通じて配信し、シェルエクスポートではありません。[企業ランチャーの背後で Claude Code を実行する](/docs/ja/corporate-launcher)は、ランチャーが満たす必要があるコントラクト、それが到達するもの、到達しないもの、およびロールアウト方法をカバーしています。

> [!NOTE]
>
> 既に実行中のスーパーバイザーは、起動時に開始した起動設定を保持します。ランチャー設定をデプロイした後、[`claude daemon stop --any`](/docs/ja/agent-view#the-supervisor-process) を実行して、次の `claude agents` または `--bg` がそれを尊重するスーパーバイザーを起動するようにします。

## ストリーミングのアイドルウォッチドッグ

Claude Code は、ストリーミング中のモデルの応答が途絶えたときにそれを中止する 4 つの独立したタイマーを実行します。これにより、切断された接続はハングしたままにならず、失敗して再試行されます。レスポンスヘッダーがまったく返されないリクエストは、次の 2 つのいずれかの形で終了します。

* **ファーストバイト期限が実行される接続の場合**: 最初の試行はその期限で終了します。期限を変更するには、`CLAUDE_STREAM_FIRST_BYTE_TIMEOUT_MS` を設定します。再試行の待機時間については、[No response from API](/docs/ja/errors#no-response-from-api) を参照してください。
* **その他の接続の場合**: ボディアイドルタイムアウトが発動する 5〜6 分後にリクエストが終了します（このタイムアウトをオフにしている場合を除く）。より早く終了させるには、`API_TIMEOUT_MS` を小さくします。

| タイマー | 中止する条件 | 実行される接続 | デフォルトのタイムアウト |
| :- | :- | :- | :- |
| ファーストバイト期限 | Claude Code がリクエストを送信した後、レスポンスヘッダーが届かない | 直接の Anthropic API と [Claude Platform on AWS](/docs/ja/claude-platform-on-aws)（HTTPS プロキシ経由を含む）。ただし、`ANTHROPIC_BASE_URL` または `ANTHROPIC_AWS_BASE_URL` によって[ゲートウェイ](/docs/ja/gateways)経由でルーティングされる場合は除く。Amazon Bedrock では `CLAUDE_ENABLE_BYTE_WATCHDOG_BEDROCK=1` でオプトイン。Google Cloud の Agent Platform、Microsoft Foundry、および [Claude apps gateway](/docs/ja/claude-apps-gateway) セッションでは実行されない | 直接の Anthropic API では 180 秒、それ以外では 300 秒。これにリクエストボディ 32KB ごとに 1 秒が加算される |
| イベントレベルのウォッチドッグ | レスポンスイベントがパースされない。Amazon Bedrock 以外の接続でバイトレベルのウォッチドッグが実行されている場合は、キープアライブの ping を含む到着バイトでもこのウォッチドッグがリセットされる（パースされたイベントがない状態で最大約 5 分まで） | すべてのプロバイダー | 300 秒 |
| バイトレベルのウォッチドッグ | SSE のキープアライブ ping を含め、ワイヤー上にバイトが届かない | 直接の Anthropic API、[Claude Platform on AWS](/docs/ja/claude-platform-on-aws)、および[ゲートウェイ](/docs/ja/gateways)接続（カスタムの `ANTHROPIC_BASE_URL` を含む）。Amazon Bedrock の `vnd.amazon.eventstream` レスポンスでは `CLAUDE_ENABLE_BYTE_WATCHDOG_BEDROCK=1` でオプトイン。Google Cloud の Agent Platform や Microsoft Foundry では実行されない | 直接の Anthropic API では 180 秒。Claude Platform on AWS、Amazon Bedrock、[Claude apps gateway](/docs/ja/claude-apps-gateway) セッション、およびカスタムの `ANTHROPIC_BASE_URL` 経由では 300 秒 |
| ボディアイドルタイムアウト | レスポンスヘッダーの待機時間を含め、5 分間バイトが届かない | 直接の Anthropic API、Claude Platform on AWS、`CLAUDE_ENABLE_BYTE_WATCHDOG_BEDROCK=1` が設定された Amazon Bedrock 以外のプロバイダー（[`API_FORCE_IDLE_TIMEOUT`](/docs/ja/env-vars) で変更されない限り） | 5 分 |

`CLAUDE_ENABLE_BYTE_WATCHDOG_BEDROCK=1` を設定すると、Bedrock ではバイトレベルのウォッチドッグがボディアイドルタイムアウトと併用されるのではなく、ボディアイドルタイムアウトを置き換えます。その場合、`CLAUDE_STREAM_IDLE_TIMEOUT_MS` は、Claude Code が接続を切断済みとみなすまでに Bedrock のストリームが無通信のままでいられる時間も、以下に示す制限の範囲内で制御します。Bedrock では、到着バイトによってイベントレベルのウォッチドッグがリセットされることは引き続きありません。このとき、デバッグログが有効であれば、各 Bedrock ストリームは `wire-heartbeat: _chunkTimes absent` で始まるデバッグメッセージをログに記録します。

タイマーは次の変数で設定します。各変数の詳細は[環境変数リファレンス](/docs/ja/env-vars)を参照してください。

* `CLAUDE_ENABLE_STREAM_WATCHDOG` と `CLAUDE_ENABLE_BYTE_WATCHDOG` は、表に示した接続の範囲内で、対応するウォッチドッグを `1` で強制的にオン、`0` で強制的にオフにします。どちらの変数も、ウォッチドッグが対象としない接続タイプにまで適用範囲を広げることはありません。`CLAUDE_ENABLE_BYTE_WATCHDOG` を `0` に設定すると、ファーストバイト期限もオフになります。
* `CLAUDE_STREAM_IDLE_TIMEOUT_MS` は両方のウォッチドッグのタイムアウトを設定します。Claude Code は 5 分未満の値を 5 分に引き上げ、バイトレベルのウォッチドッグについては値の上限を 30 分とします。
* `CLAUDE_BYTE_STREAM_IDLE_TIMEOUT_MS` は、イベントレベルのウォッチドッグのタイムアウトを変更せずに、バイトレベルのウォッチドッグのタイムアウトを設定します。値は 10 秒から 30 分の範囲に制限され、そのウォッチドッグについては `CLAUDE_STREAM_IDLE_TIMEOUT_MS` より優先されます。
* `CLAUDE_STREAM_FIRST_BYTE_TIMEOUT_MS` はファーストバイト期限を直接設定します。未設定の場合、Claude Code はバイトレベルのウォッチドッグのタイムアウトを使用するため、`CLAUDE_STREAM_IDLE_TIMEOUT_MS` と `CLAUDE_BYTE_STREAM_IDLE_TIMEOUT_MS` によって期限も変わります。値の制限範囲、アップロード分の加算、`API_TIMEOUT_MS` による上限、応答なしで中止された後に再試行が待機する時間については、[No response from API](/docs/ja/errors#no-response-from-api) を参照してください。
* `API_TIMEOUT_MS` はレスポンスヘッダーの待機時間を制限するもので、ヘッダー受信後に応答がストリーミングされる時間を制限するものではありません。Claude apps gateway セッションなど、ファーストバイト期限が実行されない場合は、応答のないリクエストをより早く再試行するために、この値を `300000`（5 分）未満に設定します。ただし、想定されるヘッダーの最長待機時間や最長の[非ストリーミングリクエスト](/docs/ja/errors#streaming-response-ended-before-any-complete-data-was-received)よりも大きい値にしてください。それより長い時間を要するリクエストは、再試行のたびに再びタイムアウトします。
* `API_FORCE_IDLE_TIMEOUT` を `0` に設定するとボディアイドルタイムアウトがオフになり、`1` に設定するとすべてのプロバイダーでオンになります。ウォッチドッグはこの設定とは独立して実行されるため、ストリームがウォッチドッグのしきい値より長く一時停止できるようにするには、ウォッチドッグのタイムアウトも引き上げるか無効にしてください。

ウォッチドッグが停止したストリームを中止すると、Claude Code はその中止をストリーム途中の失敗として扱い、表示される内容は応答がどこまで進んでいたかによって異なります。Claude Code はリクエストを再試行するかエラーでターンを終了するか、完了した出力を保持して[不完全な応答の通知](/docs/ja/errors#the-response-above-may-be-incomplete)を表示するか、ターンを通常どおり終了します。各結果がどの場合に当てはまるかは、[自動再試行](/docs/ja/errors#automatic-retries)を参照してください。

[非対話型セッション](/docs/ja/headless)、およびあらゆるセッションにおけるサブエージェントの応答では、Claude Code はまず、途中で切れた応答を続けるよう Claude にプロンプトを送る場合があります。それがいつ行われるか、またいつ通知が引き続き表示されるかについては、[その通知の項目](/docs/ja/errors#the-response-above-may-be-incomplete)を参照してください。

ファーストバイト期限が発動した場合は、応答がまだ始まっていないため、保持すべき部分的な出力はありません。Claude Code がリクエストを再送信する方法と、代わりにターンが終了する場合については、[No response from API](/docs/ja/errors#no-response-from-api) を参照してください。

## ネットワークアクセス要件

Claude Code は以下の URL へのアクセスが必要です。プロキシ設定とファイアウォールルールでこれらをホワイトリストに登録してください。特にコンテナ化された環境や制限されたネットワーク環境では重要です。初回実行時のセットアップ接続確認は、`api.anthropic.com` または `platform.claude.com` に到達できない場合、ここを指します。確認メッセージと復旧手順については、[Anthropic サービスに接続できない](/docs/ja/errors#unable-to-connect-to-anthropic-services)を参照してください。

| URL | 必要な用途 |
| - | - |
| `api.anthropic.com` | Claude API リクエスト（WebFetch の[ドメイン安全性チェック](/docs/ja/data-usage#webfetch-domain-safety-check)、機能フラグ取得、テレメトリイベントログを含む） |
| `claude.ai` | claude.ai アカウント認証 |
| `claude.com` | claude.ai アカウントサインインがブラウザで `claude.com` ページを開き、`claude.ai` にリダイレクトされます。事前承認された WebFetch ドキュメント検索も CLI からこのホストに到達します |
| `platform.claude.com` | Anthropic Console アカウント認証。OAuth トークン交換、更新、失効も claude.ai アカウントではこのホストに送信されるため、Console と claude.ai の両方のサインインに必要です |
| `sso.claude.com` | シングルサインオン（SSO）を使用する組織向けのブラウザサインインフローの一部。プロキシがこのホストをブロックすると、それらのサインインが失敗する可能性があります |
| `mcp-proxy.anthropic.com` | [claude.ai からの MCP コネクタ](/docs/ja/mcp#use-mcp-servers-from-claude-ai)（組織管理者が設定するコネクタを含む）。コネクタトラフィックはこのプロキシを経由してルーティングされます。コネクタは claude.ai 認証ユーザーではデフォルトで有効です。Claude Code がそれらを取得するのを停止するには、[`ENABLE_CLAUDEAI_MCP_SERVERS=false`](/docs/ja/env-vars) または [`disableClaudeAiConnectors`](/docs/ja/settings-reference#disableclaudeaiconnectors) 設定を設定してください |
| `downloads.claude.ai` | プラグイン実行ファイルダウンロード、ネイティブインストーラー、ネイティブ自動更新プログラム、更新バージョンチェック |
| `storage.googleapis.com` | `/plugin` に表示されるプラグインインストール数とメタデータ |
| `storage.googleapis.com` | 2.1.116 より前のバージョンのネイティブインストーラーとネイティブ自動更新プログラム |
| `registry.npmjs.org` | プラグインインストール（npm ソースプラグインパッケージの取得とプラグインの Node.js パッケージ依存関係のインストール）、`npx` で起動された MCP サーバー、および Claude Code 自体の npm と bun インストール用パッケージレジストリ |
| `bridge.claudeusercontent.com` | [Chrome の Claude](/docs/ja/chrome) 拡張機能 WebSocket ブリッジ |
| `*.frame.claudeusercontent.com` | [Artifact](/docs/ja/artifacts) コンテンツ読み取り。CLI は Claude がアーティファクトを開いたときにこのホストからアーティファクトのファイルを取得し、Artifact ツールがアカウントで[利用可能](/docs/ja/artifacts#availability)な場合のみです。ツールをオフにしてこの要件を削除するには、[`"enableArtifact": false`](/docs/ja/settings-reference#enableartifact) または [`CLAUDE_CODE_DISABLE_ARTIFACT=1`](/docs/ja/env-vars) を設定してください |
| `github.com` | GitHub ホスト型[プラグインマーケットプレイス](/docs/ja/plugins/overview)とプラグインのクローン（公式 Anthropic マーケットプレイスを含む）。HTTPS または SSH 経由。GitHub `owner/repo` ソースを HTTPS のみでクローンするには、[`CLAUDE_CODE_PLUGIN_PREFER_HTTPS=1`](/docs/ja/env-vars) を設定してください |
| `raw.githubusercontent.com` | [`/release-notes`](/docs/ja/commands) のチェンジログフィード。対話型セッションでは、Claude Code はキャッシュされたチェンジログがまだ実行中のバージョンをカバーしていない場合（更新後の初回起動など）、スタートアップ時にバックグラウンドでそれを取得します。非対話型およびクラウドセッションは決してそれを取得しません |
| `*-review.googlesource.com` | `googlesource.com` チェックアウトでの Gerrit 変更検索。Claude Desktop Code タブセッションが [信頼済み](/docs/ja/permissions#project-allow-rules-and-workspace-trust)チェックアウトで開始または再開され、その `origin` が `googlesource.com` ホストである場合、Claude Code はそのホストの `-review` サーバーに匿名で、HEAD の `Change-Id` に一致するオープン変更を 1 回（開始または再開ごと）要求します。他のセッションタイプはこの検索をスキップし、他の Gerrit ホストには接続されません。オプション：[`CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC`](/docs/ja/env-vars) で無効化 |
| `http-intake.logs.us5.datadoghq.com` | 運用テレメトリイベント。CLI が Anthropic API を直接使用する場合にのみ送信され、Amazon Bedrock、Google Cloud の Agent Platform、Microsoft Foundry では送信されません。オプション：[`DISABLE_TELEMETRY`](/docs/ja/data-usage#telemetry-services) または `DO_NOT_TRACK` で無効化 |
| `browser-intake-us5-datadoghq.com` | 運用エラーレポート。CLI が Anthropic API を直接使用し、サーバー側のロールアウトゲートがそれらを有効にする場合に送信されます。オプション：`DISABLE_ERROR_REPORTING` または `DISABLE_TELEMETRY` で無効化。[テレメトリサービス](/docs/ja/data-usage#telemetry-services)を参照してください |
| `formulae.brew.sh` | Homebrew インストールでのバージョンチェック更新。他のインストール方法はこのホストに接続しません |
| `code.claude.com` | 組み込みの claude-code-guide エージェントによる Claude Code ドキュメント検索と事前承認された WebFetch リクエスト。このホストをブロックするとドキュメント検索のみに影響します |

npm または独自のバイナリ配布を通じて Claude Code をインストールする場合、エンドユーザーはネイティブインストーラーと自動更新プログラムの `downloads.claude.ai` の使用は不要ですが、npm と bun インストールは組織がミラーしない限り、パッケージレジストリ `registry.npmjs.org` が必要です。テーブル内の他の用途はインストール方法に関係なく適用されます。

2 つの Datadog インテークホストはオプションの運用テレメトリのみを実行し、[`CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC`](/docs/ja/env-vars) を設定するとその両方が無効になります。サードパーティプロバイダーのセッションは、プラットフォームが [`CLAUDE_CODE_PROVIDER_MANAGED_BY_HOST`](/docs/ja/env-vars) を設定し、テレメトリメトリクスがデフォルトでオンになっている場合でも、これらのホストに送信されません。Claude Code が送信するすべてのもの、およびホワイトリストを最終化する前にそれを無効にする方法については、[テレメトリサービス](/docs/ja/data-usage#telemetry-services)を参照してください。

[Amazon Bedrock](/docs/ja/amazon-bedrock)、[Google Cloud の Agent Platform](/docs/ja/google-vertex-ai)、[Microsoft Foundry](/docs/ja/microsoft-foundry)、またはサインイン済みの [Claude apps gateway](/docs/ja/claude-apps-gateway) セッションを使用する場合、モデルトラフィックと認証は `api.anthropic.com`、`claude.ai`、または `platform.claude.com` ではなく、プロバイダーまたはゲートウェイに送信されます。WebFetch ツールは、[設定](/docs/ja/settings)で `skipWebFetchPreflight: true` を設定しない限り、[ドメイン安全性チェック](/docs/ja/data-usage#webfetch-domain-safety-check)のために `api.anthropic.com` を呼び出します。

[`ANTHROPIC_BASE_URL`](/docs/ja/llm-gateway-connect#set-the-base-url-and-credential) を使用して [LLM ゲートウェイ](/docs/ja/llm-gateway)を経由してルーティングする場合、[高速モード](/docs/ja/fast-mode)の可用性チェックはゲートウェイベース URL ではなく `api.anthropic.com` を呼び出します。チェックは設定された HTTP プロキシを尊重するため、ネットワークブロックが原因の場合、プロキシ内の `api.anthropic.com` のホワイトリストエントリが修正です。ネットワークブロックはホストがプロキシを通じても到達不可能な場合にのみチェックに失敗し、高速モードは接続エラーを報告します。チェックがゲートウェイ発行の認証情報を提示し、Anthropic がそれを拒否する場合も同じ接続エラーが表示されます。ホワイトリストはそこでは役に立ちません。何もブロックされていないためです。[プロキシと LLM ゲートウェイの背後で高速モードを使用する](/docs/ja/fast-mode#use-fast-mode-behind-proxies-and-llm-gateways)を参照して、それを復元する変数を確認してください。

### 組織 IP ホワイトリストとプロキシ出力

組織で Claude に対して [IP ホワイトリスト](https://support.claude.com/en/articles/13200993-restrict-access-to-claude-with-ip-allowlisting)が有効になっている場合、`bridge.claudeusercontent.com` を `claude.ai` および `api.anthropic.com` と同じプロキシ出力を経由してルーティングしてください。たとえば、同じ Zscaler アプリセグメントまたは Netskope ステアリングポリシーに配置することで実現できます。そのようにルーティングできない場合は、プロキシがそのホストに使用する出力アドレスを組織の IP ホワイトリストに追加してください。ただし、そのアドレスが組織専用の場合のみです。共有プロキシ出力範囲は、プロキシベンダーの他の顧客も許可します。

Anthropic は、到着元のアドレスを使用して、組織の IP ホワイトリストに対して `bridge.claudeusercontent.com` への接続をチェックします。プロキシがそのホストのトラフィックを、そのホワイトリストにないアドレスを通じて送信する場合、Claude Code の残りの部分は機能していても、[Chrome の Claude](/docs/ja/chrome) 拡張機能に接続できません。

### GitHub ホワイトリストとファイアウォール

Anthropic ホスト環境での [Web 上の Claude Code](/docs/ja/claude-code-on-the-web) と [Code Review](/docs/ja/code-review) は Anthropic 管理インフラストラクチャからリポジトリに接続します。[自己ホスト環境](/docs/ja/self-hosted-environments)のセッションはネットワーク内から接続します。ただし、ランナーが [Anthropic git プロキシ](/docs/ja/self-hosted-environments-deploy#use-the-anthropic-git-proxy)にオプトインする場合は除きます。これは Anthropic 側から取得します。

GitHub Enterprise Cloud 組織が IP アドレスでアクセスを制限している場合、[インストール済み GitHub Apps の IP ホワイトリスト継承を有効にし](https://docs.github.com/en/enterprise-cloud@latest/organizations/keeping-your-organization-secure/managing-security-settings-for-your-organization/managing-allowed-ip-addresses-for-your-organization#allowing-access-by-github-apps)、Anthropic の[アウトバウンド IP アドレス](https://platform.claude.com/docs/en/api/ip-addresses#outbound-ip-addresses)の[ホワイトリストエントリを追加](https://docs.github.com/en/enterprise-cloud@latest/organizations/keeping-your-organization-secure/managing-security-settings-for-your-organization/managing-allowed-ip-addresses-for-your-organization#adding-an-allowed-ip-address)してください。継承は Claude GitHub App がインストールとして行うリクエストのみをカバーし、ユーザーの代わりに行うリクエストはカバーしません。他のファイアウォールについては、[Anthropic API IP アドレス](https://platform.claude.com/docs/en/api/ip-addresses)を参照してください。

ファイアウォールの背後にある自己ホスト [GitHub Enterprise Server](/docs/ja/github-enterprise-server) インスタンスの場合、Anthropic の[アウトバウンド IP アドレス](https://platform.claude.com/docs/en/api/ip-addresses#outbound-ip-addresses)をホワイトリストに登録して、Anthropic インフラストラクチャが GHES ホストに到達してリポジトリをクローンし、レビューコメントを投稿できるようにしてください。[自己ホスト環境](/docs/ja/self-hosted-environments-deploy#configure-git)のセッションはネットワーク内から GHES ホストに到達するため、その露出は Anthropic ホストセッション、リポジトリピッカーなどのホスト前セッションフロー、および [Anthropic git プロキシ](/docs/ja/self-hosted-environments-deploy#use-the-anthropic-git-proxy)にオプトインする自己ホストランナーにのみ適用されます。これは Anthropic 側から取得します。[SCM コネクタ](/docs/ja/self-hosted-environments-reference#scm-connector-flags)は利用できないため、ホスト前セッションフローはネットワーク内でのみルーティング可能な GHES ホストに到達できません。

### デスクトップと claude.ai

前述のテーブルはスタンドアロン CLI をカバーしています。Claude Desktop アプリと browser の claude.ai は、アプリケーションコードとユーザーコンテンツを追加の Anthropic CDN ホストから読み込みます。これには `assets-proxy.anthropic.com` と、これらのアプリで [artifacts](/docs/ja/artifacts) を提供する他の `*.claudeusercontent.com` オリジンが含まれます。`claude.ai` を許可しながらこれらのホストをブロックすると、エラーではなく空白ページが表示されます。Desktop ページの [ネットワークアクセス要件](/docs/ja/desktop#network-access-requirements)を参照してください。

Claude Desktop と claude.ai は、一部のコネクタが提供する [MCP Apps](https://claude.com/docs/connectors/building/mcp-apps/getting-started) など、会話内の一部のツール結果をインタラクティブなウィジェットとしてレンダリングすることもあります。これらのウィジェットは `claudemcpcontent.com` の生成されたサブドメインから読み込まれるため、ワイルドカードをそのまま残して `*.claudemcpcontent.com` を許可してください。これをブロックしても、アプリの残りの部分は引き続き機能しますが、これらのウィジェットは読み込まれません。

#### アーティファクトのフォントとライブラリ用のサードパーティホスト

[Google Fonts](/docs/ja/artifacts#improve-the-visual-design) からタイプフェイスを読み込む [artifact](/docs/ja/artifacts) は、`fonts.googleapis.com` と `fonts.gstatic.com` もリクエストします。両方のホストはオプションです。それらをブロックすると、artifacts はフォールバックタイプフェイスでレンダリングされます。フォントリクエストが即座に失敗するように、高速拒否でブロックしてください。ページの最初のレンダリングを遅延させるのではなく。

Artifacts は React やチャートパッケージなどの JavaScript ライブラリを `cdnjs.cloudflare.com`、`cdn.jsdelivr.net`、`cdn.tailwindcss.com`、`code.jquery.com`、および `unpkg.com` から読み込むことができ、他の外部ホストからは読み込めません。これらのホストをブロックすると、ライブラリに依存する artifact の部分は機能しません。ブロックされたフォントとは異なり、ブロックされたライブラリにはフォールバックがありません。ここでも高速拒否でブロックしてください。ブロックされたライブラリリクエストが即座に失敗するように、タイムアウトするまでハングするのではなく。

## 追加リソース

* [設定ファイルと優先順位](/docs/ja/settings)
* [環境変数リファレンス](/docs/ja/env-vars)
* [トラブルシューティングガイド](/docs/ja/troubleshooting)
