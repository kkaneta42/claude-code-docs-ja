> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# VS Code で Claude Code を使用する

> Claude Code 拡張機能を VS Code にインストールして設定します。インラインの差分表示、@-メンション、プラン確認、キーボードショートカットを使用した AI コーディング支援を取得します。

<img src="https://mintcdn.com/claude-code/-YhHHmtSxwr7W8gy/images/vs-code-extension-interface.jpg?fit=max&auto=format&n=-YhHHmtSxwr7W8gy&q=85&s=300652d5678c63905e6b0ea9e50835f8" alt="VS Code エディタの右側に Claude Code 拡張機能パネルが開いており、Claude との会話が表示されている" width="2500" height="1155" data-path="images/vs-code-extension-interface.jpg" />

VS Code 拡張機能は、Claude Code 用のネイティブグラフィカルインターフェースを提供し、IDE に直接統合されています。これは VS Code で Claude Code を使用する推奨方法です。

この拡張機能を使用すると、Claude のプランを受け入れる前に確認および編集でき、編集が行われるときに自動的に受け入れることができ、選択範囲から特定の行範囲を持つファイルを @-メンションでき、会話履歴にアクセスでき、複数の会話を別々のタブまたはウィンドウで開くことができます。

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

IDE のリンクをクリックして直接インストールします。

* [VS Code 用にインストール](vscode:extension/anthropic.claude-code)
* [Cursor 用にインストール](cursor:extension/anthropic.claude-code)

または、VS Code で `Cmd+Shift+X`（Mac）または `Ctrl+Shift+X`（Windows/Linux）を押して拡張機能ビューを開き、「Claude Code」を検索して、**インストール**をクリックします。

拡張機能は Devin Desktop や Kiro などの他の VS Code フォークにもインストールされます。エディタの拡張機能ビューで「Claude Code」を検索するか、[Open VSX レジストリ](https://open-vsx.org/extension/Anthropic/claude-code)からインストールしてください。エディタが拡張機能をインストールできない場合は、[CLI](/docs/ja/quickstart) をインストールして、統合ターミナルで `claude` を実行してください。CLI はどのターミナルでも動作します。

<Note>インストール後に拡張機能が表示されない場合は、VS Code を再起動するか、コマンドパレットから「Developer: Reload Window」を実行してください。</Note>

<h2 id="get-started">
  はじめに
</h2>

インストール後、VS Code インターフェースを通じて Claude Code の使用を開始できます。

<Steps>
  <Step title="Claude Code パネルを開く">
    VS Code 全体で、Spark アイコンは Claude Code を示します。<img src="https://mintcdn.com/claude-code/c5r9_6tjPMzFdDDT/images/vs-code-spark-icon.svg?fit=max&auto=format&n=c5r9_6tjPMzFdDDT&q=85&s=3ca45e00deadec8c8f4b4f807da94505" alt="Spark icon" style={{display: "inline", height: "0.85em", verticalAlign: "middle"}} width="16" height="16" data-path="images/vs-code-spark-icon.svg" />

    Claude を開く最も速い方法は、**エディタツールバー**（エディタの右上隅）の Spark アイコンをクリックすることです。このアイコンはファイルを開いている場合にのみ表示されます。

    <img src="https://mintcdn.com/claude-code/mfM-EyoZGnQv8JTc/images/vs-code-editor-icon.png?fit=max&auto=format&n=mfM-EyoZGnQv8JTc&q=85&s=eb4540325d94664c51776dbbfec4cf02" alt="VS Code エディタでエディタツールバーに表示された Spark アイコン" width="2796" height="734" data-path="images/vs-code-editor-icon.png" />

    Claude Code を開くその他の方法：

    * **アクティビティバー**：左サイドバーの Spark アイコンをクリックしてセッションリストを開きます。任意のセッションをクリックしてフルエディタタブとして開くか、新しいセッションを開始します。このアイコンはアクティビティバーに常に表示されます。
    * **コマンドパレット**：`Cmd+Shift+P`（Mac）または `Ctrl+Shift+P`（Windows/Linux）を押し、「Claude Code」と入力して、「Open in New Tab」などのオプションを選択します。
    * **ステータスバー**：[`preferredLocation`](#extension-settings) を `sidebar` に設定した場合、または **Claude Code: Open in Side Bar** で Claude を開いた場合、ウィンドウの右下隅の **✱ Claude Code** をクリックします。ファイルが開いていない場合でも機能します。

    Claude パネルをドラッグして VS Code 内の任意の場所に移動できます。詳細は [ワークフローをカスタマイズする](#customize-your-workflow) を参照してください。
  </Step>

  <Step title="サインイン">
    パネルを初めて開くと、サインイン画面が表示されます。**Sign in** をクリックしてブラウザで認可を完了します。

    後で **Not logged in · Please run /login** が表示される場合、拡張機能はサインイン画面を自動的に再度開きます。表示されない場合は、コマンドパレットから **Developer: Reload Window** でウィンドウをリロードします。

    シェルに `ANTHROPIC_API_KEY` が設定されているのにサインインプロンプトが表示される場合、VS Code がシェル環境を継承していない可能性があります。ターミナルから `code .` で VS Code を起動して環境変数を継承するか、代わりに Claude アカウントでサインインしてください。

    サインイン後、**Learn Claude Code** チェックリストが表示されます。**Show me** をクリックして各項目を実行するか、X で閉じます。後で再度開くには、VS Code 設定の Extensions → Claude Code で **Hide Onboarding** をオフにします。
  </Step>

  <Step title="プロンプトを送信する">
    コードやファイルについて Claude に支援を求めます。これは、何かの仕組みを説明すること、問題をデバッグすること、または変更を加えることなど、様々なことが含まれます。

    <Tip>Claude は自動的に選択したテキストを認識します。`Option+K`（Mac）/ `Alt+K`（Windows/Linux）を押して、@-mention 参照（`@file.ts#5-10` など）をプロンプトに挿入することもできます。</Tip>

    ファイル内の特定の行について質問する例を以下に示します。

    <img src="https://mintcdn.com/claude-code/FVYz38sRY-VuoGHA/images/vs-code-send-prompt.png?fit=max&auto=format&n=FVYz38sRY-VuoGHA&q=85&s=ede3ed8d8d5f940e01c5de636d009cfd" alt="VS Code エディタで Python ファイルの 2～3 行が選択されており、Claude Code パネルに @-mention 参照を含むそれらの行についての質問が表示されている" width="3288" height="1876" data-path="images/vs-code-send-prompt.png" />
  </Step>

  <Step title="変更を確認する">
    表示内容は、プロンプトボックスの下部に表示される [権限モード](/docs/ja/permission-modes#which-mode-a-session-starts-in) によって異なります。

    * Auto または Edit automatically モードでは、Claude はワークスペース内のほとんどのファイルを確認なしで編集します。
    * Manual モードでは、Claude がファイルを編集したい場合、元のコンテンツと提案された変更の並べて比較を表示し、権限を求めます。受け入れたり、拒否したり、代わりに Claude に何をするかを指示したりできます。受け入れる前に diff ビューで提案されたコンテンツを直接編集した場合、Claude はそれを修正したことが通知されるため、ファイルが元の提案と一致していると想定されません。

          <img src="https://mintcdn.com/claude-code/FVYz38sRY-VuoGHA/images/vs-code-edits.png?fit=max&auto=format&n=FVYz38sRY-VuoGHA&q=85&s=e005f9b41c541c5c7c59c082f7c4841c" alt="VS Code が Claude の提案された変更の diff を表示し、編集を行うかどうかを尋ねる権限プロンプトが表示されている" width="3292" height="1876" data-path="images/vs-code-edits.png" />
  </Step>
</Steps>

Claude Code でできることについてのアイデアについては、[一般的なワークフロー](/docs/ja/common-workflows) を参照してください。

<Tip>
  コマンドパレットから「Claude Code: Open Walkthrough」を実行して、基本的な機能のガイド付きツアーを表示します。
</Tip>

<h2 id="use-the-prompt-box">
  プロンプトボックスを使用する
</h2>

プロンプトボックスは複数の機能をサポートしています。

* **権限モード**: プロンプトボックスの下部にあるモード指示器をクリックして、権限モードを切り替えます。Pro、Max、Team プランでは、Auto がビルトイン開始権限モードです。[拡張機能が開始権限モードを選択する方法](/docs/ja/permission-modes#switch-permission-modes)と、指示器が提供するすべての権限モードについては、こちらを参照してください。
  * **Auto**: 分類器があなたに尋ねる代わりにほとんどのアクションをレビューします。[auto モード](/docs/ja/permission-modes#eliminate-prompts-with-auto-mode)で、それがレビューおよびブロックする内容を確認してください。
  * **Manual**: Claude はファイル編集とほとんどのシェルコマンドの前に権限を求めます。
  * **Plan**: Claude は実行する内容を説明し、変更を加える前に承認を待ちます。VS Code は自動的にプランを完全な Markdown ドキュメントとして開き、Claude が開始する前にフィードバックを提供するためにインラインコメントを追加できます。
  * **Edit automatically**: Claude は尋ねることなく編集を行います。
* **Model**: コマンドメニューから **Switch model…** を選択して、セッション中にモデルを変更します。プロンプトボックスの下部にあるモデル名をクリックして、同じピッカーを開くこともできます。現在のモデルが [effort levels](/docs/ja/model-config#adjust-effort-level) をサポートしている場合、ピッカーは **Effort** 行も表示します。モデル名ボタンと **Effort** 行には Claude Code v2.1.257 以降が必要です。
* **Command menu**: `/` をクリックするか `/` を入力してコマンドメニューを開きます。オプションには、ファイルの添付、モデルの切り替え、拡張思考の切り替えが含まれます。Customize セクションは MCP サーバー、slash commands、出力スタイル、hooks、メモリ、権限、プラグインへのアクセスを提供します。ターミナルアイコン付きのアイテムは統合ターミナルで開きます。
  * `/usage` や [`/remote-control`](/docs/ja/remote-control) などのコマンドを参照するには、Customize セクションで **Slash commands** を選択します。ダイアログはフィルターボックス付きでそれらをリストします。1 つを選択して実行します。プロンプトボックスで `/` を入力すると、引き続きコマンドをインラインで提案します。Claude Code v2.1.257 以降が必要です。
  * Customize セクションで **Output styles** を選択して、カスタムスタイルを含む [output style](/docs/ja/output-styles) を選択します。Claude Code v2.1.257 以降が必要です。

    代わりにカスタムスタイルを作成するには、**Output styles** メニューから **Build a custom style** を選択します。Claude Code はプロジェクトまたはユーザーレベルで [style file](/docs/ja/output-styles#create-a-custom-output-style) を作成します。Claude Code v2.1.261 以降が必要です。
  * Settings セクションには **Enable Remote Control for all sessions** が含まれており、これは [`remoteControlAtStartup`](/docs/ja/settings-reference#remotecontrolatstartup) を設定して、[新しいインタラクティブセッションが Remote Control に自動的に接続するかどうか](/docs/ja/remote-control#enable-remote-control-for-all-sessions)を制御します。Claude Code v2.1.203 以降が必要です。

    VS Code ウィンドウでトグルをオンまたはオフにすると、その変更は、その後に開始するセッションだけでなく、その VS Code ウィンドウで既に開いているセッションに適用されます。オフにすると、開いているセッションは切断されます。Claude Code v2.1.261 以降では、その変更は他の VS Code ウィンドウで開いているセッションにも到達します。
  * Settings セクションには **Focus view** も含まれており、これはツール呼び出し、ツール結果、思考を展開可能な行の背後に隠し、プロンプトと Claude の応答を残します。Claude の最新の to-do リストは表示されたままで、Claude からの保留中の質問が尋ねているテキストも表示されます。これには Claude Code v2.1.225 以降が必要です。そこでトグルするか、`Ctrl+Option+F`（Mac）/ `Ctrl+Alt+F`（Windows/Linux）で、またはコマンドパレットから **Claude Code: Toggle Focus view** で切り替えます。変更はすべての開いているセッションに適用され、セッション全体で保持されます。Claude Code v2.1.221 以降が必要です。
  * バグを報告するには、メニューの下部にある **Report a problem** をクリックするか、`/bug` または `/feedback` をオプションの説明と共に入力して、レポートに事前入力します。レポートを送信し、ファーストパーティ接続で Anthropic にサインインしている場合、Claude Code はそれを Anthropic に送信します。サードパーティプロバイダーまたは Anthropic 認証情報がない場合、ダイアログは引き続き開きますが、送信するとエラーが表示され、何も送信されません。CLI の `/bug` とは異なり、拡張機能はローカルアーカイブを作成しません。Claude Code v2.1.229 以降が必要です。
* **Side questions**: `/btw` の後に質問を入力して、[会話に追加せずに](/docs/ja/interactive-mode#side-questions-with-%2Fbtw)セッションについて質問します。答えはチャットの横のパネルで開き、そこでフォローアップ質問をすることができます。スレッドはウィンドウの再読み込みを生き残ります。Claude Code は最新の 20 回の交換を保持し、Claude Code が [安全に保持期間を決定できる](/docs/ja/claude-directory#cleaned-up-automatically)限り、[`cleanupPeriodDays`](/docs/ja/settings-reference#cleanupperioddays) スケジュールで保存されたスレッドを期限切れにします。スレッドをクリアするには、パネルのゴミ箱アイコンをクリックします。Claude Code v2.1.227 以降が必要です。
* **Context indicator**: プロンプトボックスは Claude のコンテキストウィンドウをどのくらい使用しているかを表示します。Claude は必要に応じて自動的にコンパクトにするか、`/compact` を手動で実行できます。
* **Extended thinking**: Claude が複雑な問題を推論するのに時間をかけることができます。コマンドメニュー（`/`）経由でオンに切り替えます。Claude の推論は会話に折りたたまれたブロックとして表示されます。ブロックをクリックして読むか、`Ctrl+O` を押してセッション内のすべての思考ブロックを展開または折りたたみます。詳細については、[Extended thinking](/docs/ja/model-config#extended-thinking) を参照してください。
* **Multi-line input**: `Shift+Enter` を押して、送信せずに新しい行を追加します。これは質問ダイアログの「Other」フリーテキスト入力でも機能します。

<h3 id="reference-files-and-folders">
  ファイルとフォルダを参照する
</h3>

@-mentions を使用して、特定のファイルまたはフォルダについて Claude にコンテキストを提供します。`@` の後にファイルまたはフォルダ名を入力すると、Claude はそのコンテンツを読み取り、それについて質問に答えたり、変更を加えたりできます。Claude Code はファジーマッチングをサポートしているため、部分的な名前を入力して必要なものを見つけることができます。

```text wrap theme={null}
Explain the logic in @auth (fuzzy matches auth.js, AuthService.ts, etc.)
What's in @src/components/ (include a trailing slash for folders)
```

大きな PDF の場合、ファイル全体ではなく特定のページを読むよう Claude に依頼できます。単一ページ、1～10 ページのような範囲、またはページ 3 以降のようなオープンエンド範囲です。

エディターでテキストを選択すると、Claude は強調表示されたコードを自動的に見ることができます。プロンプトボックスのフッターは、選択されている行数を表示します。`Option+K`（Mac）/ `Alt+K`（Windows/Linux）を押して、ファイルパスと行番号を含む @-mention を挿入します（例：`@app.ts#5-10`）。選択指示器をクリックして、Claude が強調表示されたテキストを見ることができるかどうかを切り替えます。目のスラッシュアイコンは、選択が Claude から隠されていることを意味します。

また、`Shift` を押しながらファイルをプロンプトボックスにドラッグして、添付ファイルとして追加することもできます。任意の添付ファイルの X をクリックして、コンテキストから削除します。

<h3 id="resume-past-conversations">
  過去の会話を再開する
</h3>

Claude Code パネルの上部にある **Session history** ボタンをクリックして、会話履歴にアクセスします。キーワードで検索するか、時間で参照できます。任意の会話をクリックして、完全なメッセージ履歴で再開します。セッションの再開の詳細については、[Manage sessions](/docs/ja/sessions) を参照してください。

新しいセッションは、最初のメッセージに基づいて AI が生成したタイトルを受け取ります。セッションの上にマウスを置くと、名前変更とアーカイブアクションが表示されます。説明的なタイトルを付けるために名前変更するか、リストの下部にある **Archived sessions** グループに移動するためにアーカイブします。

アーカイブされたセッションを復元するには、**Archived sessions** を展開して **Unarchive session** をクリックします。v2.1.257 より前では、アクションは **Delete session** でした。これはセッションを隠し、復元する方法がありませんでした。その後削除したセッションは、アップグレード後に **Archived sessions** の下に表示されます。

再開した会話が plan モードで終了した場合、Claude Code は plan モードを復元します。Claude Code v2.1.246 以降が必要です。Claude Code は 2 つのケースでは復元しません。

* 拡張機能が `claudeCode.initialPermissionMode` から [開始権限モードを選択](/docs/ja/permission-modes#switch-permission-modes)するか、以前の会話から引き継がれるピックがある
* `claudeCode.claudeProcessWrapper` が設定されている

<h3 id="resume-cloud-sessions-from-claude-ai">
  Claude.ai からクラウドセッションを再開する
</h3>

[Claude Code on the web](/docs/ja/claude-code-on-the-web) を使用している場合、それらのクラウドセッションを VS Code で直接再開できます。これには Anthropic Console ではなく、**Claude.ai Subscription** でサインインする必要があります。

<Steps>
  <Step title="Open session history">
    Claude Code パネルの上部にある **Session history** ボタンをクリックします。
  </Step>

  <Step title="Select the Web tab">
    ダイアログは 2 つのタブを表示します。Local と Web です。**Web** をクリックして claude.ai からのセッションを表示します。
  </Step>

  <Step title="Select a session to resume">
    クラウドセッションを参照または検索します。任意のセッションをクリックして、ダウンロードし、会話をローカルで続行します。
  </Step>
</Steps>

<Note>
  Web タブに表示されるのは、GitHub リポジトリで開始された Web セッションのみです。再開するとローカルに会話履歴が読み込まれます。変更は claude.ai に同期されません。
</Note>

<h3 id="check-account-and-usage">
  アカウントと使用状況を確認する
</h3>

`/usage` を実行して、Account & usage ダイアログを開きます。ダイアログは claude.ai サインインが必要なため、[サードパーティプロバイダー](#use-third-party-providers)では提供されません。サインインしたアカウント、プラン、現在のセッションと週の使用状況バーを表示します。各バーは、制限がリセットされるまでの時間を表示します。

ダイアログは、プラン制限に貢献しているものを詳細に説明します。キャッシュミス、長いコンテキスト、subagent が多い、または高度に並列なセッションなど、最近の使用状況の 10% 以上を占める動作にフラグを立てます。各動作には、それを削減するためのヒントが付いています。Attribution テーブルは、各スキル、subagent、プラグイン、MCP サーバーからどのくらいの使用状況が来たかを示します。Claude Code v2.1.174 以降が必要です。

Day と Week トグルを使用して、過去 24 時間と過去 7 日間を切り替えます。数値は概算であり、このマシン上のローカルセッションから計算されるため、他のデバイスまたは claude.ai からの使用状況は含まれません。使用状況の追跡と削減の詳細については、[Track your costs](/docs/ja/costs#track-your-costs) を参照してください。

<h2 id="customize-your-workflow">
  ワークフローをカスタマイズする
</h2>

Claude パネルの位置を変更したり、複数の会話を実行したり、セッションリストをグループに整理したり、ターミナルモードに切り替えたりできます。

<h3 id="choose-where-claude-lives">
  Claude の配置場所を選択する
</h3>

Claude パネルを VS Code 内の任意の場所に移動できます。パネルのタブまたはタイトルバーをつかんで、以下の場所にドラッグします。

* **セカンダリサイドバー**: ウィンドウの右側。コード作成中に Claude を表示したままにします。
* **プライマリサイドバー**: Explorer、Search などのアイコンがある左側のサイドバー。
* **エディタ領域**: Claude をファイルの横のタブとして開きます。サイドタスクに便利です。

<Tip>
  メイン Claude セッションにはサイドバーを使用し、サイドタスク用に追加タブを開きます。Claude は優先される場所を記憶します。アクティビティバーのセッションリストアイコンは Claude パネルとは別です。セッションリストは常にアクティビティバーに表示されますが、Claude パネルアイコンは左側のサイドバーにドッキングされている場合にのみそこに表示されます。
</Tip>

<h3 id="run-multiple-conversations">
  複数の会話を実行する
</h3>

コマンドパレットから **Open in New Tab** または **Open in New Window** を使用して、追加の会話を開始します。各会話は独自の履歴とコンテキストを保持し、異なるタスクを並行して処理できます。

タブを使用する場合、スパークアイコンの小さなカラーの点がステータスを示します。青は権限リクエストが保留中であることを意味し、オレンジはタブが非表示の間に Claude が完了したことを意味します。

<h3 id="organize-sessions-into-groups">
  セッションをグループに整理する
</h3>

アクティビティバーのセッションリストで、関連するセッションを名前付きの折りたたみ可能なグループに集めることができます。Claude Code v2.1.229 以降が必要です。

* **セッションをグループ化または非グループ化する**: セッションを右クリックしてそれからグループを作成したり、既存のグループに移動したり、グループから削除したりします。各セッションは一度に 1 つのグループに属するため、別のグループに移動すると最初のグループから削除されます。
* **複数のセッションを一度に移動する**: `Cmd` キー（Mac）/ `Ctrl` キー（Windows/Linux）を押しながら各セッションをクリックするか、`Shift` キーを押しながらクリックして範囲を選択してから、選択内容を右クリックします。
* **タブからセッションをグループ化する**: コマンドパレットから **Claude Code: Add Session Tab to Group** を実行するか、セッションのエディタタブを右クリックしてから、グループを選択または作成します。Claude Code v2.1.257 以降が必要です。
* **グループの名前を変更または削除する**: グループヘッダーを右クリックします。グループを削除するとグループのみが削除され、そのセッションは非グループ化されたリストに戻ります。

拡張機能はワークスペースフォルダごとにグループを保存するため、ウィンドウの再読み込み後も保持され、同じフォルダを開くすべてのウィンドウに表示されます。リストを検索すると、拡張機能はすべてのグループ全体で 1 つのフラットリストに一致するものを表示します。

<h3 id="switch-to-terminal-mode">
  ターミナルモードに切り替える
</h3>

デフォルトでは、拡張機能はグラフィカルチャットパネルを開きます。CLI スタイルのインターフェースを使用する場合は、[Use Terminal 設定](vscode://settings/claudeCode.useTerminal)を開いてチェックボックスをオンにします。

VS Code 設定（Mac では `Cmd+,`、Windows/Linux では `Ctrl+,`）を開き、Extensions → Claude Code に移動して、**Use Terminal** をチェックすることもできます。

<h2 id="manage-plugins">
  プラグインを管理する
</h2>

VS Code 拡張機能には、[プラグイン](/docs/ja/plugins)をインストールおよび管理するためのグラフィカルインターフェイスが含まれています。プロンプトボックスに `/plugins` と入力して、**プラグインを管理**インターフェイスを開きます。

<h3 id="install-plugins">
  プラグインをインストールする
</h3>

プラグインダイアログには、**プラグイン**と**マーケットプレイス**の 2 つのタブが表示されます。

プラグインタブでは、以下のことができます。

* **インストール済みプラグイン**がトップに表示され、トグルスイッチで有効または無効にできます
* 設定されたマーケットプレイスからの**利用可能なプラグイン**が下に表示されます
* 名前または説明でプラグインをフィルタリングするために検索します
* 利用可能なプラグインの**インストール**をクリックします

プラグインをインストールするときは、インストールスコープを選択します。

* **あなたのためにインストール**：すべてのプロジェクトで利用可能（ユーザースコープ）
* **このプロジェクトのためにインストール**：プロジェクト協力者と共有（プロジェクトスコープ）
* **ローカルにインストール**：このリポジトリのみ、あなただけ（ローカルスコープ）

<h3 id="manage-marketplaces">
  マーケットプレイスを管理する
</h3>

**マーケットプレイス**タブに切り替えて、プラグインソースを追加または削除します。

* GitHub リポジトリ、URL、またはローカルパスを入力して、新しいマーケットプレイスを追加します
* 更新アイコンをクリックして、マーケットプレイスのプラグインリストを更新します
* ゴミ箱アイコンをクリックして、マーケットプレイスを削除します

変更を加えた後、Claude Code を再起動して変更を適用するようにバナーが表示されます。

<Note>
  VS Code のプラグイン管理は、内部的に同じ CLI コマンドを使用しています。拡張機能で設定したプラグインとマーケットプレイスは CLI でも利用でき、その逆も同様です。
</Note>

プラグインシステムの詳細については、[プラグイン](/docs/ja/plugins)および[プラグインマーケットプレイス](/docs/ja/plugin-marketplaces)を参照してください。

<h2 id="automate-browser-tasks-with-chrome">
  Chrome でブラウザタスクを自動化する
</h2>

Claude を Chrome ブラウザに接続して、Web アプリをテストし、コンソールログでデバッグし、VS Code を離れることなくブラウザワークフローを自動化できます。これには [Claude in Chrome 拡張機能](https://chromewebstore.google.com/detail/claude/fcoeoabgfenejglbffodgkkbkcdhcgfn) バージョン 1.0.36 以上が必要です。

プロンプトボックスに `@browser` と入力し、その後に Claude に実行させたい内容を入力します。

```text wrap theme={null}
@browser go to localhost:3000 and check the console for errors
```

添付メニューを開いて、新しいタブを開く、ページコンテンツを読むなど、特定のブラウザツールを選択することもできます。

Claude はブラウザタスク用に新しいタブを開き、ブラウザのログイン状態を共有するため、既にサインインしているサイトにアクセスできます。

セットアップ手順、機能の完全なリスト、トラブルシューティングについては、[Claude Code を Chrome で使用する](/docs/ja/chrome) を参照してください。

<h2 id="vs-code-commands-and-shortcuts">
  VS Code コマンドとショートカット
</h2>

コマンドパレット（Mac では `Cmd+Shift+P`、Windows/Linux では `Ctrl+Shift+P`）を開いて「Claude Code」と入力すると、Claude Code 拡張機能で利用可能なすべての VS Code コマンドが表示されます。

一部のショートカットは、どのパネルが「フォーカス」されているか（キーボード入力を受け取っているか）によって異なります。カーソルがコードファイル内にある場合、エディターがフォーカスされています。カーソルが Claude のプロンプトボックス内にある場合、Claude がフォーカスされています。`Cmd+Esc` / `Ctrl+Esc` を使用して、それらを切り替えます。

<Note>
  これらは拡張機能を制御するための VS Code コマンドです。組み込みの Claude Code コマンドのすべてが拡張機能で利用可能なわけではありません。詳細については、[VS Code 拡張機能と Claude Code CLI](#vs-code-extension-vs-claude-code-cli) を参照してください。
</Note>

| コマンド                       | ショートカット                                               | 説明                                                                                                                                          |
| -------------------------- | ----------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------- |
| Focus Input                | `Cmd+Esc`（Mac）/ `Ctrl+Esc`（Windows/Linux）             | エディターと Claude 間のフォーカスを切り替えます                                                                                                                |
| Open in Side Bar           | -                                                     | Claude をサイドバーで開きます                                                                                                                          |
| Open in Terminal           | -                                                     | Claude をターミナルモードで開きます                                                                                                                       |
| Open in New Tab            | `Cmd+Shift+Esc`（Mac）/ `Ctrl+Shift+Esc`（Windows/Linux） | 新しい会話をエディタータブとして開きます                                                                                                                        |
| Open in New Window         | -                                                     | 新しい会話を別のウィンドウで開きます                                                                                                                          |
| New Conversation           | `Cmd+N`（Mac）/ `Ctrl+N`（Windows/Linux）                 | 新しい会話を開始します。Claude がフォーカスされており、`enableNewConversationShortcut` が `true` に設定されている必要があります                                                     |
| Reopen Closed Session      | `Cmd+Shift+T`（Mac）/ `Ctrl+Shift+T`（Windows/Linux）     | 最近閉じた Claude セッションタブを再度開きます。最後に閉じたタブが Claude セッションではない場合、VS Code の通常の再度開く機能にフォールスルーします。`enableReopenClosedSessionShortcut` で無効にできます         |
| Insert @-Mention Reference | `Option+K`（Mac）/ `Alt+K`（Windows/Linux）               | 現在のファイルと選択範囲への参照を挿入します（エディターがフォーカスされている必要があります）                                                                                             |
| Toggle Focus view          | `Ctrl+Option+F`（Mac）/ `Ctrl+Alt+F`（Windows/Linux）     | 会話内のツールアクティビティを非表示にするか表示します。Claude パネルまたはサイドバーが表示されている間に機能します。Claude Code v2.1.221 以降が必要です                                                  |
| Rename Session Tab         | -                                                     | アクティブな Claude タブのセッションの名前を変更します。このコマンドはタブの右クリックメニューにも表示されます。Claude Code v2.1.257 以降が必要です                                                    |
| Add Session Tab to Group   | -                                                     | アクティブな Claude タブのセッションを、選択または作成する[セッショングループ](#organize-sessions-into-groups)に追加します。このコマンドはタブの右クリックメニューにも表示されます。Claude Code v2.1.257 以降が必要です |
| Mark Session as Unread     | -                                                     | アクティブな Claude タブのセッションをセッションリストで未読としてマークします。このコマンドはタブの右クリックメニューにも表示されます。Claude Code v2.1.257 以降が必要です                                        |
| Show Logs                  | -                                                     | 拡張機能のデバッグログを表示します                                                                                                                           |
| Logout                     | -                                                     | Anthropic アカウントからサインアウトします                                                                                                                  |

<h3 id="launch-a-vs-code-tab-from-other-tools">
  他のツールから VS Code タブを起動する
</h3>

拡張機能は `vscode://anthropic.claude-code/open` で URI ハンドラーを登録します。これを使用して、独自のツール（シェルエイリアス、ブラウザーブックマークレット、または URL を開くことができるスクリプト）から新しい Claude Code タブを開きます。VS Code がまだ実行されていない場合、URL を開くと最初に起動します。VS Code が既に実行されている場合、URL は現在フォーカスされているウィンドウで開きます。

オペレーティングシステムの URL オープナーでハンドラーを呼び出します。

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

    `xdg-open` コマンドは `xdg-utils` パッケージから提供されます。シェルが見つからないと報告する場合は、[xdg-open is not found on Linux](/docs/ja/deep-links#xdg-open-is-not-found-on-linux) を参照してください。
  </Tab>

  <Tab title="Windows">
    PowerShell では：

    ```powershell theme={null}
    Start-Process "vscode://anthropic.claude-code/open"
    ```

    `cmd.exe` では、`start` は最初の引用符付き引数をウィンドウタイトルとして扱うため、URL の前に空のタイトルを渡します：

    ```cmd theme={null}
    start "" "vscode://anthropic.claude-code/open"
    ```
  </Tab>
</Tabs>

ハンドラーは 2 つのオプションのクエリパラメーターを受け入れます：

| パラメーター    | 説明                                                                                                                                                                                                                        |
| --------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `prompt`  | プロンプトボックスに事前入力するテキスト。URL エンコードされている必要があります。プロンプトは事前入力されますが、自動的には送信されません。                                                                                                                                                  |
| `session` | 新しい会話を開始する代わりに再開するセッション ID。セッションは、VS Code で現在開いているワークスペースに属している必要があります。セッションが見つからない場合は、代わりに新しい会話が開始されます。セッションが既にタブで開いている場合、そのタブがフォーカスされます。セッション ID をプログラムで取得するには、[会話を続ける](/docs/ja/headless#continue-conversations) を参照してください。 |

たとえば、「review my changes」で事前入力されたタブを開くには：

```text theme={null}
vscode://anthropic.claude-code/open?prompt=review%20my%20changes
```

VS Code タブの代わりにターミナルセッションを起動するには、CLI の `claude-cli://` ハンドラーを使用します。[リンクからセッションを起動する](/docs/ja/deep-links) を参照してください。

<h2 id="configure-settings">
  設定を構成する
</h2>

拡張機能には 2 つのタイプの設定があります。

* **VS Code の拡張機能設定**：VS Code 内での拡張機能の動作を制御します。`Cmd+,`（Mac）または `Ctrl+,`（Windows/Linux）で開き、Extensions → Claude Code に移動します。`/` を入力して **General Config** を選択して設定を開くこともできます。
* **`~/.claude/settings.json` の Claude Code 設定**：拡張機能と CLI 間で共有されます。許可されたコマンド、環境変数、hooks、MCP サーバーに使用します。Pro、Max、Team プランでは、権限モード会話が開始される入力の 1 つでもあります。[Switch permission modes](/docs/ja/permission-modes#switch-permission-modes) に順序が記載されています。詳細は [Settings](/docs/ja/settings) を参照してください。

<Tip>
  `settings.json` に `"$schema": "https://json.schemastore.org/claude-code-settings.json"` を追加して、VS Code 内で利用可能なすべての設定のオートコンプリートとインライン検証を取得します。
</Tip>

<h3 id="extension-settings">
  拡張機能設定
</h3>

VS Code は `initialPermissionMode` をユーザー設定から読み込み、ワークスペース値を無視します。v2.1.225 より前では、VS Code は設定をデフォルトの `default` に設定し、ワークスペース値を適用していました。

| 設定                                  | デフォルト   | 説明                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
| ----------------------------------- | ------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `useTerminal`                       | `false` | Claude をグラフィカルパネルではなくターミナルモードで起動します                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
| `initialPermissionMode`             | -       | 新しい会話の承認プロンプトを制御します：`default`、`plan`、`acceptEdits`、または `bypassPermissions`。`manual` は `default` のエイリアスで、モード指示器で **Manual** というラベルが付いたモードを選択します。設定を未設定のままにすると、拡張機能は [Switch permission modes](/docs/ja/permission-modes#switch-permission-modes) で説明されているように開始権限モードを選択します。                                                                                                                                                                                                                                                                                                         |
| `preferredLocation`                 | `panel` | Claude が開く場所：`sidebar`（右）または `panel`（新しいタブ）                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
| `autosave`                          | `true`  | Claude がファイルを読み取りまたは書き込みする前に自動保存します                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
| `useCtrlEnterToSend`                | `false` | Enter の代わりに Ctrl/Cmd+Enter を使用してプロンプトを送信します                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
| `enableNewConversationShortcut`     | `false` | Cmd/Ctrl+N を有効にして新しい会話を開始します                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
| `enableReopenClosedSessionShortcut` | `true`  | Cmd/Ctrl+Shift+T を使用して、最近閉じた Claude セッションタブを再度開きます。最後に閉じたタブが Claude セッションではなかった場合、ショートカットは VS Code の通常の再度開く閉じたエディターコマンドを実行します。                                                                                                                                                                                                                                                                                                                                                                                                                                               |
| `hideOnboarding`                    | `false` | オンボーディングチェックリスト（卒業帽アイコン）を非表示にします                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
| `focusView`                         | `false` | ツール呼び出し、ツール結果、思考を展開可能な行の背後に非表示にして、プロンプトと Claude の応答を残します。Claude の最新のやることリストは表示されたままです。これには Claude Code v2.1.225 以降が必要です。コマンドメニューから Focus ビューを切り替えることもできます。Claude Code v2.1.221 以降が必要です                                                                                                                                                                                                                                                                                                                                                                                       |
| `respectGitIgnore`                  | `true`  | ファイル検索から .gitignore パターンを除外します                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
| `usePythonEnvironment`              | `true`  | Claude を実行するときにワークスペースの Python 環境をアクティブにします。Python 拡張機能が必要です。                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
| `environmentVariables`              | `[]`    | Claude プロセスの環境変数を設定します。共有構成には Claude Code 設定を使用してください。                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
| `disableLoginPrompt`                | `false` | 認証プロンプトをスキップします（サードパーティプロバイダーのセットアップ用）                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
| `allowDangerouslySkipPermissions`   | `false` | モードセレクターに権限をバイパスを追加します。インターネットアクセスのないサンドボックスでのみ使用してください。                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
| `claudeProcessWrapper`              | -       | Claude プロセスを起動するために使用される実行可能ファイル。バンドルされたバイナリパスが存在する場合、引数として渡されます。プラットフォーム用のバイナリが拡張機能ビルドに含まれていない場合は、別途インストールされた `claude` バイナリに設定します。ラップされたセットアップでは、`initialPermissionMode` を設定するか、以前の会話で Manual、Edit automatically、または Auto を選択していない限り、会話は Manual モードで開始されます。これは、拡張機能が設定とビルトイン デフォルトステップをスキップするためです。[Switch permission modes](/docs/ja/permission-modes#switch-permission-modes) を参照してください。アクティベーション時の「Unsupported platform」エラーは、プラットフォーム用にバイナリがバンドルされていないことを意味します。[npm install 後にネイティブバイナリが見つからない](/docs/ja/troubleshoot-install#native-binary-not-found-after-npm-install) を参照してください。 |

<h2 id="use-a-screen-reader">
  スクリーンリーダーを使用する
</h2>

拡張機能のチャットパネルはスクリーンリーダーに対応しています。何も設定する必要はありません。拡張機能はすべてのユーザーの会話アクティビティを通知し、視覚的な変化はありません。これは CLI のオプトイン [スクリーンリーダーモード](/docs/ja/accessibility) とは別のもので、ターミナルインターフェースを適応させます。

チャットパネルのスクリーンリーダーサポートには Claude Code v2.1.236 以降が必要です。

会話中、拡張機能は以下を通知します。

* **Claude の返信**: 拡張機能は各返信が完了したときに 1 回通知し、テキストがストリーミングされている間は沈黙を保ちます。スクリーンリーダーはコードブロックを行数の概要として読み、リンクをラベルで読み、テーブルをセルごとに読みます。完全な返信はトランスクリプトで読み取り可能なままです。
* **権限リクエストと質問**: 拡張機能は権限プロンプトが表示されたときにリクエストを通知し、Claude が使用したいツールの名前を指定します。Claude があなたに質問するときと Claude がプランを完了してあなたのレビューを待つときも同じ方法で通知します。
* **ステータス変更**: 拡張機能は Claude が作業を開始したとき、Claude があなたの入力の準備ができたとき、および Claude Code が会話をコンパクト化し始めたときを通知します。
* **エラーとモデルプロンプト**: 拡張機能は会話内のエラーを通知し、[使用クレジット同意プロンプト](/docs/ja/model-config#fable-and-usage-credits) または [フラグ付きリクエストプロンプト](/docs/ja/model-config#ask-before-switching) が表示されたときを通知します。

トランスクリプト内の各ターンは、ターンを開始したプロンプトでラベル付けされた視覚的に隠されたヘッディングで始まるため、スクリーンリーダーのヘッディングナビゲーションを使用してターン間をジャンプできます。`Tab` でトランスクリプト自体にフォーカスを移動することもできます。拡張機能はそれをラベル付きリージョンとして公開しており、自分のペースで読むことができます。Claude が作業している間、スクリーンリーダーはプログレススピナーのアニメーションの代わりにテキストラベルを読みます。

セッションを再度開くか別のセッションに切り替えると、拡張機能は何も通知しません。復元された履歴、保留中の権限プロンプト、および進行中のステータスは、新しいことが発生するまで沈黙を保ちます。

<h2 id="vs-code-extension-vs-claude-code-cli">
  VS Code 拡張機能と Claude Code CLI
</h2>

Claude Code は VS Code 拡張機能（グラフィカルパネル）と CLI（ターミナルのコマンドラインインターフェース）の両方で利用できます。一部の機能は CLI でのみ利用可能です。CLI のみの機能が必要な場合は、VS Code の統合ターミナルで `claude` を実行してください。これには[スタンドアロン CLI インストール](/docs/ja/setup)が必要です。拡張機能は `claude` を PATH に追加しません。[VS Code で CLI を実行する](#run-cli-in-vs-code)を参照してください。

| 機能               | CLI                 | VS Code 拡張機能                                                               |
| ---------------- | ------------------- | -------------------------------------------------------------------------- |
| コマンドとスキル         | [すべて](/docs/ja/commands) | サブセット（`/` を入力して利用可能なものを表示）                                                 |
| MCP サーバー設定       | はい                  | はい（チャットパネルで `/mcp` を使用して[サーバーを追加・管理](#connect-to-external-tools-with-mcp)） |
| チェックポイント         | はい                  | はい                                                                         |
| `!` bash ショートカット | はい                  | いいえ                                                                        |
| タブ補完             | はい                  | いいえ                                                                        |

<h3 id="rewind-with-checkpoints">
  チェックポイントでの巻き戻し
</h3>

VS Code 拡張機能はチェックポイントをサポートしており、Claude のファイル編集を追跡し、以前の状態に巻き戻すことができます。任意のメッセージにマウスを置くと巻き戻しボタンが表示されます。その後、3 つのオプションから選択します。

* **ここから会話をフォークする**：このメッセージからの新しい会話ブランチを開始し、すべてのコード変更はそのまま保持します
* **ここまでコードを巻き戻す**：会話履歴全体を保持しながら、ファイル変更をこのポイントまで戻します
* **会話をフォークしてコードを巻き戻す**：新しい会話ブランチを開始し、ファイル変更をこのポイントまで戻します

チェックポイントの仕組みと制限事項の詳細については、[チェックポイント](/docs/ja/checkpointing)を参照してください。

<h3 id="run-cli-in-vs-code">
  VS Code で CLI を実行する
</h3>

VS Code に留まりながら CLI を使用するには、統合ターミナルを開き（Windows/Linux では `` Ctrl+` ``、Mac では `` Cmd+` ``）、`claude` を実行します。CLI は diff 表示と診断共有などの機能のために IDE と自動的に統合されます。

拡張機能をインストールしても、`claude` がシェル PATH に追加されません。拡張機能はチャットパネル用に CLI のプライベートコピーをバンドルしていますが、ターミナルで `claude` を入力するには[スタンドアロン CLI インストール](/docs/ja/setup)が必要です。インストールを 1 回実行すると、このページのコマンド（`claude mcp add` や `claude --resume` を含む）は任意のターミナルで機能します。インストール後も `claude` が見つからない場合は、[PATH を確認](/docs/ja/troubleshoot-install#verify-your-path)してください。

外部ターミナルを使用している場合は、Claude Code 内で `/ide` を実行して VS Code に接続します。

<h3 id="switch-between-extension-and-cli">
  拡張機能と CLI の間で切り替える
</h3>

拡張機能と CLI は同じ会話履歴を共有します。拡張機能の会話を CLI で続行するには、ターミナルで `claude --resume` を実行します。これにより、会話を検索して選択できるインタラクティブピッカーが開きます。

<h3 id="include-terminal-output-in-prompts">
  プロンプトにターミナル出力を含める
</h3>

プロンプトで `@terminal:name` を使用してターミナル出力を参照します。ここで `name` はターミナルのタイトルです。これにより、Claude はコマンド出力、エラーメッセージ、またはログをコピー＆ペーストなしで確認できます。

<h3 id="monitor-background-processes">
  バックグラウンドプロセスを監視する
</h3>

拡張機能でのバックグラウンドタスクの可視性は CLI と比較して限定的です。より良い可視性を得るには、Claude にコマンドを出力させて、VS Code の統合ターミナルで実行します。

<h3 id="connect-to-external-tools-with-mcp">
  MCP を使用して外部ツールに接続する
</h3>

MCP（Model Context Protocol）サーバーは Claude に外部ツール、データベース、API へのアクセスを提供します。

VS Code を離れずに MCP サーバーを管理するには、チャットパネルで `/mcp` を入力します。開いたダイアログから、サーバーを追加したり、ローカル、ユーザー、またはプロジェクト[スコープ](/docs/ja/mcp#mcp-installation-scopes)に保存されたサーバーを削除したり、サーバーを有効または無効にしたり、サーバーに再接続したり、OAuth 認証を管理したりできます。ダイアログでサーバーを追加・削除するには Claude Code v2.1.261 以降が必要です。

VS Code の統合ターミナル（`` Ctrl+` `` または `` Cmd+` ``）で `claude mcp add` を実行することもできます。ダイアログとターミナルコマンドは同じ MCP 設定に保存され、どちらからの変更も、その後に開始する会話に反映されます。以下の例は GitHub のリモート MCP サーバーを追加します。このサーバーは、ヘッダーとして渡される[個人用アクセストークン](https://github.com/settings/personal-access-tokens)で認証します。

```bash theme={null}
claude mcp add --transport http github https://api.githubcopilot.com/mcp/ \
  --header "Authorization: Bearer YOUR_GITHUB_PAT"
```

`YOUR_GITHUB_PAT` を個人用アクセストークンに置き換えます。`claude mcp add` コマンドは認証情報を検証せずに設定を保存するため、ここではプレースホルダー値が受け入れられますが、サーバーは後で接続に失敗します。接続を確認するには、新しい会話を開始し、`/mcp` を入力して、サーバーが**接続済み**と表示されていることを確認します。認証情報が不正なサーバーは**失敗**と表示されます。

設定後、Claude にツールを使用するよう依頼します（例：「PR #456 をレビューしてください」）。

接続するサーバーを見つけるには、[MCP サーバーを検索・構築する](/docs/ja/mcp#find-and-build-mcp-servers)を参照してください。

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

<h2 id="use-third-party-providers">
  サードパーティプロバイダーを使用する
</h2>

デフォルトでは、Claude Code は Anthropic の API に直接接続します。組織が Amazon Bedrock、Google Cloud の Agent Platform、または Microsoft Foundry を使用して Claude にアクセスしている場合は、代わりにプロバイダーを使用するように拡張機能を設定してください。

<Steps>
  <Step title="ログインプロンプトを無効化する">
    [ログインプロンプトを無効化する設定](vscode://settings/claudeCode.disableLoginPrompt)を開き、チェックボックスをオンにします。

    VS Code の設定（Mac では `Cmd+,`、Windows/Linux では `Ctrl+,`）を開き、「Claude Code login」を検索して、**ログインプロンプトを無効化する**をオンにすることもできます。
  </Step>

  <Step title="プロバイダーを設定する">
    プロバイダーのセットアップガイドに従ってください。

    * [Amazon Bedrock 上の Claude Code](/docs/ja/amazon-bedrock)
    * [Google Cloud の Agent Platform 上の Claude Code](/docs/ja/google-vertex-ai)
    * [Microsoft Foundry 上の Claude Code](/docs/ja/microsoft-foundry)

    これらのガイドでは、`~/.claude/settings.json` でプロバイダーを設定する方法について説明しており、VS Code 拡張機能と CLI の間で設定が共有されることを保証します。
  </Step>
</Steps>

サードパーティプロバイダーでは、拡張機能は claude.ai アカウントが必要な機能（使用状況の追跡、[音声入力](/docs/ja/voice-dictation)、[クラウドセッション](#resume-cloud-sessions-from-claude-ai)用の Web タブなど）を提供しません。以前の `/login` から残された claude.ai サインインは未使用のままです。拡張機能はリクエストと共にそれを送信しません。

<h2 id="security-and-privacy">
  セキュリティとプライバシー
</h2>

あなたのコードはプライベートです。Claude Code はあなたのコードを処理して支援を提供しますが、モデルの訓練に使用することはありません。データ処理の詳細とログ記録をオプトアウトする方法については、[データとプライバシー](/docs/ja/data-usage)を参照してください。

自動編集権限が有効になっている場合、Claude Code は VS Code が自動的に実行する可能性のある VS Code 設定ファイル（`settings.json` や `tasks.json` など）を変更できます。信頼できないコードを操作する場合のリスクを軽減するには、以下の対策を講じてください。

* 信頼できないワークスペースに対して [VS Code Restricted Mode](https://code.visualstudio.com/docs/editor/workspace-trust#_restricted-mode) を有効にする
* 自動編集または自動の代わりに Manual モードを使用する
* 変更を受け入れる前に慎重に確認する

<h3 id="the-built-in-ide-mcp-server">
  組み込み IDE MCP サーバー
</h3>

拡張機能がアクティブな場合、CLI が自動的に接続するローカル MCP サーバーが実行されます。これにより、CLI は VS Code のネイティブ diff ビューアーで diff を開き、`@` メンションの現在の選択を読み取り、Jupyter ノートブックで作業している場合はセルを実行するよう VS Code に要求できます。

サーバーは `ide` という名前で、設定するものがないため `/mcp` から非表示になっています。ただし、組織が MCP ツールをホワイトリストに登録するために `PreToolUse` フックを使用している場合は、それが存在することを知っておく必要があります。

**選択とオープンファイルコンテキスト。** 接続中、CLI は現在のエディター選択とアクティブファイルのパスを、送信する各プロンプトのコンテキストとして含めます。トランスクリプトには、これが発生したときに `⧉ Selected N lines from <file>` という行が表示されます。`.env` などの機密ファイルを除外するには、そのパスに対して [`Read` 拒否ルール](/docs/ja/permissions#read-and-edit)を追加してください。一致する拒否ルールは、そのファイルの選択されたテキストとオープンファイル通知の両方が Claude に到達するのを防ぎます。

**トランスポートと認証。** サーバーは `127.0.0.1` の 10000～65535 の範囲内のランダムポートにバインドされ、ポートは設定できません。トランスポートは暗号化されていない `ws://` です。ソケットはループバックのみであるため、トラフィックをキャプチャできるプロセスはロックファイルからトークンを読み取ることもできるため、TLS は保護を追加しません。各拡張機能のアクティベーションは新しいランダム認証トークンを生成し、`~/.claude/ide/<port>.lock` のロックファイルに書き込み、CLI は `X-Claude-Code-Ide-Authorization` ヘッダーとして提示して接続する必要があります。ロックファイルは `0700` ディレクトリ内で `0600` 権限を持つため、VS Code を実行しているユーザーのみがそれを読み取ることができます。`CLAUDE_CONFIG_DIR` が設定されている場合、ロックファイルは代わりに `$CLAUDE_CONFIG_DIR/ide/` に書き込まれます。

**モデルに公開されるツール。** サーバーは 12 個のツールをホストしていますが、モデルに表示されるのは 2 つだけです。残りは CLI が独自の UI（diff を開く、選択を読み取る、ファイルを保存する）に使用する内部 RPC であり、ツールリストが Claude に到達する前にフィルタリングされます。

| ツール名（フックで表示される）            | 機能                                                                     | 読み取り専用 |
| -------------------------- | ---------------------------------------------------------------------- | ------ |
| `mcp__ide__getDiagnostics` | 言語サーバー診断（VS Code の Problems パネルのエラーと警告）を返します。オプションで 1 つのファイルにスコープできます。 | はい     |
| `mcp__ide__executeCode`    | アクティブな Jupyter ノートブックのカーネルで Python コードを実行します。以下の確認フローを参照してください。        | いいえ    |

**Jupyter 実行は常に最初に確認します。** `mcp__ide__executeCode` は何もサイレントに実行することはできません。各呼び出しで、コードはアクティブなノートブックの最後に新しいセルとして挿入され、VS Code がそれをビューにスクロールし、ネイティブ Quick Pick が **Execute** または **Cancel** を求めます。キャンセルするか、`Esc` でピッカーを閉じると、Claude にエラーが返され、何も実行されません。また、アクティブなノートブックがない場合、Jupyter 拡張機能（`ms-toolsai.jupyter`）がインストールされていない場合、またはカーネルが Python でない場合、ツールは完全に拒否します。

<Note>
  Quick Pick 確認は `PreToolUse` フックとは別です。`mcp__ide__executeCode` のホワイトリストエントリにより、Claude はセルの実行を *提案* できます。VS Code 内の Quick Pick は、実際に実行できるようにするものです。
</Note>

<a id="troubleshooting" />

<h2 id="fix-common-issues">
  一般的な問題を解決する
</h2>

<h3 id="extension-won’t-install">
  拡張機能がインストールできない
</h3>

* VS Code の互換性のあるバージョン（1.94.0 以降）があることを確認してください
* VS Code に拡張機能をインストールする権限があることを確認してください
* [VS Code Marketplace](https://marketplace.visualstudio.com/items?itemName=anthropic.claude-code) から直接インストールしてみてください

<h3 id="spark-icon-not-visible">
  Spark アイコンが表示されない
</h3>

Spark アイコンは、ファイルを開いているときに **Editor Toolbar**（エディタの右上）に表示されます。表示されない場合は、以下の手順を実行してください。

1. **ファイルを開く**：アイコンを表示するにはファイルを開く必要があります。フォルダを開いているだけでは不十分です。
2. **VS Code のバージョンを確認する**：1.94.0 以降が必要です（Help → About）
3. **VS Code を再起動する**：コマンドパレットから「Developer: Reload Window」を実行してください
4. **競合する拡張機能を無効にする**：他の AI 拡張機能（Cline、Continue など）を一時的に無効にしてください
5. **ワークスペースの信頼を確認する**：拡張機能は制限モードでは動作しません

または、[`preferredLocation`](#extension-settings) を `sidebar` に設定している場合、または **Claude Code: Open in Side Bar** で Claude を開いている場合は、**Status Bar**（右下隅）の「✱ Claude Code」をクリックしてください。これはファイルを開いていなくても動作します。**Command Palette**（`Cmd+Shift+P` / `Ctrl+Shift+P`）を使用して「Claude Code」と入力することもできます。

<h3 id="cmd-esc-does-nothing-on-macos">
  macOS で Cmd+Esc が機能しない
</h3>

macOS Tahoe 以降では、システムの Game Overlay ショートカットがデフォルトで `Cmd+Esc` にバインドされており、VS Code に到達する前にキープレスをインターセプトします。ショートカットを解放するには、以下の手順を実行してください。

1. System Settings を開く
2. Keyboard、Keyboard Shortcuts、Game Controllers の順に移動する
3. Game Overlay チェックボックスをクリアする

または、拡張機能を別のキーにリバインドしてください。VS Code の [Keyboard Shortcuts editor](https://code.visualstudio.com/docs/configure/keybindings)（`Cmd+K Cmd+S`）を開き、`Claude Code: Focus input` を検索して、新しいバインディングを割り当ててください。

<h3 id="claude-code-never-responds">
  Claude Code が応答しない
</h3>

Claude Code がプロンプトに応答しない場合は、以下の手順を実行してください。

1. **インターネット接続を確認する**：安定したインターネット接続があることを確認してください
2. **新しい会話を開始する**：新しい会話を開始して、問題が解決するかどうかを確認してください
3. **CLI を試す**：ターミナルから `claude` を実行して、より詳細なエラーメッセージが表示されるかどうかを確認してください

問題が解決しない場合は、[GitHub で issue を報告してください](https://github.com/anthropics/claude-code/issues)。エラーの詳細を含めてください。

<h2 id="uninstall-the-extension">
  拡張機能をアンインストールする
</h2>

Claude Code 拡張機能をアンインストールするには：

1. 拡張機能ビューを開きます（Mac では `Cmd+Shift+X`、Windows/Linux では `Ctrl+Shift+X`）
2. 「Claude Code」を検索します
3. **アンインストール** をクリックします

VS Code の統合ターミナルで `claude` を実行すると、Claude Code は拡張機能を自動的に再インストールします。拡張機能をインストールされたままにしないようにするには、`/config` で **Auto-install IDE extension** をオフにするか、[`autoInstallIdeExtension`](/docs/ja/settings-reference#autoinstallideextension) を `false` に設定します。また、[`CLAUDE_CODE_IDE_SKIP_AUTO_INSTALL`](/docs/ja/env-vars) 環境変数を `1` に設定することもできます。

拡張機能のデータを削除してすべての設定をリセットするには、プラットフォーム用の拡張機能のストレージディレクトリを削除します。

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

詳細なヘルプについては、[トラブルシューティングガイド](/docs/ja/troubleshooting) を参照してください。

<h2 id="next-steps">
  次のステップ
</h2>

Claude Code を VS Code で設定したら、以下を実行してください。

* [一般的なワークフローを確認する](/docs/ja/common-workflows)ことで、Claude Code を最大限に活用できます
* [MCP サーバーを設定する](/docs/ja/mcp)ことで、外部ツールを使用して Claude の機能を拡張できます。チャットパネルで `/mcp` を使用して、これらを追加および管理できます。
* [Claude Code の設定を構成する](/docs/ja/settings)ことで、許可されたコマンド、hooks などをカスタマイズできます。これらの設定は、拡張機能と CLI 間で共有されます。
