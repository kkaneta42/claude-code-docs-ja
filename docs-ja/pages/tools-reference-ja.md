> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# ツール リファレンス

> Claude Code が使用できるツールの完全なリファレンス（権限要件を含む）

Claude Code は、コードベースを理解および変更するのに役立つツールセットにアクセスできます。以下のツール名は、[権限ルール](/ja/permissions#tool-specific-permission-rules)、[subagent ツールリスト](/ja/sub-agents)、および[フック マッチャー](/ja/hooks)で使用する正確な文字列です。

| ツール                    | 説明                                                                                                                                                                                                      | 権限が必要 |
| :--------------------- | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | :---- |
| `Agent`                | 独自のコンテキストウィンドウを持つ [subagent](/ja/sub-agents) を生成してタスクを処理します                                                                                                                                             | いいえ   |
| `AskUserQuestion`      | 要件を収集したり曖昧さを明確にするために複数選択肢の質問をします                                                                                                                                                                        | いいえ   |
| `Bash`                 | 環境でシェル コマンドを実行します。[Bash ツールの動作](#bash-tool-behavior)を参照してください                                                                                                                                           | はい    |
| `CronCreate`           | 現在のセッション内で定期的または 1 回限りのプロンプトをスケジュールします（Claude が終了すると削除されます）。[スケジュール済みタスク](/ja/scheduled-tasks)を参照してください                                                                                                 | いいえ   |
| `CronDelete`           | ID でスケジュール済みタスクをキャンセルします                                                                                                                                                                                | いいえ   |
| `CronList`             | セッション内のすべてのスケジュール済みタスクをリストします                                                                                                                                                                           | いいえ   |
| `Edit`                 | 特定のファイルに対して対象を絞った編集を行います                                                                                                                                                                                | はい    |
| `EnterPlanMode`        | Plan Mode に切り替えてコーディング前にアプローチを設計します                                                                                                                                                                     | いいえ   |
| `EnterWorktree`        | 分離された [git worktree](/ja/common-workflows#run-parallel-claude-code-sessions-with-git-worktrees) を作成してそこに切り替えます                                                                                          | いいえ   |
| `ExitPlanMode`         | 承認用のプランを提示して Plan Mode を終了します                                                                                                                                                                           | はい    |
| `ExitWorktree`         | worktree セッションを終了して元のディレクトリに戻ります                                                                                                                                                                        | いいえ   |
| `Glob`                 | パターン マッチングに基づいてファイルを検索します                                                                                                                                                                               | いいえ   |
| `Grep`                 | ファイル コンテンツ内のパターンを検索します                                                                                                                                                                                  | いいえ   |
| `ListMcpResourcesTool` | 接続された [MCP servers](/ja/mcp) によって公開されたリソースをリストします                                                                                                                                                       | いいえ   |
| `LSP`                  | 言語サーバー経由のコード インテリジェンス。ファイル編集後に型エラーと警告を自動的に報告します。また、ナビゲーション操作もサポートしています：定義へのジャンプ、参照の検索、型情報の取得、シンボルのリスト、実装の検索、呼び出し階層のトレース。[コード インテリジェンス プラグイン](/ja/discover-plugins#code-intelligence)とその言語サーバー バイナリが必要です | いいえ   |
| `NotebookEdit`         | Jupyter ノートブック セルを変更します                                                                                                                                                                                 | はい    |
| `Read`                 | ファイルの内容を読み取ります                                                                                                                                                                                          | いいえ   |
| `ReadMcpResourceTool`  | URI で特定の MCP リソースを読み取ります                                                                                                                                                                                | いいえ   |
| `Skill`                | メイン会話内で [skill](/ja/skills#control-who-invokes-a-skill) を実行します                                                                                                                                          | はい    |
| `TaskCreate`           | タスク リストに新しいタスクを作成します                                                                                                                                                                                    | いいえ   |
| `TaskGet`              | 特定のタスクの完全な詳細を取得します                                                                                                                                                                                      | いいえ   |
| `TaskList`             | すべてのタスクとその現在のステータスをリストします                                                                                                                                                                               | いいえ   |
| `TaskOutput`           | （非推奨）バックグラウンド タスクから出力を取得します。タスクの出力ファイル パスで `Read` を使用することをお勧めします                                                                                                                                        | いいえ   |
| `TaskStop`             | ID で実行中のバックグラウンド タスクを終了します                                                                                                                                                                              | いいえ   |
| `TaskUpdate`           | タスク ステータス、依存関係、詳細を更新するか、タスクを削除します                                                                                                                                                                       | いいえ   |
| `TodoWrite`            | セッション タスク チェックリストを管理します。非対話型モードと [Agent SDK](/ja/headless) で利用可能です。対話型セッションでは代わりに TaskCreate、TaskGet、TaskList、TaskUpdate を使用します                                                                         | いいえ   |
| `ToolSearch`           | [ツール検索](/ja/mcp#scale-with-mcp-tool-search)が有効な場合、遅延ツールを検索してロードします                                                                                                                                      | いいえ   |
| `WebFetch`             | 指定された URL からコンテンツを取得します                                                                                                                                                                                 | はい    |
| `WebSearch`            | Web 検索を実行します                                                                                                                                                                                            | はい    |
| `Write`                | ファイルを作成または上書きします                                                                                                                                                                                        | はい    |

権限ルールは `/permissions` を使用するか、[権限設定](/ja/settings#available-settings)で構成できます。[ツール固有の権限ルール](/ja/permissions#tool-specific-permission-rules)も参照してください。

## Bash ツールの動作

Bash ツールは、次の永続化動作で各コマンドを別々のプロセスで実行します：

* 作業ディレクトリはコマンド間で永続化されます。`CLAUDE_BASH_MAINTAIN_PROJECT_WORKING_DIR=1` を設定して、各コマンド後にプロジェクト ディレクトリにリセットします。
* 環境変数は永続化されません。1 つのコマンドの `export` は次のコマンドでは利用できません。

Claude Code を起動する前に virtualenv または conda 環境をアクティブ化してください。Bash コマンド間で環境変数を永続化するには、Claude Code を起動する前に [`CLAUDE_ENV_FILE`](/ja/env-vars) をシェル スクリプトに設定するか、[SessionStart フック](/ja/hooks#persist-environment-variables)を使用して動的に設定します。

## 関連項目

* [権限](/ja/permissions)：権限システム、ルール構文、ツール固有のパターン
* [Subagents](/ja/sub-agents)：subagent のツール アクセスを構成する
* [フック](/ja/hooks-guide)：ツール実行の前後にカスタム コマンドを実行する
