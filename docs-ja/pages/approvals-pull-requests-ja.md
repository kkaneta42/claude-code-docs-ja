> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# プルリクエストで Claude Approvals を扱う

> Claude Approvals のチェックのタイトルが何を意味し、次に何をすべきかを確認し、コメントコマンドを使い、Claude やフォークからのプルリクエストに対応します

[Claude Approvals](https://code.claude.com/docs/ja/approvals.md) が有効になっている場合、評価対象のプルリクエストに **Claude Approvals** という名前のチェックが追加されます。このチェックは、リポジトリ内の[ポリシーファイル](https://code.claude.com/docs/ja/approvals-policy.md)に従って、まだ誰がプルリクエストを承認する必要があるかを報告します。リポジトリでこのチェックが必須になっている場合、GitHub はチェックが成功するまでマージをブロックできます。ドラフトであるなどの理由でプルリクエストにチェックがない場合は、[No Claude Approvals check appeared](https://code.claude.com/docs/ja/approvals-troubleshooting.md#no-claude-approvals-check-appeared) を参照してください。

## Claude Approvals を通過させる

Approvals は、プッシュや承認などのイベントの後にプルリクエストを評価します。結果はプルリクエスト上の 2 か所で報告されます。

* **Claude Approvals チェック**: **Conversation** タブの下部にあるチェックの一覧に表示されます。名前の横にあるテキスト（タイトルと呼びます）が、**Waiting on human review from any person (1/2)** のように承認ステータスを示します
* **Claude のコメント**: 会話の中に、結果の理由とともに表示されます。Approvals は結果が変わるたびに同じコメントを編集するため、コメントは最初に表示された位置に残ります

チェックを成功させるには、次の手順に従います。

1. **承認ステータスを読む**: チェックのタイトルは、まだ誰が承認する必要があるかなど、プルリクエストの現状を示します
2. **ステータスが求める対応を行う**: [タイトルを探して](#find-your-approval-status-and-what-to-do-next)、必要な対応を確認します。たとえば、書き込みアクセス権を持つ人に承認を依頼する、Code Review が投稿した指摘事項を修正する、レビューの完了を待つ、などです
3. **ステータスをもう一度読む**: 誰かが承認したときやプッシュしたときなど、次の評価でタイトルが変わることがあります。差分を変更するプッシュの後は、[以前の承認がカウントされなくなる場合があります](https://code.claude.com/docs/ja/approvals-policy.md#earlier-approvals-after-a-new-push)
4. **マージする**: チェックが成功したら、リポジトリの GitHub ルールが許す方法でマージします。ポリシーが許可している場合は、Claude が承認レビューを投稿することもできます

## 承認ステータスと次に行うことを確認する

**Claude Approvals** チェックは、プルリクエストの承認ステータスをタイトル（チェック一覧で名前の横に表示されるテキスト）で示します。以下の表でチェックのタイトルを探し、その意味と次に行うことを確認してください。

その他のタイトルの場合は、**Claude Approvals** チェックの概要を開いてください。原因と次の手順が記載されています。ポリシーファイル `.claude/approvals.yml` を管理しているユーザーを確認するには、デフォルトブランチでそのファイルを最後に変更したユーザーを確認してください。

### Approvals が人を待っている

これらのタイトルの場合、Approvals は人による対応を待っています。observe モード以外では、GitHub は **Claude Approvals** チェックを保留中のチェックとして一覧表示し、**Action required** と表示します。

| タイトル | 対応 |
| :- | :- |
| **Waiting on human review from any person (1/2)** | 書き込みアクセス権を持つ人に承認を依頼します。数字は、これまでにカウントされた承認の数と、ポリシーが求める承認の数です。通常、作成者はすでに[1 人としてカウントされています](https://code.claude.com/docs/ja/approvals-policy.md#whether-a-pull-request’s-author-counts)。「any person」の部分には、ルールが求める人やチームの名前が入ることもあれば、誰の名前も入らないこともあります |
| **Changes requested** | 変更を要求したレビュアーに承認してもらうか、誰かにそのレビューを却下してもらいます |
| **Claude's approval still stands; dismiss it** | [Claude のレビューを却下する](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/reviewing-changes-in-pull-requests/dismissing-a-pull-request-review)か、そのブランチでレビューを却下できる人に依頼します。GitHub が Approvals によるレビューの却下を許可しませんでした |

### Approvals が Code Review または分類器を待っている

これらのタイトルの場合、Approvals には [Code Review](https://code.claude.com/docs/ja/code-review-pull-requests.md) または[分類器](https://code.claude.com/docs/ja/approvals-classifiers.md)からの回答が必要です。

| タイトル | 対応 |
| :- | :- |
| **Waiting for Code Review**、**Waiting for repo/change\_risk**、**Waiting for classifiers** | 結果を待ちます |
| **A classifier had no result**、**A classifier has not run**、または **repo/change\_risk has not run** のように「A classifier」の代わりに名前が入ったもの | [Claude Approvals チェックを再実行します](#comment-commands-for-approvals)。[回答がない場合にルールが何を参照するか](https://code.claude.com/docs/ja/approvals-classifiers.md#what-a-rule-sees-when-a-classifier-run-gives-no-answer)を参照してください |

### ルールまたはポリシーファイルが原因で Approvals が成功しない

これらのタイトルの場合、ルールがプルリクエストを保留しているか、ポリシーの修正が必要です。

| タイトル | 対応 |
| :- | :- |
| **Held by Code Review's findings** | Code Review がプルリクエストに投稿した指摘事項を修正し、プッシュします。ポリシーの [`findings`](https://code.claude.com/docs/ja/approvals-policy#findings) リストにユーザーの名前がある場合は、指摘事項のスレッドを解決できます。解決した後も **Claude Approvals** チェックが保留されたままの場合は、修正をプッシュします |
| **Held by** と引用符で囲まれたルールの目的、**Held by a policy rule** | チェックのサマリーに記載されたルールが何を必要としているかをポリシーファイルの管理者に確認し、修正をプッシュします |
| **No rule applies to** と引用符で囲まれたファイル名、**No rule applies to a changed file** | ポリシーファイルの管理者に、そのファイルを対象とする `if` のないルールを依頼します。そのルールがマージされたら、チェックを再実行します |
| **This change breaks a policy file**、**Default branch policy file cannot be used** | [ポリシーファイルを修正します](https://code.claude.com/docs/ja/approvals-troubleshooting.md#fix-a-policy-file-that-approvals-refuses) |

修正をプッシュした後も、以前のコミットで失敗した Code Review がチェックを保留し続けることがあります。新しいレビューが開始されない場合は、[`@claude review`](https://code.claude.com/docs/ja/code-review-pull-requests#comment-commands) のみを記載した新しいコメントを投稿してください。これには書き込みアクセス権が必要です。

### Approvals が成功した、または何も実行されなかった

これらのタイトルの場合、Approvals が成功したか、プルリクエストを評価しませんでした。

| タイトル | 対応 |
| :- | :- |
| **Passed; no approval from Claude** | GitHub が承認を必須としている場合は、人に依頼します |
| **Nothing ran, not blocking: no file is covered** | プルリクエストで変更されるファイルを誰かがレビューすべき場合は、[ポリシーファイル](https://code.claude.com/docs/ja/approvals-policy.md)の管理者にそれらのファイルを対象に含めるよう依頼します |
| **Observe mode ended: not evaluated yet** | コミットをプッシュするか、[Claude Approvals チェックを再実行します](#comment-commands-for-approvals)。成功した場合、自動マージが有効なプルリクエストやマージキューにあるプルリクエストはすぐにマージされることがあります |

**Passed; no approval from Claude** が表示された場合は、次のような原因がないか確認してください。

* ルールに `claude: comments` と記載されている
* 変更されたファイルにルールがない、またはそのファイルが[シンボリックリンク、サブモジュールポインタ、または `.gitattributes` ファイル](https://code.claude.com/docs/ja/approvals-policy#protected-files)である
* `claude[bot]` がプルリクエストを作成した（[Claude Approvals GitHub App](#pull-requests-that-claude-opens) がインストールされ、リンクされている場合を除く）

## observe モードの Approvals

observe モードでは、**Claude Approvals** チェックは neutral（GitHub は成功として扱います）で終了し、タイトルは **(observe mode)** で始まります。

次のようなケースでは、チェックが待機する、失敗する、保留される、または表示されないことがあります。

| ケース | チェックの動作 |
| :- | :- |
| プルリクエストがポリシーファイルまたは分類器ファイルを変更する | 1 人（作成者でもよい）を待つことがあります。変更によってそれらのファイルのいずれかが壊れた場合は失敗します |
| デフォルトブランチのポリシーファイルを使用できない | [ポリシーファイルを修正する](https://code.claude.com/docs/ja/approvals-troubleshooting.md#fix-a-policy-file-that-approvals-refuses)まで失敗します |
| タイトルに Withheld と表示される | Approvals が成功したチェックを保留しています。たとえば、別のオープンなプルリクエストに同じ最新コミットがある場合などです。解除する方法については、チェックの概要を確認してください |
| プルリクエストがデフォルト以外のブランチを対象としている | チェックは表示されません。ただし、プルリクエストがポリシーファイルまたは分類器ファイルを変更する場合は除きます |

## Approvals のコメントコマンド

コマンドを使用するには、プルリクエストに新しいコメントとして投稿します。リポジトリへの書き込みアクセス権が必要です。コメントに 😕 リアクションが付いた場合は、コマンドが完全には実行されなかったことを意味します。

| コマンド | 動作 |
| :- | :- |
| `@claude approvals rerun` | 最新のコミットを再評価します。分類器が再実行されることがあり、課金されます。コメントの 1 行目に単独で記載してください。フォークのプルリクエストでは、[まず変更内容を読み、最新コミットの完全な SHA を追加して、それをコメントの唯一のテキストにしてください](#pull-requests-from-forks-and-outside-contributors) |
| `@claude approve` | **Claude Approvals** チェックにおいて、最新コミットに対するユーザーの承認としてカウントされることがあります。コミットを指定するには、その完全な SHA を追加します。フォークからのプルリクエストではこれが必須です。コメントの唯一のテキストにしてください |
| `@claude approvals resolve <ids>` | ポリシーの [`findings`](https://code.claude.com/docs/ja/approvals-policy#findings) リストにユーザーの名前がある場合、指定した ID の指摘事項をクローズできます。1 行目に単独で記載し、`f-1a2b3c4d` のような指摘事項 ID を 1〜8 個指定します |

Approvals は、GitHub App のボットアカウントからの `@claude approvals rerun` にも対応できます。そのコメントは評価を開始し、分類器が実行されて課金されることがありますが、[フォークのコミット](#pull-requests-from-forks-and-outside-contributors)を保証するものにはなりません。

チェックのサマリーに、ユーザーが[承認としてカウントされない](https://code.claude.com/docs/ja/approvals-policy.md#whether-a-pull-request’s-author-counts)と記載されている場合は、自分のプルリクエストに `@claude approve` とコメントしてください。その承認を取り消すには、自分の `@claude approve` コメントをそれぞれ編集または削除します。Approvals は編集されたコメントを承認としてカウントしないため、再度承認するには新しいコメントを投稿してください。

## Claude、フォーク、外部コントリビューターからのプルリクエスト

`claude[bot]` が作成したプルリクエストを Claude が承認できるようにするには、2 つ目の GitHub App が必要です。フォークからのプルリクエストや、書き込みアクセス権を持たない人からのプルリクエストには、メンテナーが必要になる場合があります。

### Claude が作成するプルリクエスト

2 つ目の GitHub App を追加するまでは、`claude[bot]` が作成したプルリクエストの **Claude Approvals** チェックは、**Passed; no approval from Claude** というタイトルで成功することがあります。

それらのプルリクエストで Claude の承認を得るには、2 つ目のアプリを追加します。

1. **インストールする**: GitHub 組織のオーナーに、リポジトリへの [Claude Approvals GitHub App](https://github.com/apps/claude-approvals/installations/new) のインストールを依頼します。
2. **リンクする**: GitHub 組織のオーナーであり、かつ Claude 組織の Owner または Primary Owner である人に、[アプリを Claude の組織にリンクする](https://claude.ai/settings/claude-approvals/github/finish)よう依頼します。その人がリンクできない場合は、[Anthropic サポート](https://support.claude.com)にお問い合わせください。

その後、`claude[bot]` が作成したオープンなプルリクエストで[チェックを再実行します](#comment-commands-for-approvals)。[Claude GitHub App](https://github.com/apps/claude) が引き続きチェックを報告するため、必須チェックのソースはそのままにしておいてください。

### フォークおよび外部コントリビューターからのプルリクエスト

フォークのプルリクエストでは、Approvals はメンテナー（書き込みアクセス権を持つ人）を待つことがあります。

* **メンテナーがコミットを保証するまで**: Code Review を含め、どの分類器の回答もカウントされません。ルールがいずれかの分類器に依存している場合、**Claude Approvals** チェックのタイトルが **No classifier result counts on this commit** になることがあります。
* **コミットを保証するには**: observe モード以外で、書き込みアクセス権を持っている場合は、変更内容を読みます。次に、`@claude approvals rerun` に続けて最新コミットの完全な SHA を、コメントの唯一のテキストとしてコメントします。その後、そのコミットに対して分類器が実行できるようになります。SHA を指定しない場合、コマンドはコメントした時点で最新だったコミットを対象とすることがあります。
* **成功はメンテナーを待つ**: observe モード以外で、変更されたファイルをルールが対象としている場合、チェックには、プルリクエストを作成していない書き込みアクセス権を持つ人の承認も必要です。これは、フォークのプルリクエストと、書き込みアクセス権を持たない人が作成したプルリクエストに適用されます。それまでは Claude は承認しません
* **`"!pr/authors"` を含むルール**: フォークのプルリクエストでは、どの承認もそのルールにカウントされず、誰かが承認すると、チェックのタイトルが **Cannot tell who wrote this change** になることがあります。ポリシーファイルの管理者が何を変更できるかは、チェックのサマリーに記載されています

## 関連リソース

* [Claude Approvals](https://code.claude.com/docs/ja/approvals.md): ポリシーとは何か、何に影響するか
* [Claude Approvals のトラブルシューティング](https://code.claude.com/docs/ja/approvals-troubleshooting.md): チェックが表示されない場合や、チェックが成功しない場合
* [Claude Approvals ポリシーファイルリファレンス](https://code.claude.com/docs/ja/approvals-policy.md): チェックのサマリーに記載されるキー
