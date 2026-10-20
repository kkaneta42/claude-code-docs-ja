> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# Code Review のトラブルシューティング

> 開始されなかった、失敗した、または予算のためにスキップされた Code Review の修正、表示されない指摘事項の確認、セットアップと `REVIEW.md` の問題の解決を行います。

プルリクエストで [Code Review](/docs/ja/code-review) が期待どおりに動作しない場合は、まず **Claude Code Review** チェック実行を確認してください。そのタイトルから、レビューがどこまで進んだかがわかります。

<h2 id="check-how-far-the-review-got">
  レビューがどこまで進んだかを確認する
</h2>

プルリクエストで **Claude Code Review** チェック実行を見つけ、そのタイトルを次のよくあるタイトルと照らし合わせてください。

| チェック実行のタイトル | 意味 | 対処方法 |
| :- | :- | :- |
| **Code review queued...** または **Code review in progress...** | レビューがまだ完了していません | タイトルが変わるまで待ちます |
| **Code review found no issues** | レビューが完了し、指摘すべき点は見つかりませんでした | 対処は不要です |
| 問題が見つかったことを示すタイトル | レビューが完了し、指摘事項があります | 差分上に表示されない場合は、[インラインコメントとして表示されない問題を見つける](#find-issues-that-aren’t-showing-as-inline-comments)を参照してください |
| **Code review skipped — no new changes** | 最新のプッシュに対して自動レビューが実行されませんでした | それでもレビューを受けたい場合は、`@claude review` とコメントします |
| **Code review failed** または **Code review timed out** | レビューが完了しませんでした | 再実行するには、[失敗またはタイムアウトしたレビューを再トリガーする](#retrigger-a-failed-or-timed-out-review)を参照してください |
| **Code review declined** | レビューは実行されませんでした | チェック実行の概要を読んでください。予算または支出上限について記載されている場合は、[レビューが実行されず、PR に予算に関するメッセージが表示される](#review-didn’t-run-and-the-pr-shows-a-budget-message)を参照してください |
| チェック実行なし | レビューが開始されていません | `@claude review` とコメントします。その後もチェック実行が表示されない場合は、[コメントコマンドでレビューが開始されなかった](#a-comment-command-didn’t-start-a-review)を参照してください |

<h2 id="a-review-didn’t-start">
  レビューが開始されなかった
</h2>

**Claude Code Review** チェック実行が表示されない場合、または Claude がレビューをスキップしたというコメントを投稿した場合は、次のケースを確認してください。

<h3 id="a-comment-command-didn’t-start-a-review">
  コメントコマンドでレビューが開始されなかった
</h3>

`@claude review` とコメントした後、プルリクエスト上に **Code review queued...** または **Code review in progress...** というタイトルの **Claude Code Review** チェック実行があるかを確認してください。コメントに 👀 リアクションが付いても、レビューが開始されることの確認にはなりません。チェック実行が表示されない場合は、次の各原因を確認してください。

* **このリポジトリで Code Review がオンになっていない**：Claude はコマンドに対してコメントもチェック実行も投稿しません。Owner に[リポジトリを追加する](/docs/ja/code-review-setup#add-more-repositories)よう依頼してください。
* **コメントが条件を満たしていない**：新しいトップレベルのコメントではなく、インラインコメントやレビュー本文だった場合、またはコマンドがコメントの先頭になかった場合です。新しいコメントを投稿せずに以前のコメントを編集した場合も対象外で、プルリクエストはオープンである必要があります。[コメントコマンドの条件](/docs/ja/code-review-pull-requests#comment-commands)を確認し、条件を満たす新しいコメントを投稿してください。
* **書き込みアクセス権がない**：リポジトリに対する write、maintain、または admin の権限が必要です。フォークからのプルリクエストの場合は、ベースリポジトリに対する権限が対象になります。プルリクエストが自分のものでない場合、Claude は[ヒント](/docs/ja/code-review-setup#turn-tip-comments-on-or-off)として「No review was started: manual reviews can only be requested by someone with write access to this repository.」と返信することがあります。書き込みアクセス権を持つ人に代わりにコメントしてもらってください。
* **予算が尽きた**：Claude は「⚠️ Code review skipped」で始まるコメントを投稿します。[レビューが実行されず、PR に予算に関するメッセージが表示される](#review-didn’t-run-and-the-pr-shows-a-budget-message)を参照してください。

<h3 id="review-didn’t-run-and-the-pr-shows-a-budget-message">
  レビューが実行されず、PR に予算に関するメッセージが表示される
</h3>

組織の予算でレビューをまかなえない場合、Code Review はレビューをスキップし、Claude はプルリクエストに「⚠️ Code review skipped」で始まるコメントを投稿します。場合によっては、**Code review declined** というタイトルのチェック実行も表示されます。

コメントには [claude.ai/admin-settings/usage](https://claude.ai/admin-settings/usage) へのリンクが含まれており、管理者はそこで予算を回復できます。コメントの文言から、どの上限に達したかがわかります。

* **「has reached its monthly code review spending cap」**：[Code Review の月間支出上限](/docs/ja/code-review-costs#limit-your-spend)に達しました。レビューは次の請求期間の開始時に再開されます。それより早く再開するには、管理者に上限の引き上げを依頼してください。
* **「has no extra usage available to pay for this review」**：組織の[使用クレジット](https://support.claude.com/en/articles/12429409-extra-usage-for-paid-claude-plans)残高がなくなったか、組織全体の月間支出上限に達しました。管理者に使用クレジットの追加またはその上限の引き上げを依頼してください。
* **「is too low to start another review」**：予算または残高の残りが、1 回のレビューにかかる想定コストを下回っています。管理者に上限の引き上げまたは使用クレジットの追加を依頼してください。

予算が回復したら、プルリクエストに `@claude review` とコメントして、スキップされたレビューを実行してください。[コメントコマンドの条件](/docs/ja/code-review-pull-requests#comment-commands)が適用されるため、コメントする人には書き込みアクセス権が必要です。

<h2 id="retrigger-a-failed-or-timed-out-review">
  失敗またはタイムアウトしたレビューを再トリガーする
</h2>

チェック実行の概要に「The review session was interrupted before it could finish. A new review of this commit has been queued automatically.」と表示されている場合は、何もする必要はありません。そのレビューは自動的に 1 回再試行されます。

それ以外で、チェック実行のタイトルが **Code review failed** または **Code review timed out** の場合は、コメントまたは再実行でレビューをもう一度実行してください。

* **`@claude review` とコメントする**：プルリクエストにトップレベルのコメントとして投稿します。これにより、プルリクエストを今後のプッシュの対象として登録することなく、新しいレビューが開始されます。
* **Re-run をクリックする**：プルリクエストが[フォークからのもの](/docs/ja/code-review-pull-requests#review-drafts-and-pull-requests-from-forks)でない場合は、GitHub の **Checks** タブで **Claude Code Review** チェックの **Re-run** をクリックします。再実行はプルリクエストの現在の head コミットを対象とし、こちらもプルリクエストを今後のプッシュの対象として登録しません。

<h2 id="find-issues-that-aren’t-showing-as-inline-comments">
  インラインコメントとして表示されない問題を見つける
</h2>

チェック実行のタイトルが問題が見つかったことを示しているのに、差分上にインラインのレビューコメントが表示されない場合は、指摘事項が表示される次の別の場所を確認してください。

* **チェック実行の Details**：**Checks** タブで **Claude Code Review** チェックの横にある **Details** をクリックします。重大度の表には、インラインコメントが受け付けられたかどうかにかかわらず、指摘事項がファイル、行、概要とともに一覧表示されます。
* **Files changed のアノテーション**：PR の **Files changed** タブを開きます。行が特定されているもののインラインコメントとして投稿されなかった指摘事項は、該当する行のアノテーションとしてそこに表示されます。
* **レビュー本文**：インラインの位置がない指摘事項や、現在の差分の範囲外にある指摘事項は、レビュー本文の **Additional findings** 見出しの下に表示されます。

<h2 id="the-check-run-mentions-review-md">
  チェック実行に REVIEW\.md が記載されている
</h2>

チェック実行に表示される `REVIEW.md` に関するメッセージのうち、次の 2 つはブランチ保護に関するものです。

* **「This review applied the repository's review instructions (REVIEW\.md) from its default branch, which is not protected against direct pushes.」**：レビューはルートのファイルのみを読み込みました。ブランチを保護すると何が変わるかについては、[REVIEW.md の読み込み元ブランチ](/docs/ja/code-review-customize#which-branch-review-md-is-read-from)を参照してください。
* **「were not applied to this review: branch protection could not be confirmed」**：レビューは `REVIEW.md` を読み込みませんでした。

<h2 id="setup-problems">
  セットアップの問題
</h2>

これらのケースは、Owner が [Code Review をセットアップする](/docs/ja/code-review-setup)際に発生します。

<h3 id="a-repository-isn’t-listed-in-add-a-repository">
  Add a repository にリポジトリが表示されない
</h3>

ダイアログは長いリストをすべて読み込まないため、まずリポジトリを名前で検索してください。ダイアログには、Claude GitHub App がアクセスできるリポジトリのみが表示されます。**Install GitHub App** をクリックし、アプリにそのリポジトリへのアクセス権を付与してください。リポジトリが 1 つも表示されない場合、**Install GitHub App** はダイアログ内のボタンとして表示されます。それ以外の場合は、ダイアログの GitHub 組織フィルターメニューの下部にあります。

<h3 id="no-check-run-appears-on-the-test-pull-request">
  テスト用のプルリクエストにチェック実行が表示されない
</h3>

**Allow code review** がオンになっていること、**Code review** セクションの **Repositories** にリポジトリが表示されていること、Claude GitHub App がそのリポジトリにアクセスできることを確認してください。自動レビューはドラフトのプルリクエストをスキップします。また、**Manual (@claude review)** に設定されたリポジトリでは、最初のレビューを開始するために `@claude review` コメントが必要です。

<h2 id="related-resources">
  関連リソース
</h2>

* [プルリクエストでレビューを読む・依頼する](/docs/ja/code-review-pull-requests)：指摘事項とチェック実行の意味、およびコメントコマンド
* [Code Review をセットアップする](/docs/ja/code-review-setup)：Owner 向けに、Code Review をオンにしてリポジトリを管理する方法
* [Code Review のコストと使用量](/docs/ja/code-review-costs)：予算に関するメッセージの原因となる支出上限
* [Code Review をカスタマイズする](/docs/ja/code-review-customize)：レビューがどの `REVIEW.md` を読み込むか
