> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# PR Steward のトラブルシューティング

> GitHub のプルリクエストで PR Steward が開始しなかった、停止した、または一時停止した場合の対処方法と、Owner がセットアップ中に表示されるメッセージの解決方法を説明します

[PR Steward](https://code.claude.com/docs/ja/pr-steward.md) がプルリクエストで期待どおりに動作しない場合は、まず PR Steward からのコメントを探してください。PR Steward がコメントを投稿している場合は、[そのコメントを照合](#pr-steward-posted-a-comment-that-says-why)してください。プルリクエストに何も残されていない場合は、[開始しなかった理由](#pr-steward-didn’t-start-on-a-pull-request)を確認してください。

## PR Steward がプルリクエストで開始しなかった

原因によってはプルリクエストに何も残らないため、以下の各セクションを確認してください。

### PR Steward がコメントに反応しなかった

github.com で `@claude steward` とコメントしたのに PR Steward が開始しなかった場合は、そのコメントを確認してください。

| 表示される内容 | 確認すること |
| :- | :- |
| 👀 リアクションがない | 編集ではなく新しいコメントであること、および書き込み権限があること |
| 👀 リアクションはあるが、その後に `claude-pr-steward-watching` ラベルが付かない | コマンドがトップレベルのコメントの先頭にあること。そのうえで、[PR Steward がプルリクエストで開始しなかった](#pr-steward-didn’t-start-on-a-pull-request)の他のセクションを確認してください |

### PR Steward が開始しないプルリクエスト

プルリクエストが PR Steward がスキップする対象かどうかを確認してください。

| 原因 | 対処方法 |
| :- | :- |
| プルリクエストがドラフトである | レビュー準備完了としてマークします。ドラフトでの作業については、[**Include my draft PRs**](https://code.claude.com/docs/ja/pr-steward-pull-requests.md#choose-what-pr-steward-works-on) を参照してください |
| プルリクエストがフォークからのものである、ボットが作成した、または作成者がリポジトリへの書き込み権限を持っていない | PR Steward はこれらでは開始しません |
| 説明に `<!-- claude-pr-steward-disable -->` が含まれている | 説明からこのマーカーを削除し、`@claude steward` とコメントします |
| 別の Claude セッションがすでにプルリクエストを監視している（たとえば [auto-fix](https://code.claude.com/docs/ja/claude-code-on-the-web.md#auto-fix-pull-requests) がオンになっているクラウドセッション） | そのセッションで auto-fix をオフにしてから、もう一度 `@claude steward` とコメントします |

### 設定によって PR Steward がオフになっている

設定によって PR Steward が開始しない場合があります。

| 原因 | 対処方法 |
| :- | :- |
| リポジトリが [**Manual** に設定されている](https://code.claude.com/docs/ja/pr-steward-setup.md#choose-when-pr-steward-starts-in-each-repository)、または[自分のオプション](https://code.claude.com/docs/ja/pr-steward-pull-requests.md#turn-off-or-limit-pr-steward-on-all-your-pull-requests)が **Off** または **Only when tagged** になっている | `@claude steward` とコメントします |
| プルリクエストがチームメイトのもので、そのチームメイト自身のオプションが **Off** になっている | そのチームメイトに `@claude steward` とコメントするよう依頼します |
| リポジトリまたは作成者の GitHub アカウントに対して PR Steward がオフになっている | Claude 組織の [Owner](https://code.claude.com/docs/ja/server-managed-settings.md#access-control) に、[リポジトリを追加する](https://code.claude.com/docs/ja/pr-steward-setup.md#turn-on-pr-steward-and-add-repositories)か、[PR Steward が対象とする作成者](https://code.claude.com/docs/ja/pr-steward-setup.md#limit-which-authors-pr-steward-works-for)を変更するよう依頼します |

最後の原因を確認するには、作成者に自分の [PR Steward 設定ページ](https://claude.ai/settings/claude-code#pr-steward)を開いてもらいます。組織が PR Steward をオフにしている場合、このページにバナーが表示されます。また、作成者がそこで接続した GitHub アカウントが除外されている場合にもバナーが表示されます。

### 短時間に多数のプルリクエストが作成された

組織内で PR Steward が短時間に多数のプルリクエストで開始した場合は、`@claude steward` とコメントしてください。それでも `claude-pr-steward-watching` ラベルが表示されない場合は、後でもう一度コメントしてください。

## PR Steward が理由を説明するコメントを投稿した

PR Steward のコメントの文言を、以下のいずれかの表から探してください。

### PR Steward が開始できない場合のコメント

PR Steward がコメントを投稿して開始しなかった場合は、ここでコメントの文言を探してください。

| コメントの内容 | 対処方法 |
| :- | :- |
| `PR Steward didn't start: only someone with write access` | 書き込み権限を持つユーザーに、`claude-pr-steward-watching` ラベルを追加するか `@claude steward` とコメントしてもらいます |
| `PR Steward hasn't started: your organization has no extra usage available` | Owner に、[**Organization settings > Usage**](https://claude.ai/admin-settings/usage) で使用クレジットを追加するか、支出上限を引き上げるよう依頼します。PR Steward に開始を依頼していた場合は、もう一度依頼すると開始します。それ以外の場合は、次のプッシュ時に開始します |
| `PR Steward hasn't started: billing for PR Steward isn't set up` | Owner に、PR Steward がオンになっているリポジトリを 1 つ選び、その [**Steward** 設定を](https://code.claude.com/docs/ja/pr-steward-setup.md#choose-when-pr-steward-starts-in-each-repository) **Off** 以外のオプションに変更するよう依頼します。変更後すぐに元に戻してもかまいません |
| `Claude PR Steward couldn't start, so it isn't watching this pull request` | ラベルを追加するか `@claude steward` とコメントして、再試行します |
| `Claude PR Steward couldn't start on this pull request because the setup script` | [PR Steward が実行される環境](https://code.claude.com/docs/ja/pr-steward-setup.md#choose-the-environment-pr-steward-runs-in)を編集できるユーザーにセットアップスクリプトの修正を依頼し、その後 PR Steward を再度開始します |
| `this repository has PR Steward enabled in more than one Claude workspace` | Owner に、リポジトリを 1 つの Claude 組織にのみ残し、他の組織からは削除するよう依頼します |

### PR Steward が停止または一時停止した場合のコメント

PR Steward がコメントを投稿した後に停止または一時停止した場合は、ここでコメントの冒頭の文言を探してください。

| コメントの内容 | 意味 | 対処方法 |
| :- | :- | :- |
| `PR Steward is paused on this pull request` | コメントに記載されているとおり、PR Steward の作業中に使用クレジットが尽きたか、請求のセットアップが完了していません | Owner に、使用クレジットを追加するか支出上限を引き上げるよう、またはコメントの説明に従って請求のセットアップを完了するよう依頼します。PR Steward は次のプッシュまたはコメント時に作業を再開します |
| `Claude PR Steward stopped watching this pull request: this session's spend reached the repository's PR Steward budget` | このセッションが、リポジトリに設定された[支出上限](https://code.claude.com/docs/ja/pr-steward-setup.md#set-pr-steward’s-spend-limits)に達しました | 残りの作業を自分で完了するか、`claude-pr-steward-watching` ラベルを再度追加して新しいセッションを開始します |
| `Claude PR Steward stopped watching this pull request because your organization's PR Steward settings no longer cover it` | Owner が PR Steward をオフにしたか、リポジトリまたは作成者を削除しました | 設定が再びプルリクエストを対象とするようになった後、ラベルを追加するか `@claude steward` とコメントします |
| `Claude PR Steward stopped watching this pull request because for <N> days no person has commented or reviewed here` | コメントに記載された日数の間、誰もコメントやレビューをしておらず、PR Steward 以外の誰もプッシュしていません | ラベルを追加するか `@claude steward` とコメントします |

## Auto-fix が利用できない

PR Steward が自分のプルリクエストで作業するリポジトリでは、クラウドセッションの **Auto-fix** トグルは利用できません。PR Steward が監視しているプルリクエストに対して auto-fix を依頼すると、リクエストは失敗します。claude.ai/code では、メッセージは `PR Steward is already watching this PR.` となります。そのリポジトリで [auto-fix](https://code.claude.com/docs/ja/claude-code-on-the-web.md#auto-fix-pull-requests) を使用するには、自分に対して PR Steward をオフにします。

* **今後のプルリクエスト**: [自分の PR Steward オプション](https://code.claude.com/docs/ja/pr-steward-pull-requests.md#turn-off-or-limit-pr-steward-on-all-your-pull-requests)を **Off** に設定します。これはすべてのリポジトリにおける自分のプルリクエストに適用されます
* **PR Steward がすでに監視しているプルリクエスト**: さらに、[そのプルリクエストで PR Steward を停止](https://code.claude.com/docs/ja/pr-steward-pull-requests.md#start-or-stop-pr-steward-on-one-pull-request)します

## PR Steward のセットアップ中に表示されるメッセージ

[PR Steward をセットアップ](https://code.claude.com/docs/ja/pr-steward-setup.md)している間、[**Claude Ship**](https://claude.ai/admin-settings/claude-ship) ページに次のメッセージが表示されることがあります。

| 表示される内容 | 対処方法 |
| :- | :- |
| **The GitHub connector is not enabled for your organization.** | [**Organization settings > Connectors**](https://claude.ai/admin-settings/connectors) でコネクタをオンにします |
| **Add** をクリックしたときのリポジトリ一覧にリポジトリが表示されない | [**Organization settings > Git providers**](https://claude.ai/admin-settings/source-control) に移動し、GitHub 組織に [Claude GitHub App](https://github.com/apps/claude) をインストールして、そのリポジトリを含めます |
| GitHub アカウントが「cannot push to that repository」、または追加には「needs write access」というメッセージ | プッシュできるアカウントを接続するか、プッシュできる Owner に作業を依頼します |
| `PR Steward can't be enabled right now: billing setup is temporarily unavailable` | 数分後にもう一度お試しください |
| **PR Steward isn’t available for your organization.** | [要件](https://code.claude.com/docs/ja/pr-steward.md#availability)を確認します。[**Runs for**](https://code.claude.com/docs/ja/pr-steward-setup.md#turn-on-pr-steward-and-add-repositories) が **Listed users only** になっている場合は、ユーザー名を追加します |
| **PR Steward is on but not watching any repositories yet.** | [リポジトリに対して PR Steward をオンにします](https://code.claude.com/docs/ja/pr-steward-setup.md#turn-on-pr-steward-and-add-repositories) |

## 関連リソース

* [プルリクエストで PR Steward を使用する](https://code.claude.com/docs/ja/pr-steward-pull-requests.md)
* [PR Steward をセットアップする](https://code.claude.com/docs/ja/pr-steward-setup.md)
* [PR Steward](https://code.claude.com/docs/ja/pr-steward.md)
