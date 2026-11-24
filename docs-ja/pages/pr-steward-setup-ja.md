> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# PR Steward をセットアップする

> Claude の組織で PR Steward をオンにします。レビューの必須化、リポジトリの追加、支出上限の設定を行い、開始するタイミングと対象の作成者を選択します

[PR Steward](https://code.claude.com/docs/ja/pr-steward.md) をセットアップするには、Claude の組織でオンにしてから、リポジトリごとにオンにします。[Owner ロール](https://code.claude.com/docs/ja/server-managed-settings.md#access-control)が必要です。

リポジトリでオンにすると、PR Steward はそのリポジトリのプルリクエストにコミットをプッシュしてレビューのフィードバックに対応し、失敗しているチェックの修正やマージコンフリクトの解消を試みます。PR Steward は自動で開始するか、誰かが依頼したときに開始します。どちらにするかは[リポジトリごとに選択](#choose-when-pr-steward-starts-in-each-repository)できます。

## 前提条件

組織が [PR Steward の対象となっている](https://code.claude.com/docs/ja/pr-steward.md#availability)ことを確認してください。

[claude.ai](https://claude.ai/admin-settings) で管理する Claude の組織では、次のものが必要です。

* [Owner ロール](https://code.claude.com/docs/ja/server-managed-settings.md#access-control)
* PR Steward の作業の支払いに使われる[使用クレジット](https://support.claude.com/en/articles/12429409-extra-usage-for-paid-claude-plans)
* [**Organization settings > Connectors**](https://claude.ai/admin-settings/connectors) でオンにした GitHub コネクタ。これをオンにすると、組織のメンバーが自分の [GitHub アカウントを Claude に接続](https://code.claude.com/docs/ja/web-quickstart.md#connect-github)できるようになります

GitHub では、次のアクセス権が必要です。または、これを持っている人の協力が必要です。

* GitHub 組織の Owner。[Claude GitHub App](https://github.com/apps/claude) をインストールし、[Claude の組織にリンク](https://code.claude.com/docs/ja/admin-setup.md#connected-github-accounts)するために必要です
* リポジトリの Admin。ブランチルールを追加するために必要です。プライベートリポジトリでは、[有料の GitHub プラン](https://docs.github.com/en/get-started/learning-about-github/githubs-plans)も必要です
* Claude に接続する GitHub アカウントからの、リポジトリへのプッシュアクセス

## ブランチルールでレビューを必須にする

PR Steward をオンにする前に、GitHub で次のルールを追加してください。

**1. 承認を必須にする**

デフォルトブランチに、少なくとも 1 件の承認があるプルリクエストを必須とするルールセットのルールを追加します。

**2. プッシュ後に新しい承認を必須にする**

そのルールで、新しいコミットがプッシュされたときに古い承認を却下するか、最新のプッシュの承認を必須にします。

**3. ルールセットのバイパスリストを確認する**

Claude GitHub App をルールセットのバイパスリストに含めないでください。GitHub Enterprise Server では、[組織が作成したアプリ](https://code.claude.com/docs/ja/github-enterprise-server.md#admin-setup)が対象です。PR Steward が[セルフホスト環境](#run-pr-steward-in-a-self-hosted-environment)で実行される場合は、ランナーの git ID もバイパスリストに含めないでください。

**4. ほかのブランチを保護する**

PR Steward にプッシュさせたくないほかのブランチにもルールを追加し、フォースプッシュを許可したくない場所ではブロックしてください。

> [!NOTE]
>
> [Claude Approvals ポリシーで Claude による承認が許可されている](https://code.claude.com/docs/ja/approvals-github-rules.md#merges-without-human-review)場合、Claude のレビューはステップ 1 の承認としてカウントされることがあります。[セルフホスト環境](#run-pr-steward-in-a-self-hosted-environment)のセッションからの承認もカウントされることがあります。

## PR Steward をオンにしてリポジトリを追加する

[**Organization settings > Claude Ship**](https://claude.ai/admin-settings/claude-ship) から始めます。

このページの **Repositories** テーブルには、各リポジトリとその **Steward** 設定が一覧表示されます。

![Claude Ship ページの Repositories テーブル。Add ボタンと、Steward 設定がそれぞれ Manual、Off、On の 3 つのリポジトリが表示されています。各行には Edit ボタンがあります。](https://mintcdn.com/claude-code/cMjxXVBUSLLh9iVu/images/pr-steward-setup-repositories.png?fit=max\&auto=format\&n=cMjxXVBUSLLh9iVu\&q=85\&s=a76bbd05275c5a96053cbbe7e6f1a547)

> [!WARNING]
>
> リポジトリを追加すると、そのリポジトリで [Code Review](https://code.claude.com/docs/ja/code-review-setup.md) が開始されることがあり、これは課金対象です。
>
> * **まだリポジトリが 1 つも表示されていない場合**：追加するリポジトリで Claude が何を行うかを尋ねるダイアログが表示され、デフォルトで **Code review** が選択されています。ダイアログで **Steward** を選択すると、支出上限を設定する前に、組織とそれらのリポジトリで PR Steward がオンになります。
> * **ほかのリポジトリがすでに表示されている場合**：ダイアログは表示されず、新しいリポジトリはデフォルトでプッシュのたびにレビューを行うように設定されます。
>
> これを変更するには、そのリポジトリで[レビューを実行するタイミングを設定する](https://code.claude.com/docs/ja/code-review-setup.md#set-when-reviews-run)か、[Code Review をオフにします](https://code.claude.com/docs/ja/code-review-setup.md#turn-off-code-review-or-remove-a-repository)。

**1. リポジトリを追加する**

リポジトリがすでに **Repositories** に表示されている場合は、このステップをスキップしてください。それ以外の場合は、**Add** をクリックし、求められたら GitHub アカウントを接続して、リポジトリを選択します。その後、Claude がそのリポジトリで何を行うかを尋ねるダイアログが表示された場合は、**Not now** をクリックします。これでリポジトリは一覧に残ります。

**2. PR Steward の対象とする作成者を設定する**

**Steward** スイッチの下にある **Runs for** で、PR Steward が誰のプルリクエストで作業するかを設定します。**All eligible authors** を選択するか、少人数で試験運用する場合は **Listed users only** を選択して、対象者の GitHub ユーザー名を入力します。

GitHub Enterprise Server では、**All eligible authors** を選択してください。GitHub Enterprise Server では、リストを指定すると PR Steward が開始されないためです。

**3. 組織で PR Steward をオンにする**

**Steward** スイッチをクリックし、**Turn on** をクリックします。

**4. PR Steward の月間上限を設定する**

[**Organization settings > Usage**](https://claude.ai/admin-settings/usage) に移動します。**Services** の **PR Steward** の行で上限を設定します。上限を設定するまで、PR Steward 独自の支出上限はありません。

**5. リポジトリで PR Steward をオンにする**

**Claude Ship** ページで、リポジトリの横にある **Edit** をクリックします。**Steward** を [**Manual (@claude steward)**](#choose-when-pr-steward-starts-in-each-repository) に設定します。**Steward spend cap** の横にある **Change** をクリックし、上限額を米ドルで入力します。[上限額の仕組み](#set-pr-steward’s-spend-limits)を参照してください。

**6. PR Steward をテストする**

書き込みアクセス権があり、かつ **Runs for** の対象となっているアカウントからプルリクエストを作成します。`@claude steward` とコメントします。`claude-pr-steward-watching` ラベルと、**Claude PR Steward** という見出しのコメントが表示されます。

これらが表示されない場合は、[PR Steward のトラブルシューティング](https://code.claude.com/docs/ja/pr-steward-troubleshooting.md)を参照してください。

## PR Steward をより多くのプルリクエストに展開する

PR Steward の修正がレビュアーの行う修正と一致するようになったら、リポジトリを **On** に設定します。後から追加する各リポジトリでは、まずそのリポジトリで[レビューを必須に](#require-reviews-with-branch-rules)してください。その後、[PR Steward をオンにしてリポジトリを追加する](#turn-on-pr-steward-and-add-repositories)の手順のうち、リポジトリの追加、そのリポジトリでの PR Steward のオン、PR Steward のテストを繰り返します。PR Steward は最大 256 個のリポジトリでオンにできます。

### 各リポジトリで PR Steward が開始するタイミングを選択する

**Claude Ship** ページで、リポジトリの横にある **Edit** をクリックし、**Steward** メニューを開きます。

![リポジトリの Edit ダイアログにある Steward メニュー。Off、On、On (including drafts)、Manual (@claude steward) が表示され、Manual (@claude steward) が選択されている。](https://mintcdn.com/claude-code/cMjxXVBUSLLh9iVu/images/pr-steward-setup-edit-options-light.png?fit=max\&auto=format\&n=cMjxXVBUSLLh9iVu\&q=85\&s=6dd7aaf84aa00b6893b9e7533b1089d7)

PR Steward を開始するタイミングを選択します。

| オプション | PR Steward が開始するタイミング |
| :- | :- |
| **Manual (@claude steward)** | 書き込みアクセス権を持つ人が `@claude steward` とコメントするか、`claude-pr-steward-watching` ラベルを追加したとき |
| **On** | [PR Steward がスキップしない](https://code.claude.com/docs/ja/pr-steward.md#when-pr-steward-starts)プルリクエストが作成されたとき、再オープンされたとき、またはレビュー準備完了としてマークされたとき。また、まだ開始していないオープン中のプルリクエストへの次回のプッシュ時 |
| **On (including drafts)** | **On** と同じで、ドラフトのプルリクエストも対象 |
| **Off** | このリポジトリでは PR Steward は開始しない |

**Manual** のリポジトリでは、コメントまたはラベルによって[ドラフト](https://code.claude.com/docs/ja/pr-steward-pull-requests.md#choose-what-pr-steward-works-on)で PR Steward を開始できます。[PR Steward がスキップする](https://code.claude.com/docs/ja/pr-steward.md#when-pr-steward-starts)その他のプルリクエストでは、コメントやラベルで PR Steward は開始しません。

また、[**Act on its own**](https://code.claude.com/docs/ja/pr-steward-pull-requests.md#turn-off-or-limit-pr-steward-on-all-your-pull-requests) を選択した開発者のプルリクエストでも、そのリポジトリで PR Steward が開始します。

### PR Steward の対象とする作成者を制限する

作成者を対象外にするには、**Steward** スイッチの下にある **Excluded users** にその人の GitHub ユーザー名を追加します。

## PR Steward の支出を管理する

[使用クレジットがオフになっている間も課金は継続されます](https://code.claude.com/docs/ja/claude-ship.md#how-each-claude-ship-agent-is-billed)。

### PR Steward の支出額を確認する

マージされたプルリクエストあたりの平均を確認するには、リポジトリの **Edit** ダイアログを開きます。過去 30 日間の組織全体の合計を確認するには、[claude.ai/analytics/pr-steward](https://claude.ai/analytics/pr-steward) に移動します。

### PR Steward の支出上限を設定する

月間上限は、[**Organization settings > Usage**](https://claude.ai/admin-settings/usage) の **Services** にある **PR Steward** の行で変更します。この行は、初めて PR Steward をオンにした後に表示されます。支出上限額は、リポジトリの **Edit** ダイアログで変更します。PR Steward が上限に達したら、プルリクエスト上の PR Steward のコメントを確認してください。

* **PR Steward の月間上限、または組織の使用クレジット上限**：PR Steward は一時停止します。使用クレジットで再び支払えるようになると、次回のプッシュまたはコメント時に再開します
* **支出上限額**：PR Steward はそのプルリクエストでの作業を停止します。停止する前に支出が上限額を超えることがあります。書き込みアクセス権を持つ人が、上限額を全額リセットした状態で再び開始できます。PR Steward が 1 つのプルリクエストで約 1 週間を超えて作業すると、新しい[クラウドセッション](https://code.claude.com/docs/ja/claude-code-on-the-web.md)を開始することがあり、その場合は上限額が再び全額適用されます

支出できる使用クレジットが残っていない場合、PR Steward は開始せず、**Claude Ship** ページに **Steward cannot start on pull requests** と表示されます。**Usage** ページで使用クレジットを追加するか、上限を引き上げてください。

## PR Steward のビルド環境をセットアップする

コードのビルドとテストにより多くのものが必要な場合は、PR Steward 用の環境を選択します。

### PR Steward を実行する環境を選択する

セットアップスクリプト、環境変数、または異なるネットワークアクセスを追加するには、[組織共有環境](https://code.claude.com/docs/ja/cloud-environments.md#organization-shared-environments)を使用します。**Claude Ship** ページで、**Where it runs** の下にある **Default environment** を選択します。1 つのリポジトリでこれを上書きするには、**Edit** ダイアログで **Environment** の横にある **Change** をクリックします。

どちらも設定されていない場合、PR Steward は組織の[デフォルト環境](https://code.claude.com/docs/ja/cloud-environments.md#the-default-environment)を使用できます。デフォルト環境もない場合は、セットアップスクリプトも環境変数もない Anthropic ホスト環境で実行されます。

### セルフホスト環境で PR Steward を実行する

PR Steward を実行する環境として、[セルフホスト環境](https://code.claude.com/docs/ja/self-hosted-environments)を選択できます。[承認とマージに関する制限](https://code.claude.com/docs/ja/pr-steward-security.md#limits-on-approvals-and-merges)は、Anthropic ホストのセッションについてのみ記載されています。[Anthropic 管理の git](https://code.claude.com/docs/ja/self-hosted-environments-deploy.md#use-the-anthropic-git-proxy) を使用していないランナーでは、PR Steward はランナー自身の git 認証情報でプッシュします。

> [!WARNING]
>
> セルフホスト環境では、Claude は[セッションが読み取れる任意の GitHub 認証情報](https://code.claude.com/docs/ja/self-hosted-environments-deploy.md#harden-your-deployment)を使用して GitHub に直接アクセスできます。この方法で行われた承認を Anthropic のサービスが拒否することはできません。GitHub は、その承認を必須の承認数にカウントすることがあります。

セルフホスト環境では、PR Steward はランナーからも、ランナーがチェックアウトしたプルリクエストからも、`CLAUDE.md` やルールファイルを読み込みません。[管理された `CLAUDE.md`](https://code.claude.com/docs/ja/memory#deploy-organization-wide-claude-md) も読み込みません。PR Steward に従わせたい内容は、[リポジトリのデフォルトブランチ](https://code.claude.com/docs/ja/pr-steward-pull-requests.md#save-pr-steward-instructions-for-everyone-in-a-repository)に配置してください。

### Claude Tag バンドルから PR Steward に認証情報を渡す

プライベートパッケージレジストリのログインなどの認証情報を PR Steward に渡すには、その認証情報を [Claude Tag バンドル](https://claude.com/docs/claude-tag/concepts/glossary#bundle)に保存し、PR Steward に対してそのバンドルをオンにします。PR Steward は、Anthropic ホスト環境（[セルフホスト環境](#run-pr-steward-in-a-self-hosted-environment)以外のすべての環境）で実行される場合にバンドルを使用できます。

バンドルに認証情報を追加するには、[Claude Tag をセットアップ](https://claude.com/docs/claude-tag/admins/setup-overview)し、[バンドルを作成](https://claude.com/docs/claude-tag/admins/add-connections#create-a-bundle)します。

> [!WARNING]
>
> PR Steward は無人で動作し、[他の人が書いたプルリクエストのテキストを読み取る](https://code.claude.com/docs/ja/pr-steward-security.md#pr-steward’s-session-environment)ため、そのテキストによって認証情報の使い方が誘導される可能性があります。[各認証情報を制限](https://claude.com/docs/claude-tag/admins/add-connections#limit-access-to-specific-resources)し、コードのビルドとテストに必要なホストと権限のみに絞ってください。

PR Steward に対してバンドルをオンにするには:

**1. バンドルを開く**

[**Organization settings > Claude Tag**](https://claude.ai/admin-settings/claude-tag) に移動し、**Bundles** タブを選択して、バンドルを開きます。

**2. バンドルで PR Steward をオンにする**

**Where it applies** で、**PR Steward** 行のスイッチをオンにし、**Save changes** をクリックします。

これで、組織全体で PR Steward に対してバンドルがオンになります。このスイッチはバンドル内のすべての認証情報に適用されます。

PR Steward セッション内のインストールやテストが、次のテキストで始まる 403 で失敗することがあります:

```text wrap theme={null}
denied by policy: this host's bundle of logins and rules isn't turned on for PR Steward
```

PR Steward がコードのビルドやテストにそのホストを必要とする場合は、そのホストの認証情報を保持しているバンドルで **PR Steward** スイッチをオンにしてください。2 つのスイッチは別々であるため、**Everywhere** がオンになっているバンドルでもこの操作が必要になることがあります。バンドルに PR Steward が必要とする以上のものが含まれている場合は、その認証情報のみを含む[バンドルを作成](https://claude.com/docs/claude-tag/admins/add-connections#create-a-bundle)し、そのバンドルで PR Steward をオンにしてください。

## PR Steward をオフにする

PR Steward をオフにすると、新たな開始は行われなくなります。ただし、すでに `claude-pr-steward-watching` ラベルが付いているプルリクエストでは、しばらくの間作業を続けます。1 人の作成者についてオフにした場合、その期間は約 1 週間になることがあります。

それらのプルリクエストでも PR Steward を停止するには、まず変更の対象となるプルリクエストからラベルを削除してください。

その後、**Claude Ship** ページで PR Steward をオフにします。

| PR Steward をオフにする対象 | 操作 |
| :- | :- |
| 組織 | **Steward** スイッチをクリックする |
| 1 つのリポジトリ | リポジトリの横にある **Edit** をクリックし、**Steward** を **Off** に設定する |
| 1 人の作成者 | その人の GitHub ユーザー名を **Excluded users** に追加する |

先にオフにした場合は、GitHub 組織が複数の Claude 組織にリンクされている場合を除き、後からラベルを削除して PR Steward を停止してください。

## 次のステップ

* [PR Steward を使って作業する](https://code.claude.com/docs/ja/pr-steward-pull-requests.md)
* [PR Steward がアクセスできる範囲](https://code.claude.com/docs/ja/pr-steward-security.md)
