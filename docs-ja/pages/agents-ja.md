> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# エージェントを並列実行する

> Claude Code が複数のタスクを同時に実行する 5 つの方法を比較します。サブエージェント、エージェントビュー、エージェントチーム、動的ワークフロー、およびプロジェクトについて説明します。

Claude Code には、複数のタスクを同時に処理する 5 つの方法があります。[サブエージェント](https://code.claude.com/docs/ja/sub-agents.md)、[エージェントビュー](https://code.claude.com/docs/ja/agent-view.md)、[エージェントチーム](https://code.claude.com/docs/ja/agent-teams.md)、[動的ワークフロー](https://code.claude.com/docs/ja/workflows.md)、および [プロジェクト](https://code.claude.com/docs/ja/claude-projects.md) です。これらは、各会話に自分で留まるのか、Claude にワーカーのグループを調整させるのかという関与の度合いや、作業がマシン上で実行されるのかクラウドで実行されるのかという点で異なります。

| アプローチ | 提供内容 | 使用する場合 |
| :- | :- | :- |
| [サブエージェント](https://code.claude.com/docs/ja/sub-agents.md) | 1 つのセッション内で委任されたワーカーが、独自のコンテキストでサイドタスクを実行し、サマリーを返す | サイドタスクが検索結果、ログ、またはファイルコンテンツで主な会話を埋め尽くす場合（再度参照しない） |
| [エージェントビュー](https://code.claude.com/docs/ja/agent-view.md) | `claude agents` で開く、バックグラウンドで実行されているセッションをディスパッチして監視する 1 つの画面。リサーチプレビュー | 複数の独立したタスクがあり、それらを引き継いで、一目で状態を確認し、必要な場合のみ介入したい場合 |
| [エージェントチーム](https://code.claude.com/docs/ja/agent-teams.md) | 共有タスクリストとエージェント間メッセージングを備えた複数の調整されたセッション。リーダーによって管理される。実験的で、デフォルトでは無効 | Claude にプロジェクトを分割させ、割り当てさせ、ワーカーを同期させたい場合 |
| [プロジェクト](https://code.claude.com/docs/ja/claude-projects.md) | claude.ai/code またはデスクトップアプリでの 1 つの継続的な会話。Claude は threads と呼ばれる並列セッションを開始し、クラウドで、またはリモートコントロール経由でコンピューターで実行し、各セッションにプロジェクトの指示を提供し、どのセッションがあなたを必要としているかを表示します。Pro および Max でのパブリックベータ | 作業が数日または数週間にわたる多くのタスクに及び、マシンがオフの場合でも実行を続け、各セッションをディスパッチして追跡するのではなく、一度説明したい場合 |
| [動的ワークフロー](https://code.claude.com/docs/ja/workflows.md) | 多くのサブエージェントを実行し、その結果をチェックするスクリプト。1 回のターンで調整するには大きすぎるジョブ向け | タスクが大きすぎてサブエージェント数個では対応できない場合、または検出結果を相互に検証したい場合。コードベース全体の監査、500 ファイルのマイグレーション、相互検証が必要な調査、または複数の角度から作成されたプランなど |

すべてのアプローチにおいて、ワーカーは Claude セッションです。別のツールを関与させるには、それを Claude に [MCP サーバー](https://code.claude.com/docs/ja/mcp.md) として公開します。

この作業をサポートする 3 つの追加ツールがありますが、エージェント自体を実行する方法ではありません。

* [Worktree](https://code.claude.com/docs/ja/worktrees.md) は各セッションに個別の git チェックアウトを提供するため、並列セッションはそれぞれ自分のファイルのコピーを編集します。自分で実行するセッションに使用します。エージェントビューからディスパッチしたセッションは、[ファイルを編集する前に専用の worktree に移動](https://code.claude.com/docs/ja/agent-view.md#how-file-edits-are-isolated) し、スポーンするサブエージェントもそれぞれ worktree を取得できます。
* [クロスセッションメッセージング](https://code.claude.com/docs/ja/cross-session-messaging.md) により、Claude はこのマシン上、別のマシン上、または [クラウド](https://code.claude.com/docs/ja/claude-code-on-the-web.md) 上の他の Claude Code セッションをリストして、メッセージを送信できます。自分で実行するセッションは、検出結果とステータスを相互に渡すことができます。
* [`/batch`](https://code.claude.com/docs/ja/commands) は、1 つの大きな変更を 5 ～ 30 個のワークツリー分離サブエージェントに分割する [skill](https://code.claude.com/docs/ja/skills.md) です。これはサブエージェントとワークツリーのパッケージ化された使用法であり、別の調整スタイルではありません。

他にも Claude を各ステップで駆動することなく実行する機能がいくつかありますが、これらはエージェント間で作業を分割することとは異なる問題を解決します。

* [バックグラウンド bash コマンド](https://code.claude.com/docs/ja/interactive-mode.md#background-bash-commands) は、会話をブロックすることなく 1 つのシェルコマンドを実行します。エージェントをスポーンしません。
* [フォークされたサブエージェント](https://code.claude.com/docs/ja/sub-agents.md#fork-the-current-conversation) は、新規に開始する代わりに完全な会話コンテキストを継承するサブエージェントです。これはサブエージェントをスポーンする方法であり、別のサーフェスではありません。`/subtask` で開始します。Claude は [フォークモード](https://code.claude.com/docs/ja/sub-agents.md#turn-fork-mode-on-or-off) がオンの場合、自身でもスポーンします。完全なセッションを、それと並行して実行する新しい [バックグラウンドセッション](https://code.claude.com/docs/ja/agent-view.md#from-inside-a-session) にコピーするには、`/fork` を使用します。[エージェントビューがオフ](https://code.claude.com/docs/ja/agent-view.md#turn-off-agent-view) の場合、フォークされたサブエージェントコマンドは `/fork` に変わり、`/subtask` は利用できません。
* [クラウドスケジュールタスク](https://code.claude.com/docs/ja/routines.md) は、マシン上で並列に実行するのではなく、クラウドでスケジュールに従ってセッションを実行します。

> [!NOTE]
>
> 複数のセッションまたはサブエージェントを同時に実行すると、トークン使用量が増加します。使用量とレート制限の詳細については、[コスト](https://code.claude.com/docs/ja/costs.md) を参照してください。

## アプローチを選択する

適切なアプローチは、誰が作業を調整するか、ワーカーが通信する必要があるかどうか、および同じファイルを編集するかどうかによって異なります。

* **誰が作業を調整するか？**
  * Claude が 1 つの会話内で委任と結果の収集を行う場合：[サブエージェント](https://code.claude.com/docs/ja/sub-agents.md)
  * 独立したタスクを引き継いで後で確認する場合：[エージェントビュー](https://code.claude.com/docs/ja/agent-view.md)
  * Claude がワーカーのグループを計画、割り当て、監督する場合：[エージェントチーム](https://code.claude.com/docs/ja/agent-teams.md)（実験的で、デフォルトでは無効）
  * スクリプトが Claude のターンバイターン判断の代わりに計画を保持する場合：[動的ワークフロー](https://code.claude.com/docs/ja/workflows.md)。[ワークフローがサブエージェントとスキルとどのように比較されるか](https://code.claude.com/docs/ja/workflows.md#when-to-use-a-workflow)を参照してください
* **ワーカーが互いに通信する必要があるか？** Claude は [クロスセッションメッセージング](https://code.claude.com/docs/ja/cross-session-messaging.md)を使用して、自分で実行するセッション（エージェントビューから派遣するセッションを含む）間で調査結果を渡すことができます。サブエージェントは結果をそれらを生成した会話に報告し、エージェントビューセッションはあなたにのみ報告します。エージェントチームのチームメイトは互いに直接メッセージを送信し、[Task ツールを持つ場合](https://code.claude.com/docs/ja/tools-reference.md#task-tool-availability)、タスクリストを共有します。
* **タスクが同じファイルに触れるか？** [ワークツリー](https://code.claude.com/docs/ja/worktrees.md)で作業を分離します。サブエージェントと自分で実行するセッションは、それぞれ個別のワークツリーを使用できます。エージェントチームはチームメイトをワークツリーで分離しないため、[作業を分割](https://code.claude.com/docs/ja/agent-teams.md#avoid-file-conflicts)して、各チームメイトが異なるファイルセットを所有するようにします。

## 実行中の作業を確認する

実行中の作業を確認するコマンドは、使用したアプローチによって異なります。

* バックグラウンドセッションの場合、`claude agents` は [エージェントビュー](https://code.claude.com/docs/ja/agent-view.md) を開きます。すべてのセッション、その状態、および入力が必要なセッションを表示する 1 つの画面です。
* 現在のセッション内のサブエージェントの場合、名前付きバックグラウンドサブエージェントは @-メンション入力補完に状態とともに表示されます。`/agents` コマンドは、サブエージェントファイルの場所を指すお知らせを出力します。[カスタムサブエージェントを作成および編集](https://code.claude.com/docs/ja/sub-agents.md#configure-subagents) するには、Claude に質問するか、ファイルを直接編集してください。名前は似ていますが、`/agents` は `claude agents` とは別です。
* 現在のセッションのバックグラウンドで実行されているもの場合、`/tasks` は各項目をリストし、確認、アタッチ、または停止できます。リストには完了したサブエージェントも含まれます。
* 動的ワークフローの場合、`/workflows` は実行中および完了した実行、各実行がある段階、および完了したエージェント数をリストします。

すべてのセッションのデスクトップビューについては、[デスクトップアプリでのセッションの並列実行](https://code.claude.com/docs/ja/desktop.md#work-in-parallel-with-sessions) を参照してください。

## 詳細情報

各ガイド以下は、1 つのアプローチのセットアップと構成をカバーしています。

* [カスタムサブエージェントを作成する](https://code.claude.com/docs/ja/sub-agents.md)：再利用可能なスペシャリストを定義し、使用できるツールを制御します。
* [エージェントビューでエージェントを管理する](https://code.claude.com/docs/ja/agent-view.md)：セッションをディスパッチし、その状態を監視し、必要な場合にアタッチします。
* [エージェントチームを調整する](https://code.claude.com/docs/ja/agent-teams.md)：リーダーとチームメイトをセットアップし、タスクを割り当て、その作業をレビューします。
* [動的ワークフローを調整する](https://code.claude.com/docs/ja/workflows.md)：バンドルされたワークフローを実行するか、多くのサブエージェントを実行し、その結果を相互に検証する Claude が作成したワークフローを実行します。
* [ワークツリーで並列セッションを実行する](https://code.claude.com/docs/ja/worktrees.md)：分離されたチェックアウトで Claude を開始し、コピーされるものを制御し、その後クリーンアップします。
