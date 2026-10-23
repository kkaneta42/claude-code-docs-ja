> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# セルフホスト環境リファレンス

> セルフホストランナーとオーケストレーターの完全なリファレンス：CLI フラグ、環境変数、Prometheus メトリクス。

> [!NOTE]
>
> セルフホスト環境は Team および Enterprise プランでパブリックベータ版です。[Owner](/docs/ja/cloud-environments.md#organization-shared-environments) が [**Cloud environments** 管理ページ](https://claude.ai/admin-settings/cloud-environments) で **Allow self-hosted environments** をオンにすることで有効になります。このページはフラグとメトリクスのリファレンスです。セットアップについては [クイックスタート](/docs/ja/self-hosted-environments-quickstart.md) を、フリート構成については [本番環境へのデプロイ](/docs/ja/self-hosted-environments-deploy.md) をご覧ください。

このページは、[セルフホスト環境](/docs/ja/self-hosted-environments) で実行する 2 つのプロセスのリファレンスです。ランナーはホスト上で Claude Code [クラウドセッション](/docs/ja/claude-code-on-the-web.md) を実行し、オプションのオートスケーリングオーケストレーターはセッションがキューに入ると同時にランナーを起動します。それぞれ独自のフラグテーブルを持っています。どちらも Linux または macOS ホスト上で実行され、`/workspace` や `~/.claude` などのデフォルトを想定しています。インストール済みバージョンの権限あるリストについては、`claude self-hosted-runner --help` を実行してください。

メトリクスシリーズと一部の API フィールドは、これらのページが環境と呼ぶものに対して `pool` を使用しています。どちらの用語も同じものを指しています。環境 ID は `pool_id` フィールドで、形式は `ccpool_...` です。これらのページが `pool` 識別子を示す場所では、環境を指しています。CLI フラグと環境変数では `environment` と表記されます。例えば `--environment-secret-file` のように。非推奨の `pool` 表記はまだ機能します。[`--environment-secret-file` 行](#runner-cli-flags) で説明されているとおりです。

## ランナーの CLI フラグ

ほとんどのフラグには対応する環境変数があります。両方が設定されている場合は、フラグが優先されます。期間を指定するフラグは CLI では分または秒で指定しますが、対応する環境変数は常にミリ秒単位で、これは `_MS` サフィックスで示されます。また、「デフォルト」列にはフラグの単位で値を示しています。たとえば、`--exit-if-unused-min 10` は `SELF_HOSTED_RUNNER_IDLE_SHUTDOWN_MS=600000` と同等であり、`SELF_HOSTED_RUNNER_STARTUP_TIMEOUT_MS: "15"` のような Helm の値は、デフォルトの 15 分ではなく 15 ミリ秒を意味します。

| フラグ | 環境変数 | デフォルト | 説明 |
| :- | :- | :- | :- |
| `--api-url <url>` | なし | `https://api.anthropic.com` | API のベース URL。テスト目的の場合にのみ上書きしてください。 |
| `--base-dir <path>` | `SELF_HOSTED_RUNNER_BASE_DIR` | `/workspace`（Windows ではなし） | リポジトリのチェックアウトとセッションごとの作業ディレクトリを置くディレクトリ。ランナーには、このパスまたはその親ディレクトリへの書き込みアクセスが必要です。ランナーは起動時にこのディレクトリを作成し、作成または書き込みができない場合は `cannot create or write to base directory` を出力して終了します。v2.1.225 より前は、最初のセッションの開始時にディレクトリが作成されていたため、使用できないパスでは起動ではなくセッションが失敗していました。サポート対象のランナーホストではない Windows にはデフォルトがなく、フラグを渡すか変数を設定しない限り、ランナーは起動時に終了します。環境内のすべてのランナーで同じ値を使用してください。[ランナー間でベースディレクトリと容量を同一に保つ](/docs/ja/self-hosted-environments-deploy.md#keep-the-base-directory-and-capacity-identical-across-runners)を参照してください。 |
| `--capacity <n>` | なし | `1` | このランナーが処理する同時セッションの最大数。すべてのセッションは、ロックされた同一の[オーナー](/docs/ja/self-hosted-environments#key-concepts)に属します。環境内のすべてのランナーで同じ値を使用してください。[ランナー間でベースディレクトリと容量を同一に保つ](/docs/ja/self-hosted-environments-deploy.md#keep-the-base-directory-and-capacity-identical-across-runners)を参照してください。 |
| `--client-label <label>` | `SELF_HOSTED_RUNNER_CLIENT_LABEL` | ホストのホスト名 | ランナーが登録時に送信するラベル。ランナーはこれを [`claude_code_self_hosted_runner_info`](#prometheus-metrics) の `client_label` ラベルとしても報告します。Claude Code v2.1.248 以降が必要です。 |
| `--configure-git` | `SELF_HOSTED_RUNNER_CONFIGURE_GIT=1` | オフ | 起動時に、グローバルな git の ID を書き込み、Anthropic のコミット署名を有効にし、git の push negotiation をオンにし、`Co-authored-by:` トレーラーを追加するコミットフックをインストールします。push negotiation には Claude Code v2.1.257 以降が必要です。[git を設定する](/docs/ja/self-hosted-environments-deploy.md#configure-git)を参照してください。 |
| `--confine-repo-settings <mode>` | `SELF_HOSTED_RUNNER_CONFINE_REPO_SETTINGS` | `warn` | リポジトリにコミットされた設定が、そのセッション自身のワークスペース外への書き込みまたは読み取りアクセスを付与しようとする場合、環境変数を設定しようとする場合、または `sandbox.enabled: false` や `disableAllHooks` などによってオペレーターのサンドボックスやフックの方針を上書きしようとする場合に、そのセッションを警告するガードのモードを設定します。デフォルトの `warn` は違反をログに記録したうえでセッションを開始し、`enforce` はセッションを拒否し、`off` はスキャンを無効にします。[デプロイを強化する](/docs/ja/self-hosted-environments-deploy.md#harden-your-deployment)を参照してください。 |
| `--debug-token-dir <path>` | `SELF_HOSTED_RUNNER_DEBUG_TOKEN_DIR` | 未設定 | 検査用にライブトークンをディスクに書き込みます。デバッグ専用です。本番環境では使用しないでください。 |
| `--defer-shutdown-max-min <n>` | `SELF_HOSTED_RUNNER_DEFER_SHUTDOWN_MAX_MS` | `0` | 最初の `SIGTERM` または `SIGINT` を受信したとき、すでにアタッチされているセッションをドレインせずに引き続き処理し、N 分後にまだアタッチされているものを解放して終了します。これを設定する前に、ホストの停止タイムアウトを引き上げてください。[最初のシグナル以降にドレインを延期する](/docs/ja/self-hosted-environments-deploy.md#defer-the-drain-past-the-first-signal)を参照してください。`0` で無効になります。Claude Code v2.1.238 以降が必要です。 |
| `--drain-grace-sec <n>` | `SELF_HOSTED_RUNNER_DRAIN_GRACE_MS` | `0` | ランナーがシャットダウンシグナルを受信するか退役時刻に達するまでの間、アクティブなセッションが終了した後にランナーがいつ終了するかを制御します。`0` の場合は追加のポーリングを行わずに即座に終了し、正の値の場合は、終了する前にその秒数の間ランナーを稼働させ続け、ロックされたオーナーのキューを再ポーリングします。ただしその代償として、[強化のセクション](/docs/ja/self-hosted-environments-deploy.md#harden-your-deployment)で説明しているセッションごとのコンテナ分離が失われます。[`--defer-shutdown-max-min`](/docs/ja/self-hosted-environments-deploy#defer-the-drain-past-the-first-signal) で延期した最初のシグナルの後は、ここでの設定にかかわらず、ランナーはセッションを 1 つも保持しなくなった時点ですぐに終了します。 |
| `--drain-marker-file <path>` | `SELF_HOSTED_RUNNER_DRAIN_MARKER_FILE` | 未設定 | ホストが `SIGTERM` を送信する前に、グレースフルドレインを通知するために書き込むマーカーファイル。ドレインの開始時にこのファイルが存在する場合、ランナーは自身の終了を、単なるシャットダウンシグナルではなくホストのドレインとして Anthropic に報告します。`--drain-wait-sec` による待機を含め、ドレイン自体はこのフラグがない場合と同じように実行されます。セッションから書き込めないローカルファイルシステム上のパスを指定してください。Claude Code v2.1.271 以降が必要です。 |
| `--drain-wait-sec <n>` | `SELF_HOSTED_RUNNER_DRAIN_WAIT_MS` | `0` | ドレインが開始されると（[`--defer-shutdown-max-min`](/docs/ja/self-hosted-environments-deploy#defer-the-drain-past-the-first-signal) を設定していない限り、`SIGTERM` の受信時）、子プロセスを終了する前に、各セッションの実行中のターンとバックグラウンドタスクが完了するまで最大 N 秒待機します。この待機中、ランナーは完了したばかりのバックグラウンドタスクを、その結果を読み取るフォローアップのターンが開始されるまで、最大 [`SELF_HOSTED_RUNNER_BG_RESULT_GRACE_MS`](#environment-variable-only-settings) の期間、まだ実行中としてカウントします。[停止タイムアウトも引き上げてください](/docs/ja/self-hosted-environments-deploy.md#let-running-turns-finish-before-a-restart)。 |
| `--environment-secret-file <path>` | `SELF_HOSTED_RUNNER_ENVIRONMENT_SECRET` | 必須 | 環境シークレットを含むファイルへのパス、または[オーケストレーター](/docs/ja/self-hosted-environments-configuration.md#on-demand-runners)によって起動されたランナーの場合は、使い捨てのワークオーダー JWT を含むファイルへのパス。`SELF_HOSTED_RUNNER_ENVIRONMENT_SECRET` は、ファイルパスではなくシークレットの値そのものを保持します。古い `--pool-secret-file` フラグと `SELF_HOSTED_RUNNER_POOL_SECRET` 変数も引き続き機能し、stderr に非推奨の通知を出力します。2.1.216 より古いプレビュープログラムのランナービルドは、これらの古い名前のみを認識します。 |
| `--exec-path <path>` | `SELF_HOSTED_RUNNER_EXEC_PATH` | 自身のバイナリ | 各セッションで起動するバイナリまたはラッパースクリプト。[ラッパースクリプト](/docs/ja/self-hosted-environments-configuration.md#wrapper-scripts)を参照してください。 |
| `--exit-if-unused-min <n>` | `SELF_HOSTED_RUNNER_IDLE_SHUTDOWN_MS` | `0` | オートスケーラーのスケールダウン用に、作業が一度も割り当てられないまま N 分間ポーリングした後に終了します。`0` で無効になります。 |
| `--git-host-rewrite <from>=<to>` | なし | 未設定 | スプリットホライズン DNS 用に、クローンの前にソース URL の `https://<from>/...` を `https://<to>/...` に書き換えます。繰り返し指定可能です。フラグのみで指定できます。 |
| `--git-ssh-rewrite <host>` | なし | 未設定 | SSH のみに対応した git ホスト用に、クローンの前にソース URL の `https://<host>/...` を `git@<host>:...` に書き換えます。繰り返し指定可能です。フラグのみで指定できます。 |
| `--health-port <port>` | `SELF_HOSTED_RUNNER_HEALTH_PORT` | `8080` | `/healthz` と `/metrics` のリスナーのポート。`0` に設定すると無効になります。 |
| `--hooks-dir <path>` | `SELF_HOSTED_RUNNER_HOOKS_DIR` | 未設定 | ライフサイクルフックスクリプトのディレクトリ。[ライフサイクルフック](/docs/ja/self-hosted-environments-configuration.md#lifecycle-hooks)を参照してください。 |
| `--host-config-snapshot <mode>` | `SELF_HOSTED_RUNNER_HOST_CONFIG_SNAPSHOT` | `disk` | ランナーが各セッションの初期設定に使用する[ホスト設定ディレクトリ](#environment-variable-only-settings)の起動時スナップショットを、どこに保持するかを指定します。`disk` はスナップショットを `--base-dir` 配下のランナー所有のディレクトリにコピーし、各セッションの開始時に、すべてのファイルをメモリ内のダイジェストと照合して検証します。コピー内のファイルが変更されていた場合、そのセッションは失敗し、ランナーは再起動されるまでセッションを拒否します。`memory` はスナップショット全体をヒープ上に保持し、上限は 64 MiB です。上限を超えると、セッションはホスト設定なしで開始され、その旨を示す通知が表示されます。ランナーがディスクスナップショットを書き込めない場合は、失敗をログに記録し、その実行では `memory` を使用します。Claude Code v2.1.271 以降が必要です。 |
| `--kill-session-after-min <n>` | `SELF_HOSTED_RUNNER_MAX_LIFETIME_MS` | `0` | スタックしたセッションに対する安全上の上限として、セッションを実時間で N 分に制限します。v2.1.260 以降では、ランナーは上限に達したセッションを解放し、そのユーザーの次のメッセージで再開できるようにします。[`SELF_HOSTED_RUNNER_MAX_LIFETIME_GRACE_MS`](#environment-variable-only-settings) の猶予期間が終了した時点でセッションがまだランナー上にある場合にのみ、そのセッションを終了させます。v2.1.260 より前は、上限に達した時点でランナーがセッションを終了させていました。詳細と値の選び方については、[アイドルとしてカウントされないセッションがある](/docs/ja/self-hosted-environments-deploy.md#some-sessions-don’t-count-as-idle)を参照してください。`0` で無効になります。 |
| `--lock-to-account <id>` | `SELF_HOSTED_RUNNER_LOCK_TO_ACCOUNT` | 未設定 | 最初のセッションでロックする代わりに、起動時にランナーを特定のアカウントに事前ロックします。環境の組織内のメールアドレスまたは `user_...` ID を受け付けます。事前ロックされたランナーは、アカウントを持たない Claude Tag チャネルのセッションを取得することはありません。 |
| `--log-file <path>` | `SELF_HOSTED_RUNNER_LOG_FILE` | 未設定 | stdout と stderr に加えて、ランナーのログをファイルにも出力します。ファイルは `0600` の権限で作成されます。`self-hosted-runner doctor` がローカルでログを tail するために必要です。 |
| `--log-level <level>` | なし | `info` | `info` または `debug` |
| `--post-session-hook-timeout-sec <n>` | `SELF_HOSTED_RUNNER_POST_SESSION_HOOK_TIMEOUT_MS` | `60` | ランナーのシャットダウンを含む、すべてのセッション終了時の [`post-session` フック](/docs/ja/self-hosted-environments-configuration#post-session)に割り当てる時間 |
| `--proxy-authorization-command <command>` | `SELF_HOSTED_RUNNER_PROXY_AUTHORIZATION_COMMAND` | 未設定 | エグレスプロキシへの接続ごとにランナーが実行するシェルコマンド。前後の空白を除去した stdout を `Proxy-Authorization` ヘッダーの値として使用します。`HTTPS_PROXY` または `HTTP_PROXY` が必要で、`--proxy-authorization-file` と組み合わせることはできません。[エグレスプロキシに認証する](/docs/ja/self-hosted-environments-deploy.md#authenticate-to-an-egress-proxy)を参照してください。Claude Code v2.1.238 以降が必要です。 |
| `--proxy-authorization-file <path>` | `SELF_HOSTED_RUNNER_PROXY_AUTHORIZATION_FILE` | 未設定 | エグレスプロキシへの接続ごとにランナーが読み取るファイル。前後の空白を除去した内容を `Proxy-Authorization` ヘッダーの値として使用します。別のプロセスがその場でローテーションするトークンには、このフラグを使用してください。`--proxy-authorization-command` と同じ要件があり、それと組み合わせることはできません。[エグレスプロキシに認証する](/docs/ja/self-hosted-environments-deploy.md#authenticate-to-an-egress-proxy)を参照してください。Claude Code v2.1.238 以降が必要です。 |
| `--push-outcome-on-release` | `SELF_HOSTED_RUNNER_PUSH_OUTCOME_ON_RELEASE` | オフ | ドレインやアイドル解放など、ランナーが開始したセッション終了時に、ワークスペースを削除する前に追跡中の成果ブランチを `origin` にプッシュし、進行中のコミットが再起動後も失われないようにします。ベストエフォートで行われます。シャットダウンの時間枠に 30 秒が追加され、プッシュされたブランチから再開するには git 2.29 以降が必要です。有効にする前に、プッシュアクセスを `claude/*` の ref に制限してください。[再開されたセッションではプッシュされていない作業が失われる](/docs/ja/self-hosted-environments-deploy.md#additional-limitations)を参照してください。`checkout` ライフサイクルフックでチェックアウトされたリポジトリはプッシュされません。それらについては、代わりに [`post-session` フック](/docs/ja/self-hosted-environments-configuration#post-session)からスナップショットを取得してください。 |
| `--release-idle-session-min <n>` | `SELF_HOSTED_RUNNER_SESSION_IDLE_MS` | `0` | ターンが終了するか、セッションがユーザーのアクションを待つ状態になった後、N 分間操作がなければセッションスロットを解放します。完了しないバックグラウンドタスクを保持しているセッションや、実行中のツール呼び出しの内部から承認を要求しているセッションなど、まだターンの途中にあるセッションはアイドルとしてカウントされません。強制的な歯止めとして `--kill-session-after-min` と組み合わせてください。セッションのバックグラウンドタスクが完了した後、ランナーは、その結果を読み取るフォローアップのターンが開始されるまで、最大 [`SELF_HOSTED_RUNNER_BG_RESULT_GRACE_MS`](#environment-variable-only-settings) の期間、そのセッションをビジーとみなします。ランナーがシャットダウンシグナルを受信するか退役時刻に達するまでの間は、解放によってランナーのアクティブなセッションがなくなると、通常のドレインと同じ終了パスが開始され、`--drain-grace-sec` によって制御されます。[`--defer-shutdown-max-min`](/docs/ja/self-hosted-environments-deploy#defer-the-drain-past-the-first-signal) で延期した最初のシグナルの後は、解放によってセッションを 1 つも保持しなくなった時点で、ランナーはすぐに終了します。`0` で無効になります。 |
| `--remove-session-state [bool]` | `SELF_HOSTED_RUNNER_REMOVE_SESSION_STATE` | オフ | このランナー上でセッションが終了したとき、結果にかかわらず、`<base-dir>/_sessions/` 配下のセッションごとのディレクトリを削除します。これらのディレクトリに何が保存され、残った場合に誰が読み取れるかについては、[事前ウォームアップされたチェックアウトを再利用する](/docs/ja/self-hosted-environments-deploy.md#reuse-a-pre-warmed-checkout)で説明しています。削除はベストエフォートで行われます。クリーンアップが実行される前にランナーが強制終了されたり、ドレインの期限に達したりした場合、セッションごとのディレクトリはそのまま残ります。このフラグをオンにすると、失敗または中断されたセッションのデバッグログはディスクに保持されません。Claude Code v2.1.268 以降が必要です。 |
| `--retire-at <epoch-seconds>` | `SELF_HOSTED_RUNNER_RETIRE_AT` | 未設定 | 既知の時刻にランナーを強制終了するインフラ向けに、秒単位の絶対 Unix タイムスタンプでランナーを退役させます。解放の手順とマージンの見積もり方については、[ランナーのライフサイクル](/docs/ja/self-hosted-environments#runner-lifecycle)で説明しています。2001 年より前または 5138 年より後の値は、フラグでは拒否され、環境変数では無視されます。 |
| `--server-auto-mode-lists <mode>` | `SELF_HOSTED_RUNNER_SERVER_AUTO_MODE_LISTS` | `no-allow` | コントロールプレーンがセッションとともに送信する [auto モード](/docs/ja/permission-modes.md#eliminate-prompts-with-auto-mode)の分類器ルールリストのうち、どれをそのセッションに届けるかを指定します。値は `all`、`no-allow`、`none` のいずれかです。各値で何が適用されるかについては、[auto モードのルールリスト](#auto-mode-rule-lists)を参照してください。無効な値を指定すると、ランナーは起動時に停止します。Claude Code v2.1.295 以降が必要です。 |
| `--session-stop-grace-sec <n>` | `SELF_HOSTED_RUNNER_SESSION_STOP_GRACE_MS` | `5` | セッションの終了後、強制終了する前に Claude プロセスが正常に終了するのを待つ時間。子プロセス自身の `SessionEnd` フックにより多くの時間が必要な場合は、値を引き上げてください。 |
| `--startup-timeout-min <n>` | `SELF_HOSTED_RUNNER_STARTUP_TIMEOUT_MS` | `15` | 子プロセスが N 分以内に[アクティビティチャネル](/docs/ja/self-hosted-environments-configuration.md#keep-stdin-and-file-descriptor-3-attached)で初期化完了を通知しなかった場合、セッションスロットを解放します。N 分はクローン後の起動時点から計測が始まり、子プロセスが初期化するか状態を報告する前に `user` または `assistant` メッセージを出力するたびに、計測がやり直しになります。v2.1.299 より前は、このタイムアウトはセッションで最初にそのようなメッセージが出力された時点で適用されなくなっていました。初期化シグナル後の解放については、`--release-idle-session-min` を参照してください。`0` で無効になります。 |
| `--trust-workspace [bool]` | `SELF_HOSTED_RUNNER_TRUST_WORKSPACE` | オン | 各セッションのリポジトリパスに対する永続的な信頼を事前に設定し、リポジトリにコミットされた `permissions.allow` と `additionalDirectories` が尊重されるようにします。`false` に設定すると、リポジトリにコミットされた権限の付与を破棄し、代わりにホスト設定の `settings.json` で許可ルールを構成します。リポジトリにコミットされた `sandbox.*` 設定はどちらの場合も適用されるため、[リポジトリ設定ガード](/docs/ja/self-hosted-environments-deploy.md#harden-your-deployment)はこのフラグに関係なくそれらをスキャンします。 |
| `--use-anthropic-git-proxy` | `CLAUDE_RUNNER_USE_GIT_PROXY=1` | オフ | 顧客が管理する git 認証の代わりに、[Anthropic git プロキシ](/docs/ja/self-hosted-environments-deploy.md#use-the-anthropic-git-proxy)経由で github.com 上のリポジトリをクローンします。`--capacity 1` と git 2.32 以降が必要で、これらを満たさない場合、ランナーは起動を拒否します。書き換えフラグよりも優先されます。 |

ほとんどの期間フラグには最大値があり、各タイムアウトがランタイムの 32 ビットタイマーの上限である約 24.85 日に収まるように選ばれています。`--*-min` フラグの上限は 10080 分（7 日）、`--drain-grace-sec` は 604800 秒（同じく 7 日）、`--drain-wait-sec` は 86400 秒（24 時間）です。`--session-stop-grace-sec` と `--post-session-hook-timeout-sec` には上限がありません。上限を超えた場合の動作は、指定方法によって異なります。

* **フラグ**：エラーで起動に失敗します。
* **環境変数**：ランナーは値を拒否せず、タイマーの上限に切り詰めます。

### auto モードのルールリスト

`--server-auto-mode-lists` を使用すると、ランナーの外部から届く [auto モード](/docs/ja/permission-modes.md#eliminate-prompts-with-auto-mode)の分類器ルールのうち、どれをランナー上のセッションに届けるかを決められます。Anthropic のコントロールプレーンは、セッションとともにルールリストを送信し、それらを適用するようランナーに要求できます。一部のエントリは、組織の管理者が作成したルールである場合があります。リストは `environment`、`soft_deny`、`allow` の 3 つです。

* **`environment`**：エントリによって、分類器が許可する範囲を広げることも狭めることもできます。
* **`soft_deny`**：ユーザーが明示的に要求した場合や `allow` の例外が適用される場合を除き、エントリはアクションをブロックします。
* **`allow`**：`soft_deny` のエントリに対する例外です。

フラグの値によって、ランナーが適用するリストが決まります。

* **`no-allow`**：デフォルトです。`environment` と `soft_deny` を適用し、`allow` は適用しません。`environment` のエントリによって分類器が許可する範囲が広がる可能性は残るため、デフォルトではあらゆる緩和を排除できるわけではありません。
* **`all`**：3 つのリストすべてを適用します。
* **`none`**：いずれのリストも適用しません。これらのリストによるあらゆる緩和を排除するには、`none` を選択してください。この場合、`soft_deny` による制限も適用されなくなります。

コントロールプレーンがランナーにリストの適用を要求するようにするランナー設定はありません。要求がない場合、設定にかかわらず、セッションはリストを受け取りません。どちらになったかを確認するには、`--log-level debug` を指定してランナーを起動します。すると、ランナーはセッションごとに、`the server asked this runner to apply` を含む行、または `the server did not ask this runner to apply the auto mode lists it sends` を含む行をログに記録します。

## オーケストレーター CLI フラグ

`self-hosted-runner orchestrator` サブコマンド（[オンデマンドランナー](/docs/ja/self-hosted-environments-configuration.md#on-demand-runners) を生成）は、`--api-url`、`--environment-secret-file`、`--hooks-dir`、`--health-port`、`--log-level` をランナーと同じデフォルトで受け入れます。ランナーのフラグに 1 つある場合は同じ環境変数を使用します。ただし、`--hooks-dir` は必須で、`spawn-runner` フックを含む必要があります。また、独自のフラグも取ります。

| フラグ | デフォルト | 説明 |
| :- | :- | :- |
| `--hook-concurrency <n>` | `4` | 並列で実行される最大 `spawn-runner` フック数。また、ポーリングごとにクレームされるスポーン要求の数もキャップします。 |
| `--hook-timeout <sec>` | `60` | この多くの秒後にフックのプロセスツリーを終了します。タイムアウトとその 5 秒のキルグレースは `--expected-spawn-seconds` より下にある必要があります。オーケストレーターはスタートアップでこれを強制します。 |
| `--expected-spawn-seconds <sec>` | `120` | オーケストレーターがスポーン要求を受信してからランナーが登録されるまでの予想 p99 時間（プラットフォーム上でのキャパシティ待ちを含む）。サーバーは 10 ～ 3600 の範囲を強制します。すべてのポーリングでサーバー側リースとして送信されます。ランナーが経過前に登録されない場合、セッションは新しいオーダー ID で再提供されます。すべてのレプリカはこの値を共有する必要があります。 |
| `--min-idle <n>` | `0` | スタンバイランナーを積極的に生成することで、少なくとも N 個のアイドルセッションスロットを無料で保ちます。`0` はプレウォーミングを無効にします。ランナーの `--exit-if-unused-min` とペアにして、余分なスタンバイランナーが自分自身を再利用するようにします。 |
| `--debug-dir <path>` | 未設定 | 各スポーン要求のワークオーダーとフック stderr をディスクに書き込みます。デバッグのみ。本番環境では設定しないでください。 |

### SCM コネクタフラグ

SCM コネクタは利用できないため、このセクションのフラグは未設定のままにしてください。`--scm-connector-host` を設定した場合、接続は開かず、オーケストレーターは再試行を続けます。ランナーはセッションキューとして開始されます。

コネクタは、オーケストレーターから Anthropic のコントロールプレーンへのスタンディング WebSocket 接続です。リポジトリピッカーやブランチまたは ref リゾルバーなどのホスト済みプリセッションフローが、ネットワーク内からのみルーティング可能な GitHub Enterprise Server ホストに到達できるようにするために設計されています。GitHub Enterprise Server ページの [ネットワーク要件](/docs/ja/github-enterprise-server.md#network-requirements) を参照して、これらのフローが必要とするものを確認してください。

| フラグ | デフォルト | 説明 |
| :- | :- | :- |
| `--scm-connector-host <host[:port]>` | 未設定 | リクエストを転送する GitHub Enterprise Server ホスト名。ポートはデフォルトで `443` です。 |
| `--scm-connector-id <n>` | `--scm-connector-host` で必須 | 組織の GitHub Enterprise Server 接続の数値 ID。 |
| `--scm-connector-provider <slug>` | `ghe` | プロバイダーを識別するパスセグメント。`^[a-z0-9-]{1,32}$` と一致します。 |
| `--scm-connector-ca-file <path>` | 未設定 | GitHub Enterprise Server ホストへの TLS 接続用の追加 CA バンドル（PEM 形式）。 |
| `--scm-connector-host-rewrite <from>=<to_host:to_port>` | 未設定 | エンドツーエンドテスト専用：ホストヘッダーと TLS SNI を `--scm-connector-host` として保ちながら TCP 接続をリダイレクトします。 |

各接続試行時に、オーケストレーターは既存の環境シークレットを送信し、指数バックオフで自動的に再試行します。30 秒とジッターでキャップされます。

## 環境変数のみの設定

これらのランナー設定は環境からのみ読み取られ、ほとんどのデプロイメントがデフォルトのままにしておく動作をカバーしています。

| 環境変数 | デフォルト | 説明 |
| :- | :- | :- |
| `SELF_HOSTED_RUNNER_BG_RESULT_GRACE_MS` | `30000` | バックグラウンドタスクが終了した後、その結果を読み取る後続ターンが開始されていない間、ランナーがセッションをビジーと見なす時間。[`--drain-wait-sec` および `--release-idle-session-min` 行](#runner-cli-flags) はドレインおよびアイドルリリース時にホールドが適用される場所を説明し、[ランナーライフサイクル](/docs/ja/self-hosted-environments#runner-lifecycle) は `--retire-at` リタイアメント時に適用される場所を説明しています。`0` または使用不可能な値はデフォルトにフォールバックするため、ホールドをオフにすることはできません。Claude Code v2.1.228 以降が必要です。 |
| `SELF_HOSTED_RUNNER_HOST_CONFIG_DIR` | `~/.claude` | ランナーのスタートアップスナップショットにキャプチャされ、各セッションの `CLAUDE_CONFIG_DIR` にシードされるディレクトリ。ディスク上の変更はランナーの再起動後に適用されます。変数を設定すると、ランナーが [MCP シーディング](/docs/ja/self-hosted-environments-configuration.md#mcp-servers) 用に `.claude.json` を読み取る場所も移動します。設定すると、独自のデフォルトを含めて、その検索を再配置します。空のディレクトリを指してシーディングを完全に無効にします。 |
| `SELF_HOSTED_RUNNER_MAX_LIFETIME_GRACE_MS` | `900000` | セッションが `--kill-session-after-min` 制限に達した後、実行中のターンが終了するか、リリースが完了するのを待つ時間。その後、ランナーはセッションを終了します。 |
| `SELF_HOSTED_RUNNER_POST_TURN_SETTLE_MS` | `7000` | ターンが終了した後、セッションのプロセスがターンの終了を Anthropic に報告している間、ランナーが `--drain-wait-sec` ドレイン用にセッションをビジーとしてカウントする時間の上限。`0` または使用不可能な値はデフォルトにフォールバックするため、ホールドをオフにすることはできません。Claude Code v2.1.275 以降が必要です。 |
| `SELF_HOSTED_RUNNER_SIGKILL_GRACE_MS` | `30000` | ランナーが割り込み不可能な I/O でスタックしている子に `SIGKILL` を配信するのを待つ時間。その後、ランナー自体が終了します。`--post-session-hook-timeout-sec` プラス 15 秒でフロアされ、`--push-outcome-on-release` が設定されている場合は 30 秒追加されます。有効な最小値はデフォルトで 75 秒です。 |
| `CLAUDE_RUNNER_FETCH_DEPTH` | `50` | 新規クローン用の Git フェッチ深度。正の整数、または完全なフェッチ用に `full` または `0` を設定します。ワークスペースに既に存在するリポジトリは既存の深度を保持します。 |
| `CLAUDE_RUNNER_FETCH_SERVER_PROGRESS_CAP_MS` | `600000` | git サーバー自身の進捗値が上昇し続けている間（サーバーが大規模なリポジトリ用のパックを準備している場合など）、git フェッチが最初のデータを待機できる時間（試行ごと、ミリ秒単位）。`0` または `off` を指定すると待機がオフになり、その場合、そのようなフェッチはデータがないまま 2 分経過すると打ち切られます。その他の整数は `120000` から `1800000` の範囲（2〜30 分）に制限されます。Claude Code v2.1.295 以降が必要です。 |
| `CLAUDE_RUNNER_SKIP_GIT_VERIFY` | 未設定 | `1` の場合、`checkout` フック実行後の `.git` 存在チェックをスキップします。フックが非 git ソースを具体化する場合は、これを設定します。 |
| `FORCE_AUTOUPDATE_PLUGINS` | 未設定 | `1` の場合、バイナリがピン留めされていても、プラグインマーケットプレイスの自動更新を許可します。 |
| `CLAUDE_CODE_DISABLE_ARTIFACT` | 未設定 | `1` の場合、組織の管理者設定に関係なくセッション内の Artifact ツールを無効にし、`*.frame.claudeusercontent.com` エグレス要件をドロップします。 |

## テレメトリ

セッション子は、オフにしない限り、運用テレメトリを Anthropic に送信します。コードまたはリポジトリコンテンツは送信されません。ランナープロセスでテレメトリ変数を設定します。ランナーはサーバー提供の環境変数を適用した後、それらを再アサートするため、オペレーターの設定は常に優先されます。

1 つのコントロールはセルフホスト環境に固有です。`CLAUDE_CODE_BYOC_ENABLE_DATADOG=1` は Datadog 運用メトリクスにオプトインします。これはセルフホスト環境ではデフォルトでオフです。一般的な Claude Code テレメトリコントロール `DISABLE_TELEMETRY`、`DO_NOT_TRACK`、`DISABLE_ERROR_REPORTING`、`CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC` は [環境変数リファレンス](/docs/ja/env-vars.md) に記載されているようにセッション子に適用されます。`DISABLE_GROWTHBOOK` は関連していますが異なります。`DISABLE_GROWTHBOOK=1` を設定するとフィーチャーフラグフェッチが無効になり、`DISABLE_TELEMETRY` も設定されない限りテレメトリはオンのままです。

`CLAUDE_CODE_ENABLE_TELEMETRY` は無関係です。これは [監視](/docs/ja/monitoring-usage.md) で説明されているように、独自のコレクターへの OpenTelemetry エクスポートを有効にし、Anthropic のアナリティクスを制御しません。

## ヘルスエンドポイント

ランナーは設定されたヘルスポートで `GET /healthz` を提供します。レスポンスは、プロセスが生存している限り、ポーリングループがどの状態にあるかに関係なく `200 OK` です。したがって、このエンドポイントの HTTP プローブはデッドプロセスのみを検出します。JSON ボディは現在の状態を説明します。

```json theme={null}
{
  "status": "ok",
  "runner_id": "ccrunner_...",
  "active_sessions": 2,
  "last_poll_at": "2026-03-31T18:04:11.220Z",
  "last_poll_age_ms": 842
}
```

カスタムプローブでライブネスシグナルとして `last_poll_age_ms` を使用します。無限に増加する値は、ポーリングループがスタックしていることを示します。`last_poll_at` と `last_poll_age_ms` の両方は、最初のポーリングが完了するまで `null` です。

オーケストレーター自身の `/healthz` は、そのヘルスポート上で常に `200` を返します。ボディには、最新のポーリングが成功したかどうかを報告する `connected` フィールドと、`queue_counts` 内の状態ごとのスポーンキュー数が含まれます。`connected` が `false` である理由を確認するには、トップレベルの `last_error` フィールドを参照してください。このフィールドはポーリングが成功するたびに `null` にリセットされます。ステータスコードではなく `connected` でレディネスとアラートをゲートします。

[SCM コネクタ](#scm-connector-flags) が設定されている場合、オーケストレーターの `/healthz` ボディは `scm_connector_connected` と、`connected`、`last_connected_at`、`last_error`、`reconnects`、`requests_forwarded` を持つ `scm_connector` オブジェクトも持ちます。`--scm-connector-host` が設定されていない場合、両方のフィールドは `null` です。

## Prometheus メトリクス

各ランナーは `/healthz` と同じポートで `GET /metrics` で Prometheus メトリクスを提供します。主要なシリーズ：

| シリーズ | 注記 |
| :- | :- |
| `claude_code_self_hosted_runner_info{runner_id,version,client_label}` | 常に `1`。フリートインベントリとバージョンドリフト検出に有用です。 |
| `claude_code_self_hosted_runner_capacity` | 設定済み `--capacity` |
| `claude_code_self_hosted_runner_active_sessions` | 現在実行中のセッション |
| `claude_code_self_hosted_runner_locked_account{email}` | ランナーがユーザーにロックされ、`act.email` クレームを持つセッショントークンが発行された後に存在します。シリーズは Claude Tag エージェントにロックされたランナーには存在しません。そのセッショントークンは `act.email` を持ちません。ラベル値はアカウントメールです。メトリクスストアが広く読み取り可能な場合は、スクレイプ時にラベルをドロップまたはハッシュします。例えば Prometheus `metric_relabel_configs` を使用します。 |
| `claude_code_self_hosted_runner_last_poll_age_seconds` | 最後の成功したポーリング以降の秒数。60 を超える場合はアラートします。 |
| `claude_code_self_hosted_runner_poll_errors_total{error_kind}` | 種類別の累積 PollWork 失敗：`transport`、`timeout`、`5xx`、`429`、または `4xx`。すべての 5 つのシリーズはプロセス開始から存在します。`rate(...[5m]) > 0` でアラートします。 |
| `claude_code_self_hosted_runner_sessions_started_total{client_platform}` | ランナーの生存期間にわたってスポーンされたセッション子プロセス。セッションオリジン（`web_claude_ai`、`ios`、`android`、`desktop_app`、`claude_code_cli` など）ごとに 1 つのシリーズ、またはサーバーが 1 つを送信しなかった場合は `unknown`。Slack セッションは、どの Slack 統合が作成したかに応じて `claude_in_slack` または `claude-in-slack` を持ちます。`{client_platform=~"claude[-_]in[-_]slack"}` などの正規表現セレクターで両方と一致します。フリート合計には `sum()` を使用します。 |
| `claude_code_self_hosted_runner_sessions_completed_total{client_platform}` | クリーンに終了したセッション。同じ方法でラベル付けされます。より広い範囲：[セッションライフサイクルカウンターセマンティクス](#session-lifecycle-counter-semantics) を参照して、何がカウントされるかを確認してください。 |
| `claude_code_self_hosted_runner_sessions_failed_total{client_platform}` | 失敗で終了したセッション。同じ注意事項：[セッションライフサイクルカウンターセマンティクス](#session-lifecycle-counter-semantics) を参照してください。 |
| `claude_code_self_hosted_runner_sessions_interrupted_total{client_platform}` | ランナーがセッション結果ではなく運用上の理由で終了したセッション。同じ方法でラベル付けされます。[セッションライフサイクルカウンターセマンティクス](#session-lifecycle-counter-semantics) を参照してください。 |
| `claude_code_self_hosted_runner_initializing_sessions` | 初期化フェーズ内のセッション。割り当てから子の初期化イベントまで。 |
| `claude_code_self_hosted_runner_session_init_duration_seconds` | セッション初期化期間のヒストグラム |
| `claude_code_self_hosted_runner_session_init_errors_total` | 初期化に到達する前に失敗したセッション：チェックアウトフック失敗、git 準備、トークン問題、または初期化前の子クラッシュ |
| `claude_code_self_hosted_runner_session_start_hook_errors_total` | エラー結果を報告した `SessionStart` フック。失敗したフック実行ごとに 1 つ。 |
| `claude_code_self_hosted_runner_session_idle_seconds{session_id,client_platform}` | セッションがアイドル状態になってからの秒数のセッションごとのゲージ。未回答の権限プロンプトでスタックしているセッションを終了するのに有用です。 |

オーケストレーターは `/healthz` と同じポートで `GET /metrics` で独自のシリーズを提供します。

| シリーズ | 注記 |
| :- | :- |
| `claude_code_self_hosted_orchestrator_info{version,pool_id,orchestrator_uuid,hostname}` | 常に `1` |
| `claude_code_self_hosted_orchestrator_connected` | 最新のポーリングが成功した場合は `1`。失敗の種類に関係なく、失敗したポーリング後は `0` にドロップします。 |
| `claude_code_self_hosted_orchestrator_last_poll_age_seconds` | 最後のポーリング試行（成功または失敗）以降の秒数。最後の成功以降を測定するランナーの同じ名前のメトリクスとは異なります。`connected` とペアにして、失敗したポーリングをキャッチします。オーケストレーターのポーリングループはフック実行で待機するため、デフォルトで約 90 秒の `--hook-timeout` プラス余裕の上でアラートします。フラット 60 ではなく。 |
| `claude_code_self_hosted_orchestrator_poll_errors_total{error_kind}` | 種類別の累積 PollSpawnHints 失敗：`transport`、`timeout`、`5xx`、`429`、または `4xx`。すべての 5 つのシリーズはプロセス開始から存在します。`rate(...[5m]) > 0` でアラートします。 |
| `claude_code_self_hosted_orchestrator_queue_pending_sessions` | 今すぐクレーム可能なスポーン要求 |
| `claude_code_self_hosted_orchestrator_queue_backing_off_sessions` | 再試行可能なフック失敗後の再試行バックオフ内のスポーン要求 |
| `claude_code_self_hosted_orchestrator_queue_circuit_broken_sessions` | スポーンがブロックされているセッション。各セッションは、ユーザーが新しいメッセージを送信するか、Owner が環境の **Activity** タブから再試行するまでブロックされたままです。原因を修正した後もカウントがゼロを超えたままになる場合があります。ゼロを超える場合はアラートします。 |
| `claude_code_self_hosted_orchestrator_pool_pending_sessions` | この環境でランナーを待機している総セッション数。環境全体の集計。すべてのオーケストレーターインスタンスで同一です。インスタンス全体で `SUM` ではなく `MAX` を使用します。 |
| `claude_code_self_hosted_orchestrator_pool_active_sessions` | この環境内のアライブランナーに現在割り当てられているセッション。環境全体の集計。すべてのオーケストレーターインスタンスで同一です。インスタンス全体で `SUM` ではなく `MAX` を使用します。 |
| `claude_code_self_hosted_orchestrator_spawn_hooks_total{result}` | 累積 `spawn-runner` フック結果：`ok`、`retryable`、`non_retryable`。オーケストレーターフック呼び出しをカウントします。ランナーがスポーンするセッション子ではありません。容量が 1 を超える場合、ウォームプール、同じセッション用に再度スポーンされたランナーは `sessions_started_total` と比較できないため、2 つが異なります。 |
| `claude_code_self_hosted_orchestrator_spawn_hook_duration_seconds` | フック期間のヒストグラム |
| `claude_code_self_hosted_orchestrator_warm_hints_dispatched_total` | プロセス開始以降にディスパッチされたスタンバイスポーン要求 |
| `claude_code_self_hosted_orchestrator_session_queue_wait_seconds` | 各セッションがオーケストレーターがスポーン用にクレームするまでキューで待機した秒数のヒストグラム。コントロールプレーンが各セッションのスポーン要求で送信するキュー待機タイムスタンプから記録されます。p50/p99 キュー時間アラートに使用します。プレウォーミングスポーンはサンプリングされません。 |
| `claude_code_self_hosted_orchestrator_clock_skew_seconds` | ローカルマイナスサーバークロックスキュー。診断。測定後に存在します。 |
| `claude_code_self_hosted_orchestrator_scm_connector_connected` | [SCM コネクタ](#scm-connector-flags) の WebSocket がオープンしている場合は `1`。ダイアルまたはバックオフ中は `0`。`--scm-connector-host` が設定されていない場合は存在しません。 |
| `claude_code_self_hosted_orchestrator_scm_connector_requests_forwarded_total` | プロセス開始以降に設定された SCM ホストにプロキシされた累積 HTTP リクエスト。`--scm-connector-host` が設定されていない場合は存在しません。 |

オートスケーリングの場合、スケーリングスタイルに一致するシリーズを選択し、スケーラーに供給する前にゲートします。

* **キュー深度スケーリング**：`queue_pending_sessions` ではなく `claude_code_self_hosted_orchestrator_pool_pending_sessions` を HPA または KEDA スケーラーに供給します。
* **容量スケーリング**：ランナーの `active_sessions` と `capacity` の比率でスケーリングします。
* **`connected` でゲート**：インスタンスごとに `claude_code_self_hosted_orchestrator_connected == 1` でクエリをフィルタリングします。切断されたレプリカの古い値がスケーラーに供給されないようにします。

完全なポーリング停止中、すべてのレプリカが切断されると、ゲートされたクエリはデータを返しません。HPA は欠落メトリクスで現在のレプリカ数を保持しますが、KEDA の Prometheus スケーラーはデフォルト `ignoreNullValues: "true"` で空の結果をゼロとして読み取り、スケールインします。ScaledObject で `ignoreNullValues: "false"` を設定し、オプションで `fallback` レプリカフロアを設定します。

次の Prometheus Operator `PodMonitor` は両方のプロセスをカバーしています。`app.kubernetes.io/part-of: claude-code-self-hosted-runner` ラベルと、[Kubernetes レシピ](/docs/ja/self-hosted-environments-deploy.md#kubernetes) が設定する名前付き `health` ポートでポッドを選択します。デプロイメントに合わせて名前空間を調整します。

```yaml theme={null}
# Claude Code セルフホストランナー + オーケストレーター用の Prometheus Operator PodMonitor の例。
# 名前空間とラベルセレクターをデプロイメントに合わせて調整します。
# ランナーとオーケストレーターの両方は、その --health-port（デフォルト 8080）で /metrics を提供します。
apiVersion: monitoring.coreos.com/v1
kind: PodMonitor
metadata:
  name: claude-code-self-hosted-runner
  namespace: monitoring
spec:
  namespaceSelector:
    matchNames:
      - claude-runners
  selector:
    matchExpressions:
      # Kubernetes レシピからのランナー Deployment、および同じ方法でラベル付けされた
      # オンデマンドランナー Job とオーケストレーターポッド、および名前付き 'health' containerPort を持つものと一致します。
      - key: app.kubernetes.io/part-of
        operator: In
        values: [claude-code-self-hosted-runner]
  podMetricsEndpoints:
    - port: health
      path: /metrics
      interval: 30s
```

これらのサンプルアラートルールは出発点です。フリートサイズのしきい値を調整します。

```yaml theme={null}
# Claude Code セルフホストランナー + オーケストレーター用の Prometheus アラートルールの例。
# フリートサイズと SLO のしきい値を調整します。
groups:
  - name: claude-code-self-hosted-runner
    rules:
      - alert: ClaudeRunnerPollStale
        expr: claude_code_self_hosted_runner_last_poll_age_seconds > 60
        for: 2m
        labels: {severity: warning}
        annotations:
          summary: "ランナー {{ $labels.pod }} は 60 秒以上ポーリングしていません"
      - alert: ClaudeRunnerVersionDrift
        expr: count(count by (version) (claude_code_self_hosted_runner_info)) > 1
        for: 30m
        labels: {severity: info}
        annotations:
          summary: "ランナーは混合バージョンを実行しています"
      - alert: ClaudeRunnerInitErrorsHigh
        expr: increase(claude_code_self_hosted_runner_session_init_errors_total[10m]) > 3
        for: 5m
        labels: {severity: warning}
        annotations:
          summary: "ランナー {{ $labels.pod }}：10 分間に 3 回以上のセッション初期化失敗（チェックアウトフック / git / トークン / 初期化前クラッシュ）"
      - alert: ClaudeRunnerPollErrors
        expr: sum by (pod) (rate(claude_code_self_hosted_runner_poll_errors_total[5m])) > 0
        for: 2m
        labels: {severity: warning}
        annotations:
          summary: "ランナー {{ $labels.pod }}：PollWork が失敗しています（5 分間に {{ $value | humanize }}/s）"
      - alert: ClaudeRunnerSessionStartHookErrors
        expr: increase(claude_code_self_hosted_runner_session_start_hook_errors_total[10m]) > 3
        for: 5m
        labels: {severity: warning}
        annotations:
          summary: "ランナー {{ $labels.pod }}：10 分間に 3 回以上の SessionStart フック失敗"

  - name: claude-code-self-hosted-orchestrator
    rules:
      - alert: ClaudeOrchestratorDisconnected
        expr: claude_code_self_hosted_orchestrator_connected == 0
        for: 2m
        labels: {severity: critical}
        annotations:
          summary: "オーケストレーター {{ $labels.pod }} は Anthropic コントロールプレーンに到達できません"
      - alert: ClaudeOrchestratorPollStale
        expr: claude_code_self_hosted_orchestrator_last_poll_age_seconds > 90
        for: 2m
        labels: {severity: warning}
        annotations:
          summary: "オーケストレーター {{ $labels.pod }} は 90 秒以上ポーリングしていません（ポーリングループはフック実行で待機）"
      - alert: ClaudeOrchestratorCircuitBroken
        expr: claude_code_self_hosted_orchestrator_queue_circuit_broken_sessions > 0
        for: 1m
        labels: {severity: critical}
        annotations:
          summary: "スポーンがブロックされているセッション：{{ $value }}。Activity タブで各セッションのエラーを確認し、原因を修正してから Retry を選択してください"
      - alert: ClaudeOrchestratorPollErrors
        expr: sum by (pod) (rate(claude_code_self_hosted_orchestrator_poll_errors_total[5m])) > 0
        for: 2m
        labels: {severity: warning}
        annotations:
          summary: "オーケストレーター {{ $labels.pod }}：PollSpawnHints が失敗しています（5 分間に {{ $value | humanize }}/s）"
      - alert: ClaudeOrchestratorSpawnHookFailing
        expr: sum by (pod) (increase(claude_code_self_hosted_orchestrator_spawn_hooks_total{result!="ok"}[5m])) > 3
        for: 5m
        labels: {severity: warning}
        annotations:
          summary: "オーケストレーター {{ $labels.pod }}：5 分間に 3 回以上の spawn-runner フック失敗"
```

### セッション子メトリクスをパススルーする

各セッションは独自の子プロセスで実行され、独自の OpenTelemetry メトリクスを持ちます。`--capacity` が 1 を超える場合、ランナーはそれらの子メトリクスの公開方法を書き換えます。ランナーホストで `OTEL_METRICS_EXPORTER=prometheus` を設定し、セッションの環境で `CLAUDE_CODE_ENABLE_TELEMETRY=1` を設定します。例えば、[ラッパースクリプト](/docs/ja/self-hosted-environments-configuration.md#wrapper-scripts) またはセッションが継承するランナー独自の環境から、各子のカウンターとゲージ計器をランナー独自の `/metrics` エンドポイントで再公開します。ランナーのシリーズと並んで。ランナーは子のエクスポーターを書き換えて、ヘルスポートのループバックのみのレシーバーに OTLP 経由でプッシュし、各シリーズに `session_id` および `client_platform` ラベルでタグ付けし、セッションが終了するとセッションのシリーズを削除します。ヒストグラムはパススルーしません。ランナー独自のプレフィックスと衝突する子メトリクスの名前は削除されます。

デフォルトの `--capacity 1` では、書き換えは適用されません。セッションの子は通常どおりポート 9464 で独自の Prometheus エンドポイントをバインドします。

#### セッションのメトリクスをランナーのメトリクスと結合する

セッション独自のメトリクスを `claude_code_self_hosted_runner_session_idle_seconds` と並べるには、ランナーの `session_id` で結合します。

* **`--capacity` が 1 を超える場合**：直接結合します。ランナーの `/metrics` では、セッションのシリーズはそのメトリクスと同じ `session_id` を `session_...` 形式で持ちます。
* **`--capacity 1` の場合**：変換した `ccr_session_id` で結合します。デフォルトでは、ポート 9464 の各 Claude Code メトリクスはこのラベルを持ち、セッション ID を `cse_...` 形式で保持しています。新しいラベルで `cse_` プレフィックスを `session_` に置き換えると、ランナーの `session_id` が得られます。メトリクス自体の `session_id` には Claude Code 独自の [`session.id`](/docs/ja/monitoring-usage#standard-attributes) が入っており、どのランナーシリーズとも一致しません。

### セッションライフサイクルカウンターセマンティクス

`sessions_started_total`、`sessions_completed_total`、`sessions_failed_total`、`sessions_interrupted_total` カウンターは、各セッションがどのように終了したかで分類します。スポーンされたすべてのセッション子はスポーン時に `sessions_started_total` をインクリメントし、終了時に他の 3 つのうち正確に 1 つをインクリメントします。したがって、`sessions_started_total` から他の 3 つの合計を引いたものは、現在実行中のセッション子の数に等しくなります。

* `completed`：セッションはクリーンに終了しました。これは子がコード `0` で独自に終了する場合、セッションが子がまだ接続されている間にアーカイブまたは削除される場合、およびランナーがスロットをクリーンハンドオフとしてリリースする場合をカバーします。アイドルタイムアウト、リタイア時間、または `--kill-session-after-min` 制限でのリリース、スタートアップタイムアウト、またはポーリングループが子が終了する前に気付いたサーバー側の割り当て解除。`sessions_completed_total` をインクリメントします。
* `failed`：子がゼロ以外のコードで独自に終了しました。クラッシュまたはスポーン後のセットアップ失敗のいずれか。`sessions_failed_total` をインクリメントします。
* `interrupted`：ランナーがセッション成功またはランナー障害のいずれでもない運用上の理由で子を終了しました。たとえばドレインや、`--kill-session-after-min` 制限後の [`SELF_HOSTED_RUNNER_MAX_LIFETIME_GRACE_MS`](#environment-variable-only-settings) グレースウィンドウが終了した時点でまだランナー上にあったセッションの終了などです。Kubernetes ローリング再起動が `SIGTERM` を送信することは、ドレインの一例です。`sessions_interrupted_total` をインクリメントします。

v2.1.260 より前では、ランナーは `--kill-session-after-min` 制限に達したすべてのセッションを終了し、`sessions_interrupted_total` でカウントしました。

[`post-session` フック](/docs/ja/self-hosted-environments-configuration#post-session) の `CLAUDE_RUNNER_EXIT_REASON` はクリーンハンドオフを異なる方法で分類します。フックは、ランナーが子を停止したため、リリース、スタートアップタイムアウト、サーバー割り当て解除、およびポーリングが先に気付いたアーカイブまたは削除を `interrupted` として報告します。これらのカウンターは、スロットがクリーンに返されたため、`completed` として同じイベントを記録します。

フック受信を `sessions_completed_total` に対して直接調整する場合、完了をアンダーカウントします。セッションごとの保証にはフックを使用し、集計レートにはカウンターを使用します。

ワンショット環境では、`--capacity 1` とデフォルト `--drain-grace-sec 0` で、各ランナープロセスは 1 つのセッションが終了した直後に終了します。`sessions_completed_total`、`sessions_failed_total`、`sessions_interrupted_total` はセッション終了時にのみインクリメントされます。その終了の直前に、Prometheus スクレイプが 15 ～ 60 秒ごとの場合、ランナーのシリーズが消える前にインクリメントをキャッチすることはめったにありません。これら 3 つのセッション終了カウンターは、このセクションの残りが参照するターミナルカウンターです。`sessions_started_total` はスポーン時にインクリメントされ、セッションの生存期間中は表示されたままなので、確実に表示されます。ただし、ワンショット環境では、累積カウントよりも「現在実行中のセッション」に近く読み取られます。

対応する目標の代わりにこのテーブルのシリーズを使用します。

| 目標 | 使用 |
| :- | :- |
| スループット | `claude_code_self_hosted_orchestrator_spawn_hooks_total{result="ok"}`。成功した `spawn-runner` フック呼び出しごとに 1 回インクリメントされ、`rate()` の下で意味のある長寿命オーケストレーター上のカウンター。フック呼び出しをカウントします。ランナーがスポーンするセッションではなく、プレウォーミングと同じセッション用の繰り返しスポーンはセッションカウントから異なります。 |
| 利用率 | `sum(claude_code_self_hosted_runner_active_sessions)` 対 `sum(claude_code_self_hosted_runner_capacity)`。ランナーの生存期間に関係なく、すべてのスクレイプで有効なゲージ。 |
| バックログ | キュー深度の `claude_code_self_hosted_orchestrator_pool_pending_sessions`、および `claude_code_self_hosted_orchestrator_queue_circuit_broken_sessions`。ゼロを超える場合はアラートします。 |
| 失敗 | `claude_code_self_hosted_runner_sessions_failed_total`。ベストエフォート。スポーン後の実際のクラッシュはインクリメントされ、`rate()` はセッションを超えて生存するランナーで意味があります。`--drain-grace-sec` が `0` を超える場合。ワンショット環境は他のターミナルカウンターと同じスクレイプウィンドウ問題を持つため、表示される非ゼロ値を調査する価値があるものとして扱います。スポーン前の失敗（チェックアウトフック失敗、git 準備、トークン問題など）は `session_init_errors_total` にのみ表示されます。 |

`orchestrator_*` 行は [オンデマンドオーケストレーター](/docs/ja/self-hosted-environments-configuration.md#on-demand-runners) を実行している環境にのみ存在します。セッションを超えて生存するランナーを持つ固定フリートで、`--drain-grace-sec` が `0` を超える場合、スループットに `sum(rate(claude_code_self_hosted_runner_sessions_started_total[5m]))` を使用します。ワンショットフリートではそのシリーズは他のターミナルカウンターと同じスクレイプウィンドウ問題を持つため、キューに入ったセッション数に依存します。バックログを環境の **Activity** タブで確認します。[**Cloud environments** 管理ページ](https://claude.ai/admin-settings/cloud-environments)：ランナーはキュー深度シリーズをエクスポートしません。

セッションごとの結果報告については、代わりに [`post-session` フック](/docs/ja/self-hosted-environments-configuration#post-session) を使用してください。VM プリエンプションなどの突然のランナー終了を除き、子プロセスがスポーンされたすべてのセッション終了で発火します。[フック独自の契約](/docs/ja/self-hosted-environments-configuration.md#post-session) に従って。

## 次のステップ

* [セルフホスト環境](/docs/ja/self-hosted-environments)：環境、ランナー、セッションモデル。[クイックスタート](/docs/ja/self-hosted-environments-quickstart.md) と [本番環境へのデプロイ](/docs/ja/self-hosted-environments-deploy.md) はセットアップと運用を保持しています。
* [セッションをカスタマイズする](/docs/ja/self-hosted-environments-configuration.md)：ラッパースクリプト、ライフサイクルフック、オンデマンドランナー。
* [セッション ID を検証する](/docs/ja/self-hosted-environments-identity.md)：セッショントークン、そのクレーム、検証方法。
