> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# 自己ホスト環境

> 自分たちが管理するインフラストラクチャで Claude Code クラウドセッションを実行します。自己ホスト環境をセットアップし、ランナーをデプロイし、セッションを自分たちのコンピュートにルーティングします。

<Note>
  自己ホスト環境は Team および Enterprise プランでパブリックベータ版であり、デフォルトではオフになっています。有効化パスと除外される内容については、[利用可能性と制限事項](#availability-and-limitations)を参照してください。
</Note>

自己ホスト環境は、組織が運用するインフラストラクチャで Claude Code クラウドセッションを実行します。[クラウドセッション](/docs/ja/claude-code-on-the-web)は、開発者のマシン以外の場所で実行されるセッションです。開発者は claude.ai、モバイルおよびデスクトップアプリ、[`claude --cloud`](/docs/ja/claude-code-on-the-web#from-terminal-to-cloud)を使用したターミナル、および[スケジュール済みルーチン](/docs/ja/routines)から開始でき、デフォルトでは Anthropic のインフラストラクチャで実行されます。自己ホスト環境では、これらの同じセッションがネットワーク内で実行され、開発者体験は[利用可能性と制限事項](#availability-and-limitations)の違いとデプロイページの[既知の問題](/docs/ja/self-hosted-environments-deploy#known-issues-and-limitations)を除いて同じです。

チームがクラウドセッションを使用していない場合、ここで設定することはありません。ターミナルまたは IDE のセッションは常に開発者自身のマシンで実行されます。Claude Code を常時稼働しているマシンで実行し、他のデバイスから駆動したい場合は、[リモートコントロール](/docs/ja/remote-control)を使用してください。これは Pro および Max プランでも利用可能です。セットアップの準備ができたら、[クイックスタート](/docs/ja/self-hosted-environments-quickstart)に直接進んでください。セキュリティ体制を最初に確認したい場合は、[本番環境へのデプロイ](/docs/ja/self-hosted-environments-deploy)から始めてください。このページの残りの部分では、自己ホスティングの仕組みと、それを選択する時期について説明します。

<h2 id="how-self-hosted-environments-work">
  自己ホスト環境の仕組み
</h2>

自己ホスティングには 3 つの部分があります。

* **環境**: クラウドセッションを送信できる名前付きの宛先。組織は claude.ai 管理設定で環境を作成し、各環境はランナーのセットをグループ化します。
* **ランナー**: ネットワーク内のホストで実行されるプログラム。ランナーはセッションを実行します。概念は自己ホスト CI ランナーと同じです。
* **セッション**: 開発者が開始した 1 つの Claude Code タスク。

開発者がクラウドセッションを開始すると、セッション開始 UI に環境ピッカーが表示され、Anthropic ホスト環境と組織が作成した環境が一覧表示されます。組織の環境を選択すると、Anthropic のコントロールプレーンはセッションを環境のキューに配置し、ランナーがそれを要求し、開発者が選択したリポジトリをクローンし、ホストで Claude Code プロセスを開始して実行します。ランナーは設定した認証情報を使用して git ホストに認証します。[git の設定](/docs/ja/self-hosted-environments-deploy#configure-git)では、オプションについて説明しています。セッションはネットワーク内からの内部サービスに到達し、内部の場合は同じ方法で git ホストに到達します。Anthropic へのトラフィック（キューポーリング、セッションのイベントストリーム、およびデフォルトではモデル推論）は、`api.anthropic.com` への送信 HTTPS であり、セッションが到達できるその他のホストの短いリストは[ネットワーク要件](/docs/ja/self-hosted-environments-deploy#network-requirements)にあります。Anthropic はネットワークに接続することはありません。

<div style={{maxWidth: "640px", margin: "0 auto"}}>
  <Frame>
    <img src="https://mintcdn.com/claude-code/Y0sJ2uDoOVbOVZrQ/images/self-hosted-network-paths.svg?fit=max&auto=format&n=Y0sJ2uDoOVbOVZrQ&q=85&s=8056103fc1c5564c7f0ef219d260b99d" className="dark:hidden" alt="自己ホスト環境のアーキテクチャ図。ネットワーク境界内にはランナー、その内部の 2 つの Claude Code セッションプロセス、および git ホストが含まれており、api.anthropic.com の外側にはキュー、セッションストリーム、および推論があります。ランナーはキューをポーリングして git ホストに到達し、各セッションプロセスは独自のストリーム、推論、および git 接続を開き、すべての接続はネットワークからの送信であり、受信はありません。" width="680" height="320" data-path="images/self-hosted-network-paths.svg" />

    <img src="https://mintcdn.com/claude-code/Y0sJ2uDoOVbOVZrQ/images/self-hosted-network-paths-dark.svg?fit=max&auto=format&n=Y0sJ2uDoOVbOVZrQ&q=85&s=fec6aef3b0740d80eaf6d6a7000a2233" className="hidden dark:block" alt="自己ホスト環境のアーキテクチャ図。ネットワーク境界内にはランナー、その内部の 2 つの Claude Code セッションプロセス、および git ホストが含まれており、api.anthropic.com の外側にはキュー、セッションストリーム、および推論があります。ランナーはキューをポーリングして git ホストに到達し、各セッションプロセスは独自のストリーム、推論、および git 接続を開き、すべての接続はネットワークからの送信であり、受信はありません。" width="680" height="320" data-path="images/self-hosted-network-paths-dark.svg" />
  </Frame>
</div>

図の 2 つの Claude Code ボックスはセッションプロセスです。1 つのランナーが最大で設定容量まで 2 つのセッションを同時に実行しています。ランナーは一度に 1 つの[オーナー](#key-concepts)に対応し、最初のセッションを要求するときにそのオーナーにロックされるため、チェックアウトされたコードはオーナー間で混在しません。[ランナーのライフサイクル](#runner-lifecycle)では、このルールについて説明しています。

ランナーを自分で開始して実行し続けるか、ホストする[オートスケーリングオーケストレーター](/docs/ja/self-hosted-environments-configuration#on-demand-runners)（セッションがキューに入るときにランナーを開始する 2 番目のプロセス）を実行できます。各ランナーは作業が完了すると自動的に終了します。どちらの方法でも、環境を一度セットアップすると、サポートされているすべてのサーフェスのピッカーに表示されます。

<h2 id="availability-and-limitations">
  利用可能性と制限事項
</h2>

ロールアウトを計画する前に、これらを確認してください。

* **プラン**: Team および Enterprise 組織向けのパブリックベータ版。自己ホスト環境はデフォルトではオフになっています。[オーナー](/docs/ja/cloud-environments#organization-shared-environments)が[**クラウド環境**管理ページ](https://claude.ai/admin-settings/cloud-environments)で**自己ホスト環境を許可**をオンにします。これには、組織に対して[ウェブ上の Claude Code](/docs/ja/claude-code-on-the-web)が有効になっている必要があります。
* **ゼロデータ保持**: [ゼロデータ保持](/docs/ja/zero-data-retention)が有効になっている組織では利用できません。
* **モデル推論**: ランナーを [Amazon Bedrock または Google Cloud の Agent Platform にモデルリクエストを送信する](/docs/ja/self-hosted-environments-configuration#send-model-requests-to-bedrock-or-agent-platform)ように構成しない限り、セッションは Anthropic API を使用します。いずれの場合も、セッションのコンテンツは Anthropic に送信されます。このように構成されたランナーでは、claude.ai の[サーバー管理設定](/docs/ja/server-managed-settings)と組織ポリシーはセッションに適用されません。
* **サーフェス**: [claude.ai/code](https://claude.ai/code)、モバイルおよびデスクトップアプリ、[スケジュール済みルーチン](/docs/ja/routines)、およびターミナルから開始されたセッション（[`claude --cloud`](/docs/ja/claude-code-on-the-web#from-terminal-to-cloud)または[`--environment`ディスパッチ](/docs/ja/self-hosted-environments-testing#run-the-test-loop)を使用）は、自己ホスト環境で実行できます。[Claude Tag](https://claude.com/docs/claude-tag/overview)セッションもそれらで実行できますが、Claude はまだそれらのセッションで[アクセスバンドル](https://claude.com/docs/claude-tag/concepts/glossary#access-bundle)を使用できません。[Claude Security](/docs/ja/claude-security)および[Code Review](/docs/ja/code-review)セッションはまだそれらにルーティングされません。これら 2 つのサーフェスのサポートは別途提供されます。
* **リポジトリ**: セッションは GitHub からリポジトリをチェックアウトします。[GitHub 認証オプション](/docs/ja/claude-code-on-the-web#github-authentication-options)を参照してください。GitHub Enterprise Server ホストについては、その[ネットワーク要件](/docs/ja/github-enterprise-server#network-requirements)を参照してください。
* **請求**: 自己ホスト環境のセッションは、Anthropic ホスト環境のセッションと同じ方法で組織の Claude Code 使用量を消費します。

<h2 id="why-self-host">
  自己ホスティングを選ぶ理由
</h2>

ほとんどのチームは、実行または保守するインフラストラクチャが不要な Anthropic ホスト環境の方が適しています。自己ホスティングは、ネットワーク、ツール、またはコンプライアンス要件により、セッション実行を管理するインフラストラクチャに保つ必要があるチーム向けです。その場合、運用上の所有権を計画してください。ランナーイメージを構築および保守し、フリートを運用し、ネットワークを制御します。

その代わりに、自己ホスティングはネットワークアクセス、カスタムツール、およびコンプライアンス制御を提供します。

* **ネットワークアクセス**: セッションはネットワーク内で実行され、内部サービス、データベース、およびレジストリに到達でき、それらをパブリックインターネットに公開する必要がありません。
* **カスタムツール**: コンパイラ、SDK、および内部 CLI をランナーイメージにプリインストールして、すべてのセッションが構築の準備ができた状態で開始されるようにします。
* **コンプライアンス**: リポジトリのチェックアウトとビルドアーティファクトは、管理するインフラストラクチャに保たれます。ただし、セッションコンテンツは引き続き `api.anthropic.com` に送信されます。

<h2 id="environments-runners-and-sessions">
  環境、ランナー、セッション
</h2>

環境は claude.ai の管理設定にある **Cloud environments** ページで管理します。ランナーは、ユーザーが自身のインフラストラクチャ上で起動・管理するプロセスです。

<h3 id="key-concepts">
  主要な概念
</h3>

以下の用語はセルフホスト関連のページ全体で使われます。

| 用語 | 説明 |
| :- | :- |
| 環境 | claude.ai の設定で作成する、ランナーの名前付きグループです。セッションは個々のランナーではなく、環境にルーティングされます。 |
| 環境シークレット | ランナーが環境に対して認証・登録する際に使用する、共有の単一の認証情報です。環境の作成時に一度だけ表示され、管理 UI では **environment key** というラベルで表示されます。 |
| ランナー | デプロイする長時間稼働のプロセスです。ランナーは環境に登録し、ランナートークンを受け取り、セッションをポーリングします。 |
| セッション | claude.ai、モバイルアプリ、またはスケジュールされたルーティンやエージェントなどの他の Anthropic サーフェスから開始される、1 つの Claude Code タスクです。各セッションは、ランナーが生成する子 Claude Code プロセスとして実行されます。 |

API のフィールド、トークンのクレーム、メトリクス名では、環境は `pool` として表記され、環境 ID は `pool_id` です。[リファレンス](/docs/ja/self-hosted-environments-reference)では、非推奨の `pool` フラグ名を含め、2 つの表記の対応を示しています。

ランナーは一度に 1 人のオーナーにのみサービスを提供します。ランナーが最初に取得したセッションによって、ランナーはそのセッションのオーナーにロックされ、以降は設定された容量の範囲内で、そのオーナーのセッションのみを実行します。オーナーが誰になるかは、セッションの開始方法によって異なります。

* **ユーザーが開始したセッション**：オーナーはそのユーザーのアカウントです。
* **Claude Tag チャネルセッション**：Claude はユーザーアカウントを紐付けずにこれらを実行するため、オーナーはセッションを開始した [Claude Tag エージェント](https://claude.com/docs/claude-tag/concepts/glossary#agent-identity)になります。そのエージェントが開始するチャネルセッションは、誰が Slack メッセージを送信したかにかかわらず、すべて同じオーナーを持ちます。そのため、`--capacity` を 1 より大きくするか、`--drain-grace-sec` を正の値にして実行した場合、このエージェントにロックされたランナーは、異なるユーザーが開始したセッションも処理します。

したがって、フリートの最小サイズは、同時にアクティブになると想定されるオーナーの数（ユーザーと Claude Tag エージェントを合わせた数）になります。

<h3 id="session-lifecycle">
  セッションのライフサイクル
</h3>

開発者がセッションを開始して環境を選択すると、Anthropic のコントロールプレーンはそのセッションを環境のキューに配置します。その後の流れは次のとおりです。

1. 空き容量のあるランナーがセッションを取得し、そのリースを保持します。
2. ランナーはリポジトリを作業ディレクトリにクローンし、子 Claude Code プロセスを生成します。
3. 子プロセスは HTTPS 経由でイベントをストリーミングし、その間ランナーはポーリングを続けます。各ポーリングはリースを更新し、ハートビートも兼ねます。
4. ランナーがポーリングを停止すると、リースは約 60 秒後に失効し、サーバーは数分以内にそのセッションを別のランナー向けに再度キューに入れます。

ランナーは各ポーリングリクエストに 10 秒を割り当てます。リクエストがタイムアウトした場合、失われた場合、またはランナーが解析できないレスポンスを受け取った場合、ランナーは稼働中のセッションの処理を続け、次のスケジュールされたポーリングを待たずに 1〜2 秒後に再試行します。たとえば、ポーリングに対して独自のページを返すインターセプトプロキシは、ランナーが解析できないレスポンスを生成します。リクエストがこのいずれかの形で失敗するたびに、ランナーは次の再試行までの間隔を最大 20 秒まで倍増させ、リースの期限が近づくと間隔を短縮します。

<h3 id="runner-lifecycle">
  ランナーのライフサイクル
</h3>

ランナーが最初に取得したセッションによって、ランナーはそのセッションのオーナーにロックされ、そのオーナーのセッションを最大 `--capacity` 件まで同時に実行します。ランナーにアクティブなセッションがあり、シャットダウンシグナルを受信しておらず、リタイア時刻にも達していない間は、ランナーはロックされたオーナーのキューにある作業を取得し続けます。それらのセッションが終了した後の動作は [`--drain-grace-sec`](/docs/ja/self-hosted-environments-reference#runner-cli-flags) によって異なります。

* **デフォルトの `0` の場合**：ランナーはアクティブなセッションが終了するとすぐに、追加のポーリングを行わずに終了します。これにより、Kubernetes などランナーをデプロイしているオーケストレーターが、新しいディスクでランナーを再起動し、任意のオーナーにサービスを提供できる状態にできます。
* **正の値の場合**：ランナーは終了する前に、その秒数だけロックされたオーナーのキューをポーリングし続けます。

このライフサイクルにより、オーナー間でランナーがディスクの状態を削除しなくても、各オーナーのチェックアウトされたコードが分離されます。

`--retire-at` が必要かどうかは、インフラストラクチャがランナーをどのように停止するかによって決まります。`SIGTERM` を送信する kill の場合、フラグは不要です。ランナーは[シャットダウンのタイミング](/docs/ja/self-hosted-environments-deploy#shutdown-timing)で説明されているとおりにドレインするか、[`--defer-shutdown-max-min`](/docs/ja/self-hosted-environments-deploy#defer-the-drain-past-the-first-signal) を設定している場合は、すでに保持しているセッションの処理を続けます。一方、サンドボックスの存続期間の上限やスポットインスタンスの回収など、インフラストラクチャがシグナルなしで、またはドレインするには短すぎる猶予期間で、既知の時刻にホストを破棄する場合は、その時刻の数分前に設定した `--retire-at <epoch-seconds>` を渡してください。リタイア時刻になると、次のように動作します。

1. ランナーは新しい作業の受け付けを停止します。
2. ランナーは、[`--release-idle-session-min`](/docs/ja/self-hosted-environments-reference#runner-cli-flags) フラグが使用するのと同じリリース経路を通じて各アクティブセッションをリリースします。これにより、ユーザーが次のメッセージを送信したときに、セッションは新しいランナー上で再開されます。ランナーが各セッションをリリースするタイミングは、そのセッションの状態によって異なります。
   * ターンの途中にあるセッションは、そのターンが終了した後にリリースされます。ランナーはまず、セッションのプロセスがターンの終了を Anthropic に報告するのを待ちますが、待機時間は [`SELF_HOSTED_RUNNER_POST_TURN_SETTLE_MS`](/docs/ja/self-hosted-environments-reference#environment-variable-only-settings) を超えません。v2.1.280 より前は、ターンが終了するとすぐにセッションをリリースしていました。
   * ターンが終了してもバックグラウンドタスクが実行中のままの場合、ランナーは最大 60 秒間それらを待ち、まだ実行中であってもセッションをリリースします。タスクが終了していても、その結果を読み取る後続のターンがまだ実行されていない場合、ランナーはそのターンが終了するまでセッションを保持します。そのターンの開始を待つ時間は、最長でも [`SELF_HOSTED_RUNNER_BG_RESULT_GRACE_MS`](/docs/ja/self-hosted-environments-reference#environment-variable-only-settings) までです。
3. すべてのセッションがリリースされると、ランナーは終了コード 0 で終了します。

kill の時点を過ぎても続くターンは失われます。マージンの見積もりについては[シャットダウンのタイミング](/docs/ja/self-hosted-environments-deploy#shutdown-timing)を参照してください。`--retire-at` を指定しない場合、シグナルなしのホスト kill はクラッシュと区別できません。コントロールプレーンはクリーンなリリースではなくワーカーの喪失として記録し、セッションは別のランナーに再度キューイングされます。

<h3 id="network-paths">
  ネットワーク経路
</h3>

ランナーとそのセッションは数種類のアウトバウンド接続を行いますが、Anthropic からのインバウンド接続は必要ありません。

* **コントロールプレーン**：ランナーは `api.anthropic.com` をポーリングして作業を取得し、セットアップの進行状況や失敗のイベントを送信します。これらはすべてアウトバウンドの HTTPS です。ポーリングはランナーのハートビートも兼ねます。
* **SCM コネクタ**：オプションのオーケストレーター [SCM コネクタ](/docs/ja/self-hosted-environments-reference#scm-connector-flags)のトンネルが、唯一の WebSocket 接続です。
* **Git**：ランナーは、デプロイによって提供される認証情報で認証し、HTTPS または SSH 経由で git ホストからクローンおよびプッシュを行います。[git の設定](/docs/ja/self-hosted-environments-deploy#configure-git)では、セッションごとに発行される認証情報や、git を代わりに `api.anthropic.com` 経由でルーティングする [Anthropic git プロキシ](/docs/ja/self-hosted-environments-deploy#use-the-anthropic-git-proxy)を含むオプションについて説明しています。
* **セッションの子プロセス**：子 Claude Code プロセスは `api.anthropic.com` へのセッションのイベントストリームを保持し、モデル推論とセッション中に実行される git コマンドのために独自のアウトバウンド呼び出しを行います。エグレスの完全な一覧については[ネットワーク要件](/docs/ja/self-hosted-environments-deploy#network-requirements)を参照してください。[上の図](#how-self-hosted-environments-work)は、オプションの SCM コネクタを除くこれらの経路を示しています。

デフォルトでは、モデル推論には Anthropic API を使用します。コントロールプレーンは各セッションに API エンドポイントを渡し、セッションは Anthropic が発行したセッションスコープの OAuth トークンで認証します。モデルリクエストを代わりに自社のクラウドアカウントに送信する方法については、[モデルリクエストを Bedrock または Agent Platform に送信する](/docs/ja/self-hosted-environments-configuration#send-model-requests-to-bedrock-or-agent-platform)を参照してください。

企業のエグレスプロキシもサポートされています。ランナーとオプションの[オートスケーリングオーケストレーター](/docs/ja/self-hosted-environments-configuration#on-demand-runners)は、`HTTPS_PROXY` や `NO_PROXY` など、[ネットワーク設定](/docs/ja/network-config)で説明されているプロキシおよび mTLS の環境変数に従います。これらは各プロセスの環境で設定してください。これらの変数は、コントロールプレーンへの呼び出し、オーケストレーターの [SCM コネクタ](/docs/ja/self-hosted-environments-reference#scm-connector-flags)の WebSocket、および HTTPS リモートの組み込みクローンに適用され、セッションはランナーからこれらを継承します。セッションのストリーミングは HTTPS 上の server-sent events を使用するため、経路上のプロキシはレスポンスをバッファリングしてはいけません。

プロキシで `Proxy-Authorization` ヘッダーも必要な場合、ランナーはプロキシに対して開く各接続にそのヘッダーを追加できます。[エグレスプロキシへの認証](/docs/ja/self-hosted-environments-deploy#authenticate-to-an-egress-proxy)を参照してください。

<h2 id="what-stays-on-your-infrastructure">
  インフラストラクチャに保たれるもの
</h2>

リポジトリのチェックアウト、ビルドアーティファクト、シークレット、およびセッションが作成または変更するファイルは、プロビジョニングしたマシンに保たれます。会話自体（プロンプト、応答、ツール結果を含む）は `api.anthropic.com` に送信され、Anthropic はセッショントランスクリプトを保存して、別の[サポートされているサーフェス](#availability-and-limitations)からセッションを再開できるようにします。ランナーが[モデルリクエストを Amazon Bedrock または Google Cloud の Agent Platform に送信する](/docs/ja/self-hosted-environments-configuration#send-model-requests-to-bedrock-or-agent-platform)場合でも、会話はセッションのイベントストリーム内で引き続き `api.anthropic.com` に送信されます。

自己ホスト環境はセッション実行をネットワークに移動させます。コントロールプレーンは Anthropic ホスト型のままです。セッションオーケストレーション、キューイング、および claude.ai インターフェースは Anthropic のインフラストラクチャで実行され続けます。

<h2 id="get-started">
  開始する
</h2>

自己ホスト環境ページは、実行している内容によって整理されています。

* [クイックスタート](/docs/ja/self-hosted-environments-quickstart): Claude Code をインストールし、環境を作成し、ランナーを開始し、最初のセッションをルーティングします。
* [本番環境へのデプロイ](/docs/ja/self-hosted-environments-deploy): セキュリティ強化、ネットワーク送信、git 認証情報、Kubernetes および Compose レシピ、既知の問題、およびトラブルシューティング
* [セッションをカスタマイズ](/docs/ja/self-hosted-environments-configuration): セッションごとの認証情報、ライフサイクルフック、オンデマンドランナー、MCP サーバー、および権限のためのラッパースクリプト
* [エンドツーエンドをテスト](/docs/ja/self-hosted-environments-testing): ランナーイメージをプロモーション前に検証する CI スモークテスト
* [リファレンス](/docs/ja/self-hosted-environments-reference): すべての CLI フラグ、環境変数、メトリック、およびヘルスエンドポイント
* [セッション ID を検証](/docs/ja/self-hosted-environments-identity): 独自のサービスからセッショントークンを検証してから、アクセスを許可します。
