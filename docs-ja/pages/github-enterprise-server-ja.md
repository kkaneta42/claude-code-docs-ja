> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# Claude Code と GitHub Enterprise Server

> Claude Code を自社ホストの GitHub Enterprise Server インスタンスに接続して、クラウドセッション、コードレビュー、プラグインマーケットプレイスを利用できます。

> [!NOTE]
>
> GitHub Enterprise Server サポートは Team プランと Enterprise プランで利用できます。

GitHub Enterprise Server（GHES）サポートにより、組織は github.com ではなく自社管理の GitHub インスタンスでホストされているリポジトリで Claude Code を使用できます。Owner が GHES インスタンスを接続すると、開発者はリポジトリごとの設定なしでクラウドセッションを実行し、自動コードレビューを取得できます。インスタンスでホストされているプラグインマーケットプレイスもサポートされており、認証情報の要件は [GHES 上のプラグインマーケットプレイス](#plugin-marketplaces-on-ghes) で説明されているように、サーフェスによって異なります。

github.com 上のリポジトリについては、[クラウドで Claude Code を使用する](https://code.claude.com/docs/ja/claude-code-on-the-web.md) および [コードレビュー](https://code.claude.com/docs/ja/code-review.md) を参照してください。Claude を独自の CI インフラストラクチャで実行するには、[GitHub Actions](https://code.claude.com/docs/ja/github-actions.md) を参照してください。

## GitHub Enterprise Server で動作する機能

以下の表は、Claude Code のどの機能が GHES をサポートしているか、および github.com の動作との違いを示しています。

| 機能 | GHES サポート | 注記 |
| :- | :- | :- |
| クラウドセッション | ✅ サポート | 所有者が GHES インスタンスを 1 回接続すると、開発者は `claude --cloud` または [claude.ai/code](https://claude.ai/code) を使用できます |
| Code Review | ✅ サポート | github.com と同じ自動 PR レビュー |
| Claude Security | ✅ サポート | Enterprise プランの公開ベータで [claude.ai/security](https://claude.ai/security) で利用可能 |
| Teleport セッション | ✅ サポート | `--teleport` で Cloud とターミナル間でセッションを移動 |
| プラグインマーケットプレイス | ✅ サポート | 表面によって認証情報の要件が異なります。[GHES 上のプラグインマーケットプレイス](#plugin-marketplaces-on-ghes)を参照してください |
| 貢献度メトリクス | ❌ サポートなし | github.com でホストされているリポジトリが必要です。[分析ダッシュボード](https://code.claude.com/docs/ja/analytics.md)には、GHES リポジトリでの作業に関する使用状況メトリクスが引き続き表示されます |
| GitHub Actions | ✅ サポート | 手動ワークフロー設定が必要。`/install-github-app` は github.com のみ |
| GitHub MCP サーバー | ❌ サポートなし | GitHub MCP サーバーは GHES インスタンスでは動作しません |

## 管理者セットアップ

Owner は GHES インスタンスを Claude Code に 1 回接続します。Claude 組織で Owner または Primary Owner ロールを持ち、GHES インスタンスで GitHub Apps を作成する権限が必要です。

ガイド付きセットアップは GitHub App マニフェストを生成し、GHES インスタンスにリダイレクトしてアプリをワンクリックで作成します。環境がリダイレクトフローをブロックしている場合は、[代替の手動セットアップ](#manual-setup)が利用可能です。

**1. Git プロバイダー設定を開く**

[**組織設定 > Git プロバイダー**](https://claude.ai/admin-settings/source-control#github-enterprise) にアクセスして、GitHub Enterprise セクションを見つけます。

**2. ガイド付きセットアップを開始する**

**接続** をクリックします（すでにインスタンスが接続されている場合は **インスタンスを追加** をクリックします）。次に **自動でセットアップ** を選択します。接続の表示名（最大 20 文字）と GHES ホスト名（例：`github.example.com`）を入力します。GHES インスタンスが自己署名証明書またはプライベート認証局を使用している場合は、CA 証明書をオプションフィールドに貼り付けます。

**3. GitHub App を作成する**

**GitHub Enterprise に続行** をクリックします。ブラウザが GHES インスタンスにリダイレクトされ、事前入力されたアプリマニフェストが表示されます。設定を確認して **GitHub App を作成** をクリックします。GHES はアプリ認証情報を自動的に保存して Claude に戻します。

**4. リポジトリにアプリをインストールする**

GHES インスタンスの GitHub App ページから、Claude がアクセスしたいリポジトリまたは組織にアプリをインストールします。最初はサブセットで開始して、後で追加できます。

**5. Code Review を有効にする**

[claude.ai/admin-settings/claude-code](https://claude.ai/admin-settings/claude-code) にアクセスし、GHES リポジトリの [Code Review](https://code.claude.com/docs/ja/code-review-setup.md) を github.com と同じ設定を使用して有効にします。

### GitHub App 権限

マニフェストは GitHub App を以下の権限と webhook イベントで設定します。これらは一緒にクラウドセッション、Code Review、Claude Security、およびプラグインマーケットプレイスをカバーします。

| 権限 | アクセス | 用途 |
| :- | :- | :- |
| Contents | 読み取りと書き込み | リポジトリのクローンとブランチのプッシュ |
| Pull requests | 読み取りと書き込み | PR の作成とレビューコメントの投稿 |
| Issues | 読み取りと書き込み | Issue メンションへの応答 |
| Checks | 読み取りと書き込み | コードレビューチェック実行の投稿 |
| Actions | 読み取り | 自動修正の CI ステータスの読み取り |
| Commit statuses | 読み取り | チェック実行の代わりにコミットステータスを報告するプロバイダーから CI ステータスを読み取る |
| Repository hooks | 読み取りと書き込み | [**組織設定 > プラグイン & スキル**](https://claude.ai/admin-settings/skills?tab=marketplaces) でマーケットプレイスの **自動同期** がオンになっている場合、プラグインマーケットプレイスリポジトリに webhook を作成する |
| Metadata | 読み取り | すべてのアプリに GitHub が必須 |
| Organization members | 読み取り | github.com の Claude GitHub App と一致させるため。インストールをリンクするときに接続ユーザーの組織ロールを確認するために使用します |

アプリは `pull_request`、`issue_comment`、`pull_request_review_comment`、`pull_request_review`、`check_run`、および `status` イベントをサブスクライブします。

GitHub はアプリ作成時にのみマニフェストを適用するため、マニフェストの以前のバージョンから作成されたアプリは、作成時の権限とイベントを保持します。アプリが上記の権限またはイベントのいずれかが不足している場合は、GHES インスタンスのアプリ設定で追加します。その後、GitHub は各インストールの所有者に新しい権限を承認するよう求め、インストールは承認されるまで古い権限を保持します。

### 手動セットアップ

ガイド付きリダイレクトフローがネットワーク設定によってブロックされている場合は、**接続** または **インスタンスを追加** をクリックし、**自動でセットアップ** の代わりに **手動で追加** を選択します。GHES インスタンスで [上記の権限とイベント](#github-app-permissions) を使用して GitHub App を作成し、フォームに接続詳細を入力します。表示名、GHES ホスト名とオプションのポート、アプリの ID、クライアント ID、クライアントシークレット、webhook シークレット、および秘密鍵です。フォームはオプションのカスタム CA 証明書と読み取りレプリカホスト名も受け入れます。

Claude は接続を保存するときにアプリの webhook URL を生成します。**設定を追加** をクリックした後、接続の **その他のオプション** メニューを開き、**webhook URL をコピー** を選択して、URL をアプリの webhook 設定に GHES インスタンスで貼り付けます。フォームに入力したのと同じ webhook シークレットを使用します。

### ネットワーク要件

Anthropic ホスト型セッションの場合、GHES インスタンスは Anthropic インフラストラクチャから到達可能である必要があります。これにより Claude はリポジトリをクローンしてレビューコメントを投稿できます。GHES インスタンスがファイアウォールの背後にある場合は、Anthropic の [アウトバウンド IP アドレス](https://platform.claude.com/docs/en/api/ip-addresses#outbound-ip-addresses) をホワイトリストに登録します。[自己ホスト型環境](https://code.claude.com/docs/ja/self-hosted-environments-deploy.md#configure-git) のセッションはネットワーク内からクローンします。ただし、ランナーが [Anthropic git プロキシ](https://code.claude.com/docs/ja/self-hosted-environments-deploy.md#use-the-anthropic-git-proxy) にオプトインする場合は除きます。このプロキシは Anthropic 側からフェッチし、同じ到達可能性が必要です。

リポジトリピッカーなどのホスト型プリセッションフローは、セッション開始前に Anthropic 側で実行されます。セッションが自己ホスト型環境で実行される場合でも、GHES インスタンスが Anthropic インフラストラクチャから到達可能である必要があります。[SCM コネクタ](https://code.claude.com/docs/ja/self-hosted-environments-reference.md#scm-connector-flags) は利用できないため、これらのフローは内部的にのみルーティング可能な GHES ホストに到達できません。

## 開発者ワークフロー

Claude Code は作業ディレクトリの git リモートから GHES ホスト名を自動的に検出します。

通常通り GHES インスタンスからリポジトリをクローンします。`github.example.com` とリポジトリパスを GHES ホスト名とリポジトリに置き換えてください。

```bash theme={null}
git clone git@github.example.com:platform/api-service.git
cd api-service
```

次にクラウドセッションを開始します。Claude は git リモートから GHES ホストを検出し、セッションを組織の設定されたインスタンスを通じてルーティングします。

```bash theme={null}
claude --cloud "Add retry logic to the payment webhook handler"
```

セッションは GHES からリポジトリをクローンし、変更をブランチにプッシュバックします。[claude.ai/code](https://claude.ai/code) で進捗を監視します。差分レビュー、自動修正、クラウドのスケジュールタスクを含む完全なクラウドセッションワークフローについては、[クラウドで Claude Code を使用する](https://code.claude.com/docs/ja/claude-code-on-the-web.md) を参照してください。

### セッションをターミナルに Teleport する

クラウドセッションをローカルターミナルに `claude --teleport` でプルします。Teleport は、ブランチをフェッチしてセッション履歴を読み込む前に、同じ GHES リポジトリのチェックアウトにいることを確認します。詳細については、[teleport 要件](https://code.claude.com/docs/ja/claude-code-on-the-web.md#teleport-requirements) を参照してください。

## GHES 上のプラグインマーケットプレイス

GHES インスタンスでプラグインマーケットプレイスをホストして、組織全体に内部ツールを配布します。マーケットプレイス構造は github.com でホストされているマーケットプレイスと同じですが、マーケットプレイスを追加する場所によってインストール方法が異なり、サーフェス全体で認証情報が異なります。

| サーフェス | インストール方法 | 各ユーザーに必要なもの |
| :- | :- | :- |
| Claude Code CLI とデスクトップ | Claude Code はマシンの既存の git 認証情報を使用してマーケットプレイスリポジトリをクローンします | マシンから GHES ホストへの Git アクセス |
| 管理設定（`extraKnownMarketplaces`） | Claude Code はエントリを登録し、マシンの既存の git 認証情報を使用してリポジトリをクローンします | マシンから GHES ホストへの Git アクセス |
| claude.ai 組織プラグイン設定 | Owner が GHES インスタンスをソースとして選択します。Anthropic のバックエンドが [admin setup](#admin-setup) の GitHub App を使用してリポジトリをフェッチして同期します | 追加後はユーザーごとに不要です。それを追加する Owner は、アクセスチェックとして独自の GitHub Enterprise アカウントを接続する必要があり、GitHub App をマーケットプレイスリポジトリにインストールする必要があります |
| claude.ai ユーザー設定 | Anthropic のバックエンドが送信ユーザーの GitHub Enterprise 接続を使用してリポジトリをフェッチします | Claude に接続された独自の GitHub Enterprise アカウント |
| Cloud sessions | クラウドセッションはセッションサンドボックス内でマーケットプレイスをクローンします。サンドボックスは、セッションのリポジトリが同じインスタンス上にある場合にのみ GHES インスタンスに到達でき、git 認証情報はセッションのリポジトリにスコープされます | GHES でホストされているマーケットプレイスには信頼できません。セッションのリポジトリとは異なるホストに到達できず、同じインスタンスのインストールでも失敗する可能性があります。代わりに CLI、管理設定、または claude.ai を使用してください |

> [!WARNING]
>
> claude.ai 上の GitHub Enterprise 接続は、ユーザー設定からマーケットプレイスが追加される場合、ユーザーごとです。[admin setup](#admin-setup) は GHES インスタンスを組織に接続しますが、個別のユーザーアカウントは接続しません。独自の設定から GHES マーケットプレイスを追加する各ユーザーは、最初に独自の GitHub Enterprise アカウントを接続する必要があり、Owner を含む 1 人のユーザーの接続は他のユーザーをカバーしません。組織プラグイン設定で Owner が追加したマーケットプレイスは、継続的なフェッチが組織の GitHub App を使用するため、ユーザーにこの要件を課しません。マーケットプレイスを追加する Owner は、追加時に独自の GitHub Enterprise アカウントを接続する必要があります。

### GHES マーケットプレイスを追加

`owner/repo` ショートハンドは常に github.com に解決されます。GHES でホストされているマーケットプレイスの場合は、完全な git URL を使用して、`github.example.com` とリポジトリパスを自分のものに置き換えます。HTTPS URL が推奨されます。

```bash theme={null}
/plugin marketplace add https://github.example.com/platform/claude-plugins.git
```

マシンが既に GHES ホストを信頼している場合、SSH URL が機能します。

```bash theme={null}
/plugin marketplace add git@github.example.com:platform/claude-plugins.git
```

Claude Code は git を非対話的に実行し、マシンの `known_hosts` ファイルにないホストへの SSH 接続を拒否します。git 認証情報ヘルパーを備えた HTTPS URL は `known_hosts` 要件を回避します。

マーケットプレイスの構築の完全なガイドについては、[プラグインマーケットプレイスの作成と配布](https://code.claude.com/docs/ja/plugins/create-marketplace.md) を参照してください。

### 管理設定で GHES マーケットプレイスを事前登録

`extraKnownMarketplaces` 設定はマーケットプレイスを事前登録して、開発者が手動セットアップなしでそれを取得できるようにします。これは [任意の設定ファイル](https://code.claude.com/docs/ja/settings-reference.md#extraknownmarketplaces) から機能します。リポジトリの `.claude/settings.json` を含めて、管理設定はそれを組織全体に配信します。

```json theme={null}
{
  "extraKnownMarketplaces": {
    "internal-tools": {
      "source": {
        "source": "git",
        "url": "https://github.example.com/platform/claude-plugins.git"
      }
    }
  }
}
```

Claude Code はこれらのマーケットプレイスをローカルにインストールします。各エントリを登録し、マシンの既存の git 認証情報を使用してリポジトリをクローンします。このパスは claude.ai を通過しないため、ユーザーごとの GitHub Enterprise 接続は不要です。成功したロールアウトのために。

* **完全な git URL を使用します。** `owner/repo` ショートハンドは常に github.com に解決され、GHES ホストを参照できません。
* **HTTPS URL を優先します。** SSH クローンは GHES ホストキーを既に信頼していないマシンで失敗します。組織の標準 git 認証情報ヘルパーを備えた HTTPS URL は、認証情報が設定されているすべてのマシンで機能します。
* **各マシンが GHES ホストからクローンできることを確認します。** マシンに認証情報がない場合、マーケットプレイスは登録されますが、インストールされず、そのプラグインは認証情報を求めるのではなく見つからないと報告されます。
* **設定が各マシンに到達することを確認します。** 管理設定ファイルは、デバイス管理システムを通じて配置されたマシンなど、配置されたマシンにのみ有効です。[管理設定の配信メカニズム](https://code.claude.com/docs/ja/managed-settings.md#delivery-mechanisms) のファイルの場所を参照してください。

### 管理設定で GHES マーケットプレイスをホワイトリストに登録

組織が [管理設定](https://code.claude.com/docs/ja/settings.md) を使用して開発者が追加できるマーケットプレイスを制限している場合は、`hostPattern` ソースタイプを使用して、各リポジトリを列挙することなく GHES インスタンスからすべてのマーケットプレイスを許可します。各プラットフォームのファイルの場所については、[配信メカニズム](https://code.claude.com/docs/ja/managed-settings.md#delivery-mechanisms) を参照してください。JSON を `managed-settings.json` ファイルまたは同等の MDM ポリシーに追加します。

```json theme={null}
{
  "strictKnownMarketplaces": [
    {
      "source": "hostPattern",
      "hostPattern": "^github\\.example\\.com$"
    }
  ]
}
```

完全なスキーマについては、[strictKnownMarketplaces](https://code.claude.com/docs/ja/settings-reference.md#strictknownmarketplaces) および [extraKnownMarketplaces](https://code.claude.com/docs/ja/settings-reference.md#extraknownmarketplaces) 設定リファレンスを参照してください。

## 制限事項

いくつかの機能は GHES では github.com と異なる動作をします。[機能表](#what-works-with-github-enterprise-server) はサポートをまとめています。このセクションでは回避策について説明します。

* **`/install-github-app` コマンド**：claude.ai で [管理者セットアップ](#admin-setup) フローに従ってください。GHES で GitHub Actions ワークフローも必要な場合は、[サンプルワークフロー](https://github.com/anthropics/claude-code-action/blob/main/examples/claude.yml) を手動で適応させてください。
* **GitHub MCP サーバー**：代わりに GHES ホスト用に設定された `gh` CLI を使用してください。`gh auth login --hostname github.example.com` を実行して認証し、Claude はセッションで `gh` コマンドを使用できます。

## トラブルシューティング

### クラウドセッションでリポジトリのクローンに失敗する

`claude --cloud` がクローンエラーで失敗する場合は、Owner が GHES インスタンスのセットアップを完了していること、および作業中のリポジトリに GitHub App がインストールされていることを確認してください。インスタンスを接続した Owner に、Claude の設定に登録されているホスト名が Git リモートのホスト名と一致しているかを確認するよう依頼してください。

セッションが「Authentication failed while accessing the repository」で停止する場合は、自分の GitHub Enterprise アカウントを接続していない可能性があります。[claude.ai/code](https://claude.ai/code) のリポジトリピッカーから接続し、新しいセッションを開始してください。

### マーケットプレイスの追加がポリシーエラーで失敗する

GHES の URL に対して `/plugin marketplace add` がブロックされる場合、組織がマーケットプレイスのソースを制限しています。管理者に依頼して、[管理設定](#allowlist-ghes-marketplaces-in-managed-settings)に GHES ホスト名の `hostPattern` エントリを追加してもらってください。

### claude.ai でのマーケットプレイスの追加が GitHub アクセスエラーで失敗する

ユーザー設定から GHES マーケットプレイスを追加しようとして「Marketplace couldn't be added」のような一般的なエラーで失敗する場合は、まず GitHub Enterprise の接続を確認してください。このエラーは、組織の GHES インスタンスが設定済みで他のユーザーが接続していても、自分の GitHub Enterprise アカウントが Claude に接続されていない場合に表示されます。このダイアログは GitHub Enterprise の接続フローを案内せず、また Browse タブの「Connect to GitHub」オプションは github.com にサインインするものであり、GHES リポジトリへのアクセスは付与されません。

次のいずれかの場所で GitHub Enterprise アカウントを接続してから、マーケットプレイスを再度追加してください。

* **リポジトリピッカー**：[claude.ai/code](https://claude.ai/code) のリポジトリピッカーには、設定済みの各 GHES インスタンスに対する接続オプションがあります。
* **Git providers ページ**：Owner の場合は、[**Organization settings > Git providers**](https://claude.ai/admin-settings/source-control) の GitHub セクションに移動して **Connect** をクリックするか、アカウントが接続済みであれば **Add organization** をクリックします。**GitHub instance** で GHES ホスト名を選択し、**Connect** をクリックします。

または、Owner に依頼して組織のプラグイン設定でマーケットプレイスを追加してもらうこともできます。この方法では、ユーザーごとの接続は不要になります。

claude.ai の他のサーフェスで、GHES マーケットプレイスに対して「Repository not found. If it's private, GitHub access is required」エラーが表示される場合も、通常は同じく接続が不足していることを示しています。上記のいずれかの方法で GitHub Enterprise アカウントを接続してから、再度お試しください。

### GHES インスタンスに到達できない

レビューや Anthropic がホストするクラウドセッションがタイムアウトする場合、Anthropic のインフラストラクチャから GHES インスタンスに到達できない可能性があります。ファイアウォールが Anthropic の[送信元 IP アドレス](https://platform.claude.com/docs/en/api/ip-addresses#outbound-ip-addresses)からのインバウンド接続を許可していることを確認してください。[セルフホスト環境](https://code.claude.com/docs/ja/self-hosted-environments)のセッションはネットワーク内部から GHES に到達するため、そうしたセッションでクローンできない場合は、代わりにランナー自体のネットワーク経路を確認してください。リポジトリピッカーやその他のホスト型のセッション開始前フローについては、[ネットワーク要件](#network-requirements)を参照してください。

### 接続テストは成功するが 2 回目のテストが失敗する

2 回目のテストは、Anthropic がホストするクラウドセッションと同じ方法で GHES インスタンスに接続します。表示されたメッセージを探し、ファイアウォールを確認すべきか再試行すべきかを確認してください。

* **`Connection test passed, but a second test failed.`**：インスタンスがファイアウォールの内側にある場合は、Anthropic のすべての[送信元 IP アドレス](https://platform.claude.com/docs/en/api/ip-addresses#outbound-ip-addresses)を許可してください。ファイアウォールがその一部をブロックしていても、接続テストが成功することがあるためです。数分後に再試行することもできます。
* **`Connection test passed, but a second test could not run.`**：数分後に再試行してください。

再度テストするには、[**Organization settings > Git providers**](https://claude.ai/admin-settings/source-control#github-enterprise) で接続の **More options** メニューを開き、**Test connection** を選択します。

### セッションの開始が `Unable to get organization UUID` で失敗する

Claude Code が認証情報から claude.ai の組織を読み取れませんでした。GitHub Enterprise Server のサポートは Team プランと Enterprise プランに限定されているため、Team または Enterprise 組織のアカウントを使用して `/login` でサインインしてください。原因およびこの状態で表示されるその他のメッセージについては、[Unable to get organization UUID](https://code.claude.com/docs/ja/claude-code-on-the-web.md#unable-to-get-organization-uuid) を参照してください。

## 関連リソース

これらのページは、このガイド全体で参照されている機能をより詳しく説明しています。

* [クラウドで Claude Code を使用](https://code.claude.com/docs/ja/claude-code-on-the-web.md)：クラウドインフラストラクチャで Claude Code セッションを実行
* [Code Review](https://code.claude.com/docs/ja/code-review.md)：自動 PR レビュー
* [プラグインマーケットプレイス](https://code.claude.com/docs/ja/plugins/host-marketplace.md)：プラグインカタログの構築と配布
* [分析](https://code.claude.com/docs/ja/analytics.md)：組織全体での Claude Code の使用状況の追跡
* [管理設定](https://code.claude.com/docs/ja/settings.md)：組織全体のポリシー設定
* [ネットワーク設定](https://code.claude.com/docs/ja/network-config.md)：ファイアウォールと IP ホワイトリストの要件
