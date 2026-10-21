> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# Claude Code Desktop in WSL

> WSL 2 ディストリビューション内で Code セッションを実行する

Windows では、Code タブは Windows 自体ではなく WSL 2 ディストリビューション内でセッションを実行できます。セッションの Claude Code プロセス、そのツール、および git はすべてディストリビューション内で実行され、その Linux ツールチェーンとネイティブ Linux パスを使用します。これはプロジェクトが対象とする環境と同じです。

リポジトリがディストリビューションのファイルシステム内に存在する場合は、WSL セッションを使用してください。Windows からこれらのファイルで作業すると、ネットワークファイルシステムを経由するため遅く、ファイル監視が機能しません。セッションをディストリビューション内で実行すると、両方の問題を回避できます。

## 要件

* [WSL 2](https://learn.microsoft.com/windows/wsl/install) がインストールされた Windows 10 または 11。WSL 1 はサポートされていません。
* インストール済みのディストリビューション（例：Ubuntu）が少なくとも 1 つ。
* ディストリビューション内にインストールされた `git`。

## WSL セッションを開始する

**1. ディストリビューションを選択する**

Code タブで新しいセッションを開始し、プロンプトボックスの下（[以前のレイアウト](/docs/ja/desktop#check-which-layout-you-have)ではその上）にある[環境セレクター](/docs/ja/desktop#start-a-session)を開きます。インストール済みの WSL 2 ディストリビューションが **WSL** の下に表示されます。1 つを選択してください。

**2. フォルダを選択する**

セッションはディストリビューションのホームディレクトリで開始します。フォルダピッカーを使用してプロジェクトフォルダを選択してください。ブラウジングはディストリビューション内で行われ、`/home/you/project` のような Linux パスが使用されます。

**3. フォルダを信頼する**

フォルダ内の最初のセッションはワークスペース信頼ダイアログを表示します。信頼はディストリビューションとフォルダごとに付与されます。1 つのディストリビューション内のフォルダを信頼しても、別のディストリビューションまたは Windows 上の同じパスには適用されません。

ディストリビューション内の最初のセッションは、Claude がその内部をセットアップする間、少し時間がかかります。通常のフォルダピッカーから `\\wsl.localhost\...` フォルダを開くこともでき、そのディストリビューション内で再度開きます。

## WSL セッションで機能するもの

並列セッション、サイドチャット、ビジュアル diff レビュー、ブランチとプルリクエストのステータス、および worktrees はすべて機能し、ディストリビューション内の git とツールチェーンによってサポートされます。「エディタで開く」は [Remote - WSL](https://code.visualstudio.com/docs/remote/wsl) を通じてディストリビューションに接続された VS Code を開きます。

Desktop の機能が WSL セッションで利用できない、または制限されている場合は、次のいずれかに該当するかを確認してください。

* **ターミナルとコネクタ**: セッションで[統合ターミナル](/docs/ja/desktop#run-commands-in-the-terminal)、[コネクタ](/docs/ja/desktop#connect-external-tools)、またはその両方が利用できない場合があります。[ターミナルまたはコネクタが利用できない場合](#check-for-the-terminal-and-connectors)を参照してください。
* **[プラグイン](/docs/ja/desktop#install-plugins)**: WSL セッションでは利用できません
* **ファイル編集**: [ファイルペイン](/docs/ja/desktop#open-and-edit-files)でファイルを表示することはできますが、そこで編集することはできないため、変更は Claude に依頼してください
* **添付ファイル**: **+** メニューに **Add files or photos** の代わりに **Add image** が表示される場合、添付できるのは画像のみです。[プロンプトにファイルとコンテキストを追加する](/docs/ja/desktop#add-files-and-context-to-prompts)を参照してください。

### ターミナルまたはコネクタが利用できない場合

WSL セッションの統合ターミナルやコネクタを自分でオンにすることはできません。

* **Claude アカウント**: この 2 つの機能は個別に展開されています。**Help > Check for Updates…** を選択し、更新後も機能が表示されない場合は、特に対応する必要はありません。
* **[サードパーティプロバイダー](/docs/ja/third-party-integrations)**: WSL セッションではターミナルやコネクタは利用できず、Desktop を更新してもそれは変わりません

## 管理対象デバイス

組織によって管理されているデバイスでは、WSL セッションが利用できない場合があります。セッション開始がデバイスが管理されているというメッセージで失敗する場合、それは管理者によって制御されます。管理者の方は、デプロイメントガイドの [設定がデバイスに到達する方法を決定する](/docs/ja/admin-setup#decide-how-settings-reach-devices) を参照してください。
