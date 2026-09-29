> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# 任意のデバイスからローカルセッションを続行する Remote Control

> Remote Control を使用して、電話、タブレット、または任意のブラウザから Claude Code のローカルセッションを続行します。claude.ai/code と Claude モバイルアプリで動作します。

Remote Control は [claude.ai/code](https://claude.ai/code) または Claude アプリ（[iOS](https://apps.apple.com/us/app/claude-by-anthropic/id6473753684) および [Android](https://play.google.com/store/apps/details?id=com.anthropic.claude)）をマシン上で実行されている Claude Code セッションに接続します。デスクでタスクを開始してから、ソファの電話またはコンピュータのブラウザで続行できます。

マシン上で Remote Control セッションを開始すると、Claude はローカルで実行され続けるため、コード実行とファイルシステムアクセスはマシン上に留まります。Remote Control を使用すると、以下のことができます。

* **ローカル環境全体をリモートで使用する**: ファイルシステム、[MCP サーバー](/docs/ja/mcp)、ツール、プロジェクト設定がすべて利用可能なままです。また、`@` を入力するとローカルプロジェクトのファイルパスが自動補完されます。
* **両方のサーフェスから同時に作業する**: 会話と [subagents](/docs/ja/sub-agents) および [dynamic workflows](/docs/ja/workflows) の進捗がすべての接続されたデバイス間で同期されるため、ターミナル、ブラウザ、電話から相互に交換可能にメッセージを送信できます。
* **電話またはブラウザから画像とファイルを送信する**: Claude アプリまたは claude.ai/code に写真またはファイルを添付できます。キャプション付きまたはキャプションなしで添付できます。Claude は添付された写真をメッセージの一部として直接見ることができます。Claude Code は他のファイルをマシンにダウンロードし、`@` ファイル参照として Claude に渡します。
* **中断に対応する**: ラップトップがスリープ状態になったり、ネットワークが切断されたりした場合、マシンがオンラインに戻ると、Claude Code は自動的に再接続されます。

[Web 上の Claude Code](/docs/ja/claude-code-on-the-web) はクラウドインフラストラクチャで実行されるのに対し、Remote Control セッションはマシン上で直接実行され、ローカルファイルシステムと相互作用します。Web およびモバイルインターフェースは、そのローカルセッションへのウィンドウにすぎません。そのため、コンピュータはオンのままである必要があり、`claude` プロセスは実行され続ける必要があります。

<h2 id="requirements">
  要件
</h2>

Remote Control を使用する前に、環境が以下の条件を満たしていることを確認してください。

* **サブスクリプション**: Pro、Max、Team、および Enterprise プランで利用可能です。API キーはサポートされていません。Team および Enterprise では、Owner が [Claude Code 管理設定](https://claude.ai/admin-settings/claude-code) で Remote Control トグルを最初に有効にする必要があります。
* **認証**: `claude` を実行し、まだサインインしていない場合は `/login` を使用して claude.ai 経由でサインインします。適格なログインがない場合、`claude remote-control` はエラーで終了しますが、`claude --remote-control` は対話型セッションを開始し、起動直後に Remote Control 失敗通知を表示します。
* **API エンドポイント**: 以下のいずれかの構成では利用できません。
  * Amazon Bedrock、Google Cloud の Agent Platform、または Microsoft Foundry を使用している。
  * [`ANTHROPIC_BASE_URL`](/docs/ja/env-vars) が `api.anthropic.com` 以外のホスト（[LLM gateway](/docs/ja/llm-gateway) やプロキシなど）を指している。Remote Control を使用するには、この変数を設定解除してください。
  * エンタープライズ [Claude apps gateway](/docs/ja/claude-apps-gateway) 経由でサインインしている。
* **機能フラグ評価**: [環境変数を設定して機能フラグ評価をオフにする](/docs/ja/env-vars#features-that-need-feature-flag-fetching) 場合、Remote Control が利用可能かどうかは、どの変数を設定するかによって異なります。
  * `CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC` または `DISABLE_GROWTHBOOK` を設定した場合、Remote Control は利用できません。シェル環境または [`settings.json` ファイル](/docs/ja/settings-reference#all-settings) の `env` ブロックのいずれかで変数が設定されている場所で変数を設定解除して、Remote Control を使用してください。
  * `DISABLE_TELEMETRY` または `DO_NOT_TRACK` のみを設定した場合、組織が [Trusted Devices](#trusted-devices) を要求しない限り、Remote Control は利用可能なままです。要求する場合は、Remote Control を使用するために変数を設定解除してください。いずれかの変数を設定した状態で Remote Control を使用するには、Claude Code v2.1.283 以降が必要です。
* **ワークスペース信頼**: まだ信頼していないディレクトリで、`claude remote-control` は信頼を有効にする内容を出力し、開始する前に `Trust <directory>? [y/N]` と尋ねます。`y` と答えると選択が保存されます。ただし、ホームディレクトリでは信頼は保存されず、実行するたびに質問が返されます。標準入力または出力がターミナルでない場合、コマンドは質問できず、[`Workspace not trusted`](/docs/ja/errors#workspace-not-trusted-when-starting-remote-control) エラーで終了します。

<h2 id="start-a-remote-control-session">
  リモートコントロールセッションを開始する
</h2>

CLI、[Claude Desktop アプリ](/docs/ja/desktop)、または VS Code 拡張機能からリモートコントロールセッションを開始できます。CLI は 3 つの呼び出しモードを提供し、Desktop アプリと VS Code は `/remote-control` コマンドを使用します。

<Tabs>
  <Tab title="サーバーモード">
    プロジェクトディレクトリで、以下を実行します：

    ```bash theme={null}
    claude remote-control
    ```

    リモートコントロールの 1 回限りの確認を受け入れるまで、`claude remote-control` は何をするかを説明し、サーバーを開始する前に `Enable Remote Control? (y/n)` と尋ねます。`y` と答えて受け入れ、サーバーを開始します。拒否した場合、Claude Code はサーバーを開始せずに終了し、次回コマンドを実行するときに再度尋ねます。

    プロセスはターミナルでサーバーモードで実行され続け、リモート接続を待機します。[別のデバイスから接続](#connect-from-another-device)するために使用できるセッション URL が表示され、スペースバーを押すと携帯電話からの高速アクセス用 QR コードが表示されます。リモートセッションがアクティブな間、ターミナルは接続ステータスとツールアクティビティを表示します。

    利用可能なフラグ：

    | フラグ | 説明 |
    | - | - |
    | `--name "My Project"` | claude.ai/code のセッションリストに表示されるカスタムセッションタイトルを設定します。 |
    | `--remote-control-session-name-prefix <prefix>` | 明示的な名前が設定されていない場合の自動生成セッション名のプレフィックス。デフォルトはマシンのホスト名で、`myhost-graceful-unicorn` のような名前が生成されます。`CLAUDE_REMOTE_CONTROL_SESSION_NAME_PREFIX` を設定して同じ効果を得ることができます。 |
    | `-c`, `--continue` | このディレクトリの最後のサーバーが開始したセッションを復元します。新しいセッションを作成する代わりに。[サーバーを停止した後のセッションの再開](#resume-sessions-after-stopping-the-server)を参照してください。`--session-id`、`--spawn`、`--capacity`、または `--create-session-in-dir` と組み合わせることはできません。Claude Code v2.1.200 以降が必要です。 |
    | `--session-id <id>` | ID でセッションを 1 つ復元します。[サーバーを停止した後のセッションの再開](#resume-sessions-after-stopping-the-server)を参照してください。`--continue`、`--spawn`、`--capacity`、または `--create-session-in-dir` と組み合わせることはできません。Claude Code v2.1.200 以降が必要です。 |
    | `--spawn <mode>` | サーバーがセッションを作成する方法。<br />• `same-dir`（デフォルト）：すべてのセッションが現在の作業ディレクトリを共有するため、同じファイルを編集している場合は競合する可能性があります。<br />• `worktree`：オンデマンドセッションごとに独自の [git worktree](/docs/ja/worktrees) を取得します。git リポジトリが必要です。<br />• `session`：シングルセッションモード。正確に 1 つのセッションを提供し、追加の接続を拒否します。起動時にのみ設定します。<br />実行時に `w` を押して `same-dir` と `worktree` の間で切り替えます。 |
    | `--capacity <N>` | 同時セッションの最大数。デフォルトは 32 です。`--spawn=session` では使用できません。 |
    | `--[no-]create-session-in-dir` | サーバーが起動するときに現在のディレクトリに 1 つのセッションを事前作成し、すぐに入力できる場所を用意します。`worktree` モードでは、このセッションは現在のディレクトリに留まり、オンデマンドセッションは分離された worktree を取得します。デフォルトでオンです。`--no-create-session-in-dir` を渡して何もない状態で開始する場合、Claude Code はサーバーを停止するときにサーバーのセッションをアーカイブするため、[再開](#resume-sessions-after-stopping-the-server)するものはありません。 |
    | `--permission-mode <mode>` | サーバーのセッションの開始 [権限モード](/docs/ja/permission-modes)（`acceptEdits` など）を設定します。`manual` を `default` のエイリアスとして受け入れます。認識されないモードはサーバーを起動時に停止し、有効なモードをリストします。 |
    | `-d`, `--debug[=<filter>]` | サーバーのデバッグログをオンにします。オプションでカテゴリでフィルタリングできます。フィルタは `=` 形式でのみ渡します（例：`--debug=api,hooks`）。Claude Code v2.1.282 以降が必要です。以前のバージョンはフラグを不明な引数として拒否します。 |
    | `--debug-file <path>` | デバッグログを指定されたファイルに書き込みます。 |
    | `--verbose` | 詳細な接続とセッションログを表示します。 |
    | `--sandbox` / `--no-sandbox` | ファイルシステムとネットワーク分離のための [サンドボックス](/docs/ja/sandboxing)を有効または無効にします。デフォルトではオフです。 |

    これらのフラグは `remote-control` の後に指定します。

    `remote-control` の前にグローバル `claude` フラグを渡すか、ラッパースクリプトが 1 つを追加する場合、Claude Code はそのフラグをサーバーが作成するセッションに引き継ぎません。Claude Code は `--verbose` や `--model` など、そのフラグを削除しても何が起こるかが変わらないことが既知の場合にのみフラグを通します。他のフラグ（`--settings` など）の場合、Claude Code は [起動を拒否](/docs/ja/errors#not-carried-over-to-the-sessions-remote-control-starts)し、削除するフラグを名前で指定します。

    Claude Code はヘルプを出力する前にリモートコントロール適格性をチェックするため、適格なアカウントでサインインしていない場合、`claude remote-control --help` はこのフラグリストの代わりにエラーを返します。
  </Tab>

  <Tab title="インタラクティブセッション">
    リモートコントロールを有効にした通常のインタラクティブ Claude Code セッションを開始するには、`--remote-control` フラグ（または `--rc`）を使用します：

    ```bash theme={null}
    claude --remote-control
    ```

    オプションでセッションの名前を渡します：

    ```bash theme={null}
    claude --remote-control "My Project"
    ```

    これにより、ターミナルで完全なインタラクティブセッションが得られ、claude.ai または Claude アプリからも制御できます。`claude remote-control`（サーバーモード）とは異なり、セッションがリモートで利用可能な間、ローカルでメッセージを入力できます。
  </Tab>

  <Tab title="既存のセッションから">
    既に Claude Code セッションにいて、それをリモートで続行したい場合は、`/remote-control`（または `/rc`）コマンドを使用します：

    ```text theme={null}
    /remote-control
    ```

    カスタムセッションタイトルを設定するには、引数として名前を渡します：

    ```text theme={null}
    /remote-control My Project
    ```

    これにより、現在の会話履歴を引き継ぐリモートコントロールセッションが開始されます。

    リモートコントロールの 1 回限りの確認を受け入れるまで、`/remote-control` が接続する前にダイアログが表示されます。**Enable Remote Control** を選択して受け入れて接続します。**Never mind** を選択するか Esc を押すと、Claude Code は接続せず、次回 `/remote-control` を実行するときに再度尋ねます。

    `--verbose`、`--sandbox`、および `--no-sandbox` フラグはこのコマンドでは利用できません。
  </Tab>

  <Tab title="VS Code">
    [Claude Code VS Code 拡張機能](/docs/ja/vs-code)で、プロンプトボックスに `/remote-control` または `/rc` と入力します。

    ```text theme={null}
    /remote-control
    ```

    リモートコントロールがオンの間、Claude Code はプロンプトボックスフッターに **Remote Control** インジケーターを表示します。セッションが接続されたら、インジケーターをクリックしてセッションに直接移動するか、[claude.ai/code](https://claude.ai/code) のセッションリストで見つけます。Claude Code はセッション URL を会話にも投稿します。切断するには、`/remote-control` を再度実行します。

    CLI とは異なり、VS Code コマンドは名前引数を受け入れたり、QR コードを表示したりしません。セッションタイトルは会話履歴または最初のプロンプトから派生します。
  </Tab>

  <Tab title="Desktop アプリ">
    [Claude Desktop アプリの](/docs/ja/desktop) Code タブのローカルセッションで、プロンプトボックスに `/remote-control` または `/rc` と入力します。

    ```text theme={null}
    /remote-control
    ```

    セッションが接続されたら、[claude.ai/code](https://claude.ai/code) のセッションリストで見つけます。切断するには、`/remote-control` を再度実行します。

    代わりにデフォルトですべてのセッションでリモートコントロールをオンにするには、[すべてのセッションでリモートコントロールを有効にする](#enable-remote-control-for-all-sessions)を参照してください。
  </Tab>
</Tabs>

<h3 id="check-connection-status">
  接続ステータスを確認する
</h3>

インタラクティブセッションで、リモートコントロールが接続されている間、ターミナルは claude.ai のセッションにリンクする `/rc active` インジケーターを表示します。ターミナルが狭すぎてそれに収まらない場合、インジケーターは非表示になります。セッション URL と [別のデバイスから接続](#connect-from-another-device)するための QR コードを表示するには、`/remote-control` を再度実行してステータスパネルを開きます。パネルでは、ローカルセッションが実行され続ける間、リモートコントロールを切断することもできます。

<span id="session-ended-elsewhere" />インタラクティブセッションで接続が失敗した場合、インジケーターは失敗を表示するように変わり、Claude Code は理由を通知で表示し、会話に追加します。`/remote-control` を実行して再接続します。ただし、理由がセッションが別の場所で変更されたことを示している場合を除きます：

* **Another connection took over this session**：別のデバイスまたは Claude Code セッションがそれを持っています。セッションを取り戻したい場合にのみ `/remote-control` を実行します。
* **This session was ended or archived from another device or app**：セッションを戻したい場合にのみ `/remote-control` を実行します。Claude Code はアーカイブされたセッションを再度開きます。
* **The server no longer reports this session**：別のデバイスまたはアプリから削除された可能性があります。

<h3 id="connect-from-another-device">
  別のデバイスから接続する
</h3>

リモートコントロールセッションがアクティブになったら、別のデバイスから接続するいくつかの方法があります：

* **セッション URL を開く**：任意のブラウザで [claude.ai/code](https://claude.ai/code) のセッションに直接移動します。
* **QR コードをスキャン**：セッション URL の横に表示される QR コードをスキャンして、Claude アプリで直接開きます。`claude remote-control` では、スペースバーを押して QR コード表示を切り替えます。
* **[claude.ai/code](https://claude.ai/code) または Claude アプリを開く**：セッションリストで名前でセッションを見つけます。Claude モバイルアプリでは、ナビゲーションの **Code** をタップしてセッションリストに到達します。リモートコントロールセッションはオンラインの場合、コンピューターアイコンと緑色のステータスドットを表示します。

接続すると、デバイスはセッションがバックグラウンドで既に実行しているサブエージェントとワークフローを表示します。デバイスからそのうちの 1 つを停止すると、Claude Code はマシン上のそのタスクを停止します。

リモートセッションタイトルは次の順序で選択されます：

1. `--name`、`--remote-control`、または `/remote-control` に渡した名前
2. `/rename` で設定したタイトル
3. 既存の会話履歴の最後の意味のあるメッセージ
4. `myhost-graceful-unicorn` のような自動生成名。`myhost` はマシンのホスト名または `--remote-control-session-name-prefix` で設定したプレフィックスです

明示的な名前を設定しなかった場合、Claude Code はプロンプトを送信すると、タイトルを更新してプロンプトを反映します。claude.ai または Claude アプリからセッションの名前を変更すると、Claude Code は `claude --resume` に表示されるローカルタイトルも更新します。

Claude アプリをまだ持っていない場合は、Claude Code 内で `/mobile` を実行して、[claude.ai/mobile](https://claude.ai/mobile) を開く QR コードを表示します。これにより、携帯電話の適切なアプリストアが開きます。

<h3 id="what-connected-devices-see">
  接続されたデバイスが表示するもの
</h3>

接続されたデバイスは、ターミナルの会話をリアルタイムで表示します。これらのケースは通常のメッセージを超えています：

* **圧縮と `/clear`**：Claude Code が [会話を圧縮](/docs/ja/context-window#what-survives-compaction)している間、接続されたデバイスは進行状況を表示し、会話が圧縮された場所を表示します。`/clear` を実行すると、接続されたデバイスでも会話がリセットされます。
* **`/resume` で会話を切り替える**：接続されたデバイスは、切り替え先の会話のタイトルまたは以前の履歴を受け取りませんが、両方向の新しいメッセージは、ターミナルで開いている会話に対して送受信されます。デバイスから元の会話で作業するには、ターミナルで `/resume` を実行して戻します。
* **`/teleport` でセッションをプル**：[クラウドセッション](/docs/ja/claude-code-on-the-web#from-cloud-to-terminal)を `/teleport` でターミナルにプルすると、接続されたデバイスはプルされた会話の以前の履歴を受け取りません。両方向の新しいメッセージはプルされた会話に対して送受信され、これはターミナルで開いている会話になります。
* **他のセッションからのメッセージ**：[クロスセッションメッセージング](/docs/ja/cross-session-messaging)では、同じ接続が異なるマシン上の独自のセッション間および [クラウドセッション](/docs/ja/claude-code-on-the-web)からのメッセージを運びます。
* **変更の差分**：セッションのディレクトリが git リポジトリにある場合、接続されたデバイスの差分ペインは変更を表示します。リポジトリのデフォルトブランチより先のコミットを持つブランチでは、ペインはブランチが分割されてからの変更を表示します。これにはコミットされていない編集が含まれます。デフォルトブランチ自体、またはそれより先ではないブランチでは、ペインはコミットされていない変更のみを表示します。
* **モデル**：接続されたデバイスから [モデル](/docs/ja/model-config)を選択すると、Claude Code はそのモデルでセッションを実行します。Claude Code v2.1.238 以降が必要です。デバイスのモデルコントロールから選択したモデルは現在のセッションにのみ適用されます。デバイスからインタラクティブセッションに `/model <name>` を送信すると、Claude Code は新しいセッションのデフォルトも設定します。
* **努力レベル**：接続されたデバイスから [努力レベル](/docs/ja/model-config#adjust-effort-level)を設定すると、`/effort` またはデバイスの努力コントロールで、Claude Code はそれをマシン上のセッションに適用します。`CLAUDE_CODE_EFFORT_LEVEL` でレベルをピン留めした場合、セッションはそのレベルを保持し、Claude Code は努力コントロールから別の選択を拒否します。努力コントロールからレベルを選択するには、マシン上の Claude Code v2.1.234 以降が必要です。
* **接続失敗後の再接続**：`/remote-control` を実行して再接続します。その間に圧縮が会話を書き直したか、`/resume` で会話を切り替えた場合、Claude Code はセッションリストに残す代わりに、使用していたサーバーセッションをアーカイブします。[アーカイブされたセッションをフィルタリング](/docs/ja/claude-code-on-the-web#archive-sessions)して見つけることができます。デバイスがまだ接続されている間に会話を切り替えてもセッションはアーカイブされません。

<h3 id="enable-remote-control-for-all-sessions">
  すべてのセッションでリモートコントロールを有効にする
</h3>

リモートコントロールは、`claude remote-control`、`claude --remote-control`、または `/remote-control` を明示的に実行するか、自動接続がオンになっている場合にのみアクティブになります。すべてのインタラクティブセッションで自動接続をオンにするには、Claude Code 内で `/config` を実行し、**Enable Remote Control for all sessions** を設定します。トグルは 3 つの値を取ります：

* **`true`**：インタラクティブセッションが開始するときに自動的に接続します。
* **`false`**：自動接続をオフにします。ただし、[管理設定](/docs/ja/managed-settings)からの `true` はそれをランク付けします。Claude Code は選択をユーザー設定に保存するためです。プロジェクトまたはローカル設定（`.claude/settings.json`、`.claude/settings.local.json`）の `false` は、管理 `true` の上でも自動接続をオフにします。
* **`default`**：選択をクリアし、設定されている場合は組織の管理者デフォルトに従います。そうでない場合は Claude Code の現在のデフォルトに従います。

同じトグルは CLI の外に表示されます：

* **Desktop アプリ**：**Settings > Claude Code > Enable remote control by default**。
* **VS Code 拡張機能**：[コマンドメニューの](/docs/ja/vs-code#use-the-prompt-box) Settings セクションの **Enable Remote Control for all sessions**。

代わりに設定ファイルから自動接続をオンにするには、ユーザー `~/.claude/settings.json` または [管理設定](/docs/ja/managed-settings)で [`remoteControlAtStartup`](/docs/ja/settings-reference#remotecontrolatstartup) を `true` に設定します。プロジェクトまたはローカル設定（`.claude/settings.json`、`.claude/settings.local.json`）では、Claude Code は `false` を尊重し、そのリポジトリの自動接続をオフにしますが、`true` は無視するため、チェックインされたファイルはリポジトリを開くすべての人のリモートコントロールをオンにすることはできません。

自動接続は独自の claude.ai アカウントでサインインするため、開始するセッションは独自のアカウントの Claude アプリにのみ表示され、他の誰にもアクセス権を付与しません。

この設定がオンの場合、各インタラクティブ Claude Code プロセスは 1 つのリモートセッションを登録します。複数のインスタンスを実行する場合、各インスタンスは独自のリモートセッションを取得します。単一のプロセスから複数の同時セッションを実行するには、代わりに [サーバーモード](#start-a-remote-control-session)を使用します。

<h3 id="resume-sessions-after-stopping-the-server">
  サーバーを停止した後のセッションの再開
</h3>

Ctrl+C で `claude remote-control` を停止すると、提供していたセッションは携帯電話またはブラウザからの応答を停止します。別の `claude remote-control` を同じディレクトリで実行していなかったり、`--no-create-session-in-dir` で開始していなかった限り、Claude Code はそれらをアーカイブしません。それらを復元するには、同じディレクトリで次のコマンドのいずれかを実行します：

* **`claude remote-control`**：サーバーが提供していたすべてのセッションを復元します。
* **`claude remote-control --continue`**：サーバーが開始したセッションのみを復元し、そのセッションが終了すると終了します。このディレクトリにレコードがない場合、Claude Code はこのリポジトリの他の git worktree から最新のものを使用します。
* **`claude remote-control --session-id <id>`**：渡した ID のセッションのみを復元し、そのセッションが終了すると終了します。ID はセッションの URL の claude.ai/code の `/code/` と任意の `?` の間の部分です。

これらのコマンドはサーバーが停止してから約 4 時間機能します。その後、`claude remote-control` を実行して新しいセッションを開始します。その間にセッションをアーカイブした場合、Claude Code v2.1.228 以降で `--continue` と `--session-id` はそれをアーカイブ解除します。

`claude --remote-control` または `/remote-control` で開始したセッションを復元するには、`claude --continue` または `claude --resume` で会話を再開します。リモートコントロールが再接続しない場合は、[リモートコントロールセッションに再接続できませんでした](#couldnt-reconnect-to-your-remote-control-session)を参照してください。

最初のターミナルがまだリモートコントロールをオンにしている間に 2 番目のターミナルで会話を再開する場合、Claude Code は 2 番目のターミナルに `Remote Control not started here` 通知を出力し、セッションを最初のターミナルから奪う代わりに、そこでリモートコントロールをオフのままにします。2 番目のターミナルで `/remote-control` を実行してリモートコントロールをそこに移動します。

Claude Desktop またはリモートコントロールがオンだった IDE 拡張機能で会話を再開する場合、Claude Code は新しいセッションをセッションリストに追加する代わりに、既存の claude.ai セッションに再度アタッチします。

<h2 id="connection-and-security">
  接続とセキュリティ
</h2>

ローカル Claude Code セッションは、アウトバウンド HTTPS リクエストのみを行い、マシン上のインバウンドポートを開くことはありません。Remote Control を開始すると、Anthropic API に登録され、作業をポーリングします。別のデバイスから接続すると、サーバーは Web またはモバイルクライアントとローカルセッション間のメッセージをストリーミング接続経由でルーティングします。

すべてのトラフィックは TLS 経由で Anthropic API を通じて移動し、Claude Code セッションと同じトランスポートセキュリティです。接続は複数の短命の認証情報を使用し、各認証情報は単一の目的にスコープされ、独立して有効期限が切れます。

Remote Control が接続されている間、セッショントランスクリプト（メッセージ、Claude の応答、ツールアクティビティを含む）は Anthropic サーバーに保存されます。保存されたトランスクリプトは、デバイス間で会話を同期させ、ネットワーク障害後にセッションが再接続できるようにします。実行とファイルシステムアクセスはマシン上に留まり、保存されたトランスクリプトは [データ使用](/docs/ja/data-usage) ポリシーに基づいて保持されます。

Remote Control を完全にオフにするには、[`disableRemoteControl`](/docs/ja/settings-reference#disableremotecontrol) 設定を使用します。Zero Data Retention などのコンプライアンス要件を持つ組織は Remote Control を有効にすることはできません。

<h2 id="trusted-devices">
  信頼できるデバイス
</h2>

<Note>
  信頼できるデバイスは現在ベータ版です。エクスペリエンスが改善されるにつれて、機能と機能が進化する可能性があります。

  信頼できるデバイスは Pro、Max、Team、および Enterprise プランで利用可能であり、デフォルトではオフになっています。Team および Enterprise プランでは、Owner が組織に対してこれをオンにします。Pro および Max プランでは、設定の Cowork またはアカウントページで、自分で **信頼できるデバイスを要求** をオンにします。
</Note>

信頼できるデバイスは、組織のメンバー、または Pro もしくは Max プランではあなた自身が、claude.ai、Claude モバイルアプリ、または Claude Desktop から Remote Control セッションを表示または操作する前に、デバイスを確認する必要があります。これは、署名されたアカウントだけでなく、既知のデバイスと最近の認証に Remote Control アクセスを結び付けます。

設定がオンの場合、Remote Control セッションと相互作用するには、以下の両方が必要です。

* **登録されたデバイス**: メンバーが Remote Control に使用する各ブラウザ、電話、またはデスクトップアプリは、独自の認証情報を登録します。登録は完全なサインイン直後にのみ提供されるため、デバイスはバックグラウンドで静かに登録されるのではなく、実際の認証の一部として信頼できるリストに参加します。
* **最近のサインイン**: メンバーのサインインは 18 時間以内である必要があります。毎日サインインする代わりに、メンバーは Face ID、Touch ID、Windows Hello、またはパスキーで存在を確認します。このバイオメトリック段階的認証はセッションを即座にリフレッシュします。

バイオメトリック チェックはデバイス上でオペレーティングシステムまたはブラウザを通じて実行され、パスキーサインインと同じメカニズムです。Anthropic は指紋、顔データ、またはその他のバイオメトリック情報を受け取ったり保存したりすることはありません。デバイスの公開鍵と表示名、プラットフォーム、登録時刻などの基本的なメタデータのみが保存されます。

この設定は Remote Control にのみ適用されます。通常の Claude チャット、ターミナルの Claude Code、および API 使用は影響を受けません。

<h3 id="enable-trusted-devices-for-your-organization">
  Team または Enterprise 組織で信頼できるデバイスを有効にする
</h3>

Owner は claude.ai 組織設定から設定を有効にします。

<Steps>
  <Step title="Capabilities ページに移動する">
    [**Organization settings > Capabilities > Remote sessions**](https://claude.ai/admin-settings/capabilities) に移動します。**Require trusted devices** トグルはそのセクションに表示されます。
  </Step>

  <Step title="信頼できるデバイスを要求をオンにする">
    この設定は組織のすべてのメンバーと、トグルを有効にした後に開始された Remote Control セッションに適用されます。トグルがオンになる前に既に実行されていたセッションは遡及的に保護されず、終了するまでデバイス要件なしで続行されます。チームごとまたはプロジェクトごとのスコープは利用できません。
  </Step>

  <Step title="メンバーに何を期待するかを伝える">
    設定が有効になった後、メンバーがブラウザ、電話、またはデスクトップアプリから新しい Remote Control セッションを初めて表示または操作するときに、そのデバイスを登録するよう求められます。事前に知らせることで混乱を避けられます。
  </Step>
</Steps>

<h3 id="what-members-see">
  メンバーが見るもの
</h3>

登録はデバイスごとに 1 回限りのステップです。その後、唯一の目に見える変化は時折のバイオメトリック プロンプトです。

* **各デバイスでの初回使用**: メンバーは登録するよう求められます。サインインが最近でない場合は、SSO が設定されている場合を含む通常のフローを通じてサインインしてから、登録を確認します。
* **日々**: 登録されたデバイスと最近のサインインを持つメンバーはプロンプトを見ません。サインインが 18 時間を超えて経過すると、次の Remote Control インタラクションは単一の Face ID、Touch ID、Windows Hello、またはパスキー プロンプトを表示します。
* **登録されていないデバイス**: デバイスが登録されるまで、Remote Control セッションを表示または操作することはできません。そのデバイスでの通常の Claude チャットは影響を受けません。
* **プラットフォーム認証器がない**: Face ID、Touch ID、または Windows Hello がないマシン上のメンバーは、ハードウェアセキュリティキーを使用するか、段階的認証の代わりにサインインできます。
* **ターミナルで**: Claude Code を実行しているマシンは、開発者が CLI にサインインするときに独自の認証情報を自動的に受け取ります。ターミナルに別の登録ステップはありません。

<h3 id="manage-enrolled-devices">
  登録されたデバイスを管理する
</h3>

メンバーはアカウント設定から独自のデバイスを確認および取り消すことができます。

[claude.ai/settings/account](https://claude.ai/settings/account#trusted-devices) を開き、**Trusted devices** セクションを見つけて、名前、プラットフォーム、登録日を含むすべての登録されたデバイスを確認します。デバイスを削除すると、その認証情報は即座に取り消され、デバイスは後で新しいサインイン後に再登録できます。認証情報は更新されない場合は自動的に有効期限が切れるため、未使用のデバイスは信頼できるリストから自動的に削除されます。

紛失または盗難されたデバイスの場合、メンバーはこのページから削除します。メンバーがサインインできない場合、管理者は管理コンソールで **Sign out everywhere** を使用してそのメンバーのすべてのセッションと登録されたデバイスを取り消すことができます。その後、メンバーは保持しているデバイスを再登録します。

<h2 id="remote-control-vs-cloud-sessions">
  リモートコントロール対クラウドセッション
</h2>

リモートコントロールと[クラウドセッション](/docs/ja/claude-code-on-the-web)は、どちらも claude.ai/code インターフェースを使用します。主な違いは、セッションが実行される場所です。リモートコントロールはお客様のマシン上で実行されるため、ローカル MCP サーバー、ツール、プロジェクト設定が利用可能なままです。クラウドセッションはクラウドインフラストラクチャ上で実行され、デフォルトでは Anthropic が管理します。

ローカル作業の途中で別のデバイスから続行したい場合は、リモートコントロールを使用してください。ローカルセットアップなしでタスクを開始したい場合、クローンしていないリポジトリで作業したい場合、または複数のタスクを並行して実行したい場合は、クラウドセッションを使用してください。[プロジェクト](/docs/ja/claude-projects)は両者を組み合わせたもので、そのスレッドはクラウドで実行され、お客様がそこで要求した場合、リモートコントロールを使用して[スレッドをお客様のコンピュータで実行](/docs/ja/claude-projects#run-a-thread-on-your-own-computer)します。

Claude Code は、ターミナルにいない時に作業するための複数の方法を提供しています。これらは、何が作業をトリガーするか、Claude がどこで実行されるか、そしてセットアップにどの程度の手間が必要かが異なります。

| | トリガー | Claude が実行される場所 | セットアップ | 最適な用途 |
| :- | :- | :- | :- | :- |
| [Dispatch](/docs/ja/desktop#sessions-from-dispatch) | Claude モバイルアプリからタスクをメッセージで送信 | あなたのマシン（Desktop） | [モバイルアプリを Desktop とペアリング](https://support.claude.com/en/articles/13947068) | 外出中の作業委譲、最小限のセットアップ |
| [Remote Control](/docs/ja/remote-control) | [claude.ai/code](https://claude.ai/code) または Claude モバイルアプリから実行中のセッションを操作 | あなたのマシン（CLI、Desktop、または VS Code） | [`claude remote-control` または `/remote-control`](/docs/ja/remote-control#start-a-remote-control-session) を実行 | 別のデバイスから進行中の作業を操舵 |
| [Channels](/docs/ja/channels) | Telegram や Discord などのチャットアプリ、またはあなた自身のサーバーからイベントをプッシュ | あなたのマシン（CLI） | [チャネルプラグインをインストール](/docs/ja/channels#quickstart)するか、[独自に構築](/docs/ja/channels-reference) | CI 失敗やチャットメッセージなどの外部イベントに対応 |
| [Slack](/docs/ja/slack) | チームチャネルで `@Claude` をメンション | Anthropic クラウド | [Slack アプリをインストール](/docs/ja/slack#setting-up-claude-code-in-slack)し、[ウェブ上の Claude Code](/docs/ja/claude-code-on-the-web) を有効化 | チームチャットからの PR とレビュー |
| [Self-hosted environments](/docs/ja/self-hosted-environments) | [クラウドセッション](/docs/ja/claude-code-on-the-web)を開始し、組織の環境を選択 | あなたの組織のインフラストラクチャ | [ランナーをデプロイ](/docs/ja/self-hosted-environments-quickstart)、Team および Enterprise プラン | ネットワーク内で実行する必要があるクラウドセッション |
| [Scheduled tasks](/docs/ja/scheduled-tasks) | スケジュールを設定 | [CLI](/docs/ja/scheduled-tasks)、[Desktop](/docs/ja/desktop-scheduled-tasks)、または[クラウド](/docs/ja/routines) | 頻度を選択 | 日次レビューなどの定期的な自動化 |

<h2 id="mobile-push-notifications">
  モバイルプッシュ通知
</h2>

リモートコントロールがアクティブな場合、Claude はお客様の電話にプッシュ通知を送信できます。

Claude がプッシュを送信するタイミングを決定します。通常は、長時間実行されるタスクが完了したときや、続行するためにお客様の決定が必要なときに送信されます。プロンプトでプッシュをリクエストすることもできます。例えば `notify me when the tests finish` のようにです。以下の 2 つのオン/オフトグルを除いて、イベントごとの設定はありません。

モバイルプッシュ通知を設定するには：

<Steps>
  <Step title="Claude モバイルアプリをインストール">
    [iOS](https://apps.apple.com/us/app/claude-by-anthropic/id6473753684) または [Android](https://play.google.com/store/apps/details?id=com.anthropic.claude) 用の Claude アプリをダウンロードしてください。
  </Step>

  <Step title="Claude Code アカウントでサインイン">
    ターミナルで Claude Code に使用するのと同じアカウントと組織を使用してください。
  </Step>

  <Step title="通知を許可">
    オペレーティングシステムからの通知権限プロンプトを受け入れてください。
  </Step>

  <Step title="Claude Code でプッシュを有効化">
    ターミナルで `/config` を実行し、プロアクティブな通知の場合は **Push when Claude decides**、権限プロンプトと質問の場合は **Push when actions required**、またはその両方を有効にしてください。
  </Step>
</Steps>

通知が届かない場合：

* `/config` に **No mobile registered** と表示されている場合は、Claude アプリをお客様の電話で開いて、プッシュトークンをリフレッシュしてください。リモートコントロールが次に接続するときに警告がクリアされます。
* iOS では、フォーカスモードと通知サマリーがプッシュを抑制または遅延させることができます。設定 → 通知 → Claude を確認してください。
* Android では、積極的なバッテリー最適化により配信が遅延することがあります。システム設定で Claude アプリをバッテリー最適化から除外してください。

Claude Code は、お客様がターミナルに入力中または接続されたターミナルにフォーカスしている間、モバイルプッシュ通知をスキップします。これをマシンにいるときはいつでも（別のウィンドウにいる場合でも）に拡張するには、[`CLAUDE_CLIENT_PRESENCE_FILE`](/docs/ja/env-vars) をマーカーファイルパスに設定してください。ファイルが存在する間は通知がスキップされます。スクリーンロックリスナーまたは同様のツールを設定して、スクリーンがロック解除されたときにファイルを作成し、スクリーンがロックされたときに削除してください。

<h2 id="limitations">
  制限事項
</h2>

* **インタラクティブプロセスごとに 1 つのリモートセッション**: サーバーモード外では、各 Claude Code インスタンスは一度に 1 つのリモートセッションをサポートします。単一プロセスから複数の同時セッションを実行するには、[サーバーモード](#start-a-remote-control-session)を使用してください。
* **ローカルプロセスは実行し続ける必要があります**: Remote Control はローカルプロセスとして実行されます。ターミナルを閉じたり、Desktop アプリまたは VS Code を終了したり、`claude` プロセスを停止したりすると、セッションはオフラインになります。セッションを[復帰](#resume-sessions-after-stopping-the-server)させるまでオフラインのままです。SSH から切断した後もリモートマシンでセッションを実行し続けるには、`tmux` または `screen` 内で開始してください。
* **サーバーモードでのクラッシュしたセッション**: `claude remote-control` で提供されるセッションがクラッシュした場合、接続されたデバイスからメッセージを送信してください。Claude Code はそれを再度提供します。サーバーを再起動する必要はありません。Claude Code v2.1.238 以降が必要です。
* **接続されたセッションでの HTTP 403 拒否**: インタラクティブセッションが接続されると、VPN またはネットワークの変更後に発生する可能性があるように、マシンと Anthropic のサーバー間の何かが HTTP 403 で応答する場合、Claude Code は最大 3 分間再試行を続けます。拒否が長く続く場合、Claude Code は切断され、理由は何が拒否したかを示します。ネットワークエッジ、またはあなた自身のネットワーク上のプロキシ、VPN、またはファイアウォールです。
* **拡張ネットワーク障害**: マシンが起動しているがネットワークに到達できない場合、次に何をするかはモードによって異なります。
  * **サーバーモード**: Claude Code は約 10 分後にあきらめ、`claude remote-control` プロセスが終了します。新しいセッションを開始するには、`claude remote-control` を再度実行してください。
  * **インタラクティブセッション**: ローカルで作業を続けてください。Claude Code は障害が続く限り再試行を続け、ネットワークが戻ると自動的に再接続します。
* **プレゼンスハートビートの失敗**: インタラクティブセッションが `could not reach the Remote Control server for about 30 minutes` で切断された場合、`/remote-control` を実行して再接続してください。
* **転送されたダイアログの有効期限**: Claude Code は権限プロンプトと `AskUserQuestion` の質問を、あなたが回答するまで開いたままにします。Claude Code が別の種類のダイアログをリモートセッションに転送する場合（安全性拒否後に表示されるモデル選択プロンプトなど）、デフォルトでは 5 分待機してからダイアログを閉じ、ダイアログのアクション不要なデフォルトで続行します。[`dialogExpiry`](/docs/ja/settings-reference#dialogexpiry) を設定して期限を調整または無効にしてください。Claude Code v2.1.224 以降が必要です。
* **Fable 使用クレジット同意プロンプトは転送されません**: Claude Code は、セッションが実行される場所でのみ、デバイスではなく、セッション中の [Fable 使用クレジット同意プロンプト](/docs/ja/model-config#fable-and-usage-credits)を表示します。セッションがターミナルで実行され、そこにいる誰もが Claude Code がプロンプトを閉じる前に回答しない場合、ターンはリクエストを送信せずに終了します。[プロンプトの確認が未回答のままでした](/docs/ja/errors#the-prompt-to-confirm-went-unanswered)を参照してください。
* **一部のコマンドはローカルのみ**: `/plugin` や `/resume` などのターミナルインターフェイスでのみ実行されるコマンドは、引数を渡すかどうかに関わらず、ローカル CLI からのみ機能します。以下はモバイルと Web から機能します。
  * テキスト出力コマンド: `/compact`、`/clear`、`/context`、`/usage`、`/exit`、`/usage-credits`、`/recap`、および `/reload-plugins`。`/usage-credits` はブラウザを開く代わりに課金 URL を出力します。`/reload-plugins` はセッションがインタラクティブターミナルで実行されている場合にのみ機能します。セッションがない場合は拒否されます。
  * `/model`、`/effort`、`/fast`、`/color`、および `/rename`: 値を引数として渡してください。例えば `/model sonnet` または `/effort high`。モバイルと Web から、`/model` と `/effort` は、ターミナルピッカーまたはスライダーの代わりに引数を取ります。
  * `/mcp`: モバイルアプリから、ピッカーを開く代わりにサーバーステータスのテキスト概要を返します。Web では、`/mcp` 単独で概要を返す代わりに [claude.ai コネクタ](/docs/ja/mcp#use-mcp-servers-from-claude-ai)のディレクトリを開きます。`reconnect`、`enable`、および `disable` [サブコマンド](/docs/ja/commands#all-commands)は両方から機能します。ローカル CLI とは異なり、サーバー名なしの `/mcp reconnect` は失敗したか認証が必要なすべてのサーバーを再接続します。
  * `/config`: モバイルアプリから、`key=value` を渡して設定を設定するか、引数なしで実行して設定できるキーをリストします。Web では、`/config` は代わりに設定の Claude Code セクションを開き、コマンド後のテキストを無視します。
  * Team および Enterprise では、モバイルまたは Web から `/usage-credits` は [使用クレジットリクエストを管理者に送信](/docs/ja/costs#add-usage-credits-to-your-subscription)しません。送信にはインタラクティブ CLI にのみ表示される確認が必要なため、コマンドはそこで実行するよう指示します。
  * `/autocompact`、v2.1.221 から: ウィンドウサイズを引数として渡してください。例えば `/autocompact 500k`。引数がない場合、ターミナルセッションでコマンドが表示するダイアログを開く代わりに、現在のウィンドウサイズをテキストとして出力します。
  * `/advisor`、v2.1.260 から: モデルを引数として渡してください。例えば `/advisor opus`、または `off` を渡してアドバイザーをオフにしてください。両方の形式は現在のセッションにのみ適用され、保存されたデフォルトは変わりません。引数がない場合、ピッカーを開く代わりに現在のアドバイザーをテキストとして出力します。
  * `/output-style`、v2.1.269 から: スタイル名を引数として渡してください。例えば `/output-style concise`、または引数なしで実行してスタイルをリストします。モバイルと Web から、[組み込みスタイル](/docs/ja/output-styles#built-in-output-styles)のみをリストして選択できます。[カスタムスタイル](/docs/ja/output-styles#create-a-custom-output-style)を使用するには、セッション自体で選択してください。
  * `/focus`、v2.1.281 から: 引数として `on` または `off` を渡してください。例えば `/focus on`、または引数なしで実行して [フォーカスビュー](/docs/ja/commands#all-commands)を切り替えます。両方の形式は現在のセッションにのみ適用され、保存された選択は変わりません。

<h2 id="troubleshooting">
  トラブルシューティング
</h2>

<h3 id="remote-control-requires-a-claude-ai-subscription">
  「Remote Control requires a claude.ai subscription」
</h3>

claude.ai アカウントでサインインしていないか、別の認証情報がログインより優先されています。メッセージは以下のいずれかの形式です。

* サインアウト状態で `/remote-control` または `--remote-control` から：「Remote Control requires a claude.ai subscription.」または「/remote-control requires a claude.ai subscription.」
* サインアウト状態で `claude remote-control` から：「You must be logged in to use Remote Control. Remote Control is only available with claude.ai subscriptions.」
* サインイン状態だが API キーまたはトークンが使用中：「Remote Control requires claude.ai subscription auth.」の後に、使用中の認証情報（例：「ANTHROPIC\_API\_KEY is set, so this session is using API-key auth」）が続きます。`apiKeyHelper` 設定と `ANTHROPIC_AUTH_TOKEN` も同じ方法で名前が付けられます。

`claude auth login` を実行して claude.ai オプションを選択してください。メッセージが `ANTHROPIC_API_KEY` または `ANTHROPIC_AUTH_TOKEN` を名前に挙げている場合は、それが設定されている場所（シェル環境または [設定ファイル](/docs/ja/settings-reference#env) の `env` ブロック）から削除してください。`apiKeyHelper` を名前に挙げている場合は、その設定を削除してください。

<h3 id="remote-control-requires-a-full-scope-login-token">
  「Remote Control requires a full-scope login token」
</h3>

`claude setup-token` または `CLAUDE_CODE_OAUTH_TOKEN` 環境変数から取得した長期トークンで認証されています。これらのトークンはモデルリクエストのみを実行できるため、Remote Control セッションを確立できません。代わりに `claude auth login` を実行して、フルスコープセッショントークンで認証してください。

<h3 id="unable-to-determine-your-organization-for-remote-control-eligibility">
  「Unable to determine your organization for Remote Control eligibility」
</h3>

キャッシュされたアカウント情報が古いか不完全です。`claude auth login` を実行してリフレッシュしてください。

<h3 id="remote-control-isn’t-enabled-for-this-account">
  「Remote Control isn't enabled for this account」
</h3>

Claude Code は、サインインしているアカウントの Remote Control 利用可能性を確認し、チェック結果がオフでした。通常の原因は、プラン変更後に期限切れになったキャッシュされた権限です。`claude auth logout` を実行してから `claude auth login` を実行してリフレッシュし、古いバージョンを使用している場合は Claude Code を更新してください。

`claude doctor` を実行して、どの個別の適格性チェックが失敗したかを確認してください。環境変数の競合、到達不可能なチェック、および組織の Remote Control 設定はそれぞれ独自のメッセージを生成するため、このエラーはアカウントレベルのチェック自体を意味します。

v2.1.239 より前では、このメッセージは「Remote Control is not yet enabled for your account」と表示されていました。

<h3 id="couldn’t-verify-remote-control-eligibility">
  「Couldn't verify Remote Control eligibility」
</h3>

Claude Code は、Remote Control がアカウントに対して有効になっているかどうかを確認するためにフィーチャーフラグサービスに到達できませんでした。通常の原因は、オフラインであるか、プロキシがリクエストをブロックしていることです。ネットワークアクセスが可能になったら再試行するか、詳細については `claude doctor` を実行してください。関連メッセージ「Couldn't verify your organization's Remote Control policy」は、Claude Code がそのポリシーの読み取りでエラーに遭遇したことを意味し、同じ修正方法があります。

<h3 id="remote-control-requires-feature-flag-evaluation">
  「Remote Control requires feature-flag evaluation」
</h3>

フィーチャーフラグ評価をオフにする [環境変数](/docs/ja/env-vars#features-that-need-feature-flag-fetching) が設定されており、完全なメッセージは Claude Code が見つけた変数を名前に挙げています。v2.1.154 より前のバージョンでは、同じ構成により「Remote Control is not yet enabled for your account」が代わりに生成されます。実行する内容は、メッセージが名前に挙げている変数によって異なります。

* **`CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC` または `DISABLE_GROWTHBOOK`**：シェル環境または [`settings.json` ファイル](/docs/ja/settings-reference#all-settings) の `env` ブロックで設定されている場所から変数を設定解除してください。
* **`DISABLE_TELEMETRY` または `DO_NOT_TRACK`**：Pro、Max、Team、または Enterprise プランで `DISABLE_GROWTHBOOK` が設定解除されている場合、これらの変数は組織が [Trusted Devices](#trusted-devices) を要求しない限り Remote Control を利用可能なままにします。要求する場合は、Remote Control を使用するために変数を設定されている場所から設定解除してください。v2.1.154 から v2.1.282 までは、どちらかの変数がこのメッセージを生成したため、Claude Code を v2.1.283 以降に更新してください。

<h3 id="remote-control-is-only-available-when-using-claude-via-api-anthropic-com">
  「Remote Control is only available when using Claude via api.anthropic.com」
</h3>

セッションが Anthropic API と直接通信していないため、ペアリングする claude.ai バックエンドがありません。これは Amazon Bedrock、Google Cloud の Agent Platform、および Microsoft Foundry で発生します。また、[`ANTHROPIC_BASE_URL`](/docs/ja/env-vars) が `api.anthropic.com` 以外のホスト（[LLM ゲートウェイ](/docs/ja/llm-gateway) やプロキシなど）を指している場合にも発生します。claude.ai でサインインしている場合でも同様です。完全な原因リストについては、[エラーリファレンス](/docs/ja/errors#remote-control-requires-the-anthropic-api) を参照してください。

メッセージは、セッションを Anthropic API から遠ざけたもの（`CLAUDE_CODE_USE_BEDROCK` やカスタム `ANTHROPIC_BASE_URL` など）を名前に挙げています。適格な claude.ai ログインがある場合は、名前に挙げられた変数を設定解除し、[設定](/docs/ja/settings) の `env` キーから削除した場合はそこから削除し、セッションを再開してください。

<h3 id="remote-control-is-disabled-by-your-organization’s-policy">
  「Remote Control is disabled by your organization's policy」
</h3>

ポリシーが Remote Control をブロックしています。以下の原因を順番に確認してください。

* **エラーが `disableRemoteControl` に言及している**：IT 管理者が [管理設定](/docs/ja/managed-settings) を通じてこのデバイスで Remote Control を無効にしており、組織全体のトグルおよびサインイン方法とは無関係です。
* **claude.ai プランが Pro または Max である**：Claude Code は以前のログインから Team または Enterprise 組織の下でまだサインインしているため、その組織の Remote Control ポリシーをチェックします。`/status` を実行して、サインインが使用するプランと組織を確認してください。`claude auth logout` を実行してから `claude auth login` を実行して、現在のプランの下で再度サインインしてください。
* **メッセージが組織管理者に連絡するよう指示していない**：組織に Remote Control と互換性のない HIPAA 構成があり、`/status` の `Compliance` 行に `HIPAA` が表示されています。この状態では、管理パネルの Remote Control トグルはグレーアウトされているため、所有者はそこで変更できません。オプションについて説明するために Anthropic サポートに連絡してください。v2.1.267 より前では、このケースは「Remote Control isn't available for your organization due to its compliance policy」と表示されていました。
* **それ以外の場合、所有者が組織に対して有効にしていない**：Remote Control は Team および Enterprise プランではデフォルトでオフです。所有者は [claude.ai/admin-settings/claude-code](https://claude.ai/admin-settings/claude-code) で **Remote Control** トグルをオンにすることで有効にできます。このトグルはサーバー側の組織設定です。

v2.1.281 より前では、このメッセージは Claude Code がこのマシンで組織のポリシーを読み込んでいない場合（例えば、オフラインで開始した後）にも表示されていました。後のバージョンではその状態を [`Couldn't verify your organization's policy for remote control`](#couldnt-verify-your-organizations-policy-for-remote-control) として報告します。

<h3 id="couldnt-verify-your-organizations-policy-for-remote-control">
  「Couldn't verify your organization's policy for remote control」
</h3>

Claude Code は組織のポリシーを取得できず、代わりに使用するためにこのマシンに保存されたコピーがないため、組織がそれを許可していることを確認できるまで Remote Control をオフのままにしておきます。これは通常、Claude Code をオフラインで開始するか VPN が接続する前に開始する場合、またはプロキシがリクエストに干渉する場合に発生します。遅い接続では、最初のリクエストがまだ進行中の間に表示されることもあります。

メッセージは以下のいずれかの形式です。

* `/remote-control`、`claude remote-control`、または `claude --remote-control` から：「Couldn't verify your organization's policy for remote control. Check your network connection and try again.」
* [自動接続](#enable-remote-control-for-all-sessions) からセッション開始時：「couldn't verify your organization's policy — check your network connection and try again」。通知では「Remote Control failed」が前に付き、会話では「Remote Control disconnected」が前に付きます。その後、セッションは Remote Control をオフのままにします。

ネットワーク接続を復元してから、`/remote-control` を実行するか、コマンドを再度実行してください。各試行はポリシーを再度チェックするため、Claude Code を再開する必要はありません。メッセージが表示され続ける場合は、`claude doctor` を実行し、その `Organization policy` 行を読んでください。ポリシーが読み込まれなかった理由が表示されます。

v2.1.281 より前では、この状態は「Remote Control is disabled by your organization's policy」と表示されていました。

<h3 id="remote-credentials-fetch-failed">
  「Remote credentials fetch failed」
</h3>

Claude Code は、接続を確立するために Anthropic API から短期認証情報を取得できませんでした。`--verbose` で再実行して完全なエラーを確認してください。

```bash theme={null}
claude remote-control --verbose
```

一般的な原因：

* サインインしていない：`claude` を実行して `/login` を使用して claude.ai アカウントで認証してください。API キー認証は Remote Control ではサポートされていません。
* ネットワークまたはプロキシの問題：ファイアウォールまたはプロキシが送信 HTTPS リクエストをブロックしている可能性があります。Remote Control には、ポート 443 の Anthropic API へのアクセスが必要です。
* セッション作成失敗：「Session creation failed — see debug log」も表示される場合、失敗はセットアップの前の段階で発生しました。サブスクリプションがアクティブであることを確認してください。

<h3 id="couldnt-reconnect-to-your-remote-control-session">
  「Couldn't reconnect to your Remote Control session」
</h3>

`claude --resume` または `claude --continue` で会話を再開すると、Claude Code はその会話に記録された Remote Control セッションに再接続します。このメッセージは、ネットワーク中断やサーバーエラーなど、一時的である可能性がある理由で再接続が失敗したことを意味するため、Claude Code はリモートセッションがまだ存在するかどうかを確認できません。

`/remote-control` を実行して接続を再試行するか、`claude --remote-control` で新しいセッションを開始して新しい Remote Control セッションを作成してください。その間、ローカルセッションは Remote Control なしで実行し続けます。

<h3 id="previous-session-is-unavailable">
  「Previous session is unavailable — run /remote-control to start a new one」
</h3>

Claude Code は前の Remote Control セッションを復元できず、自動的に新しいセッションを開始する代わりに停止しました。`claude --resume` または `claude --continue` で会話を再開した後、または Claude Code が [切断後に自動的に再接続](/docs/ja/errors#remote-control-couldnt-refresh-your-login) した後に、このメッセージが表示される場合があります。

`/remote-control` を実行して、現在のログインの下で新しい Remote Control セッションを開始してください。その間、ローカルセッションは Remote Control なしで実行し続けます。関連メッセージ「Remote Control could not verify the signed-in account — run /remote-control to reconnect」は同じ修正方法があります。`Previous session is unavailable` の後に Claude Code を再開せずに `/remote-control` を実行する場合、Claude Code は会話の以前のメッセージを新しいセッションから除外します。

<h3 id="remote-control-got-an-unexpected-server-response">
  「Remote Control got an unexpected server response」
</h3>

Remote Control サーバーはリクエストを受け入れましたが、リモートセッションを作成するか認証情報を取得する際に、このバージョンの Claude Code が読み取れない形式で応答しました。同じバージョンで再試行すると同じ方法で失敗します。`claude update` を実行してから、`/remote-control` を実行して再接続してください。

<h3 id="your-organization-requires-trusted-devices-for-remote-control-but-this-device-is-not-enrolled">
  「Your organization requires Trusted Devices for Remote Control, but this device is not enrolled」
</h3>

組織は [Trusted Devices](#trusted-devices) を有効にしており、このマシンはまだ登録されていません。Claude Code で `/login` を実行してください。登録はサインインの一部として行われ、個別の登録コマンドはありません。

<h3 id="session-expired-for-trusted-device-check">
  「session expired for trusted-device check」
</h3>

サインインが 18 時間以上前のものです。Claude Code で `/login` を実行するか、claude.ai またはモバイルアプリが Face ID、Touch ID、Windows Hello、またはパスキーで確認するよう求めるときに確認してください。[Trusted Devices](#trusted-devices) を参照してください。

<h2 id="related-resources">
  関連リソース
</h2>

* [Web 上の Claude Code](/docs/ja/claude-code-on-the-web): マシン上ではなくクラウドでセッションを実行します。[クラウド環境](/docs/ja/cloud-environments)を通じて設定します
* [クロスセッションメッセージング](/docs/ja/cross-session-messaging): Claude が他のマシンまたは [クラウドセッション](/docs/ja/claude-code-on-the-web)上のセッションにメッセージを送信できるようにします
* [チャネル](/docs/ja/channels): Telegram、Discord、または iMessage をセッションに転送して、Claude が離席中にメッセージに反応するようにします
* [Dispatch](/docs/ja/desktop#sessions-from-dispatch): 電話からタスクをメッセージして、Desktop セッションを生成して処理できます
* [認証](/docs/ja/authentication): `/login` をセットアップし、claude.ai の認証情報を管理します
* [CLI リファレンス](/docs/ja/cli-reference): `claude remote-control` を含むフラグとコマンドの完全なリスト
* [セキュリティ](/docs/ja/security): Remote Control セッションが Claude Code セキュリティモデルにどのように適合するか
* [データ使用](/docs/ja/data-usage): ローカル、Remote Control、およびクラウドセッション中に Anthropic API を通じてどのようなデータが流れるか
