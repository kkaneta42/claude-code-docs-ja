> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# auto モード分類器リクエスト料金

> Claude Code の通知「このセッションは auto モードの無料分類器リクエストの対象ではありません」を解決する：その意味、表示される理由、対処方法。

[Auto mode](/docs/ja/permission-modes#eliminate-prompts-with-auto-mode) では、分類器がシェルコマンドやネットワークリクエストなどのアクションをチェックしてから実行します。[サーバー側チェックが有効な場合](/docs/ja/permission-modes#server-side-classifier-review)、サーバーはセッション自体のモデルリクエストの一部としてこれらのチェックを実行し、料金は請求されません。この通知は、サーバーのチェックがセッションに到達していないことを意味するため、Claude Code は代わりに独自の分類器リクエストを作成しており、アカウントではこれらのリクエストはトークン使用量にカウントされます：

```text theme={null}
We're changing auto mode to no longer charge for classifier requests in Claude Code. However, this session isn't eligible.
```

プロンプトで、Claude Code はこのようにチェックする最初のアクションを保留し、回答を待ちます。auto モードは引き続き動作し、その分類器リクエストは以前と同じように課金されます。

最も一般的な原因は Claude Code と API の間の LLM ゲートウェイまたはプロキシであり、Claude Code がそれを識別できる場合、通知はそれに名前を付けます。**Enter** キーを押して続行するか、[セッションを対象にする](#make-the-session-eligible)を参照して、新しいセッションに表示されないようにしてください。

## ダイアログに応答する

ダイアログはあなたが答えるまでアクションを保留します：

* **Enter** で続行：保留されたアクションとセッションの残りの部分は Claude Code 独自の分類器リクエストを使用し、以前と同じようにトークン使用量として課金され、そのセッション内ではダイアログが再度表示されません。ダイアログがゲートウェイに名前を付けた場合、それを確認することで、このマシンで 24 時間再表示されなくなります。そうでない場合、ダイアログはセッションがフォールバックするたびに戻ります。
* **Esc** または **Ctrl+C** でキャンセル：保留されたアクションは実行されず、現在のターンが停止し、セッションは自動モードのままになります。何も記憶されないため、次のチェック済みアクションの前にダイアログが再度表示されます。

代わりに自動モードの使用を停止するには、答えた後に `Shift+Tab` で権限モードを切り替えてください。

ダイアログが答えを待つことができない場合、Claude Code は同じテキストを報告し、セッションは自動モードで続行されます。ただし、このマシンでの過去 24 時間以内のゲートウェイ確認がそれを却下している場合を除きます。[非対話型モード](/docs/ja/headless)で `-p` を使用する場合、テキストは stderr に出力され、`stream-json` 出力では `system` 警告メッセージが発行されます。これは Agent SDK アプリケーションがメッセージストリームから読み取ることができます。

## セッションを対応可能にする

ゲートウェイが原因の場合、会社の管理者またはゲートウェイプロバイダーに、リクエストと返信を変更せずに通すよう依頼してください。つまり、ゲートウェイが認識しない `safeguards` リクエストフィールドなどのリクエストヘッダーとボディフィールドをそのまま転送し、`safeguard_results` フィールドなどのキーをドロップしたり、tool-use ID を書き換えたりせずにレスポンスとストリーミングイベントを返すことです。[ゲートウェイ互換性ガイド](/docs/ja/llm-gateway-protocol#feature-pass-through)で説明されているとおりです。このようにトラフィックを通すゲートウェイは、この機能と将来の機能で動作し続けます。その後、新しいセッションはサーバーのチェックを再度使用します。

ゲートウェイがサーバーのチェックを提供できないことが既にわかっている場合、セッションを開始する前に、シェルまたは [`env` 設定キー](/docs/ja/settings-reference#env)で `CLAUDE_CODE_AUTO_MODE_SERVER` を `0` に設定して、Claude Code にそこでチェックを要求しないよう指示してください。

```bash theme={null}
export CLAUDE_CODE_AUTO_MODE_SERVER=0
```

分類器リクエストはその後、常に Claude Code 独自のものであり、同じ方法で課金され、通知は表示されません。Anthropic API への直接接続では、変数は Claude Code v2.1.281 以降が必要です。`CLAUDE_CODE_AUTO_MODE_SERVER` が設定されていない状態で `CLAUDE_CODE_DISABLE_EXPERIMENTAL_BETAS=1` を設定すると、[プリリリース機能を無効にする](/docs/ja/llm-gateway-protocol#disable-pre-release-capabilities)で説明されている場合を除き、サーバーのチェックもオフになります。

`CLAUDE_CODE_AUTO_MODE_SERVER` は一時的な設定であり、後のリリースで削除される可能性があります。

## ダイアログが表示される理由

[サーバー側分類器レビュー](/docs/ja/permission-modes#server-side-classifier-review)は、サーバーに分類器チェックをリクエストするセッションを一覧表示します。Pro、Max、Team プランではダイアログが表示されることはありません。ダイアログが表示される場合、通常の原因は以下の通りです：

* **LLM ゲートウェイまたはプロキシがパスに存在する**：リクエストヘッダーを削除または書き換える、認識しないリクエストフィールドを削除する、またはレスポンスを編集するもの。その場合、サーバーはチェックのリクエストを受け取らないか、Claude Code はレスポンスを受け取りません。設定またはレスポンスがゲートウェイを特定する場合、ダイアログはそれに名前を付けます。
* **サーバー側チェックがまだプラットフォーム、リージョン、または認証情報に到達していない**：プラットフォームまたはリージョンがチェックを実行するかどうかは、そのプラットフォームのロールアウトに依存します。ダイアログが表示され、パスにゲートウェイまたはプロキシがなく、ダイアログが表示され続ける場合、これが原因である可能性が高いです。確認するには、サポートまたは会社の管理者に連絡するか、`/feedback` で報告してください。

auto mode のセッションをチェックするには、Claude Code プロンプトで `/status` を実行します。その **Auto mode server** 行は、サーバーのチェックがセッションのアクションを決定している間は `Enabled` と表示され、セッションがフォールバックした後は `Disabled` と表示されます。

ゲートウェイがレスポンスを短縮したり、Claude Code が読み取れない形式にレスポンスを書き換えたりする場合、このダイアログの代わりに判定がない拒否が表示されます。[サーバー側分類器レビュー](/docs/ja/permission-modes#server-side-classifier-review)を参照してください。

## 関連リソース

* [Auto モード](/docs/ja/permission-modes#eliminate-prompts-with-auto-mode)：Auto モードとは何か、およびデフォルトでブロックされるもの
* [サーバー側分類器レビュー](/docs/ja/permission-modes#server-side-classifier-review)：どのセッションがサーバーにアクションをチェックするよう要求するか、および各セッションに必要な Claude Code バージョン
* [ゲートウェイ互換性ガイド](/docs/ja/llm-gateway-protocol#feature-pass-through)：ゲートウェイがヘッダーまたはボディフィールドを削除した場合に何が破損するか
* [サーバーが安全性判定を返さなかった](/docs/ja/errors#the-server-returned-no-safety-verdict)：サーバーがアクションに対して判定を与えない場合に表示される拒否
* [コストを効果的に管理する](/docs/ja/costs)：トークン使用量を追跡し、Claude Code コストを削減する
