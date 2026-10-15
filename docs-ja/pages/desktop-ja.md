> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# Desktop application

> Claude Code Desktop をさらに活用する：Git 分離による並列セッション、ドラッグアンドドロップペインレイアウト、統合ターミナルとファイルエディタ、サイドチャット、コンピュータ使用、電話から Dispatch セッションを送信、ビジュアル diff レビュー、アプリプレビュー、PR 監視、コネクタ、エンタープライズ設定。

Claude Desktop アプリには 3 つのタブがあります：**Chat** は会話用、**Cowork** は [Dispatch とより長い agentic work](https://claude.com/product/cowork) 用、**Code** はソフトウェア開発用です。このページは Code タブのリファレンスです。

<CardGroup cols={3}>
  <Card title="macOS 用にダウンロード" icon="apple" href="https://claude.ai/api/desktop/darwin/universal/dmg/latest/redirect?utm_source=claude_code&utm_medium=docs">
    Intel と Apple Silicon 向けのユニバーサルビルド
  </Card>

  <Card title="Windows 用にダウンロード" icon="windows" href="https://claude.ai/api/desktop/win32/x64/setup/latest/redirect?utm_source=claude_code&utm_medium=docs">
    x64 プロセッサ向け
  </Card>

  <Card title="Linux 用 Claude を入手（ベータ版）" icon="linux" href="/docs/ja/desktop-linux">
    Ubuntu と Debian 向けの apt または .deb
  </Card>
</CardGroup>

Windows ARM64 の場合は、[ARM64 インストーラー](https://claude.ai/api/desktop/win32/arm64/setup/latest/redirect?utm_source=claude_code\&utm_medium=docs)をダウンロードしてください。Linux では apt でインストールします。[Claude Desktop on Linux](/docs/ja/desktop-linux)を参照してください。

インストール後、Claude を起動してサインインし、**Code** タブをクリックします。最初のセッションのウォークスルーについては、[はじめにガイド](/docs/ja/desktop-quickstart)を参照してください。

Code タブでは、各会話は **セッション** です：独自のチャット履歴とプロジェクトフォルダを持ち、他のセッションとは独立しています。サイドバーはセッションをリストアップし、複数を並列で実行できます。セッション内では以下のことができます：

* [diff ビューで変更をレビューしてコメント](#review-changes-with-diff-view)してから、[CI を通じて結果の PR を監視](#monitor-pull-request-status)
* [埋め込みブラウザで実行中のアプリをプレビュー](#preview-your-app)し、Claude が独自の変更を検証し、[外部サイトを並べて開く](#browse-external-sites)
* [iOS Simulator ペインで iOS アプリを実行してテスト](/docs/ja/desktop-ios-simulator)する Claude を監視
* [ペインを配置](#arrange-your-workspace)して、チャット、diff、ブラウザ、ターミナル、ファイルエディタを並べて表示
* セッションのコンテキストを使用する[サイド質問](#ask-a-side-question-without-derailing-the-session)を尋ねて、セッションを脱線させない
* Claude に[他のセッションを確認、メッセージ送信、またはアーカイブ](#work-across-sessions)させる
* [外部ツールを接続](#connect-external-tools)（GitHub、Slack、Linear など）
* Claude に[アプリを開いてスクリーンを制御](#let-claude-use-your-computer)させる
* マシン上、[クラウド](#run-long-running-tasks-in-the-cloud)上、または [SSH](#ssh-sessions) 上で実行

[スケジュール済みの定期的な作業](/docs/ja/desktop-scheduled-tasks)、[キーボードショートカット](#keyboard-shortcuts)、または[電話からタスクを送信](#sessions-from-dispatch)については、リンクされたページとセクションを参照してください。既にターミナルベースの CLI を使用している場合は、[CLI 比較](#coming-from-the-cli)を参照して、何が引き継がれるかを確認してください。

<h2 id="start-a-session">
  セッションを開始する
</h2>

最初のメッセージを送信する前に、プロンプト領域で 4 つのことを設定してください：

* **環境**：Claude が実行される場所を選択します。ローカルマシンの場合は**Local**、アプリを閉じた後も継続する[クラウドセッション](#cloud-sessions)の場合は**Cloud**、管理するリモートマシンの場合は[**SSH 接続**](#ssh-sessions)を選択するか、Windows の場合は[**WSL ディストリビューション**](/docs/ja/desktop-wsl)を選択します。SSH セッション内のタスクは [Desktop が切断されている間も継続できます](#keep-a-task-running-while-desktop-is-disconnected)が、Claude アカウントを使用している場合は、サインインの有効期限が切れると停止することがあります。[環境設定](#environment-configuration)を参照してください。
* **プロジェクトフォルダ**：Claude が作業するフォルダまたはリポジトリを選択します。クラウドセッションの場合、[複数のリポジトリ](#run-long-running-tasks-in-the-cloud)を追加できます。
* **モデル**：送信ボタンの横のドロップダウンから[モデル](/docs/ja/model-config#available-models)を選択します。セッション中にこれを変更できます。
* **権限モード**：[モードセレクタ](#choose-a-permission-mode)から Claude がどの程度の自律性を持つかを選択します。セッション中にこれを変更できます。

タスクを入力して**Enter**キーを押してセッションを開始します。各セッションは独自のコンテキストと変更を追跡します。

<h2 id="work-with-code">
  コードの操作
</h2>

Claude に適切なコンテキストを提供し、それが独立して実行する量を制御し、変更内容を確認します。

<h3 id="use-the-prompt-box">
  プロンプトボックスを使用する
</h3>

Claude に実行させたいことを入力して**Enter**キーを押して送信します。Claude はプロジェクトファイルを読み取り、[権限モード](#choose-a-permission-mode)に基づいて変更を加えてコマンドを実行します。いつでも Claude を中断できます：停止ボタンをクリックして即座に中断するか、修正を入力して**Enter**キーを押して実行中のアクションを停止せずに送信します。Claude は現在のアクションが完了した後に修正を読み取り、次のステップの前に調整します。

プロンプトボックスの横の\*\*+\*\*ボタンをクリックすると、ファイル添付、[スキル](#use-skills)、[コネクタ](#connect-external-tools)、および[プラグイン](#install-plugins)にアクセスできます。

<h3 id="accept-a-suggested-prompt">
  提案されたプロンプトを受け入れる
</h3>

Claude が返信した後、Code タブでは、空のプロンプトボックスに次のプロンプトの提案がグレーのテキストで表示されることがあります。Claude Code は、会話をもとに短いバックグラウンドリクエストで[各提案を生成](/docs/ja/interactive-mode#prompt-suggestions)します。このリクエストはプランの使用制限または API コストにカウントされます。

* **提案を使用する**：**Tab** キーまたは **Right arrow** キーを押すと提案がプロンプトボックスに配置されます。必要に応じて編集してから、**Enter** キーを押して送信します。提案を受け入れる前に **Enter** キーを押しても、提案は送信されません。
* **独自のプロンプトを書く**：入力を開始します。提案は、プロンプトボックスが空で、添付ファイルがない場合にのみ表示されます。

**Settings > Claude Code** に移動し、**Sessions** の下にある **Prompt suggestions** をオフにすると、各セッションで次回の開始または再開時から提案が表示されなくなります。

<h3 id="add-files-and-context-to-prompts">
  ファイルとコンテキストをプロンプトに追加する
</h3>

プロンプトボックスは外部コンテキストを取り込む 2 つの方法をサポートしています：

* **@mention ファイル**：`@`の後にファイル名を入力して、ファイルを会話コンテキストに追加します。Claude はそのファイルを読み取り、参照できます。@mention はクラウドセッションおよび WSL セッションでは利用できません。
* **ファイルを添付**：添付ボタンを使用するか、ファイルをプロンプトに直接ドラッグアンドドロップして、画像、PDF、およびその他のファイルをプロンプトに添付します。これはバグのスクリーンショット、デザインモックアップ、または参照ドキュメントを共有するのに便利です。

<h3 id="choose-a-permission-mode">
  権限モードを選択する
</h3>

権限モードは、セッション中に Claude がどの程度の自律性を持つかを制御します：ファイルの編集、コマンドの実行、またはその両方の前に確認するかどうかです。送信ボタンの横のモードセレクタを使用して、いつでも権限モードを切り替えることができます。各変更を自分で承認するには、Manual に切り替えます。

新しいローカルセッションのデフォルトモードを設定するには、[設定ファイル](/docs/ja/settings#where-settings-live)に`permissions.defaultMode`を追加します。デスクトップアプリは CLI と同じ設定ファイルを読み取ります。セレクタで選択したモードはフォルダごとに記憶され、そのフォルダの`defaultMode`より優先されます。ただし Plan は現在のセッションにのみ適用されます。

| モード | 設定キー | 動作 |
| - | - | - |
| **Manual** | `default` | Claude はファイルの編集またはコマンドの実行の前に確認を求めます。差分を確認し、各変更を受け入れるか拒否できます。 |
| **Accept edits** | `acceptEdits` | Claude はファイル編集と`mkdir`、`touch`、`mv`などの一般的なファイルシステムコマンドを自動的に受け入れますが、他のターミナルコマンドの実行前には確認を求めます。ファイル変更を信頼し、より高速な反復を望む場合に使用します。 |
| **Plan** | `plan` | Claude はファイルを読み取り、コマンドを実行して探索してから、ソースコードを編集せずにプランを提案します。アプローチを最初に確認したい複雑なタスクに適しています。 |
| **Auto** | `auto` | Claude は日常的なプロンプトなしで実行されます。シェルコマンドやネットワークリクエストなどのアクションが実行される前に、バックグラウンド分類器がリクエストとの整合性を確認します。[auto モードが利用可能](#auto-mode-availability)な場合に表示されます。設定用の個別トグルはありません。 |
| **Bypass permissions** | `bypassPermissions` | Claude は権限プロンプトなしで実行されます。ただし、[どのモードも自動承認しないアクション](/docs/ja/permission-modes#actions-no-mode-auto-approves)、Claude が[外部サイトで機能する](#browse-external-sites)場合の安全分類器、またはセッションの削除などのデスクトップアクション（[セッションのアーカイブ](#work-across-sessions)は含みません）は除きます。CLI の`--dangerously-skip-permissions`と同等です。Pro および Max プランでは、Settings → Claude Code の「Allow bypass permissions mode」で有効にします。Team および Enterprise プランでは設定トグルはなく、組織ポリシーで制御されます。サンドボックス化されたコンテナまたは VM でのみ使用してください。 |

Code タブの以前のバージョンでは、これらのモードを Ask permissions、Auto accept edits、および Plan mode というラベルが付けられていました。

`dontAsk`権限モードは[CLI](/docs/ja/permission-modes#allow-only-pre-approved-tools-with-dontask-mode)でのみ利用可能です。

<Tip title="ベストプラクティス">
  複雑なタスクを Plan で開始して、Claude が変更を加える前にアプローチをマップアウトするようにします。プランを承認したら、Accept edits または Manual に切り替えて実行します。このワークフローの詳細については、[最初に探索してからプランしてからコード化する](/docs/ja/best-practices#explore-first-then-plan-then-code)を参照してください。
</Tip>

クラウドセッションは Accept edits、Plan、および Auto をサポートしています。Accept edits は`default`モードに対応しています：クラウドセッションはファイル編集を事前に承認するため、セレクタは Manual ではなく Accept edits を表示します。Bypass permissions はクラウドセッションでは利用できません。[自己ホスト環境](/docs/ja/self-hosted-environments)のセッションを含みます。

エンタープライズ管理者は利用可能な権限モードを制限できます。詳細については、[エンタープライズ設定](#enterprise-configuration)を参照してください。

<h4 id="auto-mode-availability">
  auto モードの利用可否
</h4>

auto モードは Anthropic API のすべてのユーザーが利用でき、Claude Opus 4.6 以降、Sonnet 4.6 以降、Haiku 5.5、または[Fable モデル](/docs/ja/model-config#work-with-fable)が必要です。組織管理者は[管理設定](#managed-settings)の`disableAutoMode`キーで auto モードをオフにできます。

Desktop を Google Cloud の Agent Platform にルーティングする Enterprise デプロイでも、auto モードはデフォルトで利用可能です。サポートされているモデルについては、[Bedrock、Agent Platform、または Foundry での auto モードの有効化](/docs/ja/permission-modes#enable-auto-mode-on-bedrock-agent-platform-or-foundry)を参照してください。

<h3 id="preview-your-app">
  アプリをプレビューする
</h3>

Claude は dev サーバーを起動し、Browser ペインで開いて変更を確認できます。これはフロントエンド Web アプリとバックエンドサーバーの両方で機能します：Claude は API エンドポイントをテストし、サーバーログを表示し、見つけた問題を反復処理できます。ほとんどの場合、Claude はプロジェクトファイルを編集した後、サーバーを自動的に起動します。いつでも Claude にプレビューを要求することもできます。デフォルトでは、Claude は編集後に[変更を自動検証](#auto-verify-changes)します。

Browser ペインは、プロジェクトから静的 HTML ファイル、PDF、画像、およびビデオを開くこともできます。チャットで HTML、PDF、画像、またはビデオパスをクリックして、Browser ペインで開きます。

<Note>
  [SSH セッション](#ssh-sessions)では、Claude は Browser ペインのツールを利用できないため、Browser ペインでアプリを開くことができません。アプリを自分で確認するには、[そのポートをコンピューターに転送](#reach-a-port-on-the-remote-machine)します。
</Note>

Browser ペインから、以下を実行できます：

* Browser ペインで実行中のアプリと直接対話する
* Claude が自動的に独自の変更を検証するのを監視する：スクリーンショットを撮影し、DOM を検査し、要素をクリックし、フォームに入力し、見つけた問題を修正します
* Browser ペインのヘッダーにある **Dev servers** メニューから、サーバーを開始または停止する、またはすべてのサーバーを一度に停止する
* Browser ペインの **⋮** メニューにある **Keep cookies** で、アプリを終了した後も Browser がクッキーを保持するかどうかを選択し、開発中に再度サインインする必要がないようにする

Claude はプロジェクトに基づいて初期サーバー設定を作成します。アプリがカスタム dev コマンドを使用する場合、`.claude/launch.json`を編集してセットアップに合わせます。完全なリファレンスについては、[プレビューサーバーを設定する](#configure-preview-servers)を参照してください。

Browser の保存データをクリアするには、Browser ペインの **⋮** メニューで **Clear browsing data** を選択します。Browser を完全にオフにするには、**Settings > Claude Code** で **Browser tools** をオフにします。

<h3 id="browse-external-sites">
  外部サイトを閲覧する
</h3>

Browser ペインはタブ付きブラウザなので、ドキュメント、issue トラッカー、または実行中のアプリの横に他のサイトを開くことができます。Browser を開くには、macOS で**Cmd+Shift+B**、Windows で**Ctrl+Shift+B**を押すか、セッションのタイトルバーにある **Browser** をクリックします。Google OAuth などのポップアップサインインフローを含め、ペイン内でサイトにサインインできます。

チャットで外部リンクを初めてクリックすると、リンクを Browser ペインで開くかデフォルトのブラウザで開くかを尋ねるダイアログが表示されます。後で選択を変更するには、Browser ペインの **⋮** メニューにある **Open links in built-in browser** を使用します。macOS で **Cmd** キーを押しながらクリックするか、Windows で **Ctrl** キーを押しながらクリックすると、デフォルトのブラウザでリンクが直接開きます。

Claude は[アプリを検証](#preview-your-app)するために使用するのと同じツールを使用して外部ページを読み取り、対話できます。2 つの追加の安全チェックがあります：

* 安全分類器は、すべての権限モードで、クリックやタイピングなど、外部ページでの Claude の書き込みアクションを確認します。これらは[auto モード](#choose-a-permission-mode)が使用するのと同じ分類器であり、分類器がアクションを警告した場合、モードに関係なく権限プロンプトが表示されます。
* Auto および Bypass permissions 以外の権限モードでは、Claude が新しいサイトに移動する前にドメイン許可リストチェックも適用されます。

<h4 id="approve-claude’s-actions-on-a-site">
  サイトで Claude のアクションを承認する
</h4>

Claude が外部サイトで初めてアクションを実行すると、権限カードが表示され、Claude は選択を待ちます：**Allow once**、**Always allow**、または**Deny**。**Allow once**は何も保存せずにアクションを承認します。**Always allow**はそのサイトの承認をデバイスに保存し、Settings で取り消すことができます。サブドメインを含む各サイトは独自の承認が必要です。ローカル dev サーバーとプロジェクトファイルは承認が不要なため、[auto-verify](#auto-verify-changes)はプロンプトなしで機能し続けます。

承認されたサイトでも、Claude はユーザーの入力なしに商品を購入したり、アカウントを作成したり、CAPTCHA をバイパスしたりしません。Browser ペインでの閲覧は、[Claude in Chrome 拡張機能](/docs/ja/chrome)と同じ安全モデルを使用します。Claude が機密サイトとリスクのあるアクションをどのように処理するかについては、[Claude in Chrome を安全に使用する](https://support.claude.com/en/articles/12902428-using-claude-in-chrome-safely)を参照してください。

<h4 id="choose-between-the-browser-and-the-chrome-extension">
  Browser と Chrome 拡張機能を選択する
</h4>

Browser ペインは、個人用ブラウザとは別の、保存されたログインや履歴がないクリーンなブラウザプロファイルを使用します。アプリの構築とテスト、および ID が不要なサイトに使用します。Claude がログイン済みセッションでユーザー本人として機能するようにしたい場合は、代わりにブラウザのログイン状態を共有する[Claude in Chrome 拡張機能](/docs/ja/chrome)を使用します。

<h4 id="restrict-external-browsing-for-your-organization">
  組織の外部閲覧を制限する
</h4>

Browser は、Claude in Chrome 拡張機能と同じ[サイト許可リストとブロックリストコントロール](https://support.claude.com/en/articles/13065128-claude-in-chrome-admin-controls)に従います。組織が既に拡張機能用にこれらのリストを設定している場合、Browser は自動的にそれらを尊重します。管理者は、[`browserExternalPageTools`管理設定](#managed-settings)で外部ページの Claude のツールをオフにすることもできます。ツールが無効になっている場合、ユーザーは外部サイトに移動できます。Claude のツールはそれらを読み取ったり、アクションを実行したりできません。

外部閲覧を完全に無効にするには、[`disableBrowserExternalNavigation`管理設定](#managed-settings)を`true`に設定します。これは Browser 内のすべての外部ナビゲーションをブロックします。組織の許可リストのサイトを含みます。localhost dev サーバーとファイルプレビューは機能し続けます。`browserExternalPageTools`を使用して、ユーザーが Claude のツールなしで外部サイトの閲覧を続けられるようにし、`disableBrowserExternalNavigation`を使用して、ユーザーと Claude の両方に対して外部サイトをブロックします。

<h3 id="review-changes-with-diff-view">
  差分ビューで変更を確認する
</h3>

Claude がコードに変更を加えた後、差分ビューを使用して、プルリクエストを作成する前にファイルごとに変更を確認できます。

Claude がファイルを変更すると、`+12 -1`などの追加および削除された行数を示す差分統計インジケータが表示されます。このインジケータをクリックして差分ビューアを開きます。左側にファイルリストが表示され、右側に各ファイルの変更が表示されます。

特定の行にコメントするには、差分内の任意の行をクリックしてコメントボックスを開きます。フィードバックを入力して**Enter**キーを押してコメントを追加します。複数の行にコメントを追加した後、すべてのコメントを一度に送信します：

* **macOS**：**Cmd+Enter**を押す
* **Windows**：**Ctrl+Enter**を押す

Claude はコメントを読み取り、要求された変更を加えます。これは確認できる新しい差分として表示されます。

<h3 id="review-your-code">
  コードを確認する
</h3>

コミット前に Claude に変更をレビューさせるには、[プロンプトボックス](#use-the-prompt-box)に `/code-review` と入力します。レビューが完了すると、結果が会話に表示されます。

ローカル、[SSH](#ssh-sessions)、および [WSL](/docs/ja/desktop-wsl) セッションでは、結果はファイルごとにグループ化された **Code review** カードとして表示されます。カードを使用して結果に対応します：

* **Walk through in diff** をクリックすると、差分ビューが開き、結果を 1 つずつ確認できます。現在の差分内の結果は該当する行に表示され、そこで **Fix this one** をクリックするか、結果を却下できます。
* **Apply fixes** をクリックすると、まだ未対応の結果を修正するよう Claude に依頼します。

どのセッションでも、プロンプトボックスで Claude にレビュー結果の修正を依頼することもできます。`/code-review` が確認する内容と受け付ける引数については、[差分をローカルでレビューする](/docs/ja/code-review#review-a-diff-locally)を参照してください。

<h3 id="monitor-pull-request-status">
  プルリクエストステータスを監視する
</h3>

プルリクエストを開いた後、CI ステータスバーがセッションに表示されます。Claude Code は GitHub CLI を使用してチェック結果をポーリングし、失敗を表示します。

* **Auto-fix CI & address comments**：有効にすると、Claude は失敗出力を読み取り、反復することで、失敗した CI チェックを自動的に修正しようとします。ローカルセッションでは、ユーザー以外の人が残した新しいレビューコメントにも Claude が対応します。対象となるのは、コメントの作成者がリポジトリのオーナー、組織のメンバー、コラボレーター、または GitHub App である場合です。
* **Auto-merge when ready**：有効にすると、Claude はすべてのチェックが成功したら PR をマージします。マージ方法はスカッシュです。先に [GitHub リポジトリ設定](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/configuring-pull-request-merges/managing-auto-merge-for-pull-requests-in-your-repository)で auto-merge を有効にしてください。有効になっていない場合、Claude は PR をマージできません。

これらをオンにするには、ステータスバーの **CI** をクリックします。PR がマージまたはクローズされた後にセッションを自動的にアーカイブするには、**Settings > Claude Code** で[auto-archive](#work-in-parallel-with-sessions)をオンにします。

<Note>
  PR 監視には、[GitHub CLI（`gh`）](https://cli.github.com/)がマシンにインストールされ、認証されている必要があります。`gh`がインストールされていない場合、Desktop は PR を作成しようとする最初の時点でインストールを促します。

  [SSH セッション](#ssh-sessions)では、Claude はリモートマシン上でブランチをプッシュし、`gh pr create` を実行するため、**Create PR** をクリックする前にリモートマシンで `git` と `gh` をセットアップしてください。SSH セッションでは Desktop がインストールを促さないため、`gh` はリモートマシンに自分でインストールしてください。その後、リモートマシンで `git push` が機能すること、および `gh auth status` がログイン済みであると報告することを確認してください。
</Note>

<h2 id="arrange-your-workspace">
  ワークスペースを配置する
</h2>

Code タブはペインを任意のレイアウトで配置できるように構築されています：チャット、diff、ブラウザ、ターミナル、ファイル、プラン、タスク、およびサブエージェント。macOS では [iOS Simulator](/docs/ja/desktop-ios-simulator) も含まれます。ペインをヘッダーでドラッグして位置を変更するか、ペインエッジをドラッグしてサイズを変更します。macOS では**Cmd+\\**を、Windows では**Ctrl+\\**を押してフォーカスされたペインを閉じます。セッションのタイトルバーにある**Terminal**、**Changes**、または**Browser**をクリックすると、ターミナル、diff、またはブラウザペインが開きます。その横にある\*\*⋮**メニューからは**Files\*\*などの追加のペインを開くことができ、ウィンドウの幅が狭くてこれらのボタンを表示できない場合は、ボタンもこのメニューに格納されます。

複数の画面で作業するには、diff やターミナルなどのペインをポップアウトして独立したウィンドウにし、完了したらドックバックします。Claude はメインウィンドウで作業を続けます。

<Note>
  このセクションのペインレイアウト、ターミナル、ファイルエディタ、およびビューモードには Claude Desktop v1.2581.0 以降が必要です。macOS では**Claude → Check for Updates**を、Windows では**Help → Check for Updates**を開いて更新してください。
</Note>

<h3 id="run-commands-in-the-terminal">
  ターミナルでコマンドを実行する
</h3>

統合ターミナルを使用すると、別のアプリに切り替えることなく、セッションと並行してコマンドを実行できます。セッションのタイトルバーにある**Terminal**をクリックするか、macOS または Windows で**Ctrl+\`**を押します。ターミナルはセッションの作業ディレクトリで開き、Claude と同じ環境を共有するため、`npm test`や`git status`などのコマンドは Claude が編集しているのと同じファイルを見ます。2 番目のターミナルタブを開くには、ターミナルペインヘッダーの**+**をクリックするか、チャットのフォルダを右クリックして**Open in terminal**を選択します。

ターミナルはローカルおよび [SSH](#ssh-sessions) セッションで利用可能ですが、[Windows リモートマシン](#windows-remote-machines)では制限があります。

<h3 id="open-and-edit-files">
  ファイルを開いて編集する
</h3>

チャットまたは diff ビューアのファイルパスをクリックして、ファイルペインで開きます。HTML、PDF、画像、およびビデオパスは代わりに[ブラウザペイン](#preview-your-app)で開きます。スポット編集を行い、**Save**をクリックして書き戻します。ファイルを開いてからディスク上で変更された場合、ペインは警告を表示し、上書きまたは破棄できます。**Discard**をクリックして編集を元に戻すか、ペインヘッダーのパスをクリックして絶対パスをコピーします。

ファイルペインはローカルおよび SSH セッションで利用可能です。クラウドセッションの場合、Claude に変更を加えるよう依頼します。

<h3 id="open-files-in-other-apps">
  ファイルを他のアプリで開く
</h3>

チャット、diff ビューア、またはファイルペイン内のファイルパスを右クリックしてコンテキストメニューを開きます：

* **Attach as context**：ファイルを次のプロンプトに追加
* **Open in**：VS Code、Cursor、Zed などのインストール済みエディタでファイルを開く
* **Show in Finder**（macOS）、**Show in Explorer**（Windows）：含まれるフォルダを開く
* **Copy path**：絶対パスをクリップボードにコピー

<h3 id="switch-view-modes">
  ビューモードを切り替える
</h3>

ビューモードは、チャットトランスクリプトに表示される詳細の量を制御します。ビューモードを切り替えるには、セッションタイトルの横のキャレットからセッションメニューを開いて**Transcript view**を選択するか、macOS または Windows で**Ctrl+O**を押してモードをサイクルします。Thinking モードは、表示しているセッションで Claude が思考を生成した後にのみメニューに表示されます。

| モード | 表示内容 |
| - | - |
| **Normal** | ツール呼び出しは要約に折りたたまれ、完全なテキスト応答 |
| **Thinking** | ツール呼び出しは要約に折りたたまれ、Claude の思考を含む |
| **Verbose** | すべてのツール呼び出し、ファイル読み取り、Claude が実行した中間ステップ、および Claude の思考 |

ツール呼び出しがまだ折りたたまれた状態で Claude の推論を追跡するには Thinking を使用します。Claude が特定のアクションを実行した理由をデバッグするときは Verbose を使用します。Claude Desktop v1.46388.1 より前のバージョンは Summary モードもリストしており、Summary に設定されたセッションは更新後に Normal で開きます。

<h3 id="keyboard-shortcuts">
  キーボードショートカット
</h3>

macOS で**Cmd+/**を、Windows で**Ctrl+/**を押して、Code タブで利用可能なすべてのショートカットを表示します。Windows では、以下のショートカットに対して**Cmd**の代わりに**Ctrl**を使用します。セッションサイクリング、ターミナルトグル、およびビューモードトグルはすべてのプラットフォームで**Ctrl**を使用します。

| ショートカット | アクション |
| - | - |
| `Cmd` `/` | キーボードショートカットを表示 |
| `Cmd` `N` | 新しいセッション |
| `Cmd` `W` | セッションを閉じる |
| `Ctrl` `Tab` / `Ctrl` `Shift` `Tab` | 次または前のセッション |
| `Cmd` `Shift` `]` / `Cmd` `Shift` `[` | 次または前のセッション |
| `Esc` | Claude の応答を停止 |
| `Tab` / `Right arrow` | 空のプロンプトボックスで[提案されたプロンプトを受け入れる](#accept-a-suggested-prompt) |
| `Cmd` `Shift` `D` | diff ペインを切り替え |
| `Cmd` `Shift` `B` | ブラウザペインを切り替え |
| `Cmd` `Shift` `S` | ブラウザで要素を選択 |
| `Ctrl` `` ` `` | ターミナルペインを切り替え |
| `Cmd` `\` | フォーカスされたペインを閉じる |
| `Cmd` `;` | サイドチャットを開く |
| `Ctrl` `O` | ビューモードをサイクル |
| `Cmd` `Shift` `M` | 権限モードメニューを開く |
| `Cmd` `Shift` `I` | モデルメニューを開く |
| `Cmd` `Shift` `E` | 努力メニューを開く |
| `1`–`9` | 開いているメニューの項目を選択 |

これらのショートカットは Code タブに適用されます。Desktop では、ターミナルの[インタラクティブモード](/docs/ja/interactive-mode#keyboard-shortcuts)とは異なり、`Shift+Tab`で権限モードをサイクルすることはできません。

<h3 id="check-usage">
  使用状況を確認する
</h3>

モデルピッカーの横の使用状況リングをクリックして、現在のコンテキストウィンドウ使用状況と期間中のプラン使用状況を確認します。コンテキスト使用状況はセッションごと、プラン使用状況はすべての Claude Code サーフェス全体で共有されます。

<h2 id="let-claude-use-your-computer">
  Claude にコンピュータを使用させる
</h2>

コンピュータ使用により、Claude はアプリを開き、スクリーンを制御し、あなたがするのと同じ方法でマシンで直接作業できます。CLI がないデスクトップツールと対話するよう Claude に依頼したり、GUI を通じてのみ機能する何かを自動化したりしてください。iOS アプリの実行とテストの場合、Desktop はスクリーン制御の代わりに専用の [iOS Simulator ペイン](/docs/ja/desktop-ios-simulator)を開きます。このペインはコンピュータ使用を有効にしなくても機能します。

<Note>
  コンピュータ使用は macOS と Windows の研究プレビューであり、Pro または Max プランが必要です。Team または Enterprise プランでは利用できません。Claude Desktop アプリが実行されている必要があります。
</Note>

コンピュータ使用はデフォルトでオフです。[設定で有効にして](#enable-computer-use)、Claude がスクリーンを制御する前に必要な権限を付与してください。macOS では、Accessibility と Screen Recording の権限も付与する必要があります。

macOS では、コンピュータ使用はバックグラウンドで実行することもできます。Claude は承認したアプリで作業しながら、あなたは作業を続けることができます。

<Warning>
  [サンドボックス化された Bash ツール](/docs/ja/sandboxing)とは異なり、コンピュータ使用は実際のデスクトップで実行され、承認したものへのアクセス権があります。Claude は各アクションをチェックし、オンスクリーンコンテンツからの潜在的なプロンプトインジェクションにフラグを立てますが、信頼境界は異なります。ベストプラクティスについては、[コンピュータ使用安全ガイド](https://support.claude.com/en/articles/14128542)を参照してください。
</Warning>

<h3 id="when-computer-use-applies">
  コンピュータ使用が適用される場合
</h3>

Claude はアプリまたはサービスと対話するための複数の方法を持ち、コンピュータ使用は最も広範で最も遅いです。最も正確なツールを最初に試します：

* サービスの[コネクタ](#connect-external-tools)がある場合、Claude はコネクタを使用します。
* タスクがシェルコマンドの場合、Claude は Bash を使用します。
* タスクがブラウザ作業であり、[Chrome の Claude](/docs/ja/chrome)がセットアップされている場合、Claude はそれを使用します。
* タスクが iOS アプリの実行またはテストの場合、Claude は [iOS Simulator ペイン](/docs/ja/desktop-ios-simulator)を使用します。これはスクリーン制御を使用しません。
* これらのいずれも適用されない場合、Claude はコンピュータ使用を使用します。

[アプリごとのアクセス層](#app-permissions)はこれを強化します：ブラウザはビューのみに制限され、ターミナルと IDE はクリックのみに制限され、Claude をコンピュータ使用がアクティブな場合でも専用ツールに向けます。スクリーン制御は、ネイティブアプリ、ハードウェア制御パネル、または API のない独自ツールなど、他に何も到達できないものに予約されています。

<h3 id="enable-computer-use">
  コンピュータ使用を有効にする
</h3>

コンピュータ使用はデフォルトでオフです。それが必要な何かをするよう Claude に依頼し、それがオフの場合、Claude は Settings でコンピュータ使用を有効にすれば、タスクを実行できることを伝えます。

<Steps>
  <Step title="デスクトップアプリを更新する">
    Claude Desktop の最新バージョンがあることを確認してください。macOS と Windows では、[claude.com/download](https://claude.com/download)でダウンロードまたは更新してください。Linux では、パッケージマネージャーを通じて更新してください（[手順](/docs/ja/desktop-linux)）。その後、アプリを再起動します。
  </Step>

  <Step title="トグルをオンにする">
    デスクトップアプリで、**Settings > This computer > System** に移動します。**Computer use** の下で **Enable computer use** をオンにします。Windows では、トグルはすぐに有効になり、セットアップは完了です。macOS では、次のステップに進みます。

    トグルが表示されない場合は、macOS または Windows で Pro または Max プランを使用していることを確認してから、アプリを更新して再起動します。
  </Step>

  <Step title="macOS 権限を付与する">
    macOS では、トグルが有効になる前に 2 つのシステム権限を付与します：

    * **Accessibility**：Claude がクリック、入力、スクロールできるようにします
    * **Screen Recording**：Claude がスクリーンに表示されているものを見ることができるようにします

    Settings ページは各権限の現在のステータスを表示します。いずれかが拒否されている場合、バッジをクリックして関連するシステム設定ペインを開きます。
  </Step>
</Steps>

<h3 id="app-permissions">
  アプリ権限
</h3>

Claude が初めてアプリを使用する必要がある場合、セッションにプロンプトが表示されます。**Allow for this session**または**Deny**をクリックします。承認は現在のセッション、または[Dispatch が生成したセッション](#sessions-from-dispatch)では 30 分間有効です。

プロンプトは、Claude がそのアプリに対して取得するコントロールのレベルも表示します。これらの層はアプリカテゴリによって固定され、変更できません：

| 層 | Claude ができること | 適用対象 |
| :- | :- | :- |
| ビューのみ | スクリーンショットでアプリを見る | ブラウザ、取引プラットフォーム |
| クリックのみ | クリックとスクロール、ただし入力またはキーボードショートカットは不可 | ターミナル、IDE |
| フルコントロール | クリック、入力、ドラッグ、キーボードショートカットの使用 | その他すべて |

Terminal、Finder または File Explorer、System Settings または Settings などの広範なリーチを持つアプリは、承認が何を付与するかを知るようにプロンプトに追加の警告を表示します。

**Settings > This computer > System** の **Computer use** セクションには、次のオプションがあります：

* **Denied apps**：ここにアプリを追加して、プロンプトなしで拒否します。Claude は許可されたアプリのアクションを通じて拒否されたアプリに間接的に影響を与える可能性がありますが、拒否されたアプリと直接対話することはできません。
* **Unhide apps when Claude finishes**：Claude が作業している間、他のウィンドウは非表示になり、承認されたアプリのみと対話します。Claude が完了すると、この設定をオフにしない限り、非表示のウィンドウが復元されます。

<h2 id="manage-sessions">
  セッションを管理する
</h2>

各セッションは独立した会話であり、独自のコンテキストと変更があります。複数のセッションを並列で実行するか、サイドチャットを分岐させるか、Claude に他のセッションをチェックしてメッセージを送信させるか、作業をクラウドに送信するか、Dispatch にセッションを電話から開始させることができます。

<h3 id="work-in-parallel-with-sessions">
  セッションで並列に作業する
</h3>

サイドバーの\*\*+ New session**をクリックするか、macOS で**Cmd+N**を、Windows で**Ctrl+N**を押して、複数のタスクを並列で作業します。**Ctrl+Tab**と**Ctrl+Shift+Tab**を押してサイドバーのセッションをサイクルします。Git リポジトリの場合、ブランチ名の横の**worktree\*\*オプションを選択すると、[Git worktrees](/docs/ja/worktrees)を使用して、セッションにプロジェクトの独立した分離コピーを与えることができます。

2 つのセッションを同時に表示するには、macOS で**Cmd**を、Windows で**Ctrl**を押しながらサイドバーのセッションをクリックします。セッションは既に開いているセッションの横の 2 番目のペインで開きます。分割がアクティブな間、別のサイドバーセッションをクリックすると、フォーカスがあるペインが置き換わります。macOS で\*\*Cmd+\\**を、Windows で**Ctrl+\\\*\*を押して、フォーカスされたペインを閉じて、単一のセッションに戻ります。

Worktrees はデフォルトで`<project-root>/.claude/worktrees/`に保存されます。これはカスタムディレクトリに変更できます：

* **ローカルセッション**：**Settings > Claude Code** で **Worktree location** を設定します
* **SSH セッション**：[SSH 接続](#choose-where-ssh-session-worktrees-go)で **Worktree folder** を設定します

**Settings > Claude Code** で **Branch prefix** を設定することもできます。Desktop はすべての worktree ブランチ名の前にこれを付加するため、Claude が作成したブランチを整理するのに便利です。

完了したら、サイドバーのセッションにマウスを合わせてアーカイブアイコンをクリックして worktree を削除します。プルリクエストがマージまたはクローズされたときにセッションを自動的にアーカイブするには、**Settings > Claude Code** で **Auto-archive after PR merge or close** をオンにします。Auto-archive は実行が完了したローカルセッションにのみ適用されます。

gitignored ファイル（`.env`など）を新しい worktrees に含めるには、プロジェクトルートに[`.worktreeinclude`ファイル](/docs/ja/worktrees#copy-gitignored-files-into-worktrees)を作成します。worktree セッションがプロジェクト設定、フック、スキルをどこから読み取るかについては、[worktree がメインのチェックアウトと共有するもの](/docs/ja/worktrees#what-worktrees-share-with-the-main-checkout)を参照してください。

<Note>
  セッション分離には[Git](https://git-scm.com/downloads)が必要です。ほとんどの Mac には Git がデフォルトで含まれています。Terminal で`git --version`を実行して確認してください。バージョン番号が表示されれば、Git がインストールされています。Git エラーが発生した場合は、[Cowork タブ](https://claude.com/product/cowork)で Claude に助けを求めてセットアップのトラブルシューティングを行ってください。
</Note>

サイドバーの上部のコントロールを使用して、ステータス、プロジェクト、または環境でセッションをフィルタリングし、プロジェクトでセッションをグループ化します。セッション名を変更するには、アクティブセッションの上部のツールバーのセッションタイトルをクリックします。

コンテキスト使用状況を確認するには、[使用状況を確認する](#check-usage)を参照してください。コンテキストがいっぱいになると、Claude は自動的に会話を要約して作業を続けます。`/compact`を入力して要約をより早くトリガーし、コンテキストスペースを解放することもできます。[コンテキストウィンドウ](/docs/ja/how-claude-code-works#the-context-window)を参照して、圧縮がどのように機能するかについての詳細を確認してください。

デスクトップアプリは、Code セッションがタスクを完了し、現在そのセッションを表示していない場合に OS 通知を送信します。[プロジェクト](/docs/ja/claude-projects#see-what-needs-you-in-overview)に属するセッションの場合、代わりにプロジェクトの通知を受け取ります。

<h3 id="ask-a-side-question-without-derailing-the-session">
  メインセッションを脱線させずにサイドクエスチョンを尋ねる
</h3>

サイドチャットを使用すると、セッションのコンテキストを使用するが、メインの会話に何も追加しない質問を Claude に尋ねることができます。コードの一部を理解したい、仮定を確認したい、またはセッションを脱線させずにアイデアを探索したい場合に使用します。

macOS で\*\*Cmd+;**を、Windows で**Ctrl+;\*\*を押してサイドチャットを開くか、プロンプトボックスで`/btw`を入力します。サイドチャットはその時点までのメインスレッドのすべてを読み取ることができます。完了したら、サイドチャットを閉じてメインセッションを続行します。

サイドチャットはローカル、SSH、および WSL セッションで利用可能です。デスクトップアプリはサイドチャットをディスクに保存しないため、アプリを閉じた後に戻ることはできません。

<h3 id="watch-background-tasks">
  バックグラウンドタスクを監視する
</h3>

タスクペインは、現在のセッション内で実行されているバックグラウンド作業を表示します：サブエージェント、バックグラウンドシェルコマンド、および[動的ワークフロー](/docs/ja/workflows)。セッションにバックグラウンド作業がある場合は、タイトルバーの **⋮** メニューにある **Background tasks** からペインを開きます。

任意のエントリをクリックして、サブエージェントペインで出力を確認するか、停止します。他のセッションが何をしているかを確認するには、[サイドバー](#work-in-parallel-with-sessions)を使用するか、Claude に[それらをチェックしてもらう](#work-across-sessions)ことができます。

<h3 id="work-across-sessions">
  セッション間で作業する
</h3>

Claude は他の Code タブセッションをリストアップし、各セッションが何をしてきたかを読み取り、セッション間でメッセージを送信できます。平易な言語で尋ねてください：「どのセッションが認証リファクタリングに触れましたか？」、「API セッションは何を結論づけましたか？」、または「支払いセッションにスキーマが変更されたことを伝えてください」。また、Claude にセッションの名前変更またはアーカイブを依頼することもできます。Claude はサイドバーのアーカイブアイコンと同じ方法でセッションをアーカイブするため、PR がマージされたセッションをクリーンアップするよう依頼してください。

このサーフェスを通じて、Claude はデスクトップアプリが自身で実行するセッションのみを見ます：ローカル、[SSH](#ssh-sessions)、および Code タブの[WSL](/docs/ja/desktop-wsl)セッション。Claude はクラウドセッション、またはターミナル CLI または VS Code 拡張機能から開始したセッションを見ません。同じプロジェクトの worktrees にあっても見ません。そのため、9 つのターミナル worktrees が開いていて 2 つのデスクトップセッションがある場合、それらの 1 つで回答する Claude は他の 1 つのデスクトップセッションを報告します。Claude は質問しているセッションをリストアップしません。デフォルトでは、最近アクティブな 20 個のセッションを見て、アーカイブされたセッションをスキップします。ただし、それらを要求する場合を除きます。[クロスセッションメッセージング](/docs/ja/cross-session-messaging)は、Claude が[他の Claude Code セッション](/docs/ja/cross-session-messaging#see-which-sessions-claude-can-reach)（ターミナルセッションを含む）にメッセージを送信することを別途許可します。

Claude がこのサーフェスを通じて別のセッションにメッセージを送信する場合、Claude Code はそこにカードとして表示され、送信セッションのタイトルでラベル付けされ、戻るリンクが付いているため、メッセージがどこから来たかを常に知ることができます。受信セッションがタスクの途中にある場合、Claude Code はメッセージを保持し、Claude は現在の作業が完了したら読み取ります。受信する Claude は返信でき、Claude Code はこのサーフェスを通じて返信を配信します。Claude はアーカイブされたセッションに配信できず、メッセージが届かない場合は通知します。

Claude Code はセッション間で 4 つの安全動作を適用します：

* Claude がセッションをアーカイブする前に承認カードが表示されます。ただし、auto モードと Bypass permissions モードでは、Claude は承認カードなしでセッションをアーカイブできます。確認を求められるようにするには、Manual に切り替えてください。
* このサーフェスを通じて、Claude はスケジュールタスクの実行など、誰も見ていないセッションからクロスセッションメッセージを送信できず、そのようなセッションにメッセージを配信することもできません。
* Claude Code は、受信セッションが[クロスセッションメッセージング](/docs/ja/cross-session-messaging#availability)自体を持たない場合でも、このサーフェスからの各メッセージを受信セッションの[インバウンドコントロール](/docs/ja/cross-session-messaging#control-inbound-messages)に対してチェックします。受信セッションで[`crossSessionInbound`](/docs/ja/settings-reference#crosssessioninbound)を`refuse`に設定した場合、Claude Code はこのサーフェスからのメッセージをドロップします。Claude Code は拒否を Claude デスクトップアプリに報告します。v2.1.234 より前では、Claude Code はこのサーフェスからクロスセッションメッセージングを持たない受信セッションへのすべてのメッセージをドロップしました。
* Claude Code は各受信メッセージを引用して送信元のセッションを明示し、Claude はメッセージに基づいて行動する際も受信セッション自体の権限設定に従います。

Claude は新しいセッションを提案することもできます。現在のタスクの範囲外で修正する価値があるものに気付くと、作業をチャットのタスクチップとして提供します。チップをクリックして、独自の worktree を持つ新しいセッションでその作業を開始します。Claude は現在のセッションを中断なく続行します。

<h3 id="run-long-running-tasks-in-the-cloud">
  長時間実行されるタスクをクラウドで実行する
</h3>

大規模なリファクタリング、テストスイート、マイグレーション、またはその他の長時間実行されるタスクの場合、セッションを開始するときに**Local**の代わりに**Cloud**を選択します。クラウドセッションはデフォルトで Anthropic が管理するインフラストラクチャで実行され、アプリを閉じたりコンピュータをシャットダウンしたりしても続行します。いつでも戻ってきて進捗を確認するか、Claude を別の方向に導くことができます。[claude.ai/code](https://claude.ai/code)または[Claude モバイルアプリ](/docs/ja/mobile)からクラウドセッションを監視することもできます。

クラウドセッションは複数のリポジトリもサポートしています。クラウド環境を選択した後、選択されたリポジトリの横の\*\*+\*\*ボタンをクリックして、セッションに追加のリポジトリを追加します。各リポジトリは独自のブランチセレクタを取得します。これは共有ライブラリとそのコンシューマーの更新など、複数のコードベースにまたがるタスクに便利です。

クラウドセッションがどのように機能するかについての詳細については、[クラウドで Claude Code を使用する](/docs/ja/claude-code-on-the-web)を参照してください。1 つの作業本体が多くのクラウドセッションを必要とする場合、サイドバーで**Projects**を選択して[プロジェクト](/docs/ja/claude-projects)を作成します。Claude はそこから 1 つの会話でセッションを開始して追跡します。

<Note>
  [SSH セッション](#ssh-sessions)のタスクも [Desktop が切断されている間も実行を続ける](#keep-a-task-running-while-desktop-is-disconnected)ことができますが、Claude アカウントを使用している場合は、サインインの有効期限が切れると停止することがあります。
</Note>

<h3 id="continue-in-another-surface">
  別のサーフェスで続行する
</h3>

セッションを別の場所で続行するには、セッションタイトルの横のキャレット、またはサイドバーのセッションの行からセッションメニューを開き、**Open in**を選択します：

* **Cloud**を選択すると、会話を要約として引き継いだうえで、セッションを[クラウドセッション](/docs/ja/claude-code-on-the-web)として続行します。確定する前に、ファイルも移動するかどうか、およびクラウドセッションの準備ができた時点でこのセッションがアーカイブされるかどうかがダイアログに表示されます。[SSH](#ssh-sessions) 経由または [WSL](/docs/ja/desktop-wsl) で実行されるセッションは、この方法で移動できません。
* インストール済みのエディタまたはファイルマネージャーを選択すると、セッションのディスク上のフォルダをそこで開きます。

<h3 id="control-which-sessions-appear-on-your-other-devices">
  他のデバイスに表示するセッションを制御する
</h3>

ローカルセッションは、[Remote Control](/docs/ja/remote-control) によって接続されると、他のデバイスに表示されます。接続されたセッションは、[claude.ai/code](https://claude.ai/code) のセッションリストと、claude.ai アカウントにサインインしているデバイス上の Claude アプリに表示されます。

ローカルセッションは、そのセッションで Remote Control をオンにしたとき、または開始時に自動的に接続されるときに接続されます：

* **そのセッションでオンにする**：セッションの **Remote Control** スイッチを使用するか、プロンプトボックスに `/remote-control` と入力します。
* **開始時に接続される**：**Settings > Claude Code** で **Connect new sessions to Remote Control** がオンの間、新しいセッションは自動的に接続されます。この設定を一度も変更していない場合、Desktop はユーザー設定または管理設定の [`remoteControlAtStartup`](/docs/ja/settings-reference#remotecontrolatstartup) に従い、次に組織のデフォルトに従います。

セッションが接続されているかどうかを確認するには、ツールバーのセッションタイトルの前にあるノートパソコンのアイコンを確認します。セッションが接続済みまたは接続中の間、アイコンはハイライト表示されます。アイコンをクリックすると、セッションの **Remote Control** スイッチが開きます。

セッションを他のデバイスに表示しないようにするには、必要なレベルで Remote Control をオフにします：

* **1 つのセッション**：そのセッションの **Remote Control** スイッチをオフにします。開始時に接続されたセッションで `/remote-control` と入力すると、Remote Control はオンのままとなり、`Remote Control is already on. This session connected automatically when it started.` と表示されます。切断するには、その行の **Turn off** をクリックします。
* **このコンピュータ上の新しい Desktop セッション**：**Settings > Claude Code** で **Connect new sessions to Remote Control** をオフにします。すでにオフと表示されている場合は、一度オンにしてからオフにすると、Desktop が選択を保存します。保存されると、`remoteControlAtStartup` およびデフォルトよりも優先されます。
* **CLI を含む、このコンピュータ上のすべてのセッション**：`~/.claude/settings.json` で [`disableRemoteControl`](/docs/ja/settings-reference#disableremotecontrol) を `true` に設定すると、セッションが接続されなくなります。ファイルを保存した時点ですでに接続されていたセッションは、そのセッションで Remote Control をオフにするまで接続されたままです。

他のデバイスにすでに表示されているセッションを非表示にするには、Desktop でそのセッションをアーカイブします。Desktop はセッションの Remote Control 側のコピーもアーカイブするため、それらのデバイスのデフォルトのセッションリストから消えます。そこで表示または削除するには、[セッションをアーカイブする](/docs/ja/claude-code-on-the-web#archive-sessions)を参照してください。

<h3 id="sessions-from-dispatch">
  Dispatch からのセッション
</h3>

[Dispatch](https://support.claude.com/en/articles/13947068)は、[Cowork](https://claude.com/product/cowork)タブに存在する Claude との永続的な会話です。Dispatch にタスクをメッセージで送信すると、それをどのように処理するかを決定します。

タスクは 2 つの方法で Code セッションになります：「Claude Code セッションを開いてログインバグを修正する」など直接要求するか、Dispatch がタスクが開発作業であると判断して自動的に生成するかです。通常 Code にルーティングされるタスクには、バグの修正、依存関係の更新、テストの実行、またはプルリクエストの作成が含まれます。リサーチ、ドキュメント編集、スプレッドシート作業は Cowork に留まります。

どちらの方法でも、Code セッションは Code タブのサイドバーに**Dispatch**バッジ付きで表示されます。完了したときまたは承認が必要なときに、電話でプッシュ通知を受け取ります。

[コンピュータ使用](#let-claude-use-your-computer)が有効な場合、Dispatch が生成した Code セッションもそれを使用できます。これらのセッションのアプリ承認は 30 分後に期限切れになり、通常の Code セッションのようにセッション全体を続けるのではなく、再度プロンプトが表示されます。

セットアップ、ペアリング、Dispatch 設定については、[Dispatch ヘルプ記事](https://support.claude.com/en/articles/13947068)を参照してください。Dispatch には Pro または Max プランが必要であり、Team または Enterprise プランでは利用できません。

Dispatch は、ターミナルから離れているときに Claude で作業する複数の方法の 1 つです。他のオプションとの比較については、[プラットフォームと統合](/docs/ja/platforms#work-when-you-are-away-from-your-terminal)を参照してください。

<h2 id="extend-claude-code">
  Claude Code を拡張する
</h2>

外部サービスを接続し、再利用可能なワークフローを追加し、Claude の動作をカスタマイズし、プレビューサーバーを設定します。コネクタ、スキル、プラグインを 1 か所で管理するには、サイドバーの**Customize**をクリックします。Desktop アプリの [Cowork](https://claude.com/product/cowork) タブは、CLI の `~/.claude` ディレクトリではなく、この Customize 設定からスキル、プラグイン、コネクタをソースとし、claude.ai アカウント経由で同期します。

Claude Code はまた、同じアカウントでサインインしたターミナルセッションで、claude.ai アカウント用に有効化されたスキルとプラグインもロードします。[claude.ai から同期されたスキル](/docs/ja/skills#how-synced-skills-behave)および [claude.ai から同期されたプラグイン](/docs/ja/plugins/loading#synced-plugins)を参照してください。

<h3 id="connect-external-tools">
  外部ツールを接続する
</h3>

ローカルおよび [SSH](#ssh-sessions) セッションの場合、プロンプトボックスの横の\*\*+**ボタンをクリックして**Connectors**を選択し、Google Calendar、Slack、GitHub、Linear、Notion などの統合を追加します。セッションの前または中にコネクタを追加できます。**+\*\*ボタンはクラウドセッションおよび WSL セッションでは利用できませんが、[ルーチン](/docs/ja/routines)はルーチン作成時にコネクタを設定します。

コネクタを管理または切断するには、デスクトップアプリの Settings → Connectors に移動するか、プロンプトボックスの Connectors メニューから**Manage connectors**を選択します。

接続すると、Claude はカレンダーを読み取り、メッセージを送信し、問題を作成し、ツールと直接対話できます。セッションで設定されているコネクタについて Claude に尋ねることができます。

コネクタは [MCP サーバー](/docs/ja/mcp)であり、グラフィカルセットアップフローを備えています。サポートされているサービスとの迅速な統合に使用します。Connectors にリストされていない統合の場合、[設定ファイル](/docs/ja/mcp#installing-mcp-servers)を介して MCP サーバーを手動で追加します。また、[カスタムコネクタを作成](https://support.claude.com/en/articles/11175166-getting-started-with-custom-connectors-using-remote-mcp)することもできます。

<h3 id="use-skills">
  スキルを使用する
</h3>

[スキル](/docs/ja/skills)は Claude ができることを拡張します。Claude は関連する場合に自動的にロードするか、直接呼び出すことができます：プロンプトボックスで `/` を入力するか、**+**ボタンをクリックして**Slash commands**を選択して、利用可能なものを参照します。これには [組み込みコマンド](/docs/ja/commands)、[カスタムスキル](/docs/ja/skills#create-your-first-skill)、コードベースからのプロジェクトスキル、および [インストール済みプラグイン](/docs/ja/plugins/install)からのスキルが含まれます。1 つを選択すると、入力フィールドで強調表示されます。その後にタスクを入力して、通常どおり送信します。

Claude が作業中でも、他のメッセージと同じようにコマンドを送信でき、ターンが終了するとセッションはアイドル状態に戻ります。

ローカルセッションは `~/.claude/skills/` からパーソナルスキルをロードします。[SSH](#ssh-sessions) セッションは、マシンからではなく、リモートホストのホームディレクトリから `~/.claude/skills/` を読み取ります。

ローカルおよびクラウドセッションは、claude.ai アカウント用に有効化されたスキルもロードします。ただし、組織が [`disableSideloadFlags`](/docs/ja/settings-reference#disablesideloadflags) を設定している場合、ローカルセッションはそれらをロードしません。クラウドセッションは、[Cowork およびクラウドセッションのスキル](/docs/ja/skills#skills-in-cowork-and-cloud-sessions)で説明されているように、`~/.claude/skills/` の代わりにそれらをロードします。

<h3 id="install-plugins">
  プラグインをインストールする
</h3>

[プラグイン](/docs/ja/plugins/overview)は、スキル、エージェント、hooks、MCP サーバー、および LSP 設定を Claude Code に追加する再利用可能なパッケージです。ターミナルを使用せずにデスクトップアプリからプラグインをインストールできます。

ローカルおよび [SSH](#ssh-sessions) セッションの場合、プロンプトボックスの横の\*\*+**ボタンをクリックして**Plugins**を選択して、インストール済みプラグインとそのスキルを確認します。プラグインを追加するには、サブメニューから**Add plugin\*\*を選択してプラグインブラウザを開きます。これは、公式 Anthropic マーケットプレイスを含む、設定された [マーケットプレイス](/docs/ja/plugins/overview)から利用可能なプラグインを表示します。**Manage plugins**を選択して、プラグインを有効化、無効化、またはアンインストールします。

プラグインはユーザーアカウント、特定のプロジェクト、またはローカルのみにスコープできます。組織がプラグインを一元管理する場合、それらのプラグインは CLI と同じ方法で Desktop セッションで利用可能です。ただし、デスクトップアプリが [`disableSideloadFlags`](/docs/ja/settings-reference#disablesideloadflags) の下で保留しているものは除きます。

プラグインブラウザはクラウドセッションでは利用できず、デスクトップアプリからインストールしたプラグインはクラウドセッションでは利用できません。クラウドセッションでもプラグインをインストールしません。リポジトリの `.claude/settings.json` で宣言されているプラグインは、[セットアップから引き継がれるもの](/docs/ja/cloud-environments#what-carries-over-from-your-setup)で説明されているとおりです。プラグインは WSL セッションでは利用できません。プラグインの作成を含む完全なプラグインリファレンスについては、[プラグイン](/docs/ja/plugins/overview)を参照してください。

<h3 id="configure-preview-servers">
  プレビューサーバーを設定する
</h3>

Claude は dev サーバーセットアップを自動的に検出し、セッションを開始するときに選択したフォルダのルートの `.claude/launch.json` に設定を保存します。Preview はこのフォルダを作業ディレクトリとして使用するため、親フォルダを選択した場合、独自の dev サーバーを持つサブフォルダは自動的に検出されません。サブフォルダのサーバーで作業するには、そのフォルダで直接セッションを開始するか、設定を手動で追加します。

サーバーの起動方法をカスタマイズするには（たとえば `npm run dev` の代わりに `yarn dev` を使用する、ポートを変更するなど）、`.claude/launch.json` を編集します。ファイルはコメント付き JSON をサポートしています。

```json theme={null}
{
  "version": "0.0.1",
  "configurations": [
    {
      "name": "my-app",
      "runtimeExecutable": "npm",
      "runtimeArgs": ["run", "dev"],
      "port": 3000
    }
  ]
}
```

同じプロジェクトから異なるサーバーを実行するために複数の設定を定義できます。たとえば、フロントエンドと API です。以下の [例](#examples)を参照してください。

<h4 id="auto-verify-changes">
  変更を自動検証する
</h4>

`autoVerify` が有効な場合、Claude はファイルを編集した後、コード変更を自動的に検証します。スクリーンショットを撮影し、エラーをチェックし、応答を完了する前に変更が機能することを確認します。

Auto-verify はデフォルトで有効です。`.claude/launch.json` に `"autoVerify": false` を追加してプロジェクトごとに無効にするか、Browser ペインの\*\*⋮**メニューで**Auto-verify changes\*\*をオフにします。

```json theme={null}
{
  "version": "0.0.1",
  "autoVerify": false,
  "configurations": [
    {
      "name": "my-app",
      "runtimeExecutable": "npm",
      "runtimeArgs": ["run", "dev"],
      "port": 3000
    }
  ]
}
```

無効にすると、プレビューツールは引き続き利用可能であり、いつでも Claude に検証を依頼できます。Auto-verify は編集後に自動的に実行します。

<h4 id="configuration-fields">
  設定フィールド
</h4>

`configurations` 配列の各エントリは、以下のフィールドを受け入れます：

| フィールド | 型 | 説明 |
| - | - | - |
| `name` | string | このサーバーの一意の識別子 |
| `runtimeExecutable` | string | 実行するコマンド（`npm`、`yarn`、`node` など） |
| `runtimeArgs` | string\[] | `runtimeExecutable` に渡される引数（`["run", "dev"]` など） |
| `port` | number | サーバーがリッスンするポート。デフォルトは 3000 |
| `cwd` | string | プロジェクトルートに相対的な作業ディレクトリ。デフォルトはプロジェクトルート。プロジェクトルートを明示的に参照するには `${workspaceFolder}` を使用します |
| `env` | object | `{ "NODE_ENV": "development" }` などのキーと値のペアとしての追加環境変数。このファイルはリポジトリにコミットされるため、ここにシークレットを入れないでください。dev サーバーにシークレットを渡すには、[ローカル環境エディタ](#local-sessions)で設定します。 |
| `autoPort` | boolean | ポート競合の処理方法。[ポート競合](#port-conflicts)を参照してください |
| `program` | string | `node` で実行するスクリプト。[`program` と `runtimeExecutable` を使用する場合](#when-to-use-program-vs-runtimeexecutable)を参照してください |
| `args` | string\[] | `program` に渡される引数。`program` が設定されている場合のみ使用されます |
| `url` | string | `http://localhost:<port>` の代わりにプレビューが開くアドレス。[特定の URL でプレビューを開く](#open-the-preview-at-a-specific-url)を参照してください |

<a id="when-to-use-program-vs-runtimeexecutable" />

<h5 id="when-to-use-program-vs-runtimeexecutable">
  `program` と `runtimeExecutable` を使用する場合
</h5>

`runtimeExecutable` を `runtimeArgs` と共に使用して、パッケージマネージャーを通じて dev サーバーを起動します。たとえば、`"runtimeExecutable": "npm"` と `"runtimeArgs": ["run", "dev"]` は `npm run dev` を実行します。

`node` で直接実行したいスタンドアロンスクリプトがある場合は `program` を使用します。たとえば、`"program": "server.js"` は `node server.js` を実行します。`args` で追加フラグを渡します。

<a id="open-the-preview-at-a-specific-url" />

<h5 id="open-the-preview-at-a-specific-url">
  特定の URL でプレビューを開く
</h5>

デフォルトでは、プレビューは `http://localhost:<port>` を開きます。サーバーが別のアドレスを必要とする場合は `url` を設定します。一般的なケースは、ローカル HTTPS が必要なサーバー、`*.localhost` サブドメインを使用するアプリ、およびリダイレクトを通じてサインインするアプリです。

```json theme={null}
{
  "version": "0.0.1",
  "configurations": [
    {
      "name": "my-app",
      "runtimeExecutable": "npm",
      "runtimeArgs": ["run", "dev"],
      "port": 8443,
      "url": "https://localhost:8443"
    }
  ]
}
```

Localhost アドレスは直接開き、デフォルトのポートアドレスとまったく同じです。これには `localhost`、任意の `*.localhost` サブドメイン、`127.0.0.1`、および `::1` が含まれます。セキュリティのため、localhost `url` はサーバーのオリジンのみである必要があります。パスやクエリはなく、ポートはエントリのポートと一致する必要があります。特定のページを表示するには、プレビューが開いた後、Claude にそこに移動するよう依頼します。パス、クエリ、または一致しないポートを持つ localhost `url` は、url を名前付けして修正を表示する設定エラーとして報告されます。

他のアドレスの場合、Desktop はプレビューが初めてそれを開くときに許可を求めます。これは、プレビューで新しいサイトを閲覧するときと同じです。外部アドレスはパスを含む場合があります。**Always allow**を選択して、将来そのサイトのプロンプトをスキップします。プレビューで外部サイトを制限する組織ポリシーは引き続き適用されます。

既に自分で実行しているサーバーをプレビューするには、コマンドなしで `url` を設定します。Claude はサーバーを起動する代わりに、実行中のサーバーにプレビューを接続します：

```json theme={null}
{
  "version": "0.0.1",
  "configurations": [
    {
      "name": "my-app",
      "url": "https://app.localhost:3000"
    }
  ]
}
```

`url` は `http` または `https` である必要があり、ユーザー名またはパスワードを含まない必要があります。

<h4 id="port-conflicts">
  ポート競合
</h4>

`autoPort` フィールドは、優先ポートが既に使用されている場合の処理を制御します：

* **`true`**：Claude は自動的に空きポートを見つけて使用します。ほとんどの dev サーバーに適しています。
* **`false`**：Claude はエラーで失敗します。OAuth コールバックまたは CORS 許可リストなど、サーバーが特定のポートを使用する必要がある場合に使用します。
* **設定されていない（デフォルト）**：`true` の場合と同様に、サーバーには次の空きポートが割り当てられます。ただし、以下の 1 つのケースは例外です。Claude Desktop v2.37337.0 より前では、代わりに Claude がサーバーにそのポートが必要かどうかを尋ね、回答を `launch.json` に保存します。

優先ポートが使用中で `autoPort` が設定されていない場合、以下の条件がすべて当てはまると、サーバーは停止したままになります：

* `npm`、`yarn`、`pnpm`、または `bun` のスクリプトを通じてサーバーを起動している。
* 優先ポートがそのスクリプトにハードコードされている、または Claude がスクリプトを検査できない。
* `runtimeArgs` でポートを渡していない。

その場合は、ポートを解放するか、ハードコードされた値を削除するか、スクリプトに合わせて `port` を変更します。代わりに `"autoPort": true` を設定する方法は、`PORT` を読み取るスクリプトでのみ機能します。

サーバーが `PORT` 環境変数からポートを読み取るようにしてください。この環境変数には割り当てられたポートが格納されます。Claude がサーバーを別のポートに移動する場合、`runtimeArgs` 内の `--port` または `-p` の値もそれに合わせて書き換えます。

<h4 id="examples">
  例
</h4>

これらの設定は、異なるプロジェクトタイプの一般的なセットアップを示しています：

<Tabs>
  <Tab title="Next.js">
    この設定は、Yarn を使用してポート 3000 で Next.js アプリを実行します：

    ```json theme={null}
    {
      "version": "0.0.1",
      "configurations": [
        {
          "name": "web",
          "runtimeExecutable": "yarn",
          "runtimeArgs": ["dev"],
          "port": 3000
        }
      ]
    }
    ```
  </Tab>

  <Tab title="複数のサーバー">
    フロントエンドと API サーバーを持つモノレポの場合、複数の設定を定義します。フロントエンドは `autoPort: true` を使用して、3000 が使用されている場合は空きポートを選択し、API サーバーはポート 8080 を正確に必要とします：

    ```json theme={null}
    {
      "version": "0.0.1",
      "configurations": [
        {
          "name": "frontend",
          "runtimeExecutable": "npm",
          "runtimeArgs": ["run", "dev"],
          "cwd": "apps/web",
          "port": 3000,
          "autoPort": true
        },
        {
          "name": "api",
          "runtimeExecutable": "npm",
          "runtimeArgs": ["run", "start"],
          "cwd": "server",
          "port": 8080,
          "env": { "NODE_ENV": "development" },
          "autoPort": false
        }
      ]
    }
    ```
  </Tab>

  <Tab title="Node.js スクリプト">
    パッケージマネージャーコマンドを使用する代わりに Node.js スクリプトを直接実行するには、`program` フィールドを使用します：

    ```json theme={null}
    {
      "version": "0.0.1",
      "configurations": [
        {
          "name": "server",
          "program": "server.js",
          "args": ["--verbose"],
          "port": 4000
        }
      ]
    }
    ```
  </Tab>
</Tabs>

<h2 id="environment-configuration">
  環境設定
</h2>

[セッションを開始する](#start-a-session)ときに選択する環境は、Claude が実行される場所と接続方法を決定します：

* **Local**：マシンで実行され、ファイルに直接アクセスできます
* **Cloud**：デフォルトで Anthropic が管理するインフラストラクチャで実行されます。アプリを閉じても、セッションは続行されます。
* **SSH**：SSH 経由で接続するリモートマシンで実行されます。たとえば、独自のサーバー、クラウド VM、または dev コンテナなどです。実行中のタスクは [Desktop が切断されている間も続行できます](#keep-a-task-running-while-desktop-is-disconnected)が、Claude アカウントの場合はサインインの期限が切れると停止することがあります。
* **WSL**（Windows）：マシン上の [WSL 2 ディストリビューション](/docs/ja/desktop-wsl)内で実行され、その Linux ツールチェーンとネイティブパスを使用します

<h3 id="local-sessions">
  ローカルセッション
</h3>

デスクトップアプリは常にシェル環境全体を継承するわけではありません。macOS では、Dock または Finder からアプリを起動すると、`~/.zshrc` または `~/.bashrc` などのシェルプロファイルを読み取り、Claude Code に `PATH` と固定された Claude Code 変数セットを渡しますが、そこでエクスポートする他の変数は渡しません。Windows では、アプリはユーザーおよびシステム環境変数を継承しますが、PowerShell プロファイルは読み取りません。

ローカルセッションと dev サーバーの環境変数を設定するには、プロンプトボックスの環境ドロップダウンを開き、**Local** にマウスを合わせて、ギアアイコンをクリックしてローカル環境エディタを開きます。ここで保存する変数は、マシンに暗号化されて保存され、開始するすべてのローカルセッションとプレビューサーバーに適用されます。また、`~/.claude/settings.json` ファイルの `env` キーに変数を追加することもできます。ただし、これらは Claude セッションにのみ到達し、dev サーバーには到達しません。サポートされている変数の完全なリストについては、[環境変数](/docs/ja/env-vars)を参照してください。

[拡張思考](/docs/ja/model-config#extended-thinking)はデフォルトで有効になっており、複雑な推論タスクのパフォーマンスを向上させますが、追加のトークンを使用します。Anthropic API では、ローカル環境エディタで `MAX_THINKING_TOKENS` を `0` に設定して思考をオフにします。これは Opus 5.5、Sonnet 5.5、Haiku 5.5、または Fable モデルには効果がなく、これらは常に拡張思考を使用します。Anthropic API で思考をオフにした場合、Claude Code は、Opus 5 などの[その組み合わせを受け入れない](/docs/ja/errors#effort-isnt-available-with-thinking-turned-off)ことが分かっているモデルに、より高いレベルではなく effort `high` を送信します。

[適応的推論](/docs/ja/model-config#adjust-effort-level)を持つモデルでは、適応的推論が代わりに思考の深さを制御するため、`MAX_THINKING_TOKENS` に正の値を設定しても、Claude Code はその数値自体を無視します。Opus 4.6 と Sonnet 4.6 では、固定思考予算を使用するために `CLAUDE_CODE_DISABLE_ADAPTIVE_THINKING` を `1` に設定します。Fable モデル、Sonnet 5 以降、Haiku 5.5、および Opus 4.7 以降は常に適応的推論を使用し、固定予算モードはありません。

<h4 id="local-sessions-on-managed-devices">
  管理デバイス上のローカルセッション
</h4>

管理者は [`disableDesktopLocalSessions` 管理設定](#managed-settings)でローカルセッションをオフにできます。オフにされた場合、**Local** は環境ドロップダウンに留まりますが、グレーアウトされて選択できず、組織がオフにしたことを示すツールチップが表示されます。Windows では、[WSL](/docs/ja/desktop-wsl) エントリも、管理デバイスでの可用性が[別途管理](/docs/ja/admin-setup#wsl-sessions-in-claude-code-desktop)される場合、同じようにグレーアウトされます。新しいセッションは、SSH 接続が設定されている場合、最初の SSH 接続にデフォルト設定されます。Desktop は、既存のセッションを続行しようとした場合、このデバイスではローカルセッションが利用できないというメッセージを表示します。代わりに [SSH](#ssh-sessions) または [Cloud](#cloud-sessions) 環境を選択するか、IT チームに連絡してください。

<h3 id="cloud-sessions">
  クラウドセッション
</h3>

クラウドセッションはアプリを閉じても、バックグラウンドで続行されます。使用状況は[サブスクリプションプランの制限](/docs/ja/costs)にカウントされ、別の計算料金はありません。

異なるネットワークアクセスレベルと環境変数を持つカスタムクラウド環境を作成できます。それらを管理するには、プロンプトボックスの環境ドロップダウンを開いて **Cloud** を選択します：

* **環境を追加する**：**Add cloud environment** を選択します
* **自分の環境の 1 つを編集またはアーカイブする**：それにマウスを合わせて、ギアアイコンをクリックします

ネットワークアクセスと環境変数の設定の詳細については、[クラウド環境を設定する](/docs/ja/cloud-environments)を参照してください。

<h3 id="ssh-sessions">
  SSH セッション
</h3>

SSH セッションを使用すると、デスクトップアプリをインターフェイスとして使用しながら、リモートマシンで Claude Code を実行できます。これは、クラウド VM、dev コンテナ、または特定のハードウェアまたは依存関係を持つサーバーに存在するコードベースで作業するのに便利です。

<Note>
  [サードパーティプロバイダー](/docs/ja/third-party-integrations)で Desktop を使用する場合、SSH セッションには個別のセットアップが必要です。[SSH remote sessions in Claude Desktop on 3P](https://claude.com/docs/third-party/claude-desktop/ssh-remote-sessions) を参照してください。
</Note>

SSH 接続を追加するには、セッションを開始する前にプロンプトボックスの環境ドロップダウンを開き、**SSH > Add SSH connection…** を選択して接続の詳細を入力します：

* **Name**：この接続のフレンドリーラベル
* **SSH host**：`user@hostname` または `~/.ssh/config` で定義されたホスト
* **SSH port**：空のままの場合はデフォルトで 22 になるか、SSH config のポートが使用されます
* **SSH key (optional)**：`~/.ssh/id_ed25519` などの秘密鍵へのパス。SSH config または SSH エージェントを使用するには空のままにします。
* **Worktree folder**：新しいセッションが worktree を作成する、リモートマシン上のフォルダ（`~/worktrees` など）。[リモートマシンのデフォルト](#choose-where-ssh-session-worktrees-go)を使用するには空のままにします。

追加されると、接続は環境ドロップダウンの **SSH** の下に表示されます。それを選択して、そのマシンでセッションを開始します。Claude はリモートマシンで実行され、そのファイルとツールにアクセスできます。

リモートマシンでは Linux、macOS、または [Windows](#windows-remote-machines) を実行できます。Desktop は初回接続時にリモートマシンに Claude Code を自動的にインストールします。接続されると、SSH セッションは権限モード、コネクタ、プラグイン、および MCP サーバーをサポートします。

<h4 id="remote-machine-requirements-for-ssh-sessions">
  SSH セッションのリモートマシン要件
</h4>

Linux または macOS のリモートマシンには、サポートされているプロセッサ、SFTP を備えた SSH サーバー、`noexec` でマウントされていないインストールフォルダ、動作するシェル、およびネットワークアクセスが必要です。接続する前に、またはログイン後に接続が失敗した場合に、各要件を確認してください：

* **システム**：x86\_64 または arm64 プロセッサ。マシンは Claude Code の[システム要件](/docs/ja/setup#system-requirements)も満たす必要があります。Linux では、Claude Code には glibc 2.17 以降、または musl が必要です。マシンがどちらを使用しているかを確認するには、そのマシンで `ldd --version` を実行します。Alpine Linux などの musl ベースのディストリビューションでは、[Claude Code が必要とするパッケージ](/docs/ja/setup#alpine-linux-and-musl-based-distributions)もインストールしてください。
* **SFTP**：SSH サーバーが SFTP サブシステムを提供している必要があります。これは `sshd_config` の `Subsystem sftp` 行で有効になります。確認するには、コンピューターのターミナルで `sftp` を使用して同じホストとポートに接続します。正常に動作しているサーバーでは `sftp>` プロンプトが表示されます。
* **接続あたりのセッション数**：macOS と Linux の Desktop は、1 つの SSH 接続で複数のセッションを開きます。サーバーの `sshd_config` で `MaxSessions 1` が設定されている場合は、OpenSSH のデフォルトである 10 などに引き上げてください。
* **インストールフォルダ**：Desktop は、ホームディレクトリの `~/.claude/remote/` の下にヘルパープログラムと Claude Code をインストールします。そこからそれらを実行するため、そのフォルダを `noexec` でマウントされたファイルシステム上に置くことはできません。接続する各ユーザーのホームディレクトリに約 1 GB のディスク容量を確保してください。そのフォルダに含まれる内容については、[リモートマシン上のファイルとプロセス](#files-and-processes-on-the-remote-machine)を参照してください。
* **シェル**：リモートマシン上のアカウントに設定されているシェルは、Bash、Zsh、`sh` と同様に、SSH 経由で送信されたコマンドを実行できる必要があります
* **ネットワーク**：Claude Code はリモートマシンで実行され、そこからネットワークリクエストを行うため、マシンには [Claude Code が必要とするネットワークアクセス](/docs/ja/network-config#network-access-requirements)が必要です。マシンが Claude Code をダウンロードできない場合、Desktop はコンピューター上でダウンロードしてアップロードします。Claude Code のその他のリクエストは引き続きリモートマシンから送信されます。Linux のリモートマシンで、それらのリクエストにプロキシが必要な場合は、[SSH セッション用に設定してください](#set-a-proxy-or-a-ca-certificate-for-ssh-sessions)。

<h4 id="set-a-proxy-or-a-ca-certificate-for-ssh-sessions">
  SSH セッションのプロキシまたは CA 証明書を設定する
</h4>

Linux のリモートマシンがプロキシ経由でインターネットに接続する場合、または CA 証明書が必要な場合は、そのマシン上の `~/.claude/settings.json` の `env` に[プロキシと CA の変数](/docs/ja/network-config)を追加してください。そのマシンの `~/.profile`、`~/.bash_profile`、`~/.zprofile`、または `~/.zshrc` ですでにエクスポートしている場合でも追加してください。

そのマシンのターミナルで実行した `claude` がそれらのファイルから変数を取得する場合でも、SSH セッションはそれらのファイルから変数を取得しません。その結果、セッションが応答しなくなったり、**The connection from … to the API failed** や **Authentication failed** が表示されたりすることがあり、再度サインインしても解決しません。

<Steps>
  <Step title="変数を追加する">
    CA ファイルには [`NODE_EXTRA_CA_CERTS`](/docs/ja/network-config#custom-ca-certificates) を使用してください。Claude Code は `~/.claude/settings.json` の `SSL_CERT_FILE` に指定された CA を信頼しないためです。次の例では、プロキシと CA ファイルを設定します：

    ```json ~/.claude/settings.json theme={null}
    {
      "env": {
        "HTTPS_PROXY": "http://proxy.example.com:8080",
        "NODE_EXTRA_CA_CERTS": "/etc/ssl/certs/example-ca.pem"
      }
    }
    ```
  </Step>

  <Step title="メッセージを再送信する">
    そのファイルで追加または変更した変数は数秒以内に有効になるため、メッセージを再送信してください。それでも失敗する場合は、新しいセッションを開始してください。
  </Step>
</Steps>

<h5 id="find-a-proxy-or-ca-variable-set-elsewhere-on-the-remote-machine">
  リモートマシンの別の場所で設定されたプロキシまたは CA の変数を見つける
</h5>

Linux のリモートマシンがプロキシまたは CA の変数を別の場所で設定していないか確認してください。セッションはその値を使用し、[どの設定ファイルの値も無視する](/docs/ja/settings-reference#how-env-values-interact-with-your-shell)ためです：

<Steps>
  <Step title="リモートマシンが設定する変数を一覧表示する">
    コンピューターのターミナルで、自分のホストを指定して `ssh devbox env` を実行します。
  </Step>

  <Step title="変数が設定されている場所で変更する">
    一覧にその変数がある場合は、リモートマシン上の `~/.zshenv`、`/etc/environment`、`~/.bashrc` など、その変数を設定しているファイルで変更します。
  </Step>

  <Step title="セッションに新しい値を渡す">
    リモートマシンを再起動するか、[ヘルパーを削除する](#files-and-processes-on-the-remote-machine)手順の最初の 2 つのステップと同様に、Desktop を終了してヘルパーのプロセスを終了します。どちらの方法でも Claude の作業が中断されるため、タスクが実行されていないときに行ってください。
  </Step>
</Steps>

<h4 id="use-your-ssh-configuration-on-macos-and-linux">
  macOS と Linux で SSH 設定を使用する
</h4>

macOS と Linux では、Desktop はコンピューター上の OpenSSH クライアントを実行して接続するため、`~/.ssh/config` が使用されます。OpenSSH クライアントを介した接続には Claude Desktop v1.37937.0 以降が必要です。そのファイルの `Host` 名を **SSH host** フィールドに入力すると、`HostName`、`User`、`IdentityFile`、`CertificateFile`、`ProxyJump`、`ProxyCommand` など、そのエントリの設定が使用されます。

接続を追加する前に、コンピューターのターミナルでクライアントとエントリを確認してください：

* **クライアントのバージョン**：`ssh -V` を実行します。クライアントは OpenSSH 7.6 以降である必要があります。
* **エントリ**：`ssh devbox` のように、`Host` 名を指定して `ssh` を実行します。失敗する場合は、先にエントリを修正してください。

**SSH port** と **SSH key (optional)** フィールドは空のままにできます。いずれかを入力した場合、Desktop はそれをエントリと組み合わせて使用します：

* **SSH port**：ここに入力した値は、エントリの `Port` を上書きします
* **SSH key (optional)**：Desktop は、エントリの `IdentityFile` と SSH エージェント内の鍵に加えて、選択した鍵ファイルを提示します

<h5 id="reach-a-machine-behind-a-jump-host">
  ジャンプホストの背後にあるマシンに接続する
</h5>

ジャンプホスト（踏み台、バスティオンとも呼ばれます）の背後にあるマシンに接続するには、エントリで `ProxyJump` または `ProxyCommand` を設定します。次のエントリは、`bastion.example.com` を経由して `devbox.internal.example.com` に接続します：

```text ~/.ssh/config theme={null}
Host devbox
  HostName devbox.internal.example.com
  User alice
  ProxyJump bastion.example.com
```

**SSH host** フィールドに `devbox` と入力します。

<h5 id="reach-a-container-on-a-remote-machine">
  リモートマシン上のコンテナに接続する
</h5>

SSH ポートを公開していないコンテナ内でセッションを実行するには、`ProxyCommand` を使用してコンテナに接続してください。Desktop は接続先エントリの `RemoteCommand` を実行しないためです。エントリで `RemoteCommand` を使用してコンテナに入っている場合、セッションはコンテナ内ではなく、エントリがログインするマシン上で実行されます。

<Steps>
  <Step title="エントリを追加する">
    次のエントリを `~/.ssh/config` の末尾に追加するか、`Host *` エントリがある場合は最初の `Host *` エントリの直前に追加します。Docker コンテナ `devbox`、そのユーザー `dev`、マシン `build.example.com` は自分のものに置き換えてください。このエントリのコマンドは、接続ごとにコンテナ内で SSH サーバーを起動します：

    ```text ~/.ssh/config theme={null}
    Host devbox-container
      User dev
      ProxyCommand ssh build.example.com docker exec -i devbox /usr/sbin/sshd -i
    ```
  </Step>

  <Step title="コンテナを準備する">
    * OpenSSH サーバーをインストールし、イメージを再ビルドしたりコンテナを再作成したりしても変わらないホスト鍵を用意します
    * `User` で指定したアカウントに、`authorized_keys` ファイルなどのログイン手段を用意します
    * コンテナが[リモートマシンの要件](#remote-machine-requirements-for-ssh-sessions)を満たしていることを確認します
  </Step>

  <Step title="許可リストを確認する">
    管理者が [SSH ホストを制限している](#restrict-which-ssh-hosts-users-can-connect-to)場合は、コンピューターのターミナルで `ssh -G devbox-container` を実行します。出力される `hostname`（ここでは `devbox-container`）を `sshHostAllowlist` で許可するよう管理者に依頼してください。管理者がその名前を許可すると、エントリの `ProxyCommand` が接続する先はどこであっても許可されることになります。
  </Step>

  <Step title="エントリをテストしてから接続する">
    コンピューターのターミナルで `ssh devbox-container` を実行します。報告された問題を修正し、何も尋ねられずにコンテナ内でシェルが開くまで繰り返し実行します：

    * **`ssh` がパスワード、パスフレーズ、またはコードを求める場合**：SSH エージェントが保持する鍵など、プロンプトなしで機能するログインに切り替えます
    * **`ssh` が `Cannot execute command-line and remote command.` または `Bad packet length` を報告する場合**：`build.example.com` のエントリから `RemoteCommand` と `RequestTTY` を削除します。その後は、コンピューターのターミナルで `ssh build.example.com` を実行すると、コンテナ内ではなくそのマシン上でシェルが開きます。
    * **`ssh` が `Connection closed by UNKNOWN port 65535` を報告する場合**：同じターミナルで `ssh build.example.com docker exec devbox /usr/sbin/sshd -t` を実行します。
      * `Missing privilege separation directory: /run/sshd` と出力された場合は、コンテナ内にそのフォルダを作成します。
      * `no hostkeys available` と出力され、コンテナにホスト鍵がある場合は、このコマンドとエントリの両方で `exec` の後に `-u root` を追加します。

    その後、**SSH host** フィールドに `devbox-container` と入力します。
  </Step>
</Steps>

<h5 id="use-variables-from-your-shell-in-a-proxycommand">
  `ProxyCommand` でシェルの変数を使用する
</h5>

`ProxyCommand` または `Match exec` コマンドで独自の環境変数を使用するには、`~/.zshrc` などのシェル起動ファイルでその変数をエクスポートしてから、Desktop を終了して再度開きます。Desktop は起動時にログインシェルがエクスポートする内容を読み取り、終了するまでその値を保持します。

これには Claude Desktop v2.37337.0 以降と、`-0` を受け付ける `env` コマンドが必要です。これはコンピューターのターミナルで `env -0` を実行して確認できます。

<Note>
  シェルが一時的な AWS 認証情報を設定する場合は、`AWS_*` 変数をエクスポートする代わりに、[AWS CLI にプロファイルを指定してください](#use-aws-credentials-in-a-proxycommand)。
</Note>

<a id="use-aws-credentials-in-a-proxycommand" />

<h5 id="use-aws-credentials-in-a-proxycommand">
  `ProxyCommand` で AWS 認証情報を使用する
</h5>

シェル起動ファイルで一時的な AWS 認証情報を設定している場合、AWS CLI を実行する `ProxyCommand` は、ターミナルでは接続できても Desktop では失敗することがあります。シェルが `AWS_SESSION_TOKEN`、`AWS_SECURITY_TOKEN`、または `AWS_CREDENTIAL_EXPIRATION` をエクスポートしていると、Desktop の `ssh` と `ProxyCommand` は、シェルの AWS 認証情報、`AWS_REGION`、`AWS_PROFILE` を取得しません。

AWS CLI にリージョンや認証情報の他の取得元がない場合、`You must specify a region` または `Unable to locate credentials` で失敗します。Desktop から接続するには、AWS CLI が `~/.aws/config` から読み取るプロファイルを指定します：

<Steps>
  <Step title="リージョンと認証情報の取得元を持つプロファイルを追加する">
    次の例では、ヘルパープログラムから認証情報を取得する `corp` という名前のプロファイルを追加します：

    ```ini ~/.aws/config theme={null}
    [profile corp]
    region = us-east-1
    credential_process = /full/path/to/your-credential-helper
    ```

    * **`region`**：接続先マシンの AWS リージョンを指定します
    * **`credential_process`**：[AWS がドキュメントで定めている JSON 形式](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-sourcing-external.html)で認証情報を出力するプログラムのフルパスを指定します。AWS CLI は、不在中の再接続を含め、接続のたびにこのプログラムを実行するため、ユーザーの入力を必要としないプログラムを選んでください。
    * **IAM Identity Center**：`credential_process` の代わりに、プロファイルの [IAM Identity Center 設定](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-sso.html)を追加します。接続する前と、そのサインインの期限が切れたときに、ターミナルで `aws sso login --profile corp` を実行します。
  </Step>

  <Step title="ProxyCommand でプロファイルを指定する">
    次の例では、[AWS が Session Manager 用にドキュメントで示しているコマンド](https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-getting-started-enable-ssh-connections.html)に `--profile` を追加します：

    ```text ~/.ssh/config theme={null}
    Host i-*
      ProxyCommand sh -c "aws ssm start-session --profile corp --target %h --document-name AWS-StartSSHSession --parameters 'portNumber=%p'"
    ```
  </Step>

  <Step title="再度接続する">
    ターミナルでホストを指定して `ssh` を実行し、エントリがそこで引き続き接続できることを確認してから、Desktop から接続します。
  </Step>
</Steps>

<h5 id="raise-the-ssh-connection-timeout">
  SSH 接続のタイムアウトを延長する
</h5>

SSH 設定でホストに `ConnectTimeout` が設定されていない場合、Desktop は `ssh` に接続のための 30 秒を与えます。ジャンプホストまたは `ProxyCommand` を経由する場合、この時間にはルートの接続にかかる時間が含まれます。ルートにそれ以上の時間が必要な場合は、エントリにより大きな値を追加します：

```text ~/.ssh/config theme={null}
Host devbox
  HostName devbox.internal.example.com
  User alice
  ProxyJump bastion.example.com
  ConnectTimeout 120
```

`ssh` はホストに対して最初に見つかった値を使用するため、このエントリは `ConnectTimeout` を設定する `Host *` エントリよりも上に配置してください。確認するには、コンピューターのターミナルで `ssh -G devbox` を実行します。その出力には `connecttimeout 120` が含まれます。値を変更した後は、Desktop を終了して再度開いてください。

リモートマシン自体がスマートフォンでの承認を待つ場合は、`ConnectTimeout` の設定にかかわらず、45 秒以内に承認してください。Desktop が `ServerAliveInterval` と `ServerAliveCountMax` を独自に設定し、リモートマシンがその間何も送信しないログインを `ssh` が閉じるため、この制限は延長できません。代わりにジャンプホストまたは `ProxyCommand` がユーザーを待つ場合は、リモートマシンのエントリの `ConnectTimeout` を延長して、その時間をカバーしてください。

<h5 id="fix-a-match-host-block-that-only-desktop-applies">
  Desktop だけが適用する `Match host` ブロックを修正する
</h5>

ターミナルの `ssh devbox` では使用されない設定を Desktop が使用する場合は、エントリの `HostName` 行より上にある `Match host` ブロックを探してください。ターミナルでは、`ssh` はその位置のブロックを `HostName` 行より前に読み取るため、ブロックを `devbox` と比較します。Desktop はコマンドラインで `ssh` に `HostName` の値を渡すため、`ssh` はブロックをその値と比較します。

確認するには、Desktop と同様に、エントリの `HostName` と `User` の値をコマンドラインで指定して、コンピューターのターミナルで `ssh -G` を実行します：

```bash theme={null}
ssh -G -o HostName=devbox.internal.example.com -l alice devbox
```

その出力を `ssh -G devbox` の出力と比較します。`proxycommand` などのブロックの設定が最初の出力にのみ表示される場合、そのブロックは Desktop でのみ有効になります。Desktop でもスキップされるようにするには、その `Match` 行に `!originalhost devbox` を追加します：

```text ~/.ssh/config theme={null}
Match host *.internal.example.com !originalhost devbox
```

確認するには、最初のコマンドを再度実行します。ブロックの設定は出力に表示されなくなります。

<h5 id="forwarding-settings-that-desktop-leaves-off">
  Desktop がオフにする転送設定
</h5>

リモートマシンへの接続では、SSH 設定でオンになっている場合でも、Desktop は `ForwardAgent`、`ForwardX11`、`LocalForward`、`RemoteForward`、`DynamicForward`、`Tunnel` をオフのままにします。[ターミナル](#run-commands-in-the-terminal)や `!` コマンドでは、Desktop がそれらの設定に従う別の `ssh` を起動することがあるため、転送設定は[一部の場合にのみ](#limits-while-desktop-is-disconnected)適用されると考えてください。

* **リモートマシン上のポートに接続するには**：[自分で転送します](#reach-a-port-on-the-remote-machine)
* **リモートマシンから自分の鍵を使用するには**：`git push` 用など、リモートマシン自体に認証情報を設定します

Desktop が SSH エージェントやポートを転送しないようにするには、コンピューターのターミナルで `ssh -G devbox` を実行します。次に、出力された `hostname` と `user` の値を使用して、`ssh -G -o HostName=devbox.internal.example.com -l alice devbox` のように、Desktop が実行しうる形でもう一度実行します。2 回目の出力には、1 回目ではスキップされる `Match` ブロックの設定が表示されることがあります。

両方の出力で、`no` 以外の値を示す `forwardagent` 行と、`localforward`、`remoteforward`、または `dynamicforward` で始まる行を探します。見つかった場合は、その設定を SSH 設定から削除してください。`ProxyCommand` が `ssh` で接続するホストについても同様に行ってください。

<h4 id="reach-a-port-on-the-remote-machine">
  リモートマシン上のポートに接続する
</h4>

ポート 3000 の dev サーバーなど、リモートマシンで実行されているサーバーを開くには、ポートを自分で転送します。コンピューターのターミナルで、`-L` と接続先のホスト（`devbox` など）を指定して `ssh` を実行します：

```bash theme={null}
ssh -N -L 3000:localhost:3000 devbox
```

接続で **SSH port** または **SSH key (optional)** を入力した場合は、同じ値で `-p` または `-i` を追加します。そのコマンドを実行したままにし、コンピューターのブラウザで `http://localhost:3000` を開くと、リモートマシンのポート 3000 に接続できます。`ssh` が `open failed: administratively prohibited` と出力した場合は、マシンの管理者に TCP 転送を許可するよう依頼してください。TCP 転送は SSH サーバーの `sshd_config` の `AllowTcpForwarding` で制御されます。

<h4 id="windows-remote-machines">
  Windows リモートマシン
</h4>

Windows リモートマシンには Claude Desktop v2.31226.0 以降が必要です。

Microsoft の OpenSSH Server を使用してください。マシンは x64 と ARM64 のどちらでもかまいません。SSH サーバーが起動するシェルには、`cmd.exe`、Windows PowerShell 5.1、または Git Bash を使用できます。

Windows リモートマシンは、Linux リモートマシンに比べてテストが少なくなっています。依存する前に、そこで自分の作業を試してください。

Windows リモートマシンでは、特に次のような制限があります：

* **ターミナル**：フォルダが `C:/projects/app` のような Windows パスであるセッションでは、[ターミナル](#run-commands-in-the-terminal)は開きません
* **サンドボックス**：Claude Code はそこではネイティブ Windows 上で実行され、コマンドはサンドボックス化されずに実行されます。[サンドボックスが実行される場所](/docs/ja/sandboxing)を参照してください。
* **プラグイン**：Desktop は、`:` を含む名前など、Windows で保存できないファイル名またはフォルダ名を含むプラグインをコピーしません。セッションには、Desktop が除外したプラグインが一覧表示されます。
* **MCP サーバー**：一部の Windows リモートマシンでは、`claude_desktop_config.json` の MCP サーバーに対する Claude の呼び出しが Desktop を経由するため、[Desktop が切断されている間](#limits-while-desktop-is-disconnected)は Claude がそれらのツールを呼び出せません。Claude Desktop v2.37337.0 より前では、これはすべての Windows リモートマシンに当てはまります。
* **worktree**：worktree は `<project-root>/.claude/worktrees/` に作成されます。[別のフォルダを選択](#choose-where-ssh-session-worktrees-go)しても、Desktop はそれを無視します。
* **以前のメッセージ**：SSH サーバーのシェルが `cmd.exe` または Windows PowerShell の場合、セッションの以前のメッセージを表示するには、接続が必要になることがあります
* **フォーク**：SSH サーバーのシェルが `cmd.exe` または Windows PowerShell の場合、セッションをフォークできるのは最初のメッセージの時点のみです
* **切断中の実行**：タスクが [Desktop の切断中も実行を続ける](#keep-a-task-running-while-desktop-is-disconnected)のは、プログラムを起動した接続が終了した後もそのプログラムが存続することを SSH サーバーが許可している場合のみです。確認するには、[リモートマシンをテスト](#prepare-a-long-task)してください。
* **残存プロセス**：セッションの終了後も、Claude Code が起動したプログラムが実行を続けている可能性があるため、マシンを確認してください。Desktop がインストールする[バックグラウンドヘルパー](#keep-a-task-running-while-desktop-is-disconnected)は、そこでは自動的に停止しません。

<h4 id="keep-a-task-running-while-desktop-is-disconnected">
  Desktop の切断中もタスクを実行し続ける
</h4>

コンピューターがスリープした場合、ネットワークが切断された場合、または Desktop を終了した場合でも、タスクは完了するか、ユーザーの対応が必要になるか、いずれかの[制限](#limits-while-desktop-is-disconnected)に達するまで続行されます。蓋を閉じることはスリープとみなされます。アップデートのためのものを含め、Desktop またはコンピューターの再起動は終了とみなされます。

Claude Code は、Desktop がリモートマシンにインストールするバックグラウンドヘルパーの下でプロセスとして実行されるため、実行を続けるのに SSH 接続は必要ありません。このセクションで説明する動作には Claude Desktop v2.31226.0 以降が必要です。

<Warning>
  Claude アカウントで Desktop にサインインしている場合、タスクが一晩中実行されることを当てにしないでください。Desktop は、Desktop が実行中かつ接続中の間のみタスクのサインインを更新するため、切断後にタスクのサインインの期限が切れ、タスクが停止することがあります。切断時に残っている時間は状況によって異なり、数分しかない場合もあります。

  それまでに行われた作業はリモートマシンに残り、戻ったときにメッセージを送信して続行できます。

  タスクを夜通し実行する必要がある場合：

  * [コンピューターをスリープさせず](/docs/ja/desktop-scheduled-tasks#how-scheduled-tasks-run)オンラインの状態に保ち、蓋を開けたまま Desktop を実行しておきます
  * リモートマシンと経由するすべてのジャンプホストに対して、SSH エージェントが保持する鍵など、プロンプトなしで機能するログインを使用します。これにより、接続が切れた後に Desktop が自動的に再接続できます。

  コンピューターがスリープ中または電源オフの間も実行する必要があるタスクの場合は、代わりに[クラウドセッション](#run-long-running-tasks-in-the-cloud)を開始してください。
</Warning>

* **スリープまたはネットワーク切断の後**：プロセスが[まだ実行されて](#limits-while-desktop-is-disconnected)おり、Desktop がプロンプトなしでログインできる場合、実行中のタスクに戻れます。ログインできない場合は、[メッセージを送信](#reconnect-after-sleep-or-a-network-loss)してください。
* **終了後、macOS または Linux の Desktop で Claude アカウントを使用している場合**：Desktop が[プロセスに再参加](#reopen-a-session-after-you-quit-desktop)できれば、実行中のタスクに戻れます。再参加できない場合、タスクは停止します。停止したままの場合は、メッセージを送信してください。
* **終了後、Windows の Desktop または[サードパーティプロバイダー](/docs/ja/third-party-integrations)を使用している場合**：Desktop はセッションを開いたときにプロセスを終了するため、実行中のタスクは失われます。続行するにはメッセージを送信してください。

戻ったときにタスクが完了していない場合は、Desktop が再接続できないという知らせ、認証エラー、または待機中のリクエストがないか確認してください：

* **Desktop が再接続できない**：セッションにその理由が表示され、通知でも知らされることがあります。Desktop は[ログインを必要とする](#reconnect-after-sleep-or-a-network-loss)場合があります。
* **認証エラー**：[サインイントークンまたは認証情報](#limits-while-desktop-is-disconnected)の期限が切れている可能性があります。Claude アカウントの場合は、メッセージを送信して続行します。サードパーティプロバイダーの場合は、[SSH remote sessions in Claude Desktop on 3P](https://claude.com/docs/third-party/claude-desktop/ssh-remote-sessions) を参照してください。
* **待機中のリクエスト**：[それに応答します](#handle-requests-that-arrive-while-you-are-away)
* **いずれにも該当しない**：メッセージを送信して続行します

<a id="prepare-a-long-task" />

<h5 id="prepare-a-long-task">
  長いタスクを準備する
</h5>

* **先に更新する**：長いタスクを開始する前に Desktop を更新してください。macOS と Windows では、Desktop はダウンロード済みのアップデートをインストールするために自動的に再起動することがあります。この再起動は、Claude が SSH タスクに取り組んでいる間は待機します。macOS で Claude アカウントを使用している場合、デフォルトでは、アップデートが 72 時間待機した後は、それでも再起動が実行されることがあります。
* **Desktop を終了しない**：Desktop が Windows で実行されている場合、またはサードパーティプロバイダーを使用している場合は、長いタスクの実行中は Desktop を開いたままにしてください。終了した場合、Desktop はセッションを開いたときに[実行中のタスクを終了します](#reopen-a-session-after-you-quit-desktop)。開いたままにしても、[ユーザーを待機している](#handle-requests-that-arrive-while-you-are-away)リクエストは保護されません。
* **リクエストを減らす**：[タスクがユーザーを待つ頻度を減らす](#handle-requests-that-arrive-while-you-are-away)権限モード、ルール、またはフックを選択します
* **ジャンプホストを確認する**：ジャンプホストがサインイン（スマートフォンへのプッシュ通知など）を求める場合は、プロンプトなしで機能するログインに切り替えてください。そうしないと、Desktop は再接続を試みるたびに別のプッシュ通知を送信する可能性があります。
* **リモートマシンをテストする**：短いタスクを開始し、タスクの実行中に Desktop を終了して、タスクが完了しているはずの時刻を十分に過ぎてからセッションを再度開きます。タスクが完了しておらず、セッションに認証エラーが表示されていない場合は、リモートマシンで[タスクを終了させうる要因](#limits-while-desktop-is-disconnected)を確認してください。
* **Desktop のターミナルでコマンドを実行しない**：リモートマシンが[アイドル状態のターミナルをログアウトさせる](#limits-while-desktop-is-disconnected)場合は、Desktop の外部からの SSH ログインで独自のコマンドを実行してください

<a id="limits-while-desktop-is-disconnected" />

<h5 id="limits-while-desktop-is-disconnected">
  Desktop の切断中の制限
</h5>

実行したままにしたタスクは、サインインの期限が切れたとき、リモートマシンがタスクを終了させたとき、またはヘルパーが停止または置き換えられたときに終了することがあります：

* **サインイントークンまたは認証情報**：Claude アカウントの場合、トークンの期限が切れるとタスクは認証エラーで停止します。サードパーティプロバイダーの場合は、シングルサインオンや認証情報ヘルパーから取得したものなど、期限が切れる認証情報にも同じことが当てはまります。[SSH remote sessions in Claude Desktop on 3P](https://claude.com/docs/third-party/claude-desktop/ssh-remote-sessions) を参照してください。Claude アカウントの場合は、Desktop がサインインを更新できるように、[Desktop を実行して接続したままにしてください](#keep-a-task-running-while-desktop-is-disconnected)。
* **リモートマシン**：リモートマシンが再起動した場合、または SSH 接続が閉じたときにプロセスを終了させる場合、実行中のタスクは終了します。Desktop が切断されている間、タスクが再開されることはありません。systemd-logind の `KillUserProcesses` が `yes` で、それがユーザーに適用される Linux マシンでは、この方法でプロセスが終了されます。そこでタスクを実行し続けるには、`KillExcludeUsers` などでユーザーを除外するよう管理者に依頼してください。
* **アイドル状態のターミナル**：一部の Linux リモートマシンは、一定時間誰も入力しないターミナルをログアウトさせます（systemd-logind の `StopIdleSessionSec`）。macOS または Linux の Desktop では、セッションの[ターミナル](#run-commands-in-the-terminal)と `!` コマンドは、デフォルトで Desktop の SSH 接続を共有します。その場合、このログアウトによって Desktop の接続中に接続が終了し、実行中のタスクも一緒に終了することがあります。ターミナルペインを閉じても防げないため、[そのターミナルでコマンドを実行しないでください](#prepare-a-long-task)。
* **Desktop のアップデート**：アップデートで新しいヘルパーが導入された場合、Desktop は後の接続時にリモートマシン上のヘルパーを置き換えるため、まだ実行中のタスクが終了することがあります
* **長期間の不在**：Linux または macOS のリモートマシンで、Desktop が 30 日間接続しない場合、ヘルパーは停止し、その下で実行されているすべての Claude Code プロセスを終了します。それまでに接続してください。

ファイルの編集と一部のツールは、Desktop が切断されている間に失敗することがあります。タスクでそれらが必要な場合は、Desktop を接続したままにしてください：

* **worktree**：[worktree](#work-in-parallel-with-sessions) を使用するセッションでは、Desktop は Claude がファイルを編集する前に各編集をチェックします。Desktop が切断されている間、各編集は約 30 秒待機した後に失敗します。シェルコマンドは引き続き実行されます。Linux または macOS のリモートマシンでは、[編集が引き続き機能する場合があります](#worktree-edits-while-disconnected)。不明な場合は、worktree を使用せずにセッションを開始してください。
* **フォルダの制限**：組織がセッションで使用できるフォルダを制限している場合、Desktop は worktree の有無にかかわらず、各ファイルの読み取り、検索、編集をチェックします。Desktop が切断されている間、それぞれ最大 10 分間待機した後に失敗します。
* **コネクタ**：[コネクタ](#connect-external-tools)および Desktop が提供するその他のツールは Desktop を経由して実行されるため、Desktop が切断されている間は各呼び出しが約 30 秒後に失敗します
* **ワークフロー**：Desktop は新しい[ワークフロー](/docs/ja/workflows)をそれぞれ開始前にチェックするため、Desktop が切断されている間、新しいワークフローは最大 10 分間待機した後に失敗します
* **MCP サーバー**：Claude Code がリモートマシンで起動する MCP サーバーは Desktop を経由しないため、Claude は引き続きそれらのツールを呼び出せます。`claude_desktop_config.json` のサーバーがこれに含まれるのは、Desktop が[組み込みの SSH クライアント](#worktree-edits-while-disconnected)を使用していない場合のみです。それ以外の場合、および[一部の Windows リモートマシン](#windows-remote-machines)では、Desktop が切断されている間、Claude はそれらのツールを呼び出せません。

<span id="worktree-edits-while-disconnected" />

<Accordion title="worktree 内の編集が引き続き機能する場合">
  Linux または macOS のリモートマシンでは、チェックが Desktop を経由しないため、Desktop が切断されている間も worktree 内の編集は引き続き機能します。Claude Desktop v2.37337.0 より前では、これは Linux リモートマシンにのみ当てはまります。

  次のような場合には、編集は引き続き失敗します：

  * **組み込みの SSH クライアント**：Desktop がそれを使用している場合。たとえば、Microsoft Store からのインストール、Microsoft の OpenSSH 9.4 以降がない Windows コンピューター、またはサードパーティプロバイダーを使用する Windows でのデフォルトの場合です
  * **リポジトリの場所**：リポジトリがホームディレクトリ、その上位のフォルダ、または `~/.claude` である
  * **macOS のパス**：macOS のリモートマシンで、リポジトリが `/Volumes` の下にある、またはリポジトリもしくは worktree のパス内のフォルダ名に `~` または非 ASCII 文字が含まれている
  * **フォルダの制限**：組織がセッションで使用できるフォルダを制限している
  * **企業ランチャー**：Claude Desktop v2.37337.0 より前で、Claude アカウントでサインインしており、組織が[企業ランチャー](/docs/ja/corporate-launcher)を介してリモートマシンで Claude Code を起動している

  worktree を使用しないセッションには、組織がセッションで使用できるフォルダを制限していない限り、このようなチェックはありません。
</Accordion>

<a id="handle-requests-that-arrive-while-you-are-away" />

<h5 id="handle-requests-that-arrive-while-you-are-away">
  不在中に届いたリクエストに対応する
</h5>

Desktop が切断されている間に Claude が承認を必要とするか質問をした場合、Claude はリモートマシン上で待機します。この待機自体には時間制限はありません。Desktop がプロセスに再参加すると、リクエストが表示されます。Desktop が代わりに新しいプロセスを開始した場合、リクエストは失われます。

タスクがユーザーを待機している間に、Desktop はアップデートのインストールなどのために自動的に再起動することがあります。Desktop が Windows で実行されている場合、またはサードパーティプロバイダーを使用している場合、その再起動後にリクエストは失われます。

リクエストが失われた場合は、メッセージを送信して続行してください。

タスクがユーザーを待つために停止する頻度を減らし、不在中にタスクからの知らせを受け取るには、離れる前に次のいずれかを設定してください：

* **auto モード**：[利用可能な場合](#auto-mode-availability)は [auto モード](#choose-a-permission-mode)を選択します。ブロックが繰り返されると、[再度確認が求められます](/docs/ja/permission-modes#when-auto-mode-falls-back)。
* **許可ルール**：リモートマシン上のユーザー設定ファイル `~/.claude/settings.json` に、タスクに必要なコマンドの[許可ルール](/docs/ja/permissions#manage-permissions)を追加します。組織が[管理設定からの権限ルールのみを受け入れる](/docs/ja/settings-reference#allowmanagedpermissionrulesonly)場合は、リモートマシンに適用される[管理設定](#managed-settings)にそれらを追加するよう管理者に依頼してください。プロジェクトの `.claude/settings.json` の許可ルールについては、[プロジェクトの許可ルールとワークスペースの信頼](/docs/ja/permissions#project-allow-rules-and-workspace-trust)を参照してください。
* **応答するフック**：リモートマシン上の `~/.claude/settings.json` に [`PermissionRequest` フック](/docs/ja/hooks#permissionrequest)を設定し、ユーザーに代わってリクエストを許可または拒否します
* **通知するフック**：同じファイルに `permission_prompt` matcher を使用した [`Notification` フック](/docs/ja/hooks#notification)を設定し、リクエストが待機しているときに自分宛てにメッセージを送信します
* **Claude の完了を知らせるフック**：同じファイルに [`Stop` フック](/docs/ja/hooks#stop)を設定し、Claude が応答を終えたときに自分宛てにメッセージを送信します。API エラーによってターンが終了した場合は実行されません。その場合は、[`StopFailure` フック](/docs/ja/hooks#stopfailure)を設定してください。

組織が[管理フックのみを実行する](/docs/ja/settings-reference#allowmanagedhooksonly)場合は、リモートマシンに適用される[管理設定](#managed-settings)にフックを追加するよう管理者に依頼してください。

Claude Code は、Bypass permissions を含むどの権限モードでも、[いくつかのアクション](/docs/ja/permission-modes#actions-no-mode-auto-approves)を自動承認しません。権限モードに応じて、Claude Code はそのようなアクションを拒否するかユーザーに確認し、タスクはユーザーの回答を待機します。

<a id="reconnect-after-sleep-or-a-network-loss" />

<h5 id="reconnect-after-sleep-or-a-network-loss">
  スリープまたはネットワーク切断の後に再接続する
</h5>

戻ったときに Desktop が再接続していない場合は、セッションでメッセージを送信してください。Desktop が自動的に再接続するのは、SSH エージェントが保持する鍵などを使用して、プロンプトなしでログインできる場合のみです。

* **記憶されたパスワード**：Desktop に記憶させたパスワードもプロンプトなしで機能しますが、長期間不在にする場合は SSH エージェントが保持する鍵を使用することをお勧めします。そのパスワードでのサインインが途中で切れたり応答しなくなったりする場合、Desktop は再接続を停止してユーザーを待つことがあります。
* **その他のプロンプト**：リモートマシンがワンタイムコードなど、その他の入力を求める場合、コンピューターに通知が届くことがあります。通知をクリックするか、セッションでメッセージを送信すると、Desktop にプロンプトが表示されます。

<Accordion title="ジャンプホストがサインインを求める場合、停止が長い場合、出力が欠落している場合、またはプロセスが存在しない場合">
  - **ジャンプホスト、不在中にプッシュ通知が止まる**：これは、ジャンプホストのサインイン（スマートフォンへのプッシュ通知など）に誰も応答しない場合に、macOS または Linux の Desktop で発生することがあります。その場合、Desktop はコンピューターの前に誰もいない間は再接続を停止します。コンピューターのロックを解除するか使用すると、Desktop が再試行できるため、別のプッシュ通知が届くことがあります。応答のない試行が 3 回続くと、ユーザーが再試行するかメッセージを送信するまで待機します。
  - **ジャンプホスト、プッシュ通知が届き続ける**：Windows の Desktop のように、Desktop が誰も応答していないことを判別できない場合、再参加するプロセスがある間は、そのプロセスがまだ実行中かどうかにかかわらず試行を続けます。試行のたびに別のプッシュ通知が届くことがあります。試行を終了するには Desktop を終了しますが、その場合は[実行中のタスクが失われる可能性があります](#reopen-a-session-after-you-quit-desktop)。
  - **長時間の停止**：Desktop は約 5 分ごとに 1 回の試行にペースを落とします。早く再接続するには、セッションで再試行するか、メッセージを送信します。メッセージは接続後に Desktop が配信します。
  - **出力の欠落**：Desktop が切断されている間、ヘルパーは各セッションの最新の Claude Code 出力を 16 MiB のバッファに保持し、それより古い出力は破棄します。Desktop が再接続した後、セッションに `Loading recent output from <host>…` と表示されることがあります。Desktop がすべての出力を読み込めない場合は、`Some output produced while you were disconnected may be missing here.` という行が表示されます。この行はタスクが停止したことを意味するものではありません。
  - **プロセスが存在しない**：Desktop の再接続時にプロセスが存在しない場合、Desktop は会話の保存された履歴から新しいプロセスを開始し、タスクを続行するよう Claude に指示することがあります。プロセスが繰り返し終了する場合、または Desktop がサードパーティプロバイダーを使用している場合、Desktop はタスクを自動的に続行しません。メッセージを送信して続行してください。
</Accordion>

<a id="reopen-a-session-after-you-quit-desktop" />

<h5 id="reopen-a-session-after-you-quit-desktop">
  Desktop を終了した後にセッションを再度開く
</h5>

Desktop を終了した後も、タスクはリモートマシン上で、完了するか、ユーザーの対応が必要になるか、いずれかの[制限](#limits-while-desktop-is-disconnected)に達するまで実行を続けます。

* **macOS または Linux の Desktop で Claude アカウントを使用している場合**：Desktop を起動してセッションを開きます。Desktop がプロセスに再参加できると、実行中のタスクに戻れます。一部の Desktop アップデートの後や、組織が管理設定を変更した後など、常に再参加できるとは限りません。
* **macOS または Linux で、Desktop が再参加できない場合**：Desktop はプロセスを終了し、会話の保存された履歴から新しいプロセスを開始します。実行中のタスクは停止し、待機していた承認や質問は失われます。アップデートの後は、Desktop がその後 Claude に続行を指示することがあります。タスクが停止したままの場合は、メッセージを送信してください。
* **Windows の Desktop、または任意のプラットフォームでサードパーティプロバイダーを使用している場合**：タスクが完了していると見込まれるときにのみ Desktop を再起動してください。Desktop は終了後に再参加することがないため、実行中のタスクには戻れません。Desktop はセッションを開いたときにプロセスを終了し、これは Desktop の起動時に発生することがあります。メッセージを送信して続行してください。

サードパーティのデプロイについては、[SSH remote sessions in Claude Desktop on 3P](https://claude.com/docs/third-party/claude-desktop/ssh-remote-sessions) を参照してください。

<Warning>
  会話の Claude Code プロセスがまだ実行されている間は、リモートマシン上でその会話に対して [`claude --resume`](/docs/ja/cli-reference#cli-flags) を実行しないでください。Claude Code はそれを阻止せず、両方のプロセスが同じ会話に書き込むことになります。不明な場合は `--fork-session` を追加すると会話のコピーで続行されますが、両方のプロセスは引き続き同じファイルを操作します。
</Warning>

<h4 id="choose-where-ssh-session-worktrees-go">
  SSH セッションの worktree の作成場所を選択する
</h4>

組織がセッションで使用できるフォルダを制限していない限り、新しい SSH セッションは、次のうち最初に設定されている場所に [worktree](#work-in-parallel-with-sessions) を作成します：

1. SSH 接続の **Worktree folder**
2. リモートマシン上の `~/.claude/settings.json` にある [`worktree.location`](/docs/ja/settings-reference#worktree-location)
3. デフォルトの `<project-root>/.claude/worktrees/`

設定したフォルダ内には各プロジェクト専用のサブフォルダが作成されるため、`~/worktrees` を設定した場合、worktree のパスは `~/worktrees/<project>-<id>/<worktree-name>` になります。設定したフォルダがプロジェクト内にある場合、Desktop はそのプロジェクトではそのフォルダを無視し、デフォルトを使用します。[Windows リモートマシン](#windows-remote-machines)では、Desktop は常にデフォルトを使用します。

以前に追加した接続、または組織が管理する接続に **Worktree folder** を設定するには、環境ドロップダウンでその接続にマウスを合わせて、ギアアイコンをクリックします。

このフィールドには Claude Desktop v1.44121.0 以降が必要です。組織がセッションで使用できるフォルダを制限している場合、Desktop はこのフィールドを非表示にし、worktree をプロジェクト内に作成します。

<h4 id="files-and-processes-on-the-remote-machine">
  リモートマシン上のファイルとプロセス
</h4>

Desktop は、Linux または macOS のリモートマシンに接続する各ユーザーのホームディレクトリの `~/.claude/remote/` の下に、ヘルパープログラムと Claude Code をインストールします。ヘルパーはどのネットワークポートもリッスンしませんが、Claude Code と、MCP サーバーや開発サーバーなど Claude Code が起動するプログラムはリッスンすることがあります。

| フォルダ | 内容 |
| - | - |
| `~/.claude/remote/srv/` | ヘルパー（バージョンごとに 1 つのフォルダ） |
| `~/.claude/remote/ccd-cli/` | Claude Code（バージョンごとに 1 つのファイル） |
| `~/.claude/remote/run/` | ソケットやログなど、ヘルパーのランタイムファイル（接続するコンピューターごとに 1 つのフォルダ） |
| `~/.claude/remote/plugins/` | Desktop がユーザーのコンピューターからコピーするプラグイン |
| [`~/.claude/uploads/`](/docs/ja/claude-directory#clear-local-data) | ユーザーがメッセージに添付するファイル（セッションごとに 1 つのフォルダ） |

1 人のユーザーのプロセスを一覧表示するには、リモートマシン上でそのユーザーとして `pgrep -fl "$HOME/.claude/remote/"` を実行するか、`$HOME` の代わりにそのユーザーのホームディレクトリを指定して実行します：

* **ヘルパー**：接続するコンピューターごとに 1 つ以上の `server` プロセス
* **Claude Code**：ヘルパーがユーザーのセッションのために起動するプロセス。それぞれ `2.1.295-…` のように、バージョンにちなんだ名前のファイルから起動されます

Desktop は、ユーザーの SSH 接続を通じて、`~/.claude/remote/run/` の下にあるヘルパーのフォルダ内の Unix ソケット `rpc.sock` を経由してヘルパーに到達します。ソケットのモードは 600、そのフォルダのモードは 700 であるため、root を除き、マシン上の他のユーザーはそのソケットに接続できません。

ヘルパーが自動的に停止する場合については、[Desktop の切断中の制限](#limits-while-desktop-is-disconnected)を参照してください。

1 人のユーザーのヘルパーと Claude Code を削除するには：

<Steps>
  <Step title="Desktop を終了する">
    ユーザーが接続する各コンピューターで Desktop を終了します。Desktop は次回接続時に両方のプログラムを再度インストールし、自動的に再接続することがあります。
  </Step>

  <Step title="プロセスを終了する">
    リモートマシンにそのユーザーとしてログインし、[`pgrep`](#files-and-processes-on-the-remote-machine) が一覧表示する各 Claude Code プロセスの ID を指定して `kill` を実行します。それらが一覧から消えたら、各 `server` プロセスの ID を指定して `kill` を実行します。先に `server` プロセスを終了すると、Claude Code が実行中のコマンドが実行を続けることがあります。

    次に、`ps -u "$(id -un)" -f` などでユーザーの残りのプロセスを一覧表示し、Claude Code が起動したと分かるものを終了します。Claude Code がバックグラウンドに残したプログラムは、`pgrep` の一覧に含まれないまま、Claude Code の終了後も実行を続けることがあります。
  </Step>

  <Step title="フォルダを削除する">
    `~/.claude/remote/` を削除します。`~/.claude/` と `~/.claude.json` にある Claude Code 自体のファイルを削除するには、[設定ファイルを削除する](/docs/ja/setup#remove-configuration-files)を参照してください。
  </Step>
</Steps>

<h5 id="end-one-session’s-process">
  1 つのセッションのプロセスを終了する
</h5>

1 つのセッションの Claude Code プロセスを終了するには、Desktop がリモートマシンに接続している間に、Desktop で[セッションをアーカイブ](#work-in-parallel-with-sessions)します。プロセスは、タスクの完了後も、Desktop を終了した後も実行を続けます。

worktree を持つセッションをアーカイブする前に、[セッションで並行作業する](#work-in-parallel-with-sessions)を参照してください。

<h5 id="see-which-user-the-processes-run-as">
  プロセスを実行するユーザーを確認する
</h5>

ヘルパーと Claude Code は、Desktop が SSH でログインするユーザーとして実行されます。これらのインストールと起動に `sudo` は必要ありません。ユーザーを確認するには、[`pgrep`](#files-and-processes-on-the-remote-machine) が一覧表示するプロセス ID を指定して、リモートマシンで `ps -o user= -p` を実行します。

シェルコマンドや MCP サーバーなど、Claude Code が起動するプログラムも、そのユーザーとして起動します。そこでコマンドを実行する人に対して行うのと同様に、`sudo` ルールを含め、リモートマシン上のそのユーザーの権限を確認してください。

<h5 id="see-who-connected-to-the-remote-machine">
  リモートマシンに接続したユーザーを確認する
</h5>

リモートマシンに誰が接続したかを確認するには、そのマシン上の SSH サーバーのログを読みます。ログでは、Desktop からのログインはターミナルからのログインと同じように表示されます。macOS または Linux の Desktop では、エントリはセッションごとではなく、Desktop が接続するたびに記録されます。

<h4 id="use-mcp-servers-set-up-on-the-remote-machine">
  リモートマシンで設定した MCP サーバーを使用する
</h4>

SSH セッションで `~/.claude.json` またはプロジェクトの `.mcp.json` の [MCP サーバー](/docs/ja/mcp)を使用するには、リモートマシン上のそれらのファイルで設定します。Claude Code はそれらの stdio サーバーをリモートマシンで起動するため、それらのサーバーが実行するコマンドをリモートマシンにインストールしてください。`claude_desktop_config.json` のサーバーについては、[Desktop の切断中の制限](#limits-while-desktop-is-disconnected)を参照してください。

<h4 id="open-an-ssh-session-from-a-link">
  リンクから SSH セッションを開く
</h4>

`claude://code/new` リンクは Desktop の新規セッションページを開き、SSH 接続を指定することもできます。このようなリンクを runbook、ダッシュボード、または wiki ページに置いておくと、適切なマシンとフォルダが設定された状態で Desktop を開けます。このようなリンクを除去するプラットフォームについては、[リンクがクリック可能にならずプレーンテキストとして表示される](/docs/ja/deep-links#the-link-renders-as-plain-text-instead-of-being-clickable)を参照してください。

SSH リンクには Claude Desktop v2.110.0 以降が必要です。

次のリンクは、`build.example.com` のユーザー `dev`、ポート 2222、フォルダ `/srv/payments` を指定し、プロンプトを入力します：

```text theme={null}
claude://code/new?ssh_host=dev%40build.example.com&ssh_port=2222&ssh_folder=/srv/payments&q=Investigate%20the%20failed%20deploy
```

SSH リンクは次のパラメータを受け取り、必須なのは `ssh_host` のみです：

| パラメータ | 値 |
| :- | :- |
| `ssh_host` | `host` または `user@host`。**SSH host** フィールドと同じ形式で記述します。値を `-` で始めることはできず、ホスト部分には英字、数字、`.`、`_`、`:`、`-` のみを使用できます |
| `ssh_port` | 1 から 65535 までのポート番号 |
| `ssh_folder` | リモートマシン上のフォルダ。`/` または `~/` で始めるか、`~` を使用します |
| `q` | プロンプトボックスに入力する URL エンコードされたテキスト |

`~/.ssh/config` のエイリアスは、そのエントリを持っているユーザーに対してのみ `ssh_host` として機能します。ユーザーがすでに持っている接続と一致させるには、その接続と同じユーザー、ホスト、ポートをリンクに指定します。

リンクを開くと、Desktop は接続を選択する前に確認を求めます：

* **既存の接続**：ホスト、ユーザー、ポートが既存の接続のいずれかと一致する場合、Desktop はその接続を使用するかどうかを確認し、接続の名前とホスト、およびリンクでフォルダが指定されている場合はそのフォルダを表示します。
* **新しい接続**：それ以外の場合、Desktop は SSH 接続を追加するダイアログを開きます。接続を追加すると、Desktop は何かを保存する前に接続するかどうかを確認し、リンクのホスト、およびリンクでポートとフォルダが指定されている場合はそれらを表示します。

確認するまで、Desktop はリンクのホスト、ポート、フォルダを保存せず、それらを使用して接続を選択したり開いたりすることもありません。SSH 接続がすでに選択されている場合、新規セッションページは、リンクがない場合と同様に、リンクが同じホストを指定している場合でも、その接続に独自に接続することがあります。リンクにキーファイル、パスワード、コマンドを含めることはできません。

リンクは誰でも作成できるため、入力された内容を確認してください：

* **確認する前に**：ホストとフォルダを確認します。
* **送信する前に**：プロンプトと選択されている環境を確認します。

Desktop はリンクを開いたときに、未送信のテキストを置き換えてプロンプトを入力しますが、自動で送信することはありません。プロンプトはプレーンテキストとして扱われるため、先頭の `/` や `!`、`@` によるファイルメンションは、コマンドやメンションとして機能しません。キャンセルした場合、プロンプトはボックスに残り、選択していた環境は変更されません。

リンクによって [`sshHostAllowlist`](#restrict-which-ssh-hosts-users-can-connect-to) を回避することはできません。Desktop は接続時に許可リストを確認します。

リンクを開いても接続に関するダイアログが表示されずに Desktop が開く場合は、次のいずれかの原因を確認してください：

* **サインアウトしている**：サインインしてから、もう一度リンクを開きます。
* **別のダイアログが開いている**：そのダイアログを閉じてから、もう一度リンクを開きます。
* **リンクが無効である**：Desktop は修正すべき点を示すメッセージを表示し、プロンプトは入力しません。
* **Desktop が v2.110.0 より古い**：以前のバージョンは SSH パラメータを無視し、プロンプトのみを入力した状態で新規セッションページを開きます。
* **SSH セッションがオフになっている**：管理者が許可リストを空の配列に設定している場合、Desktop は SSH リンクを拒否します。

<h4 id="pre-configure-ssh-connections-for-your-team">
  チームの SSH 接続を事前設定する
</h4>

管理者は、[管理設定](/docs/ja/managed-settings)で `sshConfigs` を設定することで、SSH 接続をチームメンバーに配布できます。この方法で定義された接続は、各ユーザーの環境ドロップダウンに自動的に表示され、管理対象として表示されます。ユーザーはそれらを選択し、[独自の **Worktree folder** を設定](#choose-where-ssh-session-worktrees-go)できますが、アプリでそれ以外を編集したり、削除したりすることはできません。

次の例は、単一の接続を事前設定しています：

```json theme={null}
{
  "sshConfigs": [
    {
      "id": "shared-dev-vm",
      "name": "Shared Dev VM",
      "sshHost": "user@dev.example.com",
      "sshPort": 22,
      "sshIdentityFile": "~/.ssh/id_ed25519"
    }
  ]
}
```

各エントリには `id`、`name`、および `sshHost` が必要です。`sshPort` および `sshIdentityFile` フィールドはオプションです。ユーザーは、自分の `~/.claude/settings.json` に `sshConfigs` を追加することもできます。

`sshHost` から `user@` を省略した場合、Desktop は各開発者の `~/.ssh/config` がそのホストに対して設定している `User` として接続し、設定がない場合は開発者自身のコンピューター上のユーザー名で接続します。

<h4 id="restrict-which-ssh-hosts-users-can-connect-to">
  ユーザーが接続できる SSH ホストを制限する
</h4>

管理者は、[管理設定](/docs/ja/managed-settings)で `sshHostAllowlist` を設定することで、Desktop の SSH セッションを承認されたホストのセットに制限できます。設定されると、ユーザーは解決されたホスト名がパターンの 1 つと一致するホストにのみ接続できます。SSH セッションを無効にするには、空の配列に設定します。空の配列が他の管理ソースのリストとどのように組み合わされるかについては、[`sshHostAllowlist` のリファレンス項目](/docs/ja/settings-reference#sshhostallowlist)を参照してください。

次の例は、`devboxes.example.com` の下のすべてのホストと、単一の名前付きバスティオンホストへの接続を許可しています：

```json theme={null}
{
  "sshHostAllowlist": ["*.devboxes.example.com", "bastion.example.com"]
}
```

<Warning>
  組織が[サーバー管理設定](/docs/ja/server-managed-settings)を配信している場合は、`sshHostAllowlist` をそこで設定してください。デフォルトでは、Desktop は[ポリシーキーを配信する最上位の管理ソース](/docs/ja/managed-settings#how-claude-code-combines-managed-sources)からのみこのキーを読み取ります。そのソースでキーが設定されていない場合、Desktop は下位の MDM ポリシーまたは管理設定ファイルにあるリストを無視し、キーを[未設定](/docs/ja/settings-reference#sshhostallowlist)として扱います。Desktop は警告を表示しません。

  また、各ユーザーのマシンでも、そのマシンの最上位の MDM ポリシーまたは管理設定ファイルに同じリストを保持してください。Desktop は起動時にサーバー管理設定を取得し、キャッシュされたコピーを保持しないため、取得が成功するまではマシンのリストが適用されます。
</Warning>

パターンは大文字と小文字を区別しません。`*` はすべてのホストと一致し、`*.example.com` は `example.com` とすべてのサブドメインと一致します。その他はすべて完全一致です。チェックは `ssh -G` を経由した `~/.ssh/config` 解決後のホスト名に対して実行されるため、`Host` エイリアスと `ProxyCommand`/`ProxyJump` エントリは、解決された `HostName` が一致する限り許可されます。

`sshHostAllowlist` は管理設定からのみ読み取られます。ユーザーまたはプロジェクト設定の値は無視されます。Claude Desktop アプリのみがこの設定を尊重します。Claude Code CLI と IDE 拡張機能はこれを読み取らず、Bash ツールを通じて実行される `ssh` コマンドを制限しません。これは Desktop アプリが接続するホストを管理し、ネットワーク出力ではないため、ハード境界が必要な場合は組織のネットワークまたはゼロトラストコントロールと組み合わせてください。

<h4 id="turn-off-local-sessions-and-distribute-ssh-connections">
  ローカルセッションをオフにして SSH 接続を配布する
</h4>

ローカルセッションをオフにし、SSH セッションを選択したホストに制限するには、[`disableDesktopLocalSessions`](/docs/ja/settings-reference#disabledesktoplocalsessions)、[`sshConfigs`](#pre-configure-ssh-connections-for-your-team)、[`sshHostAllowlist`](#restrict-which-ssh-hosts-users-can-connect-to) を一緒にデプロイします。

<Note>
  この構成は、Claude アカウントでサインインするユーザー向けです。[サードパーティプロバイダー](/docs/ja/third-party-integrations)を使用する場合、SSH セッションはデフォルトでオフになっており、`sshHostAllowlist` を設定するとオンにできます。これらのキーをデプロイする前に、[SSH remote sessions in Claude Desktop on 3P](https://claude.com/docs/third-party/claude-desktop/ssh-remote-sessions) をお読みください。
</Note>

次の例は、ローカルセッションをオフにし、1 つの接続を追加して、SSH セッションをその接続のホストに制限します：

```json managed-settings.json theme={null}
{
  "disableDesktopLocalSessions": true,
  "sshConfigs": [
    {
      "id": "shared-dev-vm",
      "name": "Shared Dev VM",
      "sshHost": "dev.example.com"
    }
  ],
  "sshHostAllowlist": ["dev.example.com"]
}
```

これらのキーはデスクトップアプリに適用されます。CLI、Cowork、クラウドセッションなど、Claude Code を実行する他の方法には影響しません：

* **CLI**：どのキーも、開発者が自分のコンピューターで Claude Code CLI を実行することを妨げません
* **Cowork**：どのキーも [Cowork](https://claude.com/docs/cowork/overview) セッションや Cowork のスケジュールタスクには適用されません
* **クラウドセッション**：どのキーも[クラウドセッション](#cloud-sessions)を利用できるかどうかを変更しません。クラウドセッションをオフにするには、[Admin console controls](#admin-console-controls) の **Cloud sessions** 設定を使用します。

この例を応用する場合は、ホスト名、Desktop のバージョン、およびファイルの権限を確認してください：

* **ホスト名**：`sshHostAllowlist` のパターンが、`user@` を除いた各 `sshConfigs` エントリのホスト名と一致することを確認してください。一致しない場合、開発者はその接続に接続できません。Desktop がホスト名を照合する方法については、[ユーザーが接続できる SSH ホストを制限する](#restrict-which-ssh-hosts-users-can-connect-to)を参照してください。
* **バージョン**：`disableDesktopLocalSessions` には Claude Desktop v1.37937.0 以降が必要です
* **ファイルの権限**：コンピューター上の各開発者のアカウントが管理設定ファイルを読み取れることを確認してください。アカウントが読み取れないファイル内のキーは Desktop によって適用されず、Claude Code も[それらのキーなしで起動します](/docs/ja/managed-settings#find-entries-claude-code-dropped)。

3 つのキーは、配信する[管理ソース](/docs/ja/managed-settings#how-claude-code-combines-managed-sources)のうち最上位のもの 1 つにまとめて記述してください。[サーバー管理設定](/docs/ja/server-managed-settings)を配信する場合は、各コンピューターの最上位の MDM ポリシーまたは管理設定ファイルにも 3 つのキーのコピーを保持してください。Desktop は起動時にサーバー管理設定を取得し、取得が成功するまではコンピューター上のコピーが適用されます。

設定が適用されていることを確認するには、開発者のコンピューターで次を確認します：

<Steps>
  <Step title="環境ドロップダウンを確認する">
    Desktop を終了して再度開き、プロンプトボックスの環境ドロップダウンを開きます。**Local** がグレーアウトされ、**SSH** の下に **Shared Dev VM** が表示されます。**Local** がまだ利用できる場合は、Desktop のバージョン、ファイルが有効な JSON であるかどうか、およびコンピューターがどの管理ソースを読み取っているかを確認してください。
  </Step>

  <Step title="許可リストにないホストを追加する">
    `other.example.com` など、許可リストにないホスト名で [SSH 接続を追加](#ssh-sessions)します。Desktop は接続を保存しますが、接続を拒否し、組織の設定でその接続が許可されていないことを示します。
  </Step>
</Steps>

<h2 id="enterprise-configuration">
  エンタープライズ設定
</h2>

Team または Enterprise プランの組織は、管理コンソールコントロール、管理設定ファイル、およびデバイス管理ポリシーを通じてデスクトップアプリの動作を管理できます。

<h3 id="admin-console-controls">
  管理コンソールコントロール
</h3>

これらの設定は[管理設定コンソール](https://claude.ai/admin-settings/claude-code)を通じて設定されます：

* **Desktop**：組織内のユーザーがデスクトップアプリで Claude Code にアクセスできるかどうかを制御します
* **Cloud sessions**：組織の[クラウドセッション](/docs/ja/claude-code-on-the-web)を有効または無効にします
* **Remote Control**：組織の[Remote Control](/docs/ja/remote-control)を有効または無効にします

HIPAA が有効になっている Enterprise 組織では、**Desktop** トグルはデフォルトでオフになっており、[Owner](/docs/ja/server-managed-settings#access-control) がオンにできます。[HIPAA 設定](/docs/ja/hipaa-setup)を適用すると、オンになっていた場合でもオフになるため、Owner は適用後にオンにし直す必要があります。**Cloud sessions** と **Remote Control** もデフォルトでオフであり、組織に HIPAA 設定が適用された後は、Owner がこれらをオンにすることはできません。

<Note>
  管理コンソールの[データとプライバシー設定](https://claude.ai/admin-settings/data-privacy-controls)の**Monitoring**下の Cowork 用 OpenTelemetry フォームは、Cowork セッションのみに適用されます。このマシン上の Cowork セッションでは、デスクトップアプリはそのコレクタを Claude Code に`OTEL_*`環境変数として渡すため、Claude Code がそのセッションで[管理コンソール設定をフェッチしない](#managed-settings)場合でも、フォームは有効になります。

  Code タブセッションからテレメトリをエクスポートするには、Claude Code 管理設定の`env`ブロックで`CLAUDE_CODE_ENABLE_TELEMETRY`と`OTEL_*`変数を設定します。[監視用の管理者設定](/docs/ja/monitoring-usage#administrator-configuration)に示されているとおりです。ローカル、クラウド、SSH セッションは、それぞれ[異なるソースから管理設定を読み取ります](#managed-settings)。クラウドセッションが到達できるホストについては、[ネットワークアクセス](/docs/ja/cloud-environments#network-access)を参照してください。Code タブセッションが報告する`service.name`については、[サービス情報](/docs/ja/monitoring-usage#service-information)を参照してください。

  SSH セッションがどのリモートマシンで実行されたかを確認するには、[テレメトリを Desktop SSH セッションに関連付ける](/docs/ja/monitoring-usage#attribute-telemetry-to-desktop-ssh-sessions)を参照してください。
</Note>

<h3 id="managed-settings">
  管理設定
</h3>

管理設定はプロジェクトおよびユーザー設定を上書きし、Desktop の Claude Code セッションに適用されます。これらのキーを組織の[管理設定](/docs/ja/managed-settings)ファイルで設定するか、管理コンソールを通じてリモートでプッシュできます。

| キー | 説明 |
| - | - |
| `permissions.disableBypassPermissionsMode` | ユーザーが Bypass permissions モードを有効にするのを防ぐには`"disable"`に設定します。 |
| `disableAutoMode` | [Auto](/docs/ja/permission-modes#eliminate-prompts-with-auto-mode)モードをモードセレクタから削除するには`"disable"`に設定します。`permissions`の下でも受け入れられます。 |
| `autoMode` | 組織全体で auto モード分類器が信頼およびブロックするものをカスタマイズします。[auto モードを設定する](/docs/ja/auto-mode-config)を参照してください。 |
| `browserExternalPageTools` | Claude が[Browser ペイン](#browse-external-sites)の外部ページを読み取るまたは操作するためのツールを使用するのを防ぐには`"disabled"`に設定します。ユーザーは引き続き外部サイトに自分でナビゲートできます。ローカル開発サーバープレビューは影響を受けません。 |
| `disableMobileSimulatorTools` | Claude の[iOS Simulator ペイン](/docs/ja/desktop-ios-simulator#turn-off-simulator-access)でデバイスを制御およびキャプチャするためのツールをブロックするには`true`に設定します。ペインはユーザー自身のタップに対して使用可能なままです。Claude のアクセスのみが削除されます。値は JSON ブール値`true`である必要があります。文字列`"true"`は無視されます。 |
| `disableBrowserExternalNavigation` | [Browser ペイン](#browse-external-sites)の外部ブラウジングを完全にオフにするには`true`に設定します。ユーザーも Claude も外部サイトにナビゲートできません。localhost 開発サーバープレビューは影響を受けません。値は JSON ブール値`true`である必要があります。文字列`"true"`は無視されます。 |
| `sshConfigs` | 環境ドロップダウンに表示される[SSH 接続](#pre-configure-ssh-connections-for-your-team)を事前設定します。ユーザーは管理接続を削除できず、自分の **Worktree folder** 以外は編集できません。 |
| `sshHostAllowlist` | [SSH セッション](#restrict-which-ssh-hosts-users-can-connect-to)を、解決されたホスト名がこれらのパターンのいずれかと一致するホストに制限します。管理設定からのみ読み取られます。 |
| `disableDesktopLocalSessions` | [デバイスで実行されるコードセッション](#local-sessions-on-managed-devices)をオフにするには`true`に設定します。他のホストへの SSH セッションとクラウドセッションは利用可能なままです。値は JSON ブール値`true`である必要があります。管理設定からのみ読み取られます。Claude Desktop v1.37937.0 以降が必要です。 |
| `disableSshSavedPasswords` | Desktop が SSH パスワードの保存を提案したり、以前に保存したパスワードを使用または表示したりしないようにするには`true`に設定します。オンにしても、保存済みのパスワードは削除されません。管理設定からのみ読み取られます。Claude Desktop v1.49585.0 以降が必要です。 |
| `managedMcpServers` | MCP サーバー設定をすべてのユーザーにプッシュします。サードパーティ（3P）Desktop デプロイでのみ利用可能です。各エントリで、`"http"`、`"sse"`、または`"stdio"`のトランスポート、接続詳細、およびオプションで、そのサーバーのどのツールをユーザーが呼び出せるかを制限する`toolPolicy`マップを設定します。管理設定ファイル、MDM、または Claude apps gateway ポリシーの[`desktop`ブロック](/docs/ja/claude-apps-gateway-config#claude-desktop-overlay)を通じて配信します。3P デプロイは管理コンソール設定を受け取らないためです。ゲートウェイを通じて配信するには、ゲートウェイサーバーで Claude Code v2.1.232 以降が必要です。これはデスクトップアプリ自体のキーです。Claude Code は、異なるエントリ形状を持つ、同じ名前の[管理設定](/docs/ja/managed-mcp#provide-servers-through-managed-settings)を読み取ります。 |

Desktop セッションがどこで実行されるかに応じて、どの管理設定がそのセッションに到達するかが異なります。[`availableModels`](/docs/ja/model-config#restrict-model-selection)などのモデル制限は、Desktop の Claude Code セッションでターミナル CLI と同じ方法で適用されます。[surface coverage](/docs/ja/model-config#surface-coverage)を参照してください。

* **このマシン上のローカルセッション**：ディスクにデプロイされた管理設定ファイルが適用されます。管理コンソールを通じてリモートでプッシュされた管理設定は、セッションが[適格なログイン](/docs/ja/server-managed-settings#platform-availability)で認証する場合、Anthropic の API でこれらのセッションに到達します。ターミナル CLI と同じ[設定の優先順位](/docs/ja/settings#settings-precedence)に従います。
* **[クラウドセッション](#cloud-sessions)**：[サーバー管理設定](/docs/ja/server-managed-settings)を受け取ります。デバイスにデプロイされたファイルはこれらのセッションに到達しません。Anthropic が管理する VM で実行されるためです。[自己ホスト環境](/docs/ja/self-hosted-environments)にルーティングされたセッションは、ランナーイメージ内の管理設定ファイルも読み取ります。[Claude Code が管理ソースを組み合わせる方法](/docs/ja/managed-settings#how-claude-code-combines-managed-sources)は、そのファイルが適用される場合を示しています。
* **[SSH セッション](#ssh-sessions)**：セッションはリモートホストから管理設定ファイルを読み取ります。Desktop 自体は、ローカルマシン上で`sshConfigs`、`sshHostAllowlist`、`disableSshSavedPasswords`、および`disableDesktopLocalSessions`を読み取ります。複数の管理ソースを配信する場合、Desktop は[デフォルトではそのうち 1 つから](/docs/ja/managed-settings#how-claude-code-combines-managed-sources)これらを読み取ります。
* **[Cowork](https://claude.com/docs/cowork/overview)セッション**：このマシン上の Cowork セッションでは、ユーザーが Team または Enterprise アカウントでサインインしている場合でも、Claude Code は管理コンソール設定をフェッチしません。マシンにデプロイされたポリシーを読み取ります。ただし、Claude Desktop 設定が`requireCoworkFullVmSandbox`を設定している場合を除きます。リモート Cowork セッションはどちらも受け取りません。[ポリシーが適用される場所と時期](/docs/ja/managed-settings#where-and-when-a-policy-applies)を参照して、どのデバイスファイルが Cowork に到達するかを確認してください。[MCP 権限ルール](/docs/ja/permissions#mcp)を参照して、`Bash`および`WebFetch`ルールが Cowork のツールにどのように適用されるかを確認してください。

ローカルおよび SSH セッションでは、デスクトップアプリは各ユーザーの接続された claude.ai コネクタを Claude Code に直接配信します。MCP 設定または`managed-mcp.json`はこれらのコネクタに到達しません。使用する設定ソースまたはファイルの場所に関係なく。これらのセッションでコネクタのツールをブロックするには、組織の[コネクタツールコントロール](/docs/ja/mcp#organization-controls-on-connector-tools)を使用してください。[コネクタが Claude Code に到達する方法](/docs/ja/mcp#how-connectors-reach-claude-code)は、各種類のセッションでコネクタを管理する設定を示しています。

`permissions.disableBypassPermissionsMode`と`disableAutoMode`はユーザーおよびプロジェクト設定でも機能しますが、管理設定に配置するとユーザーがそれらを上書きするのを防ぎます。

管理ソースのみが設定できる権限、プラグイン、および配信キーについては、[管理設定のみが設定できるキー](/docs/ja/managed-settings#managed-only-settings)を参照してください。

<h3 id="device-management-policies">
  デバイス管理ポリシー
</h3>

IT チームは、macOS の MDM、Windows のグループポリシー、または Linux のポリシーファイルを通じてデスクトップアプリを管理できます。利用可能なポリシーには、Claude Code 機能の有効化または無効化、macOS と Windows での自動更新の制御、およびカスタムデプロイ URL の設定が含まれます。

* **macOS**：Jamf または Kandji などのツールを使用して`com.anthropic.claudefordesktop`プリファレンスドメインを通じて設定します
* **Windows**：`SOFTWARE\Policies\Claude`のレジストリを通じて設定します
* **Linux**：`/etc/claude-desktop/managed-settings.json`にある root 所有のファイルを通じて設定します。このファイルはポリシーキーを JSON オブジェクトとして保持します。root 以外のユーザーがファイルまたはそのフォルダに書き込める場合、Desktop はそのファイルを拒否します。これは Claude Code の[管理設定ファイル](/docs/ja/managed-settings)とは別のファイルです。

<h3 id="network-access-requirements">
  ネットワークアクセス要件
</h3>

Desktop はアプリケーションコードとユーザーコンテンツを Anthropic CDN ホストから読み込みます。

```text theme={null}
anthropic.com
*.anthropic.com
claude.ai
*.claude.ai
claude.com
*.claude.com
claude.app
*.claude.app
*.claudeusercontent.com
*.claudemcpcontent.com
```

トラフィックは HTTPS ポート 443 です。ただし、[OTLP](/docs/ja/monitoring-usage)、LLM ゲートウェイ、または MCP サーバーのカスタムポートを設定する場合を除きます。

プロキシサーバー、カスタム認証局、mTLS、およびスタンドアロン CLI が必要とするドメインについては、[ネットワーク設定](/docs/ja/network-config)を参照してください。

ファイアウォールワイルドカードの数を減らすために、代わりにこれらの Anthropic ホストを許可してください。特定のサブドメインは動的に生成されるため、ワイルドカードのままである必要があります。

```text theme={null}
anthropic.com
api.anthropic.com
a-api.anthropic.com
a-cdn.anthropic.com
s-cdn.anthropic.com
assets-proxy.anthropic.com
claude.ai
a.claude.ai
assets.claude.ai
downloads.claude.ai
*.livepreview.claude.ai
claude.com
platform.claude.com
*.livepreview.claude.app
*.claudeusercontent.com
*.claudemcpcontent.com
```

組織で Claude に対して[IP 許可リスト](https://support.claude.com/en/articles/13200993-restrict-access-to-claude-with-ip-allowlisting)が有効になっている場合は、`bridge.claudeusercontent.com`を`claude.ai`および`api.anthropic.com`と同じプロキシ出口を通じてルーティングしてください。そのようにルーティングできない場合は、プロキシがそのホストに使用する出口アドレスを組織の IP 許可リストに追加してください。ただし、そのアドレスが組織に専用されている場合のみです。共有プロキシ出口範囲は、プロキシベンダーの他の顧客も許可します。

Anthropic は、到着元のアドレスを使用して、組織の IP 許可リストに対してそのホストへの接続をチェックします。プロキシがそのホストのトラフィックを、その許可リストにないアドレスを通じて送信する場合、Chrome の Claude およびブリッジを通じて接続する他の機能は機能しなくなりますが、アプリの残りの部分は機能し続けます。

[アーティファクト](/docs/ja/artifacts)が[Google Fonts](/docs/ja/artifacts#improve-the-visual-design)からタイプフェイスを読み込む場合、`fonts.googleapis.com`および`fonts.gstatic.com`もリクエストします。両方のホストはオプションです。それらをブロックする場合、アーティファクトはフォールバックタイプフェイスでレンダリングされます。フォントリクエストが即座に失敗するように、高速拒否でブロックしてください。ページの最初のレンダリングを遅延させるのではなく。

アーティファクトは、React またはチャートパッケージなどの JavaScript ライブラリを`cdnjs.cloudflare.com`、`cdn.jsdelivr.net`、`cdn.tailwindcss.com`、`code.jquery.com`、および`unpkg.com`から読み込むこともできます。他の外部ホストからは読み込みません。それらのホストをブロックする場合、ライブラリに依存するアーティファクトの部分は機能しません。ブロックされたフォントとは異なり、ブロックされたライブラリにはフォールバックがありません。ここでも高速拒否でブロックしてください。ブロックされたライブラリリクエストが即座に失敗するように。タイムアウトするまでハングするのではなく。

<h3 id="authentication-and-sso">
  認証と SSO
</h3>

Team および Enterprise 組織はすべてのユーザーに SSO を要求できます。プランレベルの詳細については[認証](/docs/ja/authentication)を参照し、[Setting up SSO](https://support.claude.com/en/articles/13132885-setting-up-single-sign-on-sso)で SAML 設定を参照してください。OIDC セットアップは[Claude Enterprise Administrator Guide](https://claude.com/resources/tutorials/claude-enterprise-administrator-guide)で説明されています。

<h3 id="data-handling">
  データ処理
</h3>

Claude Code はローカルセッションではコードをローカルで処理するか、クラウドセッションでは Anthropic が管理するインフラストラクチャで処理します。組織がそれらを[自己ホスト環境](/docs/ja/self-hosted-environments)にルーティングしない限り。クラウドセッション（自己ホスト環境を含む）は、処理のために会話とコードコンテキストを Anthropic の API に送信します。ローカルおよび SSH セッションは、デプロイで設定されている[モデルプロバイダー](#feature-comparison)（デフォルトでは Anthropic の API）に送信します。データ保持、プライバシー、およびコンプライアンスの詳細については、[データ処理](/docs/ja/data-usage)を参照してください。

<h3 id="deployment">
  デプロイ
</h3>

Desktop はエンタープライズデプロイツールを通じて配布できます：

* **macOS**：Jamf または Kandji などの MDM を使用して`.dmg`インストーラーを通じて配布します
* **Windows**：MSIX パッケージを通じてデプロイします。サイレントインストールを含むエンタープライズデプロイのオプションについては、[Deploy Claude Desktop for Windows](https://support.claude.com/en/articles/12622703-deploy-claude-desktop-for-windows)を参照してください。

ファイアウォールで許可リストに登録するドメインについては、上記の[ネットワークアクセス要件](#network-access-requirements)を参照してください。プロキシ設定、カスタム認証局、および LLM ゲートウェイについては、[ネットワーク設定](/docs/ja/network-config)を参照してください。

完全なエンタープライズ設定リファレンスについては、[エンタープライズ設定ガイド](https://support.claude.com/en/articles/12622667-enterprise-configuration)を参照してください。

<h2 id="coming-from-the-cli">
  CLI から移行する場合
</h2>

Claude Code CLI を既に使用している場合、Desktop はグラフィカルインターフェイスで同じ基盤となるエンジンを実行します。同じマシン上で、同じプロジェクト上でも、両方を同時に実行できます。各々は独自のセッションリストを保持し、CLI セッションを Desktop に持ち込むことができます。CLAUDE.md ファイルを通じて設定とプロジェクトメモリを共有します。

CLI セッションを Desktop に移動するには、ターミナルで `/desktop` を実行します。Claude はセッションを保存し、デスクトップアプリで開いてから CLI を終了します。このコマンドは、Claude サブスクリプションでサインインしている場合、macOS と x64 Windows で利用可能です。API キー認証、Amazon Bedrock、Google Cloud の Agent Platform、または Microsoft Foundry では利用できません。

シェルから、[`claude --desktop`](/docs/ja/cli-reference#cli-flags) は Desktop を直接開き、ターミナルセッションを開始しません。Claude Code v2.1.285 以降が必要で、`/desktop` と同じプラットフォームおよびサインイン要件があります。他の引数がない場合、現在のディレクトリで Desktop を開きます。既存の CLI セッションを Desktop で開くには、このディレクトリの最新の会話に対して `--continue` を追加するか、`/status` が表示するセッション ID で `--resume` を追加します：

```bash theme={null}
claude --desktop --resume <session-id>
```

Claude Code は `Opening session <session-id> in Claude Desktop` を出力し、セッションはアプリで開き、コマンドは終了します。セッション名は ID の代わりに機能しません。Claude Code は別のターミナルで開いているセッションや、バックグラウンドで実行中のセッションを移動しません。Claude Desktop がインストールされていない場合、コマンドはダウンロードリンクを出力して終了します。

Desktop 内から CLI セッションを再開することもできます。`/resume` を使用します。このコマンドはローカルセッションで利用可能で、SSH、WSL、またはクラウドセッションでは利用できません。

Desktop でターミナルセッションを続行するには：

1. ターミナルでセッションを閉じます。
2. Desktop のプロンプトボックスで `/resume` と入力します。Desktop は、このコンピューターで CLI から開始したセッションをリストアップします。タイトル、フォルダ、またはブランチで検索し、各セッションがどこで終了したかをプレビューします。
3. セッションを選択します。アプリで完全な会話とコンテキストとともに続行されます。

Desktop は同じセッションを続行するため、コピーではなく、ターミナルで `claude --resume` を実行すると、その後も見つかります。

<Tip>
  Desktop と CLI をいつ使用するか：複数のセッションを 1 つのウィンドウで管理したい場合、ペインを並べて配置したい場合、または変更を視覚的に確認したい場合は Desktop を使用します。スクリプト、自動化が必要な場合、またはターミナルワークフローを好む場合は CLI を使用します。
</Tip>

<h3 id="cli-flag-equivalents">
  CLI フラグの同等物
</h3>

このテーブルは、一般的な CLI フラグの Desktop アプリの同等物を示しています。リストされていないフラグは、スクリプトまたは自動化用に設計されているため、Desktop の同等物がありません。

| CLI | Desktop の同等物 |
| - | - |
| `--model sonnet` | 送信ボタンの横のモデルドロップダウン |
| `--resume`、`--continue` | サイドバーのセッションをクリックするか、プロンプトボックスで `/resume` と入力して CLI から開始したセッションを選択します |
| `--permission-mode` | 送信ボタンの横のモードセレクタ |
| `--dangerously-skip-permissions` | 権限モードをバイパスします。Pro および Max プランでは、設定 → Claude Code → 「権限モードのバイパスを許可」で有効にします。Team および Enterprise プランでは、組織ポリシーで制御されます |
| `--add-dir` | クラウドセッションで **+** ボタンで複数のリポジトリを追加します |
| `--allowedTools`、`--disallowedTools` | セッションごとの同等物はありません。[設定ファイル](/docs/ja/settings)の権限ルールは引き続き適用されます。 |
| `--verbose` | [詳細ビューモード](#switch-view-modes) |
| `--print`、`--output-format` | 利用できません。Desktop は対話的のみです。 |
| `ANTHROPIC_MODEL` 環境変数 | 送信ボタンの横のモデルドロップダウン |
| `MAX_THINKING_TOKENS` 環境変数 | ローカル環境エディタで設定します。[環境設定](#environment-configuration)を参照してください。 |

<h3 id="shared-configuration">
  共有設定
</h3>

Desktop と CLI は同じ設定ファイルを読み込むため、セットアップが引き継がれます：

* プロジェクト内の **[CLAUDE.md](/docs/ja/memory)** および `CLAUDE.local.md` ファイルは両方で使用されます
* `~/.claude.json` または `.mcp.json` で設定された **[MCP サーバー](/docs/ja/mcp)** は両方で機能します
* 設定で定義された **[フック](/docs/ja/hooks)** および **[スキル](/docs/ja/skills)** は両方に適用されます
* `~/.claude.json` および `~/.claude/settings.json` の **[設定](/docs/ja/settings)** は共有されます。`settings.json` の権限ルール、許可されたツール、およびその他の設定は Desktop セッションに適用されます。
* **モデル**：同じ[モデル](/docs/ja/model-config#available-models)が両方で利用可能です。Desktop では、送信ボタンの横のドロップダウンからモデルを選択します。セッション中にも同じドロップダウンからモデルを変更できます。

<h4 id="mcp-servers-from-the-claude-desktop-chat-app">
  Claude Desktop チャットアプリからの MCP サーバー
</h4>

Desktop アプリは、`claude_desktop_config.json` から MCP サーバーをローカルコードタブセッションに読み込み、`~/.claude.json` および `.mcp.json` のサーバーと並行して実行します。`claude_desktop_config.json` で定義したサーバーは、Desktop チャットサーフェイスとローカルコードタブセッションの両方で利用可能です。

`claude_desktop_config.json` と `~/.claude.json` または `.mcp.json` で同じサーバー名を定義した場合、ローカルセッションのコードタブは 1 回接続し、`claude_desktop_config.json` の定義を使用します。

アプリは、`~/.claude.json` の stdio サーバーをローカルセッションの組み込み CLI に再配信します。`~/.claude.json`（ユーザースコープ）と `.mcp.json` のトップレベルが同じ stdio サーバー名を定義する場合、コードタブは `~/.claude.json` の定義を使用し、CLI の[スコープ階層](/docs/ja/mcp#scope-hierarchy-and-precedence)から外れます。

<Note>
  スタンドアロン CLI は `claude_desktop_config.json` を読み込みません。macOS と WSL では、`claude mcp add-from-claude-desktop` を実行して、それらのサーバーを `~/.claude.json` にコピーします。[Claude Desktop から MCP サーバーをインポート](/docs/ja/mcp#import-mcp-servers-from-claude-desktop)を参照して、インポートフローとスコープオプションを確認してください。
</Note>

<h3 id="feature-comparison">
  機能比較
</h3>

このテーブルは、CLI と Desktop の主要機能を比較しています。CLI フラグの完全なリストについては、[CLI リファレンス](/docs/ja/cli-reference)を参照してください。

| 機能 | CLI | Desktop |
| - | - | - |
| 権限モード | `dontAsk` を含むすべてのモード | Manual、Accept edits、Plan、および Auto。権限モードのバイパスは、モードセレクタで有効にされると表示されます：Pro および Max プランでは設定トグルを通じて、Team および Enterprise プランでは組織ポリシーを通じて |
| [サードパーティプロバイダー](/docs/ja/third-party-integrations) | Amazon Bedrock、Google Cloud の Agent Platform、Microsoft Foundry | デフォルトで Anthropic の API。ゲートウェイルーティングについては、[Desktop アプリをゲートウェイに接続](/docs/ja/llm-gateway-connect#desktop-app)を参照してください。Code タブを Amazon Bedrock、Google Cloud の Agent Platform、Microsoft Foundry、または自己ホスト型 LLM ゲートウェイで実行するには、[Claude Desktop on 3P](https://claude.com/docs/third-party/claude-desktop/overview)を参照してください。 |
| [MCP サーバー](/docs/ja/mcp) | 設定ファイルで設定 | ローカルおよび SSH セッションのコネクタ UI、または設定ファイル |
| [プラグイン](/docs/ja/plugins/overview) | `/plugin` コマンド | プラグインマネージャー UI |
| @mention ファイル | テキストベース | オートコンプリート付き。ローカルおよび SSH セッションのみ |
| ファイル添付 | 利用できません | 画像、PDF |
| セッション分離 | [`--worktree`](/docs/ja/cli-reference) フラグ | セッション開始時の **worktree** オプション |
| 複数セッション | 別々のターミナル | サイドバータブ |
| 定期的なタスク | Cron ジョブ、CI パイプライン | [スケジュールタスク](/docs/ja/desktop-scheduled-tasks) |
| コンピューター使用 | macOS で [`/mcp`](/docs/ja/computer-use) で有効化 | macOS および Windows で[アプリとスクリーン制御](#let-claude-use-your-computer) |
| iOS シミュレータ | [コンピューター使用](/docs/ja/computer-use#test-a-simulator-flow)経由でシミュレータを駆動 | [iOS シミュレータペイン](/docs/ja/desktop-ios-simulator)が自動的に開きます |
| Dispatch 統合 | 利用できません | サイドバーの [Dispatch セッション](#sessions-from-dispatch) |
| スクリプトと自動化 | [`--print`](/docs/ja/cli-reference)、[Agent SDK](/docs/ja/headless) | 利用できません |

<h3 id="what’s-not-available-in-desktop">
  Desktop で利用できない機能
</h3>

以下の機能は Desktop では利用できません（記載されている場合を除く）：

* **サードパーティプロバイダー**：Desktop はデフォルトで Anthropic の API に接続します。Desktop をゲートウェイ経由でルーティングするか、Code タブを Amazon Bedrock、Google Cloud の Agent Platform、Microsoft Foundry、または自己ホスト型 LLM ゲートウェイで実行するには、[サードパーティプロバイダー行](#feature-comparison)のリンクに従ってください。
* **Linux（ベータ）**：Linux デスクトップアプリではコンピューター使用はまだ利用できません。[Claude Desktop on Linux](/docs/ja/desktop-linux)を参照してください。
* **インラインコード提案**：Desktop はオートコンプリートスタイルのコード補完を提供しません。会話型プロンプトと明示的なコード変更を通じて機能し、Claude の応答後に[次のプロンプトを提案](#accept-a-suggested-prompt)できます。
* **エージェントチーム**：Claude がチームリーダーとして共有タスクリストからチームメイトにタスクを割り当てる調整されたチームは、[CLI](/docs/ja/agent-teams)で利用可能で、Desktop では利用できません。1 つのセッション内でマルチエージェント作業を行う場合は、Desktop で実行される[動的ワークフロー](/docs/ja/workflows)を使用します。Claude は[他のセッションに直接メッセージを送信して管理](#work-across-sessions)することもできます。
* **ターミナルダイアログコマンド**：ターミナルで対話的パネルを開く組み込みコマンドは、コードタブで異なる動作をします。[設定ファイル](/docs/ja/settings)を直接編集して権限ルールと設定を管理するか、スタンドアロン CLI からコマンドを実行します。
  * `/permissions` などの引数形式がないコマンドは、`isn't available in this environment` で応答します。
  * `/config` は設定 → Claude Code を開きます。コマンド後のテキストは無視されるため、`/config theme=dark` はテーマを設定しません。

<h2 id="troubleshooting">
  トラブルシューティング
</h2>

以下のセクションでは、デスクトップアプリに固有の問題について説明します。チャットに表示される`API Error: 500`、`529 Overloaded`、`429`、または`Prompt is too long`などのランタイム API エラーについては、[エラーリファレンス](/docs/ja/errors)を参照してください。これらのエラーとその修正は、CLI、Desktop、Web 全体で同じです。

<h3 id="check-your-version">
  バージョンを確認する
</h3>

実行しているデスクトップアプリのバージョンを確認するには：

* **macOS**：メニューバーの**Claude**をクリックしてから、**About Claude**をクリック
* **Windows**：**Help**をクリックしてから、**About Claude**をクリック

バージョン番号をクリックしてクリップボードにコピーします。

<h4 id="claude-code-version-in-the-code-tab">
  Code タブの Claude Code バージョン
</h4>

セッションで実行されている Claude Code のバージョンを確認するには、**Code** タブのローカルセッションで `/status` と入力し、**Claude Code** 行を確認します。この行には `2.1.286` のようなバージョンが表示されます。

ローカルセッション用に新しいバージョンを取得するには、macOS では **Claude → Check for Updates**、Windows では **Help → Check for Updates** を開き、新しいセッションを開始します。

ローカルセッションでは、**Code** タブは独自の Claude Code のコピーを実行し、そのコピーには独自のバージョン番号があります。デスクトップアプリがそのコピーをダウンロードして更新するため、ターミナルの `claude` コマンドとはバージョンが異なる場合があり、一方を更新してももう一方は更新されません。

<h3 id="403-or-authentication-errors-in-the-code-tab">
  Code タブの 403 またはエラー認証エラー
</h3>

Code タブを使用するときに`Error 403: Forbidden`またはその他の認証エラーが表示される場合：

1. アプリメニューからサインアウトして再度サインインします。これが最も一般的な修正です。
2. アクティブな有料サブスクリプション（Pro、Max、Team、または Enterprise）があることを確認します。
3. CLI は機能するが Desktop は機能しない場合、デスクトップアプリを完全に終了し（ウィンドウを閉じるだけではなく）、再度開いてサインインします。
4. インターネット接続とプロキシ設定を確認します。

<h3 id="blank-or-stuck-screen-on-launch">
  起動時に空白または停止画面
</h3>

アプリが開いても空白または応答しない画面が表示される場合：

1. アプリを再起動します。
2. 保留中の更新を確認します。macOS と Windows ではアプリは起動時に自動更新されます。Linux では、[Claude Desktop on Linux](/docs/ja/desktop-linux)で説明されているように apt を使用して更新します。
3. マネージドネットワーク上では、ファイアウォールが[ネットワークアクセス要件](#network-access-requirements)の CDN ホストを許可していることを確認します。
4. Windows では、**Windows Logs → Application**の Event Viewer でクラッシュログを確認します。

<h3 id="failed-to-load-session">
  「Failed to load session」
</h3>

`Failed to load session`が表示される場合、選択したフォルダが存在しなくなった可能性があります。Git リポジトリがインストールされていない Git LFS を必要とする可能性があります。またはファイル権限がアクセスを防ぐ可能性があります。別のフォルダを選択するか、アプリを再起動してみてください。

<h3 id="session-not-finding-installed-tools">
  セッションがインストール済みツールを見つけられない
</h3>

Claude が`npm`、`node`、またはその他の CLI コマンドなどのツールを見つけられない場合、ツールが通常のターミナルで機能することを確認し、シェルプロファイルが PATH を正しく設定していることを確認し、デスクトップアプリを再起動して環境変数を再度読み込みます。

<h3 id="git-and-git-lfs-errors">
  Git および Git LFS エラー
</h3>

独自の worktree で実行されるセッションには Git が必要です。「Git is required」が表示される場合、[Git](https://git-scm.com/downloads)をインストールするか、Windows では[Git for Windows](https://git-scm.com/downloads/win)をインストールして、もう一度試してください。Windows では、1.49585.0 より前の Claude Desktop バージョンはローカルセッションを開始する前に Git を要求していました。そのプロンプトが表示され、worktrees を使用していない場合は、アプリを更新してください。

「Git LFS is required by this repository but is not installed」が表示される場合、[git-lfs.com](https://git-lfs.com/)から Git LFS をインストールし、`git lfs install`を実行してアプリを再起動します。

<h3 id="mcp-servers-not-working-on-windows">
  Windows で MCP サーバーが機能しない
</h3>

MCP サーバートグルが応答しない場合、または Windows でサーバーが接続に失敗する場合、サーバーが設定で正しく設定されていることを確認し、アプリを再起動し、Task Manager でサーバープロセスが実行されていることを確認し、接続エラーについてサーバーログを確認します。

<h3 id="ssh-connection-fails-after-you-log-in">
  ログイン後に SSH 接続が失敗する
</h3>

カードのタイトル、またはエラーメッセージの末尾にあるコードをこの表で探し、最後の列の指示に従ってください。メッセージを確認するには、失敗カードで **View details** を選択します。

| カードのタイトル | コード | 対処方法 |
| - | - | - |
| `<host>'s SSH server has SFTP turned off` | `[SFTP_UNAVAILABLE]` | [リモートマシンの要件](#remote-machine-requirements-for-ssh-sessions)で説明されているとおり、サーバーの `sshd_config` で SFTP をオンにします |
| `SFTP doesn't start on <host>` | `[SFTP_NOT_STARTED]` | コンピューターのターミナルで `sftp` を使用して同じホストに接続し、何が起動を妨げているかを確認してから、Desktop のメッセージに示されている設定とファイルを確認します |
| `<host> allows too few SSH sessions per connection` | `[SESSION_LIMIT]` | サーバーの `sshd_config` で `MaxSessions` を引き上げます（例：OpenSSH のデフォルトである 10） |
| `<host> is out of disk space` | `[ENOSPC]` または `[EDQUOT]` | リモートマシンのホームディレクトリまたは `/tmp` で空き容量またはクォータを確保します |
| `This computer is out of disk space` | `[ENOSPC]` または `[EDQUOT]`（`Couldn't prepare the deploy locally` で始まるメッセージ内） | コンピューターの空き容量を確保します |
| `Claude Code won't start on <host>` | `[CLI_UNRESPONSIVE]` | 1 分待ってから、もう一度試してください。失敗が続く場合は、メッセージに示されているコマンドをリモートマシンで実行し、そこで Claude Code が応答するかどうかを確認します。 |

その他のメッセージについては、[リモートマシンの要件](#remote-machine-requirements-for-ssh-sessions)を確認してください。

<h3 id="get-desktop’s-logs-for-an-ssh-problem">
  SSH の問題について Desktop のログを取得する
</h3>

Desktop の SSH 接続の記録である `ssh.log` は、**Help** メニューから保存する Desktop のログの zip ファイルに含まれています。保存するには、**Help > Troubleshooting** を開き、使用しているシステムに対応する項目を選択します：

* **macOS**：**Show Logs in Finder**
* **Windows**：**Show Logs in File Explorer**
* **Linux**：**Show Logs in File Manager**

ファイルには環境内の名前やその他の詳細が含まれる可能性があるため、送信する前に内容を確認してください。`<host>` と `<user>` は、Desktop が置き換えた名前を表します。Desktop はすべての名前を置き換えるわけではなく、SSH のホスト名やユーザー名が記述されたまま表示される場合もあります。zip ファイルを誰かに送信する場合は、ログにホスト名が記載されていない可能性があるため、どのホストでいつ失敗したかを伝えてください。

zip ファイルには、Desktop がリモートマシンにインストールするヘルパープログラムのログは含まれていません。そのログも取得するには、接続したユーザーのホームディレクトリにある [`~/.claude/remote/run/`](#files-and-processes-on-the-remote-machine) 配下のヘルパーのフォルダから `remote-server.log` をコピーします。このファイルも送信する前に内容を確認してください。

<h3 id="app-won’t-quit">
  アプリが終了しない
</h3>

* **macOS**：Cmd+Q を押します。アプリが応答しない場合、Cmd+Option+Esc で Force Quit を使用し、Claude を選択して Force Quit をクリックします。
* **Windows**：Ctrl+Shift+Esc で Task Manager を使用して Claude プロセスを終了します。

<h3 id="windows-specific-issues">
  Windows 固有の問題
</h3>

* **インストール後に PATH が更新されない**：新しいターミナルウィンドウを開きます。PATH の更新は新しいターミナルセッションにのみ適用されます。
* **同時インストールエラー**：別のインストールが進行中であるというエラーが表示されるが、実際には進行中でない場合、インストーラーを管理者として実行してみてください。

<h3 id="branch-doesn’t-exist-yet-when-opening-in-cli">
  CLI で開くときに「Branch doesn't exist yet」
</h3>

クラウドセッションはローカルマシンに存在しないブランチを作成できます。セッション内のブランチ名をクリックして **Copy branch name** を選択してから、ローカルでフェッチします：

```bash theme={null}
git fetch origin <branch-name>
git checkout <branch-name>
```

<h3 id="still-stuck">
  まだ立ち往生していますか？
</h3>

* デスクトップアプリで Help → Get Support を開くか、[Claude サポートセンター](https://support.claude.com/)に直接アクセスします
* スタンドアロン`claude` CLI でも再現される問題については、[GitHub Issues](https://github.com/anthropics/claude-code/issues)でバグを検索またはファイルします

問題を報告するときは、デスクトップアプリのバージョン、オペレーティングシステム、正確なエラーメッセージ、および関連ログを含めます。macOS では Console.app を確認します。Windows では Event Viewer → Windows Logs → Application を確認します。ログの抜粋を公開イシューに投稿する前に確認してください。環境からのファイルパスおよび他の詳細が含まれる可能性があります。
