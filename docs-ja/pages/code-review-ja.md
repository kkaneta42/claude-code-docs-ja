> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# Code Review

> Code Review で GitHub のプルリクエストのバグを検出します。Claude が各変更をレビューし、結果を検証して、インラインでコメントします。Team および Enterprise プラン向けです

Code Review を使用すると、Claude が GitHub リポジトリのプルリクエストをレビューします。複数のエージェントが各変更を周囲のコードとあわせて読み込み、ロジックエラー、セキュリティ脆弱性、壊れたエッジケースなどの問題を探します。検証ステップでは、結果を報告する前にコードと照らし合わせて確認します。

結果は該当する行へのインラインコメントとして届き、[重大度](/docs/ja/code-review-pull-requests#severity-levels)でランク付けされ、プルリクエストには概要とチェック実行が追加されます。レビューがプルリクエストを承認またはブロックすることはないため、マージの判断はチームに委ねられたままです。

<img src="https://mintcdn.com/claude-code/gLJVaPQEgKC8ZyUD/images/code-review-pipeline.svg?fit=max&auto=format&n=gLJVaPQEgKC8ZyUD&q=85&s=0351c96df9efa3105172eb00a672f130" className="dark:hidden" alt="4 段階のレビューの図。GitHub 上のプルリクエストが、Anthropic インフラストラクチャ上で並行して探索する複数のエージェントに渡されます。検証ステップで偽陽性が除外され、残った結果は重複排除されて重大度でランク付けされ、レビューはインラインコメント、概要、チェック実行を GitHub に投稿します。" width="760" height="300" data-path="images/code-review-pipeline.svg" />

<img src="https://mintcdn.com/claude-code/gLJVaPQEgKC8ZyUD/images/code-review-pipeline-dark.svg?fit=max&auto=format&n=gLJVaPQEgKC8ZyUD&q=85&s=9cf26bde98f4e999d0d9ff5bf5bdff40" className="hidden dark:block" alt="4 段階のレビューの図。GitHub 上のプルリクエストが、Anthropic インフラストラクチャ上で並行して探索する複数のエージェントに渡されます。検証ステップで偽陽性が除外され、残った結果は重複排除されて重大度でランク付けされ、レビューはインラインコメント、概要、チェック実行を GitHub に投稿します。" width="760" height="300" data-path="images/code-review-pipeline-dark.svg" />

<Note>
  Code Review は AI を使用してコードをレビューするため、バグ、セキュリティ脆弱性、その他の問題を見逃す可能性があります。結果のないレビューは、コードにエラーがないことや安全であることを意味するものではありません。
</Note>

<span id="review-a-diff-locally" />

Code Review をオンにするには、Claude 組織の Owner が [Code Review のセットアップ](/docs/ja/code-review-setup)の手順に従います。Claude はこのサービスを使わずにコードをレビューすることもできます。任意のプランで Claude Code セッションから [`/code-review`](/docs/ja/code-review-local) を実行するか、[すべてのオプションを比較](#compare-ways-to-get-a-review)してください。

<h2 id="availability">
  利用可能性
</h2>

Code Review をセットアップする前に、組織が条件を満たしていることを確認してください：

* **プラン**：[Team および Enterprise](/docs/ja/feature-availability)
* **コードホスト**：GitHub でホストされているリポジトリ。[GitHub Enterprise Server](/docs/ja/github-enterprise-server) およびデータレジデンシー付きの GitHub Enterprise Cloud を含みます。データレジデンシーの場合は、Owner が [GitHub Enterprise Server の管理者セットアップ](/docs/ja/github-enterprise-server#admin-setup)の手順に従い、エンタープライズの `ghe.com` ホスト名を入力します。
* **データ保持**：Code Review は、[Zero Data Retention](/docs/ja/zero-data-retention) が有効になっている組織や [HIPAA 設定](/docs/ja/hipaa-setup)が適用されている組織では利用できず、Anthropic の Business Associate Agreement（BAA）の対象外です。
* **暗号化キー**：Code Review は、顧客管理の暗号化キー（CMEK）を使用する組織ではまだ利用できません。
* **クラウドプロバイダー**：開発者が Amazon Bedrock、Google Cloud の Agent Platform、または Microsoft Foundry を通じて Claude Code を使用している場合でも、これらのいずれかのプランの Claude 組織が必要です

<h2 id="set-up-and-use-code-review">
  Code Review のセットアップと使用
</h2>

<span id="set-up-code-review" />

<span id="pricing" />

<span id="manually-trigger-reviews" />

<span id="customize-reviews" />

<span id="troubleshooting" />

目的に応じたページを選んでください：

<CardGroup cols={2}>
  <Card title="Code Review をセットアップする" icon="toggle-on" href="/docs/ja/code-review-setup">
    要件を確認し、Claude GitHub App をインストールして、リポジトリ、レビューレベル、レビューを実行するタイミングを選択します
  </Card>

  <Card title="Code Review をカスタマイズする" icon="sliders" href="/docs/ja/code-review-customize">
    リポジトリ内の `REVIEW.md` と `CLAUDE.md` ファイルで、指摘される内容を調整します
  </Card>

  <Card title="プルリクエストでレビューを読み、リクエストする" icon="code-pull-request" href="/docs/ja/code-review-pull-requests">
    結果とその重大度を読み、コメントで再度レビューをリクエストします
  </Card>

  <Card title="Code Review のトラブルシューティング" icon="wrench" href="/docs/ja/code-review-troubleshooting">
    開始されなかったレビュー、失敗したレビュー、予算のためにスキップされたレビューを修正します
  </Card>

  <Card title="Code Review のコストと使用状況" icon="chart-line" href="/docs/ja/code-review-costs">
    レビューの課金方法の確認、支出の見積もり、月間支出上限の設定、レビューアクティビティの追跡を行います
  </Card>
</CardGroup>

<h2 id="how-reviews-work">
  レビューの仕組み
</h2>

<span id="what-code-review-checks" />

デフォルトでは、Code Review は正確性に焦点を当てています：フォーマット設定の好みやテストカバレッジの欠落ではなく、本番環境を壊すバグです。指摘する内容を変更するには、リポジトリに[ガイダンスファイルを追加](/docs/ja/code-review-customize)します。

レビューは Anthropic インフラストラクチャ上で 4 つの段階で実行されます：

1. **検出**：複数のエージェントが差分と周囲のコードを並行して検査します。
2. **検証**：検証ステップが候補となる結果をコードと照らし合わせて確認し、偽陽性を除外します。
3. **ランク付け**：残った結果は重複排除され、重大度でランク付けされます。
4. **投稿**：レビューがプルリクエストに結果を投稿します。

各レビューはプルリクエストに以下を残します：

* **結果**：該当する行へのインラインコメントと、レビュー本文の概要
* **チェック実行**：**Claude Code Review** という名前で、結果はその[詳細](/docs/ja/code-review-pull-requests#check-run-output)に一覧表示されます。チェック実行が失敗として完了することはありません。
* **何も見つからなかった場合**：チェック実行のタイトルは **Code review found no issues** となり、Claude は同じ短いメモをプルリクエストに投稿します

Code Review はレビューを実行する Claude モデルを選択し、その管理設定にモデルの選択肢はありません。レビューの徹底度を上げたり下げたりするには、[レビューレベル](#review-levels)を変更します。

Owner が Code Review をオンにすると、各リポジトリに[レビューを実行するタイミング](/docs/ja/code-review-setup#set-when-reviews-run)の設定が用意されます：プルリクエストが開かれたときに 1 回、プッシュのたび、またはリクエスト時のみです。どの設定であっても、リポジトリへの書き込みアクセス権を持つユーザーは、プルリクエストに `@claude review` とコメントして[レビューを開始](/docs/ja/code-review-pull-requests#comment-commands)できます。

<h3 id="review-levels">
  レビューレベル
</h3>

レビューレベルは各レビューの徹底度を設定し、徹底したレビューほどコストが高くなります：

* **Quick**：軽めのチェックです。最も速く、コストも最も低いレベルです。
* **Standard**：深さ、速度、コストのバランスが取れています。デフォルトのレベルです。
* **Deep**：最も徹底したチェックです。最も時間がかかり、コストも最も高くなります。

Owner は[組織に 1 つのレベルを選択](/docs/ja/code-review-setup#set-the-default-review-level)し、個々のリポジトリに独自のレベルを設定できます。たとえば、日常的なコードベースには Quick、重要なコードベースには Deep を設定します。各レビューのコストに影響するその他の要因については、[Code Review のコストと使用状況](/docs/ja/code-review-costs)を参照してください。

<h3 id="what-a-review-can-access">
  レビューがアクセスできるもの
</h3>

レビューは、Owner が[セットアップ中にインストール](/docs/ja/code-review-setup#turn-on-code-review)した Claude GitHub App を通じてリポジトリにアクセスします：

* **実行場所**：Anthropic インフラストラクチャ上のマネージド環境です。レビューは[セルフホスト環境](/docs/ja/self-hosted-environments)では実行されません。
* **読み書きするもの**：レビュー内ではリポジトリへのアクセスは読み取り専用で、レビューがコミットをプッシュすることはありません。プルリクエスト上では、コメントと[チェック実行](/docs/ja/code-review-pull-requests#check-run-output)を投稿し、自身の以前のコメントスレッドを解決し、コメントコマンドに 👀 でリアクションできます。アプリ自体は、他の Claude 機能と共有する[より広い権限セット](/docs/ja/github-actions#github-app-permissions)を持っています。
* **コードの検査方法**：レビューは差分と周囲のコードを読むことで行われ、コードをビルドしたり実行したりはしません。

<h3 id="who-controls-a-review">
  レビューを制御する人
</h3>

* **開始できる人**：レビューが自動で実行される設定では、プルリクエストを開くかプッシュするとレビューが開始されます。[ただしドラフトとフォークは除きます](/docs/ja/code-review-pull-requests#review-drafts-and-pull-requests-from-forks)。[コメントコマンド](/docs/ja/code-review-pull-requests#comment-commands)は、リポジトリへの書き込みアクセス権を持つユーザーからのものである場合にのみレビューを開始します。
* **従う指示**：ベースブランチまたはデフォルトブランチの `REVIEW.md` で、[プルリクエスト自体の変更からは決して読み取りません](/docs/ja/code-review-customize#which-branch-review-md-is-read-from)。

<h2 id="compare-ways-to-get-a-review">
  レビューを受ける方法の比較
</h2>

利用できるオプションを見つけるには、**利用できるユーザー**列をプランとコードホストに照らし合わせて確認してください：

| オプション | レビューを開始するもの | 実行場所 | 利用できるユーザー |
| :- | :- | :- | :- |
| [Code Review](#how-reviews-work) | 各リポジトリの設定に応じたプルリクエストのアクティビティ、または `@claude review` コメント | Anthropic インフラストラクチャ | GitHub リポジトリを持つ Team または Enterprise プランの組織（Owner がオンにした後） |
| [`/code-review`](/docs/ja/code-review-local) | ユーザーがブランチでコマンドを実行 | ユーザーの Claude Code セッション | すべてのプランの誰でも |
| [Ultrareview](/docs/ja/ultrareview) | ユーザーが Claude Code から開始 | クラウドサンドボックス | claude.ai アカウントでのサインインが必要です。利用できない環境については [Ultrareview](/docs/ja/ultrareview) を参照してください |
| [GitHub Actions](/docs/ja/github-actions) または [GitLab CI/CD](/docs/ja/gitlab-ci-cd) を使用した独自の CI での Claude | すべてのプルリクエストやマージリクエストなど、パイプラインのイベント | 独自の CI ランナー | GitHub または GitLab 上で、Claude API キーまたはクラウドプロバイダーの認証情報を持つ誰でも |
| [サブエージェント](/docs/ja/sub-agents)または[スキル](/docs/ja/skills)としての独自のレビュアー | セッション中にユーザーまたは Claude が呼び出す | Claude Code を実行する場所 | それを作成した誰でも |

<h2 id="related-resources">
  関連リソース
</h2>

* [GitHub Enterprise Server](/docs/ja/github-enterprise-server)：セルフホストの GitHub インスタンスで Code Review を使用する
* [GitHub App permissions](/docs/ja/github-actions#github-app-permissions)：Claude GitHub App が要求する権限の完全なセット
* [How Anthropic secures its AI-native software development lifecycle](https://claude.com/blog/how-anthropic-secures-its-ai-native-software-development-lifecycle)：自動レビューが Anthropic のセキュアな開発プロセスの 1 つのレイヤーとしてどのように適合するか
