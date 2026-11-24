> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# Claude Approvals のトラブルシューティング

> 表示されない、または合格しない Claude Approvals チェック、Approvals が拒否するポリシーファイル、回答を返さない分類器を修正します

[Claude Approvals](https://code.claude.com/docs/ja/approvals.md) は、GitHub のプルリクエストに対して、誰の承認がまだ必要かを報告するチェックです。チェックが表示されない、または合格しない場合、Approvals がポリシーファイルを拒否する場合、または分類器が回答を返さない場合は、ここから始めてください。

プルリクエストの **Claude Approvals** チェックのタイトルがここで扱われていない場合は、[承認ステータスと次に行うことを確認する](https://code.claude.com/docs/ja/approvals-pull-requests.md#find-your-approval-status-and-what-to-do-next)を参照してください。

## Claude Approvals チェックが表示されない

[Claude Approvals](https://code.claude.com/docs/ja/approvals.md) が実行できない場合、何も投稿されないことがあります。

### プルリクエストとポリシーファイルを確認する

まず、自分で確認できる原因から始めます。

| 原因 | 対処方法 |
| :- | :- |
| プルリクエストがドラフトである | レビュー準備完了としてマークします |
| [ポリシーファイル](https://code.claude.com/docs/ja/approvals-policy.md#where-to-put-a-policy-file)が Approvals の参照する場所にない | デフォルトブランチ上のリポジトリのルートにある `.claude/approvals.yml` に、`version: 1` を指定して配置します |
| ファイルがマージされてから何も起きていない | プルリクエストにコミットをプッシュします |
| ポリシーが observe モードで、プルリクエストがデフォルトブランチ以外のブランチを対象としている | プルリクエストがポリシーファイルまたは分類器ファイルを変更する場合を除き、チェックは表示されません |
| ポリシーが適用されており、プルリクエストが変更するどのファイルもルールの対象になっていない | [ルールの対象にならないファイルがある場合の動作](https://code.claude.com/docs/ja/approvals-policy.md#how-rules-combine-into-one-verdict)を参照してください |

### Claude がコメントを残したが Approvals チェックがない

Claude のコメントの文言を見つけ、その横にある対処を行います。

| コメントの内容 | 対処方法 |
| :- | :- |
| Approvals "did not run on this change" | コメントの指示に従います。原因の 1 つは、ポリシーのルールが対象とするパスへ、またはそのパスからファイルを移動するプルリクエストです。その移動は 2 つのプルリクエストに分けて行います。1 つは新しい名前でファイルを追加し、もう 1 つは古いファイルを削除します |
| "More than one Claude organization is connected to this GitHub account" | Approvals を実行する Claude 組織の Owner に、[**Organization settings > Claude Ship**](https://claude.ai/admin-settings/claude-ship) でリポジトリの GitHub 組織の横にある **Connect** をクリックするよう依頼します。その後、コミットをプッシュします |
| "Claude Approvals can't start in this repository yet" | 組織に利用可能な使用クレジットがないことを Owner に伝えます |

### Owner に Claude 組織の確認を依頼する

Owner に、Claude 組織について次の各項目を確認するよう依頼します。

| 確認する内容 | 場所 |
| :- | :- |
| 組織が対象条件を満たしているか | [利用条件](https://code.claude.com/docs/ja/approvals.md#availability) |
| [Claude GitHub App](https://github.com/apps/claude) がリポジトリにアクセスでき、リンクされているか | [**Organization settings > Git providers**](https://claude.ai/admin-settings/source-control) |
| ここで Approvals がオフになっていないか | [**Organization settings > Claude Ship**](https://claude.ai/admin-settings/claude-ship) の **Approvals** 列と **Approve** 行 |

## レビュースレッドを解決しても Approvals が合格しない

ポリシーの [`findings`](https://code.claude.com/docs/ja/approvals-policy#findings) リストに自分の名前が含まれているか確認します。

自分による解決がカウントされない場合は、修正をプッシュするか、リストに含まれる人にスレッドの解決を依頼します。

## Approvals は合格したが GitHub がまだマージをブロックしている

GitHub のマージボックスに表示されているルールを確認します。レビューを求めている場合、ポリシーでは不要なレビューが GitHub のブランチルールで必要とされているため、作成者以外の人に GitHub のレビューで承認してもらいます。GitHub が何をカウントするかについては、[必須レビューと CODEOWNERS](https://code.claude.com/docs/ja/approvals-github-rules.md#required-reviews-and-codeowners) を参照してください。

## Approvals が拒否するポリシーファイルを修正する

**Claude Approvals** チェックのタイトルを次の表で探します。

| タイトル | 問題のあるコピー | メッセージ | 対処方法 |
| :- | :- | :- | :- |
| **This change breaks a policy file** | プルリクエスト自体のもの | チェックのサマリー内の **Policy files in this change** | このプルリクエストで修正します |
| **Default branch policy file cannot be used**、**Default branch policy file must be version 1**、**Default branch policy file is too large** | デフォルトブランチ上のルートポリシーファイル | チェックのサマリー | このリポジトリのブランチから新しいプルリクエストを作成して修正します。そのプルリクエストの **Policy files in this change** で、新しいコピーが読み込まれるかどうかを確認できます。observe モードでも適用時でも、すべてのプルリクエストのチェックと同様に、そのプルリクエストのチェックも失敗します。ブランチでチェックが必須になっている場合は、ブランチルールをバイパスできる人にマージを依頼します |
| **A policy file cannot be used** | デフォルトブランチ上のディレクトリのポリシーファイル | チェックのサマリー | ルートポリシーファイルと同じ方法で修正します |

修正がマージされたら 5 分待ち、チェックが更新されていない各オープンなプルリクエストに [`@claude approvals rerun`](https://code.claude.com/docs/ja/approvals-pull-requests#comment-commands-for-approvals) とコメントします。フォークからのプルリクエストの場合は、[まず変更内容を確認し、最新コミットの完全な SHA を追加します](https://code.claude.com/docs/ja/approvals-pull-requests.md#pull-requests-from-forks-and-outside-contributors)。

### ポリシーファイルの拒否メッセージ

1 つの拒否によってポリシーファイル全体が使用できなくなります。警告では何も失敗しません。

メッセージの冒頭をここで探します。

| メッセージ | 修正方法 |
| :- | :- |
| "no key of this name is read at this place" | キーのスペルと階層を、[トップレベルキー](https://code.claude.com/docs/ja/approvals-policy.md#top-level-keys)と[ルールキー](https://code.claude.com/docs/ja/approvals-policy.md#rule-keys)と照らし合わせて確認します |
| "this names no fact and no usable classifier" | 名前を [facts](https://code.claude.com/docs/ja/approvals-policy.md#if) と照らし合わせて確認します。`repo/<name>` の場合は、ポリシーファイルと同じ場所またはその上位のディレクトリにある `.claude/classifiers/<name>/def.yml` が読み込まれることを確認します |
| "a condition has no NOT" | 反対の演算子を記述します |
| "no local has this name" | このファイルまたはその上位のポリシーファイルで local を定義します。ログイン名やチームは `@` を付けずに記述します |
| "this is not YAML" | メッセージが示す行の付近で、閉じられていない引用符や括弧、またはタブがないか確認します。インデントにはスペースを使用します |

## 分類器が回答を返さない、またはその定義が拒否される

各[分類器](https://code.claude.com/docs/ja/approvals-classifiers.md)の実行状態と回答がない理由を確認するには、プルリクエスト上の Claude のコメントにある **Classifier results** を開きます。実行が予算に達した場合は、プルリクエストを分割するか、[上限](https://code.claude.com/docs/ja/approvals-classifiers.md#budget)を下回っている `time` または `cost` を引き上げます。

次に、**Claude Approvals** チェックのタイトルをここで探します。

| タイトル | 対処方法 |
| :- | :- |
| **A classifier definition is not valid**、またはポリシーファイルがその分類器を指定している場合の **This change breaks a policy file** | このプルリクエストで定義を修正します。拒否メッセージは **Policy files in this change** の下にあります |
| **A classifier's definition cannot be used** | デフォルトブランチ上の定義を修正します。定義を変更するプルリクエストで、拒否される理由が表示されます |
| **Cannot evaluate: classifier outside advisory** | サブディレクトリにポリシーファイルがある場合、一部のカスタム分類器は [`advisory` の下にのみ配置できます](https://code.claude.com/docs/ja/approvals-policy#policy-files-in-subdirectories)。分類器をそこに移動します |
| 分類器の名前を含む **repo/change\_risk reached its run limit**、または **A classifier reached its run limit** | 差分に変更をプッシュします。または `@claude approvals rerun` とコメントしてもう 1 回実行します。この場合、合格したものを含むすべての分類器の結果が破棄される可能性があります |

## 関連リソース

* [プルリクエストで Claude Approvals を使用する](https://code.claude.com/docs/ja/approvals-pull-requests.md): チェックのタイトルとコメントコマンド
* [Claude Approvals をセットアップする](https://code.claude.com/docs/ja/approvals-setup.md): 要件、スターターポリシー、必須チェック
* [Claude Approvals ポリシーファイルリファレンス](https://code.claude.com/docs/ja/approvals-policy.md): ポリシーファイルのキー
