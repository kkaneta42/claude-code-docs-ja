# Claude Code 日本語ドキュメント

Claude Code公式ドキュメントの日本語版を自動更新・管理するリポジトリです。

## ドキュメント

日本語ドキュメントは [`docs-ja/`](docs-ja/index.md) を参照してください。

## 自動更新

- **ソース**: https://code.claude.com/docs/ja/
- **更新頻度**: 毎日 9:00 JST（GitHub Actions）
- **処理**: llms.txt解析 → 全ページダウンロード → 差分検知 → 自動コミット

## 更新ログ

<!-- UPDATE_LOG_START -->

<details>
<summary>2026-05-03</summary>

**変更ファイル:**

```
 docs-ja/pages/claude-directory-ja.md     |   2 +-
 docs-ja/pages/code-review-ja.md          |  86 ++++++++++++-----
 docs-ja/pages/desktop-ja.md              | 110 +++++++++++-----------
 docs-ja/pages/desktop-quickstart-ja.md   |   2 +-
 docs-ja/pages/github-actions-ja.md       |  10 +-
 docs-ja/pages/gitlab-ci-cd-ja.md         |  22 ++---
 docs-ja/pages/legal-and-compliance-ja.md |   2 +-
 docs-ja/pages/monitoring-usage-ja.md     |   2 +-
 docs-ja/pages/settings-ja.md             | 153 ++++++++++++++++---------------
 docs-ja/pages/vs-code-ja.md              |  41 +++++++--
 docs-ja/pages/zero-data-retention-ja.md  |   2 +-
 11 files changed, 248 insertions(+), 184 deletions(-)
```

**新規追加:**


<details>
<summary>claude-directory-ja.md</summary>

```diff
diff --git a/docs-ja/pages/claude-directory-ja.md b/docs-ja/pages/claude-directory-ja.md
index b501cf1..c270b4e 100644
--- a/docs-ja/pages/claude-directory-ja.md
+++ b/docs-ja/pages/claude-directory-ja.md
@@ -95,5 +95,5 @@ export const ClaudeExplorer = () => {
 # API credentials
 config/secrets.json`,
-        docsLink: '/en/common-workflows#copy-gitignored-files-to-worktrees'
+        docsLink: '/en/worktrees#copy-gitignored-files-into-worktrees'
       }, {
         id: 'dot-claude',
```

</details>

<details>
<summary>code-review-ja.md</summary>

```diff
diff --git a/docs-ja/pages/code-review-ja.md b/docs-ja/pages/code-review-ja.md
index 4c8761d..080d8e9 100644
--- a/docs-ja/pages/code-review-ja.md
+++ b/docs-ja/pages/code-review-ja.md
@@ -8,5 +8,5 @@
 
 <Note>
-  Code Review はリサーチプレビュー段階であり、[Teams および Enterprise](https://claude.ai/admin-settings/claude-code) サブスクリプションで利用可能です。[Zero Data Retention](/ja/zero-data-retention) が有効になっている組織では利用できません。
+  Code Review はリサーチプレビュー段階であり、[Team および Enterprise](https://claude.ai/admin-settings/claude-code) サブスクリプションで利用可能です。[Zero Data Retention](/ja/zero-data-retention) が有効になっている組織では利用できません。
 </Note>
 
@@ -46,4 +46,10 @@ Claude を管理サービスではなく独自の CI インフラストラクチ
 結果には、展開可能な拡張推論セクションが含まれており、Claude がなぜ問題をフラグ立てしたのか、どのように問題を検証したのかを理解するために展開できます。
 
+### 結果に対する評価と返信
+
+Claude からの各レビューコメントには、👍 と 👎 が既に添付されているため、GitHub UI で両方のボタンがワンクリック評価のために表示されます。結果が有用だった場合は 👍 をクリックし、間違っていたか騒々しかった場合は 👎 をクリックしてください。Anthropic は PR がマージされた後にリアクションカウントを収集し、それを使用してレビュアーをチューニングします。リアクションは再レビューをトリガーしたり、PR 上の何かを変更したりしません。
+
+インラインコメントに返信しても、Claude が応答したり PR を更新したりするようにプロンプトされません。結果に対処するには、コードを修正してプッシュしてください。PR がプッシュトリガーレビューにサブスクライブされている場合、次の実行は問題が修正されるとスレッドを解決します。プッシュせずに新しいレビューをリクエストするには、[トップレベルの PR コメント](#manually-trigger-reviews)として `@claude review once` とコメントしてください。
+
 ### チェック実行出力
 
@@ -136,12 +142,12 @@ PR の現在の状態についてフィードバックが必要だが、その
 ## レビューをカスタマイズする
 
-Code Review はリポジトリから 2 つのファイルを読み取り、フラグを立てる内容をガイドします。どちらもデフォルトの正確性チェックの上に追加されます：
+Code Review はリポジトリから 2 つのファイルを読み取り、フラグを立てる内容をガイドします。これらは、デフォルトの正確性チェックの上にどの程度強く影響するかが異なります：
 
-* **`CLAUDE.md`**: Claude Code がすべてのタスク（レビューだけではなく）に使用する共有プロジェクト指示。ガイダンスが対話的な Claude Code セッションにも適用される場合に使用します。
-* **`REVIEW.md`**: レビューのみのガイダンス、コードレビュー中にのみ読み取られます。レビュー中にフラグを立てるか、スキップするかについての厳密なルールで、一般的な `CLAUDE.md` を乱雑にするルールに使用します。
```

</details>

<details>
<summary>desktop-ja.md</summary>

```diff
diff --git a/docs-ja/pages/desktop-ja.md b/docs-ja/pages/desktop-ja.md
index 8d5190c..8a9c6a5 100644
--- a/docs-ja/pages/desktop-ja.md
+++ b/docs-ja/pages/desktop-ja.md
@@ -7,5 +7,5 @@
 > Claude Code Desktop をさらに活用する：Git 分離による並列セッション、ドラッグアンドドロップペインレイアウト、統合ターミナルとファイルエディタ、サイドチャット、コンピュータ使用、電話から Dispatch セッションを送信、ビジュアル diff レビュー、アプリプレビュー、PR 監視、コネクタ、エンタープライズ設定。
 
-Claude Desktop アプリ内の Code タブを使用すると、ターミナルではなくグラフィカルインターフェイスを通じて Claude Code を使用できます。
+Claude Desktop アプリには 3 つのタブがあります：**Chat** は会話用、**Cowork** は [Dispatch とより長い agentic work](https://claude.com/product/cowork) 用、**Code** はソフトウェア開発用です。このページは Code タブのリファレンスです。
 
 <CardGroup cols={2}>
@@ -19,27 +19,19 @@ Claude Desktop アプリ内の Code タブを使用すると、ターミナル
 </CardGroup>
 
-For Windows ARM64, download the [ARM64 installer](https://claude.ai/api/desktop/win32/arm64/setup/latest/redirect?utm_source=claude_code\&utm_medium=docs). Linux is not supported.
+For Windows ARM64, download the [ARM64 installer](https://claude.ai/api/desktop/win32/arm64/setup/latest/redirect?utm_source=claude_code\&utm_medium=docs). The desktop app is not available on Linux; use the [CLI](/en/quickstart) instead.
 
-インストール後、Claude を起動してサインインし、**Code**タブをクリックします。最初のセッションの完全なウォークスルーについては、[はじめにガイド](/ja/desktop-quickstart)を参照してください。
+インストール後、Claude を起動してサインインし、**Code** タブをクリックします。Windows で初めて開く場合、[Git for Windows](https://git-scm.com/downloads/win) がインストールされている必要があります。インストール後、アプリを再起動してください。最初のセッションのウォークスルーについては、[はじめにガイド](/ja/desktop-quickstart)を参照してください。
 
-Desktop は標準的な Claude Code エクスペリエンスに以下の機能を追加します：
+Code タブでは、各会話は **セッション** です：独自のチャット履歴、プロジェクトフォルダ、コード変更を持ち、他のセッションとは独立しています。サイドバーはセッションをリストアップし、複数を並列で実行できます。セッション内では以下のことができます：
 
-* [並列セッション](#work-in-parallel-with-sessions)（自動 Git worktree 分離付き）
-* [ドラッグアンドドロップレイアウト](#arrange-your-workspace)（統合ターミナル、ファイルエディタ、プレビューペイン付き）
-* [サイドチャット](#ask-a-side-question-without-derailing-the-session)（メインスレッドに影響を与えずに分岐）
-* [ビジュアル diff レビュー](#review-changes-with-diff-view)（インラインコメント付き）
-* [ライブアプリプレビュー](#preview-your-app)（dev サーバー、HTML ファイル、PDF 付き）
-* [コンピュータ使用](#let-claude-use-your-computer)（macOS と Windows でアプリを開いてスクリーンを制御）
-* [GitHub PR 監視](#monitor-pull-request-status)（自動修正、自動マージ、自動アーカイブ付き）
```

</details>

<details>
<summary>desktop-quickstart-ja.md</summary>

```diff
diff --git a/docs-ja/pages/desktop-quickstart-ja.md b/docs-ja/pages/desktop-quickstart-ja.md
index 2145a52..cb22f4a 100644
--- a/docs-ja/pages/desktop-quickstart-ja.md
+++ b/docs-ja/pages/desktop-quickstart-ja.md
@@ -19,5 +19,5 @@
 </CardGroup>
 
-For Windows ARM64, download the [ARM64 installer](https://claude.ai/api/desktop/win32/arm64/setup/latest/redirect?utm_source=claude_code\&utm_medium=docs). Linux is not supported.
+For Windows ARM64, download the [ARM64 installer](https://claude.ai/api/desktop/win32/arm64/setup/latest/redirect?utm_source=claude_code\&utm_medium=docs). The desktop app is not available on Linux; use the [CLI](/en/quickstart) instead.
 
 <Note>
```

</details>

<details>
<summary>github-actions-ja.md</summary>

```diff
diff --git a/docs-ja/pages/github-actions-ja.md b/docs-ja/pages/github-actions-ja.md
index 4bee071..1d5cdfe 100644
--- a/docs-ja/pages/github-actions-ja.md
+++ b/docs-ja/pages/github-actions-ja.md
@@ -10,9 +10,9 @@ Claude Code GitHub Actions は、GitHub ワークフローに AI を活用した
 
 <Note>
-  Claude Code GitHub Actions は [Claude Agent SDK](https://platform.claude.com/docs/en/agent-sdk/overview) の上に構築されており、Claude Code をアプリケーションにプログラム的に統合できます。SDK を使用して、GitHub Actions を超えたカスタム自動化ワークフローを構築できます。
+  Claude Code GitHub Actions は [Claude Agent SDK](/ja/agent-sdk/overview) の上に構築されており、Claude Code をアプリケーションにプログラム的に統合できます。SDK を使用して、GitHub Actions を超えたカスタム自動化ワークフローを構築できます。
 </Note>
 
 <Info>
-  **Claude Opus 4.6 が利用可能になりました。** Claude Code GitHub Actions はデフォルトで Sonnet を使用します。Opus 4.6 を使用するには、[model パラメータ](#breaking-changes-reference) を `claude-opus-4-6` に設定してください。
+  **Claude Opus 4.7 が利用可能になりました。** Claude Code GitHub Actions はデフォルトで Sonnet を使用します。Opus 4.7 を使用するには、[model パラメータ](#breaking-changes-reference) を `claude-opus-4-7` に設定してください。
 </Info>
 
@@ -46,5 +46,5 @@ Claude Code は、コードの操作方法を変える強力な GitHub Action 
   * GitHub アプリをインストールしてシークレットを追加するには、リポジトリ管理者である必要があります
   * GitHub アプリは、Contents、Issues、Pull requests に対する読み取りと書き込みのアクセス許可をリクエストします
-  * このクイックスタート方法は、直接 Claude API ユーザーのみが利用できます。AWS Bedrock または Google Vertex AI を使用している場合は、[AWS Bedrock と Google Vertex AI での使用](#using-with-aws-bedrock-%26-google-vertex-ai) セクションを参照してください。
+  * このクイックスタート方法は、直接 Claude API ユーザーのみが利用できます。Amazon Bedrock または Google Vertex AI を使用している場合は、[Amazon Bedrock と Google Vertex AI での使用](#using-with-amazon-bedrock-%26-google-vertex-ai) セクションを参照してください。
 </Note>
 
@@ -275,5 +275,5 @@ Claude Code Action v1 は、統一されたパラメータで設定を簡素化
 </Tip>
 
-## AWS Bedrock と Google Vertex AI での使用
+## Amazon Bedrock と Google Vertex AI での使用
 
 エンタープライズ環境では、Claude Code GitHub Actions を独自のクラウドインフラストラクチャで使用できます。このアプローチにより、データレジデンシーと請求を制御しながら、同じ機能を維持できます。
```

</details>

<details>
<summary>gitlab-ci-cd-ja.md</summary>

```diff
diff --git a/docs-ja/pages/gitlab-ci-cd-ja.md b/docs-ja/pages/gitlab-ci-cd-ja.md
index 5597975..e6ad63f 100644
--- a/docs-ja/pages/gitlab-ci-cd-ja.md
+++ b/docs-ja/pages/gitlab-ci-cd-ja.md
@@ -14,5 +14,5 @@
 
 <Note>
-  この統合は [Claude Code CLI and Agent SDK](https://platform.claude.com/docs/ja/agent-sdk/overview) の上に構築されており、CI/CD ジョブとカスタム自動化ワークフローで Claude をプログラム的に使用できます。
+  この統合は [Claude Code CLI and Agent SDK](/ja/agent-sdk/overview) の上に構築されており、CI/CD ジョブとカスタム自動化ワークフローで Claude をプログラム的に使用できます。
 </Note>
 
@@ -23,5 +23,5 @@
 * **プロジェクト対応**: Claude は `CLAUDE.md` ガイドラインと既存のコードパターンに従います
 * **シンプルなセットアップ**: `.gitlab-ci.yml` に 1 つのジョブとマスクされた CI/CD 変数を追加します
-* **エンタープライズ対応**: Claude API、AWS Bedrock、または Google Vertex AI を選択して、データレジデンシーと調達のニーズを満たします
+* **エンタープライズ対応**: Claude API、Amazon Bedrock、または Google Vertex AI を選択して、データレジデンシーと調達のニーズを満たします
 * **デフォルトでセキュア**: GitLab ランナーで実行され、ブランチ保護と承認が適用されます
 
@@ -34,5 +34,5 @@ Claude Code は GitLab CI/CD を使用して AI タスクを分離されたジ
 2. **プロバイダー抽象化**: 環境に適したプロバイダーを使用します。
    * Claude API（SaaS）
-   * AWS Bedrock（IAM ベースのアクセス、クロスリージョンオプション）
+   * Amazon Bedrock（IAM ベースのアクセス、クロスリージョンオプション）
    * Google Vertex AI（GCP ネイティブ、Workload Identity Federation）
 
@@ -99,5 +99,5 @@ claude:
 
 <Note>
-  Claude API の代わりに AWS Bedrock または Google Vertex AI で実行するには、以下の [Using with AWS Bedrock & Google Vertex AI](#using-with-aws-bedrock--google-vertex-ai) セクションを参照して、認証と環境セットアップを確認してください。
+  Claude API の代わりに Amazon Bedrock または Google Vertex AI で実行するには、以下の [Using with Amazon Bedrock & Google Vertex AI](#using-with-amazon-bedrock--google-vertex-ai) セクションを参照して、認証と環境セットアップを確認してください。
```

</details>

<details>
<summary>legal-and-compliance-ja.md</summary>

```diff
diff --git a/docs-ja/pages/legal-and-compliance-ja.md b/docs-ja/pages/legal-and-compliance-ja.md
index cb5693a..2419d8c 100644
--- a/docs-ja/pages/legal-and-compliance-ja.md
+++ b/docs-ja/pages/legal-and-compliance-ja.md
@@ -18,5 +18,5 @@ Claude Code の使用は、以下の対象となります。
 ### 商用契約
 
-Claude API を直接（1P）使用している場合でも、AWS Bedrock または Google Vertex を通じてアクセスしている場合（3P）でも、既存の商用契約が Claude Code の使用に適用されます。ただし、相互に別途合意した場合を除きます。
+Claude API を直接（1P）使用している場合でも、Amazon Bedrock または Google Vertex を通じてアクセスしている場合（3P）でも、既存の商用契約が Claude Code の使用に適用されます。ただし、相互に別途合意した場合を除きます。
 
 ## 規制対応
```

</details>

<details>
<summary>monitoring-usage-ja.md</summary>

```diff
diff --git a/docs-ja/pages/monitoring-usage-ja.md b/docs-ja/pages/monitoring-usage-ja.md
index 7c8fc94..0a23d1a 100644
--- a/docs-ja/pages/monitoring-usage-ja.md
+++ b/docs-ja/pages/monitoring-usage-ja.md
@@ -860,5 +860,5 @@ API リクエストが複数回の試行後に失敗した場合に 1 回ログ
 
 <Note>
-  コストメトリクスは概算です。公式な請求データについては、API プロバイダー (Claude Console、AWS Bedrock、または Google Cloud Vertex) を参照してください。
+  コストメトリクスは概算です。公式な請求データについては、API プロバイダー (Claude Console、Amazon Bedrock、または Google Cloud Vertex) を参照してください。
 </Note>
 
```

</details>

*...以降省略*

</details>


<details>
<summary>2026-05-02</summary>

**変更ファイル:**

```
 docs-ja/pages/authentication-ja.md       |  2 +-
 docs-ja/pages/auto-mode-config-ja.md     |  4 ++
 docs-ja/pages/changelog.md               | 35 +++++++++++++++
 docs-ja/pages/claude-directory-ja.md     | 35 ++++++++++++++-
 docs-ja/pages/cli-reference-ja.md        | 43 +++++++++---------
 docs-ja/pages/data-usage-ja.md           |  2 +
 docs-ja/pages/env-vars-ja.md             |  3 ++
 docs-ja/pages/fullscreen-ja.md           |  4 ++
 docs-ja/pages/headless-ja.md             | 77 +++++++++++++++++++++++++++++---
 docs-ja/pages/hooks-guide-ja.md          | 36 +++++++--------
 docs-ja/pages/hooks-ja.md                | 48 ++++++++++----------
 docs-ja/pages/interactive-mode-ja.md     |  7 +--
 docs-ja/pages/keybindings-ja.md          | 71 +++++++++++++++--------------
 docs-ja/pages/llm-gateway-ja.md          | 10 ++++-
 docs-ja/pages/model-config-ja.md         |  2 +-
 docs-ja/pages/monitoring-usage-ja.md     | 28 +++++++++---
 docs-ja/pages/permission-modes-ja.md     | 14 +++---
 docs-ja/pages/permissions-ja.md          | 48 ++++++++++++++------
 docs-ja/pages/plugins-reference-ja.md    |  2 +-
 docs-ja/pages/sub-agents-ja.md           | 38 ++++++++--------
 docs-ja/pages/tools-reference-ja.md      |  2 +-
 docs-ja/pages/troubleshoot-install-ja.md | 14 +++---
 22 files changed, 363 insertions(+), 162 deletions(-)
```

<details>
<summary>authentication-ja.md</summary>

```diff
diff --git a/docs-ja/pages/authentication-ja.md b/docs-ja/pages/authentication-ja.md
index d100276..af808d9 100644
--- a/docs-ja/pages/authentication-ja.md
+++ b/docs-ja/pages/authentication-ja.md
@@ -15,5 +15,5 @@ Claude Code は、セットアップに応じて複数の認証方法をサポ
 ブラウザが自動的に開かない場合は、`c` を押してログイン URL をクリップボードにコピーし、ブラウザに貼り付けます。
 
-ブラウザがサインイン後にリダイレクトされずにログインコードを表示する場合は、`Paste code here if prompted` プロンプトでそれをターミナルに貼り付けます。
+ブラウザがサインイン後にリダイレクトされずにログインコードを表示する場合は、`Paste code here if prompted` プロンプトでそれをターミナルに貼り付けます。これは、ブラウザが Claude Code のローカルコールバックサーバーに到達できない場合に発生します。これは WSL2、SSH セッション、およびコンテナで一般的です。
 
 以下のいずれかのアカウントタイプで認証できます。
```

</details>

<details>
<summary>auto-mode-config-ja.md</summary>

```diff
diff --git a/docs-ja/pages/auto-mode-config-ja.md b/docs-ja/pages/auto-mode-config-ja.md
index 7cb4b3c..5a1d229 100644
--- a/docs-ja/pages/auto-mode-config-ja.md
+++ b/docs-ja/pages/auto-mode-config-ja.md
@@ -9,4 +9,8 @@
 [オートモード](/ja/permission-modes#eliminate-prompts-with-auto-mode)を使用すると、Claude Code は各ツール呼び出しを分類器にルーティングして、不可逆的、破壊的、または環境外を対象とした操作をブロックすることで、権限プロンプトなしで実行できます。`autoMode` 設定ブロックを使用して、その分類器に、組織が信頼するリポジトリ、バケット、ドメインを指定すると、ルーチンの内部操作のブロックが停止します。
 
+<Note>
+  オートモードは、Anthropic API を通じて Max、Team、Enterprise、API プランで利用可能です。Pro プランでは利用できず、Bedrock、Vertex、Foundry でも利用できません。Claude Code がアカウントでオートモードが利用不可と報告する場合は、[完全な要件](/ja/permission-modes#eliminate-prompts-with-auto-mode)を確認してください。これには、サポートされているモデルと Team および Enterprise プランの管理者有効化も含まれます。
+</Note>
+
 デフォルトでは、分類器は作業ディレクトリと現在のリポジトリの設定されたリモートのみを信頼します。会社のソース管理組織へのプッシュやチームクラウドバケットへの書き込みなどのアクションは、`autoMode.environment` に追加するまでブロックされます。
 
```

</details>

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index 6cf89e7..01788b6 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,39 @@
 # Changelog
 
+## 2.1.126
+
+- The `/model` picker now lists models from your gateway's `/v1/models` endpoint when `ANTHROPIC_BASE_URL` points at an Anthropic-compatible gateway
+- - Added `claude project purge [path]` to delete all Claude Code state for a project (transcripts, tasks, file history, config entry) — supports `--dry-run`, `-y/--yes`, `-i/--interactive`, and `--all`
+- `--dangerously-skip-permissions` now bypasses prompts for writes to `.claude/`, `.git/`, `.vscode/`, shell config files, and other previously-protected paths (catastrophic removal commands still prompt as a safety net)
+- `claude auth login` now accepts the OAuth code pasted into the terminal when the browser callback can't reach localhost (WSL2, SSH, containers)
+- `claude_code.skill_activated` OpenTelemetry event now fires for user-typed slash commands and carries a new `invocation_trigger` attribute (`"user-slash"`, `"claude-proactive"`, or `"nested-skill"`)
+- Auto mode: the spinner now turns red when a permission check stalls, instead of looking like the tool is running
+- Host-managed deployments (`CLAUDE_CODE_PROVIDER_MANAGED_BY_HOST`) no longer auto-disable analytics on Bedrock/Vertex/Foundry
+- Windows: PowerShell 7 installed via the Microsoft Store, MSI without PATH, or `.NET global tool` is now detected
+- Windows: when the PowerShell tool is enabled, Claude now treats PowerShell as the primary shell instead of defaulting to Bash
+- Read tool: removed the per-file malware-assessment reminder that could cause spurious refusals and "this is not malware" commentary on legacy models
+- **Security:** Fixed `allowManagedDomainsOnly` / `allowManagedReadPathsOnly` being ignored when a higher-priority managed-settings source lacked a `sandbox` block
+- Fixed pasting an image larger than 2000px breaking the session — images are now downscaled on paste, and oversized images in history are automatically removed and the request retried
+- Fixed showing the login screen for "OAuth not allowed for organization" errors — now shows guidance to contact your admin
+- Fixed OAuth login failing with timeout on slow or proxied connections, in IPv6-only devcontainers, and when the browser callback can't reach localhost
+- Fixed a rare race where a concurrent credential write could clear a valid OAuth refresh token
+- Fixed API retry countdown sticking at "0s" instead of counting down between attempts
+- Fixed "Stream idle timeout" error after waking Mac from sleep mid-request
+- Fixed background and remote sessions falsely aborting with "Stream idle timeout" during long model thinking pauses
+- Fixed a hang where the assistant could finish thinking but show no output after a run of empty turns
+- Fixed overly fast trackpad scrolling in Cursor and VS Code 1.92–1.104 integrated terminals
+- Fixed claude.ai MCP connectors being suppressed by manual servers stuck in needs-auth state
```

</details>

<details>
<summary>claude-directory-ja.md</summary>

```diff
diff --git a/docs-ja/pages/claude-directory-ja.md b/docs-ja/pages/claude-directory-ja.md
index fbee99f..b501cf1 100644
--- a/docs-ja/pages/claude-directory-ja.md
+++ b/docs-ja/pages/claude-directory-ja.md
@@ -1530,5 +1530,38 @@ Windows では、`~/.claude` は `%USERPROFILE%\.claude` に解決されます
 ### ローカルデータをクリアする
 
-上記のアプリケーションデータパスのいずれかをいつでも削除できます。新しいセッションは影響を受けません。以下のテーブルは、過去のセッションで失うものを示しています。
+`claude project purge` を実行して、1 つのプロジェクトに対して Claude Code が保持する状態を削除します：
+
+* `projects/` の下のトランスクリプトと自動メモリ
+* セッションごとの `tasks/`、`debug/`、`file-history/` エントリ
+* `history.jsonl` の一致するプロンプト行
+* `~/.claude.json` のプロジェクトエントリ
+
+このコマンドは完全な削除計画を出力し、何かを削除する前に確認を求めます。
+
+削除せずに計画をプレビューします：
+
+```bash theme={null}
+claude project purge ~/work/my-repo --dry-run
+```
+
+単一の確認プロンプトで削除します：
+
+```bash theme={null}
+claude project purge ~/work/my-repo
+```
+
+パスを省略して、対話型リストからプロジェクトを選択します。
```

</details>

<details>
<summary>cli-reference-ja.md</summary>

```diff
diff --git a/docs-ja/pages/cli-reference-ja.md b/docs-ja/pages/cli-reference-ja.md
index d12336f..d535196 100644
--- a/docs-ja/pages/cli-reference-ja.md
+++ b/docs-ja/pages/cli-reference-ja.md
@@ -11,25 +11,26 @@
 これらのコマンドを使用して、セッションを開始し、コンテンツをパイプし、会話を再開し、更新を管理できます。
 
-| コマンド                            | 説明                                                                                                                                                                                                         | 例                                                           |
-| :------------------------------ | :--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :---------------------------------------------------------- |
-| `claude`                        | インタラクティブセッションを開始                                                                                                                                                                                           | `claude`                                                    |
-| `claude "query"`                | 初期プロンプト付きでインタラクティブセッションを開始                                                                                                                                                                                 | `claude "explain this project"`                             |
-| `claude -p "query"`             | SDK 経由でクエリを実行してから終了                                                                                                                                                                                        | `claude -p "explain this function"`                         |
-| `cat file \| claude -p "query"` | パイプされたコンテンツを処理                                                                                                                                                                                             | `cat logs.txt \| claude -p "explain"`                       |
-| `claude -c`                     | 現在のディレクトリで最新の会話を続行                                                                                                                                                                                         | `claude -c`                                                 |
-| `claude -c -p "query"`          | SDK 経由で続行                                                                                                                                                                                                  | `claude -c -p "Check for type errors"`                      |
-| `claude -r "<session>" "query"` | セッション ID または名前でセッションを再開                                                                                                                                                                                    | `claude -r "auth-refactor" "Finish this PR"`                |
-| `claude update`                 | 最新バージョンに更新                                                                                                                                                                                                 | `claude update`                                             |
-| `claude install [version]`      | ネイティブバイナリをインストールまたは再インストールします。`2.1.118` のようなバージョン、または `stable` または `latest` を受け入れます。[特定のバージョンをインストール](/ja/setup#install-a-specific-version) を参照してください                                                      | `claude install stable`                                     |
-| `claude auth login`             | Anthropic アカウントにサインインします。`--email` を使用してメールアドレスを事前入力し、`--sso` を使用して SSO 認証を強制し、`--console` を使用して Claude サブスクリプションの代わりに Anthropic Console で API 使用料金をサインインできます                                              | `claude auth login --console`                               |
-| `claude auth logout`            | Anthropic アカウントからログアウト                                                                                                                                                                                     | `claude auth logout`                                        |
-| `claude auth status`            | 認証ステータスを JSON として表示します。`--text` を使用して人間が読める形式で表示できます。ログイン済みの場合はコード 0 で終了し、ログインしていない場合は 1 で終了します                                                                                                            | `claude auth status`                                        |
-| `claude agents`                 | すべての設定済み [subagents](/ja/sub-agents) をソース別にグループ化して一覧表示                                                                                                                                                     | `claude agents`                                             |
-| `claude auto-mode defaults`     | 組み込み [auto mode](/ja/permission-modes#eliminate-prompts-with-auto-mode) 分類器ルールを JSON として出力します。`claude auto-mode config` を使用して、設定が適用された有効な設定を確認してください                                                       | `claude auto-mode defaults > rules.json`                    |
-| `claude mcp`                    | Model Context Protocol（MCP）サーバーを設定                                                                                                                                                                         | [Claude Code MCP ドキュメント](/ja/mcp) を参照してください。                |
-| `claude plugin`                 | Claude Code [plugins](/ja/plugins) を管理します。エイリアス：`claude plugins`。サブコマンドについては [plugin reference](/ja/plugins-reference#cli-commands-reference) を参照してください                                                    | `claude plugin install code-review@claude-plugins-official` |
-| `claude remote-control`         | [Remote Control](/ja/remote-control) サーバーを開始して、Claude.ai または Claude アプリから Claude Code を制御します。サーバーモード（ローカルインタラクティブセッションなし）で実行されます。[サーバーモードフラグ](/ja/remote-control#start-a-remote-control-session) を参照してください | `claude remote-control --name "My Project"`                 |
-| `claude setup-token`            | CI とスクリプト用の長期間有効な OAuth トークンを生成します。ターミナルにトークンを出力し、保存しません。Claude サブスクリプションが必要です。[長期間有効なトークンを生成](/ja/authentication#generate-a-long-lived-token) を参照してください                                                   | `claude setup-token`                                        |
-| `claude ultrareview [target]`   | [ultrareview](/ja/ultrareview#run-ultrareview-non-interactively) を非対話的に実行します。結果を stdout に出力し、成功時は 0 で終了し、失敗時は 1 で終了します。`--json` を使用して生のペイロードを取得し、`--timeout <minutes>` を使用して 30 分のデフォルトをオーバーライドできます        | `claude ultrareview 1234 --json`                            |
+| コマンド                            | 説明                                                                                                                                                                                                                                                                                                             | 例                                                           |
+| :------------------------------ | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :---------------------------------------------------------- |
```

</details>

<details>
<summary>data-usage-ja.md</summary>

```diff
diff --git a/docs-ja/pages/data-usage-ja.md b/docs-ja/pages/data-usage-ja.md
index 715a115..92376e4 100644
--- a/docs-ja/pages/data-usage-ja.md
+++ b/docs-ja/pages/data-usage-ja.md
@@ -116,4 +116,6 @@ Claude Code は、ユーザーのマシンから Sentry に接続して、運用
 すべての環境変数は `settings.json` にチェックインできます（[settings reference](/ja/settings) を参照）。
 
+v2.1.126 以降、ホストプラットフォームが `CLAUDE_CODE_PROVIDER_MANAGED_BY_HOST` を設定する場合、Statsig メトリクスは Vertex、Bedrock、および Foundry でデフォルトでオンになり、標準の `DISABLE_TELEMETRY` オプトアウトに従います。Sentry エラーレポートと `/feedback` レポートは、これらのプロバイダーではデフォルトでオフのままです。
+
 ### WebFetch ドメインセーフティチェック
 
```

</details>

<details>
<summary>env-vars-ja.md</summary>

```diff
diff --git a/docs-ja/pages/env-vars-ja.md b/docs-ja/pages/env-vars-ja.md
index dd25739..f4c5c35 100644
--- a/docs-ja/pages/env-vars-ja.md
+++ b/docs-ja/pages/env-vars-ja.md
@@ -16,4 +16,5 @@ Claude Code は、その動作を制御するために以下の環境変数を
 | `ANTHROPIC_BEDROCK_BASE_URL`                            | Bedrock エンドポイント URL をオーバーライドします。カスタム Bedrock エンドポイントを使用する場合、または [LLM ゲートウェイ](/ja/llm-gateway) を通じてルーティングする場合に使用します。[Amazon Bedrock](/ja/amazon-bedrock) を参照してください                                                                                                                                                                                                                                                     |
 | `ANTHROPIC_BEDROCK_MANTLE_BASE_URL`                     | Bedrock Mantle エンドポイント URL をオーバーライドします。[Mantle エンドポイント](/ja/amazon-bedrock#use-the-mantle-endpoint) を参照してください                                                                                                                                                                                                                                                                                                         |
+| `ANTHROPIC_BEDROCK_SERVICE_TIER`                        | Bedrock [サービスティア](https://docs.aws.amazon.com/bedrock/latest/userguide/service-tiers-inference.html)（`default`、`flex`、または `priority`）。`X-Amzn-Bedrock-Service-Tier` ヘッダーとして送信されます。[Amazon Bedrock](/ja/amazon-bedrock#service-tiers) を参照してください                                                                                                                                                                        |
 | `ANTHROPIC_BETAS`                                       | API リクエストに含める追加の `anthropic-beta` ヘッダー値のカンマ区切りリスト。Claude Code は既に必要なベータヘッダーを送信しています。Claude Code がネイティブサポートを追加する前に、[Anthropic API ベータ](https://platform.claude.com/docs/en/api/beta-headers) にオプトインするために使用します。API キー認証が必要な [`--betas` フラグ](/ja/cli-reference#cli-flags) とは異なり、この変数は Claude.ai サブスクリプションを含むすべての認証方法で機能します                                                                                               |
 | `ANTHROPIC_CUSTOM_HEADERS`                              | リクエストに追加するカスタムヘッダー（`Name: Value` 形式、複数のヘッダーの場合は改行で区切られます）                                                                                                                                                                                                                                                                                                                                                             |
@@ -125,4 +126,5 @@ Claude Code は、その動作を制御するために以下の環境変数を
 | `CLAUDE_CODE_PLUGIN_KEEP_MARKETPLACE_ON_FAILURE`        | `git pull` が失敗した場合、既存のマーケットプレイスキャッシュを保持するには `1` に設定します。ワイプして再クローンする代わりに。オフラインまたはエアギャップ環境で役立ちます。再クローンは同じ方法で失敗します。[オフライン環境でのマーケットプレイス更新の失敗](/ja/plugin-marketplaces#marketplace-updates-fail-in-offline-environments) を参照してください                                                                                                                                                                                         |
 | `CLAUDE_CODE_PLUGIN_SEED_DIR`                           | 1 つ以上の読み取り専用プラグインシードディレクトリへのパス。Unix では `:` で、Windows では `;` で区切られます。事前入力されたプラグインディレクトリをコンテナイメージにバンドルするために使用します。Claude Code はこれらのディレクトリからマーケットプレイスを登録し、再クローンなしで事前キャッシュされたプラグインを使用します。[コンテナ用のプラグインを事前入力](/ja/plugin-marketplaces#pre-populate-plugins-for-containers) を参照してください                                                                                                                                         |
+| `CLAUDE_CODE_PROVIDER_MANAGED_BY_HOST`                  | Claude Code を埋め込み、その代わりにモデルプロバイダーのルーティングを管理するホストプラットフォームによって設定されます。設定されている場合、`CLAUDE_CODE_USE_BEDROCK`、`ANTHROPIC_BASE_URL`、`ANTHROPIC_API_KEY` などのプロバイダー選択、エンドポイント、認証変数は設定ファイルで無視されるため、ユーザー設定はホストのルーティングをオーバーライドできません。Bedrock、Vertex、Foundry の自動テレメトリオプトアウトもスキップされるため、テレメトリは標準の `DISABLE_TELEMETRY` オプトアウトに従います。[API プロバイダーごとのデフォルト動作](/ja/data-usage#default-behaviors-by-api-provider) を参照してください                   |
 | `CLAUDE_CODE_PROXY_RESOLVES_HOSTS`                      | プロキシが呼び出し元の代わりに DNS 解決を実行できるようにするには `1` に設定します。プロキシがホスト名解決を処理する必要がある環境でオプトインします                                                                                                                                                                                                                                                                                                                                       |
 | `CLAUDE_CODE_REMOTE`                                    | Claude Code が [クラウドセッション](/ja/claude-code-on-the-web) として実行されている場合に自動的に `true` に設定されます。フックまたはセットアップスクリプトからこれを読み取って、クラウド環境にいるかどうかを検出します                                                                                                                                                                                                                                                                                |
@@ -170,4 +172,5 @@ Claude Code は、その動作を制御するために以下の環境変数を
 | `DISABLE_EXTRA_USAGE_COMMAND`                           | ユーザーがレート制限を超えて追加使用量を購入できる `/extra-usage` コマンドを非表示にするには `1` に設定します                                                                                                                                                                                                                                                                                                                                                     |
 | `DISABLE_FEEDBACK_COMMAND`                              | `/feedback` コマンドを無効にするには `1` に設定します。古い名前 `DISABLE_BUG_COMMAND` も受け入れられます                                                                                                                                                                                                                                                                                                                                              |
+| `DISABLE_GROWTHBOOK`                                    | GrowthBook フィーチャーフラグ取得を無効にするには `1` に設定します。すべてのフラグにコードデフォルトを使用します。テレメトリイベントログは `DISABLE_TELEMETRY` も設定されていない限りオンのままです                                                                                                                                                                                                                                                                                                  |
 | `DISABLE_INSTALLATION_CHECKS`                           | インストール警告を無効にするには `1` に設定します。インストール場所を手動で管理する場合にのみ使用してください。標準インストールの問題をマスクする可能性があります                                                                                                                                                                                                                                                                                                                                   |
 | `DISABLE_INSTALL_GITHUB_APP_COMMAND`                    | `/install-github-app` コマンドを非表示にするには `1` に設定します。サードパーティプロバイダー（Bedrock、Vertex、または Foundry）を使用する場合は既に非表示です                                                                                                                                                                                                                                                                                                               |
```

</details>

<details>
<summary>fullscreen-ja.md</summary>

```diff
diff --git a/docs-ja/pages/fullscreen-ja.md b/docs-ja/pages/fullscreen-ja.md
index 452ec3f..a334d36 100644
--- a/docs-ja/pages/fullscreen-ja.md
+++ b/docs-ja/pages/fullscreen-ja.md
@@ -117,4 +117,8 @@ export CLAUDE_CODE_SCROLL_SPEED=3
 `Esc` または `q` を押してプロンプトに戻ります。
 
+## 会話をクリアする
+
+2 秒以内に `Ctrl+L` を 2 回押して `/clear` を実行し、新しい会話を開始します。最初のプレスは画面を再描画してヒントを表示します。2 番目のプレスは会話をクリアします。macOS では、`Cmd+K` をダブルプレスしても `/clear` が実行されます。
+
 ## tmux で使用する
 
```

</details>

*...以降省略*

</details>


<details>
<summary>2026-05-01</summary>

**変更ファイル:**

```
 docs-ja/pages/memory-ja.md | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)
```

<details>
<summary>memory-ja.md</summary>

```diff
diff --git a/docs-ja/pages/memory-ja.md b/docs-ja/pages/memory-ja.md
index fb7c79b..2d83d0b 100644
--- a/docs-ja/pages/memory-ja.md
+++ b/docs-ja/pages/memory-ja.md
@@ -48,5 +48,5 @@ CLAUDE.md を、そうでなければ再度説明する場所として扱いま
 * 新しいチームメンバーが生産的になるために同じコンテキストが必要になる
 
-Claude がすべてのセッションで保持すべき事実に限定します。ビルドコマンド、規約、プロジェクトレイアウト、「常に X を実行する」ルール。エントリが複数ステップの手順である場合、またはコードベースの 1 つの部分にのみ関連する場合は、代わりに [skill](/ja/skills) または [パススコープルール](#organize-rules-with-clauderules) に移動します。[拡張機能の概要](/ja/features-overview#build-your-setup-over-time)では、各メカニズムをいつ使用するかについて説明しています。
+Claude がすべてのセッションで保持すべき事実に限定します。ビルドコマンド、規約、プロジェクトレイアウト、「常に X を実行する」ルール。エントリが複数ステップの手順である場合、またはコードベースの 1 つの部分にのみ関連する場合は、代わりに [skill](/ja/skills) または [パススコープルール](#organize-rules-with-claude/rules/) に移動します。[拡張機能の概要](/ja/features-overview#build-your-setup-over-time)では、各メカニズムをいつ使用するかについて説明しています。
 
 ### CLAUDE.md ファイルをどこに配置するかを選択する
@@ -61,7 +61,7 @@ CLAUDE.md ファイルはいくつかの場所に配置でき、それぞれ異
 | **ローカル指示**   | `./CLAUDE.local.md`                                                                                                                                                   | 個人的なプロジェクト固有の好み。`.gitignore` に追加します | あなたのサンドボックス URL、好みのテストデータ         | あなただけ（現在のプロジェクト）  |
 
-ワーキングディレクトリより上のディレクトリ階層内の CLAUDE.md および CLAUDE.local.md ファイルは、起動時に完全に読み込まれます。サブディレクトリ内のファイルは、Claude がそれらのディレクトリ内のファイルを読むときにオンデマンドで読み込まれます。完全な解決順序については、[CLAUDE.md ファイルの読み込み方法](#how-claudemd-files-load)を参照してください。
+ワーキングディレクトリより上のディレクトリ階層内の CLAUDE.md および CLAUDE.local.md ファイルは、起動時に完全に読み込まれます。サブディレクトリ内のファイルは、Claude がそれらのディレクトリ内のファイルを読むときにオンデマンドで読み込まれます。完全な解決順序については、[CLAUDE.md ファイルの読み込み方法](#how-claude-md-files-load)を参照してください。
 
-大規模なプロジェクトの場合、[プロジェクトルール](#organize-rules-with-clauderules)を使用してトピック固有のファイルに指示を分割できます。ルールを使用すると、特定のファイルタイプまたはサブディレクトリに指示をスコープできます。
+大規模なプロジェクトの場合、[プロジェクトルール](#organize-rules-with-claude/rules/)を使用してトピック固有のファイルに指示を分割できます。ルールを使用すると、特定のファイルタイプまたはサブディレクトリに指示をスコープできます。
 
 ### プロジェクト CLAUDE.md を設定する
@@ -89,5 +89,5 @@ CLAUDE.md ファイルは各セッションの開始時にコンテキストウ
 * 「ファイルを整理しておく」ではなく「API ハンドラーは `src/api/handlers/` に存在する」
 
-**一貫性**: 2 つのルールが互いに矛盾している場合、Claude は 1 つを任意に選択する可能性があります。CLAUDE.md ファイル、サブディレクトリ内のネストされた CLAUDE.md ファイル、および [`.claude/rules/`](#organize-rules-with-clauderules) を定期的に確認して、古い指示または矛盾する指示を削除します。モノレポでは、[`claudeMdExcludes`](#exclude-specific-claudemd-files) を使用して、作業に関連のない他のチームの CLAUDE.md ファイルをスキップします。
+**一貫性**: 2 つのルールが互いに矛盾している場合、Claude は 1 つを任意に選択する可能性があります。CLAUDE.md ファイル、サブディレクトリ内のネストされた CLAUDE.md ファイル、および [`.claude/rules/`](#organize-rules-with-claude/rules/) を定期的に確認して、古い指示または矛盾する指示を削除します。モノレポでは、[`claudeMdExcludes`](#exclude-specific-claude-md-files) を使用して、作業に関連のない他のチームの CLAUDE.md ファイルをスキップします。
 
 ### 追加ファイルをインポートする
@@ -119,5 +119,5 @@ README、package.json、およびワークフローガイドを取得するに
 </Warning>
```

</details>

</details>


<details>
<summary>2026-04-30</summary>

**変更ファイル:**

```
 docs-ja/pages/changelog.md               |  4 ++++
 docs-ja/pages/claude-directory-ja.md     |  2 +-
 docs-ja/pages/env-vars-ja.md             |  2 +-
 docs-ja/pages/overview-ja.md             |  6 +++---
 docs-ja/pages/quickstart-ja.md           |  6 +++---
 docs-ja/pages/setup-ja.md                | 14 +++++++-------
 docs-ja/pages/skills-ja.md               |  3 +--
 docs-ja/pages/statusline-ja.md           |  4 ++--
 docs-ja/pages/tools-reference-ja.md      |  2 +-
 docs-ja/pages/troubleshoot-install-ja.md | 25 +++++++++++++++++++++----
 docs-ja/pages/ultrareview-ja.md          |  2 ++
 11 files changed, 46 insertions(+), 24 deletions(-)
```

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index 7359d2c..6cf89e7 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,8 @@
 # Changelog
 
+## 2.1.123
+
+- Fixed OAuth authentication failing with a 401 retry loop when `CLAUDE_CODE_DISABLE_EXPERIMENTAL_BETAS=1` is set
+
 ## 2.1.122
 
```

</details>

<details>
<summary>claude-directory-ja.md</summary>

```diff
diff --git a/docs-ja/pages/claude-directory-ja.md b/docs-ja/pages/claude-directory-ja.md
index f951427..fbee99f 100644
--- a/docs-ja/pages/claude-directory-ja.md
+++ b/docs-ja/pages/claude-directory-ja.md
@@ -486,5 +486,5 @@ Every finding must include a concrete fix.`
           oneLiner: 'Custom keyboard shortcuts',
           when: 'Read at session start and hot-reloaded when you edit the file',
-          description: <>Rebind keyboard shortcuts in the interactive CLI. Run <C>/keybindings</C> to create or open this file with a schema reference. Ctrl+C, Ctrl+D, and Ctrl+M are reserved and cannot be rebound.</>,
+          description: <>Rebind keyboard shortcuts in the interactive CLI. Run <C>/keybindings</C> to create or open this file with a schema reference. Ctrl+C, Ctrl+D, Ctrl+M, and Caps Lock are reserved and cannot be rebound.</>,
           exampleIntro: <>This example binds <C>Ctrl+E</C> to open your external editor and unbinds <C>Ctrl+U</C> by setting it to <C>null</C>. The <C>context</C> field scopes bindings to a specific part of the CLI, here the main chat input.</>,
           example: `{
```

</details>

<details>
<summary>env-vars-ja.md</summary>

```diff
diff --git a/docs-ja/pages/env-vars-ja.md b/docs-ja/pages/env-vars-ja.md
index 9fe4beb..dd25739 100644
--- a/docs-ja/pages/env-vars-ja.md
+++ b/docs-ja/pages/env-vars-ja.md
@@ -154,5 +154,5 @@ Claude Code は、その動作を制御するために以下の環境変数を
 | `CLAUDE_CODE_USE_MANTLE`                                | Bedrock [Mantle エンドポイント](/ja/amazon-bedrock#use-the-mantle-endpoint) を使用します                                                                                                                                                                                                                                                                                                                                           |
 | `CLAUDE_CODE_USE_NATIVE_FILE_SEARCH`                    | ripgrep の代わりに Node.js ファイル API を使用してカスタムコマンド、subagent、出力スタイルを検出するには `1` に設定します。バンドルされた ripgrep バイナリが利用できないか、環境でブロックされている場合に設定します。Grep またはファイル検索ツールには影響しません                                                                                                                                                                                                                                                            |
-| `CLAUDE_CODE_USE_POWERSHELL_TOOL`                       | PowerShell ツールを制御します。Windows では、ツールは段階的にロールアウトされています：オプトインするには `1` に、オプトアウトするには `0` に設定します。Linux、macOS、WSL では、有効にするには `1` に設定します。これには PATH に `pwsh` が必須です。Windows で有効にすると、Claude は Git Bash を通じてルーティングする代わりに PowerShell コマンドをネイティブに実行できます。[PowerShell ツール](/ja/tools-reference#powershell-tool) を参照してください                                                                                                             |
+| `CLAUDE_CODE_USE_POWERSHELL_TOOL`                       | PowerShell ツールを制御します。Windows では Git Bash がない場合、ツールは自動的に有効になります。無効にするには `0` に設定します。Windows に Git Bash がインストールされている場合、ツールは段階的にロールアウトされています：オプトインするには `1` に、オプトアウトするには `0` に設定します。Linux、macOS、WSL では、有効にするには `1` に設定します。これには PATH に `pwsh` が必須です。Windows で有効にすると、Claude は Git Bash を通じてルーティングする代わりに PowerShell コマンドをネイティブに実行できます。[PowerShell ツール](/ja/tools-reference#powershell-tool) を参照してください                         |
 | `CLAUDE_CODE_USE_VERTEX`                                | [Vertex](/ja/google-vertex-ai) を使用します                                                                                                                                                                                                                                                                                                                                                                                 |
 | `CLAUDE_CONFIG_DIR`                                     | 設定ディレクトリをオーバーライドします（デフォルト：`~/.claude`）。すべての設定、認証情報、セッション履歴、プラグインはこのパスの下に保存されます。複数のアカウントを並行して実行する場合に役立ちます：例えば、`alias claude-work='CLAUDE_CONFIG_DIR=~/.claude-work claude'`                                                                                                                                                                                                                                            |
```

</details>

<details>
<summary>overview-ja.md</summary>

```diff
diff --git a/docs-ja/pages/overview-ja.md b/docs-ja/pages/overview-ja.md
index e3a9595..2334771 100644
--- a/docs-ja/pages/overview-ja.md
+++ b/docs-ja/pages/overview-ja.md
@@ -490,8 +490,8 @@ export const InstallConfigurator = ({defaultSurface = 'terminal'}) => {
       {target === 'terminal' && <div className="cc-ic-below">
           {isWinInstaller && <span>
-              Requires{' '}
               <a href="https://git-scm.com/downloads/win" target="_blank" rel="noopener">
                 Git for Windows
-              </a>.
+              </a>{' '}
+              recommended. PowerShell is used if Git Bash is absent.
             </span>}
           {(pkg === 'brew' || pkg === 'winget') && <span>
@@ -675,5 +675,5 @@ Claude Code は AI を活用したコーディングアシスタントで、機
         If you see `The token '&&' is not a valid statement separator`, you're in PowerShell, not CMD. If you see `'irm' is not recognized as an internal or external command`, you're in CMD, not PowerShell. Your prompt shows `PS C:\` when you're in PowerShell and `C:\` without the `PS` when you're in CMD.
 
-        [Git for Windows](https://git-scm.com/downloads/win) is required on native Windows so Claude Code can use the Bash tool. WSL setups do not need Git for Windows.
+        [Git for Windows](https://git-scm.com/downloads/win) is recommended on native Windows so Claude Code can use the Bash tool. If Git for Windows is not installed, Claude Code uses PowerShell as the shell tool instead. WSL setups do not need Git for Windows.
 
         <Info>
```

</details>

<details>
<summary>quickstart-ja.md</summary>

```diff
diff --git a/docs-ja/pages/quickstart-ja.md b/docs-ja/pages/quickstart-ja.md
index 426425a..4f9925e 100644
--- a/docs-ja/pages/quickstart-ja.md
+++ b/docs-ja/pages/quickstart-ja.md
@@ -490,8 +490,8 @@ export const InstallConfigurator = ({defaultSurface = 'terminal'}) => {
       {target === 'terminal' && <div className="cc-ic-below">
           {isWinInstaller && <span>
-              Requires{' '}
               <a href="https://git-scm.com/downloads/win" target="_blank" rel="noopener">
                 Git for Windows
-              </a>.
+              </a>{' '}
+              recommended. PowerShell is used if Git Bash is absent.
             </span>}
           {(pkg === 'brew' || pkg === 'winget') && <span>
@@ -680,5 +680,5 @@ To install Claude Code, use one of the following methods:
     If you see `The token '&&' is not a valid statement separator`, you're in PowerShell, not CMD. If you see `'irm' is not recognized as an internal or external command`, you're in CMD, not PowerShell. Your prompt shows `PS C:\` when you're in PowerShell and `C:\` without the `PS` when you're in CMD.
 
-    [Git for Windows](https://git-scm.com/downloads/win) is required on native Windows so Claude Code can use the Bash tool. WSL setups do not need Git for Windows.
+    [Git for Windows](https://git-scm.com/downloads/win) is recommended on native Windows so Claude Code can use the Bash tool. If Git for Windows is not installed, Claude Code uses PowerShell as the shell tool instead. WSL setups do not need Git for Windows.
 
     <Info>
```

</details>

<details>
<summary>setup-ja.md</summary>

```diff
diff --git a/docs-ja/pages/setup-ja.md b/docs-ja/pages/setup-ja.md
index d49e141..546dd06 100644
--- a/docs-ja/pages/setup-ja.md
+++ b/docs-ja/pages/setup-ja.md
@@ -60,5 +60,5 @@ To install Claude Code, use one of the following methods:
     If you see `The token '&&' is not a valid statement separator`, you're in PowerShell, not CMD. If you see `'irm' is not recognized as an internal or external command`, you're in CMD, not PowerShell. Your prompt shows `PS C:\` when you're in PowerShell and `C:\` without the `PS` when you're in CMD.
 
-    [Git for Windows](https://git-scm.com/downloads/win) is required on native Windows so Claude Code can use the Bash tool. WSL setups do not need Git for Windows.
+    [Git for Windows](https://git-scm.com/downloads/win) is recommended on native Windows so Claude Code can use the Bash tool. If Git for Windows is not installed, Claude Code uses PowerShell as the shell tool instead. WSL setups do not need Git for Windows.
 
     <Info>
@@ -104,9 +104,9 @@ claude
 Claude Code をネイティブに Windows で実行することも、WSL 内で実行することもできます。プロジェクトの場所と必要な機能に基づいて選択してください。
 
-| オプション         | 必須                                                      | [サンドボックス](/ja/sandboxing) | 使用時期                              |
-| ------------- | ------------------------------------------------------- | ------------------------- | --------------------------------- |
-| ネイティブ Windows | [Git for Windows](https://git-scm.com/downloads/win)が必須 | サポートされていません               | Windows ネイティブプロジェクトとツール           |
-| WSL 2         | WSL 2 有効                                                | サポートされています                | Linux ツールチェーンまたはサンドボックス化されたコマンド実行 |
-| WSL 1         | WSL 1 有効                                                | サポートされていません               | WSL 2 が利用できない場合                   |
+| オプション         | 必須                                                                           | [サンドボックス](/ja/sandboxing) | 使用時期                              |
+| ------------- | ---------------------------------------------------------------------------- | ------------------------- | --------------------------------- |
+| ネイティブ Windows | [Git for Windows](https://git-scm.com/downloads/win)推奨；不在の場合は PowerShell を使用 | サポートされていません               | Windows ネイティブプロジェクトとツール           |
+| WSL 2         | WSL 2 有効                                                                     | サポートされています                | Linux ツールチェーンまたはサンドボックス化されたコマンド実行 |
+| WSL 1         | WSL 1 有効                                                                     | サポートされていません               | WSL 2 が利用できない場合                   |
 
 **オプション 1: Git Bash を使用したネイティブ Windows**
@@ -126,5 +126,5 @@ PowerShell または CMD からインストールするかどうかは、実行
 ```
 
-Claude Code は Windows でネイティブに PowerShell を実行することもできます。PowerShell ツールは段階的にロールアウトされています。オプトインするには `CLAUDE_CODE_USE_POWERSHELL_TOOL=1` を設定するか、オプトアウトするには `0` を設定します。セットアップと制限については、[PowerShell ツール](/ja/tools-reference#powershell-tool)を参照してください。
```

</details>

<details>
<summary>skills-ja.md</summary>

```diff
diff --git a/docs-ja/pages/skills-ja.md b/docs-ja/pages/skills-ja.md
index bd1a731..989c286 100644
--- a/docs-ja/pages/skills-ja.md
+++ b/docs-ja/pages/skills-ja.md
@@ -41,5 +41,5 @@ Claude Code には、すべてのセッションで利用可能な一連のバ
 
   <Step title="SKILL.md を記述する">
-    すべてのスキルには `SKILL.md` ファイルが必要です。2 つの部分があります。YAML フロントマター（`---` マーカー間）は Claude にスキルをいつ使用するかを伝え、マークダウンコンテンツはスキルが呼び出されるときに Claude が従う指示です。`name` フィールドは `/slash-command` になり、`description` は Claude がスキルを自動的に読み込むかどうかを決定するのに役立ちます。
+    すべてのスキルには `SKILL.md` ファイルが必要です。2 つの部分があります。YAML フロントマター（`---` マーカー間）は Claude にスキルをいつ使用するかを伝え、マークダウンコンテンツはスキルが呼び出されるときに Claude が従う指示です。ディレクトリ名は `/slash-command` になり、`description` は Claude がスキルを自動的に読み込むかどうかを決定するのに役立ちます。
 
     `~/.claude/skills/explain-code/SKILL.md` を作成します：
@@ -47,5 +47,4 @@ Claude Code には、すべてのセッションで利用可能な一連のバ
     ```yaml theme={null}
     ---
-    name: explain-code
     description: Explains code with visual diagrams and analogies. Use when explaining how code works, teaching about a codebase, or when the user asks "how does this work?"
     ---
```

</details>

<details>
<summary>statusline-ja.md</summary>

```diff
diff --git a/docs-ja/pages/statusline-ja.md b/docs-ja/pages/statusline-ja.md
index 28c960a..df2cb56 100644
--- a/docs-ja/pages/statusline-ja.md
+++ b/docs-ja/pages/statusline-ja.md
@@ -917,5 +917,5 @@ Claude.ai サブスクリプションのレート制限使用状況をステー
 ### Windows 設定
 
-Windows では、Claude Code はステータスラインコマンドを Git Bash 経由で実行します。そのシェルから PowerShell を呼び出すことができます：
+Windows では、Claude Code はステータスラインコマンドを Git Bash 経由で実行します。Git Bash がインストールされている場合、または Git Bash がない場合は PowerShell を通じて実行します。PowerShell スクリプトをステータスラインとして実行するには、`powershell` 経由で呼び出します。これはどちらのシェルからでも機能します：
 
 <CodeGroup>
@@ -944,5 +944,5 @@ Windows では、Claude Code はステータスラインコマンドを Git Bash
 </CodeGroup>
 
-または Bash スクリプトを直接実行します：
+または、Git Bash がインストールされている場合は、Bash スクリプトを直接実行します：
 
 <CodeGroup>
```

</details>

<details>
<summary>tools-reference-ja.md</summary>

```diff
diff --git a/docs-ja/pages/tools-reference-ja.md b/docs-ja/pages/tools-reference-ja.md
index 462b419..4964c27 100644
--- a/docs-ja/pages/tools-reference-ja.md
+++ b/docs-ja/pages/tools-reference-ja.md
@@ -96,5 +96,5 @@ Monitor は [Bash と同じ権限ルール](/ja/permissions#tool-specific-permis
 ## PowerShell ツール
 
-PowerShell ツールを使用すると、Claude は PowerShell コマンドをネイティブに実行できます。Windows では、これは Git Bash を経由するのではなく、PowerShell でコマンドが実行されることを意味します。ツールは Windows で段階的にロールアウトされており、Linux、macOS、および WSL ではオプトインです。
+PowerShell ツールを使用すると、Claude は PowerShell コマンドをネイティブに実行できます。Windows では、これは Git Bash を経由するのではなく、PowerShell でコマンドが実行されることを意味します。Git Bash がない Windows では、ツールは自動的に有効になります。Git Bash がインストールされている Windows では、ツールは段階的にロールアウトされています。Linux、macOS、および WSL では、ツールはオプトインです。
 
 ### PowerShell ツールを有効にする
```

</details>

<details>
<summary>troubleshoot-install-ja.md</summary>

```diff
diff --git a/docs-ja/pages/troubleshoot-install-ja.md b/docs-ja/pages/troubleshoot-install-ja.md
index e316bda..15b50da 100644
--- a/docs-ja/pages/troubleshoot-install-ja.md
+++ b/docs-ja/pages/troubleshoot-install-ja.md
@@ -23,6 +23,7 @@
 | `irm is not recognized` または `&& is not valid`                                                | [シェルに適切なコマンドを使用する](#wrong-install-command-on-windows)                                             |
 | `'bash' is not recognized as the name of a cmdlet`                                           | [Windows インストーラーコマンドを使用する](#wrong-install-command-on-windows)                                     |
-| `Claude Code on Windows requires git-bash`                                                   | [Git Bash をインストールまたは設定する](#claude-code-on-windows-requires-git-bash)                              |
+| `Claude Code on Windows requires either Git for Windows (for bash) or PowerShell`            | [シェルをインストールする](#claude-code-on-windows-requires-either-git-for-windows-for-bash-or-powershell)    |
 | `Claude Code does not support 32-bit Windows`                                                | [Windows PowerShell を開く（x86 エントリではなく）](#claude-code-does-not-support-32-bit-windows)              |
+| `The process cannot access the file ... because it is being used by another process`         | [ダウンロードフォルダをクリアして再試行する](#the-process-cannot-access-the-file-during-windows-install)               |
 | `Error loading shared library`                                                               | [システムに対応したバイナリバリアント](#linux-musl-or-glibc-binary-mismatch)                                        |
 | `Illegal instruction`                                                                        | [アーキテクチャまたは CPU 命令セットの不一致](#illegal-instruction)                                                  |
@@ -112,4 +113,6 @@ curl -sI https://downloads.claude.ai/claude-code-releases/latest
     または、ターミナルを閉じて再度開いてください。
 
+    fish や Nushell などの他のシェルの場合は、シェル独自の設定構文を使用して `~/.local/bin` を PATH に追加してから、ターミナルを再起動してください。
+
     修正が機能したことを確認してください：
 
@@ -454,4 +457,15 @@ Invoke-Expression: Missing argument in parameter list.
   ```
 
+### Windows インストール中の `The process cannot access the file`
+
+PowerShell インストーラーが `Failed to download binary: The process cannot access the file ... because it is being used by another process` で失敗する場合、インストーラーは `%USERPROFILE%\.claude\downloads` に書き込むことができませんでした。これは通常、以前のインストール試行がまだ実行されているか、アンチウイルスソフトウェアがそのフォルダー内の部分的にダウンロードされたバイナリをスキャンしていることを意味します。
+
+インストーラーを実行している他の PowerShell ウィンドウを閉じ、アンチウイルススキャンがファイルを解放するのを待ってください。その後、ダウンロードフォルダーを削除してインストーラーを再度実行してください：
+
+```powershell theme={null}
```

</details>

*...以降省略*

</details>


<details>
<summary>2026-04-29</summary>

**変更ファイル:**

```
 docs-ja/pages/admin-setup-ja.md             |   8 +-
 docs-ja/pages/amazon-bedrock-ja.md          |   7 +-
 docs-ja/pages/authentication-ja.md          |  42 +-
 docs-ja/pages/changelog.md                  |  88 +++
 docs-ja/pages/cli-reference-ja.md           |   7 +-
 docs-ja/pages/commands-ja.md                | 170 ++---
 docs-ja/pages/common-workflows-ja.md        |  14 +-
 docs-ja/pages/data-usage-ja.md              |  14 +-
 docs-ja/pages/debug-your-config-ja.md       |  11 +-
 docs-ja/pages/env-vars-ja.md                |  17 +-
 docs-ja/pages/errors-ja.md                  |  19 +-
 docs-ja/pages/fullscreen-ja.md              |   6 +-
 docs-ja/pages/google-vertex-ai-ja.md        |   6 +-
 docs-ja/pages/hooks-guide-ja.md             |  12 +-
 docs-ja/pages/hooks-ja.md                   | 219 +++++--
 docs-ja/pages/interactive-mode-ja.md        |   2 +-
 docs-ja/pages/jetbrains-ja.md               |  75 ++-
 docs-ja/pages/legal-and-compliance-ja.md    |   8 +-
 docs-ja/pages/llm-gateway-ja.md             |  10 +
 docs-ja/pages/mcp-ja.md                     |  24 +-
 docs-ja/pages/monitoring-usage-ja.md        |  48 +-
 docs-ja/pages/overview-ja.md                | 678 ++++++++++++++++++-
 docs-ja/pages/plugin-dependencies-ja.md     |  18 +
 docs-ja/pages/plugin-marketplaces-ja.md     |  15 +-
 docs-ja/pages/plugins-ja.md                 |   4 +-
 docs-ja/pages/plugins-reference-ja.md       |  79 ++-
 docs-ja/pages/quickstart-ja.md              |   4 +-
 docs-ja/pages/sandboxing-ja.md              |   4 +
 docs-ja/pages/security-ja.md                |  20 +-
 docs-ja/pages/server-managed-settings-ja.md |  18 +-
 docs-ja/pages/settings-ja.md                |   2 +-
 docs-ja/pages/setup-ja.md                   |  24 +-
 docs-ja/pages/skills-ja.md                  |   1 +
 docs-ja/pages/statusline-ja.md              |   2 +
 docs-ja/pages/sub-agents-ja.md              |  10 +-
 docs-ja/pages/terminal-config-ja.md         |   2 +
 docs-ja/pages/tools-reference-ja.md         |   1 -
 docs-ja/pages/troubleshooting-ja.md         | 972 ++--------------------------
 docs-ja/pages/ultrareview-ja.md             |  25 +-
 docs-ja/pages/voice-dictation-en.md         | 189 ------
 40 files changed, 1427 insertions(+), 1448 deletions(-)
```

**新規追加:**


**削除:**


<details>
<summary>admin-setup-ja.md</summary>

```diff
diff --git a/docs-ja/pages/admin-setup-ja.md b/docs-ja/pages/admin-setup-ja.md
index 21a13aa..64e4f81 100644
--- a/docs-ja/pages/admin-setup-ja.md
+++ b/docs-ja/pages/admin-setup-ja.md
@@ -107,13 +107,13 @@ Team、Enterprise、Claude API、およびクラウドプロバイダープラ
 ## 検証とオンボード
 
-マネージド設定を設定した後、開発者に Claude Code 内で `/status` を実行させてください。出力には `Enterprise managed settings` で始まる行が含まれ、その後に括弧内のソースが続きます。`(remote)`、`(plist)`、`(HKLM)`、`(HKCU)`、または `(file)` のいずれかです。[Verify active settings](/ja/settings#verify-active-settings) を参照してください。
+マネージド設定を設定した後、開発者に Claude Code 内で `/status` を実行させてください。出力には `Enterprise managed settings` で始まる行が含まれ、その後に括弧内のソースが続きます。`(remote)`、`(plist)`、`(HKLM)`、`(HKCU)`、または `(file)` のいずれかです。[アクティブな設定を検証](/ja/settings#verify-active-settings) を参照してください。
 
 開発者が開始するのに役立つこれらのリソースを共有してください。
 
-* [Quickstart](/ja/quickstart): インストールからプロジェクトの操作まで、最初のセッションのウォークスルー
-* [Common workflows](/ja/common-workflows): コードレビュー、リファクタリング、デバッグなどの日常的なタスクのパターン
+* [クイックスタート](/ja/quickstart): インストールからプロジェクトの操作まで、最初のセッションのウォークスルー
+* [一般的なワークフロー](/ja/common-workflows): コードレビュー、リファクタリング、デバッグなどの日常的なタスクのパターン
 * [Claude 101](https://anthropic.skilljar.com/claude-101) と [Claude Code in Action](https://anthropic.skilljar.com/claude-code-in-action): Anthropic Academy の自習型コース
 
-ログインの問題については、開発者に [authentication troubleshooting](/ja/troubleshooting#authentication-issues) を指してください。最も一般的な修正は次のとおりです。
+ログインの問題については、開発者に [認証のトラブルシューティング](/ja/troubleshoot-install#login-and-authentication) を指してください。最も一般的な修正は次のとおりです。
 
 * `/logout` を実行してから `/login` を実行してアカウントを切り替える
```

</details>

<details>
<summary>amazon-bedrock-ja.md</summary>

```diff
diff --git a/docs-ja/pages/amazon-bedrock-ja.md b/docs-ja/pages/amazon-bedrock-ja.md
index a3e2c8f..799be23 100644
--- a/docs-ja/pages/amazon-bedrock-ja.md
+++ b/docs-ja/pages/amazon-bedrock-ja.md
@@ -418,5 +418,6 @@ Claude Code に必要な権限を持つ IAM ポリシーを作成します。
         "bedrock:InvokeModel",
         "bedrock:InvokeModelWithResponseStream",
-        "bedrock:ListInferenceProfiles"
+        "bedrock:ListInferenceProfiles",
+        "bedrock:GetInferenceProfile"
       ],
       "Resource": [
@@ -446,4 +447,8 @@ Claude Code に必要な権限を持つ IAM ポリシーを作成します。
 より制限的な権限の場合は、リソースを特定の推論プロファイル ARN に制限できます。
 
+`bedrock:GetInferenceProfile` により、Claude Code は[アプリケーション推論プロファイル ARN](#map-each-model-version-to-an-inference-profile) をそのバッキング基盤モデルに解決でき、そのモデルに対して正しいリクエスト形状を選択するために使用されます。
+
+トークンにこの権限がない場合、Claude Code は代替形状で 1 回再試行することで自動的に復旧するため、リクエストは成功しますが、新しいモデルが追加されるたびに追加のラウンドトリップが発生します。権限を付与することで再試行を回避できます。これは `AWS_BEARER_TOKEN_BEDROCK` デプロイメントに最も頻繁に適用され、トークンのポリシーは通常、完全な IAM ロールよりも狭くなります。
+
 詳細については、[Bedrock IAM documentation](https://docs.aws.amazon.com/bedrock/latest/userguide/security-iam.html) を参照してください。
 
```

</details>

<details>
<summary>authentication-ja.md</summary>

```diff
diff --git a/docs-ja/pages/authentication-ja.md b/docs-ja/pages/authentication-ja.md
index 97eb374..d100276 100644
--- a/docs-ja/pages/authentication-ja.md
+++ b/docs-ja/pages/authentication-ja.md
@@ -15,4 +15,6 @@ Claude Code は、セットアップに応じて複数の認証方法をサポ
 ブラウザが自動的に開かない場合は、`c` を押してログイン URL をクリップボードにコピーし、ブラウザに貼り付けます。
 
+ブラウザがサインイン後にリダイレクトされずにログインコードを表示する場合は、`Paste code here if prompted` プロンプトでそれをターミナルに貼り付けます。
+
 以下のいずれかのアカウントタイプで認証できます。
 
@@ -24,5 +26,5 @@ Claude Code は、セットアップに応じて複数の認証方法をサポ
 ログアウトして再認証するには、Claude Code プロンプトで `/logout` と入力します。
 
-ログインに問題がある場合は、[認証のトラブルシューティング](/ja/troubleshooting#authentication-issues)を参照してください。
+ログインに問題がある場合は、[認証のトラブルシューティング](/ja/troubleshoot-install#login-and-authentication)を参照してください。
 
 ## チーム認証を設定する
@@ -112,6 +114,42 @@ Amazon Bedrock、Google Vertex AI、または Microsoft Foundry を使用する
 Claude Code は認証認証情報を安全に管理します。
 
-* **保存場所**: macOS では、認証情報は暗号化された macOS Keychain に保存されます。
+* **保存場所**: macOS では、認証情報は暗号化された macOS Keychain に保存されます。Linux と Windows では、認証情報は `~/.claude/.credentials.json` に保存されるか、その変数が設定されている場合は `$CLAUDE_CONFIG_DIR` の下に保存されます。Linux では、ファイルはモード `0600` で書き込まれます。Windows では、ユーザープロファイルディレクトリのアクセス制御を継承します。
 * **サポートされている認証タイプ**: Claude.ai 認証情報、Claude API 認証情報、Azure Auth、Bedrock Auth、および Vertex Auth。
 * **カスタム認証情報スクリプト**: [`apiKeyHelper`](/ja/settings#available-settings) 設定は、API キーを返すシェルスクリプトを実行するように設定できます。
 * **更新間隔**: デフォルトでは、`apiKeyHelper` は 5 分後または HTTP 401 レスポンス時に呼び出されます。カスタム更新間隔の場合は、`CLAUDE_CODE_API_KEY_HELPER_TTL_MS` 環境変数を設定してください。
+* **遅いヘルパー通知**: `apiKeyHelper` がキーを返すのに 10 秒以上かかる場合、Claude Code はプロンプトバーに経過時間を表示する警告通知を表示します。この通知が定期的に表示される場合は、認証情報スクリプトを最適化できるかどうかを確認してください。
+
+`apiKeyHelper`、`ANTHROPIC_API_KEY`、および `ANTHROPIC_AUTH_TOKEN` はターミナル CLI セッションにのみ適用されます。Claude Desktop とリモートセッションは OAuth のみを使用し、`apiKeyHelper` を呼び出したり、API キー環境変数を読み込んだりしません。
+
```

</details>

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index bd99d3b..7359d2c 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,92 @@
 # Changelog
 
+## 2.1.122
+
+- Added `ANTHROPIC_BEDROCK_SERVICE_TIER` environment variable to select a Bedrock service tier (`default`, `flex`, or `priority`), sent as the `X-Amzn-Bedrock-Service-Tier` header
+- Pasting a PR URL into the `/resume` search box now finds the session that created that PR (GitHub, GitHub Enterprise, GitLab, and Bitbucket)
+- `/mcp` now shows claude.ai connectors hidden by a manually-added server with the same URL, with a hint to remove the duplicate
+- Clarified the `/mcp` message shown when an MCP server is still unauthorized after the browser sign-in flow
+- OpenTelemetry: numeric attributes on `api_request`/`api_error` log events are now emitted as numbers, not strings
+- OpenTelemetry: added `claude_code.at_mention` log event for `@`-mention resolution
+- Fixed `/branch` producing forks that fail with "tool_use ids were found without tool_result blocks" when the source session contained entries from rewound timelines
+- Fixed `/model` not showing the Effort option for Bedrock application inference profile ARNs, and those ARNs not receiving `output_config.effort`
+- Fixed Vertex AI / Bedrock returning `invalid_request_error: output_config: Extra inputs are not permitted` on session-title generation and other structured-output queries
+- Fixed Vertex AI `count_tokens` endpoint returning 400 errors for users behind proxy gateways
+- Fixed `spinnerTipsOverride.excludeDefault` not suppressing the time-based spinner tips
+- Fixed ToolSearch missing MCP tools that connected after session start in nonblocking mode
+- Fixed `!exit` / `!quit` in bash mode terminating the CLI instead of running as a shell command
+- Fixed images sent to newer models being resized to 2576px per side instead of the correct 2000px maximum
+- Fixed remote control session idle status redrawing twice per second, which could flood `tmux -CC` control pipes and pause the terminal
+- Fixed assistant messages appearing blank in some sessions due to a stale view preference
+- Fixed a malformed hooks entry in `settings.json` no longer invalidating the entire file
+- Voice mode: keybindings bound to Caps Lock now show an error since terminals don't deliver Caps Lock as a key event
+
+## 2.1.121
+
```

</details>

<details>
<summary>cli-reference-ja.md</summary>

```diff
diff --git a/docs-ja/pages/cli-reference-ja.md b/docs-ja/pages/cli-reference-ja.md
index a3a3bac..d12336f 100644
--- a/docs-ja/pages/cli-reference-ja.md
+++ b/docs-ja/pages/cli-reference-ja.md
@@ -31,4 +31,5 @@
 | `claude remote-control`         | [Remote Control](/ja/remote-control) サーバーを開始して、Claude.ai または Claude アプリから Claude Code を制御します。サーバーモード（ローカルインタラクティブセッションなし）で実行されます。[サーバーモードフラグ](/ja/remote-control#start-a-remote-control-session) を参照してください | `claude remote-control --name "My Project"`                 |
 | `claude setup-token`            | CI とスクリプト用の長期間有効な OAuth トークンを生成します。ターミナルにトークンを出力し、保存しません。Claude サブスクリプションが必要です。[長期間有効なトークンを生成](/ja/authentication#generate-a-long-lived-token) を参照してください                                                   | `claude setup-token`                                        |
+| `claude ultrareview [target]`   | [ultrareview](/ja/ultrareview#run-ultrareview-non-interactively) を非対話的に実行します。結果を stdout に出力し、成功時は 0 で終了し、失敗時は 1 で終了します。`--json` を使用して生のペイロードを取得し、`--timeout <minutes>` を使用して 30 分のデフォルトをオーバーライドできます        | `claude ultrareview 1234 --json`                            |
 
 サブコマンドを誤入力した場合、Claude Code は最も近い一致を提案して、セッションを開始せずに終了します。たとえば、`claude udpate` は `Did you mean claude update?` と出力します。
@@ -65,11 +66,11 @@
 | `--from-pr`                                     | 特定のプルリクエストにリンクされたセッションを再開します。PR 番号、GitHub または GitHub Enterprise PR URL、GitLab マージリクエスト URL、または Bitbucket プルリクエスト URL を受け入れます。Claude がプルリクエストを作成するときに、セッションは自動的にリンクされます                                                                                        | `claude --from-pr 123`                                                                             |
 | `--ide`                                         | 起動時に、正確に 1 つの有効な IDE が利用可能な場合、自動的に IDE に接続します                                                                                                                                                                                                                 | `claude --ide`                                                                                     |
-| `--init`                                        | 初期化フックを実行してインタラクティブモードを開始                                                                                                                                                                                                                                     | `claude --init`                                                                                    |
-| `--init-only`                                   | 初期化フックを実行して終了（インタラクティブセッションなし）                                                                                                                                                                                                                                | `claude --init-only`                                                                               |
+| `--init`                                        | セッション開始前に `init` マッチャーで [Setup hooks](/ja/hooks#setup) を実行します（プリントモードのみ）                                                                                                                                                                                      | `claude -p --init "query"`                                                                         |
+| `--init-only`                                   | [Setup](/ja/hooks#setup) および `SessionStart` hooks を実行してから、会話を開始せずに終了します                                                                                                                                                                                       | `claude --init-only`                                                                               |
 | `--include-hook-events`                         | すべてのフックライフサイクルイベントを出力ストリームに含めます。`--output-format stream-json` が必要です                                                                                                                                                                                           | `claude -p --output-format stream-json --include-hook-events "query"`                              |
 | `--include-partial-messages`                    | 部分的なストリーミングイベントを出力に含めます。`--print` と `--output-format stream-json` が必要です                                                                                                                                                                                       | `claude -p --output-format stream-json --include-partial-messages "query"`                         |
 | `--input-format`                                | プリントモードの入力形式を指定します（オプション：`text`、`stream-json`）                                                                                                                                                                                                                | `claude -p --output-format json --input-format stream-json`                                        |
 | `--json-schema`                                 | エージェントがワークフローを完了した後、JSON Schema に一致する検証済み JSON 出力を取得します（プリントモードのみ。[構造化出力](/ja/agent-sdk/structured-outputs) を参照）                                                                                                                                              | `claude -p --json-schema '{"type":"object","properties":{...}}' "query"`                           |
-| `--maintenance`                                 | メンテナンスフックを実行してインタラクティブモードを開始                                                                                                                                                                                                                                  | `claude --maintenance`                                                                             |
+| `--maintenance`                                 | セッション開始前に `maintenance` マッチャーで [Setup hooks](/ja/hooks#setup) を実行します（プリントモードのみ）                                                                                                                                                                               | `claude -p --maintenance "query"`                                                                  |
 | `--max-budget-usd`                              | 停止する前に API 呼び出しに費やす最大ドル金額（プリントモードのみ）                                                                                                                                                                                                                          | `claude -p --max-budget-usd 5.00 "query"`                                                          |
 | `--max-turns`                                   | agentic ターンの数を制限します（プリントモードのみ）。制限に達するとエラーで終了します。デフォルトでは制限なし                                                                                                                                                                                                   | `claude -p --max-turns 3 "query"`                                                                  |
```

</details>

<details>
<summary>commands-ja.md</summary>

```diff
diff --git a/docs-ja/pages/commands-ja.md b/docs-ja/pages/commands-ja.md
index 6f6fe09..727d194 100644
--- a/docs-ja/pages/commands-ja.md
+++ b/docs-ja/pages/commands-ja.md
@@ -17,89 +17,89 @@
 以下の表では、`<arg>` は必須引数を示し、`[arg]` はオプション引数を示します。
 
-| コマンド                         | 目的                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
-| :--------------------------- | :--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
-| `/add-dir <path>`            | 現在のセッション中にファイルアクセス用の作業ディレクトリを追加。ほとんどの `.claude/` 設定は追加されたディレクトリから[検出されません](/ja/permissions#additional-directories-grant-file-access-not-configuration)。後で `--continue` または `--resume` を使用して、追加されたディレクトリからセッションを再開できます                                                                                                                                                                                                                                      |
-| `/agents`                    | [エージェント](/ja/sub-agents)設定を管理                                                                                                                                                                                                                                                                                                                                                                                                                              |
-| `/autofix-pr [prompt]`       | 現在のブランチの PR を監視し、CI が失敗するか、レビュアーがコメントを残したときに修正をプッシュする [Claude Code on the web](/ja/claude-code-on-the-web#auto-fix-pull-requests) セッションを生成。`gh pr view` で開いている PR を検出します。別の PR を監視するには、最初にそのブランチをチェックアウトしてください。デフォルトでは、リモートセッションはすべての CI 失敗とレビューコメントを修正するよう指示されます。プロンプトを渡して異なる指示を与えることができます。例えば `/autofix-pr only fix lint and type errors`。`gh` CLI と [Claude Code on the web](/ja/claude-code-on-the-web#who-can-use-claude-code-on-the-web) へのアクセスが必要です |
-| `/batch <instruction>`       | **[スキル](/ja/skills#bundled-skills)。** コードベース全体にわたる大規模な変更を並列で調整します。コードベースを調査し、作業を 5 ～ 30 個の独立したユニットに分解し、計画を提示します。承認されると、分離された [git worktree](/ja/common-workflows#run-parallel-claude-code-sessions-with-git-worktrees) 内の各ユニットごとに 1 つのバックグラウンドエージェントを生成します。各エージェントはそのユニットを実装し、テストを実行し、プルリクエストを開きます。git リポジトリが必要です。例: `/batch migrate src/ from Solid to React`                                                                                             |
-| `/branch [name]`             | この時点で現在の会話のブランチを作成。ブランチに切り替え、元の会話を保持します。`/resume` で戻ることができます。エイリアス: `/fork`。[`CLAUDE_CODE_FORK_SUBAGENT`](/ja/env-vars) が設定されている場合、`/fork` は代わりに[フォークされたサブエージェント](/ja/sub-agents#fork-the-current-conversation)を生成し、このコマンドのエイリアスではなくなります                                                                                                                                                                                                                   |
-| `/btw <question>`            | 会話に追加せずに[サイドクエスチョン](/ja/interactive-mode#side-questions-with-%2Fbtw)として素早く質問                                                                                                                                                                                                                                                                                                                                                                               |
-| `/chrome`                    | [Chrome の Claude](/ja/chrome) 設定を構成                                                                                                                                                                                                                                                                                                                                                                                                                        |
-| `/claude-api`                | **[スキル](/ja/skills#bundled-skills)。** プロジェクトの言語（Python、TypeScript、Java、Go、Ruby、C#、PHP、または cURL）と Managed Agents リファレンス用の Claude API リファレンス資料を読み込みます。ツール使用、ストリーミング、バッチ、構造化出力、および一般的な落とし穴をカバーしています。また、コードが `anthropic` または `@anthropic-ai/sdk` をインポートするときに自動的にアクティブになります                                                                                                                                                                                     |
-| `/clear`                     | 空のコンテキストで新しい会話を開始。前の会話は `/resume` で利用可能なままです。同じ会話を続けながらコンテキストを解放するには、代わりに `/compact` を使用してください。エイリアス: `/reset`、`/new`                                                                                                                                                                                                                                                                                                                                      |
-| `/color [color\|default]`    | 現在のセッションのプロンプトバーの色を設定。利用可能な色: `red`、`blue`、`green`、`yellow`、`purple`、`orange`、`pink`、`cyan`。`default` を使用してリセット。[リモートコントロール](/ja/remote-control)が接続されている場合、色は claude.ai/code に同期されます                                                                                                                                                                                                                                                                       |
-| `/compact [instructions]`    | 会話をここまで要約してコンテキストを解放。オプションで要約のフォーカス指示を渡します。[コンパクション時にルール、スキル、メモリファイルがどのように処理されるか](/ja/context-window#what-survives-compaction)を参照してください                                                                                                                                                                                                                                                                                                                    |
-| `/config`                    | [設定](/ja/settings)インターフェースを開いて、テーマ、モデル、[出力スタイル](/ja/output-styles)、およびその他の設定を調整。エイリアス: `/settings`                                                                                                                                                                                                                                                                                                                                                         |
-| `/context`                   | 現在のコンテキスト使用状況をカラーグリッドとして視覚化。コンテキストが多いツール、メモリ肥大化、容量警告の最適化提案を表示                                                                                                                                                                                                                                                                                                                                                                                              |
-| `/copy [N]`                  | 最後のアシスタント応答をクリップボードにコピー。数字 `N` を渡して N 番目に新しい応答をコピー: `/copy 2` は 2 番目に新しい応答をコピー。コードブロックが存在する場合、個別ブロックまたは完全な応答を選択するインタラクティブピッカーを表示。ピッカーで `w` を押して、クリップボードの代わりにファイルに選択内容を書き込み。SSH 経由で便利です                                                                                                                                                                                                                                                                     |
-| `/cost`                      | `/usage` のエイリアス                                                                                                                                                                                                                                                                                                                                                                                                                                            |
-| `/debug [description]`       | **[スキル](/ja/skills#bundled-skills)。** 現在のセッションのデバッグログを有効にし、セッションデバッグログを読むことで問題をトラブルシューティングします。デバッグログはデフォルトではオフです。`claude --debug` で開始した場合を除き、セッション中に `/debug` を実行するとその時点からログのキャプチャを開始します。オプションで問題を説明して分析にフォーカスを当てます                                                                                                                                                                                                                                        |
-| `/desktop`                   | 現在のセッションを Claude Code デスクトップアプリで続行。macOS と Windows のみ。エイリアス: `/app`                                                                                                                                                                                                                                                                                                                                                                                        |
-| `/diff`                      | コミットされていない変更と各ターンの diff を表示するインタラクティブ diff ビューアを開きます。左右矢印を使用して現在の git diff と個別の Claude ターンを切り替え、上下矢印でファイルをブラウズします                                                                                                                                                                                                                                                                                                                                          |
-| `/doctor`                    | Claude Code のインストールと設定を診断および検証。結果はステータスアイコン付きで表示されます。`f` を押して Claude に報告された問題を修正させます                                                                                                                                                                                                                                                                                                                                                                       |
-| `/effort [level\|auto]`      | モデルの[努力レベル](/ja/model-config#adjust-effort-level)を設定。`low`、`medium`、`high`、`xhigh`、または `max` を受け入れます。利用可能なレベルはモデルに依存し、`max` はセッションのみです。`auto` はモデルのデフォルトにリセットします。引数なしで、インタラクティブスライダーを開きます。左右矢印でレベルを選択し、`Enter` で適用します。現在の応答の完了を待たずに即座に有効になります                                                                                                                                                                                                              |
-| `/exit`                      | CLI を終了。エイリアス: `/quit`                                                                                                                                                                                                                                                                                                                                                                                                                                     |
```

</details>

*...以降省略*

</details>


<details>
<summary>2026-04-28</summary>

**変更ファイル:**

```
 docs-ja/pages/devcontainer-ja.md   | 209 ++++++++++++++++++++++++++++---------
 docs-ja/pages/network-config-ja.md |   2 +
 docs-ja/pages/sandboxing-ja.md     |  18 ++--
 docs-ja/pages/security-ja.md       |   4 +-
 4 files changed, 174 insertions(+), 59 deletions(-)
```

<details>
<summary>devcontainer-ja.md</summary>

```diff
diff --git a/docs-ja/pages/devcontainer-ja.md b/docs-ja/pages/devcontainer-ja.md
index 35b2ece..bbeeb37 100644
--- a/docs-ja/pages/devcontainer-ja.md
+++ b/docs-ja/pages/devcontainer-ja.md
@@ -5,77 +5,190 @@
 # 開発コンテナ
 
-> 一貫性のある安全な環境が必要なチーム向けのClaude Code開発コンテナについて学びます。
+> チーム全体で一貫した分離環境を実現するため、開発コンテナ内で Claude Code を実行します。
 
-リファレンス[devcontainerセットアップ](https://github.com/anthropics/claude-code/tree/main/.devcontainer)と関連する[Dockerfile](https://github.com/anthropics/claude-code/blob/main/.devcontainer/Dockerfile)は、そのまま使用することも、ニーズに合わせてカスタマイズすることもできる事前設定済みの開発コンテナを提供します。このdevcontainerはVisual Studio Code [Dev Containers拡張機能](https://code.visualstudio.com/docs/devcontainers/containers)および同様のツールと連携します。
+[開発コンテナ](https://containers.dev/)（dev container）を使用すると、チームのすべてのエンジニアが実行できる同一の分離環境を定義できます。Claude Code がそのコンテナにインストールされている場合、Claude が実行するコマンドはホストマシンではなくコンテナ内で実行され、プロジェクトファイルへの編集はローカルリポジトリに表示されます。
 
-コンテナの強化されたセキュリティ対策（分離とファイアウォールルール）により、`claude --dangerously-skip-permissions`を実行して権限プロンプトをバイパスし、無人操作を行うことができます。
+このページでは、[開発コンテナに Claude Code をインストール](#add-claude-code-to-your-dev-container)する方法と、その後の設定トピックについて説明します。各トピックは独立しているため、必要な設定に合わせてジャンプしてください：
+
+* [再構築時に認証と設定を保持する](#persist-authentication-and-settings-across-rebuilds)
+* [組織ポリシーを適用する](#enforce-organization-policy)
+* [ネットワークエグレスを制限する](#restrict-network-egress)
+* [権限プロンプトなしで実行する](#run-without-permission-prompts)
 
 <Warning>
-  devcontainerは実質的な保護を提供していますが、すべての攻撃に完全に耐性のあるシステムはありません。
-  `--dangerously-skip-permissions`で実行する場合、devcontainerはClaude Codeの認証情報を含むdevcontainer内でアクセス可能なものを悪意のあるプロジェクトが流出させることを防ぎません。
-  信頼できるリポジトリで開発する場合にのみdevcontainerを使用することをお勧めします。
-  常に良好なセキュリティプラクティスを維持し、Claudeのアクティビティを監視してください。
+  開発コンテナは実質的な保護を提供していますが、すべての攻撃に完全に耐性のあるシステムはありません。
+  `--dangerously-skip-permissions` で実行する場合、開発コンテナは、[`~/.claude`](/ja/claude-directory) に保存されている Claude Code の認証情報を含む、コンテナ内でアクセス可能なものを悪意のあるプロジェクトが流出させることを防ぎません。
+  信頼できるリポジトリで開発する場合にのみ開発コンテナを使用し、Claude のアクティビティを監視してください。
+  `~/.ssh` やクラウド認証情報ファイルなどのホストシークレットをコンテナにマウントすることは避け、リポジトリスコープまたは短期間有効なトークンを使用してください。
```

</details>

<details>
<summary>network-config-ja.md</summary>

```diff
diff --git a/docs-ja/pages/network-config-ja.md b/docs-ja/pages/network-config-ja.md
index 2a05205..d667485 100644
--- a/docs-ja/pages/network-config-ja.md
+++ b/docs-ja/pages/network-config-ja.md
@@ -118,4 +118,6 @@ Claude Code は以下の URL へのアクセスが必要です。プロキシ設
 npm を通じて Claude Code をインストールするか、独自のバイナリ配布を管理する場合、エンドユーザーは `downloads.claude.ai` または `storage.googleapis.com` へのアクセスが不要な場合があります。
 
+Claude Code はデフォルトでオプションの運用テレメトリを送信します。これは環境変数で無効にできます。ホワイトリストを最終化する前に、[テレメトリサービス](/ja/data-usage#telemetry-services) を参照して無効にする方法を確認してください。
+
 [Amazon Bedrock](/ja/amazon-bedrock)、[Google Vertex AI](/ja/google-vertex-ai)、または [Microsoft Foundry](/ja/microsoft-foundry) を使用する場合、モデルトラフィックと認証は `api.anthropic.com`、`claude.ai`、または `platform.claude.com` ではなくプロバイダーに送信されます。WebFetch ツールは、[settings](/ja/settings) で `skipWebFetchPreflight: true` を設定しない限り、[ドメイン安全性チェック](/ja/data-usage#webfetch-domain-safety-check) のために `api.anthropic.com` を呼び出します。
 
```

</details>

<details>
<summary>sandboxing-ja.md</summary>

```diff
diff --git a/docs-ja/pages/sandboxing-ja.md b/docs-ja/pages/sandboxing-ja.md
index c99ac9a..0e4ff9f 100644
--- a/docs-ja/pages/sandboxing-ja.md
+++ b/docs-ja/pages/sandboxing-ja.md
@@ -72,5 +72,5 @@ WSL1 は bubblewrap が WSL2 でのみ利用可能なカーネル機能を必要
 **macOS** では、サンドボックス化は組み込みの Seatbelt フレームワークを使用してすぐに動作します。
 
-**Linux と WSL2** では、まず必要なパッケージをインストールします。
+**Linux と WSL2** では、まず必要なパッケージをインストールしてください。
 
 <Tabs>
@@ -98,5 +98,5 @@ WSL1 は bubblewrap が WSL2 でのみ利用可能なカーネル機能を必要
 これはサンドボックスモードを選択できるメニューを開きます。必要な依存関係（Linux の `bubblewrap` や `socat` など）が不足している場合、メニューはプラットフォームのインストール手順を表示します。
 
-デフォルトでは、サンドボックスが起動できない場合（依存関係の不足、サポートされていないプラットフォーム、またはプラットフォーム制限）、Claude Code は警告を表示してサンドボックス化なしでコマンドを実行します。これをハード失敗にするには、[`sandbox.failIfUnavailable`](/ja/settings#sandbox-settings) を `true` に設定します。これは、セキュリティゲートとしてサンドボックス化を必要とする管理デプロイメント向けです。
+デフォルトでは、サンドボックスが起動できない場合（依存関係の不足またはサポートされていないプラットフォーム）、Claude Code は警告を表示してサンドボックス化なしでコマンドを実行します。これをハード失敗にするには、[`sandbox.failIfUnavailable`](/ja/settings#sandbox-settings) を `true` に設定します。これは、セキュリティゲートとしてサンドボックス化を必要とする管理デプロイメント向けです。
 
 ### サンドボックスモード
@@ -104,5 +104,5 @@ WSL1 は bubblewrap が WSL2 でのみ利用可能なカーネル機能を必要
 Claude Code は 2 つのサンドボックスモードを提供します。
 
-**自動許可モード**：Bash コマンドはサンドボックス内で実行を試みられ、許可なしに自動的に許可されます。サンドボックス化できないコマンド（許可されていないホストへのネットワークアクセスが必要なコマンドなど）は通常の許可フローにフォールバックします。明示的な拒否ルールは常に尊重されます。Ask ルールは通常の許可フローにフォールバックするコマンドにのみ適用されます。
+**自動許可モード**：Bash コマンドはサンドボックス内で実行を試みられ、許可なしに自動的に許可されます。サンドボックス化できないコマンド（許可されていないホストへのネットワークアクセスが必要なコマンドなど）は通常の許可フローにフォールバックします。明示的な拒否ルールは常に尊重されます。また、`rm` または `rmdir` コマンドが `/`、ホームディレクトリ、または他の重要なシステムパスをターゲットにしている場合でも、許可プロンプトがトリガーされます。Ask ルールは通常の許可フローにフォールバックするコマンドにのみ適用されます。
 
 **通常の許可モード**：すべての bash コマンドは、サンドボックス化されている場合でも標準的な許可フローを通じます。これはより多くの制御を提供しますが、より多くの承認が必要です。
@@ -139,9 +139,9 @@ Claude Code は 2 つのサンドボックスモードを提供します。
 パスプレフィックスはパスの解決方法を制御します。
 
-| プレフィックス           | 意味                                                          | 例                                                                      |
-| :---------------- | :---------------------------------------------------------- | :--------------------------------------------------------------------- |
```

</details>

<details>
<summary>security-ja.md</summary>

```diff
diff --git a/docs-ja/pages/security-ja.md b/docs-ja/pages/security-ja.md
index 367ac99..25f2a1d 100644
--- a/docs-ja/pages/security-ja.md
+++ b/docs-ja/pages/security-ja.md
@@ -76,5 +76,5 @@ Claude Code は、ユーザーが付与したパーミッションのみを持
 3. 重要なファイルへの提案された変更を確認します
 4. 仮想マシン（VM）を使用してスクリプトを実行し、ツール呼び出しを行います。特に外部 Web サービスと対話する場合
-5. `/bug` で疑わしい動作を報告します
+5. `/feedback` で疑わしい動作を報告します
 
 <Warning>
@@ -113,5 +113,5 @@ IDE で Claude Code を実行する場合の詳細については、[VS Code sec
 * 承認前にすべての提案された変更を確認します
 * 機密リポジトリにはプロジェクト固有のパーミッション設定を使用します
-* 追加の分離のために [devcontainers](/ja/devcontainer) の使用を検討します
+* 追加の分離のために [dev containers](/ja/devcontainer) の使用を検討します
 * `/permissions` で定期的にパーミッション設定を監査します
 
```

</details>

</details>


<details>
<summary>2026-04-27</summary>

**変更ファイル:**

```
 docs-ja/pages/chrome-ja.md | 21 +++++++++++++++------
 docs-ja/pages/skills-ja.md |  2 +-
 2 files changed, 16 insertions(+), 7 deletions(-)
```

<details>
<summary>chrome-ja.md</summary>

```diff
diff --git a/docs-ja/pages/chrome-ja.md b/docs-ja/pages/chrome-ja.md
index dc7506f..3d0a04a 100644
--- a/docs-ja/pages/chrome-ja.md
+++ b/docs-ja/pages/chrome-ja.md
@@ -7,10 +7,10 @@
 > Claude Code を Chrome ブラウザに接続して、Web アプリをテストし、コンソールログでデバッグし、フォーム入力を自動化し、Web ページからデータを抽出します。
 
-Claude Code は Claude in Chrome ブラウザ拡張機能と統合され、CLI または [VS Code 拡張機能](/ja/vs-code#automate-browser-tasks-with-chrome) からブラウザ自動化機能を提供します。コードをビルドしてから、コンテキストを切り替えることなくブラウザでテストおよびデバッグできます。
+Claude Code は [Claude in Chrome ブラウザ拡張機能](https://chromewebstore.google.com/detail/claude/fcoeoabgfenejglbffodgkkbkcdhcgfn) と統合され、CLI または [VS Code 拡張機能](/ja/vs-code#automate-browser-tasks-with-chrome) からブラウザ自動化機能を提供します。コードをビルドしてから、コンテキストを切り替えることなくブラウザでテストおよびデバッグできます。
 
 Claude はブラウザタスク用に新しいタブを開き、ブラウザのログイン状態を共有するため、既にサインインしているサイトにアクセスできます。ブラウザアクションはリアルタイムで表示される Chrome ウィンドウで実行されます。Claude がログインページまたは CAPTCHA に遭遇した場合、一時停止して手動で処理するよう求めます。
 
 <Note>
-  Chrome 統合はベータ版であり、現在 Google Chrome のみで動作します。Brave、Arc、またはその他の Chromium ベースのブラウザではまだサポートされていません。WSL（Windows Subsystem for Linux）もサポートされていません。
+  Chrome 統合はベータ版であり、現在 Google Chrome と Microsoft Edge で動作します。Brave、Arc、またはその他の Chromium ベースのブラウザではまだサポートされていません。WSL（Windows Subsystem for Linux）もサポートされていません。
 </Note>
 
@@ -31,6 +31,6 @@ Chrome が接続されている場合、単一のワークフロー内でブラ
 Claude Code を Chrome で使用する前に、以下が必要です。
 
-* [Google Chrome](https://www.google.com/chrome/) ブラウザ
-* [Claude in Chrome 拡張機能](https://chromewebstore.google.com/detail/claude/fcoeoabgfenejglbffodgkkbkcdhcgfn) バージョン 1.0.36 以上
+* [Google Chrome](https://www.google.com/chrome/) または [Microsoft Edge](https://www.microsoft.com/edge) ブラウザ
+* [Claude in Chrome 拡張機能](https://chromewebstore.google.com/detail/claude/fcoeoabgfenejglbffodgkkbkcdhcgfn) バージョン 1.0.36 以上（Chrome Web Store で両方のブラウザで利用可能）
 * [Claude Code](/ja/quickstart#step-1-install-claude-code) バージョン 2.0.73 以上
 * 直接 Anthropic プラン（Pro、Max、Team、または Enterprise）
@@ -169,5 +169,5 @@ Claude はインタラクションシーケンスを記録し、GIF ファイル
 ### 拡張機能が検出されない
 
-Claude Code が「Chrome extension not detected」を表示する場合。
```

</details>

<details>
<summary>skills-ja.md</summary>

```diff
diff --git a/docs-ja/pages/skills-ja.md b/docs-ja/pages/skills-ja.md
index 0dd0008..fe9e38a 100644
--- a/docs-ja/pages/skills-ja.md
+++ b/docs-ja/pages/skills-ja.md
@@ -92,5 +92,5 @@ Claude Code には、すべてのセッションで利用可能な一連のバ
 | Plugin     | `<plugin>/skills/<skill-name>/SKILL.md`  | プラグインが有効な場所  |
 
-スキルがレベル全体で同じ名前を共有する場合、優先度の高い場所が優先されます：enterprise > personal > project。プラグインスキルは `plugin-name:skill-name` 名前空間を使用するため、他のレベルと競合することはできません。`.claude/commands/` にファイルがある場合、それらは同じように機能しますが、スキルとコマンドが同じ名前を共有する場合、スキルが優先されます。
+スキルがレベル全体で同じ名前を共有する場合、enterprise は personal をオーバーライドし、personal はプロジェクトをオーバーライドします。プラグインスキルは `plugin-name:skill-name` 名前空間を使用するため、他のレベルと競合することはできません。`.claude/commands/` にファイルがある場合、それらは同じように機能しますが、スキルとコマンドが同じ名前を共有する場合、スキルが優先されます。
 
 #### ライブ変更検出
```

</details>

</details>


<details>
<summary>2026-04-26</summary>

**変更ファイル:**

```
 docs-ja/pages/desktop-scheduled-tasks-en.md | 55 +++++++++---------
 docs-ja/pages/terminal-config-ja.md         | 86 +++++++++++++++++++++++++++++
 2 files changed, 111 insertions(+), 30 deletions(-)
```

<details>
<summary>desktop-scheduled-tasks-en.md</summary>

```diff
diff --git a/docs-ja/pages/desktop-scheduled-tasks-en.md b/docs-ja/pages/desktop-scheduled-tasks-en.md
index 9ebbdde..bb5118f 100644
--- a/docs-ja/pages/desktop-scheduled-tasks-en.md
+++ b/docs-ja/pages/desktop-scheduled-tasks-en.md
@@ -7,5 +7,7 @@
 > Set up scheduled tasks in Claude Code Desktop to run Claude automatically on a recurring basis for daily code reviews, dependency audits, or morning briefings.
 
-By default, scheduled tasks start a new session automatically at a time and frequency you choose. Use them for recurring work like daily code reviews, dependency update checks, or morning briefings that pull from your calendar and inbox.
+Scheduled tasks start a new session automatically at a time and frequency you choose. Use them for recurring work like daily code reviews, dependency update checks, or morning briefings that pull from your calendar and inbox.
+
+The Desktop app's **Routines** page lets you create both local scheduled tasks and remote [routines](/en/routines). A local task runs on your machine with direct access to your files and tools, but only fires while the app is open and your computer is awake. A remote routine runs on Anthropic-managed cloud infrastructure even when your computer is off, and can also fire on API calls or GitHub events. This page covers local scheduled tasks; for remote routines and their trigger options, see [Routines](/en/routines).
 
 ## Compare scheduling options
@@ -29,49 +31,42 @@ Claude Code offers three ways to schedule recurring or one-off work:
 </Tip>
 
-The Schedule page supports two kinds of tasks:
-
-* **Local tasks**: run on your machine. They have direct access to your local files and tools, but the desktop app must be open and your computer awake for them to run.
-* **Remote tasks**: run on Anthropic-managed cloud infrastructure. They keep running even when your computer is off, but work against a fresh clone of your repository rather than your local checkout.
-
-Both kinds appear in the same task grid. Click **New task** to pick which kind to create. The rest of this page covers local tasks; for remote tasks, see [Routines](/en/routines).
-
-See [How scheduled tasks run](#how-scheduled-tasks-run) for details on missed runs and catch-up behavior for local tasks.
-
 <Note>
-  By default, local scheduled tasks run against whatever state your working directory is in, including uncommitted changes. Enable the worktree toggle in the prompt input to give each run its own isolated Git worktree, the same way [parallel sessions](/en/desktop#work-in-parallel-with-sessions) work.
+  By default, scheduled tasks run against whatever state your working directory is in, including uncommitted changes. Enable the worktree toggle when creating the task to give each run its own isolated Git worktree, the same way [parallel sessions](/en/desktop#work-in-parallel-with-sessions) work.
 </Note>
 
```

</details>

<details>
<summary>terminal-config-ja.md</summary>

```diff
diff --git a/docs-ja/pages/terminal-config-ja.md b/docs-ja/pages/terminal-config-ja.md
index 011ed8b..ad95de6 100644
--- a/docs-ja/pages/terminal-config-ja.md
+++ b/docs-ja/pages/terminal-config-ja.md
@@ -146,4 +146,90 @@ set -as terminal-features 'xterm*:extkeys'
 Claude Code は `~/.claude/themes/` を監視し、ファイルが変更されるとリロードするため、エディターで行われた編集は再起動なしで実行中のセッションに適用されます。
 
+以下は、`overrides` で設定できるカスタマイズの完全なリストです。`/theme` の対話的エディターは、ここでカバーされていない少数の内部トークンを含む、ライブプレビュー付きの同じトークンを表示します。
+
+<Accordion title="カラートークンリファレンス">
+  次の例は、複数のグループからのトークンを組み合わせています。ブランドアクセント、プランモードボーダー、diff 背景、および全画面メッセージ背景です。
+
+  ```json ~/.claude/themes/midnight.json theme={null}
+  {
+    "name": "Midnight",
+    "base": "dark",
+    "overrides": {
+      "claude": "#a78bfa",
+      "planMode": "#38bdf8",
+      "diffAdded": "#14532d",
+      "diffRemoved": "#7f1d1d",
+      "userMessageBackground": "#1e1b4b"
+    }
+  }
+  ```
+
+  #### テキストとアクセントカラー
+
+  プライマリブランドアクセントと、インターフェース全体で使用されるフォアグラウンドテキストの色合いを制御します。
+
```

</details>

</details>


<details>
<summary>2026-04-25</summary>

**変更ファイル:**

```
 docs-ja/pages/agent-teams-ja.md         |   2 +-
 docs-ja/pages/amazon-bedrock-ja.md      |   2 +-
 docs-ja/pages/claude-directory-ja.md    |   6 +-
 docs-ja/pages/cli-reference-ja.md       |   2 +-
 docs-ja/pages/env-vars-ja.md            |   1 +
 docs-ja/pages/google-vertex-ai-ja.md    |   4 +-
 docs-ja/pages/hooks-ja.md               |  19 ++--
 docs-ja/pages/mcp-ja.md                 | 149 +++++++++++++++++++++-----------
 docs-ja/pages/microsoft-foundry-ja.md   |   2 +-
 docs-ja/pages/monitoring-usage-ja.md    |   3 +
 docs-ja/pages/permission-modes-ja.md    |   2 +-
 docs-ja/pages/plugin-dependencies-ja.md |   2 +-
 docs-ja/pages/settings-ja.md            |  27 +++---
 docs-ja/pages/statusline-ja.md          |   9 ++
 docs-ja/pages/terminal-config-ja.md     |   4 +-
 docs-ja/pages/tools-reference-ja.md     |  20 ++---
 16 files changed, 164 insertions(+), 90 deletions(-)
```

<details>
<summary>agent-teams-ja.md</summary>

```diff
diff --git a/docs-ja/pages/agent-teams-ja.md b/docs-ja/pages/agent-teams-ja.md
index d679409..f457bb0 100644
--- a/docs-ja/pages/agent-teams-ja.md
+++ b/docs-ja/pages/agent-teams-ja.md
@@ -102,5 +102,5 @@ teammate on UX, one on technical architecture, one playing devil's advocate.
 </Note>
 
-デフォルトは `"auto"` で、既に tmux セッション内で実行している場合は分割ペインを使用し、そうでない場合は in-process を使用します。`"tmux"` 設定は分割ペインモードを有効にし、ターミナルに基づいて tmux または iTerm2 を使用するかどうかを自動検出します。オーバーライドするには、[グローバル設定](/ja/settings#global-config-settings)で `~/.claude.json` の `teammateMode` を設定してください。
+デフォルトは `"auto"` で、既に tmux セッション内で実行している場合は分割ペインを使用し、そうでない場合は in-process を使用します。`"tmux"` 設定は分割ペインモードを有効にし、ターミナルに基づいて tmux または iTerm2 を使用するかどうかを自動検出します。オーバーライドするには、[`teammateMode`](/ja/settings#available-settings) を `~/.claude/settings.json` で設定してください。
 
 ```json theme={null}
```

</details>

<details>
<summary>amazon-bedrock-ja.md</summary>

```diff
diff --git a/docs-ja/pages/amazon-bedrock-ja.md b/docs-ja/pages/amazon-bedrock-ja.md
index c648235..a3e2c8f 100644
--- a/docs-ja/pages/amazon-bedrock-ja.md
+++ b/docs-ja/pages/amazon-bedrock-ja.md
@@ -69,5 +69,5 @@ export const ContactSalesCard = ({surface}) => {
             View plans
           </a>
-          <a href={`https://www.anthropic.com/contact-sales?${utm('contact_sales')}`} className="cc-cs-btn-clay">
+          <a href={`https://claude.com/contact-sales?${utm('contact_sales')}`} className="cc-cs-btn-clay">
             Contact sales {iconArrowRight()}
           </a>
```

</details>

<details>
<summary>claude-directory-ja.md</summary>

```diff
diff --git a/docs-ja/pages/claude-directory-ja.md b/docs-ja/pages/claude-directory-ja.md
index 26af23d..f951427 100644
--- a/docs-ja/pages/claude-directory-ja.md
+++ b/docs-ja/pages/claude-directory-ja.md
@@ -420,8 +420,8 @@ Every finding must include a concrete fix.`
         when: <>Read at session start for your preferences and MCP servers. Claude Code writes back to it when you change settings in <C>/config</C> or approve trust prompts</>,
         description: <>Holds state that does not belong in settings.json: theme, OAuth session, per-project trust decisions, your personal MCP servers, and UI toggles. Mostly managed through <C>/config</C> rather than editing directly.</>,
-        tips: [<>UI toggles like <C>showTurnDuration</C> and <C>terminalProgressBarEnabled</C> live here, not in settings.json</>, <>The <C>projects</C> key tracks per-project state like trust-dialog acceptance and last-session metrics. Permission rules you approve in-session go to <C>.claude/settings.local.json</C> instead</>, <>MCP servers here are yours only: user scope applies across all projects, local scope is per-project but not committed. Team-shared servers go in <C>.mcp.json</C> at the project root instead</>],
+        tips: [<>IDE toggles like <C>autoConnectIde</C> and <C>externalEditorContext</C> live here, not in settings.json</>, <>The <C>projects</C> key tracks per-project state like trust-dialog acceptance and last-session metrics. Permission rules you approve in-session go to <C>.claude/settings.local.json</C> instead</>, <>MCP servers here are yours only: user scope applies across all projects, local scope is per-project but not committed. Team-shared servers go in <C>.mcp.json</C> at the project root instead</>],
         example: `{
-  "editorMode": "vim",
-  "showTurnDuration": false,
+  "autoConnectIde": true,
+  "externalEditorContext": true,
   "mcpServers": {
     "my-tools": {
```

</details>

<details>
<summary>cli-reference-ja.md</summary>

```diff
diff --git a/docs-ja/pages/cli-reference-ja.md b/docs-ja/pages/cli-reference-ja.md
index 0090eac..a3a3bac 100644
--- a/docs-ja/pages/cli-reference-ja.md
+++ b/docs-ja/pages/cli-reference-ja.md
@@ -63,5 +63,5 @@
 | `--fallback-model`                              | デフォルトモデルが過負荷の場合、指定されたモデルへの自動フォールバックを有効にします（プリントモードのみ）                                                                                                                                                                                                         | `claude -p --fallback-model sonnet "query"`                                                        |
 | `--fork-session`                                | 再開時に、元のセッション ID を再利用する代わりに新しいセッション ID を作成します（`--resume` または `--continue` と一緒に使用）                                                                                                                                                                              | `claude --resume abc123 --fork-session`                                                            |
-| `--from-pr`                                     | 特定の GitHub PR にリンクされたセッションを再開します。PR 番号または URL を受け入れます。セッションは `gh pr create` 経由で作成されたときに自動的にリンクされます                                                                                                                                                            | `claude --from-pr 123`                                                                             |
+| `--from-pr`                                     | 特定のプルリクエストにリンクされたセッションを再開します。PR 番号、GitHub または GitHub Enterprise PR URL、GitLab マージリクエスト URL、または Bitbucket プルリクエスト URL を受け入れます。Claude がプルリクエストを作成するときに、セッションは自動的にリンクされます                                                                                        | `claude --from-pr 123`                                                                             |
 | `--ide`                                         | 起動時に、正確に 1 つの有効な IDE が利用可能な場合、自動的に IDE に接続します                                                                                                                                                                                                                 | `claude --ide`                                                                                     |
 | `--init`                                        | 初期化フックを実行してインタラクティブモードを開始                                                                                                                                                                                                                                     | `claude --init`                                                                                    |
```

</details>

<details>
<summary>env-vars-ja.md</summary>

```diff
diff --git a/docs-ja/pages/env-vars-ja.md b/docs-ja/pages/env-vars-ja.md
index 958b620..edc0135 100644
--- a/docs-ja/pages/env-vars-ja.md
+++ b/docs-ja/pages/env-vars-ja.md
@@ -100,4 +100,5 @@ Claude Code は、その動作を制御するために以下の環境変数を
 | `CLAUDE_CODE_GLOB_NO_IGNORE`                            | [Glob ツール](/ja/tools-reference) が `.gitignore` パターンを尊重するようにするには `false` に設定します。デフォルトでは、Glob は gitignored されたものを含むすべての一致するファイルを返します。`@` ファイルオートコンプリートには影響しません。これは独自の [`respectGitignore` 設定](/ja/settings#available-settings) を持っています                                                                                                                                                                                  |
 | `CLAUDE_CODE_GLOB_TIMEOUT_SECONDS`                      | Glob ツールファイル検出のタイムアウト（秒）。ほとんどのプラットフォームではデフォルト 20 秒、WSL では 60 秒                                                                                                                                                                                                                                                                                                                                                        |
+| `CLAUDE_CODE_HIDE_CWD`                                  | スタートアップロゴで作業ディレクトリを非表示にするには `1` に設定します。スクリーンシェアまたは記録でパスが OS ユーザー名を公開する場合に役立ちます                                                                                                                                                                                                                                                                                                                                        |
 | `CLAUDE_CODE_IDE_HOST_OVERRIDE`                         | IDE 拡張機能への接続に使用されるホストアドレスをオーバーライドします。デフォルトでは Claude Code は WSL-to-Windows ルーティングを含む正しいアドレスを自動検出します                                                                                                                                                                                                                                                                                                                    |
 | `CLAUDE_CODE_IDE_SKIP_AUTO_INSTALL`                     | IDE 拡張機能の自動インストールをスキップします。[`autoInstallIdeExtension`](/ja/settings#global-config-settings) を `false` に設定するのと同等です                                                                                                                                                                                                                                                                                                      |
```

</details>

<details>
<summary>google-vertex-ai-ja.md</summary>

```diff
diff --git a/docs-ja/pages/google-vertex-ai-ja.md b/docs-ja/pages/google-vertex-ai-ja.md
index db49afd..c568906 100644
--- a/docs-ja/pages/google-vertex-ai-ja.md
+++ b/docs-ja/pages/google-vertex-ai-ja.md
@@ -69,5 +69,5 @@ export const ContactSalesCard = ({surface}) => {
             View plans
           </a>
-          <a href={`https://www.anthropic.com/contact-sales?${utm('contact_sales')}`} className="cc-cs-btn-clay">
+          <a href={`https://claude.com/contact-sales?${utm('contact_sales')}`} className="cc-cs-btn-clay">
             Contact sales {iconArrowRight()}
           </a>
@@ -296,4 +296,6 @@ export VERTEX_REGION_CLAUDE_4_6_SONNET=europe-west1
 [プロンプトキャッシング](https://platform.claude.com/docs/en/build-with-claude/prompt-caching)は自動的に有効になります。これを無効にするには、`DISABLE_PROMPT_CACHING=1` を設定します。デフォルトの 5 分ではなく 1 時間のキャッシュ TTL をリクエストするには、`ENABLE_PROMPT_CACHING_1H=1` を設定します。1 時間の TTL でのキャッシュ書き込みはより高いレートで課金されます。レート制限を高くするには、Google Cloud サポートに連絡してください。Vertex AI を使用する場合、Google Cloud 認証情報を通じて認証が処理されるため、`/login` および `/logout` コマンドは無効になります。
 
+[MCP ツール検索](/ja/mcp#scale-with-mcp-tool-search)は、エンドポイントが必要なベータヘッダーを受け入れないため、Vertex AI ではデフォルトで無効になっています。すべての MCP ツール定義は代わりに事前にロードされます。オプトインするには、`ENABLE_TOOL_SEARCH=true` を設定します。
+
 ### 5. モデルバージョンをピン留めする
 
```

</details>

<details>
<summary>hooks-ja.md</summary>

```diff
diff --git a/docs-ja/pages/hooks-ja.md b/docs-ja/pages/hooks-ja.md
index f8da3f0..6793122 100644
--- a/docs-ja/pages/hooks-ja.md
+++ b/docs-ja/pages/hooks-ja.md
@@ -1256,8 +1256,13 @@ PermissionRequest フックは PreToolUse フックのような `tool_name` と
     "success": true
   },
-  "tool_use_id": "toolu_01ABC123..."
+  "tool_use_id": "toolu_01ABC123...",
+  "duration_ms": 12
 }
 ```
 
+| フィールド         | 説明                                                    |
+| :------------ | :---------------------------------------------------- |
+| `duration_ms` | オプション。ツール実行時間（ミリ秒）。権限プロンプトと PreToolUse フックに費やされた時間は除外 |
+
 #### PostToolUse 決定制御
 
@@ -1306,12 +1311,14 @@ PostToolUseFailure フックは PostToolUse と同じ `tool_name` と `tool_inpu
   "tool_use_id": "toolu_01ABC123...",
   "error": "Command exited with non-zero status code 1",
-  "is_interrupt": false
+  "is_interrupt": false,
+  "duration_ms": 4187
 }
 ```
 
-| フィールド          | 説明                                      |
-| :------------- | :-------------------------------------- |
```

</details>

<details>
<summary>mcp-ja.md</summary>

```diff
diff --git a/docs-ja/pages/mcp-ja.md b/docs-ja/pages/mcp-ja.md
index f04d21f..e54cc9a 100644
--- a/docs-ja/pages/mcp-ja.md
+++ b/docs-ja/pages/mcp-ja.md
@@ -215,4 +215,6 @@ export const MCPServersTable = ({platform = "all"}) => {
 Claude Code は、AI ツール統合のためのオープンソース標準である [Model Context Protocol (MCP)](https://modelcontextprotocol.io/introduction) を通じて、数百の外部ツールとデータソースに接続できます。MCP サーバーは Claude Code にツール、データベース、API へのアクセスを提供します。
 
+別のツール（課題追跡ツールや監視ダッシュボードなど）からチャットにデータをコピーしている場合は、サーバーを接続してください。接続すると、Claude は貼り付けたものから作業する代わりに、そのシステムを直接読み取り、操作できます。
+
 ## MCP でできること
 
@@ -328,4 +330,8 @@ claude mcp remove github
 Claude Code は MCP `list_changed` 通知をサポートしており、MCP サーバーが切断して再接続することなく、利用可能なツール、プロンプト、リソースを動的に更新できます。MCP サーバーが `list_changed` 通知を送信すると、Claude Code はそのサーバーから利用可能な機能を自動的に更新します。
 
+### 自動再接続
+
+HTTP または SSE サーバーがセッション中に切断された場合、Claude Code は指数バックオフで自動的に再接続します：最大 5 回の試行、1 秒の遅延から始まり、毎回 2 倍になります。サーバーは再接続が進行中の間、`/mcp` では保留中として表示されます。5 回の失敗した試行の後、サーバーは失敗としてマークされ、`/mcp` から手動で再試行できます。Stdio サーバーはローカルプロセスであり、自動的には再接続されません。
+
 ### チャネルでメッセージをプッシュする
 
@@ -345,15 +351,4 @@ MCP サーバーはセッションに直接メッセージをプッシュする
 </Tip>
 
-<Warning>
-  **Windows ユーザー向け**：ネイティブ Windows（WSL ではない）では、`npx` を使用するローカル MCP サーバーは適切な実行を確保するために `cmd /c` ラッパーが必要です。
-
-  ```bash theme={null}
-  # これにより、Windows が実行できる command="cmd" が作成されます
-  claude mcp add --transport stdio my-server -- cmd /c npx -y @some/package
-  ```
```

</details>

<details>
<summary>microsoft-foundry-ja.md</summary>

```diff
diff --git a/docs-ja/pages/microsoft-foundry-ja.md b/docs-ja/pages/microsoft-foundry-ja.md
index 3de8faf..54d6f7f 100644
--- a/docs-ja/pages/microsoft-foundry-ja.md
+++ b/docs-ja/pages/microsoft-foundry-ja.md
@@ -69,5 +69,5 @@ export const ContactSalesCard = ({surface}) => {
             View plans
           </a>
-          <a href={`https://www.anthropic.com/contact-sales?${utm('contact_sales')}`} className="cc-cs-btn-clay">
+          <a href={`https://claude.com/contact-sales?${utm('contact_sales')}`} className="cc-cs-btn-clay">
             Contact sales {iconArrowRight()}
           </a>
```

</details>

<details>
<summary>monitoring-usage-ja.md</summary>

```diff
diff --git a/docs-ja/pages/monitoring-usage-ja.md b/docs-ja/pages/monitoring-usage-ja.md
index cea3f49..a235173 100644
--- a/docs-ja/pages/monitoring-usage-ja.md
+++ b/docs-ja/pages/monitoring-usage-ja.md
@@ -517,4 +517,5 @@ Claude Code は、OpenTelemetry ログ/イベント経由で以下のイベン
 * `event.sequence`: セッション内のイベントを順序付けするための単調増加カウンター
 * `tool_name`: ツールの名前
+* `tool_use_id`: このツール呼び出しの一意の識別子。フックに渡される `tool_use_id` と一致し、OTel イベントとフック取得データ間の相関を可能にします。
 * `success`: `"true"` または `"false"`
 * `duration_ms`: 実行時間 (ミリ秒単位)
@@ -523,4 +524,5 @@ Claude Code は、OpenTelemetry ログ/イベント経由で以下のイベン
 * `decision_type`: `"accept"` または `"reject"`
 * `decision_source`: 決定ソース - `"config"`、`"hook"`、`"user_permanent"`、`"user_temporary"`、`"user_abort"`、または `"user_reject"`
+* `tool_input_size_bytes`: JSON シリアル化されたツール入力のサイズ (バイト単位)
 * `tool_result_size_bytes`: ツール結果のサイズ (バイト単位)
 * `mcp_server_scope`: MCP サーバースコープ識別子 (MCP ツール用)
@@ -630,4 +632,5 @@ Claude への API リクエストが失敗するときにログされます。
 * `event.sequence`: セッション内のイベントを順序付けするための単調増加カウンター
 * `tool_name`: ツールの名前 (例: "Read"、"Edit"、"Write"、"NotebookEdit")
+* `tool_use_id`: このツール呼び出しの一意の識別子。フックに渡される `tool_use_id` と一致し、OTel イベントとフック取得データ間の相関を可能にします。
 * `decision`: `"accept"` または `"reject"`
 * `source`: 決定ソース - `"config"`、`"hook"`、`"user_permanent"`、`"user_temporary"`、`"user_abort"`、または `"user_reject"`
```

</details>

*...以降省略*

</details>


<details>
<summary>2026-04-24</summary>

**変更ファイル:**

```
 docs-ja/pages/agent-teams-ja.md             |  14 +-
 docs-ja/pages/amazon-bedrock-ja.md          | 329 ++++++++++++++++++++++++++--
 docs-ja/pages/auto-mode-config-ja.md        |  26 ++-
 docs-ja/pages/changelog.md                  |  91 ++++++++
 docs-ja/pages/claude-directory-ja.md        |  25 ++-
 docs-ja/pages/cli-reference-ja.md           | 132 +++++------
 docs-ja/pages/commands-ja.md                |  18 +-
 docs-ja/pages/costs-ja.md                   |  27 +--
 docs-ja/pages/data-usage-ja.md              |  17 +-
 docs-ja/pages/desktop-scheduled-tasks-en.md |   2 +-
 docs-ja/pages/env-vars-ja.md                |   9 +-
 docs-ja/pages/google-vertex-ai-ja.md        |   5 +-
 docs-ja/pages/hooks-guide-ja.md             |  39 ++--
 docs-ja/pages/hooks-ja.md                   | 209 +++++++++++++-----
 docs-ja/pages/interactive-mode-ja.md        |  50 +++--
 docs-ja/pages/microsoft-foundry-ja.md       | 273 ++++++++++++++++++++---
 docs-ja/pages/model-config-ja.md            |   4 +-
 docs-ja/pages/overview-ja.md                |   2 +
 docs-ja/pages/permission-modes-ja.md        |   2 +-
 docs-ja/pages/permissions-ja.md             |  27 +--
 docs-ja/pages/plugin-dependencies-ja.md     |  15 +-
 docs-ja/pages/plugin-marketplaces-ja.md     |  48 ++--
 docs-ja/pages/plugins-ja.md                 |  14 +-
 docs-ja/pages/plugins-reference-ja.md       | 100 ++++++---
 docs-ja/pages/quickstart-ja.md              |   2 +
 docs-ja/pages/remote-control-ja.md          |   6 +-
 docs-ja/pages/scheduled-tasks-ja.md         |   2 +-
 docs-ja/pages/settings-ja.md                |  12 +-
 docs-ja/pages/setup-ja.md                   | 115 +++++++++-
 docs-ja/pages/statusline-ja.md              |   2 +-
 docs-ja/pages/sub-agents-ja.md              |  64 +++++-
 docs-ja/pages/terminal-config-ja.md         |  40 +++-
 32 files changed, 1375 insertions(+), 346 deletions(-)
```

**新規追加:**


<details>
<summary>agent-teams-ja.md</summary>

```diff
diff --git a/docs-ja/pages/agent-teams-ja.md b/docs-ja/pages/agent-teams-ja.md
index 78d2863..d679409 100644
--- a/docs-ja/pages/agent-teams-ja.md
+++ b/docs-ja/pages/agent-teams-ja.md
@@ -236,5 +236,5 @@ Claude Code はチームを作成するときにこれらの両方を自動的
 ### チームメンバーに subagent 定義を使用する
 
-チームメンバーを生成するときに、任意の [subagent スコープ](/ja/sub-agents#choose-the-subagent-scope)（プロジェクト、ユーザー、プラグイン、または CLI 定義）から [subagent](/ja/sub-agents) タイプを参照できます。チームメンバーはその subagent のシステムプロンプト、ツール、およびモデルを継承します。これにより、セキュリティレビュアーやテストランナーなどのロールを 1 回定義し、委任された subagent とエージェントチームチームメンバーの両方として再利用できます。
+チームメンバーを生成するときに、任意の [subagent スコープ](/ja/sub-agents#choose-the-subagent-scope)（プロジェクト、ユーザー、プラグイン、または CLI 定義）から [subagent](/ja/sub-agents) タイプを参照できます。これにより、セキュリティレビュアーやテストランナーなどのロールを 1 回定義し、委任された subagent とエージェントチームチームメンバーの両方として再利用できます。
 
 subagent 定義を使用するには、Claude にチームメンバーを生成するよう指示するときに名前で言及してください。
@@ -244,4 +244,10 @@ Spawn a teammate using the security-reviewer agent type to audit the auth module
 ```
 
+チームメンバーはその定義の `tools` 許可リストと `model` を尊重し、定義の本体はチームメンバーのシステムプロンプトに追加の指示として追加されます。チーム調整ツール（`SendMessage` やタスク管理ツール）は、`tools` が他のツールを制限している場合でも、チームメンバーが常に利用できます。
+
+<Note>
+  subagent 定義の `skills` と `mcpServers` frontmatter フィールドは、その定義がチームメンバーとして実行される場合は適用されません。チームメンバーは、通常のセッションと同じように、プロジェクトおよびユーザー設定から skills と MCP servers をロードします。
+</Note>
+
 ### 権限
 
@@ -257,9 +263,7 @@ Spawn a teammate using the security-reviewer agent type to audit the auth module
 * **アイドル通知**：チームメンバーが完了して停止すると、リーダーに自動的に通知します。
 * **共有タスクリスト**：すべてのエージェントはタスクステータスを表示でき、利用可能な作業を要求できます。
+* **チームメンバーメッセージング**：その名前で特定のチームメンバーにメッセージを送信します。全員に到達するには、受信者ごとに 1 つのメッセージを送信してください。
 
-**チームメンバーメッセージング：**
-
-* **message**：特定のチームメンバーに 1 つのメッセージを送信します
```

</details>

<details>
<summary>amazon-bedrock-ja.md</summary>

```diff
diff --git a/docs-ja/pages/amazon-bedrock-ja.md b/docs-ja/pages/amazon-bedrock-ja.md
index 8bcc35b..c648235 100644
--- a/docs-ja/pages/amazon-bedrock-ja.md
+++ b/docs-ja/pages/amazon-bedrock-ja.md
@@ -7,4 +7,186 @@
 > Amazon Bedrock を通じた Claude Code の設定方法（セットアップ、IAM 設定、トラブルシューティングを含む）について学習します。
 
+export const ContactSalesCard = ({surface}) => {
+  const utm = content => `utm_source=claude_code&utm_medium=docs&utm_content=${surface}_${content}`;
+  const iconArrowRight = (size = 13) => <svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">
+      <line x1="5" y1="12" x2="19" y2="12" />
+      <polyline points="12 5 19 12 12 19" />
+    </svg>;
+  const STYLES = `
+.cc-cs {
+  --cs-slate: #141413;
+  --cs-clay: #d97757;
+  --cs-clay-deep: #c6613f;
+  --cs-gray-000: #ffffff;
+  --cs-gray-700: #3d3d3a;
+  --cs-border-default: rgba(31, 30, 29, 0.15);
+  font-family: inherit;
+}
+.dark .cc-cs {
+  --cs-slate: #f0eee6;
+  --cs-gray-000: #262624;
+  --cs-gray-700: #bfbdb4;
+  --cs-border-default: rgba(240, 238, 230, 0.14);
+}
+.cc-cs-card {
```

</details>

<details>
<summary>auto-mode-config-ja.md</summary>

```diff
diff --git a/docs-ja/pages/auto-mode-config-ja.md b/docs-ja/pages/auto-mode-config-ja.md
index 44cf16e..7cb4b3c 100644
--- a/docs-ja/pages/auto-mode-config-ja.md
+++ b/docs-ja/pages/auto-mode-config-ja.md
@@ -46,5 +46,5 @@
 ほとんどの組織では、`autoMode.environment` が設定する必要がある唯一のフィールドです。これは、分類器に、どのリポジトリ、バケット、ドメインが信頼できるかを指定します。分類器はこれを使用して「外部」が何を意味するかを決定するため、リストに記載されていない宛先は潜在的な流出ターゲットです。
 
-`environment` を設定すると、デフォルトの環境リストが置き換わります。デフォルトには、作業リポジトリとそのリモートを信頼するエントリが含まれます。`claude auto-mode defaults` を実行してデフォルトを出力し、リストを狭めるのではなく拡張するように、独自のエントリと一緒に含めます。
+デフォルトの環境リストは、作業リポジトリとその設定されたリモートを信頼します。そのデフォルトと一緒に独自のエントリを追加するには、配列にリテラル文字列 `"$defaults"` を含めます。デフォルトエントリはその位置に挿入されるため、カスタムエントリはそれらの前後に配置できます。
 
 ```json theme={null}
@@ -52,4 +52,5 @@
   "autoMode": {
     "environment": [
+      "$defaults",
       "Source control: github.example.com/acme-corp and all repos under it",
       "Trusted cloud buckets: s3://acme-build-artifacts, gs://acme-ml-datasets",
@@ -76,4 +77,5 @@
   "autoMode": {
     "environment": [
+      "$defaults",
       "Organization: {COMPANY_NAME}. Primary use: {PRIMARY_USE_CASE, e.g. software development, infrastructure automation}",
       "Source control: {SOURCE_CONTROL, e.g. GitHub org github.example.com/acme-corp}",
@@ -104,9 +106,5 @@
 一般的なリクエストは明示的な意図としてカウントされません。Claude に「リポジトリをクリーンアップする」ように依頼することは force push を認可しませんが、「このブランチを force push する」ように依頼することは認可します。
 
-<Danger>
-  `environment`、`allow`、`soft_deny` のいずれかを設定すると、そのセクション全体のデフォルトリストが置き換わります。単一のエントリで `soft_deny` を設定すると、すべての組み込みブロックルール（force push、データ流出、`curl | bash`、本番環境へのデプロイ、その他すべてのデフォルトブロックルール）が破棄されて許可されます。安全にカスタマイズするには、`claude auto-mode defaults` を実行して組み込みルールを出力し、それらを設定ファイルにコピーしてから、各ルールを独自のパイプラインとリスク許容度に対して確認します。インフラストラクチャが既に軽減しているリスクのルールのみを削除します。
-</Danger>
-
```

</details>

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index 6e3b347..bd99d3b 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,95 @@
 # Changelog
 
+## 2.1.119
+
+- `/config` settings (theme, editor mode, verbose, etc.) now persist to `~/.claude/settings.json` and participate in project/local/policy override precedence
+- Added `prUrlTemplate` setting to point the footer PR badge at a custom code-review URL instead of github.com
+- Added `CLAUDE_CODE_HIDE_CWD` environment variable to hide the working directory in the startup logo
+- `--from-pr` now accepts GitLab merge-request, Bitbucket pull-request, and GitHub Enterprise PR URLs
+- `--print` mode now honors the agent's `tools:` and `disallowedTools:` frontmatter, matching interactive-mode behavior
+- `--agent <name>` now honors the agent definition's `permissionMode` for built-in agents
+- PowerShell tool commands can now be auto-approved in permission mode, matching Bash behavior
+- Hooks: `PostToolUse` and `PostToolUseFailure` hook inputs now include `duration_ms` (tool execution time, excluding permission prompts and PreToolUse hooks)
+- Subagent and SDK MCP server reconfiguration now connects servers in parallel instead of serially
+- Plugins pinned by another plugin's version constraint now auto-update to the highest satisfying git tag
+- Vim mode: Esc in INSERT no longer pulls a queued message back into the input; press Esc again to interrupt
+- Slash command suggestions now highlight the characters that matched your query
+- Slash command picker now wraps long descriptions onto a second line instead of truncating
+- `owner/repo#N` shorthand links in output now use your git remote's host instead of always pointing at github.com
+- Security: `blockedMarketplaces` now correctly enforces `hostPattern` and `pathPattern` entries
+- OpenTelemetry: `tool_result` and `tool_decision` events now include `tool_use_id`; `tool_result` also includes `tool_input_size_bytes`
+- Status line: stdin JSON now includes `effort.level` and `thinking.enabled`
+- Fixed pasting CRLF content (Windows clipboards, Xcode console) inserting an extra blank line between every line
+- Fixed multi-line paste losing newlines in terminals using kitty keyboard protocol sequences inside bracketed paste
+- Fixed Glob and Grep tools disappearing on native macOS/Linux builds when the Bash tool is denied via permissions
+- Fixed scrolling up in fullscreen mode snapping back to the bottom every time a tool finishes
```

</details>

<details>
<summary>claude-directory-ja.md</summary>

```diff
diff --git a/docs-ja/pages/claude-directory-ja.md b/docs-ja/pages/claude-directory-ja.md
index f263cac..26af23d 100644
--- a/docs-ja/pages/claude-directory-ja.md
+++ b/docs-ja/pages/claude-directory-ja.md
@@ -502,4 +502,24 @@ Every finding must include a concrete fix.`
 }`,
           docsLink: '/en/keybindings'
+        }, {
+          id: 'themes',
+          label: 'themes/',
+          type: 'folder',
+          icon: 'folder',
+          color: '#5AA7A7',
+          oneLiner: 'Custom color themes',
+          when: <>Read at session start and hot-reloaded when files change. Listed in <C>/theme</C></>,
+          description: <>Each <C>.json</C> file defines a custom color theme: a built-in <C>base</C> preset plus an <C>overrides</C> map of color tokens. Create one interactively with <C>/theme</C> or write the JSON by hand. Selecting a custom theme stores <C>custom:&lt;slug&gt;</C> as your theme preference.</>,
+          example: `{
+  "name": "Dracula",
+  "base": "dark",
+  "overrides": {
+    "claude": "#bd93f9",
+    "error": "#ff5555",
+    "success": "#50fa7b"
+  }
+}`,
+          docsLink: '/en/terminal-config#create-a-custom-theme',
+          children: []
         }, {
           id: 'global-projects',
@@ -1461,4 +1481,5 @@ Windows では、`~/.claude` は `%USERPROFILE%\.claude` に解決されます
```

</details>

<details>
<summary>cli-reference-ja.md</summary>

```diff
diff --git a/docs-ja/pages/cli-reference-ja.md b/docs-ja/pages/cli-reference-ja.md
index eb5ba05..0090eac 100644
--- a/docs-ja/pages/cli-reference-ja.md
+++ b/docs-ja/pages/cli-reference-ja.md
@@ -21,4 +21,5 @@
 | `claude -r "<session>" "query"` | セッション ID または名前でセッションを再開                                                                                                                                                                                    | `claude -r "auth-refactor" "Finish this PR"`                |
 | `claude update`                 | 最新バージョンに更新                                                                                                                                                                                                 | `claude update`                                             |
+| `claude install [version]`      | ネイティブバイナリをインストールまたは再インストールします。`2.1.118` のようなバージョン、または `stable` または `latest` を受け入れます。[特定のバージョンをインストール](/ja/setup#install-a-specific-version) を参照してください                                                      | `claude install stable`                                     |
 | `claude auth login`             | Anthropic アカウントにサインインします。`--email` を使用してメールアドレスを事前入力し、`--sso` を使用して SSO 認証を強制し、`--console` を使用して Claude サブスクリプションの代わりに Anthropic Console で API 使用料金をサインインできます                                              | `claude auth login --console`                               |
 | `claude auth logout`            | Anthropic アカウントからログアウト                                                                                                                                                                                     | `claude auth logout`                                        |
@@ -29,4 +30,7 @@
 | `claude plugin`                 | Claude Code [plugins](/ja/plugins) を管理します。エイリアス：`claude plugins`。サブコマンドについては [plugin reference](/ja/plugins-reference#cli-commands-reference) を参照してください                                                    | `claude plugin install code-review@claude-plugins-official` |
 | `claude remote-control`         | [Remote Control](/ja/remote-control) サーバーを開始して、Claude.ai または Claude アプリから Claude Code を制御します。サーバーモード（ローカルインタラクティブセッションなし）で実行されます。[サーバーモードフラグ](/ja/remote-control#start-a-remote-control-session) を参照してください | `claude remote-control --name "My Project"`                 |
+| `claude setup-token`            | CI とスクリプト用の長期間有効な OAuth トークンを生成します。ターミナルにトークンを出力し、保存しません。Claude サブスクリプションが必要です。[長期間有効なトークンを生成](/ja/authentication#generate-a-long-lived-token) を参照してください                                                   | `claude setup-token`                                        |
+
+サブコマンドを誤入力した場合、Claude Code は最も近い一致を提案して、セッションを開始せずに終了します。たとえば、`claude udpate` は `Did you mean claude update?` と出力します。
 
 ## CLI フラグ
@@ -34,66 +38,68 @@
 これらのコマンドラインフラグを使用して Claude Code の動作をカスタマイズします。`claude --help` はすべてのフラグをリストしていないため、`--help` にフラグが表示されていないことは、そのフラグが利用できないことを意味しません。
 
-| フラグ                                       | 説明                                                                                                                                                                                                                                               | 例                                                                                                  |
-| :---------------------------------------- | :----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :------------------------------------------------------------------------------------------------- |
-| `--add-dir`                               | Claude がファイルを読み取り、編集するための追加の作業ディレクトリを追加します。ファイルアクセスを許可します。ほとんどの `.claude/` 設定は [これらのディレクトリから検出されません](/ja/permissions#additional-directories-grant-file-access-not-configuration)。各パスがディレクトリとして存在することを検証します                                       | `claude --add-dir ../apps ../lib`                                                                  |
-| `--agent`                                 | 現在のセッションのエージェントを指定します（`agent` 設定をオーバーライドします）                                                                                                                                                                                                     | `claude --agent my-custom-agent`                                                                   |
-| `--agents`                                | JSON 経由でカスタム subagents を動的に定義します。subagent [frontmatter](/ja/sub-agents#supported-frontmatter-fields) と同じフィールド名を使用し、さらにエージェントの指示用の `prompt` フィールドを追加します                                                                                           | `claude --agents '{"reviewer":{"description":"Reviews code","prompt":"You are a code reviewer"}}'` |
-| `--allow-dangerously-skip-permissions`    | `Shift+Tab` モードサイクルに `bypassPermissions` を追加します。これを開始時に有効にしません。`plan` のような別のモードで開始し、後で `bypassPermissions` に切り替えることができます。[権限モード](/ja/permission-modes#skip-all-checks-with-bypasspermissions-mode) を参照してください                                     | `claude --permission-mode plan --allow-dangerously-skip-permissions`                               |
-| `--allowedTools`                          | 権限を求めずに実行するツール。パターンマッチングについては [権限ルール構文](/ja/settings#permission-rule-syntax) を参照してください。利用可能なツールを制限するには、代わりに `--tools` を使用してください                                                                                                                  | `"Bash(git log *)" "Bash(git diff *)" "Read"`                                                      |
-| `--append-system-prompt`                  | デフォルトシステムプロンプトの末尾にカスタムテキストを追加                                                                                                                                                                                                                    | `claude --append-system-prompt "Always use TypeScript"`                                            |
-| `--append-system-prompt-file`             | ファイルから追加のシステムプロンプトテキストを読み込み、デフォルトプロンプトに追加                                                                                                                                                                                                        | `claude --append-system-prompt-file ./extra-rules.txt`                                             |
```

</details>

*...以降省略*

</details>


<details>
<summary>2026-04-23</summary>

**変更ファイル:**

```
 docs-ja/pages/changelog.md                  |   1 +
 docs-ja/pages/claude-directory-ja.md        |  62 ++--
 docs-ja/pages/commands-ja.md                |   2 +-
 docs-ja/pages/common-workflows-ja.md        |   8 +-
 docs-ja/pages/desktop-ja.md                 |   2 +-
 docs-ja/pages/errors-en.md                  | 535 ----------------------------
 docs-ja/pages/google-vertex-ai-ja.md        | 250 ++++++++++++-
 docs-ja/pages/hooks-ja.md                   | 187 ++++++----
 docs-ja/pages/memory-ja.md                  |  56 ++-
 docs-ja/pages/model-config-ja.md            |   8 +-
 docs-ja/pages/monitoring-usage-ja.md        | 411 +++++++++++++++++++--
 docs-ja/pages/network-config-ja.md          |  26 +-
 docs-ja/pages/permission-modes-ja.md        | 298 ++++++++--------
 docs-ja/pages/permissions-ja.md             | 116 +-----
 docs-ja/pages/plugin-dependencies-ja.md     |  13 +-
 docs-ja/pages/plugin-marketplaces-ja.md     |   4 +-
 docs-ja/pages/server-managed-settings-ja.md |  38 +-
 docs-ja/pages/settings-ja.md                |  13 +-
 docs-ja/pages/skills-ja.md                  |   1 +
 docs-ja/pages/sub-agents-ja.md              |  11 +-
 docs-ja/pages/voice-dictation-en.md         |  63 +++-
 21 files changed, 1085 insertions(+), 1020 deletions(-)
```

**新規追加:**


**削除:**


<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index 65e9f4b..6e3b347 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -46,4 +46,5 @@
 - Slash command menu now shows "No commands match" when your filter has zero results, instead of disappearing
 - Security: sandbox auto-allow no longer bypasses the dangerous-path safety check for `rm`/`rmdir` targeting `/`, `$HOME`, or other critical system directories
+- Claude Code and installer now use `https://downloads.claude.ai/claude-code-releases` instead of `https://storage.googleapis.com/claude-code-dist-86c565f3-f756-42ad-8dfa-d59b1c096819/claude-code-releases`
 - Fixed Devanagari and other Indic scripts rendering with broken column alignment in the terminal UI
 - Fixed Ctrl+- not triggering undo in terminals using the Kitty keyboard protocol (iTerm2, Ghostty, kitty, WezTerm, Windows Terminal)
```

</details>

<details>
<summary>claude-directory-ja.md</summary>

```diff
diff --git a/docs-ja/pages/claude-directory-ja.md b/docs-ja/pages/claude-directory-ja.md
index f22b0bc..f263cac 100644
--- a/docs-ja/pages/claude-directory-ja.md
+++ b/docs-ja/pages/claude-directory-ja.md
@@ -1395,5 +1395,7 @@ Windows では、`~/.claude` は `%USERPROFILE%\.claude` に解決されます
 ほとんどのユーザーは `CLAUDE.md` と `settings.json` のみを編集します。ディレクトリの残りはオプションです。必要に応じて skills、rules、または subagents を追加してください。
 
-このページはインタラクティブなエクスプローラーです。ツリー内のファイルをクリックして、各ファイルの機能、読み込みタイミング、および例を確認できます。クイックリファレンスについては、以下の[ファイルリファレンステーブル](#file-reference)を参照してください。
+## ディレクトリを探索する
+
+ツリー内のファイルをクリックして、各ファイルの機能、読み込みタイミング、および例を確認してください。
 
 <ClaudeExplorer />
@@ -1411,4 +1413,20 @@ Windows では、`~/.claude` は `%USERPROFILE%\.claude` に解決されます
 `~/.claude` は、作業中に Claude Code が書き込むデータも保持します。トランスクリプト、プロンプト履歴、ファイルスナップショット、キャッシュ、ログです。以下の[アプリケーションデータ](#application-data)を参照してください。
 
+## 適切なファイルを選択する
+
+異なる種類のカスタマイズは異なるファイルに存在します。このテーブルを使用して、変更がどこに属するかを見つけてください。
+
+| 実行したいこと                       | 編集                                        | スコープ           | リファレンス                                        |
+| :---------------------------- | :---------------------------------------- | :------------- | :-------------------------------------------- |
+| Claude にプロジェクトコンテキストと規約を提供する  | `CLAUDE.md`                               | プロジェクトまたはグローバル | [メモリ](/ja/memory)                             |
+| 特定のツール呼び出しを許可またはブロックする        | `settings.json` `permissions` または `hooks` | プロジェクトまたはグローバル | [パーミッション](/ja/permissions)、[Hooks](/ja/hooks) |
+| ツール呼び出しの前後にスクリプトを実行する         | `settings.json` `hooks`                   | プロジェクトまたはグローバル | [Hooks](/ja/hooks)                            |
+| セッションの環境変数を設定する               | `settings.json` `env`                     | プロジェクトまたはグローバル | [設定](/ja/settings#available-settings)         |
+| 個人的なオーバーライドを git から除外する       | `settings.local.json`                     | プロジェクトのみ       | [設定スコープ](/ja/settings#settings-files)         |
+| `/name` で呼び出すプロンプトまたは機能を追加する  | `skills/<name>/SKILL.md`                  | プロジェクトまたはグローバル | [Skills](/ja/skills)                          |
+| 独自のツールを持つ特化した subagent を定義する  | `agents/*.md`                             | プロジェクトまたはグローバル | [Subagents](/ja/sub-agents)                   |
+| MCP 経由で外部ツールを接続する             | `.mcp.json`                               | プロジェクトのみ       | [MCP](/ja/mcp)                                |
```

</details>

<details>
<summary>commands-ja.md</summary>

```diff
diff --git a/docs-ja/pages/commands-ja.md b/docs-ja/pages/commands-ja.md
index 30d6e9b..a242d56 100644
--- a/docs-ja/pages/commands-ja.md
+++ b/docs-ja/pages/commands-ja.md
@@ -63,5 +63,5 @@
 | `/model [model]`             | AI モデルを選択または変更。サポートしているモデルの場合、左右矢印を使用して[努力レベルを調整](/ja/model-config#adjust-effort-level)します。引数なしで、会話に前の出力がある場合に確認を求めるピッカーを開きます。次の応答はキャッシュされたコンテキストなしで完全な履歴を再読み込みするためです。確認されると、現在の応答の完了を待たずに変更が適用されます                                                                                                                                                                                                                                                        |
 | `/passes`                    | Claude Code の無料 1 週間を友人と共有。アカウントが対象の場合のみ表示                                                                                                                                                                                                                                                                                                                                                                                                                 |
-| `/permissions`               | ツール権限のアクセス許可、確認、および拒否ルールを管理。スコープ別にルールを表示し、ルールを追加または削除し、作業ディレクトリを管理し、[最近の自動モード拒否](/ja/permissions#review-auto-mode-denials)を確認できるインタラクティブダイアログを開きます。エイリアス: `/allowed-tools`                                                                                                                                                                                                                                                                                 |
+| `/permissions`               | ツール権限のアクセス許可、確認、および拒否ルールを管理。スコープ別にルールを表示し、ルールを追加または削除し、作業ディレクトリを管理し、[最近の自動モード拒否](/ja/auto-mode-config#review-denials)を確認できるインタラクティブダイアログを開きます。エイリアス: `/allowed-tools`                                                                                                                                                                                                                                                                                      |
 | `/plan [description]`        | プロンプトから直接 Plan Mode に入ります。オプションの説明を渡して Plan Mode に入り、すぐにそのタスクで開始します。例えば `/plan fix the auth bug`                                                                                                                                                                                                                                                                                                                                                           |
 | `/plugin`                    | Claude Code [プラグイン](/ja/plugins)を管理                                                                                                                                                                                                                                                                                                                                                                                                                        |
```

</details>

<details>
<summary>common-workflows-ja.md</summary>

```diff
diff --git a/docs-ja/pages/common-workflows-ja.md b/docs-ja/pages/common-workflows-ja.md
index b3a6387..fdafe64 100644
--- a/docs-ja/pages/common-workflows-ja.md
+++ b/docs-ja/pages/common-workflows-ja.md
@@ -515,5 +515,7 @@ Claude Code はどのディレクトリでも機能します。ノートボル
 ## 拡張思考（思考モード）を使用する
 
-[拡張思考](https://platform.claude.com/docs/en/build-with-claude/extended-thinking)はデフォルトで有効になっており、Claude が複雑な問題をステップバイステップで推論するためのスペースを提供します。この推論は詳細モードで表示され、`Ctrl+O` でオンに切り替えることができます。さらに、[努力レベルをサポートするモデル](/ja/model-config#adjust-effort-level)は適応的推論を使用します。固定された思考トークン予算の代わりに、モデルは努力レベル設定とタスクに基づいて動的に思考を決定します。適応的推論により、Claude は日常的なプロンプトにより速く応答し、それから恩恵を受けるステップのためにより深い思考を予約できます。
+[拡張思考](https://platform.claude.com/docs/ja/build-with-claude/extended-thinking)はデフォルトで有効になっており、Claude が複雑な問題をステップバイステップで推論するためのスペースを提供します。この推論は詳細モードで表示され、`Ctrl+O` でオンに切り替えることができます。拡張思考中、スピナーは「still thinking」や「almost done thinking」などのインラインの進捗ヒントを表示し、Claude が積極的に作業していることを示します。
+
+さらに、[努力レベルをサポートするモデル](/ja/model-config#adjust-effort-level)は適応的推論を使用します。固定された思考トークン予算の代わりに、モデルは努力レベル設定とタスクに基づいて動的に思考を決定します。適応的推論により、Claude は日常的なプロンプトにより速く応答し、それから恩恵を受けるステップのためにより深い思考を予約できます。
 
 拡張思考は、複雑なアーキテクチャの決定、難しいバグ、マルチステップの実装計画、異なるアプローチ間のトレードオフの評価に特に価値があります。
@@ -563,5 +565,7 @@ Claude Code を開始するときは、以前のセッションを再開でき
 アクティブなセッション内から、`/resume` を使用して別の会話に切り替えます。
 
-セッションはプロジェクトディレクトリごとに保存されます。デフォルトでは、`/resume` ピッカーは現在の worktree からのインタラクティブセッションを表示し、リストを他の worktree またはプロジェクトに広げるためのキーボードショートカットがあります。検索、プレビュー、名前変更を行います。[以下のセッションピッカーを使用](#use-the-session-picker)を参照してください。
+選択したセッションが古く、それを再度読み込むことが使用制限の実質的な部分を消費するほど大きい場合、`--resume`、`--continue`、および `/resume` は完全なトランスクリプトを読み込む代わりに、サマリーから再開することを提案します。このプロンプトは Amazon Bedrock、Google Cloud Vertex AI、または Microsoft Foundry では利用できません。
+
+セッションはプロジェクトディレクトリごとに保存されます。デフォルトでは、`/resume` ピッカーは現在の worktree からのインタラクティブセッションを表示し、リストを他の worktree またはプロジェクトに広げるためのキーボードショートカット、検索、プレビュー、名前変更があります。[以下のセッションピッカーを使用](#use-the-session-picker)を参照してください。
 
 別の worktree の同じリポジトリからセッションを選択すると、Claude Code はディレクトリを切り替える必要なく直接再開します。関連のないプロジェクトからセッションを選択すると、`cd` と再開コマンドをクリップボードにコピーします。
```

</details>

<details>
<summary>desktop-ja.md</summary>

```diff
diff --git a/docs-ja/pages/desktop-ja.md b/docs-ja/pages/desktop-ja.md
index 9b64fb9..8d5190c 100644
--- a/docs-ja/pages/desktop-ja.md
+++ b/docs-ja/pages/desktop-ja.md
@@ -582,5 +582,5 @@ Team または Enterprise プランの組織は、管理コンソールコント
 | `permissions.disableBypassPermissionsMode` | ユーザーが Bypass permissions モードを有効にするのを防ぐには`"disable"`に設定します。                                                                                          |
 | `disableAutoMode`                          | ユーザーが[Auto](/ja/permission-modes#eliminate-prompts-with-auto-mode)モードを有効にするのを防ぐには`"disable"`に設定します。モードセレクタから Auto を削除します。`permissions`の下でも受け入れられます。 |
-| `autoMode`                                 | 組織全体で auto mode 分類器が信頼およびブロックするものをカスタマイズします。[auto mode 分類器を設定する](/ja/permissions#configure-the-auto-mode-classifier)を参照してください。                      |
+| `autoMode`                                 | 組織全体で auto mode 分類器が信頼およびブロックするものをカスタマイズします。[auto mode を設定する](/ja/auto-mode-config)を参照してください。                                                       |
 | `sshConfigs`                               | 環境ドロップダウンに表示される[SSH 接続](#pre-configure-ssh-connections-for-your-team)を事前設定します。ユーザーは管理接続を編集または削除できません。                                               |
 
```

</details>

<details>
<summary>google-vertex-ai-ja.md</summary>

```diff
diff --git a/docs-ja/pages/google-vertex-ai-ja.md b/docs-ja/pages/google-vertex-ai-ja.md
index 90e9db6..c2c852b 100644
--- a/docs-ja/pages/google-vertex-ai-ja.md
+++ b/docs-ja/pages/google-vertex-ai-ja.md
@@ -7,4 +7,186 @@
 > Google Vertex AI を通じた Claude Code の設定方法について学びます。セットアップ、IAM 設定、トラブルシューティングを含みます。
 
+export const ContactSalesCard = ({surface}) => {
+  const utm = content => `utm_source=claude_code&utm_medium=docs&utm_content=${surface}_${content}`;
+  const iconArrowRight = (size = 13) => <svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">
+      <line x1="5" y1="12" x2="19" y2="12" />
+      <polyline points="12 5 19 12 12 19" />
+    </svg>;
+  const STYLES = `
+.cc-cs {
+  --cs-slate: #141413;
+  --cs-clay: #d97757;
+  --cs-clay-deep: #c6613f;
+  --cs-gray-000: #ffffff;
+  --cs-gray-700: #3d3d3a;
+  --cs-border-default: rgba(31, 30, 29, 0.15);
+  font-family: inherit;
+}
+.dark .cc-cs {
+  --cs-slate: #f0eee6;
+  --cs-gray-000: #262624;
+  --cs-gray-700: #bfbdb4;
+  --cs-border-default: rgba(240, 238, 230, 0.14);
+}
+.cc-cs-card {
```

</details>

<details>
<summary>hooks-ja.md</summary>

```diff
diff --git a/docs-ja/pages/hooks-ja.md b/docs-ja/pages/hooks-ja.md
index ac2d5f4..3cb9a0b 100644
--- a/docs-ja/pages/hooks-ja.md
+++ b/docs-ja/pages/hooks-ja.md
@@ -19,5 +19,5 @@
 <div style={{maxWidth: "500px", margin: "0 auto"}}>
   <Frame>
-    <img src="https://mintcdn.com/claude-code/NgDeMMkM7ZmaRibg/images/hooks-lifecycle.svg?fit=max&auto=format&n=NgDeMMkM7ZmaRibg&q=85&s=ec53c77f9943a6470cb2c8ecace6d809" alt="SessionStart から始まり、ターンごとのループ（UserPromptSubmit、nested agentic ループ（PreToolUse、PermissionRequest、PostToolUse、SubagentStart/Stop、TaskCreated、TaskCompleted）、Stop または StopFailure）、TeammateIdle、PreCompact、PostCompact、SessionEnd を含むフック ライフサイクル図。Elicitation と ElicitationResult は MCP ツール実行内にネストされ、PermissionDenied は PermissionRequest からの副分岐として、WorktreeCreate、WorktreeRemove、Notification、ConfigChange、InstructionsLoaded、CwdChanged、FileChanged はスタンドアロン非同期イベント" width="520" height="1155" data-path="images/hooks-lifecycle.svg" />
+    <img src="https://mintcdn.com/claude-code/NgDeMMkM7ZmaRibg/images/hooks-lifecycle.svg?fit=max&auto=format&n=NgDeMMkM7ZmaRibg&q=85&s=ec53c77f9943a6470cb2c8ecace6d809" alt="SessionStart から始まり、ターンごとのループ（UserPromptSubmit、UserPromptExpansion（スラッシュ コマンド用）、ネストされた agentic ループ（PreToolUse、PermissionRequest、PostToolUse、PostToolUseFailure、SubagentStart/Stop、TaskCreated、TaskCompleted）、Stop または StopFailure）、TeammateIdle、PreCompact、PostCompact、SessionEnd を含むフック ライフサイクル図。Elicitation と ElicitationResult は MCP ツール実行内にネストされ、PermissionDenied は PermissionRequest からの副分岐として、WorktreeCreate、WorktreeRemove、Notification、ConfigChange、InstructionsLoaded、CwdChanged、FileChanged はスタンドアロン非同期イベント" width="520" height="1155" data-path="images/hooks-lifecycle.svg" />
   </Frame>
 </div>
@@ -201,4 +201,5 @@ fi
 | `StopFailure`                                                                                            | エラー タイプ                                        | `rate_limit`、`authentication_failed`、`billing_error`、`invalid_request`、`server_error`、`max_output_tokens`、`unknown` |
 | `InstructionsLoaded`                                                                                     | ロード理由                                          | `session_start`、`nested_traversal`、`path_glob_match`、`include`、`compact`                                            |
+| `UserPromptExpansion`                                                                                    | コマンド名                                          | スキルまたはコマンド名                                                                                                         |
 | `Elicitation`                                                                                            | MCP サーバー名                                      | 設定された MCP サーバー名                                                                                                     |
 | `ElicitationResult`                                                                                      | MCP サーバー名                                      | `Elicitation` と同じ値                                                                                                  |
@@ -229,5 +230,5 @@ fi
 `UserPromptSubmit`、`Stop`、`TeammateIdle`、`TaskCreated`、`TaskCompleted`、`WorktreeCreate`、`WorktreeRemove`、`CwdChanged` はマッチャーをサポートせず、すべての出現で常に発火します。これらのイベントに `matcher` フィールドを追加すると、サイレントに無視されます。
 
-ツール イベントの場合、個別のフック ハンドラーで [`if` フィールド](#common-fields)を設定することで、より狭くフィルタリングできます。`if` は[権限ルール構文](/ja/permissions)を使用してツール名と引数を一緒にマッチするため、`"Bash(git *)"` は `git` コマンドのみに対して実行され、`"Edit(*.ts)"` は TypeScript ファイルのみに対して実行されます。
+ツール イベントの場合、個別のフック ハンドラーで [`if` フィールド](#common-fields)を設定することで、より狭くフィルタリングできます。`if` は[権限ルール構文](/ja/permissions)を使用してツール名と引数を一緒にマッチするため、`"Bash(git *)"` は `git *` に一致する Bash 入力のサブコマンドのいずれかに対して実行され、`"Edit(*.ts)"` は TypeScript ファイルのみに対して実行されます。
 
 #### MCP ツールをマッチ
@@ -512,5 +513,5 @@ Claude Code で `/hooks` と入力して、設定されたフックの読み取
 フック コマンドからの終了コードは、Claude Code にアクションが進行すべきか、ブロックされるべきか、無視されるべきかを伝えます。
 
-**終了 0** は成功を意味します。Claude Code は stdout を[JSON 出力フィールド](#json-output)で解析します。JSON 出力は終了 0 でのみ処理されます。ほとんどのイベントでは、stdout はデバッグ ログに書き込まれますが、トランスクリプトには表示されません。例外は `UserPromptSubmit` と `SessionStart` で、stdout は Claude が見て行動できるコンテキストとして追加されます。
+**終了 0** は成功を意味します。Claude Code は stdout を[JSON 出力フィールド](#json-output)で解析します。JSON 出力は終了 0 でのみ処理されます。ほとんどのイベントでは、stdout はデバッグ ログに書き込まれますが、トランスクリプトには表示されません。例外は `UserPromptSubmit`、`UserPromptExpansion`、および `SessionStart` で、stdout は Claude が見て行動できるコンテキストとして追加されます。
 
```

</details>

<details>
<summary>memory-ja.md</summary>

```diff
diff --git a/docs-ja/pages/memory-ja.md b/docs-ja/pages/memory-ja.md
index b6cf082..fb7c79b 100644
--- a/docs-ja/pages/memory-ja.md
+++ b/docs-ja/pages/memory-ja.md
@@ -39,15 +39,27 @@ Subagent も独自の自動メモリを保持できます。詳細について
 CLAUDE.md ファイルは、プロジェクト、個人的なワークフロー、または組織全体に対して Claude に永続的な指示を与えるマークダウンファイルです。これらのファイルをプレーンテキストで書きます。Claude は各セッションの開始時にそれらを読みます。
 
+### CLAUDE.md をいつ追加するか
+
+CLAUDE.md を、そうでなければ再度説明する場所として扱います。以下の場合に追加します。
+
+* Claude が 2 回目に同じ間違いを犯す
+* コードレビューが Claude がこのコードベースについて知っておくべきだったことを指摘する
+* 前回のセッションで入力した同じ修正または説明をチャットに入力する
+* 新しいチームメンバーが生産的になるために同じコンテキストが必要になる
+
+Claude がすべてのセッションで保持すべき事実に限定します。ビルドコマンド、規約、プロジェクトレイアウト、「常に X を実行する」ルール。エントリが複数ステップの手順である場合、またはコードベースの 1 つの部分にのみ関連する場合は、代わりに [skill](/ja/skills) または [パススコープルール](#organize-rules-with-clauderules) に移動します。[拡張機能の概要](/ja/features-overview#build-your-setup-over-time)では、各メカニズムをいつ使用するかについて説明しています。
+
 ### CLAUDE.md ファイルをどこに配置するかを選択する
 
 CLAUDE.md ファイルはいくつかの場所に配置でき、それぞれ異なるスコープを持ちます。より具体的な場所がより広い場所よりも優先されます。
 
-| スコープ         | 場所                                                                                                                                                                    | 目的                     | ユースケースの例                          | 共有対象              |
-| ------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------- | --------------------------------- | ----------------- |
-| **管理ポリシー**   | • macOS: `/Library/Application Support/ClaudeCode/CLAUDE.md`<br />• Linux と WSL: `/etc/claude-code/CLAUDE.md`<br />• Windows: `C:\Program Files\ClaudeCode\CLAUDE.md` | IT/DevOps が管理する組織全体の指示 | 会社のコーディング標準、セキュリティポリシー、コンプライアンス要件 | 組織内のすべてのユーザー      |
-| **プロジェクト指示** | `./CLAUDE.md` または `./.claude/CLAUDE.md`                                                                                                                               | プロジェクトのチーム共有指示         | プロジェクトアーキテクチャ、コーディング標準、一般的なワークフロー | ソース管理を通じたチームメンバー  |
-| **ユーザー指示**   | `~/.claude/CLAUDE.md`                                                                                                                                                 | すべてのプロジェクトの個人的な好み      | コードスタイルの好み、個人的なツーリングショートカット       | あなただけ（すべてのプロジェクト） |
+| スコープ         | 場所                                                                                                                                                                    | 目的                                  | ユースケースの例                          | 共有対象              |
+| ------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------- | --------------------------------- | ----------------- |
+| **管理ポリシー**   | • macOS: `/Library/Application Support/ClaudeCode/CLAUDE.md`<br />• Linux と WSL: `/etc/claude-code/CLAUDE.md`<br />• Windows: `C:\Program Files\ClaudeCode\CLAUDE.md` | IT/DevOps が管理する組織全体の指示              | 会社のコーディング標準、セキュリティポリシー、コンプライアンス要件 | 組織内のすべてのユーザー      |
```

</details>

*...以降省略*

</details>


<details>
<summary>2026-04-22</summary>

**変更ファイル:**

```
 docs-ja/pages/best-practices-ja.md      |    3 +-
 docs-ja/pages/changelog.md              |   31 +
 docs-ja/pages/claude-directory-en.md    | 1523 -------------------------------
 docs-ja/pages/commands-ja.md            |    2 +-
 docs-ja/pages/common-workflows-ja.md    |   88 +-
 docs-ja/pages/data-usage-ja.md          |   35 +-
 docs-ja/pages/desktop-ja.md             |   40 +-
 docs-ja/pages/hooks-guide-ja.md         |   57 +-
 docs-ja/pages/hooks-ja.md               |   59 +-
 docs-ja/pages/network-config-ja.md      |   38 +-
 docs-ja/pages/permissions-ja.md         |   12 +-
 docs-ja/pages/plugin-dependencies-en.md |  104 ---
 docs-ja/pages/plugin-marketplaces-ja.md |  197 +++-
 docs-ja/pages/plugins-reference-ja.md   |  110 ++-
 docs-ja/pages/settings-ja.md            |   12 +-
 docs-ja/pages/skills-ja.md              |  121 ++-
 docs-ja/pages/statusline-ja.md          |  107 ++-
 docs-ja/pages/sub-agents-ja.md          |   46 +-
 docs-ja/pages/ultrareview-ja.md         |   12 +-
 docs-ja/pages/vs-code-ja.md             |  156 ++--
 docs-ja/pages/zero-data-retention-ja.md |    4 +-
 21 files changed, 748 insertions(+), 2009 deletions(-)
```

**新規追加:**


**削除:**


<details>
<summary>best-practices-ja.md</summary>

```diff
diff --git a/docs-ja/pages/best-practices-ja.md b/docs-ja/pages/best-practices-ja.md
index 5f2fe13..dbdc966 100644
--- a/docs-ja/pages/best-practices-ja.md
+++ b/docs-ja/pages/best-practices-ja.md
@@ -21,5 +21,5 @@ Claude Code は agentic coding 環境です。質問に答えて待つチャッ
 Claude のコンテキストウィンドウは、すべてのメッセージ、Claude が読み取ったすべてのファイル、およびすべてのコマンド出力を含む、会話全体を保持します。ただし、これはすぐにいっぱいになる可能性があります。単一のデバッグセッションまたはコードベース探索でも、数万のトークンを生成および消費する可能性があります。
 
-LLM のパフォーマンスはコンテキストが満杯になるにつれて低下するため、これは重要です。コンテキストウィンドウがいっぱいになると、Claude は以前の指示を「忘れる」か、より多くの間違いを犯す可能性があります。コンテキストウィンドウは管理する最も重要なリソースです。[カスタムステータスライン](/ja/statusline)でコンテキスト使用量を継続的に追跡し、トークン使用量を削減するための戦略については[トークン使用量を削減](/ja/costs#reduce-token-usage)を参照してください。
+LLM のパフォーマンスはコンテキストが満杯になるにつれて低下するため、これは重要です。コンテキストウィンドウがいっぱいになると、Claude は以前の指示を「忘れる」か、より多くの間違いを犯す可能性があります。コンテキストウィンドウは管理する最も重要なリソースです。セッションがどのように満杯になるかを実際に確認するには、スタートアップで何が読み込まれるか、各ファイル読み取りのコストについての[インタラクティブなウォークスルー](/ja/context-window)を参照してください。[カスタムステータスライン](/ja/statusline)でコンテキスト使用量を継続的に追跡し、トークン使用量を削減するための戦略については[トークン使用量を削減](/ja/costs#reduce-token-usage)を参照してください。
 
 ***
@@ -195,4 +195,5 @@ CLAUDE.md ファイルはいくつかの場所に配置できます。
 * **ホームフォルダ（`~/.claude/CLAUDE.md`）**：すべての Claude セッションに適用されます
 * **プロジェクトルート（`./CLAUDE.md`）**：git にチェックインしてチームと共有します
+* **プロジェクトルート（`./CLAUDE.local.md`）**：個人的なプロジェクト固有のメモ；このファイルを `.gitignore` に追加して、チームと共有しないようにします
 * **親ディレクトリ**：`root/CLAUDE.md` と `root/foo/CLAUDE.md` の両方が自動的にプルされるモノレポに役立ちます
 * **子ディレクトリ**：Claude はそれらのディレクトリ内のファイルを操作するときに、子 CLAUDE.md ファイルをオンデマンドでプルします
```

</details>

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index d68a21f..65e9f4b 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,35 @@
 # Changelog
 
+## 2.1.117
+
+- Forked subagents can now be enabled on external builds by setting `CLAUDE_CODE_FORK_SUBAGENT=1`
+- Agent frontmatter `mcpServers` are now loaded for main-thread agent sessions via `--agent`
+- Improved `/model`: selections now persist across restarts even when the project pins a different model, and the startup header shows when the active model comes from a project or managed-settings pin
+- The `/resume` command now offers to summarize stale, large sessions before re-reading them, matching the existing `--resume` behavior
+- Faster startup when both local and claude.ai MCP servers are configured (concurrent connect now default)
+- `plugin install` on an already-installed plugin now installs any missing dependencies instead of stopping at "already installed"
+- Plugin dependency errors now say "not installed" with an install hint, and `claude plugin marketplace add` now auto-resolves missing dependencies from configured marketplaces
+- Managed-settings `blockedMarketplaces` and `strictKnownMarketplaces` are now enforced on plugin install, update, refresh, and autoupdate
+- Advisor Tool (experimental): dialog now carries an "experimental" label, learn-more link, and startup notification when enabled; sessions no longer get stuck with "Advisor tool result content could not be processed" errors on every prompt and `/compact`
+- The `cleanupPeriodDays` retention sweep now also covers `~/.claude/tasks/`, `~/.claude/shell-snapshots/`, and `~/.claude/backups/`
+- OpenTelemetry: `user_prompt` events now include `command_name` and `command_source` for slash commands; `cost.usage`, `token.usage`, `api_request`, and `api_error` now include an `effort` attribute when the model supports effort levels. Custom/MCP command names are redacted unless `OTEL_LOG_TOOL_DETAILS=1` is set
+- Native builds on macOS and Linux: the `Glob` and `Grep` tools are replaced by embedded `bfs` and `ugrep` available through the Bash tool — faster searches without a separate tool round-trip (Windows and npm-installed builds unchanged)
+- Windows: cached `where.exe` executable lookups per process for faster subprocess launches
+- Default effort for Pro/Max subscribers on Opus 4.6 and Sonnet 4.6 is now `high` (was `medium`)
+- Fixed Plain-CLI OAuth sessions dying with "Please run /login" when the access token expires mid-session — the token is now refreshed reactively on 401
+- Fixed `WebFetch` hanging on very large HTML pages by truncating input before HTML-to-markdown conversion
+- Fixed a crash when a proxy returns HTTP 204 No Content — now surfaces a clear error instead of a `TypeError`
+- Fixed `/login` having no effect when launched with `CLAUDE_CODE_OAUTH_TOKEN` env var and that token expires
+- Fixed prompt-input undo (`Ctrl+_`) doing nothing immediately after typing, and skipping a state on each undo step
+- Fixed `NO_PROXY` not being respected for remote API requests when running under Bun
+- Fixed rare spurious escape/return triggers when key names arrive as coalesced text over slow connections
```

</details>

<details>
<summary>commands-ja.md</summary>

```diff
diff --git a/docs-ja/pages/commands-ja.md b/docs-ja/pages/commands-ja.md
index 06eff03..30d6e9b 100644
--- a/docs-ja/pages/commands-ja.md
+++ b/docs-ja/pages/commands-ja.md
@@ -24,5 +24,5 @@
 | `/batch <instruction>`       | **[スキル](/ja/skills#bundled-skills)。** コードベース全体にわたる大規模な変更を並列で調整します。コードベースを調査し、作業を 5 ～ 30 個の独立したユニットに分解し、計画を提示します。承認されると、分離された [git worktree](/ja/common-workflows#run-parallel-claude-code-sessions-with-git-worktrees) 内の各ユニットごとに 1 つのバックグラウンドエージェントを生成します。各エージェントはそのユニットを実装し、テストを実行し、プルリクエストを開きます。git リポジトリが必要です。例: `/batch migrate src/ from Solid to React`                                                                                             |
 | `/branch [name]`             | この時点で現在の会話のブランチを作成。ブランチに切り替え、元の会話を保持します。`/resume` で戻ることができます。エイリアス: `/fork`                                                                                                                                                                                                                                                                                                                                                                                |
-| `/btw <question>`            | 会話に追加せずに[サイドクエスチョン](/ja/interactive-mode#side-questions-with-btw)として素早く質問                                                                                                                                                                                                                                                                                                                                                                                  |
+| `/btw <question>`            | 会話に追加せずに[サイドクエスチョン](/ja/interactive-mode#side-questions-with-%2Fbtw)として素早く質問                                                                                                                                                                                                                                                                                                                                                                               |
 | `/chrome`                    | [Chrome の Claude](/ja/chrome) 設定を構成                                                                                                                                                                                                                                                                                                                                                                                                                        |
 | `/claude-api`                | **[スキル](/ja/skills#bundled-skills)。** プロジェクトの言語（Python、TypeScript、Java、Go、Ruby、C#、PHP、または cURL）と Managed Agents リファレンス用の Claude API リファレンス資料を読み込みます。ツール使用、ストリーミング、バッチ、構造化出力、および一般的な落とし穴をカバーしています。また、コードが `anthropic` または `@anthropic-ai/sdk` をインポートするときに自動的にアクティブになります                                                                                                                                                                                     |
```

</details>

<details>
<summary>common-workflows-ja.md</summary>

```diff
diff --git a/docs-ja/pages/common-workflows-ja.md b/docs-ja/pages/common-workflows-ja.md
index e280607..b3a6387 100644
--- a/docs-ja/pages/common-workflows-ja.md
+++ b/docs-ja/pages/common-workflows-ja.md
@@ -404,4 +404,12 @@ Claude に直接プルリクエストを作成するよう依頼するか（「c
 ***
 
+## ノートと非コードフォルダで作業する
+
+Claude Code はどのディレクトリでも機能します。ノートボルト、ドキュメントフォルダ、またはマークダウンファイルの任意のコレクション内で実行して、コードと同じ方法でコンテンツを検索、編集、再編成します。
+
+`.claude/` ディレクトリと `CLAUDE.md` は他のツールの設定ディレクトリと並んで競合なく存在します。Claude は各ツール呼び出しで新しくファイルを読み込むため、別のアプリケーションで行った編集は次回そのファイルを読み込むときに表示されます。
+
+***
+
 ## 画像を使用する
 
@@ -507,7 +515,5 @@ Claude に直接プルリクエストを作成するよう依頼するか（「c
 ## 拡張思考（思考モード）を使用する
 
-[拡張思考](https://platform.claude.com/docs/en/build-with-claude/extended-thinking)はデフォルトで有効になっており、Claude が複雑な問題をステップバイステップで推論するためのスペースを提供します。この推論は詳細モードで表示され、`Ctrl+O` でオンに切り替えることができます。
-
-さらに、Opus 4.6 と Sonnet 4.6 は適応的推論をサポートしています。固定された思考トークン予算の代わりに、モデルは[努力レベル](/ja/model-config#adjust-effort-level)設定に基づいて思考を動的に割り当てます。拡張思考と適応的推論は一緒に機能して、Claude が応答する前にどの程度深く推論するかを制御できます。
+[拡張思考](https://platform.claude.com/docs/en/build-with-claude/extended-thinking)はデフォルトで有効になっており、Claude が複雑な問題をステップバイステップで推論するためのスペースを提供します。この推論は詳細モードで表示され、`Ctrl+O` でオンに切り替えることができます。さらに、[努力レベルをサポートするモデル](/ja/model-config#adjust-effort-level)は適応的推論を使用します。固定された思考トークン予算の代わりに、モデルは努力レベル設定とタスクに基づいて動的に思考を決定します。適応的推論により、Claude は日常的なプロンプトにより速く応答し、それから恩恵を受けるステップのためにより深い思考を予約できます。
 
 拡張思考は、複雑なアーキテクチャの決定、難しいバグ、マルチステップの実装計画、異なるアプローチ間のトレードオフの評価に特に価値があります。
@@ -521,11 +527,11 @@ Claude に直接プルリクエストを作成するよう依頼するか（「c
 思考はデフォルトで有効になっていますが、調整または無効にできます。
 
-| スコープ                   | 設定方法                                                                             | 詳細                                                                                                                         |
```

</details>

<details>
<summary>data-usage-ja.md</summary>

```diff
diff --git a/docs-ja/pages/data-usage-ja.md b/docs-ja/pages/data-usage-ja.md
index 6aa6f3f..c6a4d7c 100644
--- a/docs-ja/pages/data-usage-ja.md
+++ b/docs-ja/pages/data-usage-ja.md
@@ -20,11 +20,11 @@
 [Development Partner Program](https://support.claude.com/ja/articles/11174108-about-the-development-partner-program) などを通じて、トレーニング用の資料を提供する方法に明示的にオプトインした場合、提供された資料を使用してモデルをトレーニングする可能性があります。組織管理者は、組織の Development Partner Program に明示的にオプトインできます。このプログラムは Anthropic ファーストパーティ API でのみ利用可能であり、Bedrock または Vertex ユーザーは利用できないことに注意してください。
 
-### `/bug` コマンドを使用したフィードバック
+### `/feedback` コマンドを使用したフィードバック
 
-`/bug` コマンドを使用して Claude Code に関するフィードバックを送信することを選択した場合、製品とサービスを改善するためにフィードバックを使用する可能性があります。`/bug` を通じて共有されたトランスクリプトは 5 年間保持されます。
+`/feedback` コマンドを使用して Claude Code に関するフィードバックを送信することを選択した場合、製品とサービスを改善するためにフィードバックを使用する可能性があります。`/feedback` を通じて共有されたトランスクリプトは 5 年間保持されます。
 
 ### セッション品質調査
 
-Claude Code で「How is Claude doing this session?」プロンプトが表示されたときに、この調査に応答する場合（「Dismiss」を選択する場合を含む）、数値評価（1、2、3、または dismiss）のみが記録されます。この調査の一部として、会話トランスクリプト、入力、出力、またはその他のセッションデータは収集または保存されません。サムズアップ/ダウンフィードバックまたは `/bug` レポートとは異なり、このセッション品質調査は単純な製品満足度メトリックです。この調査への応答は、データトレーニング設定に影響を与えず、AI モデルをトレーニングするために使用することはできません。
+Claude Code で「How is Claude doing this session?」プロンプトが表示されたときに、この調査に応答する場合（「Dismiss」を選択する場合を含む）、数値評価（1、2、3、または dismiss）のみが記録されます。この調査の一部として、会話トランスクリプト、入力、出力、またはその他のセッションデータは収集または保存されません。サムズアップ/ダウンフィードバックまたは `/feedback` レポートとは異なり、このセッション品質調査は単純な製品満足度メトリックです。この調査への応答は、データトレーニング設定に影響を与えず、AI モデルをトレーニングするために使用することはできません。
 
 これらの調査を無効にするには、`CLAUDE_CODE_DISABLE_FEEDBACK_SURVEY=1` を設定します。調査は、`DISABLE_TELEMETRY` または `CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC` が設定されている場合にも無効になります。頻度を制御する代わりに無効にするには、設定ファイルで [`feedbackSurveyRate`](/ja/settings#available-settings) を `0` から `1` の間の確率に設定します。
@@ -44,7 +44,7 @@ Anthropic は、アカウントタイプと設定に基づいて Claude Code デ
 * 標準：30 日間の保持期間
 * [Zero data retention](/ja/zero-data-retention)：Claude for Enterprise の Claude Code で利用可能。ZDR は組織ごとに有効になります。新しい各組織は、アカウントチームによって個別に ZDR を有効にする必要があります
-* ローカルキャッシング：Claude Code クライアントは、セッション再開を有効にするために、セッションをローカルに最大 30 日間保存できます（設定可能）
+* ローカルキャッシング：Claude Code クライアントは、セッション再開を有効にするために、`~/.claude/projects/` の下にセッショントランスクリプトをプレーンテキストでローカルに 30 日間保存します。`cleanupPeriodDays` で期間を調整できます。[application data](/ja/claude-directory#application-data) を参照して、何が保存されているか、およびそれをクリアする方法を確認してください。
 
-Web 上の個別の Claude Code セッションはいつでも削除できます。セッションを削除すると、セッションのイベントデータが永久に削除されます。セッションの削除方法については、[Managing sessions](/ja/claude-code-on-the-web#managing-sessions) を参照してください。
+Web 上の個別の Claude Code セッションはいつでも削除できます。セッションを削除すると、セッションのイベントデータが永久に削除されます。セッションの削除方法については、[Delete sessions](/ja/claude-code-on-the-web#delete-sessions) を参照してください。
 
 データ保持慣行の詳細については、[Privacy Center](https://privacy.anthropic.com/) を参照してください。
@@ -83,16 +83,23 @@ Claude Code は、ユーザーのマシンから Statsig サービスに接続
```

</details>

<details>
<summary>desktop-ja.md</summary>

```diff
diff --git a/docs-ja/pages/desktop-ja.md b/docs-ja/pages/desktop-ja.md
index a688330..9b64fb9 100644
--- a/docs-ja/pages/desktop-ja.md
+++ b/docs-ja/pages/desktop-ja.md
@@ -511,9 +511,9 @@ Claude が別のポートを選択すると、割り当てられたポートを`
 ### ローカルセッション
 
-デスクトップアプリは常にシェル環境全体を継承するわけではありません。macOS では、Dock または Finder からアプリを起動すると、`~/.zshrc`または`~/.bashrc`などのシェルプロファイルを読み取り、`PATH`と固定された Claude Code 変数セットを抽出しますが、そこでエクスポートする他の変数は取得されません。Windows では、アプリはユーザーおよびシステム環境変数を継承しますが、PowerShell プロファイルは読み取りません。
+デスクトップアプリは常にシェル環境全体を継承するわけではありません。macOS では、Dock または Finder からアプリを起動すると、`~/.zshrc` または `~/.bashrc` などのシェルプロファイルを読み取り、`PATH` と固定された Claude Code 変数セットを抽出しますが、そこでエクスポートする他の変数は取得されません。Windows では、アプリはユーザーおよびシステム環境変数を継承しますが、PowerShell プロファイルは読み取りません。
 
-ローカルセッションと dev サーバーの環境変数を設定するには、プロンプトボックスの環境ドロップダウンを開き、**Local**にマウスを合わせて、ギアアイコンをクリックしてローカル環境エディタを開きます。ここで保存する変数は、マシンに暗号化されて保存され、開始するすべてのローカルセッションとプレビューサーバーに適用されます。また、`~/.claude/settings.json`ファイルの`env`キーに変数を追加することもできます。ただし、これらは Claude セッションにのみ到達し、dev サーバーには到達しません。サポートされている変数の完全なリストについては、[環境変数](/ja/env-vars)を参照してください。
+ローカルセッションと dev サーバーの環境変数を設定するには、プロンプトボックスの環境ドロップダウンを開き、**Local** にマウスを合わせて、ギアアイコンをクリックしてローカル環境エディタを開きます。ここで保存する変数は、マシンに暗号化されて保存され、開始するすべてのローカルセッションとプレビューサーバーに適用されます。また、`~/.claude/settings.json` ファイルの `env` キーに変数を追加することもできます。ただし、これらは Claude セッションにのみ到達し、dev サーバーには到達しません。サポートされている変数の完全なリストについては、[環境変数](/ja/env-vars)を参照してください。
 
-[拡張思考](/ja/common-workflows#use-extended-thinking-thinking-mode)はデフォルトで有効になっており、複雑な推論タスクのパフォーマンスを向上させますが、追加のトークンを使用します。思考を完全に無効にするには、ローカル環境エディタで`MAX_THINKING_TOKENS`を`0`に設定します。[適応的推論](/ja/model-config#adjust-effort-level)を持つモデルでは、適応的推論が思考の深さを制御するため、他の`MAX_THINKING_TOKENS`値は無視されます。Opus 4.6 と Sonnet 4.6 では、固定思考予算を使用するために`CLAUDE_CODE_DISABLE_ADAPTIVE_THINKING`を`1`に設定します。Opus 4.7 は常に適応的推論を使用し、固定予算モードはありません。
+[拡張思考](/ja/common-workflows#use-extended-thinking-thinking-mode)はデフォルトで有効になっており、複雑な推論タスクのパフォーマンスを向上させますが、追加のトークンを使用します。思考を完全に無効にするには、ローカル環境エディタで `MAX_THINKING_TOKENS` を `0` に設定します。[適応的推論](/ja/model-config#adjust-effort-level)を持つモデルでは、適応的推論が思考の深さを制御するため、他の `MAX_THINKING_TOKENS` 値は無視されます。Opus 4.6 と Sonnet 4.6 では、固定思考予算を使用するために `CLAUDE_CODE_DISABLE_ADAPTIVE_THINKING` を `1` に設定します。Opus 4.7 は常に適応的推論を使用し、固定予算モードはありません。
 
 ### リモートセッション
@@ -521,5 +521,5 @@ Claude が別のポートを選択すると、割り当てられたポートを`
 リモートセッションはアプリを閉じても、バックグラウンドで続行されます。使用状況は[サブスクリプションプランの制限](/ja/costs)にカウントされ、別の計算料金はありません。
 
-異なるネットワークアクセスレベルと環境変数を持つカスタムクラウド環境を作成できます。リモートセッションを開始するときに環境ドロップダウンを選択し、**Add environment**を選択します。ネットワークアクセスと環境変数の設定の詳細については、[クラウド環境](/ja/claude-code-on-the-web#the-cloud-environment)を参照してください。
+異なるネットワークアクセスレベルと環境変数を持つカスタムクラウド環境を作成できます。リモートセッションを開始するときに環境ドロップダウンを選択し、**Add environment** を選択します。ネットワークアクセスと環境変数の設定の詳細については、[クラウド環境](/ja/claude-code-on-the-web#the-cloud-environment)を参照してください。
 
 ### SSH セッション
@@ -527,10 +527,10 @@ Claude が別のポートを選択すると、割り当てられたポートを`
 SSH セッションを使用すると、デスクトップアプリをインターフェイスとして使用しながら、リモートマシンで Claude Code を実行できます。これは、クラウド VM、dev コンテナ、または特定のハードウェアまたは依存関係を持つサーバーに存在するコードベースで作業するのに便利です。
 
-SSH 接続を追加するには、セッションを開始する前に環境ドロップダウンをクリックして、**+ Add SSH connection**を選択します。ダイアログは以下を要求します：
+SSH 接続を追加するには、セッションを開始する前に環境ドロップダウンをクリックして、**+ Add SSH connection** を選択します。ダイアログは以下を要求します：
 
```

</details>

<details>
<summary>hooks-guide-ja.md</summary>

```diff
diff --git a/docs-ja/pages/hooks-guide-ja.md b/docs-ja/pages/hooks-guide-ja.md
index 7df87f6..e51bdaf 100644
--- a/docs-ja/pages/hooks-guide-ja.md
+++ b/docs-ja/pages/hooks-guide-ja.md
@@ -424,32 +424,33 @@ Hook が承認すると、Claude Code は Plan Mode を終了し、Plan Mode に
 Hook イベントは Claude Code のライフサイクルの特定のポイントで発火します。イベントが発火すると、すべてのマッチングする hooks が並列で実行され、同一の hook コマンドは自動的に重複排除されます。以下の表は各イベントとそれがトリガーされるときを示しています：
 
-| Event                | When it fires                                                                                                                                          |
-| :------------------- | :----------------------------------------------------------------------------------------------------------------------------------------------------- |
-| `SessionStart`       | When a session begins or resumes                                                                                                                       |
-| `UserPromptSubmit`   | When you submit a prompt, before Claude processes it                                                                                                   |
-| `PreToolUse`         | Before a tool call executes. Can block it                                                                                                              |
-| `PermissionRequest`  | When a permission dialog appears                                                                                                                       |
-| `PermissionDenied`   | When a tool call is denied by the auto mode classifier. Return `{retry: true}` to tell the model it may retry the denied tool call                     |
-| `PostToolUse`        | After a tool call succeeds                                                                                                                             |
-| `PostToolUseFailure` | After a tool call fails                                                                                                                                |
-| `Notification`       | When Claude Code sends a notification                                                                                                                  |
-| `SubagentStart`      | When a subagent is spawned                                                                                                                             |
-| `SubagentStop`       | When a subagent finishes                                                                                                                               |
-| `TaskCreated`        | When a task is being created via `TaskCreate`                                                                                                          |
-| `TaskCompleted`      | When a task is being marked as completed                                                                                                               |
-| `Stop`               | When Claude finishes responding                                                                                                                        |
-| `StopFailure`        | When the turn ends due to an API error. Output and exit code are ignored                                                                               |
-| `TeammateIdle`       | When an [agent team](/en/agent-teams) teammate is about to go idle                                                                                     |
-| `InstructionsLoaded` | When a CLAUDE.md or `.claude/rules/*.md` file is loaded into context. Fires at session start and when files are lazily loaded during a session         |
-| `ConfigChange`       | When a configuration file changes during a session                                                                                                     |
-| `CwdChanged`         | When the working directory changes, for example when Claude executes a `cd` command. Useful for reactive environment management with tools like direnv |
-| `FileChanged`        | When a watched file changes on disk. The `matcher` field specifies which filenames to watch                                                            |
-| `WorktreeCreate`     | When a worktree is being created via `--worktree` or `isolation: "worktree"`. Replaces default git behavior                                            |
-| `WorktreeRemove`     | When a worktree is being removed, either at session exit or when a subagent finishes                                                                   |
```

</details>

*...以降省略*

</details>


<details>
<summary>2026-04-21</summary>

**変更ファイル:**

```
 docs-ja/pages/changelog.md             |  27 +++
 docs-ja/pages/commands-ja.md           | 164 ++++++++------
 docs-ja/pages/desktop-ja.md            | 341 ++++++++++++++--------------
 docs-ja/pages/desktop-quickstart-ja.md |  56 ++---
 docs-ja/pages/env-vars-ja.md           | 391 +++++++++++++++++----------------
 docs-ja/pages/fullscreen-ja.md         |  46 ++--
 docs-ja/pages/hooks-guide-ja.md        | 119 ++++++----
 docs-ja/pages/hooks-ja.md              | 200 ++++++++++-------
 docs-ja/pages/interactive-mode-ja.md   | 118 +++++-----
 docs-ja/pages/keybindings-ja.md        |  91 +++++---
 docs-ja/pages/model-config-ja.md       | 122 ++++++----
 docs-ja/pages/permissions-ja.md        |  72 ++++--
 docs-ja/pages/remote-control-ja.md     |   9 +-
 docs-ja/pages/routines-ja.md           |   2 -
 docs-ja/pages/sandboxing-ja.md         |   7 +-
 docs-ja/pages/scheduled-tasks-ja.md    |  10 +-
 docs-ja/pages/settings-ja.md           |  54 +++--
 docs-ja/pages/setup-ja.md              |  43 ++--
 docs-ja/pages/terminal-config-ja.md    | 167 +++++++++-----
 docs-ja/pages/troubleshooting-ja.md    | 171 +++++++++++---
 20 files changed, 1330 insertions(+), 880 deletions(-)
```

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index 475ad34..d68a21f 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,31 @@
 # Changelog
 
+## 2.1.116
+
+- `/resume` on large sessions is significantly faster (up to 67% on 40MB+ sessions) and handles sessions with many dead-fork entries more efficiently
+- Faster MCP startup when multiple stdio servers are configured; `resources/templates/list` is now deferred to first `@`-mention
+- Smoother fullscreen scrolling in VS Code, Cursor, and Windsurf terminals — `/terminal-setup` now configures the editor's scroll sensitivity
+- Thinking spinner now shows progress inline ("still thinking", "thinking more", "almost done thinking"), replacing the separate hint row
+- `/config` search now matches option values (e.g. searching "vim" finds the Editor mode setting)
+- `/doctor` can now be opened while Claude is responding, without waiting for the current turn to finish
+- `/reload-plugins` and background plugin auto-update now auto-install missing plugin dependencies from marketplaces you've already added
+- Bash tool now surfaces a hint when `gh` commands hit GitHub's API rate limit, so agents can back off instead of retrying
+- The Usage tab in Settings now shows your 5-hour and weekly usage immediately and no longer fails when the usage endpoint is rate-limited
+- Agent frontmatter `hooks:` now fire when running as a main-thread agent via `--agent`
+- Slash command menu now shows "No commands match" when your filter has zero results, instead of disappearing
+- Security: sandbox auto-allow no longer bypasses the dangerous-path safety check for `rm`/`rmdir` targeting `/`, `$HOME`, or other critical system directories
+- Fixed Devanagari and other Indic scripts rendering with broken column alignment in the terminal UI
+- Fixed Ctrl+- not triggering undo in terminals using the Kitty keyboard protocol (iTerm2, Ghostty, kitty, WezTerm, Windows Terminal)
+- Fixed Cmd+Left/Right not jumping to line start/end in terminals that use the Kitty keyboard protocol (Warp fullscreen, kitty, Ghostty, WezTerm)
+- Fixed Ctrl+Z hanging the terminal when Claude Code is launched via a wrapper process (e.g. `npx`, `bun run`)
+- Fixed scrollback duplication in inline mode where resizing the terminal or large output bursts would repeat earlier conversation history
+- Fixed modal search dialogs overflowing the screen at short terminal heights, hiding the search box and keyboard hints
+- Fixed scattered blank cells and disappearing composer chrome in the VS Code integrated terminal during scrolling
+- Fixed an intermittent API 400 error related to cache control TTL ordering that could occur when a parallel request completed during request setup
+- Fixed `/branch` rejecting conversations with transcripts larger than 50MB
```

</details>

<details>
<summary>commands-ja.md</summary>

```diff
diff --git a/docs-ja/pages/commands-ja.md b/docs-ja/pages/commands-ja.md
index 20e57ff..06eff03 100644
--- a/docs-ja/pages/commands-ja.md
+++ b/docs-ja/pages/commands-ja.md
@@ -3,81 +3,103 @@
 > Use this file to discover all available pages before exploring further.
 
-# 組み込みコマンド
+# コマンド
 
-> Claude Code で利用可能な組み込みコマンドの完全なリファレンス。
+> Claude Code で利用可能なコマンドの完全なリファレンス。組み込みコマンドとバンドルされたスキルを含む。
 
-Claude Code で `/` と入力すると、利用可能なすべてのコマンドが表示されます。または `/` の後に任意の文字を入力してフィルタリングできます。すべてのコマンドがすべてのユーザーに表示されるわけではありません。プラットフォーム、プラン、または環境によって異なります。たとえば、`/desktop` は macOS と Windows にのみ表示され、`/upgrade` と `/privacy-settings` は Pro プランと Max プランでのみ利用可能で、`/terminal-setup` はターミナルがネイティブにキーバインディングをサポートしている場合は非表示になります。
+コマンドはセッション内から Claude Code を制御します。モデルの切り替え、権限の管理、コンテキストのクリア、ワークフローの実行など、様々な操作を素早く行うことができます。
 
-Claude Code には、`/` と入力したときに組み込みコマンドと一緒に表示される `/simplify`、`/batch`、`/debug`、`/loop` などの[バンドルされたスキル](/ja/skills#bundled-skills)も含まれています。独自のコマンドを作成するには、[スキル](/ja/skills)を参照してください。
+`/` と入力すると、利用可能なすべてのコマンドが表示されます。または `/` の後に文字を入力してフィルタリングできます。
+
+以下の表は Claude Code に含まれるすべてのコマンドをリストしています。**[スキル](/ja/skills#bundled-skills)** とマークされたエントリはバンドルされたスキルです。これらは自分で作成するスキルと同じメカニズムを使用します。Claude に渡されるプロンプトであり、Claude は関連する場合に自動的に呼び出すこともできます。その他はすべて、CLI にコード化された動作を持つ組み込みコマンドです。独自のコマンドを追加するには、[スキル](/ja/skills)を参照してください。
+
+すべてのコマンドがすべてのユーザーに表示されるわけではありません。可用性はプラットフォーム、プラン、環境によって異なります。たとえば、`/desktop` は macOS と Windows にのみ表示され、`/upgrade` は Pro プランと Max プランにのみ表示されます。
 
 以下の表では、`<arg>` は必須引数を示し、`[arg]` はオプション引数を示します。
 
-| コマンド                                     | 目的                                                                                                                                                                                       |
-| :--------------------------------------- | :--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
-| `/add-dir <path>`                        | 現在のセッション中にファイルアクセス用の作業ディレクトリを追加。ほとんどの `.claude/` 設定は追加されたディレクトリから[検出されません](/ja/permissions#additional-directories-grant-file-access-not-configuration)                                   |
-| `/agents`                                | [エージェント](/ja/sub-agents)設定を管理                                                                                                                                                            |
-| `/btw <question>`                        | 会話に追加せずに[サイドクエスチョン](/ja/interactive-mode#side-questions-with-btw)として素早く質問                                                                                                                |
```

</details>

<details>
<summary>desktop-ja.md</summary>

```diff
diff --git a/docs-ja/pages/desktop-ja.md b/docs-ja/pages/desktop-ja.md
index aece073..a688330 100644
--- a/docs-ja/pages/desktop-ja.md
+++ b/docs-ja/pages/desktop-ja.md
@@ -5,25 +5,41 @@
 # Claude Code Desktop を使用する
 
-> Claude Code Desktop をさらに活用する：コンピュータ使用、電話から Dispatch セッションを送信、Git 分離による並列セッション、ビジュアル diff レビュー、アプリプレビュー、PR 監視、コネクタ、エンタープライズ設定。
+> Claude Code Desktop をさらに活用する：Git 分離による並列セッション、ドラッグアンドドロップペインレイアウト、統合ターミナルとファイルエディタ、サイドチャット、コンピュータ使用、電話から Dispatch セッションを送信、ビジュアル diff レビュー、アプリプレビュー、PR 監視、コネクタ、エンタープライズ設定。
 
 Claude Desktop アプリ内の Code タブを使用すると、ターミナルではなくグラフィカルインターフェイスを通じて Claude Code を使用できます。
 
+<CardGroup cols={2}>
+  <Card title="Download for macOS" icon="apple" href="https://claude.ai/api/desktop/darwin/universal/dmg/latest/redirect?utm_source=claude_code&utm_medium=docs">
+    Universal build for Intel and Apple Silicon
+  </Card>
+
+  <Card title="Download for Windows" icon="windows" href="https://claude.ai/api/desktop/win32/x64/setup/latest/redirect?utm_source=claude_code&utm_medium=docs">
+    For x64 processors
+  </Card>
+</CardGroup>
+
+For Windows ARM64, download the [ARM64 installer](https://claude.ai/api/desktop/win32/arm64/setup/latest/redirect?utm_source=claude_code\&utm_medium=docs). Linux is not supported.
+
+インストール後、Claude を起動してサインインし、**Code**タブをクリックします。最初のセッションの完全なウォークスルーについては、[はじめにガイド](/ja/desktop-quickstart)を参照してください。
+
 Desktop は標準的な Claude Code エクスペリエンスに以下の機能を追加します：
 
-* [ビジュアル diff レビュー](#review-changes-with-diff-view)（インラインコメント付き）
-* [ライブアプリプレビュー](#preview-your-app)（dev サーバー付き）
```

</details>

<details>
<summary>desktop-quickstart-ja.md</summary>

```diff
diff --git a/docs-ja/pages/desktop-quickstart-ja.md b/docs-ja/pages/desktop-quickstart-ja.md
index ee92f63..2145a52 100644
--- a/docs-ja/pages/desktop-quickstart-ja.md
+++ b/docs-ja/pages/desktop-quickstart-ja.md
@@ -7,13 +7,23 @@
 > Claude Code をデスクトップにインストールして、最初のコーディングセッションを開始します
 
-デスクトップアプリは、グラフィカルインターフェース付きの Claude Code を提供します。ビジュアル diff レビュー、ライブアプリプレビュー、GitHub PR 監視と自動マージ、Git worktree 分離による並列セッション、スケジュール済みタスク、リモートでタスクを実行する機能があります。ターミナルは不要です。
+デスクトップアプリは、複数のセッションを並行して実行するために構築されたグラフィカルインターフェース付きの Claude Code を提供します。並列作業を管理するためのサイドバー、統合ターミナルとファイルエディター付きのドラッグアンドドロップレイアウト、ビジュアル diff レビュー、ライブアプリプレビュー、自動マージ機能付きの GitHub PR 監視、スケジュール済みタスクがあります。ターミナルは不要です。
 
-このページでは、アプリのインストールと最初のセッションの開始について説明します。既にセットアップが完了している場合は、[Claude Code Desktop を使用する](/ja/desktop)で完全なリファレンスを参照してください。
+<CardGroup cols={2}>
+  <Card title="Download for macOS" icon="apple" href="https://claude.ai/api/desktop/darwin/universal/dmg/latest/redirect?utm_source=claude_code&utm_medium=docs">
+    Universal build for Intel and Apple Silicon
+  </Card>
+
+  <Card title="Download for Windows" icon="windows" href="https://claude.ai/api/desktop/win32/x64/setup/latest/redirect?utm_source=claude_code&utm_medium=docs">
+    For x64 processors
+  </Card>
+</CardGroup>
 
-<Frame>
-  <img src="https://mintlify.s3.us-west-1.amazonaws.com/claude-code/images/desktop-code-tab-light.png" className="block dark:hidden" alt="Code タブが選択されている Claude Code Desktop インターフェースを示しており、プロンプトボックス、権限モードセレクター（'Ask permissions'に設定）、モデルピッカー、フォルダセレクター、Local environment オプションが表示されています" />
+For Windows ARM64, download the [ARM64 installer](https://claude.ai/api/desktop/win32/arm64/setup/latest/redirect?utm_source=claude_code\&utm_medium=docs). Linux is not supported.
+
+<Note>
+  Claude Code には [Pro、Max、Team、または Enterprise サブスクリプション](https://claude.com/pricing?utm_source=claude_code\&utm_medium=docs\&utm_content=desktop_quickstart_pricing)が必要です。
+</Note>
 
-  <img src="https://mintlify.s3.us-west-1.amazonaws.com/claude-code/images/desktop-code-tab-dark.png" className="hidden dark:block" alt="ダークモードの Claude Code Desktop インターフェースを示しており、Code タブが選択されている状態で、プロンプトボックス、権限モードセレクター（'Ask permissions'に設定）、モデルピッカー、フォルダセレクター、Local environment オプションが表示されています" />
```

</details>

<details>
<summary>env-vars-ja.md</summary>

```diff
diff --git a/docs-ja/pages/env-vars-ja.md b/docs-ja/pages/env-vars-ja.md
index 234f9f2..c176b23 100644
--- a/docs-ja/pages/env-vars-ja.md
+++ b/docs-ja/pages/env-vars-ja.md
@@ -9,188 +9,211 @@
 Claude Code は、その動作を制御するために以下の環境変数をサポートしています。`claude` を起動する前にシェルで設定するか、[`settings.json`](/ja/settings#available-settings) の `env` キーで設定して、すべてのセッションに適用するか、チーム全体にロールアウトしてください。
 
-| 変数                                                      | 目的                                                                                                                                                                                                                                                                                                                                                                               |
-| :------------------------------------------------------ | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
-| `ANTHROPIC_API_KEY`                                     | `X-Api-Key` ヘッダーとして送信される API キー。設定されている場合、ログインしていても Claude Pro、Max、Team、または Enterprise サブスクリプションの代わりにこのキーが使用されます。非対話モード（`-p`）では、キーが存在する場合は常に使用されます。対話モードでは、キーがサブスクリプションをオーバーライドする前に一度承認するよう求められます。代わりにサブスクリプションを使用するには、`unset ANTHROPIC_API_KEY` を実行してください                                                                                                                       |
-| `ANTHROPIC_AUTH_TOKEN`                                  | `Authorization` ヘッダーのカスタム値（ここで設定した値には `Bearer ` が接頭辞として付けられます）                                                                                                                                                                                                                                                                                                                   |
-| `ANTHROPIC_BASE_URL`                                    | API エンドポイントをオーバーライドして、プロキシまたはゲートウェイを通じてリクエストをルーティングします。ファーストパーティ以外のホストに設定されている場合、[MCP ツール検索](/ja/mcp#scale-with-mcp-tool-search) はデフォルトで無効になります。プロキシが `tool_reference` ブロックを転送する場合は、`ENABLE_TOOL_SEARCH=true` を設定してください                                                                                                                                                          |
-| `ANTHROPIC_BEDROCK_BASE_URL`                            | Bedrock エンドポイント URL をオーバーライドします。カスタム Bedrock エンドポイントを使用する場合、または [LLM ゲートウェイ](/ja/llm-gateway) を通じてルーティングする場合に使用します。[Amazon Bedrock](/ja/amazon-bedrock) を参照してください                                                                                                                                                                                                                |
-| `ANTHROPIC_BETAS`                                       | API リクエストに含める追加の `anthropic-beta` ヘッダー値のカンマ区切りリスト。Claude Code は既に必要なベータヘッダーを送信しています。Claude Code がネイティブサポートを追加する前に、[Anthropic API ベータ](https://platform.claude.com/docs/en/api/beta-headers) にオプトインするために使用します。API キー認証が必要な [`--betas` フラグ](/ja/cli-reference#cli-flags) とは異なり、この変数は Claude.ai サブスクリプションを含むすべての認証方法で機能します                                                          |
-| `ANTHROPIC_CUSTOM_HEADERS`                              | リクエストに追加するカスタムヘッダー（`Name: Value` 形式、複数のヘッダーの場合は改行で区切られます）                                                                                                                                                                                                                                                                                                                        |
-| `ANTHROPIC_CUSTOM_MODEL_OPTION`                         | `/model` ピッカーにカスタムエントリとして追加するモデル ID。組み込みエイリアスを置き換えずに、非標準またはゲートウェイ固有のモデルを選択可能にするために使用します。[モデル設定](/ja/model-config#add-a-custom-model-option) を参照してください                                                                                                                                                                                                                            |
-| `ANTHROPIC_CUSTOM_MODEL_OPTION_DESCRIPTION`             | `/model` ピッカーのカスタムモデルエントリの表示説明。設定されていない場合、デフォルトは `Custom model (<model-id>)` です                                                                                                                                                                                                                                                                                                  |
-| `ANTHROPIC_CUSTOM_MODEL_OPTION_NAME`                    | `/model` ピッカーのカスタムモデルエントリの表示名。設定されていない場合、デフォルトはモデル ID です                                                                                                                                                                                                                                                                                                                         |
-| `ANTHROPIC_DEFAULT_HAIKU_MODEL`                         | [モデル設定](/ja/model-config#environment-variables) を参照してください                                                                                                                                                                                                                                                                                                                        |
-| `ANTHROPIC_DEFAULT_HAIKU_MODEL_DESCRIPTION`             | [モデル設定](/ja/model-config#customize-pinned-model-display-and-capabilities) を参照してください                                                                                                                                                                                                                                                                                              |
-| `ANTHROPIC_DEFAULT_HAIKU_MODEL_NAME`                    | [モデル設定](/ja/model-config#customize-pinned-model-display-and-capabilities) を参照してください                                                                                                                                                                                                                                                                                              |
-| `ANTHROPIC_DEFAULT_HAIKU_MODEL_SUPPORTED_CAPABILITIES`  | [モデル設定](/ja/model-config#customize-pinned-model-display-and-capabilities) を参照してください                                                                                                                                                                                                                                                                                              |
-| `ANTHROPIC_DEFAULT_OPUS_MODEL`                          | [モデル設定](/ja/model-config#environment-variables) を参照してください                                                                                                                                                                                                                                                                                                                        |
-| `ANTHROPIC_DEFAULT_OPUS_MODEL_DESCRIPTION`              | [モデル設定](/ja/model-config#customize-pinned-model-display-and-capabilities) を参照してください                                                                                                                                                                                                                                                                                              |
-| `ANTHROPIC_DEFAULT_OPUS_MODEL_NAME`                     | [モデル設定](/ja/model-config#customize-pinned-model-display-and-capabilities) を参照してください                                                                                                                                                                                                                                                                                              |
-| `ANTHROPIC_DEFAULT_OPUS_MODEL_SUPPORTED_CAPABILITIES`   | [モデル設定](/ja/model-config#customize-pinned-model-display-and-capabilities) を参照してください                                                                                                                                                                                                                                                                                              |
-| `ANTHROPIC_DEFAULT_SONNET_MODEL`                        | [モデル設定](/ja/model-config#environment-variables) を参照してください                                                                                                                                                                                                                                                                                                                        |
-| `ANTHROPIC_DEFAULT_SONNET_MODEL_DESCRIPTION`            | [モデル設定](/ja/model-config#customize-pinned-model-display-and-capabilities) を参照してください                                                                                                                                                                                                                                                                                              |
-| `ANTHROPIC_DEFAULT_SONNET_MODEL_NAME`                   | [モデル設定](/ja/model-config#customize-pinned-model-display-and-capabilities) を参照してください                                                                                                                                                                                                                                                                                              |
-| `ANTHROPIC_DEFAULT_SONNET_MODEL_SUPPORTED_CAPABILITIES` | [モデル設定](/ja/model-config#customize-pinned-model-display-and-capabilities) を参照してください                                                                                                                                                                                                                                                                                              |
```

</details>

<!-- UPDATE_LOG_END -->
