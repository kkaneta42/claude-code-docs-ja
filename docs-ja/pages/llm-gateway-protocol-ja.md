> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# Claude Code ゲートウェイ互換性ガイド

> Claude Code と互換性のある LLM ゲートウェイを保つ：呼び出すエンドポイント、転送すべきヘッダーとボディフィールド、削除された場合に機能しなくなる機能。

このページでは、Claude Code がゲートウェイに送信するリクエストについて説明します。呼び出すエンドポイント、ゲートウェイが転送する必要があるヘッダーとボディフィールド、および転送されない場合に機能しなくなる機能について記載しています。このページは、Claude Code で動作するようにゲートウェイ製品を設定するオペレーター向けに作成されています。

[Claude apps ゲートウェイ](/docs/ja/claude-apps-gateway)（Anthropic の自己ホスト型ゲートウェイ）は、`GET /protocol` で独自のエンドポイントリファレンスを提供しており、そのゲートウェイのサインイン、推論、マネージド設定、モデル検出、およびテレメトリエンドポイントをカバーしています。これはこのガイドとは別のドキュメントです。

<Note>
  * 既存またはサードパーティのゲートウェイを組織にロールアウトする場合は、[LLM ゲートウェイのロールアウト](/docs/ja/llm-gateway-rollout)を参照してください
  * 提供されたクレデンシャルを使用してゲートウェイに Claude Code を認証する個別開発者の場合は、[Claude Code を LLM ゲートウェイに接続](/docs/ja/llm-gateway-connect)を参照してください
</Note>

このページでは以下について説明します：

* [API フォーマット](#api-formats)と各フォーマットで提供するエンドポイント
* [リクエストヘッダー](#request-headers)：アップストリームに到達する必要があるもの、およびゲートウェイが使用できるもの
* [システムプロンプト属性ブロック](#system-prompt-attribution-block)とプロンプトキャッシングとの相互作用
* [機能パススルー](#feature-pass-through)：ヘッダーまたはボディフィールドが削除された場合に何が壊れるか
* [モデル検出](#model-discovery)

このページでは、ゲートウェイが各ヘッダーとボディフィールドで実行する内容について 2 つの用語を使用します：

* **変更なしで転送**：アップストリームにバイト単位で渡す
* **使用**：ゲートウェイはルーティング、属性、またはトレース用に読み取ることができ、転送する必要はありません

変更なしで転送とマークされていないものは、使用または無視できます。

<h2 id="api-formats">
  API フォーマット
</h2>

ゲートウェイは、Claude Code クライアントに対して以下の API フォーマットの少なくとも 1 つを公開する必要があります。クライアントはフォーマットを選択し、以下の表の「選択者」列の変数を使用して Claude Code をゲートウェイに指定します。

Google Cloud の Agent Platform は Google Cloud の Claude エンドポイントで、以前は Vertex AI でした。その変数名は `VERTEX` のスペルを保持しています。

| フォーマット                                   | 選択者                                                        | エンドポイント                                                                                                   | 変更なしで転送                                                                                  |
| :--------------------------------------- | :--------------------------------------------------------- | :-------------------------------------------------------------------------------------------------------- | :--------------------------------------------------------------------------------------- |
| Anthropic Messages                       | `ANTHROPIC_BASE_URL`                                       | `/v1/messages`、`/v1/messages/count_tokens`（オプション）                                                         | `anthropic-beta` および `anthropic-version` リクエストヘッダー                                       |
| Amazon Bedrock InvokeModel               | `ANTHROPIC_BEDROCK_BASE_URL` と `CLAUDE_CODE_USE_BEDROCK=1` | `/model/{model}/invoke`、`/model/{model}/invoke-with-response-stream`、`/model/{model}/count-tokens`（オプション） | `anthropic_beta` および `anthropic_version` リクエストボディフィールド                                   |
| Google Cloud の Agent Platform rawPredict | `ANTHROPIC_VERTEX_BASE_URL` と `CLAUDE_CODE_USE_VERTEX=1`   | `:rawPredict`、`:streamRawPredict`、`count-tokens:rawPredict`（オプション）                                        | `anthropic-beta` および `anthropic-version` リクエストヘッダー、および `anthropic_version` リクエストボディフィールド |

<h3 id="foundry-and-claude-platform-on-aws">
  Foundry および AWS 上の Claude Platform
</h3>

Microsoft Foundry および [AWS 上の Claude Platform](/docs/ja/claude-platform-on-aws) は Anthropic Messages フォーマットを実装しています。Claude Code は独自の変数 `ANTHROPIC_FOUNDRY_BASE_URL` および `ANTHROPIC_AWS_BASE_URL` を通じてそれらにルーティングしますが、どちらかの前にあるゲートウェイは上記の Anthropic Messages 行を実装します。AWS 上の Claude Platform の前にあるゲートウェイは、[そのプラットフォームがすべてのリクエストで必要とする](/docs/ja/claude-platform-on-aws) `anthropic-workspace-id` ヘッダーも転送する必要があります。

<h3 id="optional-endpoints-and-startup-traffic">
  オプションエンドポイントとスタートアップトラフィック
</h3>

トークンカウントエンドポイントは唯一のオプションです。存在しない場合、Claude Code は文字ベースのコンテキスト使用量の推定にフォールバックします。

パスで一致させてください。完全な URL ではなく：

* 推論リクエストは `/v1/messages?beta=true` に POST されます
* Google Cloud の Agent Platform メソッドのサフィックスは、`/projects/{project}/locations/{location}/publishers/anthropic/models/{model}:streamRawPredict` のようにパブリッシャーモデルパスに付加されます

ゲートウェイは、拒否しても何も壊さないベストエフォート型のスタートアップトラフィックも受け取ります。Anthropic Messages フォーマットゲートウェイは `HEAD /api/hello` 接続ウォーミングプローブを受け取ります。これは HTTP プロキシまたはクライアント証明書が設定されている場合、Claude Code はスキップします。Amazon Bedrock フォーマットゲートウェイは `GET /inference-profiles?type=SYSTEM_DEFINED` リクエストを受け取り、設定されたモデルが推論プロファイルの場合、`GET /inference-profiles/{profile}` ルックアップを受け取ります。

[高速モード](/docs/ja/fast-mode) の可用性チェックはゲートウェイログに表示されません。`ANTHROPIC_BASE_URL` に従う代わりに `api.anthropic.com` を直接呼び出すため、`api.anthropic.com` への直接エグレスをブロックするネットワークでは、高速モードは接続エラーを報告する可能性がありますが、ゲートウェイを通じた推論は機能し続けます。[WebFetch ドメイン安全性チェック](/docs/ja/data-usage#webfetch-domain-safety-check) も `api.anthropic.com` を直接呼び出します。[プロキシと LLM ゲートウェイの背後で高速モードを使用する](/docs/ja/fast-mode#use-fast-mode-behind-proxies-and-llm-gateways) は、それを復元する変数をカバーしています。

<h3 id="streaming">
  ストリーミング
</h3>

推論レスポンスをストリーミングしてください。Claude Code はストリームが到着するにつれてそれを読み取るため、ゲートウェイが完全なレスポンスをバッファリングしてからリレーする場合、Claude Code は停止します。

クライアントが Amazon Bedrock フォーマットを使用する場合、`InvokeModelWithResponseStream` レスポンスボディとその `Content-Type: application/vnd.amazon.eventstream` ヘッダーを変更せずにリレーし、ストリームをサーバー送信イベントに変換しないでください。[ゲートウェイまたはプロキシの背後でのストリーミングエラー](/docs/ja/amazon-bedrock#streaming-errors-behind-a-gateway-or-proxy) を参照してください。

キープアライブピングもリレーしてください。`ANTHROPIC_BASE_URL` または `ANTHROPIC_AWS_BASE_URL` を通じた接続では、Claude Code はゲートウェイがリレーするすべてのバイト（SSE `ping` イベントとコメント行を含む）をカウントし、300 秒間デフォルトで無音のストリームを中止します。アップストリームのピングは長い思考の一時停止中の唯一のトラフィックであるため、ゲートウェイがそれらをストリップまたはバッファリングする場合、Claude Code はそれらの一時停止中にストリームを中止します。[自動再試行](/docs/ja/errors#automatic-retries) は、レスポンスがどこまで進行したかに基づいて、中止されたストリームが報告するものをカバーしています。Amazon Bedrock のバイナリイベントストリームなど、ピングをまったく送信しないアップストリームは、それらの一時停止中にリレーするものがありません。そのようなアップストリームから変換する場合、無音のギャップ中に独自の `ping` イベントを発行してください。`ANTHROPIC_BEDROCK_BASE_URL`、`ANTHROPIC_VERTEX_BASE_URL`、または `ANTHROPIC_FOUNDRY_BASE_URL` を通じて到達するゲートウェイは、Anthropic Messages フォーマットをリレーする場合でも、このバイトレベルのウォッチドッグでラップされません。そこでは、[5 分間のアイドルタイムアウト](/docs/ja/env-vars) が無音のストリームを中止し、`ANTHROPIC_BEDROCK_BASE_URL` 接続では [`CLAUDE_ENABLE_BYTE_WATCHDOG_BEDROCK`](/docs/ja/env-vars) でバイトウォッチドッグを追加できます。

<h3 id="format-mismatch-with-the-upstream">
  アップストリームとのフォーマット不一致
</h3>

クライアントが使用するフォーマットは、ゲートウェイが受け取るものを決定します。一般的な障害モードは、クライアントがゲートウェイに送信するフォーマットと、その背後にあるアップストリームプロバイダーが受け入れるフォーマット間の不一致です。

* クライアントが Amazon Bedrock または Google Cloud の Agent Platform フォーマットを使用する場合、Claude Code はそれらのプロバイダーが受け入れる完全な機能セットのサブセットのみを送信します
* クライアントが Anthropic Messages フォーマットを使用する場合、ゲートウェイが Amazon Bedrock または Google Cloud の Agent Platform アップストリームに転送する場合でも、Claude Code は完全なセットを送信します

その違いを橋渡けするのはゲートウェイの仕事です。[機能パススルー](#feature-pass-through)では、転送されない場合に何が壊れるかについて説明しています。

<h2 id="request-headers">
  リクエストヘッダー
</h2>

Claude Code は API リクエストにこれらのヘッダーを含めます。ヘッダー名はワイヤ上では大文字と小文字を区別しません。`anthropic-version` および `anthropic-beta` を変更なしで転送し、アップストリームが [AWS 上の Claude Platform](/docs/ja/claude-platform-on-aws) の場合は `anthropic-workspace-id` も転送してください。残りはゲートウェイがルーティング、属性、およびトレース用に使用でき、転送する必要はありません。

| ヘッダー                            | 説明                                                                                                                                                                                                                                              |
| :------------------------------ | :---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `Authorization`、`x-api-key`     | 開発者のゲートウェイクレデンシャル。設定した[クレデンシャル変数](/docs/ja/llm-gateway-connect#set-the-credential-variable)に応じて、1 つまたは両方のヘッダーに含まれます                                                                                                                                  |
| `anthropic-version`             | API バージョン。現在は `2023-06-01`。Amazon Bedrock および Google Cloud の Agent Platform フォーマットリクエストは、`anthropic_version` ボディフィールドも含みます。その値はこのヘッダーの値ではなく、プロバイダー方言文字列です                                                                                       |
| `anthropic-beta`                | リクエストの機能値をカンマで区切ったもの。ヘッダーをそのまま転送してください。個別の値をホワイトリストに登録しないでください。セットは Claude Code リリースで変わるためです。開発者が claude.ai ログインで認証する場合（`ANTHROPIC_BASE_URL` がゲートウェイクレデンシャル変数なしで設定されている場合に可能）、このヘッダーはアップストリームが必要とする OAuth 機能も含み、それを削除するとそれらのリクエストは `401` で失敗します |
| `x-claude-code-session-id`      | 現在の Claude Code セッションの一意の識別子。リクエストボディを解析せずに 1 つのセッションからのすべてのリクエストを集約するために使用してください                                                                                                                                                               |
| `x-claude-code-agent-id`        | リクエストを発行した[サブエージェント](/docs/ja/sub-agents)の識別子。セッション内で Claude Code が生成したエージェントからのリクエストにのみ存在します。セッション ID と共に使用して、並列エージェントにコストを属性付けしてください                                                                                                               |
| `x-claude-code-parent-agent-id` | リクエストするエージェントを生成したエージェントの識別子。ネストされたエージェントにのみ存在します                                                                                                                                                                                               |

サブエージェント ID は各スポーン時に新しく生成されます。チームメイトエージェント（[エージェントチーム](/docs/ja/agent-teams)の名前付きメンバー）は、再接続全体で安定した名前ベースの ID を再利用します。どちらの場合も、ID はエージェントを識別し、人またはデバイスを識別しないため、エージェント ID ヘッダーをユーザー識別子として扱わないでください。

開発者が `ANTHROPIC_CUSTOM_HEADERS` を設定した場合、それらのヘッダーもリクエストに表示されます。

<h3 id="forward-as-open-lists">
  オープンリストとして転送
</h3>

ヘッダーとボディフィールドをクローズドリストではなく、オープンリストとして扱ってください。Claude Code はリリース全体で機能を獲得し、新しい `anthropic-beta` 値、新しいリクエストボディフィールド、および時々新しい `anthropic-*` または `x-claude-code-*` ヘッダーとして到着します。

Anthropic フォーマットアップストリームに転送する場合、今日見ている値をホワイトリストに登録するのではなく、`anthropic-*` リクエストヘッダーとリクエストボディフィールドを変更なしで渡してください。観察されたリストに固定されたゲートウェイは、次の機能のヘッダーまたはフィールドを削除し、それを導入するリリースで壊します。

例外は Amazon Bedrock や Google Cloud の Agent Platform などの非 Anthropic アップストリームです。スキーマの違いを橋渡けするのはゲートウェイの仕事です。[機能パススルー](#feature-pass-through)を参照してください。

<h2 id="system-prompt-attribution-block">
  システムプロンプト属性ブロック
</h2>

Claude Code は、クライアントバージョンと会話から派生したフィンガープリントを含む短い属性ブロックをシステムプロンプトの前に付加します。`api.anthropic.com` エンドポイントは変更されていない状態で最初のシステムブロックとして到着したときに処理前にブロックを削除するため、ファーストパーティプロンプトキャッシングに影響しません。他のアップストリームはプロンプトの一部として受け取ります。

削除は位置に基づいているため、ゲートウェイが `system` 配列を変更せずに転送する場合にのみ機能します。別のシステムブロックを前に付加したり、配列を並べ替えたり、単一の文字列に変換したりすると、削除が機能しなくなり、ブロックはモデルとプロンプトキャッシュキーに到達します。プロンプトから属性ブロックを除外しながら他のシステムコンテンツを保持するには、以下の方法があります。

* 受け取った `system` 配列を正確に転送し、ブロックを最初に保つ：別のシステムブロックを前に付加したり、配列を並べ替えたり、単一の文字列に変換したりすると、削除が機能しなくなり、ブロックはモデルとプロンプトキャッシュキーに到達します。
* ブロックを独自の配列エントリに保つ：エンドポイントは属性ヘッダーで始まるマージされたブロックを属性全体として扱い、マージされたすべてのコンテンツ（システムプロンプトの残りを含む）を削除します。
* ゲートウェイがシステムコンテンツを再形成する必要がある場合は、[`CLAUDE_CODE_ATTRIBUTION_HEADER=0`](/docs/ja/env-vars) を設定して Claude Code がブロックを省略するようにしてください。Anthropic とクラウドプロバイダーの Claude エンドポイントは属性用にブロックを読み取るため、ゲートウェイで削除または移動するのではなく、クライアント側で省略してください。

この変数はゲートウェイとサードパーティキャッシング互換性のために存在し、プライバシーコントロールではありません。直接接続では、完全なリクエストはいずれにしても Anthropic API に送信されます。以下の両方が当てはまる場合、Claude Code は変数を `0` に設定した場合でも [auto mode](/docs/ja/permission-modes#eliminate-prompts-with-auto-mode) 分類器リクエストでブロックを保持します。

* リクエストは `api.anthropic.com` に送信され、`ANTHROPIC_BASE_URL` が設定されていないか、そのホストを指定しており、サードパーティプロバイダーが選択されていません。
* アクティブな認証情報は [Anthropic プロファイルまたはフェデレーション認証情報](/docs/ja/authentication#anthropic-profiles-and-federation-credentials) ではありません。

分類器リクエストは Claude Code のシステムプロンプトの残りをスキップするため、これらのリクエストではブロックはリクエストボディ内でそれらを Claude Code トラフィックとして識別する唯一のマーカーです。いずれかの条件が失敗した場合、LLM ゲートウェイを通じて、サードパーティプロバイダー上で、またはプロファイルまたはフェデレーション認証情報がアクティブな場合、`0` を設定すると分類器リクエストからもブロックが削除されます。v2.1.229 より前では、この例外は存在しませんでした。`0` を設定するとそれらの分類器リクエストからブロックが削除され、API がリクエストを拒否したときに、auto mode は分類器に送信するすべてのアクションで失敗しました。

Claude Code v2.1.181 から、リクエストがカスタムベース URL を通じてルーティングされる場合、ブロックは会話の存続期間中安定しているため、完全なリクエストボディをキーとするゲートウェイ側プロンプトキャッシュは無効化せずに機能し、ゲートウェイが転送するすべてのプロバイダーは安定したプロンプトプレフィックスを受け取ります。v2.1.181 より前のバージョンでは、ブロックはリクエストごとのトークンを含み、システムプロンプトの開始を変更しました。それらのバージョンでは、ゲートウェイが以下のいずれかを実装する場合は `CLAUDE_CODE_ATTRIBUTION_HEADER=0` を設定してください。

* リクエストボディをキーとするプロンプトキャッシュを実装します。
* Amazon Bedrock、Microsoft Foundry、Google Cloud の Agent Platform などのサードパーティプロバイダーにリクエストを転送します。Anthropic Messages 形式またはプロバイダー独自の形式で、変更されるプレフィックスはそのプロバイダー上のプロンプトキャッシュ再利用を削減します。

<h2 id="feature-pass-through">
  機能パススルー
</h2>

Claude Code は `ANTHROPIC_BASE_URL` ゲートウェイを Anthropic フォーマットエンドポイントとして扱い、`api.anthropic.com` に送信するベータヘッダーとリクエストボディフィールドを送信します。ただし、直接接続用に予約されている小さな診断とデフォルトのセットは除きます。以下で説明するきめ細かいツールストリーミングデフォルトなど、そのセットはリリースごとに異なるため、その内容に依存しないでください。

機能がボディフィールドを追加する場合、それらはベータヘッダーと組み合わされ、ペアは一緒に移動します。ヘッダーを削除しながらボディを渡すゲートウェイ、または Anthropic フォーマットボディを異なるスキーマのアップストリームに転送するゲートウェイは、ハード `400` エラーを生成します。両方の半分が一緒に存在しない場合のみ、機能は静かにオフになります。リクエストボディをコンテンツ検査のために書き直したり編集したりするゲートウェイは、削除と同じ方法でペアリングを壊すため、変更せずに検査してください。表は機能がペアリングから逸脱する場所を記載しています。

きめ細かいツールストリーミングは直接接続デフォルトの 1 つです。リクエストがカスタムベース URL を通じてルーティングされるときはデフォルトでオフになり、開発者が [`CLAUDE_CODE_ENABLE_FINE_GRAINED_TOOL_STREAMING=1`](/docs/ja/env-vars) を設定するとゲートウェイはそれを受け取ります。

| 機能                                                                                                                                                                                                                          | ヘッダーとボディペア                                                                                                                   | 壊れた場合の症状                                                                                                                      | 修復                                                                                                           |
| :-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :--------------------------------------------------------------------------------------------------------------------------- | :---------------------------------------------------------------------------------------------------------------------------- | :----------------------------------------------------------------------------------------------------------- |
| [適応的推論](/docs/ja/model-config#adjust-effort-level)                                                                                                                                                                               | ベータヘッダーなし。Claude Code は Claude 4.6 以降に `thinking: {"type": "adaptive"}` を送信し、ゲートウェイエイリアスなど認識しないモデル名を、フィールドを受け取る現在のモデルとして扱います | `thinking` フィールドまたは `adaptive` タグを命名する `400`。アップストリームモデルビルドがそれを受け入れない場合                                                       | アップストリームをアップグレードしてください。Opus 4.6 および Sonnet 4.6 では、開発者は代わりに `CLAUDE_CODE_DISABLE_ADAPTIVE_THINKING=1` を設定できます |
| [コンテキスト管理](https://platform.claude.com/docs/en/build-with-claude/context-editing)                                                                                                                                           | コンテキスト管理ベータヘッダーは `context_management` ボディフィールドと組み合わされます                                                                      | `Extra inputs are not permitted` を含む `400`。ゲートウェイが Anthropic フォーマットリクエストを受け入れるが Amazon Bedrock に転送する場合に一般的です                  | 両方を転送するか、[`CLAUDE_CODE_DISABLE_EXPERIMENTAL_BETAS=1`](/docs/ja/env-vars)                                          |
| [拡張コンテキスト](https://platform.claude.com/docs/en/build-with-claude/context-windows#context-window-sizes-by-model)および[インターリーブ思考](https://platform.claude.com/docs/en/build-with-claude/extended-thinking#interleaved-thinking) | ベータヘッダーのみ。ボディフィールドなし                                                                                                         | ヘッダーが削除されると静かに利用不可。アップストリームは機能リクエストを見ません                                                                                      | `anthropic-beta` をそのまま転送してください                                                                               |
| ベータ[ツールフィールド](https://platform.claude.com/docs/en/agents-and-tools/tool-use/overview)                                                                                                                                       | ツール関連ベータヘッダーは `strict` および `defer_loading` などのツールスキーマフィールドと組み合わされます                                                          | ボディがヘッダーなしで渡される場合、認識されないツールスキーマフィールドを命名する `400`                                                                               | 両方を転送するか、[`CLAUDE_CODE_DISABLE_EXPERIMENTAL_BETAS=1`](#disable-pre-release-capabilities)                     |
| [努力](https://platform.claude.com/docs/en/build-with-claude/effort)および[構造化出力](https://platform.claude.com/docs/en/build-with-claude/structured-outputs)                                                                      | `output_config` ボディフィールドは努力、構造化出力フォーマット、およびタスク予算設定を含みます。各々は独自のベータヘッダーと組み合わされます                                               | `output_config` を命名する `400`。多くの場合 `Extra inputs are not permitted`。Amazon Bedrock および Google Cloud の Agent Platform アップストリーム上 | フィールドとそのヘッダーを一緒に転送してください                                                                                     |
| [プロンプトキャッシング](/docs/ja/prompt-caching)                                                                                                                                                                                           | ベータペアリングなし。Claude Code は `cache_control` マーカーを `system` ブロックおよび `messages` エントリ（会話の途中で追加される `role: "system"` エントリを含む）に付加します  | エラーなし。会話は毎ターン、キャッシュされていない入力として課金されます。`usage` でキャッシュアクティビティがほとんどまたはまったくない高い `input_tokens` として表示されます                           | `cache_control` が表示される場所ならどこでも変更なしで転送し、ブロック形式の `system` またはメッセージコンテンツをプレーン文字列に変換しないでください                     |
| [トークンカウント](https://platform.claude.com/docs/en/build-with-claude/token-counting)                                                                                                                                            | ベータペアリングなし。`count_tokens` エンドポイントを使用します                                                                                      | エラーなし。Claude Code は文字ベースの推定にフォールバックするため、`/context` は概算カウントを表示します                                                              | 正確なトークンカウントのためにエンドポイントを公開してください                                                                              |

`ANTHROPIC_DEFAULT_*_MODEL_SUPPORTED_CAPABILITIES` [変数](/docs/ja/model-config)は、プロバイダー設定でのみモデル機能を宣言します：`CLAUDE_CODE_USE_BEDROCK`、`CLAUDE_CODE_USE_VERTEX`、`CLAUDE_CODE_USE_FOUNDRY`、および [`CLAUDE_CODE_USE_MANTLE`](/docs/ja/amazon-bedrock#use-the-mantle-endpoint)。`ANTHROPIC_BASE_URL` ゲートウェイの背後では効果がありません。

<h3 id="automatic-retry-and-error-forwarding">
  自動リトライとエラー転送
</h3>

アップストリーム拒否後に Claude Code が実行する内容は、何が拒否されたかによって異なります：

* アップストリームが `thinking` フィールド、会話中のシステムメッセージ、またはそのようなメッセージの `cache_control` マーカーを拒否する場合、Claude Code はリクエストをリトライし、拒否された機能を会話の残りの部分で無効にします
* アップストリームが[思考署名](https://platform.claude.com/docs/en/build-with-claude/extended-thinking)を拒否する場合、Claude Code はリクエストを会話の以前の思考ブロックなしでリトライし、それらを後のすべてのリクエストから除外します。新しい応答には依然として思考が含まれます
* Claude Code はコンテキスト管理またはツールスキーマフィールド拒否をリトライしません。それらの `400` エラーは開発者に到達します

リトライロジックはアップストリームのエラー文言に一致するため、アップストリームエラーレスポンスボディを変更なしで転送してください。アップストリームエラーを独自のエンベロープでラップするゲートウェイは、ステータスコードを保持する場合でも回復パスを壊します。ただし、エンベロープのメッセージが安定した `capability_rejected:` トークンを含む場合は除きます。[Claude apps ゲートウェイはクラウドプロバイダーのエラー文言をそれらのトークンに置き換えます](/docs/ja/claude-apps-gateway-config#upstream-error-messages)。例えば `capability_rejected: prompt_too_long` です。

<h3 id="disable-pre-release-capabilities">
  プレリリース機能を無効化
</h3>

`CLAUDE_CODE_DISABLE_EXPERIMENTAL_BETAS=1` は Claude Code がすべてのプロバイダーでプレリリース機能とそのボディフィールドを送信するのを停止します。コンテキスト管理とベータツールフィールドを含みます。適応的推論には影響しません。これはモデルではなくベータで選択されるため、サブスクリプション認証が必要とする OAuth 機能を抑制することはありません。

Claude Code v2.1.227 以降では、組織は [MCP ツール検索](/docs/ja/mcp#scale-with-mcp-tool-search)を[管理設定](/docs/ja/managed-settings)を通じてこの変数の下で有効に保つことができます。このオーバーライドが有効な場合に Claude Code が送信する内容は、接続方法によって異なります：

* 直接接続、または `ANTHROPIC_BASE_URL` で設定されたゲートウェイを通じて、Claude Code はツール検索ベータヘッダー、`defer_loading` ツールフィールド、および `tool_reference` ブロックを送信し続け、残りをストリップします
* クラウドプロバイダー、または [Claude apps ゲートウェイ](/docs/ja/claude-apps-gateway)を通じてサインインしている場合、オーバーライドは効果がありません

Claude Code が送信する機能セットはリリース全体で増加します。現在のベータヘッダー文字列については、[ベータヘッダーリファレンス](https://platform.claude.com/docs/en/api/beta-headers)を参照してください。観察されたリストに固定するのではなく、新しい Claude Code リリースに対してゲートウェイをテストしてください。

<h2 id="model-discovery">
  モデル検出
</h2>

`ANTHROPIC_BASE_URL` が Anthropic Messages フォーマットを公開するゲートウェイを指す場合、Claude Code はスタートアップ時にゲートウェイの `/v1/models` エンドポイントをクエリし、返されたモデルを `/model` ピッカーに追加できます。あなたまたはあなたの管理者が [`modelPicker`](/docs/ja/settings-reference#modelpicker) ラインアップで `replaceBuiltInOptions` を設定した場合、Claude Code はピッカーから検出されたモデルを非表示にします。

開発者は [`CLAUDE_CODE_ENABLE_GATEWAY_MODEL_DISCOVERY=1`](/docs/ja/env-vars) を設定することで有効にします。独自の環境またはマネージド設定を通じて。検出はデフォルトでオフになっているため、共有 API キーでバックアップされたゲートウェイはすべてのユーザーにキーがアクセスできるすべてのモデルを表示しません。

<h3 id="when-discovery-runs">
  検出が実行される場合
</h3>

検出は Anthropic Messages フォーマットにのみ適用されます。以下の場合は実行されません：

* `ANTHROPIC_BASE_URL` も設定されている場合でも、任意の `CLAUDE_CODE_USE_*` プロバイダー変数が設定されている
* `ANTHROPIC_BASE_URL` が設定されていないか、`api.anthropic.com` を指している

検出は [非必須トラフィックがオフになっている](/docs/ja/llm-gateway-connect#turn-off-traffic-outside-the-gateway-path) 場合でも実行されます。リクエストはゲートウェイのみに送信されるためです。v2.1.257 より前では、非必須トラフィックがオフになっている間は検出は実行されませんでした。

<h3 id="request-and-response">
  リクエストとレスポンス
</h3>

リクエストは 3 秒のタイムアウト付きの `GET /v1/models?limit=1000` であり、リダイレクトはクレデンシャルがリダイレクトターゲットにリークされないように失敗として扱われます。`/v1/models` に遅く応答するか、リダイレクトするゲートウェイ（`http` から `https` へのリダイレクトでも）は検出を静かに失敗させます。設定されたベース URL で直接エンドポイントを提供してください。

Claude Code は検出リクエストを以下の両方のクレデンシャルヘッダーで送信し、値が解決されないヘッダーは省略します。両方のヘッダーを送信するには Claude Code v2.1.248 以降が必要です。以前のバージョンは `ANTHROPIC_AUTH_TOKEN` が設定されている場合は `Authorization` のみを送信し、それ以外の場合は `x-api-key` のみを送信します。

* `Authorization`：`ANTHROPIC_AUTH_TOKEN` をベアラートークンとして、またはそれ以外の場合は [`apiKeyHelper`](/docs/ja/llm-gateway-connect#rotate-credentials-with-apikeyhelper) 値をベアラートークンとして。その場合、Claude Code はリクエストを送信する前にヘルパーが戻るのを待ちます。
* `x-api-key`：Claude Code が解決した API キー（`ANTHROPIC_API_KEY` など）。ヘルパー値が唯一のクレデンシャルである場合、このヘッダーもそれを含むため、値は両方のヘッダーに到達します。

Claude Code は `ANTHROPIC_CUSTOM_HEADERS` からのすべてのヘッダーも送信します。カスタムヘッダーが空でない値を持つ場合、Claude Code はそれを同じ名前の組み込みヘッダーの代わりに送信し、名前を大文字と小文字を区別せずにマッチングします。

どちらのクレデンシャルヘッダーの値も解決されない場合、Claude Code は検出をスキップし、`claude --debug` セッションのデバッグログに `[gatewayDiscovery] skipped` 行を書き込みます。`ANTHROPIC_CUSTOM_HEADERS` を通じてのみクレデンシャルを提供する場合、Claude Code は検出をスキップします。

Claude Code はレスポンスの `data` 配列の各エントリから `id`、オプションの `display_name`、およびオプションの `description` を読み取ります：

```json theme={null}
{
  "data": [
    {
      "id": "claude-sonnet-4-6",
      "display_name": "Claude Sonnet 4.6",
      "description": "Default model for everyday coding tasks"
    },
    { "id": "claude-opus-4-8" }
  ]
}
```

Claude Code は `id` が文字列内の任意の場所に `claude` または `anthropic` を含むエントリを保持し、大文字と小文字を区別せずにマッチングし、残りを無視します。`vertex_ai/claude-sonnet-4-6` または `bedrock/anthropic.claude-sonnet-4-5` などのプロバイダープレフィックス付き ID はフィルターを通過します。どちらの部分文字列も含まない ID は通過しません。v2.1.223 より前では、Claude Code は `id` が `claude` または `anthropic` で始まる場合のみエントリを保持し、プロバイダープレフィックス付き ID を非表示にしていました。

<h3 id="picker-entries-and-caching">
  ピッカーエントリとキャッシング
</h3>

ピッカーは、開発者が Claude Code で `/model` を実行するときに開く対話型モデルリストです。各検出されたエントリは、ゲートウェイが `id` と異なるものを送信する場合、`display_name` をその名前として使用します。それ以外の場合、エントリは Claude Code が [`id` を認識する](/docs/ja/model-config#customize-pinned-model-display-and-capabilities) 場合はモデルの名前を表示し、認識しない場合は `id` を表示します。たとえば、`id` が `my-gateway-claude-sonnet-4-6` で `display_name` がないエントリは `Sonnet 4.6` として表示されます。

検出は [`availableModels` マネージド設定](/docs/ja/settings-reference#availablemodels) が許可するモデルのみを追加します。

各エントリはモデルの `description` も表示し、1 行に折りたたまれます。`description` がないエントリは代わりに「ゲートウェイから」と表示されます。v2.1.257 より前では、すべての検出されたエントリが「ゲートウェイから」と表示されていました。

検出された ID は、ピッカーに既に存在する行と一致する場合、独自の行を取得しません：

* 同じ ID：検出された ID は既存の行の ID と正確に一致するか、2 つの ID は同じ [Fable](/docs/ja/model-config#work-with-fable) バージョンのスペルです。
* 組み込みエイリアスと同じモデル：検出された明示的な ID が組み込みエイリアスが現在解決するモデルに名前を付ける場合、ピッカーはエイリアス行のみを表示します。たとえば、`sonnet` が `claude-sonnet-5` に解決される間、検出された `claude-sonnet-5` は `sonnet` 行に折りたたまれ、検出された `claude-sonnet-4-6` は依然として独自の行を取得します。v2.1.197 より前では、Claude Code はこれらの ID を組み込み行に折りたたまなかったため、`claude-sonnet-5` も独自の「ゲートウェイから」行を取得しました。

結果は `~/.claude/cache/gateway-models.json` にキャッシュされます。Windows では `%USERPROFILE%\.claude\cache\gateway-models.json`。各スタートアップで更新されます。[`CLAUDE_CONFIG_DIR`](/docs/ja/env-vars) を設定した場合、キャッシュはそのディレクトリの代わりにそのディレクトリの下に存在します。リクエストが失敗するか、ゲートウェイが `/v1/models` を実装しない場合、ピッカーは前回のスタートアップからのキャッシュリストまたは組み込みモデルリストにフォールバックします。ゲートウェイが検出フィルターと一致しないエイリアスの下で Claude モデルを提供する場合、開発者は [モデル設定](/docs/ja/model-config) 変数を使用してそれらのエイリアスを手動で追加できます。

<h2 id="related-resources">
  関連リソース
</h2>

ゲートウェイドキュメントセットの残りと基礎となる API リファレンス：

* [ゲートウェイの概要](/docs/ja/gateways)：ゲートウェイとは何か、および Claude アプリゲートウェイと別の製品の間で選択する方法
* [その他の LLM ゲートウェイ](/docs/ja/llm-gateway)：組織が実行するゲートウェイをロールアウトする方法、および claude.ai サブスクリプションとどのように相互作用するか
* [組織用 LLM ゲートウェイのロールアウト](/docs/ja/llm-gateway-rollout)：このガイドを使用する管理者チェックリスト
* [Claude Code を LLM ゲートウェイに接続](/docs/ja/llm-gateway-connect)：開発者ごとの設定とトラブルシューティング表
* [ベータヘッダーリファレンス](https://platform.claude.com/docs/en/api/beta-headers)：現在の `anthropic-beta` 値のセット
* [Messages API](https://platform.claude.com/docs/en/api/messages)：Anthropic フォーマットゲートウェイが実装する API フォーマット
