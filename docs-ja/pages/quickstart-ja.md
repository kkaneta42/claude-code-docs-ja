> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# クイックスタート

> ターミナルに Claude Code をインストールしてサインインし、CLI を使ってコードベースを探索して最初のコード変更を行います。

このクイックスタートでは、ターミナルでの Claude Code の使い方を説明します。CLI のインストール、最初のセッションからのサインイン、そして自分のプロジェクトでの一般的な開発タスクへの活用方法を扱います。

## 始める前に

以下を確認してください：

* ターミナルまたはコマンドプロンプトが開いている
* 作業するコードプロジェクトがある
* [Claude サブスクリプション](https://claude.com/pricing?utm_source=claude_code\&utm_medium=docs\&utm_content=quickstart_prereq)（Pro、Max、Ultra、Team、または Enterprise）、[Claude Console](https://platform.claude.com/) アカウント、または[サポートされているクラウドプロバイダー](https://code.claude.com/docs/ja/third-party-integrations.md)経由のアクセスがある

> [!NOTE]
>
> 以下のケースについては、他のページで説明しています：
>
> * **ターミナルを使用したことがない場合**：[ターミナルガイド](https://code.claude.com/docs/ja/terminal-guide)から始めてください
> * **ターミナル以外の場所で Claude Code を使用したい場合**：Claude Code は[ウェブ](https://claude.ai/code)、[デスクトップアプリ](https://code.claude.com/docs/ja/desktop.md)、[VS Code](https://code.claude.com/docs/ja/vs-code.md) および [JetBrains IDE](https://code.claude.com/docs/ja/jetbrains.md)、[Slack](https://code.claude.com/docs/ja/slack.md)、および [GitHub Actions](https://code.claude.com/docs/ja/github-actions.md) と [GitLab](https://code.claude.com/docs/ja/gitlab-ci-cd.md) を使用した CI/CD でも利用できます。[すべてのインターフェース](https://code.claude.com/docs/ja/overview.md#use-claude-code-everywhere)を参照してください。

## ステップ 1：Claude Code をインストールする

Claude Code をインストールするには、ターミナルを開いてシステムのコマンドを実行してください。ターミナルを使用したことがない場合は、[ターミナルガイド](https://code.claude.com/docs/ja/terminal-guide)でターミナルを開いてコマンドを貼り付ける方法を確認できます。

> [tab] ネイティブインストール（推奨）
>
> **macOS、Linux、WSL：**
>
> ```bash theme={null}
> curl -fsSL https://claude.ai/install.sh | bash
> ```
>
> Windows では、PowerShell を使用している場合はシェルプロンプトに `PS C:\` と表示され、CMD を使用している場合は `PS` なしで `C:\` と表示されます。
>
> **Windows PowerShell：**
>
> ```powershell theme={null}
> irm https://claude.ai/install.ps1 | iex
> ```
>
> **Windows CMD：**
>
> ```batch theme={null}
> curl -fsSL https://claude.ai/install.cmd -o install.cmd && install.cmd && del install.cmd
> ```
>
> インストールコマンドは、Claude Code のダウンロード中に進行状況を表示しません。インストーラーが完了したら、新しいターミナルウィンドウを開いて `claude --version` を実行してください。インストールが正常に完了すると、バージョン番号が表示されます。シェルが `claude` が見つからない、または認識されていないと表示される場合は、インストールディレクトリがまだ PATH に含まれていません。[PATH を修正する](https://code.claude.com/docs/ja/troubleshoot-install.md#command-not-found-claude-after-installation)を参照してください。
>
> `The token '&&' is not a valid statement separator` というエラーが表示される場合は、CMD ではなく PowerShell を使用しています。`'irm' is not recognized as an internal or external command` というエラーが表示される場合は、PowerShell ではなく CMD を使用しています。
>
> インストールコマンドが `syntax error near unexpected token '<'`、`403`、またはその他のエラーで失敗する場合は、[インストールのトラブルシューティング](https://code.claude.com/docs/ja/troubleshoot-install.md#find-your-error)を参照して、エラーを修正方法に照合し、代替インストール方法を確認してください。
>
> [Git for Windows](https://git-scm.com/downloads/win) は、Claude Code が Bash ツールを使用できるようにネイティブ Windows で推奨されます。Git for Windows がインストールされていない場合、Claude Code はシェルツールとして PowerShell を代わりに使用します。WSL セットアップは Git for Windows を必要としません。
>
> > [!NOTE]
> >
> > ネイティブインストールは、最新バージョンに保つために自動的にバックグラウンドで更新されます。

> [tab] Homebrew
>
> ```bash theme={null}
> brew install --cask claude-code
> ```
>
> Homebrew は 2 つの cask を提供しています。`claude-code` は安定リリースチャネルを追跡しており、通常は約 1 週間遅れており、大きな回帰を伴うリリースをスキップします。`claude-code@latest` は最新チャネルを追跡し、新しいバージョンが出荷されるとすぐに受け取ります。
>
> > [!NOTE]
> >
> > Homebrew インストールは自動更新されません。インストールした cask に応じて、`brew upgrade claude-code` または `brew upgrade claude-code@latest` を実行して、最新の機能とセキュリティ修正を取得してください。

> [tab] WinGet
>
> ```powershell theme={null}
> winget install Anthropic.ClaudeCode
> ```
>
> > [!NOTE]
> >
> > WinGet インストールは自動更新されません。最新の機能とセキュリティ修正を取得するために、定期的に `winget upgrade Anthropic.ClaudeCode` を実行してください。

また、Debian、Fedora、RHEL、Alpine で [apt、dnf、または apk](https://code.claude.com/docs/ja/setup.md#install-with-linux-package-managers) を使用してインストールすることもできます。

インストールが正常に機能したことを確認するには、以下を実行してください：

```bash theme={null}
claude --version
```

このコマンドは、バージョン番号の後に `(Claude Code)` を出力します。

## ステップ 2: 最初のセッションを開始する

任意のプロジェクトディレクトリでターミナルを開き、Claude Code を起動します。

```bash theme={null}
cd /path/to/your/project
claude
```

`/path/to/your/project` は、作業したいプロジェクトのパスに置き換えてください。

初回使用時には、Claude Code からログインを求められます。Claude サブスクリプションまたは Console アカウントの場合は、表示される指示に従ってブラウザで認証を完了してください。`ANTHROPIC_API_KEY` 環境変数を設定しており、Claude Code からそのキーを使用するかどうか尋ねられた際に承認した場合、Claude Code はログインプロンプトをスキップします。

次のいずれかのアカウントタイプでログインできます。

* [Claude Pro、Max、Ultra、Team、または Enterprise](https://claude.com/pricing?utm_source=claude_code\&utm_medium=docs\&utm_content=quickstart_login)（推奨）
* [Claude Console](https://platform.claude.com/)（前払いクレジットによる API アクセス）。初回ログイン時に、コストを一元的に追跡するための「Claude Code」ワークスペースが Console に自動的に作成されます。
* [Amazon Bedrock、Google Cloud の Agent Platform、または Microsoft Foundry](https://code.claude.com/docs/ja/third-party-integrations.md)（エンタープライズ向けクラウドプロバイダー）
* 組織で運用している場合は、セルフホストの [Claude apps ゲートウェイ](https://code.claude.com/docs/ja/claude-apps-gateway)：管理者がゲートウェイ URL を事前に設定しており、`/login` を実行すると **Cloud gateway** 画面が直接開くので、企業の SSO でサインインします

一度ログインすると認証情報が保存されるため、再度ログインする必要はありません。詳しくは[認証情報の管理](https://code.claude.com/docs/ja/authentication.md#credential-management)を参照してください。

Claude Code のプロンプトが表示され、その上にバージョン、現在のモデル、作業ディレクトリが表示されます。`/help` と入力すると利用可能なコマンドが表示され、`/resume` と入力すると以前の会話を再開できます。後でアカウントを切り替えたり再認証したりするには、実行中のセッション内で `/login` と入力します。

## ステップ 3: 最初の質問をする

次のいずれかのコマンドを試してください：

```text wrap theme={null}
what does this project do?
```

Claude がファイルを分析し、概要を提示します。より具体的な質問をすることもできます：

```text wrap theme={null}
what technologies does this project use?
```

```text wrap theme={null}
where is the main entry point?
```

```text wrap theme={null}
explain the folder structure
```

Claude 自身の機能について質問することもできます：

```text wrap theme={null}
what can Claude Code do?
```

```text wrap theme={null}
how do I create custom skills in Claude Code?
```

```text wrap theme={null}
can Claude Code work with Docker?
```

> [!NOTE]
>
> Claude Code は必要に応じてプロジェクトファイルを読み取ります。コンテキストを手動で追加する必要はありません。

## ステップ 4: 最初のコード変更を行う

小さなタスクを試してみましょう。

```text wrap theme={null}
add a hello world function to the main file
```

Claude Code は適切なファイルを見つけ、変更内容を表示します。変更を行う前に確認を求められた場合は、**Yes** を選択して承認します。

セッションの[権限モード](https://code.claude.com/docs/ja/permission-modes.md)は、Claude が事前に確認せずに実行できるアクションを決定します。`Shift+Tab` を押すと、いつでも現在のセッションの権限モードを切り替えられます。

## ステップ 5：Claude Code で Git を使用する

Claude Code を使うと、Git の操作を会話形式で行えます：

```text wrap theme={null}
what files have I changed?
```

```text wrap theme={null}
commit my changes with a descriptive message
```

より複雑な Git 操作をプロンプトで依頼することもできます：

```text wrap theme={null}
create a new branch called feature/quickstart
```

```text wrap theme={null}
show me the last 5 commits
```

```text wrap theme={null}
help me resolve merge conflicts
```

## ステップ 6: バグを修正する、または機能を追加する

やりたいことを自然言語で説明します。

```text wrap theme={null}
add input validation to the user registration form
```

既存の問題を修正することもできます。

```text wrap theme={null}
there's a bug where users can submit empty forms - fix it
```

## ステップ 7: その他の一般的なワークフローを試す

さらにいくつかのプロンプトを試してみましょう。Claude にコードのリファクタリング、テストの作成、ドキュメントの更新、変更内容のレビューを依頼できます。

```text wrap theme={null}
refactor the authentication module to use async/await instead of callbacks
```

```text wrap theme={null}
write unit tests for the calculator functions
```

```text wrap theme={null}
update the README with installation instructions
```

```text wrap theme={null}
review my changes and suggest improvements
```

> [!TIP]
>
> 頼りになる同僚に話しかけるように Claude に話しかけてください。達成したいことを説明すれば、Claude がその実現を手助けします。

## 必須コマンド

日常的に使用する最も重要なコマンドを、実行する場所ごとにまとめて以下に示します。

### シェルコマンド

これらはターミナルから実行して Claude Code を開始または再開します。

| コマンド | 機能 | 例 |
| - | - | - |
| `claude` | インタラクティブモードを開始する | `claude` |
| `claude "task"` | 初期プロンプト付きでインタラクティブモードを開始する | `claude "fix the build error"` |
| `claude -p "query"` | 1 回限りのクエリを実行してから終了する | `claude -p "explain this function"` |
| `claude -c` | 現在のディレクトリで最新の会話を続行する | `claude -c` |
| `claude -r` | 前の会話を再開する | `claude -r` |

シェルコマンドの完全なリストについては [CLI リファレンス](https://code.claude.com/docs/ja/cli-reference.md)を参照してください。

### セッションコマンド

これらは Claude Code の起動後にその中で実行します。

| コマンド | 機能 | 例 |
| - | - | - |
| `/clear` | 会話履歴をクリアする | `/clear` |
| `/help` | 利用可能なコマンドを表示する | `/help` |
| `/exit` または Ctrl+D 2 回 | Claude Code を終了する | `/exit` |

セッションコマンドの完全なリストについては [コマンドリファレンス](https://code.claude.com/docs/ja/commands.md)を参照してください。

## 初心者向けのプロのヒント

詳細については、[ベストプラクティス](https://code.claude.com/docs/ja/best-practices.md)と[一般的なワークフロー](https://code.claude.com/docs/ja/common-workflows.md)を参照してください。

> [accordion] リクエストを具体的にする
>
> 代わりに：'バグを修正してください'
>
> 試してください：'ユーザーが間違った認証情報を入力した後に空白の画面が表示されるログインバグを修正してください'

> [accordion] 段階的な指示を使用する
>
> 複雑なタスクをステップに分割します：
>
> ```text wrap theme={null}
> 1. ユーザープロファイル用の新しいデータベーステーブルを作成する
> 2. ユーザープロファイルを取得および更新するための API エンドポイントを作成する
> 3. ユーザーが自分の情報を表示および編集できるウェブページを構築する
> ```

> [accordion] Claude に最初に探索させる
>
> 変更を加える前に、Claude にコードを理解させます：
>
> ```text wrap theme={null}
> データベーススキーマを分析する
> ```
>
> ```text wrap theme={null}
> 英国の顧客によって最も頻繁に返品される製品を表示するダッシュボードを構築する
> ```

> [accordion] ショートカットで時間を節約する
>
> * `/` を入力してすべてのコマンドとスキルを表示する
> * Tab キーでコマンド補完を使用する
> * ↑ キーでコマンド履歴を表示する
> * `Shift+Tab` を押して権限モードをサイクルさせる

## 次のステップ

基本を学習したので、より高度な機能を探索してください：

* [Claude Code の仕組み](https://code.claude.com/docs/ja/how-claude-code-works.md)：エージェント型ループ、組み込みツール、および Claude Code がプロジェクトと相互作用する方法を理解する
* [ベストプラクティス](https://code.claude.com/docs/ja/best-practices.md)：効果的なプロンプティングとプロジェクト設定でより良い結果を得る
* [一般的なワークフロー](https://code.claude.com/docs/ja/common-workflows.md)：一般的なタスクのステップバイステップガイド
* [Claude Code を拡張する](https://code.claude.com/docs/ja/features-overview.md)：CLAUDE.md、スキル、フック、MCP などでカスタマイズする

インストールオプション、手動アップデート、またはアンインストール手順については、[高度なセットアップ](https://code.claude.com/docs/ja/setup.md)を参照してください。

## ヘルプを取得する

* **Claude Code 内**：`/help` を入力するか、「how do I」という質問をする
* **ドキュメント**：このサイトの他のガイドを参照する
* **コース**：[Claude Code 101](https://academy.claude.com/courses/claude-code-101) と [Claude Academy](https://academy.claude.com/) の他の無料のセルフペースコースを受講する
* **コミュニティ**：[Discord サーバー](https://www.anthropic.com/discord) に参加してヒントとサポートを得る
