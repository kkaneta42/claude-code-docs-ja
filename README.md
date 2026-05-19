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
<summary>2026-05-19</summary>

**変更ファイル:**

```
 docs-ja/pages/agent-view-ja.md          | 115 +++++++++++++++++++++++---------
 docs-ja/pages/cli-reference-ja.md       |  57 ++++++++--------
 docs-ja/pages/code-review-ja.md         |   4 +-
 docs-ja/pages/commands-ja.md            |   6 +-
 docs-ja/pages/debug-your-config-ja.md   |  36 +++++-----
 docs-ja/pages/desktop-ja.md             |   3 +-
 docs-ja/pages/discover-plugins-ja.md    |   4 +-
 docs-ja/pages/env-vars-ja.md            |  21 +++---
 docs-ja/pages/errors-ja.md              |  16 +++--
 docs-ja/pages/fast-mode-ja.md           |  56 +++-------------
 docs-ja/pages/features-overview-ja.md   |   4 +-
 docs-ja/pages/hooks-guide-ja.md         |   8 ++-
 docs-ja/pages/hooks-ja.md               |   4 +-
 docs-ja/pages/mcp-ja.md                 |   4 +-
 docs-ja/pages/model-config-ja.md        |  54 +++++++--------
 docs-ja/pages/overview-ja.md            |   2 +-
 docs-ja/pages/permission-modes-ja.md    |  26 ++++----
 docs-ja/pages/plugin-dependencies-ja.md |  24 +++++++
 docs-ja/pages/plugin-marketplaces-ja.md |   3 +-
 docs-ja/pages/plugins-reference-ja.md   |  13 ++--
 docs-ja/pages/remote-control-ja.md      |   2 +-
 docs-ja/pages/routines-ja.md            |   2 +-
 docs-ja/pages/scheduled-tasks-ja.md     |   2 +-
 docs-ja/pages/settings-ja.md            |  33 ++++-----
 docs-ja/pages/skills-ja.md              |  10 +--
 docs-ja/pages/statusline-ja.md          |   1 +
 docs-ja/pages/sub-agents-ja.md          |  32 ++++++++-
 docs-ja/pages/tools-reference-ja.md     |   3 +-
 docs-ja/pages/ultrareview-ja.md         |   2 +-
 29 files changed, 322 insertions(+), 225 deletions(-)
```

<details>
<summary>agent-view-ja.md</summary>

```diff
diff --git a/docs-ja/pages/agent-view-ja.md b/docs-ja/pages/agent-view-ja.md
index bbb89ed..9c0d473 100644
--- a/docs-ja/pages/agent-view-ja.md
+++ b/docs-ja/pages/agent-view-ja.md
@@ -73,7 +73,13 @@ Claude が複数の独立したタスクに対して、あなたが毎ステッ
 `claude agents` を実行してエージェントビューを開きます。ターミナル全体を占有し、状態でグループ化されたすべてのセッションをリストします。ピン留めされたセッションと入力が必要なセッションが上部に表示されます。各行はセッションの名前、現在のアクティビティ、最後に変更されてからの経過時間を表示します。
 
-リストはすべてのプロジェクト全体で開始したすべてのバックグラウンドセッションを表示します。1 つのリポジトリで作業しているセッションと別のワークツリーで作業している別のセッションの両方がここに表示されます。エージェントビューを開いたディレクトリに関係なく表示されます。他のターミナルで開いているインタラクティブセッションは、[バックグラウンドにする](#from-inside-a-session)までは表示されません。[Subagents](/ja/sub-agents) と [teammates](/ja/agent-teams) はセッションが生成しても個別の行としてリストされません。
+デフォルトでは、リストはすべてのプロジェクト全体で開始したすべてのバックグラウンドセッションを表示します。1 つのリポジトリで作業しているセッションと別のワークツリーで作業している別のセッションの両方がここに表示されます。エージェントビューを開いたディレクトリに関係なく表示されます。リストを 1 つのプロジェクトに絞り込むには、`--cwd` を渡します（Claude Code v2.1.141 以降が必要です）。
 
-ビューを 1 つのプロジェクトにスコープするには、`claude agents --cwd <path>` で起動します。そのディレクトリの下で開始されたセッションのみが表示されます。これには、そこからディスパッチされた [ワークツリー](/ja/worktrees) で実行されているセッションも含まれます。
+```bash theme={null}
+claude agents --cwd ~/projects/my-app
+```
+
+これはそのディレクトリの下で開始されたセッションのみを表示します。`~/projects/my-app/.claude/worktrees/` の下の [ワークツリーに移動した](#how-file-edits-are-isolated) セッションは、`~/projects/my-app` に属するものとしてカウントされます。
+
+他のターミナルで開いているインタラクティブセッションは、[バックグラウンドにする](#from-inside-a-session)までは表示されません。[Subagents](/ja/sub-agents) と [teammates](/ja/agent-teams) はセッションが生成しても個別の行としてリストされません。
 
 ```text theme={null}
@@ -118,7 +124,9 @@ Completed
 | `✢`                | [`/loop`](/ja/scheduled-tasks) セッションはイテレーション間でスリープしています。行は実行回数とカウントダウンを表示します |
 
+行の右端に表示される `●` は [プルリクエストステータス](#pull-request-status) インジケーターであり、状態アイコンの一部ではありません。その前の数字はセッションが開いたプルリクエストの数です。
+
 バックグラウンドセッションは作業を続けるためにターミナルを開く必要がありません。別の [スーパーバイザープロセス](#the-supervisor-process) がセッションを実行するため、エージェントビューを閉じたり、シェルを閉じたり、新しいインタラクティブセッションを開始したりしても、ディスパッチされた作業は続きます。
 
-セッション状態はディスク上に永続化され、自動更新とスーパーバイザー再起動を通じて保存されます。マシンがスリープまたはシャットダウンした場合、実行中のセッションは停止します。`claude respawn --all` で再開します。
+セッション状態はディスク上に永続化され、自動更新とスーパーバイザー再起動を通じて保存されます。セッションはマシンがスリープするときも保存されます。プロセスはウェイク時に再開され、スーパーバイザーはアイドルとして時間ギャップを扱う代わりにそれらに再接続します。シャットダウンはまだ実行中のセッションを停止します。[シャットダウン後にセッションが失敗として表示される](#sessions-show-as-failed-after-shutdown) を参照して、それらを復旧する方法を確認してください。
 
```

</details>

<details>
<summary>cli-reference-ja.md</summary>

```diff
diff --git a/docs-ja/pages/cli-reference-ja.md b/docs-ja/pages/cli-reference-ja.md
index 438c1b0..963b558 100644
--- a/docs-ja/pages/cli-reference-ja.md
+++ b/docs-ja/pages/cli-reference-ja.md
@@ -11,31 +11,32 @@
 これらのコマンドを使用して、セッションを開始し、コンテンツをパイプし、会話を再開し、更新を管理できます。
 
-| コマンド                            | 説明                                                                                                                                                                                                                                                                                                             | 例                                                           |
-| :------------------------------ | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :---------------------------------------------------------- |
-| `claude`                        | インタラクティブセッションを開始                                                                                                                                                                                                                                                                                               | `claude`                                                    |
-| `claude "query"`                | 初期プロンプト付きでインタラクティブセッションを開始                                                                                                                                                                                                                                                                                     | `claude "explain this project"`                             |
-| `claude -p "query"`             | SDK 経由でクエリを実行してから終了                                                                                                                                                                                                                                                                                            | `claude -p "explain this function"`                         |
-| `cat file \| claude -p "query"` | パイプされたコンテンツを処理                                                                                                                                                                                                                                                                                                 | `cat logs.txt \| claude -p "explain"`                       |
-| `claude -c`                     | 現在のディレクトリで最新の会話を続行                                                                                                                                                                                                                                                                                             | `claude -c`                                                 |
-| `claude -c -p "query"`          | SDK 経由で続行                                                                                                                                                                                                                                                                                                      | `claude -c -p "Check for type errors"`                      |
-| `claude -r "<session>" "query"` | セッション ID または名前でセッションを再開                                                                                                                                                                                                                                                                                        | `claude -r "auth-refactor" "Finish this PR"`                |
-| `claude update`                 | 最新バージョンに更新                                                                                                                                                                                                                                                                                                     | `claude update`                                             |
-| `claude install [version]`      | ネイティブバイナリをインストールまたは再インストールします。`2.1.118` のようなバージョン、または `stable` または `latest` を受け入れます。[特定のバージョンをインストール](/ja/setup#install-a-specific-version) を参照してください                                                                                                                                                          | `claude install stable`                                     |
-| `claude auth login`             | Anthropic アカウントにサインインします。`--email` を使用してメールアドレスを事前入力し、`--sso` を使用して SSO 認証を強制し、`--console` を使用して Claude サブスクリプションの代わりに Anthropic Console で API 使用料金をサインインできます                                                                                                                                                  | `claude auth login --console`                               |
-| `claude auth logout`            | Anthropic アカウントからログアウト                                                                                                                                                                                                                                                                                         | `claude auth logout`                                        |
-| `claude auth status`            | 認証ステータスを JSON として表示します。`--text` を使用して人間が読める形式で表示できます。ログイン済みの場合はコード 0 で終了し、ログインしていない場合は 1 で終了します                                                                                                                                                                                                                | `claude auth status`                                        |
-| `claude agents`                 | [エージェントビュー](/ja/agent-view) を開いて、並列バックグラウンドセッションを監視およびディスパッチします。`--cwd <path>` を使用して、そのディレクトリの下で開始されたセッションのみを表示します                                                                                                                                                                                             | `claude agents`                                             |
-| `claude attach <id>`            | このターミナルで [バックグラウンドセッション](/ja/agent-view#manage-sessions-from-the-shell) に接続します                                                                                                                                                                                                                                 | `claude attach 7c5dcf5d`                                    |
-| `claude auto-mode defaults`     | 組み込み [auto mode](/ja/permission-modes#eliminate-prompts-with-auto-mode) 分類器ルールを JSON として出力します。`claude auto-mode config` を使用して、設定が適用された有効な設定を確認してください                                                                                                                                                           | `claude auto-mode defaults > rules.json`                    |
-| `claude logs <id>`              | [バックグラウンドセッション](/ja/agent-view#manage-sessions-from-the-shell) からの最近の出力を出力します                                                                                                                                                                                                                                  | `claude logs 7c5dcf5d`                                      |
-| `claude mcp`                    | Model Context Protocol（MCP）サーバーを設定                                                                                                                                                                                                                                                                             | [Claude Code MCP ドキュメント](/ja/mcp) を参照してください。                |
-| `claude plugin`                 | Claude Code [plugins](/ja/plugins) を管理します。エイリアス：`claude plugins`。サブコマンドについては [plugin reference](/ja/plugins-reference#cli-commands-reference) を参照してください                                                                                                                                                        | `claude plugin install code-review@claude-plugins-official` |
-| `claude project purge [path]`   | プロジェクトのすべてのローカル Claude Code 状態を削除します：トランスクリプト、タスクリスト、デバッグログ、ファイル編集履歴、プロンプト履歴行、および `~/.claude.json` 内のプロジェクトエントリ。`[path]` を省略して、インタラクティブリストから選択します。フラグ：`--dry-run` でプレビュー、`-y`/`--yes` で確認をスキップ、`-i`/`--interactive` で各項目を確認、`--all` ですべてのプロジェクト。[ローカルデータをクリア](/ja/claude-directory#clear-local-data) を参照してください | `claude project purge ~/work/repo --dry-run`                |
-| `claude remote-control`         | [Remote Control](/ja/remote-control) サーバーを開始して、Claude.ai または Claude アプリから Claude Code を制御します。サーバーモード（ローカルインタラクティブセッションなし）で実行されます。[サーバーモードフラグ](/ja/remote-control#start-a-remote-control-session) を参照してください                                                                                                     | `claude remote-control --name "My Project"`                 |
-| `claude respawn <id>`           | 会話を保持したまま、停止した [バックグラウンドセッション](/ja/agent-view#manage-sessions-from-the-shell) を再開します。`--all` を使用してすべての停止したセッションを再開します                                                                                                                                                                                          | `claude respawn 7c5dcf5d`                                   |
```

</details>

<details>
<summary>code-review-ja.md</summary>

```diff
diff --git a/docs-ja/pages/code-review-ja.md b/docs-ja/pages/code-review-ja.md
index 080d8e9..eacd4b1 100644
--- a/docs-ja/pages/code-review-ja.md
+++ b/docs-ja/pages/code-review-ja.md
@@ -30,5 +30,5 @@ Claude を管理サービスではなく独自の CI インフラストラクチ
 管理者が組織の Code Review を[有効にする](#set-up-code-review)と、リポジトリの設定された動作に応じて、PR が開かれたとき、すべてのプッシュ時、または手動でリクエストされたときにレビューがトリガーされます。PR で `@claude review` と[コメントすると](#manually-trigger-reviews)、任意のモードでレビューが開始されます。
 
-レビューが実行されると、複数のエージェントが Anthropic インフラストラクチャ上で並行して diff と周囲のコードを分析します。各エージェントは異なるクラスの問題を探し、その後、検証ステップが候補を実際のコード動作に対してチェックして、偽陽性を除外します。結果は重複排除され、重大度でランク付けされ、問題が見つかった特定の行にインラインコメントとして投稿されます。問題が見つからない場合、Claude は PR に短い確認コメントを投稿します。
+レビューが実行されると、複数のエージェントが Anthropic インフラストラクチャ上で並行して diff と周囲のコードを分析します。各エージェントは異なるクラスの問題を探し、その後、検証ステップが候補を実際のコード動作に対してチェックして、偽陽性を除外します。結果は重複排除され、重大度でランク付けされ、問題が見つかった特定の行にインラインコメントとして投稿され、レビュー本文に概要が記載されます。問題が見つからない場合、Code Review は GitHub チェック実行を更新して、問題が検出されなかったことを表示します。Claude は PR に短い確認コメントを投稿することもあります。
 
 レビューはコストが PR のサイズと複雑さに応じてスケーリングされ、平均 20 分で完了します。管理者は[分析ダッシュボード](#view-usage)を通じてレビューアクティビティと支出を監視できます。
@@ -226,5 +226,5 @@ Important は、動作を壊す、データをリークする、またはロー
 ## 料金
 
-Code Review はトークン使用量に基づいて請求されます。各レビューは平均 \$15～25 のコストで、PR サイズ、コードベースの複雑さ、検証が必要な問題の数に応じてスケーリングされます。Code Review の使用は[extra usage](https://support.claude.com/en/articles/12429409-extra-usage-for-paid-claude-plans)を通じて個別に請求され、プランの含まれた使用量にはカウントされません。
+Code Review はトークン使用量に基づいて請求されます。各レビューは平均 \$15～25 のコストで、PR サイズ、コードベースの複雑さ、検証が必要な問題の数に応じてスケーリングされます。Code Review の使用は[usage credits](https://support.claude.com/ja/articles/12429409-extra-usage-for-paid-claude-plans)を通じて個別に請求され、プランの含まれた使用量にはカウントされません。
 
 選択するレビュートリガーは総コストに影響します：
```

</details>

<details>
<summary>commands-ja.md</summary>

```diff
diff --git a/docs-ja/pages/commands-ja.md b/docs-ja/pages/commands-ja.md
index 38f411a..a5efe68 100644
--- a/docs-ja/pages/commands-ja.md
+++ b/docs-ja/pages/commands-ja.md
@@ -61,7 +61,6 @@
 | `/doctor`                                       | Claude Code のインストールと設定を診断および検証します。結果はステータスアイコン付きで表示されます。`f` を押して Claude に報告された問題を修正させます                                                                                                                                                                                                                                                                                                                                                                                                                        |
 | `/effort [level\|auto]`                         | モデルの[努力レベル](/ja/model-config#adjust-effort-level)を設定します。`low`、`medium`、`high`、`xhigh`、または `max` を受け入れます。利用可能なレベルはモデルに依存し、`max` はセッションのみです。`auto` はモデルのデフォルトにリセットします。引数なしで、インタラクティブスライダーを開きます。左右矢印でレベルを選択し、`Enter` で適用します。現在の応答の完了を待たずに即座に有効になります                                                                                                                                                                                                                                                               |
-| `/exit`                                         | CLI を終了します。エイリアス: `/quit`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
+| `/exit`                                         | CLI を終了します。接続されている[バックグラウンドセッション](/ja/agent-view#attach-to-a-session)では、これはデタッチされ、セッションは実行を続けます。エイリアス: `/quit`                                                                                                                                                                                                                                                                                                                                                                                                 |
 | `/export [filename]`                            | 現在の会話をプレーンテキストとしてエクスポートします。ファイル名を指定すると、そのファイルに直接書き込みます。指定しない場合、クリップボードにコピーするか、ファイルに保存するダイアログを開きます                                                                                                                                                                                                                                                                                                                                                                                                              |
-| `/extra-usage`                                  | レート制限に達したときに作業を続行するための追加使用量を構成します                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
 | `/fast [on\|off]`                               | [高速モード](/ja/fast-mode)のオン/オフを切り替えます                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
 | `/feedback [report]`                            | Claude Code に関するフィードバックを送信します。エイリアス: `/bug`                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
@@ -122,7 +121,8 @@
 | `/tui [default\|fullscreen]`                    | ターミナル UI レンダラーを設定し、会話を保持したまま再起動します。`fullscreen` は[ちらつきなしの alt-screen レンダラー](/ja/fullscreen)を有効にします。引数なしで、アクティブなレンダラーを出力します                                                                                                                                                                                                                                                                                                                                                                                     |
 | `/ultraplan <prompt>`                           | [ultraplan](/ja/ultraplan) セッションで計画を作成し、ブラウザでレビューし、リモートで実行するか、ターミナルに送り返します                                                                                                                                                                                                                                                                                                                                                                                                                                     |
-| `/ultrareview [PR]`                             | [ultrareview](/ja/ultrareview) を使用してクラウドサンドボックスで深い複数エージェントコードレビューを実行します。Pro と Max に 3 つの無料実行が含まれ、その後は [extra usage](https://support.claude.com/en/articles/12429409-extra-usage-for-paid-claude-plans) が必要です                                                                                                                                                                                                                                                                                                   |
+| `/ultrareview [PR]`                             | [ultrareview](/ja/ultrareview) を使用してクラウドサンドボックスで深い複数エージェントコードレビューを実行します。Pro と Max に 3 つの無料実行が含まれ、その後は [usage credits](https://support.claude.com/en/articles/12429409-extra-usage-for-paid-claude-plans) が必要です                                                                                                                                                                                                                                                                                                 |
 | `/upgrade`                                      | アップグレードページを開いて、より高いプランティアに切り替えます                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
 | `/usage`                                        | セッションコスト、プラン使用制限、およびアクティビティ統計を表示します。サブスクリプション固有の詳細については、[コスト追跡ガイド](/ja/costs#using-the-%2Fusage-command)を参照してください。`/cost` と `/stats` はエイリアスです                                                                                                                                                                                                                                                                                                                                                                  |
+| `/usage-credits`                                | 制限に達したときに作業を続行するための usage credits を構成します。以前は `/extra-usage`                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
 | `/vim`                                          | {/* max-version: 2.1.91 */}v2.1.92 で削除。Vim と通常編集モード間を切り替えるには、`/config` → エディタモードを使用してください                                                                                                                                                                                                                                                                                                                                                                                                                      |
 | `/voice [hold\|tap\|off]`                       | [音声ディクテーション](/ja/voice-dictation)を切り替えるか、特定のモードで有効にします。Claude.ai アカウントが必要です                                                                                                                                                                                                                                                                                                                                                                                                                                    |
```

</details>

<details>
<summary>debug-your-config-ja.md</summary>

```diff
diff --git a/docs-ja/pages/debug-your-config-ja.md b/docs-ja/pages/debug-your-config-ja.md
index 846395c..5960e71 100644
--- a/docs-ja/pages/debug-your-config-ja.md
+++ b/docs-ja/pages/debug-your-config-ja.md
@@ -87,22 +87,22 @@ cd /tmp && CLAUDE_CONFIG_DIR=/tmp/claude-clean claude
 ほとんどの設定の問題は、小さな場所とシンタックスルールのセットに遡ります。バグを想定する前にこれらを確認してください：
 
-| 症状                                                         | 原因                                                                       | 修正                                                                                                                                                      |
-| :--------------------------------------------------------- | :----------------------------------------------------------------------- | :------------------------------------------------------------------------------------------------------------------------------------------------------ |
-| フックが発火しない                                                  | `matcher` が JSON 配列ではなく文字列である                                            | 複数のツールをマッチするために `\|` を含む単一の文字列を使用します。例えば `"Edit\|Write"` です。[マッチャーパターン](/ja/hooks#matcher-patterns) を参照してください。                                          |
-| フックが発火しない                                                  | `matcher` 値が小文字です。例えば `"bash"`                                           | マッチングは大文字と小文字を区別します。ツール名は大文字です：`Bash`、`Edit`、`Write`、`Read`。                                                                                            |
-| フックが発火しない                                                  | Hooks がスタンドアロンの `.claude/hooks.json` ファイルにあります                           | スタンドアロンの hooks ファイルはありません。`settings.json` の `"hooks"` キーの下に hooks を定義します。[フック設定](/ja/hooks) を参照してください。                                                  |
-| グローバルに設定された権限、hooks、env が無視されます                            | 設定が `~/.claude.json` に追加されました                                            | `~/.claude.json` はアプリ状態と UI トグルを保持します。`permissions`、`hooks`、`env` は `~/.claude/settings.json` に属します。これらは 2 つの異なるファイルです。                                 |
-| `settings.json` 値が無視されているように見えます                           | 同じキーが `settings.local.json` で設定されています                                    | `settings.local.json` は `settings.json` をオーバーライドし、両方とも `~/.claude/settings.json` をオーバーライドします。[設定の優先順位](/ja/settings#how-scopes-interact) を参照してください。     |
-| スキルが `/skills` に表示されません                                    | スキルファイルがフォルダ内ではなく `.claude/skills/name.md` にあります                         | `SKILL.md` を含むフォルダを使用します：`.claude/skills/name/SKILL.md`。                                                                                                |
-| スキルが `/skills` に表示されますが Claude が呼び出しません                    | スキルのフロントマターに `disable-model-invocation: true` があるか、その説明がリクエストの言い方と一致しません | `/skills` のバッジを確認します：「user-only」ラベルは Claude が独自にトリガーしないことを意味します。[スキル呼び出し](/ja/skills) を参照してください。                                                        |
-| サブディレクトリの `CLAUDE.md` 指示が無視されているように見えます                    | サブディレクトリファイルはセッション開始時ではなくオンデマンドで読み込まれます                                  | Claude が Read ツールでそのディレクトリ内のファイルを読むときに読み込まれます。起動時ではなく、ファイルを書き込みまたは作成するときではありません。[CLAUDE.md ファイルの読み込み方法](/ja/memory#how-claude-md-files-load) を参照してください。 |
-| サブエージェントが `CLAUDE.md` 指示を無視します                             | サブエージェントは常にプロジェクトメモリを継承するわけではありません                                       | 重要なルールをエージェントファイル本体に入れます。これはサブエージェントのシステムプロンプトになります。[サブエージェント設定](/ja/sub-agents) を参照してください。                                                             |
-| クリーンアップロジックがセッション終了時に実行されません                               | `SessionEnd` フックが設定されていません                                               | `settings.json` に `SessionEnd` フックを追加します。[フックイベントリスト](/ja/hooks#hook-events) を参照してください。                                                                 |
-| `.mcp.json` の MCP サーバーが読み込まれません                            | ファイルが `.claude/` の下にあるか、Claude Desktop の設定形式を使用しています                     | プロジェクト MCP 設定はリポジトリルートの `.mcp.json` に置かれます。`.claude/` 内ではありません。[MCP 設定](/ja/mcp) を参照してください。                                                             |
-| `settings.json` の `mcpServers` の下に追加された MCP サーバーが表示されません   | `settings.json` は `mcpServers` キーを読み込みません                                | プロジェクトサーバーをリポジトリルートの `.mcp.json` で定義するか、`claude mcp add --scope user` を実行してユーザースコープサーバーを追加します。[MCP 設定](/ja/mcp) を参照してください。                              |
-| プロジェクト MCP サーバーが追加されても表示されません                              | 1 回限りの承認プロンプトが却下されました                                                    | プロジェクトスコープサーバーは承認が必要です。`/mcp` を実行してステータスを確認し、承認します。                                                                                                     |
-| MCP サーバーが一部のディレクトリから起動に失敗します                               | `command` または `args` が相対ファイルパスを使用しています                                   | ローカルスクリプトには絶対パスを使用します。`npx` または `uvx` のような `PATH` 上の実行可能ファイルはそのまま機能します。                                                                                 |
-| MCP サーバーが予期された環境変数なしで起動します                                 | 変数は `settings.json` `env` にあり、MCP 子プロセスに伝播しません                           | 代わりに `.mcp.json` 内のサーバーごとの `env` を設定します。                                                                                                                |
-| `Bash(rm *)` 拒否ルールが `/bin/rm` または `find -delete` をブロックしません | プレフィックスルールは基になる実行可能ファイルではなく、リテラルコマンド文字列をマッチします                           | 各バリアントの明示的なパターンを追加するか、[PreToolUse フック](/ja/hooks-guide) または [サンドボックス](/ja/sandboxing) を使用して、ハード保証を取得します。                                                |
+| 症状                                                         | 原因                                                                                 | 修正                                                                                                                                                                                           |
+| :--------------------------------------------------------- | :--------------------------------------------------------------------------------- | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
+| フックが発火しない                                                  | `matcher` が JSON 配列ではなく文字列である                                                      | 複数のツールをマッチするために `\|` を含む単一の文字列を使用します。例えば `"Edit\|Write"` です。[マッチャーパターン](/ja/hooks#matcher-patterns) を参照してください。                                                                               |
+| フックが発火しない                                                  | `matcher` 値が小文字です。例えば `"bash"`                                                     | マッチングは大文字と小文字を区別します。ツール名は大文字です：`Bash`、`Edit`、`Write`、`Read`。                                                                                                                                 |
+| フックが発火しない                                                  | Hooks がスタンドアロンファイルではなく `settings.json` に定義されていません                                  | プロジェクトまたはユーザー設定用のスタンドアロン hooks ファイルはありません。`settings.json` の `"hooks"` キーの下に hooks を定義します。[プラグイン](/ja/plugins-reference#hooks) のみが別の `hooks/hooks.json` を読み込みます。[フック設定](/ja/hooks) を参照してください。 |
```

</details>

<details>
<summary>desktop-ja.md</summary>

```diff
diff --git a/docs-ja/pages/desktop-ja.md b/docs-ja/pages/desktop-ja.md
index 1a01545..be82d69 100644
--- a/docs-ja/pages/desktop-ja.md
+++ b/docs-ja/pages/desktop-ja.md
@@ -3,5 +3,5 @@
 > Use this file to discover all available pages before exploring further.
 
-# Claude Code Desktop を使用する
+# Desktop application
 
 > Claude Code Desktop をさらに活用する：Git 分離による並列セッション、ドラッグアンドドロップペインレイアウト、統合ターミナルとファイルエディタ、サイドチャット、コンピュータ使用、電話から Dispatch セッションを送信、ビジュアル diff レビュー、アプリプレビュー、PR 監視、コネクタ、エンタープライズ設定。
@@ -708,4 +708,5 @@ Desktop と CLI は同じ設定ファイルを読み取るため、セットア
 * **インラインコード提案**：Desktop はオートコンプリートスタイルの提案を提供しません。会話型プロンプトと明示的なコード変更を通じて機能します。
 * **エージェントチーム**：マルチエージェントオーケストレーションは [CLI](/ja/agent-teams) および [Agent SDK](/ja/headless) を通じて利用可能であり、Desktop では利用できません。
+* **ターミナルダイアログコマンド**：`/permissions`、`/config`、`/agents`、`/doctor` などのターミナルで対話型パネルを開く組み込みコマンドは、Code タブでは利用できず、`isn't available in this environment` で応答します。[設定ファイル](/ja/settings)を直接編集して権限ルールと設定を管理するか、スタンドアロン CLI からコマンドを実行します。
 
 ## トラブルシューティング
```

</details>

<details>
<summary>discover-plugins-ja.md</summary>

```diff
diff --git a/docs-ja/pages/discover-plugins-ja.md b/docs-ja/pages/discover-plugins-ja.md
index 5116c21..4e24038 100644
--- a/docs-ja/pages/discover-plugins-ja.md
+++ b/docs-ja/pages/discover-plugins-ja.md
@@ -139,5 +139,7 @@ Anthropic は、プラグインシステムで何が可能かを示す例プラ
 
   <Step title="プラグインをインストールする">
-    プラグインを選択してその詳細を表示し、インストール スコープを選択します：
+    プラグインを選択してその詳細を表示します。{/* min-version: 2.1.143 */}Claude Code v2.1.143 以降では、詳細ペインに **Context cost** の推定値が含まれており、インストール前に、プラグインが毎ターン [コンテキストウィンドウ](/ja/features-overview#understand-context-costs) に追加するトークン数を確認できます。
+
+    インストール スコープを選択します：
 
     * **User scope**: すべてのプロジェクト全体で自分用にインストール
```

</details>

*...以降省略*

</details>


<details>
<summary>2026-05-17</summary>

**変更ファイル:**

```
 docs-ja/pages/microsoft-foundry-ja.md | 10 ++++++++++
 docs-ja/pages/model-config-ja.md      |  2 +-
 docs-ja/pages/skills-ja.md            |  2 ++
 3 files changed, 13 insertions(+), 1 deletion(-)
```

<details>
<summary>microsoft-foundry-ja.md</summary>

```diff
diff --git a/docs-ja/pages/microsoft-foundry-ja.md b/docs-ja/pages/microsoft-foundry-ja.md
index 3126d0b..fb2293a 100644
--- a/docs-ja/pages/microsoft-foundry-ja.md
+++ b/docs-ja/pages/microsoft-foundry-ja.md
@@ -174,4 +174,14 @@ export ENABLE_PROMPT_CACHING_1H=1
 ```
 
+### 5. Claude Code を実行する
+
+環境変数を設定したら、プロジェクトディレクトリから Claude Code を起動します：
+
+```bash theme={null}
+claude
+```
+
+Claude Code は環境から `CLAUDE_CODE_USE_FOUNDRY` およびその他の Foundry 変数を読み込み、最初のプロンプトで Azure リソースに接続します。Bedrock および Vertex AI とは異なり、Foundry には対話型セットアップウィザードがないため、ステップ 3 およびステップ 4 の環境変数が唯一の構成パスです。
+
 ## Azure RBAC 構成
 
```

</details>

<details>
<summary>model-config-ja.md</summary>

```diff
diff --git a/docs-ja/pages/model-config-ja.md b/docs-ja/pages/model-config-ja.md
index 7393d92..c98dc3c 100644
--- a/docs-ja/pages/model-config-ja.md
+++ b/docs-ja/pages/model-config-ja.md
@@ -201,5 +201,5 @@ Opus 4.7 を初めて実行する場合、Claude Code は、以前に Opus 4.6 
 * **`--effort` フラグ**：Claude Code を起動する際にレベル名を渡して、単一セッションのレベルを設定
 * **環境変数**：`CLAUDE_CODE_EFFORT_LEVEL` をレベル名または `auto` に設定
-* **設定**：設定ファイルで `effortLevel` を設定
+* **設定**：設定ファイルで `effortLevel` を `low`、`medium`、`high`、`xhigh` に設定します。`max` は [セッションのみ](#adjust-effort-level) であり、ここでは受け入れられません
 * **Skill と subagent frontmatter**：[skill](/ja/skills#frontmatter-reference) または [subagent](/ja/sub-agents#supported-frontmatter-fields) markdown ファイルで `effort` を設定して、その skill または subagent が実行される際の努力レベルをオーバーライド
 
```

</details>

<details>
<summary>skills-ja.md</summary>

```diff
diff --git a/docs-ja/pages/skills-ja.md b/docs-ja/pages/skills-ja.md
index 0ea2ddb..fb7abe6 100644
--- a/docs-ja/pages/skills-ja.md
+++ b/docs-ja/pages/skills-ja.md
@@ -408,4 +408,6 @@ Summarize this pull request...
 これは前処理であり、Claude が実行するものではありません。Claude は最終結果のみを見ます。
 
+置換は元のファイルに対して 1 回実行されます。コマンド出力はプレーンテキストとして挿入され、さらに `` !`<command>` `` プレースホルダーについて再スキャンされないため、コマンドは後のパスで展開するプレースホルダーを発行することはできません。
+
 複数行のコマンドの場合、インラインフォーム `` !`<command>` `` の代わりに、` ```! ` で開かれたフェンスコードブロックを使用します：
 
```

</details>

</details>


<details>
<summary>2026-05-16</summary>

**変更ファイル:**

```
 docs-ja/pages/agent-view-ja.md        |  6 ++++++
 docs-ja/pages/amazon-bedrock-ja.md    |  9 ++++++---
 docs-ja/pages/changelog.md            | 36 +++++++++++++++++++++++++++++++++++
 docs-ja/pages/claude-directory-ja.md  |  1 +
 docs-ja/pages/data-usage-ja.md        |  4 +++-
 docs-ja/pages/env-vars-ja.md          |  5 +++--
 docs-ja/pages/errors-ja.md            | 20 +++++++++----------
 docs-ja/pages/goal-ja.md              |  4 ++++
 docs-ja/pages/google-vertex-ai-ja.md  |  6 ++++--
 docs-ja/pages/hooks-ja.md             | 16 +++++++++++++++-
 docs-ja/pages/mcp-ja.md               | 20 ++++++++++---------
 docs-ja/pages/microsoft-foundry-ja.md |  2 ++
 12 files changed, 101 insertions(+), 28 deletions(-)
```

<details>
<summary>agent-view-ja.md</summary>

```diff
diff --git a/docs-ja/pages/agent-view-ja.md b/docs-ja/pages/agent-view-ja.md
index 4c98b5e..bbb89ed 100644
--- a/docs-ja/pages/agent-view-ja.md
+++ b/docs-ja/pages/agent-view-ja.md
@@ -266,4 +266,10 @@ claude --agent code-reviewer --bg "address review comments on PR 1234"
 ```
 
+`--name` を渡して、自動生成されたセッションの代わりにエージェントビューでセッションの表示名を設定します。
+
+```bash theme={null}
+claude --bg --name "flaky-test-fix" "investigate the flaky SettingsChangeDetector test"
+```
+
 バックグラウンド化の後、Claude はセッションの短い ID とセッションを管理するためのコマンドを出力します。
 
```

</details>

<details>
<summary>amazon-bedrock-ja.md</summary>

```diff
diff --git a/docs-ja/pages/amazon-bedrock-ja.md b/docs-ja/pages/amazon-bedrock-ja.md
index 53f2bea..2665a7e 100644
--- a/docs-ja/pages/amazon-bedrock-ja.md
+++ b/docs-ja/pages/amazon-bedrock-ja.md
@@ -212,6 +212,7 @@ export CLAUDE_CODE_USE_BEDROCK=1
 export AWS_REGION=us-east-1  # または希望するリージョン
 
-# オプション：小型/高速モデル（Haiku）のリージョンをオーバーライド
-# Bedrock Mantle にも適用されます。
+# オプション：小型/高速モデル（Bedrock および Mantle）の AWS リージョンをオーバーライド
+# Bedrock では、ANTHROPIC_DEFAULT_HAIKU_MODEL
+# または非推奨の ANTHROPIC_SMALL_FAST_MODEL が設定されていない場合、効果がありません。
 export ANTHROPIC_SMALL_FAST_MODEL_AWS_REGION=us-west-2
 
@@ -249,5 +250,7 @@ export ANTHROPIC_DEFAULT_HAIKU_MODEL='us.anthropic.claude-haiku-4-5-20251001-v1:
 | :------- | :--------------------------------------------- |
 | プライマリモデル | `us.anthropic.claude-sonnet-4-5-20250929-v1:0` |
-| 小型/高速モデル | `us.anthropic.claude-haiku-4-5-20251001-v1:0`  |
+| 小型/高速モデル | プライマリモデルと同じ                                    |
+
+セッションタイトル生成などのバックグラウンドタスクは、小型/高速モデル（通常は Haiku クラスモデル）を使用します。Bedrock では、すべてのアカウントまたはリージョンで Haiku が有効になっていない可能性があるため、Claude Code はこれをプライマリモデルにデフォルト設定します。バックグラウンドタスクに Haiku を使用するには、`ANTHROPIC_DEFAULT_HAIKU_MODEL` をアカウントで利用可能なモデル ID に設定してください。
 
 モデルをさらにカスタマイズするには、以下のいずれかの方法を使用します。
```

</details>

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index 3fcf5ed..8c6909b 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,40 @@
 # Changelog
 
+## 2.1.143
+
+- Added plugin dependency enforcement: `claude plugin disable` now refuses when another enabled plugin depends on the target (with a copy-pasteable disable-chain hint), and `claude plugin enable` force-enables transitive dependencies
+- Added projected context cost (per-turn and per-invocation token estimates) to the `/plugin` marketplace browse pane
+- Added `worktree.bgIsolation: "none"` setting to let background sessions edit the working copy directly without `EnterWorktree`, for repos where worktrees are impractical
+- PowerShell tool now passes `-ExecutionPolicy Bypass`. Opt out with `CLAUDE_CODE_POWERSHELL_RESPECT_EXECUTION_POLICY=1`
+- Background sessions now preserve the model and effort level you set after waking from idle
+- Shift+Tab in attached agent sessions now includes auto mode in the cycle
+- Fixed a corrupt `.credentials.json` with a non-array `scopes` value hanging the CLI on startup or silently aborting OAuth token refresh
+- Fixed right-click paste in `claude agents` on Windows Terminal and WSL
+- Fixed stop hooks that block repeatedly looping forever — the turn now ends with a warning after 8 consecutive blocks (override via `CLAUDE_CODE_STOP_HOOK_BLOCK_CAP`)
+- Fixed Esc/Ctrl+C not cancelling a pending `/loop` wakeup while Claude is idle between iterations
+- Fixed `/goal` evaluator firing while background shells or delegated subagents are still running
+- Fixed `NO_COLOR`/`FORCE_COLOR` in settings.json `env` stripping Claude Code's own UI colors — they now apply to subprocesses only
+- Fixed agent view spawning repeated PowerShell processes on Windows when listing sessions
+- Fixed `/bg` without a prompt sending "continue" to the forked session — the fork now waits for input
+- Fixed `--agent <name>` not finding plugin-contributed agents without the `plugin:` prefix
+- Fixed deleting a session from agent view not removing its transcript file
+- Fixed stale-fragment rendering when scrolling in attached background sessions on Windows Terminal
+- Fixed background agents false-positive worker-stall detection storm after host sleep or macOS App Nap
+- Fixed 5xx error messages pointing at status.claude.com instead of naming the configured gateway or cloud provider
+- The PowerShell tool is now enabled by default on Windows for Bedrock, Vertex, and Foundry users. Opt out with `CLAUDE_CODE_USE_POWERSHELL_TOOL=0`.
+- `claude agents` now accepts `--add-dir`, `--settings`, `--mcp-config`, and `--plugin-dir` and applies them to the dashboard and to background sessions dispatched from it
```

</details>

<details>
<summary>claude-directory-ja.md</summary>

```diff
diff --git a/docs-ja/pages/claude-directory-ja.md b/docs-ja/pages/claude-directory-ja.md
index 3e1b6a3..cc41673 100644
--- a/docs-ja/pages/claude-directory-ja.md
+++ b/docs-ja/pages/claude-directory-ja.md
@@ -1508,4 +1508,5 @@ Windows では、`~/.claude` は `%USERPROFILE%\.claude` に解決されます
 | `shell-snapshots/`                           | Bash ツールによって使用されるキャプチャされたシェル環境。正常な終了時に削除されます。スイープはクラッシュ後に残されたものをクリアします。              |
 | `backups/`                                   | 設定マイグレーション前に取得された `~/.claude.json` のタイムスタンプ付きコピー                                     |
+| `feedback-bundles/`                          | `/feedback` によってサードパーティプロバイダーに書き込まれた編集済みトランスクリプトアーカイブ。Anthropic アカウントチームに送信するため      |
 
 ### 削除するまで保持される
```

</details>

<details>
<summary>data-usage-ja.md</summary>

```diff
diff --git a/docs-ja/pages/data-usage-ja.md b/docs-ja/pages/data-usage-ja.md
index a165950..69741f4 100644
--- a/docs-ja/pages/data-usage-ja.md
+++ b/docs-ja/pages/data-usage-ja.md
@@ -100,5 +100,7 @@ Claude Code はユーザーのマシンから Anthropic に接続して、レイ
 Claude Code はユーザーのマシンから Sentry に接続して、運用エラーログを記録します。データは TLS を使用して転送中に暗号化され、256 ビット AES 暗号化を使用して保存時に暗号化されます。詳細については、[Sentry security documentation](https://sentry.io/security/) を参照してください。エラーログをオプトアウトするには、`DISABLE_ERROR_REPORTING` 環境変数を設定します。
 
-ユーザーが `/feedback` コマンドを実行すると、コードを含む完全な会話履歴のコピーが Anthropic に送信されます。データは転送中に TLS で暗号化されます。オプションで、公開リポジトリに GitHub イシューが作成されます。オプトアウトするには、`DISABLE_FEEDBACK_COMMAND` 環境変数を `1` に設定します。
+`/feedback` コマンドを実行すると、コードを含む会話履歴のコピーが Anthropic に送信されます。送信前に、含める履歴の量を選択できます。デフォルトは現在のセッションのみですが、同じプロジェクトの過去 24 時間または 7 日間の他のセッションも含めることができます。データは TLS 経由で転送中に暗号化されます。オプションで、公開リポジトリに GitHub イシューが作成されます。オプトアウトするには、`DISABLE_FEEDBACK_COMMAND` 環境変数を `1` に設定します。
+
+Bedrock や Vertex などのサードパーティプロバイダーを使用している場合、または Anthropic 認証情報が設定されていない場合、`/feedback` はレポートを Anthropic に送信する代わりに、`~/.claude/feedback-bundles/` の下のローカルアーカイブに書き込みます。既知の API キーおよびトークンパターンは、アーカイブが書き込まれる前に削除されます。Anthropic アカウント担当者にファイルを送信するか、サポートリクエストに添付するまで、何もマシンから出ません。
 
 ## API プロバイダーのデフォルト動作
```

</details>

<details>
<summary>env-vars-ja.md</summary>

```diff
diff --git a/docs-ja/pages/env-vars-ja.md b/docs-ja/pages/env-vars-ja.md
index 2b295c5..331370d 100644
--- a/docs-ja/pages/env-vars-ja.md
+++ b/docs-ja/pages/env-vars-ja.md
@@ -43,5 +43,5 @@ Claude Code は、その動作を制御するために以下の環境変数を
 | `ANTHROPIC_MODEL`                                       | 使用するモデル設定の名前（[モデル設定](/ja/model-config#environment-variables) を参照してください）                                                                                                                                                                                                                                                                                                                                                        |
 | `ANTHROPIC_SMALL_FAST_MODEL`                            | \[非推奨] バックグラウンドタスク用の [Haiku クラスモデルの名前](/ja/costs)                                                                                                                                                                                                                                                                                                                                                                              |
-| `ANTHROPIC_SMALL_FAST_MODEL_AWS_REGION`                 | Bedrock または Bedrock Mantle を使用する場合、Haiku クラスモデルの AWS リージョンをオーバーライドします                                                                                                                                                                                                                                                                                                                                                          |
+| `ANTHROPIC_SMALL_FAST_MODEL_AWS_REGION`                 | Bedrock または Bedrock Mantle を使用する場合、Haiku クラスモデルの AWS リージョンをオーバーライドします。Bedrock では、`ANTHROPIC_DEFAULT_HAIKU_MODEL` または非推奨の `ANTHROPIC_SMALL_FAST_MODEL` も設定されている場合にのみ有効になります。Bedrock はそれ以外の場合、バックグラウンドタスク用にプライマリモデルを使用するためです                                                                                                                                                                                                     |
 | `ANTHROPIC_VERTEX_BASE_URL`                             | Vertex AI エンドポイント URL をオーバーライドします。カスタム Vertex エンドポイントを使用する場合、または [LLM ゲートウェイ](/ja/llm-gateway) を通じてルーティングする場合に使用します。[Google Vertex AI](/ja/google-vertex-ai) を参照してください                                                                                                                                                                                                                                                         |
 | `ANTHROPIC_VERTEX_PROJECT_ID`                           | Vertex AI リクエスト用の GCP プロジェクト ID。`GCLOUD_PROJECT`、`GOOGLE_CLOUD_PROJECT`、または `GOOGLE_APPLICATION_CREDENTIALS` 認証情報ファイル内のプロジェクトでオーバーライドされます。[Google Vertex AI](/ja/google-vertex-ai) を参照してください                                                                                                                                                                                                                                   |
@@ -70,5 +70,5 @@ Claude Code は、その動作を制御するために以下の環境変数を
 | `CLAUDE_CODE_CLIENT_KEY`                                | mTLS 認証用のクライアント秘密鍵ファイルへのパス                                                                                                                                                                                                                                                                                                                                                                                                     |
 | `CLAUDE_CODE_CLIENT_KEY_PASSPHRASE`                     | 暗号化された CLAUDE\_CODE\_CLIENT\_KEY のパスフレーズ（オプション）                                                                                                                                                                                                                                                                                                                                                                                |
-| `CLAUDE_CODE_DEBUG_LOGS_DIR`                            | デバッグログファイルパスをオーバーライドします。名前に反して、これはディレクトリではなくファイルパスです。デバッグモードを `--debug` または `/debug` で別途有効にする必要があります。この変数を設定するだけではログが有効になりません。[`--debug-file`](/ja/cli-reference#cli-flags) フラグは両方を一度に行います。デフォルトは `~/.claude/debug/<session-id>.txt` です                                                                                                                                                                                        |
+| `CLAUDE_CODE_DEBUG_LOGS_DIR`                            | デバッグログファイルパスをオーバーライドします。名前に反して、これはディレクトリではなくファイルパスです。デバッグモードを `--debug`、`/debug`、または `DEBUG` 環境変数で別途有効にする必要があります。この変数を設定するだけではログが有効になりません。[`--debug-file`](/ja/cli-reference#cli-flags) フラグは両方を一度に行います。デフォルトは `~/.claude/debug/<session-id>.txt` です                                                                                                                                                                            |
 | `CLAUDE_CODE_DEBUG_LOG_LEVEL`                           | デバッグログファイルに書き込まれる最小ログレベル。値：`verbose`、`debug`（デフォルト）、`info`、`warn`、`error`。フルステータスラインコマンド出力などの大量の診断を含めるには `verbose` に設定するか、ノイズを減らすには `error` に上げます                                                                                                                                                                                                                                                                              |
 | `CLAUDE_CODE_DISABLE_1M_CONTEXT`                        | [1M コンテキストウィンドウ](/ja/model-config#extended-context) サポートを無効にするには `1` に設定します。設定すると、1M モデルバリアントはモデルピッカーで利用できなくなります。コンプライアンス要件のあるエンタープライズ環境に役立ちます                                                                                                                                                                                                                                                                                 |
@@ -185,4 +185,5 @@ Claude Code は、その動作を制御するために以下の環境変数を
 | `CLAUDE_REMOTE_CONTROL_SESSION_NAME_PREFIX`             | 明示的な名前が指定されていない場合、自動生成される [Remote Control](/ja/remote-control) セッション名のプレフィックス。デフォルトはマシンのホスト名で、`myhost-graceful-unicorn` のような名前を生成します。`--remote-control-session-name-prefix` CLI フラグは単一の呼び出しに対して同じ値を設定します                                                                                                                                                                                                                       |
 | `CLAUDE_STREAM_IDLE_TIMEOUT_MS`                         | ストリーミングアイドルウォッチドッグが停止した接続を閉じるまでのタイムアウト（ミリ秒）。デフォルトと最小 `300000`（5 分）の両方のバイトレベルとイベントレベルウォッチドッグの場合。低い値は拡張思考の一時停止とプロキシバッファリングを吸収するために自動的にクランプされます。サードパーティプロバイダーの場合、`CLAUDE_ENABLE_STREAM_WATCHDOG=1` が必須です                                                                                                                                                                                                                          |
+| `DEBUG`                                                 | デバッグモードを有効にするには `1` に設定します。[`--debug`](/ja/cli-reference#cli-flags) で起動するのと同等です。デバッグログは `~/.claude/debug/<session-id>.txt` に書き込まれるか、`CLAUDE_CODE_DEBUG_LOGS_DIR` で設定されたパスに書き込まれます。`1`、`true`、`yes`、`on` の真の値のみがデバッグモードを有効にするため、他のツール用に設定された `DEBUG=express:*` などの名前空間パターンはトリガーしません                                                                                                                                             |
 | `DISABLE_AUTOUPDATER`                                   | 自動更新を無効にするには `1` に設定します。手動の `claude update` は引き続き機能します。`DISABLE_UPDATES` を使用して両方をブロックします                                                                                                                                                                                                                                                                                                                                       |
 | `DISABLE_AUTO_COMPACT`                                  | コンテキスト制限に近づいたときの自動コンパクションを無効にするには `1` に設定します。手動の `/compact` コマンドは引き続き利用可能です。コンパクションが発生するタイミングを明示的に制御したい場合に使用します                                                                                                                                                                                                                                                                                                                |
```

</details>

<details>
<summary>errors-ja.md</summary>

```diff
diff --git a/docs-ja/pages/errors-ja.md b/docs-ja/pages/errors-ja.md
index 414f4be..4f2d5d3 100644
--- a/docs-ja/pages/errors-ja.md
+++ b/docs-ja/pages/errors-ja.md
@@ -80,7 +80,7 @@ API Error: 500 {"type":"error","error":{"type":"api_error","message":"Internal s
 **対応方法：**
 
-* [status.claude.com](https://status.claude.com)でアクティブなインシデントを確認してください
+* [status.claude.com](https://status.claude.com) でアクティブなインシデントを確認してください
 * 1 分待ってからメッセージを再度送信してください。元のメッセージはまだ会話に残っているため、長いプロンプトの場合は全体を貼り付ける代わりに `try again` と入力できます。
-* エラーが投稿されたインシデントなしで続く場合は、`/feedback` を実行して、Anthropic がリクエスト詳細で調査できるようにしてください。プロバイダーで `/feedback` が利用できない場合は、[エラーを報告する](#report-an-error)を参照してください。
+* エラーが投稿されたインシデントなしで続く場合は、`/feedback` を実行して、Anthropic がリクエスト詳細で調査できるようにしてください。環境で `/feedback` が利用できない場合は、[エラーを報告する](#report-an-error) を参照してください。
 
 ### API Error: Repeated 529 Overloaded errors
@@ -96,5 +96,5 @@ API Error: Repeated 529 Overloaded errors · check status.claude.com
 **対応方法：**
 
-* [status.claude.com](https://status.claude.com)で容量に関する通知を確認してください
+* [status.claude.com](https://status.claude.com) で容量に関する通知を確認してください
 * 数分後に再度試してください
 * `/model` を実行して別のモデルに切り替えて、容量がモデルごとに追跡されるため、作業を続けてください。Claude Code は、1 つのモデルが特に高い負荷を受けている場合、たとえば `Opus is experiencing high load, please use /model to switch to Sonnet` のようにこれを行うようにプロンプトを表示します。
@@ -114,10 +114,10 @@ Request timed out
 * リクエストを再試行してください
 * 長時間実行されるタスクの場合は、作業をより小さいプロンプトに分割してください
-* 遅いネットワークまたはプロキシが原因の場合は、[自動リトライ](#automatic-retries)で説明されているように `API_TIMEOUT_MS` を上げてください
-* タイムアウトが頻繁で、ネットワークが正常な場合は、以下の[ネットワークと接続エラー](#network-and-connection-errors)を参照してください
+* 遅いネットワークまたはプロキシが原因の場合は、[自動リトライ](#automatic-retries) で説明されているように `API_TIMEOUT_MS` を上げてください
+* タイムアウトが頻繁で、ネットワークが正常な場合は、以下の[ネットワークと接続エラー](#network-and-connection-errors) を参照してください
 
 ### Auto mode cannot determine the safety of an action
```

</details>

<details>
<summary>goal-ja.md</summary>

```diff
diff --git a/docs-ja/pages/goal-ja.md b/docs-ja/pages/goal-ja.md
index 16469b3..08f2780 100644
--- a/docs-ja/pages/goal-ja.md
+++ b/docs-ja/pages/goal-ja.md
@@ -7,4 +7,8 @@
 > /goal でコンプリーション条件を設定すると、Claude はターン間でプロンプトなしに条件が満たされるまで動作し続けます。
 
+<Note>
+  `/goal` には Claude Code v2.1.139 以降が必要です。
+</Note>
+
 `/goal` コマンドはコンプリーション条件を設定し、Claude はあなたが各ステップをプロンプトすることなく、その条件に向かって動作し続けます。各ターンの後、小さく高速なモデルが条件が成立しているかどうかをチェックします。成立していない場合、Claude はあなたに制御を返す代わりに別のターンを開始します。条件が満たされると、ゴールは自動的にクリアされます。
 
```

</details>

*...以降省略*

</details>


<details>
<summary>2026-05-15</summary>

**変更ファイル:**

```
 docs-ja/pages/agent-view-ja.md              |  68 ++++++++++++++----
 docs-ja/pages/amazon-bedrock-ja.md          |  13 ++--
 docs-ja/pages/best-practices-ja.md          |  48 ++++++-------
 docs-ja/pages/changelog.md                  |  27 ++++++++
 docs-ja/pages/checkpointing-ja.md           |  19 ++---
 docs-ja/pages/claude-code-on-the-web-ja.md  |   2 +-
 docs-ja/pages/cli-reference-ja.md           |   2 +-
 docs-ja/pages/commands-ja.md                |   2 +-
 docs-ja/pages/desktop-ja.md                 |  19 ++---
 docs-ja/pages/desktop-scheduled-tasks-en.md | 104 ----------------------------
 docs-ja/pages/env-vars-ja.md                |   4 +-
 docs-ja/pages/github-actions-ja.md          |  32 ++++++---
 docs-ja/pages/glossary-ja.md                |   2 +-
 docs-ja/pages/goal-ja.md                    |   2 +-
 docs-ja/pages/hooks-guide-ja.md             |   5 +-
 docs-ja/pages/hooks-ja.md                   |  68 ++++++++++++++----
 docs-ja/pages/mcp-ja.md                     |   2 +-
 docs-ja/pages/remote-control-ja.md          |  37 +++++-----
 docs-ja/pages/sub-agents-ja.md              |  10 +--
 docs-ja/pages/voice-dictation-ja.md         |  32 +++++----
 20 files changed, 260 insertions(+), 238 deletions(-)
```

**新規追加:**


**削除:**


<details>
<summary>agent-view-ja.md</summary>

```diff
diff --git a/docs-ja/pages/agent-view-ja.md b/docs-ja/pages/agent-view-ja.md
index 9f045f3..4c98b5e 100644
--- a/docs-ja/pages/agent-view-ja.md
+++ b/docs-ja/pages/agent-view-ja.md
@@ -47,5 +47,5 @@ Claude が複数の独立したタスクに対して、あなたが毎ステッ
 
   <Step title="セッションをディスパッチする">
-    タスクを説明するプロンプトを入力して `Enter` を押します。新しいバックグラウンドセッションがそのタスクで開始され、作業中か、入力を待機中か、完了しているかを示す行として表示されます。新しいセッションはエージェントビューヘッダーに表示されているモデルと、そのディレクトリで `claude` を実行する場合と同じ[パーミッションモード](#permission-mode-and-settings)を使用します。
+    タスクを説明するプロンプトを入力して `Enter` を押します。新しいバックグラウンドセッションがそのタスクで開始され、作業中か、入力を待機中か、完了しているかを示す行として表示されます。新しいセッションはエージェントビューヘッダーに表示されているモデルと、そのディレクトリで `claude` を実行する場合と同じ[パーミッションモード](#permission-mode-model-and-effort)を使用します。
 
     ここで入力するすべてのプロンプトは独自の新しいセッションを開始します。別のプロンプトを入力して `Enter` を押すと、最初のセッションへのフォローアップを送信するのではなく、最初のセッションと並行して 2 番目のセッションが起動します。この方法で複数を並行して実行できます。
@@ -55,5 +55,5 @@ Claude が複数の独立したタスクに対して、あなたが毎ステッ
 
   <Step title="ピーク表示と返信">
-    矢印キーで行を選択し、`Space` を押してピークパネルを開きます。フル トランスクリプトではなく、セッションの最新の出力、または待機中の質問が表示されます。返信を入力して `Enter` を押すと、エージェントビューを離れずに送信できます。
+    矢印キーで行を選択し、`Space` を押してピークパネルを開きます。フルトランスクリプトではなく、セッションの最新の出力、または待機中の質問が表示されます。返信を入力して `Enter` を押すと、エージェントビューを離れずに送信できます。
   </Step>
 
@@ -75,4 +75,6 @@ Claude が複数の独立したタスクに対して、あなたが毎ステッ
 リストはすべてのプロジェクト全体で開始したすべてのバックグラウンドセッションを表示します。1 つのリポジトリで作業しているセッションと別のワークツリーで作業している別のセッションの両方がここに表示されます。エージェントビューを開いたディレクトリに関係なく表示されます。他のターミナルで開いているインタラクティブセッションは、[バックグラウンドにする](#from-inside-a-session)までは表示されません。[Subagents](/ja/sub-agents) と [teammates](/ja/agent-teams) はセッションが生成しても個別の行としてリストされません。
 
+ビューを 1 つのプロジェクトにスコープするには、`claude agents --cwd <path>` で起動します。そのディレクトリの下で開始されたセッションのみが表示されます。これには、そこからディスパッチされた [ワークツリー](/ja/worktrees) で実行されているセッションも含まれます。
+
 ```text theme={null}
 Pinned
@@ -286,5 +288,5 @@ subagent が開始方法に関係なく常に独自のワークツリーで実
 ### モデルを設定する
 
-エージェントビューヘッダーに表示されるモデル名はディスパッチのデフォルトです。入力から開始する新しいセッションはこのモデルを使用します。これは任意のセッションで [`/model`](/ja/model-config) が制御するのと同じ設定です。
+エージェントビューヘッダーに表示されるモデル名はディスパッチのデフォルトです。入力から開始する新しいセッションはこのモデルを使用します。これは任意のセッションで [`/model`](/ja/model-config) が制御するのと同じ設定です。エージェントビューセッション全体でオーバーライドするには、エージェントビューを開く際に `--model` を渡します。[パーミッションモード、モデル、および努力](#permission-mode-model-and-effort) を参照してください。
```

</details>

<details>
<summary>amazon-bedrock-ja.md</summary>

```diff
diff --git a/docs-ja/pages/amazon-bedrock-ja.md b/docs-ja/pages/amazon-bedrock-ja.md
index e27a827..53f2bea 100644
--- a/docs-ja/pages/amazon-bedrock-ja.md
+++ b/docs-ja/pages/amazon-bedrock-ja.md
@@ -116,5 +116,5 @@ AWS 認証情報を持っていて、Bedrock を通じて Claude Code の使用
 ### 1. ユースケースの詳細を送信
 
-Anthropic モデルの初回ユーザーは、モデルを呼び出す前にユースケースの詳細を送信する必要があります。これはアカウントごとに 1 回行われます。
+Anthropic モデルの初回ユーザーは、モデルを呼び出す前にユースケースの詳細を送信する必要があります。これは AWS アカウントごとに 1 回行われます。
 
 1. 以下で説明する適切な IAM 権限があることを確認してください
@@ -171,5 +171,8 @@ Bedrock API キーは、完全な AWS 認証情報を必要としない、より
 Claude Code は、AWS SSO および企業 ID プロバイダーの自動認証情報更新をサポートしています。これらの設定を Claude Code 設定ファイルに追加してください（ファイルの場所については [Settings](/ja/settings) を参照）。
 
-Claude Code が AWS 認証情報の有効期限が切れていることを検出した場合（ローカルのタイムスタンプに基づくか、Bedrock が認証情報エラーを返した場合）、設定された `awsAuthRefresh` および/または `awsCredentialExport` コマンドを自動的に実行して、リクエストを再試行する前に新しい認証情報を取得します。
+これら 2 つの設定には異なるトリガー条件があります。
+
+* **`awsAuthRefresh`**：Claude Code がローカルのタイムスタンプに基づくか、Bedrock が認証情報エラーを返した場合に AWS 認証情報の有効期限が切れていることを検出した場合にのみ実行され、更新された認証情報でリクエストを再試行します。
+* **`awsCredentialExport`**：セッション開始時および各認証情報リロード時に実行されます。AWS デフォルト認証情報プロバイダーチェーン内の認証情報がまだ有効な場合でも実行されます。Bedrock アカウントがデフォルトプロバイダーチェーンが解決するものと異なるクロスアカウント認証情報を必要とする場合に使用します。
 
 ##### 設定例
@@ -188,5 +191,5 @@ Claude Code が AWS 認証情報の有効期限が切れていることを検出
 **`awsAuthRefresh`**：`.aws` ディレクトリを変更するコマンド（認証情報、SSO キャッシュ、または設定ファイルの更新など）に使用します。コマンドの出力はユーザーに表示されますが、対話的な入力はサポートされていません。これは、CLI が URL またはコードを表示し、ブラウザで認証を完了するブラウザベースの SSO フローに適しています。
 
-**`awsCredentialExport`**：`.aws` を変更できず、認証情報を直接返す必要がある場合にのみ使用します。出力はサイレントにキャプチャされ、ユーザーに表示されません。コマンドは次の形式で JSON を出力する必要があります。
+**`awsCredentialExport`**：`.aws` を変更できず、認証情報を直接返す必要がある場合にのみ使用します。このコマンドは、認証情報の有効期限が切れた場合だけでなく、認証情報をリフレッシュする必要があるたびに実行されます。出力はサイレントにキャプチャされ、ユーザーに表示されません。コマンドは次の形式で JSON を出力する必要があります。
 
 ```json theme={null}
@@ -226,5 +229,5 @@ Claude Code で Bedrock を有効にする場合は、以下に注意してく
 
```

</details>

<details>
<summary>best-practices-ja.md</summary>

```diff
diff --git a/docs-ja/pages/best-practices-ja.md b/docs-ja/pages/best-practices-ja.md
index dbdc966..181f528 100644
--- a/docs-ja/pages/best-practices-ja.md
+++ b/docs-ja/pages/best-practices-ja.md
@@ -53,5 +53,5 @@ UI の変更は [Chrome 拡張機能の Claude](/ja/chrome) を使用して検
 </Tip>
 
-Claude が直接コーディングにジャンプさせると、間違った問題を解決するコードが生成される可能性があります。[Plan Mode](/ja/common-workflows#use-plan-mode-for-safe-code-analysis) を使用して、探索を実行から分離します。
+Claude が直接コーディングにジャンプさせると、間違った問題を解決するコードが生成される可能性があります。[Plan Mode](/ja/permission-modes#analyze-before-you-edit-with-plan-mode) を使用して、探索を実行から分離します。
 
 推奨されるワークフローには 4 つのフェーズがあります。
@@ -61,5 +61,5 @@ Claude が直接コーディングにジャンプさせると、間違った問
     Plan Mode に入ります。Claude はファイルを読み取り、変更を加えずに質問に答えます。
 
-    ```txt claude (Plan Mode) theme={null}
+    ```txt claude (plan mode) theme={null}
     read /src/auth and understand how we handle sessions and login.
     also look at how we manage environment variables for secrets.
@@ -70,5 +70,5 @@ Claude が直接コーディングにジャンプさせると、間違った問
     Claude に詳細な実装計画を作成するよう依頼します。
 
-    ```txt claude (Plan Mode) theme={null}
+    ```txt claude (plan mode) theme={null}
     I want to add Google OAuth. What files need to change?
     What's the session flow? Create a plan.
@@ -79,7 +79,7 @@ Claude が直接コーディングにジャンプさせると、間違った問
 
   <Step title="実装">
-    Normal Mode に戻り、Claude にコーディングさせ、計画に対して検証します。
+    Plan Mode を終了し、Claude にコーディングさせ、計画に対して検証します。
```

</details>

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index 1a635c8..3fcf5ed 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,31 @@
 # Changelog
 
+## 2.1.142
+
+- Added new `claude agents` flags: `--add-dir`, `--settings`, `--mcp-config`, `--plugin-dir`, `--permission-mode`, `--model`, `--effort`, and `--dangerously-skip-permissions` to configure dispatched background sessions
+- Fast mode now uses Opus 4.7 by default (previously Opus 4.6). Set `CLAUDE_CODE_OPUS_4_6_FAST_MODE_OVERRIDE=1` to pin fast mode to Opus 4.6
+- Plugins with a root-level `SKILL.md` and no `skills/` subdirectory are now surfaced as a skill
+- The `/plugin` details pane and `claude plugin details` now show LSP servers a plugin provides
+- `/web-setup` warns before replacing an existing GitHub App connection
+- Fixed `MCP_TOOL_TIMEOUT` not raising the per-request fetch timeout for remote HTTP and SSE MCP servers, which capped tool calls at 60 seconds regardless of the configured value
+- Fixed background sessions not recognizing pre-existing git worktrees, blocking Edit while EnterWorktree refused to create a duplicate
+- Fixed background sessions disappearing and daemon reconnect failing after macOS sleep/wake — the daemon now detects clock jumps instead of treating them as elapsed idle time
+- Fixed daemon not exiting cleanly after the binary is upgraded (e.g. `brew upgrade`), causing dispatched agents to crash-loop on the deleted path
+- Fixed background agents crash-looping when the Claude-in-Chrome extension is connected without a shared tab
+- Fixed clicking links in an attached `claude agents` session — the background worker's headless browser shim no longer applies while attached
+- Fixed `claude agents` "v to open in editor" using the daemon's default editor instead of your shell's `$EDITOR`/`$VISUAL`
+- Fixed `claude agents` deadlocking on Windows with network-drive working directories; Ctrl+C now works during startup
+- Fixed background-color bleed when attaching to a `claude agents` session from Apple Terminal or other 256-color-only terminals
+- Fixed `claude --bg --dangerously-skip-permissions` not persisting across retire/wake
+- Fixed session titles being derived from the URL when the first message is a link
+- Fixed redundant `set_model` requests from remote clients injecting duplicate `/model` breadcrumbs into the transcript
+- Fixed plugins using `skills: ["./"]` showing a false "path escapes plugin directory" error
+- Fixed plugin cache cleanup deleting the active plugin version directory when no installation metadata is present
+- Fixed `/plugin` browse pane showing "0 installs" for newly published plugins
+- Fixed plugin advisories not naming every `plugin.json` key that shadows a default folder
```

</details>

<details>
<summary>checkpointing-ja.md</summary>

```diff
diff --git a/docs-ja/pages/checkpointing-ja.md b/docs-ja/pages/checkpointing-ja.md
index e30c21b..5fca0e3 100644
--- a/docs-ja/pages/checkpointing-ja.md
+++ b/docs-ja/pages/checkpointing-ja.md
@@ -29,21 +29,22 @@ Claude Code は、ファイル編集ツールで行われたすべての変更
 * **コードを復元**: 会話を保持しながら、ファイルの変更を戻します
 * **ここから要約**: このポイント以降の会話を圧縮して要約し、コンテキストウィンドウスペースを解放します
+* **ここまで要約**: このポイント前の会話を要約に圧縮し、後のメッセージはそのまま保持します
 * **キャンセル**: 変更を加えずにメッセージリストに戻ります
 
-会話を復元または要約した後、選択したメッセージからの元のプロンプトが入力フィールドに復元されるため、再送信または編集できます。
+会話を復元または「ここから要約」を選択した後、選択したメッセージからの元のプロンプトが入力フィールドに復元されるため、再送信または編集できます。
+
+「ここまで要約」を選択すると、会話の最後に留まり、入力フィールドは空になります。
 
 #### 復元と要約の違い
 
-3 つの復元オプションは状態を戻します。コード変更、会話履歴、またはその両方を取り消します。「ここから要約」は異なる動作をします。
+復元オプションは状態を戻します。コード変更、会話履歴、またはその両方を取り消します。要約オプションは、ディスク上のファイルを変更せずに、会話の一部を AI 生成の要約に圧縮します。
 
-* 選択したメッセージより前のメッセージはそのまま保持されます
-* 選択したメッセージとそれ以降のすべてのメッセージは、コンパクトな AI 生成の要約に置き換えられます
-* ディスク上のファイルは変更されません
-* 元のメッセージはセッショントランスクリプトに保持されるため、Claude は必要に応じて詳細を参照できます
+* **ここから要約**: 選択したメッセージより前のメッセージはそのまま保持されます。選択したメッセージとそれ以降のすべてのメッセージは、要約に置き換えられます。サイドディスカッションを破棄しながら、初期コンテキストを完全な詳細で保持する場合に使用します。
+* **ここまで要約**: 選択したメッセージより前のメッセージは、要約に置き換えられます。選択したメッセージとそれ以降のすべてのメッセージはそのまま保持され、会話の最後に留まります。初期セットアップディスカッションを圧縮しながら、最近の作業を完全な詳細で保持する場合に使用します。
 
-これは `/compact` に似ていますが、対象を絞ったものです。会話全体を要約する代わりに、初期コンテキストを完全な詳細で保持し、スペースを使用している部分のみを圧縮します。要約が焦点を当てるべき内容をガイドするためのオプション指示を入力できます。
+どちらの場合も、元のメッセージはセッショントランスクリプトに保持されるため、Claude は必要に応じて詳細を参照できます。要約が焦点を当てるべき内容をガイドするためのオプション指示を入力できます。これは `/compact` に似ていますが、対象を絞ったものです。会話全体を要約する代わりに、選択したメッセージのどちらの側を圧縮するかを選択します。
 
```

</details>

<details>
<summary>claude-code-on-the-web-ja.md</summary>

```diff
diff --git a/docs-ja/pages/claude-code-on-the-web-ja.md b/docs-ja/pages/claude-code-on-the-web-ja.md
index 975ec6e..5dd700b 100644
--- a/docs-ja/pages/claude-code-on-the-web-ja.md
+++ b/docs-ja/pages/claude-code-on-the-web-ja.md
@@ -783,5 +783,5 @@ Claude は PR を解決する際に GitHub のレビューコメントスレッ
 ### Remote Control セッションの有効期限切れまたはアクセス拒否
 
-`--teleport` はクラウドセッションが使用する同じ Remote Control セッションインフラストラクチャを通じて接続するため、認証およびセッション有効期限エラーは Remote Control の表現で表示されます。`Remote Control session has expired` または `Access denied` が表示される場合があります。接続トークンは短命で、アカウントにスコープされています。
+`--teleport` はクラウドセッションが使用する同じ Remote Control セッションインフラストラクチャを通じて接続するため、認証およびセッション有効期限エラーは Remote Control の表現で表示されます。`Remote Control session expired` または `Access denied` が表示される場合があります。接続トークンは短命で、アカウントにスコープされています。
 
 * ローカルで `/login` を実行して認証情報をリフレッシュし、再接続してください
```

</details>

*...以降省略*

</details>


<details>
<summary>2026-05-14</summary>

**変更ファイル:**

```
 docs-ja/pages/admin-setup-ja.md             |   4 +-
 docs-ja/pages/agent-view-ja.md              | 246 ++++++++++++++++++----------
 docs-ja/pages/authentication-ja.md          |   4 +
 docs-ja/pages/changelog.md                  |  64 ++++++++
 docs-ja/pages/claude-code-on-the-web-ja.md  |  28 ++--
 docs-ja/pages/commands-ja.md                |   2 +-
 docs-ja/pages/headless-ja.md                |   8 +-
 docs-ja/pages/hooks-guide-ja.md             |   2 +-
 docs-ja/pages/legal-and-compliance-ja.md    |   4 +
 docs-ja/pages/memory-ja.md                  |   8 +-
 docs-ja/pages/model-config-ja.md            |   2 +-
 docs-ja/pages/output-styles-ja.md           | 102 +++++++-----
 docs-ja/pages/permissions-ja.md             |   2 +-
 docs-ja/pages/server-managed-settings-ja.md |  16 +-
 docs-ja/pages/settings-ja.md                |   6 +-
 docs-ja/pages/ultrareview-ja.md             |  12 +-
 16 files changed, 344 insertions(+), 166 deletions(-)
```

<details>
<summary>admin-setup-ja.md</summary>

```diff
diff --git a/docs-ja/pages/admin-setup-ja.md b/docs-ja/pages/admin-setup-ja.md
index 118bc30..463883e 100644
--- a/docs-ja/pages/admin-setup-ja.md
+++ b/docs-ja/pages/admin-setup-ja.md
@@ -25,5 +25,5 @@ Claude Code は、ローカル開発者設定よりも優先されるマネー
 ## API プロバイダーを選択する
 
-Claude Code は複数の API プロバイダーのいずれかを通じて Claude に接続します。選択は課金、認証、継承するコンプライアンス体制に影響します。
+Claude Code は複数の API プロバイダーのいずれかを通じて Claude に接続します。選択は課金、認証、継承するコンプライアンス体制、および開発者が使用できる Claude Code 機能に影響します。
 
 | プロバイダー                        | 選択する場合                                                                                     |
@@ -35,4 +35,6 @@ Claude Code は複数の API プロバイダーのいずれかを通じて Claud
 | Microsoft Foundry             | 既存の Azure コンプライアンス制御と課金を継承したい場合                                                            |
 
+一部の Claude Code 機能には Claude.ai アカウントが必要です。[web 上の Claude Code](/ja/claude-code-on-the-web)、[Routines](/ja/routines)、[Code Review](/ja/code-review)、[Remote Control](/ja/remote-control)、および [Chrome 拡張機能](/ja/chrome) は、Console API キーまたはクラウドプロバイダーの認証情報だけでは利用できません。Bedrock、Vertex、または Foundry を通じてデプロイする場合は、開発者が Claude for Teams または Enterprise シートも必要かどうかを検討してください。各機能ページにはプラン要件が記載されています。
+
 認証、リージョン、機能パリティをカバーする完全なプロバイダー比較については、[エンタープライズ展開概要](/ja/third-party-integrations) を参照してください。各プロバイダーの認証セットアップは [Authentication](/ja/authentication) にあります。
 
```

</details>

<details>
<summary>agent-view-ja.md</summary>

```diff
diff --git a/docs-ja/pages/agent-view-ja.md b/docs-ja/pages/agent-view-ja.md
index e888f27..9f045f3 100644
--- a/docs-ja/pages/agent-view-ja.md
+++ b/docs-ja/pages/agent-view-ja.md
@@ -7,15 +7,23 @@
 > 1 つの画面から多くの Claude Code セッションをディスパッチして管理します。エージェントビューは、すべてのセッションが何をしているか、どのセッションが入力を必要としているかを表示します。
 
-`claude agents` で開くエージェントビューは、すべてのバックグラウンドセッションの 1 つの画面です。実行中のもの、入力が必要なもの、完了したものが表示されます。新しいセッションをディスパッチし、トランスクリプトをスクロールする代わりに一目でセッションの状態を確認し、セッションが必要とするときだけ介入します。セッションはターミナルが接続されていなくてもバックグラウンドで実行し続けます。
+`claude agents` で開くエージェントビューは、すべてのバックグラウンドセッションの 1 つの画面です。実行中のもの、入力が必要なもの、完了したものが表示されます。新しいセッションをディスパッチし、トランスクリプトをスクロールする代わりに一目でセッションの状態を確認し、セッションが必要とするときだけ介入します。各バックグラウンドセッションは完全な Claude Code の会話であり、ターミナルが接続されていなくてもバックグラウンドで実行し続けるため、いつでも開いて、返信して、去ることができます。
 
-エージェントビューは、Claude が同時に複数の独立したタスク（バグの修正、プルリクエストのレビュー、ログの調査など）に取り組むことができる場合に使用します。問題を一緒に解決したい場合は、セッションにアタッチして、通常どおり Claude Code をインタラクティブに使用します。エージェントビューのセッションは独立して実行され、あなたにのみレポートします。subagents、agent teams、worktrees との比較については、[エージェントを並列で実行する](/ja/agents)を参照してください。
+<img src="https://mintcdn.com/claude-code/1B48Qz2Z9hac4SLG/images/agent-view-light.png?fit=max&auto=format&n=1B48Qz2Z9hac4SLG&q=85&s=7a186c96ed47d6700d084d77e786be65" className="dark:hidden" alt="ターミナルのエージェントビュー：ヘッダーは Claude Code v2.1.140、モデル、作業ディレクトリ、および概要カウントを表示します。セッションは'入力が必要'、'実行中'、'完了'の下にグループ化され、下部にディスパッチ入力とキーボードヒントのフッターがあります。" width="1772" height="780" data-path="images/agent-view-light.png" />
+
+<img src="https://mintcdn.com/claude-code/1B48Qz2Z9hac4SLG/images/agent-view-dark.png?fit=max&auto=format&n=1B48Qz2Z9hac4SLG&q=85&s=a5bed7434bae368faea3a8f023b52aa2" className="hidden dark:block" alt="ターミナルのエージェントビュー：ヘッダーは Claude Code v2.1.140、モデル、作業ディレクトリ、および概要カウントを表示します。セッションは'入力が必要'、'実行中'、'完了'の下にグループ化され、下部にディスパッチ入力とキーボードヒントのフッターがあります。" width="1772" height="780" data-path="images/agent-view-dark.png" />
+
+Claude が複数の独立したタスクに対して、あなたが毎ステップを監視することなく作業できる場合に、エージェントビューを使用します。バグ修正、プルリクエストレビュー、不安定なテストの調査を 3 つの行としてディスパッチし、別のウィンドウで作業を続け、行が入力が必要であることを示すか、結果が得られたときに確認します。
+
+任意のエージェントのセッションでより直接的に作業したい場合は、行にアタッチして完全な会話に入ります。
+
+エージェントビューを subagents、agent teams、worktrees と比較するには、[エージェントを並列で実行する](/ja/agents)を参照してください。
 
 <Note>
-  エージェントビューはリサーチプレビューであり、Claude Code v2.1.139 以降が必要です。`claude --version` でバージョンを確認してください。インターフェースとキーボードショートカットは機能の進化に伴って変更される可能性があり、管理者は [`disableAgentView`](#how-background-sessions-are-hosted) マネージド設定を使用して組織のエージェントビューを無効にできます。
+  エージェントビューはリサーチプレビューであり、Claude Code v2.1.139 以降が必要です。`claude --version` でバージョンを確認してください。インターフェースとキーボードショートカットは機能の進化に伴って変更される可能性があります。
 </Note>
 
 このページでは以下をカバーしています。
 
-* [クイックスタート](#quick-start)
+* [クイックスタート](#quick-start)：Claude にバックグラウンドで作業するタスクを与え、確認し、必要なときに介入する
```

</details>

<details>
<summary>authentication-ja.md</summary>

```diff
diff --git a/docs-ja/pages/authentication-ja.md b/docs-ja/pages/authentication-ja.md
index a34f95d..e8c9bd5 100644
--- a/docs-ja/pages/authentication-ja.md
+++ b/docs-ja/pages/authentication-ja.md
@@ -144,4 +144,8 @@ Claude Code は認証情報を安全に管理します。
 ### 長期トークンを生成する
 
+<Note>
+  Starting June 15, 2026, Agent SDK and `claude -p` usage on subscription plans will draw from a new monthly Agent SDK credit, separate from your interactive usage limits. See [Use the Claude Agent SDK with your Claude plan](https://support.claude.com/en/articles/15036540-use-the-claude-agent-sdk-with-your-claude-plan) for details.
+</Note>
+
 CI パイプライン、スクリプト、または対話的なブラウザログインが利用できない他の環境の場合、`claude setup-token` で 1 年間の OAuth トークンを生成します。
 
```

</details>

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index 8a8624e..1a635c8 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,68 @@
 # Changelog
 
+## 2.1.141
+
+- Added `terminalSequence` field to hook JSON output so hooks can emit desktop notifications, window titles, and bells without a controlling terminal
+- Added `CLAUDE_CODE_PLUGIN_PREFER_HTTPS` to clone GitHub plugin sources over HTTPS instead of SSH, for environments without a GitHub SSH key
+- Added `ANTHROPIC_WORKSPACE_ID` environment variable for workload identity federation — scopes the minted token to a specific workspace when the federation rule covers more than one
+- Added `claude agents --cwd <path>` to scope the session list to a directory
+- `/feedback` can now include recent sessions (last 24 hours or 7 days) for issues spanning more than the current session
+- Rewind menu: added "Summarize up to here" to compress earlier context while keeping recent turns intact
+- Auto mode permission dialog now explains when a `permissions.ask` rule caused the prompt
+- Restored the "view diff in your IDE" option on file-edit permission prompts when an IDE is connected
+- Background agents launched via `/bg` or `←←` now preserve the current permission mode instead of reverting to default
+- `claude agents`: agents that finish work but leave a background shell running now move to Completed instead of staying under Working
+- Improved spinner feedback during long thinking periods — the spinner now warms to amber after 10 seconds to signal Claude is still working
+- Improved plugin menu navigation: `→`/Tab switch tabs, `↑` moves to the tab strip, and tab headers and search box are clickable in fullscreen mode
+- Fixed background side-queries sending an unavailable Haiku model ID on Bedrock/Vertex/Foundry/gateway when no `ANTHROPIC_SMALL_FAST_MODEL` override is set — now falls back to the main-loop model
+- Fixed `claude daemon status` and `/doctor` on Windows throwing when the daemon pipe key file is locked or unreadable — now shows the underlying error instead of an opaque failure
+- Fixed `claude agents` showing the agent-type list instead of the dashboard when launched through a wrapper that adds flags
+- Fixed `claude agents` opening a crashed session firing redundant dispatches when the working directory was deleted
+- Fixed background jobs on a custom `ANTHROPIC_BASE_URL` gateway not getting auto-named — the namer now uses the main model when no Haiku model is configured
+- Fixed `/model` in one session silently changing the autocompact threshold in other concurrent sessions
+- Fixed switching permission mode while a tool-permission prompt is open not auto-dismissing the prompt when the new setting permits the tool
+- Fixed pressing Enter while a permission/dialog prompt is open also submitting text in the input box
+- Fixed hooks receiving a non-existent `transcript_path` after `EnterWorktree` switches the working directory
```

</details>

<details>
<summary>claude-code-on-the-web-ja.md</summary>

```diff
diff --git a/docs-ja/pages/claude-code-on-the-web-ja.md b/docs-ja/pages/claude-code-on-the-web-ja.md
index 73d3404..975ec6e 100644
--- a/docs-ja/pages/claude-code-on-the-web-ja.md
+++ b/docs-ja/pages/claude-code-on-the-web-ja.md
@@ -33,10 +33,14 @@
 クラウドセッションはコードをクローンしてブランチをプッシュするために GitHub リポジトリへのアクセスが必要です。2 つの方法でアクセスを許可できます：
 
-| 方法               | 仕組み                                                                                                | 最適な用途                 |
-| :--------------- | :------------------------------------------------------------------------------------------------- | :-------------------- |
-| **GitHub App**   | [ウェブオンボーディング](/ja/web-quickstart)中に特定のリポジトリに Claude GitHub App をインストールします。アクセスはリポジトリごとにスコープされます。   | リポジトリごとの明示的な認可を望むチーム  |
-| **`/web-setup`** | ターミナルで `/web-setup` を実行して、ローカル `gh` CLI トークンを Claude アカウントに同期します。アクセスは `gh` トークンが見ることができるものと一致します。 | すでに `gh` を使用している個別開発者 |
+| 方法               | 仕組み                                                               | 最適な用途                                                     |
+| :--------------- | :---------------------------------------------------------------- | :-------------------------------------------------------- |
+| **GitHub App**   | [ウェブオンボーディング](/ja/web-quickstart)中に Claude GitHub App を認可します。     | ブラウザオンボーディング；[Auto-fix](#auto-fix-pull-requests) を希望するチーム |
+| **`/web-setup`** | ターミナルで `/web-setup` を実行して、ローカル `gh` CLI トークンを Claude アカウントに同期します。 | すでに `gh` を使用している個別開発者                                     |
 
-どちらの方法でも機能します。[`/schedule`](/ja/routines)は両方の形式のアクセスをチェックし、どちらも設定されていない場合は `/web-setup` を実行するよう促します。[ターミナルから接続](/ja/web-quickstart#connect-from-your-terminal)で `/web-setup` のウォークスルーを参照してください。
+<Note>
+  どちらの方法でも、クラウドセッションは Claude GitHub App がインストールされているリポジトリだけでなく、接続している GitHub アカウントが見ることができるすべてのリポジトリにアクセスできます。App インストールは [Auto-fix](#auto-fix-pull-requests) の PR webhook を有効にします；これはセッションレベルのアクセス制御ではありません。クラウドセッションからチームが到達できるリポジトリを制限するには、GitHub 自体でアクセスを制限してください。たとえば、接続している GitHub アカウントのチームまたはリポジトリメンバーシップを制限することで実現できます。
+</Note>
+
+どちらの方法でも機能します。[`/schedule`](/ja/routines) は両方の形式のアクセスをチェックし、どちらも設定されていない場合は `/web-setup` を実行するよう促します。[ターミナルから接続](/ja/web-quickstart#connect-from-your-terminal)で `/web-setup` のウォークスルーを参照してください。
 
 GitHub App は [Auto-fix](#auto-fix-pull-requests) に必須です。これは App を使用して PR webhook を受け取ります。`/web-setup` で接続し、後で Auto-fix が必要な場合は、それらのリポジトリに App をインストールします。
@@ -740,4 +744,6 @@ PR がどこから来たか、どのデバイスを使用しているかに応
 * **既存の PR**：PR URL をセッションに貼り付けて、Claude に auto-fix するよう指示します
 
+Auto-fix は PR ごとのトグルです。監視を停止するには、ウェブセッションで CI ステータスバーを開き、**Auto-fix** トグルをクリアするか、Claude に PR の監視を停止するよう指示します。
+
 ### Claude が PR アクティビティにどのように応答するか
```

</details>

<details>
<summary>commands-ja.md</summary>

```diff
diff --git a/docs-ja/pages/commands-ja.md b/docs-ja/pages/commands-ja.md
index ff8b82d..a6d1b69 100644
--- a/docs-ja/pages/commands-ja.md
+++ b/docs-ja/pages/commands-ja.md
@@ -122,5 +122,5 @@
 | `/tui [default\|fullscreen]`                    | ターミナル UI レンダラーを設定し、会話を保持したまま再起動します。`fullscreen` は[ちらつきなしの alt-screen レンダラー](/ja/fullscreen)を有効にします。引数なしで、アクティブなレンダラーを出力します                                                                                                                                                                                                                                                                                                                                                                                     |
 | `/ultraplan <prompt>`                           | [ultraplan](/ja/ultraplan) セッションで計画を作成し、ブラウザでレビューし、リモートで実行するか、ターミナルに送り返します                                                                                                                                                                                                                                                                                                                                                                                                                                     |
-| `/ultrareview [PR]`                             | [ultrareview](/ja/ultrareview) を使用してクラウドサンドボックスで深い複数エージェントコードレビューを実行します。Pro と Max に 3 つの無料実行が含まれ、2026 年 5 月 5 日まで、その後は [extra usage](https://support.claude.com/en/articles/12429409-extra-usage-for-paid-claude-plans) が必要です                                                                                                                                                                                                                                                                                  |
+| `/ultrareview [PR]`                             | [ultrareview](/ja/ultrareview) を使用してクラウドサンドボックスで深い複数エージェントコードレビューを実行します。Pro と Max に 3 つの無料実行が含まれ、その後は [extra usage](https://support.claude.com/en/articles/12429409-extra-usage-for-paid-claude-plans) が必要です                                                                                                                                                                                                                                                                                                   |
 | `/upgrade`                                      | アップグレードページを開いて、より高いプランティアに切り替えます                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
 | `/usage`                                        | セッションコスト、プラン使用制限、およびアクティビティ統計を表示します。サブスクリプション固有の詳細については、[コスト追跡ガイド](/ja/costs#using-the-%2Fusage-command)を参照してください。`/cost` と `/stats` はエイリアスです                                                                                                                                                                                                                                                                                                                                                                  |
```

</details>

<details>
<summary>headless-ja.md</summary>

```diff
diff --git a/docs-ja/pages/headless-ja.md b/docs-ja/pages/headless-ja.md
index 9a5267f..24f9538 100644
--- a/docs-ja/pages/headless-ja.md
+++ b/docs-ja/pages/headless-ja.md
@@ -7,11 +7,11 @@
 > Agent SDK を使用して、CLI、Python、または TypeScript からプログラムで Claude Code を実行します。
 
-[Agent SDK](/ja/agent-sdk/overview) は、Claude Code を支える同じツール、エージェントループ、およびコンテキスト管理を提供します。スクリプトと CI/CD 用の CLI として、または完全なプログラムによる制御のための [Python](/ja/agent-sdk/python) および [TypeScript](/ja/agent-sdk/typescript) パッケージとして利用できます。
-
 <Note>
-  CLI は以前「headless mode」と呼ばれていました。`-p` フラグとすべての CLI オプションは同じように機能します。
+  Starting June 15, 2026, Agent SDK and `claude -p` usage on subscription plans will draw from a new monthly Agent SDK credit, separate from your interactive usage limits. See [Use the Claude Agent SDK with your Claude plan](https://support.claude.com/en/articles/15036540-use-the-claude-agent-sdk-with-your-claude-plan) for details.
 </Note>
 
-CLI からプログラムで Claude Code を実行するには、プロンプトと任意の [CLI オプション](/ja/cli-reference) を指定して `-p` を渡します。
+[Agent SDK](/ja/agent-sdk/overview) は、Claude Code を支える同じツール、エージェントループ、およびコンテキスト管理を提供します。スクリプトと CI/CD 用の CLI として、または完全なプログラムによる制御のための [Python](/ja/agent-sdk/python) および [TypeScript](/ja/agent-sdk/typescript) パッケージとして利用できます。
+
+Claude Code を非対話型モードで実行するには、プロンプトと任意の [CLI オプション](/ja/cli-reference) を指定して `-p` を渡します。
 
 ```bash theme={null}
```

</details>

<details>
<summary>hooks-guide-ja.md</summary>

```diff
diff --git a/docs-ja/pages/hooks-guide-ja.md b/docs-ja/pages/hooks-guide-ja.md
index 67479d4..9c17b19 100644
--- a/docs-ja/pages/hooks-guide-ja.md
+++ b/docs-ja/pages/hooks-guide-ja.md
@@ -755,5 +755,5 @@ Hook を追加する場所がそのスコープを決定します：
 | [Skill](/ja/skills) または [agent](/ja/sub-agents) frontmatter | スキルまたはエージェントがアクティブなとき | はい、コンポーネントファイルで定義 |
 
-Claude Code で [`/hooks`](/ja/hooks#the-hooks-menu) を実行して、イベント別にグループ化されたすべての設定済み hooks を参照します。すべての hooks を一度に無効にするには、設定ファイルで `"disableAllHooks": true` を設定します。
+Claude Code で [`/hooks`](/ja/hooks#the-hooks-menu) を実行して、イベント別にグループ化されたすべての設定済み hooks を参照します。すべての hooks を一度に無効にするには、設定ファイルで `"disableAllHooks": true` を設定します。管理設定で設定された Hooks は、`disableAllHooks` がそこにも設定されていない限り、実行されます。
 
 Claude Code が実行中に設定ファイルを直接編集する場合、ファイルウォッチャーは通常、hook の変更を自動的に取得します。
```

</details>

*...以降省略*

</details>


<details>
<summary>2026-05-13</summary>

**変更ファイル:**

```
 docs-ja/pages/agent-teams-ja.md       |   2 +
 docs-ja/pages/agent-view-ja.md        |  15 +-
 docs-ja/pages/changelog.md            |  16 +++
 docs-ja/pages/claude-directory-ja.md  |   3 +-
 docs-ja/pages/cli-reference-ja.md     |   6 +-
 docs-ja/pages/data-usage-ja.md        |   4 +-
 docs-ja/pages/discover-plugins-ja.md  |   2 +
 docs-ja/pages/env-vars-ja.md          |  10 +-
 docs-ja/pages/fast-mode-ja.md         |  73 +++++++---
 docs-ja/pages/goal-ja.md              |   2 +-
 docs-ja/pages/hooks-guide-ja.md       |   2 +-
 docs-ja/pages/hooks-ja.md             |  17 ++-
 docs-ja/pages/mcp-ja.md               | 256 +++++-----------------------------
 docs-ja/pages/monitoring-usage-ja.md  |  18 +++
 docs-ja/pages/output-styles-ja.md     |   8 +-
 docs-ja/pages/permission-modes-ja.md  |   8 ++
 docs-ja/pages/permissions-ja.md       |  24 ++--
 docs-ja/pages/plugins-ja.md           |   6 +
 docs-ja/pages/plugins-reference-ja.md |   4 +-
 docs-ja/pages/routines-ja.md          |   4 +-
 docs-ja/pages/security-ja.md          |   2 +-
 docs-ja/pages/settings-ja.md          |  13 +-
 docs-ja/pages/skills-ja.md            |  10 +-
 23 files changed, 214 insertions(+), 291 deletions(-)
```

<details>
<summary>agent-teams-ja.md</summary>

```diff
diff --git a/docs-ja/pages/agent-teams-ja.md b/docs-ja/pages/agent-teams-ja.md
index 691d350..9e7818b 100644
--- a/docs-ja/pages/agent-teams-ja.md
+++ b/docs-ja/pages/agent-teams-ja.md
@@ -130,4 +130,6 @@ Use Sonnet for each teammate.
 ```
 
+チームメンバーはデフォルトではリーダーの `/model` 選択を継承しません。プロンプトで指定されていない場合に使用されるモデルを変更するには、`/config` で **Default teammate model** を設定してください。チームメンバーがリーダーの現在のモデルに従うようにするには、**Default (leader's model)** を選択してください。
+
 ### チームメンバーのプラン承認を要求する
 
```

</details>

<details>
<summary>agent-view-ja.md</summary>

```diff
diff --git a/docs-ja/pages/agent-view-ja.md b/docs-ja/pages/agent-view-ja.md
index ef45b0a..e888f27 100644
--- a/docs-ja/pages/agent-view-ja.md
+++ b/docs-ja/pages/agent-view-ja.md
@@ -59,5 +59,5 @@
 `claude agents` を実行してエージェントビューを開きます。ターミナル全体を占有し、状態でグループ化されたすべてのセッションをリストします。ピン留めされたセッションと入力が必要なセッションが上部に表示されます。各行はセッションの名前、現在のアクティビティ、最後に変更されてからの経過時間を表示します。
 
-リストはマシンに対してグローバルであり、どのプロジェクトまたはワークツリーで作業しているかに関係なく、[config ディレクトリ](#how-background-sessions-are-hosted)の下にあるすべてのバックグラウンドセッションを含みます。1 つのリポジトリで開始されたセッションと別のワークツリーで開始された別のセッションの両方が一緒に表示されます。他のターミナルで開いているインタラクティブセッションは、[バックグラウンドにする](#from-inside-a-session)までは表示されず、セッション内で実行している [subagents](/ja/sub-agents) は個別の行としてリストされません。
+リストは [config ディレクトリ](#how-background-sessions-are-hosted) の下にあるすべてのバックグラウンドセッションを含み、どのプロジェクトまたはワークツリーで作業しているかに関係なく、マシン全体をカバーします。1 つのリポジトリで開始されたセッションと別のワークツリーで開始された別のセッションの両方が一緒に表示されます。他のターミナルで開いているインタラクティブセッションは、[バックグラウンドにする](#from-inside-a-session)までは表示されず、セッション内で実行している [subagents](/ja/sub-agents) は個別の行としてリストされません。
 
 ```text theme={null}
@@ -66,5 +66,5 @@ Pinned
 
 Ready for review
-  ∙ jump physics              github.com/anthropics/example/pull/2048       2h
+  ∙ jump physics              github.com/anthropics/example/pull/2048    ●  2h
 
 Needs input
@@ -100,5 +100,14 @@ Completed
 各行の 1 行の概要は、設定された [Haiku クラスモデル](/ja/model-config) によって生成されるため、行はセッションが何をしているか、何が必要か、または何を生成したかをトランスクリプトを開かずに伝えることができます。セッションがアクティブに作業している間、概要は最大 15 秒ごとに 1 回、および各ターンが終了したときに 1 回更新されます。各更新は通常のプロバイダーを通じた 1 つの短い Haiku クラスリクエストであり、セッション自体と同じ [データ使用条件](/ja/data-usage) の下で請求および処理されます。
 
-セッションがプルリクエストを開くと、行は PR リンクと CI チェックのステータスインジケーターを表示します。ほとんどのタスクでは、この行が結果を収集する方法です。チェックが成功したときにプルリクエストをレビューしてマージします。
+セッションがプルリクエストを開くと、ステータスドットが行の右端に表示され、ハイパーリンクをサポートするターミナルではプルリクエストにリンクされます。セッションが複数のプルリクエストを開いた場合、カウントはドットの前に表示され、色はどれが最も注意が必要かを反映します。
+
+| ドットの色 | プルリクエストのステータス              |
+| :---- | :------------------------- |
+| 黄色    | チェックまたはレビューを待機中、またはチェックが失敗 |
+| 緑     | チェックが成功し、レビューがブロックされていない   |
+| 紫     | マージ済み                      |
+| グレー   | ドラフトまたはクローズ                |
```

</details>

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index af9c193..8a8624e 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,20 @@
 # Changelog
 
+## 2.1.140
+
+- Improved Agent tool `subagent_type` matching to accept case- and separator-insensitive values (e.g. `"Code Reviewer"` resolves to `code-reviewer`)
+- Updated agent color palette
+- Fixed `/goal` silently hanging when `disableAllHooks` or `allowManagedHooksOnly` is set — now shows a clear message instead of an indicator that never resolves
+- Fixed a regression in settings hot-reload where symlinked settings files caused misattributed change events and spurious `ConfigChange` hooks
+- Fixed `claude --bg` failing with "connection dropped mid-request" when the background service was about to idle-exit
+- Fixed background service startup failing on machines with enterprise endpoint security by allowing more time
+- Fixed remote managed settings not retrying on 401 — now retries once with a force-refreshed token
+- Fixed managed `extraKnownMarketplaces` auto-update policy not being persisted to `known_marketplaces.json`
+- Fixed `/loop` scheduling redundant wakeups to poll for background tasks that already notify on completion
+- Fixed a recurring event-loop stall on Windows when a missing executable (e.g. `gh`) triggered synchronous `where.exe` re-spawns on every check
+- Fixed `Read` tool calls failing validation when `offset` is passed as a whitespace-padded or `+`-prefixed string
+- Fixed native terminal cursor not staying at the input caret when the terminal loses focus
+- Plugins now warn when a default component folder (e.g. `commands/`) is silently ignored because `plugin.json` sets the matching key. Shown in `/doctor`, `claude plugin list`, and `/plugin`.
+
 ## 2.1.139
 
```

</details>

<details>
<summary>claude-directory-ja.md</summary>

```diff
diff --git a/docs-ja/pages/claude-directory-ja.md b/docs-ja/pages/claude-directory-ja.md
index 56d7d22..3e1b6a3 100644
--- a/docs-ja/pages/claude-directory-ja.md
+++ b/docs-ja/pages/claude-directory-ja.md
@@ -1498,4 +1498,5 @@ Windows では、`~/.claude` は `%USERPROFILE%\.claude` に解決されます
 | -------------------------------------------- | ------------------------------------------------------------------------------------ |
 | `projects/<project>/<session>.jsonl`         | 完全な会話トランスクリプト：すべてのメッセージ、ツール呼び出し、ツール結果                                                |
+| `projects/<project>/<session>/subagents/`    | [Subagent](/ja/sub-agents) 会話トランスクリプト。親セッショントランスクリプトが古くなると一緒に削除されます                  |
 | `projects/<project>/<session>/tool-results/` | 大きなツール出力を別ファイルにこぼしたもの                                                                |
 | `file-history/<session>/`                    | Claude が変更したファイルの編集前スナップショット。[チェックポイント復元](/ja/checkpointing)に使用                      |
@@ -1526,5 +1527,5 @@ Windows では、`~/.claude` は `%USERPROFILE%\.claude` に解決されます
 
 * `cleanupPeriodDays` を低くしてトランスクリプトの保持期間を短縮します
-* [`CLAUDE_CODE_SKIP_PROMPT_HISTORY`](/ja/env-vars)環境変数を設定して、任意のモードでトランスクリプトとプロンプト履歴の書き込みをスキップします。非対話型モードでは、代わりに `-p` と一緒に `--no-session-persistence` を渡すか、Agent SDK で `persistSession: false` を設定できます。
+* [`CLAUDE_CODE_SKIP_PROMPT_HISTORY`](/ja/env-vars) 環境変数を設定して、任意のモードでトランスクリプトとプロンプト履歴の書き込みをスキップします。非対話型モードでは、代わりに `-p` と一緒に `--no-session-persistence` を渡すか、Agent SDK で `persistSession: false` を設定できます。
 * [パーミッションルール](/ja/permissions)を使用して認証情報ファイルの読み込みを拒否します
 
```

</details>

<details>
<summary>cli-reference-ja.md</summary>

```diff
diff --git a/docs-ja/pages/cli-reference-ja.md b/docs-ja/pages/cli-reference-ja.md
index de6df18..951e0a9 100644
--- a/docs-ja/pages/cli-reference-ja.md
+++ b/docs-ja/pages/cli-reference-ja.md
@@ -68,5 +68,5 @@
 | `--effort`                                      | 現在のセッションの [努力レベル](/ja/model-config#adjust-effort-level) を設定します。オプション：`low`、`medium`、`high`、`xhigh`、`max`。利用可能なレベルはモデルによって異なります。[`effortLevel`](/ja/settings#available-settings) 設定をこのセッションでオーバーライドし、永続化されません                                                                                                                | `claude --effort high`                                                                             |
 | `--enable-auto-mode`                            | {/* max-version: 2.1.110 */}v2.1.111 で削除されました。Auto mode は現在 `Shift+Tab` サイクルにデフォルトで含まれています。`--permission-mode auto` を使用して開始してください                                                                                                                                                                                           | `claude --permission-mode auto`                                                                    |
-| `--exclude-dynamic-system-prompt-sections`      | システムプロンプトからマシンごとのセクション（作業ディレクトリ、環境情報、メモリパス、git ステータス）を最初のユーザーメッセージに移動します。異なるユーザーとマシンで同じタスクを実行する場合、prompt-cache の再利用を改善します。デフォルトシステムプロンプトにのみ適用されます。`--system-prompt` または `--system-prompt-file` が設定されている場合は無視されます。スクリプト化された複数ユーザーのワークロードの場合は `-p` と一緒に使用してください                                                               | `claude -p --exclude-dynamic-system-prompt-sections "query"`                                       |
+| `--exclude-dynamic-system-prompt-sections`      | システムプロンプトからマシンごとのセクション（作業ディレクトリ、環境情報、メモリパス、git リポジトリフラグ）を最初のユーザーメッセージに移動します。異なるユーザーとマシンで同じタスクを実行する場合、prompt-cache の再利用を改善します。デフォルトシステムプロンプトにのみ適用されます。`--system-prompt` または `--system-prompt-file` が設定されている場合は無視されます。スクリプト化された複数ユーザーのワークロードの場合は `-p` と一緒に使用してください                                                            | `claude -p --exclude-dynamic-system-prompt-sections "query"`                                       |
 | `--fallback-model`                              | デフォルトモデルが過負荷の場合、指定されたモデルへの自動フォールバックを有効にします（プリントモードのみ）                                                                                                                                                                                                                                                                       | `claude -p --fallback-model sonnet "query"`                                                        |
 | `--fork-session`                                | 再開時に、元のセッション ID を再利用する代わりに新しいセッション ID を作成します（`--resume` または `--continue` と一緒に使用）                                                                                                                                                                                                                                            | `claude --resume abc123 --fork-session`                                                            |
@@ -125,5 +125,7 @@ Claude Code は、システムプロンプトをカスタマイズするため
 `--system-prompt` と `--system-prompt-file` は相互に排他的です。追加フラグは、置き換えフラグのいずれかと組み合わせることができます。
 
-ほとんどのユースケースでは、追加フラグを使用してください。追加することで、Claude Code の組み込み機能を保持しながら、要件を追加できます。置き換えフラグは、システムプロンプトを完全に制御する必要がある場合にのみ使用してください。
+Claude Code のデフォルトの ID がタスクに適合しているかどうかに基づいて選択してください。Claude が追加のルールも従うコーディングアシスタントのままである場合は、追加フラグを使用してください：呼び出しごとの指示、出力形式設定、または `-p` スクリプトのドメインコンテキスト。追加することで、デフォルトのツールガイダンス、安全指示、およびコーディング規約が保持されるため、異なる部分のみを提供します。システムプロンプトの表面、ID、または権限モデルが Claude Code のものと異なる場合は、置き換えフラグを使用してください。例えば、人間が監視していないパイプラインの非コーディングエージェント。置き換えることで、デフォルトプロンプト全体が削除されます。ツールガイダンスと安全指示を含めて、タスクがまだ必要とするものについて責任を負います。
+
+これらのフラグは現在の呼び出しにのみ適用されます。プロジェクト全体で切り替えて共有できる永続的なペルソナについては、[出力スタイル](/ja/output-styles) を使用してください。Claude が常に従うべきプロジェクト規約については、[CLAUDE.md](/ja/memory) を使用してください。[Agent SDK ガイドのシステムプロンプト](/ja/agent-sdk/modifying-system-prompts#decide-on-a-starting-point) は、より詳細に同じ決定をカバーしています。
 
 ## 関連項目
```

</details>

<details>
<summary>data-usage-ja.md</summary>

```diff
diff --git a/docs-ja/pages/data-usage-ja.md b/docs-ja/pages/data-usage-ja.md
index d326c51..a165950 100644
--- a/docs-ja/pages/data-usage-ja.md
+++ b/docs-ja/pages/data-usage-ja.md
@@ -34,7 +34,7 @@ Claude Code で「How is Claude doing this session?」プロンプトが表示
 * **Don't ask again**：拒否し、今後のセッションでこのフォローアップが表示されなくなります
 
-**Yes** を明示的に選択しない限り、何もアップロードされません。[ゼロデータ保持](/ja/zero-data-retention) を設定している組織、または組織ポリシーで製品フィードバックが無効になっている組織は、このフォローアップを表示しません。数値評価プロンプトの後に送信されたセッショントランスクリプトを含む、この調査への応答は、データトレーニング設定に影響を与えず、AI モデルをトレーニングするために使用することはできません。
+**Yes** を明示的に選択しない限り、何もアップロードされません。[ゼロデータ保持](/ja/zero-data-retention) を設定している組織、または組織ポリシーで製品フィードバックが無効になっている組織、または `CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC` が設定されている組織は、このフォローアップを表示しません。数値評価プロンプトの後に送信されたセッショントランスクリプトを含む、この調査への応答は、データトレーニング設定に影響を与えず、AI モデルをトレーニングするために使用することはできません。
 
-これらの調査を無効にするには、`CLAUDE_CODE_DISABLE_FEEDBACK_SURVEY=1` を設定します。調査は、`DISABLE_TELEMETRY` または `CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC` が設定されている場合にも無効になります。無効にする代わりに頻度を制御するには、設定ファイルで [`feedbackSurveyRate`](/ja/settings#available-settings) を `0` から `1` の間の確率に設定します。
+これらの調査を無効にするには、`CLAUDE_CODE_DISABLE_FEEDBACK_SURVEY=1` を設定します。調査は、`DISABLE_TELEMETRY`、`DO_NOT_TRACK`、または `CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC` が設定されている場合にも無効になります。無効にする代わりに頻度を制御するには、設定ファイルで [`feedbackSurveyRate`](/ja/settings#available-settings) を `0` から `1` の間の確率に設定します。非必須トラフィックをブロックしているが、独自の [OpenTelemetry collector](/ja/monitoring-usage) を通じて調査応答をキャプチャしている組織は、`CLAUDE_CODE_ENABLE_FEEDBACK_SURVEY_FOR_OTEL=1` を設定することで調査をオプトバックインできます。調査は、設定されたコレクターのみに数値評価をログします。トランスクリプト共有フォローアップおよび他のすべての Anthropic バウンドフィードバックトラフィックは無効のままです。
 
 ### データ保持
```

</details>

<details>
<summary>discover-plugins-ja.md</summary>

```diff
diff --git a/docs-ja/pages/discover-plugins-ja.md b/docs-ja/pages/discover-plugins-ja.md
index ca4164c..5116c21 100644
--- a/docs-ja/pages/discover-plugins-ja.md
+++ b/docs-ja/pages/discover-plugins-ja.md
@@ -365,4 +365,6 @@ UI を通じて個別のマーケットプレイスの自動更新を切り替
 公式 Anthropic マーケットプレイスはデフォルトで自動更新が有効になっています。サードパーティおよびローカル開発マーケットプレイスはデフォルトで自動更新が無効になっています。
 
+管理者は、マネージド設定で各 [`extraKnownMarketplaces`](/ja/settings#extraknownmarketplaces) エントリに `"autoUpdate": true` を設定して、各ユーザーが切り替える必要なく、組織マーケットプレイスの自動更新を有効にすることもできます。
+
 Claude Code とすべてのプラグインの両方のすべての自動更新を完全に無効化するには、`DISABLE_AUTOUPDATER` 環境変数を設定します。詳細については、[自動更新](/ja/setup#auto-updates)を参照してください。
 
```

</details>

<details>
<summary>env-vars-ja.md</summary>

```diff
diff --git a/docs-ja/pages/env-vars-ja.md b/docs-ja/pages/env-vars-ja.md
index 981ce2c..3e142e8 100644
--- a/docs-ja/pages/env-vars-ja.md
+++ b/docs-ja/pages/env-vars-ja.md
@@ -82,5 +82,5 @@ Claude Code は、その動作を制御するために以下の環境変数を
 | `CLAUDE_CODE_DISABLE_EXPERIMENTAL_BETAS`                | Anthropic 固有の `anthropic-beta` リクエストヘッダーと beta ツールスキーマフィールド（`defer_loading` や `eager_input_streaming` など）を API リクエストから削除するには `1` に設定します。プロキシゲートウェイが「`anthropic-beta` ヘッダーの予期しない値」や「追加の入力は許可されていません」などのエラーでリクエストを拒否する場合に使用します。標準フィールド（`name`、`description`、`input_schema`、`cache_control`）は保持されます。                                                                                                                              |
 | `CLAUDE_CODE_DISABLE_FAST_MODE`                         | [高速モード](/ja/fast-mode) を無効にするには `1` に設定します                                                                                                                                                                                                                                                                                                                                                                                     |
-| `CLAUDE_CODE_DISABLE_FEEDBACK_SURVEY`                   | 「Claude の調子はどうですか？」セッション品質調査を無効にするには `1` に設定します。`DISABLE_TELEMETRY` または `CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC` が設定されている場合も調査は無効になります。サンプルレートを設定する代わりに、[`feedbackSurveyRate`](/ja/settings#available-settings) 設定を使用します。[セッション品質調査](/ja/data-usage#session-quality-surveys) を参照してください                                                                                                                                       |
+| `CLAUDE_CODE_DISABLE_FEEDBACK_SURVEY`                   | 「Claude の調子はどうですか？」セッション品質調査を無効にするには `1` に設定します。`DISABLE_TELEMETRY`、`DO_NOT_TRACK`、または `CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC` が設定されている場合も調査は無効になります。`CLAUDE_CODE_ENABLE_FEEDBACK_SURVEY_FOR_OTEL` でオプトバックインしない限り。サンプルレートを設定する代わりに、[`feedbackSurveyRate`](/ja/settings#available-settings) 設定を使用します。[セッション品質調査](/ja/data-usage#session-quality-surveys) を参照してください                                                           |
 | `CLAUDE_CODE_DISABLE_FILE_CHECKPOINTING`                | ファイル [チェックポイント](/ja/checkpointing) を無効にするには `1` に設定します。`/rewind` コマンドはコード変更を復元できなくなります                                                                                                                                                                                                                                                                                                                                         |
 | `CLAUDE_CODE_DISABLE_GIT_INSTRUCTIONS`                  | Claude のシステムプロンプトから組み込みのコミットと PR ワークフロー命令と git ステータススナップショットを削除するには `1` に設定します。独自の git ワークフロースキルを使用する場合に役立ちます。設定されている場合、[`includeGitInstructions`](/ja/settings#available-settings) 設定よりも優先されます                                                                                                                                                                                                                                |
@@ -97,6 +97,8 @@ Claude Code は、その動作を制御するために以下の環境変数を
 | `CLAUDE_CODE_ENABLE_AWAY_SUMMARY`                       | [セッションリキャップ](/ja/interactive-mode#session-recap) の利用可能性をオーバーライドします。`/config` トグルに関係なくリキャップを強制的にオフにするには `0` に設定します。[`awaySummaryEnabled`](/ja/settings#available-settings) が `false` の場合にリキャップを強制的にオンにするには `1` に設定します。設定と `/config` トグルより優先されます                                                                                                                                                                                 |
 | `CLAUDE_CODE_ENABLE_BACKGROUND_PLUGIN_REFRESH`          | [非対話モード](/ja/headless) でバックグラウンドインストールが完了した後、ターン境界でプラグイン状態をリフレッシュするには `1` に設定します。リフレッシュはセッション中にシステムプロンプトを変更するため、デフォルトではオフです。これにより、そのターンの [プロンプトキャッシング](https://platform.claude.com/docs/en/build-with-claude/prompt-caching) が無効になります                                                                                                                                                                                          |
+| `CLAUDE_CODE_ENABLE_FEEDBACK_SURVEY_FOR_OTEL`           | Anthropic バウンドの非必須トラフィックがブロックされている場合、「Claude の調子はどうですか？」セッション品質調査を独自の [OpenTelemetry コレクター](/ja/monitoring-usage) にルーティングするには `1` に設定します。調査の評価は OTEL イベントとしてのみ設定されたコレクターに出力されます。このモードでは調査データは Anthropic に送信されません。`CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC`、`DISABLE_TELEMETRY`、または `DO_NOT_TRACK` が設定されている場合に適用され、それ以外の場合は効果がありません。`CLAUDE_CODE_DISABLE_FEEDBACK_SURVEY` と組織製品フィードバックポリシーが優先されます                              |
 | `CLAUDE_CODE_ENABLE_FINE_GRAINED_TOOL_STREAMING`        | ツール呼び出し入力が Claude によって生成されるときに API からストリーミングされるかどうかを制御します。これがない場合、大きなツール入力（長いファイル書き込みなど）は Claude が生成を完了した後にのみ到着します。これは、ハングしているように見える可能性があります。Anthropic API 直接接続でデフォルトで有効です。Bedrock と Vertex では、デプロイされたコンテナがサポートしているモデルごとに有効です。`0` に設定してオプトアウトします。`1` に設定して、`ANTHROPIC_BASE_URL`、`ANTHROPIC_VERTEX_BASE_URL`、または `ANTHROPIC_BEDROCK_BASE_URL` を通じてプロキシにルーティングする場合に強制的に有効にします。Foundry と [ゲートウェイ](/ja/llm-gateway) 接続ではデフォルトでオフです |
 | `CLAUDE_CODE_ENABLE_GATEWAY_MODEL_DISCOVERY`            | `ANTHROPIC_BASE_URL` が LiteLLM、Kong、または内部プロキシなどの Anthropic 互換ゲートウェイを指している場合、ゲートウェイの `/v1/models` エンドポイントから `/model` ピッカーを入力するには `1` に設定します。共有 API キーでバックアップされたゲートウェイはそれ以外の場合、すべてのユーザーにキーがアクセスできるすべてのモデルを表示するため、デフォルトではオフです。検出されたモデルは依然として [`availableModels`](/ja/settings#available-settings) 許可リストでフィルタリングされます                                                                                                               |
+| `CLAUDE_CODE_ENABLE_OPUS_4_7_FAST_MODE`                 | [高速モード](/ja/fast-mode) を Claude Opus 4.7 で実行するには `1` に設定します。Opus 4.6 の代わりに。変数が設定されている場合、`/fast` は Opus 4.7 に切り替わります。設定されていない場合、`/fast` は引き続き Opus 4.6 を使用します                                                                                                                                                                                                                                                                   |
 | `CLAUDE_CODE_ENABLE_PROMPT_SUGGESTION`                  | プロンプト提案を無効にするには `false` に設定します（`/config` の「プロンプト提案」トグル）。これらは Claude が応答した後にプロンプト入力に表示される灰色の予測です。[プロンプト提案](/ja/interactive-mode#prompt-suggestions) を参照してください                                                                                                                                                                                                                                                                   |
 | `CLAUDE_CODE_ENABLE_TASKS`                              | 非対話モード（`-p` フラグ）でタスク追跡システムを有効にするには `1` に設定します。タスクは対話モードではデフォルトでオンです。[タスクリスト](/ja/interactive-mode#task-list) を参照してください                                                                                                                                                                                                                                                                                                         |
@@ -128,4 +130,5 @@ Claude Code は、その動作を制御するために以下の環境変数を
 | `CLAUDE_CODE_OAUTH_SCOPES`                              | リフレッシュトークンが発行されたスペース区切りの OAuth スコープ（例：`"user:profile user:inference user:sessions:claude_code"`）。`CLAUDE_CODE_OAUTH_REFRESH_TOKEN` が設定されている場合は必須です                                                                                                                                                                                                                                                                             |
 | `CLAUDE_CODE_OAUTH_TOKEN`                               | Claude.ai 認証用の OAuth アクセストークン。SDK および自動化された環境での `/login` の代替。キーチェーンに保存された認証情報よりも優先されます。[`claude setup-token`](/ja/authentication#generate-a-long-lived-token) で生成します                                                                                                                                                                                                                                                           |
+| `CLAUDE_CODE_OPUS_4_6_FAST_MODE_OVERRIDE`               | [高速モード](/ja/fast-mode) を Claude Opus 4.6 で保持するには `1` に設定します。`CLAUDE_CODE_ENABLE_OPUS_4_7_FAST_MODE` より優先されるため、デフォルトの変更方法に関係なく Opus 4.6 をピンする必要がある場合に設定します                                                                                                                                                                                                                                                                      |
 | `CLAUDE_CODE_OTEL_FLUSH_TIMEOUT_MS`                     | 保留中の OpenTelemetry スパンをフラッシュするためのタイムアウト（ミリ秒）（デフォルト：5000）。[監視](/ja/monitoring-usage) を参照してください                                                                                                                                                                                                                                                                                                                                  |
 | `CLAUDE_CODE_OTEL_HEADERS_HELPER_DEBOUNCE_MS`           | 動的 OpenTelemetry ヘッダーをリフレッシュする間隔（ミリ秒）（デフォルト：1740000 / 29 分）。[動的ヘッダー](/ja/monitoring-usage#dynamic-headers) を参照してください                                                                                                                                                                                                                                                                                                           |
@@ -142,4 +145,5 @@ Claude Code は、その動作を制御するために以下の環境変数を
 | `CLAUDE_CODE_REMOTE_SESSION_ID`                         | [クラウドセッション](/ja/claude-code-on-the-web) で現在のセッションの ID に自動的に設定されます。セッショントランスクリプトへのリンクを構築するために読み取ります。[セッションにアーティファクトをリンク](/ja/claude-code-on-the-web#link-artifacts-back-to-the-session) を参照してください                                                                                                                                                                                                                               |
 | `CLAUDE_CODE_RESUME_INTERRUPTED_TURN`                   | 前のセッションが途中で終了した場合に自動的に再開するには `1` に設定します。SDK モードで使用されるため、モデルは SDK がプロンプトを再送信する必要なく続行します                                                                                                                                                                                                                                                                                                                                         |
+| `CLAUDE_CODE_RESUME_PROMPT`                             | セッションが途中で終了した場合に再開するときに挿入される継続メッセージをオーバーライドします。デフォルトは `Continue from where you left off.` です。長時間実行されるエージェント用のスポーンスクリプトは、これをより指示的なブートメッセージに設定できます。空の文字列はデフォルトを使用します                                                                                                                                                                                                                                                             |
```

</details>

*...以降省略*

</details>


<details>
<summary>2026-05-12</summary>

**変更ファイル:**

```
 docs-ja/pages/admin-setup-ja.md              |   3 +-
 docs-ja/pages/changelog.md                   |  53 +++
 docs-ja/pages/claude-directory-ja.md         |  46 +-
 docs-ja/pages/cli-reference-ja.md            |   8 +-
 docs-ja/pages/commands-ja.md                 |   7 +-
 docs-ja/pages/common-workflows-ja.md         | 684 ++++-----------------------
 docs-ja/pages/data-usage-ja.md               |  24 +-
 docs-ja/pages/env-vars-ja.md                 |  17 +-
 docs-ja/pages/fullscreen-ja.md               |   2 +
 docs-ja/pages/glossary-ja.md                 |  18 +-
 docs-ja/pages/hooks-guide-ja.md              |   4 +-
 docs-ja/pages/hooks-ja.md                    | 122 +++--
 docs-ja/pages/interactive-mode-ja.md         |  45 +-
 docs-ja/pages/keybindings-ja.md              |   2 +-
 docs-ja/pages/llm-gateway-ja.md              |  61 ++-
 docs-ja/pages/mcp-ja.md                      |  10 +-
 docs-ja/pages/memory-ja.md                   |  20 +-
 docs-ja/pages/model-config-ja.md             |   8 +-
 docs-ja/pages/monitoring-usage-ja.md         |  75 ++-
 docs-ja/pages/output-styles-ja.md            |   4 +-
 docs-ja/pages/overview-ja.md                 |   2 +-
 docs-ja/pages/permission-modes-ja.md         |  22 +-
 docs-ja/pages/permissions-ja.md              |   8 +-
 docs-ja/pages/plugins-reference-ja.md        |  78 ++-
 docs-ja/pages/quickstart-ja.md               |   4 +-
 docs-ja/pages/scheduled-tasks-ja.md          |  10 +-
 docs-ja/pages/settings-ja.md                 |   2 +
 docs-ja/pages/sub-agents-ja.md               |  14 +-
 docs-ja/pages/third-party-integrations-ja.md |  18 +-
 docs-ja/pages/tools-reference-ja.md          | 257 ++++++++--
 docs-ja/pages/vs-code-ja.md                  |  56 +--
 31 files changed, 842 insertions(+), 842 deletions(-)
```

**新規追加:**


<details>
<summary>admin-setup-ja.md</summary>

```diff
diff --git a/docs-ja/pages/admin-setup-ja.md b/docs-ja/pages/admin-setup-ja.md
index 64e4f81..118bc30 100644
--- a/docs-ja/pages/admin-setup-ja.md
+++ b/docs-ja/pages/admin-setup-ja.md
@@ -64,5 +64,5 @@ plist と HKLM レジストリの場所は任意のプロバイダーで機能
 ## 実行する内容を決定する
 
-マネージド設定は、ツール、サンドボックス実行、MCP サーバーとプラグインソースへのアクセスをロックダウンし、実行されるフックを制御できます。各行は、それを駆動する設定キーを持つ制御サーフェスです。
+マネージド設定は、ツール、サンドボックス実行、MCP サーバーとプラグインソースへのアクセスをロックダウンし、実行されるフック を制御できます。各行は、それを駆動する設定キーを持つ制御サーフェスです。
 
 | 制御                                                                                     | 機能                                                              | キー設定                                                                         |
@@ -75,4 +75,5 @@ plist と HKLM レジストリの場所は任意のプロバイダーで機能
 | [Plugin marketplace control](/ja/plugin-marketplaces#managed-marketplace-restrictions) | ユーザーが追加およびインストールできるマーケットプレイスソースを制限する                            | `strictKnownMarketplaces`、`blockedMarketplaces`                              |
 | [Hook restrictions](/ja/settings#hook-configuration)                                   | マネージドフックのみが読み込まれる。HTTP フック URL を制限する                            | `allowManagedHooksOnly`、`allowedHttpHookUrls`                                |
+| [Disable agent view](/ja/agent-view#how-background-sessions-are-hosted)                | `claude agents`、`--bg`、`/background`、およびオンデマンドスーパーバイザーをオフにする    | `disableAgentView`                                                           |
 | [Version floor](/ja/settings)                                                          | 自動更新が組織全体の最小値より下にインストールされるのを防ぐ                                  | `minimumVersion`                                                             |
 
```

</details>

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index 3e8bd69..af9c193 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,57 @@
 # Changelog
 
+## 2.1.139
+
+- Added agent view (Research Preview): a single list of every Claude Code session — running, blocked on you, or done. Run `claude agents` to get started. See https://code.claude.com/docs/en/agent-view
+- Added `/goal` command: set a completion condition and Claude keeps working across turns until it's met. Works in interactive, `-p`, and Remote Control. Shows live elapsed/turns/tokens as an overlay panel
+- Added `/scroll-speed` command to tune mouse wheel scroll speed with a live preview
+- Added `claude plugin details <name>` to show a plugin's component inventory and projected per-session token cost
+- Added transcript view navigation: `?` for keyboard shortcuts, `{`/`}` to jump between user prompts, `v` to toggle shortcut panel
+- Added hook `args: string[]` field (exec form) that spawns the command directly without a shell, so path placeholders never need quoting
+- Added hook `continueOnBlock` config option for `PostToolUse` — set to `true` to feed the hook's rejection reason back to Claude and continue the turn
+- MCP stdio servers now receive `CLAUDE_PROJECT_DIR` in their environment, matching hooks. Plugin configs can reference `${CLAUDE_PROJECT_DIR}` in commands
+- Compaction prompt now asks the model to preserve sensitive user instructions
+- `/mcp` Reconnect now picks up `.mcp.json` edits without a restart, and shows the HTTP status and URL when reconnecting fails
+- `/context all` per-skill token estimates now account for the model's tokenizer and show rounded values
+- `claude plugin install <name>@<marketplace>` now auto-refreshes the marketplace and retries before reporting a plugin as not found
+- `/plugin` installed-plugin details now show hook event names and MCP server names cleanly
+- `/context` now shows the providing plugin's name for plugin-sourced skills
+- Remote MCP server reconnect retry on transient failures is now enabled for all users
+- API requests from subagents now carry `x-claude-code-agent-id` / `x-claude-code-parent-agent-id` headers, and `claude_code.llm_request` OTEL spans include `agent_id` / `parent_agent_id` attributes
+- Remote Control, `/schedule`, claude.ai MCP connectors, and notification preferences are now disabled when `ANTHROPIC_API_KEY` / `apiKeyHelper` / `ANTHROPIC_AUTH_TOKEN` is set, even if a Claude.ai login also exists. Unset the API key to use these features
+- Fixed a deadlock where expired credentials and the `forceRemoteSettingsRefresh` policy setting blocked `claude auth login`/`logout`/`status` with no way to recover
+- Fixed `autoAllowBashIfSandboxed` not auto-approving commands with shell expansions like `$VAR` and `$(cmd)`
+- Fixed a bug where a hook writing to the terminal could corrupt an on-screen interactive prompt; hooks now run without terminal access
+- Fixed unbounded memory growth when an HTTP/SSE MCP server streams non-protocol data — response bodies now capped at 16 MB per SSE frame
```

</details>

<details>
<summary>claude-directory-ja.md</summary>

```diff
diff --git a/docs-ja/pages/claude-directory-ja.md b/docs-ja/pages/claude-directory-ja.md
index c270b4e..56d7d22 100644
--- a/docs-ja/pages/claude-directory-ja.md
+++ b/docs-ja/pages/claude-directory-ja.md
@@ -1465,21 +1465,21 @@ Windows では、`~/.claude` は `%USERPROFILE%\.claude` に解決されます
 ファイル名をクリックして、上記のエクスプローラーでそのノードを開きます。
 
-| ファイル                                                | スコープ           | コミット | 機能                                     | リファレンス                                                               |
-| --------------------------------------------------- | -------------- | ---- | -------------------------------------- | -------------------------------------------------------------------- |
-| [`CLAUDE.md`](#ce-claude-md)                        | プロジェクトおよびグローバル | ✓    | 毎セッション読み込まれる指示                         | [メモリ](/ja/memory)                                                    |
-| [`rules/*.md`](#ce-rules)                           | プロジェクトおよびグローバル | ✓    | トピックスコープの指示、オプションでパスゲート                | [ルール](/ja/memory#organize-rules-with-claude/rules/)                  |
-| [`settings.json`](#ce-settings-json)                | プロジェクトおよびグローバル | ✓    | パーミッション、hooks、環境変数、モデルデフォルト            | [設定](/ja/settings)                                                   |
-| [`settings.local.json`](#ce-settings-local-json)    | プロジェクトのみ       |      | 個人的なオーバーライド、自動 gitignore               | [設定スコープ](/ja/settings#settings-files)                                |
-| [`.mcp.json`](#ce-mcp-json)                         | プロジェクトのみ       | ✓    | チーム共有 MCP サーバー                         | [MCP スコープ](/ja/mcp#mcp-installation-scopes)                          |
-| [`.worktreeinclude`](#ce-worktreeinclude)           | プロジェクトのみ       | ✓    | 新しい worktrees にコピーする gitignore ファイル    | [Worktrees](/ja/common-workflows#copy-gitignored-files-to-worktrees) |
-| [`skills/<name>/SKILL.md`](#ce-skills)              | プロジェクトおよびグローバル | ✓    | `/name` で呼び出される、または自動呼び出される再利用可能なプロンプト | [Skills](/ja/skills)                                                 |
-| [`commands/*.md`](#ce-commands)                     | プロジェクトおよびグローバル | ✓    | シングルファイルプロンプト。skills と同じメカニズム          | [Skills](/ja/skills)                                                 |
-| [`output-styles/*.md`](#ce-output-styles)           | プロジェクトおよびグローバル | ✓    | カスタムシステムプロンプトセクション                     | [出力スタイル](/ja/output-styles)                                          |
-| [`agents/*.md`](#ce-agents)                         | プロジェクトおよびグローバル | ✓    | 独自のプロンプトとツールを持つ subagent 定義            | [Subagents](/ja/sub-agents)                                          |
-| [`agent-memory/<name>/`](#ce-agent-memory)          | プロジェクトおよびグローバル | ✓    | subagents の永続メモリ                       | [永続メモリ](/ja/sub-agents#enable-persistent-memory)                     |
-| [`~/.claude.json`](#ce-claude-json)                 | グローバルのみ        |      | アプリ状態、OAuth、UI トグル、個人 MCP サーバー         | [グローバル設定](/ja/settings#global-config-settings)                       |
-| [`projects/<project>/memory/`](#ce-global-projects) | グローバルのみ        |      | Auto memory：Claude のセッション間のメモ          | [Auto memory](/ja/memory#auto-memory)                                |
-| [`keybindings.json`](#ce-keybindings)               | グローバルのみ        |      | カスタムキーボードショートカット                       | [キーバインディング](/ja/keybindings)                                         |
-| [`themes/*.json`](#ce-themes)                       | グローバルのみ        |      | カスタムカラーテーマ                             | [カスタムテーマ](/ja/terminal-config#create-a-custom-theme)                 |
+| ファイル                                                | スコープ           | コミット | 機能                                     | リファレンス                                                          |
+| --------------------------------------------------- | -------------- | ---- | -------------------------------------- | --------------------------------------------------------------- |
+| [`CLAUDE.md`](#ce-claude-md)                        | プロジェクトおよびグローバル | ✓    | 毎セッション読み込まれる指示                         | [メモリ](/ja/memory)                                               |
+| [`rules/*.md`](#ce-rules)                           | プロジェクトおよびグローバル | ✓    | トピックスコープの指示、オプションでパスゲート                | [ルール](/ja/memory#organize-rules-with-claude/rules/)             |
+| [`settings.json`](#ce-settings-json)                | プロジェクトおよびグローバル | ✓    | パーミッション、hooks、環境変数、モデルデフォルト            | [設定](/ja/settings)                                              |
+| [`settings.local.json`](#ce-settings-local-json)    | プロジェクトのみ       |      | 個人的なオーバーライド、自動 gitignore               | [設定スコープ](/ja/settings#settings-files)                           |
```

</details>

<details>
<summary>cli-reference-ja.md</summary>

```diff
diff --git a/docs-ja/pages/cli-reference-ja.md b/docs-ja/pages/cli-reference-ja.md
index c81bcc0..de6df18 100644
--- a/docs-ja/pages/cli-reference-ja.md
+++ b/docs-ja/pages/cli-reference-ja.md
@@ -25,11 +25,16 @@
 | `claude auth logout`            | Anthropic アカウントからログアウト                                                                                                                                                                                                                                                                                         | `claude auth logout`                                        |
 | `claude auth status`            | 認証ステータスを JSON として表示します。`--text` を使用して人間が読める形式で表示できます。ログイン済みの場合はコード 0 で終了し、ログインしていない場合は 1 で終了します                                                                                                                                                                                                                | `claude auth status`                                        |
-| `claude agents`                 | すべての設定済み [subagents](/ja/sub-agents) をソース別にグループ化して一覧表示                                                                                                                                                                                                                                                         | `claude agents`                                             |
+| `claude agents`                 | [エージェントビュー](/ja/agent-view) を開いて、並列バックグラウンドセッションを監視およびディスパッチします。出力がパイプされている場合は、代わりに設定済み [subagents](/ja/sub-agents) を一覧表示します                                                                                                                                                                                   | `claude agents`                                             |
+| `claude attach <id>`            | このターミナルで [バックグラウンドセッション](/ja/agent-view#manage-sessions-from-the-shell) に接続します                                                                                                                                                                                                                                 | `claude attach 7c5dcf5d`                                    |
 | `claude auto-mode defaults`     | 組み込み [auto mode](/ja/permission-modes#eliminate-prompts-with-auto-mode) 分類器ルールを JSON として出力します。`claude auto-mode config` を使用して、設定が適用された有効な設定を確認してください                                                                                                                                                           | `claude auto-mode defaults > rules.json`                    |
+| `claude logs <id>`              | [バックグラウンドセッション](/ja/agent-view#manage-sessions-from-the-shell) からの最近の出力を出力します                                                                                                                                                                                                                                  | `claude logs 7c5dcf5d`                                      |
 | `claude mcp`                    | Model Context Protocol（MCP）サーバーを設定                                                                                                                                                                                                                                                                             | [Claude Code MCP ドキュメント](/ja/mcp) を参照してください。                |
 | `claude plugin`                 | Claude Code [plugins](/ja/plugins) を管理します。エイリアス：`claude plugins`。サブコマンドについては [plugin reference](/ja/plugins-reference#cli-commands-reference) を参照してください                                                                                                                                                        | `claude plugin install code-review@claude-plugins-official` |
 | `claude project purge [path]`   | プロジェクトのすべてのローカル Claude Code 状態を削除します：トランスクリプト、タスクリスト、デバッグログ、ファイル編集履歴、プロンプト履歴行、および `~/.claude.json` 内のプロジェクトエントリ。`[path]` を省略して、インタラクティブリストから選択します。フラグ：`--dry-run` でプレビュー、`-y`/`--yes` で確認をスキップ、`-i`/`--interactive` で各項目を確認、`--all` ですべてのプロジェクト。[ローカルデータをクリア](/ja/claude-directory#clear-local-data) を参照してください | `claude project purge ~/work/repo --dry-run`                |
 | `claude remote-control`         | [Remote Control](/ja/remote-control) サーバーを開始して、Claude.ai または Claude アプリから Claude Code を制御します。サーバーモード（ローカルインタラクティブセッションなし）で実行されます。[サーバーモードフラグ](/ja/remote-control#start-a-remote-control-session) を参照してください                                                                                                     | `claude remote-control --name "My Project"`                 |
+| `claude respawn <id>`           | 会話を保持したまま、停止した [バックグラウンドセッション](/ja/agent-view#manage-sessions-from-the-shell) を再開します。`--all` を使用してすべての停止したセッションを再開します                                                                                                                                                                                          | `claude respawn 7c5dcf5d`                                   |
+| `claude rm <id>`                | [バックグラウンドセッション](/ja/agent-view#manage-sessions-from-the-shell) をリストから削除します                                                                                                                                                                                                                                     | `claude rm 7c5dcf5d`                                        |
 | `claude setup-token`            | CI とスクリプト用の長期間有効な OAuth トークンを生成します。ターミナルにトークンを出力し、保存しません。Claude サブスクリプションが必要です。[長期間有効なトークンを生成](/ja/authentication#generate-a-long-lived-token) を参照してください                                                                                                                                                       | `claude setup-token`                                        |
+| `claude stop <id>`              | [バックグラウンドセッション](/ja/agent-view#manage-sessions-from-the-shell) を停止します。`claude kill` も受け入れます                                                                                                                                                                                                                    | `claude stop 7c5dcf5d`                                      |
 | `claude ultrareview [target]`   | [ultrareview](/ja/ultrareview#run-ultrareview-non-interactively) を非対話的に実行します。結果を stdout に出力し、成功時は 0 で終了し、失敗時は 1 で終了します。`--json` を使用して生のペイロードを取得し、`--timeout <minutes>` を使用して 30 分のデフォルトをオーバーライドできます                                                                                                            | `claude ultrareview 1234 --json`                            |
 
@@ -51,4 +56,5 @@
 | `--bare`                                        | 最小限モード：hooks、skills、plugins、MCP サーバー、自動メモリ、CLAUDE.md の自動検出をスキップして、スクリプト化された呼び出しをより高速に開始します。Claude は Bash、ファイル読み取り、ファイル編集ツールにアクセスできます。[`CLAUDE_CODE_SIMPLE`](/ja/env-vars) を設定します。[bare mode](/ja/headless#start-faster-with-bare-mode) を参照してください                                                                            | `claude --bare -p "query"`                                                                         |
 | `--betas`                                       | API リクエストに含めるベータヘッダー（API キーユーザーのみ）                                                                                                                                                                                                                                                                                          | `claude --betas interleaved-thinking`                                                              |
+| `--bg`                                          | セッションを [バックグラウンドエージェント](/ja/agent-view) として開始し、すぐに戻ります。セッション ID と管理コマンドを出力します。`--agent` と組み合わせて特定の subagent を実行します                                                                                                                                                                                                          | `claude --bg "investigate the flaky test"`                                                         |
 | `--channels`                                    | （研究プレビュー）Claude がこのセッションでリッスンすべき [channel](/ja/channels) 通知を持つ MCP サーバー。`plugin:<name>@<marketplace>` エントリのスペース区切りリスト。Claude.ai 認証が必要です                                                                                                                                                                                     | `claude --channels plugin:my-notifier@my-marketplace`                                              |
 | `--chrome`                                      | Web 自動化とテストのための [Chrome ブラウザ統合](/ja/chrome) を有効にします                                                                                                                                                                                                                                                                         | `claude --chrome`                                                                                  |
```

</details>

<details>
<summary>commands-ja.md</summary>

```diff
diff --git a/docs-ja/pages/commands-ja.md b/docs-ja/pages/commands-ja.md
index 48db7e5..ff8b82d 100644
--- a/docs-ja/pages/commands-ja.md
+++ b/docs-ja/pages/commands-ja.md
@@ -21,4 +21,6 @@
 **タスク中。** `/plan` は大きな変更の前に Plan Mode に切り替えます。`/model` と `/effort` は使用している推論量を調整します。会話が長くなったら、`/context` はウィンドウがどこに向かっているかを表示し、`/compact` はそれを要約します。`/btw` を使用して、履歴を膨らませるべきではない素早い脇道を作成します。
 
+**並行して作業を実行する。** `/agents` は Claude が副次的なタスクを委譲できる[サブエージェント](/ja/sub-agents)のマネージャーを開き、`/tasks` は現在のセッションのバックグラウンドで実行されているものをリストします。`/background` はセッション全体をデタッチして[バックグラウンドエージェント](/ja/agent-view)として実行し続け、ターミナルを解放します。コードベース全体にまたがる大きな変更の場合、`/batch` はそれを独立したユニットに分解し、各ユニットを独自の[worktree](/ja/worktrees)で実行します。これらのアプローチがどのように関連しているかについては、[エージェントを並行して実行する](/ja/agents)を参照してください。
+
 **リリース前。** `/diff` は変更内容を表示し、`/simplify` は最近のファイルをレビューして品質と効率の修正を適用し、`/review` または `/security-review` はより深い読み取り専用パスを提供します。
 
@@ -42,5 +44,5 @@
 | `/agents`                                       | [エージェント](/ja/sub-agents)設定を管理します                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
 | `/autofix-pr [prompt]`                          | 現在のブランチの PR を監視し、CI が失敗するか、レビュアーがコメントを残したときに修正をプッシュする [Claude Code on the web](/ja/claude-code-on-the-web#auto-fix-pull-requests) セッションを生成します。`gh pr view` で開いている PR を検出します。別の PR を監視するには、最初にそのブランチをチェックアウトしてください。デフォルトでは、リモートセッションはすべての CI 失敗とレビューコメントを修正するよう指示されます。プロンプトを渡して異なる指示を与えることができます。例えば `/autofix-pr only fix lint and type errors`。`gh` CLI と [Claude Code on the web](/ja/claude-code-on-the-web#who-can-use-claude-code-on-the-web) へのアクセスが必要です                                                  |
-| `/batch <instruction>`                          | **[スキル](/ja/skills#bundled-skills)。** コードベース全体にわたる大規模な変更を並列で調整します。コードベースを調査し、作業を 5 ～ 30 個の独立したユニットに分解し、計画を提示します。承認されると、分離された [git worktree](/ja/worktrees) 内の各ユニットごとに 1 つのバックグラウンドエージェントを生成します。各エージェントはそのユニットを実装し、テストを実行し、プルリクエストを開きます。git リポジトリが必要です。例: `/batch migrate src/ from Solid to React`                                                                                                                                                                                                             |
+| `/batch <instruction>`                          | **[スキル](/ja/skills#bundled-skills)。** コードベース全体にわたる大規模な変更を並列で調整します。コードベースを調査し、作業を 5 ～ 30 個の独立したユニットに分解し、計画を提示します。承認されると、分離された [git worktree](/ja/worktrees) 内の各ユニットごとに 1 つのバックグラウンドサブエージェントを生成します。各サブエージェントはそのユニットを実装し、テストを実行し、プルリクエストを開きます。git リポジトリが必要です。例: `/batch migrate src/ from Solid to React`                                                                                                                                                                                                         |
 | `/branch [name]`                                | この時点で現在の会話のブランチを作成します。ブランチに切り替え、元の会話を保持します。`/resume` で戻ることができます。エイリアス: `/fork`。[`CLAUDE_CODE_FORK_SUBAGENT`](/ja/env-vars) が設定されている場合、`/fork` は代わりに[フォークされたサブエージェント](/ja/sub-agents#fork-the-current-conversation)を生成し、このコマンドのエイリアスではなくなります                                                                                                                                                                                                                                                                    |
 | `/btw <question>`                               | 会話に追加せずに[サイドクエスチョン](/ja/interactive-mode#side-questions-with-%2Fbtw)として素早く質問します                                                                                                                                                                                                                                                                                                                                                                                                                                |
@@ -66,4 +68,5 @@
 | `/fewer-permission-prompts`                     | **[スキル](/ja/skills#bundled-skills)。** トランスクリプトで一般的な読み取り専用 Bash と MCP ツール呼び出しをスキャンし、プロジェクト `.claude/settings.json` に優先度付きの許可リストを追加して権限プロンプトを削減します                                                                                                                                                                                                                                                                                                                                                               |
 | `/focus`                                        | フォーカスビューを切り替えます。最後のプロンプト、編集 diffstats を含む 1 行のツール呼び出し要約、および最終応答のみを表示します。選択は複数セッション間で保持されます。設定で [`viewMode`](/ja/settings#available-settings) を設定してオーバーライドします。[フルスクリーンレンダリング](/ja/fullscreen)でのみ利用可能です                                                                                                                                                                                                                                                                                                          |
+| `/goal [condition\|clear]`                      | [目標](/ja/goal)を設定します。Claude は条件が満たされるまでターン間で作業を続けます。引数なしで、現在または最後に達成された目標を表示します。`clear`、`stop`、`off`、`reset`、`none`、または `cancel` はアクティブな目標を早期に削除します                                                                                                                                                                                                                                                                                                                                                            |
 | `/heapdump`                                     | JavaScript ヒープスナップショットとメモリ分析を `~/Desktop` に書き込んで、高いメモリ使用量を診断します。Linux で Desktop フォルダがない場合はホームディレクトリに書き込みます。[トラブルシューティング](/ja/troubleshooting#high-cpu-or-memory-usage)を参照してください                                                                                                                                                                                                                                                                                                                                |
 | `/help`                                         | ヘルプと利用可能なコマンドを表示します                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
@@ -101,4 +104,5 @@
 | `/sandbox`                                      | [サンドボックスモード](/ja/sandboxing)を切り替えます。サポートされているプラットフォームでのみ利用可能です                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
 | `/schedule [description]`                       | [ルーチン](/ja/routines)を作成、更新、リスト表示、または実行します。Claude がセットアップを会話形式でガイドします。エイリアス: `/routines`                                                                                                                                                                                                                                                                                                                                                                                                                        |
+| `/scroll-speed`                                 | マウスホイール[スクロール速度](/ja/fullscreen#mouse-wheel-scrolling)をインタラクティブに調整します。ダイアログが開いている間にスクロールできるルーラーで変更をプレビューできます。[フルスクリーンレンダリング](/ja/fullscreen)でのみ利用可能で、JetBrains IDE ターミナルでは利用できません                                                                                                                                                                                                                                                                                                                              |
 | `/security-review`                              | 現在のブランチの保留中の変更をセキュリティ脆弱性について分析します。git diff をレビューし、インジェクション、認証の問題、データ露出などのリスクを特定します                                                                                                                                                                                                                                                                                                                                                                                                                             |
 | `/setup-bedrock`                                | [Amazon Bedrock](/ja/amazon-bedrock) 認証、リージョン、モデルピンをインタラクティブウィザードで構成します。`CLAUDE_CODE_USE_BEDROCK=1` が設定されている場合のみ表示されます。初回 Bedrock ユーザーはログイン画面からこのウィザードにアクセスすることもできます                                                                                                                                                                                                                                                                                                                                           |
```

</details>

<details>
<summary>common-workflows-ja.md</summary>

```diff
diff --git a/docs-ja/pages/common-workflows-ja.md b/docs-ja/pages/common-workflows-ja.md
index 26283e8..0115bb6 100644
--- a/docs-ja/pages/common-workflows-ja.md
+++ b/docs-ja/pages/common-workflows-ja.md
@@ -7,9 +7,22 @@
 > Claude Code を使用してコードベースの探索、バグ修正、リファクタリング、テスト、その他の日常的なタスクを実行するためのステップバイステップガイド。
 
-このページでは、日常的な開発のための実践的なワークフローについて説明します。未知のコードの探索、デバッグ、リファクタリング、テストの作成、PR の作成、セッションの管理などです。各セクションには、自分のプロジェクトに適応させることができるプロンプトの例が含まれています。より高度なパターンとヒントについては、[ベストプラクティス](/ja/best-practices)を参照してください。
+このページでは、日常的な開発のための短いレシピを集めています。プロンプティングとコンテキスト管理に関する高度なガイダンスについては、[ベストプラクティス](/ja/best-practices)を参照してください。
 
-## 新しいコードベースを理解する
+このページでは以下をカバーしています：
 
-### コードベースの概要を素早く把握する
+* [プロンプトレシピ](#prompt-recipes)：コード探索、バグ修正、リファクタリング、テスト、PR、ドキュメント用
+* [以前の会話を再開する](#resume-previous-conversations)：タスクを複数回に分けて実行できるようにする
+* [worktree を使用して並列セッションを実行する](#run-parallel-sessions-with-worktrees)：同時編集が衝突しないようにする
+* [編集前に計画する](#plan-before-editing)：ディスクに変更を加える前に確認する
+* [研究を subagent に委譲する](#delegate-research-to-subagents)：メインコンテキストをクリーンに保つ
+* [Claude をスクリプトにパイプする](#pipe-claude-into-scripts)：CI とバッチ処理用
+
+## プロンプトレシピ
+
+これらは、未知のコード探索、デバッグ、リファクタリング、テスト作成、PR 作成などの日常的なタスク用のプロンプトパターンです。各パターンは任意の Claude Code サーフェスで機能します。プロジェクトに合わせて表現を調整してください。
+
+### 新しいコードベースを理解する
+
+#### コードベースの概要を素早く把握する
 
 新しいプロジェクトに参加したばかりで、その構造を素早く理解する必要があるとします。
```

</details>

*...以降省略*

</details>


<details>
<summary>2026-05-11</summary>

**変更ファイル:**

```
 docs-ja/pages/errors-ja.md      | 34 +++++++++++++++++++++++++++++++---
 docs-ja/pages/hooks-guide-ja.md | 34 ++++++++++++++++++++++++++++++++--
 docs-ja/pages/settings-ja.md    |  2 ++
 docs-ja/pages/skills-ja.md      |  4 ++--
 4 files changed, 67 insertions(+), 7 deletions(-)
```

<details>
<summary>errors-ja.md</summary>

```diff
diff --git a/docs-ja/pages/errors-ja.md b/docs-ja/pages/errors-ja.md
index 4779629..414f4be 100644
--- a/docs-ja/pages/errors-ja.md
+++ b/docs-ja/pages/errors-ja.md
@@ -25,4 +25,6 @@
 | `Request timed out`                                                                  | [サーバーエラー](#request-timed-out)、またはメッセージがインターネット接続に言及している場合は[ネットワーク](#unable-to-connect-to-api) |
 | `<model> is temporarily unavailable, so auto mode cannot determine the safety of...` | [サーバーエラー](#auto-mode-cannot-determine-the-safety-of-an-action)                                |
+| `Auto mode could not evaluate this action and is blocking it for safety`             | [サーバーエラー](#auto-mode-cannot-determine-the-safety-of-an-action)                                |
+| `Auto mode classifier transcript exceeded context window`                            | [サーバーエラー](#auto-mode-cannot-determine-the-safety-of-an-action)                                |
 | `You've hit your session limit` / `You've hit your weekly limit`                     | [使用制限](#youve-hit-your-session-limit)                                                         |
 | `Server is temporarily limiting requests`                                            | [使用制限](#server-is-temporarily-limiting-requests)                                              |
@@ -117,5 +119,9 @@ Request timed out
 ### Auto mode cannot determine the safety of an action
 
-[auto mode](/ja/permission-modes#eliminate-prompts-with-auto-mode)がアクションを分類するために使用するモデルがオーバーロードされているため、auto mode はそれをチェックなしで承認する代わりにアクションをブロックしました。
+[auto mode](/ja/permission-modes#eliminate-prompts-with-auto-mode)がアクションを分類するために使用するモデルが決定を生成できなかったため、auto mode はアクションを自動的に承認しませんでした。表示されるメッセージは、分類器が失敗した理由によって異なります。
+
+読み取り、検索、および作業ディレクトリ内の編集は分類器をスキップするため、これらすべてのケースで機能し続けます。
+
+分類器モデルがオーバーロードされている場合：
 
 ```text theme={null}
@@ -123,6 +129,4 @@ Request timed out
 ```
 
-読み取り、検索、および作業ディレクトリ内の編集は分類器をスキップするため、停止中も機能し続けます。
-
 **対応方法：**
 
@@ -131,4 +135,28 @@ Request timed out
```

</details>

<details>
<summary>hooks-guide-ja.md</summary>

```diff
diff --git a/docs-ja/pages/hooks-guide-ja.md b/docs-ja/pages/hooks-guide-ja.md
index 997f2d5..ea59109 100644
--- a/docs-ja/pages/hooks-guide-ja.md
+++ b/docs-ja/pages/hooks-guide-ja.md
@@ -471,6 +471,4 @@ Hook イベントは Claude Code のライフサイクルの特定のポイン
 | `SessionEnd`          | When a session terminates                                                                                                                              |
 
-複数の hooks がマッチする場合、それぞれが独自の結果を返します。決定については、Claude Code は最も制限的な答えを選択します。`PreToolUse` hook が `deny` を返すと、他が何を返すかに関わらず、ツール呼び出しがキャンセルされます。1 つの hook が `ask` を返すと、残りが `allow` を返しても、許可プロンプトが強制されます。`additionalContext` からのテキストはすべての hook から保持され、Claude に一緒に渡されます。
-
 各 hook には、それがどのように実行されるかを決定する `type` があります。ほとんどの hooks は `"type": "command"` を使用し、シェルコマンドを実行します。他の 4 つのタイプが利用可能です：
 
@@ -480,4 +478,36 @@ Hook イベントは Claude Code のライフサイクルの特定のポイン
 * `"type": "agent"`：ツールアクセス付きマルチターン検証。エージェント hooks は実験的であり、変更される可能性があります。[エージェントベースの hooks](#agent-based-hooks) を参照してください。
 
+### 複数の hooks からの結果を組み合わせる
+
+複数の hooks が同じイベントにマッチする場合、すべての hook のコマンドが完了してから Claude Code は結果をマージします。1 つの hook が `deny` を返しても、兄弟 hooks の実行は停止されません。1 つの hook の `deny` が別の hook の副作用を抑制することに依存しないでください。
+
+すべてのマッチングする hooks が完了した後、Claude Code はそれらの出力を組み合わせます。`PreToolUse` 許可決定については、最も制限的な答えが勝ちます：`deny` は `ask` をオーバーライドし、`ask` は `allow` をオーバーライドします。`additionalContext` からのテキストはすべての hook から保持され、Claude に一緒に渡されます。
+
+以下の例は `Bash` に 2 つの `PreToolUse` hooks を登録しています。最初のものはすべてのコマンドをログファイルに追加して 0 で終了します。2 番目のものはスクリプトを実行し、コマンドに `rm -rf` が含まれている場合は 2 で終了して拒否します：
+
+```json theme={null}
+{
+  "hooks": {
+    "PreToolUse": [
+      {
+        "matcher": "Bash",
+        "hooks": [
+          {
```

</details>

<details>
<summary>settings-ja.md</summary>

```diff
diff --git a/docs-ja/pages/settings-ja.md b/docs-ja/pages/settings-ja.md
index 85a546b..b72108e 100644
--- a/docs-ja/pages/settings-ja.md
+++ b/docs-ja/pages/settings-ja.md
@@ -207,4 +207,5 @@ Windows では、`~/.claude` として表示されるパスは `%USERPROFILE%\.c
 | `includeGitInstructions`          | Claude のシステムプロンプトに組み込みコミットおよび PR ワークフロー命令と git ステータススナップショットを含めます（デフォルト：`true`）。たとえば、独自の git ワークフロースキルを使用する場合は、これらの命令を削除するために `false` に設定します。`CLAUDE_CODE_DISABLE_GIT_INSTRUCTIONS` 環境変数が設定されている場合、この設定よりも優先されます                                                                                                                                                                             | `false`                                                                                                                         |
 | `language`                        | Claude の優先応答言語を構成します（例：`"japanese"`、`"spanish"`、`"french"`）。Claude はデフォルトでこの言語で応答します。また、[音声ディクテーション](/ja/voice-dictation#change-the-dictation-language)言語も設定します                                                                                                                                                                                                                              | `"japanese"`                                                                                                                    |
+| `maxSkillDescriptionChars`        | {/* min-version: 2.1.105 */}[スキルリスティング](/ja/skills#skill-descriptions-are-cut-short)Claude が各ターンで見る `description` と `when_to_use` テキストの結合されたスキルごとの文字上限（デフォルト：`1536`）。この長さより長いテキストは切り詰められます。長い説明を保持するために上げるか、より多くのスキルを [`skillListingBudgetFraction`](#available-settings)の下に収めるために下げます。Claude Code v2.1.105 以降が必要です                                                                          | `2048`                                                                                                                          |
 | `minimumVersion`                  | 背景自動更新と `claude update` が特定のバージョン以下にインストールするのを防止するフロア。`"latest"` チャネルから `"stable"` に `/config` を通じて切り替えると、現在のバージョンに留まるか、ダウングレードを許可するかを求めるプロンプトが表示されます。留まることを選択すると、この値が設定されます。また、[managed 設定](/ja/permissions#managed-settings)で組織全体の最小値をピンするのに役立ちます                                                                                                                                          | `"2.1.100"`                                                                                                                     |
 | `model`                           | Claude Code に使用するデフォルトモデルをオーバーライドします。`--model` と [`ANTHROPIC_MODEL`](/ja/model-config#environment-variables)はこれを 1 セッション間オーバーライドします                                                                                                                                                                                                                                                          | `"claude-sonnet-4-6"`                                                                                                           |
@@ -224,4 +225,5 @@ Windows では、`~/.claude` として表示されるパスは `%USERPROFILE%\.c
 | `showThinkingSummaries`           | [拡張思考](/ja/model-config#extended-thinking)サマリーをインタラクティブセッションに表示します。未設定または `false`（インタラクティブモードのデフォルト）の場合、思考ブロックは API によって編集され、折りたたまれたスタブとして表示されます。編集は表示内容のみを変更し、モデルが生成するものは変更しません：思考支出を削減するには、[予算を低下させるか思考を無効にする](/ja/model-config#extended-thinking)代わりに。非インタラクティブモード（`-p`）と SDK 呼び出し元は、この設定に関係なく常にサマリーを受け取ります                                                                               | `true`                                                                                                                          |
 | `showTurnDuration`                | レスポンス後のターン期間メッセージを表示します（例：「Cooked for 1m 6s」）。デフォルト：`true`。`/config` に**ターン期間を表示**として表示されます                                                                                                                                                                                                                                                                                                  | `false`                                                                                                                         |
+| `skillListingBudgetFraction`      | {/* min-version: 2.1.105 */}[スキルリスティング](/ja/skills#skill-descriptions-are-cut-short)Claude が各ターンで見るモデルのコンテキストウィンドウ用に予約されたフラクション（デフォルト：`0.01` = 1%）。リスティングが予算を超える場合、最も使用頻度の低いスキルの説明は、Claude が引き続き呼び出すことができるが理由を見ることができないように、ベアネームに折りたたまれます。より多くの説明を表示するために上げるか、より多くのスキルを収めるために下げます。`/doctor` は現在の切り詰めカウントと影響を受けるスキルを表示します。Claude Code v2.1.105 以降が必要です                                        | `0.02`                                                                                                                          |
 | `skillOverrides`                  | {/* min-version: 2.1.129 */}スキル名でキー付けされたスキルごとの可視性オーバーライド。値は `"on"`、`"name-only"`、`"user-invocable-only"`、または `"off"` です。スキルの SKILL.md を編集することなく、スキルを非表示または折りたたむことができます。プラグインスキルには適用されません。これらは `/plugin` を通じて管理されます。`/skills` メニューはこれらを `.claude/settings.local.json` に書き込みます。[設定からスキルの可視性をオーバーライド](/ja/skills#override-skill-visibility-from-settings)を参照してください。Claude Code v2.1.129 以降が必要です | `{"legacy-context": "name-only", "deploy": "off"}`                                                                              |
 | `skipWebFetchPreflight`           | [WebFetch ドメイン安全チェック](/ja/data-usage#webfetch-domain-safety-check)をスキップします。このチェックは、フェッチ前に各リクエストされたホスト名を `api.anthropic.com` に送信します。Bedrock、Vertex AI、または制限的な出力を持つ Foundry デプロイメントなど、Anthropic へのトラフィックをブロックする環境で `true` に設定します。スキップされた場合、WebFetch はブロックリストを参照せずに任意の URL を試みます                                                                                                                | `true`                                                                                                                          |
```

</details>

<details>
<summary>skills-ja.md</summary>

```diff
diff --git a/docs-ja/pages/skills-ja.md b/docs-ja/pages/skills-ja.md
index 47de823..21a6874 100644
--- a/docs-ja/pages/skills-ja.md
+++ b/docs-ja/pages/skills-ja.md
@@ -753,7 +753,7 @@ Claude がスキルを使用したくない場合：
 ### スキルの説明が短縮される
 
-スキルの説明がコンテキストに読み込まれるため、Claude は利用可能なものを知っています。すべてのスキル名は常に含まれていますが、多くのスキルがある場合、説明は文字予算に合わせて短縮される可能性があり、Claude が一致するために必要なキーワードを削除できます。予算はコンテキストウィンドウの 1% で動的にスケーリングされ、8,000 文字のフォールバックがあります。
+スキルの説明がコンテキストに読み込まれるため、Claude は利用可能なものを知っています。すべてのスキル名は常に含まれていますが、多くのスキルがある場合、説明は文字予算に合わせて短縮される可能性があり、Claude が一致するために必要なキーワードを削除できます。予算はモデルのコンテキストウィンドウの 1% でスケーリングされます。オーバーフローすると、最も呼び出しが少ないスキルの説明が最初に削除され、実際に使用するスキルは完全なテキストを保持します。`/doctor` を実行して、予算がオーバーフローしているかどうか、どのスキルが影響を受けているかを確認します。
 
-制限を上げるには、`SLASH_COMMAND_TOOL_CHAR_BUDGET` 環境変数を設定します。他のスキルの予算を解放するには、[`skillOverrides`](#override-skill-visibility-from-settings) で低優先度のエントリを `"name-only"` に設定して、説明なしでリストアップします。ソースで `description` と `when_to_use` テキストをトリミングすることもできます。各エントリの組み合わせテキストは予算に関係なく 1,536 文字でキャップされているため、主要なユースケースを前置きしてください。
+予算を上げるには、[`skillListingBudgetFraction`](/ja/settings#available-settings) 設定（例：`0.02` = 2%）または `SLASH_COMMAND_TOOL_CHAR_BUDGET` 環境変数を固定文字数に設定します。他のスキルの予算を解放するには、[`skillOverrides`](#override-skill-visibility-from-settings) で低優先度のエントリを `"name-only"` に設定して、説明なしでリストアップします。ソースで `description` と `when_to_use` テキストをトリミングすることもできます。各エントリの組み合わせテキストは予算に関係なく 1,536 文字でキャップされているため、主要なユースケースを前置きしてください。キャップは [`maxSkillDescriptionChars`](/ja/settings#available-settings) で設定可能です。
 
 ## 関連リソース
```

</details>

</details>


<details>
<summary>2026-05-10</summary>

**変更ファイル:**

```
 docs-ja/pages/auto-mode-config-ja.md        |  27 +++--
 docs-ja/pages/changelog.md                  |   4 +
 docs-ja/pages/commands-ja.md                | 171 ++++++++++++++--------------
 docs-ja/pages/env-vars-ja.md                |   2 +
 docs-ja/pages/errors-ja.md                  |  16 +++
 docs-ja/pages/interactive-mode-ja.md        |   2 +-
 docs-ja/pages/mcp-ja.md                     |   2 +
 docs-ja/pages/permissions-ja.md             |   7 ++
 docs-ja/pages/plugins-reference-ja.md       |  11 +-
 docs-ja/pages/routines-ja.md                |  10 +-
 docs-ja/pages/security-ja.md                |   2 +-
 docs-ja/pages/server-managed-settings-ja.md |   5 +-
 docs-ja/pages/settings-ja.md                |  29 ++++-
 13 files changed, 183 insertions(+), 105 deletions(-)
```

<details>
<summary>auto-mode-config-ja.md</summary>

```diff
diff --git a/docs-ja/pages/auto-mode-config-ja.md b/docs-ja/pages/auto-mode-config-ja.md
index 5a1d229..88d9241 100644
--- a/docs-ja/pages/auto-mode-config-ja.md
+++ b/docs-ja/pages/auto-mode-config-ja.md
@@ -40,5 +40,5 @@
 分類器は `.claude/settings.json` の共有プロジェクト設定から `autoMode` を読み込まないため、チェックインされたリポジトリは独自の許可ルールを注入できません。
 
-各スコープのエントリは結合されます。開発者は個人エントリで `environment`、`allow`、`soft_deny` を拡張できますが、管理設定が提供するエントリを削除することはできません。許可ルールは分類器内のブロックルールの例外として機能するため、開発者が追加した `allow` エントリは組織の `soft_deny` エントリをオーバーライドできます。組み合わせは加算的であり、ハードポリシー境界ではありません。
+各スコープのエントリは結合されます。開発者は個人エントリで `environment`、`allow`、`soft_deny`、および `hard_deny` を拡張できますが、管理設定が提供するエントリを削除することはできません。許可ルールは分類器内のソフトブロックルールの例外として機能するため、開発者が追加した `allow` エントリは組織の `soft_deny` エントリをオーバーライドできます。組み合わせは加算的であり、ハードポリシー境界ではありません。
 
 <Note>
@@ -100,15 +100,16 @@
 ## ブロックルールと許可ルールをオーバーライドする
 
-2 つの追加フィールドを使用すると、分類器の組み込みルールリストを置き換えることができます。`autoMode.soft_deny` はブロックされる内容を制御し、`autoMode.allow` は適用される例外を制御します。各フィールドは散文説明の配列であり、自然言語ルールとして読み込まれます。`autoMode.deny` フィールドはありません。意図に関係なくアクションをハードブロックするには、分類器の前に実行される [`permissions.deny`](/ja/permissions) を使用します。
+3 つの追加フィールドを使用すると、分類器の組み込みルールリストを置き換えることができます。`autoMode.hard_deny` は無条件のセキュリティ境界用、`autoMode.soft_deny` はユーザーの意図でクリアできる破壊的なアクション用、`autoMode.allow` は例外用です。各フィールドは散文説明の配列であり、自然言語ルールとして読み込まれます。分類器の前に実行されるツールパターンベースのハードブロックについては、[`permissions.deny`](/ja/permissions) を使用します。
 
-分類器内では、優先順位は 3 つのレベルで機能します。
+分類器内では、優先順位は 4 つのレベルで機能します。
 
-* `soft_deny` ルールが最初にブロック
-* `allow` ルールが一致するブロックを例外としてオーバーライド
-* 明示的なユーザーの意図が両方をオーバーライド。ユーザーのメッセージが Claude が実行しようとしている正確なアクションを直接かつ具体的に説明する場合、`soft_deny` ルールが一致しても分類器はそれを許可します
+* `hard_deny` ルールは無条件にブロックします。ユーザーの意図と `allow` 例外は適用されません。
+* `soft_deny` ルールが次にブロックします。ユーザーの意図と `allow` 例外はこれらをオーバーライドできます。
+* `allow` ルールは一致する `soft_deny` ルールを例外としてオーバーライドします。
+* 明示的なユーザーの意図が残りのソフトブロックをオーバーライドします。ユーザーのメッセージが Claude が実行しようとしている正確なアクションを直接かつ具体的に説明する場合、`soft_deny` ルールが一致しても分類器はそれを許可します。
 
 一般的なリクエストは明示的な意図としてカウントされません。Claude に「リポジトリをクリーンアップする」ように依頼することは force push を認可しませんが、「このブランチを force push する」ように依頼することは認可します。
 
```

</details>

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index 60efa10..3e8bd69 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,8 @@
 # Changelog
 
+## 2.1.138
+
+- Internal fixes
+
 ## 2.1.137
 
```

</details>

<details>
<summary>commands-ja.md</summary>

```diff
diff --git a/docs-ja/pages/commands-ja.md b/docs-ja/pages/commands-ja.md
index e218299..48db7e5 100644
--- a/docs-ja/pages/commands-ja.md
+++ b/docs-ja/pages/commands-ja.md
@@ -37,89 +37,90 @@
 </Note>
 
-| コマンド                                            | 目的                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
-| :---------------------------------------------- | :----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
-| `/add-dir <path>`                               | 現在のセッション中にファイルアクセス用の作業ディレクトリを追加。ほとんどの `.claude/` 設定は追加されたディレクトリから[検出されません](/ja/permissions#additional-directories-grant-file-access-not-configuration)。後で `--continue` または `--resume` を使用して、追加されたディレクトリからセッションを再開できます                                                                                                                                                                                                                                                                                        |
-| `/agents`                                       | [エージェント](/ja/sub-agents)設定を管理                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
-| `/autofix-pr [prompt]`                          | 現在のブランチの PR を監視し、CI が失敗するか、レビュアーがコメントを残したときに修正をプッシュする [Claude Code on the web](/ja/claude-code-on-the-web#auto-fix-pull-requests) セッションを生成。`gh pr view` で開いている PR を検出します。別の PR を監視するには、最初にそのブランチをチェックアウトしてください。デフォルトでは、リモートセッションはすべての CI 失敗とレビューコメントを修正するよう指示されます。プロンプトを渡して異なる指示を与えることができます。例えば `/autofix-pr only fix lint and type errors`。`gh` CLI と [Claude Code on the web](/ja/claude-code-on-the-web#who-can-use-claude-code-on-the-web) へのアクセスが必要です                                                   |
-| `/batch <instruction>`                          | **[スキル](/ja/skills#bundled-skills)。** コードベース全体にわたる大規模な変更を並列で調整します。コードベースを調査し、作業を 5 ～ 30 個の独立したユニットに分解し、計画を提示します。承認されると、分離された [git worktree](/ja/worktrees) 内の各ユニットごとに 1 つのバックグラウンドエージェントを生成します。各エージェントはそのユニットを実装し、テストを実行し、プルリクエストを開きます。git リポジトリが必要です。例: `/batch migrate src/ from Solid to React`                                                                                                                                                                                                           |
-| `/branch [name]`                                | この時点で現在の会話のブランチを作成。ブランチに切り替え、元の会話を保持します。`/resume` で戻ることができます。エイリアス: `/fork`。[`CLAUDE_CODE_FORK_SUBAGENT`](/ja/env-vars) が設定されている場合、`/fork` は代わりに[フォークされたサブエージェント](/ja/sub-agents#fork-the-current-conversation)を生成し、このコマンドのエイリアスではなくなります                                                                                                                                                                                                                                                                     |
-| `/btw <question>`                               | 会話に追加せずに[サイドクエスチョン](/ja/interactive-mode#side-questions-with-%2Fbtw)として素早く質問                                                                                                                                                                                                                                                                                                                                                                                                                                 |
-| `/chrome`                                       | [Chrome の Claude](/ja/chrome) 設定を構成                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
-| `/claude-api [migrate\|managed-agents-onboard]` | **[スキル](/ja/skills#bundled-skills)。** プロジェクトの言語（Python、TypeScript、Java、Go、Ruby、C#、PHP、または cURL）と Managed Agents リファレンス用の Claude API リファレンス資料を読み込みます。ツール使用、ストリーミング、バッチ、構造化出力、および一般的な落とし穴をカバーしています。また、コードが `anthropic` または `@anthropic-ai/sdk` をインポートするときに自動的にアクティブになります。`/claude-api migrate` を実行して、既存の Claude API コードを新しいモデルにアップグレード: Claude はスキャンするファイルとターゲットモデルを尋ね、モデル ID、思考設定、およびバージョン間で変更されたその他のパラメータを更新します。`/claude-api managed-agents-onboard` を実行して、新しい Managed Agent をゼロから作成するインタラクティブなウォークスルーを実施します |
-| `/clear`                                        | 空のコンテキストで新しい会話を開始。前の会話は `/resume` で利用可能なままです。同じ会話を続けながらコンテキストを解放するには、代わりに `/compact` を使用してください。エイリアス: `/reset`、`/new`                                                                                                                                                                                                                                                                                                                                                                                        |
-| `/color [color\|default]`                       | 現在のセッションのプロンプトバーの色を設定。利用可能な色: `red`、`blue`、`green`、`yellow`、`purple`、`orange`、`pink`、`cyan`。`default` を使用してリセット。引数なしで実行するとランダムな色を選択します。[リモートコントロール](/ja/remote-control)が接続されている場合、色は claude.ai/code に同期されます                                                                                                                                                                                                                                                                                                  |
-| `/compact [instructions]`                       | 会話をここまで要約してコンテキストを解放。オプションで要約のフォーカス指示を渡します。[コンパクション時にルール、スキル、メモリファイルがどのように処理されるか](/ja/context-window#what-survives-compaction)を参照してください                                                                                                                                                                                                                                                                                                                                                                      |
-| `/config`                                       | [設定](/ja/settings)インターフェースを開いて、テーマ、モデル、[出力スタイル](/ja/output-styles)、およびその他の設定を調整。エイリアス: `/settings`                                                                                                                                                                                                                                                                                                                                                                                                           |
-| `/context`                                      | 現在のコンテキスト使用状況をカラーグリッドとして視覚化。コンテキストが多いツール、メモリ肥大化、容量警告の最適化提案を表示                                                                                                                                                                                                                                                                                                                                                                                                                                                |
-| `/copy [N]`                                     | 最後のアシスタント応答をクリップボードにコピー。数字 `N` を渡して N 番目に新しい応答をコピー: `/copy 2` は 2 番目に新しい応答をコピー。コードブロックが存在する場合、個別ブロックまたは完全な応答を選択するインタラクティブピッカーを表示。ピッカーで `w` を押して、クリップボードの代わりにファイルに選択内容を書き込み。SSH 経由で便利です                                                                                                                                                                                                                                                                                                                       |
-| `/cost`                                         | `/usage` のエイリアス                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
-| `/debug [description]`                          | **[スキル](/ja/skills#bundled-skills)。** 現在のセッションのデバッグログを有効にし、セッションデバッグログを読むことで問題をトラブルシューティングします。デバッグログはデフォルトではオフです。`claude --debug` で開始した場合を除き、セッション中に `/debug` を実行するとその時点からログのキャプチャを開始します。オプションで問題を説明して分析にフォーカスを当てます                                                                                                                                                                                                                                                                                          |
-| `/desktop`                                      | 現在のセッションを Claude Code デスクトップアプリで続行。macOS と Windows のみ。エイリアス: `/app`                                                                                                                                                                                                                                                                                                                                                                                                                                          |
-| `/diff`                                         | コミットされていない変更と各ターンの diff を表示するインタラクティブ diff ビューアを開きます。左右矢印を使用して現在の git diff と個別の Claude ターンを切り替え、上下矢印でファイルをブラウズします                                                                                                                                                                                                                                                                                                                                                                                            |
-| `/doctor`                                       | Claude Code のインストールと設定を診断および検証。結果はステータスアイコン付きで表示されます。`f` を押して Claude に報告された問題を修正させます                                                                                                                                                                                                                                                                                                                                                                                                                         |
-| `/effort [level\|auto]`                         | モデルの[努力レベル](/ja/model-config#adjust-effort-level)を設定。`low`、`medium`、`high`、`xhigh`、または `max` を受け入れます。利用可能なレベルはモデルに依存し、`max` はセッションのみです。`auto` はモデルのデフォルトにリセットします。引数なしで、インタラクティブスライダーを開きます。左右矢印でレベルを選択し、`Enter` で適用します。現在の応答の完了を待たずに即座に有効になります                                                                                                                                                                                                                                                                |
-| `/exit`                                         | CLI を終了。エイリアス: `/quit`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
```

</details>

<details>
<summary>env-vars-ja.md</summary>

```diff
diff --git a/docs-ja/pages/env-vars-ja.md b/docs-ja/pages/env-vars-ja.md
index 1e078de..039d7dd 100644
--- a/docs-ja/pages/env-vars-ja.md
+++ b/docs-ja/pages/env-vars-ja.md
@@ -117,4 +117,5 @@ Claude Code は、その動作を制御するために以下の環境変数を
 | `CLAUDE_CODE_MAX_TOOL_USE_CONCURRENCY`                  | 並列実行できる読み取り専用ツールと subagent の最大数（デフォルト：10）。高い値は並列性を増加させますが、より多くのリソースを消費します                                                                                                                                                                                                                                                                                                                                                      |
 | `CLAUDE_CODE_MCP_ALLOWLIST_ENV`                         | stdio MCP サーバーをシェル環境を継承する代わりに、安全なベースライン環境とサーバーの設定された `env` のみでスポーンするには `1` に設定します                                                                                                                                                                                                                                                                                                                                              |
+| `CLAUDE_CODE_NATIVE_CURSOR`                             | ターミナル独自のカーソルを入力キャレットに表示するには `1` に設定します。描画されたブロックの代わりに。カーソルはターミナルのまばたき、形状、フォーカス設定を尊重します                                                                                                                                                                                                                                                                                                                                         |
 | `CLAUDE_CODE_NEW_INIT`                                  | `/init` が対話的なセットアップフローを実行するようにするには `1` に設定します。フローは、CLAUDE.md、スキル、フックを含む、生成するファイルを尋ねてから、コードベースを探索して書き込みます。この変数がない場合、`/init` はプロンプトなしに CLAUDE.md を自動的に生成します。                                                                                                                                                                                                                                                                     |
 | `CLAUDE_CODE_NO_FLICKER`                                | [フルスクリーンレンダリング](/ja/fullscreen) を有効にするには `1` に設定します。これは研究プレビューで、フリッカーを減らし、長い会話でメモリをフラットに保ちます。[`tui`](/ja/settings#available-settings) 設定と同等です。`/tui fullscreen` で切り替えることもできます                                                                                                                                                                                                                                                  |
@@ -192,4 +193,5 @@ Claude Code は、その動作を制御するために以下の環境変数を
 | `DISABLE_UPDATES`                                       | すべての更新をブロックするには `1` に設定します。手動の `claude update` と `claude install` を含みます。`DISABLE_AUTOUPDATER` より厳密です。Claude Code を独自のチャネルを通じて配布し、ユーザーが自己更新すべきでない場合に使用します                                                                                                                                                                                                                                                                       |
 | `DISABLE_UPGRADE_COMMAND`                               | `/upgrade` コマンドを非表示にするには `1` に設定します                                                                                                                                                                                                                                                                                                                                                                                            |
+| `DO_NOT_TRACK`                                          | テレメトリをオプトアウトするには `1` に設定します。`DISABLE_TELEMETRY` を設定するのと同等です。[標準クロスツール規約](https://consoledonottrack.com/) として尊重されます                                                                                                                                                                                                                                                                                                             |
 | `ENABLE_CLAUDEAI_MCP_SERVERS`                           | Claude Code で [claude.ai MCP サーバー](/ja/mcp#use-mcp-servers-from-claude-ai) を無効にするには `false` に設定します。ログインしているユーザーではデフォルトで有効です                                                                                                                                                                                                                                                                                                    |
 | `ENABLE_PROMPT_CACHING_1H`                              | API キー、[Bedrock](/ja/amazon-bedrock)、[Vertex](/ja/google-vertex-ai)、[Foundry](/ja/microsoft-foundry) ユーザーの場合、デフォルトの 5 分の代わりに 1 時間のプロンプトキャッシュ TTL をリクエストするには `1` に設定します。サブスクリプションユーザーは 1 時間の TTL を自動的に受け取ります。1 時間キャッシュ書き込みはより高いレートで請求されます                                                                                                                                                                                       |
```

</details>

<details>
<summary>errors-ja.md</summary>

```diff
diff --git a/docs-ja/pages/errors-ja.md b/docs-ja/pages/errors-ja.md
index d9c5e3d..4779629 100644
--- a/docs-ja/pages/errors-ja.md
+++ b/docs-ja/pages/errors-ja.md
@@ -32,4 +32,5 @@
 | `Invalid API key`                                                                    | [認証](#invalid-api-key)                                                                        |
 | `This organization has been disabled`                                                | [認証](#this-organization-has-been-disabled)                                                    |
+| `Routines are disabled by your organization's policy`                                | [認証](#routines-are-disabled-by-your-organizations-policy)                                     |
 | `OAuth token revoked` / `OAuth token has expired`                                    | [認証](#oauth-token-revoked-or-expired)                                                         |
 | `does not meet scope requirement user:profile`                                       | [認証](#oauth-scope-requirement)                                                                |
@@ -253,4 +254,19 @@ API Error: 400 ... This organization has been disabled.
 * 環境変数が設定されておらず、エラーが続く場合、無効な組織は `/login` に関連付けられているものです。サポートに連絡するか、別のアカウントでサインインしてください。
 
+### Routines are disabled by your organization's policy
+
+チームまたはエンタープライズ管理者が、組織レベルでルーチンをオフにしています。エラーは、`/schedule` および claude.ai/code の [Routines](/ja/routines) UI を含め、ルーチンを作成または実行しようとするときに表示されます。
+
+```text theme={null}
+Routines are disabled by your organization's policy.
+```
+
+これはサーバー側の設定であるため、ローカル設定、環境変数、または CLI フラグからオーバーライドすることはできません。
+
+**対応方法：**
+
+* 管理者に [claude.ai/admin-settings/claude-code](https://claude.ai/admin-settings/claude-code) で **Routines** トグルを有効にするよう依頼してください
+* 組織レベルのルーチンを必要としない 1 回限りのスケジュール済み作業については、[スケジュール済みタスク](/ja/scheduled-tasks)を参照してください
+
 ### OAuth token revoked or expired
 
```

</details>

<details>
<summary>interactive-mode-ja.md</summary>

```diff
diff --git a/docs-ja/pages/interactive-mode-ja.md b/docs-ja/pages/interactive-mode-ja.md
index cc0d611..42cfa91 100644
--- a/docs-ja/pages/interactive-mode-ja.md
+++ b/docs-ja/pages/interactive-mode-ja.md
@@ -290,5 +290,5 @@ Bash モード：
 Claude が応答した後、マルチパートリクエストのフォローアップステップや、ワークフローの自然な継続など、会話履歴に基づいて提案が表示され続けます。
 
-* **Tab** または **Right arrow** を押して提案を受け入れるか、**Enter** を押して受け入れて送信
+* **Tab** または **Right arrow** を押して提案をプロンプト入力に配置してから、**Enter** を押して送信
 * 入力を開始して却下
 
```

</details>

<details>
<summary>mcp-ja.md</summary>

```diff
diff --git a/docs-ja/pages/mcp-ja.md b/docs-ja/pages/mcp-ja.md
index 90382ce..2271b72 100644
--- a/docs-ja/pages/mcp-ja.md
+++ b/docs-ja/pages/mcp-ja.md
@@ -264,4 +264,6 @@ claude mcp add --transport http secure-api https://api.example.com/mcp \
 ```
 
+MCP サーバーを `.mcp.json`、`~/.claude.json`、または `claude mcp add-json` で JSON を使用して設定する場合、`type` フィールドは `http` のエイリアスとして `streamable-http` を受け入れます。MCP 仕様ではこのトランスポートに `streamable-http` という名前を使用しているため、サーバードキュメントからコピーされた設定は変更なしで機能します。
+
 ### オプション 2：リモート SSE サーバーを追加する
 
```

</details>

<details>
<summary>permissions-ja.md</summary>

```diff
diff --git a/docs-ja/pages/permissions-ja.md b/docs-ja/pages/permissions-ja.md
index 8ded97f..b4d1fd9 100644
--- a/docs-ja/pages/permissions-ja.md
+++ b/docs-ja/pages/permissions-ja.md
@@ -211,4 +211,11 @@ Windows では、パスはマッチング前に POSIX 形式に正規化され
 * `Read(src/**)`: `<current-directory>/src/` から読み取ります
 
+ルールはそのアンカーの下のファイルのみをマッチさせるため、アンカーは deny ルールがどこまで到達するかを決定します。ベアファイル名は gitignore セマンティクスに従い、任意の深さでマッチするため、`Read(.env)` と `Read(**/.env)` は同等です。
+
+| Deny ルール                         | ブロック                    | ブロックしない                       |
+| -------------------------------- | ----------------------- | ----------------------------- |
+| `Read(.env)` または `Read(**/.env)` | 現在のディレクトリ以下の任意の `.env`  | 親ディレクトリまたは別のプロジェクト内の `.env`   |
+| `Read(//**/.env)`                | ファイルシステム上の任意の場所の `.env` | なし。ルールはファイルシステムルートにアンカーされています |
+
 <Note>
   gitignore パターンでは、`*` は単一のディレクトリ内のファイルをマッチさせ、`**` はディレクトリ全体で再帰的にマッチさせます。すべてのファイルアクセスを許可するには、括弧なしでツール名を使用します。`Read`、`Edit`、または `Write`。
```

</details>

<details>
<summary>plugins-reference-ja.md</summary>

```diff
diff --git a/docs-ja/pages/plugins-reference-ja.md b/docs-ja/pages/plugins-reference-ja.md
index e0364d1..e278347 100644
--- a/docs-ja/pages/plugins-reference-ja.md
+++ b/docs-ja/pages/plugins-reference-ja.md
@@ -424,5 +424,5 @@ monitors をインラインで宣言するには、`plugin.json` の `experiment
 | フィールド                   | 型                     | 説明                                                                                                                  | 例                                                    |
 | :---------------------- | :-------------------- | :------------------------------------------------------------------------------------------------------------------ | :--------------------------------------------------- |
-| `skills`                | string\|array         | `<name>/SKILL.md` を含むカスタム skill ディレクトリ（デフォルト `skills/` を置き換え）                                                       | `"./custom/skills/"`                                 |
+| `skills`                | string\|array         | `<name>/SKILL.md` を含むカスタム skill ディレクトリ（デフォルト `skills/` に加えて）                                                        | `"./custom/skills/"`                                 |
 | `commands`              | string\|array         | カスタムフラット `.md` skill ファイルまたはディレクトリ（デフォルト `commands/` を置き換え）                                                         | `"./custom/cmd.md"` または `["./cmd1.md"]`              |
 | `agents`                | string\|array         | カスタムエージェントファイル（デフォルト `agents/` を置き換え）                                                                               | `"./custom/agents/reviewer.md"`                      |
@@ -511,10 +511,15 @@ monitors をインラインで宣言するには、`plugin.json` の `experiment
 ### パス動作ルール
 
-`skills`、`commands`、`agents`、`outputStyles`、`experimental.themes`、`experimental.monitors` の場合、カスタムパスはデフォルトを置き換えます。マニフェストが `skills` を指定する場合、デフォルト `skills/` ディレクトリはスキャンされません。`experimental.monitors` を指定する場合、デフォルト `monitors/monitors.json` は読み込まれません。[Hooks](#hooks)、[MCP servers](#mcp-servers)、[LSP servers](#lsp-servers)は複数のソースを処理するための異なるセマンティクスを持ちます。
+カスタムパスがプラグインのデフォルトディレクトリを置き換えるか拡張するかは、フィールドによって異なります:
+
+* **デフォルトを置き換える**: `commands`、`agents`、`outputStyles`、`experimental.themes`、`experimental.monitors`。たとえば、マニフェストが `commands` を指定する場合、デフォルト `commands/` ディレクトリはスキャンされません。デフォルトを保持してさらに追加するには、明示的にリストします: `"commands": ["./commands/", "./extras/"]`
+* **デフォルトに追加**: `skills`。デフォルト `skills/` ディレクトリは常にスキャンされ、`skills` にリストされているディレクトリはそれと一緒に読み込まれます
+* **独自のマージルール**: [hooks](#hooks)、[MCP servers](#mcp-servers)、[LSP servers](#lsp-servers)。各セクションで複数のソースがどのように結合されるかを参照してください
+
+すべてのパスフィールドについて:
 
 * すべてのパスはプラグインルートに相対的で、`./` で始まる必要があります
 * カスタムパスからのコンポーネントは同じ命名と名前空間ルールを使用します
 * 複数のパスを配列として指定できます
-* skills、commands、agents、output styles のデフォルトディレクトリを保持してさらにパスを追加するには、配列にデフォルトを含めます: `"skills": ["./skills/", "./extras/"]`
 * skill パスが `SKILL.md` を直接含むディレクトリを指す場合（例: `"skills": ["./"]` がプラグインルートを指す）、`SKILL.md` の frontmatter `name` フィールドが skill の呼び出し名を決定します。これはインストールディレクトリに関係なく安定した名前を提供します。frontmatter に `name` が設定されていない場合、ディレクトリ basename がフォールバックとして使用されます。
 
```

</details>

*...以降省略*

</details>


<details>
<summary>2026-05-09</summary>

**変更ファイル:**

```
 docs-ja/pages/agent-teams-ja.md       |   2 +-
 docs-ja/pages/changelog.md            |  59 ++++
 docs-ja/pages/cli-reference-ja.md     |   4 +-
 docs-ja/pages/commands-ja.md          |  22 +-
 docs-ja/pages/desktop-ja.md           |  17 +
 docs-ja/pages/env-vars-ja.md          | 452 ++++++++++++------------
 docs-ja/pages/features-overview-ja.md |   2 +-
 docs-ja/pages/hooks-ja.md             |  21 +-
 docs-ja/pages/overview-ja.md          | 636 +--------------------------------
 docs-ja/pages/plugins-ja.md           |  10 +-
 docs-ja/pages/quickstart-ja.md        | 639 +---------------------------------
 docs-ja/pages/settings-ja.md          |  14 +-
 docs-ja/pages/setup-ja.md             |   2 +
 docs-ja/pages/sub-agents-ja.md        |   6 +-
 docs-ja/pages/terminal-config-ja.md   |   2 +-
 docs-ja/pages/vs-code-ja.md           |   2 +-
 16 files changed, 367 insertions(+), 1523 deletions(-)
```

<details>
<summary>agent-teams-ja.md</summary>

```diff
diff --git a/docs-ja/pages/agent-teams-ja.md b/docs-ja/pages/agent-teams-ja.md
index f457bb0..691d350 100644
--- a/docs-ja/pages/agent-teams-ja.md
+++ b/docs-ja/pages/agent-teams-ja.md
@@ -421,4 +421,4 @@ tmux kill-session -t <session-name>
 
 * **軽量委任**：[subagents](/ja/sub-agents) はセッション内で調査または検証用のヘルパーエージェントを生成し、エージェント間調整が必要ないタスクに適しています
-* **手動並列セッション**：[Git worktrees](/ja/common-workflows#run-parallel-claude-code-sessions-with-git-worktrees) を使用すると、自動チーム調整なしで複数の Claude Code セッションを自分で実行できます
+* **手動並列セッション**：[Git worktrees](/ja/worktrees) を使用すると、自動チーム調整なしで複数の Claude Code セッションを自分で実行できます
 * **アプローチを比較**：[subagent とエージェントチーム](/ja/features-overview#compare-similar-features)の比較を参照して、並べて比較してください
```

</details>

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index 32b662b..60efa10 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,63 @@
 # Changelog
 
+## 2.1.137
+
+- [VSCode] Fixed extension failing to activate on Windows
+
+## 2.1.136
+
+- Added `CLAUDE_CODE_ENABLE_FEEDBACK_SURVEY_FOR_OTEL` to re-enable the session quality survey for enterprises capturing responses through OpenTelemetry
+- Added `settings.autoMode.hard_deny` for auto mode classifier rules that block unconditionally regardless of user intent or allow exceptions
+- Fixed MCP servers configured in `.mcp.json`, plugins, and claude.ai connectors silently disappearing after `/clear` in the VS Code extension, JetBrains plugin, and Agent SDK
+- Fixed a rare login loop where a concurrent credential write could overwrite a freshly-rotated OAuth token and force re-login
+- Fixed MCP OAuth refresh tokens being lost when multiple servers refresh concurrently — users with several remote MCP servers should no longer need daily re-authentication
+- Fixed an API error (400) when extended thinking emitted a redacted thinking block after a tool call
+- Fixed `--resume` / `--continue` not finding sessions when the project path contains underscores
+- Fixed plan mode not blocking file writes when a matching `Edit(...)` allow rule exists
+- WSL2: image paste from Windows clipboard now works via a PowerShell fallback when xclip/wl-paste cannot read image data
+- Fixed plugin `Stop`/`UserPromptSubmit` hooks failing when cache cleanup deletes a version still in use by a running session
+- Improved visual consistency across slash command dialogs: standardized footer hints, dialog spacing, and arrow-key styling, and the dialog frame now appears immediately during loading instead of popping in after
+- Fixed colors appearing at wrong positions in bash command output and markdown code blocks
+- Fixed ReasonML diffs rendering corrupted "undefined" text artifacts at word-diff boundaries
+- Fixed worktree exit dialog warning about uncommitted files in the wrong directory after worktree removal
+- Fixed `@` file picker not matching files created mid-session in small non-git directories
+- Fixed `@`-mention file picker not finding files in directories with more than 100 entries
+- Fixed failed tool calls not being click-to-expand in fullscreen mode when their output was truncated
```

</details>

<details>
<summary>cli-reference-ja.md</summary>

```diff
diff --git a/docs-ja/pages/cli-reference-ja.md b/docs-ja/pages/cli-reference-ja.md
index a7190a9..c81bcc0 100644
--- a/docs-ja/pages/cli-reference-ja.md
+++ b/docs-ja/pages/cli-reference-ja.md
@@ -85,5 +85,5 @@
 | `--permission-prompt-tool`                      | 非インタラクティブモードで権限プロンプトを処理する MCP ツールを指定します                                                                                                                                                                                                                                                                                     | `claude -p --permission-prompt-tool mcp_auth_tool "query"`                                         |
 | `--plugin-dir`                                  | このセッションのみのプラグインをディレクトリまたは `.zip` アーカイブから読み込みます。各フラグは 1 つのパスを取ります。複数のプラグインの場合はフラグを繰り返します：`--plugin-dir A --plugin-dir B.zip`                                                                                                                                                                                                 | `claude --plugin-dir ./my-plugin`                                                                  |
-| `--plugin-url`                                  | このセッションのみのプラグイン `.zip` アーカイブを URL から取得します。各フラグは 1 つの URL を取ります。複数のプラグインの場合はフラグを繰り返します                                                                                                                                                                                                                                       | `claude --plugin-url https://example.com/plugin.zip`                                               |
+| `--plugin-url`                                  | このセッションのみのプラグイン `.zip` アーカイブを URL から取得します。複数のプラグインの場合はフラグを繰り返すか、スペース区切りの URL を単一の引用符で囲まれた値で渡します                                                                                                                                                                                                                             | `claude --plugin-url https://example.com/plugin.zip`                                               |
 | `--print`, `-p`                                 | インタラクティブモードなしで応答を出力します（プログラムによる使用の詳細については [Agent SDK ドキュメント](/ja/agent-sdk/overview) を参照）                                                                                                                                                                                                                                   | `claude -p "query"`                                                                                |
 | `--remote`                                      | 提供されたタスク説明で claude.ai に新しい [Web セッション](/ja/claude-code-on-the-web) を作成します                                                                                                                                                                                                                                                   | `claude --remote "Fix the login bug"`                                                              |
@@ -104,5 +104,5 @@
 | `--verbose`                                     | 詳細ログを有効にし、ターンごとの完全な出力を表示します。このセッションの [`viewMode`](/ja/settings#available-settings) 設定をオーバーライドします                                                                                                                                                                                                                            | `claude --verbose`                                                                                 |
 | `--version`, `-v`                               | バージョン番号を出力します                                                                                                                                                                                                                                                                                                               | `claude -v`                                                                                        |
-| `--worktree`, `-w`                              | Claude を `<repo>/.claude/worktrees/<name>` の分離された [git worktree](/ja/worktrees) で開始します。名前が指定されていない場合は、自動生成されます                                                                                                                                                                                                              | `claude -w feature-auth`                                                                           |
+| `--worktree`, `-w`                              | Claude を `<repo>/.claude/worktrees/<name>` の分離された [git worktree](/ja/worktrees) で開始します。名前が指定されていない場合は、自動生成されます。`#<number>` または GitHub プルリクエスト URL を渡して、`origin` からその PR をフェッチし、worktree をそこからブランチします                                                                                                                        | `claude -w feature-auth`                                                                           |
 
 ### システムプロンプトフラグ
```

</details>

<details>
<summary>commands-ja.md</summary>

```diff
diff --git a/docs-ja/pages/commands-ja.md b/docs-ja/pages/commands-ja.md
index 98542ab..e218299 100644
--- a/docs-ja/pages/commands-ja.md
+++ b/docs-ja/pages/commands-ja.md
@@ -13,10 +13,28 @@
 コマンドはメッセージの開始時にのみ認識されます。コマンド名の後に続くテキストは引数として渡されます。
 
-以下の表は Claude Code に含まれるすべてのコマンドをリストしています。**[スキル](/ja/skills#bundled-skills)** とマークされたエントリはバンドルされたスキルです。これらは自分で作成するスキルと同じメカニズムを使用します。Claude に渡されるプロンプトであり、Claude は関連する場合に自動的に呼び出すこともできます。その他はすべて、CLI にコード化された動作を持つ組み込みコマンドです。独自のコマンドを追加するには、[スキル](/ja/skills)を参照してください。
+## 典型的なワークフロー全体でのコマンド
+
+ほとんどのコマンドはセッション内の特定の時点で有用です。プロジェクトのセットアップから変更のリリースまでです。
+
+**リポジトリでの最初のセッション。** `/init` を実行してスターター `CLAUDE.md` を生成し、その後 `/memory` を実行して改善します。`/mcp` と `/agents` を使用してプロジェクトが必要とするサーバーまたはサブエージェントをセットアップし、`/permissions` を使用して必要な承認ルールを設定します。
+
+**タスク中。** `/plan` は大きな変更の前に Plan Mode に切り替えます。`/model` と `/effort` は使用している推論量を調整します。会話が長くなったら、`/context` はウィンドウがどこに向かっているかを表示し、`/compact` はそれを要約します。`/btw` を使用して、履歴を膨らませるべきではない素早い脇道を作成します。
+
+**リリース前。** `/diff` は変更内容を表示し、`/simplify` は最近のファイルをレビューして品質と効率の修正を適用し、`/review` または `/security-review` はより深い読み取り専用パスを提供します。
 
-すべてのコマンドがすべてのユーザーに表示されるわけではありません。可用性はプラットフォーム、プラン、環境によって異なります。たとえば、`/desktop` は macOS と Windows にのみ表示され、`/upgrade` は Pro プランと Max プランにのみ表示されます。
+**セッション間。** `/clear` は新しいタスクで新しく開始しながらプロジェクトメモリを保持します。`/resume` と `/branch` を使用して、以前の会話に戻るか、フォークできます。`/teleport` はウェブセッションをこのターミナルに引き込み、`/remote-control` を使用してこのローカルセッションを別のデバイスから続行できます。
+
+**何か問題がある場合。** `/rewind` はコードと会話をチェックポイントに巻き戻します。`/doctor` と `/debug` はインストールとランタイムの問題を診断し、`/feedback` はセッションコンテキストが添付されたバグを報告します。
+
+## すべてのコマンド
+
+以下の表は Claude Code に含まれるすべてのコマンドをリストしています。**[スキル](/ja/skills#bundled-skills)** とマークされたエントリはバンドルされたスキルです。これらは自分で作成するスキルと同じメカニズムを使用します。Claude に渡されるプロンプトであり、Claude は関連する場合に自動的に呼び出すこともできます。その他はすべて、CLI にコード化された動作を持つ組み込みコマンドです。独自のコマンドを追加するには、[スキル](/ja/skills)を参照してください。
 
 以下の表では、`<arg>` は必須引数を示し、`[arg]` はオプション引数を示します。
 
+<Note>
```

</details>

<details>
<summary>desktop-ja.md</summary>

```diff
diff --git a/docs-ja/pages/desktop-ja.md b/docs-ja/pages/desktop-ja.md
index 24cc374..a5ebd8a 100644
--- a/docs-ja/pages/desktop-ja.md
+++ b/docs-ja/pages/desktop-ja.md
@@ -565,4 +565,20 @@ SSH 接続を追加するには、セッションを開始する前に環境ド
 各エントリには `id`、`name`、および `sshHost` が必要です。`sshPort`、`sshIdentityFile`、および `startDirectory` フィールドはオプションです。ユーザーは、ダイアログを通じて追加された接続が保存される独自の `~/.claude/settings.json` に `sshConfigs` を追加することもできます。
 
+#### ユーザーが接続できる SSH ホストを制限する
+
+管理者は、[管理設定](/ja/settings#settings-precedence)ファイルに `sshHostAllowlist` を追加することで、Desktop の SSH セッションを承認されたホストのセットに制限できます。設定されると、ユーザーは解決されたホスト名がパターンの 1 つと一致するホストにのみ接続できます。SSH セッションを完全に無効にするには、空の配列に設定します。
+
+次の例は、`devboxes.example.com` の下のすべてのホストと、単一の名前付きバスティオンホストへの接続を許可しています：
+
+```json theme={null}
+{
+  "sshHostAllowlist": ["*.devboxes.example.com", "bastion.example.com"]
+}
+```
+
+パターンは大文字と小文字を区別しません。`*` はすべてのホストと一致し、`*.example.com` は `example.com` とすべてのサブドメインと一致します。その他はすべて完全一致です。チェックは `ssh -G` を経由した `~/.ssh/config` 解決後のホスト名に対して実行されるため、`Host` エイリアスと `ProxyCommand`/`ProxyJump` エントリは、解決された `HostName` が一致する限り許可されます。
+
+`sshHostAllowlist` は管理設定からのみ読み取られます。ユーザーまたはプロジェクト設定の値は無視されます。Claude Desktop アプリのみがこの設定を尊重します。Claude Code CLI と IDE 拡張機能はこれを読み取らず、Bash ツールを通じて実行される `ssh` コマンドを制限しません。これは Desktop アプリが接続するホストを管理し、ネットワーク出力ではないため、ハード境界が必要な場合は組織のネットワークまたはゼロトラストコントロールと組み合わせてください。
+
 ## エンタープライズ設定
 
@@ -588,4 +604,5 @@ Team または Enterprise プランの組織は、管理コンソールコント
 | `autoMode`                                 | 組織全体で auto mode 分類器が信頼およびブロックするものをカスタマイズします。[auto mode を設定する](/ja/auto-mode-config)を参照してください。                                                       |
 | `sshConfigs`                               | 環境ドロップダウンに表示される[SSH 接続](#pre-configure-ssh-connections-for-your-team)を事前設定します。ユーザーは管理接続を編集または削除できません。                                               |
+| `sshHostAllowlist`                         | [SSH セッション](#restrict-which-ssh-hosts-users-can-connect-to)を、解決されたホスト名がこれらのパターンのいずれかと一致するホストに制限します。空の配列は SSH セッションを無効にします。管理設定からのみ読み取られます。          |
 
```

</details>

<details>
<summary>env-vars-ja.md</summary>

```diff
diff --git a/docs-ja/pages/env-vars-ja.md b/docs-ja/pages/env-vars-ja.md
index 6a52fc6..1e078de 100644
--- a/docs-ja/pages/env-vars-ja.md
+++ b/docs-ja/pages/env-vars-ja.md
@@ -9,229 +9,231 @@
 Claude Code は、その動作を制御するために以下の環境変数をサポートしています。`claude` を起動する前にシェルで設定するか、[`settings.json`](/ja/settings#available-settings) の `env` キーで設定して、すべてのセッションに適用するか、チーム全体にロールアウトしてください。
 
-| 変数                                                      | 目的                                                                                                                                                                                                                                                                                                                                                                                                                    |
-| :------------------------------------------------------ | :-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
-| `ANTHROPIC_API_KEY`                                     | `X-Api-Key` ヘッダーとして送信される API キー。設定されている場合、ログインしていても Claude Pro、Max、Team、または Enterprise サブスクリプションの代わりにこのキーが使用されます。非対話モード（`-p`）では、キーが存在する場合は常に使用されます。対話モードでは、キーがサブスクリプションをオーバーライドする前に一度承認するよう求められます。代わりにサブスクリプションを使用するには、`unset ANTHROPIC_API_KEY` を実行してください                                                                                                                                                            |
-| `ANTHROPIC_AUTH_TOKEN`                                  | `Authorization` ヘッダーのカスタム値（ここで設定した値には `Bearer ` が接頭辞として付けられます）                                                                                                                                                                                                                                                                                                                                                        |
-| `ANTHROPIC_BASE_URL`                                    | API エンドポイントをオーバーライドして、プロキシまたはゲートウェイを通じてリクエストをルーティングします。ファーストパーティ以外のホストに設定されている場合、[MCP ツール検索](/ja/mcp#scale-with-mcp-tool-search) はデフォルトで無効になります。プロキシが `tool_reference` ブロックを転送する場合は、`ENABLE_TOOL_SEARCH=true` を設定してください                                                                                                                                                                                               |
-| `ANTHROPIC_BEDROCK_BASE_URL`                            | Bedrock エンドポイント URL をオーバーライドします。カスタム Bedrock エンドポイントを使用する場合、または [LLM ゲートウェイ](/ja/llm-gateway) を通じてルーティングする場合に使用します。[Amazon Bedrock](/ja/amazon-bedrock) を参照してください                                                                                                                                                                                                                                                     |
-| `ANTHROPIC_BEDROCK_MANTLE_BASE_URL`                     | Bedrock Mantle エンドポイント URL をオーバーライドします。[Mantle エンドポイント](/ja/amazon-bedrock#use-the-mantle-endpoint) を参照してください                                                                                                                                                                                                                                                                                                         |
-| `ANTHROPIC_BEDROCK_SERVICE_TIER`                        | Bedrock [サービスティア](https://docs.aws.amazon.com/bedrock/latest/userguide/service-tiers-inference.html)（`default`、`flex`、または `priority`）。`X-Amzn-Bedrock-Service-Tier` ヘッダーとして送信されます。[Amazon Bedrock](/ja/amazon-bedrock#service-tiers) を参照してください                                                                                                                                                                        |
-| `ANTHROPIC_BETAS`                                       | API リクエストに含める追加の `anthropic-beta` ヘッダー値のカンマ区切りリスト。Claude Code は既に必要なベータヘッダーを送信しています。Claude Code がネイティブサポートを追加する前に、[Anthropic API ベータ](https://platform.claude.com/docs/en/api/beta-headers) にオプトインするために使用します。API キー認証が必要な [`--betas` フラグ](/ja/cli-reference#cli-flags) とは異なり、この変数は Claude.ai サブスクリプションを含むすべての認証方法で機能します                                                                                               |
-| `ANTHROPIC_CUSTOM_HEADERS`                              | リクエストに追加するカスタムヘッダー（`Name: Value` 形式、複数のヘッダーの場合は改行で区切られます）                                                                                                                                                                                                                                                                                                                                                             |
-| `ANTHROPIC_CUSTOM_MODEL_OPTION`                         | `/model` ピッカーにカスタムエントリとして追加するモデル ID。組み込みエイリアスを置き換えずに、非標準またはゲートウェイ固有のモデルを選択可能にするために使用します。[モデル設定](/ja/model-config#add-a-custom-model-option) を参照してください                                                                                                                                                                                                                                                                 |
-| `ANTHROPIC_CUSTOM_MODEL_OPTION_DESCRIPTION`             | `/model` ピッカーのカスタムモデルエントリの表示説明。設定されていない場合、デフォルトは `Custom model (<model-id>)` です                                                                                                                                                                                                                                                                                                                                       |
-| `ANTHROPIC_CUSTOM_MODEL_OPTION_NAME`                    | `/model` ピッカーのカスタムモデルエントリの表示名。設定されていない場合、デフォルトはモデル ID です                                                                                                                                                                                                                                                                                                                                                              |
-| `ANTHROPIC_CUSTOM_MODEL_OPTION_SUPPORTED_CAPABILITIES`  | [モデル設定](/ja/model-config#customize-pinned-model-display-and-capabilities) を参照してください                                                                                                                                                                                                                                                                                                                                   |
-| `ANTHROPIC_DEFAULT_HAIKU_MODEL`                         | [モデル設定](/ja/model-config#environment-variables) を参照してください                                                                                                                                                                                                                                                                                                                                                             |
-| `ANTHROPIC_DEFAULT_HAIKU_MODEL_DESCRIPTION`             | [モデル設定](/ja/model-config#customize-pinned-model-display-and-capabilities) を参照してください                                                                                                                                                                                                                                                                                                                                   |
-| `ANTHROPIC_DEFAULT_HAIKU_MODEL_NAME`                    | [モデル設定](/ja/model-config#customize-pinned-model-display-and-capabilities) を参照してください                                                                                                                                                                                                                                                                                                                                   |
-| `ANTHROPIC_DEFAULT_HAIKU_MODEL_SUPPORTED_CAPABILITIES`  | [モデル設定](/ja/model-config#customize-pinned-model-display-and-capabilities) を参照してください                                                                                                                                                                                                                                                                                                                                   |
-| `ANTHROPIC_DEFAULT_OPUS_MODEL`                          | [モデル設定](/ja/model-config#environment-variables) を参照してください                                                                                                                                                                                                                                                                                                                                                             |
-| `ANTHROPIC_DEFAULT_OPUS_MODEL_DESCRIPTION`              | [モデル設定](/ja/model-config#customize-pinned-model-display-and-capabilities) を参照してください                                                                                                                                                                                                                                                                                                                                   |
-| `ANTHROPIC_DEFAULT_OPUS_MODEL_NAME`                     | [モデル設定](/ja/model-config#customize-pinned-model-display-and-capabilities) を参照してください                                                                                                                                                                                                                                                                                                                                   |
-| `ANTHROPIC_DEFAULT_OPUS_MODEL_SUPPORTED_CAPABILITIES`   | [モデル設定](/ja/model-config#customize-pinned-model-display-and-capabilities) を参照してください                                                                                                                                                                                                                                                                                                                                   |
-| `ANTHROPIC_DEFAULT_SONNET_MODEL`                        | [モデル設定](/ja/model-config#environment-variables) を参照してください                                                                                                                                                                                                                                                                                                                                                             |
```

</details>

<details>
<summary>features-overview-ja.md</summary>

```diff
diff --git a/docs-ja/pages/features-overview-ja.md b/docs-ja/pages/features-overview-ja.md
index 1dae4a0..d15b86b 100644
--- a/docs-ja/pages/features-overview-ja.md
+++ b/docs-ja/pages/features-overview-ja.md
@@ -250,5 +250,5 @@ Claude Code は、コードについて推論するモデルと、ファイル
     **コンテキストコスト：** 使用されるまで低い。ユーザーのみのスキルは呼び出されるまでゼロコストです。
 
-    **Subagents 内：** スキルは subagents で異なる動作をします。オンデマンドロードの代わりに、subagent に渡されるスキルは起動時にそのコンテキストに完全にプリロードされます。Subagents はメインセッションからスキルを継承しません。明示的に指定する必要があります。
+    **Subagents 内：** スキルは subagents で異なる動作をします。オンデマンドロードの代わりに、subagent の `skills` フィールドにリストされているスキルは起動時にそのコンテキストに完全にプリロードされます。Subagents はスキルツールを通じて、リストされていないプロジェクト、ユーザー、プラグインスキルを発見して呼び出すことができます。
 
     <Tip>副作用を持つスキルには `disable-model-invocation: true` を使用します。これはコンテキストを節約し、あなたのみがそれらをトリガーすることを保証します。</Tip>
```

</details>

*...以降省略*

</details>


<details>
<summary>2026-05-08</summary>

**変更ファイル:**

```
 docs-ja/pages/amazon-bedrock-ja.md           | 130 +++---------------------
 docs-ja/pages/authentication-ja.md           |  13 ++-
 docs-ja/pages/changelog.md                   |  20 ++++
 docs-ja/pages/claude-code-on-the-web-ja.md   |  41 +++++++-
 docs-ja/pages/cli-reference-ja.md            | 142 +++++++++++++--------------
 docs-ja/pages/debug-your-config-ja.md        |  46 ++++++---
 docs-ja/pages/discover-plugins-ja.md         |  82 +++++++++-------
 docs-ja/pages/env-vars-ja.md                 |  17 ++--
 docs-ja/pages/errors-ja.md                   |  36 +++++--
 docs-ja/pages/fullscreen-ja.md               |  18 +++-
 docs-ja/pages/google-vertex-ai-ja.md         | 139 +++++---------------------
 docs-ja/pages/interactive-mode-ja.md         |   4 +-
 docs-ja/pages/mcp-ja.md                      |  20 +++-
 docs-ja/pages/memory-ja.md                   |  14 ++-
 docs-ja/pages/microsoft-foundry-ja.md        | 112 +--------------------
 docs-ja/pages/model-config-ja.md             |   6 +-
 docs-ja/pages/output-styles-ja.md            |  25 +++--
 docs-ja/pages/routines-ja.md                 |  86 ++++++++++++----
 docs-ja/pages/settings-ja.md                 |  35 ++++---
 docs-ja/pages/statusline-ja.md               |  38 ++++---
 docs-ja/pages/terminal-config-ja.md          |  10 +-
 docs-ja/pages/third-party-integrations-ja.md |  74 +++++++++++++-
 docs-ja/pages/vs-code-ja.md                  |   2 +
 23 files changed, 555 insertions(+), 555 deletions(-)
```

<details>
<summary>amazon-bedrock-ja.md</summary>

```diff
diff --git a/docs-ja/pages/amazon-bedrock-ja.md b/docs-ja/pages/amazon-bedrock-ja.md
index 799be23..e27a827 100644
--- a/docs-ja/pages/amazon-bedrock-ja.md
+++ b/docs-ja/pages/amazon-bedrock-ja.md
@@ -77,115 +77,5 @@ export const ContactSalesCard = ({surface}) => {
 };
 
-export const Experiment = ({flag, treatment, children}) => {
-  const VID_KEY = 'exp_vid';
-  const CONSENT_COUNTRIES = new Set(['AT', 'BE', 'BG', 'HR', 'CY', 'CZ', 'DK', 'EE', 'FI', 'FR', 'DE', 'GR', 'HU', 'IE', 'IT', 'LV', 'LT', 'LU', 'MT', 'NL', 'PL', 'PT', 'RO', 'SK', 'SI', 'ES', 'SE', 'RE', 'GP', 'MQ', 'GF', 'YT', 'BL', 'MF', 'PM', 'WF', 'PF', 'NC', 'AW', 'CW', 'SX', 'FO', 'GL', 'AX', 'GB', 'UK', 'AI', 'BM', 'IO', 'VG', 'KY', 'FK', 'GI', 'MS', 'PN', 'SH', 'TC', 'GG', 'JE', 'IM', 'CA', 'BR', 'IN']);
-  const fnv1a = s => {
-    let h = 0x811c9dc5;
-    for (let i = 0; i < s.length; i++) {
-      h ^= s.charCodeAt(i);
-      h += (h << 1) + (h << 4) + (h << 7) + (h << 8) + (h << 24);
-    }
-    return h >>> 0;
-  };
-  const bucket = (seed, vid) => fnv1a(fnv1a(seed + vid) + '') % 10000 < 5000 ? 'control' : 'treatment';
-  const [decision] = useState(() => {
-    const params = new URLSearchParams(location.search);
-    const preBucketed = document.documentElement.dataset['gb_' + flag.replace(/-/g, '_')];
-    const force = params.get('gb-force');
-    if (force) {
-      for (const p of force.split(',')) {
-        const [k, v] = p.split(':');
-        if (k === flag) return {
-          variant: v || 'treatment',
-          track: false
-        };
```

</details>

<details>
<summary>authentication-ja.md</summary>

```diff
diff --git a/docs-ja/pages/authentication-ja.md b/docs-ja/pages/authentication-ja.md
index af808d9..a34f95d 100644
--- a/docs-ja/pages/authentication-ja.md
+++ b/docs-ja/pages/authentication-ja.md
@@ -112,7 +112,12 @@ Amazon Bedrock、Google Vertex AI、または Microsoft Foundry を使用する
 ## 認証情報管理
 
-Claude Code は認証認証情報を安全に管理します。
-
-* **保存場所**: macOS では、認証情報は暗号化された macOS Keychain に保存されます。Linux と Windows では、認証情報は `~/.claude/.credentials.json` に保存されるか、その変数が設定されている場合は `$CLAUDE_CONFIG_DIR` の下に保存されます。Linux では、ファイルはモード `0600` で書き込まれます。Windows では、ユーザープロファイルディレクトリのアクセス制御を継承します。
+Claude Code は認証情報を安全に管理します。
+
+* **保存場所**:
+  * macOS では、認証情報は暗号化された macOS Keychain に保存されます。
+  * Linux では、認証情報は `~/.claude/.credentials.json` に保存され、ファイルモードは `0600` です。
+  * Windows では、認証情報は `%USERPROFILE%\.claude\.credentials.json` に保存され、ユーザープロファイルディレクトリのアクセス制御を継承します。これにより、ファイルはデフォルトでユーザーアカウントに制限されます。
+  * Linux または Windows で `CLAUDE_CONFIG_DIR` 環境変数を設定している場合、`.credentials.json` ファイルはそのディレクトリの下に配置されます。
+  * Claude Code は `/login` と `/logout` を通じて `.credentials.json` を管理します。リクエストをカスタム API エンドポイント経由でルーティングするには、代わりに [`ANTHROPIC_BASE_URL`](/ja/env-vars) 環境変数を設定してください。
 * **サポートされている認証タイプ**: Claude.ai 認証情報、Claude API 認証情報、Azure Auth、Bedrock Auth、および Vertex Auth。
 * **カスタム認証情報スクリプト**: [`apiKeyHelper`](/ja/settings#available-settings) 設定は、API キーを返すシェルスクリプトを実行するように設定できます。
@@ -129,5 +134,5 @@ Claude Code は認証認証情報を安全に管理します。
 2. `ANTHROPIC_AUTH_TOKEN` 環境変数。`Authorization: Bearer` ヘッダーとして送信されます。Anthropic API キーではなくベアラートークンで認証する [LLM ゲートウェイまたはプロキシ](/ja/llm-gateway)を通じてルーティングする場合に使用します。
 3. `ANTHROPIC_API_KEY` 環境変数。`X-Api-Key` ヘッダーとして送信されます。[Claude Console](https://platform.claude.com) からのキーを使用して Anthropic API に直接アクセスする場合に使用します。対話モードでは、キーを承認または拒否するよう 1 回プロンプトが表示され、選択が記憶されます。後で変更するには、`/config` の「Use custom API key」トグルを使用します。非対話モード（`-p`）では、キーが存在する場合は常に使用されます。
-4. [`apiKeyHelper`](/ja/settings#available-settings) スクリプト出力。短期トークンなど、動的または回転する認証情報に使用します。これはボルトから取得されます。
+4. [`apiKeyHelper`](/ja/settings#available-settings) スクリプト出力。動的または回転する認証情報（ボルトから取得した短期トークンなど）に使用します。
 5. `CLAUDE_CODE_OAUTH_TOKEN` 環境変数。[`claude setup-token`](#generate-a-long-lived-token) によって生成された長期 OAuth トークン。ブラウザログインが利用できない CI パイプラインとスクリプトに使用します。
 6. `/login` からのサブスクリプション OAuth 認証情報。これは Claude Pro、Max、Team、および Enterprise ユーザーのデフォルトです。
```

</details>

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index a109771..32b662b 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,24 @@
 # Changelog
 
+## 2.1.133
+
+- Added `worktree.baseRef` setting (`fresh` | `head`) to choose whether `--worktree`, `EnterWorktree`, and agent-isolation worktrees branch from `origin/<default>` or local `HEAD`. **Note:** the default `fresh` changes `EnterWorktree`'s base back to `origin/<default>` (it has been local `HEAD` since 2.1.128) — set `worktree.baseRef: "head"` to keep unpushed commits in new worktrees
+- Added `sandbox.bwrapPath` and `sandbox.socatPath` managed settings (Linux/WSL) to specify custom bubblewrap and socat binary locations
+- Added `parentSettingsBehavior` admin-tier key (`'first-wins' | 'merge'`) to let admins opt SDK `managedSettings` (parent tier) into the policy merge
+- Hooks now receive the active effort level via the `effort.level` JSON input field and the `$CLAUDE_EFFORT` environment variable, and Bash tool commands can read `$CLAUDE_EFFORT`
+- Improved focus mode behavior
+- Improved memory usage by releasing warm-spare background workers under memory pressure
+- Fixed parallel sessions all dead-ending at 401 after a refresh-token race wiped shared credentials
+- Fixed `Edit`/`Write` allow rules scoped to a drive root (`C:\`) or POSIX `/` matching incorrectly and always prompting
+- Fixed an unhandled rejection (`ECOMPROMISED`) when a history or session-log file lock is compromised by clock skew or slow disk
+- Fixed pressing Esc during conversation compaction showing a spurious "Error compacting conversation" notification
+- Fixed `HTTP(S)_PROXY` / `NO_PROXY` / mTLS not being respected for the full MCP OAuth flow including discovery, dynamic client registration, token exchange, and token refresh
+- Fixed Read/Write/Edit being denied on mapped network drives passed via `--add-dir` / SDK `additionalDirectories`
+- Fixed Remote Control stop/interrupt from claude.ai not fully canceling the CLI session the same way local Esc does, causing queued messages to never advance after interrupting a stuck tool or prompt
+- Fixed `/effort` in one session unexpectedly changing the effort level of other concurrent sessions, and a related issue where an IDE effort change could be silently dropped
+- Fixed subagents not discovering project, user, or plugin skills via the Skill tool
+- `claude --help` now lists `--remote-control` alongside `--remote-control-session-name-prefix`
+- [VSCode] Fixed `claudeCode.claudeProcessWrapper` failing with "Unsupported platform" when the extension build doesn't bundle a Claude binary
+
 ## 2.1.132
 
```

</details>

<details>
<summary>claude-code-on-the-web-ja.md</summary>

```diff
diff --git a/docs-ja/pages/claude-code-on-the-web-ja.md b/docs-ja/pages/claude-code-on-the-web-ja.md
index d1a97f3..73d3404 100644
--- a/docs-ja/pages/claude-code-on-the-web-ja.md
+++ b/docs-ja/pages/claude-code-on-the-web-ja.md
@@ -114,8 +114,8 @@ Team および Enterprise 管理者は [claude.ai/admin-settings/claude-code](ht
 各クラウドセッションは claude.ai 上にトランスクリプト URL を持ち、セッションは `CLAUDE_CODE_REMOTE_SESSION_ID` 環境変数から独自の ID を読み取ることができます。これを使用して、PR 本文、コミットメッセージ、Slack 投稿、または生成されたレポートに追跡可能なリンクを配置し、レビュアーがそれを生成した実行を開くことができます。
 
-Claude に環境変数からリンクを構築するよう依頼してください。次のコマンドは URL を出力します：
+変数の値は `cse_` プレフィックスを使用し、トランスクリプト URL パスは同じ ID を `session_` プレフィックスで使用します。リンクを構築するときにプレフィックスを置き換えてください。次のコマンドは URL を出力します：
 
 ```bash theme={null}
-echo "https://claude.ai/code/${CLAUDE_CODE_REMOTE_SESSION_ID}"
+echo "https://claude.ai/code/${CLAUDE_CODE_REMOTE_SESSION_ID/#cse_/session_}"
 ```
 
@@ -157,5 +157,5 @@ Docker はコンテナ化されたサービスを実行するために利用可
 | :------------------- | :--------------------------------------------------------------------------------------------------------------------- |
 | 環境を追加                | 現在の環境を選択して環境セレクターを開き、**Add environment** を選択します。ダイアログには名前、ネットワークアクセスレベル、環境変数、セットアップスクリプトが含まれます。                        |
-| 環境を編集                | 環境名の右側の設定アイコンを選択します。                                                                                                   |
+| 環境を編集                | クラウドアイコンを選択して現在の環境の名前を表示し、セレクターを開き、環境にマウスを合わせて、右側に表示される設定アイコンをクリックします。                                                 |
 | 環境をアーカイブ             | 環境を編集用に開き、**Archive** を選択します。アーカイブされた環境はセレクターから非表示になりますが、既存のセッションは実行を続けます。                                             |
 | `--remote` のデフォルトを設定 | ターミナルで `/remote-env` を実行します。単一の環境がある場合、このコマンドは現在の設定を表示します。`/remote-env` はデフォルトのみを選択します。ウェブインターフェースから環境を追加、編集、アーカイブします。 |
@@ -186,4 +186,6 @@ apt update && apt install -y gh
 スクリプトがゼロ以外で終了する場合、セッションは開始に失敗します。不安定なインストール失敗でセッションをブロックするのを避けるために、重要でないコマンドに `|| true` を追加します。
 
+スクリプトの総実行時間を約 5 分以下に保つため、[環境キャッシュ](#environment-caching)を構築できます。`&` と `wait` を使用して独立したインストールを並列で実行します。単一のダウンロードが 5 分の制限に収まらない場合は、バックグラウンドで起動する [SessionStart フック](#setup-scripts-vs-sessionstart-hooks)に移動します。
+
 <Note>
   パッケージをインストールするセットアップスクリプトはレジストリに到達するためにネットワークアクセスが必要です。デフォルトの **Trusted** ネットワークアクセスは npm、PyPI、RubyGems、crates.io を含む[一般的なパッケージレジストリ](#default-allowed-domains)への接続を許可します。環境が **None** ネットワークアクセスを使用する場合、スクリプトはパッケージのインストールに失敗します。
@@ -266,4 +268,10 @@ SessionStart フックはクラウドセッションでいくつかの制限が
```

</details>

<details>
<summary>cli-reference-ja.md</summary>

```diff
diff --git a/docs-ja/pages/cli-reference-ja.md b/docs-ja/pages/cli-reference-ja.md
index 08d61cd..a7190a9 100644
--- a/docs-ja/pages/cli-reference-ja.md
+++ b/docs-ja/pages/cli-reference-ja.md
@@ -40,69 +40,69 @@
 これらのコマンドラインフラグを使用して Claude Code の動作をカスタマイズします。`claude --help` はすべてのフラグをリストしていないため、`--help` にフラグが表示されていないことは、そのフラグが利用できないことを意味しません。
 
-| フラグ                                             | 説明                                                                                                                                                                                                                                                            | 例                                                                                                  |
-| :---------------------------------------------- | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | :------------------------------------------------------------------------------------------------- |
-| `--add-dir`                                     | Claude がファイルを読み取り、編集するための追加の作業ディレクトリを追加します。ファイルアクセスを許可します。ほとんどの `.claude/` 設定は [これらのディレクトリから検出されません](/ja/permissions#additional-directories-grant-file-access-not-configuration)。各パスがディレクトリとして存在することを検証します                                                    | `claude --add-dir ../apps ../lib`                                                                  |
-| `--agent`                                       | 現在のセッションのエージェントを指定します（`agent` 設定をオーバーライドします）                                                                                                                                                                                                                  | `claude --agent my-custom-agent`                                                                   |
-| `--agents`                                      | JSON 経由でカスタム subagents を動的に定義します。subagent [frontmatter](/ja/sub-agents#supported-frontmatter-fields) と同じフィールド名を使用し、さらにエージェントの指示用の `prompt` フィールドを追加します                                                                                                        | `claude --agents '{"reviewer":{"description":"Reviews code","prompt":"You are a code reviewer"}}'` |
-| `--allow-dangerously-skip-permissions`          | `Shift+Tab` モードサイクルに `bypassPermissions` を追加します。これを開始時に有効にしません。`plan` のような別のモードで開始し、後で `bypassPermissions` に切り替えることができます。[権限モード](/ja/permission-modes#skip-all-checks-with-bypasspermissions-mode) を参照してください                                                  | `claude --permission-mode plan --allow-dangerously-skip-permissions`                               |
-| `--allowedTools`                                | 権限を求めずに実行するツール。パターンマッチングについては [権限ルール構文](/ja/settings#permission-rule-syntax) を参照してください。利用可能なツールを制限するには、代わりに `--tools` を使用してください                                                                                                                               | `"Bash(git log *)" "Bash(git diff *)" "Read"`                                                      |
-| `--append-system-prompt`                        | デフォルトシステムプロンプトの末尾にカスタムテキストを追加                                                                                                                                                                                                                                 | `claude --append-system-prompt "Always use TypeScript"`                                            |
-| `--append-system-prompt-file`                   | ファイルから追加のシステムプロンプトテキストを読み込み、デフォルトプロンプトに追加                                                                                                                                                                                                                     | `claude --append-system-prompt-file ./extra-rules.txt`                                             |
-| `--bare`                                        | 最小限モード：hooks、skills、plugins、MCP サーバー、自動メモリ、CLAUDE.md の自動検出をスキップして、スクリプト化された呼び出しをより高速に開始します。Claude は Bash、ファイル読み取り、ファイル編集ツールにアクセスできます。[`CLAUDE_CODE_SIMPLE`](/ja/env-vars) を設定します。[bare mode](/ja/headless#start-faster-with-bare-mode) を参照してください              | `claude --bare -p "query"`                                                                         |
-| `--betas`                                       | API リクエストに含めるベータヘッダー（API キーユーザーのみ）                                                                                                                                                                                                                            | `claude --betas interleaved-thinking`                                                              |
-| `--channels`                                    | （研究プレビュー）Claude がこのセッションでリッスンすべき [channel](/ja/channels) 通知を持つ MCP サーバー。`plugin:<name>@<marketplace>` エントリのスペース区切りリスト。Claude.ai 認証が必要です                                                                                                                       | `claude --channels plugin:my-notifier@my-marketplace`                                              |
-| `--chrome`                                      | Web 自動化とテストのための [Chrome ブラウザ統合](/ja/chrome) を有効にします                                                                                                                                                                                                           | `claude --chrome`                                                                                  |
-| `--continue`, `-c`                              | 現在のディレクトリで最新の会話を読み込みます。このディレクトリを `/add-dir` で追加したセッションを含みます                                                                                                                                                                                                   | `claude --continue`                                                                                |
-| `--dangerously-load-development-channels`       | 承認されたアローリストにない [channels](/ja/channels-reference#test-during-the-research-preview) をローカル開発用に有効にします。`plugin:<name>@<marketplace>` および `server:<name>` エントリを受け入れます。確認を求めます                                                                                      | `claude --dangerously-load-development-channels server:webhook`                                    |
-| `--dangerously-skip-permissions`                | すべての権限プロンプトをスキップします。`--permission-mode bypassPermissions` と同等です。[権限モード](/ja/permission-modes#skip-all-checks-with-bypasspermissions-mode) を参照して、これが何をスキップし、何をスキップしないかを確認してください                                                                                | `claude --dangerously-skip-permissions`                                                            |
-| `--debug`                                       | オプションのカテゴリフィルタリング付きでデバッグモードを有効にします（例：`"api,hooks"` または `"!statsig,!file"`）                                                                                                                                                                                    | `claude --debug "api,mcp"`                                                                         |
-| `--debug-file <path>`                           | デバッグログを特定のファイルパスに書き込みます。暗黙的にデバッグモードを有効にします。`CLAUDE_CODE_DEBUG_LOGS_DIR` より優先されます                                                                                                                                                                              | `claude --debug-file /tmp/claude-debug.log`                                                        |
-| `--disable-slash-commands`                      | このセッションのすべてのスキルとコマンドを無効にします                                                                                                                                                                                                                                   | `claude --disable-slash-commands`                                                                  |
-| `--disallowedTools`                             | モデルのコンテキストから削除され、使用できないツール                                                                                                                                                                                                                                    | `"Bash(git log *)" "Bash(git diff *)" "Edit"`                                                      |
-| `--effort`                                      | 現在のセッションの [努力レベル](/ja/model-config#adjust-effort-level) を設定します。オプション：`low`、`medium`、`high`、`xhigh`、`max`。利用可能なレベルはモデルによって異なります。セッションスコープであり、設定に永続化されません                                                                                                       | `claude --effort high`                                                                             |
-| `--enable-auto-mode`                            | {/* max-version: 2.1.110 */}v2.1.111 で削除されました。Auto mode は現在 `Shift+Tab` サイクルにデフォルトで含まれています。`--permission-mode auto` を使用して開始してください                                                                                                                             | `claude --permission-mode auto`                                                                    |
-| `--exclude-dynamic-system-prompt-sections`      | システムプロンプトからマシンごとのセクション（作業ディレクトリ、環境情報、メモリパス、git ステータス）を最初のユーザーメッセージに移動します。異なるユーザーとマシンで同じタスクを実行する場合、prompt-cache の再利用を改善します。デフォルトシステムプロンプトにのみ適用されます。`--system-prompt` または `--system-prompt-file` が設定されている場合は無視されます。スクリプト化された複数ユーザーのワークロードの場合は `-p` と一緒に使用してください | `claude -p --exclude-dynamic-system-prompt-sections "query"`                                       |
```

</details>

<details>
<summary>debug-your-config-ja.md</summary>

```diff
diff --git a/docs-ja/pages/debug-your-config-ja.md b/docs-ja/pages/debug-your-config-ja.md
index 1abb6e4..846395c 100644
--- a/docs-ja/pages/debug-your-config-ja.md
+++ b/docs-ja/pages/debug-your-config-ja.md
@@ -9,5 +9,5 @@
 Claude が指示を無視したり、設定した機能が表示されない場合、通常の原因はファイルが読み込まれなかった、予期した場所とは異なる場所から読み込まれた、または別のファイルがそれをオーバーライドしたことです。このガイドでは、Claude Code が実際に読み込んだ内容を検査して、どれが当てはまるかを絞り込む方法を示します。
 
-インストール、認証、接続の問題については、代わりに [トラブルシューティング](/ja/troubleshoot-install) を参照してください。
+インストール、認証、接続の問題については、代わりに [トラブルシューティング インストールとログイン](/ja/troubleshoot-install) を参照してください。
 
 ## コンテキストに読み込まれた内容を確認する
@@ -17,14 +17,15 @@ Claude が指示を無視したり、設定した機能が表示されない場
 特定のカテゴリの詳細については、専用コマンドで確認してください：
 
-| コマンド           | 表示内容                                      |
-| :------------- | :---------------------------------------- |
-| `/memory`      | 読み込まれた `CLAUDE.md` とルールファイル、およびオートメモリエントリ |
-| `/skills`      | プロジェクト、ユーザー、プラグインソースから利用可能なスキル            |
-| `/agents`      | 設定されたサブエージェントとその設定                        |
-| `/hooks`       | アクティブなフック設定                               |
-| `/mcp`         | 接続された MCP サーバーとそのステータス                    |
-| `/permissions` | 現在有効な許可と拒否ルール                             |
-| `/doctor`      | 設定診断：無効なキー、スキーマエラー、インストール状態               |
-| `/status`      | アクティブな設定ソース（マネージド設定が有効かどうかを含む）            |
+| コマンド             | 表示内容                                               |
+| :--------------- | :------------------------------------------------- |
+| `/memory`        | 読み込まれた `CLAUDE.md` とルールファイル、およびオートメモリエントリ          |
+| `/skills`        | プロジェクト、ユーザー、プラグインソースから利用可能なスキル                     |
+| `/agents`        | 設定されたサブエージェントとその設定                                 |
+| `/hooks`         | アクティブなフック設定                                        |
```

</details>

*...以降省略*

</details>


<details>
<summary>2026-05-07</summary>

**変更ファイル:**

```
 docs-ja/pages/changelog.md                |  66 ++++++++++++
 docs-ja/pages/cli-reference-ja.md         |   7 +-
 docs-ja/pages/commands-ja.md              |  10 +-
 docs-ja/pages/env-vars-ja.md              |  13 ++-
 docs-ja/pages/features-overview-ja.md     |   8 +-
 docs-ja/pages/headless-ja.md              |  32 +++++-
 docs-ja/pages/how-claude-code-works-ja.md |  24 ++---
 docs-ja/pages/interactive-mode-ja.md      |   3 +-
 docs-ja/pages/llm-gateway-ja.md           |   4 +-
 docs-ja/pages/model-config-ja.md          |  42 +++++---
 docs-ja/pages/monitoring-usage-ja.md      |  82 ++++++++++++++-
 docs-ja/pages/plugins-ja.md               |   6 ++
 docs-ja/pages/plugins-reference-ja.md     |  46 +++++----
 docs-ja/pages/settings-ja.md              | 161 +++++++++++++++---------------
 docs-ja/pages/setup-ja.md                 |  10 +-
 docs-ja/pages/skills-ja.md                |  95 ++++++++++++------
 16 files changed, 424 insertions(+), 185 deletions(-)
```

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index 4051405..a109771 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,70 @@
 # Changelog
 
+## 2.1.132
+
+- Added `CLAUDE_CODE_SESSION_ID` environment variable to the Bash tool subprocess environment, matching the `session_id` passed to hooks
+- Added `CLAUDE_CODE_DISABLE_ALTERNATE_SCREEN=1` env var to opt out of the fullscreen alternate-screen renderer and keep the conversation in the terminal's native scrollback
+- Added a "Pasting…" footer hint while a Ctrl+V image paste is being read from the clipboard
+- Fixed external SIGINT (e.g. IDE stop button, `kill -INT`) not running graceful shutdown — terminal modes are now restored and the `--resume` hint is printed instead of an abrupt exit
+- Fixed an uncaught exception when the terminal is closed or SSH disconnects mid-session under the native build
+- Fixed `--resume` failing with `no low surrogate in string` when a tool error truncation split an emoji; pre-corrupted sessions are sanitized on load
+- Fixed `--permission-mode` flag being ignored when resuming a plan-mode session with `-p --continue`/`--resume`, and plan mode not being re-applied after `ExitPlanMode` within the same session
+- Fixed fullscreen mode showing a blank screen after laptop sleep/wake or Ctrl+Z/`fg` until the next keystroke or stream output
+- Fixed cursor landing mid-grapheme on Ctrl+E/A/K/U/arrow keys when an Indic conjunct or ZWJ emoji wraps across lines
+- Fixed vim operators corrupting text containing decomposed (NFD) accented characters
+- Fixed pasting text starting with `/` silently swallowing the input or triggering an unknown-command reply
+- Fixed pasting dumping stray escape sequences into the prompt when focus events or mouse-tracking reports interleave with the bracketed paste
+- Fixed mouse wheel scrolling being too fast in Cursor and VS Code 1.92–1.104 due to an upstream xterm.js bug
+- Fixed scroll-wheel handling in JetBrains IDE 2025.2 terminals (spurious arrow keys, wrong-direction events, runaway acceleration)
+- Fixed `/usage` Ctrl+S hanging when copying the stats screenshot to the clipboard on Linux/X11
+- Fixed `/terminal-setup` showing a contradictory error in Windows Terminal — Shift+Enter is natively supported there
+- Fixed `/effort` picker not reflecting the `CLAUDE_CODE_EFFORT_LEVEL` env var override
+- Fixed `/status` showing the wrong default model for some users
+- Fixed slash command autocomplete popup being capped at ~3–5 visible commands instead of scaling with terminal height
+- Fixed statusline `context_window` token counts reflecting cumulative session totals instead of current context usage
+- Fixed Alt+T (thinking toggle) not working on macOS terminals without "Option as Meta" enabled (iTerm2, Terminal.app defaults)
```

</details>

<details>
<summary>cli-reference-ja.md</summary>

```diff
diff --git a/docs-ja/pages/cli-reference-ja.md b/docs-ja/pages/cli-reference-ja.md
index d535196..08d61cd 100644
--- a/docs-ja/pages/cli-reference-ja.md
+++ b/docs-ja/pages/cli-reference-ja.md
@@ -84,5 +84,6 @@
 | `--permission-mode`                             | 指定された [権限モード](/ja/permission-modes) で開始します。`default`、`acceptEdits`、`plan`、`auto`、`dontAsk`、または `bypassPermissions` を受け入れます。設定ファイルの `defaultMode` をオーバーライドします                                                                                                  | `claude --permission-mode plan`                                                                    |
 | `--permission-prompt-tool`                      | 非インタラクティブモードで権限プロンプトを処理する MCP ツールを指定します                                                                                                                                                                                                                       | `claude -p --permission-prompt-tool mcp_auth_tool "query"`                                         |
-| `--plugin-dir`                                  | このセッションのみのプラグインをディレクトリから読み込みます。各フラグは 1 つのパスを取ります。複数のディレクトリの場合はフラグを繰り返します：`--plugin-dir A --plugin-dir B`                                                                                                                                                      | `claude --plugin-dir ./my-plugins`                                                                 |
+| `--plugin-dir`                                  | このセッションのみのプラグインをディレクトリまたは `.zip` アーカイブから読み込みます。各フラグは 1 つのパスを取ります。複数のプラグインの場合はフラグを繰り返します：`--plugin-dir A --plugin-dir B.zip`                                                                                                                                   | `claude --plugin-dir ./my-plugin`                                                                  |
+| `--plugin-url`                                  | このセッションのみのプラグイン `.zip` アーカイブを URL から取得します。各フラグは 1 つの URL を取ります。複数のプラグインの場合はフラグを繰り返します                                                                                                                                                                         | `claude --plugin-url https://example.com/plugin.zip`                                               |
 | `--print`, `-p`                                 | インタラクティブモードなしで応答を出力します（プログラムによる使用の詳細については [Agent SDK ドキュメント](/ja/agent-sdk/overview) を参照）                                                                                                                                                                     | `claude -p "query"`                                                                                |
 | `--remote`                                      | 提供されたタスク説明で claude.ai に新しい [Web セッション](/ja/claude-code-on-the-web) を作成します                                                                                                                                                                                     | `claude --remote "Fix the login bug"`                                                              |
@@ -93,5 +94,5 @@
 | `--session-id`                                  | 会話に特定のセッション ID を使用します（有効な UUID である必要があります）                                                                                                                                                                                                                    | `claude --session-id "550e8400-e29b-41d4-a716-446655440000"`                                       |
 | `--setting-sources`                             | 読み込む設定ソースのカンマ区切りリスト（`user`、`project`、`local`）                                                                                                                                                                                                                 | `claude --setting-sources user,project`                                                            |
-| `--settings`                                    | 追加の設定を読み込むための設定 JSON ファイルまたは JSON 文字列へのパス                                                                                                                                                                                                                     | `claude --settings ./settings.json`                                                                |
+| `--settings`                                    | 設定 JSON ファイルまたはインライン JSON 文字列へのパス。ここで設定した値は、このセッションの `settings.json` ファイル内の同じキーをオーバーライドします。省略したキーはファイルベースの値を保持します。[設定の優先順位](/ja/settings#settings-precedence) を参照してください                                                                                       | `claude --settings ./settings.json`                                                                |
 | `--strict-mcp-config`                           | `--mcp-config` からのみ MCP サーバーを使用し、他のすべての MCP 設定を無視します                                                                                                                                                                                                          | `claude --strict-mcp-config --mcp-config ./mcp.json`                                               |
 | `--system-prompt`                               | デフォルトシステムプロンプト全体をカスタムテキストで置き換え                                                                                                                                                                                                                                | `claude --system-prompt "You are a Python expert"`                                                 |
@@ -103,5 +104,5 @@
 | `--verbose`                                     | 詳細ログを有効にし、ターンごとの完全な出力を表示                                                                                                                                                                                                                                      | `claude --verbose`                                                                                 |
 | `--version`, `-v`                               | バージョン番号を出力                                                                                                                                                                                                                                                    | `claude -v`                                                                                        |
-| `--worktree`, `-w`                              | Claude を `<repo>/.claude/worktrees/<name>` の分離された [git worktree](/ja/common-workflows#run-parallel-claude-code-sessions-with-git-worktrees) で開始します。名前が指定されていない場合は、自動生成されます                                                                                    | `claude -w feature-auth`                                                                           |
+| `--worktree`, `-w`                              | Claude を `<repo>/.claude/worktrees/<name>` の分離された [git worktree](/ja/worktrees) で開始します。名前が指定されていない場合は、自動生成されます                                                                                                                                                | `claude -w feature-auth`                                                                           |
 
 ### システムプロンプトフラグ
```

</details>

<details>
<summary>commands-ja.md</summary>

```diff
diff --git a/docs-ja/pages/commands-ja.md b/docs-ja/pages/commands-ja.md
index 727d194..98542ab 100644
--- a/docs-ja/pages/commands-ja.md
+++ b/docs-ja/pages/commands-ja.md
@@ -11,4 +11,6 @@
 `/` と入力すると、利用可能なすべてのコマンドが表示されます。または `/` の後に文字を入力してフィルタリングできます。
 
+コマンドはメッセージの開始時にのみ認識されます。コマンド名の後に続くテキストは引数として渡されます。
+
 以下の表は Claude Code に含まれるすべてのコマンドをリストしています。**[スキル](/ja/skills#bundled-skills)** とマークされたエントリはバンドルされたスキルです。これらは自分で作成するスキルと同じメカニズムを使用します。Claude に渡されるプロンプトであり、Claude は関連する場合に自動的に呼び出すこともできます。その他はすべて、CLI にコード化された動作を持つ組み込みコマンドです。独自のコマンドを追加するには、[スキル](/ja/skills)を参照してください。
 
@@ -22,5 +24,5 @@
 | `/agents`                                       | [エージェント](/ja/sub-agents)設定を管理                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
 | `/autofix-pr [prompt]`                          | 現在のブランチの PR を監視し、CI が失敗するか、レビュアーがコメントを残したときに修正をプッシュする [Claude Code on the web](/ja/claude-code-on-the-web#auto-fix-pull-requests) セッションを生成。`gh pr view` で開いている PR を検出します。別の PR を監視するには、最初にそのブランチをチェックアウトしてください。デフォルトでは、リモートセッションはすべての CI 失敗とレビューコメントを修正するよう指示されます。プロンプトを渡して異なる指示を与えることができます。例えば `/autofix-pr only fix lint and type errors`。`gh` CLI と [Claude Code on the web](/ja/claude-code-on-the-web#who-can-use-claude-code-on-the-web) へのアクセスが必要です                                                   |
-| `/batch <instruction>`                          | **[スキル](/ja/skills#bundled-skills)。** コードベース全体にわたる大規模な変更を並列で調整します。コードベースを調査し、作業を 5 ～ 30 個の独立したユニットに分解し、計画を提示します。承認されると、分離された [git worktree](/ja/common-workflows#run-parallel-claude-code-sessions-with-git-worktrees) 内の各ユニットごとに 1 つのバックグラウンドエージェントを生成します。各エージェントはそのユニットを実装し、テストを実行し、プルリクエストを開きます。git リポジトリが必要です。例: `/batch migrate src/ from Solid to React`                                                                                                                                               |
+| `/batch <instruction>`                          | **[スキル](/ja/skills#bundled-skills)。** コードベース全体にわたる大規模な変更を並列で調整します。コードベースを調査し、作業を 5 ～ 30 個の独立したユニットに分解し、計画を提示します。承認されると、分離された [git worktree](/ja/worktrees) 内の各ユニットごとに 1 つのバックグラウンドエージェントを生成します。各エージェントはそのユニットを実装し、テストを実行し、プルリクエストを開きます。git リポジトリが必要です。例: `/batch migrate src/ from Solid to React`                                                                                                                                                                                                           |
 | `/branch [name]`                                | この時点で現在の会話のブランチを作成。ブランチに切り替え、元の会話を保持します。`/resume` で戻ることができます。エイリアス: `/fork`。[`CLAUDE_CODE_FORK_SUBAGENT`](/ja/env-vars) が設定されている場合、`/fork` は代わりに[フォークされたサブエージェント](/ja/sub-agents#fork-the-current-conversation)を生成し、このコマンドのエイリアスではなくなります                                                                                                                                                                                                                                                                     |
 | `/btw <question>`                               | 会話に追加せずに[サイドクエスチョン](/ja/interactive-mode#side-questions-with-%2Fbtw)として素早く質問                                                                                                                                                                                                                                                                                                                                                                                                                                 |
@@ -28,5 +30,5 @@
 | `/claude-api [migrate\|managed-agents-onboard]` | **[スキル](/ja/skills#bundled-skills)。** プロジェクトの言語（Python、TypeScript、Java、Go、Ruby、C#、PHP、または cURL）と Managed Agents リファレンス用の Claude API リファレンス資料を読み込みます。ツール使用、ストリーミング、バッチ、構造化出力、および一般的な落とし穴をカバーしています。また、コードが `anthropic` または `@anthropic-ai/sdk` をインポートするときに自動的にアクティブになります。`/claude-api migrate` を実行して、既存の Claude API コードを新しいモデルにアップグレード: Claude はスキャンするファイルとターゲットモデルを尋ね、モデル ID、思考設定、およびバージョン間で変更されたその他のパラメータを更新します。`/claude-api managed-agents-onboard` を実行して、新しい Managed Agent をゼロから作成するインタラクティブなウォークスルーを実施します |
 | `/clear`                                        | 空のコンテキストで新しい会話を開始。前の会話は `/resume` で利用可能なままです。同じ会話を続けながらコンテキストを解放するには、代わりに `/compact` を使用してください。エイリアス: `/reset`、`/new`                                                                                                                                                                                                                                                                                                                                                                                        |
-| `/color [color\|default]`                       | 現在のセッションのプロンプトバーの色を設定。利用可能な色: `red`、`blue`、`green`、`yellow`、`purple`、`orange`、`pink`、`cyan`。`default` を使用してリセット。[リモートコントロール](/ja/remote-control)が接続されている場合、色は claude.ai/code に同期されます                                                                                                                                                                                                                                                                                                                         |
+| `/color [color\|default]`                       | 現在のセッションのプロンプトバーの色を設定。利用可能な色: `red`、`blue`、`green`、`yellow`、`purple`、`orange`、`pink`、`cyan`。`default` を使用してリセット。引数なしで実行するとランダムな色を選択します。[リモートコントロール](/ja/remote-control)が接続されている場合、色は claude.ai/code に同期されます                                                                                                                                                                                                                                                                                                  |
 | `/compact [instructions]`                       | 会話をここまで要約してコンテキストを解放。オプションで要約のフォーカス指示を渡します。[コンパクション時にルール、スキル、メモリファイルがどのように処理されるか](/ja/context-window#what-survives-compaction)を参照してください                                                                                                                                                                                                                                                                                                                                                                      |
 | `/config`                                       | [設定](/ja/settings)インターフェースを開いて、テーマ、モデル、[出力スタイル](/ja/output-styles)、およびその他の設定を調整。エイリアス: `/settings`                                                                                                                                                                                                                                                                                                                                                                                                           |
@@ -45,5 +47,5 @@
 | `/feedback [report]`                            | Claude Code に関するフィードバックを送信。エイリアス: `/bug`                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
 | `/fewer-permission-prompts`                     | **[スキル](/ja/skills#bundled-skills)。** トランスクリプトで一般的な読み取り専用 Bash と MCP ツール呼び出しをスキャンし、プロジェクト `.claude/settings.json` に優先度付きの許可リストを追加して権限プロンプトを削減します                                                                                                                                                                                                                                                                                                                                                             |
-| `/focus`                                        | フォーカスビューを切り替えます。最後のプロンプト、編集 diffstats を含む 1 行のツール呼び出し要約、および最終応答のみを表示します。選択は複数セッション間で保持されます。[フルスクリーンレンダリング](/ja/fullscreen)でのみ利用可能です                                                                                                                                                                                                                                                                                                                                                                          |
+| `/focus`                                        | フォーカスビューを切り替えます。最後のプロンプト、編集 diffstats を含む 1 行のツール呼び出し要約、および最終応答のみを表示します。選択は複数セッション間で保持されます。設定で [`viewMode`](/ja/settings#available-settings) を設定してオーバーライドします。[フルスクリーンレンダリング](/ja/fullscreen)でのみ利用可能です                                                                                                                                                                                                                                                                                                        |
```

</details>

<details>
<summary>env-vars-ja.md</summary>

```diff
diff --git a/docs-ja/pages/env-vars-ja.md b/docs-ja/pages/env-vars-ja.md
index f4c5c35..67ee4e1 100644
--- a/docs-ja/pages/env-vars-ja.md
+++ b/docs-ja/pages/env-vars-ja.md
@@ -61,5 +61,5 @@ Claude Code は、その動作を制御するために以下の環境変数を
 | `CLAUDE_CODE_AUTO_COMPACT_WINDOW`                       | オートコンパクション計算に使用されるコンテキスト容量をトークン単位で設定します。デフォルトはモデルのコンテキストウィンドウです：標準モデルの場合は 200K、[拡張コンテキスト](/ja/model-config#extended-context) モデルの場合は 1M。1M モデルで `500000` などの低い値を使用して、コンパクション目的でウィンドウを 500K として扱います。値はモデルの実際のコンテキストウィンドウでキャップされます。`CLAUDE_AUTOCOMPACT_PCT_OVERRIDE` はこの値のパーセンテージとして適用されます。この変数を設定すると、コンパクション閾値がステータスラインの `used_percentage` から分離されます。これは常にモデルの完全なコンテキストウィンドウを使用します                                      |
 | `CLAUDE_CODE_AUTO_CONNECT_IDE`                          | 自動 [IDE 接続](/ja/vs-code) をオーバーライドします。デフォルトでは、Claude Code はサポートされている IDE の統合ターミナル内で起動されると自動的に接続します。これを防ぐには `false` に設定します。tmux が親ターミナルを隠すなど、自動検出が失敗した場合に接続を強制するには `true` に設定します                                                                                                                                                                                                                                        |
-| `CLAUDE_CODE_CERT_STORE`                                | TLS 接続用の CA 証明書ソースのカンマ区切りリスト。`bundled` は Claude Code に付属する Mozilla CA セットです。`system` はオペレーティングシステムの信頼ストアです。デフォルトは `bundled,system` です。システムストア統合にはネイティブバイナリ配布が必須です。Node.js ランタイムでは、この値に関係なく、バンドルされたセットのみが使用されます                                                                                                                                                                                                        |
+| `CLAUDE_CODE_CERT_STORE`                                | TLS 接続用の CA 証明書ソースのカンマ区切りリスト。`bundled` は Claude Code に付属する Mozilla CA セットです。`system` はオペレーティングシステムの信頼ストアです。デフォルトは `bundled,system` です                                                                                                                                                                                                                                                                                 |
 | `CLAUDE_CODE_CLIENT_CERT`                               | mTLS 認証用のクライアント証明書ファイルへのパス                                                                                                                                                                                                                                                                                                                                                                                            |
 | `CLAUDE_CODE_CLIENT_KEY`                                | mTLS 認証用のクライアント秘密鍵ファイルへのパス                                                                                                                                                                                                                                                                                                                                                                                            |
@@ -91,5 +91,6 @@ Claude Code は、その動作を制御するために以下の環境変数を
 | `CLAUDE_CODE_ENABLE_AWAY_SUMMARY`                       | [セッションリキャップ](/ja/interactive-mode#session-recap) の利用可能性をオーバーライドします。`/config` トグルに関係なくリキャップを強制的にオフにするには `0` に設定します。[`awaySummaryEnabled`](/ja/settings#available-settings) が `false` の場合にリキャップを強制的にオンにするには `1` に設定します。設定と `/config` トグルより優先されます                                                                                                                                                                        |
 | `CLAUDE_CODE_ENABLE_BACKGROUND_PLUGIN_REFRESH`          | [非対話モード](/ja/headless) でバックグラウンドインストールが完了した後、ターン境界でプラグイン状態をリフレッシュするには `1` に設定します。リフレッシュはセッション中にシステムプロンプトを変更するため、デフォルトではオフです。これにより、そのターンの [プロンプトキャッシング](https://platform.claude.com/docs/en/build-with-claude/prompt-caching) が無効になります                                                                                                                                                                                 |
-| `CLAUDE_CODE_ENABLE_FINE_GRAINED_TOOL_STREAMING`        | 細粒度ツール入力ストリーミングを強制的に有効にするには `1` に設定します。これがない場合、API はツール入力パラメータを完全にバッファリングしてからデルタイベントを送信します。これは大きなツール入力での表示を遅延させる可能性があります。Anthropic API のみ：Bedrock、Vertex、または Foundry では効果がありません                                                                                                                                                                                                                                       |
+| `CLAUDE_CODE_ENABLE_FINE_GRAINED_TOOL_STREAMING`        | ツール呼び出し入力が Claude によって生成されるときに API からストリーミングされるかどうかを制御します。これがない場合、大きなツール入力（長いファイル書き込みなど）は Claude が生成を完了した後にのみ到着します。これは、ハングしているように見える可能性があります。Anthropic API のみで有効です。Bedrock、Vertex、Foundry、または [ゲートウェイ](/ja/llm-gateway) 接続には効果がありません                                                                                                                                                                                  |
+| `CLAUDE_CODE_ENABLE_GATEWAY_MODEL_DISCOVERY`            | `ANTHROPIC_BASE_URL` が LiteLLM、Kong、または内部プロキシなどの Anthropic 互換ゲートウェイを指している場合、ゲートウェイの `/v1/models` エンドポイントから `/model` ピッカーを入力するには `1` に設定します。共有 API キーでバックアップされたゲートウェイはそれ以外の場合、すべてのユーザーにキーがアクセスできるすべてのモデルを表示するため、デフォルトではオフです。検出されたモデルは依然として [`availableModels`](/ja/settings#available-settings) 許可リストでフィルタリングされます                                                                                                      |
 | `CLAUDE_CODE_ENABLE_PROMPT_SUGGESTION`                  | プロンプト提案を無効にするには `false` に設定します（`/config` の「プロンプト提案」トグル）。これらは Claude が応答した後にプロンプト入力に表示される灰色の予測です。[プロンプト提案](/ja/interactive-mode#prompt-suggestions) を参照してください                                                                                                                                                                                                                                                          |
 | `CLAUDE_CODE_ENABLE_TASKS`                              | 非対話モード（`-p` フラグ）でタスク追跡システムを有効にするには `1` に設定します。タスクは対話モードではデフォルトでオンです。[タスクリスト](/ja/interactive-mode#task-list) を参照してください                                                                                                                                                                                                                                                                                                |
@@ -99,4 +100,5 @@ Claude Code は、その動作を制御するために以下の環境変数を
 | `CLAUDE_CODE_EXTRA_BODY`                                | すべての API リクエストボディの最上位にマージする JSON オブジェクト。Claude Code が直接公開していないプロバイダー固有のパラメータを渡すのに役立ちます                                                                                                                                                                                                                                                                                                                                |
 | `CLAUDE_CODE_FILE_READ_MAX_OUTPUT_TOKENS`               | ファイル読み取りのデフォルトトークン制限をオーバーライドします。より大きなファイルを完全に読み取る必要がある場合に役立ちます                                                                                                                                                                                                                                                                                                                                                        |
+| `CLAUDE_CODE_FORCE_SYNC_OUTPUT`                         | ターミナルがサポートしているが自動検出されていない場合、DEC プライベートモード 2026 [同期出力](https://gist.github.com/christianparpart/d8a62cc1ab659194337d73e399004036) を強制的に有効にするには `1` に設定します。Emacs `eat` などのエミュレーターで役立ちます。これは BSU/ESU を実装していますが、機能プローブに応答しません。tmux では効果がありません                                                                                                                                                                             |
 | `CLAUDE_CODE_FORK_SUBAGENT`                             | [フォークされた subagent](/ja/sub-agents#fork-the-current-conversation) を有効にするには `1` に設定します。フォークされた subagent は、最初から開始する代わりに、メインセッションから完全な会話コンテキストを継承します。有効にすると、`/fork` は [`/branch`](/ja/commands) のエイリアスとして機能する代わりに、フォークされた subagent をスポーンします。すべての subagent スポーンはバックグラウンドで実行されます。対話モードと SDK または `claude -p` を通じて                                                                                                            |
 | `CLAUDE_CODE_GIT_BASH_PATH`                             | Windows のみ：Git Bash 実行可能ファイル（`bash.exe`）へのパス。Git Bash がインストールされているが PATH にない場合に使用します。[Windows セットアップ](/ja/setup#set-up-on-windows) を参照してください                                                                                                                                                                                                                                                                          |
@@ -121,4 +123,5 @@ Claude Code は、その動作を制御するために以下の環境変数を
 | `CLAUDE_CODE_OTEL_HEADERS_HELPER_DEBOUNCE_MS`           | 動的 OpenTelemetry ヘッダーをリフレッシュする間隔（ミリ秒）（デフォルト：1740000 / 29 分）。[動的ヘッダー](/ja/monitoring-usage#dynamic-headers) を参照してください                                                                                                                                                                                                                                                                                                  |
 | `CLAUDE_CODE_OTEL_SHUTDOWN_TIMEOUT_MS`                  | シャットダウン時に OpenTelemetry エクスポーターが完了するためのタイムアウト（ミリ秒）（デフォルト：2000）。終了時にメトリクスがドロップされる場合は増やしてください。[監視](/ja/monitoring-usage) を参照してください                                                                                                                                                                                                                                                                                      |
+| `CLAUDE_CODE_PACKAGE_MANAGER_AUTO_UPDATE`               | 新しいバージョンが利用可能な場合、Claude Code がパッケージマネージャーのアップグレードコマンドをバックグラウンドで実行できるようにするには `1` に設定します。Homebrew と WinGet インストールに適用されます。他のパッケージマネージャーは、実行せずにアップグレードコマンドを表示し続けます。[自動更新](/ja/setup#auto-updates) を参照してください                                                                                                                                                                                                               |
 | `CLAUDE_CODE_PERFORCE_MODE`                             | Perforce 対応の書き込み保護を有効にするには `1` に設定します。設定されている場合、Edit、Write、NotebookEdit は、ターゲットファイルが所有者書き込みビットを欠いている場合に `p4 edit <file>` ヒント付きで失敗します。これは Perforce が同期されたファイルで消去し、`p4 edit` が開くまで消去したままにします。これにより、Claude Code が Perforce 変更追跡をバイパスすることを防ぎます                                                                                                                                                                            |
```

</details>

<details>
<summary>features-overview-ja.md</summary>

```diff
diff --git a/docs-ja/pages/features-overview-ja.md b/docs-ja/pages/features-overview-ja.md
index c306054..1dae4a0 100644
--- a/docs-ja/pages/features-overview-ja.md
+++ b/docs-ja/pages/features-overview-ja.md
@@ -206,5 +206,5 @@ Claude Code は、コードについて推論するモデルと、ファイル
 ## コンテキストコストを理解する
 
-追加する各機能は Claude のコンテキストの一部を消費します。多すぎるとコンテキストウィンドウがいっぱいになる可能性がありますが、Claude の効果を低下させるノイズを追加することもできます。スキルが正しくトリガーされない場合や、Claude が規約を失う場合があります。これらのトレードオフを理解することで、効果的なセットアップを構築するのに役立ちます。実行中のセッションでこれらの機能がどのように組み合わされるかのインタラクティブビューについては、[Explore the context window](/ja/context-window) を参照してください。
+追加する各機能は Claude のコンテキストの一部を消費します。多すぎるとコンテキストウィンドウがいっぱいになる可能性がありますが、Claude の効果を低下させるノイズを追加することもできます。スキルが正しくトリガーされない場合や、Claude が規約を失う場合があります。これらのトレードオフを理解することで、効果的なセットアップを構築するのに役立ちます。実行中のセッションでこれらの機能がどのように組み合わされるかのインタラクティブビューについては、[コンテキストウィンドウを探索する](/ja/context-window) を参照してください。
 
 ### 機能別のコンテキストコスト
@@ -220,5 +220,5 @@ Claude Code は、コードについて推論するモデルと、ファイル
 | **Hooks**     | トリガー時         | なし（外部で実行）                 | ゼロ（フックが追加コンテキストを返さない限り） |
 
-\*デフォルトでは、スキル説明はセッション開始時にロードされるため、Claude はそれらを使用する時期を決定できます。スキルの frontmatter で `disable-model-invocation: true` を設定して、手動で呼び出すまで Claude から完全に非表示にします。これにより、自分でのみトリガーするスキルのコンテキストコストをゼロに削減します。
+\*デフォルトでは、スキル説明はセッション開始時にロードされるため、Claude はそれらを使用する時期を決定できます。スキルの frontmatter で `disable-model-invocation: true` を設定して、手動で呼び出すまで Claude から完全に非表示にします。これにより、自分でのみトリガーするスキルのコンテキストコストをゼロに削減します。書いていないスキルの場合は、ファイルを編集せずに同じことを行うために settings で [`skillOverrides`](/ja/skills#override-skill-visibility-from-settings) を設定します。
 
 ### 機能がどのようにロードされるかを理解する
@@ -234,5 +234,5 @@ Claude Code は、コードについて推論するモデルと、ファイル
     **ロード内容：** すべての CLAUDE.md ファイル（管理、ユーザー、プロジェクトレベル）の完全なコンテンツ。
 
-    **継承：** Claude は作業ディレクトリからルートまで CLAUDE.md ファイルを読み取り、サブディレクトリにネストされたものを、それらのファイルにアクセスするときに検出します。詳細は [How CLAUDE.md files load](/ja/memory#how-claudemd-files-load) を参照してください。
+    **継承：** Claude は作業ディレクトリからルートまで CLAUDE.md ファイルを読み取り、サブディレクトリにネストされたものを、それらのファイルにアクセスするときに検出します。詳細は [CLAUDE.md ファイルがどのようにロードされるか](/ja/memory#how-claudemd-files-load) を参照してください。
 
     <Tip>CLAUDE.md を 200 行以下に保ちます。リファレンスマテリアルをスキルに移動します。スキルはオンデマンドでロードされます。</Tip>
@@ -260,5 +260,5 @@ Claude Code は、コードについて推論するモデルと、ファイル
     **ロード内容：** 接続されたサーバーからのツール名。完全な JSON スキーマは Claude が特定のツールを必要とするまで遅延されます。
 
-    **コンテキストコスト：** [Tool search](/ja/mcp#scale-with-mcp-tool-search) はデフォルトで有効になっているため、アイドル MCP ツールは最小限のコンテキストを消費します。
+    **コンテキストコスト：** [ツール検索](/ja/mcp#scale-with-mcp-tool-search) はデフォルトで有効になっているため、アイドル MCP ツールは最小限のコンテキストを消費します。
```

</details>

<details>
<summary>headless-ja.md</summary>

```diff
diff --git a/docs-ja/pages/headless-ja.md b/docs-ja/pages/headless-ja.md
index ec16841..9a5267f 100644
--- a/docs-ja/pages/headless-ja.md
+++ b/docs-ja/pages/headless-ja.md
@@ -55,5 +55,5 @@ claude --bare -p "Summarize this file" --allowedTools "Read"
 | MCP サーバー    | `--mcp-config <file-or-json>`                          |
 | カスタムエージェント  | `--agents <json>`                                      |
-| プラグインディレクトリ | `--plugin-dir <path>`                                  |
+| プラグイン       | `--plugin-dir <path>`、`--plugin-url <url>`             |
 
 ベアモードは OAuth とキーチェーン読み取りをスキップします。Anthropic 認証は `ANTHROPIC_API_KEY` または `--settings` に渡される JSON の `apiKeyHelper` から取得する必要があります。Bedrock、Vertex、および Foundry は通常のプロバイダー認証情報を使用します。
@@ -67,4 +67,34 @@ claude --bare -p "Summarize this file" --allowedTools "Read"
 これらの例は、一般的な CLI パターンを強調しています。CI およびその他のスクリプト呼び出しの場合は、[`--bare`](#start-faster-with-bare-mode) を追加して、ローカルで設定されているものを取得しないようにします。
 
+### Claude にデータをパイプする
+
+非対話モードは stdin を読み取るため、他のコマンドラインツールと同様にデータをパイプして応答をリダイレクトできます。
+
+この例は、ビルドログを Claude にパイプし、説明をファイルに書き込みます。
+
+```bash theme={null}
+cat build-error.txt | claude -p 'concisely explain the root cause of this build error' > output.txt
+```
+
+`--output-format json` を使用すると、応答ペイロードに `total_cost_usd` とモデルごとのコスト内訳が含まれるため、スクリプト呼び出し元は [使用状況ダッシュボード](/ja/costs) を参照せずに呼び出しごとの支出を追跡できます。
+
+<Note>
+  Claude Code v2.1.128 以降、パイプされた stdin は 10MB に制限されています。制限を超える場合、Claude Code は明確なエラーと 0 以外のステータスで終了します。より大きな入力を処理するには、コンテンツをファイルに書き込み、パイプする代わりにプロンプトでファイルパスを参照してください。
+</Note>
+
```

</details>

*...以降省略*

</details>


<!-- UPDATE_LOG_END -->
