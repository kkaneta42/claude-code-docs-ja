> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# Claude Approvals と GitHub のルール

> Claude Approvals のチェックが必須レビュー、CODEOWNERS、マージキューとどのように連携するか、人を介さずにマージできるもの、ポリシーを変更できる人を確認します

[Claude Approvals](https://code.claude.com/docs/ja/approvals.md) は、評価対象の GitHub プルリクエストにチェックを追加します。このチェックは、リポジトリ内のファイルである[ポリシー](https://code.claude.com/docs/ja/approvals-policy.md)に従って、プルリクエストを誰が承認する必要があるかを報告します。このチェックがマージをブロックするのは、GitHub で必須チェックにした場合のみであり、何がマージされるかはブランチのルールによって決まります。

リポジトリを管理している場合やセキュリティをレビューしている場合は、[ポリシーを適用する](https://code.claude.com/docs/ja/approvals-setup.md#enforce-your-policy-and-require-claude-approvals)前に、ポリシーと GitHub の設定がどのように連携するかを確認してください。

* **[人によるレビューなしのマージ](#merges-without-human-review)**: 作成者以外のレビューなしでプルリクエストをマージできてしまう設定と、作成者ではない人を求めるルール
* **[必須レビューと CODEOWNERS](#required-reviews-and-codeowners)**: GitHub 独自のレビュールールが Claude の承認レビューをどのようにカウントするか、および何を設定するか
* **[自動マージとマージキュー](#auto-merge-and-merge-queues)**: 誰も操作せずにマージされ得るもの
* **[ポリシーを変更または緩和できる人](#who-can-change-or-loosen-a-policy)**: ポリシーファイルを編集できる人、チェックの必須化をやめられる人、分類器の回答を誘導できる人

## 人によるレビューなしのマージ

Approvals をオンにしていても、プルリクエストは作成者以外の誰も確認しないまま、またボットが作成した場合は誰も確認しないままマージされる可能性があります。これは、GitHub が **Claude Approvals** チェックを必須にしていない場合に起こり得ます。また、作成者以外の人がいなくてもチェックが成功する場合にも起こり得ます。たとえば、次のような場合です。

* `seats: 0`
* `seats: 1`（作成者が埋められる）
* ボットを許可する [`from` リスト](https://code.claude.com/docs/ja/approvals-policy#people-lists)
* マシンユーザー（スクリプトやエージェントが操作するユーザーアカウント）。これは[人としてカウントされる場合があります](https://code.claude.com/docs/ja/approvals-policy.md#whether-a-pull-request’s-author-counts)
* プッシュ後もシートを維持する [`reuse`](https://code.claude.com/docs/ja/approvals-policy#reuse)
* どのルールもカバーしないファイル。この場合、GitHub は neutral の結果を成功としてカウントします
* ルールの `if`、上書きの `if`、または `reuse` 内で[分類器](https://code.claude.com/docs/ja/approvals-classifiers.md)の回答を参照する条件。その回答は[プルリクエストのテキストによって誘導され得る](#classifier-answers-that-a-pull-request-can-steer)ものです

デフォルトブランチへの直接プッシュにはチェックが行われません。GitHub でデフォルトブランチへのプルリクエストを必須にしてください。

Claude の[承認レビュー](https://code.claude.com/docs/ja/approvals.md#find-claude-approvals-on-a-pull-request)は、1 件の承認を必須とする GitHub のブランチルールを満たすことができます。

### 作成者ではない人を求める

すべてのパスで **Claude Approvals** チェックが作成者ではない人を 1 人求めるようにするには、このファイルのルールを、[適用する](https://code.claude.com/docs/ja/approvals-setup.md#enforce-your-policy-and-require-claude-approvals)ルートの[ポリシーファイル](https://code.claude.com/docs/ja/approvals-policy.md)に追加します。

```yaml theme={null}
# .claude/approvals.yml
version: 1
rules:
  - purpose: "A change takes one person who isn't an author."
    paths: ["**"]
    nested: inherit
    verdict:
      claude: comments
      seats: [{ count: 1, from: [humans, "!pr/authors"] }]
    advisory: [claude/code_review]
```

このルールの各部分には、それぞれ役割があります。

| ルールの部分 | 役割 |
| :- | :- |
| `if` や `override` がない | どの分類器の回答もルールを変更しません |
| `claude: comments` | Approvals は Claude の承認を投稿しません |
| `nested: inherit` | このルールは[サブディレクトリ内のポリシーファイル](https://code.claude.com/docs/ja/approvals-policy.md#policy-files-in-subdirectories)の配下にも適用されます |
| `humans` | [マシンユーザー](https://code.claude.com/docs/ja/approvals-policy.md#whether-a-pull-request’s-author-counts)（スクリプトやエージェントが操作するユーザーアカウント）がこのシートを埋めることができます。特定のマシンユーザーを除外するには、`[humans, "!pr/authors", "!acme-ci"]` のようにそのログイン名を追加します |
| `"!pr/authors"` | プルリクエストの作成者を除外します。[フォークからのプルリクエスト](https://code.claude.com/docs/ja/approvals-pull-requests.md#pull-requests-from-forks-and-outside-contributors)では、どの承認もこのシートにカウントされません |
| `advisory` | [自動 Code Review を維持します](https://code.claude.com/docs/ja/approvals.md#keep-automatic-code-reviews) |

より多くの人を必要とするパスについては、ルールをコピーし、`paths` を絞り込んで、`count` を増やしてください。

## 必須レビューと CODEOWNERS

各 GitHub 設定がポリシーとどのように併用されるか、および何を設定するかを確認してください。

| GitHub の設定 | Approvals との連携 | 対処方法 |
| :- | :- | :- |
| 必須承認 | GitHub は Claude の承認レビューを 1 件の承認としてカウントできます。GitHub は、シートを埋めた作成者や [`@claude approve`](https://code.claude.com/docs/ja/approvals-pull-requests#comment-commands-for-approvals) コメントはカウントしません | **Claude Approvals** チェックを必須にする場合は、GitHub で必須とする承認を 1 件以下にし、それ以上の人は `seats` で求めてください。そうしないと、**Claude Approvals** チェックが成功した後もプルリクエストがブロックされたままになる可能性があります |
| CODEOWNERS | ブランチルールで Code Owner のレビューを必須にできます | ポリシーでオーナーを指定するには、そのパスの `seats` で[人のリスト](https://code.claude.com/docs/ja/approvals-policy.md#people-lists)を使用してください |
| 古い承認 | Claude は承認レビューを 1 つのコミットに対して投稿し、GitHub はそのレビューが却下されるまでカウントし続ける場合があります。Approvals は通常、次のプッシュを評価する際に GitHub にレビューの却下を求めますが、GitHub が[拒否する](https://code.claude.com/docs/ja/approvals-pull-requests.md#approvals-waits-for-people)場合があります | GitHub で承認を必須にしている場合は、**Dismiss stale pull request approvals when new commits are pushed** または **Require approval of the most recent reviewable push** をオンにしてください |

## 自動マージとマージキュー

人の承認を必要としないポリシーで GitHub の自動マージやマージキューを使用すると、誰も操作しないまま変更がマージされる可能性があります。すべてのパスでチェックが作成者ではない人を求めるようにするには、[このルールを追加](#ask-for-a-person-who-isn’t-an-author)し、**Claude Approvals** チェックを必須にしてください。

Approvals は、マージキューが作成するコミットを評価しません。

* **キューのコミット**: Approvals は通常、これらを **Stamped for merge queue** というタイトルで成功としてマークします。ただし、[observe モード](https://code.claude.com/docs/ja/approvals-pull-requests.md#approvals-in-observe-mode)でのみ評価されたプルリクエストは除きます
* **キューへの投入**: GitHub 独自のルールによって決まり、通常はプルリクエストの必須チェックが成功した後に行われます。チェックの実行中にプルリクエストがキューに入ることもあります。その後チェックが成功しなかった場合は、プルリクエストをキューから削除してください
* **observe のみされたプルリクエスト**: ポリシーの適用を開始した後は、各オープンなプルリクエストをキューに入れる前に[チェックを再実行](https://code.claude.com/docs/ja/approvals-setup.md#enforce-your-policy-and-require-claude-approvals)してください。最新のコミットがポリシーのもとで成功するまで、キュー内のそのコミットには通常チェックが行われず、チェックが必須の場合はそこで待機し続ける可能性があります
* **アプリの権限**: GitHub 組織のオーナーに、Claude GitHub App の [**Merge queues** 権限](https://code.claude.com/docs/ja/github-actions.md#github-app-permissions)を承諾するよう依頼してください。この権限がないと、キューのコミットにはチェックが行われないため、GitHub がチェックを必須にしている場合、キューのエントリは待機し続けます

## ポリシーを変更または緩和できる人

ポリシーはリポジトリ内のファイルであるため、誰がそれを変更できるかは GitHub の権限によって決まります。

| 誰が | できること |
| :- | :- |
| デフォルトブランチにマージできるすべての人 | ポリシーファイルを変更できます。ポリシーファイルは[保護されたファイル](https://code.claude.com/docs/ja/approvals-policy.md#protected-files)であり、これを変更するプルリクエストには書き込みアクセス権を持つ人が必要になる場合があります。その人はプルリクエストの作成者でもかまいません。[マシンユーザー](https://code.claude.com/docs/ja/approvals-policy.md#whether-a-pull-request’s-author-counts)は人としてカウントされます |
| GitHub リポジトリの管理者 | リポジトリ自体のブランチルールで **Claude Approvals** チェックの必須化をやめられます |
| チェックを必須にしているすべてのルールをバイパスできる人 | チェックを無視してマージできます |
| Claude 組織の [Owner ロール](https://code.claude.com/docs/ja/server-managed-settings.md#access-control) | GitHub 組織、**Edit** ダイアログに **Claude Approvals** が表示されるリポジトリ、または Claude 組織全体で [Approvals をオフにする](https://code.claude.com/docs/ja/approvals-setup.md#turn-off-approvals)ことができます |

### プルリクエストによって誘導され得る分類器の回答

Approvals は、デフォルトブランチのポリシーファイルと分類器の定義を適用します。プルリクエストの[作成者のテキスト](https://code.claude.com/docs/ja/approvals-classifiers.md#what-a-classifier-run-can-read-and-change)は、分類器の回答を誘導できます。

ルールの `if`、上書きの `if`、または `reuse` の条件が回答を参照する場合、誘導された回答によってプルリクエストに必要な要件が引き下げられる可能性があります。すべてのパスで作成者ではない人を 1 人求めるには、[このルールを追加](#ask-for-a-person-who-isn’t-an-author)してください。

## 関連リソース

* [Claude Approvals をセットアップする](https://code.claude.com/docs/ja/approvals-setup.md): ポリシーを適用し、**Claude Approvals** チェックを必須にする
* [Claude Approvals ポリシーファイルリファレンス](https://code.claude.com/docs/ja/approvals-policy.md): シート、人のリスト、保護されたファイル
* [Claude Approvals の分類器](https://code.claude.com/docs/ja/approvals-classifiers.md): 分類器の実行が読み取り、変更できるもの
