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
| `Server error mid-response. The response above may be incomplete.`                            | [サーバーエラー](#the-response-above-may-be-incomplete)                                              |
| `Connection closed mid-response` / `Response stalled mid-stream`                              | [サーバーエラー](#the-response-above-may-be-incomplete)                                              |
| `<model> is temporarily unavailable, so auto mode cannot determine the safety of...`          | [サーバーエラー](#auto-mode-cannot-determine-the-safety-of-an-action)                                |
| `Auto mode could not evaluate this action and is blocking it for safety`                      | [サーバーエラー](#auto-mode-cannot-determine-the-safety-of-an-action)                                |
| `Auto mode classifier transcript exceeded context window`                                     | [サーバーエラー](#auto-mode-cannot-determine-the-safety-of-an-action)                                |
| `Agent terminated early due to an API error`                                                  | [サーバーエラー](#agent-terminated-early-due-to-an-api-error)                                        |
| `You've hit your session limit` / `You've hit your weekly limit`                              | [使用制限](#youve-hit-your-session-limit)                                                         |
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
| `Routines are disabled by your organization's policy`                                         | [認証](#routines-are-disabled-by-your-organizations-policy)                                     |
| `Remote Control is only available when using Claude via api.anthropic.com`                    | [認証](#remote-control-requires-the-anthropic-api)                                              |
| `OAuth token revoked` / `OAuth token has expired`                                             | [認証](#oauth-token-revoked-or-expired)                                                         |
| `does not meet scope requirement user:profile`                                                | [認証](#oauth-scope-requirement)                                                                |
| `AWS credentials expired or invalid`                                                          | [認証](#aws-credentials-expired-or-invalid)                                                     |
| `AWS authentication failed`                                                                   | [認証](#aws-authentication-failed)                                                              |
| `Unable to connect to API`                                                                    | [ネットワーク](#unable-to-connect-to-api)                                                           |
| `Waiting for API response · will retry in`                                                    | [自動リトライ](#automatic-retries)、または継続する場合は[ネットワーク](#unable-to-connect-to-api)                    |
| `SSL certificate verification failed`                                                         | [ネットワーク](#ssl-certificate-errors)                                                             |
| `SSL certificate error (...)` during login or startup                                         | [ネットワーク](#ssl-certificate-errors)                                                             |
| `403` with `x-deny-reason: host_not_allowed` in a cloud or routine session                    | [ネットワーク](#host-not-allowed-in-a-cloud-session)                                                |
| `Couldn't reconnect to your Remote Control session`                                           | [ネットワーク](#couldnt-reconnect-to-your-remote-control-session)                                   |
| `Prompt is too long`                                                                          | [リクエストエラー](#prompt-is-too-long)                                                               |
| `Error during compaction: Conversation too long`                                              | [リクエストエラー](#error-during-compaction-conversation-too-long)                                    |
| `Request too large`                                                                           | [リクエストエラー](#request-too-large)                                                                |
| `Image was too large`                                                                         | [リクエストエラー](#image-was-too-large)                                                              |
| `Unable to resize image`                                                                      | [リクエストエラー](#unable-to-resize-image)                                                           |
| `PDF too large` / `PDF is password protected`                                                 | [リクエストエラー](#pdf-errors)                                                                       |
| `Extra inputs are not permitted`                                                              | [リクエストエラー](#extra-inputs-are-not-permitted)                                                   |
| `There's an issue with the selected model`                                                    | [リクエストエラー](#theres-an-issue-with-the-selected-model)                                          |
| `Model ... is not a recognized model id`                                                      | [リクエストエラー](#model-is-not-a-recognized-model-id)                                               |
| `Claude Opus is not available with the Claude Pro plan`                                       | [リクエストエラー](#claude-opus-is-not-available-with-the-claude-pro-plan)                            |
| `Model ... is restricted by your organization's settings`                                     | [リクエストエラー](#model-is-restricted-by-your-organizations-settings)                               |
| `thinking.type.enabled is not supported for this model`                                       | [リクエストエラー](#thinking-type-enabled-is-not-supported-for-this-model)                            |
| `max_tokens must be greater than thinking.budget_tokens`                                      | [リクエストエラー](#thinking-budget-exceeds-output-limit)                                             |
| `API Error: 400 due to tool use concurrency issues`                                           | [リクエストエラー](#tool-use-or-thinking-block-mismatch)                                              |
| `Claude Code is unable to respond to this request, which appears to violate our Usage Policy` | [リクエストエラー](#usage-policy-refusal)                                                             |
| `<model> has safety measures that flagged this message for a cybersecurity topic`             | [リクエストエラー](#safety-measures-flagged-a-cybersecurity-topic)                                    |
| `Installation was killed before it could finish (exit code 137)`                              | [インストールエラー](#installation-was-killed-before-it-could-finish)                                  |
| `The connection dropped while downloading the update`                                         | [インストールエラー](#the-connection-dropped-while-downloading-the-update)                             |
| `Download timed out: exceeded the total deadline`                                             | [インストールエラー](#the-connection-dropped-while-downloading-the-update)                             |
| `--bg and --print conflict`                                                                   | [コマンドラインエラー](#command-line-errors)                                                            |
| `Error: --json-schema is not a valid JSON Schema`                                             | [コマンドラインエラー](#command-line-errors)                                                            |
| `Could not import <server>: <reason>`                                                         | [コマンドラインエラー](#could-not-import-a-server-from-claude-desktop)                                  |
| `Marketplace "<name>" is registered from an untrusted source`                                 | [プラグインエラー](#marketplace-is-registered-from-an-untrusted-source)                               |
| `Ignoring N permissions.allow entries from ... this workspace has not been trusted`           | [設定警告](#workspace-has-not-been-trusted)                                                       |
| レスポンスの品質が通常より低いように見える                                                                         | [レスポンス品質](#responses-seem-lower-quality-than-usual)                                           |

<h2 id="automatic-retries">
  自動リトライ
</h2>

Claude Code は、エラーを表示する前に一時的な障害をリトライします。サーバーエラー、オーバーロードレスポンス、リクエストタイムアウト、一時的な 429 スロットル、および接続の切断はすべて、指数バックオフで最大 10 回リトライされます。{/* min-version: 2.1.198 */}v2.1.198 以降では、これは、表示可能な出力がストリームされる前に応答の途中で切断される接続をカバーしています。Claude Code は同じバックオフでリクエストを再発行し、接続エラーで停止する代わりにターンが続行されます。{/* min-version: 2.1.199 */}v2.1.199 以降では、プランのクォータヘッダーを持たない一時的な 429 スロットルも、claude.ai サブスクリプションでサインインしている場合にリトライされます。それより前のバージョンでは、API キーおよびエンタープライズサインインの場合のみリトライされました。

2 つの障害クラスはリトライされません。リトライが成功できないためです。

* {/* min-version: 2.1.199 */}v2.1.199 以降では、TLS 証明書検証の失敗（TLS 検査プロキシ、不足している `NODE_EXTRA_CA_CERTS` バンドル、または期限切れの証明書など）は最初の試行で失敗するため、完全なリトライ予算の後ではなく、修正がすぐに表示されます。[SSL 証明書エラー](#ssl-certificate-errors)を参照してください。ハンドシェイクタイムアウトなどの一時的な TLS 条件はまだリトライされます。
* {/* min-version: 2.1.199 */}v2.1.199 以降では、Claude が既に表示可能な出力をストリームした後に到着するサーバーエラーは、部分的なレスポンスを保持し、リトライする代わりに[不完全なレスポンス通知](#the-response-above-may-be-incomplete)を追加します。同じツール呼び出しを 2 回実行する可能性があるためです。それより前のバージョンでは、部分的な出力を破棄し、ターン全体をエラーとして報告しました。

リトライ中、スピナーはエラーラベルの後に `Retrying in Ns · attempt x/y` カウントダウンを表示します。ラベルは、すぐに対応できる障害の最初の試行からの具体的な理由を示します。ネットワークがダウンしている、TLS ハンドシェイクが失敗した、またはレート制限に達しました。他のエラーの場合は、最初は `API error` と表示されます。{/* min-version: 2.1.198 */}v2.1.198 以降では、3 番目の試行からの具体的な理由に切り替わるか、`CLAUDE_CODE_MAX_RETRIES` が 3 未満の試行を許可する場合は最終試行時に切り替わります。それより前のバージョンでは、最終試行時のみ切り替わります。

{/* min-version: 2.1.198 */}v2.1.198 以降では、通常のスピナーチップはリトライ中に抑制されます。エラーの理由が明らかになると、障害が 529 オーバーロードの場合、カウントダウンの下の行はサービスステータスを確認する場所も示します。Anthropic API では `status.claude.com`、または他の設定ではメッセージに示されているプロバイダーまたはゲートウェイホスト。

{/* min-version: 2.1.185 */}リクエストがまだ保留中の状態で、レスポンスストリームで 20 秒間データが到着しない場合、スピナーは `Waiting for API response · will retry in … · check your network` を表示します。これはリトライが開始される前です。リクエストはまだ失敗していません。カウントダウンは Claude Code が停止した接続を中止してリトライする時点まで実行されるため、データが再開されるか、リトライが成功するとバナーは自動的にクリアされます。v2.1.185 以降、閾値は 20 秒です。それより前のバージョンでは、異なる表現でバナーが 10 秒後に表示されます。すべての試行で再度表示される場合は、[ネットワークの問題](#unable-to-connect-to-api)として扱ってください。

このページのエラーの 1 つが表示されている場合、これらのリトライはすでに使い果たされています。ただし、証明書検証の失敗など、リトライされないクラスに属する場合は除きます。これらの環境変数で動作をチューニングできます。

| 変数                                           | デフォルト  | 効果                                                                                                                                                                                                                                                                                  |
| :------------------------------------------- | :----- | :---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [`CLAUDE_CODE_MAX_RETRIES`](/ja/env-vars)    | 10     | リトライ試行回数。{/* min-version: 2.1.186 */}v2.1.186 以降、15 に制限されています。{/* min-version: 2.1.199 */}v2.1.199 以降では `CLAUDE_CODE_RETRY_WATCHDOG` がデフォルトを上げ、キャップを削除します。スクリプトで障害をより速く表示するには低くします。                                                                                                 |
| [`CLAUDE_CODE_RETRY_WATCHDOG`](/ja/env-vars) | 未設定    | CI ジョブなどの無人セッションで `1` に設定して、`CLAUDE_CODE_MAX_RETRIES` 試行後に失敗する代わりに、`429` および `529` キャパシティエラーを無限にリトライします。{/* min-version: 2.1.199 */}v2.1.199 以降では、サーバーエラー、タイムアウト、接続の切断などの他の一時的なエラーのデフォルトリトライ数も上げ、バックオフの約 3 時間である 300 に上げ、変数を明示的に設定した場合は `CLAUDE_CODE_MAX_RETRIES` の 15 のキャップを削除します。 |
| [`API_TIMEOUT_MS`](/ja/env-vars)             | 600000 | リクエストごとのタイムアウト（ミリ秒単位）。遅いネットワークまたはプロキシの場合は高くします。                                                                                                                                                                                                                                     |

<h2 id="server-errors">
  サーバーエラー
</h2>

これらのエラーはアカウントまたはリクエストではなく、推論プロバイダーから発生します。Anthropic API の場合は Anthropic インフラストラクチャを意味します。Amazon Bedrock、Google Cloud の Agent Platform、Microsoft Foundry、またはカスタムゲートウェイの場合は、そのプロバイダーのインフラストラクチャを意味します。

<h3 id="api-error-500-internal-server-error">
  API Error: 500 Internal server error
</h3>

Claude Code は 5xx レスポンスのステータスコードと API のエラーメッセージを表示します。以下の例は Anthropic API での 500 レスポンスを示しています。

```text theme={null}
API Error: 500 Internal server error. This is a server-side issue, usually temporary — try again in a moment. If it persists, check https://status.claude.com.
```

末尾の文はサービスヘルスを確認する場所を示し、プロバイダーによって異なります。Amazon Bedrock、Google Cloud の Agent Platform、Microsoft Foundry の設定はそのプロバイダーのサービスステータスを示します。カスタム `ANTHROPIC_BASE_URL` はゲートウェイホストを示します。

これは API 内の予期しない障害を示しています。プロンプト、設定、またはアカウントが原因ではありません。

**対応方法：**

* [status.claude.com](https://status.claude.com) またはメッセージに示されているプロバイダーのステータスページで、アクティブなインシデントを確認してください
* 1 分待ってからメッセージを再度送信してください。元のメッセージはまだ会話に残っているため、長いプロンプトの場合は全体を貼り付ける代わりに `try again` と入力できます
* エラーが投稿されたインシデントなしで続く場合は、`/feedback` を実行して Anthropic がリクエストの詳細で調査できるようにしてください。環境で `/feedback` が利用できない場合は、[エラーを報告する](#report-an-error)を参照してください。

<h3 id="api-error-repeated-529-overloaded-errors">
  API Error: Repeated 529 Overloaded errors
</h3>

API はすべてのユーザー全体で一時的に容量に達しています。Claude Code はこのメッセージを表示する前に既に数回再試行しています。

```text theme={null}
API Error: Repeated 529 Overloaded errors. The API is at capacity — this is usually temporary. Try again in a moment. If it persists, check https://status.claude.com.
```

末尾の文は 500 エラーと同じ方法でプロバイダーによって異なります。

529 はユーザーの使用制限ではなく、クォータに対してカウントされません。

**対応方法：**

* [status.claude.com](https://status.claude.com) またはメッセージに示されているプロバイダーのステータスページで、容量に関する通知を確認してください
* 数分後に再度試してください
* `/model` を実行して別のモデルに切り替えて作業を続けてください。容量はモデルごとに追跡されるためです。Claude Code は 1 つのモデルが特に高い負荷を受けている場合、例えば `Opus is experiencing high load, please use /model to switch to Sonnet` のようにプロンプトを表示します。

<h3 id="request-timed-out">
  Request timed out
</h3>

API は接続期限前に応答しませんでした。

```text theme={null}
Request timed out
```

これは高負荷期間中、またはモデルが非常に大きなレスポンスを生成している場合に発生する可能性があります。デフォルトのリクエストタイムアウトは 10 分です。

**対応方法：**

* リクエストを再試行してください
* 長時間実行されるタスクの場合は、作業をより小さなプロンプトに分割してください
* 遅いネットワークまたはプロキシが原因の場合は、[自動再試行](#automatic-retries)で説明されているように `API_TIMEOUT_MS` を上げてください
* タイムアウトが頻繁で、ネットワークが正常な場合は、以下の[ネットワークと接続エラー](#network-and-connection-errors)を参照してください

<h3 id="the-response-above-may-be-incomplete">
  The response above may be incomplete
</h3>

ストリーミングレスポンスが Claude が既に表示可能な出力を生成した後に失敗しました。リクエストを再送信すると同じツール呼び出しが 2 回実行される可能性があるため、Claude Code は既にストリーミングされたものを保持し、ターンを破棄する代わりにこの通知を追加します。表示されるバリアントはどれが原因かを示します。

```text theme={null}
API Error: Server error mid-response. The response above may be incomplete.
API Error: Connection closed mid-response. The response above may be incomplete.
API Error: Response stalled mid-stream. The response above may be incomplete.
```

* {/* min-version: 2.1.199 */}`Server error mid-response`：ストリーム中のオーバーロードまたは 5xx サーバーエラー。このバリアントには Claude Code v2.1.199 以降が必要です。それ以前は、その場合は部分的な出力を破棄し、ターン全体をエラーとして報告していました。
* `Connection closed mid-response`：接続が切断されました。
* `Response stalled mid-stream`：ストリームがデータの送信を停止しました。

**対応方法：**

* ストリーミングされたレスポンスを読んでください。何も失われていませんが、最後の文またはツール呼び出しが欠落している可能性があります。
* `continue` で返信して、Claude が停止した場所から再開するようにしてください
* 表示可能な出力の前に同じエラーが表示される場合、Claude Code はそれを最終化する代わりにリクエストを再試行します。[自動再試行](#automatic-retries)を参照してください。

<h3 id="auto-mode-cannot-determine-the-safety-of-an-action">
  Auto mode cannot determine the safety of an action
</h3>

[auto mode](/ja/permission-modes#eliminate-prompts-with-auto-mode)が使用するモデルがアクションを分類できず、決定を生成できなかったため、auto mode はアクションを自動的に承認しませんでした。表示されるメッセージは分類器が失敗した理由によって異なります。

読み取り、検索、および作業ディレクトリ内の編集は分類器をスキップするため、これらすべてのケースで動作し続けます。

分類器モデルがオーバーロードされている場合：

```text theme={null}
<model> is temporarily unavailable, so auto mode cannot determine the safety of <tool> right now. Wait briefly and then try this action again.
```

**対応方法：**

* 数秒後に再試行してください。Claude は同じメッセージを表示し、通常は自動的に再試行します
* 再試行が失敗し続ける場合は、読み取り専用タスクを続行し、後でブロックされたアクションに戻ってください
* これは一時的で、[auto mode 適格性](/ja/permission-modes#eliminate-prompts-with-auto-mode)とは無関係です。設定を変更する必要はありません

分類器が解析不可能なレスポンスを返した場合：

```text theme={null}
Auto mode could not evaluate this action and is blocking it for safety — run with --debug for details
```

**対応方法：**

* アクションを再試行してください。これは通常、次の試行で成功します
* `claude --debug` を実行してアクションを繰り返し、デバッグログで基になる分類器レスポンスを確認してください

別の API セーフティチェックが以前の会話コンテンツのため分類器リクエストをブロックした場合：

```text theme={null}
Auto mode could not evaluate this action and is blocking it for safety — a safety check separate from auto mode blocked this request because of earlier conversation content — it isn't about the action itself — run with --debug for details
```

**対応方法：**

* これはアクションに関する決定ではありません。会話に既にあるコンテンツが、auto mode が会話を分類器に送信したときに API のセーフティフィルターをトリガーしました
* 再試行は役に立ちません。同じ会話コンテンツがフィルターを再度トリガーします
* 別の[権限モード](/ja/permission-modes)に切り替えて、プロンプトが表示されたときにアクションを承認するか、トリガーするコンテンツなしで新しい会話を開始してください

会話が分類器のコンテキストウィンドウより大きくなった場合：

```text theme={null}
Auto mode classifier transcript exceeded context window — falling back to manual approval (try /compact to reduce conversation size)
```

インタラクティブセッションでは、auto mode はそのアクションに対して通常の権限プロンプトにフォールバックするため、手動で承認または拒否できます。[非インタラクティブモード](/ja/headless)では、トランスクリプトのみが増加し、再試行が成功できないため、実行は中止されます。

**対応方法：**

* 表示されるプロンプトでアクションを承認または拒否してください
* `/compact` を実行して会話サイズを削減し、後続のアクションが分類器ウィンドウ内に収まるようにしてください

<h3 id="agent-terminated-early-due-to-an-api-error">
  Agent terminated early due to an API error
</h3>

{/* min-version: 2.1.199 */}[subagent](/ja/sub-agents)の API リクエストが終了的に失敗しました。例えば、使用制限に達したか、サーバーエラーの再試行が終了したため、subagent はタスクを完了する前に停止しました。このメッセージには Claude Code v2.1.199 以降が必要です。それ以前は、API エラーテキストが subagent の結果であるかのように Claude に返されていました。

```text theme={null}
Agent terminated early due to an API error: <error detail>
```

**対応方法：**

* コロンの後のエラー詳細をこのページの独自のセクション（[使用制限](#usage-limits)または[サーバーエラー](#server-errors)など）と照合し、そのセクションの手順に従ってください
* 基になるエラーがクリアされたら、Claude にタスクを再試行するか、[subagent を再開](/ja/sub-agents#resume-subagents)するよう依頼してください

レート制限、オーバーロード、またはサーバーエラーが既にテキスト出力を生成したフォアグラウンド subagent を中断する場合、Claude はその部分的な出力を不完全としてマークされたものを受け取り、このエラーは受け取りません。{/* min-version: 2.1.200 */}唯一の出力がツール呼び出しだった subagent もこのエラーを取得します。v2.1.199 ではその形状は空の部分的な結果を返していました。[subagent の API エラー](/ja/sub-agents#api-errors-in-subagents)を参照してください。

<h2 id="usage-limits">
  使用制限
</h2>

これらのエラーは、アカウントまたはプランに関連するクォータに達したことを意味します。これらは、すべてのユーザーに影響する[サーバーエラー](#server-errors)とは異なります。

<h3 id="youve-hit-your-session-limit">
  セッション制限に達しました
</h3>

サブスクリプションプランには、ローリング使用許容量が含まれています。これが尽きると、以下のいずれかのメッセージが表示されます。

```text theme={null}
You've hit your session limit · resets 3:45pm
You've hit your weekly limit · resets Mon 12:00am
You've hit your Opus limit · resets 3:45pm
```

Claude Code は、メッセージに表示されたリセット時刻までさらなるリクエストをブロックします。

**対応方法：**

* エラーに表示されたリセット時刻まで待機してください
* `/usage` を実行して、プランの制限と、それらがいつリセットされるかを確認してください
* `/usage-credits` を実行して、Pro および Max で追加使用量を購入するか、Team および Enterprise で管理者にリクエストしてください。この請求方法については、[有料プランの使用クレジット](https://support.claude.com/en/articles/12429409-extra-usage-for-paid-claude-plans)を参照してください。
* より高い基本制限のためにプランをアップグレードするには、[claude.com/pricing](https://claude.com/pricing) を参照してください。

制限に達する前に残りの許容量を監視するには、`rate_limits` フィールドを[カスタムステータスライン](/ja/statusline#rate-limit-usage)に追加するか、Desktop アプリでモデルピッカーの横にある[使用量リング](/ja/desktop#check-usage)をクリックしてください。

<h3 id="usage-credits-required-for-1m-context">
  1M コンテキストに必要な使用クレジット
</h3>

選択されたモデルは 1M トークンの拡張コンテキストウィンドウを使用しており、プランではこれを使用クレジットを通じてのみ含めています。

```text theme={null}
API Error: Usage credits required for 1M context · run /usage-credits to turn them on, or /model to switch to standard context
```

これはクォータ枯渇ではなく、エンタイトルメント チェックです。セッションおよび週間許容量に容量が残っている場合でも発火します。[拡張コンテキスト](/ja/model-config#extended-context)で、どのプランが 1M コンテキストを直接含み、どのプランが使用クレジットを必要とするかを確認してください。

{/* min-version: 2.1.172 */}このエラーがコンテキストが 200K トークンを超えて成長したため会話の途中に表示される場合、Claude Code は自動的に会話を標準コンテキスト制限以下にコンパクト化し、その後セッションをその制限に保つため、アクションは不要です。v2.1.172 より前のバージョンでは、エラーは `/compact` を含むその後のすべてのリクエストで繰り返されました。これらのバージョンで復旧するには `/clear` を実行してください。以下の手順は、明示的に `[1m]` モデルを選択した場合に適用されます。

**対応方法：**

* `/model` を実行し、`[1m]` サフィックスなしのバリアントを選択して、標準コンテキストウィンドウにフォールバックしてください
* `/usage-credits` を実行して、Pro および Max で 1M バリアントのメータリング課金をオンにするか、Team および Enterprise で管理者にリクエストしてください
* `/model` の後もエラーが続く場合、1M モデル ID が他の場所に設定されている可能性があります。優先順位順に確認する設定場所については、[選択されたモデルに問題があります](#theres-an-issue-with-the-selected-model)を参照してください。
* モデルピッカーから 1M バリアントを完全に削除するには、[`CLAUDE_CODE_DISABLE_1M_CONTEXT=1`](/ja/env-vars) を設定してください

<h3 id="server-is-temporarily-limiting-requests">
  サーバーが一時的にリクエストを制限しています
</h3>

API は、プランクォータとは無関係の短期的なスロットルを適用しました。

```text theme={null}
API Error: Server is temporarily limiting requests (not your usage limit)
```

Claude Code は、実際の制限応答が持つ統一クォータヘッダーの不在によって、これらをプラン制限と区別します。{/* min-version: 2.1.199 */}v2.1.199 以降、これは認証方法に関係なく、表示される前に[自動的に再試行](#automatic-retries)されます（バックオフ付き）。以前のバージョンでは、claude.ai サブスクリプションでサインインしたセッションは最初の発生時にターンに失敗しました。API キーと Enterprise サインインのみがこれを再試行しました。

**対応方法：**

* しばらく待ってから再度試してください
* 続く場合は [status.claude.com](https://status.claude.com) でサービスの状態を確認してください

<h3 id="request-rejected-429">
  リクエストが拒否されました（429）
</h3>

API キー、Amazon Bedrock プロジェクト、または Google Cloud プロジェクトに設定されたレート制限に達しました。

```text theme={null}
API Error: Request rejected (429) · this may be a temporary capacity issue. If it persists, check https://status.claude.com.
```

末尾の文は、サービスの状態を確認する場所を示し、プロバイダーによって異なります。Amazon Bedrock、Google Cloud の Agent Platform、および Microsoft Foundry 設定は、Anthropic ステータスページの代わりにそのプロバイダーのサービスステータスを示します。カスタム `ANTHROPIC_BASE_URL` はゲートウェイホストを示します。

**対応方法：**

* `/status` を実行し、アクティブな認証情報が予想されるものであることを確認してください。環境内の迷走した `ANTHROPIC_API_KEY` は、サブスクリプションの代わりに低層キーを通じてリクエストをルーティングできます。
* プロバイダーコンソールでアクティブな制限を確認し、必要に応じてより高い層をリクエストしてください
* Anthropic API キーについては、[レート制限リファレンス](https://platform.claude.com/docs/en/api/rate-limits)を参照して、層がどのように機能し、ワークスペースごとのキャップを設定する方法を確認してください
* 同時実行性を削減してください：[`CLAUDE_CODE_MAX_TOOL_USE_CONCURRENCY`](/ja/env-vars) を低くするか、多くの並列サブエージェントの実行を避けるか、高ボリュームのスクリプト実行用に `/model` で小さいモデルに切り替えてください

<h3 id="credit-balance-is-too-low">
  クレジット残高が不足しています
</h3>

Console 組織のプリペイドクレジットが尽きました。

```text theme={null}
Credit balance is too low
```

**対応方法：**

* [platform.claude.com/settings/billing](https://platform.claude.com/settings/billing) でクレジットを追加し、残高がゼロに達する前に自動リロードを有効にすることを検討してください
* Pro、Max、Team、または Enterprise プランがある場合は、`/login` でサブスクリプション認証に切り替えてください
* Console でワークスペースごとの支出キャップを設定して、単一のプロジェクトが組織の残高を枯渇させるのを防いでください。[コストを効果的に管理する](/ja/costs)を参照してください。

<h2 id="authentication-errors">
  認証エラー
</h2>

これらのエラーは Claude Code が API に対してあなたの身元を証明できないことを意味します。任意の時点で `/status` を実行して、現在アクティブな認証情報を確認できます。

<h3 id="not-logged-in">
  ログインしていない
</h3>

このセッションで有効な認証情報が利用できません。

```text theme={null}
Not logged in · Please run /login
```

**対応方法：**

* `/login` を実行して、Claude サブスクリプションまたは Console アカウントで認証します
* 環境変数で認証されることを想定していた場合は、`ANTHROPIC_API_KEY` が `claude` を起動したシェルで設定およびエクスポートされていることを確認します
* CI または自動化で対話的ログインが不可能な場合は、起動時にキーを取得する [`apiKeyHelper`](/ja/settings#available-settings) スクリプトを設定します
* [認証の優先順位](/ja/authentication#authentication-precedence) を参照して、複数の認証情報が存在する場合に Claude Code がどの認証情報を使用するかを理解します

ログインを繰り返し求められる場合は、[ログインしていないまたはトークンの有効期限が切れている](/ja/troubleshoot-install#not-logged-in-or-token-expired) を参照して、システムクロックと macOS キーチェーンの修正を確認してください。

<h3 id="could-not-resolve-authentication-method">
  認証方法を解決できない
</h3>

セッションが認証情報なしで API クライアントに到達しました。これは [バックグラウンドセッション](/ja/agent-view)、クラウドセッション、および最初のリクエストの前に対話的ログインチェックが実行されない Agent SDK コンテキストに表示されます。

```text theme={null}
Could not resolve authentication method. Expected one of apiKey, authToken, credentials, config, or profile to be set. Or for one of the "X-Api-Key" or "Authorization" headers to be explicitly omitted
```

{/* min-version: 2.1.174 */}v2.1.174 より前では、アイドル状態の事前初期化ワーカーに割り当てられたバックグラウンドまたはクラウドセッションは、有効な認証情報が設定されていても、このように失敗する可能性がありました。アップグレードして復旧します。現在のバージョンでは、このエラーはワーカープロセスで認証情報が利用できなかったことを意味します。

**対応方法：**

* バックグラウンドまたはクラウドセッションでこれが表示され、認証情報が既に設定されている場合は、v2.1.174 以降にアップグレードします
* `ANTHROPIC_API_KEY`、`CLAUDE_CODE_OAUTH_TOKEN`、またはクラウドプロバイダーの認証情報が、対話的シェルだけでなく、ワーカーを起動する環境で設定されていることを確認します
* Agent SDK については、[認証セットアップ](/ja/agent-sdk/overview#get-started) を参照してください
* 同じ環境の対話的セッションで `/status` を実行して、どの認証情報ソースが解決されるかを確認します

<h3 id="invalid-api-key">
  無効な API キー
</h3>

`ANTHROPIC_API_KEY` 環境変数または `apiKeyHelper` スクリプトが返したキーが API に拒否されました。

```text theme={null}
Invalid API key · Fix external API key
```

**対応方法：**

* タイプミスがないか確認し、キーが [Console](https://platform.claude.com/settings/keys) で失効していないことを確認します
* 同じシェルで `env | grep ANTHROPIC` を実行します。direnv、dotenv シェルプラグイン、IDE ターミナルなどのツールは、プロジェクト内の `.env` ファイルから古いキーを明示的に設定せずに読み込むことができます
* `ANTHROPIC_API_KEY` をアンセットして `/login` を実行し、代わりにサブスクリプション認証を使用します
* キーが [`apiKeyHelper`](/ja/settings#available-settings) スクリプトから来ている場合は、スクリプトを直接実行して、stdout に有効なキーが出力されることを確認します
* `/status` を実行して、Claude Code が実際に使用している認証情報ソースを確認します

<h3 id="this-organization-has-been-disabled">
  この組織は無効になっています
</h3>

無効な Console 組織からの古い `ANTHROPIC_API_KEY` がサブスクリプションログインをオーバーライドしています。

```text theme={null}
Your ANTHROPIC_API_KEY belongs to a disabled organization · Unset the environment variable to use your other credentials
API Error: 400 ... This organization has been disabled.
```

環境変数は `/login` より優先されるため、シェルプロファイルでエクスポートされたキーまたは `.env` ファイルから読み込まれたキーは、動作する Pro または Max サブスクリプションがある場合でも使用されます。非対話モード（`-p`）では、キーが存在する場合は常に使用されます。

**対応方法：**

* 現在のシェルで `ANTHROPIC_API_KEY` をアンセットし、シェルプロファイルから削除してから、`claude` を再起動します
* その後 `/status` を実行して、アクティブな認証情報がサブスクリプションであることを確認します
* 環境変数が設定されておらず、エラーが続く場合は、無効な組織は `/login` に関連付けられています。サポートに連絡するか、別のアカウントでサインインします。

<h3 id="your-organization-has-disabled-api-key-authentication">
  組織が API キー認証を無効にしました
</h3>

このメッセージには Claude Code v2.1.169 以降が必要です。Console 組織の管理者が API キー認証をオフにしたため、API が Claude Code が送信しているキーを拒否します。`·` の後の復旧ヒントは、キーがどこから来たかによって異なります：

```text theme={null}
Your organization has disabled API key authentication · Run /login to sign in with your claude.ai account
Your organization has disabled API key authentication · Unset ANTHROPIC_API_KEY to use your claude.ai account instead
Your organization has disabled API key authentication · Unset ANTHROPIC_API_KEY and run /login to sign in with your claude.ai account
Your organization has disabled API key authentication · Unset the apiKeyHelper setting and run /login to sign in with your claude.ai account
```

環境変数と `apiKeyHelper` は `/login` より優先されるため、どちらかがまだキーを供給している間は `/login` だけを実行しても役に立ちません。[認証の優先順位](/ja/authentication#authentication-precedence) を参照してください。

**対応方法：**

* メッセージが `ANTHROPIC_API_KEY` を指定している場合は、現在のシェルでアンセットし、シェルプロファイルまたは `.env` ファイルから削除してから、`claude` を再起動します
* メッセージが `apiKeyHelper` を指定している場合は、`settings.json` から [`apiKeyHelper`](/ja/settings#available-settings) 設定を削除します
* `/login` を実行して claude.ai アカウントでサインインします
* その後 `/status` を実行して、アクティブな認証情報が API キーではなくサブスクリプションであることを確認します
* 自動化に API キー認証が必要な場合は、組織の管理者に Console で再度有効にするよう依頼します

<h3 id="your-organization-has-disabled-claude-subscription-access">
  組織が Claude サブスクリプションアクセスを無効にしました
</h3>

Claude 組織は、サブスクリプションログインで Claude Code にサインインすることを許可していません。同じアカウントで `/login` を再度実行すると、同じエラーが返されます。

```text theme={null}
Your organization has disabled Claude subscription access for Claude Code · Use an Anthropic API key instead, or ask your admin to enable access
```

これはサーバー側の組織設定であるため、ローカル設定、環境変数、または CLI フラグからオーバーライドすることはできません。

Agent SDK と `-p` 非対話モードは、これを `oauth_org_not_allowed` エラーコードとして表示します。

**対応方法：**

* 管理者に組織の Claude Code アクセスを有効にするよう依頼します
* サブスクリプションの代わりに Console API キーで認証します。セットアップについては [Claude Console 認証](/ja/authentication#claude-console-authentication) を参照してください
* あなたが管理者で、アクセスを有効にするオプションが表示されない場合は、[Anthropic サポート](https://support.claude.com) に連絡してください

<h3 id="routines-are-disabled-by-your-organizations-policy">
  ルーチンは組織のポリシーで無効になっています
</h3>

Team または Enterprise 組織の Owner がルーチンを組織レベルで無効にしました。エラーは、`/schedule` および claude.ai/code の [ルーチン](/ja/routines) UI からルーチンを作成または実行しようとするときに表示されます。

```text theme={null}
Routines are disabled by your organization's policy.
```

これはサーバー側の設定であるため、ローカル設定、環境変数、または CLI フラグからオーバーライドすることはできません。

**対応方法：**

* 組織の Owner に [claude.ai/admin-settings/claude-code](https://claude.ai/admin-settings/claude-code) で **ルーチン** トグルを有効にするよう依頼します
* 組織レベルのルーチンを必要としない 1 回限りのスケジュール済み作業については、[スケジュール済みタスク](/ja/scheduled-tasks) を参照してください

<h3 id="remote-control-requires-the-anthropic-api">
  リモートコントロールには Anthropic API が必要です
</h3>

セッションが Anthropic API と直接通信していないため、[リモートコントロール](/ja/remote-control) がペアリングする claude.ai バックエンドがありません。

```text theme={null}
Remote Control is only available when using Claude via api.anthropic.com.
```

これは Amazon Bedrock、Google Cloud の Agent Platform、および Microsoft Foundry に表示されます。{/* min-version: 2.1.196 */}v2.1.196 以降では、[`ANTHROPIC_BASE_URL`](/ja/env-vars) が `api.anthropic.com` 以外のホスト（[LLM ゲートウェイ](/ja/llm-gateway) やプロキシなど）を指している場合にも表示されます。claude.ai でサインインしている場合でも表示されます。

**対応方法：**

* `ANTHROPIC_BASE_URL` をアンセットしてセッションを再起動するか、Anthropic API と直接通信するセッションからリモートコントロールを起動します
* このおよび他のリモートコントロール起動メッセージについては、[リモートコントロールのトラブルシューティング](/ja/remote-control#troubleshooting) を参照してください

<h3 id="oauth-token-revoked-or-expired">
  OAuth トークンが失効または期限切れです
</h3>

保存されたログインは有効ではなくなりました。失効したトークンは、どこからでもサインアウトしたか、管理者がアクセスを削除したことを意味します。期限切れのトークンは、自動更新がセッション中に失敗したことを意味します。

```text theme={null}
OAuth token revoked · Please run /login
OAuth token has expired · Please run /login
API Error: 401 ... authentication_error
```

**対応方法：**

* `/login` を実行して再度サインインします
* 再認証後、同じセッション内でエラーが返される場合は、まず `/logout` を実行して保存されたトークンを完全にクリアしてから、`/login` を実行します
* 起動全体でログインを繰り返し求められる場合は、[トラブルシューティング](/ja/troubleshoot-install#not-logged-in-or-token-expired) のシステムクロックと macOS キーチェーンチェックを参照してください
* `403 Forbidden` や OAuth ブラウザーの問題を含む他の障害については、[ログインと認証](/ja/troubleshoot-install#login-and-authentication) を参照してください

<h3 id="oauth-scope-requirement">
  OAuth スコープ要件
</h3>

保存されたトークンは、新しい機能が必要とする権限スコープより前のものです。これは `/usage` とステータス行の使用状況インジケーターから最も頻繁に表示されます：

```text theme={null}
OAuth token does not meet scope requirement: user:profile
```

**対応方法：**

* `/login` を実行して、現在のスコープを持つ新しいトークンを取得します。ログアウトする必要はありません。

<h3 id="aws-credentials-expired-or-invalid">
  AWS 認証情報の有効期限切れまたは無効
</h3>

{/* min-version: 2.1.198 */}このメッセージには Claude Code v2.1.198 以降が必要で、設定ファイルで [`awsAuthRefresh`](/ja/amazon-bedrock#advanced-credential-configuration) が設定されている場合にのみ表示されます。AWS セッショントークンの有効期限が切れたか、拒否され、Claude Code が既に実行した自動更新が API が受け入れる認証情報を生成しませんでした。[AWS 上の Claude Platform](/ja/claude-platform-on-aws) または [Mantle エンドポイント](/ja/amazon-bedrock#use-the-mantle-endpoint) からの 401 に表示されます。これらのプロバイダーが期限切れのセキュリティトークンを報告する方法です。

中央のアクションヒントは設定からの `awsAuthRefresh` コマンドに名前を付けるため、異なります。安定した部分は先頭の `AWS credentials expired or invalid` です：

```text theme={null}
AWS credentials expired or invalid · run /login and select "Claude Platform on AWS · refresh credentials", or run `aws sso login --profile myprofile` in another terminal · API Error: 401 ...
```

`awsAuthRefresh` が設定されていない場合、同じ 401 は代わりに汎用の `Please run /login` メッセージを表示し、AWS 認証情報を更新できません。

**対応方法：**

* メッセージで指定された `awsAuthRefresh` コマンド（`aws sso login --profile myprofile` など）を別のターミナルで実行し、ブラウザーサインインを完了してから再試行します
* 対話的セッションで `/login` を実行し、**3 番目のパーティプラットフォーム** を選択してから、**3 番目のパーティプラットフォームを使用** の下で **Claude Platform on AWS · 認証情報を更新** を選択して、Claude Code を再起動せずに同じコマンドを実行します。[AWS 認証情報を設定](/ja/claude-platform-on-aws#1-configure-aws-credentials) を参照してください
* 更新コマンドが成功した後もエラーが繰り返される場合は、同じシェルとプロファイルで `aws sts get-caller-identity` を使用して Claude Code の外で ID が有効であることを確認します

<h3 id="aws-authentication-failed">
  AWS 認証に失敗しました
</h3>

{/* min-version: 2.1.198 */}このメッセージには Claude Code v2.1.198 以降が必要で、設定ファイルで [`awsAuthRefresh`](/ja/amazon-bedrock#advanced-credential-configuration) が設定されている場合にのみ表示されます。AWS プロバイダーが 403 を返したか、[Amazon Bedrock](/ja/amazon-bedrock) が 401 を返しました。

Claude Code はどの原因に当たったかを判断できません。Amazon Bedrock は期限切れのセキュリティトークンを 403 として報告しますが、403 は認可拒否（IAM 権限の欠落またはアカウントで有効になっていないモデルからの `AccessDeniedException` など）を報告する方法でもあります。

Amazon Bedrock からの 401 も [AWS 認証情報の有効期限切れまたは無効](#aws-credentials-expired-or-invalid) の下ではなくここに該当します。Amazon Bedrock は期限切れのトークンを 401 として報告しないためです。そのエンドポイントからの 401 は通常、企業プロキシなどのリクエストパス内の他の何かから来ています。

認証情報の更新は期限切れのトークンを修正でき、他の原因を修正できないため、メッセージは両方を提供します：

```text theme={null}
AWS authentication failed · run /login and select "Claude Platform on AWS · refresh credentials", or run `aws sso login --profile myprofile` in another terminal · if credentials are current, check AWS permissions and model access · API Error: 403 ...
```

中央のアクションヒントは設定からの `awsAuthRefresh` コマンドに名前を付けるため、異なります。安定した部分は先頭の `AWS authentication failed` です。

**対応方法：**

* メッセージで指定された `awsAuthRefresh` コマンドまたは `aws sso login` を実行します。期限切れの認証情報が原因である可能性があります
* 認証情報が最新の場合は、[IAM 設定](/ja/amazon-bedrock#iam-configuration) の IAM 権限が使用している ID に接続されていることを確認し、選択したモデルがアカウントとリージョンで有効になっていることを確認します
* `aws sts get-caller-identity` を実行して、リクエストが使用する ID を確認します。古い `AWS_PROFILE` またはデフォルトプロファイルは、権限の不一致の一般的な原因です

<h2 id="network-and-connection-errors">
  ネットワークと接続エラー
</h2>

これらのエラーは、Claude Code からのネットワークリクエストが宛先に到達できなかったことを意味します。通常、ローカルネットワーク、プロキシ、ファイアウォール、またはクラウド環境のネットワークポリシーに起因します。

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
* 企業プロキシの背後にいる場合は、Claude Code を起動する前に `HTTPS_PROXY` を設定し、[ネットワーク設定](/ja/network-config)を参照してください。
* LLM ゲートウェイまたはリレーを経由してルーティングする場合は、[`ANTHROPIC_BASE_URL`](/ja/env-vars)をそのアドレスに設定してください。セットアップについては、[Claude Code を LLM ゲートウェイに接続する](/ja/llm-gateway-connect)を参照してください。
* ファイアウォールが[ネットワークアクセス要件](/ja/network-config#network-access-requirements)に記載されているホストを許可していることを確認してください。
* 一時的な障害は[自動的に再試行](#automatic-retries)されます。永続的な障害はローカルネットワークの問題を示しています。

`curl` は成功するが Claude Code は失敗する場合、原因は通常、ネットワーク自体ではなく、ランタイムとネットワークの間にあります：

* Linux と WSL では、`/etc/resolv.conf` で到達不可能なネームサーバーを確認してください。特に WSL はホストから壊れたリゾルバーを継承する可能性があります。
* macOS では、切断またはアンインストールされた VPN クライアントがトンネルインターフェースまたはルーティングルールを残す可能性があります。`ifconfig` で古い `utun` インターフェースを確認し、システム設定から VPN のネットワーク拡張機能を削除してください。
* Docker Desktop および同様のコンテナランタイムは、アウトバウンドトラフィックをインターセプトできます。これを除外するために、それらを終了して再試行してください。

<h3 id="ssl-certificate-errors">
  SSL 証明書エラー
</h3>

ネットワーク上のプロキシまたはセキュリティアプライアンスが TLS トラフィックを独自の証明書でインターセプトしており、Claude Code がそれを信頼していません。

```text theme={null}
Unable to connect to API: SSL certificate verification failed. Check your proxy or corporate SSL certificates
Unable to connect to API: Self-signed certificate detected
```

{/* min-version: 2.1.199 */}v2.1.199 以降、証明書検証の失敗は再試行されないため、このエラーは完全な[再試行予算](#automatic-retries)の後ではなく、最初の試行時に表示されます。以前のバージョンでは、表示する前に数分間再試行していました。ハンドシェイクタイムアウトなどの一時的な TLS 条件は、引き続き再試行されます。

`/login` とスタートアップ接続チェック中に、同じ障害が OpenSSL コードとインラインの修正とともに報告されます：

```text theme={null}
SSL certificate error (UNABLE_TO_GET_ISSUER_CERT_LOCALLY). If you are behind a corporate proxy or TLS-intercepting firewall, set NODE_EXTRA_CA_CERTS to your CA bundle path, or ask IT to allowlist *.anthropic.com. Run `claude doctor` for details.
```

**対応方法：**

* 組織の CA バンドルをエクスポートし、`NODE_EXTRA_CA_CERTS=/path/to/ca-bundle.pem` で Claude Code に指定してください。
* 完全なセットアップ手順については、[ネットワーク設定](/ja/network-config#custom-ca-certificates)を参照してください。
* `NODE_TLS_REJECT_UNAUTHORIZED=0` を設定しないでください。これは証明書検証を完全に無効にします。

<h3 id="host-not-allowed-in-a-cloud-session">
  クラウドセッションでホストが許可されていない
</h3>

クラウドセッションまたはルーチンからのアウトバウンド HTTP リクエストが、環境のネットワークポリシーによってブロックされました。

```text theme={null}
HTTP 403
x-deny-reason: host_not_allowed
```

宛先の実際の証明書と一致しない TLS 証明書も表示される場合があります。クラウド環境はアウトバウンドトラフィックをプロキシを通じてルーティングしてネットワークポリシーを適用するため、証明書の不一致は宛先ではなくプロキシが接続を終了したことを意味します。

これはクライアント側のネットワーク問題ではありません。クラウドセッションと[ルーチン](/ja/routines)はサンドボックス環境内で実行され、アウトバウンドトラフィックは環境のアローリストにフィルタリングされます。**Default** 環境は**Trusted** アクセスを使用し、パッケージレジストリ、クラウドプロバイダー API、コンテナレジストリ、および一般的な開発ドメインの[デフォルトアローリスト](/ja/claude-code-on-the-web#default-allowed-domains)を許可しますが、その他すべてをブロックします。

**対応方法：**

* ルーチンを編集用に開くか、クラウドセッションを開始してください。**Default** などの環境名を示すクラウドアイコンを選択して、セレクターを開いてください。環境にマウスを置き、設定アイコンをクリックしてください。
* **Update cloud environment** ダイアログで、**Network access** を**Trusted** から**Custom** に変更し、ブロックされたドメインを**Allowed domains** に追加してください。1 行に 1 つのドメインを入力してください。**Also include default list of common package managers** をチェックして、カスタムドメインと共に[デフォルトアローリスト](/ja/claude-code-on-the-web#default-allowed-domains)を保持してください。無制限のアクセスが必要な場合は、代わりに**Full** を選択してください。
* **Save changes** をクリックしてください。次の実行は更新されたアローリストを使用します。

アクセスレベルとデフォルトアローリストについては、[ネットワークアクセス](/ja/claude-code-on-the-web#network-access)を参照してください。ローカル CLI セッションはこのポリシーの影響を受けません。

<h3 id="couldnt-reconnect-to-your-remote-control-session">
  Remote Control セッションに再接続できませんでした
</h3>

```text theme={null}
Couldn't reconnect to your Remote Control session. Retry, or start a fresh session without --resume.
```

`claude --resume` または `claude --continue` で再開すると、その会話に記録された[Remote Control](/ja/remote-control)セッションに再接続します。このメッセージは、ネットワーク中断またはサーバーエラーなどの一時的な理由で再接続に失敗したことを意味し、Claude Code はリモートセッションがまだ存在するかどうかを確認できません。ローカルセッションは Remote Control なしで実行を続けます。

**対応方法：**

* `/remote-control` を実行して接続を再試行してください。
* `--resume` なしで Claude Code を開始して、新しい Remote Control セッションを作成してください。
* その他の Remote Control スタートアップメッセージについては、[Remote Control のトラブルシューティング](/ja/remote-control#troubleshooting)を参照してください。

サーバーが前のセッションがもう存在しないことを確認した場合、このメッセージは表示されません。Claude Code はその場合に新しいセッションを作成します。{/* min-version: 2.1.200 */}v2.1.200 より前では、再接続の失敗により新しい Remote Control セッションが作成され、claude.ai/code のセッションリストに余分なセッションが残されました。

<h2 id="request-errors">
  リクエストエラー
</h2>

これらのエラーはリクエストの内容に関連しています。ほとんどはリクエストを拒否した後に API から返されます。いくつかはリクエストが送信される前に Claude Code によってローカルで生成されます。

<h3 id="prompt-is-too-long">
  プロンプトが長すぎます
</h3>

会話と添付ファイルがモデルのコンテキストウィンドウを超えています。

```text theme={null}
Prompt is too long
```

**対処方法：**

* `/compact` を実行して以前のターンを要約し、スペースを解放するか、`/clear` を実行して新しく開始します
* `/context` を実行して、ウィンドウを消費しているものの内訳を確認します。システムプロンプト、ツール、メモリファイル、メッセージです
* `/mcp disable <name>` で使用していない MCP サーバーを無効にして、コンテキストからツール定義を削除します
* 大きな `CLAUDE.md` メモリファイルをトリミングするか、指示を [パススコープ規則](/ja/memory#path-specific-rules) に移動して、関連する場合にのみ読み込みます
* サブエージェントは親セッションからすべての MCP ツール定義を継承します。これにより、最初のターンの前にコンテキストウィンドウが満杯になる可能性があります。サブエージェントを生成する前に、使用していない MCP サーバーを無効にします
* オートコンパクトはデフォルトで有効になっており、通常このエラーを防ぎます。[`DISABLE_AUTO_COMPACT`](/ja/env-vars) を設定している場合は、再度有効にするか、ウィンドウが満杯になる前に `/compact` を手動で実行します

[コンテキストウィンドウを探索](/ja/context-window) を参照して、コンテキストがどのように満杯になるかのインタラクティブビューを確認してください。

<h3 id="error-during-compaction-conversation-too-long">
  コンパクション中のエラー：会話が長すぎます
</h3>

`/compact` 自体が失敗しました。生成される要約を保持するのに十分な空きコンテキストがないためです。

```text theme={null}
Error during compaction: Conversation too long. Press esc twice to go up a few messages and try again.
```

これは、ウィンドウがオートコンパクトをトリガーする時点で既に満杯の場合、または `Prompt is too long` を見た後に `/compact` を実行した場合に発生する可能性があります。

**対処方法：**

* Esc キーを 2 回押してメッセージリストを開き、数ターン戻ります。これにより、最新のメッセージがコンテキストから削除されます。その後、`/compact` を再度実行します
* 戻ることで十分なスペースが解放されない場合は、`/clear` を実行して新しいセッションを開始します。以前の会話は保持され、`/resume` で再度開くことができます

<h3 id="request-too-large">
  リクエストが大きすぎます
</h3>

トークン化前の生のリクエストボディが API のバイト制限を超えました。通常は、大きなペーストファイルまたは添付ファイルが原因です。

```text theme={null}
Request too large (max 30 MB). Double press esc to go back and remove or shrink the attached content.
```

これは HTTP リクエストのサイズ制限であり、[コンテキストウィンドウ制限](#prompt-is-too-long) とは別です。

**対処方法：**

* Esc キーを 2 回押して、サイズが大きすぎるコンテンツを追加したターンを戻ります
* 大きなファイルの内容をペーストするのではなく、パスで参照して、Claude がチャンク単位で読み込めるようにします
* 画像については、以下の [画像が大きすぎました](#image-was-too-large) を参照してください

<h3 id="image-was-too-large">
  画像が大きすぎました
</h3>

ペーストまたは添付された画像が API のサイズまたは寸法制限を超えています。

```text theme={null}
Image was too large. Double press esc to go back and try again with a smaller image.
API Error: 400 ... image dimensions exceed max allowed size
```

{/* min-version: 2.1.142 */}Claude Code は処理できない画像をテキストプレースホルダーに置き換えて再試行するため、後続のメッセージは成功します。2.1.142 より前のバージョンでは、ペーストされた画像が会話に残り、後続のすべてのメッセージで同じエラーが繰り返される可能性がありました。これらのバージョンで復旧するには、Esc キーを 2 回押して、画像が追加されたターンを戻ります。

**対処方法：**

* ペーストする前に画像をリサイズします。API は単一の画像の場合は最長辺で 8000 ピクセルまで、多くの画像がコンテキストにある場合は 2000 ピクセルまでの画像を受け入れます
* 全画面ではなく、関連する領域のより厳密なスクリーンショットを撮ります

<h3 id="unable-to-resize-image">
  画像をリサイズできません
</h3>

Claude Code は添付された画像を API に送信する前にダウンスケールできませんでした。

```text theme={null}
Unable to resize image — image processing is unavailable and dimensions could not be read from the file header. Please convert the image to PNG, JPEG, GIF, or WebP.
Unable to resize image — dimensions exceed the 2000x2000px limit and image processing failed. Please resize the image to reduce its pixel dimensions.
Unable to resize image (… raw, … base64). The image exceeds the … API limit and compression failed. Please resize the image manually or use a smaller image.
Unable to resize image — could not verify image dimensions are within the 2000x2000px API limit.
```

Claude Code は通常、大きな画像を自動的にリサイズします。これらのエラーは、ネイティブ画像プロセッサーが読み込みに失敗したか、エラーを返したため、画像を API 制限内に収まるようにリサイズできなかったことを意味します。

**対処方法：**

* メッセージで画像を変換するよう求められた場合は、PNG、JPEG、GIF、または WebP に変換して再度添付します。Claude Code はこれらの形式の寸法を画像プロセッサーなしで検証できます
* メッセージが寸法またはサイズ制限を報告する場合は、その制限以下に画像をリサイズまたは再圧縮してから添付します

<h3 id="pdf-errors">
  PDF エラー
</h3>

添付した PDF を処理できませんでした。

```text theme={null}
PDF too large (max 100 pages, 32 MB). Try splitting it or extracting text first.
PDF is password protected. Try removing protection or extracting text first.
The PDF file was not valid. Try converting to a different format first.
```

**対処方法：**

* サイズが大きい PDF の場合は、ファイル全体を添付するのではなく、Read ツールでページ範囲を読み込むよう Claude に依頼するか、`pdftotext` などのツールでテキストを抽出して、出力ファイルをパスで参照します
* 保護されている、または無効な PDF の場合は、パスワードを削除するか、ソースアプリケーションからファイルを再度エクスポートしてから、もう一度試します

<h3 id="extra-inputs-are-not-permitted">
  追加の入力は許可されていません
</h3>

Claude Code と API の間のプロキシまたは LLM ゲートウェイが `anthropic-beta` リクエストヘッダーを削除したため、API はそれに依存するフィールドを拒否しました。

```text theme={null}
API Error: 400 ... Extra inputs are not permitted ... context_management
API Error: 400 ... Extra inputs are not permitted ... tools.0.custom.input_examples
API Error: 400 ... Unexpected value(s) for the `anthropic-beta` header
```

Claude Code は `context_management`、`effort`、ツール `input_examples` などのベータのみのフィールドを、それらを有効にする `anthropic-beta` ヘッダーと共に送信します。ゲートウェイがボディを転送してもヘッダーを削除すると、API は認識しないフィールドを見ます。

**対処方法：**

* `anthropic-beta` ヘッダーを転送するようにゲートウェイを設定します。ゲートウェイが転送する必要があるものについては、[機能パススルー](/ja/llm-gateway-protocol#feature-pass-through) を参照してください
* フォールバックとして、起動前に [`CLAUDE_CODE_DISABLE_EXPERIMENTAL_BETAS=1`](/ja/env-vars) を設定します。これにより、ベータヘッダーが必要な機能が無効になり、ヘッダーを転送できないゲートウェイを通じてリクエストが成功します

<h3 id="theres-an-issue-with-the-selected-model">
  選択されたモデルに問題があります
</h3>

設定されたモデル名が認識されなかったか、アカウントがそれへのアクセス権を持っていません。v2.1.160 以降、ここに対話形式で示されている末尾のヒントはサーフェスによって異なります。

```text theme={null}
There's an issue with the selected model (claude-...). It may not exist or you may not have access to it. Run /model to pick a different model.
```

**対処方法：**

* **対話型 CLI**：`/model` を実行して、アカウントで利用可能なモデルから選択します
* **非対話型モード（`-p`）**：`--model` に有効なエイリアスまたは ID を渡すか、[`ANTHROPIC_MODEL`](/ja/env-vars) を設定します。エラーテキストはこのサーフェスで `Run --model` を表示します
* **Agent SDK**：モデルがプログラムで設定されているため、エラーテキストはヒントを省略します。TypeScript で [`Options` の `model`](/ja/agent-sdk/typescript#options) を設定するか、Python で [`ClaudeAgentOptions(model=...)`](/ja/agent-sdk/python#claudeagentoptions) を設定し、構造化された `model_not_found` エラーを処理して、独自の再試行またはモデルピッカーを表示します
* 完全なバージョン付き ID ではなく、`sonnet` や `opus` などのエイリアスを使用します。エイリアスは保守されたデフォルトに解決されるため、古くなりません。[モデル設定](/ja/model-config) を参照してください
* CLI で間違ったモデルが戻り続ける場合は、どこかに古い ID が設定されています。[優先順位順](/ja/model-config#setting-your-model) で確認します：`--model` フラグ、`ANTHROPIC_MODEL` 環境変数、次に `.claude/settings.local.json` の `model` フィールド、プロジェクトの `.claude/settings.json`、および `~/.claude/settings.json`。古い値を削除すると、Claude Code はアカウントのデフォルトにフォールバックします
* Google Cloud の Agent Platform デプロイメントについては、[Google Cloud の Agent Platform トラブルシューティング](/ja/google-vertex-ai#troubleshooting) を参照してください

<h3 id="model-is-not-a-recognized-model-id">
  モデルは認識されたモデル ID ではありません
</h3>

モデルスイッチに渡したモデル文字列は、モデルエイリアス、この Claude Code バージョンが認識するモデル ID、または `claude-` で始まる ID ではありません。通常の原因は、ID のタイプミス、`Sonnet 5` などの表示名（ID `claude-sonnet-5` が必要）、または新しい Claude Code バージョンのみが認識するエイリアスです。Claude Code はスイッチを即座に拒否します。v2.1.200 より前は、Claude Code は文字列を保存し、[選択されたモデルに問題があります](#theres-an-issue-with-the-selected-model) で次のリクエストで失敗しました。

```text theme={null}
Model "claud-sonnet-5" is not a recognized model id. Did you mean 'claude-sonnet-5'?
```

末尾のヒントは、最も近いマッチングエイリアスまたはモデル ID に名前を付けます。十分に近いものがない場合は、代わりに `Run /model to see available models.` と表示されます。

Claude Code はこのエラーをローカルで生成します。スイッチが要求された時点で、API リクエストが行われる前です。これは、[Agent SDK](/ja/agent-sdk/typescript) `setModel()` メソッドを通じてモデルが設定されるか、[Desktop app](/ja/desktop) などのアプリケーションが Claude Code CLI を実行する場合に適用されます。

**対処方法：**

* 引数なしで `/model` を実行してピッカーを開き、アカウントで利用可能なモデルから選択してから、そこに表示されているエイリアスまたは ID を渡します
* 新しい Claude Code バージョンがサポートするエイリアスを使用した場合は、`claude update` を実行します。`claude-` で始まる完全な ID はこのチェックに合格します。モデルが Claude Code バージョンより新しい場合でも、アップグレードは不要です
* v2.1.200 より前に保存されたモデルはこのチェックで修復されません。古い値が戻り続ける場合は、[選択されたモデルに問題があります](#theres-an-issue-with-the-selected-model) に記載されている場所から削除します
* チェックは Anthropic API でのみ実行されます。Amazon Bedrock、Google Cloud の Agent Platform、Microsoft Foundry、[Claude Platform on AWS](/ja/claude-platform-on-aws)、および [LLM ゲートウェイ](/ja/llm-gateway) または カスタム `ANTHROPIC_BASE_URL` の背後では、プロバイダーまたはゲートウェイがモデル名を定義するため、Claude Code は任意の文字列を受け入れて渡します

<h3 id="claude-opus-is-not-available-with-the-claude-pro-plan">
  Claude Opus は Claude Pro プランでは利用できません
</h3>

アクティブなサブスクリプションプランに、選択したモデルが含まれていません。

```text theme={null}
Claude Opus is not available with the Claude Pro plan · Select a different model in /model
```

**対処方法：**

* `/model` を実行して、プランに含まれるモデルを選択します
* 最近プランをアップグレードしてもこれが表示される場合は、`/logout` を実行してから `/login` を実行します。保存されたトークンはサインイン時のプランを反映するため、Web でアップグレードしても、再認証するまで既存のセッションで有効になりません
* 各プランに含まれるモデルについては、[claude.com/pricing](https://claude.com/pricing) を参照してください

<h3 id="model-is-restricted-by-your-organizations-settings">
  モデルは組織の設定によって制限されています
</h3>

組織の管理者が claude.ai 管理コンソールでこのモデルを無効にしたか、管理設定の [`availableModels`](/ja/model-config#restrict-model-selection) 許可リストで除外されています。制限されたモデルが `--model`、`ANTHROPIC_MODEL`、または `model` 設定で設定された場合、Claude Code は許可されたモデルに置き換えて続行します。制限されたモデルに対して `/model <name>` を入力すると、`Run /model to choose a different model.` で拒否され、セッションは現在のモデルを保持します。

```text theme={null}
Model "claude-opus-4-8" is restricted by your organization's settings. Using claude-sonnet-4-6 instead.
```

Claude Code は、`opus`、`sonnet`、`haiku`、または `fable` の 1 つであるモデルファミリーエイリアスを、最新バージョンへのリクエストではなく、そのファミリーへのリクエストとして扱います。Anthropic API および [Claude Platform on AWS](/ja/claude-platform-on-aws) では、制限されたファミリーエイリアスは、組織と `availableModels` 許可リストが許可するファミリーの最新バージョンに解決され、置き換え通知がそのバージョンに名前を付けます。Claude Code は、ファミリーのすべてのバージョンが制限されている場合にのみ `/model <alias>` を拒否します。v2.1.205 より前は、ファミリーエイリアスは同じファミリーの古いバージョンが許可されている場合でも、最新バージョンのみに基づいて置き換えられるか拒否されました。

**対処方法：**

* `/model` を実行して、組織が許可するモデルから選択します。制限されたモデルはピッカーから非表示になります
* 制限されたモデルが `--model`、`ANTHROPIC_MODEL`、または設定ファイルの `model` フィールドで設定された場合は、その値を削除または更新して、起動するたびに通知が繰り返されないようにします
* 制限されたモデルへのアクセスが必要な場合は、組織の管理者に有効にするよう依頼します。[組織モデル制限](/ja/model-config#organization-model-restrictions) を参照してください

<h3 id="thinking-type-enabled-is-not-supported-for-this-model">
  thinking.type.enabled はこのモデルではサポートされていません
</h3>

Claude Code バージョンが Sonnet 5、Opus 4.8、または Opus 4.7 の最小値より古いです。CLI は、モデルが受け入れなくなった思考設定を送信しました。

```text theme={null}
API Error: 400 ... "thinking.type.enabled" is not supported for this model. Use "thinking.type.adaptive" and "output_config.effort" to control thinking behavior.
```

**対処方法：**

* `claude update` を実行して Claude Code を再起動します。Opus 4.7 には v2.1.111 以降が必要です。Opus 4.8 には v2.1.154 以降が必要です。Sonnet 5 には v2.1.197 以降が必要です
* アップグレードできない場合は、`/model` を実行して Opus 4.6 または Sonnet 4.6 を選択します
* {/* min-version: agent-sdk@0.3.197 */}[Agent SDK](/ja/agent-sdk/overview) でこれが発生した場合は、SDK パッケージをアップグレードします。Opus 4.8 には TypeScript SDK v0.3.154 以降と Python SDK v0.2.88 以降が必要です。Sonnet 5 には TypeScript SDK v0.3.197 以降が必要です

<h3 id="thinking-budget-exceeds-output-limit">
  思考予算が出力制限を超えています
</h3>

設定された拡張思考予算が最大応答長を超えているため、実際の回答用のスペースが残っていません。

```text theme={null}
API Error: 400 ... max_tokens must be greater than thinking.budget_tokens
```

Claude Code は Anthropic API でこれらの値を自動的に調整します。通常、Amazon Bedrock または Google Cloud の Agent Platform でこのエラーが表示されるのは、[`MAX_THINKING_TOKENS`](/ja/env-vars) がプロバイダーの出力制限より高く設定されている場合、またはプランモードが思考予算を引き上げた場合です。

**対処方法：**

* `MAX_THINKING_TOKENS` を下げるか、[`CLAUDE_CODE_MAX_OUTPUT_TOKENS`](/ja/env-vars) を思考予算より上に上げます
* 予算が出力長とどのように相互作用するかについては、[拡張思考](/ja/model-config#extended-thinking) を参照してください

<h3 id="tool-use-or-thinking-block-mismatch">
  ツール使用または思考ブロックの不一致
</h3>

会話履歴が API に矛盾した状態で到達しました。通常は、ツール呼び出しが中断されたか、ターンがストリーム中に編集された後です。

```text theme={null}
API Error: 400 due to tool use concurrency issues. Run /rewind to recover the conversation.
API Error: 400 ... unexpected `tool_use_id` found in `tool_result` blocks
API Error: 400 ... thinking blocks ... cannot be modified
```

3 つのバリアントすべてが同じことを意味します。履歴内の `tool_use`、`tool_result`、および `thinking` ブロックのシーケンスが、API が期待するものと一致しなくなりました。

**対処方法：**

* {/* max-version: 2.1.155 */}Opus 4.7 または Opus 4.8 を使用している場合は、最初に `claude update` を実行します。v2.1.156 より前のバージョンは、通常のツール使用中にこのエラーをトリガーでき、`/rewind` はそれをクリアしません
* `/rewind` を実行するか、Esc キーを 2 回押して、破損したターンの前のチェックポイントに戻り、そこから続行します。チェックポイントがどのように作成および復元されるかについては、[チェックポイント](/ja/checkpointing) を参照してください

<h3 id="usage-policy-refusal">
  使用ポリシー拒否
</h3>

API は、会話内のコンテンツが [使用ポリシー](https://www.anthropic.com/legal/aup) チェックをトリガーしたため、応答を拒否しました。メッセージには、拒否が正しくないと思われる場合にサポートに引用できるリクエスト ID が含まれています。

```text theme={null}
API Error: Claude Code is unable to respond to this request, which appears to violate our Usage Policy (https://www.anthropic.com/legal/aup). Please double press esc to edit your last message or start a new session for Claude Code to assist with a different task.
```

チェックは最新のプロンプトだけでなく、完全な会話を評価するため、同じセッションで新しいメッセージを送信すると、通常は同じ拒否が再度トリガーされます。同じことは、`--continue` または `--resume` でセッションを終了して再度開いた後にも適用されます。ディスク上のトランスクリプトにはまだトリガーコンテンツが含まれているためです。[Amazon Bedrock](/ja/amazon-bedrock)、[Google Cloud の Agent Platform](/ja/google-vertex-ai)、および [Microsoft Foundry](/ja/microsoft-foundry) では、このメッセージはモデルのセーフティ対策がサイバーセキュリティトピックとしてフラグを立てたリクエストもカバーします。[セーフティ対策がサイバーセキュリティトピックをフラグ立てしました](#safety-measures-flagged-a-cybersecurity-topic) を参照してください。

**対処方法：**

* Esc キーを 2 回押すか `/rewind` を実行して、拒否をトリガーしたターンの前のチェックポイントに戻り、別の方法で言い換えるか試します。[チェックポイント](/ja/checkpointing) を参照してください
* どのターンが原因かを特定できない場合は、`/clear` を実行して同じプロジェクトで新しい会話を開始します。以前の会話はディスクに保持され、`/resume` で利用可能なままです
* [非対話型モード](/ja/headless)（`-p`）では、巻き戻しが利用できないため、`--continue` なしの新しいセッションで言い換えたプロンプトで再試行します。ポリシーチェックはモデルによって異なるため、`--model` で別のモデルに切り替えると、場合によっては拒否が解決される可能性があります

<h3 id="safety-measures-flagged-a-cybersecurity-topic">
  セーフティ対策がサイバーセキュリティトピックをフラグ立てしました
</h3>

モデルのセーフティ対策が会話内のコンテンツをサイバーセキュリティトピックとしてフラグ立てしました。メッセージはリクエストをフラグ立てしたモデルに名前を付けます：

```text theme={null}
API Error: Opus 4.8 has safety measures that flagged this message for a cybersecurity topic. To learn about the Cyber Verification Program and apply for access, visit our help center: https://support.claude.com/en/articles/14604842-real-time-cyber-safeguards-on-claude.

If you were not engaging in a cybersecurity topic, please send feedback via /feedback.
```

メッセージは [Cyber Verification Program](https://support.claude.com/en/articles/14604842-real-time-cyber-safeguards-on-claude) にリンクしており、正当なサイバーセキュリティ作業へのアクセスを許可します。セーフガード自体はサーバー側であり、v2.1.203 より前のものです。このリリースはメッセージの文言とそれがリンクするページのみを変更しました。

表示内容はプロバイダーとモードによって異なります：

* [Amazon Bedrock](/ja/amazon-bedrock)、[Google Cloud の Agent Platform](/ja/google-vertex-ai)、および [Microsoft Foundry](/ja/microsoft-foundry) では、サイバーセキュリティフラグは代わりに [使用ポリシー拒否](#usage-policy-refusal) メッセージを生成します
* [非対話型モード](/ja/headless) は `/feedback` 文を省略します

{/* max-version: 2.1.202 */}v2.1.203 より前は、メッセージは `<model>'s safeguards flagged this message for a cybersecurity topic. If your work requires this access, you can apply for an exemption:` の後に免除フォームリンクが続きました。

**対処方法：**

* このコンテンツが必要な場合は、[Cyber Verification Program](https://support.claude.com/en/articles/14604842-real-time-cyber-safeguards-on-claude) を通じてアクセスを申請します
* リクエストがサイバーセキュリティトピックではなかった場合は、`/feedback` を実行して誤検知を報告します
* 同じセッションで作業を続けるには、Esc キーを 2 回押すか `/rewind` を実行して、フラグをトリガーしたターンの前のチェックポイントに戻り、別の方法を試します。[チェックポイント](/ja/checkpointing) を参照してください

<h2 id="installation-errors">
  インストールエラー
</h2>

これらのエラーは、[インストールスクリプト](/ja/setup#install-claude-code)、`claude install`、または `claude update` から Claude Code をインストールまたは更新する際に表示されます。セットアップ中の `command not found`、PATH、権限、および TLS の問題については、[インストールとログインのトラブルシューティング](/ja/troubleshoot-install)を参照してください。

<h3 id="installation-was-killed-before-it-could-finish">
  インストールが完了する前に終了しました
</h3>

インストールスクリプトは、`claude install` ステップがシグナルによって終了された場合に報告します。Linux では、終了コード 137 はプロセスが SIGKILL を受け取ったことを意味し、メモリが少ないホストでは通常、カーネルのメモリ不足（OOM）キラーです。スクリプトはこの説明を出力し、コード 137 で終了します。

```text theme={null}
Installation was killed before it could finish (exit code 137). This usually means the system ran out of memory.
Claude Code needs roughly 512MB of free memory to install. Free up memory, then run this script again.
```

その他の致命的なシグナルの場合、および macOS でのコード 137 の場合、スクリプトは `Installation was killed before it could finish (exit code <N>)` を出力し、実際の終了コードを表示し、メモリ不足の説明は省略します。メッセージは macOS と Linux が使用するインストールスクリプトから来ており、WSL 内のインストールもカバーしています。ネイティブ Windows インストールスクリプトはこれを出力しません。v2.1.200 より前では、スクリプトはシェルの単なる `Killed` 行でのみ終了していました。

**対処方法：**

* 他のプロセスを停止してメモリを解放し、インストーラーを再実行します
* スワップスペースを追加するか、より大きなインスタンスに移動します。[低メモリ Linux サーバーでのインストール終了](/ja/troubleshoot-install#install-killed-on-low-memory-linux-servers)を参照して、スワップファイルコマンドを確認してください。

<h3 id="the-connection-dropped-while-downloading-the-update">
  更新のダウンロード中に接続が切断されました
</h3>

`claude install`、`claude update`、または[自動アップデーター](/ja/setup#auto-updates)が Claude Code バイナリをフェッチしている間にダウンロードサーバーへの接続が閉じられ、リトライが回復しませんでした。Claude Code は、接続がドロップされた場合、転送が停止した場合、またはダウンロードされたファイルがチェックサムに失敗した場合、最大 3 回の試行でダウンロードを再試行します。404 などの完了した HTTP エラーは、サーバーが既に応答しているため再試行されません。{/* min-version: 2.1.202 */}v2.1.202 より前では、単一の接続ドロップはダウンロードを即座に失敗させ、リトライの代わりに単なるエラー `aborted` を表示していました。

```text theme={null}
The connection dropped while downloading the update (attempt 3/3: aborted). Check your network — proxies sometimes cut off large downloads.
```

括弧内のテキストは、失敗した試行と基になるネットワークエラーを示します。`claude update` は stderr でメッセージの前に `Error: Failed to install native update` を付けます。

接続は保持されているがダウンロードが 10 分以内に完了しない場合、代わりに `Download timed out: exceeded the total deadline` で失敗します。Claude Code はタイムアウトしたダウンロードを再試行しません。これは、期限内に完了するのに十分な速度がない接続は、即座に再試行しても完了しないためです。以下の手順は両方のメッセージに適用されます。v2.1.205 より前では、同じ 10 分のデッドラインは HTTP クライアントの汎用 `timeout of 600000ms exceeded` として報告されていました。

通常の原因は、長い転送が完了する前に接続を閉じるプロキシまたはゲートウェイです。Claude Code バイナリは大きなダウンロードであるため、通常の API トラフィックに影響を与えないプロキシ接続制限でも、それでも中断される可能性があります。

**対処方法：**

* `claude update` を再度実行します。それ以外の場合は健全なネットワークで、ダウンロードは通常、次の実行で成功します。タイムアウトメッセージの場合は、より高速またはスロットルされていないネットワークから再度実行します。
* ネットワークがプロキシを必要とする場合は、インストーラーまたは `claude update` を実行する前に `HTTPS_PROXY` を設定します。[ネットワーク接続の確認](/ja/troubleshoot-install#check-network-connectivity)を参照してください。
* 企業プロキシが転送を閉じ続ける場合は、ネットワークチームに `downloads.claude.ai` からの完全なダウンロードを許可するよう依頼します。[ネットワークアクセス要件](/ja/network-config#network-access-requirements)を参照してください。
* インストール診断のためにシェルから `claude doctor` を実行します

<h2 id="command-line-errors">
  コマンドラインエラー
</h2>

これらのエラーは `claude` コマンドラインとそのサブコマンドから発生します。Claude Code はプロンプトを実行する前またはAPI リクエストを送信する前にこれらを出力します。

<h3 id="conflict-between-bg-and-print">
  \--bg と --print の競合
</h3>

このメッセージは Claude Code v2.1.198 以降が必要です。同じ `claude` 呼び出しで `--bg` を `-p` または `--print` と組み合わせました。`--bg` は[バックグラウンドセッション](/ja/agent-view#from-your-shell)を開始し、後で `claude agents` で接続できます。一方、`--print` は[非対話的に](/ja/headless)実行され、`claude agents` が接続するインタラクティブセッションを開始しません。v2.1.198 より前では、この組み合わせは接続できないバックグラウンドジョブを静かに作成していました。

```text theme={null}
--bg と --print の競合: --print は `claude agents` が接続するインタラクティブセッションを開始しないため、ジョブは接続不可能になります。プロンプトは位置引数です — --print を削除してください: `claude --bg '<task>'`。
```

**対応方法:**

* `-p` または `--print` を削除してください。`--bg` はプロンプトを位置引数として受け取るため、`claude --bg "<task>"` が完全なコマンドです。[シェルから新しいエージェントをディスパッチする](/ja/agent-view#from-your-shell)を参照してください。
* プロンプトを非対話的に実行し、バックグラウンドセッションを作成する代わりに結果を出力するには、`--bg` を削除して `claude -p "<task>"` を実行してください。

<h3 id="the-json-schema-value-is-not-a-valid-json-schema">
  \--json-schema 値が有効な JSON Schema ではありません
</h3>

[非対話的モード](/ja/headless#get-structured-output)で [`--json-schema`](/ja/cli-reference#cli-flags) に渡したスキーマが JSON Schema コンパイルに失敗したため、`claude` はプロンプトを実行する代わりに終了コード 1 で終了します。v2.1.205 より前では、無効なスキーマは エラーなしで非構造化出力を生成し、`format` キーワードを使用したスキーマはすべて無効として扱われていました。

```text theme={null}
Error: --json-schema is not a valid JSON Schema: data/type must be equal to one of the allowed values
```

2 番目のコロンの後のテキストはバリデータの診断で、失敗したキーワードまたは場所を示します。`"format": "email"` などの `format` キーワードを使用するスキーマは有効です。Claude Code は `format` を注釈として受け入れ、強制しません。

Claude Code はスキーマコンパイルの前に 2 つのチェックを実行します。解析不可能な JSON の値は `Error: --json-schema is not valid JSON` で拒否され、オブジェクトではない有効な JSON は `Error: --json-schema must be a JSON object` で拒否されます。

**対応方法:**

* 診断が示すスキーマの部分を修正し、コマンドを再実行してください。
* 診断が `schema too large` の場合は、スキーマのネストと `$ref` の再利用を減らしてください。
* [構造化出力を取得する](/ja/headless#get-structured-output)で動作するスキーマとコマンドを参照してください。

<h3 id="could-not-import-a-server-from-claude-desktop">
  Claude Desktop からサーバーをインポートできませんでした
</h3>

Claude Code は `claude mcp add-from-claude-desktop` で選択したサーバーの 1 つを追加できませんでした。コマンドは他の選択されたサーバーをインポートし、追加できなかったサーバーごとに 1 行出力します。v2.1.205 より前では、失敗した最初のサーバーがインポートを停止し、選択されたサーバーは追加されませんでした。

```text theme={null}
Could not import my server: Invalid name my server. Names can only contain letters, numbers, hyphens, and underscores.
```

サーバー名の後のテキストは理由です。最も一般的なのは名前チェックです。Claude Desktop はサーバー名にスペースやピリオドなどの文字を許可していますが、`claude mcp` はこれらを文字、数字、ハイフン、アンダースコアのみに制限しています。その他の理由には、検証に失敗するサーバー設定と、組織の [MCP ポリシー](/ja/managed-mcp)によってブロックされたサーバーが含まれます。

**対応方法:**

* `claude_desktop_config.json` でサーバーの名前を変更して、文字、数字、ハイフン、アンダースコアのみを使用するようにしてから、`claude mcp add-from-claude-desktop` を再度実行してください。
* 有効な名前で `claude mcp add` または `claude mcp add-json` を使用してそのサーバーを直接追加してください。[Claude Desktop から MCP サーバーをインポートする](/ja/mcp#import-mcp-servers-from-claude-desktop)を参照してください。

<h2 id="plugin-errors">
  プラグインエラー
</h2>

これらのエラーは、[プラグイン](/ja/plugins)と[マーケットプレイス](/ja/plugin-marketplaces)の設定から発生します。このページのメッセージを生成しないプラグインの問題（マーケットプレイス URL が読み込まれない、またはプラグインがインストールされても表示されないなど）については、[プラグインのトラブルシューティング](/ja/discover-plugins#troubleshooting)を参照してください。

<h3 id="marketplace-is-registered-from-an-untrusted-source">
  マーケットプレイスが信頼されていないソースから登録されている
</h3>

マーケットプレイスは、[公式 Anthropic マーケットプレイス用に予約されている](/ja/plugin-marketplaces#marketplace-schema)名前で登録されていますが、登録されたソースが `anthropics` GitHub リポジトリではありません。Claude Code は、マーケットプレイスを読み込むか更新するたびに予約名を再確認するため、マーケットプレイスとそこからインストールされたプラグインの読み込みが停止します。v2.1.205 より前では、マーケットプレイスが追加されたときにのみ名前がチェックされていたため、その名前が予約される前に登録されたエントリは読み込み続けていました。

```text theme={null}
Marketplace "claude-community" is registered from an untrusted source: The name 'claude-community' is reserved for official Anthropic marketplaces. Only repositories from 'github.com/anthropics/' can use this name. To fix it, remove the marketplace and re-add it from the official source.
```

**対処方法：**

* `claude plugin marketplace remove <name>` を実行してから、公式の `github.com/anthropics` リポジトリからマーケットプレイスを再度追加してください
* 名前が予約される前にその名前を使用していたサードパーティマーケットプレイスを公開している場合は、名前を変更し、ユーザーにあなたのソースから再度追加するよう依頼してください
* [マーケットプレイススキーマ](/ja/plugin-marketplaces#marketplace-schema)の予約名リストを参照してください

<h2 id="configuration-warnings">
  設定に関する警告
</h2>

Claude Code は、会話内にエラーを表示するのではなく、起動時にこれらのメッセージを stderr に書き込みます。これらは読み込まれたが適用されなかった設定を報告します。

<h3 id="workspace-has-not-been-trusted">
  ワークスペースが信頼されていません
</h3>

Claude Code は、プロジェクトの `.claude/settings.json` または `.claude/settings.local.json` で `permissions.allow` ルールまたは `permissions.additionalDirectories` エントリを見つけましたが、[プロジェクト設定からの allow ルールはワークスペース信頼が必要](/ja/permissions#project-allow-rules-and-workspace-trust)であるため、それらを適用しませんでした。メッセージに表示されるカウント、設定名、ファイル名は、設定によって異なります。`deny` ルールと `ask` ルールは影響を受けません。

```text theme={null}
Ignoring 2 permissions.allow entries from .claude/settings.local.json: this workspace has not been trusted. Run Claude Code interactively here once and accept the trust dialog, or set projects["/Users/you/project"].hasTrustDialogAccepted: true in /Users/you/.claude.json.
```

**対応方法：**

* ディレクトリで `claude` を実行し、信頼ダイアログを受け入れます。{/* min-version: 2.1.200 */}親ディレクトリが既に信頼されている場合でも、ダイアログが表示され、保留中のルールが一覧表示され、それらなしで作業を続けることを拒否できます。v2.1.200 より前では、その状況ではダイアログが表示されなかったため、そこではこのステップを完了できませんでした。
* [非対話型モード](/ja/headless)で `-p` を使用する場合、ダイアログは表示されません。メッセージが出力する正確な `projects` キーを使用して、`~/.claude.json` の `hasTrustDialogAccepted` エントリを設定します。
* {/* min-version: 2.1.200 */}メッセージが `.claude/settings.local.json` という名前で、git リポジトリの外またはホームディレクトリで Claude Code を起動した場合は、v2.1.200 以降に更新してください。バージョン 2.1.196 から 2.1.199 では、これらのワークスペースで独自の `.claude/settings.local.json` をリポジトリ提供として扱いました。[プロジェクト allow ルールとワークスペース信頼](/ja/permissions#project-allow-rules-and-workspace-trust)を参照してください。

<h2 id="responses-seem-lower-quality-than-usual">
  応答の品質がいつもより低いように見える
</h2>

Claude の回答がいつもより能力が低いように見えるが、エラーが表示されていない場合、原因は通常、モデル自体ではなく会話の状態です。Claude Code はモデルバージョンを静かに変更することはありません。3 つの特定のケースでフォールバックモデルに切り替わることができます。

* 設定された [`--fallback-model`](/ja/cli-reference#cli-flags) は可用性エラーの後、そのターンのみ引き継ぎ、トランスクリプトに通知が表示されます
* Amazon Bedrock または Google Cloud の Agent Platform スタートアップチェックがデフォルトモデルが利用不可であることを検出します
* [自動モデルフォールバック](/ja/model-config#automatic-model-fallback) は Fable 5 でセッションをデフォルトの Opus モデルに移動し、トランスクリプトに通知を表示します

以下のモデル選択チェックは 2 番目と 3 番目のケースをキャッチします。最初のケースは `/model` の変更ではなくトランスクリプト通知として表示されます。[モデル設定](/ja/model-config) は各フォールバックが適用される時期を説明しています。

まずこれらを確認してください。

* **モデル選択**: `/model` を実行して、期待するモデルにいることを確認します。以前の `/model` の選択または `ANTHROPIC_MODEL` 環境変数により、意図したより小さいモデルにいる可能性があります。
* **努力レベル**: `/effort` を実行して現在の推論レベルを確認し、難しいデバッグまたは設計作業のためにそれを上げます。デフォルトはモデルによって異なるため、最大値以下であると仮定する前に確認してください。[努力レベルを調整](/ja/model-config#adjust-effort-level) でモデルごとのデフォルトと `ultrathink` ショートカットを参照してください。
* **コンテキスト圧力**: `/context` を実行してウィンドウがどの程度満杯かを確認します。容量に近い場合は、自然な区切り点で `/compact` を実行するか、新しく開始するために `/clear` を実行します。[コンテキストウィンドウを探索](/ja/context-window) で自動コンパクトが以前のターンにどのように影響するかを参照してください。
* **古い指示**: 大きいまたは古い `CLAUDE.md` ファイルと MCP ツール定義はコンテキストを消費し、応答を操作できます。{/* min-version: 2.1.205 */}`/doctor` チェックアップは過度に大きいメモリファイルと未使用の拡張機能にフラグを立て、`/context` は MCP ツールトークン使用量を表示します。v2.1.205 より前では、`/doctor` は過度に大きいメモリファイルとサブエージェント定義にフラグを立てた診断画面を開きました。

応答がうまくいかない場合、修正で返信するよりも通常は巻き戻しの方がうまく機能します。Esc を 2 回押すか `/rewind` を実行して悪いターンの前に戻り、より具体的なプロンプトで言い換えます。スレッド内で修正すると、間違った試みがコンテキストに残り、後の回答をそれに固定する可能性があります。[チェックポイント](/ja/checkpointing) を参照してください。

上記を確認した後も品質がまだおかしいように見える場合は、`/feedback` を実行して、期待したものと得たものを説明してください。この方法で送信されたフィードバックには会話トランスクリプトが含まれており、Anthropic が実際の回帰を診断する最速の方法です。環境で `/feedback` が利用できない場合は、[エラーを報告](#report-an-error) を参照してください。

{/* min-version: 2.1.201 */}Sonnet 5 がリクエストを拒否し、Claude Code v2.1.200 以前で疑わしいプロンプトインジェクションを引用する場合は、`claude update` を実行して v2.1.201 修正を取得します。

<h2 id="report-an-error">
  エラーを報告する
</h2>

このページでカバーされていないコンポーネントからのエラーについては、関連するガイドを参照してください。

* MCP サーバーが接続またはアテンティケーションに失敗した場合：[MCP](/ja/mcp)
* フック スクリプトが失敗したか、ツールをブロックした場合：[フックのデバッグ](/ja/hooks#debug-hooks)
* インストール中にパーミッション拒否またはファイルシステム エラーが発生した場合：[インストールとログインのトラブルシューティング](/ja/troubleshoot-install)

ここにエラーが記載されていない場合、または提案された修正が役に立たない場合：

* Claude Code 内で `/feedback` を実行して、トランスクリプトと説明を Anthropic に送信します。このコマンドは、事前入力された GitHub issue を開くオプションも提供します。Amazon Bedrock、Google Cloud の Agent Platform、Microsoft Foundry、およびその他のサードパーティ プロバイダーでは、`/feedback` はローカル アーカイブを保存し、Anthropic アカウント担当者に送信できます。
* シェルから `claude doctor` を実行して、インストールの読み取り専用診断を実行するか、Claude Code 内で `/doctor` チェックアップを実行してセットアップの問題を検出して修正します。
* [status.claude.com](https://status.claude.com) で有効なインシデントを確認します。
* GitHub の[既存の issue](https://github.com/anthropics/claude-code/issues) を検索します。
