> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# デスクトップアプリを始める

> Claude デスクトップアプリをインストールして、Code タブを開き、コンピューター上のプロジェクトフォルダーで最初の Claude Code セッションを開始します。

デスクトップアプリは、グラフィカルインターフェース付きの Claude Code を提供します。コンピューター上のフォルダー内のコードに対して Claude に作業を依頼し、ターミナルを使用せずにその変更をレビューできます。

Claude Code は、アプリのサイドバー上部にある **Code** タブにあります。このページでは、アプリのインストールと、そこで最初のセッションを開始する方法について説明します。Claude Code には [Pro、Max、Team、または Enterprise サブスクリプション](https://claude.com/pricing?utm_source=claude_code\&utm_medium=docs\&utm_content=desktop_quickstart_pricing)が必要です。

> **[macOS 用にダウンロード](https://claude.ai/api/desktop/darwin/universal/dmg/latest/redirect?utm_source=claude_code\&utm_medium=docs)**
>
> Intel と Apple Silicon 向けのユニバーサルビルド

> **[Windows 用にダウンロード](https://claude.ai/api/desktop/win32/x64/setup/latest/redirect?utm_source=claude_code\&utm_medium=docs)**
>
> x64 プロセッサ向け

> **[Linux 用 Claude を入手（ベータ版）](/docs/ja/desktop-linux)**
>
> Ubuntu と Debian 向けの apt または .deb

Windows ARM64 の場合は、[ARM64 インストーラー](https://claude.ai/api/desktop/win32/arm64/setup/latest/redirect?utm_source=claude_code\&utm_medium=docs)をダウンロードしてください。Linux では apt でインストールします。[Claude Desktop on Linux](/docs/ja/desktop-linux)を参照してください。

> [!NOTE]
>
> 以下のケースは他のページで説明されています。
>
> * **既にセットアップ済み**: [Claude Code Desktop を使用する](/docs/ja/desktop)で Code タブが実行できるすべての機能を参照してください
> * **ターミナルで `claude` を使用したい**: [CLI](/docs/ja/quickstart) を別途インストールしてください
> * **Chat または Cowork を使用している**: [Claude ヘルプセンター](https://support.claude.com/)を参照してください
> * **デスクトップアプリのインストールやデプロイについて詳しく知りたい**: [Claude Desktop サポート記事](https://support.claude.com/en/collections/16163169-claude-desktop)を参照してください

## インストール

**1. インストールしてサインインする**

macOS と Windows では、上記のリンクからインストーラーをダウンロードして実行します。Linux では、[Claude Desktop on Linux](/docs/ja/desktop-linux) のインストール手順に従ってください。macOS の Applications フォルダ、Windows の Start メニュー、または Linux のアプリケーションランチャーから Claude を起動し、Anthropic アカウントでサインインします。

**2. Code タブを開く**

サイドバー上部の **Code** タブをクリックします。タブにアイコンしか表示されていない場合は、アイコンにカーソルを合わせると名前が表示されます。**Code** をクリックした後にメッセージやエラーが表示された場合は、該当する対処法に従ってください。

* **アップグレードを促すメッセージ**：最初に[有料プランにサブスクライブ](https://claude.com/pricing?utm_source=claude_code\&utm_medium=docs\&utm_content=desktop_quickstart_upgrade)する必要があります
* **オンラインでサインインするよう促すメッセージ**：サインインを完了してアプリを再起動してください
* **403 エラー**：[認証のトラブルシューティング](/docs/ja/desktop#403-or-authentication-errors-in-the-code-tab)を参照してください

デスクトップアプリには Claude Code が含まれています。Code タブを使用するために Node.js または CLI をインストールする必要はありません。

## 最初のセッションを開始する

Code タブを開いた状態で、プロジェクトを選択し、Claude に何かをさせます。

**1. 環境とフォルダを選択する**

[プロンプトボックスの下の行](/docs/ja/desktop#start-a-session)で、最初のコントロールである環境セレクタをクリックし、**Local** グループの一番上の項目を選択します。次に、環境セレクタの横にあるプロジェクトフォルダのコントロールをクリックし、**Open folder…** を選択して、プロジェクトのディレクトリを選択します。

プロンプトボックスの下に環境セレクタが表示されない場合は、以前のレイアウトを使用しています。[使用しているレイアウトを確認する](/docs/ja/desktop#check-which-layout-you-have)を参照してください。

> [!TIP]
>
> よく知っている小さなプロジェクトから始めてください。Claude Code が何ができるかを見る最速の方法です。

次のオプションも選択できます。

* **Cloud**: アプリを閉じても続行するクラウドセッションを実行します。クラウドセッションの動作方法については [Claude Code in the cloud](/docs/ja/claude-code-on-the-web) を参照してください。
* **SSH**: SSH 経由でリモートマシン（独自のサーバー、クラウド VM、dev コンテナなど）に接続します。最初に[接続を追加](/docs/ja/desktop#ssh-sessions)してください。Desktop は初回接続時にリモートマシンに Claude Code を自動的にインストールします。実行中のタスクは [Desktop が切断されている間も続行できます](/docs/ja/desktop#keep-a-task-running-while-desktop-is-disconnected)が、Claude アカウントを使用している場合は、サインインの有効期限が切れると停止することがあります。
* **WSL**（Windows）: [WSL 2 distribution](/docs/ja/desktop-wsl) 内でセッションを実行します。Claude Code、ツール、git は Linux 側でネイティブパスで実行されます。

**2. モデルを選択する**

プロンプトボックスの下の行の右端寄りにあるモデルピッカーからモデルを選択します。利用可能なモデルの比較については [models](/docs/ja/model-config#available-models) を参照してください。後でモデルピッカーからモデルを変更できます。

**3. Claude に何をするかを指示する**

Claude に何をさせたいかを入力します。

* `TODO コメントを見つけて修正する`
* `main 関数のテストを追加する`
* `このコードベースの手順を含む CLAUDE.md を作成する`

[セッション](/docs/ja/desktop#work-in-parallel-with-sessions)は、コードについての Claude との会話です。各セッションは独自のコンテキストと変更を追跡します。

**4. 変更を確認して受け入れる**

プロンプトボックスの下の行で[権限モード](/docs/ja/desktop#choose-a-permission-mode)を確認し、Claude が承認を待つかどうかを確認します。

* **Auto or Accept edits**: Claude はファイルの変更を適用し、`+12 -1` などのインジケータが表示されるため、[差分ビュー](/docs/ja/desktop#review-changes-with-diff-view)で確認できます
* **Manual**: Claude は各変更を提案し、適用する前に承認を待ちます

Manual モードでは、以下が表示されます。

1. 何が変更されるかを正確に示す差分
2. 各変更を承認または拒否するためのボタン
3. Claude があなたのリクエストを処理する際のリアルタイム更新

## 次は何をしますか？

最初の編集が完了しました。Desktop が実行できるすべての機能の完全なリファレンスについては、[Claude Code Desktop を使用する](/docs/ja/desktop)を参照してください。次に試すべきことをいくつか紹介します。

**中断して方向を変える。** Claude をいつでもリダイレクトできます。停止ボタンをクリックして即座に中断するか、修正を入力して **Enter** キーを押して、実行中のアクションを停止せずに送信します。どちらの方法でも、完了を待つ必要がなく、最初からやり直す必要もありません。

**Claude により多くのコンテキストを提供する。** プロンプトボックスに `@filename` と入力すると、特定のファイルを会話に取り込めます。Claude が持つコンテキストが多いほど、結果は良くなります。[ファイルとコンテキストを追加する](/docs/ja/desktop#add-files-and-context-to-prompts)を参照してください。

**繰り返し可能なタスクにスキルを使用する。** `/` を入力するか、**+** → **Slash commands** をクリックして、[組み込みコマンド](/docs/ja/commands)、[カスタムスキル](/docs/ja/skills)、およびプラグインスキルを参照します。スキルは、コードレビューチェックリストやデプロイメント手順など、必要なときに呼び出すことができる再利用可能なプロンプトです。

**コミット前に変更を確認する。** Claude がファイルを編集した後、`+12 -1` インジケーターが表示されます。それをクリックして[差分ビュー](/docs/ja/desktop#review-changes-with-diff-view)を開き、ファイルごとに変更を確認し、特定の行にコメントを付けます。Claude はコメントを読んで修正します。Claude 自身に変更をレビューさせるには、プロンプトボックスに [`/code-review`](/docs/ja/desktop#review-your-code) と入力します。

**制御の量を調整する。** [権限モード](/docs/ja/desktop#choose-a-permission-mode)は、Claude が承認を求めずに実行できる量を設定します。

* **Auto**: 分類器がバックグラウンドでアクションを確認し、質問する代わりにリスクのあるものをブロックします。
* **Manual**: Claude はファイルを編集またはコマンドを実行する前に確認を求めます。
* **Accept edits**: Claude はファイル編集を自動的に受け入れ、より高速な反復を実現します。
* **Plan**: Claude は任意のファイルを編集せずにアプローチを提案します。これは大規模なリファクタリング前に役立ちます。

**より多くの機能のためにプラグインを追加する。** スキル、エージェント、MCP サーバーなどを追加する[プラグイン](/docs/ja/desktop#install-plugins)をインストールします。

**ワークスペースを整理する。** チャット、diff、ターミナル、ファイル、ブラウザーペインを任意のレイアウトにドラッグします。**Ctrl+\`** でターミナルを開いてセッションと並行してコマンドを実行するか、ファイルパスをクリックして開きます。[ワークスペースを整理する](/docs/ja/desktop#arrange-your-workspace)を参照してください。

**アプリをプレビューする。** Desktop で開発サーバーを実行すると、アプリはブラウザーペインで開きます。ブラウザーペインは [外部サイトを開く](/docs/ja/desktop#browse-external-sites)こともできます。Claude は実行中のアプリを表示し、エンドポイントをテストし、ログを検査し、表示されているものに対して反復できます。[アプリをプレビューする](/docs/ja/desktop#preview-your-app)を参照してください。

**プルリクエストを追跡する。** PR を開いた後、Claude Code は CI チェック結果を監視し、失敗を自動的に修正できます。[プルリクエストステータスを監視する](/docs/ja/desktop#monitor-pull-request-status)を参照してください。

**Claude をスケジュールに設定する。** [スケジュール済みタスク](/docs/ja/desktop-scheduled-tasks)を設定して、Claude を定期的に自動実行します。毎朝のコードレビュー、週次の依存関係監査、または接続されたツールから情報を取得するブリーフィングです。

**準備ができたらスケールアップする。** サイドバーから [並列セッション](/docs/ja/desktop#work-in-parallel-with-sessions)を開いて複数のタスクを同時に実行します。各セッションは必要に応じて独自の Git worktree で実行でき、[タスクペイン](/docs/ja/desktop#watch-background-tasks)を開いてセッションが実行しているサブエージェントとバックグラウンドコマンドを監視します。[サイドチャット](/docs/ja/desktop#ask-a-side-question-without-derailing-the-session)を開いてメインスレッドを脱線させずに質問を尋ねます。[長時間実行される作業をクラウドに送信](/docs/ja/desktop#run-long-running-tasks-in-the-cloud)して、アプリを閉じても続行するか、タスクが予想より長くかかる場合は[すでに開始したセッションをクラウドに移動](/docs/ja/desktop#continue-in-another-surface)します。[GitHub、Slack、Linear などの外部ツールを接続](/docs/ja/desktop#extend-claude-code)して、ワークフローをまとめます。

## 次のステップ

* [Claude Code Desktop を使用する](/docs/ja/desktop)：権限モード、並列セッション、diff ビュー、コネクタ、およびエンタープライズ設定
* [CLI から移行する場合](/docs/ja/desktop#coming-from-the-cli)：Desktop と CLI を同じプロジェクトで実行し、機能、フラグの同等物、および Desktop で利用できない機能を比較する
* [トラブルシューティング](/docs/ja/desktop#troubleshooting)：一般的なエラーとセットアップの問題の解決策
* [ベストプラクティス](/docs/ja/best-practices)：効果的なプロンプトを作成し、Claude Code を最大限に活用するためのヒント
* [一般的なワークフロー](/docs/ja/common-workflows)：デバッグ、リファクタリング、テストなどのチュートリアル
