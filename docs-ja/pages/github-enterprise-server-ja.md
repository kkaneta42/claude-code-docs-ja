> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# Claude Code と GitHub Enterprise Server

> Claude Code を自社ホストの GitHub Enterprise Server インスタンスに接続して、Web セッション、コードレビュー、プラグインマーケットプレイスを利用できます。

<Note>
  GitHub Enterprise Server サポートは Team プランと Enterprise プランで利用できます。
</Note>

GitHub Enterprise Server（GHES）サポートにより、組織は github.com ではなく自社管理の GitHub インスタンスでホストされているリポジトリで Claude Code を使用できます。管理者が GHES インスタンスを接続すると、開発者はリポジトリごとの設定なしで Web セッションを実行し、自動コードレビューを取得し、内部マーケットプレイスからプラグインをインストールできます。

github.com 上のリポジトリについては、[Claude Code on the web](/ja/claude-code-on-the-web) および [Code Review](/ja/code-review) を参照してください。Claude を独自の CI インフラストラクチャで実行するには、[GitHub Actions](/ja/github-actions) を参照してください。

<h2 id="what-works-with-github-enterprise-server">
  GitHub Enterprise Server で動作する機能
</h2>

以下の表は、Claude Code のどの機能が GHES をサポートしているか、および github.com の動作との違いを示しています。

| 機能                     | GHES サポート | 注記                                                                                                         |
| :--------------------- | :-------- | :--------------------------------------------------------------------------------------------------------- |
| Claude Code on the web | ✅ サポート    | 管理者が GHES インスタンスを 1 回接続すると、開発者は通常通り `claude --remote` または [claude.ai/code](https://claude.ai/code) を使用できます |
| Code Review            | ✅ サポート    | github.com と同じ自動 PR レビュー                                                                                   |
| Claude Security        | ✅ サポート    | Enterprise プランの公開ベータで [claude.ai/security](https://claude.ai/security) で利用可能                               |
| Teleport セッション         | ✅ サポート    | `--teleport` で Web とターミナル間でセッションを移動                                                                        |
| プラグインマーケットプレイス         | ✅ サポート    | `owner/repo` ショートハンドの代わりに完全な git URL を使用                                                                   |
| 貢献度メトリクス               | ✅ サポート    | [分析ダッシュボード](/ja/analytics) への Webhook 経由で配信                                                                |
| GitHub Actions         | ✅ サポート    | 手動ワークフロー設定が必要。`/install-github-app` は github.com のみ                                                        |
| GitHub MCP サーバー        | ❌ サポートなし  | GitHub MCP サーバーは GHES インスタンスでは動作しません                                                                       |

<h2 id="admin-setup">
  管理者セットアップ
</h2>

管理者が GHES インスタンスを Claude Code に 1 回接続します。その後、組織の開発者は追加の設定なしで GHES リポジトリを使用できます。Claude 組織への管理者アクセスと、GHES インスタンスで GitHub App を作成する権限が必要です。

ガイド付きセットアップは GitHub App マニフェストを生成し、GHES インスタンスにリダイレクトして 1 クリックでアプリを作成します。環境がリダイレクトフローをブロックしている場合は、[代替手動セットアップ](#manual-setup) が利用可能です。

<Steps>
  <Step title="Claude Code 管理者設定を開く">
    [claude.ai/admin-settings/claude-code](https://claude.ai/admin-settings/claude-code) にアクセスして、GitHub Enterprise Server セクションを見つけます。
  </Step>

  <Step title="ガイド付きセットアップを開始">
    **Connect** をクリックします。接続の表示名と GHES ホスト名（例：`github.example.com`）を入力します。GHES インスタンスが自己署名証明書またはプライベート認証局を使用している場合は、CA 証明書をオプションフィールドに貼り付けます。
  </Step>

  <Step title="GitHub App を作成">
    **Continue to GitHub Enterprise** をクリックします。ブラウザが事前入力されたアプリマニフェストを含む GHES インスタンスにリダイレクトされます。設定を確認して **Create GitHub App** をクリックします。GHES はアプリ認証情報が自動的に保存された状態で Claude にリダイレクトします。
  </Step>

  <Step title="リポジトリにアプリをインストール">
    GHES インスタンスの GitHub App ページから、Claude がアクセスする必要があるリポジトリまたは組織にアプリをインストールします。最初はサブセットで開始して、後で追加できます。
  </Step>

  <Step title="機能を有効化">
    [claude.ai/admin-settings/claude-code](https://claude.ai/admin-settings/claude-code) に戻り、GHES リポジトリの [Code Review](/ja/code-review#set-up-code-review)、Claude Security、および [貢献度メトリクス](/ja/analytics#enable-contribution-metrics) を github.com と同じ設定で有効化します。
  </Step>
</Steps>

<h3 id="github-app-permissions">
  GitHub App の権限
</h3>

マニフェストは、Web セッション、Code Review、Claude Security、および貢献度メトリクス全体で Claude が必要とする権限と Webhook イベントで GitHub App を設定します。

| 権限               | アクセス      | 用途                    |
| :--------------- | :-------- | :-------------------- |
| Contents         | 読み取りと書き込み | リポジトリのクローンとブランチのプッシュ  |
| Pull requests    | 読み取りと書き込み | PR の作成とレビューコメントの投稿    |
| Issues           | 読み取りと書き込み | Issue メンションへの応答       |
| Checks           | 読み取りと書き込み | Code Review チェック実行の投稿 |
| Actions          | 読み取り      | 自動修正用の CI ステータスの読み取り  |
| Repository hooks | 読み取りと書き込み | 貢献度メトリクス用の Webhook 受信 |
| Metadata         | 読み取り      | すべてのアプリで GitHub が必須   |

アプリは `pull_request`、`issue_comment`、`pull_request_review_comment`、`pull_request_review`、および `check_run` イベントをサブスクライブします。

<h3 id="manual-setup">
  手動セットアップ
</h3>

ネットワーク設定によってガイド付きリダイレクトフローがブロックされている場合は、Connect の代わりに **Add manually** をクリックします。[上記の権限とイベント](#github-app-permissions) を使用して GHES インスタンスで GitHub App を作成し、フォームにアプリ認証情報を入力します。ホスト名、OAuth クライアント ID とシークレット、GitHub App ID、クライアント ID、クライアントシークレット、Webhook シークレット、および秘密鍵です。

<h3 id="network-requirements">
  ネットワーク要件
</h3>

GHES インスタンスは Anthropic インフラストラクチャから到達可能である必要があります。これにより Claude はリポジトリをクローンしてレビューコメントを投稿できます。GHES インスタンスがファイアウォールの背後にある場合は、[Anthropic API IP アドレス](https://platform.claude.com/docs/en/api/ip-addresses) をホワイトリストに登録します。

<h2 id="developer-workflow">
  開発者ワークフロー
</h2>

管理者が GHES インスタンスを接続した後、開発者側の設定は不要です。Claude Code は作業ディレクトリの git リモートから GHES ホスト名を自動的に検出します。

通常通り GHES インスタンスからリポジトリをクローンします。

```bash theme={null}
git clone git@github.example.com:platform/api-service.git
cd api-service
```

次に Web セッションを開始します。Claude は git リモートから GHES ホストを検出し、セッションを組織の設定されたインスタンスを通じてルーティングします。

```bash theme={null}
claude --remote "Add retry logic to the payment webhook handler"
```

セッションは Anthropic インフラストラクチャで実行され、GHES からリポジトリをクローンし、変更をブランチにプッシュバックします。`/tasks` で、または [claude.ai/code](https://claude.ai/code) で進捗を監視します。diff レビュー、自動修正、ルーチンを含む完全なリモートセッションワークフローについては、[Claude Code on the web](/ja/claude-code-on-the-web) を参照してください。

<h3 id="teleport-sessions-to-your-terminal">
  セッションをターミナルに Teleport
</h3>

`claude --teleport` で Web セッションをローカルターミナルにプルします。Teleport は、ブランチをフェッチしてセッション履歴を読み込む前に、同じ GHES リポジトリのチェックアウトにいることを確認します。詳細については、[teleport 要件](/ja/claude-code-on-the-web#teleport-requirements) を参照してください。

<h2 id="plugin-marketplaces-on-ghes">
  GHES 上のプラグインマーケットプレイス
</h2>

GHES インスタンスでプラグインマーケットプレイスをホストして、組織全体に内部ツールを配布します。マーケットプレイス構造は github.com でホストされているマーケットプレイスと同じです。唯一の違いはそれらを参照する方法です。

<h3 id="add-a-ghes-marketplace">
  GHES マーケットプレイスを追加
</h3>

`owner/repo` ショートハンドは常に github.com に解決されます。GHES でホストされているマーケットプレイスの場合は、完全な git URL を使用します。

```bash theme={null}
/plugin marketplace add git@github.example.com:platform/claude-plugins.git
```

HTTPS URL も機能します。

```bash theme={null}
/plugin marketplace add https://github.example.com/platform/claude-plugins.git
```

マーケットプレイスの構築の完全なガイドについては、[プラグインマーケットプレイスの作成と配布](/ja/plugin-marketplaces) を参照してください。

<h3 id="allowlist-ghes-marketplaces-in-managed-settings">
  管理設定で GHES マーケットプレイスをホワイトリストに登録
</h3>

組織が [管理設定](/ja/settings) を使用して開発者が追加できるマーケットプレイスを制限している場合は、`hostPattern` ソースタイプを使用して、各リポジトリを列挙することなく GHES インスタンスからすべてのマーケットプレイスを許可します。

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

開発者向けにマーケットプレイスを事前登録して、手動セットアップなしで表示されるようにすることもできます。この例は、内部ツールマーケットプレイスを組織全体で利用可能にします。

```json theme={null}
{
  "extraKnownMarketplaces": {
    "internal-tools": {
      "source": {
        "source": "git",
        "url": "git@github.example.com:platform/claude-plugins.git"
      }
    }
  }
}
```

完全なスキーマについては、[strictKnownMarketplaces](/ja/settings#strictknownmarketplaces) および [extraKnownMarketplaces](/ja/settings#extraknownmarketplaces) 設定リファレンスを参照してください。

<h2 id="limitations">
  制限事項
</h2>

いくつかの機能は GHES では github.com と異なる動作をします。[機能表](#what-works-with-github-enterprise-server) はサポートをまとめています。このセクションでは回避策について説明します。

* **`/install-github-app` コマンド**：claude.ai で [管理者セットアップ](#admin-setup) フローに従ってください。GHES で GitHub Actions ワークフローも必要な場合は、[サンプルワークフロー](https://github.com/anthropics/claude-code-action/blob/main/examples/claude.yml) を手動で適応させてください。
* **GitHub MCP サーバー**：代わりに GHES ホスト用に設定された `gh` CLI を使用してください。`gh auth login --hostname github.example.com` を実行して認証し、Claude はセッションで `gh` コマンドを使用できます。

<h2 id="troubleshooting">
  トラブルシューティング
</h2>

<h3 id="web-session-fails-to-clone-repository">
  Web セッションがリポジトリのクローンに失敗
</h3>

`claude --remote` がクローンエラーで失敗する場合は、管理者が GHES インスタンスのセットアップを完了し、GitHub App が作業しているリポジトリにインストールされていることを確認してください。管理者に確認して、Claude 設定に登録されているインスタンスホスト名が git リモートのホスト名と一致することを確認してください。

<h3 id="marketplace-add-fails-with-a-policy-error">
  マーケットプレイス追加がポリシーエラーで失敗
</h3>

GHES URL の `/plugin marketplace add` がブロックされている場合、組織はマーケットプレイスソースを制限しています。管理者に [管理設定](#allowlist-ghes-marketplaces-in-managed-settings) で GHES ホスト名の `hostPattern` エントリを追加するよう依頼してください。

<h3 id="ghes-instance-not-reachable">
  GHES インスタンスに到達不可
</h3>

レビューまたは Web セッションがタイムアウトする場合、GHES インスタンスは Anthropic インフラストラクチャから到達不可能な可能性があります。ファイアウォールが [Anthropic API IP アドレス](https://platform.claude.com/docs/en/api/ip-addresses) からのインバウンド接続を許可していることを確認してください。

<h2 id="related-resources">
  関連リソース
</h2>

これらのページは、このガイド全体で参照されている機能をより詳しく説明しています。

* [Claude Code on the web](/ja/claude-code-on-the-web)：クラウドインフラストラクチャで Claude Code セッションを実行
* [Code Review](/ja/code-review)：自動 PR レビュー
* [プラグインマーケットプレイス](/ja/plugin-marketplaces)：プラグインカタログの構築と配布
* [分析](/ja/analytics)：使用状況と貢献度メトリクスの追跡
* [管理設定](/ja/settings)：組織全体のポリシー設定
* [ネットワーク設定](/ja/network-config)：ファイアウォールと IP ホワイトリストの要件
