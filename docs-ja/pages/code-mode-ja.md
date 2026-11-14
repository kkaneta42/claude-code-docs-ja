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
* **フック**: `PreToolUse` フックが実行できない場合やタイムアウトした場合に[ツール呼び出しが拒否される](#tool-call-refused-by-a-hook)ことがあり、`UserPromptSubmit` フックによって[コードの出力がブロックされる](#code-output-withheld-by-a-hook)ことがあります
* **利用できない機能**: [Remote Control](https://code.claude.com/docs/ja/remote-control.md)、[Claude in Chrome](https://code.claude.com/docs/ja/chrome.md)、[computer use](https://code.claude.com/docs/ja/computer-use.md) は使用できません
* **セッションの移動**: セッションを Desktop アプリに移動したり、[バックグラウンドセッション](https://code.claude.com/docs/ja/agent-view.md)に変えたりすることはできず、`/fork` でバックグラウンドのコピーを開始することもできません

## 要件

* **バージョン**: Claude Code v2.1.323 以降（どちらの[リリースチャネル](https://code.claude.com/docs/ja/setup.md#configure-release-channel)でも可）。古いバージョンでは、理由 `it isn't open to your account yet` の表示の有無にかかわらず、Code Mode なしで起動します
* **アカウント**: Claude のサブスクリプションまたは Console アカウント。ゲートウェイ、Amazon Bedrock、Claude Platform on AWS、Google Cloud の Agent Platform、Microsoft Foundry を経由して Code Mode を使うことはできません
* **組織**: 組織が [HIPAA 構成](https://code.claude.com/docs/ja/hipaa-setup.md)や[ゼロデータ保持](https://code.claude.com/docs/ja/zero-data-retention.md)を使用していないこと
* **モデル**: Claude Opus 5.5、Sonnet 5.5、Haiku 5.5、または Fable 5.2
* **サーフェス**: ターミナルでの対話型の `claude` セッション。Code Mode は `-p`、Agent SDK、VS Code パネル、Desktop アプリ、クラウドセッションでは動作しません
* **インストール**: Claude Code の[ネイティブビルド](https://code.claude.com/docs/ja/setup.md)
* **Windows**: [Git for Windows](https://git-scm.com/downloads/win) がインストールされていること

また、API キーヘルパー、エージェントチーム、OpenTelemetry エクスポート、`DISABLE_TELEMETRY` など、一部の設定がオンになっている場合も Code Mode を開始できません。それぞれの対処方法については、[Code Mode が起動しない](#code-mode-doesnt-start)を参照してください。

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

権限モードによって、Claude のコードがどのようにチェックされるか、またコードの実行中に Claude と会話できるかどうかが決まります。

### 権限チェック

Claude のコードが行う各ツール呼び出しは、`deny` と `ask` の[権限ルール](https://code.claude.com/docs/ja/permissions.md)および [`PreToolUse` フック](https://code.claude.com/docs/ja/hooks#pretooluse)を通過します。`Bash` などのツールのルールや matcher を変更する必要はありません。ルールとフックに加えて、auto モードでは分類器がコードをレビューし、確認を求めるモードではプロンプトに応答します。

* **[auto モード](https://code.claude.com/docs/ja/permission-modes.md#eliminate-prompts-with-auto-mode)**: 分類器は、各ツール呼び出しではなく、実行前の各コードをレビューします。検索出力から取得したパスなど、実行時に計算される値は分類器には見えないため、制御する必要がある呼び出しにはルールやフックを残しておいてください。それでも、[以前のコードの実行中に新しいコードが開始されると、プロンプトが表示される](#permission-prompt-with-a-countdown)ことがあります
* **その他の[権限モード](https://code.claude.com/docs/ja/permission-modes.md)**: コードはレビューなしで開始され、そのモードでプロンプトが表示されるツール呼び出しごとにプロンプトが表示されます

コード自体をチェックするには、Claude のコードを実行するツールである `REPL` にマッチする `PreToolUse` フックを書き、`tool_input.code` から JavaScript を読み取ります。

> [!WARNING]
>
> Bash ルールはコマンドのテキストにマッチするため、Code Mode の有無にかかわらず、Claude は拒否されたコマンドを[ルールにマッチしない形式で](https://code.claude.com/docs/ja/permissions.md#bash-rule-limits)実行できます。コマンドのテキストに依存しない制限については、[サンドボックス化](https://code.claude.com/docs/ja/sandboxing.md)を参照してください。

### 長時間実行されるコード

コードが長時間のビルドやテストを実行している間、Claude はその完了を待つか、バックグラウンドで続行させます。

* **待機**: Claude はコードの完了後に応答し、コードは 10 分後に停止します（権限プロンプトで費やした時間を含みます）
* **バックグラウンド**: Claude との会話を続けることができ、コードは最大 2 時間実行できます

バックグラウンドでコードを実行するには、auto モードまたは `bypassPermissions` モードでセッションを開始します。それでも Claude が待機する場合は、現在のモードとセッションの開始方法を確認してください。

* **別のモードに切り替えた場合**: 開始時のモードに戻るまで `Shift+Tab` を押します
* **別のモードで開始した場合、または `claude --resume` のリストからセッションを選択した場合**: [auto モードが利用できる](https://code.claude.com/docs/ja/permission-modes.md#eliminate-prompts-with-auto-mode)場合は、終了してから、Code Mode をオンにした状態で `claude --continue --permission-mode auto` を実行します
* **`--tools` にツール名を渡した場合**: そのフラグなしで auto モードで再度起動します

## トラブルシューティング

### Code Mode が起動しない

セッションの上部付近に `Code Mode (experimental) isn't available` と表示される場合、Claude Code は Code Mode なしで起動しています。理由は同じ行に続けて表示され、`/status` にも表示されます。次の表で理由を見つけて変更を行い、新しいセッションを開始してください。表にない理由の場合は、[要件](#requirements)を確認してください。

| 理由に含まれる文字列 | 対処方法 |
| :- | :- |
| `it isn't open to your account yet` | バージョンが v2.1.323 より古い場合は、[更新](#try-code-mode)してください。それ以外の場合は、ネットワーク接続を確認して再度起動してください。理由が変わらない場合は、別の日に再試行してください |
| `it only works with the Anthropic API` | クラウドプロバイダー、ゲートウェイ、またはカスタムの `ANTHROPIC_BASE_URL` を経由してリクエストをルーティングする設定を削除してください |
| `it doesn't work with an API key helper` | `apiKeyHelper`、`ANTHROPIC_AUTH_TOKEN`、および `ANTHROPIC_CUSTOM_HEADERS` 内の `Authorization` または `X-Api-Key` ヘッダーを削除してください。その後、サインインするか `ANTHROPIC_API_KEY` を設定してください |
| `it only works with Opus 5.5, Sonnet 5.5 and later models` | [サポートされているモデル](#requirements)で起動してください（例: `--model opus`）。Haiku 5.5 と Fable 5.2 も動作します |
| `it doesn't work in background jobs` | `--remote-control` なしでフォアグラウンドで起動してください |
| `it needs settings that Claude Code downloads from Anthropic` | `DISABLE_TELEMETRY` など、[機能フラグの取得をオフにする](https://code.claude.com/docs/ja/env-vars.md#features-that-need-feature-flag-fetching)変数の設定を解除してください |
| `OpenTelemetry is on` | [OpenTelemetry エクスポート](https://code.claude.com/docs/ja/monitoring-usage.md)なしで作業できる場合は、`CLAUDE_CODE_ENABLE_TELEMETRY` と `ENABLE_BETA_TRACING_DETAILED` の設定を解除してください |
| `it doesn't yet work with an installed mod` | ツール呼び出しをチェックする [mod](https://code.claude.com/docs/ja/plugins/mods/overview.md) をオフにしてください |
| `it can't be used together with agent teams yet` | `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS` の設定を解除してください |
| `this launch's tool options` | `--restricted` なしで起動し、`--tools` に `REPL` を追加して、`--disallowedTools` と `deny` ルールから `REPL` を削除してください |
| `couldn't save your answer` | `~/.claude.json` を書き込み可能にしてください |
| `your organization's settings don't allow it` | [管理設定](#block-code-mode-for-your-organization)について管理者に問い合わせてください |

Code Mode に関する行が何も表示されない場合は、`claude --version` を実行します。バージョンが v2.1.323 より古い場合は更新してください。その後、シェルまたはユーザー設定で `CLAUDE_CODE_EXPERIMENTAL_CODE_MODE` が `1` になっていることを確認し、それらの場所と `--settings` ファイルから `0` をすべて削除してください。

### カウントダウン付きの権限プロンプト

auto モードで、以前のコードがまだ実行中のときに Claude がさらにコードを開始すると、以前のコードは分類器によるレビューを失います。Claude Code は、以前のコードの残りの呼び出しのうちレビューが必要になるものについて確認を求めます。IDE が接続されていない場合、プロンプトにはカウントダウンが表示されます。

```text theme={null}
Claude Code will automatically block this request in 1:59, to avoid holding up an unattended session
```

カウントダウンが終わる前に応答してください。応答しない場合、その呼び出しは拒否され、カウントダウンが表示されるはずの以降の呼び出しもプロンプトなしで拒否されます。再びプロンプトを表示するには、Claude にメッセージを送信してください。

### フックによってツール呼び出しが拒否された

Claude がツール呼び出しの拒否を報告した場合は、エラーテキストを尋ねてください。次のエラーは、`PreToolUse` フックが判定を返さなかったことを意味し、[`onFailure`](https://code.claude.com/docs/ja/hooks#block-the-action-when-a-hook-fails) が設定されていない場合でも呼び出しは拒否されます。

* **`the hook failed`**: Claude のコードからの呼び出しで、フックが開始できなかった、強制終了された、126、127、または 128 を超えるコードで終了した、あるいは HTTP エラーや無効な出力を返しました。フックを修正してください
* **`the hook did not finish`**: Claude のコードからの呼び出し、または Claude がセッション内でコードを実行した後のその他のツール呼び出しで、フックがタイムアウトしました。フックの [`timeout`](https://code.claude.com/docs/ja/hooks#common-fields) を引き上げてください

`command` または `http` フックが失敗またはタイムアウトしたときに呼び出しを続行させるには、そのフックに `"onFailure": "continue"` を設定します。`command` フックが 1 などの通常のコードで終了した場合、`"onFailure": "block"` を設定した場合を除き、呼び出しは続行されます。

### フックによってコードの出力が保留された

Claude のコードからの出力を期待していたところで Claude がフックのブロック理由を報告した場合は、[`UserPromptSubmit`](https://code.claude.com/docs/ja/hooks#userpromptsubmit) フックを確認してください。[コードをバックグラウンドで実行できる](#long-running-code)場合、そのイベントの `command`、`http`、`mcp_tool` フックはコードの出力に対しても実行されます。出力を通過させるには、入力の `source` が `poll_event` のときにブロックしないようにフックを変更してください。

## 関連リソース

* [権限モード](https://code.claude.com/docs/ja/permission-modes.md): auto モードとプロンプトを表示するモードを比較する
* [フックリファレンス](https://code.claude.com/docs/ja/hooks.md): `PreToolUse` フックと `UserPromptSubmit` フックを書く
* [管理設定](https://code.claude.com/docs/ja/managed-settings.md): 1 つの設定を組織全体に適用する
