> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# Code Review を設定する

> Claude 組織で Code Review をオンにします。GitHub を接続し、Claude GitHub App をインストールし、リポジトリを選択して、レビューを実行するタイミングを設定します

Claude 組織の Owner は、claude.ai の [**Admin settings > Claude Code**](https://claude.ai/admin-settings/claude-code#code-review) で Code Review をオンにします。レビューは Anthropic のインフラストラクチャ上で実行されるため、リポジトリにワークフローファイルを追加する必要はありません。

設定後は、各リポジトリでレビューの綿密さと実行タイミングを選択します。レビューレベルが高いほど、またレビューの実行頻度が高いほど費用は増えます。[Code Review のコスト](/docs/ja/code-review-costs.md#pricing)を参照してください。

## Code Review をオンにするために必要なもの

まず、組織が [Code Review の対象](/docs/ja/code-review.md#availability)であることを確認します。次に、以下のアクセス権を自分が持っているか、持っている人がいることを確認します。

| アクセス権 | 必要となる作業 |
| :- | :- |
| Claude 組織での [Owner ロール](/docs/ja/server-managed-settings.md#access-control) | 管理ページでのすべての手順 |
| GitHub 組織のオーナー | Claude GitHub App のインストールと、[Claude 組織へのリンク](/docs/ja/admin-setup.md#connected-github-accounts)。オーナーでない場合は、開始前にオーナーにアプリのインストールとリンクを依頼してください |
| Claude に接続する GitHub アカウントでの、追加する各リポジトリへの書き込みアクセス権 | リポジトリの追加 |

## Code Review をオンにする

**1. Allow code review スイッチをクリックする**

[**Admin settings > Claude Code**](https://claude.ai/admin-settings/claude-code#code-review) の **Code review** セクションに移動し、**Allow code review** スイッチをクリックします。

ダイアログが表示されずに Code Review がすぐにオンになった場合、組織ではすでに Claude GitHub App がリンクされているか、リポジトリが追加されています。[リポジトリをさらに追加する](#add-more-repositories)に進み、その後最後の手順に戻ってください。

**2. GitHub アカウントを接続する**

**Connect GitHub** ダイアログが開いた場合は、**Connect** をクリックします。組織で GitHub Enterprise Server を使用している場合は、先にダイアログでインスタンスを選択します。GitHub で Claude の認可を求められ、その後 **Add a repository** ダイアログが開いた状態で管理ページに戻ります。

すぐに **Add a repository** が開いた場合は、アカウントがすでに接続されているため、次の手順に進んでください。

**3. Claude GitHub App をインストールする**

目的のリポジトリが **Add a repository** ダイアログに一覧表示されているか、そこで検索して見つかる場合は、次の手順に進みます。ダイアログには Claude GitHub App がアクセスできるリポジトリのみが表示されるため、表示されない場合はアプリをインストールします。

* **Install GitHub App** をクリックします。リポジトリが 1 つも表示されていない場合はダイアログ内のボタンとして表示されます。それ以外の場合は、ダイアログの GitHub 組織フィルターメニューの下部にあります。GitHub のインストールページが新しいタブで開きます。
* リポジトリを所有する GitHub 組織を選択します。
* アプリがアクセスできるリポジトリを選択します。
* 要求された権限を承認します。この権限セットはレビューで使用する範囲より広く、[GitHub Actions](/docs/ja/github-actions.md) など他の Claude 機能と共有されます。[レビューがアクセスできる範囲](/docs/ja/code-review.md#what-a-review-can-access)と[権限の完全な一覧](/docs/ja/github-actions.md#github-app-permissions)を参照してください。
* インストールが完了すると、タブは Claude に戻ります。**Finish connecting GitHub** ボタンが表示された場合は、それをクリックしてインストールを Claude 組織にリンクします。
* 管理ページのタブに戻ると、ダイアログ内の一覧が更新されます。

**4. リポジトリを選択する**

レビュー対象にするリポジトリを選択し、**Continue** をクリックします。リポジトリを追加するには、接続した GitHub アカウントでそのリポジトリへの書き込みアクセス権が必要です。[リポジトリは後から追加](#add-more-repositories)することもできます。

**5. Finish をクリックする**

続いて **Code review is set up** ダイアログが表示されます。**Finish** をクリックすると Code Review がオンになります。それ以外の方法でダイアログを閉じた場合、リポジトリは追加されたままですが **Allow code review** はオフのままになるため、スイッチからオンにします。

各リポジトリは最初、プッシュのたびにレビューする設定になっており、レビューの実行回数が最も多くなります。実行回数を減らすには、[レビューを実行するタイミングを設定](#set-when-reviews-run)してください。

**6. テスト用プルリクエストで確認する**

追加したリポジトリのいずれかでテスト用のプルリクエストを作成します。ドラフトにはしないでください。数分以内に **Claude Code Review** という名前のチェック実行が表示されます。リポジトリをすでに **Manual (@claude review)** に設定している場合は、プルリクエストに `@claude review` とコメントして最初のレビューを開始します。

チェック実行が表示されない場合は、[No check run appears on the test pull request](/docs/ja/code-review-troubleshooting.md#no-check-run-appears-on-the-test-pull-request) を参照してください。

レビューが届いたら、開発者に[プルリクエストでレビューを確認・リクエストする](/docs/ja/code-review-pull-requests.md)を共有してください。重大度レベル、コメントコマンド、指摘事項への対応方法が説明されています。

## 組織のデフォルトを設定する

Owner は、レビューの綿密さと実行頻度を決定します。どちらも [**Admin settings > Claude Code**](https://claude.ai/admin-settings/claude-code#code-review) の **Code review** セクションにあります。

### デフォルトのレビューレベルを設定する

レビューレベルは各レビューの綿密さを決めるもので、綿密なレビューほど費用がかかります。組織に 1 つのデフォルトを設定し、個々のリポジトリで上書きできます。

| レベル | トレードオフ |
| :- | :- |
| Quick | 軽めのチェック。最も速く、費用も最も低いレベル |
| Standard | 深さ、速度、費用のバランスを取ったレベル。デフォルトのレベル |
| Deep | 最も綿密なチェック。最も時間がかかり、費用も最も高い |

* **組織のデフォルト**：**Review level** でレベルを選択し、**Change level** で確定します。リポジトリ個別のレベルを設定しない限り、すべてのリポジトリでこのレベルが使用されます。
* **1 つのリポジトリ**：リポジトリの行の **Edit** をクリックし、そこで **Review level** を選択します。最初の選択肢である **Default** は組織の設定に従います。レベルは選択した時点で保存されます。

新しいレベルは、変更後に開始されるレビューに適用されます。各レビューの費用を左右するその他の要因については、[Code Review のコストと使用量](/docs/ja/code-review-costs.md)を参照してください。

### レビューを実行するタイミングを設定する

各リポジトリには個別の **Review runs** 設定があり、プルリクエストがレビューされるタイミングを決定します。

* **Once after PR creation**：プルリクエストが作成されたとき、再オープンされたとき、またはレビュー準備完了としてマークされたときにレビューが実行されます
* **After every push**：プルリクエストのブランチへのプッシュごとにレビューが実行されます。プルリクエストの変化に合わせて新たな問題を検出し、指摘された問題を修正するとスレッドが自動的に解決されます
* **Manual (@claude review)**：プルリクエストの作成やプッシュではレビューは開始されません。[`@claude review`](/docs/ja/code-review-pull-requests#comment-commands) とコメントしてレビューをリクエストするか、`@claude review always` とコメントして、以降のプッシュでもレビューを受けるようにプルリクエストを登録します。

Manual は、特定のプルリクエストだけをレビュー対象にしたいトラフィックの多いリポジトリや、準備が整ったプルリクエストだけをレビューしたい場合に便利です。各選択肢が費用に与える影響の比較については、[レビューの実行頻度](/docs/ja/code-review-costs.md#how-often-reviews-run)を参照してください。

設定を変更するには、**Repositories** テーブルでリポジトリの行の **Edit** をクリックし、**Review runs** の選択肢を選びます。選択は選んだ時点で保存され、テーブルの **Review runs** 列には Once per PR、Every push、Manual のいずれかの短縮表記で表示されます。

* **ドラフトとフォークからのプルリクエスト**：どの選択肢を選んでも、[自動レビューではどちらもスキップされます](/docs/ja/code-review-pull-requests.md#review-drafts-and-pull-requests-from-forks)
* **新しいリポジトリ**：**Add a repository** ダイアログから追加したリポジトリは **After every push** から始まります。その GitHub 組織が[組織全体として対象](#cover-a-whole-github-organization)になっている場合は、代わりにその組織の行の設定が適用されます。

### ヒントコメントのオン/オフを切り替える

ヒントコメントとは、レビューが開始されなかったときに、その理由と次に行うことを Claude がプルリクエストに投稿する短いコメントです。**Show tips on pull requests** はデフォルトでオンです。オンの場合、Claude は次の各ケースでヒントを投稿し、以下を説明します。

* **リポジトリが Manual に設定されている**：コメントでレビューをリクエストする方法
* **プルリクエストがフォークからのものである**：メンテナーがレビューをリクエストできること
* **ボット、またはプルリクエストの作成者ではなく書き込みアクセス権もないユーザーが `@claude review` とコメントした**：レビューが開始されなかったことと、誰がリクエストできるか
* **GitHub 組織が Claude 組織にリンクされていない**：レビューが一時停止していることと、リンクする方法

これらのコメントを止めるには、設定をオフにします。

### 開発者が変更できること

レビューレベル、**Review runs** 設定、レビュー対象のリポジトリを変更したい場合、開発者は Owner に依頼します。Owner ロールを持たない開発者でも、GitHub から次の操作を行えます。

* **レビューをリクエストする**：プルリクエストに [`@claude review`](/docs/ja/code-review-pull-requests#comment-commands) とコメントします。リポジトリへの書き込みアクセス権が必要で、自動レビューではスキップされる[ドラフトとフォークからのプルリクエスト](/docs/ja/code-review-pull-requests.md#review-drafts-and-pull-requests-from-forks)でも機能します。
* **1 つのプルリクエストをプッシュごとのレビューに登録する**：Manual に設定されたリポジトリなどで、[ドラフトでもフォークからのものでもない](/docs/ja/code-review-pull-requests.md#review-drafts-and-pull-requests-from-forks)プルリクエストに `@claude review always` とコメントします
* **レビューで指摘される内容を変更する**：[`REVIEW.md` と `CLAUDE.md` ファイル](/docs/ja/code-review-customize)をリポジトリにコミットします。たとえばチェックを追加できます

開発者がリクエストしたレビューは[組織に課金されます](/docs/ja/code-review-costs.md#pricing)。Code Review の月間の支出を制限するには、[支出を制限する](/docs/ja/code-review-costs.md#limit-your-spend)を参照してください。

## リポジトリを管理する

リポジトリは 1 つずつ追加することも、GitHub 組織全体をまとめて対象にすることもでき、不要な場所ではレビューを停止できます。

### リポジトリをさらに追加する

設定後にリポジトリを追加するには、**Code review** セクションの **Repositories** テーブルの上にある **Add** をクリックします。**Add a repository** ダイアログが開きます。リポジトリを選択し、**Continue** をクリックします。

* **リポジトリが一覧に表示されない**：[A repository isn't listed in Add a repository](/docs/ja/code-review-troubleshooting.md#a-repository-isn’t-listed-in-add-a-repository) を参照してください。
* **GitHub 組織内のすべてのリポジトリを対象にしたい**：リポジトリを 1 つずつ選択する代わりに、[組織全体を対象にします](#cover-a-whole-github-organization)

### GitHub 組織全体を対象にする

GitHub 組織内のすべてのリポジトリで Code Review をオンにするには、**Repositories** テーブルの組織の行で **Review runs** を設定します。これにより、Claude GitHub App がアクセスできるその組織内のすべてのリポジトリが対象になり、後から追加されるリポジトリも含まれます。支出が大幅に増える可能性があります。次のすべての条件を満たす必要があります。

* Claude に接続した GitHub アカウントが、その GitHub 組織のオーナーであること。
* 組織が github.com 上にあること。GitHub Enterprise Server インスタンスと個人の GitHub アカウントは対象外です。
* Claude 組織または Code Review に対して[月間の支出上限](/docs/ja/code-review-costs.md#limit-your-spend)が設定されていること。

組織を対象にするには、その行の **Edit** をクリックし、**Review runs** の選択肢を選んで確定します。選択肢は、[レビューを実行するタイミングを設定する](#set-when-reviews-run)の 3 つに **Off** を加えたものです。

確定すると、次の変更が適用されます。

* **対象範囲**：各リポジトリは次のプルリクエストから対象になります。Claude GitHub App がすべてのリポジトリではなく選択したリポジトリにインストールされていた場合、Claude はそれらのリポジトリをレビューします。残りも対象にするには、GitHub でアプリのリポジトリアクセスを変更してください。
* **既存の設定**：その GitHub 組織内のすべてのリポジトリに選択した設定が適用され、個別に設定していたリポジトリも含まれます。行を再度設定した場合も同様です。各リポジトリの行でオフにしたリポジトリはオフのままです。
* **その後の個別変更**：後から組織と異なる設定にしたリポジトリは、テーブルで **Custom** と表示されます。
* **レビューレベル**：組織の行には独自のレビューレベルはありません。

### Code Review をオフにする、またはリポジトリを削除する

[**Admin settings > Claude Code**](https://claude.ai/admin-settings/claude-code#code-review) の **Code review** セクションで、停止したい対象に応じたコントロールを選択します。

* **1 つのリポジトリ（一覧には残す）**：その行の **Edit** をクリックし、**Code review** をオフにします。テーブルではリポジトリが Off と表示されます。
* **1 つのリポジトリ（削除する）**：その行の **Edit** をクリックし、ダイアログ下部の **Remove repository** をクリックします。そのリポジトリでのレビューは停止し、別の Claude 組織がそのリポジトリを設定できるようになります。リポジトリの GitHub 組織が組織全体として対象になっている間は削除できないため、代わりに **Code review** スイッチをオフにしてください。
* **GitHub 組織全体**：組織の行の **Edit** をクリックし、**Off** を選択します。これにより、その組織内で 1 つずつ追加したリポジトリもオフになります。
* **すべて**：**Allow code review** をオフにします。どのリポジトリでも新しいレビューは開始されず、リポジトリの一覧は保持されるため、後で再びオンにできます。

## 関連リソース

* [Code Review のコストと使用量](/docs/ja/code-review-costs.md)：レビューレベルとレビューの実行タイミングが支出に与える影響、支出上限の設定方法、使用量の確認場所
* [プルリクエストでレビューを確認・リクエストする](/docs/ja/code-review-pull-requests.md)：開発者がプルリクエスト上で目にする内容とコメントコマンド
* [Code Review をカスタマイズする](/docs/ja/code-review-customize.md)：`REVIEW.md` と `CLAUDE.md` で Claude が指摘する内容を調整する
* [GitHub Enterprise Server](/docs/ja/github-enterprise-server.md)：設定前にセルフホストの GitHub インスタンスを接続する
