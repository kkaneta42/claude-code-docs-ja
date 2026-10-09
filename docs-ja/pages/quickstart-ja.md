> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# クイックスタート

> ターミナルに Claude Code をインストールしてサインインし、CLI を使ってコードベースを探索して最初のコード変更を行います。

このクイックスタートでは、ターミナルでの Claude Code の使い方を説明します。CLI のインストール、最初のセッションからのサインイン、そして自分のプロジェクトでの一般的な開発タスクへの活用方法を扱います。

<h2 id="before-you-begin">
  始める前に
</h2>

以下を確認してください：

* ターミナルまたはコマンドプロンプトが開いている
* 作業するコードプロジェクトがある
* [Claude サブスクリプション](https://claude.com/pricing?utm_source=claude_code\&utm_medium=docs\&utm_content=quickstart_prereq)（Pro、Max、Team、または Enterprise）、[Claude Console](https://platform.claude.com/) アカウント、または[サポートされているクラウドプロバイダー](/docs/ja/third-party-integrations)経由のアクセスがある

<Note>
  以下のケースについては、他のページで説明しています：

  * **ターミナルを使用したことがない場合**：[ターミナルガイド](/docs/ja/terminal-guide)から始めてください
  * **ターミナル以外の場所で Claude Code を使用したい場合**：Claude Code は[ウェブ](https://claude.ai/code)、[デスクトップアプリ](/docs/ja/desktop)、[VS Code](/docs/ja/vs-code) および [JetBrains IDE](/docs/ja/jetbrains)、[Slack](/docs/ja/slack)、および [GitHub Actions](/docs/ja/github-actions) と [GitLab](/docs/ja/gitlab-ci-cd) を使用した CI/CD でも利用できます。[すべてのインターフェース](/docs/ja/overview#use-claude-code-everywhere)を参照してください。
</Note>

<h2 id="step-1-install-claude-code">
  ステップ 1：Claude Code をインストールする
</h2>

Claude Code をインストールするには、ターミナルを開いてシステムのコマンドを実行してください。ターミナルを使用したことがない場合は、[ターミナルガイド](/docs/ja/terminal-guide)でターミナルを開いてコマンドを貼り付ける方法を確認できます。

<Tabs>
  <Tab title="ネイティブインストール（推奨）">
    **macOS、Linux、WSL：**

    ```bash theme={null}
    curl -fsSL https://claude.ai/install.sh | bash
    ```

    Windows では、PowerShell を使用している場合はシェルプロンプトに `PS C:\` と表示され、CMD を使用している場合は `PS` なしで `C:\` と表示されます。

    **Windows PowerShell：**

    ```powershell theme={null}
    irm https://claude.ai/install.ps1 | iex
    ```

    **Windows CMD：**

    ```batch theme={null}
    curl -fsSL https://claude.ai/install.cmd -o install.cmd && install.cmd && del install.cmd
    ```

    インストールコマンドは、Claude Code のダウンロード中に進行状況を表示しません。インストーラーが完了したら、新しいターミナルウィンドウを開いて `claude --version` を実行してください。インストールが正常に完了すると、バージョン番号が表示されます。シェルが `claude` が見つからない、または認識されていないと表示される場合は、インストールディレクトリがまだ PATH に含まれていません。[PATH を修正する](/docs/ja/troubleshoot-install#command-not-found-claude-after-installation)を参照してください。

    `The token '&&' is not a valid statement separator` というエラーが表示される場合は、CMD ではなく PowerShell を使用しています。`'irm' is not recognized as an internal or external command` というエラーが表示される場合は、PowerShell ではなく CMD を使用しています。

    インストールコマンドが `syntax error near unexpected token '<'`、`403`、またはその他のエラーで失敗する場合は、[インストールのトラブルシューティング](/docs/ja/troubleshoot-install#find-your-error)を参照して、エラーを修正方法に照合し、代替インストール方法を確認してください。

    [Git for Windows](https://git-scm.com/downloads/win) は、Claude Code が Bash ツールを使用できるようにネイティブ Windows で推奨されます。Git for Windows がインストールされていない場合、Claude Code はシェルツールとして PowerShell を代わりに使用します。WSL セットアップは Git for Windows を必要としません。

    <Info>
      ネイティブインストールは、最新バージョンに保つために自動的にバックグラウンドで更新されます。
    </Info>
  </Tab>

  <Tab title="Homebrew">
    ```bash theme={null}
    brew install --cask claude-code
    ```

    Homebrew は 2 つの cask を提供しています。`claude-code` は安定リリースチャネルを追跡しており、通常は約 1 週間遅れており、大きな回帰を伴うリリースをスキップします。`claude-code@latest` は最新チャネルを追跡し、新しいバージョンが出荷されるとすぐに受け取ります。

    <Info>
      Homebrew インストールは自動更新されません。インストールした cask に応じて、`brew upgrade claude-code` または `brew upgrade claude-code@latest` を実行して、最新の機能とセキュリティ修正を取得してください。
    </Info>
  </Tab>

  <Tab title="WinGet">
    ```powershell theme={null}
    winget install Anthropic.ClaudeCode
    ```

    <Info>
      WinGet インストールは自動更新されません。最新の機能とセキュリティ修正を取得するために、定期的に `winget upgrade Anthropic.ClaudeCode` を実行してください。
    </Info>
  </Tab>
</Tabs>

また、Debian、Fedora、RHEL、Alpine で [apt、dnf、または apk](/docs/ja/setup#install-with-linux-package-managers) を使用してインストールすることもできます。

インストールが正常に機能したことを確認するには、以下を実行してください：

```bash theme={null}
claude --version
```

このコマンドは、バージョン番号の後に `(Claude Code)` を出力します。

<h2 id="step-2-start-your-first-session">
  ステップ 2: 最初のセッションを開始する
</h2>

任意のプロジェクトディレクトリでターミナルを開き、Claude Code を起動します。

```bash theme={null}
cd /path/to/your/project
claude
```

`/path/to/your/project` は、作業したいプロジェクトのパスに置き換えてください。

初回使用時には、Claude Code からログインを求められます。Claude サブスクリプションまたは Console アカウントの場合は、表示される指示に従ってブラウザで認証を完了してください。`ANTHROPIC_API_KEY` 環境変数を設定しており、Claude Code からそのキーを使用するかどうか尋ねられた際に承認した場合、Claude Code はログインプロンプトをスキップします。

次のいずれかのアカウントタイプでログインできます。

* [Claude Pro、Max、Team、または Enterprise](https://claude.com/pricing?utm_source=claude_code\&utm_medium=docs\&utm_content=quickstart_login)（推奨）
* [Claude Console](https://platform.claude.com/)（前払いクレジットによる API アクセス）。初回ログイン時に、コストを一元的に追跡するための「Claude Code」ワークスペースが Console に自動的に作成されます。
* [Amazon Bedrock、Google Cloud の Agent Platform、または Microsoft Foundry](/docs/ja/third-party-integrations)（エンタープライズ向けクラウドプロバイダー）
* 組織で運用している場合は、セルフホストの [Claude apps ゲートウェイ](/docs/ja/claude-apps-gateway)：管理者がゲートウェイ URL を事前に設定しており、`/login` を実行すると **Cloud gateway** 画面が直接開くので、企業の SSO でサインインします

一度ログインすると認証情報が保存されるため、再度ログインする必要はありません。詳しくは[認証情報の管理](/docs/ja/authentication#credential-management)を参照してください。

Claude Code のプロンプトが表示され、その上にバージョン、現在のモデル、作業ディレクトリが表示されます。`/help` と入力すると利用可能なコマンドが表示され、`/resume` と入力すると以前の会話を再開できます。後でアカウントを切り替えたり再認証したりするには、実行中のセッション内で `/login` と入力します。

<h2 id="step-3-ask-your-first-question">
  ステップ 3: 最初の質問をする
</h2>

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

<Note>
  Claude Code は必要に応じてプロジェクトファイルを読み取ります。コンテキストを手動で追加する必要はありません。
</Note>

<h2 id="step-4-make-your-first-code-change">
  ステップ 4: 最初のコード変更を行う
</h2>

小さなタスクを試してみましょう。

```text wrap theme={null}
add a hello world function to the main file
```

Claude Code は適切なファイルを見つけ、変更内容を表示します。変更を行う前に確認を求められた場合は、**Yes** を選択して承認します。

セッションの[権限モード](/docs/ja/permission-modes)は、Claude が事前に確認せずに実行できるアクションを決定します。`Shift+Tab` を押すと、いつでも現在のセッションの権限モードを切り替えられます。

<h2 id="step-5-use-git-with-claude-code">
  ステップ 5：Claude Code で Git を使用する
</h2>

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

<h2 id="step-6-fix-a-bug-or-add-a-feature">
  ステップ 6: バグを修正する、または機能を追加する
</h2>

やりたいことを自然言語で説明します。

```text wrap theme={null}
add input validation to the user registration form
```

既存の問題を修正することもできます。

```text wrap theme={null}
there's a bug where users can submit empty forms - fix it
```

<h2 id="step-7-test-out-other-common-workflows">
  ステップ 7: その他の一般的なワークフローを試す
</h2>

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

<Tip>
  頼りになる同僚に話しかけるように Claude に話しかけてください。達成したいことを説明すれば、Claude がその実現を手助けします。
</Tip>

<h2 id="essential-commands">
  必須コマンド
</h2>

日常的に使用する最も重要なコマンドを、実行する場所ごとにまとめて以下に示します。

<h3 id="shell-commands">
  シェルコマンド
</h3>

これらはターミナルから実行して Claude Code を開始または再開します。

| コマンド | 機能 | 例 |
| - | - | - |
| `claude` | インタラクティブモードを開始する | `claude` |
| `claude "task"` | 初期プロンプト付きでインタラクティブモードを開始する | `claude "fix the build error"` |
| `claude -p "query"` | 1 回限りのクエリを実行してから終了する | `claude -p "explain this function"` |
| `claude -c` | 現在のディレクトリで最新の会話を続行する | `claude -c` |
| `claude -r` | 前の会話を再開する | `claude -r` |

シェルコマンドの完全なリストについては [CLI リファレンス](/docs/ja/cli-reference)を参照してください。

<h3 id="session-commands">
  セッションコマンド
</h3>

これらは Claude Code の起動後にその中で実行します。

| コマンド | 機能 | 例 |
| - | - | - |
| `/clear` | 会話履歴をクリアする | `/clear` |
| `/help` | 利用可能なコマンドを表示する | `/help` |
| `/exit` または Ctrl+D 2 回 | Claude Code を終了する | `/exit` |

セッションコマンドの完全なリストについては [コマンドリファレンス](/docs/ja/commands)を参照してください。

<h2 id="pro-tips-for-beginners">
  初心者向けのプロのヒント
</h2>

詳細については、[ベストプラクティス](/docs/ja/best-practices)と[一般的なワークフロー](/docs/ja/common-workflows)を参照してください。

<AccordionGroup>
  <Accordion title="リクエストを具体的にする">
    代わりに：'バグを修正してください'

    試してください：'ユーザーが間違った認証情報を入力した後に空白の画面が表示されるログインバグを修正してください'
  </Accordion>

  <Accordion title="段階的な指示を使用する">
    複雑なタスクをステップに分割します：

    ```text wrap theme={null}
    1. ユーザープロファイル用の新しいデータベーステーブルを作成する
    2. ユーザープロファイルを取得および更新するための API エンドポイントを作成する
    3. ユーザーが自分の情報を表示および編集できるウェブページを構築する
    ```
  </Accordion>

  <Accordion title="Claude に最初に探索させる">
    変更を加える前に、Claude にコードを理解させます：

    ```text wrap theme={null}
    データベーススキーマを分析する
    ```

    ```text wrap theme={null}
    英国の顧客によって最も頻繁に返品される製品を表示するダッシュボードを構築する
    ```
  </Accordion>

  <Accordion title="ショートカットで時間を節約する">
    * `/` を入力してすべてのコマンドとスキルを表示する
    * Tab キーでコマンド補完を使用する
    * ↑ キーでコマンド履歴を表示する
    * `Shift+Tab` を押して権限モードをサイクルさせる
  </Accordion>
</AccordionGroup>

<h2 id="what’s-next">
  次のステップ
</h2>

基本を学習したので、より高度な機能を探索してください：

* [Claude Code の仕組み](/docs/ja/how-claude-code-works)：エージェント型ループ、組み込みツール、および Claude Code がプロジェクトと相互作用する方法を理解する
* [ベストプラクティス](/docs/ja/best-practices)：効果的なプロンプティングとプロジェクト設定でより良い結果を得る
* [一般的なワークフロー](/docs/ja/common-workflows)：一般的なタスクのステップバイステップガイド
* [Claude Code を拡張する](/docs/ja/features-overview)：CLAUDE.md、スキル、フック、MCP などでカスタマイズする

インストールオプション、手動アップデート、またはアンインストール手順については、[高度なセットアップ](/docs/ja/setup)を参照してください。

<h2 id="getting-help">
  ヘルプを取得する
</h2>

* **Claude Code 内**：`/help` を入力するか、「how do I」という質問をする
* **ドキュメント**：このサイトの他のガイドを参照する
* **コース**：[Claude Code 101](https://academy.claude.com/courses/claude-code-101) と [Claude Academy](https://academy.claude.com/) の他の無料のセルフペースコースを受講する
* **コミュニティ**：[Discord サーバー](https://www.anthropic.com/discord) に参加してヒントとサポートを得る
