> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# プラットフォームと統合

> Claude Code を実行する場所を選択し、何に接続するかを決定します。CLI、Desktop、VS Code、JetBrains、Web、モバイル、および Chrome、Slack、CI/CD などの統合を比較します。

Claude Code は、どこでも同じ基盤となるエンジンを実行しますが、各サーフェスは異なる作業方法に合わせて調整されています。このページは、ワークフローに適したプラットフォームを選択し、既に使用しているツールを接続するのに役立ちます。

## Claude Code を実行する場所

プロジェクトがどこにあるか、どのように作業したいかに基づいてプラットフォームを選択します。

| プラットフォーム | 最適な用途 | 提供される機能 |
| :- | :- | :- |
| [CLI](/docs/ja/quickstart.md) | ターミナルワークフロー、スクリプティング、リモートサーバー | 完全な機能セット、[Agent SDK](/docs/ja/headless.md)、[コンピューター使用](/docs/ja/computer-use.md)（macOS の Pro および Max）、サードパーティプロバイダー |
| [Desktop](/docs/ja/desktop.md) | ビジュアルレビュー、並列セッション、管理されたセットアップ | Diff ビューアー、アプリプレビュー、Pro および Max での[コンピューター使用](/docs/ja/desktop.md#let-claude-use-your-computer)および[Dispatch](/docs/ja/desktop.md#sessions-from-dispatch) |
| [VS Code](/docs/ja/vs-code.md) | ターミナルに切り替えずに VS Code 内で作業 | インラインの Diff、統合ターミナル、ファイルコンテキスト |
| [JetBrains](/docs/ja/jetbrains.md) | IntelliJ、PyCharm、WebStorm、またはその他の JetBrains IDE 内で作業 | Diff ビューアー、選択共有、ターミナルセッション |
| [Web](/docs/ja/claude-code-on-the-web.md) | あまり操作が必要ない長時間実行タスク、またはオフラインの場合も続行すべき作業 | クラウド、Anthropic 管理（デフォルト）、切断後も続行 |
| [Mobile](/docs/ja/mobile.md) | コンピューターから離れている間にタスクを開始および監視 | iOS および Android 用 Claude アプリからのクラウドセッション、ローカルセッション用の[Remote Control](/docs/ja/remote-control.md)、Pro および Max での Desktop への[Dispatch](/docs/ja/desktop.md#sessions-from-dispatch) |

CLI はターミナルネイティブな作業に最も完全なサーフェスです。スクリプティングと Agent SDK は CLI のみです。サードパーティプロバイダーは[VS Code](/docs/ja/vs-code.md#use-third-party-providers)でも[JetBrains](/docs/ja/feature-availability.md#features-available-on-every-provider)でも機能します。JetBrains は IDE のターミナルで CLI を実行します。Enterprise [Desktop](/docs/ja/desktop.md) デプロイメントは Google Cloud の Agent Platform をサポートしており、Desktop は[ゲートウェイプロバイダー](/docs/ja/llm-gateway-connect.md#desktop-app)をサポートしています。Amazon Bedrock または Microsoft Foundry の場合は、CLI または IDE 拡張機能を使用するか、[Claude Desktop on 3P](https://claude.com/docs/third-party/claude-desktop/overview)を使用してください。これは、それらのプロバイダーで Code タブを実行します。Desktop と IDE 拡張機能は、CLI のみの機能の一部をビジュアルレビューとより緊密なエディター統合と引き換えにします。Web はクラウドで実行されるため、切断後もタスクが続行されます。モバイルは、これらの同じクラウドセッションへのシンクライアント、または Remote Control 経由のローカルセッションへのシンクライアントであり、Dispatch で Desktop にタスクを送信できます。

同じプロジェクトで複数のサーフェスを混在させることができます。設定、プロジェクトメモリ、MCP サーバーはローカルサーフェス全体で共有されます。

## ツールを接続する

統合により、Claude はコードベース外のサービスと連携できます。

| 統合 | 機能 | 用途 |
| :- | :- | :- |
| [Chrome](/docs/ja/chrome.md) | ログインしたセッションでブラウザを制御 | Web アプリのテスト、フォーム入力、API なしでサイトを自動化 |
| [GitHub Actions](/docs/ja/github-actions.md) | CI パイプラインで Claude を実行 | 自動 PR レビュー、Issue トリアージ、スケジュール済みメンテナンス |
| [GitLab CI/CD](/docs/ja/gitlab-ci-cd.md) | GitLab の GitHub Actions と同じ | GitLab での CI 駆動自動化 |
| [Code Review](/docs/ja/code-review.md) | すべての PR を自動的にレビュー | 人間によるレビュー前にバグをキャッチ |
| [Slack](/docs/ja/slack.md) | チャンネルでの `@Claude` メンションに自分のアカウントで応答 | Pro および Max プランで、チームチャットからバグレポートをプルリクエストに変換 |
| [Claude Tag](https://claude.com/docs/claude-tag) | 管理者が設定したアクセス権限を持つ組織の共有 ID として `@Claude` を実行 | Team および Enterprise プランでの共有チームアクセス（ユーザーごとの Slack セッションの代わり） |

ここにリストされていない統合については、[MCP サーバー](/docs/ja/mcp.md)と[コネクター](/docs/ja/desktop.md#connect-external-tools)により、ほぼすべてのものを接続できます。Linear、Notion、Google Drive、または独自の内部 API など。

## ターミナルから離れているときに作業する

Claude Code は、ターミナルにいない時に作業するための複数の方法を提供しています。これらは、何が作業をトリガーするか、Claude がどこで実行されるか、そしてセットアップにどの程度の手間が必要かが異なります。

| | トリガー | Claude が実行される場所 | セットアップ | 最適な用途 |
| :- | :- | :- | :- | :- |
| [Dispatch](/docs/ja/desktop.md#sessions-from-dispatch) | Claude モバイルアプリからタスクをメッセージで送信 | あなたのマシン（Desktop） | [モバイルアプリを Desktop とペアリング](https://support.claude.com/en/articles/13947068) | 外出中の作業委譲、最小限のセットアップ |
| [Remote Control](/docs/ja/remote-control.md) | [claude.ai/code](https://claude.ai/code) または Claude モバイルアプリから実行中のセッションを操作 | あなたのマシン（CLI、Desktop、または VS Code） | [`claude remote-control` または `/remote-control`](/docs/ja/remote-control#start-a-remote-control-session) を実行 | 別のデバイスから進行中の作業を操舵 |
| [Channels](/docs/ja/channels.md) | Telegram や Discord などのチャットアプリ、またはあなた自身のサーバーからイベントをプッシュ | あなたのマシン（CLI） | [チャネルプラグインをインストール](/docs/ja/channels.md#quickstart)するか、[独自に構築](/docs/ja/channels-reference.md) | CI 失敗やチャットメッセージなどの外部イベントに対応 |
| [Slack](/docs/ja/slack.md) | チームチャンネルで `@Claude` をメンション | Anthropic クラウド | [ウェブ上の Claude Code](/docs/ja/claude-code-on-the-web.md) を有効にした状態で [Slack アプリをインストール](/docs/ja/slack.md#setting-up-claude-code-in-slack)、Pro および Max プラン | チームチャットからの PR とレビュー |
| [Self-hosted environments](/docs/ja/self-hosted-environments) | [クラウドセッション](/docs/ja/claude-code-on-the-web.md)を開始し、組織の環境を選択 | あなたの組織のインフラストラクチャ | [ランナーをデプロイ](/docs/ja/self-hosted-environments-quickstart.md)、Team および Enterprise プラン | ネットワーク内で実行する必要があるクラウドセッション |
| [Scheduled tasks](/docs/ja/scheduled-tasks.md) | スケジュールを設定 | [CLI](/docs/ja/scheduled-tasks.md)、[Desktop](/docs/ja/desktop-scheduled-tasks.md)、または[クラウド](/docs/ja/routines.md) | 頻度を選択 | 日次レビューなどの定期的な自動化 |

どこから始めるべきか不確かな場合は、[CLI をインストール](/docs/ja/quickstart.md)してプロジェクトディレクトリで実行します。ターミナルを使用したくない場合は、[Desktop](/docs/ja/desktop-quickstart.md) がグラフィカルインターフェースで同じエンジンを提供します。

## 関連リソース

### プラットフォーム

* [CLI クイックスタート](/docs/ja/quickstart.md)：ターミナルでインストールして最初のコマンドを実行
* [Desktop](/docs/ja/desktop.md)：ビジュアル Diff レビュー、並列セッション、コンピューター使用、Dispatch
* [VS Code](/docs/ja/vs-code.md)：エディター内の Claude Code 拡張機能
* [JetBrains](/docs/ja/jetbrains.md)：IntelliJ、PyCharm、およびその他の JetBrains IDE の拡張機能
* [Web](/docs/ja/claude-code-on-the-web.md)：切断後も実行し続ける claude.ai/code のクラウドセッション
* [Projects](/docs/ja/claude-projects.md)：Claude が多くのクラウドセッションを調整し、作業内容について報告する 1 つの会話
* [モバイル](/docs/ja/mobile.md)：コンピューターから離れている間にタスクを開始および監視するための [iOS](https://apps.apple.com/us/app/claude-by-anthropic/id6473753684) および [Android](https://play.google.com/store/apps/details?id=com.anthropic.claude) 用 Claude アプリ

### 統合

* [Chrome](/docs/ja/chrome.md)：ログインしたセッションでブラウザタスクを自動化
* [Computer use](/docs/ja/computer-use.md)：Claude が macOS でアプリを開いてスクリーンを制御できるようにする
* [GitHub Actions](/docs/ja/github-actions.md)：CI パイプラインで Claude を実行
* [GitLab CI/CD](/docs/ja/gitlab-ci-cd.md)：GitLab の場合も同じ
* [Code Review](/docs/ja/code-review.md)：すべてのプルリクエストで自動レビュー
* [Slack](/docs/ja/slack.md)：Pro および Max プランで、チームチャットからタスクを送信して PR を受け取る
* [Claude Tag](https://claude.com/docs/claude-tag)：Team および Enterprise プランで組織の共有 ID として `@Claude` を実行

### リモートアクセス

* [Dispatch](/docs/ja/desktop.md#sessions-from-dispatch)：携帯電話からタスクをメッセージして Desktop セッションを生成
* [Remote Control](/docs/ja/remote-control.md)：携帯電話またはブラウザから実行中のセッションを操作
* [Channels](/docs/ja/channels.md)：チャットアプリまたは独自のサーバーからセッションにイベントをプッシュ
* [スケジュールオプション](/docs/ja/scheduled-tasks.md#compare-scheduling-options)：定期的なスケジュールでプロンプトを実行
