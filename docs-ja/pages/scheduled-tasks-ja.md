> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# スケジュールに従ってプロンプトを実行する

> /loop と cron スケジューリングツールを使用して、Claude Code セッション内でプロンプトを繰り返し実行したり、ステータスをポーリングしたり、1 回限りのリマインダーを設定したりします。

セッションスコープのスケジュールタスクを使用すると、Claude は Claude Code セッション内で一定の間隔でプロンプトを自動的に再実行できます。デプロイをポーリングしたり、PR を監視したり、長時間実行されるビルドをチェックバックしたり、後でセッション内で何かを実行するようにリマインダーを設定したりするために使用します。

> [!NOTE]
>
> 次のケースは他のページで説明しています。
>
> * **ポーリングする代わりにイベントが発生したときに反応する**: [チャネル](https://code.claude.com/docs/ja/channels.md) を参照してください。CI はセッションに直接失敗をプッシュできます。
> * **一定の間隔ではなく、条件を満たすまでターンごとにセッションを動作させ続ける**: [`/goal`](https://code.claude.com/docs/ja/goal) を参照してください。

タスクはセッションスコープです。`--resume` または `--continue` で再開すると、Claude Code は [有効期限切れ](#seven-day-expiry) になっていないタスクを復元します。ただし、[制限事項](#limitations) に記載されているタスクは除きます。セッションとは独立して存続するスケジューリングについては、[クラウドスケジュールタスク](https://code.claude.com/docs/ja/routines.md) を作成するか、[Desktop スケジュールタスク](https://code.claude.com/docs/ja/desktop-scheduled-tasks.md) をセットアップするか、[GitHub Actions](https://code.claude.com/docs/ja/github-actions.md) を使用してください。

## スケジューリングオプションを比較する

Claude Code は、定期的または 1 回限りの作業をスケジュールするための 3 つの方法を提供します。

| | [Cloud](https://code.claude.com/docs/ja/routines.md) | [Desktop](https://code.claude.com/docs/ja/desktop-scheduled-tasks.md) | [`/loop`](https://code.claude.com/docs/ja/scheduled-tasks) |
| :- | :- | :- | :- |
| 実行場所 | Cloud、デフォルトでは Anthropic 管理 | お客様のマシン | お客様のマシン |
| マシンの起動が必要 | いいえ | はい | はい |
| オープンセッションが必要 | いいえ | いいえ | はい |
| 再起動後も永続 | はい | はい | `--resume` で復元、[例外](https://code.claude.com/docs/ja/scheduled-tasks.md#limitations)あり |
| ローカルファイルへのアクセス | いいえ（新規クローン） | はい | はい |
| MCP サーバー | タスクごとに設定されたコネクタ | [設定ファイル](https://code.claude.com/docs/ja/mcp.md)とコネクタ | セッションから継承 |
| 権限プロンプト | デフォルトで [auto モード](https://code.claude.com/docs/ja/routines.md#permission-prompts-during-a-run) | タスクごとに設定可能 | セッションから継承 |
| カスタマイズ可能なスケジュール | はい | はい | はい |
| 最小間隔 | 1 時間 | Claude が設定する場合は 1 分、[フォームでは 1 時間](https://code.claude.com/docs/ja/desktop-scheduled-tasks.md#schedule-options) | 1 分 |

> [!TIP]
>
> マシンなしで確実に実行する必要がある作業には**クラウドタスク**を使用します。ローカルファイルとツールへのアクセスが必要な場合は**デスクトップタスク**を使用します。セッション中の迅速なポーリングには\*\*`/loop`\*\*を使用します。

## /loop で定期的にプロンプトを実行する

`/loop` [バンドルスキル](https://code.claude.com/docs/ja/commands.md) は、セッションが開いている間、プロンプトを繰り返し実行する最速の方法です。間隔とプロンプトの両方はオプションであり、提供する内容によってループの動作が決まります。

| 提供する内容 | 例 | 動作 |
| :- | :- | :- |
| 間隔とプロンプト | `/loop 5m check the deploy` | プロンプトは[固定スケジュール](#run-on-a-fixed-interval)で実行されます |
| プロンプトのみ | `/loop check the deploy` | プロンプトは各反復で[Claude が選択した間隔](#let-claude-choose-the-interval)で実行されます |
| 間隔のみ、または何もなし | `/loop` | [組み込みメンテナンスプロンプト](#run-the-built-in-maintenance-prompt)が実行されるか、存在する場合は `loop.md` が実行されます |

スキルをプロンプトとして渡すこともできます。例えば `/loop 20m /review-pr 1234` は、各反復でそのスキルを再実行します。スケジュール済みの実行は Claude が[独自に呼び出すことを許可されているスキル](https://code.claude.com/docs/ja/skills.md#control-who-invokes-a-skill)のみを実行します。以下は Claude にプレーンテキストとして到達し、実行されません。

* `/permissions`、`/model`、`/clear` などの組み込みコマンド
* [`disable-model-invocation: true`](https://code.claude.com/docs/ja/skills#frontmatter-reference) とマークされたスキル（バンドルされた `/verify` スキルを含む）
* [`skillOverrides`](https://code.claude.com/docs/ja/skills#override-skill-visibility-from-settings) 設定または `Skill` [拒否ルール](https://code.claude.com/docs/ja/skills.md#restrict-claude%E2%80%99s-skill-access)によって Claude から保留されたスキル
* [MCP プロンプト](https://code.claude.com/docs/ja/mcp.md#use-mcp-prompts-as-commands)（`/mcp__github__list_prs` など）

### 固定間隔で実行する

間隔を指定すると、Claude はそれを cron 式に変換し、ジョブをスケジュールし、頻度とジョブ ID を確認します。

```text theme={null}
/loop 5m check if the deployment finished and tell me what happened
```

間隔は `30m` のような裸のトークンとしてプロンプトの前に配置することも、`every 2 hours` のような句としてプロンプトの後に配置することもできます。サポートされている単位は、秒の場合は `s`、分の場合は `m`、時間の場合は `h`、日の場合は `d` です。

秒は cron が 1 分の粒度を持つため、最も近い分に切り上げられます。`7m` や `90m` など、クリーンな cron ステップにマップされない間隔は、最も近い間隔に丸められ、Claude が選択したものを通知します。

### Claude に間隔を選択させる

間隔を省略すると、Claude は固定 cron スケジュールで実行する代わりに、動的に間隔を選択します。各反復の後、観察した内容に基づいて 1 分から 1 時間の間の遅延を選択します。ビルドが完了している間または PR がアクティブな間は短い待機時間、何も保留中でない場合は長い待機時間です。選択された遅延とその理由は、各反復の終了時に出力されます。

以下の例は CI とレビューコメントをチェックし、PR が静かになると Claude がより長く反復間で待機します。

```text theme={null}
/loop check whether CI passed and address any review comments
```

[Monitor ツールが利用可能](https://code.claude.com/docs/ja/tools-reference.md#monitor-tool)なセッションでは、動的な `/loop` スケジュールをリクエストすると、Claude は Monitor ツールを直接使用する場合があります。Monitor はバックグラウンドスクリプトを実行し、各出力行をストリーミングバックします。これにより、ポーリングを完全に回避でき、プロンプトを間隔で再実行するよりも多くの場合、トークン効率が高く、応答性が高くなります。

動的にスケジュールされたループは、他のタスクと同様に[スケジュールタスクリスト](#manage-scheduled-tasks)に表示されるため、同じ方法でリストまたはキャンセルできます。リストには保留中のウェイクアップが単発タスクとして表示されるため、`:00` または `:30` にスケジュールされたウェイクアップは[少し早く実行される](#when-a-one-shot-task-runs-early)場合があります。[7 日間の有効期限](#seven-day-expiry)もループに適用されます。

> [!NOTE]
>
> 動的に選択された間隔と[組み込みメンテナンスプロンプト](#run-the-built-in-maintenance-prompt)はすべてのプロバイダーで機能し、[フィーチャーフラグ取得](https://code.claude.com/docs/ja/env-vars.md#features-that-need-feature-flag-fetching)がオフになっている場合でも機能します。Amazon Bedrock、Claude Platform on AWS、Google Cloud の Agent Platform、Microsoft Foundry、または取得がオフになっている場合、両方とも Claude Code v2.1.248 以降が必要です。

### 組み込みメンテナンスプロンプトを実行する

プロンプトを省略すると、Claude は提供するプロンプトの代わりに組み込みメンテナンスプロンプトを使用します。各反復で、以下を順番に処理します。

* 会話からの未完了の作業を続行する
* 現在のブランチのプルリクエストを処理する。レビューコメント、失敗した CI 実行、マージコンフリクト
* 他に何も保留中でない場合、バグハントや簡素化などのクリーンアップパスを実行する

Claude はそのスコープ外の新しいイニシアチブを開始せず、プッシュまたは削除などの取り消し不可能なアクションは、トランスクリプトが既に承認した何かを続行する場合にのみ進行します。

```text theme={null}
/loop
```

裸の `/loop` は、このプロンプトを[動的に選択された間隔](#let-claude-choose-the-interval)で実行します。例えば `/loop 15m` のように間隔を追加して、代わりに固定スケジュールで実行します。組み込みプロンプトを独自のデフォルトに置き換えるには、[loop.md でデフォルトプロンプトをカスタマイズする](#customize-the-default-prompt-with-loop-md)を参照してください。

### loop.md でデフォルトプロンプトをカスタマイズする

`loop.md` ファイルを作成して、[組み込みメンテナンスプロンプト](#run-the-built-in-maintenance-prompt)を独自の指示に置き換えます。これは、裸の `/loop` の単一のデフォルトプロンプトを定義し、個別のスケジュール済みタスクのリストではなく、コマンドラインでプロンプトを指定するたびに Claude Code は無視します。それと一緒に追加のプロンプトをスケジュールするには、`/loop <prompt>` を使用するか、[Claude に直接依頼してください](#manage-scheduled-tasks)。

Claude は 2 つの場所でファイルを探し、最初に見つかったものを使用します。

| パス | スコープ |
| :- | :- |
| `.claude/loop.md` | プロジェクトレベル。両方のファイルが存在する場合は優先されます。 |
| `~/.claude/loop.md` | ユーザーレベル。独自のファイルを定義しないプロジェクトに適用されます。 |

ファイルは必須の構造を持たないプレーン Markdown です。`/loop` プロンプトを直接入力しているかのように記述してください。以下の例は、リリースブランチを健全に保ちます。

```markdown title=".claude/loop.md" theme={null}
Check the `release/next` PR. If CI is red, pull the failing job log,
diagnose, and push a minimal fix. If new review comments have arrived,
address each one and resolve the thread. If everything is green and
quiet, say so in one line.
```

`loop.md` への編集は次の反復で有効になるため、ループが実行中に指示を改善できます。どちらの場所にも `loop.md` が存在しない場合、ループは組み込みメンテナンスプロンプトにフォールバックします。ファイルは簡潔に保ってください。25,000 バイトを超えるコンテンツは切り詰められます。

### ループを停止する

* **[自分のペースで実行するループ](#let-claude-choose-the-interval)**: ループが次の反復を待機している間に `Esc` を押すと停止します。Claude がアイドル状態のときは `Ctrl+C` で停止することもできます。ただし、[アタッチしたバックグラウンドセッション](#detach-without-stopping-a-loop)では除きます。`Pending wakeup cancelled` という通知により、ループが再度実行されないことを確認できます。
* **[固定間隔のループ](#run-on-a-fixed-interval)**: `/loop 5m` などのループを停止するには、Claude にキャンセルを依頼します（例: `cancel the deploy check loop`）。`Esc` と `Ctrl+C` では、このループも、[Claude に直接依頼してスケジュールした](#manage-scheduled-tasks)タスクも停止しません。キャンセルしないループは [7 日が経過](#seven-day-expiry)すると終了します。

[自分のペースモード](#let-claude-choose-the-interval)では、Claude はタスクが完了したら自分でループを終了することもできます。Claude は [`ScheduleWakeup` ツール](https://code.claude.com/docs/ja/tools-reference)を `stop: true` で呼び出し、保留中のウェイクアップを直ちにキャンセルします。反復がスケジュール変更またはスケジュール停止のいずれも行わずに終了した場合、Claude Code は約 20 分後にフォールバックウェイクアップをスケジュールし、その反復がスケジュール変更も行わない場合にループを終了します。

#### ループを停止せずにデタッチする

[バックグラウンドセッションにアタッチ](https://code.claude.com/docs/ja/agent-view.md#attach-to-a-session)していて Claude がアイドル状態のときは、空のプロンプトで `Ctrl+C` を 2 回押すとデタッチします。そこで次の反復を待機している自分のペースのループは実行を続け、その反復はスケジュールどおりに開始されます。代わりにループを停止するには、デタッチする前に `Esc` を押します。ループを停止せずに `Ctrl+C` でデタッチするには、Claude Code v2.1.295 以降が必要です。

## 1 回限りのリマインダーを設定する

1 回限りのリマインダーの場合は、`/loop` を使用する代わりに、自然言語で実行したい内容を説明してください。Claude は実行後に自身を削除する単一実行タスクをスケジュールします。

```text theme={null}
remind me at 3pm to push the release branch
```

```text theme={null}
in 45 minutes, check whether the integration tests passed
```

Claude は cron 式を使用して実行時刻を特定の分と時間に固定し、いつ実行されるかを確認します。

## セッションスコープのスケジュールタスクを管理する

自然言語で Claude にタスクをリストまたはキャンセルするよう依頼するか、基盤となるツールを直接参照してください。

```text theme={null}
what scheduled tasks do I have?
```

```text theme={null}
cancel the deploy check job
```

これらは Claude が使用する基盤となるツールです。

| ツール | 目的 |
| :- | :- |
| `CronCreate` | 新しいタスクをスケジュールします。5 フィールドの cron 式、実行するプロンプト、および繰り返すか 1 回実行するかを受け入れます。 |
| `CronList` | スケジュールタスクを、ID、スケジュール、[次回実行時刻](#jitter)、プロンプトとともにリストします。 |
| `CronDelete` | ID でタスクをキャンセルします。 |

各スケジュール済みタスクには、`CronDelete` に渡すことができる 8 文字の ID があります。セッションは一度に最大 50 個のスケジュール済みタスクを保持できます。

## セッションスコープのスケジュールタスクの実行方法

スケジューラは毎秒期限切れのタスクをチェックし、低優先度でキューに入れます。スケジュール済みプロンプトは、Claude が応答の途中ではなく、ターン間で実行されます。タスクが期限切れになったときに Claude がビジーの場合、プロンプトは現在のターンが終了するまで待機します。

すべての時間はローカルタイムゾーンで解釈されます。`0 9 * * *` のような cron 式は、UTC ではなく、Claude Code を実行している場所の午前 9 時を意味します。

### ジッター

スケジュールタスクは、スケジュールで指定された時刻とは異なる時刻に実行されることがあります。すべてのセッションのタスクが正確にスケジュールどおりに実行されると、多くのタスクが同じ瞬間に API を呼び出すことになるため、Claude Code は各タスクの実行時刻をずらします。定期的なタスクは遅れて実行されます。ただし、`*/5 * * * *` と記述される 5 分ごとに実行されるタスクは例外です。毎時 0 分または 30 分にスケジュールされた 1 回限りのタスクは少し早く実行されます。

タスクの次回実行予定時刻を確認するには、ターミナルで Claude の `CronCreate` 呼び出しの下にある行を確認してください。この行には、スケジュールの後にその時刻が表示されます（例：`next run 10:21 AM`）。後で改めて確認するには、[Claude にタスクの一覧表示を依頼](#manage-scheduled-tasks)し、`CronList` 呼び出しの下の行で `next run` を探してください。これらの行に次回実行時刻が表示されるには、Claude Code v2.1.299 以降が必要です。

#### 定期的なタスクがどれだけ遅れて実行されるか

5 分ごとに実行されるタスクを除き、定期的なタスクは各実行を、次の実行までの間隔の最大半分、かつ最長 30 分遅れて開始します。タスクは次の 3 つのケースのいずれかに該当します。

* **等間隔の実行**：1 時間ごと、毎日、10 分ごとなど、間隔が等しいタスクは、セッションがアイドル状態の場合も含め、毎回同じ分数だけ遅れて実行されます。
* **不等間隔の実行**：毎時 `:00` と `:15` にスケジュールされたタスクなど、間隔が等しくないタスクは、実行ごとに異なる分数だけ遅れて実行されることがあります。
* **5 分ごと**：`*/5 * * * *` と記述されたタスクは遅延しません。前回の実行のちょうど 5 分後に実行すると、5 分間の[プロンプトキャッシュ](https://code.claude.com/docs/ja/prompt-caching.md#which-ttl-each-request-gets)の有効期限が切れた後に開始されることになるため、各実行は 15 秒早く開始されます。

この表の最初の列で該当するスケジュールを探すと、各実行がいつ開始されるかを確認できます。

| スケジュール | 各実行の開始時刻 |
| :- | :- |
| 5 分ごと（`*/5 * * * *` と記述。`/loop 5m` で作成されるのはこの形式） | 前回の実行から 4 分 45 秒後 |
| 10 分ごと | 0〜5 分遅れ |
| 30 分ごと | 0〜15 分遅れ |
| 1 時間ごと、または毎日などそれより低い頻度 | 0〜30 分遅れ |

たとえば、`7,37 * * * *` はタスクを `:07` と `:37` にスケジュールします。この 2 つは 30 分間隔なので、遅延は 0〜15 分のいずれかになります。このタスクの遅延が 14 分の場合、毎時 `:21` と `:51` に実行されます。スケジュールを別の分に変更すると実行時刻は移動しますが、その場合も遅延は上乗せされます。

#### 1 回限りのタスクが早く実行される場合

`:00` または `:30` にスケジュールされた 1 回限りのタスクは、最大 90 秒早く実行されます。Claude Code はそれ以外の分にスケジュールされた 1 回限りのタスクの実行時刻はずらさないため、タイミングが重要な場合は、`0 9 * * *` ではなく `3 9 * * *` のように、毎時 0 分と 30 分を避けてスケジュールしてください。

### 7 日間の有効期限

定期的なタスクは作成後 7 日で自動的に期限切れになります。タスクは最後に 1 回実行され、その後自身を削除します。これにより、忘れられたループが実行できる期間が制限されます。定期的なタスクをより長く続ける必要がある場合は、期限切れになる前にキャンセルして再作成するか、永続的なスケジューリングのために[クラウドスケジュールタスク](https://code.claude.com/docs/ja/routines.md)または [Desktop スケジュールタスク](https://code.claude.com/docs/ja/desktop-scheduled-tasks.md)を使用してください。

## Cron 式リファレンス

`CronCreate` は標準 5 フィールド cron 式を受け入れます。`minute hour day-of-month month day-of-week`。すべてのフィールドは、ワイルドカード（`*`）、単一値（`5`）、ステップ（`*/15`）、範囲（`1-5`）、カンマ区切りリスト（`1,15,30`）をサポートしています。

| 例 | 意味 |
| :- | :- |
| `*/5 * * * *` | 5 分ごと |
| `0 * * * *` | 毎時間の時刻 |
| `7 * * * *` | 毎時間 7 分経過時 |
| `0 9 * * *` | 毎日午前 9 時（ローカル） |
| `0 9 * * 1-5` | 平日午前 9 時（ローカル） |
| `30 14 15 3 *` | 3 月 15 日午後 2 時 30 分（ローカル） |

曜日は日曜日の場合は `0` または `7`、土曜日の場合は `6` を使用します。`L`、`W`、`?` などの拡張構文や、`MON` や `JAN` などの名前エイリアスはサポートされていません。

月の日と曜日の両方が制約されている場合、どちらかのフィールドが一致すれば日付が一致します。これは標準の vixie-cron セマンティクスに従います。

## セッションスコープのスケジュールタスクを無効にする

環境で `CLAUDE_CODE_DISABLE_CRON=1` を設定して、スケジューラ全体を無効にします。cron ツールと `/loop` は利用できなくなり、既にスケジュール済みのタスクは実行を停止します。無効化フラグの完全なリストについては、[環境変数](https://code.claude.com/docs/ja/env-vars.md) を参照してください。

## 制限事項

セッションスコープのスケジューリングには固有の制約があります。

* タスクは Claude Code が実行中でアイドル状態の場合にのみ実行されます。ターミナルを閉じるか、セッションを終了すると、タスクは実行を停止します。[セッションをバックグラウンドで実行する](https://code.claude.com/docs/ja/agent-view.md#from-inside-a-session)と、`/loop` タスクがバックグラウンドセッションに引き継がれ、ターミナルなしで実行を続けます。
* 見落とされた実行のキャッチアップはありません。タスクのスケジュール済み時間が Claude が長時間実行されるリクエストでビジーの間に経過した場合、Claude がアイドル状態になったときに 1 回実行され、見落とされた間隔ごとに 1 回ではありません。
* [バックグラウンドセッション](https://code.claude.com/docs/ja/agent-view.md#from-inside-a-session)では、クラッシュ後など、セッションのプロセスが実行されていない間に次のウェイクアップの時刻が来ると、[自分のペースで実行するループ](#let-claude-choose-the-interval)は停止します。プロセスが再び起動すると、トランスクリプトに[ウェイクアップが実行されないという通知](https://code.claude.com/docs/ja/errors.md#restarted-after-its-next-loop-wakeup-was-due)が表示されます。ループを続けるには、[セッションに返信](https://code.claude.com/docs/ja/agent-view.md#peek-and-reply)して、ループの実行を続けるよう Claude に依頼してください。
* `claude --resume` または `claude --continue` でセッションを再開すると、Claude Code は `CronCreate` でスケジュールされたタスクを復元します。ただし、[有効期限切れ](#seven-day-expiry)になっている定期的なタスク、およびスケジュール済み時間がすでに経過している 1 回限りのタスクは除きます。[自分のペースで実行する `/loop`](#let-claude-choose-the-interval)は復元されないため、再度 `/loop` を実行して再開してください。
* 復元された定期的なタスクは、セッションが実行されていなかった間に見逃した実行分については実行されません。次の実行は再開後に最初に予定されている実行で、その実行には[ジッター](#jitter)が適用されます。
* `claude --resume` または `claude --continue` で再開しても、Claude Code はセッション終了時に実行中だったバックグラウンドの Bash コマンドとモニターを再起動しません。引き続き必要な場合は、再度開始するよう Claude に依頼してください。
* [フィーチャーフラグ取得がオフ](https://code.claude.com/docs/ja/env-vars.md#features-that-need-feature-flag-fetching)の場合、Claude Code はセッション間で保持するよう要求したタスクをプロジェクトの `.claude/scheduled_tasks.json` ファイルに保存します。`.claude` ディレクトリまたはそのファイルがシンボリックリンクの場合、Claude Code はタスクをスケジュールする代わりにエラーを返します。保存されたタスクは、それを作成したプロジェクトフォルダでのみ実行されます。ファイルを新しいワークツリーなど別のフォルダにコピーした場合、そこのセッションはコピーされたタスクをリストしますが実行しないため、そのフォルダで再度タスクを作成してください。

無人で実行する必要がある cron 駆動オートメーションの場合は、以下を使用してください。

* [クラウドスケジュールタスク](https://code.claude.com/docs/ja/routines.md)：クラウドでスケジュールに従って実行、API 呼び出し、または GitHub イベント時に実行
* [GitHub Actions](https://code.claude.com/docs/ja/github-actions.md)：CI で `schedule` トリガーを使用
* [Desktop スケジュール済みタスク](https://code.claude.com/docs/ja/desktop-scheduled-tasks.md)：マシン上でローカルに実行
