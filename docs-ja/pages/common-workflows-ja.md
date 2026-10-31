> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# 一般的なワークフロー

> Claude Code を使用してコードベースの探索、バグ修正、リファクタリング、テスト、その他の日常的なタスクを実行するためのステップバイステップガイド。

このページでは、日常的な開発のための短いレシピを集めています。プロンプティングとコンテキスト管理に関する高度なガイダンスについては、[ベストプラクティス](https://code.claude.com/docs/ja/best-practices.md)を参照してください。

このページでは以下をカバーしています：

* [プロンプトレシピ](#prompt-recipes)：コード探索、バグ修正、リファクタリング、テスト、PR、ドキュメント用
* [以前の会話を再開する](#resume-previous-conversations)：タスクを複数回に分けて実行できるようにする
* [worktree を使用して並列セッションを実行する](#run-parallel-sessions-with-worktrees)：同時編集が衝突しないようにする
* [編集前に計画する](#plan-before-editing)：ディスクに変更を加える前に確認する
* [研究を subagent に委譲する](#delegate-research-to-subagents)：メインコンテキストをクリーンに保つ
* [Claude をスクリプトにパイプする](#pipe-claude-into-scripts)：CI とバッチ処理用

## プロンプトレシピ

これらは、未知のコード探索、デバッグ、リファクタリング、テスト作成、PR 作成などの日常的なタスク用のプロンプトパターンです。各パターンは任意の Claude Code サーフェスで機能します。プロジェクトに合わせて表現を調整してください。

### 新しいコードベースを理解する

モノレポまたは大規模なコードベースで Claude Code を設定する場合は、[モノレポと大規模リポジトリ](https://code.claude.com/docs/ja/large-codebases.md)を参照してください。

#### コードベースの概要を素早く把握する

新しいプロジェクトに参加したばかりで、その構造を素早く理解する必要があるとします。

**1. プロジェクトルートディレクトリに移動する**

```bash theme={null}
cd /path/to/project 
```

`/path/to/project` をプロジェクトへのパスに置き換えてください。

**2. Claude Code を起動する**

```bash theme={null}
claude 
```

**3. 高レベルの概要をリクエストする**

```text wrap theme={null}
give me an overview of this codebase
```

**4. 特定のコンポーネントについてさらに詳しく調べる**

```text wrap theme={null}
explain the main architecture patterns used here
```

```text wrap theme={null}
what are the key data models?
```

```text wrap theme={null}
how is authentication handled?
```

> [!TIP]
>
> ヒント：
>
> * 広い質問から始めて、特定の領域に絞り込んでいく
> * プロジェクトで使用されているコーディング規約とパターンについて質問する
> * プロジェクト固有の用語の用語集をリクエストする

#### 関連するコードを見つける

特定の機能または機能に関連するコードを見つける必要があるとします。

**1. Claude に関連ファイルを見つけるよう依頼する**

```text wrap theme={null}
find the files that handle user authentication
```

**2. コンポーネントがどのように相互作用するかについてのコンテキストを取得する**

```text wrap theme={null}
how do these authentication files work together?
```

**3. 実行フローを理解する**

```text wrap theme={null}
trace the login process from front-end to database
```

> [!TIP]
>
> ヒント：
>
> * 探しているものについて具体的に説明する
> * プロジェクトのドメイン言語を使用する
> * 言語の[コード インテリジェンス プラグイン](https://code.claude.com/docs/ja/plugins/code-intelligence.md)をインストールして、Claude に正確な「定義に移動」と「参照を検索」のナビゲーションを提供する

***

### バグを効率的に修正する

エラーメッセージが表示され、そのソースを見つけて修正する必要があるとします。

**1. Claude とエラーを共有する**

```text wrap theme={null}
I'm seeing an error when I run npm test
```

**2. 修正の推奨事項をリクエストする**

```text wrap theme={null}
suggest a few ways to fix the @ts-ignore in user.ts
```

**3. 修正を適用する**

```text wrap theme={null}
update user.ts to add the null check you suggested
```

> [!TIP]
>
> ヒント：
>
> * Claude に問題を再現するコマンドとスタックトレースを伝える
> * エラーを再現するための手順を記載する
> * エラーが断続的か一貫しているかを Claude に知らせる

***

### コードをリファクタリングする

古いコードを最新のパターンとプラクティスを使用するように更新する必要があるとします。

コードベース全体を新しい言語に移植する場合は、ブログの[Anthropic が Claude Code で大規模なコード移行を実行する方法](https://claude.com/blog/ai-code-migration)を参照してください。

**1. リファクタリング対象のレガシーコードを特定する**

```text wrap theme={null}
find deprecated API usage in our codebase
```

**2. リファクタリングの推奨事項を取得する**

```text wrap theme={null}
suggest how to refactor utils.js to use modern JavaScript features
```

**3. 変更を安全に適用する**

```text wrap theme={null}
refactor utils.js to use ES2024 features while maintaining the same behavior
```

**4. リファクタリングを検証する**

```text wrap theme={null}
run tests for the refactored code
```

> [!TIP]
>
> ヒント：
>
> * Claude に最新のアプローチの利点を説明するよう依頼する
> * 必要に応じて変更が後方互換性を維持することをリクエストする
> * リファクタリングを小さくテスト可能な増分で実行する

***

### テストを使用する

カバーされていないコードのテストを追加する必要があるとします。

**1. テストされていないコードを特定する**

```text wrap theme={null}
find functions in NotificationsService.swift that are not covered by tests
```

**2. テストスキャフォルディングを生成する**

```text wrap theme={null}
add tests for the notification service
```

**3. 意味のあるテストケースを追加する**

```text wrap theme={null}
add test cases for edge conditions in the notification service
```

**4. テストを実行して検証する**

```text wrap theme={null}
run the new tests and fix any failures
```

Claude は、プロジェクトの既存のパターンと規約に従うテストを生成できます。テストをリクエストするときは、検証したい動作について具体的に説明してください。Claude は既存のテストファイルを調べて、既に使用されているスタイル、フレームワーク、アサーションパターンに一致させます。

カバレッジを向上させるには、Claude に見落とした可能性のあるエッジケースを特定するよう依頼してください。Claude はコードパスを分析し、エラー条件、境界値、見落としやすい予期しない入力のテストを提案できます。

***

### プルリクエストを作成する

Claude に直接プルリクエストを作成するよう依頼するか（「create a pr for my changes」）、ステップバイステップで Claude をガイドできます：

**1. 変更内容を要約する**

```text wrap theme={null}
summarize the changes I've made to the authentication module
```

**2. プルリクエストを生成する**

```text wrap theme={null}
create a pr
```

**3. レビューと改善**

```text wrap theme={null}
enhance the PR description with more context about the security improvements
```

後でセッションを見つけるには、`claude --from-pr 1234` を実行してください。1234 を PR 番号に置き換えてください。これにより、その PR にリンクされたセッションにフィルタリングされたセッションピッカーが開きます。または、[`/resume` ピッカー](https://code.claude.com/docs/ja/sessions#use-the-session-picker)の検索に PR URL を貼り付けてください。Claude が `gh pr create` または `glab mr create` でプルリクエストを作成するとき、および Claude が[既存の PR で作業する](https://code.claude.com/docs/ja/agent-view.md#pull-request-status)ときに、Claude Code はセッションを PR にリンクします。

> [!TIP]
>
> Claude が生成した PR を送信する前にレビューし、Claude に潜在的なリスクや考慮事項を強調するよう依頼してください。

### ドキュメントを処理する

コードのドキュメントを追加または更新する必要があるとします。

**1. ドキュメント化されていないコードを特定する**

```text wrap theme={null}
find functions without proper JSDoc comments in the auth module
```

**2. ドキュメントを生成する**

```text wrap theme={null}
add JSDoc comments to the undocumented functions in auth.js
```

**3. レビューと改善**

```text wrap theme={null}
improve the generated documentation with more context and examples
```

**4. ドキュメントを検証する**

```text wrap theme={null}
check if the documentation follows our project standards
```

> [!TIP]
>
> ヒント：
>
> * 必要なドキュメントスタイル（JSDoc、docstring など）を指定する
> * ドキュメント内の例をリクエストする
> * パブリック API、インターフェース、複雑なロジックのドキュメントをリクエストする

***

### ノートと非コードフォルダで作業する

Claude Code はどのディレクトリでも機能します。ノートボルト、ドキュメントフォルダ、またはマークダウンファイルの任意のコレクション内で実行して、コードと同じ方法でコンテンツを検索、編集、再編成します。

`.claude/` ディレクトリと `CLAUDE.md` は他のツールの設定ディレクトリと並んで競合なく存在します。Claude は各ツール呼び出しで新しくファイルを読み込むため、別のアプリケーションで行った編集は次回そのファイルを読み込むときに表示されます。

***

### 画像を使用する

コードベース内の画像を使用する必要があり、Claude の画像コンテンツ分析を支援したいとします。

**1. 会話に画像を追加する**

次のいずれかの方法を使用できます：

1. Claude Code ウィンドウに画像をドラッグアンドドロップする
2. 画像をコピーして、CLI に `Ctrl+V` で貼り付ける。または [`Alt+V` を Windows と WSL で](https://code.claude.com/docs/ja/interactive-mode#general-controls)使用する
3. Claude に画像パスを提供する。例：「Analyze this image: /path/to/your/image.png」

**2. Claude に画像を分析するよう依頼する**

```text wrap theme={null}
What does this image show?
```

```text wrap theme={null}
Describe the UI elements in this screenshot
```

```text wrap theme={null}
Are there any problematic elements in this diagram?
```

**3. コンテキストに画像を使用する**

```text wrap theme={null}
Here's a screenshot of the error. What's causing it?
```

```text wrap theme={null}
This is our current database schema. How should we modify it for the new feature?
```

**4. ビジュアルコンテンツからコード提案を取得する**

```text wrap theme={null}
Generate CSS to match this design mockup
```

```text wrap theme={null}
What HTML structure would recreate this component?
```

> [!TIP]
>
> ヒント：
>
> * テキスト説明が不明確または面倒な場合は画像を使用する
> * より良いコンテキストのために、エラー、UI デザイン、図のスクリーンショットを含める
> * 会話で複数の画像を使用できます
> * 画像分析は図、スクリーンショット、モックアップなどで機能します
> * Claude が画像を参照する場合（例：`[Image #1]`）、`Cmd+Click`（Mac）または `Ctrl+Click`（Windows/Linux）リンクをクリックして、デフォルトビューアで画像を開きます

***

### ファイルとディレクトリを参照する

@ を使用して、Claude に読み込まれるのを待たずにファイルまたはディレクトリをすばやく含めます。

**1. 単一ファイルを参照する**

```text wrap theme={null}
Explain the logic in @src/utils/auth.js
```

これにより、ファイルが [Read ツール](https://code.claude.com/docs/ja/tools-reference.md#read-tool-behavior)のトークン制限（デフォルトでは 25,000 トークン）に収まる場合、ファイルの内容が会話に含まれます。256KB を超えるテキストファイルは含まれません。

**2. ディレクトリを参照する**

```text wrap theme={null}
What's the structure of @src/components?
```

**3. MCP リソースを参照する**

```text wrap theme={null}
Show me the data from @github:repos/owner/repo/issues
```

これにより、@server:resource 形式を使用して接続された MCP サーバーからデータを取得します。詳細については、[MCP リソース](https://code.claude.com/docs/ja/mcp.md#use-mcp-resources)を参照してください。

> [!TIP]
>
> ヒント：
>
> * ファイルパスは相対パスまたは絶対パスにできます
> * `@` を入力してパス提案メニューを開き、Enter または Tab キーを押してハイライトされたパスを受け入れ、もう一度 Enter キーを押してメッセージを送信します
> * @ ファイル参照は、ファイルのディレクトリと親ディレクトリに `CLAUDE.md` を追加してコンテキストに含めます
> * ディレクトリ参照はコンテンツではなくファイルリストを表示します
> * 単一のメッセージで複数のファイルを参照できます（例：「@file1.js and @file2.js」）

`@` 参照によってファイルの内容やディレクトリリストが含まれないようにするには、シェル、またはユーザー設定や[管理設定](https://code.claude.com/docs/ja/managed-settings.md)の [`env` ブロック](https://code.claude.com/docs/ja/env-vars#set-variables-in-settings-files)で [`CLAUDE_CODE_DISABLE_FILE_MENTIONS`](https://code.claude.com/docs/ja/env-vars#variables) を `1` に設定してください。その場合、Claude は参照されたパスを、ファイルツールを使って読み込むよう促すメモとともに受け取ります。この変数には Claude Code v2.1.299 以降が必要です。また、プロジェクト設定とローカル設定では Claude Code はこの変数を無視します。

Claude Code が `@` で参照されたファイルを含める場合、ツール呼び出しを行わないため、[`PreToolUse` フック](https://code.claude.com/docs/ja/hooks#pretooluse)は実行されません。Claude が読み込む内容をこれらのフックで制御している場合は、特定のパスをブロックするか、`@` 参照によってファイルが含まれないようにしてください：

* **特定のパスをブロックする**：それらのパスに対する [`Read` 拒否ルール](https://code.claude.com/docs/ja/permissions#read-and-edit)を追加します。Claude Code は、このルールに一致するファイルを含めません。
* **`@` 参照によってファイルが含まれないようにする**：`CLAUDE_CODE_DISABLE_FILE_MENTIONS=1` を設定します。これにより、フックがチェックしないパスであっても、メッセージ内の `@` ファイル参照とディレクトリ参照によって内容が含まれなくなります。その後、Claude が `Read` などのツールで参照先のパスを開く前に、一致するフックが実行されます。

***

### スケジュールで Claude を実行する

Claude に長時間実行されるタスクを自動的に定期的に処理させたいとします。例えば、毎朝オープン PR をレビューしたり、毎週依存関係を監査したり、夜間に CI の失敗をチェックしたりします。

実行場所に基づいてスケジューリングオプションを選択します：

| オプション | 実行場所 | 最適な用途 |
| :- | :- | :- |
| [クラウドスケジュールタスク](https://code.claude.com/docs/ja/routines.md) | クラウド（デフォルトでは Anthropic 管理） | コンピューターがオフの場合でも実行する必要があるタスク。スケジュールに加えて API 呼び出しまたは GitHub イベントでトリガーすることもできます。[claude.ai/code/routines](https://claude.ai/code/routines) で設定します。 |
| [デスクトップスケジュール済みタスク](https://code.claude.com/docs/ja/desktop-scheduled-tasks.md) | デスクトップアプリ経由のマシン | ローカルファイル、ツール、またはコミットされていない変更への直接アクセスが必要なタスク。 |
| [GitHub Actions](https://code.claude.com/docs/ja/github-actions.md) | CI パイプライン | オープン PR などのリポジトリイベント、またはワークフロー設定と一緒に存在する必要がある cron スケジュールに関連するタスク。 |
| [`/loop`](https://code.claude.com/docs/ja/scheduled-tasks) | 現在の CLI セッション | セッションが開いている間のクイックポーリング。`--resume` と `--continue` は期限切れでない固定間隔のループを復元します。 |

> [!TIP]
>
> スケジュール済みタスク用のプロンプトを作成するときは、成功がどのように見えるか、および結果をどうするかについて明示的に説明してください。タスクは自律的に実行されるため、確認質問をすることはできません。例えば：「`needs-review` ラベルが付いたオープン PR をレビューし、問題に関するインラインコメントを残し、`#eng-reviews` Slack チャネルに要約を投稿します。」

***

### Claude にその機能について質問する

Claude は自分の機能と制限についての質問に答えることができます。回答は最新の Claude Code ドキュメントから調べるため、実行中のバージョンに限定されません。

#### 質問例

```text wrap theme={null}
can Claude Code create pull requests?
```

```text wrap theme={null}
how does Claude Code handle permissions?
```

```text wrap theme={null}
what skills are available?
```

```text wrap theme={null}
how do I use MCP with Claude Code?
```

```text wrap theme={null}
how do I configure Claude Code for Amazon Bedrock?
```

```text wrap theme={null}
what are the limitations of Claude Code?
```

> [!NOTE]
>
> Claude はこれらの質問に対してドキュメントベースの回答を提供します。実行可能な例と実践的なデモンストレーションについては、`/powerup` を実行してアニメーション化されたデモを含むインタラクティブレッスンを受けるか、上記の特定のワークフローセクションを参照してください。

> [!TIP]
>
> ヒント：
>
> * 詳細な回答を得るために具体的な質問をする
> * Claude は MCP 統合、エンタープライズ設定、高度なワークフローなどの複雑な機能を説明できます

***

## 以前の会話を再開する

タスクが複数回に分けて実行される場合は、コンテキストを再度説明するのではなく、中断したところから再開してください。Claude Code はすべての会話をローカルに保存します。

```bash theme={null}
claude --continue
```

これにより、現在のディレクトリで最新のセッションが再開されます。まだセッションがない場合は、`No conversation found to continue` と出力して終了します。`claude --resume` を使用してリストから選択するか、実行中のセッション内から `/resume` を使用してください。[セッションを管理する](https://code.claude.com/docs/ja/sessions.md)を参照して、名前付け、ブランチ、および完全なピッカーリファレンスを確認してください。

## worktree を使用して並列セッションを実行する

1 つのターミナルで機能に取り組みながら、別のターミナルで Claude がバグを修正するようにします。編集が衝突しないようにしてください。各 [git worktree](https://git-scm.com/docs/git-worktree) は既存のコミットから作成された独自のブランチ上の個別のチェックアウトです。そのため、リポジトリには最初に少なくとも 1 つのコミットが必要です。

```bash theme={null}
claude --worktree feature-auth
```

別の名前で 2 番目のターミナルで同じコマンドを実行して、分離された並列セッションを開始します。コミットがないリポジトリでは、コマンドは `Failed to resolve base branch "HEAD": git rev-parse failed` というエラーで失敗します。クリーンアップ、`.worktreeinclude`、および非 git VCS サポートについては、[Worktrees](https://code.claude.com/docs/ja/worktrees.md) を参照してください。1 つの画面から並列セッションを監視するには、別のターミナルではなく、[バックグラウンドエージェント](https://code.claude.com/docs/ja/agent-view.md) を参照してください。

## 編集前に計画する

ディスクに変更を加える前に確認したい変更については、計画モードに切り替えてください。Claude はファイルを読み込んで計画を提案しますが、承認されるまで編集は行いません。ステータスバーは計画モードがアクティブな間、`⏸ plan mode on` と表示されます。

```bash theme={null}
claude --permission-mode plan
```

セッション中に `Shift+Tab` を押してステータスバーが `⏸ plan mode on` と表示されるまで切り替えることもできます。承認フローとテキストエディタで計画を編集する方法については、[計画モード](https://code.claude.com/docs/ja/permission-modes.md#analyze-before-you-edit-with-plan-mode)を参照してください。

## 研究を subagent に委譲する

大規模なコードベースの探索はコンテキストをファイル読み込みで満たします。探索を委譲して、結果のみが戻るようにしてください。

```text wrap theme={null}
use a subagent to investigate how our auth system handles token refresh
```

subagent は独自のコンテキストウィンドウでファイルを読み込み、要約を報告します。[Subagents](https://code.claude.com/docs/ja/sub-agents.md)を参照して、独自のツールとプロンプトを持つカスタムエージェントを定義することを確認してください。

## Claude をスクリプトにパイプする

CI、プリコミットフック、またはバッチ処理用に Claude を非対話的に実行します。stdin と stdout は任意の Unix ツールのように機能します。

```bash theme={null}
git log --oneline -20 | claude -p "summarize these recent commits"
```

[非対話モード](https://code.claude.com/docs/ja/headless.md)を参照して、出力形式、許可フラグ、およびファンアウトパターンを確認してください。

## 次のステップ

> [card] [ベストプラクティス](https://code.claude.com/docs/ja/best-practices.md)
>
> Claude Code から最大限の価値を得るためのパターン

> [card] [セッションを管理する](https://code.claude.com/docs/ja/sessions.md)
>
> 会話を再開、名前付け、ブランチする

> [card] [Worktrees](https://code.claude.com/docs/ja/worktrees.md)
>
> 分離された並列セッションを実行する

> [card] [Claude Code を拡張する](https://code.claude.com/docs/ja/features-overview.md)
>
> skill、フック、MCP、subagent、プラグインを追加する
