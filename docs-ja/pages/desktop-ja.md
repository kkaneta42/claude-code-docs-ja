> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# Desktop application

> Claude Code Desktop をさらに活用する：Git 分離による並列セッション、ドラッグアンドドロップペインレイアウト、統合ターミナルとファイルエディタ、サイドチャット、コンピュータ使用、電話から Dispatch セッションを送信、ビジュアル diff レビュー、アプリプレビュー、PR 監視、コネクタ、エンタープライズ設定。

Claude Desktop アプリでは、Claude Code は **Code** タブです。アプリにはチャットと [Cowork](https://claude.com/product/cowork) もあり、Cowork は Dispatch やより長いエージェント型の作業を担います。このページは Code タブのリファレンスです。

> [card] [macOS 用にダウンロード](https://claude.ai/api/desktop/darwin/universal/dmg/latest/redirect?utm_source=claude_code\&utm_medium=docs)
>
> Intel と Apple Silicon 向けのユニバーサルビルド

> [card] [Windows 用にダウンロード](https://claude.ai/api/desktop/win32/x64/setup/latest/redirect?utm_source=claude_code\&utm_medium=docs)
>
> x64 プロセッサ向け

> [card] [Linux 用 Claude を入手（ベータ版）](https://code.claude.com/docs/ja/desktop-linux.md)
>
> Ubuntu と Debian 向けの apt または .deb

Windows ARM64 の場合は、[ARM64 インストーラー](https://claude.ai/api/desktop/win32/arm64/setup/latest/redirect?utm_source=claude_code\&utm_medium=docs)をダウンロードしてください。Linux では apt でインストールします。[Claude Desktop on Linux](https://code.claude.com/docs/ja/desktop-linux.md)を参照してください。

インストール後、Claude を起動してサインインし、**Code** タブをクリックします。最初のセッションのウォークスルーについては、[はじめにガイド](https://code.claude.com/docs/ja/desktop-quickstart.md)を参照してください。

Code タブでは、各会話は **セッション** です：独自のチャット履歴とプロジェクトフォルダを持ち、他のセッションとは独立しています。サイドバーはセッションをリストアップし、複数を並列で実行できます。セッション内では以下のことができます：

* [diff ビューで変更をレビューしてコメント](#review-changes-with-diff-view)してから、[CI を通じて結果の PR を監視](#monitor-pull-request-status)
* [埋め込みブラウザで実行中のアプリをプレビュー](#preview-your-app)し、Claude が独自の変更を検証し、[外部サイトを並べて開く](#browse-external-sites)
* [iOS Simulator ペインで iOS アプリを実行してテスト](https://code.claude.com/docs/ja/desktop-ios-simulator.md)する Claude を監視
* [ペインを配置](#arrange-your-workspace)して、チャット、diff、ブラウザ、ターミナル、ファイルエディタを並べて表示
* セッションのコンテキストを使用する[サイド質問](#ask-a-side-question-without-derailing-the-session)を尋ねて、セッションを脱線させない
* Claude に[他のセッションを確認、メッセージ送信、またはアーカイブ](#work-across-sessions)させる
* [外部ツールを接続](#connect-external-tools)（GitHub、Slack、Linear など）
* Claude に[アプリを開いてスクリーンを制御](#let-claude-use-your-computer)させる
* マシン上、[クラウド](#run-long-running-tasks-in-the-cloud)上、または [SSH](#ssh-sessions) 上で実行

[スケジュール済みの定期的な作業](https://code.claude.com/docs/ja/desktop-scheduled-tasks.md)、[キーボードショートカット](#keyboard-shortcuts)、または[電話からタスクを送信](#sessions-from-dispatch)については、リンクされたページとセクションを参照してください。既にターミナルベースの CLI を使用している場合は、[CLI 比較](#coming-from-the-cli)を参照して、何が引き継がれるかを確認してください。

## セッションを開始する

最初のメッセージを送信する前に、プロンプトボックスの下の行で環境、プロジェクトフォルダ、権限モード、モデルを選択してください：

* **環境**：行の最初のコントロールである環境セレクタを使用して、Claude が実行される場所を選択します。[環境設定](#environment-configuration)を参照してください。
  * 新しいセッションでプロンプトボックスの下に環境が表示されない場合は、[以前のレイアウトの手順](#check-which-layout-you-have)に従ってください。
* **プロジェクトフォルダ**：環境セレクタの隣にあるプロジェクトフォルダコントロールをクリックして、Claude が作業するフォルダを選択します。
  * **クラウドセッション**：フォルダの代わりに[リポジトリ](#run-long-running-tasks-in-the-cloud)を選択します
  * **[保存済みのローカルまたは SSH 環境](#create-a-saved-environment)**：環境がすでにフォルダを保持しているため、行にはプロジェクトフォルダコントロールが表示されません。フォルダを変更するには、[環境を編集](#use-edit-or-remove-a-saved-environment)します。
* **権限モード**：[モードセレクタ](#choose-a-permission-mode)を使用して、Claude がどの程度の自律性を持つかを選択します。セッション中に権限モードを変更できます。
* **モデル**：行の右端寄りにあるモデルピッカーから[モデル](https://code.claude.com/docs/ja/model-config.md#available-models)を選択します。セッション中にモデルを変更できます。

タスクを入力して**Enter**キーを押してセッションを開始します。各セッションは独自のコンテキストと変更を追跡します。

## コードの操作

Claude に適切なコンテキストを提供し、それが独立して実行する量を制御し、変更内容を確認します。

### プロンプトボックスを使用する

Claude に実行させたいことを入力して**Enter**キーを押して送信します。Claude はプロジェクトファイルを読み取り、[権限モード](#choose-a-permission-mode)に基づいて変更を加えてコマンドを実行します。いつでも Claude を中断できます：停止ボタンをクリックして即座に中断するか、修正を入力して**Enter**キーを押して実行中のアクションを停止せずに送信します。Claude は現在のアクションが完了した後に修正を読み取り、次のステップの前に調整します。

プロンプトボックスの横の\*\*+\*\*ボタンをクリックすると、ファイル添付、[スキル](#use-skills)、[コネクタ](#connect-external-tools)、および[プラグイン](#install-plugins)にアクセスできます。

### 提案されたプロンプトを受け入れる

Claude が返信した後、Code タブでは、空のプロンプトボックスに次のプロンプトの提案がグレーのテキストで表示されることがあります。Claude Code は、会話をもとに短いバックグラウンドリクエストで[各提案を生成](https://code.claude.com/docs/ja/interactive-mode.md#prompt-suggestions)します。このリクエストはプランの使用制限または API コストにカウントされます。

* **提案を使用する**：**Tab** キーまたは **Right arrow** キーを押すと提案がプロンプトボックスに配置されます。必要に応じて編集してから、**Enter** キーを押して送信します。提案を受け入れる前に **Enter** キーを押しても、提案は送信されません。
* **独自のプロンプトを書く**：入力を開始します。提案は、プロンプトボックスが空で、添付ファイルがない場合にのみ表示されます。

提案を停止するには、**Settings > Code** または **Settings > Claude Code** で **Prompt suggestions** をオフにします。各セッションでは、次回の開始または再開時から提案が表示されなくなります。

### ファイルとコンテキストをプロンプトに追加する

Claude にファイルを渡すには、プロンプトボックスでファイルを @mention するか添付します：

* **@mention ファイル**：`@` の後にファイル名を入力して、ファイルを会話コンテキストに追加します。
  * **クラウドセッションの場合**：`@` でファイルを一覧表示できるのは、最初のメッセージを送信した後のみです。`@` で何も表示されない場合は、ファイルなしで最初のメッセージを送信し、次のメッセージでそのファイルを @mention します。
* **ファイルを添付**：プロンプトボックスの横の **+** ボタンから画像、PDF、およびその他のファイルをプロンプトに添付するか、ファイルをプロンプトに直接ドラッグアンドドロップします。これはバグのスクリーンショット、デザインモックアップ、または参照ドキュメントを共有するのに便利です。
  * **[WSL セッション](https://code.claude.com/docs/ja/desktop-wsl.md)の場合**：**+** メニューに **Add files or photos** ではなく **Add image** が表示される場合、添付できるのは画像のみです。セッションのフォルダにあるその他のファイルを Claude に渡すには、そのファイルを @mention します。

### 権限モードを選択する

権限モードは、セッション中に Claude がどの程度の自律性を持つかを制御します：ファイルの編集、コマンドの実行、またはその両方の前に確認するかどうかです。プロンプトボックスの下の行にあるモードセレクタを使用して、いつでも権限モードを切り替えることができます。各変更を自分で承認するには、Manual に切り替えます。

新しいローカルセッションのデフォルトモードを設定するには、[設定ファイル](https://code.claude.com/docs/ja/settings.md#where-settings-live)に`permissions.defaultMode`を追加します。デスクトップアプリは CLI と同じ設定ファイルを読み取ります。セレクタで選択したモードはフォルダごとに記憶され、そのフォルダの`defaultMode`より優先されます。ただし Plan は現在のセッションにのみ適用されます。

| モード | 設定キー | 動作 |
| - | - | - |
| **Manual** | `default` | Claude はファイルの編集またはコマンドの実行の前に確認を求めます。差分を確認し、各変更を受け入れるか拒否できます。 |
| **Accept edits** | `acceptEdits` | Claude はファイル編集と`mkdir`、`touch`、`mv`などの一般的なファイルシステムコマンドを自動的に受け入れますが、他のターミナルコマンドの実行前には確認を求めます。ファイル変更を信頼し、より高速な反復を望む場合に使用します。 |
| **Plan** | `plan` | Claude はファイルを読み取り、コマンドを実行して探索してから、ソースコードを編集せずにプランを提案します。アプローチを最初に確認したい複雑なタスクに適しています。 |
| **Auto** | `auto` | Claude は日常的なプロンプトなしで実行されます。シェルコマンドやネットワークリクエストなどのアクションが実行される前に、バックグラウンド分類器がリクエストとの整合性を確認します。[auto モードが利用可能](#auto-mode-availability)な場合に表示されます。設定用の個別トグルはありません。 |
| **Bypass permissions** | `bypassPermissions` | Claude は権限プロンプトなしで実行されます。ただし、[どのモードも自動承認しないアクション](https://code.claude.com/docs/ja/permission-modes.md#actions-no-mode-auto-approves)、Claude が[外部サイトで機能する](#browse-external-sites)場合の安全分類器、またはセッションの削除などのデスクトップアクション（[セッションのアーカイブ](#work-across-sessions)は含みません）は除きます。CLI の`--dangerously-skip-permissions`と同等です。Pro、Max、および Ultra プランでは、**Settings > Code** または **Settings > Claude Code** の「Allow bypass permissions mode」で有効にします。Team および Enterprise プランでは設定トグルはなく、組織ポリシーで制御されます。サンドボックス化されたコンテナまたは VM でのみ使用してください。 |

Code タブの以前のバージョンでは、これらのモードを Ask permissions、Auto accept edits、および Plan mode というラベルが付けられていました。

`dontAsk`権限モードは[CLI](https://code.claude.com/docs/ja/permission-modes.md#allow-only-pre-approved-tools-with-dontask-mode)でのみ利用可能です。

> [!TIP]
>
> 複雑なタスクを Plan で開始して、Claude が変更を加える前にアプローチをマップアウトするようにします。プランを承認したら、Accept edits または Manual に切り替えて実行します。このワークフローの詳細については、[plan モード](https://code.claude.com/docs/ja/permission-modes.md#analyze-before-you-edit-with-plan-mode)を参照してください。

クラウドセッションは Accept edits、Plan、および Auto をサポートしています。Accept edits は`default`モードに対応しています：クラウドセッションはファイル編集を事前に承認するため、セレクタは Manual ではなく Accept edits を表示します。Bypass permissions はクラウドセッションでは利用できません。[自己ホスト環境](https://code.claude.com/docs/ja/self-hosted-environments)のセッションを含みます。

エンタープライズ管理者は利用可能な権限モードを制限できます。詳細については、[エンタープライズ設定](#enterprise-configuration)を参照してください。

#### auto モードの利用可否

auto モードは Anthropic API のすべてのユーザーが利用でき、Claude Opus 4.6 以降、Sonnet 4.6 以降、Haiku 5.5、または[Fable モデル](https://code.claude.com/docs/ja/model-config.md#work-with-fable)が必要です。組織管理者は[管理設定](#managed-settings)の`disableAutoMode`キーで auto モードをオフにできます。

Desktop を Google Cloud の Agent Platform にルーティングする Enterprise デプロイでも、auto モードはデフォルトで利用可能です。サポートされているモデルについては、[Bedrock、Agent Platform、または Foundry での auto モードの有効化](https://code.claude.com/docs/ja/permission-modes.md#enable-auto-mode-on-bedrock-agent-platform-or-foundry)を参照してください。

### アプリをプレビューする

Claude は dev サーバーを起動し、Browser ペインで開いて変更を確認できます。これはフロントエンド Web アプリとバックエンドサーバーの両方で機能します：Claude は API エンドポイントをテストし、サーバーログを表示し、見つけた問題を反復処理できます。ほとんどの場合、Claude はプロジェクトファイルを編集した後、サーバーを自動的に起動します。いつでも Claude にプレビューを要求することもできます。デフォルトでは、Claude は編集後に[変更を自動検証](#auto-verify-changes)します。

ローカルセッションでは、チャットで HTML、PDF、またはビデオのパスをクリックすると、Browser ペインで開きます。

> [!NOTE]
>
> [SSH セッション](#ssh-sessions)では、Claude は Browser ペインのツールを利用できないため、Browser ペインでアプリを開くことができません。アプリを自分で確認するには、[そのポートをコンピューターに転送](#reach-a-port-on-the-remote-machine)します。

ローカルセッションで Claude がサーバーを起動した後に Browser ペインが開いていない場合は、チャット内のサーバーのカードにある **Open** をクリックします。

Browser ペインから、以下を実行できます：

* Browser ペインで実行中のアプリと直接対話する
* Claude が自動的に独自の変更を検証するのを監視する：スクリーンショットを撮影し、DOM を検査し、要素をクリックし、フォームに入力し、見つけた問題を修正します
* Browser ペインのヘッダーにある **Dev servers** メニューから、サーバーを開始または停止する、またはすべてのサーバーを一度に停止する
* Browser ペインの **⋮** メニューにある **Keep cookies** で、アプリを終了した後も Browser がクッキーを保持するかどうかを選択し、開発中に再度サインインする必要がないようにする

Claude はプロジェクトに基づいて初期サーバー設定を作成します。アプリがカスタム dev コマンドを使用する場合、`.claude/launch.json`を編集してセットアップに合わせます。完全なリファレンスについては、[プレビューサーバーを設定する](#configure-preview-servers)を参照してください。

Browser の保存データをクリアするには、Browser ペインの **⋮** メニューで **Clear browsing data** を選択します。Browser を完全にオフにするには、**Settings > Code** または **Settings > Claude Code** で **Browser tools** をオフにします。

### 外部サイトを閲覧する

Browser ペインはタブ付きブラウザなので、ドキュメント、issue トラッカー、または実行中のアプリの横に他のサイトを開くことができます。Browser を開くには、macOS で**Cmd+Shift+B**、Windows で**Ctrl+Shift+B**を押すか、セッションのタイトルバーにある **Browser** をクリックします。Google OAuth などのポップアップサインインフローを含め、ペイン内でサイトにサインインできます。

チャットで外部リンクを初めてクリックすると、リンクを Browser ペインで開くかデフォルトのブラウザで開くかを尋ねるダイアログが表示されます。後で選択を変更するには、Browser ペインの **⋮** メニューにある **Open links in built-in browser** を使用します。macOS で **Cmd** キーを押しながらクリックするか、Windows で **Ctrl** キーを押しながらクリックすると、デフォルトのブラウザでリンクが直接開きます。

Claude は[アプリを検証](#preview-your-app)するために使用するのと同じツールを使用して外部ページを読み取り、対話できます。2 つの追加の安全チェックがあります：

* 安全分類器は、すべての権限モードで、クリックやタイピングなど、外部ページでの Claude の書き込みアクションを確認します。これらは[auto モード](#choose-a-permission-mode)が使用するのと同じ分類器であり、分類器がアクションを警告した場合、モードに関係なく権限プロンプトが表示されます。
* Auto および Bypass permissions 以外の権限モードでは、Claude が新しいサイトに移動する前にドメイン許可リストチェックも適用されます。

#### サイトで Claude のアクションを承認する

Claude が外部サイトで初めてアクションを実行すると、権限カードが表示され、Claude は選択を待ちます：**Allow once**、**Always allow**、または**Deny**。**Allow once**は何も保存せずにアクションを承認します。**Always allow**はそのサイトの承認をデバイスに保存し、Settings で取り消すことができます。サブドメインを含む各サイトは独自の承認が必要です。ローカル dev サーバーとプロジェクトファイルは承認が不要なため、[auto-verify](#auto-verify-changes)はプロンプトなしで機能し続けます。

承認されたサイトでも、Claude はユーザーの入力なしに商品を購入したり、アカウントを作成したり、CAPTCHA をバイパスしたりしません。Browser ペインでの閲覧は、[Claude in Chrome 拡張機能](https://code.claude.com/docs/ja/chrome.md)と同じ安全モデルを使用します。Claude が機密サイトとリスクのあるアクションをどのように処理するかについては、[Claude in Chrome を安全に使用する](https://support.claude.com/en/articles/12902428-using-claude-in-chrome-safely)を参照してください。

#### Browser と Chrome 拡張機能を選択する

Browser ペインは、個人用ブラウザとは別の、保存されたログインや履歴がないクリーンなブラウザプロファイルを使用します。アプリの構築とテスト、および ID が不要なサイトに使用します。Claude がログイン済みセッションでユーザー本人として機能するようにしたい場合は、代わりにブラウザのログイン状態を共有する[Claude in Chrome 拡張機能](https://code.claude.com/docs/ja/chrome.md)を使用します。

#### 組織の外部閲覧を制限する

Browser は、Claude in Chrome 拡張機能と同じ[サイト許可リストとブロックリストコントロール](https://support.claude.com/en/articles/13065128-claude-in-chrome-admin-controls)に従います。組織が既に拡張機能用にこれらのリストを設定している場合、Browser は自動的にそれらを尊重します。管理者は、[`browserExternalPageTools`管理設定](#managed-settings)で外部ページの Claude のツールをオフにすることもできます。ツールが無効になっている場合、ユーザーは外部サイトに移動できます。Claude のツールはそれらを読み取ったり、アクションを実行したりできません。

外部閲覧を完全に無効にするには、[`disableBrowserExternalNavigation`管理設定](#managed-settings)を`true`に設定します。これは Browser 内のすべての外部ナビゲーションをブロックします。組織の許可リストのサイトを含みます。localhost dev サーバーとファイルプレビューは機能し続けます。`browserExternalPageTools`を使用して、ユーザーが Claude のツールなしで外部サイトの閲覧を続けられるようにし、`disableBrowserExternalNavigation`を使用して、ユーザーと Claude の両方に対して外部サイトをブロックします。

### 差分ビューで変更を確認する

Claude がコードに変更を加えた後、差分ビューを使用して、プルリクエストを作成する前にファイルごとに変更を確認できます。差分ビューを開くには、[セッション詳細パネル](#see-session-details)の **Changes** カードにある `+12 -1` などの行数をクリックします。セッションのタイトルバーにある **Changes** をクリックすることもできます。クラウドセッションのベースブランチに対する差分には、[まだプッシュされていない変更が含まれない場合があります](https://code.claude.com/docs/ja/claude-code-on-the-web.md#troubleshoot-a-missing-file-in-the-diff-view)。

特定の行にコメントするには、行にカーソルを合わせ、行番号の横に表示される **+** をクリックしてコメントボックスを開きます。フィードバックを入力して**Enter**キーを押してコメントを追加します。複数の行にコメントを追加した後、すべてのコメントを一度に送信します：

* **macOS**：**Cmd+Enter**を押す
* **Windows**：**Ctrl+Enter**を押す

Claude はコメントを読み取り、要求された変更を加えます。これは確認できる新しい差分として表示されます。

### コードを確認する

コミット前に Claude に変更をレビューさせるには、[プロンプトボックス](#use-the-prompt-box)に `/code-review` と入力します。レビューが完了すると、結果が会話に表示されます。

ローカル、[SSH](#ssh-sessions)、および [WSL](https://code.claude.com/docs/ja/desktop-wsl.md) セッションでは、結果はファイルごとにグループ化された **Code review** カードとして表示されます。カードを使用して結果に対応します：

* **Walk through in diff** をクリックすると、差分ビューが開き、結果を 1 つずつ確認できます。現在の差分内の結果は該当する行に表示され、そこで **Fix this one** をクリックするか、結果を却下できます。
* **Apply fixes** をクリックすると、まだ未対応の結果を修正するよう Claude に依頼します。

どのセッションでも、プロンプトボックスで Claude にレビュー結果の修正を依頼することもできます。`/code-review` が確認する内容と受け付ける引数については、[`/code-review` でローカルにレビューする](https://code.claude.com/docs/ja/code-review-local)を参照してください。

### プルリクエストステータスを監視する

Claude に失敗したチェックを修正させる、または GitHub にプルリクエストをマージさせるには、**Auto-fix** または **Merge when ready** をオンにします。プルリクエストを開くと、そのプルリクエストが CI チェックのステータスとともに[セッション詳細パネル](#see-session-details)の **Changes** カードに表示されます。タイトルの横にある **⋮** メニューを開きます：

* **Auto-fix**：ローカルセッションでは、ユーザー以外の人が残した新しいレビューコメントにも Claude が対応します。コメントの作成者は、リポジトリのオーナー、組織のメンバー、コラボレーター、または GitHub App である必要があります。
* **Merge when ready**：PR に対して GitHub の auto-merge をオンにします。ローカルセッションでは、ベースブランチがマージキューを使用していない限り、Desktop はスカッシュマージを要求します。
  * **SSH および WSL セッションの場合**：**Merge when ready** は無効になっているため、GitHub でプルリクエストの auto-merge をオンにします
  * **リポジトリが auto-merge を許可していない場合**：**Merge when ready** はオンにならないため、先に [GitHub リポジトリ設定](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/configuring-pull-request-merges/managing-auto-merge-for-pull-requests-in-your-repository)で auto-merge を有効にします
* **[以前のレイアウト](#check-which-layout-you-have)**：セッションにプルリクエストができたら、ステータスバーの **CI** をクリックします。

PR がマージまたはクローズされた後にセッションを自動的にアーカイブするには、**Settings > Code** または **Settings > Claude Code** で[auto-archive](#archive-a-session)をオンにします。

> [!NOTE]
>
> PR 監視には、[GitHub CLI（`gh`）](https://cli.github.com/)がマシンにインストールされ、認証されている必要があります。`gh`がインストールされていない場合、Desktop は PR を作成しようとする最初の時点でインストールを促します。
>
> [SSH セッション](#ssh-sessions)では、Claude はリモートマシン上でブランチをプッシュし、`gh pr create` を実行するため、**Create PR** をクリックする前にリモートマシンで `git` と `gh` をセットアップしてください。SSH セッションでは Desktop がインストールを促さないため、`gh` はリモートマシンに自分でインストールしてください。その後、リモートマシンで `git push` が機能すること、および `gh auth status` がログイン済みであると報告することを確認してください。

## ワークスペースを配置する

Code タブはペインを任意のレイアウトで配置できるように構築されています：チャット、diff、ブラウザ、ターミナル、ファイル、プラン、タスク、およびサブエージェント。macOS では [iOS Simulator](https://code.claude.com/docs/ja/desktop-ios-simulator.md) も含まれます。ペインをヘッダーでドラッグして位置を変更するか、ペインエッジをドラッグしてサイズを変更します。macOS では\*\*Cmd+\\**を、Windows では**Ctrl+\\\*\*を押してフォーカスされたペインを閉じます。

別のペインを開くには、セッションのタイトルバーにあるそのペインのアイコンボタンをクリックします。ホバーすると、**Terminal**、diff ビューの**Changes**、**Browser**、**Files**など、各ボタンの名前が表示されます。開きたいペインのボタンがタイトルバーにない場合は、ボタンの横にある\*\*⋮\*\*メニューから選択します：

* **ウィンドウの幅が狭い場合**：収まらないボタンはメニューに移動します
* **ボタンのないペインの場合**：**Background tasks**や**Plan**などのペインは、それらのペインに表示する内容がセッションに生じると一覧に表示されます

複数の画面で作業するには、diff やターミナルなどのペインをポップアウトして独立したウィンドウにし、完了したらドックバックします。Claude はメインウィンドウで作業を続けます。

> [!NOTE]
>
> このセクションのペインレイアウト、ターミナル、ファイルエディタ、およびビューモードには Claude Desktop v1.2581.0 以降が必要です。macOS では\*\*Claude > Check for Updates…**を、Windows では**Help > Check for Updates…\*\*を開いて更新してください。

### セッションの詳細を確認する

セッション詳細パネルは、チャットの横に表示されるカードのセットで、セッションの実行場所、変更内容、実行中の内容、およびコンテキストの使用状況を表示します。このパネルはセッションを開始した後、チャットの幅が十分にある場合に表示されます。

#### セッション詳細パネルを表示または非表示にする

パネルを表示または非表示にするには、セッションのタイトルバー、またはバーの\*\*⋮**メニューで、**Hide session rail**または**Show session rail\*\*をクリックします。それでもパネルが表示されない場合は、[使用している Code タブのレイアウトを確認してください](#check-which-layout-you-have)。

### ターミナルでコマンドを実行する

統合ターミナルを使用すると、別のアプリに切り替えることなく、セッションと並行してコマンドを実行できます。セッションのタイトルバーにある**Terminal**をクリックするか、macOS または Windows で**Ctrl+\`**を押します。ターミナルはセッションの作業ディレクトリで開き、Claude と同じ環境を共有するため、`npm test`や`git status`などのコマンドは Claude が編集しているのと同じファイルを見ます。2 番目のターミナルタブを開くには、ターミナルペインヘッダーの**+**をクリックするか、チャットのフォルダを右クリックして**Open in terminal**を選択します。

WSL セッションでターミナルがない場合は、[ターミナルまたはコネクタが利用できない場合](https://code.claude.com/docs/ja/desktop-wsl.md#check-for-the-terminal-and-connectors)を参照してください。ターミナルはローカルおよび [SSH](#ssh-sessions) セッションで利用可能ですが、[Windows リモートマシン](#windows-remote-machines)では制限があります。

### ファイルを開いて編集する

Claude が言及したファイルを開くには、チャット内のそのパスをクリックします。

ファイルを自分で編集するには、[ファイルペイン](#arrange-your-workspace)を使用します：

* **ローカルセッション**：セッションの作業ディレクトリ内のファイルを編集できます。ただし、`.mcp.json`や`.claude/settings.json`など、一部の表示専用ファイルは除きます。これらを変更するには、[別のアプリで開いてください](#open-files-in-other-apps)。
* **クラウド、SSH、WSL セッション**：ファイルペインは表示専用のため、Claude に編集を依頼してください。

#### ファイルペインで編集内容を保存する

デフォルトでは、ファイルペインでの編集は自動的に保存されるため、ペインに**Save**ボタンは表示されません。編集内容を自分で保存するには、ペインの\*\*⋮**メニューで**Auto save**のチェックを外します。**Auto save**がオフの場合は、ファイルを変更した後に**Save\*\*をクリックして編集内容を書き込むか、**Cancel**をクリックして元に戻します。

ファイルがディスク上で変更されたことをペインが警告した場合は、**Override**をクリックしてディスク上のバージョンを編集内容で上書きするか、**Discard**をクリックして編集内容を破棄します。

### ファイルを他のアプリで開く

チャット、diff ビューア、またはファイルペイン内のファイルパスを右クリックしてコンテキストメニューを開きます：

* **Attach as context**：ファイルを次のプロンプトに追加
* **Open in**：VS Code、Cursor、Zed などのインストール済みエディタでファイルを開く
* **Show in Finder**（macOS）、**Show in Explorer**（Windows）：含まれるフォルダを開く
* **Copy**：ファイルの**Absolute path**、**Relative path**、または**Filename**をコピーするサブメニュー

### ビューモードを切り替える

ビューモードは、チャットトランスクリプトに表示される詳細の量を制御します。ビューモードを切り替えるには、セッションタイトルの横のキャレットからセッションメニューを開いて**Transcript view**を選択するか、macOS または Windows で**Ctrl+O**を押してモードをサイクルします。Thinking モードは、表示しているセッションで Claude が思考を生成した後にのみメニューに表示されます。

| モード | 表示内容 |
| - | - |
| **Normal** | ツール呼び出しは要約に折りたたまれ、完全なテキスト応答 |
| **Thinking** | ツール呼び出しは要約に折りたたまれ、Claude の思考を含む |
| **Verbose** | すべてのツール呼び出し、ファイル読み取り、Claude が実行した中間ステップ、および Claude の思考 |

ツール呼び出しがまだ折りたたまれた状態で Claude の推論を追跡するには Thinking を使用します。Claude が特定のアクションを実行した理由をデバッグするときは Verbose を使用します。Claude Desktop v1.46388.1 より前のバージョンは Summary モードもリストしており、Summary に設定されたセッションは更新後に Normal で開きます。

### キーボードショートカット

macOS で\*\*Cmd+/**を、Windows で**Ctrl+/\*\*を押して、Code タブで利用可能なすべてのショートカットを表示します。このセクションの表は macOS のキーを示しています。Windows および Linux では、以下のキーを置き換えてください：

* **Cmd+Option**：**Alt**を押す
* **Cmd+Ctrl**：**Ctrl+Alt**を押す
* **Cmd**：**Ctrl**を押す

`Ctrl`で始まるショートカットは、すべてのプラットフォームで同じです。

| ショートカット | アクション |
| - | - |
| `Cmd` `/` | キーボードショートカットを表示 |
| `Cmd` `N` | 新しいセッション |
| `Cmd` `Option` `1`–`9` | [現在のレイアウト](#check-which-layout-you-have)の新しいセッション画面で、環境を選択 |
| `Cmd` `Option` `0` | 現在のレイアウトの新しいセッション画面で、[**New environment** ダイアログ](#create-a-saved-environment)を開く |
| `Cmd` `W` | セッションを閉じる |
| `Ctrl` `Tab` / `Ctrl` `Shift` `Tab` | セッションを切り替え |
| `Cmd` `Shift` `]` / `Cmd` `Shift` `[` | 次または前のセッション |
| `Esc` | Claude の応答を停止 |
| `Tab` / `Right arrow` | 空のプロンプトボックスで[提案されたプロンプトを受け入れる](#accept-a-suggested-prompt) |
| `Cmd` `Shift` `D` | diff ペインを切り替え |
| `Cmd` `Shift` `B` | ブラウザペインを切り替え |
| `Cmd` `Shift` `S` | ブラウザで要素を選択 |
| `Ctrl` `` ` `` | ターミナルペインを切り替え |
| `Cmd` `\` | フォーカスされたペインを閉じる |
| `Cmd` `Ctrl` `W` | フォーカスされたセッションを[分割ビュー](#work-in-parallel-with-sessions)から外す |
| `Cmd` `;` | サイドチャットを開く |
| `Ctrl` `O` | ビューモードをサイクル |
| `Cmd` `Shift` `M` | 権限モードメニューを開く |
| `Cmd` `Shift` `I` | モデルメニューを開く |
| `Cmd` `Shift` `E` | 努力メニューを開く |
| `1`–`9` | 開いているメニューの項目を選択 |

これらのショートカットは Code タブに適用されます。Desktop では、ターミナルの[インタラクティブモード](https://code.claude.com/docs/ja/interactive-mode.md#keyboard-shortcuts)とは異なり、`Shift+Tab`で権限モードをサイクルすることはできません。

### 使用状況を確認する

このセッションのコンテキストウィンドウがどの程度埋まっているかを確認するには、使用している Code タブのレイアウトを確認します：

* **現在のレイアウト**：[セッション詳細パネル](#see-session-details)の**Context**カードのヘッダーにパーセンテージで表示されます。カードを開くと、ウィンドウを使用している内容をカテゴリ別に確認できます。
* **[以前のレイアウト](#check-which-layout-you-have)**：モデルピッカーの横の使用状況リングをクリックします。そのポップオーバーにコンテキストウィンドウの使用状況が表示されます。

どちらのレイアウトでも、プロンプトボックスに`/context`と入力すると、このセッションのコンテキストウィンドウのカテゴリ別の内訳がチャットに出力されます。

どちらのレイアウトにも、モデルピッカーの横に使用状況リングがあります。これをクリックするとプランの使用状況が表示されます。プランの使用状況はすべての Claude Code サーフェス全体で共有されます。

## Claude にコンピューターを使わせる

コンピューター操作（computer use）を使うと、Claude がユーザーと同じようにアプリを開き、画面を操作し、マシン上で直接作業できます。CLI のないデスクトップツールの操作を Claude に依頼したり、GUI でしか行えない作業を自動化したりできます。iOS アプリの実行とテストについては、Desktop は画面を操作する代わりに専用の [iOS Simulator ペイン](https://code.claude.com/docs/ja/desktop-ios-simulator.md)を開きます。このペインはコンピューター操作を有効にしなくても動作します。

> [!NOTE]
>
> コンピューター操作は macOS と Windows で提供されているリサーチプレビューで、Pro、Max、または Ultra プランが必要です。Team プランおよび Enterprise プランでは利用できません。Claude Desktop アプリが起動している必要があります。macOS では、コンピューター操作には macOS 14 以降が必要です。

コンピューター操作はデフォルトでオフになっています。Claude が画面を操作できるようにするには、事前に[設定で有効にしてください](#enable-computer-use)。macOS では、アクセシビリティと画面収録の権限も付与する必要があります。

macOS では、コンピューター操作をバックグラウンドで実行することもできます。ユーザーが作業を続けている間に、Claude は承認済みのアプリで作業します。

> [!WARNING]
>
> [サンドボックス化された Bash ツール](https://code.claude.com/docs/ja/sandboxing.md)とは異なり、コンピューター操作はユーザーが承認したものすべてにアクセスできる実際のデスクトップ上で実行されます。Claude は各アクションをチェックし、画面上のコンテンツに起因するプロンプトインジェクションの可能性を警告しますが、信頼境界は異なります。ベストプラクティスについては、[コンピューター操作の安全ガイド](https://support.claude.com/en/articles/14128542)を参照してください。

### コンピューター操作が使われる場面

Claude がアプリやサービスとやり取りする方法はいくつかあり、コンピューター操作はその中で最も対象範囲が広く、最も低速な方法です。Claude は最も精密なツールから順に試します。

* サービス用の[コネクタ](#connect-external-tools)がある場合、Claude はコネクタを使います。
* タスクがシェルコマンドの場合、Claude は Bash を使います。
* タスクがブラウザでの作業で、[Claude in Chrome](https://code.claude.com/docs/ja/chrome.md) をセットアップ済みの場合、Claude はそれを使います。
* タスクが iOS アプリの実行やテストの場合、Claude は画面操作を使わない [iOS Simulator ペイン](https://code.claude.com/docs/ja/desktop-ios-simulator.md)を使います。
* いずれにも該当しない場合、Claude はコンピューター操作を使います。

[アプリごとのアクセスレベル](#app-permissions)もこれを補強します。ブラウザは表示のみ、ターミナルと IDE はクリックのみに制限されており、コンピューター操作が有効な場合でも Claude が専用ツールを使うよう誘導します。画面操作は、ネイティブアプリ、ハードウェアのコントロールパネル、API のない独自ツールなど、他の手段では到達できないもののために取っておかれます。

### コンピューター操作を有効にする

コンピューター操作はデフォルトでオフになっています。オフの状態でコンピューター操作が必要な作業を依頼すると、設定でコンピューター操作を有効にすればそのタスクを実行できることを Claude が伝えます。

**1. デスクトップアプリを更新する**

Claude Desktop が最新バージョンであることを確認してください。macOS と Windows では [claude.com/download](https://claude.com/download) からダウンロードまたは更新します。Linux ではパッケージマネージャーを使って更新します（[手順](https://code.claude.com/docs/ja/desktop-linux.md)）。その後、アプリを再起動します。

**2. トグルをオンにする**

デスクトップアプリで **Settings** を開き、次のように操作します。

* **Settings メニューに This computer が表示されている場合**: **This computer > System** に移動します
* **それ以外の場合**: **Capabilities** に移動します

**Computer use** の下にある **Enable computer use** をオンにします。

* **Windows**: トグルがすぐに有効になり、セットアップは完了です
* **macOS**: 次のステップに進みます

トグルが表示されない場合は、macOS または Windows で Pro、Max、または Ultra プランを利用していることを確認してから、アプリを更新して再起動してください。

**3. macOS の権限を付与する**

macOS では、トグルが有効になる前に 2 つのシステム権限を付与します。

* **アクセシビリティ**: Claude がクリック、入力、スクロールできるようにします
* **画面収録**: Claude が画面の内容を見られるようにします

設定ページには各権限の現在の状態が表示されます。いずれかが拒否されている場合は、バッジをクリックすると該当するシステム設定のペインが開きます。

### アプリの権限

Claude が初めてアプリを使う必要があるとき、セッション内にプロンプトが表示されます。**Allow for this session** または **Deny** をクリックします。承認は現在のセッションの間、または [Dispatch から起動されたセッション](#sessions-from-dispatch)では 30 分間有効です。

プロンプトには、そのアプリに対して Claude が得る操作のレベルも表示されます。これらのレベルはアプリのカテゴリによって固定されており、変更できません。

| レベル | Claude ができること | 対象 |
| :- | :- | :- |
| 表示のみ | スクリーンショットでアプリを見る | ブラウザ、取引プラットフォーム |
| クリックのみ | クリックとスクロールはできるが、入力やキーボードショートカットは使えない | ターミナル、IDE |
| フルコントロール | クリック、入力、ドラッグ、キーボードショートカットの使用 | その他すべて |

ターミナル、Finder や File Explorer、System Settings や Settings など、影響範囲の広いアプリでは、承認すると何が許可されるかがわかるよう、プロンプトに追加の警告が表示されます。

Settings で[コンピューター操作をオンにした](#enable-computer-use) **Computer use** セクションには、次のオプションがあります。

* **Denied apps**: ここに追加したアプリは、プロンプトを表示せずに拒否されます。Claude が許可されたアプリでのアクションを通じて、拒否されたアプリに間接的に影響を与える可能性はありますが、拒否されたアプリを直接操作することはできません。
* **Unhide apps when Claude finishes**: コンピューター操作がバックグラウンドで実行されていない場合、Claude は作業中に他のウィンドウを非表示にし、承認されたアプリのみを操作します。Claude の作業が終わると、この設定をオフにしない限り、非表示にしたウィンドウは元に戻ります。

## セッションを管理する

各セッションは独立した会話であり、独自のコンテキストと変更があります。複数のセッションを並列で実行するか、サイドチャットを分岐させるか、Claude に他のセッションをチェックしてメッセージを送信させるか、作業をクラウドに送信するか、Dispatch にセッションを電話から開始させることができます。

### セッションで並列に作業する

サイドバーの **+ New** をクリックするか、macOS で **Cmd+N** を、Windows で **Ctrl+N** を押して、複数のタスクを並列で作業します。**Ctrl+Tab** と **Ctrl+Shift+Tab** を押してセッションを切り替えます。

2 つ目のセッションを、現在のセッションの横または独自のウィンドウで開くこともできます：

* **横に並べて表示**：macOS で **Option** を、Windows で **Alt** を押しながらサイドバーのセッションをクリックするか、セッションを右クリックして **Open in**、**Split view** の順に選択します
* **独自のウィンドウで表示**：macOS で **Cmd** を、Windows で **Ctrl** を押しながらセッションをクリックするか、セッションを右クリックして **Open in**、**New window** の順に選択します

分割表示では、最後に開いたペインまたは最後にクリックしたペインにフォーカスがあり、もう一方のペインは暗く表示されます。ペインに表示するセッションを変更するには、そのペイン内をクリックしてフォーカスを移してから、サイドバーのセッションをクリックします。フォーカスされたセッションを分割表示から外すには、macOS で **Cmd+Ctrl+W** を、Windows で **Ctrl+Alt+W** を押します。

#### セッションを独自の worktree で実行する

Git リポジトリであるプロジェクトでは、セッションを開始する前に **Worktree** をオンにすると、プロジェクトの分離されたコピーである独自の [Git worktree](https://code.claude.com/docs/ja/worktrees.md) でセッションを実行できます。デフォルトでは **Worktree** はオフで、Claude はプロジェクトフォルダ自体で作業します。[現在のレイアウト](#check-which-layout-you-have)では、[プロンプトボックスの下の行](#start-a-session)にある **Worktree** ボタンをオンにします。

* **[サードパーティプロバイダー](https://code.claude.com/docs/ja/third-party-integrations.md)を使用する場合**：プロンプトボックスの下の行にプロジェクトフォルダのコントロールが表示されていて **Worktree** ボタンがない場合は、そのコントロールをクリックして **Worktree** をオンにします
* **[保存済みのローカル環境または SSH 環境](#create-a-saved-environment)のデフォルトとして設定する場合**：環境を作成または編集するときに **Worktree** を設定します
* **[以前のレイアウト](#check-which-layout-you-have)**：プロンプトボックスの上にあるブランチ名の横の **worktree** チェックボックスを選択します

Worktrees はデフォルトで`<project-root>/.claude/worktrees/`に保存されます。これはカスタムディレクトリに変更できます：

* **ローカルセッション**：**Settings > Code** または **Settings > Claude Code** で **Worktree location** を設定します
* **SSH セッション**：[SSH 接続](#choose-where-ssh-session-worktrees-go)で **Worktree folder** を設定します

**Settings > Code** または **Settings > Claude Code** で **Branch prefix** を設定することもできます。Desktop はすべての worktree ブランチ名の前にこれを付加するため、Claude が作成したブランチを整理するのに便利です。

gitignored ファイル（`.env`など）を新しい worktrees に含めるには、プロジェクトルートに[`.worktreeinclude`ファイル](https://code.claude.com/docs/ja/worktrees#copy-gitignored-files-into-worktrees)を作成します。worktree セッションがプロジェクト設定、フック、スキルをどこから読み取るかについては、[worktree がメインのチェックアウトと共有するもの](https://code.claude.com/docs/ja/worktrees.md#what-worktrees-share-with-the-main-checkout)を参照してください。

> [!NOTE]
>
> セッション分離には[Git](https://git-scm.com/downloads)が必要です。ほとんどの Mac には Git がデフォルトで含まれています。Terminal で`git --version`を実行して確認してください。バージョン番号が表示されれば、Git がインストールされています。Git エラーが発生した場合は、[Cowork](https://claude.com/product/cowork) で Claude に助けを求めてセットアップのトラブルシューティングを行ってください。

### セッションにフォルダを追加する

フォルダはセッションの開始前または実行中に追加できます：

* **ローカルセッションの開始前**：[保存済み環境を作成](#create-a-saved-environment)または編集するときに **Folders** の下にフォルダを追加し、[その保存済み環境からセッションを開始](#use-edit-or-remove-a-saved-environment)します。
* **ローカルまたは [SSH](#ssh-sessions) セッションの実行中**：プロンプトボックスの横の **+** をクリックし、**Add folder** を選択します。Claude は [worktree](#run-a-session-in-its-own-worktree) を使わず、そのフォルダ自体で作業します。

### セッションをアーカイブする

worktree にコミットされていない変更があるセッションをアーカイブする前に、[セッションのアーカイブ時にコミットされていない変更を保持する](#keep-uncommitted-changes-when-a-session-is-archived)を参照してください。セッションをアーカイブするには、サイドバーでセッションにマウスを合わせてメニューを開き、**Archive** を選択します。セッションは[アーカイブ済みセッション](#organize-and-find-sessions)に移動します。

プルリクエストがマージまたはクローズされたときにセッションを自動的にアーカイブするには、**Settings > Code** または **Settings > Claude Code** で **Auto-archive after PR merge or close** をオンにします。クラウドセッションとまだ実行中のセッションは自動的にアーカイブされません。

#### セッションのアーカイブ時にコミットされていない変更を保持する

セッションがアーカイブされると、セッションの worktree にあるコミットされていない変更が失われる可能性があるため、保持したいものは先にコミットしてください：

* **Desktop が変更について確認してきた場合**：**Archive anyway** を選択して変更を破棄するか、キャンセルしてコミットします
* **変更が追跡されていないファイルのみの場合**：セッション内で Claude が作成したプルリクエストがマージされる前に、保持したいファイルをコミットします。マージ後は Desktop が確認なしにそれらを削除できるためです
* **それ以外の場合**：worktree は変更とともにディスク上に残ります。ローカルセッションの場合、Desktop はセッションがアーカイブされた時点または最後にセッションを開いた時点のいずれか遅いほうから約 30 日後に、その両方を削除します。変更を保持するには、[**Archived** タブ](#organize-and-find-sessions)からセッションを開き、**Unarchive** を選択します

### セッションを整理して見つける

セッションのグループ化、並べ替え、検索は、サイドバーのセッションリストにあるアイコンから行います：

* **現在のレイアウト**：セッションリストの見出しにマウスを合わせると **Group and sort** アイコンが表示されるので、それをクリックします。アーカイブ済みセッションを見つけるには、メニューの最後の行である **View all** を選択し、**Archived** タブを開きます。
* **[以前のレイアウト](#check-which-layout-you-have)**：**Filter** アイコンはマウスを合わせなくても表示されます。これをクリックし、**Group by** または **Sort by** でリストを整理します。アーカイブ済みセッションを表示するには、**Status** を選択し、次に **Archived** を選択します。

セッション名を変更するには、セッションを開いてタイトルバーのセッションタイトルをクリックします。

### コンテキストを確認して解放する

コンテキスト使用状況を確認するには、[使用状況を確認する](#check-usage)を参照してください。コンテキストがいっぱいになると、Claude は自動的に会話を要約して作業を続けます。`/compact`を入力して要約をより早くトリガーし、コンテキストスペースを解放することもできます。[コンテキストウィンドウ](https://code.claude.com/docs/ja/how-claude-code-works.md#the-context-window)を参照して、圧縮がどのように機能するかについての詳細を確認してください。

### セッションの完了時に通知を受け取る

デスクトップアプリは、Code セッションがタスクを完了し、現在そのセッションを表示していない場合に OS 通知を送信します。[プロジェクト](https://code.claude.com/docs/ja/claude-projects.md#see-what-needs-you-in-overview)に属するセッションの場合、代わりにプロジェクトの通知を受け取ります。

### メインセッションを脱線させずにサイドクエスチョンを尋ねる

サイドチャットを使用すると、セッションのコンテキストを使用するが、メインの会話に何も追加しない質問を Claude に尋ねることができます。コードの一部を理解したい、仮定を確認したい、またはセッションを脱線させずにアイデアを探索したい場合に使用します。

macOS で\*\*Cmd+;**を、Windows で**Ctrl+;\*\*を押してサイドチャットを開くか、プロンプトボックスで`/btw`を入力します。サイドチャットはその時点までのメインスレッドのすべてを読み取ることができます。完了したら、サイドチャットを閉じてメインセッションを続行します。

サイドチャットはローカル、SSH、および WSL セッションで利用可能です。デスクトップアプリはサイドチャットをディスクに保存しないため、アプリを閉じた後に戻ることはできません。

### バックグラウンドタスクを監視する

タスクペインは、現在のセッション内で実行されているバックグラウンド作業を表示します：サブエージェント、バックグラウンドシェルコマンド、および[動的ワークフロー](https://code.claude.com/docs/ja/workflows.md)。セッションにバックグラウンド作業がある場合は、タイトルバーの **⋮** メニューにある **Background tasks** からペインを開きます。

任意のエントリをクリックして、サブエージェントペインで出力を確認するか、停止します。他のセッションが何をしているかを確認するには、[サイドバー](#work-in-parallel-with-sessions)を使用するか、Claude に[それらをチェックしてもらう](#work-across-sessions)ことができます。

### セッション間で作業する

Claude は他の Code タブセッションをリストアップし、各セッションが何をしてきたかを読み取り、セッション間でメッセージを送信できます。平易な言語で尋ねてください：「どのセッションが認証リファクタリングに触れましたか？」、「API セッションは何を結論づけましたか？」、または「支払いセッションにスキーマが変更されたことを伝えてください」。

また、Claude にセッションの名前変更またはアーカイブを依頼することもできます。たとえば、PR がマージされたセッションをアーカイブするよう依頼してください。

このサーフェスを通じて、Claude はデスクトップアプリが自身で実行するセッションのみを見ます：ローカル、[SSH](#ssh-sessions)、および Code タブの[WSL](https://code.claude.com/docs/ja/desktop-wsl.md)セッション。Claude はクラウドセッション、またはターミナル CLI または VS Code 拡張機能から開始したセッションを見ません。同じプロジェクトの worktrees にあっても見ません。そのため、9 つのターミナル worktrees が開いていて 2 つのデスクトップセッションがある場合、それらの 1 つで回答する Claude は他の 1 つのデスクトップセッションを報告します。Claude は質問しているセッションをリストアップしません。デフォルトでは、最近アクティブな 20 個のセッションを見て、アーカイブされたセッションをスキップします。ただし、それらを要求する場合を除きます。[クロスセッションメッセージング](https://code.claude.com/docs/ja/cross-session-messaging.md)は、Claude が[他の Claude Code セッション](https://code.claude.com/docs/ja/cross-session-messaging.md#see-which-sessions-claude-can-reach)（ターミナルセッションを含む）にメッセージを送信することを別途許可します。

Claude がこのサーフェスを通じて別のセッションにメッセージを送信する場合、Claude Code はそこにカードとして表示され、送信セッションのタイトルでラベル付けされ、戻るリンクが付いているため、メッセージがどこから来たかを常に知ることができます。受信セッションがタスクの途中にある場合、Claude Code はメッセージを保持し、Claude は現在の作業が完了したら読み取ります。受信する Claude は返信でき、Claude Code はこのサーフェスを通じて返信を配信します。Claude はアーカイブされたセッションに配信できず、メッセージが届かない場合は通知します。

Claude Code はセッション間で 3 つの安全動作を適用します：

* Claude がセッションをアーカイブする前に承認カードが表示されます。ただし、auto モードと Bypass permissions モードでは、Claude は承認カードなしでセッションをアーカイブできます。確認を求められるようにするには、Manual に切り替えてください。
* Claude Code は、受信セッションが[クロスセッションメッセージング](https://code.claude.com/docs/ja/cross-session-messaging.md#availability)自体を持たない場合でも、このサーフェスからの各メッセージを受信セッションの[インバウンドコントロール](https://code.claude.com/docs/ja/cross-session-messaging.md#control-inbound-messages)に対してチェックします。受信セッションで[`crossSessionInbound`](https://code.claude.com/docs/ja/settings-reference#crosssessioninbound)を`refuse`に設定した場合、Claude Code はこのサーフェスからのメッセージをドロップします。Claude Code は拒否を Claude デスクトップアプリに報告します。v2.1.234 より前では、Claude Code はこのサーフェスからクロスセッションメッセージングを持たない受信セッションへのすべてのメッセージをドロップしました。
* Claude Code は各受信メッセージを引用して送信元のセッションを明示し、Claude はメッセージに基づいて行動する際も受信セッション自体の権限設定に従います。

### Claude が提案するタスクを開始する

現在のタスクの範囲外で修正する価値があるものに気付くと、Claude はその作業をタスクとして提案します。[現在のレイアウト](#check-which-layout-you-have)のローカルセッションと SSH セッションでは、提案はチャット内のカードとして表示され、そのボタンでタスクを開始するか、このセッション内で行うかを選べます：

* **Start**：別のセッションでタスクを開始します。デフォルトでは、タスクは現在のセッションの環境で実行されます。その後、カードには開始されたセッションの状態が表示され、[サイドバー](#work-in-parallel-with-sessions)では開始されたセッションが現在のセッションの下に表示されます。
* **Do it here**：タスクをメッセージとして現在のセッションに送信します
* **Options**：**Start** をクリックする前に、環境、モデル、[worktree](#run-a-session-in-its-own-worktree)、権限などの設定を確認または変更します
* **Start all**：カードに複数のタスクが表示されている場合、1 つのタスクの完了を待たずに、各タスクをそれぞれ独自のセッションで開始します

クラウドセッション、および以前のレイアウトのローカルセッションと SSH セッションでは、提案は **Suggested task** カードとして表示されます。カードのメインボタンに示された方法（たとえば **Send to cloud** や **Start with worktree**）でタスクを開始するには、そのボタンをクリックします。**Do it here** を含む、タスクを開始する他の方法を選ぶには、メインボタンの横のキャレットをクリックします。

### 長時間実行されるタスクをクラウドで実行する

大規模なリファクタリング、テストスイート、マイグレーション、またはその他の長時間実行されるタスクの場合、セッションを開始するときに[環境セレクター](#start-a-session)の **Cloud** の下にある環境を選択します。クラウドセッションはデフォルトで Anthropic が管理するインフラストラクチャで実行され、アプリを閉じたりコンピュータをシャットダウンしたりしても続行します。いつでも戻ってきて進捗を確認するか、Claude を別の方向に導くことができます。[claude.ai/code](https://claude.ai/code)または[Claude モバイルアプリ](https://code.claude.com/docs/ja/mobile.md)からクラウドセッションを監視することもできます。

クラウドセッションは複数のリポジトリもサポートしています。リポジトリは次の場所で選択します：

* **現在のレイアウト**：クラウド環境を選択した後、プロンプトボックスの下の行で選択します。
* **[以前のレイアウト](#check-which-layout-you-have)**：プロンプトボックスの上で選択します。別のリポジトリを追加するには、選択されたリポジトリの横の **+** をクリックします。

クラウドセッションがどのように機能するかについての詳細については、[クラウドで Claude Code を使用する](https://code.claude.com/docs/ja/claude-code-on-the-web.md)を参照してください。1 つの作業本体が多くのクラウドセッションを必要とする場合は、[プロジェクト](https://code.claude.com/docs/ja/claude-projects.md)を使用します。Claude が 1 つの会話からセッションを開始して追跡します。手順については[プロジェクトを作成する](https://code.claude.com/docs/ja/claude-projects.md#create-a-project)を参照してください。

> [!NOTE]
>
> [SSH セッション](#ssh-sessions)のタスクも [Desktop が切断されている間も実行を続ける](#keep-a-task-running-while-desktop-is-disconnected)ことができますが、Claude アカウントを使用している場合は、サインインの有効期限が切れると停止することがあります。

### 別のサーフェスで続行する

セッションを別の場所で続行するには、セッションタイトルの横のキャレット、またはサイドバーのセッションの行からセッションメニューを開き、**Open in**を選択します：

* **Cloud**を選択すると、会話を要約として引き継いだうえで、セッションを[クラウドセッション](https://code.claude.com/docs/ja/claude-code-on-the-web.md)として続行します。確定する前に、ファイルも移動するかどうか、およびクラウドセッションの準備ができた時点でこのセッションがアーカイブされるかどうかがダイアログに表示されます。[SSH](#ssh-sessions) 経由または [WSL](https://code.claude.com/docs/ja/desktop-wsl.md) で実行されるセッションは、この方法で移動できません。
* インストール済みのエディタまたはファイルマネージャーを選択すると、セッションのディスク上のフォルダをそこで開きます。

### 他のデバイスに表示するセッションを制御する

ローカルセッションは、[Remote Control](https://code.claude.com/docs/ja/remote-control.md) によって接続されると、他のデバイスに表示されます。接続されたセッションは、[claude.ai/code](https://claude.ai/code) のセッションリストと、claude.ai アカウントにサインインしているデバイス上の Claude アプリに表示されます。

ローカルセッションは、そのセッションで Remote Control をオンにしたとき、または開始時に自動的に接続されるときに接続されます：

* **そのセッションでオンにする**：セッションの **Remote Control** スイッチを使用するか、プロンプトボックスに `/remote-control` と入力します。
* **開始時に接続される**：**Settings > Code** または **Settings > Claude Code** で **Connect new sessions to Remote Control** がオンの間、新しいセッションは自動的に接続されます。この設定を一度も変更していない場合、Desktop はユーザー設定または管理設定の [`remoteControlAtStartup`](https://code.claude.com/docs/ja/settings-reference#remotecontrolatstartup) に従い、次に組織のデフォルトに従います。

セッションが接続されているかどうかを確認するには、[セッション詳細パネル](#see-session-details)の **Environment** カードにある **Remote Control** スイッチを確認します。

セッションを他のデバイスに表示しないようにするには、必要なレベルで Remote Control をオフにします：

* **1 つのセッション**：そのセッションの **Remote Control** スイッチをオフにします。開始時に接続されたセッションで `/remote-control` と入力すると、Remote Control はオンのままとなり、`Remote Control is already on. This session connected automatically when it started.` と表示されます。切断するには、その行の **Turn off** をクリックします。
* **このコンピュータ上の新しい Desktop セッション**：**Settings > Code** または **Settings > Claude Code** で **Connect new sessions to Remote Control** をオフにします。すでにオフと表示されている場合は、一度オンにしてからオフにすると、Desktop が選択を保存します。保存されると、`remoteControlAtStartup` およびデフォルトよりも優先されます。
* **CLI を含む、このコンピュータ上のすべてのセッション**：`~/.claude/settings.json` で [`disableRemoteControl`](https://code.claude.com/docs/ja/settings-reference#disableremotecontrol) を `true` に設定すると、セッションが接続されなくなります。ファイルを保存した時点ですでに接続されていたセッションは、そのセッションで Remote Control をオフにするまで接続されたままです。

他のデバイスにすでに表示されているセッションを非表示にするには、Desktop でそのセッションをアーカイブします。Desktop はセッションの Remote Control 側のコピーもアーカイブするため、それらのデバイスのデフォルトのセッションリストから消えます。そこで表示または削除するには、[セッションをアーカイブする](https://code.claude.com/docs/ja/claude-code-on-the-web.md#archive-sessions)を参照してください。

### Dispatch からのセッション

[Dispatch](https://support.claude.com/en/articles/13947068)は、[Cowork](https://claude.com/product/cowork) 内に存在する Claude との永続的な会話です。Dispatch にタスクをメッセージで送信すると、それをどのように処理するかを決定します。

タスクは 2 つの方法で Code セッションになります：「Claude Code セッションを開いてログインバグを修正する」など直接要求するか、Dispatch がタスクが開発作業であると判断して自動的に生成するかです。通常 Code にルーティングされるタスクには、バグの修正、依存関係の更新、テストの実行、またはプルリクエストの作成が含まれます。リサーチ、ドキュメント編集、スプレッドシート作業は Cowork に留まります。

#### Dispatch が開始したセッションを追跡する

Dispatch が開始したセッションは、Code タブのサイドバーに他のセッションと一緒に表示されます。サイドバーの[デフォルトのグループ化と並べ替え](#organize-and-find-sessions)では、そのセッションが実行されているフォルダのグループ内で最も新しいセッションを探してください。完了したときまたは承認が必要なときに、電話でプッシュ通知を受け取ります。

[コンピュータ使用](#let-claude-use-your-computer)が有効な場合、Dispatch が生成した Code セッションもそれを使用できます。これらのセッションのアプリ承認は 30 分後に期限切れになり、通常の Code セッションのようにセッション全体を続けるのではなく、再度プロンプトが表示されます。

#### Dispatch をセットアップする

* **プラン**：Dispatch には Pro、Max、または Ultra プランが必要であり、Team または Enterprise プランでは利用できません
* **セットアップ、ペアリング、Dispatch 設定**：[Dispatch ヘルプ記事](https://support.claude.com/en/articles/13947068)を参照してください

Dispatch は、ターミナルから離れているときに Claude で作業する複数の方法の 1 つです。他のオプションとの比較については、[プラットフォームと統合](https://code.claude.com/docs/ja/platforms.md#work-when-you-are-away-from-your-terminal)を参照してください。

## Claude Code を拡張する

外部サービスの接続、再利用可能なワークフローの追加、Claude の動作のカスタマイズ、プレビューサーバーの設定を行えます。コネクタ、スキル、プラグインを一か所で管理するには、サイドバーの **Customize** をクリックします。デスクトップアプリの [Cowork](https://claude.com/product/cowork) は、スキル、プラグイン、コネクタを CLI の `~/.claude` ディレクトリからではなく、claude.ai アカウントを通じて同期されるこの Customize の設定から取得します。

Claude Code は、同じアカウントでサインインしたターミナルセッションでも、claude.ai アカウントで有効になっているスキルとプラグインを読み込みます。[claude.ai から同期されたスキル](https://code.claude.com/docs/ja/skills.md#how-synced-skills-behave)および [claude.ai から同期されたプラグイン](https://code.claude.com/docs/ja/plugins/loading.md#synced-plugins)を参照してください。

### 外部ツールを接続する

コネクタは、グラフィカルなセットアップフローを備えた [MCP サーバー](https://code.claude.com/docs/ja/mcp.md)です。

Claude アカウントを使用するローカルセッションまたは [SSH](#ssh-sessions) セッションでコネクタを追加するには、セッションの開始前または開始後に、プロンプトボックスの横にある **+** をクリックします。**Add connectors** を選択するとコネクタディレクトリが開きます。メニューに **Connectors** が表示される場合は、それを選択してから **Browse connectors** を選択します。

> [!NOTE]
>
> 以下のケースは別のページで説明しています。
>
> * **WSL セッションで Connectors がグレーアウトしている場合**：[ターミナルまたはコネクタが利用できない場合](https://code.claude.com/docs/ja/desktop-wsl.md#check-for-the-terminal-and-connectors)を参照してください
> * **クラウドセッション**：[コネクタが Claude Code に届く仕組み](https://code.claude.com/docs/ja/mcp.md#how-connectors-reach-claude-code)を参照してください

接続すると、Claude はカレンダーの読み取り、メッセージの送信、issue の作成など、ツールを直接操作できるようになります。セッションで設定されているコネクタを Claude に尋ねることもできます。コネクタを管理または切断するには、サイドバーの **Customize** をクリックし、**Connectors** を開きます。

Connectors に掲載されていないインテグレーションについては、[設定ファイル](https://code.claude.com/docs/ja/mcp.md#installing-mcp-servers)を使用して MCP サーバーを手動で追加します。[カスタムコネクタを作成する](https://support.claude.com/en/articles/11175166-getting-started-with-custom-connectors-using-remote-mcp)こともできます。

### スキルを使用する

[スキル](https://code.claude.com/docs/ja/skills.md)は Claude ができることを拡張します。Claude は関連する場面でスキルを自動的に読み込みます。また、スキルを直接呼び出すこともできます。プロンプトボックスに `/` と入力するか、**+** ボタンをクリックして **Slash commands** を選択すると、利用可能なものを一覧できます。これには、[組み込みコマンド](https://code.claude.com/docs/ja/commands.md)、[カスタムスキル](https://code.claude.com/docs/ja/skills.md#create-your-first-skill)、コードベースのプロジェクトスキル、[インストール済みのプラグイン](https://code.claude.com/docs/ja/plugins/install.md)のスキルが含まれます。いずれかを選択すると、入力フィールドにハイライト表示されます。その後にタスクを入力し、通常どおり送信します。

Claude の作業中でも、他のメッセージと同様にコマンドを送信でき、ターンが完了するとセッションはアイドル状態に戻ります。

ローカルセッションは、`~/.claude/skills/` から個人用スキルを読み込みます。[SSH](#ssh-sessions) セッションは、ユーザーのマシンではなく、リモートホストのホームディレクトリにある `~/.claude/skills/` を読み取ります。

ローカルセッションとクラウドセッションは、claude.ai アカウントで有効になっているスキルも読み込みます。ただし、組織が [`disableSideloadFlags`](https://code.claude.com/docs/ja/settings-reference#disablesideloadflags) を設定している場合のローカルセッションは除きます。クラウドセッションは、[Cowork とクラウドセッションのスキル](https://code.claude.com/docs/ja/skills.md#skills-in-cowork-and-cloud-sessions)で説明しているとおり、`~/.claude/skills/` の代わりにこれらのスキルを読み込みます。

### プラグインをインストールする

[プラグイン](https://code.claude.com/docs/ja/plugins/overview.md)は、スキル、エージェント、フック、MCP サーバー、LSP 設定を Claude Code に追加する再利用可能なパッケージです。ターミナルを使用せずに、デスクトップアプリからプラグインをインストールできます。

ローカルセッションまたは [SSH セッション](#ssh-sessions)で、プロンプトボックスの横にある **+** をクリックし、**Add plugins** を選択するとプラグインブラウザが開きます。メニューに **Plugins** が表示される場合は、それを選択してから **Browse plugins** を選択します。プラグインを有効化、無効化、またはアンインストールするには **Manage plugins** を選択します。

プラグインのスコープは、ユーザーアカウント、特定のプロジェクト、またはローカルのみに設定できます。組織がプラグインを一元管理している場合、それらのプラグインは CLI と同じようにデスクトップセッションでも利用できます。ただし、デスクトップアプリが [`disableSideloadFlags` により保留する](https://code.claude.com/docs/ja/settings-reference#disablesideloadflags)ものは除きます。

プラグインブラウザはクラウドセッションでは利用できず、デスクトップアプリからインストールしたプラグインもクラウドセッションでは利用できません。また、[セットアップから引き継がれるもの](https://code.claude.com/docs/ja/cloud-environments.md#what-carries-over-from-your-setup)で説明しているとおり、クラウドセッションは、リポジトリの `.claude/settings.json` で宣言されているプラグインもインストールしません。プラグインは WSL セッションでは利用できません。独自のプラグインの作成を含むプラグインの完全なリファレンスについては、[プラグイン](https://code.claude.com/docs/ja/plugins/overview.md)を参照してください。

### プレビューサーバーを設定する

Claude は開発サーバーのセットアップを自動的に検出し、セッション開始時に選択したフォルダーのルートにある `.claude/launch.json` に設定を保存します。プレビューはこのフォルダーを作業ディレクトリとして使用するため、親フォルダーを選択した場合、独自の開発サーバーを持つサブフォルダーは自動的に検出されません。サブフォルダーのサーバーを使用するには、そのフォルダーで直接セッションを開始するか、設定を手動で追加します。

サーバーの起動方法をカスタマイズするには（たとえば `npm run dev` の代わりに `yarn dev` を使用する場合やポートを変更する場合など）、`.claude/launch.json` を編集します。このファイルはコメント付きの JSON をサポートしています。

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

複数の設定を定義して、フロントエンドと API など、同じプロジェクトから異なるサーバーを実行できます。以下の[例](#examples)を参照してください。

#### 変更を自動検証する

`autoVerify` が有効になっている場合、Claude はファイルを編集した後にコードの変更を自動的に検証します。応答を完了する前に、スクリーンショットを撮り、エラーをチェックし、変更が機能することを確認します。

自動検証はデフォルトでオンになっています。プロジェクトごとに無効にするには、`.claude/launch.json` に `"autoVerify": false` を追加するか、Browser ペインの **⋮** メニューで **Auto-verify changes** をオフにします。

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

無効にした場合でもプレビューツールは引き続き利用でき、いつでも Claude に検証を依頼できます。自動検証は、編集のたびにこれを自動的に行います。

#### 設定フィールド

`configurations` 配列の各エントリは、以下のフィールドを受け付けます。

| フィールド | 型 | 説明 |
| - | - | - |
| `name` | string | このサーバーの一意の識別子 |
| `runtimeExecutable` | string | 実行するコマンド（`npm`、`yarn`、`node` など） |
| `runtimeArgs` | string\[] | `runtimeExecutable` に渡される引数（`["run", "dev"]` など） |
| `port` | number | サーバーがリッスンするポート。デフォルトは 3000 |
| `cwd` | string | プロジェクトルートからの相対パスで指定する作業ディレクトリ。デフォルトはプロジェクトルート。プロジェクトルートを明示的に参照するには `${workspaceFolder}` を使用します |
| `env` | object | キーと値のペアで指定する追加の環境変数（`{ "NODE_ENV": "development" }` など）。このファイルはリポジトリにコミットされるため、シークレットはここに記述しないでください。シークレットについては、[開発サーバーの環境変数を設定する](#set-environment-variables-for-dev-servers)を参照してください。 |
| `autoPort` | boolean | ポートの競合の処理方法。[ポートの競合](#port-conflicts)を参照してください |
| `program` | string | `node` で実行するスクリプト。[`program` と `runtimeExecutable` の使い分け](#when-to-use-program-vs-runtimeexecutable)を参照してください |
| `args` | string\[] | `program` に渡される引数。`program` が設定されている場合にのみ使用されます |
| `url` | string | `http://localhost:<port>` の代わりにプレビューが開くアドレス。[特定の URL でプレビューを開く](#open-the-preview-at-a-specific-url)を参照してください |

##### `program` と `runtimeExecutable` の使い分け

パッケージマネージャー経由で開発サーバーを起動するには、`runtimeExecutable` と `runtimeArgs` を使用します。たとえば、`"runtimeExecutable": "npm"` と `"runtimeArgs": ["run", "dev"]` を組み合わせると `npm run dev` が実行されます。

`node` で直接実行したいスタンドアロンのスクリプトがある場合は、`program` を使用します。たとえば、`"program": "server.js"` は `node server.js` を実行します。追加のフラグは `args` で渡します。

##### 特定の URL でプレビューを開く

デフォルトでは、プレビューは `http://localhost:<port>` を開きます。サーバーに別のアドレスが必要な場合は `url` を設定します。よくあるケースは、ローカル HTTPS が必要なサーバー、`*.localhost` サブドメインを使用するアプリ、リダイレクト経由でサインインさせるアプリです。

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

localhost アドレスは、デフォルトのポートアドレスとまったく同じように直接開きます。これには `localhost`、任意の `*.localhost` サブドメイン、`127.0.0.1`、`::1` が含まれます。セキュリティ上の理由から、localhost の `url` はサーバーのオリジンのみで、パスやクエリを含めることはできません。そのポートはエントリのポートと一致している必要があります。特定のページを表示するには、プレビューが開いた後に Claude にそのページへ移動するよう依頼します。パス、クエリ、または一致しないポートを含む localhost の `url` は設定エラーとして報告され、その url と修正方法が表示されます。

それ以外のアドレスについては、プレビューがそのアドレスを初めて開くときに、プレビューで新しいサイトを閲覧する場合と同様に、Desktop が権限を求めます。外部アドレスにはパスを含めることができます。**Always allow** を選択すると、以降そのサイトについてのプロンプトがスキップされます。プレビューで外部サイトを制限する組織のポリシーは引き続き適用されます。

自分ですでに実行しているサーバーをプレビューするには、コマンドを指定せずに `url` を設定します。Claude はサーバーを起動する代わりに、実行中のサーバーにプレビューを接続します。

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

`url` は `http` または `https` である必要があり、ユーザー名やパスワードを含めることはできません。

#### ポートの競合

`autoPort` フィールドは、希望するポートがすでに使用中の場合の動作を制御します。

* **`true`**：Claude は空いているポートを自動的に見つけて使用します。ほとんどの開発サーバーに適しています。
* **`false`**：Claude はエラーで失敗します。OAuth コールバックや CORS 許可リストなど、サーバーが特定のポートを使用する必要がある場合に使用します。
* **未設定（デフォルト）**：以下の 1 つのケースを除き、`true` の場合と同様に、サーバーには次の空いているポートが割り当てられます。Claude Desktop v2.37337.0 より前では、代わりにサーバーがそのポートを厳密に必要とするかどうかを Claude が尋ね、回答を `launch.json` に保存します。

希望するポートが使用中で `autoPort` が未設定の場合、以下の条件がすべて満たされると、サーバーは停止したままになります。

* `npm`、`yarn`、`pnpm`、または `bun` スクリプトを通じてサーバーを起動している。
* 希望するポートがそのスクリプトにハードコードされている、または Claude がスクリプトを検査できない。
* `runtimeArgs` でポートを渡していない。

その場合は、ポートを解放するか、ハードコードされた値を削除するか、スクリプトに合わせて `port` を変更します。代わりに `"autoPort": true` を設定する方法は、`PORT` を読み取るスクリプトでのみ機能します。

割り当てられたポートを保持する `PORT` 環境変数からポートを読み取るよう、サーバーを構成してください。Claude がサーバーを別のポートに移動する際には、`runtimeArgs` 内の `--port` または `-p` の値も一致するように書き換えます。

#### 例

以下の設定は、さまざまなプロジェクトタイプの一般的なセットアップを示しています。

> [tab] Next.js
>
> この設定は、Yarn を使用してポート 3000 で Next.js アプリを実行します。
>
> ```json theme={null}
> {
>   "version": "0.0.1",
>   "configurations": [
>     {
>       "name": "web",
>       "runtimeExecutable": "yarn",
>       "runtimeArgs": ["dev"],
>       "port": 3000
>     }
>   ]
> }
> ```

> [tab] 複数のサーバー
>
> フロントエンドと API サーバーを持つモノレポでは、複数の設定を定義します。フロントエンドは `autoPort: true` を使用するため、3000 が使用中の場合は空いているポートを選択します。一方、API サーバーはポート 8080 を厳密に必要とします。
>
> ```json theme={null}
> {
>   "version": "0.0.1",
>   "configurations": [
>     {
>       "name": "frontend",
>       "runtimeExecutable": "npm",
>       "runtimeArgs": ["run", "dev"],
>       "cwd": "apps/web",
>       "port": 3000,
>       "autoPort": true
>     },
>     {
>       "name": "api",
>       "runtimeExecutable": "npm",
>       "runtimeArgs": ["run", "start"],
>       "cwd": "server",
>       "port": 8080,
>       "env": { "NODE_ENV": "development" },
>       "autoPort": false
>     }
>   ]
> }
> ```

> [tab] Node.js スクリプト
>
> パッケージマネージャーのコマンドを使用せずに Node.js スクリプトを直接実行するには、`program` フィールドを使用します。
>
> ```json theme={null}
> {
>   "version": "0.0.1",
>   "configurations": [
>     {
>       "name": "server",
>       "program": "server.js",
>       "args": ["--verbose"],
>       "port": 4000
>     }
>   ]
> }
> ```

## 環境設定

[セッションを開始する](#start-a-session)ときに選択する環境は、Claude が実行される場所と接続方法を決定します：

* **Local**：マシンで実行され、ファイルに直接アクセスできます
* **Cloud**：デフォルトで Anthropic が管理するインフラストラクチャで実行されます。アプリを閉じても、セッションは続行されます。
* **SSH**：SSH 経由で接続するリモートマシンで実行されます。たとえば、独自のサーバー、クラウド VM、または dev コンテナなどです。実行中のタスクは [Desktop が切断されている間も続行できます](#keep-a-task-running-while-desktop-is-disconnected)が、Claude アカウントの場合はサインインの期限が切れると停止することがあります。
* **WSL**（Windows）：マシン上の [WSL 2 ディストリビューション](https://code.claude.com/docs/ja/desktop-wsl.md)内で実行され、その Linux ツールチェーンとネイティブパスを使用します

### 保存済み環境を作成する

保存済み環境とは、Claude が実行される場所を記録した[環境セレクター](#start-a-session)内のエントリで、以降のセッションをそこで開始できます。ローカル環境や SSH 環境には、Claude が作業するフォルダーも保持されます。保存済みのローカル環境と SSH 環境は[現在のレイアウト](#check-which-layout-you-have)の一部であるため、表示されない場合は、使用しているレイアウトと現在のレイアウトを入手する方法を確認してください。

**1. New environment ダイアログを開く**

プロンプトボックスの下にある環境セレクターを開き、メニューの一番下にある **New environment** を選択します。

**2. Claude の実行場所を選択する**

**Local**、**SSH**、または [**Cloud**](#cloud-sessions) タブを選択し、そのタブのフォームに入力します。**SSH** タブでは、[接続](#ssh-sessions)とリモートマシン上のフォルダーを選択します。

**3. 環境を保存する**

**Create environment** を選択します。**Cloud** タブでは **Add environment** を選択します。

#### Desktop が自動作成する環境

環境セレクターに自分で作成していないローカル環境や SSH 環境が表示されている場合、それらは Desktop が作成したものです。[現在のレイアウト](#check-which-layout-you-have)で初めて Code タブを開くと、Desktop は最大 8 つの環境を作成します。これらの環境は、過去 1 か月間に最も多く使用したローカルフォルダーと SSH フォルダーから作成されます。これらは[編集または削除](#use-edit-or-remove-a-saved-environment)できます。

#### 保存済み環境を使用、編集、または削除する

[環境セレクター](#start-a-session)で環境のエントリを探します。

* **セッションを開始する**: エントリを選択します。
* **編集または削除する**: エントリにカーソルを合わせ、歯車アイコンをクリックします。ローカル環境または SSH 環境を削除するには、**Edit environment** で **Delete environment** をクリックします。
* **クラウド環境をアーカイブする**: [環境をアーカイブする](https://code.claude.com/docs/ja/cloud-environments.md#archive-an-environment)を参照してください。

### ローカルセッションの環境変数

ローカルセッションに環境変数を設定するには、[保存済みのローカル環境に追加](#set-environment-variables-for-local-sessions)してから、その環境で新しいセッションを開始します。

`PATH` や `CLAUDE_CONFIG_DIR` などの変数には、それぞれ専用の手順があります。

| 変数 | 代わりに行うこと |
| :- | :- |
| `PATH`（`npm` などのプログラムをシステムが検索するフォルダー） | [セッションがインストール済みのツールを見つけられない](#session-not-finding-installed-tools)を参照してください。Windows では Desktop は PowerShell プロファイルを読み込まないため、ユーザーまたはシステムの環境変数で `PATH` を設定してから、Desktop を終了して再度開きます。 |
| [`claude_desktop_config.json`](#mcp-servers-from-the-claude-desktop-chat-app) の MCP サーバー用の変数 | Desktop を終了し、そのサーバーの `env` ブロックで設定してから、Desktop を再度開きます |
| [`CLAUDE_CONFIG_DIR`](https://code.claude.com/docs/ja/env-vars#variables) または [`CLAUDE_CODE_TMPDIR`](https://code.claude.com/docs/ja/env-vars#variables) | [開発サーバー用の変数を設定する場所のいずれか](#set-environment-variables-for-dev-servers)で設定してから、Desktop を終了して再度開きます |
| `API_TIMEOUT_MS`、`ANTHROPIC_BASE_URL`、または Desktop 自身が設定するその他の変数 | [Desktop 自身が設定する環境変数](#environment-variables-desktop-sets-itself)を参照してください |

macOS または Linux で、`export` で設定した変数が Claude の実行するコマンドで欠落している、または誤っている場合は、[Claude が実行するコマンドでエクスポートした変数が欠落している、または誤っている](#exported-variable-missing-or-wrong-in-commands-claude-runs)を参照してください。

#### ローカルセッションの環境変数を設定する

保存済みのローカル環境に変数を追加し、その環境からセッションを開始します。Desktop は `API_TIMEOUT_MS` などの[一部の変数を自身で設定する](#environment-variables-desktop-sets-itself)ため、それらの変数についてはユーザーの値ではなく Desktop の値がセッションに渡されます。

> [!NOTE]
>
> 新しいセッションでプロンプトボックスの下に環境が表示されない場合は、保存済みのローカル環境がない[以前のレイアウト](#check-which-layout-you-have)を使用しています。代わりに[ローカル環境エディター](#use-the-local-environment-editor)を使用してください。

**1. ローカル環境のフォームを開く**

* **保存済みのローカル環境を作成するには**: 環境セレクターのメニューの一番下にある [**New environment**](#create-a-saved-environment) を選択し、**Local** タブを選択します
* **既存の環境を変更するには**: 環境セレクターで **Local** の下にある保存済み環境にカーソルを合わせ、歯車アイコンをクリックして [**Edit environment**](#use-edit-or-remove-a-saved-environment) を開きます

**2. 変数を入力する**

**Environment variables** を選択し、1 行に 1 つずつ `KEY=value` を入力して、**Done** を選択します。

**3. 環境を保存する**

**Create environment** または **Save** を選択します。

その環境から開始したセッションにのみ変数が渡されます。

すべてのローカルセッションに変数を設定するには、`~/.claude/settings.json` ファイルの [`env` キー](https://code.claude.com/docs/ja/env-vars#set-variables-in-settings-files)に追加します。Desktop がセッションを開始する環境にその変数がすでに存在する場合、Claude Code は[その値を無視します](https://code.claude.com/docs/ja/settings-reference.md#how-env-values-interact-with-your-shell)。サポートされている変数の一覧については、[環境変数](https://code.claude.com/docs/ja/env-vars.md)を参照してください。

#### 開発サーバーの環境変数を設定する

シークレットを [`launch.json`](#configure-preview-servers) にコミットせずに開発サーバーに渡すには、次のいずれかの場所で設定してから Desktop を再起動します。

* **macOS と Linux**: シェルプロファイルでエクスポートします
* **Windows**: ユーザー環境変数またはシステム環境変数に追加します
* **任意のプラットフォーム**: [ローカル環境エディター](#use-the-local-environment-editor)を開ける場合は、そこに保存します

[保存済み環境](#create-a-saved-environment)や `~/.claude/settings.json` に追加した変数は、開発サーバーには渡されません。

#### ローカル環境エディターを使用する

ローカル環境エディターを開くには、保存済み環境のエントリではなく、自分のコンピューターのエントリにある歯車アイコンをクリックします。

* **プロンプトボックスの下にあるセレクター**: **Local** の下の最初にある、自分のコンピューターのエントリにカーソルを合わせます。歯車アイコンが表示されたらクリックします。表示されない場合、エディターは利用できないため、[ローカルセッション](#set-environment-variables-for-local-sessions)または[開発サーバー](#set-environment-variables-for-dev-servers)の変数を別の方法で設定してください。
* **プロンプトボックスの上にあるセレクター**: **Local** にカーソルを合わせ、歯車アイコンをクリックします

1 行に 1 つずつ `KEY=value` を入力し、**Save changes** を選択します。ここで保存した変数は、マシン上に暗号化されて保存されます。ローカルセッションにはこれらの変数が渡されますが、`API_TIMEOUT_MS` など [Desktop が自身で設定する](#environment-variables-desktop-sets-itself)変数は除きます。開発サーバーに変数を渡すには、Desktop を再起動します。

#### Claude が実行するコマンドでエクスポートした変数が見つからない、または値が正しくない

macOS または Linux で Claude が実行するコマンドに、`~/.zshrc` または `~/.bashrc` で `export` を使って設定した変数が渡されない場合や、誤った値が渡される場合は、次の手順を順番に試してください。

**1. 新しいセッションを開始する**

Claude にコマンドを再度実行するよう依頼します。

**2. Desktop を終了して再度開く**

その後、新しいセッションを開始します。

**3. 保存済みの変数を確認する**

コマンドに誤った値が渡される場合は、その変数を[保存済み環境](#use-edit-or-remove-a-saved-environment)または[ローカル環境エディター](#use-the-local-environment-editor)でも設定していないか確認します。設定している場合は、そこで値を変更し、新しいセッションを開始します。

**4. 保存済み環境を使用する**

変数を[保存済みのローカル環境](#set-environment-variables-for-local-sessions)に追加してから、その環境から新しいセッションを開始します。`PATH`、`CLAUDE_CONFIG_DIR`、`API_TIMEOUT_MS` などの変数については、代わりに[専用の手順](#environment-variables-in-local-sessions)に従ってください。

v2.1.304 より前の Claude Code はエクスポートされた変数をコマンドに渡さないため、[セッションで実行されているバージョンを確認](#claude-code-version-in-the-code-tab)してください。

#### Desktop が自身で設定する環境変数

`API_TIMEOUT_MS` や `ANTHROPIC_BASE_URL` を設定してもローカルセッションで何も変わらなかった場合、それは Desktop がこれらの[変数](https://code.claude.com/docs/ja/env-vars.md#variables)などを自身で設定しているためです。シェルプロファイル、Windows のユーザー変数またはシステム変数、ローカル環境エディター、保存済み環境のいずれで値を設定しても、ローカルセッションには Desktop の値が渡されます。値を設定ファイルに移しても効果はありません。ローカルセッションでは Claude Code が[その値を無視する](https://code.claude.com/docs/ja/settings-reference.md#how-env-values-interact-with-your-shell)ためです。

* `API_TIMEOUT_MS`: ローカルセッションには `900000`（15 分）が渡されます。より長いタイムアウトが必要な場合は、[Claude Code CLI をインストール](https://code.claude.com/docs/ja/quickstart.md)し、Desktop の代わりに使用してください。[シェルで変数を設定](https://code.claude.com/docs/ja/env-vars.md#set-variables-in-your-shell)し、ターミナルで `claude` を実行します。
* `ANTHROPIC_BASE_URL`: Claude アカウントでサインインしている場合、ローカルセッションには Anthropic の API ホストが渡されます。ゲートウェイを使用するには、代わりに Desktop の[サードパーティ推論設定](https://code.claude.com/docs/ja/llm-gateway-connect.md#desktop-app)をセットアップしてください。

#### 拡張思考をオフにする

[拡張思考](https://code.claude.com/docs/ja/model-config.md#extended-thinking)はデフォルトで有効になっており、複雑な推論タスクのパフォーマンスが向上しますが、追加のトークンを消費します。オフにするには、[保存済みのローカル環境](#set-environment-variables-for-local-sessions)または[ローカル環境エディター](#use-the-local-environment-editor)で `MAX_THINKING_TOKENS` を `0` に設定します。これにより Anthropic API で思考がオフになります。ただし、Opus 5.5、Sonnet 5.5、Haiku 5.5、および Fable モデルは常に拡張思考を使用します。

Opus 5 では、セッションを開始する前に effort を `high` 以下に選択してください。[現在のレイアウト](#check-which-layout-you-have)では、モデルピッカーを開き、**Effort** の下でレベルを選択します。より高いレベルでセッションを開始した場合は、`high` 以下で新しいセッションを開始してください。

#### 固定の思考予算

[適応的推論](https://code.claude.com/docs/ja/model-config.md#adjust-effort-level)を持つモデルでは、適応的推論が代わりに思考の深さを制御するため、`MAX_THINKING_TOKENS` に正の値を設定しても、Claude Code はその数値自体を無視します。Opus 4.6 と Sonnet 4.6 では、固定思考予算を使用するために `CLAUDE_CODE_DISABLE_ADAPTIVE_THINKING` を `1` に設定します。Fable モデル、Sonnet 5 以降、Haiku 5.5、および Opus 4.7 以降は常に適応的推論を使用し、固定予算モードはありません。

### 管理対象デバイスでのローカルセッション

環境セレクターで自分のコンピューターのエントリがグレー表示され、**Disabled by your organization** というツールチップが表示されている場合、管理者が[ローカルセッションをオフにしています](#managed-settings)。Windows では、[WSL](https://code.claude.com/docs/ja/desktop-wsl.md) のエントリも同じようにグレー表示されます。管理対象デバイスでの WSL の利用可否は[別途管理されます](https://code.claude.com/docs/ja/admin-setup.md#wsl-sessions-in-claude-code-desktop)。

SSH 接続が構成されている場合、新しいセッションはデフォルトで最初の SSH 接続を使用します。既存のローカルセッションを続行しようとすると、Desktop はこのデバイスではローカルセッションを利用できないというメッセージを表示します。[保存済みのローカル環境](#create-a-saved-environment)を選択すると、`Couldn’t switch environments: the Local environment isn’t available anymore.` というエラーが表示されます。代わりに [SSH](#ssh-sessions) 環境または[クラウド](#cloud-sessions)環境を選択するか、IT チームに問い合わせてください。

### クラウドセッション

クラウドセッションはアプリを閉じても、バックグラウンドで続行されます。使用状況は[サブスクリプションプランの制限](https://code.claude.com/docs/ja/costs.md)にカウントされ、別の計算料金はありません。

クラウド環境を追加、編集、または[アーカイブ](https://code.claude.com/docs/ja/cloud-environments.md#archive-an-environment)するには、[環境セレクター](#start-a-session)を開きます。

* **環境を追加する**: セレクターのメニューの一番下にある **New environment** を選択し、[**New environment** ダイアログ](#create-a-saved-environment)の **Cloud** タブを選択します
* **自分の環境の 1 つを編集またはアーカイブする**：それにマウスを合わせて、ギアアイコンをクリックします

ネットワークアクセスと環境変数の設定の詳細については、[クラウド環境を設定する](https://code.claude.com/docs/ja/cloud-environments.md)を参照してください。

### SSH セッション

SSH セッションを使用すると、デスクトップアプリをインターフェイスとして使用しながら、リモートマシンで Claude Code を実行できます。これは、クラウド VM、dev コンテナ、または特定のハードウェアまたは依存関係を持つサーバーに存在するコードベースで作業するのに便利です。

> [!NOTE]
>
> [サードパーティプロバイダー](https://code.claude.com/docs/ja/third-party-integrations.md)で Desktop を使用する場合、SSH セッションには個別のセットアップが必要です。[SSH remote sessions in Claude Desktop on 3P](https://claude.com/docs/third-party/claude-desktop/ssh-remote-sessions) を参照してください。

[**New environment** ダイアログ](#create-a-saved-environment)で SSH 接続を追加してから、その接続でセッションを開始します。新しいセッションでプロンプトボックスの下に環境が表示されない場合は、以前のレイアウトを使用しています。[使用しているレイアウトを確認する](#check-which-layout-you-have)を参照してください。

**1. New environment ダイアログを開く**

セッションを開始する前に、プロンプトボックスの下にある環境セレクターを開き、メニューの一番下にある **New environment** を選択します。

**2. 接続を追加する**

**New environment** ダイアログの **SSH** タブで **Host** リストを開き、**Add SSH connection…** を選択して、接続の詳細を入力します。

* **Name**: この接続のわかりやすいラベル。
* **SSH host**: `user@hostname`、または `~/.ssh/config` で定義されたホスト。
* **SSH port**: 空欄の場合はデフォルトで 22 になるか、SSH 設定のポートが使用されます。
* **SSH key (optional)**: `~/.ssh/id_ed25519` などの秘密鍵へのパス。SSH 設定または SSH エージェントを使用する場合は空欄のままにします。
* **Worktree folder**: 新しいセッションが worktree を作成する、`~/worktrees` などのリモートマシン上のフォルダー。[リモートマシンのデフォルト](#choose-where-ssh-session-worktrees-go)を使用する場合は空欄のままにします。

その後、**Add SSH connection** を選択します。

**3. 接続でセッションを開始する**

リモートマシン上のフォルダーを選択し、**Create environment** をクリックします。マシンとフォルダーは、以降のセッション用の[保存済み環境](#create-a-saved-environment)としてまとめて保持されます。Desktop は新しいセッションにその環境を選択するので、タスクを入力して **Enter** を押します。

リモートマシンでは Linux、macOS、または [Windows](#windows-remote-machines) を実行できます。Desktop は初回接続時にリモートマシンに Claude Code を自動的にインストールします。接続されると、SSH セッションは権限モード、コネクタ、プラグイン、および MCP サーバーをサポートします。

#### SSH セッションのリモートマシン要件

Linux または macOS のリモートマシンには、サポートされているプロセッサ、SFTP を備えた SSH サーバー、`noexec` でマウントされていないインストールフォルダ、動作するシェル、およびネットワークアクセスが必要です。接続する前に、またはログイン後に接続が失敗した場合に、各要件を確認してください：

* **システム**：x86\_64 または arm64 プロセッサ。マシンは Claude Code の[システム要件](https://code.claude.com/docs/ja/setup.md#system-requirements)も満たす必要があります。Linux では、Claude Code には glibc 2.17 以降、または musl が必要です。マシンがどちらを使用しているかを確認するには、そのマシンで `ldd --version` を実行します。Alpine Linux などの musl ベースのディストリビューションでは、[Claude Code が必要とするパッケージ](https://code.claude.com/docs/ja/setup.md#alpine-linux-and-musl-based-distributions)もインストールしてください。
* **SFTP**：SSH サーバーが SFTP サブシステムを提供している必要があります。これは `sshd_config` の `Subsystem sftp` 行で有効になります。確認するには、コンピューターのターミナルで `sftp` を使用して同じホストとポートに接続します。正常に動作しているサーバーでは `sftp>` プロンプトが表示されます。
* **サーバーでの `MaxSessions 1`**: `sshd_config` で `MaxSessions 1` が設定されているサーバーに接続するには、次のいずれかを行います。
  * **コンピューターが macOS または Linux の場合**: Claude Desktop v3.1623.0 以降に更新します
  * **コンピューターが Windows の場合**: Desktop の組み込み SSH クライアントはそのサーバーに接続できないため、Desktop が [OpenSSH クライアント経由で接続する](#use-your-ssh-configuration)ようにします
  * **サーバーを変更できる場合**: `MaxSessions` を、たとえば OpenSSH のデフォルトである 10 に引き上げます
* **`MaxSessions 1` でのログイン**: SSH エージェントが保持する鍵など、プロンプトなしで機能するログインを使用してください。Desktop は接続または再接続のたびに少なくとも 2 回ログインします。さらに、[ターミナル](#run-commands-in-the-terminal)タブごと、および `!` で始まるコマンドを実行する Desktop セッションごとに、少なくとも 1 回のログインが追加で発生します。Claude が実行するコマンドではログインは発生しません。
* **`MaxSessions 1` でのワンタイムコード**: ワンタイムコードのようにログインのたびにプロンプトが表示される場合、`!` コマンドは失敗します。代わりに、それらのコマンドはターミナルタブで実行してください。ターミナルタブでは、独自のペインでプロンプトが表示されます。
* **インストールフォルダ**：Desktop は、ホームディレクトリの `~/.claude/remote/` の下にヘルパープログラムと Claude Code をインストールします。そこからそれらを実行するため、そのフォルダを `noexec` でマウントされたファイルシステム上に置くことはできません。接続する各ユーザーのホームディレクトリに約 1 GB のディスク容量を確保してください。そのフォルダに含まれる内容については、[リモートマシン上のファイルとプロセス](#files-and-processes-on-the-remote-machine)を参照してください。
* **シェル**：リモートマシン上のアカウントに設定されているシェルは、Bash、Zsh、`sh` と同様に、SSH 経由で送信されたコマンドを実行できる必要があります
* **ネットワーク**：Claude Code はリモートマシンで実行され、そこからネットワークリクエストを行うため、マシンには [Claude Code が必要とするネットワークアクセス](https://code.claude.com/docs/ja/network-config.md#network-access-requirements)が必要です。マシンが Claude Code をダウンロードできない場合、Desktop はコンピューター上でダウンロードしてアップロードします。Claude Code のその他のリクエストは引き続きリモートマシンから送信されます。Linux のリモートマシンで、それらのリクエストにプロキシが必要な場合は、[SSH セッション用に設定してください](#set-a-proxy-or-a-ca-certificate-for-ssh-sessions)。

#### リモートマシンのホスト鍵を確認する

ホスト鍵とは、リモートマシンが自分がどのマシンであるかを証明するために提示する鍵で、フィンガープリントはその鍵を短くした形です。鍵を信頼すると、コンピューターはその鍵を保存し、以降はその鍵を提示する相手に確認なしで接続します。何かが接続を傍受している可能性があるため、信頼する前に鍵を確認してください。

まず、フィンガープリントが表示された場所から、その鍵がどのマシンのものかを特定します。

* **Desktop が `Connect to <host> for the first time?` と尋ねた場合、または Review new key を選択した場合**: Desktop が示すマシン `<host>`
* **Desktop が `Connect through <jump host> for the first time?` と尋ねた場合**: 踏み台ホスト。これは接続が経由するマシンで、接続先のマシンではありません
* **ターミナルで `ssh` が尋ねるか警告した場合**: メッセージに示されたマシン。入力したマシンとは異なる場合があります

そのマシン自体のフィンガープリントを、確認対象の接続経由ではなく、マシン自体から取得します。

* **他の人がマシンを管理している場合**: ホスト鍵のフィンガープリントを問い合わせます
* **自分が管理していて、Linux または macOS を実行している場合**: マシンのコンソールで、またはすでに信頼している接続経由で、`ssh-keygen -lf /etc/ssh/ssh_host_<type>_key.pub` を実行します。`<type>` には、Desktop または `ssh` がフィンガープリントの横に表示する鍵の種類を小文字で指定します。たとえば `ED25519` や `ssh-ed25519` なら `ed25519` です。

次に、マシン自体のフィンガープリントと表示されたフィンガープリントを比較します。

* **一致する場合**: 鍵を信頼します。Desktop では **Trust and connect** または **Trust new key** を選択し、ターミナルでは `yes` と答えます。
* **一致しない、または確認できない場合**: 接続しないでください。Desktop では **Cancel** を選択し、ターミナルでは `no` と答えます。他の人がマシンを管理している場合は、表示されたフィンガープリントを伝えてください。

トラブルシューティングの手順からここに来た場合は、どちらの結果でもその手順に戻ってください。

#### SSH セッションのプロキシまたは CA 証明書を設定する

Linux のリモートマシンがプロキシ経由でインターネットに接続する場合、または CA 証明書が必要な場合は、そのマシン上の `~/.claude/settings.json` の `env` に[プロキシと CA の変数](https://code.claude.com/docs/ja/network-config.md)を追加してください。そのマシンの `~/.profile`、`~/.bash_profile`、`~/.zprofile`、または `~/.zshrc` ですでにエクスポートしている場合でも追加してください。

SSH セッションでは、そのマシンのターミナルで実行した `claude` にはそれらのファイルの変数が渡される場合でも、Claude Code には渡されません。その結果、セッションがハングしたり、**The connection from … to the API failed** や **Authentication failed** が表示されたりすることがあり、再度サインインしても解決しません。

**1. 変数を追加する**

CA ファイルには [`NODE_EXTRA_CA_CERTS`](https://code.claude.com/docs/ja/network-config#custom-ca-certificates) を使用してください。Claude Code は `~/.claude/settings.json` の `SSL_CERT_FILE` に指定された CA を信頼しないためです。次の例では、プロキシと CA ファイルを設定します：

```json ~/.claude/settings.json theme={null}
{
  "env": {
    "HTTPS_PROXY": "http://proxy.example.com:8080",
    "NODE_EXTRA_CA_CERTS": "/etc/ssl/certs/example-ca.pem"
  }
}
```

**2. メッセージを再送信する**

そのファイルで追加または変更した変数は数秒以内に有効になるため、メッセージを再送信してください。それでも失敗する場合は、新しいセッションを開始してください。

##### リモートマシンの別の場所で設定されたプロキシまたは CA の変数を見つける

Linux のリモートマシンがプロキシまたは CA の変数を別の場所で設定していないか確認してください。セッションはその値を使用し、[どの設定ファイルの値も無視する](https://code.claude.com/docs/ja/settings-reference.md#how-env-values-interact-with-your-shell)ためです：

**1. リモートマシンが設定する変数を一覧表示する**

コンピューターのターミナルで、自分のホストを指定して `ssh devbox env` を実行します。

**2. 変数が設定されている場所で変更する**

一覧にその変数がある場合は、リモートマシン上の `~/.zshenv`、`/etc/environment`、`~/.bashrc` など、その変数を設定しているファイルで変更します。

**3. セッションに新しい値を渡す**

リモートマシンを再起動するか、[ヘルパーを削除する](#files-and-processes-on-the-remote-machine)手順の最初の 2 つのステップと同様に、Desktop を終了してヘルパーのプロセスを終了します。どちらの方法でも Claude の作業が中断されるため、タスクが実行されていないときに行ってください。

#### SSH 設定を使用する

Desktop が自分のコンピューター上の OpenSSH クライアント経由で接続する場合、macOS、Linux、Windows で SSH 設定を使用できます。

* **macOS と Linux**: Desktop は自分のコンピューター上で OpenSSH クライアントを実行して接続するため、`~/.ssh/config` を使用します。OpenSSH クライアント経由で接続するには、Claude Desktop v1.37937.0 以降が必要です。
* **Windows**: Desktop が OpenSSH クライアント経由で接続する場合、`%USERPROFILE%\.ssh\config` を使用します。サードパーティプロバイダーではなく Claude アカウントを使用している場合、OpenSSH クライアント経由で接続するには、次のすべてが必要です。

  * Claude Desktop v2.2553.0 以降。バージョンを確認するには、[バージョンを確認する](#check-your-version)を参照してください。
  * Microsoft の OpenSSH 9.4 以降
  * このページ上部のダウンロードボタンでインストールした Desktop。Microsoft Store 版の Desktop は OpenSSH クライアント経由で接続しないためです

  これらの要件を満たせない場合、またはサードパーティプロバイダーを使用している場合は、[OpenSSH クライアントを使用せずに Windows で接続する](#connect-on-windows-without-the-openssh-client)を参照してください。

OpenSSH クライアントを使用する場合は、**SSH host** フィールドに設定ファイルの `Host` 名を入力します。Desktop は、その `Host` エントリの `HostName`、`User`、`IdentityFile`、`CertificateFile`、`ProxyJump`、`ProxyCommand` などの設定を使用します。

接続を追加する前に、コンピューターのターミナルでクライアントとエントリを確認してください：

* **macOS と Linux でのクライアントのバージョン**: `ssh -V` を実行します。クライアントは OpenSSH 7.6 以降である必要があります。
* **Windows でのクライアントのバージョン**: Desktop は最初に `PATH` 上の `ssh` を試すため、`ssh -V` を実行します。出力に `OpenSSH_for_Windows_` と 9.4 以降が表示されれば、そのクライアントは要件を満たしています。満たしていない場合は、Desktop が次に試す 2 つのフォルダーを確認します。`C:\Windows\System32\OpenSSH` で `.\ssh.exe -V` を実行し、次に `C:\Program Files\OpenSSH` で実行します。
* **Windows で要件を満たすクライアントがない場合**: Windows で **OpenSSH Client** オプション機能を追加して保留中の Windows 更新プログラムをインストールするか、[Microsoft の新しいビルド](https://learn.microsoft.com/en-us/troubleshoot/windows-server/system-management-components/upgrade-in-box-openssh-to-latest-openssh-release)をインストールします。その後、Desktop を終了して再度開きます。Desktop が使用可能な OpenSSH クライアントを見つけたかどうかを確認するには、[`ssh.log`](#get-desktops-logs-for-an-ssh-problem) で `Windows OpenSSH client:` とバージョン、または `no usable Windows OpenSSH client` を探します。
* **エントリ**: Windows では、バージョンチェックで要件を満たしたクライアントを使用します。`ssh devbox` のように、`Host` 名を指定して `ssh` を実行します。失敗する場合は、先にエントリを修正してください。

**SSH port** と **SSH key (optional)** フィールドは空のままにできます。いずれかを入力した場合、Desktop はそれをエントリと組み合わせて使用します：

* **SSH port**：ここに入力した値は、エントリの `Port` を上書きします
* **SSH key (optional)**: OpenSSH クライアントでは、Desktop はエントリの `IdentityFile` と SSH エージェント内の鍵に加えて、ここで選択した鍵ファイルを提示します。Windows では、`ssh` は PuTTY の `.ppk` ファイルを読み込まないため、OpenSSH 形式の鍵を選択してください。

##### OpenSSH クライアントを使用せずに Windows で接続する

Windows では、コンピューターが [OpenSSH クライアントの要件](#use-your-ssh-configuration)を満たしていない場合、Desktop の組み込み SSH クライアント経由で接続します。サードパーティプロバイダーでは、デフォルトで組み込みクライアント経由で接続しますが、管理者がこれを変更できます。この設定については、[SSH remote sessions in Claude Desktop on 3P](https://claude.com/docs/third-party/claude-desktop/ssh-remote-sessions) を参照してください。

組み込みクライアントでも、`PATH` に `ssh` コマンドがあれば、**SSH host** フィールドに SSH 設定の `Host` 名を入力できます。ただし、次の制限があります。

* **エントリからの設定**: Desktop は `HostName`、`User`、`Port`、`IdentityFile` を使用します。`PATH` に `sh` シェルがある場合は `ProxyCommand` も使用します。
* **SSH key (optional)**: ここで選択した鍵ファイルは `IdentityFile` を置き換えるため、エントリの `IdentityFile` を使い続けるにはこのフィールドを空欄のままにします
* **`CertificateFile` と `ProxyJump`**: Desktop は `CertificateFile` を無視し、エントリで `ProxyJump` が設定されていると接続は失敗します。いずれかの設定を使用するには、[OpenSSH クライアント経由で接続してください](#use-your-ssh-configuration)。

##### ジャンプホストの背後にあるマシンに接続する

ジャンプホスト（踏み台、バスティオンとも呼ばれます）の背後にあるマシンに接続するには、エントリで `ProxyJump` または `ProxyCommand` を設定します。次のエントリは、`bastion.example.com` を経由して `devbox.internal.example.com` に接続します：

```text ~/.ssh/config theme={null}
Host devbox
  HostName devbox.internal.example.com
  User alice
  ProxyJump bastion.example.com
```

**SSH host** フィールドに `devbox` と入力します。

管理者が [SSH ホストを制限している](#allow-jump-hosts)場合は、ジャンプホストもリストに含まれている必要があります。コンピューターのターミナルで `ssh -G bastion.example.com` を実行し、出力される `hostname` を許可するよう管理者に依頼してください。

##### リモートマシン上のコンテナに接続する

SSH ポートを公開していないコンテナ内でセッションを実行するには、`ProxyCommand` を使用してコンテナに接続してください。Desktop は接続先エントリの `RemoteCommand` を実行しないためです。エントリで `RemoteCommand` を使用してコンテナに入っている場合、セッションはコンテナ内ではなく、エントリがログインするマシン上で実行されます。

**1. エントリを追加する**

`~/.ssh/config` の末尾、または最初の `Host *` エントリがある場合はその直前に、次のエントリを追加します。Docker コンテナ `devbox`、そのユーザー `dev`、マシン `build.example.com` を自分のものに置き換えてください。エントリのコマンドは、接続ごとにコンテナ内で SSH サーバーを起動します。

```text ~/.ssh/config theme={null}
Host devbox-container
  User dev
  ProxyCommand ssh build.example.com docker exec -i devbox /usr/sbin/sshd -i
```

**2. コンテナを準備する**

* OpenSSH サーバーをインストールし、イメージを再ビルドしたりコンテナを再作成したりしても変わらないホスト鍵を用意します
* `User` で指定したアカウントに、`authorized_keys` ファイルなどのログイン手段を用意します
* コンテナが[リモートマシンの要件](#remote-machine-requirements-for-ssh-sessions)を満たしていることを確認します

**3. 許可リストを確認する**

管理者が [SSH ホストを制限している](#restrict-which-ssh-hosts-users-can-connect-to)場合は、コンピューターのターミナルで `ssh -G devbox-container` を実行します。出力される `hostname`（ここでは `devbox-container`）を `sshHostAllowlist` で許可するよう管理者に依頼してください。管理者がその名前を許可すると、エントリの `ProxyCommand` が接続する先はどこであっても許可されることになります。

**4. エントリをテストしてから接続する**

コンピューターのターミナルで `ssh devbox-container` を実行します。報告された問題を修正し、何も尋ねられずにコンテナ内でシェルが開くまで繰り返し実行します：

* **`ssh` がパスワード、パスフレーズ、またはコードを求める場合**：SSH エージェントが保持する鍵など、プロンプトなしで機能するログインに切り替えます
* **`ssh` が `Cannot execute command-line and remote command.` または `Bad packet length` を報告する場合**：`build.example.com` のエントリから `RemoteCommand` と `RequestTTY` を削除します。その後は、コンピューターのターミナルで `ssh build.example.com` を実行すると、コンテナ内ではなくそのマシン上でシェルが開きます。
* **`ssh` が `Connection closed by UNKNOWN port 65535` を報告する場合**：同じターミナルで `ssh build.example.com docker exec devbox /usr/sbin/sshd -t` を実行します。
  * `Missing privilege separation directory: /run/sshd` と出力された場合は、コンテナ内にそのフォルダを作成します。
  * `no hostkeys available` と出力され、コンテナにホスト鍵がある場合は、このコマンドとエントリの両方で `exec` の後に `-u root` を追加します。

その後、**SSH host** フィールドに `devbox-container` と入力します。

##### `ProxyCommand` でシェルの変数を使用する

macOS と Linux で、`ProxyCommand` または `Match exec` コマンドで独自の環境変数を使用するには、`~/.zshrc` などのシェル起動ファイルでエクスポートします。その後、Desktop を終了して再度開きます。Desktop は起動時にログインシェルがエクスポートする内容を読み込み、終了するまでその値を保持します。

これには Claude Desktop v2.37337.0 以降と、`-0` を受け付ける `env` コマンドが必要です。これはコンピューターのターミナルで `env -0` を実行して確認できます。

> [!NOTE]
>
> シェルが一時的な AWS 認証情報を設定する場合は、`AWS_*` 変数をエクスポートする代わりに、[AWS CLI にプロファイルを指定してください](#use-aws-credentials-in-a-proxycommand)。

##### macOS と Linux で `ProxyCommand` に AWS 認証情報を使用する

シェル起動ファイルで一時的な AWS 認証情報を設定している場合、AWS CLI を実行する `ProxyCommand` は、ターミナルでは接続できても Desktop では失敗することがあります。シェルが `AWS_SESSION_TOKEN`、`AWS_SECURITY_TOKEN`、または `AWS_CREDENTIAL_EXPIRATION` をエクスポートしていると、Desktop の `ssh` と `ProxyCommand` は、シェルの AWS 認証情報、`AWS_REGION`、`AWS_PROFILE` を取得しません。

AWS CLI にリージョンや認証情報の他の取得元がない場合、`You must specify a region` または `Unable to locate credentials` で失敗します。Desktop から接続するには、AWS CLI が `~/.aws/config` から読み取るプロファイルを指定します：

**1. リージョンと認証情報の取得元を持つプロファイルを追加する**

次の例では、ヘルパープログラムから認証情報を取得する `corp` という名前のプロファイルを追加します：

```ini ~/.aws/config theme={null}
[profile corp]
region = us-east-1
credential_process = /full/path/to/your-credential-helper
```

* **`region`**：接続先マシンの AWS リージョンを指定します
* **`credential_process`**：[AWS がドキュメントで定めている JSON 形式](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-sourcing-external.html)で認証情報を出力するプログラムのフルパスを指定します。AWS CLI は、不在中の再接続を含め、接続のたびにこのプログラムを実行するため、ユーザーの入力を必要としないプログラムを選んでください。
* **IAM Identity Center**：`credential_process` の代わりに、プロファイルの [IAM Identity Center 設定](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-sso.html)を追加します。接続する前と、そのサインインの期限が切れたときに、ターミナルで `aws sso login --profile corp` を実行します。

**2. ProxyCommand でプロファイルを指定する**

次の例では、[AWS が Session Manager 用にドキュメントで示しているコマンド](https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-getting-started-enable-ssh-connections.html)に `--profile` を追加します：

```text ~/.ssh/config theme={null}
Host i-*
  ProxyCommand sh -c "aws ssm start-session --profile corp --target %h --document-name AWS-StartSSHSession --parameters 'portNumber=%p'"
```

**3. 再度接続する**

ターミナルでホストを指定して `ssh` を実行し、エントリがそこで引き続き接続できることを確認してから、Desktop から接続します。

##### SSH 接続のタイムアウトを延長する

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

##### Desktop だけが適用する `Match host` ブロックを修正する

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

##### Desktop がオフにする転送設定

リモートマシンへの接続では、SSH 設定でオンになっている場合でも、Desktop は `ForwardAgent`、`ForwardX11`、`LocalForward`、`RemoteForward`、`DynamicForward`、`Tunnel` をオフのままにします。[ターミナル](#run-commands-in-the-terminal)や `!` コマンドでは、Desktop がそれらの設定に従う別の `ssh` を起動することがあるため、転送設定は[一部の場合にのみ](#limits-while-desktop-is-disconnected)適用されると考えてください。

* **リモートマシン上のポートに接続するには**：[自分で転送します](#reach-a-port-on-the-remote-machine)
* **リモートマシンから自分の鍵を使用するには**：`git push` 用など、リモートマシン自体に認証情報を設定します

Desktop が SSH エージェントやポートを転送しないようにするには、コンピューターのターミナルで `ssh -G devbox` を実行します。次に、出力された `hostname` と `user` の値を使用して、`ssh -G -o HostName=devbox.internal.example.com -l alice devbox` のように、Desktop が実行しうる形でもう一度実行します。2 回目の出力には、1 回目ではスキップされる `Match` ブロックの設定が表示されることがあります。

両方の出力で、`no` 以外の値を示す `forwardagent` 行と、`localforward`、`remoteforward`、または `dynamicforward` で始まる行を探します。見つかった場合は、その設定を SSH 設定から削除してください。`ProxyCommand` が `ssh` で接続するホストについても同様に行ってください。

#### リモートマシン上のポートに接続する

ポート 3000 の dev サーバーなど、リモートマシンで実行されているサーバーを開くには、ポートを自分で転送します。コンピューターのターミナルで、`-L` と接続先のホスト（`devbox` など）を指定して `ssh` を実行します：

```bash theme={null}
ssh -N -L 3000:localhost:3000 devbox
```

接続で **SSH port** または **SSH key (optional)** を入力した場合は、同じ値で `-p` または `-i` を追加します。そのコマンドを実行したままにし、コンピューターのブラウザで `http://localhost:3000` を開くと、リモートマシンのポート 3000 に接続できます。`ssh` が `open failed: administratively prohibited` と出力した場合は、マシンの管理者に TCP 転送を許可するよう依頼してください。TCP 転送は SSH サーバーの `sshd_config` の `AllowTcpForwarding` で制御されます。

#### Windows リモートマシン

Windows リモートマシンには Claude Desktop v2.31226.0 以降が必要です。

Microsoft の OpenSSH Server を使用してください。マシンは x64 と ARM64 のどちらでもかまいません。SSH サーバーが起動するシェルには、`cmd.exe`、Windows PowerShell 5.1、または Git Bash を使用できます。

Windows リモートマシンは、Linux リモートマシンに比べてテストが少なくなっています。依存する前に、そこで自分の作業を試してください。

Windows リモートマシンでは、特に次のような制限があります：

* **ターミナル**：フォルダが `C:/projects/app` のような Windows パスであるセッションでは、[ターミナル](#run-commands-in-the-terminal)は開きません
* **サンドボックス**：Claude Code はそこではネイティブ Windows 上で実行され、コマンドはサンドボックス化されずに実行されます。[サンドボックスが実行される場所](https://code.claude.com/docs/ja/sandboxing.md)を参照してください。
* **プラグイン**：Desktop は、`:` を含む名前など、Windows で保存できないファイル名またはフォルダ名を含むプラグインをコピーしません。セッションには、Desktop が除外したプラグインが一覧表示されます。
* **MCP サーバー**：一部の Windows リモートマシンでは、`claude_desktop_config.json` の MCP サーバーに対する Claude の呼び出しが Desktop を経由するため、[Desktop が切断されている間](#limits-while-desktop-is-disconnected)は Claude がそれらのツールを呼び出せません。Claude Desktop v2.37337.0 より前では、これはすべての Windows リモートマシンに当てはまります。
* **worktree**：worktree は `<project-root>/.claude/worktrees/` に作成されます。[別のフォルダを選択](#choose-where-ssh-session-worktrees-go)しても、Desktop はそれを無視します。
* **以前のメッセージ**：SSH サーバーのシェルが `cmd.exe` または Windows PowerShell の場合、セッションの以前のメッセージを表示するには、接続が必要になることがあります
* **フォーク**：SSH サーバーのシェルが `cmd.exe` または Windows PowerShell の場合、セッションをフォークできるのは最初のメッセージの時点のみです
* **切断中の実行**：タスクが [Desktop の切断中も実行を続ける](#keep-a-task-running-while-desktop-is-disconnected)のは、プログラムを起動した接続が終了した後もそのプログラムが存続することを SSH サーバーが許可している場合のみです。確認するには、[リモートマシンをテスト](#prepare-a-long-task)してください。
* **残存プロセス**：セッションの終了後も、Claude Code が起動したプログラムが実行を続けている可能性があるため、マシンを確認してください。Desktop がインストールする[バックグラウンドヘルパー](#keep-a-task-running-while-desktop-is-disconnected)は、そこでは自動的に停止しません。

#### Desktop の切断中もタスクを実行し続ける

コンピューターがスリープした場合、ネットワークが切断された場合、または Desktop を終了した場合でも、タスクは完了するか、ユーザーの対応が必要になるか、いずれかの[制限](#limits-while-desktop-is-disconnected)に達するまで続行されます。蓋を閉じることはスリープとみなされます。アップデートのためのものを含め、Desktop またはコンピューターの再起動は終了とみなされます。

Claude Code は、Desktop がリモートマシンにインストールするバックグラウンドヘルパーの下でプロセスとして実行されるため、実行を続けるのに SSH 接続は必要ありません。このセクションで説明する動作には Claude Desktop v2.31226.0 以降が必要です。

> [!WARNING]
>
> Claude アカウントで Desktop にサインインしている場合、タスクが一晩中実行されることを当てにしないでください。Desktop は、Desktop が実行中かつ接続中の間のみタスクのサインインを更新するため、切断後にタスクのサインインの期限が切れ、タスクが停止することがあります。切断時に残っている時間は状況によって異なり、数分しかない場合もあります。
>
> それまでに行われた作業はリモートマシンに残り、戻ったときにメッセージを送信して続行できます。
>
> タスクを夜通し実行する必要がある場合：
>
> * [コンピューターをスリープさせず](https://code.claude.com/docs/ja/desktop-scheduled-tasks.md#how-scheduled-tasks-run)オンラインの状態に保ち、蓋を開けたまま Desktop を実行しておきます
> * リモートマシンと経由するすべてのジャンプホストに対して、SSH エージェントが保持する鍵など、プロンプトなしで機能するログインを使用します。これにより、接続が切れた後に Desktop が自動的に再接続できます。
>
> コンピューターがスリープ中または電源オフの間も実行する必要があるタスクの場合は、代わりに[クラウドセッション](#run-long-running-tasks-in-the-cloud)を開始してください。

* **スリープまたはネットワーク切断の後**：プロセスが[まだ実行されて](#limits-while-desktop-is-disconnected)おり、Desktop がプロンプトなしでログインできる場合、実行中のタスクに戻れます。ログインできない場合は、[メッセージを送信](#reconnect-after-sleep-or-a-network-loss)してください。
* **終了の後**: タスクは実行を続けますが、Desktop がそのプロセスに再参加できない限り、セッションを再度開いたときにタスクは失われます。終了する前に [Desktop が再参加できる場合](#reopen-a-session-after-you-quit-desktop)を確認してください。タスクが失われた場合は、メッセージを送信して続行します。

戻ったときにタスクが完了していない場合は、Desktop が再接続できないという知らせ、認証エラー、または待機中のリクエストがないか確認してください：

* **Desktop が再接続できない**：セッションにその理由が表示され、通知でも知らされることがあります。Desktop は[ログインを必要とする](#reconnect-after-sleep-or-a-network-loss)場合があります。
* **認証エラー**：[サインイントークンまたは認証情報](#limits-while-desktop-is-disconnected)の期限が切れている可能性があります。Claude アカウントの場合は、メッセージを送信して続行します。サードパーティプロバイダーの場合は、[SSH remote sessions in Claude Desktop on 3P](https://claude.com/docs/third-party/claude-desktop/ssh-remote-sessions) を参照してください。
* **待機中のリクエスト**：[それに応答します](#handle-requests-that-arrive-while-you-are-away)
* **いずれにも該当しない**：メッセージを送信して続行します

##### 長いタスクを準備する

* **先に更新する**: 長時間のタスクを開始する前に Desktop を更新してください。macOS と Windows では、Desktop はダウンロード済みの更新をインストールするために自動的に再起動することがあります。この再起動は、Claude が SSH タスクで作業している間は待機します。デフォルトでは、更新が 72 時間待機した後、Desktop が[その後タスクに再接続できる](#reopen-a-session-after-you-quit-desktop)場合は、タスク中でも再起動が実行されることがあります。
* **終了する前に確認する**: 終了や再起動の後、たとえば一部の Desktop の更新後などには、実行中のタスクに必ず戻れるとは限りません。該当するケースについては、[Desktop を終了した後にセッションを再度開く](#reopen-a-session-after-you-quit-desktop)を参照してください。
* **古いバージョンでは Desktop を開いたままにする**: Windows で v3.1623.0 より前の Claude Desktop を使用している場合、Desktop が終了または再起動すると、実行中のタスクに戻れません。macOS または Linux で v2.42304.0 より前のサードパーティプロバイダーを使用している場合も同様です。どちらの場合も、タスクの実行中は Desktop を開いたままにしてください。バージョンを確認するには、[バージョンを確認する](#check-your-version)を参照してください。
* **リクエストを減らす**：[タスクがユーザーを待つ頻度を減らす](#handle-requests-that-arrive-while-you-are-away)権限モード、ルール、またはフックを選択します
* **ジャンプホストを確認する**：ジャンプホストがサインイン（スマートフォンへのプッシュ通知など）を求める場合は、プロンプトなしで機能するログインに切り替えてください。そうしないと、Desktop は再接続を試みるたびに別のプッシュ通知を送信する可能性があります。
* **リモートマシンをテストする**：短いタスクを開始し、タスクの実行中に Desktop を終了して、タスクが完了しているはずの時刻を十分に過ぎてからセッションを再度開きます。タスクが完了しておらず、セッションに認証エラーが表示されていない場合は、リモートマシンで[タスクを終了させうる要因](#limits-while-desktop-is-disconnected)を確認してください。
* **Desktop のターミナルでコマンドを実行しない**：リモートマシンが[アイドル状態のターミナルをログアウトさせる](#limits-while-desktop-is-disconnected)場合は、Desktop の外部からの SSH ログインで独自のコマンドを実行してください

##### Desktop の切断中の制限

実行したままにしたタスクは、サインインの期限が切れたとき、リモートマシンがタスクを終了させたとき、またはヘルパーが停止または置き換えられたときに終了することがあります：

* **サインイントークンまたは認証情報**：Claude アカウントの場合、トークンの期限が切れるとタスクは認証エラーで停止します。サードパーティプロバイダーの場合は、シングルサインオンや認証情報ヘルパーから取得したものなど、期限が切れる認証情報にも同じことが当てはまります。[SSH remote sessions in Claude Desktop on 3P](https://claude.com/docs/third-party/claude-desktop/ssh-remote-sessions) を参照してください。Claude アカウントの場合は、Desktop がサインインを更新できるように、[Desktop を実行して接続したままにしてください](#keep-a-task-running-while-desktop-is-disconnected)。
* **リモートマシン**：リモートマシンが再起動した場合、または SSH 接続が閉じたときにプロセスを終了させる場合、実行中のタスクは終了します。Desktop が切断されている間、タスクが再開されることはありません。systemd-logind の `KillUserProcesses` が `yes` で、それがユーザーに適用される Linux マシンでは、この方法でプロセスが終了されます。そこでタスクを実行し続けるには、`KillExcludeUsers` などでユーザーを除外するよう管理者に依頼してください。
* **アイドル状態のターミナル**：一部の Linux リモートマシンは、一定時間誰も入力しないターミナルをログアウトさせます（systemd-logind の `StopIdleSessionSec`）。macOS または Linux の Desktop では、セッションの[ターミナル](#run-commands-in-the-terminal)と `!` コマンドは、デフォルトで Desktop の SSH 接続を共有します。その場合、このログアウトによって Desktop の接続中に接続が終了し、実行中のタスクも一緒に終了することがあります。ターミナルペインを閉じても防げないため、[そのターミナルでコマンドを実行しないでください](#prepare-a-long-task)。
* **Desktop のアップデート**：アップデートで新しいヘルパーが導入された場合、Desktop は後の接続時にリモートマシン上のヘルパーを置き換えるため、まだ実行中のタスクが終了することがあります
* **長期間の不在**：Linux または macOS のリモートマシンで、Desktop が 30 日間接続しない場合、ヘルパーは停止し、その下で実行されているすべての Claude Code プロセスを終了します。それまでに接続してください。

ファイルの編集と一部のツールは、Desktop が切断されている間に失敗することがあります。タスクでそれらが必要な場合は、Desktop を接続したままにしてください：

* **worktree**: [worktree](#run-a-session-in-its-own-worktree) を使用するセッションでは、Claude がファイルを編集する前に Desktop が各編集を確認します。Desktop が切断されている間、各編集は約 30 秒待機した後に失敗します。シェルコマンドは引き続き実行されます。Linux または macOS のリモートマシンでは、[編集が引き続き機能する場合があります](#worktree-edits-while-disconnected)。不明な場合は、worktree なしでセッションを開始してください。
* **フォルダの制限**：組織がセッションで使用できるフォルダを制限している場合、Desktop は worktree の有無にかかわらず、各ファイルの読み取り、検索、編集をチェックします。Desktop が切断されている間、それぞれ最大 10 分間待機した後に失敗します。
* **コネクタ**：[コネクタ](#connect-external-tools)および Desktop が提供するその他のツールは Desktop を経由して実行されるため、Desktop が切断されている間は各呼び出しが約 30 秒後に失敗します
* **ワークフロー**：Desktop は新しい[ワークフロー](https://code.claude.com/docs/ja/workflows.md)をそれぞれ開始前にチェックするため、Desktop が切断されている間、新しいワークフローは最大 10 分間待機した後に失敗します
* **MCP サーバー**：Claude Code がリモートマシンで起動する MCP サーバーは Desktop を経由しないため、Claude は引き続きそれらのツールを呼び出せます。`claude_desktop_config.json` のサーバーがこれに含まれるのは、Desktop が[組み込みの SSH クライアント](#worktree-edits-while-disconnected)を使用していない場合のみです。それ以外の場合、および[一部の Windows リモートマシン](#windows-remote-machines)では、Desktop が切断されている間、Claude はそれらのツールを呼び出せません。

> [accordion] worktree 内の編集が引き続き機能する場合
>
> Linux または macOS のリモートマシンでは、チェックが Desktop を経由しないため、Desktop が切断されている間も worktree 内の編集は引き続き機能します。Claude Desktop v2.37337.0 より前では、これは Linux リモートマシンにのみ当てはまります。
>
> 次のような場合には、編集は引き続き失敗します：
>
> * **組み込みの SSH クライアント**：Desktop がそれを使用している場合。たとえば、Microsoft Store からのインストール、Microsoft の OpenSSH 9.4 以降がない Windows コンピューター、またはサードパーティプロバイダーを使用する Windows でのデフォルトの場合です
> * **リポジトリの場所**：リポジトリがホームディレクトリ、その上位のフォルダ、または `~/.claude` である
> * **macOS のパス**：macOS のリモートマシンで、リポジトリが `/Volumes` の下にある、またはリポジトリもしくは worktree のパス内のフォルダ名に `~` または非 ASCII 文字が含まれている
> * **フォルダの制限**：組織がセッションで使用できるフォルダを制限している
> * **企業ランチャー**：Claude Desktop v2.37337.0 より前で、Claude アカウントでサインインしており、組織が[企業ランチャー](https://code.claude.com/docs/ja/corporate-launcher.md)を介してリモートマシンで Claude Code を起動している
>
> worktree を使用しないセッションには、組織がセッションで使用できるフォルダを制限していない限り、このようなチェックはありません。

##### 不在中に届いたリクエストに対応する

Desktop が切断されている間に Claude が承認を必要とするか質問をした場合、Claude はリモートマシン上で待機します。この待機自体には時間制限はありません。Desktop がプロセスに再参加すると、リクエストが表示されます。Desktop が代わりに新しいプロセスを開始した場合、リクエストは失われます。

戻ったときに待機していたリクエストがなくなっている場合、原因の 1 つとして、アップデートのインストールなどのために Desktop が自動的に再起動したことが考えられます。再起動後もリクエストが保持されるのは Desktop がプロセスに再参加できる場合のみであるため、タスクを実行したままにする前に [Desktop が再参加できる場合](#reopen-a-session-after-you-quit-desktop)を確認してください。

リクエストが失われた場合は、メッセージを送信して続行してください。

タスクがユーザーを待つために停止する頻度を減らし、不在中にタスクからの知らせを受け取るには、離れる前に次のいずれかを設定してください：

* **auto モード**：[利用可能な場合](#auto-mode-availability)は [auto モード](#choose-a-permission-mode)を選択します。ブロックが繰り返されると、[再度確認が求められます](https://code.claude.com/docs/ja/permission-modes.md#when-auto-mode-falls-back)。
* **許可ルール**：リモートマシン上のユーザー設定ファイル `~/.claude/settings.json` に、タスクに必要なコマンドの[許可ルール](https://code.claude.com/docs/ja/permissions.md#manage-permissions)を追加します。組織が[管理設定からの権限ルールのみを受け入れる](https://code.claude.com/docs/ja/settings-reference.md#allowmanagedpermissionrulesonly)場合は、リモートマシンに適用される[管理設定](#managed-settings)にそれらを追加するよう管理者に依頼してください。プロジェクトの `.claude/settings.json` の許可ルールについては、[プロジェクトの許可ルールとワークスペースの信頼](https://code.claude.com/docs/ja/permissions.md#project-allow-rules-and-workspace-trust)を参照してください。
* **応答するフック**：リモートマシン上の `~/.claude/settings.json` に [`PermissionRequest` フック](https://code.claude.com/docs/ja/hooks#permissionrequest)を設定し、ユーザーに代わってリクエストを許可または拒否します
* **通知するフック**：同じファイルに `permission_prompt` matcher を使用した [`Notification` フック](https://code.claude.com/docs/ja/hooks#notification)を設定し、リクエストが待機しているときに自分宛てにメッセージを送信します
* **Claude の完了を知らせるフック**：同じファイルに [`Stop` フック](https://code.claude.com/docs/ja/hooks#stop)を設定し、Claude が応答を終えたときに自分宛てにメッセージを送信します。API エラーによってターンが終了した場合は実行されません。その場合は、[`StopFailure` フック](https://code.claude.com/docs/ja/hooks#stopfailure)を設定してください。

組織が[管理フックのみを実行する](https://code.claude.com/docs/ja/settings-reference.md#allowmanagedhooksonly)場合は、リモートマシンに適用される[管理設定](#managed-settings)にフックを追加するよう管理者に依頼してください。

Claude Code は、Bypass permissions を含むどの権限モードでも、[いくつかのアクション](https://code.claude.com/docs/ja/permission-modes.md#actions-no-mode-auto-approves)を自動承認しません。権限モードに応じて、Claude Code はそのようなアクションを拒否するかユーザーに確認し、タスクはユーザーの回答を待機します。

##### スリープまたはネットワーク切断の後に再接続する

戻ったときに Desktop が再接続していない場合は、セッションでメッセージを送信してください。Desktop が自動的に再接続するのは、SSH エージェントが保持する鍵などを使用して、プロンプトなしでログインできる場合のみです。

* **記憶されたパスワード**：Desktop に記憶させたパスワードもプロンプトなしで機能しますが、長期間不在にする場合は SSH エージェントが保持する鍵を使用することをお勧めします。そのパスワードでのサインインが途中で切れたり応答しなくなったりする場合、Desktop は再接続を停止してユーザーを待つことがあります。
* **その他のプロンプト**：リモートマシンがワンタイムコードなど、その他の入力を求める場合、コンピューターに通知が届くことがあります。通知をクリックするか、セッションでメッセージを送信すると、Desktop にプロンプトが表示されます。

> [accordion] ジャンプホストがサインインを求める場合、停止が長い場合、出力が欠落している場合、またはプロセスが存在しない場合
>
> * **ジャンプホスト、不在中にプッシュ通知が止まる**：これは、ジャンプホストのサインイン（スマートフォンへのプッシュ通知など）に誰も応答しない場合に、macOS または Linux の Desktop で発生することがあります。その場合、Desktop はコンピューターの前に誰もいない間は再接続を停止します。コンピューターのロックを解除するか使用すると、Desktop が再試行できるため、別のプッシュ通知が届くことがあります。応答のない試行が 3 回続くと、ユーザーが再試行するかメッセージを送信するまで待機します。
> * **ジャンプホスト、プッシュ通知が届き続ける**：Windows の Desktop のように、Desktop が誰も応答していないことを判別できない場合、再参加するプロセスがある間は、そのプロセスがまだ実行中かどうかにかかわらず試行を続けます。試行のたびに別のプッシュ通知が届くことがあります。試行を終了するには Desktop を終了しますが、その場合は[実行中のタスクが失われる可能性があります](#reopen-a-session-after-you-quit-desktop)。
> * **長時間の停止**：Desktop は約 5 分ごとに 1 回の試行にペースを落とします。早く再接続するには、セッションで再試行するか、メッセージを送信します。メッセージは接続後に Desktop が配信します。
> * **出力の欠落**：Desktop が切断されている間、ヘルパーは各セッションの最新の Claude Code 出力を 16 MiB のバッファに保持し、それより古い出力は破棄します。Desktop が再接続した後、セッションに `Loading recent output from <host>…` と表示されることがあります。Desktop がすべての出力を読み込めない場合は、`Some output produced while you were disconnected may be missing here.` という行が表示されます。この行はタスクが停止したことを意味するものではありません。
> * **プロセスがなくなった**: リモートマシンの再起動時など、Desktop が切断されている間にプロセスが終了した状態です。その場合、Desktop は会話の保存された履歴から新しいプロセスを開始し、Claude にタスクを続行するよう指示できます。タスクが停止したままの場合は、メッセージを送信してください。サードパーティプロバイダーの場合は、それより前のバージョンでは自動的にタスクが続行されることはないため、Claude Desktop v2.42304.0 以降に更新してください。

##### Desktop を終了した後にセッションを再度開く

Desktop を終了した後もタスクはリモートマシン上で実行を続けますが、Desktop がそのプロセスに再参加できない限り、セッションを再度開いたときに停止します。Desktop が閉じている間、タスクは完了するか、ユーザーの対応が必要になるか、[制限](#limits-while-desktop-is-disconnected)のいずれかに達するまで実行されます。

* **Windows の Desktop で、v3.1623.0 より前のバージョンで開始したタスク**: その後 Desktop が更新されていても、タスクには戻れません。Desktop の起動時にセッションが開くことがあり、セッションが開くとタスクは停止するため、タスクが完了していると予想される時点になってから Desktop を再度起動してください。どのバージョンでタスクを開始したかわからない場合も、タスクが完了していると予想される時点まで待ってください。
* **macOS または Linux のサードパーティプロバイダーで、v2.42304.0 より前のバージョンで開始したタスク**: タスクには戻れません。タスクが完了していると予想される時点になってから Desktop を再度起動してください。
* **その他のタスク**: Desktop を起動してセッションを開くと、Desktop が再接続できればタスクは続行されます。一部の Desktop の更新後など、常に再接続できるとは限らないため、[長時間のタスクの前に更新してください](#prepare-a-long-task)。

タスクが停止すると、Desktop が新しいプロセスを開始する間、セッションに `Restarting Claude Code on <host>…` が表示されることがあります。また、待機していた承認や質問も失われます。Claude が自動的に続行しない場合はメッセージを送信してください。Claude は会話の保存済み履歴から続行します。

サードパーティのデプロイについては、[SSH remote sessions in Claude Desktop on 3P](https://claude.com/docs/third-party/claude-desktop/ssh-remote-sessions) を参照してください。

> [!WARNING]
>
> 会話の Claude Code プロセスがまだ実行されている間は、リモートマシン上でその会話に対して [`claude --resume`](https://code.claude.com/docs/ja/cli-reference#cli-flags) を実行しないでください。Claude Code はそれを阻止せず、両方のプロセスが同じ会話に書き込むことになります。不明な場合は `--fork-session` を追加すると会話のコピーで続行されますが、両方のプロセスは引き続き同じファイルを操作します。

#### SSH セッションの worktree の作成場所を選択する

組織がセッションで使用できるフォルダーを制限していない限り、新しい SSH セッションは、次の場所のうち設定されている最初の場所に [worktree](#run-a-session-in-its-own-worktree) を作成します。

1. SSH 接続の **Worktree folder**
2. リモートマシン上の `~/.claude/settings.json` にある [`worktree.location`](https://code.claude.com/docs/ja/settings-reference#worktree-location)
3. デフォルトの `<project-root>/.claude/worktrees/`

設定したフォルダ内には各プロジェクト専用のサブフォルダが作成されるため、`~/worktrees` を設定した場合、worktree のパスは `~/worktrees/<project>-<id>/<worktree-name>` になります。設定したフォルダがプロジェクト内にある場合、Desktop はそのプロジェクトではそのフォルダを無視し、デフォルトを使用します。[Windows リモートマシン](#windows-remote-machines)では、Desktop は常にデフォルトを使用します。

##### 既存の接続で worktree フォルダーを設定する

以前に追加した接続、または組織が管理する接続の設定で **Worktree folder** を設定します。このフィールドには Claude Desktop v1.44121.0 以降が必要です。組織がセッションで使用できるフォルダーを制限している場合、Desktop はこのフィールドを非表示にし、worktree をプロジェクト内に保持します。

**1. 接続を見つける**

[環境セレクター](#start-a-session)を開き、**SSH** の下で接続を探します。

**2. 接続の設定を開く**

接続にカーソルを合わせ、歯車アイコンをクリックします。開いたダイアログの **Host** の横に **Edit connection…** が表示されている場合は、**Edit connection…** を選択します。

**3. フォルダーを設定する**

**Worktree folder** に `~/worktrees` などのリモートマシン上のフォルダーを入力し、**Save changes** を選択します。

#### リモートマシン上のファイルとプロセス

Desktop は、Linux または macOS のリモートマシンに接続する各ユーザーのホームディレクトリの `~/.claude/remote/` の下に、ヘルパープログラムと Claude Code をインストールします。ヘルパーはどのネットワークポートもリッスンしませんが、Claude Code と、MCP サーバーや開発サーバーなど Claude Code が起動するプログラムはリッスンすることがあります。

| フォルダ | 内容 |
| - | - |
| `~/.claude/remote/srv/` | ヘルパー（バージョンごとに 1 つのフォルダ） |
| `~/.claude/remote/ccd-cli/` | Claude Code（バージョンごとに 1 つのファイル） |
| `~/.claude/remote/run/` | ソケットやログなど、ヘルパーのランタイムファイル（接続するコンピューターごとに 1 つのフォルダ） |
| `~/.claude/remote/plugins/` | Desktop がユーザーのコンピューターからコピーするプラグイン |
| [`~/.claude/uploads/`](https://code.claude.com/docs/ja/claude-directory#clear-local-data) | ユーザーがメッセージに添付するファイル（セッションごとに 1 つのフォルダ） |

1 人のユーザーのプロセスを一覧表示するには、リモートマシン上でそのユーザーとして `pgrep -fl "$HOME/.claude/remote/"` を実行するか、`$HOME` の代わりにそのユーザーのホームディレクトリを指定して実行します：

* **ヘルパー**：接続するコンピューターごとに 1 つ以上の `server` プロセス
* **Claude Code**：ヘルパーがユーザーのセッションのために起動するプロセス。それぞれ `2.1.295-…` のように、バージョンにちなんだ名前のファイルから起動されます

Desktop は、ユーザーの SSH 接続を通じて、`~/.claude/remote/run/` の下にあるヘルパーのフォルダ内の Unix ソケット `rpc.sock` を経由してヘルパーに到達します。ソケットのモードは 600、そのフォルダのモードは 700 であるため、root を除き、マシン上の他のユーザーはそのソケットに接続できません。

ヘルパーが自動的に停止する場合については、[Desktop の切断中の制限](#limits-while-desktop-is-disconnected)を参照してください。

1 人のユーザーのヘルパーと Claude Code を削除するには：

**1. Desktop を終了する**

ユーザーが接続する各コンピューターで Desktop を終了します。Desktop は次回接続時に両方のプログラムを再度インストールし、自動的に再接続することがあります。

**2. プロセスを終了する**

リモートマシンにそのユーザーとしてログインし、[`pgrep`](#files-and-processes-on-the-remote-machine) が一覧表示する各 Claude Code プロセスの ID を指定して `kill` を実行します。それらが一覧から消えたら、各 `server` プロセスの ID を指定して `kill` を実行します。先に `server` プロセスを終了すると、Claude Code が実行中のコマンドが実行を続けることがあります。

次に、`ps -u "$(id -un)" -f` などでユーザーの残りのプロセスを一覧表示し、Claude Code が起動したと分かるものを終了します。Claude Code がバックグラウンドに残したプログラムは、`pgrep` の一覧に含まれないまま、Claude Code の終了後も実行を続けることがあります。

**3. フォルダを削除する**

`~/.claude/remote/` を削除します。`~/.claude/` と `~/.claude.json` にある Claude Code 自体のファイルを削除するには、[設定ファイルを削除する](https://code.claude.com/docs/ja/setup.md#remove-configuration-files)を参照してください。

##### 1 つのセッションのプロセスを終了する

1 つのセッションの Claude Code プロセスを終了するには、Desktop がリモートマシンに接続されている間に、Desktop で[セッションをアーカイブ](#archive-a-session)します。プロセスは、タスクの完了後も Desktop の終了後も実行を続けます。

worktree にコミットされていない変更があるセッションをアーカイブする前に、[セッションのアーカイブ時にコミットされていない変更を保持する](#keep-uncommitted-changes-when-a-session-is-archived)を参照してください。

##### プロセスを実行するユーザーを確認する

ヘルパーと Claude Code は、Desktop が SSH でログインするユーザーとして実行されます。これらのインストールと起動に `sudo` は必要ありません。ユーザーを確認するには、[`pgrep`](#files-and-processes-on-the-remote-machine) が一覧表示するプロセス ID を指定して、リモートマシンで `ps -o user= -p` を実行します。

シェルコマンドや MCP サーバーなど、Claude Code が起動するプログラムも、そのユーザーとして起動します。そこでコマンドを実行する人に対して行うのと同様に、`sudo` ルールを含め、リモートマシン上のそのユーザーの権限を確認してください。

##### リモートマシンに接続したユーザーを確認する

リモートマシンに誰が接続したかを確認するには、そのマシン上の SSH サーバーのログを読みます。ログでは、Desktop からのログインはターミナルからのログインと同じように表示されます。macOS または Linux の Desktop では、エントリはセッションごとではなく、Desktop が接続するたびに記録されます。

サーバーが `MaxSessions 1` を設定している場合、Desktop が接続または再接続するたびに少なくとも 2 つのエントリが記録されます。さらに、ターミナルタブごと、および `!` で始まるコマンドを実行する Desktop セッションごとに、少なくとも 1 つずつ追加されます。

Desktop の SSH 接続は、Claude Code の[メトリクスとイベント](https://code.claude.com/docs/ja/monitoring-usage.md#available-metrics-and-events)には含まれません。そこから SSH セッションがどのリモートマシンで実行されたかを確認するには、[Desktop SSH セッションにテレメトリを関連付ける](https://code.claude.com/docs/ja/monitoring-usage.md#attribute-telemetry-to-desktop-ssh-sessions)を参照してください。Desktop 自体の接続記録については、[SSH の問題について Desktop のログを取得する](#get-desktops-logs-for-an-ssh-problem)を参照してください。

#### ログイン前に閉じる接続

SSH サーバーのログに、ログイン前に閉じる接続が記録されている場合、それは Desktop による SSH ポートのテストである可能性があります。Desktop は、たとえばマシンへの接続が失敗した後などに、マシンが応答するかどうかをテストします。ポートへの接続を開き、何も送信せずにすぐに閉じます。テストは 1 回の場合もあれば、たとえば約 2 分間に 8 回など、連続して複数回行われる場合もあります。

そのような接続に対してアドレスを禁止または拒否する仕組みがない場合は、Desktop のテストについて何もする必要はありません。Desktop の接続元アドレスが拒否または禁止される場合は、[SSH サーバー自体がそのアドレスを拒否しているかどうか](#check-whether-the-ssh-server-itself-refuses-the-address)と、[fail2ban が Desktop のテストをカウントしているかどうか](#check-whether-fail2ban-counts-desktops-tests)を確認してください。

##### SSH サーバーのログでテストを識別する

ログの行を、Linux 上の OpenSSH サーバーがデフォルトの `LogLevel` でテストについて書き込む行と、サーバーのバージョンに対応する行で比較してください。Desktop が接続を閉じる前にサーバーのグリーティングが届いた場合は、代わりに最後の列の行が表示されることがあります。

| OpenSSH のバージョン | テストの行 | グリーティングが先に届いた場合の行 |
| - | - | - |
| 6.6 から 7.9 | `Did not receive identification string from 203.0.113.7` を含む行 | 同じ行 |
| 8.0 から 8.2 | `error: kex_exchange_identification: Connection closed by remote host` | `error: kex_exchange_identification: read: Connection reset by peer` |
| 8.3 から 9.4 | `error: kex_exchange_identification: Connection closed by remote host`、続いて `Connection closed by 203.0.113.7 port 51234` | `error: kex_exchange_identification: read: Connection reset by peer`、続いて `Connection reset by 203.0.113.7 port 51234` |
| 9.5 から 10.2 | `Connection closed by 203.0.113.7 port 51234` | `error: kex_exchange_identification: read: Connection reset by peer`、続いて `Connection reset by 203.0.113.7 port 51234` |
| 10.3 から 10.5 | `Connection closed by 203.0.113.7 port 51234 [preauth]` | `error: kex_exchange_identification: read: Connection reset by peer [preauth]`、続いて `Connection reset by 203.0.113.7 port 51234 [preauth]` |

ポートを開いて閉じる他のプログラムも、同じ行を残すことがあります。行にアドレスがある場合は、それが Desktop を使用するコンピューターの接続元アドレスであることを確認してください。

8.0 から 8.2 の行にはアドレスがありません。アドレスを取得するには、`sshd_config` で `LogLevel VERBOSE` を設定し、root として `sshd -T | grep -i loglevel` を実行します。`loglevel VERBOSE` と出力された場合は、SSH サーバーをリロードします。その後、テストの行の前にある `Connection from 203.0.113.7 port 51234` を含む行を探してください。

##### SSH サーバー自体がアドレスを拒否しているかどうかを確認する

Desktop を使用する多数のコンピューターが共有するアドレスからの接続が拒否される場合は、SSH サーバーのログで次のように終わる行を探してください。

```text theme={null}
drop connection #0 from [203.0.113.7]:51234 on [192.0.2.10]:22 penalty: connections without attempting authentication
```

デフォルトの `LogLevel` では、OpenSSH 9.8 以降は、Desktop のテストのようにログインを試みずに閉じた接続を理由にアドレスを拒否する際に、このような行を書き込むことがあります。デフォルト設定では、数回のテストだけでこのような行が表示されることはありません。

拒否を防ぐには、`sshd_config` で `PerSourcePenaltyExemptList` を接続元のアドレスに設定します（例: `PerSourcePenaltyExemptList 203.0.113.7`）。サーバーはそれらのアドレスに対して、ログイン失敗に対するものを含め、どのペナルティも適用しなくなります。ファイルを確認するには、root として `sshd -T | grep -i persourcepenalt` を実行します。リストが出力された場合は、SSH サーバーをリロードしてください。

##### fail2ban が Desktop のテストをカウントしているかどうかを確認する

fail2ban 0.10.5 以降が Desktop の接続元アドレスを禁止した場合は、`jail.conf`、`jail.local`、または `jail.d/` の下で jail のモードを確認します。

* **角かっこ内でモードを指定する `filter` 行**（`filter = sshd[mode=aggressive]` など）がある場合: そのモードを使用します。
* **標準の `filter` 行**（`[mode=%(mode)s]`）のみの場合: `mode` 行を使用し、ない場合は `normal` を使用します。

モードが `normal` の場合、fail2ban は Desktop のテストの行をカウントしないため、禁止の別の原因を探してください。

それ以外のモードの場合は、自分のログの行をリモートマシン上のファイルにコピーします。各行を日付から末尾まで丸ごとコピーし、テストが 2 行を残す場合は両方の行をコピーします。そこで、ファイルと jail のモード（たとえば `aggressive`）を指定して `fail2ban-regex` を実行します。

```bash theme={null}
fail2ban-regex -o ip lines.log "sshd[mode=aggressive]"
```

fail2ban がカウントする失敗ごとに、コマンドは `203.0.113.7` のようにアドレスを 1 行ずつ出力します。その場合は、[禁止を防いで](#prevent-a-ban-by-fail2ban)ください。何も出力されない場合、fail2ban はそのモードではそれらの行を 1 つもカウントしていないため、禁止の別の原因を探してください。

##### fail2ban による禁止を防ぐ

fail2ban が Desktop のテストを理由にアドレスを禁止しないようにするには、jail の 2 つの設定のいずれかを変更します。どちらにも代償があります。

* **`mode`**: jail で設定されている箇所（`mode` 行、または `filter = sshd[mode=aggressive]` のような行の角かっこ内）で `normal` に設定します。ログインを試みずに接続して切断するクライアントのカウントなど、他のモードでのみ行われるカウントはすべて行われなくなります。
* **`ignoreip`**: 接続元のアドレスに設定します（例: `ignoreip = 203.0.113.7`）。fail2ban は、ログイン失敗を含め、それらのアドレスからのものを一切カウントしなくなります。

#### リモートマシンで設定した MCP サーバーを使用する

SSH セッションで `~/.claude.json` またはプロジェクトの `.mcp.json` の [MCP サーバー](https://code.claude.com/docs/ja/mcp.md)を使用するには、リモートマシン上のそれらのファイルで設定します。Claude Code はそれらの stdio サーバーをリモートマシンで起動するため、それらのサーバーが実行するコマンドをリモートマシンにインストールしてください。`claude_desktop_config.json` のサーバーについては、[Desktop の切断中の制限](#limits-while-desktop-is-disconnected)を参照してください。

#### リンクから SSH セッションを開く

`claude://code/new` リンクは Desktop の新規セッションページを開き、SSH 接続を指定することもできます。このようなリンクを runbook、ダッシュボード、または wiki ページに置いておくと、適切なマシンとフォルダが設定された状態で Desktop を開けます。このようなリンクを除去するプラットフォームについては、[リンクがクリック可能にならずプレーンテキストとして表示される](https://code.claude.com/docs/ja/deep-links.md#the-link-renders-as-plain-text-instead-of-being-clickable)を参照してください。

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

#### コマンドから SSH 接続を作成する

コマンドラインツールでリモートマシンをオンデマンドで作成している場合は、そのコマンドを [`~/.claude/settings.json`](https://code.claude.com/docs/ja/settings#settings-files) の `sshHostCommands` に追加します。すると環境セレクターに、**Create Dev box** のようにエントリー名を含む項目が表示されます。それを選択すると、Desktop はコンピューター上でコマンドを実行し、コマンドが出力したホストを SSH 接続として保存して接続します。

> [!NOTE]
>
> コマンドからの接続には、macOS または Linux 上の Claude Desktop v3.6556.0 以降と、Claude アカウントでのサインインが必要です。管理者は[コマンドをチームに配布](#distribute-commands-to-your-team)できます。

Desktop がコマンドを実行するのは、接続の作成時、または[別のマシンを作成](#create-another-machine)するときのみで、接続のたびに実行するわけではありません。各エントリは 1 つの接続であり、その接続は、エントリのコマンドから Desktop が最後に保存したホストを指します。

> [!WARNING]
>
> Desktop はマシンを停止も削除もしません。次のものはいずれも、ツールで削除するまで実行され続け、費用が発生し続ける可能性があります。
>
> * [別のマシンを作成](#create-another-machine)する前にエントリが指していたマシン
> * ファイルから削除したエントリ、または `id` を変更したエントリのマシン
> * コマンドが作成したものの、Desktop がそのホストを保存しなかったマシン。たとえば次の場合です。
>   * コマンドが失敗した、またはタイムアウトした
>   * 出力されたホストを Desktop が使用できない、別の接続がすでにそのホストを使用している、または組織がそれを許可していない
>   * コマンドの実行中に、コマンドをキャンセルした、そのエントリを削除した、その `command` または `id` を変更した、あるいは Desktop を終了した

次の例は、Dev box という名前の接続を追加します。ファイルが存在しない場合は作成してください。すでに設定が含まれている場合は、その横にキーを追加します。コマンド `acme-dev create` は独自のツールを表し、`~/project` はコマンドが作成した各マシンで Desktop が選択するフォルダーです。

```json ~/.claude/settings.json theme={null}
{
  "sshHostCommands": [
    {
      "id": "devbox",
      "name": "Dev box",
      "command": "acme-dev create",
      "startDirectory": "~/project"
    }
  ]
}
```

各エントリーは次のフィールドを受け付けます。`id`、`name`、`command` は必須です。

| フィールド | 値 |
| :- | :- |
| `id` | 最大 64 文字の ASCII 英字、数字、`.`、`_`、`-` で、英字または数字で始まるもの。`sshHostCommands` または [`sshConfigs`](#pre-configure-ssh-connections-for-your-team) の他のどのエントリにもない `id` を使用してください。Desktop は接続のホストをこの ID の下に保持するため、これを変更すると、接続はホストのない状態からやり直しになり、そのマシンは実行され続け、Desktop は[引き続きそれらに接続できます](#remove-an-entry)。 |
| `name` | 環境セレクターに表示される接続の名前。1 行で最大 200 文字 |
| `command` | プログラムとその引数。[コマンドを記述する](#write-the-command)で説明するとおりに記述します |
| `sshIdentityFile` | 秘密鍵へのパス（`~/.ssh/id_ed25519` など）。SSH 設定または SSH エージェントを使う場合は省略します。 |
| `startDirectory` | リモートマシン上のデフォルトフォルダー。`/` または `~/` で始めるか、`~` を使用します。 |

接続を変更または削除するには、ファイル内のそのエントリーを編集します。この接続に対してはアプリの SSH 接続ダイアログが開かないためです。ファイルを編集した後に Desktop を再起動する必要はありません。エントリーが表示されない場合や選択できない場合は、[コマンドが表示されない、またはグレー表示になる場合](#if-a-command-is-missing-or-gray)を参照してください。

##### コマンドを記述する

Desktop はシェルやターミナルを介さずにプログラムを直接起動します。

* **プログラム**: 名前、または `/` から始まるフルパスをスペースなしで記述します。名前のみの場合、Desktop はログインシェルがエクスポートする `PATH` から検索します。`./acme-dev` のような相対パス、`~` で始まるパス、シェルのエイリアスや関数は機能しません。
* **引数**: 通常の引数はスペースで区切ります。コマンドに含められるのはスペース、ASCII の英字、数字、および文字 `+,-./:=@_~` のみで、どの単語も `~` で始めることはできません。
* **スクリプト**: 引用符、パイプ、変数、`?` や `&` を含む URL など、それ以外のものが必要な場合は、スクリプトに記述します。スクリプトを実行可能にし、`#!` 行で始め、`command` をそのフルパス（`/Users/you/bin/make-devbox` など）に設定します。macOS では、macOS がブロックする可能性があるため、スクリプトを書類、デスクトップ、ダウンロードの各フォルダーに置かないでください。
* **入力**: プログラムには入力もターミナルも与えられないため、そこでユーザーに入力を求めることはできません。ツールがブラウザーやプロンプトを通じてサインインする場合は、事前にターミナルからサインインし、そのサインインが期限切れになるたびに再度サインインしてください。
* **環境**: プログラムはホームディレクトリで、ログインシェルがエクスポートする変数を使って実行されます。Desktop は [`ProxyCommand`](#use-variables-from-your-shell-in-a-proxycommand) の場合と同様に起動時にこれらの変数を読み込むため、変数を変更した後は Desktop を終了して再度開いてください。
* **制限時間**: Desktop は 10 分経過してもまだ実行中のプログラムを停止します。Desktop の進行状況メッセージにはプログラムの出力は表示されません。プログラムをより早く停止するには、そのメッセージの横にある **Cancel** を選択します。

プログラムは終了コード 0 で終了し、標準出力にはホストのみを次の 2 つの形式のいずれかで出力する必要があります。

* **1 行**: `host` または `user@host`。[SSH リンク](#open-an-ssh-session-from-a-link)の `ssh_host` と同じ形式で記述します。ポートを指定するには JSON 形式を使用します。
* **1 つの JSON オブジェクト**: `sshHost` と、オプションで数値の `sshPort` およびエントリーの値を置き換える `startDirectory`。例: `{"sshHost": "dev@devbox-1234.example.com", "sshPort": 2222}`

Desktop が読み取る出力を確認するには、入力なしで標準出力をファイルに書き出す形でターミナルからコマンドを実行します。

```bash theme={null}
acme-dev create < /dev/null > host.txt
```

ファイルにはホストのみが含まれている必要があります。このテストを実行するとツールがマシンも作成するため、後でツールを使って削除してください。

ツールが進行状況メッセージなど、ホストより前にほかの行を出力する場合は、ホストのみを出力するスクリプトでツールをラップします。次のスクリプトはツールの出力の最終行を出力します。ツールが失敗した場合、スクリプトは同じコードで終了するため、Desktop は失敗を報告します。

```bash theme={null}
#!/bin/bash
out=$(mktemp) || exit
trap 'rm -f "$out"' EXIT
acme-dev create > "$out" || exit
tail -n 1 "$out"
```

コマンドが失敗した場合、Desktop のメッセージにある **View details** に、コマンドが標準エラーに書き込んだ最後の行があれば表示されます。

##### 新しいホストに接続する

新しいホストに初めて接続するときは、2 つの質問に答えます。

* **ホストキー**: OpenSSH のデフォルトのホストキー検証では、キーのフィンガープリントを確認してから、接続するかどうかを選択します。この質問を省略するには、ツールがマシンを作成したときに取得したキーを使い、ホストを出力する前にコマンドでそのキーを `~/.ssh/known_hosts` に追加させます。ポートが 22 以外の場合、その行は `[host]:port` で始まります。ツールがホスト名を再利用する場合は、古いキーの行も削除してください。
* **フォルダー**: そのホストで開くフォルダーを信頼するかどうかを選択します。

これらのホストではホストキー検証をオンのままにし、`known_hosts` ファイルを保持してください。`StrictHostKeyChecking` が `no` または `accept-new` で、かつ `UserKnownHostsFile` が `/dev/null` または `none` の場合、キーはどこにも記録されません。その状態でツールが名前を再利用すると、警告なしに別のマシンに接続してしまう可能性があります。

Desktop はこれらのホストに自動的に接続するため、コンピューターの前に誰もいない場合にも、名前の再利用は問題になります。たとえば、ホストに到達できない間に送信したメッセージは、ホストが応答した時点で配信されます。ホストキーチェックがオンであっても、次の場合にはメッセージがその名前の新しいマシンに届く可能性があるため、マシンが削除される前に[マシンの使用を停止](#stop-using-a-machine)してください。

* ユーザー、コマンド、または別のプログラムが新しいキーを `known_hosts` に追加した、または古いキーの行を削除した（コマンドがホストキーを追加する場合はコマンドがこれを行います）
* ツールのマシンがホストキーを共有している
* ツールのマシンが、`known_hosts` が信頼する認証局を共有している
* ユーザーまたは管理者が `KnownHostsCommand` または `VerifyHostKeyDNS yes` を設定しているため、SSH が `known_hosts` 以外からのキーを受け入れる

##### 別のマシンを作成する

**Create another Dev box** を選択した後も、以前のマシン上のセッションは引き続き機能し、新しいセッションは新しいマシンを使用します。新しいマシンを作成する場合や、なくなったマシンを置き換える場合は、環境セレクターでこの項目を選択します。新規セッションページでは、Desktop がホストに到達できないことを示すメッセージからも選択できます。

* **以前のマシン上のセッション**: セレクターには Dev box の現在のマシンが表示され、以前のマシンは表示されないため、サイドバーからセッションを続行します。Desktop は、たとえば起動時などに、それらのマシンに自動的に接続することがあるため、使用を終えたら[マシンの使用を停止](#stop-using-a-machine)してください。
* **Claude Desktop v4.4212.0 より前に置き換えたホスト**: これらのバージョンでは **Replace Dev box's host** が表示され、置き換えられたホストへの接続を停止します。そのホスト上のセッションを続行するには、セッションを開いて **Add SSH connection** を選択し、Desktop が入力した接続を保存します。別のホストを置き換える前に Desktop を更新してください。
* **2 台のマシンでの新しいセッション**: [`sshHostCommands`](#create-an-ssh-connection-from-a-command) に 2 つ目のエントリを追加します
* **まだ応答しない新しいホスト**: 新規セッションページが接続を試行し続けている間、最大 10 分間ページを開いたままにします。それでもホストが応答しない場合は、ページのメッセージで **Create another Dev box** を選択します。
* **直後に別のマシンを作成する**: 1 時間以内にコマンドを何度か実行した後は、それ以降の実行ごとに、Desktop が開くコマンドを表示するダイアログで確認します

##### マシンの使用を停止する

コマンドが作成したマシンに Desktop が自動的に接続しないようにするには、そのマシン上のすべてのセッションをアーカイブします。

1. サイドバーでそのマシンのセッションを探します。セッションの[詳細パネル](#see-session-details)には、セッションが実行されているホストが表示されます。
2. [各セッションをアーカイブ](#archive-a-session)し、アーカイブしたままにします。
3. このマシンを作成した後に同じ `sshHostCommands` エントリから別のマシンを作成していない場合は、[別のマシンを作成](#create-another-machine)するか、[エントリを削除](#remove-an-entry)もします。それまでは、このマシンがエントリの保存済み接続であり、その接続が選択された状態で新規セッションページを開くと、Desktop がこのマシンに接続する可能性があります。
4. アプリでそのマシンへの他の SSH 接続を削除するか、その [`sshConfigs`](#pre-configure-ssh-connections-for-your-team) エントリを削除します。
5. Desktop を終了して再度開きます。これにより、マシンへの接続が閉じられ、到達の試行が終了します。
6. ツールでマシンを削除します。

##### エントリを削除する

設定ファイルからエントリを削除したり、その `id` を変更したりした後も、そのマシン上のセッションは残るため、Desktop は引き続きそれらのマシンに接続できます。たとえば、セッションの実行中のプロセスに再接続したり、送信待ちだったメッセージを配信したりするために、コンピューターの前に誰もいなくても接続することがあります。これを停止するには、[マシンの使用を停止する](#stop-using-a-machine)で説明するとおりにセッションをアーカイブします。

管理者が管理対象のエントリを削除した場合も、ユーザーのセッションは残り、各ユーザーが自分のセッションをアーカイブする必要があります。エントリのマシンを管理者側でブロックするには、ユーザーが引き続き必要とするホストには一致し、マシンのホスト名には一致しない [`sshHostAllowlist`](#restrict-which-ssh-hosts-users-can-connect-to) を設定します。これができるのは、パターンで両者を区別できる場合のみです。

##### コマンドをチームに配布する

チームに接続を提供するには、デスクトップアプリ独自の[デバイス管理ポリシー](#device-management-policies)ではなく、各コンピューター上の Claude Code の[管理設定](https://code.claude.com/docs/ja/managed-settings.md)ファイルまたは MDM ポリシーで `sshHostCommands` を設定します。ユーザーには自分のエントリーと並んで管理者のエントリーが表示されます。アプリには、ユーザーのものであれ管理者のものであれ、エントリーを編集または削除する手段はありません。

次の管理設定ファイルは、Dev box という名前の接続をユーザーに提供し、ユーザー独自のエントリーを、ユーザー設定、プロジェクト設定、ローカル設定の Claude Code フックとあわせてオフにします。

```json managed-settings.json theme={null}
{
  "sshHostCommands": [
    {
      "id": "acme-devbox",
      "name": "Dev box",
      "command": "/usr/local/bin/acme-dev create"
    }
  ],
  "strictPluginOnlyCustomization": ["hooks"]
}
```

キーをデプロイする前に、次の各点を決めておいてください。

* **キーの配置場所**: Claude Code 用の MDM ポリシーですでに[ポリシーキー](https://code.claude.com/docs/ja/managed-settings.md#how-claude-code-combines-managed-sources)を設定している場合は、そこに配置します。そうでない場合は、管理設定ファイルに配置します。デフォルトでは、そのようなポリシーはファイルより優先され、その場合 Desktop はファイル内のエントリーを無視します。[サーバー管理設定](https://code.claude.com/docs/ja/server-managed-settings.md)が適用される環境でも、コンピューター上で設定してください。Desktop はサーバー管理設定、およびプロジェクト設定とローカル設定にあるこのキーを無視します。
* **`id`**: ユーザーの `sshHostCommands` エントリが管理者の `id` を持っている場合、管理者のエントリのみが機能します。ユーザーの `sshConfigs` にあるものなど、他の SSH 接続がその ID を持っている場合、管理者のエントリはグレー表示になります。ユーザーが選びそうにない `id` を選んでください。
* **プログラム**: Desktop は名前のみの場合に各ユーザー自身の `PATH` から検索するため、フルパスを指定してください。プログラムはそのユーザーとして、ユーザーのログインシェルがエクスポートする変数を使って実行されます。
* **ユーザー独自のエントリー**: どちらもコンピューター上でプログラムを実行するため、Desktop はユーザーのエントリーを[フック](https://code.claude.com/docs/ja/hooks.md)と同様に扱います。管理者のエントリーのみを許可するには、[`strictPluginOnlyCustomization`](https://code.claude.com/docs/ja/settings-reference#strictpluginonlycustomization) を `["hooks"]` に設定するか、そのリストに `"hooks"` を追加します。これにより、ユーザー設定、プロジェクト設定、ローカル設定の Claude Code フックも停止され、それらを維持する方法はありません。代わりにこのキーまたは [`allowManagedHooksOnly`](https://code.claude.com/docs/ja/settings-reference#allowmanagedhooksonly) を `true` に設定すると、各キーの項目に記載されているとおり、より多くのものがブロックされます。
* **すべてのエントリ**: 管理者のエントリもオフにするには、管理設定で [`disableAllHooks`](https://code.claude.com/docs/ja/settings-reference#disableallhooks) を設定します。[`disableDesktopLocalSessions`](https://code.claude.com/docs/ja/settings-reference#disabledesktoplocalsessions)、またはどのホストも許可しない `sshHostAllowlist` を設定した場合、セレクターには **Create** や **Create another** の項目は表示されません。
* **ロックが有効になる場所**: これらのエントリーについて、Desktop は `allowManagedHooksOnly`、`strictPluginOnlyCustomization`、`disableAllHooks` をサーバー管理設定とコンピューター自身のファイルまたはポリシーから読み取り、より厳しい結果を適用します。組織にサーバー管理設定がない場合でも、Desktop が claude.ai でサーバー管理設定を確認するまで、すべてのエントリーはグレー表示のままです。
* **許可されたホスト**: [`sshHostAllowlist`](#restrict-which-ssh-hosts-users-can-connect-to) を設定する場合は、ツールが出力する各ホスト名にいずれかのパターンが一致するようにし、パターンには `user@` を含めないでください。Desktop が出力された名前を確認するのはコマンドの実行後であるため、リストで拒否されたマシンはすでに存在しており、ユーザーはツールを使ってそれを削除する必要があります。各接続時には、解決後の `HostName` も一致する必要があります。

キーをデプロイした後、テスト用のコンピューターで Desktop を再起動します。Code タブの環境セレクターで、**SSH** の下、または単一の **SSH** 行を確認します。エントリーは **Create** 項目として、またはホバーすると理由が表示されるグレー表示の項目として表示されます。表示されない場合は、キーの配置場所を確認し、次に[コマンドが表示されない、またはグレー表示になる場合](#if-a-command-is-missing-or-gray)のケースを確認してください。

##### コマンドが表示されない、またはグレー表示になる場合

次の場合、環境セレクターには **Create** や **Create another** の項目が表示されません。

* **ファイル**: `~/.claude/settings.json` に[無効な JSON またはスキーマで拒否される値](https://code.claude.com/docs/ja/settings.md#fix-a-broken-settings-file)がある、キーのスペルを間違えている、またはプロジェクトの設定にキーを記述している。ファイルを修正してください。
* **プラットフォームとアカウント**: Windows を使用している、または Claude アカウントではなく[サードパーティプロバイダー](https://code.claude.com/docs/ja/third-party-integrations.md)を使用している。各ホストを自分で [SSH 接続](#ssh-sessions)として追加してください。
* **組織の設定**: 管理者がローカルセッションをオフにしている、または SSH セッションをオフにしている。コマンドを使用できるかどうか管理者に確認してください。
* **`ssh` プログラムがない**: Desktop がコンピューター上の OpenSSH クライアントを起動できなかった。インストールするか、管理者に許可を依頼してから、Desktop を再起動してください。

選択できないエントリーはグレー表示になります。ホバーすると理由が表示されます。

* **エントリの誤り**: メッセージに示されたフィールドまたはコマンドを修正します。`id` が使用中の場合は、エントリに別の ID を付けます。
* **壊れた設定ファイル**: 自分の設定ファイルが壊れている間、管理者のエントリーが、ファイル名を示すメッセージとともにグレー表示になることがあります。[ファイルを修正](https://code.claude.com/docs/ja/settings.md#fix-a-broken-settings-file)してください。
* **新しいホスト**: Desktop がホストを保存してから 1 分間、[**Create another**](#create-another-machine) はグレー表示になります。1 分経過後に選択してください。Claude Desktop v4.4212.0 より前では、**Replace Dev box's host** が 10 分間グレー表示になります。
* **フックがオフまたは制限されている**: 自分のエントリーは、自分のフックが実行できる場合にのみ機能します。設定から `disableAllHooks` を削除するか、管理者に相談してください。
* **設定がまだ読み込み中**: Desktop が組織の[サーバー管理設定](https://code.claude.com/docs/ja/server-managed-settings.md)を読み込むまで（通常は起動から数秒）、すべてのエントリーはグレー表示になります。エントリーがグレー表示のままの場合は、claude.ai への接続を確認してください。

#### チームの SSH 接続を事前設定する

管理者は、[管理設定](https://code.claude.com/docs/ja/managed-settings.md)で `sshConfigs` を設定することで、チームメンバーに SSH 接続を配布できます。

* **ユーザーに表示される内容**：この方法で定義された接続は、各ユーザーの環境セレクターに自動的に表示されます。
* **ユーザーが変更できる内容**：ユーザーは管理対象の接続を選択し、その接続に対して[独自の **Worktree folder** を設定](#set-the-worktree-folder-on-an-existing-connection)できます。その他のフィールドを編集したり、アプリ内で削除したりすることはできません。

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

#### ユーザーが接続できる SSH ホストを制限する

管理者は、[管理設定](https://code.claude.com/docs/ja/managed-settings.md)で `sshHostAllowlist` を設定することで、Desktop の SSH セッションを承認されたホストのセットに制限できます。設定されると、ユーザーは解決されたホスト名がパターンの 1 つと一致するホストにのみ接続できます。SSH セッションを無効にするには、空の配列に設定します。空の配列が他の管理ソースのリストとどのように組み合わされるかについては、[`sshHostAllowlist` のリファレンス項目](https://code.claude.com/docs/ja/settings-reference#sshhostallowlist)を参照してください。

次の例は、`devboxes.example.com` の下のすべてのホストと、単一の名前付きバスティオンホストへの接続を許可しています：

```json theme={null}
{
  "sshHostAllowlist": ["*.devboxes.example.com", "bastion.example.com"]
}
```

> [!WARNING]
>
> 組織が[サーバー管理設定](https://code.claude.com/docs/ja/server-managed-settings.md)を配信している場合は、`sshHostAllowlist` をそこで設定してください。デフォルトでは、Desktop は[ポリシーキーを配信する最上位の管理ソース](https://code.claude.com/docs/ja/managed-settings.md#how-claude-code-combines-managed-sources)からのみこのキーを読み取ります。そのソースでキーが設定されていない場合、Desktop は下位の MDM ポリシーまたは管理設定ファイルにあるリストを無視し、キーを[未設定](https://code.claude.com/docs/ja/settings-reference.md#sshhostallowlist)として扱います。Desktop は警告を表示しません。
>
> また、各ユーザーのマシンでも、そのマシンの最上位の MDM ポリシーまたは管理設定ファイルに同じリストを保持してください。Desktop は起動時にサーバー管理設定を取得し、キャッシュされたコピーを保持しないため、取得が成功するまではマシンのリストが適用されます。

パターンは大文字と小文字を区別しません。`*` は任意のホストに一致し、`*.example.com` は `example.com` とその任意のサブドメインに一致します。それ以外は完全一致です。チェックは `ssh -G` による `~/.ssh/config` の解決後のホスト名に対して行われるため、`Host` エイリアスは解決後の `HostName` が一致する限り許可されます。セッションの[ジャンプホスト](#allow-jump-hosts)も一致する必要があります。

`sshHostAllowlist` は管理設定からのみ読み取られます。ユーザーまたはプロジェクト設定の値は無視されます。Claude Desktop アプリのみがこの設定を尊重します。Claude Code CLI と IDE 拡張機能はこれを読み取らず、Bash ツールを通じて実行される `ssh` コマンドを制限しません。これは Desktop アプリが接続するホストを管理し、ネットワーク出力ではないため、ハード境界が必要な場合は組織のネットワークまたはゼロトラストコントロールと組み合わせてください。

##### ジャンプホストを許可する

Desktop がチェックする各ジャンプホストを、それ自体の解決後の `HostName` で `sshHostAllowlist` に追加してください。ユーザーが Claude Desktop v3.1623.0 以降に更新する前にジャンプホストを追加しておかないと、ユーザーはそれらを経由して接続できなくなります。

> [!WARNING]
>
> リストのエントリは 1 種類しかないため、ユーザーはリストに記載した任意のホストでセッションを開始することもできます。ユーザーにセッションの実行も許可してよいジャンプホストのみを記載してください。

Desktop は、ユーザーの `~/.ssh/config` がセッションのホストに設定している `ProxyJump`、または `ssh -W %h:%p <host>` の形式で記述された `ProxyCommand` 内のジャンプホストをチェックします。Desktop がセッションを接続または再接続する際に、チェック対象のジャンプホストがリストにない場合、接続は失敗します。ユーザーがセッションを開始したりメッセージを送信したりすると、エラーの詳細にそのジャンプホストの `HostName` が表示されます。これが追加すべき名前です。

```text theme={null}
SSH host "bastion.example.com" is not allowed by your organization's managed settings. It is a jump host on the way to "devbox".
```

メッセージに `managed settings on this computer` と表示される場合は、ユーザーのコンピューター上のリストにその名前を追加してください。複数のジャンプホストが不足している場合、エラーは 1 つずつ名前を示します。ユーザーが更新する前にすべての名前を見つけるには、ユーザーのコンピューターでターミナルを使用します。

**1. 経路を確認する**

ユーザーが接続するホストを指定して `ssh -G` を実行します（例: `ssh -G devbox`）。`proxyjump` 行、または `ssh -W %h:%p <host>` の形式で記述された `proxycommand` 行を探します。コマンドに `-l`、`-p`、`-J`、`-q`、`-v`、`-N`、`-T`、`-x`、`-a` のいずれかが含まれていても対象となり、`-J` の後のホストもジャンプホストです。`proxycommand` 行が `ssh` 以外のプログラムを実行している場合、その行については何も追加しません。

**2. 各ジャンプホストを調べる**

その行にある各ジャンプホストを指定して、`:port` を付けずに `ssh -G` を実行し、出力される `hostname` を控えます。その行の最初のジャンプホストの出力にいずれかの種類の行がある場合は、それについてこの手順を繰り返します。2 番目以降のジャンプホストの出力にあるそのような行は無視してください。

**3. 名前を追加する**

各ホスト名、またはそれをカバーするワイルドカードを、リストを設定しているすべての管理ソースの `sshHostAllowlist` に追加します。Desktop は起動時にサーバー管理設定を取得するため、その後ユーザーに Desktop を終了して再度開いてもらいます。

#### ローカルセッションをオフにして SSH 接続を配布する

ローカルセッションをオフにし、SSH セッションを選択したホストに制限するには、[`disableDesktopLocalSessions`](https://code.claude.com/docs/ja/settings-reference#disabledesktoplocalsessions)、[`sshConfigs`](#pre-configure-ssh-connections-for-your-team)、[`sshHostAllowlist`](#restrict-which-ssh-hosts-users-can-connect-to) を一緒にデプロイします。

> [!NOTE]
>
> この構成は、Claude アカウントでサインインするユーザー向けです。[サードパーティプロバイダー](https://code.claude.com/docs/ja/third-party-integrations.md)を使用する場合、SSH セッションはデフォルトでオフになっており、`sshHostAllowlist` を設定するとオンにできます。これらのキーをデプロイする前に、[SSH remote sessions in Claude Desktop on 3P](https://claude.com/docs/third-party/claude-desktop/ssh-remote-sessions) をお読みください。

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

* **ホスト名**: `sshHostAllowlist` のパターンが、`user@` を除いた各 `sshConfigs` エントリのホスト名に一致していることを確認してください。一致していないと、開発者はそのホストに接続できません。また、そこに至る途中で Desktop がチェックする各[ジャンプホスト](#allow-jump-hosts)に一致するパターンも追加してください。Desktop がホスト名を照合する方法については、[ユーザーが接続できる SSH ホストを制限する](#restrict-which-ssh-hosts-users-can-connect-to)を参照してください。
* **バージョン**：`disableDesktopLocalSessions` には Claude Desktop v1.37937.0 以降が必要です
* **ファイルの権限**：コンピューター上の各開発者のアカウントが管理設定ファイルを読み取れることを確認してください。アカウントが読み取れないファイル内のキーは Desktop によって適用されず、Claude Code も[それらのキーなしで起動します](https://code.claude.com/docs/ja/managed-settings.md#find-entries-claude-code-dropped)。

3 つのキーは、配信する[管理ソース](https://code.claude.com/docs/ja/managed-settings.md#how-claude-code-combines-managed-sources)のうち最上位のもの 1 つにまとめて記述してください。[サーバー管理設定](https://code.claude.com/docs/ja/server-managed-settings.md)を配信する場合は、各コンピューターの最上位の MDM ポリシーまたは管理設定ファイルにも 3 つのキーのコピーを保持してください。Desktop は起動時にサーバー管理設定を取得し、取得が成功するまではコンピューター上のコピーが適用されます。

設定が適用されていることを確認するには、開発者のコンピューターで次を確認します：

**1. 環境セレクターを確認する**

Desktop を終了して再度開き、[環境セレクター](#start-a-session)を開きます。次のように表示されていれば、設定は適用されています。

* そのコンピューターのエントリがグレー表示されている
* **SSH** の下に **Shared Dev VM** がある。そこに表示されていない場合は、単一の **SSH** 行、またはグループ末尾の **More** をクリックしてください。

コンピューターのエントリがまだ選択可能な場合は、次の原因を確認してください。

* **Desktop のバージョン**：v1.37937.0 より前の場合は Desktop を更新してください。
* **管理設定ファイル**：ファイルが有効な JSON であることを確認してください。
* **管理ソース**：キーを保持している[管理ソース](https://code.claude.com/docs/ja/managed-settings.md#how-claude-code-combines-managed-sources)をコンピューターが読み取っていることを確認してください。

**2. 許可リストにないホストを追加する**

`other.example.com` など、許可リストにないホスト名で [SSH 接続を追加](#ssh-sessions)します。Desktop は接続を保存しますが、接続は拒否し、組織の設定でその接続が許可されていないことを表示します。

## エンタープライズ設定

Team または Enterprise プランの組織は、管理コンソールコントロール、管理設定ファイル、およびデバイス管理ポリシーを通じてデスクトップアプリの動作を管理できます。

### 管理コンソールコントロール

これらの設定は[管理設定コンソール](https://claude.ai/admin-settings/claude-code)を通じて設定されます：

* **Desktop**：組織内のユーザーがデスクトップアプリで Claude Code にアクセスできるかどうかを制御します
* **Cloud sessions**：組織の[クラウドセッション](https://code.claude.com/docs/ja/claude-code-on-the-web.md)を有効または無効にします
* **Remote Control**：組織の[Remote Control](https://code.claude.com/docs/ja/remote-control.md)を有効または無効にします

HIPAA が有効になっている Enterprise 組織では、**Desktop** トグルはデフォルトでオフになっており、[Owner](https://code.claude.com/docs/ja/server-managed-settings.md#access-control) がオンにできます。[HIPAA 設定](https://code.claude.com/docs/ja/hipaa-setup.md)を適用すると、オンになっていた場合でもオフになるため、Owner は適用後にオンにし直す必要があります。**Cloud sessions** と **Remote Control** もデフォルトでオフであり、組織に HIPAA 設定が適用された後は、Owner がこれらをオンにすることはできません。

> [!NOTE]
>
> 管理コンソールの[データとプライバシー設定](https://claude.ai/admin-settings/data-privacy-controls)の**Monitoring**下の Cowork 用 OpenTelemetry フォームは、Cowork セッションのみに適用されます。このマシン上の Cowork セッションでは、デスクトップアプリはそのコレクタを Claude Code に`OTEL_*`環境変数として渡すため、Claude Code がそのセッションで[管理コンソール設定をフェッチしない](#managed-settings)場合でも、フォームは有効になります。
>
> Code タブセッションからテレメトリをエクスポートするには、Claude Code 管理設定の`env`ブロックで`CLAUDE_CODE_ENABLE_TELEMETRY`と`OTEL_*`変数を設定します。[監視用の管理者設定](https://code.claude.com/docs/ja/monitoring-usage.md#administrator-configuration)に示されているとおりです。ローカル、クラウド、SSH セッションは、それぞれ[異なるソースから管理設定を読み取ります](#managed-settings)。クラウドセッションが到達できるホストについては、[ネットワークアクセス](https://code.claude.com/docs/ja/cloud-environments.md#network-access)を参照してください。Code タブセッションが報告する`service.name`については、[サービス情報](https://code.claude.com/docs/ja/monitoring-usage.md#service-information)を参照してください。
>
> SSH セッションがどのリモートマシンで実行されたかを確認するには、[テレメトリを Desktop SSH セッションに関連付ける](https://code.claude.com/docs/ja/monitoring-usage.md#attribute-telemetry-to-desktop-ssh-sessions)を参照してください。

### 管理設定

管理設定はプロジェクトおよびユーザー設定を上書きし、Desktop の Claude Code セッションに適用されます。これらのキーを組織の[管理設定](https://code.claude.com/docs/ja/managed-settings.md)ファイルで設定するか、管理コンソールを通じてリモートでプッシュできます。ただし、キーの行に別の記載がある場合を除きます。

| キー | 説明 |
| - | - |
| `permissions.disableBypassPermissionsMode` | ユーザーが Bypass permissions モードを有効にするのを防ぐには`"disable"`に設定します。 |
| `disableAutoMode` | [Auto](https://code.claude.com/docs/ja/permission-modes.md#eliminate-prompts-with-auto-mode)モードをモードセレクタから削除するには`"disable"`に設定します。`permissions`の下でも受け入れられます。 |
| `autoMode` | 組織全体で auto モード分類器が信頼およびブロックするものをカスタマイズします。[auto モードを設定する](https://code.claude.com/docs/ja/auto-mode-config.md)を参照してください。 |
| `browserExternalPageTools` | Claude が[Browser ペイン](#browse-external-sites)の外部ページを読み取るまたは操作するためのツールを使用するのを防ぐには`"disabled"`に設定します。ユーザーは引き続き外部サイトに自分でナビゲートできます。ローカル開発サーバープレビューは影響を受けません。 |
| `disableMobileSimulatorTools` | Claude の[iOS Simulator ペイン](https://code.claude.com/docs/ja/desktop-ios-simulator.md#turn-off-simulator-access)でデバイスを制御およびキャプチャするためのツールをブロックするには`true`に設定します。ペインはユーザー自身のタップに対して使用可能なままです。Claude のアクセスのみが削除されます。値は JSON ブール値`true`である必要があります。文字列`"true"`は無視されます。 |
| `disableBrowserExternalNavigation` | [Browser ペイン](#browse-external-sites)の外部ブラウジングを完全にオフにするには`true`に設定します。ユーザーも Claude も外部サイトにナビゲートできません。localhost 開発サーバープレビューは影響を受けません。値は JSON ブール値`true`である必要があります。文字列`"true"`は無視されます。 |
| `sshConfigs` | 環境セレクタに表示される[SSH 接続](#pre-configure-ssh-connections-for-your-team)を事前設定します。ユーザーは管理接続を削除できず、自分の **Worktree folder** 以外は編集できません。 |
| `sshHostCommands` | ユーザー自身の接続に加えて、[ホストがコマンドから取得される SSH 接続](#distribute-commands-to-your-team)をユーザーに提供します。Desktop はこれをコンピューター上の管理設定ファイルまたは MDM ポリシーから読み取り、[サーバー管理設定](https://code.claude.com/docs/ja/server-managed-settings.md)では無視します。macOS または Linux 上の Claude Desktop v3.6556.0 以降で、Claude アカウントでサインインしている必要があります。 |
| `sshHostAllowlist` | [SSH セッション](#restrict-which-ssh-hosts-users-can-connect-to)を、解決されたホスト名がこれらのパターンのいずれかと一致するホストに制限します。管理設定からのみ読み取られます。 |
| `disableDesktopLocalSessions` | [デバイスで実行されるコードセッション](#local-sessions-on-managed-devices)をオフにするには`true`に設定します。他のホストへの SSH セッションとクラウドセッションは利用可能なままです。値は JSON ブール値`true`である必要があります。管理設定からのみ読み取られます。Claude Desktop v1.37937.0 以降が必要です。 |
| `disableSshSavedPasswords` | Desktop が SSH パスワードの保存を提案したり、以前に保存したパスワードを使用または表示したりしないようにするには`true`に設定します。オンにしても、保存済みのパスワードは削除されません。管理設定からのみ読み取られます。Claude Desktop v1.49585.0 以降が必要です。 |
| `managedMcpServers` | MCP サーバー設定をすべてのユーザーにプッシュします。サードパーティ（3P）Desktop デプロイでのみ利用可能です。各エントリで、`"http"`、`"sse"`、または`"stdio"`のトランスポート、接続詳細、およびオプションで、そのサーバーのどのツールをユーザーが呼び出せるかを制限する`toolPolicy`マップを設定します。管理設定ファイル、MDM、または Claude apps gateway ポリシーの[`desktop`ブロック](https://code.claude.com/docs/ja/claude-apps-gateway-config#claude-desktop-overlay)を通じて配信します。3P デプロイは管理コンソール設定を受け取らないためです。ゲートウェイを通じて配信するには、ゲートウェイサーバーで Claude Code v2.1.232 以降が必要です。これはデスクトップアプリ自体のキーです。Claude Code は、異なるエントリ形状を持つ、同じ名前の[管理設定](https://code.claude.com/docs/ja/managed-mcp.md#provide-servers-through-managed-settings)を読み取ります。 |

Desktop セッションがどこで実行されるかに応じて、どの管理設定がそのセッションに到達するかが異なります。[`availableModels`](https://code.claude.com/docs/ja/model-config#restrict-model-selection)などのモデル制限は、Desktop の Claude Code セッションでターミナル CLI と同じ方法で適用されます。[surface coverage](https://code.claude.com/docs/ja/model-config.md#surface-coverage)を参照してください。

* **このマシン上のローカルセッション**：ディスクにデプロイされた管理設定ファイルが適用されます。管理コンソールを通じてリモートでプッシュされた管理設定は、セッションが[適格なログイン](https://code.claude.com/docs/ja/server-managed-settings.md#platform-availability)で認証する場合、Anthropic の API でこれらのセッションに到達します。ターミナル CLI と同じ[設定の優先順位](https://code.claude.com/docs/ja/settings.md#settings-precedence)に従います。
* **[クラウドセッション](#cloud-sessions)**：[サーバー管理設定](https://code.claude.com/docs/ja/server-managed-settings.md)を受け取ります。デバイスにデプロイされたファイルはこれらのセッションに到達しません。Anthropic が管理する VM で実行されるためです。[自己ホスト環境](https://code.claude.com/docs/ja/self-hosted-environments)にルーティングされたセッションは、ランナーイメージ内の管理設定ファイルも読み取ります。[Claude Code が管理ソースを組み合わせる方法](https://code.claude.com/docs/ja/managed-settings.md#how-claude-code-combines-managed-sources)は、そのファイルが適用される場合を示しています。
* **[SSH セッション](#ssh-sessions)**：セッションはリモートホストから管理設定ファイルを読み取ります。Desktop 自体は、ローカルマシン上で`sshConfigs`、`sshHostAllowlist`、`disableSshSavedPasswords`、および`disableDesktopLocalSessions`を読み取ります。複数の管理ソースを配信する場合、Desktop は[デフォルトではそのうち 1 つから](https://code.claude.com/docs/ja/managed-settings.md#how-claude-code-combines-managed-sources)これらを読み取ります。
* **[Cowork](https://claude.com/docs/cowork/overview)セッション**：このマシン上の Cowork セッションでは、ユーザーが Team または Enterprise アカウントでサインインしている場合でも、Claude Code は管理コンソール設定をフェッチしません。マシンにデプロイされたポリシーを読み取ります。ただし、Claude Desktop 設定が`requireCoworkFullVmSandbox`を設定している場合を除きます。リモート Cowork セッションはどちらも受け取りません。[ポリシーが適用される場所と時期](https://code.claude.com/docs/ja/managed-settings.md#where-and-when-a-policy-applies)を参照して、どのデバイスファイルが Cowork に到達するかを確認してください。[MCP 権限ルール](https://code.claude.com/docs/ja/permissions.md#mcp)を参照して、`Bash`および`WebFetch`ルールが Cowork のツールにどのように適用されるかを確認してください。

ローカルおよび SSH セッションでは、デスクトップアプリは各ユーザーの接続された claude.ai コネクタを Claude Code に直接配信します。MCP 設定または`managed-mcp.json`はこれらのコネクタに到達しません。使用する設定ソースまたはファイルの場所に関係なく。これらのセッションでコネクタのツールをブロックするには、組織の[コネクタツールコントロール](https://code.claude.com/docs/ja/mcp.md#organization-controls-on-connector-tools)を使用してください。[コネクタが Claude Code に到達する方法](https://code.claude.com/docs/ja/mcp.md#how-connectors-reach-claude-code)は、各種類のセッションでコネクタを管理する設定を示しています。

`permissions.disableBypassPermissionsMode`と`disableAutoMode`はユーザーおよびプロジェクト設定でも機能しますが、管理設定に配置するとユーザーがそれらを上書きするのを防ぎます。

管理ソースのみが設定できる権限、プラグイン、および配信キーについては、[管理設定のみが設定できるキー](https://code.claude.com/docs/ja/managed-settings.md#managed-only-settings)を参照してください。

### デバイス管理ポリシー

IT チームは、macOS の MDM、Windows のグループポリシー、または Linux のポリシーファイルを通じてデスクトップアプリを管理できます。利用可能なポリシーには、Claude Code 機能の有効化または無効化、macOS と Windows での自動更新の制御、およびカスタムデプロイ URL の設定が含まれます。

* **macOS**：Jamf または Kandji などのツールを使用して`com.anthropic.claudefordesktop`プリファレンスドメインを通じて設定します
* **Windows**：`SOFTWARE\Policies\Claude`のレジストリを通じて設定します
* **Linux**：`/etc/claude-desktop/managed-settings.json`にある root 所有のファイルを通じて設定します。このファイルはポリシーキーを JSON オブジェクトとして保持します。root 以外のユーザーがファイルまたはそのフォルダに書き込める場合、Desktop はそのファイルを拒否します。これは Claude Code の[管理設定ファイル](https://code.claude.com/docs/ja/managed-settings.md)とは別のファイルです。

#### 組織へのサインインを制限する

Claude Desktop にサインインできる claude.ai 組織を制限するには、Claude Desktop ポリシーで`forceLoginOrgUUID`を設定します。

このキーには Claude Desktop v1.2581.0 以降が必要です。

Linux では、このキーのみを設定するポリシーファイルは次のようになります：

```json /etc/claude-desktop/managed-settings.json theme={null}
{
  "forceLoginOrgUUID": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
}
```

プレースホルダーを、[claude.ai 管理設定](https://claude.ai/admin-settings/organization)に表示される claude.ai 組織 ID に置き換えてください。これは Claude Code の[`forceLoginOrgUUID`](https://code.claude.com/docs/ja/settings-reference#forceloginorguuid)設定が受け取るものと同じ ID です。このキーを設定する macOS および Windows のサンプルについては、HIPAA 対応組織向け Cowork ガイドの[Deploy the Claude Desktop policy](https://claude.com/docs/cowork/hipaa-setup#deploy-the-claude-desktop-policy)を参照してください。

> [!WARNING]
>
> デプロイする前に`forceLoginOrgUUID`の値を確認してください。ID が自組織のものでない場合、組織のメンバーは、その ID を持つ組織にも所属していない限り Claude Desktop を使用できません。復旧するには、正しい ID をデプロイし、メンバーに Claude Desktop を再起動してもらってください。

Claude Code の[管理設定](https://code.claude.com/docs/ja/managed-settings.md)で`forceLoginMethod`と`forceLoginOrgUUID`を設定しても、Claude Desktop のサインイン画面は変わりません。

### ネットワークアクセス要件

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

トラフィックは HTTPS ポート 443 です。ただし、[OTLP](https://code.claude.com/docs/ja/monitoring-usage.md)、LLM ゲートウェイ、または MCP サーバーのカスタムポートを設定する場合を除きます。

プロキシサーバー、カスタム認証局、mTLS、およびスタンドアロン CLI が必要とするドメインについては、[ネットワーク設定](https://code.claude.com/docs/ja/network-config.md)を参照してください。

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
sso.claude.com
*.livepreview.claude.app
*.claudeusercontent.com
*.claudemcpcontent.com
```

組織で Claude に対して[IP 許可リスト](https://support.claude.com/en/articles/13200993-restrict-access-to-claude-with-ip-allowlisting)が有効になっている場合は、`bridge.claudeusercontent.com`を`claude.ai`および`api.anthropic.com`と同じプロキシ出口を通じてルーティングしてください。そのようにルーティングできない場合は、プロキシがそのホストに使用する出口アドレスを組織の IP 許可リストに追加してください。ただし、そのアドレスが組織に専用されている場合のみです。共有プロキシ出口範囲は、プロキシベンダーの他の顧客も許可します。

Anthropic は、到着元のアドレスを使用して、組織の IP 許可リストに対してそのホストへの接続をチェックします。プロキシがそのホストのトラフィックを、その許可リストにないアドレスを通じて送信する場合、Chrome の Claude およびブリッジを通じて接続する他の機能は機能しなくなりますが、アプリの残りの部分は機能し続けます。

[アーティファクト](https://code.claude.com/docs/ja/artifacts.md)が[Google Fonts](https://code.claude.com/docs/ja/artifacts.md#improve-the-visual-design)からタイプフェイスを読み込む場合、`fonts.googleapis.com`および`fonts.gstatic.com`もリクエストします。両方のホストはオプションです。それらをブロックする場合、アーティファクトはフォールバックタイプフェイスでレンダリングされます。フォントリクエストが即座に失敗するように、高速拒否でブロックしてください。ページの最初のレンダリングを遅延させるのではなく。

アーティファクトは、React またはチャートパッケージなどの JavaScript ライブラリを`cdnjs.cloudflare.com`、`cdn.jsdelivr.net`、`cdn.tailwindcss.com`、`code.jquery.com`、および`unpkg.com`から読み込むこともできます。他の外部ホストからは読み込みません。それらのホストをブロックする場合、ライブラリに依存するアーティファクトの部分は機能しません。ブロックされたフォントとは異なり、ブロックされたライブラリにはフォールバックがありません。ここでも高速拒否でブロックしてください。ブロックされたライブラリリクエストが即座に失敗するように。タイムアウトするまでハングするのではなく。

### 認証と SSO

Team および Enterprise 組織はすべてのユーザーに SSO を要求できます。プランレベルの詳細については[認証](https://code.claude.com/docs/ja/authentication.md)を参照し、[Setting up SSO](https://support.claude.com/en/articles/13132885-setting-up-single-sign-on-sso)で SAML 設定を参照してください。OIDC セットアップは[Claude Enterprise Administrator Guide](https://claude.com/resources/tutorials/claude-enterprise-administrator-guide)で説明されています。

### データ処理

Claude Code はローカルセッションではコードをローカルで処理するか、クラウドセッションでは Anthropic が管理するインフラストラクチャで処理します。組織がそれらを[自己ホスト環境](https://code.claude.com/docs/ja/self-hosted-environments)にルーティングしない限り。クラウドセッション（自己ホスト環境を含む）は、処理のために会話とコードコンテキストを Anthropic の API に送信します。ローカルおよび SSH セッションは、デプロイで設定されている[モデルプロバイダー](#feature-comparison)（デフォルトでは Anthropic の API）に送信します。データ保持、プライバシー、およびコンプライアンスの詳細については、[データ処理](https://code.claude.com/docs/ja/data-usage.md)を参照してください。

### デプロイ

Desktop はエンタープライズデプロイツールを通じて配布できます：

* **macOS**：Jamf または Kandji などの MDM を使用して`.dmg`インストーラーを通じて配布します
* **Windows**：MSIX パッケージを通じてデプロイします。サイレントインストールを含むエンタープライズデプロイのオプションについては、[Deploy Claude Desktop for Windows](https://support.claude.com/en/articles/12622703-deploy-claude-desktop-for-windows)を参照してください。

ファイアウォールで許可リストに登録するドメインについては、上記の[ネットワークアクセス要件](#network-access-requirements)を参照してください。プロキシ設定、カスタム認証局、および LLM ゲートウェイについては、[ネットワーク設定](https://code.claude.com/docs/ja/network-config.md)を参照してください。

完全なエンタープライズ設定リファレンスについては、[エンタープライズ設定ガイド](https://support.claude.com/en/articles/12622667-enterprise-configuration)を参照してください。

## CLI から移行する場合

Claude Code CLI を既に使用している場合、Desktop はグラフィカルインターフェイスで同じ基盤となるエンジンを実行します。同じマシン上で、同じプロジェクト上でも、両方を同時に実行できます。各々は独自のセッションリストを保持し、CLI セッションを Desktop に持ち込むことができます。CLAUDE.md ファイルを通じて設定とプロジェクトメモリを共有します。

CLI セッションを Desktop に移動するには、ターミナルで `/desktop` を実行します。Claude はセッションを保存し、デスクトップアプリで開いてから CLI を終了します。このコマンドは、Claude サブスクリプションでサインインしている場合、macOS と x64 Windows で利用可能です。API キー認証、Amazon Bedrock、Google Cloud の Agent Platform、または Microsoft Foundry では利用できません。

シェルから、[`claude --desktop`](https://code.claude.com/docs/ja/cli-reference#cli-flags) は Desktop を直接開き、ターミナルセッションを開始しません。Claude Code v2.1.285 以降が必要で、`/desktop` と同じプラットフォームおよびサインイン要件があります。他の引数がない場合、現在のディレクトリで Desktop を開きます。既存の CLI セッションを Desktop で開くには、このディレクトリの最新の会話に対して `--continue` を追加するか、`/status` が表示するセッション ID で `--resume` を追加します：

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

> [!TIP]
>
> Desktop と CLI をいつ使用するか：複数のセッションを 1 つのウィンドウで管理したい場合、ペインを並べて配置したい場合、または変更を視覚的に確認したい場合は Desktop を使用します。スクリプト、自動化が必要な場合、またはターミナルワークフローを好む場合は CLI を使用します。

### CLI フラグの同等物

このテーブルは、一般的な CLI フラグの Desktop アプリの同等物を示しています。リストされていないフラグは、スクリプトまたは自動化用に設計されているため、Desktop の同等物がありません。

| CLI | Desktop の同等物 |
| - | - |
| `--model sonnet` | プロンプトボックスの下の行にあるモデルピッカー |
| `--resume`、`--continue` | サイドバーのセッションをクリックするか、プロンプトボックスで `/resume` と入力して CLI から開始したセッションを選択します |
| `--permission-mode` | プロンプトボックスの下の行にあるモードセレクタ |
| `--dangerously-skip-permissions` | 権限モードをバイパスします。Pro、Max、および Ultra プランでは、**設定 > Code** または **設定 > Claude Code** で「権限モードのバイパスを許可」を有効にします。Team および Enterprise プランでは、組織ポリシーで制御されます |
| `--add-dir` | ローカルセッションと SSH セッションでは[セッションにフォルダを追加](#add-folders-to-a-session)し、クラウドセッションでは[複数のリポジトリ](#run-long-running-tasks-in-the-cloud)を選択します |
| `--allowedTools`、`--disallowedTools` | セッションごとの同等物はありません。[設定ファイル](https://code.claude.com/docs/ja/settings.md)の権限ルールは引き続き適用されます。 |
| `--verbose` | [詳細ビューモード](#switch-view-modes) |
| `--print`、`--output-format` | 利用できません。Desktop は対話的のみです。 |
| `ANTHROPIC_MODEL` 環境変数 | プロンプトボックスの下の行にあるモデルピッカー |
| `MAX_THINKING_TOKENS` 環境変数 | [拡張思考をオフにする](#turn-off-extended-thinking)を参照してください |

### 共有設定

Desktop と CLI は同じ設定ファイルを読み込むため、セットアップが引き継がれます：

* プロジェクト内の **[CLAUDE.md](https://code.claude.com/docs/ja/memory.md)** および `CLAUDE.local.md` ファイルは両方で使用されます
* `~/.claude.json` または `.mcp.json` で設定された **[MCP サーバー](https://code.claude.com/docs/ja/mcp.md)** は両方で機能します
* 設定で定義された **[フック](https://code.claude.com/docs/ja/hooks.md)** および **[スキル](https://code.claude.com/docs/ja/skills.md)** は両方に適用されます
* `~/.claude.json` および `~/.claude/settings.json` の **[設定](https://code.claude.com/docs/ja/settings.md)** は共有されます。`settings.json` の権限ルール、許可されたツール、およびその他の設定は Desktop セッションに適用されます。
* **モデル**：同じ[モデル](https://code.claude.com/docs/ja/model-config.md#available-models)が両方で利用可能です。Desktop では、プロンプトボックスの下の行にあるモデルピッカーからモデルを選択します。セッション中にも同じピッカーからモデルを変更できます。

#### Claude Desktop チャットアプリからの MCP サーバー

Desktop アプリは、`claude_desktop_config.json` から MCP サーバーをローカルコードタブセッションに読み込み、`~/.claude.json` および `.mcp.json` のサーバーと並行して実行します。`claude_desktop_config.json` で定義したサーバーは、Desktop チャットサーフェイスとローカルコードタブセッションの両方で利用可能です。

`claude_desktop_config.json` と `~/.claude.json` または `.mcp.json` で同じサーバー名を定義した場合、ローカルセッションのコードタブは 1 回接続し、`claude_desktop_config.json` の定義を使用します。

アプリは、`~/.claude.json` の stdio サーバーをローカルセッションの組み込み CLI に再配信します。`~/.claude.json`（ユーザースコープ）と `.mcp.json` のトップレベルが同じ stdio サーバー名を定義する場合、コードタブは `~/.claude.json` の定義を使用し、CLI の[スコープ階層](https://code.claude.com/docs/ja/mcp.md#scope-hierarchy-and-precedence)から外れます。

> [!NOTE]
>
> スタンドアロン CLI は `claude_desktop_config.json` を読み込みません。macOS と WSL では、`claude mcp add-from-claude-desktop` を実行して、それらのサーバーを `~/.claude.json` にコピーします。[Claude Desktop から MCP サーバーをインポート](https://code.claude.com/docs/ja/mcp.md#import-mcp-servers-from-claude-desktop)を参照して、インポートフローとスコープオプションを確認してください。

### 機能比較

このテーブルは、CLI と Desktop の主要機能を比較しています。CLI フラグの完全なリストについては、[CLI リファレンス](https://code.claude.com/docs/ja/cli-reference.md)を参照してください。

| 機能 | CLI | Desktop |
| - | - | - |
| 権限モード | `dontAsk` を含むすべてのモード | Manual、Accept edits、Plan、および Auto。権限モードのバイパスは、有効にされるとモードセレクタに表示されます：Pro、Max、および Ultra プランでは設定トグルを通じて、Team および Enterprise プランでは組織ポリシーを通じて |
| [サードパーティプロバイダー](https://code.claude.com/docs/ja/third-party-integrations.md) | Amazon Bedrock、Google Cloud の Agent Platform、Microsoft Foundry | デフォルトで Anthropic の API。ゲートウェイルーティングについては、[Desktop アプリをゲートウェイに接続](https://code.claude.com/docs/ja/llm-gateway-connect.md#desktop-app)を参照してください。Code タブを Amazon Bedrock、Google Cloud の Agent Platform、Microsoft Foundry、または自己ホスト型 LLM ゲートウェイで実行するには、[Claude Desktop on 3P](https://claude.com/docs/third-party/claude-desktop/overview)を参照してください。 |
| [MCP サーバー](https://code.claude.com/docs/ja/mcp.md) | 設定ファイルで設定 | ローカルおよび SSH セッションのコネクタ UI、または設定ファイル |
| [プラグイン](https://code.claude.com/docs/ja/plugins/overview.md) | `/plugin` コマンド | プラグインマネージャー UI |
| @mention ファイル | テキストベース | オートコンプリート付き（クラウドセッションの最初のメッセージを除く） |
| ファイル添付 | 利用できません | 画像、PDF |
| セッション分離 | [`--worktree`](https://code.claude.com/docs/ja/cli-reference) フラグ | [独自の worktree でセッションを実行](#run-a-session-in-its-own-worktree) |
| 複数セッション | 別々のターミナル | サイドバータブ |
| 定期的なタスク | Cron ジョブ、CI パイプライン | [スケジュールタスク](https://code.claude.com/docs/ja/desktop-scheduled-tasks.md) |
| コンピューター使用 | macOS で [`/mcp`](https://code.claude.com/docs/ja/computer-use) で有効化 | macOS および Windows で[アプリとスクリーン制御](#let-claude-use-your-computer) |
| iOS シミュレータ | [コンピューター使用](https://code.claude.com/docs/ja/computer-use.md#test-a-simulator-flow)経由でシミュレータを駆動 | [iOS シミュレータペイン](https://code.claude.com/docs/ja/desktop-ios-simulator.md)が自動的に開きます |
| Dispatch 統合 | 利用できません | サイドバーの [Dispatch セッション](#sessions-from-dispatch) |
| スクリプトと自動化 | [`--print`](https://code.claude.com/docs/ja/cli-reference)、[Agent SDK](https://code.claude.com/docs/ja/headless.md) | 利用できません |

### Desktop で利用できない機能

以下の機能は Desktop では利用できません（記載されている場合を除く）：

* **サードパーティプロバイダー**：Desktop はデフォルトで Anthropic の API に接続します。Desktop をゲートウェイ経由でルーティングするか、Code タブを Amazon Bedrock、Google Cloud の Agent Platform、Microsoft Foundry、または自己ホスト型 LLM ゲートウェイで実行するには、[サードパーティプロバイダー行](#feature-comparison)のリンクに従ってください。
* **Linux（ベータ）**：Linux デスクトップアプリではコンピューター使用はまだ利用できません。[Claude Desktop on Linux](https://code.claude.com/docs/ja/desktop-linux.md)を参照してください。
* **インラインコード提案**：Desktop はオートコンプリートスタイルのコード補完を提供しません。会話型プロンプトと明示的なコード変更を通じて機能し、Claude の応答後に[次のプロンプトを提案](#accept-a-suggested-prompt)できます。
* **エージェントチーム**：Claude がチームリーダーとして共有タスクリストからチームメイトにタスクを割り当てる調整されたチームは、[CLI](https://code.claude.com/docs/ja/agent-teams.md)で利用可能で、Desktop では利用できません。1 つのセッション内でマルチエージェント作業を行う場合は、Desktop で実行される[動的ワークフロー](https://code.claude.com/docs/ja/workflows.md)を使用します。Claude は[他のセッションに直接メッセージを送信して管理](#work-across-sessions)することもできます。
* **ターミナルダイアログコマンド**：ターミナルで対話的パネルを開く組み込みコマンドは、コードタブで異なる動作をします。[設定ファイル](https://code.claude.com/docs/ja/settings.md)を直接編集して権限ルールと設定を管理するか、スタンドアロン CLI からコマンドを実行します。
  * `/permissions` などの引数形式がないコマンドは、`isn't available in this environment` で応答します。
  * `/config` は **設定 > Code** または **設定 > Claude Code** を開きます。

## トラブルシューティング

以下のセクションでは、デスクトップアプリに固有の問題について説明します。チャットに表示される`API Error: 500`、`529 Overloaded`、`429`、または`Prompt is too long`などのランタイム API エラーについては、[エラーリファレンス](https://code.claude.com/docs/ja/errors.md)を参照してください。

### バージョンを確認する

実行しているデスクトップアプリのバージョンを確認するには：

* **macOS**：メニューバーの**Claude**をクリックしてから、**About Claude**をクリック
* **Windows**：**Help**をクリックしてから、**About Claude**をクリック

バージョン番号をクリックしてクリップボードにコピーします。

#### Code タブの Claude Code バージョン

セッションで実行されている Claude Code のバージョンを確認するには、**Code** タブのローカルセッションで `/status` と入力し、**Claude Code** 行を確認します。この行には `2.1.286` のようなバージョンが表示されます。

ローカルセッション用に新しいバージョンを取得するには、macOS では **Claude > Check for Updates…**、Windows では **Help > Check for Updates…** を開き、新しいセッションを開始します。

ローカルセッションでは、**Code** タブは独自の Claude Code のコピーを実行し、そのコピーには独自のバージョン番号があります。デスクトップアプリがそのコピーをダウンロードして更新するため、ターミナルの `claude` コマンドとはバージョンが異なる場合があり、一方を更新してももう一方は更新されません。

### 使用しているレイアウトを確認する

新しいセッションで[環境](#start-a-session)がプロンプトボックスの下ではなく上に表示される場合は、以前のレイアウトを使用しています：

* **[v2.37337.0 より前の Desktop](#check-your-version)**：更新すると現在のレイアウトになります。macOS では **Claude > Check for Updates…**、Windows では **Help > Check for Updates…** を選択します。
* **[サードパーティプロバイダー](https://code.claude.com/docs/ja/third-party-integrations.md)でセッションをコンピューター上で実行している場合**：現在のレイアウトには Claude Desktop v3.1623.0 以降が必要なため、[バージョンを確認](#check-your-version)してください。更新するには、macOS では **Claude > Check for Updates…**、Windows では **Help > Check for Updates…** を選択します。組織が[自動更新をオフにしている](#device-management-policies)場合、**Check for Updates…** は非表示になるため、管理者に v3.1623.0 以降を依頼してください。
* **サードパーティプロバイダーでセッションを組織のインフラストラクチャ上で実行している場合**：現在のレイアウトには Claude Desktop v4.29.0 以降が必要なため、[バージョンを確認](#check-your-version)してください。それより古いバージョンを使用している場合は、管理者に v4.29.0 以降を依頼してください。セッションがどこで実行されているかわからない場合は、管理者に確認してください。

以前のレイアウトでは、プロンプトボックスの上で環境と、必要に応じてプロジェクトフォルダまたはリポジトリを選択し、その下の行で権限モードとモデルを選択します。以前のレイアウトには[セッション詳細パネル](#see-session-details)と[保存済みのローカル環境および SSH 環境](#create-a-saved-environment)がありません。

### Code タブの 403 またはエラー認証エラー

Code タブを使用するときに`Error 403: Forbidden`またはその他の認証エラーが表示される場合：

1. アプリメニューからサインアウトして再度サインインします。これが最も一般的な修正です。
2. アクティブな有料サブスクリプション（Pro、Max、Ultra、Team、または Enterprise）があることを確認します。
3. CLI は機能するが Desktop は機能しない場合、デスクトップアプリを完全に終了し（ウィンドウを閉じるだけではなく）、再度開いてサインインします。
4. インターネット接続とプロキシ設定を確認します。

### 起動時に空白または停止画面

アプリが開いても空白または応答しない画面が表示される場合：

1. アプリを再起動します。
2. 保留中の更新を確認します。macOS と Windows ではアプリは起動時に自動更新されます。Linux では、[Claude Desktop on Linux](https://code.claude.com/docs/ja/desktop-linux.md)で説明されているように apt を使用して更新します。
3. マネージドネットワーク上では、ファイアウォールが[ネットワークアクセス要件](#network-access-requirements)の CDN ホストを許可していることを確認します。
4. Windows では、**Windows Logs → Application**の Event Viewer でクラッシュログを確認します。

### 「Failed to load session」

`Failed to load session`が表示される場合、選択したフォルダが存在しなくなった可能性があります。Git リポジトリがインストールされていない Git LFS を必要とする可能性があります。またはファイル権限がアクセスを防ぐ可能性があります。別のフォルダを選択するか、アプリを再起動してみてください。

### セッションがインストール済みツールを見つけられない

Claude が`npm`、`node`、またはその他の CLI コマンドなどのツールを見つけられない場合、ツールが通常のターミナルで機能することを確認し、シェルプロファイルが PATH を正しく設定していることを確認し、デスクトップアプリを再起動して環境変数を再度読み込みます。

### Git および Git LFS エラー

独自の worktree で実行されるセッションには Git が必要です。「Git is required」が表示される場合、[Git](https://git-scm.com/downloads)をインストールするか、Windows では[Git for Windows](https://git-scm.com/downloads/win)をインストールして、もう一度試してください。Windows では、1.49585.0 より前の Claude Desktop バージョンはローカルセッションを開始する前に Git を要求していました。そのプロンプトが表示され、worktrees を使用していない場合は、アプリを更新してください。

「Git LFS is required by this repository but is not installed」が表示される場合、[git-lfs.com](https://git-lfs.com/)から Git LFS をインストールし、`git lfs install`を実行してアプリを再起動します。

### Windows で MCP サーバーが機能しない

MCP サーバートグルが応答しない場合、または Windows でサーバーが接続に失敗する場合、サーバーが設定で正しく設定されていることを確認し、アプリを再起動し、Task Manager でサーバープロセスが実行されていることを確認し、接続エラーについてサーバーログを確認します。

### SSH host key verification failed

以下のいずれかのメッセージは、Desktop が[ホストキー](#check-a-remote-machines-host-key)を拒否したことを意味します：

* `Couldn't connect to <host>` カードの **View details** に表示される `SSH host key verification failed` または `Host denied (verification failed)`
* プロンプトボックスの横、または **Test connection** の後に表示される `Connection failed: Host key changed or not trusted`
* 切断されたセッションに表示される `<host>'s host key is not trusted` または `<host>'s host key has changed`

Desktop がキーを拒否するのは通常、コンピューターに保存されているキーと異なる場合、またはそのマシンのキーが保存されていない場合です。再構築または再インストールされたマシンは通常新しいキーを提示し、接続を傍受するものも同様です。再度接続する前に、Desktop がメッセージとともに表示する内容を出発点としてキーを確認してください：

* **Windows を使用していて、Desktop に `Connection failed: Host key changed or not trusted` と表示される場合**：まず [OpenSSH クライアントがない](#ssh-host-key-refused-on-windows-without-an-openssh-client)可能性を除外します
* **Desktop が `UserKnownHostsFile` を設定するよう指示する場合**：`~/.ssh/config` でこれを `~/.ssh/known_hosts` に設定してから、[ターミナルからキーを確認](#check-the-host-key-from-a-terminal)します
* **Review new key ボタンが表示される場合**：それを選択し、Desktop が表示するフィンガープリントをそのマシン自体のフィンガープリントと[比較](#check-a-remote-machines-host-key)します。一致する場合は **Trust new key** を選択して保存済みのキーを置き換えます。一致しない場合は **Cancel** を選択します。
* **Review new key ボタンが表示されない、Desktop に `Couldn't show the new key` と表示される、または Trust new key の後も Desktop がキーを再び拒否する場合**：[ターミナルからキーを確認](#check-the-host-key-from-a-terminal)します

#### ターミナルからホストキーを確認する

Desktop の [SSH 接続](#ssh-sessions)の **SSH host** の値を使用して、コンピューター上で `ssh <SSH host>` を実行します。接続に **SSH port** の値がある場合は `-p <SSH port>` を追加します。Windows では PowerShell を使用してください。Desktop は Git Bash や WSL の `ssh` では接続しないためです。PowerShell で `ssh` が見つからない場合は、[Microsoft の OpenSSH クライアントをインストール](#ssh-host-key-refused-on-windows-without-an-openssh-client)します。

`ssh` がメッセージ内でどのマシンを示しているかを確認します（`<SSH host>` ではなくジャンプホストの場合もあります）。その後、該当するケースに従います：

* **`ssh` が接続を続行するかどうか尋ねる場合**：表示されるフィンガープリントをそのマシン自体のフィンガープリントと[比較](#check-a-remote-machines-host-key)します。一致する場合にのみ `yes` と答えます。
* **`ssh` がホストキーが変更されたと警告する場合**：警告のフィンガープリントをそのマシン自体のフィンガープリントと[比較](#check-a-remote-machines-host-key)します。一致する場合にのみ、`Offending <type> key in <file>:<line>` が示す行を削除して `ssh` を再実行します。`ssh` が別の行について再び警告する場合は、同様に比較、削除、再実行を行います。
* **`ssh` が尋ねることなく未知のキーを拒否する場合**：そのマシンの `known_hosts` 行を、確認対象の接続経由ではなく、そのマシンの管理者から入手します。`ssh` のメッセージに含まれる名前をホスト名としてその行を `known_hosts` ファイルに追加し、`ssh` を再実行します。
* **`ssh` がホストキーについて尋ねずにそのままサインインに進む場合**：まだパスワードを入力しないでください。[`ssh` がすでに信頼しているキーを確認](#check-the-keys-that-ssh-already-trusts)します。

確認または追加したキーを `ssh` が受け入れたら、Desktop で再試行します。Desktop が再びキーを拒否する場合は、[SSH の問題について Desktop のログを取得する](#get-desktops-logs-for-an-ssh-problem)を参照してください。

##### `ssh` がすでに信頼しているキーを確認する

同じ `ssh` コマンドに `-v -S none` を追加して再実行します。出力では、`Server host key:` 行にフィンガープリントが表示され、次の `Host '<name>' is known` 行にそのフィンガープリントが属するマシンが示されます。見つかった各フィンガープリントを、そのマシン自体のフィンガープリントと[比較](#check-a-remote-machines-host-key)します。

* **ジャンプホストに `Server host key:` 行がない場合**：`ssh -v -S none <jump host>` も実行し、そのフィンガープリントも同じ方法で比較します。
* **フィンガープリントが一致しない、または確認できない場合**：再度接続しないでください。保存されているキーを削除します。`Host '<name>' is known` の下にある `Found key in <file>:<line>` 行に、そのキーを保持するファイルが示されています。`ssh-keygen -R "<name>" -f <file>` を実行します。ホストキーを複数のファイルに保存している場合は、それぞれのファイルからキーを削除します。ファイルを変更できない場合は、コンピューターの管理者に伝えてください。
* **すべてのフィンガープリントが一致する場合**：Desktop で再試行します。Desktop が再びキーを拒否する場合は、[SSH の問題について Desktop のログを取得する](#get-desktops-logs-for-an-ssh-problem)を参照してください。

### OpenSSH クライアントがない Windows で SSH ホストキーが拒否される

OpenSSH クライアントがない Windows では、Desktop は正しいホストキーであっても `Connection failed: Host key changed or not trusted` と表示して拒否します。Desktop は保存済みのキーを検索するためにこのクライアントを必要とします。クライアントがあるかどうかを確認するには、PowerShell で `ssh` を実行します。PowerShell が `ssh` を認識しない場合は、[Microsoft の OpenSSH クライアント](https://learn.microsoft.com/windows-server/administration/openssh/openssh_install_firstuse)をインストールして Desktop を再起動します。

その後、再度接続します。Desktop が初回接続を行うかどうか尋ねてきた場合は、信頼する前に[マシンのホストキーを確認](#check-a-remote-machines-host-key)してください。それでも Desktop がキーを拒否する場合は、[SSH host key verification failed](#ssh-host-key-verification-failed) のその他のケースに従ってください。

### ログイン後に SSH 接続が失敗する

カードのタイトル、またはエラーメッセージの末尾にあるコードをこの表で探し、最後の列の指示に従ってください。メッセージを確認するには、失敗カードで **View details** を選択します。

| カードのタイトル | コード | 対処方法 |
| - | - | - |
| `<host>'s SSH server has SFTP turned off` | `[SFTP_UNAVAILABLE]` | [リモートマシンの要件](#remote-machine-requirements-for-ssh-sessions)で説明されているとおり、サーバーの `sshd_config` で SFTP をオンにします |
| `SFTP doesn't start on <host>` | `[SFTP_NOT_STARTED]` | コンピューターのターミナルで `sftp` を使用して同じホストに接続し、何が起動を妨げているかを確認してから、Desktop のメッセージに示されている設定とファイルを確認します |
| `<host> allows too few SSH sessions per connection` | `[SESSION_LIMIT]` | Claude Desktop v3.1623.0 以降に更新するか、サーバーの `sshd_config` で `MaxSessions` を引き上げます（例：OpenSSH のデフォルトである 10） |
| `<host> is out of disk space` | `[ENOSPC]` または `[EDQUOT]` | リモートマシンのホームディレクトリまたは `/tmp` で空き容量またはクォータを確保します |
| `Free up disk space on this computer` | `[ENOSPC]` または `[EDQUOT]`（`Couldn't prepare the deploy locally` で始まるメッセージ内） | コンピューターの空き容量を確保します |
| `Claude Code won't start on <host>` | `[CLI_UNRESPONSIVE]` | 1 分待ってから、もう一度試してください。失敗が続く場合は、メッセージに示されているコマンドをリモートマシンで実行し、そこで Claude Code が応答するかどうかを確認します。 |

その他のメッセージについては、[リモートマシンの要件](#remote-machine-requirements-for-ssh-sessions)を確認してください。

### SSH の問題について Desktop のログを取得する

Desktop の SSH 接続の記録である `ssh.log` は、**Help** メニューから保存する Desktop のログの zip ファイルに含まれています。保存するには、**Help > Troubleshooting** を開き、使用しているシステムに対応する項目を選択します：

* **macOS**：**Show Logs in Finder**
* **Windows**：**Show Logs in File Explorer**
* **Linux**：**Show Logs in File Manager**

ファイルには環境内の名前やその他の詳細が含まれる可能性があるため、送信する前に内容を確認してください。`<host>` と `<user>` は、Desktop が置き換えた名前を表します。Desktop はすべての名前を置き換えるわけではなく、SSH のホスト名やユーザー名が記述されたまま表示される場合もあります。zip ファイルを誰かに送信する場合は、ログにホスト名が記載されていない可能性があるため、どのホストでいつ失敗したかを伝えてください。

zip ファイルには、Desktop がリモートマシンにインストールするヘルパープログラムのログは含まれていません。そのログも取得するには、接続したユーザーのホームディレクトリにある [`~/.claude/remote/run/`](#files-and-processes-on-the-remote-machine) 配下のヘルパーのフォルダから `remote-server.log` をコピーします。このファイルも送信する前に内容を確認してください。

### アプリが終了しない

* **macOS**：Cmd+Q を押します。アプリが応答しない場合、Cmd+Option+Esc で Force Quit を使用し、Claude を選択して Force Quit をクリックします。
* **Windows**：Ctrl+Shift+Esc で Task Manager を使用して Claude プロセスを終了します。

### Windows 固有の問題

* **インストール後に PATH が更新されない**：新しいターミナルウィンドウを開きます。PATH の更新は新しいターミナルセッションにのみ適用されます。
* **同時インストールエラー**：別のインストールが進行中であるというエラーが表示されるが、実際には進行中でない場合、インストーラーを管理者として実行してみてください。

### CLI で開くときに「Branch doesn't exist yet」

クラウドセッションはローカルマシンに存在しないブランチを作成できます。セッション内のブランチ名をクリックして **Copy branch name** を選択してから、ローカルでフェッチします：

```bash theme={null}
git fetch origin <branch-name>
git checkout <branch-name>
```

### まだ立ち往生していますか？

* デスクトップアプリで Help → Get Support を開くか、[Claude サポートセンター](https://support.claude.com/)に直接アクセスします
* スタンドアロン`claude` CLI でも再現される問題については、[GitHub Issues](https://github.com/anthropics/claude-code/issues)でバグを検索またはファイルします

問題を報告するときは、デスクトップアプリのバージョン、オペレーティングシステム、正確なエラーメッセージ、および関連ログを含めます。macOS では Console.app を確認します。Windows では Event Viewer → Windows Logs → Application を確認します。ログの抜粋を公開イシューに投稿する前に確認してください。環境からのファイルパスおよび他の詳細が含まれる可能性があります。
