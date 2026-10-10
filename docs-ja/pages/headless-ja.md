> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# Claude Code をプログラムで実行する

> Agent SDK を使用して、CLI、Python、または TypeScript からプログラムで Claude Code を実行します。

[Agent SDK](/docs/ja/agent-sdk/overview) は、Claude Code を支える同じツール、エージェントループ、およびコンテキスト管理を提供します。スクリプトと CI/CD 用の CLI として、または完全なプログラムによる制御のための [Python](/docs/ja/agent-sdk/python) および [TypeScript](/docs/ja/agent-sdk/typescript) パッケージとして利用できます。

Claude Code を非対話型モードで実行するには、プロンプトと任意の [CLI オプション](/docs/ja/cli-reference) を指定して `-p` を渡します。

```bash theme={null}
claude -p "Find and fix the bug in auth.py" --allowedTools "Read,Edit,Bash"
```

このページでは、CLI（`claude -p`）経由で Agent SDK を使用することについて説明しています。構造化された出力、ツール承認コールバック、およびネイティブメッセージオブジェクトを備えた Python および TypeScript SDK パッケージについては、[完全な Agent SDK ドキュメント](/docs/ja/agent-sdk/overview) を参照してください。

<h2 id="basic-usage">
  基本的な使用方法
</h2>

任意の `claude` コマンドに `-p` （または `--print` ）フラグを追加して、非対話的に実行します。すべての [CLI オプション](/docs/ja/cli-reference) が `-p` と組み合わせられるわけではありません。Claude Code は `--bg` を拒否し、タスク説明付きの `--cloud` を拒否します。競合を示すエラーが表示されます。セッション ID 付きの `--cloud` と `-p` は代わりに [そのクラウドセッションにメッセージをキューイングして終了します](/docs/ja/claude-code-on-the-web#send-follow-ups-from-the-cli)。`-p` と組み合わせることが多いオプションには以下が含まれます。

* `--continue` は [会話を続行する](#continue-conversations) ため
* `--allowedTools` は [ツールを自動承認する](#auto-approve-tools) ため
* `--output-format` は [構造化された出力を取得する](#get-structured-output) ため

この例は、コードベースについて Claude に質問し、応答を出力します。

```bash theme={null}
claude -p "What does the auth module do?"
```

Claude Code は成功時にコード 0 で終了し、実行が失敗した場合は 0 以外のコードで終了するため、スクリプトは終了ステータスで分岐できます。無効なフラグを渡すと、Claude Code は実行開始前にエラーを stderr に報告します。実行内で認証の欠落など障害が発生した場合、Claude Code は障害を stdout の結果として出力します。

<h3 id="start-faster-with-bare-mode">
  bare モードで高速に開始する
</h3>

`--bare` を追加して、フック、スキル、カスタムコマンド、[サブエージェント](/docs/ja/sub-agents)、インストール済みプラグイン、MCP サーバー、自動メモリ、CLAUDE.md の自動検出をスキップすることで、起動時間を短縮します。これがない場合、`claude -p` は対話的セッションと同じ [コンテキスト](/docs/ja/how-claude-code-works#the-context-window) を読み込みます。これには、作業ディレクトリまたは `~/.claude` で設定されたすべてが含まれます。

bare モードは、すべてのマシンで同じ結果が必要な CI とスクリプトに役立ちます。チームメイトの `~/.claude` のフック、またはプロジェクトの `.mcp.json` の MCP サーバーは実行されません。bare モードはそれらを読み込まないためです。`--add-dir` で指定するディレクトリは部分的な例外です。bare モードはその `.claude/skills/` フォルダからスキルを読み込みますが、その `.claude/commands/` と `.claude/agents/` フォルダはスキップします。[追加ディレクトリからのスキル](/docs/ja/skills#skills-from-additional-directories) は、何が読み込まれ、何が読み込まれないかについて説明しています。

`--bare` がない場合、`-p` セッションはプロジェクトの `.claude/settings.json` のフックを実行し、その `.mcp.json` のサーバーに接続します。これは、信頼したことのないフォルダでも同様です。`-p` セッションはワークスペース信頼ダイアログもサーバーごとの承認プロンプトも表示しません。[フォルダを信頼する前に実行されるもの](/docs/ja/permissions#what-runs-before-you-trust-a-folder) は、`-p` の下での各種リポジトリコンテンツと、それを除外する方法について説明しています。

この例は、bare モードで 1 回限りの要約タスクを実行し、Read ツールを事前承認して、権限プロンプトなしで呼び出しが完了するようにします。bare モードはサブスクリプションログインを使用しないため、実行前に `ANTHROPIC_API_KEY` を設定してください。

```bash theme={null}
claude --bare -p "Summarize README.md" --allowedTools "Read"
```

bare モードでは、Claude Code は OAuth 認証情報またはシステムキーチェーンを読み込みません。Anthropic API の場合、環境で `ANTHROPIC_API_KEY` を設定します。[Claude Console](https://platform.claude.com) で作成されたキーを使用するか、`--settings` JSON で `apiKeyHelper` を指定します。Amazon Bedrock、Google Cloud の Agent Platform、Microsoft Foundry は、通常どおり独自のプロバイダー認証情報を読み込み続けます。

bare モードでは、Claude は Bash、ファイル読み取り、ファイル編集ツールにアクセスできます。フラグで必要なコンテキストを渡します。

| 読み込むもの | 使用 |
| - | - |
| システムプロンプト追加 | `--append-system-prompt`、`--append-system-prompt-file` |
| 設定 | `--settings <file-or-json>` |
| MCP サーバー | `--mcp-config <file-or-json>` |
| [カスタムエージェント](/docs/ja/sub-agents#choose-the-subagent-scope) | `--agents <file-or-json>` |
| プラグイン | `--plugin-dir <path>`、`--plugin-url <url>` |

bare モードでは、セッションの実行中に行われる処理も制限されます。

* **MCP サーバー**: コマンドラインで指定されたサーバー（例えば `--mcp-config` で指定したもの）のみが接続されます。対話型セッションでは、`--ide` を渡さない限り、Claude Code は IDE への自動接続もスキップします。
* **システムリマインダー**: Claude はプロンプトとツールの結果を受け取りますが、Claude Code が通常それらと一緒に追加する [システムリマインダー](/docs/ja/glossary#system-reminder) は含まれません。例えば、以前に読み取ったファイルがディスク上で変更されても Claude には通知されず、`--add-dir` フォルダのスキルを含む利用可能なスキルの一覧も Claude には渡されません。
* **バックグラウンドタスク**: 実行されません。[タイムアウト](/docs/ja/tools-reference#timeout-and-output-limits) に達したコマンドは、[バックグラウンドに移行する](/docs/ja/tools-reference#background-commands) 代わりに停止します。

v2.1.286 より前は、これらの制限は部分的にしか適用されていませんでした。対話型の `--bare` セッションは通常のセッションと同じ MCP サーバーに接続し、すべての `--bare` セッションがシステムリマインダーを送信し、バックグラウンドタスクも引き続き利用可能でした。

<Note>
  `--bare` はスクリプト化および SDK 呼び出しの推奨モードであり、将来のリリースで `-p` のデフォルトになります。
</Note>

<h3 id="background-tasks-at-exit">
  終了時のバックグラウンドタスク
</h3>

Claude がターンを終え、stdin が閉じられた後も、`claude -p` の実行は Claude が開始したバックグラウンド作業を待つために開いたままになることがあります。

メイン会話が開始したバックグラウンドコマンドがまだ実行中でない限り、Claude Code はデフォルトで 10 分間の継続的なアイドル待機後に実行中のすべてを停止し、その部分的な結果を破棄します。10 分の上限を変更するには、[`CLAUDE_CODE_PRINT_BG_WAIT_CEILING_MS`](/docs/ja/env-vars) を設定するか、`0` に設定して上限なしで待機します。

実行は、バックグラウンドコマンド、サブエージェントとワークフロー、Monitor ウォッチ、保留中の `/loop` ウェイクアップなどのバックグラウンド作業を待機します。

* **[バックグラウンドコマンド](/docs/ja/tools-reference#background-commands)**: メイン会話が開始したコマンド（例えば開発サーバーやウォッチビルド）の場合、実行はコマンドが終了するか [時間制限](/docs/ja/tools-reference#time-limit-for-background-commands) に達するまで待機します。その後、Claude はその結果を受けてもう 1 ターン実行します。コマンドの実行中は、10 分の上限によって待機が終了することはありません。
* **バックグラウンドの [サブエージェント](/docs/ja/sub-agents) とワークフロー**: その結果は最終出力の一部であるため、実行はその作業が完了するまで開いたままになります。
* **[Monitor](/docs/ja/tools-reference#monitor-tool) ウォッチ**: 実行は、ウォッチがタイムアウトするか 10 分の上限が待機を終了するか、どちらか先に来た方まで待機します。待機中、Claude はウォッチが報告することに応答し続けます。デフォルトでは、ウォッチは Claude が開始してから 5 分後にタイムアウトします。
* **保留中のウェイクアップ**: プロンプトを `--input-format stream-json` ではなくテキストとして渡した実行で、Claude が [自己ペースの `/loop` ウェイクアップ](/docs/ja/scheduled-tasks#let-claude-choose-the-interval) をスケジュールした場合、実行は各ウェイクアップが発生するのを待ち、[ループが終了する](/docs/ja/scheduled-tasks#stop-a-loop) までその反復を実行します。これは 10 分の上限を超えても続きます。

stderr がターミナルで、実行が 5 秒間待機した場合、Claude Code は `Waiting for background work to finish` で始まり、待機中の作業を示す行を stderr に出力します。[`json` または `stream-json` 出力](#get-structured-output) では、この行は stdout がターミナルでない場合にのみ出力されるため、スクリプトが読み取る JSON にこの行が含まれることはありません。

実行が [`--max-budget-usd`](/docs/ja/cli-reference#cli-flags) の上限に達した場合、Claude Code は待機せずに残りのバックグラウンド作業を停止します。

バックグラウンド作業によって別のターンが開始された場合、デフォルトの `text` 出力では各ターンの結果が出力され、`json` 出力では最後のターンの結果が出力されます。v2.1.295 より前は、`text` 出力でも最後のターンの結果のみが出力されていました。

<h3 id="stop-a-run-with-sigterm">
  SIGTERM で実行を停止する
</h3>

`claude -p` 実行を SIGTERM で停止した場合（例えば、`kill` またはプロセススーパーバイザーから）、Claude Code はコード 143 で終了します。Claude Code は進行中のターンを未完了のままにし、そのための結果を記録しません。ターンを終了するには、SIGINT を送信するか、Agent SDK の `interrupt()` を呼び出してから、プロセスを停止します。

SIGTERM では、Claude Code はまだ実行中の Bash コマンドのプロセスツリーを終了します。Claude Code は [`SessionEnd` フック](/docs/ja/hooks#sessionend) を実行して終了します。終了中、Claude Code は新しいツール呼び出しを開始せず、新しいモデルリクエストを送信せず、`SessionEnd` 以外のフックを実行しません。シグナルを受け取ったときに実行がコマンドの途中にあった場合、または権限プロンプトへの回答を待機していた場合、Claude Code はそのステップを次のように処理します。

* **コマンドを実行中**: Claude Code はコマンドをセッションで強制終了として記録します。
* **権限プロンプトへの回答を待機中**: SIGTERM をプロセスに送信した場合、Claude Code はプロンプトを未回答のままにします。プログラムが Agent SDK を通じてセッションを閉じた場合、SDK はシグナルを送信する前に Claude Code の入力を終了し、Claude Code は入力が終了するとすぐにプロンプトをキャンセルします。

[セッションを再開](#continue-conversations) すると、Claude Code は中断されたターンをそのままにし、次のプロンプトが会話を駆動します。再開時に Claude Code が中断されたターンを続行するようにするには、[`CLAUDE_CODE_RESUME_INTERRUPTED_TURN=1`](/docs/ja/env-vars) を設定します。

<h3 id="if-the-working-directory-is-deleted">
  作業ディレクトリが削除された場合
</h3>

`claude -p` または Agent SDK セッションの作業ディレクトリがセッション中に削除された場合、セッションは実行を続けます。ディレクトリが見つからない間にターンが開始されると、Claude Code は `stream-json` 出力で [警告メッセージ](/docs/ja/agent-sdk/typescript#sdkinformationalmessage) を発行し、ディレクトリが再度存在するまでシェルコマンドは失敗します。

<h2 id="examples">
  例
</h2>

これらの例は、一般的な CLI パターンを紹介しています。`auth.py` や `build-error.txt` などのファイルを指定するコマンドの場合は、自分のプロジェクトのファイルに置き換えてください。CI やその他のスクリプト環境では、[`--bare`](#start-faster-with-bare-mode) を追加して、Claude Code がホストのフック、プラグイン、自動メモリ、または `CLAUDE.md` を読み込まずに起動するようにしてください。

<h3 id="pipe-data-through-claude">
  Claude にデータをパイプする
</h3>

非対話モードは stdin を読み込むため、他のコマンドラインツールと同様にデータをパイプで渡し、応答をリダイレクトできます。

この例は、ビルドログを Claude にパイプして、説明をファイルに書き込みます。

```bash theme={null}
cat build-error.txt | claude -p 'concisely explain the root cause of this build error' > output.txt
```

`--output-format json` を使用すると、応答ペイロードに `total_cost_usd` とモデルごとのコスト内訳が含まれるため、スクリプトの呼び出し元は [使用状況ダッシュボード](/docs/ja/costs) を参照せずに支出を追跡できます。`--continue` または `--resume` で以前の会話を続ける場合、実行は[以前の実行の支出を含めた](/docs/ja/agent-sdk/cost-tracking#accumulate-costs-across-multiple-calls)会話全体の合計を報告します。どちらの数値も[クライアント側の推定値](/docs/ja/agent-sdk/cost-tracking)であり、実際の請求額と異なる場合があります。

<Note>
  パイプされた stdin は 10MB に制限されています。制限を超えた場合、Claude Code は明確なエラーを表示して終了し、ゼロ以外のステータスを返します。より大きな入力を処理するには、コンテンツをファイルに書き込み、パイプする代わりにプロンプトでファイルパスを参照してください。
</Note>

Claude Code が stdin を読み込めない場合（例えば、Claude Code を起動したプロセスが自分側の接続を切断した場合）、Claude Code は stderr に警告を出力し、コマンドラインから渡されたプロンプトで続行します。v2.1.211 より前では、Windows で stdin を読み込めないとセッションがクラッシュするか、出力なしで静かに終了していました。

<h3 id="add-claude-to-a-build-script">
  ビルドスクリプトに Claude を追加する
</h3>

非対話呼び出しをスクリプトでラップして、Claude をプロジェクト固有のリンターまたはレビュアーとして使用できます。

この `package.json` スクリプトは `main` に対する差分を Claude にパイプし、タイプミスを報告するよう指示します。差分をパイプすることで、Claude はそれを読むための Bash 権限を必要とせず、エスケープされたダブルクォートによってスクリプトを Windows でも使用できます。

```json theme={null}
{
  "scripts": {
    "lint:claude": "git diff main | claude -p \"you are a typo linter. for each typo in this diff, report filename:line on one line and the issue on the next. return nothing else.\""
  }
}
```

`npm run lint:claude` で実行します。

<h3 id="get-structured-output">
  構造化された出力を取得する
</h3>

`--output-format` を使用して、応答の返され方を制御します。

* `text`（デフォルト）：プレーンテキスト出力
* `json`：結果、セッション ID、メタデータを含む構造化 JSON
* `stream-json`：リアルタイムストリーミング用の改行区切り JSON

この例は、プロジェクト概要をセッションメタデータ付きの JSON で返し、テキスト結果は `result` フィールドに入ります。

```bash theme={null}
claude -p "Summarize this project" --output-format json
```

特定のスキーマに準拠した出力を取得するには、`--output-format json` を `--json-schema` と [JSON Schema](https://json-schema.org/) 定義と共に使用します。応答には、リクエストに関するメタデータ（セッション ID、使用状況など）が含まれ、構造化出力は `structured_output` フィールドに入ります。

この例は、関数名を抽出して文字列の配列として返します。

```bash theme={null}
claude -p "Extract the main function names from auth.py" \
  --output-format json \
  --json-schema '{"type":"object","properties":{"functions":{"type":"array","items":{"type":"string"}}},"required":["functions"]}'
```

値が有効な JSON Schema でない場合、`claude` は `Error: --json-schema is not a valid JSON Schema` とそれに続くバリデータの診断を出力して終了します。Claude Code は `format` キーワード（例：`"format": "email"`）を使用するスキーマを受け入れますが、`format` を注釈として扱い、強制はしません。v2.1.205 より前では、Claude Code は無効なスキーマを静かに無視して非構造化テキストを返し、`format` を含むスキーマをすべて無効として扱っていました。

<Tip>
  [jq](https://jqlang.org/) などのツールを使用して応答を解析し、特定のフィールドを抽出します。

  ```bash theme={null}
  # Extract the text result
  claude -p "Summarize this project" --output-format json | jq -r '.result'

  # Extract structured output
  claude -p "Extract function names from auth.py" \
    --output-format json \
    --json-schema '{"type":"object","properties":{"functions":{"type":"array","items":{"type":"string"}}},"required":["functions"]}' \
    | jq '.structured_output'
  ```
</Tip>

<h3 id="stream-responses">
  応答をストリーミングする
</h3>

`--output-format stream-json` を `--verbose` および `--include-partial-messages` と共に使用すると、生成されたトークンを順次受け取れます。各行は、イベントを表す JSON オブジェクトです。

```bash theme={null}
claude -p "Explain recursion" --output-format stream-json --verbose --include-partial-messages
```

ストリームの最後の行は、最終応答テキスト、コスト、セッションメタデータを含む `result` メッセージです。

コンシューマーがストリームをゆっくり読む場合、Claude Code はキューに入った出力が排出されるまで待機してから終了します。待機時間はまだキューに残っている量に応じて伸び、上限は 30 秒です。v2.1.214 より前では、終了時の待機の上限は約 2 秒であり、大きな応答の末尾が切り捨てられる可能性がありました。

次の例は [jq](https://jqlang.org/) を使用してテキストデルタをフィルタリングし、ストリーミングテキストのみを表示します。`-r` フラグは生の文字列（引用符なし）を出力し、`-j` は改行なしで結合するため、トークンが途切れなくストリーミングされます。

```bash theme={null}
claude -p "Write a poem" --output-format stream-json --verbose --include-partial-messages | \
  jq -rj 'select(.type == "stream_event" and .event.delta.type? == "text_delta") | .event.delta.text'
```

コールバックとメッセージオブジェクトを使用したプログラムによるストリーミングについては、Agent SDK ドキュメントの[リアルタイムで応答をストリーミングする](/docs/ja/agent-sdk/streaming-output)を参照してください。

<h4 id="follow-subagent-messages">
  サブエージェントのメッセージを追跡する
</h4>

[サブエージェント](/docs/ja/sub-agents)からのメッセージと、[サブエージェントで実行される](/docs/ja/skills#run-skills-in-a-subagent)スキルからのメッセージは、ストリームに `assistant` および `user` メッセージとして表示されます。その `parent_tool_use_id` フィールドは、各メッセージがどの実行に属するかを示します。メインの会話からのメッセージは、このフィールドに `null` を持ちます。

フォークされたスキル、または[フォアグラウンド](/docs/ja/sub-agents#run-subagents-in-foreground-or-background)で実行されているサブエージェントからの最初のメッセージは、その実行を駆動するプロンプトまたはスキルコンテンツを含む `user` メッセージです。その最初のメッセージの後、Claude Code は以下を発行します。

* **デフォルト**：その実行の `tool_use` および `tool_result` ブロック。
* **[`--forward-subagent-text`](/docs/ja/cli-reference#cli-flags) または [`CLAUDE_CODE_FORWARD_SUBAGENT_TEXT`](/docs/ja/env-vars) を使用した場合**：その実行のテキストブロックと思考ブロックも発行されるため、各実行のトランスクリプトを再構築できます。

いずれかのオプションを有効にすると、Claude Code は[あらゆるネストの深さのサブエージェント](/docs/ja/sub-agents#let-subagents-spawn-their-own-subagents)からのメッセージを、Agent ツールで生成されたものかフォークされたスキルとして開始されたものかに関わらず転送します。`parent_tool_use_id` では、ネストされたサブエージェントのメッセージはそれを開始した Agent または Skill ツール呼び出しの ID を持つため、これらの ID をたどることで完全なネストツリーを再構築できます。

Claude がツール呼び出しで開始した実行は、そのツール呼び出しの ID を持ちます。`/<skill-name>` をプロンプトとして渡して開始したフォークされたスキルにはツール呼び出しがないため、そのメッセージは代わりに `forked-command-` で始まる値を持ち、スキルの完了後に届きます。実行の開始方法は最初の列で確認してください。

| 実行の開始方法 | `parent_tool_use_id` | メッセージが届くタイミング |
| :- | :- | :- |
| Claude がメインの会話から Agent ツールを呼び出す | その Agent `tool_use` ブロックの ID | サブエージェントの作業中 |
| Claude がメインの会話からフォークされたスキルの Skill ツールを呼び出す | その Skill `tool_use` ブロックの ID | フォークされたスキルの作業中 |
| `/<skill-name>` をプロンプトとして渡す | `forked-command-` で始まる値 | フォークされたスキルの完了後に、まとめて順番に |

プロンプトから開始したフォークされたスキルについては、`parent_tool_use_id` を `forked-command-` プレフィックスで照合してください。プレフィックスの後に続く名前は、入力した名前と異なる場合があるためです。

これらのメッセージの一部がストリームに含まれていない場合は、Claude Code のバージョンを次の最小要件と照らし合わせて確認してください。

* **`--forward-subagent-text` と `CLAUDE_CODE_FORWARD_SUBAGENT_TEXT`**：v2.1.211 以降
* **あらゆるネストの深さでの転送**：v2.1.219 以降
* **Claude がメインの会話から Skill ツールで開始するフォークされたスキル**：`tool_use` および `tool_result` ブロックには v2.1.86 以降、最初の `user` メッセージとテキストブロックおよび思考ブロックには v2.1.265 以降
* **フォークされたスキルが生成するサブエージェントのメッセージ、およびサブエージェントや別のフォークされたスキルの中で開始されたフォークされたスキルのメッセージ**：v2.1.275 以降
* **`/<skill-name>` をプロンプトとして渡して開始したフォークされたスキルのメッセージ**：v2.1.287 以降

<h4 id="handle-api-retries">
  API の再試行を処理する
</h4>

API リクエストが再試行可能なエラーで失敗すると、Claude Code は再試行する前に `system/api_retry` イベントを発行します。v2.1.246 以降では、`401` または `403` によって [`apiKeyHelper`](/docs/ja/settings-reference#apikeyhelper) の認証情報が拒否された場合、Claude Code は最初の 2 回の再試行をイベントなしで静かに行い、3 回目の連続した再試行以降は通常どおりイベントを発行します。静かな再試行も `attempt` にカウントされます。このイベントを使用して、独自のインターフェースで再試行の進行状況を表示できます。

| フィールド | 型 | 説明 |
| - | - | - |
| `type` | `"system"` | メッセージタイプ |
| `subtype` | `"api_retry"` | これを再試行イベントとして識別 |
| `attempt` | integer | 現在の試行番号（1 から開始） |
| `max_retries` | integer | この失敗の原因に対して許可される再試行の合計 |
| `retry_delay_ms` | integer | 次の試行までのミリ秒 |
| `error_status` | integer または null | 失敗した試行の HTTP ステータスコード、または試行が API から HTTP レスポンスを受け取らなかった場合は `null` |
| `no_response` | object、optional | 失敗した試行が[時間内にレスポンスヘッダーを受け取らなかった](/docs/ja/errors#no-response-from-api)場合にのみ存在します。`waited_ms` はその試行が待機した時間で、`retry_wait_ms` は再試行が待機する時間です。Claude Code v2.1.261 以降が必要です |
| `error` | string | エラーカテゴリ：`authentication_failed`、`oauth_org_not_allowed`、`account_on_hold`、`billing_error`、`rate_limit`、`overloaded`、`invalid_request`、`model_not_found`、`server_error`、`max_output_tokens`、`cloud_credential_error`、または `unknown` |
| `uuid` | string | 一意のイベント識別子 |
| `session_id` | string | イベントが属するセッション |

<h4 id="read-session-metadata">
  セッションメタデータを読む
</h4>

`system/init` イベントは、モデル、ツール、MCP サーバー、読み込まれたプラグインを含むセッションメタデータを報告します。起動時のイベントが先行しない限り、ストリームの最初のイベントです。

* `plugin_install` イベント（[`CLAUDE_CODE_SYNC_PLUGIN_INSTALL`](/docs/ja/env-vars) が設定されている場合）。
* [`hook_started`、`hook_progress`、および `hook_response` イベント](/docs/ja/agent-sdk/typescript#sdkhookstartedmessage)（設定された [`SessionStart`](/docs/ja/hooks#sessionstart) または [`Setup`](/docs/ja/hooks#setup) フックが実行されている間）。これらはフックが生成するたびにストリーミングされます。Claude Code v2.1.169 から v2.1.203 では、フックの完了後に 1 つのバッチで配信されていました（それでも `system/init` より前）。v2.1.204 でライブ配信が復元されました。

このイベントには、この Claude Code バージョンが実装しているプロトコル動作を示す文字列の optional な `capabilities` 配列も含まれます（例：`interrupt_receipt_v1` や `interrupt_cancel_queued_v1`）。バージョン文字列を比較する代わりにこれを確認して機能を検出し、認識しない値は無視してください。このフィールドには Claude Code v2.1.205 以降が必要で、それより前のバージョンでは存在しません。機能の一覧については [`SDKSystemMessage`](/docs/ja/agent-sdk/typescript#sdksystemmessage) を参照してください。

<h4 id="fail-ci-when-a-plugin-or-mcp-server-doesn’t-load">
  プラグインまたは MCP サーバーが読み込まれない場合に CI を失敗させる
</h4>

`system/init` イベントのプラグインフィールドを使用して、読み込まれなかったプラグインを検出します。

| フィールド | 型 | 説明 |
| - | - | - |
| `plugins` | array | 正常に読み込まれたプラグイン（各々 `name` と `path` を含む） |
| `plugin_errors` | array | プラグイン読み込み時のエラー（各々 `plugin`、`type`、`message` を含む）。満たされていない依存関係のバージョンや、`--plugin-dir` の読み込み失敗（パスが存在しない、アーカイブが無効など）を含みます。読み込まれなかったプラグインは `plugins` に含まれません。エラーがない場合、キーは省略されます |

`--plugin-dir` のディレクトリまたはアーカイブ自体の読み込みに失敗した場合、その `plugin_errors` エントリには解決された絶対パスが `path` として含まれます。複数の `--plugin-dir` 値のうちどれが失敗したかを判断するために使用します。`path` フィールドには Claude Code v2.1.283 以降が必要です。

MCP サーバーのフィールドも同じ方法で使用します。`-p` で [`--mcp-config`](/docs/ja/cli-reference#cli-flags) を渡すと、Claude Code は最初のターンを実行する前に、まだ保留中のサーバーを [`MCP_TIMEOUT`](/docs/ja/env-vars) の起動タイムアウト（デフォルトは 30 秒）まで待機します。[キャッシュされたツールリスト](/docs/ja/agent-sdk/mcp#connection-timing)を持つリモートサーバーは待機をスキップし、`system/init` に `pending` と表示され、最初のツール呼び出し時に接続します。[セルフホスト環境](/docs/ja/self-hosted-environments-configuration#connection-timing)では、代わりにより短い待機が適用されます。この待機には Claude Code v2.1.221 以降が必要です。

Claude Code は起動時に各 `--mcp-config` エントリを検証し、検証に失敗したエントリ（例えば、`type` のない `url` エントリ）をスキップします。実行は続行されて正常に終了するため、これらのフィールドを確認して、読み込まれなかったサーバーを検出します。

| フィールド | 型 | 説明 |
| - | - | - |
| `mcp_servers` | array | セッション内の MCP サーバー（各々 `name` と `status` を含む） |
| `mcp_server_errors` | array | 設定の検証によってスキップされた `--mcp-config` エントリ（各々 `name`、`type`、`message` を含む）。`type` はスキップカテゴリ（`unknown_type`、`url_missing_type`、`invalid_config`、`reserved_name` など）です。認識しない値は汎用的なスキップとして扱ってください。該当するサーバーは `mcp_servers` に含まれません。エラーがない場合、キーは省略されるため、CI ゲートは配列が空でない場合に失敗させることができます。Claude Code v2.1.219 以降が必要です |

ターミナルでコマンドを手動で実行する場合、Claude Code は stderr に起動時の警告（例：`Warning: 1 MCP server skipped due to invalid config:`）も出力し、その後にスキップされた各エントリの理由が続きます。stderr をリダイレクトする場合、または CI ランナーや SDK ホストなどのプログラムがそれをキャプチャする場合、Claude Code は警告を出力せず、スキップされたエントリを `mcp_server_errors` フィールドでのみ報告します。この警告には Claude Code v2.1.219 以降が必要です。

<h4 id="track-plugin-installs">
  プラグインのインストールを追跡する
</h4>

[`CLAUDE_CODE_SYNC_PLUGIN_INSTALL`](/docs/ja/env-vars) が設定されている場合、Claude Code は最初のターンの前にマーケットプレイスのプラグインをインストールしている間、`system/plugin_install` イベントを発行します。これらを使用して、独自の UI にインストールの進行状況を表示します。

| フィールド | 型 | 説明 |
| - | - | - |
| `type` | `"system"` | メッセージタイプ |
| `subtype` | `"plugin_install"` | これをプラグインインストールイベントとして識別 |
| `status` | `"started"`、`"installed"`、`"failed"`、または `"completed"` | `started` と `completed` はインストール全体の開始と終了を示します。`installed` と `failed` は個々のマーケットプレイスについて報告します |
| `name` | string、optional | マーケットプレイス名（`installed` と `failed` に存在） |
| `error` | string、optional | 失敗メッセージ（`failed` に存在） |
| `uuid` | string | 一意のイベント識別子 |
| `session_id` | string | イベントが属するセッション |

<h3 id="auto-approve-tools">
  ツールを自動承認する
</h3>

`--allowedTools` を使用して、Claude が特定のツールを確認なしで使用できるようにします。`Read` と `Edit` を指定すると、Claude は権限を求めずにファイルを読み取り、編集できます。`Bash` を指定すると、シェルコマンドについても同様になります。ただし、[auto モード](/docs/ja/permission-modes#how-auto-mode-evaluates-actions)で開始される実行では、Claude Code は単独の `Bash` エントリを広すぎる許可ルールとして除外し、代わりに auto モードが各コマンドを評価します。この例は、これら 3 つのツールを指定してテストスイートを実行し、失敗を修正します。

```bash theme={null}
claude -p "Run the test suite and fix any failures" \
  --allowedTools "Bash,Read,Edit"
```

個別のツールを指定する代わりにセッション全体のベースラインを設定するには、[権限モード](/docs/ja/permission-modes)を渡します。何も権限モードを設定しない実行は、[組み込みの開始時の権限モード](/docs/ja/permission-modes#which-mode-a-session-starts-in)になり、これは `auto` の場合があるため、使用したいモードを渡してください。

* **`auto`**：`--permission-mode auto` を渡すと、ユーザーに代わって分類器がほとんどのアクションをレビューします
* **`dontAsk`**：Claude Code は、本来なら確認を求めるすべての呼び出しを拒否します。これは制限された CI 実行に役立ちます。Manual モードで承認が不要なアクション（作業ディレクトリでのファイル読み取りや[読み取り専用コマンドセット](/docs/ja/permissions#read-only-commands)など）は引き続き実行され、`--allowedTools` エントリまたは `permissions.allow` ルールがカバーするアクションも実行されます。`AskUserQuestion`、[組織が `ask` に設定したコネクタツール](/docs/ja/mcp#organization-controls-on-connector-tools)、および [`requiresUserInteraction`](/docs/ja/mcp#require-approval-for-a-specific-tool) とマークされた MCP ツールは、許可ルールが一致する場合でも拒否されます
* **`acceptEdits`**：Claude は確認なしでファイルを書き込み、Claude Code は `mkdir`、`touch`、`mv`、`cp` などの一般的なファイルシステムコマンドを自動承認します。[どのモードでも自動承認されないアクション](/docs/ja/permission-modes#actions-no-mode-auto-approves)は引き続き適用されます。読み取り専用コマンドセットを除き、その他のシェルコマンドとネットワークリクエストには引き続き `--allowedTools` エントリまたは `permissions.allow` ルールが必要です。完全なリストについては [`acceptEdits` が自動承認する内容](/docs/ja/permission-modes#auto-approve-file-edits-with-acceptedits-mode)を参照してください

この例は `acceptEdits` をベースラインとしてリント修正を適用します。

```bash theme={null}
claude -p "Apply the lint fixes" --permission-mode acceptEdits
```

<h3 id="turn-off-permission-prompts-in-unattended-runs">
  無人実行で権限プロンプトをオフにする
</h3>

権限プロンプトに答えられる人がいない場合（例えば、スケジュール済みジョブ）は、`--permission-prompts none` を渡します。このフラグが最も重要になるのは、実行に権限ホストがある場合です。権限ホストとは、[`canUseTool` コールバック](/docs/ja/agent-sdk/user-input)を持つ Agent SDK アプリ、または [`--permission-prompt-tool`](/docs/ja/cli-reference#cli-flags) で渡す MCP ツールです。フラグがない場合、実行は各権限リクエストに対してそのホストが答えるのを待ちます。

フラグを指定すると、実行はホストに問い合わせず、待機もしません。確認を求めることになるものはすべて、`PermissionRequest` フックが許可しない限り拒否され、Claude には誰もリクエストを承認できないため再試行しないよう伝えられ、実行は続行されます。ホストのない `-p` 実行では、これらのリクエストはいずれにしても拒否されますが、このフラグは Claude に再試行しないよう伝える役割も果たします。権限ルール、[`PermissionRequest` フック](/docs/ja/hooks#permissionrequest)、および設定した権限モードが引き続き最初にすべての呼び出しを判定し、Claude Code は他の何によっても解決されないリクエストのみを拒否します。

この例は [auto モード](/docs/ja/permission-modes#eliminate-prompts-with-auto-mode)で無人タスクを実行します。分類器は通常どおり各アクションをレビューし、Claude Code はプロンプトにフォールバックするはずだったものをすべて拒否します。

```bash theme={null}
claude -p "Update the dependency pins and run the tests" --permission-mode auto --permission-prompts none
```

`--permission-prompts none` を使用すると、Claude Code は [`AskUserQuestion`](/docs/ja/tools-reference#askuserquestion-tool-behavior) など人の回答を必要とするツールを削除するため、Claude はそれらを呼び出せません。[`Elicitation` フック](/docs/ja/hooks#elicitation)が応答しない [MCP エリシテーションリクエスト](/docs/ja/mcp#respond-to-mcp-elicitation-requests)はキャンセルされます。

`--output-format stream-json` を使用すると、拒否は `permission_denied` システムメッセージとして表示され、最終結果メッセージの `permission_denials` にそれらが一覧表示されます。

<Note>
  `--permission-prompts` フラグには Claude Code v2.1.259 以降が必要です。それより前のバージョンでは、不明なオプションのエラーで拒否されます。
</Note>

<h3 id="create-a-commit">
  コミットを作成する
</h3>

この例はステージされた変更をレビューして、適切なメッセージでコミットを作成します。

```bash theme={null}
claude -p "Look at my staged changes and create an appropriate commit" \
  --allowedTools "Bash(git diff *),Bash(git log *),Bash(git status *),Bash(git commit *)"
```

`--allowedTools` フラグは[権限ルールの構文](/docs/ja/settings-reference#permission-rule-syntax)を使用します。末尾の ` *` はプレフィックスマッチングを有効にするため、`Bash(git diff *)` は `git diff` で始まるすべてのコマンドを許可します。`*` の前のスペースは重要です。スペースがないと、`Bash(git diff*)` は `git diff-index` にも一致します。

<Note>
  `-p` モードでは、コマンドのサポート状況が異なります。

  * ユーザーが呼び出す[スキル](/docs/ja/skills)とカスタムコマンドは機能します。プロンプト文字列に `/skill-name` を含めると、Claude Code は実行前にそれを展開します。
  * ターミナルインターフェースでのみ動作する `/login` などの組み込みコマンドは利用できません。
  * `/model`、`/effort`、`/fast`、`/color`、`/rename` は値を引数として受け付け（例：`/model sonnet`）、`/mcp` は引数なしでサーバーステータスのテキスト概要を出力します。これらの形式には Claude Code v2.1.205 以降が必要で、各コマンドの[利用可能性に関する注記](/docs/ja/commands#all-commands)に従います。
  * 設定を変更するには、`/config` に `key=value` を渡します（例：`/config thinking=false`）。
  * `/output-style <style>` は[出力スタイル](/docs/ja/output-styles)を切り替え、`/output-style` 単体ではそれらを一覧表示します。Claude Code v2.1.269 以降が必要です。
</Note>

<h3 id="customize-the-system-prompt">
  システムプロンプトをカスタマイズする
</h3>

`--append-system-prompt` を使用して、Claude Code のデフォルト動作を保持しながら指示を追加します。この例は PR の差分を Claude にパイプし、セキュリティ脆弱性をレビューするよう指示します。シェルスクリプトとして保存します（例：`review.sh`）。

```bash theme={null}
gh pr diff "$1" | claude -p \
  --append-system-prompt "You are a security engineer. Review for vulnerabilities." \
  --output-format json
```

スクリプト内の `"$1"` は、コマンドラインで渡す最初の引数を表します。`bash review.sh 123` を実行すると、シェルは `"$1"` を `123` に置き換えるため、スクリプトは PR 123 の差分を取得します。Claude Code はレビューを JSON として出力し、テキストは `result` フィールドに入ります。

デフォルトのプロンプトを完全に置き換える `--system-prompt` を含むその他のオプションについては、[システムプロンプトフラグ](/docs/ja/cli-reference#system-prompt-flags)を参照してください。

<h3 id="continue-conversations">
  会話を続ける
</h3>

`--continue` を使用して最新の会話を続けるか、`--resume` をセッション ID と共に使用して特定の会話を続けます。Claude Code v2.1.257 以降では、`--continue` を渡すと、Claude Code は終了済みの[バックグラウンドセッション](/docs/ja/sessions#resume-a-session)は開きますが、まだ実行中のものは開きません。この例はレビューを実行してから、フォローアップのプロンプトを送信します。

```bash theme={null}
# First request
claude -p "Review this codebase for performance issues"

# Continue the most recent conversation
claude -p "Now focus on the database queries" --continue
claude -p "Generate a summary of all issues found" --continue
```

複数の会話を実行している場合は、セッション ID を取得して特定の会話を再開します。

```bash theme={null}
session_id=$(claude -p "Start a review" --output-format json | jq -r '.session_id')
claude -p "Continue that review" --resume "$session_id"
```

2 つのコマンドは異なるディレクトリから実行できます。Claude Code はこのマシン上の任意のプロジェクトから[ID でセッションを検索します](/docs/ja/sessions#resume-a-session)。v2.1.223 より前では、Claude Code は現在のプロジェクトディレクトリとその git worktree でのみ ID を探していたため、両方のコマンドを同じディレクトリから実行する必要がありました。

セッション ID の代わりに、`--resume` にセッションの `.jsonl` [トランスクリプトファイル](/docs/ja/sessions#where-transcripts-are-stored)への絶対パスを渡すこともでき、Claude Code はそのファイルに保存されている会話を続けます。

<h2 id="next-steps">
  次のステップ
</h2>

* [Agent SDK クイックスタート](/docs/ja/agent-sdk/quickstart)：Python または TypeScript で最初のエージェントを構築します
* [CLI リファレンス](/docs/ja/cli-reference)：すべての CLI フラグとオプション
* [GitHub Actions](/docs/ja/github-actions)：GitHub ワークフローで Agent SDK を使用します
* [GitLab CI/CD](/docs/ja/gitlab-ci-cd)：GitLab パイプラインで Agent SDK を使用します
