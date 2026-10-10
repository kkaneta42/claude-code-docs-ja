> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# セルフホストされた環境のクイックスタート

> セルフホストされた環境を初めてセットアップします。Claude Code をインストールし、環境を作成し、ランナーを起動し、セッションをルーティングします。

<Note>
  セルフホストされた環境は Team および Enterprise プランでパブリックベータ版です。[利用可能性と制限事項](/docs/ja/self-hosted-environments#availability-and-limitations)は有効化パスをカバーしています。このページは最初のセッションを実行します。詳細は[セルフホストされた環境](/docs/ja/self-hosted-environments)を参照し、本番環境へのデプロイについては[本番環境へのデプロイ](/docs/ja/self-hosted-environments-deploy)を参照してください。
</Note>

[セルフホストされた環境](/docs/ja/self-hosted-environments)は、Claude Code の[クラウドセッション](/docs/ja/claude-code-on-the-web)を、組織が運用するインフラストラクチャ上で実行し、デプロイするランナープロセスによって実行されます。このクイックスタートは最初のセットアップを行います。最小限の構成は、単一ホスト上の 1 つのランナーで 1 つのテストセッションを実行することです。2 つのステップがあります。[環境とランナーを作成し、セッションをルーティングする](#set-up-an-environment-and-runner)、その後[実行中のセッションにターミナルからメッセージを送信する](#send-a-follow-up-message-to-a-running-session)。2 つのサーフェス間を移動します。claude.ai は環境の作成、ステータスの確認、セッションのルーティング用で、ホスト上のターミナルはランナーが行うすべてのことに使用します。

終了時には、[**Cloud environments** 管理ページ](https://claude.ai/admin-settings/cloud-environments)に環境があり、ランナーが仕事をポーリングしており、セッションがホスト上で実行されています。実際のリポジトリまたは内部システムを接続する前に、[本番環境へのデプロイ](/docs/ja/self-hosted-environments-deploy)を実行してください。これはセキュリティ体制、エグレス制御、git 認証情報、およびオーケストレーションをカバーしています。

<h2 id="prerequisites">
  前提条件
</h2>

<h3 id="organization-and-roles">
  組織とロール
</h3>

claude.ai 側には以下が必要です。

* **セルフホストされた環境を許可**は、[**Cloud environments** 管理ページ](https://claude.ai/admin-settings/cloud-environments)で[オーナー](/docs/ja/cloud-environments#organization-shared-environments)によってオンにされます。**新規**ボタンはそれがオンになるまで表示されません。ロールを保持していない場合、保持している人が環境を作成してシークレットを渡すことができます。このページのランナーとターミナルのステップには claude.ai ロールは不要です。ステップが管理 UI でステータスをチェックする場合、ランナー自身のログ行が同じシグナルを提供します。
* 組織の[GitHub 接続](/docs/ja/claude-code-on-the-web#github-authentication-options)。開発者がセッションを開始するときにリポジトリを選択できるようにします。

<h3 id="host-and-network">
  ホストとネットワーク
</h3>

ランナーホストには以下が必要です。

* `api.anthropic.com`、`claude.ai` および以下のインストールステップ用のダウンロードホストへのアウトバウンド HTTPS、および git ホストへのクローン用の Linux または macOS ホストまたはコンテナ。[ネットワーク要件テーブル](/docs/ja/self-hosted-environments-deploy#network-requirements)に完全なリストがあります。Windows はランナーホストとしてサポートされていません。代わりに Linux コンテナでランナーを実行してください。セッションは claude.ai のブラウザから開始されるため、開発者ワークステーションは影響を受けません。
* テストセッション用のリポジトリ。公開リポジトリ、またはこのホストが認証情報を求められることなく HTTPS URL で既にクローンできるリポジトリを用意してください。
* NTP などで実時間に同期されたクロック。クロックが 5 分以上ずれていると認証が失敗します。[トラブルシューティング](/docs/ja/self-hosted-environments-deploy#troubleshooting)を参照してください。

<h3 id="software-on-the-runner-host">
  ランナーホスト上のソフトウェア
</h3>

開始する前にホストにインストールしてください。

* **Claude Code v2.1.224 以降**。[標準インストール方法](/docs/ja/setup)のいずれかを使用します。ランナーは標準 `claude` バイナリの一部であり、以前のバージョンは `self-hosted-runner` サブコマンドを認識しません。ネイティブインストーラーのデフォルト `latest` チャネルは各リリースを公開直後に提供します。`stable` チャネル、Homebrew `claude-code` cask、および安定版 apt、dnf、apk リポジトリは約 1 週間遅れます。フロートが実行する正確なバージョンをピンするには、[特定のバージョンをインストール](/docs/ja/setup#install-a-specific-version)を参照してください。コンテナイメージについては、[本番環境へのデプロイ](/docs/ja/self-hosted-environments-deploy#build-the-runner-image)の Dockerfile を参照してください。
* **Git 2.24 以降**。デプロイページの一部の git オプションはより新しいバージョンが必要です。[git を設定](/docs/ja/self-hosted-environments-deploy#configure-git)は各フロアを記載しています。

ホストの準備ができていることを確認します。

```bash theme={null}
claude self-hosted-runner --help
```

準備ができたホストはランナーの使用テキストを出力し、`--environment-secret-file` などのフラグをリストします。2.1.224 より古いバージョンでは、コマンドは代わりに一般的な `claude --help` 出力を出力します。`claude update` でアップグレードするか、`latest` チャネルから再インストールしてください。

<h2 id="set-up-an-environment-and-runner">
  環境とランナーをセットアップする
</h2>

[ガイド付きセットアップ](#run-the-guided-setup)または[手動手順](#set-up-manually)のいずれかを使用します。ガイド付きセットアップは、インタラクティブな Claude Code セッションを開始して残りの手順を案内する単一のコマンドです。インタラクティブセッションが不可能なホストでは、代わりに手動手順を使用してください。Owner ロールを持つユーザーが環境を作成してそのシークレットを渡した場合も、手動手順を使用してください。ガイド付きセットアップには Owner としてのサインインが必要なためです。

<h3 id="run-the-guided-setup">
  ガイド付きセットアップを実行する
</h3>

ガイド付きセットアップは、管理 UI で環境を作成する手順を案内し、保存したシークレットファイルを使用してローカルランナーを起動し、ランナーが登録されたことを確認し、`./runner-setup/CHEAT-SHEET.md` にチートシートを書き込みます。実行する前に、サインインとバージョンを確認してください。

* **サインイン**：Owner ロールを持つアカウントを使用して `claude auth login` でサインインしたマシンで実行してください。API キーまたはサードパーティのモデルプロバイダーのみの場合、セッションは開始されますが、組織のチェックに失敗します。
* **バージョン**：[バージョンチェック](#software-on-the-runner-host)が成功したことを確認してください。2.1.224 より古いバージョンでは、setup コマンドはガイド付きセットアップではなく、単語をプロンプトとして使用する Claude セッションを開始します。

ガイド付きセットアップを開始するには、シェルで setup サブコマンドを実行してプロンプトに従ってください。

```bash theme={null}
claude self-hosted-runner setup
```

セットアップ自体はテストセッションを開始しません。claude.ai/code でテストセッションを開始するよう案内されます。セットアップの最後のステップでは、セットアップが起動したランナーを停止します。そのステップの前にセットアップを終了した場合、ランナーは実行を続けます。最後のステップの後も続行するには、`./runner-setup/CHEAT-SHEET.md` に記載されたコマンドを使用してシェルでランナーを再度起動し、[セッションを環境にルーティング](#route-a-session)してください。

<h3 id="set-up-manually">
  手動でセットアップする
</h3>

claude.ai で環境を作成し、ホスト上のターミナルからランナーを起動してから、claude.ai に戻ってランナーが表示されることを確認し、セッションをランナーにルーティングします。Owner ロールを持つユーザーが既に環境を作成してそのシークレットを渡している場合は、ステップ 2 から開始してください。

<Steps>
  <Step title="環境を作成する">
    管理設定の [**Cloud environments** ページ](https://claude.ai/admin-settings/cloud-environments) に移動します。**Self-hosted environments** の下で、**New** を選択し、環境に名前を付けて、**Create** を選択します。ウィザードの 2 番目のステップで、**Copy environment key** を選択して環境シークレットをコピーします。管理 UI はこれを環境キーとしてラベル付けしています。claude.ai はシークレットを 1 回だけ表示し、後で取得することはできません。シークレットは作成から 365 日後に期限切れになります。環境の `ccpool_...` ID は詳細ダイアログに表示されたままになります。これは、[トークン検証](/docs/ja/self-hosted-environments-identity)の `aud` チェックと、[CI からのテストセッションのディスパッチ](/docs/ja/self-hosted-environments-testing#run-the-test-loop)に必要です。

    シークレットを紛失した場合、またはローテーションが必要な場合は、環境の **Configuration** タブから新しいシークレットを作成し、新しいシークレットをランナーにロールアウトしてから、古いシークレットを取り消します。取り消されたシークレットを保持しているランナーは、次の認証済みポーリングに失敗して終了し、`poll auth failed` をログに記録します。オーケストレーターは新しいシークレットでランナーを再起動します。
  </Step>

  <Step title="ランナーを起動する">
    シークレットディレクトリを作成します。このコマンドと次のコマンドは `/etc/claude` を使用するため root が必要です。また、これらのコマンドで作成されるシークレットファイルは、コマンドを実行したユーザーのみが読み取ることができます。ランナーを別のユーザーとして実行する場合、ランナーは `error: Failed to read environment secret file <path> (EACCES: permission denied, open '<path>')` で終了します。その場合は、`/etc/claude` の代わりにランナーのユーザーが書き込めるディレクトリを使用して両方のコマンドをランナーのユーザーとして実行し、同じパスを `--environment-secret-file` に渡してください。ランナープロセスが読み取ることができるパスであれば、どのパスでも機能します。

    ```bash theme={null}
    mkdir -p /etc/claude
    ```

    環境シークレットをファイルに書き込みます。以下のコマンドはターミナルから読み取るため、シークレットはシェル履歴から除外されます。コピーした値を貼り付け、Enter キーを押してから Ctrl-D を押します。サブシェルの `umask` により、ファイルは所有者のみが読み取ることができます。

    ```bash theme={null}
    (umask 077 && cat > /etc/claude/environment-secret)
    ```

    ベースディレクトリを選択し、以下のランナーコマンドの `<writable-dir>` を、ランナーが書き込みまたは作成できる絶対パスに置き換えます。ランナーは起動時にディレクトリを作成し、リポジトリをチェックアウトして、その下にセッションごとのディレクトリを作成します。`--base-dir` がない場合、`/workspace` を使用します。これは、そのディレクトリが既に存在し、書き込み可能であるか、ランナーを root として起動する場合にのみ機能します。

    ランナーがパスを作成または書き込みできない場合、起動時にディレクトリを名前として指定するエラーで終了し、登録されません。[トラブルシューティング](/docs/ja/self-hosted-environments-deploy#troubleshooting)を参照してください。

    次に、`--environment-secret-file` と `--base-dir` を使用してランナーを起動します。

    ```bash theme={null}
    claude self-hosted-runner --environment-secret-file '/etc/claude/environment-secret' --base-dir '<writable-dir>'
    ```

    ランナーは環境に登録されると `Registered: runner_id=<runner-id>` をログに記録し、作業のポーリングを開始します。後でランナーが終了した場合は、手動で再起動してください。これが発生する状況については、[ランナーが終了した場合](#if-the-runner-exits)を参照してください。
  </Step>

  <Step title="ランナーが表示されることを確認する">
    [**Cloud environments** ページ](https://claude.ai/admin-settings/cloud-environments)に戻ります。環境のステータスは、ランナーが起動してから数秒以内に **No runners deployed** から **Healthy** に変わります。環境を開いて **Activity** を選択すると、ランナー自体が表示されます。管理ページにアクセスできない場合は、前のステップのランナーのログにある `Registered: runner_id=<runner-id>` の行で同じことを確認できます。
  </Step>

  <Step title="セッションを環境にルーティングする">
    <span id="route-a-session" />claude.ai/code でセッションを開始し、環境ピッカーから環境を選択します。セルフホスト環境は Anthropic ホスト環境と並んで表示されます。リポジトリには、[前提条件](#host-and-network)で用意したもの、つまり公開リポジトリ、またはこのホストが既にクローンできるリポジトリを選択してください。ランナーは、ホストが既に持っている git 認証情報を使用してクローンを作成します。

    次に利用可能なランナーがキューに入ったセッションを取得し、`Picked up session <session-id>` をアクティブカウントと容量とともにログに記録します。ランナー自身の出力からどのホストがセッションを取得したかを確認できます。[claude.ai/code](https://claude.ai/code) でセッションの動作を監視し、Claude の返信を読んでください。

    セッションが動作を開始しない場合は、表示される状況に応じて対処してください。

    * **セッションがキューに入ったままになる**：[トラブルシューティング](/docs/ja/self-hosted-environments-deploy#troubleshooting)を参照してください。
    * **セッションが git エラーで開始に失敗する**：エラーはセッションとランナーのログに表示されます。git の `could not read Username for` に続いて git ホストの URL が含まれている場合、ランナーにはそのホストの HTTPS 認証情報がありませんでした。[git を設定する](/docs/ja/self-hosted-environments-deploy#configure-git)を参照してください。本番環境のプライベートリポジトリの認証情報オプションもここに記載されています。
  </Step>
</Steps>

<h3 id="if-the-runner-exits">
  ランナーが終了した場合
</h3>

このクイックスタートの途中でランナーが終了した場合は、同じコマンドで再度起動してください。ランナーは自ら終了することがあります。

* **セッションの終了**：ログに `[runner:exit] account workload drained — exiting` が表示されます。ランナーは設計上、アクティブセッションが終了すると終了します。[ランナーのライフサイクル](/docs/ja/self-hosted-environments#runner-lifecycle)を参照してください。
* **接続の喪失**：ログに `runner record gone server-side` または `poll auth failed` を含む `[runner:fatal]` の行が表示されます。ホストがスリープするなどしてランナーが Anthropic としばらく接続できなくなった場合、次に Anthropic に接続したときに終了することがあります。

ターンが終了しても、テストセッションは終了しません。最初のターンの後もセッションは接続されたままで、ランナーも稼働し続けているため、先にランナーを再起動することなく[セッションにフォローアップメッセージを送信](#send-a-follow-up-message-to-a-running-session)できます。

本番環境では、終了時にランナーを再起動し、ランナーが起動直後に終了し続ける場合は再起動間の待機時間を長くするオーケストレーターの下にデプロイしてください。[本番環境へのデプロイ](/docs/ja/self-hosted-environments-deploy)と[ランナーが終了する場合](/docs/ja/self-hosted-environments-deploy#when-the-runner-exits)を参照してください。

<h2 id="send-a-follow-up-message-to-a-running-session">
  実行中のセッションにフォローアップメッセージを送信する
</h2>

セッションが環境で実行されたら、`claude auth login` でログインしているマシンの `claude` CLI からフォローアップを送信します。コマンドはセッションを開始したマシンから実行する必要はありません。コマンドは 1 つのメッセージを投稿します。

```bash theme={null}
claude -p "your message" --cloud <session-id>
```

`<session-id>` については、ベアの `session_...` または `cse_...` ID またはセッションの claude.ai/code URL を渡します。成功した送信は `Sent to cloud session.` をセッション ID とビューリンク付きで出力します。受け入れられた ID フォーム、JSON 出力、およびアカウントとポリシー要件は[CLI からフォローアップを送信](/docs/ja/claude-code-on-the-web#send-follow-ups-from-the-cli)にあります。コマンドは Anthropic ホストされたセッションに対して同じように機能するためです。

<h2 id="what’s-next">
  次のステップ
</h2>

* [本番環境へのデプロイ](/docs/ja/self-hosted-environments-deploy)。デプロイメントを強化し、エグレスを制御し、git 認証情報を設定し、Kubernetes または Compose の下でフロートを実行します。
* [セッションをカスタマイズ](/docs/ja/self-hosted-environments-configuration)。ラッパースクリプト、ライフサイクルフック、オンデマンドランナー、MCP サーバー、および権限。
* [エンドツーエンドをテスト](/docs/ja/self-hosted-environments-testing)。セッションをディスパッチして Claude の返信を読む CI スモークテスト。
