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
<summary>2026-02-06</summary>

**変更ファイル:**

```
 docs-ja/pages/agent-teams-en.md           | 380 ------------------------------
 docs-ja/pages/changelog.md                |  24 ++
 docs-ja/pages/features-overview-en.md     | 278 ----------------------
 docs-ja/pages/how-claude-code-works-en.md | 240 -------------------
 docs-ja/pages/permissions-en.md           | 258 --------------------
 5 files changed, 24 insertions(+), 1156 deletions(-)
```

**削除:**


<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index 287e824..d1f1f91 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,28 @@
 # Changelog
 
+## 2.1.34
+
+- Fixed a crash when agent teams setting changed between renders
+- Fixed a bug where commands excluded from sandboxing (via `sandbox.excludedCommands` or `dangerouslyDisableSandbox`) could bypass the Bash ask permission rule when `autoAllowBashIfSandboxed` was enabled
+
+## 2.1.33
+
+- Fixed agent teammate sessions in tmux to send and receive messages
+- Fixed warnings about agent teams not being available on your current plan
+- Added `TeammateIdle` and `TaskCompleted` hook events for multi-agent workflows
+- Added support for restricting which sub-agents can be spawned via `Task(agent_type)` syntax in agent "tools" frontmatter
+- Added `memory` frontmatter field support for agents, enabling persistent memory with `user`, `project`, or `local` scope
+- Added plugin name to skill descriptions and `/skills` menu for better discoverability
+- Fixed an issue where submitting a new message while the model was in extended thinking would interrupt the thinking phase
+- Fixed an API error that could occur when aborting mid-stream, where whitespace text combined with a thinking block would bypass normalization and produce an invalid request
+- Fixed API proxy compatibility issue where 404 errors on streaming endpoints no longer triggered non-streaming fallback
+- Fixed an issue where proxy settings configured via `settings.json` environment variables were not applied to WebFetch and other HTTP requests on the Node.js build
+- Fixed `/resume` session picker showing raw XML markup instead of clean titles for sessions started with slash commands
+- Improved error messages for API connection failures — now shows specific cause (e.g., ECONNREFUSED, SSL errors) instead of generic "Connection error"
+- Errors from invalid managed settings are now surfaced
+- VSCode: Added support for remote sessions, allowing OAuth users to browse and resume sessions from claude.ai
+- VSCode: Added git branch and message count to the session picker, with support for searching by branch name
+- VSCode: Fixed scroll-to-bottom under-scrolling on initial session load and session switch
```

</details>

</details>


<details>
<summary>2026-02-06</summary>

**変更ファイル:**

```
 docs-ja/pages/best-practices-ja.md      | 338 +++++++++---------
 docs-ja/pages/checkpointing-ja.md       |  50 +--
 docs-ja/pages/cli-reference-ja.md       | 127 +++----
 docs-ja/pages/common-workflows-ja.md    | 138 ++++---
 docs-ja/pages/data-usage-ja.md          |  87 ++---
 docs-ja/pages/headless-ja.md            |  85 +++--
 docs-ja/pages/model-config-ja.md        | 143 +++++---
 docs-ja/pages/output-styles-ja.md       |  44 +--
 docs-ja/pages/plugin-marketplaces-ja.md | 329 ++++++++++-------
 docs-ja/pages/plugins-ja.md             | 208 ++++++-----
 docs-ja/pages/plugins-reference-ja.md   | 460 ++++++++++++------------
 docs-ja/pages/settings-ja.md            | 464 ++++++++++++------------
 docs-ja/pages/sub-agents-ja.md          | 614 +++++++++++++++++---------------
 13 files changed, 1622 insertions(+), 1465 deletions(-)
```

**新規追加:**


<details>
<summary>best-practices-ja.md</summary>

```diff
diff --git a/docs-ja/pages/best-practices-ja.md b/docs-ja/pages/best-practices-ja.md
index 94dcc00..62335da 100644
--- a/docs-ja/pages/best-practices-ja.md
+++ b/docs-ja/pages/best-practices-ja.md
@@ -9,17 +9,17 @@
 Claude Code は agentic coding 環境です。質問に答えて待つチャットボットとは異なり、Claude Code はファイルを読み取り、コマンドを実行し、変更を加え、あなたが見守ったり、方向を変えたり、完全に任せたりしながら、自律的に問題を解決できます。
 
-これはあなたの作業方法を変えます。自分でコードを書いて Claude にレビューしてもらう代わりに、やりたいことを説明すると Claude がそれをどのように構築するかを考え出します。Claude は探索し、計画し、実装します。
+これはあなたの作業方法を変えます。自分でコードを書いて Claude にレビューしてもらう代わりに、何をしたいかを説明すると、Claude がそれをどのように構築するかを考え出します。Claude は探索し、計画し、実装します。
 
 しかし、この自律性にも学習曲線があります。Claude は理解する必要がある特定の制約の中で動作します。
 
-このガイドでは、Anthropic の内部チームと様々なコードベース、言語、環境で Claude Code を使用しているエンジニアの間で効果的であることが証明されたパターンについて説明します。agentic ループがどのように機能するかについては、[Claude Code の仕組み](/ja/how-claude-code-works)を参照してください。
+このガイドでは、Anthropic の内部チームと、様々なコードベース、言語、環境で Claude Code を使用しているエンジニアの間で効果的であることが証明されたパターンについて説明します。agentic ループがどのように機能するかについては、[Claude Code の仕組み](/ja/how-claude-code-works)を参照してください。
 
 ***
 
-ほとんどのベストプラクティスは 1 つの制約に基づいています。Claude のコンテキストウィンドウはすぐにいっぱいになり、満杯になるにつれてパフォーマンスが低下します。
+ほとんどのベストプラクティスは 1 つの制約に基づいています。Claude のコンテキストウィンドウはすぐにいっぱいになり、いっぱいになるにつれてパフォーマンスが低下します。
 
-Claude のコンテキストウィンドウは、すべてのメッセージ、Claude が読み取ったすべてのファイル、すべてのコマンド出力を含む、会話全体を保持します。ただし、これはすぐにいっぱいになる可能性があります。単一のデバッグセッションまたはコードベース探索でも、数万トークンが生成および消費される可能性があります。
+Claude のコンテキストウィンドウは、すべてのメッセージ、Claude が読み取ったすべてのファイル、およびすべてのコマンド出力を含む、会話全体を保持します。ただし、これはすぐにいっぱいになる可能性があります。単一のデバッグセッションまたはコードベース探索でも、数万のトークンを生成および消費する可能性があります。
 
-これは重要です。LLM のパフォーマンスはコンテキストが満杯になるにつれて低下するためです。コンテキストウィンドウがいっぱいになりかけると、Claude は以前の指示を「忘れる」か、より多くの間違いを犯す可能性があります。コンテキストウィンドウは管理する最も重要なリソースです。トークン使用量を削減するための詳細な戦略については、[トークン使用量を削減する](/ja/costs#reduce-token-usage)を参照してください。
+これは重要です。LLM のパフォーマンスはコンテキストがいっぱいになるにつれて低下するためです。コンテキストウィンドウがいっぱいになりかけると、Claude は以前の指示を「忘れる」か、より多くの間違いを犯す可能性があります。コンテキストウィンドウは管理する最も重要なリソースです。トークン使用量を削減するための詳細な戦略については、[トークン使用量を削減する](/ja/costs#reduce-token-usage)を参照してください。
 
 ***
@@ -28,8 +28,8 @@ Claude のコンテキストウィンドウは、すべてのメッセージ、C
 
 <Tip>
```

</details>

<details>
<summary>checkpointing-ja.md</summary>

```diff
diff --git a/docs-ja/pages/checkpointing-ja.md b/docs-ja/pages/checkpointing-ja.md
index fbd5ccb..32f841d 100644
--- a/docs-ja/pages/checkpointing-ja.md
+++ b/docs-ja/pages/checkpointing-ja.md
@@ -3,43 +3,43 @@
 > Use this file to discover all available pages before exploring further.
 
-# チェックポイント
+# Checkpointing
 
-> Claudeの編集を自動的に追跡し、巻き戻して、不要な変更から素早く復旧します。
+> Claude の編集を自動的に追跡し、不要な変更から素早く復旧するために以前の状態に巻き戻します。
 
-Claude Codeは、作業中にClaudeのファイル編集を自動的に追跡し、変更を素早く元に戻したり、問題が発生した場合に以前の状態に巻き戻したりできます。
+Claude Code は、作業中に Claude のファイル編集を自動的に追跡し、何か問題が発生した場合に変更を素早く取り消し、以前の状態に巻き戻すことができます。
 
-## チェックポイントの仕組み
+## Checkpointing の仕組み
 
-Claude Codeで作業する際、チェックポイント機能は各編集の前にコードの状態を自動的にキャプチャします。このセーフティネットにより、野心的で大規模なタスクを実行する際に、いつでも以前のコード状態に戻ることができるという安心感を持って作業できます。
+Claude と作業する際、checkpointing は各編集の前にコードの状態を自動的にキャプチャします。このセーフティネットにより、野心的で大規模なタスクを実行する際に、いつでも以前のコード状態に戻ることができるという安心感を持って作業できます。
 
 ### 自動追跡
 
-Claude Codeはファイル編集ツールによるすべての変更を追跡します：
+Claude Code は、ファイル編集ツールによって行われたすべての変更を追跡します：
 
-* ユーザープロンプトごとに新しいチェックポイントが作成されます
-* チェックポイントはセッション間で保持されるため、再開した会話でアクセスできます
-* セッション後30日で自動的にクリーンアップされます（設定可能）
```

</details>

<details>
<summary>cli-reference-ja.md</summary>

```diff
diff --git a/docs-ja/pages/cli-reference-ja.md b/docs-ja/pages/cli-reference-ja.md
index 4eb24b2..c8ee375 100644
--- a/docs-ja/pages/cli-reference-ja.md
+++ b/docs-ja/pages/cli-reference-ja.md
@@ -23,58 +23,59 @@
 ## CLI フラグ
 
-これらのコマンドラインフラグを使用して Claude Code の動作をカスタマイズします。
-
-| フラグ                                    | 説明                                                                                                                                            | 例                                                                                                  |
-| :------------------------------------- | :-------------------------------------------------------------------------------------------------------------------------------------------- | :------------------------------------------------------------------------------------------------- |
-| `--add-dir`                            | Claude がアクセスできる追加の作業ディレクトリを追加します（各パスがディレクトリとして存在することを検証します）                                                                                   | `claude --add-dir ../apps ../lib`                                                                  |
-| `--agent`                              | 現在のセッション用のエージェントを指定します（`agent` 設定をオーバーライドします）                                                                                                 | `claude --agent my-custom-agent`                                                                   |
-| `--agents`                             | カスタム [subagents](/ja/sub-agents) を JSON 経由で動的に定義します（形式については以下を参照）                                                                             | `claude --agents '{"reviewer":{"description":"Reviews code","prompt":"You are a code reviewer"}}'` |
-| `--allow-dangerously-skip-permissions` | 権限バイパスをオプションとして有効にします。すぐには有効化しません。`--permission-mode` と組み合わせることができます（注意して使用してください）                                                            | `claude --permission-mode plan --allow-dangerously-skip-permissions`                               |
-| `--allowedTools`                       | 権限を求めずに実行するツール。パターンマッチングについては [権限ルール構文](/ja/settings#permission-rule-syntax) を参照してください。利用可能なツールを制限するには、代わりに `--tools` を使用してください               | `"Bash(git log *)" "Bash(git diff *)" "Read"`                                                      |
-| `--append-system-prompt`               | デフォルトシステムプロンプトの末尾にカスタムテキストを追加します（インタラクティブモードと出力モードの両方で機能します）                                                                                  | `claude --append-system-prompt "Always use TypeScript"`                                            |
-| `--append-system-prompt-file`          | ファイルから追加のシステムプロンプトテキストを読み込み、デフォルトプロンプトに追加します（出力モードのみ）                                                                                         | `claude -p --append-system-prompt-file ./extra-rules.txt "query"`                                  |
-| `--betas`                              | API リクエストに含めるベータヘッダー（API キーユーザーのみ）                                                                                                            | `claude --betas interleaved-thinking`                                                              |
-| `--chrome`                             | Web 自動化とテスト用の [Chrome ブラウザ統合](/ja/chrome) を有効にします                                                                                             | `claude --chrome`                                                                                  |
-| `--continue`, `-c`                     | 現在のディレクトリで最新の会話を読み込みます                                                                                                                        | `claude --continue`                                                                                |
-| `--dangerously-skip-permissions`       | すべての権限プロンプトをスキップします（注意して使用してください）                                                                                                             | `claude --dangerously-skip-permissions`                                                            |
-| `--debug`                              | デバッグモードを有効にします。オプションのカテゴリフィルタリング付き（例：`"api,hooks"` または `"!statsig,!file"`）                                                                    | `claude --debug "api,mcp"`                                                                         |
-| `--disable-slash-commands`             | このセッションのすべてのスキルとスラッシュコマンドを無効にします                                                                                                              | `claude --disable-slash-commands`                                                                  |
-| `--disallowedTools`                    | モデルのコンテキストから削除され、使用できないツール                                                                                                                    | `"Bash(git log *)" "Bash(git diff *)" "Edit"`                                                      |
-| `--fallback-model`                     | デフォルトモデルがオーバーロードされた場合、指定されたモデルへの自動フォールバックを有効にします（出力モードのみ）                                                                                     | `claude -p --fallback-model sonnet "query"`                                                        |
-| `--fork-session`                       | 再開時に、元のセッション ID を再利用する代わりに新しいセッション ID を作成します（`--resume` または `--continue` と共に使用）                                                               | `claude --resume abc123 --fork-session`                                                            |
-| `--from-pr`                            | 特定の GitHub PR にリンクされたセッションを再開します。PR 番号または URL を受け入れます。セッションは `gh pr create` 経由で作成されたときに自動的にリンクされます                                            | `claude --from-pr 123`                                                                             |
-| `--ide`                                | スタートアップ時に、正確に 1 つの有効な IDE が利用可能な場合、自動的に IDE に接続します                                                                                            | `claude --ide`                                                                                     |
-| `--init`                               | 初期化フックを実行してインタラクティブモードを開始します                                                                                                                  | `claude --init`                                                                                    |
```

</details>

<details>
<summary>common-workflows-ja.md</summary>

```diff
diff --git a/docs-ja/pages/common-workflows-ja.md b/docs-ja/pages/common-workflows-ja.md
index 6271b9d..ecad25a 100644
--- a/docs-ja/pages/common-workflows-ja.md
+++ b/docs-ja/pages/common-workflows-ja.md
@@ -5,16 +5,16 @@
 # 一般的なワークフロー
 
-> Claude Code でコードベースの探索、バグ修正、リファクタリング、テスト、その他の日常的なタスクを行うためのステップバイステップガイド。
+> Claude Code でコードベースの探索、バグ修正、リファクタリング、テスト、その他の日常的なタスクを実行するためのステップバイステップガイド。
 
-このページでは、日常的な開発のための実践的なワークフローについて説明します。コードベースの探索、デバッグ、リファクタリング、テストの作成、PR の作成、セッション管理などです。各セクションには、自分のプロジェクトに適応できるプロンプトの例が含まれています。より高度なパターンとヒントについては、[ベストプラクティス](/ja/best-practices)を参照してください。
+このページでは、日常的な開発のための実践的なワークフローについて説明します。未知のコードの探索、デバッグ、リファクタリング、テストの作成、PR の作成、セッションの管理などです。各セクションには、自分のプロジェクトに適応させることができるプロンプトの例が含まれています。より高度なパターンとヒントについては、[ベストプラクティス](/ja/best-practices)を参照してください。
 
 ## 新しいコードベースを理解する
 
-### コードベースの概要を素早く取得する
+### コードベースの概要を素早く把握する
 
 新しいプロジェクトに参加したばかりで、その構造を素早く理解する必要があるとします。
 
 <Steps>
-  <Step title="プロジェクトルートディレクトリに移動する">
+  <Step title="プロジェクトのルートディレクトリに移動する">
     ```bash  theme={null}
     cd /path/to/project 
@@ -28,5 +28,5 @@
   </Step>
 
-  <Step title="高レベルの概要をリクエストする">
+  <Step title="高レベルの概要を要求する">
```

</details>

<details>
<summary>data-usage-ja.md</summary>

```diff
diff --git a/docs-ja/pages/data-usage-ja.md b/docs-ja/pages/data-usage-ja.md
index 14660b3..a135b1d 100644
--- a/docs-ja/pages/data-usage-ja.md
+++ b/docs-ja/pages/data-usage-ja.md
@@ -5,5 +5,5 @@
 # データ使用
 
-> Anthropicのデータ使用ポリシーについて学ぶ
+> Anthropic の Claude のデータ使用ポリシーについて学習します
 
 ## データポリシー
@@ -11,83 +11,86 @@
 ### データトレーニングポリシー
 
-**コンシューマーユーザー（Free、Pro、Maxプラン）**：
-将来のClaudeモデルの改善のためにデータを使用することを許可するかどうかを選択できます。この設定がオンの場合、Free、Pro、Maxアカウントからのデータを使用して新しいモデルをトレーニングします（これらのアカウントからClaude Codeを使用する場合を含む）。
+**コンシューマーユーザー（Free、Pro、Max プラン）**：
+将来の Claude モデルの改善のためにデータを使用することを許可するかどうかを選択できます。この設定がオンの場合、Free、Pro、Max アカウントからのデータを使用して新しいモデルをトレーニングします（これらのアカウントから Claude Code を使用する場合を含む）。
 
-**商用ユーザー**：（TeamおよびEnterpriseプラン、API、サードパーティプラットフォーム、およびClaude Gov）既存のポリシーを維持します。Anthropicは、商用条件の下でClaude Codeに送信されたコードまたはプロンプトを使用して生成モデルをトレーニングしません。ただし、顧客がモデル改善のためにデータを提供することを選択した場合は除きます（例えば、[Developer Partner Program](https://support.claude.com/ja/articles/11174108-about-the-development-partner-program)）。
+**商用ユーザー**：（Team および Enterprise プラン、API、サードパーティプラットフォーム、Claude Gov）既存のポリシーを維持します。Anthropic は、商用条件の下で Claude Code に送信されたコードまたはプロンプトを使用して生成モデルをトレーニングしません。ただし、カスタマーがモデル改善のためにデータを提供することを選択した場合は除きます（例えば、[Developer Partner Program](https://support.claude.com/ja/articles/11174108-about-the-development-partner-program)）。
 
 ### Development Partner Program
 
-[Development Partner Program](https://support.claude.com/ja/articles/11174108-about-the-development-partner-program)などを通じて、トレーニング用の資料を提供する方法に明示的にオプトインした場合、提供された資料を使用してモデルをトレーニングする可能性があります。組織の管理者は、組織のDevelopment Partner Programに明示的にオプトインできます。このプログラムはAnthropicファーストパーティAPIでのみ利用可能であり、BedrockまたはVertexユーザーには利用できないことに注意してください。
+[Development Partner Program](https://support.claude.com/ja/articles/11174108-about-the-development-partner-program) などを通じて、トレーニング用の資料を提供する方法に明示的にオプトインした場合、提供された資料を使用してモデルをトレーニングする可能性があります。組織管理者は、組織の Development Partner Program に明示的にオプトインできます。このプログラムは Anthropic ファーストパーティ API でのみ利用可能であり、Bedrock または Vertex ユーザーは利用できないことに注意してください。
 
-### `/bug`コマンドを使用したフィードバック
+### `/bug` コマンドを使用したフィードバック
 
```

</details>

<details>
<summary>headless-ja.md</summary>

```diff
diff --git a/docs-ja/pages/headless-ja.md b/docs-ja/pages/headless-ja.md
index d06b7af..46ffae3 100644
--- a/docs-ja/pages/headless-ja.md
+++ b/docs-ja/pages/headless-ja.md
@@ -3,15 +3,15 @@
 > Use this file to discover all available pages before exploring further.
 
-# Claude Codeをプログラムで実行する
+# Claude Code をプログラムで実行する
 
-> Agent SDKを使用して、CLI、Python、またはTypeScriptからClaudeコードをプログラムで実行します。
+> Agent SDK を使用して、CLI、Python、または TypeScript からプログラムで Claude Code を実行します。
 
-[Agent SDK](https://platform.claude.com/docs/ja/agent-sdk/overview)は、Claude Codeを支える同じツール、エージェントループ、およびコンテキスト管理を提供します。スクリプトとCI/CDのためのCLIとして、または完全なプログラムによる制御のための[Python](https://platform.claude.com/docs/ja/agent-sdk/python)および[TypeScript](https://platform.claude.com/docs/ja/agent-sdk/typescript)パッケージとして利用できます。
+[Agent SDK](https://platform.claude.com/docs/ja/agent-sdk/overview) は、Claude Code を支える同じツール、エージェントループ、およびコンテキスト管理を提供します。スクリプトと CI/CD 用の CLI として、または完全なプログラムによる制御のための [Python](https://platform.claude.com/docs/ja/agent-sdk/python) および [TypeScript](https://platform.claude.com/docs/ja/agent-sdk/typescript) パッケージとして利用できます。
 
 <Note>
-  CLIは以前「ヘッドレスモード」と呼ばれていました。`-p`フラグとすべてのCLIオプションは同じように機能します。
+  CLI は以前「headless mode」と呼ばれていました。`-p` フラグとすべての CLI オプションは同じように機能します。
 </Note>
 
-CLIからClaudeコードをプログラムで実行するには、プロンプトと任意の[CLIオプション](/ja/cli-reference)を指定して`-p`を渡します：
+CLI からプログラムで Claude Code を実行するには、プロンプトと任意の [CLI オプション](/ja/cli-reference) を指定して `-p` を渡します。
 
 ```bash  theme={null}
@@ -19,15 +19,15 @@ claude -p "Find and fix the bug in auth.py" --allowedTools "Read,Edit,Bash"
 ```
 
-このページではCLI（`claude -p`）経由でAgent SDKを使用することについて説明しています。構造化された出力、ツール承認コールバック、およびネイティブメッセージオブジェクトを備えたPythonおよびTypeScript SDKパッケージについては、[完全なAgent SDKドキュメント](https://platform.claude.com/docs/ja/agent-sdk/overview)を参照してください。
+このページでは、CLI（`claude -p`）経由で Agent SDK を使用することについて説明しています。構造化された出力、ツール承認コールバック、およびネイティブメッセージオブジェクトを備えた Python および TypeScript SDK パッケージについては、[完全な Agent SDK ドキュメント](https://platform.claude.com/docs/ja/agent-sdk/overview) を参照してください。
```

</details>

*...以降省略*

</details>

<!-- UPDATE_LOG_END -->
