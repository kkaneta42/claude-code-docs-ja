> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# セルフホストされた環境でセッションをカスタマイズする

> セッションごとの認証情報のためのラッパースクリプト、ライフサイクルフック、オンデマンドランナースポーニングを使用して、セルフホストされた環境のセッションをカスタマイズします。

<Note>
  セルフホストされた環境は Team および Enterprise プランでパブリックベータ版です。[Owner](/docs/ja/cloud-environments#organization-shared-environments) が [**Cloud environments** 管理ページ](https://claude.ai/admin-settings/cloud-environments) で **Allow self-hosted environments** をオンにすることで有効になります。このページは動作するランナーを前提としています。セットアップについては [クイックスタート](/docs/ja/self-hosted-environments-quickstart) を、フリートレシピについては [本番環境へのデプロイ](/docs/ja/self-hosted-environments-deploy) を参照してください。
</Note>

[セルフホストされた環境](/docs/ja/self-hosted-environments) は、デプロイするランナープロセスによって実行される独自のインフラストラクチャ上で Claude Code [クラウドセッション](/docs/ja/claude-code-on-the-web) を実行します。設定がない場合、そのランナーはセッションのリポジトリをクローンし、Claude Code をスポーンし、クリーンアップします。このページはランナーを操作するプラットフォームエンジニア向けです。デフォルトが適さない場合の拡張ポイント、セッションごとの認証情報プロビジョニングからチェックアウト全体の置き換えまでをカバーしています。ラッパーとフックはランナーホスト上の実行可能ファイルとして実行され、Linux または macOS であり、このページの例は POSIX シェルを想定しています。

このページのいくつかのフック環境変数は `pool` を使用しています（例：`CLAUDE_RUNNER_POOL_ID`）。CLI フラグと環境変数名は `environment` を使用しています（例：`--environment-secret-file`）。

<h2 id="wrapper-scripts">
  ラッパースクリプト
</h2>

各セッションがランナー自体では実行できないセットアップが必要な場合、ラッパースクリプトを使用します。セッション作成者にスコープされた短期認証情報のプロビジョニング、環境固有のシークレットのエクスポート、言語ツールチェーンの準備、または子プロセスの周囲のリソース制限の適用などです。ランナーはセッションごとに 1 回、Claude Code バイナリの代わりにラッパーを起動します。ラッパーを終了するには、`$CLAUDE_RUNNER_CLAUDE_BIN`（ランナー自体のバイナリ）に `exec` することで、シグナルと終了コードが正しく伝播します。

ランナーを起動するときに `--exec-path` または `SELF_HOSTED_RUNNER_EXEC_PATH` をラッパーに指定します。

```bash theme={null}
claude self-hosted-runner --environment-secret-file /etc/claude/environment-secret --exec-path /etc/claude/session-wrapper.sh
```

ランナーはラッパーの環境に以下を設定します。

| 変数 | 説明 |
| :- | :- |
| `CLAUDE_CODE_SESSION_ACCESS_TOKEN` | セッション JWT。プレフィックス `sk-ant-cc-` が付きます。その `act` クレームはセッション作成者を識別し、作成サーフェスが記録した場合は作成者のメールを含みます。値はスポーン時のトークンです。更新はこどもの stdin を介して到着するため、ラッパーは初期値のみを見ます。[セッション ID を検証する](/docs/ja/self-hosted-environments-identity) を参照してください。 |
| `CCR_SESSION_ACCOUNT_EMAIL` | セッション作成者のメール。ランナーによってトークンの `act.email` クレームから署名検証なしで事前抽出されます。ラベリングなどに適しています。メールが認証情報の発行をゲートする場合、トークンを検証し、代わりにクレームから読み取ります。[セッション作成者にスコープされた認証情報をプロビジョニングする](#provision-credentials-scoped-to-the-session-creator) を参照してください。トークンが作成者メールを含まない場合は設定されません。個人識別情報として扱います。 |
| `CLAUDE_RUNNER_CLIENT_PLATFORM` | セッションを作成したクライアントサーフェス（`web_claude_ai`、`desktop_app`、`ios`、`claude_code_cli`、`scheduled_trigger` など）。Anthropic はセッション作成時に値を 1 回記録するため、ラッパーとすべてのライフサイクルフックは同じ値を見ます。採用分析とラベリングにのみ使用し、認可シグナルとしては使用しないでください。セッションに記録または認識されたサーフェスがない場合は設定されないため、`set -u` の下で `${CLAUDE_RUNNER_CLIENT_PLATFORM:-}` として参照してください。Claude Code v2.1.229 以降が必要です。 |
| `CLAUDE_RUNNER_CLAUDE_BIN` | ランナー自体の Claude Code バイナリへの絶対パス。`exec "$CLAUDE_RUNNER_CLAUDE_BIN" "$@"` でラッパーを終了して、インストールパスをハードコードせずにピン留めされたバイナリに制御を渡します。 |
| `CLAUDE_CODE_REMOTE_SESSION_ID` | タグ付き `cse_...` 形式のセッション ID。これは [ライフサイクルフック](#lifecycle-hooks) が `session_...` 形式の `CLAUDE_RUNNER_SESSION_ID` として見るのと同じセッションです。UUID 変数は両方で一致し、`cse_` プレフィックスを `session_` に置き換えるとセッション URL に表示される ID が得られます。 |
| `CLAUDE_CODE_REMOTE_SESSION_UUID` | 正規 UUID 形式の同じセッション ID。UUID をキーとするシステム用です。 |
| `CLAUDE_SESSION_INGRESS_TOKEN_FILE` | 現在のセッション JWT を保持する、セッションごとのファイルへの絶対パス。トークン更新全体で最新に保たれます。シェルサブプロセスは、ユーザーがセッションに追加した添付ファイルをダウンロードするときに、その `Authorization` ヘッダーに対して読み取ります。`exec` は変数を自動的に保持します。子の環境を再構築するラッパーは変数を引き継ぐ必要があります。そうしないと、添付ファイルのダウンロードが静かに停止します。 |
| `CLAUDE_CONFIG_DIR` | セッションごとの Claude 設定ディレクトリ。ランナーが起動時にキャプチャするランナーホストの設定のスナップショットからセッション開始時に書き込まれます。[権限とツール承認](#permissions-and-tool-approval) を参照してください。このディレクトリへの書き込みはこのセッションに分離されます。ディレクトリはセッション終了後、ランナーを [`--remove-session-state`](/docs/ja/self-hosted-environments-reference#runner-cli-flags) で起動しない限り `<base-dir>/_sessions/` の下に留まります。[事前ウォーミングされたチェックアウトを再利用する](/docs/ja/self-hosted-environments-deploy#reuse-a-pre-warmed-checkout) を参照してください。 |
| `ANTHROPIC_BASE_URL` | こどもが使用する API ベース URL。コントロールプレーンによってセッションごとに配信され、通常は `https://api.anthropic.com` です。上書きしないでください。セッションの推論認証情報は Anthropic が発行した OAuth トークンであり、他のプロバイダーはこれを受け入れません。 |
| `CLAUDE_CODE_OAUTH_TOKEN` | こどもがモデル推論に使用する短期 OAuth アクセストークン。モデル推論とファイルアップロードのみにスコープされ、約 30 分の有効期限があります。ランナーは有効期限前に再発行し、こどもの stdin を介して更新を配信するため、[stdin を接続したままにしない](#keep-stdin-and-file-descriptor-3-attached) ラッパーは初期値のみを見ます。組織の IP 許可リストに依存してこのトークンの使用を制限しないでください。約 30 分間リークした場合に使用可能なままのベアラー認証情報として扱い、ログに記録したり、ディスクに書き込んだり、セッションコンテナの外に転送したりしないでください。 |

ラッパーはこどもの管理環境の残りの部分も継承します。これには、サーバーが提供する環境変数が含まれます。`exec` はすべてを自動的に伝播します。ラッパーが別の方法でこどもをスポーンする場合、完全な環境を転送します。

<h3 id="keep-stdin-and-file-descriptor-3-attached">
  stdin とファイルディスクリプタ 3 を接続したままにする
</h3>

こどもの stdin はランナーのコントロールチャネルです。トークン更新とセッション終了シグナルがそこに到着します。ランナーはファイルディスクリプタ 3 でパイプも開き、こどものアクティビティシグナルを読み取ってアイドルおよびスタートアップタイムアウトを駆動します。プレーンな `exec "$CLAUDE_RUNNER_CLAUDE_BIN" "$@"` は両方を自動的に保持します。

ラッパーが裸の `&` でこどもをバックグラウンドにする場合、こどもの stdin が切断されます。セッションは初期 OAuth トークンの約 30 分の有効期限が切れるまで健全に見えますが、その後すべての API 呼び出しが `401 authentication_error` で失敗します。ラッパーがこどもをバックグラウンドにする必要がある場合（例えば、ティアダウントラップを生かしておくため）、stdin をファイルディスクリプタ 4 以上に保存し、明示的に再接続します。

```bash theme={null}
exec 4<&0
"$CLAUDE_RUNNER_CLAUDE_BIN" "$@" <&4 4<&- &
CHILD=$!
trap 'teardown' EXIT
wait "$CHILD"
```

ラッパーでファイルディスクリプタ 3 を閉じたり再利用したりしないでください。こどもの stdout と stderr をリダイレクトするのは問題ありません。

<h3 id="pass-the-system-prompt-flags-through">
  システムプロンプトフラグをそのまま渡す
</h3>

Anthropic のコントロールプレーンがセッションに送信するシステムプロンプトと追加システムプロンプトは、インラインテキストではなくファイルパスとしてラッパーに届きます。ランナーは各プロンプトをセッションの設定ディレクトリ `CLAUDE_CONFIG_DIR` 内のファイルに書き込み、そのパスをラッパーが受け取る引数の中で [`--system-prompt-file <path>` または `--append-system-prompt-file <path>`](/docs/ja/cli-reference#system-prompt-flags) として渡します。

Claude Code v2.1.281 以降のランナーは、プロンプトをファイルとして配信します。v2.1.281 より前は、ランナーはプロンプトを `--system-prompt <text>` および `--append-system-prompt <text>` として渡していました。

ラッパースクリプトまたは [`command` フック](#command) では、これらのフラグを次のように扱います。

* **そのまま渡す**: ラッパーを `exec "$CLAUDE_RUNNER_CLAUDE_BIN" "$@"` で終了します。これにより、ファイルフラグが他のすべての引数とともに転送されます。フラグを削除したり書き換えたりしないでください。セッションがプロンプトファイルフラグを失うと、コントロールプレーンがそのセッションに送信した指示なしで実行されます。
* **v2.1.281 以降のランナーでは、追加したファイルフラグはサーバーのフラグを置き換えるものであり、追加されることはない**: 各プロンプトファイルフラグは単一の値を取り、Claude Code は最後に出現したものを保持します。そのため、`"$@"` の後に `--append-system-prompt-file <path>` を追加すると、ファイルの内容がサーバーの追加指示を置き換えます。サーバーの指示に加えて指示を追加するには、ランナーイメージの `CLAUDE.md` に記述します。ランナーはこれを[すべてのセッションのユーザーレベル設定にシードします](#how-each-session’s-config-is-assembled)。

<h3 id="provision-credentials-scoped-to-the-session-creator">
  セッション作成者にスコープされた認証情報をプロビジョニングする
</h3>

`decode-token` サブコマンドを使用してセッション JWT からクレームを読み取ります。引数、`CLAUDE_CODE_SESSION_ACCESS_TOKEN`、または stdin からトークンを読み取ります（この順序で）。[セッション内のトークンを検証する](/docs/ja/self-hosted-environments-identity#verify-the-token-inside-the-session) を参照して、何をチェックするかを確認してください。以下の例は作成者 ID をデコードし、短期 AWS 認証情報と交換し、Claude Code に exec します。

```bash theme={null}
#!/bin/bash
# 安定した Anthropic ユーザー ID をキーにし、人間の作成者を要求します。
CREATOR_SUB=$("$CLAUDE_RUNNER_CLAUDE_BIN" self-hosted-runner decode-token \
  | jq -re '.act.sub // "" | select(startswith("user:"))') \
  || { echo "decode-token: verification failed or no human creator" >&2; exit 1; }

creds=$(your-sts-helper assume-role --subject "$CREATOR_SUB") \
  || { echo "credential exchange failed" >&2; exit 1; }
eval "$creds"

exec "$CLAUDE_RUNNER_CLAUDE_BIN" "$@"
```

抽出されたクレームが認可決定をゲートする場合、`jq -r` ではなく `jq -re` を使用して、不在のクレームが下流に文字列 `null` を渡す代わりにゼロ以外で終了するようにします。組織のサービス ID（ボットおよびエージェントセッションなど）によって作成されたセッションは、`user:` サブジェクトではなく `agent:` サブジェクトを持つため、この例はそれらを拒否します。環境がそれらのセッションを提供する場合、ラッパーが終了する代わりにデフォルト認証情報にフォールバックするかどうかを明示的に決定します。認証情報交換で代わりにメールが必要な場合は、`.act.email` を読み取り、その不在を処理します。トークンは作成サーフェスが記録した場合にのみメールを持ち、[CLI ディスパッチセッション](/docs/ja/self-hosted-environments-testing#run-the-test-loop) はそれを欠く可能性があります。完全なクレーム参照とランナーの外のサービスからの検証については、[セッション ID を検証する](/docs/ja/self-hosted-environments-identity) を参照してください。

<h2 id="lifecycle-hooks">
  ライフサイクルフック
</h2>

ライフサイクルフックは、ランナーのセッションごとのパイプラインのステージを独自のスクリプトに置き換えます。`--hooks-dir <path>` または `SELF_HOSTED_RUNNER_HOOKS_DIR` を使用して、ランナーをフックのディレクトリに指定します。ランナーは既知の名前を持つ実行可能ファイルを探します。存在しないフックはすべて組み込み動作にフォールスルーするため、必要なものだけを記述します。フックはランナー自身の権限で実行され、セッション子プロセスはその UID を共有するため、フックディレクトリを読み取り専用でマウントするか、イメージにベイクして、セッションコードが変更できないようにしてください。[強化セクション](/docs/ja/self-hosted-environments-deploy#harden-your-deployment)を参照してください。

これらのフックは、[Claude Code フック](/docs/ja/hooks)（セッション内で実行される）とは異なります。ライフサイクルフックはランナー上で、セッションの周囲で実行されます。

<h3 id="checkout">
  checkout
</h3>

リポジトリごとに 1 回実行され、ランナーの組み込みクローンとフェッチの代わりになります。フックを使用して、リードスルーミラーからクローンしたり、アーカイブからワーキングツリーをシードしたり、セッションごとの git 認証を適用したりします。ランナーは以下の変数を設定します。また、表に記載されていない他の `CLAUDE_RUNNER_` 変数を設定する場合もあります。

| 変数 | 説明 |
| :- | :- |
| `CLAUDE_RUNNER_REPO_URL` | クローンするリポジトリ URL。`--git-host-rewrite` と `--git-ssh-rewrite` が適用された後 |
| `CLAUDE_RUNNER_REPO_REF` | チェックアウトするリビジョン。ブランチ、タグ、またはコミット SHA。セッションがリクエストしたとおり。空の場合はリポジトリのデフォルトブランチ |
| `CLAUDE_RUNNER_CHECKOUT_PATH` | ワーキングツリーを配置する必要がある絶対パス |
| `CLAUDE_RUNNER_SESSION_ID` | ログと相関のための `session_...` 形式のセッション ID |
| `CLAUDE_RUNNER_SESSION_UUID` | 正規 UUID 形式の同じセッション ID |
| `CLAUDE_RUNNER_API_BASE_URL` | セッションスコープの呼び出し用の Anthropic API ベース URL |
| `CLAUDE_RUNNER_CLIENT_PLATFORM` | セッションを作成したクライアント表面。`web_claude_ai`、`desktop_app`、`ios` など。セッションに記録または認識された表面がない場合は未設定 |
| `CLAUDE_CODE_SESSION_ACCESS_TOKEN` | セッションスコープの API 呼び出し用のセッションアクセストークン |
| `GIT_CONFIG_COUNT`、`GIT_CONFIG_KEY_n`、`GIT_CONFIG_VALUE_n` | フックが実行する git に対してランナーが固定する git 設定。[ライフサイクルフック内の Git 設定](#git-configuration-inside-lifecycle-hooks)で説明しています。Claude Code v2.1.280 以降が必要 |

スクリプトは `CLAUDE_RUNNER_CHECKOUT_PATH` にワーキングツリーを残し、リクエストされたリビジョンでチェックアウトする必要があります。デタッチド HEAD は問題ありません。ランナーはその上にセッションのワーキングブランチを作成します。ランナーはその後、パスに `.git` が含まれていることを確認します。フックが Perforce やアンパックされたタールボールなどの非 git ソースを具体化する場合は、ランナーの環境で `CLAUDE_RUNNER_SKIP_GIT_VERIFY=1` を設定して、そのチェックをスキップしてください。ワーキングブランチの作成と結果のプッシュなどの git ベースのフローには git チェックアウトが必要なため、非 git ツリーから結果をエクスポートするには [`post-session` フック](#post-session)を使用してください。

ランナーは git 認証情報をフックに渡しません。代わりに、セッションの ID からセッションごとのクローン認証情報を発行します。`CLAUDE_RUNNER_API_BASE_URL` の下の JWKS エンドポイントに対して標準 JWT ライブラリを使用して `CLAUDE_CODE_SESSION_ACCESS_TOKEN` を検証します。これは [Verify the token from your service](/docs/ja/self-hosted-environments-identity#verify-the-token-from-your-service) で説明されています。その後、認証情報サービスがトークンの `act` クレーム内の ID に対して短期間のクローン認証情報を発行します。`CLAUDE_RUNNER_CLAUDE_BIN` はチェックアウトフック環境では設定されていないため、`decode-token` サブコマンドはここでは利用できません。SSH エージェント、認証情報ヘルパー、`.netrc` など、ホストが既に持っている git 認証にフォールバックすることもオプションです。

フックが 0 以外で終了するか、0 で終了しても使用可能なチェックアウトを残さない場合、ランナーが実行する処理はリポジトリによって異なります。

* **セッションが結果をプッシュするリポジトリ**：ランナーはセッションを失敗させ、0 以外の終了時にスクリプトの stderr の末尾をユーザーに表示します。
* **セッションが読み取り専用のリポジトリ**（実行中のセッションに追加されたリポジトリなど）：ランナーは失敗の詳細を含む `[runner:warn]` 行をログに記録し、`Skipped` ステップをセッションにポストし、フックがチェックアウトパスに残したものを削除し、残りのリポジトリで続行します。ランナーがパスをすぐに削除できない場合、セッション終了時に削除を再試行します。スキップによってセッションにリポジトリがまったくなくなった場合、ランナーはとにかくセッションを失敗させます。

v2.1.228 より前は、ランナーはどのリポジトリでもフック失敗時にセッションを失敗させていたため、フックが提供できない読み取り専用リポジトリは、セッションが再開される新しいランナーのたびに再度セッションを失敗させていました。

ランナーはセッション終了後、チェックアウトパスを削除します。

<h3 id="post-session">
  post-session
</h3>

セッションごとに 1 回実行され、Claude Code 子プロセスが終了した後、ランナーがワークスペースを破棄する前に実行されます。このフックはコミットされていない作業を保存する唯一のチャンスです。`--capacity` が 1 より大きい場合、ランナーはフックが返された直後にセッションごとのワーキングツリーを削除し、`--capacity 1` の場合、再利用される[正規クローン](/docs/ja/self-hosted-environments-deploy#reuse-a-pre-warmed-checkout)は次のセッションが開始されるときにハードリセットされるため、コミットされていない追跡変更はどちらのパスでも保存されません。典型的な用途は、コミットされていない変更のスナップショットブランチをプッシュしたり、ログをアーカイブしたり、セッション終了イベントを独自のシステムに発行したりすることです。

フックは子プロセスがスポーンされたセッション終了のたびに発火します。原因は何でもかまいません。以下の `CLAUDE_RUNNER_EXIT_REASON` 値がケースを列挙しています。ランナーが VM プリエンプションや停電などで突然終了する場合は発火できません。突然の終了に対する保証が必要な場合は、Claude Code `PostToolUse` フックを使用してセッション内から定期的にスナップショットを取得してください。ランナーは以下を設定します。

| 変数 | 説明 |
| :- | :- |
| `CLAUDE_RUNNER_SESSION_ID` | `session_...` 形式のセッション ID |
| `CLAUDE_RUNNER_SESSION_UUID` | 正規 UUID 形式の同じセッション ID |
| `CLAUDE_RUNNER_EXIT_REASON` | セッションがどのように終了したか。テーブル下の値を参照 |
| `CLAUDE_RUNNER_WORKSPACE_PATHS` | セッションのワーキングツリーのコロン区切り絶対パス。ゼロリポジトリセッションの場合は空 |
| `CLAUDE_RUNNER_DEBUG_LOG_PATH` | セッションのデバッグログへのパス。フック実行中もディスク上に存在 |
| `CLAUDE_RUNNER_API_BASE_URL` | セッションスコープの呼び出し用の Anthropic API ベース URL |
| `CLAUDE_RUNNER_CLIENT_PLATFORM` | セッションを作成したクライアント表面。`web_claude_ai`、`desktop_app`、`ios` など。セッションに記録または認識された表面がない場合は未設定。Claude Code v2.1.229 以降が必要 |
| `CLAUDE_CODE_SESSION_ACCESS_TOKEN` | セッションスコープの API 呼び出し用のセッションアクセストークン |
| `GIT_CONFIG_COUNT`、`GIT_CONFIG_KEY_n`、`GIT_CONFIG_VALUE_n` | フックが実行する git に対してランナーが固定する git 設定。[ライフサイクルフック内の Git 設定](#git-configuration-inside-lifecycle-hooks)で説明しています。Claude Code v2.1.280 以降が必要 |

`CLAUDE_RUNNER_EXIT_REASON` は 4 つの値のいずれかを取ります。

* `completed`：セッションがクリーンに終了しました。Claude Code プロセスが正常に終了したか、セッションがまだ実行中に削除またはアーカイブされました。
* `failed`：Claude Code プロセスがクラッシュしたか、開始後にセットアップが失敗しました。
* `interrupted`：ランナーがセッションを停止しました。セッションをリリースしてスロットを解放したか、セッションがスタートアップでタイムアウトしたか、サーバーがセッションをこのランナーから移動したか、ランナーがドレイン中であったか、セッションが [`--kill-session-after-min`](/docs/ja/self-hosted-environments-reference#runner-cli-flags) 制限を超えました。
* `abandoned`：別のランナーが要求したセッション用に予約されています。フックは現在その場合には発火しません。

[セッションライフサイクルカウンター](/docs/ja/self-hosted-environments-reference#session-lifecycle-counter-semantics)は、リリース、スタートアップタイムアウト、サーバー移動を `interrupted` ではなく `completed` としてカウントします。ランナーがスロットをクリーンに返したためです。フック受信とカウンターを比較する場合、その違いを予期してください。

フックの終了ステータスはセッション結果に影響しません。失敗はログに記録され、無視されます。ランナーはセッション終了を含むランナーシャットダウンのたびに、`--post-session-hook-timeout-sec`（デフォルトは 60 秒）まで待機します。この例はコミットされていない作業をレスキューブランチに保存します。

```bash theme={null}
#!/usr/bin/env bash
set -u
IFS=':'
# -c overrides beat repo-local settings, blocking session-written fsmonitor,
# hook-path, and gpg-program config from executing code with the hook's
# privileges. -c commit.gpgsign=false also leaves these rescue commits
# unsigned under --configure-git.
# Repo-local credential.helper and pushurl still apply, and on a runner
# before v2.1.280 so does core.sshCommand; if the hook holds credentials
# the session didn't, see the note below the script.
g() { git -c core.fsmonitor=false -c core.hooksPath=/dev/null \
        -c commit.gpgsign=false "$@"; }
for ws in $CLAUDE_RUNNER_WORKSPACE_PATHS; do
  cd "$ws" 2>/dev/null || continue
  [ -z "$(g status --porcelain 2>/dev/null)" ] && continue
  g add -A
  g commit -q -m "runner snapshot: $CLAUDE_RUNNER_SESSION_ID ($CLAUDE_RUNNER_EXIT_REASON)" || continue
  g push -q origin "HEAD:refs/heads/rescue/$CLAUDE_RUNNER_SESSION_ID" || true
done
```

フックは、ランナーホスト上の独自の環境で利用可能な git 認証情報を使用してプッシュします。[イメージに認証情報がない姿勢](/docs/ja/self-hosted-environments-deploy#configure-git)の下では、組み込みクローンが Anthropic git プロキシを通過する場合を含めて、認証情報がないため、フック内で短期間のプッシュ認証情報を発行します。フックが受け取る `CLAUDE_CODE_SESSION_ACCESS_TOKEN` のセッショントークンを独自のトークンサービスと交換し、[Verify session identity](/docs/ja/self-hosted-environments-identity) が説明するように検証します。フックがセッションが持たなかった認証情報を保持している場合は、`origin` をオペレーター提供の URL に置き換え、`-c credential.helper=` と独自のヘルパーを渡します。セッションが書き込んだ設定が引き続き影響し得る内容については、[ライフサイクルフック内の Git 設定](#git-configuration-inside-lifecycle-hooks)で説明しています。

<h4 id="hook-timing-when-the-runner-releases-a-session">
  ランナーがセッションをリリースするときのフックタイミング
</h4>

リリースされたセッションは別のランナーで再開できます。v2.1.236 以降のランナーでは、セッションがリリース時に何をしていたかによって、このフックが終了する前に再開できるかどうかが決まります。

* **ターンの後にアイドル状態、またはスタートアップでタイムアウト**：ランナーは子プロセスを停止し、このフックを完了まで実行します。その後でのみセッションをリリースします。フック実行中に送信されたユーザーメッセージは、フックが終了する前に別のランナーでセッションを再開できません。
* **ユーザーが権限プロンプトなどのプロンプトに答えるのを待機中**：ランナーは最初にセッションをリリースし、その後このフックを実行します。フック実行中に送信されたユーザーメッセージは、フックが終了する前に別のランナーでセッションを再開できます。

これはランナーがセッションをリリースするたびに適用されます。アイドルタイムアウト時、[`--retire-at`](/docs/ja/self-hosted-environments-reference#runner-cli-flags) 時、および v2.1.260 以降のランナーでは、セッションの [`--kill-session-after-min`](/docs/ja/self-hosted-environments-reference#runner-cli-flags) 制限時。ターンが終了し、バックグラウンドタスクのみを保持するセッションはここではアイドル状態としてカウントされます。v2.1.236 より前は、ランナーは両方のケースで最初にセッションをリリースし、その後このフックを実行していました。

`SIGTERM` ドレイン中、ランナーはフックが終了するまでセッションリースを保持します。[Shutdown timing](/docs/ja/self-hosted-environments-deploy#shutdown-timing) を参照してください。

<h3 id="git-configuration-inside-lifecycle-hooks">
  ライフサイクルフック内の Git 設定
</h3>

`checkout` フックと `post-session` フックは、環境にセッションのアクセストークンを持った状態で実行され、これらが実行する git は、`~/.gitconfig` やチェックアウトの `.git/config` など、セッションが書き込める設定ファイルを読み取ります。どちらかのフックを実行する前に、ランナーは以下を含む git 設定を、`GIT_CONFIG_COUNT`/`GIT_CONFIG_KEY_n`/`GIT_CONFIG_VALUE_n` のペアおよび git 環境変数として、フックの環境に設定します。git はこれらをすべての設定ファイルより優先し、これらはフックが実行する git にのみ適用され、セッション自身の git には適用されません。起動時に、ランナーは有効なフックパス、許可されたプロトコル、gpg プログラム、署名モードを示す `[runner:git] lifecycle hooks:` 行を出力します。Claude Code v2.1.280 以降が必要です。

* **Git フック**：値を指定しない限り、`core.hooksPath` は `/dev/null` になるため、git はリポジトリの `.git/hooks` 内のフックと、`~/.gitconfig` が指定するフックディレクトリをスキップします。値を指定するには、ランナーの環境で `core.hooksPath` を `GIT_CONFIG_KEY_n`/`GIT_CONFIG_VALUE_n` ペアとしてエクスポートします。ランナーはシステムの git 設定からも `core.hooksPath` を読み取りますが、ランナーのユーザーがそのファイル、それが指定するディレクトリ、またはその中のフックファイルに書き込めない場合にのみ使用します。ランナーが値を無視した場合、起動時の `[runner:warn]` 行にその値と理由が示されます。
* **ファイルシステムモニター**：`core.fsmonitor` は空であるため、フック内の git は設定ファイルが指定するモニタープログラムを実行しません。
* **リモートプロトコル**：`GIT_ALLOW_PROTOCOL` は `https:http:ssh` です。ローカルパス、`file://` URL、または `git://` URL を使用するクローン、フェッチ、プッシュは、`fatal: transport 'file' not allowed` または `fatal: transport 'git' not allowed` で失敗します。
* **SSH コマンドと認証情報プロンプト**：フック内の git は、設定ファイルの `core.sshCommand` と `core.askPass` を無視します。独自の SSH コマンドを使用するには、ランナーの環境で `GIT_SSH_COMMAND` を設定します。認証情報プロンプトプログラムを使用するには、同じくランナーの環境で `GIT_ASKPASS` を設定します。セッションはランナーの環境を継承するため、両方の変数はセッション自身の git にも渡ります。どちらにも認証情報を入れないでください。
* **gpg プログラム**：`gpg.program`、`gpg.openpgp.program`、`gpg.x509.program`、`gpg.ssh.program` はランナーが設定するパスであり、設定ファイルの値が使われることはありません。
* **コミット署名**：[`--configure-git`](/docs/ja/self-hosted-environments-deploy#let-the-runner-configure-git) を使用すると、フックから作成したコミットはセッションとして署名されます。このフラグがない場合、`commit.gpgsign` と `tag.gpgsign` は `false` です。

これらの設定のいずれかを変更するには、ランナーの環境またはフック内の `git -c` オプションを使用します。

* **設定ペア**：ランナーの環境でエクスポートした `GIT_CONFIG_KEY_n`/`GIT_CONFIG_VALUE_n` ペアは、同じキーに対するランナーの値を置き換えます。ペアには `0` から番号を付け、`GIT_CONFIG_COUNT` をペアの数に設定します。カウントが示す最後のペアが欠けている場合、ランナーは指定したすべてのペアを無視し、起動時に `[runner:warn]` 行をログに記録します。
* **Git 環境変数**：ランナーは、`GIT_ALLOW_PROTOCOL`、`GIT_SSH_COMMAND`、`GIT_ASKPASS` を、ランナーの環境で設定したとおりのまま残します。
* **`git -c` オプション**：フック内の `git -c` オプションは、ランナーのものか自分で設定したものかにかかわらず、`GIT_CONFIG_KEY_n` ペアを上書きします。git があらゆる設定より先に読み取る `GIT_ALLOW_PROTOCOL`、`GIT_SSH_COMMAND`、`GIT_ASKPASS` は変更しません。

フック内の git は、認証情報ヘルパー、`url.*.insteadOf` による書き換え、フィルタードライバーなど、ランナーが設定しないすべての設定項目を、セッションが書き込めるものを含むすべての設定ファイルから引き続き読み取ります。これらのファイルのいずれかで指定された認証情報ヘルパーやフィルタードライバーは、フックの権限でプログラムとして実行され、これらのファイル内の設定によって、コマンドラインで渡した URL へのプッシュを含め、フックからのプッシュの送信先が変わる可能性もあります。

v2.1.280 より前は、ランナーはこれらの設定をいずれも設定しておらず、`--configure-git` の下では、フックが `-c commit.gpgsign=false` を渡さない限り、フックから作成したコミットは失敗していました。

<h3 id="command">
  command
</h3>

セッションごとに 1 回実行され、チェックアウト後、組み込み子スポーン の代わりになります。フックは [ラッパースクリプト](#wrapper-scripts)と同じ環境を受け取り、同じ方法で `"$CLAUDE_RUNNER_CLAUDE_BIN"` に `exec` する必要があります。`command` フックを使用して、すべてのカスタマイズをフックディレクトリに保持します。ラッパーが別の場所にある場合は `--exec-path` を使用します。`--exec-path` も設定されている場合、フラグが優先され、`command` フックは無視されます。

PATH で解決された `claude` ではなく、ランナー自身のバイナリに常に `exec` してください。そうしないと、[バージョンピンニング](/docs/ja/self-hosted-environments-deploy#pin-the-version)を無効にしてしまいます。

<h2 id="on-demand-runners">
  オンデマンドランナー
</h2>

固定フリートを実行する代わりに、セッションごとに 1 つのランナーをブートできます。オーケストレーターは別の、ステートレスなサブコマンドで、Anthropic にスポーン要求をポーリングします。利用可能なランナーがないキューに入っているセッションごとに 1 つの要求をポーリングし、各要求に対して `spawn-runner` フックを実行します。フックは、ワークロードをプラットフォームに送信します。Kubernetes Job、EC2 インスタンス、Nomad dispatch などです。

オンデマンドランナーは認証情報の衛生状態を改善します。固定フリートでは、環境シークレットはすべてのランナーホストに存在し、これはユーザーセッションを実行するのと同じホストです。オーケストレーターを使用すると、環境シークレットはオーケストレーターホストにのみ存在し、ユーザーコードは実行されません。各スポーンされたランナーは、正確に 1 つのランナーを登録してから期限切れになる単一用途の作業指示を受け取ります。

オーケストレーターを開始するには、環境シークレットと実行可能な `spawn-runner` スクリプトを含むフックディレクトリを渡します。

```bash theme={null}
claude self-hosted-runner orchestrator \
  --environment-secret-file /etc/claude/environment-secret \
  --hooks-dir /etc/claude/hooks
```

オーケストレーターはポーリング間で状態を保持しないため、可用性のために同じ環境に対して 2 つ以上のレプリカを実行できます。各スポーン要求は、サーバー側で正確に 1 つのレプリカによって要求されます。すべてのレプリカは同じ `--expected-spawn-seconds` 値を使用する必要があります。[フックコントラクト](#the-spawn-runner-hook)を参照してください。

<h3 id="the-spawn-runner-hook">
  spawn-runner フック
</h3>

オーケストレーターは、スポーン要求ごとに 1 回 `${hooks-dir}/spawn-runner` を実行します。フックは非同期でワークを送信する必要があり、ランナーのブートを待たずに、`--hook-timeout`（デフォルトは 60 秒）以内に戻る必要があります。フックは以下を受け取ります。

| 変数 | 説明 |
| :- | :- |
| `CLAUDE_RUNNER_WORK_ORDER_FILE` | 新しいランナーが登録する署名済みワークオーダー JWT を含む一時ファイルへのパス。フック終了後に削除されます。ファイルの内容をログに記録しないでください。 |
| `CLAUDE_RUNNER_ORDER_ID` | 不透明なべき等性キー。スポーン要求ごとに一意で、Kubernetes リソース名に対して安全です。プロビジョナーの重複排除キーとしてのみ使用してください。 |
| `CLAUDE_RUNNER_SESSION_ID` | この要求が対象とするセッション。セッションの再要求のたびに繰り返されるため、ログとルーティングに使用し、重複排除キーとしては使用しないでください。[`--min-idle`](/docs/ja/self-hosted-environments-reference#orchestrator-cli-flags) が設定されている場合、事前ウォーミング要求（特定のセッションの前にスタンバイランナーをブート）では空です。変数が設定されていると仮定しないでください。 |
| `CLAUDE_RUNNER_SESSION_UUID` | 正規 UUID 形式の同じセッション ID。事前ウォーミング要求では空です。 |
| `CLAUDE_RUNNER_ATTEMPT` | このセッションが持つスポーン要求の数。事前ウォーミング要求では 0 です。 |
| `CLAUDE_RUNNER_ORDER_SERVER_TIME` | ポーリング応答の HTTP `Date` ヘッダーからのサーバー時刻。フックがワークオーダー JWT の `exp` を検証する場合、ローカルクロックの代わりにこの値と比較して、スキューを許容してください。ゲートウェイがヘッダーを省略した場合は空です。 |
| `CLAUDE_RUNNER_POOL_ID` | 新しいランナーが参加する環境の ID。`ccpool_...` 形式です。 |
| `CLAUDE_RUNNER_ACCOUNT_ID` | セッションをエンキューしたアカウントのタグ付き ID。アカウントごとのルーティング、クォータ、またはチャージバック用です。利用できない場合は空で、Claude Tag チャネルセッションでは常に空です。どのアカウントもこれらのセッションをエンキューしません。 |
| `CLAUDE_RUNNER_ACCOUNT_EMAIL` | セッションをエンキューしたアカウントのメール。利用できない場合は空です。メールを個人識別情報として扱い、ログに記録しないでください。 |
| `CLAUDE_RUNNER_PRIMARY_REPO_URL` | セッションの最初の git ソースの URL。そのリポジトリが事前ウォーミングされたランナーへのルーティング用です。セッションに git ソースがない場合は空です。 |
| `CLAUDE_RUNNER_PRIMARY_REPO_REVISION` | セッションの最初の git ソースのリビジョン。ブランチ、SHA、またはタグです。指定されていない場合は空です。 |
| `CLAUDE_RUNNER_REPO_SOURCES` | セッションのすべての git ソースの `{url, revision}` の JSON 配列。セカンダリリポジトリでルーティングするフック用です。ソースがない場合は空です。 |
| `CLAUDE_RUNNER_CORRELATION_ID` | セッション作成時に提供された相関 ID。フックがこのワークオーダーをセッションを作成した要求にマップできるようにエコーバックされます。セッションに相関 ID がない場合は空です。 |
| `CLAUDE_RUNNER_CLIENT_PLATFORM` | セッションを作成したクライアント表面。`web_claude_ai`、`desktop_app`、`ios`、`scheduled_trigger` など。採用分析用です。セッションに記録または認識された表面がない場合は未設定で、事前ウォーミング要求の場合も未設定です。`[ -n "${CLAUDE_RUNNER_CLIENT_PLATFORM:-}" ]` で確認してください。これは `set -u` の下で安全なままです。 |

スポーンされたランナーは、環境シークレットの代わりにワークオーダーで登録します。

* **ワークオーダーで開始します**。[`--environment-secret-file`](/docs/ja/self-hosted-environments-reference#runner-cli-flags) をワークオーダー JWT を含むファイルに指定するか、`SELF_HOSTED_RUNNER_ENVIRONMENT_SECRET` を JWT 値に設定します。
* **フック終了前に JWT をコピーします**。オーケストレーターはフック終了後にワークオーダーファイルを削除するため、JWT を送信するワークロード（スポーンされたジョブの Kubernetes Secret など）にコピーし、ファイルパスを渡さないでください。
* **スポーンされたランナーで `--capacity 1` を使用します**。セッションバウンドワークオーダーは正確に 1 つのランナーをそのセッションにバウンドするため、より高い容量を使用するとスロットが追加されますが、これらのスロットは作業を受け取らず、ランナーはスタートアップで警告をログに記録します。
* **事前ウォーミングワークオーダーはアンバウンドで登録します**。スタンバイランナーはセッションにバウンドされず、固定フリートランナーのようにキューに入った作業を要求します。

コントラクトには 4 つのプロビジョナー非依存ルールがあります。

1. **`CLAUDE_RUNNER_ORDER_ID` でべき等です。** 同じ要求の再配信は、最大 1 つのランナーをスポーンする必要があります。オーダー ID から決定論的なリソース名を導出し、プラットフォームに重複を拒否させてください。`CLAUDE_RUNNER_SESSION_ID` をキーとして使用しないでください。セッションの再要求のたびに同じセッション ID が新しいオーダー ID で実行されるため、セッション ID で名前付けまたは重複排除されたワークロードは、そのセッションに対して 1 回作成され、二度と作成されません。
2. **ワークロードを再試行しないでください。** 1 つのオーダー ID は、最大 1 つの作成されたワークロードを意味します。ランナーが登録されない場合、Anthropic は `--expected-spawn-seconds` 後に新しいオーダー ID で再要求します。
3. **終了コードコントラクトを使用します。** 終了 0 は送信されたことを意味します。終了 1 は再試行可能な失敗を意味します。セッションはバックオフして再度提供されます。終了 2 以上は再試行不可を意味します。セッションは、[Owner](/docs/ja/cloud-environments#organization-shared-environments) が環境の **Activity** タブでそれに対して **Retry** を選択するまで、再度スポーンされることがブロックされます。ゼロ以外の終了時に、フックの stderr の末尾がそこに失敗理由として表示されるため、実行可能なエラーを stderr に書き込み、シークレットは決して書き込まないでください。事前ウォーミング要求の場合、失敗するセッションはありません。オーケストレーターはゼロ以外の終了をローカルでのみログに記録し、サーバーはリース後にスポーンを再要求します。
4. **`--expected-spawn-seconds` を少なくとも p99 ブート時間に設定します。** これはサーバー側のリースです。すべてのオーケストレーターレプリカは同じ値を使用する必要があります。

フックが stdout または stderr に書き込むすべてのものは、認証情報が自動的に削除されたオーケストレーターのログに表示されます。セッションがキューに入ったままの場合、オーケストレーターの `/healthz` ボディをチェックしてキュー数を確認し、[**Cloud environments** 管理ページ](https://claude.ai/admin-settings/cloud-environments)で環境の **Activity** タブを開きます。失敗したセッションをそこで展開してスポーンエラーを確認し、**Retry** を選択して再要求してください。

セッションが **Activity** タブにスポーンエラーなしでキューに入ったままの場合、フックがセッション ID でキーになっていることを意味する可能性があります。確認するには、プラットフォームがそのセッションの最初のスポーン要求のワークロードを持っているかどうか、および再要求のワークロードを持っていないかどうかを確認してください。その場合は、ワークロードを `CLAUDE_RUNNER_ORDER_ID` でキーにしてください。

<h2 id="send-model-requests-to-bedrock-or-agent-platform">
  モデルリクエストを Bedrock または Agent Platform に送信する
</h2>

組織でモデルリクエストを自社の AWS または Google Cloud アカウント経由にする必要がある場合は、ランナーを [Amazon Bedrock](/docs/ja/amazon-bedrock) または [Google Cloud の Agent Platform（旧 Vertex AI）](/docs/ja/google-vertex-ai) 向けに設定します。これにより、そのランナーが開始するすべてのセッションが、自社のクラウド認証情報を使用して自社のクラウドアカウント内のモデルを呼び出します。この設定を行わない場合、セッションはモデルリクエストを Anthropic API に送信します。

ランナーは引き続き Anthropic にセッションをポーリングし、各セッションは引き続きイベントストリームを `api.anthropic.com` に送信します。イベントストリームにはプロンプト、応答、ツールの結果が含まれます。[利用条件と制限事項](/docs/ja/self-hosted-environments#availability-and-limitations)に記載されているプランの要件と Zero Data Retention の除外も引き続き適用されます。

セッションはランナーではなく環境にルーティングされ、再キューされたセッションや再開されたセッションは別のランナーで実行される場合があります。環境内のすべてのランナーを同じ方法で設定してください。開始する前に、[これらのプロバイダーでの違い](#what-differs-from-sessions-on-the-anthropic-api)を確認してください。

<Steps>
  <Step title="クラウドアカウントと egress ルールを準備する">
    モデルへのアクセス、範囲を限定したポリシーまたはロール、ネットワークアクセスを設定します。

    * **Amazon Bedrock**：[ユースケースの詳細を送信](/docs/ja/amazon-bedrock#1-submit-use-case-details)してから、[IAM 設定](/docs/ja/amazon-bedrock#iam-configuration)に従ってポリシーを作成し、`bedrock:InvokeModel` と `bedrock:InvokeModelWithResponseStream` を、セッションが使用する推論プロファイルとその背後にある基盤モデルに限定します
    * **Agent Platform**：[API を有効化](/docs/ja/google-vertex-ai#1-enable-agent-platform-api)し、[モデルへのアクセスをリクエスト](/docs/ja/google-vertex-ai#2-request-model-access)してから、[IAM 設定](/docs/ja/google-vertex-ai#iam-configuration)で説明されているカスタムロールを、`aiplatform.endpoints.predict` のみを含めて作成します
    * **Egress**：egress ルールでプロバイダーのエンドポイントへの通信を許可します。[ネットワーク要件](/docs/ja/self-hosted-environments-deploy#network-requirements)を参照してください。セッションがこれらに到達できない場合、Claude Code はセッションにエラーが表示されるまで何時間も再試行を続けることがあります。
  </Step>

  <Step title="セッションに範囲を限定した認証情報を与える">
    ステップ 1 のポリシーまたはロールを、それ以外に何もできない ID にアタッチします。Claude Code が受け付ける方法については、[AWS 認証情報を設定する](/docs/ja/amazon-bedrock#2-configure-aws-credentials)と [GCP 認証情報を設定する](/docs/ja/google-vertex-ai#3-configure-gcp-credentials)を参照してください。

    <Warning>
      プロンプトインジェクションを含め、セッション内でコードを実行させることができる人は誰でも、認証情報が有効である限り、これらの認証情報をユーザーの費用負担で使用できます。Claude Code はセッション内で実行されるため、モデルの呼び出しに使用する認証情報はセッション内で読み取り可能である必要があります。

      Claude が実行するシェルコマンド、[Claude Code フック](/docs/ja/hooks)、stdio MCP サーバーはセッションの環境を継承し、Claude Code と同じユーザーとして実行されます。その結果、これらは認証情報の変数や認証情報ファイルを読み取ることができます。

      [デプロイを強化](/docs/ja/self-hosted-environments-deploy#harden-your-deployment)すると、ホストの認証情報をセッションから遠ざけることはできますが、この認証情報を遠ざけることはできません。その背後にある ID には、ステップ 1 のポリシーまたはロール以外の権限を与えないでください。
    </Warning>

    選択した方法を、次のランナーの動作と照らし合わせて確認してください。

    * **メタデータエンドポイント**：セッションに対して[クラウドメタデータエンドポイント](/docs/ja/self-hosted-environments-deploy#harden-your-deployment)を完全に拒否すると、インスタンスプロファイルなど、そこから提供される認証情報も Claude Code に届きません。Amazon EKS の IAM Roles for Service Accounts（IRSA）や Workload Identity Federation の認証情報ファイルなど、ファイルベースの Web ID はこれに依存しません。
    * **更新**：セッションは認証情報よりも長く存続する場合があるため、ファイルベースの Web ID など、自動的に更新される方法を使用してください
    * **ラッパースクリプト**：ランナーは[ラッパースクリプト](#provision-credentials-scoped-to-the-session-creator)をセッションごとに 1 回起動するため、そこでエクスポートした認証情報は更新されません。Claude Code は環境から AWS 認証情報を読み取るため、ラッパーが他の作業のためにすでに AWS 認証情報をエクスポートしている場合、Claude Code はそれを使用してモデルリクエストに署名する可能性があります。
  </Step>

  <Step title="ランナーの環境に 1 つのプロバイダーの変数を設定する">
    コンテナ仕様やサービスユニットなど、ランナーの他の環境変数を設定している場所に、1 つのプロバイダーの変数のみを設定してから、ランナーを再起動します。例ではシェルのエクスポートとして示しています。[オンデマンドランナー](#on-demand-runners)の場合は、`spawn-runner` フックが起動するワークロードに設定します。

    これらのランナーは [`--confine-repo-settings enforce`](/docs/ja/self-hosted-environments-deploy#harden-your-deployment) を指定して起動してください。このモードでは、コミットされた設定が警告対象となったリポジトリでのセッションを拒否するため、まずデフォルトの `warn` モードで実行し、ログに記録された内容を解消してください。

    <Tabs>
      <Tab title="Amazon Bedrock">
        リージョンを自分のものに置き換えます。

        ```bash theme={null}
        export CLAUDE_CODE_USE_BEDROCK=1
        export AWS_REGION=us-east-1
        ```

        Claude Code がリージョンを解決する方法については、[Claude Code を設定する](/docs/ja/amazon-bedrock#3-configure-claude-code)を参照してください。Claude Code がリージョンに応じて使用する推論プロファイルのプレフィックスについては、[クロスリージョン推論プロファイルのプレフィックス](/docs/ja/amazon-bedrock#cross-region-inference-profile-prefixes)を参照してください。
      </Tab>

      <Tab title="Google Cloud の Agent Platform">
        リージョンとプロジェクト ID を自分のものに置き換えます。

        ```bash theme={null}
        export CLAUDE_CODE_USE_VERTEX=1
        export CLOUD_ML_REGION=global
        export ANTHROPIC_VERTEX_PROJECT_ID=YOUR-PROJECT-ID
        ```

        リージョンの選択については、[リージョンの設定](/docs/ja/google-vertex-ai#region-configuration)を参照してください。
      </Tab>
    </Tabs>
  </Step>

  <Step title="変数がセッションに届いたことを確認する">
    ホスト上の自分のシェルは別のプロセスであるため、セッション内から確認します。環境でセッションを開始し、Claude に次のコマンドを実行するよう依頼します。

    ```bash theme={null}
    env | grep -E 'CLAUDE_CODE_USE_(BEDROCK|VERTEX)'
    ```

    `CLAUDE_CODE_USE_BEDROCK` または `CLAUDE_CODE_USE_VERTEX` を `1` に設定する行が表示されれば、変数はセッションに届いています。両方が表示された場合、Claude Code は Amazon Bedrock を使用します。何も出力されない場合は、どちらも届いていません。

    このコマンドが示すのは設定であり、トラフィックではありません。リクエスト自体を確認するには、クラウドアカウント自体のメトリクスまたはリクエストログで探してください。最初のメッセージが失敗した場合は、[Amazon Bedrock](/docs/ja/amazon-bedrock#troubleshooting) または [Agent Platform](/docs/ja/google-vertex-ai#troubleshooting) のトラブルシューティングを参照してください。
  </Step>
</Steps>

<h3 id="what-differs-from-sessions-on-the-anthropic-api">
  Anthropic API 上のセッションとの違い
</h3>

モデルリクエストを Amazon Bedrock または Google Cloud の Agent Platform に送信するセッションは、Anthropic API 上のセッションと次の点で異なります。

* **claude.ai からのポリシー**：[サーバー管理設定](/docs/ja/server-managed-settings)はこれらのセッションに届きません。Owner が Claude Code の管理設定で設定する組織ポリシーも届かないため、Claude Code はセッション内でそれらを適用しません。依存するルールは、ランナーイメージの[管理設定ファイル](/docs/ja/managed-settings#delivery-mechanisms)に記述してください。
* **ファイル**：claude.ai やモバイルアプリ、デスクトップアプリでセッションに添付されたファイルはセッションに届かず、Claude は [`SendUserFile` ツール](/docs/ja/tools-reference)でファイルを送り返すこともできません。代わりに、入力ファイルはリポジトリまたはランナー上に配置してください。
* **モデルの選択**：Anthropic のコントロールプレーンが各セッションのモデルを送信し、モデルが指定されずにセッションが開始された場合、Claude Code はそのプロバイダーのデフォルトを使用します。ランナーは、セッションに渡す環境から `ANTHROPIC_MODEL` と `ANTHROPIC_DEFAULT_MODEL` を削除します。プロバイダーのページの例では `ANTHROPIC_MODEL` を設定していますが、ランナーの環境ではどちらの変数も効果がありません。[Amazon Bedrock](/docs/ja/amazon-bedrock#4-pin-model-versions) と [Agent Platform](/docs/ja/google-vertex-ai#5-pin-model-versions) の「モデルバージョンを固定する」に記載されているファミリーごとの変数はセッションに届きます。これらは `opus` などのエイリアスの解決先を決定するものであり、完全なモデル ID の解決先を決定するものではありません。
* **アカウントで提供されていないモデル**：セッションが、モデル名を示すエラーでメッセージの処理に失敗する場合があります。開発者が選択できるモデル、「モデルバージョンを固定する」で説明されているバックグラウンドモデル、[auto モード](/docs/ja/permission-modes#enable-auto-mode-on-bedrock-agent-platform-or-foundry)が使用する分類器モデルを有効にしてください。Amazon Bedrock では、それぞれをポリシーで許可してください。
* **Web 検索と fast mode**：[Web 検索](/docs/ja/tools-reference#websearch-tool-behavior)は Amazon Bedrock では利用できず、[fast mode](/docs/ja/fast-mode) はどちらのプロバイダーでも利用できません。プロバイダーによって異なるその他の機能については、[プロバイダーによって異なる CLI 機能](/docs/ja/feature-availability#cli-capabilities-that-vary-by-provider)を参照してください。

<h2 id="mcp-servers">
  MCP サーバー
</h2>

[MCP サーバー](/docs/ja/mcp)をすべてのセッションで利用できるようにするには、デスクトップへのインストール時と同じ `claude mcp add` コマンドを使って、イメージのビルド時に追加します。ランナーがコンテナではなくベアプロセスの場合は、ホスト上でランナーのユーザーとして同じコマンドを実行してから、ランナーを再起動します。ランナーはホストの設定を起動時に一度だけ読み込むためです。`--scope user` フラグは必須です。デフォルトのローカルスコープはディレクトリごとのキーの下に書き込みますが、ランナーはこのキーをセッションに引き継ぎません。たとえば、Dockerfile では次のようにします。

```dockerfile theme={null}
RUN claude mcp add --scope user sidecar -- /usr/local/bin/mcp-sidecar
RUN claude mcp add --scope user --transport http internal http://mcp-gateway.svc.cluster.local:8080
```

ランナーは起動時に一度だけホストの設定のスナップショットを取得します。スナップショットは、`~/.claude/` の中ではなくその隣にあるホストの `.claude.json` から `mcpServers` キーを取得し、ランナーはそのキーだけを各セッションの分離された設定に引き継ぎます。アカウントの状態とプロジェクト履歴は破棄されます。サーバーがセッションに届いたことを確認するには、その環境でセッションを開始し、Claude に MCP ツールの一覧を表示するよう依頼します。また、取得したエントリの `type` をランナーが認識できない場合、ランナーは起動時に警告をログに記録してそのエントリを破棄するため、そのサーバーがセッションに存在しない理由を確認できます。`SELF_HOSTED_RUNNER_HOST_CONFIG_DIR` が設定されている場合、ランナーは代わりにそのディレクトリから `.claude.json` を読み込むため、この変数を空のディレクトリに向けると MCP の引き継ぎも無効になります。

Claude Code は、ほかのソースからも MCP サーバーを読み込みます。

* 標準のシステムパスにあるエンタープライズスコープの[管理 MCP ファイル](/docs/ja/managed-mcp)：Linux のランナーホストでは `/etc/claude-code/managed-mcp.json`、macOS のホストでは `/Library/Application Support/ClaudeCode/managed-mcp.json` です。管理者が列挙したサーバーのみを読み込めるようにする、ロックダウンされたフリートで使用します。優先順位のルールについては、[managed-mcp.json による排他的な制御](/docs/ja/managed-mcp#exclusive-control-with-managed-mcp-json)を参照してください。このファイルがランナーホスト上にある場合、Claude Code は claude.ai のコネクタを含め、Anthropic のコントロールプレーンがセッションに配信する MCP サーバーをスキップし、セッションの子プロセスの stderr に出力される警告でそれらの名前を示します。ランナーはこの警告を `debug` ログレベルで記録します。v2.1.229 より前は、これらのセッションは起動時に `You cannot dynamically configure MCP servers when an enterprise MCP config is present` というメッセージを出して終了していました。
* ランナーホスト上の[管理設定](/docs/ja/managed-settings)にある [`managedMcpServers`](/docs/ja/settings-reference#managedmcpservers) キー：排他的な制御を行わずに HTTP および SSE サーバーを提供するため、ほかのソースからのサーバーも引き続き読み込まれます。Claude Code v2.1.259 以降が必要です。
* `<repo>/.mcp.json`：プロジェクトスコープです。このファイルをリポジトリにコミットしてください。そのサーバーはクラウドセッションで自動承認されます。複数のリポジトリを含むセッションでは、[読み込まれるのは最大 1 つのリポジトリのファイルのみです](#repository-settings-in-sessions-with-several-repositories)。

組織でコネクタ配信が有効になっている場合、Anthropic のコントロールプレーンは、claude.ai で設定したコネクタを、サーバーが提供する MCP 設定を通じて対話的に作成されたセッションに配信します。この配信は `api.anthropic.com` を経由します。[CLI からのディスパッチ](/docs/ja/self-hosted-environments-testing#run-the-test-loop)のようにプログラムで作成されたセッションには、コネクタは配信されません。そうしたセッションには、このセクションで挙げたほかのいずれかのソースを通じて MCP サーバーを提供してください。子プロセスの OAuth トークンにはコネクタを直接取得するためのスコープが含まれていないため、子プロセスが自らその取得を試みることはありません。配信はサーバー主導で行われます。

`settings.json` には MCP サーバーの定義は含まれず、設定スキーマにはトップレベルの `mcpServers` フィールドはありません。管理設定では、代わりに [`managedMcpServers`](/docs/ja/settings-reference#managedmcpservers) キーでサーバーを提供してください。

セッションはランナーの環境を継承するため、ランナーで [`ENABLE_TOOL_SEARCH`](/docs/ja/mcp#scale-with-mcp-tool-search) を設定すると、そのランナーが起動するすべてのセッションで MCP ツール検索を制御できます。値については MCP のページで説明しています。

<h3 id="turn-off-built-in-session-tools">
  組み込みのセッションツールをオフにする
</h3>

Anthropic のコントロールプレーンは、Claude Code Remote という名前の独自の MCP サーバーをクラウドセッションに接続します。Claude はこのサーバーのツールを使用して、[ルーティン](/docs/ja/routines)のスケジュール設定、ほかのクラウドセッションの開始と操作、リポジトリの追加、プルリクエストのアクティビティの追跡を行います。

サーバー全体をオフにするには、設定に[サーバーレベルの拒否ルール](/docs/ja/permissions#mcp)を追加します。コントロールプレーンは、セッションの作成方法に応じて、3 つの名前のいずれかでサーバーを登録します。Claude Code はルール内の名前を大文字と小文字も含めて完全一致で照合するため、次のように名前ごとに 1 回ずつルールを記述してください。

```json theme={null}
{
  "permissions": {
    "deny": [
      "mcp__Claude_Code_Remote",
      "mcp__claude-code-remote",
      "mcp__bf7c680d-5fdc-5ef4-b4a0-abadb619bf0a"
    ]
  }
}
```

サーバー全体を指定するルールは、サーバーに後から追加されるツールにも適用されます。1 つのツールだけをオフにして残りを維持するには、`mcp__Claude_Code_Remote__add_repo` のように、各ルールにアンダースコアを 2 つとツール名を付け加えます。ツールを削除するのではなく、サーバーの接続そのものをブロックするには、代わりに 3 つの名前を `mcp__` プレフィックスなしで [`deniedMcpServers`](/docs/ja/managed-mcp#policy-based-control-with-allowlists-and-denylists) の下に `serverName` エントリとして追加します。

ランナーを変更せずにセッションに適用するにはルールを[サーバー管理設定](/docs/ja/server-managed-settings)に、それ以外の場合はランナー上の `~/.claude/settings.json` に記述します。[モデルリクエストを Bedrock または Agent Platform に送信する](#send-model-requests-to-bedrock-or-agent-platform)ランナーでは、サーバー管理設定がそれらのセッションに届かないため、このファイルを使用してください。ランナー上の設定がセッションにどのように反映されるかについては、[権限とツールの承認](#permissions-and-tool-approval)で説明しています。

ルールが有効になったことを確認するには、その環境でセッションを開始し、Claude に MCP ツールの一覧を表示するよう依頼します。Claude Code は拒否されたツールを Claude のコンテキストから削除するため、拒否されたツールは回答に含まれません。

<h2 id="prompt-sessions-to-push-their-work">
  セッションに作業をプッシュするよう促す
</h2>

Anthropic ホストセッションは [`Stop` フック](/docs/ja/hooks#stop)（Claude Code フック。Claude が応答を終了するときに実行）を実行し、Claude にその作業をコミットしてプッシュするよう促します。ランナーはそれをインストールしません。それなしで、コミットされていない変更で終了するセッションはその作業をランナーのディスク上のみに残し、claude.ai/code の **Create PR** ボタンはブランチがリモートに存在するまで非アクティブなままです。

以下の参照実装には 2 つの部分があります。設定ブロックを `~/.claude/settings.json` にランナーホストにマージし、スクリプトを `~/.claude/hooks/stop-hook-nudge.sh` にランナーホストに保存して実行可能にします。

```json theme={null}
{
  "hooks": {
    "Stop": [
      {
        "hooks": [
          {
            "type": "command",
            "timeout": 10,
            "command": "\"$CLAUDE_CONFIG_DIR/hooks/stop-hook-nudge.sh\""
          }
        ]
      }
    ]
  }
}
```

```sh theme={null}
#!/bin/sh
# セルフホストランナー用の Stop フック参照実装。
#
# プロジェクトディレクトリにコミットされていない変更または
# プッシュされていないコミットがある場合、ターンごとに 1 回 Claude を促します。
# これにより、アイドルセッションがリリースされるときに作業が失われず、
# claude.ai/code の "Create PR" ボタンが点灯します。
#
# ランナーレベル（リポジトリ変更なし）：このファイルを
# ランナーホストの ~/.claude/hooks/ にドロップし、
# 付属の Stop フック設定ブロックを ~/.claude/settings.json にマージします。
# ランナーは両方をすべてのセッションにシードします。
# リポジトリレベルの代替：<repo>/.claude/hooks/ にコミットし、
# settings.json コマンドパスを $CLAUDE_PROJECT_DIR/.claude/hooks/ に変更します。
#
# stdin：フック JSON ペイロード（https://code.claude.com/docs/en/hooks を参照）
# stdout：{"decision":"block","reason":"..."} で促すか、何もなしで停止を許可。

# 再入力ガード：ハーネスはブロック後に Stop フックを再呼び出しするときに
# stop_hook_active=true を設定します。ターンごとに 1 回だけ促すようにベイルします。
# ハーネスはコンパクト JSON（コロン後にスペースなし）を発行します。
# このパターンはそれに依存します。スペース許容チェックが必要な場合は jq を使用します。
in=$(cat)
case "$in" in *'"stop_hook_active":true'*) exit 0 ;; esac

d="$CLAUDE_PROJECT_DIR"

# git リポジトリではない → 促すものはありません。
git -C "$d" rev-parse --git-dir >/dev/null 2>&1 || exit 0

# リモートがない → "リモートにプッシュ" は満たせません。ベイルします。
[ -z "$(git -C "$d" remote 2>/dev/null)" ] && exit 0

# コミットされていない変更（ステージ、アンステージ、または未追跡）。
# .claude/ 全体を除外します。オペレーターシード設定と CLI 書き込み
# ランタイム状態（スケジューラロック、ワークツリー、ルーチン状態）
# がそこに存在し、どちらも「モデルがプッシュする必要がある
# コミットされていない作業」ではありません。
s=$(git -C "$d" status --porcelain -- . ':(exclude).claude/' 2>/dev/null)
if [ -n "$s" ]; then
  printf '{"decision":"block","reason":"There are uncommitted changes in the repository. Please commit and push these changes to the remote branch."}'
  exit 0
fi

# プッシュされていないコミット。HEAD 上のコミット数を数えます。
# リモート追跡参照または FETCH_HEAD から到達不可。これは
# 以下に対して均一に機能します。
#   - init+fetch チェックアウト（ランナーデフォルト：FETCH_HEAD のみ存在）
#   - クローンベースのチェックアウト（origin/* が存在）
#   - ランナーデフォルト：こどもはセッションの結果ブランチで開始します。
#     ランナーはチェックアウト後にそれを作成します。
#   - デタッチされた HEAD。カスタムセットアップがそのブランチ作成をスキップする場合
# 参照ポイントがまったくない場合（フェッチされたことがない）、
# 偽陽性ではなく静かに留まります。
base=""
git -C "$d" rev-parse --verify -q FETCH_HEAD >/dev/null && base="FETCH_HEAD"
if [ -z "$base" ] && [ -z "$(git -C "$d" for-each-ref --count=1 refs/remotes/origin 2>/dev/null)" ]; then
  exit 0
fi
# shellcheck disable=SC2086  # $base は "" または "FETCH_HEAD"。意図的なワード分割
unpushed=$(git -C "$d" rev-list HEAD --not $base --remotes=origin --count 2>/dev/null) || unpushed=0
if [ "$unpushed" -gt 0 ]; then
  branch=$(git -C "$d" symbolic-ref --short -q HEAD)
  if [ -n "$branch" ]; then
    # $branch は攻撃者の影響を受けます。git-check-ref-format(1) は
    # ref 名で "`" を許可します。`\` は禁止されています（ルール 10）
    # が、安価な多層防御として同様にエスケープされます。
    # JSON メタ文字をハンドビルドペイロードに補間する前にエスケープして、
    # x","continue":false のようなブランチがハーネスが解析する
    # フック出力 JSON にキーを注入できないようにします。
    # $unpushed は安全です。上記の -gt ガードは平文整数以外を拒否します。
    branch_esc=$(printf '%s' "$branch" | sed 's/\\/\\\\/g; s/"/\\"/g')
    printf '{"decision":"block","reason":"There are %s unpushed commit(s) on branch '\''%s'\''. Please push these changes to the remote repository."}' "$unpushed" "$branch_esc"
  else
    printf '{"decision":"block","reason":"There are %s unpushed commit(s) on a detached HEAD. Please create a branch and push it to the remote repository."}' "$unpushed"
  fi
  exit 0
fi

exit 0
```

フックはセッション終了前に Claude にコミットしてプッシュするよう促し、ディレクトリが git リポジトリではないか、リモートがない場合は静かに留まります。複数のリポジトリを含むセッションについては、[`$CLAUDE_PROJECT_DIR` が指すもの](#repository-settings-in-sessions-with-several-repositories)を参照してください。

<h2 id="permissions-and-tool-approval">
  権限とツール承認
</h2>

セルフホストセッションには接続されたターミナルがないため、未回答の権限プロンプトはユーザーが UI で応答するまでターンを停止します。Anthropic のコントロールプレーンは各セッションのツールリストと権限ルールをワークペイロードで送信します。デフォルト設定は `Bash` を含むルーチンツール呼び出しを事前承認し、クラウドセッションは [モードに関係なくファイル編集を事前承認](/docs/ja/permission-modes#switch-permission-modes) します。何も事前承認しない呼び出しはセッション UI を通じてプロンプトします。

<Note>
  [デフォルト拒否ネットワーク出力](/docs/ja/self-hosted-environments-deploy#default-deny-egress) を実行するセッションコンテナと [強化セクション](/docs/ja/self-hosted-environments-deploy#harden-your-deployment) の残りを備えた環境でのみ、オートモードをピン留めします。ルーチンツール呼び出し（`Bash` ネットワークリクエストを含む）は、デフォルト事前承認ツールセットとオートモードの両方で人間のループなしで実行されるため、ネットワーク境界がそれらの呼び出しが到達できる場所を制限するものです。
</Note>

コントロールプレーンが送信するものに関係なくプロンプトを最小限に保つには、ラッパースクリプトまたは [`command` フック](#command) から [オートモード](/docs/ja/permission-modes#eliminate-prompts-with-auto-mode) をピン留めします。オートモードはセッションがルーチン権限プロンプトなしで実行されるようにします。別の分類器モデルは実行前にアクションをレビューし、拒否するものをブロックし、明示的な ask ルールはまだプロンプトを強制します。権限モードページは分類器がチェックするものをカバーしています。ランナーはラッパーを呼び出す前にサーバー計算フラグを追加し、`--permission-mode` などの単一値フラグの場合、パーサーは最後の出現を尊重するため、`"$@"` の後に追加するフラグはサーバー送信値をオーバーライドします。

```bash theme={null}
#!/bin/bash
exec "$CLAUDE_RUNNER_CLAUDE_BIN" "$@" --permission-mode auto
```

代わりに特定のツールを事前承認するには、`--allowed-tools` をルールで追加します。例えば `--allowed-tools "Bash(bazel *) Bash(yarn *) mcp__internal__*"`。`--allowed-tools` と `--disallowed-tools` などのリストフラグは出現全体で蓄積され、オーバーライドされないため、ルールはコントロールプレーンが送信するルールの上に適用されます。絞り込むには、`--disallowed-tools` を追加します。これは別のルールがそれらを許可しても、ツールを拒否します。

<h3 id="how-each-session’s-config-is-assembled">
  各セッションの設定がどのように組み立てられるか
</h3>

ランナーは各セッションに独自の設定ディレクトリを提供します。ランナーが起動時に 1 回キャプチャするホストの `~/.claude/` のスナップショットからシードされます。`settings.json`、`CLAUDE.md`、フック、エージェント、コマンド、スキルがランナーイメージにあります。これらはすべてのセッションにユーザーレベルのベースラインとして適用されます。実行中のホストで設定を変更する場合、変更はランナーを再起動した後にのみ有効になります。

`SELF_HOSTED_RUNNER_HOST_CONFIG_DIR` を設定して別のパスからシードするか、空のディレクトリに指定してシーディングを無効にします。

リポジトリコミット `.claude/settings.json` はプロジェクト設定として上に層状化されます。複数のリポジトリを含むセッションでは、[有効になるのは最大 1 つのリポジトリのファイルのみです](#repository-settings-in-sessions-with-several-repositories)。セッションはランナーイメージの標準システムパスから [`managed-settings.json`](/docs/ja/settings#where-settings-live) も読み取ります。そのキーが [サーバー管理設定](/docs/ja/server-managed-settings) と一緒に適用されるかどうかは、[Claude Code が管理ソースを組み合わせる方法](/docs/ja/managed-settings#how-claude-code-combines-managed-sources) に従います。デフォルトでは、組織が任意のサーバー管理キーを配信する場合、セッションは [Claude Code がすべての管理ソースから読み取るキー](/docs/ja/managed-settings#keys-read-from-every-admin-source)（`env` ブロック、サンドボックスロック、サンドボックスバイナリパス、`forceRemoteSettingsRefresh` など）を除いて、ランナーイメージのファイルを無視します。[設定優先順位](/docs/ja/settings#settings-precedence) を参照してください。

Anthropic のコントロールプレーンがセッションに [Claude Code フック](/docs/ja/hooks) を提供する場合、ランナーはそれらを独自の設定の上ではなく隣に設定します。Claude Code v2.1.229 以降が必要です。

* **どこに着地するか**：ランナーは提供された各フックスクリプトをセッションの設定ディレクトリの予約済み `hooks/.ccr-launcher/` サブディレクトリに書き込み、スクリプトを `--settings` で渡す別の設定ファイルに登録し、シードされた `settings.json` と `hooks/<name>` の独自のスクリプトを変更しないままにします。ランナーは各セッションの予約済みサブディレクトリを再作成し、`~/.claude/hooks/.ccr-launcher/` のホストコンテンツをセッションにシードしません。
* **誰がそれらを作成するか**：コントロールプレーンはセッションごとまたはサードパーティ入力からではなく、独自のデプロイメント内の固定定数からスクリプトを入力します。
* **何がそれらを管理するか**：`--settings` を通じて配信されるフックは通常のマージされたフック設定に入り、管理層ではないため、管理設定はまだ適用されます。`disableAllHooks` はそれらを無効にし、[`allowManagedHooksOnly`](/docs/ja/settings-reference#allowmanagedhooksonly) が保つカテゴリーには含まれません。

[Claude Tag](https://claude.com/docs/claude-tag/overview) セッション以外では、セルフホスト環境のセッションはデフォルトで [自動メモリ](/docs/ja/memory#auto-memory) がオフの状態で実行されます。セッションをまたいで引き継ぐべき指示には、ランナーイメージまたはリポジトリ内の `CLAUDE.md` を使用してください。

ランナーによるホストの `~/.claude/` のスナップショットには `projects/` ディレクトリは含まれません。自動メモリのデフォルトの保存場所はこのディレクトリの下にあります。そこにメモリファイルを置いても、ランナーはそれらをセッションにシードせず、自動メモリがオンになることもありません。

<h3 id="repository-settings-in-sessions-with-several-repositories">
  複数のリポジトリを含むセッションでのリポジトリ設定
</h3>

複数のリポジトリを含むセッションでは、Claude Code はセッションの開始ディレクトリからプロジェクト設定を読み取るため、プロジェクト設定として有効になるのは最大 1 つのリポジトリの `.claude/settings.json` のみです。別のリポジトリのファイルで定義されたフックは実行されず、そのファイル内の拒否ルールは適用されず、その `env` も設定されません。

* **`--capacity 1`（デフォルト）と組み込みのチェックアウトを使用する場合**：セッションはリポジトリリストの最初のリポジトリで開始します。そのリポジトリの `.claude/settings.json` がプロジェクト設定として有効になり、その `.mcp.json` が読み込まれますが、他のリポジトリのものは有効にならず、読み込まれません。
* **1 より大きい `--capacity`、または [`checkout` フック](#checkout) を使用する場合**：セッションはチェックアウトを含むセッションごとのディレクトリで開始します。どのリポジトリの `.claude/settings.json` もプロジェクト設定として有効にならず、どのリポジトリの `.mcp.json` も読み込まれず、フックコマンド内の [`$CLAUDE_PROJECT_DIR`](/docs/ja/hooks#reference-scripts-by-path) はチェックアウトではなくそのディレクトリになります。

各リポジトリの `CLAUDE.md` とスキルは、セッションがどこで開始しても読み込まれます。ランナーはすべてのリポジトリを [追加ディレクトリ](/docs/ja/permissions#additional-directories-grant-file-access-not-configuration) として Claude Code に渡すため、Claude Code は各リポジトリの `.claude/settings.json` から `enabledPlugins` キーと `extraKnownMarketplaces` キーも読み取ります。

すべてのセッションでフックを実行したり権限ルールを適用したりするには、ランナーホストの `~/.claude/settings.json` に記述します。ランナーは、セッションがどこで開始しても、[ホストのファイルをすべてのセッションにシードします](#how-each-session’s-config-is-assembled)。`Read` ルールまたは `Edit` ルールのパスは、`//` による絶対パスまたは `~/` によるホーム相対の [パターン](/docs/ja/permissions#read-and-edit) として記述してください。それ以外のパターンは設定ソースまたは現在のディレクトリを基準とするためです。

<h3 id="repository-committed-permission-rules">
  リポジトリコミット権限ルール
</h3>

リポジトリコミット `permissions.allow` にベアな `"Edit"`、`"Write"`、または `"NotebookEdit"` エントリを入れないでください。ベアなファイルツールルールはパスに関係なくツールにマッチし、ワークスペースのみではなくホスト全体への書き込みを許可するため、ランナーの書き込みスコープ閉じ込めガードはセッションにフラグを立てます。[`--confine-repo-settings enforce`](/docs/ja/self-hosted-environments-reference#runner-cli-flags) を使用すると、ログして続行する代わりにセッションのスポーンを拒否します。[強化セクション](/docs/ja/self-hosted-environments-deploy#harden-your-deployment) を参照してください。

リポジトリはファイルツールルールをまったく必要としません。クラウドセッションは [モードに関係なくファイル編集を事前承認](/docs/ja/permission-modes#switch-permission-modes) します。ルールをコミットする場合、ワークスペースにスコープします。例えば `"Edit(/**)"`。単一の先頭スラッシュはプロジェクトルート（セッションのワークスペース）に相対的です。ベアなファイルツールルールはオペレーターのホストレベル `settings.json` では問題ありません。そのファイルはリポジトリコミットされないため。

`defaultMode` の `auto` はイメージ全体またはユーザーレベルの設定ファイルからのみ尊重されるため、チェックアウトされたリポジトリはそれ自体にオートモードを許可できません。クラウドセッションが受け入れるモードと完全なルール構文については、[権限モード](/docs/ja/permission-modes) を参照してください。

<h2 id="what’s-next">
  次のステップ
</h2>

* [リファレンス](/docs/ja/self-hosted-environments-reference)：すべての CLI フラグ、環境変数、メトリック
* [セッション ID を検証する](/docs/ja/self-hosted-environments-identity)：ランナーの外のサービスからセッショントークンを検証
