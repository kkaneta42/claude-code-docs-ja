> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# VS Code で Claude Code を使用する

> Claude Code 拡張機能を VS Code にインストールして設定します。インラインの差分表示、@-メンション、プラン確認、キーボードショートカットを使用した AI コーディング支援を取得します。

<img src="https://mintcdn.com/claude-code/-YhHHmtSxwr7W8gy/images/vs-code-extension-interface.jpg?fit=max&auto=format&n=-YhHHmtSxwr7W8gy&q=85&s=300652d5678c63905e6b0ea9e50835f8" alt="VS Code エディタの右側に Claude Code 拡張機能パネルが開いており、Claude との会話が表示されている" width="2500" height="1155" data-path="images/vs-code-extension-interface.jpg" />

VS Code 拡張機能は、Claude Code 用のネイティブグラフィカルインターフェースを提供し、IDE に直接統合されています。これは VS Code で Claude Code を使用する推奨方法です。

この拡張機能を使用すると、次のことができます。

* Claude のプランを受け入れる前に確認および編集する
* 編集が行われるときに自動的に受け入れる
* 選択範囲から特定の行範囲を指定してファイルを @-メンションする
* 会話履歴にアクセスする
* 複数の会話を別々のタブまたはウィンドウで開く

<h2 id="prerequisites">
  前提条件
</h2>

インストール前に、以下があることを確認してください。

* VS Code 1.94.0 以上
* Anthropic アカウント：任意の有料 Claude サブスクリプション（Pro、Max、Team、または Enterprise）または Claude Console アカウントが機能し、API キーは不要です。拡張機能を初めて開くときに、このアカウントで[サインイン](/docs/ja/authentication#log-in-to-claude-code)します。Amazon Bedrock や Google Cloud の Agent Platform などのサードパーティプロバイダーを通じて Claude にアクセスする場合は、セットアップ手順について[サードパーティプロバイダーを使用する](#use-third-party-providers)を参照してください。

<Tip>
  拡張機能には、チャットパネル用の CLI（コマンドラインインターフェース）の独自コピーが含まれています。VS Code の統合ターミナルで `claude` を実行するには、[スタンドアロン CLI インストール](/docs/ja/setup)も必要です。詳細については、[VS Code 拡張機能と Claude Code CLI](#vs-code-extension-vs-claude-code-cli)を参照してください。
</Tip>

<h2 id="install-the-extension">
  拡張機能をインストールする
</h2>

使用している IDE のリンクをクリックすると、直接インストールできます。

* [VS Code 用にインストール](vscode:extension/anthropic.claude-code)
* [Cursor 用にインストール](cursor:extension/anthropic.claude-code)

または、VS Code で `Cmd+Shift+X`（Mac）または `Ctrl+Shift+X`（Windows/Linux）を押して拡張機能ビューを開き、「Claude Code」を検索して **Install** をクリックします。

拡張機能のバージョン番号は、同梱されている Claude Code のバージョンです。たとえば、Claude Code v2.1.286 以降を必要とする機能には、拡張機能のバージョン 2.1.286 以降が必要です。拡張機能のバージョンは拡張機能ビューに表示されます。

Claude Code は、ほかのエディタやコンテナでも動作します。

* **その他の VS Code フォーク**：拡張機能は Devin Desktop や Kiro などのフォークにもインストールできます。エディタの拡張機能ビューで「Claude Code」を検索するか、[Open VSX レジストリ](https://open-vsx.org/extension/Anthropic/claude-code)からインストールしてください。
* **拡張機能をインストールできないエディタ**：代わりに [CLI をインストール](/docs/ja/quickstart)し、エディタの統合ターミナルで `claude` を実行してください。CLI はどのターミナルでも動作します。
* **開発コンテナ**：開発コンテナ内で Claude Code を実行するには、[開発コンテナ](/docs/ja/devcontainer)を参照してください。

<Note>インストール後に拡張機能が表示されない場合は、VS Code を再起動するか、コマンドパレットから「Developer: Reload Window」を実行してください。</Note>

<h2 id="get-started">
  はじめに
</h2>

インストールが完了したら、VS Code のインターフェースから Claude Code を使い始めることができます。

<Steps>
  <Step title="Claude Code パネルを開く">
    VS Code 全体を通して、Spark アイコンは Claude Code を表します: <img src="https://mintcdn.com/claude-code/c5r9_6tjPMzFdDDT/images/vs-code-spark-icon.svg?fit=max&auto=format&n=c5r9_6tjPMzFdDDT&q=85&s=3ca45e00deadec8c8f4b4f807da94505" alt="Spark アイコン" style={{display: "inline", height: "0.85em", verticalAlign: "middle"}} width="16" height="16" data-path="images/vs-code-spark-icon.svg" />

    Claude を開く最も簡単な方法は、**エディターツールバー**（エディターの右上隅）にある Spark アイコンをクリックすることです。このアイコンは、ファイルを開いているときにのみ表示されます。

    <img src="https://mintcdn.com/claude-code/mfM-EyoZGnQv8JTc/images/vs-code-editor-icon.png?fit=max&auto=format&n=mfM-EyoZGnQv8JTc&q=85&s=eb4540325d94664c51776dbbfec4cf02" alt="エディターツールバーに Spark アイコンが表示されている VS Code エディター" width="2796" height="734" data-path="images/vs-code-editor-icon.png" />

    Claude Code を開くその他の方法:

    * **アクティビティバー**: 左サイドバーの Spark アイコンをクリックしてセッション一覧を開きます。任意のセッションをクリックすると[優先する場所](#extension-settings)で開くことができ、新しいセッションを開始することもできます。このアイコンはアクティビティバーに常に表示されています。
    * **コマンドパレット**: `Cmd+Shift+P`（Mac）または `Ctrl+Shift+P`（Windows/Linux）を押して「Claude Code」と入力し、「Open in New Tab」などのオプションを選択します
    * **ステータスバー**: ウィンドウの右下隅にある **✻ Claude Code** をクリックします。これはファイルを開いていないときでも機能します。

    Claude パネルはドラッグして VS Code 内の任意の場所に移動できます。詳しくは[ワークフローをカスタマイズする](#customize-your-workflow)を参照してください。
  </Step>

  <Step title="サインインする">
    初めてパネルを開くと、サインイン画面が表示されます。**Sign in** をクリックし、ブラウザーで認可を完了してください。

    後で **Not logged in · Please run /login** と表示された場合、拡張機能は自動的にサインイン画面を再度開きます。表示されない場合は、コマンドパレットから **Developer: Reload Window** を実行してウィンドウを再読み込みしてください。

    シェルで `ANTHROPIC_API_KEY` を設定しているにもかかわらずサインインプロンプトが表示される場合は、VS Code がシェル環境を引き継いでいない可能性があります。環境変数を引き継ぐようにターミナルから `code .` で VS Code を起動するか、代わりに Claude アカウントでサインインしてください。

    サインインすると、**Learn Claude Code** チェックリストが表示されます。**Show me** をクリックして各項目を順に進めるか、X で閉じてください。後で再度開くには、VS Code の設定の **Extensions > Claude Code** で **Hide Onboarding** のチェックを外します。
  </Step>

  <Step title="プロンプトを送信する">
    仕組みの説明、問題のデバッグ、変更の実施など、コードやファイルに関する手助けを Claude に依頼しましょう。

    <Tip>Claude は選択したテキストを自動的に認識します。`Option+K`（Mac）/ `Alt+K`（Windows/Linux）を押すと、@メンション参照（`@file.ts#5-10` など）をプロンプトに挿入することもできます。</Tip>

    ファイル内の特定の行について質問する例を次に示します。

    <img src="https://mintcdn.com/claude-code/FVYz38sRY-VuoGHA/images/vs-code-send-prompt.png?fit=max&auto=format&n=FVYz38sRY-VuoGHA&q=85&s=ede3ed8d8d5f940e01c5de636d009cfd" alt="Python ファイルの 2〜3 行目が選択された VS Code エディターと、@メンション参照を使ってそれらの行について質問している Claude Code パネル" width="3288" height="1876" data-path="images/vs-code-send-prompt.png" />
  </Step>

  <Step title="変更を確認する">
    <span id="security-considerations" />

    <span id="security-and-privacy" />

    プロンプトボックスの下部に表示されている[権限モード](/docs/ja/permission-modes#which-mode-a-session-starts-in)を確認してください。

    * Auto または Edit automatically モードでは、Claude はワークスペース内の[ほとんどのファイル](/docs/ja/permission-modes#protected-paths)を確認なしで編集します。
    * Manual モードでは、Claude がファイルを編集しようとすると、元の内容と提案された変更を並べて比較表示し、権限を求めます。承認、拒否、または代わりに何をすべきかを Claude に伝えることができます。承認する前に差分ビューで提案内容を直接編集した場合は、変更したことが Claude に伝えられるため、Claude はファイルが元の提案と一致しているとは想定しません。

          <img src="https://mintcdn.com/claude-code/FVYz38sRY-VuoGHA/images/vs-code-edits.png?fit=max&auto=format&n=FVYz38sRY-VuoGHA&q=85&s=e005f9b41c541c5c7c59c082f7c4841c" alt="Claude が提案した変更の差分と、編集を行うかどうかを尋ねる権限プロンプトを表示している VS Code" width="3292" height="1876" data-path="images/vs-code-edits.png" />

    提案された編集を 1 つの変更ずつ確認するには、差分内の各変更の下にある **Accept this change** ボタンと **Reject this change** ボタンを使用します。変更を拒否すると提案内容からその変更が元に戻され、承認するとその変更は確認済みとしてマークされます。変更ごとの確認には Claude Code v2.1.275 以降が必要です。

    ファイル全体を承認または拒否しても、引き続き確認を完了できます。100 を超える変更を含む差分は変更ごとのボタンなしで開かれるため、ファイル全体として確認してください。

    同じ操作は、エディターのコンテキストメニューからカーソル位置で、またコマンドパレットから **Claude Code: Accept Change at Cursor** および **Claude Code: Reject Change at Cursor** として実行することもできます。
  </Step>
</Steps>

Claude Code でできることのその他のアイデアについては、[一般的なワークフロー](/docs/ja/common-workflows)を参照してください。

<Tip>
  コマンドパレットから「Claude Code: Open Walkthrough」を実行すると、基本操作のガイド付きツアーを利用できます。
</Tip>

<h2 id="use-the-prompt-box">
  プロンプトボックスを使用する
</h2>

プロンプトボックスには次の機能があります。

* **権限モード**: プロンプトボックス下部のモードインジケーターをクリックすると、権限モードを切り替えられます。Claude Code v2.1.283 以降では Auto が組み込みの開始時の権限モードです。それより前のバージョンでは、Pro、Max、Team プランでのみ Auto が開始時の権限モードになります。何によって変わるか、およびインジケーターで選択できるすべての権限モードについては、[拡張機能が開始時の権限モードを選択する仕組み](/docs/ja/permission-modes#switch-permission-modes)を参照してください。
  * **Auto**: ユーザーに確認する代わりに、分類器がほとんどのアクションをレビューします。レビューおよびブロックされる内容については、[auto モード](/docs/ja/permission-modes#eliminate-prompts-with-auto-mode)を参照してください。
  * **Manual**: Claude はファイルの編集やほとんどのシェルコマンドの前に権限を求めます。
  * **Plan**: Claude は実行する内容を説明し、変更を加える前に承認を待ちます。VS Code はプランを完全な Markdown ドキュメントとして自動的に開き、Claude が作業を始める前にインラインコメントを追加してフィードバックを伝えられます。

    プロンプトボックスに `/plan` と入力することもできます。Claude Code v2.1.280 以降が必要です。

    * `/plan`: plan モードに切り替えます。すでに plan モードの場合は、現在のプランを表示します。
    * `/plan fix the auth bug` のようにタスクを付けた `/plan`: plan モードに切り替え、そのタスクの計画を開始します。
    * `/plan open`: すでに plan モードの場合、エディターでプランファイルを開きます。
  * **Edit automatically**: Claude は確認せずに編集を行います。
* **モデル**: コマンドメニューから **Switch model…** を選択すると、セッションの途中でモデルを変更できます。プロンプトボックス下部のモデル名をクリックしても、同じピッカーを開けます。Claude Code v2.1.284 以降では、プロンプトボックスに `/model` のみを入力してもピッカーが開きます。

  現在のモデルが [effort レベル](/docs/ja/model-config#adjust-effort-level)をサポートしている場合、ピッカーには **Effort** 行も表示され、モデル名ボタンには選択したレベルが表示されます。`max` 以外のレベルを選択すると、Claude Code はそれを現在のモデルのデフォルトとして、ユーザー設定の [`modelSettings`](/docs/ja/settings-reference#modelsettings) に保存します。`max` は現在のセッションにのみ適用されます。モデル名ボタンと **Effort** 行には Claude Code v2.1.257 以降が必要です。

  [動的ワークフロー](/docs/ja/workflows)が有効で、現在のモデルがそれをサポートしている場合、**Effort** 行の下に **Ultracode** スイッチが表示されます。これをオンにすると、Claude はこのセッションの実質的なタスクごとに、選択した effort レベルで[ワークフロー](/docs/ja/workflows#let-claude-decide-with-ultracode)を計画します。オンの間、モデル名ボタンにはレベルの後に `· Ultracode` と表示されます。このスイッチには Claude Code v2.1.284 以降が必要です。
* **コマンドメニュー**: `/` をクリックするか `/` と入力すると、コマンドメニューが開きます。ファイルの添付、モデルの切り替え、拡張思考の切り替えなどのオプションがあります。

  Customize セクションには、MCP サーバー、コマンド、出力スタイル、フック、メモリ、指示、権限、プラグインなどの項目があります。ターミナルアイコンの付いた項目は統合ターミナルで開きます。

  * `/usage` や [`/remote-control`](/docs/ja/remote-control) などのコマンドを一覧するには、Customize セクションで **Slash commands** を選択します。フィルターボックス付きのダイアログにコマンドが一覧表示されます。いずれかを選ぶと実行されます。プロンプトボックスに `/` と入力した場合も、引き続きインラインでコマンドが候補表示されます。Claude Code v2.1.257 以降が必要です。

    `/skills` と入力してもこのダイアログが開きます。各[スキル](/docs/ja/skills)の行には、**On** や **Name only** などの[表示設定](/docs/ja/skills#override-skill-visibility-from-settings)が表示されます。表示設定をクリックすると変更できます。ただし、プラグインのスキルなど **locked** と表示された行は変更できません。`/skills` ショートカットと表示設定のコントロールには Claude Code v2.1.280 以降が必要です。
  * Customize セクションで **Output styles** を選択すると、カスタムスタイルを含む[出力スタイル](/docs/ja/output-styles)を選択できます。Claude Code v2.1.257 以降が必要です。

    代わりにカスタムスタイルを作成するには、**Output styles** メニューから **Build a custom style** を選択します。Claude Code がプロジェクトレベルまたはユーザーレベルで[スタイルファイル](/docs/ja/output-styles#create-a-custom-output-style)を作成します。Claude Code v2.1.261 以降が必要です。
  * Customize セクションで **Hooks** を選択すると、セッションで読み込まれている[フック](/docs/ja/hooks)をイベントごとにグループ化して表示できます。ユーザー、プロジェクト、ローカルの設定ファイルに保存されているフックは追加、編集、削除できます。管理設定やプラグインなど、その他のソースからのフックは読み取り専用です。Claude Code v2.1.269 以降が必要です。
  * Customize セクションで **Permissions** を選択すると、セッションの[権限ルール](/docs/ja/permissions)を Allow、Ask、Deny に分けて表示できます。ユーザー、プロジェクト、ローカルの設定にルールを追加したり、そこに保存されているルールを削除したりできます。管理設定や、このセッションのみを対象とした承認など、その他のソースからのルールは読み取り専用です。Claude Code v2.1.269 以降が必要です。
  * Customize セクションで **Memory** を選択すると、[自動メモリ](/docs/ja/memory#auto-memory)のオン/オフを切り替えられます。オンの間は、Claude が保存したメモリを参照したり、それらを保存しているフォルダーをファイルマネージャーで表示したりすることもできます。Claude Code v2.1.274 以降が必要です。

    保存されたメモリをクリックするとダイアログで内容を読むことができ、そこでテキストの編集、メモリの削除、エディターでのファイルのオープンが行えます。ダイアログでのメモリの表示、編集、削除には Claude Code v2.1.275 以降が必要です。
  * Customize セクションで **Instructions** を選択すると、Claude が読み込む [CLAUDE.md ファイル](/docs/ja/memory#claude-md-files)を編集できます。ファイルを選ぶとエディターで開きます。ファイルがまだ存在しない場合は、Claude Code が先に作成します。Claude Code v2.1.274 以降が必要です。
  * Customize セクションで **Status** を選択するか `/status` と入力すると、セッションの Claude Code のバージョン、アカウント、モデル、MCP サーバーの詳細を確認できます。Claude Code v2.1.280 以降が必要です。
  * Customize セクションで **Sandbox** を選択するか `/sandbox` と入力すると、Claude の Bash コマンドが[サンドボックス内](/docs/ja/sandboxing)で実行されるかどうかを確認できます。そこでサンドボックスモードを切り替えたり、[除外コマンド](/docs/ja/settings-reference#sandbox-excludedcommands)を追加したりできます。Claude Code v2.1.280 以降が必要です。
  * Customize セクションで **Claude in Chrome** を選択するか `/chrome` と入力すると、[Claude in Chrome](/docs/ja/chrome) の接続を確認および管理できます。いずれも claude.ai アカウントでのサインインが必要です。Claude Code v2.1.280 以降が必要です。
  * Context セクションで **Export conversation** を選択するか `/export` と入力すると、会話をプレーンテキストとしてコピーしたり、ファイルに保存したりできます。`/export notes.txt` のようにファイル名を付けると、ダイアログを省略してファイルの保存先を選択できます。Claude Code v2.1.280 以降が必要です。
  * Settings セクションには **Enable Remote Control for all sessions** があり、[`remoteControlAtStartup`](/docs/ja/settings-reference#remotecontrolatstartup) を設定して、[新しい対話型セッションが自動的に Remote Control に接続するか](/docs/ja/remote-control#enable-remote-control-for-all-sessions)どうかを制御します。Claude Code v2.1.203 以降が必要です。

    VS Code ウィンドウでこのトグルをオンまたはオフにすると、その変更は以降に開始するセッションだけに限定されません。その VS Code ウィンドウですでに開いているセッションにも適用されます。オフにすると、開いているセッションは切断されます。Claude Code v2.1.261 以降では、この変更は他の VS Code ウィンドウで開いているセッションにも反映されます。
  * Settings セクションには **Focus view** もあり、ツール呼び出し、ツールの結果、思考を展開可能な行の中に隠し、ユーザーのプロンプトと Claude の応答だけを表示します。そこで切り替えるか、`Ctrl+Option+F`（Mac）/ `Ctrl+Alt+F`（Windows/Linux）を使うか、コマンドパレットから **Claude Code: Toggle Focus view** を実行して切り替えます。変更は開いているすべてのセッションに適用され、セッションをまたいで保持されます。Claude Code v2.1.221 以降が必要です。

    Claude の最新の To-Do リストは表示されたままになり、Claude からの保留中の質問が対象としているテキストも表示されたままになります。これには Claude Code v2.1.225 以降が必要です。Claude が[サブエージェント](/docs/ja/sub-agents)を実行している間は、それらを開始したツール呼び出しグループの下に、最新のアクティビティを示すライブ進捗行が表示されます。これには Claude Code v2.1.269 以降が必要です。
  * Anthropic アカウントからサインアウトするには、Settings セクションで **Sign out** を選択するか、`/logout` と入力します。[サードパーティプロバイダー](#use-third-party-providers)を使用している場合、メニューにはどちらも表示されません。Claude Code v2.1.277 以降が必要です。
  * バグを報告するには、メニュー下部の **Report a problem** をクリックするか、`/bug` または `/feedback` と入力します。任意で説明を付けると、それがレポートにあらかじめ入力されます。ファーストパーティ接続で Anthropic にサインインしている状態でレポートを送信すると、Claude Code はそれを Anthropic に送信します。Claude Code v2.1.229 以降が必要です。

    サードパーティプロバイダーを使用している場合や Anthropic の認証情報がない場合は、何も送信されません。そのことは、入力を始める前にダイアログに表示されます。送信すると、既知の API キーやトークンのパターンを伏せた上で、レポートが [`~/.claude/feedback-bundles/` 配下のローカルアーカイブ](/docs/ja/data-usage#telemetry-services)として保存されます。レポートをコンピューターに保存するには Claude Code v2.1.284 以降が必要です。

    レポートが保存されると、確認メッセージにファイル名が表示され、**Show folder** ボタンが含まれます。そのファイルを Anthropic のアカウント担当者に送るか、サポートリクエストに添付してください。

    組織のポリシーで製品フィードバックがオフになっている場合、メニューに **Report a problem** は表示されず、`/bug` と `/feedback` はレポートを開く代わりに `Feedback is turned off by your organization's policy or this environment's settings.` という通知を表示します。Claude Code v2.1.284 以降では、`DISABLE_FEEDBACK_COMMAND` または `CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC` 環境変数を設定した場合もフィードバックがオフになり、レポートを開こうとするとその通知が表示されます。
* **サイドクエスチョン**: `/btw` に続けて質問を入力すると、[会話に追加せずに](/docs/ja/interactive-mode#side-questions-with-%2Fbtw)セッションについて質問できます。回答はチャットの横のパネルに開き、そこでフォローアップの質問ができます。Claude Code v2.1.227 以降が必要です。

  このスレッドはウィンドウを再読み込みしても保持されます。Claude Code は最新の 20 件のやり取りを保持し、Claude Code が[保持期間を安全に判断できる](/docs/ja/claude-directory#cleaned-up-automatically)限り、保存されたスレッドを [`cleanupPeriodDays`](/docs/ja/settings-reference#cleanupperioddays) のスケジュールに従って期限切れにします。スレッドを消去するには、パネルのゴミ箱アイコンをクリックします。
* **応答をコピーする**: 応答にカーソルを合わせて **Copy response** をクリックするとクリップボードにコピーされます。また、`/copy` と入力すると最新の応答をコピーできます。`/copy 2` は最後から 2 番目の応答をコピーします。Claude Code v2.1.277 以降が必要です。
* **ブックマーク**: 応答にカーソルを合わせて **Bookmark response** をクリックすると保存されます。保存済みの応答で **Remove bookmark** をクリックすると削除されます。

  保存した応答を確認するには、Bookmarks パネルを開きます。Claude Code パネル上部のブックマークアイコンをクリックするか、コマンドメニューの Context セクションで **Bookmarks** を選択するか、`/bookmarks` と入力します。Claude Code v2.1.286 以降が必要です。
* **Claude から送られたファイル**: セッションが [Remote Control](/docs/ja/remote-control#start-a-remote-control-session) に接続されていて、Claude が [`SendUserFile` ツール](/docs/ja/tools-reference)でファイルを送った場合、会話には **Sent report.md, chart.png** のような行が表示されます。ファイル名をクリックするとエディターで開きます。
* **コンテキストインジケーター**: プロンプトボックスには、Claude のコンテキストウィンドウをどれだけ使用しているかが表示されます。Claude は必要に応じて自動的に圧縮しますが、`/compact` を手動で実行することもできます。
* **プロンプトキャッシュの時計**: コンテキストインジケーターの横にある時計アイコンは、会話の[プロンプトキャッシュ](/docs/ja/prompt-caching)の有効期限が切れるまでの残り時間を推定して表示します。キャッシュの 5 分または 1 時間の[有効期間](/docs/ja/prompt-caching#cache-lifetime)からカウントダウンし、キャッシュを使用する応答があるたびにカウントダウンがリセットされます。コンテキスト圧縮を除き、[キャッシュを無効化するアクション](/docs/ja/prompt-caching#actions-that-invalidate-the-cache)では時計はリセットされないため、モデルを切り替えた後も残り時間が表示されることがあります。
  * カウントダウンが終わるまで、アイコンには **12m** のように残りの分数が表示されます。
  * カウントダウンが終わると、次の応答まで分数が消え、アイコンが赤色（またはテーマのエラーカラー）に変わります。キャッシュは期限切れになっている可能性が高いため、キャッシュが再構築される間、次のメッセージへの応答は遅く、コストも高くなると考えてください。5 分の有効期間がメッセージの間に何度も切れてしまう場合は、[TTL を自分で選択する](/docs/ja/prompt-caching#choose-the-ttl-yourself)を参照してください。
  * 会話が[圧縮](/docs/ja/prompt-caching#compacting-the-conversation)された直後も、キャッシュが圧縮後の会話をまだカバーしていないため、次の応答までアイコンは分数なしで赤色になります。
* **エージェントマップ**: 会話に[サブエージェント](/docs/ja/sub-agents)が含まれている場合、プロンプトボックス下部に **2 agents** のようなエージェント数が表示されます。そのドットは、いずれかのサブエージェントが作業中か、ユーザーの権限を待っているかを示します。

  エージェント数をクリックするとエージェントマップが開き、会話のサブエージェントがメインエージェントの下にツリーとして描画され、それぞれのステータス、経過時間、トークン数が表示されます。サブエージェントをクリックすると、そのプロンプトとツール呼び出しを確認したり、読み取り専用のトランスクリプトを開いたり、実行中のサブエージェントを停止したりできます。Claude Code v2.1.269 以降が必要です。

  マップには、エージェントの下にセッションのその他の[バックグラウンドタスク](/docs/ja/tools-reference#background-commands)（バックグラウンドのシェルコマンドや[モニター](/docs/ja/tools-reference#monitor-tool)など）も一覧表示されます。行をクリックするとタスクのカードが開き、そこで停止できます。

  Claude がバックグラウンドシェルを開始したもののサブエージェントがない場合など、エージェント数が表示されていないときにマップを開くには、プロンプトボックスに `/tasks` と入力します。マップ内のバックグラウンドタスクと、入力による `/tasks` には Claude Code v2.1.277 以降が必要です。

  Claude Code v2.1.286 以降では、**Stop** をクリックするか `Esc` を押すと、現在のターンが終了します。バックグラウンドエージェントは、完了するか、マップから停止するまで実行を続けます。
* **拡張思考**: 複雑な問題について Claude がより多くの時間をかけて推論できるようにします。コマンドメニュー（`/`）からオンに切り替えます。Claude の推論は会話内に折りたたまれたブロックとして表示されます。ブロックをクリックすると内容を読むことができ、`Ctrl+O` を押すとセッション内のすべての思考ブロックを展開または折りたたむことができます。詳細は[拡張思考](/docs/ja/model-config#extended-thinking)を参照してください。
* **複数行入力**: `Shift+Enter` を押すと、送信せずに改行を追加できます。これは質問ダイアログの「Other」自由記述入力でも機能します。

<h3 id="reference-files-and-folders">
  ファイルとフォルダーを参照する
</h3>

@メンションを使用すると、特定のファイルやフォルダーに関するコンテキストを Claude に与えられます。`@` に続けてファイル名やフォルダー名を入力すると、Claude はその内容を読み込み、それについての質問に答えたり、変更を加えたりできます。Claude Code はあいまい一致をサポートしているため、名前の一部を入力するだけで目的のものを見つけられます。

```text wrap theme={null}
Explain the logic in @auth (fuzzy matches auth.js, AuthService.ts, etc.)
What's in @src/components/ (include a trailing slash for folders)
```

大きな PDF の場合は、ファイル全体ではなく特定のページを読むよう Claude に依頼できます。単一のページ、1～10 ページのような範囲、3 ページ以降のような終わりを指定しない範囲を指定できます。特定のページを読むには、Claude Code を実行しているマシンに [poppler-utils](/docs/ja/tools-reference#read-tool-behavior) が必要です。

エディターでテキストを選択すると、Claude はハイライトされたコードを自動的に認識できます。プロンプトボックスのフッターには選択されている行数が表示されます。`Option+K`（Mac）/ `Alt+K`（Windows/Linux）を押すと、`@app.ts#5-10` のように、ファイルパスと行番号を含む @メンションが挿入されます。選択範囲インジケーターの **X** をクリックすると選択範囲が解除され、Claude はその選択範囲を受け取らなくなります。別のテキストを選択すると、インジケーターは再び表示されます。

拡張機能は、一部のファイルの選択テキストを Claude に渡しません。

* ファイルがワークスペース内にあり、`files.exclude` または `search.exclude` の設定に一致する場合、Claude が受け取るのは最大でもファイルのパスのみで、選択したテキストは受け取りません。
* VS Code の `search.useIgnoreFiles` 設定と拡張機能の [`respectGitIgnore` 設定](#extension-settings)の両方がオン（デフォルト）の場合、git が無視するファイルにも同じことが当てはまります。

このフィルターはチャットパネルにのみ適用されます。Claude Code が統合ターミナルで実行されている場合、CLI はファイルに関係なく選択したテキストを送信します。その場合にファイルの内容を Claude に渡さないようにするには、[`Read` の拒否ルール](#the-built-in-ide-mcp-server)を追加します。

何も選択していない場合でも、Claude はエディターで開いているファイルを認識し、プロンプトボックスにはその名前が表示されます。選択したテキストのみを追加するには、[Attach Open File 設定](vscode://settings/claudeCode.attachOpenFile)をオフにします。この設定には Claude Code v2.1.271 以降が必要です。

メッセージに画像やファイルを添付することもできます。

* 画像を添付するには、クリップボードからプロンプトボックスに貼り付けます。
* ファイルを添付するには、`Shift` を押しながらプロンプトボックスにドラッグします。
* 添付ファイルをコンテキストから削除するには、その X をクリックします。

<h3 id="include-terminal-output-in-prompts">
  プロンプトにターミナル出力を含める
</h3>

`@terminal:name`（`name` はターミナルのタイトル）を使用して、プロンプトでターミナル出力を参照できます。これにより、コピー＆ペーストせずに、コマンド出力、エラーメッセージ、ログを Claude に見せることができます。

<h3 id="paste-text">
  テキストを貼り付ける
</h3>

貼り付けたテキストは、[ターミナル](/docs/ja/terminal-config#paste-large-content)のようにプレースホルダーに折りたたまれることなく、プロンプトボックスに表示されたままになります。Claude Code が[貼り付けたテキストをマークする](/docs/ja/terminal-config#how-claude-treats-pasted-text)セッションでは、大きな貼り付けは、入力したものではなく貼り付けたテキストとして Claude に認識されます。

Claude Code は、プロンプトボックスに貼り付けたテキストや送信するその他すべての内容から、[不可視の Unicode 文字](/docs/ja/interactive-mode#invisible-characters-in-prompts)も削除します。

* 貼り付け時に `Removed 3 invisible characters from the pasted text` のような通知が表示された場合、テキストはそれらの文字を除いて入力されています。
* 送信時に削除された文字に関する通知が表示された場合、何も送信されていません。クリーンアップされたテキストはプロンプトボックスに戻されています。表示されたとおりのテキストを送信するには、再度送信してください。

<h3 id="latex-math-in-responses">
  応答内の LaTeX 数式
</h3>

チャットパネルは、Claude の応答内の LaTeX 数式を組版された数式として表示します。数式のレンダリングには Claude Code v2.1.301 以降が必要です。[ターミナルモード](#switch-to-terminal-mode)では、数式は組版されません。パネルはディスプレイ数式とインライン数式の両方を組版します。

* **ディスプレイ数式**: 独立した 1 行または複数行に記述された `$$ … $$` または `\[ … \]` ブロック、および言語が `math` のフェンス付きコードブロック
* **インライン数式**: `$E = mc^2$` や `\(a^2 + b^2 = c^2\)` のように、同じ行で開始と終了がある `$…$` または `\(…\)`

パネルは同じ文字の他の用途と数式を区別しようとするため、`$HOME`、`$5` のような価格、`sed 's/\(foo\)/\1/'` などのテキストは組版されません。コードスパン内や、フェンス付き `math` ブロック以外のコードブロック内のテキストも組版されません。組版されるはずの数式が記述どおりに表示される場合は、[数式が生の LaTeX として表示される](#a-formula-shows-as-raw-latex)を参照してください。

組版された数式を含むテキストを選択してコピーすると、描画された記号ではなく、`$…$` または `$$…$$` の区切り文字で囲まれた数式の TeX ソースが得られます。[**Copy response**](#use-the-prompt-box) と `/copy` では、TeX ソースを含め、Claude が書いたとおりの応答が得られます。

<h3 id="resume-past-conversations">
  過去の会話を再開する
</h3>

Claude Code パネル上部の **Session history** ボタンをクリックすると、会話履歴にアクセスできます。キーワードで検索したり、時系列で参照したりできます。

任意の会話をクリックすると、その会話を再開できます。その会話が現在のウィンドウの別のタブですでに開いている場合は、クリックするとそのタブに切り替わります。会話を開いたときにメッセージが表示されない場合は、[再開した会話が最初は空白になる理由](#a-resumed-conversation-is-blank-at-first)を参照してください。セッションの再開について詳しくは、[セッションを管理する](/docs/ja/sessions)を参照してください。

* **セッションタイトル**: 新しいセッションには、最初のメッセージに基づいて AI が生成したタイトルが付けられます。
* **名前の変更とアーカイブ**: セッションにカーソルを合わせると、これらのアクションが表示されます。名前を変更してわかりやすいタイトルを付けたり、アーカイブしてリスト下部の **Archived sessions** グループに移動したりできます。

会話が別の Claude Code プロセス（ターミナルの `claude` や別の VS Code ウィンドウなど）で開かれている場合、プロンプトボックスの代わりに次の通知が表示されます。

```text theme={null}
This conversation is still open somewhere else. Using it in two places at once can mix up its messages.
```

ここで続行するには、もう一方の場所で会話を閉じてから **Open here anyway** をクリックします。閉じずにクリックすると、会話は両方の場所で開かれた状態になります。[`claudeProcessWrapper`](#extension-settings) が設定されている場合、拡張機能はこのチェックをスキップして会話を直接開きます。

デフォルトでは、14 日間アクティビティのないセッションは、開いている、未読である、または[グループ](#organize-sessions-into-groups)に属している場合を除き、自動的に **Archived sessions** に移動します。自動アーカイブには Claude Code v2.1.265 以降が必要です。期間を変更したりオフにしたりするには、[Archive Inactive Sessions 設定](vscode://settings/claudeCode.archiveInactiveSessions)を開き、日数または **Never** を選択します。

アーカイブしたセッションを復元するには、次のようにします。

* **1 つのセッション**: **Archived sessions** を展開し、**Unarchive session** をクリックします。
* **アーカイブしたすべてのセッションを一括で**: アクティビティバーのセッションリストにある **Archived sessions** ヘッダーにカーソルを合わせ、そのアーカイブ解除アイコンをクリックします。Claude Code v2.1.277 以降が必要です。

v2.1.257 より前は、このアクションは **Delete session** で、セッションを復元する手段のない形で非表示にしていました。その際に削除したセッションは、アップグレード後に **Archived sessions** の下に表示されます。

再開した会話が plan モードで終了していた場合、Claude Code は plan モードを復元します。Claude Code v2.1.246 以降が必要です。次の場合、Claude Code は plan モードを復元しません。

* 拡張機能が `claudeCode.initialPermissionMode` から、または以前の会話から引き継がれた選択から[開始時の権限モードを選択する](/docs/ja/permission-modes#switch-permission-modes)場合
* `claudeCode.claudeProcessWrapper` を設定している場合
* [拒否ルール](/docs/ja/permissions#manage-permissions)によって [`ExitPlanMode`](/docs/ja/tools-reference) ツールが除外されている場合

<h3 id="resume-cloud-sessions-from-claude-ai">
  claude.ai のクラウドセッションを再開する
</h3>

[クラウドセッション](/docs/ja/claude-code-on-the-web)を実行している場合は、VS Code で直接再開できます。これには、Anthropic Console ではなく **Claude.ai Subscription** でのサインインが必要です。

<Steps>
  <Step title="セッション履歴を開く">
    Claude Code パネル上部の **Session history** ボタンをクリックします。
  </Step>

  <Step title="Web タブを選択する">
    ダイアログには Local と Web の 2 つのタブが表示されます。**Web** をクリックすると、claude.ai のセッションが表示されます。
  </Step>

  <Step title="再開するセッションを選択する">
    セッションを参照または検索します。いずれかをクリックすると、ローカルで会話を続行できます。
  </Step>
</Steps>

<Note>
  開いているフォルダーが GitHub リポジトリの場合、Web タブにはそのリポジトリのセッションのみが表示されます。

  クラウドセッションを再開すると、拡張機能は会話履歴のコピーをダウンロードします。変更は claude.ai には同期されません。
</Note>

Web タブには [Remote Control](/docs/ja/remote-control) セッションも一覧表示されます。開いているフォルダーで実行されたセッションをクリックすると、拡張機能はコピーをダウンロードする代わりにそのローカルの会話を開きます。すでにその会話を表示しているタブがある場合は、そのタブにフォーカスします。別の Claude プロセスがその会話を開いている可能性を拡張機能が排除できない場合は、代わりにダウンロードしたコピーが開かれます。

会話の一部のダウンロードに失敗した場合は、エラーが表示され、コピーは保存されません。再試行するには、もう一度セッションを選択してください。ダウンロードできる会話がまだないセッションを選択した場合は、代わりにどこで続行すればよいかをエラーで案内します。

<h3 id="check-account-and-usage">
  アカウントと使用量を確認する
</h3>

`/usage` を実行すると Account & usage ダイアログが開き、サインインしているアカウントと使用量が表示されます。使用量の数値はサインイン方法に応じて異なります。

* **claude.ai プラン**: 現在のセッションや週など、プランの制限ごとの使用量バーが表示されます。各バーには、その制限がリセットされるまでの時間が表示されます。

  ダイアログでは、プランの制限に影響している要因の内訳も確認できます。キャッシュミス、長いコンテキスト、サブエージェントを多用するセッションや並列性の高いセッションなど、最近の使用量の 10% 以上を占める動作が指摘されます。指摘された動作にはそれぞれ、削減するためのヒントが示されます。帰属テーブルには、各スキル、サブエージェント、プラグイン、MCP サーバーによる使用量が表示されます。

  Day と Week のトグルを使用すると、過去 24 時間と過去 7 日間を切り替えられます。数値は概算であり、このマシン上のローカルセッションから計算されるため、他のデバイスや claude.ai での使用量は含まれません。
* **その他のサインイン**: [サードパーティプロバイダー](#use-third-party-providers)や API キーを使用している場合など、サインイン方法にプランの制限が適用されない場合は、Usage セクションに代わりにセッション自体のコストとトークン使用量が表示されます。CLI の `/usage` でも、[Session ブロック](/docs/ja/costs#track-your-costs)に同じ合計が表示されます。アクティビティバーのセッションリストにも、**Account & usage** ヘッダーの下にアクティブなセッションの合計が表示されます。Claude Code v2.1.277 以降が必要です。

使用量の追跡と削減について詳しくは、[コストを追跡する](/docs/ja/costs#track-your-costs)を参照してください。

<h3 id="rewind-with-checkpoints">
  チェックポイントで巻き戻す
</h3>

VS Code 拡張機能はチェックポイントをサポートしています。チェックポイントは Claude によるファイル編集を追跡し、以前の状態に巻き戻せるようにします。任意のメッセージにカーソルを合わせると巻き戻しボタンが表示されるので、次の 3 つのオプションから選択します。

* **Fork conversation from here**: すべてのコード変更をそのまま保持しつつ、このメッセージから新しい会話の分岐を開始します
* **Rewind code to here**: 会話履歴全体を保持しつつ、ファイルの変更を会話のこの時点まで元に戻します
* **Fork conversation and rewind code**: 新しい会話の分岐を開始し、ファイルの変更をこの時点まで元に戻します

チェックポイントの仕組みと制限について詳しくは、[チェックポイント機能](/docs/ja/checkpointing)を参照してください。

<h2 id="customize-your-workflow">
  ワークフローをカスタマイズする
</h2>

Claude パネルの位置を変更したり、複数の会話を実行したり、セッションリストをグループ化またはフィルタリングしたり、ターミナルモードに切り替えたりできます。

<h3 id="choose-where-claude-lives">
  Claude の配置場所を選ぶ
</h3>

Claude パネルをドラッグして、VS Code 内の任意の場所に移動できます。パネルのタブまたはタイトルバーをつかんで、次の場所にドラッグします。

* **セカンダリサイドバー**：ウィンドウの右側です。コーディング中も Claude を表示したままにできます。
* **プライマリサイドバー**：エクスプローラーや検索などのアイコンがある左側のサイドバーです。
* **エディター領域**：Claude をファイルと並ぶタブとして開きます。サイドタスクに便利です。

Claude が新しいエディターグループでタブを開くと、拡張機能はそのグループをロックします。その後、Claude のタブにフォーカスがある状態で開いたファイルは、その隣ではなく別のグループに開かれます。

拡張機能がグループをロックしないようにするには、[Lock Editor Groups 設定](vscode://settings/claudeCode.lockEditorGroups)をオフにします。すでにロックされているグループは、ロックを解除するまでロックされたままです。この設定には Claude Code v2.1.274 以降が必要です。

<Tip>
  メインの Claude セッションにはサイドバーを使い、サイドタスクには追加のタブを開きましょう。Claude は好みの配置場所を記憶します。アクティビティバーのセッションリストアイコンは Claude パネルとは別のものです。セッションリストは常にアクティビティバーに表示されますが、Claude パネルのアイコンがそこに表示されるのは、パネルが左側のサイドバーにドッキングされている場合のみです。
</Tip>

<h3 id="continue-conversations-after-a-reload">
  リロード後に会話を続ける
</h3>

**Developer: Reload Window** を実行するか VS Code を再起動した後は、会話がどこで開かれていたかを確認してください。

* **エディタータブ**：会話はそのタブとともに復元されます。
* **サイドバー**：過去 10 分以内にその会話でメッセージを送信したか Claude が応答した場合、会話は復元されます。復元されない場合は、[セッション履歴](#resume-past-conversations)から会話を再開してください。

別の Claude Code プロセスがまだその会話を開いている場合は、ここで開く前に確認が求められます。これは[セッション履歴から再開する](#resume-past-conversations)ときと同じ **Open here anyway** の通知です。最初にメッセージが空白のままの場合は、[空白になる理由と表示されるタイミング](#a-resumed-conversation-is-blank-at-first)を参照してください。

<h4 id="interrupted-steps-after-a-reload">
  リロード後に中断されたステップ
</h4>

リロードによって Claude がステップの途中で中断された場合、会話が復元されると Claude はそのステップを続行し、チャット内の通知で続行であることが示されます。Claude Code v2.1.274 以降が必要です。ステップが中断されてから 1 時間以上経過している場合や、セッションが別の場所で開かれている場合は、代わりに会話はアイドル状態で復元されます。

<h4 id="turn-off-continuation-after-a-reload">
  リロード後の続行をオフにする
</h4>

リロード後に Claude が中断されたステップを続行しないようにするには、[Continue After Reload 設定](vscode://settings/claudeCode.continueAfterReload)を開いてチェックを外します。

VS Code の環境または [`environmentVariables` 設定](#extension-settings)で [`CLAUDE_CODE_RESUME_INTERRUPTED_TURN`](/docs/ja/env-vars#variables) やその他の `CLAUDE_CODE_RESUME_` 変数を設定しても、パネルでは効果がありません。これは、拡張機能がパネルのセッションを開始する前にそれらの変数を削除するためです。

<h4 id="a-conversation-was-not-reopened">
  会話が再度開かれなかった
</h4>

リロード後、プロンプトボックスの上に次のような通知が表示された新しいチャットが開いた場合、その会話の直近 2 回の読み込みが完了しなかったため、パネルが会話を閉じたままにしたことを意味します。

```text theme={null}
“Fix the login bug” was not reopened. It did not finish opening the last 2 times, and opening it again may stop Claude Code from responding here.
```

会話の読み込み中にパネルがクラッシュしたり応答しなくなったりした場合、または会話が開いてから約 3 秒以内にウィンドウをリロードしたり閉じたりした場合、読み込みは完了しません。会話は変更されず、[セッション履歴](#resume-past-conversations)に残ります。

* **それでも開く場合**：**Open it anyway** をクリックするか、セッション履歴から会話を選択します。会話の読み込みが完了すると、[以降のリロード後も通常どおり復元されます](#continue-conversations-after-a-reload)。
* **会話の読み込み中にパネルが応答しなくなった場合**：ウィンドウをリロードします。新しいチャットが開きます。
* **閉じたままにする場合**：新しいチャットで作業を続けてください。プロンプトを送信すると通知は消えます。

<h3 id="run-multiple-conversations">
  複数の会話を実行する
</h3>

コマンドパレットから **Open in New Tab** または **Open in New Window** を使用して、追加の会話を開始できます。各会話は独自の履歴とコンテキストを保持するため、異なるタスクを並行して進められます。

タブを使用している場合、スパークアイコン上の小さな色付きのドットがステータスを示します。青は権限リクエストが保留中であること、オレンジはタブが非表示の間に Claude が処理を完了したことを意味します。

<h3 id="organize-sessions-into-groups">
  セッションをグループに整理する
</h3>

アクティビティバーのセッションリストでは、関連するセッションを名前付きの折りたたみ可能なグループにまとめられます。Claude Code v2.1.229 以降が必要です。

* **セッションをグループ化またはグループ解除する**：セッションを右クリックして、そのセッションからグループを作成したり、既存のグループに移動したり、グループから削除したりします。各セッションは一度に 1 つのグループにのみ所属するため、別のグループに移動すると元のグループからは削除されます。
* **複数のセッションを一度に移動する**：各セッションを `Cmd` クリック（Mac）/ `Ctrl` クリック（Windows/Linux）するか、`Shift` クリックで範囲を選択してから、選択部分を右クリックします。
* **タブからセッションをグループ化する**：コマンドパレットから **Claude Code: Add Session Tab to Group** を実行し、グループを選択または作成します。Claude Code v2.1.257 以降が必要です。
* **グループの名前を変更または削除する**：グループのヘッダーを右クリックします。グループを削除してもグループ自体が削除されるだけで、そのセッションはグループ化されていないリストに戻ります。

拡張機能はグループをワークスペースフォルダーごとに保存するため、グループはウィンドウのリロード後も保持され、同じフォルダーを開いたすべてのウィンドウに表示されます。リストを検索すると、拡張機能はすべてのグループにまたがる一致結果を 1 つのフラットなリストで表示します。

<h3 id="filter-the-sessions-list">
  セッションリストをフィルタリングする
</h3>

アクティビティバーの長いセッションリストを絞り込むには、リスト上部にある 2 つのフィルターコントロールを使用します。Claude Code v2.1.271 以降が必要です。いずれかのフィルターがオンの間は、アーカイブされたセッションは表示されません。

* **Active**：このトグルをオンにすると、入力が必要なセッション、処理中のセッション、未読のセッションと、最後にフォーカスした Claude タブのセッションのみが表示されます。
* **ステータスでフィルタリング**：じょうごアイコンをクリックし、**Needs input**、**Working**、または **Completed** にチェックを入れると、それらのいずれかの状態にあるセッションが表示されます。**Open** または **Closed** にチェックを入れると、セッションが開いているかどうかで絞り込めます。このウィンドウにタブがある場合、またはこのマシン上の別の Claude Code プロセス（ターミナルなど）で実行中の場合、セッションは開いているとみなされます。

**Active** がオンの状態でステータス、**Open**、または **Closed** にチェックを入れると、チェックした条件に一致するすべてのセッションもリストに表示されます。設定したフィルターはウィンドウのリロード後も保持されます。

<h3 id="switch-to-terminal-mode">
  ターミナルモードに切り替える
</h3>

デフォルトでは、拡張機能はグラフィカルなチャットパネルを開きます。CLI スタイルのインターフェースを使いたい場合は、[Use Terminal 設定](vscode://settings/claudeCode.useTerminal)を開いてチェックボックスをオンにします。

Mac では `Cmd+,`、Windows/Linux では `Ctrl+,` を押して VS Code の設定を開き、**Extensions > Claude Code** に移動して **Use Terminal** にチェックを入れることもできます。

<h2 id="manage-plugins">
  プラグインを管理する
</h2>

VS Code 拡張機能には、[プラグイン](/docs/ja/plugins/overview)をインストールおよび管理するためのグラフィカルインターフェースが含まれています。プロンプトボックスに `/plugins` と入力すると、**Manage plugins** インターフェースが開きます。

<h3 id="install-plugins">
  プラグインをインストールする
</h3>

プラグインダイアログには、**Plugins** と **Marketplaces** の 2 つのタブがあります。

Plugins タブでは次の操作ができます。

* **インストール済みのプラグイン**は上部に表示され、トグルスイッチで有効化または無効化できます。
  * プロジェクトの共有 `.claude/settings.json` でオンになっているプラグインをオフにしようとすると、拡張機能が事前に確認します。**Disable for me** は自分だけに対してオフにし、**Disable for everyone** は共有ファイルを変更します。
  * 読み込みに失敗したプラグインの行には、短い理由が表示されます。理由をクリックすると対処方法が表示されます。これには、[プラグインのトラブルシューティング](/docs/ja/plugins/troubleshooting)で調べるために完全なエラーメッセージをコピーする操作も含まれます。
* 設定済みのマーケットプレイスから**利用可能なプラグイン**がその下に表示されます
* 検索して、名前または説明でプラグインを絞り込めます
* 利用可能なプラグインの **Install** をクリックします

プラグインをインストールするときは、インストールスコープを選択します。

* **Install for you**: すべてのプロジェクトで利用可能（ユーザースコープ）
* **Install for this project**: プロジェクトの共同作業者と共有（プロジェクトスコープ）
* **Install locally**: 自分だけ、このリポジトリ内のみ（ローカルスコープ）

インストールが完了すると、プラグインの[設定オプション](/docs/ja/plugins/components#user-configuration)のうち、まだ設定されていないものを入力するフォームが表示されます。後でオプションを確認または変更するには、プラグインの行にある歯車アイコンをクリックします。

機密性の高いテキストフィールドはマスクされ、以前に保存したシークレットには **(unchanged)** と表示されます。保存済みの値を維持するには、フィールドを空欄のままにします。変更を保存すると、開いているセッションがプラグインを再読み込みし、ダイアログに **Restart Claude to apply plugin changes** と表示されます。

<h3 id="uninstall-plugins">
  プラグインをアンインストールする
</h3>

インストール済みの各行には、インストールされている[スコープ](/docs/ja/plugins/install#choose-an-install-scope)が表示されます。そのインストールをアンインストールするには、行のゴミ箱アイコンをクリックします。ゴミ箱アイコンが薄く表示されている行は、このワークスペースからアンインストールできないことを示します。たとえば、組織が管理しているプラグインや、別のプロジェクト用にインストールされたプラグインなどです。

拡張機能は、次の 2 つの場合に事前に確認します。

* **プロジェクトの共有 `.claude/settings.json` でオンになっているプラグイン**: **Disable for me** を選択すると、共同作業者のためにプラグインはインストールされたままになります。**Uninstall for everyone** を選択すると、[`--keep-data`](/docs/ja/plugins/cli-reference#what-an-uninstall-deletes-and-keeps) を指定してプロジェクトのインストールが削除されるため、プラグインの保存データディレクトリは残ります。すでに自分に対してプラグインをオフにしている場合は、ゴミ箱アイコンをクリックすると、確認なしで自分のインストールが削除されます。
* **それ以外で、保存データを持つプラグインの最後のインストール**: データを保持するか削除するかを選択します。デフォルトは **Keep** です

<h3 id="share-a-plugin-install-link">
  プラグインのインストールリンクを共有する
</h3>

特定のプラグインのインストール画面に直接誘導するには、拡張機能の `install-plugin` URL を渡します。このURLを開くと、VS Code が起動またはフォーカスされ、Claude Code パネルが開き、そのプラグインのスコープ選択画面で **Manage plugins** ダイアログが開きます。相手がスコープを選択するまで、何もインストールされません。プラグインのマーケットプレイスが相手の Claude Code でまだ設定されていない場合は、ダイアログでまずマーケットプレイスの追加を求められます。

```text theme={null}
vscode://anthropic.claude-code/install-plugin?plugin=code-review&marketplace=anthropics/claude-plugins-official
```

URL は 2 つのクエリパラメータを受け取ります。

| パラメータ | 説明 |
| - | - |
| `plugin` | マーケットプレイスに掲載されているプラグインの名前。必須。 |
| `marketplace` | マーケットプレイスの[ソース](/docs/ja/plugins/install#add-a-marketplace)。GitHub の `owner/repo`、`https://` URL、または `git@github.com:owner/repo.git` などの git SSH アドレスを指定します。省略した場合のデフォルトは `anthropics/claude-plugins-official` です。 |

拡張機能は、何かを開く前に両方の値をチェックします。

* **プラグイン名**: 最大 100 文字で、ASCII 英字または数字で始まり、それ以外は ASCII 英字、数字、`.`、`_`、`-` のみを使用する必要があります。
* **マーケットプレイスのソース**: `marketplace` パラメータに記載された形式のみが使用できます。ローカルパス、`http://` アドレス、`claude-plugins-official` のようなマーケットプレイス名は使用できません。`https://` URL にはユーザー名、パスワード、クエリ文字列を含めることはできません。
* **Git ref**: マーケットプレイスをブランチまたはタグに固定するには、`marketplace=owner/repo%23v1.0` のように、`#` をエンコードした形式である `%23` の後に ref をソースに追加します。エンコードされていない `#` を含むリンクは失敗します。`anthropics` GitHub 組織内のマーケットプレイスは、リンクで固定できません。

これらのルールに違反するリンクを開くと、`Invalid plugin installation URL` で始まるエラーが表示されます。Claude Code パネルとダイアログは開かず、何もインストールされません。プラグインの名前やマーケットプレイスをリンクに含められない場合は、**Marketplaces** タブでマーケットプレイスを追加してから **Plugins** タブでプラグインをインストールするよう案内してください。

次の場合は、スコープ選択画面ではなく、ダイアログ内のメッセージで終了します。

* **マーケットプレイスにその名前のプラグインが掲載されていない**: ダイアログに、プラグインが見つからなかったことが表示されます。`plugin` の値をマーケットプレイスの掲載内容と照らし合わせて確認してください。
* **プラグインがすでにインストールされている**: ダイアログにその旨が表示され、何も変更されません。
* **同じ名前の別のマーケットプレイスがすでに追加されている**: ダイアログに、リンクのマーケットプレイスが追加されなかったことが表示され、何もインストールされません。

GitHub の README や issue、その他一部の Markdown ホストでは、スキームが `http` または `https` ではないリンクが除去されるため、そこでは `vscode://` リンクがプレーンテキストとして表示されます。`claude-cli://` リンクについて[リンクがクリック可能にならずプレーンテキストとして表示される](/docs/ja/deep-links#the-link-renders-as-plain-text-instead-of-being-clickable)で説明しているとおり、これらのホストでは URL をコードブロックに入れてください。

<h3 id="manage-marketplaces">
  マーケットプレイスを管理する
</h3>

**Marketplaces** タブに切り替えて、プラグインのソースを追加または削除します。

* GitHub リポジトリ、URL、またはローカルパスを入力して、新しいマーケットプレイスを追加します
* 更新アイコンをクリックして、マーケットプレイスのプラグインリストを更新します
* ゴミ箱アイコンをクリックして、マーケットプレイスを削除します。削除すると[そこからインストールしたすべてのプラグインがアンインストールされる](/docs/ja/plugins/install#manage-marketplaces)ため、まず確認画面でそれらのプラグインが表示されます

ダイアログで行ったプラグインの変更は、その VS Code ウィンドウで開いている Claude Code セッションにすぐに適用されます。

ダイアログを開いたセッションがプラグインを再読み込みできない場合、ダイアログは再試行するか、そのセッションで Claude を再起動するかを提案します。

<Note>
  拡張機能は、CLI と同じコマンドを実行してプラグインを管理します。拡張機能で設定したプラグインとマーケットプレイスは CLI でも利用でき、その逆も同様です。
</Note>

プラグインシステムの詳細については、[プラグイン](/docs/ja/plugins/overview)と[プラグインマーケットプレイス](/docs/ja/plugins/overview)を参照してください。

<h3 id="plugins-that-draw-in-the-panel">
  パネルに描画するプラグイン
</h3>

[mod](/docs/ja/plugins/mods/overview) を含むプラグインは、チャットパネルに描画できます。描画には、拡張機能のバージョン 2.1.299 以降が必要です。Amazon Bedrock 上のセッションなど、[機能フラグを取得しない](/docs/ja/env-vars#features-that-need-feature-flag-fetching)セッションでは、2.1.304 以降が必要です。そのようなプラグインからは、次のものが表示されることがあります。

* 会話の横またはプロンプトボックスの上にあるペイン
* プロンプトボックスの上に表示されるトーストまたはステータスライン
* プラグイン独自の方法で描画されたメッセージまたはツール呼び出し

インストールしたプラグインがパネルに何かを追加または変更すると、次のようなフレーズでそのプラグイン名を示すラベルが表示されます。

* **From the token-chart plugin**: プラグインがこれを描画または出力した、あるいはこのカードはプラグインからの問いかけである
* **Edited by the token-chart plugin**: プラグインが、ツール呼び出しなど Claude Code が描画するものを変更した
* **Prompt from the token-chart plugin**: プラグインがユーザーに代わってこのメッセージを送信した

プラグインによる描画を停止するには、[プラグインダイアログ](#install-plugins)でそのプラグインをオフにします。

<h2 id="automate-browser-tasks-with-chrome">
  Chrome でブラウザタスクを自動化する
</h2>

Claude を Chrome ブラウザに接続すると、VS Code を離れることなく、Web アプリのテスト、コンソールログを使ったデバッグ、ブラウザワークフローの自動化を行えます。これには [Claude in Chrome 拡張機能](https://chromewebstore.google.com/detail/claude/fcoeoabgfenejglbffodgkkbkcdhcgfn)のバージョン 1.0.36 以降が必要です。

プロンプトボックスに `@browser` と入力し、続けて Claude に実行してほしい内容を入力します。

```text wrap theme={null}
@browser go to localhost:3000 and check the console for errors
```

添付メニューを開いて、新しいタブを開く、ページの内容を読み取るといった特定のブラウザツールを選択することもできます。

Claude はブラウザタスク用に新しいタブを開き、ブラウザのログイン状態を共有するため、すでにサインインしているサイトであればどこにでもアクセスできます。

ブラウザの操作について詳しくは、以下を参照してください。

* [デフォルトで Chrome を有効にする](/docs/ja/chrome#enable-chrome-by-default): `@browser` と入力しなくても、各セッションの開始時にブラウザへ接続するようにします
* [VS Code セッションでの権限プロンプト](/docs/ja/chrome#permission-prompts-in-vs-code-sessions): Claude Code がブラウザ操作の前に確認を求めるタイミング
* [Chrome で Claude Code を使用する](/docs/ja/chrome): セットアップ手順、機能の一覧、トラブルシューティング

<h2 id="work-with-git">
  git で作業する
</h2>

Claude Code は git と統合されており、VS Code 内で直接バージョン管理ワークフローをサポートします。Claude にコミット、プルリクエストの作成、またはブランチ間での作業を依頼できます。独立した worktree とそれ自身のファイルおよびブランチで Claude を開始するには、[worktrees を使用した並列セッションの実行](/docs/ja/worktrees)を参照してください。

<h3 id="create-commits-and-pull-requests">
  コミットとプルリクエストを作成する
</h3>

Claude はコミット、コミットメッセージの作成、および実装に基づいてプルリクエストを作成できます。

```text wrap theme={null}
commit my changes with a descriptive message
create a pr for this feature
summarize the changes I've made to the auth module
```

プルリクエストを作成する場合、Claude は実際のコード変更に基づいて説明を生成し、テストまたは実装の決定に関するコンテキストを追加できます。

<h2 id="run-work-in-the-background">
  バックグラウンドで作業を実行する
</h2>

長時間実行されるコマンドやサブエージェントをバックグラウンドに送り、プロンプトボックスから状況を確認します。

<h3 id="move-a-running-command-or-subagent-to-the-background">
  実行中のコマンドまたはサブエージェントをバックグラウンドに移動する
</h3>

コマンドや[サブエージェント](/docs/ja/sub-agents)のために Claude が想定以上に長く待機している場合は、会話内のそのツール呼び出しの下にある **Run in background** をクリックします。Claude Code v2.1.287 以降が必要です。

* **タイミング**：このアクションは、コマンドが約 2 秒間実行された時点、または Claude がメインの会話から起動した[サブエージェント](/docs/ja/sub-agents#run-subagents-in-foreground-or-background)の待機を開始した直後に表示されます。
* **クリック後**：Claude は待機をやめてターンを続行します。コマンドまたはサブエージェントは、完了時に Claude に通知する[バックグラウンドタスク](/docs/ja/tools-reference#background-commands)として実行を続けます。

その間にタスクを確認したり停止したりするには、プロンプトボックスに `/tasks` と入力して[エージェントマップ](#use-the-prompt-box)を開きます。サブエージェントはそこでエージェントツリー内の位置を保持し、コマンドはエージェントの下に一覧表示され、その[カードに最新の出力](#monitor-background-processes)が表示されます。

<h4 id="the-run-in-background-action-is-missing-under-a-subagent">
  サブエージェントの下に Run in background アクションが表示されない
</h4>

VS Code では、デフォルトでサブエージェントにこのアクションは表示されません。特定のサブエージェントについてその理由を確認するには、[エージェントマップ](#use-the-prompt-box)でそのカードを開き、`Spawned by` の行を確認します：

* **`Spawned by the main agent`**：サブエージェントはバックグラウンドで開始されたため、Claude はその完了を待っておらず、操作は必要ありません。代わりに Claude にサブエージェントを待機させるには、[Claude にサブエージェントを待機させる](/docs/ja/sub-agents#let-claude-wait-for-a-subagent)を参照してください。
* **`Spawned by` に別のサブエージェントの名前が表示される**：このアクションは、メインエージェントが起動したサブエージェントにのみ表示され、別のサブエージェントが待機している[ネストされたサブエージェント](/docs/ja/sub-agents#let-subagents-spawn-their-own-subagents)には表示されません。ネストされたサブエージェントを早期に終了するには、そのカードで **Stop agent** をクリックします。待機していたサブエージェントは、その結果なしで処理を続行します。

<h3 id="monitor-background-processes">
  バックグラウンドプロセスを監視する
</h3>

プロンプトボックスに `/tasks` と入力して[エージェントマップ](#use-the-prompt-box)を開くと、セッションのバックグラウンドタスク（Claude がバックグラウンドのシェルコマンドとして実行したままにした開発サーバーなど）が一覧表示されます。タスクをクリックするとそのカードが開き、そこでタスクを停止できます。Claude Code v2.1.277 以降が必要です。

バックグラウンドのシェルコマンド、またはコマンドを実行する[モニター](/docs/ja/tools-reference#monitor-tool)の場合、カードにはコマンドの最新の出力も表示され、コマンドの実行中は更新され続けます。

<h2 id="vs-code-commands-and-shortcuts">
  VS Code のコマンドとショートカット
</h2>

コマンドパレットを開くには、Mac では `Cmd+Shift+P`、Windows/Linux では `Ctrl+Shift+P` を押します。そこで「Claude Code」と入力すると、Claude Code 拡張機能で使用できるすべての VS Code コマンドが表示されます。

一部のショートカットは、どのパネルが「フォーカス」されているか（キーボード入力を受け付けているか）によって動作が変わります。カーソルがコードファイル内にあるときはエディターがフォーカスされています。カーソルが Claude のプロンプトボックス内にあるときは Claude がフォーカスされています。`Cmd+Esc` / `Ctrl+Esc` を使用して両者を切り替えます。

<Note>
  これらは拡張機能を操作するための VS Code コマンドです。Claude Code の組み込みコマンドのすべてが拡張機能で使用できるわけではありません。詳細については [VS Code 拡張機能と Claude Code CLI の比較](#vs-code-extension-vs-claude-code-cli)を参照してください。
</Note>

| コマンド | ショートカット | 説明 |
| - | - | - |
| Focus Input | `Cmd+Esc`（Mac）/ `Ctrl+Esc`（Windows/Linux） | エディターと Claude の間でフォーカスを切り替えます |
| Focus last message | - | キーボードフォーカスを会話内の最新のメッセージ、または待機中の権限プロンプトに移動し、そこからキーボードやスクリーンリーダーで読めるようにします。[ターミナルモード](#switch-to-terminal-mode)では使用できません。Claude Code v2.1.268 以降が必要です |
| Open in Side Bar | - | Claude をサイドバーで開きます |
| Open in Terminal | - | Claude をターミナルモードで開きます |
| Open in New Tab | `Cmd+Shift+Esc`（Mac）/ `Ctrl+Shift+Esc`（Windows/Linux） | 新しい会話をエディタータブとして開きます |
| Open in New Window | - | 新しい会話を別のウィンドウで開きます |
| New Conversation | `Cmd+N`（Mac）/ `Ctrl+N`（Windows/Linux） | 新しい会話を開始します。Claude がフォーカスされており、`enableNewConversationShortcut` が `true` に設定されている必要があります |
| Reopen Closed Session | `Cmd+Shift+T`（Mac）/ `Ctrl+Shift+T`（Windows/Linux） | 最後に閉じた Claude セッションタブを再度開きます。最後に閉じたタブが Claude セッションでなかった場合は、VS Code の通常の「閉じたエディターを再度開く」動作になります。`enableReopenClosedSessionShortcut` で無効にできます |
| Insert @-Mention Reference | `Option+K`（Mac）/ `Alt+K`（Windows/Linux） | 現在のファイルと選択範囲への参照を挿入します（エディターがフォーカスされている必要があります） |
| Accept Change at Cursor | - | [提案された編集を変更ごとにレビュー](#get-started)しているときに、カーソル位置の変更を承認します。Claude Code v2.1.275 以降が必要です |
| Reject Change at Cursor | - | 提案された編集を変更ごとにレビューしているときに、カーソル位置の変更を元に戻します。Claude Code v2.1.275 以降が必要です |
| Toggle Focus view | `Ctrl+Option+F`（Mac）/ `Ctrl+Alt+F`（Windows/Linux） | 会話内のツールのアクティビティを非表示または表示にします。Claude パネルまたはサイドバーが表示されている間に機能します。Claude Code v2.1.221 以降が必要です |
| Rename Session Tab | - | アクティブな Claude タブのセッション名を変更します。Claude Code v2.1.257 以降が必要です |
| Add Session Tab to Group | - | アクティブな Claude タブのセッションを、選択または作成した[セッショングループ](#organize-sessions-into-groups)に追加します。Claude Code v2.1.257 以降が必要です |
| Mark Session as Unread | - | アクティブな Claude タブのセッションを、セッション一覧で未読としてマークします。Claude Code v2.1.257 以降が必要です |
| Show Logs | - | 拡張機能のデバッグログを表示します |
| Logout | - | Anthropic アカウントからサインアウトします |

<h3 id="launch-a-vs-code-tab-from-other-tools">
  他のツールから VS Code タブを起動する
</h3>

拡張機能は `vscode://anthropic.claude-code/open` に URI ハンドラーを登録します。これを使用すると、シェルエイリアス、ブラウザーのブックマークレット、URL を開くことができる任意のスクリプトなど、独自のツールから新しい Claude Code タブを開くことができます。VS Code がまだ起動していない場合は、URL を開くとまず VS Code が起動します。VS Code がすでに起動している場合は、現在フォーカスされているウィンドウで URL が開きます。

オペレーティングシステムの URL オープナーを使用してハンドラーを呼び出します。

<Tabs>
  <Tab title="macOS">
    ```bash theme={null}
    open "vscode://anthropic.claude-code/open"
    ```
  </Tab>

  <Tab title="Linux">
    ```bash theme={null}
    xdg-open "vscode://anthropic.claude-code/open"
    ```

    `xdg-open` コマンドは `xdg-utils` パッケージに含まれています。シェルでコマンドが見つからないと報告された場合は、[Linux で xdg-open が見つからない](/docs/ja/deep-links#xdg-open-is-not-found-on-linux)を参照してください。
  </Tab>

  <Tab title="Windows">
    PowerShell の場合：

    ```powershell theme={null}
    Start-Process "vscode://anthropic.claude-code/open"
    ```

    `cmd.exe` では、`start` は最初の引用符付き引数をウィンドウタイトルとして扱うため、URL の前に空のタイトルを渡します。

    ```cmd theme={null}
    start "" "vscode://anthropic.claude-code/open"
    ```
  </Tab>
</Tabs>

ハンドラーは 2 つのオプションのクエリパラメーターを受け付けます。

| パラメーター | 説明 |
| - | - |
| `prompt` | プロンプトボックスに事前入力するテキスト。URL エンコードされている必要があります。プロンプトは事前入力されますが、自動的には送信されません。 |
| `session` | 新しい会話を開始する代わりに再開するセッション ID。セッションは VS Code で現在開いているワークスペースに属している必要があります。セッションが見つからない場合は、代わりに新しい会話が開始されます。セッションがすでにタブで開いている場合は、そのタブにフォーカスが移ります。セッション ID をプログラムで取得するには、[会話を続ける](/docs/ja/headless#continue-conversations)を参照してください。 |

たとえば、「review my changes」が事前入力されたタブを開くには次のようにします。

```text theme={null}
vscode://anthropic.claude-code/open?prompt=review%20my%20changes
```

拡張機能は `vscode://anthropic.claude-code/install-plugin` も処理します。これは[特定のプラグインを対象にプラグインダイアログを開きます](#share-a-plugin-install-link)。VS Code タブではなくターミナルセッションを起動するには、CLI の `claude-cli://` ハンドラーを使用します。[リンクからセッションを起動する](/docs/ja/deep-links)を参照してください。

<h2 id="configure-settings">
  設定を構成する
</h2>

拡張機能は、VS Code の拡張機能設定と Claude Code の設定ファイルの 2 か所で構成します。

* VS Code の**拡張機能設定**：VS Code 内での拡張機能の動作を制御します。`Cmd+,`（Mac）または `Ctrl+,`（Windows/Linux）で開き、**Extensions > Claude Code** に移動します。`/` と入力して **General config…** を選択して設定を開くこともできます。
* `~/.claude/settings.json` の **Claude Code 設定**：拡張機能と CLI の間で共有されます。許可するコマンド、環境変数、フック、MCP サーバーに使用します。Claude Code v2.1.283 以降では、会話が開始される権限モードを決める入力の 1 つにもなります。それより前のバージョンでは、Pro、Max、Team プランでのみ該当します。順序については[権限モードを切り替える](/docs/ja/permission-modes#switch-permission-modes)を参照してください。詳細は[設定](/docs/ja/settings)を参照してください。

<Tip>
  `settings.json` に `"$schema": "https://json.schemastore.org/claude-code-settings.json"` を追加すると、利用可能なすべての設定について、VS Code 上で直接オートコンプリートとインライン検証を利用できます。
</Tip>

<h3 id="extension-settings">
  拡張機能設定
</h3>

VS Code は `initialPermissionMode` をユーザー設定から読み取り、ワークスペースの値は無視します。v2.1.225 より前は、VS Code はこの設定のデフォルトを `default` とし、ワークスペースの値を適用していました。

| 設定 | デフォルト | 説明 |
| - | - | - |
| `useTerminal` | `false` | グラフィカルパネルの代わりにターミナルモードで Claude を起動します |
| `initialPermissionMode` | - | 新しい会話の承認プロンプトを制御します：`default`、`plan`、`acceptEdits`、または `bypassPermissions`。`manual` は `default` のエイリアスで、モードインジケーターで **Manual** と表示されるモードを選択します。未設定のままにすると、拡張機能は[権限モードを切り替える](/docs/ja/permission-modes#switch-permission-modes)で説明されているとおりに開始時の権限モードを選択します。 |
| `preferredLocation` | `panel` | Claude を開く場所：`sidebar`（右側）または `panel`（新しいタブ） |
| `lockEditorGroups` | `true` | [Claude がタブ用に開始したエディターグループをロック](#choose-where-claude-lives)し、Claude タブにフォーカスがある間に開いたファイルが別のグループで開くようにします。オフにすると、拡張機能はエディターグループを一切ロックしません。Claude Code v2.1.274 以降が必要です |
| `autosave` | `true` | Claude がファイルを読み書きする前にファイルを自動保存します |
| `attachOpenFile` | `true` | エディターで開いているファイルをメッセージに追加し、プロンプトボックスに表示します。オフにすると、選択したテキストのみが追加されます。Claude Code v2.1.271 以降が必要です |
| `useCtrlEnterToSend` | `false` | プロンプトの送信に Enter の代わりに Ctrl/Cmd+Enter を使用します |
| `scrollToBottomOnSend` | `true` | メッセージを送信したときに会話を最下部までスクロールします。オフにすると、会話は表示していた位置のままになります。Claude Code v2.1.275 以降が必要です |
| `showMessageTimestamps` | `true` | 各メッセージの送信日時を表示します。日付が変わる箇所には日付行が表示されます。Claude Code v2.1.284 以降が必要です。v2.1.290 より前はデフォルトが `false` でした |
| `spinnerVerbs` | `{"mode": "append", "verbs": []}` | ターンの実行中に会話のスピナーが順番に表示する動詞を設定します。CLI の [`spinnerVerbs`](/docs/ja/settings-reference#spinnerverbs) と同じ `mode` および `verbs` フィールドを使用します。 |
| `enableNewConversationShortcut` | `false` | Cmd/Ctrl+N で新しい会話を開始できるようにします |
| `enableReopenClosedSessionShortcut` | `true` | Cmd/Ctrl+Shift+T で、最後に閉じた Claude セッションタブを再度開きます。最後に閉じたタブが Claude セッションでない場合、このショートカットは代わりに VS Code の通常の「閉じたエディターを再度開く」コマンドを実行します。 |
| `archiveInactiveSessions` | `14` | アクティビティがないままこの日数が経過すると、[セッションを自動的にアーカイブ](#resume-past-conversations)します：`1`、`2`、`7`、または `14`。`0` に設定するとオフになります。Claude Code v2.1.265 以降が必要です |
| `continueAfterReload` | `true` | ウィンドウの再読み込み後、Claude は復元されたセッションで[中断されたステップを続行](#continue-conversations-after-a-reload)します。Claude Code v2.1.274 以降が必要です |
| `hideOnboarding` | `false` | オンボーディングチェックリスト（卒業帽アイコン）を非表示にします |
| `focusView` | `false` | ツール呼び出し、ツールの結果、思考を展開可能な行の中に隠し、ユーザーのプロンプトと Claude の応答だけを残します。Claude の最新の To-Do リストは表示されたままになります。これには Claude Code v2.1.225 以降が必要です。コマンドメニューから Focus view を切り替えることもできます。Claude Code v2.1.221 以降が必要です |
| `respectGitIgnore` | `true` | .gitignore のパターンをファイル検索および[選択コンテキスト](#reference-files-and-folders)から除外します |
| `usePythonEnvironment` | `true` | Claude の実行時にワークスペースの Python 環境をアクティブ化します。Python 拡張機能が必要です。 |
| `environmentVariables` | `[]` | Claude プロセスの環境変数を設定します。共有する構成には、代わりに Claude Code 設定を使用してください。[`CLAUDE_CONFIG_DIR`](/docs/ja/env-vars) のエントリは、値が絶対パスの場合にのみ適用されます。拡張機能は `~` を展開せず、相対パスの値は無視します。 |
| `disableLoginPrompt` | `false` | 認証プロンプトをスキップします（サードパーティプロバイダーの構成向け） |
| `allowDangerouslySkipPermissions` | `false` | モードセレクターに Bypass permissions を追加します。インターネットにアクセスできないサンドボックスでのみ使用してください。 |
| `claudeProcessWrapper` | - | Claude プロセスの起動に使用する実行ファイルです。バンドルされたバイナリのパスが存在する場合は、引数として渡されます。拡張機能のビルドにお使いのプラットフォーム用のバイナリが含まれていない場合は、別途インストールした `claude` バイナリを設定してください。 |

<h2 id="use-third-party-providers">
  サードパーティプロバイダーを使用する
</h2>

デフォルトでは、Claude Code は Anthropic の API に直接接続します。組織が Amazon Bedrock、Google Cloud の Agent Platform、または Microsoft Foundry を使用して Claude にアクセスしている場合は、代わりにそのプロバイダーを使用するように拡張機能を設定します。

<Steps>
  <Step title="ログインプロンプトを無効にする">
    [Disable Login Prompt 設定](vscode://settings/claudeCode.disableLoginPrompt)を開き、チェックボックスをオンにします。

    Mac では `Cmd+,`、Windows/Linux では `Ctrl+,` を押して VS Code の設定を開き、「Claude Code login」を検索して **Disable Login Prompt** をオンにすることもできます。
  </Step>

  <Step title="プロバイダーを設定する">
    使用しているプロバイダーのセットアップガイドに従ってください。

    * [Amazon Bedrock での Claude Code](/docs/ja/amazon-bedrock)
    * [Google Cloud の Agent Platform での Claude Code](/docs/ja/google-vertex-ai)
    * [Microsoft Foundry での Claude Code](/docs/ja/microsoft-foundry)

    これらのガイドでは、`~/.claude/settings.json` でプロバイダーを設定する方法を説明しています。これにより、設定が VS Code 拡張機能と CLI の間で共有されます。
  </Step>
</Steps>

サードパーティプロバイダーを使用している場合、プランの使用量バー、[音声入力](/docs/ja/voice-dictation)、[クラウドセッション](#resume-cloud-sessions-from-claude-ai)用の Web タブなど、claude.ai アカウントを必要とする機能は拡張機能で提供されません。これらのサインイン方法で Account & usage ダイアログに何が表示されるかについては、[アカウントと使用量を確認する](#check-account-and-usage)を参照してください。

以前の `/login` で残った claude.ai のサインインは使用されません。拡張機能はどのリクエストでもそれを送信しません。

<h2 id="use-a-screen-reader">
  スクリーンリーダーを使用する
</h2>

拡張機能のチャットパネルはスクリーンリーダーに対応しています。何かをオンにする必要はありません。拡張機能は、視覚的な変化を伴わずに、すべてのユーザーに対して会話のアクティビティを読み上げます。これは、ターミナルインターフェイスを調整する CLI のオプトイン方式の[スクリーンリーダーモード](/docs/ja/accessibility)とは別のものです。

チャットパネルでのスクリーンリーダーのサポートには、Claude Code v2.1.236 以降が必要です。

会話中、拡張機能は次の内容を読み上げます。

* **Claude の返信**: 拡張機能は各返信を完了時に 1 回だけ読み上げ、テキストのストリーミング中は何も読み上げません。スクリーンリーダーは、コードブロックを行数の要約として、リンクをラベルで、テーブルをセルごとに読み上げます。返信の全文はトランスクリプトで引き続き読むことができます。
* **権限リクエストと質問**: 拡張機能は、権限プロンプトが表示されたときに、Claude が使用しようとしているツール名を含めてリクエストを読み上げます。Claude がユーザーに質問したときや、Claude がプランを完成させてユーザーのレビューを待っているときも、同様に読み上げます。
* **ステータスの変化**: 拡張機能は、Claude が作業を開始したとき、Claude がユーザーの入力を受け付ける準備ができたとき、Claude Code が会話のコンパクト化を開始したときに読み上げます。
* **キューに入れられたメッセージ**: Claude の作業中にメッセージを送信すると、拡張機能はそのメッセージについて「Message queued.」と読み上げます。
* **エラーとモデルのプロンプト**: 拡張機能は会話中のエラーを読み上げるほか、[使用クレジットの同意プロンプト](/docs/ja/model-config#fable-and-usage-credits)や[フラグ付きリクエストのプロンプト](/docs/ja/model-config#ask-before-switching)が表示されたときにも読み上げます。

Claude の作業中は、スクリーンリーダーが進行状況スピナーのアニメーションの代わりにテキストラベルを読み上げます。

セッションを再度開いたり別のセッションに切り替えたりしたときは、拡張機能は何も読み上げません。復元された履歴、保留中の権限プロンプト、進行中のステータスは、新しいことが起きるまで読み上げられません。

<h3 id="use-the-chat-panel-from-the-keyboard">
  キーボードからチャットパネルを使用する
</h3>

トランスクリプト内の各ターンは、そのターンを開始したプロンプトでラベル付けされた、視覚的に非表示の見出しで始まります。スクリーンリーダーの見出しナビゲーションを使用して、ターン間を移動できます。

ターン内を移動すると、スクリーンリーダーは現在どちらのメッセージにいるかを読み上げます。

* **ユーザーのメッセージ**: 「You」
* **Claude のメッセージ**: 「Claude」
* **ツールのステップ**: 「Claude」とツール名（例: 「Claude, Bash」）
* **思考ブロック**: 「Claude, thinking」

拡張機能はトランスクリプトをラベル付きのリージョンとして公開しているため、`Tab` でトランスクリプト自体にフォーカスを移動し、自分のペースで読むこともできます。代わりに最新のメッセージや待機中の権限プロンプトにフォーカスを移動するには、[コマンドパレット](#vs-code-commands-and-shortcuts)から **Claude Code: Focus last message** を実行します。

権限プロンプトの選択肢が権限ルールやディレクトリアクセスを保存するものである場合、そのラベルの末尾には「all projects」や「this session」など、承認の保存先が示されます。保存先を変更するには、次のいずれかを行います。

* その選択肢にフォーカスした状態で、`Left` または `Right` の矢印キーを押します。拡張機能は、移動先の保存先をそれぞれ読み上げます。矢印キーを使用するには、Claude Code v2.1.268 以降が必要です。
* ラベル内の保存先をクリックします。

<h2 id="vs-code-extension-vs-claude-code-cli">
  VS Code 拡張機能と Claude Code CLI の比較
</h2>

Claude Code は、VS Code 拡張機能（グラフィカルパネル）と CLI（ターミナルのコマンドラインインターフェース）の両方で利用できます。一部の機能は CLI でのみ利用できます。CLI 専用の機能が必要な場合は、VS Code の統合ターミナルで `claude` を実行してください。これには [スタンドアロン CLI のインストール](/docs/ja/setup) が必要です。拡張機能は `claude` を PATH に追加しません。[VS Code で CLI を実行する](#run-cli-in-vs-code)を参照してください。

| 機能 | CLI | VS Code 拡張機能 |
| - | - | - |
| コマンドとスキル | [すべて](/docs/ja/commands) | 一部（`/` を入力すると利用可能なものを確認できます） |
| MCP サーバーの設定 | はい | はい：チャットパネルで `/mcp` を使用して[サーバーを追加・管理](#connect-to-external-tools-with-mcp)できます |
| チェックポイント | はい | はい |
| `!` Bash ショートカット | はい | いいえ |
| Tab 補完 | はい | いいえ |

<h3 id="run-cli-in-vs-code">
  VS Code で CLI を実行する
</h3>

VS Code から離れずに CLI を使用するには、Windows/Linux では `` Ctrl+` ``、Mac では `` Cmd+` `` を押して統合ターミナルを開き、`claude` を実行します。CLI は IDE と自動的に連携し、差分の表示や診断情報の共有などの機能を利用できます。外部ターミナルを使用する場合は、Claude Code 内で `/ide` を実行して VS Code に接続します。

拡張機能をインストールしても、`claude` はシェルの PATH に追加されません。拡張機能はチャットパネル用に CLI の専用コピーを同梱していますが、ターミナルで `claude` と入力するには [スタンドアロン CLI のインストール](/docs/ja/setup) が必要です。一度インストールすれば、`claude mcp add` や `claude --resume` を含むこのページのコマンドが任意のターミナルで動作します。インストール後も `claude` が見つからない場合は、[PATH を確認してください](/docs/ja/troubleshoot-install#verify-your-path)。

<h3 id="switch-between-extension-and-cli">
  拡張機能と CLI を切り替える
</h3>

拡張機能と CLI は同じ会話履歴を共有します。拡張機能での会話を CLI で続けるには、ターミナルで `claude --resume` を実行します。インタラクティブな選択画面が開き、会話を検索して選択できます。

<h2 id="connect-to-external-tools-with-mcp">
  MCP で外部ツールに接続する
</h2>

MCP（Model Context Protocol）サーバーは、Claude に外部ツール、データベース、API へのアクセスを提供します。

VS Code を離れずに MCP サーバーを管理するには、チャットパネルで `/mcp` と入力します。開いたダイアログから、次の操作を行えます。

* サーバーを追加する
* ローカル、ユーザー、またはプロジェクトの[スコープ](/docs/ja/mcp#mcp-installation-scopes)に保存されたサーバーを削除する
* サーバーを有効化または無効化する
* サーバーに再接続する
* OAuth 認証を管理する

ダイアログでサーバーを追加および削除するには、Claude Code v2.1.261 以降が必要です。

VS Code の統合ターミナル（`` Ctrl+` `` または `` Cmd+` ``）で `claude mcp add` を実行することもできます。ダイアログとターミナルのコマンドは同じ MCP 設定に保存され、どちらからの変更も、その後に開始する会話で有効になります。以下の例では、ヘッダーとして渡される[個人用アクセストークン](https://github.com/settings/personal-access-tokens)で認証する GitHub のリモート MCP サーバーを追加します。

```bash theme={null}
claude mcp add --transport http github https://api.githubcopilot.com/mcp/ \
  --header "Authorization: Bearer YOUR_GITHUB_PAT"
```

`YOUR_GITHUB_PAT` を個人用アクセストークンに置き換えてください。`claude mcp add` コマンドは認証情報を検証せずに設定を保存するため、ここではプレースホルダーの値も受け入れられますが、後でサーバーへの接続に失敗します。接続を確認するには、新しい会話を開始して `/mcp` と入力し、サーバーに **Connected** と表示されていることを確認します。認証情報が正しくないサーバーには **Failed** と表示されます。

設定が完了したら、Claude にツールを使用するよう依頼します（例：「Review PR #456」）。

<Note>接続するサーバーを見つけるには、[MCP サーバーを見つけてビルドする](/docs/ja/mcp#find-and-build-mcp-servers)を参照してください。</Note>

<h2 id="the-built-in-ide-mcp-server">
  組み込みの IDE MCP サーバー
</h2>

拡張機能が有効な間は、ローカルの MCP サーバーが実行され、CLI は自動的にそのサーバーに接続します。このサーバーを通じて、CLI は次のことを行います。

* VS Code のネイティブ差分ビューアーで差分を開く
* `@` メンションのために現在の選択範囲を読み取る
* Jupyter ノートブックで作業している場合に、VS Code にセルの実行を依頼する

このサーバーの名前は `ide` で、設定する項目が何もないため `/mcp` には表示されません。ただし、組織で `PreToolUse` フックを使用して MCP ツールの許可リストを管理している場合は、このサーバーの存在を把握しておく必要があります。

**選択範囲と開いているファイルのコンテキスト。** 接続中、CLI は送信する各プロンプトに、現在のエディターの選択範囲とアクティブなファイルのパスをコンテキストとして含めます。このとき、トランスクリプトには `⧉ Selected N lines from <file>` という行が表示されます。次の場合には、このコンテキストが変わります。

* **キューに入れたメッセージ**: [Claude の作業中にメッセージをキューに入れた](/docs/ja/interactive-mode#queue-messages-while-claude-works)場合、その後に何を選択しても、`Enter` を押した時点の選択範囲が保持されます。
* **機密ファイル**: `.env` などの機密ファイルを除外するには、そのパスに対する [`Read` 拒否ルール](/docs/ja/permissions#read-and-edit)を追加します。一致する拒否ルールがあると、そのファイルの選択テキストと開いているファイルの通知のどちらも Claude に届かなくなります。
* **Attach Open File がオフの場合**: [Attach Open File 設定](#extension-settings)をオフにすると、CLI はアクティブなファイル内でテキストを選択している間だけ、そのファイルのパスを受け取ります。

**トランスポートと認証。** サーバーは `127.0.0.1` の 10000〜65535 の範囲のランダムなポートにバインドされ、ポートは設定できません。トランスポートと認証トークンは次のように動作します。

* **トランスポート**: 暗号化されていない `ws://` です。ソケットはループバック専用であるため、通信を傍受できるプロセスであればロックファイルからトークンも読み取れます。そのため、TLS を使用しても保護は強化されません。
* **認証トークン**: 拡張機能が有効化されるたびに新しいランダムな認証トークンが生成され、`~/.claude/ide/<port>.lock` のロックファイルに書き込まれます。CLI が接続するには、このトークンを `X-Claude-Code-Ide-Authorization` ヘッダーとして提示する必要があります。
* **ロックファイルの権限**: ロックファイルは `0700` のディレクトリ内で `0600` の権限を持つため、VS Code を実行しているユーザーだけが読み取れます。`CLAUDE_CONFIG_DIR` が設定されている場合、ロックファイルは代わりに `$CLAUDE_CONFIG_DIR/ide/` に書き込まれます。

**モデルに公開されるツール。** サーバーは十数個のツールをホストしていますが、モデルから見えるのは 2 つだけです。残りは、差分を開く、選択範囲を読み取る、ファイルを保存するなど、CLI が自身の UI のために使用する内部 RPC です。これらはツールリストが Claude に届く前に除外されます。

| ツール名（フックから見た名前） | 機能 | 読み取り専用 |
| - | - | - |
| `mcp__ide__getDiagnostics` | 言語サーバーの診断情報（VS Code の Problems パネルに表示されるエラーと警告）を返します。必要に応じて 1 つのファイルに範囲を限定できます。 | はい |
| `mcp__ide__executeCode` | アクティブな Jupyter ノートブックのカーネルで Python コードを実行します。後述の確認フローを参照してください。 | いいえ |

**チャットパネルでの診断情報。** Claude Code v2.1.285 以降のチャットパネルでは、Claude は `claude-vscode` という名前の別の組み込みサーバーを通じて VS Code の Problems パネルを読み取ります。Claude は、1 つのファイル、または VS Code が診断情報を持つすべてのファイルについて、現在のエラーと警告をこのサーバーに問い合わせることができます。

フックと権限ルールからは、チャットパネルの診断ツールは `mcp__claude-vscode__getDiagnostics` として見えます。CLI とチャットパネルの両方の診断情報を対象にするには、フックまたはルールで `mcp__ide__getDiagnostics` と `mcp__claude-vscode__getDiagnostics` の両方を指定してください。

次の `settings.json` の例では、両方のツールを拒否しています。

```json theme={null}
{
  "permissions": {
    "deny": [
      "mcp__ide__getDiagnostics",
      "mcp__claude-vscode__getDiagnostics"
    ]
  }
}
```

`Read` 拒否ルールはどちらのツールにも適用されないため、この例のように[拒否ルール](/docs/ja/permissions#mcp)で名前を指定してブロックしてください。

**Jupyter での実行は必ず事前に確認されます。** `mcp__ide__executeCode` が何かを暗黙のうちに実行することはありません。各呼び出しは次の手順を経ます。

1. コードがアクティブなノートブックの末尾に新しいセルとして挿入されます。
2. VS Code がそのセルを表示位置までスクロールします。
3. ネイティブの Quick Pick で **Execute** または **Cancel** を選択するよう求められます。

キャンセルするか、`Esc` でピッカーを閉じると、Claude にエラーが返され、何も実行されません。また、アクティブなノートブックがない場合、Jupyter 拡張機能（`ms-toolsai.jupyter`）がインストールされていない場合、またはカーネルが Python でない場合、ツールは実行自体を拒否します。

<Note>
  Quick Pick による確認は `PreToolUse` フックとは別のものです。`mcp__ide__executeCode` を許可リストに登録すると、Claude はセルの実行を*提案*できるようになります。*実際に*実行できるようにするのは、VS Code 内の Quick Pick です。
</Note>

<a id="troubleshooting" />

<h2 id="fix-common-issues">
  よくある問題の解決
</h2>

サインイン、ネットワーク、起動時のエラーについては、インストールのトラブルシューティングページとエラーリファレンスページにそれぞれ専用の項目があります。表示された内容を表から探し、リンク先を参照してください。

| 表示される内容 | 参照先 |
| - | - |
| サインイン後に `API Error: 403 Request not allowed` が表示される | [403 Forbidden after login](/docs/ja/troubleshoot-install#403-forbidden-after-login) |
| すでにサインインしたのに再度サインインを求められる | [Not logged in or token expired](/docs/ja/troubleshoot-install#not-logged-in-or-token-expired) |
| クラウドプロバイダーの認証情報がターミナルでは機能するが拡張機能では機能しない | [Bedrock、Agent Platform、または Foundry の認証情報が読み込まれない](/docs/ja/troubleshoot-install#bedrock-agent-platform-or-foundry-credentials-not-loading) |
| `SSL certificate verification failed` または `Self-signed certificate detected` | [SSL 証明書エラー](/docs/ja/errors#ssl-certificate-errors) |
| `Claude Code process exited with code 1` またはその他のコード | [Claude Code process exited with code N](/docs/ja/errors#claude-code-process-exited-with-code-n) |
| `Could not locate the Claude CLI on PATH` | [Could not locate the Claude CLI on PATH](/docs/ja/errors#could-not-locate-the-claude-cli-on-path) |
| `The connection to Claude Code ended before this message completed` | [The connection to Claude Code ended before this message completed](/docs/ja/errors#the-connection-to-claude-code-ended-before-this-message-completed) |
| VS Code の統合ターミナルで `claude` が見つからない | [VS Code で CLI を実行する](#run-cli-in-vs-code) |

<h3 id="extension-won’t-install">
  拡張機能をインストールできない
</h3>

* 互換性のあるバージョンの VS Code（1.94.0 以降）を使用していることを確認してください
* VS Code に拡張機能をインストールする権限があることを確認してください
* [VS Code Marketplace](https://marketplace.visualstudio.com/items?itemName=anthropic.claude-code) から直接インストールしてみてください

<h3 id="spark-icon-not-visible">
  Spark アイコンが表示されない
</h3>

Spark アイコンは、ファイルを開いているときに **Editor Toolbar**（エディターの右上）に表示されます。表示されない場合は、次の手順を試してください。

1. **ファイルを開く**: アイコンを表示するにはファイルを開いている必要があります。フォルダーを開いているだけでは不十分です。
2. **VS Code のバージョンを確認する**: 1.94.0 以降が必要です。**Help > About** で確認してください
3. **VS Code を再起動する**: コマンドパレットから「Developer: Reload Window」を実行します
4. **競合する拡張機能を無効にする**: 他の AI 拡張機能（Cline、Continue など）を一時的に無効にします
5. **ワークスペースの信頼を確認する**: 拡張機能は制限モードでは動作しません

または、ウィンドウ右下の **Status Bar** にある **✻ Claude Code** をクリックします。この方法はファイルを開いていなくても機能します。**Command Palette**（`Cmd+Shift+P` / `Ctrl+Shift+P`）を使用して「Claude Code」と入力することもできます。

<h3 id="cmd-esc-does-nothing-on-macos">
  macOS で Cmd+Esc を押しても何も起こらない
</h3>

macOS Tahoe 以降では、システムの Game Overlay ショートカットがデフォルトで `Cmd+Esc` に割り当てられており、キー入力が VS Code に届く前に横取りされます。このショートカットを解放するには、次の手順を実行します。

1. システム設定を開きます
2. キーボード、キーボードショートカット、ゲームコントローラの順に移動します
3. Game Overlay のチェックボックスをオフにします

または、拡張機能を別のキーに割り当て直すこともできます。VS Code の [Keyboard Shortcuts エディター](https://code.visualstudio.com/docs/configure/keybindings)（`Cmd+K Cmd+S`）を開き、`Claude Code: Focus input` を検索して、新しいキーボードショートカットを割り当ててください。

<h3 id="a-resumed-conversation-is-blank-at-first">
  再開した会話が最初は空白になる
</h3>

[過去の会話を再開](#resume-past-conversations)したときや、会話が[リロード後に復元](#continue-conversations-after-a-reload)されたとき、その会話の Claude Code プロセスが起動している間はメッセージが空白のままになることがあります。約 1 秒後、空白部分に `Waiting for your plugins…` が表示されます。

何もする必要はありません。プロセスが起動し、事前にメッセージを確認する必要のあるプラグインがないことが確認されると、メッセージが表示されます。起動に時間がかかる場合は 20 秒後に表示されます。

<h3 id="the-panel-stops-responding-each-time-a-reload-reopens-a-conversation">
  リロードで会話が再度開かれるたびにパネルが応答しなくなる
</h3>

リロードして会話が復元されるたびに、パネル全体がクラッシュする、フリーズする、または `Something went wrong` のみが表示される場合は、拡張機能を v2.1.301 以降に更新してください。その後、もう一度ウィンドウをリロードするか VS Code を再起動します。会話を開く処理が 2 回連続で完了しなかった場合は、その会話の代わりに新しいチャットが開き、[会話が再度開かれなかった](#a-conversation-was-not-reopened)ことを示す通知が表示されます。

<h3 id="a-formula-shows-as-raw-latex">
  数式が LaTeX のまま表示される
</h3>

Claude の応答内の数式がまったく組版されない場合は、[数式のレンダリング](#latex-math-in-responses)にはバージョン 2.1.301 以降が必要なため、Extensions ビューで拡張機能のバージョンを確認してください。[ターミナルモード](#switch-to-terminal-mode)を使用している場合は、バージョンにかかわらず数式は組版されないため、[Use Terminal 設定](vscode://settings/claudeCode.useTerminal)のチェックを外して、Claude Code がチャットパネルで開くようにしてください。

周囲の数式は組版されているのに、1 つの数式だけが書かれたまま表示される場合は、次の原因を確認してください。

* **インライン数式がパネルで数式として扱われない**: 独立した行に置いた `$$` ブロックとしてもう一度送信するよう Claude に依頼してください。パネルは、`$…$` 区切り文字の間のテキストが次のいずれかに該当する場合、インライン数式を書かれたまま表示します。
  * 単純な算術式を超える内容なのに、`$O(n log n)$` のように、数式であることを示す `=`、`+`、`^` などの文字が含まれていない
  * `$30$` や `$1/N$` のように、数字で始まり、そのような文字が含まれていない
  * `$ x^2 $` のように、ドル記号の内側にスペースがある
  * 60 文字を超えている
  * 2 行にまたがっている。2 行にまたがる `\(…\)` の数式も組版されません。
* **数式に TeX の構文エラーがある**: エラーを修正して書き直すよう Claude に依頼してください。
* **数式でマクロを定義している**: `\newcommand` や `\def` などのマクロ定義を含む数式は、書かれたまま表示されます。マクロを使わずに書き直すよう Claude に依頼してください。
* **数式にエスケープされていない `%` が含まれている**: パーセント記号に `\%` を使って書き直すよう Claude に依頼してください。
* **数式が大きすぎる**: 8,192 文字を超える数式や、組版後の出力が TeX ソースよりもはるかに大きくなる数式は、書かれたまま表示されます。より小さな数式に分割するか、よりコンパクトに書くよう Claude に依頼してください。
* **数式が大量の数式の後にある**: 応答内の 1 つのテキストブロックでは、パネルは上限に達するまで数式を順番に組版します。上限を超える後続の数式は書かれたまま表示されます。必要な数式を単独でもう一度送信するよう Claude に依頼してください。

<h3 id="claude-code-never-responds">
  Claude Code がまったく応答しない
</h3>

Claude Code がプロンプトに応答しない場合は、次の手順を試してください。

1. **インターネット接続を確認する**: 安定したインターネット接続があることを確認してください
2. **新しい会話を開始する**: 新しい会話を開始して、問題が解消されないか確認してください
3. **CLI を試す**: ターミナルから `claude` を実行して、より詳細なエラーメッセージが表示されるか確認してください

問題が解決しない場合は、エラーの詳細を添えて [GitHub で issue を作成](https://github.com/anthropics/claude-code/issues)してください。

<h2 id="uninstall-the-extension">
  拡張機能のアンインストール
</h2>

Claude Code 拡張機能をアンインストールするには：

1. Mac では `Cmd+Shift+X`、Windows/Linux では `Ctrl+Shift+X` を押して拡張機能ビューを開きます
2. 「Claude Code」を検索します
3. **Uninstall** をクリックします

VS Code の統合ターミナルで `claude` を実行すると、Claude Code は拡張機能を自動的に再インストールします。アンインストールした状態を維持するには、`/config` で **Auto-install IDE extension** をオフにするか、[`autoInstallIdeExtension`](/docs/ja/settings-reference#autoinstallideextension) を `false` に設定します。また、[`CLAUDE_CODE_IDE_SKIP_AUTO_INSTALL`](/docs/ja/env-vars) 環境変数を `1` に設定することもできます。

拡張機能のデータも削除してすべての設定をリセットするには、使用しているプラットフォームに応じて拡張機能のストレージディレクトリを削除します。

macOS の場合：

```bash theme={null}
rm -rf ~/Library/"Application Support"/Code/User/globalStorage/anthropic.claude-code
```

Linux の場合：

```bash theme={null}
rm -rf ~/.config/Code/User/globalStorage/anthropic.claude-code
```

Windows の場合（PowerShell）：

```powershell theme={null}
Remove-Item -Recurse -Force "$env:APPDATA\Code\User\globalStorage\anthropic.claude-code"
```

その他のヘルプについては、[トラブルシューティングガイド](/docs/ja/troubleshooting)を参照してください。

<h2 id="next-steps">
  次のステップ
</h2>

VS Code で Claude Code のセットアップが完了したら、次のことを行いましょう：

* [一般的なワークフローを確認する](/docs/ja/common-workflows)ことで、Claude Code を最大限に活用できます
* [MCP サーバーをセットアップする](/docs/ja/mcp)ことで、外部ツールを使って Claude の機能を拡張できます。MCP サーバーの追加と管理は、チャットパネルで `/mcp` を使って行います。
* [Claude Code の設定を構成する](/docs/ja/settings)ことで、許可するコマンドやフックなどをカスタマイズできます。これらの設定は拡張機能と CLI の間で共有されます。
* Claude Code の[セキュリティ保護機能](/docs/ja/security)と[データの使用](/docs/ja/data-usage)を確認しましょう
