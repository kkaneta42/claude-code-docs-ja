> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# 本番環境へのセルフホスト環境のデプロイ

> 本番環境でセルフホストランナーを実行する：セキュリティ強化、ネットワーク出力制御、git 認証情報、Kubernetes と Compose レシピ、トラブルシューティング。

> [!NOTE]
>
> セルフホスト環境は Team および Enterprise プランで公開ベータ版です。[利用可能性と制限事項](https://code.claude.com/docs/ja/self-hosted-environments#availability-and-limitations)では有効化パスについて説明しています。このページではフリートを本番環境で実行する方法について説明します。最初のランナーとセッションについては[クイックスタート](https://code.claude.com/docs/ja/self-hosted-environments-quickstart.md)を参照してください。

[セルフホスト環境](https://code.claude.com/docs/ja/self-hosted-environments)は、ネットワーク内にデプロイしたランナー上で Claude Code [クラウドセッション](https://code.claude.com/docs/ja/claude-code-on-the-web.md)を実行し、本番環境ではそれらのセッションが環境にセッションをディスパッチできるすべてのユーザーに代わってモデル指向のコードを実行します。このページは、動作している環境を本番環境に移行するオペレーター向けです。デプロイメントを順番に説明します：実際のシステムに接続する前にロックダウンすべき内容、フリートが必要とする出力、セッションが git ホストに認証する方法、デプロイメントレシピ自体、セッションが不正に動作する場合に確認すべき内容です。

## デプロイを強化する

セルフホストランナーは、環境にセッションをディスパッチできるすべてのユーザーに代わって、インフラストラクチャ上で任意のモデル指向のコードを実行します。これは Anthropic 組織のすべてのメンバーと、Owner が環境にルーティングしたスコープで [Claude Tag](https://claude.com/docs/claude-tag/overview) チャネルセッションを開始できるすべてのユーザーです。本番環境システムに環境を接続する前に、各項目を確認してください：

* **エフェメラルなセッションごとのコンテナ**：各ランナープロセスを、プロセスが終了するときに破棄される新しいコンテナまたは VM で実行します。`--capacity 1` とデフォルトの `--drain-grace-sec 0` を使用して、各コンテナが正確に 1 つのセッションを処理するようにします。容量が高い場合、またはドレイングレースが正の場合、1 つのコンテナが同じ[ロックされたオーナー](https://code.claude.com/docs/ja/self-hosted-environments#key-concepts)からの複数のセッションを処理します。[ランナーのライフサイクル](https://code.claude.com/docs/ja/self-hosted-environments#runner-lifecycle)を参照してください。ランナーの再起動間でファイルシステムを再利用しないでください。ただし、意図的な[プリウォーミングされたチェックアウト](#reuse-a-pre-warmed-checkout)セットアップは除きます。また、オーナー間では再利用しないでください。
  * ランナーがセッションを停止するとき、シェルコマンドの終了後も実行を続けているプロセス（デーモン化したサービスなど）にはシグナルを送信しません。コンテナまたは VM を破棄すると、そのプロセスは終了します。
* **イメージに広範な認証情報を含めない**：長期的な SSH キー、クラウドプロバイダーの認証情報、またはセッションが必要とする以上の権限を付与するパーソナルアクセストークンを含めないでください。セッション中に使用される認証情報（プッシュトークンや API トークン）は、[ラッパースクリプト](https://code.claude.com/docs/ja/self-hosted-environments-configuration.md#wrapper-scripts)からセッションごとにミントしてください。初期クローンはラッパーが実行される前に発生するため、[`checkout` ライフサイクルフック](https://code.claude.com/docs/ja/self-hosted-environments-configuration#checkout)で処理するか、セッションのすべてのリポジトリが github.com 上にある場合は [`--use-anthropic-git-proxy`](#use-the-anthropic-git-proxy) で処理してください。どちらについても、[git を設定する](#configure-git)を参照してください。
* **ホストの GitHub 認証情報をセッションから遠ざける**：Claude は、セッションが読み取れる任意の GitHub 認証情報を、その認証情報が付与するアクセス権の範囲で使用できます。ランナーホスト自身の広範なスコープを持つ GitHub 認証情報は、セッションが読み取れる場所に置かないでください。このような認証情報には、パーソナルアクセストークン、`gh auth login` がアカウント用に保存するトークン、ランナーの環境内の `GH_TOKEN` などがあります。
  * **[Anthropic 管理の git](#use-the-anthropic-git-proxy) を使用する場合**：このような認証情報があると、Claude は Anthropic 管理の git を経由せずに GitHub に直接アクセスします。
  * **Anthropic 管理の git を使用しない場合**：[イメージに git 設定を含める](#ship-git-config-in-your-image)で説明しているとおりに厳密にスコープを限定すれば、クローン用の認証情報をイメージに残しておくことができます。
* **環境シークレットをセッション実行ホストに置かない**：環境シークレットはランナーを登録し、環境でキューに入っているセッションを取得できます。固定フリートでは、シークレットはすべてのランナーホストに存在し、どのセッションのコードもシークレットファイルを読み取ることができます。[オンデマンドランナー](https://code.claude.com/docs/ja/self-hosted-environments-configuration.md#on-demand-runners)を優先してください。この場合、シークレットはユーザーコードを一切実行しないオーケストレーターホストに留まり、各ランナーは正確に 1 つのランナーを登録する単一使用の作業指示を受け取ります。固定フリートでは、環境シークレットファイルをすべてのセッションで読み取り可能として扱い、セッション侵害が疑われる場合はその後にシークレットをローテーションしてください。
* **デフォルト拒否ネットワーク出力**：すべての環境でランナーとセッションコンテナのアウトバウンドトラフィックをネットワーク境界で制限してください。[デフォルト拒否出力](#default-deny-egress)では、許可する内容と理由について説明しています。
* **最小権限ホスト IAM**：ランナーホストに接続されたコンピュート ID（インスタンスプロファイルやノードサービスアカウントなど）は、ランナー自体が必要とするもののみを付与する必要があります。セッションは、ホストの ID を継承するのではなく、ラッパースクリプトを通じて独自の認証情報を取得する必要があります。
* **セッションからクラウドメタデータエンドポイントをブロックする**：セッションにホスト ID を使わせないようにするには、クラウドメタデータエンドポイントへのアクセスをブロックする必要があります。サブネットレベルの出力ポリシーはリンクローカルメタデータトラフィックをインターセプトしないため、コンテナ自体でブロックしてください：

  * ホップリミットが 1 の IMDSv2
  * メタデータ隠蔽を備えた GKE Workload Identity
  * セッションコンテナのネットワーク名前空間で `169.254.169.254` の明示的な拒否

  ブロックはラッパースクリプトとライフサイクルフックにも適用されます。これらはコンテナを共有するためです。トークン交換を[セッション JWT](https://code.claude.com/docs/ja/self-hosted-environments-identity.md)で認証し、許可リストに登録された出力を通じて独自のトークンサービスに対して行うか、Amazon EKS の IAM Roles for Service Accounts（IRSA）などのファイルベースの Web ID を使用してください。
* **ランナーごとのファイルシステム分離**：各ランナープロセスは、ホスト上の他のプロセスが読み取りまたは書き込みできない独自の作業ディレクトリを取得します。`--hooks-dir`、ラッパースクリプト、ホストの `~/.claude/` をセッションに対して読み取り専用にします。イメージに組み込むか、読み取り専用でマウントしてください。
* **ディスパッチには環境ごとのアクセス制御がない**：Anthropic 組織のすべてのメンバーは、セッションを任意の環境にディスパッチできます。Owner が [Claude Tag チャネルを環境にルーティング](https://code.claude.com/docs/ja/cloud-environments.md#set-the-environment-a-claude-tag-channel-uses)する場合、[Claude Tag アクセス設定](https://claude.com/docs/claude-tag/admins/restrict-access#restrict-who-can-use-claude)が許可するすべてのユーザーがそこで実行されるチャネルセッションを開始できます。デフォルトでは、Claude アカウントの有無に関わらず、接続された Slack ワークスペース内のすべてのユーザーです。すべてのランナーホストを、それにディスパッチできるすべてのユーザーがコード実行に到達可能として扱い、ランナーホストには、それらのユーザーすべてが読み取ることを許可されているデータと認証情報のみを配置してください。[`--lock-to-account`](https://code.claude.com/docs/ja/self-hosted-environments-reference#runner-cli-flags) は、特定のホストが実行するアカウントのセッションを制限しますが、環境にディスパッチできるユーザーを絞り込みません。セルフホスト環境を唯一のピッカーオプションにするには、[Owner](https://code.claude.com/docs/ja/cloud-environments.md#organization-shared-environments) が [**Cloud environments** ページ](https://claude.ai/admin-settings/cloud-environments)から組織全体の Anthropic ホスト環境を非表示にできます。
* **リポジトリ設定ガードを適用する**：[`--confine-repo-settings`](https://code.claude.com/docs/ja/self-hosted-environments-reference#runner-cli-flags) でガードモードを選択してください。デフォルトの `warn` は違反をログに記録してもセッションを生成し、`enforce` はセッションを拒否し、`off` はスキャンを無効にします。ランナーは各リポジトリのコミットされた設定をスキャンして、次の項目を検出します：

  * そのセッション独自のワークスペースの外で解決される付与：`additionalDirectories` エントリ、`permissions.allow` の `Edit`、`Write`、または `NotebookEdit` ルール、または `sandbox.filesystem.allowWrite` または `allowRead` エントリ
  * 空でない `env` ブロック
  * `sandbox.enabled: false` などのオペレーター姿勢の上書き

  ガードは [`--trust-workspace`](https://code.claude.com/docs/ja/self-hosted-environments-reference#runner-cli-flags) に関係なく実行され、リポジトリフック、`.mcp.json`、または Bash ルールはカバーしません。[権限とツール承認](https://code.claude.com/docs/ja/self-hosted-environments-configuration.md#permissions-and-tool-approval)では、これらの付与がどこに属するかについて説明しています。

> [!NOTE]
>
> 組織で [IP 許可リスト](https://support.claude.com/en/articles/13200993-restrict-access-to-claude-with-ip-allowlisting)が有効になっている場合は、ランナーとセッションコンテナを起動する前に、それらのパブリック出力アドレスを許可リストに追加してください。[オンデマンドランナー](https://code.claude.com/docs/ja/self-hosted-environments-configuration.md#on-demand-runners)を実行する場合は、オーケストレーターホストのアドレスも追加してください。ランナーまたはセッショントラフィックのネットワーク制御として許可リストに依存しないでください。代わりに、独自のネットワーク境界でデフォルト拒否出力を適用してください。

## ネットワーク要件

ランナーとそれが生成するセッション子は、以下のホストへのアウトバウンド接続を行います。セッションコンテナの出力をこれらのホストとセッションが到達する必要がある特定の内部サービスに制限してください。[デフォルト拒否出力](#default-deny-egress)では、方法と理由について説明しています。

これらのホストは常に必須です：

| ホスト | ポート | 用途 |
| :- | :- | :- |
| `api.anthropic.com` | 443、HTTPS；[Anthropic 管理の git](#use-the-anthropic-git-proxy) では WSS | ランナーコントロールプレーンとセッションストリーミング、モデル推論、機能フラグ、製品分析、[JWKS](https://code.claude.com/docs/ja/self-hosted-environments-identity.md) キーフェッチ、コミット署名、`--use-anthropic-git-proxy` が設定されている場合の Anthropic 管理の git |
| `github.com` や GitHub Enterprise ホストなどの git ホスト | 443 または 22 | ランナーのセッションが使用する各 git ホストでのリポジトリのクローンとプッシュ。[`--use-anthropic-git-proxy`](#use-the-anthropic-git-proxy) を使用するランナーについては、[`github.com` へのパスが引き続き必要になる場合](#github-com-egress-with-the-anthropic-git-proxy)を参照してください。 |

[`--use-anthropic-git-proxy`](#use-the-anthropic-git-proxy) を使用するランナーは、`github.com` の git トラフィックを `api.anthropic.com` 経由でルーティングするため、`github.com` 向けの git ホストへのパスは不要です。ただし、`--push-outcome-on-release` を設定する場合や `post-session` フックからプッシュする場合は、引き続きそのパスが必要です。

これらのホストが必要かどうかは、設定によって異なります：

| ホスト | ポート | 必須の場合 |
| :- | :- | :- |
| `downloads.claude.ai` | 443 | インストール時に、ネイティブインストーラーでホストに Claude Code をインストールまたは更新する場合。`install.sh` スクリプト自体は `claude.ai` から提供されます。セッション実行時には、セッションが公式 Anthropic マーケットプレイスからプラグインをインストールする場合のみです。 |
| `storage.googleapis.com` | 443 | セッション実行時に、`/plugin` に表示されるプラグインインストール数とメタデータの場合。 |
| `code.claude.com` および `claude.com` | 443 | 組み込みの claude-code-guide エージェントによるドキュメント検索と、セッション中の事前承認された WebFetch リクエストの場合。これらのホストをブロックするとドキュメント検索のみに影響します。 |
| `*.frame.claudeusercontent.com` | 443 | 組織内のセッションで [Artifact ツール](https://code.claude.com/docs/ja/artifacts.md#availability)が利用可能な場合のみ。デフォルトはプランによって異なり、そこの利用可能性テーブルに従います。ランナーで `CLAUDE_CODE_DISABLE_ARTIFACT=1` を設定して、組織設定に関係なくツールを無効に保ちます。 |
| `registry.npmjs.org` | 443 | セッションがプラグインをインストールする場合、npm ソースプラグインパッケージのフェッチとプラグインの Node.js 依存関係のインストール、または `npx` で起動された MCP サーバーが実行される場合。 |
| `http-intake.logs.us5.datadoghq.com` | 443 | Anthropic 運用メトリクス。`CLAUDE_CODE_BYOC_ENABLE_DATADOG=1` が設定されている場合のみ。セルフホスト環境ではデフォルトでオフです。 |
| `browser-intake-us5-datadoghq.com` | 443 | Anthropic エラーレポートアップロード。セッションのアカウントで[エラーレポート](https://code.claude.com/docs/ja/data-usage.md#telemetry-services)が有効な場合のみ送信されます。`DISABLE_ERROR_REPORTING=1` または `DISABLE_TELEMETRY=1` で抑制されます。 |
| モデルリクエスト、モデル検索、認証情報の更新に使用するクラウドプロバイダーのエンドポイント（`bedrock-runtime.us-east-1.amazonaws.com` や `aiplatform.googleapis.com` など） | 443 | ランナーが[モデルリクエストを Amazon Bedrock または Google Cloud の Agent Platform に送信する](https://code.claude.com/docs/ja/self-hosted-environments-configuration.md#send-model-requests-to-bedrock-or-agent-platform)場合のみ |

ランナーまたはセッションのトラフィックのために、以下のホストを許可リストに登録する必要はありません：

* **`statsig.anthropic.com`、`*.sentry.io`、`claude.ai`、`platform.claude.com`**：これらのホストは一部の古いエンタープライズネットワークチェックリストに記載されていますが、ランナーはこれらに到達しません。機能フラグのフェッチは `api.anthropic.com` に送られ、ランナーはインタラクティブ OAuth ではなく環境シークレットで認証します。
* **`mcp-proxy.anthropic.com`**：セルフホストセッションはこれを使用しません。組織でコネクタ配信が有効な場合、組織の claude.ai コネクタは `api.anthropic.com` を通じてセッションに届きます。[MCP サーバー](https://code.claude.com/docs/ja/self-hosted-environments-configuration.md#mcp-servers)を参照してください。

以下のホスト側フローは `claude.ai` に到達するため、セッションコンテナの出力を広げるのではなく、出力でこれを許可しているホストから実行してください：

* **ワンラインインストーラー**：インストール時に `claude.ai` から `install.sh` をフェッチします。
* **インタラクティブな `claude auth login`**：`claude.ai`、`claude.com`、`platform.claude.com` を通じてサインインします。[ガイド付きセットアップ](https://code.claude.com/docs/ja/self-hosted-environments-quickstart.md#run-the-guided-setup)、`doctor` のサインイン済みモード、[CI ディスパッチ](https://code.claude.com/docs/ja/self-hosted-environments-testing.md#authenticate-from-ci)がこれを使用します。サインインに使用するブラウザーは、claude.ai サインインページのブラウザーチェックも `hcaptcha.com`、`*.hcaptcha.com`、`challenges.cloudflare.com` から読み込みます。組織でシングルサインオンを使用している場合、そのブラウザーは `sso.claude.com` 経由でリダイレクトされることもあります。

### デフォルト拒否出力

ランナーとセッションコンテナを、アウトバウンドトラフィックが[ネットワーク要件テーブル](#network-requirements)のホスト、git ホスト、セッションが到達する必要がある特定の内部サービスに制限されるネットワークセグメントまたは名前空間にデプロイします。製品はこれを検証または適用できないため、すべての環境でネットワーク境界に適用してください。セッションコードはモデル指向であり、任意のホストへの接続を試みることができます。ネットワークレイヤーでのデフォルト拒否出力は、これらの試みが到達できる場所を制限します。これは権限モードに関係なく適用されます：デフォルトの事前承認ツールセットには既に `Bash` が含まれているため、[自動モード](https://code.claude.com/docs/ja/self-hosted-environments-configuration.md#permissions-and-tool-approval)がなくてもシェル出力はプロンプトなしで実行されます。

各セッションが出力するテレメトリとそれをオフにする方法の詳細については、[テレメトリ](https://code.claude.com/docs/ja/self-hosted-environments-reference.md#telemetry)を参照してください。

### 出力プロキシに認証する

一部の企業出力プロキシは、すべての接続で `Proxy-Authorization` ヘッダーを必要とします。そのヘッダーのトークンは、`HTTPS_PROXY` に設定するプロキシ URL に書き込むには速すぎるペースでローテーションすることが多いです。通常どおり `HTTPS_PROXY` または `HTTP_PROXY` をプロキシの URL に設定してから、`--proxy-authorization-command` または `--proxy-authorization-file` を設定して、ランナーにヘッダー値を読み取る場所を指示してください。両方のフラグには Claude Code v2.1.238 以降が必要です。

#### `Proxy-Authorization` 値の出所を選択する

`Proxy-Authorization` トークンを生成する方法に一致するフラグを選択してください：

* **[`--proxy-authorization-command <command>`](https://code.claude.com/docs/ja/self-hosted-environments-reference#runner-cli-flags)**：オンデマンドで生成するトークンの場合はこれを選択してください。ランナーはシェルコマンドを実行し、トリミングされた stdout をヘッダー値として使用します。例えば `Bearer <token>`。
* **[`--proxy-authorization-file <path>`](https://code.claude.com/docs/ja/self-hosted-environments-reference#runner-cli-flags)**：別のプロセスがローテーションするトークンの場合はこれを選択してください。ランナーはファイルを読み取り、トリミングされた内容をヘッダー値として使用します。

#### ランナーが起動を拒否する設定

各フラグには環境変数形式もあり、[ランナー CLI フラグリファレンス](https://code.claude.com/docs/ja/self-hosted-environments-reference.md#runner-cli-flags)に記載されています。ランナーがプロキシまたはコントロールプレーンに接続する前に、フラグとその変数をチェックし、3 つの場合に起動を拒否します：

* **両方のフラグが設定されている**：1 つのフラグと他のフラグの環境変数は、両方を設定することとしてカウントされます。
* **プロキシ URL がない**：`HTTPS_PROXY` も `HTTP_PROXY` も `http://` または `https://` URL を保持していません。ランナーは両方の変数を大文字または小文字で読み取り、`ALL_PROXY` を参照しません。
* **フラグがオーケストレーターサブコマンドに渡される**：`self-hosted-runner orchestrator` はフラグまたはそれらの環境変数を受け入れません。代わりに、オーケストレーターが開始する各ランナーにフラグを渡してください。

#### プロキシ認可フラグが設定されている間にランナーが変更する内容

いずれかのフラグが設定されている場合、ランナーは独自のリスナーを開始し、プロキシトラフィックをそれ自体、ライフサイクルフック、セッションからそのリスナーを通じて送信します。リスナーはプロキシへの途中で `Proxy-Authorization` ヘッダーを追加します。

* **リスナー**：リスナーは `127.0.0.1` 上のフォワードプロキシです。ランナーはコントロールプレーンに登録する前にリスナーを開始し、リスナーが開始できない場合は起動時に終了します。
* **プロキシ変数**：ランナーは、設定した `HTTPS_PROXY` と `HTTP_PROXY` のいずれかをリスナーを指すように書き直します。その書き直された値はランナー自体、ライフサイクルフック、実行するすべてのセッションに到達します。
* **トークンローテーション**：ローテーションされたトークンは再起動なしで有効になります。リスナーがプロキシに開く各接続について、ランナーはコマンドを実行するか、ファイルを再度読み取り、結果をヘッダーとして追加します。
* **セッション環境**：セッションはリスナーを通じてのみプロキシに到達します。各セッションの環境で、ランナーは `ALL_PROXY` を削除し、設定しなかった `HTTPS_PROXY` または `HTTP_PROXY` のスペルを削除し、`NO_PROXY` をランナー独自の値にピンします。
* **ログ**：ランナーはヘッダー値をログに記録しません。

## git を設定する

ランナーはリポジトリチェックアウトを管理しますが、デフォルトでは git ID または認証情報を設定しません。ランナーのイメージとプロセス環境を制御するため、git 設定を制御します。2 つのアプローチのいずれかを選択してください：

* **ランナーに git を設定させる**：`--configure-git` でランナーを開始して、Anthropic ホストセッションが使用する同じ ID とコミット署名設定を書き込ませます
* **イメージに git 設定を含める**：ID とプッシュ認証情報を自分で設定します。例えば、独自のボット ID でコミットするため

github.com 上のリポジトリについては、[`--use-anthropic-git-proxy`](#use-the-anthropic-git-proxy) でランナーを開始するか、`CLAUDE_RUNNER_USE_GIT_PROXY=1` を設定して、ランナーのセッションの git を提供するよう Anthropic に求めることもできます。

ランナーホストの Git バージョンフロア：[`--configure-git`](#let-the-runner-configure-git) SSH コミット署名には Git 2.34 以降が必要です。[`--use-anthropic-git-proxy`](#use-the-anthropic-git-proxy) には 2.32 以降が必要です。[`--push-outcome-on-release`](https://code.claude.com/docs/ja/self-hosted-environments-reference#runner-cli-flags) でプッシュされたブランチからセッションを再開するには 2.29 以降が必要です。3 つすべてを省略して git ID を自分で管理する場合は、Git 2.24 で十分です。

### ランナーに git を設定させる

`--configure-git` でランナーを開始するか、`SELF_HOSTED_RUNNER_CONFIGURE_GIT=1` を設定して、起動時にグローバル git 設定を書き込ませます：

* `user.name = Claude` および `user.email = noreply@anthropic.com`。Anthropic ホストセッションと一致します
* SSH 形式のコミットとタグ署名。ランナー管理のシムを通じてルーティングされ、セッション独自の認証情報を使用して Anthropic の署名サービスを通じて各コミットに署名します。署名は GitHub で Anthropic の公開 SSH 署名キーに対して検証可能です。
* `push.negotiate = true`。git がプッシュをパックする前に git ホストが既に持っているコミットを尋ねます。Claude Code v2.1.257 以降が必要です。
* `core.hooksPath` はランナー管理のフックディレクトリを指します。その `commit-msg` および `prepare-commit-msg` フックは、各コミットにセッションの作成者の `Co-authored-by:` トレーラーを追加します。[`CCR_SESSION_ACCOUNT_EMAIL`](https://code.claude.com/docs/ja/self-hosted-environments-configuration#wrapper-scripts) のメールから構築され、その変数が設定されていない場合は省略されます。イメージが既に `core.hooksPath` を設定していて、ランナーが [Anthropic 管理の git](#use-the-anthropic-git-proxy) を使用していない場合、ランナーは設定を保持し、これらのフックのインストールをスキップし、`[runner:git]` 警告を出力します。

コミット署名には git 2.34 以降が必要です。ランナーは起動時にチェックし、git が古い場合はエラーで終了します。このフラグはプッシュ認証情報を設定しません。これはイメージで提供する必要があります。

v2.1.280 以降のランナーでは、`checkout` または `post-session` ライフサイクルフックから行ったコミットもセッションとして署名されます。ただし、`Co-authored-by:` トレーラーは付きません。[ライフサイクルフック内の git 設定](https://code.claude.com/docs/ja/self-hosted-environments-configuration.md#git-configuration-inside-lifecycle-hooks)では、ランナーがこれらのフック内で固定する git 設定について説明しています。

`--configure-git` の有無にかかわらず、Claude Code は Claude に対して、コミットメッセージの末尾に `Claude-Session: <url>` トレーラーを付け、プルリクエストの説明の末尾にセッションの URL を付けるよう指示します。両方を省略するには、ランナーホストの [`~/.claude/settings.json`](https://code.claude.com/docs/ja/self-hosted-environments-configuration#how-each-session’s-config-is-assembled) で [`attribution.sessionUrl`](https://code.claude.com/docs/ja/settings-reference#attribution-sessionurl) を `false` に設定してから、ランナーを再起動してください。

### イメージに git 設定を含める

git ID はすべてのコミットに必須です。Dockerfile でシステム全体に設定して、ランナープロセスが実行されるユーザーに関係なく設定が適用されるようにします：

```dockerfile theme={null}
RUN git config --system user.name "Claude" && \
    git config --system user.email "noreply@anthropic.com"
```

ID がない場合、`git commit` は `Please tell me who you are` で失敗し、セッションは進行できません。代わりに独自のボット ID を使用できます。ランナーはこれらの値をオーバーライドしません。

長期的または広くスコープされたプッシュ認証情報を共有ランナーイメージにベイクしないでください：イメージの認証情報は、イメージが実行するすべてのセッションで利用可能です。誰が開始したかに関係なく。代わりに、セッション JWT からデコードされたセッション作成者の ID を使用して、[ラッパースクリプト](https://code.claude.com/docs/ja/self-hosted-environments-configuration.md#wrapper-scripts)からセッションごとに短期的で最小スコープのトークンをミントしてください。エフェメラルなセッションごとのコンテナと組み合わせます。これには `--capacity 1` が必要です。認証情報がセッションを超えて存続しないようにします。[強化セクション](#harden-your-deployment)を参照してください。

イメージレベルでプッシュ認証情報を設定する必要がある場合（例えば、読み取り専用デプロイキーの場合）、git ホストが許可する限りスコープを厳しくしてください：

* `url.<base>.insteadOf` 書き直しで 1 つのリポジトリに制限された SSH デプロイキー
* 最小限のスコープトークンを返す `credential.helper`
* 狭くスコープされたキーを指す `GIT_SSH_COMMAND`

設定するメカニズムは、ランナーの組み込みクローンとフェッチがプロンプトを無効にするため、プロンプトなしで動作する必要があります。git、SSH、Git Credential Manager が表示するプロンプト：

* ランナーは `GIT_TERMINAL_PROMPT=0` を設定するため、git はユーザー名またはパスワードを要求しません。
* ランナーは `BatchMode=yes` で SSH を実行します。`GIT_SSH_COMMAND` を設定した場合は追加されます。SSH はパスフレーズまたはホスト確認を要求しません。
* ランナーは `GCM_INTERACTIVE=never` を設定するため、Git Credential Manager はサインインダイアログを開きません。
* ランナーは `core.askPass` をクリアするため、askpass ヘルパーを使用する場合は、`GIT_ASKPASS` 環境変数を通じて設定してください。

git ホストが認証情報を拒否するか、認証情報を設定しなかった場合、ランナーは数回再試行してから失敗します。リポジトリがセッションがプッシュする結果のリポジトリである場合、ランナーはリポジトリ準備に失敗します。セッションが読み取り専用のリポジトリの場合、[トラブルシューティング](#troubleshooting)はランナーがスキップする場合をカバーしています。ランナーはこれらの設定をセッション環境に渡しません。

`GIT_SSH_COMMAND` または `GIT_ASKPASS` で名前を付けるプログラムを、セッションが書き込めない場所に保持してください。[強化チェックリスト](#harden-your-deployment)がフックディレクトリとラッパースクリプトに要求する方法と同じです。そのプログラムのコマンドラインのキーまたはファイルについても同じです。ランナー独自の git は、クローンまたはフェッチするときにそのプログラムを実行します。

チェックアウトディレクトリがランナープロセスと異なる uid で所有されている場合、git は操作を拒否します。`safe.directory` を追加してください：

```dockerfile theme={null}
RUN git config --system --add safe.directory '*'
```

### Anthropic git プロキシを使用する

Anthropic git プロキシ（Anthropic 管理の git とも呼ばれます）を使用すると、ランナーイメージはセッション自体のために SSH キー、認証情報ヘルパー、`.netrc`、その他の git 認証情報を必要としません。代わりに、ランナーはセッションの git を提供するよう Anthropic に求めます。Anthropic が提供するユーザーのセッションでは、ランナーのクローンとセッション独自のフェッチおよびプッシュは Anthropic を経由し、Anthropic はセッション作成者用に保存された GitHub OAuth トークンを使用します。ボットおよびエージェントセッションについては、[Anthropic がセッションの git を提供する仕組み](#how-anthropic-serves-git-for-a-session)で説明しています。

git プロキシは、[オンにしない](#turn-the-anthropic-git-proxy-on)限りオフです。独自の認証情報で git ホストに到達するランナーには不要であり、そのランナーの git はどの git ホストでも動作します。

その代わり、git プロキシはランナーがサポートする範囲を制限し、ランナーに必要なものを変更します：

* **github.com のみ**：Anthropic は、セッションのすべてのリポジトリが github.com 上にある場合にのみそのセッションを提供します。また、git プロキシはまだ GitHub Enterprise Server をサポートしていません。git プロキシを使用するランナーでは、別の git ホスト上のリポジトリを持つセッションは[開始に失敗します](#when-anthropic-doesnt-serve-a-session)。
* **セッションのリポジトリのみの認証情報**：Anthropic は、セッションに含まれるリポジトリに対して git 認証情報を提供し、同じ git ホスト上の他のリポジトリに対しては提供しません。プライベートサブモジュール、パッケージマネージャーが git で取得する依存関係、または別のリポジトリにあるプラグインマーケットプレイスは、Anthropic から認証情報を受け取りません。セッションを作成するユーザーに、作成時にセッションが必要とする[すべてのリポジトリを追加する](https://code.claude.com/docs/ja/web-quickstart.md#start-a-task)よう依頼してください。

  [クラウドスケジュールタスク](https://code.claude.com/docs/ja/routines.md)の各実行は、そのタスクのリポジトリを持つセッションです。そのため、各タスクの所有者に、実行に必要な[すべてのリポジトリを追加する](https://code.claude.com/docs/ja/routines.md#edit-and-control-routines)よう依頼してください。
* **ブランチへのプッシュのみ**：ブランチを削除するプッシュは失敗し、タグなど他の種類の ref へのプッシュも失敗します。プッシュで更新できるブランチについては、[GitHub プロキシ](https://code.claude.com/docs/ja/cloud-environments.md#github-proxy)を参照してください。
* **接続済みの GitHub アカウント**：リポジトリを含むユーザーセッションを作成する各ユーザーに、[GitHub を接続する](https://code.claude.com/docs/ja/web-quickstart.md#connect-github)よう依頼してください。本人の接続がない場合、それらのセッションは[開始されません](#creator-has-no-github-connection)。
* **`--capacity 1`**：git プロキシはランナープロセスごとに 1 つのセッションを必要とするため、並列処理のためにより多くのレプリカを実行してください。要件は [Anthropic git プロキシをオンにする](#turn-the-anthropic-git-proxy-on)に記載されています。
* **グローバル git 設定の置き換え**：ランナーは、実行ユーザーの[グローバル git 設定を削除して置き換えます](#git-proxy-replaces-global-git-config)。専用ユーザーとして、またはコンテナ内で実行してください。
* **ホストからのプッシュにはホストの認証情報**：ランナーの [`--push-outcome-on-release`](https://code.claude.com/docs/ja/self-hosted-environments-reference#runner-cli-flags) によるプッシュと、[`post-session` フック](https://code.claude.com/docs/ja/self-hosted-environments-configuration#post-session)が行うプッシュは、引き続きランナーホスト独自の git 認証情報と [`github.com` へのネットワーク経路](#github-com-egress-with-the-anthropic-git-proxy)を使用します。これらの認証情報は[グローバル git 設定](#git-proxy-replaces-global-git-config)に置かないでください。提供方法については[イメージに git 設定を含める](#ship-git-config-in-your-image)を参照してください。
* **セッションごとの判断**：Anthropic はランナー上の各セッションについて git を提供するかどうかを決定し、提供されないセッションは開始に失敗します。原因については [git プロキシを使用するランナーでセッションの開始に失敗する場合](#when-anthropic-doesnt-serve-a-session)で説明しています。

> [!WARNING]
>
> `--use-anthropic-git-proxy` を設定すると、ランナーは実行ユーザーのグローバル git 設定を削除して置き換え、バックアップは保持しません。これは起動時と各セッションの前に行われます。そこに保存していたログインや認証情報ヘルパーは失われます。[`--configure-git`](#let-the-runner-configure-git) が書き込む設定は保持されます。ランナーは専用ユーザーとして、またはコンテナ内で実行し、決して自分のユーザーとして実行しないでください。

ID や `safe.directory` など、機密ではない git 設定はシステムの git 設定に保持してください。

#### Anthropic git プロキシをオンにする

`--use-anthropic-git-proxy` でランナーを開始する前に、ランナーホストが次の各要件を満たしていることを確認してください。容量または git の要件が満たされていない場合、ランナーは起動を拒否します：

* **Claude Code v2.1.267 以降**：それより前のバージョンはフラグを受け入れますが、Anthropic に git の提供を求めるリクエストを報告せず、`Registering as opted in` 行も出力しないため、Anthropic はそれらのセッションを提供しません。
* **`--capacity 1`（デフォルト）**：各ランナープロセスは一度に 1 つのセッションを処理するため、並列処理のためにより多くのレプリカを実行してください。
* **Git 2.32 以降**：古い git は、ランナーが git プロキシ用に設定するセッションごとの git 設定を無視します。

> [!WARNING]
>
> このページの [Kubernetes](#kubernetes) および [Docker Compose](#docker-compose) レシピは `--capacity 4` を使用しています。`--use-anthropic-git-proxy` または `CLAUDE_RUNNER_USE_GIT_PROXY=1` をそのいずれかに追加する場合、容量を `1` に変更しないと、オーケストレーターがそれを再起動するたびにランナーは起動時に終了します。`--capacity 1` を設定し、並列処理のためにより多くのレプリカを実行してください。[ランナーが終了するとき](#when-the-runner-exits)はランナーが出力する行を示しています。

git プロキシをオンにするには、ランナーのコマンドに `--use-anthropic-git-proxy` を追加するか、ランナーの環境で `CLAUDE_RUNNER_USE_GIT_PROXY=1` を設定します。ランナーホスト上のシェルで実行する次のコマンドは、[クイックスタート](https://code.claude.com/docs/ja/self-hosted-environments-quickstart.md#set-up-manually)のランナーを git プロキシをオンにした状態で開始します：

```bash theme={null}
claude self-hosted-runner --environment-secret-file '/etc/claude/environment-secret' --base-dir '<writable-dir>' --use-anthropic-git-proxy
```

起動時に、ランナーは `Registering as opted in to Anthropic-managed git (--use-anthropic-git-proxy)` を出力します。その後、Anthropic はそのランナー上の各セッションについて git を提供するかどうかを決定します。提供する各セッションについて、ランナーは `governed git ACTIVE` を含む `[runner:session]` 行をログに記録します。代わりにセッションの開始に失敗した場合は、[git プロキシを使用するランナーでセッションの開始に失敗する場合](#when-anthropic-doesnt-serve-a-session)を参照してください。

#### Anthropic がセッションの git を提供する仕組み

Anthropic が提供するセッションでは、ランナーのクローンとセッション独自のフェッチおよびプッシュは、セッション独自の短期トークンで認証されて Anthropic を経由します：

* **ユーザーセッション**：Anthropic はセッション作成者用に保存された GitHub OAuth トークンを使用します。
* **ボットおよびエージェントセッション**：Anthropic は組織の GitHub App インストールトークンを使用します。
* **URL の書き直し**：`--git-host-rewrite` と `--git-ssh-rewrite` は、git プロキシが提供するリポジトリには効果がありません。

#### git プロキシを使用するランナーでセッションの開始に失敗する場合

`--use-anthropic-git-proxy` で開始したランナーでは、Anthropic がセッションの git を提供しない場合、セッションは開始に失敗します。ランナーのログで、`/git_proxy/` を含む `api.anthropic.com` アドレスを示す git エラーを探してください。

各セッションについて、Claude Code v2.1.267 以降のランナーは、Anthropic がセッションの git を提供する場合は `governed git ACTIVE` を含む `[runner:session]` 行を、提供しない場合は `the server withheld Anthropic-managed git for this session` を含む `[runner:warn]` 行を 1 つログに記録します。表示されている行を次のケースから探してください：

* **`governed git ACTIVE` も `withheld` 行もない**：Claude Code v2.1.267 より古いランナーはどちらの行もログに記録せず、Anthropic はそのセッションを提供しません。[バージョンを固定する](#pin-the-version)の手順に従って、ランナーを v2.1.267 以降に更新してください。
* **`withheld` 行**：Anthropic はセッションを提供しませんでした。以前は git プロキシで動作していたランナーでも、ユーザー側で何も変更していないのにこのように失敗することがあります。
  * **github.com 上にないリポジトリがある**：GitHub Enterprise Server など別の git ホスト上のリポジトリが 1 つでもあるセッションは、その github.com リポジトリも含めて提供されません。その環境のランナーでは [Anthropic git プロキシをオフにしてください](#turn-the-anthropic-git-proxy-off)。
  * **すべてのリポジトリが github.com 上にある**：`withheld` 行のセッション ID を添えて、[Anthropic アカウントチーム](#report-an-issue)に失敗を報告してください。Anthropic は理由を自社側で記録しています。
* **`remote: access denied by the git proxy` を含む行**：Anthropic が提供するセッションでも拒否される場合があります。たとえば、組織のポリシーがセッションの git アクセスを拒否する場合や、セッションがリポジトリに対して認可されていない場合です。その場合、ランナーのログに `remote: access denied by the git proxy` を含む行が表示され、その行の残りの部分に理由が示されます。
* **`GitHub authentication required`**：セッションの作成者が claude.ai で有効な GitHub 接続を持っていない場合に表示されます。セッションのクローンは失敗し、git エラーには `GitHub authentication required. Please reconnect your GitHub account.` と表示されます。そのユーザーに、claude.ai の設定で GitHub を接続または再接続するよう依頼してください。

原因を修正した後、失敗したセッションを再度開始してください。

#### Anthropic git プロキシをオフにする

環境内のセッションが GitHub Enterprise Server など github.com 以外の git ホスト上のリポジトリを使用する場合は、その環境のランナーで `--use-anthropic-git-proxy` をオフにしてください。

**1. フラグを削除する**

ランナーのコマンドから `--use-anthropic-git-proxy` を削除します。Pod 仕様や Compose ファイルなど、ランナーの環境で `CLAUDE_RUNNER_USE_GIT_PROXY` を設定している場合は、そこから削除します。シェルでは設定を解除します：

```bash theme={null}
unset CLAUDE_RUNNER_USE_GIT_PROXY
```

**2. ランナーに git 認証情報を与える**

github.com を含め、ランナーのセッションが使用するすべての git ホストに対して、プロンプトなしで動作する認証情報を提供してください。ランナーユーザーのグローバル git 設定にあった認証情報は、`--use-anthropic-git-proxy` が設定されている間にランナーがその設定を削除したため、失われています。[イメージに認証情報を含める](#ship-git-config-in-your-image)か、[`checkout` ライフサイクルフック](https://code.claude.com/docs/ja/self-hosted-environments-configuration#checkout)を使用してください。

**3. ネットワーク経路を開く**

ランナーのセッションが使用する各 git ホストに、ランナーがポート 443 または 22 で到達できるようにしてください。[ネットワーク要件](#network-requirements)の git ホストの行を参照してください。

**4. ランナーを再起動する**

git プロキシなしで登録されるようにランナーを再起動します。その後、失敗した各セッションを再度開始してください。

#### GitHub CLI なしで GitHub API にアクセスする

ランナーイメージに GitHub CLI が含まれていない場合、Claude Code は組み込みの `gh` を提供できるため、Claude は引き続きプルリクエストの作成、コメント、CI 結果の読み取りを行えます。組み込みの `gh` は、Anthropic 管理の git を使用するランナー向けです。サポートするコマンドは GitHub の REST API を呼び出す `gh api` の 1 つのみです。ランナーイメージに Claude Code v2.1.287 以降が必要です。

次のコマンドは、`gh pr create` の代わりにプルリクエストを作成します。組み込みの `gh` は、現在のリポジトリの `{owner}` と `{repo}` を自動で埋めます：

```bash theme={null}
gh api repos/{owner}/{repo}/pulls -f title='Fix' -f head='my-branch' -f base='main'
```

* **認証情報**：組み込みの `gh` は REST リクエストを Anthropic 管理の git 経由で送信し、GitHub の認証情報は Anthropic 側で提供されるため、イメージにそのための GitHub トークンは不要です
* **利用できるセッション**：Anthropic 管理の git がセッションの `gh` を提供するかどうかは、Anthropic がセッションごとに決定します。提供する場合、ランナーがそのセッションについてログに記録する `[runner:session] governed git ACTIVE` 行に `gh_path_shim=true` が表示されます。提供しない場合、そのセッションには `gh` がありません
* **`jq`**：`--jq` を使用したい場合は、イメージに `jq` をインストールしてください
* **[`CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC`](https://code.claude.com/docs/ja/env-vars)**：セッション環境でこれが設定されている場合、Claude Code は組み込みの `gh` を提供せず、セッションには `gh` がありません

イメージに GitHub CLI が含まれている場合、セッションはそれを使用します。

#### Anthropic 管理の git でプライベート認証局を信頼する

このセクションは、セッションが Anthropic 管理の git を使用するランナーの環境で `GIT_SSL_CAINFO` または `GIT_SSL_NO_VERIFY` を設定した場合に適用されます。説明する処理には、ランナーが Claude Code v2.1.283 以降を実行する必要があります。

ランナー上の git が TLS 検査プロキシが署名するプライベート認証局（CA）などのプライベート認証局を信頼する必要がある場合、通常のアプローチは次のように機能します：

* **システム証明書ストア**：ランナーホストのシステム証明書ストアに CA をインストールし、git は変数なしでそれを信頼します。
* **`GIT_SSL_CAINFO`**：CA の PEM ファイルに設定します。例えば `GIT_SSL_CAINFO=/etc/ssl/corp-ca.pem`。
* **`GIT_SSL_NO_VERIFY`**：再署名プロキシの背後では役に立ちません。Anthropic 管理の git を通じたランナー独自のクローンは、変数が設定されている場合でも証明書をチェックするため、git が他の 2 つのアプローチのいずれかを通じて CA を信頼するまで、そのクローンは失敗します。

セッションのトークンを Anthropic 管理の git に運ぶ git 接続の場合、ランナーは 2 つの変数を次のように適用します。[`command` フック](https://code.claude.com/docs/ja/self-hosted-environments-configuration#command)はセッションの環境で開始するため、git がセッション内で取得するものを取得します：

* **`GIT_SSL_CAINFO`**：git が Anthropic 管理の git に対してチェックするものは、git が実行される場所によって異なります：
  * **ランナー独自のクローンとフェッチ**：変数なしで実行され、ランナーが書き込むセッションごとの証明書ファイルに対して Anthropic 管理の git をチェックします。ランナーは、ランナーホストのシステム CA バンドルと指定したファイル内の証明書からそのファイルを作成します。
  * **セッション内の git**：変数の代わりに `http.sslCAInfo` 設定を取得し、ファイルに名前を付けます。また、セッションごとのファイルに対して Anthropic 管理の git をチェックする `http.<url>.sslCAInfo` エントリを取得します。
  * **`checkout` および `post-session` フック**：変数を変更されずに継承します。
* **`GIT_SSL_NO_VERIFY`**：証明書チェックが無効のままであるかは、git が実行される場所によって異なります：
  * **ランナー独自のクローンとフェッチ**：変数なしで実行され、提示される証明書をチェックします。
  * **セッション内の git**：変数の代わりに `http.sslVerify=false` 設定を取得するため、他のホストのチェックは無効のままです。また、Anthropic 管理の git のチェックを有効に保つ `http.<url>.sslVerify=true` エントリを取得します。
  * **`checkout` および `post-session` フック**：セッションが Anthropic 管理の git 上のリポジトリを持つ場合、変数の代わりに `http.sslVerify=false` 設定を取得します。また、Anthropic 管理の git のチェックを有効に保つ `http.<url>.sslVerify=true` エントリを取得します。

セッションごとの証明書ファイルには、ランナーホスト上の `/etc/ssl/certs/ca-certificates.crt` または `/etc/pki/tls/certs/ca-bundle.crt` のシステム CA バンドルが必要です。また、ランナーのユーザーが読み取ることができ、PEM `CERTIFICATE` ブロックを保持し、最大 1 MiB である `GIT_SSL_CAINFO` ファイルが必要です。ランナーがセッションごとのファイルを構築できない場合、`[runner:warn]` 行を記録します。これには `did not build the certificate file` と理由が含まれます。git はその後、Anthropic 管理の git のファイルをそのまま使用します。行が名前を付けるものを修正してください。

Anthropic 管理の git を使用する各セッションについて、ランナーは `[runner:warn]` 行をログに記録します。これは `governed git: GIT_SSL_CAINFO is set` または `governed git: GIT_SSL_NO_VERIFY is set` で始まります。行は、ランナーが独自の git、セッション内の git、およびライフサイクルフックのその変数で何をしたかを示します。何かを変更する必要があるかどうかで終わります。

### Claude Tag チャンネルのセッションに github.com のリポジトリを追加する

Claude が Claude Tag チャンネルのセッションに github.com のリポジトリを追加できない場合は、ランナーがそのリポジトリをクローンできる場合でも、チャンネルがそのリポジトリにアクセスできることを確認してください。このアクセス権は、ランナーの git 認証情報ではなく、GitHub と Claude 組織の設定によって決まります。

**1. Claude GitHub App をインストールする**

リポジトリを所有する GitHub 組織またはアカウントに [Claude GitHub App](https://github.com/apps/claude) をインストールし、そのリポジトリをインストール対象に含めます。

**2. GitHub 組織またはアカウントをリンクする**

[**Organization settings > Git providers**](https://claude.ai/admin-settings/source-control) で、その組織またはアカウントを Claude 組織にリンクします。GitHub 組織のオーナーでもある Claude 組織の Owner がリンクできます。[GitHub 組織をリンクする](https://claude.com/docs/claude-tag/admins/configure-github#link-your-github-organization)を参照してください。

**3. リポジトリへのアクセスを付与する**

[Claude Tag 管理設定](https://claude.ai/admin-settings/claude-tag)で、チャンネル、またはそのチャンネルを含むより広いスコープ（その Slack ワークスペースまたは Slack 全体）にリポジトリへのアクセスを付与します。Owner ロールまたは Claude Tag Admin 権限を持つユーザーが付与できます。チャンネルマネージャーも、自分の GitHub アカウントがリポジトリの管理者であれば、自分のチャンネルにリポジトリを追加できます。[リポジトリへのアクセスを付与する](https://claude.com/docs/claude-tag/admins/configure-github#grant-repository-access)を参照してください。

その後、チャンネルで新しいスレッドを開始し、最初のメッセージで[リポジトリ名を指定](https://claude.com/docs/claude-tag/admins/configure-github#how-granted-repositories-reach-a-session)してください。

それでも Claude がリポジトリを追加できない場合は、GitHub のリンクとリポジトリへのアクセス付与を確認する場所について、[Claude がリポジトリにアクセスできない場合](https://claude.com/docs/claude-tag/admins/configure-github#if-claude-can%E2%80%99t-reach-a-repository)を参照してください。

### プライベートネットワークの git URL を書き直す

リポジトリ URL はコントロールプレーンから HTTPS として到達します。git ホストのホスト名を使用します。GitHub Enterprise の場合、claude.ai で [GitHub Enterprise 統合](https://code.claude.com/docs/ja/github-enterprise-server.md)用に設定したホスト名です。2 つの繰り返し可能なフラグはクローン前にこれらの URL を書き直します：

* `--git-host-rewrite <from>=<to>`：スプリットホライズン DNS の場合。Anthropic は外部ホスト名を通じて git ホストに到達しますが、ランナーは内部ホスト名を使用する必要があります
* `--git-ssh-rewrite <host>`：SSH のみを受け入れる git ホストの場合、または SSH キーしか持たないランナーホストの場合。例えば、github.com のリポジトリを SSH でクローンするには、ランナーのコマンドに `--git-ssh-rewrite github.com` を追加します。するとランナーは `https://github.com/owner/repo` を `git@github.com:owner/repo` に書き直します。SSH は[プロンプトなしで接続](#git-must-work-without-a-prompt)できる必要があります。

ホスト書き直しが最初に実行されるため、両方が必要な場合は `--git-ssh-rewrite` に内部ホスト名をリストします。チェックアウトを完全に制御するには、[`checkout` ライフサイクルフック](https://code.claude.com/docs/ja/self-hosted-environments-configuration#checkout)を使用してください。

## ランナーイメージをビルドする

Anthropic は事前にビルドされたランナーイメージを公開していません。`claude` バイナリの周りに独自のイメージをビルドし、リポジトリが必要とするツールチェーン（言語ランタイム、コンパイラ、パッケージマネージャー、[MCP](https://code.claude.com/docs/ja/mcp.md) サイドカー）をレイヤーに追加してください。

以下のレシピは `--capacity 4` を使用しているため、1 つのコンテナが同じロックされたオーナーからの最大 4 つの同時セッションを処理します。これは[ハードニングセクション](#harden-your-deployment)のセッションごとのコンテナ分離を提供していません。環境を本番システムに接続する前に、レシピを `--capacity 1` で実行してセッションごとに 1 つのコンテナを使用するか、[オンデマンドランナー](https://code.claude.com/docs/ja/self-hosted-environments-configuration.md#on-demand-runners)を使用してください。オンデマンドランナーは、セッション実行ホストから環境シークレットを保持します。これらのレシピのいずれかに[Anthropic git プロキシ](#use-the-anthropic-git-proxy)を追加する場合は、`--capacity` も `1` に変更してください。

これは最小限の開始点となる Dockerfile です。

```dockerfile theme={null}
FROM debian:bookworm-slim
ARG CLAUDE_CODE_VERSION
RUN apt-get update && apt-get install -y --no-install-recommends git curl ca-certificates openssh-client jq \
 && rm -rf /var/lib/apt/lists/*
RUN curl -fsSL "https://downloads.claude.ai/claude-code-releases/${CLAUDE_CODE_VERSION:?set with --build-arg CLAUDE_CODE_VERSION}/linux-x64/claude" \
      -o /usr/local/bin/claude && chmod +x /usr/local/bin/claude
RUN git config --system user.name "Claude" \
 && git config --system user.email "noreply@anthropic.com" \
 && git config --system --add safe.directory '*'
ENTRYPOINT ["claude"]
```

ARM ノードの場合は `linux-x64` を `linux-arm64` に置き換えるか、Alpine などの musl ベースのイメージの場合は `linux-x64-musl` または `linux-arm64-musl` に置き換えてください。[Alpine Linux セットアップ](https://code.claude.com/docs/ja/setup.md#alpine-linux-and-musl-based-distributions)を参照して、musl イメージが必要とする追加パッケージを確認してください。URL は標準的な Claude Code リリースロケーションであるため、[バイナリの整合性とコード署名](https://code.claude.com/docs/ja/setup.md#binary-integrity-and-code-signing)で説明されているように、ダウンロードされたバイナリをリリースの署名されたマニフェストに対して検証できます。ランナーは Claude Code バージョン 2.1.224 以降が必要です。イメージをビルドしてから、レジストリにプッシュし、以下のレシピで参照してください。

```bash theme={null}
docker build \
  --build-arg CLAUDE_CODE_VERSION="$(curl -fsSL https://downloads.claude.ai/claude-code-releases/stable)" \
  -t <your-registry>/claude-runner:latest .
```

コマンド置換は現在の `stable` リリース番号を検索し、ビルド引数として渡すため、新しい安定版リリース後に同じコマンドを実行すると、ダウンロードレイヤーが新しいバイナリで再ビルドされます。再現可能なビルドのために特定のリリースをピンするには、バージョン番号を `CLAUDE_CODE_VERSION` として直接渡してください。[新しくリリースされたモデルが必要とする](https://code.claude.com/docs/ja/model-config.md)ような安定版チャネルより新しいリリースが必要な場合は、ルックアップ URL の `stable` を `latest` に置き換えてください。

## セッション用に CPU とメモリをサイズ設定する

ランナープロセス自体ではなく、ランナーが実行するセッション用にランナーのコンテナまたはホストをサイズ設定してください。ランナー自体は作業をポーリングし、各セッションのチェックアウトを準備し、[ライフサイクルフック](https://code.claude.com/docs/ja/self-hosted-environments-configuration.md#lifecycle-hooks)を実行し、セッションプロセスを開始および監視します。負荷はセッションから発生します。各セッションは Claude Code プロセスと、ビルド、テストスイート、パッケージインストール、[MCP サーバー](https://code.claude.com/docs/ja/mcp.md)など、それが開始するものです。

1 つのセッションについて、以下の値から開始してください。Kubernetes のリクエストと制限、またはプラットフォームの同等の値として記載されており、要件ではなく開始点として扱ってください。

* **メモリ**: 各 4 GiB のリクエストと制限。これは Claude Code の[システム要件](https://code.claude.com/docs/ja/setup.md#system-requirements)の 4 GB 最小値を満たします。2 つを等しく保つことで、スケジューラーはコンテナの全メモリを考慮に入れます。コンテナがメモリ制限に達すると、カーネルはその内部のプロセスを強制終了し、セッションをタスクの途中で終了させる可能性があります。
* **CPU**: 2 CPU のリクエストと 4 CPU の制限。セッションはビルド中にリクエストを超えてバースト可能です。カーネルはコンテナを CPU 制限でスロットルします。その制限でプロセスを強制終了するのではなく、セッションは制限で実行速度が低下しますが、実行を続けます。

Kubernetes コンテナスペックで、以下の `resources` ブロックを使用してこれらの開始値を設定します。

```yaml theme={null}
resources:
  requests:
    cpu: "2"
    memory: 4Gi
  limits:
    cpu: "4"
    memory: 4Gi
```

ビルドとテストは通常、セッションの負荷の最大かつ最も変動する部分です。リポジトリの代表的なビルドを実行し、ピーク CPU とメモリを測定し、そのピークの上に Claude Code プロセスの余地を残さない開始値を引き上げてください。

ランナーは `--capacity` を使用して、一度に実行するセッション数をキャップします。CPU またはメモリをセッション間で分割しないため、ランナー上のセッションはコンテナの CPU とメモリを共有します。1 つのセッションのメモリ使用が他のセッションを終了させないようにするには、[専用のメモリ制限](#give-each-session-its-own-memory-limit)を設けて、ランナーあたり 1 つのセッションを実行してください。

* **ランナーあたり 1 つのセッション**: 各コンテナに 1 つのセッションの値を与えます。[強化セクション](#harden-your-deployment)が推奨する `--capacity 1` でこのサイズ設定を使用し、[オンデマンドランナー](https://code.claude.com/docs/ja/self-hosted-environments-configuration.md#on-demand-runners)の場合、[`spawn-runner` フック](https://code.claude.com/docs/ja/self-hosted-environments-configuration#the-spawn-runner-hook)が送信するワークロード（Kubernetes Job のポッドテンプレートなど）に値を設定します。
* **ランナーあたり複数のセッション**: `--capacity` が 1 より上の場合、1 つのセッションの値に容量を掛けます。その容量まで多くのセッションがコンテナ内で同時に実行できるためです。[Kubernetes](#kubernetes) と [Docker Compose](#docker-compose) レシピは CPU またはメモリ制限なしで `--capacity 4` を実行するため、実行する容量のサイズ設定された制限を追加してください。
* **1 つのホスト上の複数のランナーコンテナ**: 各ランナーは自身のセッションのみを `--capacity` に対してカウントするため、ランナーの容量の合計に合わせてホストをサイズ設定します。

  * **メモリ**: 1 つのセッションのメモリに合計を掛け、ホスト自身のプロセスが使用する分を加えます
  * **CPU**: 1 つのセッションの CPU リクエストに合計を掛けます。すべてのセッションが同時にバーストできるようにするには、代わりに CPU 制限を掛けます。

  各ランナーに専用のコンテナを与えてください。各ランナーが[専用の作業ディレクトリ](#harden-your-deployment)を持つように、それぞれで[同じ `--base-dir` パス](#keep-the-base-directory-and-capacity-identical-across-runners)を、他のランナーのコンテナがマウントしないストレージ上で使用してください。

### 各セッションに専用のメモリ制限を与える

メモリが不足したときに 1 つのセッションが他のセッションを終了させないようにするには、各ランナーを `--capacity 1` で、1 つのセッションのメモリに設定した専用のメモリ制限の下で実行してください。

* **コンテナ内**: コンテナあたり 1 つのランナーを実行し、コンテナのメモリ制限を設定します。例えば Kubernetes では `limits.memory`、Docker では `--memory`、Compose ファイルでは `mem_limit` です。コンテナの制限の合計はホストのメモリ未満に保ってください。ホスト自体のメモリが不足すると、カーネルはホスト上のどこにあるプロセスでも強制終了する可能性があるためです。
* **コンテナなしの systemd 下**: ランナーのユニットに `MemoryMax` を設定し、ホストあたり 1 つのランナーを実行します。1 つのファイルシステム上で[同じ `--base-dir` を使用する](#keep-the-base-directory-and-capacity-identical-across-runners)ランナーは、そこにクローンされたリポジトリを共有するためです。例えば、`checkout` フックなしの `--capacity 1` では、1 つのリポジトリ上のそれらのセッションが同じチェックアウトで同時に作業する可能性があります。1 つのホストで複数のランナーを実行するには、それぞれにコンテナを与えてください。

コンテナまたはユニットがメモリ制限に達すると、カーネルはその内部のプロセスのみを強制終了します。`--capacity` を 1 より上に設定すると、セッションは 1 つの制限を共有します。制限に達したとき、カーネルは強制終了するプロセスをセッション単位で選択しないため、1 つのセッションのメモリ使用が他のセッションを終了させる可能性があります。

Kubernetes では、kubelet の `singleProcessOOMKill` 設定のどちらの値でもセッションを分離することはできません。また、[ラッパースクリプト](https://code.claude.com/docs/ja/self-hosted-environments-configuration.md#wrapper-scripts)内のメモリ `ulimit` でセッションの合計メモリをキャップすることもできません。カーネルは `ulimit -v` などの値を各プロセスに個別に適用します。

### プロセスとスレッドの制限に余裕を残す

プロセスとスレッドの制限をサイズ設定するには、1 つのセッションが必要とする量を測定し、その制限を共有するセッション数を掛けます。それらのセッションが制限に達すると、カーネルは新しいプロセスとスレッドを拒否するため、いずれのセッションでもコマンド、ビルド、テストが失敗する可能性があります。拒否された呼び出しは `EAGAIN` を返し、その標準メッセージは `Resource temporarily unavailable` です。

1 つのセッションのピークが 300 のプロセスとスレッドで、4 つのセッションが制限を共有するとします。合計で 1,200 が必要になり、制限を 2,400 にすれば、その 2 倍を必要とするビルドにも余裕を残せます。

#### 各制限の設定場所

この表の各制限はプロセスだけでなくスレッドもカウントし、`pids.max` は cgroup の制限を保持するファイルです。

| 制限 | 設定場所 | 共有するもの |
| :- | :- | :- |
| Kubernetes の `pids.max` | ランナーを実行するノードの kubelet 設定の `podPidsLimit`。Pod スペックでは設定できません。 | 1 つの Pod のコンテナ |
| Docker の `pids.max` | `--pids-limit`、または Compose ファイルの `pids_limit` | 1 つのコンテナ |
| systemd 下の `pids.max` | ランナーのユニットの `TasksMax` | 1 つのユニット |
| `ulimit -u` | ランナーを開始するシェルまたはサービス | ホスト上でランナーのユーザー ID として実行されるすべてのもの。root には適用されません。 |

`TasksMax` を設定しない場合、systemd は `DefaultTasksMax` を適用します。そのデフォルトは、`kernel.pid_max`、`kernel.threads-max`、ルート cgroup の `pids.max` のうち最も低い値の 15% です。

#### 1 つのセッションのピークを測定する

自分のランナーの数値を得るには、ホスト（Kubernetes ではノード）上で 1 つのセッションを測定します。

**1. 1 つのランナーを単独で開始する**

コンテナまたは systemd ユニット内に他に何もない状態で、1 つのランナーを `--capacity 1` で開始し、ホストと環境で単独にします。

* **ホスト**: 他のランナーを実行していないホストを使用します。これにより、次のステップでそのプロセスを特定できます。
* **環境**: 例えば[テスト用に作成した](https://code.claude.com/docs/ja/self-hosted-environments-quickstart.md#set-up-manually)環境で、そこにある唯一のランナーにします。セッションはランナーではなく環境にルーティングされます。

ビルドを開始する前に次のステップのディレクトリが必要なため、まだセッションを開始しないでください。

**2. ランナーの cgroup ディレクトリを見つける**

コンテナ内ではなくホスト上で、例えば `ps` を使ってランナーのプロセス ID を見つけます。その ID の `/proc/<pid>/cgroup` を読み取ります。

* **`:pids:` を含む行がある**: ホストは cgroup v1 を使用しており、ディレクトリは `/sys/fs/cgroup/pids` に `:pids:` の後のテキストを続けたものです
* **唯一の行が `0::` で始まる**: ホストは cgroup v2 を使用しており、ディレクトリは `/sys/fs/cgroup` に `0::` の後のテキストを続けたものです

**3. 代表的なビルドを実行してピークを記録する**

1 つのセッションで代表的なビルドを実行し、ランナーの cgroup ディレクトリからピークを取得します。

* **ディレクトリに `pids.peak` がある**: ビルドが終了した後にファイルを読み取ります
* **ディレクトリに `pids.peak` がない**: ビルドの実行中に `pids.current` を 1 秒ごとに読み取り、最大値を保持します。2 回の読み取りの間のピークは見逃されるため、その値は低めの見積もりとして扱ってください。

**4. 制限を共有するセッション数を掛ける**

* **1 つのランナーの Pod、コンテナ、またはユニット**: ピークにランナーの `--capacity` を掛けます
* **複数のランナーが共有する制限**: ピークにそれらの容量の合計を掛けます

次に、Pod 内の別のコンテナなど、制限を共有する他のもののピークを加えます。

**5. 結果より上に制限を設定する**

制限を高くすれば、より重いビルドに余裕を残せます。低くすれば、フォーク爆弾をより早く止められます。

#### `pids.max` 制限を確認する

* **`pids.max` に達したかどうかを確認する**: 例えば `dmesg` を使って、ホストのカーネルログで `cgroup: fork rejected by pids controller in` と cgroup のパスを含む行を検索します。カーネルはその cgroup で最初にプロセスまたはスレッドを拒否したときにのみログに記録するため、ログ全体を検索してください。
* **適用中の制限を確認する**: ランナーの cgroup ディレクトリとその上位の各ディレクトリで `pids.max` を読み取ります。最も低い値が適用中の制限で、`max` はそのレベルで制限がないことを意味します。

## Kubernetes

ランナーはデフォルトでポート 8080 で `GET /healthz` を提供し、`--health-port` で設定可能です。Kubernetes プローブは追加セットアップなしで動作します。エンドポイントはプロセスが生きている限り `200` を返すため、以下のプローブはデッドプロセスを検出し、スタックしたプロセスは検出しません。ランナーがポーリングを停止したことをキャッチするには、[`/metrics`](https://code.claude.com/docs/ja/self-hosted-environments-reference#prometheus-metrics)から `last_poll_age_seconds` シリーズでアラートを出してください。以下の Deployment は Kubernetes Secret から環境シークレットをマウントし、liveness および readiness プローブを `/healthz` に指します。90 秒の終了猶予期間を設定します。[シャットダウンタイミング](#shutdown-timing)を参照して、猶予期間が重要な理由を確認してください。

マニフェストはランナーコンテナに CPU またはメモリ `resources` を設定しません。実行する容量のサイズ設定されたブロックを追加してください。[セッションの CPU とメモリをサイズ設定する](#size-cpu-and-memory-for-sessions)で説明されています。

```yaml theme={null}
apiVersion: apps/v1
kind: Deployment
metadata:
  name: claude-runner
  namespace: claude-runners
spec:
  replicas: 3
  selector:
    matchLabels:
      app: claude-runner
  template:
    metadata:
      labels:
        app: claude-runner
        app.kubernetes.io/part-of: claude-code-self-hosted-runner
    spec:
      terminationGracePeriodSeconds: 90
      containers:
        - name: runner
          image: <your-registry>/claude-runner:latest
          args:
            - self-hosted-runner
            - --environment-secret-file
            - /etc/claude/environment-secret
            - --capacity
            - "4"
            - --base-dir
            - /workspace
          volumeMounts:
            - name: environment-secret
              mountPath: /etc/claude
              readOnly: true
          ports:
            - name: health
              containerPort: 8080
          readinessProbe:
            httpGet:
              path: /healthz
              port: 8080
            initialDelaySeconds: 5
            periodSeconds: 10
          livenessProbe:
            httpGet:
              path: /healthz
              port: 8080
            initialDelaySeconds: 30
            periodSeconds: 30
      volumes:
        - name: environment-secret
          secret:
            secretName: claude-runner-environment-secret
```

上記の Deployment は `claude-runners` 名前空間に存在します。最初に名前空間を作成してください：

```bash theme={null}
kubectl create namespace claude-runners
```

管理 UI の [**環境キーをコピー**ステップ](https://code.claude.com/docs/ja/self-hosted-environments-quickstart.md#set-up-manually)でコピーした値を保持するローカルファイルからバッキング Secret を作成してください。シークレットはシェル履歴に表示されません。`(umask 077 && cat > ./environment-secret)` を実行し、シークレットを貼り付け、Enter キーを押してから Ctrl-D を押してください。次に Secret を作成してファイルを削除してください：

```bash theme={null}
kubectl create secret generic claude-runner-environment-secret -n claude-runners --from-file=environment-secret=./environment-secret
```

## Docker Compose

以下の Compose サービスは、ランナーが終了するたびに再起動します。これはクラッシュと通常のドレイン後の終了の両方をカバーします。Docker 再起動ポリシーは、書き込み可能なレイヤーを保持して同じコンテナを再起動するため、ランナーは[強化姿勢](#harden-your-deployment)が推奨する新しいファイルシステムではなく、再利用されたファイルシステムで戻ります。このレシピを評価に使用し、本番環境ではコンテナを実行ごとに再作成するか、そうするオーケストレーターを使用してください。

Docker は、コンテナが終了し続ける前に、より長く待機してから再起動します。上限に達するまで、ランナーが起動できない場合、このレシピの下で厳しいループで再起動し続けることはありません。[ランナーが終了するとき](#when-the-runner-exits)は、その場合に確認する内容について説明しています。

```yaml theme={null}
services:
  claude-runner:
    image: <your-registry>/claude-runner:latest
    command:
      - self-hosted-runner
      - --environment-secret-file
      - /run/secrets/environment-secret
      - --capacity
      - "4"
      - --base-dir
      - /workspace
    secrets:
      - environment-secret
    restart: always
    stop_grace_period: 90s

secrets:
  environment-secret:
    file: ./environment-secret
```

## シャットダウンタイミング

`SIGTERM` の後、ランナーはオーケストレーターに強制終了される前に、セッションをクリーンにシャットダウンするための時間を必要とします。必要な時間は起動時にログに記録され、デフォルト設定では `This runner needs up to 80s` を含む行として出力されます。オーケストレーターの停止タイムアウトを少なくともその秒数に設定してください。Kubernetes では `terminationGracePeriodSeconds`、Docker Compose では `stop_grace_period`、またはプラットフォームの同等の設定です。Kubernetes のデフォルトは 30 秒であるため、この設定がないと、ランナーが終了する前にポッドが停止される可能性があります。

`SIGTERM` を受け取ると、ランナーは新しいセッションの受け付けを停止します。次に、[`--defer-shutdown-max-min`](#defer-the-drain-past-the-first-signal) を設定して遅延させない限り、ドレインと呼ばれるグレースフルシャットダウンを開始します。ドレインは 3 つのステップで構成されます：

1. ランナーは、まだ実行中のターンが終了するのを最大 [`--drain-wait-sec`](https://code.claude.com/docs/ja/self-hosted-environments-reference#runner-cli-flags) 秒（デフォルトは `0`）待機します。
2. 各セッションのプロセスツリーを終了します。これには Claude がまだ実行していたコマンドも含まれますが、[シェルコマンドの終了後も実行し続けているプロセス](#processes-a-stopped-session-leaves)は含まれません。
3. [`post-session` ライフサイクルフック](https://code.claude.com/docs/ja/self-hosted-environments-configuration#post-session)を実行します。

ランナーはドレイン中も Anthropic へのポーリングを続けます。これによりセッションはそのランナーに割り当てられたままになるため、`post-session` フックがコミットされていない作業を保存している間に、別のランナーがそのセッションを引き継ぐことはありません。

ログに記録される時間は、次の値の合計です：

* ステップ 1 の `--drain-wait-sec`（デフォルトは 0 秒）
* ステップ 2 の [`--session-stop-grace-sec`](https://code.claude.com/docs/ja/self-hosted-environments-reference#runner-cli-flags)（デフォルトは 5 秒）
* ステップ 3 の [`--post-session-hook-timeout-sec`](https://code.claude.com/docs/ja/self-hosted-environments-reference#runner-cli-flags)（デフォルトは 60 秒）
* 固定の 15 秒の余裕
* [`--push-outcome-on-release`](https://code.claude.com/docs/ja/self-hosted-environments-reference#runner-cli-flags) が設定されている場合はさらに 30 秒

デフォルト設定では 0 + 5 + 60 + 15 = 80 秒になります。ランナーはすべてのセッションを同時にドレインするため、`--capacity` を増やしてもこの時間は増えません。

次のいずれかのフラグを設定する場合は、より多くの時間を確保してください：

* **[`--retire-at`](https://code.claude.com/docs/ja/self-hosted-environments-reference#runner-cli-flags) を使用する場合**：リタイア時刻とホストが停止する時刻の間に、典型的なターンが終了するのに十分な時間、[ランナーのライフサイクル](https://code.claude.com/docs/ja/self-hosted-environments#runner-lifecycle)で説明されているバックグラウンドタスクの待機時間、およびログに記録された時間を確保してください。リタイア時刻は起動のたびに計算します。例えば `date +%s` にランナーの想定稼働時間を加えます。
* **[`--defer-shutdown-max-min`](#defer-the-drain-past-the-first-signal) を使用する場合**：停止タイムアウトには、設定した分数と、ドレイン開始前のさらなる待機時間（デフォルト設定では 75 秒）も含める必要があります。両方については[最初のシグナルを超えてドレインを遅延させる](#defer-the-drain-past-the-first-signal)で説明しています。ランナーはこの長い時間も起動時にログに記録します。

### 再起動の前に実行中のターンを終了させる

ローリング再起動の前に実行中のターンを終了させるには、`--drain-wait-sec` を設定し、停止タイムアウトを少なくともその待機時間に 80 秒を加えた値に引き上げてください。デフォルトの待機時間 `0` では、再起動によってまだ実行中のターンが中断され、セッションは[プッシュされていない作業](#additional-limitations)を失った状態で別のランナーで再開されます。

* **`--drain-wait-sec`**：終了させたいターンとバックグラウンドタスクにかかる時間と同程度に設定します。これは最大値です：それらが先に終了した場合、待機は早めに終わります。
* **停止タイムアウト**：Kubernetes では `terminationGracePeriodSeconds`、Docker Compose では `stop_grace_period` です。例えば `--drain-wait-sec 120` の場合、[Kubernetes](#kubernetes) または [Docker Compose](#docker-compose) のレシピの `90` を `200` に置き換えます。
* **他のシャットダウン設定を変更した場合**：80 秒はデフォルト設定の場合の値です。使用するフラグで 1 つのランナーを起動し、起動時の行 `This runner needs up to` に示される数値（待機時間を含みます）以上を使用してください。[`--defer-shutdown-max-min`](#defer-the-drain-past-the-first-signal) を設定している場合は、次の起動時の行で `Size the stop timeout to at least` の後に示される、より大きい数値を使用してください。これらの数値に加算される要素は[シャットダウンタイミング](#shutdown-timing)に記載されています。

> [!WARNING]
>
> 待機中に停止タイムアウトが切れると、ホストは作業が実行中のままランナーを強制終了します。そのセッションでは `post-session` フックが実行されません。また、ランナーは登録解除されないため、コントロールプレーンがそれらのセッションを再キューイングするまでに数分、場合によってはそれ以上かかることがあります。

### 再起動の前にステータスメッセージを投稿する

セッションを中断する再起動の前に、[Owner](https://code.claude.com/docs/ja/cloud-environments.md#organization-shared-environments) に [**Cloud environments** 管理ページ](https://claude.ai/admin-settings/cloud-environments)から環境にステータスメッセージを投稿してもらいます。[claude.ai/code](https://claude.ai/code) では、メンバーはその環境内の自分のセッションでメッセージを確認できます。投稿時に Owner に有効期限を設定してもらうか、ランナーが復帰したらメッセージを削除してもらってください。

### 最初のシグナルを超えてドレインを遅延させる

再起動しているランナーが最初のシグナルでドレインするのではなく、最大 `n` 分間保持するセッションを提供し続けるようにしたい場合は、[`--defer-shutdown-max-min <n>`](https://code.claude.com/docs/ja/self-hosted-environments-reference#runner-cli-flags)を設定してください。最初の `SIGTERM` または `SIGINT` では、ランナーは新しい作業を受け取るのを停止し、保持するセッションを提供し続けます。ポーリングを続けるため、コントロールプレーンはそれらのセッションを再キューイングしません。Claude Code v2.1.238 以降が必要です。

#### 最初のシグナル後にランナーが保持するセッションに何が起こるか

最初のシグナルに続く最初の 2 つのステージでは、ランナーはセッションをリリースし、リリースされたセッションはユーザーが次のメッセージを送信するときに新しいランナーで再開されます。最初のシグナルからカウントして、ランナーは 3 つのステージを通じて移動します：

* **最初の `n` 分間**：ランナーは通常セッションを提供し、`--startup-timeout-min` と `--kill-session-after-min` を適用し続けます。[`--release-idle-session-min`](https://code.claude.com/docs/ja/self-hosted-environments-reference#runner-cli-flags)も設定した場合、ランナーはユーザーがその時間アイドル状態だったセッションをリリースします。それなしでは、アイドルセッションはランナーに留まります。
* **`n` 分が経過したとき**：ランナーは、アイドルかどうかにかかわらず、まだ保持しているすべてのセッションをリリースします。ランナーはターン途中のセッションのターンが終了するのを待ち、ターンのバックグラウンドタスクのためにさらに最大 60 秒待ってから、そのセッションをリリースします。
* **リリース後の猶予が経過したとき**：ランナーはまだ保持しているセッションをドレインし、コントロールプレーンは各ドレインされたセッションを別のランナーにすぐに再キューイングします。リリース後の猶予は `n` 分が経過したときに開始され、デフォルトでは 75 秒です。`--drain-wait-sec` を 60 秒より大きく設定した場合、リリース後の猶予は代わりに `--drain-wait-sec` + 15 秒になります。

任意のステージで、ランナーはセッションを保持しなくなるとすぐに 0 で終了します。2 番目のシグナルはステージを短縮します：`--defer-shutdown-max-min` なしの最初のシグナルの場合と同様に、ランナーは直ちにドレインします。ドレインが進行中になると、次のシグナルはランナーを強制終了します。これは、ドレインを開始したのが 2 番目のシグナルであっても、リリース後の猶予の経過であっても同じです。

#### 停止タイムアウトをサイズ設定する

ホストの停止タイムアウトに、少なくとも 3 つの部分の合計を与えてください：設定する `n` 分、リリース後の猶予、[シャットダウンタイミング](#shutdown-timing)で説明されているドレインです。デフォルト設定ではリリース後の猶予は 75 秒、ドレインは最大 80 秒かかるため、`n` 分 + 155 秒を確保してください。`--defer-shutdown-max-min` が設定されている場合、ランナーはこの合計を起動時に出力します。

ランナーが終了する前に停止タイムアウトが切れると、まだ保持しているセッションでは `post-session` フックが実行されません。ランナーは登録解除されないため、コントロールプレーンがそれらのセッションを再キューイングするまでに数分、場合によってはそれ以上かかることがあります。停止タイムアウトにその合計を与えることができない場合は、`--defer-shutdown-max-min` を設定しないままにして、ランナーが最初のシグナルでドレインするようにしてください。

### 実行中の post-session フックに到達するもの

`post-session` フックと Claude セッション子は、それぞれ独自の POSIX プロセスグループで実行され、ランナーから分離されているため、停止メカニズムは異なる方法で到達します：

* **ランナーが既にドレイン中の `SIGTERM`**：ランナーを直ちに強制終了し、ドレインの残りをスキップします。[`--defer-shutdown-max-min`](#defer-the-drain-past-the-first-signal)なしでは、ランナーが受け取る 2 番目の `SIGTERM` です。実行中の `post-session` フックにはシグナルが送信されないため、init プロセスが孤児プロセスを引き取るベアホストでは、フックは独自に終了しますが、監視されていません：タイムアウト予算はもはや適用されず、閉じたログパイプへの書き込みによって `SIGPIPE` で強制終了される可能性があるため、そこで強制終了から生き残る必要があるフックは独自の出力をファイルにリダイレクトする必要があります。このページのコンテナレシピでは、ランナーはコンテナの PID 1 であり、その終了はコンテナを終了させます。また systemd のデフォルト `KillMode=control-group` の下では、**Cgroup 全体のキル**の項目で説明するように、cgroup 全体のキルがフックにも到達します。どちらの場合も、強制終了をフックにとって致命的なものとして扱い、代わりに猶予期間に依存してください。
* **プロセスグループ全体のシグナル**（ラッパースクリプト内の `kill -- -<pid>`、シェルのジョブ制御、グループ全体のウォッチドッグなど）：ランナーと、`checkout` フック実行中のサブプロセス（意図的にグループに接続されたままです）に到達しますが、実行中の `post-session` フックやセッション子には到達しません。
* **Cgroup 全体のキル**（systemd のデフォルト `KillMode=control-group` や、`terminationGracePeriodSeconds` が期限切れになったときに Kubernetes がコンテナ全体に送信する `SIGKILL` など）：フックを含むすべてに到達します。プロセスグループの分離ではこれらから保護できないため、猶予期間はドレイン全体をカバーする必要があります。
* **フック独自のタイムアウト**：フックが `--post-session-hook-timeout-sec` を超えると、ランナーはフックの全体プロセスグループに `SIGTERM` を送信し、2 秒後に `SIGKILL` を送信します。フックがフォークしたワーカー（tar、rsync、git など）はラッパーシェルと一緒に終了し、孤児として生き残りません。ランナーの監視は、フックの stdio が閉じたときに終了します：独自の出力をファイルにリダイレクトし、`SIGTERM` ステージを超えて生き残るワーカーはランナーの到達範囲を超えています。

ドレインが開始されたとき、および強制終了時に、ランナーはまだ実行中の `post-session` フックの数をログに記録するため、静かなドレインとスナップショット途中のドレインを区別できます。

## ベースディレクトリと容量をランナー全体で同じに保つ

ランナーがセッション途中で死亡した場合、サーバーはセッションを再キューイングし、環境内の別のランナーがそれを取得します。そのランナーは、独自の `--base-dir` と `--capacity` からチェックアウトパスを導出します：`--capacity 1` は `--base-dir` の直下にチェックアウトし、`--capacity` が `1` を超える場合は代わりにセッションごとの worktree を使用します。同じ環境内のランナーがこれらのフラグのいずれかに異なる値を使用する場合、再開されたセッションの作業ディレクトリが変更され、エージェントが以前に記録した絶対パス（編集、ツール呼び出し、独自のメモ）は、もはや存在しない場所を指します。

環境内のすべてのランナーで同じ `--base-dir` と `--capacity` を使用し、インスタンス ID やホスト名などのホストごとの値を使用しないでください。[Kubernetes](#kubernetes) および [Docker Compose](#docker-compose) のレシピと同様に両方のフラグを明示的に渡し、どちらの値もデフォルトに依存しないようにしてください。

ベースディレクトリのデフォルトは `/workspace` です。[`--base-dir` リファレンス行](https://code.claude.com/docs/ja/self-hosted-environments-reference#runner-cli-flags)が記録する例外を除きます。ランナーは書き込みアクセスが必要です。起動時に登録する前に、ランナーはディレクトリを作成し、書き込みできることを確認し、できない場合は `cannot create or write to base directory` で終了します。ルートとして開始されたランナーはデフォルト `/workspace` を自分で作成します。非ルートランナーの場合、ランナーを開始する前にディレクトリを作成してランナーのユーザーに所有権を与えるか、`--base-dir` をそのユーザーが既に所有しているディレクトリを指してください。

## 事前にウォームアップされたチェックアウトを再利用する

大規模なリポジトリの場合、クローンがセッション起動を支配することがあります。コールドクローンをスキップするには、ランナーが自身のクローンを保持するパスにクローンを自分で用意します。[`checkout` フック](https://code.claude.com/docs/ja/self-hosted-environments-configuration#checkout) がない場合、ランナーは `<base-dir>/<repo-owner>/<repo>` でリポジトリごとに 1 つの正規クローンを保持し、セッション全体で再利用します。

* **`--capacity 1` の場合**: ランナーは要求された ref をフェッチし、`HEAD` をデタッチして、それにハードリセットします。これは変更がほとんどない場合、ほぼ瞬時に完了します。
* **`--capacity` が 1 より大きい場合**: ランナーはそのクローンにフェッチし、セッションごとにそこから個別の worktree をチェックアウトします。事前にウォームアップされたクローンによってダウンロードは省略されますが、チェックアウトは省略されません。

クローンはイメージ内または永続ボリューム上に用意します。

* **イメージ内にクローンを配置する**: ランナーイメージをそのパスにビルドしてクローンを含めます。その後、新しいコンテナはすべてディスクを再利用せずにウォームクローンで起動します。
* **永続ボリューム上にクローンを配置する**: [`--lock-to-account`](https://code.claude.com/docs/ja/self-hosted-environments-reference#runner-cli-flags) で 1 人のユーザーアカウントにプリロックされたランナーで、`--base-dir` を永続ボリュームに指定すると、ディスクはそのアカウントのみを提供します。プリロックされたランナーは Claude Tag チャネルセッションを取得しないため、このオプションはそれらを提供するランナーには適用されません。

再利用パスが保証するもの、しないもの：

* **クローンの深さ**: クローンは `--depth` なしでビルドしてください。`--single-branch` の有無は問いません。ランナーは `origin` リモートを持つクローンにフェッチするとき、[`CLAUDE_RUNNER_FETCH_DEPTH`](https://code.claude.com/docs/ja/self-hosted-environments-reference#environment-variable-only-settings) を設定していても `--depth` を渡しません。完全なクローンでは、各セッションはクローンに欠けているコミットのみをダウンロードします。シャロークローンでは、クローンの最も古いコミットより前に分岐したブランチ上のセッションは、そのブランチの履歴全体をダウンロードします。
* **追跡された変更はリセットされ、追跡されていないファイルは保持される**: `--capacity 1` では、各セッションはハードリセットから開始され、前のセッションの追跡された変更を削除しますが、ランナーは `git clean` を実行しないため、ロックされたオーナーの以前のセッションからの追跡されていないファイルはツリーに残ります。
* **セッションごとのディレクトリも保持される**: チェックアウトの横に、ランナーは実行するすべてのセッションに対して `<base-dir>/_sessions/` の下にセッションごとのエントリを作成します。セッションの Claude 設定ディレクトリは、会話トランスクリプトのローカルコピーを保持します。その横には、セッションがある場合、セッションのアップロードされたファイルが配置されます。セッションディレクトリもそこに配置されます。セッションの実行中、セッションごとの worktrees と `checkout` フックチェックアウトを保持し、Claude がそこに書き込んだ他のすべてのものを保持します。

  デフォルトでは、ランナーはセッションが終了したときにこれらをそのまま残すため、ランナープロセスより長く存続するディスク上に蓄積されます。すべてのセッションはランナー自身のユーザーとして実行されるため、そのディスクが提供する後続のセッションはそれらを読み取ることができます。永続的な `--base-dir` を保持する場合は、その成長に対応するようにボリュームのサイズを設定してください。同じことは、[Docker Compose レシピ](#docker-compose) を含む、同じファイルシステム上でランナーを再起動するすべてのセットアップに適用されます。
* **`--remove-session-state` を使用する場合、セッションごとのディレクトリは保持されない**: [`--remove-session-state`](https://code.claude.com/docs/ja/self-hosted-environments-reference#runner-cli-flags) でランナーを起動して、セッションが終了するときに各セッションのセッションごとのディレクトリを削除させます。削除はベストエフォートです。ランナーがクリーンアップ実行前に強制終了された場合、ディレクトリは残ります。正規クローンとセッションがホスト上の他の場所（一時ディレクトリなど）に書き込んだファイルは、いずれにせよ残ります。
* **git プロキシを使用する場合、リセットはチェックアウトになる**: [`--use-anthropic-git-proxy`](#use-the-anthropic-git-proxy) を使用すると、ランナーは各セッションの前にクローンの `.git/` をサニタイズします。オブジェクトストアとシャロー状態は保持し、インデックスは削除します。インデックスがないため、各セッションはほぼ瞬時のリセットではなく、完全なワーキングツリーチェックアウトから開始されます。それでもランナーは、リポジトリを再度クローンするのではなく、既存のクローンにフェッチします。プロキシの下ではサブモジュールプリウォームはサポートされていません。
* **git プロキシを使用する場合、`reftable` のプリウォームは ref を失う**: ランナーは各セッションの前に `.git/` をサニタイズする際、`.git/refs/` を保持し、`.git/reftable/` ディレクトリを削除します。git の `reftable` ref 形式でプリウォームされたクローンはこの処理によって ref を失うため、代わりに git の `files` ref 形式でクローンをプリウォームしてください。
* **長いクローンは回避策を必要としない**: ランナーは各 git 操作を 120 秒の無進捗ウォッチドッグと 30 分のハードキャップで制限し、フラットタイムアウトではないため、進捗を報告し続けるスローコールドクローンは完了します。

### ランナーがクローンを使用していることを確認する

ランナーがクローンを使用していることを確認するには、[`--log-level debug`](https://code.claude.com/docs/ja/self-hosted-environments-reference#runner-cli-flags) を指定してランナーを起動し、そのリポジトリでセッションを開始します。ランナーは `Prefetched repo found at` とクローンのパスをログに記録します。代わりに `No prefetched repo, fresh init at` をログに記録した場合、その行に示されたパスで使用可能なクローンが見つからなかったことを意味します。クローンがそのパスにあり、ランナーのユーザーが所有しており、`origin` という名前のリモートを持っていることを確認してください。

ランナーがクローンを見つけているにもかかわらずセッションの起動が遅い場合は、クローンがシャロークローンになっていないか確認してください。

## バージョンをピンする

各セッションの子プロセスはデフォルトでランナー独自のバイナリを実行し、ランナーは自身が起動するセッション内でオートアップデートをオフにします。このデフォルトでは、すべてのセッションはホストにインストールされたか、イメージに組み込まれたバージョンを実行します。ホストレベルのアップデートはランナーが次に開始するときに有効になります。

セッションが実行するバージョンと、それを変更するタイミングを選択します。

* **バージョンをピンする前に**：セッションが使用するすべてのモデルについて [モデルが必要とする Claude Code バージョン](https://code.claude.com/docs/ja/model-config.md#available-models) を確認してください。モデルがセッションで実行されるバージョンより新しいバージョンを必要とする場合、サーバーはそのモデルのリクエストを [Claude Code does not support this model](https://code.claude.com/docs/ja/errors.md#claude-code-does-not-support-this-model) で拒否します。
* **フリートを 1 つのバージョンに保持するには**：ピンされたバージョンでイメージをビルドするか、ベアホストで特定のバージョンをインストールし、[オートアップデートを無効にしてください](https://code.claude.com/docs/ja/setup.md#disable-auto-updates)
* **固定フリートをアップグレードするには**：現在のバージョンとインストールするバージョンの間の [changelog](https://code.claude.com/docs/en/changelog.md) のエントリを確認してから、新しいバージョンをインストールするか、イメージを再ビルドしてランナーを再起動してください
* **オンデマンドランナーをアップグレードするには**：現在のバージョンとインストールするバージョンの間の [changelog](https://code.claude.com/docs/en/changelog.md) のエントリを確認してから、[`spawn-runner` フック](https://code.claude.com/docs/ja/self-hosted-environments-configuration#the-spawn-runner-hook)が起動するイメージを変更してください。新しいランナーにはそれぞれ新しいバージョンが適用されます。すでに起動しているランナー（[`--min-idle`](https://code.claude.com/docs/ja/self-hosted-environments-reference#orchestrator-cli-flags) によって起動されたスタンバイランナーを含む）は、終了するまでそのバージョンを維持します。その作業指示は一度しか使用できないため、再起動しないでください。
* **セッションが別のバイナリを起動する場合**：[`--exec-path`](https://code.claude.com/docs/ja/self-hosted-environments-reference#runner-cli-flags) または [`command` フック](https://code.claude.com/docs/ja/self-hosted-environments-configuration#command)を使用してランナー独自のもの以外の Claude Code バイナリを起動する場合、セッションはそのバイナリのバージョンを実行します。ランナーをアップデートするときは、そのバイナリもアップデートしてください。
* **プラグイン**：プラグインマーケットプレイスもオートアップデートしません。ランナーの環境で `FORCE_AUTOUPDATE_PLUGINS=1` を設定して、バイナリがピンされたままの間、プラグインをオートアップデートさせます

## フリートをスケーリングする

オーケストレーターは、ランナーを追加または削除するタイミングを決定します。[ランナーのライフサイクル](https://code.claude.com/docs/ja/self-hosted-environments#runner-lifecycle)に関する 1 つのオーナーごとのロックのため、最小レプリカ数は、同時にアクティブになると予想されるユーザーと Claude Tag エージェントの数です。`--capacity` は、オーナー全体ではなく、1 つのオーナーのセッション内での並列処理を制御します。

2 つのスケーリングアプローチが利用可能です。

* **固定フリート**: 静的なランナーレプリカセットを実行し、各ランナーが提供する [Prometheus メトリクス](https://code.claude.com/docs/ja/self-hosted-environments-reference.md#prometheus-metrics)に基づいてスケーリングします
* **オンデマンドランナー**: `claude self-hosted-runner orchestrator` サブコマンドを実行します。このコマンドは、利用可能なランナーがないキューに入っているセッションについて Anthropic をポーリングし、`spawn-runner` フックを呼び出して、セッションごとに 1 つ起動します。[オンデマンドランナー](https://code.claude.com/docs/ja/self-hosted-environments-configuration.md#on-demand-runners)を参照してください。

### 固定フリートでアイドル状態のセッションを解放する

固定フリートですべてのランナーがオンラインであるにもかかわらずセッションがキューに入ったままになる場合、アイドル状態のセッションが原因である可能性があります。デフォルトでは、セッションはターンが終了した後もスロットを保持し、そのランナーはそのセッションの[オーナー](https://code.claude.com/docs/ja/self-hosted-environments#key-concepts)にロックされたままになります。チームの[クラウドスケジュールタスク](https://code.claude.com/docs/ja/routines.md)が実行のたびに新しいセッションを開始する場合、そのアイドル状態のセッションがすべてのスロットを埋めてしまう可能性があります。

確認するには、各ランナーの [Prometheus メトリクス](https://code.claude.com/docs/ja/self-hosted-environments-reference.md#prometheus-metrics)で `claude_code_self_hosted_runner_session_idle_seconds` を読み取ります。ランナーが保持する各セッションには独自の系列があり、セッションがビジー状態の間は `0`、それ以外の場合はアイドル状態になってからの秒数を示します。許容するアイドル時間を選択してください。作業途中で人が取る休止よりも長く、かつスケジュールタスクの次の実行が始まる前に各実行が解放されるほど短い時間にします。系列をその時間と比較します。

* **その時間を超える系列（30 分の場合の `1800` など）**: アイドル状態のセッションがそれらのスロットを保持しているため、`--release-idle-session-min` を設定します
* **すべての系列がその時間未満**: それほど長くアイドル状態のセッションはありません。ランナーを追加するか、[アイドル状態にならないセッション](#some-sessions-don’t-count-as-idle)のために [`--kill-session-after-min`](https://code.claude.com/docs/ja/self-hosted-environments-reference#runner-cli-flags) を設定します。
* **系列がないランナー**: そのランナーを保持しているセッションはありません。[トラブルシューティング](#troubleshooting)の **Sessions stay queued** を参照してください。
* **メトリクスが応答しないランナー**: プロセスが終了している可能性があります。[ランナーが終了したとき](#when-the-runner-exits)の **An environment that looks healthy** を参照してください。

アイドル状態のセッションを解放するには、すべてのランナーを [`--release-idle-session-min`](https://code.claude.com/docs/ja/self-hosted-environments-reference#runner-cli-flags) とその時間（分単位）を指定して起動します（例: `--release-idle-session-min 30`）。ランナーは、スケジュールタスクと人のどちらが開始したかにかかわらず、その時間アイドル状態が続いたセッションを解放します。

* **プッシュされていない作業**: 解放されたセッションは次のメッセージで再開されますが、プッシュしていなかった作業は失われます。コミットを保持するには、[再開されたセッションはプッシュされていない作業を失う](#additional-limitations)を参照してください。
* **ランナーの終了**: 最後のセッションを解放したランナーは[通常の終了](#when-the-runner-exits)を開始します。[デプロイを強化する](#harden-your-deployment)で説明しているように、スーパーバイザーが新しいファイルシステム上でランナーを再起動するようにしてください。
* **アイドル状態にならないセッション**: [一部のセッションはアイドル状態としてカウントされない](#some-sessions-don’t-count-as-idle)ため、[`--kill-session-after-min`](https://code.claude.com/docs/ja/self-hosted-environments-reference#runner-cli-flags) も設定します

## 既知の問題と制限事項

このリリースにおける制限事項と、回避策がある場合はその回避策を以下に示します。

### コネクタのトラフィックはネットワーク外に出る

Anthropic は、コネクタのツールをランナーからではなく、Anthropic 自身のインフラストラクチャから呼び出します。コネクタのツールとは、GitHub、Slack、Linear などの claude.ai のコネクタです。セルフホストセッションで Claude がコネクタを使用すると、そのトラフィックはネットワーク境界の内側から発信されるのではなく、`api.anthropic.com` を経由します。

コネクタをセルフホストセッションから除外するには、[`allowedMcpServers` および `deniedMcpServers` ポリシー設定](https://code.claude.com/docs/ja/managed-mcp#policy-based-control-with-allowlists-and-denylists)でフィルタリングします。Claude Code はこれらの設定を、ランナーホストからシードするサーバーやユーザーが追加するサーバーだけでなく、Anthropic が配信するコネクタにも適用します。そのため、他のサーバー向けに許可リストをデプロイすると、Claude Code は配信されたコネクタもブロックします。URL ベースの許可リストを使いながらコネクタを引き続き利用できるようにするには、配信されるコネクタ用の Anthropic プロキシのパスに一致するエントリを追加します。

* `https://api.anthropic.com/v2/ccr-sessions/*`
* `https://api.anthropic.com/v1/code/sessions/*`
* `https://api.anthropic.com/v1/code/mcp/*`

ツールのトラフィックをネットワーク内に留める必要がある場合は、代わりに同等のツールをランナーイメージ上のローカル MCP サーバーとして実行してください。[MCP サーバー](https://code.claude.com/docs/ja/self-hosted-environments-configuration.md#mcp-servers)を参照してください。

### 一部のセッションはアイドルとみなされない

終了しないバックグラウンドタスクを保持しているセッションはアイドルとみなされないため、`--release-idle-session-min` はそのセッションのスロットを解放しません。実行中のツール呼び出しの内部から要求された承認を待っているセッションも、アイドルとみなされません。どのセッションもスロットを無期限に保持できないように、厳格な安全策として必ず `--kill-session-after-min` を併せて設定してください。

`--kill-session-after-min` は、暴走したセッションに対する安全策です。v2.1.260 以降のランナーでは、上限に達したセッションはただちに終了されません。ランナーはそのセッションに猶予期間（デフォルトは 15 分）を与えます。この期間は [`SELF_HOSTED_RUNNER_MAX_LIFETIME_GRACE_MS`](https://code.claude.com/docs/ja/self-hosted-environments-reference#environment-variable-only-settings) で変更できます。

* セッションがユーザーを待っている場合、ランナーはそのセッションを解放します。ターンが終了していてバックグラウンドタスクのみを保持している場合、ランナーはそれらのタスクが完了するまで最大 60 秒待ってから、セッションを解放します。セッションは、ユーザーが次のメッセージを送信すると再開されます。
* ターンがまだ実行中の場合、ランナーはターンが完了するか、セッションが次にユーザーを待つ状態になるまで待ってから、セッションを解放します。
* 猶予期間が終了した時点でセッションがまだランナー上にある場合、ランナーはセッションを終了し、実行中のターンの作業は失われます。実行中のツール呼び出しの内部から要求された承認をターンが待っている場合は、セッションが猶予期間を超えて残る一例です。

解放されたセッションは新しいクローンから再開されるため、いずれの場合もプッシュしていなかった作業は失われます。[再開されたセッションではプッシュしていない作業が失われる](#additional-limitations)を参照してください。v2.1.260 より前では、ランナーは実行中のターンの完了を最大で猶予期間だけ待った後、上限に達したすべてのセッションを終了していました。

このフラグは、想定される最長のセッションよりも長い値に設定してください。たとえば 8 時間の場合は `--kill-session-after-min 480` とします。アイドル状態になった会話からスロットを解放するには、代わりに `--release-idle-session-min` を使用してください。

### その他の制限事項

* **再開されたセッションではプッシュしていない作業が失われる**: 新しいランナーはリポジトリを開始ブランチから再度クローンするため、セッションがプッシュしていなかった作業は失われます。
  * **コミット済みの作業を保持するには**: 環境内のすべてのランナーで [`--push-outcome-on-release`](https://code.claude.com/docs/ja/self-hosted-environments-reference#runner-cli-flags) を設定してください。このフラグのないランナーは、セッションを開始ブランチから再開するためです。このフラグを設定したランナーは、解放する前にセッションの成果ブランチのプッシュをベストエフォートで行い、再開されたセッションはそれらのコミットから開始されます。プッシュにはランナーホスト自身の git 認証情報が使用されます。これは [Anthropic 管理の git](#use-the-anthropic-git-proxy) を使用するランナーでも同様です。
  * **`checkout` フックを使用する場合**: [`checkout` ライフサイクルフック](https://code.claude.com/docs/ja/self-hosted-environments-configuration#checkout)でチェックアウトされたリポジトリはプッシュされません。代わりに [`post-session` フック](https://code.claude.com/docs/ja/self-hosted-environments-configuration#post-session)からそれらのスナップショットを取得してください。
  * **フラグを有効にする前に**: ソースリモート上の `claude/*` ref にプッシュできるユーザーを制限してください。再開時、ランナーは以前にプッシュされたブランチを、誰がプッシュしたかを検証せずにフェッチします。
  * **コミットされていない変更は引き続き失われる**: Claude が応答を終えたときにコミットとプッシュを行うよう促すには、[セッションに作業のプッシュを促す](https://code.claude.com/docs/ja/self-hosted-environments-configuration.md#prompt-sessions-to-push-their-work)を参照してください。
* **ランナーの喪失によって中断されたコマンドが再度実行されることがある**: セッションが別のランナーで再開されると、中断されたツール呼び出しが、その成否が不明であることを示す結果とともに Claude に表示されます。
* **セッションの途中で追加したリポジトリのクローンが失敗することがある**: Claude は HTTPS 経由の `git clone` でリポジトリをクローンします。[`--use-anthropic-git-proxy`](#use-the-anthropic-git-proxy) を使用していないランナーでは、ホスト上にリポジトリを読み取れるものが何もない場合、クローンは git の認証エラーで失敗します。可能であれば、セッションの作成時に、セッションで必要なすべてのリポジトリを選択してください。
* **一部のコネクタがセルフホストセッションに表示されない**: claude.ai の設定でまだ接続していないコネクタはセルフホストセッションに表示されず、セッションから接続を求められることもありません。まず設定で接続してから、新しいセッションを開始してください。また、すでに実行中のセッションにコネクタを追加しても、そのツールは Claude で使用できるようになりません。新しく追加したコネクタを反映するには、新しいセッションを開始してください。
* **誰かがセッションをアーカイブまたは削除した場合、またはセッションのメニューからランナーを解放した場合**: [`--push-outcome-on-release`](https://code.claude.com/docs/ja/self-hosted-environments-reference#runner-cli-flags) によるプッシュは当てにしないでください。このような場合にコミットを保存するには、[`post-session` フック](https://code.claude.com/docs/ja/self-hosted-environments-configuration#post-session)から `HEAD` を退避用ブランチにプッシュしてください。そこにある例をもとにする場合は、コミットされていない変更が何もないときでもプッシュするように変更してください。この例はスナップショットのコミットを作成した後にのみプッシュするためです。

### 問題を報告する

セルフホスト環境に関する問題については、Anthropic のアカウントチームにお問い合わせください。

## トラブルシューティング

ガイド付きの診断を行うには、ランナーホストで doctor サブコマンドを実行します。doctor サブコマンドは、ランナーのログと状態を添付した対話型の Claude Code セッションを開始します。セッションが環境、そのランナー、キューに入っているセッションを照会できるように、先にそのホストで `claude auth login` を使ってサインインしてください。このサインインがない場合（たとえばホストが API キーで認証する場合）、利用できるのはローカルのヘルスエンドポイント、メトリクス、ランナーのログに限られ、ログを読み取るのもランナーを `--log-file` 付きで起動した場合のみです。

```bash theme={null}
claude self-hosted-runner doctor
```

よくある問題:

* **ランナーが環境に表示されない**: ホストが HTTPS 経由で `api.anthropic.com` に到達できること、環境シークレットが最新であること、ホストの時計と実時間との差が 5 分以内であることを確認してください。それより大きなずれがあると認証が失敗します。認証に失敗すると、ランナーは拒否理由とともに `[runner:fatal]` をログに記録します。
* **ランナーが起動時に `cannot create or write to base directory` で終了する**: ランナーが `--base-dir`（デフォルトは `/workspace`）を作成できないか、書き込めません。[ランナー間でベースディレクトリと容量を同一に保つ](#keep-the-base-directory-and-capacity-identical-across-runners)で説明しているとおり、ディレクトリの所有権を修正するか、`--base-dir` を書き込み可能なパスに向けてください。代わりにランナーがベースディレクトリのチェックがタイムアウトしたという `[runner:fatal]` をログに記録する場合、そのディレクトリはハングした NFS または CSI マウント上にあります。権限ではなくマウントの健全性を確認してください。ランナーはこれら 2 つの起動時の失敗を `--log-file` を開く前に stderr に出力するため、ログファイルではなくターミナルまたはプラットフォームのコンテナログで探してください。v2.1.225 より前は、ランナーは起動時にベースディレクトリをチェックしておらず、この設定ミスがあると代わりにピックアップ後にセッションが失敗していました。
* **ランナーが起動時に `RegisterRunner failed:` と TLS 証明書エラーで終了する**: エラーはたとえば `self signed certificate in certificate chain` となることがあります。TLS を検査するプロキシの背後にある場合のように、ランナーが受け取った証明書の背後にある認証局（CA）を信頼していません。ランナーの環境で [`NODE_EXTRA_CA_CERTS`](https://code.claude.com/docs/ja/network-config#custom-ca-certificates) に、プロキシのルート CA を含む PEM ファイルを設定してください。

  セッションはこれを継承するため、セッション用に再度設定する必要はありません。Git はこれを読み取りません。そのプロキシを経由したクローンには、[`GIT_SSL_CAINFO`](#trust-a-private-certificate-authority-with-anthropic-managed-git) も設定してください。
* **開始スクリプトが `Resource temporarily unavailable` を含む書き込みエラーを出力して終了する**: スクリプトが、自身が起動する `claude self-hosted-runner` または [orchestrator](https://code.claude.com/docs/ja/self-hosted-environments-configuration.md#on-demand-runners) プロセスと stdout または stderr を共有しており、そのプロセスが共有のパイプまたはソケットをノンブロッキングモードに切り替えています。パイプがいっぱいになると、スクリプトからの書き込みは待機せずにこのオペレーティングシステムのエラーで失敗し、`set -e` の下ではスクリプトが終了します。

  このエラーを止めるには、ランナーまたはオーケストレーターの出力を、スクリプトのユーザーが作成できるファイルに送ってください。それを起動するコマンドに、バックグラウンド化する `&` より前の位置で `>> "$HOME/claude-runner.log" 2>&1` を追加します:

  ```bash theme={null}
  claude self-hosted-runner --environment-secret-file /etc/claude/environment-secret >> "$HOME/claude-runner.log" 2>&1
  ```

  スクリプト自身の出力は引き続き以前と同じ場所に出力され、ランナーが stdout と stderr に書き込む内容（起動エラーを含む）はそのファイルに出力されます。[`--log-file`](https://code.claude.com/docs/ja/self-hosted-environments-reference#runner-cli-flags) 単体ではなく、このシェルリダイレクトを使用してください。`--log-file` はログをファイルにミラーリングしますが、ランナーは stdout と stderr への書き込みを続けます。すでに `--log-file` を渡している場合は、それもそのまま残してください。リダイレクトはそのファイルが受け取る内容を変えないためです。
* **オーケストレーターが TLS 証明書エラーとともに `poll failed:` をログに記録し、再試行を続ける**: TLS を検査するプロキシの背後にある場合のように、オーケストレーターが受け取った証明書の背後にある CA を信頼していません。オーケストレーターの環境で [`NODE_EXTRA_CA_CERTS`](https://code.claude.com/docs/ja/network-config#custom-ca-certificates) に、プロキシのルート CA を含む PEM ファイルを設定してください。`spawn-runner` フックが起動するランナーにも設定してください。

  たとえば、行が `poll failed: self signed certificate in certificate chain — retrying in 1s` で終わることがあり、コロンとダッシュの間に TLS ライブラリの文言が入ります。修正を確認するには、オーケストレーターの [`/healthz`](https://code.claude.com/docs/ja/self-hosted-environments-reference#health-endpoint) のボディで `connected` が `true` であることを確認してください。
* **セッションがキューに入ったままになる**: すべてのオンラインランナーがそれぞれ別の所有者にロックされている可能性があります。各ランナーの `claude_code_self_hosted_runner_locked_account` [メトリクス](https://code.claude.com/docs/ja/self-hosted-environments-reference.md#prometheus-metrics)、またはその `[runner:health]` ログ行の `locked_account` フィールドを確認して、誰がロックしているかを調べてください。どちらも、`act.email` クレームを含むセッショントークンがランナーに発行された後にのみ所有者のメールアドレスを表示しますが、Claude Tag エージェントのセッションではこのクレームが含まれることはありません。クレームがない場合、ランナーは `locked_account` 系列を出力せず、`locked_account=yes` をログに記録します。これはランナーがロックされていることを示しますが、どの所有者にロックされているかは示しません。レプリカを追加するか、既存のランナーがドレインして再起動するのを待ってください。環境がオンデマンドランナーを使用している場合は、代わりにオーケストレーターを確認してください。[オンデマンドランナー](https://code.claude.com/docs/ja/self-hosted-environments-configuration.md#on-demand-runners)を参照してください。
* **ピックアップ直後にセッションが失敗する**: claude.ai/code でセッションを開いてエラーを確認してください。git が認証できなかったことをエラーが示している場合は、ランナーの [git 認証情報](#configure-git)を確認してください。`--use-anthropic-git-proxy` 付きで起動したランナーでは、[git プロキシを使用するランナーでセッションの開始に失敗した場合](#when-anthropic-doesnt-serve-a-session)を参照してください。

  書き込めないベースディレクトリは、セッションを失敗させるのではなく、起動時にランナーを停止させます。このリストの **ランナーが起動時に `cannot create or write to base directory` で終了する** の項目を参照してください。
* **セッションはピックアップされたが、Claude が最初のメッセージに応答しない**: ランナーがプロキシ経由で `api.anthropic.com` に到達している場合は、セッションの `/worker/events/stream` レスポンスを到着したとおりに通過させるようにプロキシを設定してください。ランナーのタイムアウトを引き上げても解決しません。ランナーのログで原因を確認するには、[セッションはピックアップされたが、Claude が最初のメッセージに応答しない](#when-a-sessions-first-message-is-never-answered)を参照してください。
* **`--use-anthropic-git-proxy` を設定したランナーでセッションの開始に失敗する**: ランナーのログで `access denied by the git proxy`、または `/git_proxy/` を含む `api.anthropic.com` アドレスを示す git エラーを探してください。Anthropic がセッションを処理したかどうかを判断して原因を修正するには、[git プロキシを使用するランナーでセッションの開始に失敗した場合](#when-anthropic-doesnt-serve-a-session)を参照してください。
* **認証を行うエグレスプロキシ経由でセッションがネットワークに到達できない**: [`--proxy-authorization-command` または `--proxy-authorization-file`](#authenticate-to-an-egress-proxy) で設定したソースが失敗する、30 秒後にタイムアウトする、または空の値を返す場合、ランナーはその接続に `502 Bad Gateway` で応答し、理由をログに記録します。ランナーはそのログ内でコマンドの stderr を秘匿し、ヘッダー値をログに記録することはありません。`--proxy-authorization-command` を使用している場合は、ホスト上でそのコマンドを自分で実行し、ヘッダー値全体が stdout に出力されることを確認してください。代わりにランナーが起動時に `could not start the proxy-authorization listener` で終了する場合、ランナーはループバックリスナーを開けませんでした。
* **ランナーが `rejecting the malformed poll response` を含む `Poll failed` 行をログに記録する**: ランナーが受け取ったワークポーリングのレスポンスのボディが、キューが想定する JSON ではありません。原因の 1 つは、インターセプトプロキシやキャプティブポータルが独自のページで応答したことです。ランナーがプロキシ経由で接続している場合は、`api.anthropic.com` からのレスポンスを変更せずに通過させるようにプロキシを設定してください。

  ランナーはその不正なレスポンスを拒否し、`claude_code_self_hosted_runner_poll_errors_total` [メトリクス](https://code.claude.com/docs/ja/self-hosted-environments-reference.md#prometheus-metrics)の `transport` 種別としてカウントし、[セッションのライフサイクル](https://code.claude.com/docs/ja/self-hosted-environments#session-lifecycle)で説明されているポーリング失敗時のスケジュールで再試行します。ランナーは稼働中のセッションの処理を続けます。v2.1.246 より前は、ランナーはこのようなレスポンスを空のワークキューとして読み取っていたため、稼働中のセッションが終了したり、ランナーが終了したりすることがありました。
* **セッションが `no longer exists on the remote` または `couldn't find remote ref` で失敗する**: ランナーは git の `couldn't find remote ref` を、ブランチが削除されたものとして解釈します。ブランチはまだ存在している可能性があります。メッセージ内の名前そのままで git ホスト上のブランチを探し、当てはまる各原因を確認してください:

  * **ブランチが存在しない**: メッセージの求めに従ってブランチを復元してください。
  * **ブランチは存在し、自分はランナーを管理していない**: ランナーの管理者にメッセージ全文を送り、ブランチが存在することを伝えてください。
  * **ブランチは存在し、ランナーに `checkout` フックがある**: フック内の git コマンドが、フックが 0 以外で終了する前に `couldn't find remote ref` を stderr に出力することがあります。そのコマンドを見つけ、要求している ref またはフェッチ元のリモートを修正してください。ランナーは、セッションが要求したリビジョンを [`CLAUDE_RUNNER_REPO_REF`](https://code.claude.com/docs/ja/self-hosted-environments-configuration#checkout) としてフックに渡します。
  * **ブランチは存在し、ランナーに `checkout` フックがない**: ランナー自身がブランチをフェッチします。リポジトリに [`--git-host-rewrite`](#rewrite-git-urls-for-private-networks) が適用される場合は、書き換え先のホストに同じ名前のブランチがあることを確認し、ない場合はそこにブランチをプッシュしてください。
  * **ブランチは存在し、ランナーが v2.1.301 より古い**: 別の失敗がそれ自体のエラーを表示するように、[バージョンを固定する](#pin-the-version)で説明しているとおりランナーをアップグレードしてください。v2.1.301 より前は、エラー出力に `couldn't find remote ref` を含むその他の失敗も、ブランチの削除として報告されていました。

  ランナーをアップグレードするか原因を修正したら、セッションを再試行するか、新しいセッションを開始してください。これらのチェックで原因が見つからない場合は、[問題を報告](#report-an-issue)してください。

  セッションが結果をプッシュするソースでは、ブランチが削除されているとセッションが失敗します。セッションが読み取るだけの git ソースでは、ランナーはそのソースをスキップして残りのソースで続行します。スキップするとリポジトリがまったくなくなる場合、ランナーはセッションを失敗させます。v2.1.228 より前は、そのようなセッションは空のディレクトリで開始されていました。
* **セッションがリポジトリの 1 つを欠いたまま開始される**: [`checkout` フック](https://code.claude.com/docs/ja/self-hosted-environments-configuration#checkout)のないランナーでは、セッションが読み取るだけのリポジトリについて、git ホストがランナーのアクセスチェックを拒否することがあります。その場合、ランナーはそのリポジトリをスキップし、拒否内容を示す `[runner:warn] could not access context source` 行をログに記録して、残りのリポジトリでセッションを開始します。

  ランナーがスキップするのは明確な拒否の場合のみです。つまり、ホストがリポジトリが見つからないと応答した場合、git がホストの認証情報を見つけられない場合、または認証に失敗した場合です。ネットワーク障害、タイムアウト、HTTP `403` の場合は、セッションが結果をプッシュするリポジトリに対する拒否と同様に、引き続きセッションの開始が失敗します。スキップするとリポジトリがまったくなくなるセッションは、引き続きランナーによって失敗とされます。[`--use-anthropic-git-proxy`](#use-the-anthropic-git-proxy) を使用する場合、ランナーは git プロキシ自体が拒否したリポジトリのみをスキップします。

  アクセスチェックはセッションがランナー上で開始されるたびに再度実行されるため、ランナーの git ID に読み取りアクセス権が付与されると、次回の開始時にリポジトリがクローンされます。v2.1.274 より前は、これらの拒否のいずれでもセッションの開始が失敗していました。
* **セッションが `This runner couldn't read` で開始に失敗する**: ランナーが [git 認証情報](#configure-git)を使って git ホストにリポジトリを要求し、見つからないという応答を受け取りました。リポジトリが存在しないか、その認証情報ではリポジトリにアクセスできません。
  * **ランナーを管理している場合**: ランナーの git 認証情報にリポジトリへの読み取りアクセス権を付与してから、新しいセッションを開始してください。
  * **セッションを開始した場合**: リポジトリが存在しない場合は、正しいリポジトリで新しいセッションを開始してください。ランナーがリポジトリにアクセスできない場合は、ランナーの管理者にアクセス権の付与を依頼してから、新しいセッションを開始してください。
* **セッションの開始または再開に数分かかる**: 原因の 1 つは新規のクローンです。各ランナーを空のディスクで起動し、[`checkout` フック](https://code.claude.com/docs/ja/self-hosted-environments-configuration#checkout)がないフリートでは、ランナーは Claude Code を起動する前にセッションのリポジトリを新たにクローンします。空のディスク上で再開するセッションも、同じクローンを再び待つことになります。

  新規のクローンを省略するには、[事前にウォームアップしたチェックアウト](#reuse-a-pre-warmed-checkout)を用意してください。すでに用意している場合は、[ランナーがそれを使用していることを確認](#confirm-that-the-runner-uses-your-clone)してください。ランナー自身がクローンを作成し、1 つのセッションの後に終了する場合は、[`CLAUDE_RUNNER_FETCH_DEPTH`](https://code.claude.com/docs/ja/self-hosted-environments-reference#environment-variable-only-settings) をデフォルトの 50 コミットから下げて、フェッチする履歴を減らしてください。

  フックを使用している場合、フックはランナーのクローンの代わりに実行されるため、代わりにフックの処理内容を確認してください。開始にかかる時間を確認するには、`claude_code_self_hosted_runner_session_init_duration_seconds` [メトリクス](https://code.claude.com/docs/ja/self-hosted-environments-reference.md#prometheus-metrics)を監視してください。
* **ターンが 401 で失敗する**: ターンが Anthropic API からの 401 または 403 で終了すると、ランナーは Anthropic から新しい [`CLAUDE_CODE_OAUTH_TOKEN`](https://code.claude.com/docs/ja/self-hosted-environments-configuration#wrapper-scripts) を取得してセッションに渡します。失敗したターンは再試行されません。このトークンは有効期間が短く、ランナーはセッションの stdin を介してこれをローテーションします。

  取得に失敗すると、ランナーはいつ再試行するかを示す `inference_token refresh failed` 行をログに記録し、セッションが実行されている間は再試行を続けます。

  セッション開始から約 30 分後にすべての呼び出しが失敗し始める場合は、ラッパースクリプトがセッションの stdin を切断しているため、トークンのローテーションが届いていない可能性があります。[stdin とファイル記述子 3 を接続したままにする](https://code.claude.com/docs/ja/self-hosted-environments-configuration.md#keep-stdin-and-file-descriptor-3-attached)を参照してください。

  v2.1.274 より前は、ランナーは失敗した取得の再試行を数回で停止し、次の予定された取得を待っていました。失敗したターンでは取得がトリガーされなかったため、次の予定された取得まですべてのターンが 401 で失敗していました。
* **claude.ai/code でターンが `This model needs a newer version of Claude Code` で失敗する**: ランナーがセッションの開始に使用する Claude Code のバージョンが、セッションのモデルが必要とするバージョンより古いため、API が[リクエストを拒否します](https://code.claude.com/docs/ja/errors.md#claude-code-does-not-support-this-model)。[バージョンを固定する](#pin-the-version)で説明しているとおり、メッセージが求めるバージョン以降にランナーをアップグレードしてください。それまでは、セッション内で別のモデルを選択できます。
* **ドレイン中に Pod が強制終了される**: `terminationGracePeriodSeconds` を、ランナーが起動時にログに記録する値以上に引き上げてください。[シャットダウンのタイミング](#shutdown-timing)を参照してください。

ロギングが初期化されると、ランナーは `[runner:fatal]` 行を含むライフサイクルログを stdout に、デバッグ出力を stderr に、いずれも JSON ではなくプレーンテキストの行として書き込みます。上記のトラブルシューティング項目で説明したベースディレクトリの失敗は、その時点より前に stderr に出力されます。両方のストリームを `--log-file`（これにより `self-hosted-runner doctor` がそれらを tail できるようにもなります）またはプラットフォームのログ収集でキャプチャしてください。

各セッションの子プロセスは個別のデバッグログを書き込みます。失敗時には、ランナーは claude.ai/code でセッションとともにそのログの末尾を表示します。[`--remove-session-state`](https://code.claude.com/docs/ja/self-hosted-environments-reference#runner-cli-flags) 付きでランナーを起動していない限り、ランナーは失敗したセッションのログもディスク上に保持し、そのパスをランナーログに出力します。

### ランナーが終了したとき

[オンデマンドランナー](https://code.claude.com/docs/ja/self-hosted-environments-configuration.md#on-demand-runners)は、作業指示が 1 回限りのものであるため、再起動しないでください。起動直後に終了するランナーは、それ以外の理由で終了するランナーとは異なる対処が必要です。

* **正常な終了**: ランナーがセッションを終えてドレインした、リタイア時刻に達した、または停止を指示された場合です。環境が再び処理能力を持てるように、ランナーを再起動してください。これらの終了については[ランナーのライフサイクル](https://code.claude.com/docs/ja/self-hosted-environments#runner-lifecycle)で説明しています。
* **起動の失敗**: ランナーは与えられた設定またはホストでは起動できないため、起動から数秒で終了し、再起動するたびに同じように終了します。より早く再起動しても解決しません。誰かが出力を読み、原因を修正する必要があります。
* **接続の喪失**: たとえばホストがスリープしている間など、[リース](https://code.claude.com/docs/ja/self-hosted-environments#session-lifecycle)より長く Anthropic に到達できないランナーは、環境から削除されることがあります。削除されたランナーは再接続すると終了します。そのログには、`runner record gone server-side` を含む `[runner:fatal]` 行、またはより長い停止の後には [`poll auth failed`](https://code.claude.com/docs/ja/self-hosted-environments-quickstart#set-up-an-environment-and-runner) が表示されることがあります。ランナーは自動的に再登録されないため、再起動してください。

スーパーバイザーは、ランナーが終了するたびに再起動し、ランナーが起動直後に終了し続ける場合は再起動の間隔を長くし、それが続く場合は誰かに通知するように設定してください。

本番環境では、[デプロイを強化する](#harden-your-deployment)で推奨されているとおり、スーパーバイザーが新しいコンテナまたは VM 内の新しいディスク上でランナーを再起動するようにしてください。

#### 起動の失敗を見分ける

ランナーは起動できない場合、その理由を示す行を出力してから終了します。ほとんどの原因では、その行に `[runner:fatal]` が含まれます。一部の原因では、代わりに行が `error:` で始まります。これには、ランナーがフラグを解析できない場合、環境シークレットを読み取れない場合、ベースディレクトリを作成できないか書き込めない場合が含まれます。その場合、次の行で `--help` が案内されます。

ほとんどのログ行はタイムスタンプと `[self-hosted-runner]` で始まりますが、以下のサンプルでは省略しています。たとえば、Anthropic git プロキシと 1 を超える容量で起動したランナーは、次のような行を出力します:

```text theme={null}
[runner:fatal] --use-anthropic-git-proxy requires --capacity 1 (the proxy URL is per-session and linked worktrees share origin). Omit --use-anthropic-git-proxy or set --capacity 1.
```

この行は、ランナーの標準出力と標準エラー、プラットフォームのコンテナログ、または [`--log-file`](https://code.claude.com/docs/ja/self-hosted-environments-reference#runner-cli-flags) で設定したファイルで探してください。ランナーはログファイルを開く前に `error:` 行を出力するため、[トラブルシューティング](#troubleshooting)で説明しているとおり、ターミナルまたはコンテナログで探してください。

起動の失敗を読み解く際には、次の点も役立ちます:

* **行がまったくない**: ホストによって強制終了されたランナーは、どちらの行も出力しません。出力が `[runner:fatal]` 行も `error:` 行もなく終わっている場合は、たとえばメモリ制限を超えたためにホストまたはオーケストレーターがプロセスを停止したかどうかを確認してください。
* **終了コード**: ランナーは、起動のたびに繰り返されるエラー専用の終了コードを用意していません。サポートされていないフラグの組み合わせなどの設定エラーでも、ランナー自身の再試行を通じて API に到達できない状態が続くなど自然に解消する可能性のある失敗でも、同じコードで終了します。待機時間を長くするかどうかは、ランナーがどれだけ早く終了したかに基づいて判断し、理由を知るにはランナーの出力を読んでください。
* **正常に見える環境**: [`--configure-git`](#let-the-runner-configure-git) や Anthropic git プロキシの認証情報のセットアップなど、一部の起動ステップはランナーが環境に登録された後に実行されます。これらのステップのいずれかが失敗すると、プロセスが終了した後も数分間、環境がそのランナーを一覧に表示し続けることがあり、どのランナーも作業をピックアップしていないのに **Cloud environments** ページに **Healthy** と表示されることがあります。正常に見える環境でセッションがキューに入ったままになる場合は、スーパーバイザーがランナーを再起動し続けていないか確認してください。

#### 待機時間を延ばしながら再起動する

待機時間を延ばしていく方法は、スーパーバイザーによって異なります。

* **Kubernetes**: このページの [Deployment](#kubernetes) は変更不要です。コンテナが終了した後、kubelet はデフォルトでコンテナを再起動する前に待機し、その待機時間は再起動のたびに上限まで延びます。コンテナが終了せずにしばらく実行されると、待機時間は最初からやり直しになります。

  kubelet は、コンテナの実行時間が短かった場合は正常終了の後にも同じ待機を適用します。そのため、頻繁にドレインするランナーも `CrashLoopBackOff` ステータスを表示することがあるので、ランナーが起動できないと結論づける前に出力を読んでください。以下のコマンドは、Deployment の 1 つの Pod から前回の実行の出力を読み取ります:

  ```bash theme={null}
  kubectl logs --previous -n claude-runners deploy/claude-runner
  ```

  前回の実行が起動の失敗であった場合、`[runner:fatal]` または `error:` 行は出力の最後のほうの行にあります。別の Pod の前回の実行を読むには、`deploy/claude-runner` の代わりにその Pod の名前を指定してください。
* **Docker と Docker Compose**: このページの [Compose レシピ](#docker-compose)は変更不要です。`restart: always` を指定すると、Docker は終了し続けるコンテナの再起動のたびに、上限まで待機時間を長くします。以下のコマンドの `<container>` をコンテナ名に置き換えてください。このコマンドは、Docker がコンテナを再起動した回数を読み取ります:

  ```bash theme={null}
  docker inspect --format '{{.RestartCount}}' <container>
  ```

  コマンドは数値を出力します。数値が増え続けている場合は、Docker がランナーを再起動し続けていることを意味します。
* **systemd ユニット**: デフォルトでは、systemd は再起動のたびに同じ `RestartSec` だけ待機し、それを延ばさないため、`Restart=always` のユニットは、起動できないランナーを毎回同じ間隔で再起動します。起動がユニットの起動レート制限（デフォルトでは 10 秒間に 5 回の起動）に達するほど速く行われると、systemd はユニットの再起動を停止します。ユニットは誰かが再び起動するまで停止したままになります。systemd がそれを許可するのは、レート制限の間隔が経過した後、または `systemctl reset-failed` の後です。`RestartSec` はすべての再起動に適用されるため、値を長くすると正常終了後の再起動も遅れます。この 2 つのバランスを取る値を選び、ユニットの再起動回数に対してアラートを設定してください。
* **シェルループまたは独自のスーパーバイザー**: 同じルールを自分で適用してください。5 秒の待機から始めます。1 分以内に終了した実行の後は、次の再起動までの待機時間を最大 5 分まで 2 倍にします。1 分以上続いた実行の後は、5 秒に戻します。

#### ランナーが終了し続ける理由を確認する

ランナーが起動直後に終了することを何度も続けて繰り返した場合は、再び再起動する前にいったん止めて、次の点を確認してください。

* **最後の `[runner:fatal]` または `error:` 行**: ランナーが停止した理由が示されています。一般的な原因は[トラブルシューティング](#troubleshooting)に記載しています。
* **フラグの組み合わせ**: [Anthropic git プロキシ](#use-the-anthropic-git-proxy)には `--capacity 1` が必要です。このページのレシピではより大きな容量を使用しているため、いずれかのレシピにプロキシを追加する場合は容量を下げてください。
* **サービスの環境から到達できるもの**: ランナーを手動で起動すると成功するのに、スーパーバイザーの下では失敗する場合は、ユーザー、ホームディレクトリ、`PATH`、メモリ制限を比較してください。`--configure-git` と Anthropic git プロキシには、`PATH` 上の git と書き込み可能な `~/.gitconfig` が必要です。
* **環境シークレット**: シークレットを取り消したか、入力を誤った場合、ランナーは `RegisterRunner auth failed` を含む行を出力します。
* **環境の Activity タブ**: 環境を開き、**Activity** を選択します。そこに新しいランナーが次々と表示され、どれも作業をピックアップしていない場合は、スーパーバイザーがランナーを再起動しています。

ランナーホストでガイド付きの診断を行うには、[doctor サブコマンド](#troubleshooting)を実行してください。

### セッションはピックアップされたが、Claude が最初のメッセージに応答しない

ランナーがセッションをピックアップしたのに Claude が最初のメッセージに応答せず、ランナーがプロキシ経由で `api.anthropic.com` に到達している場合は、プロキシが原因である可能性があります。Anthropic は、開いたままになる 1 つのストリーミングレスポンスを通じてセッションにメッセージを送信します。プロキシがこのレスポンスをバッファリングしたり、何も渡さないうちに終了させたりすると、最初のメッセージは届きません。セッションからの他のリクエストは引き続き成功します。

修正するには、プロキシがこのリクエストを処理する方法を変更してください:

```text theme={null}
GET https://api.anthropic.com/v1/code/sessions/<session-id>/worker/events/stream
```

* **レスポンスをバッファリングしない**: 到着したとおりに通過させてください。コンテンツタイプは `text/event-stream` です。
* **レスポンスを開いたままにする**: レスポンスは最長 1 時間開いたままになることがあります。プロキシにアイドルタイムアウトがある場合は、15 秒よりも十分に長くしてください。Anthropic はデフォルトで少なくともその頻度でキープアライブを送信するためです。

その後、新しいセッションを開始し、Claude が応答することを確認してください。ランナーのタイムアウトを引き上げても解決しません。ランナーがセッションを停止するまでの待ち時間が長くなるだけです。

#### ランナーのログで原因を確認する

以下の手順は、デフォルトの `--log-level info` で動作する Claude Code v2.1.287 以降のランナーを対象としています。それより古いランナーでは、これらの行はより遅れて記録されるか、まったく記録されません。

1. [`--startup-timeout-min`](https://code.claude.com/docs/ja/self-hosted-environments-reference#runner-cli-flags)（デフォルトは 15 分）が経過するのを待ちます。するとランナーはセッションを停止し、`no child output for` を含み `— releasing` で終わる行をログに記録します。
2. ランナーのログで `SDKStartup: SSE` を検索します。これらの行は、手順 1 の行から数行後にある `finished: interrupted` 行に続きます。ほとんどの行にはタイムスタンプがないため、ログコレクターでは別の場所に表示されることがあります。
3. 次の表で該当する行を見つけます:

| ログ行に含まれる内容 | 対処方法 |
| :- | :- |
| `SSE connect failed (no response in 30s)` または `SSE liveness timeout` | プロキシがリクエストを転送し、レスポンスのヘッダーとデータを到着したとおりに通過させ、接続を切断していないことを確認してください |
| `SSE connect failed (HTTP` とステータスコード | プロキシ自身のログを確認してください。プロキシ自体がリクエストに応答していた場合は、リクエストがプロキシを通過するようにしてください。 |
| `SSE connect failed (` とその他のテキスト | 括弧内のテキストがエラーです。プロキシ自身のログで同じ接続を探してください。 |
| `SSE stream ended by server` が何度も繰り返される | 長時間続くレスポンスに対するプロキシの時間制限を確認してください。このような行が 1 つだけであれば正常です。 |
| `SSE reconnected after` | その後にある他のいずれかの行を探してください。この行は、何かがセッションに届いたことを意味するものではありません。 |

ログにこれらの行がいずれもない場合、またはプロキシのログに問題が見当たらない場合は、[問題を報告](#report-an-issue)してください。

#### セッションの再試行を止める

セッションはメッセージを保留したままにし、セッションの所有者に対応できるランナーがセッションを再びピックアップします。プロキシを変更するまで、セッションは毎回同じように待機します。これを止めるには、claude.ai/code でセッションをアーカイブしてください。

## 次のステップ

* [セッションをカスタマイズする](https://code.claude.com/docs/ja/self-hosted-environments-configuration.md)：ラッパースクリプト、ライフサイクルフック、オンデマンドランナー、MCP サーバー、権限
* [エンドツーエンドをテストする](https://code.claude.com/docs/ja/self-hosted-environments-testing.md)：本番環境に昇格させる前に新しいランナーイメージを検証する
* [リファレンス](https://code.claude.com/docs/ja/self-hosted-environments-reference.md)：すべての CLI フラグ、環境変数、メトリクス
