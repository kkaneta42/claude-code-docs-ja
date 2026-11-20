> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# Code Mode でコードからツール呼び出しを実行する

> Claude が 1 ステップで複数のツール呼び出しを行う JavaScript を書く実験的機能、Code Mode を試します。

Code Mode は、Claude が[ツール](https://code.claude.com/docs/ja/tools-reference.md)を使う方法を変更します。Code Mode がない場合、Claude は Bash、Read、Edit などのツール呼び出しを直接要求し、次に何をするかを決める前にそれぞれの結果を読みます。Code Mode では、Claude がツール呼び出しを行う JavaScript のコードを書き、Claude Code がそのコードをセッション内で実行します。

> [!NOTE]
>
> Code Mode は実験的な機能で、デフォルトではオフになっています。どのリリースでも変更または削除される可能性があります。フィードバックを送るには、`/feedback` を実行してください。

## Code Mode の仕組み

Code Mode のセッションでも、タスクはこれまでどおりプロンプトで説明し、Claude がそれを実行するための JavaScript を書きます。1 つのコードで、コマンドを並列に実行し、ある結果を次の呼び出しで使い、出力のうち Claude が読む必要のある部分を返すことができます。

たとえば、再試行の上限を引き上げるよう Claude に依頼すると、Claude はファイルを見つけて編集し、テストを実行するために次のようなコードを書くことがあります。最後の行で、ファイルのパスとテストの出力を Claude に返します。

```javascript theme={null}
const files = await $`rg -l "function retryPolicy" src`.text();
const target = files.trim().split("\n")[0];
await edit(target, "maxAttempts: 3", "maxAttempts: 5");
({ edited: target, tests: $`npm test -- retryPolicy`.nothrow() });
```

会話には、編集の差分などのツール呼び出しが表示され、コードは表示されません。コードを読むには、`Ctrl+O` を押して[トランスクリプトビューア](https://code.claude.com/docs/ja/interactive-mode.md#transcript-viewer)を開きます。各コードはそこで折りたたまれた **Code** 行として表示され、展開方法のヒントが添えられています。

### Code Mode を使う場面

Code Mode は、関連する多数のツール呼び出しを必要とするタスクで試してください。たとえば次のようなものです。

* 多くのファイルにわたって繰り返される変更
* Claude が読む前に結果を絞り込む必要がある検索
* 同時に実行できる複数の独立したコマンド

### Code Mode の制限事項

Code Mode をオンにする前に、次の制限を受け入れられるか確認してください。

* **再開**: Code Mode のセッションは、ターミナルで Code Mode をオンにした状態でのみ再開できます
* **auto モード**: auto モードの分類器は、[各ツール呼び出しではなくコードをレビューします](#permission-checks)
* **長時間実行されるコード**: [コードをバックグラウンドで実行できる](#long-running-code)場合を除き、完了するまで待つ必要があり、コードは 10 分後に停止します
* **フック**: `PreToolUse` フックが実行できない場合やタイムアウトした場合に[ツール呼び出しが拒否される](#tool-call-refused-by-a-hook)ことがあります
* **利用できない機能**: [Remote Control](https://code.claude.com/docs/ja/remote-control.md)、[Claude in Chrome](https://code.claude.com/docs/ja/chrome.md)、[computer use](https://code.claude.com/docs/ja/computer-use.md) は使用できません
* **セッションの移動**: セッションを Desktop アプリに移動したり、[バックグラウンドセッション](https://code.claude.com/docs/ja/agent-view.md)に変えたりすることはできず、`/fork` でバックグラウンドのコピーを開始することもできません

## 要件

* **バージョン**: Claude Code v2.1.323 以降（どちらの[リリースチャネル](https://code.claude.com/docs/ja/setup.md#configure-release-channel)でも可）。古いバージョンでは、理由 `it isn't open to your account yet` の表示の有無にかかわらず、Code Mode なしで起動します
* **アカウント**: Claude のサブスクリプションまたは Console アカウント。ゲートウェイ、Amazon Bedrock、Claude Platform on AWS、Google Cloud の Agent Platform、Microsoft Foundry、[Claude Models on Google Cloud (Anthropic managed)](https://code.claude.com/docs/ja/claude-models-on-google-cloud-anthropic-managed.md) を経由して Code Mode を使うことはできません
* **組織**: 組織が [HIPAA 構成](https://code.claude.com/docs/ja/hipaa-setup.md)や[ゼロデータ保持](https://code.claude.com/docs/ja/zero-data-retention.md)を使用していないこと
* **モデル**: Claude Opus 5.5、Sonnet 5.5、Haiku 5.5、または Fable 5.2
* **サーフェス**: ターミナルでの対話型の `claude` セッション。Code Mode は `-p`、Agent SDK、VS Code パネル、Desktop アプリ、クラウドセッションでは動作しません
* **エージェントチーム**: [エージェントチーム](https://code.claude.com/docs/ja/agent-teams.md)をオンにした状態で Code Mode を使用するには、v2.1.326 以降が必要です。チームメイトは、デフォルトの[インプロセス表示モード](https://code.claude.com/docs/ja/agent-teams.md#choose-a-display-mode)では Code Mode で実行され、分割ペインでは Code Mode なしで起動します
* **インストール**: Claude Code の[ネイティブビルド](https://code.claude.com/docs/ja/setup.md)
* **Windows**: [Git for Windows](https://git-scm.com/downloads/win) がインストールされていること

また、API キーヘルパー、OpenTelemetry エクスポート、`DISABLE_TELEMETRY` など、一部の設定がオンになっている場合も Code Mode を開始できません。それぞれの対処方法については、[Code Mode が起動しない](#code-mode-doesnt-start)を参照してください。

## Code Mode を試す

Code Mode をオンにして Claude にタスクを与え、Claude が書いたコードを確認します。

**1. バージョンを確認する**

`claude --version` を実行します。バージョンが v2.1.323 より古い場合は、`claude update` を実行します。`stable` チャネルを使用していて、更新しても v2.1.323 に達しない場合は、`stable` が追いつくのを待つか、[`latest` に切り替えてください](https://code.claude.com/docs/ja/setup#configure-release-channel)。

**2. Code Mode をオンにして Claude Code を起動する**

環境変数 [`CLAUDE_CODE_EXPERIMENTAL_CODE_MODE`](https://code.claude.com/docs/ja/env-vars#variables) を `1` に設定します。Code Mode を試すには、シェルで設定します。すべての新しいセッションで Code Mode をオンにするには、ユーザー設定で設定します。

> [tab] macOS, Linux, WSL
>
> ```bash theme={null}
> CLAUDE_CODE_EXPERIMENTAL_CODE_MODE=1 claude
> ```

> [tab] Windows PowerShell
>
> ```powershell theme={null}
> $env:CLAUDE_CODE_EXPERIMENTAL_CODE_MODE = "1"
> claude
> ```

> [tab] settings.json
>
> この `env` ブロックを `~/.claude/settings.json` に保存し、`claude` を起動します。
>
> ```json theme={null}
> {
>   "env": {
>     "CLAUDE_CODE_EXPERIMENTAL_CODE_MODE": "1"
>   }
> }
> ```
>
> Claude Code は[プロジェクトの設定ファイル内のこの変数を無視する](https://code.claude.com/docs/ja/settings-reference.md#variables-claude-code-ignores-in-env)ため、クローンしたリポジトリが勝手に Code Mode をオンにすることはできません。

**3. Code Mode を使うことを確認する**

Claude Code は、最初の Code Mode セッションの前に確認を求めます。**Yes, turn on Code Mode** を選択します。Claude Code が再起動し、セッションの上部付近に次の行が表示されます。

```text theme={null}
Code Mode (experimental) is on · this session can be resumed only with Code Mode on
```

別の行が表示された場合や何も表示されない場合は、[Code Mode が起動しない](#code-mode-doesnt-start)を参照してください。

**4. 多数のツール呼び出しを必要とするタスクを Claude に与える**

よく知っているプロジェクトで、次のようなプロンプトを送信します。

```text theme={null}
Read every Markdown file in this project and list the links that point to local files that don't exist.
```

**5. Claude が書いたコードを読む**

`Ctrl+O` を押して **Code** 行を展開すると、ツール呼び出しの背後にある JavaScript を確認できます。会話に戻るには、もう一度 `Ctrl+O` を押します。

> [!WARNING]
>
> 後で Code Mode のセッションを再開するには、`claude --continue` または `claude --resume` を実行するときに `CLAUDE_CODE_EXPERIMENTAL_CODE_MODE` を `1` に設定したままにしてください。Code Mode がオフの場合、Claude Code はセッションの再開を拒否します。Code Mode なしで開始したセッションは、変数が設定されていても Code Mode なしで再開されます。

### Code Mode をオフにする

シェルと `~/.claude/settings.json` から `CLAUDE_CODE_EXPERIMENTAL_CODE_MODE` を削除し、新しいセッションを開始します。変数を残したまま、どちらかの場所でその値を `0` に変更することもできます。一方の場所に `0` があれば、もう一方で `1` を設定していても Code Mode はオフのままです。

### 組織で Code Mode をブロックする

組織内の誰も Code Mode を使えないようにするには、[管理設定](https://code.claude.com/docs/ja/managed-settings.md)に値 `0` の `CLAUDE_CODE_EXPERIMENTAL_CODE_MODE` を追加します。

```json theme={null}
{
  "env": {
    "CLAUDE_CODE_EXPERIMENTAL_CODE_MODE": "0"
  }
}
```

Code Mode のセッション中のユーザーは、Claude Code を終了または再起動するまでそのセッションにとどまります。その後、ユーザーは Code Mode なしで起動し、`0` が設定されている間は Code Mode のセッションを再開できません。管理設定からユーザーに対して Code Mode をオンにすることはできません。

## 権限と長時間実行されるコード

権限モードによって、Claude が書くコードがどのようにチェックされるか、またコードの実行中に Claude と会話できるかどうかが決まります。

### 権限チェック

auto モードと `bypassPermissions` モードでは、コードは権限プロンプトなしで最初から最後まで実行できます。ただし、[どのモードでも自動承認されないアクション](https://code.claude.com/docs/ja/permission-modes.md#actions-no-mode-auto-approves)など、一部の呼び出しでは引き続きプロンプトが表示されます。

コード内の各ツール呼び出しは、`Bash` や [MCP ツールの名前](https://code.claude.com/docs/ja/permissions.md#mcp)などのツールの通常の名前で、`deny` と `ask` の[権限ルール](https://code.claude.com/docs/ja/permissions.md)および [`PreToolUse` フック](https://code.claude.com/docs/ja/hooks#pretooluse)を通過します。ルールとフックに加えて、auto モードでは分類器がコードをレビューし、確認を求めるモードではプロンプトに応答します。

* **[auto モード](https://code.claude.com/docs/ja/permission-modes.md#eliminate-prompts-with-auto-mode)**: 分類器は、各ツール呼び出しではなく、実行前の各コードをレビューします。検索出力から取得したパスなど、実行時に計算される値は分類器には見えないため、制御する必要がある呼び出しにはルールやフックを残しておいてください。それでも、分類器によるブロックが繰り返された後に自分で承認したコード内の呼び出しなど、[一部の呼び出しではプロンプトが表示される](#permission-prompt-with-a-countdown)ことがあります
* **その他の[権限モード](https://code.claude.com/docs/ja/permission-modes.md)**: そのモードでプロンプトが表示されるツール呼び出しごとにプロンプトが表示されます

シェルコマンドを許可またはブロックする `PreToolUse` フックがある場合は、[Bash ルールと同様に](https://code.claude.com/docs/ja/permissions.md#compound-commands)、コマンドの各部分をチェックするようにしてください。Code Mode では、`app` という名前のフォルダでの `git push` が、`cd 'app' && git push` としてフックに届くことがあります。

コード自体をチェックするには、コードを実行するツールである `REPL` にマッチする `PreToolUse` フックを書き、`tool_input.code` から JavaScript を読み取ります。コードが返す内容をチェックするには、[フックでコードの出力をチェックする](#check-code-output-with-a-hook)を参照してください。

> [!WARNING]
>
> Bash ルールはコマンドのテキストにマッチするため、Code Mode の有無にかかわらず、Claude は拒否されたコマンドを[ルールにマッチしない形式で](https://code.claude.com/docs/ja/permissions.md#bash-rule-limits)実行できます。コマンドのテキストに依存しない制限については、[サンドボックス化](https://code.claude.com/docs/ja/sandboxing.md)を参照してください。

#### コマンドの承認を必須にする

auto モードまたは `bypassPermissions` モードで特定のコマンドに対してプロンプトを表示するには、そのコマンドの `ask` ルールを追加します。[ルールがマッチする形式のコマンド](https://code.claude.com/docs/ja/permissions.md#bash-rule-limits)に対してプロンプトが表示されます。`git push` で始まるコマンドでプロンプトが表示されるようにするには、次のルールを `~/.claude/settings.json` に保存します。

```json theme={null}
{
  "permissions": {
    "ask": ["Bash(git push *)"]
  }
}
```

ルールをテストするには、リモートのないリポジトリで auto モードの新しいセッションを開始し、`git push origin main` を実行するよう Claude に依頼します。そのコマンドに対するプロンプトが表示されます。

#### 各コードを事前に承認する

コードの開始前にコードを読んで承認するには、コードを実行するツールである `REPL` の `ask` ルールを追加します。次のルールを `~/.claude/settings.json` に保存します。

```json theme={null}
{
  "permissions": {
    "ask": ["REPL"]
  }
}
```

ルールをテストするには、新しいセッションを開始し、Claude にタスクを与えます。コードを含まないプロンプトが表示されます。応答する前にコードを読むには、`Ctrl+O` を押して **Code** 行を展開し、もう一度 `Ctrl+O` を押して戻ります。メインの会話からは、このビューで[サブエージェント](https://code.claude.com/docs/ja/sub-agents.md)のコードは表示されません。

auto モードで承認すると、分類器がブロックしたはずの場合でもコードが開始され、そのコードによるプロジェクトの編集と読み取り専用コマンドはプロンプトなしで実行されます。コードがサブエージェントを開始できないと Claude が報告した場合は、このルールを削除してください。

#### コードの実行中に権限プロンプトに応答する

コードのツール呼び出しのいずれかに対するプロンプトでコードを停止するには、コメントなしで **No** と応答します。以下の結果は、サブエージェントからのものとラベル付けされていないプロンプトに適用されます。

* **No、または `Esc`**: コードが停止し、すでに完了した呼び出しによる変更はそのまま残ります
* **[コメント](https://code.claude.com/docs/ja/permissions.md#add-a-comment-when-you-answer-a-permission-prompt)付きの No**: その呼び出しは拒否され、コードは他の呼び出しを続行できます

### サンドボックスでシェルコマンドを制限する

[サンドボックス](https://code.claude.com/docs/ja/sandboxing.md)の設定は、コードが実行するシェルコマンドに適用されます。JavaScript 自体と、そのファイル、Web、MCP のツール呼び出しは[サンドボックスの外](https://code.claude.com/docs/ja/sandboxing.md#what-runs-outside-the-sandbox)で実行されます。JavaScript とそれらの呼び出しも分離するには、[コンテナまたは仮想マシン](https://code.claude.com/docs/ja/sandbox-environments.md)で Claude Code を実行します。

コードがサンドボックスなしでのコマンド実行を要求したときもコマンドをサンドボックス内に留めるには、[strict サンドボックスモード](https://code.claude.com/docs/ja/sandboxing.md#turn-off-the-retry-with-strict-sandbox-mode)をオンにします。auto モードでは、分類器はその要求を行うコードをレビューし、コマンドに対する個別のレビューはありません。

### 長時間実行されるコード

コードが長時間のビルドやテストを実行している間、Claude はその完了を待つか、バックグラウンドで続行させます。

* **待機**: Claude はコードの完了後に応答し、コードは 10 分後に停止します。Manual および `acceptEdits` [モード](https://code.claude.com/docs/ja/permission-modes.md#available-modes)では、ツールの権限プロンプトで費やした時間は 10 分に含まれません。v2.1.328 より前は、その時間も含まれていました。
* **バックグラウンド**: Claude との会話を続けることができ、コードは最大 2 時間実行できます

バックグラウンドでコードを実行するには、auto モードまたは `bypassPermissions` モードでセッションを開始します。それでも Claude が待機する場合は、現在のモードとセッションの開始方法を確認してください。

* **別のモードに切り替えた場合**: 開始時のモードに戻るまで `Shift+Tab` を押します
* **別のモードで開始した場合**: [auto モードが利用できる](https://code.claude.com/docs/ja/permission-modes.md#eliminate-prompts-with-auto-mode)場合は、終了してから、Code Mode をオンにした状態で `claude --continue --permission-mode auto` を実行します
* **v2.1.328 より前のバージョンを使用していて、`claude --resume` のリストからセッションを選択した場合**: 終了して [Claude Code を更新](https://code.claude.com/docs/ja/setup.md#update-claude-code)してから、Code Mode をオンにした状態で同じ `claude --resume` コマンドを実行します。現在のバージョンのままにするには、`--resume` を `--continue` に置き換えます
* **`--tools` にツール名を渡した場合**: そのフラグなしで auto モードで再度起動します

### 実行中のコードを停止する

Claude が応答中またはコードを待機中にコードを停止するには、`Esc` を押します。Claude の応答が終わった後にバックグラウンドのコードを停止するには、セッションで [`/tasks`](https://code.claude.com/docs/ja/commands) を実行し、実行中のタスクを選択して `x` を押します。

コードを停止した後、そのコードが開始してまだ実行中の[サブエージェント](https://code.claude.com/docs/ja/sub-agents.md)、[シェルコマンド](https://code.claude.com/docs/ja/interactive-mode.md#background-bash-commands)、[MCP 呼び出し](https://code.claude.com/docs/ja/mcp.md#automatic-backgrounding-of-long-tool-calls)がないか `/tasks` で確認してください。停止するには、それを選択して `x` を押します。

### フックでコードの出力をチェックする

Claude が読み取る前にコードが返す内容をチェックまたは編集するには、コードを実行するツールである `REPL` にマッチする [`PostToolUse` フック](https://code.claude.com/docs/ja/hooks#posttooluse)を書きます。同じフックは、[バックグラウンドのコード](#long-running-code)が完了したときと、コードがエラーをスローしたときにも実行されます。

#### フックでコードの出力を読み取る

`PostToolUse` フックでは、出力を `tool_response` から読み取ります。`tool_response` には次のようなフィールドがあります。

```json theme={null}
{
  "code": "(await $`cat notes.txt`.text())",
  "result": "deploy token: abc123",
  "stdout": "",
  "stderr": "",
  "toolsUsed": ["Bash"]
}
```

#### コードの出力を編集する

出力の一部を隠すには、`tool_response` を変更したコピーを [`updatedToolOutput`](https://code.claude.com/docs/ja/hooks#posttooluse-decision-control) として返します。コピーは次のように作成します。

* **テキストを変更する**: `result`、`stdout`、`stderr`、`error` を秘匿化します。`result` が存在しない場合や `null` の場合にも対応し、`error` はコードが失敗した場合または停止された場合にのみ存在すると想定してください
* **形式を維持する**: `code`、`stdout`、`stderr` は文字列として返し、`error` は文字列として返すか省略します。この形式を崩すと、Claude は元の出力を受け取ります
* **画像と PDF を削除する**: コピーに隠すべき `images` または `documents` がある場合は、そのフィールドを `[]` に設定します

`notes.txt` の結果にあるデプロイトークンを隠すには、次の JSON を出力します。

```json theme={null}
{
  "hookSpecificOutput": {
    "hookEventName": "PostToolUse",
    "updatedToolOutput": {
      "code": "(await $`cat notes.txt`.text())",
      "result": "deploy token: REDACTED",
      "stdout": "",
      "stderr": "",
      "toolsUsed": ["Bash"]
    }
  }
}
```

フックをテストするには、フックが編集する値を含むファイルを作成します。次に Code Mode セッションを開始し、そのファイルを読み取って引用するよう Claude に依頼します。パスは `@` を付けずに入力し、Claude の応答に置換後のテキストが表示されることを確認してください。

> [!WARNING]
>
> Bash コマンドなど、拒否されたツール呼び出しの入力に含まれる値を隠す目的でこのフックに依存しないでください。`refusedCalls` フィールドにはその入力が繰り返し含まれることがあり、Claude はそれを変更されないまま読み取ります。

#### フックがブロックした場合やエラーが発生した場合に編集する

フックがブロックした場合やエラーが発生した場合でも、`tool_response` を変更したコピーを `updatedToolOutput` として返します。

* **フックがブロックする場合**: [編集したコピー](#redact-code-output)を [`"decision": "block"`](https://code.claude.com/docs/ja/hooks#posttooluse-decision-control) と同じ JSON で出力します。コピーがない場合、ブロックしても Claude は元の出力を読み取ります
* **フックでエラーが発生した場合**: エラーをキャッチし、編集対象のフィールドにプレースホルダーテキストを入れたコピーを出力します。フックがクラッシュした場合、タイムアウトした場合、または無効な JSON を出力した場合、Claude は元の出力を受け取ります

#### `UserPromptSubmit` フックからチェックを移す

[`UserPromptSubmit` フック](https://code.claude.com/docs/ja/hooks#userpromptsubmit)でコードの出力をチェックしている場合は、そのチェックを `PostToolUse` フックに移してください。v2.1.328 以降では、管理者が[管理設定](https://code.claude.com/docs/ja/managed-settings.md)で設定した場合でも、`UserPromptSubmit` フックはコードの出力を受け取りません。

## トラブルシューティング

### Code Mode が起動しない

セッションの上部付近に `Code Mode (experimental) isn't available` と表示される場合、Claude Code は Code Mode なしで起動しています。理由は同じ行に続けて表示され、`/status` にも表示されます。次の表で理由を見つけて変更を行い、新しいセッションを開始してください。表にない理由の場合は、[要件](#requirements)を確認してください。

| 理由に含まれる文字列 | 対処方法 |
| :- | :- |
| `it isn't open to your account in this version` または `it isn't open to your account yet` | バージョンが v2.1.323 より古い場合は、[更新](#try-code-mode)してください。それ以外の場合は、ネットワーク接続を確認して再度起動してください。理由が変わらない場合は、別の日に再試行してください |
| `it only works directly with the Anthropic API` または `it only works with the Anthropic API` | クラウドプロバイダー、ゲートウェイ、またはカスタムの `ANTHROPIC_BASE_URL` を経由してリクエストをルーティングする設定を削除してください |
| `it doesn't work with an API key helper` | `apiKeyHelper`、`ANTHROPIC_AUTH_TOKEN`、および `ANTHROPIC_CUSTOM_HEADERS` 内の `Authorization` または `X-Api-Key` ヘッダーを削除してください。その後、サインインするか `ANTHROPIC_API_KEY` を設定してください |
| `it only works with Opus 5.5, Sonnet 5.5 and later models` | [サポートされているモデル](#requirements)で起動してください（例: `--model opus`）。Haiku 5.5 と Fable 5.2 も動作します |
| `it doesn't work in background jobs` | `--remote-control` なしでフォアグラウンドで起動してください。チームメイトの分割ペインに理由が表示される場合は、[in-process 表示モード](https://code.claude.com/docs/ja/agent-teams.md#choose-a-display-mode)を使用して、チームメイトを Code Mode で実行してください |
| `it needs settings that Claude Code downloads from Anthropic` | `DISABLE_TELEMETRY` など、[機能フラグの取得をオフにする](https://code.claude.com/docs/ja/env-vars.md#features-that-need-feature-flag-fetching)変数の設定を解除してください |
| `OpenTelemetry is on` | [OpenTelemetry エクスポート](https://code.claude.com/docs/ja/monitoring-usage.md)なしで作業できる場合は、`CLAUDE_CODE_ENABLE_TELEMETRY` と `ENABLE_BETA_TRACING_DETAILED` の設定を解除してください |
| `it doesn't yet work with the plugin` | セッションで `/plugin` を実行し、理由に名前が挙がっている各プラグインを無効にしてください。組織がプラグインをオンにしている場合は、管理者にオフにするよう依頼してください |
| `it doesn't yet work with an installed mod` | ツール呼び出しをチェックする [mod](https://code.claude.com/docs/ja/plugins/mods/overview.md) をオフにしてください |
| `it can't be used together with agent teams yet` | エージェントチームをオンのままにするには、[Claude Code を更新](https://code.claude.com/docs/ja/setup.md#update-claude-code)して v2.1.326 以降にしてください。現在のバージョンを使い続ける場合は、`CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS` の設定を解除してください |
| `this launch's tool options` | `--restricted` なしで起動し、`--tools` に `REPL` を追加して、`--disallowedTools` と `deny` ルールから `REPL` を削除してください |
| `couldn't save your answer` | `~/.claude.json` を書き込み可能にしてください |
| `your organization's settings don't allow it` | [管理設定](#block-code-mode-for-your-organization)について管理者に問い合わせてください |

Code Mode に関する行が何も表示されない場合は、`claude --version` を実行します。バージョンが v2.1.323 より古い場合は更新してください。その後、シェルまたはユーザー設定で `CLAUDE_CODE_EXPERIMENTAL_CODE_MODE` が `1` になっていることを確認し、それらの場所と `--settings` ファイルから `0` をすべて削除してください。

### カウントダウン付きの権限プロンプト

auto モードで、[分類器によるブロックが繰り返された](https://code.claude.com/docs/ja/permission-modes.md#when-auto-mode-falls-back)後にユーザー自身がコードを承認すると、そのコード内、およびまだ実行中の以前のコード内のツール呼び出しについて確認を求められることがあります。IDE が接続されていない場合、プロンプトにカウントダウンが表示されることがあります。

```text theme={null}
Claude Code will automatically block this request in 1:59, to avoid holding up an unattended session
```

カウントダウンが終わる前に応答してください。応答しない場合、その呼び出しは拒否され、カウントダウンが表示されるはずの以降の呼び出しもプロンプトなしで拒否されます。再びプロンプトを表示するには、Claude にメッセージを送信してください。

v2.1.327 より前では、Claude が新しいコードを開始した後、分類器がその新しいコードを許可した場合でも、実行中のコードの残りの呼び出しについて確認を求められることもありました。このようなプロンプトを減らすには、[Claude Code を更新](https://code.claude.com/docs/ja/setup.md#update-claude-code)して v2.1.327 以降にしてください。

### フックによってツール呼び出しが拒否された

Claude がツール呼び出しの拒否を報告した場合は、エラーテキストを尋ねてください。次のエラーは、`PreToolUse` フックが判定を返さなかったことを意味し、[`onFailure`](https://code.claude.com/docs/ja/hooks#block-the-action-when-a-hook-fails) が設定されていない場合でも呼び出しは拒否されます。

* **`the hook failed`**: コードからの呼び出しで、フックが開始できなかった、強制終了された、126、127、または 128 を超えるコードで終了した、あるいは HTTP エラーや無効な出力を返しました。フックを修正してください
* **`the hook did not finish`**: コードからの呼び出し、または Claude がセッション内でコードを実行した後のその他のツール呼び出しで、フックがタイムアウトしました。フックの [`timeout`](https://code.claude.com/docs/ja/hooks#common-fields) を引き上げてください

`command` または `http` フックが失敗またはタイムアウトしたときに呼び出しを続行させるには、そのフックに `"onFailure": "continue"` を設定します。`command` フックが 1 などの通常のコードで終了した場合、`"onFailure": "block"` を設定した場合を除き、呼び出しは続行されます。

### フックによってコードの出力が保留された

コードからの出力を期待していたのに、Claude の返答に `UserPromptSubmit operation blocked by hook` と表示される場合、[`UserPromptSubmit`](https://code.claude.com/docs/ja/hooks#userpromptsubmit) フックがその出力をプロンプトとして受け取り、ブロックしています。Claude がフックの理由のみを報告する場合は、受け取ったメッセージを引用するよう Claude に依頼してください。

v2.1.328 以降では、`UserPromptSubmit` フックはコードの出力を受け取りません。それより前のバージョンで出力を通過させるには、Claude Code を更新するか、フックを変更してください。

* **更新**: フックを使ってコードの出力をチェックしている場合は、まず[チェックを `PostToolUse` フックに移動](#check-code-output-with-a-hook)してください。その後、[Claude Code を更新](https://code.claude.com/docs/ja/setup.md#update-claude-code)して v2.1.328 以降にしてください
* **現在のバージョンを使い続ける**: 入力の `source` が `poll_event` のときにブロックしないようにフックを変更してください

## 関連リソース

* [権限モード](https://code.claude.com/docs/ja/permission-modes.md): auto モードとプロンプトを表示するモードを比較する
* [フックリファレンス](https://code.claude.com/docs/ja/hooks.md): `PreToolUse` フックと `PostToolUse` フックを書く
* [管理設定](https://code.claude.com/docs/ja/managed-settings.md): 1 つの設定を組織全体に適用する
