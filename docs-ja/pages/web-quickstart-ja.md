> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# Claude Code をウェブで始める

> ブラウザまたはスマートフォンからクラウドで Claude Code を実行します。GitHub リポジトリを接続し、タスクを送信し、ローカルセットアップなしで PR をレビューします。

<Note>
  Claude Code on the web は、Pro、Max、Team ユーザー、および premium seats または Chat + Claude Code seats を持つ Enterprise ユーザーを対象とした研究プレビュー版です。
</Note>

Claude Code on the web は、あなたのマシンではなく Anthropic が管理するクラウドインフラストラクチャで実行されます。ブラウザまたは Claude モバイルアプリから [claude.ai/code](https://claude.ai/code) でタスクを送信します。

[始めるには](#connect-github-and-create-an-environment) GitHub リポジトリが必要です。Claude はそれを分離された仮想マシンにクローンし、変更を加え、レビュー用のブランチをプッシュします。セッションはデバイス間で永続化されるため、ラップトップで開始したタスクは後でスマートフォンからレビューする準備ができています。

Claude Code on the web は以下に適しています：

* **並列タスク**：複数の worktrees を管理することなく、複数の独立したタスクを同時に実行し、それぞれ独自のセッションとブランチで実行します
* **ローカルにないリポジトリ**：Claude はセッションごとにリポジトリを新規クローンするため、チェックアウトする必要がありません
* **頻繁なステアリングが不要なタスク**：明確に定義されたタスクを送信し、他のことをして、Claude が完了したときに結果をレビューします
* **コードの質問と探索**：ローカルチェックアウトなしでコードベースを理解したり、機能がどのように実装されているかをトレースします

ローカル設定、ツール、または環境が必要な作業の場合は、Claude Code をローカルで実行するか、[Remote Control](/ja/remote-control) を使用する方が適しています。

## セッションの実行方法

タスクを送信すると：

1. **クローンと準備**：リポジトリが Anthropic が管理する VM にクローンされ、設定されている場合は [setup script](/ja/claude-code-on-the-web#setup-scripts) が実行されます。
2. **ネットワークの設定**：インターネットアクセスは環境の [access level](/ja/claude-code-on-the-web#access-levels) に基づいて設定されます。
3. **作業**：Claude はコードを分析し、変更を加え、テストを実行し、その作業をチェックします。全体を監視してステアリングすることも、完了したら戻ってくることもできます。
4. **ブランチをプッシュ**：Claude が停止ポイントに達すると、ブランチを GitHub にプッシュします。diff をレビューし、インラインコメントを残し、PR を作成するか、別のメッセージを送信して続行します。

ブランチがプッシュされてもセッションは閉じません。PR の作成とさらなる編集はすべて同じ会話内で行われます。

## Claude Code を実行する方法を比較

Claude Code はどこでも同じように動作します。変わるのは、コードが実行される場所とローカル設定が利用可能かどうかです。Desktop app は local と cloud の両方のセッションを提供するため、以下の回答はどちらを選択するかによって異なります：

|                                              | On the web                                                                                                      | Remote Control               | Terminal CLI           | Desktop app                 |
| :------------------------------------------- | :-------------------------------------------------------------------------------------------------------------- | :--------------------------- | :--------------------- | :-------------------------- |
| **Code runs on**                             | Anthropic cloud VM                                                                                              | Your machine                 | Your machine           | Your machine or cloud VM    |
| **You chat from**                            | claude.ai or mobile app                                                                                         | claude.ai or mobile app      | Your terminal          | The Desktop UI              |
| **Uses your local config**                   | No, repo only                                                                                                   | Yes                          | Yes                    | Yes for local, no for cloud |
| **Requires GitHub**                          | Yes, or [bundle a local repo](/ja/claude-code-on-the-web#send-local-repositories-without-github) via `--remote` | No                           | No                     | Only for cloud sessions     |
| **Keeps running if you disconnect**          | Yes                                                                                                             | While terminal stays open    | No                     | Depends on session type     |
| **[Permission modes](/ja/permission-modes)** | Auto accept edits, Plan                                                                                         | Ask, Auto accept edits, Plan | All modes              | Depends on session type     |
| **Network access**                           | Configurable per environment                                                                                    | Your machine's network       | Your machine's network | Depends on session type     |

[terminal quickstart](/ja/quickstart)、[Desktop app](/ja/desktop)、または [Remote Control](/ja/remote-control) ドキュメントを参照して、それらをセットアップしてください。

## GitHub を接続して環境を作成

セットアップは 1 回限りのプロセスです。既に GitHub CLI を使用している場合は、ブラウザの代わりに [ターミナルからこれを実行](#connect-from-your-terminal) できます。

<Steps>
  <Step title="claude.ai/code にアクセス">
    [claude.ai/code](https://claude.ai/code) にアクセスし、Anthropic アカウントでサインインします。
  </Step>

  <Step title="Claude GitHub App をインストール">
    サインイン後、claude.ai/code は GitHub に接続するよう促します。プロンプトに従って Claude GitHub App をインストールし、リポジトリへのアクセスを許可します。Cloud セッションは既存の GitHub リポジトリで機能するため、新しいプロジェクトを開始するには、まず [GitHub に空のリポジトリを作成](https://github.com/new) してください。
  </Step>

  <Step title="環境を作成">
    GitHub を接続した後、cloud 環境を作成するよう促されます。環境は、セッション中に Claude が持つネットワークアクセスと、新しいセッションが作成されたときに実行される内容を制御します。設定なしで利用可能な内容については、[Installed tools](/ja/claude-code-on-the-web#installed-tools) を参照してください。

    フォームには以下のフィールドがあります：

    * **Name**：表示ラベル。異なるプロジェクトまたはアクセスレベル用に複数の環境がある場合に便利です。
    * **Network access**：セッションがインターネット上で到達できるものを制御します。デフォルトの `Trusted` は、npm、PyPI、RubyGems などの [common package registries](/ja/claude-code-on-the-web#default-allowed-domains) への接続を許可しながら、一般的なインターネットアクセスをブロックします。
    * **Environment variables**：すべてのセッションで利用可能なオプション変数（`.env` 形式）。値をクォートで囲まないでください。クォートは値の一部として保存されるためです。これらは、この環境を編集できるすべてのユーザーに表示されます。
    * **Setup script**：Claude Code が起動する前に実行されるオプションの Bash スクリプト。cloud VM に含まれていない `apt install -y gh` などのシステムツールをインストールするために使用します。結果は [cached](/ja/claude-code-on-the-web#environment-caching) されるため、スクリプトはセッションごとに再実行されません。例とデバッグのヒントについては、[Setup scripts](/ja/claude-code-on-the-web#setup-scripts) を参照してください。

    最初のプロジェクトの場合は、デフォルトのままにして **Create environment** をクリックします。後で [環境を編集したり、異なるプロジェクト用に追加の環境を作成](/ja/claude-code-on-the-web#configure-your-environment) できます。
  </Step>
</Steps>

### ターミナルから接続

既に GitHub CLI（`gh`）を使用している場合は、ブラウザを開かずに Claude Code on the web をセットアップできます。これには [Claude Code CLI](/ja/quickstart) が必要です。`/web-setup` はローカルの `gh` トークンを読み取り、Claude アカウントにリンクし、cloud 環境がない場合はデフォルトの cloud 環境を作成します。

<Note>
  [Zero Data Retention](/ja/zero-data-retention) が有効な Organization は `/web-setup` または他の cloud セッション機能を使用できません。GitHub CLI がインストールされていない、または認証されていない場合、`/web-setup` はブラウザオンボーディングフローを開きます。
</Note>

<Steps>
  <Step title="GitHub CLI で認証">
    シェルで、まだ認証していない場合は GitHub CLI を認証します：

    ```bash theme={null}
    gh auth login
    ```
  </Step>

  <Step title="Claude にサインイン">
    Claude Code CLI で `/login` を実行して、claude.ai アカウントでサインインします。既にサインインしている場合はこのステップをスキップします。
  </Step>

  <Step title="/web-setup を実行">
    Claude Code CLI で以下を実行します：

    ```text theme={null}
    /web-setup
    ```

    これにより、`gh` トークンが Claude アカウントに同期されます。cloud 環境がまだない場合、`/web-setup` は Trusted ネットワークアクセスと setup script なしで環境を作成します。後で [環境を編集したり、変数を追加](/ja/claude-code-on-the-web#configure-your-environment) できます。`/web-setup` が完了したら、[`--remote`](/ja/claude-code-on-the-web#from-terminal-to-web) でターミナルから cloud セッションを開始するか、[`/schedule`](/ja/routines) で定期的なタスクをセットアップできます。
  </Step>
</Steps>

## タスクを開始

GitHub が接続され、環境が作成されたら、タスクを送信する準備ができています。

<Steps>
  <Step title="リポジトリとブランチを選択">
    [claude.ai/code](https://claude.ai/code) または Claude モバイルアプリの Code タブから、入力ボックスの下のリポジトリセレクターをクリックし、Claude が作業するリポジトリを選択します。各リポジトリはブランチセレクターを表示します。デフォルトの代わりに feature ブランチから Claude を開始するように変更します。複数のリポジトリを追加して、1 つのセッション内で複数のリポジトリで作業できます。
  </Step>

  <Step title="permission mode を選択">
    入力の横の mode ドロップダウンは、デフォルトで **Auto accept edits** で、Claude は承認を待たずに変更を加えてブランチをプッシュします。Claude がアプローチを提案し、ファイルを編集する前にあなたの許可を待つようにしたい場合は、**Plan mode** に切り替えます。Cloud セッションは Ask permissions、Auto mode、または Bypass permissions を提供しません。完全なリストについては [Permission modes](/ja/permission-modes) を参照してください。
  </Step>

  <Step title="タスクを説明して送信">
    実行したい内容の説明を入力して Enter キーを押します。具体的にしてください：

    * ファイルまたは関数に名前を付けます：'Add a README with setup instructions'または'Fix the failing auth test in `tests/test_auth.py`'は'fix tests'より良いです
    * エラー出力がある場合は貼り付けます
    * 症状だけでなく、期待される動作を説明します

    Claude はリポジトリをクローンし、設定されている場合は setup script を実行し、作業を開始します。各タスクは独自のセッションと独自のブランチを取得するため、1 つが完了するのを待つ必要はありません。
  </Step>
</Steps>

## セッションを事前入力

[claude.ai/code](https://claude.ai/code) URL にクエリパラメータを追加することで、新しいセッションのプロンプト、リポジトリ、環境を事前入力できます。これを使用して、issue tracker のボタンなどの統合を構築し、issue の説明をプロンプトとして Claude Code を開きます。

| Parameter      | Description                                                                                         |
| :------------- | :-------------------------------------------------------------------------------------------------- |
| `prompt`       | 入力ボックスに事前入力するプロンプトテキスト。エイリアス `q` も受け入れられます。                                                         |
| `prompt_url`   | クエリ文字列に埋め込むには長すぎるプロンプトのプロンプトテキストを取得する URL。URL はクロスオリジンリクエストを許可する必要があります。`prompt` も設定されている場合は無視されます。 |
| `repositories` | 事前選択する `owner/repo` スラッグのコンマ区切りリスト。エイリアス `repo` も受け入れられます。                                          |
| `environment`  | 事前選択する [environment](#connect-github-and-create-an-environment) の名前または ID。                          |

各値を URL エンコードします。以下の例は、プロンプトとリポジトリが既に選択された状態でフォームを開きます：

```text theme={null}
https://claude.ai/code?prompt=Fix%20the%20login%20bug&repositories=acme/webapp
```

## レビューと反復

Claude が完了したら、変更をレビューし、特定の行にフィードバックを残し、diff が正しく見えるまで続行します。

<Steps>
  <Step title="diff ビューを開く">
    diff インジケーターはセッション全体で追加および削除された行を表示します（例：`+42 -18`）。それを選択して diff ビューを開き、左側にファイルリスト、右側に変更が表示されます。
  </Step>

  <Step title="インラインコメントを残す">
    diff 内の任意の行を選択し、フィードバックを入力して Enter キーを押します。コメントは次のメッセージを送信するまでキューに入り、その後バンドルされます。Claude は'at `src/auth.ts:47`, don't catch the error here'をメインの指示と一緒に見るため、問題がどこにあるかを説明する必要はありません。
  </Step>

  <Step title="pull request を作成">
    diff が正しく見えたら、diff ビューの上部にある **Create PR** を選択します。完全な PR として開くか、ドラフトとして開くか、生成されたタイトルと説明で GitHub の作成ページにジャンプできます。
  </Step>

  <Step title="PR 作成後も反復を続ける">
    PR が作成された後もセッションはライブのままです。CI 失敗出力またはレビュアーのコメントをチャットに貼り付け、Claude にそれらに対処するよう依頼します。Claude に PR を自動的に監視させるには、[Auto-fix pull requests](/ja/claude-code-on-the-web#auto-fix-pull-requests) を参照してください。
  </Step>
</Steps>

## セットアップのトラブルシューティング

### GitHub 接続後にリポジトリが表示されない

Claude GitHub App は、使用する各リポジトリへの明示的なアクセスが必要です。github.com で **Settings → Applications → Claude → Configure** を開き、リポジトリが **Repository access** の下にリストされていることを確認します。Private リポジトリは public リポジトリと同じ認可が必要です。

### ページに GitHub ログインボタンのみが表示される

Cloud セッションには接続された GitHub アカウントが必要です。上記のブラウザフローで接続するか、GitHub CLI を使用している場合はターミナルから `/web-setup` を実行します。GitHub をまったく接続したくない場合は、[Remote Control](/ja/remote-control) を参照して、独自のマシンで Claude Code を実行し、ウェブから監視します。

### 「Not available for the selected organization」

Enterprise Organization では、管理者が Claude Code on the web を有効にする必要がある場合があります。Anthropic アカウントチームに連絡してください。

### `/web-setup` が「Unknown command」を返す

`/web-setup` はシェルではなく Claude Code CLI 内で実行されます。まず `claude` を起動し、プロンプトで `/web-setup` を入力します。

Claude Code 内で入力してもエラーが表示される場合は、CLI が v2.1.80 より古いか、API キーまたはサードパーティプロバイダーではなく claude.ai サブスクリプションで認証されています。`claude update` を実行してから `/login` を実行して、claude.ai アカウントでサインインします。

### `--remote` または ultraplan を使用する場合に「Could not create a cloud environment」または「No cloud environment available」

Remote セッション機能は、cloud 環境がない場合、デフォルトの cloud 環境を自動的に作成します。「Could not create a cloud environment」が表示される場合、自動作成に失敗しました。{/* max-version: 2.1.100 */}「No cloud environment available」が表示される場合、CLI は自動作成より前のものです。どちらの場合でも、Claude Code CLI で `/web-setup` を実行して手動で作成するか、[claude.ai/code](https://claude.ai/code) にアクセスして上記の **Create your environment** ステップに従ってください。

### Setup script が失敗

Setup script は 0 以外のステータスで終了し、セッションの開始をブロックします。一般的な原因：

* レジストリが [network access level](/ja/claude-code-on-the-web#access-levels) にないため、パッケージのインストールに失敗しました。`Trusted` はほとんどのパッケージマネージャーをカバーします。`None` はすべてをブロックします。
* スクリプトは新規クローンに存在しないファイルまたはパスを参照しています。
* ローカルで機能するコマンドは Ubuntu で異なる呼び出しが必要です。

デバッグするには、スクリプトの上部に `set -x` を追加して、どのコマンドが失敗したかを確認します。重要でないコマンドの場合は、`|| true` を追加してセッション開始をブロックしないようにします。

### タブを閉じた後もセッションが実行され続ける

これは仕様です。タブを閉じたり、移動したりしてもセッションは停止しません。Claude が現在のタスクを完了するまでバックグラウンドで実行され、その後アイドル状態になります。サイドバーから、セッションをリストから非表示にするために [archive a session](/ja/claude-code-on-the-web#archive-sessions) するか、永久に削除するために [delete it](/ja/claude-code-on-the-web#delete-sessions) できます。

## 次のステップ

タスクを送信してレビューできるようになったので、これらのページは次に来るものをカバーしています：ターミナルから cloud セッションを開始し、定期的な作業をスケジュールし、Claude に常設の指示を与えます。

* [Use Claude Code on the web](/ja/claude-code-on-the-web)：完全なリファレンス。セッションをターミナルにテレポートする、setup script、環境変数、ネットワーク設定を含みます
* [Routines](/ja/routines)：スケジュール、API 呼び出し、または GitHub イベントへの応答で作業を自動化します
* [CLAUDE.md](/ja/memory)：すべてのセッションの開始時に読み込まれる永続的な指示とコンテキストを Claude に提供します
* [iOS](https://apps.apple.com/us/app/claude-by-anthropic/id6473753684) または [Android](https://play.google.com/store/apps/details?id=com.anthropic.claude) 用の Claude モバイルアプリをインストールして、スマートフォンからセッションを監視します。Claude Code CLI から、`/mobile` は QR コードを表示します。
