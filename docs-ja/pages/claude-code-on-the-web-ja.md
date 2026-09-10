> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# ウェブ上の Claude Code を使用する

> Move sessions between web and terminal with `--cloud` and `--teleport`, manage and share sessions, and auto-fix pull requests from the cloud.

<Note>
  Claude Code on the web is in research preview for Pro, Max, and Team users, and for Enterprise users with premium seats or Chat + Claude Code seats.
</Note>

ウェブ上の Claude Code は [claude.ai/code](https://claude.ai/code) の Anthropic 管理クラウドインフラストラクチャでタスクを実行するか、ルーティングされた場合は組織の[セルフホスト環境](/docs/ja/self-hosted-environments)で実行されます。セッションはブラウザを閉じても保持され、Claude モバイルアプリから監視できます。

<Tip>
  ウェブ上の Claude Code は初めてですか？[はじめに](/docs/ja/web-quickstart)から始めて、GitHub アカウントを接続し、最初のタスクを送信してください。
</Tip>

このページでは以下をカバーしています：

* [クラウド環境](#cloud-environments)：セッションが実行される場所、およびそれを設定する場所
* [GitHub 認証オプション](#github-authentication-options)：GitHub を接続する 2 つの方法
* [`--cloud` と `--teleport` を使用してウェブとターミナル間でタスクを移動](#move-tasks-between-web-and-terminal)
* [セッションの操作](#work-with-sessions)：権限モード、確認、共有、アーカイブ、削除
* [プルリクエストの自動修正](#auto-fix-pull-requests)：CI 失敗とレビューコメントに自動的に応答
* [セキュリティと分離](#security-and-isolation)：セッションの分離方法
* [制限事項](#limitations)：レート制限とプラットフォーム制限

<h2 id="cloud-environments">
  クラウド環境
</h2>

すべてのクラウドセッションは[クラウド環境](/docs/ja/cloud-environments)で実行されます。これはネットワークアクセス、環境変数、セットアップスクリプトを制御する保存された設定です。環境がまだない場合、オンボーディングは[**Trusted** ネットワークアクセス](/docs/ja/cloud-environments#access-levels)を持つ**Default** 環境をセットアップします。これは、あなたのために作成するか、作成するよう依頼するかのいずれかです。[Default 環境](/docs/ja/cloud-environments#the-default-environment)を参照して、どちらがあなたのプランで発生するか、および複数の環境がある場合にセッションが環境を選択する方法を確認してください。

同じ環境はクラウドセッションを開始する場所に関係なく適用されます：ウェブ、ターミナル、[Claude Tag](https://claude.com/docs/claude-tag/overview)、[ルーチン](/docs/ja/routines)、およびモバイルおよび Desktop アプリ。Claude Tag チャネルセッションは組織レベルの環境のみを使用します。[共有環境](/docs/ja/cloud-environments#organization-shared-environments)または[セルフホスト環境](/docs/ja/self-hosted-environments)のいずれかです。

[クラウド環境を設定](/docs/ja/cloud-environments)して、環境が許可するものを変更し、変数を設定するか、セットアップスクリプトを追加してください。[インストール済みツール](/docs/ja/cloud-environments#installed-tools)を参照して、設定なしでセッションに含まれるものを確認してください。

<h2 id="github-authentication-options">
  GitHub 認証オプション
</h2>

クラウドセッションはコードをクローンしてブランチをプッシュするために GitHub リポジトリへのアクセスが必要です。2 つの方法でアクセスを許可できます：

| 方法               | 仕組み                                                               | 最適な用途                                                     |
| :--------------- | :---------------------------------------------------------------- | :-------------------------------------------------------- |
| **GitHub App**   | [ウェブオンボーディング](/docs/ja/web-quickstart)中に Claude GitHub App を認可します。     | ブラウザオンボーディング；[Auto-fix](#auto-fix-pull-requests) を希望するチーム |
| **`/web-setup`** | ターミナルで `/web-setup` を実行して、ローカル `gh` CLI トークンを Claude アカウントに同期します。 | すでに `gh` を使用している個別開発者                                     |

<Note>
  どちらの方法でも、クラウドセッションは Claude GitHub App がインストールされているリポジトリだけでなく、接続している GitHub アカウントが見ることができるすべてのリポジトリにアクセスできます。App インストールは [Auto-fix](#auto-fix-pull-requests) の PR webhook を有効にします；これはセッションレベルのアクセス制御ではありません。クラウドセッションからチームが到達できるリポジトリを制限するには、GitHub 自体でアクセスを制限してください。たとえば、接続している GitHub アカウントのチームまたはリポジトリメンバーシップを制限することで実現できます。
</Note>

どちらの方法でも機能します。`/schedule` がアクセスをチェックしてからルーチンを作成する方法については、[リポジトリとブランチの権限](/docs/ja/routines#repositories-and-branch-permissions)を参照してください。[ターミナルから接続](/docs/ja/web-quickstart#connect-from-your-terminal)で `/web-setup` のウォークスルーを参照してください。

Quick web setup は、メンバーが `/web-setup` で GitHub を接続できるようにする組織設定で、ブラウザオンボーディング中に Claude GitHub App インストールプロンプトをスキップし、環境フォームを表示する代わりに、ブラウザオンボーディングが [**Default** 環境](/docs/ja/cloud-environments#the-default-environment)を作成するようにします。Team および Enterprise プランではデフォルトでオフになっており、`/web-setup` を非表示にします。[Owner](/docs/ja/server-managed-settings#access-control) は [**Admin settings > Claude Code**](https://claude.ai/admin-settings/claude-code) の **Quick web setup** トグルでオンにします。

<Note>
  [Zero Data Retention](/docs/ja/zero-data-retention) が有効な組織は `/web-setup` またはその他のクラウドセッション機能を使用できません。
</Note>

<h2 id="move-tasks-between-web-and-terminal">
  ウェブとターミナル間でタスクを移動
</h2>

これらのワークフローには [Claude Code CLI](/docs/ja/quickstart) が同じ claude.ai アカウントにサインインしている必要があります。ターミナルから新しいクラウドセッションを開始するか、クラウドセッションをターミナルにプルしてローカルで続行できます。クラウドセッションはラップトップを閉じても保持され、Claude モバイルアプリを含む任意の場所から監視できます。

<Note>
  CLI からのセッションハンドオフは一方向です：`--teleport` でクラウドセッションをターミナルにプルできますが、既存のターミナルセッションをウェブにプッシュすることはできません。`--cloud` フラグはタスク説明を使用して現在のリポジトリの新しいクラウドセッションを作成します；`-p` とセッション ID または claude.ai/code URL を使用すると、代わりに[その既存セッションにメッセージをキューイング](/docs/ja/claude-code-on-the-web#send-follow-ups-from-the-cli)します。[Desktop アプリ](/docs/ja/desktop#continue-in-another-surface)は別のサーフェスにローカルセッションを送信できる Continue in メニューを提供します。
</Note>

<h3 id="from-terminal-to-web">
  ターミナルからウェブへ
</h3>

`--cloud` フラグを使用してコマンドラインからクラウドセッションを開始します：

```bash theme={null}
claude --cloud "Fix the authentication bug in src/auth/login.ts"
```

これにより claude.ai 上に新しいクラウドセッションが作成されます。クラウド VM はローカルチェックアウトではなく、現在のブランチで現在のディレクトリの GitHub リモートをクローンするため、ローカルコミットがある場合は最初にプッシュしてください。`--cloud` は一度に 1 つのリポジトリで機能します。タスクはクラウドで実行され、ローカルで作業を続行できます。古い `--remote` スペルは `--cloud` の非推奨エイリアスとしてまだ機能します。

クラウドコンテナが起動している間、CLI はリポジトリのクローンやセットアップスクリプトの実行などのセットアップステップのライブチェックリストを表示します。プロビジョニング中に入力したメッセージはキューに入れられ、セッションの準備ができたら送信されます。

<Note>
  `--cloud` はクラウドセッションを作成します。`--remote-control` は無関係です：ウェブから監視するためにローカル CLI セッションを公開します。[Remote Control](/docs/ja/remote-control)を参照してください。
</Note>

Claude Code CLI で `/tasks` を使用して進捗をチェックするか、claude.ai または Claude モバイルアプリでセッションを開いて直接対話します。そこから Claude を操舵し、フィードバックを提供するか、他のすべての会話と同じように質問に答えることができます。

Claude が質問をして、セッションがアイドル状態のままの場合、[環境の有効期限切れ](#environment-expired)まで戻ってきたときに答えることができ、セッションはあなたの答えから続行されます。

<h4 id="tips-for-cloud-tasks">
  クラウドタスクのヒント
</h4>

**ローカルで計画し、リモートで実行する**：複雑なタスクの場合、Claude をプランモードで開始してアプローチについて協力し、その後ウェブに作業を送信します：

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

Claude Code CLI で `/tasks` を使用してすべてのセッションを監視します。セッションが完了したら、ウェブインターフェースから PR を作成するか、[セッションをテレポート](#from-web-to-terminal)してターミナルで作業を続行できます。

<h4 id="send-local-repositories-without-github">
  GitHub なしでローカルリポジトリを送信
</h4>

GitHub に接続されていないリポジトリから `claude --cloud` を実行する場合、Claude Code はローカルリポジトリをバンドルしてクラウドセッションに直接アップロードします。バンドルにはすべてのブランチ全体のリポジトリ履歴と、追跡されたファイルへのコミットされていない変更が含まれます。

macOS、Linux、WSL では、Claude Code は認証情報またはキーのような名前のファイルへのコミットされていない変更をアップロードから除外し、除外したファイルに名前を付けます。これは `.env` ファイル、Terraform `*.tfvars` ファイル、および `id_rsa` や `*.pem` などのキーファイルをカバーしています。セッションは各のコミットされたバージョンで開始するか、コミットされたものがない場合はファイルなしで開始されます。リンクされたワーキングツリー、サブモジュール、または同様のレイアウトでは、Claude Code はこれらの変更を残りと一緒にアップロードし、アップロードしたファイルに名前を付けます。

GitHub アクセスが利用できない場合、このフォールバックは自動的にアクティブになります。GitHub が接続されている場合でも強制するには、`CCR_FORCE_BUNDLE=1` を設定します：

```bash theme={null}
CCR_FORCE_BUNDLE=1 claude --cloud "Run the test suite and fix any failures"
```

バンドルされたリポジトリはこれらの制限を満たす必要があります：

* ディレクトリは少なくとも 1 つのコミットを持つ git リポジトリである必要があります
* バンドルされたリポジトリは 100 MB 未満である必要があります。より大きなリポジトリは現在のブランチのみをバンドルすることにフォールバックし、その後ワーキングツリーの単一の圧縮スナップショットにフォールバックし、スナップショットがまだ大きすぎる場合のみ失敗します
* 追跡されていないファイルは含まれません。クラウドセッションが見るべきファイルで `git add` を実行します
* バンドルから作成されたセッションは、[GitHub 認証](#github-authentication-options)も設定されていない限り、リモートにプッシュバックできません

<h3 id="send-follow-ups-from-the-cli">
  CLI からフォローアップを送信
</h3>

クラウドセッションが実行されている場合、どこで実行されていても、`claude auth login` でサインインしている任意のマシンの `claude` CLI からそれにフォローアップメッセージを送信します。CLI は Anthropic アカウント認証情報で認証し、ローカルセッション状態を送信しないため、コマンドはセッションを開始したマシンから実行する必要がなく、PowerShell を含むすべてのシェルで同じです。

コマンドは 1 つのメッセージを投稿して終了します：

```bash theme={null}
claude -p "your message" --cloud <session-id>
```

CLI はメッセージをセッションにキューイングして、返信を待たずに終了します。長時間実行されるセッションを操舵し、現在のセッションがまだ終了している間に次のステップをキューイングするか、[CI スクリプト](/docs/ja/self-hosted-environments-testing#run-the-test-loop)からフォローアップを送信するために使用します。代わりに stdin でメッセージをパイプすることもできます：`echo "your message" | claude -p --cloud <session-id>`。

`<session-id>` については、`session_...` または `cse_...` などの裸の ID、またはセッションの `claude.ai/code/<id>` URL をスキーム、クエリ文字列の有無で渡します。ID は claude.ai/code のセッションリストで見つけます。

<Note>
  `--cloud` には Anthropic アカウントが必要です。Claude Code が Amazon Bedrock、Google Cloud の Agent Platform、または別のサードパーティプロバイダー用に設定されている場合は利用できません。`ANTHROPIC_BASE_URL` を通じてのみ設定された[LLM ゲートウェイ](/docs/ja/llm-gateway)はこのチェックではサードパーティプロバイダーとしてカウントされませんが、`claude auth login` でサインインする必要があります。組織の `allow_remote_sessions` ポリシーも有効にする必要があります。Owner は claude.ai/admin-settings/claude-code の Claude Code 管理設定でオンにできます。
</Note>

<h4 id="output-and-errors">
  出力とエラー
</h4>

成功時に、コマンドはセッション ID とセッションを表示するリンクを出力します：

```
Sent to cloud session.
Session ID: session_01DiUkqY2kzbUbDmW1w96rfi
View: https://claude.ai/code/session_01DiUkqY2kzbUbDmW1w96rfi?from=cli&m=0
```

マシン可読結果の場合は `--output-format json` を渡します：成功時は `{ok, session_id, url}`、送信が失敗した場合は `{ok: false, session_id, error}`（例えば、セッションが見つからないか、アーカイブされている場合）。設定エラー（サポートされていないプロバイダーや無効な組織ポリシーなど）は JSON なしで stderr に出力されます。`--output-format stream-json` は `--cloud <session-id>` ではサポートされていません。

CLI はエラーの前に `Error: ` を付けます。失敗した配信は `failed to send message to cloud session <id>: <reason>` としてラップされます。

| メッセージ                                                                                                                       | 意味                                                                                                                                                                                                                   |
| --------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `Cloud sessions aren't available with <provider>. They run on Anthropic's infrastructure and require an Anthropic account.` | Claude Code はサードパーティプロバイダー用に設定されています。メッセージは設定が使用するラベル（`Amazon Bedrock` や `Google Vertex AI` など）でプロバイダーに名前を付けます。そのプロバイダーの設定を削除します（例えば、`CLAUDE_CODE_USE_BEDROCK` を設定解除）、Anthropic アカウント（`claude auth login`）でサインインします。 |
| `Cloud sessions are disabled by your organization's policy. Contact your organization admin to enable them.`                | `allow_remote_sessions` 組織ポリシーがオフです。                                                                                                                                                                                 |
| `Couldn't verify your organization's policy for cloud sessions. Check your network connection and try again.`               | Claude Code は組織のポリシーをフェッチできなかったため、クラウドセッションが許可されていると仮定するのではなく、送信を拒否します。ネットワーク接続を確認して再試行してください。                                                                                                                       |
| `Attaching to an existing cloud session is not enabled for your account.`                                                   | `-p` なしで `--cloud <session-id>` を実行しました。`claude -p "your message" --cloud <session-id>` でメッセージを送信します。                                                                                                                |
| `Session not found: <id>`                                                                                                   | ID または URL はアクセスできるセッションと一致しません。セッションの claude.ai/code URL に対して確認してください。                                                                                                                                              |
| `cloud session <id> is archived and cannot accept new messages`                                                             | セッションはアーカイブされています。代わりに新しいセッションを開始します。                                                                                                                                                                                |

<h3 id="from-web-to-terminal">
  ウェブからターミナルへ
</h3>

以下のいずれかを使用してクラウドセッションをターミナルにプルします：

* **`--teleport` を使用**：コマンドラインから `claude --teleport` を実行してインタラクティブセッションピッカーを表示するか、`claude --teleport <session-id>` を実行して特定のセッションを直接再開します。コミットされていない変更がある場合は、最初にそれらをスタッシュするよう求められます。
* **`/teleport` を使用**：既存の CLI セッション内で `/teleport` または `/tp` を実行して、Claude Code を再起動せずに同じセッションピッカーを開きます。
* **`/tasks` から**：`/tasks` を実行してバックグラウンドセッションを表示し、`t` を押してセッションにテレポートします。
* **ウェブインターフェースから**：セッションメニューから **Open in > Terminal** を選択して、ターミナルに貼り付けられるコマンドをコピーします。
* **クラウドセッション内から**：`/teleport` を入力すると、Claude Code はそのセッションの正確な `claude --teleport <session-id>` コマンドで返信し、リポジトリのチェックアウトから実行する準備ができています。セッションの環境で Claude Code v2.1.223 以降が必要です。

セッションをテレポートすると、Claude は正しいリポジトリにいることを確認し、クラウドセッションからブランチをフェッチしてチェックアウトし、完全な会話履歴をターミナルに読み込みます。ターミナルはセッションの独自のコピーを取得します：そこでの新しい作業はローカルのままで、claude.ai または Claude モバイルアプリのクラウドセッションに表示されません。テレポート後に電話から操舵を続けるには、ローカルセッションで [`/remote-control`](/docs/ja/remote-control) を開始します。

`--teleport` は `--resume` とは異なります。`--resume` はこのマシンのローカル履歴から会話を再開し、クラウドセッションをリストしません。`--teleport` はクラウドセッションとそのブランチをプルします。

<h4 id="teleport-requirements">
  テレポート要件
</h4>

テレポートはセッションを再開する前にこれらの要件をチェックします。要件が満たされていない場合は、エラーが表示されるか、問題を解決するよう求められます。

| 要件           | 詳細                                                                                                                                                                                                                                                                       |
| ------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| クリーンな git 状態 | 作業ディレクトリにコミットされていない変更がないことが必要です。テレポートは必要に応じて変更をスタッシュするよう求めます。                                                                                                                                                                                                            |
| 正しいリポジトリ     | フォークではなく、同じリポジトリのチェックアウトから `--teleport` を実行する必要があります。別のリポジトリのチェックアウトから実行する場合、Claude Code はセッションのリポジトリとチェックアウトの両方に名前を付けるエラーを表示します。Claude Code がリモートをホスト名に解析できない場合（`git@work:owner/repo.git` のような SSH ホストエイリアスなど）、確認を求め、リモートの所有者とリポジトリ名がセッションのリポジトリと一致する場合、チェックアウトを受け入れます。 |
| ブランチが利用可能    | クラウドセッションからのブランチがリモートにプッシュされている必要があります。テレポートは自動的にフェッチしてチェックアウトします。                                                                                                                                                                                                       |
| 同じアカウント      | クラウドセッションで使用された同じ claude.ai アカウントに認証される必要があります。                                                                                                                                                                                                                          |

<h4 id="teleport-is-unavailable">
  `--teleport` が利用できない
</h4>

テレポートには claude.ai サブスクリプション認証が必要です。API キーで認証されている場合は、代わりに claude.ai アカウントでサインインするために `/login` を実行してください。エラーがプロバイダーに名前を付ける場合、クラウドセッションはサードパーティプロバイダーを通じて利用できません；[エラーテーブル](#output-and-errors)を参照してください。claude.ai 経由で既にサインインしており、`--teleport` がまだ利用できない場合は、組織がクラウドセッションを無効にしている可能性があります。

<h2 id="work-with-sessions">
  セッションの操作
</h2>

セッションは claude.ai/code のサイドバーに表示されます。そこから変更を確認し、チームメイトと共有し、完了した作業をアーカイブするか、セッションを永続的に削除できます。

<h3 id="manage-context">
  コンテキストを管理
</h3>

クラウドセッションは[組み込みコマンド](/docs/ja/commands)をサポートしており、テキスト出力を生成します。ターミナルインターフェイスでのみ実行されるコマンド（`/plugin` や `/resume` など）は利用できません。ターミナルでピッカーまたはパネルを開くコマンドはクラウドセッションで異なる動作をします：

* **`/model`、`/effort`、`/fast`、`/color`、`/rename`**：ターミナルピッカーまたはスライダーを開く代わりに、引数として値を渡します。例えば `/model sonnet` のように使用します。引数形式はセッションの環境で Claude Code v2.1.205 以降が必要であり、各コマンドの[利用可能性に関する注記](/docs/ja/commands#all-commands)に従います。`/effort` はモデルの[起動デフォルト努力保持](/docs/ja/model-config#adjust-effort-level)が有効な場合は `Not applied` を報告し、`/fast` はファストモードを有効にして開始されたセッションでのみ機能します。
* **`/config`**：ウェブ上では、値を設定する代わりに Claude Code セクションの設定を開き、`key=value` を含むコマンド後のテキストは無視されます。クラウドセッションの設定を変更するには、[環境変数](/docs/ja/cloud-environments#set-environment-variables)を使用するか、[設定ファイル](/docs/ja/settings)をリポジトリにコミットします。

コンテキスト管理の場合：

| コマンド       | クラウドセッションで機能 | 注記                                                                           |
| :--------- | :----------- | :--------------------------------------------------------------------------- |
| `/compact` | はい           | 会話を要約してコンテキストを解放します。`/compact keep the test output` のようなオプションのフォーカス指示を受け入れます |
| `/context` | はい           | 現在コンテキストウィンドウにあるものを表示します                                                     |
| `/clear`   | いいえ          | サイドバーから新しいセッションを開始します                                                        |

自動圧縮はコンテキストウィンドウが容量に近づくと自動的に実行されます。Claude Code on the web は [`CLAUDE_AUTOCOMPACT_PCT_OVERRIDE`](/docs/ja/env-vars) をクラウドセッションで自身で設定するため、圧縮はウィンドウが満杯になるのではなく、[自動圧縮ウィンドウ](/docs/ja/model-config#set-the-auto-compact-window)の途中でトリガーされます。その値は[環境変数](/docs/ja/cloud-environments#set-environment-variables)に追加するものをオーバーライドするため、そこに変数を追加しても圧縮がトリガーされるタイミングは変わりません。

自動圧縮ウィンドウを変更するには、[環境変数](/docs/ja/cloud-environments#set-environment-variables)で [`CLAUDE_CODE_AUTO_COMPACT_WINDOW`](/docs/ja/env-vars) を設定するか、変数が設定されていないセッションで [`/autocompact`](/docs/ja/commands#all-commands) をトークン数で実行します。

[Subagents](/docs/ja/sub-agents)はローカルと同じように機能します。Claude は Agent ツールでそれらをスポーンして、研究または並列作業を別のコンテキストウィンドウにオフロードし、メイン会話を軽くすることができます。リポジトリの `.claude/agents/` で定義された Subagents は自動的にピックアップされます。

[Agent teams](/docs/ja/agent-teams)はデフォルトでオフですが、[環境変数](/docs/ja/cloud-environments#set-environment-variables)に `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1` を追加することで有効にできます。

<h3 id="permission-modes-in-cloud-sessions">
  クラウドセッションの権限モード
</h3>

クラウドセッションの[権限モード](/docs/ja/permission-modes)は[モードドロップダウン](/docs/ja/permission-modes#switch-permission-modes)から選択します。タスクを作成するときとセッションが実行されている間の両方です。Anthropic ホスト型[環境が有効期限切れ](#environment-expired)になったセッションを再度開くか、セルフホスト型ランナーが[アイドル中にリリース](/docs/ja/self-hosted-environments-reference#runner-cli-flags)したセッションにメッセージを送信する場合、Claude Code はセッションが存在していた権限モードで再開されます。

<h3 id="review-changes">
  変更を確認
</h3>

各セッションは追加および削除された行数を示す diff インジケーター（例：`+42 -18`）を表示します。それを選択して diff ビューを開き、特定の行にインラインコメントを残し、次のメッセージで Claude に送信します。

Claude Code はこれらの diff を計算します。これには Claude が編集するときに表示される per-file diff が含まれます。これは raw git blob コンテンツから計算されるため、リポジトリで設定された diff ドライバーと `textconv` フィルターは適用されません。

PR 作成を含む完全なウォークスルーについては [Review and iterate](/docs/ja/web-quickstart#review-and-iterate) を参照してください。Claude が PR の CI 失敗とレビューコメントを自動的に監視するようにするには、[プルリクエストの自動修正](#auto-fix-pull-requests)を参照してください。

<h3 id="share-sessions">
  セッションを共有
</h3>

セッションを共有するには、以下のアカウントタイプに従ってその可視性を切り替えます。その後、セッションリンクをそのまま共有します。受信者はリンクを開くと最新の状態を表示しますが、ビューはリアルタイムで更新されません。

<h4 id="share-from-an-enterprise-or-team-account">
  Enterprise または Team アカウントから共有
</h4>

Enterprise および Team アカウントの場合、2 つの可視性オプションは **Private** と **Team** です。Team 可視性により、セッションは claude.ai 組織の他のメンバーに表示されます。[Claude in Slack](/docs/ja/slack)セッションは自動的に Team 可視性で共有されます。

リポジトリアクセス検証はデフォルトで有効になっており、受信者のアカウントに接続された GitHub アカウントに基づいています。アカウントの表示名はアクセス権を持つすべての受信者に表示されます。

<h4 id="share-from-a-max-or-pro-account">
  Max または Pro アカウントから共有
</h4>

Max および Pro アカウントの場合、2 つの可視性オプションは **Private** と **Public** です。Public 可視性により、セッションは claude.ai にログインしているすべてのユーザーに表示されます。

共有する前にセッションで機密コンテンツを確認してください。セッションにはプライベート GitHub リポジトリのコードと認証情報が含まれる可能性があります。リポジトリアクセス検証はデフォルトで有効になっていません。

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

* **ウェブ上の Claude Code で作成された PR**：CI ステータスバーを開き、**Auto-fix** を選択します
* **ターミナルから**：PR のブランチにいる間に [`/autofix-pr`](/docs/ja/commands) を実行します。Claude Code は `gh` で開いている PR を検出し、ウェブセッションをスポーンし、1 ステップで auto-fix をオンにします
* **モバイルアプリから**：Claude に PR を auto-fix するよう指示します。例えば「watch this PR and fix any CI failures or review comments」
* **既存の PR**：PR URL をセッションに貼り付けて、Claude に auto-fix するよう指示します

Auto-fix は PR ごとのトグルです。監視を停止するには、ウェブセッションで CI ステータスバーを開き、**Auto-fix** トグルをクリアするか、Claude に PR の監視を停止するよう指示します。

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
* **ネットワークアクセス制御**：Anthropic ホスト型環境では、ネットワークアクセスはデフォルトで制限され、無効にできます。セルフホスト型環境では、独自のネットワーク境界でセッション出力を制限します。ネットワークアクセスを無効にして実行する場合、Claude Code は Anthropic API と通信できます。これにより VM からデータが出ることを許可する可能性があります。
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

新しいセッションが `Session creation failed` で開始に失敗するか、プロビジョニングで停止する場合、Claude Code はクラウド環境を割り当てることができませんでした。

* [status.claude.com](https://status.claude.com) でクラウドセッションインシデントを確認してください
* 1 分後に再試行してください。容量はオンデマンドでプロビジョニングされます
* リポジトリが到達可能であることを確認してください。接続している GitHub アカウントは、Claude GitHub App 認可またはオンデマンドで `/web-setup` 経由で同期された `gh` トークンのいずれかを通じて、GitHub 上のリポジトリへのアクセス権を持つ必要があります。リポジトリに App をインストールする必要はありません。[GitHub 認証オプション](#github-authentication-options)を参照してください。

<h3 id="unable-to-get-organization-uuid">
  組織 UUID を取得できない
</h3>

`claude --cloud` と `claude --teleport` には claude.ai アカウントでのサインインが必要です。API キーで認証されている場合、または保存されたアカウント詳細が古い場合、これらのコマンドは `Unable to get organization UUID` で失敗するか、API キー認証が十分でないというメッセージが表示されます。API キー認証または古いアカウント詳細を使用して、セッション ID なしで `claude --teleport` を実行すると、どちらかのメッセージの代わりにセッションピッカーで `Error loading Claude Code sessions` が表示され、同じ修正が適用されます。

`/login` を実行して claude.ai アカウントでサインインし、コマンドを再試行してください。エラーがプロバイダーに名前を付ける場合は、[エラーテーブル](#output-and-errors)を参照してください：クラウドセッションはサードパーティプロバイダーを通じて利用できません。

<h3 id="remote-control-session-expired-or-access-denied">
  Remote Control セッションの有効期限切れまたはアクセス拒否
</h3>

`--teleport` はクラウドセッションが使用する同じ Remote Control セッションインフラストラクチャを通じて接続するため、認証およびセッション有効期限エラーは Remote Control の表現で表示されます。`Remote Control session expired` または `Access denied` が表示される場合があります。接続トークンは短命で、アカウントにスコープされています。

* ローカルで `/login` を実行して認証情報をリフレッシュし、再接続してください
* セッションを所有する同じアカウントにサインインしていることを確認してください
* `Remote Control may not be available for this organization` が表示される場合、Owner がクラウドセッションを組織に対して有効にしていません

<h3 id="environment-expired">
  環境の有効期限切れ
</h3>

クラウドセッションは非アクティブ期間後に停止し、セッションの VM は回収されます。ウェブでは、セッションはセッションリストで期限切れとしてマークされます。

[claude.ai/code](https://claude.ai/code) からセッションを再度開いて、会話履歴が復元された新しい VM をプロビジョニングしてください。VM が回収されたときにまだ実行されていたバックグラウンド作業（subagents やシェルコマンドなど）は復元されません。

<h2 id="limitations">
  制限事項
</h2>

クラウドセッションをワークフローに依存させる前に、これらの制約を考慮してください：

* **レート制限**：ウェブ上の Claude Code はアカウント内のすべての他の Claude および Claude Code 使用とレート制限を共有します。複数のタスクを並列で実行すると、レート制限をより多く消費します。クラウド VM に対する個別のコンピュート料金はありません。
* **リポジトリ認証**：ウェブからローカルにセッションを移動できるのは、同じアカウントに認証されている場合のみです
* **プラットフォーム制限**：リポジトリのクローンとプルリクエストの作成には GitHub が必要です。セルフホスト型の [GitHub Enterprise Server](/docs/ja/github-enterprise-server) インスタンスは Team および Enterprise プランでサポートされています。GitLab、Bitbucket、およびその他の非 GitHub リポジトリは[ローカルバンドル](#send-local-repositories-without-github)としてクラウドセッションに送信できますが、セッションはリモートに結果をプッシュバックできません
* **組織 IP 許可リスト**：クラウドセッションは Anthropic 管理インフラストラクチャから Anthropic API を呼び出すため、ネットワークからではありません。セッションが[セルフホスト環境](/docs/ja/self-hosted-environments)にルーティングされている場合、独自のネットワークから呼び出します。組織が [IP 許可リスト](https://support.claude.com/en/articles/13200993-restrict-access-to-claude-with-ip-allowlisting)を有効にしている場合、すべての Anthropic ホスト型クラウドセッションは認証エラーで失敗します。同じことが [Code Review](/docs/ja/code-review) および Anthropic ホスト型環境で実行される[ルーチン](/docs/ja/routines)に適用されます；セルフホスト型環境にルーティングされたルーチンは独自のネットワークから API を呼び出します。[Anthropic サポート](https://support.claude.com/)に連絡して、Anthropic ホスト型サービスを組織の IP 許可リストから除外してください。

<h2 id="related-resources">
  関連リソース
</h2>

* [クラウド環境](/docs/ja/cloud-environments)：クラウドセッションのネットワークアクセス、環境変数、セットアップスクリプトを設定
* [Ultrareview](/docs/ja/ultrareview)：クラウドサンドボックスで深いマルチエージェントコードレビューを実行
* [ルーチン](/docs/ja/routines)：スケジュール、API 呼び出し、または GitHub イベントに応答して作業を自動化
* [フック設定](/docs/ja/hooks)：セッションライフサイクルイベントでスクリプトを実行
* [すべての設定](/docs/ja/settings-reference)：すべての設定オプション
* [セキュリティ](/docs/ja/security)：分離保証とデータ処理
* [データ使用](/docs/ja/data-usage)：Anthropic がクラウドセッションから保持するもの
* [Claude Tag](https://claude.com/docs/claude-tag/overview)：Slack で実行される組織管理の @Claude で、同じクラウドインフラストラクチャで動作
