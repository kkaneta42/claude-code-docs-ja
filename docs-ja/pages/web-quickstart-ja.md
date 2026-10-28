> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# Claude Code をクラウドで始める

> ブラウザまたはスマートフォンからクラウドで Claude Code を実行します。GitHub リポジトリを接続し、タスクを送信し、ローカルセットアップなしで PR をレビューします。

> [!NOTE]
>
> クラウドセッションは、Pro、Max、Team プランおよび premium seats または Chat + Claude Code seats を持つ Enterprise ユーザーを対象としています。

クラウドセッションは、あなたのマシンではなく Anthropic が管理するクラウドインフラストラクチャで Claude Code を実行します。このクイックスタートでは、ブラウザから [claude.ai/code](https://claude.ai/code) で開始します。Claude モバイルアプリ、Desktop アプリ、またはターミナルから `claude --cloud` で開始することもできます。

[始めるには](#connect-github) GitHub リポジトリが必要です。Claude はそれを分離された仮想マシンにクローンし、変更を加え、レビュー用のブランチをプッシュします。セッションはデバイス間で永続化されるため、ラップトップで開始したタスクは後でスマートフォンからレビューする準備ができています。各セッションは、Claude および Claude Code のその他の使用量とあわせてプランの使用制限にカウントされます。クラウド VM に対する別途の料金は発生しません。

クラウドセッションは以下に適しています：

* **並列タスク**：複数の worktrees を管理することなく、複数の独立したタスクを同時に実行し、それぞれ独自のセッションとブランチで実行します
* **ローカルにないリポジトリ**：Claude はセッションごとにリポジトリを新規クローンするため、チェックアウトする必要がありません
* **頻繁なステアリングが不要なタスク**：明確に定義されたタスクを送信し、他のことをして、Claude が完了したときに結果をレビューします
* **コードの質問と探索**：ローカルチェックアウトなしでコードベースを理解したり、機能がどのように実装されているかをトレースします

ローカル設定、ツール、または環境が必要な作業の場合は、Claude Code をローカルで実行するか、[Remote Control](https://code.claude.com/docs/ja/remote-control.md) を使用する方が適しています。

## セッションの実行方法

以下の手順は Anthropic がホストするセッションについて説明しています。[自己ホスト環境](https://code.claude.com/docs/ja/self-hosted-environments)では、クローンとそれ以降のすべてが組織独自のランナー上で実行され、ネットワーク境界、セットアップ、プッシュ動作はオペレーターが設定します。タスクを送信すると：

1. **クローンと準備**：リポジトリが Anthropic が管理する VM にクローンされ、設定されている場合は [setup script](https://code.claude.com/docs/ja/cloud-environments.md#setup-scripts) が実行されます。
2. **ネットワークの設定**：インターネットアクセスは環境の [access level](https://code.claude.com/docs/ja/cloud-environments.md#access-levels) に基づいて設定されます。
3. **作業**：Claude はコードを分析し、変更を加え、テストを実行し、その作業をチェックします。全体を監視してステアリングすることも、完了したら戻ってくることもできます。
4. **ブランチをプッシュ**：Claude が停止ポイントに達すると、ブランチを GitHub にプッシュします。diff をレビューし、インラインコメントを残し、PR を作成するか、別のメッセージを送信して続行します。

ブランチがプッシュされてもセッションは閉じません。PR の作成とさらなる編集はすべて同じ会話内で行われます。

## Claude Code を実行する方法を比較

Claude Code はどこでも同じように動作します。変わるのは、セッションが実行される場所とローカル設定が利用可能かどうかです。

| | クラウドセッション | ローカルセッション | [リモートコントロール](https://code.claude.com/docs/ja/remote-control.md)を使用したローカルセッション |
| :- | :- | :- | :- |
| **コードが実行される場所** | クラウド VM、Anthropic 管理（デフォルト） | お客様のマシン | お客様のマシン |
| **セッションを開始する場所** | claude.ai/code、Claude モバイルアプリ、**Cloud** が選択された Desktop app、または `claude --cloud` | お客様のターミナル、お客様の IDE、または **Local** が選択された Desktop app | お客様のターミナル、VS Code 拡張機能、または Desktop app |
| **チャットを行う場所** | claude.ai、モバイルアプリ、または Desktop app | セッションを開始した場所 | claude.ai またはモバイルアプリ、およびセッションを開始した場所 |
| **ローカル設定を使用** | いいえ、リポジトリのみ | はい | はい |
| **GitHub が必要** | はい、または `--cloud` 経由で[ローカルリポジトリをバンドル](https://code.claude.com/docs/ja/claude-code-on-the-web.md#send-local-repositories-without-github) | いいえ | いいえ |
| **切断時に実行を継続** | はい | いいえ | セッションがお客様のマシンで開いている間 |
| **[権限モード](https://code.claude.com/docs/ja/permission-modes.md)** | 編集を受け入れる、Plan、Auto | ターミナルのすべてのモード。IDE と Desktop app については[権限モードを切り替える](https://code.claude.com/docs/ja/permission-modes.md#switch-permission-modes)を参照してください | claude.ai とモバイルアプリから Manual、編集を受け入れる、Plan、または Auto |
| **ネットワークアクセス** | 環境ごとに設定可能 | お客様のマシンのネットワーク | お客様のマシンのネットワーク |

ローカルセッションをセットアップするには、[ターミナルクイックスタート](https://code.claude.com/docs/ja/quickstart.md)、[Desktop app](https://code.claude.com/docs/ja/desktop.md)、または [リモートコントロール](https://code.claude.com/docs/ja/remote-control.md) ドキュメントを参照してください。

## GitHub を接続

GitHub への接続は 1 回限りのステップです。既に GitHub CLI を使用している場合は、ブラウザの代わりに [ターミナルからこれを実行](#connect-from-your-terminal) できます。

> [!NOTE]
>
> Team および Enterprise プランでは、**Sign in with GitHub** ステップは、Claude 組織の [Owner](https://code.claude.com/docs/ja/server-managed-settings.md#access-control) が [**Organization settings > Connectors**](https://claude.ai/admin-settings/connectors) で GitHub コネクタをオンにした後にのみ機能します。それまでは、そのステップはサインインボタンの代わりに「GitHub access is required for Claude Code cloud sessions」と表示されます。コネクタがオンになった後、[claude.ai/code](https://claude.ai/code) をリロードして、最初のステップから再度開始します。[**Organization settings > Claude Code**](https://claude.ai/admin-settings/claude-code) の [Quick setup](https://code.claude.com/docs/ja/claude-code-on-the-web.md#quick-setup-for-team-and-enterprise) という 2 番目のトグルはオプションです。オンにすると、`/web-setup` が機能し、オンボーディングはメンバーの環境を作成します。

**1. claude.ai/code にアクセス**

[claude.ai/code](https://claude.ai/code) にアクセスし、claude.ai アカウントでサインインします。

**2. GitHub でサインイン**

サインイン後、claude.ai/code は GitHub を接続するよう促します。プロンプトに従うと、claude.ai/code は GitHub の認可ページに移動します。認可リクエストを承認すると、GitHub は claude.ai/code に戻ります。クラウドセッションは既存の GitHub リポジトリで機能します。新しいプロジェクトを開始するには、まず [GitHub で README 付きのリポジトリを作成](https://github.com/new) してください。

この接続により、セッションは任意のパブリックリポジトリをクローンできますが、プライベートリポジトリで機能するのは Claude GitHub App がインストールされている場合のみです。[Claude GitHub App をインストール](https://github.com/apps/claude/installations/new) してください。使用したいプライベートリポジトリを持つ各 GitHub アカウントまたは Organization に対してインストールします。GitHub Organization では、Organization オーナーがインストールを承認する必要がある場合があります。App をインストールすると、[Auto-fix](https://code.claude.com/docs/ja/claude-code-on-the-web.md#auto-fix-pull-requests) も有効になります。これにより、Claude はこれらのリポジトリの pull request の CI 失敗とレビューコメントに応答できます。

接続すると、Claude は、自分が所有する GitHub アカウントのうち Claude GitHub App がインストールされているものを Claude 組織にもリンクします。Team および Enterprise プランでは、管理者は [接続済み GitHub アカウントのリスト](https://code.claude.com/docs/ja/admin-setup.md#connected-github-accounts) でそれらのアカウントを確認できます。

オンボーディングがこの時点で Claude GitHub App をインストールするよう促し、後で実行したい場合は、**Skip** をクリックします。

**3. デフォルト環境をセットアップ**

[cloud environment](https://code.claude.com/docs/ja/cloud-environments.md) は、セッション中に Claude が持つネットワークアクセスと、セッション開始時に実行される内容を制御する保存された設定です。GitHub を接続した後の動作はプランによって異なります。

* **Pro および Max**：オンボーディングは **Default** という名前の環境を作成します。
* **Team および Enterprise**：オンボーディングは **Create your first cloud environment** フォームを表示します。事前入力された名前とネットワークアクセスを変更せず、**Create & finish** をクリックして **Default** 環境を作成します。Owner が [Quick setup](https://code.claude.com/docs/ja/claude-code-on-the-web.md#quick-setup-for-team-and-enterprise) をオンにしている場合、オンボーディングは代わりに **Default** を作成します。

**Default** は [`Trusted` ネットワークアクセス](https://code.claude.com/docs/ja/cloud-environments#access-levels) を使用します。セッションは [common package registries](https://code.claude.com/docs/ja/cloud-environments.md#default-allowed-domains) およびその他のホワイトリストに登録されたドメインに到達し、セッションのネットワークを通じて他には何も到達しません。設定なしで利用可能な内容については、[Installed tools](https://code.claude.com/docs/ja/cloud-environments.md#installed-tools) を参照してください。

最初のプロジェクトの場合、**Default** 環境はそのまま機能します。ネットワークアクセスを変更したり、環境変数を追加したり、セッション開始前に [setup script](https://code.claude.com/docs/ja/cloud-environments.md#setup-scripts) を実行したりするには、[環境を編集するか、追加の環境を作成](https://code.claude.com/docs/ja/cloud-environments.md#configure-your-environment) してください。

### ターミナルから接続

既に GitHub CLI（`gh`）を使用している場合は、ターミナルからクラウドセッション用に GitHub を接続できます。これには [Claude Code CLI](https://code.claude.com/docs/ja/quickstart.md) が必要です。Team および Enterprise プランでは、`/web-setup` は Owner が [Quick setup](https://code.claude.com/docs/ja/claude-code-on-the-web.md#quick-setup-for-team-and-enterprise) をオンにした後にのみ利用可能です。

`/web-setup` を実行すると、Claude Code は `gh auth token` が出力するトークンを読み取り、確認を求め、トークンを Anthropic に送信します。Anthropic はそれを claude.ai アカウントで暗号化して保存し、cloud セッションはそれを GitHub アクセスに使用します。これは [削除](#remove-the-web-setup-token) するまで続きます。自分で開始した cloud セッションは、そのトークンがアクセスできる任意のリポジトリにアクセスでき、Claude GitHub App をインストールする必要はありません。[project](https://code.claude.com/docs/ja/claude-projects.md#set-up-github-access) 内のスレッドは引き続き Claude GitHub App が必要です。

既にブラウザで GitHub を接続している場合、`/web-setup` は続行すると cloud セッションの接続が置き換わることを警告します。

> [!NOTE]
>
> [Zero Data Retention](https://code.claude.com/docs/ja/zero-data-retention.md) が有効な組織、または [HIPAA 構成](https://code.claude.com/docs/ja/hipaa-setup.md) が適用されている組織は、`/web-setup` または他のクラウドセッション機能を使用できません。[顧客管理の暗号化キー](https://platform.claude.com/docs/en/manage-claude/cmek)（CMEK）を使用している組織も、クラウドセッションを開始できません。GitHub CLI がインストールされていない、または認証されていない場合、Claude Code はブラウザオンボーディングフローを開きます。

**1. GitHub CLI で認証**

シェルで、まだ認証していない場合は GitHub CLI を認証します：

```bash theme={null}
gh auth login
```

**2. Claude にサインイン**

Claude Code CLI で `/login` を実行して、claude.ai アカウントでサインインします。既に claude.ai アカウントでサインインしている場合はこのステップをスキップします。API キーで認証することはカウントされません。確認するには、`/status` を実行し、**Login method** 行に claude.ai アカウントが表示されることを確認します。

**3. /web-setup を実行**

Claude Code CLI で以下を実行します：

```text theme={null}
/web-setup
```

`gh` トークンを Claude アカウントに送信するプロンプトを確認します。成功すると、Claude Code は `Connected as <your-github-username>` を出力し、[claude.ai/code](https://claude.ai/code) をブラウザで開きます。cloud 環境がまだない場合、`/web-setup` は Trusted ネットワークアクセスと setup script なしで環境を作成します。後で [環境を編集したり、変数を追加](https://code.claude.com/docs/ja/cloud-environments.md#configure-your-environment) できます。`/web-setup` が完了したら、[`--cloud`](https://code.claude.com/docs/ja/claude-code-on-the-web#from-terminal-to-cloud) でターミナルから cloud セッションを開始するか、[`/schedule`](https://code.claude.com/docs/ja/routines) で定期的なタスクをセットアップできます。

#### `/web-setup` トークンを削除

Claude アカウントからトークンを削除するには、[claude.ai/customize/connectors](https://claude.ai/customize/connectors) で GitHub を切断します。切断すると、ブラウザから来たか `/web-setup` から来たかに関わらず、cloud セッションが使用する GitHub 認証情報が削除されるため、cloud セッションは再度接続するまで GitHub アクセスを失います。ローカルの `gh` はサインインしたままで、トークンは GitHub で有効なままです。

トークン自体を無効にするには、GitHub でそれを取り消します。ブラウザを通じて `gh` にサインインした場合、トークンは GitHub の [**Settings > Applications > Authorized OAuth Apps**](https://github.com/settings/applications) の **GitHub CLI** エントリに属し、そのエントリを取り消すと、マシン上の GitHub CLI もサインアウトします。Cloud セッションは `gh auth login` と `/web-setup` を再度実行するまで GitHub アクセスを失います。

## タスクを開始する

GitHub を接続して環境を作成したら、タスクを送信する準備が整います。

**1. リポジトリとブランチを選択する**

[claude.ai/code](https://claude.ai/code) または Claude モバイルアプリの Code タブで、入力ボックスの下にあるリポジトリセレクターをクリックし、Claude が作業するリポジトリを選択します。複数のリポジトリを追加して、1 つのセッションでそれらにまたがって作業することもできます。

claude.ai/code で、デフォルトではなくフィーチャーブランチから Claude を開始するには、リポジトリセレクターの後にあるコントロールでブランチを変更します。

**2. 権限モードを選択する**

[権限モードコントロール](https://code.claude.com/docs/ja/permission-modes.md#switch-permission-modes)には、セッションが実行される権限モードが表示されます。

* **Auto**：ユーザーに確認する代わりに、分類器が Claude のアクションをレビューします。組織が auto モードを許可しており、選択したモデルがそれをサポートしている場合に表示されます
* **Accept edits**：Claude は承認を待たずに変更を加え、ブランチをプッシュします
* **Plan**：Claude はアプローチを提案し、ファイルを編集する前にユーザーの承認を待ちます

クラウドセッションでは Manual や Bypass permissions は提供されません。それぞれで何が許可されるかについては、[権限モードの一覧](https://code.claude.com/docs/ja/permission-modes.md#available-modes)を参照してください。

**3. タスクを説明して送信する**

やりたいことの説明を入力して Enter キーを押します。具体的に記述してください。

* ファイルや関数の名前を挙げる：「fix tests」よりも「Add a README with setup instructions」や「Fix the failing auth test in `tests/test_auth.py`」のほうが適切です
* エラー出力があれば貼り付ける
* 症状だけでなく、期待される動作を説明する

Claude はリポジトリをクローンし、セットアップスクリプトが設定されていればそれを実行して、作業を開始します。各タスクには専用のセッションと専用のブランチが割り当てられるため、1 つのタスクが完了するのを待たずに別のタスクを開始できます。

## セッションを事前入力

[claude.ai/code](https://claude.ai/code) URL にクエリパラメータを追加することで、新しいセッションのプロンプト、リポジトリ、環境を事前入力できます。これを使用して、issue tracker のボタンなどの統合を構築し、issue の説明をプロンプトとして Claude Code を開きます。

| Parameter | Description |
| :- | :- |
| `prompt` | 入力ボックスに事前入力するプロンプトテキスト。エイリアス `q` も受け入れられます。 |
| `prompt_url` | クエリ文字列に埋め込むには長すぎるプロンプトのプロンプトテキストを取得する URL。URL はクロスオリジンリクエストを許可する必要があります。`prompt` も設定されている場合は無視されます。 |
| `repositories` | 事前選択する `owner/repo` スラッグのコンマ区切りリスト。エイリアス `repo` も受け入れられます。 |
| `environment` | 事前選択する [environment](#connect-github) の名前または ID。 |

各値を URL エンコードします。以下の例は、プロンプトとリポジトリが既に選択された状態でフォームを開きます：

```text theme={null}
https://claude.ai/code?prompt=Fix%20the%20login%20bug&repositories=acme/webapp
```

## レビューと反復

Claude が完了したら、変更をレビューし、特定の行にフィードバックを残し、diff が正しく見えるまで続行します。

**1. 差分ビューを開く**

Claude が変更をブランチにプッシュすると、チャットの横にあるパネルの **Changes** カードに、セッション全体で追加および削除された行が表示されます（例：`+42 -18`）。これらの数値をクリックすると差分ビューが開きます。

* セッションのタイトルバー、またはバーの **⋮** メニューにある **Changes** をクリックすることもできます。
* パネルが非表示になっているときに表示するには、セッションのタイトルバー、またはバーの **⋮** メニューにある **Show session rail** アイコンをクリックします。

差分はデフォルトではセッションの変更をベースブランチと比較します。別のブランチと比較するには、**Compare against** を選択して 1 つを選びます。ベースブランチと比較する場合、差分には[まだプッシュされていない変更が含まれないことがあります](https://code.claude.com/docs/ja/claude-code-on-the-web.md#troubleshoot-a-missing-file-in-the-diff-view)。

**2. インラインコメントを残す**

差分内の行にカーソルを合わせ、行番号の横に表示される **+** をクリックしてコメントボックスを開き、フィードバックを入力して Enter キーを押します。コメントは次のメッセージを送信するまでキューに入り、その後そのメッセージとまとめて送信されます。Claude は「`src/auth.ts:47` で、ここでエラーをキャッチしないでください」をメインの指示と一緒に見るため、問題がどこにあるかを説明する必要はありません。

**3. プルリクエストを作成**

差分が正しく見えたら、**Changes** カードが表示されていない場合は[パネルを再度表示](https://code.claude.com/docs/ja/claude-code-on-the-web.md#review-changes)し、カードからプルリクエストまたはドラフトを作成します：

* **Create PR** をクリックします。Claude Code が生成されたタイトルと説明でプルリクエストを作成します。
* 代わりにドラフトとして開くには、**Create PR** を右クリックし、**Create draft PR** を選択してボタンの動作を変更してから、ボタンをクリックします

**4. PR 作成後も反復を続ける**

PR が作成された後もセッションはライブのままです。CI 失敗出力またはレビュアーのコメントをチャットに貼り付け、Claude にそれらに対処するよう依頼します。Claude に PR を自動的に監視させるには、[Auto-fix pull requests](https://code.claude.com/docs/ja/claude-code-on-the-web.md#auto-fix-pull-requests) を参照してください。

## セットアップのトラブルシューティング

### GitHub 接続後にリポジトリが表示されない

ブラウザで GitHub を接続した場合、セッションはすべてのパブリックリポジトリをクローンできますが、プライベートリポジトリは Claude GitHub App がそれを所有するアカウントまたは組織にインストールされており、インストールのリポジトリアクセスにそれが含まれている場合にのみ表示されます。[Claude GitHub App をインストール](https://github.com/apps/claude/installations/new)するか、組織の所有者にインストールまたは承認を依頼してください。

`/web-setup` で接続した場合、セッションは `gh` トークンがアクセスできるすべてのリポジトリに到達できます。シェルで `gh repo view OWNER/REPO` を実行して、GitHub CLI ログインがリポジトリを見ることができることを確認し、接続以降に `gh` アカウントを切り替えた場合は `/web-setup` を再度実行してください。

### ページに GitHub ログインボタンのみが表示される

クラウドセッションには接続された GitHub アカウントが必要です。上記のブラウザフローで接続するか、GitHub CLI を使用する場合はターミナルから `/web-setup` を実行してください。GitHub をまったく接続したくない場合は、[Remote Control](https://code.claude.com/docs/ja/remote-control.md) を参照して、自分のマシンで Claude Code を実行し、ブラウザまたは電話から監視してください。

### 「Claude Code はアカウントで利用できません」

選択した組織のシートに Claude Code が含まれていません。別の組織に属している場合は、そのページで **Switch organization** をクリックしてください。それ以外の場合は、組織の所有者に [Claude Code を含むシート](https://support.claude.com/en/articles/11845131-use-claude-code-with-your-team-or-enterprise-plan)を割り当てるよう依頼してください。

### `/web-setup` が「Claude にサインインしていません」と表示される

`/web-setup` が「Not signed in to Claude. Run /login first.」と応答する場合、CLI には有効な claude.ai サインインがありません。これは以前のサインインの有効期限が切れた場合にも発生する可能性があります。`/login` を実行し、claude.ai アカウントでサインインしてから、`/web-setup` を再度実行してください。

### `/web-setup` がトークンに `workflow` スコープがないことを警告する

`/web-setup` が GitHub CLI トークンに `workflow` スコープがないと表示される場合、続行できますが、GitHub はそのトークンで行われた一部のプッシュ（GitHub Actions ワークフローファイルを変更するプッシュなど）を拒否する可能性があります。スコープを追加するには、シェルで `gh auth refresh -s workflow` を実行してから、`/web-setup` を再度実行してください。

### `/web-setup` が「No commands match」または「Unknown command」を表示する

`/web-setup` は Claude Code CLI 内で実行され、シェルではありません。まず `claude` を起動してから、プロンプトで `/web-setup` と入力してください。

Claude Code 内に入力した場合、コマンドメニューが「No commands match "/web-setup"」を表示するか、送信すると「Unknown command: /web-setup」が返される場合、要件が満たされていないため、コマンドは非表示になっています。通常の原因は、claude.ai サブスクリプションではなく API キーまたはサードパーティプロバイダーで認証されていることです。`/login` を実行して claude.ai アカウントでサインインしてください。

Team および Enterprise プランでは、コマンドはデフォルトで非表示になっています。[Quick setup トグル](https://code.claude.com/docs/ja/claude-code-on-the-web.md#quick-setup-for-team-and-enterprise)は、所有者がオンにするまでオフになっています。オフの間は、代わりに[ブラウザから GitHub を接続](#connect-github)してください。

コマンドは他の 2 つのケースでも非表示になります。

* 管理者が組織のクラウドセッションを無効にしました。この場合、`/web-setup` を送信すると [`Cloud sessions are disabled by your organization's policy`](https://code.claude.com/docs/ja/errors#cloud-sessions-are-disabled-by-your-organizations-policy) が返されます。v2.1.268 より前では、このケースも `Unknown command: /web-setup` を返していました。
* Enterprise 組織で [Zero Data Retention](https://code.claude.com/docs/ja/zero-data-retention.md) が有効になっているか、[HIPAA 設定](https://code.claude.com/docs/ja/hipaa-setup.md)が適用されています。いずれの場合もクラウドセッションは利用できなくなります。

### `--cloud` を使用する場合に「Could not create a cloud environment」または「No cloud environment available」が表示される

クラウドセッション機能は、環境がない場合、デフォルトのクラウド環境を自動的に作成します。「Could not create a cloud environment」が表示される場合、自動作成に失敗しました。「No cloud environment available」が表示される場合、CLI は自動作成より前のバージョンです。どちらの場合でも、Claude Code CLI で `/web-setup` を実行するか、[claude.ai/code](https://claude.ai/code) の[環境セレクター](https://code.claude.com/docs/ja/cloud-environments.md#configure-your-environment)から環境を追加してください。

### セットアップスクリプトが失敗した

セットアップスクリプトがゼロ以外のステータスで終了し、セッションの開始がブロックされました。一般的な原因は以下の通りです。

* パッケージインストールが失敗しました。レジストリが[ネットワークアクセスレベル](https://code.claude.com/docs/ja/cloud-environments.md#access-levels)にないためです。`Trusted` はほとんどのパッケージマネージャーをカバーしており、`None` はすべてをブロックします。
* スクリプトが新しいクローンに存在しないファイルまたはパスを参照しています。
* ローカルで機能するコマンドが Ubuntu では異なる呼び出しが必要です。

デバッグするには、スクリプトの先頭に `set -x` を追加して、どのコマンドが失敗したかを確認してください。重要でないコマンドの場合は、セッション開始をブロックしないように `|| true` を追加してください。

### 新しいセッションがセットアップ中にハングするか、タイムアウトする

新しいセッションがセットアップスクリプトステップで停止するか、スクリプトが完了する前に一般的なコンテナエラーで失敗する場合、スクリプトは[環境キャッシュ](https://code.claude.com/docs/ja/cloud-environments.md#environment-caching)を構築するための約 5 分間の時間予算を超えている可能性があります。大きな Docker イメージのプル、完全な依存関係ツリーの同期、モデルの重みのダウンロードなどの重い手順は、特に連続して実行される場合、合計を制限を超えることがよくあります。

これを修正するには、スクリプトを調整して、5 分以内に確実に完了するようにしてください。

* `&` と最終的な `wait` を使用して独立したインストールを並列で実行し、順序に実行する代わりに実行します。
* 最大のダウンロードをセットアップスクリプトから[SessionStart hook](https://code.claude.com/docs/ja/cloud-environments.md#setup-scripts-vs-sessionstart-hooks)に移動して、バックグラウンドで起動し、セッションが完了中に使用可能になるようにします。
* セットアップスクリプトから長い再試行スリープを削除してください。停止した再試行ループは予算に対してカウントされるためです。

### タブを閉じた後もセッションが実行され続ける

これは仕様です。タブを閉じたり、移動したりしてもセッションは停止しません。Claude が現在のタスクを完了するまでバックグラウンドで実行され続け、その後アイドル状態になります。サイドバーから、セッションをリストから非表示にするために[セッションをアーカイブ](https://code.claude.com/docs/ja/claude-code-on-the-web.md#archive-sessions)するか、永続的に削除するために[削除](https://code.claude.com/docs/ja/claude-code-on-the-web.md#delete-sessions)できます。

## 次のステップ

タスクを送信してレビューできるようになったので、これらのページは次に来るものをカバーしています：ターミナルから cloud セッションを開始し、定期的な作業をスケジュールし、Claude に常設の指示を与えます。

* [Claude Code をクラウドで使用する](https://code.claude.com/docs/ja/claude-code-on-the-web.md)：完全なリファレンス。セッションをターミナルにテレポートする、セッション共有、auto-fixing pull requests を含みます
* [クラウド環境を設定する](https://code.claude.com/docs/ja/cloud-environments.md)：ネットワークアクセスレベル、環境変数、cloud セッション用のセットアップスクリプト
* [クラウドのスケジュールタスク](https://code.claude.com/docs/ja/routines.md)：スケジュール、API 呼び出し、または GitHub イベントへの応答で作業を自動化します
* [CLAUDE.md](https://code.claude.com/docs/ja/memory.md)：すべてのセッションの開始時に読み込まれる永続的な指示とコンテキストを Claude に提供します
* [iOS](https://apps.apple.com/us/app/claude-by-anthropic/id6473753684) または [Android](https://play.google.com/store/apps/details?id=com.anthropic.claude) 用の Claude モバイルアプリをインストールして、スマートフォンからセッションを監視します。Claude Code CLI から、`/mobile` は [claude.ai/mobile](https://claude.ai/mobile) 用の QR コードを表示します。これはお使いのスマートフォンに適切なアプリストアを開きます。
