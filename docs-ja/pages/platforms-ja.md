> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# プラットフォームと統合

> Claude Code を実行する場所を選択し、何に接続するかを決定します。CLI、Desktop、VS Code、JetBrains、Web、および Chrome、Slack、CI/CD などの統合を比較します。

Claude Code は、どこでも同じ基盤となるエンジンを実行しますが、各サーフェスは異なる作業方法に合わせて調整されています。このページは、ワークフローに適したプラットフォームを選択し、既に使用しているツールを接続するのに役立ちます。

## Claude Code を実行する場所

プロジェクトがどこにあるか、どのように作業したいかに基づいてプラットフォームを選択します。

| プラットフォーム                          | 最適な用途                                                | 提供される機能                                                                                                                                  |
| :-------------------------------- | :--------------------------------------------------- | :--------------------------------------------------------------------------------------------------------------------------------------- |
| [CLI](/ja/quickstart)             | ターミナルワークフロー、スクリプティング、リモートサーバー                        | 完全な機能セット、[Agent SDK](/ja/headless)、サードパーティプロバイダー                                                                                         |
| [Desktop](/ja/desktop)            | ビジュアルレビュー、並列セッション、管理されたセットアップ                        | Diff ビューアー、アプリプレビュー、Pro および Max での[コンピューター使用](/ja/desktop#let-claude-use-your-computer)および[Dispatch](/ja/desktop#sessions-from-dispatch) |
| [VS Code](/ja/vs-code)            | ターミナルに切り替えずに VS Code 内で作業                            | インラインの Diff、統合ターミナル、ファイルコンテキスト                                                                                                           |
| [JetBrains](/ja/jetbrains)        | IntelliJ、PyCharm、WebStorm、またはその他の JetBrains IDE 内で作業 | Diff ビューアー、選択共有、ターミナルセッション                                                                                                               |
| [Web](/ja/claude-code-on-the-web) | あまり操作が必要ない長時間実行タスク、またはオフラインの場合も続行すべき作業               | Anthropic 管理クラウド、切断後も続行                                                                                                                  |

CLI はターミナルネイティブな作業に最も完全なサーフェスです。スクリプティング、サードパーティプロバイダー、Agent SDK は CLI のみです。Desktop と IDE 拡張機能は、CLI のみの機能の一部をビジュアルレビューとより緊密なエディター統合と引き換えにします。Web は Anthropic のクラウドで実行されるため、切断後もタスクが続行されます。

同じプロジェクトで複数のサーフェスを混在させることができます。設定、プロジェクトメモリ、MCP サーバーはローカルサーフェス全体で共有されます。

## ツールを接続する

統合により、Claude はコードベース外のサービスと連携できます。

| 統合                                   | 機能                          | 用途                                    |
| :----------------------------------- | :-------------------------- | :------------------------------------ |
| [Chrome](/ja/chrome)                 | ログインしたセッションでブラウザを制御         | Web アプリのテスト、フォーム入力、API なしでサイトを自動化     |
| [GitHub Actions](/ja/github-actions) | CI パイプラインで Claude を実行       | 自動 PR レビュー、Issue トリアージ、スケジュール済みメンテナンス |
| [GitLab CI/CD](/ja/gitlab-ci-cd)     | GitLab の GitHub Actions と同じ | GitLab での CI 駆動自動化                    |
| [Code Review](/ja/code-review)       | すべての PR を自動的にレビュー           | 人間によるレビュー前にバグをキャッチ                    |
| [Slack](/ja/slack)                   | チャネルの `@Claude` メンションに応答    | バグレポートをチームチャットから PR に変換               |

ここにリストされていない統合については、[MCP サーバー](/ja/mcp)と[コネクター](/ja/desktop#connect-external-tools)により、ほぼすべてのものを接続できます。Linear、Notion、Google Drive、または独自の内部 API など。

## ターミナルから離れているときに作業する

Claude Code offers several ways to work when you're not at your terminal. They differ in what triggers the work, where Claude runs, and how much you need to set up.

|                                                | Trigger                                                                                        | Claude runs on                                                                                          | Setup                                                                                                                                | Best for                                                      |
| :--------------------------------------------- | :--------------------------------------------------------------------------------------------- | :------------------------------------------------------------------------------------------------------ | :----------------------------------------------------------------------------------------------------------------------------------- | :------------------------------------------------------------ |
| [Dispatch](/en/desktop#sessions-from-dispatch) | Message a task from the Claude mobile app                                                      | Your machine (Desktop)                                                                                  | [Pair the mobile app with Desktop](https://support.claude.com/en/articles/13947068)                                                  | Delegating work while you're away, minimal setup              |
| [Remote Control](/en/remote-control)           | Drive a running session from [claude.ai/code](https://claude.ai/code) or the Claude mobile app | Your machine (CLI or VS Code)                                                                           | Run `claude remote-control`                                                                                                          | Steering in-progress work from another device                 |
| [Channels](/en/channels)                       | Push events from a chat app like Telegram or Discord, or your own server                       | Your machine (CLI)                                                                                      | [Install a channel plugin](/en/channels#quickstart) or [build your own](/en/channels-reference)                                      | Reacting to external events like CI failures or chat messages |
| [Slack](/en/slack)                             | Mention `@Claude` in a team channel                                                            | Anthropic cloud                                                                                         | [Install the Slack app](/en/slack#setting-up-claude-code-in-slack) with [Claude Code on the web](/en/claude-code-on-the-web) enabled | PRs and reviews from team chat                                |
| [Scheduled tasks](/en/scheduled-tasks)         | Set a schedule                                                                                 | [CLI](/en/scheduled-tasks), [Desktop](/en/desktop-scheduled-tasks), or [cloud](/en/web-scheduled-tasks) | Pick a frequency                                                                                                                     | Recurring automation like daily reviews                       |

どこから始めるべきか不確かな場合は、[CLI をインストール](/ja/quickstart)してプロジェクトディレクトリで実行します。ターミナルを使用したくない場合は、[Desktop](/ja/desktop-quickstart) がグラフィカルインターフェースで同じエンジンを提供します。

## 関連リソース

### プラットフォーム

* [CLI クイックスタート](/ja/quickstart)：ターミナルでインストールして最初のコマンドを実行
* [Desktop](/ja/desktop)：ビジュアル Diff レビュー、並列セッション、コンピューター使用、Dispatch
* [VS Code](/ja/vs-code)：エディター内の Claude Code 拡張機能
* [JetBrains](/ja/jetbrains)：IntelliJ、PyCharm、およびその他の JetBrains IDE の拡張機能
* [Claude Code on the web](/ja/claude-code-on-the-web)：切断後も実行し続けるクラウドセッション

### 統合

* [Chrome](/ja/chrome)：ログインしたセッションでブラウザタスクを自動化
* [GitHub Actions](/ja/github-actions)：CI パイプラインで Claude を実行
* [GitLab CI/CD](/ja/gitlab-ci-cd)：GitLab の場合も同じ
* [Code Review](/ja/code-review)：すべてのプルリクエストで自動レビュー
* [Slack](/ja/slack)：チームチャットからタスクを送信、PR を取得

### リモートアクセス

* [Dispatch](/ja/desktop#sessions-from-dispatch)：携帯電話からタスクをメッセージして Desktop セッションを生成
* [Remote Control](/ja/remote-control)：携帯電話またはブラウザから実行中のセッションを操作
* [Channels](/ja/channels)：チャットアプリまたは独自のサーバーからセッションにイベントをプッシュ
* [Scheduled tasks](/ja/scheduled-tasks)：定期的なスケジュールでプロンプトを実行
