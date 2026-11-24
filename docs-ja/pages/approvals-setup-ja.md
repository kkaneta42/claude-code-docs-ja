> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# Claude Approvals をセットアップする

> GitHub リポジトリで Claude Approvals をオンにします。observe モードで開始し、ポリシーを適用し、チェックを必須にし、支出を制限し、オフにする方法を説明します

[Claude Approvals](https://code.claude.com/docs/ja/approvals.md) は、GitHub のプルリクエストに対するチェックで、まだ誰の承認が必要かを報告します。リポジトリでオンにするには、リポジトリのルートの `.claude/approvals.yml` に[ポリシーファイル](https://code.claude.com/docs/ja/approvals-policy.md)を、デフォルトブランチ上でコミットします。ファイルがデフォルトブランチに入ると、Approvals の[課金](#what-approvals-costs)が始まる可能性があります。

## 前提条件

Approvals をセットアップして適用するには、次のすべてが必要です。

* [要件を満たす](https://code.claude.com/docs/ja/approvals.md#availability) Claude 組織と、ポリシーが開始するモデル実行の支払いに充てる[使用クレジット](https://support.claude.com/en/articles/12429409-extra-usage-for-paid-claude-plans)
* リポジトリにインストールされ、[Claude 組織にリンクされた](https://code.claude.com/docs/ja/admin-setup.md#connected-github-accounts) [Claude GitHub App](https://github.com/apps/claude)
* デフォルトブランチにマージする権限
* **Claude Approvals** チェックを必須にするための、GitHub 上のリポジトリへの管理者アクセス。プライベートリポジトリの場合は、[有料の GitHub プラン](https://docs.github.com/en/get-started/learning-about-github/githubs-plans)も必要です
* このページのいずれかのポリシーを適用する前に、書き込みアクセス権を持つ 2 人のユーザー。1 人だけの場合、`.claude/` 配下の変更や、Claude のレビューが失敗したか結果を返さなかった変更では、チェックをパスできません。[各変更に 2 人を関与させる](#keep-two-people-on-each-change)ポリシーでは、どの変更でもパスできません

## 最初のポリシーを計画する

[ポリシーファイル](https://code.claude.com/docs/ja/approvals-policy.md)は、プルリクエストを誰が承認する必要があるかを Approvals に伝えます。最初のポリシーでは、Claude が承認できるかどうかを決め、それに合ったスターターポリシーをコピーします。

* **[Code Review をパスしたら Claude に承認させる](#let-claude-approve-when-code-review-passes)**: Claude のレビューをパスしたプルリクエストは、通常、他のユーザーの承認を必要としません
* **[各変更に 2 人を関与させる](#keep-two-people-on-each-change)**: プルリクエストには通常、作成者以外に 1 人のユーザーが必要で、Claude は承認しません

どちらのポリシーも observe モードで開始します。observe モードでは、**Claude Approvals** チェックがポリシーの判定内容を表示し、Claude は承認せず、チェックは[通常パスとして扱われます](https://code.claude.com/docs/ja/approvals-pull-requests.md#approvals-in-observe-mode)。

どちらのポリシーも `claude/code_review` を指定しています。これはポリシーファイルに残しておいてください。ファイルがデフォルトブランチに入ると、observe モードでも適用時でも、一致するルールがこれを指定していない場合、自動の Code Review は通常停止します。

### Code Review をパスしたら Claude に承認させる

このスターターポリシーを適用すると、Claude のレビューをパスしたプルリクエストは、`.claude/` 配下の変更を除き、通常は他のユーザーの承認を必要としません。その他のプルリクエストには、通常、[作成者以外](https://code.claude.com/docs/ja/approvals-policy.md#whether-a-pull-request’s-author-counts)に 1 人のユーザーが必要です。

このポリシーでは、最初のルールが変更に 2 人を求めます。その `override` は、`claude/code_review` が `pass` を返した場合にそれを 1 人に減らし、Claude が承認できるようにします。2 番目のルールは、`.claude/` 配下の変更に 2 人を求めます。

```yaml theme={null}
# .claude/approvals.yml
version: 1
mode: observe
rules:
  - purpose: "A change takes two people. When Claude's review passes, one is enough and Claude approves."
    paths: ["**"]
    verdict: { claude: comments, seats: 2 }
    override:
      - { if: "claude/code_review = pass", verdict: { claude: approves, seats: 1 } }
  - purpose: "A change to the review rules takes two people."
    paths: ["**/.claude/**"]
    nested: inherit
    verdict: { claude: comments, seats: 2 }
```

このポリシーはプッシュのたびに課金対象の Code Review を開始する可能性があり、observe モードも課金されます。[Code Review の設定](https://code.claude.com/docs/ja/code-review-setup.md#set-when-reviews-run)でそれより少ないレビューを指定している場合、ポリシーはそれに追加してレビューを実行します。

### 各変更に 2 人を関与させる

このスターターポリシーは、各変更に 2 人を求めます。ポリシーを適用すると、プルリクエストには通常、作成者以外に 1 人のユーザーが必要で、Claude は承認しません。

このポリシーでは、両方のルールが 2 人を求めます。最初のルールは `claude/code_review` を [`advisory`](https://code.claude.com/docs/ja/approvals-policy#advisory) の下に記載しているため、レビューは Code Review の設定に従います。

```yaml theme={null}
# .claude/approvals.yml
version: 1
mode: observe
rules:
  - purpose: "A change takes two people."
    paths: ["**"]
    verdict: { claude: comments, seats: 2 }
    advisory: [claude/code_review]
  - purpose: "A change to the review rules takes two people."
    paths: ["**/.claude/**"]
    nested: inherit
    verdict: { claude: comments, seats: 2 }
```

## observe モードで Approvals をオンにする

ポリシーファイルを単独のプルリクエストで追加し、次に 2 つ目のプルリクエストを開いて **Claude Approvals** チェックを確認します。

**1. ポリシーファイルを追加する**

リポジトリ内のブランチから作成した単独のプルリクエストで、リポジトリのルートの `.claude/approvals.yml` にポリシーを追加します。

**2. プルリクエストをマージする**

Claude が「found the policy file in this change valid」とコメントしたらマージします。ファイルが無効な場合は、**This change breaks a policy file** というタイトルの失敗したチェックが表示されます。このプルリクエスト内で[修正してください](https://code.claude.com/docs/ja/approvals-troubleshooting.md#fix-a-policy-file-that-approvals-refuses)。

**3. 別のプルリクエストを開く**

デフォルトブランチに対して、ドラフトではないプルリクエストを開きます。タイトルが **(observe mode)** で始まる **Claude Approvals** チェックが表示されます。

何も表示されない場合は、[No Claude Approvals check appeared](https://code.claude.com/docs/ja/approvals-troubleshooting.md#no-claude-approvals-check-appeared) を参照してください。

## ポリシーを適用して Claude Approvals を必須にする

observe モードで表示される **Claude Approvals** チェックのタイトルがレビュアーの判断と一致するようになったら、ポリシーを適用します。それ以降、チェックはマージをブロックできるようになり、ポリシーが許可する場合は [Claude が承認できます](https://code.claude.com/docs/ja/approvals-github-rules.md#merges-without-human-review)。

### 保護するファイルとブランチを決める

[ポリシーを observe モードから適用に切り替える](#switch-from-observe-mode-to-enforcement)前に、どのファイルにユーザーの承認が必要か、チェックがどのブランチを制御するか、GitHub の必須承認数をいつ変更するかを決めます。

* **ファイル**: Claude の検出結果にかかわらずユーザーの承認が必要なファイルを決め、[このルール](https://code.claude.com/docs/ja/approvals-github-rules.md#ask-for-a-person-who-isn’t-an-author)をコピーしてその `paths` を絞り込みます
* **ブランチ**: 適用されたポリシーはデフォルトブランチ以外のブランチへのプルリクエストも対象にするため、**Claude Approvals** チェックでマージを制御すべき各ブランチを列挙します。それらのブランチでは、対象ファイルを含まないプルリクエストにはチェックが付かないため、必須チェックは待機状態になります
* **GitHub の必須承認数**: [GitHub が要求する承認数の変更](https://code.claude.com/docs/ja/approvals-github-rules.md#required-reviews-and-codeowners)は、切り替えの最後のステップの後にのみ行います

### observe モードから適用に切り替える

ポリシーファイルの [`mode`](https://code.claude.com/docs/ja/approvals-policy#top-level-keys) は次のいずれかです。

* **`observe`**: **Claude Approvals** チェックがポリシーの判定内容を表示し、Claude は承認せず、チェックは[通常パスとして扱われます](https://code.claude.com/docs/ja/approvals-pull-requests.md#approvals-in-observe-mode)
* **`enforce`**: チェックはマージをブロックでき、ポリシーが許可する場合は Claude が承認できます。これがデフォルトのため、`mode` 行のないポリシーファイルは適用されます

ポリシーを適用するには、次の手順に従います。最初のステップの後、開いているプルリクエストでは、Approvals を再実行するまで、GitHub がパスとして扱うチェックが残る可能性があります。ステップ 2 で Approvals を再実行するまで、開いているプルリクエストをマージキューに入れないでください。

**1. mode: observe 行を削除する**

`mode: observe` を削除し、その変更をマージします。

**2. 開いているプルリクエストで Approvals を再実行する**

マージの 5 分後に、チェックのタイトルが **(observe mode)** または **Observe mode ended** で始まる各プルリクエストに `@claude approvals rerun` とコメントします。フォークからのプルリクエストでは、[先に変更内容を確認し、最新コミットの完全な SHA を追加してください](https://code.claude.com/docs/ja/approvals-pull-requests.md#pull-requests-from-forks-and-outside-contributors)。

**3. GitHub で Claude Approvals を必須にする**

デフォルトブランチと列挙した各ブランチについて、[ステータスチェックのパスを必須にし](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-protected-branches/about-protected-branches#require-status-checks-before-merging)、**Claude Approvals** を追加します。そのソースとして、チェックを報告した Claude アプリを選択します。

**4. Approvals がマージをブロックすることを確認する**

`.claude/` 配下のファイルを変更するプルリクエストを開きます。チェックが完了すると、タイトルは **Waiting on human review from any person (1/2)** となり、GitHub のマージボックスにはこのチェックが必須として表示されます。

再実行しなかったプルリクエストの一部は後で Approvals によって評価され、[課金対象の実行](#what-approvals-costs)が開始される可能性があります。

### GitHub が Claude Approvals に対して受け入れるソースを設定する

必須チェックのソースを Claude アプリに設定します。**any source** の場合、GitHub は他の場所からの **Claude Approvals** という名前のチェックも受け入れます。GitHub の API を通じてソースを設定するには、Claude アプリの ID `1236702` を、ルールセットでは `integration_id` に、ブランチ保護ルールでは `app_id` に指定します。

## Approvals の支出を管理する

Approvals は、ポリシーが開始するモデル実行に対して組織の使用クレジットを課金し、observe モードも課金されます。課金は、[使用クレジットがオフになっている間も開始され、継続します](https://code.claude.com/docs/ja/claude-ship.md#how-each-claude-ship-agent-is-billed)。どのポリシーファイルからも課金が開始されないようにするには、Owner が組織全体で [Approvals をオフにする](#turn-off-approvals)ことができます。

### Approvals のコスト

`if` 条件に `claude/code_review` を含むポリシーは、プルリクエストが開かれたときとプッシュのたびに、[課金対象の Code Review](https://code.claude.com/docs/ja/code-review-costs.md) を開始する可能性があります。これらのレビューを停止するには、条件から `advisory` に移動します。`claude/code_review` が [`level`](https://code.claude.com/docs/ja/approvals-classifiers#read-a-classifier’s-answer-from-a-rule) なしで `advisory` の下にのみある場合、レビューは Code Review の設定に従います。

ルールは他の[分類器](https://code.claude.com/docs/ja/approvals-classifiers.md)を読み取ることもできます。`claude/diff` とカスタム分類器では、[モデルを呼び出す実行](https://code.claude.com/docs/ja/approvals-classifiers.md#what-a-classifier-run-costs)ごとに課金されます。カスタム分類器の各実行を制限するには、その [`budget`](https://code.claude.com/docs/ja/approvals-classifiers#budget) を設定します。

### ポリシーのコストを制限する

ポリシーが開始する Code Review と分類器の実行に対して組織が支払う金額に上限を設けるには、支出制限を設定します。これらの制限はいずれも [**Organization settings > Usage**](https://claude.ai/admin-settings/usage) で設定でき、Owner ロールが必要です。

* **組織の使用クレジットの支出制限**: Approvals を対象とします
* **Code Review の支出制限**: ポリシーによるレビューと Code Review のその他のレビューを合わせて対象とします。**Services** の下で **Claude Code Review** 行のメニューを開き、**Edit spend limit** を選択します
* **分類器の実行の支出制限**: **Services** の下で Approvals 行のメニューを開き、**Edit spend limit** を選択します。この行は表示された時点では制限がありません

そのページでは、**Services** の下の **Claude Code Review** 行が制限なしで開始される場合があります。

* **行の制限欄にダッシュが表示されている**: ポリシーによる最初の課金対象レビューが開始されたときに、月間制限が自動的に設定されます。金額が表示されたら変更してください
* **ポリシーより前に Code Review がオンになっていた**: 設定するまで、行には制限がありません

リセラーが組織に請求している場合は、リセラーに制限を依頼してください。

Code Review の制限に達すると、Claude のレビューを必要とするチェックがパスしなくなる可能性があります。制限を引き上げるか、[次の請求期間](https://code.claude.com/docs/ja/code-review-costs.md#limit-your-spend)まで待ってください。

## Approvals をオフにする

Approvals は、1 つのリポジトリ、GitHub 組織、または Claude 組織全体でオフにできます。

> [!WARNING]
>
> Claude GitHub App の一時停止やアンインストール、または GitHub 組織のリンク解除は、必ず Approvals をオフにした後に行ってください。先に行うと、新しいコミットにチェックが付かないため、必須チェックがマージをブロックする可能性があります。また、開いているプルリクエストに残っている Claude の承認レビューを、GitHub が引き続きカウントする可能性があります。

次の順序で行います。

1. **GitHub が古い承認をどう扱うかを確認する**: GitHub が承認を要求している場合は、[**Dismiss stale pull request approvals when new commits are pushed**](https://code.claude.com/docs/ja/approvals-github-rules.md#required-reviews-and-codeowners) をオンにします。そうしないと、最後のステップでレビューを却下するまで、新しいプッシュの後も GitHub が Claude の承認レビューをカウントし続ける可能性があります。
2. **チェックの必須指定を解除する**: GitHub で、各ブランチ保護ルールとルールセットの必須チェックから **Claude Approvals** を削除します。
3. **Approvals をオフにする**: 目的のスコープに応じて[方法を選択します](#ways-to-turn-off-approvals)。
4. **Claude のレビューを却下する**: Claude が承認した開いているプルリクエストで、GitHub 上でそのレビューを却下します。

Approvals をオフにせずにチェックによるブロックを止めるには、まずデフォルトブランチ以外のブランチでチェックの必須指定を解除します。次に、すべてのポリシーファイルに `mode: observe` を記述します。これにより、チェックは通常ブロックしなくなりますが、分類器は引き続き実行され、課金されます。それらの他のブランチへのプルリクエストには、ポリシーファイルまたは分類器ファイルを変更する場合を除き、チェックは付きません。

### Approvals をオフにする方法

Approvals をオフにするには、次の表で目的のスコープを見つけます。

| スコープ | Approvals をオフにする方法 |
| :- | :- |
| 1 つのリポジトリ（Owner なし） | デフォルトブランチからすべてのポリシーファイルを削除します |
| GitHub 組織、または **Edit** ダイアログに **Claude Approvals** が表示されるリポジトリ | [Owner ロール](https://code.claude.com/docs/ja/server-managed-settings.md#access-control)で [**Organization settings > Claude Ship**](https://claude.ai/admin-settings/claude-ship) に移動し、その行の **Edit** をクリックして、**Claude Approvals** をオフにします |
| Claude 組織全体 | Owner ロールで [**Organization settings > Claude Ship**](https://claude.ai/admin-settings/claude-ship) に移動し、**Approve** 行の **Block globally** をクリックします。再度オンにするには、同じ行の **Allow policy files** をクリックします |

Claude 組織全体でオフにしたものは、後でポリシーファイルがマージされてもオフのままです。Code Review もオフにする場合は、先に Approvals をオフにしてください。Code Review がオフの場合でも、ポリシーが課金対象のレビューを開始する可能性があるためです。

## 関連リソース

* [Claude Approvals ポリシーファイルリファレンス](https://code.claude.com/docs/ja/approvals-policy.md): キーとポリシーの例
* [Approvals と GitHub のルール](https://code.claude.com/docs/ja/approvals-github-rules.md): ユーザーの承認なしでマージできるもの、およびポリシーを変更できるユーザー
* [Claude Approvals のトラブルシューティング](https://code.claude.com/docs/ja/approvals-troubleshooting.md): チェックが表示されない場合や、チェックがポリシーファイルを拒否する場合
