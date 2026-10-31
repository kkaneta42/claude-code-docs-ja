> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# 概要

> Claude Code は agentic coding ツールで、コードベースを読み取り、ファイルを編集し、コマンドを実行し、開発ツールと統合します。ターミナル、IDE、デスクトップアプリ、ブラウザで利用できます。

Claude Code は AI を活用したコーディングアシスタントで、機能の構築、バグの修正、開発タスクの自動化を支援します。コードベース全体を理解し、複数のファイルとツール間で作業して目標を達成できます。

## はじめに

Claude Code は複数のサーフェスで実行されます。ターミナル、IDE 拡張機能、デスクトップアプリ、Web です。下のタブから 1 つを選択してはじめましょう。ほとんどのサーフェスには [Claude サブスクリプション](https://claude.com/pricing?utm_source=claude_code\&utm_medium=docs\&utm_content=overview_pricing)または [Anthropic Console](https://platform.claude.com/) アカウントが必要です。Terminal CLI、VS Code、JetBrains も [サードパーティプロバイダー](https://code.claude.com/docs/ja/third-party-integrations.md)をサポートしています。

> [tab] Terminal
>
> ターミナルで Claude Code を直接操作するための機能豊富な CLI です。ファイルを編集し、コマンドを実行し、コマンドラインからプロジェクト全体を管理できます。
>
> Claude Code をインストールするには、ターミナルを開いてシステムのコマンドを実行してください。ターミナルを使用したことがない場合は、[ターミナルガイド](https://code.claude.com/docs/ja/terminal-guide)でターミナルを開いてコマンドを貼り付ける方法を確認できます。
>
> > [tab] ネイティブインストール（推奨）
> >
> > **macOS、Linux、WSL：**
> >
> > ```bash theme={null}
> > curl -fsSL https://claude.ai/install.sh | bash
> > ```
> >
> > Windows では、PowerShell を使用している場合はシェルプロンプトに `PS C:\` と表示され、CMD を使用している場合は `PS` なしで `C:\` と表示されます。
> >
> > **Windows PowerShell：**
> >
> > ```powershell theme={null}
> > irm https://claude.ai/install.ps1 | iex
> > ```
> >
> > **Windows CMD：**
> >
> > ```batch theme={null}
> > curl -fsSL https://claude.ai/install.cmd -o install.cmd && install.cmd && del install.cmd
> > ```
> >
> > インストールコマンドは、Claude Code のダウンロード中に進行状況を表示しません。インストーラーが完了したら、新しいターミナルウィンドウを開いて `claude --version` を実行してください。インストールが正常に完了すると、バージョン番号が表示されます。シェルが `claude` が見つからない、または認識されていないと表示される場合は、インストールディレクトリがまだ PATH に含まれていません。[PATH を修正する](https://code.claude.com/docs/ja/troubleshoot-install.md#command-not-found-claude-after-installation)を参照してください。
> >
> > `The token '&&' is not a valid statement separator` というエラーが表示される場合は、CMD ではなく PowerShell を使用しています。`'irm' is not recognized as an internal or external command` というエラーが表示される場合は、PowerShell ではなく CMD を使用しています。
> >
> > インストールコマンドが `syntax error near unexpected token '<'`、`403`、またはその他のエラーで失敗する場合は、[インストールのトラブルシューティング](https://code.claude.com/docs/ja/troubleshoot-install.md#find-your-error)を参照して、エラーを修正方法に照合し、代替インストール方法を確認してください。
> >
> > [Git for Windows](https://git-scm.com/downloads/win) は、Claude Code が Bash ツールを使用できるようにネイティブ Windows で推奨されます。Git for Windows がインストールされていない場合、Claude Code はシェルツールとして PowerShell を代わりに使用します。WSL セットアップは Git for Windows を必要としません。
> >
> > > [!NOTE]
> > >
> > > ネイティブインストールは、最新バージョンに保つために自動的にバックグラウンドで更新されます。
>
> > [tab] Homebrew
> >
> > ```bash theme={null}
> > brew install --cask claude-code
> > ```
> >
> > Homebrew は 2 つの cask を提供しています。`claude-code` は安定リリースチャネルを追跡しており、通常は約 1 週間遅れており、大きな回帰を伴うリリースをスキップします。`claude-code@latest` は最新チャネルを追跡し、新しいバージョンが出荷されるとすぐに受け取ります。
> >
> > > [!NOTE]
> > >
> > > Homebrew インストールは自動更新されません。インストールした cask に応じて、`brew upgrade claude-code` または `brew upgrade claude-code@latest` を実行して、最新の機能とセキュリティ修正を取得してください。
>
> > [tab] WinGet
> >
> > ```powershell theme={null}
> > winget install Anthropic.ClaudeCode
> > ```
> >
> > > [!NOTE]
> > >
> > > WinGet インストールは自動更新されません。最新の機能とセキュリティ修正を取得するために、定期的に `winget upgrade Anthropic.ClaudeCode` を実行してください。
>
> また、Debian、Fedora、RHEL、Alpine で [apt、dnf、または apk](https://code.claude.com/docs/ja/setup.md#install-with-linux-package-managers) を使用してインストールすることもできます。
>
> その後、任意のプロジェクトで Claude Code を開始します。`your-project` をマシン上のプロジェクトディレクトリへのパスに置き換えてください：
>
> ```bash theme={null}
> cd your-project
> claude
> ```
>
> 初回使用時に、Claude Code からログインするよう促されます。`ANTHROPIC_API_KEY` 環境変数を設定しており、そのキーを使用するかどうか Claude Code に尋ねられたときに承認すると、Claude Code はログインプロンプトをスキップします。[クイックスタートに進む →](https://code.claude.com/docs/ja/quickstart.md)
>
> > [!TIP]
> >
> > インストールオプション、手動更新、またはアンインストール手順については [高度なセットアップ](https://code.claude.com/docs/ja/setup.md) を参照してください。問題が発生した場合は [インストールのトラブルシューティング](https://code.claude.com/docs/ja/troubleshoot-install.md) にアクセスしてください。

> [tab] VS Code
>
> VS Code 拡張機能は、インラインの差分表示、@-メンション、プラン確認、会話履歴をエディター内で直接提供します。
>
> * [VS Code 用にインストール](vscode:extension/anthropic.claude-code)
> * [Cursor 用にインストール](cursor:extension/anthropic.claude-code)
>
> または、拡張機能ビュー（Mac では `Cmd+Shift+X`、Windows/Linux では `Ctrl+Shift+X`）で「Claude Code」を検索してください。インストール後、コマンドパレット（`Cmd+Shift+P` / `Ctrl+Shift+P`）を開き、「Claude Code」と入力して、**新しいタブで開く** を選択します。
>
> [VS Code ではじめる →](https://code.claude.com/docs/ja/vs-code.md#get-started)

> [tab] Desktop app
>
> IDE またはターミナルの外で Claude Code を実行するためのスタンドアロンアプリです。差分を視覚的に確認し、複数のセッションを並行実行し、定期的なタスクをスケジュール設定し、クラウドセッションを開始できます。
>
> ダウンロードしてインストール：
>
> * [macOS](https://claude.ai/api/desktop/darwin/universal/dmg/latest/redirect?utm_source=claude_code\&utm_medium=docs)（Intel および Apple Silicon）
> * [Windows](https://claude.ai/api/desktop/win32/x64/setup/latest/redirect?utm_source=claude_code\&utm_medium=docs)（x64）
> * [Windows ARM64](https://claude.ai/api/desktop/win32/arm64/setup/latest/redirect?utm_source=claude_code\&utm_medium=docs)
> * Ubuntu または Debian では、アプリはベータ版です。[Linux インストール手順](https://code.claude.com/docs/ja/desktop-linux.md)に従って apt でインストールしてください。
>
> インストール後、Claude を起動し、サインインして、**Code** タブをクリックしてコーディングを開始します。アプリには Claude Code が含まれているため、CLI を別途インストールする必要はありません。[有料サブスクリプション](https://claude.com/pricing?utm_source=claude_code\&utm_medium=docs\&utm_content=overview_desktop_pricing)が必要です。
>
> [デスクトップアプリについて詳しく →](https://code.claude.com/docs/ja/desktop-quickstart.md)

> [tab] Web
>
> ローカルセットアップなしでブラウザで Claude Code を実行します。長時間実行されるタスクを開始して完了を待つ、ローカルにないリポジトリで作業する、または複数のタスクを並行実行できます。長期的な作業の場合は、[プロジェクト](https://code.claude.com/docs/ja/claude-projects.md)を作成して、Claude に複数のセッションを調整させることができます。デスクトップブラウザと [iOS および Android 用 Claude アプリ](https://code.claude.com/docs/ja/mobile.md)で利用できます。
>
> [claude.ai/code](https://claude.ai/code) でコーディングを開始します。
>
> [Web ではじめる →](https://code.claude.com/docs/ja/web-quickstart.md)

> [tab] JetBrains
>
> IntelliJ IDEA、PyCharm、WebStorm、その他の JetBrains IDE 用のプラグインで、インタラクティブな差分表示と選択コンテキスト共有機能があります。
>
> JetBrains Marketplace から [Claude Code プラグイン](https://plugins.jetbrains.com/plugin/27310-claude-code-beta-) をインストールして IDE を再起動します。プラグインには Claude Code CLI が必要で、別途インストールしてください。[JetBrains セットアップステップ](https://code.claude.com/docs/ja/jetbrains.md#installation)を参照してください。
>
> [JetBrains ではじめる →](https://code.claude.com/docs/ja/jetbrains.md)

## できること

Claude Code を使用できるいくつかの方法を紹介します：

> [accordion] 先延ばしにしている作業を自動化する
>
> Claude Code は、1 日を費やす退屈なタスクを処理します：テストされていないコードのテスト作成、プロジェクト全体のリントエラー修正、マージコンフリクト解決、依存関係の更新、リリースノートの作成。
>
> ```bash theme={null}
> claude "write tests for the auth module, run them, and fix any failures"
> ```

> [accordion] 機能を構築し、バグを修正する
>
> プレーンテキストで実現したいことを説明します。Claude Code はアプローチを計画し、複数のファイル間でコードを作成し、動作を検証します。
>
> バグの場合は、エラーメッセージを貼り付けるか、症状を説明します。Claude Code はコードベース全体で問題をトレースし、根本原因を特定し、修正を実装します。詳細な例については [一般的なワークフロー](https://code.claude.com/docs/ja/common-workflows.md) を参照してください。

> [accordion] コミットとプルリクエストを作成する
>
> Claude Code は git と直接連携します。変更をステージングし、コミットメッセージを作成し、ブランチを作成し、プルリクエストを開きます。
>
> ```bash theme={null}
> claude "commit my changes with a descriptive message"
> ```
>
> CI では、[GitHub Actions](https://code.claude.com/docs/ja/github-actions.md) または [GitLab CI/CD](https://code.claude.com/docs/ja/gitlab-ci-cd.md) でコードレビューと問題トリアージを自動化できます。

> [accordion] MCP でツールを接続する
>
> [Model Context Protocol（MCP）](https://code.claude.com/docs/ja/mcp.md) は、AI ツールを外部データソースに接続するためのオープンスタンダードです。MCP を使用すると、Claude Code は Google Drive のデザインドキュメントを読み取り、Jira のチケットを更新し、Slack からデータをプルするか、独自のカスタムツーリングを使用できます。[MCP クイックスタート](https://code.claude.com/docs/ja/mcp-quickstart.md) は、最初のサーバーをエンドツーエンドで接続します。

> [accordion] 指示、スキル、フックでカスタマイズする
>
> [`CLAUDE.md`](https://code.claude.com/docs/ja/memory) はプロジェクトルートに追加するマークダウンファイルで、Claude Code はすべてのセッションの開始時に読み取ります。コーディング標準、アーキテクチャの決定、推奨ライブラリ、レビューチェックリストを設定するために使用します。リポジトリに他のコーディングエージェント用の `AGENTS.md` が既にある場合、Claude Code は `CLAUDE.md` の代わりに [それを読み取ることができます](https://code.claude.com/docs/ja/memory.md#agents-md)。Claude は作業しながら [自動メモリ](https://code.claude.com/docs/ja/memory.md#auto-memory) も構築し、ユーザーが何も書かなくてもセッション間で学習内容を保存します。
>
> [スキル](https://code.claude.com/docs/ja/skills.md) を作成して、チームが共有できる反復可能なワークフローをパッケージ化します（`/review-pr` や `/deploy-staging` など）。
>
> [フック](https://code.claude.com/docs/ja/hooks.md) を使用すると、ファイル編集後の自動フォーマットやコミット前のリント実行など、Claude Code アクション前後にシェルコマンドを実行できます。

> [accordion] エージェントを並行実行し、カスタムエージェントを構築する
>
> [複数の Claude Code エージェント](https://code.claude.com/docs/ja/sub-agents.md) を生成して、タスクの異なる部分に同時に取り組みます。リードエージェントが作業を調整し、サブタスクを割り当て、結果をマージします。
>
> 複数の完全なセッションを並行して実行し、1 つの画面から監視するには、[バックグラウンドエージェント](https://code.claude.com/docs/ja/agent-view.md) を使用します。完全にカスタムなワークフローの場合、[Agent SDK](https://code.claude.com/docs/ja/agent-sdk/overview.md) を使用すると、Claude Code のツールと機能を活用した独自のエージェントを構築でき、オーケストレーション、ツールアクセス、権限を完全に制御できます。

> [accordion] CLI でパイプ、スクリプト、自動化する
>
> Claude Code は構成可能で Unix 哲学に従います。ログをパイプで渡し、CI で実行するか、他のツールと連鎖させます：
>
> ```bash theme={null}
> # 最近のログ出力を分析する
> tail -200 app.log | claude -p "Slack me if you see any anomalies"
>
> # CI で翻訳を自動化する
> claude -p "translate new strings into French and raise a PR for review"
>
> # ファイル全体でバルク操作
> git diff main --name-only | claude -p "review these changed files for security issues"
> ```
>
> すべてのコマンドとフラグのセットについては [CLI リファレンス](https://code.claude.com/docs/ja/cli-reference.md) を参照してください。

> [accordion] 定期的なタスクをスケジュール設定する
>
> 繰り返される作業を自動化するためにスケジュールで Claude を実行します：朝の PR レビュー、夜間の CI 障害分析、週次の依存関係監査、または PR マージ後のドキュメント同期。
>
> * [クラウドスケジュールタスク](https://code.claude.com/docs/ja/routines.md)（旧称ルーティン）はクラウドで実行されるため、コンピューターがオフの場合でも実行し続けます。API 呼び出しまたは GitHub イベントでトリガーすることもできます。Web、デスクトップアプリ、または CLI で `/schedule` を実行して作成します。
> * [デスクトップスケジュールタスク](https://code.claude.com/docs/ja/desktop-scheduled-tasks.md) はマシン上で実行され、ローカルファイルとツールに直接アクセスできます
> * [`/loop`](https://code.claude.com/docs/ja/scheduled-tasks) は CLI セッション内でプロンプトを繰り返し、クイックポーリングを行います

> [accordion] どこからでも作業する
>
> セッションは単一のサーフェスに限定されません。コンテキストが変わるにつれて、環境間で作業を移動します：
>
> * デスクから離れて、電話または [リモートコントロール](https://code.claude.com/docs/ja/remote-control.md) を使用した任意のブラウザから作業を続けます
> * [Dispatch](https://code.claude.com/docs/ja/desktop.md#sessions-from-dispatch) にメッセージを送信して、電話からタスクを送信し、作成されたデスクトップセッションを開きます
> * [Web](https://code.claude.com/docs/ja/claude-code-on-the-web.md) または [Claude モバイルアプリ](https://code.claude.com/docs/ja/mobile.md) で長時間実行されるタスクを開始し、`claude --teleport` でターミナルにプルします。Teleport には claude.ai サブスクリプションが必要です。
> * `/desktop` を実行して、現在のターミナルセッションを [デスクトップアプリ](https://code.claude.com/docs/ja/desktop.md) に続行し、差分を視覚的に確認できます。`/desktop` ハンドオフには claude.ai サブスクリプションが必要です。macOS と x64 Windows で利用可能です。
> * チームチャットからタスクをルーティング：[Slack](https://code.claude.com/docs/ja/slack.md) で `@Claude` にメンションしてバグレポートを送信し、プルリクエストを取得します

## Claude Code をどこでも使用する

各 [サーフェス](https://code.claude.com/docs/ja/glossary.md#surface) は同じ基盤となる Claude Code エンジンに接続するため、repo の CLAUDE.md ファイル、設定、MCP サーバーはすべてのサーフェスで機能します。

上記の [Terminal](https://code.claude.com/docs/ja/quickstart.md)、[VS Code](https://code.claude.com/docs/ja/vs-code.md)、[JetBrains](https://code.claude.com/docs/ja/jetbrains.md)、[Desktop](https://code.claude.com/docs/ja/desktop.md)、[Web](https://code.claude.com/docs/ja/claude-code-on-the-web.md) サーフェスを超えて、Claude Code は CI/CD、チャット、ブラウザワークフローと統合します：

| 実現したいこと | 最適なオプション |
| - | - |
| ローカルセッションを電話または別のデバイスから続行する | [リモートコントロール](https://code.claude.com/docs/ja/remote-control.md) |
| Telegram、Discord、iMessage、または独自の webhook からセッションにイベントをプッシュする | [チャネル](https://code.claude.com/docs/ja/channels.md) |
| ローカルでタスクを開始し、モバイルで続行する | [`claude --cloud`](https://code.claude.com/docs/ja/claude-code-on-the-web#from-terminal-to-cloud)、その後 [Claude モバイルアプリ](https://code.claude.com/docs/ja/mobile.md) |
| 定期的なスケジュールで Claude を実行する | [クラウドスケジュールタスク](https://code.claude.com/docs/ja/routines.md) または [Desktop スケジュールタスク](https://code.claude.com/docs/ja/desktop-scheduled-tasks.md) |
| PR レビューと問題トリアージを自動化する | [GitHub Actions](https://code.claude.com/docs/ja/github-actions.md) または [GitLab CI/CD](https://code.claude.com/docs/ja/gitlab-ci-cd.md) |
| すべての PR で自動コードレビューを取得する | [GitHub Code Review](https://code.claude.com/docs/ja/code-review.md) |
| Slack からプルリクエストへバグレポートをルーティングする | [Slack](https://code.claude.com/docs/ja/slack.md) |
| ライブ Web アプリケーションをデバッグする | [Chrome](https://code.claude.com/docs/ja/chrome.md) |
| 独自のワークフロー用のカスタムエージェントを構築する | [Agent SDK](https://code.claude.com/docs/ja/agent-sdk/overview.md) |

## 次のステップ

Claude Code をインストールしたら、これらのガイドでさらに詳しく学べます。

* [クイックスタート](https://code.claude.com/docs/ja/quickstart.md)：コードベースの探索から修正のコミットまで、最初の実際のタスクを実行します
* [指示とメモリを保存する](https://code.claude.com/docs/ja/memory.md)：CLAUDE.md ファイルと自動メモリで Claude に永続的な指示を与えます
* [一般的なワークフロー](https://code.claude.com/docs/ja/common-workflows.md) と [ベストプラクティス](https://code.claude.com/docs/ja/best-practices.md)：Claude Code から最大限の価値を得るためのパターン
* [Claude Academy](https://academy.claude.com/)：無料の自習コース。[Claude Code 101](https://academy.claude.com/courses/claude-code-101) と [Claude Code in Action](https://academy.claude.com/courses/claude-code-in-action) を含みます
* [すべてのタスクのためのハーネス](https://claude.com/blog/a-harness-for-every-task-dynamic-workflows-in-claude-code)：Claude Code チームが [動的ワークフロー](https://code.claude.com/docs/ja/workflows.md) を使用して大規模にサブエージェントを調整する方法
* [設定](https://code.claude.com/docs/ja/settings.md)：ワークフローに合わせて Claude Code をカスタマイズします
* [トラブルシューティング](https://code.claude.com/docs/ja/troubleshooting.md)：一般的な問題の解決策
* [code.claude.com](https://code.claude.com/)：デモ、価格設定、製品の詳細
