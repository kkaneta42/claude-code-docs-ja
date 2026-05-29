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
<summary>2026-05-29</summary>

**変更ファイル:**

```
 docs-ja/pages/agent-view-ja.md       | 24 +++++-----
 docs-ja/pages/agents-ja.md           | 36 ++++++++++-----
 docs-ja/pages/best-practices-ja.md   | 15 ++++---
 docs-ja/pages/changelog.md           | 86 ++++++++++++++++++++++++++++++++++++
 docs-ja/pages/claude-directory-ja.md | 82 ++++++++++++++++++++++------------
 docs-ja/pages/commands-ja.md         | 16 +++++--
 docs-ja/pages/desktop-ja.md          |  2 +-
 docs-ja/pages/env-vars-ja.md         | 15 ++++---
 docs-ja/pages/fast-mode-ja.md        | 35 ++++++++-------
 docs-ja/pages/glossary-ja.md         | 26 +++++++----
 docs-ja/pages/hooks-ja.md            | 18 ++++----
 docs-ja/pages/keybindings-ja.md      | 10 ++---
 docs-ja/pages/model-config-ja.md     | 32 +++++++++-----
 docs-ja/pages/monitoring-usage-ja.md |  1 +
 docs-ja/pages/settings-ja.md         |  4 ++
 docs-ja/pages/setup-ja.md            |  6 ++-
 docs-ja/pages/skills-ja.md           |  2 +-
 docs-ja/pages/statusline-ja.md       | 76 ++++++++++++++++---------------
 docs-ja/pages/sub-agents-ja.md       | 10 +++++
 19 files changed, 341 insertions(+), 155 deletions(-)
```

**新規追加:**


<details>
<summary>agent-view-ja.md</summary>

```diff
diff --git a/docs-ja/pages/agent-view-ja.md b/docs-ja/pages/agent-view-ja.md
index 22f28cc..6e99095 100644
--- a/docs-ja/pages/agent-view-ja.md
+++ b/docs-ja/pages/agent-view-ja.md
@@ -88,5 +88,5 @@ Pinned
 
 Ready for review
-  ∙ jump physics              Opened PR with collision fix            ⧉ PR #2048  2h
+  ∙ jump physics              Opened PR with collision fix              PR #2048  2h
 
 Needs input
@@ -124,5 +124,5 @@ Completed
 | `✢`                | [`/loop`](/ja/scheduled-tasks) セッションはイテレーション間でスリープしています。行は実行回数とカウントダウンを表示します |
 
-行の右端に表示される `⧉ PR #N` ラベルは [セッションが開いたプルリクエスト](#pull-request-status) であり、状態アイコンの一部ではありません。セッションが複数のプルリクエストを開いた場合、ラベルは他をカウントする `+N` サフィックスを追加します。
+行の右端に表示される `PR #N` ラベルは [セッションが開いたプルリクエスト](#pull-request-status) であり、状態アイコンの一部ではありません。セッションが複数のプルリクエストを開いた場合、ラベルはカウントを表示します。例えば `3 PRs` のようになります。
 
 ターミナルタブのタイトルは、エージェントビューが開いている間、待機中の入力カウントを表示します。セッションが入力を必要とする場合は `2 awaiting input · claude agents`、そうでない場合は `claude agents` です。
@@ -140,9 +140,9 @@ Completed
 ### プルリクエストステータス
 
-セッションがプルリクエストを開くと、`⧉ PR #1234` ラベルが行の右端に表示され、ハイパーリンクをサポートするターミナルではプルリクエストにリンクされます。セッションにフォローアップを送信するときもラベルは保存されるため、行がライブプログレスに戻るときもプルリクエストは表示されたままです。
+セッションがプルリクエストを開くと、`PR #1234` ラベルが行の右端に表示され、ハイパーリンクをサポートするターミナルではプルリクエストにリンクされます。セッションにフォローアップを送信するときもラベルは保存されるため、行がライブプログレスに戻るときもプルリクエストは表示されたままです。
 
-セッションが複数のプルリクエストを開いた場合、ラベルは最も注意が必要なオープンプルリクエストを表示し、他をカウントする `+N` サフィックスを追加します。[ピークパネル](#peek-and-reply) を開いてすべてを表示します。
+セッションが複数のプルリクエストを開いた場合、ラベルはカウントを表示します。例えば `3 PRs` のようになり、最も注意が必要なオープンプルリクエストで色付けされます。[ピークパネル](#peek-and-reply) を開いてすべてを表示します。
 
-`⧉` アイコンはプルリクエストのステータスで色付けされます。
+プルリクエスト番号はそのステータスで色付けされます。
 
```

</details>

<details>
<summary>agents-ja.md</summary>

```diff
diff --git a/docs-ja/pages/agents-ja.md b/docs-ja/pages/agents-ja.md
index 9ae0ee1..f296684 100644
--- a/docs-ja/pages/agents-ja.md
+++ b/docs-ja/pages/agents-ja.md
@@ -5,19 +5,27 @@
 # エージェントを並列実行する
 
-> Claude Code が複数のタスクを同時に実行する方法を比較します。サブエージェント、エージェントビュー、エージェントチーム、および分離されたワークツリーセッションについて説明します。
+> Claude Code が複数のタスクを同時に実行する方法を比較します。サブエージェント、エージェントビュー、エージェントチーム、および動的ワークフローについて説明します。
 
-[サブエージェント](/ja/sub-agents)、[エージェントビュー](/ja/agent-view)、[エージェントチーム](/ja/agent-teams)、および [ワークツリー](/ja/worktrees) は、それぞれ異なる方法で作業を並列化します。どれを選ぶかは、各会話に自分で留まりたいのか、タスクを引き継いで後で確認したいのか、それとも Claude に一群のワーカーを調整させたいのかによって異なります。
+[サブエージェント](/ja/sub-agents)、[エージェントビュー](/ja/agent-view)、[エージェントチーム](/ja/agent-teams)、および [動的ワークフロー](/ja/workflows) は、それぞれ異なる方法で作業を並列化します。どれを選ぶかは、各会話に自分で留まりたいのか、タスクを引き継いで後で確認したいのか、それとも Claude に一群のワーカーを調整させたいのかによって異なります。
 
-| アプローチ                        | 提供内容                                                                    | 使用する場合                                            |
-| :--------------------------- | :---------------------------------------------------------------------- | :------------------------------------------------ |
-| [サブエージェント](/ja/sub-agents)   | 1 つのセッション内で委任されたワーカーが、独自のコンテキストでサイドタスクを実行し、サマリーを返す                      | サイドタスクが検索結果、ログ、またはファイルコンテンツで主な会話を埋め尽くす場合（再度参照しない） |
-| [エージェントビュー](/ja/agent-view)  | `claude agents` で開く、バックグラウンドで実行されているセッションをディスパッチして監視する 1 つの画面。リサーチプレビュー | 複数の独立したタスクがあり、それらを引き継いで、一目で状態を確認し、必要な場合のみ介入したい場合  |
-| [エージェントチーム](/ja/agent-teams) | 共有タスクリストとエージェント間メッセージングを備えた複数の調整されたセッション。リーダーによって管理される。実験的で、デフォルトでは無効   | Claude にプロジェクトを分割させ、割り当てさせ、ワーカーを同期させたい場合          |
-| [ワークツリー](/ja/worktrees)      | 個別の git チェックアウト。並列セッションが互いのファイルに触れることはない                                | 複数のセッションを自分で実行しているか、サブエージェントが重複するファイルを編集している場合    |
-| [`/batch`](/ja/commands)     | 1 つの大きな変更を 5 ～ 30 個のワークツリー分離サブエージェントに計画的に分割し、各エージェントがプルリクエストを開く         | リポジトリ全体のマイグレーションまたは機械的なリファクタリング。1 つの指示で説明できる場合    |
+| アプローチ                        | 提供内容                                                                    | 使用する場合                                                                       |
+| :--------------------------- | :---------------------------------------------------------------------- | :--------------------------------------------------------------------------- |
+| [サブエージェント](/ja/sub-agents)   | 1 つのセッション内で委任されたワーカーが、独自のコンテキストでサイドタスクを実行し、サマリーを返す                      | サイドタスクが検索結果、ログ、またはファイルコンテンツで主な会話を埋め尽くす場合（再度参照しない）                            |
+| [エージェントビュー](/ja/agent-view)  | `claude agents` で開く、バックグラウンドで実行されているセッションをディスパッチして監視する 1 つの画面。リサーチプレビュー | 複数の独立したタスクがあり、それらを引き継いで、一目で状態を確認し、必要な場合のみ介入したい場合                             |
+| [エージェントチーム](/ja/agent-teams) | 共有タスクリストとエージェント間メッセージングを備えた複数の調整されたセッション。リーダーによって管理される。実験的で、デフォルトでは無効   | Claude にプロジェクトを分割させ、割り当てさせ、ワーカーを同期させたい場合                                     |
+| [動的ワークフロー](/ja/workflows)    | 多くのサブエージェントを実行し、その結果をチェックするスクリプト。1 回のターンで調整するには大きすぎるジョブ向け。リサーチプレビュー     | タスクが大きすぎてサブエージェント数個では対応できない場合。コードベース全体の監査、500 ファイルのマイグレーション、または敵対的検証が必要な調査など |
 
 すべてのアプローチにおいて、ワーカーは Claude セッションです。別のツールを関与させるには、それを Claude に [MCP サーバー](/ja/mcp) として公開します。
 
-これらのアプローチを組み合わせることができます。エージェントビューは、ディスパッチされた各セッションをファイルを編集する必要がある場合に自動的に独自のワークツリーに移動し、作業中のセッションはサブエージェントを生成でき、各サブエージェントは独自のワークツリーを取得します。
```

</details>

<details>
<summary>best-practices-ja.md</summary>

```diff
diff --git a/docs-ja/pages/best-practices-ja.md b/docs-ja/pages/best-practices-ja.md
index 334c33a..c480d8b 100644
--- a/docs-ja/pages/best-practices-ja.md
+++ b/docs-ja/pages/best-practices-ja.md
@@ -28,10 +28,10 @@ LLM のパフォーマンスはコンテキストが満杯になるにつれて
 
 <Tip>
-  テスト、スクリーンショット、または期待される出力を含めて、Claude が自分自身をチェックできるようにします。これはあなたができる最も高いレバレッジのことです。
+  Claude が実行できるチェックを与えてください。テスト、ビルド、比較するスクリーンショットです。これは、あなたが見守るセッションと、あなたが立ち去ることができるセッションの違いです。
 </Tip>
 
-Claude は、テストを実行したり、スクリーンショットを比較したり、出力を検証したりするなど、自分の作業を検証できるときに劇的に良くなります。
+Claude は、作業が完了したように見えるときに停止します。実行できるチェックがないと、「完了したように見える」が唯一の利用可能なシグナルであり、あなたが検証ループになります。すべての間違いはあなたがそれに気付くのを待ちます。Claude が実行できるパスまたはフェイルを生成するものを与えると、ループは自動的に閉じます。Claude は作業を行い、チェックを実行し、結果を読み、チェックが合格するまで反復します。
 
-明確な成功基準がないと、正しく見えるが実際には機能しないものを生成する可能性があります。あなたが唯一のフィードバックループになり、すべての間違いがあなたの注意を必要とします。
+チェックは、会話で Claude が読むことができるシグナルを返すものです。テストスイート、ビルド終了コード、リンター、出力を固定値と比較するスクリプト、またはデザインと比較される[ブラウザスクリーンショット](/ja/chrome)です。
 
 | 戦略                  | 前                        | 後                                                                                                                                                      |
@@ -41,7 +41,12 @@ Claude は、テストを実行したり、スクリーンショットを比較
 | **症状ではなく根本原因に対処する** | *「ビルドが失敗している」*           | *「ビルドがこのエラーで失敗している：\[エラーを貼り付け]。修正して、ビルドが成功することを確認する。根本原因に対処し、エラーを抑制しない」*                                                                               |
 
-UI の変更は [Chrome 拡張機能の Claude](/ja/chrome) を使用して検証できます。これはブラウザで新しいタブを開き、UI をテストし、コードが機能するまで反復します。
+チェックが存在したら、停止をどの程度厳しくゲートするかを決定します。
 
-検証はテストスイート、リンター、または出力をチェックする Bash コマンドにすることもできます。検証を堅牢にすることに投資してください。
+* **1 つのプロンプトで**：Claude にチェックを実行し、同じメッセージ内で反復するよう求めます。上記の表のように。
+* **セッション全体で**：チェックを[`/goal` 条件](/ja/goal)として設定します。別の評価者がすべてのターンの後に再度チェックし、Claude はそれが保持されるまで作業を続けます。
+* **決定論的ゲートとして**：[Stop hook](/ja/hooks#stop) がスクリプトとしてチェックを実行し、合格するまでターンが終了するのをブロックします。Claude Code はフックをオーバーライドし、8 回連続でブロックされた後、ターンを終了します。
+* **第二の意見によって**：[検証サブエージェント](/ja/sub-agents)または[動的ワークフロー](/ja/workflows)が独自の調査結果をチェックし、新しいモデルが結果を反論しようとするため、作業を行っているエージェントがそれを採点しているわけではありません。
+
```

</details>

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index 761d992..92ea9fb 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,90 @@
 # Changelog
 
+## 2.1.154
+
+- Opus 4.8 is here! Now defaults to high effort · /effort xhigh for your hardest tasks
+- Introducing dynamic workflows: ask Claude to create a workflow and it orchestrates work across tens to hundreds of agents in the background, so you can take on larger, more complex tasks. Run `/workflows` to view your runs
+- Fast mode on Opus 4.8 is now available at a fraction of its previous cost: 2x the standard rate for 2.5x the speed
+- The lean system prompt is now the default for all models except Haiku, Sonnet, and Opus 4.7 and earlier
+- Claude now reserves the multiple-choice question prompt for decisions it genuinely cannot make itself, instead of asking when it already has enough context to proceed
+- `/simplify` now runs a cleanup-only review (reuse, simplification, efficiency, altitude) and applies the fixes, instead of running the full `/code-review --fix` bug-hunting review
+- Renamed the `/effort` slider labels from "Speed"/"Intelligence" to "Faster"/"Smarter" for clarity
+- `claude agents`: type `! <command>` to run a shell command as a background session you can attach to and detach from. Also available as `claude --bg --exec '<command>'`
+- `claude agents`: `/logout` now signs you out instead of being sent to a background session
+- `←←` to open the agents view now works on Bedrock, Vertex, Foundry, and with telemetry disabled
+- Claude in Chrome: pick which connected browser to use via `/chrome` → "Select browser…", or in-chat when a browser action runs with multiple connected
+- Plugins can now declare `defaultEnabled: false` in `plugin.json` or a marketplace entry; enable them with `/plugin` or `claude plugin enable`. Dependencies of enabled plugins are still enabled automatically
+- The `/plugin` Discover tab now pins plugins whose relevance signals match the current directory with a "suggested for this directory" annotation
+- Streaming tool execution is now always enabled, including when telemetry is disabled or on Bedrock/Vertex/Foundry (previously behind a feature flag)
+- Stdio MCP server subprocesses now receive `CLAUDE_CODE_SESSION_ID` and `CLAUDECODE=1` in their environment
+- `claude mcp list`/`get` now show unapproved `.mcp.json` servers as `⏸ Pending approval` instead of auto-approving and connecting when output is piped
+- `/remote-control` autocomplete now shows "Disconnect Remote Control" when Remote Control is already active
+- Added Claude Opus 4.8 support and 4.7 → 4.8 migration guidance to the `/claude-api` skill
+- Deprecated `CLAUDE_CODE_OPUS_4_6_FAST_MODE_OVERRIDE` (will be removed on 06/01). To use fast mode on Opus 4.6, switch with `/model claude-opus-4-6[1m]` and then `/fast on`
+- Improved the auto-mode classifier's detection of data exfiltration, particularly bulk transfers of repository contents
+- Fixed `rm -rf $HOME` not being blocked as a dangerous path when `HOME` has a trailing slash
```

</details>

<details>
<summary>claude-directory-ja.md</summary>

```diff
diff --git a/docs-ja/pages/claude-directory-ja.md b/docs-ja/pages/claude-directory-ja.md
index 2b3cba4..3347c46 100644
--- a/docs-ja/pages/claude-directory-ja.md
+++ b/docs-ja/pages/claude-directory-ja.md
@@ -5,5 +5,5 @@
 # .claude ディレクトリを探索する
 
-> Claude Code が CLAUDE.md、settings.json、hooks、skills、commands、subagents、rules、auto memory を読み込む場所。プロジェクト内の .claude ディレクトリとホームディレクトリの ~/.claude を探索します。
+> Claude Code が CLAUDE.md、settings.json、hooks、skills、commands、subagents、workflows、rules、auto memory を読み込む場所。プロジェクト内の .claude ディレクトリとホームディレクトリの ~/.claude を探索します。
 
 export const ClaudeExplorer = () => {
@@ -362,4 +362,15 @@ You are a senior code reviewer. Review for:
 Every finding must include a concrete fix.`
           }]
+        }, {
+          id: 'workflows',
+          label: 'workflows/',
+          type: 'folder',
+          icon: 'folder',
+          color: '#C46686',
+          oneLiner: 'Dynamic workflow scripts that orchestrate many subagents',
+          when: 'Loaded at startup; each file becomes a /<name> command',
+          description: <>Each <C>.js</C> file is a <A href="/en/workflows">dynamic workflow</A>: a script the runtime executes to spawn and coordinate many subagents. Workflows are written by Claude and saved here from <C>/workflows</C> rather than authored from scratch.</>,
+          tips: [<>Save a run from <C>/workflows</C> with <C>s</C> to create one of these</>, <>A project workflow takes precedence over a personal one in <C>~/.claude/workflows/</C> with the same name</>],
+          docsLink: '/en/workflows'
         }, {
           id: 'agent-memory',
@@ -665,4 +676,15 @@ themselves by leaving a TODO(human) marker instead of writing it.`
           docsLink: '/en/sub-agents',
           children: []
```

</details>

<details>
<summary>commands-ja.md</summary>

```diff
diff --git a/docs-ja/pages/commands-ja.md b/docs-ja/pages/commands-ja.md
index abb0c4e..5bf232d 100644
--- a/docs-ja/pages/commands-ja.md
+++ b/docs-ja/pages/commands-ja.md
@@ -31,5 +31,10 @@
 ## すべてのコマンド
 
-以下の表は Claude Code に含まれるすべてのコマンドをリストしています。**[スキル](/ja/skills#bundled-skills)** とマークされたエントリはバンドルされたスキルです。これらは自分で作成するスキルと同じメカニズムを使用します。Claude に渡されるプロンプトであり、Claude は関連する場合に自動的に呼び出すこともできます。その他はすべて、CLI にコード化された動作を持つ組み込みコマンドです。独自のコマンドを追加するには、[スキル](/ja/skills)を参照してください。
+以下の表は Claude Code に含まれるすべてのコマンドをリストしています。ほとんどは CLI にコード化された動作を持つ組み込みコマンドです。2 つの種類のエントリがマークされています。
+
+* **[スキル](/ja/skills#bundled-skills)**: バンドルされたスキル。自分で作成するスキルと同じように機能します。Claude に渡されるプロンプトであり、Claude は関連する場合に自動的に呼び出すこともできます。
+* **[ワークフロー](/ja/workflows#bundled-workflows)**: バンドルされた[動的ワークフロー](/ja/workflows)。多くのサブエージェント間で作業をファンアウトし、バックグラウンドで実行されます。
+
+独自のコマンドを追加するには、[スキル](/ja/skills)を参照してください。
 
 以下の表では、`<arg>` は必須引数を示し、`[arg]` はオプション引数を示します。
@@ -44,5 +49,6 @@
 | `/agents`                                                                          | [エージェント](/ja/sub-agents)設定を管理します                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
 | `/autofix-pr [prompt]`                                                             | 現在のブランチの PR を監視し、CI が失敗するか、レビュアーがコメントを残したときに修正をプッシュする [Claude Code on the web](/ja/claude-code-on-the-web#auto-fix-pull-requests) セッションを生成します。`gh pr view` で開いている PR を検出します。別の PR を監視するには、最初にそのブランチをチェックアウトしてください。デフォルトでは、リモートセッションはすべての CI 失敗とレビューコメントを修正するよう指示されます。プロンプトを渡して異なる指示を与えることができます。例えば `/autofix-pr only fix lint and type errors`。`gh` CLI と [Claude Code on the web](/ja/claude-code-on-the-web#who-can-use-claude-code-on-the-web) へのアクセスが必要です                                                  |
-| `/batch <instruction>`                                                             | **[スキル](/ja/skills#bundled-skills)。** コードベース全体にわたる大規模な変更を並列で調整します。コードベースを調査し、作業を 5 ～ 30 個の独立したユニットに分解し、計画を提示します。承認されると、分離された [git worktree](/ja/worktrees) 内の各ユニットごとに 1 つのバックグラウンドサブエージェントを生成します。各サブエージェントはそのユニットを実装し、テストを実行し、プルリクエストを開きます。git リポジトリが必要です。例: `/batch migrate src/ from Solid to React`                                                                                                                                                                                                         |
+| `/background [prompt]`                                                             | 現在のセッションをデタッチして[バックグラウンドエージェント](/ja/agent-view)として実行し、このターミナルを解放します。デタッチする前に 1 つ以上の指示を送信するためにプロンプトを渡します。`claude agents` でセッションを監視します。エイリアス: `/bg`                                                                                                                                                                                                                                                                                                                                                              |
+| `/batch <instruction>`                                                             | **[スキル](/ja/skills#bundled-skills)。** コードベース全体にわたる大規模な変更を並列で調整します。コードベースを調査し、作業を 5 ～ 30 個の独立したユニットに分解し、計画を提示します。承認されると、分離された [git worktree](/ja/worktrees) 内の各ユニットごとに 1 つの[バックグラウンドサブエージェント](/ja/sub-agents#run-subagents-in-foreground-or-background)を生成します。各サブエージェントはそのユニットを実装し、テストを実行し、プルリクエストを開きます。git リポジトリが必要です。例: `/batch migrate src/ from Solid to React`                                                                                                                                             |
 | `/branch [name]`                                                                   | この時点で現在の会話のブランチを作成します。ブランチに切り替え、元の会話を保持します。`/resume` で戻ることができます。エイリアス: `/fork`。[`CLAUDE_CODE_FORK_SUBAGENT`](/ja/env-vars) が設定されている場合、`/fork` は代わりに[フォークされたサブエージェント](/ja/sub-agents#fork-the-current-conversation)を生成し、このコマンドのエイリアスではなくなります                                                                                                                                                                                                                                                                    |
 | `/btw <question>`                                                                  | 会話に追加せずに[サイドクエスチョン](/ja/interactive-mode#side-questions-with-%2Fbtw)として素早く質問します                                                                                                                                                                                                                                                                                                                                                                                                                                |
@@ -58,8 +64,9 @@
 | `/cost`                                                                            | `/usage` のエイリアス                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
 | `/debug [description]`                                                             | **[スキル](/ja/skills#bundled-skills)。** 現在のセッションのデバッグログを有効にし、セッションデバッグログを読むことで問題をトラブルシューティングします。デバッグログはデフォルトではオフです。`claude --debug` で開始した場合を除き、セッション中に `/debug` を実行するとその時点からログのキャプチャを開始します。オプションで問題を説明して分析にフォーカスを当てます                                                                                                                                                                                                                                                                                            |
+| `/deep-research <question>`                                                        | **[ワークフロー](/ja/workflows#bundled-workflows)。** 質問に関するウェブ検索をファンアウトし、ソースをフェッチして相互検証し、引用されたレポートを合成します                                                                                                                                                                                                                                                                                                                                                                                                             |
 | `/desktop`                                                                         | 現在のセッションを Claude Code デスクトップアプリで続行します。macOS と Windows が必要で、Claude サブスクリプションが必要です。エイリアス: `/app`                                                                                                                                                                                                                                                                                                                                                                                                                 |
 | `/diff`                                                                            | コミットされていない変更と各ターンの diff を表示するインタラクティブ diff ビューアを開きます。左右矢印を使用して現在の git diff と個別の Claude ターンを切り替え、上下矢印でファイルをブラウズします                                                                                                                                                                                                                                                                                                                                                                                              |
```

</details>

*...以降省略*

</details>


<details>
<summary>2026-05-28</summary>

**変更ファイル:**

```
 docs-ja/pages/agent-view-ja.md          |  24 ++--
 docs-ja/pages/changelog.md              |  36 ++++++
 docs-ja/pages/code-review-ja.md         |  13 ++-
 docs-ja/pages/commands-ja.md            | 187 ++++++++++++++++----------------
 docs-ja/pages/env-vars-ja.md            |   2 +
 docs-ja/pages/errors-ja.md              |   6 +-
 docs-ja/pages/headless-ja.md            |   2 +-
 docs-ja/pages/hooks-guide-ja.md         |  37 ++++---
 docs-ja/pages/hooks-ja.md               | 135 ++++++++++++++++-------
 docs-ja/pages/interactive-mode-ja.md    |  12 +-
 docs-ja/pages/keybindings-ja.md         |   1 +
 docs-ja/pages/monitoring-usage-ja.md    |  32 ++++--
 docs-ja/pages/plugin-marketplaces-ja.md |  10 +-
 docs-ja/pages/plugins-reference-ja.md   |   1 +
 docs-ja/pages/settings-ja.md            |   1 +
 docs-ja/pages/skills-ja.md              |   1 +
 docs-ja/pages/ultrareview-ja.md         |  24 ++--
 17 files changed, 333 insertions(+), 191 deletions(-)
```

<details>
<summary>agent-view-ja.md</summary>

```diff
diff --git a/docs-ja/pages/agent-view-ja.md b/docs-ja/pages/agent-view-ja.md
index 7666309..22f28cc 100644
--- a/docs-ja/pages/agent-view-ja.md
+++ b/docs-ja/pages/agent-view-ja.md
@@ -88,5 +88,5 @@ Pinned
 
 Ready for review
-  ∙ jump physics              github.com/example/game/pull/2048          ●  2h
+  ∙ jump physics              Opened PR with collision fix            ⧉ PR #2048  2h
 
 Needs input
@@ -124,5 +124,5 @@ Completed
 | `✢`                | [`/loop`](/ja/scheduled-tasks) セッションはイテレーション間でスリープしています。行は実行回数とカウントダウンを表示します |
 
-行の右端に表示される `●` は [プルリクエストステータス](#pull-request-status) インジケーターであり、状態アイコンの一部ではありません。その前の数字はセッションが開いたプルリクエストの数です。
+行の右端に表示される `⧉ PR #N` ラベルは [セッションが開いたプルリクエスト](#pull-request-status) であり、状態アイコンの一部ではありません。セッションが複数のプルリクエストを開いた場合、ラベルは他をカウントする `+N` サフィックスを追加します。
 
 ターミナルタブのタイトルは、エージェントビューが開いている間、待機中の入力カウントを表示します。セッションが入力を必要とする場合は `2 awaiting input · claude agents`、そうでない場合は `claude agents` です。
@@ -140,14 +140,18 @@ Completed
 ### プルリクエストステータス
 
-セッションがプルリクエストを開くと、ステータスドットが行の右端に表示され、ハイパーリンクをサポートするターミナルではプルリクエストにリンクされます。セッションが複数のプルリクエストを開いた場合、カウントはドットの前に表示され、色はどれが最も注意が必要かを反映します。
+セッションがプルリクエストを開くと、`⧉ PR #1234` ラベルが行の右端に表示され、ハイパーリンクをサポートするターミナルではプルリクエストにリンクされます。セッションにフォローアップを送信するときもラベルは保存されるため、行がライブプログレスに戻るときもプルリクエストは表示されたままです。
 
-| ドットの色 | プルリクエストステータス               |
-| :---- | :------------------------- |
-| 黄色    | チェックまたはレビューを待機中、またはチェックが失敗 |
-| 緑     | チェックが成功し、レビューがブロックされていない   |
-| 紫     | マージ済み                      |
-| グレー   | ドラフトまたはクローズ                |
```

</details>

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index 20cadc6..761d992 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,40 @@
 # Changelog
 
+## 2.1.152
+
+- `/code-review --fix` now applies review findings to your working tree after the review, surfacing reuse, simplification, and efficiency suggestions; `/simplify` now invokes `/code-review --fix`
+- Skills and slash commands can now set `disallowed-tools` in frontmatter to remove tools from the model while the skill is active
+- Added `/reload-skills` command to re-scan skill directories without restarting the session
+- `SessionStart` hooks can now return `reloadSkills: true` to re-scan skill directories, making skills installed by the hook available in the same session
+- `SessionStart` hooks can now set the session title via `hookSpecificOutput.sessionTitle` on startup and resume
+- Added a `MessageDisplay` hook event that lets hooks transform or hide assistant message text as it is displayed
+- Added `pluginSuggestionMarketplaces` managed setting: admins can allowlist org marketplaces whose plugins may be suggested via context-aware tips
+- `claude plugin marketplace remove` now accepts `--scope user|project|local` for symmetry with `marketplace add`, `install`, and `uninstall`
+- Claude Code now switches to your configured `--fallback-model` for the rest of the session when the primary model is not found, instead of failing every request
+- Auto mode no longer requires opt-in consent
+- Vim mode: `/` in NORMAL mode now opens reverse history search (like Ctrl+R), matching bash/zsh vi-mode
+- The `/usage` breakdown now includes large session files; files are scanned with a streaming read so memory usage stays flat
+- Thinking summaries in the collapsed group now stay readable for at least 3 seconds, render as markdown, and cap at 10 lines (`Ctrl+O` shows the full thinking)
+- In fullscreen mode, the "Thinking for Ns" indicator now counts up live while the model is thinking, and keeps its value if you interrupt mid-thought
+- Simplified the Workflow tool's inline progress display — live agent counts now show only in the persistent workflow status row below the prompt
+- The post-response timer now shows "Waiting for N background agents/workflows to finish" when backgrounded agents or workflows are still running, and reports the cumulative time once their results are processed
+- Added the session entrypoint as an OpenTelemetry metric attribute (`app.entrypoint`, opt-in via `OTEL_METRICS_INCLUDE_ENTRYPOINT=true`)
+- Fixed terminal styling degrading in very long sessions by recycling the renderer's style pool
+- Fixed the sandbox-enabled warning not appearing in condensed startup mode — it now shows in every layout
+- Fixed the loading spinner showing "still thinking"/"almost done thinking" while a tool is running, and reset the thinking status to "thinking" after each tool
+- Fixed focus mode showing a spurious "N messages hidden" count on turns with no hidden activity
```

</details>

<details>
<summary>code-review-ja.md</summary>

```diff
diff --git a/docs-ja/pages/code-review-ja.md b/docs-ja/pages/code-review-ja.md
index 2750b92..4cced00 100644
--- a/docs-ja/pages/code-review-ja.md
+++ b/docs-ja/pages/code-review-ja.md
@@ -25,7 +25,8 @@ Claude を管理サービスではなく独自の CI インフラストラクチ
 * [料金](#pricing)
 * [トラブルシューティング](#troubleshooting)失敗した実行と欠落したコメント
+* [ローカルで差分をレビューする](#review-a-diff-locally) `/code-review` コマンドを使用
 
 <Note>
-  GitHub アプリをインストールせずにターミナルでローカルに差分をレビューするには、任意の Claude Code セッションで [`/code-review` コマンド](/ja/commands)を実行してください。選択した努力レベルで現在の差分の正確性バグを報告し、`--comment` で結果をインライン PR コメントとして投稿できます。このコマンドは v2.1.147 より前は `/simplify` という名前でした。
+  GitHub アプリをインストールせずにターミナルでローカルに差分をレビューするには、任意の Claude Code セッションで `/code-review` コマンドを実行してください。[ローカルで差分をレビューする](#review-a-diff-locally)を参照してください。
 </Note>
 
@@ -268,4 +269,14 @@ GitHub の Checks タブの **Re-run** ボタンは Code Review を再トリガ
 * **レビュー本文**: レビューが実行されている間に PR にプッシュした場合、一部の結果は現在の diff に存在しなくなった行を参照する場合があります。これらは、インラインコメントではなく、レビュー本文テキストの **Additional findings** 見出しの下に表示されます。
 
+## ローカルで差分をレビューする
+
+[`/code-review` コマンド](/ja/commands)はターミナルで差分をレビューし、GitHub App をインストールせずに実行します。任意の Claude Code セッションで実行します：現在の差分の正確性バグを報告し、{/* min-version: 2.1.151 */}再利用、簡素化、効率化のクリーンアップを報告します。`--comment` を渡してインライン PR コメントとして結果を投稿するか、`--fix` を渡してレビュー後に結果をワーキングツリーに適用します。
+
+低い[努力レベル](/ja/model-config#adjust-effort-level)は、より少なく、より高い信頼度の結果を返し、`high` から `max` はより広いカバレッジを提供し、不確実な結果を含む場合があります。努力引数がない場合、レビューはセッションの現在の努力を使用します。現在の差分の代わりに特定のターゲットをレビューするためにパスまたは PR 参照を渡します。
+
+`/code-review ultra --fix` はクラウドでより深い[ultrareview](/ja/ultrareview)を実行し、セッションに戻ってきたときに結果をワーキングツリーに適用します。
+
+このコマンドは v2.1.147 より前は `/simplify` という名前で、デフォルトで修正を適用していました。`/simplify` は依然として機能し、`/code-review --fix` と同等です。
+
 ## 関連リソース
 
```

</details>

<details>
<summary>commands-ja.md</summary>

```diff
diff --git a/docs-ja/pages/commands-ja.md b/docs-ja/pages/commands-ja.md
index e0f52f1..abb0c4e 100644
--- a/docs-ja/pages/commands-ja.md
+++ b/docs-ja/pages/commands-ja.md
@@ -23,5 +23,5 @@
 **並行して作業を実行する。** `/agents` は Claude が副次的なタスクを委譲できる[サブエージェント](/ja/sub-agents)のマネージャーを開き、`/tasks` は現在のセッションのバックグラウンドで実行されているものをリストします。`/background` はセッション全体をデタッチして[バックグラウンドエージェント](/ja/agent-view)として実行し続け、ターミナルを解放します。コードベース全体にまたがる大きな変更の場合、`/batch` はそれを独立したユニットに分解し、各ユニットを独自の[worktree](/ja/worktrees)で実行します。これらのアプローチがどのように関連しているかについては、[エージェントを並行して実行する](/ja/agents)を参照してください。
 
-**リリース前。** `/diff` は変更内容を表示し、`/code-review` は diff の正確性のバグをチェックし、`/review` または `/security-review` はより深い読み取り専用パスを提供します。
+**リリース前。** `/diff` は変更内容を表示し、`/code-review` は diff の正確性のバグをチェックし、`--fix` で検出結果を適用できます。`/review` または `/security-review` はより深い読み取り専用パスを提供します。`/code-review ultra` はクラウドでマルチエージェントレビューを実行します。
 
 **セッション間。** `/clear` は新しいタスクで新しく開始しながらプロジェクトメモリを保持します。`/resume` と `/branch` を使用して、以前の会話に戻るか、フォークできます。`/teleport` はウェブセッションをこのターミナルに引き込み、`/remote-control` を使用してこのローカルセッションを別のデバイスから続行できます。
@@ -39,96 +39,97 @@
 </Note>
 
-| コマンド                                                                | 目的                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
-| :------------------------------------------------------------------ | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
-| `/add-dir <path>`                                                   | 現在のセッション中にファイルアクセス用の作業ディレクトリを追加します。ほとんどの `.claude/` 設定は追加されたディレクトリから[検出されません](/ja/permissions#additional-directories-grant-file-access-not-configuration)。後で `--continue` または `--resume` を使用して、追加されたディレクトリからセッションを再開できます                                                                                                                                                                                                                                                                                       |
-| `/agents`                                                           | [エージェント](/ja/sub-agents)設定を管理します                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
-| `/autofix-pr [prompt]`                                              | 現在のブランチの PR を監視し、CI が失敗するか、レビュアーがコメントを残したときに修正をプッシュする [Claude Code on the web](/ja/claude-code-on-the-web#auto-fix-pull-requests) セッションを生成します。`gh pr view` で開いている PR を検出します。別の PR を監視するには、最初にそのブランチをチェックアウトしてください。デフォルトでは、リモートセッションはすべての CI 失敗とレビューコメントを修正するよう指示されます。プロンプトを渡して異なる指示を与えることができます。例えば `/autofix-pr only fix lint and type errors`。`gh` CLI と [Claude Code on the web](/ja/claude-code-on-the-web#who-can-use-claude-code-on-the-web) へのアクセスが必要です                                                  |
-| `/batch <instruction>`                                              | **[スキル](/ja/skills#bundled-skills)。** コードベース全体にわたる大規模な変更を並列で調整します。コードベースを調査し、作業を 5 ～ 30 個の独立したユニットに分解し、計画を提示します。承認されると、分離された [git worktree](/ja/worktrees) 内の各ユニットごとに 1 つのバックグラウンドサブエージェントを生成します。各サブエージェントはそのユニットを実装し、テストを実行し、プルリクエストを開きます。git リポジトリが必要です。例: `/batch migrate src/ from Solid to React`                                                                                                                                                                                                         |
-| `/branch [name]`                                                    | この時点で現在の会話のブランチを作成します。ブランチに切り替え、元の会話を保持します。`/resume` で戻ることができます。エイリアス: `/fork`。[`CLAUDE_CODE_FORK_SUBAGENT`](/ja/env-vars) が設定されている場合、`/fork` は代わりに[フォークされたサブエージェント](/ja/sub-agents#fork-the-current-conversation)を生成し、このコマンドのエイリアスではなくなります                                                                                                                                                                                                                                                                    |
-| `/btw <question>`                                                   | 会話に追加せずに[サイドクエスチョン](/ja/interactive-mode#side-questions-with-%2Fbtw)として素早く質問します                                                                                                                                                                                                                                                                                                                                                                                                                                |
-| `/chrome`                                                           | [Chrome の Claude](/ja/chrome) 設定を構成します                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
-| `/claude-api [migrate\|managed-agents-onboard]`                     | **[スキル](/ja/skills#bundled-skills)。** プロジェクトの言語（Python、TypeScript、Java、Go、Ruby、C#、PHP、または cURL）と Managed Agents リファレンス用の Claude API リファレンス資料を読み込みます。ツール使用、ストリーミング、バッチ、構造化出力、および一般的な落とし穴をカバーしています。また、コードが `anthropic` または `@anthropic-ai/sdk` をインポートするときに自動的にアクティブになります。`/claude-api migrate` を実行して、既存の Claude API コードを新しいモデルにアップグレードします。Claude はスキャンするファイルとターゲットモデルを尋ね、モデル ID、思考設定、およびバージョン間で変更されたその他のパラメータを更新します。`/claude-api managed-agents-onboard` を実行して、新しい Managed Agent をゼロから作成するインタラクティブなウォークスルーを実施します |
-| `/clear [name]`                                                     | 空のコンテキストで新しい会話を開始します。前の会話は `/resume` で利用可能なままです。前の会話にラベルを付けるために名前を渡します。`/resume` ピッカーで。同じ会話を続けながらコンテキストを解放するには、代わりに `/compact` を使用してください。エイリアス: `/reset`、`/new`                                                                                                                                                                                                                                                                                                                                                |
-| `/code-review [low\|medium\|high\|xhigh\|max] [--comment] [target]` | **[スキル](/ja/skills#bundled-skills)。** 現在の diff を正確性バグについてレビューし、ファイルを編集せずに結果を報告します。低い[努力レベル](/ja/model-config#adjust-effort-level)はより少なく、より高い信頼度の結果を返し、`high` から `max` はより広いカバレッジを提供し、不確実な結果を含む場合があります。努力引数がない場合、レビューはセッションの現在の努力を使用します。`--comment` を渡して、現在の GitHub PR にインラインコメントとして結果を投稿します。特定のターゲットをレビューするためにパスまたは PR リファレンスを渡します。以前は `/simplify` でしたが、これはエイリアスとしても機能します                                                                                                                                      |
-| `/color [color\|default]`                                           | 現在のセッションのプロンプトバーの色を設定します。利用可能な色: `red`、`blue`、`green`、`yellow`、`purple`、`orange`、`pink`、`cyan`。`default` を使用してリセットするか、引数なしで実行するとランダムな色を選択します。[リモートコントロール](/ja/remote-control)が接続されている場合、色は claude.ai/code に同期されます                                                                                                                                                                                                                                                                                              |
-| `/compact [instructions]`                                           | 会話をここまで要約してコンテキストを解放します。オプションで要約のフォーカス指示を渡します。[コンパクション時にルール、スキル、メモリファイルがどのように処理されるか](/ja/context-window#what-survives-compaction)を参照してください                                                                                                                                                                                                                                                                                                                                                                     |
-| `/config`                                                           | [設定](/ja/settings)インターフェースを開いて、テーマ、モデル、[出力スタイル](/ja/output-styles)、およびその他の設定を調整します。エイリアス: `/settings`                                                                                                                                                                                                                                                                                                                                                                                                          |
-| `/context [all]`                                                    | 現在のコンテキスト使用状況をカラーグリッドとして視覚化します。コンテキストが多いツール、メモリ肥大化、容量警告の最適化提案を表示します。[フルスクリーンモード](/ja/fullscreen)では、項目ごとの内訳はグリッドを表示したままにするために折りたたまれます。`all` を渡して展開します                                                                                                                                                                                                                                                                                                                                                           |
```

</details>

<details>
<summary>env-vars-ja.md</summary>

```diff
diff --git a/docs-ja/pages/env-vars-ja.md b/docs-ja/pages/env-vars-ja.md
index c8ddfea..4af7768 100644
--- a/docs-ja/pages/env-vars-ja.md
+++ b/docs-ja/pages/env-vars-ja.md
@@ -221,4 +221,5 @@ Claude Code は起動時に環境変数を読み取るため、変更は `claude
 | `CLAUDE_CODE_PLUGIN_SEED_DIR`                           | 1 つ以上の読み取り専用プラグインシードディレクトリへのパス。Unix では `:` で、Windows では `;` で区切られます。事前入力されたプラグインディレクトリをコンテナイメージにバンドルするために使用します。Claude Code はこれらのディレクトリからマーケットプレイスを登録し、再クローンなしで事前キャッシュされたプラグインを使用します。[コンテナ用のプラグインを事前入力](/ja/plugin-marketplaces#pre-populate-plugins-for-containers) を参照してください                                                                                                                                                  |
 | `CLAUDE_CODE_POWERSHELL_RESPECT_EXECUTION_POLICY`       | Claude Code が PowerShell をスポーンするときに `-ExecutionPolicy Bypass` を渡すことを停止するには `1` に設定します。ツール呼び出し、フック、ステータスラインコマンドの場合、マシンの有効な実行ポリシーを尊重します。デフォルトでは Claude Code はプロセススコープでバイパスを実行するため、`.ps1` スクリプトとモジュールインポートはデフォルト制限 Windows インストールで機能します。プロセススコープバイパスは、この設定に関係なく、グループポリシー `MachinePolicy` または `UserPolicy` をオーバーライドしません                                                                                                            |
+| `CLAUDE_CODE_PROPAGATE_TRACEPARENT`                     | {/* min-version: 2.1.152 */}カスタムプロキシを指す場合、W3C トレースコンテキストを伝播するには `1` に設定します。`ANTHROPIC_BASE_URL` が指しています。伝播は、モデルと HTTP MCP リクエストの `traceparent` ヘッダーと、Bash、PowerShell、フックサブプロセスの `TRACEPARENT` 環境変数をカバーします。デフォルトでは、伝播は Anthropic API に直接接続されている場合にのみ有効になります。[トレース（ベータ）](/ja/monitoring-usage#traces-beta) を参照してください                                                                                                             |
 | `CLAUDE_CODE_PROVIDER_MANAGED_BY_HOST`                  | Claude Code を埋め込み、その代わりにモデルプロバイダーのルーティングを管理するホストプラットフォームによって設定されます。設定されている場合、`CLAUDE_CODE_USE_BEDROCK`、`ANTHROPIC_BASE_URL`、`ANTHROPIC_API_KEY` などのプロバイダー選択、エンドポイント、認証変数は設定ファイルで無視されるため、ユーザー設定はホストのルーティングをオーバーライドできません。Bedrock、Vertex、Foundry の自動テレメトリオプトアウトもスキップされるため、テレメトリは標準の `DISABLE_TELEMETRY` オプトアウトに従います。[API プロバイダーごとのデフォルト動作](/ja/data-usage#default-behaviors-by-api-provider) を参照してください                            |
 | `CLAUDE_CODE_PROXY_RESOLVES_HOSTS`                      | プロキシが呼び出し元の代わりに DNS 解決を実行できるようにするには `1` に設定します。プロキシがホスト名解決を処理する必要がある環境でオプトインします                                                                                                                                                                                                                                                                                                                                                |
@@ -316,4 +317,5 @@ Claude Code は起動時に環境変数を読み取るため、変更は `claude
 | `OTEL_LOG_USER_PROMPTS`                                 | ユーザープロンプトテキストを OpenTelemetry トレースとログに含めるには `1` に設定します。デフォルトで無効です（プロンプトは編集されます）。[監視](/ja/monitoring-usage) を参照してください                                                                                                                                                                                                                                                                                                            |
 | `OTEL_METRICS_INCLUDE_ACCOUNT_UUID`                     | メトリクス属性からアカウント UUID を除外するには `false` に設定します（デフォルト：含まれます）。[監視](/ja/monitoring-usage) を参照してください                                                                                                                                                                                                                                                                                                                                   |
+| `OTEL_METRICS_INCLUDE_ENTRYPOINT`                       | {/* min-version: 2.1.152 */}セッションエントリポイントをメトリクス属性に含めるには `true` に設定します（デフォルト：除外）。[監視](/ja/monitoring-usage) を参照してください                                                                                                                                                                                                                                                                                                           |
 | `OTEL_METRICS_INCLUDE_SESSION_ID`                       | メトリクス属性からセッション ID を除外するには `false` に設定します（デフォルト：含まれます）。[監視](/ja/monitoring-usage) を参照してください                                                                                                                                                                                                                                                                                                                                     |
 | `OTEL_METRICS_INCLUDE_VERSION`                          | Claude Code バージョンをメトリクス属性に含めるには `true` に設定します（デフォルト：除外）。[監視](/ja/monitoring-usage) を参照してください                                                                                                                                                                                                                                                                                                                                   |
```

</details>

<details>
<summary>errors-ja.md</summary>

```diff
diff --git a/docs-ja/pages/errors-ja.md b/docs-ja/pages/errors-ja.md
index 843f4b0..96510d9 100644
--- a/docs-ja/pages/errors-ja.md
+++ b/docs-ja/pages/errors-ja.md
@@ -76,5 +76,5 @@ Claude Code は、5xx レスポンスに対してステータスコードと API
 
 ```text theme={null}
-API Error: 500 Internal server error. This is a server-side issue, usually temporary — try again in a moment. If it persists, check status.claude.com.
+API Error: 500 Internal server error. This is a server-side issue, usually temporary — try again in a moment. If it persists, check https://status.claude.com.
 ```
 
@@ -94,5 +94,5 @@ API は、すべてのユーザー全体で一時的に容量に達していま
 
 ```text theme={null}
-API Error: Repeated 529 Overloaded errors. The API is at capacity — this is usually temporary. Try again in a moment. If it persists, check status.claude.com.
+API Error: Repeated 529 Overloaded errors. The API is at capacity — this is usually temporary. Try again in a moment. If it persists, check https://status.claude.com.
 ```
 
@@ -209,5 +209,5 @@ API キー、Amazon Bedrock プロジェクト、または Google Vertex AI プ
 
 ```text theme={null}
-API Error: Request rejected (429) · this may be a temporary capacity issue. If it persists, check status.claude.com.
+API Error: Request rejected (429) · this may be a temporary capacity issue. If it persists, check https://status.claude.com.
 ```
 
```

</details>

*...以降省略*

</details>


<details>
<summary>2026-05-27</summary>

**変更ファイル:**

```
 docs-ja/pages/agent-view-ja.md               |   4 +-
 docs-ja/pages/amazon-bedrock-ja.md           |   2 +-
 docs-ja/pages/best-practices-ja.md           |  30 ++++-
 docs-ja/pages/cli-reference-ja.md            | 132 +++++++++----------
 docs-ja/pages/discover-plugins-ja.md         |   6 +-
 docs-ja/pages/github-enterprise-server-en.md | 188 ---------------------------
 docs-ja/pages/google-vertex-ai-ja.md         |   2 +-
 docs-ja/pages/hooks-guide-ja.md              |   2 +
 docs-ja/pages/mcp-ja.md                      |   4 +-
 docs-ja/pages/memory-ja.md                   |   6 +-
 docs-ja/pages/microsoft-foundry-ja.md        |   2 +-
 docs-ja/pages/permissions-ja.md              |   2 +
 docs-ja/pages/plugins-reference-ja.md        |   6 +-
 docs-ja/pages/security-ja.md                 |   1 +
 docs-ja/pages/skills-ja.md                   |   2 +-
 15 files changed, 119 insertions(+), 270 deletions(-)
```

**新規追加:**


**削除:**


<details>
<summary>agent-view-ja.md</summary>

```diff
diff --git a/docs-ja/pages/agent-view-ja.md b/docs-ja/pages/agent-view-ja.md
index db305cf..7666309 100644
--- a/docs-ja/pages/agent-view-ja.md
+++ b/docs-ja/pages/agent-view-ja.md
@@ -167,5 +167,7 @@ Completed
 空のプロンプトで `←` を押してデタッチし、エージェントビューに戻ります。ダイアログがフォーカスを持っており、`←` に応答していない場合は、`Ctrl+Z` を押して直ちにデタッチします。
 
-デタッチはバックグラウンドセッションを停止しません。`←`、`Ctrl+C`、`Ctrl+D`、`Ctrl+Z`、および `/exit` はすべてセッションを実行し続けます。セッション内からセッションを終了するには、`/stop` を実行します。
+`Ctrl+C` はアタッチ中に標準的な割り込み動作を保持します。実行中の応答または `!` シェルコマンドをキャンセルするのであり、デタッチするのではありません。空のプロンプトで `Ctrl+C` を 2 回押すとデタッチします。これは他のセッションと同じです。
+
+デタッチはバックグラウンドセッションを停止しません。`←`、`Ctrl+Z`、`/exit`、および二重 `Ctrl+C` または二重 `Ctrl+D` はすべてセッションを実行し続けます。セッション内からセッションを終了するには、`/stop` を実行します。
 
 ディスパッチまたはバックグラウンドにしたセッションの後、空のプロンプトで `←` を押すと、アタッチしたセッションだけでなく、任意の Claude Code セッションから機能します。現在のセッションをバックグラウンドにし、そのセッションが事前に選択された状態でエージェントビューを開くため、ターミナルを離れずにセッションを切り替えることができます。行は会話履歴がない新しいセッションからでも作成されるため、`→` はそれに戻ります。その行が唯一の行である場合、エージェントビューはその下にオンボーディングヒントを表示します。このショートカットは `/config` でオフにできます（`leftArrowOpensAgents` 設定）。
```

</details>

<details>
<summary>amazon-bedrock-ja.md</summary>

```diff
diff --git a/docs-ja/pages/amazon-bedrock-ja.md b/docs-ja/pages/amazon-bedrock-ja.md
index fa88d72..2f5b379 100644
--- a/docs-ja/pages/amazon-bedrock-ja.md
+++ b/docs-ja/pages/amazon-bedrock-ja.md
@@ -224,5 +224,5 @@ Claude Code で Bedrock を有効にする場合は、以下に注意してく
 
 * `AWS_REGION` は必須の環境変数です。Claude Code はこの設定について `.aws` 設定ファイルから読み込みません。
-* Bedrock を使用する場合、`/login` および `/logout` コマンドは無効になります。認証は AWS 認証情報を通じて処理されるためです。
+* Bedrock を使用する場合、`/logout` コマンドは無効になります。認証は AWS 認証情報を通じて処理されるためです。
 * 他のプロセスに漏らしたくない `AWS_PROFILE` などの環境変数に設定ファイルを使用できます。詳細については [Settings](/ja/settings) を参照してください。
 
```

</details>

<details>
<summary>best-practices-ja.md</summary>

```diff
diff --git a/docs-ja/pages/best-practices-ja.md b/docs-ja/pages/best-practices-ja.md
index 181f528..334c33a 100644
--- a/docs-ja/pages/best-practices-ja.md
+++ b/docs-ja/pages/best-practices-ja.md
@@ -45,4 +45,6 @@ UI の変更は [Chrome 拡張機能の Claude](/ja/chrome) を使用して検
 検証はテストスイート、リンター、または出力をチェックする Bash コマンドにすることもできます。検証を堅牢にすることに投資してください。
 
+Claude に成功を主張するのではなく、証拠を示すよう指示してください。テスト出力、実行したコマンドとその戻り値、または結果のスクリーンショットです。証拠を確認することは、検証を自分で再実行するよりも高速であり、監視していなかったセッションでも機能します。
+
 ***
 
@@ -361,4 +363,6 @@ Keep interviewing until we've covered everything, then write a complete spec to
 仕様が完成したら、新しいセッションを開始して実行します。新しいセッションはクリーンなコンテキストを持ち、実装に完全に焦点を当てており、参照する書かれた仕様があります。
 
+最も有用な仕様は自己完結型です。関連するファイルとインターフェースに名前を付け、スコープ外のものを述べ、機能が機能することを証明するエンドツーエンド検証ステップで終わります。仕様を正確にするのに費やした時間は、実装を見守るのに費やした時間よりも多くの見返りがあります。
+
 ***
 
@@ -453,5 +457,5 @@ Claude Code は会話をローカルに保存するため、タスクが複数
 
 <Tip>
-  CI、プリコミットフック、またはスクリプトで `claude -p "prompt"` を使用します。ストリーミング JSON 出力の場合は `--output-format stream-json` を追加します。
+  CI、プリコミットフック、またはスクリプトで `claude -p "prompt"` を使用します。ストリーミング JSON 出力の場合は `--output-format stream-json --verbose` を追加します。
 </Tip>
 
@@ -466,5 +470,5 @@ claude -p "List all API endpoints" --output-format json
 
 # Streaming for real-time processing
-claude -p "Analyze this log file" --output-format stream-json
+claude -p "Analyze this log file" --output-format stream-json --verbose
```

</details>

<details>
<summary>cli-reference-ja.md</summary>

```diff
diff --git a/docs-ja/pages/cli-reference-ja.md b/docs-ja/pages/cli-reference-ja.md
index 14ddc5f..dca521a 100644
--- a/docs-ja/pages/cli-reference-ja.md
+++ b/docs-ja/pages/cli-reference-ja.md
@@ -46,70 +46,70 @@
 これらのコマンドラインフラグを使用して Claude Code の動作をカスタマイズします。`claude --help` はすべてのフラグをリストしていないため、`--help` にフラグが表示されていないことは、そのフラグが利用できないことを意味しません。
 
-| フラグ                                             | 説明                                                                                                                                                                                                                                                                                                                          | 例                                                                                                  |
-| :---------------------------------------------- | :-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :------------------------------------------------------------------------------------------------- |
-| `--add-dir`                                     | Claude がファイルを読み取り、編集するための追加の作業ディレクトリを追加します。ファイルアクセスを許可します。ほとんどの `.claude/` 設定は [これらのディレクトリから検出されません](/ja/permissions#additional-directories-grant-file-access-not-configuration)。各パスがディレクトリとして存在することを検証します。これらのディレクトリをセッション全体で永続化するには、設定で [`permissions.additionalDirectories`](/ja/settings#permission-settings) を設定してください | `claude --add-dir ../apps ../lib`                                                                  |
-| `--agent`                                       | 現在のセッションのエージェントを指定します（`agent` 設定をオーバーライドします）                                                                                                                                                                                                                                                                                | `claude --agent my-custom-agent`                                                                   |
-| `--agents`                                      | JSON 経由でカスタム subagents を動的に定義します。subagent [frontmatter](/ja/sub-agents#supported-frontmatter-fields) と同じフィールド名を使用し、さらにエージェントの指示用の `prompt` フィールドを追加します                                                                                                                                                                      | `claude --agents '{"reviewer":{"description":"Reviews code","prompt":"You are a code reviewer"}}'` |
-| `--allow-dangerously-skip-permissions`          | `Shift+Tab` モードサイクルに `bypassPermissions` を追加します。これを開始時に有効にしません。`plan` のような別のモードで開始し、後で `bypassPermissions` に切り替えることができます。[権限モード](/ja/permission-modes#skip-all-checks-with-bypasspermissions-mode) を参照してください                                                                                                                | `claude --permission-mode plan --allow-dangerously-skip-permissions`                               |
-| `--allowedTools`                                | 権限を求めずに実行するツール。パターンマッチングについては [権限ルール構文](/ja/settings#permission-rule-syntax) を参照してください。利用可能なツールを制限するには、代わりに `--tools` を使用してください                                                                                                                                                                                             | `"Bash(git log *)" "Bash(git diff *)" "Read"`                                                      |
-| `--append-system-prompt`                        | デフォルトシステムプロンプトの末尾にカスタムテキストを追加します                                                                                                                                                                                                                                                                                            | `claude --append-system-prompt "Always use TypeScript"`                                            |
-| `--append-system-prompt-file`                   | ファイルから追加のシステムプロンプトテキストを読み込み、デフォルトプロンプトに追加します                                                                                                                                                                                                                                                                                | `claude --append-system-prompt-file ./extra-rules.txt`                                             |
-| `--bare`                                        | 最小限モード：hooks、skills、plugins、MCP サーバー、自動メモリ、CLAUDE.md の自動検出をスキップして、スクリプト化された呼び出しをより高速に開始します。Claude は Bash、ファイル読み取り、ファイル編集ツールにアクセスできます。[`CLAUDE_CODE_SIMPLE`](/ja/env-vars) を設定します。[bare mode](/ja/headless#start-faster-with-bare-mode) を参照してください                                                                            | `claude --bare -p "query"`                                                                         |
-| `--betas`                                       | API リクエストに含めるベータヘッダー（API キーユーザーのみ）                                                                                                                                                                                                                                                                                          | `claude --betas interleaved-thinking`                                                              |
-| `--bg`                                          | セッションを [バックグラウンドエージェント](/ja/agent-view) として開始し、すぐに戻ります。セッション ID と管理コマンドを出力します。`--agent` と組み合わせて特定の subagent を実行します                                                                                                                                                                                                          | `claude --bg "investigate the flaky test"`                                                         |
-| `--channels`                                    | （研究プレビュー）Claude がこのセッションでリッスンすべき [channel](/ja/channels) 通知を持つ MCP サーバー。`plugin:<name>@<marketplace>` エントリのスペース区切りリスト。Claude.ai 認証が必要です                                                                                                                                                                                     | `claude --channels plugin:my-notifier@my-marketplace`                                              |
-| `--chrome`                                      | Web 自動化とテストのための [Chrome ブラウザ統合](/ja/chrome) を有効にします                                                                                                                                                                                                                                                                         | `claude --chrome`                                                                                  |
-| `--continue`, `-c`                              | 現在のディレクトリで最新の会話を読み込みます。このディレクトリを `/add-dir` で追加したセッションを含みます                                                                                                                                                                                                                                                                 | `claude --continue`                                                                                |
-| `--dangerously-load-development-channels`       | 承認されたアローリストにない [channels](/ja/channels-reference#test-during-the-research-preview) をローカル開発用に有効にします。`plugin:<name>@<marketplace>` および `server:<name>` エントリを受け入れます。確認を求めます                                                                                                                                                    | `claude --dangerously-load-development-channels server:webhook`                                    |
-| `--dangerously-skip-permissions`                | すべての権限プロンプトをスキップします。`--permission-mode bypassPermissions` と同等です。[権限モード](/ja/permission-modes#skip-all-checks-with-bypasspermissions-mode) を参照して、これが何をスキップし、何をスキップしないかを確認してください                                                                                                                                              | `claude --dangerously-skip-permissions`                                                            |
-| `--debug`                                       | オプションのカテゴリフィルタリング付きでデバッグモードを有効にします（例：`"api,hooks"` または `"!statsig,!file"`）                                                                                                                                                                                                                                                  | `claude --debug "api,mcp"`                                                                         |
-| `--debug-file <path>`                           | デバッグログを特定のファイルパスに書き込みます。暗黙的にデバッグモードを有効にします。`CLAUDE_CODE_DEBUG_LOGS_DIR` より優先されます                                                                                                                                                                                                                                            | `claude --debug-file /tmp/claude-debug.log`                                                        |
-| `--disable-slash-commands`                      | このセッションのすべてのスキルとコマンドを無効にします                                                                                                                                                                                                                                                                                                 | `claude --disable-slash-commands`                                                                  |
-| `--disallowedTools`                             | 拒否ルール。ベアツール名はそのツールをモデルのコンテキストから削除します。`Bash(rm *)` のようなスコープ付きルールはツールを利用可能なままにし、一致する呼び出しのみを拒否します                                                                                                                                                                                                                              | `"Bash(git log *)" "Bash(git diff *)" "Edit"`                                                      |
-| `--effort`                                      | 現在のセッションの [努力レベル](/ja/model-config#adjust-effort-level) を設定します。オプション：`low`、`medium`、`high`、`xhigh`、`max`。利用可能なレベルはモデルによって異なります。[`effortLevel`](/ja/settings#available-settings) 設定をこのセッションでオーバーライドし、永続化されません                                                                                                                | `claude --effort high`                                                                             |
-| `--enable-auto-mode`                            | {/* max-version: 2.1.110 */}v2.1.111 で削除されました。Auto mode は現在 `Shift+Tab` サイクルにデフォルトで含まれています。`--permission-mode auto` を使用して開始してください                                                                                                                                                                                           | `claude --permission-mode auto`                                                                    |
```

</details>

<details>
<summary>discover-plugins-ja.md</summary>

```diff
diff --git a/docs-ja/pages/discover-plugins-ja.md b/docs-ja/pages/discover-plugins-ja.md
index db5547c..22daccd 100644
--- a/docs-ja/pages/discover-plugins-ja.md
+++ b/docs-ja/pages/discover-plugins-ja.md
@@ -91,4 +91,8 @@ Claude Code がプラグインがどのマーケットプレイスにも見つ
 * **監視**: `sentry`
 
+### 自動セキュリティレビュー
+
+`security-guidance` プラグインは Claude が行う各変更を一般的な脆弱性についてレビューし、Claude に見つかったものを修正するよう指示します。[Claude がコードを書く際にセキュリティの問題をキャッチする](/ja/security-guidance)を参照して、何をチェックするか、プロジェクト固有のルールを追加する方法を確認してください。
+
 ### 開発ワークフロー
 
@@ -167,5 +171,5 @@ Anthropic は、プラグインシステムで何が可能かを示す例プラ
 
     ```shell theme={null}
-    /plugin install commit-commands@anthropics-claude-code
+    /plugin install commit-commands@claude-code-plugins
     ```
 
```

</details>

<details>
<summary>google-vertex-ai-ja.md</summary>

```diff
diff --git a/docs-ja/pages/google-vertex-ai-ja.md b/docs-ja/pages/google-vertex-ai-ja.md
index 4f058a6..8d81b81 100644
--- a/docs-ja/pages/google-vertex-ai-ja.md
+++ b/docs-ja/pages/google-vertex-ai-ja.md
@@ -201,5 +201,5 @@ export VERTEX_REGION_CLAUDE_4_6_SONNET=europe-west1
 ほとんどのモデルバージョンには、対応する `VERTEX_REGION_CLAUDE_*` 変数があります。完全なリストについては、[環境変数リファレンス](/ja/env-vars)を参照してください。どのモデルがグローバルエンドポイントをサポートしているか、または地域別のみをサポートしているかを確認するには、[Vertex Model Garden](https://console.cloud.google.com/vertex-ai/model-garden)を確認してください。
 
-[prompt caching](/ja/prompt-caching)は自動的に有効になります。これを無効にするには、`DISABLE_PROMPT_CACHING=1` を設定します。デフォルトの 5 分ではなく 1 時間のキャッシュ TTL をリクエストするには、`ENABLE_PROMPT_CACHING_1H=1` を設定します。1 時間の TTL でのキャッシュ書き込みはより高いレートで課金されます。レート制限を高くするには、Google Cloud サポートに連絡してください。Vertex AI を使用する場合、Google Cloud 認証情報を通じて認証が処理されるため、`/login` および `/logout` コマンドは無効になります。
+[prompt caching](/ja/prompt-caching)は自動的に有効になります。これを無効にするには、`DISABLE_PROMPT_CACHING=1` を設定します。デフォルトの 5 分ではなく 1 時間のキャッシュ TTL をリクエストするには、`ENABLE_PROMPT_CACHING_1H=1` を設定します。1 時間の TTL でのキャッシュ書き込みはより高いレートで課金されます。レート制限を高くするには、Google Cloud サポートに連絡してください。Vertex AI を使用する場合、Google Cloud 認証情報を通じて認証が処理されるため、`/logout` コマンドは無効になります。
 
 Claude Code は Vertex AI でデフォルトで [MCP tool search](/ja/mcp#scale-with-mcp-tool-search)を無効にしているため、MCP ツール定義は事前にロードされます。Vertex AI は Claude Sonnet 4.5 以降および Claude Opus 4.5 以降のツール検索をサポートしています。`ENABLE_TOOL_SEARCH=true` を設定して、これらのモデルで有効にします。Vertex AI の以前のモデルは必要なベータヘッダーを受け入れず、これらのモデルでツール検索を有効にするとリクエストが失敗します。
```

</details>

<details>
<summary>hooks-guide-ja.md</summary>

```diff
diff --git a/docs-ja/pages/hooks-guide-ja.md b/docs-ja/pages/hooks-guide-ja.md
index eef1196..01ae6af 100644
--- a/docs-ja/pages/hooks-guide-ja.md
+++ b/docs-ja/pages/hooks-guide-ja.md
@@ -94,4 +94,6 @@ Hooks を使用すると、Claude Code のライフサイクルの主要なポ
 * [特定の許可プロンプトを自動承認する](#auto-approve-specific-permission-prompts)
 
+本番環境での hooks の例として、別のモデルレビューを実行し、その結果をセッションにフィードバックする場合は、[`security-guidance` プラグインが Claude Code と統合する方法](/ja/security-guidance#how-the-plugin-integrates-with-claude-code) を参照してください。
+
 ### Claude が入力を必要とするときに通知を受け取る
 
```

</details>

<details>
<summary>mcp-ja.md</summary>

```diff
diff --git a/docs-ja/pages/mcp-ja.md b/docs-ja/pages/mcp-ja.md
index a10ec0d..cae9faf 100644
--- a/docs-ja/pages/mcp-ja.md
+++ b/docs-ja/pages/mcp-ja.md
@@ -42,5 +42,5 @@ MCP サーバーが接続されている場合、Claude Code に以下のこと
     ```
 
-    次に `/reload-plugins` を実行して、現在のセッションでアクティブにします。
+    Claude Code がマーケットプレイスが見つからないと報告する場合は、まず `/plugin marketplace add anthropics/claude-plugins-official` を実行してから、インストールを再試行してください。インストール後、`/reload-plugins` を実行して、現在のセッションでアクティブにします。
   </Step>
 
@@ -324,5 +324,5 @@ claude mcp add --transport http hubspot --scope user https://mcp.hubspot.com/ant
 ### スコープの階層と優先順位
 
-同じサーバーが複数の場所で定義されている場合、Claude Code はそれに 1 回接続し、最も優先度の高いソースからの定義を使用します：
+同じサーバーが複数の場所で定義されている場合、Claude Code はそれに 1 回接続し、最も優先度の高いソースからの定義を使用します。その定義全体が使用され、フィールドはスコープ全体でマージされません。
 
 1. ローカルスコープ
```

</details>

<details>
<summary>memory-ja.md</summary>

```diff
diff --git a/docs-ja/pages/memory-ja.md b/docs-ja/pages/memory-ja.md
index b72f343..a5fa144 100644
--- a/docs-ja/pages/memory-ja.md
+++ b/docs-ja/pages/memory-ja.md
@@ -21,5 +21,5 @@ Claude Code の各セッションは、新しいコンテキストウィンド
 ## CLAUDE.md と自動メモリ
 
-Claude Code には 2 つの相互補完的なメモリシステムがあります。どちらも各会話の開始時に読み込まれます。Claude はこれらをコンテキストとして扱い、強制的な設定ではありません。指示がより具体的で簡潔であるほど、Claude はそれに従う可能性が高くなります。
+Claude Code には 2 つの相互補完的なメモリシステムがあります。どちらも各会話の開始時に読み込まれます。Claude はこれらをコンテキストとして扱い、強制的な設定ではありません。指示がより具体的で簡潔であるほど、Claude はそれに従う可能性が高くなります。アクションをブロックするには、Claude の判断に関わらず [PreToolUse hook](/ja/hooks-guide) を使用してください。
 
 |              | CLAUDE.md ファイル                | 自動メモリ                          |
@@ -95,5 +95,5 @@ CLAUDE.md ファイルは各セッションの開始時にコンテキストウ
 CLAUDE.md ファイルは `@path/to/import` 構文を使用して追加ファイルをインポートできます。インポートされたファイルは展開され、それらを参照する CLAUDE.md と一緒に起動時にコンテキストに読み込まれます。
 
-相対パスと絶対パスの両方が許可されます。相対パスはワーキングディレクトリではなく、インポートを含むファイルに相対的に解決されます。インポートされたファイルは他のファイルを再帰的にインポートでき、最大深度は 5 ホップです。
+相対パスと絶対パスの両方が許可されます。相対パスはワーキングディレクトリではなく、インポートを含むファイルに相対的に解決されます。インポートされたファイルは他のファイルを再帰的にインポートでき、最大深度は 4 ホップです。
 
 README、package.json、およびワークフローガイドを取得するには、CLAUDE.md の任意の場所で `@` 構文を使用してそれらを参照します。
@@ -151,5 +151,5 @@ Claude Code は現在のワーキングディレクトリからディレクト
 Claude は現在のワーキングディレクトリの下のサブディレクトリ内の `CLAUDE.md` および `CLAUDE.local.md` ファイルも発見します。起動時に読み込む代わりに、Claude がそれらのサブディレクトリ内のファイルを読むときに含まれます。
 
-他のチームの CLAUDE.md ファイルが取得される大規模なモノレポで作業する場合は、[`claudeMdExcludes`](#exclude-specific-claude-md-files) を使用してそれらをスキップします。
+他のチームの CLAUDE.md ファイルが取得される大規模なモノレポで作業する場合は、[`claudeMdExcludes`](#exclude-specific-claude-md-files) を使用してそれらをスキップします。大規模なリポジトリのルートおよびディレクトリごとの CLAUDE.md ファイルとルールの完全なレイアウトについては、[モノレポと大規模リポジトリ](/ja/large-codebases)を参照してください。
 
 CLAUDE.md ファイル内のブロックレベル HTML コメント（`<!-- maintainer notes -->`）は、コンテンツが Claude のコンテキストに注入される前に削除されます。コンテキストトークンを費やさずに人間のメンテナーのためにメモを残すために使用します。コードブロック内のコメントは保持されます。Read ツールで CLAUDE.md ファイルを直接開くと、コメントは表示されたままになります。
```

</details>

*...以降省略*

</details>


<details>
<summary>2026-05-26</summary>

**変更ファイル:**

```
 docs-ja/pages/claude-directory-ja.md  |  4 ++--
 docs-ja/pages/commands-ja.md          |  2 +-
 docs-ja/pages/costs-ja.md             |  8 +++++--
 docs-ja/pages/features-overview-ja.md |  2 --
 docs-ja/pages/keybindings-ja.md       | 29 +++++++++++++++-------
 docs-ja/pages/managed-mcp-ja.md       | 25 ++++++++++++-------
 docs-ja/pages/monitoring-usage-ja.md  | 16 +++++++++----
 docs-ja/pages/output-styles-ja.md     |  2 ++
 docs-ja/pages/permissions-ja.md       |  3 ++-
 docs-ja/pages/prompt-caching-ja.md    | 13 ++++++----
 docs-ja/pages/remote-control-ja.md    |  2 +-
 docs-ja/pages/settings-ja.md          |  1 +
 docs-ja/pages/skills-ja.md            | 17 ++++++++++++-
 docs-ja/pages/sub-agents-ja.md        | 45 ++++++++++++++++++++---------------
 docs-ja/pages/tools-reference-ja.md   |  4 ++--
 15 files changed, 117 insertions(+), 56 deletions(-)
```

<details>
<summary>claude-directory-ja.md</summary>

```diff
diff --git a/docs-ja/pages/claude-directory-ja.md b/docs-ja/pages/claude-directory-ja.md
index cc41673..2b3cba4 100644
--- a/docs-ja/pages/claude-directory-ja.md
+++ b/docs-ja/pages/claude-directory-ja.md
@@ -1509,4 +1509,5 @@ Windows では、`~/.claude` は `%USERPROFILE%\.claude` に解決されます
 | `backups/`                                   | 設定マイグレーション前に取得された `~/.claude.json` のタイムスタンプ付きコピー                                     |
 | `feedback-bundles/`                          | `/feedback` によってサードパーティプロバイダーに書き込まれた編集済みトランスクリプトアーカイブ。Anthropic アカウントチームに送信するため      |
+| `todos/`、`statsig/`、`logs/`                  | 古いバージョンのレガシーディレクトリ。現在は書き込まれません。スイープはコンテンツを削除してから空のディレクトリを削除します。                      |
 
 ### 削除するまで保持される
@@ -1519,5 +1520,4 @@ Windows では、`~/.claude` は `%USERPROFILE%\.claude` に解決されます
 | `stats-cache.json`     | `/usage` で表示される集計トークンおよびコスト数                                                           |
 | `remote-settings.json` | 組織の[サーバー管理設定](/ja/server-managed-settings)のキャッシュコピー。組織が設定を構成している場合のみ存在します。各起動時に更新されます。 |
-| `todos/`               | レガシーセッションごとのタスクリスト。現在のバージョンでは書き込まれません。削除しても安全です。                                       |
 
 その他の小さなキャッシュおよびロックファイルは、使用する機能に応じて表示され、削除しても安全です。
@@ -1576,5 +1576,5 @@ claude project purge ~/work/my-repo --yes
 | `~/.claude/remote-settings.json`                                                                                                                                                      | なし。次の起動時に再取得されます。               |
 | `~/.claude/debug/`、`~/.claude/plans/`、`~/.claude/paste-cache/`、`~/.claude/image-cache/`、`~/.claude/session-env/`、`~/.claude/tasks/`、`~/.claude/shell-snapshots/`、`~/.claude/backups/` | ユーザー向けのもの                       |
-| `~/.claude/todos/`                                                                                                                                                                    | なし。現在のバージョンでは書き込まれないレガシーディレクトリ。 |
+| `~/.claude/todos/`、`~/.claude/statsig/`、`~/.claude/logs/`                                                                                                                             | なし。現在のバージョンでは書き込まれないレガシーディレクトリ。 |
 
 `~/.claude.json`、`~/.claude/settings.json`、または `~/.claude/plugins/` は削除しないでください。これらは認証、設定、インストール済みプラグインを保持しています。
```

</details>

<details>
<summary>commands-ja.md</summary>

```diff
diff --git a/docs-ja/pages/commands-ja.md b/docs-ja/pages/commands-ja.md
index 29bd6dc..e0f52f1 100644
--- a/docs-ja/pages/commands-ja.md
+++ b/docs-ja/pages/commands-ja.md
@@ -125,5 +125,5 @@
 | `/ultrareview [PR]`                                                 | [ultrareview](/ja/ultrareview) を使用してクラウドサンドボックスで深い複数エージェントコードレビューを実行します。Pro と Max に 3 つの無料実行が含まれ、その後は [usage credits](https://support.claude.com/en/articles/12429409-extra-usage-for-paid-claude-plans) が必要です                                                                                                                                                                                                                                                                                                 |
 | `/upgrade`                                                          | アップグレードページを開いて、より高いプランティアに切り替えます                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
-| `/usage`                                                            | セッションコスト、プラン使用制限、およびアクティビティ統計を表示します。サブスクリプション固有の詳細については、[コスト追跡ガイド](/ja/costs#using-the-%2Fusage-command)を参照してください。`/cost` と `/stats` はエイリアスです                                                                                                                                                                                                                                                                                                                                                                  |
+| `/usage`                                                            | セッションコスト、プラン使用制限、およびアクティビティ統計を表示します。Pro、Max、Team、または Enterprise プランの場合、スキル、サブエージェント、プラグイン、MCP サーバーごとの使用状況の内訳が含まれます。詳細については、[コスト追跡ガイド](/ja/costs#using-the-%2Fusage-command)を参照してください。`/cost` と `/stats` はエイリアスです                                                                                                                                                                                                                                                                                               |
 | `/usage-credits`                                                    | 制限に達したときに作業を続行するための usage credits を構成します。以前は `/extra-usage`                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
 | `/verify`                                                           | **[スキル](/ja/skills#bundled-skills)。** プロジェクトのアプリをビルドして実行し、結果を観察することで、コード変更が期待通りに機能することを確認します。テストまたは型チェックに依存するのではなく。[アプリを実行して検証](/ja/skills#run-and-verify-your-app)を参照してください。{/* min-version: 2.1.145 */}Claude Code v2.1.145 以降が必要です                                                                                                                                                                                                                                                                          |
```

</details>

<details>
<summary>costs-ja.md</summary>

```diff
diff --git a/docs-ja/pages/costs-ja.md b/docs-ja/pages/costs-ja.md
index 9739f2d..9064823 100644
--- a/docs-ja/pages/costs-ja.md
+++ b/docs-ja/pages/costs-ja.md
@@ -18,8 +18,8 @@ Claude Code は API トークン消費によって課金されます。サブス
 
 <Note>
-  `/usage` のセッションブロックは API トークン使用量を表示し、API ユーザーを対象としています。Claude Max および Pro サブスクライバーはサブスクリプションに使用量が含まれているため、セッションコスト数値は請求目的では関連がありません。サブスクライバーは同じ画面でプラン使用量バーとアクティビティ統計を表示します。
+  `/usage` のセッションブロックは API トークン使用量を表示し、API ユーザーを対象としています。Claude Max および Pro サブスクライバーはサブスクリプションに使用量が含まれているため、セッションコスト数値は請求目的では関連がありません。サブスクライバーは同じ画面でプラン使用量バー、アクティビティ統計、および使用量の内訳を表示します。
 </Note>
 
-`/usage` コマンドは現在のセッションの詳細なトークン使用統計を提供します。ドル数値はトークン数から局所的に計算された推定値であり、実際の請求書と異なる場合があります。権限のある請求については、[Claude Console](https://platform.claude.com/usage) の使用量ページを参照してください。
+`/usage` の上部のセッションブロックは、現在のセッションの詳細なトークン使用統計を表示します。ドル数値はトークン数から局所的に計算された推定値であり、実際の請求書と異なる場合があります。権限のある請求については、[Claude Console](https://platform.claude.com/usage) の使用量ページを参照してください。
 
 ```text theme={null}
@@ -30,8 +30,12 @@ Total code changes:    0 lines added, 0 lines removed
 ```
 
+Pro、Max、Team、または Enterprise プランでは、`/usage` はプラン制限に対してカウントされるものの内訳も表示します。最近の使用量をスキル、サブエージェント、プラグイン、および個別の MCP サーバーに属性付けし、それぞれが合計のパーセンテージとして表示されます。`d` または `w` を押して、過去 24 時間と過去 7 日間を切り替えることができます。数値は概算であり、このマシン上のローカルセッション履歴から計算されるため、他のデバイスまたは claude.ai からの使用量は含まれていません。
+
 ## チームのコストを管理する
 
 Claude API を使用する場合、Claude Code ワークスペース支出の合計に対して [ワークスペース支出制限を設定](https://platform.claude.com/docs/ja/build-with-claude/workspaces#workspace-limits) できます。管理者は Console で [コストと使用状況レポートを表示](https://platform.claude.com/docs/ja/build-with-claude/workspaces#usage-and-cost-tracking) できます。
 
+Pro および Max プランでは、`/usage-credits` コマンドを使用して使用クレジットの月間支出制限を設定できます。その制限に達しても使用クレジットがまだ利用可能な場合、Claude Code はプロンプトを表示して、制限を引き上げるか削除するよう促し、CLI を離れることなく続行できるようにします。制限の変更にはアカウントの請求アクセスが必要です。
+
 <Note>
   Claude Code を Claude Console アカウントで初めて認証すると、「Claude Code」というワークスペースが自動的に作成されます。このワークスペースは、組織内のすべての Claude Code 使用量の一元化されたコスト追跡と管理を提供します。このワークスペースの API キーを作成することはできません。これは Claude Code 認証と使用量専用です。
```

</details>

<details>
<summary>features-overview-ja.md</summary>

```diff
diff --git a/docs-ja/pages/features-overview-ja.md b/docs-ja/pages/features-overview-ja.md
index 85ae42e..88093dd 100644
--- a/docs-ja/pages/features-overview-ja.md
+++ b/docs-ja/pages/features-overview-ja.md
@@ -266,6 +266,4 @@ Claude Code は、コードについて推論するモデルと、ファイル
     **コンテキストコスト：** [ツール検索](/ja/mcp#scale-with-mcp-tool-search) はデフォルトで有効になっているため、アイドル MCP ツールは最小限のコンテキストを消費します。
 
-    **信頼性に関する注記：** MCP 接続はセッション中に静かに失敗する可能性があります。サーバーが切断されると、そのツールは警告なく消えます。Claude は以前アクセスできたツールを使用しようとする可能性があります。Claude が以前アクセスできた MCP ツールを使用できなくなったことに気付いた場合は、`/mcp` で接続を確認してください。
-
     <Tip>`/mcp` を実行してサーバーごとのトークンコストを確認します。積極的に使用していないサーバーを切断します。</Tip>
   </Tab>
```

</details>

<details>
<summary>keybindings-ja.md</summary>

```diff
diff --git a/docs-ja/pages/keybindings-ja.md b/docs-ja/pages/keybindings-ja.md
index 186e886..df5334f 100644
--- a/docs-ja/pages/keybindings-ja.md
+++ b/docs-ja/pages/keybindings-ja.md
@@ -248,13 +248,24 @@ Claude Code はカスタマイズ可能なキーボードショートカット
 `DiffDialog` コンテキストで利用可能なアクション：
 
-| アクション                 | デフォルト      | 説明            |
-| :-------------------- | :--------- | :------------ |
-| `diff:dismiss`        | Escape     | Diff ビューアを閉じる |
-| `diff:previousSource` | Left       | 前の Diff ソース   |
-| `diff:nextSource`     | Right      | 次の Diff ソース   |
-| `diff:previousFile`   | Up         | Diff の前のファイル  |
-| `diff:nextFile`       | Down       | Diff の次のファイル  |
-| `diff:viewDetails`    | Enter      | Diff の詳細を表示   |
-| `diff:back`           | （コンテキスト固有） | Diff ビューアで戻る  |
+| アクション                 | デフォルト      | 説明                               |
+| :-------------------- | :--------- | :------------------------------- |
+| `diff:dismiss`        | Escape     | Diff ビューアを閉じる                    |
+| `diff:previousSource` | Left       | 前の Diff ソース                      |
+| `diff:nextSource`     | Right      | 次の Diff ソース                      |
+| `diff:previousFile`   | Up、K       | ファイルリストの前のファイル。詳細ビューで 1 行上にスクロール |
+| `diff:nextFile`       | Down、J     | ファイルリストの次のファイル。詳細ビューで 1 行下にスクロール |
+| `diff:viewDetails`    | Enter      | Diff の詳細を表示                      |
+| `diff:back`           | （コンテキスト固有） | Diff ビューアで戻る                     |
+
+Diff 詳細ビューは、ページャースタイルのキーを標準的な[スクロールアクション](#scroll-actions)にバインドします。これらのバインディングは `DiffDialog` コンテキストの一部であり、詳細ビューにのみ適用されます。[スクロールアクション](#scroll-actions)の下に記載されている `Scroll` コンテキストのデフォルトは変わりません。
+
+| アクション                 | デフォルト         | 説明                 |
+| :-------------------- | :------------ | :----------------- |
```

</details>

<details>
<summary>managed-mcp-ja.md</summary>

```diff
diff --git a/docs-ja/pages/managed-mcp-ja.md b/docs-ja/pages/managed-mcp-ja.md
index 98936f3..b2ea6fb 100644
--- a/docs-ja/pages/managed-mcp-ja.md
+++ b/docs-ja/pages/managed-mcp-ja.md
@@ -41,5 +41,5 @@ Claude Code は、さまざまな制限レベルをサポートしています
 ## managed-mcp.json による排他的制御
 
-`managed-mcp.json` ファイルをデプロイすると、Claude Code はそのファイルで定義されたサーバーのみを読み込みます。ユーザーは、プラグイン提供のサーバーや claude.ai コネクターを含む、他の MCP サーバーを追加、変更、または使用することはできません。
+`managed-mcp.json` ファイルをデプロイすると、Claude Code はそのファイルで定義されたサーバーのみを読み込みます。ユーザーは、プラグイン提供のサーバーを含む他の MCP サーバーを追加、変更、または使用することはできません。また、このファイルは [管理対象セットと共に許可する](#allow-claude-ai-connectors-alongside-the-managed-set)場合を除き、claude.ai コネクターも抑制します。
 
 2 つの他の設定は、管理対象セットをさらにフィルタリングできます。
@@ -110,4 +110,12 @@ Claude Code は、さまざまな制限レベルをサポートしています
 ユーザーは `/mcp` に MCP サーバーを表示しません。`claude mcp add` は上記のエンタープライズポリシーエラーで失敗します。ユーザーが以前に設定したサーバーは、次回セッションを開始するときに読み込みを停止します。ポリシーが理由であることについて警告はありません。
 
+### 管理対象セットと共に claude.ai コネクターを許可する
+
+`managed-mcp.json` をデプロイすると、デフォルトでは [claude.ai コネクター](/ja/mcp#use-mcp-servers-from-claude-ai)が抑制されます。これには、管理者が claude.ai 管理コンソールで組織向けに設定したコネクターも含まれます。これらのコネクターを `managed-mcp.json` 内のサーバーと共に読み込むには、[管理設定ソース](/ja/admin-setup#decide-how-settings-reach-devices)で `"allowAllClaudeAiMcps": true` を設定します。Claude Code v2.1.149 以降が必要です。
+
+この設定が有効になると、Claude Code は `managed-mcp.json` がデプロイされていない場合に読み込むのと同じ claude.ai コネクターを読み込みます。[許可リストと拒否リスト](#policy-based-control-with-allowlists-and-denylists)は引き続きこれらのコネクターに適用されるため、`deniedMcpServers` で特定のコネクターをブロックできます。この設定は claude.ai コネクターのみに影響します。プラグイン提供のサーバーは抑制されたままです。
+
+Claude Code は、この設定を管理者制御のポリシー層からのみ読み取ります。サーバー管理設定、MDM デプロイされた plist または HKLM レジストリキー、またはシステム `managed-settings.json` ファイルです。これをユーザーまたはプロジェクト設定に配置しても効果がないため、ユーザーは排他的制御が抑制したコネクターを再度有効にすることはできません。
+
 ## 許可リストとブロックリストによるポリシーベースの制御
 
@@ -322,12 +330,13 @@ Claude Code は、さまざまな制限レベルをサポートしています
 ## 設定の概要
 
-このページで説明するすべてのファイルと設定、それが制御するもの、および配信方法。
+このページで説明するすべてのファイルと設定、それが制御するもの、および配信方法：
 
```

</details>

<details>
<summary>monitoring-usage-ja.md</summary>

```diff
diff --git a/docs-ja/pages/monitoring-usage-ja.md b/docs-ja/pages/monitoring-usage-ja.md
index a625b86..96ee86b 100644
--- a/docs-ja/pages/monitoring-usage-ja.md
+++ b/docs-ja/pages/monitoring-usage-ja.md
@@ -263,4 +263,6 @@ Agent SDK および `claude -p` セッションでは、`TRACEPARENT` が環境
 ```
 
+値は、スペースを含むパスを含む実行可能ファイルへのパス、またはシェルコマンドラインと引数です。Windows では、値は常にシェルを通じて実行されるため、JSON 値内にスペースを含むパスをクォートで囲みます。
+
 #### スクリプト要件
 
@@ -273,4 +275,10 @@ echo "{\"Authorization\": \"Bearer $(get-token.sh)\", \"X-API-Key\": \"$(get-api
 ```
 
+ヘルパーが失敗するか、これらの要件を満たさない出力を出力する場合、Claude Code は以下のエラーを報告します:
+
+* `/doctor` 出力
+* [`--debug`](/ja/cli-reference#cli-flags) で実行するか、セッション内で `/debug` を実行した後のデバッグログ
+* stderr、`-p` で開始された非対話型セッション内
+
 #### リフレッシュ動作
 
@@ -530,5 +538,5 @@ Claude Code は、OpenTelemetry ログ/イベント経由で以下のイベン
 #### ツール結果イベント
 
-ツールが実行を完了するときにログされます。
+ツールが実行を完了するときにログされます。ツール呼び出しが拒否された場合は出力されません。[ツール決定イベント](#tool-decision-event)を参照してください。
 
 **イベント名**: `claude_code.tool_result`
@@ -546,6 +554,6 @@ Claude Code は、OpenTelemetry ログ/イベント経由で以下のイベン
```

</details>

*...以降省略*

</details>


<details>
<summary>2026-05-25</summary>

**変更ファイル:**

```
 docs-ja/pages/code-review-ja.md     |  6 +++++-
 docs-ja/pages/quickstart-ja.md      | 10 +++++-----
 docs-ja/pages/sandboxing-ja.md      |  1 +
 docs-ja/pages/tools-reference-ja.md |  3 ++-
 4 files changed, 13 insertions(+), 7 deletions(-)
```

<details>
<summary>code-review-ja.md</summary>

```diff
diff --git a/docs-ja/pages/code-review-ja.md b/docs-ja/pages/code-review-ja.md
index eacd4b1..2750b92 100644
--- a/docs-ja/pages/code-review-ja.md
+++ b/docs-ja/pages/code-review-ja.md
@@ -26,4 +26,8 @@ Claude を管理サービスではなく独自の CI インフラストラクチ
 * [トラブルシューティング](#troubleshooting)失敗した実行と欠落したコメント
 
+<Note>
+  GitHub アプリをインストールせずにターミナルでローカルに差分をレビューするには、任意の Claude Code セッションで [`/code-review` コマンド](/ja/commands)を実行してください。選択した努力レベルで現在の差分の正確性バグを報告し、`--comment` で結果をインライン PR コメントとして投稿できます。このコマンドは v2.1.147 より前は `/simplify` という名前でした。
+</Note>
+
 ## レビューの仕組み
 
@@ -268,5 +272,5 @@ GitHub の Checks タブの **Re-run** ボタンは Code Review を再トリガ
 Code Review は Claude Code の残りの部分と連携するように設計されています。PR を開く前にローカルでレビューを実行したい場合、自己ホスト型セットアップが必要な場合、または `CLAUDE.md` がツール全体で Claude の動作をどのように形成するかについてさらに詳しく知りたい場合、これらのページは次の良い停止点です：
 
-* [Plugins](/ja/discover-plugins): プッシュ前にローカルでオンデマンドレビューを実行するための `code-review` プラグインを含むプラグインマーケットプレイスを参照
+* [Commands](/ja/commands): ローカルの Claude Code セッションで `/code-review` を実行して、プッシュ前に差分をチェック
 * [GitHub Actions](/ja/github-actions): コードレビューを超えたカスタム自動化のための独自の GitHub Actions ワークフローで Claude を実行
 * [GitLab CI/CD](/ja/gitlab-ci-cd): GitLab パイプライン用の自己ホスト型 Claude 統合
```

</details>

<details>
<summary>quickstart-ja.md</summary>

```diff
diff --git a/docs-ja/pages/quickstart-ja.md b/docs-ja/pages/quickstart-ja.md
index ba1a22a..45f226e 100644
--- a/docs-ja/pages/quickstart-ja.md
+++ b/docs-ja/pages/quickstart-ja.md
@@ -82,14 +82,14 @@ You can also install with [apt, dnf, or apk](/en/setup#install-with-linux-packag
 ## ステップ 2：アカウントにログインする
 
-Claude Code を使用するにはアカウントが必要です。`claude` コマンドでインタラクティブセッションを開始すると、ログインが必要になります：
+Claude Code を使用するにはアカウントが必要です。`claude` コマンドでインタラクティブセッションを開始すると、初回使用時にログインするよう求められます：
 
 ```bash theme={null}
 claude
-# 初回使用時にログインするよう求められます
 ```
 
-```bash theme={null}
+Claude サブスクリプションまたは Console アカウントの場合は、プロンプトに従ってブラウザで認証を完了してください。後でアカウントを切り替えるか再認証するには、実行中のセッション内で `/login` と入力します：
+
+```text theme={null}
 /login
-# プロンプトに従ってアカウントでログインします
 ```
 
@@ -100,5 +100,5 @@ claude
 * [Amazon Bedrock、Google Vertex AI、または Microsoft Foundry](/ja/third-party-integrations)（エンタープライズクラウドプロバイダー）
 
-ログイン後、認証情報がシステムに保存され、再度ログインする必要はありません。後でアカウントを切り替えるには、`/login` コマンドを使用します。
+ログイン後、認証情報が保存され、再度ログインする必要はありません。
 
 ## ステップ 3：最初のセッションを開始する
```

</details>

<details>
<summary>sandboxing-ja.md</summary>

```diff
diff --git a/docs-ja/pages/sandboxing-ja.md b/docs-ja/pages/sandboxing-ja.md
index 920238d..bdb8acd 100644
--- a/docs-ja/pages/sandboxing-ja.md
+++ b/docs-ja/pages/sandboxing-ja.md
@@ -201,4 +201,5 @@ Claude Code は 2 つのサンドボックスモードを提供します。
 * **デフォルトの読み取り動作**：特定の拒否ディレクトリを除く、コンピュータ全体への読み取りアクセス。このデフォルトは `~/.aws/credentials` や `~/.ssh/` などの認証情報ファイルの読み取りを許可することに注意してください。これらをブロックするには、`denyRead` に追加してください。
 * **ブロックされたアクセス**：明示的な許可なしに現在の作業ディレクトリ外のファイルを変更できません。これには `~/.bashrc` などのシェル設定ファイルと `/bin/` のシステムバイナリが含まれます。
+* **Git worktrees**：作業ディレクトリが[リンクされた git worktree](/ja/worktrees)の場合、サンドボックスはメインリポジトリの共有 `.git` ディレクトリへの書き込みも許可するため、`git commit` などのコマンドが refs とインデックスを更新できます。そのディレクトリ内の `hooks/` と `config` への書き込みは引き続き拒否されます。
 * **設定可能**：設定を通じてカスタム許可パスと拒否パスを定義します
 
```

</details>

<details>
<summary>tools-reference-ja.md</summary>

```diff
diff --git a/docs-ja/pages/tools-reference-ja.md b/docs-ja/pages/tools-reference-ja.md
index f65f794..94a262f 100644
--- a/docs-ja/pages/tools-reference-ja.md
+++ b/docs-ja/pages/tools-reference-ja.md
@@ -112,6 +112,7 @@ Bash ツールは、次の永続化動作で各コマンドを別々のプロセ
   * この引き継ぎを無効にして、すべての Bash コマンドがプロジェクト ディレクトリで開始されるようにするには、`CLAUDE_BASH_MAINTAIN_PROJECT_WORKING_DIR=1` を設定します。
 * 環境変数は永続化されません。1 つのコマンドの `export` は次のコマンドでは利用できません。
+* シェル スタートアップ ファイルで定義されたエイリアスとシェル関数は利用できます。セッション開始時に、Claude Code はシェルに応じて `~/.zshrc`、`~/.bashrc`、または `~/.profile` をソースし、結果のエイリアス、関数、およびシェル オプションをキャプチャして、すべての Bash コマンドに適用します。
 
-Claude Code を起動する前に virtualenv または conda 環境をアクティブ化してください。Bash コマンド間で環境変数を永続化するには、Claude Code を起動する前に [`CLAUDE_ENV_FILE`](/ja/env-vars)をシェル スクリプトに設定するか、[SessionStart フック](/ja/hooks#persist-environment-variables)を使用して動的に設定します。
+Claude Code を起動する前に virtualenv または conda 環境をアクティブ化してください。Bash コマンド間で環境変数を永続化するには、Claude Code を起動する前に [`CLAUDE_ENV_FILE`](/ja/env-vars) をシェル スクリプトに設定するか、[SessionStart フック](/ja/hooks#persist-environment-variables)を使用して動的に設定します。
 
 2 つの制限が各コマンドを制限します：
```

</details>

</details>


<details>
<summary>2026-05-24</summary>

**変更ファイル:**

```
 docs-ja/pages/changelog.md | 4 ++++
 1 file changed, 4 insertions(+)
```

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index 1f55984..20cadc6 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,8 @@
 # Changelog
 
+## 2.1.150
+
+- Internal infrastructure improvements (no user-facing changes)
+
 ## 2.1.149
 
```

</details>

</details>


<details>
<summary>2026-05-23</summary>

**変更ファイル:**

```
 docs-ja/pages/agent-view-ja.md           |  10 +-
 docs-ja/pages/changelog.md               |  33 ++++++
 docs-ja/pages/commands-ja.md             | 186 +++++++++++++++----------------
 docs-ja/pages/env-vars-ja.md             |   2 +-
 docs-ja/pages/errors-ja.md               |  19 ++++
 docs-ja/pages/features-overview-ja.md    |   2 +-
 docs-ja/pages/glossary-ja.md             |   2 +-
 docs-ja/pages/interactive-mode-ja.md     |   1 +
 docs-ja/pages/keybindings-ja.md          |   6 +-
 docs-ja/pages/mcp-ja.md                  |   3 +
 docs-ja/pages/model-config-ja.md         |  12 +-
 docs-ja/pages/plugin-marketplaces-ja.md  |   2 +-
 docs-ja/pages/settings-ja.md             |   5 +-
 docs-ja/pages/setup-ja.md                |  35 +++---
 docs-ja/pages/skills-ja.md               |   4 +-
 docs-ja/pages/tools-reference-ja.md      |   2 +
 docs-ja/pages/troubleshoot-install-ja.md |  22 ++--
 17 files changed, 209 insertions(+), 137 deletions(-)
```

<details>
<summary>agent-view-ja.md</summary>

```diff
diff --git a/docs-ja/pages/agent-view-ja.md b/docs-ja/pages/agent-view-ja.md
index 927081d..db305cf 100644
--- a/docs-ja/pages/agent-view-ja.md
+++ b/docs-ja/pages/agent-view-ja.md
@@ -177,5 +177,5 @@ Completed
 グループ内で：
 
-* `Ctrl+T` を押してセッションをトップにピン留めします
+* `Ctrl+T` を押してセッションをトップにピン留めし、[アイドル中にそのプロセスを実行し続けます](#the-supervisor-process)
 * `Shift+↑` または `Shift+↓` を押してセッションを並べ替えます
 * `Ctrl+R` を押してセッションの名前を変更します
@@ -422,7 +422,9 @@ claude agents --settings ./ci-settings.json --add-dir ../shared-lib
 各バックグラウンドセッションは独自の Claude Code プロセスであり、ターミナルではなくスーパーバイザーによって管理されます。アクティブに作業しているセッション、入力を待機しているセッション、またはターミナルが接続されているセッションはプロセスを実行し続けます。実行中のバックグラウンドシェルコマンド、サブエージェント、ワークフロー、またはモニターはアクティブな作業としてカウントされるため、開発サーバーなどの長時間実行プロセスはセッションを生かし続けます。
 
-セッションが完了し、約 1 時間アタッチされていない状態で待機すると、スーパーバイザーはリソースを解放するためにプロセスを停止します。トランスクリプトと状態はディスク上に残り、次回アタッチ、ピーク表示、または返信するときに、スーパーバイザーは中断したところから新しいプロセスを開始します。すべてのセッションが完了し、ターミナルが接続されていない場合、スーパーバイザー自体が終了し、次回セッションをバックグラウンド化するか、エージェントビューを開くときに再度開始します。
+セッションが完了し、約 1 時間アタッチされていない状態で待機すると、スーパーバイザーはリソースを解放するためにプロセスを停止します。[`Ctrl+T`](#organize-the-list) でピン留めしたセッションは除外され、アイドル状態でもプロセスを実行し続けます。トランスクリプトと状態はディスク上に残り、次回アタッチ、ピーク表示、または返信するときに、スーパーバイザーは中断したところから新しいプロセスを開始します。すべてのセッションが完了し、ターミナルが接続されていない場合、スーパーバイザー自体が終了し、次回セッションをバックグラウンド化するか、エージェントビューを開くときに再度開始します。
 
-スーパーバイザーはディスク上にインストールされた Claude Code バイナリを監視し、通常の [自動更新プログラム](/ja/setup#auto-updates) がそれを置き換えた後、新しいバージョンに再開します。これはネットワークチェックではなく、ローカルファイルウォッチです。バックグラウンドセッションはデタッチされたプロセスであるため、再開を通じて実行し続け、新しいスーパーバイザーはそれらに再接続します。
+ホストのメモリが不足している場合、スーパーバイザーはアイドル状態の非ピン留めセッションを最初に停止し、何も解放されない場合のみアイドル状態のピン留めセッションを停止します。
+
+スーパーバイザーはディスク上にインストールされた Claude Code バイナリを監視し、通常の [自動更新プログラム](/ja/setup#auto-updates) がそれを置き換えた後、新しいバージョンに再開します。これはネットワークチェックではなく、ローカルファイルウォッチです。バックグラウンドセッションはデタッチされたプロセスであるため、再開を通じて実行し続け、新しいスーパーバイザーはそれらに再接続します。アイドル状態のピン留めセッションも新しいバージョンに再開されるため、再度アタッチすることなく更新を取得します。
 
 ### 状態が保存される場所
@@ -470,5 +472,5 @@ claude agents --settings ./ci-settings.json --add-dir ../shared-lib
 ### セッションがアタッチ後に応答が遅い
 
-セッションが完了し、約 1 時間アタッチされていない状態で待機すると、スーパーバイザーはリソースを解放するためにプロセスを停止します。アタッチすると、中断したところから新しいプロセスが開始され、少し時間がかかります。作業中または入力を待機しているセッションはこの方法で停止されることはありません。
+セッションが完了し、約 1 時間アタッチされていない状態で待機すると、スーパーバイザーはリソースを解放するためにプロセスを停止します。アタッチすると、中断したところから新しいプロセスが開始され、少し時間がかかります。作業中または入力を待機しているセッション、または[ピン留めされた](#organize-the-list)セッションはこの方法で停止されることはありません。セッションを `Ctrl+T` でピン留めして、応答性を保つことができます。
 
 ### `.claude/worktrees/` が満杯になっている
```

</details>

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index 7c01af0..1f55984 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,37 @@
 # Changelog
 
+## 2.1.149
+
+- `/usage` now shows a per-category breakdown of what's driving your limits usage — skills, subagents, plugins, and per-MCP-server cost
+- `/diff` detail view can now be scrolled with the keyboard (arrows, `j`/`k`, `PgUp`/`PgDn`, `Space`, `Home`/`End`)
+- Markdown output now renders GFM task list checkboxes (`- [ ] todo` / `- [x] done`) instead of plain bullets
+- Enterprise: added the `allowAllClaudeAiMcps` managed setting to load claude.ai cloud MCP connectors alongside `managed-mcp.json`
+- Fixed a PowerShell permission bypass: built-in `cd` functions (`cd..`, `cd\`, `cd~`, `X:`) changed the working directory undetected, letting a later command read outside the workspace
+- Fixed the sandbox write allowlist in git worktrees covering the entire main repository root instead of only the shared `.git` directory (with `hooks/` and `config` denied)
+- Fixed PowerShell prefix/wildcard allow rules (e.g. `PowerShell(dotnet.exe build *)`) not pre-approving native executables and scripts
+- Fixed a permission-analysis gap where the parser trusted stale variable-tracking values for `PWD`/`OLDPWD`/`DIRSTACK` across `cd`/`pushd`/`popd`
+- Fixed `find` in the Bash tool exhausting the macOS system file/vnode table and crashing the host on large directory trees
+- Fixed the managed-settings approval dialog leaving the terminal frozen after accepting at startup
+- Fixed `/ultraplan` and remote session creation failing with "Could not capture uncommitted changes" when the working tree has no real changes
+- Fixed `otelHeadersHelper` failing silently when the script path contains spaces; helper failures are now reported in `/doctor` and the debug log
+- Fixed the thinking spinner staying amber across tool calls and onto fresh thinking bursts
+- Fixed collapsed Bash output reporting the wrong hidden-line count for outputs with many short lines
+- Fixed slash-command argument-hint clipping trailing typed characters when the hint overflows the input box
+- Fixed argument-hint and progressive arg suggestions not appearing after Tab-completing a skill whose frontmatter `name:` differs from its directory basename
+- Fixed the status bar showing the user's baseline `/effort` setting instead of the effort level applied by skill/agent `effort:` frontmatter
+- Fixed Ctrl+O transcript view freezing at the moment it was opened instead of tailing new messages
+- Fixed editing a recalled prompt-history entry losing the edit when navigating further up/down with arrow keys
+- Fixed `/config` exit summary reporting phantom changes to auto-compact and theme when toggling unrelated settings
+- Fixed `/insights` crashing when cached session-meta files are missing optional fields
```

</details>

<details>
<summary>commands-ja.md</summary>

```diff
diff --git a/docs-ja/pages/commands-ja.md b/docs-ja/pages/commands-ja.md
index 38144a7..29bd6dc 100644
--- a/docs-ja/pages/commands-ja.md
+++ b/docs-ja/pages/commands-ja.md
@@ -23,5 +23,5 @@
 **並行して作業を実行する。** `/agents` は Claude が副次的なタスクを委譲できる[サブエージェント](/ja/sub-agents)のマネージャーを開き、`/tasks` は現在のセッションのバックグラウンドで実行されているものをリストします。`/background` はセッション全体をデタッチして[バックグラウンドエージェント](/ja/agent-view)として実行し続け、ターミナルを解放します。コードベース全体にまたがる大きな変更の場合、`/batch` はそれを独立したユニットに分解し、各ユニットを独自の[worktree](/ja/worktrees)で実行します。これらのアプローチがどのように関連しているかについては、[エージェントを並行して実行する](/ja/agents)を参照してください。
 
-**リリース前。** `/diff` は変更内容を表示し、`/simplify` は最近のファイルをレビューして品質と効率の修正を適用し、`/review` または `/security-review` はより深い読み取り専用パスを提供します。
+**リリース前。** `/diff` は変更内容を表示し、`/code-review` は diff の正確性のバグをチェックし、`/review` または `/security-review` はより深い読み取り専用パスを提供します。
 
 **セッション間。** `/clear` は新しいタスクで新しく開始しながらプロジェクトメモリを保持します。`/resume` と `/branch` を使用して、以前の会話に戻るか、フォークできます。`/teleport` はウェブセッションをこのターミナルに引き込み、`/remote-control` を使用してこのローカルセッションを別のデバイスから続行できます。
@@ -39,96 +39,96 @@
 </Note>
 
-| コマンド                                            | 目的                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
-| :---------------------------------------------- | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
-| `/add-dir <path>`                               | 現在のセッション中にファイルアクセス用の作業ディレクトリを追加します。ほとんどの `.claude/` 設定は追加されたディレクトリから[検出されません](/ja/permissions#additional-directories-grant-file-access-not-configuration)。後で `--continue` または `--resume` を使用して、追加されたディレクトリからセッションを再開できます                                                                                                                                                                                                                                                                                       |
-| `/agents`                                       | [エージェント](/ja/sub-agents)設定を管理します                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
-| `/autofix-pr [prompt]`                          | 現在のブランチの PR を監視し、CI が失敗するか、レビュアーがコメントを残したときに修正をプッシュする [Claude Code on the web](/ja/claude-code-on-the-web#auto-fix-pull-requests) セッションを生成します。`gh pr view` で開いている PR を検出します。別の PR を監視するには、最初にそのブランチをチェックアウトしてください。デフォルトでは、リモートセッションはすべての CI 失敗とレビューコメントを修正するよう指示されます。プロンプトを渡して異なる指示を与えることができます。例えば `/autofix-pr only fix lint and type errors`。`gh` CLI と [Claude Code on the web](/ja/claude-code-on-the-web#who-can-use-claude-code-on-the-web) へのアクセスが必要です                                                  |
-| `/batch <instruction>`                          | **[スキル](/ja/skills#bundled-skills)。** コードベース全体にわたる大規模な変更を並列で調整します。コードベースを調査し、作業を 5 ～ 30 個の独立したユニットに分解し、計画を提示します。承認されると、分離された [git worktree](/ja/worktrees) 内の各ユニットごとに 1 つのバックグラウンドサブエージェントを生成します。各サブエージェントはそのユニットを実装し、テストを実行し、プルリクエストを開きます。git リポジトリが必要です。例: `/batch migrate src/ from Solid to React`                                                                                                                                                                                                         |
-| `/branch [name]`                                | この時点で現在の会話のブランチを作成します。ブランチに切り替え、元の会話を保持します。`/resume` で戻ることができます。エイリアス: `/fork`。[`CLAUDE_CODE_FORK_SUBAGENT`](/ja/env-vars) が設定されている場合、`/fork` は代わりに[フォークされたサブエージェント](/ja/sub-agents#fork-the-current-conversation)を生成し、このコマンドのエイリアスではなくなります                                                                                                                                                                                                                                                                    |
-| `/btw <question>`                               | 会話に追加せずに[サイドクエスチョン](/ja/interactive-mode#side-questions-with-%2Fbtw)として素早く質問します                                                                                                                                                                                                                                                                                                                                                                                                                                |
-| `/chrome`                                       | [Chrome の Claude](/ja/chrome) 設定を構成します                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
-| `/claude-api [migrate\|managed-agents-onboard]` | **[スキル](/ja/skills#bundled-skills)。** プロジェクトの言語（Python、TypeScript、Java、Go、Ruby、C#、PHP、または cURL）と Managed Agents リファレンス用の Claude API リファレンス資料を読み込みます。ツール使用、ストリーミング、バッチ、構造化出力、および一般的な落とし穴をカバーしています。また、コードが `anthropic` または `@anthropic-ai/sdk` をインポートするときに自動的にアクティブになります。`/claude-api migrate` を実行して、既存の Claude API コードを新しいモデルにアップグレードします。Claude はスキャンするファイルとターゲットモデルを尋ね、モデル ID、思考設定、およびバージョン間で変更されたその他のパラメータを更新します。`/claude-api managed-agents-onboard` を実行して、新しい Managed Agent をゼロから作成するインタラクティブなウォークスルーを実施します |
-| `/clear [name]`                                 | 空のコンテキストで新しい会話を開始します。前の会話は `/resume` で利用可能なままです。前の会話にラベルを付けるために名前を渡します。`/resume` ピッカーで。同じ会話を続けながらコンテキストを解放するには、代わりに `/compact` を使用してください。エイリアス: `/reset`、`/new`                                                                                                                                                                                                                                                                                                                                                |
-| `/color [color\|default]`                       | 現在のセッションのプロンプトバーの色を設定します。利用可能な色: `red`、`blue`、`green`、`yellow`、`purple`、`orange`、`pink`、`cyan`。`default` を使用してリセットするか、引数なしで実行するとランダムな色を選択します。[リモートコントロール](/ja/remote-control)が接続されている場合、色は claude.ai/code に同期されます                                                                                                                                                                                                                                                                                              |
-| `/compact [instructions]`                       | 会話をここまで要約してコンテキストを解放します。オプションで要約のフォーカス指示を渡します。[コンパクション時にルール、スキル、メモリファイルがどのように処理されるか](/ja/context-window#what-survives-compaction)を参照してください                                                                                                                                                                                                                                                                                                                                                                     |
-| `/config`                                       | [設定](/ja/settings)インターフェースを開いて、テーマ、モデル、[出力スタイル](/ja/output-styles)、およびその他の設定を調整します。エイリアス: `/settings`                                                                                                                                                                                                                                                                                                                                                                                                          |
-| `/context [all]`                                | 現在のコンテキスト使用状況をカラーグリッドとして視覚化します。コンテキストが多いツール、メモリ肥大化、容量警告の最適化提案を表示します。[フルスクリーンモード](/ja/fullscreen)では、項目ごとの内訳はグリッドを表示したままにするために折りたたまれます。`all` を渡して展開します                                                                                                                                                                                                                                                                                                                                                           |
-| `/copy [N]`                                     | 最後のアシスタント応答をクリップボードにコピーします。数字 `N` を渡して N 番目に新しい応答をコピーします。`/copy 2` は 2 番目に新しい応答をコピーします。コードブロックが存在する場合、個別ブロックまたは完全な応答を選択するインタラクティブピッカーを表示します。ピッカーで `w` を押して、クリップボードの代わりにファイルに選択内容を書き込みます。SSH 経由で便利です                                                                                                                                                                                                                                                                                                            |
```

</details>

<details>
<summary>env-vars-ja.md</summary>

```diff
diff --git a/docs-ja/pages/env-vars-ja.md b/docs-ja/pages/env-vars-ja.md
index ecd7046..c8ddfea 100644
--- a/docs-ja/pages/env-vars-ja.md
+++ b/docs-ja/pages/env-vars-ja.md
@@ -309,5 +309,5 @@ Claude Code は起動時に環境変数を読み取るため、変更は `claude
 | `MCP_SERVER_CONNECTION_BATCH_SIZE`                      | スタートアップ中に並列接続するローカル MCP サーバー（stdio）の最大数（デフォルト：3）                                                                                                                                                                                                                                                                                                                                                                               |
 | `MCP_TIMEOUT`                                           | MCP サーバー起動のタイムアウト（ミリ秒）（デフォルト：30000、または 30 秒）                                                                                                                                                                                                                                                                                                                                                                                   |
-| `MCP_TOOL_TIMEOUT`                                      | MCP ツール実行のタイムアウト（ミリ秒）（デフォルト：100000000、約 28 時間）                                                                                                                                                                                                                                                                                                                                                                                 |
+| `MCP_TOOL_TIMEOUT`                                      | MCP ツール実行のタイムアウト（ミリ秒）（デフォルト：100000000、約 28 時間）。`.mcp.json` のサーバーごとの `timeout` フィールドはそのサーバーのこれをオーバーライドします。1000 未満の値は 1 秒にフロアされます                                                                                                                                                                                                                                                                                                |
 | `NO_PROXY`                                              | リクエストが直接発行されるドメインと IP のリスト。プロキシをバイパスします                                                                                                                                                                                                                                                                                                                                                                                        |
 | `OTEL_LOG_RAW_API_BODIES`                               | Anthropic Messages API リクエストとレスポンス JSON を `api_request_body` / `api_response_body` ログイベントとして出力します。60 KB で切り詰められたインラインボディの場合は `1` に設定するか、切り詰められていないボディをディスクに書き込み、`body_ref` パスを出力する場合は `file:<dir>` に設定します。デフォルトでは無効です。ボディには会話履歴全体が含まれます。[監視](/ja/monitoring-usage#api-request-body-event) を参照してください                                                                                                                            |
```

</details>

<details>
<summary>errors-ja.md</summary>

```diff
diff --git a/docs-ja/pages/errors-ja.md b/docs-ja/pages/errors-ja.md
index 25db665..843f4b0 100644
--- a/docs-ja/pages/errors-ja.md
+++ b/docs-ja/pages/errors-ja.md
@@ -45,4 +45,5 @@
 | `Request too large`                                                                           | [リクエストエラー](#request-too-large)                                                                |
 | `Image was too large`                                                                         | [リクエストエラー](#image-was-too-large)                                                              |
+| `Unable to resize image`                                                                      | [リクエストエラー](#unable-to-resize-image)                                                           |
 | `PDF too large` / `PDF is password protected`                                                 | [リクエストエラー](#pdf-errors)                                                                       |
 | `Extra inputs are not permitted`                                                              | [リクエストエラー](#extra-inputs-are-not-permitted)                                                   |
@@ -488,4 +489,22 @@ API Error: 400 ... image dimensions exceed max allowed size
 * 全画面ではなく、関連する領域のより厳密なスクリーンショットを撮ってください
 
+### Unable to resize image
+
+Claude Code は、API に送信する前に添付された画像をダウンスケールできませんでした。
+
+```text theme={null}
+Unable to resize image — image processing is unavailable and dimensions could not be read from the file header. Please convert the image to PNG, JPEG, GIF, or WebP.
+Unable to resize image — dimensions exceed the 2000x2000px limit and image processing failed. Please resize the image to reduce its pixel dimensions.
+Unable to resize image (… raw, … base64). The image exceeds the … API limit and compression failed. Please resize the image manually or use a smaller image.
+Unable to resize image — could not verify image dimensions are within the 2000x2000px API limit.
+```
+
+Claude Code は通常、大きな画像を自動的にリサイズします。これらのエラーは、ネイティブ画像プロセッサーがロードに失敗したか、エラーを返したため、画像を API 制限内に収まるようにリサイズできなかったことを意味します。
+
+**対応方法：**
+
+* メッセージが画像の変換を求めている場合は、PNG、JPEG、GIF、または WebP に変換して、再度添付してください。Claude Code はこれらの形式の寸法を画像プロセッサーなしで検証できます。
+* メッセージが寸法またはサイズ制限を報告している場合は、その制限以下に画像をリサイズまたは再圧縮してから添付してください。
```

</details>

<details>
<summary>features-overview-ja.md</summary>

```diff
diff --git a/docs-ja/pages/features-overview-ja.md b/docs-ja/pages/features-overview-ja.md
index 8e42a08..85ae42e 100644
--- a/docs-ja/pages/features-overview-ja.md
+++ b/docs-ja/pages/features-overview-ja.md
@@ -244,5 +244,5 @@ Claude Code は、コードについて推論するモデルと、ファイル
 
   <Tab title="Skills">
-    スキルは Claude のツールキットの追加機能です。リファレンスマテリアル（API スタイルガイドなど）または `/<name>` でトリガーする呼び出し可能なワークフロー（`/deploy` など）です。Claude Code は `/simplify`、`/batch`、`/debug` などの[バンドルされたスキル](/ja/commands) を備えており、すぐに機能します。独自のスキルを作成することもできます。Claude は適切な場合にスキルを使用するか、直接呼び出すことができます。
+    スキルは Claude のツールキットの追加機能です。リファレンスマテリアル（API スタイルガイドなど）または `/<name>` でトリガーする呼び出し可能なワークフロー（`/deploy` など）です。Claude Code は `/code-review`、`/batch`、`/debug` などの[バンドルされたスキル](/ja/commands) を備えており、すぐに機能します。独自のスキルを作成することもできます。Claude は適切な場合にスキルを使用するか、直接呼び出すことができます。
 
     **時期：** スキルの設定によって異なります。デフォルトでは、説明はセッション開始時にロードされ、完全なコンテンツは使用時にロードされます。ユーザーのみのスキル（`disable-model-invocation: true`）の場合、呼び出すまで何もロードされません。
```

</details>

<details>
<summary>glossary-ja.md</summary>

```diff
diff --git a/docs-ja/pages/glossary-ja.md b/docs-ja/pages/glossary-ja.md
index 6bb76d8..af1005e 100644
--- a/docs-ja/pages/glossary-ja.md
+++ b/docs-ja/pages/glossary-ja.md
@@ -57,5 +57,5 @@ Claude が自分自身のために書いたメモ。あなたの修正と設定
 ### Bundled skills
 
-Claude Code に含まれるプロンプトベースのプレイブック。`/batch`、`/simplify`、`/debug`、`/loop` など。固定ロジックを実行する組み込みコマンドとは異なり、bundled skills は Claude に詳細なプロンプトを与え、作業をオーケストレーションさせるため、エージェントを生成し、ファイルを読み取り、コードベースに適応できます。
+Claude Code に含まれるプロンプトベースのプレイブック。`/batch`、`/code-review`、`/debug`、`/loop` など。固定ロジックを実行する組み込みコマンドとは異なり、bundled skills は Claude に詳細なプロンプトを与え、作業をオーケストレーションさせるため、エージェントを生成し、ファイルを読み取り、コードベースに適応できます。
 
 詳細情報: [Bundled skills](/ja/skills#bundled-skills)
```

</details>

<details>
<summary>interactive-mode-ja.md</summary>

```diff
diff --git a/docs-ja/pages/interactive-mode-ja.md b/docs-ja/pages/interactive-mode-ja.md
index 7905e12..b70d474 100644
--- a/docs-ja/pages/interactive-mode-ja.md
+++ b/docs-ja/pages/interactive-mode-ja.md
@@ -215,4 +215,5 @@ Claude Code は現在のセッションのコマンド履歴を保持します
 * 入力履歴は作業ディレクトリごとに保存されます
 * `/clear` を実行して新しいセッションを開始すると、入力履歴がリセットされます。前のセッションの会話は保持され、再開できます。
+* 同じプロンプトを 2 回連続で送信すると、1 つの履歴エントリが記録されるため、Up キーを押すと前の異なるプロンプトにステップします
 * Up/Down 矢印を使用して移動します（上記のキーボードショートカットを参照）
 * **注記**: 履歴展開（`!`）はデフォルトで無効です
```

</details>

*...以降省略*

</details>


<details>
<summary>2026-05-22</summary>

**変更ファイル:**

```
 docs-ja/pages/admin-setup-ja.md             |  27 +-
 docs-ja/pages/auto-mode-config-ja.md        |   2 +-
 docs-ja/pages/changelog.md                  |  36 +++
 docs-ja/pages/desktop-ja.md                 |   2 +-
 docs-ja/pages/devcontainer-ja.md            |   1 +
 docs-ja/pages/errors-ja.md                  |  23 +-
 docs-ja/pages/glossary-ja.md                |   2 +-
 docs-ja/pages/hooks-guide-ja.md             |   6 +-
 docs-ja/pages/hooks-ja.md                   |  60 +++--
 docs-ja/pages/mcp-ja.md                     | 228 +----------------
 docs-ja/pages/permission-modes-ja.md        |   4 +-
 docs-ja/pages/permissions-ja.md             |  29 +--
 docs-ja/pages/sandboxing-ja.md              | 376 ++++++++++++++++------------
 docs-ja/pages/scheduled-tasks-ja.md         |   4 +-
 docs-ja/pages/security-ja.md                |  11 +-
 docs-ja/pages/server-managed-settings-ja.md |   2 +-
 docs-ja/pages/settings-ja.md                |  36 ++-
 17 files changed, 379 insertions(+), 470 deletions(-)
```

**新規追加:**


<details>
<summary>admin-setup-ja.md</summary>

```diff
diff --git a/docs-ja/pages/admin-setup-ja.md b/docs-ja/pages/admin-setup-ja.md
index 463883e..0c9936a 100644
--- a/docs-ja/pages/admin-setup-ja.md
+++ b/docs-ja/pages/admin-setup-ja.md
@@ -66,17 +66,18 @@ plist と HKLM レジストリの場所は任意のプロバイダーで機能
 ## 実行する内容を決定する
 
-マネージド設定は、ツール、サンドボックス実行、MCP サーバーとプラグインソースへのアクセスをロックダウンし、実行されるフック を制御できます。各行は、それを駆動する設定キーを持つ制御サーフェスです。
-
-| 制御                                                                                     | 機能                                                              | キー設定                                                                         |
-| :------------------------------------------------------------------------------------- | :-------------------------------------------------------------- | :--------------------------------------------------------------------------- |
-| [Permission rules](/ja/permissions)                                                    | 特定のツールとコマンドを許可、確認、または拒否する                                       | `permissions.allow`、`permissions.deny`                                       |
-| [Permission lockdown](/ja/permissions#managed-only-settings)                           | マネージドパーミッションルールのみが適用される。`--dangerously-skip-permissions` を無効化する | `allowManagedPermissionRulesOnly`、`permissions.disableBypassPermissionsMode` |
-| [Sandboxing](/ja/sandboxing)                                                           | ドメイン許可リスト付きの OS レベルのファイルシステムとネットワーク分離                           | `sandbox.enabled`、`sandbox.network.allowedDomains`                           |
-| [Managed policy CLAUDE.md](/ja/memory#deploy-organization-wide-claude-md)              | すべてのセッションで読み込まれる組織全体の指示。除外できない                                  | マネージドポリシーパスのファイル                                                             |
-| [MCP server control](/ja/mcp#managed-mcp-configuration)                                | ユーザーが追加または接続できる MCP サーバーを制限する                                   | `allowedMcpServers`、`deniedMcpServers`、`allowManagedMcpServersOnly`          |
-| [Plugin marketplace control](/ja/plugin-marketplaces#managed-marketplace-restrictions) | ユーザーが追加およびインストールできるマーケットプレイスソースを制限する                            | `strictKnownMarketplaces`、`blockedMarketplaces`                              |
-| [Hook restrictions](/ja/settings#hook-configuration)                                   | マネージドフックのみが読み込まれる。HTTP フック URL を制限する                            | `allowManagedHooksOnly`、`allowedHttpHookUrls`                                |
-| [Disable agent view](/ja/agent-view#how-background-sessions-are-hosted)                | `claude agents`、`--bg`、`/background`、およびオンデマンドスーパーバイザーをオフにする    | `disableAgentView`                                                           |
-| [Version floor](/ja/settings)                                                          | 自動更新が組織全体の最小値より下にインストールされるのを防ぐ                                  | `minimumVersion`                                                             |
+マネージド設定は、ツール、サンドボックス実行、MCP サーバーとプラグインソースへのアクセスをロックダウンし、実行されるフックを制御できます。各行は、それを駆動する設定キーを持つ制御サーフェスです。
+
+| 制御                                                                                     | 機能                                                                                | キー設定                                                                                                   |
+| :------------------------------------------------------------------------------------- | :-------------------------------------------------------------------------------- | :----------------------------------------------------------------------------------------------------- |
+| [Permission rules](/ja/permissions)                                                    | 特定のツールとコマンドを許可、確認、または拒否する                                                         | `permissions.allow`、`permissions.deny`                                                                 |
+| [Permission lockdown](/ja/permissions#managed-only-settings)                           | マネージドパーミッションルールのみが適用される。`--dangerously-skip-permissions` を無効化する                   | `allowManagedPermissionRulesOnly`、`permissions.disableBypassPermissionsMode`                           |
+| [Sandboxing](/ja/sandboxing)                                                           | ドメイン許可リスト付きの OS レベルのファイルシステムとネットワーク分離                                             | `sandbox.enabled`、`sandbox.network.allowedDomains`                                                     |
+| [Managed policy CLAUDE.md](/ja/memory#deploy-organization-wide-claude-md)              | すべてのセッションで読み込まれる組織全体の指示。除外できない                                                    | マネージドポリシーパスのファイル                                                                                       |
+| [MCP server control](/ja/managed-mcp)                                                  | ユーザーが追加または接続できる MCP サーバーを制限するか、固定セットをデプロイする                                       | `allowedMcpServers`、`deniedMcpServers`、`allowManagedMcpServersOnly`、またはデプロイされた `managed-mcp.json` ファイル |
+| [Plugin marketplace control](/ja/plugin-marketplaces#managed-marketplace-restrictions) | ユーザーが追加およびインストールできるマーケットプレイスソースを制限する                                              | `strictKnownMarketplaces`、`blockedMarketplaces`                                                        |
```

</details>

<details>
<summary>auto-mode-config-ja.md</summary>

```diff
diff --git a/docs-ja/pages/auto-mode-config-ja.md b/docs-ja/pages/auto-mode-config-ja.md
index 88d9241..5dd6a62 100644
--- a/docs-ja/pages/auto-mode-config-ja.md
+++ b/docs-ja/pages/auto-mode-config-ja.md
@@ -10,5 +10,5 @@
 
 <Note>
-  オートモードは、Anthropic API を通じて Max、Team、Enterprise、API プランで利用可能です。Pro プランでは利用できず、Bedrock、Vertex、Foundry でも利用できません。Claude Code がアカウントでオートモードが利用不可と報告する場合は、[完全な要件](/ja/permission-modes#eliminate-prompts-with-auto-mode)を確認してください。これには、サポートされているモデルと Team および Enterprise プランの管理者有効化も含まれます。
+  オートモードは、Anthropic API を通じてすべてのユーザーが利用できます。Bedrock、Vertex、Foundry では利用できません。Claude Code がアカウントでオートモードが利用不可と報告する場合は、[完全な要件](/ja/permission-modes#eliminate-prompts-with-auto-mode)を確認してください。これには、サポートされているモデルと Team および Enterprise プランの管理者有効化も含まれます。
 </Note>
 
```

</details>

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index f476a24..7c01af0 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,40 @@
 # Changelog
 
+## 2.1.147
+
+- Pinned background sessions (`Ctrl+T` in `claude agents`) now stay alive when idle, are restarted in place to apply Claude Code updates, and are shed under memory pressure only after non-pinned sessions
+- Renamed `/simplify` to `/code-review`. It now reports correctness bugs at a chosen effort level (e.g., `/code-review high`); pass `--comment` to post findings as inline GitHub PR comments. The old cleanup-and-fix behavior has been removed
+- Improved auto-updater: retries transient network failures, reports specific error categories and OS error codes on failure, and shows the current version when an update fails
+- Improved diff rendering performance for large file edits
+- Prompt history no longer records consecutive duplicate entries — recalling a prompt with arrow-up and submitting it again won't add another copy
+- Fixed enterprise login restrictions (`forceLoginOrgUUID` and `forceLoginMethod` managed-settings) not being enforced against third-party-provider and API-key sessions
+- Fixed `&` in `!` command output displaying as `&amp;`, which broke copy-pasting URLs from commands like `gcloud auth login` on headless machines
+- Fixed unknown slash commands silently doing nothing in headless/SDK mode — they now show an error message
+- Fixed `/help` rendering a broken tab header and showing only one command per page on small terminals when not in fullscreen mode
+- Fixed shell snapshot dropping user functions whose names start with a single underscore, which broke aliases referencing them
+- Fixed plugin agents that declare multiple `Agent(...)` types in `tools:` frontmatter dropping all but the last entry
+- Fixed hook `if` conditions like `PowerShell(git push*)` never matching — only `PowerShell(*)` worked
+- Fixed PowerShell tool dropping output for commands that rely on the default formatter
+- Fixed: on Windows, "Yes, and don't ask again" for a PowerShell script invocation now writes a rule that actually matches on subsequent runs
+- Fixed PowerShell tool failing on Windows with exit code 1 when `pwsh` is installed via winget or the Microsoft Store
+- Fixed `/effort` opening with the slider on the wrong level — it now starts at your current effort
+- Fixed paginating MCP servers dropping resources, templates, and prompts past page 1
+- Fixed full-screen strobing in attached background sessions on Windows Terminal while Claude is streaming
+- Fixed: on Windows, removing a background-job worktree no longer follows NTFS junctions into the main repo
+- Fixed `/background` refusing sessions whose only typed input was a skill or custom slash command
+- Fixed auto mode suppressing `AskUserQuestion` when the user or a skill explicitly relies on it; the auto-mode classifier now sees the user's answers as intent signal
```

</details>

<details>
<summary>desktop-ja.md</summary>

```diff
diff --git a/docs-ja/pages/desktop-ja.md b/docs-ja/pages/desktop-ja.md
index 6e08268..e605625 100644
--- a/docs-ja/pages/desktop-ja.md
+++ b/docs-ja/pages/desktop-ja.md
@@ -79,5 +79,5 @@ Claude に実行させたいことを入力して**Enter**キーを押して送
 <span id="auto-mode-availability" />
 
-Auto mode は Max、Team、Enterprise、および API プランで利用可能な研究プレビューです。Pro プランまたはサードパーティプロバイダーでは利用できません。Team、Enterprise、および API プランでは Claude Sonnet 4.6、Opus 4.6、または Opus 4.7 が必要です。Max プランでは Claude Opus 4.7 が必要です。
+Auto mode は Anthropic API のすべてのユーザーが利用できる研究プレビューです。サードパーティプロバイダーでは利用できません。Claude Sonnet 4.6、Opus 4.6、または Opus 4.7 が必要です。
 
 <Tip title="ベストプラクティス">
```

</details>

<details>
<summary>devcontainer-ja.md</summary>

```diff
diff --git a/docs-ja/pages/devcontainer-ja.md b/docs-ja/pages/devcontainer-ja.md
index bbeeb37..2f9c6e5 100644
--- a/docs-ja/pages/devcontainer-ja.md
+++ b/docs-ja/pages/devcontainer-ja.md
@@ -191,4 +191,5 @@ Claude Code が開発コンテナで実行されたら、以下のページは
 * [テレメトリサービスとオプトアウト](/ja/data-usage#telemetry-services)：Claude Code がデフォルトで送信するもの、およびそれを無効にする環境変数
 * [`.claude` ディレクトリを探索する](/ja/claude-directory)：ボリュームマウントが保持するもの（認証情報、設定、セッション履歴を含む）
+* [サンドボックス環境](/ja/sandbox-environments)：開発コンテナと組み込み Bash サンドボックス、カスタムコンテナ、VM を比較します
 * [セキュリティモデル](/ja/security)：Claude Code の権限システム、サンドボックス、プロンプトインジェクション保護がどのように組み合わさるか
 * [権限モード](/ja/permission-modes)：プランモードから自動モードからバイパスまでの完全な範囲、および各モードを使用する場合
```

</details>

<details>
<summary>errors-ja.md</summary>

```diff
diff --git a/docs-ja/pages/errors-ja.md b/docs-ja/pages/errors-ja.md
index ba9250c..25db665 100644
--- a/docs-ja/pages/errors-ja.md
+++ b/docs-ja/pages/errors-ja.md
@@ -21,5 +21,5 @@
 | メッセージ                                                                                         | セクション                                                                                         |
 | :-------------------------------------------------------------------------------------------- | :-------------------------------------------------------------------------------------------- |
-| `API Error: 500 ... Internal server error`                                                    | [サーバーエラー](#api-error-500-internal-server-error)                                               |
+| `API Error: 500 Internal server error`                                                        | [サーバーエラー](#api-error-500-internal-server-error)                                               |
 | `API Error: Repeated 529 Overloaded errors`                                                   | [サーバーエラー](#api-error-repeated-529-overloaded-errors)                                          |
 | `Request timed out`                                                                           | [サーバーエラー](#request-timed-out)、またはメッセージがインターネット接続に言及している場合は[ネットワーク](#unable-to-connect-to-api) |
@@ -34,4 +34,5 @@
 | `Invalid API key`                                                                             | [認証](#invalid-api-key)                                                                        |
 | `This organization has been disabled`                                                         | [認証](#this-organization-has-been-disabled)                                                    |
+| `Your organization has disabled Claude subscription access`                                   | [認証](#your-organization-has-disabled-claude-subscription-access)                              |
 | `Routines are disabled by your organization's policy`                                         | [認証](#routines-are-disabled-by-your-organizations-policy)                                     |
 | `OAuth token revoked` / `OAuth token has expired`                                             | [認証](#oauth-token-revoked-or-expired)                                                         |
@@ -67,19 +68,21 @@ Claude Code は、エラーを表示する前に一時的な障害をリトラ
 ## サーバーエラー
 
-これらのエラーは、アカウントまたはリクエストではなく、Anthropic インフラストラクチャから発生します。
+これらのエラーは、アカウントまたはリクエストではなく、推論プロバイダーから発生します。Anthropic API では Anthropic インフラストラクチャを意味します。Bedrock、Vertex AI、Foundry、またはカスタムゲートウェイでは、そのプロバイダーのインフラストラクチャを意味します。
 
 ### API Error: 500 Internal server error
 
-Claude Code は、5xx ステータスの生の API レスポンスボディを表示します。以下の例は 500 レスポンスを示しています。
+Claude Code は、5xx レスポンスに対してステータスコードと API のエラーメッセージを表示します。以下の例は Anthropic API での 500 レスポンスを示しています：
 
 ```text theme={null}
-API Error: 500 {"type":"error","error":{"type":"api_error","message":"Internal server error"}} · check status.claude.com
```

</details>

<details>
<summary>glossary-ja.md</summary>

```diff
diff --git a/docs-ja/pages/glossary-ja.md b/docs-ja/pages/glossary-ja.md
index 40d7b70..6bb76d8 100644
--- a/docs-ja/pages/glossary-ja.md
+++ b/docs-ja/pages/glossary-ja.md
@@ -43,5 +43,5 @@ Claude が自分自身のために書いたメモ。あなたの修正と設定
 ### Auto mode
 
-[permission mode](#permission-mode) の一種。承認プロンプトを表示する代わりに、別の分類器モデルがバックグラウンドで各アクションをレビューします。分類器はスコープエスカレーション、信頼されていないインフラストラクチャ、および [prompt injection](#prompt-injection) をブロックします。ツール結果を見ることはないため、注入された指示がその決定に影響を与えることはできません。Auto mode は Max、Team、Enterprise、API プランで利用可能な研究プレビューです。
+[permission mode](#permission-mode) の一種。承認プロンプトを表示する代わりに、別の分類器モデルがバックグラウンドで各アクションをレビューします。分類器はスコープエスカレーション、信頼されていないインフラストラクチャ、および [prompt injection](#prompt-injection) をブロックします。ツール結果を見ることはないため、注入された指示がその決定に影響を与えることはできません。Auto mode は Anthropic API のすべてのユーザーが利用可能な研究プレビューです。
 
 詳細情報: [Eliminate prompts with auto mode](/ja/permission-modes#eliminate-prompts-with-auto-mode)
```

</details>

<details>
<summary>hooks-guide-ja.md</summary>

```diff
diff --git a/docs-ja/pages/hooks-guide-ja.md b/docs-ja/pages/hooks-guide-ja.md
index d954ddd..eef1196 100644
--- a/docs-ja/pages/hooks-guide-ja.md
+++ b/docs-ja/pages/hooks-guide-ja.md
@@ -546,10 +546,10 @@ if echo "$COMMAND" | grep -q "drop table"; then
 fi
 
-exit 0  # exit 0 = 続行させる
+exit 0  # exit 0 = 決定なし。通常の許可フローが適用されます
 ```
 
 終了コードは次に何が起こるかを決定します：
 
-* **終了 0**：アクションが続行されます。`UserPromptSubmit`、`UserPromptExpansion`、および `SessionStart` hooks の場合、stdout に書き込むすべてのものが Claude のコンテキストに追加されます。
+* **終了 0**：hook は異議を報告せず、アクションは通常どおり進行します。`PreToolUse` hook の場合、これはツール呼び出しを承認しません：通常の [許可フロー](/ja/permissions) が引き続き適用されます。`UserPromptSubmit`、`UserPromptExpansion`、および `SessionStart` hooks の場合、stdout に書き込むすべてのものが Claude のコンテキストに追加されます。
 * **終了 2**：アクションがブロックされます。stderr に理由を書き込み、Claude はそれをフィードバックとして受け取るため、調整できます。一部のイベントはブロックできません：`SessionStart`、`Setup`、`Notification` などの場合、終了 2 は stderr をユーザーに表示し、実行は続行されます。[イベントごとの終了コード 2 の動作](/ja/hooks#exit-code-2-behavior-per-event) で完全なリストを参照してください。
 * **その他の終了コード**：アクションが続行されます。トランスクリプトは `<hook name> hook error` 通知を表示し、その後 stderr の最初の行が続きます。完全な stderr は [デバッグログ](/ja/hooks#debug-hooks) に記録されます。
@@ -557,5 +557,5 @@ exit 0  # exit 0 = 続行させる
 #### 構造化 JSON 出力
 
-終了コードは 2 つのオプションを提供します：許可またはブロック。より多くの制御のために、終了 0 して stdout に JSON オブジェクトを出力します。
+終了コードはブロックするか沈黙するかのみを許可します。より多くの制御のために、終了 0 して stdout に JSON オブジェクトを出力します。
 
 <Note>
```

</details>

<details>
<summary>hooks-ja.md</summary>

```diff
diff --git a/docs-ja/pages/hooks-ja.md b/docs-ja/pages/hooks-ja.md
index fd66b90..87e96a6 100644
--- a/docs-ja/pages/hooks-ja.md
+++ b/docs-ja/pages/hooks-ja.md
@@ -97,5 +97,5 @@ if echo "$COMMAND" | grep -q 'rm -rf'; then
   }'
 else
-  exit 0  # allow the command
+  exit 0  # no decision; normal permission flow applies
 fi
 ```
@@ -137,5 +137,5 @@ fi
     ```
 
-    コマンドが安全だった場合（`rm file.txt` など）、スクリプトは代わりに `exit 0` に到達し、これは Claude Code にツール呼び出しを許可するよう指示します。
+    コマンドが安全な `rm` バリアント（`rm file.txt` など）だった場合、スクリプトは代わりに `exit 0` に到達します。出力なしの終了コード 0 は、フックが報告する決定がないことを意味するため、ツール呼び出しは通常の[権限フロー](/ja/permissions)を通じて続行されます。フックは呼び出しを拒否できますが、沈黙を保つことは承認を意味しません。
   </Step>
 
@@ -733,6 +733,6 @@ Claude を完全に停止するには、イベント タイプに関係なく。
 input=$(cat)
 title="Claude Code'
-body=$(jq -r '.message // 'Needs your attention'' <<<'$input')
-seq=$(printf '\033]777;notify;%s;%s\007' '$title" "$body")
+body=$(jq -r '.message // "Needs your attention"' <<<"$input")
+seq=$(printf '\033]777;notify;%s;%s\007' "$title" "$body")
 jq -nc --arg seq "$seq" '{terminalSequence: $seq}'
 ```
@@ -783,15 +783,16 @@ Claude が現在の環境の状態または実行されたばかりの操作に
 すべてのイベントが JSON を通じたブロッキングまたは動作制御をサポートしているわけではありません。サポートするイベントは、その決定を表現するために異なるフィールド セットを使用します。フックを書く前に、このテーブルをクイック リファレンスとして使用してください。
 
```

</details>

*...以降省略*

</details>


<details>
<summary>2026-05-21</summary>

**変更ファイル:**

```
 docs-ja/pages/agent-view-ja.md            |  3 ++
 docs-ja/pages/checkpointing-ja.md         |  8 ++-
 docs-ja/pages/cli-reference-ja.md         | 56 ++++++++++----------
 docs-ja/pages/commands-ja.md              |  7 ++-
 docs-ja/pages/desktop-ja.md               |  4 +-
 docs-ja/pages/desktop-quickstart-ja.md    | 14 ++---
 docs-ja/pages/discover-plugins-ja.md      |  8 ++-
 docs-ja/pages/env-vars-ja.md              |  2 +-
 docs-ja/pages/fullscreen-ja.md            |  3 +-
 docs-ja/pages/hooks-ja.md                 | 58 +++++++++++++++++++--
 docs-ja/pages/how-claude-code-works-ja.md |  5 +-
 docs-ja/pages/interactive-mode-ja.md      | 11 ++--
 docs-ja/pages/monitoring-usage-ja.md      | 20 ++++----
 docs-ja/pages/output-styles-ja.md         |  8 +--
 docs-ja/pages/permission-modes-ja.md      |  2 +-
 docs-ja/pages/plugin-marketplaces-ja.md   | 22 ++++----
 docs-ja/pages/plugins-reference-ja.md     | 14 +++++
 docs-ja/pages/scheduled-tasks-ja.md       |  6 ++-
 docs-ja/pages/skills-ja.md                | 20 +++++++-
 docs-ja/pages/statusline-ja.md            | 19 ++++++-
 docs-ja/pages/tools-reference-ja.md       | 85 ++++++++++++++++---------------
 21 files changed, 249 insertions(+), 126 deletions(-)
```

**新規追加:**


<details>
<summary>agent-view-ja.md</summary>

```diff
diff --git a/docs-ja/pages/agent-view-ja.md b/docs-ja/pages/agent-view-ja.md
index a47438b..927081d 100644
--- a/docs-ja/pages/agent-view-ja.md
+++ b/docs-ja/pages/agent-view-ja.md
@@ -126,4 +126,6 @@ Completed
 行の右端に表示される `●` は [プルリクエストステータス](#pull-request-status) インジケーターであり、状態アイコンの一部ではありません。その前の数字はセッションが開いたプルリクエストの数です。
 
+ターミナルタブのタイトルは、エージェントビューが開いている間、待機中の入力カウントを表示します。セッションが入力を必要とする場合は `2 awaiting input · claude agents`、そうでない場合は `claude agents` です。
+
 バックグラウンドセッションは作業を続けるためにターミナルを開く必要がありません。別の [スーパーバイザープロセス](#the-supervisor-process) がセッションを実行するため、エージェントビューを閉じたり、シェルを閉じたり、新しいインタラクティブセッションを開始したりしても、ディスパッチされた作業は続きます。
 
@@ -399,4 +401,5 @@ claude agents --settings ./ci-settings.json --add-dir ../shared-lib
 | `claude agents`              | エージェントビューを開く                                                                                                                                                                                          |
 | `claude agents --cwd <path>` | `<path>` の下で開始されたセッションにスコープされたエージェントビューを開く                                                                                                                                                            |
+| `claude agents --json`       | ライブセッションを JSON 配列として出力して終了します。各エントリには `pid`、`cwd`、`kind`、`startedAt` が含まれ、設定されている場合は `sessionId`、`name`、`status` も含まれます。`--cwd <path>` と組み合わせてフィルタリングします                                              |
 | `claude attach <id>`         | このターミナルでセッションにアタッチする                                                                                                                                                                                  |
 | `claude logs <id>`           | セッションの最新出力を出力する                                                                                                                                                                                       |
```

</details>

<details>
<summary>checkpointing-ja.md</summary>

```diff
diff --git a/docs-ja/pages/checkpointing-ja.md b/docs-ja/pages/checkpointing-ja.md
index 5fca0e3..5f25f1f 100644
--- a/docs-ja/pages/checkpointing-ja.md
+++ b/docs-ja/pages/checkpointing-ja.md
@@ -23,5 +23,11 @@ Claude Code は、ファイル編集ツールで行われたすべての変更
 ### 巻き戻しと要約
 
-`Esc` キーを 2 回（`Esc` + `Esc`）押すか、`/rewind` コマンドを使用して巻き戻しメニューを開きます。スクロール可能なリストにセッションからの各プロンプトが表示されます。操作したいポイントを選択してから、アクションを選択します。
+`/rewind` を実行するか、プロンプト入力が空の状態で `Esc` キーを 2 回押して、巻き戻しメニューを開きます。
+
+<Note>
+  プロンプト入力にテキストが含まれている場合、ダブル `Esc` はメニューを開く代わりにテキストをクリアします。クリアされたテキストは入力履歴に保存されるため、巻き戻しメニューを終了した後に `Up` キーを押して呼び出すことができます。
+</Note>
+
+巻き戻しメニューには、セッション中に送信した各プロンプトが表示されます。操作したいポイントを選択してから、アクションを選択します。
 
 * **コードと会話を復元**: コードと会話の両方をそのポイントに戻します
```

</details>

<details>
<summary>cli-reference-ja.md</summary>

```diff
diff --git a/docs-ja/pages/cli-reference-ja.md b/docs-ja/pages/cli-reference-ja.md
index 7f876e7..14ddc5f 100644
--- a/docs-ja/pages/cli-reference-ja.md
+++ b/docs-ja/pages/cli-reference-ja.md
@@ -11,32 +11,32 @@
 これらのコマンドを使用して、セッションを開始し、コンテンツをパイプし、会話を再開し、更新を管理できます。
 
-| コマンド                            | 説明                                                                                                                                                                                                                                                                                                                                                                  | 例                                                           |
-| :------------------------------ | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | :---------------------------------------------------------- |
-| `claude`                        | インタラクティブセッションを開始                                                                                                                                                                                                                                                                                                                                                    | `claude`                                                    |
-| `claude "query"`                | 初期プロンプト付きでインタラクティブセッションを開始                                                                                                                                                                                                                                                                                                                                          | `claude "explain this project"`                             |
-| `claude -p "query"`             | SDK 経由でクエリを実行してから終了                                                                                                                                                                                                                                                                                                                                                 | `claude -p "explain this function"`                         |
-| `cat file \| claude -p "query"` | パイプされたコンテンツを処理                                                                                                                                                                                                                                                                                                                                                      | `cat logs.txt \| claude -p "explain"`                       |
-| `claude -c`                     | 現在のディレクトリで最新の会話を続行                                                                                                                                                                                                                                                                                                                                                  | `claude -c`                                                 |
-| `claude -c -p "query"`          | SDK 経由で続行                                                                                                                                                                                                                                                                                                                                                           | `claude -c -p "Check for type errors"`                      |
-| `claude -r "<session>" "query"` | セッション ID または名前でセッションを再開                                                                                                                                                                                                                                                                                                                                             | `claude -r "auth-refactor" "Finish this PR"`                |
-| `claude update`                 | 最新バージョンに更新                                                                                                                                                                                                                                                                                                                                                          | `claude update`                                             |
-| `claude install [version]`      | ネイティブバイナリをインストールまたは再インストールします。`2.1.118` のようなバージョン、または `stable` または `latest` を受け入れます。[特定のバージョンをインストール](/ja/setup#install-a-specific-version) を参照してください                                                                                                                                                                                                               | `claude install stable`                                     |
-| `claude auth login`             | Anthropic アカウントにサインインします。`--email` を使用してメールアドレスを事前入力し、`--sso` を使用して SSO 認証を強制し、`--console` を使用して Claude サブスクリプションの代わりに Anthropic Console で API 使用料金をサインインできます                                                                                                                                                                                                       | `claude auth login --console`                               |
-| `claude auth logout`            | Anthropic アカウントからログアウト                                                                                                                                                                                                                                                                                                                                              | `claude auth logout`                                        |
-| `claude auth status`            | 認証ステータスを JSON として表示します。`--text` を使用して人間が読める形式で表示できます。ログイン済みの場合はコード 0 で終了し、ログインしていない場合は 1 で終了します                                                                                                                                                                                                                                                                     | `claude auth status`                                        |
-| `claude agents`                 | [エージェントビュー](/ja/agent-view) を開いて、並列バックグラウンドセッションを監視およびディスパッチします。`--cwd <path>` を使用して、そのディレクトリの下で開始されたセッションのみを表示します。`--permission-mode`、`--model`、または `--effort` を渡して、[ディスパッチされたセッションのデフォルト](/ja/agent-view#permission-mode-model-and-effort) を設定します。トップレベルの `claude` コマンドと同様に `--settings`、`--add-dir`、`--plugin-dir`、および `--mcp-config` を受け入れます。インタラクティブターミナルが必要です | `claude agents --cwd ~/projects/my-app`                     |
-| `claude attach <id>`            | このターミナルで [バックグラウンドセッション](/ja/agent-view#manage-sessions-from-the-shell) に接続します                                                                                                                                                                                                                                                                                      | `claude attach 7c5dcf5d`                                    |
-| `claude auto-mode defaults`     | 組み込み [auto mode](/ja/permission-modes#eliminate-prompts-with-auto-mode) 分類器ルールを JSON として出力します。`claude auto-mode config` を使用して、設定が適用された有効な設定を確認してください                                                                                                                                                                                                                | `claude auto-mode defaults > rules.json`                    |
-| `claude daemon status`          | バックグラウンドセッション [スーパーバイザー](/ja/agent-view#the-supervisor-process) の状態、バージョン、ソケットディレクトリ、および診断用のワーカー数を出力します。スーパーバイザーが実行されていない場合は 1 で終了します                                                                                                                                                                                                                               | `claude daemon status`                                      |
-| `claude logs <id>`              | [バックグラウンドセッション](/ja/agent-view#manage-sessions-from-the-shell) からの最近の出力を出力します                                                                                                                                                                                                                                                                                       | `claude logs 7c5dcf5d`                                      |
-| `claude mcp`                    | Model Context Protocol（MCP）サーバーを設定                                                                                                                                                                                                                                                                                                                                  | [Claude Code MCP ドキュメント](/ja/mcp) を参照してください。                |
-| `claude plugin`                 | Claude Code [plugins](/ja/plugins) を管理します。エイリアス：`claude plugins`。サブコマンドについては [plugin reference](/ja/plugins-reference#cli-commands-reference) を参照してください                                                                                                                                                                                                             | `claude plugin install code-review@claude-plugins-official` |
-| `claude project purge [path]`   | プロジェクトのすべてのローカル Claude Code 状態を削除します：トランスクリプト、タスクリスト、デバッグログ、ファイル編集履歴、プロンプト履歴行、および `~/.claude.json` 内のプロジェクトエントリ。`[path]` を省略して、インタラクティブリストから選択します。フラグ：`--dry-run` でプレビュー、`-y`/`--yes` で確認をスキップ、`-i`/`--interactive` で各項目を確認、`--all` ですべてのプロジェクト。[ローカルデータをクリア](/ja/claude-directory#clear-local-data) を参照してください                                                      | `claude project purge ~/work/repo --dry-run`                |
-| `claude remote-control`         | [Remote Control](/ja/remote-control) サーバーを開始して、Claude.ai または Claude アプリから Claude Code を制御します。サーバーモード（ローカルインタラクティブセッションなし）で実行されます。[サーバーモードフラグ](/ja/remote-control#start-a-remote-control-session) を参照してください                                                                                                                                                          | `claude remote-control --name "My Project"`                 |
```

</details>

<details>
<summary>commands-ja.md</summary>

```diff
diff --git a/docs-ja/pages/commands-ja.md b/docs-ja/pages/commands-ja.md
index 11b3094..38144a7 100644
--- a/docs-ja/pages/commands-ja.md
+++ b/docs-ja/pages/commands-ja.md
@@ -36,5 +36,5 @@
 
 <Note>
-  すべてのコマンドがすべてのユーザーに表示されるわけではありません。可用性はプラットフォーム、プラン、環境によって異なります。たとえば、`/desktop` は macOS と Windows にのみ表示され、`/upgrade` は Pro プランと Max プランにのみ表示されます。
+  すべてのコマンドがすべてのユーザーに表示されるわけではありません。可用性はプラットフォーム、プラン、環境によって異なります。たとえば、`/desktop` は macOS と Windows にのみ表示され、Claude サブスクリプションでサインインしている場合のみ表示されます。また、`/upgrade` は Pro プランと Max プランにのみ表示されます。
 </Note>
 
@@ -57,5 +57,5 @@
 | `/cost`                                         | `/usage` のエイリアス                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
 | `/debug [description]`                          | **[スキル](/ja/skills#bundled-skills)。** 現在のセッションのデバッグログを有効にし、セッションデバッグログを読むことで問題をトラブルシューティングします。デバッグログはデフォルトではオフです。`claude --debug` で開始した場合を除き、セッション中に `/debug` を実行するとその時点からログのキャプチャを開始します。オプションで問題を説明して分析にフォーカスを当てます                                                                                                                                                                                                                                                                                            |
-| `/desktop`                                      | 現在のセッションを Claude Code デスクトップアプリで続行します。macOS と Windows のみ。エイリアス: `/app`                                                                                                                                                                                                                                                                                                                                                                                                                                         |
+| `/desktop`                                      | 現在のセッションを Claude Code デスクトップアプリで続行します。macOS と Windows が必要で、Claude サブスクリプションが必要です。エイリアス: `/app`                                                                                                                                                                                                                                                                                                                                                                                                                 |
 | `/diff`                                         | コミットされていない変更と各ターンの diff を表示するインタラクティブ diff ビューアを開きます。左右矢印を使用して現在の git diff と個別の Claude ターンを切り替え、上下矢印でファイルをブラウズします                                                                                                                                                                                                                                                                                                                                                                                              |
 | `/doctor`                                       | Claude Code のインストールと設定を診断および検証します。結果はステータスアイコン付きで表示されます。`f` を押して Claude に報告された問題を修正させます                                                                                                                                                                                                                                                                                                                                                                                                                        |
@@ -101,4 +101,6 @@
 | `/review [PR]`                                  | 現在のセッションでプルリクエストをローカルでレビューします。より深いクラウドベースのレビューについては、[`/ultrareview`](/ja/ultrareview)を参照してください                                                                                                                                                                                                                                                                                                                                                                                                                 |
 | `/rewind`                                       | 会話またはコードを前の時点に巻き戻すか、選択したメッセージから要約します。[チェックポイント](/ja/checkpointing)を参照してください。エイリアス: `/checkpoint`、`/undo`                                                                                                                                                                                                                                                                                                                                                                                                       |
+| `/run`                                          | **[スキル](/ja/skills#bundled-skills)。** プロジェクトのアプリを起動して実行し、テストだけでなく実行中のアプリで変更が機能しているのを確認します。[アプリを実行して検証](/ja/skills#run-and-verify-your-app)を参照してください。{/* min-version: 2.1.145 */}Claude Code v2.1.145 以降が必要です                                                                                                                                                                                                                                                                                                   |
+| `/run-skill-generator`                          | **[スキル](/ja/skills#bundled-skills)。** クリーンな環境からプロジェクトのアプリをビルド、起動、実行する方法を `/run` と `/verify` に教えるために、プロジェクトごとの[スキル](/ja/skills#run-and-verify-your-app)を作成します。{/* min-version: 2.1.145 */}Claude Code v2.1.145 以降が必要です                                                                                                                                                                                                                                                                                          |
 | `/sandbox`                                      | [サンドボックスモード](/ja/sandboxing)を切り替えます。サポートされているプラットフォームでのみ利用可能です                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
 | `/schedule [description]`                       | [ルーチン](/ja/routines)を作成、更新、リスト表示、または実行します。Claude がセットアップを会話形式でガイドします。エイリアス: `/routines`                                                                                                                                                                                                                                                                                                                                                                                                                        |
@@ -125,4 +127,5 @@
 | `/usage`                                        | セッションコスト、プラン使用制限、およびアクティビティ統計を表示します。サブスクリプション固有の詳細については、[コスト追跡ガイド](/ja/costs#using-the-%2Fusage-command)を参照してください。`/cost` と `/stats` はエイリアスです                                                                                                                                                                                                                                                                                                                                                                  |
 | `/usage-credits`                                | 制限に達したときに作業を続行するための usage credits を構成します。以前は `/extra-usage`                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
+| `/verify`                                       | **[スキル](/ja/skills#bundled-skills)。** プロジェクトのアプリをビルドして実行し、結果を観察することで、コード変更が期待通りに機能することを確認します。テストまたは型チェックに依存するのではなく。[アプリを実行して検証](/ja/skills#run-and-verify-your-app)を参照してください。{/* min-version: 2.1.145 */}Claude Code v2.1.145 以降が必要です                                                                                                                                                                                                                                                                          |
 | `/vim`                                          | {/* max-version: 2.1.91 */}v2.1.92 で削除。Vim と通常編集モード間を切り替えるには、`/config` → エディタモードを使用してください                                                                                                                                                                                                                                                                                                                                                                                                                      |
```

</details>

<details>
<summary>desktop-ja.md</summary>

```diff
diff --git a/docs-ja/pages/desktop-ja.md b/docs-ja/pages/desktop-ja.md
index be82d69..6e08268 100644
--- a/docs-ja/pages/desktop-ja.md
+++ b/docs-ja/pages/desktop-ja.md
@@ -643,5 +643,5 @@ Desktop はエンタープライズデプロイメントツールを通じて配
 既に Claude Code CLI を使用している場合、Desktop は同じ基盤となるエンジンをグラフィカルインターフェイスで実行します。同じマシン上で、同じプロジェクト上でも、両方を同時に実行できます。各々は個別のセッション履歴を保持しますが、CLAUDE.md ファイルを通じて設定とプロジェクトメモリを共有します。
 
-CLI セッションを Desktop に移動するには、ターミナルで `/desktop` を実行します。Claude はセッションを保存し、デスクトップアプリで開いてから CLI を終了します。このコマンドは macOS と Windows でのみ利用可能です。
+CLI セッションを Desktop に移動するには、ターミナルで `/desktop` を実行します。Claude はセッションを保存し、デスクトップアプリで開いてから CLI を終了します。このコマンドは macOS と Windows でのみ利用可能です。Claude サブスクリプションでサインインしている場合に利用できます。API キー認証では利用できず、Bedrock、Vertex、Foundry でも利用できません。
 
 <Tip>
@@ -660,5 +660,5 @@ CLI セッションを Desktop に移動するには、ターミナルで `/desk
 | `--dangerously-skip-permissions`     | Bypass permissions モード。Settings → Claude Code → 「Allow bypass permissions mode」で有効にします。エンタープライズ管理者はこの設定を無効にできます。 |
 | `--add-dir`                          | リモートセッションで **+** ボタンで複数のリポジトリを追加                                                                                 |
-| `--allowedTools`、`--disallowedTools` | [設定ファイル](/ja/settings)の権限ルールは引き続き適用されます。Desktop の同等物はありません。                                                      |
+| `--allowedTools`、`--disallowedTools` | セッションごとの同等物はありません。[設定ファイル](/ja/settings)の権限ルールは引き続き適用されます。                                                       |
 | `--verbose`                          | [Verbose ビューモード](#switch-view-modes)（Transcript view ドロップダウン）                                                    |
 | `--print`、`--output-format`          | 利用できません。Desktop はインタラクティブのみです。                                                                                   |
```

</details>

<details>
<summary>desktop-quickstart-ja.md</summary>

```diff
diff --git a/docs-ja/pages/desktop-quickstart-ja.md b/docs-ja/pages/desktop-quickstart-ja.md
index cb22f4a..cbff9f9 100644
--- a/docs-ja/pages/desktop-quickstart-ja.md
+++ b/docs-ja/pages/desktop-quickstart-ja.md
@@ -58,15 +58,15 @@ Code タブを開いた状態で、プロジェクトを選択して Claude に
 
     <Tip>
-      よく知っている小さなプロジェクトから始めてください。Claude Code が何ができるかを見るための最速の方法です。Windows では、ローカルセッションが機能するために [Git](https://git-scm.com/downloads/win)がインストールされている必要があります。ほとんどの Mac にはデフォルトで Git が含まれています。
+      よく知っている小さなプロジェクトから始めてください。Claude Code が何ができるかを見るための最速の方法です。Windows では、ローカルセッションが機能するために [Git](https://git-scm.com/downloads/win) がインストールされている必要があります。ほとんどの Mac にはデフォルトで Git が含まれています。
     </Tip>
 
     以下も選択できます。
 
-    * **Remote**: Anthropic のクラウドインフラストラクチャでセッションを実行します。アプリを閉じても続行します。リモートセッションは [Claude Code on the web](/ja/claude-code-on-the-web)と同じインフラストラクチャを使用します。
-    * **SSH**: SSH 経由でリモートマシンに接続します（独自のサーバー、クラウド VM、または dev コンテナー）。Claude Code はリモートマシンにインストールされている必要があります。
+    * **Remote**: Anthropic のクラウドインフラストラクチャでセッションを実行します。アプリを閉じても続行します。リモートセッションは [Claude Code on the web](/ja/claude-code-on-the-web) と同じインフラストラクチャを使用します。
+    * **SSH**: SSH 経由でリモートマシンに接続します（独自のサーバー、クラウド VM、または dev コンテナー）。Desktop は初回接続時にリモートマシンに Claude Code を自動的にインストールします。
   </Step>
 
   <Step title="モデルを選択する">
-    送信ボタンの横のドロップダウンからモデルを選択します。Opus、Sonnet、Haiku の比較については、[モデル](/ja/model-config#available-models)を参照してください。後でこのドロップダウンから同じモデルを変更できます。
+    送信ボタンの横のドロップダウンからモデルを選択します。Opus、Sonnet、Haiku の比較については、[モデル](/ja/model-config#available-models) を参照してください。後でこのドロップダウンから同じモデルを変更できます。
   </Step>
 
@@ -78,9 +78,9 @@ Code タブを開いた状態で、プロジェクトを選択して Claude に
     * `このコードベースの指示を含む CLAUDE.md を作成する`
 
-    [セッション](/ja/desktop#work-in-parallel-with-sessions)は、コードについて Claude との会話です。各セッションは独自のコンテキストと変更を追跡するため、複数のタスクに取り組む際に相互に干渉することなく作業できます。
+    [セッション](/ja/desktop#work-in-parallel-with-sessions) は、コードについて Claude との会話です。各セッションは独自のコンテキストと変更を追跡するため、複数のタスクに取り組む際に相互に干渉することなく作業できます。
   </Step>
```

</details>

<details>
<summary>discover-plugins-ja.md</summary>

```diff
diff --git a/docs-ja/pages/discover-plugins-ja.md b/docs-ja/pages/discover-plugins-ja.md
index 39dd8fc..db5547c 100644
--- a/docs-ja/pages/discover-plugins-ja.md
+++ b/docs-ja/pages/discover-plugins-ja.md
@@ -150,5 +150,9 @@ Anthropic は、プラグインシステムで何が可能かを示す例プラ
 
   <Step title="プラグインをインストールする">
-    プラグインを選択してその詳細を表示します。{/* min-version: 2.1.143 */}Claude Code v2.1.143 以降では、詳細ペインに **Context cost** の推定値が含まれており、インストール前に、プラグインが毎ターン [コンテキストウィンドウ](/ja/features-overview#understand-context-costs) に追加するトークン数を確認できます。{/* min-version: 2.1.144 */}v2.1.144 以降では、ペインにプラグインの **Last updated** 日付も表示されます。
+    プラグインを選択してその詳細を表示します。詳細ペインには、プラグインに含まれるもの、およびそのコストが表示されます：
+
+    * {/* min-version: 2.1.143 */}**Context cost** の推定値。毎ターン [コンテキストウィンドウ](/ja/features-overview#understand-context-costs) にプラグインが追加するトークン数を確認できます（Claude Code v2.1.143 以降）
+    * {/* min-version: 2.1.144 */}プラグインの **Last updated** 日付（v2.1.144 以降）
+    * {/* min-version: 2.1.145 */}プラグインのコマンド、エージェント、スキル、フック、MCP および LSP サーバーをリストアップする **Will install** セクション。インストール前に正確に何が追加されるかを確認できます（v2.1.145 以降）
 
     インストールスコープを選択します：
@@ -180,5 +184,5 @@ Anthropic は、プラグインシステムで何が可能かを示す例プラ
     これにより、変更がステージされ、コミットメッセージが生成され、コミットが作成されます。
 
-    各プラグインは異なる方法で機能します。**Discover** タブのプラグインの説明またはそのホームページをチェックして、提供されるスキルと機能を確認してください。
+    各プラグインは異なる方法で機能します。**Discover** タブのプラグインの詳細を確認して、提供されるコマンドとスキルを確認するか、使用方法のガイダンスについてそのホームページにアクセスしてください。
   </Step>
 </Steps>
```

</details>

*...以降省略*

</details>


<details>
<summary>2026-05-20</summary>

**変更ファイル:**

```
 docs-ja/pages/agent-view-ja.md             |   40 +-
 docs-ja/pages/amazon-bedrock-ja.md         |    4 +-
 docs-ja/pages/changelog.md                 |   76 ++
 docs-ja/pages/channels-reference-ja.md     |   16 +-
 docs-ja/pages/claude-platform-on-aws-ja.md |    4 +-
 docs-ja/pages/cli-reference-ja.md          |    6 +-
 docs-ja/pages/commands-ja.md               |    6 +-
 docs-ja/pages/context-window-en.md         | 1614 ----------------------------
 docs-ja/pages/costs-ja.md                  |    4 +-
 docs-ja/pages/discover-plugins-ja.md       |   45 +-
 docs-ja/pages/env-vars-ja.md               |   86 +-
 docs-ja/pages/errors-ja.md                 |   99 +-
 docs-ja/pages/features-overview-ja.md      |   64 +-
 docs-ja/pages/glossary-ja.md               |   12 +-
 docs-ja/pages/google-vertex-ai-ja.md       |    2 +-
 docs-ja/pages/headless-ja.md               |   22 +-
 docs-ja/pages/hooks-guide-ja.md            |   36 +-
 docs-ja/pages/hooks-ja.md                  |   50 +-
 docs-ja/pages/keybindings-ja.md            |    9 +-
 docs-ja/pages/mcp-ja.md                    |    2 +
 docs-ja/pages/microsoft-foundry-ja.md      |    2 +-
 docs-ja/pages/model-config-ja.md           |   28 +-
 docs-ja/pages/monitoring-usage-ja.md       |   18 +
 docs-ja/pages/output-styles-ja.md          |    4 +-
 docs-ja/pages/permissions-ja.md            |    6 +-
 docs-ja/pages/plugins-ja.md                |   17 +-
 docs-ja/pages/routines-ja.md               |   11 +
 docs-ja/pages/security-ja.md               |    1 +
 docs-ja/pages/settings-ja.md               |   17 +-
 docs-ja/pages/statusline-ja.md             |    2 +
 docs-ja/pages/sub-agents-ja.md             |    2 +-
 docs-ja/pages/tools-reference-ja.md        |    6 +-
 docs-ja/pages/voice-dictation-ja.md        |    2 +-
 33 files changed, 494 insertions(+), 1819 deletions(-)
```

**新規追加:**


**削除:**


<details>
<summary>agent-view-ja.md</summary>

```diff
diff --git a/docs-ja/pages/agent-view-ja.md b/docs-ja/pages/agent-view-ja.md
index 9c0d473..a47438b 100644
--- a/docs-ja/pages/agent-view-ja.md
+++ b/docs-ja/pages/agent-view-ja.md
@@ -182,5 +182,5 @@ Completed
 セッションをリストから削除するには、`Ctrl+X` を押して停止し、2 秒以内に `Ctrl+X` を再度押して削除します。グループヘッダーで `Ctrl+X` を押すと、確認後、そのグループ内のすべてのセッションが削除されます。
 
-削除するとセッションがエージェントビューから削除され、その会話トランスクリプトが削除されます。Claude が [ワークツリーを作成した](#how-file-edits-are-isolated) 場合、削除するとそのワークツリーも削除されます。コミットされていない変更を含みます。保持したい作業をプッシュまたはコミットしてから削除します。自分で作成したワークツリーとセッションを開始した場合は、そのままにしておきます。
+削除するとセッションがエージェントビューから削除されます。Claude が [ワークツリーを作成した](#how-file-edits-are-isolated) 場合、削除するとそのワークツリーも削除されます。コミットされていない変更を含みます。保持したい作業をプッシュまたはコミットしてから削除します。自分で作成したワークツリーとセッションを開始した場合は、そのままにしておきます。会話トランスクリプトはローカルマシンに残り、`claude --resume` を通じて利用可能です。
 
 古い完了したセッションは「… N more」行に折りたたまれ、リストを短く保ちます。失敗とオープンなプルリクエストを持つセッションは常に表示されます。
@@ -229,5 +229,5 @@ Completed
 プロンプトに画像を貼り付けて、タスクにスクリーンショットまたは図を含めます。
 
-プロンプトの一部をプレフィックスまたは言及してセッションの開始方法を制御します。
+プロンプトの一部をプレフィックスまたは言及してセッションの開始方法を制御します：
 
 | 入力                      | 効果                                                                                                       |
@@ -269,4 +269,6 @@ Completed
 * `--allow-dangerously-skip-permissions`
 
+セッション中に [`/add-dir`](/ja/permissions#additional-directories-grant-file-access-not-configuration) で追加したディレクトリも引き継がれます。
+
 `--allow-dangerously-skip-permissions` を引き継ぐことで、バックグラウンド化されたセッションで `bypassPermissions` に到達可能になりますが、新しい権限は付与されません。このモードは、セッションが監視していない状態で承認なしに動作することを許可するため、[パーミッションモード、モデル、および努力](#permission-mode-model-and-effort) で説明されているのと同じ 1 回限りのインタラクティブな受け入れが必要です。
 
@@ -291,8 +293,8 @@ claude --bg --name "flaky-test-fix" "investigate the flaky SettingsChangeDetecto
 ```
 
-バックグラウンド化の後、Claude はセッションの短い ID とセッションを管理するためのコマンドを出力します：
+バックグラウンド化の後、Claude はセッションの短い ID とセッションを管理するためのコマンドを出力します。`--name` を渡すと、短い ID の後に名前が表示されます：
```

</details>

<details>
<summary>amazon-bedrock-ja.md</summary>

```diff
diff --git a/docs-ja/pages/amazon-bedrock-ja.md b/docs-ja/pages/amazon-bedrock-ja.md
index 2665a7e..fa88d72 100644
--- a/docs-ja/pages/amazon-bedrock-ja.md
+++ b/docs-ja/pages/amazon-bedrock-ja.md
@@ -271,5 +271,7 @@ export ENABLE_PROMPT_CACHING_1H=1
 ```
 
-<Note>[プロンプトキャッシング](https://platform.claude.com/docs/en/build-with-claude/prompt-caching)は、すべてのリージョンで利用できない場合があります。1 時間の TTL でのキャッシュ書き込みは、5 分の書き込みよりも高いレートで課金されます。</Note>
+1 時間のキャッシュ TTL は、5 分のデフォルトよりも高いレートで課金されます。[キャッシュライフタイム](/ja/prompt-caching#cache-lifetime)を参照してください。
+
+<Note>プロンプトキャッシングは、すべての Bedrock リージョンで利用できない場合があります。キャッシュトークンカウントがゼロのままの場合は、Bedrock ドキュメントの[サポートされているモデル、リージョン、および制限](https://docs.aws.amazon.com/bedrock/latest/userguide/prompt-caching.html#prompt-caching-models)を確認してください。</Note>
 
 #### 各モデルバージョンを推論プロファイルにマップ
```

</details>

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index 8c6909b..f476a24 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,80 @@
 # Changelog
 
+## 2.1.145
+
+- Added `claude agents --json` to list live Claude sessions as JSON for scripting (tmux-resurrect, status bars, session pickers)
+- Added `agent_id` and `parent_agent_id` attributes to `claude_code.tool` OTEL spans, and fixed trace parenting so background subagent spans nest under the dispatching Agent tool span
+- Status line JSON input now includes GitHub repo and PR information when detected
+- `/plugin` Discover and Browse screens now show a plugin's commands, agents, skills, hooks, and MCP/LSP servers before installation
+- `claude agents` terminal tab title now shows the awaiting-input count so an alt-tabbed window tells you when an agent needs attention
+- Slash command and @-mention suggestion list now supports mouse hover and click in fullscreen mode
+- Stop and SubagentStop hook input now includes `background_tasks` and `session_crons` fields
+- Fixed a permission-prompt bypass where bare variable assignments to non-allowlisted environment variables in Bash commands were auto-approved
+- Fixed MCP prompt slash commands showing raw server validation errors when a required argument is omitted — the error now names the missing argument and shows expected usage
+- Fixed the spinner and elapsed-time display freezing until a keypress after the terminal was resized or refocused
+- Fixed the cross-project resume hint failing in default Windows PowerShell 5.1 — Windows now uses `;` as the command separator
+- Fixed voice push-to-talk not working in the agent view's reply pane
+- Fixed task lists rendering in random order when several tasks are created at once
+- Fixed stale "Failed to install Anthropic marketplace" banner showing when the marketplace is already installed
+- Fixed the PR badge in the footer not updating immediately after `gh pr create` and other PR-state-changing commands run in-session
+- Fixed Agent Teams teammates with non-ASCII names failing every API call due to invalid header encoding
+- Fixed `/review` using a deprecated `projectCards` GraphQL query that errored on repos with Classic Projects
+- Fixed `claude plugin validate` not flagging `skills:` entries that point at a file instead of a directory — the error now suggests the parent directory
+- Fixed an infinite loop where a skill using `context: fork` could repeatedly re-invoke itself instead of running
+- Improved the Read tool to return a truncated first page with a "PARTIAL view" notice instead of a hard error when a whole-file read exceeds the token limit
+
```

</details>

<details>
<summary>channels-reference-ja.md</summary>

```diff
diff --git a/docs-ja/pages/channels-reference-ja.md b/docs-ja/pages/channels-reference-ja.md
index 0fcdb31..d3e6664 100644
--- a/docs-ja/pages/channels-reference-ja.md
+++ b/docs-ja/pages/channels-reference-ja.md
@@ -8,5 +8,5 @@
 
 <Note>
-  チャネルは[リサーチプレビュー](/ja/channels#research-preview)段階にあり、Claude Code v2.1.80 以降が必要です。claude.ai ログインが必要です。Console と API キー認証はサポートされていません。Team および Enterprise 組織は[明示的に有効化](/ja/channels#enterprise-controls)する必要があります。
+  チャネルは[リサーチプレビュー](/ja/channels#research-preview)段階にあり、Claude Code v2.1.80 以降が必要です。Team および Enterprise 組織は[明示的に有効化](/ja/channels#enterprise-controls)する必要があります。
 </Note>
 
@@ -21,5 +21,5 @@
 * [例：webhook レシーバーを構築](#example-build-a-webhook-receiver)：最小限の一方向ウォークスルー
 * [サーバーオプション](#server-options)：コンストラクタフィールド
-* [通知フォーマット](#notification-format)：イベントペイロード
+* [通知フォーマット](#notification-format)：イベントペイロードと配信動作
 * [返信ツールを公開](#expose-a-reply-tool)：Claude がメッセージを返送できるようにする
 * [インバウンドメッセージをゲート](#gate-inbound-messages)：プロンプトインジェクションを防ぐための送信者チェック
@@ -139,5 +139,5 @@
     Claude Code が起動すると、MCP 設定を読み込み、`webhook.ts` をサブプロセスとして生成し、HTTP リスナーは設定したポート（この例では 8788）で自動的に開始されます。サーバーを自分で実行する必要はありません。
 
-    'ブロックされた組織ポリシー'が表示される場合は、Team または Enterprise 管理者が最初に[チャネルを有効化](/ja/channels#enterprise-controls)する必要があります。
+    'ブロックされた組織ポリシー'が表示される場合は、組織管理者が最初に[チャネルを有効化](/ja/channels#enterprise-controls)する必要があります。
 
     別のターミナルで、HTTP POST でメッセージを送信して webhook をシミュレートします。この例は、CI 失敗アラートをポート 8788（または設定したポート）に送信します：
@@ -242,4 +242,10 @@ build failed on main: https://ci.example.com/run/1234
 ```
 
+通知は確認されません。`mcp.notification()` の `await` は、メッセージがトランスポートに書き込まれるときに解決され、Claude が処理したときではありません。セッションがチャネルとしてサーバーを読み込んでいない場合、または組織ポリシーがそれをブロックしている場合、イベントはサーバーにエラーが返されることなくサイレントにドロップされます。
+
```

</details>

<details>
<summary>claude-platform-on-aws-ja.md</summary>

```diff
diff --git a/docs-ja/pages/claude-platform-on-aws-ja.md b/docs-ja/pages/claude-platform-on-aws-ja.md
index 796145a..c8092a0 100644
--- a/docs-ja/pages/claude-platform-on-aws-ja.md
+++ b/docs-ja/pages/claude-platform-on-aws-ja.md
@@ -275,7 +275,7 @@ export ANTHROPIC_DEFAULT_HAIKU_MODEL=claude-haiku-4-5
 ```
 
-モデル ID とエイリアスの完全なリストについては、[モデル概要](https://platform.claude.com/docs/en/about-claude/models/overview)を参照してください。その他のモデル関連の変数については、[モデル設定](/ja/model-config)を参照してください。
+モデル ID とエイリアスの完全なリストについては、[モデル概要](https://platform.claude.com/docs/en/about-claude/models/overview) を参照してください。その他のモデル関連の変数については、[モデル設定](/ja/model-config) を参照してください。
 
-[プロンプトキャッシング](https://platform.claude.com/docs/en/build-with-claude/prompt-caching)は自動的に有効になります。1 時間のキャッシュ書き込みは 5 分の書き込みよりも高いレートで請求されます。5 分のデフォルトの代わりに 1 時間のキャッシュ TTL をリクエストするには、`ENABLE_PROMPT_CACHING_1H=1` を設定します。
+[プロンプトキャッシング](/ja/prompt-caching) は自動的に有効になります。5 分のデフォルトの代わりに 1 時間のキャッシュ TTL をリクエストするには、`ENABLE_PROMPT_CACHING_1H=1` を設定します。API は 1 時間のキャッシュ書き込みをより高いレートで請求します。レートについては、[プロンプトキャッシング価格](https://platform.claude.com/docs/en/build-with-claude/prompt-caching#pricing) を参照してください。
 
 ## Agent SDK を使用する
```

</details>

<details>
<summary>cli-reference-ja.md</summary>

```diff
diff --git a/docs-ja/pages/cli-reference-ja.md b/docs-ja/pages/cli-reference-ja.md
index 963b558..7f876e7 100644
--- a/docs-ja/pages/cli-reference-ja.md
+++ b/docs-ja/pages/cli-reference-ja.md
@@ -35,5 +35,5 @@
 | `claude remote-control`         | [Remote Control](/ja/remote-control) サーバーを開始して、Claude.ai または Claude アプリから Claude Code を制御します。サーバーモード（ローカルインタラクティブセッションなし）で実行されます。[サーバーモードフラグ](/ja/remote-control#start-a-remote-control-session) を参照してください                                                                                                                                                          | `claude remote-control --name "My Project"`                 |
 | `claude respawn <id>`           | 会話を保持したまま、[バックグラウンドセッション](/ja/agent-view#manage-sessions-from-the-shell) を再開します。実行中または停止中。`--all` を使用してすべての実行中セッションを再開します。たとえば、更新された Claude Code バイナリを取得するため                                                                                                                                                                                                        | `claude respawn 7c5dcf5d`                                   |
-| `claude rm <id>`                | [バックグラウンドセッション](/ja/agent-view#manage-sessions-from-the-shell) をリストから削除します                                                                                                                                                                                                                                                                                          | `claude rm 7c5dcf5d`                                        |
+| `claude rm <id>`                | [バックグラウンドセッション](/ja/agent-view#manage-sessions-from-the-shell) をリストから削除します。会話トランスクリプトはローカルマシンに残り、`claude --resume` を通じて利用可能です                                                                                                                                                                                                                                       | `claude rm 7c5dcf5d`                                        |
 | `claude setup-token`            | CI とスクリプト用の長期間有効な OAuth トークンを生成します。ターミナルにトークンを出力し、保存しません。Claude サブスクリプションが必要です。[長期間有効なトークンを生成](/ja/authentication#generate-a-long-lived-token) を参照してください                                                                                                                                                                                                            | `claude setup-token`                                        |
 | `claude stop <id>`              | [バックグラウンドセッション](/ja/agent-view#manage-sessions-from-the-shell) を停止します。`claude kill` も受け入れます                                                                                                                                                                                                                                                                         | `claude stop 7c5dcf5d`                                      |
@@ -66,5 +66,5 @@
 | `--debug-file <path>`                           | デバッグログを特定のファイルパスに書き込みます。暗黙的にデバッグモードを有効にします。`CLAUDE_CODE_DEBUG_LOGS_DIR` より優先されます                                                                                                                                                                                                                                            | `claude --debug-file /tmp/claude-debug.log`                                                        |
 | `--disable-slash-commands`                      | このセッションのすべてのスキルとコマンドを無効にします                                                                                                                                                                                                                                                                                                 | `claude --disable-slash-commands`                                                                  |
-| `--disallowedTools`                             | モデルのコンテキストから削除され、使用できないツール                                                                                                                                                                                                                                                                                                  | `"Bash(git log *)" "Bash(git diff *)" "Edit"`                                                      |
+| `--disallowedTools`                             | 拒否ルール。ベアツール名はそのツールをモデルのコンテキストから削除します。`Bash(rm *)` のようなスコープ付きルールはツールを利用可能なままにし、一致する呼び出しのみを拒否します                                                                                                                                                                                                                              | `"Bash(git log *)" "Bash(git diff *)" "Edit"`                                                      |
 | `--effort`                                      | 現在のセッションの [努力レベル](/ja/model-config#adjust-effort-level) を設定します。オプション：`low`、`medium`、`high`、`xhigh`、`max`。利用可能なレベルはモデルによって異なります。[`effortLevel`](/ja/settings#available-settings) 設定をこのセッションでオーバーライドし、永続化されません                                                                                                                | `claude --effort high`                                                                             |
 | `--enable-auto-mode`                            | {/* max-version: 2.1.110 */}v2.1.111 で削除されました。Auto mode は現在 `Shift+Tab` サイクルにデフォルトで含まれています。`--permission-mode auto` を使用して開始してください                                                                                                                                                                                           | `claude --permission-mode auto`                                                                    |
@@ -98,5 +98,5 @@
 | `--remote-control-session-name-prefix <prefix>` | 明示的な名前が設定されていない場合、自動生成される [Remote Control](/ja/remote-control) セッション名のプレフィックス。デフォルトはマシンのホスト名で、`myhost-graceful-unicorn` のような名前が生成されます。同じ効果を得るには `CLAUDE_REMOTE_CONTROL_SESSION_NAME_PREFIX` を設定してください                                                                                                                       | `claude remote-control --remote-control-session-name-prefix dev-box`                               |
 | `--replay-user-messages`                        | stdin からのユーザーメッセージを stdout に再発行して確認します。`--input-format stream-json` と `--output-format stream-json` が必要です                                                                                                                                                                                                                   | `claude -p --input-format stream-json --output-format stream-json --replay-user-messages`          |
-| `--resume`, `-r`                                | ID または名前で特定のセッションを再開するか、セッションを選択するためのインタラクティブピッカーを表示します。このディレクトリを `/add-dir` で追加したセッションを含みます                                                                                                                                                                                                                                | `claude --resume auth-refactor`                                                                    |
+| `--resume`, `-r`                                | ID または名前で特定のセッションを再開するか、セッションを選択するためのインタラクティブピッカーを表示します。このディレクトリを `/add-dir` で追加したセッションを含みます。v2.1.144 以降、[バックグラウンドセッション](/ja/agent-view) はピッカーに `bg` でマークされて表示されます                                                                                                                                                          | `claude --resume auth-refactor`                                                                    |
 | `--session-id`                                  | 会話に特定のセッション ID を使用します（有効な UUID である必要があります）                                                                                                                                                                                                                                                                                  | `claude --session-id "550e8400-e29b-41d4-a716-446655440000"`                                       |
 | `--setting-sources`                             | 読み込む設定ソースのカンマ区切りリスト（`user`、`project`、`local`）                                                                                                                                                                                                                                                                               | `claude --setting-sources user,project`                                                            |
```

</details>

<details>
<summary>commands-ja.md</summary>

```diff
diff --git a/docs-ja/pages/commands-ja.md b/docs-ja/pages/commands-ja.md
index a5efe68..11b3094 100644
--- a/docs-ja/pages/commands-ja.md
+++ b/docs-ja/pages/commands-ja.md
@@ -64,5 +64,5 @@
 | `/export [filename]`                            | 現在の会話をプレーンテキストとしてエクスポートします。ファイル名を指定すると、そのファイルに直接書き込みます。指定しない場合、クリップボードにコピーするか、ファイルに保存するダイアログを開きます                                                                                                                                                                                                                                                                                                                                                                                                              |
 | `/fast [on\|off]`                               | [高速モード](/ja/fast-mode)のオン/オフを切り替えます                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
-| `/feedback [report]`                            | Claude Code に関するフィードバックを送信します。エイリアス: `/bug`                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
+| `/feedback [report]`                            | フィードバックを送信し、バグを報告するか、会話を共有します。エイリアス: `/bug`、`/share`                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
 | `/fewer-permission-prompts`                     | **[スキル](/ja/skills#bundled-skills)。** トランスクリプトで一般的な読み取り専用 Bash と MCP ツール呼び出しをスキャンし、プロジェクト `.claude/settings.json` に優先度付きの許可リストを追加して権限プロンプトを削減します                                                                                                                                                                                                                                                                                                                                                               |
 | `/focus`                                        | フォーカスビューを切り替えます。最後のプロンプト、編集 diffstats を含む 1 行のツール呼び出し要約、および最終応答のみを表示します。選択は複数セッション間で保持されます。設定で [`viewMode`](/ja/settings#available-settings) を設定してオーバーライドします。[フルスクリーンレンダリング](/ja/fullscreen)でのみ利用可能です                                                                                                                                                                                                                                                                                                          |
@@ -83,5 +83,5 @@
 | `/memory`                                       | `CLAUDE.md` メモリファイルを編集し、[自動メモリ](/ja/memory#auto-memory)を有効または無効にし、自動メモリエントリを表示します                                                                                                                                                                                                                                                                                                                                                                                                                              |
 | `/mobile`                                       | Claude モバイルアプリをダウンロードするための QR コードを表示します。エイリアス: `/ios`、`/android`                                                                                                                                                                                                                                                                                                                                                                                                                                               |
-| `/model [model]`                                | AI モデルを選択または変更します。サポートしているモデルの場合、左右矢印を使用して[努力レベルを調整](/ja/model-config#adjust-effort-level)します。引数なしで、会話に前の出力がある場合に確認を求めるピッカーを開きます。次の応答はキャッシュされたコンテキストなしで完全な履歴を再読み込みするためです。確認されると、現在の応答の完了を待たずに変更が適用されます                                                                                                                                                                                                                                                                                                         |
+| `/model [model]`                                | 現在のセッションの AI モデルを設定します。サポートしているモデルの場合、左右矢印を使用して[努力レベルを調整](/ja/model-config#adjust-effort-level)します。引数なしで、ピッカーを開きます。ピッカーで `d` を押して、そのモデルを新しいセッションのデフォルトとして保存することもできます。会話に前の出力がある場合、ピッカーは確認を求めます。次の応答はキャッシュされたコンテキストなしで完全な履歴を再読み込みするためです。確認されると、現在の応答の完了を待たずに変更が適用されます                                                                                                                                                                                                                                           |
 | `/passes`                                       | Claude Code の無料 1 週間を友人と共有します。アカウントが対象の場合のみ表示されます                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
 | `/permissions`                                  | ツール権限のアクセス許可、確認、および拒否ルールを管理します。スコープ別にルールを表示し、ルールを追加または削除し、作業ディレクトリを管理し、[最近の自動モード拒否](/ja/auto-mode-config#review-denials)を確認できるインタラクティブダイアログを開きます。エイリアス: `/allowed-tools`                                                                                                                                                                                                                                                                                                                                       |
@@ -98,5 +98,5 @@
 | `/remote-env`                                   | [`--remote` で開始されたウェブセッション](/ja/claude-code-on-the-web#configure-your-environment)のデフォルトリモート環境を構成します                                                                                                                                                                                                                                                                                                                                                                                                           |
 | `/rename [name]`                                | 現在のセッションの名前を変更してプロンプトバーに名前を表示します。名前を指定しない場合、会話履歴から自動生成されます                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
-| `/resume [session]`                             | ID または名前で会話を再開するか、セッションピッカーを開きます。エイリアス: `/continue`                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
+| `/resume [session]`                             | ID または名前で会話を再開するか、セッションピッカーを開きます。v2.1.144 以降、[バックグラウンドセッション](/ja/agent-view)はピッカーに `bg` とマークされて表示されます。エイリアス: `/continue`                                                                                                                                                                                                                                                                                                                                                                                       |
 | `/review [PR]`                                  | 現在のセッションでプルリクエストをローカルでレビューします。より深いクラウドベースのレビューについては、[`/ultrareview`](/ja/ultrareview)を参照してください                                                                                                                                                                                                                                                                                                                                                                                                                 |
 | `/rewind`                                       | 会話またはコードを前の時点に巻き戻すか、選択したメッセージから要約します。[チェックポイント](/ja/checkpointing)を参照してください。エイリアス: `/checkpoint`、`/undo`                                                                                                                                                                                                                                                                                                                                                                                                       |
```

</details>

*...以降省略*

</details>


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

<!-- UPDATE_LOG_END -->
