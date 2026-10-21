> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# Code Review のコストと使用状況

> 組織が Claude Code Review に費やす金額を見積もり、上限を設定します。使用クレジットを通じたレビューの課金方法、コストを左右する要因、使用状況の確認場所について説明します。

[Code Review](/docs/ja/code-review) には、レビューごとの定額料金はありません。支出額は、各レビューのコストと実行されるレビューの数によって決まります。

* **各レビューのコスト**：[レビューレベル](/docs/ja/code-review-setup#set-the-default-review-level)、変更の規模、周辺コードの複雑さ、検証が必要な候補の問題の数に応じて増減します
* **レビューの数**：各リポジトリで[レビューが実行される頻度](#how-often-reviews-run)によって決まります

## 料金

Code Review は、プランに含まれる使用量とは別に、[使用クレジット](https://support.claude.com/en/articles/12429409-extra-usage-for-paid-claude-plans)を通じてトークン使用量に基づいて課金されます。レビューは、PR を作成した開発者やレビューを依頼した開発者ではなく、組織に対して課金されます。組織が他の Claude Code 機能に Amazon Bedrock、Google Cloud の Agent Platform、Microsoft Foundry のいずれを使用しているかにかかわらず、コストは Anthropic の請求書に記載されます。

### レビューが実行される頻度

管理ページから追加したリポジトリは、最も多くのレビューが実行される **After every push** から始まります。各リポジトリの [**Review runs** 設定](/docs/ja/code-review-setup#set-when-reviews-run)によって、プルリクエストが受けるレビューの数が決まります。

* **Once after PR creation**：プルリクエストが作成されたとき、再オープンされたとき、またはレビュー準備完了としてマークされたときにレビューが実行されます
* **After every push**：プッシュのたびに実行されるため、コストはプッシュ回数に比例して増えます
* **Manual (@claude review)**：作成時やプッシュ時にはレビューは実行されません

コメントコマンド、ドラフト、フォークからのプルリクエストによって、これらの回数は次のように変わります。

* **Once after PR creation または Manual モードでの `@claude review always`**：[PR をプッシュトリガーのレビューにオプトインする](/docs/ja/code-review-pull-requests#comment-commands)ため、そのコメント以降はプッシュごとに追加のコストが発生します
* **After every push モードでの `@claude review always`**：プッシュですでにレビューがトリガーされるため、このサブスクリプションによってプッシュごとのコストは変わりません
* **`@claude review`**：今後のプッシュをサブスクライブせずに、1 回だけレビューを実行します
* **ドラフトとフォークからのプルリクエスト**：[自動レビューはどちらもスキップする](/docs/ja/code-review-pull-requests#review-drafts-and-pull-requests-from-forks)ため、これらへのプッシュでレビューが増えることはありません

## 支出を見積もる

本格的に展開する前に、小規模なパイロットを実施して、自組織のプルリクエストから月間の支出を見積もります。

1. パイロット用に[月間支出上限](#limit-your-spend)を設定します。
2. 代表的ないくつかのリポジトリで Code Review をオンにし、**Review runs** を **Once after PR creation** または **Manual (@claude review)** に設定します。
3. いくつかのレビューが実行された後、[**Admin settings > Claude Code**](https://claude.ai/admin-settings/claude-code#code-review) の **Code review** セクションにある **Repositories** テーブルの **Average cost** 列で、各リポジトリのレビューあたりの平均コストを確認します。
4. その平均値に、そのリポジトリで 1 か月間に作成されるプルリクエストの数を掛けます。**After every push** の場合は、さらにプルリクエストあたりの一般的なプッシュ回数を掛けます。

リポジトリの平均値は、そのプルリクエストの規模と選択したレビューレベルに応じて変動します。

## 支出を制限する

Code Review の月間支出上限を設定するには、[claude.ai/admin-settings/usage](https://claude.ai/admin-settings/usage) に移動し、Claude Code Review サービスの上限を構成します。この上限は組織全体に適用されます。

次のいずれかが尽きると、Code Review はレビューをスキップします。

* **Code Review の支出上限**：Claude Code Review サービスに設定した月間上限です。次の請求期間の開始時にリセットされ、上限を引き上げればそれより早くレビューが再開されます。
* **組織の支出上限**：使用クレジットに対する組織全体の月間支出上限です。同じページで引き上げられます。
* **使用クレジットの残高**：組織の使用クレジットの残高です。同じページでクレジットを追加できます。

また、残りの額が 1 回のレビューの想定コストを下回った時点でも、Code Review はレビューをスキップします。レビューがスキップされると、開発者には原因を示し使用状況の設定へのリンクを含む [PR へのコメント](/docs/ja/code-review-troubleshooting#review-didn’t-run-and-the-pr-shows-a-budget-message)が表示されます。

支出を監視するには、[分析ダッシュボード](#view-usage)を使用します。

## 使用状況を確認する

[claude.ai/analytics/code-review](https://claude.ai/analytics/code-review) に移動すると、組織全体の Code Review のアクティビティを確認できます。

| セクション | 表示内容 |
| :- | :- |
| PRs reviewed | 選択した期間にレビューされたプルリクエストの日ごとの件数 |
| Code Review cost | 今月これまでの Code Review の支出 |
| Feedback | 開発者が問題に対処したために自動的に解決されたレビューコメントの件数 |
| Repository breakdown | リポジトリごとのレビューされた PR、解決されたコメント、レビュー実行の件数と、推定コストおよび PR ごとのビュー |

Code Review cost カードには、当月が選択されている場合にのみ金額が表示されます。分析のコスト数値は請求書と異なる場合があります。Repository breakdown のコストは割引やクレジットを適用する前の定価で推定されており、Claude がプルリクエストに投稿したレビューのみが対象です。請求書と一致する正確な支出については、Anthropic の請求書を参照してください。

## 関連リソース

* [Code Review をセットアップする](/docs/ja/code-review-setup)：各リポジトリでレビューレベルとレビューの実行タイミングを選択する場所
* [プルリクエストでレビューを確認・依頼する](/docs/ja/code-review-pull-requests)：コメントコマンド、フォークからのプルリクエスト、レビューがスキップされたときに開発者に表示される予算メッセージ
* [Code Review](/docs/ja/code-review)：レビューで確認される内容と投稿される内容
* [コストを効果的に管理する](/docs/ja/costs)：Claude Code のその他の機能における支出管理と使用状況の追跡
