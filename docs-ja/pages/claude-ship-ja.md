> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# Claude Ship

> GitHub のプルリクエスト向けの Claude Ship エージェント（Code Review、PR Steward、Claude Approvals）を紹介します

Claude Ship は、チームの GitHub プルリクエストをマージできる状態にするためのエージェント群です。

* [Code Review](https://code.claude.com/docs/ja/code-review.md)：ロジックエラー、セキュリティ脆弱性、エッジケースの不具合などの問題を探します
* [PR Steward](https://code.claude.com/docs/ja/pr-steward.md)：レビューのフィードバックや失敗しているチェックに対応します
* [Claude Approvals](https://code.claude.com/docs/ja/approvals.md)：ユーザーが作成した承認ポリシーに照らしてプルリクエストをチェックします

これらを組み合わせることで、プルリクエストをレビュー、修正、承認の判断まで進められるため、チームが各ステップを手動で管理する必要がなくなります。何がマージされるかは、ユーザーの設定と GitHub のブランチルールによって決まります。Claude Ship は [Team プランと Enterprise プラン](#who-can-use-claude-ship)で利用できます。

エージェントをオンにするには、[Claude Ship のセットアップ](#set-up-claude-ship)を参照してください。

> [!NOTE]
>
> 自分のプルリクエストについてローカルでレビューと修正を受けるには、Claude Code で [`/ship`](https://code.claude.com/docs/ja/ship-command) を実行してください。

## Claude Ship エージェント

次の図は、プルリクエストにおける各エージェントの役割と、ユーザーと GitHub に委ねられる部分を示しています。

![3 つの Claude Ship エージェントをすべてオンにしたプルリクエストの図：Code Review が問題を見つけ、PR Steward が修正をプッシュし、修正によって別のレビューが始まることがあります。Claude Approvals がポリシーを適用し、マージはブランチルールに従います。](https://mintcdn.com/claude-code/sMH7RDpTvyWlAkrg/images/claude-ship-overview.svg?fit=max\&auto=format\&n=sMH7RDpTvyWlAkrg\&q=85\&s=6c972cdcb9dfc1c7a9a54e421bcf35a5)

> [!NOTE]
>
> Claude Ship は AI を使用しているため、バグ、セキュリティ脆弱性、その他の問題を見逃す可能性があります。

### Code Review が問題を見つける

[Code Review](https://code.claude.com/docs/ja/code-review.md) は、変更内容を周囲のコードとあわせて読み取ります。指摘事項は、該当する行へのインラインコメントとして、重大度順に届きます。

### PR Steward が修正をプッシュする

[PR Steward](https://code.claude.com/docs/ja/pr-steward.md) は、失敗しているチェック、マージコンフリクト、そして人間や Code Review などのレビューボットからのレビューコメントに対応します。修正を含むコミットをプッシュします。

Steward はプルリクエストを承認したりマージしたりしないように設計されています。何かがマージされる前に必要な承認を求めるには、ブランチ保護を使用してください。[承認とマージに関する制限](https://code.claude.com/docs/ja/pr-steward-security.md#limits-on-approvals-and-merges)を参照してください。

### Claude Approvals がポリシーを適用する

[Claude Approvals](https://code.claude.com/docs/ja/approvals.md) は、まだ誰の承認が必要かを報告するチェックです。ポリシーファイルはユーザーが作成します。このファイルでは、あるパスへの変更に何人の承認が必要か、また Claude がどこで承認レビューを投稿できるかを設定できます。このチェックがマージをブロックするのは、[GitHub で必須チェックにした](https://code.claude.com/docs/ja/approvals-setup.md#enforce-your-policy-and-require-claude-approvals)場合のみで、observe モードでは通常ブロックしません。

> [!WARNING]
>
> 人間の承認を必要としないポリシーで GitHub の自動マージやマージキューを使用すると、誰も操作しないまま変更がマージされる可能性があります。[人間のレビューなしのマージ](https://code.claude.com/docs/ja/approvals-github-rules.md#merges-without-human-review)を参照してください。

## Claude Ship のセットアップ

Claude Ship の設定は [**Organization settings > Claude Ship**](https://claude.ai/admin-settings/claude-ship) にあります。[Owner ロール](https://code.claude.com/docs/ja/server-managed-settings.md#access-control)が必要です。

エージェントは 1 つのリポジトリで 1 つずつ、次の順序でオンにしてください。

1. [Code Review をセットアップする](https://code.claude.com/docs/ja/code-review-setup.md)
2. [PR Steward をセットアップする](https://code.claude.com/docs/ja/pr-steward-setup.md)。PR Steward の開始タイミングを選択する設定では、まず [**Manual (@claude steward)**](https://code.claude.com/docs/ja/pr-steward-setup.md#choose-when-pr-steward-starts-in-each-repository) から始めてください。PR Steward には、ユーザーが設定するまで独自の支出上限がありません。
3. [Claude Approvals をセットアップする](https://code.claude.com/docs/ja/approvals-setup.md)。リポジトリ内のポリシーファイルによって開始されるため、[誰がオンにできるか](https://code.claude.com/docs/ja/approvals.md#who-can-turn-approvals-on-or-off)を確認してください。まず observe モードで開始します。このモードでは、**Claude Approvals** チェックがポリシーによる判断結果を報告します。observe モードも課金されます。[Approvals の費用](https://code.claude.com/docs/ja/approvals-setup.md#what-approvals-costs)を参照してください。

### すでに Code Review を使用している場合

Code Review の設定は [**Organization settings > Claude Ship**](https://claude.ai/admin-settings/claude-ship) に移動しました。

Claude Approvals のポリシーファイル `.claude/approvals.yml` は、Code Review が自動的にレビューするプルリクエストを変更します。このファイルがデフォルトブランチに置かれると、observe モードでも強制モードでも、`claude/code_review` を指定する一致ルールがない場合は通常、自動レビューが停止します。自動レビューを維持するには、[ルールに `claude/code_review` を追加](https://code.claude.com/docs/ja/approvals-policy#advisory)してください。

## プランと請求

Claude Ship は Team プランおよび Enterprise プランの組織向けです。

### Claude Ship を利用できるユーザー

Code Review は一般提供されています。PR Steward と Claude Approvals はパブリックベータです。[Zero Data Retention](https://code.claude.com/docs/ja/zero-data-retention.md) が有効になっている組織、[HIPAA 設定](https://code.claude.com/docs/ja/hipaa-setup.md)が適用されている組織、または顧客管理の暗号化キーを使用している組織では、これらのエージェントを利用できません。Approvals には[さらに制限](https://code.claude.com/docs/ja/approvals.md#availability)があります。

### 各 Claude Ship エージェントの課金方法

各エージェントは、プランに含まれる使用量とは別に、組織の[使用クレジット](https://support.claude.com/en/articles/12429409-extra-usage-for-paid-claude-plans)を通じてトークン使用量に基づいて課金されます。Approvals では、[分類器](https://code.claude.com/docs/ja/approvals-classifiers.md)の実行と、ポリシーが求める Code Review に対して課金されます。

> [!NOTE]
>
> 対象となる Enterprise 組織は、Claude Ship のプロモーションクレジットを受け取ることができます。対象条件、金額、期間については、[クレジットの規約](https://support.claude.com/en/articles/17603594-free-code-review-promotional-credits-for-claude-enterprise)を参照してください。

[**Organization settings > Usage**](https://claude.ai/admin-settings/usage) で使用クレジットをオフにしても、オンになっているエージェントは実行を続け、組織に課金し続けます。課金を停止するには、[Claude Ship をオフにする](#turn-off-claude-ship)の手順に従ってください。

各エージェントの費用を確認してください。

* [Code Review](https://code.claude.com/docs/ja/code-review-costs.md)
* [PR Steward](https://code.claude.com/docs/ja/pr-steward-setup.md#set-pr-steward’s-spend-limits)
* [Claude Approvals](https://code.claude.com/docs/ja/approvals-setup.md#what-approvals-costs)

## Claude Ship をオフにする

Code Review がオフになっていても、ポリシーによって課金対象のレビューが開始される可能性があるため、Code Review より先に Approvals をオフにしてください。

1. [Approvals をオフにする](https://code.claude.com/docs/ja/approvals-setup.md#turn-off-approvals)
2. [PR Steward をオフにする](https://code.claude.com/docs/ja/pr-steward-setup.md#turn-off-pr-steward)
3. [Code Review をオフにする](https://code.claude.com/docs/ja/code-review-setup.md#turn-off-code-review-or-remove-a-repository)

これらの手順を実行しても、`/ship` コマンドと `/steward` コマンドはオンのままです。[これらをオフにする方法](https://code.claude.com/docs/ja/ship-command.md#turn-off-%2Fship-and-%2Fsteward-for-your-organization)を参照してください。

## 関連リソース

* [GitHub Actions](https://code.claude.com/docs/ja/github-actions.md) と [GitLab CI/CD](https://code.claude.com/docs/ja/gitlab-ci-cd.md)：独自の CI で Claude Code を実行します
* [ローカルでコードをレビューする](https://code.claude.com/docs/ja/code-review-local.md)：プッシュする前にターミナルでレビューを受けます
