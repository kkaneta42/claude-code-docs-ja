> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# セキュリティ

> Claude Codeのセキュリティ対策とセキュアな使用方法のベストプラクティスについて学びます。

## セキュリティへのアプローチ方法

### セキュリティの基盤

コードのセキュリティは最優先事項です。Claude Codeはセキュリティをコアとして構築されており、Anthropicの包括的なセキュリティプログラムに従って開発されています。詳細情報とリソース（SOC 2 Type 2レポート、ISO 27001証明書など）については、[Anthropic Trust Center](https://trust.anthropic.com)をご覧ください。

### パーミッションベースのアーキテクチャ

Claude Codeはデフォルトで厳密な読み取り専用パーミッションを使用します。追加のアクション（ファイルの編集、テストの実行、コマンドの実行）が必要な場合、Claude Codeは明示的なパーミッションをリクエストします。ユーザーはアクションを1回だけ承認するか、自動的に許可するかを制御できます。

Claude Codeは透過的でセキュアになるように設計されています。例えば、bashコマンドを実行する前に承認が必要であり、直接制御できます。このアプローチにより、ユーザーと組織はパーミッションを直接設定できます。

詳細なパーミッション設定については、[Identity and Access Management](/ja/iam)を参照してください。

### 組み込み保護機能

エージェントシステムのリスクを軽減するために：

* **サンドボックス化されたbashツール**: [Sandbox](/ja/sandboxing)でbashコマンドをファイルシステムとネットワークの分離で実行し、パーミッションプロンプトを減らしながらセキュリティを維持します。`/sandbox`で有効にして、Claude Codeが自律的に作業できる境界を定義します
* **書き込みアクセス制限**: Claude Codeは開始されたフォルダとそのサブフォルダにのみ書き込みでき、明示的なパーミッションなしに親ディレクトリのファイルを変更することはできません。Claude Codeは作業ディレクトリ外のファイルを読み取ることができます（システムライブラリと依存関係へのアクセスに便利です）が、書き込み操作はプロジェクトスコープに厳密に限定され、明確なセキュリティ境界を作成します
* **プロンプト疲労の軽減**: ユーザーごと、コードベースごと、または組織ごとに頻繁に使用される安全なコマンドのホワイトリスト化をサポート
* **Accept Edits モード**: 複数の編集をバッチで承認しながら、副作用のあるコマンドのパーミッションプロンプトを維持

### ユーザーの責任

Claude Codeは付与されたパーミッションのみを持ちます。承認前に提案されたコードとコマンドの安全性を確認する責任があります。

## プロンプトインジェクションから保護する

プロンプトインジェクションは、攻撃者がAIアシスタントの指示をオーバーライドまたは操作しようとして悪意のあるテキストを挿入する技術です。Claude Codeにはこれらの攻撃に対する複数のセーフガードが含まれています：

### コア保護機能

* **パーミッションシステム**: 機密操作には明示的な承認が必要です
* **コンテキスト認識分析**: 完全なリクエストを分析して潜在的に有害な指示を検出します
* **入力サニタイゼーション**: ユーザー入力を処理してコマンドインジェクションを防止します
* **コマンドブロックリスト**: `curl`や`wget`のようなウェブから任意のコンテンツを取得するリスクのあるコマンドをデフォルトでブロックします。明示的に許可する場合は、[パーミッションパターンの制限](/ja/iam#tool-specific-permission-rules)に注意してください

### プライバシーセーフガード

データを保護するために複数のセーフガードを実装しています：

* 機密情報の保持期間の制限（詳細については[Privacy Center](https://privacy.anthropic.com/en/articles/10023548-how-long-do-you-store-my-data)を参照してください）
* ユーザーセッションデータへのアクセス制限
* データトレーニング設定に対するユーザーコントロール。コンシューマーユーザーは[プライバシー設定](https://claude.ai/settings/privacy)をいつでも変更できます。

詳細については、[Commercial Terms of Service](https://www.anthropic.com/legal/commercial-terms)（Team、Enterprise、APIユーザー向け）または[Consumer Terms](https://www.anthropic.com/legal/consumer-terms)（Free、Pro、Maxユーザー向け）および[Privacy Policy](https://www.anthropic.com/legal/privacy)をご確認ください。

### 追加のセーフガード

* **ネットワークリクエスト承認**: ネットワークリクエストを行うツールはデフォルトでユーザー承認が必要です
* **分離されたコンテキストウィンドウ**: Webフェッチは潜在的に悪意のあるプロンプトの注入を避けるために別のコンテキストウィンドウを使用します
* **信頼検証**: 初回のコードベース実行と新しいMCPサーバーは信頼検証が必要です
  * 注：信頼検証は`-p`フラグで非対話的に実行する場合は無効になります
* **コマンドインジェクション検出**: 疑わしいbashコマンドは以前にホワイトリストに登録されていても手動承認が必要です
* **フェイルクローズドマッチング**: マッチしないコマンドはデフォルトで手動承認が必要です
* **自然言語説明**: 複雑なbashコマンドにはユーザーの理解のための説明が含まれます
* **セキュアな認証情報ストレージ**: APIキーとトークンは暗号化されます。[Credential Management](/ja/iam#credential-management)を参照してください

<Warning>
  **Windows WebDAVセキュリティリスク**: Windows上でClaude Codeを実行する場合、WebDAVを有効にしたり、Claude Codeに`\\*`などのWebDAVサブディレクトリを含む可能性のあるパスへのアクセスを許可することはお勧めしません。[WebDAVはMicrosoftによって非推奨になりました](https://learn.microsoft.com/en-us/windows/whats-new/deprecated-features#:~:text=The%20Webclient%20\(WebDAV\)%20service%20is%20deprecated)セキュリティリスクのため。WebDAVを有効にするとClaude Codeがリモートホストへのネットワークリクエストをトリガーし、パーミッションシステムをバイパスする可能性があります。
</Warning>

**信頼できないコンテンツを扱うためのベストプラクティス**：

1. 承認前に提案されたコマンドを確認します
2. 信頼できないコンテンツをClaude Codeに直接パイプすることを避けます
3. 重要なファイルへの提案された変更を確認します
4. 仮想マシン（VM）を使用してスクリプトを実行し、特に外部Webサービスと相互作用する場合はツール呼び出しを行います
5. `/bug`で疑わしい動作を報告します

<Warning>
  これらの保護機能はリスクを大幅に軽減しますが、どのシステムもすべての攻撃に完全に免疫があるわけではありません。AIツールを使用する場合は常に良好なセキュリティプラクティスを維持してください。
</Warning>

## MCPセキュリティ

Claude Codeはユーザーが Model Context Protocol（MCP）サーバーを設定できます。許可されたMCPサーバーのリストはソースコードで設定され、Claude Code設定の一部としてエンジニアがソース管理にチェックインします。

信頼できるプロバイダーから独自のMCPサーバーを作成するか、MCPサーバーを使用することをお勧めします。Claude CodeのMCPサーバーのパーミッションを設定できます。AnthropicはいかなるMCPサーバーも管理または監査しません。

## IDEセキュリティ

IDEでClaude Codeを実行する場合の詳細については、[VS Code security and privacy](/ja/vs-code#security-and-privacy)を参照してください。

## クラウド実行セキュリティ

[Claude Code on the web](/ja/claude-code-on-the-web)を使用する場合、追加のセキュリティコントロールが実施されています：

* **分離された仮想マシン**: 各クラウドセッションは分離されたAnthropicが管理するVMで実行されます
* **ネットワークアクセス制御**: ネットワークアクセスはデフォルトで制限され、無効にするか特定のドメインのみを許可するように設定できます
* **認証情報保護**: 認証はサンドボックス内のスコープ付き認証情報を使用するセキュアプロキシを通じて処理され、その後実際のGitHub認証トークンに変換されます
* **ブランチ制限**: Gitプッシュ操作は現在の作業ブランチに制限されます
* **監査ログ**: クラウド環境のすべての操作はコンプライアンスと監査目的でログに記録されます
* **自動クリーンアップ**: クラウド環境はセッション完了後に自動的に終了されます

クラウド実行の詳細については、[Claude Code on the web](/ja/claude-code-on-the-web)を参照してください。

## セキュリティベストプラクティス

### 機密コードの操作

* 承認前にすべての提案された変更を確認します
* 機密リポジトリにはプロジェクト固有のパーミッション設定を使用します
* 追加の分離のために[devcontainers](/ja/devcontainer)の使用を検討します
* `/permissions`で定期的にパーミッション設定を監査します

### チームセキュリティ

* [managed settings](/ja/iam#managed-settings)を使用して組織標準を実施します
* 承認されたパーミッション設定をバージョン管理を通じて共有します
* チームメンバーにセキュリティベストプラクティスについて訓練します
* [OpenTelemetry metrics](/ja/monitoring-usage)を通じてClaude Codeの使用を監視します

### セキュリティ問題の報告

Claude Codeでセキュリティ脆弱性を発見した場合：

1. 公開的に開示しないでください
2. [HackerOne program](https://hackerone.com/anthropic-vdp/reports/new?type=team\&report_type=vulnerability)を通じて報告してください
3. 詳細な再現手順を含めてください
4. 公開開示前に問題に対処する時間を与えてください

## 関連リソース

* [Sandboxing](/ja/sandboxing) - bashコマンドのファイルシステムとネットワーク分離
* [Identity and Access Management](/ja/iam) - パーミッションとアクセス制御を設定
* [Monitoring usage](/ja/monitoring-usage) - Claude Codeアクティビティを追跡および監査
* [Development containers](/ja/devcontainer) - セキュアで分離された環境
* [Anthropic Trust Center](https://trust.anthropic.com) - セキュリティ認証とコンプライアンス
