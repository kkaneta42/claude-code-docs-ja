> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# セキュリティ

> Claude Code のセキュリティ対策とセキュアな使用方法のベストプラクティスについて学びます。

<h2 id="how-we-approach-security">
  セキュリティへのアプローチ方法
</h2>

<h3 id="security-foundation">
  セキュリティの基盤
</h3>

コードのセキュリティは最優先事項です。Claude Code はセキュリティを中核に据えて構築されており、Anthropic の包括的なセキュリティプログラムに従って開発されています。詳細情報とリソース（SOC 2 Type 2 レポート、ISO 27001 証明書など）については、[Anthropic Trust Center](https://trust.anthropic.com) をご覧ください。

<h3 id="permission-based-architecture">
  パーミッションベースのアーキテクチャ
</h3>

セッションの権限モードは、Claude が事前に確認せずに実行できるアクションを決定します。auto モードは、対話型のターミナルセッションと VS Code セッションにおける組み込みの開始権限モードです。[セッションがどのモードで開始されるか](/docs/ja/permission-modes#which-mode-a-session-starts-in) では、以前のバージョン、その他のサーフェス、および開始権限モードを変更する設定について説明しています。

* **auto モード**: 別の分類器モデルがユーザーの代わりにアクションをレビューし、安全でないと判断したものをブロックします。[分類器がアクションを評価する方法](/docs/ja/permission-modes#how-the-classifier-evaluates-actions) では、Claude Code が直接承認するアクション、分類器に送信するアクション、および Claude Code が引き続きユーザーに確認するアクションを一覧表示しています。明示的な ask ルールと deny ルールは引き続き適用され、組織は [auto モードをオフにする](/docs/ja/permission-modes#eliminate-prompts-with-auto-mode) ことができます
* **Manual モード**: Claude Code は読み取り専用の権限で開始されます。ファイルを編集したり、テストを実行したり、コマンドを実行したりする必要がある場合は、まずユーザーに確認し、ユーザーはアクションを 1 回だけ承認するか、それ以降は常に許可するかを選択できます。`ls`、`cat`、`git status` などの [読み取り専用コマンド](/docs/ja/permissions#read-only-commands) の組み込みセットは、確認なしで実行されます

ユーザーと組織は、これらの権限を直接設定します。詳細な権限設定については、[Permissions](/docs/ja/permissions) を参照してください。

<h3 id="built-in-protections">
  組み込み保護機能
</h3>

agentic システムのリスクを軽減するために：

* **サンドボックス化された bash ツール**: [Sandbox](/docs/ja/sandboxing) bash コマンドをファイルシステムとネットワークの分離で実行し、権限プロンプトを減らしながらセキュリティを維持します。`/sandbox` で設定して、Claude Code が自律的に動作できる境界を定義します
* **作業ディレクトリの境界**: Manual モードでは、Claude Code のファイルツールが、起動されたフォルダとそのサブフォルダの外部で読み取りまたは書き込みを行う前に、ユーザーに確認します。この境界は権限プロンプトであるため、ユーザーが承認した Bash コマンドは、ユーザーアカウントが書き込み可能な任意の場所に書き込むことができます
  * 確認なしでフォルダを読み取るには、そのフォルダを [追加ディレクトリ](/docs/ja/permissions#working-directories) として追加します
  * オペレーティングシステムレベルで Bash コマンドを制限するには、[サンドボックス化](/docs/ja/sandboxing#filesystem-isolation) をオンにします
* **プロンプト疲労の軽減**: ユーザーごと、コードベースごと、または組織ごとに頻繁に使用される安全なコマンドのホワイトリスト化をサポート
* **Accept Edits モード**: ファイル編集と `mkdir`、`touch`、`rm`、`mv`、`cp`、`sed` などの固定セットのファイルシステム Bash コマンドを作業ディレクトリ内のパスに対して自動承認します。その他の Bash コマンドとスコープ外のパスはプロンプトが表示されます

<h3 id="user-responsibility">
  ユーザーの責任
</h3>

承認前に、提案されたコードとコマンドの安全性を確認する責任があります。

<h2 id="protect-against-prompt-injection">
  プロンプトインジェクションから保護する
</h2>

プロンプトインジェクションは、攻撃者が悪意のあるテキストを挿入することで AI アシスタントの指示をオーバーライドまたは操作しようとする手法です。Claude Code にはこれらの攻撃に対する複数のセーフガードが含まれています：

<h3 id="core-protections">
  コア保護機能
</h3>

* **権限モード**: Manual モードでは、機密操作には明示的な承認が必要です
* **ネットワークコマンド承認**: `curl` や `wget` などのウェブからコンテンツを取得するコマンドはデフォルトでは自動承認されません。Manual モードでは他の読み取り専用以外の Bash コマンドと同様にプロンプトが表示されるため、一度承認するか、`Bash(curl *)` のような明示的な許可ルールを追加できます。Claude がこれらを実行しないようにするには、[`permissions.deny`](/docs/ja/permissions#tool-specific-permission-rules) に追加してください。deny ルールは[書かれたとおりの](/docs/ja/permissions#bash-rule-limits)コマンドにマッチします。コマンドテキストに依存しないネットワーク強制については、[sandbox ネットワーク分離](/docs/ja/sandboxing#network-isolation) を参照してください

<h3 id="privacy-safeguards">
  プライバシーセーフガード
</h3>

データを保護するために、複数のセーフガードを実装しています：

* 機密情報の保持期間の制限（詳細については [Privacy Center](https://privacy.anthropic.com/en/articles/10023548-how-long-do-you-store-my-data) を参照してください）
* ユーザーセッションデータへのアクセス制限
* データトレーニング設定に対するユーザーコントロール。コンシューマーユーザーは [プライバシー設定](https://claude.ai/settings/privacy) をいつでも変更できます。

詳細については、[Commercial Terms of Service](https://www.anthropic.com/legal/commercial-terms)（Team、Enterprise、API ユーザー向け）または [Consumer Terms](https://www.anthropic.com/legal/consumer-terms)（Free、Pro、Max ユーザー向け）および [Privacy Policy](https://www.anthropic.com/legal/privacy) をご確認ください。

<h3 id="additional-safeguards">
  追加のセーフガード
</h3>

* **ネットワークリクエスト承認**: Manual モードでは、ネットワークリクエストを行うほとんどのツールはデフォルトでユーザー承認が必要です
* **Web ページの要約**: ほとんどのフェッチでは、WebFetch がページに対して別のモデル呼び出しを実行し、Claude は生のページではなくその呼び出しの回答を受け取ります。[WebFetch ツールの動作](/docs/ja/tools-reference#webfetch-tool-behavior) を参照してください
* **信頼検証**: 対話型セッションでは、まだ信頼していないフォルダで Claude Code を起動すると、ワークスペースの信頼ダイアログが表示されます。プロジェクトの `.mcp.json` 内のサーバーには独自の承認プロンプトがあり、[プロジェクトスコープ](/docs/ja/mcp#project-scope) にはそのプロンプトをスキップするセッションが記載されています
  * 注：`-p` セッションではどちらのプロンプトも表示されません。そこでリポジトリのファイルが実行できるものについては、[フォルダを信頼する前に実行されるもの](/docs/ja/permissions#what-runs-before-you-trust-a-folder) に記載されています
  * 注：Claude Code をホームディレクトリで直接起動する場合、信頼受け入れは現在のセッションのみ保持され、ディスクに書き込まれないため、起動するたびにプロンプトが再度表示されます。これを永続化するための設定はありません。代わりに、プロジェクトサブディレクトリから Claude Code を起動してください。そこでは信頼受け入れはディレクトリごとに保存されます
* **コマンドインジェクション検出**: Manual モードでは、Claude Code は完全に分析できない Bash コマンドを実行する前に確認を求めます。`Bash(git *)` のようなコマンドの一部に対する許可ルールがあっても、このプロンプトはスキップされません。[サンドボックス化されたコマンド](/docs/ja/permissions#how-permissions-interact-with-sandboxing) はこのプロンプトなしで実行できます
* **フェイルクローズドマッチング**: Manual モードでは、マッチしないコマンドはデフォルトで承認が必要です
* **セキュアな認証情報ストレージ**: API キーとトークンは、利用可能な場合は macOS Keychain に保存されます。Linux ではモード `0600` のファイルに保存され、Windows ではユーザープロファイルディレクトリのアクセス制御を継承するファイルに保存されます。[Credential Management](/docs/ja/authentication#credential-management) を参照してください

<Warning>
  **Windows WebDAV セキュリティリスク**: Windows で Claude Code を実行する場合、WebDAV を有効にしたり、Claude Code に `\\*` などの WebDAV サブディレクトリを含む可能性のあるパスへのアクセスを許可することはお勧めしません。[WebDAV は Microsoft によって非推奨になっています](https://learn.microsoft.com/en-us/windows/whats-new/deprecated-features#:~:text=The%20Webclient%20\(WebDAV\)%20service%20is%20deprecated) セキュリティリスクのため。WebDAV を有効にすると、Claude Code がリモートホストへのネットワークリクエストをトリガーし、パーミッションシステムをバイパスする可能性があります。
</Warning>

**信頼できないコンテンツを使用する場合のベストプラクティス**：

1. 承認前に提案されたコマンドを確認します
2. 信頼できないコンテンツを Claude に直接パイプすることを避けます
3. 重要なファイルへの提案された変更を確認します
4. 仮想マシン（VM）を使用してスクリプトを実行し、ツール呼び出しを行います。特に外部 Web サービスと対話する場合
5. `/feedback` で疑わしい動作を報告します

<Warning>
  これらの保護機能はリスクを大幅に軽減しますが、どのシステムもすべての攻撃に完全に免疫があるわけではありません。AI ツールを使用する場合は常に良好なセキュリティプラクティスを維持してください。
</Warning>

<h2 id="mcp-security">
  MCP セキュリティ
</h2>

Claude Code を Model Context Protocol（MCP）サーバーに接続できます。プロジェクトスコープのサーバーは `.mcp.json` で定義され、このファイルはソース管理にチェックインできます。[その他のスコープ](/docs/ja/mcp#mcp-installation-scopes)のサーバーや [claude.ai コネクタ](/docs/ja/mcp#how-connectors-reach-claude-code)はリポジトリの外部で設定され、プラグインもサーバーを追加できるため、`.mcp.json` を確認しても、セッションが読み込む可能性のあるすべてのサーバーがわかるわけではありません。組織内で実行されるサーバーを制限するには、[マネージド MCP 設定](/docs/ja/managed-mcp)を参照してください。

独自の MCP サーバーを作成するか、信頼できるプロバイダーからの MCP サーバーを使用することをお勧めします。Claude Code パーミッションを MCP サーバー用に設定できます。Anthropic は MCP サーバーを [リスティング基準](https://claude.com/docs/connectors/building/review-criteria) に照らして確認してから [Anthropic Directory](https://claude.ai/directory) に追加しますが、MCP サーバーのセキュリティ監査または管理は行いません。

<h2 id="ide-security">
  IDE セキュリティ
</h2>

IDE で Claude Code を実行する場合の詳細については、[VS Code security and privacy](/docs/ja/vs-code#security-and-privacy) を参照してください。

<h2 id="cloud-execution-security">
  クラウド実行セキュリティ
</h2>

[クラウドセッション](/docs/ja/claude-code-on-the-web) を使用する場合、追加のセキュリティ制御が実施されます。組織が [self-hosted environment](/docs/ja/self-hosted-environments) にルーティングするセッションは独自のインフラストラクチャで実行され、分離、ネットワーク出力、および Git 認証情報は展開の責任です。Anthropic ホスト環境では：

* **分離された仮想マシン**: 各クラウドセッションは分離された Anthropic 管理 VM で実行されます
* **ネットワークアクセス制御**: ネットワークアクセスはデフォルトで制限され、無効にするか特定のドメインのみを許可するように設定できます
* **認証情報保護**: GitHub 認証情報は Anthropic のサーバーに暗号化されて保存され、セッション VM に入ることはありません。VM はそのセッションにスコープされた短命の認証情報を保持し、GitHub トラフィックは GitHub 認証情報をサーバー側で付与する [Anthropic プロキシ](/docs/ja/cloud-environments#github-proxy) を通じて流れます。アクセスを付与する方法については、[GitHub 認証オプション](/docs/ja/claude-code-on-the-web#github-authentication-options) を参照してください
* **プッシュ制限**: [GitHub プロキシ](/docs/ja/cloud-environments#github-proxy) は、ブランチの削除と、タグなどブランチ以外のもののプッシュを拒否します。セッションがどのブランチを更新できるかは、接続した GitHub アクセスに対してリポジトリのブランチ保護ルールとルールセットを適用することで GitHub が決定します。そのアクセスがバイパスできるルールでは、セッションのプッシュはブロックされません
* **監査ログ**: クラウドセッション内のすべての操作はコンプライアンスと監査目的でログされます
* **自動クリーンアップ**: セッション VM は非アクティブ期間後に回収されます
* **削除**: [セッションを削除](/docs/ja/claude-code-on-the-web#delete-sessions) することはいつでも可能です。クラウドセッションについて Anthropic が保存する内容については、[クラウド実行データフロー](/docs/ja/data-usage#cloud-execution-data-flow-and-dependencies) を参照してください

クラウド実行の詳細については、[Claude Code をクラウドで使用する](/docs/ja/claude-code-on-the-web) を参照してください。クラウドセッションのネットワークアクセスを設定するには、[クラウド環境を設定する](/docs/ja/cloud-environments#network-access) を参照してください。

[Remote Control](/docs/ja/remote-control) セッションは異なる方法で動作します：Web インターフェースはローカルマシンで実行されている Claude Code プロセスに接続します。すべてのコード実行とファイルアクセスはローカルに留まり、セッショントラフィックは TLS 経由で Anthropic API を通じて流れます。接続中、セッショントランスクリプトはデバイス間で会話を同期するために Anthropic サーバーに保存されます。これは [Connection and security](/docs/ja/remote-control#connection-and-security) で説明されています。クラウド VM またはサンドボックスは関与しません。接続は複数の短命で狭くスコープされた認証情報を使用し、各認証情報は特定の目的に限定され、独立して有効期限が切れ、単一の侵害された認証情報のブラストラディウスを制限します。

<h2 id="security-best-practices">
  セキュリティベストプラクティス
</h2>

<h3 id="working-with-sensitive-code">
  機密コードの使用
</h3>

* 承認前にすべての提案された変更を確認してください
* 機密リポジトリにはプロジェクト固有のパーミッション設定を使用してください
* さらに分離を強化するには、Claude Code（ローカルモード）のプロセス全体を [サンドボックスランタイム](/docs/ja/sandbox-environments#sandbox-runtime) または [dev container](/docs/ja/devcontainer) 内で実行してください
* `/permissions` で定期的にパーミッション設定を監査してください

<h3 id="team-security">
  チームセキュリティ
</h3>

* [managed settings](/docs/ja/settings#where-settings-live) を使用して組織標準を実施してください
* 承認されたパーミッション設定をバージョン管理を通じて共有してください
* チームメンバーにセキュリティベストプラクティスについてトレーニングを行ってください
* [OpenTelemetry metrics](/docs/ja/monitoring-usage) を通じて Claude Code の使用を監視してください
* [`ConfigChange` hooks](/docs/ja/hooks#configchange) でセッション中の設定変更を監査またはブロックしてください

<h3 id="reporting-security-issues">
  セキュリティ問題の報告
</h3>

Claude Code でセキュリティ脆弱性を発見した場合：

1. 公開で開示しないでください
2. [HackerOne program](https://hackerone.com/4f1f16ba-10d3-4d09-9ecc-c721aad90f24/embedded_submissions/new) を通じて報告してください
3. 詳細な再現手順を含めてください
4. 公開開示前に問題に対処する時間を与えてください

<h2 id="related-resources">
  関連リソース
</h2>

* [Security guidance plugin](/docs/ja/security-guidance)：Claude がセッション中に独自のコード変更の脆弱性をレビューして修正します
* [`/security-review`](/docs/ja/commands#all-commands)：現在のブランチの変更に対してオンデマンドのセキュリティパスを実行します
* [Sandbox environments](/docs/ja/sandbox-environments)：分離アプローチを比較し、脅威モデルに合わせて選択します
* [Sandboxing](/docs/ja/sandboxing)：Bash コマンドのファイルシステムとネットワーク分離
* [Permissions](/docs/ja/permissions)：パーミッションとアクセス制御を設定します
* [Monitoring usage](/docs/ja/monitoring-usage)：Claude Code アクティビティを追跡および監査します
* [Development containers](/docs/ja/devcontainer)：セキュアで分離された環境
* [Anthropic Trust Center](https://trust.anthropic.com)：セキュリティ認証とコンプライアンス
* [CISO's guide to agentic AI](https://claude.com/blog/ciso-guide-to-agentic-ai)：agentic AI デプロイメントを評価するためのセキュリティリーダーのフレームワーク
