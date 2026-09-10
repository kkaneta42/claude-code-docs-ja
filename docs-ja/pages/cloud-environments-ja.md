> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# クラウド環境を設定する

> Claude Code クラウドセッション用のクラウド環境を設定します。ネットワークアクセスレベル、環境変数、セットアップスクリプト、環境キャッシュを構成できます。

<Note>
  クラウド環境には [Web 上の Claude Code](/docs/ja/claude-code-on-the-web) が必要です。これは Pro、Max、Team ユーザーの研究プレビュー版であり、[プレミアムシートまたは Chat + Claude Code シートを持つ](https://support.claude.com/en/articles/11845131-use-claude-code-with-your-team-or-enterprise-plan) Enterprise ユーザー向けです。
</Note>

各 [クラウドセッション](/docs/ja/claude-code-on-the-web) はクラウド環境で実行されます。環境を設定して [ネットワークアクセス](#access-levels) を許可または拒否し、セッション用に [環境変数を設定](#set-environment-variables) し、Pro および Max プランで [API 認証情報](#add-api-credentials) を保存してセッションが認証情報を見ずに使用でき、Claude が作業を開始する前に [セットアップスクリプト](#setup-scripts) を実行できます。

同じ環境は、クラウドセッションを開始する場所に関係なく適用されます。[Web 上の Claude Code](/docs/ja/claude-code-on-the-web)、[`claude --cloud`](/docs/ja/claude-code-on-the-web#from-terminal-to-web) を使用したターミナル、[Claude Tag](https://claude.com/docs/claude-tag/overview)、[ルーチン](/docs/ja/routines)、[Claude モバイルアプリ](/docs/ja/mobile)、[Desktop アプリ](/docs/ja/desktop) です。これらの各サーフェスは [セルフホスト環境](/docs/ja/self-hosted-environments) にもルーティングできます。[利用可能性と制限](/docs/ja/self-hosted-environments#availability-and-limitations) は、Claude Tag セッションがセルフホスト環境で実行される場合に Claude がまだ使用できないものをカバーしています。

<Info>
  [Remote Control](/docs/ja/remote-control) セッションは Web とモバイルインターフェイスを自分のマシン上のセッションに接続します。これはクラウド環境ではなく、自分のマシンのネットワークとファイルを使用します。Claude Tag チャネルセッションは [共有環境](#organization-shared-environments) または [セルフホスト環境](/docs/ja/self-hosted-environments) のいずれかの組織レベルの環境のみを使用します。
</Info>

<h2 id="the-default-environment">
  Default 環境
</h2>

オンボーディングが **Default** 環境をセットアップします。どのように設定されるかは、オンボーディングの場所によって異なります。

* **`/web-setup` などの CLI フロー**：**Default** を作成します
* **Pro および Max での Web オンボーディング**：**Default** を作成します
* **Team および Enterprise での Web オンボーディング**：オーナーが [Quick web setup](/docs/ja/claude-code-on-the-web#github-authentication-options) をオンにしていない限り、**最初のクラウド環境を作成** フォームを表示します。フォームのデフォルトを保持して **作成して完了** をクリックして、同じ **Default** 環境を取得します

**Default** は独自の設定を持ちません。

* [**Trusted** ネットワークアクセス](#access-levels)：セッションはパッケージレジストリおよび他の [許可リストドメイン](#default-allowed-domains) に到達でき、セッションのネットワークを通じて他には何も到達できません。
* その他の設定なし：**Default** は環境変数またはセットアップスクリプトを定義しないため、セッションは [プリインストールされたツール](#installed-tools) だけで開始されます。

**Default** のみが利用可能な場合、すべてのセッションはそれで実行されます。複数の環境がある場合、セッションはサーフェスごとに 1 つを選択します。

* Web、Desktop アプリ、モバイルアプリでは、セッションは [セレクタ](#configure-your-environment) に表示される環境を使用します。オーナーが設定した [組織のデフォルト](#organization-shared-environments) は、選択していない場合にセレクションを埋めます。
* CLI からは、Claude Code は [`/remote-env` の選択](#select-an-environment-from-the-cli) を使用するか、リストに 1 つある場合は Anthropic ホスト環境にフォールバックし、そうでない場合はブリッジ環境ではないリスト内の最初の環境にフォールバックします。ブリッジ環境は、クラウド環境ではなく独自のマシンを表すために [Remote Control](/docs/ja/remote-control) が登録するエントリです。[セルフホスト環境](/docs/ja/self-hosted-environments) の場合、[セッションをディスパッチする](/docs/ja/self-hosted-environments-testing#run-the-test-loop) ときに `ccpool_` ID を持つ `--environment <environment-id>` を渡すと、その呼び出しの `/remote-env` の選択とフォールバックをオーバーライドします。Claude Code は Anthropic ホスト `env_` ID をフラグに渡されたものを拒否するため、それらをターゲットにするには `/remote-env` を使用します。フラグには Claude Code v2.1.224 以降が必要です。

デフォルトでは不十分な場合は環境を設定します。Claude が [デフォルト許可リスト](#default-allowed-domains) 外のドメインに到達する必要がある場合、セッション用に環境変数を設定する必要がある場合、または作業を開始する前に依存関係をインストールする必要がある場合です。

<h2 id="configure-your-environment">
  環境を設定する
</h2>

[claude.ai/code](https://claude.ai/code) の環境セレクターから環境を作成、編集、アーカイブできます。このセレクターには [ウェブオンボーディング](/docs/ja/web-quickstart) の後にアクセスできます。作成した環境はアカウントに個人的なものです。[共有環境](#organization-shared-environments) はオーナーが作成したものが同じセレクターに表示されます。設定なしで利用可能なものについては [インストール済みツール](#installed-tools) を参照してください。

<Steps>
  <Step title="環境セレクターを開く">
    [claude.ai/code](https://claude.ai/code) で、メッセージボックスの上の行にある現在の環境名を表示するクラウドアイコンを選択します。セレクターの設定ページや直接 URL はありません。

    <Frame>
      <img src="https://mintcdn.com/claude-code/ZFId6l95856c5LSw/images/cloud-environment-selector.png?fit=max&auto=format&n=ZFId6l95856c5LSw&q=85&s=cc2813a5664519eaf5a89d793ce5af26" alt="claude.ai/code のメッセージボックスの上に開いた環境セレクター。環境名 Default を表示するクラウドボタンがメッセージボックスの上の行にあります。開いたメニューには Download と Desktop only ラベルが付いた Local 行、Default 環境がチェックマークで選択され、ホバー時に設定ギアアイコンが表示される Cloud セクション、クラウド環境を追加するオプション、セットアップ手順を含む Remote Control セクションが表示されます。" width="1672" height="682" data-path="images/cloud-environment-selector.png" />
    </Frame>
  </Step>

  <Step title="環境を追加または編集する">
    **クラウド環境を追加** を選択するか、既存の環境にホバーして右側に表示される設定アイコンを選択します。ダイアログには名前、ネットワークアクセスレベル、環境変数、セットアップスクリプトが含まれます。Pro または Max プランで既存のクラウド環境を編集する場合、ダイアログには [API 認証情報](#add-api-credentials) も含まれます。

    <Frame>
      <img src="https://mintcdn.com/claude-code/ZFId6l95856c5LSw/images/cloud-environment-dialog.png?fit=max&auto=format&n=ZFId6l95856c5LSw&q=85&s=30d4478b31d1f879f7ee287ddab32505" alt="新しいクラウド環境ダイアログ。プレースホルダー Default を持つ Name フィールド、ネットワークポリシーとアクセスレベルへのリンク付きで Trusted に設定された Network access セレクター、.env 形式のプレースホルダーテキストを表示し、値は環境を使用する誰もが見ることができるというメモが付いた Environment variables ボックス、新しいセッションが開始され Claude Code が起動する前に実行される Bash スクリプトとして説明されている Setup script ボックス、および Cancel と Create environment ボタン。" width="874" height="1372" data-path="images/cloud-environment-dialog.png" />
    </Frame>
  </Step>
</Steps>

<h3 id="set-environment-variables">
  環境変数を設定する
</h3>

環境変数は `.env` 形式を使用し、1 行に 1 つの `KEY=value` ペアです。プレーンな値は引用符が不要で、一致するペアで値を引用符で囲むと、引用符は値の一部にはなりません。複数行にまたがる値または `#` を含む値を引用符で囲みます。引用符なしの値では、`#` はコメントを開始し、行の残りは削除されます。

次の例は 3 つの変数を定義しています。

```text theme={null}
NODE_ENV=development
LOG_LEVEL=debug
DATABASE_URL=postgres://localhost:5432/myapp
```

各セッションは起動時に環境の値を 1 回コピーして、Claude が実行するコマンドが読み取ることができる通常の環境変数にします。実行中のセッションは設定を再度読み込まないため、変数を編集または追加すると、その後に開始するセッションに影響します。既に実行中のセッションは開始時の値を保持します。

Web 上の Claude Code は、セッションを開始するときに独自にいくつかの変数を設定します。[`CLAUDE_AUTOCOMPACT_PCT_OVERRIDE`](/docs/ja/claude-code-on-the-web#manage-context) の場合、Web 上の Claude Code が設定する値は、ここで追加したものをオーバーライドするため、ここでそのキーを追加しても効果がありません。

環境を使用する誰もが値を読み取ることができます。Pro および Max プランでは、エージェントプロキシがリクエストに接続できるキーの場合は [API 認証情報](#add-api-credentials) を代わりに使用します。[認証情報を取得しないリクエスト](#requests-that-never-get-the-credential) はそこにリストされています。

<h3 id="add-api-credentials">
  API 認証情報を追加する
</h3>

API 認証情報は、クラウド環境に保存する API キーまたはトークンであり、Claude はキーを見ずに環境内のセッションからそのAPI を呼び出すことができます。Anthropic のエージェントプロキシは、各リクエストがセッションの VM を離れた後、リストしたホストへのリクエストにキーを追加します。キーは Claude、実行するコマンド、またはセッションの環境変数に到達しません。

API 認証情報は Pro および Max プランで利用可能です。Team または Enterprise プランではまだ利用できないため、**API credentials** セクションはこれらのプランの環境ダイアログに表示されません。

<h4 id="requirements">
  要件
</h4>

これらのうち 2 つは認証情報を追加できるかどうかを決定し、2 つは追加後にエージェントプロキシがそれを使用できるかどうかを決定します。

* **ロール**：claude.ai 組織の組織管理者ロール
  * Team および Enterprise では、オーナーがそれを保持し、管理者は保持しません
  * Pro および Max では、独自の組織でそれを保持します
  * これがない場合、独自の環境でも認証情報リストの代わりにメモが表示されます。オーナーに認証情報を共有環境に追加してセッションをそこで実行するよう依頼します
* **環境タイプ**：既に存在する Anthropic ホスト クラウド環境。[セルフホスト環境](/docs/ja/self-hosted-environments) には API 認証情報がありません
* **API 到達可能性**：API はインターネットからの接続を受け入れます。リクエストは Anthropic のネットワークから離れるためです
* **暗号化キー**：組織がカスタマー管理暗号化キーを使用する場合、認証情報を保存できません

<h4 id="add-a-credential">
  認証情報を追加する
</h4>

既に存在する環境のエディターから一度に 1 つの認証情報を追加します。新しい環境のダイアログはそれらを提供しません。編集もありません。認証情報のホストまたは値を変更するには、削除して再度追加します。

<Steps>
  <Step title="環境の API 認証情報を開く">
    [claude.ai/code](https://claude.ai/code) で [編集用に環境を開きます](#configure-your-environment)。**クラウド環境を更新** ダイアログで、**環境変数** の下の **API credentials** を見つけます。環境に既にある認証情報が表示され、それが適用されるホストが表示されます。
  </Step>

  <Step title="認証情報を追加する">
    **認証情報を追加** を選択してフォームに入力します。デフォルトの **認証情報タイプ** の **Bearer** を保持します。これはリクエストヘッダーで移動する API キーの場合であり、これらのフィールドに入力します。

    * **名前**：認証情報のラベル（例：`Internal billing API`）
    * **許可されたウェブサイト**：API のホスト（例：`api.example.com`）。先頭の `*.` はすべてのサブドメインと一致します
    * **カスタムヘッダー**：キーを運ぶヘッダーの 1 行。行は `Authorization` をヘッダーの **名前** として、`Bearer` を **プレフィックス** として開始します。キー自体を **値** として貼り付けます。`X-Api-Key` のようなベア値を取るヘッダーの場合、名前を変更してプレフィックスをクリアします

    別の方法で認証する API の場合、別の **認証情報タイプ** を選択します。リストは [Claude Tag](https://claude.com/docs/claude-tag/overview) が [接続](https://claude.com/docs/claude-tag/admins/add-connections) に提供するものと同じです。
  </Step>

  <Step title="認証情報を保存する">
    **接続** を選択します。認証情報はリストにホストと共に表示され、ダイアログの **変更を保存** ボタンなしで保存されます。保存後に値を再度表示することはできません。
  </Step>
</Steps>

認証情報が機能することを確認するには、環境でセッションを開始して、Claude に API を呼び出すよう依頼します。例えば `curl` を使用します。API はキーがリクエストにあるかのように応答し、キーはセッションの環境変数またはファイルに表示されません。リストが認証情報を **送信されていません** とマークしている場合、その下のメモは理由と対処方法を説明しています。ホストが正確に一致しないで重複する 2 つの認証情報はマーカーを取得しません。エージェントプロキシはそのうちの 1 つだけを送信します。

<h4 id="which-requests-get-the-credential">
  どのリクエストが認証情報を取得するか
</h4>

エージェントプロキシは、リクエストのホストがその認証情報にリストしたものと一致する場合、認証情報をリクエストに接続します。セッションは、環境の [ネットワークアクセスレベル](#access-levels) がそれ以外の場合は許可しない場合でも、これらのホストに到達できます。ただし [エージェントプロキシがスキップするホスト](#requests-that-never-get-the-credential) は除きます。認証情報は、削除するまで、それを開始した人に関係なく、環境で実行されるすべてのセッションに適用されます。

<h4 id="requests-that-never-get-the-credential">
  認証情報を取得しないリクエスト
</h4>

エージェントプロキシは、追加した認証情報をこれらのリクエストに接続しません。

* **GitHub**：[GitHub プロキシ](#github-proxy) は代わりに GitHub へのリクエストを認証するため、GitHub の API 認証情報は必要ありません
* **Anthropic API とパブリックパッケージレジストリ**：`api.anthropic.com`、`registry.npmjs.org`、`jsr.io`、`npm.jsr.io`、`pypi.org`、`files.pythonhosted.org`、`index.crates.io`、`proxy.golang.org` へのリクエストはエージェントプロキシを通じません
* **セットアップスクリプトリクエスト**：Claude Code は [セットアップスクリプト](#setup-scripts) が実行された後、起動時にエージェントプロキシに接続します

<h3 id="select-an-environment-from-the-cli">
  CLI から環境を選択する
</h3>

ターミナルで `/remote-env` を実行して、[`claude --cloud`](/docs/ja/claude-code-on-the-web#from-terminal-to-web) などの CLI から作成するクラウドセッションのデフォルト環境を選択します。コマンドは既存の環境のピッカーを開き、選択を [ユーザー設定](/docs/ja/settings#where-settings-live) の `remote.defaultEnvironmentId` キーに保存するため、より高い優先度の [設定レイヤー](/docs/ja/settings#settings-precedence) （リポジトリのプロジェクト設定など）で同じキーが設定されていない限り、マシン上のすべてのプロジェクトで変更するまで適用されます。

[セルフホスト環境](/docs/ja/self-hosted-environments) ID（`ccpool_...` の形式）は、より厳密なソースルールに従います。Claude Code がそれを尊重する設定レイヤーについては [`remote.defaultEnvironmentId`](/docs/ja/settings-reference#remote-defaultenvironmentid) を参照してください。

`/remote-env` はデフォルトのみを設定します。セッションを開始せず、環境を追加または編集することはできません。[claude.ai/code](https://claude.ai/code) で管理してください。

<h3 id="archive-an-environment">
  環境をアーカイブする
</h3>

環境をアーカイブするには、編集用に開いて **アーカイブ** を選択します。環境を削除することはできず、アーカイブのみできます。

アーカイブは新しいセッションに影響し、実行中のセッションには影響しません。

* 環境で既に実行中のセッションは引き続き機能します。
* 環境はセレクターと `/remote-env` から消えるため、新しいセッション用に選択できません。
* 環境の API 認証情報は実行中のセッションに接続されたままです。アーカイブする前に不要なものを削除します。
* アーカイブされた環境では、どのサーフェスでも新しいセッションを開始できません。環境が保存された [CLI デフォルト](#select-an-environment-from-the-cli) だった場合、Claude Code はリストに 1 つある場合は Anthropic ホスト環境で CLI クラウドセッションを開始し、そうでない場合はリスト内の最初の環境で [Remote Control ブリッジ環境](#the-default-environment) ではないものを開始します。[ルーチン](/docs/ja/routines#environments-and-network-access) など、環境で明示的に設定されたものは、その中で新しいセッションを開始できません。別の環境を指定してください。

<h3 id="organization-shared-environments">
  組織共有環境
</h3>

Team および Enterprise プランでは、オーナーは組織のすべてのメンバーと共有されるクラウド環境を作成できます。同じロールは **クラウド環境** 管理ページで他のすべてを管理します。[セルフホスト環境](/docs/ja/self-hosted-environments) を含みます。管理者ロールはページを開くことができません。ページを開くことができるロールの完全なリストは [サーバー管理設定を管理する](/docs/ja/server-managed-settings#access-control) ためのものです。共有環境は各メンバーの環境セレクターに個人的なものと一緒に表示されるため、チームは各メンバーが再作成する代わりに 1 つの設定で標準化できます。

[管理設定](https://claude.ai/admin-settings) の **クラウド環境** ページから共有環境を作成、編集、アーカイブします。共有環境は [claude.ai/code](https://claude.ai/code) の [環境セレクター](#configure-your-environment) からも開きます。オーナーはそこで編集できます。他のメンバーは読み取り専用で表示します。各共有環境には名前、[ネットワークアクセスレベル](#access-levels)、`.env` 形式の [環境変数](#set-environment-variables)、[セットアップスクリプト](#setup-scripts) があります。オーナーは [claude.ai/admin-settings/claude-code](https://claude.ai/admin-settings/claude-code) で組織の [デフォルト環境](#the-default-environment) を別途選択します。

すべてのメンバーのセッションが共有環境の変数を読み取るため、シークレットを含めないでください。[API 認証情報](#add-api-credentials)（セッションが読み取ることができないキーを提供）は Team または Enterprise プランではまだ利用できません。

<h3 id="set-the-environment-a-claude-tag-channel-uses">
  Claude Tag チャネルが使用する環境を設定する
</h3>

[Claude Tag](https://claude.com/docs/claude-tag/overview) チャネルでは、Claude はメンバーではなく組織の共有アイデンティティとして機能するため、チャネルセッションは組織レベルの環境のみを使用します。共有環境または [セルフホスト環境](/docs/ja/self-hosted-environments) のいずれかです。チャネルに [プリインストール](#installed-tools) されていない .NET などのツールチェーンを提供するには、オーナーは **クラウド環境** 管理ページから [共有環境](#organization-shared-environments) を作成し、[セットアップスクリプト](#setup-scripts) でそれをインストールできます。チャネルを環境に指定する 2 つの方法があります。

* [claude.ai/admin-settings/claude-code](https://claude.ai/admin-settings/claude-code) で共有またはセルフホスト環境を組織の [デフォルト環境](#the-default-environment) として設定します。
* Claude Tag 管理設定で [チャネルにピン留めします](https://claude.com/docs/claude-tag/admins/troubleshooting#channel-sessions-use-the-wrong-environment-or-can%E2%80%99t-find-one)。

<h2 id="network-access">
  ネットワークアクセス
</h2>

各環境は 1 つのネットワークアクセスレベルを設定し、セッションが行える送信接続を制御します。デフォルトレベルの **Trusted** はパッケージレジストリおよび他の [許可リストドメイン](#default-allowed-domains) を許可します。**Custom** は独自のドメインリストを取ります。

環境のネットワークアクセスを変更するには、[編集用に開いて](#configure-your-environment) ダイアログの **Network access** セレクタを使用します。セレクタを開くクラウドアイコンは、[Default 環境](#the-default-environment) の下にリストされたアプリサーフェスおよび [ルーチンエディタ](/docs/ja/routines#environments-and-network-access) に表示されます。個人環境は claude.ai アカウント設定に別のページを持ちません。

<Note>
  セッションまたはルーチンで有効にする MCP コネクタは、コネクタホストを **Allowed domains** に追加しなくても機能します。コネクタトラフィックはセッションのネットワークではなく Anthropic のサーバーを通じて移動するためです。コネクタはセッションごとまたはルーチンごとに設定します。Claude が到達できるツールを制限するために不要なものを削除します。これは [セキュリティと分離](/docs/ja/claude-code-on-the-web#security-and-isolation) の下に記載されている同じ Anthropic バウンドチャネルに依存します。
</Note>

<h3 id="access-levels">
  アクセスレベル
</h3>

[環境ダイアログ](#configure-your-environment) の **Network access** フィールドは 4 つのレベルのいずれかを取ります。

| レベル         | 送信接続                                                                |
| :---------- | :------------------------------------------------------------------ |
| **None**    | セッションのネットワークを通じた送信ネットワークアクセスなし                                      |
| **Trusted** | [許可リストドメイン](#default-allowed-domains) のみ：パッケージレジストリ、GitHub、クラウド SDK |
| **Full**    | 任意のドメイン                                                             |
| **Custom**  | 独自の許可リスト（オプションでデフォルトを含む）                                            |

どのレベルを選択しても、セッションはこれらに到達できます。それぞれはセッションのネットワーク許可リストを通じて行かないパスを取るためです。

* GitHub（[別のプロキシ](#github-proxy) を通じて）
* [MCP コネクタ](#network-access)（トラフィックが Anthropic のサーバーを通じて移動）
* 環境の [API 認証情報](#add-api-credentials) にリストしたホスト（[エージェントプロキシがスキップするホスト](#requests-that-never-get-the-credential) を除く）
* Anthropic API（Claude Code 独自のリクエスト用。[セキュリティと分離](/docs/ja/claude-code-on-the-web#security-and-isolation) の下に記載されているように **None** でも）

<h3 id="allow-specific-domains">
  特定のドメインを許可する
</h3>

Trusted リストにないドメインを許可するには、環境のネットワークアクセス設定で **Custom** を選択し、**Allowed domains** フィールドに 1 行に 1 つのドメインをリストします。この例は、内部プロジェクトが必要とする可能性のある 3 つのホストを許可します。

```text theme={null}
api.example.com
*.internal.example.com
registry.example.com
```

この環境のセッションは `api.example.com`、`internal.example.com` のすべてのサブドメイン、および `registry.example.com` に到達でき、セッションのネットワークを通じて他のドメインには到達できません。[GitHub トラフィック](#github-proxy)、[MCP コネクタトラフィック](#network-access)、および環境の [API 認証情報](#add-api-credentials) のホストへのリクエスト（[エージェントプロキシがスキップするホスト](#requests-that-never-get-the-credential) を除く）はこの許可リストを通じません。先頭の `*.` はすべてのサブドメインと一致します。[Trusted ドメイン](#default-allowed-domains) も保持するには、**一般的なパッケージマネージャーのデフォルトリストも含める** をチェックします。チェックを外すと、リストしたもののみを許可します。

組織が [アーティファクト](/docs/ja/artifacts#availability) を使用する場合、セッションがそれらを読み取るために `*.frame.claudeusercontent.com` をリストに含める必要はありません。リストがそのホストを除外する場合、Claude Code はセッションの Anthropic への接続を通じてアーティファクトコンテンツを読み取ります。ホストを許可リストに保持する 2 つの状況があります。

* **この環境のセッションが別の組織のパブリックアーティファクトを開く**：Claude Code はホストから直接それらをフェッチするため、このリストに追加します。
* **ローカル CLI またはセルフホスト実行を設定している**：ホストをその許可リストに保持します。[ネットワークアクセス要件](/docs/ja/network-config#network-access-requirements) およびセルフホスト [ネットワーク要件](/docs/ja/self-hosted-environments-deploy#network-requirements) を参照してください。

各環境は独自の許可ドメインリストを持ちます。管理者がすべてのメンバーの環境にプッシュできる組織レベルの許可リストはありません。[サーバー管理設定](/docs/ja/server-managed-settings) はクラウドセッション内に適用されますが、環境のネットワーク許可リストにドメインを追加するものはありません。

<h3 id="github-proxy">
  GitHub プロキシ
</h3>

Anthropic ホスト環境では、すべての GitHub 操作は、セッションの VM の外に実際の GitHub 認証情報を保持する専用プロキシを通じて行われます。これは環境の [アクセスレベル](#access-levels) とは独立しています。セルフホスト環境のセッションは、デプロイが提供する認証情報で git 操作を認証します。[Git を設定する](/docs/ja/self-hosted-environments-deploy#configure-git) はオプションをカバーしています。セッションごとにミントされた認証情報とこの同じプロキシへのオプトインを含みます。プロキシは以下を提供します。

* **Git 認証情報**：VM 内の git クライアントはスコープされた認証情報を使用し、プロキシはそれを検証して実際の GitHub トークンと交換します。
* **API リクエスト**：組み込み GitHub ツールからのリクエスト、および [`proxy-injected` プレースホルダー](#work-with-github-issues-and-pull-requests) の下の `gh` からのリクエストは、実際の認証情報が置き換えられた状態で送信されます。
* **プッシュ保護**：`git push` はセッションの現在の作業ブランチに対してのみ機能します。クローン、フェッチ、PR 操作は通常どおり機能します。
* **リポジトリスコープ**：GitHub API およびリリースアセットリクエストはセッションに接続されたリポジトリのみに到達するため、セットアップスクリプトが接続されていないリポジトリからリリースアセットをダウンロードすると 403 が返されます。
* **GraphQL 制限**：プロキシはプルリクエストワークフロー用にピン留めされた GraphQL 操作のセットのみを提供します。プロキシは GraphQL エンドポイント上の他のすべてを 403 で拒否します。`This GraphQL query is not enabled for this session` と言い、REST フォールバック `gh api repos/{owner}/{repo}/...` を名前付けします。制限は、提供する認証情報に関係なく、プロキシを通じるすべてのリクエストに適用されます。設定した `GH_TOKEN` は同じ 403 を取得します。Claude は Projects v2 などのプロキシを通じて GraphQL にのみ存在する GitHub API に到達できません。

パブリックリポジトリからのコミットされたファイルは `raw.githubusercontent.com` を通じて到達し、[セキュリティプロキシ](#security-proxy) がそれを処理します。そのドメインはデフォルト [Trusted リスト](#default-allowed-domains) にあるため、環境の [アクセスレベル](#access-levels) がそれを除外しない限り、これらのファイルは到達可能なままです。

<h3 id="security-proxy">
  セキュリティプロキシ
</h3>

Anthropic ホスト環境のクラウドセッションはセキュリティと不正使用防止のため HTTP/HTTPS ネットワークプロキシの背後で実行されます。[セルフホスト環境](/docs/ja/self-hosted-environments-deploy#default-deny-egress) では、送信トラフィックは代わりに独自のネットワーク境界を通じて離れます。Anthropic ホスト セッションからのすべての送信インターネットトラフィックはこのプロキシを通じて渡され、以下を提供します。

* 悪意のあるリクエストに対する保護
* レート制限と不正使用防止
* 強化されたセキュリティのためのコンテンツフィルタリング
* リクエストされたホスト名の DNS レベルの監査証跡

<h2 id="what’s-available-in-cloud-sessions">
  クラウドセッションで利用可能なもの
</h2>

Anthropic ホスト環境では、各セッションは独自のオペレーティングシステムに関係なく Ubuntu 24.04 を実行する新しい仮想マシン（VM）を x86\_64 で取得し、リポジトリがクローンされ、一般的なツールチェーンがプリインストールされています。依存関係がプリコンパイルされたバイナリを提供する場合（Ruby gems とネイティブ拡張またはプリビルト Python wheels など）、VM と一致するように x86\_64 Linux ビルドを使用します。このセクションでは Anthropic ホスト デフォルト、組み込み GitHub ツール、[テストとサービスの実行](#run-tests-start-services-and-add-packages) 方法、および各 VM が取得する [リソース制限](#resource-limits) について説明します。

<Note>
  組織が [セルフホスト環境](/docs/ja/self-hosted-environments) にルーティングするセッションは、代わりに独自のランナーで実行され、ランナーイメージが提供するツールを使用します。
</Note>

<h3 id="what-carries-over-from-your-setup">
  セットアップから引き継がれるもの
</h3>

クラウドセッションはリポジトリの新しいクローンから開始されます。リポジトリにコミットしたものはすべて利用可能です。独自のマシンにのみインストールまたは設定したものはセッションで利用できません。組織のポリシーは [サーバー管理設定](/docs/ja/server-managed-settings) を通じて別途到達します。

|                                                                                                                                               | クラウドセッションで利用可能                                         | 理由                                                                                                                                                                                                                                                                                                                                                                                                   |
| :-------------------------------------------------------------------------------------------------------------------------------------------- | :----------------------------------------------------- | :--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| リポジトリの `CLAUDE.md`                                                                                                                            | はい                                                     | クローンの一部                                                                                                                                                                                                                                                                                                                                                                                              |
| リポジトリの `.claude/settings.json` フック                                                                                                            | はい                                                     | クローンの一部                                                                                                                                                                                                                                                                                                                                                                                              |
| リポジトリの `.mcp.json` MCP サーバー                                                                                                                   | はい                                                     | クローンの一部                                                                                                                                                                                                                                                                                                                                                                                              |
| リポジトリの `.claude/rules/`                                                                                                                       | はい                                                     | クローンの一部                                                                                                                                                                                                                                                                                                                                                                                              |
| リポジトリの `.claude/skills/`、`.claude/agents/`、`.claude/commands/`                                                                                | はい                                                     | クローンの一部                                                                                                                                                                                                                                                                                                                                                                                              |
| `.claude/settings.json` で宣言されたプラグイン                                                                                                           | はい                                                     | 宣言した [マーケットプレイス](/docs/ja/plugin-marketplaces) からセッション開始時にインストールされます。マーケットプレイスソースに到達するにはネットワークアクセスが必要です                                                                                                                                                                                                                                                                                                   |
| 組織の [サーバー管理設定](/docs/ja/server-managed-settings)                                                                                                   | はい                                                     | セッション開始時に Anthropic のサーバーから取得されます。クラウドセッションで `availableModels` がどのように適用されるかについては [サーフェスカバレッジ](/docs/ja/model-config#surface-coverage) を参照してください。MDM または管理設定ファイルを通じてデバイスにデプロイされた設定は適用されません。セッションは Anthropic 管理 VM で実行されるためです。[セルフホスト環境](/docs/ja/self-hosted-environments) では、セッションはランナーイメージの管理設定ファイルも読み取ります。[Claude Code が管理ソースを組み合わせる方法](/docs/ja/managed-settings#how-claude-code-combines-managed-sources) に従います |
| ユーザー `~/.claude/CLAUDE.md`                                                                                                                    | いいえ                                                    | マシンに存在し、リポジトリには存在しません                                                                                                                                                                                                                                                                                                                                                                                |
| ユーザー `~/.claude/skills/`、`~/.claude/agents/`、`~/.claude/commands/`                                                                            | いいえ                                                    | マシンに存在し、リポジトリには存在しません。代わりにリポジトリの `.claude/` ディレクトリにコミットします。クラウドセッションは claude.ai で有効にしたスキルを自動的にロードします                                                                                                                                                                                                                                                                                                 |
| ユーザー設定でのみ有効なプラグイン                                                                                                                             | いいえ                                                    | ユーザースコープの `enabledPlugins` は `~/.claude/settings.json` に存在します。代わりにリポジトリの `.claude/settings.json` で宣言します。または claude.ai アカウントで有効にして、Claude Code が [同期プラグイン](/docs/ja/plugins-reference#synced-plugins) としてロードするようにします                                                                                                                                                                                       |
| デフォルトのローカルスコープまたはユーザースコープで `claude mcp add` で追加した MCP サーバー                                                                                    | いいえ                                                    | これらはマシンの `~/.claude.json` に書き込まれ、リポジトリには書き込まれません。`claude mcp add --scope project` でサーバーを追加します。これはリポジトリの [`.mcp.json`](/docs/ja/mcp#project-scope) に書き込まれ、そのファイルをコミットします                                                                                                                                                                                                                                   |
| リポジトリの `.claude/settings.json` `env` ブロック内のトランスポート変数（`NODE_EXTRA_CA_CERTS` および [mTLS クライアント証明書変数](/docs/ja/network-config#mtls-authentication) など） | いいえ                                                    | ホスティング環境はセッションの API 接続を管理するため、Claude Code はこれらのキーを無視し、セッションのデバッグログで各無視されたキーを記録します                                                                                                                                                                                                                                                                                                                    |
| サービス Claude が呼び出す API キーとトークン                                                                                                                 | Pro および Max プランでは [API 認証情報](#add-api-credentials) として | キーを環境に 1 回追加し、エージェントプロキシがリストしたホストへのリクエストに接続します。エージェントプロキシが [接続できない](#requests-that-never-get-the-credential) キー、または Team または Enterprise プランのキーは環境変数に留まります                                                                                                                                                                                                                                            |
| AWS SSO などのインタラクティブ認証                                                                                                                         | いいえ                                                    | サポートされていません。SSO はクラウドセッションで実行できないブラウザベースのログインが必要です                                                                                                                                                                                                                                                                                                                                                   |

独自の設定をクラウドセッションで利用可能にするには、リポジトリにコミットします。

環境を使用する誰もが環境変数とセットアップスクリプトを読み取ることができます。ダイアログの **環境変数** の下のメモはそう述べており、シークレットを追加しないよう警告します。Pro および Max プランでは、エージェントプロキシが接続できるキーを [API 認証情報](#add-api-credentials) として代わりに保存します。

<h3 id="installed-tools">
  インストール済みツール
</h3>

クラウドセッションには、一般的な言語ランタイム、ビルドツール、データベースがプリインストールされています。以下の表は、カテゴリ別に含まれるものをまとめています。

| カテゴリ        | 含まれるもの                                                    |
| :---------- | :-------------------------------------------------------- |
| **Python**  | pip、poetry、uv、black、mypy、pytest、ruff を備えた Python 3.x      |
| **Node.js** | 20、21、22（npm、yarn、pnpm、bun¹、eslint、prettier、chromedriver） |
| **Ruby**    | gem、bundler、rbenv を備えた 3.1、3.2、3.3                        |
| **PHP**     | Composer を備えた 8.3                                         |
| **Java**    | Maven と Gradle を備えた OpenJDK 21                            |
| **Go**      | モジュールサポート付きの Go                                           |
| **Rust**    | rustc と cargo                                             |
| **C/C++**   | GCC、Clang、cmake、ninja、conan                               |
| **Docker**  | docker、dockerd、docker compose                             |
| **データベース**  | PostgreSQL 16、Redis 7.0                                   |
| **ユーティリティ** | git、gh、jq、yq、ripgrep、tmux、vim、nano                        |

¹ Bun はインストールされていますが、パッケージフェッチに関して既知の [プロキシ互換性の問題](#install-dependencies-with-a-sessionstart-hook) があります。

このテーブルのほとんどのツールのバージョンを取得するには、Claude にクラウドセッションで `check-tools` を実行するよう依頼してください。これはスラッシュコマンドではなく、セッション VM にインストールされたシェルコマンドです。[Claude はすべての VM コマンドを実行します](#run-tests-start-services-and-add-packages)。Ruby、PHP、bun、PostgreSQL、Redis などのツールについては、Claude にツール独自のバージョンコマンド（例：`psql --version`）を実行するよう依頼してください。

Node.js バージョンは `/opt/node20`、`/opt/node21`、`/opt/node22` にインストールされ、デフォルトで 22 が `PATH` にあります。別のバージョンで作業するには、Claude にそのバージョンの `bin` ディレクトリ（例：`/opt/node20/bin`）を `PATH` の前に追加するよう依頼してください。

.NET SDK などのこのリスト外のツールチェーンは、パッケージレジストリが [デフォルト許可リスト](#default-allowed-domains) にある場合でも、プリインストールされていません。[セットアップスクリプト](#setup-scripts) でインストールします。

<h3 id="work-with-github-issues-and-pull-requests">
  GitHub の問題とプルリクエストを操作する
</h3>

クラウドセッションには、Claude が問題を読み取り、プルリクエストをリストし、差分をフェッチし、セットアップなしでコメントを投稿できる組み込み GitHub ツールが含まれています。これらのツールは [GitHub プロキシ](#github-proxy) を通じて認証され、[GitHub 認証オプション](/docs/ja/claude-code-on-the-web#github-authentication-options) の下で設定した方法を使用するため、トークンはコンテナに入りません。

[環境設定](#set-environment-variables) で `GH_TOKEN` または `GITHUB_TOKEN` を自分で設定するか、両方を設定しないままにして [GitHub プロキシ](#github-proxy) に認証を処理させることができます。

* トークンを設定する場合、それはコンテナに変更されずに渡されるため、スクリプトと GitHub の [`gh` CLI](https://cli.github.com) がインストールされている場合は直接使用します。
* どちらも設定せず、[GitHub プロキシ](#github-proxy) がセッションの認証を処理している場合、両方の変数は Claude が実行するコマンドでプレースホルダー文字列 `proxy-injected` として読み取られ、プロキシは送信 GitHub リクエストで実際の認証情報を置き換えます。`gh` はトークンなしで機能しますが、`GITHUB_TOKEN` を直接読み取るスクリプトはプレースホルダーを取得し、使用可能なトークンは取得しません。

設定したトークンは通常の環境変数であるため、環境を使用する誰でも読み取ることができます。プロキシパスは認証情報を環境設定とセッション VM の外に保持します。

セッションに適用される場合を確認するには、Claude に `echo $GH_TOKEN` を実行するよう依頼してください。

GitHub の [`gh` CLI](https://cli.github.com) はプリインストールされています。組み込みツールがカバーしない `gh release` または `gh workflow run` などの `gh` コマンドが必要な場合は、Claude に実行するよう依頼してください。`gh` は `GH_TOKEN` を自動的に読み取るため、`gh auth login` を実行する必要はありません。

<h3 id="link-output-back-to-the-session">
  セッションに出力をリンクバックする
</h3>

各クラウドセッションは claude.ai 上にトランスクリプト URL を持ち、セッションは `CLAUDE_CODE_REMOTE_SESSION_ID` 環境変数から独自の ID を読み取ることができます。これを使用して、PR 本文、コミットメッセージ、Slack 投稿、または生成されたレポートに追跡可能なリンクを配置し、レビュアーがそれを生成した実行を開くことができるようにします。

Claude がクラウドセッションで作成するコミットには `Claude-Session: <url>` git トレーラーが含まれ、PR 本文にはセッション URL が独自の行に含まれます。これには v2.1.179 以降が必要です。トレーラーと PR 本文リンクを省略するには、[`attribution.sessionUrl`](/docs/ja/settings-reference#attribution-sessionurl) を `false` に設定します。設定には v2.1.182 以降が必要です。

セッションリンクをコミットまたは PR 以外のもの（Claude が投稿する Slack メッセージまたは書き込むレポートファイルなど）に含めるには、Claude に次のコマンドを実行させ、その出力を使用します。コマンドは環境変数の値の `cse_` プレフィックスをトランスクリプト URL が期待する `session_` プレフィックスに変換します。

```bash theme={null}
echo "https://claude.ai/code/${CLAUDE_CODE_REMOTE_SESSION_ID/#cse_/session_}"
```

<h3 id="run-tests-start-services-and-add-packages">
  テストを実行し、サービスを開始し、パッケージを追加する
</h3>

セッション VM へのシェルアクセスは取得できません。Claude はすべてのコマンドを実行するため、このセクションのタスクをプロンプトでリクエストとして表現します。

<h4 id="run-tests">
  テストを実行する
</h4>

Claude はタスクに取り組む際にテストを実行します。プロンプトで「`tests/` の失敗したテストを修正する」または「各変更後に pytest を実行する」のようにリクエストします。pytest や cargo test などの [プリインストールされたツールチェーン](#installed-tools) に付属するテストランナーは、追加のセットアップなしで機能します。jest などのプロジェクトが依存関係として宣言するランナーは、依存関係と共にインストールされます。

<h4 id="start-services">
  サービスを開始する
</h4>

PostgreSQL と Redis はプリインストールされていますが、デフォルトでは実行されていません。必要なものを開始するよう Claude に依頼します。実行するコマンドは次のとおりです。

```bash theme={null}
service postgresql start
```

```bash theme={null}
service redis-server start
```

Docker はコンテナ化されたサービスを実行するために利用可能です。Claude に `docker compose up` を実行するよう依頼して、プロジェクトのサービスを開始します。イメージをプルするためのネットワークアクセスは環境の [アクセスレベル](#access-levels) に従い、[Trusted デフォルト](#default-allowed-domains) には Docker Hub および他の一般的なレジストリが含まれます。

イメージが大きいか遅い場合は、[セットアップスクリプト](#setup-scripts) に `docker compose pull` または `docker compose build` を追加します。[環境キャッシュ](#environment-caching) はプルされたイメージを保持するため、各新しいセッションはディスク上にそれらを持ちます。キャッシュはファイルのみを保存し、実行中のプロセスは保存しないため、Claude は各セッションでコンテナを開始します。

<h4 id="add-packages">
  パッケージを追加する
</h4>

プリインストールされていないパッケージを追加するには、[セットアップスクリプト](#setup-scripts) を使用します。[環境キャッシュ](#environment-caching) はスクリプトがインストールするものを保持するため、そこにインストールするパッケージは各セッションの開始時に利用可能であり、毎回再インストールする必要はありません。Claude にセッション中にパッケージをインストールするよう依頼することもできますが、これらのインストールは他のセッションに引き継がれません。

<h3 id="resource-limits">
  リソース制限
</h3>

Anthropic ホスト環境のクラウドセッションは、時間とともに変わる可能性のある概算リソース上限で実行されます。

* 4 vCPU
* 16 GB の RAM
* 30 GB のディスク

VM は、大規模なビルドジョブやメモリ集約的なテストなど、大幅により多くのメモリを必要とするタスクを停止する可能性があります。これらの制限を超えるワークロードについては、[Remote Control](/docs/ja/remote-control) を使用して独自のハードウェアで Claude Code を実行するか、[セルフホスト環境](/docs/ja/self-hosted-environments) でクラウドセッションを実行します。組織が操作するコンピュートで。

<h2 id="setup-scripts">
  セットアップスクリプト
</h2>

セットアップスクリプトは、新しいクラウドセッションが開始されるときに実行される Bash スクリプトです。Claude Code が起動する前です。セットアップスクリプトを使用して、依存関係をインストールし、ツールを設定し、またはセッションが必要とするプリインストールされていないものをフェッチします。

スクリプトは Ubuntu 24.04 上で root として実行されるため、`apt install` およびほとんどの言語パッケージマネージャーが機能します。

セットアップスクリプトを追加するには、環境設定ダイアログを開き、**Setup script** フィールドにスクリプトを入力します。

この例は、プリインストールされていない [ShellCheck](https://www.shellcheck.net/) をインストールします。

```bash theme={null}
#!/bin/bash
apt update && apt install -y shellcheck
```

<h3 id="script-requirements">
  スクリプト要件
</h3>

セットアップスクリプトには、対応する 3 つの制約があります。

* **ゼロで終了**：スクリプトがゼロ以外で終了する場合、セッションは開始に失敗します。非重要なコマンドに `|| true` を追加して、一時的なインストール失敗がセッションをブロックしないようにします。
* **5 分以内に完了**：スクリプトの総実行時間を約 5 分以内に保つため、[環境キャッシュ](#environment-caching) をビルドできます。独立したインストールを `&` と `wait` で並列実行し、フィットしない単一ダウンロードを [SessionStart フック](#setup-scripts-vs-sessionstart-hooks) に移動して、バックグラウンドで起動します。
* **インストール用のネットワークアクセス**：パッケージインストールはレジストリに到達する必要があります。デフォルトの **Trusted** レベルは npm、PyPI、RubyGems、crates.io を含む [一般的なパッケージレジストリ](#default-allowed-domains) をカバーします。**None** ネットワークアクセスでは、インストールは失敗します。

<h3 id="environment-caching">
  環境キャッシング
</h3>

セットアップスクリプトは、環境でセッションを開始する最初の時間に実行されます。完了後、Anthropic はファイルシステムをスナップショットし、そのスナップショットを後のセッションの開始点として再利用します。新しいセッションはディスク上に既に依存関係、ツール、Docker イメージを持ち、セットアップスクリプトステップをスキップします。これにより、スクリプトが大規模なツールチェーンをインストールしたりコンテナイメージをプルしたりする場合でも、スタートアップが高速に保たれます。

キャッシュはファイルシステムスナップショットであるため、セットアップスクリプトがディスクに書き込むものを保持し、実行中のみのものを失います。インストールするパッケージ、プルする Docker イメージ、書き込むファイルはすべて引き継がれます。スクリプトが開始したデータベース、`docker compose up` スタック、またはその他のバックグラウンドプロセスは引き継がれません。これらはセッションごとに Claude に依頼するか、[SessionStart フック](#setup-scripts-vs-sessionstart-hooks) で開始します。

セットアップスクリプトは、環境のセットアップスクリプトまたは許可されたネットワークホストを変更するとき、およびキャッシュが約 7 日後に有効期限に達するときに再度実行され、キャッシュを再構築します。既存のセッションを再開すると、セットアップスクリプトは再度実行されません。

キャッシングを有効にするか、スナップショットを自分で管理する必要はありません。

<h3 id="setup-scripts-vs-sessionstart-hooks">
  セットアップスクリプト対 SessionStart フック
</h3>

セットアップスクリプトを使用して VM 自体をプロビジョニングします。[プリインストール](#installed-tools) されていないツールチェーンと CLI ツール。[SessionStart フック](/docs/ja/hooks#sessionstart) をプロジェクトセットアップに使用します。クラウドとローカルで実行する必要があります。`npm install` などです。

セットアップスクリプトと SessionStart フックは、クラウドセッションが開始するときに固定順序で実行されます。テーブルは、設定場所、実行時期、実行場所を比較しています。

|          | セットアップスクリプト                                                                                                    | SessionStart フック                                                                                                                                                           |
| -------- | -------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **設定場所** | [claude.ai/code](https://claude.ai/code) の環境ダイアログ、[共有環境](#organization-shared-environments) の **クラウド環境** 管理ページ | [設定ファイル](/docs/ja/settings#where-settings-live)（リポジトリの `.claude/settings.json` など）。[セットアップから引き継がれるもの](#what-carries-over-from-your-setup) を参照して、どのファイルがクラウドセッションに到達するかを確認してください |
| **実行時期** | Claude Code が起動する前に、[キャッシュされた環境](#environment-caching) が存在する場合はスキップ                                            | Claude Code が起動した後、再開を含むすべてのセッションで                                                                                                                                         |
| **実行場所** | クラウドセッションのみ                                                                                                    | ローカルとクラウドセッション                                                                                                                                                             |

ユーザーレベルの `~/.claude/settings.json` に SessionStart フックがある場合、クラウドではそれらを期待しないでください。ユーザーレベルの設定はマシンに留まります。どの他のフックが実行されるかは、セッションが実行される場所によって異なります。

* **Anthropic ホスト環境**：Claude Code はリポジトリおよび組織の [サーバー管理設定](/docs/ja/server-managed-settings) からフックを実行します。
* **[セルフホスト環境](/docs/ja/self-hosted-environments-configuration#permissions-and-tool-approval)**：Claude Code はオペレーターがランナーホストの `~/.claude/` からシードしたフックも実行し、ランナーイメージの管理設定ファイルのフック（そのファイルが [Claude Code が適用する管理ソース](/docs/ja/managed-settings#how-claude-code-combines-managed-sources) のいずれかである場合）。

<h3 id="install-dependencies-with-a-sessionstart-hook">
  SessionStart フックで依存関係をインストールする
</h3>

クラウドセッションのみに依存関係をインストールするには、SessionStart フックを実行場所をチェックするスクリプトと組み合わせます。

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

次に、`scripts/install_pkgs.sh` でスクリプトを作成します。クラウドの外では直ちに終了し、依存関係をインストールします。

```bash theme={null}
#!/bin/bash

if [ "$CLAUDE_CODE_REMOTE" != "true" ]; then
  exit 0
fi

npm install
pip install -r requirements.txt
exit 0
```

`CLAUDE_CODE_REMOTE` チェックは、インストールをクラウドセッションにスコープするものです。セッション VM の環境は変数を `true` として持ち、ローカルでは決して `true` ではないため、ラップトップではスクリプトは何もインストールする前に終了します。

2 つのファイルを合わせると、すべてのクラウドセッションは起動時に新しい `npm install` と `pip install` を取得し、ローカルセッションは影響を受けません。

<h4 id="limitations-in-cloud-sessions">
  クラウドセッションの制限
</h4>

SessionStart フックはクラウドでローカルと同じように動作しますが、これらの注意事項があります。

* **クラウドのみのスコープなし**：フックはローカルとクラウドセッションの両方で実行されます。ローカル実行をスキップするには、上記のように `CLAUDE_CODE_REMOTE` 環境変数をチェックします。
* **ネットワークアクセスが必要**：インストールコマンドはパッケージレジストリに到達する必要があります。環境が **None** ネットワークアクセスを使用する場合、これらのフックは失敗します。**Trusted** の下の [デフォルト許可リスト](#default-allowed-domains) は npm、PyPI、RubyGems、crates.io をカバーします。
* **プロキシ互換性**：Anthropic ホスト環境では、すべての送信トラフィックは [セキュリティプロキシ](#security-proxy) を通じて渡されます。一部のパッケージマネージャーはこのプロキシで正しく機能しません。Bun は既知の例です。[セルフホスト環境](/docs/ja/self-hosted-environments-deploy#default-deny-egress) では、送信トラフィックは代わりに独自のネットワーク境界を通じて行きます。
* **スタートアップレイテンシを追加**：フックはセッションが開始または再開されるたびに実行されます。[環境キャッシング](#environment-caching) の恩恵を受けるセットアップスクリプトとは異なります。依存関係が既に存在するかどうかをチェックして再インストールを避けることで、インストールスクリプトを高速に保ちます。

ベースイメージをカスタマイズするには、セットアップスクリプトを使用して [提供されたイメージ](#installed-tools) の上にインストールするか、`docker compose` で Claude と一緒にコンテナとして独自のイメージを実行します。ベースイメージ全体を置き換えることはまだサポートされていません。

<h2 id="default-allowed-domains">
  デフォルト許可ドメイン
</h2>

**Trusted** ネットワークアクセスでは、セッションはデフォルトで次のドメインに到達できます。`*` でマークされたドメインはワイルドカードサブドメインマッチングを示すため、`*.gcr.io` は `gcr.io` のすべてのサブドメインを許可します。

<AccordionGroup>
  <Accordion title="Anthropic サービス">
    * api.anthropic.com
    * statsig.anthropic.com
    * docs.claude.com
    * platform.claude.com
    * code.claude.com
    * claude.ai
  </Accordion>

  <Accordion title="バージョン管理">
    * github.com
    * [www.github.com](http://www.github.com)
    * api.github.com
    * npm.pkg.github.com
    * raw\.githubusercontent.com
    * pkg-npm.githubusercontent.com
    * objects.githubusercontent.com
    * release-assets.githubusercontent.com
    * codeload.github.com
    * avatars.githubusercontent.com
    * camo.githubusercontent.com
    * gist.github.com
    * gitlab.com
    * [www.gitlab.com](http://www.gitlab.com)
    * registry.gitlab.com
    * bitbucket.org
    * [www.bitbucket.org](http://www.bitbucket.org)
    * api.bitbucket.org
  </Accordion>

  <Accordion title="コンテナレジストリ">
    * registry-1.docker.io
    * auth.docker.io
    * index.docker.io
    * hub.docker.com
    * [www.docker.com](http://www.docker.com)
    * production.cloudflare.docker.com
    * download.docker.com
    * gcr.io
    * \*.gcr.io
    * ghcr.io
    * mcr.microsoft.com
    * \*.data.mcr.microsoft.com
    * public.ecr.aws
  </Accordion>

  <Accordion title="クラウドプラットフォーム">
    * cloud.google.com
    * accounts.google.com
    * gcloud.google.com
    * \*.googleapis.com
    * storage.googleapis.com
    * compute.googleapis.com
    * container.googleapis.com
    * azure.com
    * portal.azure.com
    * microsoft.com
    * [www.microsoft.com](http://www.microsoft.com)
    * \*.microsoftonline.com
    * packages.microsoft.com
    * dotnet.microsoft.com
    * dot.net
    * visualstudio.com
    * dev.azure.com
    * \*.amazonaws.com
    * \*.api.aws
    * oracle.com
    * [www.oracle.com](http://www.oracle.com)
    * java.com
    * [www.java.com](http://www.java.com)
    * java.net
    * [www.java.net](http://www.java.net)
    * download.oracle.com
    * yum.oracle.com
  </Accordion>

  <Accordion title="JavaScript と Node パッケージマネージャー">
    * registry.npmjs.org
    * [www.npmjs.com](http://www.npmjs.com)
    * [www.npmjs.org](http://www.npmjs.org)
    * npmjs.com
    * npmjs.org
    * yarnpkg.com
    * registry.yarnpkg.com
  </Accordion>

  <Accordion title="Python パッケージマネージャー">
    * pypi.org
    * [www.pypi.org](http://www.pypi.org)
    * files.pythonhosted.org
    * pythonhosted.org
    * test.pypi.org
    * pypi.python.org
    * pypa.io
    * [www.pypa.io](http://www.pypa.io)
  </Accordion>

  <Accordion title="Ruby パッケージマネージャー">
    * rubygems.org
    * [www.rubygems.org](http://www.rubygems.org)
    * api.rubygems.org
    * index.rubygems.org
    * ruby-lang.org
    * [www.ruby-lang.org](http://www.ruby-lang.org)
    * rubyforge.org
    * [www.rubyforge.org](http://www.rubyforge.org)
    * rubyonrails.org
    * [www.rubyonrails.org](http://www.rubyonrails.org)
    * rvm.io
    * get.rvm.io
  </Accordion>

  <Accordion title="Rust パッケージマネージャー">
    * crates.io
    * [www.crates.io](http://www.crates.io)
    * index.crates.io
    * static.crates.io
    * rustup.rs
    * static.rust-lang.org
    * [www.rust-lang.org](http://www.rust-lang.org)
  </Accordion>

  <Accordion title="Go パッケージマネージャー">
    * proxy.golang.org
    * sum.golang.org
    * index.golang.org
    * golang.org
    * [www.golang.org](http://www.golang.org)
    * goproxy.io
    * pkg.go.dev
  </Accordion>

  <Accordion title="JVM パッケージマネージャー">
    * maven.org
    * repo.maven.org
    * central.maven.org
    * repo1.maven.org
    * repo.maven.apache.org
    * jcenter.bintray.com
    * gradle.org
    * [www.gradle.org](http://www.gradle.org)
    * services.gradle.org
    * plugins.gradle.org
    * kotlinlang.org
    * [www.kotlinlang.org](http://www.kotlinlang.org)
    * spring.io
    * repo.spring.io
  </Accordion>

  <Accordion title="その他のパッケージマネージャー">
    * packagist.org（PHP Composer）
    * [www.packagist.org](http://www.packagist.org)
    * repo.packagist.org
    * nuget.org（.NET NuGet）
    * [www.nuget.org](http://www.nuget.org)
    * api.nuget.org
    * pub.dev（Dart/Flutter）
    * api.pub.dev
    * hex.pm（Elixir/Erlang）
    * [www.hex.pm](http://www.hex.pm)
    * cpan.org（Perl CPAN）
    * [www.cpan.org](http://www.cpan.org)
    * metacpan.org
    * [www.metacpan.org](http://www.metacpan.org)
    * api.metacpan.org
    * cocoapods.org（iOS/macOS）
    * [www.cocoapods.org](http://www.cocoapods.org)
    * cdn.cocoapods.org
    * haskell.org
    * [www.haskell.org](http://www.haskell.org)
    * hackage.haskell.org
    * swift.org
    * [www.swift.org](http://www.swift.org)
  </Accordion>

  <Accordion title="Linux ディストリビューション">
    * archive.ubuntu.com
    * security.ubuntu.com
    * ubuntu.com
    * [www.ubuntu.com](http://www.ubuntu.com)
    * \*.ubuntu.com
    * ppa.launchpad.net
    * launchpad.net
    * [www.launchpad.net](http://www.launchpad.net)
    * \*.nixos.org
  </Accordion>

  <Accordion title="開発ツールとプラットフォーム">
    * dl.k8s.io（Kubernetes）
    * pkgs.k8s.io
    * k8s.io
    * [www.k8s.io](http://www.k8s.io)
    * releases.hashicorp.com（HashiCorp）
    * apt.releases.hashicorp.com
    * rpm.releases.hashicorp.com
    * archive.releases.hashicorp.com
    * hashicorp.com
    * [www.hashicorp.com](http://www.hashicorp.com)
    * repo.anaconda.com（Anaconda/Conda）
    * conda.anaconda.org
    * anaconda.org
    * [www.anaconda.com](http://www.anaconda.com)
    * anaconda.com
    * continuum.io
    * apache.org（Apache）
    * [www.apache.org](http://www.apache.org)
    * archive.apache.org
    * downloads.apache.org
    * eclipse.org（Eclipse）
    * [www.eclipse.org](http://www.eclipse.org)
    * download.eclipse.org
    * nodejs.org（Node.js）
    * [www.nodejs.org](http://www.nodejs.org)
    * developer.apple.com
    * developer.android.com
    * pkg.stainless.com
    * binaries.prisma.sh
  </Accordion>

  <Accordion title="クラウドサービスと監視">
    * statsig.com
    * [www.statsig.com](http://www.statsig.com)
    * api.statsig.com
    * sentry.io
    * \*.sentry.io
    * downloads.sentry-cdn.com
    * http-intake.logs.datadoghq.com
    * browser-intake-us5-datadoghq.com
    * \*.datadoghq.com
    * \*.datadoghq.eu
    * api.honeycomb.io
  </Accordion>

  <Accordion title="コンテンツ配信とミラー">
    * sourceforge.net
    * \*.sourceforge.net
    * packagecloud.io
    * \*.packagecloud.io
    * fonts.googleapis.com
    * fonts.gstatic.com
  </Accordion>

  <Accordion title="スキーマと設定">
    * json-schema.org
    * [www.json-schema.org](http://www.json-schema.org)
    * json.schemastore.org
    * [www.schemastore.org](http://www.schemastore.org)
  </Accordion>

  <Accordion title="Model Context Protocol">
    * \*.modelcontextprotocol.io
  </Accordion>
</AccordionGroup>

<h2 id="related-resources">
  関連リソース
</h2>

* [Web 上の Claude Code](/docs/ja/claude-code-on-the-web)：クラウドセッションを開始、管理、共有します
* [Web クイックスタート](/docs/ja/web-quickstart)：GitHub を接続して最初のクラウドセッションを開始します
* [Claude Tag](https://claude.com/docs/claude-tag/overview)：Claude が Slack から開始するセッションは同じ環境で実行されます
* [ルーチン](/docs/ja/routines)：スケジュール実行は同じ環境とネットワークアクセスレベルを使用します
* [Remote Control](/docs/ja/remote-control)：代わりに独自のマシンのネットワークとファイルでセッションを実行します
* [セルフホスト環境](/docs/ja/self-hosted-environments)：組織独自のインフラストラクチャでクラウドセッションを実行します
* [SessionStart フック](/docs/ja/hooks#sessionstart)：ローカルとクラウドセッションで実行されるリポジトリコミットセットアップ
* [サーバー管理設定](/docs/ja/server-managed-settings)：クラウドセッションに到達する組織ポリシー
