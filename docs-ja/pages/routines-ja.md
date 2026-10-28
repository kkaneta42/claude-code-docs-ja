> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# スケジュールタスクで作業を自動化する

> Claude Code を自動操縦に設定します。スケジュール、API 呼び出し、または GitHub イベントに応じてクラウドで実行されるスケジュールタスク（旧称ルーティン）を作成します。

> [!NOTE]
>
> スケジュールタスクはリサーチプレビュー段階です。動作、制限、API サーフェスは変更される可能性があります。

クラウドスケジュールタスク（旧称ルーティン）は、保存された Claude Code の設定です。プロンプト、1 つ以上のリポジトリ、一連の[コネクタ](https://code.claude.com/docs/ja/mcp.md)を一度パッケージ化し、自動的に実行します。スケジュールタスクは Anthropic が管理するクラウドインフラストラクチャ上で実行されるか、ルーティングされた場合は組織の[セルフホスト環境](https://code.claude.com/docs/ja/self-hosted-environments)で実行されるため、ラップトップを閉じても動作し続けます。

各スケジュールタスクには、1 つ以上のトリガーを設定できます。

* **スケジュール**: 1 時間ごと、毎晩、毎週など定期的なペースで実行するか、将来の特定の時刻に 1 回実行
* **API**: ベアラートークンを付けてタスク固有のエンドポイントに HTTP POST を送信し、オンデマンドでトリガー
* **GitHub**: プルリクエストやリリースなどのリポジトリイベントに応じて自動的に実行

1 つのスケジュールタスクで複数のトリガーを組み合わせることができます。たとえば、PR レビュータスクを毎晩実行し、デプロイスクリプトからトリガーし、さらに新しい PR すべてに反応させることもできます。

スケジュールタスクにスケジュールは必須ではありません。

* API トリガーのみを持つタスクは、そのエンドポイントを呼び出したときに実行されます。
* GitHub トリガーのみを持つタスクは、一致するリポジトリイベントが発生したときに実行されます。

スケジュールタスクは Pro、Max、Team、Enterprise プランで利用できます。[claude.ai/code/routines](https://claude.ai/code/routines) で作成・管理するか、CLI で `/schedule` を使用します。以前の名前であるルーティンは[引き続き表示されます](#where-the-name-routines-still-appears)。

> [!NOTE]
>
> クラウドではなくマシン上で作業をスケジュールする機能が他に 2 つあります。[Desktop スケジュールタスク](https://code.claude.com/docs/ja/desktop-scheduled-tasks.md)と [`/loop`](https://code.claude.com/docs/ja/scheduled-tasks) です。3 つの中から選ぶには、[スケジューリングオプションを比較する](https://code.claude.com/docs/ja/scheduled-tasks.md#compare-scheduling-options)を参照してください。

Team および Enterprise の Owner は、[**Organization settings > Capabilities > Remote sessions**](https://claude.ai/admin-settings/capabilities) の **Scheduled tasks (Was Routines)** トグルを使用して、すべてのメンバーのスケジュールタスクをオフにできます。トグルがオフの場合、既存のスケジュールタスクは実行を停止し、メンバーは新しいスケジュールタスクを作成できません。

Enterprise 組織が[カスタムロール](https://support.claude.com/en/articles/13930452)でアクセスを管理している場合は、スケジュールタスクの権限を含むロールも必要です。Owner は [**Organization settings > Roles**](https://claude.ai/admin-settings/roles) でロールの **Remote sessions** セクションにこの権限を追加できます。

## ユースケースの例

各例は、トリガータイプと、スケジュールタスクに適した作業の種類を組み合わせたものです。いずれも無人で実行でき、繰り返し可能で、明確な成果に結びついています。

* **バックログメンテナンス**: スケジュールトリガーが平日の毎晩リポジトリで実行され、課題トラッカーがコネクタとして追加されています。スケジュールタスクは前回の実行以降にオープンされた課題を読み取り、ラベルを付け、参照されているコード領域に基づいて担当者を割り当てます。その後 Slack に概要を投稿するため、チームは整理されたキューで 1 日を始められます。
* **アラートトリアージ**: エラーのしきい値を超えたときに監視ツールがスケジュールタスクの API エンドポイントを呼び出し、アラート本文を `text` として渡します。タスクのプロンプトは fire ペイロード内のアラートを調査するよう Claude に指示しているため、Claude はスタックトレースを取得し、リポジトリの最近のコミットと照合します。その後、修正案とアラートへのリンクを含むドラフトプルリクエストを作成します。オンコール担当者は空のターミナルから始めるのではなく、PR をレビューします。
* **独自のコードレビュー**: GitHub トリガーが `pull_request.opened` で実行されます。スケジュールタスクはチーム独自のレビューチェックリストを適用し、セキュリティ、パフォーマンス、スタイルの問題についてインラインコメントを残します。また概要コメントも追加するため、人間のレビュアーは機械的なチェックではなく設計に集中できます。
* **デプロイ検証**: CD パイプラインが本番デプロイのたびにスケジュールタスクの API エンドポイントを呼び出します。タスクは新しいビルドに対してスモークチェックを実行し、エラーログをスキャンしてリグレッションを探し、デプロイウィンドウが閉じる前にリリースチャンネルに go または no-go を投稿します。
* **ドキュメントのずれ**: スケジュールトリガーが毎週実行されます。スケジュールタスクは前回の実行以降にマージされた PR をスキャンし、変更された API を参照しているドキュメントを指摘して、編集者がレビューできるようドキュメントリポジトリに更新 PR を作成します。
* **ライブラリの移植**: GitHub トリガーが `pull_request.closed` で実行され、1 つの SDK リポジトリのマージ済み PR に絞り込まれています。スケジュールタスクは変更を別の言語の対応する SDK に移植して対応する PR を作成するため、人間が各変更を再実装しなくても 2 つのライブラリの歩調がそろいます。

## スケジュールタスクを作成する

スケジュールタスクは、[claude.ai/code/routines](https://claude.ai/code/routines) の Web、Desktop アプリ、または CLI から作成できます。3 つのサーフェスはすべて同じクラウドアカウントに書き込むため、どれかで作成したスケジュールタスクは他のサーフェスにもすぐに表示されます。Desktop アプリの **Code** タブで、サイドバーまたはサイドバーの **More** メニューにある **Scheduled** をクリックしてから **New task** をクリックし、[Web から作成する](#create-from-the-web)の手順に進みます。

スケジュールタスクは完全な Claude Code クラウドセッションとして自律的に実行されます。セッションはシェルコマンドを実行し、[スキル](https://code.claude.com/docs/ja/skills.md)を使用し、含めたコネクタを呼び出します。[プロジェクト](https://code.claude.com/docs/ja/claude-projects.md#what-threads-pick-up-from-your-repositories)のスレッドの外では、これらのスキルにはクローンされたリポジトリにコミットされたスキルも含まれます。タスクの作成時に権限モードは選択しません。実行が停止してユーザーを待つ場合については、[実行中の権限プロンプト](#permission-prompts-during-a-run)を参照してください。

スケジュールタスクがアクセスできる範囲は、次によって決まります。

* 選択したリポジトリ
* [環境](https://code.claude.com/docs/ja/cloud-environments.md)のネットワークアクセスと変数
* 含めたコネクタ

それぞれを、タスクが必要とするものに限定してください。

スケジュールタスクは個人の claude.ai アカウントに属します。チームメイトとは共有されず、その実行はアカウントの[使用量と制限](#usage-and-limits)にカウントされます。スケジュールタスクが接続された GitHub ID やコネクタを通じて行うことは、すべてユーザー本人によるものとして表示されます。コミットとプルリクエストにはユーザーの GitHub ユーザーが記録され、Slack メッセージ、Linear チケット、その他のコネクタアクションでは、それぞれのサービスにリンクされたユーザーのアカウントが使用されます。

### Web から作成する

**1. 作成ダイアログを開く**

[claude.ai/code/routines](https://claude.ai/code/routines) にアクセスし、**New task** をクリックして **New scheduled task** ダイアログを開きます。先に進む前に、次の画面が表示されていないか確認してください。

* ボタンが **New task** ではなく **New routine** と表示されている場合は、**New routine** をクリックし、[全画面フォーム](#full-page-form)に進みます。
* Desktop アプリで **Local** と **Cloud** のメニューが開いた場合は、[全画面フォーム](#full-page-form)に進みます。
* **Create with Claude** と **Set up manually** のメニューが開いた場合は、**Set up manually** を選択してダイアログを開きます。**Create with Claude** を選ぶと、代わりにチャットでタスクを説明し、Claude に作成させることができます。
* ダイアログの代わりに全画面のページが開いた場合は、[全画面フォーム](#full-page-form)に進みます。

ダイアログを開いた時点で **Repositories** と **Environment** がすでに表示されている場合は、[そのダイアログの違い](#dialog-with-repositories-and-environment-in-the-main-view)を参照してください。それ以外の場合、このダイアログは claude.ai チャット用のスケジュールタスクも作成します。ダイアログで Claude Code タスクと呼ばれるものにするには、以降の手順でリポジトリを選択するか、GitHub イベントまたは API トリガーを追加します。この種類のタスクは、クラウドセッションで Claude Code を実行します。

**2. タスクに名前を付けてプロンプトを書く**

スケジュールタスクにわかりやすい名前を付け、Claude が毎回実行するプロンプトを書きます。プロンプトが最も重要な部分です。タスクは自律的に実行されるため、プロンプトは自己完結しており、何をすべきか、何をもって成功とするかを明確に示す必要があります。

トリガーが発火すると、セッションは保存されたプロンプトを割り当てられたタスクとして受け取り、実行します。会話の途中で届いた信頼できないコンテンツとしては扱いません。トリガーが証明するのは、そのプロンプトがアカウント上の認可されたセッションによって事前に保存されたことだけです。したがって、発火したプロンプトはライブのユーザー入力ではなく、実行中のアクションに対する承認や同意として機能することはできません。セッションが実行中に取得するコンテンツは、通常どおりに扱われます。

**3. トリガーを選択する**

**Trigger** 行で、タスクの開始方法を選択します。複数のトリガーを組み合わせるには、行の末尾にある **+** をクリックします。

**Schedule**

定期実行のプリセット頻度を選択します。タイムゾーンの扱い、遅延開始、カスタム cron 間隔、1 回限りの実行については、[スケジュールトリガーを追加する](#add-a-schedule-trigger)を参照してください。

**GitHub event**

リポジトリ、反応するイベント、およびオプションのフィルタを選択します。サポートされているイベントとフィルタフィールドの完全なリストについては、[GitHub トリガーを追加する](#add-a-github-trigger)を参照してください。

**API**

ここで **API** を選択します。**Create** をクリックすると、**API token** ダイアログにトークンが 1 回だけ表示されるため、ダイアログを閉じる前にコピーしてください。URL をコピーしたり新しいトークンを生成したりするには、[API トリガーを追加する](#add-an-api-trigger)を参照してください。

**4. リポジトリを選択する**

**Advanced settings** を展開します。**General** タブの **Repository** で、Claude が作業する 1 つ以上の GitHub リポジトリを選択します。

各リポジトリは実行の開始時にクローンされます。Claude は変更用に `claude/` プレフィックス付きのブランチを作成します。

**5. 環境を選択する**

リポジトリを選択すると、その下に **Cloud environment** が表示されます。タスク用の[クラウド環境](https://code.claude.com/docs/ja/cloud-environments.md)を選択します。環境は、クラウドセッションがアクセスできるものを制御します。

* **Network access**: 各実行中に利用可能なインターネットアクセスのレベルを設定します
* **Environment variables**: Claude が各実行中に使用できる値を提供します。これらは[環境を使用するすべてのユーザーに表示される](https://code.claude.com/docs/ja/cloud-environments.md#what-carries-over-from-your-setup)ため、Anthropic がホストする環境では、Claude が実行中に呼び出す API のキーは代わりに[ネットワークシークレット](https://code.claude.com/docs/ja/cloud-environments.md#add-network-secrets)として保存してください。そのセクションには、シークレットが付与されないリクエストも記載されています
* **Setup script**: タスクが必要とする依存関係とツールをインストールします。結果は[キャッシュ](https://code.claude.com/docs/ja/cloud-environments.md#environment-caching)されるため、スクリプトはセッションごとに再実行されません

**Default** 環境は **Trusted** ネットワークアクセスで提供されます。これにより、パッケージレジストリ、クラウドプロバイダー API、コンテナレジストリ、一般的な開発ドメインからなる[デフォルト許可リスト](https://code.claude.com/docs/ja/cloud-environments.md#default-allowed-domains)のみがセッションのネットワークを通じて許可されます。タスクに追加するコネクタは Anthropic のサーバーを通じてサービスにアクセスするため、許可リストを変更する必要はありません。

タスクが独自のサービスや、そのリストにないドメインに直接アクセスする必要がある場合は、実行前に環境の[ネットワークアクセス](https://code.claude.com/docs/ja/cloud-environments.md#network-access)を編集してください。別の環境を使用するには、先に[環境を作成](https://code.claude.com/docs/ja/cloud-environments.md#configure-your-environment)してください。

**6. モデルと effort レベルを選択する**

プロンプト入力のモデルセレクタで、Claude が毎回の実行で使用するモデルを選択します。Claude Code タスクの場合、モデルが [effort レベル](https://code.claude.com/docs/ja/model-config.md#adjust-effort-level)を提供していれば、同じセレクタの **Effort** に現在のレベルが表示されます。変更するには、別のレベルを選択します。セレクタの **Default** オプションにはレベルがありません。

**7. コネクタを確認する**

**Advanced settings** の **Connectors** タブに切り替えます。接続済みのすべての [MCP コネクタ](https://code.claude.com/docs/ja/mcp.md)がデフォルトで含まれています。タスクに不要なものは削除してください。Claude は、含まれているコネクタを書き込みも含めて実行中に使用できます。実行が停止して先にユーザーに確認を求める場合については、[実行中の権限プロンプト](#permission-prompts-during-a-run)を参照してください。

**8. タスクを作成する**

**Create** をクリックします。ダイアログが閉じ、新しいタスクの詳細ページが開きます。タスクは、トリガーのいずれかが次に一致したときに実行されます。すぐに実行を開始するには、詳細ページで **Run now** をクリックします。

実行内容を確認するには、詳細ページの **History** リストでその実行をクリックします。実行は[完全なセッションとして開き](#view-and-interact-with-runs)（実行ごとに新しいセッションが作成されます）、そこで Claude が行ったことの確認、変更のレビュー、プルリクエストの作成ができます。

#### メインビューに Repositories と Environment があるダイアログ

[Web から作成する手順](#create-from-the-web)に従い、各フィールドは **Advanced settings** ではなくダイアログのメインビューで入力します。このダイアログでは Claude Code タスクのみが作成されます。

GitHub イベントトリガーを追加する前にリポジトリを選択してください。リポジトリを選択するまで、そのトリガーは使用できません。

#### 全画面フォーム

Desktop アプリで **Local** と **Cloud** のメニューが開いた場合は、**Cloud** を選択します。**New routine** または **New scheduled task** というタイトルのページが開きます。各フィールドに入力します。

* **Name**: 名前を入力します。
* **Instructions**: プロンプトを入力します。同じボックスで、モデル、effort レベル（モデルが提供している場合）、リポジトリ、環境を選択します。それぞれが制御する内容については、[Web から作成する](#create-from-the-web)の手順を参照してください。
* **Select a trigger**: **Schedule**、**GitHub event**、**API** のいずれかを選択します。スケジュールについては、[スケジュールトリガーを追加する](#add-a-schedule-trigger)を参照してください。[GitHub イベント](#add-a-github-trigger)の場合は、リポジトリを選択します。[API トリガー](#add-an-api-trigger)の場合は、**Create** をクリックした後に開く **API token** ダイアログからトークンをコピーしてください。トークンは 1 回だけ表示されます。複数のトリガーを組み合わせるには、**Add another trigger** をクリックします。
* **Connectors**: 接続済みのすべてのコネクタがデフォルトで含まれているため、タスクに不要なものは削除してください。

**Create** が使用できない場合は、その上にカーソルを合わせると、フォームにまだ必要な項目が表示されます。**Create** をクリックすると、タスクの詳細ページが開きます。

### CLI から作成する

任意のセッションで `/schedule` を実行すると、会話形式でスケジュールタスクを作成できます。説明を直接渡すこともできます。定期タスクなら `/schedule daily PR review at 9am`、1 回限りなら `/schedule clean up feature flag in one week` のように指定します。Claude は Web ダイアログが収集するのと同じ情報を順に確認し、タスクをアカウントに保存します。このコマンドは `/routines` というエイリアスでも利用できます。

正常に開始されると、会話のように進みます。Claude は保存する前に、スケジュール、リポジトリ、プロンプトについて追加の質問をします。代わりに、認証が必要である、またはリモートの claude.ai アカウントに接続できないと Claude が返答した場合、スケジュールタスクは作成されていません。[トラブルシューティング](#troubleshooting)を参照してください。

`/schedule` で作成したタスクにはスケジュールトリガーがあります。他のトリガータイプを追加することもできます。

* **API トリガー**: [claude.ai/code/routines](https://claude.ai/code/routines) の Web でタスクを編集します
* **[GitHub トリガー](#add-a-github-trigger)**: Web でタスクを編集するか、CLI で Claude に依頼します。CLI から追加するには Claude Code v2.1.225 以降が必要です

API 呼び出しや GitHub イベントによってのみ開始されるものなど、スケジュールトリガーのないスケジュールタスクには次回の実行時刻がありません。Claude がそれを保存または更新するとき、CLI は何も表示しません。

## トリガーを設定する

スケジュールタスクは、トリガーのいずれかが一致したときに開始されます。タスクのトリガーは、タスクの[編集ダイアログ](#edit-and-control-scheduled-tasks)の **Trigger** 行でいつでも追加または削除できます。

タスクに 2 つ以上のトリガーがある場合、そのダイアログでは各トリガーにゴミ箱アイコンが表示されます。スケジュールトリガーまたは GitHub イベントトリガーを削除するには、そのゴミ箱アイコンをクリックしてから **Save changes** をクリックします。API トリガーを削除するには、代わりに[そのトークンを削除](#add-an-api-trigger)します。

### スケジュールトリガーを追加する

スケジュールトリガーは、定期的なペースで、または将来の特定の時刻に 1 回、タスクを実行します。Web のタスク作成ダイアログまたは編集ダイアログで、1 時間ごと、毎日、毎週などのプリセット頻度を選択します。

* **正時の実行**: 9:00 のように正時ちょうどに実行をスケジュールすると、数分遅れて開始される場合があります。スケジュールした時刻に近いタイミングで開始するには、9:07 のように正時から数分ずらした時刻を選択してください。
* **カスタム間隔**: プリセットにないペースの場合は、タスクを作成してから、その[編集ダイアログ](#edit-and-control-scheduled-tasks)で **Custom** を選択します。次に、2 時間ごとを表す `0 */2 * * *` などの cron 式を入力します。CLI から設定するには、[`/schedule update`](#manage-scheduled-tasks-from-the-cli) を実行します。1 時間に 1 回より頻繁に実行される式は拒否されます。
* **タイムゾーン**: プリセット頻度を選択する場合は、時刻をローカルのタイムゾーンで入力します。
* **cron 式のタイムゾーン**: 式が 5 つのフィールドだけで構成されている場合は、時刻を UTC で記述します。たとえば `0 9 * * 1-5` は平日の UTC 午前 9:00 に実行されます。フィールドが `CRON_TZ=` プレフィックスで始まる場合は、それを残してそのタイムゾーンで時刻を記述するか、プレフィックスを削除して UTC で記述します。

#### 1 回限りの実行をスケジュールする

1 回限りのスケジュールは、特定のタイムスタンプでタスクを 1 回だけ実行します。たとえば、次のような用途に使用します。

* 週の後半に自分へリマインドする
* ロールアウト完了後にクリーンアップ PR を作成する
* アップストリームの変更がリリースされた後にフォローアップ作業を開始する

タスクは実行後に自動的にオフになり、Web UI では **Completed** と表示されます。再度実行するには、Web でタスクの[編集ダイアログ](#edit-and-control-scheduled-tasks)を開き、ダイアログに表示されているラベルに応じて **One-time** または **Once** を選択します。次に、ローカルのタイムゾーンで新しい日付と時刻を設定して保存します。

CLI から 1 回限りの実行を作成するには、時刻を自然言語で記述します。Claude は現在時刻を基準にその表現を解釈し、保存する前に絶対タイムスタンプを確認します。

```text theme={null}
/schedule tomorrow at 9am, summarize yesterday's merged PRs
```

```text theme={null}
/schedule in 2 weeks, open a cleanup PR that removes the feature flag
```

1 回限りの実行は、他のスケジュール実行と同じ 1 時間あたりの制限にカウントされます。詳細については、[使用量と制限](#usage-and-limits)を参照してください。

### API トリガーを追加する

API トリガーは、スケジュールタスクに専用の HTTP エンドポイントを提供します。タスクのベアラートークンを付けてエンドポイントに POST すると、新しいセッションが開始され、セッション URL が返されます。これを使用して、Claude Code をアラートシステム、デプロイパイプライン、社内ツールなど、認証済み HTTP リクエストを送信できるあらゆる場所に接続できます。

API トリガーは、[タスクの作成](#create-from-the-web)時、または後から以下の手順で、Web から追加します。CLI から API トリガーを追加したり、そのトークンを管理したりすることはできません。

**1. タスクを編集用に開く**

[claude.ai/code/routines](https://claude.ai/code/routines) にアクセスし、API 経由でトリガーするスケジュールタスクをクリックしてから、名前の横にあるメニューを開いて **Edit** を選択します。**Edit scheduled task** ダイアログが開きます。

**2. API トリガーを追加する**

**Trigger** 行で **+** をクリックし、開いたメニューから **API** を選択します。このタスクの **Fire URL** と **Token** を含むパネルが表示されます。

**3. URL をコピーしてトークンを生成する**

**Fire URL** をコピーします。**Generate token** をクリックし、**Token generated** ダイアログからすぐにトークンをコピーします。トークンは 1 回だけ表示され、後から取得することはできないため、アラートツールのシークレットストアなどの安全な場所に保存してください。

API トリガーはトークンを生成した時点で有効になります。**Save changes** をクリックする必要はないため、完了したらダイアログを閉じてください。

**4. エンドポイントを呼び出す**

URL に POST するときに、`Authorization: Bearer` ヘッダーでトークンを送信します。完全な例は[スケジュールタスクをトリガーする](#trigger-a-scheduled-task)に示されています。

各スケジュールタスクには独自のトークンがあり、そのタスクのトリガーのみにスコープされています。API アクセスをオフにする、またはトークンをローテーションするには、[タスクの **Edit scheduled task** ダイアログ](#edit-and-control-scheduled-tasks)を再度開きます。どちらのコントロールも API トリガーのパネル内のトークンの横にあり、すぐに反映されます。

* **API アクセスをオフにする**: **Regenerate** の横にあるゴミ箱アイコン、**Delete token** をクリックします。これにより API トリガーが削除されます
* **トークンをローテーションする**: **Regenerate** をクリックします。以前のトークンは使用できなくなり、**Token generated** ダイアログに新しいトークンが 1 回だけ表示されます

#### スケジュールタスクをトリガーする

`Authorization` ヘッダーにベアラートークンを指定して、`/fire` エンドポイントに POST リクエストを送信します。リクエスト本文では、アラート本文や失敗したログなど、実行固有のコンテキストのためのオプションの `text` フィールドを指定でき、保存されたプロンプトとともにタスクに渡されます。値は自由形式のテキストで、解析されません。JSON などの構造化ペイロードを送信した場合、タスクはそれをリテラル文字列として受け取ります。

`text` の値は、そのままのメッセージとしてルーティンに届くわけではありません。`<routine-fire-payload>` ブロックで囲まれて届き、このブロックはそれを信頼できないデータとしてラベル付けし、ルーティン自身のプロンプトが指示しない限り、その中の指示に従わないよう Claude に伝えます。Web UI の **Run now** で指定したテキストにも、同じラッピングが適用されます。

つまり、ルーティンの保存されたプロンプトで、fire テキストに基づいて行動することを明示的に許可する必要があります。たとえば「routine-fire-payload ブロックで説明されているアラートを調査する」のように、ペイロードを明示的に参照するプロンプトを書いてください。そうしないと、ルーティンはそのテキストを単なるコンテキストとして扱います。ベアラートークンを持っている人は誰でも `text` を送信できるため、このラッパーにより、漏洩したトークンからの fire テキストは、ルーティンへの直接の指示ではなく、信頼できないデータとしてラベル付けされて届きます。

以下の例は、シェルからスケジュールタスクをトリガーします。示されているタスク ID とトークンはプレースホルダーです。[API トリガーを追加した](#add-an-api-trigger)ときにコピーした URL とトークンに置き換えてください。置き換えないと、リクエストは `401` 認証エラーで失敗します。

```bash theme={null}
curl -X POST https://api.anthropic.com/v1/claude_code/routines/trig_01ABCDEFGHJKLMNOPQRSTUVW/fire \
  -H "Authorization: Bearer sk-ant-oat01-xxxxx" \
  -H "anthropic-beta: experimental-cc-routine-2026-04-01" \
  -H "anthropic-version: 2023-06-01" \
  -H "Content-Type: application/json" \
  -d '{"text": "Sentry alert SEN-4521 fired in prod. Stack trace attached."}'
```

リクエストが成功すると、新しいセッション ID と URL を含む JSON 本文が返されます。

```json theme={null}
{
  "type": "routine_fire",
  "claude_code_session_id": "session_01HJKLMNOPQRSTUVWXYZ",
  "claude_code_session_url": "https://claude.ai/code/session_01HJKLMNOPQRSTUVWXYZ"
}
```

ブラウザでセッション URL を開くと、実行をリアルタイムで確認したり、変更をレビューしたり、会話を手動で続けたりできます。

> [!WARNING]
>
> `/fire` エンドポイントは `experimental-cc-routine-2026-04-01` ベータヘッダーで提供されています。リクエストとレスポンスの形式、レート制限、トークンの仕様は、機能がリサーチプレビュー段階にある間に変更される可能性があります。破壊的変更は日付付きの新しいベータヘッダーバージョンで提供され、直前の 2 つのヘッダーバージョンは引き続き動作するため、呼び出し元には移行する時間があります。

#### API リファレンス

すべてのエラーレスポンス、検証ルール、フィールド制限を含む完全な API リファレンスについては、Claude Platform ドキュメントの [API 経由でルーティンをトリガーする](https://platform.claude.com/docs/en/api/claude-code/routines-fire)を参照してください。

`/fire` エンドポイントは claude.ai ユーザーのみが利用でき、Claude Platform API サーフェスの一部ではありません。

### GitHub トリガーを追加する

GitHub トリガーは、接続されたリポジトリで一致するイベントが発生したときに、新しいセッションを自動的に開始します。Claude Code はイベント間でセッションを再利用しないため、2 つの PR 更新からは 2 つの独立したセッションが生成されます。

> [!NOTE]
>
> GitHub webhook イベントには、タスクごとおよびアカウントごとの 1 時間あたりの上限があります。上限を超えたイベントは、ウィンドウがリセットされるまで破棄されます。

どのサーフェスからトリガーを設定する場合でも、サブスクライブするリポジトリに Claude GitHub App がインストールされている必要があります。

* GitHub トリガーは Web UI から設定します。アプリがない場合は、インストールするよう求められます。Web で設定するには、以下の手順に従ってください。
* CLI からは、まず [GitHub App ページ](https://github.com/apps/claude)からアプリをインストールし、次に既存のスケジュールタスクに GitHub トリガーを追加するよう Claude に依頼します。たとえば `/schedule add a GitHub trigger to my nightly review for pull requests opened in acme/webapp` のようにします。CLI からの設定には Claude Code v2.1.225 以降が必要です。Claude はトリガーを追加すると、そのトリガーが起動するタスクへのリンクを返信します。

**1. タスクを編集用に開く**

[claude.ai/code/routines](https://claude.ai/code/routines) にアクセスし、スケジュールタスクをクリックしてから、名前の横にあるメニューを開いて **Edit** を選択します。**Edit scheduled task** ダイアログが開きます。

**2. GitHub イベントトリガーを追加する**

**Trigger** 行で **+** をクリックし、開いたメニューから **GitHub event** を選択します。

> [!NOTE]
>
> CLI で `/web-setup` を実行すると、クローン用のリポジトリアクセスが付与されますが、Claude GitHub App はインストールされず、webhook 配信も有効になりません。

**3. トリガーを設定する**

必要に応じてリポジトリを変更し、[サポートされているイベント](#supported-events)のリストからイベントを選択し、必要に応じてフィルタを追加します。その後、ダイアログ下部の **Save changes** をクリックしてトリガーを適用します。

#### サポートされているイベント

次のいずれかのカテゴリからイベントを選択します。各カテゴリ内で、`pull_request.opened` などの特定のアクションを選択するか、カテゴリ内のすべてのアクションに反応させることができます。

| イベント | トリガーのタイミング |
| :- | :- |
| プルリクエスト | PR がオープン、クローズ、割り当て、ラベル付け、同期、またはその他の方法で更新されたとき |
| リリース | リリースが作成、公開、編集、または削除されたとき |
| Issue | Issue がオープン、編集、クローズ、再オープン、ラベル付け、割り当て、またはその他の方法で更新されたとき |

#### プルリクエストをフィルタリングする

フィルタを使用して、新しいセッションを開始するプルリクエストを絞り込みます。スケジュールタスクがトリガーされるには、すべてのフィルタ条件が一致する必要があります。利用可能なフィルタフィールドは次のとおりです。

| フィルタ | マッチ |
| :- | :- |
| 作成者 | PR 作成者の GitHub ユーザー名 |
| タイトル | PR タイトルテキスト |
| 本文 | PR 説明テキスト |
| ベースブランチ | PR がターゲットするブランチ |
| ヘッドブランチ | PR が由来するブランチ |
| ラベル | PR に適用されたラベル |
| ドラフト | PR がドラフト状態かどうか |
| マージ済み | PR がマージされたかどうか |

各フィルタは、フィールドと演算子を組み合わせます。演算子は、等しい、含む、で始まる、いずれかである、いずれでもない、正規表現に一致する、のいずれかです。

`matches regex` 演算子は、フィールド値の一部ではなく、フィールド値全体をテストします。`hotfix` を含むタイトルに一致させるには、`.*hotfix.*` と記述します。前後の `.*` がない場合、フィルタは前後に何もない、正確に `hotfix` であるタイトルにのみ一致します。正規表現構文を使わずにリテラルの部分文字列で一致させるには、代わりに `contains` 演算子を使用してください。

フィルタの組み合わせの例をいくつか示します。

* **認証モジュールのレビュー**: ベースブランチが `main`、ヘッドブランチに `auth-provider` を含む。認証に関わる PR を専門のレビュアーに送ります。
* **レビュー準備完了のみ**: ドラフトが `false`。ドラフトをスキップし、PR がレビュー可能になったときにのみタスクが実行されるようにします。
* **ラベルによるバックポート**: ラベルに `needs-backport` を含む。メンテナーが PR にタグを付けたときにのみ、別ブランチへの移植タスクをトリガーします。

## スケジュールタスクを管理する

リスト内のスケジュールタスクをクリックすると、その詳細ページが開きます。詳細ページには、タスクのリポジトリ、コネクタ、プロンプト、スケジュール、API トークン、GitHub トリガー、過去の実行のリストが表示されます。

### 実行を表示して操作する

任意の実行をクリックして、フルセッションとして開きます。そこから Claude が何をしたかを確認し、変更をレビューし、プルリクエストを作成するか、会話を続けることができます。各実行セッションは他のセッションと同じように機能します。セッションタイトルの横のドロップダウンメニューを使用して、名前変更、アーカイブ、または削除を行います。

タスクの詳細ページの **History** では、完了した各実行の行の末尾に、実行が失敗した場合は **Error**、キャンセルされた場合は **Cancelled** と表示され、成功した場合はどちらも表示されません。**Status** フィルターでは、同じ 3 つの結果を **Failed**、**Cancelled**、**Succeeded** と呼びます。これらの結果はセッションがどのように終了したかを示すものであり、プロンプトに記述された作業を Claude が完了したかどうかを示すものではありません。何が起こったかを確認するには、実行を開いてトランスクリプトを読んでください。

* **Succeeded**: Claude Code が失敗を報告することなくセッションが終了しました。ブロックされたネットワークリクエスト、不足しているコネクタツール、Claude が完了できなかった作業は、行ではなくトランスクリプトに表示されます
* **Failed**: セッションが正常に終了しませんでした。たとえば、予期せず停止した、エラーで終了した、または実行の開始前にアーカイブされた場合です
* **Cancelled**: 実行は失敗しておらず、そのセッションがアーカイブされました。成功した実行のセッションをアーカイブすると、その実行は **Cancelled** に変わります。タスク側で変更する必要はありません

**History** に警告が表示される場合は、[「The last run」の警告](#the-last-run-didnt-start)を参照してください。

### スケジュールタスクを編集して制御する

詳細ページから、以下を実行できます。

* **Run now** をクリックして、次のスケジュール時刻を待たずにすぐに実行を開始します。
* ページ上部のオン/オフスイッチを使用して、スケジュールを一時停止または再開します。一時停止したタスクは設定を保持しますが、再びオンにするまで実行されません。
* タスク名の横にあるメニューを開いて **Edit** を選択し、名前、プロンプト、リポジトリ、環境、コネクタ、またはタスクのいずれかのトリガーを変更します。**Edit scheduled task** ダイアログが、[作成ダイアログ](#create-from-the-web)と同じレイアウトで開きます。トリガーを追加するには、**Trigger** 行の **+** をクリックします。編集を適用するには **Save changes** をクリックします。API トークンの操作は **Save changes** なしですぐに反映されます。
* 同じメニューを開いて **Delete** を選択し、タスクを削除します。

### CLI からスケジュールタスクを管理する

`/schedule list` を実行するとスケジュールタスクを表示でき、`/schedule update` で変更、`/schedule run` ですぐに開始できます。

スケジュールタスクの実行履歴について質問することもできます。たとえば `/schedule why did my nightly review do nothing this morning?` のようにします。Claude はタスクの最近の実行をステータスと[各実行を Web で開く](#view-and-interact-with-runs)ためのリンクとともに一覧表示します。また、実行のログを読み、ツールエラー、権限拒否、最終結果を含めて何が起こったかを説明します。Claude Code v2.1.227 以降が必要です。

### リポジトリとブランチの権限

スケジュールタスクには、リポジトリをクローンするための GitHub アクセスが必要です。CLI で `/schedule` を使用してスケジュールタスクを作成すると、Claude は実行元のリポジトリに対してアカウントが GitHub アクセスを持っているかどうかを確認します。持っていない場合、Claude はアクセスを付与する方法を示すセットアップノートを追加します。

> [!NOTE]
>
> アクセスを付与する 2 つの方法については、[GitHub 認証オプション](https://code.claude.com/docs/ja/claude-code-on-the-web.md#github-authentication-options)を参照してください。Team プランと Enterprise プランでは、各方法を使用する前に Claude 組織の [Owner](https://code.claude.com/docs/ja/server-managed-settings.md#access-control) がその方法をオンにする必要があります。[GitHub を接続する](https://code.claude.com/docs/ja/web-quickstart.md#connect-github)を参照してください。

実行予定時に GitHub 接続が存在しないか期限切れの場合、スケジュールタスクは再接続されるまで、最大 72 時間、実行をスキップします。その期間内に GitHub を再接続すると、タスクは自動的に再開されます。接続がないまま 72 時間が経過するとタスクはオフになり、GitHub を再接続した後に再度オンにする必要があります。

追加した各リポジトリは、実行のたびにクローンされます。プロンプトで別途指定しない限り、Claude はリポジトリのデフォルトブランチから開始します。[GitHub プルリクエストイベント](#add-a-github-trigger)が実行をトリガーし、そのプルリクエストのリポジトリがタスクの最初のリポジトリである場合、そのリポジトリは代わりにプルリクエストの head コミットから開始します。

Claude は、プロンプトで別のブランチへのプッシュを指示しない限り、`claude/` で始まるブランチに作業をプッシュします。実行がプッシュできるブランチを制御するには、GitHub のブランチ保護ルールまたはルールセットを使用します。Anthropic 管理のインフラストラクチャ上の実行、および [Anthropic の git プロキシ](https://code.claude.com/docs/ja/self-hosted-environments-deploy.md#use-the-anthropic-git-proxy)を通じてプッシュするセルフホスト実行の場合、GitHub はこれらのルールを接続した GitHub アクセスに適用するため、そのアクセスがバイパスできるルールは実行のプッシュをブロックしません。デプロイが提供する git 認証情報でプッシュするセルフホスト実行は、代わりにその認証情報に対してチェックされます。[git を設定する](https://code.claude.com/docs/ja/self-hosted-environments-deploy.md#configure-git)を参照してください。

### コネクタ

スケジュールタスクは、接続済みの MCP コネクタを使用して、各実行中に外部サービスの読み取りと書き込みを行えます。たとえば、サポートリクエストをトリアージするタスクは、Slack チャンネルから読み取り、Linear に課題を作成することがあります。

コネクタは、アカウント上の [claude.ai インテグレーション](https://code.claude.com/docs/ja/mcp.md#use-mcp-servers-from-claude-ai)です。CLI で `claude mcp add` を使用してローカルに追加した MCP サーバーは claude.ai アカウントではなくマシンに保存されるため、コネクタリストには表示されません。これらのサーバーのいずれかをスケジュールタスクで使用するには、次のいずれかを行います。

* **コネクタとして**: [claude.ai/customize/connectors](https://claude.ai/customize/connectors) でコネクタとして追加します
* **リポジトリ内で**: リポジトリが 1 つのスケジュールタスクの場合は、代わりにコミットされた [`.mcp.json`](https://code.claude.com/docs/ja/mcp#project-scope) でサーバーを宣言することもできます。ただし、タスクが[プロジェクト](https://code.claude.com/docs/ja/claude-projects.md#what-threads-pick-up-from-your-repositories)内のスレッドとして実行される場合は除きます。その場合は、サーバーをコネクタとして追加してください。

スケジュールタスクを作成すると、現在接続されているすべてのコネクタがデフォルトで含まれます。実行中に Claude がアクセスできるツールを制限するため、不要なものは削除してください。タスクの作成ダイアログまたは編集ダイアログから直接コネクタを追加することもできます。

そのダイアログ以外でコネクタを管理または追加するには、[claude.ai/customize/connectors](https://claude.ai/customize/connectors) にアクセスするか、CLI で `/schedule update` を使用します。

### 実行中の権限プロンプト

> [!NOTE]
>
> 組織のセルフホスト環境で実行されるタスクについては、[権限とツールの承認](https://code.claude.com/docs/ja/self-hosted-environments-configuration.md#permissions-and-tool-approval)を参照してください。

実行が Anthropic のクラウド上で新しいセッションを開始すると、auto モードが利用できない場合を除き、そのセッションは [auto モード](https://code.claude.com/docs/ja/permission-modes.md#eliminate-prompts-with-auto-mode)で開始されます。auto モードでは、本来であればユーザーの承認を待つことになるアクションを、分類器モデルが許可またはブロックします。

次のような場合には、実行は引き続き停止して応答を待ちます。

* **auto モードでも確認を求めるアクション**: たとえば、[ask ルール](https://code.claude.com/docs/ja/permissions.md#manage-permissions)に一致するアクションです。[auto モードがアクションを評価する方法](https://code.claude.com/docs/ja/permission-modes.md#how-auto-mode-evaluates-actions)を参照してください
* **繰り返しのブロック**: 1 回のブロックで実行が終了することはありません。ブロックが auto モードの[繰り返しブロックのしきい値](https://code.claude.com/docs/ja/permission-modes.md#repeated-block-thresholds)に達すると、実行のセッションに権限プロンプトが表示され、誰かが応答するまで待機します

組織が auto モードをオフにしている場合や、タスクのモデルが auto モードをサポートしていない場合など、auto モードが利用できない場合、実行は起動時の権限モードを維持します。待機中のプロンプトに応答するには、タスクの[詳細ページ](#view-and-interact-with-runs)から実行を開きます。

[プロジェクト](https://code.claude.com/docs/ja/claude-projects.md)では、実行が新しいセッションを開始する代わりにスレッドを継続することがあります。その実行は、その時点でスレッドが使用している権限モードをそのまま維持します。そのスレッドは作成時に、auto モードが利用できない場合を除き、auto モードで開始されています。そのスレッドで待機中のプロンプトに応答するには、[承認待ちのスレッドのブロックを解除する](https://code.claude.com/docs/ja/claude-projects.md#unblock-a-thread-waiting-on-approval)を参照してください。

### 実行が確認なしでアーティファクトを公開する場合

[auto モード](#permission-prompts-during-a-run)での実行中、分類器が公開を許可すると、Claude は確認を求めずに[アーティファクト](https://code.claude.com/docs/ja/artifacts.md)を公開します。たとえば公開が [ask ルール](https://code.claude.com/docs/ja/permissions.md#manage-permissions)に一致する場合は、引き続き事前に確認が求められます。新しいアーティファクトは、[共有する](https://code.claude.com/docs/ja/artifacts.md#share-an-artifact)まではユーザー本人にのみ表示されます。以下の [Accept edits のルール](#artifacts-in-accept-edits-mode)は auto モードには適用されません。

スケジュールタスクの役割がページを最新の状態に保つことである場合は、すでに公開済みのアーティファクトを渡してください。

#### Accept edits モードでのアーティファクト

スケジュールタスクのスケジュールまたは **Run now** によって実行が開始された場合、Claude は確認を求めずに新しい[アーティファクト](https://code.claude.com/docs/ja/artifacts.md)を公開できます。新しいアーティファクトは、[共有する](https://code.claude.com/docs/ja/artifacts.md#share-an-artifact)まではユーザー本人にのみ表示されます。公開時にページのランタイム機能（[コネクタ呼び出し](https://code.claude.com/docs/ja/artifacts.md#pull-live-data-with-mcp-connectors)や[ファイルのダウンロード](https://code.claude.com/docs/ja/artifacts.md#offer-a-file-download)など）を宣言する場合、Claude は事前に確認を求めます。

これらの実行では、Claude は以下のすべてが満たされる場合にのみ、確認を求めずに既存のアーティファクトを再公開します。

* アーティファクトを編集でき、かつ自分の組織に属している
* 公開内容にページ以外のもの（サポートファイルなど）が含まれる場合、そのアーティファクトを所有している
* アーティファクトが一般公開で共有されていない
* アーティファクトが特定のユーザーまたは組織と共有されている場合、その閲覧者に新しいバージョンが自動的に表示されない
* 公開によって新しいバージョンを強制的に上書きしない
* 公開でページのランタイム機能を宣言しない
* 既存のページに、ページの範囲を超える権限付与（[コネクタ呼び出し](https://code.claude.com/docs/ja/artifacts.md#pull-live-data-with-mcp-connectors)など）がない

API トリガーや GitHub トリガーによって開始された実行を含め、それ以外のすべての場合、Claude は事前に確認を求めます。

### 環境とネットワークアクセス

各スケジュールタスクは、ネットワークアクセス、環境変数、セットアップスクリプトを制御する[クラウド環境](https://code.claude.com/docs/ja/cloud-environments.md)を使用します。タスクは、すべての実行でその環境のネットワークポリシーを継承します。

**Default** 環境は **Trusted** ネットワークアクセスを使用します。これにより、セッションのネットワークを通じて[デフォルト許可リスト](https://code.claude.com/docs/ja/cloud-environments.md#default-allowed-domains)のみが許可されます。そのパス上で許可リスト外のホストへのリクエストは `403` と `x-deny-reason: host_not_allowed` で失敗します。MCP コネクタのトラフィックはそのパスではなく Anthropic のサーバーを通じてルーティングされるため、タスクに追加するコネクタは **Allowed domains** にホストを追加しなくても機能します。不要なコネクタは[コネクタ](#connectors)で削除してください。

独自の環境のいずれかで追加のドメインを許可するには、以下の手順に従います。[組織共有環境](https://code.claude.com/docs/ja/cloud-environments.md#organization-shared-environments)はここでは読み取り専用で開くため、その場合は Owner が[管理設定](https://claude.ai/admin-settings)の **Cloud environments** ページからネットワークアクセスを変更します。

**1. タスクを編集用に開く**

[claude.ai/code/routines](https://claude.ai/code/routines) にアクセスし、スケジュールタスクをクリックしてから、名前の横にあるメニューを開いて **Edit** を選択します。**Edit scheduled task** ダイアログが開きます。

**2. 環境セレクタを開く**

**Advanced settings > General > Cloud environment** に移動します。**Advanced settings** が折りたたまれている場合は、先に展開してください。**Default** など、環境の名前が表示されているクラウドアイコンをクリックします。

**3. 環境設定を開く**

リスト内の環境にマウスを置き、右側に表示される設定アイコンをクリックします。

**4. ネットワークアクセスレベルを変更する**

**Edit cloud environment** ダイアログで、**Network access** を **Custom** に変更し、**Allowed domains** にドメインを入力します。**Also include default list of common package managers** をチェックすると、カスタムドメインとともに[デフォルト許可リスト](https://code.claude.com/docs/ja/cloud-environments.md#default-allowed-domains)も維持されます。制限のないアクセスにするには、代わりに **Full** を選択します。

**5. 保存**

**Edit cloud environment** ダイアログで **Save changes** をクリックしてから、その背後にある **Edit scheduled task** ダイアログを閉じます。新しいポリシーは次の実行から適用されます。

アクセスレベルとデフォルト許可リストの詳細については、[ネットワークアクセス](https://code.claude.com/docs/ja/cloud-environments.md#network-access)を参照してください。

## 使用量と制限

スケジュールタスクは、対話型セッションと同じようにサブスクリプションの使用量を消費します。現在の消費量は [claude.ai/settings/usage](https://claude.ai/settings/usage) で確認してください。

サブスクリプションの使用量とは別に、実行を開始する各方法には 1 時間あたりの制限があります。

| アクション | 制限 | カウント対象 | 制限超過時 |
| :- | :- | :- | :- |
| スケジュール実行（1 回限りの実行を含む） | 1 時間あたり 100 回 | アカウント | 制限がリセットされるまで実行は待機します |
| **Run now**、API の fire、1 回限りのタスクの再実行設定 | 1 時間あたり 30 回 | 各スケジュールタスク（3 つすべてで 1 つのカウントを共有） | 制限がリセットされるまでアクションは失敗します |
| **Run now** と 1 回限りのタスクの再実行設定 | 1 時間あたり 100 回 | アカウント | 同上 |
| API の fire | 1 時間あたり 100 回 | アカウント（**Run now** とは別にカウント） | 同上 |
| GitHub イベント | [GitHub トリガーを追加する](#add-a-github-trigger)を参照 | | |

これらの 1 時間あたりの制限には超過利用がありません。

スケジュールタスクがサブスクリプションの使用制限に達した場合、使用クレジットを有効にしている組織は、従量制の超過利用でスケジュールタスクの実行を続けられます。使用クレジットがない場合、使用量のウィンドウがリセットされるまで追加の実行は拒否されます。使用クレジットは [claude.ai/settings/usage](https://claude.ai/settings/usage) で有効にしてください。Team プランと Enterprise プランでは、管理者が [claude.ai/admin-settings/usage](https://claude.ai/admin-settings/usage) で組織の使用クレジットを有効にします。

サブスクリプションが一時停止されている間、スケジュールタスクは保留状態になり、実行されません。サブスクリプションが再びアクティブになったら、タスクを再度オンにしてください。

## ルーティンという名前が残っている場所

スケジュールタスクは以前ルーティンと呼ばれており、以下の場所では以前の名前が残っています。いずれも同じ機能を指します。

* **アプリ**: 一部のアカウントでは、サイドバーの項目とページタイトルが **Routines**、ボタンが **New routine** と表示され、その他のラベルでも routine と表記されています。そこからタスクを作成するには、[フルページフォーム](#full-page-form)を参照してください。
* **Web アドレス**: `claude.ai/code/routines`
* **CLI**: `/schedule` のエイリアス `/routines`、コマンドの説明、タスクのセットアップ中の Claude の返答
* **API**: `/fire` エンドポイントのパス、そのベータヘッダー、レスポンスの `type`、`<routine-fire-payload>` タグ、および [API 経由でルーティンをトリガーする](https://platform.claude.com/docs/en/api/claude-code/routines-fire)リファレンスページ
* **組織設定**: **Scheduled tasks (Was Routines)** トグル

## トラブルシューティング

### `/schedule` returns "Unknown command"

CLI は `/schedule` の要件の 1 つが満たされていない場合、このコマンドを非表示にします。入力中、コマンドメニューには `No commands match "/schedule"` と表示されます。送信すると `Unknown command: /schedule` が返されます。ただし、以下のケースのうち異なる応答を示すものは除きます。

原因は通常、以下のいずれかです。

* Console API キー、[Anthropic プロフィールまたはフェデレーション認証情報](https://code.claude.com/docs/ja/authentication.md#anthropic-profiles-and-federation-credentials)、または Amazon Bedrock、Google Cloud の Agent Platform、Microsoft Foundry などのクラウドプロバイダーで認証されている。`/schedule` には claude.ai サブスクリプションでのログインが必要です。Console API キーまたはプロフィールを使用していて、フィーチャーフラグの取得が有効な場合、`/schedule` を送信すると代わりに `/schedule is available with Claude for Enterprise — ask your admin about migrating from API-key access` と表示されます。クラウドプロバイダーでログインしている場合は、引き続き `Unknown command: /schedule` が表示されます。シェルで `ANTHROPIC_API_KEY` または `ANTHROPIC_AUTH_TOKEN` が設定されている場合、または `settings.json` で `apiKeyHelper` が設定されている場合は、これらが claude.ai ログインより優先されるため、まず削除してください。プロフィールまたはフェデレーション認証情報も優先されるため、それもオフにしてください
* 完全にサインアウトしており、API キーやその他の認証情報がない。フィーチャーフラグの取得が有効な場合、`/schedule` を送信すると `/schedule requires a claude.ai subscription. Run /login to sign in with your claude.ai account.` と表示されます。v2.1.268 より前は、サインアウトしたセッションでは Console API キーの場合と同じ Claude for Enterprise のメッセージが表示されていました
* クラウドセッション内にいる。この場合、`/schedule` を送信すると、その環境ではコマンドを使用できないという応答が返されます。代わりに [Web UI](https://claude.ai/code/routines) からスケジュールタスクを管理してください
* 組織のポリシーが、スケジュールタスクに必要な[クラウドセッション](https://code.claude.com/docs/ja/claude-code-on-the-web.md)を無効にしている。この場合、`/schedule` を送信すると代わりに [`Cloud sessions are disabled by your organization's policy`](https://code.claude.com/docs/ja/errors#cloud-sessions-are-disabled-by-your-organizations-policy) と応答されます。v2.1.268 より前は、`Unknown command: /schedule` が返されていました
* Owner が Team または Enterprise 組織の[スケジュールタスクをオフにした](#routines-are-disabled-by-your-organizations-policy)。v2.1.227 より前は、このケースでもコマンドが表示されており、Claude がタスクを作成または実行しようとしたときに claude.ai がそれを拒否していました
* Enterprise 組織が[カスタムロール](https://support.claude.com/en/articles/13930452)でアクセスを管理しており、どのロールにも **Remote sessions** のスケジュールタスク権限が含まれていない。いずれかのロールにこの権限を追加するよう Owner に依頼してください

原因が CLI のサインインやクラウドセッション内にいることである場合でも、[claude.ai/code/routines](https://claude.ai/code/routines) でスケジュールタスクを作成・管理できます。そのためには Pro、Max、Team、または Enterprise アカウントが必要です。組織でスケジュールタスクまたはクラウドセッションがオフになっている場合や、ロールにそれらが含まれていない場合は、Web でも作成できません。

### "Routines are disabled by your organization's policy"

Team または Enterprise 組織の Owner が、[**Organization settings > Capabilities > Remote sessions**](https://claude.ai/admin-settings/capabilities) の **Scheduled tasks (Was Routines)** トグルをオフにしている可能性があります。Claude Code v2.1.227 以降では、同じトグルで CLI の `/schedule` も非表示になります。これはサーバー側の組織設定であるため、ローカルの設定から上書きすることはできません。組織のスケジュールタスクを再びオンにするよう Owner に依頼してください。

### "The last run" の警告

**History** の下にある警告が「The last run」で始まる場合は、最初の列でその警告を探し、その行に記載された対処を行ってください。警告は、以降の実行が開始されると消えます。

| 警告 | 対処方法 |
| :- | :- |
| "The last run didn't start because your organization had reached its limit on cloud sessions running at once." | タスクを変更する必要はありません。後で **Run now** をクリックするか、次回の実行を待ってください |
| "The last run didn't start because its cloud environment couldn't be found or used." | タスクの詳細ページで、名前の横にあるメニューを開き、**Edit** を選択して、[クラウド環境セレクター](#environments-and-network-access)を探します。**Unavailable environment** と表示されている場合、その環境はアーカイブされたか、アカウントで利用できなくなっているため、そこで別の環境を選択して変更を保存してください。それ以外の場合は、詳細ページの **Run now** で再試行するか、セレクターで別の環境を選択して変更を保存してください |
| "The last run was blocked because it couldn't access something it needs, or your organization's policy doesn't allow it." | [GitHub アクセス](#repositories-and-branch-permissions)がタスクのリポジトリを対象に含んでいることを確認してください。含まれている場合は、Claude 組織の [Owner](https://code.claude.com/docs/ja/server-managed-settings.md#access-control) に、ポリシーがタスクをブロックしていないか確認してください |
| "The last run didn't start because of a problem that's usually temporary." | **Run now** をクリックして再試行するか、次回の実行を待ってください |
| "The last run didn't start because its repository or branch wasn't available." | タスク内の各リポジトリに[実行の開始元となるブランチ](#repositories-and-branch-permissions)が存在することを GitHub で確認してください。また、[GitHub アクセス](#repositories-and-branch-permissions)が各リポジトリを対象に含んでいることを確認し、接続の有効期限が切れている場合は GitHub に再接続してください |
| "The last run didn't start because some of its settings weren't accepted." | タスクの詳細ページで、名前の横にあるメニューを開き、**Edit** を選択します。ダイアログにはどの設定項目が受け入れられなかったかは示されないため、タスクの名前、プロンプト、モデル、リポジトリ、環境、コネクタ、トリガーを含め、各設定項目をそこで確認してください |
| "The last run stopped because a usage limit was reached." | 使用制限に達した後、タスクの実行を再開できるタイミングについては、[使用量と制限](#usage-and-limits)を参照してください |
| "The last run failed." | **Run now** をクリックして再試行するか、次回の実行を待ってください。失敗した実行には開けるセッションがありません |

## 関連リソース

* [`/loop` とセッション内スケジューリング](https://code.claude.com/docs/ja/scheduled-tasks): 開いている CLI セッション内でローカルタスクをスケジュール
* [Desktop スケジュールタスク](https://code.claude.com/docs/ja/desktop-scheduled-tasks.md): マシン上で実行され、ローカルファイルにアクセスできるローカルのスケジュールタスク
* [クラウド環境](https://code.claude.com/docs/ja/cloud-environments.md): クラウドセッションのネットワークアクセス、環境変数、セットアップスクリプトを設定
* [Projects](https://code.claude.com/docs/ja/claude-projects.md): Claude が複数のクラウドセッションにわたって並行して調整する継続的な作業。プロジェクトから作成されたスケジュールタスクは、その **Scheduled tasks** タブに表示されます
* [MCP コネクタ](https://code.claude.com/docs/ja/mcp.md): Slack、Linear、Google Drive などの外部サービスを接続
* [GitHub Actions](https://code.claude.com/docs/ja/github-actions.md): リポジトリイベントに応じて CI パイプラインで Claude を実行
