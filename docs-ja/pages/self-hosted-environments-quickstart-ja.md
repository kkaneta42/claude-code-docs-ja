> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# セルフホストされた環境のクイックスタート

> セルフホストされた環境を初めてセットアップします。Claude Code をインストールし、環境を作成し、ランナーを起動し、セッションをルーティングします。

> [!NOTE]
>
> セルフホストされた環境は Team および Enterprise プランでパブリックベータ版です。[利用可能性と制限事項](https://code.claude.com/docs/ja/self-hosted-environments#availability-and-limitations)は有効化パスをカバーしています。このページは最初のセッションを実行します。詳細は[セルフホストされた環境](https://code.claude.com/docs/ja/self-hosted-environments)を参照し、本番環境へのデプロイについては[本番環境へのデプロイ](https://code.claude.com/docs/ja/self-hosted-environments-deploy.md)を参照してください。

[セルフホストされた環境](https://code.claude.com/docs/ja/self-hosted-environments)は、Claude Code の[クラウドセッション](https://code.claude.com/docs/ja/claude-code-on-the-web.md)を、組織が運用するインフラストラクチャ上で実行し、デプロイするランナープロセスによって実行されます。このクイックスタートは最初のセットアップを行います。最小限の構成は、単一ホスト上の 1 つのランナーで 1 つのテストセッションを実行することです。2 つのステップがあります。[環境とランナーを作成し、セッションをルーティングする](#set-up-an-environment-and-runner)、その後[実行中のセッションにターミナルからメッセージを送信する](#send-a-follow-up-message-to-a-running-session)。2 つのサーフェス間を移動します。claude.ai は環境の作成、ステータスの確認、セッションのルーティング用で、ホスト上のターミナルはランナーが行うすべてのことに使用します。

終了時には、[**Cloud environments** 管理ページ](https://claude.ai/admin-settings/cloud-environments)に環境があり、ランナーが仕事をポーリングしており、セッションがホスト上で実行されています。実際のリポジトリまたは内部システムを接続する前に、[本番環境へのデプロイ](https://code.claude.com/docs/ja/self-hosted-environments-deploy.md)を実行してください。これはセキュリティ体制、エグレス制御、git 認証情報、およびオーケストレーションをカバーしています。

## 前提条件

### 組織とロール

claude.ai 側には以下が必要です。

* **セルフホストされた環境を許可**は、[**Cloud environments** 管理ページ](https://claude.ai/admin-settings/cloud-environments)で[オーナー](https://code.claude.com/docs/ja/cloud-environments.md#organization-shared-environments)によってオンにされます。**新規**ボタンはそれがオンになるまで表示されません。ロールを保持していない場合、保持している人が環境を作成してシークレットを渡すことができます。このページのランナーとターミナルのステップには claude.ai ロールは不要です。ステップが管理 UI でステータスをチェックする場合、ランナー自身のログ行が同じシグナルを提供します。
* オーナーによってオンにされた [GitHub コネクタ](https://claude.ai/admin-settings/connectors)と、各開発者自身の [GitHub 接続](https://code.claude.com/docs/ja/web-quickstart.md#connect-github)。これにより、開発者はセッションを開始するときに github.com のリポジトリを選択できます。

### ホストとネットワーク

ランナーホストには以下が必要です。

* `api.anthropic.com`、`claude.ai` および以下のインストールステップ用のダウンロードホストへのアウトバウンド HTTPS、および git ホストへのクローン用の Linux または macOS ホストまたはコンテナ。[ネットワーク要件テーブル](https://code.claude.com/docs/ja/self-hosted-environments-deploy.md#network-requirements)に完全なリストがあります。Windows はランナーホストとしてサポートされていません。代わりに Linux コンテナでランナーを実行してください。セッションは claude.ai のブラウザから開始されるため、開発者ワークステーションは影響を受けません。
* テストセッション用のリポジトリ。公開リポジトリ、またはこのホストが認証情報を求められることなく HTTPS URL で既にクローンできるリポジトリを用意してください。ランナーはリポジトリの `https://` URL をクローンするため、SSH キーだけでは不十分です。代わりに SSH 経由でクローンするには、[プライベートネットワーク用に git URL を書き換える](https://code.claude.com/docs/ja/self-hosted-environments-deploy.md#rewrite-git-urls-for-private-networks)を参照してください。
* NTP などで実時間に同期されたクロック。クロックが 5 分以上ずれていると認証が失敗します。[トラブルシューティング](https://code.claude.com/docs/ja/self-hosted-environments-deploy.md#troubleshooting)を参照してください。

### ランナーホスト上のソフトウェア

開始する前にホストにインストールしてください。

* **Claude Code v2.1.224 以降**。[標準インストール方法](https://code.claude.com/docs/ja/setup.md)のいずれかを使用します。ランナーは標準 `claude` バイナリの一部であり、以前のバージョンは `self-hosted-runner` サブコマンドを認識しません。Claude Tag セッションを処理するランナーには、v2.1.229 以降と `PATH` 上の `python3` が必要です。これらのセッション用に[コントロールプレーンが提供するフック](https://code.claude.com/docs/ja/self-hosted-environments-configuration.md#how-each-session’s-config-is-assembled)が `python3` を実行するためです。フリートが実行する正確なバージョンをピンするには、[特定のバージョンをインストール](https://code.claude.com/docs/ja/setup.md#install-a-specific-version)を参照してください。コンテナイメージについては、[本番環境へのデプロイ](https://code.claude.com/docs/ja/self-hosted-environments-deploy.md#build-the-runner-image)の Dockerfile を参照してください。
* **Git 2.24 以降**。デプロイページの一部の git オプションはより新しいバージョンが必要です。[git を設定](https://code.claude.com/docs/ja/self-hosted-environments-deploy.md#configure-git)は各フロアを記載しています。

ホストの準備ができていることを確認します。

```bash theme={null}
claude self-hosted-runner --help
```

準備ができたホストはランナーの使用テキストを出力し、`--environment-secret-file` などのフラグをリストします。2.1.224 より古いバージョンでは、コマンドは代わりに一般的な `claude --help` 出力を出力します。この出力が表示された場合は、[Claude Code を更新](https://code.claude.com/docs/ja/setup.md#update-claude-code)してください。コンテナイメージから `claude` を実行している場合は、バージョン 2.1.224 以降で[イメージを再ビルド](https://code.claude.com/docs/ja/self-hosted-environments-deploy.md#build-the-runner-image)してください。

## 環境とランナーをセットアップする

[ガイド付きセットアップ](#run-the-guided-setup)または[手動手順](#set-up-manually)のいずれかを使用します。ガイド付きセットアップは、インタラクティブな Claude Code セッションを開始して残りの手順を案内する単一のコマンドです。インタラクティブセッションが不可能なホストでは、代わりに手動手順を使用してください。Owner ロールを持つユーザーが環境を作成してそのシークレットを渡した場合も、手動手順を使用してください。ガイド付きセットアップには Owner としてのサインインが必要なためです。

### ガイド付きセットアップを実行する

ガイド付きセットアップは、管理 UI で環境を作成する手順を案内し、保存したシークレットファイルを使用してローカルランナーを起動し、ランナーが登録されたことを確認し、`./runner-setup/CHEAT-SHEET.md` にチートシートを書き込みます。実行する前に、サインインとバージョンを確認してください。

* **サインイン**：Owner ロールを持つアカウントを使用して `claude auth login` でサインインしたマシンで実行してください。API キーまたはサードパーティのモデルプロバイダーのみの場合、セッションは開始されますが、組織のチェックに失敗します。
* **バージョン**：[バージョンチェック](#software-on-the-runner-host)が成功したことを確認してください。2.1.224 より古いバージョンでは、setup コマンドはガイド付きセットアップではなく、単語をプロンプトとして使用する Claude セッションを開始します。

ガイド付きセットアップを開始するには、シェルで setup サブコマンドを実行してプロンプトに従ってください。

```bash theme={null}
claude self-hosted-runner setup
```

セットアップ自体はテストセッションを開始しません。claude.ai/code でテストセッションを開始するよう案内されます。セットアップの最後のステップでは、セットアップが起動したランナーを停止します。そのステップの前にセットアップを終了した場合、ランナーは実行を続けます。最後のステップの後も続行するには、`./runner-setup/CHEAT-SHEET.md` に記載されたコマンドを使用してシェルでランナーを再度起動し、[セッションを環境にルーティング](#route-a-session)してください。

### 手動でセットアップする

claude.ai で環境を作成し、ホスト上のターミナルからランナーを起動してから、claude.ai に戻ってランナーが表示されることを確認し、セッションをランナーにルーティングします。Owner ロールを持つユーザーが既に環境を作成してそのシークレットを渡している場合は、ステップ 2 から開始してください。

**1. 環境を作成する**

管理設定の [**Cloud environments** ページ](https://claude.ai/admin-settings/cloud-environments) に移動します。**Self-hosted environments** の下で、**New** を選択し、環境に名前を付けて、**Create** を選択します。ウィザードの 2 番目のステップで、**Copy environment key** を選択して環境シークレットをコピーします。管理 UI はこれを環境キーとしてラベル付けしています。claude.ai はシークレットを 1 回だけ表示し、後で取得することはできません。シークレットは作成から 365 日後に期限切れになります。環境の `ccpool_...` ID は詳細ダイアログに表示されたままになります。これは、[トークン検証](https://code.claude.com/docs/ja/self-hosted-environments-identity.md)の `aud` チェックと、[CI からのテストセッションのディスパッチ](https://code.claude.com/docs/ja/self-hosted-environments-testing.md#run-the-test-loop)に必要です。

シークレットを紛失した場合、またはローテーションが必要な場合は、環境の **Configuration** タブから新しいシークレットを作成し、新しいシークレットをランナーにロールアウトしてから、古いシークレットを取り消します。取り消されたシークレットを保持しているランナーは、次の認証済みポーリングに失敗して終了し、`poll auth failed` をログに記録します。オーケストレーターは新しいシークレットでランナーを再起動します。

**2. ランナーを起動する**

シークレットディレクトリを作成します。このコマンドと次のコマンドは `/etc/claude` を使用するため root が必要です。また、これらのコマンドで作成されるシークレットファイルは、コマンドを実行したユーザーのみが読み取ることができます。ランナーを別のユーザーとして実行する場合、ランナーは `error: Failed to read environment secret file <path> (EACCES: permission denied, open '<path>')` で終了します。その場合は、`/etc/claude` の代わりにランナーのユーザーが書き込めるディレクトリを使用して両方のコマンドをランナーのユーザーとして実行し、同じパスを `--environment-secret-file` に渡してください。ランナープロセスが読み取ることができるパスであれば、どのパスでも機能します。

```bash theme={null}
mkdir -p /etc/claude
```

環境シークレットをファイルに書き込みます。以下のコマンドはターミナルから読み取るため、シークレットはシェル履歴から除外されます。コピーした値を貼り付け、Enter キーを押してから Ctrl-D を押します。サブシェルの `umask` により、ファイルは所有者のみが読み取ることができます。

```bash theme={null}
(umask 077 && cat > /etc/claude/environment-secret)
```

ベースディレクトリを選択し、以下のランナーコマンドの `<writable-dir>` を、ランナーが書き込みまたは作成できる絶対パスに置き換えます。ランナーは起動時にディレクトリを作成し、リポジトリをチェックアウトして、その下にセッションごとのディレクトリを作成します。`--base-dir` がない場合、`/workspace` を使用します。これは、そのディレクトリが既に存在し、書き込み可能であるか、ランナーを root として起動する場合にのみ機能します。

> [!WARNING]
>
> ホームディレクトリや自分のクローンを置いているディレクトリではなく、ランナー専用のディレクトリを使用してください。ランナーは `<writable-dir>/<repo-owner>/<repo>` にあるものを自身のクローンとして扱い、それをリセットしたり、その中のファイルを上書きまたは削除したりすることがあります。

ランナーがベースディレクトリを作成または書き込みできない場合、登録されずに、起動時にそのディレクトリ名を示すエラーで終了します。[トラブルシューティング](https://code.claude.com/docs/ja/self-hosted-environments-deploy.md#troubleshooting)を参照してください。

次に、`--environment-secret-file` と `--base-dir` を使用してランナーを起動します。

```bash theme={null}
claude self-hosted-runner --environment-secret-file '/etc/claude/environment-secret' --base-dir '<writable-dir>'
```

ランナーは環境に登録されると `Registered: runner_id=<runner-id>` をログに記録し、作業のポーリングを開始します。このコマンドで起動した場合、ランナーは設計上、ターンごとではなく 1 つのセッションを処理した後に終了します。さらに多くのセッションを処理するには、ランナーが終了するたびに再度起動してください。これが発生する状況とランナーがログに記録する内容については、[ランナーが終了した場合](#if-the-runner-exits)を参照してください。

**3. ランナーが表示されることを確認する**

[**Cloud environments** ページ](https://claude.ai/admin-settings/cloud-environments)に戻ります。環境のステータスは、ランナーが起動してから数秒以内に **No runners deployed** から **Healthy** に変わります。環境を開いて **Activity** を選択すると、ランナー自体が表示されます。管理ページにアクセスできない場合は、前のステップのランナーのログにある `Registered: runner_id=<runner-id>` の行で同じことを確認できます。

**4. セッションを環境にルーティングする**

claude.ai/code でセッションを開始し、環境ピッカーから環境を選択します。セルフホスト環境は Anthropic ホスト環境と並んで表示されます。リポジトリには、[前提条件](#host-and-network)で用意したもの、つまり公開リポジトリ、またはこのホストが認証情報を求められることなく HTTPS URL で既にクローンできるリポジトリを選択してください。

次に利用可能なランナーがキューに入ったセッションを取得し、`Picked up session <session-id>` をアクティブカウントと容量とともにログに記録します。ランナー自身の出力からどのホストがセッションを取得したかを確認できます。[claude.ai/code](https://claude.ai/code) でセッションの動作を監視し、Claude の返信を読んでください。

セッションが動作を開始しない場合は、表示される状況に応じて対処してください。

* **セッションがキューに入ったままになる**：[トラブルシューティング](https://code.claude.com/docs/ja/self-hosted-environments-deploy.md#troubleshooting)を参照してください。
* **セッションが git エラーで開始に失敗する**：エラーに git の `could not read Username for` に続いて git ホストの URL が含まれている場合、ランナーにはそのホストの HTTPS 認証情報がありませんでした。
  * **HTTPS 認証情報を指定する**：[git を設定する](https://code.claude.com/docs/ja/self-hosted-environments-deploy.md#configure-git)を参照してください
  * **代わりに SSH でクローンする**：ランナーホストに既に SSH キーがある場合は、[プライベートネットワーク向けに git URL を書き換える](https://code.claude.com/docs/ja/self-hosted-environments-deploy.md#rewrite-git-urls-for-private-networks)を参照してください
  * **いずれかの修正の後**：ランナーを再度起動し、新しいセッションを開始するのではなく、失敗したセッションを監視してください。何度も失敗している場合は、ランナーが `Picked up session` をログに記録するまで数分待ってください。
  * **代わりに別のリポジトリを使用する場合**：失敗したセッションを[アーカイブ](https://code.claude.com/docs/ja/claude-code-on-the-web.md#archive-sessions)または[削除](https://code.claude.com/docs/ja/claude-code-on-the-web.md#delete-sessions)してから、ランナーを再度起動して新しいセッションを開始してください。そうしないと、ランナーが新しいセッションではなく失敗したセッションを取得することがあります。

### ランナーが終了した場合

このクイックスタートの途中でランナーが終了した場合は、再度起動してください。ランナーは自ら終了することがあります。

* **実行中のものがなくなった**：ログに `[runner:exit] account workload drained — exiting` が表示されます。ランナーは、セッションを実行しなくなると[設計上終了します](https://code.claude.com/docs/ja/self-hosted-environments#runner-lifecycle)。例：
  * **セッションをアーカイブまたは削除した**：ランナーを再度起動してください
  * **セッションの開始に失敗した**：[原因を修正](#session-doesnt-start)してから、ランナーを再度起動してください
* **接続の喪失**：ログに `runner record gone server-side` または `poll auth failed` を含む `[runner:fatal]` の行が表示されます。ホストがスリープするなどしてランナーが Anthropic としばらく接続できなくなった場合、次に Anthropic に接続したときに終了することがあります。

ターンが終了しても、テストセッションは終了しません。最初のターンの後もセッションは接続されたままで、ランナーも稼働し続けているため、先にランナーを再起動することなく[セッションにフォローアップメッセージを送信](#send-a-follow-up-message-to-a-running-session)できます。

本番環境では、終了時にランナーを再起動し、ランナーが起動直後に終了し続ける場合は再起動間の待機時間を長くするオーケストレーターの下にデプロイしてください。[本番環境へのデプロイ](https://code.claude.com/docs/ja/self-hosted-environments-deploy.md)と[ランナーが終了する場合](https://code.claude.com/docs/ja/self-hosted-environments-deploy.md#when-the-runner-exits)を参照してください。

## 実行中のセッションにフォローアップメッセージを送信する

セッションが環境で実行されたら、`claude auth login` でログインしているマシンの `claude` CLI からフォローアップを送信します。コマンドはセッションを開始したマシンから実行する必要はありません。コマンドは 1 つのメッセージを投稿します。

```bash theme={null}
claude -p "your message" --cloud <session-id>
```

`<session-id>` については、ベアの `session_...` または `cse_...` ID またはセッションの claude.ai/code URL を渡します。成功した送信は `Sent to cloud session.` をセッション ID とビューリンク付きで出力します。受け入れられた ID フォーム、JSON 出力、およびアカウントとポリシー要件は[CLI からフォローアップを送信](https://code.claude.com/docs/ja/claude-code-on-the-web.md#send-follow-ups-from-the-cli)にあります。コマンドは Anthropic ホストされたセッションに対して同じように機能するためです。

## 次のステップ

* [本番環境へのデプロイ](https://code.claude.com/docs/ja/self-hosted-environments-deploy.md)。デプロイメントを強化し、エグレスを制御し、git 認証情報を設定し、Kubernetes または Compose の下でフロートを実行します。
* [セッションをカスタマイズ](https://code.claude.com/docs/ja/self-hosted-environments-configuration.md)。ラッパースクリプト、ライフサイクルフック、オンデマンドランナー、MCP サーバー、および権限。
* [エンドツーエンドをテスト](https://code.claude.com/docs/ja/self-hosted-environments-testing.md)。セッションをディスパッチして Claude の返信を読む CI スモークテスト。
