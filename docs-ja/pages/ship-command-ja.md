> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# /ship と /steward でプルリクエストをマージ可能な状態にする

> `/ship` を実行すると、GitHub のプルリクエストを開いてレビューを受け、Claude にフィードバックと失敗したチェックへの対応を任せられます。開いているプルリクエストでレビューを省略するには `/steward` を実行します。

`/ship` は、ブランチにプルリクエストがない場合に、変更の GitHub プルリクエストを開く Claude Code コマンドです。Claude は変更をレビューし、フィードバックと失敗したチェックに対応して、マージできる状態に仕上げる手助けをします。

プルリクエストがすでに開いていてレビューが不要な場合は、[`/steward`](#start-a-watch-with-%2Fsteward) と入力します。レビューは省略され、Claude はフィードバックと失敗したチェックに対して同じ作業を行います。

> [!NOTE]
>
> どちらのコマンドも、ターミナルの Claude Code CLI から、リポジトリのローカルクローン内で実行してください。クラウドセッションではこれらのコマンドは使用できません。

`/ship` と入力すると、変更は次の手順を経ます。

![/ship と入力した後に起こることを示す図。セッション内で Claude Code がプルリクエストを開き、/code-review でレビューします。続いてウォッチが始まります。Claude はブランチに修正をプッシュし、チェック、コメント、コンフリクトに対応します。プルリクエストの準備ができたら、ユーザーがマージします。](https://mintcdn.com/claude-code/sMH7RDpTvyWlAkrg/images/ship-flow.svg?fit=max\&auto=format\&n=sMH7RDpTvyWlAkrg\&q=85\&s=ccfa7e5848711d691b8cdf65ac22b26e)

1. **プルリクエスト**: `/ship` はユーザーとして[作業をコミットし、ブランチをプッシュし、プルリクエストを開く](#what-%2Fship-commits-and-pushes)ことができます
2. **レビュー**: Claude が [`/code-review`](https://code.claude.com/docs/ja/code-review-local) で変更をレビューします
3. **ウォッチ**: Claude は Claude Code セッションからプルリクエストを継続的に確認します。失敗したチェック、マージコンフリクト、レビュアーのコメント、自身のレビューでの指摘事項に対応し、修正をプッシュします。この継続的な作業をウォッチと呼びます
4. **マージ**: プルリクエストの準備ができたら、自分でマージします

`/steward` は手順 1 と 2 を省略してウォッチを開始します。

## /ship と /steward を使う場面

どちらのコマンドでも、Claude はプルリクエストのフィードバックと失敗したチェックに対応します。変更がどの段階にあるかによって、`/ship` と `/steward` を使い分けます。

* **`/ship`**: 変更が完成しており、Claude にレビューしてもらった後、その後のフィードバックと失敗したチェックに対応してもらいたい場合
* **`/steward`**: プルリクエストがすでに開いていて、先にレビューを受ける必要がない場合、またはウォッチが終了して再開したい場合

どちらのコマンドもセッション内で実行されるため、その作業は使用量にカウントされます。

レビューのみ、またはクラウドセッションからの修正など、別のことをしたい場合は、次のいずれかを使用します。

| 目的 | 使用するもの |
| :- | :- |
| レビューのみ | [`/code-review`](https://code.claude.com/docs/ja/code-review-local) |
| フィードバックが届くたびに、クラウドセッションから修正する | [Auto-fix](https://code.claude.com/docs/ja/claude-code-on-the-web.md#auto-fix-pull-requests) または `/autofix-pr` |
| リポジトリ全体を対象とし、組織に請求されるエージェント | [Claude Ship](https://code.claude.com/docs/ja/claude-ship.md) |

## /ship と /steward の前提条件

次のツールをインストールまたは更新します。

* Claude Code v2.1.330 以降。`/ship` が見つからない場合は、[セッションで /ship が使用できない](https://code.claude.com/docs/ja/ship-command-troubleshooting.md#%2Fship-isn’t-available-in-your-session)を参照してください
* [GitHub CLI](https://cli.github.com) 2.63 以降（`gh auth login` でサインイン済みであること）。古いバージョンでは、Claude は修正をプッシュできません
* 新しいコミットをブランチにマージするための git 2.38 以降。古い git では、Claude はそれらのマージをユーザーに任せます

次に、変更とセッションを準備します。

* **完成した変更（`/ship` の場合）**: GitHub 上のリポジトリのローカルクローンに用意します。未コミットでも、デフォルトブランチ以外のブランチにコミット済みでも、自分の開いているプルリクエストにすでに含まれていてもかまいません。リポジトリが GitHub 以外でホストされている場合、`/ship` はプルリクエストを開かず、Claude が変更をレビューします
* **プルリクエストに含めたいファイルのみ（`/ship` の場合）**: `/ship` は、新規ファイルを含め、未コミットの変更をすべてコミットできます。シェルで `git status` を実行します。プルリクエストに含めたくない新規ファイルはそれぞれ削除するか、`git stash push -u -- <file>` で stash します
* **それらのファイルにシークレットが含まれていないこと（`/ship` の場合）**: `/ship` は `.env` などのファイル名でシークレットを探すため、ファイルの中身は自分で確認してください。`Read(./notes.txt)` などの拒否ルールでは、ファイルをコミットから除外できません
* **GitHub 上の開いているプルリクエスト（`/steward` の場合）**: 自分のプルリクエストであり、そのブランチがローカルクローンでチェックアウトされている必要があります
* **権限モード**: Claude に無人でプルリクエストの作業をさせたい場合は、[auto モード](https://code.claude.com/docs/ja/permission-modes.md#eliminate-prompts-with-auto-mode)を選択します。その他のほとんどの権限モードでは、Claude はプロンプトごとに待機します。`bypassPermissions` モードでは、ウォッチは開始されません

ネイティブ Windows では、[ウォッチは開始されません](https://code.claude.com/docs/ja/ship-command-troubleshooting.md#cases-where-no-watch-can-start)。

> [!WARNING]
>
> ウォッチは、ベースブランチにマージできる人とブランチにプッシュできる人の全員を信頼できる場合にのみ実行してください。それらの誰もが、ユーザーの認証情報を使ってユーザーのコンピューター上でプログラムを実行できます。

## /ship または /steward を実行する

ターミナルでクローン内の Claude Code を開き、プロンプトで `/ship` または `/steward` と入力します。どちらも、プルリクエストの番号などの[引数](#arguments-for-%2Fship-and-%2Fsteward)を受け付けます。

### 完成した変更に対して /ship を実行する

Claude と一緒に変更を行った場合は、同じセッションを使用してください。Claude はセッションの会話からコミットメッセージを書くためです。プルリクエストを閲覧できる人は誰でもそのメッセージを読めます。

> [!NOTE]
>
> `/ship` は確認プロンプトなしで進行します。Enter を押すと、ユーザーとして[作業をコミットし、ブランチをプッシュし、プルリクエストを開く](#what-%2Fship-commits-and-pushes)ことができます。コミットの前と、プッシュの前にもう一度、`Esc to cancel` で終わる行がこれから何が起こるかを示します。何もしなければ、数秒後に `/ship` は続行します。

プッシュの前にキャンセルした場合でも、`/ship` が作成したコミットは残ります。ファイルを保持したままコミットを取り消すには、シェルで `git reset HEAD~1` を実行します。

### /ship がコミットおよびプッシュする内容

フォークではない github.com 上のリポジトリでは、`/ship` はレビューの前に、未コミットの変更をコミットし、ブランチをプッシュし、プルリクエストを開くことができます。デフォルトブランチ上では、新しいブランチにコミットし、チェックアウトをそのブランチに切り替えます。作業がすでに別のブランチにコミットされている場合、`/ship` はそのブランチをプッシュしてプルリクエストを開きます。

次の場合、`/ship` は未コミットの変更をコミットしません。当てはまる最初のケースに従ってください。

* **ブランチにプルリクエストがすでに開いている**: プルリクエストに含めたいものは自分でコミットしてプッシュします
* **リポジトリが公開されている**: デフォルトブランチ以外のブランチにいて、そのブランチ独自のコミットがある場合、`/ship` はそれらをプッシュし、未コミットの変更を含めずにプルリクエストを開きます。それ以外の場合は、デフォルトブランチ以外のブランチに作業をコミットしてから、もう一度 `/ship` を実行します
* **未コミットのファイルの名前がシークレットを示唆している（`.env` など）**: 公開されていないリポジトリでは、`/ship` は何もコミットもプッシュもしません。[/ship が何もコミットまたはプッシュしなかった](https://code.claude.com/docs/ja/ship-command-troubleshooting.md#%2Fship-committed-or-pushed-nothing)を参照してください

次のいずれかが必要な場合は、自分でプルリクエストを開いてから `/ship` を実行します。

* ドラフトプルリクエスト
* 別のベースブランチ
* リポジトリのプルリクエストテンプレート
* [GitHub Enterprise 上またはフォークからの](https://code.claude.com/docs/ja/ship-command-troubleshooting.md#github-enterprise-and-forks)プルリクエスト

`/ship` が何もコミットまたはプッシュせず、上記のケースでその理由が説明されない場合は、[/ship が何もコミットまたはプッシュしなかった](https://code.claude.com/docs/ja/ship-command-troubleshooting.md#%2Fship-committed-or-pushed-nothing)を参照してください。

### /steward でウォッチを開始する

事前のレビューなしでウォッチを開始するには、Claude Code のプロンプトで `/steward` と入力します。自分の開いているプルリクエストに対して使用するか、ウォッチが終了した後に再開するために使用します。ウォッチを放置する前に、[ウォッチがコンピューター上で実行するコード](#code-that-a-watch-runs-on-your-computer)を確認してください。

`/steward` は、組織が設定するエージェントである [PR Steward](https://code.claude.com/docs/ja/pr-steward.md) とは別のものです。PR Steward がすでにプルリクエストの作業をしている場合、ウォッチは開始されません。

## ウォッチ中に Claude が行うこと

ウォッチとは、`/ship` のレビュー後、または `/steward` と入力したときに始まる、プルリクエストに対する Claude の継続的な作業です。Claude はユーザーの `gh` と `git` のサインインを使用するため、GitHub 上での Claude の作業はユーザーの名前で表示されます。

auto モードでは、Claude は確認せずに次のアクションを実行します。

* 問題であると判断したレビューの指摘事項に対応する
* レビューをまとめたコメントを 1 件投稿できる
* ブランチにコミットをプッシュする
* コンフリクトを解決するため、またはブランチを最新の状態にするために、ベースブランチをユーザーのブランチにマージする
* 失敗したチェックに対応し、失敗したチェックを再実行する
* レビューコメントに返答し、スレッドを解決し、レビューを再リクエストする

Claude は、ユーザー自身と書き込みアクセス権を持つ人からのコメントを読みます。github.com では、Claude のボットからのコメントも読みます。Claude に別のボットのコメントを読ませるには、`/steward +my-lint-bot` のように、`/steward +` に続けてボットの名前を入力します。

チェックが通り、コメントへの返答が済むと、Claude はセッション内でその旨を伝えます。プルリクエストは自分でマージしてください。何がマージできるかは、ユーザーの権限とリポジトリのブランチルールによって異なります。[ウォッチがマージにつながる場合](#when-a-watch-can-lead-to-a-merge)を参照してください。

### ウォッチの実行中に作業を続ける

ウォッチの実行中は、セッションを開いたまま[フォアグラウンド](https://code.claude.com/docs/ja/agent-view.md#send-the-session-to-the-background)に保ち、コンピューターをスリープさせず、プルリクエストのブランチをチェックアウトしたままにしてください。Claude はユーザーと同じチェックアウト内のファイルを編集します。

* **次の変更を始めるには**: リポジトリの 2 つ目のクローンなど別のフォルダーで作業し、そこで別の Claude Code セッションを開きます
* **自分のコミットをプッシュするには**: `git push origin <branch>` のように、リモートとブランチを指定します。`git push -u` や `git branch -u` などで git の設定を変更すると、ウォッチは終了します
* **プッシュしていないコミット**: Claude の次のプッシュで一緒にプッシュされる可能性があります
* **未コミットの作業**: Claude は作業中のファイルを編集でき、それをコミットすることもできます。Claude がユーザーからのメッセージなしで動作する場合、Claude Code は Claude からの `git stash`、`git reset`、`git checkout`、`git add -A`、`git commit -a` の各コマンドを拒否します

### 先に Claude に確認してもらう

Claude が `/ship` のレビューの指摘事項やレビュアーのコメントに対応する前にそれらを確認したい場合は、Claude Code のプロンプトでメッセージを送ってその旨を伝えます。Claude が何かを修正する前に指摘事項を確認するには、レビューの実行中にメッセージを送信します。

次の例では、指摘事項を表示し、プッシュや返信の前に確認するよう Claude に求めています。

```text theme={null}
From now on, don't push code changes or reply to reviewers without asking me first. Show me the review findings and wait.
```

このメッセージは Claude への依頼であり、Claude Code がそれを強制するわけではありません。

### リポジトリでのウォッチの指示を保存する

リポジトリ内のプルリクエストをどう扱うかを Claude に伝えるには、リポジトリの最上位フォルダーの `.claude/skills/steward/SKILL.md` にファイルを保存します。[PR Steward も同じファイルを読む](https://code.claude.com/docs/ja/pr-steward-pull-requests.md#save-pr-steward-instructions-for-everyone-in-a-repository)ため、1 つのファイルで両方に対応でき、そのセクションに例があります。

ウォッチ中、Claude はチェックアウト内のコピーを読み、たとえばどのチェックが重要か、テストをどう実行するかについての指示として、次の制限の範囲内で従います。

* **インストールとダウンロード**: Claude は、その例の `npm install` 行など、何かをインストールまたはダウンロードする行をスキップすることがあります
* **ブロックされるコマンド**: このファイルによって[ウォッチ中に Claude Code がブロックするもの](#what-claude-code-blocks-during-a-watch)が変わることはありません
* **ファイルへの変更**: ウォッチの実行中にユーザー自身がファイルを追加または編集すると、ウォッチは終了します。他の誰の変更がこのファイルに反映されうるかについては、[ウォッチがコンピューター上で実行するコード](#code-that-a-watch-runs-on-your-computer)を参照してください

## ウォッチを確認、停止、再開する

ウォッチとは、`/ship` のレビュー後、または `/steward` と入力したときに始まる、プルリクエストに対する Claude の継続的な作業です。ウォッチはセッション内で実行されるため、Claude Code のプロンプトで確認や停止を行います。

### ウォッチが実行中かどうかを確認する

Claude Code のプロンプトで `/tasks` と入力します。レビューが完了した後、Claude が作業していない間は、実行中のウォッチが、名前が `/steward --tend` で始まるスケジュールタスクとして一覧に表示されます。

### ウォッチが終了する条件

ウォッチが終了したら、`Stopped watching pull request` で始まる行を探します。[ウォッチが停止した](https://code.claude.com/docs/ja/ship-command-troubleshooting.md#a-watch-stopped)に、その行が示す理由の一覧があります。

次のような場合にウォッチは終了します。

| 場所 | ウォッチを終了させるもの |
| :- | :- |
| プルリクエスト上 | マージまたはクローズされた、[PR Steward](https://code.claude.com/docs/ja/pr-steward.md) がラベルを付けた、または 7 日が経過した |
| キーボード | プロンプトで、または Claude の作業中に `Esc` または `Ctrl+C` を押した。1 回押すだけで、確認なしにウォッチが終了することがある |
| チェックアウト内 | 別のブランチをチェックアウトした、または git の設定を変更した |
| セッション内 | セッションが終了した、セッションをバックグラウンドに送った、別のウォッチまたはタスク付きの `/loop` を開始した、または `/clear`、`/resume`、`/branch` を実行した |
| 失敗後 | エラー、拒否したプロンプト、または使用制限により早期に終了することがある |

### ウォッチを停止または再開する

ウォッチを終了するには、ウォッチを実行しているセッションの Claude Code プロンプトで `/ship stop` と入力します。入力時に Claude が作業中の場合、ウォッチは現在のターンが終わった時点で終了するため、そのターンで Claude がプッシュまたは投稿したものはプルリクエストに反映されます。ターンも停止するには、`Esc` を押します。

ウォッチを再開するには、[`/steward`](#start-a-watch-with-%2Fsteward) と入力します。

## ウォッチを実行する場所を決める

ウォッチとは、`/ship` のレビュー後、または `/steward` と入力したときに始まる、プルリクエストに対する Claude の継続的な作業です。Claude はユーザーの `gh` と `git` のサインインで作業します。ウォッチを放置する前に、Claude Code が何をブロックするか、どのコードがコンピューター上で実行されうるか、何が依然としてマージにつながりうるかを確認してください。

### ウォッチ中に Claude Code がブロックするもの

Claude がユーザーからのメッセージなしで動作する場合、Claude Code は、プルリクエストをマージする、承認する、自動マージをオンにする、または強制プッシュする `gh` と `git` のコマンドをブロックします。そのような場合、Claude Code は Claude の `gh` と `git` のコマンドを短いリストに制限し、コネクタ、`WebFetch`、`WebSearch` など、ウォッチに不要なツールを拒否します。Claude Code でこれらの制限を確認するには、プロンプトで `/ship terms` と入力します。

> [!WARNING]
>
> ウォッチの制限がすべてを網羅しているわけではありません。ウォッチはユーザーの `gh` と `git` のサインインを使用するため、リポジトリのブランチルールで他者の承認なしにユーザーがマージできるプルリクエストであれば、マージしてしまう可能性があります。[ウォッチがマージにつながる場合](#when-a-watch-can-lead-to-a-merge)を参照してください。権限ルールやフックなど、セッション内の設定によって、[コマンドが制限をすり抜ける](https://code.claude.com/docs/ja/ship-command-troubleshooting.md#messages-during-a-watch)ことがあります。

### ウォッチがコンピューター上で実行するコード

ウォッチ中、次の各ソースからのコードが、ユーザーの認証情報でコンピューター上で実行される可能性があります。

| ソース | 何が起こるか |
| :- | :- |
| ベースブランチ | コンフリクトを解決するため、またはブランチを最新の状態にするため、Claude はベースブランチをユーザーのブランチにマージします。これには自動的に実行されるスクリプトも含まれます |
| 他の人によるブランチへのプッシュ | Claude はそれらをマージするよう指示されています |
| テストなど、ブランチのプログラム | Claude がそれらを実行します。それらはユーザーの認証情報でマージや強制プッシュを行えます。Claude Code は、セッションの権限モードのもとで、それらを起動するコマンドのみをチェックします |
| Claude Code のフック | 確認なしで実行され、Claude が編集したファイルを実行することもあります |
| [`.claude/skills/steward/SKILL.md`](https://code.claude.com/docs/ja/pr-steward-pull-requests#save-pr-steward-instructions-for-everyone-in-a-repository) | チェックアウトにこのファイルがあれば、Claude はそれに従います。リポジトリにマージできる人なら誰でもこのファイルに書き込めます |

ベースブランチや他の人のプッシュをマージすると Claude Code の設定、`.mcp.json`、または git の設定ファイルが変更されることを Claude Code が検出した場合、Claude はそのマージをユーザーに任せます。

### ウォッチがマージにつながる場合

次のような場合に、マージにつながる可能性があります。

| ケース | 何が起こるか |
| :- | :- |
| プルリクエストで自動マージがオンになっている | チェックとレビューの条件が満たされると、GitHub がマージします。修正のプッシュなど、ウォッチ中の Claude の動作がそのきっかけになることがあります。オフにするには、シェルで `gh pr merge --disable-auto <number>` を実行します |
| ターミナルセッションで、Claude がアイドル状態のときにメッセージを入力した | Claude がメッセージに応答している間、[Claude Code の制限](#what-claude-code-blocks-during-a-watch)はオフになります。その間に届いたバックグラウンドタスクの結果を Claude が処理している間もオフになります。その場合、auto モードでは Claude がマージを許可される可能性があります |
| ターミナルで開始したセッションを、レビュー中またはウォッチ中に、たとえば `←` を押してバックグラウンドに送った | ウォッチは終了します。進行中の作業は、そこでこれらの制限なしに続行される可能性があります。その作業を終了するには、[そのセッションを停止](https://code.claude.com/docs/ja/agent-view.md#manage-sessions-from-the-shell)します |

### /ship と /steward に適用される権限ルールとフック

Claude Code は、`/ship` 自身のコミット、プッシュ、プルリクエストのコマンドを、[サンドボックスの外](https://code.claude.com/docs/ja/sandboxing.md#what-runs-outside-the-sandbox)で自ら実行します。ウォッチ中、Claude がユーザーからのメッセージなしで動作する場合、Claude は git の fetch、マージ、コミット、プッシュを `git -c core.hooksPath=/dev/null push` の形式で記述します。

ルールとフックは、ユーザー自身の設定にあるか管理設定にあるかにかかわらず、次のように適用されます。

| 設定 | `/ship` 自身のコミットとプッシュ | ウォッチ中 |
| :- | :- | :- |
| `Bash(git push *)` などの[拒否ルール](https://code.claude.com/docs/ja/permissions.md#manage-permissions) | `/ship` はそれらの手順をユーザーに任せます | ウォッチは開始されません |
| `Bash(git push *)` で確認するルール | Claude Code は参照しません | その形式には[一致しない](https://code.claude.com/docs/ja/permissions.md#bash-rule-limits)ため、プロンプトは追加されません |
| `Bash(git *)` で確認するルール | Claude Code は参照しません | 一致するため、auto モードを含め、ウォッチはプロンプトごとに待機します |
| auto モードのチェック、および `PreToolUse` などのツールフック | 実行されません | プルリクエストの読み取りなど、Claude Code がサンドボックスの外で自ら実行する `gh` と `git` のコマンドには適用されません |
| リポジトリのフックフォルダー内の Git フック | 実行されます | それらのターンでの Claude の fetch、マージ、コミット、プッシュでは実行されません |

## 組織で /ship と /steward をオフにする

両方のコマンドをオフにするには、[管理設定](https://code.claude.com/docs/ja/managed-settings.md)の [`skillOverrides`](https://code.claude.com/docs/ja/skills#override-skill-visibility-from-settings) の下に次のキーを設定します。`ship-local` は `/ship` の背後にあるスキルです。

次の例では両方をオフにします。

```json theme={null}
{
  "skillOverrides": {
    "ship-local": "off",
    "steward": "off"
  }
}
```

`/ship` 自身のプッシュを止めるには、`Bash(git push *)` などの[拒否ルール](https://code.claude.com/docs/ja/permissions.md#manage-permissions)を管理設定に追加します。このルールがあると、ウォッチは開始されません。

## /ship と /steward の引数

Claude Code のプロンプトで、`/ship` または `/steward` の後に引数を入力します。引数を組み合わせるには、`/ship low 41 +my-lint-bot` のように、effort レベルを先頭に置きます。

| 入力する値 | コマンド | 動作 |
| :- | :- | :- |
| `low`、`medium`、`high`、`xhigh`、または `max` | `/ship` | その effort レベルでのレビューを求めます。デフォルトは `high` です |
| `41`、またはプルリクエストの URL | `/ship`、`/steward` | そのプルリクエストを対象に作業します。ウォッチの場合、自分のプルリクエストであり、そのブランチがチェックアウトされている必要があります |
| `+botname` | `/ship`、`/steward` | そのボットのコメントも読みます。ウォッチを再開するときにも、繰り返し指定してください |
| `stop` | `/ship`、`/steward` | ウォッチを終了します |
| `terms` | `/ship`、`/steward` | ウォッチ中に Claude が行えることと、それを制限するものを表示します |

## 関連リソース

* [`/ship` と `/steward` のトラブルシューティング](https://code.claude.com/docs/ja/ship-command-troubleshooting): コマンドが出力するメッセージと対処方法
* [ローカルでコードをレビューする](https://code.claude.com/docs/ja/code-review-local.md): `/ship` が実行するレビュー
* [権限モード](https://code.claude.com/docs/ja/permission-modes.md): auto モードとその他の権限モード
