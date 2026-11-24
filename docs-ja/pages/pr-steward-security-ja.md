> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# PR Steward がアクセスできる範囲

> PR Steward が使用する GitHub の ID、権限、リポジトリ、セッションの実行場所、および承認とマージを制限する仕組みを確認します

[PR Steward](https://code.claude.com/docs/ja/pr-steward.md) は、チームの GitHub 上のオープンなプルリクエストに取り組むエージェントです。GitHub 上では [Claude GitHub App](https://github.com/apps/claude) として動作し、各プルリクエストには[クラウドセッション](https://code.claude.com/docs/ja/claude-code-on-the-web.md)で取り組みます。GitHub Enterprise Server では、[組織が作成したアプリ](https://code.claude.com/docs/ja/github-enterprise-server.md#admin-setup)として動作します。

ここで説明するアクセスと制限は、Anthropic がホストする環境でのセッションのものです。セルフホスト環境については、[セルフホスト環境で PR Steward を実行する](https://code.claude.com/docs/ja/pr-steward-setup.md#run-pr-steward-in-a-self-hosted-environment)を参照してください。セッションデータの取り扱いについては、[データの使用](https://code.claude.com/docs/ja/data-usage.md)を参照してください。

## PR Steward の ID と権限

PR Steward のセッションが GitHub 上でアクセスできる範囲を確認し、次にセッション自体の構成を確認します。

### PR Steward の GitHub アクセス

PR Steward のセッションは、その GitHub App として、次のリポジトリ、権限、トークンを使って GitHub 上で動作します：

| 項目 | PR Steward が使用するもの |
| :- | :- |
| リポジトリ | セッションはプルリクエスト自体のリポジトリから開始し、そのリポジトリを読み書きします。github.com 上の GitHub 検索では、組織が PR Steward 用に追加した他の github.com リポジトリの結果が返されることがあります。セッションは github.com 上のパブリックリポジトリを取得できます |
| 権限 | contents、pull requests、issues に対する読み取りと書き込み。アプリのインストールで付与されている場合は、checks と statuses に対する読み取りと Actions に対する書き込みも持ちます。github.com では、インストールで workflows に対する書き込みも付与でき、これにより PR Steward はワークフローファイルへの変更をプッシュできます。アプリの[権限一覧](https://code.claude.com/docs/ja/github-actions.md#github-app-permissions)を参照してください |
| トークン | アプリのトークンはセッションのサンドボックスの外に保持されます。デフォルトでは、セッションの `gh` および `git` のリクエストは Anthropic のサービスを経由し、そこでトークンが付加されます |

### PR Steward のセッション環境

PR Steward のセッションがどこで実行されるか、権限プロンプトをどのように扱うか、どのコメントと指示ファイルを読み取るかを確認します：

| 項目 | セッションの動作 |
| :- | :- |
| コードの実行場所 | [クラウドセッション](https://code.claude.com/docs/ja/claude-code-on-the-web.md)内。[PR Steward が実行される環境](https://code.claude.com/docs/ja/pr-steward-setup.md#choose-the-environment-pr-steward-runs-in)を参照してください |
| 権限プロンプト | セッションは [auto モード](https://code.claude.com/docs/ja/permission-modes.md#eliminate-prompts-with-auto-mode)で開始され、権限の要求は拒否されます |
| コメント | Anthropic のサービスは、プルリクエストの作成者、リポジトリへの書き込みアクセス権を持つユーザー、およびボットによるコメントとレビューをセッションに送信します。セッションがプルリクエストを直接読み取る場合は、他のユーザーがそこに書いた内容も見ることができます |
| 指示ファイル | PR Steward は[デフォルトブランチから読み取ります](https://code.claude.com/docs/ja/pr-steward-pull-requests.md#save-pr-steward-instructions-for-everyone-in-a-repository) |

## 承認とマージに関する制限

Steward は、プルリクエストを承認したりマージしたりしないように設計されています。何かがマージされる前に必要な承認を求めるには、ブランチ保護を使用してください。

Anthropic がホストする環境では、PR Steward のセッションがその GitHub App として行う一部のリクエストを Anthropic のサービスが拒否し、その他のリクエストは GitHub のブランチルールに委ねます。

### Anthropic のサービスが拒否するリクエスト

Anthropic のサービスは、GitHub App として動作する PR Steward のセッションからの次のリクエストを拒否します：

* プルリクエストの承認
* ブランチ保護、ルールセット、またはステータスの変更、あるいはチェック実行の書き込み
* ブランチの削除
* タグのプッシュ

### GitHub のブランチルールに委ねられるリクエスト

Anthropic のサービスは、次のようなリクエストを許可します。ルールが設定されているブランチでは、GitHub のブランチルールがこれらを制御します：

* **マージ、自動マージのオン、強制プッシュ**：GitHub のブランチルールが適用される前に、Claude が実行するコマンドに対して 2 つのチェックが実行されます
* **プルリクエストのブランチ以外のブランチへのプッシュ**：セッションは、そのリポジトリ内で GitHub が Claude GitHub App にプッシュを許可している任意のブランチにプッシュできます
* **レビューの却下**：実行できるユーザーを制限するには、GitHub のブランチルールを使用します。たとえば、クラシックブランチ保護ルールの **Restrict who can dismiss pull request reviews** を使用します

マージ、自動マージのオン、または強制プッシュを行うコマンドには、2 つのチェックが実行されます。権限ルールは、これらの操作に対する通常のコマンドを拒否します。どのルールにも一致しないコマンドは、[auto モードのチェック](https://code.claude.com/docs/ja/permission-modes.md#how-auto-mode-evaluates-actions)が判断します。ルールはコマンドのテキストに対して照合され、チェックはモデルによる判断であるため、別の書き方をしたコマンドは両方を通過する可能性があります。

PR Steward がプッシュした内容に対して GitHub にレビューを強制させるには、[ブランチルールでレビューを必須にし](https://code.claude.com/docs/ja/pr-steward-setup.md#require-reviews-with-branch-rules)、Claude GitHub App を各ルールセットのバイパスリストに含めないようにしてください。クラシックブランチ保護ルールでは、**Allow specified actors to bypass required pull requests** リストに含めないようにしてください。

## 関連リソース

* [PR Steward をセットアップする](https://code.claude.com/docs/ja/pr-steward-setup.md)
* [PR Steward](https://code.claude.com/docs/ja/pr-steward.md)
* [データの使用](https://code.claude.com/docs/ja/data-usage.md)
