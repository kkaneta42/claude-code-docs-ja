> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# エラーリファレンス

> Claude Code のランタイムエラーメッセージを検索し、各エラーの意味と修正方法を確認できます。

このページでは、Claude Code が表示するランタイムエラーと各エラーからの復旧方法、および応答がエラーなしで異常に見える場合に確認すべき内容を一覧表示しています。セットアップ中の `command not found` や TLS エラーなどのインストールエラーについては、[トラブルシューティング](/ja/troubleshooting)を参照してください。

これらのエラーと復旧コマンドは、CLI、[デスクトップアプリ](/ja/desktop)、および[ウェブ上の Claude Code](/ja/claude-code-on-the-web)全体に適用されます。これら 3 つはすべて同じ Claude Code CLI をラップしているためです。サーフェス固有の問題については、そのサーフェスのページのトラブルシューティングセクションを参照してください。

<Note>
  Claude Code は、モデルレスポンスについて Claude API を呼び出すため、ほとんどのランタイムエラーは基盤となる API エラーコードにマップされます。このページでは、Claude Code 内での各エラーの意味と復旧方法について説明しています。生の HTTP ステータスコード定義については、[Claude Platform エラーリファレンス](https://platform.claude.com/docs/en/api/errors)を参照してください。
</Note>

## エラーを検索する

ターミナルに表示されるメッセージを以下のセクションと照合してください。

| メッセージ                                                                                | セクション                                                                                         |
| :----------------------------------------------------------------------------------- | :-------------------------------------------------------------------------------------------- |
| `API Error: 500 ... Internal server error`                                           | [サーバーエラー](#api-error-500-internal-server-error)                                               |
| `API Error: Repeated 529 Overloaded errors`                                          | [サーバーエラー](#api-error-repeated-529-overloaded-errors)                                          |
| `Request timed out`                                                                  | [サーバーエラー](#request-timed-out)、またはメッセージがインターネット接続に言及している場合は[ネットワーク](#unable-to-connect-to-api) |
| `<model> is temporarily unavailable, so auto mode cannot determine the safety of...` | [サーバーエラー](#auto-mode-cannot-determine-the-safety-of-an-action)                                |
| `You've hit your session limit` / `You've hit your weekly limit`                     | [使用制限](#youve-hit-your-session-limit)                                                         |
| `Server is temporarily limiting requests`                                            | [使用制限](#server-is-temporarily-limiting-requests)                                              |
| `Request rejected (429)`                                                             | [使用制限](#request-rejected-429)                                                                 |
| `Credit balance is too low`                                                          | [使用制限](#credit-balance-is-too-low)                                                            |
| `Not logged in · Please run /login`                                                  | [認証](#not-logged-in)                                                                          |
| `Invalid API key`                                                                    | [認証](#invalid-api-key)                                                                        |
| `This organization has been disabled`                                                | [認証](#this-organization-has-been-disabled)                                                    |
| `OAuth token revoked` / `OAuth token has expired`                                    | [認証](#oauth-token-revoked-or-expired)                                                         |
| `does not meet scope requirement user:profile`                                       | [認証](#oauth-scope-requirement)                                                                |
| `Unable to connect to API`                                                           | [ネットワーク](#unable-to-connect-to-api)                                                           |
| `SSL certificate verification failed`                                                | [ネットワーク](#ssl-certificate-errors)                                                             |
| `Prompt is too long`                                                                 | [リクエストエラー](#prompt-is-too-long)                                                               |
| `Error during compaction: Conversation too long`                                     | [リクエストエラー](#error-during-compaction-conversation-too-long)                                    |
| `Request too large`                                                                  | [リクエストエラー](#request-too-large)                                                                |
| `Image was too large`                                                                | [リクエストエラー](#image-was-too-large)                                                              |
| `PDF too large` / `PDF is password protected`                                        | [リクエストエラー](#pdf-errors)                                                                       |
| `Extra inputs are not permitted`                                                     | [リクエストエラー](#extra-inputs-are-not-permitted)                                                   |
| `There's an issue with the selected model`                                           | [リクエストエラー](#theres-an-issue-with-the-selected-model)                                          |
| `Claude Opus is not available with the Claude Pro plan`                              | [リクエストエラー](#claude-opus-is-not-available-with-the-claude-pro-plan)                            |
| `thinking.type.enabled is not supported for this model`                              | [リクエストエラー](#thinking-type-enabled-is-not-supported-for-this-model)                            |
| `max_tokens must be greater than thinking.budget_tokens`                             | [リクエストエラー](#thinking-budget-exceeds-output-limit)                                             |
| `API Error: 400 due to tool use concurrency issues`                                  | [リクエストエラー](#tool-use-or-thinking-block-mismatch)                                              |
| レスポンスの品質が通常より低いように見える                                                                | [レスポンス品質](#responses-seem-lower-quality-than-usual)                                           |

## 自動リトライ

Claude Code は、エラーを表示する前に一時的な障害をリトライします。サーバーエラー、オーバーロードレスポンス、リクエストタイムアウト、一時的な 429 スロットル、および接続の切断はすべて、指数バックオフで最大 10 回リトライされます。リトライ中、スピナーは `Retrying in Ns · attempt x/y` カウントダウンを表示します。

このページのエラーの 1 つが表示されている場合、これらのリトライはすでに使い果たされています。2 つの環境変数で動作をチューニングできます。

| 変数                                        | デフォルト  | 効果                                                    |
| :---------------------------------------- | :----- | :---------------------------------------------------- |
| [`CLAUDE_CODE_MAX_RETRIES`](/ja/env-vars) | 10     | リトライ試行回数。スクリプトで障害をより速く表示するには低くし、より長いインシデントを待つには高くします。 |
| [`API_TIMEOUT_MS`](/ja/env-vars)          | 600000 | リクエストごとのタイムアウト（ミリ秒単位）。遅いネットワークまたはプロキシの場合は高くします。       |

## サーバーエラー

これらのエラーは、アカウントまたはリクエストではなく、Anthropic インフラストラクチャから発生します。

### API Error: 500 Internal server error

Claude Code は、5xx ステータスの生の API レスポンスボディを表示します。以下の例は 500 レスポンスを示しています。

```text theme={null}
API Error: 500 {"type":"error","error":{"type":"api_error","message":"Internal server error"}} · check status.claude.com
```

これは API 内の予期しない障害を示しています。プロンプト、設定、またはアカウントが原因ではありません。

**対応方法：**

* [status.claude.com](https://status.claude.com)でアクティブなインシデントを確認してください
* 1 分待ってからメッセージを再度送信してください。元のメッセージはまだ会話に残っているため、長いプロンプトの場合は全体を貼り付ける代わりに `try again` と入力できます。
* エラーが投稿されたインシデントなしで続く場合は、`/feedback` を実行して、Anthropic がリクエスト詳細で調査できるようにしてください。プロバイダーで `/feedback` が利用できない場合は、[エラーを報告する](#report-an-error)を参照してください。

### API Error: Repeated 529 Overloaded errors

API は、すべてのユーザー全体で一時的に容量に達しています。Claude Code は、このメッセージを表示する前に既に数回リトライしています。

```text theme={null}
API Error: Repeated 529 Overloaded errors · check status.claude.com
```

529 は使用制限ではなく、クォータに対してカウントされません。

**対応方法：**

* [status.claude.com](https://status.claude.com)で容量に関する通知を確認してください
* 数分後に再度試してください
* `/model` を実行して別のモデルに切り替えて、容量がモデルごとに追跡されるため、作業を続けてください。Claude Code は、1 つのモデルが特に高い負荷を受けている場合、たとえば `Opus is experiencing high load, please use /model to switch to Sonnet` のようにこれを行うようにプロンプトを表示します。

### Request timed out

API は接続期限前に応答しませんでした。

```text theme={null}
Request timed out
```

これは、高負荷期間中または非常に大きなレスポンスが生成されている場合に発生する可能性があります。デフォルトのリクエストタイムアウトは 10 分です。

**対応方法：**

* リクエストを再試行してください
* 長時間実行されるタスクの場合は、作業をより小さいプロンプトに分割してください
* 遅いネットワークまたはプロキシが原因の場合は、[自動リトライ](#automatic-retries)で説明されているように `API_TIMEOUT_MS` を上げてください
* タイムアウトが頻繁で、ネットワークが正常な場合は、以下の[ネットワークと接続エラー](#network-and-connection-errors)を参照してください

### Auto mode cannot determine the safety of an action

[auto mode](/ja/permission-modes#eliminate-prompts-with-auto-mode)がアクションを分類するために使用するモデルがオーバーロードされているため、auto mode はそれをチェックなしで承認する代わりにアクションをブロックしました。

```text theme={null}
<model> is temporarily unavailable, so auto mode cannot determine the safety of <tool> right now. Wait briefly and then try this action again.
```

読み取り、検索、および作業ディレクトリ内の編集は分類器をスキップするため、停止中も機能し続けます。

**対応方法：**

* 数秒後に再試行してください。Claude は同じメッセージを見て、通常は自動的に再試行します
* リトライが失敗し続ける場合は、読み取り専用タスクを続行し、後でブロックされたアクションに戻ってください
* これは一時的であり、[auto mode 適格性](/ja/permission-modes#eliminate-prompts-with-auto-mode)とは無関係です。設定を変更する必要はありません

## 使用制限

これらのエラーは、アカウントまたはプランに関連するクォータに達したことを意味します。これらは、すべてに影響する[サーバーエラー](#server-errors)とは異なります。

### You've hit your session limit

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
* `/extra-usage` を実行して、Pro および Max で追加使用量を購入するか、Team および Enterprise で管理者にリクエストしてください。[有料プランの追加使用量](https://support.claude.com/en/articles/12429409-extra-usage-for-paid-claude-plans)を参照して、これがどのように請求されるかを確認してください。
* プランをアップグレードしてより高いベース制限を取得するには、[claude.com/pricing](https://claude.com/pricing)を参照してください

制限に達する前に残りの許容量を監視するには、`rate_limits` フィールドを[カスタムステータスライン](/ja/statusline#rate-limit-usage)に追加するか、デスクトップアプリでモデルピッカーの横にある[使用量リング](/ja/desktop#check-usage)をクリックしてください。

### Server is temporarily limiting requests

API は、プランクォータとは無関係の短期的なスロットルを適用しました。

```text theme={null}
API Error: Server is temporarily limiting requests (not your usage limit)
```

これは、表示される前に[自動的にリトライ](#automatic-retries)されます。

**対応方法：**

* 少し待ってから再度試してください
* 続く場合は [status.claude.com](https://status.claude.com)を確認してください

### Request rejected (429)

API キー、Amazon Bedrock プロジェクト、または Google Vertex AI プロジェクト用に設定されたレート制限に達しました。

```text theme={null}
API Error: Request rejected (429) · this may be a temporary capacity issue
```

**対応方法：**

* `/status` を実行して、アクティブな認証情報が予想されるものであることを確認してください。環境内の迷走した `ANTHROPIC_API_KEY` は、サブスクリプションではなく低層キーを通じてリクエストをルーティングできます。
* プロバイダーコンソールでアクティブな制限を確認し、必要に応じてより高い層をリクエストしてください
* Anthropic API キーについては、[レート制限リファレンス](https://platform.claude.com/docs/en/api/rate-limits)を参照して、層がどのように機能し、ワークスペースごとのキャップを設定する方法を確認してください
* 同時実行性を削減します。[`CLAUDE_CODE_MAX_TOOL_USE_CONCURRENCY`](/ja/env-vars)を低くするか、多くの並列サブエージェントの実行を避けるか、高ボリュームのスクリプト実行用に `/model` で小さいモデルに切り替えてください

### Credit balance is too low

Console 組織は、プリペイドクレジットを使い果たしました。

```text theme={null}
Credit balance is too low
```

**対応方法：**

* [platform.claude.com/settings/billing](https://platform.claude.com/settings/billing)でクレジットを追加し、そこで自動リロードを有効にして、残高がゼロに達する前に補充されるようにすることを検討してください
* Pro、Max、Team、または Enterprise プランがある場合は、`/login` でサブスクリプション認証に切り替えてください
* Console でワークスペースごとの支出キャップを設定して、単一のプロジェクトが組織の残高を枯渇させるのを防いでください。[コストを効果的に管理する](/ja/costs)を参照してください。

## 認証エラー

これらのエラーは、Claude Code が API に対して身元を証明できないことを意味します。いつでも `/status` を実行して、現在アクティブな認証情報を確認してください。

### Not logged in

このセッションで有効な認証情報は利用できません。

```text theme={null}
Not logged in · Please run /login
```

**対応方法：**

* `/login` を実行して、Claude サブスクリプションまたは Console アカウントで認証してください
* 環境変数で認証されることを期待していた場合は、`ANTHROPIC_API_KEY` が設定され、`claude` を起動したシェルでエクスポートされていることを確認してください
* インタラクティブログインが不可能な CI または自動化の場合は、起動時にキーをフェッチする[`apiKeyHelper`](/ja/settings#available-settings)スクリプトを設定してください
* [認証の優先順位](/ja/authentication#authentication-precedence)を参照して、複数の認証情報が存在する場合にどの認証情報が優先されるかを理解してください

ログインを繰り返しプロンプトされている場合は、[ログインしていないまたはトークンの有効期限が切れている](/ja/troubleshooting#not-logged-in-or-token-expired)を参照して、システムクロックと macOS キーチェーンの修正を確認してください。

### Invalid API key

`ANTHROPIC_API_KEY` 環境変数または `apiKeyHelper` スクリプトが、API が拒否したキーを返しました。

```text theme={null}
Invalid API key · Fix external API key
```

**対応方法：**

* タイプミスを確認し、キーが [Console](https://platform.claude.com/settings/keys)で取り消されていないことを確認してください
* 同じシェルで `env | grep ANTHROPIC` を実行してください。direnv、dotenv シェルプラグイン、IDE ターミナルなどのツールは、明示的に設定せずにプロジェクト内の `.env` ファイルから古いキーをロードできます。
* `ANTHROPIC_API_KEY` をアンセットして `/login` を実行し、代わりにサブスクリプション認証を使用してください
* キーが[`apiKeyHelper`](/ja/settings#available-settings)スクリプトから来ている場合は、スクリプトを直接実行して、stdout に有効なキーを出力することを確認してください
* `/status` を実行して、Claude Code が実際に使用している認証情報ソースを確認してください

### This organization has been disabled

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

### OAuth token revoked or expired

保存されたログインは有効ではなくなりました。取り消されたトークンは、どこかでサインアウトしたか、管理者がアクセスを削除したことを意味します。期限切れのトークンは、自動リフレッシュがセッション中に失敗したことを意味します。

```text theme={null}
OAuth token revoked · Please run /login
OAuth token has expired · Please run /login
API Error: 401 ... authentication_error
```

**対応方法：**

* `/login` を実行して再度サインインしてください
* 再認証後、同じセッション内でエラーが返される場合は、最初に `/logout` を実行して保存されたトークンを完全にクリアしてから、`/login` を実行してください
* 起動全体でログインを繰り返しプロンプトされている場合は、[トラブルシューティング](/ja/troubleshooting#not-logged-in-or-token-expired)のシステムクロックと macOS キーチェーンチェックを参照してください
* `403 Forbidden` や OAuth ブラウザの問題を含む他の障害については、[権限と認証](/ja/troubleshooting#permissions-and-authentication)を参照してください

### OAuth scope requirement

保存されたトークンは、新しい機能が必要とする権限スコープより前のものです。これは、`/usage` とステータスラインの使用量インジケーターから最も頻繁に表示されます。

```text theme={null}
OAuth token does not meet scope requirement: user:profile
```

**対応方法：**

* `/login` を実行して、現在のスコープで新しいトークンを作成してください。ログアウトする必要はありません。

## ネットワークと接続エラー

これらのエラーは、Claude Code が API に到達できなかったことを意味します。これらはほぼ常に、Anthropic インフラストラクチャではなく、ローカルネットワーク、プロキシ、またはファイアウォールから発生します。

### Unable to connect to API

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
* LLM ゲートウェイまたはリレーを通じてルーティングする場合は、[`ANTHROPIC_BASE_URL`](/ja/env-vars)をそのアドレスに設定してください。セットアップについては、[LLM ゲートウェイ設定](/ja/llm-gateway)を参照してください。
* ファイアウォールが[ネットワークアクセス要件](/ja/network-config#network-access-requirements)に記載されているホストを許可していることを確認してください
* 一時的な障害は[自動的にリトライ](#automatic-retries)されます。永続的な障害はローカルネットワークの問題を指しています

`curl` は成功しても Claude Code が失敗する場合、原因は通常、ネットワーク自体ではなく Node.js とネットワークの間にあります。

* Linux および WSL では、`/etc/resolv.conf` で到達不可能なネームサーバーを確認してください。特に WSL はホストから壊れたリゾルバーを継承できます。
* macOS では、切断または削除された VPN クライアントがトンネルインターフェースまたはルーティングルールを残す可能性があります。`ifconfig` で古い `utun` インターフェースを確認し、システム設定で VPN のネットワーク拡張を削除してください。
* Docker Desktop および同様のコンテナランタイムは、アウトバウンドトラフィックをインターセプトできます。それらを終了して再試行し、これを除外してください。

### SSL certificate errors

ネットワーク上のプロキシまたはセキュリティアプライアンスが、独自の証明書で TLS トラフィックをインターセプトしており、Node.js がそれを信頼していません。

```text theme={null}
Unable to connect to API: SSL certificate verification failed. Check your proxy or corporate SSL certificates
Unable to connect to API: Self-signed certificate detected
```

**対応方法：**

* 組織の CA バンドルをエクスポートし、`NODE_EXTRA_CA_CERTS=/path/to/ca-bundle.pem` で Node をポイントしてください
* 完全なセットアップ手順については、[ネットワーク設定](/ja/network-config#custom-ca-certificates)を参照してください
* 証明書検証を完全に無効にする `NODE_TLS_REJECT_UNAUTHORIZED=0` を設定しないでください

## リクエストエラー

これらのエラーは、API がリクエストを受け取ったが、その内容を拒否したことを意味します。

### Prompt is too long

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

### Error during compaction: Conversation too long

`/compact` 自体が失敗しました。これは、生成される要約を保持するのに十分な空きコンテキストがないためです。

```text theme={null}
Error during compaction: Conversation too long. Press esc twice to go up a few messages and try again.
```

これは、ウィンドウが自動コンパクトがトリガーされる時点で既に満杯の場合、または `Prompt is too long` を見た後に `/compact` を実行する場合に発生する可能性があります。

**対応方法：**

* Esc を 2 回押してメッセージリストを開き、数ターン戻ってください。これにより、最新のメッセージがコンテキストから削除されます。その後、`/compact` を再度実行してください。
* 戻ることで十分なスペースが解放されない場合は、`/clear` を実行して新しいセッションを開始してください。以前の会話は保存され、`/resume` で再度開くことができます。

### Request too large

生のリクエストボディが、トークン化前に API のバイト制限を超えました。通常、大きく貼り付けられたファイルまたは添付ファイルが原因です。

```text theme={null}
Request too large (max 30 MB). Double press esc to go back and remove or shrink the attached content.
```

これは、[コンテキストウィンドウ制限](#prompt-is-too-long)とは別の HTTP リクエストのサイズ制限です。

**対応方法：**

* Esc を 2 回押して、サイズを超えたコンテンツを追加したターンを過ぎて戻ってください
* 大きなファイルをパスで参照して、内容を貼り付けるのではなく、Claude がチャンク単位で読み取ることができるようにしてください
* 画像については、以下の[画像が大きすぎました](#image-was-too-large)を参照してください

### Image was too large

貼り付けられた、または添付された画像が API のサイズまたは寸法制限を超えています。

```text theme={null}
Image was too large. Double press esc to go back and try again with a smaller image.
API Error: 400 ... image dimensions exceed max allowed size
```

画像はエラー後も会話履歴に残るため、削除するまで後続のすべてのメッセージは同じエラーで失敗します。

**対応方法：**

* Esc を 2 回押して、画像が追加されたターンを過ぎて戻ってください
* 貼り付ける前に画像をリサイズしてください。API は、単一の画像の場合は最長辺で最大 8000 ピクセル、またはコンテキストに多くの画像がある場合は 2000 ピクセルの画像を受け入れます。
* 全画面ではなく、関連する領域のより厳密なスクリーンショットを撮ってください

### PDF errors

添付した PDF を処理できませんでした。

```text theme={null}
PDF too large (max 100 pages, 32 MB). Try splitting it or extracting text first.
PDF is password protected. Try removing protection or extracting text first.
The PDF file was not valid. Try converting to a different format first.
```

**対応方法：**

* サイズの大きい PDF の場合は、ファイル全体を添付する代わりに Read ツールでページ範囲を読み取るよう Claude に依頼するか、`pdftotext` などのツールでテキストを抽出し、パスでファイルを参照してください
* 保護されたまたは無効な PDF の場合は、パスワードを削除するか、ソースアプリケーションからファイルを再度エクスポートしてから、再度試してください

### Extra inputs are not permitted

Claude Code と API の間のプロキシまたは LLM ゲートウェイが `anthropic-beta` リクエストヘッダーをストリップしたため、API はそれに依存するフィールドを拒否しました。

```text theme={null}
API Error: 400 ... Extra inputs are not permitted ... context_management
API Error: 400 ... Extra inputs are not permitted ... tools.0.custom.input_examples
API Error: 400 ... Unexpected value(s) for the `anthropic-beta` header
```

Claude Code は、`context_management`、`effort`、ツール `input_examples` などのベータのみのフィールドを、それらを有効にする `anthropic-beta` ヘッダーと共に送信します。ゲートウェイがボディを転送しますがヘッダーをドロップすると、API は認識しないフィールドを見ます。

**対応方法：**

* `anthropic-beta` ヘッダーを転送するようにゲートウェイを設定してください。[LLM ゲートウェイ設定](/ja/llm-gateway)を参照してください。
* フォールバックとして、起動前に[`CLAUDE_CODE_DISABLE_EXPERIMENTAL_BETAS=1`](/ja/env-vars)を設定してください。これにより、ベータヘッダーが必要な機能が無効になり、リクエストはそれを転送できないゲートウェイを通じて成功します。

### There's an issue with the selected model

設定されたモデル名が認識されなかったか、アカウントがそれへのアクセスを持っていません。

```text theme={null}
There's an issue with the selected model (claude-...). It may not exist or you may not have access to it. Run /model to select a different one.
```

**対応方法：**

* `/model` を実行して、アカウントで利用可能なモデルから選択してください
* 完全なバージョン ID ではなく、`sonnet` や `opus` などのエイリアスを使用してください。エイリアスは最新リリースを追跡するため、古くなりません。[モデル設定](/ja/model-config)を参照してください。
* [モデルが見つからない](/ja/troubleshooting#model-not-found-or-not-accessible)を参照して、`--model`、`ANTHROPIC_MODEL`、および設定ファイル全体で古い ID がどこに設定されているかを確認してください

### Claude Opus is not available with the Claude Pro plan

アクティブなサブスクリプションプランには、選択したモデルが含まれていません。

```text theme={null}
Claude Opus is not available with the Claude Pro plan · Select a different model in /model
```

**対応方法：**

* `/model` を実行して、プランに含まれるモデルを選択してください
* 最近プランをアップグレードしてもこれが表示される場合は、`/logout` を実行してから `/login` を実行してください。保存されたトークンはサインイン時のプランを反映しているため、ウェブでアップグレードしても既存のセッションで有効になるまで再認証する必要があります。
* [claude.com/pricing](https://claude.com/pricing)を参照して、各プランに含まれるモデルを確認してください

### thinking.type.enabled is not supported for this model

Claude Code バージョンが Opus 4.7 の最小値より古いです。CLI は、モデルが受け入れなくなった思考設定を送信しました。

```text theme={null}
API Error: 400 ... "thinking.type.enabled" is not supported for this model. Use "thinking.type.adaptive" and "output_config.effort" to control thinking behavior.
```

**対応方法：**

* `claude update` を実行して v2.1.111 以降にアップグレードしてから、Claude Code を再起動してください
* アップグレードできない場合は、`/model` を実行して Opus 4.6 または Sonnet を選択してください
* Agent SDK でこれに遭遇した場合は、[SDK トラブルシューティング](/ja/agent-sdk/quickstart#troubleshooting)を参照してください

### Thinking budget exceeds output limit

設定された拡張思考予算が最大レスポンス長を超えているため、実際の回答用のスペースが残っていません。

```text theme={null}
API Error: 400 ... max_tokens must be greater than thinking.budget_tokens
```

Claude Code は Anthropic API でこれらの値を自動的に調整します。通常、Amazon Bedrock または Google Vertex AI でこのエラーが表示されるのは、[`MAX_THINKING_TOKENS`](/ja/env-vars)がプロバイダーの出力制限より高く設定されている場合、またはプランモードが思考予算を上げる場合です。

**対応方法：**

* `MAX_THINKING_TOKENS` を低くするか、[`CLAUDE_CODE_MAX_OUTPUT_TOKENS`](/ja/env-vars)を思考予算より上に上げてください
* [拡張思考](/ja/common-workflows#use-extended-thinking-thinking-mode)を参照して、予算が出力長とどのように相互作用するかを確認してください

### Tool use or thinking block mismatch

会話履歴が矛盾した状態で API に到達しました。通常、ツール呼び出しが中断されたか、ターンがストリーム中に編集された後です。

```text theme={null}
API Error: 400 due to tool use concurrency issues. Run /rewind to recover the conversation.
API Error: 400 ... unexpected `tool_use_id` found in `tool_result` blocks
API Error: 400 ... thinking blocks ... cannot be modified
```

3 つのバリアントはすべて同じことを意味します。履歴内の `tool_use`、`tool_result`、および `thinking` ブロックのシーケンスが、API が期待するものと一致しなくなりました。

**対応方法：**

* `/rewind` を実行するか、Esc を 2 回押して、破損したターンの前のチェックポイントに戻り、そこから続行してください。[チェックポイント](/ja/checkpointing)を参照して、チェックポイントがどのように作成および復元されるかを確認してください。

## Responses seem lower quality than usual

Claude の回答がエラーなしで予想より能力が低いように見える場合、原因は通常、モデル自体ではなく会話状態です。Claude Code はモデルバージョンを静かに変更しません。Opus クォータに達した場合や Bedrock または Vertex AI リージョンがモデルを欠いている場合など、特定の場合にはフォールバックモデルに切り替えることができます。以下のモデル選択チェックはその両方をキャッチし、[モデル設定](/ja/model-config)はフォールバックが適用される場合を説明しています。

最初にこれらを確認してください。

* **モデル選択**：`/model` を実行して、予想されるモデルにいることを確認してください。以前の `/model` 選択または `ANTHROPIC_MODEL` 環境変数により、意図したより小さいモデルにいる可能性があります。
* **努力レベル**：`/effort` を実行して、現在の推論レベルを確認し、難しいデバッグまたは設計作業のためにそれを上げてください。デフォルトはモデルによって異なるため、最大値より下にあると仮定する前に確認してください。[努力レベルを調整する](/ja/model-config#adjust-effort-level)を参照して、モデルごとのデフォルトと `ultrathink` ショートカットを確認してください。
* **コンテキスト圧力**：`/context` を実行して、ウィンドウがどの程度満杯かを確認してください。容量に近い場合は、自然な区切り点で `/compact` を実行するか、`/clear` を実行して新しく開始してください。[コンテキストウィンドウを探索する](/ja/context-window)を参照して、自動コンパクトが以前のターンにどのように影響するかを確認してください。
* **古い指示**：大きなまたは古い `CLAUDE.md` ファイルと MCP ツール定義はコンテキストを消費し、レスポンスを操作できます。`/doctor` は大きなメモリファイルとサブエージェント定義にフラグを立てます。`/context` は MCP ツールトークン使用量を表示します。

レスポンスが間違っている場合、修正で返信するより、巻き戻しの方が通常うまくいきます。Esc を 2 回押すか、`/rewind` を実行して悪いターンの前に戻り、より詳細なプロンプトで言い換えてください。スレッド内で修正すると、間違った試みがコンテキストに残り、後の回答をそれに固定できます。[チェックポイント](/ja/checkpointing)を参照してください。

上記を確認した後も品質が異常に見える場合は、`/feedback` を実行して、期待したものと得たものを説明してください。このように送信されたフィードバックには会話トランスクリプトが含まれており、Anthropic が実際の回帰を診断する最速の方法です。プロバイダーで `/feedback` が利用できない場合は、[エラーを報告する](#report-an-error)を参照してください。

## Report an error

このページでは Claude API からのエラーについて説明しています。Claude Code の他のコンポーネントからのエラーについては、関連するガイドを参照してください。

* MCP サーバーが接続または認証に失敗しました：[MCP](/ja/mcp)
* フックスクリプトが失敗したか、ツールをブロックしました：[フックをデバッグする](/ja/hooks#debug-hooks)
* インストール中に権限が拒否されたか、ファイルシステムエラーが発生しました：[トラブルシューティング](/ja/troubleshooting)

エラーがここに記載されていない場合、または提案された修正が役に立たない場合：

* Claude Code 内で `/feedback` を実行して、トランスクリプトと説明を Anthropic に送信してください。コマンドは、事前入力された GitHub イシューを開くことも提供します。フィードバックは Bedrock、Vertex AI、および Foundry デプロイメントでは利用できません。
* `/doctor` を実行してローカル設定の問題を確認してください
* [status.claude.com](https://status.claude.com)でアクティブなインシデントを確認してください
* GitHub の[既存のイシュー](https://github.com/anthropics/claude-code/issues)を検索してください
