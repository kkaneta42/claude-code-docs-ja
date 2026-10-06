> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# クラウドで Claude Code を使用する

> ブラウザ、携帯電話、デスクトップアプリ、またはターミナルからクラウドで Claude Code セッションを実行し、--cloud と --teleport で移動し、プルリクエストを自動修正します。

<Note>
  クラウドセッションは Pro、Max、Team プランで利用でき、Premium シートまたは Chat + Claude Code シートを持つ Enterprise ユーザーも対象です。
</Note>

クラウドセッションは、マシン上ではなくクラウドインフラストラクチャで実行される Claude Code セッションです。デフォルトでは Anthropic が管理するインフラストラクチャで実行されるか、ルーティングされた場合は組織の[セルフホスト環境](/docs/ja/self-hosted-environments)で実行されます。セッションはラップトップを閉じた後も実行を続け、任意のデバイスから確認または操作できます。

クラウドセッションが GitHub からコードをクローンしてブランチをプッシュできるようにするには、いずれかの [GitHub 接続方法](#github-authentication-options)で GitHub を接続します。リポジトリが GitLab、Bitbucket、またはその他のホスト上にある場合は、[プラットフォームの制限](#limitations)で利用可能な機能を確認してください。

以下のいずれかのサーフェスからクラウドセッションを開始できます：

* **ブラウザ**：[claude.ai/code](https://claude.ai/code)（ウェブ上の Claude Code とも呼ばれます）
* **モバイル**：[Claude アプリ](/docs/ja/mobile)の**Code** タブ
* **デスクトップアプリ**：[セッションを開始](/docs/ja/desktop#run-long-running-tasks-in-the-cloud)するときに**Local** の代わりに**Cloud** を選択
* **ターミナル**：[`claude --cloud`](#from-terminal-to-cloud)
* **ルーティン**：[スケジュール実行とトリガー実行](/docs/ja/routines)は各々クラウドセッションとして実行されます

セットアップが完了したら、このページを参考に、ターミナルとクラウド間での作業の移動、セッションの管理と共有、プルリクエストの自動修正の有効化、およびトラブルシューティングを行ってください。

<Note>
  以下のケースは他のページで説明しています：

  * **最初のクラウドセッションの開始**：[クラウドセッションを始める](/docs/ja/web-quickstart)では、GitHub を接続し、ブラウザでタスクを実行する手順を説明しています
  * **1 つの作業本体に対する多数のクラウドセッション**：[プロジェクト](/docs/ja/claude-projects)を使用すると、Claude がセッションを開始して追跡します
  * **別のデバイスからのローカルセッションの操作**：ターミナル、IDE、または**Local** が選択されたデスクトップアプリのセッションはマシン上で実行され、[Remote Control](/docs/ja/remote-control) を使用すると携帯電話やブラウザからそれらにアクセスできます
</Note>

<h2 id="cloud-environments">
  クラウド環境
</h2>

すべてのクラウドセッションは[クラウド環境](/docs/ja/cloud-environments)で実行されます。これはネットワークアクセス、環境変数、セットアップスクリプトを制御する保存された設定です。

* **最初の環境**: 環境がまだない場合、オンボーディングは[**Trusted** ネットワークアクセス](/docs/ja/cloud-environments#access-levels)を持つ **Default** 環境をセットアップします。自動的に作成されるか、作成するよう求められるかのいずれかです。プランごとにどちらになるかについては、[Default 環境](/docs/ja/cloud-environments#the-default-environment)を参照してください
* **セッションが使用する環境**: 複数の環境がある場合にセッションが環境を選択する方法については、[Default 環境](/docs/ja/cloud-environments#the-default-environment)を参照してください
* **セッションがアクセスできる対象や起動時に実行する内容を変更する**: [クラウド環境を設定する](/docs/ja/cloud-environments)を参照してください
* **設定なしでインストールされているもの**: [インストール済みツール](/docs/ja/cloud-environments#installed-tools)を参照してください

<h2 id="github-authentication-options">
  GitHub 認証オプション
</h2>

クラウドセッションはコードをクローンしてブランチをプッシュするために GitHub リポジトリへのアクセスが必要です。2 つの方法でアクセスを許可できます：

| 方法 | 接続方法 | セッションが到達できるリポジトリ | 最適な用途 |
| :- | :- | :- | :- |
| **GitHub App** | [ウェブオンボーディング](/docs/ja/web-quickstart)中に Claude GitHub App を認可します | 任意のパブリックリポジトリ、および Claude GitHub App がインストールされているプライベートリポジトリ | ブラウザオンボーディング；[Auto-fix](#auto-fix-pull-requests) を希望するチーム |
| **`/web-setup`** | ターミナルで `/web-setup` を実行して、ローカル `gh` CLI トークンを Claude アカウントに送信します | `gh` トークンがアクセスできる任意のリポジトリ（App がインストールされているかどうかに関わらず） | すでに `gh` を使用している個別開発者 |

以下の機能は、リポジトリに Claude GitHub App がインストールされていることが前提となります：

* **Auto-fix**：Claude GitHub App をリポジトリにインストールすると、そのリポジトリのプルリクエストに対して [Auto-fix](#auto-fix-pull-requests) も有効になります
* **Projects**：[プロジェクト](/docs/ja/claude-projects)内のスレッドは、接続方法に関わらず、クローンする各リポジトリに Claude GitHub App がインストールされている必要があります。[GitHub アクセスの設定](/docs/ja/claude-projects#set-up-github-access)を参照してください

Anthropic ホスト環境では、GitHub 認証情報は Anthropic のサーバー上で暗号化されたままであり、セッションの VM に入ることはありません。VM からの GitHub 操作は [GitHub プロキシ](/docs/ja/cloud-environments#github-proxy)を通じて行われ、サーバー側で認証情報を添付します。

`/web-setup` のウォークスルー（`/web-setup` が保存する内容と削除方法を含む）については、[ターミナルから接続](/docs/ja/web-quickstart#connect-from-your-terminal)を参照してください。

<Note>
  [Zero Data Retention](/docs/ja/zero-data-retention) が有効な組織、または [HIPAA 設定](/docs/ja/hipaa-setup)が適用されている組織は、`/web-setup` またはその他のクラウドセッション機能を使用できません。
</Note>

<h3 id="quick-setup-for-team-and-enterprise">
  Team および Enterprise 向けの Quick setup
</h3>

Quick setup は、メンバーの GitHub と環境のセットアップの手順を省く組織設定です。Team および Enterprise プランではデフォルトでオフになっています。

オンにすると、メンバーにとって次の点が変わります：

* **`/web-setup`**：メンバーは `/web-setup` で GitHub を接続できます。この設定がオフの間、このコマンドは非表示になります
* **GitHub App のプロンプト**：ブラウザオンボーディングで Claude GitHub App のインストールプロンプトがスキップされます
* **最初の環境**：ブラウザオンボーディングでは、環境フォームを表示する代わりに、メンバー向けに [**Default** 環境](/docs/ja/cloud-environments#the-default-environment)が作成されます

[Owner](/docs/ja/server-managed-settings#access-control) は [**Organization settings > Claude Code**](https://claude.ai/admin-settings/claude-code) の **Quick setup** トグルでオンにします。

<h2 id="move-tasks-between-terminal-and-cloud">
  ターミナルとクラウド間でタスクを移動
</h2>

これらのワークフローには [Claude Code CLI](/docs/ja/quickstart) が同じ claude.ai アカウントにサインインしている必要があります。ターミナルから新しいクラウドセッションを開始するか、クラウドセッションをターミナルにプルしてローカルで続行できます。クラウドセッションはラップトップを閉じても保持され、Claude モバイルアプリを含む任意の場所から監視できます。

<Note>
  CLI からのセッションハンドオフは一方向です：`--teleport` でクラウドセッションをターミナルにプルできますが、既存のターミナルセッションをクラウドにプッシュすることはできません。`--cloud` フラグはタスク説明を使用して現在のリポジトリの新しいクラウドセッションを作成します；`-p` とセッション ID または claude.ai/code URL を使用すると、代わりに[その既存セッションにメッセージをキューイング](/docs/ja/claude-code-on-the-web#send-follow-ups-from-the-cli)します。[Desktop アプリ](/docs/ja/desktop#continue-in-another-surface)では、Code タブのローカルセッションを **Open in** メニューからクラウドに送信できます。
</Note>

<h3 id="from-terminal-to-cloud">
  ターミナルからクラウドへ
</h3>

`--cloud` フラグを使用してコマンドラインからクラウドセッションを開始します：

```bash theme={null}
claude --cloud "Fix the authentication bug in src/auth/login.ts"
```

これにより claude.ai 上に新しいクラウドセッションが作成されます。クラウド VM はローカルチェックアウトではなく、現在のブランチで現在のディレクトリの GitHub リモートをクローンするため、ローカルコミットがある場合は最初にプッシュしてください。[ローカルリポジトリを GitHub なしで送信](#send-local-repositories-without-github)を参照して、Claude Code がリモートをクローンする代わりにローカルリポジトリをアップロードする場合を確認してください。

`--cloud` は一度に 1 つのリポジトリで機能します。タスクはクラウドで実行され、ローカルで作業を続行できます。古い `--remote` スペルは `--cloud` の非推奨エイリアスとしてまだ機能します。

クラウドコンテナが起動している間、CLI はリポジトリのクローンや[セットアップスクリプト](/docs/ja/cloud-environments#setup-scripts)の実行などのセットアップステップのライブチェックリストを表示します。プロビジョニング中に入力したメッセージはキューに入れられ、セッションの準備ができたら送信されます。

<Note>
  `--cloud` はクラウドセッションを作成します。`--remote-control` は無関係です：ローカル CLI セッションを claude.ai または Claude アプリから監視および操舵できます。[Remote Control](/docs/ja/remote-control)を参照してください。
</Note>

claude.ai または Claude モバイルアプリでセッションを開いて進捗をチェックするか、直接対話します。そこから Claude を操舵し、フィードバックを提供するか、他のすべての会話と同じように質問に答えることができます。

Claude が質問をして、セッションがアイドル状態のままの場合、[環境の有効期限切れ](#environment-expired)まで戻ってきたときに答えることができ、セッションはあなたの答えから続行されます。

<h4 id="tips-for-cloud-tasks">
  クラウドタスクのヒント
</h4>

**ローカルで計画し、クラウドで実行する**：複雑なタスクの場合、Claude をプランモードで開始してアプローチについて協力し、その後クラウドに作業を送信します：

```bash theme={null}
claude --permission-mode plan
```

プランモードでは、Claude はファイルを読み取り、コマンドを実行して探索し、ソースコードを編集せずにプランを提案します。計画に満足したら、リポジトリにプランを保存し、コミットしてプッシュし、クラウド VM がそれをクローンできるようにします。その後、自律実行のためにクラウドセッションを開始します：

```bash theme={null}
claude --cloud "Execute the migration plan in docs/migration-plan.md"
```

**タスクを並列で実行**：各 `--cloud` コマンドは独立して実行される独自のクラウドセッションを作成します。複数のタスクを開始でき、すべて別々のセッションで同時に実行されます：

```bash theme={null}
claude --cloud "Fix the flaky test in auth.spec.ts"
claude --cloud "Update the API documentation"
claude --cloud "Refactor the logger to use structured output"
```

セッションが完了したら、claude.ai/code から PR を作成するか、[セッションをテレポート](#from-cloud-to-terminal)してターミナルで作業を続行できます。

<h4 id="send-local-repositories-without-github">
  GitHub なしでローカルリポジトリを送信
</h4>

git リモートがないリポジトリから `claude --cloud` を実行する場合、または Claude GitHub App がインストールされていない github.com リポジトリから実行する場合、Claude Code はローカルリポジトリをバンドルしてクラウドセッションに直接アップロードします。これは `/web-setup` で GitHub を接続した場合でも適用されます。

完全なクローンの場合、バンドルにはすべてのブランチにわたるリポジトリ履歴と、追跡されたファイルへのコミットされていない変更が含まれます。

機密ファイルへのコミットされていない変更の扱いは、プラットフォームによって異なります：

* **macOS、Linux、WSL**：Claude Code は、認証情報やキーのような名前のファイルへのコミットされていない変更をアップロードから除外します。これには `.env` ファイル、Terraform `*.tfvars` ファイル、および `id_rsa` や `*.pem` などのキーファイルが含まれます。また、Git LFS などの git フィルターが管理するファイルへのコミットされていない変更も除外します。`Left on this machine:` という通知に除外されたファイルの名前が表示され、セッションは各ファイルのコミット済みバージョンで開始されます。コミット済みのものがない場合は、そのファイルなしで開始されます。
* **ネイティブ Windows**：追跡されたファイルへのコミットされていない変更は、ファイル名にかかわらずそのままアップロードされます。クラウドセッションに含めたくない編集は、セッションを開始する前にスタッシュするか元に戻してください。

Claude Code がリモートからクローンする場合でも強制するには、`CCR_FORCE_BUNDLE=1` を設定します：

```bash theme={null}
CCR_FORCE_BUNDLE=1 claude --cloud "Run the test suite and fix any failures"
```

バンドルされたリポジトリはこれらの制限を満たす必要があります：

* ディレクトリは少なくとも 1 つのコミットを持つ git リポジトリである必要があります
* バンドルされたリポジトリは 100 MB 未満である必要があります。より大きなリポジトリは現在のブランチのみをバンドルすることにフォールバックし、その後ワーキングツリーの単一の圧縮スナップショットにフォールバックし、スナップショットがまだ大きすぎる場合のみ失敗します
* 追跡されていないファイルは含まれません。クラウドセッションが見るべきファイルで `git add` を実行します
* macOS、Linux、WSL では、Claude Code は属性ルールがファイルに適用される方法に影響する git 設定（インクルードされた設定ファイルで設定された `core.attributesFile` など）に従うことができない場合、アップロードを拒否します。[拒否メッセージ](/docs/ja/errors#the-repository-upload-cant-follow-a-git-setting)は設定と修正に名前を付けます
* バンドルから作成されたセッションは、[GitHub 接続](#github-authentication-options)がそのリポジトリへのプッシュアクセスを持つ場合にのみ、GitHub リモートにプッシュバックできます

macOS、Linux、WSL では、アップロードには git 2.31 以降と、サポートされているチェックアウト構成も必要です。一方、ネイティブ Windows では、Claude Code はどちらのチェックも行わずにアップロードします。チェックアウトがこれらの要件を満たさない場合、Claude Code はセッションを開始しません。`Not uploading this working tree:` を含むエラーを出力し、原因と変更すべき点を示します。主な原因は次のとおりです：

* **古い git**：インストールされている git が 2.31 より古い。git を更新してから再試行してください。
* **アップロードがサポートしていないチェックアウト構成**：サブモジュール内、`git clone --separate-git-dir`、`--shared`、または `--reference` で作成したクローン内、`core.worktree` が設定されたチェックアウト内、または参照を reftable 形式で保持するリポジトリ内から開始した。代わりに、通常の `git clone` で作成したクローンのメインチェックアウトから開始してください。
* **スパースチェックアウトを使用したリンクされた worktree**：`git sparse-checkout` は worktree 独自の `config.worktree` ファイルに設定を書き込みますが、アップロードはこれを受け付けません。そのため、これらの設定を持つ worktree はアップロードされず、Claude Code が [`worktree.sparsePaths`](/docs/ja/settings-reference#worktree-sparsepaths) で作成した worktree もアップロードされません。代わりにリポジトリのメインチェックアウトから開始してください。
* **作業ツリー内に置かれた git 設定**：git 設定が、チェックアウト内にあるファイルをインクルードしている（たとえば、リポジトリ内を指す `include.path` エントリ）。そのファイルを作業ツリーの外に移動するか、インクルードを削除してから再試行してください。

macOS、Linux、WSL では、`git clone --filter` で作成した部分クローンは、クローンがすべての追跡ファイルをローカルに保持している限り、履歴なしの作業ツリーのスナップショットとしてアップロードされます。

`claude --cloud` の場合、リポジトリが GitHub 上にあれば、アップロードとその要件を回避できます。ブランチをプッシュし、リポジトリに Claude GitHub App をインストールしてから、GitHub からクローンされるようにセッションを再度開始してください。

<h3 id="send-follow-ups-from-the-cli">
  CLI からフォローアップを送信
</h3>

クラウドセッションが実行されている場合、どこで実行されていても、`claude auth login` でサインインしている任意のマシンの `claude` CLI からそれにフォローアップメッセージを送信します。CLI は Anthropic アカウントの認証情報で認証し、ローカルセッション状態を送信しないため、コマンドはセッションを開始したマシンから実行する必要はありません。

コマンドは 1 つのメッセージを投稿して終了します：

```bash theme={null}
claude -p "your message" --cloud <session-id>
```

CLI はメッセージをセッションにキューイングして、返信を待たずに終了します。長時間実行されるセッションを操舵し、現在のセッションがまだ終了している間に次のステップをキューイングするか、[CI スクリプト](/docs/ja/self-hosted-environments-testing#run-the-test-loop)からフォローアップを送信するために使用します。代わりに stdin でメッセージをパイプすることもできます：`echo "your message" | claude -p --cloud <session-id>`。

`<session-id>` については、`session_...` または `cse_...` などの裸の ID、またはセッションの `claude.ai/code/<id>` URL をスキーム、クエリ文字列の有無で渡します。ID は claude.ai/code のセッションリストで見つけます。

<Note>
  `--cloud` には Anthropic アカウントが必要です。Claude Code が Amazon Bedrock、Google Cloud の Agent Platform、または別のサードパーティプロバイダー用に設定されている場合は利用できません。`ANTHROPIC_BASE_URL` を通じてのみ設定された[LLM ゲートウェイ](/docs/ja/llm-gateway)はこのチェックではサードパーティプロバイダーとしてカウントされませんが、`claude auth login` でサインインする必要があります。組織の `allow_remote_sessions` ポリシーも有効にする必要があります。Owner は claude.ai/admin-settings/claude-code の Claude Code 管理設定でオンにできます。
</Note>

<h4 id="output">
  出力
</h4>

成功時に、コマンドはセッション ID とセッションを表示するリンクを出力します：

```
Sent to cloud session.
Session ID: session_01DiUkqY2kzbUbDmW1w96rfi
View: https://claude.ai/code/session_01DiUkqY2kzbUbDmW1w96rfi?from=cli&m=0
```

マシン可読結果の場合は `--output-format json` を渡します：成功時は `{ok, session_id, url}`、送信が失敗した場合は `{ok: false, session_id, error}`（例えば、セッションが見つからないか、アーカイブされている場合）。設定エラー（サポートされていないプロバイダーや無効な組織ポリシーなど）は JSON なしで stderr に出力されます。`--output-format stream-json` は `--cloud <session-id>` ではサポートされていません。

送信が失敗した場合は、[クラウドセッションへの送信時のエラー](#errors-when-sending-to-a-cloud-session)を参照してください。

<h3 id="from-cloud-to-terminal">
  クラウドからターミナルへ
</h3>

以下のいずれかを使用してクラウドセッションをターミナルにプルします：

* **`--teleport` を使用**：コマンドラインから `claude --teleport` を実行してインタラクティブセッションピッカーを表示するか、`claude --teleport <session-id>` を実行して特定のセッションを直接再開します。コミットされていない変更がある場合は、最初にそれらをスタッシュするよう求められます。
* **`/teleport` を使用**：既存の CLI セッション内で `/teleport` または `/tp` を実行して、Claude Code を再起動せずに同じセッションピッカーを開きます。
* **`/tasks` から**：`/tasks` を実行してバックグラウンドセッションを表示し、`t` を押してセッションにテレポートします。
* **claude.ai/code から**：セッションメニューから **Open in > Terminal** を選択して、ターミナルに貼り付けられるコマンドをコピーします。
* **クラウドセッション内から**：`/teleport` を入力すると、Claude Code はそのセッションの正確な `claude --teleport <session-id>` コマンドで返信し、リポジトリのチェックアウトから実行する準備ができています。セッションの環境で Claude Code v2.1.223 以降が必要です。

セッションをテレポートすると、Claude はあなたが正しいリポジトリにいることを確認し、クラウドセッションからブランチをフェッチしてチェックアウトし、完全な会話履歴をターミナルに読み込みます。ターミナルはセッションの独自のコピーを取得します：そこでの新しい作業はローカルのままで、claude.ai または Claude モバイルアプリのクラウドセッションに表示されません。テレポート後に電話から操舵を続けるには、ローカルセッションで [`/remote-control`](/docs/ja/remote-control) を開始します。

`--teleport` は `--resume` とは異なります。`--resume` はこのマシンのローカル履歴から会話を再開し、クラウドセッションをリストしません。`--teleport` はクラウドセッションとそのブランチをプルします。

<h4 id="teleport-requirements">
  テレポート要件
</h4>

テレポートはセッションを再開する前にこれらの要件をチェックします。要件が満たされていない場合は、エラーが表示されるか、問題を解決するよう求められます。

| 要件 | 詳細 |
| - | - |
| クリーンな git 状態 | 作業ディレクトリにコミットされていない変更がないことが必要です。テレポートは必要に応じて変更をスタッシュするよう求めます。 |
| 正しいリポジトリ | フォークではなく、同じリポジトリのチェックアウトから `--teleport` を実行する必要があります。別のリポジトリのチェックアウトから実行する場合、Claude Code はセッションのリポジトリとチェックアウトのリポジトリの両方を示すエラーを表示します。Claude Code がリモートをホスト名に解析できない場合（`git@work:owner/repo.git` のような SSH ホストエイリアスなど）、確認を求め、リモートの所有者とリポジトリ名がセッションのリポジトリと一致する場合、チェックアウトを受け入れます。 |
| ブランチが利用可能 | クラウドセッションからのブランチがリモートにプッシュされている必要があります。テレポートは自動的にフェッチしてチェックアウトします。 |
| 同じアカウント | クラウドセッションで使用された同じ claude.ai アカウントに認証される必要があります。 |

Teleport がセッションのブランチをフェッチする際、フェッチがターミナルでの入力を待つことはありません。git や ssh がパスワード、鍵のパスフレーズ、または新しい SSH ホストの確認を求める場合、フェッチは失敗し、その後のチェックアウトはローカルクローンにすでにそのブランチがある場合にのみ成功します。SSH の 2 つのケースについては、鍵を `ssh-agent` に読み込み、事前に一度手動で `git fetch` を実行してホストを記録してください。

<h4 id="teleport-is-unavailable">
  `--teleport` が利用できない
</h4>

Teleport には claude.ai サブスクリプション認証が必要です。該当するケースを確認してください：

* **API キーで認証されている場合**：代わりに claude.ai アカウントでサインインするために `/login` を実行してください
* **エラーにプロバイダー名が表示される場合**：クラウドセッションはサードパーティプロバイダーを通じて利用できません。[エラーテーブル](#errors-when-sending-to-a-cloud-session)を参照してください
* **すでに claude.ai 経由でサインインしている場合**：組織がクラウドセッションを無効にしている可能性があります

<h2 id="work-with-sessions">
  セッションの操作
</h2>

セッションは claude.ai/code のサイドバーに表示されます。そこから変更を確認し、チームメイトと共有し、完了した作業をアーカイブするか、セッションを永続的に削除できます。

<h3 id="permission-modes-in-cloud-sessions">
  クラウドセッションの権限モード
</h3>

クラウドセッションの[権限モード](/docs/ja/permission-modes)は[モードドロップダウン](/docs/ja/permission-modes#switch-permission-modes)から選択します。タスクを作成するときとセッションが実行されている間の両方で選択できます。

次のいずれかを行うと、Claude Code はセッションが直前にあった権限モードでセッションを再開します：

* Anthropic ホスト型の[環境が有効期限切れ](#environment-expired)になったセッションを再度開く
* セルフホスト型ランナーが[アイドル中にリリース](/docs/ja/self-hosted-environments-reference#runner-cli-flags)したセッションにメッセージを送信する

<h3 id="review-changes">
  変更を確認
</h3>

各セッションは追加および削除された行数を示す差分インジケーター（例：`+42 -18`）を表示します。それを選択して差分ビューを開き、特定の行にインラインコメントを残し、次のメッセージで Claude に送信します。

差分ビューは、デフォルトでセッションの変更をそのベースブランチと比較します。リポジトリ内の他の任意のブランチと比較するには、**Compare against** を選択してブランチを 1 つ選びます。

Claude Code はこれらの差分を raw git blob コンテンツから計算するため、リポジトリで設定された diff ドライバーと `textconv` フィルターは適用されません。

以下の手順は別の場所で説明しています：

* **PR 作成を含む完全なウォークスルー**：[Review and iterate](/docs/ja/web-quickstart#review-and-iterate) を参照してください
* **Claude に PR の CI 失敗とレビューコメントを自動的に監視させる**：[プルリクエストの自動修正](#auto-fix-pull-requests)を参照してください

<h3 id="manage-context">
  コンテキストを管理
</h3>

クラウドセッションは[組み込みコマンド](/docs/ja/commands)をサポートしており、テキスト出力を生成します。ターミナルインターフェイスでのみ実行されるコマンド（`/plugin` や `/resume` など）は利用できません。ターミナルでピッカーまたはパネルを開くコマンドはクラウドセッションで異なる動作をします：

* **`/model`、`/effort`、`/color`、`/rename`**：ターミナルピッカーまたはスライダーを開く代わりに、引数として値を渡します。例えば `/model sonnet` のように使用します。引数形式はセッションの環境で Claude Code v2.1.205 以降が必要であり、各コマンドの[利用可能性に関する注記](/docs/ja/commands#all-commands)に従います。
* **`/fast`**：アカウントで[利用可能な場合](/docs/ja/fast-mode#requirements)、セッションの[ファストモード](/docs/ja/fast-mode#use-fast-mode-in-cloud-sessions)を切り替えます。セッションの環境で Claude Code v2.1.271 以降が必要です。
* **`/config`**：ブラウザの claude.ai/code では、値を設定する代わりに Claude Code セクションの設定を開き、`key=value` を含むコマンド後のテキストは無視されます。クラウドセッションの設定を変更するには、[環境変数](/docs/ja/cloud-environments#set-environment-variables)を環境に設定するか、1 つのリポジトリを持つセッションでキーをそのリポジトリの `.claude/settings.json` にコミットします。[クラウドセッションの設定](/docs/ja/settings#settings-in-cloud-sessions)には各セッションが読み込むものが記載されています。

コンテキスト管理の場合：

| コマンド | クラウドセッションで機能 | 注記 |
| :- | :- | :- |
| `/compact` | はい | 会話を要約してコンテキストを解放します。`/compact keep the test output` のようなオプションのフォーカス指示を受け入れます |
| `/context` | はい | 現在コンテキストウィンドウにあるものを表示します |
| `/clear` | いいえ | サイドバーから新しいセッションを開始します |

自動圧縮はコンテキストウィンドウが容量に近づくと自動的に実行されます。クラウドセッションは [`CLAUDE_AUTOCOMPACT_PCT_OVERRIDE`](/docs/ja/env-vars) をセッション自身で設定するため、圧縮はウィンドウが満杯になるのではなく、[自動圧縮ウィンドウ](/docs/ja/model-config#set-the-auto-compact-window)の途中でトリガーされます。その値は[環境変数](/docs/ja/cloud-environments#set-environment-variables)に追加するものをオーバーライドするため、そこに変数を追加しても圧縮がトリガーされるタイミングは変わりません。

自動圧縮ウィンドウを変更するには、環境変数で [`CLAUDE_CODE_AUTO_COMPACT_WINDOW`](/docs/ja/env-vars) を設定するか、変数が設定されていないセッションで [`/autocompact`](/docs/ja/commands#all-commands) をトークン数で実行します。

[Subagents](/docs/ja/sub-agents)はローカルと同じように機能します。Claude は Agent ツールでそれらをスポーンして、研究または並列作業を別のコンテキストウィンドウにオフロードし、メイン会話を軽くすることができます。リポジトリの `.claude/agents/` で定義された Subagents は自動的にピックアップされます。

[Agent teams](/docs/ja/agent-teams)はデフォルトでオフですが、[環境変数](/docs/ja/cloud-environments#set-environment-variables)に `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1` を追加することで有効にできます。

<h3 id="take-back-a-queued-message">
  キューに入ったメッセージを取り戻す
</h3>

Claude が作業中にメッセージを送信すると、Claude がそれを読むまでメッセージはキューに入ります。キューに入ったメッセージを取り戻すには、その上の ✕ をクリックします。テキストはメッセージボックスに戻るため、編集するか別のものを送信できます。

Claude がすでにメッセージを読んでいる場合、それは会話に留まります。

<h3 id="share-sessions">
  セッションを共有
</h3>

セッションを共有するには、以下のアカウントタイプに従ってその可視性を切り替えます。その後、セッションリンクをそのまま共有します。受信者はリンクを開くと最新の状態を表示しますが、ビューはリアルタイムで更新されません。

<h4 id="share-from-an-enterprise-or-team-account">
  Enterprise または Team アカウントから共有
</h4>

Enterprise および Team アカウントでは、共有は次のように機能します：

* **可視性オプション**：**Private** と **Team**。Team 可視性により、セッションは claude.ai 組織の他のメンバーに表示されます
* **リポジトリアクセス**：検証はデフォルトで有効になっており、受信者のアカウントに接続された GitHub アカウントに基づいて行われます
* **ユーザーの名前**：アカウントの表示名はアクセス権を持つすべての受信者に表示されます
* **Slack セッション**：[Claude in Slack](/docs/ja/slack) セッションは自動的に Team 可視性で共有されます

<h4 id="share-from-a-max-or-pro-account">
  Max または Pro アカウントから共有
</h4>

Max および Pro アカウントでは、共有は次のように機能します：

* **可視性オプション**：**Private** と **Public**。Public 可視性により、セッションは claude.ai にログインしているすべてのユーザーに表示されます
* **リポジトリアクセス**：検証はデフォルトで有効になっていません
* **機密コンテンツ**：共有する前にセッションを確認してください。セッションにはプライベート GitHub リポジトリのコードと認証情報が含まれる可能性があります

受信者がリポジトリアクセスを持つことを要求するか、共有セッションから名前を非表示にするには、[**Settings > Claude Code > Sharing settings**](https://claude.ai/settings/claude-code) に移動します。

<h3 id="archive-sessions">
  セッションをアーカイブ
</h3>

セッションをアーカイブしてセッションリストを整理できます。アーカイブされたセッションはデフォルトのセッションリストから非表示になりますが、アーカイブされたセッションをフィルタリングして表示できます。

セッションをアーカイブするには、サイドバーのセッションにマウスを合わせてアーカイブアイコンを選択します。

<h3 id="delete-sessions">
  セッションを削除
</h3>

セッションを削除すると、セッションとそのデータが永続的に削除されます。このアクションは取り消せません。セッションは 2 つの方法で削除できます：

* **サイドバーから**：アーカイブされたセッションをフィルタリングし、削除するセッションにマウスを合わせて削除アイコンを選択します
* **セッションメニューから**：セッションを開き、セッションタイトルの横のドロップダウンを選択し、**Delete** を選択します

セッションが削除される前に確認するよう求められます。

<h2 id="auto-fix-pull-requests">
  プルリクエストの自動修正
</h2>

Claude はプルリクエストを監視し、CI 失敗とレビューコメントに自動的に応答できます。Claude は PR の GitHub アクティビティをサブスクライブし、チェックが失敗するかレビュアーがコメントを残すと、Claude は調査し、明確な場合は修正をプッシュします。

<Note>
  Auto-fix には Claude GitHub App がリポジトリにインストールされている必要があります。まだインストールしていない場合は、[GitHub App ページ](https://github.com/apps/claude)からインストールしてください。
</Note>

PR がどこから来たか、どのデバイスを使用しているかに応じて、auto-fix をオンにするにはいくつかの方法があります：

* **クラウドセッションで作成された PR**：claude.ai/code でセッションを開き、CI ステータスバーを開き、**Auto-fix** を選択します
* **ターミナルから**：PR のブランチにいる間に [`/autofix-pr`](/docs/ja/commands) を実行します。Claude Code は `gh` で開いている PR を検出し、クラウドセッションをスポーンし、1 ステップで auto-fix をオンにします
* **モバイルアプリから**：Claude に PR を auto-fix するよう指示します。例えば「watch this PR and fix any CI failures or review comments」
* **既存の PR**：PR URL をセッションに貼り付けて、Claude に auto-fix するよう指示します

Auto-fix は PR ごとのトグルです。監視を停止するには、claude.ai/code のセッションで CI ステータスバーを開き、**Auto-fix** トグルをクリアするか、Claude に PR の監視を停止するよう指示します。

<h3 id="how-claude-responds-to-pr-activity">
  Claude が PR アクティビティにどのように応答するか
</h3>

auto-fix がアクティブな場合、Claude は新しいレビューコメントと CI チェック失敗を含む PR の GitHub イベントを受け取ります。各イベントについて、Claude は調査して進め方を決定します：

* **明確な修正**：Claude が修正に確信があり、以前の指示と矛盾しない場合、Claude は変更を加え、プッシュし、セッションで何が行われたかを説明します
* **曖昧なリクエスト**：レビュアーのコメントが複数の方法で解釈される可能性がある場合、または建築的に重要なものが含まれている場合、Claude は行動する前にあなたに尋ねます
* **重複または無アクション イベント**：イベントが重複している場合、または変更が不要な場合、Claude はセッションでそれを記録して続行します

ベースブランチが進み、マージコンフリクトが作成されるときに GitHub は webhook を発行しないため、auto-fix は単独でコンフリクトに反応することはできません。コンフリクトを解決するには、セッションを開き、Claude にリベースするよう依頼してください。

Claude は PR を解決する際に GitHub のレビューコメントスレッドに返信する場合があります。これらの返信はあなたの GitHub アカウントを使用して投稿されるため、あなたのユーザー名の下に表示されますが、各返信は Claude Code から来たものとしてラベル付けされるため、レビュアーはそれがエージェントによって書かれたものであり、あなたが直接書いたものではないことを知っています。

<Warning>
  リポジトリが Atlantis、Terraform Cloud、または `issue_comment` イベントで実行されるカスタム GitHub Actions などのコメントトリガー自動化を使用する場合、Claude の返信がそれらのワークフローをトリガーする可能性があることに注意してください。auto-fix を有効にする前にリポジトリの自動化を確認し、PR コメントがインフラストラクチャをデプロイするか特権操作を実行できるリポジトリでは auto-fix を無効にすることを検討してください。
</Warning>

<h2 id="security-and-isolation">
  セキュリティと分離
</h2>

各クラウドセッションはいくつかのレイヤーを通じてマシンおよび他のセッションから分離されます：

* **分離された仮想マシン**：各セッションは分離された Anthropic 管理 VM で実行されます。セッションが組織によってルーティングされる[セルフホスト環境](/docs/ja/self-hosted-environments)は、代わりに独自のインフラストラクチャで実行され、分離はデプロイメントの責任です
* <span id="default-allowed-domains" />**ネットワークアクセス制御**：Anthropic ホスト型環境では、ネットワークアクセスはデフォルトで制限され、無効にできます。[ネットワークアクセス](/docs/ja/cloud-environments#network-access)でアクセスレベル、[デフォルト許可ドメイン](/docs/ja/cloud-environments#default-allowed-domains)、および許可リストを通過しないトラフィックを参照してください。セルフホスト型環境では、独自のネットワーク境界でセッション出力を制限します。ネットワークアクセスを無効にして実行する場合、Claude Code は Anthropic API と通信できます。これにより VM からデータが出ることを許可する可能性があります。
* **認証情報保護**：Anthropic ホスト型環境では、git 認証情報と署名キーはサンドボックスの外に留まり、プロキシはスコープ付き認証情報で認証します。セルフホスト型環境では、デプロイメントが git 認証情報を提供します；[git を設定](/docs/ja/self-hosted-environments-deploy#configure-git)を参照してください
* **API 認証情報**：Anthropic ホスト型環境の Pro および Max プランでは、[クラウド環境に追加](/docs/ja/cloud-environments#add-api-credentials)するキーはサンドボックスの外に留まり、セッションを離れた後、一致するリクエストに添付されます。セルフホスト型環境には API 認証情報がなく、Team および Enterprise プランはまだそれらを持っていません
* **セキュアな分析**：コードは PR を作成する前に分離されたセッション環境内で分析および変更されます

<h2 id="troubleshooting">
  トラブルシューティング
</h2>

`API Error: 500`、`529 Overloaded`、`429`、または `Prompt is too long` などの会話に表示される実行時 API エラーについては、[エラーリファレンス](/docs/ja/errors)を参照してください。これらのエラーとその修正は CLI および Desktop アプリと共有されます。以下のセクションはクラウドセッションに固有の問題をカバーしています。

<h3 id="session-creation-failed">
  セッション作成に失敗
</h3>

新しいセッションが `Session creation failed` で開始に失敗するか、プロビジョニングで停止する場合、Claude Code は VM をセッションに割り当てることができませんでした。

* [status.claude.com](https://status.claude.com) でクラウドセッションインシデントを確認してください
* 1 分後に再試行してください。容量はオンデマンドでプロビジョニングされます
* [GitHub 接続後にリポジトリが表示されない](/docs/ja/web-quickstart#no-repositories-appear-after-connecting-github)に従って、GitHub 接続がリポジトリに到達できることを確認してください

<h3 id="unable-to-get-organization-uuid">
  組織 UUID を取得できない
</h3>

`claude --cloud` と `claude --teleport` には claude.ai アカウントでのサインインが必要です。API キーで認証している場合、または保存されたアカウント詳細が古い場合、次のいずれかが表示されます。

* `Unable to get organization UUID`
* API キー認証では不十分であるというメッセージ
* セッション ID なしで `claude --teleport` を実行した場合、セッションピッカーでの `Error loading Claude Code sessions`

`/login` を実行して claude.ai アカウントでサインインし、コマンドを再試行してください。エラーにプロバイダー名が示されている場合は、[エラーテーブル](#errors-when-sending-to-a-cloud-session)を参照してください。クラウドセッションはサードパーティプロバイダーを通じては利用できません。

<h3 id="remote-control-session-expired-or-access-denied">
  Remote Control セッションの有効期限切れまたはアクセス拒否
</h3>

`--teleport` はクラウドセッションが使用する同じ Remote Control セッションインフラストラクチャを通じて接続するため、認証およびセッション有効期限エラーは Remote Control の表現で表示されます。`Remote Control session expired` または `Access denied` が表示される場合があります。接続トークンは短命で、アカウントにスコープされています。

* ローカルで `/login` を実行して認証情報をリフレッシュし、再接続してください
* セッションを所有する同じアカウントにサインインしていることを確認してください
* `Remote Control may not be available for this organization` が表示される場合、Owner がクラウドセッションを組織に対して有効にしていません

<h3 id="errors-when-sending-to-a-cloud-session">
  クラウドセッションへの送信時のエラー
</h3>

これらのエラーは、`-p` の有無にかかわらず、[`--cloud <session-id>`](#send-follow-ups-from-the-cli) を指定して `claude` を実行したときに発生します。CLI はエラーの先頭に `Error: ` を付けます。配信に失敗した場合は `failed to send message to cloud session <id>: <reason>` としてラップされます。

| メッセージ | 意味 |
| - | - |
| `Cloud sessions aren't available with <provider>. They run on Anthropic's infrastructure and require an Anthropic account.` | Claude Code がサードパーティプロバイダー向けに設定されています。メッセージには、`Amazon Bedrock` や `Google Vertex AI` など、設定で使用されているラベルでプロバイダー名が示されます。たとえば `CLAUDE_CODE_USE_BEDROCK` の設定を解除するなどしてそのプロバイダーの設定を削除し、Anthropic アカウントでサインインしてください（`claude auth login`）。 |
| `Cloud sessions are disabled by your organization's policy. Contact your organization admin to enable them.` | `allow_remote_sessions` 組織ポリシーがオフになっています。 |
| `Couldn't verify your organization's policy for cloud sessions. Check your network connection and try again.` | Claude Code が組織のポリシーを取得できなかったため、クラウドセッションが許可されていると仮定せずに送信を拒否しています。ネットワーク接続を確認して再試行してください。 |
| `Attaching to an existing cloud session is not enabled for your account.` | `-p` なしで `--cloud <session-id>` を実行しました。`claude -p "your message" --cloud <session-id>` でメッセージを送信してください。 |
| `Session not found: <id>` | ID または URL が、アクセス可能なセッションと一致しません。セッションの claude.ai/code URL と照合してください。 |
| `cloud session <id> is archived and cannot accept new messages` | セッションはアーカイブされています。代わりに新しいセッションを開始してください。 |

<h3 id="environment-expired">
  環境の有効期限切れ
</h3>

クラウドセッションは非アクティブ期間後に停止し、セッションの VM は回収されます。セッションは [MCP コネクタ](/docs/ja/cloud-environments#network-access)ツール呼び出しを承認するか、MCP サーバーにサインインするのを待っている間、非アクティブとしてカウントされ、その待機中に有効期限が切れる可能性があります。

[claude.ai/code](https://claude.ai/code) からセッションを再度開いて、新しい VM をプロビジョニングしてください。

* **復元されるもの**: 会話履歴
* **復元されないもの**: VM が回収されたときにまだ実行されていたバックグラウンド作業（サブエージェントやシェルコマンドなど）

<h2 id="limitations">
  制限事項
</h2>

クラウドセッションをワークフローに組み込む前に、以下の制約を考慮してください。

* **レート制限**: クラウドセッションは、アカウント内のすべての Claude および Claude Code の使用状況とレート制限を共有します。複数のタスクを並行実行すると、レート制限がそれに応じてより多く消費されます。クラウド VM に対する個別の計算料金はありません。
* **時間制限**: Claude が実行するコマンドと SessionStart フックにはデフォルトのタイムアウトがあり、変更できます。セットアップスクリプトはおよそ 5 分以内に完了した場合のみキャッシュされます。[時間制限](/docs/ja/cloud-environments#time-limits) を参照してください。
* **リポジトリ認証**: クラウドセッションをターミナルに取り込むことができるのは、同じアカウントで認証されている場合のみです。
* **プラットフォーム制限**: リポジトリのクローンとプルリクエストの作成には GitHub が必要です。自己ホスト型の [GitHub Enterprise Server](/docs/ja/github-enterprise-server) インスタンスは Team および Enterprise プランでサポートされています。GitLab、Bitbucket、またはその他の非 GitHub リポジトリをクラウドセッションに [ローカルバンドル](#send-local-repositories-without-github) として送信できます。これは `CCR_FORCE_BUNDLE=1` を設定することで実現できますが、セッションはその結果をリモートにプッシュバックできません。
* **組織 IP 許可リスト**: クラウドセッションは Anthropic 管理インフラストラクチャから Anthropic API を呼び出します。これはお客様のネットワークからではなく、[自己ホスト環境](/docs/ja/self-hosted-environments) のセッションはお客様自身のネットワークから呼び出します。組織で [IP 許可リスト](https://support.claude.com/en/articles/13200993-restrict-access-to-claude-with-ip-allowlisting) が有効になっている場合、Anthropic ホスト型のすべてのクラウドセッションは認証エラーで失敗します。同じことが [Code Review](/docs/ja/code-review) および Anthropic ホスト環境で実行される [routines](/docs/ja/routines) にも適用されます。自己ホスト環境にルーティングされたルーチンは、お客様自身のネットワークから API を呼び出します。Anthropic ホスト型サービスを組織の IP 許可リストから除外するには、[Anthropic サポート](https://support.claude.com/) にお問い合わせください。

<h2 id="related-resources">
  関連リソース
</h2>

* [クラウド環境](/docs/ja/cloud-environments)：クラウドセッションのネットワークアクセス、環境変数、セットアップスクリプトを設定
* [Projects](/docs/ja/claude-projects)：Claude がリポジトリ上で並列クラウドセッションを調整し、結果を報告する 1 つの会話
* [Ultrareview](/docs/ja/ultrareview)：クラウドサンドボックスで深いマルチエージェントコードレビューを実行
* [Routines](/docs/ja/routines)：スケジュール、API 呼び出し、または GitHub イベントに応答して作業を自動化
* [フック設定](/docs/ja/hooks)：セッションライフサイクルイベントでスクリプトを実行
* [すべての設定](/docs/ja/settings-reference)：すべての設定オプション
* [セキュリティ](/docs/ja/security)：分離保証とデータ処理
* [データ使用](/docs/ja/data-usage)：Anthropic がクラウドセッションから保持するもの
* [Claude Tag](https://claude.com/docs/claude-tag/overview)：Slack で実行される組織管理の @Claude で、同じクラウドインフラストラクチャで動作
