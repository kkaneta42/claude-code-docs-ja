> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# エラーリファレンス

> Claude Code のランタイムエラーメッセージを検索し、各エラーの意味と修正方法を確認できます。

このページでは、Claude Code が表示するランタイムエラーと各エラーからの復旧方法、および応答がエラーなしで異常に見える場合に確認すべき内容を一覧表示しています。セットアップ中の `command not found` や TLS エラーなどのインストールエラーについては、[トラブルシューティング インストールとログイン](/ja/troubleshoot-install)を参照してください。

これらのエラーと復旧コマンドは、CLI、[デスクトップアプリ](/ja/desktop)、および[ウェブ上の Claude Code](/ja/claude-code-on-the-web)全体に適用されます。これら 3 つはすべて同じ Claude Code CLI をラップしているためです。サーフェス固有の問題については、そのサーフェスのページのトラブルシューティングセクションを参照してください。

<Note>
  Claude Code は、モデルレスポンスについて Claude API を呼び出すため、ほとんどのランタイムエラーは基盤となる API エラーコードにマップされます。このページでは、Claude Code 内での各エラーの意味と復旧方法について説明しています。生の HTTP ステータスコード定義については、[Claude Platform エラーリファレンス](https://platform.claude.com/docs/en/api/errors)を参照してください。
</Note>

<h2 id="find-your-error">
  エラーを検索する
</h2>

ターミナルに表示されるメッセージを以下のセクションと照合してください。

| メッセージ                                                                                         | セクション                                                                                         |
| :-------------------------------------------------------------------------------------------- | :-------------------------------------------------------------------------------------------- |
| `API Error: 500 Internal server error`                                                        | [サーバーエラー](#api-error-500-internal-server-error)                                               |
| `API Error: Repeated 529 Overloaded errors`                                                   | [サーバーエラー](#api-error-repeated-529-overloaded-errors)                                          |
| `Request timed out`                                                                           | [サーバーエラー](#request-timed-out)、またはメッセージがインターネット接続に言及している場合は[ネットワーク](#unable-to-connect-to-api) |
| `<model> is temporarily unavailable, so auto mode cannot determine the safety of...`          | [サーバーエラー](#auto-mode-cannot-determine-the-safety-of-an-action)                                |
| `Auto mode could not evaluate this action and is blocking it for safety`                      | [サーバーエラー](#auto-mode-cannot-determine-the-safety-of-an-action)                                |
| `Auto mode classifier transcript exceeded context window`                                     | [サーバーエラー](#auto-mode-cannot-determine-the-safety-of-an-action)                                |
| `You've hit your session limit` / `You've hit your weekly limit`                              | [使用制限](#you%E2%80%99ve-hit-your-session-limit)                                                |
| `Usage credits required for 1M context`                                                       | [使用制限](#usage-credits-required-for-1m-context)                                                |
| `Server is temporarily limiting requests`                                                     | [使用制限](#server-is-temporarily-limiting-requests)                                              |
| `Request rejected (429)`                                                                      | [使用制限](#request-rejected-429)                                                                 |
| `Credit balance is too low`                                                                   | [使用制限](#credit-balance-is-too-low)                                                            |
| `Not logged in · Please run /login`                                                           | [認証](#not-logged-in)                                                                          |
| `Could not resolve authentication method`                                                     | [認証](#could-not-resolve-authentication-method)                                                |
| `Invalid API key`                                                                             | [認証](#invalid-api-key)                                                                        |
| `This organization has been disabled`                                                         | [認証](#this-organization-has-been-disabled)                                                    |
| `Your organization has disabled API key authentication`                                       | [認証](#your-organization-has-disabled-api-key-authentication)                                  |
| `Your organization has disabled Claude subscription access`                                   | [認証](#your-organization-has-disabled-claude-subscription-access)                              |
| `Routines are disabled by your organization's policy`                                         | [認証](#routines-are-disabled-by-your-organization%E2%80%99s-policy)                            |
| `Remote Control is only available when using Claude via api.anthropic.com`                    | [認証](#remote-control-requires-the-anthropic-api)                                              |
| `OAuth token revoked` / `OAuth token has expired`                                             | [認証](#oauth-token-revoked-or-expired)                                                         |
| `does not meet scope requirement user:profile`                                                | [認証](#oauth-scope-requirement)                                                                |
| `Unable to connect to API`                                                                    | [ネットワーク](#unable-to-connect-to-api)                                                           |
| `Waiting for API response · will retry in`                                                    | [自動リトライ](#automatic-retries)、または継続する場合は[ネットワーク](#unable-to-connect-to-api)                    |
| `SSL certificate verification failed`                                                         | [ネットワーク](#ssl-certificate-errors)                                                             |
| `403` with `x-deny-reason: host_not_allowed` in a cloud or routine session                    | [ネットワーク](#host-not-allowed-in-a-cloud-session)                                                |
| `Prompt is too long`                                                                          | [リクエストエラー](#prompt-is-too-long)                                                               |
| `Error during compaction: Conversation too long`                                              | [リクエストエラー](#error-during-compaction-conversation-too-long)                                    |
| `Request too large`                                                                           | [リクエストエラー](#request-too-large)                                                                |
| `Image was too large`                                                                         | [リクエストエラー](#image-was-too-large)                                                              |
| `Unable to resize image`                                                                      | [リクエストエラー](#unable-to-resize-image)                                                           |
| `PDF too large` / `PDF is password protected`                                                 | [リクエストエラー](#pdf-errors)                                                                       |
| `Extra inputs are not permitted`                                                              | [リクエストエラー](#extra-inputs-are-not-permitted)                                                   |
| `There's an issue with the selected model`                                                    | [リクエストエラー](#there%E2%80%99s-an-issue-with-the-selected-model)                                 |
| `Claude Opus is not available with the Claude Pro plan`                                       | [リクエストエラー](#claude-opus-is-not-available-with-the-claude-pro-plan)                            |
| `Model ... is restricted by your organization's settings`                                     | [リクエストエラー](#model-is-restricted-by-your-organization%E2%80%99s-settings)                      |
| `thinking.type.enabled is not supported for this model`                                       | [リクエストエラー](#thinking-type-enabled-is-not-supported-for-this-model)                            |
| `max_tokens must be greater than thinking.budget_tokens`                                      | [リクエストエラー](#thinking-budget-exceeds-output-limit)                                             |
| `API Error: 400 due to tool use concurrency issues`                                           | [リクエストエラー](#tool-use-or-thinking-block-mismatch)                                              |
| `Claude Code is unable to respond to this request, which appears to violate our Usage Policy` | [リクエストエラー](#usage-policy-refusal)                                                             |
| レスポンスの品質が通常より低いように見える                                                                         | [レスポンス品質](#responses-seem-lower-quality-than-usual)                                           |

<h2 id="automatic-retries">
  自動リトライ
</h2>

Claude Code は、エラーを表示する前に一時的な障害をリトライします。サーバーエラー、オーバーロードレスポンス、リクエストタイムアウト、一時的な 429 スロットル、および接続の切断はすべて、指数バックオフで最大 10 回リトライされます。リトライ中、スピナーは `Retrying in Ns · attempt x/y` カウントダウンを表示します。

{/* min-version: 2.1.185 */}リクエストがまだ保留中の状態で、レスポンスストリームで 20 秒間データが到着しない場合、スピナーは `Waiting for API response · will retry in … · check your network` を表示します。これはリトライが開始される前です。リクエストはまだ失敗していません。カウントダウンは Claude Code が停止した接続を中止してリトライする時点まで実行されるため、データが再開されるか、リトライが成功するとバナーは自動的にクリアされます。v2.1.185 以降、閾値は 20 秒です。それより前のバージョンでは、異なる表現でバナーが 10 秒後に表示されます。すべての試行で再度表示される場合は、[ネットワークの問題](#unable-to-connect-to-api)として扱ってください。

このページのエラーの 1 つが表示されている場合、これらのリトライはすでに使い果たされています。これらの環境変数で動作をチューニングできます。

| 変数                                           | デフォルト  | 効果                                                                                                       |
| :------------------------------------------- | :----- | :------------------------------------------------------------------------------------------------------- |
| [`CLAUDE_CODE_MAX_RETRIES`](/ja/env-vars)    | 10     | リトライ試行回数。{/* min-version: 2.1.186 */}v2.1.186 以降、15 に制限されています。スクリプトで障害をより速く表示するには低くします。                  |
| [`CLAUDE_CODE_RETRY_WATCHDOG`](/ja/env-vars) | 未設定    | CI ジョブなどの無人セッションで `1` に設定して、`CLAUDE_CODE_MAX_RETRIES` 試行後に失敗する代わりに、`429` および `529` キャパシティエラーを無限にリトライします。 |
| [`API_TIMEOUT_MS`](/ja/env-vars)             | 600000 | リクエストごとのタイムアウト（ミリ秒単位）。遅いネットワークまたはプロキシの場合は高くします。                                                          |

<h2 id="server-errors">
  サーバーエラー
</h2>

これらのエラーは、アカウントまたはリクエストではなく、推論プロバイダーから発生します。Anthropic API では Anthropic インフラストラクチャを意味します。Bedrock、Vertex AI、Foundry、またはカスタムゲートウェイでは、そのプロバイダーのインフラストラクチャを意味します。

<h3 id="api-error-500-internal-server-error">
  API Error: 500 Internal server error
</h3>

Claude Code は、5xx レスポンスに対してステータスコードと API のエラーメッセージを表示します。以下の例は Anthropic API での 500 レスポンスを示しています：

```text theme={null}
API Error: 500 Internal server error. This is a server-side issue, usually temporary — try again in a moment. If it persists, check https://status.claude.com.
```

末尾の文は、サービスヘルスを確認する場所を示し、プロバイダーによって異なります。Bedrock、Vertex AI、および Foundry の設定は、そのプロバイダーのサービスステータスを示します。カスタム `ANTHROPIC_BASE_URL` はゲートウェイホストを示します。

これは API 内の予期しない障害を示しています。プロンプト、設定、またはアカウントが原因ではありません。

**対応方法：**

* [status.claude.com](https://status.claude.com) またはメッセージに示されているプロバイダーのステータスページで、アクティブなインシデントを確認してください
* 1 分待ってからメッセージを再度送信してください。元のメッセージはまだ会話に残っているため、長いプロンプトの場合は全体を貼り付ける代わりに `try again` と入力できます。
* エラーが投稿されたインシデントなしで続く場合は、`/feedback` を実行して、Anthropic がリクエスト詳細で調査できるようにしてください。環境で `/feedback` が利用できない場合は、[エラーを報告する](#report-an-error) を参照してください。

<h3 id="api-error-repeated-529-overloaded-errors">
  API Error: Repeated 529 Overloaded errors
</h3>

API は、すべてのユーザー全体で一時的に容量に達しています。Claude Code は、このメッセージを表示する前に既に数回リトライしています：

```text theme={null}
API Error: Repeated 529 Overloaded errors. The API is at capacity — this is usually temporary. Try again in a moment. If it persists, check https://status.claude.com.
```

末尾の文は、500 エラーと同じ方法でプロバイダーによって異なります。529 は使用制限ではなく、クォータに対してカウントされません。

**対応方法：**

* [status.claude.com](https://status.claude.com) またはメッセージに示されているプロバイダーのステータスページで、容量に関する通知を確認してください
* 数分後に再度試してください
* `/model` を実行して別のモデルに切り替えて、容量がモデルごとに追跡されるため、作業を続けてください。Claude Code は、1 つのモデルが特に高い負荷を受けている場合、たとえば `Opus is experiencing high load, please use /model to switch to Sonnet` のようにこれを行うようにプロンプトを表示します。

<h3 id="request-timed-out">
  Request timed out
</h3>

API は接続期限前に応答しませんでした。

```text theme={null}
Request timed out
```

これは、高負荷期間中または非常に大きなレスポンスが生成されている場合に発生する可能性があります。デフォルトのリクエストタイムアウトは 10 分です。

**対応方法：**

* リクエストを再試行してください
* 長時間実行されるタスクの場合は、作業をより小さいプロンプトに分割してください
* 遅いネットワークまたはプロキシが原因の場合は、[自動リトライ](#automatic-retries) で説明されているように `API_TIMEOUT_MS` を上げてください
* タイムアウトが頻繁で、ネットワークが正常な場合は、以下の[ネットワークと接続エラー](#network-and-connection-errors) を参照してください

<h3 id="auto-mode-cannot-determine-the-safety-of-an-action">
  Auto mode cannot determine the safety of an action
</h3>

[auto mode](/ja/permission-modes#eliminate-prompts-with-auto-mode) がアクションを分類するために使用するモデルが決定を生成できなかったため、auto mode はアクションを自動的に承認しませんでした。表示されるメッセージは、分類器が失敗した理由によって異なります。

読み取り、検索、および作業ディレクトリ内の編集は分類器をスキップするため、これらすべてのケースで機能し続けます。

分類器モデルがオーバーロードされている場合：

```text theme={null}
<model> is temporarily unavailable, so auto mode cannot determine the safety of <tool> right now. Wait briefly and then try this action again.
```

**対応方法：**

* 数秒後に再試行してください。Claude は同じメッセージを見て、通常は自動的に再試行します
* リトライが失敗し続ける場合は、読み取り専用タスクを続行し、後でブロックされたアクションに戻ってください
* これは一時的であり、[auto mode 適格性](/ja/permission-modes#eliminate-prompts-with-auto-mode) とは無関係です。設定を変更する必要はありません

分類器が解析不可能なレスポンスを返した場合：

```text theme={null}
Auto mode could not evaluate this action and is blocking it for safety — run with --debug for details
```

**対応方法：**

* アクションを再試行してください。これは通常、次の試行で成功します
* `claude --debug` を実行してアクションを繰り返し、デバッグログで基になる分類器レスポンスを確認してください

会話が分類器のコンテキストウィンドウより大きくなった場合：

```text theme={null}
Auto mode classifier transcript exceeded context window — falling back to manual approval (try /compact to reduce conversation size)
```

インタラクティブセッションでは、auto mode はそのアクションに対して通常の権限プロンプトにフォールバックするため、手動で承認または拒否できます。[非インタラクティブモード](/ja/headless) では、トランスクリプトのみが増加し、リトライが成功できないため、実行が中止されます。

**対応方法：**

* 表示されるプロンプトでアクションを承認または拒否してください
* `/compact` を実行して会話サイズを削減し、後続のアクションが分類器ウィンドウ内に収まるようにしてください

<h2 id="usage-limits">
  使用制限
</h2>

これらのエラーは、アカウントまたはプランに関連するクォータに達したことを意味します。これらは、すべてに影響する[サーバーエラー](#server-errors)とは異なります。

<h3 id="you’ve-hit-your-session-limit">
  セッション制限に達しました
</h3>

サブスクリプションプランには、ローリング使用許容量が含まれています。使い果たされると、次のいずれかのメッセージが表示されます。

```text theme={null}
You've hit your session limit · resets 3:45pm
You've hit your weekly limit · resets Mon 12:00am
You've hit your Opus limit · resets 3:45pm
```

Claude Code は、メッセージに表示されているリセット時刻までさらなるリクエストをブロックします。

**対応方法：**

* エラーに表示されているリセット時刻を待ってください
* `/usage` を実行して、プランの制限とリセット時刻を確認してください
* `/usage-credits` を実行して、Pro および Max で追加使用量を購入するか、Team および Enterprise で管理者にリクエストしてください。[有料プランの使用量クレジット](https://support.claude.com/ja/articles/12429409-extra-usage-for-paid-claude-plans)を参照して、これがどのように請求されるかを確認してください。
* プランをアップグレードしてより高いベース制限を取得するには、[claude.com/pricing](https://claude.com/pricing)を参照してください

制限に達する前に残りの許容量を監視するには、`rate_limits` フィールドを[カスタムステータスライン](/ja/statusline#rate-limit-usage)に追加するか、デスクトップアプリでモデルピッカーの横にある[使用量リング](/ja/desktop#check-usage)をクリックしてください。

<h3 id="usage-credits-required-for-1m-context">
  1M コンテキストに使用量クレジットが必要です
</h3>

選択されたモデルは 1M トークンの拡張コンテキストウィンドウを使用しており、お客様のプランではこれを使用量クレジットを通じてのみ含めています。

```text theme={null}
API Error: Usage credits required for 1M context · run /usage-credits to turn them on, or /model to switch to standard context
```

これはクォータ枯渇ではなく、エンタイトルメントチェックです。セッションおよび週間許容量に容量が残っている場合でも発火します。[拡張コンテキスト](/ja/model-config#extended-context)を参照して、どのプランが 1M コンテキストを直接含めており、どのプランが使用量クレジットを必要とするかを確認してください。

{/* min-version: 2.1.172 */}このエラーがコンテキストが 200K トークンを超えて成長したために会話の途中で表示される場合、Claude Code は自動的に会話を標準コンテキスト制限の下に圧縮し、その後セッションをその制限に保つため、アクションは不要です。v2.1.172 より前のバージョンでは、エラーは `/compact` を含むその後のすべてのリクエストで繰り返されました。これらのバージョンで復旧するには `/clear` を実行してください。以下の手順は、明示的に `[1m]` モデルを選択した場合に適用されます。

**対応方法：**

* `/model` を実行して、`[1m]` サフィックスのないバリアントを選択して、標準コンテキストウィンドウにフォールバックしてください
* `/usage-credits` を実行して、Pro および Max で 1M バリアントのメーター制課金をオンにするか、Team および Enterprise で管理者にリクエストしてください
* `/model` の後もエラーが続く場合は、1M モデル ID が他の場所に設定されている可能性があります。優先順位順に確認する設定場所については、[選択されたモデルに問題があります](#there%E2%80%99s-an-issue-with-the-selected-model)を参照してください。
* モデルピッカーから 1M バリアントを完全に削除するには、[`CLAUDE_CODE_DISABLE_1M_CONTEXT=1`](/ja/env-vars)を設定してください

<h3 id="server-is-temporarily-limiting-requests">
  サーバーが一時的にリクエストを制限しています
</h3>

API は、プランクォータとは無関係の短期的なスロットルを適用しました。

```text theme={null}
API Error: Server is temporarily limiting requests (not your usage limit)
```

これは、表示される前に[自動的にリトライ](#automatic-retries)されます。

**対応方法：**

* 少し待ってから再度試してください
* 続く場合は [status.claude.com](https://status.claude.com)を確認してください

<h3 id="request-rejected-429">
  リクエストが拒否されました（429）
</h3>

API キー、Amazon Bedrock プロジェクト、または Google Vertex AI プロジェクト用に設定されたレート制限に達しました。

```text theme={null}
API Error: Request rejected (429) · this may be a temporary capacity issue. If it persists, check https://status.claude.com.
```

末尾の文は、サービスの健全性を確認する場所を示し、プロバイダーによって異なります。Bedrock および Vertex AI 設定では、Anthropic ステータスページの代わりにそのプロバイダーのサービスステータスを示します。カスタム `ANTHROPIC_BASE_URL` はゲートウェイホストを示します。

**対応方法：**

* `/status` を実行して、アクティブな認証情報が予想されるものであることを確認してください。環境内の迷走した `ANTHROPIC_API_KEY` は、サブスクリプションではなく低層キーを通じてリクエストをルーティングできます。
* プロバイダーコンソールでアクティブな制限を確認し、必要に応じてより高い層をリクエストしてください
* Anthropic API キーについては、[レート制限リファレンス](https://platform.claude.com/docs/ja/api/rate-limits)を参照して、層がどのように機能し、ワークスペースごとのキャップを設定する方法を確認してください
* 同時実行性を削減します。[`CLAUDE_CODE_MAX_TOOL_USE_CONCURRENCY`](/ja/env-vars)を低くするか、多くの並列サブエージェントの実行を避けるか、高ボリュームのスクリプト実行用に `/model` で小さいモデルに切り替えてください

<h3 id="credit-balance-is-too-low">
  クレジット残高が不足しています
</h3>

Console 組織は、プリペイドクレジットを使い果たしました。

```text theme={null}
Credit balance is too low
```

**対応方法：**

* [platform.claude.com/settings/billing](https://platform.claude.com/settings/billing)でクレジットを追加し、そこで自動リロードを有効にして、残高がゼロに達する前に補充されるようにすることを検討してください
* Pro、Max、Team、または Enterprise プランがある場合は、`/login` でサブスクリプション認証に切り替えてください
* Console でワークスペースごとの支出キャップを設定して、単一のプロジェクトが組織の残高を枯渇させるのを防いでください。[コストを効果的に管理する](/ja/costs)を参照してください。

<h2 id="authentication-errors">
  認証エラー
</h2>

これらのエラーは、Claude Code が API に対して身元を証明できないことを意味します。いつでも `/status` を実行して、現在アクティブな認証情報を確認してください。

<h3 id="not-logged-in">
  Not logged in
</h3>

このセッションで有効な認証情報は利用できません。

```text theme={null}
Not logged in · Please run /login
```

**対応方法：**

* `/login` を実行して、Claude サブスクリプションまたは Console アカウントで認証してください
* 環境変数で認証されることを期待していた場合は、`ANTHROPIC_API_KEY` が設定され、`claude` を起動したシェルでエクスポートされていることを確認してください
* インタラクティブログインが不可能な CI または自動化の場合は、起動時にキーをフェッチする[`apiKeyHelper`](/ja/settings#available-settings)スクリプトを設定してください
* [認証の優先順位](/ja/authentication#authentication-precedence)を参照して、複数の認証情報が存在する場合にどの認証情報が優先されるかを理解してください

ログインを繰り返しプロンプトされている場合は、[ログインしていないまたはトークンの有効期限が切れている](/ja/troubleshoot-install#not-logged-in-or-token-expired)を参照して、システムクロックと macOS キーチェーンの修正を確認してください。

<h3 id="could-not-resolve-authentication-method">
  Could not resolve authentication method
</h3>

セッションが認証情報なしで API クライアントに到達しました。これは[バックグラウンドセッション](/ja/agent-view)、クラウドセッション、および最初のリクエストの前にインタラクティブログインチェックが実行されない Agent SDK コンテキストに表示されます。

```text theme={null}
Could not resolve authentication method. Expected one of apiKey, authToken, credentials, config, or profile to be set. Or for one of the "X-Api-Key" or "Authorization" headers to be explicitly omitted
```

{/* min-version: 2.1.174 */}v2.1.174 より前では、バックグラウンドまたはクラウドセッションがアイドル状態の事前初期化ワーカーに割り当てられている場合、有効な認証情報が設定されていても、このように失敗する可能性がありました。アップグレードして復旧してください。現在のバージョンでは、エラーはワーカープロセスで認証情報が利用できなかったことを意味します。

**対応方法：**

* バックグラウンドまたはクラウドセッションでこれが表示され、認証情報が既に設定されている場合は、v2.1.174 以降にアップグレードしてください
* `ANTHROPIC_API_KEY`、`CLAUDE_CODE_OAUTH_TOKEN`、またはクラウドプロバイダーの認証情報が、インタラクティブシェルだけでなく、ワーカーを起動する環境で設定されていることを確認してください
* Agent SDK については、[認証セットアップ](/ja/agent-sdk/overview#get-started)を参照してください
* 同じ環境のインタラクティブセッションで `/status` を実行して、どの認証情報ソースが解決されるかを確認してください

<h3 id="invalid-api-key">
  Invalid API key
</h3>

`ANTHROPIC_API_KEY` 環境変数または `apiKeyHelper` スクリプトが、API が拒否したキーを返しました。

```text theme={null}
Invalid API key · Fix external API key
```

**対応方法：**

* タイプミスを確認し、キーが [Console](https://platform.claude.com/settings/keys) で取り消されていないことを確認してください
* 同じシェルで `env | grep ANTHROPIC` を実行してください。direnv、dotenv シェルプラグイン、IDE ターミナルなどのツールは、明示的に設定せずにプロジェクト内の `.env` ファイルから古いキーをロードできます。
* `ANTHROPIC_API_KEY` をアンセットして `/login` を実行し、代わりにサブスクリプション認証を使用してください
* キーが[`apiKeyHelper`](/ja/settings#available-settings)スクリプトから来ている場合は、スクリプトを直接実行して、stdout に有効なキーを出力することを確認してください
* `/status` を実行して、Claude Code が実際に使用している認証情報ソースを確認してください

<h3 id="this-organization-has-been-disabled">
  This organization has been disabled
</h3>

無効な Console 組織からの古い `ANTHROPIC_API_KEY` がサブスクリプションログインをオーバーライドしています。

```text theme={null}
Your ANTHROPIC_API_KEY belongs to a disabled organization · Unset the environment variable to use your other credentials
API Error: 400 ... This organization has been disabled.
```

環境変数は `/login` より優先されるため、シェルプロファイルでエクスポートされたキーまたは `.env` ファイルからロードされたキーは、機能する Pro または Max サブスクリプションがある場合でも使用されます。非インタラクティブモード（`-p`）では、キーが存在する場合は常に使用されます。

**対応方法：**

* 現在のシェルで `ANTHROPIC_API_KEY` をアンセットし、シェルプロファイルから削除してから、`claude` を再起動してください
* その後 `/status` を実行して、アクティブな認証情報がサブスクリプションであることを確認してください
* 環境変数が設定されておらず、エラーが続く場合、無効な組織は `/login` に関連付けられているものです。サポートに連絡するか、別のアカウントでサインインしてください。

<h3 id="your-organization-has-disabled-api-key-authentication">
  Your organization has disabled API key authentication
</h3>

Console 組織の管理者が API キー認証をオフにしているため、API が Claude Code が送信しているキーを拒否しています。`·` の後の復旧ヒントは、キーがどこから来たかによって異なります。

```text theme={null}
Your organization has disabled API key authentication · Run /login to sign in with your claude.ai account
Your organization has disabled API key authentication · Unset ANTHROPIC_API_KEY to use your claude.ai account instead
Your organization has disabled API key authentication · Unset ANTHROPIC_API_KEY and run /login to sign in with your claude.ai account
Your organization has disabled API key authentication · Unset the apiKeyHelper setting and run /login to sign in with your claude.ai account
```

環境変数と `apiKeyHelper` は `/login` より優先されるため、どちらかがキーを供給している間は `/login` を実行するだけでは役に立ちません。[認証の優先順位](/ja/authentication#authentication-precedence)を参照してください。

**対応方法：**

* メッセージが `ANTHROPIC_API_KEY` に言及している場合は、現在のシェルでアンセットし、シェルプロファイルまたは `.env` ファイルから削除してから、`claude` を再起動してください
* メッセージが `apiKeyHelper` に言及している場合は、`settings.json` から[`apiKeyHelper`](/ja/settings#available-settings)設定を削除してください
* `/login` を実行して、claude.ai アカウントでサインインしてください
* その後 `/status` を実行して、アクティブな認証情報が API キーではなくサブスクリプションであることを確認してください
* 自動化に API キー認証が必要な場合は、組織の管理者に Console で再度有効にするよう依頼してください

<h3 id="your-organization-has-disabled-claude-subscription-access">
  Your organization has disabled Claude subscription access
</h3>

Claude 組織がサブスクリプションログインで Claude Code にサインインすることを許可していません。同じアカウントで `/login` を再度実行すると、同じエラーが返されます。

```text theme={null}
Your organization has disabled Claude subscription access for Claude Code · Use an Anthropic API key instead, or ask your admin to enable access
```

これはサーバー側の組織設定であるため、ローカル設定、環境変数、または CLI フラグからオーバーライドすることはできません。Agent SDK および `-p` 非インタラクティブモードは、これを `oauth_org_not_allowed` エラーコードとして表示します。

**対応方法：**

* 管理者に組織の Claude Code アクセスを有効にするよう依頼してください
* サブスクリプションの代わりに Console API キーで認証してください。セットアップについては、[Claude Console 認証](/ja/authentication#claude-console-authentication)を参照してください。
* 管理者であり、アクセスを有効にするオプションが表示されない場合は、[Anthropic サポート](https://support.claude.com)に連絡してください

<h3 id="routines-are-disabled-by-your-organization’s-policy">
  Routines are disabled by your organization's policy
</h3>

チームまたはエンタープライズ組織の Owner が、組織レベルでルーチンをオフにしています。エラーは、`/schedule` および claude.ai/code の [Routines](/ja/routines) UI を含め、ルーチンを作成または実行しようとするときに表示されます。

```text theme={null}
Routines are disabled by your organization's policy.
```

これはサーバー側の設定であるため、ローカル設定、環境変数、または CLI フラグからオーバーライドすることはできません。

**対応方法：**

* 組織の Owner に [claude.ai/admin-settings/claude-code](https://claude.ai/admin-settings/claude-code) で **Routines** トグルを有効にするよう依頼してください
* 組織レベルのルーチンを必要としない 1 回限りのスケジュール済み作業については、[スケジュール済みタスク](/ja/scheduled-tasks)を参照してください

<h3 id="remote-control-requires-the-anthropic-api">
  Remote Control requires the Anthropic API
</h3>

セッションが Anthropic API と直接通信していないため、[Remote Control](/ja/remote-control)がペアリングする claude.ai バックエンドがありません。

```text theme={null}
Remote Control is only available when using Claude via api.anthropic.com.
```

これは Amazon Bedrock、Google Vertex AI、Microsoft Foundry に表示されます。{/* min-version: 2.1.196 */}v2.1.196 以降では、[`ANTHROPIC_BASE_URL`](/ja/env-vars)が `api.anthropic.com` 以外のホスト（[LLM ゲートウェイ](/ja/llm-gateway)やプロキシなど）を指している場合にも表示されます。claude.ai でサインインしている場合でも表示されます。

**対応方法：**

* `ANTHROPIC_BASE_URL` をアンセットしてセッションを再起動するか、Anthropic API と直接通信するセッションから Remote Control を起動してください
* このおよび他の Remote Control スタートアップメッセージについては、[Remote Control のトラブルシューティング](/ja/remote-control#troubleshooting)を参照してください

<h3 id="oauth-token-revoked-or-expired">
  OAuth token revoked or expired
</h3>

保存されたログインは有効ではなくなりました。取り消されたトークンは、どこかでサインアウトしたか、管理者がアクセスを削除したことを意味します。期限切れのトークンは、自動リフレッシュがセッション中に失敗したことを意味します。

```text theme={null}
OAuth token revoked · Please run /login
OAuth token has expired · Please run /login
API Error: 401 ... authentication_error
```

**対応方法：**

* `/login` を実行して再度サインインしてください
* 再認証後、同じセッション内でエラーが返される場合は、最初に `/logout` を実行して保存されたトークンを完全にクリアしてから、`/login` を実行してください
* 起動全体でログインを繰り返しプロンプトされている場合は、[トラブルシューティング](/ja/troubleshoot-install#not-logged-in-or-token-expired)のシステムクロックと macOS キーチェーンチェックを参照してください
* `403 Forbidden` や OAuth ブラウザの問題を含む他の障害については、[ログインと認証](/ja/troubleshoot-install#login-and-authentication)を参照してください

<h3 id="oauth-scope-requirement">
  OAuth scope requirement
</h3>

保存されたトークンは、新しい機能が必要とする権限スコープより前のものです。これは、`/usage` とステータスラインの使用量インジケーターから最も頻繁に表示されます。

```text theme={null}
OAuth token does not meet scope requirement: user:profile
```

**対応方法：**

* `/login` を実行して、現在のスコープで新しいトークンを作成してください。ログアウトする必要はありません。

<h2 id="network-and-connection-errors">
  ネットワークと接続エラー
</h2>

これらのエラーは、Claude Code がネットワークリクエストで API に到達できなかったことを意味します。これらは通常、ローカルネットワーク、プロキシ、またはファイアウォール、あるいはクラウド環境のネットワークポリシーから発生します。

<h3 id="unable-to-connect-to-api">
  API に接続できない
</h3>

API への TCP 接続に失敗したか、完了しませんでした。

```text theme={null}
Unable to connect to API. Check your internet connection
Unable to connect to API (ECONNREFUSED)
Unable to connect to API (ECONNRESET)
Unable to connect to API (ETIMEDOUT)
fetch failed
Request timed out. Check your internet connection and proxy settings
```

一般的な原因には、インターネットアクセスがない、`api.anthropic.com` をブロックする VPN、または設定されていない必須の企業プロキシが含まれます。

**対応方法：**

* 同じシェルから `curl -I https://api.anthropic.com` を実行して、API ホストに到達できることを確認してください。Windows PowerShell では、組み込みの `Invoke-WebRequest` エイリアスが使用されないように `curl.exe -I https://api.anthropic.com` を使用してください。
* 企業プロキシの背後にある場合は、Claude Code を起動する前に `HTTPS_PROXY` を設定し、[ネットワーク設定](/ja/network-config)を参照してください
* LLM ゲートウェイまたはリレーを通じてルーティングする場合は、[`ANTHROPIC_BASE_URL`](/ja/env-vars)をそのアドレスに設定してください。セットアップについては、[LLM ゲートウェイに Claude Code を接続する](/ja/llm-gateway-connect)を参照してください。
* ファイアウォールが[ネットワークアクセス要件](/ja/network-config#network-access-requirements)に記載されているホストを許可していることを確認してください
* 一時的な障害は[自動的にリトライ](#automatic-retries)されます。永続的な障害はローカルネットワークの問題を指しています

`curl` は成功しても Claude Code が失敗する場合、原因は通常、ネットワーク自体ではなく、ランタイムとネットワークの間にあります。

* Linux および WSL では、`/etc/resolv.conf` で到達不可能なネームサーバーを確認してください。特に WSL はホストから壊れたリゾルバーを継承できます。
* macOS では、切断または削除された VPN クライアントがトンネルインターフェースまたはルーティングルールを残す可能性があります。`ifconfig` で古い `utun` インターフェースを確認し、システム設定で VPN のネットワーク拡張を削除してください。
* Docker Desktop および同様のコンテナランタイムは、アウトバウンドトラフィックをインターセプトできます。それらを終了して再試行し、これを除外してください。

<h3 id="ssl-certificate-errors">
  SSL 証明書エラー
</h3>

ネットワーク上のプロキシまたはセキュリティアプライアンスが、独自の証明書で TLS トラフィックをインターセプトしており、Claude Code がそれを信頼していません。

```text theme={null}
Unable to connect to API: SSL certificate verification failed. Check your proxy or corporate SSL certificates
Unable to connect to API: Self-signed certificate detected
```

**対応方法：**

* 組織の CA バンドルをエクスポートし、`NODE_EXTRA_CA_CERTS=/path/to/ca-bundle.pem` で Claude Code をポイントしてください
* 完全なセットアップ手順については、[ネットワーク設定](/ja/network-config#custom-ca-certificates)を参照してください
* 証明書検証を完全に無効にする `NODE_TLS_REJECT_UNAUTHORIZED=0` を設定しないでください

<h3 id="host-not-allowed-in-a-cloud-session">
  クラウドセッションでホストが許可されていない
</h3>

クラウドセッションまたはルーチンからのアウトバウンド HTTP リクエストが、環境のネットワークポリシーによってブロックされました。

```text theme={null}
HTTP 403
x-deny-reason: host_not_allowed
```

宛先の実際の証明書と一致しない TLS 証明書が表示される場合もあります。クラウド環境はアウトバウンドトラフィックをプロキシを通じてルーティングしてネットワークポリシーを適用するため、証明書の不一致は宛先ではなくプロキシが接続を終了したことを意味します。

これはクライアント側のネットワーク問題ではありません。クラウドセッションと[ルーチン](/ja/routines)は、アウトバウンドトラフィックが環境のアローリストにフィルタリングされるサンドボックス環境内で実行されます。**デフォルト**環境は**信頼済み**アクセスを使用し、パッケージレジストリ、クラウドプロバイダー API、コンテナレジストリ、および一般的な開発ドメインの[デフォルトアローリスト](/ja/claude-code-on-the-web#default-allowed-domains)を許可しますが、その他すべてをブロックします。

**対応方法：**

* ルーチンを編集用に開くか、クラウドセッションを開始してください。**デフォルト**などの環境名を表示しているクラウドアイコンを選択して、セレクターを開いてください。環境にマウスを置き、設定アイコンをクリックしてください。
* **クラウド環境を更新**ダイアログで、**ネットワークアクセス**を**信頼済み**から**カスタム**に変更し、ブロックされたドメインを**許可されたドメイン**に追加してください。1 行に 1 つのドメインを入力してください。**デフォルトリストの一般的なパッケージマネージャーも含める**をチェックして、カスタムドメインと共に[デフォルトアローリスト](/ja/claude-code-on-the-web#default-allowed-domains)を保持してください。無制限アクセスが必要な場合は、代わりに**フル**を選択してください。
* **変更を保存**をクリックしてください。次の実行は更新されたアローリストを使用します。

アクセスレベルとデフォルトアローリストについては、[ネットワークアクセス](/ja/claude-code-on-the-web#network-access)を参照してください。ローカル CLI セッションはこのポリシーの影響を受けません。

<h2 id="request-errors">
  リクエストエラー
</h2>

これらのエラーは、API がリクエストを受け取ったが、その内容を拒否したことを意味します。

<h3 id="prompt-is-too-long">
  Prompt is too long
</h3>

会話と添付ファイルがモデルのコンテキストウィンドウを超えています。

```text theme={null}
Prompt is too long
```

**対応方法：**

* `/compact` を実行して以前のターンを要約し、スペースを解放するか、`/clear` を実行して新しく開始してください
* `/context` を実行して、ウィンドウを消費しているものの内訳を確認してください。システムプロンプト、ツール、メモリファイル、およびメッセージです
* `/mcp disable <name>` で使用していない MCP サーバーを無効にして、コンテキストからツール定義を削除してください
* 大きな `CLAUDE.md` メモリファイルをトリミングするか、関連する場合にのみロードされる[パススコープルール](/ja/memory#path-specific-rules)に指示を移動してください
* サブエージェントは親セッションからすべての MCP ツール定義を継承します。これにより、最初のターンの前にコンテキストウィンドウが満杯になる可能性があります。サブエージェントを生成する前に、使用していない MCP サーバーを無効にしてください。
* 自動コンパクトはデフォルトで有効になっており、通常このエラーを防ぎます。[`DISABLE_AUTO_COMPACT`](/ja/env-vars)を設定している場合は、再度有効にするか、ウィンドウが満杯になる前に `/compact` を手動で実行してください。

[コンテキストウィンドウを探索する](/ja/context-window)を参照して、コンテキストがどのように満杯になるかのインタラクティブビューを確認してください。

<h3 id="error-during-compaction-conversation-too-long">
  Error during compaction: Conversation too long
</h3>

`/compact` 自体が失敗しました。これは、生成される要約を保持するのに十分な空きコンテキストがないためです。

```text theme={null}
Error during compaction: Conversation too long. Press esc twice to go up a few messages and try again.
```

これは、ウィンドウが自動コンパクトがトリガーされる時点で既に満杯の場合、または `Prompt is too long` を見た後に `/compact` を実行する場合に発生する可能性があります。

**対応方法：**

* Esc を 2 回押してメッセージリストを開き、数ターン戻ってください。これにより、最新のメッセージがコンテキストから削除されます。その後、`/compact` を再度実行してください。
* 戻ることで十分なスペースが解放されない場合は、`/clear` を実行して新しいセッションを開始してください。以前の会話は保存され、`/resume` で再度開くことができます。

<h3 id="request-too-large">
  Request too large
</h3>

生のリクエストボディが、トークン化前に API のバイト制限を超えました。通常、大きく貼り付けられたファイルまたは添付ファイルが原因です。

```text theme={null}
Request too large (max 30 MB). Double press esc to go back and remove or shrink the attached content.
```

これは、[コンテキストウィンドウ制限](#prompt-is-too-long)とは別の HTTP リクエストのサイズ制限です。

**対応方法：**

* Esc を 2 回押して、サイズを超えたコンテンツを追加したターンを過ぎて戻ってください
* 大きなファイルをパスで参照して、内容を貼り付けるのではなく、Claude がチャンク単位で読み取ることができるようにしてください
* 画像については、以下の[画像が大きすぎました](#image-was-too-large)を参照してください

<h3 id="image-was-too-large">
  Image was too large
</h3>

貼り付けられた、または添付された画像が API のサイズまたは寸法制限を超えています。

```text theme={null}
Image was too large. Double press esc to go back and try again with a smaller image.
API Error: 400 ... image dimensions exceed max allowed size
```

{/* min-version: 2.1.142 */}Claude Code は処理できない画像をテキストプレースホルダーに置き換えて再試行するため、後続のメッセージは成功します。v2.1.142 より前のバージョンでは、貼り付けられた画像は会話に残る可能性があり、後続のすべてのメッセージで同じエラーが繰り返される可能性があります。これらのバージョンで復旧するには、Esc を 2 回押して、画像が追加されたターンを過ぎて戻ってください。

**対応方法：**

* 貼り付ける前に画像をリサイズしてください。API は、単一の画像の場合は最長辺で最大 8000 ピクセル、またはコンテキストに多くの画像がある場合は 2000 ピクセルの画像を受け入れます。
* 全画面ではなく、関連する領域のより厳密なスクリーンショットを撮ってください

<h3 id="unable-to-resize-image">
  Unable to resize image
</h3>

Claude Code は、API に送信する前に添付された画像をダウンスケールできませんでした。

```text theme={null}
Unable to resize image — image processing is unavailable and dimensions could not be read from the file header. Please convert the image to PNG, JPEG, GIF, or WebP.
Unable to resize image — dimensions exceed the 2000x2000px limit and image processing failed. Please resize the image to reduce its pixel dimensions.
Unable to resize image (… raw, … base64). The image exceeds the … API limit and compression failed. Please resize the image manually or use a smaller image.
Unable to resize image — could not verify image dimensions are within the 2000x2000px API limit.
```

Claude Code は通常、大きな画像を自動的にリサイズします。これらのエラーは、ネイティブ画像プロセッサーがロードに失敗したか、エラーを返したため、画像を API 制限内に収まるようにリサイズできなかったことを意味します。

**対応方法：**

* メッセージが画像の変換を求めている場合は、PNG、JPEG、GIF、または WebP に変換して、再度添付してください。Claude Code はこれらの形式の寸法を画像プロセッサーなしで検証できます。
* メッセージが寸法またはサイズ制限を報告している場合は、その制限以下に画像をリサイズまたは再圧縮してから添付してください。

<h3 id="pdf-errors">
  PDF errors
</h3>

添付した PDF を処理できませんでした。

```text theme={null}
PDF too large (max 100 pages, 32 MB). Try splitting it or extracting text first.
PDF is password protected. Try removing protection or extracting text first.
The PDF file was not valid. Try converting to a different format first.
```

**対応方法：**

* サイズの大きい PDF の場合は、ファイル全体を添付する代わりに Read ツールでページ範囲を読み取るよう Claude に依頼するか、`pdftotext` などのツールでテキストを抽出し、パスでファイルを参照してください
* 保護されたまたは無効な PDF の場合は、パスワードを削除するか、ソースアプリケーションからファイルを再度エクスポートしてから、再度試してください

<h3 id="extra-inputs-are-not-permitted">
  Extra inputs are not permitted
</h3>

Claude Code と API の間のプロキシまたは LLM ゲートウェイが `anthropic-beta` リクエストヘッダーをストリップしたため、API はそれに依存するフィールドを拒否しました。

```text theme={null}
API Error: 400 ... Extra inputs are not permitted ... context_management
API Error: 400 ... Extra inputs are not permitted ... tools.0.custom.input_examples
API Error: 400 ... Unexpected value(s) for the `anthropic-beta` header
```

Claude Code は、`context_management`、`effort`、ツール `input_examples` などのベータのみのフィールドを、それらを有効にする `anthropic-beta` ヘッダーと共に送信します。ゲートウェイがボディを転送しますがヘッダーをドロップすると、API は認識しないフィールドを見ます。

**対応方法：**

* `anthropic-beta` ヘッダーを転送するようにゲートウェイを設定してください。[機能パススルー](/ja/llm-gateway-protocol#feature-pass-through)を参照して、ゲートウェイが転送する必要があるものを確認してください。
* フォールバックとして、起動前に[`CLAUDE_CODE_DISABLE_EXPERIMENTAL_BETAS=1`](/ja/env-vars)を設定してください。これにより、ベータヘッダーが必要な機能が無効になり、リクエストはそれを転送できないゲートウェイを通じて成功します。

<h3 id="there’s-an-issue-with-the-selected-model">
  There's an issue with the selected model
</h3>

設定されたモデル名が認識されなかったか、アカウントがそれへのアクセスを持っていません。v2.1.160 以降、表示される末尾のヒントはサーフェスによって異なります。

```text theme={null}
There's an issue with the selected model (claude-...). It may not exist or you may not have access to it. Run /model to pick a different model.
```

**対応方法：**

* **インタラクティブ CLI**：`/model` を実行して、アカウントで利用可能なモデルから選択してください。
* **非対話型モード（`-p`）**：`--model` に有効なエイリアスまたは ID を渡すか、[`ANTHROPIC_MODEL`](/ja/env-vars)を設定してください。エラーテキストはこのサーフェスで `Run --model` を表示します。
* **Agent SDK**：モデルがプログラムで設定されているため、エラーテキストはヒントを省略します。TypeScript で[`Options` の `model`](/ja/agent-sdk/typescript#options)を設定するか、Python で[`ClaudeAgentOptions(model=...)`](/ja/agent-sdk/python#claudeagentoptions)を設定し、構造化された `model_not_found` エラーを処理して、独自の再試行またはモデルピッカーを表示してください。
* `sonnet` や `opus` などのエイリアスを完全なバージョン ID ではなく使用してください。エイリアスは最新リリースを追跡するため、古くなりません。[モデル設定](/ja/model-config)を参照してください。
* 間違ったモデルが戻り続ける場合は、古い ID がどこかに設定されています。[優先順位順](/ja/model-config#setting-your-model)で確認してください。`--model` フラグ、`ANTHROPIC_MODEL` 環境変数、その後 `.claude/settings.local.json`、プロジェクトの `.claude/settings.json`、および `~/.claude/settings.json` の `model` フィールド。古い値を削除すると、Claude Code はアカウントのデフォルトにフォールバックします。
* Vertex AI デプロイメントについては、[Vertex AI トラブルシューティング](/ja/google-vertex-ai#troubleshooting)を参照してください。

<h3 id="claude-opus-is-not-available-with-the-claude-pro-plan">
  Claude Opus is not available with the Claude Pro plan
</h3>

アクティブなサブスクリプションプランには、選択したモデルが含まれていません。

```text theme={null}
Claude Opus is not available with the Claude Pro plan · Select a different model in /model
```

**対応方法：**

* `/model` を実行して、プランに含まれるモデルを選択してください
* 最近プランをアップグレードしてもこれが表示される場合は、`/logout` を実行してから `/login` を実行してください。保存されたトークンはサインイン時のプランを反映しているため、ウェブでアップグレードしても既存のセッションで有効になるまで再認証する必要があります。
* [claude.com/pricing](https://claude.com/pricing)を参照して、各プランに含まれるモデルを確認してください

<h3 id="model-is-restricted-by-your-organization’s-settings">
  Model is restricted by your organization's settings
</h3>

組織の管理者が Claude Console でこのモデルを無効にしたか、管理設定の [`availableModels`](/ja/model-config#restrict-model-selection) 許可リストで除外されています。制限されたモデルが `--model`、`ANTHROPIC_MODEL`、または `model` 設定で設定された場合、Claude Code は許可されたモデルに置き換えて続行します。制限されたモデルに対して `/model <name>` を入力すると、`Run /model to choose a different model.` で拒否され、セッションは現在のモデルを保持します。

```text theme={null}
Model "claude-opus-4-8" is restricted by your organization's settings. Using claude-sonnet-4-6 instead.
```

**対応方法：**

* `/model` を実行して、組織が許可するモデルから選択してください。制限されたモデルはピッカーから非表示になります。
* 制限されたモデルが `--model`、`ANTHROPIC_MODEL`、または設定ファイルの `model` フィールドで設定された場合は、その値を削除または更新して、起動するたびに通知が繰り返されないようにしてください
* 制限されたモデルへのアクセスが必要な場合は、組織の管理者に有効にするよう依頼してください。[組織モデル制限](/ja/model-config#organization-model-restrictions)を参照してください。

<h3 id="thinking-type-enabled-is-not-supported-for-this-model">
  thinking.type.enabled is not supported for this model
</h3>

Claude Code バージョンが Sonnet 5、Opus 4.8、または Opus 4.7 の最小値より古いです。CLI は、モデルが受け入れなくなった思考設定を送信しました。

```text theme={null}
API Error: 400 ... "thinking.type.enabled" is not supported for this model. Use "thinking.type.adaptive" and "output_config.effort" to control thinking behavior.
```

**対応方法：**

* `claude update` を実行して Claude Code を再起動してください。Opus 4.7 は v2.1.111 以降が必要です。Opus 4.8 は v2.1.154 以降が必要です。Sonnet 5 は v2.1.197 以降が必要です
* アップグレードできない場合は、`/model` を実行して Opus 4.6 または Sonnet 4.6 を選択してください
* {/* min-version: agent-sdk@0.3.197 */}[Agent SDK](/ja/agent-sdk/overview)でこれに遭遇した場合は、SDK パッケージをアップグレードしてください。Opus 4.8 は TypeScript SDK v0.3.154 以降と Python SDK v0.2.88 以降が必要です。Sonnet 5 は TypeScript SDK v0.3.197 以降が必要です

<h3 id="thinking-budget-exceeds-output-limit">
  Thinking budget exceeds output limit
</h3>

設定された拡張思考予算が最大レスポンス長を超えているため、実際の回答用のスペースが残っていません。

```text theme={null}
API Error: 400 ... max_tokens must be greater than thinking.budget_tokens
```

Claude Code は Anthropic API でこれらの値を自動的に調整します。通常、Amazon Bedrock または Google Vertex AI でこのエラーが表示されるのは、[`MAX_THINKING_TOKENS`](/ja/env-vars)がプロバイダーの出力制限より高く設定されている場合、またはプランモードが思考予算を上げる場合です。

**対応方法：**

* `MAX_THINKING_TOKENS` を低くするか、[`CLAUDE_CODE_MAX_OUTPUT_TOKENS`](/ja/env-vars)を思考予算より上に上げてください
* [拡張思考](/ja/model-config#extended-thinking)を参照して、予算が出力長とどのように相互作用するかを確認してください

<h3 id="tool-use-or-thinking-block-mismatch">
  Tool use or thinking block mismatch
</h3>

会話履歴が矛盾した状態で API に到達しました。通常、ツール呼び出しが中断されたか、ターンがストリーム中に編集された後です。

```text theme={null}
API Error: 400 due to tool use concurrency issues. Run /rewind to recover the conversation.
API Error: 400 ... unexpected `tool_use_id` found in `tool_result` blocks
API Error: 400 ... thinking blocks ... cannot be modified
```

3 つのバリアントはすべて同じことを意味します。履歴内の `tool_use`、`tool_result`、および `thinking` ブロックのシーケンスが、API が期待するものと一致しなくなりました。

**対応方法：**

* {/* max-version: 2.1.155 */}Opus 4.7 または Opus 4.8 を使用している場合は、まず `claude update` を実行してください。v2.1.156 より前のバージョンは、通常のツール使用中にこのエラーをトリガーでき、`/rewind` はそれをクリアしません。
* `/rewind` を実行するか、Esc を 2 回押して、破損したターンの前のチェックポイントに戻り、そこから続行してください。[チェックポイント](/ja/checkpointing)を参照して、チェックポイントがどのように作成および復元されるかを確認してください。

<h3 id="usage-policy-refusal">
  Usage Policy refusal
</h3>

API は、会話内のコンテンツが[利用規約](https://www.anthropic.com/legal/aup)チェックをトリガーしたため、応答を拒否しました。メッセージには、拒否が正しくないと思われる場合にサポートに引用できるリクエスト ID が含まれています。

```text theme={null}
API Error: Claude Code is unable to respond to this request, which appears to violate our Usage Policy (https://www.anthropic.com/legal/aup). Please double press esc to edit your last message or start a new session for Claude Code to assist with a different task.
```

チェックは最新のプロンプトだけでなく、会話全体を評価するため、同じセッションで新しいメッセージを送信すると、通常は同じ拒否が再度トリガーされます。`--continue` または `--resume` でセッションを終了して再度開いた後も同じことが当てはまります。ディスク上のトランスクリプトにはまだトリガーコンテンツが含まれているためです。

**対応方法：**

* Esc を 2 回押すか `/rewind` を実行して、拒否をトリガーしたターンの前のチェックポイントに戻り、その後、別の方法で言い換えるか、別のアプローチを取ってください。[チェックポイント](/ja/checkpointing)を参照してください。
* どのターンが原因かを特定できない場合は、`/clear` を実行して同じプロジェクト内で新しい会話を開始してください。以前の会話はディスクに保存され、`/resume` で利用可能なままです。
* [非対話型モード](/ja/headless)（`-p`）では、巻き戻しが利用できないため、言い換えたプロンプトで再試行するか、`--continue` なしで新しいセッションを開始してください。ポリシーチェックはモデルによって異なるため、`--model` で別のモデルに切り替えると、場合によっては拒否が解決される可能性があります。

<h2 id="responses-seem-lower-quality-than-usual">
  Responses seem lower quality than usual
</h2>

Claude の回答がエラーなしで予想より能力が低いように見える場合、原因は通常、モデル自体ではなく会話状態です。Claude Code はモデルバージョンを静かに変更しません。3 つの特定のケースでフォールバックモデルに切り替えることができます。

* 設定された [`--fallback-model`](/ja/cli-reference#cli-flags) は可用性エラーの後にそのターンのみ引き継ぎ、トランスクリプトに通知が表示されます
* Bedrock または Vertex AI スタートアップチェックがデフォルトモデルが利用不可であることを検出します
* [Automatic model fallback](/ja/model-config#automatic-model-fallback) on Fable 5 はセッションをデフォルト Opus モデルに移動し、トランスクリプトに通知を表示します

以下のモデル選択チェックは 2 番目と 3 番目のケースをキャッチします。最初のケースはトランスクリプト通知として表示され、`/model` 変更ではなく表示されます。[Model configuration](/ja/model-config) はそれぞれのフォールバックが適用される場合を説明しています。

最初にこれらを確認してください。

* **モデル選択**：`/model` を実行して、予想されるモデルにいることを確認してください。以前の `/model` 選択または `ANTHROPIC_MODEL` 環境変数により、意図したより小さいモデルにいる可能性があります。
* **努力レベル**：`/effort` を実行して、現在の推論レベルを確認し、難しいデバッグまたは設計作業のためにそれを上げてください。デフォルトはモデルによって異なるため、最大値より下にあると仮定する前に確認してください。[Adjust effort level](/ja/model-config#adjust-effort-level) を参照して、モデルごとのデフォルトと `ultrathink` ショートカットを確認してください。
* **コンテキスト圧力**：`/context` を実行して、ウィンドウがどの程度満杯かを確認してください。容量に近い場合は、自然な区切り点で `/compact` を実行するか、`/clear` を実行して新しく開始してください。[Explore the context window](/ja/context-window) を参照して、自動コンパクトが以前のターンにどのように影響するかを確認してください。
* **古い指示**：大きなまたは古い `CLAUDE.md` ファイルと MCP ツール定義はコンテキストを消費し、レスポンスを操作できます。`/doctor` は大きなメモリファイルとサブエージェント定義にフラグを立てます。`/context` は MCP ツールトークン使用量を表示します。

レスポンスが間違っている場合、修正で返信するより、巻き戻しの方が通常うまくいきます。Esc を 2 回押すか、`/rewind` を実行して悪いターンの前に戻り、より詳細なプロンプトで言い換えてください。スレッド内で修正すると、間違った試みがコンテキストに残り、後の回答をそれに固定できます。[Checkpointing](/ja/checkpointing) を参照してください。

上記を確認した後も品質が異常に見える場合は、`/feedback` を実行して、期待したものと得たものを説明してください。このように送信されたフィードバックには会話トランスクリプトが含まれており、Anthropic が実際の回帰を診断する最速の方法です。環境で `/feedback` が利用できない場合は、[Report an error](#report-an-error) を参照してください。

<h2 id="report-an-error">
  エラーを報告する
</h2>

このページでは Claude API からのエラーについて説明しています。Claude Code の他のコンポーネントからのエラーについては、関連するガイドを参照してください。

* MCP サーバーが接続または認証に失敗しました：[MCP](/ja/mcp)
* フックスクリプトが失敗したか、ツールをブロックしました：[フックをデバッグする](/ja/hooks#debug-hooks)
* インストール中に権限が拒否されたか、ファイルシステムエラーが発生しました：[インストールとログインのトラブルシューティング](/ja/troubleshoot-install)

エラーがここに記載されていない場合、または提案された修正が役に立たない場合：

* Claude Code 内で `/feedback` を実行して、トランスクリプトと説明を Anthropic に送信してください。コマンドは、事前入力された GitHub イシューを開くことも提供します。Bedrock、Vertex AI、Foundry、およびその他のサードパーティプロバイダーでは、`/feedback` はローカルアーカイブを保存し、Anthropic アカウント担当者に送信できます。
* `/doctor` を実行してローカル設定の問題を確認してください
* [status.claude.com](https://status.claude.com) でアクティブなインシデントを確認してください
* GitHub の[既存のイシュー](https://github.com/anthropics/claude-code/issues)を検索してください
