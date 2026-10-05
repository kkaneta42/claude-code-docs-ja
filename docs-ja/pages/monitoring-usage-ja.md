> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# 監視

> Claude Code の OpenTelemetry を有効にして設定する方法を学びます。

OpenTelemetry (OTel) を通じてテレメトリデータをエクスポートすることで、組織全体で Claude Code の使用状況、コスト、ツールアクティビティを追跡します。Claude Code はメトリクスを標準メトリクスプロトコル経由で時系列データとしてエクスポートし、イベントをログ/イベントプロトコル経由でエクスポートし、オプションで [トレースプロトコル](#traces-beta)経由で分散トレースをエクスポートします。

<h2 id="quick-start">
  クイックスタート
</h2>

環境変数を使用して OpenTelemetry を設定します:

```bash theme={null}
# 1. テレメトリを有効にする
export CLAUDE_CODE_ENABLE_TELEMETRY=1

# 2. エクスポーターを選択する (両方はオプション - 必要なものだけを設定してください)
export OTEL_METRICS_EXPORTER=otlp       # オプション: otlp、prometheus、console、none
export OTEL_LOGS_EXPORTER=otlp          # オプション: otlp、console、none

# 3. OTLP エンドポイントを設定する (OTLP エクスポーター用)
export OTEL_EXPORTER_OTLP_PROTOCOL=grpc
export OTEL_EXPORTER_OTLP_ENDPOINT=http://localhost:4317

# 4. 認証を設定する (必要な場合)
export OTEL_EXPORTER_OTLP_HEADERS="Authorization=Bearer your-token"

# 5. デバッグ用: エクスポート間隔を短縮し、本番環境での使用に向けてリセットしてください
export OTEL_METRIC_EXPORT_INTERVAL=10000  # 10 秒 (デフォルト: 60000ms)
export OTEL_LOGS_EXPORT_INTERVAL=5000     # 5 秒 (デフォルト: 5000ms)

# 6. Claude Code を実行する
claude
```

メトリクスをエクスポートするセットアップを検証するには、バックエンドで `claude_code.session.count` メトリクスを確認してください。Claude Code はセッション開始時にこのメトリクスを出力します。ログのみのセットアップを検証するには、プロンプトを送信して `claude_code.user_prompt` イベントを確認してください。

何も到着しない場合は、`claude --debug-file <path>` を使用して Claude Code を起動し、そのパスに書き込まれるログを確認してください。Claude Code は、設定したエクスポーターからの失敗を `[3P telemetry]` エラーとして報告します。ここで 3P はサードパーティを意味します。`[Anthropic telemetry]` で始まる行は、[Anthropic の個別の運用テレメトリ](/docs/ja/data-usage#telemetry-services)について説明しており、セットアップの問題を示していません。

完全な設定オプションについては、[OpenTelemetry 仕様](https://github.com/open-telemetry/opentelemetry-specification/blob/main/specification/protocol/exporter.md#configuration-options)を参照してください。

<h2 id="administrator-configuration">
  管理者設定
</h2>

管理者は、[管理設定ファイル](/docs/ja/managed-settings#delivery-mechanisms)を通じてすべてのユーザーの OpenTelemetry 設定を設定できます。設定がどのように適用されるかについては、[設定の優先順位](/docs/ja/settings#settings-precedence)を参照してください。

管理設定の設定例：

```json theme={null}
{
  "env": {
    "CLAUDE_CODE_ENABLE_TELEMETRY": "1",
    "OTEL_METRICS_EXPORTER": "otlp",
    "OTEL_LOGS_EXPORTER": "otlp",
    "OTEL_EXPORTER_OTLP_PROTOCOL": "grpc",
    "OTEL_EXPORTER_OTLP_ENDPOINT": "http://collector.example.com:4317",
    "OTEL_EXPORTER_OTLP_HEADERS": "Authorization=Bearer example-token"
  }
}
```

Claude Desktop アプリでは、Code タブセッションは[各種 Desktop セッションに到達する](/docs/ja/desktop#managed-settings)ソースからこれらの管理設定を読み込みます。管理コンソールの[データとプライバシー設定](https://claude.ai/admin-settings/data-privacy-controls)の**監視**下にある Cowork の OpenTelemetry フォームは Cowork セッションのみに適用されるため、ターミナル CLI も Code タブも、そこで設定したコレクターにはエクスポートしません。

Claude Code は、リポジトリの `.claude/settings.json` と `.claude/settings.local.json` の [OpenTelemetry エクスポーター変数](/docs/ja/settings-reference#variables-claude-code-ignores-in-env)を無視するため、リポジトリはそれらを使用してテレメトリをオンにしたり、送信先を選択したり、コンテンツをキャプチャしたりすることはできません。管理設定で設定するか、各開発者がシェルまたは `~/.claude/settings.json` で設定してください。リポジトリは、`OTEL_LOGS_EXPORTER` などのエクスポーターセレクターを `none` に設定することでシグナルをオフにすることはできますが、管理設定、`--settings` ファイル、または Claude Code を起動する環境がその変数を設定している場合を除きます。

Claude Code は、Bash ツール、フック、MCP サーバー、言語サーバーを含む、生成するサブプロセスに `OTEL_*` 環境変数を渡しません。OpenTelemetry でインストルメント化されたアプリケーションを Bash ツール経由で実行する場合、Claude Code のエクスポーターエンドポイントまたはヘッダーを継承しないため、そのアプリケーションが独自のテレメトリをエクスポートする必要がある場合は、コマンド内でこれらの変数を直接設定してください。

<h3 id="how-managed-settings-lock-the-otlp-destination">
  管理設定が OTLP 宛先をロックする方法
</h3>

管理設定で `OTEL_EXPORTER_OTLP_*` 変数を設定すると、Claude Code は起動時に競合する開発者設定の変数を削除し、デバッグログに警告をログに記録します。削除される内容は、設定する変数によって異なります：

* **エンドポイント**：`OTEL_EXPORTER_OTLP_ENDPOINT` を設定すると、Claude Code はすべての開発者設定のシグナル別エンドポイントを削除します。開発者は 1 つのシグナルを別のコレクターにポイントできないため、管理設定でシグナル別エンドポイント変数も設定する必要はありません。
* **プロトコル**：`OTEL_EXPORTER_OTLP_PROTOCOL` を設定すると、Claude Code はすべての開発者設定のシグナル別プロトコルを削除します。
* **認証情報**：`OTEL_EXPORTER_OTLP_HEADERS`、`OTEL_EXPORTER_OTLP_CLIENT_KEY`、または `OTEL_EXPORTER_OTLP_CLIENT_CERTIFICATE` を設定すると、Claude Code はその変数の開発者設定のシグナル別バージョンと、すべての開発者設定のエンドポイント変数（汎用またはシグナル別）を削除します。これらの認証情報が管理設定で選択されていないコレクターに到達するのを防ぐためです。
* **エクスポーターセレクター**：`OTEL_METRICS_EXPORTER`、`OTEL_LOGS_EXPORTER`、およびベータ版の `OTEL_TRACES_EXPORTER` は通常のキーごとの優先順位に従います。開発者の設定はシグナルを無効にするか、コンソールエクスポーターに切り替えることができるため、ロックが必要な場合は管理設定でセレクターも設定してください。[管理ソース](/docs/ja/managed-settings#precedence-within-the-managed-tier)全体で、`OTEL_LOGS_EXPORTER` は[テレメトリユニット](/docs/ja/server-managed-settings#per-key-exceptions-across-managed-sources)に従い、他の 2 つのセレクターはキーごとにマージされます。Claude Code v2.1.223 以降が必要です。
* **ベータ版トレーシングエンドポイント**：[詳細ベータ版トレーシング](#traces-beta)がアクティブな場合、Claude Code はログとトレースをログおよびトレースエクスポーターを通じてではなく `BETA_TRACING_ENDPOINT` にエクスポートします。したがって、Claude Code は以下の管理設定のいずれかがシグナルの宛先を決定するたびに、開発者設定の `BETA_TRACING_ENDPOINT` を削除します：

  * 汎用またはログ/トレースエンドポイントまたは認証情報
  * [`otelHeadersHelper`](/docs/ja/settings-reference#otelheadershelper)
  * `none`、`console`、または空に設定されたログまたはトレースエクスポーターセレクター。これらの値はシグナルをコレクターから外します
  * `CLAUDE_CODE_ENABLE_TELEMETRY` がオフ

  メトリクスのみのエンドポイントまたは認証情報は削除しません。v2.1.251 より前では、開発者設定の `BETA_TRACING_ENDPOINT` は、管理設定がコレクターをピン留めしている場合でも、詳細ベータ版トレーシングがエクスポートするログとトレースをリダイレクトしていました。

Claude Code は管理設定自体で設定したシグナル別変数を削除しないため、その変数をそこに設定することで 1 つのシグナルを別のコレクターにルーティングできます。[SIEM の例](#send-events-to-a-siem)がこれを行っています。そこでシグナル別認証情報を設定する場合、Claude Code はそのシグナルの開発者設定エンドポイントを削除します。

この削除動作は、テレメトリが配信される場所を変更するもので、Claude Code が収集する内容ではありません。

v2.1.217 より前では、すべての変数は独立してキーごとの設定優先順位に従っていたため、ユーザー設定またはシェルで設定されたシグナル固有のエンドポイントがそのシグナルを管理コレクターから離れた場所にリダイレクトしていました。

デスクトップアプリまたは[セルフホスト環境](/docs/ja/self-hosted-environments)ランナーが Claude Code を起動し、提供する環境で OTLP エンドポイントを指定する場合、Claude Code は同じ方法で宛先をピン留めします。ランナーのテレメトリ変数は、管理設定と同じように開発者設定の変数を削除します。Claude Code はランナー自体が設定した変数を削除しません。Claude Code v2.1.251 以降が必要です。

<h2 id="configuration-details">
  設定の詳細
</h2>

<h3 id="common-configuration-variables">
  共通の設定変数
</h3>

これらの変数は、すべてのデプロイに共通するエクスポーター、エンドポイント、エクスポート動作を設定します。

`OTEL_EXPORTER_OTLP_METRICS_ENDPOINT` のようなシグナルごとのエンドポイント変数またはプロトコル変数を設定すると、Claude Code はそのシグナルについて汎用の変数の代わりにそれを使用します。`OTEL_EXPORTER_OTLP_METRICS_HEADERS` のようなシグナルごとのヘッダー変数を設定すると、Claude Code はそのシグナルについて汎用の `OTEL_EXPORTER_OTLP_HEADERS` とマージします。

管理設定があるマシンで Claude Code が何を削除するかについては、[管理設定が OTLP の送信先をロックする仕組み](#how-managed-settings-lock-the-otlp-destination)を参照してください。

| 環境変数 | 説明 | 値の例 |
| - | - | - |
| `CLAUDE_CODE_ENABLE_TELEMETRY` | テレメトリ収集を有効にします（必須） | `1` |
| `OTEL_METRICS_EXPORTER` | メトリクスエクスポーターの種類（カンマ区切り）。無効にするには `none` を使用します | `console`, `otlp`, `prometheus`, `none` |
| `OTEL_LOGS_EXPORTER` | ログ/イベントエクスポーターの種類（カンマ区切り）。無効にするには `none` を使用します | `console`, `otlp`, `none` |
| `OTEL_EXPORTER_OTLP_PROTOCOL` | OTLP エクスポーターのプロトコル。すべてのシグナルに適用されます。Claude Code にはデフォルトのプロトコルがないため、有効にする `otlp` エクスポーターごとに、この変数またはシグナル固有のプロトコル変数を設定してください | `grpc`, `http/json`, `http/protobuf` |
| `OTEL_EXPORTER_OTLP_ENDPOINT` | すべてのシグナル向けの OTLP コレクターエンドポイント | `http://localhost:4317` |
| `OTEL_EXPORTER_OTLP_METRICS_PROTOCOL` | メトリクスのプロトコル。全般設定を上書きします | `grpc`, `http/json`, `http/protobuf` |
| `OTEL_EXPORTER_OTLP_METRICS_ENDPOINT` | OTLP メトリクスエンドポイント。全般設定を上書きします | `http://localhost:4318/v1/metrics` |
| `OTEL_EXPORTER_OTLP_LOGS_PROTOCOL` | ログのプロトコル。全般設定を上書きします | `grpc`, `http/json`, `http/protobuf` |
| `OTEL_EXPORTER_OTLP_LOGS_ENDPOINT` | OTLP ログエンドポイント。全般設定を上書きします | `http://localhost:4318/v1/logs` |
| `OTEL_EXPORTER_OTLP_HEADERS` | OTLP の認証ヘッダー | `Authorization=Bearer token` |
| `OTEL_EXPORTER_OTLP_METRICS_HEADERS` | メトリクスの認証ヘッダー。全般のヘッダーとマージされます | `Authorization=Bearer token` |
| `OTEL_EXPORTER_OTLP_LOGS_HEADERS` | ログの認証ヘッダー。全般のヘッダーとマージされます | `Authorization=Bearer token` |
| `OTEL_METRIC_EXPORT_INTERVAL` | エクスポート間隔（ミリ秒、デフォルト: 60000） | `5000`, `60000` |
| `OTEL_LOGS_EXPORT_INTERVAL` | ログのエクスポート間隔（ミリ秒、デフォルト: 5000） | `1000`, `10000` |
| `OTEL_LOG_USER_PROMPTS` | ユーザープロンプトの内容のログ記録を有効にします（デフォルト: 無効） | 有効にするには `1` |
| `OTEL_LOG_ASSISTANT_RESPONSES` | `assistant_response` イベントでのアシスタント応答テキストのログ記録を有効にします（デフォルト: 無効）。未設定の場合は `OTEL_LOG_USER_PROMPTS` の値にフォールバックします。Claude Code v2.1.193 以降が必要です | 有効にするには `1`、編集済みのままにするには `0` |
| `OTEL_LOG_TOOL_DETAILS` | ツールイベントとトレーススパン属性におけるツールパラメーターと入力引数のログ記録を有効にします。対象は Bash コマンド、MCP サーバー名とツール名、スキル名、ユーザーが作成したワークフロー名、ツール入力です。また、`user_prompt` イベントでのカスタムコマンド、プラグインコマンド、MCP コマンドの名前と、[コストおよびトークンのカウンター](#cost-counter)での実際のエージェント名、スキル名、プラグイン名、MCP サーバー名とツール名も有効にします（デフォルト: 無効）。Claude Desktop の組み込みサーバーについては、Claude Desktop が所有するセッションでは、このフラグがオフでも `tool_decision`/`tool_result` で `mcp_server_name`/`mcp_tool_name` が出力されます。この例外には Claude Code v2.1.214 以降が必要です | 有効にするには `1` |
| `OTEL_LOG_TOOL_CONTENT` | [`tool.output` スパンイベント](#tool-output-span-event)でのツールコンテンツのログ記録を有効にします（デフォルト: 無効）。スパン属性は[独自のゲート](#new-context-gates)のもとでツールコンテンツを保持します。[トレース](#traces-beta)が必要です。コンテンツはコンテンツ上限（デフォルトで 60 KB）で切り詰められます | 有効にするには `1` |
| `OTEL_LOG_MANAGED_SETTINGS` | 編集済みの管理設定と、編集前の設定の SHA-256 ダイジェストを[管理設定の解決](#managed-settings-resolved-event)イベントに追加します（デフォルト: 無効）。プロジェクト設定またはローカル設定の値ではオンになりません。Claude Code v2.1.274 以降が必要です | 有効にするには `1` |
| `OTEL_LOG_RAW_API_BODIES` | Anthropic Messages API のリクエストとレスポンスの完全な JSON を `api_request_body` / `api_response_body` ログイベントとして出力します（デフォルト: 無効）。ボディには会話履歴全体が含まれます。これを有効にすることは、`OTEL_LOG_USER_PROMPTS`、`OTEL_LOG_TOOL_DETAILS`、`OTEL_LOG_TOOL_CONTENT` によって公開されるすべての内容への同意を意味します | コンテンツ上限（デフォルトで 60 KB）で切り詰められたインラインのボディには `1`、切り詰められていないボディをディスクに保存し、イベントに `body_ref` ポインターを含めるには `file:<dir>` |
| `CLAUDE_CODE_OTEL_CONTENT_MAX_LENGTH` | コンテンツ上限: モデルの応答、ツールコンテンツ、システムプロンプト、生の API ボディなど、コンテンツを保持する属性の最大長（切り詰めマーカーを含む、UTF-16 コード単位、デフォルト: 61440、つまり 60 KB）。デフォルト値は属性値を 64 KB に制限するバックエンドに合わせたサイズです。バックエンドがより大きな値を受け付ける場合にのみ引き上げるか、テレメトリ量を削減するために引き下げてください。OpenTelemetry SDK の属性上限である `OTEL_ATTRIBUTE_VALUE_LENGTH_LIMIT` またはその logrecord 版や span 版のいずれかがより小さく設定されている場合、Claude Code はその小さい値で切り詰め、`[TRUNCATED ...]` マーカーが SDK の上限内に収まるようにします。Claude Code v2.1.214 以降が必要です | `262144` |
| `OTEL_EXPORTER_OTLP_METRICS_TEMPORALITY_PREFERENCE` | メトリクスのテンポラリティ設定（デフォルト: `delta`）。バックエンドが累積テンポラリティを想定している場合は `cumulative` に設定します | `delta`, `cumulative` |
| `CLAUDE_CODE_OTEL_HEADERS_HELPER_DEBOUNCE_MS` | 動的ヘッダーの更新間隔（デフォルト: 1740000ms / 29 分） | `900000` |

`http/protobuf` および `http/json` プロトコルでは、Claude Code は各エクスポートリクエストを `Content-Length` ヘッダー付きで送信します。v2.1.212 より前は、v2.1.191 以降の Claude Code バージョンがこれらのリクエストをチャンク転送エンコーディングで送信していたため、Azure Monitor など長さの宣言を必要とするエンドポイントは `411 Length Required` または `400` エラーでこれらを拒否していました。

<h3 id="mtls-authentication">
  mTLS 認証
</h3>

OTLP エクスポーターのクライアント証明書の設定方法は、そのシグナルで使用される OTLP プロトコル（`OTEL_EXPORTER_OTLP_PROTOCOL` またはシグナルごとの上書きで設定）によって異なります。同じ設定がメトリクス、ログ、トレースに適用されます。

| プロトコル | クライアント証明書の変数 | コレクターの CA を信頼する方法 |
| :- | :- | :- |
| `http/protobuf`, `http/json` | `CLAUDE_CODE_CLIENT_CERT`、`CLAUDE_CODE_CLIENT_KEY`、および必要に応じて `CLAUDE_CODE_CLIENT_KEY_PASSPHRASE`。[ネットワーク設定](/docs/ja/network-config#mtls-authentication)を参照してください | `NODE_EXTRA_CA_CERTS` |
| `grpc` | `OTEL_EXPORTER_OTLP_CLIENT_KEY` と `OTEL_EXPORTER_OTLP_CLIENT_CERTIFICATE`、またはシグナルごとに異なる証明書を使用する場合は `OTEL_EXPORTER_OTLP_METRICS_CLIENT_KEY` などのシグナルごとのバリアント | `OTEL_EXPORTER_OTLP_CERTIFICATE` |

`grpc` の場合、OpenTelemetry SDK が標準の OTLP 変数を直接読み取るため、シグナルごとのメトリクス変数を設定している既存の設定はそのまま動作します。管理設定があるマシンでは、Claude Code は起動時に[開発者が設定したシグナルごとの認証情報とエンドポイントを削除する場合があります](#how-managed-settings-lock-the-otlp-destination)。

<h3 id="metrics-cardinality-control">
  メトリクスのカーディナリティ制御
</h3>

以下の環境変数は、カーディナリティを管理するためにメトリクスに含める属性を制御します。

| 環境変数 | 説明 | デフォルト値 | 無効にする例 |
| - | - | - | - |
| `OTEL_METRICS_INCLUDE_SESSION_ID` | メトリクスに session.id 属性と、クラウドセッションでは ccr.session.id 属性を含めます | `true` | `false` |
| `OTEL_METRICS_INCLUDE_VERSION` | メトリクスに app.version 属性を含めます | `false` | `true` |
| `OTEL_METRICS_INCLUDE_ACCOUNT_UUID` | メトリクスに user.account\_uuid 属性と user.account\_id 属性を含めます | `true` | `false` |
| `OTEL_METRICS_INCLUDE_ENTRYPOINT` | メトリクスに app.entrypoint 属性を含めます | `false` | `true` |
| `OTEL_METRICS_INCLUDE_RESOURCE_ATTRIBUTES` | `OTEL_RESOURCE_ATTRIBUTES` のキーをメトリクスのデータポイントの属性として含めます | `true` | `false` |
| `OTEL_METRICS_INCLUDE_REPOSITORY` | メトリクスとイベントに `vcs.*` [リポジトリ識別属性](#repository-attributes)を含めます。Claude Code v2.1.269 以降が必要です | `false` | `true` |

一般に、カーディナリティが低いほどパフォーマンスが向上しストレージコストが下がりますが、分析用のデータの粒度は粗くなります。

<h3 id="traces-beta">
  トレース（ベータ）
</h3>

分散トレースは、各ユーザープロンプトと、それによってトリガーされる API リクエストおよびツール実行を結び付けるスパンをエクスポートするため、トレースバックエンドで 1 つのリクエスト全体を単一のトレースとして確認できます。

トレースはデフォルトでオフです。有効にするには、`CLAUDE_CODE_ENABLE_TELEMETRY=1` と `CLAUDE_CODE_ENHANCED_TELEMETRY_BETA=1` の両方を設定し、`OTEL_TRACES_EXPORTER` を設定してスパンの送信先を選択します。トレースは、エンドポイント、プロトコル、ヘッダー、[mTLS](#mtls-authentication) について[共通の OTLP 設定](#common-configuration-variables)を再利用します。管理設定があるマシンでは、Claude Code は起動時に[開発者が設定したシグナルごとの認証情報とエンドポイントを削除する場合があります](#how-managed-settings-lock-the-otlp-destination)。

| 環境変数 | 説明 | 値の例 |
| - | - | - |
| `CLAUDE_CODE_ENHANCED_TELEMETRY_BETA` | スパントレースを有効にします（必須）。`ENABLE_ENHANCED_TELEMETRY_BETA` も受け付けられます | `1` |
| `OTEL_TRACES_EXPORTER` | トレースエクスポーターの種類（カンマ区切り）。無効にするには `none` を使用します | `console`, `otlp`, `none` |
| `OTEL_EXPORTER_OTLP_TRACES_PROTOCOL` | トレースのプロトコル。`OTEL_EXPORTER_OTLP_PROTOCOL` を上書きします | `grpc`, `http/json`, `http/protobuf` |
| `OTEL_EXPORTER_OTLP_TRACES_ENDPOINT` | OTLP トレースエンドポイント。`OTEL_EXPORTER_OTLP_ENDPOINT` を上書きします | `http://localhost:4318/v1/traces` |
| `OTEL_EXPORTER_OTLP_TRACES_HEADERS` | トレースの認証ヘッダー。`OTEL_EXPORTER_OTLP_HEADERS` とマージされます | `Authorization=Bearer token` |
| `OTEL_TRACES_EXPORT_INTERVAL` | スパンのバッチエクスポート間隔（ミリ秒、デフォルト: 5000） | `1000`, `10000` |

スパンでは、ユーザープロンプトのテキスト、ツール入力の詳細、ツールコンテンツがデフォルトで編集（秘匿）されます。これらを含めるには、`OTEL_LOG_USER_PROMPTS=1`、`OTEL_LOG_TOOL_DETAILS=1`、`OTEL_LOG_TOOL_CONTENT=1` を設定します。

トレースが有効な場合、Bash と PowerShell のサブプロセスは、アクティブなツール実行スパンの W3C トレースコンテキストを含む `TRACEPARENT` 環境変数を自動的に継承します。これにより、`TRACEPARENT` を読み取るサブプロセスは自身のスパンを同じトレースの下に親付けでき、Claude が実行するスクリプトやコマンドを通じたエンドツーエンドの分散トレースが可能になります。

トレースが有効で、Claude Code が Anthropic API に直接接続されている場合、各モデルリクエストには `claude_code.llm_request` スパンのコンテキストに設定された W3C `traceparent` ヘッダーが付与され、API の `traceresponse` ヘッダーはスパンリンクとして記録されます。これらを組み合わせることで、準拠した中継サーバーを経由しても、Claude Code のクライアント側スパンがサーバー側のトレースに接続されます。送信される HTTP MCP リクエストにも同様に `traceparent` が付与されます。このヘッダーはサードパーティのプロバイダーには送信されません。

一部のプロキシは認識できないヘッダーを拒否するため、デフォルトでは、モデルリクエストと HTTP MCP リクエストの `traceparent` ヘッダーは、`ANTHROPIC_BASE_URL` が未設定であるか Anthropic API を指している場合にのみ送信されます。一貫性のため、サブプロセスの `TRACEPARENT` 変数も同じスイッチで制御されます。カスタムの `ANTHROPIC_BASE_URL` プロキシを介して Claude Code を実行していて、トレースコンテキストを伝播させたい場合は、`CLAUDE_CODE_PROPAGATE_TRACEPARENT=1` を設定してください。

Agent SDK および `-p` で開始した非対話型セッションでは、Claude Code は各インタラクションスパンの開始時に、自身の環境から `TRACEPARENT` と `TRACESTATE` も読み取ります。これにより、埋め込み側のプロセスがアクティブな W3C トレースコンテキストをサブプロセスに渡し、Claude Code のスパンを呼び出し元の分散トレースの子として表示させることができます。対話型セッションでは、CI やコンテナ環境の周囲の値を誤って継承しないよう、受信した `TRACEPARENT` は無視されます。

受信したトレースコンテキストは[イベント](#events)にも適用されます。`TRACEPARENT` が設定された Agent SDK および `-p` セッションでは、トレースエクスポーターが設定されていない場合でも、各 OTLP イベントログレコードにアプリケーションのトレースと結び付ける `trace_id` と `span_id` の値が付与されるため、ログバックエンドでイベントをトレースの他の部分と関連付けることができます。

インタラクションがアクティブな間に出力されたレコードには、Claude Code がスパンの非同期コンテキストの外で出力した場合（権限プロンプトのコールバック内や、起動中にバッファリングされて後でエクスポートされたレコードなど）でも、インタラクションスパンの ID が付与されます。アクティブなインタラクションスパンがない状態で出力されたレコードには、受信した `TRACEPARENT` の ID が直接付与されます。v2.1.214 より前は、スパンの非同期コンテキストの外で出力されたレコードには、スパンの ID ではなく受信した `TRACEPARENT` の ID が付与されていました。v2.1.212 より前は、アクティブなスパンの外で出力されたイベントレコードには `trace_id` も `span_id` も付与されていませんでした。

<h4 id="span-hierarchy">
  スパンの階層
</h4>

各ユーザープロンプトは `claude_code.interaction` ルートスパンを開始します。API 呼び出し、ツール呼び出し、フックの実行は、その子として記録されます。ツールスパンには独自の子スパンが 2 つあります。1 つは権限の決定を待つ時間、もう 1 つは実行自体の時間です。Agent ツールまたはレガシーの Task ツールがサブエージェントを起動すると、サブエージェントの API スパンとツールスパンは親の `claude_code.tool` スパンの下にネストされます。

```text theme={null}
claude_code.interaction
├── claude_code.llm_request
├── claude_code.hook                    (requires detailed beta tracing)
└── claude_code.tool
    ├── claude_code.tool.blocked_on_user
    ├── claude_code.tool.execution
    └── (Agent tool) subagent claude_code.llm_request / claude_code.tool spans
```

Agent SDK および `claude -p` セッションでは、環境に `TRACEPARENT` が設定されている場合、`claude_code.interaction` 自体が呼び出し元のスパンの子になります。

`PreToolUse` フックが[ツール呼び出しを延期](/docs/ja/hooks#defer-a-tool-call-for-later)すると、Claude Code は延期したターンのトレースコンテキストを保存します。セッションを再開してツールが再実行されると、そのツールのスパンは以前のターンのトレースに、そのターンの `claude_code.interaction` スパンの子として加わります。

<h4 id="span-attributes">
  スパン属性
</h4>

すべてのスパンには、[標準属性](#standard-attributes)に加えて、スパン名と一致する `span.type` 属性が付与されます。以下の表は、各スパンに設定される追加の属性を示しています。`llm_request`、`tool.execution`、`hook` スパンは、失敗を記録した場合に OpenTelemetry のステータス `ERROR` を設定します。その他のスパンは常にステータス `UNSET` で終了します。

**`claude_code.interaction`**

| 属性 | 説明 | ゲート |
| - | - | - |
| `user_prompt` | プロンプトのテキスト。ゲートが設定されていない限り、値は `<REDACTED>` です | `OTEL_LOG_USER_PROMPTS` |
| `user_prompt_length` | プロンプトの長さ（文字数） | |
| `interaction.sequence` | インタラクションの 1 から始まるカウンター。[`event.sequence`](#event-correlation-attributes) の説明のとおり、セッションごとではなく Claude Code プロセスごとにカウントされます | |
| `parent.source` | スパンがトレースの親をどのように取得したか。受信した `TRACEPARENT` の下に親付けされた場合は `env`、独自のトレースを開始した場合は `none` です。Claude Code v2.1.268 以降が必要です | |
| `interaction.duration_ms` | ターンの実時間 | |

**`claude_code.llm_request`**

| 属性 | 説明 | ゲート |
| - | - | - |
| `model` | モデル識別子 | |
| `gen_ai.system` | 常に `anthropic`。OpenTelemetry GenAI セマンティック規約 | |
| `gen_ai.request.model` | `model` と同じ値。OpenTelemetry GenAI セマンティック規約 | |
| `query_source` | リクエストを発行したサブシステム（`repl_main_thread` やサブエージェント名など） | `ENABLE_BETA_TRACING_DETAILED` |
| `query_source_safe` | `query_source` の値域を限定した形式。詳細ベータトレースが有効かどうかにかかわらず出力され、`repl_main_thread` や `agent.builtin.general-purpose` などの値を取ります。`:` は `.` になり、ユーザーが名前を付けたエージェントは `agent.custom` として表示されます。Claude Code v2.1.268 以降が必要です | |
| `agent_id` | リクエストを発行したサブエージェントまたはチームメイトの識別子。メインセッションでは付与されません | |
| `parent_agent_id` | このエージェントを起動したエージェントの識別子。メインセッションと、メインセッションから直接起動されたエージェントでは付与されません | |
| `workflow.run_id` | このエージェントを起動した [Workflow](/docs/ja/workflows) ツール実行の実行識別子（接頭辞 `wf_`）。ワークフローによって起動されていないエージェントでは付与されません | |
| `workflow.name` | このエージェントを起動したワークフローの名前。ゲートが設定されていない限り、ユーザーが作成した名前は `custom` に置き換えられます | `OTEL_LOG_TOOL_DETAILS` |
| `speed` | `fast` または `normal` | |
| `effort` | リクエストに適用された [effort レベル](/docs/ja/model-config#adjust-effort-level): `low`、`medium`、`high`、`xhigh`、または `max`。Claude Code が effort レベルを送信しない場合（effort をサポートしていないモデルの場合など）は付与されません。Claude Code v2.1.274 以降が必要です | |
| `llm_request.context` | 親スパンに応じて `interaction`、`tool`、または `standalone` | |
| `duration_ms` | 再試行を含む実時間 | |
| `ttft_ms` | 最初のトークンまでの時間（ミリ秒） | |
| `first_content_ms` | リクエスト開始から、成功した試行の最初のコンテンツブロックまでの時間（ミリ秒）。非ストリーミングパスにフォールバックしたリクエストでは付与されません。Claude Code v2.1.268 以降が必要です | |
| `input_tokens` | API の使用量ブロックから取得した入力トークン数。プロンプトキャッシュから読み取られたトークンや書き込まれたトークンは含まれず、それらは `cache_read_tokens` と `cache_creation_tokens` で報告されます | |
| `output_tokens` | 出力トークン数 | |
| `cache_read_tokens` | プロンプトキャッシュから読み取られたトークン | |
| `cache_creation_tokens` | プロンプトキャッシュに書き込まれたトークン | |
| `request_id` | API リクエスト ID。`request_id` [イベント相関属性](#event-correlation-attributes)と同じ値です | |
| `gen_ai.response.id` | `request_id` と同じ値。OpenTelemetry GenAI セマンティック規約 | |
| `client_request_id` | 最終試行のクライアント生成 `x-client-request-id` | |
| `attempt` | このリクエストで行われた試行の合計回数 | |
| `success` | `true` または `false` | |
| `status_code` | リクエストが失敗した場合の HTTP ステータスコード | |
| `error` | リクエストが失敗した場合のエラーメッセージ | |
| `error_class` | リクエストが失敗した場合の短いエラークラストークン（`api_timeout` や `server_overload` など）。Claude Code v2.1.268 以降が必要です | |
| `response.has_tool_call` | レスポンスにツール使用ブロックが含まれていた場合は `true` | |
| `stop_reason` | API レスポンスの `stop_reason`（`end_turn`、`tool_use`、`max_tokens`、`stop_sequence`、`pause_turn`、`refusal` など） | |
| `gen_ai.response.finish_reasons` | `stop_reason` と同じ値を文字列配列でラップしたもの。OpenTelemetry GenAI セマンティック規約 | |

各再試行は、`attempt` 属性と `client_request_id` 属性を持つ `gen_ai.request.attempt` スパンイベントとしても記録されます。

**`claude_code.tool`**

| 属性 | 説明 | ゲート |
| - | - | - |
| `tool_name` | ツール名 | |
| `tool_name_safe` | ユーザーが選んだ名前を含まない形式の `tool_name`。組み込みツール名はそのまま渡されます。MCP ツール名は `mcp_other` として表示されますが、`browser_*` という名前の `playwright` ツールなど、いくつかの固定された形式に一致するツール名はそのまま渡されます。Claude Code v2.1.268 以降が必要です | |
| `bash_command_class` | Bash ツールの場合: 固定リストに基づくコマンドの最初のプログラムのカテゴリ（`vcs` や `package_manager` など）。リスト外のプログラムの場合は `other`、行を解析できない場合は `unparsed` です。Claude Code v2.1.268 以降が必要です | |
| `bash_argv0` | Bash ツールの場合: コマンドの最初のプログラムが同じ固定リストに含まれている場合はそのプログラム（`git` や `npm` など）。リスト外のプログラムの場合は `other` です。Claude Code v2.1.268 以降が必要です | |
| `duration_ms` | 権限の待機と実行を含む実時間 | |
| `result_tokens` | ツール結果のおおよそのトークンサイズ | |
| `agent_id` | ツールを実行したサブエージェントまたはチームメイトの識別子。メインセッションでは付与されません | |
| `parent_agent_id` | このエージェントを起動したエージェントの識別子。メインセッションと、メインセッションから直接起動されたエージェントでは付与されません | |
| `workflow.run_id` | このエージェントを起動した Workflow ツール実行の実行識別子（接頭辞 `wf_`）。ワークフローによって起動されていないエージェントでは付与されません | |
| `workflow.name` | このエージェントを起動したワークフローの名前。ゲートが設定されていない限り、ユーザーが作成した名前は `custom` に置き換えられます | `OTEL_LOG_TOOL_DETAILS` |
| `tool_use_id` | この呼び出しに対するモデルの `tool_use` ブロック ID。[tool\_result](#tool-result-event) イベントと [tool\_decision](#tool-decision-event) イベント、およびフックのペイロードにある `tool_use_id` と一致するため、スパンをそれらのレコードと結合できます | |
| `gen_ai.tool.call.id` | `tool_use_id` と同じ値。OpenTelemetry GenAI セマンティック規約 | |
| `file_path` | Read、Edit、Write ツールの対象ファイルパス | `OTEL_LOG_TOOL_DETAILS` |
| `full_command` | Bash ツールのコマンド文字列 | `OTEL_LOG_TOOL_DETAILS` |
| `skill_name` | Skill ツールのスキル名 | `OTEL_LOG_TOOL_DETAILS` |
| `subagent_type` | Agent ツールまたはレガシーの Task ツールのサブエージェントタイプ | `OTEL_LOG_TOOL_DETAILS` |

<span id="tool-output-span-event" />**`claude_code.tool` の `tool.output` スパンイベント**

`OTEL_LOG_TOOL_CONTENT=1` を設定すると、Read と Bash の呼び出しで `claude_code.tool` スパンに `tool.output` スパンイベントを記録できます。Edit と Write の呼び出しでは、`OTEL_LOG_TOOL_DETAILS=1` も設定した場合にのみ記録されます。この変数はこれら 2 つのツールに限定されないため、他の箇所で追加される引数については[設定テーブルの該当行](#common-configuration-variables)を確認してください。

MCP ツール、WebFetch、WebSearch も、Claude Code v2.1.283 以降ではこのイベントを記録します。

Claude Code はツール呼び出しが正常に戻ったときにこのイベントを書き込むため、エラーを発生させた呼び出しは、ツールにかかわらず何も記録しません。正常に戻った呼び出しのうち、次の場合は `tool.output` イベントを記録しません。

* Read、Edit、Write、Bash、WebFetch、WebSearch、MCP ツール以外のツールの呼び出し
* ファイルのテキスト以外を返す Read（画像、PDF、内容が変更されていないファイルの再読み込みなど）
* `OTEL_LOG_TOOL_DETAILS=1` も設定していない場合の Edit または Write の呼び出し
* 待機中のメッセージが Claude に届くよう、実行中に Claude Code がバックグラウンドに移した WebFetch または WebSearch の呼び出し。後から届く結果も記録されません。Claude Code が呼び出しを移すタイミングについては、ターミナルの場合は[キューに入れた内容を Claude Code が送信するタイミング](/docs/ja/interactive-mode#when-claude-code-sends-what-you-queued)を、Agent SDK セッションの場合は [`priority` フィールド](/docs/ja/agent-sdk/typescript#sdkusermessage)を参照してください

このイベントには以下の属性が付与され、それぞれコンテンツ上限（デフォルトで 60 KB）で切り詰められます。`ゲート`は `OTEL_LOG_TOOL_CONTENT=1` に加えて属性に必要な変数を示します。Edit と Write については、その変数は属性ではなくイベント自体のゲートとなります。

| 属性 | 説明 | ゲート |
| - | - | - |
| `content` | Read ツールが返したテキスト、または Write の呼び出しで書き込みを指示されたテキスト | Write ツールの場合は `OTEL_LOG_TOOL_DETAILS` |
| `output` | Bash ツールの場合は、stderr が stdout に混在したコマンドの結合出力。MCP ツール、WebFetch、WebSearch の場合は、ツールが返した結果（テキストブロックを改行で連結し、画像やドキュメントは `[image]` などのプレースホルダーに置き換えたもの） | |
| `diff` | Edit ツールが適用した構造化パッチ | `OTEL_LOG_TOOL_DETAILS` |
| `file_path` | Read、Edit、Write ツールの対象ファイルパス。同名のスパン属性を繰り返したもの | `OTEL_LOG_TOOL_DETAILS` |
| `bash_command` | Bash ツールのコマンド文字列 | `OTEL_LOG_TOOL_DETAILS` |

親スパンの `tool_name` 属性で、イベントがどのツールから来たかがわかります。コンテンツ上限で切り詰められた属性には、`<attribute>_truncated` と `<attribute>_original_length` が付随します。

**`claude_code.tool.blocked_on_user`**

| 属性 | 説明 | ゲート |
| - | - | - |
| `duration_ms` | 権限の決定を待っていた時間 | |
| `decision` | `accept` または `reject` | |
| `source` | 決定のソース。[ツール決定イベント](#tool-decision-event)と一致します | |

**`claude_code.tool.execution`**

| 属性 | 説明 | ゲート |
| - | - | - |
| `duration_ms` | ツール本体の実行に費やした時間 | |
| `tool_use_id` | 親の `claude_code.tool` スパンと同じ値 | |
| `gen_ai.tool.call.id` | `tool_use_id` と同じ値。OpenTelemetry GenAI セマンティック規約 | |
| `success` | `true` または `false` | |
| `error` | 実行が失敗した場合のエラーカテゴリ文字列（`Error:ENOENT` や `ShellError` など）。ゲートが設定されている場合は、代わりに完全なエラーメッセージが含まれます | `OTEL_LOG_TOOL_DETAILS` |
| `error_class` | 識別子形式のエラーカテゴリ。英字、数字、アンダースコア以外の文字は `_` に置き換えられます（`Error_ENOENT` や `ShellError` など）。`error` に完全なメッセージが含まれる場合でもカテゴリを保持します。Claude Code v2.1.268 以降が必要です | |

**`claude_code.hook`**

このスパンは詳細ベータトレースが有効な場合にのみ表示されます。詳細ベータトレースには `ENABLE_BETA_TRACING_DETAILED=1` と `BETA_TRACING_ENDPOINT` が必要で、この組み合わせは[ログとトレースの送信先も変更します](/docs/ja/env-vars#variables)。この組み合わせは、シェル、ユーザー設定、または管理設定で設定してください。どちらの変数も[プロジェクト設定とローカル設定](/docs/ja/settings-reference#variables-claude-code-ignores-in-env)では無視されます。`CLAUDE_CODE_ENHANCED_TELEMETRY_BETA` だけではこのスパンは生成されません。

対話型 CLI セッションでは、詳細ベータトレースには、組織がこの機能の許可リストに登録されていることも必要です。Agent SDK および非対話型の `-p` セッションでは、許可リストへの登録は不要です。

| 属性 | 説明 | ゲート |
| - | - | - |
| `hook_event` | フックイベントの種類（`PreToolUse` など） | |
| `hook_name` | 完全なフック名（`PreToolUse:Write` など） | |
| `num_hooks` | 実行された一致するフックコマンドの数 | |
| `hook_definitions` | JSON シリアライズされたフック設定 | `OTEL_LOG_TOOL_DETAILS` |
| `duration_ms` | 一致するすべてのフックの実時間 | |
| `num_success` | 正常に完了したフックの数 | |
| `num_blocking` | ブロックの決定を返したフックの数 | |
| `num_non_blocking_error` | ブロックせずに失敗したフックの数 | |
| `num_cancelled` | 完了前にキャンセルされたフックの数 | |

<span id="new-context-gates" />

**詳細ベータトレースでのコンテンツ属性**

<Note>
  `new_context`、`system_reminders`、`system_prompt_preview`、`user_system_prompt`、`tool_input`、`response.model_output` など、コンテンツを保持する追加の属性は、詳細ベータトレースが有効な場合にのみ出力されます。これらは安定したスパンスキーマには含まれません。
</Note>

これらの属性は以下のスパンに付与され、`ゲート`は詳細ベータトレースに加えて属性に必要な変数を示します。コンテンツ上限（デフォルトで 60 KB）を超える値は切り詰められます。

| 属性 | スパン | 説明 | ゲート |
| - | - | - | - |
| `new_context` | `claude_code.interaction` | ユーザープロンプト | `OTEL_LOG_USER_PROMPTS` |
| `new_context` | `claude_code.llm_request` | リクエストとともに送信された新しいユーザーメッセージとツール結果 | `OTEL_LOG_USER_PROMPTS` |
| `system_reminders` | `claude_code.llm_request` | リクエストの新しいメッセージに含まれる[システムリマインダー](/docs/ja/glossary#system-reminder)のテキスト | `OTEL_LOG_USER_PROMPTS` |
| `system_prompt_preview` | `claude_code.llm_request` | リクエストとともに送信された完全なシステムプロンプトの最初の 500 文字 | `OTEL_LOG_USER_PROMPTS` |
| `user_system_prompt` | `claude_code.llm_request` | `systemPrompt` SDK オプションまたは `--system-prompt` フラグと `--append-system-prompt` フラグで指定したシステムプロンプトのテキストのみ。リクエストごとではなくセッションごとに 1 回出力されます | `OTEL_LOG_USER_PROMPTS` |
| `response.model_output` | `claude_code.llm_request` | リクエストに対するモデルの応答のテキスト | `OTEL_LOG_USER_PROMPTS` |
| `new_context` | `claude_code.tool` | ツールにかかわらず、そのツール呼び出しの結果 | `OTEL_LOG_TOOL_CONTENT` |
| `tool_input` | `claude_code.tool` | ツール呼び出しのシリアライズされた入力 | `OTEL_LOG_TOOL_DETAILS` |

詳細ベータトレースで `OTEL_LOG_USER_PROMPTS=1` を設定している場合、Claude Code は完全なシステムプロンプトを保持する `claude_code.system_prompt` イベントも出力します。このシステムプロンプトはコンテンツ上限で切り詰められます。このイベントは、セッションが個々の異なるシステムプロンプトを初めて送信したときに届き、コンテキスト圧縮の後にも再度届きます。

<h3 id="dynamic-headers">
  動的ヘッダー
</h3>

動的な認証を必要とするエンタープライズ環境では、ヘッダーを動的に生成するスクリプトを設定できます。動的ヘッダーは `http/protobuf` および `http/json` プロトコルにのみ適用されます。`grpc` プロトコルでは、Claude Code は静的なヘッダー変数である `OTEL_EXPORTER_OTLP_HEADERS` とそのシグナルごとのバリアントのみを使用します。

<h4 id="settings-configuration">
  設定
</h4>

`.claude/settings.json` に以下を追加し、パスを独自のスクリプトに置き換えます。

```json theme={null}
{
  "otelHeadersHelper": "/path/to/generate-otel-headers.sh"
}
```

値には、実行可能ファイルへのパス（スペースを含むパスも可）、または引数付きのシェルコマンドラインを指定できます。Windows では値は常にシェルを介して実行されるため、スペースを含むパスは JSON 値内で引用符で囲んでください。

<h4 id="script-requirements">
  スクリプトの要件
</h4>

スクリプトは、HTTP ヘッダーを表す文字列のキーと値のペアを含む有効な JSON を出力する必要があります。

```bash theme={null}
#!/bin/bash
# Example: Multiple headers
echo "{\"Authorization\": \"Bearer $(get-token.sh)\", \"X-API-Key\": \"$(get-api-key.sh)\"}"
```

ヘルパーが失敗するか、これらの要件を満たさない出力を表示した場合、エクスポートは失敗し、ヘルパーが再び動作するまでテレメトリバックエンドはそのセッションから何も受信しません。Claude Code は次の場所で失敗を報告します。

* 対話型セッションでの警告通知 [`otelHeadersHelper failed; telemetry is not being exported`](/docs/ja/errors#otelheadershelper-failed)。ヘルパーが最初に失敗したときに、セッションごとに 1 回表示されます
* `/status` の出力
* [`--debug`](/docs/ja/cli-reference#cli-flags) 付きで実行した場合、またはセッション内で `/debug` を実行した後のデバッグログ
* `-p` で開始した非対話型セッションでの stderr

<h4 id="refresh-behavior">
  更新の動作
</h4>

ヘッダーヘルパースクリプトは、トークンの更新をサポートするために、起動時とその後定期的に実行されます。デフォルトでは、スクリプトは 29 分ごとに実行されます。間隔は `CLAUDE_CODE_OTEL_HEADERS_HELPER_DEBOUNCE_MS` 環境変数でカスタマイズできます。

<h3 id="multi-team-organization-support">
  複数チームの組織のサポート
</h3>

複数のチームや部門を持つ組織は、`OTEL_RESOURCE_ATTRIBUTES` 環境変数を使用してカスタム属性を追加し、異なるグループを区別できます。

```bash theme={null}
# Add custom attributes for team identification
export OTEL_RESOURCE_ATTRIBUTES="department=engineering,team.id=platform,cost_center=eng-123"
```

これらのカスタム属性はすべてのメトリクスとイベントに含まれるため、次のことが可能になります。

* チームまたは部門でメトリクスをフィルタリングする
* コストセンターごとにコストを追跡する
* チーム固有のダッシュボードを作成する
* 特定のチーム向けのアラートを設定する

Claude Code は、これらの値を OTLP リソースブロックで送信するだけでなく、すべてのメトリクスのデータポイントとイベントレコードに属性として付与します。ほとんどのメトリクスバックエンドはデータポイントの属性をクエリ可能なラベルとして公開するため、カスタムキーでメトリクスを直接グループ化およびフィルタリングできます。`vcs.*` [リポジトリ属性](#repository-attributes)を除き、カスタムキーが `user.id` や `session.id` などの[標準属性](#standard-attributes)を上書きすることはありません。キーが衝突した場合、Claude Code は組み込みの値を保持します。

各カスタムキーはすべてのメトリクス系列のラベルになるため、カーディナリティの高い値はメトリクスバックエンドのストレージコストを増加させます。カスタム属性をリソースブロックでのみ送信し、データポイントのラベルから除外するには、`OTEL_METRICS_INCLUDE_RESOURCE_ATTRIBUTES=false` を設定します。[メトリクスのカーディナリティ制御](#metrics-cardinality-control)を参照してください。

<Warning>
  `OTEL_RESOURCE_ATTRIBUTES` 環境変数は、厳密なフォーマット要件を持つカンマ区切りの key=value ペアを使用します。

  * **スペース不可**: 値にスペースを含めることはできません。たとえば、`user.organizationName=My Company` は無効です
  * **フォーマット**: カンマ区切りの key=value ペアである必要があります: `key1=value1,key2=value2`
  * **使用可能な文字**: 制御文字、空白、二重引用符、カンマ、セミコロン、バックスラッシュを除く US-ASCII 文字のみ
  * **特殊文字**: 使用可能な範囲外の文字はパーセントエンコードする必要があります

  スペースが必要な値には、代わりにアンダースコアまたはキャメルケースを使用してください。以下の例では、それぞれの形式で `org.name` を設定しています。

  ```bash theme={null}
  export OTEL_RESOURCE_ATTRIBUTES="org.name=Johns_Organization"
  export OTEL_RESOURCE_ATTRIBUTES="org.name=JohnsOrganization"
  ```

  除外された文字に限らず、任意の文字をパーセントエンコードできます。この例では、スペースとアポストロフィの両方をエンコードしています。

  ```bash theme={null}
  export OTEL_RESOURCE_ATTRIBUTES="org.name=John%27s%20Organization"
  ```

  値を引用符で囲んでもスペースはエスケープされません。たとえば、`org.name="My Company"` は `My Company` ではなく、引用符を含むリテラル値 `"My Company"` になります。
</Warning>

<h3 id="example-configurations">
  設定例
</h3>

`claude` を実行する前に、これらの環境変数を設定してください。以下の各シナリオは完全な設定を示しており、各変数は[共通の設定変数](#common-configuration-variables)で説明しています。設定が反映されたことを確認するには、セッションを開始した後にバックエンドで `claude_code.session.count` メトリクスを確認してください。ログのみの検証方法と、何も届かない場合の確認事項については[クイックスタート](#quick-start)で説明しています。

エクスポート間隔 1 秒でのコンソールデバッグの場合:

```bash theme={null}
export CLAUDE_CODE_ENABLE_TELEMETRY=1
export OTEL_METRICS_EXPORTER=console
export OTEL_METRIC_EXPORT_INTERVAL=1000
```

gRPC 経由の OTLP の場合:

```bash theme={null}
export CLAUDE_CODE_ENABLE_TELEMETRY=1
export OTEL_METRICS_EXPORTER=otlp
export OTEL_EXPORTER_OTLP_PROTOCOL=grpc
export OTEL_EXPORTER_OTLP_ENDPOINT=http://localhost:4317
```

`http://localhost:9464/metrics` からスクレイプする Prometheus の場合:

```bash theme={null}
export CLAUDE_CODE_ENABLE_TELEMETRY=1
export OTEL_METRICS_EXPORTER=prometheus
```

[セルフホスト環境](/docs/ja/self-hosted-environments-reference#pass-through-session-child-metrics)では、セッションがポート 9464 をバインドするのは、ランナーのキャパシティがデフォルトの 1 の場合のみです。キャパシティがそれより大きい場合、ランナーは代わりにセッションのカウンターとゲージを自身の `/metrics` エンドポイントで再公開します。

メトリクスを複数のエクスポーターに送信するには:

```bash theme={null}
export CLAUDE_CODE_ENABLE_TELEMETRY=1
export OTEL_METRICS_EXPORTER=console,otlp
export OTEL_EXPORTER_OTLP_PROTOCOL=http/json
```

メトリクスとログを異なるエンドポイントまたはバックエンドに送信するには:

```bash theme={null}
export CLAUDE_CODE_ENABLE_TELEMETRY=1
export OTEL_METRICS_EXPORTER=otlp
export OTEL_LOGS_EXPORTER=otlp
export OTEL_EXPORTER_OTLP_METRICS_PROTOCOL=http/protobuf
export OTEL_EXPORTER_OTLP_METRICS_ENDPOINT=http://metrics.example.com:4318
export OTEL_EXPORTER_OTLP_LOGS_PROTOCOL=grpc
export OTEL_EXPORTER_OTLP_LOGS_ENDPOINT=http://logs.example.com:4317
```

イベントやログなしでメトリクスのみをエクスポートするには:

```bash theme={null}
export CLAUDE_CODE_ENABLE_TELEMETRY=1
export OTEL_METRICS_EXPORTER=otlp
export OTEL_EXPORTER_OTLP_PROTOCOL=grpc
export OTEL_EXPORTER_OTLP_ENDPOINT=http://localhost:4317
```

メトリクスなしでイベントとログのみをエクスポートするには:

```bash theme={null}
export CLAUDE_CODE_ENABLE_TELEMETRY=1
export OTEL_LOGS_EXPORTER=otlp
export OTEL_EXPORTER_OTLP_PROTOCOL=grpc
export OTEL_EXPORTER_OTLP_ENDPOINT=http://localhost:4317
```

<h2 id="telemetry-from-cloud-sessions-and-claude-tag">
  クラウドセッションと Claude Tag からのテレメトリ
</h2>

[クラウドセッション](/docs/ja/claude-code-on-the-web)（[Claude Tag](https://claude.com/docs/claude-tag/overview) チャネルセッションを含む）は、ユーザーのデバイス上ではなく [クラウド環境](/docs/ja/cloud-environments) で実行されるため、これらのデバイス上の管理設定ファイルまたはシェルプロファイルではテレメトリを設定できません。Anthropic ホスト環境のセッションの場合、このセクションではテレメトリ変数を設定する場所、コレクターを環境から到達可能にする方法、およびエクスポートされたデータでクラウドセッションと Claude Tag セッションを区別する方法について説明します。

これらのセッションからテレメトリをエクスポートするには、[管理者設定](#administrator-configuration) の例と同じキーを使用して、`CLAUDE_CODE_ENABLE_TELEMETRY` と `OTEL_*` 変数を次の 2 つの場所のいずれかに設定します。

* **サーバー管理設定**: 組織の [サーバー管理設定](/docs/ja/server-managed-settings) の `env` ブロックに追加します。Claude Code は [サーバー管理設定が適用される](/docs/ja/model-config#surface-coverage) 場所（ユーザーのマシンと Claude Tag チャネルセッション以外のクラウドセッションを含む）で起動時にこれらの設定を取得します。Claude Tag セッションはサーバー管理設定を受け取らないため、このルートではそれらを設定できません。
* **環境の変数**: クラウド環境の [環境変数](/docs/ja/cloud-environments#set-environment-variables) に追加して、その環境で実行されるセッションのみを設定します。これは Claude Tag セッションに到達するルートです。

環境を使用する誰もがその変数を読み取ることができるため、`OTEL_EXPORTER_OTLP_HEADERS` のコレクタートークンなどの認証情報をそこに配置しないでください。環境の [API 認証情報](/docs/ja/cloud-environments#add-api-credentials) も役に立ちません。Claude Code 独自のテレメトリエクスポートは、[認証情報を取得しないリクエスト](/docs/ja/cloud-environments#requests-that-never-get-the-credential) の 1 つだからです。コレクターが認証情報を必要とする場合は、代わりにサーバー管理設定を通じてエクスポート全体を設定してください。認証情報をそこに設定すると、[Claude Code は管理設定外で設定されたエンドポイント変数を削除します](#how-managed-settings-lock-the-otlp-destination)。

クラウドセッションのテレメトリを設定する際は、これらの制約を念頭に置いてください。

* **セッションがコレクターに到達できるようにする**: Claude Code はセッションのネットワークを通じてエクスポートを送信するため、`OTEL_EXPORTER_OTLP_ENDPOINT` のホストに到達できるかどうかは、環境の [ネットワークアクセスレベル](/docs/ja/cloud-environments#access-levels) によって異なります。セッションが選択したレベルでコレクターのドメインに到達できない場合は、[ドメインを環境のアローリストに追加してください](/docs/ja/cloud-environments#allow-specific-domains)。サーバー管理設定はドメインを環境のネットワークアローリストに追加しないためです。
* **Claude Tag チャネルは組織レベルの環境を使用します**: チャネルセッションはメンバーの個人環境ではなく組織レベルの環境で実行されるため、[共有環境](/docs/ja/cloud-environments#organization-shared-environments) でアローリストと環境変数の変更を行い、組織のデフォルトとして設定するか、チャネルにピン留めしてください。
* **Cowork は個別に設定されます**: [サーフェスカバレッジテーブル](/docs/ja/model-config#surface-coverage) に示されているように、Cowork セッションはサーバー管理設定を受け取らないため、サーバー管理 `env` ブロックはそれらのテレメトリを設定しません。

<h3 id="attribute-telemetry-to-cloud-sessions">
  クラウドセッションにテレメトリを属性付けする
</h3>

デフォルトでは、クラウドセッションからのメトリクスとイベントは、`session.id`、`ccr.session.id`、`organization.id` を含む [標準属性](#standard-attributes) を含むため、追加の設定なしでセッションまたは組織でフィルタリングできます。`ccr.session.id` の値はセッションの `CLAUDE_CODE_REMOTE_SESSION_ID` です。これをセッションのトランスクリプト URL に変換するには、[出力をセッションにリンク戻す](/docs/ja/cloud-environments#link-output-back-to-the-session) を参照してください。

テレメトリをより詳細に属性付けするには、これらのオプションを使用します。

* **Claude Tag セッションを識別する**: [メトリクスカーディナリティ制御](#metrics-cardinality-control) で説明されているように、`OTEL_METRICS_INCLUDE_ENTRYPOINT=true` を設定します。メトリクスは `app.entrypoint` を含むようになり、Claude Tag セッションの値は `claude-in-slack` です。
* **カスタム属性を追加する**: これらのセッションの他の `OTEL_*` 変数を設定する場所と同じ場所に [`OTEL_RESOURCE_ATTRIBUTES`](#multi-team-organization-support) を設定します。代わりに環境の [セットアップスクリプト](/docs/ja/cloud-environments#setup-scripts) でそれを `export` する場合、値は Claude Code に到達しません。セットアップスクリプトは Claude Code が起動する前に実行される別の Bash スクリプトであり、それがエクスポートする変数はそれで終わります。

Claude Tag チャネルセッションでは、Claude はメンバーではなく組織の [共有 ID](/docs/ja/cloud-environments#set-the-environment-a-claude-tag-channel-uses) として機能するため、`user.*` 属性に依存して Claude にタグを付けたユーザーを識別しないでください。

<h2 id="available-metrics-and-events">
  利用可能なメトリクスとイベント
</h2>

<h3 id="standard-attributes">
  標準属性
</h3>

すべてのメトリクスとイベントは、以下の標準属性を共有します。

| 属性 | 説明 | 制御方法 |
| - | - | - |
| `session.id` | 一意のセッション識別子 | `OTEL_METRICS_INCLUDE_SESSION_ID`（デフォルト: true） |
| `ccr.session.id` | クラウドセッション識別子。[クラウド環境](/docs/ja/cloud-environments)で実行されるセッションにおける `CLAUDE_CODE_REMOTE_SESSION_ID` の値 | `OTEL_METRICS_INCLUDE_SESSION_ID`（デフォルト: true） |
| `app.version` | 現在の Claude Code のバージョン | `OTEL_METRICS_INCLUDE_VERSION`（デフォルト: false） |
| `app.entrypoint` | セッションの起動方法。`cli`、`sdk-cli`、`sdk-ts`、`sdk-py`、`claude-vscode`、または Claude Tag セッションの場合は `claude-in-slack` など | `OTEL_METRICS_INCLUDE_ENTRYPOINT`（デフォルト: false） |
| `organization.id` | 組織 UUID（認証時） | 利用可能な場合は常に含まれる |
| `user.account_uuid` | アカウント UUID（認証時） | `OTEL_METRICS_INCLUDE_ACCOUNT_UUID`（デフォルト: true） |
| `user.account_id` | Anthropic の管理 API と一致するタグ付き形式のアカウント ID（認証時）。例: `user_01BWBeN28...` | `OTEL_METRICS_INCLUDE_ACCOUNT_UUID`（デフォルト: true） |
| `user.id` | 初回実行時に生成され `~/.claude.json` に保存されるランダムな匿名識別子。個人情報は含まれず、Claude アカウントから派生したものでもありません。このファイルを削除すると、次回実行時に無関係な新しい値が生成されます。 | 常に含まれる |
| `user.email` | ユーザーのメールアドレス。サインイン情報から取得されるか、[クラウドセッション](/docs/ja/claude-code-on-the-web)ではセッション自体の認証情報から取得されます | 利用可能な場合は常に含まれる |
| `terminal.type` | ターミナルの種類。`iTerm.app`、`vscode`、`cursor`、`tmux` など | 検出された場合は常に含まれる |
| `OTEL_RESOURCE_ATTRIBUTES` のキー | 設定したカスタム属性（`department` や `team.id` など）。[マルチチーム組織のサポート](#multi-team-organization-support)を参照してください | `OTEL_METRICS_INCLUDE_RESOURCE_ATTRIBUTES`（デフォルト: true） |
| `vcs.repository.url.full`、`vcs.owner.name`、`vcs.repository.name`、`vcs.provider.name` | `origin` リモートから導出された、セッションのリポジトリの識別情報。[リポジトリ属性](#repository-attributes)を参照してください | `OTEL_METRICS_INCLUDE_REPOSITORY`（デフォルト: false）。Claude Code v2.1.269 以降が必要 |

`/login` を通じて [Claude apps gateway](/docs/ja/claude-apps-gateway) にサインインしたセッションでは、CLI は認証済みの ID をエクスポートに付与します。`user.id` は IdP のサブジェクト、`user.email` はサインインしたメールアドレスで、`user.groups` は IdP のグループメンバーシップをカンマ区切りの文字列として保持します。各エクスポートには `identity.source: gateway-oidc` も付与されます。ゲートウェイの ID は最後に適用されるため、これらのセッションでは `OTEL_RESOURCE_ATTRIBUTES` で設定した `user.*` および `identity.*` キーは無視されます。

ゲートウェイ経由で接続する Claude Desktop および Cowork セッションの ID 属性については、[ゲートウェイの `telemetry` リファレンス](/docs/ja/claude-apps-gateway-config#telemetry)を参照してください。

イベントには、さらに以下の属性が含まれます。これらはカーディナリティが無制限に増大する原因となるため、メトリクスには付与されません。

* `prompt.id`: ユーザーのプロンプトと、次のプロンプトまでに発生する後続のすべてのイベントを関連付ける UUID。[イベント相関属性](#event-correlation-attributes)を参照してください。
* `workspace.host_paths`: デスクトップアプリで選択されたホストのワークスペースディレクトリ（文字列配列）
* `workflow.run_id`: `wf_` をプレフィックスとする実行識別子。[Workflow](/docs/ja/workflows) ツールの実行に属するエージェントが発行する API イベントとツールイベントに付与されます。1 つの `workflow.run_id` でイベントをフィルタリングすると、その実行の API リクエストとツール結果を再構成できます。この識別子は、ワークフロースクリプトが起動するエージェントと、それらがさらに起動するエージェント（スキルの呼び出しなど）を対象とします。Workflow ツールの結果で報告される実行識別子と一致します。その他のすべてのイベントには含まれません。Claude Code v2.1.202 以降が必要です
* `workflow.name`: ワークフローの名前（スクリプトの `meta.name`）。`workflow.run_id` と一緒に出力されます。組み込みワークフローの名前は、未変更の組み込みスクリプトが実行された場合にそのまま表示されます。ユーザーが作成した名前（組み込みスクリプトを編集したコピーを含む）は、`OTEL_LOG_TOOL_DETAILS=1` が設定されていない限り `custom` に置き換えられます。Claude Code v2.1.202 以降が必要です

<h4 id="repository-attributes">
  リポジトリ属性
</h4>

`OTEL_METRICS_INCLUDE_REPOSITORY=true` を設定すると、メトリクスとイベントにセッションのリポジトリの識別情報がタグ付けされ、共有コレクターで使用量をリポジトリごとに集計できるようになります。Claude Code v2.1.269 以降が必要です。

Claude Code は、これらの属性をセッションごとに 1 回、リポジトリの `origin` リモートから導出します。GitHub、GitLab、Bitbucket Cloud のように、リポジトリの HTTPS リモートと SSH リモートが同じホストと同じパスを指している場合、どちらからも同一の値が生成されます。

| 属性 | 値 |
| - | - |
| `vcs.repository.url.full` | `.git` を除いたリポジトリのブラウザ URL。例: `https://github.com/example-org/example-repo` |
| `vcs.owner.name` | オーナーまたはグループのパス。例: `example-org`。リモートのパスが単一のセグメントの場合は省略されます |
| `vcs.repository.name` | リポジトリ名のみ。例: `example-repo` |
| `vcs.provider.name` | Claude Code がリモートのホストまたは URL の形式を `github`、`gitlab`、`bitbucket`、`gitea` のいずれかのプロバイダーとして認識した場合のその値。それ以外の場合は省略されます |

値は小文字に変換され、リモート URL の認証情報、クエリ文字列、フラグメントが含まれることはありません。セッションに `origin` リモートがない場合、リモートが URL 形式でない場合、または唯一の親リポジトリがホームディレクトリである場合、これらの属性は省略されます。

[クラウドセッション](/docs/ja/claude-code-on-the-web)でこれらの属性を取得するには、`OTEL_METRICS_INCLUDE_REPOSITORY` を含むテレメトリ変数を、そのセッションの[クラウド環境](/docs/ja/cloud-environments#set-environment-variables)に設定します。また、環境の[ネットワークアクセス](/docs/ja/cloud-environments#network-access)でコレクターのドメインを許可してください。

[`OTEL_RESOURCE_ATTRIBUTES`](#multi-team-organization-support) で宣言した `vcs.*` キーは、そのキーの導出値を置き換えます。`vcs.repository.url.full` を宣言した場合、Claude Code はリモートを読み取らず、宣言したキーのみを報告します。

1 つのリポジトリの HTTPS クローンと SSH クローンが異なる値を報告する場合（たとえば、HTTPS のクローン URL に SSH の URL にはないパスプレフィックスが含まれるセルフホスト環境など）、`OTEL_RESOURCE_ATTRIBUTES` で `vcs.repository.url.full` を、報告させたい他のすべての `vcs.*` キーとともに宣言してください。これにより、すべてのクローンが宣言した識別情報を報告するようになります。

これらの属性は独自のエクスポーターにのみ送信されます。Anthropic のテレメトリはすべての `vcs.*` キーを破棄します。

<h3 id="metrics">
  メトリクス
</h3>

Claude Code は以下のメトリクスをエクスポートします。「単位」列には各メトリクスに付与される OpenTelemetry の単位文字列を示しています。カウント系のメトリクスには単位はありません。

| メトリクス名 | 説明 | 単位 |
| - | - | - |
| `claude_code.session.count` | 開始された CLI セッションの数 | なし |
| `claude_code.lines_of_code.count` | 変更されたコードの行数 | なし |
| `claude_code.pull_request.count` | 作成されたプルリクエストの数 | なし |
| `claude_code.commit.count` | 作成された Git コミットの数 | なし |
| `claude_code.cost.usage` | Claude Code セッションのコスト | USD |
| `claude_code.token.usage` | 使用されたトークン数 | tokens |
| `claude_code.code_edit_tool.decision` | コード編集ツールの権限決定の数 | なし |
| `claude_code.active_time.total` | 合計アクティブ時間 | s |

`OTEL_METRICS_EXPORTER` に指定されたエクスポーターが `prometheus` のみの場合、スクレイプ結果が有効な Prometheus テキスト形式となるよう、Claude Code はエクスポートするメトリクスから `USD`、`tokens`、`s` の単位を省略します。メトリクス名は変わりません。また、`otlp,prometheus` のようにエクスポーターを組み合わせた設定では単位が維持されます。v2.1.216 より前は、Prometheus のスクレイプ結果に OpenMetrics 専用の `# UNIT` 行が含まれており、一部のスクレイパーで拒否されていました。

<h3 id="metric-details">
  メトリクスの詳細
</h3>

各メトリクスには上記の標準属性が含まれます。追加のコンテキスト固有の属性を持つメトリクスについては、以下に記載しています。

<h4 id="session-counter">
  セッションカウンター
</h4>

各セッションの開始時にインクリメントされます。

**属性**:

* すべての[標準属性](#standard-attributes)
* `start_type`: セッションの開始方法。`"fresh"`、`"resume"`、`"continue"`、`"agents_view"` のいずれかです。`"agents_view"` の値は `claude agents` ダッシュボードプロセスを示します。これは会話セッションではなく、ユーザーが起動するローカル UI です。ダッシュボードで UI プロセスの起動と会話セッションを区別するには、この値でフィルタリングしてください。

<h4 id="lines-of-code-counter">
  コード行数カウンター
</h4>

コードが追加または削除されたときにインクリメントされます。

**属性**:

* すべての[標準属性](#standard-attributes)
* `type`: （`"added"`、`"removed"`）
* `model`: 変更を行ったモデルのモデル識別子（例: "claude-sonnet-5"）

<h4 id="pull-request-counter">
  プルリクエストカウンター
</h4>

Claude Code がシェルコマンドまたは MCP ツールを通じてプルリクエストまたはマージリクエストを作成したときにインクリメントされます。

**属性**:

* すべての[標準属性](#standard-attributes)

<h4 id="commit-counter">
  コミットカウンター
</h4>

Claude Code 経由で Git コミットを作成したときにインクリメントされます。

**属性**:

* すべての[標準属性](#standard-attributes)

<h4 id="cost-counter">
  コストカウンター
</h4>

各 API リクエストの後にインクリメントされます。

`agent.name`、`skill.name`、`plugin.name`、`mcp_server.name`、`mcp_tool.name` の各属性は、デフォルトで一部の名前を `"custom"` または `"third-party"` というプレースホルダーに置き換えて秘匿化します。`OTEL_LOG_TOOL_DETAILS=1` を設定すると、代わりに実際の名前が含まれます。v2.1.273 より前は、`OTEL_LOG_TOOL_DETAILS=1` を設定していても、コストカウンターとトークンカウンター、および `api_request`、`api_error`、`api_refusal` イベントには秘匿化された値が含まれていました。

**属性**:

* すべての[標準属性](#standard-attributes)
* `model`: モデル識別子（例: "claude-sonnet-5"）
* `query_source`: リクエストを発行したサブシステムのカテゴリ。`"main"`、`"subagent"`、`"auxiliary"` のいずれか
* `speed`: リクエストが fast mode を使用した場合は `"fast"`。それ以外の場合は含まれません
* `effort`: リクエストに適用された [effort レベル](/docs/ja/model-config#adjust-effort-level)。`"low"`、`"medium"`、`"high"`、`"xhigh"`、`"max"` のいずれか。Claude Code が effort レベルを送信しない場合（effort をサポートしていないモデルなど）は含まれません。
* `agent.name`: リクエストを発行したサブエージェントの種類。組み込みエージェント名と公式マーケットプレイスのプラグインのエージェントはそのまま表示されます。その他のユーザー定義のエージェント名は `"custom"` に置き換えられます。名前付きのサブエージェントの種類によって発行されたリクエストでない場合は含まれません。
* `skill.name`: リクエストでアクティブなスキル。Skill ツールまたは `/` コマンドによって設定されるか、起動されたサブエージェントに継承されます。組み込み、バンドル、ユーザー定義、および公式マーケットプレイスのプラグインのスキル名はそのまま表示されます。サードパーティのプラグインのスキル名は `"third-party"` に置き換えられます。アクティブなスキルがない場合は含まれません。
* `plugin.name`: アクティブなスキルまたはサブエージェントがプラグインによって提供されている場合の、所有元のプラグイン。公式マーケットプレイスのプラグイン名はそのまま表示されます。サードパーティのプラグイン名は `"third-party"` に置き換えられます。スキルとサブエージェントのどちらにも所有元のプラグインがない場合は含まれません。
* `marketplace.name`: 所有元のプラグインのインストール元のマーケットプレイス。`OTEL_LOG_TOOL_DETAILS=1` が設定されている場合でも、公式マーケットプレイスのプラグインに対してのみ出力されます。それ以外の場合は含まれません。
* `mcp_server.name`: このリクエストが消費したツール結果を返した MCP サーバー。組み込み、claude.ai 経由のプロキシ、および公式レジストリのサーバー名はそのまま表示されます。ユーザーが設定したサーバー名は `"custom"` に置き換えられます。リクエストが MCP ツールの結果を消費しなかった場合は含まれません。v2.1.222 より前は、Claude Code はツール結果を消費したリクエストだけでなく、MCP ツール呼び出し後のすべてのリクエストにこの属性を設定していたため、この属性を集計するダッシュボードではアップグレード後に値が減少します。
* `mcp_tool.name`: このリクエストが結果を消費した MCP ツール。秘匿化とバージョンの挙動は `mcp_server.name` と同じです。リクエストが MCP ツールの結果を消費しなかった場合は含まれません。

<h4 id="token-counter">
  トークンカウンター
</h4>

各 API リクエストの後にインクリメントされます。

**属性**:

* すべての[標準属性](#standard-attributes)
* `type`: （`"input"`、`"output"`、`"cacheRead"`、`"cacheCreation"`）。`"input"` タイプには、プロンプトキャッシュから読み取られた、またはプロンプトキャッシュに書き込まれたトークンは含まれません。これらは `"cacheRead"` と `"cacheCreation"` でカウントされます
* `model`: モデル識別子（例: "claude-sonnet-5"）
* `query_source`: リクエストを発行したサブシステムのカテゴリ。`"main"`、`"subagent"`、`"auxiliary"` のいずれか
* `speed`: リクエストが fast mode を使用した場合は `"fast"`。それ以外の場合は含まれません
* `effort`: リクエストに適用された [effort レベル](/docs/ja/model-config#adjust-effort-level)。詳細は[コストカウンター](#cost-counter)を参照してください。
* `agent.name`、`skill.name`、`plugin.name`、`marketplace.name`、`mcp_server.name`、`mcp_tool.name`: リクエストのスキル、プラグイン、エージェント、MCP の帰属情報。定義と秘匿化の挙動については[コストカウンター](#cost-counter)を参照してください。

<h4 id="code-edit-tool-decision-counter">
  コード編集ツール決定カウンター
</h4>

ユーザーが Edit、Write、NotebookEdit ツールの使用を承認または拒否したときにインクリメントされます。

**属性**:

* すべての[標準属性](#standard-attributes)
* `tool_name`: ツール名（`"Edit"`、`"Write"`、`"NotebookEdit"`）
* `decision`: ユーザーの決定（`"accept"`、`"reject"`）
* `source`: 決定の出どころ。`"config"`、`"hook"`、`"user_permanent"`、`"user_temporary"`、`"user_abort"`、`"user_reject"` のいずれかです。各値の意味については[ツール決定イベント](#tool-decision-event)を参照してください。
* `language`: 編集されたファイルのプログラミング言語。`"TypeScript"`、`"Python"`、`"JavaScript"`、`"Markdown"` など。認識されないファイル拡張子の場合は `"unknown"` を返します。

<h4 id="active-time-counter">
  アクティブ時間カウンター
</h4>

アイドル時間を除き、Claude Code をアクティブに使用した実際の時間を記録します。このメトリクスは、ユーザーの操作中（入力や応答の閲覧など）と、CLI の処理中（ツールの実行や AI の応答生成など）にインクリメントされます。

**属性**:

* すべての[標準属性](#standard-attributes)
* `type`: キーボード操作の場合は `"user"`、ツールの実行と AI の応答の場合は `"cli"`

<h3 id="events">
  イベント
</h3>

Claude Code は、OpenTelemetry のログ/イベントを通じて以下のイベントをエクスポートします（`OTEL_LOGS_EXPORTER` が設定されている場合）。

<h4 id="event-correlation-attributes">
  イベント相関属性
</h4>

ユーザーがプロンプトを送信すると、Claude Code は複数の API 呼び出しを行い、いくつかのツールを実行することがあります。`prompt.id` 属性を使用すると、それらのイベントすべてを、それらをトリガーした単一のプロンプトに結び付けることができます。

| 属性 | 説明 |
| - | - |
| `prompt.id` | 単一のユーザープロンプトの処理中に生成されたすべてのイベントを関連付ける UUID v4 識別子 |
| `event.sequence` | イベントを順序付けるための 0 始まりのカウンター。セッションごとではなく Claude Code プロセスごとにカウントされます |
| `message.uuid` | セッションのトランスクリプト（`~/.claude/projects/*/*.jsonl` ファイル）に保存されたメッセージの UUID。`assistant_response`、`api_response_body`、および `user_prompt` に含まれます。ただし、0 個または複数のメッセージを生成する可能性があるコマンドのディスパッチは除きます。`assistant_response` と `api_response_body` では、これはレスポンスの最後のトランスクリプトエントリであり、次のターンの `parentUuid` がこれにチェーンされます。Claude Code v2.1.214 以降が必要です。`api_response_body` では v2.1.274 以降が必要です |
| `request_id` | サーバーが割り当てた API リクエストの ID。`request-id` レスポンスヘッダーから読み取られます（例: `req_011...`）。[Amazon Bedrock](/docs/ja/amazon-bedrock) のように `request-id` ヘッダーのないレスポンスでは、代わりに `x-amzn-requestid` ヘッダーから値を取得します。レスポンスにいずれかのヘッダーが含まれる場合、`api_request`、`api_error`、`api_refusal`、`assistant_response`、`api_response_body` に含まれます。`llm_request` トレーススパンの同名の属性と一致します。`x-amzn-requestid` からの取得には Claude Code v2.1.282 以降が必要です |
| `client_request_id` | `x-client-request-id` リクエストヘッダーとして送信される、クライアントが生成した UUID。ファーストパーティの API 接続では `api_request` と `api_error` に含まれます。サードパーティのプロバイダーのバックエンドや、非ストリーミングのフォールバックを通じてリクエストが再試行された場合には含まれません。リクエストとそのレスポンスを対応付けるもので、タイムアウトなどサーバーの `request_id` が生成されなかった失敗の場合にも利用できます。`llm_request` トレーススパンの同名の属性と一致します。Claude Code v2.1.214 以降が必要です |

単一のプロンプトによってトリガーされたすべてのアクティビティを追跡するには、特定の `prompt.id` の値でイベントをフィルタリングします。これにより、そのプロンプトの処理中に発生した user\_prompt イベント、api\_request イベント、tool\_result イベントが返されます。

`event.sequence` は Claude Code プロセスが開始されるたびに 0 から始まり、そのプロセスが存続する間カウントアップされます。新しい `session.id` が割り当てられる `/clear` の後もカウントは継続します。[フォークせずにセッションを再開](/docs/ja/how-claude-code-works#resume-or-fork-sessions)した場合、セッションは `session.id` を維持しますが、`event.sequence` の値は再開したプロセスのものになります。そのため、1 つのセッション内で後のイベントが前のイベントより小さい値を持つことや、同じ値が重複することがあります。セッションのイベントを順序付けるには、`event.timestamp` で並べ替え、同じタイムスタンプを持つイベントの順序付けに `event.sequence` を使用してください。

メッセージ単位で再構成するために、各イベントクラスはセッションのトランスクリプトのフィールドと一致するキーを保持しています。トランスクリプトのエントリ形式は [Claude Code の内部仕様](/docs/ja/sessions#where-transcripts-are-stored)であり、バージョン間で変更されるため、これらのフィールドで結合するパイプラインはどのリリースでも壊れる可能性があります。結合は安定した契約ではなく、バージョン固有のものとして扱ってください。

* `user_prompt`、`assistant_response`、`api_response_body` の `message.uuid`
* API イベントの `request_id`。トランスクリプトのアシスタントエントリには `requestId` として保存されます
* `tool_result` および `tool_decision` イベントの `tool_use_id`

<h4 id="user-prompt-event">
  ユーザープロンプトイベント
</h4>

プロンプトが送信されたときにログに記録されます。Claude Code が自ら開始するターンも含まれます。

**イベント名**: `claude_code.user_prompt`

**属性**:

* すべての[標準属性](#standard-attributes)
* `event.name`: `"user_prompt"`
* `event.timestamp`: ISO 8601 タイムスタンプ
* `event.sequence`: イベントを順序付けるためのプロセスごとのカウンター。[イベント相関属性](#event-correlation-attributes)で説明しています
* `prompt_length`: プロンプトの長さ
* `prompt`: プロンプトの内容。デフォルトでは秘匿化されます。含めるには `OTEL_LOG_USER_PROMPTS=1` を設定してください
* `prompt_text`: `prompt` と同じ値で、同じ条件で伏せ字化されます。ドット区切りの属性名をネストされたオブジェクトとして保存するバックエンドでは、`prompt.id` を `prompt` という名前のオブジェクト内の `id` として読み取るため、プロンプト文字列が失われる可能性があります。その場合は代わりに `prompt_text` を読み取ってください。Claude Code v2.1.287 以降が必要です
* `message.uuid`: 結果として生成されたユーザーメッセージの UUID。保存されたトランスクリプトのエントリと一致します。0 個または複数のメッセージを生成する可能性があるコマンドのディスパッチには含まれません。Claude Code v2.1.214 以降が必要です
* `command_name`: プロンプトがコマンドを呼び出す場合のコマンド名。`compact` や `debug` などの組み込みおよびバンドルのコマンド名はそのまま出力されます。`reset` などのエイリアスは正規の名前ではなく入力されたとおりに出力されます。カスタム、プラグイン、MCP のコマンド名は、`OTEL_LOG_TOOL_DETAILS=1` が設定されていない限り `custom` または `mcp` にまとめられます
* `command_source`: コマンドが存在する場合のコマンドの出どころ。`builtin`、`custom`、`mcp` のいずれかです。プラグインが提供するコマンドは `custom` として報告されます

<h4 id="assistant-response-event">
  アシスタント応答イベント
</h4>

モデルからテキストコンテンツを返す各 API リクエストの後にログに記録されます。応答のテキストブロックのみが含まれ、思考ブロックとツール使用ブロックは除外されます。Claude Code v2.1.193 以降が必要です。

**イベント名**: `claude_code.assistant_response`

**属性**:

* すべての[標準属性](#standard-attributes)
* `event.name`: `"assistant_response"`
* `event.timestamp`: ISO 8601 タイムスタンプ
* `event.sequence`: イベントを順序付けるためのプロセスごとのカウンター。[イベント相関属性](#event-correlation-attributes)で説明しています
* `response_length`: 応答テキストの長さ（文字数）
* `response`: 応答テキスト。コンテンツの上限（デフォルトは 60 KB）で切り詰められます。デフォルトでは `<REDACTED>` に秘匿化されます。含めるには `OTEL_LOG_ASSISTANT_RESPONSES=1` を設定してください。`OTEL_LOG_ASSISTANT_RESPONSES` が未設定の場合は、代わりに `OTEL_LOG_USER_PROMPTS` によって制御されます。そのため、プロンプトのログ記録を有効にしたまま応答を秘匿化しておくには `OTEL_LOG_ASSISTANT_RESPONSES=0` を設定してください
* `model`: モデル識別子（例: "claude-sonnet-5"）
* `request_id`: API リクエスト ID。[イベント相関属性](#event-correlation-attributes)で説明しています
* `message.uuid`: 応答の最後のトランスクリプトエントリの UUID。API レスポンスはコンテンツブロックごとに 1 つのトランスクリプトエントリとして保存されます。これはその最後のエントリであり、次のターンの `parentUuid` がこれにチェーンされます。Claude Code v2.1.214 以降が必要です
* `query_source`: リクエストを発行したサブシステム。`"repl_main_thread"`、`"compact"`、またはサブエージェント名など

<h4 id="tool-result-event">
  ツール結果イベント
</h4>

ツールの実行が完了したときにログに記録されます。ツール呼び出しが拒否された場合は出力されません。拒否については[ツール決定イベント](#tool-decision-event)を参照してください。

**イベント名**: `claude_code.tool_result`

**属性**:

* すべての[標準属性](#standard-attributes)
* `event.name`: `"tool_result"`
* `event.timestamp`: ISO 8601 タイムスタンプ
* `event.sequence`: イベントを順序付けるためのプロセスごとのカウンター。[イベント相関属性](#event-correlation-attributes)で説明しています
* `tool_name`: ツールの名前
* `tool_use_id`: このツール呼び出しの一意の識別子。フックに渡される `tool_use_id` と一致するため、OTel イベントとフックで取得したデータを関連付けることができます。
* `success`: `"true"` または `"false"`
* `duration_ms`: 実行時間（ミリ秒）
* `error_type`: ツールが失敗した場合のエラーカテゴリの文字列。`"Error:ENOENT"` や `"ShellError"` など
* `error`（`OTEL_LOG_TOOL_DETAILS=1` の場合）: ツールが失敗した場合の完全なエラーメッセージ
* `decision_type`: 常に `"accept"`。このイベントはツールの実行後にのみ出力されるためです。拒否された呼び出しはツール結果を生成しません
* `decision_source`: 権限決定の出どころ。`"config"`、`"hook"`、`"user_permanent"`、`"user_temporary"` のいずれかです。各値の意味については[ツール決定イベント](#tool-decision-event)を参照してください。拒否専用のソースである `"user_abort"` と `"user_reject"` がこのイベントに現れることはありません。
* `tool_input_size_bytes`: JSON シリアライズされたツール入力のサイズ（バイト）
* `tool_result_size_bytes`: ツール結果のサイズ（バイト）
* `mcp_server_scope`: MCP サーバーのスコープ識別子（MCP ツールの場合）
* `vcs.ref.head.revision`、`vcs.ref.head.name`、`vcs.ref.head.type`（`OTEL_LOG_TOOL_DETAILS=1` の場合）: Bash または PowerShell ツールによって実行され成功した `git commit` のコミットの識別情報。`vcs.ref.head.revision` はコミット SHA、`vcs.ref.head.name` はコミットされたブランチ、`vcs.ref.head.type` は `branch` です。detached HEAD 上でコミットされた場合、名前と種類は省略されます。Claude Code v2.1.269 以降が必要です
* `tool_parameters`（`OTEL_LOG_TOOL_DETAILS=1` の場合）: ツール固有のパラメーターを含む JSON 文字列。Claude Desktop の組み込みサーバーについては、Claude Desktop が所有するセッションでは、フラグがオフでも `mcp_server_name`/`mcp_tool_name` のペアが含まれます。これは[ツール決定イベント](#tool-decision-event)と同じ、ホストが作成した名前に対する例外であり、Claude Code v2.1.214 以降が必要です。パラメーターはツールによって異なります。
  * Bash ツールの場合: `bash_command`、`full_command`、`timeout`、`description`、`dangerouslyDisableSandbox` を含みます。さらに `git commit` コマンドが成功した場合は `git_commit_id` と `git_branch` を含みます。`git_commit_id` は、コミットがセッションの作業ディレクトリの HEAD である場合は完全なコミット SHA、それ以外の場合は Git の短縮 SHA です。`git_branch` はコミットされたブランチで、detached HEAD の場合は省略されます
  * デスクトップアプリのワークスペース Bash ツール（`tool_name` も `Bash` として報告されます）の場合: `bash_command`、`full_command`、`timeout` のみを含みます
  * MCP ツールの場合: `mcp_server_name`、`mcp_tool_name` を含みます
  * Skill ツールの場合: `skill_name` を含みます
  * Agent ツールまたは従来の Task ツールの場合: `subagent_type` を含みます
* `tool_input`（`OTEL_LOG_TOOL_DETAILS=1` の場合）: JSON シリアライズされたツールの引数。512 文字を超える個々の値は切り詰められ、ペイロード全体は約 4 K 文字に制限されます。MCP ツールを含むすべてのツールに適用されます。

<h4 id="api-request-event">
  API リクエストイベント
</h4>

Claude への各 API リクエストについてログに記録されます。

**イベント名**: `claude_code.api_request`

**属性**:

* すべての[標準属性](#standard-attributes)
* `event.name`: `"api_request"`
* `event.timestamp`: ISO 8601 タイムスタンプ
* `event.sequence`: イベントを順序付けるためのプロセスごとのカウンター。[イベント相関属性](#event-correlation-attributes)で説明しています
* `model`: 使用されたモデル（例: "claude-sonnet-5"）
* `cost_usd`: 推定コスト（USD）
* `cost_usd_micros`: 推定コスト（100 万分の 1 米ドル単位）。整数として出力されます
* `duration_ms`: リクエストの所要時間（ミリ秒）
* `input_tokens`: 入力トークン数。プロンプトキャッシュから読み取られた、またはプロンプトキャッシュに書き込まれたトークンは含みません
* `output_tokens`: 出力トークン数
* `cache_read_tokens`: キャッシュから読み取られたトークン数
* `cache_creation_tokens`: キャッシュの作成に使用されたトークン数
* `request_id`: API リクエスト ID（例: `"req_011..."`）。[イベント相関属性](#event-correlation-attributes)で説明しています。
* `client_request_id`: `x-client-request-id` リクエストヘッダーとして送信される、クライアントが生成した UUID。含まれる条件については[イベント相関属性](#event-correlation-attributes)の表を参照してください。Claude Code v2.1.214 以降が必要です
* `speed`: `"fast"` または `"normal"`。fast mode が有効だったかどうかを示します
* `query_source`: リクエストを発行したサブシステム。`"repl_main_thread"`、`"compact"`、またはサブエージェント名など
* `effort`: リクエストに適用された [effort レベル](/docs/ja/model-config#adjust-effort-level)。`"low"`、`"medium"`、`"high"`、`"xhigh"`、`"max"` のいずれか。Claude Code が effort レベルを送信しない場合（effort をサポートしていないモデルなど）は含まれません。
* `agent.name`、`skill.name`、`plugin.name`、`marketplace.name`、`mcp_server.name`、`mcp_tool.name`: リクエストのスキル、プラグイン、エージェント、MCP の帰属情報。定義と秘匿化の挙動については[コストカウンター](#cost-counter)を参照してください。

<h4 id="api-error-event">
  API エラーイベント
</h4>

Claude への API リクエストが失敗したときにログに記録されます。

**イベント名**: `claude_code.api_error`

**属性**:

* すべての[標準属性](#standard-attributes)
* `event.name`: `"api_error"`
* `event.timestamp`: ISO 8601 タイムスタンプ
* `event.sequence`: イベントを順序付けるためのプロセスごとのカウンター。[イベント相関属性](#event-correlation-attributes)で説明しています
* `model`: 使用されたモデル（例: "claude-sonnet-5"）
* `error`: エラーメッセージ
* `status_code`: 数値としての HTTP ステータスコード。接続の失敗など、HTTP 以外のエラーの場合は含まれません。
* `duration_ms`: リクエストの所要時間（ミリ秒）
* `attempt`: 最初のリクエストを含む試行の合計回数（`1` は再試行が発生しなかったことを意味します）
* `request_id`: API リクエスト ID（例: `"req_011..."`）。[イベント相関属性](#event-correlation-attributes)で説明しています。
* `client_request_id`: `x-client-request-id` リクエストヘッダーとして送信される、クライアントが生成した UUID。タイムアウトや接続エラーなどの失敗によってサーバーの `request_id` が生成されなかった場合でも利用できます。含まれる条件については[イベント相関属性](#event-correlation-attributes)の表を参照してください。Claude Code v2.1.214 以降が必要です
* `speed`: `"fast"` または `"normal"`。fast mode が有効だったかどうかを示します
* `query_source`: リクエストを発行したサブシステム。`"repl_main_thread"`、`"compact"`、またはサブエージェント名など
* `effort`: リクエストに適用された [effort レベル](/docs/ja/model-config#adjust-effort-level)。Claude Code が effort レベルを送信しない場合（effort をサポートしていないモデルなど）は含まれません。
* `agent.name`、`skill.name`、`plugin.name`、`marketplace.name`、`mcp_server.name`、`mcp_tool.name`: リクエストのスキル、プラグイン、エージェント、MCP の帰属情報。定義と秘匿化の挙動については[コストカウンター](#cost-counter)を参照してください。

<h4 id="api-refusal-event">
  API 拒否イベント
</h4>

API リクエストが `stop_reason: "refusal"` を返したときにログに記録されます。拒否は HTTP エラーとしてではなく成功したレスポンスストリーム上で届くため、`api_error` イベントは発生しません。このイベントを使用すると、拒否の頻度を追跡し、`api_request` や `api_error` と同じ属性で拒否をグループ化できます。

**イベント名**: `claude_code.api_refusal`

**属性**:

* すべての[標準属性](#standard-attributes)
* `event.name`: `"api_refusal"`
* `event.timestamp`: ISO 8601 タイムスタンプ
* `event.sequence`: イベントを順序付けるためのプロセスごとのカウンター。[イベント相関属性](#event-correlation-attributes)で説明しています
* `model`: リクエストのモデル識別子
* `request_id`: API リクエスト ID（例: `"req_011..."`）。[イベント相関属性](#event-correlation-attributes)で説明しています。
* `query_source`: リクエストを発行したサブシステム。`"repl_main_thread"`、`"compact"`、またはサブエージェント名など。定義については [`api_request`](#api-request-event) を参照してください。
* `speed`: [Fast mode](/docs/ja/fast-mode) が有効な場合は `"fast"`、それ以外は `"normal"`
* `attempt`: 再試行の試行番号。最初の試行は `1` です。
* `effort`: リクエストに適用された [effort レベル](/docs/ja/model-config#adjust-effort-level)。Claude Code が effort レベルを送信しない場合（effort をサポートしていないモデルなど）は含まれません。
* `server_fallback_hop`: API のサーバー側のモデルフォールバックがこの拒否をすでに別のモデルで再試行したため、ユーザーにはこの拒否が表示されなかった場合は `true`。リクエストが拒否で終了した場合は `false`。フォールバック先のモデルも拒否した場合、1 つのターンで `true` のホップイベントと、その後の `false` の最終イベントの両方が出力されることがあります。
* `has_category`: API レスポンスに `"cyber"`、`"bio"`、`"frontier_llm"`、`"reasoning_extraction"` のいずれかの `stop_details.category` が含まれていた場合は `true`。レスポンスにカテゴリが含まれていなかった場合、またはその集合以外の値だった場合は `false`。ホップのブロックには `stop_details` が含まれないため、`server_fallback_hop` が `true` の場合は含まれません。
* `has_explanation`: API レスポンスに `stop_details.explanation` が含まれていた場合は `true`、それ以外は `false`。`server_fallback_hop` が `true` の場合は含まれません。
* `category`: API レスポンスの `stop_details.category` の値。`"cyber"`、`"bio"`、`"frontier_llm"`、`"reasoning_extraction"` のいずれかです。`OTEL_LOG_TOOL_DETAILS=1` が設定され、かつ `has_category` が `true` の場合にのみ含まれます。
* `agent.name`、`skill.name`、`plugin.name`、`marketplace.name`、`mcp_server.name`、`mcp_tool.name`: リクエストのスキル、プラグイン、エージェント、MCP の帰属情報。定義と秘匿化の挙動については[コストカウンター](#cost-counter)を参照してください。

<h4 id="api-request-body-event">
  API リクエストボディイベント
</h4>

`OTEL_LOG_RAW_API_BODIES` が設定されている場合、各 API リクエストの試行についてログに記録されます。試行ごとに 1 つのイベントが出力されるため、パラメーターを調整した再試行はそれぞれ独自のイベントを生成します。

**イベント名**: `claude_code.api_request_body`

**属性**:

* すべての[標準属性](#standard-attributes)
* `event.name`: `"api_request_body"`
* `event.timestamp`: ISO 8601 タイムスタンプ
* `event.sequence`: イベントを順序付けるためのプロセスごとのカウンター。[イベント相関属性](#event-correlation-attributes)で説明しています
* `body`: システムプロンプト、メッセージ、ツールなどを含む、JSON シリアライズされた Messages API のリクエストパラメーター。コンテンツの上限（デフォルトは 60 KB）で切り詰められます。過去のアシスタントのターンに含まれる拡張思考のコンテンツは秘匿化されます。インラインモード（`OTEL_LOG_RAW_API_BODIES=1`）でのみ出力されます。
* `body_ref`: 切り詰められていないボディを含む `<dir>/<uuid>.request.json` ファイルへの絶対パス。ファイルモード（`OTEL_LOG_RAW_API_BODIES=file:<dir>`）でのみ出力されます。
* `body_length`: 切り詰め前のボディの長さ。`OTEL_LOG_RAW_API_BODIES=file:<dir>` の場合は UTF-8 バイト、`=1` の場合は UTF-16 コード単位です
* `body_truncated`: インラインでの切り詰めが発生した場合は `"true"`。ファイルモードの場合、および切り詰めが発生しなかった場合は含まれません。
* `model`: リクエストパラメーターのモデル識別子
* `query_source`: リクエストを発行したサブシステム（例: `"compact"`）
* `request_body_id`: この試行のリクエストボディを識別する UUID。成功した試行の [`api_response_body` イベント](#api-response-body-event)にも同じ値が含まれるため、レスポンスとそれを生成した正確なリクエストを対応付けることができます。Claude Code v2.1.274 以降が必要です

<h4 id="api-response-body-event">
  API レスポンスボディイベント
</h4>

`OTEL_LOG_RAW_API_BODIES` が設定されている場合、成功した各 API レスポンスについてログに記録されます。

ファイルモード（`OTEL_LOG_RAW_API_BODIES=file:<dir>`）では、Claude Code は成功したレスポンスごとに `<dir>/index.jsonl` にも 1 行の JSON を追記します。この行には `timestamp`、`session_id`、`query_source`、`model`、`request_id`、`message_id`、`message_uuid`、`request_file`、`response_file` のフィールドが含まれます。これを読むと、テレメトリバックエンドにクエリを実行することなく、特定のトランスクリプトメッセージの背後にあるリクエストファイルとレスポンスファイルを見つけることができます。インデックスファイルには Claude Code v2.1.274 以降が必要です。

**イベント名**: `claude_code.api_response_body`

**属性**:

* すべての[標準属性](#standard-attributes)
* `event.name`: `"api_response_body"`
* `event.timestamp`: ISO 8601 タイムスタンプ
* `event.sequence`: イベントを順序付けるためのプロセスごとのカウンター。[イベント相関属性](#event-correlation-attributes)で説明しています
* `body`: ID、コンテンツブロック、使用量、停止理由を含む、JSON シリアライズされた Messages API のレスポンス。コンテンツの上限（デフォルトは 60 KB）で切り詰められます。拡張思考のコンテンツは秘匿化されます。インラインモード（`OTEL_LOG_RAW_API_BODIES=1`）でのみ出力されます。
* `body_ref`: 切り詰められていないボディを含む `<dir>/<request_id>.response.json` ファイルへの絶対パス。ファイルモード（`OTEL_LOG_RAW_API_BODIES=file:<dir>`）でのみ出力されます。
* `body_length`: 切り詰め前のボディの長さ。`OTEL_LOG_RAW_API_BODIES=file:<dir>` の場合は UTF-8 バイト、`=1` の場合は UTF-16 コード単位です
* `body_truncated`: インラインでの切り詰めが発生した場合は `"true"`。ファイルモードの場合、および切り詰めが発生しなかった場合は含まれません。
* `model`: モデル識別子
* `query_source`: リクエストを発行したサブシステム
* `request_id`: API リクエスト ID（例: `"req_011..."`）。[イベント相関属性](#event-correlation-attributes)で説明しています。
* `request_body_id`: このレスポンスが応答する [`api_request_body` イベント](#api-request-body-event)の `request_body_id`。Claude Code v2.1.274 以降が必要です
* `message.id`: API がレスポンスに割り当てたメッセージ ID（レスポンスボディの `id` フィールド）。Claude Code v2.1.274 以降が必要です
* `message.uuid`: レスポンスの最後のトランスクリプトエントリの UUID。`request_body_id` と組み合わせることで、トランスクリプトのメッセージをその背後にあるリクエストボディとレスポンスボディに結び付けます。Claude Code v2.1.274 以降が必要です

<h4 id="tool-decision-event">
  ツール決定イベント
</h4>

ツールの権限決定（承認/拒否）が行われたときにログに記録されます。

**イベント名**: `claude_code.tool_decision`

**属性**:

* すべての[標準属性](#standard-attributes)
* `event.name`: `"tool_decision"`
* `event.timestamp`: ISO 8601 タイムスタンプ
* `event.sequence`: イベントを順序付けるためのプロセスごとのカウンター。[イベント相関属性](#event-correlation-attributes)で説明しています
* `tool_name`: ツールの名前（例: "Read"、"Edit"、"Write"、"NotebookEdit"）
* `tool_use_id`: このツール呼び出しの一意の識別子。フックに渡される `tool_use_id` と一致するため、OTel イベントとフックで取得したデータを関連付けることができます。
* `decision`: `"accept"` または `"reject"`
* `tool_source`: 常に含まれます。ツールの出自を示す、CLI が定める閉じた集合の値です。Claude Code v2.1.214 以降が必要です
  * `"builtin"`: CLI 自身のツール
  * `"mcp"`: 一般的な MCP サーバー
  * `"sdk_host_builtin_mcp"`: Claude Desktop が所有するセッションにおける、Claude Desktop 自体に組み込まれたインプロセスサーバー。Claude Desktop は、自身のエントリポイント（`claude-desktop`、`claude-desktop-3p`、`local-agent`）のいずれかから開始したセッションが、ネストされた子セッションでない場合にそのセッションを所有します。Claude Code 自体が起動するセッションを含むネストされたセッションでは、これらのサーバーは `"mcp"` として報告されます
* `source`: 決定の出どころ:
  * `"config"`: プロンプトを表示せずに自動的に決定されたもの。プロジェクト設定、ユーザーの個人設定の許可ルールまたは拒否ルール、エンタープライズの管理ポリシー、`--allowedTools` または `--disallowedTools` フラグ、アクティブな権限モード、同じ対話型 CLI セッション内の以前のプロンプトで付与されたセッションスコープの権限、またはツールが本質的に安全であることに基づきます。イベントには、これらのうちどのソースが一致したかは示されません。Claude Code は、権限プロンプトのリクエスト自体が失敗した場合にも `"config"` を報告します。たとえば、Agent SDK の [`canUseTool`](/docs/ja/agent-sdk/typescript#canusetool) コールバックや [`--permission-prompt-tool`](/docs/ja/cli-reference#cli-flags) ツールが無効な結果を返した場合や、リクエストの保留中に入力ストリームが閉じられた場合です。v2.1.216 より前は、Claude Code はこれらの失敗を `"user_reject"` として報告していました。
  * `"hook"`: `PreToolUse` または `PermissionRequest` フックが決定を返したもの。
  * `"user_permanent"`: ユーザーが権限プロンプトで「Yes, and don't ask again for ...」を選択したときに出力されます。この選択により、ユーザーの個人設定に許可ルールが保存されます。対話型 CLI では、その選択自体に対してのみ出力され、保存されたルールに一致する以降の呼び出しでは代わりに `"config"` が出力されます。Agent SDK または非対話型の `-p` セッションでは、最初の選択と以降のルール一致の両方で `"user_permanent"` が出力されます。承認として扱われます。
  * `"user_temporary"`: ユーザーが権限プロンプトで 1 回限りの承認として「Yes」を選択した場合、またはファイルの編集や読み取りのプロンプトでセッションの残りの間アクセスを許可するオプションを選択した場合に出力されます。対話型 CLI では選択自体に対してのみ出力され、そのセッションスコープの権限によって許可された以降の呼び出しでは代わりに `"config"` が出力されます。Agent SDK または非対話型の `-p` セッションでは、選択と以降の一致の両方で `"user_temporary"` が出力されます。承認として扱われます。
  * `"user_abort"`: ユーザーが応答せずに権限プロンプトを閉じたときに出力されます。Agent SDK および非対話型の `-p` セッションでは、`canUseTool` または `--permission-prompt-tool` の権限リクエストが保留中にターンを中断した場合も含まれます。v2.1.216 より前は、Claude Code はその中断を `"user_reject"` として報告していました。拒否として扱われます。
  * `"user_reject"`: プロンプトが表示されたときにユーザーが「No」を選択したときに出力されます。対話型 CLI では、その選択自体に対してのみ出力され、ユーザーの個人設定の拒否ルールに一致する呼び出しでは代わりに `"config"` が出力されます。Agent SDK または非対話型の `-p` セッションでは、個人設定の拒否ルールに一致する呼び出しで `"user_reject"` が出力されます。拒否として扱われます。
* `tool_parameters`（`OTEL_LOG_TOOL_DETAILS=1` の場合）: ツール固有のパラメーターを含む JSON 文字列。[ツール結果イベント](#tool-result-event)と同じ形式ですが、`git_commit_id` などの実行後のフィールドは含まれません。権限決定が `updatedInput` を介してツール入力を書き換えた場合、承認された呼び出しでは値が `tool_result` と異なることがあります。`decision` が `"reject"` の場合にどのコマンドが拒否されたかを確認するには、この属性を使用してください。
  * `"sdk_host_builtin_mcp"` ツールの場合: ホストアプリケーションがこれらの名前を定義しているため、`OTEL_LOG_TOOL_DETAILS` がオフの場合でも `mcp_server_name` と `mcp_tool_name` が含まれます。これらがなければ、これらの組み込みサーバーへの拒否された呼び出しをデフォルトのストリームで特定できなくなります。ユーザーが設定した MCP サーバーの場合、イベントの `tool_name` は常にリテラルの `"mcp_tool"` であり、サーバー名とツール名はフラグがオンの場合にのみ `tool_parameters` に表示されます。引数の内容はどの場合もフラグが必要です。Claude Code v2.1.214 以降が必要です
  * Bash ツールの場合: `bash_command`、`full_command`、`timeout`、`description`、`dangerouslyDisableSandbox` を含みます。デスクトップアプリのワークスペース Bash ツールも `tool_name` を `Bash` として報告しますが、`bash_command`、`full_command`、`timeout` のみを含みます
  * MCP ツールの場合: `mcp_server_name`、`mcp_tool_name` を含みます
  * Skill ツールの場合: `skill_name` を含みます
  * Agent ツールまたは従来の Task ツールの場合: `subagent_type` を含みます

<h4 id="permission-mode-changed-event">
  権限モード変更イベント
</h4>

権限モードが変更されたときにログに記録されます。たとえば、`Shift+Tab` による切り替え、plan モードの終了、auto モードのゲートチェックなどです。

**イベント名**: `claude_code.permission_mode_changed`

**属性**:

* すべての[標準属性](#standard-attributes)
* `event.name`: `"permission_mode_changed"`
* `event.timestamp`: ISO 8601 タイムスタンプ
* `event.sequence`: イベントを順序付けるためのプロセスごとのカウンター。[イベント相関属性](#event-correlation-attributes)で説明しています
* `from_mode`: 以前の権限モード。例: `"default"`、`"plan"`、`"acceptEdits"`、`"auto"`、`"bypassPermissions"`
* `to_mode`: 新しい権限モード
* `trigger`: 変更の原因。`"shift_tab"`、`"exit_plan_mode"`、`"auto_gate_denied"`、`"auto_opt_in"` のいずれかです。遷移が SDK またはブリッジから発生した場合は含まれません

<h4 id="auth-event">
  認証イベント
</h4>

`/login` または `/logout` が完了したときにログに記録されます。

**イベント名**: `claude_code.auth`

**属性**:

* すべての[標準属性](#standard-attributes)
* `event.name`: `"auth"`
* `event.timestamp`: ISO 8601 タイムスタンプ
* `event.sequence`: イベントを順序付けるためのプロセスごとのカウンター。[イベント相関属性](#event-correlation-attributes)で説明しています
* `action`: `"login"` または `"logout"`
* `success`: `"true"` または `"false"`
* `auth_method`: 認証方法。`"oauth"` など
* `error_category`: アクションが失敗した場合のエラーの種類のカテゴリ。生のエラーメッセージが含まれることはありません
* `status_code`: アクションが HTTP エラーで失敗した場合の、文字列としての HTTP ステータスコード

<h4 id="mcp-server-connection-event">
  MCP サーバー接続イベント
</h4>

MCP サーバーが接続、切断、または接続に失敗したときにログに記録されます。

**イベント名**: `claude_code.mcp_server_connection`

**属性**:

* すべての[標準属性](#standard-attributes)
* `event.name`: `"mcp_server_connection"`
* `event.timestamp`: ISO 8601 タイムスタンプ
* `event.sequence`: イベントを順序付けるためのプロセスごとのカウンター。[イベント相関属性](#event-correlation-attributes)で説明しています
* `status`: `"connected"`、`"failed"`、`"disconnected"` のいずれか
* `transport_type`: サーバーのトランスポート。`"stdio"`、`"sse"`、`"http"` など
* `server_scope`: サーバーが設定されているスコープ。`"user"`、`"project"`、`"local"` など
* `duration_ms`: 接続試行の所要時間（ミリ秒）
* `error_code`: 接続が失敗した場合のエラーコード
* `is_plugin`: サーバーがプラグインによって提供されている場合は `true`、それ以外は `false`
* `plugin_id_hash`（`is_plugin` が `true` の場合）: プラグイン名とマーケットプレイスの安定したハッシュ。名前を公開せずにプラグインごとにイベントをグループ化するために使用します。Claude Code は[プラグイン読み込みイベント](#plugin-loaded-event)で説明している方法でこれを計算します
* `plugin.name`（`is_plugin` が `true` の場合）: サーバーを提供するプラグインの名前。サードパーティのプラグインの場合、`OTEL_LOG_TOOL_DETAILS=1` でない限り、これはリテラル文字列 `"third-party"` になります。これにより、デフォルトではサードパーティのプラグイン名がログに表示されないよう保護されます。Anthropic の公式ソースのプラグインは常に名前で識別されます。`plugin_id_hash` と `plugin.name` の属性は独自の監視バックエンドに送信され、Anthropic には送信されません
* `server_name`（`OTEL_LOG_TOOL_DETAILS=1` の場合）: 設定されたサーバー名
* `error`（`OTEL_LOG_TOOL_DETAILS=1` の場合）: 接続が失敗した場合の完全なエラーメッセージ

<h4 id="internal-error-event">
  内部エラーイベント
</h4>

Claude Code が予期しない内部エラーを捕捉したときにログに記録されます。エラークラス名と errno 形式のコードのみが記録されます。エラーメッセージとスタックトレースが含まれることはありません。このイベントは、Amazon Bedrock、Google Cloud の Agent Platform、Microsoft Foundry に対して実行している場合、または `DISABLE_ERROR_REPORTING` が設定されている場合は出力されません。

**イベント名**: `claude_code.internal_error`

**属性**:

* すべての[標準属性](#standard-attributes)
* `event.name`: `"internal_error"`
* `event.timestamp`: ISO 8601 タイムスタンプ
* `event.sequence`: イベントを順序付けるためのプロセスごとのカウンター。[イベント相関属性](#event-correlation-attributes)で説明しています
* `error_name`: エラークラス名。`"TypeError"` や `"SyntaxError"` など
* `error_code`: エラーに存在する場合の Node.js の errno コード（`"ENOENT"` など）

<h4 id="plugin-installed-event">
  プラグインインストールイベント
</h4>

プラグインのインストールが完了したときにログに記録されます。`claude plugin install` CLI コマンドと対話型の `/plugin` UI の両方が対象です。

**イベント名**: `claude_code.plugin_installed`

**属性**:

* すべての[標準属性](#standard-attributes)
* `event.name`: `"plugin_installed"`
* `event.timestamp`: ISO 8601 タイムスタンプ
* `event.sequence`: イベントを順序付けるためのプロセスごとのカウンター。[イベント相関属性](#event-correlation-attributes)で説明しています
* `marketplace.is_official`: マーケットプレイスが Anthropic の公式マーケットプレイスの場合は `"true"`、それ以外は `"false"`
* `install.trigger`: `"cli"` または `"ui"`
* `plugin.name`: インストールされたプラグインの名前。サードパーティのマーケットプレイスの場合は、`OTEL_LOG_TOOL_DETAILS=1` の場合にのみ含まれます
* `plugin.version`: マーケットプレイスのエントリで宣言されている場合のプラグインのバージョン。サードパーティのマーケットプレイスの場合は、`OTEL_LOG_TOOL_DETAILS=1` の場合にのみ含まれます
* `marketplace.name`: プラグインのインストール元のマーケットプレイス。サードパーティのマーケットプレイスの場合は、`OTEL_LOG_TOOL_DETAILS=1` の場合にのみ含まれます

<h4 id="plugin-loaded-event">
  プラグイン読み込みイベント
</h4>

セッションの開始時に、有効化されているプラグインごとに 1 回ログに記録されます。インストール操作自体を記録する `plugin_installed` を補完するものとして、このイベントを使用してフリート全体でどのプラグインがアクティブかを把握できます。

**イベント名**: `claude_code.plugin_loaded`

**属性**:

* すべての[標準属性](#standard-attributes)
* `event.name`: `"plugin_loaded"`
* `event.timestamp`: ISO 8601 タイムスタンプ
* `event.sequence`: イベントを順序付けるためのプロセスごとのカウンター。[イベント相関属性](#event-correlation-attributes)で説明しています
* `plugin.name`: プラグインの名前。公式マーケットプレイスおよび組み込みバンドル以外のプラグインの場合、`OTEL_LOG_TOOL_DETAILS=1` でない限り値は `"third-party"` になります
* `marketplace.name`: 判明している場合の、プラグインのインストール元のマーケットプレイス。`plugin.name` と同じ条件で `"third-party"` に秘匿化されます
* `plugin.version`: プラグインマニフェストのバージョン。名前が秘匿化されておらず、マニフェストでバージョンが宣言されている場合にのみ含まれます
* `plugin.scope`: プラグインの出自カテゴリ。`"official"`、`"community"`、`"org"`、`"user-local"`、`"default-bundle"` のいずれか
* `enabled_via`: プラグインが有効化された経緯。`"default-enable"`、`"org-policy"`、`"admin-install"`、`"seed-mount"`、`"user-install"` のいずれかです。`"admin-install"` の値は、[**Organization settings > Plugins & skills**](https://claude.ai/admin-settings/skills?tab=inventory) でプラグインが組織に対して必須または自動インストールに設定されていることを意味します。v2.1.246 より前は、Claude Code はこれらのプラグインを `"user-install"` または `"seed-mount"` として報告していました
* `plugin_id_hash`: プラグイン名とマーケットプレイスの決定論的なハッシュ。設定したエクスポーターにのみ送信されます。名前を記録せずに、フリート全体で読み込まれた個別のサードパーティプラグインの数をカウントできます。[claude.ai から同期されたプラグイン](/docs/ja/plugins/loading#synced-plugins)の場合、Claude Code は、claude.ai がそのプラグインについて報告するマーケットプレイス名、それがない場合は `synced` とプラグイン名を組み合わせてハッシュします。v2.1.246 より前は、Claude Code は claude.ai が報告するマーケットプレイス名をハッシュに使用していませんでした
* `has_hooks`: プラグインがフックを提供するかどうか
* `has_mcp`: プラグインが MCP サーバーを提供するかどうか
* `host_owned_mcp`: SDK ホストがこのプラグインの MCP 接続を管理しており、Claude Code がプラグインの MCP サーバー設定の読み取りをスキップした場合は `true`、それ以外は `false`。Claude Code v2.1.172 以降が必要です
* `skill_path_count`: プラグインが宣言するスキルディレクトリの数
* `command_path_count`: プラグインが宣言するコマンドディレクトリの数
* `agent_path_count`: プラグインが宣言するエージェントディレクトリの数
* `safe_mode`: セッションが [`--safe-mode`](/docs/ja/cli-reference) で開始された場合は `"true"`、それ以外は `"false"`。safe モードでは、このイベントは設定されたインベントリのみを報告し、プラグインのコマンド、スキル、フック、MCP サーバーは読み込まれません。Claude Code v2.1.169 以降が必要です

<h4 id="skill-activated-event">
  スキル有効化イベント
</h4>

スキルが呼び出されたときにログに記録されます。Claude が Skill ツールを通じて呼び出した場合と、ユーザーが `/` コマンドとして実行した場合の両方が対象です。

**イベント名**: `claude_code.skill_activated`

**属性**:

* すべての[標準属性](#standard-attributes)
* `event.name`: `"skill_activated"`
* `event.timestamp`: ISO 8601 タイムスタンプ
* `event.sequence`: イベントを順序付けるためのプロセスごとのカウンター。[イベント相関属性](#event-correlation-attributes)で説明しています
* `skill.name`: スキルの名前。ユーザー定義およびサードパーティのプラグインのスキルの場合、`OTEL_LOG_TOOL_DETAILS=1` でない限り値はプレースホルダーの `"custom_skill"` になります
* `invocation_trigger`: スキルがトリガーされた方法（`"user-slash"`、`"claude-proactive"`、`"nested-skill"`）
* `skill.source`: スキルの読み込み元（例: `"bundled"`、`"userSettings"`、`"projectSettings"`、`"plugin"`）
* `skill.kind`: スキルがワークフロースキルの場合は `"workflow"`。それ以外の場合は含まれません
* `plugin.name`（`OTEL_LOG_TOOL_DETAILS=1` の場合、またはプラグインが公式マーケットプレイスのものの場合）: スキルがプラグインによって提供されている場合の、所有元のプラグインの名前
* `marketplace.name`（`OTEL_LOG_TOOL_DETAILS=1` の場合、またはプラグインが公式マーケットプレイスのものの場合）: スキルがプラグインによって提供されている場合の、所有元のプラグインのインストール元のマーケットプレイス

<h4 id="at-mention-event">
  @ メンションイベント
</h4>

Claude Code がプロンプト内の `@` メンションを解決したときにログに記録されます。すべてのメンションでイベントが出力されるわけではありません。権限の拒否、サイズが大きすぎるファイル、PDF の参照添付、ディレクトリ一覧の取得失敗などの早期終了パスでは、ログに記録せずに戻ります。

**イベント名**: `claude_code.at_mention`

**属性**:

* すべての[標準属性](#standard-attributes)
* `event.name`: `"at_mention"`
* `event.timestamp`: ISO 8601 タイムスタンプ
* `event.sequence`: イベントを順序付けるためのプロセスごとのカウンター。[イベント相関属性](#event-correlation-attributes)で説明しています
* `mention_type`: メンションの種類（`"file"`、`"directory"`、`"agent"`、`"mcp_resource"`、`"peer"`）。`"peer"` の値は、[ユーザーの他の Claude Code セッションのいずれか](/docs/ja/cross-session-messaging)をメンションしたことを意味します。Claude Code v2.1.232 以降が必要です
* `success`: メンションが正常に解決されたかどうか（`"true"` または `"false"`）

<h4 id="api-retries-exhausted-event">
  API 再試行上限到達イベント
</h4>

API リクエストが複数回の試行の後に失敗したときに 1 回ログに記録されます。最後の `api_error` イベントと一緒に出力されます。

**イベント名**: `claude_code.api_retries_exhausted`

**属性**:

* すべての[標準属性](#standard-attributes)
* `event.name`: `"api_retries_exhausted"`
* `event.timestamp`: ISO 8601 タイムスタンプ
* `event.sequence`: イベントを順序付けるためのプロセスごとのカウンター。[イベント相関属性](#event-correlation-attributes)で説明しています
* `model`: 使用されたモデル
* `error`: 最終的なエラーメッセージ
* `status_code`: 数値としての HTTP ステータスコード。HTTP 以外のエラーの場合は含まれません。
* `total_attempts`: 試行の合計回数
* `total_retry_duration_ms`: すべての試行にわたる合計の実経過時間
* `speed`: `"fast"` または `"normal"`

<h4 id="hook-registered-event">
  フック登録イベント
</h4>

セッションの開始時に、設定されたフックごとに 1 回ログに記録されます。実行ごとの `hook_execution_start` および `hook_execution_complete` イベントを補完するものとして、このイベントを使用してフリート全体でどのフックがアクティブかを把握できます。

**イベント名**: `claude_code.hook_registered`

**属性**:

* すべての[標準属性](#standard-attributes)
* `event.name`: `"hook_registered"`
* `event.timestamp`: ISO 8601 タイムスタンプ
* `event.sequence`: イベントを順序付けるためのプロセスごとのカウンター。[イベント相関属性](#event-correlation-attributes)で説明しています
* `hook_event`: フックイベントの種類。`"PreToolUse"` や `"PostToolUse"` など
* `hook_type`: フックの実装の種類。`"command"`、`"prompt"`、`"mcp_tool"`、`"http"`、`"agent"` のいずれか
* `hook_source`: フックが定義されている場所。`"userSettings"`、`"projectSettings"`、`"localSettings"`、`"flagSettings"`、`"policySettings"`、`"pluginHook"` のいずれか
* `safe_mode`: セッションが [`--safe-mode`](/docs/ja/cli-reference) で開始された場合は `"true"`、それ以外は `"false"`。Claude Code v2.1.169 以降が必要です
* `hook_matcher`（`OTEL_LOG_TOOL_DETAILS=1` の場合）: フック設定で matcher が設定されている場合の matcher 文字列
* `plugin.name`（`hook_source` が `"pluginHook"` の場合）: フックを提供するプラグインの名前。公式マーケットプレイスおよび組み込みバンドル以外のプラグインの場合、`OTEL_LOG_TOOL_DETAILS=1` でない限り値は `"third-party"` になります
* `plugin_id_hash`（`hook_source` が `"pluginHook"` の場合）: プラグイン名とマーケットプレイスの決定論的なハッシュ。設定したエクスポーターにのみ送信されます。名前を記録せずに、フックを提供する個別のプラグインの数をカウントできます。Claude Code は[プラグイン読み込みイベント](#plugin-loaded-event)で説明している方法でこれを計算します

<h4 id="hook-execution-start-event">
  フック実行開始イベント
</h4>

フックイベントに対して 1 つ以上のフックの実行が開始されたときにログに記録されます。

**イベント名**: `claude_code.hook_execution_start`

**属性**:

* すべての[標準属性](#standard-attributes)
* `event.name`: `"hook_execution_start"`
* `event.timestamp`: ISO 8601 タイムスタンプ
* `event.sequence`: イベントを順序付けるためのプロセスごとのカウンター。[イベント相関属性](#event-correlation-attributes)で説明しています
* `hook_event`: フックイベントの種類。`"PreToolUse"` や `"PostToolUse"` など
* `hook_name`: matcher を含む完全なフック名。`"PreToolUse:Write"` など
* `num_hooks`: 一致したフックコマンドの数
* `managed_only`: 管理ポリシーのフックのみが許可されている場合は `"true"`
* `hook_source`: `"policySettings"` または `"merged"`
* `safe_mode`: セッションが [`--safe-mode`](/docs/ja/cli-reference) で開始された場合は `"true"`、それ以外は `"false"`。Claude Code v2.1.169 以降が必要です
* `hook_definitions`: JSON シリアライズされたフック設定。詳細なベータトレースと `OTEL_LOG_TOOL_DETAILS=1` の両方が有効な場合にのみ含まれます

<h4 id="hook-execution-complete-event">
  フック実行完了イベント
</h4>

フックイベントに対するすべてのフックが完了したときにログに記録されます。

**イベント名**: `claude_code.hook_execution_complete`

**属性**:

* すべての[標準属性](#standard-attributes)
* `event.name`: `"hook_execution_complete"`
* `event.timestamp`: ISO 8601 タイムスタンプ
* `event.sequence`: イベントを順序付けるためのプロセスごとのカウンター。[イベント相関属性](#event-correlation-attributes)で説明しています
* `hook_event`: フックイベントの種類
* `hook_name`: matcher を含む完全なフック名
* `num_hooks`: 一致したフックコマンドの数
* `num_success`: 正常に完了した数
* `num_blocking`: ブロッキングの決定を返した数
* `num_non_blocking_error`: ブロックせずに失敗した数
* `num_cancelled`: 完了前にキャンセルされた数
* `total_duration_ms`: 一致したすべてのフックの実経過時間
* `stdout_chars`: 成功した一致フック全体の stdout の合計文字数。Claude Code v2.1.280 以降が必要です
* `additional_context_chars`: 一致したフックが返した `additionalContext` の合計文字数。Claude Code v2.1.280 以降が必要です
* `system_message_chars`: 一致したフックが返した `systemMessage` の合計文字数。Claude Code v2.1.280 以降が必要です
* `initial_user_message_chars`: 一致したフックが返した `initialUserMessage` の合計文字数。Claude Code v2.1.280 以降が必要です
* `num_outputs_persisted`: [10,000 文字の上限](/docs/ja/hooks#json-output)を超えたために Claude Code がファイルに保存したフック出力の数。Claude Code v2.1.280 以降が必要です
* `managed_only`: 管理ポリシーのフックのみが許可されている場合は `"true"`
* `hook_source`: `"policySettings"` または `"merged"`
* `safe_mode`: セッションが [`--safe-mode`](/docs/ja/cli-reference) で開始された場合は `"true"`、それ以外は `"false"`。Claude Code v2.1.169 以降が必要です
* `hook_definitions`: JSON シリアライズされたフック設定。詳細なベータトレースと `OTEL_LOG_TOOL_DETAILS=1` の両方が有効な場合にのみ含まれます

<h4 id="hook-plugin-metrics-event">
  フックプラグインメトリクスイベント
</h4>

公式マーケットプレイスのプラグインのフックが呼び出しごとのメトリクスを出力したときにログに記録されます。これを出力できるのは、Anthropic の公式マーケットプレイスからインストールされたプラグインのみです。サードパーティのマーケットプレイスのプラグインやユーザーが設定したフックは、このイベントに出力しません。このイベントを使用すると、検出率、コスト、所要時間などのプラグインの挙動を独自のオブザーバビリティスタックから監視できます。

**イベント名**: `claude_code.hook_plugin_metrics`

**属性**:

* すべての[標準属性](#standard-attributes)
* `event.name`: `"hook_plugin_metrics"`
* `event.timestamp`: ISO 8601 タイムスタンプ
* `event.sequence`: イベントを順序付けるためのプロセスごとのカウンター。[イベント相関属性](#event-correlation-attributes)で説明しています
* `plugin_id`: `<name>@<marketplace>` 形式のプラグイン識別子
* `hook_event`: メトリクスを出力したフックイベントの種類
* プラグインが出力する最大 20 個のメトリクスキー。名前は `^[a-z][a-z0-9_]{0,39}$` に一致します。値はブール値または数値です。

<h4 id="compaction-event">
  コンテキスト圧縮イベント
</h4>

会話のコンテキスト圧縮が完了したときにログに記録されます。

**イベント名**: `claude_code.compaction`

**属性**:

* すべての[標準属性](#standard-attributes)
* `event.name`: `"compaction"`
* `event.timestamp`: ISO 8601 タイムスタンプ
* `event.sequence`: イベントを順序付けるためのプロセスごとのカウンター。[イベント相関属性](#event-correlation-attributes)で説明しています
* `trigger`: `"auto"` または `"manual"`
* `success`: `"true"` または `"false"`
* `duration_ms`: 圧縮の所要時間
* `pre_tokens`: 圧縮前のおおよそのトークン数
* `post_tokens`: 圧縮後のおおよそのトークン数
* `error`: 圧縮が失敗した場合のエラーメッセージ
* `precompute_reuse`: `trigger` が `"manual"` の場合にのみ設定されます。自動圧縮では、コンテキストウィンドウがいっぱいになる前にバックグラウンドで要約を準備できます。この属性は、`/compact` がその準備済みの要約を再利用したかどうかを記録します。`"hit"` は再利用されたことを意味し、`"miss_custom_instructions"`、`"miss_hook"`、`"miss_not_ready"` は代わりに新しい要約が計算された理由を示します。Claude Code v2.1.153 以降が必要です

<h4 id="subagent-completed-event">
  サブエージェント完了イベント
</h4>

[サブエージェント](/docs/ja/sub-agents)が終了し、その結果を起動元の会話に返したときに記録されます。サブエージェントの種類ごとにツール使用と実行時間を集計する用途に使用します。トークンやコストを集計する場合は、`query_source` を `"subagent"` でフィルタリングした [トークンカウンター](#token-counter)と[コストカウンター](#cost-counter)を使用してください。このイベントの `total_tokens` は最後のリクエストのみを対象とするためです。`"subagent"` カテゴリには、エージェントベースのフックからのリクエストも含まれますが、これらはサブエージェントイベントを出力しません。

**イベント名**: `claude_code.subagent_completed`

**属性**:

* すべての[標準属性](#standard-attributes)
* `event.name`: `"subagent_completed"`
* `event.timestamp`: ISO 8601 タイムスタンプ
* `event.sequence`: イベントを順序付けるためのプロセスごとのカウンター。[イベント相関属性](#event-correlation-attributes)で説明しています
* `agent_type`: サブエージェントの種類。組み込みエージェント名と公式マーケットプレイスのプラグインからのエージェントはそのまま表示されます。その他のエージェント名は、`OTEL_LOG_TOOL_DETAILS=1` が設定されていない限り `"custom"` に置き換えられます
* `agent.source`: エージェント定義の取得元。`built-in`、`plugin`、またはカスタムエージェントを定義した設定ソース（`userSettings` や `projectSettings` など）
* `is_built_in`: サブエージェントが組み込みのエージェントタイプかどうか
* `is_async`: サブエージェントが[バックグラウンド](/docs/ja/sub-agents#run-subagents-in-foreground-or-background)で実行されたかどうか
* `total_tokens`: サブエージェントの最後の API リクエストのトークン量。その 1 つのリクエストの入力、キャッシュ作成、キャッシュ読み取り、出力トークンであり、完了時点のサブエージェントのコンテキストサイズにおおよそ相当します。実行全体の合計ではありません
* `total_tool_uses`: サブエージェントが実行全体で行ったツール呼び出しの数
* `duration_ms`: 実行時間（ミリ秒）
* `model`: サブエージェントの実行に解決されたモデル
* `final_model`: サブエージェントの最終応答を生成したモデル。フォールバックなど実行途中で切り替えがあった場合は `model` と異なります。Claude Code v2.1.212 以降が必要です
* `model_swapped`: サブエージェントのリクエストを複数のモデルが処理したかどうか。Claude Code v2.1.212 以降が必要です
* `plugin_id_hash`、`plugin.name`: プラグインが提供するエージェントの場合に存在します。公式マーケットプレイスのプラグイン名はそのまま表示されます。その他のプラグイン名は、`OTEL_LOG_TOOL_DETAILS=1` が設定されていない限り `"third-party"` に置き換えられます

<h4 id="feedback-survey-event">
  フィードバックアンケートイベント
</h4>

セッション品質アンケートが表示されたとき、または回答されたときに記録されます。アンケートで収集される内容とその制御方法については、[セッション品質アンケート](/docs/ja/data-usage#session-quality-surveys)を参照してください。

**イベント名**: `claude_code.feedback_survey`

**属性**:

* すべての[標準属性](#standard-attributes)
* `event.name`: `"feedback_survey"`
* `event.timestamp`: ISO 8601 タイムスタンプ
* `event.sequence`: イベントを順序付けるためのプロセスごとのカウンター。[イベント相関属性](#event-correlation-attributes)で説明しています
* `event_type`: アンケートのライフサイクルイベント。例: `"appeared"`、`"responded"`、`"transcript_prompt_appeared"`
* `appearance_id`: 1 つのアンケートインスタンスに対して出力されたイベントを結び付ける一意の ID
* `survey_type`: イベントを生成したアンケート。`"session"` は「Claude の調子はどうですか？」という評価プロンプトです
* `response`: `responded` イベントにおけるユーザーの選択
* `enabled_via_override`: [`CLAUDE_CODE_ENABLE_FEEDBACK_SURVEY_FOR_OTEL`](/docs/ja/env-vars) が設定されている場合は `true`。文字列ではなくブール値として出力されます。`session` アンケートイベントに存在します。この属性でフィルタリングすると、上書きがフリート全体に適用されていることを確認できます

<h4 id="retention-sweep-event">
  保持期間スイープイベント
</h4>

保持期間クリーンアップスイープの実行ごとに 1 回記録されます。このスイープは、[`cleanupPeriodDays`](/docs/ja/settings-reference#cleanupperioddays) 設定よりも古い[セッショントランスクリプトやその他のアプリケーションデータ](/docs/ja/claude-directory#cleaned-up-automatically)を削除します。Claude Code はセッションごとに最大 1 回、バックグラウンドでスイープを実行し、何も削除しなかった実行でもイベントを出力します。同じマシン上のいずれかのセッションで過去 24 時間以内に Claude Code がスイープを実行していた場合、このセッションのスイープは少なくとも 10 分遅延されるため、それより早く終了したセッションは何も出力しません。`claude -p` を `--bare` とともに実行した場合、Claude Code はスイープを実行せず、何も出力しません。

このページのすべての OTel イベントと同様に、このイベントは設定したテレメトリバックエンドにのみ送信されます。Claude Code v2.1.227 以降が必要です。

Claude Code が保持期間を安全に判断できない場合、スイープを一時停止し、`result` を `"skipped"` に設定し、`skip_reason` を付けてイベントを出力します。[管理設定](/docs/ja/server-managed-settings)で `cleanupPeriodDays` が設定されている場合は、管理設定の値によって保持期間が固定され、より優先度の低いスコープの設定ファイルが壊れていたり無効であったりしてもスイープは実行されます。`managed-settings.json` 自体を読み取れない場合、[管理層](/docs/ja/managed-settings#how-claude-code-combines-managed-sources)がサーバー管理設定や壊れたファイルの隣にある `managed-settings.d/` ドロップインなど、他の場所から `cleanupPeriodDays` を提供しない限り、Claude Code はスイープを一時停止します。削除カウンター属性は、`result` が `"complete"` の場合にのみ存在します。

**イベント名**: `claude_code.retention_sweep`

**属性**:

* すべての[標準属性](#standard-attributes)
* `event.name`: `"retention_sweep"`
* `event.timestamp`: ISO 8601 タイムスタンプ
* `event.sequence`: イベントを順序付けるためのプロセスごとのカウンター。[イベント相関属性](#event-correlation-attributes)で説明しています
* `result`: スイープが実行された場合は `"complete"`、Claude Code が一時停止した場合は `"skipped"`
* `period_days`: マージされた設定の `cleanupPeriodDays` の値（日数）。どのソースでも設定されていない場合は `30`。skipped イベントでは、Claude Code が読み取れた設定ソースから算出した、スイープが使用するはずだった値
* `used_default`: 読み取り可能な設定ソースのいずれでも `cleanupPeriodDays` が設定されていない場合は `"true"`、それ以外は `"false"`。complete イベントでは、`"true"` は 30 日のデフォルトが適用されたことを意味します
* `skip_reason`: Claude Code がスイープを一時停止した理由。`result` が `"skipped"` の場合にのみ存在します:
  * `"user_source_disabled"`: [`--setting-sources`](/docs/ja/cli-reference#cli-flags) フラグや SDK の [`settingSources`](/docs/ja/agent-sdk/typescript#options) オプションなどによってユーザー設定が除外されており、有効なソースのいずれも `cleanupPeriodDays` を提供していない
  * `"settings_unknowable"`: 設定ファイルを読み取りまたは解析できなかったため、`cleanupPeriodDays` または `desktopSessionCleanupPeriodDays` が Claude Code から見えない値に設定されている可能性がある
  * `"settings_invalid_key_set"`: 設定に検証エラーがあり、かつ `cleanupPeriodDays` または `desktopSessionCleanupPeriodDays` が明示的に設定されているため、デフォルトにフォールバックするとその設定に反してファイルを削除または保持してしまう可能性がある
* `transcripts_deleted`: スイープが削除したセッショントランスクリプト（最上位の `~/.claude/projects/*/*.jsonl` ファイル）の数
* `transcripts_exempted_desktop`: 保持期間を過ぎているものの、[Claude Desktop と Cowork のルール](/docs/ja/claude-directory#cleaned-up-automatically)によりスイープが保持したトランスクリプトの数。これらは `files_past_cutoff` にはカウントされません。Claude Code v2.1.248 以降が必要です
* `session_files_deleted`: セッションファイルスイープが削除したアーティファクトの数。トランスクリプトに加え、サイドカー、録画、ツール結果などのセッションごとの付随ファイルを含みます
* `artifacts_deleted`: スイープが対象とするデータディレクトリ全体で削除した項目の合計（セッションファイルを含む）。一部のスイープは削除したディレクトリツリー全体を 1 項目としてカウントし、いくつかのクリーンアップパスはカウンターに加算されないため、この値は正確なファイル数ではなく下限値として扱ってください
* `files_retained_fresh`: 検査されたものの、まだ保持期間内であるためそのまま残されたファイル。ファイル単位のスイープのみがこれらをカウントするため、この値は下限値です。ゼロ以外の値は通常の定常状態です
* `files_past_cutoff`: 保持期間より古いものの、権限エラーやファイルが開かれたままであることなどが原因でスイープが削除に失敗したファイル。ゼロより大きい値は、設定された保持期間を超えてファイルが残ったことを意味します。ただし、ディレクトリ全体の削除に失敗した場合は代わりに `error_count` にカウントされるため、ゼロであってもそのようなファイルがないことの証明にはなりません
* `error_count`: ファイルの一覧取得または削除中にスイープが遭遇したエラーの数

<h4 id="managed-settings-resolved-event">
  管理設定解決イベント
</h4>

セッションが解決した[管理設定](/docs/ja/managed-settings)とともに記録されます。セッション開始時に 1 回、セッション中に管理設定または[ポリシーヘルパー](/docs/ja/managed-settings#compute-the-policy-with-a-helper-program)の状態が変化したときに再度、そして `error.type` 属性に列挙されている理由のいずれかにより Claude Code が起動を拒否するかセッションを終了したときに記録されます。
このイベントを使用して、予期しない管理ソースで実行されているマシン、ポリシーヘルパーが失敗しているマシン、およびマシンが起動を拒否した理由を特定できます。
Claude Code v2.1.274 以降が必要です。

デフォルトでは、このイベントには管理ソースとポリシーヘルパーの状態が含まれますが、設定自体は含まれません。編集済みの `managed_settings.settings` 属性と `managed_settings.resolved_sha256` ダイジェストを追加するには、`OTEL_LOG_MANAGED_SETTINGS=1` を設定します:

* 管理設定、ユーザー設定、または `--settings` の `env` ブロック、あるいは Claude Code を起動する環境で設定してください。プロジェクト設定やローカル設定の値では有効になりません。クローンしたリポジトリがこれらを書き込めるためです。
* サーバー管理設定では、[セキュリティ承認ダイアログ](/docs/ja/server-managed-settings#security-approval-dialogs)を表示せずにこれを設定できます。この変数は、組織がすでに受け取っているイベントに、組織自身の編集済みポリシーを追加するだけだからです。

[信頼](/docs/ja/permissions#what-runs-before-you-trust-a-folder)していないフォルダーでの対話型セッションでは、Claude Code は拒否イベントをエクスポートしません。

**イベント名**: `claude_code.managed_settings_resolved`

**属性**:

* すべての[標準属性](#standard-attributes)
* `event.name`: `"managed_settings_resolved"`
* `event.timestamp`: ISO 8601 タイムスタンプ
* `event.sequence`: イベントを順序付けるためのプロセスごとのカウンター。[イベント相関属性](#event-correlation-attributes)で説明しています
* `managed_settings.trigger`: セッション開始時のイベントの場合は `"startup"`、セッションの後半で管理設定またはポリシーヘルパーの状態が変化した場合は `"change"`、管理設定ポリシーによってセッションが停止された場合は `"refused"`。Claude Code は、最後に送信したイベントと属性が異なる場合にのみ `change` イベントを送信します。設定値の変更は、`OTEL_LOG_MANAGED_SETTINGS` がオフの場合でもカウントされます
* `error.type`: Claude Code がセッションを停止した理由。`refused` イベントにのみ存在します:
  * `"helper_failed"`: [ポリシーヘルパーの実行が失敗した](/docs/ja/settings-reference#helper-failures)
  * `"policy_invalid"`: 管理設定に Claude Code の起動を妨げるエラーが含まれている、または管理ソースが読み取り拒否以外の理由で読み込みに失敗したため、Claude Code が組織ログインやプロバイダーの強制を確認できない
  * `"provider_not_allowed"`: セッションが、管理設定の [`allowedProviders`](/docs/ja/settings-reference#allowedproviders) リストで許可されていない API プロバイダーを使用する、またはプロバイダーのトラフィックを許可されていないホストに送信しようとしている。Claude Code v2.1.285 以降が必要です
  * `"consent_rejected"`: ユーザーがサーバー管理設定の[セキュリティ承認ダイアログ](/docs/ja/server-managed-settings#security-approval-dialogs)を拒否した
  * `"force_refresh_failed"`: [`forceRemoteSettingsRefresh`](/docs/ja/settings-reference#forceremotesettingsrefresh) が必要とする設定の取得に失敗した
  * `"gateway_rejected"`: [Claude apps ゲートウェイ](/docs/ja/claude-apps-gateway)が管理設定の読み込みに HTTP 403 で応答した
  * `"version_below_minimum"`: この Claude Code のバージョンが [`requiredMinimumVersion`](/docs/ja/settings-reference#requiredminimumversion) を下回っているか、[`requiredMaximumVersion`](/docs/ja/settings-reference#requiredmaximumversion) を上回っている
  * `"_OTHER"`: Claude apps ゲートウェイの管理設定の読み込みがその他の理由で失敗した
* `managed_settings.sources`: 少なくとも 1 つの[ポリシーキー](/docs/ja/managed-settings#how-claude-code-combines-managed-sources)を提供するすべての管理ソース。優先度の高い順に並び、`first-wins` の下でキーが有効にならないソースも含まれます。値は、MDM または OS レベルのポリシーの場合は `"remote"`、`"plist"`、または `"hklm"`、管理設定ファイルとドロップインの場合は `"file"`、[埋め込みホスト](/docs/ja/managed-settings#let-an-embedding-host-add-policy)が設定を提供する場合は `"parent"`、Claude Code が [Windows HKCU レジストリ値](/docs/ja/managed-settings#where-each-mechanism-stores-the-policy)を[読み取る](/docs/ja/managed-settings#how-claude-code-combines-managed-sources)場合は `"hkcu"` です。制御キーのみを含むソースや、Claude Code が読み取れなかったソースは一覧に含まれません。文字列の配列として出力され、ポリシーキーを提供する管理ソースがない場合は空になります
* `managed_settings.source_behavior`: Claude Code が読み取った [`managedSourcesBehavior`](/docs/ja/settings-reference#managedsourcesbehavior) の値で、`"first-wins"` または `"merge"`。どのソースでもこのキーが設定されていない場合は `"first-wins"`
* `managed_settings.helper.state`: 選択された MDM またはファイルソースが設定するポリシーヘルパーの状態:
  * `"ok"`: ヘルパーの出力が管理設定として使用されている
  * `"bad_path"`、`"not_a_file"`、`"exit_nonzero"`、`"timed_out"`、`"oversize"`、`"parse_failed"`、`"envelope_invalid"`、または `"schema_rejected"`: ヘルパーの最後の実行が失敗した。各ケースについては[ヘルパーの失敗](/docs/ja/settings-reference#helper-failures)で説明しています
  * `"none"`: ヘルパーが設定されていない、またはヘルパーを設定するソースが MDM ポリシーや管理設定ファイルではない
* `managed_settings.helper.applied`: ヘルパー自身の出力が管理設定として使用されている間は `"output"`、そうでない場合は `"none"`
* `managed_settings.helper.entry`: Claude Code が [`policyHelper`](/docs/ja/settings-reference#policyhelper) を選択した場合は `"policyHelper"`。ヘルパーを選択しなかった場合は存在しません
* `managed_settings.helper.path`: ヘルパーに設定された [`path`](/docs/ja/settings-reference#policyhelper-path)。Claude Code がヘルパーを選択した場合は、`OTEL_LOG_MANAGED_SETTINGS` が設定されているかどうかにかかわらず常に存在します
* `managed_settings.resolved_sha256`（`OTEL_LOG_MANAGED_SETTINGS=1` の場合）: 編集前の解決済み管理設定の SHA-256。キーを再帰的にソートし、空白なしの JSON としてシリアル化したものです。同じダイジェストを持つマシンは同じポリシーで実行されています。短いポリシーは推測値をハッシュ化することで復元できてしまうため、Claude Code はオプトインした場合にのみダイジェストを送信します。管理設定が解決されなかった場合、および `refused` イベントでは存在しません
* `managed_settings.settings`（`OTEL_LOG_MANAGED_SETTINGS=1` の場合）: 解決済み管理設定の名前と構造を、値を編集した JSON 文字列として表したもの。`refused` イベントでは存在しません。Claude Code は設定スキーマに基づいてこれを構築します:

  * スキーマで宣言されている設定名はエクスポートされ、宣言されていないキーは除外されます
  * ブール値、数値、およびスキーマが固定の選択肢に制限している文字列値（`permissions.defaultMode` など）はそのままエクスポートされます。`sandbox.network.httpProxyPort` と `sandbox.network.socksProxyPort` は `"[REDACTED]"` としてエクスポートされます
  * `model`、`apiKeyHelper`、すべての `env` の値、すべての URL、すべてのコマンドなど、その他のすべての文字列は `"[REDACTED]"` としてエクスポートされます
  * `env` の変数名やプラグイン ID など、マップのエントリ名はそのままエクスポートされます。`vimInsertModeRemaps` など、スキーマがエントリの型を定義していない設定は単一の `"[REDACTED]"` としてエクスポートされ、`sandbox.ignoreViolations` はコマンドパターンを除いたパスリストのリストとしてエクスポートされます
  * リストは長さを保持し、各エントリは同じルールで編集されます
  * `permissions.allow`、`permissions.deny`、または `permissions.ask` のルールは、ツールがこのバージョンの Claude Code に組み込まれている場合、または `mcp__jira__create_issue` のような `mcp__` 参照である場合、`Read([REDACTED])` のように内容を編集したツール名としてエクスポートされます。その他のルールは `"[REDACTED]"` としてエクスポートされます
  * フックも同じルールに従うため、`type` や `timeout` などの固定選択肢のフィールドや数値フィールドは表示されますが、各コマンド、URL、`matcher`、`if` 条件は `"[REDACTED]"` としてエクスポートされます

  たとえば、`apiKeyHelper`、2 つの `env` 変数、および拒否ルールを含む管理設定は、`{"apiKeyHelper":"[REDACTED]","env":{"HTTPS_PROXY":"[REDACTED]","CLAUDE_CODE_ENABLE_TELEMETRY":"[REDACTED]"},"permissions":{"deny":["Read([REDACTED])"]}}` としてエクスポートされます。

  Claude Code は値を UTF-8 で 8 KB に切り詰め、切り詰められた値は有効な JSON ではありません
* `managed_settings.settings_truncated`（`managed_settings.settings` が存在する場合）: Claude Code が `managed_settings.settings` を 8 KB で切り詰めた場合は `true`、それ以外は `false`。文字列ではなくブール値として出力されます

<h2 id="interpret-metrics-and-events-data">
  メトリクスとイベントデータの解釈
</h2>

エクスポートされたメトリクスとイベントは、さまざまな分析をサポートします:

<h3 id="usage-monitoring">
  使用状況監視
</h3>

| メトリクス | 分析の機会 |
| - | - |
| `claude_code.token.usage` | トークンの [`type`](#token-counter)、ユーザー、チーム、モデル、`skill.name`、`plugin.name`、または `agent.name` 別に分類 |
| `claude_code.session.count` | 時間経過に伴う採用と関与を追跡 |
| `claude_code.lines_of_code.count` | コード追加と削除を追跡して生産性を測定し、モデル別に分類 |
| `claude_code.commit.count` & `claude_code.pull_request.count` | 開発ワークフローへの影響を理解 |

<h3 id="cost-monitoring">
  コスト監視
</h3>

`claude_code.cost.usage` メトリクスは以下に役立ちます:

* チームまたは個人全体の使用トレンドを追跡する
* 最適化のための高使用セッションを特定する
* `skill.name`、`plugin.name`、および `agent.name` 属性を介して、特定のスキル、プラグイン、またはサブエージェントタイプへの支出を属性付けする

<Note>
  コストメトリクスは概算です。公式な請求データについては、API プロバイダー (Claude Console、Amazon Bedrock、または Google Cloud の Agent Platform) を参照してください。
</Note>

Claude Code は、`ANTHROPIC_BASE_URL` の背後にあるゲートウェイまたはプロキシが複数のフレーム全体で使用状況をプログレッシブにストリーミングする場合を含め、各ストリーミングレスポンスをコストおよびトークンメトリクスに対して正確に 1 回カウントします。v2.1.214 より前では、複数のフレームで使用状況を含むストリームは、`claude_code.cost.usage` と `claude_code.token.usage` を追加フレームごとにおよそ 1 つの追加フルリクエスト分だけ増加させました。

<h3 id="alerting-and-segmentation">
  アラートとセグメンテーション
</h3>

検討すべき一般的なアラート:

* コストスパイク
* 異常なトークン消費
* 特定のユーザーからの高いセッションボリューム

すべてのメトリクスは、[標準属性](#standard-attributes) でセグメント化できます。`model` 属性は `claude_code.token.usage`、`claude_code.cost.usage`、および v2.1.172 以降の `claude_code.lines_of_code.count` で利用可能です。

コミットのモデル別の内訳は、1 つのセッションが複数のモデルにまたがる可能性があるため、`session.id` でトークンまたはコストメトリクスに対して結合することによってのみ概算できます。トークンまたはコスト側をフィルタリングして、`query_source` が `"main"` である行のみにしてください。これにより、補助的なリクエストとサブエージェントリクエストが、セッションのコミットをそれらを作成しなかったモデルに属性付けしません。

<h3 id="detect-retry-exhaustion">
  再試行枯渇の検出
</h3>

Claude Code は失敗した API リクエストを内部的に再試行し、あきらめた後にのみ単一の `claude_code.api_error` イベントを出力するため、イベント自体がそのリクエストの終端信号です。中間再試行試行は個別のイベントとしてログされません。

イベントの `attempt` 属性は、試行の総数を記録します。`CLAUDE_CODE_MAX_RETRIES` はデフォルトで 10 で、15 で上限です。v2.1.199 以降では、`CLAUDE_CODE_RETRY_WATCHDOG` を設定してデフォルトを引き上げ、上限を削除できます。

リクエストが一時的なエラーのすべての再試行を枯渇させた場合、`attempt` はその有効な制限より 1 つ多くなります: デフォルトでは 11、ウォッチドッグが設定されていない限り 16 を超えることはありません。より低い値は、`400` レスポンスなどの再試行不可能なエラー、または独自のより小さい再試行予算を持つ原因を示します。たとえば、Claude Code は AWS または Google Cloud 認証情報の読み込み失敗を最大 2 回再試行します。

セッションが回復したものと停止したものを区別するには、イベントを `session.id` でグループ化し、エラーの後に後続の `api_request` イベントが存在するかどうかを確認します。

<h3 id="event-analysis">
  イベント分析
</h3>

イベントデータは Claude Code インタラクションに関する詳細な洞察を提供します:

**ツール使用パターン**: ツール結果イベントを分析して以下を特定します:

* 最も頻繁に使用されるツール
* ツール成功率
* 平均ツール実行時間
* ツールタイプ別のエラーパターン

**パフォーマンス監視**: API リクエスト期間とツール実行時間を追跡して、パフォーマンスボトルネックを特定します。

<h3 id="map-input-tokens-to-opentelemetry-genai-semantic-conventions">
  入力トークンを OpenTelemetry GenAI セマンティック規約にマッピングする
</h3>

Claude Code は、入力トークン数を API レスポンスの usage ブロックに表示されるとおりにエクスポートするため、これらの値には [プロンプトキャッシュ](/docs/ja/prompt-caching) から読み取られたトークンやキャッシュに書き込まれたトークンは含まれません:

* [`claude_code.llm_request`](#span-attributes) スパンと [`api_request`](#api-request-event) イベントの `input_tokens`
* [`claude_code.token.usage`](#token-counter) メトリクスの `"input"` タイプ

Claude Code は `gen_ai.usage.*` 属性を設定しません。[OpenTelemetry GenAI セマンティック規約](https://github.com/open-telemetry/semantic-conventions-genai) では、`gen_ai.usage.input_tokens` にはキャッシュから読み取られたトークンとキャッシュに書き込まれたトークンを含めるべきとされています。その合計を計算するには:

* スパンまたはイベントから: `input_tokens`、`cache_read_tokens`、`cache_creation_tokens` を合計します
* `claude_code.token.usage` メトリクスから: その `"input"`、`"cacheRead"`、`"cacheCreation"` タイプを合計します

規約では、キャッシュ読み取りとキャッシュ書き込みに対して個別の属性も定義されています:

* `cache_read_tokens` は `gen_ai.usage.cache_read.input_tokens` に対応します
* `cache_creation_tokens` は `gen_ai.usage.cache_write.input_tokens` に対応します。古いバージョンの規約ではキャッシュ書き込み属性の名前が `gen_ai.usage.cache_creation.input_tokens` となっているため、バックエンドが想定する名前を使用してください。

<h2 id="audit-security-events">
  監査セキュリティイベント
</h2>

OpenTelemetry イベントは Claude Code アクティビティの監査データソースです。すべてのイベントは、ツール呼び出し、MCP アクティビティ、権限決定をそれらをトリガーしたユーザーに結び付ける ID 属性を持ち、OTLP ログエクスポーターは、これらのイベントを OTLP レシーバーを持つセキュリティ情報およびイベント管理（SIEM）プラットフォーム、または SIEM にフォワードする OpenTelemetry Collector に配信できます。

<h3 id="attribute-actions-to-users">
  属性アクションをユーザーに関連付ける
</h3>

各イベントの [標準属性](#standard-attributes) には、認証されたユーザーの ID が含まれます：Claude アカウントでサインインしている場合は `user.email`、`user.account_uuid`、`user.account_id`、および `organization.id`、さらに [クラウドセッション](/docs/ja/claude-code-on-the-web) では、セッション自体の認証情報がそれらを持つ場合、`user.id` とセッションごとの `session.id`。`user.id` はインストールスコープの識別子です。ただし、[Claude apps gateway](/docs/ja/claude-apps-gateway) セッションでは `/login` を通じてサインインしている場合、ゲートウェイが発行したトークンからの IdP サブジェクトです。

開発者が開始したセッションでは、MCP ツール呼び出し、Bash コマンド、ファイル編集はその開発者に属性付けられます。Claude Code は個別のサービスアカウントの下では機能しません。各イベントに記録される ID は、開発者自身の Claude アカウント、または [Claude apps gateway](/docs/ja/claude-apps-gateway) セッションでの開発者の IdP ID です。Claude Tag チャネルセッションでは、Claude はあなたの組織の [共有 ID](/docs/ja/cloud-environments#set-the-environment-a-claude-tag-channel-uses) として機能します。

Claude Code が直接 API キーで認証する場合、または Amazon Bedrock、Google Cloud の Agent Platform、または Microsoft Foundry に対して認証する場合、セッションに Claude アカウントはなく、`user.id` と `session.id` のみが入力されます。これらのデプロイメントでは、`OTEL_RESOURCE_ATTRIBUTES` を使用してユーザー ID を自分で添付し、[管理設定](#administrator-configuration) ファイルまたはローンチラッパーを通じてユーザーごとに設定します。Claude apps gateway セッションはこれを必要としません：[標準属性](#standard-attributes) を参照して、それらのエクスポートが持つ ID を確認してください。

```bash theme={null}
export OTEL_RESOURCE_ATTRIBUTES="enduser.id=jdoe@example.com,enduser.directory_id=S-1-5-21-..."
```

<h3 id="audit-mcp-activity">
  MCP アクティビティを監査する
</h3>

完全なコール詳細で MCP サーバーアクティビティをキャプチャするには、ログエクスポーターを有効にし、`OTEL_LOG_TOOL_DETAILS=1` を設定します。その後、各 MCP 操作は、標準 ID 属性と共にサーバー名、ツール名、呼び出し引数を含む構造化イベントを生成します：

| イベント | MCP に対して記録するもの |
| - | - |
| `mcp_server_connection` | `server_name`、`transport_type`、`server_scope`、およびエラー詳細を含むサーバー接続、切断、接続失敗 |
| `tool_result` | `tool_name` および `mcp_server_scope` を含む各 MCP ツール呼び出し、`mcp_server_name` および `mcp_tool_name` を含む `tool_parameters` ペイロード、および呼び出し引数を含む `tool_input` ペイロード |
| `tool_decision` | 呼び出しが許可されたか拒否されたか、および決定が設定、フック、またはユーザーから来たかどうか、および `mcp_server_name` と `mcp_tool_name` を含む `tool_parameters` ペイロード |

`OTEL_LOG_TOOL_DETAILS` がない場合、これらのイベントは識別詳細を削除します：

* `tool_result`：`mcp_server_scope` と、ユーザー設定サーバーの場合はリテラル `"mcp_tool"` に編集された `tool_name` を保持し、引数コンテンツを省略します。Claude Desktop の組み込みサーバーの場合、Claude Desktop が所有するセッションでは、`tool_parameters` 内の `mcp_server_name`/`mcp_tool_name` ペアも保持します。これは `tool_decision` と同じホスト作成例外です。Claude Code v2.1.214 以降が必要です
* `tool_decision`：`tool_source` と、ユーザー設定サーバーの場合はリテラル `"mcp_tool"` に編集された `tool_name` を保持し、引数コンテンツを省略します。Claude Desktop の組み込みサーバーの場合、Claude Desktop が所有するセッションでは、`tool_parameters` 内の `mcp_server_name`/`mcp_tool_name` ペアも保持します。`tool_source` と名前ペアの両方に Claude Code v2.1.214 以降が必要です
* `mcp_server_connection`：`server_name` とエラーメッセージを省略しますが、`is_plugin`、`plugin_id_hash`、および `plugin.name` を保持し、Anthropic 以外のプラグイン名はリテラル `"third-party"` に編集されるため、プラグイン提供サーバーは詳細ログなしで区別可能なままです

<h3 id="map-security-questions-to-events">
  セキュリティの質問をイベントにマップする
</h3>

検出ルールを構築する場合、監視したいシグナルを検索し、対応するイベントと属性についてバックエンドをクエリします：

| シグナル | イベント | キー属性 |
| - | - | - |
| ツール呼び出しが許可または拒否され、何によって | `tool_decision` | `decision`、`source`、`tool_name`、`tool_parameters` |
| 権限モードのエスカレーション | `permission_mode_changed` | `from_mode`、`to_mode`、`trigger` |
| ポリシーフックがアクションをブロック | `hook_execution_complete` | `hook_event`、`num_blocking` |
| ログイン、ログアウト、認証失敗 | `auth` | `action`、`success`、`error_category` |
| MCP サーバー接続または失敗 | `mcp_server_connection` | `status`、`server_name`、`is_plugin`、`error_code` |
| プラグインがインストールされ、そのソース | `plugin_installed` | `plugin.name`、`marketplace.name`、`marketplace.is_official` |
| 実行されたコマンドとタッチされたファイル | `tool_result`（実行）または `tool_decision`（拒否）（`OTEL_LOG_TOOL_DETAILS=1` の場合） | `tool_parameters`；`tool_input`（`tool_result` のみ） |
| マシンが実行する管理設定ソース、そのポリシーヘルパーが正常かどうか、およびマシンが起動を拒否した理由 | `managed_settings_resolved` | `managed_settings.trigger`、`managed_settings.sources`、`managed_settings.source_behavior`、`managed_settings.helper.state`、`error.type`；`managed_settings.settings` および `managed_settings.resolved_sha256`（`OTEL_LOG_MANAGED_SETTINGS=1` の場合） |

Claude Code は生のイベントストリームのみを出力します。異常検出、ベースライン化、セッション間の相関、アラートは SIEM または可観測性バックエンドの責任です。

<h3 id="send-events-to-a-siem">
  SIEM にイベントを送信する
</h3>

`OTEL_EXPORTER_OTLP_LOGS_ENDPOINT` を SIEM の OTLP レシーバーに、または SIEM のネイティブ取り込み API にフォワードする OpenTelemetry Collector に指定します。以下の管理設定の例は、MCP および Bash 監査のための完全なツール詳細を有効にして、イベントのみをエクスポートします：

```json theme={null}
{
  "env": {
    "CLAUDE_CODE_ENABLE_TELEMETRY": "1",
    "OTEL_LOGS_EXPORTER": "otlp",
    "OTEL_LOG_TOOL_DETAILS": "1",
    "OTEL_EXPORTER_OTLP_LOGS_PROTOCOL": "http/protobuf",
    "OTEL_EXPORTER_OTLP_LOGS_ENDPOINT": "https://siem.example.com:4318/v1/logs",
    "OTEL_EXPORTER_OTLP_HEADERS": "Authorization=Bearer your-siem-token"
  }
}
```

イベントが到着したことを確認するには、この設定で実行されているセッションでプロンプトを送信し、SIEM で `claude_code.user_prompt` イベントを確認します。何も到着しない場合は、`claude --debug-file <path>` で Claude Code を起動し、そのログで `[3P telemetry]` エクスポートエラーを確認します。

<h2 id="backend-considerations">
  バックエンドに関する考慮事項
</h2>

メトリクス、ログ、トレースバックエンドの選択により、実行できる分析のタイプが決まります:

<h3 id="for-metrics">
  メトリクスの場合
</h3>

* **時系列データベース**: レート計算、集約メトリクス
* **カラムナーストア**: 複雑なクエリ、一意のユーザー分析
* **フル機能の可観測性プラットフォーム**: 高度なクエリ、可視化、アラート

<h3 id="for-events/logs">
  イベント/ログの場合
</h3>

* **ログ集約システム**: 全文検索、ログ分析
* **カラムナーストア**: 構造化イベント分析
* **フル機能の可観測性プラットフォーム**: メトリクスとイベント間の相関

<h3 id="for-traces">
  トレースの場合
</h3>

分散トレースストレージとスパン相関をサポートするバックエンドを選択します:

* **分散トレースシステム**: スパン可視化、リクエストウォーターフォール、レイテンシー分析
* **フル機能の可観測性プラットフォーム**: トレース検索とメトリクスおよびログとの相関

日次/週次/月次アクティブユーザー (DAU/WAU/MAU) メトリクスが必要な組織の場合は、効率的な一意値クエリをサポートするバックエンドを検討してください。

<h2 id="service-information">
  サービス情報
</h2>

すべてのメトリクスとイベントは、以下のリソース属性でエクスポートされます:

* `service.name`: ターミナルセッションの場合は `claude-code`、[Claude Desktop アプリ](/docs/ja/desktop)のコードタブから開始されたセッションの場合は `claude-code-desktop`
* `service.version`: 現在の Claude Code バージョン、またはコードタブセッションの場合は Desktop アプリバージョン
* `os.type`: オペレーティングシステムタイプ (例: `linux`、`darwin`、`windows`)
* `os.version`: オペレーティングシステムバージョン文字列
* `host.arch`: ホストアーキテクチャ (例: `amd64`、`arm64`)
* `wsl.version`: WSL バージョン番号 (Windows Subsystem for Linux で実行している場合のみ存在)
* メーター名: `com.anthropic.claude_code`

`service.name = claude-code` でフィルタリングするコレクターパイプラインまたはダッシュボードがある場合は、コードタブセッションからのテレメトリもキャプチャするために、フィルターに `claude-code-desktop` を追加してください。

<h2 id="roi-measurement-resources">
  ROI 測定リソース
</h2>

テレメトリセットアップ、コスト分析、生産性メトリクス、自動レポート生成を含む Claude Code の投資収益率（ROI）測定に関する包括的なガイドについては、[Claude Code ROI 測定ガイド](https://github.com/anthropics/claude-code-monitoring-guide)を参照してください。このリポジトリは、すぐに使用できる Docker Compose 設定、Prometheus と OpenTelemetry セットアップ、Linear などのツールと統合された生産性レポート生成テンプレートを提供します。

<h2 id="security-and-privacy">
  セキュリティとプライバシー
</h2>

* OpenTelemetry エクスポートをバックエンドに送信することはオプトインであり、明示的な設定が必要です。Anthropic の個別の運用テレメトリと無効化方法については、[データ使用](/docs/ja/data-usage#telemetry-services)を参照してください
* 生のファイルコンテンツとコードスニペットはメトリクスやイベントに含まれません。トレーススパンは別のデータパスです。以下の `OTEL_LOG_TOOL_CONTENT` の項目を参照してください
* OAuth 経由で認証されている場合、`user.email` はテレメトリ属性に含まれ、設定した OTel エンドポイントにのみ送信され、Anthropic には送信されません。これが組織にとって懸念事項である場合は、テレメトリバックエンドと協力してこのフィールドをフィルタリングまたは編集してください
* ユーザープロンプトコンテンツはデフォルトでは収集されません。プロンプト長のみが記録されます。プロンプトコンテンツを含めるには、`OTEL_LOG_USER_PROMPTS=1` を設定してください。有効にすると：
  * `user_prompt` イベントは、プロンプトテキストを `prompt` と [`prompt_text`](#user-prompt-event) の 2 つの属性に含みます。コレクターでイベントのプロンプトテキストを属性名によって削除またはマスクする場合は、ルールで両方の属性を指定してください

    この OpenTelemetry Collector の `attributes` プロセッサーは、これを指定しているパイプラインで両方の属性を削除します：

    ```yaml theme={null}
    processors:
      attributes/drop-prompt-text:
        actions:
          - key: prompt
            action: delete
          - key: prompt_text
            action: delete
    ```

  * [トレース](#traces-beta)がオンの場合、`claude_code.interaction` スパンは `user_prompt` 属性にプロンプトテキストを含みます

  * 詳細なベータトレースでは、スパンには各リクエストとともに送信される新しいユーザーメッセージ、ツール結果、システムリマインダーに加えて、システムプロンプトテキストとモデル出力も含まれます。各属性は[詳細なベータトレースにおけるコンテンツ属性](#new-context-gates)に記載されています。`claude_code.system_prompt` イベントは完全なシステムプロンプトを含みます
* アシスタント応答テキストはデフォルトでは収集されません。応答長のみが記録されます。応答テキストを含めるには、`OTEL_LOG_ASSISTANT_RESPONSES=1` を設定してください。Claude Code からのすべての OpenTelemetry データと同様に、応答テキストは設定した OTel エンドポイントにのみ送信され、Anthropic には送信されません。この変数が設定されていない場合、`OTEL_LOG_USER_PROMPTS` がフォールバックとして使用されるため、イベントで応答コンテンツなしでプロンプトコンテンツが必要な場合は `OTEL_LOG_ASSISTANT_RESPONSES=0` を設定してください。詳細なベータトレースでは、`claude_code.llm_request` スパンは引き続き [`response.model_output`](#new-context-gates) にモデル出力を含みます。これはこの変数ではなく `OTEL_LOG_USER_PROMPTS` に従います
* ツール入力引数とパラメータはデフォルトではログに記録されません。これらを含めるには、`OTEL_LOG_TOOL_DETAILS=1` を設定してください。Claude Desktop の組み込みサーバーの場合、Claude Desktop が所有するセッションでは、`tool_decision` と `tool_result` は `mcp_server_name`/`mcp_tool_name` ペアを含みます。これはホストが作成した名前であり、フラグがオフの場合でも引数コンテンツではありません。この例外には Claude Code v2.1.214 以降が必要です。このデータは設定した OTEL エンドポイントにのみ送信され、Anthropic には送信されません。引数には機密値が含まれる可能性があるため、テレメトリバックエンドを設定してこれらの属性をフィルタリングまたは編集してください。有効にすると：
  * `tool_result` と `tool_decision` イベントには、Bash コマンド、MCP サーバーとツール名、およびスキル名を含む `tool_parameters` 属性が含まれます。`full_command` などのフィールドは切り詰められずに出力されます
  * `tool_result` イベントには、ファイルパス、URL、検索パターン、およびその他の引数を含む `tool_input` 属性も含まれます。512 文字を超える個別の値は切り詰められ、合計は約 4 K 文字に制限されます
  * `user_prompt` イベントには、カスタム、プラグイン、および MCP コマンドの逐語的な `command_name` が含まれます
  * [コストとトークンカウンター](#cost-counter)および `api_request`、`api_error`、および `api_refusal` イベントは、その属性の帰属に実際のエージェント、スキル、プラグイン、および MCP サーバーとツール名を含みます
  * `claude_code.tool` スパンには、`file_path` などの入力派生属性が含まれます。詳細なベータトレースでは、[`tool_input`](#new-context-gates) 属性も含まれます
* ツールコンテンツはデフォルトではトレーススパンにログに記録されません。これを含めるには、`OTEL_LOG_TOOL_CONTENT=1` を設定してください。その後、`claude_code.tool` スパンは、生のファイルコンテンツ、Bash コマンド出力、および MCP ツール、WebFetch、WebSearch が返すものを含む [`tool.output` スパンイベント](#tool-output-span-event)を含みます。コンテンツは属性ごとにコンテンツ制限（デフォルトでは 60 KB）で切り詰められます。MCP ツール、WebFetch、WebSearch からの結果には Claude Code v2.1.283 以降が必要です。ツールコンテンツは [`new_context`](#new-context-gates) を通じてスパンに到達します。このゲートはスパンごとに異なります。テレメトリバックエンドを設定してこれらの属性をフィルタリングまたは編集してください
* 生の Anthropic Messages API リクエストおよびレスポンスボディはデフォルトではログに記録されません。これらを含めるには、シェル、ユーザー設定、または管理設定で `OTEL_LOG_RAW_API_BODIES` を設定してください。[プロジェクトおよびローカル設定](/docs/ja/settings-reference#variables-claude-code-ignores-in-env)では無視されます。ボディには、システムプロンプト、すべての以前のユーザーとアシスタントのターン、およびツール結果を含む完全な会話履歴が含まれるため、これを有効にすることは、他の `OTEL_LOG_*` コンテンツフラグが明かすすべてのことへの同意を意味します。Claude Code は、他の設定に関係なく、これらのボディから Claude の拡張思考コンテンツを常に編集します。設定する値は、Claude Code がボディを配信する方法を決定します：
  * `=1` の場合、Claude Code は各 API 呼び出しに対して `api_request_body` と `api_response_body` ログイベントを出力します。イベントの `body` 属性は JSON シリアル化されたペイロードを含み、コンテンツ制限（デフォルトでは 60 KB）で切り詰められます
  * `=file:<dir>` の場合、Claude Code は切り詰められていないボディをそのディレクトリの `.request.json` と `.response.json` ファイルに書き込み、イベントはインラインボディの代わりに `body_ref` パスを含みます。テレメトリストリームではなく、ログコレクターまたはサイドカーでディレクトリを送信してください。

    各成功したレスポンスについて、Claude Code はそのディレクトリの `index.jsonl` に 1 行追加し、レスポンスファイルをそれを生成したリクエストファイルおよびそれが成為したトランスクリプトメッセージにリンクします。各行はメッセージコンテンツを含まず、[API レスポンスボディイベント](#api-response-body-event)セクションがそのフィールドをリストします。インデックスファイルには Claude Code v2.1.274 以降が必要です

<h2 id="monitor-claude-code-on-amazon-bedrock">
  Amazon Bedrock での Claude Code の監視
</h2>

Amazon Bedrock での Claude Code 使用状況監視ガイダンスの詳細については、[Claude Code 監視実装（Amazon Bedrock）](https://github.com/aws-solutions-library-samples/guidance-for-claude-code-with-amazon-bedrock/blob/main/assets/docs/MONITORING.md)を参照してください。
