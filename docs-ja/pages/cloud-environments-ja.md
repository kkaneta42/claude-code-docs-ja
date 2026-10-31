> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# クラウド環境を設定する

> Claude Code クラウドセッション用のクラウド環境を設定します。ネットワークアクセスレベル、環境変数、セットアップスクリプト、環境キャッシュを構成できます。

> [!NOTE]
>
> クラウド環境は [クラウドセッション](https://code.claude.com/docs/ja/claude-code-on-the-web.md) に適用されます。これは Pro、Max、Ultra、Team プランで利用可能であり、[プレミアムシートまたは Chat + Claude Code シートを持つ](https://support.claude.com/en/articles/11845131-use-claude-code-with-your-team-or-enterprise-plan) Enterprise ユーザー向けです。

各 [クラウドセッション](https://code.claude.com/docs/ja/claude-code-on-the-web.md) はクラウド環境で実行されます。環境を設定して [ネットワークアクセス](#access-levels) を許可または拒否し、セッション用に [環境変数を設定](#set-environment-variables) し、セッションが内容を見ずに使用できる [ネットワークシークレット](#add-network-secrets) を保存し、Claude が作業を開始する前に [セットアップスクリプト](#setup-scripts) を実行できます。

同じ環境は、クラウドセッションを開始する場所に関係なく適用されます。

* [Desktop アプリ](https://code.claude.com/docs/ja/desktop.md)
* [Claude モバイルアプリ](https://code.claude.com/docs/ja/mobile.md)
* [claude.ai/code](https://claude.ai/code) のブラウザ
* [`claude --cloud`](https://code.claude.com/docs/ja/claude-code-on-the-web#from-terminal-to-cloud) を使用したターミナル
* [クラウドスケジュールタスク](https://code.claude.com/docs/ja/routines.md)
* [Claude Tag](https://claude.com/docs/claude-tag/overview)

これらの各サーフェスは [セルフホスト環境](https://code.claude.com/docs/ja/self-hosted-environments) にもルーティングできます。[利用可能性と制限](https://code.claude.com/docs/ja/self-hosted-environments#availability-and-limitations) は、Claude Tag セッションがセルフホスト環境で実行される場合に Claude がまだ使用できないものをカバーしています。

> [!NOTE]
>
> [Remote Control](https://code.claude.com/docs/ja/remote-control.md) セッションは Web とモバイルインターフェイスを自分のマシン上のセッションに接続します。これはクラウド環境ではなく、自分のマシンのネットワークとファイルを使用します。Claude Tag チャネルが使用する環境を選択するには、[Claude Tag チャネルが使用する環境を設定する](#set-the-environment-a-claude-tag-channel-uses) を参照してください。

## Default 環境

環境がまだない場合、オンボーディングは **Default** 環境をセットアップします。どのように設定されるかは、オンボーディングの場所によって異なります。

* **`/web-setup` などの CLI フロー**：**Default** を作成します
* **Pro、Max、および Ultra での Web オンボーディング**：**Default** が自動的に用意されます
* **Team および Enterprise での Web オンボーディング**：オーナーが [Quick setup](https://code.claude.com/docs/ja/claude-code-on-the-web.md#quick-setup-for-team-and-enterprise) をオンにしていない限り、**最初のクラウド環境を作成** フォームを表示します。フォームのデフォルトを保持して **作成して完了** をクリックして、同じ **Default** 環境を取得します

**Default** は独自の設定を持ちません。

* [**Trusted** ネットワークアクセス](#access-levels)：セッションはパッケージレジストリおよび他の [許可リストドメイン](#default-allowed-domains) に到達でき、セッションのネットワークを通じて他には何も到達できません。
* その他の設定なし：**Default** は環境変数またはセットアップスクリプトを定義しないため、セッションは [プリインストールされたツール](#installed-tools) だけで開始されます。

**Default** のみが利用可能な場合、すべてのセッションはそれで実行されます。複数の環境がある場合、セッションはサーフェスごとに 1 つを選択します。

* Desktop アプリ、モバイルアプリ、および claude.ai/code では、自分で開始したセッションは [セレクタ](#configure-your-environment) に表示される環境を使用します。オーナーが設定した [組織のデフォルト](#organization-shared-environments) は、選択していない場合にセレクションを埋めます。[プロジェクト](https://code.claude.com/docs/ja/claude-projects.md#project-settings-reference) 内のスレッドは、代わりにプロジェクトの設定で設定された環境を使用します。
* CLI からは、Claude Code は [`/remote-env` の選択](#select-an-environment-from-the-cli) を使用するか、リストに 1 つある場合は Anthropic ホスト環境にフォールバックし、そうでない場合はブリッジ環境ではないリスト内の最初の環境にフォールバックします。ブリッジ環境は、クラウド環境ではなく独自のマシンを表すために [Remote Control](https://code.claude.com/docs/ja/remote-control.md) が登録するエントリです。[セルフホスト環境](https://code.claude.com/docs/ja/self-hosted-environments) の場合、[セッションをディスパッチする](https://code.claude.com/docs/ja/self-hosted-environments-testing.md#run-the-test-loop) ときに `ccpool_` ID を持つ `--environment <environment-id>` を渡すと、その呼び出しの `/remote-env` の選択とフォールバックをオーバーライドします。Claude Code は Anthropic ホスト `env_` ID をフラグに渡されたものを拒否するため、それらをターゲットにするには `/remote-env` を使用します。フラグには Claude Code v2.1.224 以降が必要です。

デフォルトでは不十分な場合は環境を設定します。Claude が [デフォルト許可リスト](#default-allowed-domains) 外のドメインに到達する必要がある場合、セッション用に環境変数を設定する必要がある場合、または作業を開始する前に依存関係をインストールする必要がある場合です。

## 環境を設定する

[claude.ai/code](https://claude.ai/code) で新しいセッションを開始する画面のメッセージボックスの下にある環境セレクターから、環境を追加、編集、アーカイブできます。この画面にアクセスするには、[Web オンボーディング](https://code.claude.com/docs/ja/web-quickstart.md) を完了してください。Desktop アプリについては、[クラウドセッション](https://code.claude.com/docs/ja/desktop.md#cloud-sessions) を参照してください。作成した環境はアカウントに個人的なものです。Owner が作成した [共有環境](#organization-shared-environments) も、それらと並んでセレクターに表示されます。設定なしで利用可能な内容については、[インストール済みツール](#installed-tools) を参照してください。

セレクターは、新しいセッションの最初のメッセージを送信するまでしか表示されません。実行中の自分のクラウドセッションの環境を編集するには、上部のセッションタイトルの後にあるキャレットを選択し、**クラウド環境を編集** を選択します。

**1. 環境セレクターを開く**

新しいセッションの画面で、メッセージボックスの下の行にある最初のコントロールを選択します。

**2. 環境を追加または編集する**

* **環境を追加する**: メニュー下部の **新しい環境** を選択して **新しい環境** ダイアログを開きます。フォームに入力し、**環境を追加** を選択します。新しいセッションでは、追加した環境が使用されます。
* **環境を編集する**: **Cloud** の下でその環境の行を見つけます。**Cloud** が 1 行だけの場合は、それを選択してリストを開きます。環境が **Cloud** の下に表示されていない場合は、その見出しの下の **その他** 行を選択します。環境の行にホバーし、右側に表示される設定アイコンを選択してダイアログを開きます。

環境を追加する場合、または自分の環境を編集する場合は、ダイアログの [**ネットワークアクセス**](#network-access)、[**セットアップスクリプト**](#add-a-setup-script)、または [**環境変数**](#set-environment-variables) 行を選択して、その設定を開きます。最後の変更が終わったら、新しい環境の場合は **環境を追加**、既存の環境の場合は **変更を保存** で保存します。セッションがキーを見ることなく使用できるようにキーを保存するには、[ネットワークシークレットを追加する](#add-network-secrets) を参照してください。

### 環境変数を設定する

環境変数は `.env` 形式を使用し、1 行に 1 つの `KEY=value` ペアです。プレーン値は引用符が不要で、一致するペアで値を引用符で囲む場合、引用符は値の一部にはなりません。複数行にまたがる値または `#` を含む値を引用符で囲みます。引用符なしの値では、`#` はコメントを開始し、行の残りは削除されます。

次の例は 3 つの変数を定義しています。

```text theme={null}
NODE_ENV=development
LOG_LEVEL=debug
DATABASE_URL=postgres://localhost:5432/myapp
```

セッションは環境の値を読み込んで、Claude が実行するコマンドが読み取ることができる通常の環境変数にします。ただし、`OTEL_*` 変数は除きます。Claude Code はそれらを独自の [テレメトリエクスポート](https://code.claude.com/docs/ja/monitoring-usage.md#telemetry-from-cloud-sessions-and-claude-tag) に使用し、実行するコマンドに渡しません。

Anthropic ホスト型環境では、セッションは環境の値をセッション作成時に読み込み、その後 Claude Code がセッションの VM で起動するたびに再度読み込みます。これは 2 つのケースで発生します。

* **VM がアイドル後に復元される**: 数分間アクティビティがない場合、セッションの VM はファイルが保存された状態で一時停止します。次のメッセージは同じ VM を復元し、Claude Code を再度起動します。
* **VM が回収され再構築される**: 一時停止した VM が [回収](https://code.claude.com/docs/ja/claude-code-on-the-web.md#environment-expired) されている場合、セッションを再度開くと新しい VM がプロビジョニングされます。

変数を編集、追加、または削除した後、Anthropic ホスト型環境の既存セッションは、VM が次に復元または再構築されるまで最後に読み込んだ値を保持し、その後は変更を使用します。VM はセッションがアイドル状態になると自動的に一時停止し、自分で一時停止することはできません。新しい値をすぐに使用するには、Claude に実行するコマンドで設定するよう依頼します。例えば `LOG_LEVEL=trace npm test` のように、または新しいセッションを開始します。

クラウドセッションは起動時に自身でいくつかの変数も設定します。[`CLAUDE_AUTOCOMPACT_PCT_OVERRIDE`](https://code.claude.com/docs/ja/claude-code-on-the-web#manage-context) の場合、セッションが設定する値はここで追加した値をオーバーライドするため、ここでそのキーを追加しても効果がありません。

環境を使用する誰もが値を読み取ることができます。Anthropic ホスト型環境では、エージェントプロキシがリクエストに添付できるキーに対しては、代わりに [ネットワークシークレット](#add-network-secrets) を使用してください。[シークレットを取得しないリクエスト](#requests-that-never-get-the-credential) はそこにリストされています。

### ネットワークシークレットを追加する

ネットワークシークレットは、クラウド環境に保存する API キーまたはトークンで、Claude が環境内の任意のセッションからそのキーを見ることなく API を呼び出すことができます。Anthropic のエージェントプロキシは、各リクエストがセッションの VM を離れた後、リストしたホストへのリクエストにキーを追加するため、キー自体は VM の外部にとどまります。

ネットワークシークレットは Pro、Max、Ultra、Team、Enterprise プランで利用可能です。自分で追加できるかどうかを確認するには、[要件](#requirements) を参照してください。

#### 要件

これらの要件によって、シークレットを追加できるかどうか、および追加後にエージェントプロキシがそれを使用できるかどうかが決まります。

* **ロール**: すべてのプランで、ロールに関係なく自分の環境でシークレットを追加および削除できます。Team および Enterprise では、Owner は claude.ai 組織内で組織管理者ロールを保持し、Admin は保持しません。これにより、次のケースで表示される内容が変わります。
  * **自分の環境**: 組織管理者ロールがない場合、**シークレットを追加** を選択すると [短いフォーム](#add-a-secret-without-the-role) が開きます
  * **共有環境**: Owner が管理設定から [シークレットを追加および削除](#add-a-credential) します。組織管理者ロールがない場合は、環境のダイアログに **ネットワークシークレット** セクションがないため、Owner にシークレットの追加を依頼してください
* **環境タイプ**: 既に存在する Anthropic ホスト型クラウド環境。[自己ホスト型環境](https://code.claude.com/docs/ja/self-hosted-environments) にはネットワークシークレットがありません
* **API 到達可能性**: API がインターネットからの接続を受け入れます。リクエストは Anthropic のネットワークから離れるためです
* **暗号化キー**: 組織が顧客管理の暗号化キーを使用する場合、ネットワークシークレットを保存できません

#### シークレットを追加する

シークレットは一度に 1 つずつ追加します。シークレットのホストまたは値を変更するには、削除して再度追加します。

[共有環境](#organization-shared-environments) にシークレットを追加するには、[管理設定](https://claude.ai/admin-settings) の **クラウド環境** ページから環境を編集用に開き、その **ネットワークシークレット** セクションで手順 2 から続けます。Team または Enterprise プランで [組織管理者ロール](#requirements) を持っていない場合は、自分の環境で手順 1 に従い、その後 [短いフォームに入力](#add-a-secret-without-the-role) します。

**1. 環境のネットワークシークレットを開く**

[claude.ai/code](https://claude.ai/code) で [環境を編集用に開きます](#configure-your-environment)。**クラウド環境を編集** ダイアログで、**ネットワークシークレット** 行を選択します。環境に既にあるシークレットが表示され、それぞれが適用されるホストが表示されます。

**2. シークレットを追加する**

**シークレットを追加**（管理設定では **追加** と表示）を選択してフォームに入力します。API キーがリクエストヘッダーで移動する場合はデフォルトの **シークレットタイプ**、**Bearer** を保持し、これらのフィールドに入力します。

* **名前**: `Internal billing API` などのシークレットのラベル
* **許可されたウェブサイト**: `api.example.com` などの API のホスト。先頭の `*.` はすべてのサブドメインと一致します
* **カスタムヘッダー**: キーを運ぶヘッダーの 1 行。行は `Authorization` をヘッダーの **名前** として、`Bearer` を **プレフィックス** として開始します。キー自体を **値** として貼り付けます。`X-Api-Key` のようなベア値を取得するヘッダーの場合、名前を変更してプレフィックスをクリアします

別の方法で認証する API の場合、別の **シークレットタイプ** を選択します。リストは [Claude Tag](https://claude.com/docs/claude-tag/overview)（Team および Enterprise プランの Slack 統合）が [接続](https://claude.com/docs/claude-tag/admins/add-connections) に提供するものと同じです。

**3. シークレットを保存する**

**追加** を選択します。シークレットはリストにホストと共に表示され、ダイアログの **変更を保存** ボタンなしで保存されます。保存後に値を再度表示することはできません。

シークレットが機能することを確認するには、環境でセッションを開始して Claude に API を呼び出すよう依頼します。例えば `curl` を使用します。API はキーがリクエストにあるかのように応答し、キーはセッションの環境変数またはファイルに表示されません。リストがシークレットを **送信されていません** とマークしている場合、その下のメモは理由と対処方法を説明しています。ホストが正確に一致せずに重複する 2 つのシークレットはマーカーを取得せず、エージェントプロキシはそのうちの 1 つだけを送信します。

#### 組織管理者ロールなしでシークレットを追加する

Team または Enterprise プランで [組織管理者ロール](#requirements) を持っていない場合、**シークレットを追加** フォームでは 1 つのホストに対して 1 つのシークレットを指定します。環境の [**ネットワークシークレット** 行](#add-a-credential) を選択し、次に **シークレットを追加** を選択します。次のフィールドに入力し、フォームの **シークレットを追加** ボタンを選択します。

* **ホスト**: シークレットを受け取る 1 つのホスト（`api.example.com` など）。フォームは `*.` ワイルドカードを受け付けません
* **名前**: シークレットの任意のラベル
* **シークレットタイプ**: リクエストヘッダーで送信されるキーの場合は **トークン**、または **ユーザー名とパスワード**。トークンの場合は、キーを **値** として貼り付けます

#### どのリクエストがシークレットを取得するか

エージェントプロキシは、リクエストのホストがそのシークレットにリストしたものと一致する場合、シークレットをリクエストに添付します。セッションは、環境の [ネットワークアクセスレベル](#access-levels) がそれ以外の場合は許可しない場合でも、[シークレットを取得しないホスト](#requests-that-never-get-the-credential) を除いて、これらのホストに到達できます。シークレットは、削除するまで、それを開始した人に関係なく、環境で実行されるすべてのセッションに適用されます。

#### シークレットを取得しないリクエスト

エージェントプロキシは、追加したシークレットをこれらのリクエストに添付しません。

* **GitHub**: [GitHub プロキシ](#github-proxy) は代わりに GitHub へのリクエストを認証するため、GitHub に対してネットワークシークレットは不要です
* **Anthropic API およびパブリックパッケージレジストリ**: `api.anthropic.com`、`registry.npmjs.org`、`jsr.io`、`npm.jsr.io`、`pypi.org`、`files.pythonhosted.org`、`index.crates.io`、および `proxy.golang.org`
* **セットアップスクリプトリクエスト**: Claude Code は [セットアップスクリプト](#setup-scripts) が実行された後、起動時にエージェントプロキシに接続します
* **Claude Code のテレメトリエクスポート**: Claude Code は [テレメトリエクスポート](https://code.claude.com/docs/ja/monitoring-usage.md#telemetry-from-cloud-sessions-and-claude-tag) を実行するコマンドではなく自身で送信し、そのリクエストはエージェントプロキシを通過しません

### CLI から環境を選択する

ターミナルで `/remote-env` を実行して、[`claude --cloud`](https://code.claude.com/docs/ja/claude-code-on-the-web#from-terminal-to-cloud) などの CLI から作成するクラウドセッションのデフォルト環境を選択します。コマンドは既存の環境のピッカーを開き、選択を [ユーザー設定](https://code.claude.com/docs/ja/settings.md#where-settings-live) の `remote.defaultEnvironmentId` キーに保存するため、マシン上のすべてのプロジェクトに適用されます。同じキーが [設定レイヤー](https://code.claude.com/docs/ja/settings.md#settings-precedence) の高い優先度で設定されている場合（リポジトリのプロジェクト設定など）を除きます。

[自己ホスト型環境](https://code.claude.com/docs/ja/self-hosted-environments) ID（`ccpool_...` の形式）は、より厳密なソースルールに従います。Claude Code がそれを受け入れる設定レイヤーについては、[`remote.defaultEnvironmentId`](https://code.claude.com/docs/ja/settings-reference#remote-defaultenvironmentid) を参照してください。

`/remote-env` はデフォルトのみを設定します。セッションを開始せず、環境を追加または編集することはできません。[環境セレクター](#configure-your-environment) から管理します。

### 環境をアーカイブする

自分の環境の 1 つをアーカイブするには、編集用に開いて **環境をアーカイブ** を選択し、確認します。環境が [組織と共有](#organization-shared-environments) されている場合は、代わりに Owner が [管理設定](https://claude.ai/admin-settings) の **クラウド環境** ページからアーカイブするため、自分が Owner でない場合は Owner に依頼してください。

アーカイブは新しいセッションに影響し、実行中のセッションには影響しません。

* 環境で既に実行中のセッションは引き続き機能します。
* 環境はセレクターと `/remote-env` から消えるため、新しいセッション用に選択できません。
* 環境のネットワークシークレットは実行中のセッションに添付されたままです。アーカイブする前に不要なものを削除してください。
* アーカイブされた環境では、どのサーフェスでも新しいセッションを開始できません。
  * **保存された CLI デフォルト**: 環境が保存された [CLI デフォルト](#select-an-environment-from-the-cli) だった場合、リストに Anthropic ホスト型環境があれば、Claude Code はそこで CLI クラウドセッションを開始します。ない場合は、リスト内で [Remote Control ブリッジ環境](#the-default-environment) ではない最初の環境で開始します。
  * **明示的に設定されたもの**: [クラウドスケジュールタスク](https://code.claude.com/docs/ja/routines.md#environments-and-network-access) など、その環境を明示的に指定して設定されたものは、その環境で新しいセッションを開始できません。別の環境を指すようにしてください。

Anthropic ホスト型環境が不要になったら、アーカイブしてください。環境のダイアログにも **クラウド環境** 管理ページにも、Anthropic ホスト型環境を削除するオプションはありません。環境が [自己ホスト型](https://code.claude.com/docs/ja/self-hosted-environments) の場合は、Owner が管理設定の **クラウド環境** ページから削除できます。自分が Owner でない場合は、Owner に削除を依頼してください。

### 組織共有環境

Team および Enterprise プランでは、Owner は組織のすべてのメンバーと共有されるクラウド環境を作成できます。同じロールは **クラウド環境** 管理ページで他のすべてを管理します。[自己ホスト型環境](https://code.claude.com/docs/ja/self-hosted-environments) を含みます。Admin ロールはページを開くことができません。それを開くことができるロールの完全なリストは、[サーバー管理設定を管理する](https://code.claude.com/docs/ja/server-managed-settings.md#access-control) ためのものです。

共有環境は各メンバーの [環境セレクター](#configure-your-environment) に **組織** 見出しの下に表示され、メンバー独自の環境の下に **個人** が表示されるため、チームは各メンバーが再作成する代わりに 1 つの設定で標準化できます。共有環境の設定アイコンを選択すると、すべてのメンバー（Owner を含む）の設定の読み取り専用サマリーが開きます。

Owner は 2 つの方法のいずれかで環境を組織で利用可能にします。

* **共有環境を作成する**: [管理設定](https://claude.ai/admin-settings) の **クラウド環境** ページを使用します。これは Owner が共有環境を編集およびアーカイブする場所でもあります。各環境には名前、[ネットワークアクセスレベル](#access-levels)、`.env` 形式の [環境変数](#set-environment-variables)、および [セットアップスクリプト](#setup-scripts) があります。
* **個人環境を共有する**: 環境セレクターで独自の環境の 1 つを編集用に開き、**それを使用できるユーザー** 行から共有します。環境はその ID を保持するため、既にそれを使用しているセッションとスケジュールタスクは影響を受けず、すべてのメンバーはそれを見てセッションを開始できます。

Owner は [claude.ai/admin-settings/claude-code](https://claude.ai/admin-settings/claude-code) で組織の [デフォルト環境](#the-default-environment) を別途選択します。

共有環境のセッションに読み取れないキーを提供するには、**クラウド環境** ページで環境を編集する際に [ネットワークシークレット](#add-network-secrets) を追加します。すべてのメンバーのセッションが変数を読み取るため、変数にシークレットを含めないでください。

### Claude Tag チャネルが使用する環境を設定する

[Claude Tag](https://claude.com/docs/claude-tag/overview) チャネルでは、Claude はメンバーではなく組織の共有アイデンティティとして機能するため、チャネルセッションは組織レベルの環境のみを使用します。共有環境または [自己ホスト型環境](https://code.claude.com/docs/ja/self-hosted-environments)。チャネルに .NET などの [事前インストール](#installed-tools) されていないツールチェーンを提供するには、Owner は **クラウド環境** 管理ページから [共有環境](#organization-shared-environments) を作成し、それをインストールする [セットアップスクリプト](#setup-scripts) を使用できます。チャネルを環境に指す 2 つの方法のいずれかで：

* [claude.ai/admin-settings/claude-code](https://claude.ai/admin-settings/claude-code) で共有環境または自己ホスト型環境を組織の [デフォルト環境](#the-default-environment) として設定します。
* Claude Tag 管理設定で [チャネルに 1 つをピンする](https://claude.com/docs/claude-tag/admins/troubleshooting#channel-sessions-use-the-wrong-environment-or-can%E2%80%99t-find-one)。

## ネットワークアクセス

各環境は 1 つのネットワークアクセスレベルを設定します。これは、セッションが行える送信接続を制御します。デフォルトレベルの **Trusted** は、パッケージレジストリおよび他の [許可リストに登録されたドメイン](#default-allowed-domains) を許可します。**Custom** はカスタムドメインリストを使用します。

環境のネットワークアクセスを変更するには、[編集用に開き](#configure-your-environment)、ダイアログの **Network access** セレクターを使用します。[共有環境](#organization-shared-environments) はそこで読み取り専用で開くため、Owner は [admin settings](https://claude.ai/admin-settings) の **Cloud environments** ページからネットワークアクセスを変更します。セレクターを開くコントロールは、[The Default environment](#the-default-environment) に記載されているアプリサーフェスと [クラウドスケジュールタスクエディター](https://code.claude.com/docs/ja/routines.md#environments-and-network-access) に表示されます。個人環境は claude.ai アカウント設定に別ページを持ちません。

Anthropic ホスト環境のネットワークアクセスを変更すると、既存のセッションはセッションの [network allowlist](#access-levels) を通じて行くリクエストについて、約 1 分以内に新しい設定に従います。新しいセッションを開始する必要はありません。

> [!NOTE]
>
> セッションまたはスケジュールタスクで有効にした MCP コネクタは、**Allowed domains** にホストを追加しなくても機能します。コネクタのトラフィックはセッションのネットワークではなく Anthropic のサーバーを通じて移動するためです。これは [Security and isolation](https://code.claude.com/docs/ja/claude-code-on-the-web.md#security-and-isolation) に記載されている同じ Anthropic バウンドチャネルに依存しています。不要なコネクタをオフにして、Claude が到達できるツールを制限します。

### アクセスレベル

[environment dialog](#configure-your-environment) の **Network access** フィールドは、4 つのレベルのいずれかを取ります。

| Level | 送信接続 |
| :- | :- |
| **None** | セッションのネットワークを通じた送信ネットワークアクセスなし |
| **Trusted** | [許可リストに登録されたドメイン](#default-allowed-domains) のみ：パッケージレジストリ、GitHub、クラウド SDK |
| **Full** | 任意のドメイン |
| **Custom** | カスタム許可リスト（オプションでデフォルトを含む） |

どのレベルを選択しても、セッションはこれらに到達できます。各セッションはセッションのネットワーク許可リストを通じない経路を取るためです。

* GitHub（[separate proxy](#github-proxy) を通じて）
* 有効にした [MCP connectors](#network-access)（トラフィックは Anthropic のサーバーを通じて移動）
* 環境の [ネットワークシークレット](#add-network-secrets) にリストしたホスト（[シークレットを取得しないホスト](#requests-that-never-get-the-credential) を除く）
* Anthropic API（Claude Code 独自のリクエスト用。[Security and isolation](https://code.claude.com/docs/ja/claude-code-on-the-web.md#security-and-isolation) に記載されているように **None** でも）

### 特定のドメインを許可する

Trusted リストにないドメインを許可するには、環境のネットワークアクセス設定で **Custom** を選択し、**Allowed domains** フィールドに 1 行に 1 つのドメインをリストします。この例は、内部プロジェクトが必要とする 3 つのホストを許可します。

```text theme={null}
api.example.com
*.internal.example.com
registry.example.com
```

この環境のセッションは、`api.example.com`、`internal.example.com` のすべてのサブドメイン、および `registry.example.com` に到達でき、セッションのネットワークを通じた他のドメインには到達できません。[GitHub traffic](#github-proxy)、[MCP connector traffic](#network-access)、および環境の [ネットワークシークレット](#add-network-secrets) のホストへのリクエスト（[シークレットを取得しないホスト](#requests-that-never-get-the-credential) を除く）は、この許可リストを通じません。先頭の `*.` はすべてのサブドメインにマッチします。[Trusted domains](#default-allowed-domains) も保持するには、**Also include default list of common package managers** をチェックします。チェックを外すと、リストしたもののみを許可します。

組織が [artifacts](https://code.claude.com/docs/ja/artifacts.md#availability) を使用する場合、セッションがそれらを読み取るために `*.frame.claudeusercontent.com` をリストに含める必要はありません。リストがそのホストを除外する場合、Claude Code はセッションの Anthropic への接続を通じてアーティファクトコンテンツを読み取ります。ホストを許可リストに保持する 2 つの状況があります。

* **この環境のセッションが別の組織のパブリックアーティファクトを開く**：Claude Code はホストから直接それらをフェッチするため、このリストに追加します。
* **ローカル CLI または自己ホスト型ランナーを設定している**：ホストをその許可リストに保持します。[network access requirements](https://code.claude.com/docs/ja/network-config.md#network-access-requirements) と自己ホスト型 [network requirements](https://code.claude.com/docs/ja/self-hosted-environments-deploy.md#network-requirements) を参照してください。

各環境は独自の許可ドメインリストを持ちます。管理者がすべてのメンバーの環境にプッシュできる組織レベルの許可リストはありません。[server-managed setting](https://code.claude.com/docs/ja/server-managed-settings.md) も環境のネットワーク許可リストにドメインを追加しません。チームに 1 つの標準リストを提供するには、Owner が **Custom** ネットワークアクセスとそのリストを持つ [organization-shared environment](#organization-shared-environments) を作成できます。

### GitHub プロキシ

Anthropic ホスト環境では、すべての GitHub 操作は、環境の [access level](#access-levels) に関係なく、セッションの VM の外に実際の GitHub 認証情報を保つ専用プロキシを通じて行われます。自己ホスト型環境のセッションは、デプロイが提供する認証情報で git 操作を認証します。[Configure git](https://code.claude.com/docs/ja/self-hosted-environments-deploy.md#configure-git) はオプションをカバーしており、セッションごとにミントされた認証情報と同じプロキシへのオプトインが含まれます。プロキシは以下を提供します。

* **Git credentials**：VM 内の git クライアントはスコープ付き認証情報を使用し、プロキシはそれを検証して実際の GitHub トークンと交換します。
* **API requests**：組み込み GitHub ツールからのリクエスト、および [`proxy-injected` placeholder](#work-with-github-issues-and-pull-requests) の下の `gh` からのリクエストは、実際の認証情報が置き換えられて送信されます。
* **Push restrictions**：プロキシは、ブランチの削除と、タグなどブランチ以外のもののプッシュを拒否します。プッシュで更新できるブランチは制限しません。それを制限するには、GitHub のブランチ保護ルールまたはルールセットを使用してください。
* **Repository scope**：プロキシは、セッションに接続されたリポジトリに対する GitHub API リクエストを処理します。他のリポジトリに対する API リクエストは、`GitHub access to` で始まり `is not enabled for this session` を含むメッセージとともに 403 を受け取ります。`github.com/{owner}/{repo}/archive/` または `codeload.github.com` の URL 経由で取得するソースアーカイブも、リポジトリが接続されていない場合は、パブリックリポジトリであっても同じ 403 を受け取ります。
* **GraphQL restrictions**：プロキシは GitHub の GraphQL エンドポイントへのリクエストを、`GitHub GraphQL is not available from Claude Code sessions` で始まり REST フォールバック `gh api repos/{owner}/{repo}/...` を示すメッセージとともに 403 で拒否します。`gh pr` や `gh issue` など GraphQL を使用する `gh` サブコマンドも同じ 403 を受け取ります。制限は、提供する認証情報に関係なく、プロキシを通じたすべてのリクエストに適用されるため、設定した `GH_TOKEN` は同じ 403 を取得します。Claude はプロキシを通じて Projects v2 などの GraphQL にのみ存在する GitHub API に到達できません。

パブリックリポジトリからのコミットされたファイルは `raw.githubusercontent.com` を通じて到着し、[security proxy](#security-proxy) が代わりに処理します。そのドメインはデフォルト [Trusted list](#default-allowed-domains) にあるため、環境の [access level](#access-levels) がそれを除外しない限り、それらのファイルは到達可能なままです。

### セキュリティプロキシ

Anthropic ホスト環境のクラウドセッションは、セキュリティと不正使用防止のための HTTP/HTTPS ネットワークプロキシの背後で実行されます。[self-hosted environment](https://code.claude.com/docs/ja/self-hosted-environments-deploy.md#default-deny-egress) では、送信トラフィックは代わりに独自のネットワーク境界を通じて離脱します。Anthropic ホストセッションからのすべての送信インターネットトラフィックはこのプロキシを通じて渡され、以下を提供します。

* 悪意のあるリクエストに対する保護
* レート制限と不正使用防止

## クラウドセッションで利用可能な機能

Anthropic ホスト環境では、各セッションは独自のオペレーティングシステムと CPU アーキテクチャに関係なく、Ubuntu 24.04 を x86\_64 で実行する新しい仮想マシン（VM）を取得し、リポジトリがクローンされ、一般的なツールチェーンが事前にインストールされています。依存関係が Ruby ネイティブ拡張機能付きの gem やプリビルド Python wheels などのプリコンパイル済みバイナリを提供する場合は、VM に合わせて x86\_64 Linux ビルドを使用してください。このセクションでは、Anthropic ホストのデフォルト、組み込み GitHub ツール、[テストとサービスの実行](#run-tests-start-services-and-add-packages)方法、各 VM が取得する[リソース制限](#resource-limits)、および[時間制限](#time-limits)について説明します。

> [!NOTE]
>
> 組織が[セルフホスト環境](https://code.claude.com/docs/ja/self-hosted-environments)にルーティングするセッションは、代わりに独自のランナーで実行され、ランナーイメージが提供するツールを使用します。

### セットアップから引き継がれるもの

> [!NOTE]
>
> この表のリポジトリ設定のうち、[プロジェクト](https://code.claude.com/docs/ja/claude-projects.md)内のクラウドスレッドが読み込むのは、リポジトリルートの `CLAUDE.md`、`.claude/CLAUDE.md`、および[パス固有](https://code.claude.com/docs/ja/memory.md#path-specific-rules)ではない `.claude/rules/` ファイルのみです。[スレッドがリポジトリから取り込むもの](https://code.claude.com/docs/ja/claude-projects.md#what-threads-pick-up-from-your-repositories)を参照してください。

クラウドセッションはリポジトリの新しいクローンから開始されます。リポジトリにコミットしたものはすべて利用可能です。独自のマシンにのみインストールまたは構成したものはセッションでは利用できません。組織のポリシーは[サーバー管理設定](https://code.claude.com/docs/ja/server-managed-settings.md)を通じて別途到着します。

| | クラウドセッションで利用可能 | 理由 |
| :- | :- | :- |
| リポジトリの `CLAUDE.md` | はい | クローンの一部 |
| リポジトリの `.claude/settings.json` フックと権限ルール | はい、1 つのリポジトリを持つセッションの場合 | クローンの一部。複数のリポジトリを持つセッションについては、[読み取られる設定](https://code.claude.com/docs/ja/settings.md#settings-in-cloud-sessions)を参照してください |
| リポジトリの `.mcp.json` MCP サーバー | はい、1 つのリポジトリを持つセッションの場合 | クローンの一部、セッションの作業ディレクトリから検出されます。セルフホスト環境については、[どのリポジトリの設定が適用されるか](https://code.claude.com/docs/ja/self-hosted-environments-configuration.md#repository-settings-in-sessions-with-several-repositories)を参照してください |
| リポジトリの `.claude/rules/` | はい | クローンの一部 |
| リポジトリの `.claude/skills/`、`.claude/agents/`、`.claude/commands/` | はい | クローンの一部 |
| リポジトリの `.claude/settings.json` で宣言されたプラグインとマーケットプレイス | いいえ | クラウドセッションは、リポジトリが [`enabledPlugins`](https://code.claude.com/docs/ja/settings-reference#enabledplugins) で有効にするプラグインをインストールしません。これには [`extraKnownMarketplaces`](https://code.claude.com/docs/ja/settings-reference#extraknownmarketplaces) の下にリストされているマーケットプレイスのプラグインも含まれます |
| 組織の[サーバー管理設定](https://code.claude.com/docs/ja/server-managed-settings.md) | はい、[Claude Tag](https://claude.com/docs/claude-tag/overview) セッションを除く | セッション開始時に Anthropic のサーバーから取得されます。クラウドセッションで `availableModels` がどのように適用されるかについては、[Surface coverage](https://code.claude.com/docs/ja/model-config.md#surface-coverage) を参照してください。MDM または管理設定ファイルを通じてデバイスにデプロイされた設定は適用されません。セッションは Anthropic 管理 VM で実行されるためです。[セルフホスト環境](https://code.claude.com/docs/ja/self-hosted-environments)では、セッションはランナーイメージの管理設定ファイルも読み取ります。[Claude Code が管理ソースを組み合わせる方法](https://code.claude.com/docs/ja/managed-settings.md#how-claude-code-combines-managed-sources)に従います |
| ユーザー `~/.claude/CLAUDE.md` | いいえ | マシンに存在し、リポジトリには存在しません。[リポジトリにコミットせずに個人設定を追加する](#add-personal-preferences-without-committing-to-the-repo)を参照してください |
| ユーザー `~/.claude/skills/`、`~/.claude/agents/`、`~/.claude/commands/` | いいえ | マシンに存在し、リポジトリには存在しません。代わりにリポジトリの `.claude/` ディレクトリにコミットしてください。クラウドセッションは [claude.ai で有効にしたスキル](https://code.claude.com/docs/ja/skills.md#skills-in-cowork-and-cloud-sessions)を自動的に読み込みます |
| ユーザー設定でのみ有効なプラグイン | いいえ | ユーザースコープの `enabledPlugins` はマシンの `~/.claude/settings.json` に存在します |
| デフォルトのローカルスコープまたはユーザースコープで `claude mcp add` を使用して追加した MCP サーバー | いいえ | これらはマシンの `~/.claude.json` に書き込まれ、リポジトリには書き込まれません。`claude mcp add --scope project` でサーバーを追加します。これはリポジトリの[`.mcp.json`](https://code.claude.com/docs/ja/mcp#project-scope)に書き込まれ、そのファイルをコミットしてください。1 つのリポジトリを持つセッションはそれを読み込みます |
| リポジトリの `.claude/settings.json` `env` ブロック内のトランスポート変数（`NODE_EXTRA_CA_CERTS` や[mTLS クライアント証明書変数](https://code.claude.com/docs/ja/network-config.md#mtls-authentication)など） | いいえ | ホスティング環境がセッションの API 接続を管理するため、Claude Code はこれらのキーを無視し、セッションのデバッグログで無視された各キーを記録します |
| Claude が呼び出すサービスの API キーとトークン | Anthropic ホスト環境では、[ネットワークシークレット](#add-network-secrets)として | キーを環境に一度追加すると、エージェントプロキシがリストしたホストへのリクエストにそれを添付します。エージェントプロキシが[添付できない](#requests-that-never-get-the-credential)キーは環境変数に留まります |
| AWS SSO のようなインタラクティブ認証 | いいえ | サポートされていません。SSO はクラウドセッションで実行できないブラウザベースのログインが必要です |

クラウドセッションで独自の構成を利用可能にするには、リポジトリにコミットしてください。

環境を使用する誰もが環境変数とセットアップスクリプトを読むことができます。ダイアログの**環境変数**の下のメモはそのことを述べており、シークレットをそこに置かないよう警告しています。Anthropic ホスト環境では、代わりにエージェントプロキシが添付できるキーを[ネットワークシークレット](#add-network-secrets)として保存してください。

#### リポジトリにコミットせずに個人設定を追加する

Anthropic ホスト環境では、共有リポジトリに置きたくない設定のために、`~/.claude/CLAUDE.md` を書き込む[セットアップスクリプト](#setup-scripts)を追加してください。Claude Code はそのファイルをセッション内で[ユーザー指示](https://code.claude.com/docs/ja/memory.md#choose-where-to-put-claude-md-files)として読み込みます。この例では、コミットメッセージに関する設定を指定します：

```bash theme={null}
#!/bin/bash
mkdir -p ~/.claude
cat > ~/.claude/CLAUDE.md <<'EOF'
Use conventional commit messages.
EOF
```

このスクリプトは[共有環境](#organization-shared-environments)ではなく、自分の環境のいずれかに設定してください。

次のクラウドセッションで `/context` を実行し、**Memory files** の下に `/root/.claude/CLAUDE.md` が表示されることを確認してください。

### インストール済みツール

クラウドセッションには、一般的な言語ランタイム、ビルドツール、データベースが事前にインストールされています。以下の表は、カテゴリ別に含まれるものをまとめています。

| カテゴリ | 含まれるもの |
| :- | :- |
| **Python** | Python 3.x（pip、poetry、uv、black、mypy、pytest、ruff 付き） |
| **Node.js** | 20、21、22（npm、yarn、pnpm、bun¹、eslint、prettier、chromedriver 付き） |
| **Ruby** | 3.1、3.2、3.3（gem、bundler、rbenv 付き） |
| **PHP** | 8.3（Composer 付き） |
| **Java** | OpenJDK 21（Maven と Gradle 付き） |
| **Go** | モジュールサポート付き Go |
| **Rust** | rustc と cargo |
| **C/C++** | GCC、Clang、cmake、ninja、conan |
| **Docker** | docker、dockerd、docker compose |
| **データベース** | PostgreSQL 16、Redis 7.0 |
| **ユーティリティ** | git、gh、jq、yq、ripgrep、tmux、vim、nano |

¹ Bun はインストールされていますが、パッケージ取得の[プロキシ互換性の問題](#install-dependencies-with-a-sessionstart-hook)が既知です。

このテーブルのほとんどのツールのバージョンを取得するには、クラウドセッションで `check-tools` を実行するよう Claude に依頼してください。これは `/` で入力するコマンドではなく、セッション VM にインストールされたシェルコマンドです。[Claude がすべての VM コマンドを実行するため](#run-tests-start-services-and-add-packages)、Claude に依頼します。Ruby、PHP、bun、PostgreSQL、Redis など、報告されないツールについては、Claude にそのツール独自のバージョンコマンド（例：`psql --version`）を実行するよう依頼してください。

Node.js バージョンは `/opt/node20`、`/opt/node21`、`/opt/node22` にインストールされ、デフォルトでは 22 が `PATH` にあります。別のバージョンで作業するには、Claude にそのバージョンの `bin` ディレクトリ（例：`/opt/node20/bin`）を `PATH` の先頭に追加するよう依頼してください。

このリストの外のツールチェーン（.NET SDK など）は、パッケージレジストリが[デフォルト許可リスト](#default-allowed-domains)にある場合でも、事前にインストールされていません。[セットアップスクリプト](#setup-scripts)でインストールしてください。

### GitHub の issue とプルリクエストを操作する

クラウドセッションには、Claude が issue を読み取り、プルリクエストをリストし、diff を取得し、セットアップなしでコメントを投稿できる組み込み GitHub ツールが含まれています。これらのツールは[GitHub プロキシ](#github-proxy)を通じて認証され、[GitHub 認証オプション](https://code.claude.com/docs/ja/claude-code-on-the-web.md#github-authentication-options)で構成した方法を使用するため、トークンはコンテナに入りません。

[環境設定](#set-environment-variables)で `GH_TOKEN` または `GITHUB_TOKEN` を自分で設定するか、両方を設定しないままにして[GitHub プロキシ](#github-proxy)に認証を処理させることができます：

* トークンを設定した場合、コンテナに変更されずに渡されるため、スクリプトと GitHub の[`gh` CLI](https://cli.github.com)がそれを直接使用します。
* どちらも設定せず、[GitHub プロキシ](#github-proxy)がセッションの認証を処理している場合、Claude が実行するコマンドでは両方の変数がプレースホルダー文字列 `proxy-injected` として読み取られ、プロキシは送信 GitHub リクエストで実際の認証情報を置き換えます。アタッチされたリポジトリに対する `gh api` 呼び出しは独自のトークンなしで動作しますが、`GITHUB_TOKEN` を直接読み取るスクリプトはプレースホルダーを取得し、使用可能なトークンは取得しません。

設定したトークンは通常の環境変数であるため、環境を使用する誰もがそれを読むことができます。プロキシパスは認証情報を環境構成とセッション VM から除外します。

セッションにどちらが適用されるかを確認するには、Claude に `echo $GH_TOKEN` を実行するよう依頼してください。

GitHub の[`gh` CLI](https://cli.github.com)は事前にインストールされています。組み込みツールがカバーしていない GitHub 操作が必要な場合は、`gh api` で REST API を呼び出すよう Claude に依頼してください。`gh workflow list` など、REST API を使用する `gh` サブコマンドも動作します。`gh pr` や `gh issue` など、GraphQL を使用するサブコマンドはプロキシによって[拒否されます](#github-proxy)。`gh` は `GH_TOKEN` を自動的に読み取るため、`gh auth login` を実行する必要はありません。

### セッションに出力をリンクバックする

各クラウドセッションは claude.ai 上にトランスクリプト URL を持ち、セッションは `CLAUDE_CODE_REMOTE_SESSION_ID` 環境変数から独自の ID を読み取ることができます。これを使用して、PR 本文、コミットメッセージ、Slack 投稿、または生成されたレポートに追跡可能なリンクを配置し、レビュアーがそれらを生成した実行を開くことができるようにします。

Claude がクラウドセッションで作成するコミットには `Claude-Session: <url>` git トレーラーが含まれ、PR 本文にはセッション URL が独自の行に含まれます。トレーラーと PR 本文リンクを省略するには、[`attribution.sessionUrl`](https://code.claude.com/docs/ja/settings-reference#attribution-sessionurl)を `false` に設定します。

Claude が投稿する Slack メッセージやレポートファイルなど、コミットまたは PR 以外のものにセッションリンクを含めるには、Claude に次のコマンドを実行させ、その出力を使用してください。このコマンドは環境変数の値の `cse_` プレフィックスをトランスクリプト URL が期待する `session_` プレフィックスに変換します：

```bash theme={null}
echo "https://claude.ai/code/${CLAUDE_CODE_REMOTE_SESSION_ID/#cse_/session_}"
```

### テストの実行、サービスの開始、パッケージの追加

セッション VM へのシェルアクセスは取得できません。Claude がすべてのコマンドを実行するため、このセクションのタスクをプロンプトでリクエストとして表現してください。

#### テストの実行

Claude はタスクに取り組む際にテストを実行します。プロンプトでリクエストしてください。例えば「`tests/` の失敗したテストを修正してください」または「各変更後に pytest を実行してください」。[事前にインストールされたツールチェーン](#installed-tools)に付属するテストランナー（pytest や cargo test など）は追加のセットアップなしで動作します。プロジェクトが依存関係として宣言するランナー（jest など）は依存関係と共にインストールされます。

#### サービスの開始

PostgreSQL と Redis は事前にインストールされていますが、デフォルトでは実行されていません。必要なものを開始するよう Claude に依頼してください。実行するコマンドは次のとおりです：

```bash theme={null}
service postgresql start
```

```bash theme={null}
service redis-server start
```

Docker はコンテナ化されたサービスを実行するために利用可能です。Claude に `docker compose up` を実行するよう依頼して、プロジェクトのサービスを開始してください。イメージをプルするためのネットワークアクセスは環境の[アクセスレベル](#access-levels)に従い、[信頼できるデフォルト](#default-allowed-domains)には Docker Hub および他の一般的なレジストリが含まれます。

イメージが大きいか遅い場合は、[セットアップスクリプト](#setup-scripts)に `docker compose pull` または `docker compose build` を追加してください。[環境キャッシュ](#environment-caching)はプルされたイメージを保持するため、各新しいセッションはディスク上にそれらを持ちます。キャッシュはファイルのみを保存し、実行中のプロセスは保存しないため、Claude は各セッションでコンテナを開始します。

#### パッケージの追加

事前にインストールされていないパッケージを追加するには、[セットアップスクリプト](#setup-scripts)を使用してください。[環境キャッシュ](#environment-caching)はスクリプトがインストールするものを保持するため、そこにインストールするパッケージは各セッションの開始時に利用可能で、毎回再インストールする必要はありません。セッション中に Claude にパッケージをインストールするよう依頼することもできますが、これらのインストールは他のセッションに引き継がれません。

### リソース制限

Anthropic ホスト環境のクラウドセッションは、時間とともに変わる可能性のある概算リソース上限で実行されます：

* 4 vCPU
* 16 GB の RAM
* 30 GB のディスク

VM は大規模なビルドジョブやメモリ集約的なテストなど、大幅により多くのメモリを必要とするタスクを停止する可能性があります。これらの制限を超えるワークロードの場合は、[Remote Control](https://code.claude.com/docs/ja/remote-control.md)を使用して Claude Code を独自のハードウェアで実行するか、組織が運用するコンピュートで[セルフホスト環境](https://code.claude.com/docs/ja/self-hosted-environments)でクラウドセッションを実行してください。

### 時間制限

Anthropic ホスト環境では、ビルド、インストール、テスト実行など、クラウドセッションでの長時間実行作業に対して、これらの時間制限が適用されます。各エントリは制限を定義するセクションにリンクしています。

* **Claude が実行するコマンド**：クラウド環境は独自のコマンドタイムアウトを設定しないため、Bash ツールのデフォルトが適用されます。Claude はデフォルトでフォアグラウンドコマンドを 2 分間待機し、最大 10 分間要求できます。

  コマンドが[タイムアウト](https://code.claude.com/docs/ja/tools-reference.md#timeout-and-output-limits)に達すると、Claude Code は `sleep` で始まるコマンドを除き、それを停止する代わりに[バックグラウンドに移動](https://code.claude.com/docs/ja/tools-reference.md#foreground-commands-that-move-to-the-background)します。この方法で移動されたコマンドは、Claude Code がそれを[バックグラウンド時間制限](https://code.claude.com/docs/ja/tools-reference.md#time-limit-for-background-commands)で停止する前に、最大 30 分間実行し続けることができます。`BASH_DEFAULT_TIMEOUT_MS` を `1800000` ミリ秒より上に設定すると、その制限とフォアグラウンドデフォルトの両方が長くなります。
* **SessionStart hooks**：Claude Code は、hook エントリで[`timeout`](https://code.claude.com/docs/ja/hooks#common-fields)（秒単位）を設定しない限り、600 秒後に `command` hook をキャンセルします。Claude Code は[`async: true`](https://code.claude.com/docs/ja/hooks#run-hooks-in-the-background)で実行する hook に対してタイムアウトを適用しません。
* **セットアップスクリプト**：約 5 分以上かかるスクリプトはキャッシュされません。[スクリプト要件](#script-requirements)は、その制限内に留まる方法をカバーしています。
* **アイドルセッション**：数分間アクティビティがない場合、セッションの VM はファイルが保存された状態で一時停止され、一時停止された VM は後で回収される可能性があります。[環境変数の設定](#set-environment-variables)は、各ケースでセッションが何を取得するかについて説明し、[Environment expired](https://code.claude.com/docs/ja/claude-code-on-the-web.md#environment-expired)は VM が回収されたセッションを再度開く方法をカバーしています。

環境のセッションのコマンドタイムアウトを上げるには、[`BASH_DEFAULT_TIMEOUT_MS` と `BASH_MAX_TIMEOUT_MS`](https://code.claude.com/docs/ja/env-vars#variables)をその[環境変数](#set-environment-variables)に追加してください。どちらもミリ秒を取ります。例えば、`BASH_DEFAULT_TIMEOUT_MS=600000` は 10 分をデフォルトにします。

## セットアップスクリプト

セットアップスクリプトは、新しいクラウドセッションが開始されるときに実行される Bash スクリプトです。Claude Code が起動する前です。セットアップスクリプトを使用して、依存関係をインストールし、ツールを設定し、またはセッションが必要とするプリインストールされていないものをフェッチします。

スクリプトは Ubuntu 24.04 上で root として実行されるため、`apt install` およびほとんどの言語パッケージマネージャーが機能します。

### セットアップスクリプトを追加する

自分の環境にセットアップスクリプトを追加するには、スクリプトを入力または貼り付けるか、`setup.sh` などのテキストファイルを読み込みます。[環境を追加または編集](#configure-your-environment) して、**Setup script** 行を選択します。開いたボックスにスクリプトを入力するか、**Choose file** を選択して、ボックスの内容を最大 64 KB のファイルのテキストに置き換えます。その後、**Add environment** または **Save changes** を選択します。

この例は、プリインストールされていない [ShellCheck](https://www.shellcheck.net/) をインストールします。

```bash theme={null}
#!/bin/bash
apt update && apt install -y shellcheck
```

### スクリプト要件

セットアップスクリプトには、対応する 4 つの制約があります。

* **ゼロで終了**：スクリプトがゼロ以外で終了する場合、セッションは開始に失敗します。非重要なコマンドに `|| true` を追加して、一時的なインストール失敗がセッションをブロックしないようにします。
* **5 分以内に完了**：スクリプトの総実行時間を約 5 分以内に保つため、[環境キャッシュ](#environment-caching) をビルドできます。セットアップが 5 分以上かかる場合、環境はキャッシュされません。独立したインストールを `&` と `wait` で並列実行し、フィットしない単一ダウンロードを [SessionStart フック](#setup-scripts-vs-sessionstart-hooks) に移動して、バックグラウンドで起動します。新しいセッションがセットアップ中にハングまたはタイムアウトする場合は、[新しいセッションがセットアップ中にハングまたはタイムアウトする](https://code.claude.com/docs/ja/web-quickstart.md#new-sessions-hang-or-time-out-during-setup) を参照してください。
* **インストール用のネットワークアクセス**：パッケージインストールはレジストリに到達する必要があります。デフォルトの **Trusted** レベルは npm、PyPI、RubyGems、crates.io を含む [一般的なパッケージレジストリ](#default-allowed-domains) をカバーします。**None** ネットワークアクセスでは、インストールは失敗します。
* **環境の変数はまだ設定されていない**：スクリプトは、セッションが環境の [環境変数](#set-environment-variables) を設定する前に実行されます。スクリプトが必要とする値は、スクリプト自体で設定してください。

### 環境キャッシング

セットアップスクリプトは、環境でセッションを開始する最初の時間に実行されます。セットアップが [約 5 分以内](#script-requirements) に完了すると、Anthropic はファイルシステムをスナップショットし、そのスナップショットを後のセッションの開始点として再利用します。新しいセッションはディスク上に既に依存関係、ツール、Docker イメージを持ち、セットアップスクリプトステップをスキップします。これにより、スクリプトが大規模なツールチェーンをインストールしたりコンテナイメージをプルしたりする場合でも、スタートアップが高速に保たれます。セットアップが約 5 分以上かかる場合、環境はキャッシュされません。

キャッシュはファイルシステムスナップショットであるため、セットアップスクリプトがディスクに書き込むものを保持し、実行中のみのものを失います。インストールするパッケージ、プルする Docker イメージ、書き込むファイルはすべて引き継がれます。スクリプトが開始したデータベース、`docker compose up` スタック、またはその他のバックグラウンドプロセスは引き継がれません。これらはセッションごとに Claude に依頼するか、[SessionStart フック](#setup-scripts-vs-sessionstart-hooks) で開始します。

セットアップスクリプトは、環境のセットアップスクリプトまたは許可されたネットワークホストを変更するとき、およびキャッシュが約 7 日後に有効期限に達するときに再度実行され、キャッシュを再構築します。Anthropic ホスト環境では、セッションの VM が [アイドル後に復元](#set-environment-variables) されるときに、セットアップスクリプトは実行されません。そのため、スクリプトへの変更は、その VM が [回収](https://code.claude.com/docs/ja/claude-code-on-the-web.md#environment-expired) されて再構築されるときにのみ既存のセッションに到達します。変更をすぐに適用するには、セッションでコマンドを実行するか、新しいセッションを開始します。

キャッシングを有効にするか、スナップショットを自分で管理する必要はありません。

### セットアップスクリプト対 SessionStart フック

セットアップスクリプトを使用して VM 自体をプロビジョニングします。[プリインストール](#installed-tools) されていないツールチェーンと CLI ツール。[SessionStart フック](https://code.claude.com/docs/ja/hooks.md#sessionstart) をプロジェクトセットアップに使用します。クラウドとローカルで実行する必要があります。`npm install` などです。

セットアップスクリプトと SessionStart フックは、クラウドセッションが開始するときに固定順序で実行されます。テーブルは、設定場所、実行時期、実行場所を比較しています。

| | セットアップスクリプト | SessionStart フック |
| - | - | - |
| **設定場所** | [claude.ai/code](https://claude.ai/code) の環境ダイアログ、[共有環境](#organization-shared-environments) の **クラウド環境** 管理ページ | [設定ファイル](https://code.claude.com/docs/ja/settings.md#where-settings-live)（リポジトリの `.claude/settings.json` など）。[セットアップから引き継がれるもの](#what-carries-over-from-your-setup) を参照して、どのファイルがクラウドセッションに到達するかを確認してください |
| **実行時期** | Claude Code が起動する前に、[キャッシュされた環境](#environment-caching) が存在する場合はスキップ | Claude Code が起動した後、再開を含むすべてのセッションで |
| **実行場所** | クラウドセッションのみ | ローカルとクラウドセッション |

ユーザーレベルの `~/.claude/settings.json` に SessionStart フックがある場合、クラウドではそれらを期待しないでください。ユーザーレベルの設定はマシンに留まります。どの他のフックが実行されるかは、セッションが実行される場所によって異なります。

* **Anthropic ホスト環境**：Claude Code は組織の [サーバー管理設定](https://code.claude.com/docs/ja/server-managed-settings.md) からフックを実行し、[プロジェクト](https://code.claude.com/docs/ja/claude-projects.md#what-threads-pick-up-from-your-repositories) のスレッド以外ではリポジトリからもフックを実行します。[Claude Tag](https://claude.com/docs/claude-tag/overview) セッションはサーバー管理設定を受け取らないため、サーバー管理設定からのフックはそこで実行されません。
* **[セルフホスト環境](https://code.claude.com/docs/ja/self-hosted-environments-configuration.md#permissions-and-tool-approval)**：Claude Code はオペレーターがランナーホストの `~/.claude/` からシードしたフックも実行し、ランナーイメージの管理設定ファイルのフック（そのファイルが [Claude Code が適用する管理ソース](https://code.claude.com/docs/ja/managed-settings.md#how-claude-code-combines-managed-sources) のいずれかである場合）。

### SessionStart フックで依存関係をインストールする

[プロジェクト](https://code.claude.com/docs/ja/claude-projects.md#what-threads-pick-up-from-your-repositories) のスレッド以外のクラウドセッションでのみ依存関係をインストールするには、SessionStart フックを実行場所をチェックするスクリプトと組み合わせます。

まず、SessionStart フックをリポジトリの `.claude/settings.json` に追加します。この設定は、セッションが開始または再開されるたびに Claude Code に `scripts/install_pkgs.sh` をリポジトリから実行するよう指示します。

```json theme={null}
{
  "hooks": {
    "SessionStart": [
      {
        "matcher": "startup|resume",
        "hooks": [
          {
            "type": "command",
            "command": "bash \"$CLAUDE_PROJECT_DIR\"/scripts/install_pkgs.sh"
          }
        ]
      }
    ]
  }
}
```

`matcher` はフックを `startup` および `resume` イベントに制限し、`$CLAUDE_PROJECT_DIR` はリポジトリルートに解決されるため、フックはセッションの作業ディレクトリに関係なくスクリプトを見つけます。

次に、`scripts/install_pkgs.sh` でスクリプトを作成します。クラウドの外では直ちに終了し、依存関係をインストールします。`package.json`、`package-lock.json`、およびスクリプト自体が前回のインストール成功以降変更されていない間は、`npm install` をスキップします。

```bash theme={null}
#!/bin/bash

if [ "$CLAUDE_CODE_REMOTE" != "true" ]; then
  exit 0
fi

cd "$CLAUDE_PROJECT_DIR" || exit 1
hashes=node_modules/.install_pkgs.sha256

if ! sha256sum --check --status "$hashes" 2>/dev/null; then
  # Delete the old hashes first, so a failed install runs again next time
  rm -f "$hashes"
  if npm install; then
    sha256sum scripts/install_pkgs.sh package.json package-lock.json > "$hashes" || rm -f "$hashes"
  fi
fi

# pip skips requirements that are already satisfied
pip install -r requirements.txt
exit 0
```

`CLAUDE_CODE_REMOTE` チェックは、インストールをクラウドセッションにスコープするものです。セッション VM の環境は変数を `true` として持ち、ローカルでは決して `true` ではないため、ラップトップではスクリプトは何もインストールする前に終了します。

`npm install` が成功したことを確認するには、クラウドセッションを開始し、Claude に `node_modules/.install_pkgs.sha256` を表示するよう依頼します。このファイルには、3 つのファイルそれぞれのハッシュが記載されています。ファイルが存在しない場合は、Claude に `npm install` を実行してエラーを報告するよう依頼してください。

> [!NOTE]
>
> `npm install` がワークスペースの `package.json`、`.npmrc`、`postinstall` スクリプトの入力など、他のファイルを読み込む場合は、ハッシュを保存する `sha256sum` コマンドにそれらを追加してください。そうしないと、それらのファイルのいずれかが変更された後も古いパッケージが残ったままになります。

#### クラウドセッションの制限

SessionStart フックはクラウドでローカルと同じように動作しますが、これらの注意事項があります。

* **セッションごとに 1 つのリポジトリ**：Anthropic ホスト環境では、複数のリポジトリを持つセッションはどのリポジトリの `.claude/settings.json` からもフックをロードしないため、そこで定義した SessionStart フックは実行されません。これらのセッションの依存関係は、代わりに [セットアップスクリプト](#setup-scripts) でインストールしてください。セルフホスト環境については、[どのリポジトリの設定が適用されるか](https://code.claude.com/docs/ja/self-hosted-environments-configuration.md#repository-settings-in-sessions-with-several-repositories) を参照してください。
* **プロジェクトのクラウドスレッドでは実行されない**：[プロジェクト](https://code.claude.com/docs/ja/claude-projects.md#what-threads-pick-up-from-your-repositories) 内のクラウドスレッドは、リポジトリの数にかかわらず、リポジトリの `.claude/settings.json` からフックを実行しません。Anthropic ホスト環境では、スレッドの依存関係は [セットアップスクリプト](#setup-scripts) でインストールしてください。セルフホスト環境では、代わりに [ランナーホストの設定](https://code.claude.com/docs/ja/self-hosted-environments-configuration.md#repository-settings-in-sessions-with-several-repositories) にあるフックを使用してください。
* **クラウドのみのスコープなし**：フックはローカルとクラウドセッションの両方で実行されます。ローカル実行をスキップするには、[依存関係インストールスクリプト](#install-dependencies-with-a-sessionstart-hook) のように `CLAUDE_CODE_REMOTE` 環境変数が `true` でない限り早期に終了します。
* **ネットワークアクセスが必要**：インストールコマンドはパッケージレジストリに到達する必要があります。環境が **None** ネットワークアクセスを使用する場合、これらのフックは失敗します。**Trusted** の下の [デフォルト許可リスト](#default-allowed-domains) は npm、PyPI、RubyGems、crates.io をカバーします。
* **プロキシ互換性**：Anthropic ホスト環境では、すべての送信トラフィックは [セキュリティプロキシ](#security-proxy) を通じて渡されます。一部のパッケージマネージャーはこのプロキシで正しく機能しません。Bun は既知の例です。[セルフホスト環境](https://code.claude.com/docs/ja/self-hosted-environments-deploy.md#default-deny-egress) では、送信トラフィックは代わりに独自のネットワーク境界を通じて行きます。
* **スタートアップレイテンシを追加**：フックはセッションが開始または再開されるたびに実行されます。[環境キャッシング](#environment-caching) の恩恵を受けるセットアップスクリプトとは異なります。[依存関係インストールスクリプト](#install-dependencies-with-a-sessionstart-hook) のように、既に完了している作業をスキップすることで、インストールスクリプトを高速に保ちます。

ベースイメージをカスタマイズするには、セットアップスクリプトを使用して [提供されたイメージ](#installed-tools) の上にインストールするか、`docker compose` で Claude と一緒にコンテナとして独自のイメージを実行します。ベースイメージ全体を置き換えることはまだサポートされていません。

## デフォルト許可ドメイン

**Trusted** ネットワークアクセスでは、セッションはデフォルトで次のドメインに到達できます。`*` でマークされたドメインはワイルドカードサブドメインマッチングを示すため、`*.gcr.io` は `gcr.io` のすべてのサブドメインを許可します。

> [accordion] Anthropic サービス
>
> * api.anthropic.com
> * docs.claude.com
> * platform.claude.com
> * code.claude.com
> * claude.ai
> * claude.com
> * support.claude.com
> * anthropic.com
> * [www.anthropic.com](http://www.anthropic.com)

> [accordion] バージョン管理
>
> * github.com
> * [www.github.com](http://www.github.com)
> * api.github.com
> * npm.pkg.github.com
> * raw\.githubusercontent.com
> * pkg-npm.githubusercontent.com
> * objects.githubusercontent.com
> * release-assets.githubusercontent.com
> * codeload.github.com
> * avatars.githubusercontent.com
> * camo.githubusercontent.com
> * gist.github.com
> * gitlab.com
> * [www.gitlab.com](http://www.gitlab.com)
> * registry.gitlab.com
> * bitbucket.org
> * [www.bitbucket.org](http://www.bitbucket.org)
> * api.bitbucket.org

> [accordion] コンテナレジストリ
>
> * registry-1.docker.io
> * auth.docker.io
> * index.docker.io
> * hub.docker.com
> * [www.docker.com](http://www.docker.com)
> * production.cloudflare.docker.com
> * production.cloudfront.docker.com
> * download.docker.com
> * gcr.io
> * \*.gcr.io
> * ghcr.io
> * mcr.microsoft.com
> * \*.data.mcr.microsoft.com
> * public.ecr.aws

> [accordion] クラウドプラットフォーム
>
> * cloud.google.com
> * accounts.google.com
> * gcloud.google.com
> * \*.googleapis.com
> * storage.googleapis.com
> * compute.googleapis.com
> * container.googleapis.com
> * azure.com
> * portal.azure.com
> * microsoft.com
> * [www.microsoft.com](http://www.microsoft.com)
> * \*.microsoftonline.com
> * packages.microsoft.com
> * dotnet.microsoft.com
> * dot.net
> * visualstudio.com
> * dev.azure.com
> * \*.amazonaws.com
> * \*.api.aws
> * oracle.com
> * [www.oracle.com](http://www.oracle.com)
> * java.com
> * [www.java.com](http://www.java.com)
> * java.net
> * [www.java.net](http://www.java.net)
> * download.oracle.com
> * yum.oracle.com
> * \*.r2.cloudflarestorage.com

> [accordion] JavaScript と Node パッケージマネージャー
>
> * registry.npmjs.org
> * [www.npmjs.com](http://www.npmjs.com)
> * [www.npmjs.org](http://www.npmjs.org)
> * npmjs.com
> * npmjs.org
> * yarnpkg.com
> * registry.yarnpkg.com
> * jsr.io
> * npm.jsr.io

> [accordion] Python パッケージマネージャー
>
> * pypi.org
> * [www.pypi.org](http://www.pypi.org)
> * files.pythonhosted.org
> * pythonhosted.org
> * test.pypi.org
> * pypi.python.org
> * pypa.io
> * [www.pypa.io](http://www.pypa.io)

> [accordion] Ruby パッケージマネージャー
>
> * rubygems.org
> * [www.rubygems.org](http://www.rubygems.org)
> * api.rubygems.org
> * index.rubygems.org
> * ruby-lang.org
> * [www.ruby-lang.org](http://www.ruby-lang.org)
> * rubyforge.org
> * [www.rubyforge.org](http://www.rubyforge.org)
> * rubyonrails.org
> * [www.rubyonrails.org](http://www.rubyonrails.org)
> * rvm.io
> * get.rvm.io

> [accordion] Rust パッケージマネージャー
>
> * crates.io
> * [www.crates.io](http://www.crates.io)
> * index.crates.io
> * static.crates.io
> * rustup.rs
> * static.rust-lang.org
> * [www.rust-lang.org](http://www.rust-lang.org)

> [accordion] Go パッケージマネージャー
>
> * proxy.golang.org
> * sum.golang.org
> * index.golang.org
> * golang.org
> * [www.golang.org](http://www.golang.org)
> * goproxy.io
> * pkg.go.dev

> [accordion] JVM パッケージマネージャー
>
> * maven.org
> * repo.maven.org
> * central.maven.org
> * repo1.maven.org
> * repo.maven.apache.org
> * maven.google.com
> * jcenter.bintray.com
> * gradle.org
> * [www.gradle.org](http://www.gradle.org)
> * services.gradle.org
> * plugins.gradle.org
> * plugins-artifacts.gradle.org
> * kotlinlang.org
> * [www.kotlinlang.org](http://www.kotlinlang.org)
> * spring.io
> * repo.spring.io

> [accordion] その他のパッケージマネージャー
>
> * packagist.org（PHP Composer）
> * [www.packagist.org](http://www.packagist.org)
> * repo.packagist.org
> * nuget.org（.NET NuGet）
> * [www.nuget.org](http://www.nuget.org)
> * api.nuget.org
> * pub.dev（Dart/Flutter）
> * api.pub.dev
> * hex.pm（Elixir/Erlang）
> * [www.hex.pm](http://www.hex.pm)
> * cpan.org（Perl CPAN）
> * [www.cpan.org](http://www.cpan.org)
> * metacpan.org
> * [www.metacpan.org](http://www.metacpan.org)
> * api.metacpan.org
> * cocoapods.org（iOS/macOS）
> * [www.cocoapods.org](http://www.cocoapods.org)
> * cdn.cocoapods.org
> * haskell.org
> * [www.haskell.org](http://www.haskell.org)
> * hackage.haskell.org
> * swift.org
> * [www.swift.org](http://www.swift.org)

> [accordion] Linux ディストリビューション
>
> * archive.ubuntu.com
> * security.ubuntu.com
> * ubuntu.com
> * [www.ubuntu.com](http://www.ubuntu.com)
> * \*.ubuntu.com
> * ppa.launchpad.net
> * launchpad.net
> * [www.launchpad.net](http://www.launchpad.net)
> * \*.nixos.org

> [accordion] 開発ツールとプラットフォーム
>
> * dl.k8s.io（Kubernetes）
> * pkgs.k8s.io
> * k8s.io
> * [www.k8s.io](http://www.k8s.io)
> * releases.hashicorp.com（HashiCorp）
> * apt.releases.hashicorp.com
> * rpm.releases.hashicorp.com
> * archive.releases.hashicorp.com
> * hashicorp.com
> * [www.hashicorp.com](http://www.hashicorp.com)
> * repo.anaconda.com（Anaconda/Conda）
> * conda.anaconda.org
> * anaconda.org
> * [www.anaconda.com](http://www.anaconda.com)
> * anaconda.com
> * continuum.io
> * apache.org（Apache）
> * [www.apache.org](http://www.apache.org)
> * archive.apache.org
> * downloads.apache.org
> * eclipse.org（Eclipse）
> * [www.eclipse.org](http://www.eclipse.org)
> * download.eclipse.org
> * nodejs.org（Node.js）
> * [www.nodejs.org](http://www.nodejs.org)
> * developer.apple.com
> * developer.android.com
> * pkg.stainless.com
> * binaries.prisma.sh

> [accordion] クラウドサービスと監視
>
> * http-intake.logs.datadoghq.com
> * \*.datadoghq.com
> * \*.datadoghq.eu
> * api.honeycomb.io

> [accordion] コンテンツ配信とミラー
>
> * sourceforge.net
> * \*.sourceforge.net
> * packagecloud.io
> * \*.packagecloud.io
> * fonts.googleapis.com
> * fonts.gstatic.com

> [accordion] スキーマと設定
>
> * json-schema.org
> * [www.json-schema.org](http://www.json-schema.org)
> * json.schemastore.org
> * [www.schemastore.org](http://www.schemastore.org)

> [accordion] Model Context Protocol
>
> * \*.modelcontextprotocol.io

## 関連リソース

* [Cloud sessions reference](https://code.claude.com/docs/ja/claude-code-on-the-web.md)：クラウドセッションを開始、管理、共有します
* [Cloud sessions quickstart](https://code.claude.com/docs/ja/web-quickstart.md)：GitHub を接続して最初のクラウドセッションを開始します
* [Claude Tag](https://claude.com/docs/claude-tag/overview)：Claude が Slack から開始するセッションは同じ環境で実行されます
* [Cloud scheduled tasks](https://code.claude.com/docs/ja/routines.md)：スケジュール実行は同じ環境とネットワークアクセスレベルを使用します
* [Remote Control](https://code.claude.com/docs/ja/remote-control.md)：代わりに独自のマシンのネットワークとファイルでセッションを実行します
* [Self-hosted environments](https://code.claude.com/docs/ja/self-hosted-environments)：組織独自のインフラストラクチャでクラウドセッションを実行します
* [SessionStart hooks](https://code.claude.com/docs/ja/hooks.md#sessionstart)：ローカルとクラウドセッションで実行されるリポジトリコミットセットアップ
* [Server-managed settings](https://code.claude.com/docs/ja/server-managed-settings.md)：管理コンソールから配信される組織ポリシー
