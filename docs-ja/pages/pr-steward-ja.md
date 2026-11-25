> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# PR Steward

> 失敗したチェック、マージコンフリクト、レビューのフィードバックに対する修正を PR Steward に GitHub のプルリクエストへプッシュさせます

PR Steward は、チームのオープンな GitHub プルリクエストに取り組むエージェントです。レビューのフィードバックに対応するコミットをプッシュし、失敗したチェックの修正やマージコンフリクトの解決を試みます。PR Steward をオンにすると、プルリクエストを作成したらすぐに次の変更に着手でき、その後に発生する失敗したチェック、コンフリクト、レビューコメントには PR Steward が対応します。Team プランと Enterprise プランでパブリックベータとして提供されています。

> [!TIP]
>
> PR Steward をオンにするには、[PR Steward をセットアップする](https://code.claude.com/docs/ja/pr-steward-setup.md)の手順に従ってください。これには Claude 組織の Owner ロールが必要です。

PR Steward は GitHub 上の問題を検出し、クラウドセッションで作業して、プルリクエスト上で結果を報告します。

![PR Steward の図：失敗したチェック、レビューコメント、またはマージコンフリクトがクラウドセッション内の PR Steward に渡され、そのコミットと返信が GitHub に表示される。](https://mintcdn.com/claude-code/sMH7RDpTvyWlAkrg/images/pr-steward-flow.svg?fit=max\&auto=format\&n=sMH7RDpTvyWlAkrg\&q=85\&s=4a1de46fbee43c2a00ef78c3dca36e59)

プルリクエスト上で PR Steward を停止するには、`claude-pr-steward-watching` ラベルを削除するか、[`@claude stop` とコメントします](https://code.claude.com/docs/ja/pr-steward-pull-requests#start-or-stop-pr-steward-on-one-pull-request)。

Steward はプルリクエストを承認またはマージしないように設計されています。マージの前に必要な承認を求めるには、ブランチ保護を使用してください。[承認とマージに関する制限](https://code.claude.com/docs/ja/pr-steward-security.md#limits-on-approvals-and-merges)を参照してください。

## PR Steward がプルリクエスト上で行うこと

PR Steward がプルリクエストを監視している間は、事前に確認することなくコミットをプッシュしてコメントに返信し、プルリクエストには `claude-pr-steward-watching` ラベルが付きます。[PR Steward がプルリクエストに追加するもの](https://code.claude.com/docs/ja/pr-steward-pull-requests.md#what-pr-steward-adds-to-a-pull-request)を参照してください。

### PR Steward が開始するタイミング

Owner が PR Steward を **On** に設定したリポジトリでは、プルリクエストを作成したとき、再オープンしたとき、またはドラフトをレビュー可能としてマークしたときに開始します。また、まだ開始していないオープンなプルリクエストに対して次にプッシュが行われたときにも開始します。

PR Steward は、ドラフト、フォークからのプルリクエスト、ボットが作成したプルリクエスト、リポジトリへの書き込み権限を持たない作成者をスキップします。Owner は[リポジトリの設定を変更](https://code.claude.com/docs/ja/pr-steward-setup.md#choose-when-pr-steward-starts-in-each-repository)して、PR Steward がドラフトも対象にするように、または通常は誰かが依頼したときにのみ開始するようにできます。

### PR Steward が修正するもの

PR Steward は、失敗したチェック、マージコンフリクト、レビューのフィードバック、Claude Approvals チェックに取り組みます。

* **失敗したチェック**：原因がプルリクエストで変更されたコードにある場合に修正を試みます
* **マージコンフリクト**：ベースブランチをマージしてコンフリクトの解決を試みます
* **人によるレビューコメント**：小さく具体的な変更を試み、コメントに返信します。依頼が大規模な場合や設計に関するものである場合は、プッシュせずに返信することがあります
* **レビューボットの指摘**：[Code Review](https://code.claude.com/docs/ja/code-review.md) が **Important** とマークした指摘に取り組みます。その他のボットについては、lint の指摘とバグに取り組みます
* **[Claude Approvals](https://code.claude.com/docs/ja/approvals.md) チェック**：未解決の Code Review の指摘など、コミットで修正できるものをチェックが待っている場合は、それに取り組みます。チェックが人による承認を待っている場合は、そのままにします。PR Steward がプッシュした後、チェックが[再度承認を求める](https://code.claude.com/docs/ja/approvals-policy.md#earlier-approvals-after-a-new-push)ことがあります

### PR Steward を停止または制限する

1 つのプルリクエストで PR Steward を停止するには、`claude-pr-steward-watching` ラベルを削除するか、[`@claude stop` とコメントします](https://code.claude.com/docs/ja/pr-steward-pull-requests#start-or-stop-pr-steward-on-one-pull-request)。今後作成するプルリクエストで PR Steward をオフにしたり制限したりするには、claude.ai の **Settings > Code** にある [**PR Steward**](https://claude.ai/settings/claude-code#pr-steward) に移動します。

## PR Steward がチームに適しているかを判断する

PR Steward は、Code Review や Claude Approvals と並ぶ [Claude Ship](https://code.claude.com/docs/ja/claude-ship.md) エージェントの 1 つです。オンにする前に、auto-fix や `/steward` と比較し、組織が要件を満たしているかを確認し、課金方法を確認してください。

### PR Steward と auto-fix および /steward の違い

[Auto-fix](https://code.claude.com/docs/ja/claude-code-on-the-web.md#auto-fix-pull-requests) と [`/steward` コマンド](https://code.claude.com/docs/ja/ship-command#start-a-watch-with-%2Fsteward)も、失敗したチェックやレビューコメントに取り組みます。これらはユーザー自身のセッションで実行され、ユーザーとして動作し、ユーザー自身の使用量にカウントされます。PR Steward は [Claude GitHub App](https://github.com/apps/claude) として動作し、組織に課金されます。

PR Steward が監視しているプルリクエストに auto-fix を依頼すると、そのリクエストは失敗します。[Auto-fix が利用できない](https://code.claude.com/docs/ja/pr-steward-troubleshooting.md#auto-fix-is-unavailable)を参照してください。

### 利用条件

PR Steward は、github.com 上のリポジトリ、またはポート 443 で接続された [GitHub Enterprise Server](https://code.claude.com/docs/ja/github-enterprise-server.md) インスタンス上のリポジトリで動作します。[Team プランまたは Enterprise プラン](https://code.claude.com/docs/ja/feature-availability.md#features-that-require-a-claude-subscription)の Claude 組織が必要です。

[Zero Data Retention](https://code.claude.com/docs/ja/zero-data-retention.md) が有効になっている組織、[HIPAA 構成](https://code.claude.com/docs/ja/hipaa-setup.md)が適用されている組織、または顧客管理の暗号鍵を使用している組織では、PR Steward を利用できません。

### PR Steward の費用

PR Steward の使用量はトークン単位で、組織の[使用クレジット](https://support.claude.com/en/articles/12429409-extra-usage-for-paid-claude-plans)に課金されます。[支出上限を設定する](https://code.claude.com/docs/ja/pr-steward-setup.md#set-pr-steward’s-spend-limits)まで、PR Steward 独自の支出上限はありません。設定には Owner ロールが必要です。

## 次のステップ

* [PR Steward をセットアップする](https://code.claude.com/docs/ja/pr-steward-setup.md)（Owner が必要）
* プルリクエストで [PR Steward を活用する](https://code.claude.com/docs/ja/pr-steward-pull-requests.md)
* [PR Steward がアクセスできるもの](https://code.claude.com/docs/ja/pr-steward-security.md)
* [PR Steward のトラブルシューティング](https://code.claude.com/docs/ja/pr-steward-troubleshooting.md)
