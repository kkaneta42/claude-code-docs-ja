> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# ウェブでタスクをスケジュール設定する

> クラウドスケジュール設定タスクで定期的な作業を自動化する

スケジュール設定されたタスクは、Anthropic が管理するインフラストラクチャを使用して、定期的なケイデンスでプロンプトを実行します。タスクはコンピュータがオフの場合でも動作し続けます。

自動化できる定期的な作業の例をいくつか示します。

* 毎朝オープンなプルリクエストをレビューする
* 夜間に CI の失敗を分析し、サマリーを表示する
* PR マージ後にドキュメントを同期する
* 毎週依存関係の監査を実行する

スケジュール設定されたタスクは、Pro、Max、Team、Enterprise を含むすべての Claude Code ウェブユーザーが利用できます。

## スケジュール設定オプションを比較する

Claude Code offers three ways to schedule recurring work:

|                            | [Cloud](/en/web-scheduled-tasks) | [Desktop](/en/desktop-scheduled-tasks) | [`/loop`](/en/scheduled-tasks) |
| :------------------------- | :------------------------------- | :------------------------------------- | :----------------------------- |
| Runs on                    | Anthropic cloud                  | Your machine                           | Your machine                   |
| Requires machine on        | No                               | Yes                                    | Yes                            |
| Requires open session      | No                               | No                                     | Yes                            |
| Persistent across restarts | Yes                              | Yes                                    | No (session-scoped)            |
| Access to local files      | No (fresh clone)                 | Yes                                    | Yes                            |
| MCP servers                | Connectors configured per task   | [Config files](/en/mcp) and connectors | Inherits from session          |
| Permission prompts         | No (runs autonomously)           | Configurable per task                  | Inherits from session          |
| Customizable schedule      | Via `/schedule` in the CLI       | Yes                                    | Yes                            |
| Minimum interval           | 1 hour                           | 1 minute                               | 1 minute                       |

<Tip>
  Use **cloud tasks** for work that should run reliably without your machine. Use **Desktop tasks** when you need access to local files and tools. Use **`/loop`** for quick polling during a session.
</Tip>

## スケジュール設定されたタスクを作成する

スケジュール設定されたタスクは 3 つの場所から作成できます。

* **ウェブ**: [claude.ai/code/scheduled](https://claude.ai/code/scheduled) にアクセスして、**New scheduled task** をクリックします
* **デスクトップアプリ**: **Schedule** ページを開き、**New task** をクリックして、**New remote task** を選択します。詳細は [Desktop scheduled tasks](/ja/desktop#schedule-recurring-tasks) を参照してください。
* **CLI**: 任意のセッションで `/schedule` を実行します。Claude がセットアップを会話形式で案内します。説明を直接渡すこともできます。例えば、`/schedule daily PR review at 9am` のようにします。

ウェブとデスクトップのエントリーポイントはフォームを開きます。CLI は同じ情報をガイド付き会話を通じて収集します。

以下のステップはウェブインターフェースを通じて説明します。

<Steps>
  <Step title="作成フォームを開く">
    [claude.ai/code/scheduled](https://claude.ai/code/scheduled) にアクセスして、**New scheduled task** をクリックします。
  </Step>

  <Step title="タスクに名前を付けてプロンプトを作成する">
    タスクに説明的な名前を付け、Claude が毎回実行するプロンプトを作成します。プロンプトが最も重要な部分です。タスクは自律的に実行されるため、プロンプトは自己完結型で、何をするか、成功がどのようなものかについて明確である必要があります。

    プロンプト入力にはモデルセレクターが含まれています。Claude はタスクの各実行にこのモデルを使用します。
  </Step>

  <Step title="リポジトリを選択する">
    Claude が作業する 1 つ以上の GitHub リポジトリを追加します。各リポジトリは実行の開始時にデフォルトブランチから複製されます。Claude は変更用に `claude/` プレフィックス付きブランチを作成します。任意のブランチへのプッシュを許可するには、そのリポジトリに対して **Allow unrestricted branch pushes** を有効にします。
  </Step>

  <Step title="環境を選択する">
    タスク用に [cloud environment](/ja/claude-code-on-the-web#cloud-environment) を選択します。環境は、クラウドセッションがアクセスできるものを制御します。

    * **Network access**: 各実行中に利用可能なインターネットアクセスのレベルを設定します
    * **Environment variables**: Claude が使用できる API キー、トークン、またはその他のシークレットを提供します
    * **Setup script**: 依存関係のインストールやツールの構成など、各セッション開始前にインストールコマンドを実行します

    **Default** 環境はすぐに利用可能です。カスタム環境を使用するには、タスクを作成する前に [create one](/ja/claude-code-on-the-web#cloud-environment) を実行してください。
  </Step>

  <Step title="スケジュールを選択する">
    [frequency options](#frequency-options) からタスクの実行頻度を選択します。デフォルトは現地時間の毎日午前 9:00 です。タスクはスケジュール設定された時間の数分後に実行される場合があります。

    プリセットオプションがニーズに合わない場合は、最も近いものを選択し、CLI から `/schedule update` を使用してスケジュールを更新して、特定のスケジュールを設定します。
  </Step>

  <Step title="コネクターを確認する">
    接続されているすべての [MCP connectors](/ja/mcp) はデフォルトで含まれています。タスクが必要としないものを削除します。コネクターは Claude に各実行中に Slack、Linear、Google Drive などの外部サービスへのアクセスを提供します。
  </Step>

  <Step title="タスクを作成する">
    **Create** をクリックします。タスクはスケジュール設定されたタスクリストに表示され、次のスケジュール設定された時間に自動的に実行されます。各実行は他のセッションと並行して新しいセッションを作成し、Claude が何をしたかを確認し、変更をレビューし、プルリクエストを作成できます。実行をすぐにトリガーするには、タスクの詳細ページから **Run now** をクリックします。
  </Step>
</Steps>

### 頻度オプション

スケジュールピッカーはタイムゾーン変換を処理するプリセット頻度を提供します。現地時間で時間を選択すると、クラウドインフラストラクチャがどこにあるかに関係なく、タスクはその壁時計時間で実行されます。

<Note>
  タスクはスケジュール設定された時間の数分後に実行される場合があります。オフセットは各タスクで一貫しています。
</Note>

| 頻度       | 説明                                           |
| :------- | :------------------------------------------- |
| Hourly   | 1 時間ごとに実行されます。                               |
| Daily    | 指定した時間に 1 日 1 回実行されます。デフォルトは現地時間の午前 9:00 です。 |
| Weekdays | Daily と同じですが、土曜日と日曜日をスキップします。                |
| Weekly   | 指定した曜日と時間に週 1 回実行されます。                       |

2 時間ごと、または毎月初日などのカスタム間隔の場合は、最も近いプリセットを選択し、CLI から `/schedule update` を使用してスケジュールを更新して、特定のスケジュールを設定します。

### リポジトリとブランチ権限

追加する各リポジトリは、すべての実行で複製されます。Claude はプロンプトで別途指定されない限り、リポジトリのデフォルトブランチから開始します。

デフォルトでは、Claude は `claude/` プレフィックス付きのブランチにのみプッシュできます。これにより、スケジュール設定されたタスクが保護されたブランチまたは長期的なブランチを誤って変更するのを防ぎます。

特定のリポジトリに対してこの制限を削除するには、タスクを作成または編集するときに、そのリポジトリに対して **Allow unrestricted branch pushes** を有効にします。

### コネクター

スケジュール設定されたタスクは、接続されている MCP コネクターを使用して、各実行中に外部サービスから読み取り、外部サービスに書き込むことができます。例えば、サポートリクエストをトリアージするタスクは、Slack チャネルから読み取り、Linear で問題を作成する場合があります。

タスクを作成すると、現在接続されているすべてのコネクターがデフォルトで含まれます。実行中に Claude がアクセスできるツールを制限するために、必要のないものを削除します。タスクフォームからコネクターを直接追加することもできます。

タスクフォーム外でコネクターを管理または追加するには、claude.ai で **Settings > Connectors** にアクセスするか、CLI で `/schedule update` を使用します。

### 環境

各タスクは、ネットワークアクセス、環境変数、セットアップスクリプトを制御する [cloud environment](/ja/claude-code-on-the-web#cloud-environment) で実行されます。タスク作成前に環境を構成して、Claude に API へのアクセス、依存関係のインストール、またはネットワークスコープの制限を提供します。完全なセットアップガイドについては、[cloud environment](/ja/claude-code-on-the-web#cloud-environment) を参照してください。

## スケジュール設定されたタスクを管理する

**Scheduled** リストのタスクをクリックして、その詳細ページを開きます。詳細ページには、タスクのリポジトリ、コネクター、プロンプト、スケジュール、および過去の実行のリストが表示されます。

### 実行を表示して操作する

任意の実行をクリックして、それを完全なセッションとして開きます。そこから、Claude が何をしたかを確認し、変更をレビューし、プルリクエストを作成するか、会話を続けることができます。各実行セッションは他のセッションと同じように機能します。セッションタイトルの横のドロップダウンメニューを使用して、セッションの名前変更、アーカイブ、または削除を行います。

### タスクを編集して制御する

タスク詳細ページから、以下を実行できます。

* **Run now** をクリックして、次のスケジュール設定された時間を待たずに実行をすぐに開始します。
* **Repeats** セクションのトグルを使用して、スケジュールを一時停止または再開します。一時停止されたタスクは構成を保持しますが、再度有効にするまで実行されません。
* 編集アイコンをクリックして、名前、プロンプト、スケジュール、リポジトリ、環境、またはコネクターを変更します。
* 削除アイコンをクリックして、タスクを削除します。タスクによって作成された過去のセッションはセッションリストに残ります。

CLI から `/schedule` を使用してタスクを管理することもできます。`/schedule list` を実行してすべてのタスクを表示し、`/schedule update` を実行してタスクを変更するか、`/schedule run` を実行して 1 つをすぐにトリガーします。

## 関連リソース

* [Desktop scheduled tasks](/ja/desktop#schedule-recurring-tasks): ローカルファイルへのアクセス権を持つマシンで実行されるタスクをスケジュール設定します。デスクトップアプリの **Schedule** ページは、同じグリッドにローカルタスクとリモートタスクの両方を表示します。
* [`/loop` and CLI scheduled tasks](/ja/scheduled-tasks): CLI セッション内での軽量スケジュール設定
* [Cloud environment](/ja/claude-code-on-the-web#cloud-environment): クラウドタスクのランタイム環境を構成します
* [MCP connectors](/ja/mcp): Slack、Linear、Google Drive などの外部サービスを接続します
* [GitHub Actions](/ja/github-actions): リポジトリイベントで CI パイプラインで Claude を実行します
