> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# クラウドで Claude Code を使用する

> ブラウザ、携帯電話、デスクトップアプリ、またはターミナルからクラウドで Claude Code セッションを実行し、`--cloud` と `--teleport` で移動し、プルリクエストを自動修正します。

> [!NOTE]
>
> クラウドセッションは Pro、Max、Ultra、Team プランで利用でき、Premium シートまたは Chat + Claude Code シートを持つ Enterprise ユーザーも対象です。[カスタムロール](https://support.claude.com/en/articles/13930452)でアクセスが管理されている場合、ブラウザ、アプリ、またはターミナルから Anthropic のインフラストラクチャでセッションを開始するには、クラウドセッションの権限を含むロールも必要です。Owner に依頼して、[**Organization settings > Roles**](https://claude.ai/admin-settings/roles) でいずれかのロールにこの権限を追加してもらってください。

クラウドセッションは、マシン上ではなくクラウドインフラストラクチャで実行される Claude Code セッションです。デフォルトでは Anthropic が管理するインフラストラクチャで実行されるか、ルーティングされた場合は組織の[セルフホスト環境](https://code.claude.com/docs/ja/self-hosted-environments)で実行されます。セッションはラップトップを閉じた後も実行を続け、任意のデバイスから確認または操作できます。クラウドセッションは、Claude および Claude Code のその他の使用量と合わせてプランの使用制限にカウントされ、クラウド VM に対する別途料金はかかりません。

クラウドセッションが GitHub からコードをクローンしてブランチをプッシュできるようにするには、いずれかの [GitHub 接続方法](#github-authentication-options)で GitHub を接続します。リポジトリが GitLab、Bitbucket、またはその他のホスト上にある場合は、[プラットフォームの制限](#limitations)で利用可能な機能を確認してください。

以下のいずれかのサーフェスからクラウドセッションを開始できます：

* **ブラウザ**：[claude.ai/code](https://claude.ai/code)（ウェブ上の Claude Code とも呼ばれます）
* **モバイル**：[Claude アプリ](https://code.claude.com/docs/ja/mobile.md)の**Code** タブ
* **デスクトップアプリ**：[セッションを開始](https://code.claude.com/docs/ja/desktop.md#run-long-running-tasks-in-the-cloud)するときに、環境セレクターの**Cloud** の下にある環境を選択
* **ターミナル**：[`claude --cloud`](#from-terminal-to-cloud)
* **クラウドスケジュールタスク**：[スケジュール実行とトリガー実行](https://code.claude.com/docs/ja/routines.md)は各々クラウドセッションとして実行されます

セットアップが完了したら、このページを参考に、ターミナルとクラウド間での作業の移動、セッションの管理と共有、プルリクエストの自動修正の有効化、およびトラブルシューティングを行ってください。

> [!NOTE]
>
> 以下のケースは他のページで説明しています：
>
> * **最初のクラウドセッションの開始**：[クラウドセッションを始める](https://code.claude.com/docs/ja/web-quickstart.md)では、GitHub を接続し、ブラウザでタスクを実行する手順を説明しています
> * **1 つの作業本体に対する多数のクラウドセッション**：[プロジェクト](https://code.claude.com/docs/ja/claude-projects.md)を使用すると、Claude がセッションを開始して追跡します
> * **別のデバイスからのローカルセッションの操作**：ターミナル、IDE、または**Local** が選択されたデスクトップアプリのセッションはマシン上で実行され、[Remote Control](https://code.claude.com/docs/ja/remote-control.md) を使用すると携帯電話やブラウザからそれらにアクセスできます

## クラウド環境

すべてのクラウドセッションは[クラウド環境](https://code.claude.com/docs/ja/cloud-environments.md)で実行されます。これはネットワークアクセス、環境変数、セットアップスクリプトを制御する保存された設定です。

* **最初の環境**: 環境がまだない場合、オンボーディングは[**Trusted** ネットワークアクセス](https://code.claude.com/docs/ja/cloud-environments.md#access-levels)を持つ **Default** 環境をセットアップします。自動的に作成されるか、作成するよう求められるかのいずれかです。プランごとにどちらになるかについては、[Default 環境](https://code.claude.com/docs/ja/cloud-environments.md#the-default-environment)を参照してください
* **セッションが使用する環境**: 複数の環境がある場合にセッションが環境を選択する方法については、[Default 環境](https://code.claude.com/docs/ja/cloud-environments.md#the-default-environment)を参照してください
* **セッションがアクセスできる対象や起動時に実行する内容を変更する**: [クラウド環境を設定する](https://code.claude.com/docs/ja/cloud-environments.md)を参照してください
* **設定なしでインストールされているもの**: [インストール済みツール](https://code.claude.com/docs/ja/cloud-environments.md#installed-tools)を参照してください

## GitHub 認証オプション

クラウドセッションはコードをクローンしてブランチをプッシュするために GitHub リポジトリへのアクセスが必要です。2 つの方法でアクセスを許可できます：

| 方法 | 接続方法 | セッションが到達できるリポジトリ | 最適な用途 |
| :- | :- | :- | :- |
| **GitHub App** | [ウェブオンボーディング](https://code.claude.com/docs/ja/web-quickstart.md)中に Claude GitHub App を認可します | 任意のパブリックリポジトリ、および Claude GitHub App がインストールされているプライベートリポジトリ | ブラウザオンボーディング；[Auto-fix](#auto-fix-pull-requests) を希望するチーム |
| **`/web-setup`** | ターミナルで `/web-setup` を実行して、ローカル `gh` CLI トークンを Claude アカウントに送信します | `gh` トークンがアクセスできる任意のリポジトリ（App がインストールされているかどうかに関わらず） | すでに `gh` を使用している個別開発者 |

以下の機能は、リポジトリに Claude GitHub App がインストールされていることが前提となります：

* **Auto-fix**：Claude GitHub App をリポジトリにインストールすると、そのリポジトリのプルリクエストに対して [Auto-fix](#auto-fix-pull-requests) も有効になります
* **Projects**：[プロジェクト](https://code.claude.com/docs/ja/claude-projects.md)内のスレッドは、接続方法に関わらず、クローンする各リポジトリに Claude GitHub App がインストールされている必要があります。[GitHub アクセスの設定](https://code.claude.com/docs/ja/claude-projects.md#set-up-github-access)を参照してください

Anthropic ホスト環境では、GitHub 認証情報は Anthropic のサーバー上で暗号化されたままであり、セッションの VM に入ることはありません。VM からの GitHub 操作は [GitHub プロキシ](https://code.claude.com/docs/ja/cloud-environments.md#github-proxy)を通じて行われ、サーバー側で認証情報を添付します。

`/web-setup` のウォークスルー（`/web-setup` が保存する内容と削除方法を含む）については、[ターミナルから接続](https://code.claude.com/docs/ja/web-quickstart.md#connect-from-your-terminal)を参照してください。

> [!NOTE]
>
> [Zero Data Retention](https://code.claude.com/docs/ja/zero-data-retention.md) が有効な組織、または [HIPAA 設定](https://code.claude.com/docs/ja/hipaa-setup.md)が適用されている組織は、`/web-setup` またはその他のクラウドセッション機能を使用できません。[顧客管理の暗号化キー](https://platform.claude.com/docs/en/manage-claude/cmek)（CMEK）を使用している組織も、クラウドセッションを開始できません。

### Team および Enterprise 向けの Quick setup

Quick setup は、メンバーの GitHub と環境のセットアップの手順を省く組織設定です。Team および Enterprise プランではデフォルトでオフになっています。

オンにすると、メンバーにとって次の点が変わります：

* **`/web-setup`**：メンバーは `/web-setup` で GitHub を接続できます。この設定がオフの間、このコマンドは非表示になります
* **GitHub App のプロンプト**：ブラウザオンボーディングで Claude GitHub App のインストールプロンプトがスキップされます
* **最初の環境**：ブラウザオンボーディングでは、環境フォームを表示する代わりに、メンバー向けに [**Default** 環境](https://code.claude.com/docs/ja/cloud-environments.md#the-default-environment)が作成されます

[Owner](https://code.claude.com/docs/ja/server-managed-settings.md#access-control) は [**Organization settings > Claude Code**](https://claude.ai/admin-settings/claude-code) の **Quick setup** トグルでオンにします。

## ターミナルとクラウドの間でタスクを移動する

これらのワークフローには、同じ claude.ai アカウントでサインインした [Claude Code CLI](https://code.claude.com/docs/ja/quickstart.md) が必要です。ターミナルから新しいクラウドセッションを開始したり、クラウドセッションをターミナルに取り込んでローカルで作業を続けたりできます。クラウドセッションはノートパソコンを閉じても維持され、Claude モバイルアプリを含むどこからでも監視できます。

> [!NOTE]
>
> CLI からのセッションの引き渡しは一方向です。`--teleport` でクラウドセッションをターミナルに取り込むことはできますが、既存のターミナルセッションをクラウドに送ることはできません。タスクの説明を付けた `--cloud` フラグは、現在のリポジトリ用に新しいクラウドセッションを作成します。一方、`-p` とセッション ID または claude.ai/code の URL を付けた場合は、[その既存のセッションにメッセージをキューに追加](https://code.claude.com/docs/ja/claude-code-on-the-web.md#send-follow-ups-from-the-cli)します。[Desktop アプリ](https://code.claude.com/docs/ja/desktop.md#continue-in-another-surface)では、Code タブのローカルセッションを **Open in** メニューからクラウドに送ることができます。

### ターミナルからクラウドセッションを開始する

`--cloud` フラグを使用して、コマンドラインからクラウドセッションを開始します。

```bash theme={null}
claude --cloud "Fix the authentication bug in src/auth/login.ts"
```

これにより、claude.ai 上に新しいクラウドセッションが作成されます。クラウド VM は、ローカルのチェックアウトではなく、現在のディレクトリの GitHub リモートを現在のブランチでクローンします。そのため、ローカルのコミットがある場合は先にプッシュしてください。Claude Code がクローンの代わりにローカルリポジトリをアップロードするケースについては、[GitHub を使わずにローカルリポジトリを送信する](#send-local-repositories-without-github)を参照してください。ターミナルに `Branch <name> is not on GitHub` と表示された場合は、[Branch is not on GitHub](#branch-is-not-on-github) を参照してください。

`--cloud` は一度に 1 つのリポジトリで動作します。タスクはクラウドで実行され、その間もローカルで作業を続けられます。以前の `--remote` という表記も、`--cloud` の非推奨のエイリアスとして引き続き使用できます。

クラウドコンテナの起動中、CLI にはリポジトリのクローンや[セットアップスクリプト](https://code.claude.com/docs/ja/cloud-environments.md#setup-scripts)の実行など、セットアップ手順のライブチェックリストが表示されます。プロビジョニング中に入力したメッセージはキューに追加され、セッションの準備ができると送信されます。

> [!NOTE]
>
> `--cloud` はクラウドセッションを作成します。`--remote-control` はこれとは無関係で、claude.ai または Claude アプリからローカルの CLI セッションを監視・操作できるようにするものです。[Remote Control](https://code.claude.com/docs/ja/remote-control.md) を参照してください。

claude.ai または Claude モバイルアプリでセッションを開くと、進行状況を確認したり、直接操作したりできます。そこから、他の会話と同じように Claude を誘導したり、フィードバックを送ったり、質問に答えたりできます。

Claude が質問をしてセッションがアイドル状態になっても、[環境の有効期限](#environment-expired)までであれば戻ってきたときに回答でき、セッションはその回答から続行されます。

#### クラウドタスクのヒント

**ローカルで計画し、クラウドで実行する**: 複雑なタスクでは、Claude を plan モードで起動してアプローチを一緒に検討し、その後作業をクラウドに送ります。

```bash theme={null}
claude --permission-mode plan
```

plan モードでは、Claude はファイルを読み、調査のためにコマンドを実行し、ソースコードを編集せずに計画を提案します。納得できたら、クラウド VM がクローンできるように、計画をリポジトリに保存してコミットし、プッシュします。その後、自律的に実行するためのクラウドセッションを開始します。

```bash theme={null}
claude --cloud "Execute the migration plan in docs/migration-plan.md"
```

**タスクを並列で実行する**: 各 `--cloud` コマンドは、独立して実行される専用のクラウドセッションを作成します。複数のタスクを開始すると、それぞれ別のセッションで同時に実行されます。

```bash theme={null}
claude --cloud "Fix the flaky test in auth.spec.ts"
claude --cloud "Update the API documentation"
claude --cloud "Refactor the logger to use structured output"
```

セッションが完了したら、claude.ai/code から PR を作成するか、セッションをターミナルに [teleport](#from-cloud-to-terminal) して作業を続けられます。

#### GitHub を使わずにローカルリポジトリを送信する

Git リモートのないリポジトリ、または Claude GitHub App がインストールされていない github.com のリポジトリから `claude --cloud` を実行すると、Claude Code はローカルリポジトリをバンドルし、クラウドセッションに直接アップロードします。これは `/web-setup` で GitHub を接続している場合でも適用されます。

フルクローンの場合、バンドルにはすべてのブランチにわたるリポジトリの履歴と、追跡対象ファイルへのコミットされていない変更が含まれます。

機密ファイルへのコミットされていない変更の扱いは、プラットフォームによって異なります。

* **macOS、Linux、WSL**: Claude Code は、認証情報やキーのような名前のファイルへのコミットされていない変更をアップロードから除外します。これには `.env` ファイル、Terraform の `*.tfvars` ファイル、`id_rsa` や `*.pem` などのキーファイルが含まれます。また、Git LFS などの Git フィルターが管理するファイルへのコミットされていない変更も除外します。除外されたファイルは `Left on this machine:` という通知で示され、セッションは各ファイルのコミット済みのバージョンで開始されます。コミット済みのバージョンがない場合は、そのファイルなしで開始されます。
* **ネイティブ Windows**: 追跡対象ファイルへのコミットされていない変更は、ファイル名にかかわらずそのままアップロードされます。クラウドセッションに含めたくない編集は、セッションを開始する前に stash するか元に戻してください。

Claude Code が通常はリモートからクローンする場合でもバンドルをアップロードするには、`CCR_FORCE_BUNDLE=1` を設定します。

```bash theme={null}
CCR_FORCE_BUNDLE=1 claude --cloud "Run the test suite and fix any failures"
```

バンドルされるリポジトリは、以下の制限を満たす必要があります。

* ディレクトリは、少なくとも 1 つのコミットがある Git リポジトリである必要があります
* バンドルされるリポジトリは 100 MB 未満である必要があります。これより大きいリポジトリは、現在のブランチのみのバンドルにフォールバックし、次に作業ツリーの単一のスカッシュされたスナップショットにフォールバックします。スナップショットがそれでも大きすぎる場合は失敗します
* 追跡されていないファイルは含まれません。クラウドセッションで参照させたいファイルには `git add` を実行してください
* macOS、Linux、WSL では、インクルードされた設定ファイルで設定された `core.attributesFile` など、ファイルに適用される属性ルールに影響する Git の設定を追跡できない場合、Claude Code はアップロードを拒否します。[拒否メッセージ](https://code.claude.com/docs/ja/errors.md#the-repository-upload-cant-follow-a-git-setting)には、その設定と修正方法が示されます
* バンドルから作成されたセッションが GitHub リモートにプッシュできるのは、[GitHub 接続](#github-authentication-options)がそのリポジトリへのプッシュ権限を持っている場合のみです

macOS、Linux、WSL では、アップロードには Git 2.31 以降と、サポートされているチェックアウト構成も必要です。一方、ネイティブ Windows では、Claude Code はどちらのチェックも行わずにアップロードします。チェックアウトがこれらの要件を満たさない場合、Claude Code はセッションを開始しません。`Not uploading this working tree:` を含むエラーを表示し、原因と変更すべき点を示します。一般的な原因は次のとおりです。

* **古い Git**: インストールされている Git が 2.31 より古い。Git を更新してから再試行してください。
* **アップロードがサポートしていないチェックアウト構成**: サブモジュール内、`git clone --separate-git-dir`、`--shared`、`--reference` で作成したクローン内、`core.worktree` が設定されたチェックアウト内、または ref を reftable 形式で保持するリポジトリ内から開始した。代わりに、通常の `git clone` で作成したクローンのメインのチェックアウトから開始してください。
* **スパースチェックアウトを使用するリンクされた worktree**: `git sparse-checkout` は worktree 固有の `config.worktree` ファイルに設定を書き込みますが、アップロードはこれを受け付けません。そのため、これらの設定を持つ worktree はアップロードされず、Claude Code が [`worktree.sparsePaths`](https://code.claude.com/docs/ja/settings-reference#worktree-sparsepaths) で作成した worktree もアップロードされません。代わりに、リポジトリのメインのチェックアウトから開始してください。
* **作業ツリー内に保持された Git 設定**: Git 設定が、チェックアウト内にあるファイルをインクルードしている（例: リポジトリ内を指す `include.path` エントリ）。そのファイルを作業ツリーの外に移動するか、インクルードを削除してから再試行してください。

macOS、Linux、WSL では、`git clone --filter` で作成した部分クローンは、クローンがすべての追跡対象ファイルをローカルに保持している限り、履歴なしの作業ツリーのスナップショットとしてアップロードされます。

`claude --cloud` の場合、リポジトリが GitHub 上にあれば、アップロードとその要件を回避できます。ブランチをプッシュし、リポジトリに Claude GitHub App をインストールしてから、GitHub からクローンされるようにセッションを再度開始してください。

### CLI からフォローアップを送信する

クラウドセッションが実行中であれば、実行場所にかかわらず、`claude auth login` でログインしている任意のマシン上の `claude` CLI からフォローアップメッセージを送信できます。CLI は Anthropic アカウントの認証情報で認証し、ローカルのセッション状態は送信しないため、セッションを開始したマシンからコマンドを実行する必要はありません。

このコマンドは 1 つのメッセージを投稿して終了します。

```bash theme={null}
claude -p "your message" --cloud <session-id>
```

CLI はメッセージをセッションのキューに追加し、返信を待たずに終了します。長時間実行されるセッションを誘導したり、現在のステップがまだ完了処理の途中である間に次のステップをキューに追加したり、[CI スクリプト](https://code.claude.com/docs/ja/self-hosted-environments-testing.md#run-the-test-loop)からフォローアップを送信したりするのに使用できます。メッセージを引数として渡す代わりに、標準入力からパイプで渡すこともできます: `echo "your message" | claude -p --cloud <session-id>`。

`<session-id>` には、`session_...` や `cse_...` などの ID そのもの、またはセッションの `claude.ai/code/<id>` URL（スキームやクエリ文字列の有無は問いません）を渡します。ID は claude.ai/code のセッション一覧で確認できます。

> [!NOTE]
>
> `--cloud` には Anthropic アカウントが必要です。Claude Code が Amazon Bedrock、Google Cloud の Agent Platform、またはその他のサードパーティプロバイダー向けに設定されている場合は利用できません。`ANTHROPIC_BASE_URL` のみで設定された [LLM ゲートウェイ](https://code.claude.com/docs/ja/llm-gateway)は、このチェックではサードパーティプロバイダーとして扱われませんが、`claude auth login` でサインインする必要はあります。また、組織の `allow_remote_sessions` ポリシーが有効になっている必要があります。Owner は claude.ai/admin-settings/claude-code の Claude Code 管理設定でこれをオンにできます。

#### 出力

成功すると、コマンドはセッション ID とセッションを表示するためのリンクを出力します。

```
Sent to cloud session.
Session ID: session_01DiUkqY2kzbUbDmW1w96rfi
View: https://claude.ai/code/session_01DiUkqY2kzbUbDmW1w96rfi?from=cli&m=0
```

機械可読な結果を得るには `--output-format json` を渡します。成功時は `{ok, session_id, url}`、送信に失敗した場合（セッションが存在しない、またはアーカイブされている場合など）は `{ok: false, session_id, error}` が返されます。サポートされていないプロバイダーや無効化された組織ポリシーなどの設定エラーは、JSON なしで stderr に出力されます。`--output-format stream-json` は `--cloud <session-id>` ではサポートされていません。

送信に失敗した場合は、[クラウドセッションへの送信時のエラー](#errors-when-sending-to-a-cloud-session)を参照してください。

### クラウドセッションをターミナルで続行する

次のいずれかの方法で、クラウドセッションをターミナルに取り込みます。

* **`--teleport` を使用する**: コマンドラインから `claude --teleport` を実行すると対話型のセッション選択画面が開き、`claude --teleport <session-id>` を実行すると特定のセッションを直接再開できます。コミットされていない変更がある場合は、先に stash するよう求められます。[`--resume`](https://code.claude.com/docs/ja/sessions#resume-a-session) はこのマシンのローカル履歴から会話を再開するもので、クラウドセッションは一覧に表示されません。
* **`/teleport` を使用する**: 既存の CLI セッション内で `/teleport` または `/tp` を実行すると、Claude Code を再起動せずに同じセッション選択画面を開けます。
* **`/tasks` から**: `/tasks` を実行してバックグラウンドセッションを表示し、`t` を押してセッションに teleport します。
* **claude.ai/code から**: セッションメニューから **Open in > Terminal** を選択すると、ターミナルに貼り付けられるコマンドがコピーされます。
* **クラウドセッション内から**: `/teleport` と入力すると、Claude Code がそのセッション用の正確な `claude --teleport <session-id>` コマンドを返します。このコマンドはリポジトリのチェックアウトからすぐに実行できます。セッションの環境に Claude Code v2.1.223 以降が必要です。

セッションを teleport すると、Claude は正しいリポジトリにいることを確認し、クラウドセッションのブランチをフェッチしてチェックアウトし、会話をターミナルに読み込みます。

> [!NOTE]
>
> Claude Code がクラウドセッションを[コンパクト化](https://code.claude.com/docs/ja/context-window.md#what-survives-compaction)している場合（長いセッションでは自動的に行われます）、要約された以前のメッセージはターミナルにコピーされません。Claude は要約から続行します。元のメッセージを読むには、claude.ai または Claude モバイルアプリのクラウドセッションで上にスクロールしてください。

ターミナルはセッションの独自のコピーを取得します。そこで行った新しい作業はローカルにとどまり、claude.ai や Claude モバイルアプリのクラウドセッションには表示されません。teleport 後もスマートフォンから操作を続けるには、ローカルセッションで [`/remote-control`](https://code.claude.com/docs/ja/remote-control) を開始してください。

#### Teleport の要件

Teleport は、セッションを再開する前に以下の要件を確認します。いずれかの要件が満たされていない場合は、エラーが表示されるか、問題の解決を求められます。

| 要件 | 詳細 |
| - | - |
| クリーンな Git の状態 | 作業ディレクトリにコミットされていない変更があってはなりません。必要に応じて、Teleport が変更を stash するよう求めます。 |
| 正しいリポジトリ | `--teleport` は、フォークではなく同じリポジトリのチェックアウトから実行する必要があります。別のリポジトリのチェックアウトから実行すると、Claude Code はセッションのリポジトリとチェックアウトのリポジトリの両方を示すエラーを表示します。`git@work:owner/repo.git` のような SSH ホストエイリアスなど、Claude Code がリモートをホスト名に解析できない場合は確認を求め、リモートのオーナーとリポジトリ名がセッションのリポジトリと一致すればそのチェックアウトを受け入れます。 |
| ブランチが利用可能 | クラウドセッションのブランチがリモートにプッシュされている必要があります。Teleport は自動的にそれをフェッチしてチェックアウトします。 |
| 同じアカウント | クラウドセッションで使用したものと同じ claude.ai アカウントで認証されている必要があります。 |

Teleport がセッションのブランチをフェッチする際、フェッチがターミナルでの入力を待つことはありません。Git や ssh がパスワード、キーのパスフレーズ、または新しい SSH ホストの確認を求める場合、フェッチは失敗し、ローカルのクローンにすでにそのブランチがある場合にのみチェックアウトが機能します。SSH の 2 つのケースについては、キーを `ssh-agent` に読み込み、先に一度手動で `git fetch` を実行してホストを記録してください。

#### `--teleport` is unavailable

Teleport には claude.ai のサブスクリプション認証が必要です。該当するケースを確認してください。

* **API キーまたは Console アカウントでサインインしている**: シェルで `claude auth login` を実行し、claude.ai でサインインしてください
* **エラーにプロバイダー名が表示される**: クラウドセッションはサードパーティプロバイダー経由では利用できません。[エラー表](#errors-when-sending-to-a-cloud-session)を参照してください
* **すでに claude.ai でサインインしている**: 組織がクラウドセッションを無効にしている可能性があります

## セッションの操作

セッションは claude.ai/code のサイドバーに表示されます。そこから変更を確認し、チームメイトと共有し、完了した作業をアーカイブするか、セッションを永続的に削除できます。

### クラウドセッションの権限モード

クラウドセッションの[権限モード](https://code.claude.com/docs/ja/permission-modes.md)は[モードドロップダウン](https://code.claude.com/docs/ja/permission-modes.md#switch-permission-modes)から選択します。タスクを作成するときとセッションが実行されている間の両方で選択できます。

次のいずれかを行うと、Claude Code はセッションが直前にあった権限モードでセッションを再開します：

* Anthropic ホスト型の[環境が有効期限切れ](#environment-expired)になったセッションを再度開く
* セルフホスト型ランナーが[アイドル中にリリース](https://code.claude.com/docs/ja/self-hosted-environments-reference.md#runner-cli-flags)したセッションにメッセージを送信する

### 変更を確認

Claude がブランチに変更をプッシュすると、チャットの横のパネルにある **Changes** カードに、`+42 -18` のように追加および削除された行数が表示されます。**Changes** カードの行数をクリックすると差分ビューが開きます。

* セッションのタイトルバー、またはバーの **⋮** メニューにある **Changes** をクリックすることもできます。
* パネルが非表示のときに表示するには、セッションのタイトルバー、またはバーの **⋮** メニューにある **Show session rail** アイコンをクリックします。

差分ビューでは、行にコメントしたり、別のブランチと比較したりできます：

* **Comment**：特定の行にインラインコメントを残し、次のメッセージでそのコメントを Claude に送信します
* **Compare**：差分ビューは、デフォルトでセッションの変更をそのベースブランチと比較します。リポジトリ内の他の任意のブランチと比較するには、**Compare against** を選択してブランチを 1 つ選びます

Claude Code はこれらの差分を raw git blob コンテンツから計算するため、リポジトリで設定された diff ドライバーと `textconv` フィルターは適用されません。

以下の手順は別の場所で説明しています：

* **PR 作成を含む完全なウォークスルー**：[Review and iterate](https://code.claude.com/docs/ja/web-quickstart.md#review-and-iterate) を参照してください
* **Claude に PR の CI 失敗とレビューコメントを自動的に監視させる**：[プルリクエストの自動修正](#auto-fix-pull-requests)を参照してください

#### 差分ビューで見つからないファイルのトラブルシューティング

差分ビューがベースブランチと比較する際、セッションが変更をプッシュしたかどうかにかかわらず、期待したファイルが差分ビューのファイルリストに表示されないことがあります：

* **まだ変更がプッシュされていない場合**：リストには Claude 自身の編集が含まれますが、Claude が実行したコマンド（フォーマッターなど）による変更は含まれません
* **変更がプッシュされている場合**：リストにはプッシュされたコミットが含まれますが、最後のプッシュ以降に行われた変更は含まれません

不足している変更をリストに追加するには、Claude にコミットとプッシュを依頼します。

### コンテキストを管理

クラウドセッションは[組み込みコマンド](https://code.claude.com/docs/ja/commands.md)をサポートしており、テキスト出力を生成します。ターミナルインターフェイスでのみ実行されるコマンド（`/plugin` や `/resume` など）は利用できません。ターミナルでピッカーまたはパネルを開くコマンドはクラウドセッションで異なる動作をします：

* **`/model`、`/effort`、`/color`、`/rename`**：ターミナルピッカーまたはスライダーを開く代わりに、引数として値を渡します。例えば `/model sonnet` のように使用します。引数形式は各コマンドの[利用可能性に関する注記](https://code.claude.com/docs/ja/commands.md#all-commands)に従います。
* **`/fast`**：アカウントで[利用可能な場合](https://code.claude.com/docs/ja/fast-mode.md#requirements)、セッションの[ファストモード](https://code.claude.com/docs/ja/fast-mode.md#use-fast-mode-in-cloud-sessions)を切り替えます。セッションの環境で Claude Code v2.1.271 以降が必要です。
* **`/config`**：ブラウザの claude.ai/code では、値を設定する代わりに **Settings > Code** または **Settings > Claude Code** を開きます。クラウドセッションの設定を変更するには、環境に[環境変数](https://code.claude.com/docs/ja/cloud-environments.md#set-environment-variables)を設定します。[プロジェクト](https://code.claude.com/docs/ja/claude-projects.md)のスレッド以外で 1 つのリポジトリを持つセッションでは、代わりにキーをそのリポジトリの `.claude/settings.json` にコミットします。[クラウドセッションの設定](https://code.claude.com/docs/ja/settings.md#settings-in-cloud-sessions)には各セッションが読み込むものが記載されています。

[プロジェクトのスレッド](https://code.claude.com/docs/ja/claude-projects.md#choose-models-and-let-claude-manage-context)以外のクラウドセッションでのコンテキスト管理の場合：

| コマンド | クラウドセッションで機能 | 注記 |
| :- | :- | :- |
| `/compact` | はい | 会話を要約してコンテキストを解放します。`/compact keep the test output` のようなオプションのフォーカス指示を受け入れます |
| `/context` | はい | 現在コンテキストウィンドウにあるものを表示します |
| `/clear` | はい | 同じクラウドセッション内で、空のコンテキストで新しい会話を開始します |

自動圧縮はコンテキストウィンドウが容量に近づくと自動的に実行されます。クラウドセッションは [`CLAUDE_AUTOCOMPACT_PCT_OVERRIDE`](https://code.claude.com/docs/ja/env-vars) をセッション自身で設定するため、圧縮はウィンドウが満杯になるのではなく、[自動圧縮ウィンドウ](https://code.claude.com/docs/ja/model-config.md#set-the-auto-compact-window)の途中でトリガーされます。その値は[環境変数](https://code.claude.com/docs/ja/cloud-environments.md#set-environment-variables)に追加するものをオーバーライドするため、そこに変数を追加しても圧縮がトリガーされるタイミングは変わりません。

自動圧縮ウィンドウを変更するには、環境変数で [`CLAUDE_CODE_AUTO_COMPACT_WINDOW`](https://code.claude.com/docs/ja/env-vars) を設定するか、変数が設定されていないセッションで [`/autocompact`](https://code.claude.com/docs/ja/commands#all-commands) をトークン数で実行します。

[サブエージェント](https://code.claude.com/docs/ja/sub-agents.md)はローカルと同じように機能します。Claude は Agent ツールでサブエージェントをスポーンして、調査や並列作業を別のコンテキストウィンドウにオフロードし、メインの会話を軽く保つことができます。[プロジェクト](https://code.claude.com/docs/ja/claude-projects.md#what-threads-pick-up-from-your-repositories)のスレッド以外では、リポジトリの `.claude/agents/` で定義されたサブエージェントが自動的に読み込まれます。

[Agent teams](https://code.claude.com/docs/ja/agent-teams.md)はデフォルトでオフですが、[環境変数](https://code.claude.com/docs/ja/cloud-environments.md#set-environment-variables)に `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1` を追加することで有効にできます。

### 会話内のプラグインの提案

会話内に 1 つ以上の[プラグイン](https://code.claude.com/docs/ja/plugins/overview.md)を一覧表示し、**Add** ボタンを備えたカードが表示された場合、Claude がタスクのためにプラグインを提案していることを意味します。Claude はユーザーが求めなくてもこれらの提案を行うことがあります。応答する必要はなく、どちらの場合でも Claude はタスクを続行します。

#### 提案されたプラグインを追加または削除する

プラグインの **Add** を選択すると、claude.ai アカウントでそのプラグインがオンになり、セッション終了後もオンのままになります。元に戻すには、カードから追加したプラグインを開き、**Manage** を選択して claude.ai 上のプラグインのページに移動し、そのページからプラグインを削除します。

#### プラグインの提案をオフにする

Claude がプラグインを提案しないようにするには、[権限ルール](https://code.claude.com/docs/ja/permissions.md#manage-permissions)で `SearchPlugins` ツールと `SuggestPluginInstall` ツールを拒否します。[プロジェクト](https://code.claude.com/docs/ja/claude-projects.md)外で 1 つのリポジトリを持つセッションでは、両方のツール名を `permissions.deny` の下に列挙して、ルールをそのリポジトリの `.claude/settings.json` にコミットします：

```json theme={null}
{
  "permissions": {
    "deny": ["SearchPlugins", "SuggestPluginInstall"]
  }
}
```

Claude Code は、セッションに適用される[管理設定](https://code.claude.com/docs/ja/managed-settings.md)で [`allowManagedPermissionRulesOnly`](https://code.claude.com/docs/ja/settings-reference#allowmanagedpermissionrulesonly) が設定されている場合、これらの拒否ルールを含め、リポジトリの `.claude/settings.json` 内の権限ルールを無視します。その場合は、代わりにそれらの管理設定にルールを記述します。複数のリポジトリを持つセッションやプロジェクト内のクラウドスレッドなど、その他の構成については、どの[設定がクラウドセッションに適用されるか](https://code.claude.com/docs/ja/settings.md#settings-in-cloud-sessions)を参照してください。

### キューに入ったメッセージを取り戻す

Claude が作業中にメッセージを送信すると、Claude がそれを読むまでメッセージはキューに入ります。キューに入ったメッセージを取り戻すには、その上の ✕ をクリックします。テキストはメッセージボックスに戻るため、編集するか別のものを送信できます。

Claude がすでにメッセージを読んでいる場合、それは会話に留まります。

### セッションを共有

セッションを共有するには、以下のアカウントタイプに従ってその可視性を切り替えます。その後、セッションリンクをそのまま共有します。受信者はリンクを開くと最新の状態を表示しますが、ビューはリアルタイムで更新されません。

#### Enterprise または Team アカウントから共有

Enterprise および Team アカウントでは、共有は次のように機能します：

* **可視性オプション**：**Private** と **Team**。Team 可視性により、セッションは claude.ai 組織の他のメンバーに表示されます
* **リポジトリアクセス**：検証はデフォルトで有効になっており、受信者のアカウントに接続された GitHub アカウントに基づいて行われます
* **ユーザーの名前**：アカウントの表示名はアクセス権を持つすべての受信者に表示されます
* **Slack セッション**：[Claude in Slack](https://code.claude.com/docs/ja/slack.md) セッションは自動的に Team 可視性で共有されます

#### Max、Ultra、または Pro アカウントから共有

* **可視性オプション**：**Private** と **Public**。Public 可視性により、セッションは claude.ai にログインしているすべてのユーザーに表示されます
* **リポジトリアクセス**：検証はデフォルトで有効になっていません
* **機密コンテンツ**：共有する前にセッションを確認してください。セッションにはプライベート GitHub リポジトリのコードと認証情報が含まれる可能性があります

受信者がリポジトリアクセスを持つことを要求するか、共有セッションから名前を非表示にするには、claude.ai で Settings を開き、次の操作を行います：

* **Settings メニューに Claude Code ではなく Code が表示される場合**：これらの設定がある [**Privacy**](https://claude.ai/settings/data-privacy-controls) に移動します
* **それ以外の場合**：[**Claude Code > Sharing settings**](https://claude.ai/settings/claude-code) に移動します

### セッションをアーカイブ

セッションをアーカイブすると、サイドバーのセッションリストから削除されます。セッションをアーカイブするには、サイドバーでセッションにマウスを合わせ、**⋯** メニューを開いて **Archive** を選択します。

#### アーカイブされたセッションを見つける

アーカイブされたセッションを表示するには、[claude.ai/code/sessions](https://claude.ai/code/sessions) に移動して **Archived** タブを開きます。セッションをサイドバーのセッションリストに戻すには、そのタブでセッションにマウスを合わせ、**⋮** メニューを開いて **Unarchive** を選択します。

### セッションを削除

セッションを削除すると、セッションとそのデータが永続的に削除されます。このアクションは取り消せません。セッションは、サイドバー、セッションメニュー、またはすでにアーカイブしている場合は **Archived** タブから削除できます：

* **サイドバーから**：セッションにマウスを合わせ、**⋯** メニューを開いて **Delete** を選択します
* **セッションメニューから**：セッションを開き、セッションタイトルの横のドロップダウンを選択し、**Delete** を選択します
* **Archived タブから**：[**Archived** タブ](#find-an-archived-session)でセッションにマウスを合わせ、**⋮** メニューを開いて **Delete** を選択します

セッションが削除される前に確認するよう求められます。

## プルリクエストの自動修正

Claude はプルリクエストを監視し、CI 失敗とレビューコメントに自動的に応答できます。Claude は PR の GitHub アクティビティをサブスクライブし、チェックが失敗するかレビュアーがコメントを残すと、Claude は調査し、明確な場合は修正をプッシュします。

> [!NOTE]
>
> Auto-fix には Claude GitHub App がリポジトリにインストールされている必要があります。まだインストールしていない場合は、[GitHub App ページ](https://github.com/apps/claude)からインストールしてください。

PR がどこから来たか、どのデバイスを使用しているかに応じて、auto-fix をオンにするにはいくつかの方法があります：

* **クラウドセッションで作成された PR**：claude.ai/code でセッションを開き、[**Changes** カード](#review-changes)でプルリクエストを見つけます。プルリクエストのタイトルの横にある **⋮** メニューを開き、**Auto-fix** をオンにします
* **ターミナルから**：PR のブランチにいる間に [`/autofix-pr`](https://code.claude.com/docs/ja/commands) を実行します。Claude Code は `gh` で開いている PR を検出し、クラウドセッションをスポーンし、1 ステップで auto-fix をオンにします
* **モバイルアプリから**：Claude に PR を auto-fix するよう指示します。例えば「watch this PR and fix any CI failures or review comments」
* **既存の PR**：PR URL をセッションに貼り付けて、Claude に auto-fix するよう指示します

監視を停止するには、セッションの [**Changes** カード](#review-changes)にあるプルリクエストの **⋮** メニューで **Auto-fix** をオフにするか、Claude に PR の監視を停止するよう指示します。

### Claude が PR アクティビティにどのように応答するか

auto-fix がアクティブな場合、Claude は新しいレビューコメントと CI チェック失敗を含む PR の GitHub イベントを受け取ります。各イベントについて、Claude は調査して進め方を決定します：

* **明確な修正**：Claude が修正に確信があり、以前の指示と矛盾しない場合、Claude は変更を加え、プッシュし、セッションで何が行われたかを説明します
* **曖昧なリクエスト**：レビュアーのコメントが複数の方法で解釈される可能性がある場合、または建築的に重要なものが含まれている場合、Claude は行動する前にあなたに尋ねます
* **重複または無アクション イベント**：イベントが重複している場合、または変更が不要な場合、Claude はセッションでそれを記録して続行します

ベースブランチが進み、マージコンフリクトが作成されるときに GitHub は webhook を発行しないため、auto-fix は単独でコンフリクトに反応することはできません。コンフリクトを解決するには、セッションを開き、Claude にリベースするよう依頼してください。

Claude は PR を解決する際に GitHub のレビューコメントスレッドに返信する場合があります。これらの返信はあなたの GitHub アカウントを使用して投稿されるため、あなたのユーザー名の下に表示されますが、各返信は Claude Code から来たものとしてラベル付けされるため、レビュアーはそれがエージェントによって書かれたものであり、あなたが直接書いたものではないことを知っています。

> [!WARNING]
>
> リポジトリが Atlantis、Terraform Cloud、または `issue_comment` イベントで実行されるカスタム GitHub Actions などのコメントトリガー自動化を使用する場合、Claude の返信がそれらのワークフローをトリガーする可能性があることに注意してください。auto-fix を有効にする前にリポジトリの自動化を確認し、PR コメントがインフラストラクチャをデプロイするか特権操作を実行できるリポジトリでは auto-fix を無効にすることを検討してください。

## セキュリティと分離

各クラウドセッションはいくつかのレイヤーを通じてマシンおよび他のセッションから分離されます：

* **分離された仮想マシン**：各セッションは分離された Anthropic 管理 VM で実行されます。セッションが組織によってルーティングされる[セルフホスト環境](https://code.claude.com/docs/ja/self-hosted-environments)は、代わりに独自のインフラストラクチャで実行され、分離はデプロイメントの責任です
* **ネットワークアクセス制御**：Anthropic ホスト型環境では、ネットワークアクセスはデフォルトで制限され、無効にできます。[ネットワークアクセス](https://code.claude.com/docs/ja/cloud-environments.md#network-access)でアクセスレベル、[デフォルト許可ドメイン](https://code.claude.com/docs/ja/cloud-environments.md#default-allowed-domains)、および許可リストを通過しないトラフィックを参照してください。セルフホスト型環境では、独自のネットワーク境界でセッション出力を制限します。ネットワークアクセスを無効にして実行する場合、Claude Code は Anthropic API と通信できます。これにより VM からデータが出ることを許可する可能性があります。
* **認証情報保護**：Anthropic ホスト型環境では、git 認証情報と署名キーはサンドボックスの外に留まり、プロキシはスコープ付き認証情報で認証します。セルフホスト型環境では、デプロイメントが git 認証情報を提供します；[git を設定](https://code.claude.com/docs/ja/self-hosted-environments-deploy.md#configure-git)を参照してください
* **ネットワークシークレット**：Anthropic ホスト型環境では、[クラウド環境に追加](https://code.claude.com/docs/ja/cloud-environments.md#add-network-secrets)したキーも同様にサンドボックスの外に留まり、セッションを離れた後に一致するリクエストに添付されます。セルフホスト型環境にはネットワークシークレットはありません
* **セキュアな分析**：コードは PR を作成する前に分離されたセッション環境内で分析および変更されます

## トラブルシューティング

`API Error: 500`、`529 Overloaded`、`429`、または `Prompt is too long` などの会話に表示される実行時 API エラーについては、[エラーリファレンス](https://code.claude.com/docs/ja/errors.md)を参照してください。これらのエラーとその修正は CLI および Desktop アプリと共有されます。以下のセクションはクラウドセッションに固有の問題をカバーしています。

### セッション作成に失敗

新しいセッションが `Session creation failed` で開始に失敗するか、プロビジョニングで停止する場合、Claude Code は VM をセッションに割り当てることができませんでした。

* [status.claude.com](https://status.claude.com) でクラウドセッションインシデントを確認してください
* 1 分後に再試行してください。容量はオンデマンドでプロビジョニングされます
* [GitHub 接続後にリポジトリが表示されない](https://code.claude.com/docs/ja/web-quickstart.md#no-repositories-appear-after-connecting-github)に従って、GitHub 接続がリポジトリに到達できることを確認してください

### Your new session couldn't start

プロンプトは、送信元の入力ボックスに戻されています。

* **Connection lost**: インターネット接続と、使用している VPN またはプロキシを確認してから、プロンプトを再度送信してください
* **Server error**: しばらく待ってから、プロンプトを再度送信してください。この通知が再び表示される場合は、[status.claude.com](https://status.claude.com) を確認してください

### Can't rewind to this message

セッションが v2.1.246 より前の Claude Code を使用する[セルフホストランナー](https://code.claude.com/docs/ja/self-hosted-environments)で実行されている場合、最新のメッセージ以外のメッセージで **Rewind to here** を実行すると、このエラーで失敗します。組織のランナーを運用している担当者に[アップグレード](https://code.claude.com/docs/ja/self-hosted-environments-deploy.md#pin-the-version)を依頼してください。

### 組織 UUID を取得できない

`claude --cloud` と `claude --teleport` には claude.ai アカウントでのサインインが必要です。代わりに API キーまたは Console のサインインで認証している場合、あるいは保存されたアカウント詳細が古い場合、次のようなメッセージが表示されます。

* `Unable to get organization UUID`
* ``Cloud sessions need a claude.ai sign-in. Run `claude auth login` (or /login in a local session), then try again.``
* ``Cloud sessions aren't available with this Console sign-in. They need a claude.ai sign-in. Run `claude auth login` (or /login in a local session), then try again.``
* セッション ID なしで `claude --teleport` を実行した場合、セッションピッカーでの `Error loading Claude Code sessions`

シェルで [`claude auth login`](https://code.claude.com/docs/ja/cli-reference#cli-commands) を実行して claude.ai アカウントでサインインし、コマンドを再試行してください。実行中のセッション内では、`/login` でも同じことができます。エラーにプロバイダー名が示されている場合は、[エラーテーブル](#errors-when-sending-to-a-cloud-session)を参照してください。クラウドセッションはサードパーティプロバイダーを通じては利用できません。

v2.1.274 から v2.1.289 までは、サインインメッセージは `Claude Code cloud sessions require authentication with a Claude.ai account. API key authentication is not sufficient. Please run /login to authenticate, or check your authentication status with /status.` でした。

### ブランチが GitHub 上にない

`claude --cloud` が `Branch <name> is not on GitHub` で始まる行を出力した場合でも、クラウドセッションは開始されますが、そのブランチからは開始されません。この行には、代わりにセッションが開始される場所が示されます。ブランチの履歴にあるプッシュ済みのコミット、またはリポジトリのデフォルトブランチのいずれかです。ローカルマシンにのみ存在するコミットや、コミットされていない変更はセッションに含まれません。

この行は、たとえばブランチを一度もプッシュしていない場合や、プルリクエストのマージ後に GitHub がブランチを削除した場合に表示されます。行に示された開始点にタスクに必要なものが含まれている場合は、そのままセッションを使用してください。そうでない場合は、ブランチをプッシュしてから新しいセッションを開始し、セッションがそのブランチをクローンするようにしてください。

### Remote Control セッションの有効期限切れまたはアクセス拒否

`--teleport` はクラウドセッションが使用する同じ Remote Control セッションインフラストラクチャを通じて接続するため、認証およびセッション有効期限エラーは Remote Control の表現で表示されます。`Remote Control session expired` または `Access denied` が表示される場合があります。接続トークンは短命で、アカウントにスコープされています。

* ローカルで `/login` を実行して認証情報をリフレッシュし、再接続してください
* セッションを所有する同じアカウントにサインインしていることを確認してください
* `Remote Control may not be available for this organization` が表示される場合、Owner がクラウドセッションを組織に対して有効にしていません

### クラウドセッションへの送信時のエラー

これらのエラーは、`-p` の有無にかかわらず、[`--cloud <session-id>`](#send-follow-ups-from-the-cli) を指定して `claude` を実行したときに発生します。CLI はエラーの先頭に `Error: ` を付けます。配信に失敗した場合は `failed to send message to cloud session <id>: <reason>` としてラップされます。

| メッセージ | 意味 |
| - | - |
| `Cloud sessions aren't available with <provider>. They run on Anthropic's infrastructure and require an Anthropic account.` | Claude Code がサードパーティプロバイダー向けに設定されています。メッセージには、`Amazon Bedrock` や `Google Vertex AI` など、設定で使用されているラベルでプロバイダー名が示されます。たとえば `CLAUDE_CODE_USE_BEDROCK` の設定を解除するなどしてそのプロバイダーの設定を削除し、Anthropic アカウントでサインインしてください（`claude auth login`）。 |
| `Cloud sessions are disabled by your organization's policy. Contact your organization admin to enable them.` | `allow_remote_sessions` 組織ポリシーがオフになっています。[Cloud sessions are disabled by your organization's policy](https://code.claude.com/docs/ja/errors.md#cloud-sessions-are-disabled-by-your-organizations-policy) を参照してください。メッセージに、このセッションが使用している認証情報の名前が示されている場合は、[クラウドセッションは claude.ai のログインを使用する](https://code.claude.com/docs/ja/errors.md#cloud-sessions-use-your-claude-ai-login)を参照してください。 |
| `Couldn't verify your organization's policy for cloud sessions. Check your network connection and try again.` | Claude Code が組織のポリシーの読み込みを完了していないため、クラウドセッションが許可されていると仮定せずに送信を拒否しています。ネットワーク接続を確認して再試行してください。 |
| `Cloud sessions aren't available:` の後に原因が続くもの | 組織のポリシーの読み込みに失敗しました。メッセージの残りの部分に失敗の内容が示されています。示された原因に対処してください。[Couldn't verify your organization's policy for cloud sessions](https://code.claude.com/docs/ja/errors.md#couldnt-verify-your-organizations-policy-for-cloud-sessions) を参照してください。 |
| `Attaching to an existing cloud session is not enabled for your account.` | `-p` なしで `--cloud <session-id>` を実行しました。`claude -p "your message" --cloud <session-id>` でメッセージを送信してください。 |
| `Session not found: <id>` | ID または URL が、アクセス可能なセッションと一致しません。セッションの claude.ai/code URL と照合してください。 |
| `cloud session <id> is archived and cannot accept new messages` | セッションはアーカイブされています。代わりに新しいセッションを開始してください。 |

### 環境の有効期限切れ

クラウドセッションは非アクティブ期間後に停止し、セッションの VM は回収されます。セッションは [MCP コネクタ](https://code.claude.com/docs/ja/cloud-environments.md#network-access)ツール呼び出しを承認するか、MCP サーバーにサインインするのを待っている間、非アクティブとしてカウントされ、その待機中に有効期限が切れる可能性があります。

[claude.ai/code](https://claude.ai/code) からセッションを再度開いて、新しい VM をプロビジョニングしてください。

* **復元されるもの**: 会話履歴
* **復元されないもの**: VM が回収されたときにまだ実行中または保留中だったバックグラウンド作業。以下が含まれます。
  * **シェルコマンド**: Claude Code は、どのコマンドが停止したかを Claude に伝えます。まだ必要なコマンドを再実行するよう Claude に依頼してください。
  * **サブエージェント**: Claude Code は、どのサブエージェントが停止したか、そしてそのうちどれを最初からやり直す代わりに[再開](https://code.claude.com/docs/ja/sub-agents.md#resume-subagents)できるかを Claude に伝えます。作業を続けるよう Claude に依頼してください。
  * **セッションスコープのスケジュールタスク**: [セッション内でスケジュールした](https://code.claude.com/docs/ja/scheduled-tasks.md)タスクや、次の反復を待っている `/loop` は、再度開いたセッションには引き継がれません。タスクを再度スケジュールするよう Claude に依頼するか、`/loop` を再度実行してループを再開してください。

## 制限事項

クラウドセッションをワークフローに組み込む前に、以下の制約を考慮してください。

* **レート制限**: クラウドセッションは、アカウント内のすべての Claude および Claude Code の使用状況とレート制限を共有します。複数のタスクを並行実行すると、レート制限がそれに応じてより多く消費されます。
* **時間制限**: Claude が実行するコマンドと SessionStart フックにはデフォルトのタイムアウトがあり、変更できます。セットアップスクリプトはおよそ 5 分以内に完了した場合のみキャッシュされます。[時間制限](https://code.claude.com/docs/ja/cloud-environments.md#time-limits) を参照してください。
* **リポジトリ認証**: クラウドセッションをターミナルに取り込むことができるのは、同じアカウントで認証されている場合のみです。
* **プラットフォーム制限**: Anthropic ホスト環境でのリポジトリのクローンとプルリクエストの作成には GitHub が必要です。自己ホスト型の [GitHub Enterprise Server](https://code.claude.com/docs/ja/github-enterprise-server.md) インスタンスは Team および Enterprise プランでサポートされています。GitLab、Bitbucket、またはその他の非 GitHub リポジトリをクラウドセッションに [ローカルバンドル](#send-local-repositories-without-github) として送信できます。これは `CCR_FORCE_BUNDLE=1` を設定することで実現できますが、セッションはその結果をリモートにプッシュバックできません。
  * **自己ホスト環境**: 他の git ホスト上のリポジトリについては、[`--environment` でセッションを開始するための要件](https://code.claude.com/docs/ja/self-hosted-environments-deploy#start-a-session-on-a-repository-outside-github) を参照してください。
* **組織 IP 許可リスト**: クラウドセッションは、ユーザーのネットワークではなく Anthropic 管理のインフラストラクチャから Anthropic API を呼び出します。一方、[自己ホスト環境](https://code.claude.com/docs/ja/self-hosted-environments) のセッションは自身のネットワークから呼び出します。組織で [IP 許可リスト](https://support.claude.com/en/articles/13200993-restrict-access-to-claude-with-ip-allowlisting) が有効になっている場合、Anthropic ホスト型のすべてのクラウドセッションは認証エラーで失敗します。
  * **Code Review とスケジュールタスク**: 同じことが [Code Review](https://code.claude.com/docs/ja/code-review.md) と、Anthropic ホスト環境で実行される [クラウドスケジュールタスク](https://code.claude.com/docs/ja/routines.md) にも当てはまります。自己ホスト環境にルーティングされたスケジュールタスクは、自身のネットワークから API を呼び出します。
  * **除外の取得**: Anthropic ホスト型サービスを組織の IP 許可リストから除外するには、[Anthropic サポート](https://support.claude.com/) にお問い合わせください。

## 関連リソース

* [クラウド環境](https://code.claude.com/docs/ja/cloud-environments.md)：クラウドセッションのネットワークアクセス、環境変数、セットアップスクリプトを設定
* [Projects](https://code.claude.com/docs/ja/claude-projects.md)：Claude がリポジトリ上で並列クラウドセッションを調整し、結果を報告する 1 つの会話
* [Ultrareview](https://code.claude.com/docs/ja/ultrareview.md)：クラウドサンドボックスで深いマルチエージェントコードレビューを実行
* [クラウドスケジュールタスク](https://code.claude.com/docs/ja/routines.md)：スケジュール、API 呼び出し、または GitHub イベントに応答して作業を自動化
* [フック設定](https://code.claude.com/docs/ja/hooks.md)：セッションライフサイクルイベントでスクリプトを実行
* [すべての設定](https://code.claude.com/docs/ja/settings-reference.md)：すべての設定オプション
* [セキュリティ](https://code.claude.com/docs/ja/security.md)：分離保証とデータ処理
* [データ使用](https://code.claude.com/docs/ja/data-usage.md)：Anthropic がクラウドセッションから保持するもの
* [Claude Tag](https://claude.com/docs/claude-tag/overview)：Slack で実行される組織管理の @Claude で、同じクラウドインフラストラクチャで動作
