> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# Claude Approvals

> ポリシーファイルとプルリクエストのチェックを使って、GitHub リポジトリ内のパスに必要な人数と、Claude が承認できる場所を設定します

Claude Approvals は、GitHub のプルリクエストに対するチェックで、まだ誰の承認が必要かを報告します。Claude Approvals は[ポリシー](https://code.claude.com/docs/ja/approvals-policy.md)に従います。ポリシーとはリポジトリ内のファイルで、あるパスへの変更を何人が承認する必要があるか、また Claude がどこで承認できるかを設定できます。

> [!TIP]
>
> リポジトリで Claude Approvals をオンにするには、[Claude Approvals を設定する](https://code.claude.com/docs/ja/approvals-setup.md)の手順に従ってください。

プルリクエストを評価するために、Approvals はポリシーを読み取り、適用されるルールを見つけ、承認の数を数えます。

![Claude Approvals がプルリクエストを評価する仕組みの図。Approvals はデフォルトブランチ上のポリシーを読み取り、適用されるルールを見つけて最も厳しいものを採用し、承認の数を数えます。プルリクエストにチェックとコメントが表示されます。ポリシーが許可する場合は、承認レビューも表示されます。](https://mintcdn.com/claude-code/sMH7RDpTvyWlAkrg/images/approvals-flow.svg?fit=max\&auto=format\&n=sMH7RDpTvyWlAkrg\&q=85\&s=29bc7cd0a0a49c1986cab5afdf57ca3b)

Approvals を使うと、変更を承認する必要がある人数を設定できます。リスクの高い変更にはより多くの人数を、日常的な変更にはより少ない人数を求めることができます。たとえば、請求関連のコードには 2 人を必要とし、テストフィクスチャには [Code Review](https://code.claude.com/docs/ja/code-review.md) をパスした後に 1 人を必要とする、といった設定ができます。

> [!NOTE]
>
> Claude Code セッションでの権限プロンプトについては、[権限を設定する](https://code.claude.com/docs/ja/permissions.md)を参照してください。

## プルリクエスト上で Claude Approvals を見つける

Approvals は、評価するプルリクエストに **Claude Approvals** という名前のチェックを追加します。チェックのタイトルには、まだ何が必要かが示されます（例：**Waiting on human review from any person (1/2)**）。タイトルが **(observe mode)** で始まる場合は、チェックの実行時にポリシーが適用されていなかったことを意味します。[observe モード](#set-up-claude-approvals)では、チェックはポリシーがどのように判定するかを示します。

Claude は理由を記載したコメントも投稿します。ポリシーが許可している場合、Claude は承認レビューを投稿できます。よく表示されるタイトルとそれぞれへの対処方法については、[承認ステータスと次に行うことを確認する](https://code.claude.com/docs/ja/approvals-pull-requests.md#find-your-approval-status-and-what-to-do-next)を参照してください。プルリクエストにチェックがない場合は、[Claude Approvals のチェックが表示されない](https://code.claude.com/docs/ja/approvals-troubleshooting.md#no-claude-approvals-check-appeared)を参照してください。

## ポリシーの例

ポリシーは、`.claude/approvals.yml` にルールのリストとして記述します。

次のポリシーにはルールが 1 つあり、すべての変更に 2 人を求めます。

```yaml theme={null}
# .claude/approvals.yml
version: 1
mode: observe
rules:
  - purpose: "A change takes two people, and Claude doesn't approve."
    paths: ["**"]
    verdict: { claude: comments, seats: 2 }
    advisory: [claude/code_review]
```

ポリシーの各部分は、それぞれ 1 つのことを設定します。

* **`mode: observe`**：ポリシーを [observe モード](#set-up-claude-approvals)で開始します
* **`purpose`**：ルールが存在する理由を記述します
* **`paths`**：ルールが一致するファイルを指定します。ここではすべてのファイルです
* **`seats: 2`**：2 人を求めます。そのうち 1 人は[作成者でもかまいません](https://code.claude.com/docs/ja/approvals-policy.md#whether-a-pull-request’s-author-counts)
* **`claude: comments`**：Claude が承認しないことを意味します
* **`advisory`**：[自動の Code Review を維持します](#keep-automatic-code-reviews)

ルールには条件を付けることもできます。条件では、プルリクエストに関する事実や分類器の回答を読み取れます。

* **プルリクエストに関する[事実](https://code.claude.com/docs/ja/approvals-policy.md#if)**：変更された行数、誰がプルリクエストを作成したか、どのブランチを対象としているかなど
* **[分類器](https://code.claude.com/docs/ja/approvals-classifiers.md)の回答**：変更のリスクの高さなどの問いに対するモデルの判断

条件では CI の結果を読み取れないため、CI は GitHub で独立した必須チェックとして維持してください。

## Approvals をオンにする前に

リポジトリにポリシーファイルを追加する前に、組織が要件を満たしているか、また誰が Approvals をオンまたはオフにできるかを確認してください。その上で、Approvals によってマージ、Code Review、請求に関して何が変わるかを確認してください。

### 利用可能性

Approvals は、[Team および Enterprise](https://code.claude.com/docs/ja/feature-availability.md#features-that-require-a-claude-subscription) プランの Claude 組織向けに、[Claude Ship](https://code.claude.com/docs/ja/claude-ship.md) の一部としてパブリックベータで提供されています。GitHub Enterprise Cloud を含む github.com で動作します。コンプライアンス設定によって利用できるユーザーが制限されます。

* **利用不可**：[Zero Data Retention](https://code.claude.com/docs/ja/zero-data-retention.md) が有効な場合、[HIPAA 設定](https://code.claude.com/docs/ja/hipaa-setup.md)が適用されている場合、または顧客管理の暗号鍵（CMEK）を使用している場合
* **Approvals を開始できない**：FERPA または Access Transparency の設定がある場合

### Approvals をオンまたはオフにできるユーザー

[前提条件](https://code.claude.com/docs/ja/approvals-setup.md#prerequisites)を満たしていれば、デフォルトブランチにポリシーファイルをマージできるユーザーであれば誰でも Approvals をオンにできます。Claude 組織の Owner は組織全体で [Approvals をオフにする](https://code.claude.com/docs/ja/approvals-setup.md#turn-off-approvals)ことができ、その場合はポリシーファイルがマージされてもオフのままになります。

### 人によるレビューなしのマージ

プルリクエストは、作成者以外の誰も確認していない状態でマージされることがあります。次のようなケースについて、ポリシーと GitHub のルールを確認してください。

* **チェックが必須になっていない**：**Claude Approvals** チェックがマージをブロックするのは、GitHub でそれを必須チェックにしている場合のみです。また、observe モードでは通常ブロックしません
* **ポリシーが他の人を求めていない**：作成者も 1 席を埋められるため、`seats: 1` では他の誰も確認する必要がありません。`seats: 0` では、ボットが作成したプルリクエストは、誰も確認していなくてもマージできます
* **GitHub が Claude の承認をカウントする**：GitHub のブランチルールで 1 件の承認が必須とされている場合、Claude の承認レビューがその承認になり得ます
* **Claude がレビューなしで承認する**：`claude: approves` を指定したルールはそれ自体では Code Review を開始しないため、Claude は何もレビューしていない変更を承認できます。先にレビューを行うには、[Code Review がパスした場合にのみ Claude に承認させます](https://code.claude.com/docs/ja/approvals-setup.md#let-claude-approve-when-code-review-passes)

その他のケースや、作成者ではない人を求めるルールについては、[人によるレビューなしのマージ](https://code.claude.com/docs/ja/approvals-github-rules.md#merges-without-human-review)を参照してください。

### 自動の Code Review を維持する

Claude Ship のもう 1 つのエージェントである [Code Review](https://code.claude.com/docs/ja/code-review.md) は、各プルリクエストを自動的にレビューできます。ポリシーファイルを追加すると、これらのレビューが停止することがあります。プルリクエストが変更するすべてのファイルがポリシーファイルの対象範囲にある場合、それらのファイルに対するルールが `claude/code_review` を指定している場合を除き、自動レビューは通常停止します。これは [observe モード](#set-up-claude-approvals)でも、ポリシーが適用されている場合でも同じです。

自動レビューを維持するには、[ポリシーの例](#example-policy)が `advisory` の下で行っているように、[ルールに `claude/code_review` を記載します](https://code.claude.com/docs/ja/approvals-policy#advisory)。

### Approvals の請求

Approvals は、ポリシーによって開始される Code Review と分類器の実行について、トークン単位で組織の[使用クレジット](https://support.claude.com/en/articles/12429409-extra-usage-for-paid-claude-plans)に課金します。[課金が発生する条件](https://code.claude.com/docs/ja/approvals-setup.md#what-approvals-costs)を参照してください。

## Claude Approvals を設定する

Approvals を設定するには、ポリシーを observe モードで開始します。observe モードでは、**Claude Approvals** チェックがポリシーがどのように判定するかを示します。observe モードでも、レビューと分類器の実行は課金されます。スターターポリシーと手順については、[Claude Approvals を設定する](https://code.claude.com/docs/ja/approvals-setup.md)を参照してください。

## 関連リソース

* [プルリクエスト上で Claude Approvals を使用する](https://code.claude.com/docs/ja/approvals-pull-requests.md)：チェックのタイトルとコメントコマンド
* [Approvals と GitHub のルール](https://code.claude.com/docs/ja/approvals-github-rules.md)：必須レビュー、CODEOWNERS、マージキュー
* [ポリシーファイルのリファレンス](https://code.claude.com/docs/ja/approvals-policy.md)：キーとポリシーの例
* [Claude Approvals のトラブルシューティング](https://code.claude.com/docs/ja/approvals-troubleshooting.md)：チェックが表示されない場合やポリシーファイルが拒否された場合
* [権限を設定する](https://code.claude.com/docs/ja/permissions.md)：Claude Code の権限プロンプト
