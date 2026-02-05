> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# VS Code で Claude Code を使用する

> Claude Code 拡張機能を VS Code にインストールして設定します。インラインの差分表示、@-メンション、プラン確認、キーボードショートカットを使用した AI コーディング支援を取得します。

<img src="https://mintcdn.com/claude-code/-YhHHmtSxwr7W8gy/images/vs-code-extension-interface.jpg?fit=max&auto=format&n=-YhHHmtSxwr7W8gy&q=85&s=300652d5678c63905e6b0ea9e50835f8" alt="VS Code エディタの右側に Claude Code 拡張機能パネルが開いており、Claude との会話が表示されている" data-og-width="2500" width="2500" data-og-height="1155" height="1155" data-path="images/vs-code-extension-interface.jpg" data-optimize="true" data-opv="3" srcset="https://mintcdn.com/claude-code/-YhHHmtSxwr7W8gy/images/vs-code-extension-interface.jpg?w=280&fit=max&auto=format&n=-YhHHmtSxwr7W8gy&q=85&s=87630c671517a3d52e9aee627041696e 280w, https://mintcdn.com/claude-code/-YhHHmtSxwr7W8gy/images/vs-code-extension-interface.jpg?w=560&fit=max&auto=format&n=-YhHHmtSxwr7W8gy&q=85&s=716b093879204beec8d952649ef75292 560w, https://mintcdn.com/claude-code/-YhHHmtSxwr7W8gy/images/vs-code-extension-interface.jpg?w=840&fit=max&auto=format&n=-YhHHmtSxwr7W8gy&q=85&s=c1525d1a01513acd9d83d8b5a8fe2fc8 840w, https://mintcdn.com/claude-code/-YhHHmtSxwr7W8gy/images/vs-code-extension-interface.jpg?w=1100&fit=max&auto=format&n=-YhHHmtSxwr7W8gy&q=85&s=1d90021d58bbb51f871efec13af955c3 1100w, https://mintcdn.com/claude-code/-YhHHmtSxwr7W8gy/images/vs-code-extension-interface.jpg?w=1650&fit=max&auto=format&n=-YhHHmtSxwr7W8gy&q=85&s=7babdd25440099886f193cfa99af88ae 1650w, https://mintcdn.com/claude-code/-YhHHmtSxwr7W8gy/images/vs-code-extension-interface.jpg?w=2500&fit=max&auto=format&n=-YhHHmtSxwr7W8gy&q=85&s=08c92eedfb56fe61a61e480fb63784b6 2500w" />

VS Code 拡張機能は、Claude Code のネイティブグラフィカルインターフェースを提供し、IDE に直接統合されています。これは VS Code で Claude Code を使用する推奨方法です。

この拡張機能を使用すると、Claude のプランを受け入れる前に確認および編集でき、編集が行われるにつれて自動的に受け入れることができ、選択範囲から特定の行範囲を持つファイルを @-メンションでき、会話履歴にアクセスでき、複数の会話を別々のタブまたはウィンドウで開くことができます。

## 前提条件

* VS Code 1.98.0 以上
* Anthropic アカウント（拡張機能を初めて開くときにサインインします）。Amazon Bedrock や Google Vertex AI などのサードパーティプロバイダーを使用している場合は、代わりに[サードパーティプロバイダーを使用する](#use-third-party-providers)を参照してください。

<Tip>
  この拡張機能には CLI（コマンドラインインターフェース）が含まれており、VS Code の統合ターミナルからアクセスして高度な機能を使用できます。詳細については、[VS Code 拡張機能と Claude Code CLI](#vs-code-extension-vs-claude-code-cli) を参照してください。
</Tip>

## 拡張機能をインストールする

IDE のリンクをクリックして直接インストールします。

* [VS Code 用にインストール](vscode:extension/anthropic.claude-code)
* [Cursor 用にインストール](cursor:extension/anthropic.claude-code)

または、VS Code で `Cmd+Shift+X`（Mac）または `Ctrl+Shift+X`（Windows/Linux）を押して拡張機能ビューを開き、「Claude Code」を検索して、**インストール**をクリックします。

<Note>インストール後に拡張機能が表示されない場合は、VS Code を再起動するか、コマンドパレットから「Developer: Reload Window」を実行してください。</Note>

## はじめに

インストール後、VS Code インターフェースを通じて Claude Code の使用を開始できます。

<Steps>
  <Step title="Claude Code パネルを開く">
    VS Code 全体で、Spark アイコンは Claude Code を示します。<img src="https://mintcdn.com/claude-code/mfM-EyoZGnQv8JTc/images/vs-code-spark-icon.svg?fit=max&auto=format&n=mfM-EyoZGnQv8JTc&q=85&s=a734d84e785140016672f08e0abb236c" alt="Spark icon" style={{display: "inline", height: "0.85em", verticalAlign: "middle"}} data-og-width="16" width="16" data-og-height="16" height="16" data-path="images/vs-code-spark-icon.svg" data-optimize="true" data-opv="3" srcset="https://mintcdn.com/claude-code/mfM-EyoZGnQv8JTc/images/vs-code-spark-icon.svg?w=280&fit=max&auto=format&n=mfM-EyoZGnQv8JTc&q=85&s=9a45aad9a84b9fa1701ac99a1f9aa4e9 280w, https://mintcdn.com/claude-code/mfM-EyoZGnQv8JTc/images/vs-code-spark-icon.svg?w=560&fit=max&auto=format&n=mfM-EyoZGnQv8JTc&q=85&s=3f4cb9254c4d4e93989c4b6bf9292f4b 560w, https://mintcdn.com/claude-code/mfM-EyoZGnQv8JTc/images/vs-code-spark-icon.svg?w=840&fit=max&auto=format&n=mfM-EyoZGnQv8JTc&q=85&s=e75ccc9faa3e572db8f291ceb65bb264 840w, https://mintcdn.com/claude-code/mfM-EyoZGnQv8JTc/images/vs-code-spark-icon.svg?w=1100&fit=max&auto=format&n=mfM-EyoZGnQv8JTc&q=85&s=f147bd81a381a62539a4ce361fac41c7 1100w, https://mintcdn.com/claude-code/mfM-EyoZGnQv8JTc/images/vs-code-spark-icon.svg?w=1650&fit=max&auto=format&n=mfM-EyoZGnQv8JTc&q=85&s=78fe68efaee5d6e844bbacab1b442ed5 1650w, https://mintcdn.com/claude-code/mfM-EyoZGnQv8JTc/images/vs-code-spark-icon.svg?w=2500&fit=max&auto=format&n=mfM-EyoZGnQv8JTc&q=85&s=efb8dbe1dfa722d094edc6ad2ad4bedb 2500w" />

    Claude を開く最速の方法は、**エディタツールバー**（エディタの右上隅）の Spark アイコンをクリックすることです。このアイコンはファイルを開いている場合にのみ表示されます。

        <img src="https://mintcdn.com/claude-code/mfM-EyoZGnQv8JTc/images/vs-code-editor-icon.png?fit=max&auto=format&n=mfM-EyoZGnQv8JTc&q=85&s=eb4540325d94664c51776dbbfec4cf02" alt="VS Code エディタの右上隅のエディタツールバーに Spark アイコンが表示されている" data-og-width="2796" width="2796" data-og-height="734" height="734" data-path="images/vs-code-editor-icon.png" data-optimize="true" data-opv="3" srcset="https://mintcdn.com/claude-code/mfM-EyoZGnQv8JTc/images/vs-code-editor-icon.png?w=280&fit=max&auto=format&n=mfM-EyoZGnQv8JTc&q=85&s=56f218d5464359d6480cfe23f70a923e 280w, https://mintcdn.com/claude-code/mfM-EyoZGnQv8JTc/images/vs-code-editor-icon.png?w=560&fit=max&auto=format&n=mfM-EyoZGnQv8JTc&q=85&s=344a8db024b196c795a80dc85cacb8d1 560w, https://mintcdn.com/claude-code/mfM-EyoZGnQv8JTc/images/vs-code-editor-icon.png?w=840&fit=max&auto=format&n=mfM-EyoZGnQv8JTc&q=85&s=f30bf834ee0625b2a4a635d552d87163 840w, https://mintcdn.com/claude-code/mfM-EyoZGnQv8JTc/images/vs-code-editor-icon.png?w=1100&fit=max&auto=format&n=mfM-EyoZGnQv8JTc&q=85&s=81fdf984840e43a9f08ae42729d1484d 1100w, https://mintcdn.com/claude-code/mfM-EyoZGnQv8JTc/images/vs-code-editor-icon.png?w=1650&fit=max&auto=format&n=mfM-EyoZGnQv8JTc&q=85&s=8b60fb32de54717093d512afaa99785c 1650w, https://mintcdn.com/claude-code/mfM-EyoZGnQv8JTc/images/vs-code-editor-icon.png?w=2500&fit=max&auto=format&n=mfM-EyoZGnQv8JTc&q=85&s=893e6bda8f2e9d42c8a294d394f0b736 2500w" />

    Claude Code を開く他の方法：

    * **コマンドパレット**：`Cmd+Shift+P`（Mac）または `Ctrl+Shift+P`（Windows/Linux）を押し、「Claude Code」と入力して、「新しいタブで開く」などのオプションを選択します。
    * **ステータスバー**：ウィンドウの右下隅の **✱ Claude Code** をクリックします。ファイルが開いていない場合でも機能します。

    パネルを初めて開くと、**Learn Claude Code** チェックリストが表示されます。**Show me** をクリックして各項目を実行するか、X で閉じます。後で再度開くには、VS Code 設定の Extensions → Claude Code で **Hide Onboarding** をオフにします。

    Claude パネルをドラッグして、VS Code 内の任意の場所に再配置できます。詳細については、[ワークフローをカスタマイズする](#customize-your-workflow)を参照してください。
  </Step>

  <Step title="プロンプトを送信する">
    コードまたはファイルについて Claude に支援を求めます。これは、何かがどのように機能するかを説明したり、問題をデバッグしたり、変更を加えたりすることが含まれます。

    <Tip>Claude は自動的に選択したテキストを表示します。`Option+K`（Mac）/ `Alt+K`（Windows/Linux）を押して、@-メンション参照（`@file.ts#5-10` など）をプロンプトに挿入することもできます。</Tip>

    ファイル内の特定の行について質問する例を次に示します。

        <img src="https://mintcdn.com/claude-code/FVYz38sRY-VuoGHA/images/vs-code-send-prompt.png?fit=max&auto=format&n=FVYz38sRY-VuoGHA&q=85&s=ede3ed8d8d5f940e01c5de636d009cfd" alt="VS Code エディタで Python ファイルの 2～3 行が選択されており、Claude Code パネルにそれらの行についての質問と @-メンション参照が表示されている" data-og-width="3288" width="3288" data-og-height="1876" height="1876" data-path="images/vs-code-send-prompt.png" data-optimize="true" data-opv="3" srcset="https://mintcdn.com/claude-code/FVYz38sRY-VuoGHA/images/vs-code-send-prompt.png?w=280&fit=max&auto=format&n=FVYz38sRY-VuoGHA&q=85&s=f40bde7b2c245fe8f0f5b784e8106492 280w, https://mintcdn.com/claude-code/FVYz38sRY-VuoGHA/images/vs-code-send-prompt.png?w=560&fit=max&auto=format&n=FVYz38sRY-VuoGHA&q=85&s=fad66a27a9a6faa23b05370aa4f398b2 560w, https://mintcdn.com/claude-code/FVYz38sRY-VuoGHA/images/vs-code-send-prompt.png?w=840&fit=max&auto=format&n=FVYz38sRY-VuoGHA&q=85&s=4539c8a3823ca80a5c8771f6c088ce9e 840w, https://mintcdn.com/claude-code/FVYz38sRY-VuoGHA/images/vs-code-send-prompt.png?w=1100&fit=max&auto=format&n=FVYz38sRY-VuoGHA&q=85&s=fae8ebf300c7853409a562ffa46d9c71 1100w, https://mintcdn.com/claude-code/FVYz38sRY-VuoGHA/images/vs-code-send-prompt.png?w=1650&fit=max&auto=format&n=FVYz38sRY-VuoGHA&q=85&s=22e4462bb8cf0c0ca20f8102bc4c971a 1650w, https://mintcdn.com/claude-code/FVYz38sRY-VuoGHA/images/vs-code-send-prompt.png?w=2500&fit=max&auto=format&n=FVYz38sRY-VuoGHA&q=85&s=739bfd045f70fe7be1a109a53494590e 2500w" />
  </Step>

  <Step title="変更を確認する">
    Claude がファイルを編集したい場合、元の内容と提案された変更の並列比較を表示し、許可を求めます。編集を受け入れたり、拒否したり、Claude に代わりに何をするかを指示したりできます。

        <img src="https://mintcdn.com/claude-code/FVYz38sRY-VuoGHA/images/vs-code-edits.png?fit=max&auto=format&n=FVYz38sRY-VuoGHA&q=85&s=e005f9b41c541c5c7c59c082f7c4841c" alt="VS Code が Claude の提案された変更の差分を表示し、編集を行うかどうかを尋ねる許可プロンプトが表示されている" data-og-width="3292" width="3292" data-og-height="1876" height="1876" data-path="images/vs-code-edits.png" data-optimize="true" data-opv="3" srcset="https://mintcdn.com/claude-code/FVYz38sRY-VuoGHA/images/vs-code-edits.png?w=280&fit=max&auto=format&n=FVYz38sRY-VuoGHA&q=85&s=cb5d41b81087f79b842a56b5a3304660 280w, https://mintcdn.com/claude-code/FVYz38sRY-VuoGHA/images/vs-code-edits.png?w=560&fit=max&auto=format&n=FVYz38sRY-VuoGHA&q=85&s=90bb691960decdc06393c3c21cd62c75 560w, https://mintcdn.com/claude-code/FVYz38sRY-VuoGHA/images/vs-code-edits.png?w=840&fit=max&auto=format&n=FVYz38sRY-VuoGHA&q=85&s=9a11bf878ba619e850380904ff4f38e8 840w, https://mintcdn.com/claude-code/FVYz38sRY-VuoGHA/images/vs-code-edits.png?w=1100&fit=max&auto=format&n=FVYz38sRY-VuoGHA&q=85&s=6dddbf596b4f69ec6245bdc5eb6dd487 1100w, https://mintcdn.com/claude-code/FVYz38sRY-VuoGHA/images/vs-code-edits.png?w=1650&fit=max&auto=format&n=FVYz38sRY-VuoGHA&q=85&s=ef2713b8cbfd2cee97af817d813d64c7 1650w, https://mintcdn.com/claude-code/FVYz38sRY-VuoGHA/images/vs-code-edits.png?w=2500&fit=max&auto=format&n=FVYz38sRY-VuoGHA&q=85&s=1f7e1c52919cdfddf295f32a2ec7ae59 2500w" />
  </Step>
</Steps>

Claude Code で実行できることについてのアイデアについては、[一般的なワークフロー](/ja/common-workflows)を参照してください。

<Tip>
  コマンドパレットから「Claude Code: Open Walkthrough」を実行して、基本的な機能のガイド付きツアーを取得します。
</Tip>

## プロンプトボックスを使用する

プロンプトボックスは複数の機能をサポートしています。

* **許可モード**：プロンプトボックスの下部のモード指示器をクリックしてモードを切り替えます。通常モードでは、Claude は各アクション前に許可を求めます。Plan モードでは、Claude は実行内容を説明し、変更を加える前に承認を待ちます。自動受け入れモードでは、Claude は許可を求めずに編集を行います。VS Code 設定の `claudeCode.initialPermissionMode` でデフォルトを設定します。
* **コマンドメニュー**：`/` をクリックするか `/` を入力してコマンドメニューを開きます。オプションには、ファイルの添付、モデルの切り替え、拡張思考の切り替え、プラン使用状況の表示（`/usage`）が含まれます。カスタマイズセクションは、MCP サーバー、hooks、メモリ、権限、プラグインへのアクセスを提供します。ターミナルアイコンが付いた項目は統合ターミナルで開きます。
* **コンテキスト指示器**：プロンプトボックスは Claude のコンテキストウィンドウをどの程度使用しているかを表示します。Claude は必要に応じて自動的にコンパクト化するか、`/compact` を手動で実行できます。
* **拡張思考**：Claude が複雑な問題について推論に時間をかけることができます。コマンドメニュー（`/`）経由でオンに切り替えます。詳細については、[拡張思考](/ja/common-workflows#use-extended-thinking-thinking-mode)を参照してください。
* **複数行入力**：`Shift+Enter` を押して送信せずに新しい行を追加します。これは質問ダイアログの「その他」フリーテキスト入力でも機能します。

### ファイルとフォルダを参照する

@-メンション を使用して、特定のファイルまたはフォルダについて Claude にコンテキストを提供します。`@` の後にファイルまたはフォルダ名を入力すると、Claude はそのコンテンツを読み取り、それについて質問に答えたり、変更を加えたりできます。Claude Code はファジーマッチングをサポートしているため、部分的な名前を入力して必要なものを見つけることができます。

```
> Explain the logic in @auth (fuzzy matches auth.js, AuthService.ts, etc.)
> What's in @src/components/ (include a trailing slash for folders)
```

大きな PDF の場合、Claude にファイル全体ではなく特定のページを読むよう求めることができます。単一ページ、1～10 ページなどの範囲、または 3 ページ以降などのオープンエンドの範囲です。

エディタでテキストを選択すると、Claude は強調表示されたコードを自動的に表示できます。プロンプトボックスのフッターは、選択されている行数を表示します。`Option+K`（Mac）/ `Alt+K`（Windows/Linux）を押して、ファイルパスと行番号を含む @-メンション を挿入します（例：`@app.ts#5-10`）。選択指示器をクリックして、Claude が強調表示されたテキストを表示できるかどうかを切り替えます。目のスラッシュアイコンは、選択が Claude から非表示であることを意味します。

また、`Shift` を押しながらファイルをプロンプトボックスにドラッグして、添付ファイルとして追加することもできます。任意の添付ファイルの X をクリックしてコンテキストから削除します。

### 過去の会話を再開する

Claude Code パネルの上部のドロップダウンをクリックして、会話履歴にアクセスします。キーワードで検索するか、時間別に参照できます（今日、昨日、過去 7 日間など）。任意の会話をクリックして、完全なメッセージ履歴で再開します。セッションの再開の詳細については、[一般的なワークフロー](/ja/common-workflows#resume-previous-conversations)を参照してください。

### Claude.ai からリモートセッションを再開する

[Web 上の Claude Code](/ja/claude-code-on-the-web) を使用している場合、VS Code でそれらのリモートセッションを直接再開できます。これには Anthropic Console ではなく **Claude.ai Subscription** でのサインインが必要です。

<Steps>
  <Step title="過去の会話を開く">
    Claude Code パネルの上部の **過去の会話**ドロップダウンをクリックします。
  </Step>

  <Step title="リモートタブを選択する">
    ダイアログには 2 つのタブが表示されます。ローカルとリモート。**リモート**をクリックして claude.ai からのセッションを表示します。
  </Step>

  <Step title="再開するセッションを選択する">
    リモートセッションを参照または検索します。任意のセッションをクリックしてダウンロードし、会話をローカルで続行します。
  </Step>
</Steps>

<Note>
  リモートタブに表示されるのは、GitHub リポジトリで開始された Web セッションのみです。再開するとローカルに会話履歴が読み込まれます。変更は claude.ai に同期されません。
</Note>

## ワークフローをカスタマイズする

起動して実行したら、Claude パネルを再配置したり、複数のセッションを実行したり、ターミナルモードに切り替えたりできます。

### Claude が存在する場所を選択する

Claude パネルをドラッグして、VS Code 内の任意の場所に再配置できます。パネルのタブまたはタイトルバーをつかんでドラッグします。

* **セカンダリサイドバー**：ウィンドウの右側。コード作成中に Claude を表示したままにします。
* **プライマリサイドバー**：Explorer、Search などのアイコンが付いた左側のサイドバー。
* **エディタ領域**：Claude をファイルの横のタブとして開きます。サイドタスクに便利です。

<Tip>
  メイン Claude セッションにはサイドバーを使用し、サイドタスク用に追加のタブを開きます。Claude は優先される場所を記憶します。Spark アイコンは Claude パネルが左にドックされている場合にのみアクティビティバーに表示されることに注意してください。Claude はデフォルトで右側にあるため、エディタツールバーアイコンを使用して Claude を開きます。
</Tip>

### 複数の会話を実行する

コマンドパレットから **新しいタブで開く**または **新しいウィンドウで開く**を使用して、追加の会話を開始します。各会話は独自の履歴とコンテキストを保持し、異なるタスクで並列に作業できます。

タブを使用する場合、Spark アイコンの小さな色付きドットはステータスを示します。青は許可リクエストが保留中であることを意味し、オレンジは Claude がタブが非表示の間に完了したことを意味します。

### ターミナルモードに切り替える

デフォルトでは、拡張機能はグラフィカルチャットパネルを開きます。CLI スタイルのインターフェースを使用する場合は、[ターミナル設定を使用](vscode://settings/claudeCode.useTerminal)を開いてボックスをチェックします。

VS Code 設定（Mac で `Cmd+,` または Windows/Linux で `Ctrl+,`）を開き、Extensions → Claude Code に移動して、**ターミナルを使用**をチェックすることもできます。

## プラグインを管理する

VS Code 拡張機能には、[プラグイン](/ja/plugins)をインストールおよび管理するためのグラフィカルインターフェースが含まれています。プロンプトボックスで `/plugins` と入力して、**プラグインを管理**インターフェースを開きます。

### プラグインをインストールする

プラグインダイアログには 2 つのタブが表示されます。**プラグイン**と**マーケットプレイス**。

プラグインタブで：

* **インストール済みプラグイン**は上部に表示され、有効または無効にするためのトグルスイッチが付いています。
* **利用可能なプラグイン**は設定されたマーケットプレイスから下に表示されます。
* 検索してプラグインを名前または説明でフィルタリングします。
* 利用可能なプラグインで **インストール**をクリックします。

プラグインをインストールするときは、インストールスコープを選択します。

* **あなたのためにインストール**：すべてのプロジェクトで利用可能（ユーザースコープ）
* **このプロジェクトのためにインストール**：プロジェクト協力者と共有（プロジェクトスコープ）
* **ローカルにインストール**：このリポジトリでのみあなたのためだけ（ローカルスコープ）

### マーケットプレイスを管理する

**マーケットプレイス**タブに切り替えてプラグインソースを追加または削除します。

* GitHub リポジトリ、URL、またはローカルパスを入力して新しいマーケットプレイスを追加します。
* 更新アイコンをクリックしてマーケットプレイスのプラグインリストを更新します。
* ゴミ箱アイコンをクリックしてマーケットプレイスを削除します。

変更を加えた後、Claude Code を再起動して更新を適用するようにバナーが表示されます。

<Note>
  VS Code のプラグイン管理は、内部で同じ CLI コマンドを使用します。拡張機能で設定したプラグインとマーケットプレイスは CLI でも利用可能であり、その逆も同様です。
</Note>

プラグインシステムの詳細については、[プラグイン](/ja/plugins)および[プラグインマーケットプレイス](/ja/plugin-marketplaces)を参照してください。

## Chrome でブラウザタスクを自動化する

Claude を Chrome ブラウザに接続して、Web アプリをテストし、コンソールログでデバッグし、VS Code を離れることなくブラウザワークフローを自動化します。これには [Claude in Chrome 拡張機能](https://chromewebstore.google.com/detail/claude/fcoeoabgfenejglbffodgkkbkcdhcgfn)バージョン 1.0.36 以上が必要です。

プロンプトボックスで `@browser` と入力し、その後に Claude に実行させたいことを入力します。

```text  theme={null}
@browser go to localhost:3000 and check the console for errors
```

添付メニューを開いて、新しいタブを開いたりページコンテンツを読んだりするなど、特定のブラウザツールを選択することもできます。

Claude はブラウザタスク用に新しいタブを開き、ブラウザのログイン状態を共有するため、既にサインインしているサイトにアクセスできます。

セットアップ手順、機能の完全なリスト、トラブルシューティングについては、[Chrome で Claude Code を使用する](/ja/chrome)を参照してください。

## VS Code コマンドとショートカット

コマンドパレット（Mac で `Cmd+Shift+P` または Windows/Linux で `Ctrl+Shift+P`）を開き、'Claude Code'と入力して、Claude Code 拡張機能で利用可能なすべての VS Code コマンドを表示します。

一部のショートカットは、どのパネルが'フォーカス'されているか（キーボード入力を受け取っているか）によって異なります。カーソルがコードファイルにある場合、エディタはフォーカスされています。カーソルが Claude のプロンプトボックスにある場合、Claude はフォーカスされています。`Cmd+Esc` / `Ctrl+Esc` を使用してそれらを切り替えます。

<Note>
  これらは拡張機能を制御するための VS Code コマンドです。組み込みの Claude Code コマンドのすべてが拡張機能で利用可能なわけではありません。詳細については、[VS Code 拡張機能と Claude Code CLI](#vs-code-extension-vs-claude-code-cli)を参照してください。
</Note>

| コマンド                       | ショートカット                                               | 説明                                          |
| -------------------------- | ----------------------------------------------------- | ------------------------------------------- |
| Focus Input                | `Cmd+Esc`（Mac）/ `Ctrl+Esc`（Windows/Linux）             | エディタと Claude 間のフォーカスを切り替える                  |
| Open in Side Bar           | -                                                     | Claude を左側のサイドバーで開く                         |
| Open in Terminal           | -                                                     | Claude をターミナルモードで開く                         |
| Open in New Tab            | `Cmd+Shift+Esc`（Mac）/ `Ctrl+Shift+Esc`（Windows/Linux） | 新しい会話をエディタタブとして開く                           |
| Open in New Window         | -                                                     | 新しい会話を別のウィンドウで開く                            |
| New Conversation           | `Cmd+N`（Mac）/ `Ctrl+N`（Windows/Linux）                 | 新しい会話を開始する（Claude がフォーカスされている必要があります）       |
| Insert @-Mention Reference | `Option+K`（Mac）/ `Alt+K`（Windows/Linux）               | 現在のファイルと選択への参照を挿入する（エディタがフォーカスされている必要があります） |
| Show Logs                  | -                                                     | 拡張機能デバッグログを表示する                             |
| Logout                     | -                                                     | Anthropic アカウントからサインアウトする                   |

## 設定を構成する

拡張機能には 2 種類の設定があります。

* **VS Code の拡張機能設定**：VS Code 内の拡張機能の動作を制御します。`Cmd+,`（Mac）または `Ctrl+,`（Windows/Linux）で開き、Extensions → Claude Code に移動します。`/` を入力して **General Config** を選択して設定を開くこともできます。
* **`~/.claude/settings.json` の Claude Code 設定**：拡張機能と CLI 間で共有されます。許可されたコマンド、環境変数、hooks、MCP サーバーに使用します。詳細については、[設定](/ja/settings)を参照してください。

<Tip>
  `"$schema": "https://json.schemastore.org/claude-code-settings.json"` を `settings.json` に追加して、VS Code で直接利用可能なすべての設定のオートコンプリートとインライン検証を取得します。
</Tip>

### 拡張機能設定

| 設定                                | デフォルト     | 説明                                                                          |
| --------------------------------- | --------- | --------------------------------------------------------------------------- |
| `selectedModel`                   | `default` | 新しい会話のモデル。`/model` でセッションごとに変更します。                                          |
| `useTerminal`                     | `false`   | グラフィカルパネルの代わりにターミナルモードで Claude を起動する                                        |
| `initialPermissionMode`           | `default` | 承認プロンプトを制御します。`default`（毎回尋ねる）、`plan`、`acceptEdits`、または `bypassPermissions` |
| `preferredLocation`               | `panel`   | Claude が開く場所：`sidebar`（右）または `panel`（新しいタブ）                                 |
| `autosave`                        | `true`    | Claude が読み取りまたは書き込みする前にファイルを自動保存する                                          |
| `useCtrlEnterToSend`              | `false`   | Enter の代わりに Ctrl/Cmd+Enter を使用してプロンプトを送信する                                  |
| `enableNewConversationShortcut`   | `true`    | Cmd/Ctrl+N を有効にして新しい会話を開始する                                                 |
| `hideOnboarding`                  | `false`   | オンボーディングチェックリスト（卒業キャップアイコン）を非表示にする                                          |
| `respectGitIgnore`                | `true`    | ファイル検索から .gitignore パターンを除外する                                               |
| `environmentVariables`            | `[]`      | Claude プロセスの環境変数を設定します。共有設定には Claude Code 設定を使用します。                         |
| `disableLoginPrompt`              | `false`   | 認証プロンプトをスキップする（サードパーティプロバイダーセットアップ用）                                        |
| `allowDangerouslySkipPermissions` | `false`   | すべての許可プロンプトをバイパスします。**極度の注意を持って使用してください。**                                  |
| `claudeProcessWrapper`            | -         | Claude プロセスを起動するために使用される実行可能ファイルパス                                          |

## VS Code 拡張機能と Claude Code CLI

Claude Code は VS Code 拡張機能（グラフィカルパネル）と CLI（ターミナルのコマンドラインインターフェース）の両方として利用可能です。一部の機能は CLI でのみ利用可能です。CLI のみの機能が必要な場合は、VS Code の統合ターミナルで `claude` を実行します。

| 機能               | CLI                                           | VS Code 拡張機能               |
| ---------------- | --------------------------------------------- | -------------------------- |
| コマンドと skills     | [すべて](/ja/interactive-mode#built-in-commands) | サブセット（`/` を入力して利用可能なものを表示） |
| MCP サーバー設定       | はい                                            | いいえ（CLI 経由で設定、拡張機能で使用）     |
| チェックポイント         | はい                                            | はい                         |
| `!` bash ショートカット | はい                                            | いいえ                        |
| タブ補完             | はい                                            | いいえ                        |

### チェックポイントで巻き戻す

VS Code 拡張機能はチェックポイントをサポートしており、Claude のファイル編集を追跡し、以前の状態に巻き戻すことができます。任意のメッセージの上にマウスを置いて巻き戻しボタンを表示し、3 つのオプションから選択します。

* **ここから会話をフォーク**：このメッセージからの新しい会話ブランチを開始しながら、すべてのコード変更をそのまま保持します。
* **ここにコードを巻き戻す**：会話履歴全体を保持しながら、ファイル変更をこのポイントに戻します。
* **会話をフォークしてコードを巻き戻す**：新しい会話ブランチを開始し、ファイル変更をこのポイントに戻します。

チェックポイントの動作方法と制限事項の詳細については、[チェックポイント](/ja/checkpointing)を参照してください。

### VS Code で CLI を実行する

VS Code に留まりながら CLI を使用するには、統合ターミナル（Windows/Linux で `` Ctrl+` `` または Mac で `` Cmd+` ``）を開き、`claude` を実行します。CLI は diff 表示や診断共有などの機能のために IDE と自動的に統合されます。

外部ターミナルを使用している場合は、Claude Code 内で `/ide` を実行して VS Code に接続します。

### 拡張機能と CLI を切り替える

拡張機能と CLI は同じ会話履歴を共有します。拡張機能の会話を CLI で続行するには、ターミナルで `claude --resume` を実行します。これにより、会話を検索して選択できるインタラクティブピッカーが開きます。

### プロンプトにターミナル出力を含める

プロンプトで `@terminal:name` を使用してターミナル出力を参照します。ここで `name` はターミナルのタイトルです。これにより、Claude はコマンド出力、エラーメッセージ、またはログをコピーペーストせずに表示できます。

### バックグラウンドプロセスを監視する

Claude が長時間実行されるコマンドを実行すると、拡張機能はステータスバーに進行状況を表示します。ただし、バックグラウンドタスクの可視性は CLI と比較して制限されています。可視性を向上させるには、Claude にコマンドを出力させて、VS Code の統合ターミナルで実行できるようにします。

### MCP で外部ツールに接続する

MCP（Model Context Protocol）サーバーは Claude に外部ツール、データベース、API へのアクセスを提供します。CLI 経由で設定してから、拡張機能と CLI の両方で使用します。

MCP サーバーを追加するには、統合ターミナル（`` Ctrl+` `` または `` Cmd+` ``）を開き、以下を実行します。

```bash  theme={null}
claude mcp add --transport http github https://api.githubcopilot.com/mcp/
```

設定後、Claude にツールを使用するよう求めます（例：「Review PR #456」）。一部のサーバーは認証が必要です。ターミナルで `claude` を実行し、`/mcp` を入力して認証します。利用可能なサーバーについては、[MCP ドキュメント](/ja/mcp)を参照してください。

## git で作業する

Claude Code は git と統合され、VS Code でバージョン管理ワークフローを直接支援します。Claude にコミット変更、プルリクエスト作成、またはブランチ間での作業を求めます。

### コミットとプルリクエストを作成する

Claude は変更をステージング、コミットメッセージを作成、作業に基づいてプルリクエストを作成できます。

```
> commit my changes with a descriptive message
> create a pr for this feature
> summarize the changes I've made to the auth module
```

プルリクエストを作成するときに、Claude は実際のコード変更に基づいて説明を生成し、テストまたは実装の決定についてのコンテキストを追加できます。

### 並列タスク用に git worktrees を使用する

Git worktrees により、複数の Claude Code セッションが同時に別々のブランチで作業でき、各セッションは分離されたファイルを持ちます。

```bash  theme={null}
# 新しい機能用に worktree を作成する
git worktree add ../project-feature-a -b feature-a

# 各 worktree で Claude Code を実行する
cd ../project-feature-a && claude
```

各 worktree は git 履歴を共有しながら独立したファイル状態を保持します。これにより、異なるタスクで作業するときに Claude インスタンスが互いに干渉するのを防ぎます。

PR レビューとブランチ管理を含む詳細な git ワークフローについては、[一般的なワークフロー](/ja/common-workflows#create-pull-requests)を参照してください。

## サードパーティプロバイダーを使用する

デフォルトでは、Claude Code は Anthropic の API に直接接続します。組織が Amazon Bedrock、Google Vertex AI、または Microsoft Foundry を使用して Claude にアクセスする場合は、代わりにプロバイダーを使用するように拡張機能を設定します。

<Steps>
  <Step title="ログインプロンプトを無効にする">
    [ログインプロンプトを無効にする設定](vscode://settings/claudeCode.disableLoginPrompt)を開いてボックスをチェックします。

    VS Code 設定（Mac で `Cmd+,` または Windows/Linux で `Ctrl+,`）を開き、'Claude Code login'を検索して、**ログインプロンプトを無効にする**をチェックすることもできます。
  </Step>

  <Step title="プロバイダーを設定する">
    プロバイダーのセットアップガイドに従います。

    * [Amazon Bedrock 上の Claude Code](/ja/amazon-bedrock)
    * [Google Vertex AI 上の Claude Code](/ja/google-vertex-ai)
    * [Microsoft Foundry 上の Claude Code](/ja/microsoft-foundry)

    これらのガイドは `~/.claude/settings.json` でプロバイダーを設定することをカバーしており、VS Code 拡張機能と CLI 間で設定が共有されることを保証します。
  </Step>
</Steps>

## セキュリティとプライバシー

コードはプライベートのままです。Claude Code はコード支援を提供するためにコードを処理しますが、モデルのトレーニングには使用しません。データ処理とログアウトの方法の詳細については、[データとプライバシー](/ja/data-usage)を参照してください。

自動編集権限が有効な場合、Claude Code は VS Code が自動的に実行する可能性がある VS Code 設定ファイル（`settings.json` や `tasks.json` など）を変更できます。信頼できないコードで作業するときのリスクを軽減するには、以下を実行します。

* 信頼できないワークスペースに対して [VS Code 制限モード](https://code.visualstudio.com/docs/editor/workspace-trust#_restricted-mode)を有効にします。
* 編集の自動受け入れの代わりに手動承認モードを使用します。
* 変更を受け入れる前に慎重に確認します。

## 一般的な問題を修正する

### 拡張機能がインストールされない

* VS Code の互換バージョン（1.98.0 以上）があることを確認します。
* VS Code に拡張機能をインストールする権限があることを確認します。
* [VS Code マーケットプレイス](https://marketplace.visualstudio.com/items?itemName=anthropic.claude-code)から直接インストールしてみてください。

### Spark アイコンが表示されない

Spark アイコンは、ファイルを開いている場合、**エディタツールバー**（エディタの右上）に表示されます。表示されない場合：

1. **ファイルを開く**：アイコンはファイルが開いている必要があります。フォルダを開いているだけでは不十分です。
2. **VS Code バージョンを確認**：1.98.0 以上が必要です（Help → About）
3. **VS Code を再起動**：コマンドパレットから「Developer: Reload Window」を実行します。
4. **競合する拡張機能を無効にする**：他の AI 拡張機能（Cline、Continue など）を一時的に無効にします。
5. **ワークスペーストラストを確認**：拡張機能は制限モードでは機能しません。

または、**ステータスバー**（右下隅）の「✱ Claude Code」をクリックします。ファイルが開いていない場合でも機能します。**コマンドパレット**（`Cmd+Shift+P` / `Ctrl+Shift+P`）を使用して「Claude Code」と入力することもできます。

### Claude Code が応答しない

Claude Code がプロンプトに応答しない場合：

1. **インターネット接続を確認**：安定したインターネット接続があることを確認します。
2. **新しい会話を開始**：新しい会話を開始して、問題が続くかどうかを確認します。
3. **CLI を試す**：ターミナルから `claude` を実行して、より詳細なエラーメッセージが表示されるかどうかを確認します。

問題が続く場合は、エラーの詳細を含めて [GitHub で問題を報告](https://github.com/anthropics/claude-code/issues)してください。

## 拡張機能をアンインストールする

Claude Code 拡張機能をアンインストールするには：

1. 拡張機能ビューを開きます（Mac で `Cmd+Shift+X` または Windows/Linux で `Ctrl+Shift+X`）
2. 「Claude Code」を検索します。
3. **アンインストール**をクリックします。

拡張機能データを削除してすべての設定をリセットするには：

```bash  theme={null}
rm -rf ~/.vscode/globalStorage/anthropic.claude-code
```

追加のヘルプについては、[トラブルシューティングガイド](/ja/troubleshooting)を参照してください。

## 次のステップ

VS Code で Claude Code をセットアップしたので：

* [一般的なワークフローを探索](/ja/common-workflows)して Claude Code を最大限に活用します。
* [MCP サーバーをセットアップ](/ja/mcp)して、外部ツールで Claude の機能を拡張します。CLI を使用してサーバーを設定してから、拡張機能で使用します。
* [Claude Code 設定を構成](/ja/settings)して、許可されたコマンド、hooks などをカスタマイズします。これらの設定は拡張機能と CLI 間で共有されます。
