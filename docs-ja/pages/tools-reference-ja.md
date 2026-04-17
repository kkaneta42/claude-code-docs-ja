> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# ツール リファレンス

> Claude Code が使用できるツールの完全なリファレンス（権限要件を含む）

Claude Code は、コードベースを理解および変更するのに役立つ組み込みツールのセットにアクセスできます。ツール名は、[権限ルール](/ja/permissions#tool-specific-permission-rules)、[subagent ツールリスト](/ja/sub-agents)、および[フック マッチャー](/ja/hooks)で使用する正確な文字列です。ツールを完全に無効にするには、[権限設定](/ja/permissions#tool-specific-permission-rules)の `deny` 配列にその名前を追加します。

カスタム ツールを追加するには、[MCP サーバー](/ja/mcp)を接続します。再利用可能なプロンプトベースのワークフローで Claude を拡張するには、[skill](/ja/skills) を作成します。これは新しいツール エントリを追加するのではなく、既存の `Skill` ツールを通じて実行されます。

| ツール                    | 説明                                                                                                                                                                                                           | 権限が必要 |
| :--------------------- | :----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :---- |
| `Agent`                | 独自のコンテキストウィンドウを持つ [subagent](/ja/sub-agents) を生成してタスクを処理します                                                                                                                                                  | いいえ   |
| `AskUserQuestion`      | 要件を収集したり曖昧さを明確にするために複数選択肢の質問をします                                                                                                                                                                             | いいえ   |
| `Bash`                 | 環境でシェル コマンドを実行します。[Bash ツールの動作](#bash-tool-behavior)を参照してください                                                                                                                                                | はい    |
| `CronCreate`           | 現在のセッション内で定期的または 1 回限りのプロンプトをスケジュールします（Claude が終了すると削除されます）。[スケジュール済みタスク](/ja/scheduled-tasks)を参照してください                                                                                                      | いいえ   |
| `CronDelete`           | ID でスケジュール済みタスクをキャンセルします                                                                                                                                                                                     | いいえ   |
| `CronList`             | セッション内のすべてのスケジュール済みタスクをリストします                                                                                                                                                                                | いいえ   |
| `Edit`                 | 特定のファイルに対して対象を絞った編集を行います                                                                                                                                                                                     | はい    |
| `EnterPlanMode`        | Plan Mode に切り替えてコーディング前にアプローチを設計します                                                                                                                                                                          | いいえ   |
| `EnterWorktree`        | 分離された [git worktree](/ja/common-workflows#run-parallel-claude-code-sessions-with-git-worktrees) を作成してそこに切り替えます。現在のリポジトリの既存の worktree に切り替えるには、新しいものを作成する代わりに `path` を渡します                                    | いいえ   |
| `ExitPlanMode`         | 承認用のプランを提示して Plan Mode を終了します                                                                                                                                                                                | はい    |
| `ExitWorktree`         | worktree セッションを終了して元のディレクトリに戻ります                                                                                                                                                                             | いいえ   |
| `Glob`                 | パターン マッチングに基づいてファイルを検索します                                                                                                                                                                                    | いいえ   |
| `Grep`                 | ファイル コンテンツ内のパターンを検索します                                                                                                                                                                                       | いいえ   |
| `ListMcpResourcesTool` | 接続された [MCP servers](/ja/mcp) によって公開されたリソースをリストします                                                                                                                                                            | いいえ   |
| `LSP`                  | 言語サーバー経由のコード インテリジェンス：定義へのジャンプ、参照の検索、型エラーと警告の報告。[LSP ツールの動作](#lsp-tool-behavior)を参照してください                                                                                                                    | いいえ   |
| `Monitor`              | コマンドをバックグラウンドで実行し、各出力行を Claude にフィードバックするため、会話の途中でログ エントリ、ファイル変更、またはポーリング ステータスに対応できます。[Monitor ツール](#monitor-tool)を参照してください                                                                                 | はい    |
| `NotebookEdit`         | Jupyter ノートブック セルを変更します                                                                                                                                                                                      | はい    |
| `PowerShell`           | Windows で PowerShell コマンドを実行します。オプトイン プレビュー。[PowerShell ツール](#powershell-tool)を参照してください                                                                                                                      | はい    |
| `Read`                 | ファイルの内容を読み取ります                                                                                                                                                                                               | いいえ   |
| `ReadMcpResourceTool`  | URI で特定の MCP リソースを読み取ります                                                                                                                                                                                     | いいえ   |
| `SendMessage`          | [agent team](/ja/agent-teams) メンバーにメッセージを送信するか、agent ID で [subagent](/ja/sub-agents#resume-subagents) を再開します。停止した subagent はバックグラウンドで自動的に再開されます。`CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1` が設定されている場合にのみ利用可能です | いいえ   |
| `Skill`                | メイン会話内で [skill](/ja/skills#control-who-invokes-a-skill) を実行します                                                                                                                                               | はい    |
| `TaskCreate`           | タスク リストに新しいタスクを作成します                                                                                                                                                                                         | いいえ   |
| `TaskGet`              | 特定のタスクの完全な詳細を取得します                                                                                                                                                                                           | いいえ   |
| `TaskList`             | すべてのタスクとその現在のステータスをリストします                                                                                                                                                                                    | いいえ   |
| `TaskOutput`           | （非推奨）バックグラウンド タスクから出力を取得します。タスクの出力ファイル パスで `Read` を使用することをお勧めします                                                                                                                                             | いいえ   |
| `TaskStop`             | ID で実行中のバックグラウンド タスクを終了します                                                                                                                                                                                   | いいえ   |
| `TaskUpdate`           | タスク ステータス、依存関係、詳細を更新するか、タスクを削除します                                                                                                                                                                            | いいえ   |
| `TeamCreate`           | 複数のメンバーを持つ [agent team](/ja/agent-teams) を作成します。`CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1` が設定されている場合にのみ利用可能です                                                                                                 | いいえ   |
| `TeamDelete`           | agent team を解散してメンバー プロセスをクリーンアップします。`CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1` が設定されている場合にのみ利用可能です                                                                                                            | いいえ   |
| `TodoWrite`            | セッション タスク チェックリストを管理します。非対話型モードと [Agent SDK](/ja/headless) で利用可能です。対話型セッションでは代わりに TaskCreate、TaskGet、TaskList、TaskUpdate を使用します                                                                              | いいえ   |
| `ToolSearch`           | [ツール検索](/ja/mcp#scale-with-mcp-tool-search)が有効な場合、遅延ツールを検索してロードします                                                                                                                                           | いいえ   |
| `WebFetch`             | 指定された URL からコンテンツを取得します                                                                                                                                                                                      | はい    |
| `WebSearch`            | Web 検索を実行します                                                                                                                                                                                                 | はい    |
| `Write`                | ファイルを作成または上書きします                                                                                                                                                                                             | はい    |

権限ルールは `/permissions` を使用するか、[権限設定](/ja/settings#available-settings)で構成できます。[ツール固有の権限ルール](/ja/permissions#tool-specific-permission-rules)も参照してください。

## Bash ツールの動作

Bash ツールは、次の永続化動作で各コマンドを別々のプロセスで実行します：

* Claude がメイン セッションで `cd` を実行すると、新しい作業ディレクトリはプロジェクト ディレクトリ内に留まる限り、または `--add-dir`、`/add-dir`、または設定の `additionalDirectories` で追加した[追加の作業ディレクトリ](/ja/permissions#working-directories)内に留まる限り、後の Bash コマンドに引き継がれます。Subagent セッションは作業ディレクトリの変更を引き継ぎません。
  * `cd` がこれらのディレクトリの外に出た場合、Claude Code はプロジェクト ディレクトリにリセットし、ツール結果に `Shell cwd was reset to <dir>` を追加します。
  * この引き継ぎを無効にして、すべての Bash コマンドがプロジェクト ディレクトリで開始されるようにするには、`CLAUDE_BASH_MAINTAIN_PROJECT_WORKING_DIR=1` を設定します。
* 環境変数は永続化されません。1 つのコマンドの `export` は次のコマンドでは利用できません。

Claude Code を起動する前に virtualenv または conda 環境をアクティブ化してください。Bash コマンド間で環境変数を永続化するには、Claude Code を起動する前に [`CLAUDE_ENV_FILE`](/ja/env-vars) をシェル スクリプトに設定するか、[SessionStart フック](/ja/hooks#persist-environment-variables)を使用して動的に設定します。

## LSP ツールの動作

LSP ツールは、実行中の言語サーバーから Claude にコード インテリジェンスを提供します。ファイル編集後、型エラーと警告を自動的に報告するため、Claude は別のビルド ステップなしで問題を修正できます。Claude はナビゲーション操作のために直接呼び出すこともできます：

* シンボルの定義へのジャンプ
* シンボルへのすべての参照を検索
* 位置での型情報を取得
* ファイルまたはワークスペース内のシンボルをリスト
* インターフェイスの実装を検索
* 呼び出し階層をトレース

ツールは、言語の[コード インテリジェンス プラグイン](/ja/discover-plugins#code-intelligence)をインストールするまで非アクティブです。プラグインは言語サーバー構成をバンドルし、サーバー バイナリは別途インストールします。

## Monitor ツール

<Note>
  Monitor ツールには Claude Code v2.1.98 以降が必要です。
</Note>

Monitor ツールを使用すると、Claude は会話を一時停止することなく、バックグラウンドで何かを監視し、変更時に対応できます。Claude に以下を依頼します：

* ログ ファイルをテールして、エラーが表示されたらフラグを立てる
* PR または CI ジョブをポーリングして、ステータスが変更されたときに報告する
* ディレクトリのファイル変更を監視する
* 指定した長時間実行スクリプトからの出力を追跡する

Claude は監視用の小さなスクリプトを作成し、バックグラウンドで実行し、到着した各出力行を受け取ります。同じセッションで作業を続け、イベントが到着すると Claude が割り込みます。Claude にキャンセルするよう依頼するか、セッションを終了することで Monitor を停止します。

Monitor は [Bash と同じ権限ルール](/ja/permissions#tool-specific-permission-rules)を使用するため、Bash に設定した `allow` および `deny` パターンがここにも適用されます。Amazon Bedrock、Google Vertex AI、または Microsoft Foundry では利用できません。`DISABLE_TELEMETRY` または `CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC` が設定されている場合も利用できません。

プラグインは、Claude に開始するよう依頼する代わりに、プラグインがアクティブな場合に自動的に開始される Monitor を宣言できます。[プラグイン Monitor](/ja/plugins-reference#monitors)を参照してください。

## PowerShell ツール

Windows では、Claude Code は Git Bash を経由するのではなく、PowerShell コマンドをネイティブに実行できます。これはオプトイン プレビューです。

### PowerShell ツールを有効にする

環境または `settings.json` で `CLAUDE_CODE_USE_POWERSHELL_TOOL=1` を設定します：

```json theme={null}
{
  "env": {
    "CLAUDE_CODE_USE_POWERSHELL_TOOL": "1"
  }
}
```

Claude Code は `pwsh.exe`（PowerShell 7 以降）を自動検出し、`powershell.exe`（PowerShell 5.1）にフォールバックします。Bash ツールは PowerShell ツールと並行して登録されるため、Claude に PowerShell を使用するよう依頼する必要がある場合があります。

### 設定、フック、スキルでのシェル選択

3 つの追加設定は PowerShell が使用される場所を制御します：

* [`settings.json`](/ja/settings#available-settings) の `"defaultShell": "powershell"`：対話型 `!` コマンドを PowerShell 経由でルーティングします。PowerShell ツールが有効になっている必要があります。
* 個別の[コマンド フック](/ja/hooks#command-hook-fields)の `"shell": "powershell"`：そのフックを PowerShell で実行します。フックは PowerShell を直接生成するため、`CLAUDE_CODE_USE_POWERSHELL_TOOL` に関係なく機能します。
* [skill frontmatter](/ja/skills#frontmatter-reference) の `shell: powershell`：`` !`command` `` ブロックを PowerShell で実行します。PowerShell ツールが有効になっている必要があります。

Bash ツール セクションで説明されている同じメイン セッション作業ディレクトリ リセット動作が PowerShell コマンドに適用されます。これには `CLAUDE_BASH_MAINTAIN_PROJECT_WORKING_DIR` 環境変数が含まれます。

### プレビューの制限事項

PowerShell ツールには、プレビュー中に次の既知の制限事項があります：

* Auto mode は PowerShell ツールではまだ機能しません
* PowerShell プロファイルはロードされません
* サンドボックスはサポートされていません
* ネイティブ Windows でのみサポートされ、WSL ではサポートされていません
* Claude Code を起動するには Git Bash が必要です

## 利用可能なツールを確認する

正確なツール セットは、プロバイダー、プラットフォーム、および設定によって異なります。実行中のセッションで読み込まれているものを確認するには、Claude に直接尋ねます：

```text theme={null}
What tools do you have access to?
```

Claude は会話形式の概要を提供します。正確な MCP ツール名については、`/mcp` を実行します。

## 関連項目

* [MCP servers](/ja/mcp)：外部サーバーを接続してカスタム ツールを追加する
* [権限](/ja/permissions)：権限システム、ルール構文、ツール固有のパターン
* [Subagents](/ja/sub-agents)：subagent のツール アクセスを構成する
* [フック](/ja/hooks-guide)：ツール実行の前後にカスタム コマンドを実行する
