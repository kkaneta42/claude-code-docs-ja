> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# Claude Codeをプログラムで実行する

> Agent SDKを使用して、CLI、Python、またはTypeScriptからClaudeコードをプログラムで実行します。

[Agent SDK](https://platform.claude.com/docs/ja/agent-sdk/overview)は、Claude Codeを支える同じツール、エージェントループ、およびコンテキスト管理を提供します。スクリプトとCI/CDのためのCLIとして、または完全なプログラムによる制御のための[Python](https://platform.claude.com/docs/ja/agent-sdk/python)および[TypeScript](https://platform.claude.com/docs/ja/agent-sdk/typescript)パッケージとして利用できます。

<Note>
  CLIは以前「ヘッドレスモード」と呼ばれていました。`-p`フラグとすべてのCLIオプションは同じように機能します。
</Note>

CLIからClaudeコードをプログラムで実行するには、プロンプトと任意の[CLIオプション](/ja/cli-reference)を指定して`-p`を渡します：

```bash  theme={null}
claude -p "Find and fix the bug in auth.py" --allowedTools "Read,Edit,Bash"
```

このページではCLI（`claude -p`）経由でAgent SDKを使用することについて説明しています。構造化された出力、ツール承認コールバック、およびネイティブメッセージオブジェクトを備えたPythonおよびTypeScript SDKパッケージについては、[完全なAgent SDKドキュメント](https://platform.claude.com/docs/ja/agent-sdk/overview)を参照してください。

## 基本的な使用方法

任意の`claude`コマンドに`-p`（または`--print`）フラグを追加して、非対話的に実行します。すべての[CLIオプション](/ja/cli-reference)は`-p`で機能します。以下を含みます：

* `--continue`は[会話を続ける](#continue-conversations)ため
* `--allowedTools`は[ツールを自動承認する](#auto-approve-tools)ため
* `--output-format`は[構造化された出力を取得する](#get-structured-output)ため

この例はコードベースについてClaudeに質問し、応答を出力します：

```bash  theme={null}
claude -p "What does the auth module do?"
```

## 例

これらの例は一般的なCLIパターンを強調しています。

### 構造化された出力を取得する

`--output-format`を使用して、応答がどのように返されるかを制御します：

* `text`（デフォルト）：プレーンテキスト出力
* `json`：結果、セッションID、およびメタデータを含む構造化JSON
* `stream-json`：リアルタイムストリーミング用の改行区切りJSON

この例は、セッションメタデータを含むJSONとしてプロジェクトサマリーを返し、テキスト結果は`result`フィールドにあります：

```bash  theme={null}
claude -p "Summarize this project" --output-format json
```

特定のスキーマに準拠した出力を取得するには、`--output-format json`を`--json-schema`と[JSON Schema](https://json-schema.org/)定義で使用します。応答には、リクエストに関するメタデータ（セッションID、使用状況など）が含まれ、構造化された出力は`structured_output`フィールドにあります。

この例は関数名を抽出し、文字列の配列として返します：

```bash  theme={null}
claude -p "Extract the main function names from auth.py" \
  --output-format json \
  --json-schema '{"type":"object","properties":{"functions":{"type":"array","items":{"type":"string"}}},"required":["functions"]}'
```

<Tip>
  [jq](https://jqlang.github.io/jq/)などのツールを使用して応答を解析し、特定のフィールドを抽出します：

  ```bash  theme={null}
  # テキスト結果を抽出
  claude -p "Summarize this project" --output-format json | jq -r '.result'

  # 構造化された出力を抽出
  claude -p "Extract function names from auth.py" \
    --output-format json \
    --json-schema '{"type":"object","properties":{"functions":{"type":"array","items":{"type":"string"}}},"required":["functions"]}' \
    | jq '.structured_output'
  ```
</Tip>

### ツールを自動承認する

`--allowedTools`を使用して、Claudeが特定のツールをプロンプトなしで使用できるようにします。この例はテストスイートを実行し、失敗を修正し、Claudeが許可を求めずにBashコマンドを実行してファイルを読み取り/編集できるようにします：

```bash  theme={null}
claude -p "Run the test suite and fix any failures" \
  --allowedTools "Bash,Read,Edit"
```

### コミットを作成する

この例はステージされた変更を確認し、適切なメッセージでコミットを作成します：

```bash  theme={null}
claude -p "Look at my staged changes and create an appropriate commit" \
  --allowedTools "Bash(git diff:*),Bash(git log:*),Bash(git status:*),Bash(git commit:*)"
```

`--allowedTools`フラグは[パーミッションルール構文](/ja/settings#permission-rule-syntax)を使用します。`:*`サフィックスはプレフィックスマッチングを有効にするため、`Bash(git diff:*)`は`git diff`で始まるコマンドを許可します。

<Note>
  [スラッシュコマンド](/ja/slash-commands)（`/commit`など）は対話モードでのみ利用可能です。`-p`モードでは、代わりに実行したいタスクを説明してください。
</Note>

### システムプロンプトをカスタマイズする

`--append-system-prompt`を使用して、Claude Codeのデフォルト動作を保持しながら指示を追加します。この例はPR diffをClaudeにパイプし、セキュリティ脆弱性をレビューするよう指示します：

```bash  theme={null}
gh pr diff "$1" | claude -p \
  --append-system-prompt "You are a security engineer. Review for vulnerabilities." \
  --output-format json
```

`--system-prompt`を含む詳細オプションについては、[システムプロンプトフラグ](/ja/cli-reference#system-prompt-flags)を参照して、デフォルトプロンプトを完全に置き換えます。

### 会話を続ける

`--continue`を使用して最新の会話を続けるか、`--resume`をセッションIDで使用して特定の会話を続けます。この例はレビューを実行し、その後フォローアッププロンプトを送信します：

```bash  theme={null}
# 最初のリクエスト
claude -p "Review this codebase for performance issues"

# 最新の会話を続ける
claude -p "Now focus on the database queries" --continue
claude -p "Generate a summary of all issues found" --continue
```

複数の会話を実行している場合は、セッションIDをキャプチャして特定の会話を再開します：

```bash  theme={null}
session_id=$(claude -p "Start a review" --output-format json | jq -r '.session_id')
claude -p "Continue that review" --resume "$session_id"
```

## 次のステップ

<CardGroup cols={2}>
  <Card title="Agent SDKクイックスタート" icon="play" href="https://platform.claude.com/docs/ja/agent-sdk/quickstart">
    PythonまたはTypeScriptで最初のエージェントを構築する
  </Card>

  <Card title="CLIリファレンス" icon="terminal" href="/ja/cli-reference">
    すべてのCLIフラグとオプションを探索する
  </Card>

  <Card title="GitHub Actions" icon="github" href="/ja/github-actions">
    GitHubワークフローでAgent SDKを使用する
  </Card>

  <Card title="GitLab CI/CD" icon="gitlab" href="/ja/gitlab-ci-cd">
    GitLabパイプラインでAgent SDKを使用する
  </Card>
</CardGroup>
