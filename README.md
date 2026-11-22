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
<summary>2026-11-22</summary>

**変更ファイル:**

```
 docs-ja/pages/env-vars-ja.md         |   4 +-
 docs-ja/pages/hooks-ja.md            |  28 +++++---
 docs-ja/pages/permission-modes-ja.md |   8 ++-
 docs-ja/pages/sub-agents-ja.md       |  69 +++++++++----------
 docs-ja/pages/tools-reference-ja.md  | 127 +++++++++++++++++++++++++++--------
 docs-ja/pages/vs-code-ja.md          |   2 +-
 6 files changed, 161 insertions(+), 77 deletions(-)
```

<details>
<summary>env-vars-ja.md</summary>

```diff
diff --git a/docs-ja/pages/env-vars-ja.md b/docs-ja/pages/env-vars-ja.md
index a8f1149..3458bc5 100644
--- a/docs-ja/pages/env-vars-ja.md
+++ b/docs-ja/pages/env-vars-ja.md
@@ -314,5 +314,5 @@ Claude Code はスタートアップ時にシェル環境変数を読み込む
 | `CLAUDE_CODE_FORCE_SYNC_OUTPUT` | ターミナルがサポートしているものの自動検出されない場合に、`1` に設定すると DEC プライベートモード 2026 の [同期出力](https://gist.github.com/christianparpart/d8a62cc1ab659194337d73e399004036) を強制的に有効にします。BSU/ESU を実装しているものの機能プローブに応答しない Emacs `eat` などのエミュレーターに便利です。tmux の下では効果がありません。[フルスクリーンレンダリング](https://code.claude.com/docs/ja/fullscreen.md) に切り替える `CLAUDE_CODE_NO_FLICKER` とは異なり、これはレンダラーを変更しません |
 | `CLAUDE_CODE_FORCE_TERMINAL_IMAGES` | ターミナルが Unicode プレースホルダー付きの kitty グラフィックスプロトコル画像を描画できるのに、`Image` の薄く表示された `alt` テキストが表示される場合に、`1` に設定すると [mod の `Image` 要素](https://code.claude.com/docs/ja/plugins/mods/reference#elements)を画像として描画します。[`Image` を描画するターミナルと、この変数を設定すべきでない場所](https://code.claude.com/docs/ja/plugins/mods/gallery#image-and-client)を参照してください |
-| `CLAUDE_CODE_FORK_SUBAGENT` | fork モードを制御します。fork モードはデフォルトでオンで、Claude が自ら[フォーク](https://code.claude.com/docs/ja/sub-agents.md#fork-the-current-conversation)を開始できるようにします。fork モードがオンの間、Claude はマシン上の対話型ターミナル、VS Code、またはデスクトップのセッションで[サブエージェントを待機する](https://code.claude.com/docs/ja/sub-agents.md#run-subagents-in-foreground-or-background)こともできません。`0` に設定すると fork モードをオフにします。バージョンについては、[fork モードをオフにする](https://code.claude.com/docs/ja/sub-agents.md#turn-fork-mode-on-or-off)を参照してください |
+| `CLAUDE_CODE_FORK_SUBAGENT` | fork モードを制御します。fork モードはデフォルトでオンで、Claude が自ら[フォーク](https://code.claude.com/docs/ja/sub-agents.md#fork-the-current-conversation)を開始できるようにします。`0` に設定すると fork モードをオフにします。例えば、[Claude にサブエージェントを待たせる](https://code.claude.com/docs/ja/sub-agents.md#let-claude-wait-for-a-subagent)場合に使用します。バージョンについては、[fork モードをオフにする](https://code.claude.com/docs/ja/sub-agents.md#turn-fork-mode-on-or-off)を参照してください |
 | `CLAUDE_CODE_FORWARD_SUBAGENT_TEXT` | `1` に設定すると、`claude -p --output-format stream-json` の出力に [サブエージェント](https://code.claude.com/docs/ja/sub-agents.md) のテキストと思考ブロックを出力します。これは [`--forward-subagent-text`](https://code.claude.com/docs/ja/cli-reference#cli-flags) フラグと同じ動作です。ハーネスが `claude` を呼び出し、フラグ自体を渡せない場合にこの変数を使用します。stream-json 出力を伴う非対話モード以外ではエラーで終了するフラグとは異なり、この変数はそのような場合には無視されるため、プロセス全体で設定されていてもネストされた呼び出しは引き続き動作します。Claude Code v2.1.211 以降が必要です |
 | `CLAUDE_CODE_FULL_SIGN_IN_LINK` | 短い URL の代わりに完全な claude.ai ログイン URL を表示するには `1` に設定します。短い URL でエラーが表示される場合や、スクリプトが URL から値を読み取る場合に使用します。シェルまたはユーザー設定で設定してください。Claude Code v2.1.330 以降が必要です |
@@ -442,5 +442,5 @@ Claude Code はスタートアップ時にシェル環境変数を読み込む
 | `CLAUDE_CODE_WARN_DISK_FREE_GIB` | `10` などの GiB 単位の整数に設定すると、作業ディレクトリのファイルシステムの空き容量がその量を下回ったときに、Claude Code が Claude に警告します。警告は空き容量を示すシステムリマインダーです。変数が未設定、`0`、または数字のみでない場合、リマインダーはオフになります。Claude Code は設定の `env` ブロックで渡された値を無視するため、Claude Code を起動する環境で設定してください。Claude Code v2.1.304 以降が必要です |
 | `CLAUDE_CODE_WARN_MEMORY_FREE_GIB` | Linux と WSL で、`4` などの GiB 単位の整数に設定すると、利用可能なメモリがその量を下回ったときに、Claude Code が Claude に警告します。警告は利用可能な量を示すシステムリマインダーです。変数が未設定、`0`、または数字のみでない場合、リマインダーはオフになります。Claude Code は設定の `env` ブロックで渡された値を無視するため、Claude Code を起動する環境で設定してください。Claude Code v2.1.304 以降が必要です |
-| `CLAUDE_CODE_WEBFETCH_CACHE_TTL_MS` | [WebFetch](https://code.claude.com/docs/ja/tools-reference.md#webfetch-tool-behavior) が取得した各 URL のレスポンスをキャッシュしておく時間をミリ秒で設定します。デフォルトは `900000`（15 分）です。数字のみを受け付けます。`0`、小数、その他の表記ではデフォルトが維持されます。Claude Code は起動ごとに 1 回だけ値を読み取るため、設定の `env` ブロックでの変更は次に `claude` を起動したときに適用されます。Claude Code v2.1.233 以降が必要です |
+| `CLAUDE_CODE_WEBFETCH_CACHE_TTL_MS` | [WebFetch](https://code.claude.com/docs/ja/tools-reference.md#webfetch-tool-behavior) が取得した各ページをキャッシュに保持するミリ秒数を設定します。デフォルトは `900000`（15 分）です。数字のみを受け付けます。`0`、小数、その他の表記ではデフォルトが維持されます。Claude Code は起動ごとに 1 回値を読み取るため、設定の `env` ブロックでの変更は、次に `claude` を起動したときに適用されます。Claude Code v2.1.233 以降が必要です |
 | `CLAUDE_CODE_WEBFETCH_DEADLINE_MS` | [WebFetch](https://code.claude.com/docs/ja/tools-reference.md#webfetch-tool-behavior) がページのダウンロード（たどるリダイレクトを含む）を待機する時間の上限（ミリ秒）。その時点までに完了しないダウンロードは期限エラーで失敗します。デフォルトは `300000`（5 分）です。`0` に設定すると制限がなくなります。数字のみを受け付けます。小数やその他の表記ではデフォルトが維持されます。Claude Code v2.1.268 以降が必要です |
 | `CLAUDE_CODE_WEB_SEARCH_REFILLS_PER_HOUR` | セッションの [WebSearch の制限](https://code.claude.com/docs/ja/tools-reference.md#session-search-limit)が補充されるレート（1 時間あたりの呼び出し数）。対話型のターミナルセッションではデフォルトは `100` です。[非対話](https://code.claude.com/docs/ja/headless.md)セッションではデフォルトは `0` で、補充はオフになります。数字のみを受け付けます。その他の表記は未設定として扱われます。Claude Code v2.1.290 以降が必要です |
```

</details>

<details>
<summary>hooks-ja.md</summary>

```diff
diff --git a/docs-ja/pages/hooks-ja.md b/docs-ja/pages/hooks-ja.md
index 775d707..da4c30e 100644
--- a/docs-ja/pages/hooks-ja.md
+++ b/docs-ja/pages/hooks-ja.md
@@ -2597,7 +2597,7 @@ Claude Code が通知を送信するときに実行されます。通知タイ
 > * `permission_prompt` は、ユーザーが約 6 秒間入力していないときに発火します。タイマーは権限プロンプトが表示されたときに開始され、キー入力のたびに延期されます。Claude がツールの使用権限を求めたときにすぐにフックを実行するには、代わりに [PermissionRequest](#permissionrequest) を使用してください。
 > * `idle_prompt` は、Claude が応答を完了してから約 60 秒後に発火します。ただし、それ以降ユーザーが入力しておらず、バックグラウンドの[サブエージェント](https://code.claude.com/docs/ja/sub-agents.md)などのバックグラウンドエージェントが実行中でない場合に限ります。claude.ai の使用制限のリセットを待っている間、Claude Code は `idle_prompt` を送信しません。待機が自然に終了すると、代わりに `quota_auto_resume_*` タイプのいずれかが発火します。
-> * `elicitation_dialog`（elicitation フォームの場合）または `elicitation_url_dialog`（ブラウザの URL リクエストの場合）は、ユーザーが約 6 秒間入力していないときに発火します。どちらも `permission_prompt` と同じ 6 秒間の条件を共有しており、タイマーはダイアログが表示されたときに開始され、キー入力のたびに延期されます。
+> * elicitation フォームの場合は `elicitation_dialog`、ブラウザ URL のリクエストの場合は `elicitation_url_dialog` が、約 6 秒間入力がなかった時点で発生します。
 >
-> 別のダイアログが画面に表示されている間に届いた権限リクエストや elicitation にも、同じ 6 秒間の条件が適用され、タイマーはリクエストが届いた時点から計測されます。そのため、リクエストが開いているダイアログの後ろで待機している間に、その通知が届くことがあります。
+> 別のダイアログが画面に表示されている間に届いた権限リクエストや elicitation も、リクエストが届いた時点から計測される同じ 6 秒のタイミングを維持します。その通知は、リクエストが開いているダイアログの後ろでまだ待機している間に届くことがあります。
 
 Claude Code が権限リクエストを Agent SDK の [`canUseTool` コールバック](https://code.claude.com/docs/ja/agent-sdk/user-input)に送信するセッションでは、`permission_prompt` のタイミングが異なります。これは、Claude Desktop と VS Code 拡張機能が Claude Code をホストする方法です。
@@ -2653,5 +2653,5 @@ v2.1.233 より前では、これらのセッションで `permission_prompt` 
 ```
 
-Notification フックは、通知をブロックしたり変更したりすることはできません。Claude Code はこれらのフックの `systemMessage` と `continue` フィールドを破棄しますが、[`terminalSequence`](#emit-terminal-notifications) は引き続き出力します。デスクトップ通知の例はこれを利用しています。Notification フックは、通知を外部サービスに転送するなどの副作用を目的としています。
+Notification フックは通知をブロックしたり変更したりできません。Claude Code はそれらの `systemMessage` と `continue` フィールドを破棄しますが、[`terminalSequence`](#emit-terminal-notifications) は引き続き出力します。
 
 ### SubagentStart
@@ -2661,4 +2661,8 @@ Claude が Agent ツールでサブエージェントを生成したとき、Cla
 [プラグイン](https://code.claude.com/docs/ja/plugins/overview.md)に含まれるサブエージェントの場合、エージェントタイプは素のフロントマターの名前ではなく、`my-plugin:reviewer` のようなプラグインスコープの識別子になります。コロンが含まれるとプラグインスコープの名前は正規表現として扱われるため、完全一致させるには matcher を `^` と `$` で固定してください（`^my-plugin:reviewer$`）。
 
+> [!NOTE]
+>
+> 組み込みの [`web-fetch` サブエージェント](https://code.claude.com/docs/ja/tools-reference#web-fetch-subagent)については、Claude Code は管理設定の `SubagentStart` フックのみを実行します。それ以外の場所で設定したフックの場合は、代わりに `PreToolUse` フックで `WebFetch` をマッチさせてください。
+
 #### SubagentStart の入力
 
```

</details>

<details>
<summary>permission-modes-ja.md</summary>

```diff
diff --git a/docs-ja/pages/permission-modes-ja.md b/docs-ja/pages/permission-modes-ja.md
index c0a5df5..77065d1 100644
--- a/docs-ja/pages/permission-modes-ja.md
+++ b/docs-ja/pages/permission-modes-ja.md
@@ -629,9 +629,13 @@ auto モードがセッションのアクションを承認できない場合、
 > [accordion] auto モードがサブエージェントを扱う方法
 >
-> 分類器は[サブエージェント](https://code.claude.com/docs/ja/sub-agents.md)の作業を 3 つの時点でチェックします。
+> Claude が Agent ツールで[サブエージェント](https://code.claude.com/docs/ja/sub-agents.md)を開始すると、分類器はサブエージェントの作業を 3 つの時点でチェックします。
 >
 > 1. サブエージェントが開始する前に、委任されたタスクの説明が評価されるため、危険に見えるタスクは生成時にブロックされます。
 > 2. サブエージェントの実行中、その各アクションは親セッションと同じ[決定順序](#how-the-classifier-evaluates-actions)で、同じブロックルールと allow ルールに基づいて処理されます。サブエージェントのフロントマターにある `permissionMode` は無視されます。
-> 3. サブエージェントが終了すると、親がレポートを読む前に、分類器がその作業と最終レポートをレビューします。分類器がサブエージェントの作業やレポートを指摘した場合、または別の API 安全チェックがレビューを拒否した場合でも、レポートはセキュリティ警告を先頭に付けて配信されます。分類器がレビューに利用できない場合、レポートには、行動する前にサブエージェントの作業を検証するよう促すメモが付いて届きます。
+> 3. [エージェントチーム](https://code.claude.com/docs/ja/agent-teams.md)のチームメイト以外のサブエージェントが終了すると、親がレポートを読む前に、分類器がその作業と最終レポートをレビューします。
+>
+>    分類器がサブエージェントの作業やレポートを指摘した場合、または別の API 安全チェックがレビューを拒否した場合でも、レポートはセキュリティ警告を先頭に付けて配信されます。分類器がレビューに利用できない場合、レポートには、行動する前にサブエージェントの作業を検証するよう促すメモが付いて届きます。
+>
+> [`web-fetch` サブエージェント](https://code.claude.com/docs/ja/tools-reference#web-fetch-subagent)については、`WebFetch(domain:...)` の許可ルールまたは[事前承認済みドメイン](https://code.claude.com/docs/ja/tools-reference.md#webfetch-tool-behavior)がタスク内のすべての URL をカバーしている場合、Claude Code は最初の 2 つのチェックをスキップできます。その場合、サブエージェントは [`dontAsk` モード](#allow-only-pre-approved-tools-with-dontask-mode)で開始するため、承認が必要なその他の取得はすべて拒否されます。3 つ目のチェックは引き続き実行されます。
 
 > [accordion] コストとレイテンシー
```

</details>

<details>
<summary>sub-agents-ja.md</summary>

```diff
diff --git a/docs-ja/pages/sub-agents-ja.md b/docs-ja/pages/sub-agents-ja.md
index 5183ca7..6b2fd30 100644
--- a/docs-ja/pages/sub-agents-ja.md
+++ b/docs-ja/pages/sub-agents-ja.md
@@ -31,5 +31,5 @@ Claude は各サブエージェントの説明を使用して、タスクを委
 Claude Code には、Claude が必要に応じて自動的に使用する組み込みサブエージェントが含まれています。各サブエージェントは親の会話の権限を継承します。ほとんどは制限されたツールセットで実行されます。
 
-Explore と Plan は、調査を高速かつ低コストに保つために、CLAUDE.md ファイルと git ステータスのスナップショットを読み込まずに開始します。その他の組み込みサブエージェントと[カスタムサブエージェント](#configure-subagents)は両方を読み込みます。ただし、カスタムサブエージェントの定義で [`omitClaudeMd`](#supported-frontmatter-fields) を設定すると、ユーザー、プロジェクト、およびローカルの CLAUDE.md ファイルを読み込まずに開始できます。サブエージェントに到達するものの完全な内訳については、[スタートアップ時に読み込まれるもの](#what-loads-at-startup)を参照してください。
+Explore と Plan は、調査を高速かつ低コストに保つために、CLAUDE.md ファイルと git ステータスのスナップショットを読み込まずに開始します。サブエージェントに到達するものの完全な内訳については、[スタートアップ時に読み込まれるもの](#what-loads-at-startup)を参照してください。
 
 > [tab] Explore
@@ -71,5 +71,5 @@ Explore と Plan は、調査を高速かつ低コストに保つために、CLA
 > [tab] Other
 >
-> Claude Code には、特定のタスク用の追加のヘルパーエージェントが含まれています。これらは通常自動的に呼び出されるため、直接使用する必要はありません。
+> Claude Code には、特定のタスク用の追加のヘルパーエージェントが含まれています。
 >
 > | エージェント | モデル | Claude が使用する場合 |
@@ -78,4 +78,5 @@ Explore と Plan は、調査を高速かつ低コストに保つために、CLA
 > | statusline-setup | Sonnet | `/statusline`を実行してステータスラインを設定する場合 |
 > | claude-code-guide | Haiku | Claude Code 機能について質問する場合 |
+> | web-fetch | Haiku、または [Haiku を使用できない場合](https://code.claude.com/docs/ja/tools-reference.md#which-model-the-web-fetch-subagent-runs-on)はこれを開始した会話のモデル | [このサブエージェントを使用するセッション](https://code.claude.com/docs/ja/tools-reference.md#web-fetch-subagent)で Claude が Web ページを読み取る場合 |
 
 組み込みサブエージェントはインタラクティブセッションでデフォルトで登録されます。これらを制限するには：
@@ -88,5 +89,5 @@ Explore と Plan は、調査を高速かつ低コストに保つために、CLA
 `subagent_type` を省略する Agent ツール呼び出しは、フォールバック先となる `general-purpose` サブエージェントがセッションにない場合、[`subagent_type is required`](https://code.claude.com/docs/ja/errors#subagent-type-is-required) で失敗します。
 
-これらの組み込みサブエージェント以外に、カスタムプロンプト、ツール制限、権限モード、フック、およびスキルを使用して独自のサブエージェントを作成できます。次のセクションでは、サブエージェントの使用を開始し、カスタマイズする方法を示します。
+これらの組み込みサブエージェント以外に、カスタムプロンプト、ツール制限、権限モード、フック、およびスキルを使用して独自のサブエージェントを作成できます。
 
```

</details>

<details>
<summary>tools-reference-ja.md</summary>

```diff
diff --git a/docs-ja/pages/tools-reference-ja.md b/docs-ja/pages/tools-reference-ja.md
index 51ad93e..2612508 100644
--- a/docs-ja/pages/tools-reference-ja.md
+++ b/docs-ja/pages/tools-reference-ja.md
@@ -111,5 +111,5 @@ Agent ツールは、別のコンテキストウィンドウでサブエージ
 * **フォーク**: [フォークモード](https://code.claude.com/docs/ja/sub-agents.md#turn-fork-mode-on-or-off) がオンの場所では、このツールは [フォークされたサブエージェント](https://code.claude.com/docs/ja/sub-agents.md#fork-the-current-conversation) を起動できます。フォークされたサブエージェントは、新規に開始する代わりに親の会話全体を継承します
 
-サブエージェントが実行するターン数を制限するには、[subagent definition](https://code.claude.com/docs/ja/sub-agents.md#supported-frontmatter-fields) で `maxTurns` を設定します。サブエージェントが制限に達すると、Claude Code は返された結果を部分的な出力としてマークし、Claude は [subagent を再開](https://code.claude.com/docs/ja/sub-agents.md#resume-subagents) して続行することができます。
+サブエージェントが実行するターン数を制限するには、[サブエージェント定義](https://code.claude.com/docs/ja/sub-agents.md#supported-frontmatter-fields) で `maxTurns` を設定します。
 
 非フォーク subagent が使用できるツールは、[subagent definition](https://code.claude.com/docs/ja/sub-agents.md) の `tools` フィールドと `disallowedTools` フィールドに依存します。
@@ -220,5 +220,5 @@ Claude Code はコマンドの出力をコマンド実行中に作業ファイ
 #### フォアグラウンドコマンドがバックグラウンドに移動する
 
-フォアグラウンドコマンドが完了せずにタイムアウトに達すると、Claude Code はそれを停止する代わりにバックグラウンドに移動します。ただし、コマンドが `sleep` で始まる場合は除きます。移動されたコマンドの[時間制限](#time-limit-for-background-commands)は移動からカウントされ、フォアグラウンドサブエージェントの移動されたコマンドはそのサブエージェントの実行が終了すると停止します。
+フォアグラウンドコマンドが完了せずにタイムアウトに達すると、Claude Code はそれを停止する代わりにバックグラウンドに移動します。ただし、コマンドが `sleep` で始まる場合は除きます。
 
 [`CLAUDE_CODE_DISABLE_BACKGROUND_TASKS=1`](https://code.claude.com/docs/ja/env-vars#variables) を設定するか、[bare モード](https://code.claude.com/docs/ja/headless.md#start-faster-with-bare-mode)で実行すると、自動バックグラウンド化が無効になるため、タイムアウトに達したコマンドは代わりに停止します。
@@ -392,6 +392,4 @@ Monitor ツールは Claude がバックグラウンドで何かを監視し、
 ほとんどの監視では、Claude は小さなスクリプトを作成し、バックグラウンドで実行し、到着した各出力行を受け取ります。既にイベントをプッシュしているサーバーの場合、Claude はスクリプトを実行する代わりに [WebSocket](#websocket-source) を開くことができます。
 
-同じセッションで作業を続けることができ、イベントが到着すると Claude が割り込みます。
-
 Claude が開始するすべての監視には期限があります。デフォルトでは 5 分、最大 30 分、および `-p` で単一のプロンプトが与えられた [非対話型](https://code.claude.com/docs/ja/headless.md) 実行では最大 10 分です。
 
@@ -658,41 +656,114 @@ Task ツールがない場合、エージェントは[共有タスクリスト](
 ## WebFetch ツールの動作
 
-WebFetch は URL とそこから抽出する内容を説明するプロンプトを受け取ります。ページをフェッチし、サーバーが HTML を返した場合はレスポンスを Markdown に変換します。ほとんどのフェッチでは、その後、別のモデル呼び出しでコンテンツに対してプロンプトを実行し、Claude は生のページではなくその呼び出しの結果を受け取ります。変換ステップは設定できません。
+Claude は WebFetch を使用して Web ページ上の情報を調べます。URL はユーザーが指定することも、Claude が指定することもあります（たとえば [WebSearch](#websearch-tool-behavior) の結果から）。ほとんどのページでは、Claude は全文を見ません。Claude がページについて質問し、別のモデル呼び出しがページを読んで回答を返します。
```

</details>

<details>
<summary>vs-code-ja.md</summary>

```diff
diff --git a/docs-ja/pages/vs-code-ja.md b/docs-ja/pages/vs-code-ja.md
index 180966a..4da46b9 100644
--- a/docs-ja/pages/vs-code-ja.md
+++ b/docs-ja/pages/vs-code-ja.md
@@ -653,5 +653,5 @@ Claude がコードセルを置き換えると、ファイル内のセルのソ
 #### サブエージェントの下に Run in background アクションが表示されない
 
-VS Code では、デフォルトでサブエージェントにこのアクションは表示されません。特定のサブエージェントについてその理由を確認するには、[エージェントマップ](#use-the-prompt-box)でそのカードを開き、`Spawned by` の行を確認します：
+VS Code では、デフォルトでほとんどのサブエージェントにこのアクションは表示されません。特定のサブエージェントについてその理由を確認するには、[エージェントマップ](#use-the-prompt-box)でそのカードを開き、`Spawned by` の行を確認します：
 
 * **`Spawned by the main agent`**：サブエージェントはバックグラウンドで開始されたため、Claude はその完了を待っておらず、操作は必要ありません。代わりに Claude にサブエージェントを待機させるには、[Claude にサブエージェントを待機させる](https://code.claude.com/docs/ja/sub-agents.md#let-claude-wait-for-a-subagent)を参照してください。
```

</details>

</details>


<details>
<summary>2026-11-21</summary>

**変更ファイル:**

```
 docs-ja/pages/admin-setup-ja.md                    |  46 ++++++-
 docs-ja/pages/agent-teams-ja.md                    |   2 +-
 docs-ja/pages/agent-view-ja.md                     |   2 -
 docs-ja/pages/artifacts-ja.md                      |  20 +--
 docs-ja/pages/authentication-ja.md                 |  17 ++-
 docs-ja/pages/best-practices-ja.md                 |   2 +-
 docs-ja/pages/changelog.md                         | 145 +++++++++++++++++++++
 docs-ja/pages/claude-code-on-the-web-ja.md         |  15 ++-
 docs-ja/pages/claude-directory-ja.md               |   1 +
 docs-ja/pages/claude-platform-on-aws-ja.md         |   2 +-
 docs-ja/pages/claude-projects-ja.md                |  29 +++--
 docs-ja/pages/cloud-environments-ja.md             |   2 +-
 docs-ja/pages/code-mode-ja.md                      |  27 ++--
 docs-ja/pages/commands-ja.md                       |   2 +-
 docs-ja/pages/desktop-ja.md                        |  14 +-
 docs-ja/pages/devcontainer-ja.md                   |   2 +-
 docs-ja/pages/env-vars-ja.md                       |   4 +-
 docs-ja/pages/errors-ja.md                         |  40 ++++--
 docs-ja/pages/feature-availability-ja.md           |   2 +-
 docs-ja/pages/github-enterprise-server-ja.md       |   2 +-
 docs-ja/pages/glossary-ja.md                       |   6 +-
 docs-ja/pages/goal-ja.md                           |   2 +-
 docs-ja/pages/hooks-guide-ja.md                    |   4 +-
 docs-ja/pages/hooks-ja.md                          |  20 +--
 docs-ja/pages/how-claude-code-works-ja.md          |   2 +-
 docs-ja/pages/interactive-mode-ja.md               |   2 +-
 docs-ja/pages/managed-mcp-ja.md                    |   2 +-
 docs-ja/pages/managed-settings-ja.md               |   5 +-
 docs-ja/pages/mcp-ja.md                            |  22 +++-
 docs-ja/pages/memory-ja.md                         |  14 +-
 docs-ja/pages/microsoft-foundry-ja.md              |   2 +-
 docs-ja/pages/mobile-ja.md                         |   2 +-
 docs-ja/pages/monitoring-usage-ja.md               |   2 +-
 docs-ja/pages/network-config-ja.md                 |   2 +
 docs-ja/pages/permissions-ja.md                    |   4 +-
 docs-ja/pages/platforms-ja.md                      |   6 +-
 docs-ja/pages/prompt-caching-ja.md                 |   2 +-
 docs-ja/pages/quickstart-ja.md                     |  10 +-
 docs-ja/pages/remote-control-ja.md                 |   2 +-
 docs-ja/pages/routines-ja.md                       |   2 +-
 docs-ja/pages/sandboxing-ja.md                     |  36 +++--
 docs-ja/pages/security-guidance-ja.md              |   4 +-
 .../self-hosted-environments-configuration-ja.md   |   4 +-
 docs-ja/pages/server-managed-settings-ja.md        |  13 +-
 docs-ja/pages/settings-reference-ja.md             |  32 ++++-
 docs-ja/pages/setup-ja.md                          |  10 +-
 docs-ja/pages/skills-ja.md                         |  10 +-
 docs-ja/pages/statusline-ja.md                     |   6 +-
 docs-ja/pages/sub-agents-ja.md                     |   6 +-
 docs-ja/pages/troubleshoot-install-ja.md           |   4 +-
 docs-ja/pages/vs-code-ja.md                        |  21 +--
 docs-ja/pages/workflows-ja.md                      |   4 +-
 docs-ja/pages/worktrees-ja.md                      |  10 +-
 53 files changed, 466 insertions(+), 183 deletions(-)
```

<details>
<summary>admin-setup-ja.md</summary>

```diff
diff --git a/docs-ja/pages/admin-setup-ja.md b/docs-ja/pages/admin-setup-ja.md
index 705fed6..2af11a9 100644
--- a/docs-ja/pages/admin-setup-ja.md
+++ b/docs-ja/pages/admin-setup-ja.md
@@ -54,4 +54,6 @@ Claude Code は複数の API プロバイダーのいずれかを通じて Claud
 Claude Code はスタートアップ時に server-managed 設定をフェッチし、セッション中は 1 時間ごとに更新します。デプロイするエンドポイントインフラストラクチャはありません。claude.ai 管理コンソール経由の配信には Claude for Teams または Enterprise プランが必要です。Amazon Bedrock、Google Cloud の Agent Platform、または Microsoft Foundry でのデプロイは、[Claude apps gateway](https://code.claude.com/docs/ja/claude-apps-gateway) を実行することで同じリモート配信を取得できます。または、ファイルベースまたは OS レベルのメカニズムのいずれかを代わりに使用してください。
 
+claude.ai の **Organization settings > Desktop 3P** でプロバイダーまたはゲートウェイを設定している場合は、Enterprise Admin Console ガイドの[どの設定が優先されるか](https://claude.com/docs/third-party/claude-desktop/admin-console-claude-code#which-settings-take-priority)を参照してください。
+
 組織が複数のプロバイダーを混在させている場合、claude.ai ユーザー向けに [server-managed settings](https://code.claude.com/docs/ja/server-managed-settings.md) を設定し、他のユーザーがマネージドポリシーを受け取るように [ファイルベースまたは plist/registry フォールバック](https://code.claude.com/docs/ja/managed-settings.md#delivery-mechanisms)を設定してください。
 
@@ -100,5 +102,7 @@ WSL 2 ユーティリティ VM 内のプロセスは、Windows 側のエンド
 | [claude.ai 同期の無効化](https://code.claude.com/docs/ja/settings-reference.md#syncclaudeaiskills) | 開発者が claude.ai で有効にした[スキル](https://code.claude.com/docs/ja/skills.md#how-synced-skills-behave)と[プラグイン](https://code.claude.com/docs/ja/plugins/loading.md#synced-plugins)を Claude Code が読み込まないようにします。claude.ai で組織の Skills をオフにすると、Claude Code は両方の同期を停止し、v2.1.273 以降では同期済みのものも削除します。Skills をオフにせずにいずれかを停止するには、管理設定でそのキーを `false` に設定します | `syncClaudeAiSkills`、`syncClaudeAiPlugins` |
 | [フックの制限](https://code.claude.com/docs/ja/settings-reference.md#allowmanagedhooksonly) | 実行するフックと HTTP フックの URL を制限します。影響の全一覧は [`allowManagedHooksOnly` で実行されるもの](https://code.claude.com/docs/ja/settings-reference#what-runs-under-allowmanagedhooksonly)を参照してください | `allowManagedHooksOnly`、`allowedHttpHookUrls` |
-| [ログインの強制](https://code.claude.com/docs/ja/settings-reference.md#forceloginmethod) | ログインを特定の方法または Anthropic 組織に制限します。方法の制限は VS Code 拡張機能、Agent SDK、`claude setup-token`、`/install-github-app` 全体に適用されます。`/login` または初回のオンボーディングで表示されるターミナルの対話型ログイン画面では、その方法が事前に選択されますが、強制はされません。Claude Code は、ターミナル、VS Code 拡張機能、Agent SDK での claude.ai アカウントのログインについて組織を検証しますが、Claude Console のログインや[ゲートウェイ](https://code.claude.com/docs/ja/claude-apps-gateway)のサインインについては確認しません。v2.1.212 より前は、いずれのキーもターミナルのログインにのみ適用されていました。設定されている場合、`ANTHROPIC_API_KEY`、`ANTHROPIC_AUTH_TOKEN`、または `apiKeyHelper` で認証されたセッションは起動時にブロックされます。クラウドプロバイダーのセッションは影響を受けませんが、これらの認証情報のいずれか、または以前の Claude Console ログインで保存された API キーも存在する場合は例外としてブロックされます | `forceLoginMethod`、`forceLoginOrgUUID` |
+| [ログイン方法の強制](https://code.claude.com/docs/ja/settings-reference.md#forceloginmethod) | ログインを特定の方法に制限します。この制限は VS Code 拡張機能、Agent SDK、`claude setup-token`、`/install-github-app` 全体に適用されます。`/login` または初回のオンボーディングで表示されるターミナルの対話型ログイン画面で他のログインをブロックする目的で、`claudeai` または `console` の値に頼らないでください。v2.1.212 より前は、このキーまたは `forceLoginOrgUUID` が適用されるのはターミナルのログインのみでした | `forceLoginMethod` |
+| [ログイン組織の強制](https://code.claude.com/docs/ja/settings-reference.md#forceloginorguuid) | ターミナル、VS Code 拡張機能、Agent SDK での claude.ai のログインを自組織に制限します。Claude Console のログインの組織を制限する目的でこのキーに頼らないでください。Claude Code は[ゲートウェイ](https://code.claude.com/docs/ja/claude-apps-gateway)のサインインではこのキーを確認しません | `forceLoginOrgUUID` |
+| [ログインキーがブロックする認証情報](https://code.claude.com/docs/ja/authentication.md#restrict-login-to-your-organization) | いずれかのキーが設定されている場合、`ANTHROPIC_API_KEY`、`ANTHROPIC_AUTH_TOKEN`、または `apiKeyHelper` で認証されたセッションは起動時にブロックされます。クラウドプロバイダーのセッションは、これらの認証情報のいずれか、または以前の Claude Console ログインで保存された API キーも存在する場合を除き、影響を受けません | `forceLoginMethod`、`forceLoginOrgUUID` |
 | [プロバイダーの制限](https://code.claude.com/docs/ja/settings-reference.md#allowedproviders) | マシンが使用できる API プロバイダーを制限します。リストにないプロバイダーのセッションは、起動時、ログイン時、および次に API に接続したときに拒否されます。Claude Code v2.1.285 以降が必要です | `allowedProviders` |
 | [エージェントビューの無効化](https://code.claude.com/docs/ja/agent-view.md#how-background-sessions-are-hosted) | `claude agents`、`--bg`、`/background`、およびオンデマンドのスーパーバイザーをオフにします | `disableAgentView` |
@@ -132,15 +136,49 @@ WSL 2 ユーティリティ VM 内のプロセスは、Windows 側のエンド
 Team プランと Enterprise プランでは、[**Organization settings > Git providers**](https://claude.ai/admin-settings/source-control) の GitHub セクションに、[Claude GitHub App](https://github.com/apps/claude) を通じて Claude 組織にリンクされた GitHub 組織と個人アカウントが一覧表示されます。Claude Code、[Claude Tag](https://claude.com/docs/claude-tag/admins/configure-github)、Claude Security はこの一覧を共有します。このページを開くには、Claude 組織の [Owner ロール](https://code.claude.com/docs/ja/server-managed-settings.md#access-control)が必要です。Admin ロールではこのページを開けません。
 
-アカウントは、Git プロバイダーページから、または GitHub を Claude に接続することでリンクできます。
+デフォルトでは、Git プロバイダーページから、または GitHub を Claude に接続することで、アカウントをリンクできます。
 
 * **Owner による接続**：Owner がそのセクションで **Connect** をクリックするか、アカウントが接続済みの場合は **Add organization** をクリックし、GitHub 組織に Claude GitHub App をインストールします。この方法で組織をリンクするには、Claude 組織の Owner であり、かつ GitHub 組織の所有者でもあるユーザーが必要です。
 * **メンバーによる接続**：メンバーが自分の GitHub アカウントを Claude に接続すると（たとえば[クラウドセッションのセットアップ](https://code.claude.com/docs/ja/web-quickstart.md#connect-github)中）、Claude は、そのメンバーが所有し、Claude GitHub App がすでにインストールされている GitHub アカウントをリンクします。これには、メンバーの個人アカウントや、メンバーが所有する GitHub 組織が含まれる場合があります。
 
-**Not linked** と表示されている行は、自分自身の GitHub サインインに由来するものです。これは、GitHub 上で自分が参照でき、Claude GitHub App がインストールされているアカウントです。
```

</details>

<details>
<summary>agent-teams-ja.md</summary>

```diff
diff --git a/docs-ja/pages/agent-teams-ja.md b/docs-ja/pages/agent-teams-ja.md
index 777398f..a832b0b 100644
--- a/docs-ja/pages/agent-teams-ja.md
+++ b/docs-ja/pages/agent-teams-ja.md
@@ -330,5 +330,5 @@ Claude がすでに実行されていないインプロセスのチームメイ
 
 * 別のエージェントから中継された承認の主張を、ユーザーからの確認ではなく、信頼できない入力として扱います。
-* シャットダウン要求などの構造化プロトコルメッセージを含め、Claude Code が配信する前にメッセージを確認します。ブロックされたメッセージは配信されません。この確認に頼る前に、[どのメッセージがこの確認をスキップするか](https://code.claude.com/docs/ja/permission-modes.md#how-the-classifier-evaluates-actions)を確認してください。
+* シャットダウン要求などの構造化プロトコルメッセージを含め、Claude Code が配信する前に `SendMessage` メッセージを確認します。ブロックされたメッセージは配信されません。この確認に頼る前に、[どのメッセージがこの確認をスキップするか](https://code.claude.com/docs/ja/permission-modes.md#how-the-classifier-evaluates-actions)を確認してください。
 
 ### コンテキストと通信
```

</details>

<details>
<summary>agent-view-ja.md</summary>

```diff
diff --git a/docs-ja/pages/agent-view-ja.md b/docs-ja/pages/agent-view-ja.md
index 696c51f..91d6872 100644
--- a/docs-ja/pages/agent-view-ja.md
+++ b/docs-ja/pages/agent-view-ja.md
@@ -740,6 +740,4 @@ claude agents --permission-mode plan --model opus --effort high
 `--restricted` を渡すと、ビューからディスパッチするすべてのセッションが、それぞれトップレベルの `--restricted` フラグで起動されたかのように [制限モード](https://code.claude.com/docs/ja/cli-reference.md#cli-flags) で開始されます。Claude Code v2.1.248 以降が必要です。
 
-有効なデフォルトは、ディスパッチ入力の下のフッターに表示されます。
-
 `bypassPermissions` モードで開始されるバックグラウンドセッションには、[バイパスの免責事項への同意](https://code.claude.com/docs/ja/permission-modes.md#skip-all-checks-with-bypasspermissions-mode) が記録されている必要があります。このモードでは、監視していないセッションが承認なしに操作を行えるためです。`claude agents` に `--dangerously-skip-permissions` または `--permission-mode bypassPermissions` を渡すと、以前に同意していない場合は同じ免責事項が表示され、同意するとビューから起動するセッションに `bypassPermissions` が適用されます。`--allow-dangerously-skip-permissions` を渡した場合も同じ免責事項が表示され、同意すると、それらのセッションをそのモードで開始せずに、`Shift+Tab` サイクルで `bypassPermissions` を利用可能にします。
 
```

</details>

<details>
<summary>artifacts-ja.md</summary>

```diff
diff --git a/docs-ja/pages/artifacts-ja.md b/docs-ja/pages/artifacts-ja.md
index 42c9099..d1cb0fe 100644
--- a/docs-ja/pages/artifacts-ja.md
+++ b/docs-ja/pages/artifacts-ja.md
@@ -181,9 +181,5 @@ Read the comments on https://claude.ai/code/artifact/5fbea6f3-... and make the c
 ```
 
-Claude がコメントを読めないと言う場合は、バージョン、セッション、フィーチャーフラグ設定を確認してください。
-
-* Claude Code v2.1.221 以降を実行しています。
-* Claude Code をインストールした後、または v2.1.221 より前のバージョンからアップグレードした後の最初のセッションではありません。[インストールまたはアップグレード後の最初のセッション](https://code.claude.com/docs/ja/env-vars.md#first-session-after-an-install-or-upgrade)では、Claude はまだコメントを読めない可能性があります。新しいセッションを開始して、もう一度試してください。
-* フィーチャーフラグ取得をオフにしていません。
+v2.1.326 より前のバージョンでは、Claude がコメントを読んだり監視したりするには、[フィーチャーフラグ取得](https://code.claude.com/docs/ja/env-vars.md#features-that-need-feature-flag-fetching)がオンになっている必要があります。
 
 ### Claude にコメントに自動で返信させる
@@ -191,5 +187,5 @@ Claude がコメントを読めないと言う場合は、バージョン、セ
 セッションがアーティファクトを公開した後、Claude Code はそのアーティファクトのコメントを監視します。アーティファクトを編集できるユーザーが Claude にコメントを送信すると、すぐにセッションに到達し、Claude はスレッドを読んで、ユーザーが依頼しなくても返信できます。
 
-Claude Code v2.1.228 以降が必要です。[フィーチャーフラグ取得](https://code.claude.com/docs/ja/env-vars.md#features-that-need-feature-flag-fetching)をオフにした場合、Claude Code はコメントを監視しません。
+Claude Code v2.1.228 以降が必要です。
 
 [権限モード](https://code.claude.com/docs/ja/permission-modes.md)によって、送信されたコメントが到着したときに Claude が何をするかが決まります。
@@ -223,5 +219,5 @@ Build a dashboard artifact of our open pull requests that pulls the live list th
 ```
 
-Claude は公開処理の一環として、ページが呼び出せるコネクタを宣言します。ページはその宣言に含まれないコネクタを呼び出せません。対象となるのは claude.ai アカウントのコネクタのみです。Claude が宣言でそれらを指定し、誰かがページを閲覧すると、各呼び出しはそのコネクタに対する[閲覧しているアカウント自身の接続を通じて実行されます](#how-connector-calls-work-for-viewers)。`.mcp.json` のサーバーなど、Claude Code で設定したローカルの MCP サーバーは、Claude がページを作成する間はデータを提供できますが、公開されたページからは呼び出せません。
+claude.ai アカウントのコネクタを使用してください。`.mcp.json` のサーバーなど、Claude Code で設定したローカルの MCP サーバーは、Claude がページを作成する間はデータを提供できますが、公開されたページからは呼び出せません。
 
 ページは読み込み時にデータを取得し、一定間隔で、または閲覧者がページ上の更新コントロールを使ったときに再取得できます。レスポンスは閲覧者のブラウザにキャッシュされるため、再度開いたページはキャッシュされたレスポンスからすぐに描画され、その後新しい結果で更新されます。
@@ -229,5 +225,5 @@ Claude は公開処理の一環として、ページが呼び出せるコネク
```

</details>

<details>
<summary>authentication-ja.md</summary>

```diff
diff --git a/docs-ja/pages/authentication-ja.md b/docs-ja/pages/authentication-ja.md
index b951a36..7b7225e 100644
--- a/docs-ja/pages/authentication-ja.md
+++ b/docs-ja/pages/authentication-ja.md
@@ -27,6 +27,7 @@ Claude Code は、セットアップに応じて複数の認証方法をサポ
 * **Claude for Teams または Enterprise**: チーム管理者が招待した claude.ai アカウントでログインします。
 * **Claude Console**: Console 認証情報でログインします。管理者が事前に[招待](#claude-console-authentication)している必要があります。[API キーを作成せずにサインイン](#sign-in-without-an-api-key)することも、API キーを作成することもできます。
-* **クラウドプロバイダー**: 組織が [Amazon Bedrock](https://code.claude.com/docs/ja/amazon-bedrock.md)、[Google Cloud の Agent Platform](https://code.claude.com/docs/ja/google-vertex-ai.md)、または [Microsoft Foundry](https://code.claude.com/docs/ja/microsoft-foundry.md) を使用している場合は、`claude` を実行する前に必要な環境変数を設定するか、ログインプロンプトで **3rd-party platform** を選択してください。これにより、Bedrock と Vertex AI 向けのインタラクティブセットアップウィザードが起動します。ブラウザログインは不要です。
+* **クラウドプロバイダー**: 組織が [Amazon Bedrock](https://code.claude.com/docs/ja/amazon-bedrock.md)、[Google Cloud の Agent Platform](https://code.claude.com/docs/ja/google-vertex-ai.md)、または [Microsoft Foundry](https://code.claude.com/docs/ja/microsoft-foundry.md) を使用している場合は、`claude` を実行する前に必要な環境変数を設定します。ログインプロンプトで **3rd-party platform** を選択することもでき、これにより Bedrock と Agent Platform 向けのインタラクティブセットアップウィザードが起動します。
 * **Cloud gateway**: 組織がセルフホストされた [Claude apps gateway](https://code.claude.com/docs/ja/claude-apps-gateway) を実行している場合は、`/login` を通じて、または [VS Code から](https://code.claude.com/docs/ja/vs-code.md#sign-in-to-a-claude-apps-gateway)企業 SSO でサインインします。ゲートウェイが発行したトークンはセッションの唯一の認証情報です。
+* **Enterprise Admin Console**: Owner が組織のプロバイダーまたはゲートウェイに対して[このサインインを有効にしている](https://claude.com/docs/third-party/claude-desktop/admin-console-claude-code#turn-on-sign-in-from-claude-code)場合は、シェルで `claude auth login` を実行し、ブラウザで組織を選択します。確認するには、ターミナルに `Signed in to the organization` と表示されているかを確認してください。必要な Claude Code のバージョンについては、[始める前に](https://claude.com/docs/third-party/claude-desktop/admin-console-claude-code#before-you-start)を参照してください。
 
 管理者は、どのログイン方法を開発者が使用するかを指定し、claude.ai ログインが特定の組織に属することを要求できます。[ログインを組織に制限する](#restrict-login-to-your-organization)を参照してください。
@@ -125,5 +126,5 @@ API キーを作成しなくても Console アカウントにサインインで
 実際には、プロファイルは OAuth ログインを保存し、API キーは静的な認証情報です。Claude Code はプロファイルのログインを自動的に更新し、更新に失敗すると、再度サインインするまで [Anthropic プロファイルログイン期限切れ](https://code.claude.com/docs/ja/errors.md#anthropic-profile-login-expired) でリクエストが失敗します。
 
-すべてのマシンで選択肢が得られるわけではありません。Claude Code は以下の場合、確認なしに API キーを作成します。
+以下の場合、キーレスのオプションは表示されません。
 
 * Amazon Bedrock、Google Cloud の Agent Platform、Microsoft Foundry などの [クラウドプロバイダーに対して実行](https://code.claude.com/docs/ja/third-party-integrations.md)するか、[AWS 上の Claude Platform](https://code.claude.com/docs/ja/claude-platform-on-aws.md) に対して実行する
@@ -172,9 +173,13 @@ Amazon Bedrock、Google Cloud の Agent Platform、または Microsoft Foundry 
 開発者の claude.ai ログインが特定の Anthropic 組織に属することを要求するには、[管理設定](https://code.claude.com/docs/ja/managed-settings.md)で [`forceLoginMethod`](https://code.claude.com/docs/ja/settings-reference#forceloginmethod) と [`forceLoginOrgUUID`](https://code.claude.com/docs/ja/settings-reference#forceloginorguuid) を設定します。`forceLoginOrgUUID` を組織 ID に設定します。組織 ID は Claude for Teams または Enterprise 組織の [claude.ai 管理設定](https://claude.ai/admin-settings/organization)に表示されます。Claude Code は他の組織への claude.ai ログインについてエラーを報告し、使用中の claude.ai 認証情報がリストされていない組織に属している場合、起動時に終了します。
 
-Claude Console ログインの場合、Claude Code は `forceLoginOrgUUID` を使用して、単一の Console 組織 ID に設定した場合、Console サインインページで組織を事前選択します。組織 ID は [platform.claude.com/settings/organization](https://platform.claude.com/settings/organization) に表示されます。ログイン時または起動時に、結果の Console 認証情報がどの組織に属しているかを確認しません。キーをデプロイする前に Console アカウントでログインした開発者はログインしたままになり、その保存されたキーは [ゲートウェイ](https://code.claude.com/docs/ja/claude-apps-gateway)サインインも必要とするマシン上、またはクラウドプロバイダーを選択するセッション内でブロックされます。
+`forceLoginOrgUUID` を単一の Console 組織 ID に設定した場合、Claude Code は Claude Console のサインインページでその組織を事前選択します。組織 ID は [platform.claude.com/settings/organization](https://platform.claude.com/settings/organization) で確認できます。
 
-任意の設定ファイルで `forceLoginOrgUUID` を設定した場合、Claude Code はそのファイルが適用されるセッションで [キーレス Console サインイン](#sign-in-without-an-api-key)の提供を停止し、代わりに API キーを作成します。開発者を claude.ai サインインに向かわせるには、`forceLoginMethod` を `"claudeai"` に設定します。
+> [!NOTE]
+>
+> 起動時に、Claude Code は保存済みの Console 認証情報がどの組織に属しているかを確認しません。Console ログインの組織を制限する目的で `forceLoginOrgUUID` に頼らないでください。`forceLoginMethod` または `forceLoginOrgUUID` をデプロイした後も、既に Console にログインしている開発者はログインしたままになります。ただし、保存済みの Console API キーは、[ゲートウェイ](https://code.claude.com/docs/ja/claude-apps-gateway)サインインも必要とするマシン上、またはクラウドプロバイダーを選択するセッション内ではブロックされます。
```

</details>

<details>
<summary>best-practices-ja.md</summary>

```diff
diff --git a/docs-ja/pages/best-practices-ja.md b/docs-ja/pages/best-practices-ja.md
index 4d8f3c5..3422d26 100644
--- a/docs-ja/pages/best-practices-ja.md
+++ b/docs-ja/pages/best-practices-ja.md
@@ -400,5 +400,5 @@ use a subagent to review the rate limiter diff against SPEC.md, check every requ
 auto モードがアクションをブロックすると通知が届き、そのアクションは `/permissions` の **Recently blocked** に表示されます。そこで[アクションを承認して Claude が再試行できるようにする](https://code.claude.com/docs/ja/auto-mode-config.md#review-denials)ことができます。[3 回連続](https://code.claude.com/docs/ja/permission-modes.md#when-auto-mode-falls-back)（または合計 20 回）ブロックされると、auto モードは一時停止し、ユーザーに確認する方式に戻ります。
 
-これは決定論的な制御に取って代わるものではありません。それらの*後*に実行されるからです。拒否ルール、確認ルール、`PreToolUse` フックは分類器が何かを見る前に適用されるため、拒否ルールは auto モードでも他のすべての場所とまったく同じようにブロックします。サンドボックスも引き続き、[ラップするシェルコマンド](https://code.claude.com/docs/ja/sandboxing.md#what-runs-outside-the-sandbox)を制限します。
+サンドボックスは引き続き、[ラップするシェルコマンド](https://code.claude.com/docs/ja/sandboxing.md#what-runs-outside-the-sandbox)を制限します。
 
 > [!NOTE]
```

</details>

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index e64de47..169c78c 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,149 @@
 # Changelog
 
+## 2.1.330
+
+- Added sign-in to organizations managed in Anthropic's Enterprise Admin Console: after `claude auth login`, Claude Code applies the organization's settings and uses its cloud provider or gateway
+- Added easel, a built-in mod that draws charts when asked and under MCP metrics results, on Pro, Max and, where available, Team and Enterprise on macOS and Linux; turn automatic charts off in `/config`
+- Added `CLAUDE_CODE_FULL_SIGN_IN_LINK=1` to print the full sign-in link, if the short one shows an error or a script reads values from it
+- Self-hosted runner: Added `--start-dir` / `SELF_HOSTED_RUNNER_START_DIR` to have Claude start its work in a folder of a repository, while settings and hooks load as without it
+- Added a notice in cloud and self-hosted runner sessions when a plugin marketplace can't be fetched because its repository isn't one of the session's
+- Self-hosted runner: Added a notice when Anthropic-managed git refuses a plugin's own repository, naming the plugin and what to do
+- Added `commandPrinted` to `claude plugin install --json` results, true when the plugin's install command wrote to stderr, and `commandFailed` when it exited with an error, was killed or timed out
+- Added `claude_code_self_hosted_runner_order_to_registered_seconds` to the self-hosted runner's `/metrics`: seconds from work order issued to registration accepted, on orchestrator-spawned runners
+- Added `claude_code_self_hosted_runner_order_to_first_session_seconds` to the self-hosted runner's `/metrics`: seconds from work order to first session handed over, on runners started for a session
+- Fixed Claude Code freezing for up to several minutes right after compacting a very long conversation
+- Fixed WebFetch freezing the session for minutes on some pages, and returning an empty result for some others
+- Fixed `ExitWorktree` and the worktree exit dialog deleting a worktree that another running Claude Code session was working in
+- Fixed changes to user settings being lost when several Claude Code processes saved them at the same time
+- Fixed `--continue` and `--resume` opening an empty session or failing when the last saved message had a missing or invalid timestamp
+- Fixed the first prompt after a sleep of two minutes or more waiting three minutes on a connection that had died, on Linux and WSL
+- Fixed turns failing with "JSON schema is invalid", and session files growing by many megabytes, when many MCP tools have an input schema that the API refuses
+- Linux: Fixed Bash commands waiting seconds and showing no file diff for the rest of a session in slow repositories with large ignored folders such as `node_modules`
+- Windows: Fixed Bash commands running slower for the rest of a session after Git Bash took 10 to 60 seconds to start, on machines with no custom start-up files
+- Fixed `/rewind` sometimes restoring an older version of a file when two queued prompts, or stacked skills, ran together right after a turn that changed it
+- Fixed text and images added when approving a permission prompt being dropped when the approved command or tool then failed
+- Fixed MCP resources from claude.ai connectors and plugin servers not being attached when @-mentioned in the terminal's prompt box
```

</details>

<details>
<summary>claude-code-on-the-web-ja.md</summary>

```diff
diff --git a/docs-ja/pages/claude-code-on-the-web-ja.md b/docs-ja/pages/claude-code-on-the-web-ja.md
index 17e1453..1d33a8a 100644
--- a/docs-ja/pages/claude-code-on-the-web-ja.md
+++ b/docs-ja/pages/claude-code-on-the-web-ja.md
@@ -204,5 +204,5 @@ View: https://claude.ai/code/session_01HJKLMNOPQRSTUVWXYZ?from=cli&m=0
 次のいずれかの方法で、クラウドセッションをターミナルに取り込みます。
 
-* **`--teleport` を使用する**: コマンドラインから `claude --teleport` を実行すると対話型のセッション選択画面が開き、`claude --teleport <session-id>` を実行すると特定のセッションを直接再開できます。コミットされていない変更がある場合は、先に stash するよう求められます。[`--resume`](https://code.claude.com/docs/ja/sessions#resume-a-session) はこのマシンのローカル履歴から会話を再開するもので、クラウドセッションは一覧に表示されません。
+* **`--teleport` を使用する**: コマンドラインから `claude --teleport` を実行すると対話型のセッション選択画面が開き、`claude --teleport <session-id>` を実行すると特定のセッションを直接再開できます。[`--resume`](https://code.claude.com/docs/ja/sessions#resume-a-session) はこのマシンのローカル履歴から会話を再開するもので、クラウドセッションは一覧に表示されません。
 * **`/teleport` を使用する**: 既存の CLI セッション内で `/teleport` または `/tp` を実行すると、Claude Code を再起動せずに同じセッション選択画面を開けます。
 * **`/tasks` から**: `/tasks` を実行してバックグラウンドセッションを表示し、`t` を押してセッションに teleport します。
@@ -210,5 +210,5 @@ View: https://claude.ai/code/session_01HJKLMNOPQRSTUVWXYZ?from=cli&m=0
 * **クラウドセッション内から**: `/teleport` と入力すると、Claude Code がそのセッション用の正確な `claude --teleport <session-id>` コマンドを返します。このコマンドはリポジトリのチェックアウトからすぐに実行できます。
 
-セッションを teleport すると、Claude は正しいリポジトリにいることを確認し、クラウドセッションのブランチをフェッチしてチェックアウトし、会話をターミナルに読み込みます。
+セッションを teleport すると、Claude は正しいリポジトリにいることを確認し、会話をターミナルに読み込みます。セッションのブランチも取得するには、[要件](#teleport-requirements)を確認してから `claude --teleport` を実行してください。
 
 > [!NOTE]
@@ -220,11 +220,11 @@ View: https://claude.ai/code/session_01HJKLMNOPQRSTUVWXYZ?from=cli&m=0
 #### Teleport の要件
 
-Teleport は、セッションを再開する前に以下の要件を確認します。いずれかの要件が満たされていない場合は、エラーが表示されるか、問題の解決を求められます。
+セッションを teleport する前に、以下の要件を確認してください。
 
 | 要件 | 詳細 |
 | - | - |
-| クリーンな Git の状態 | 作業ディレクトリにコミットされていない変更があってはなりません。必要に応じて、Teleport が変更を stash するよう求めます。 |
+| クリーンな Git の状態 | 先に変更をコミットするか、Teleport に求められたときに stash してください。 |
 | 正しいリポジトリ | `--teleport` は、フォークではなく同じリポジトリのチェックアウトから実行する必要があります。別のリポジトリのチェックアウトから実行すると、Claude Code はセッションのリポジトリとチェックアウトのリポジトリの両方を示すエラーを表示します。`git@work:owner/repo.git` のような SSH ホストエイリアスなど、Claude Code がリモートをホスト名に解析できない場合は確認を求め、リモートのオーナーとリポジトリ名がセッションのリポジトリと一致すればそのチェックアウトを受け入れます。 |
-| ブランチが利用可能 | クラウドセッションのブランチがリモートにプッシュされている必要があります。Teleport は自動的にそれをフェッチしてチェックアウトします。 |
```

</details>

*...以降省略*

</details>


<details>
<summary>2026-11-20</summary>

**変更ファイル:**

```
 docs-ja/pages/agent-view-ja.md                     |   4 +-
 docs-ja/pages/artifacts-ja.md                      |   4 +-
 docs-ja/pages/authentication-ja.md                 |  14 +-
 docs-ja/pages/best-practices-ja.md                 |   4 +-
 docs-ja/pages/changelog.md                         | 133 ++++
 docs-ja/pages/channels-ja.md                       |   2 +-
 docs-ja/pages/channels-reference-ja.md             |   2 +-
 docs-ja/pages/checkpointing-ja.md                  |   2 +-
 docs-ja/pages/chrome-ja.md                         |   2 +-
 docs-ja/pages/claude-apps-gateway-deploy-ja.md     |   6 +-
 docs-ja/pages/claude-code-on-the-web-ja.md         |  16 +-
 docs-ja/pages/claude-directory-ja.md               |   2 +-
 docs-ja/pages/cli-reference-ja.md                  |   8 +-
 docs-ja/pages/cloud-environments-ja.md             |   4 +-
 docs-ja/pages/code-mode-ja.md                      | 139 ++++-
 docs-ja/pages/code-review-setup-ja.md              |   4 +-
 docs-ja/pages/commands-ja.md                       |   6 +-
 docs-ja/pages/common-workflows-ja.md               |   2 +-
 docs-ja/pages/computer-use-ja.md                   |  10 +-
 docs-ja/pages/costs-ja.md                          |   6 +-
 docs-ja/pages/cross-session-messaging-ja.md        |   4 +-
 docs-ja/pages/desktop-ios-simulator-ja.md          |   8 +-
 docs-ja/pages/desktop-ja.md                        |  59 +-
 docs-ja/pages/devcontainer-ja.md                   |   2 +-
 docs-ja/pages/env-vars-ja.md                       |   8 +-
 docs-ja/pages/errors-ja.md                         |  72 +--
 docs-ja/pages/feature-availability-ja.md           |   2 +-
 docs-ja/pages/github-actions-ja.md                 |   6 +-
 docs-ja/pages/glossary-ja.md                       |   2 +-
 docs-ja/pages/goal-ja.md                           |   2 +-
 docs-ja/pages/headless-ja.md                       |   4 +-
 docs-ja/pages/hooks-ja.md                          |  38 +-
 docs-ja/pages/interactive-mode-ja.md               |   2 +-
 docs-ja/pages/keybindings-ja.md                    |   2 +-
 docs-ja/pages/large-codebases-ja.md                |   2 +-
 docs-ja/pages/llm-gateway-rollout-ja.md            |   4 +-
 docs-ja/pages/managed-mcp-ja.md                    |   2 +-
 docs-ja/pages/managed-settings-ja.md               |   9 +-
 docs-ja/pages/mcp-ja.md                            |   8 +-
 docs-ja/pages/mcp-quickstart-ja.md                 |   4 +-
 docs-ja/pages/mobile-ja.md                         |   4 +-
 docs-ja/pages/model-config-ja.md                   |  18 +-
 docs-ja/pages/monitoring-usage-ja.md               | 670 ++++++++++-----------
 docs-ja/pages/network-config-ja.md                 |   6 +-
 docs-ja/pages/permission-modes-ja.md               |  27 +-
 docs-ja/pages/permissions-ja.md                    |  37 +-
 docs-ja/pages/prompt-caching-ja.md                 |   2 +-
 docs-ja/pages/quickstart-ja.md                     |  14 +-
 docs-ja/pages/remote-control-ja.md                 |  30 +-
 docs-ja/pages/routines-ja.md                       |   6 +-
 docs-ja/pages/sandbox-environments-ja.md           |  10 +-
 docs-ja/pages/sandboxing-ja.md                     |   8 +-
 docs-ja/pages/scheduled-tasks-ja.md                |   6 +-
 docs-ja/pages/security-ja.md                       |   7 +-
 .../self-hosted-environments-configuration-ja.md   |   5 +-
 .../pages/self-hosted-environments-deploy-ja.md    |   7 +-
 .../pages/self-hosted-environments-reference-ja.md |   4 +
 .../pages/self-hosted-environments-testing-ja.md   |   2 +-
 docs-ja/pages/server-managed-settings-ja.md        |   2 +-
 docs-ja/pages/sessions-ja.md                       |  13 +-
 docs-ja/pages/settings-ja.md                       |   6 +-
 docs-ja/pages/settings-reference-ja.md             |  48 +-
 docs-ja/pages/skills-ja.md                         |   6 +-
 docs-ja/pages/sub-agents-ja.md                     |  28 +-
 docs-ja/pages/terminal-config-ja.md                |   5 +-
 docs-ja/pages/third-party-integrations-ja.md       |   2 +-
 docs-ja/pages/tools-reference-ja.md                |  15 +-
 docs-ja/pages/troubleshoot-install-ja.md           |   8 +-
 docs-ja/pages/voice-dictation-ja.md                |  12 +-
 docs-ja/pages/web-quickstart-ja.md                 |   8 +-
 70 files changed, 970 insertions(+), 656 deletions(-)
```

<details>
<summary>agent-view-ja.md</summary>

```diff
diff --git a/docs-ja/pages/agent-view-ja.md b/docs-ja/pages/agent-view-ja.md
index 4cf2176..696c51f 100644
--- a/docs-ja/pages/agent-view-ja.md
+++ b/docs-ja/pages/agent-view-ja.md
@@ -226,5 +226,5 @@ Completed
 * 選択肢が用意された質問：パネルには選択肢が番号付きで表示されます。返信入力が空の状態で選択肢の番号を押すと入力され、`Enter` で送信できます。または、代わりに独自の回答を入力します
 * 選択肢のない質問：回答を入力します。空の入力に返信の候補が表示されている場合は、`Tab` を押して入力し、送信前に編集できます
-* 権限プロンプトまたはその他のダイアログ（[サンドボックス](https://code.claude.com/docs/ja/sandboxing.md) プロンプトや MCP サーバーの [入力リクエスト](https://code.claude.com/docs/ja/mcp.md#respond-to-mcp-elicitation-requests) など）：返信してもダイアログには答えられません。返信はキューで待機します。ダイアログに答えるには、`→` でアタッチします
+* 権限プロンプトまたはその他のダイアログ（[サンドボックス](https://code.claude.com/docs/ja/sandboxing.md) プロンプトや MCP サーバーの [入力リクエスト](https://code.claude.com/docs/ja/mcp.md#respond-to-mcp-elicitation-requests) など）：返信してもダイアログには答えられません。ダイアログに答えるには、返信入力が空の状態で `→` でアタッチします
 
 [`PermissionRequest`](https://code.claude.com/docs/ja/hooks#permissionrequest) または [`PreToolUse`](https://code.claude.com/docs/ja/hooks#pretooluse) フックが、セッションが尋ねている呼び出しについて Claude Code が検証できない出力を返した場合、行には保留中のリクエストのテキストの前に、フックイベントと `hook output invalid:` および検証エラーが表示されます。別の形で失敗したフックの場合、行にはフックが失敗したことが表示されます。セッションは引き続き同じリクエストで待機します。
@@ -264,5 +264,5 @@ Windows では、アタッチしてから約 0.5 秒以内に `←` を押すと
 フォアグラウンドで実行しているセッション、つまりエージェントビューからアタッチするのではなくターミナルで開始したセッションでは、空のプロンプトで `←` を押すとセッションがバックグラウンドになり、その行が選択された状態でエージェントビューが開くため、ターミナルを離れずにセッションを切り替えられます。同じ 1 回の押下で、アタッチされたセッションはデタッチされます。
 
-プロンプトのテキストの最後の文字を削除した直後、またはプロンプト履歴を移動した直後に `←` を押すと、Claude Code は確認を求めます。最初の押下では `Press ← again to open agents`（アタッチされたセッションでは `Press ← again to go back to agents`）が表示され、2 回目の押下で切り替わります。
+プロンプトのテキストの最後の文字を削除した直後、またはプロンプト履歴を移動した直後に `←` を押すと、Claude Code は確認を求めます。切り替えるには `←` を再度押します。
 
 `←` でセッションをバックグラウンドにした後：
```

</details>

<details>
<summary>artifacts-ja.md</summary>

```diff
diff --git a/docs-ja/pages/artifacts-ja.md b/docs-ja/pages/artifacts-ja.md
index e46cefd..42c9099 100644
--- a/docs-ja/pages/artifacts-ja.md
+++ b/docs-ja/pages/artifacts-ja.md
@@ -209,5 +209,5 @@ Claude は、1 時間以内にそのアーティファクトで 60 件の送信
 * **3 秒以内に `Ctrl+X Ctrl+K` を 2 回押す**：[すべての実行中のバックグラウンドサブエージェントを停止](https://code.claude.com/docs/ja/interactive-mode.md#general-controls)するコードは、セッションの残りの間、Claude がすべてのアーティファクトに返信するのも停止します。Claude に返信を再開するよう求めても、この停止は元に戻りません。
 
-Claude Code が自動で開始した監視は、アーティファクトで数時間アクティビティがない状態が続くと終了することがあります。監視を再開するには、アーティファクトを再度公開するか、Claude に監視するよう依頼してください。
+Claude Code が自動で開始した監視は、アーティファクトで数時間アクティビティがない状態が続くと終了することがあります。`Stopped watching Artifact: <name> (idle)` が表示されます。監視を再開するには、アーティファクトを再度公開するか、Claude に監視するよう依頼してください。`(idle)` の代わりに `(made room for a newer watch)` が表示される場合は、セッションが監視の上限である 25 件に達しています。その監視を再開するには、再度公開してください。
 
 コメントを配信するサービスが利用できなくなるか、応答を停止した場合、Claude Code はしばらく再接続を試み、その後、セッションが監視していた各アーティファクトの監視を停止します。
@@ -424,5 +424,5 @@ Team プランと Enterprise プランのオーナーは、[claude.ai 管理設
 公開共有は Team プランと Enterprise プランではデフォルトでオフになっています。メンバーがサインインなしで誰でも表示できるパブリックリンクにアーティファクトを公開できるようにするには、[**Organization settings > Artifacts**](https://claude.ai/admin-settings/artifacts)に移動して、**Artifacts** トグルの下の **External sharing** をオンにします。オフに戻すと、各アーティファクトのオーディエンスを変更することなく、既存のパブリックリンク経由のアクセスがブロックされます。再度有効にすると、アクセスが再開されます。
 
-### 保持ポリシーを設定する
+### Enterprise プランで保持ポリシーを設定する
 
 アーティファクトが自動削除される前に保持される期間を設定するには、[**Organization settings > Data and privacy**](https://claude.ai/admin-settings/data-privacy-controls)に移動します。作成者にのみプライベートなアーティファクトと共有されたアーティファクトに対して、別々の保持期間を設定できます。
```

</details>

<details>
<summary>authentication-ja.md</summary>

```diff
diff --git a/docs-ja/pages/authentication-ja.md b/docs-ja/pages/authentication-ja.md
index ccbacd5..b951a36 100644
--- a/docs-ja/pages/authentication-ja.md
+++ b/docs-ja/pages/authentication-ja.md
@@ -230,7 +230,19 @@ Claude Code は認証情報を安全に管理します。
 `apiKeyHelper`、`ANTHROPIC_API_KEY`、および `ANTHROPIC_AUTH_TOKEN` は CLI およびそれをラップするサーフェス（VS Code 拡張機能、Agent SDK、GitHub Actions を含む）に適用されます。Claude Desktop とクラウドセッションは `apiKeyHelper` を呼び出したり、これらの環境変数を読み込んだりしません。OAuth を使用します。ただし、[サードパーティ推論設定](https://code.claude.com/docs/ja/llm-gateway-connect.md#desktop-app)を実行しているデスクトップセッションは、その設定の認証情報で認証します。
 
+### 保存されたログインの終了日を確認する
+
+使用している claude.ai ログインがいつ終了するかを確認するには、シェルで `claude auth status --text` を実行します。Claude Code v2.1.318 以降では、`Sign-in` で始まる行を確認してください。
+
+```text theme={null}
+Sign-in ends: between 2026-11-20 and 2026-11-23 (2026-11-23T17:04:11.000Z)
+```
+
+早い方の日付より前に、`/login` または `claude auth login` を使用してブラウザで再度サインインしてください。Claude Code を使用してもログインは延長されません。行に `any day now` または `may have ended` と表示されている場合は、今すぐサインインしてください。他の認証情報の場合や日付が不明な場合、この行は表示されません。
+
+遅い方の日付まで 10 日を切ると、テキスト出力で実行した `claude -p` は stderr に `Warning: this sign-in` を出力します。そのため、早い方の日付より前に再度サインインしてください。
+
 ### 期限切れ間近のログインを更新する
 
-`/login` で作成したログインが期限切れまで 3 日以内になると、Claude Code はスタートアップ時に警告を表示します。`Your login expires in 3 days · run /login to renew`。
+ログインの[2 つの終了日](#check-when-a-stored-login-ends)のうち早い方の日付から、Claude Code はスタートアップ時に警告を表示します。`Your login expires in 3 days · run /login to renew`。
 
 `/login` を実行して更新します。警告は claude.ai ログインがアクティブな認証情報である場合にのみ表示されます。
```

</details>

<details>
<summary>best-practices-ja.md</summary>

```diff
diff --git a/docs-ja/pages/best-practices-ja.md b/docs-ja/pages/best-practices-ja.md
index bad69db..4d8f3c5 100644
--- a/docs-ja/pages/best-practices-ja.md
+++ b/docs-ja/pages/best-practices-ja.md
@@ -305,5 +305,5 @@ use a subagent to review the rate limiter diff against SPEC.md, check every requ
 * モデルに判断させる [`prompt` または `agent` フック](https://code.claude.com/docs/ja/hooks#hook-handler-fields)
 
-`prompt` または `agent` フックは*別のモデル*に判断を求めるため、これも決定論的ではありません。本当の意味で強制するには `command` または `http` フックを使い、フック自体がクラッシュしたりタイムアウトしたりした場合にもアクションを止めるべきなら [`onFailure: "block"`](https://code.claude.com/docs/ja/hooks#block-the-action-when-a-hook-fails) を追加します。例えばコミットに含まれるシークレットをスキャンするフックなら、スキャナーが停止している間にスキャンされないままコミットを通すより、コミットをブロックしたほうがよいでしょう。
+`prompt` または `agent` フックは*別のモデル*に判断を求めるため、これも決定論的ではありません。本当の意味で強制するには `command`、`http`、または `mcp_tool` フックを使い、フック自体がクラッシュしたりタイムアウトしたりした場合にもアクションを止めるべきなら [`onFailure: "block"`](https://code.claude.com/docs/ja/hooks#block-the-action-when-a-hook-fails) を追加します。例えばコミットに含まれるシークレットをスキャンするフックなら、スキャナーが停止している間にスキャンされないままコミットを通すより、コミットをブロックしたほうがよいでしょう。
 
 以下はフォーマッタールールを `PostToolUse` フックにしたものです。すべての `Edit` または `Write` の後に実行され、実行するのは Claude ではないため、Claude がルールを覚えているかどうかはもはや関係ありません：
@@ -544,5 +544,5 @@ Claude に `have the reviewer compare the rate limiter against SPEC.md` と依
 スクリプトでは、ほぼ必ず追加のフラグがいくつか必要になります：
 
-* [`--bare`](https://code.claude.com/docs/ja/headless#start-faster-with-bare-mode) は、フック、スキル、プラグイン、MCP サーバー、`CLAUDE.md` ファイル（リポジトリのものもマシンのものも）をスキップするため、どこで実行しても同じ動作になります。また、claude.ai のログインには一切触れません。認証は `ANTHROPIC_API_KEY`、`--settings` で渡すファイル内の `apiKeyHelper`、またはクラウドプロバイダーの認証情報から取得します。
+* [`--bare`](https://code.claude.com/docs/ja/headless#start-faster-with-bare-mode) は、フック、スキル、プラグイン、MCP サーバー、およびリポジトリとホームディレクトリにある `CLAUDE.md` ファイルをスキップします。また、claude.ai のログインも使用しません。認証は `ANTHROPIC_API_KEY`、`--settings` で渡すファイル内の `apiKeyHelper`、またはクラウドプロバイダーの認証情報から取得します。
 * `--append-system-prompt`、`--mcp-config`、`--settings` は、その実行で*実際に*必要なものを明示的に渡します。`--settings` で渡したフックは [`--bare` では実行されない](https://code.claude.com/docs/ja/headless#start-faster-with-bare-mode)ため、フックを必要とする実行では `--bare` を使わないでください。
 * `--allowedTools` はツールを事前承認し、[`--permission-mode dontAsk`](https://code.claude.com/docs/ja/permission-modes#allow-only-pre-approved-tools-with-dontask-mode) はそれ以外で確認が必要になるものをすべて拒否します。
```

</details>

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index def4645..e64de47 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,137 @@
 # Changelog
 
+## 2.1.329
+
+- Added a trust dialog warning that says where a folder's hooks are declared
+- Added a warning in the conversation, in Claude Desktop and other non-interactive hosts, when hooks in managed settings fail to load
+- Added this session's scheduled tasks, `/loop` wakeups, the goal and this conversation's forks to `/tasks`; x stops one after asking
+- Added a "Server message" row to a server's page in `/mcp` that shows the JSON-RPC error message of a remote HTTP MCP server that refuses the connection
+- Added a "Marketplace auto-update" row to `/status` that names managed marketplaces that get no automatic updates, and why
+- Added support for turning on Code Mode while OpenTelemetry events and metrics are enabled; each tool call the code makes sends its events; tracing still keeps it off
+- Fixed `~/.claude.json` sometimes being reset to defaults when a network stall or file lock made it unreadable and cleared during a save
+- Fixed repeated sign-outs on macOS when Claude Code could read the Keychain but not save to it. That session now stops at expiry and says why, and other sessions stay signed in
+- Fixed `/terminal-setup` corrupting VS Code settings or keybindings files around block comments, and reporting success while losing the Shift+Enter binding where keybindings.json has an unclosed string
+- Fixed files accepted through the IDE diff being saved without their last newline, and losing their byte order mark (BOM) when an edit was accepted by saving the diff in VS Code
+- Fixed picking a cloud session in `/teleport` replacing your open conversation: the pick now starts a new session, as `/clear` does, and `/resume` brings the old one back
+- Fixed `/usage-credits` asking Pro and Max users to log in again after opening the browser, and the link disappearing after 8 seconds if the browser doesn't open and a task stops for usage credits
+- Fixed `/usage` saying usage credits are off when they had run out or reached the monthly limit, and `/model` not telling Pro and Max users when that limit blocks a model that runs on usage credits
+- Fixed the spend limit menu showing your spend as your monthly limit and wrapping its rows under the pointer in narrow windows
+- Fixed a status line script that prints without end freezing the prompt and using gigabytes of memory
+- Fixed an empty, frozen screen after approving managed settings while the --resume picker, the trust dialog or another set-up screen was waiting
+- Fixed choosing Default in `/model` replacing your saved model with your organization's default when the Default row already showed your saved model
+- Fixed an MCP server being signed in again after you cleared its authentication while a token refresh was running
+- Fixed background MCP tasks that stalled after a slow reconnect: Claude Code now reconnects most HTTP MCP servers by itself when one is left on an older protocol version
+- Fixed PDFs, images and `.docx`, `.xlsx` or `.pptx` files that MCP servers or websites send as `application/octet-stream` being saved as .bin, which kept Claude from reading the PDFs and images
+- Fixed `/code-review <pr number>` sometimes reviewing the checked-out branch instead of the pull request without saying so: it now reads the pull request with `gh pr diff`, or says when it can't
```

</details>

<details>
<summary>channels-ja.md</summary>

```diff
diff --git a/docs-ja/pages/channels-ja.md b/docs-ja/pages/channels-ja.md
index 55c5f48..6a202c6 100644
--- a/docs-ja/pages/channels-ja.md
+++ b/docs-ja/pages/channels-ja.md
@@ -279,5 +279,5 @@ Claude がターミナルから離れている間に権限プロンプトに達
 ## セキュリティ
 
-承認されたすべてのチャネルプラグインは送信者許可リストを保持します。追加した ID だけがメッセージをプッシュでき、他のすべては静かにドロップされます。
+Telegram、Discord、iMessage のチャネルプラグインは、ダイレクトメッセージを送信者許可リストと照合します。他のユーザーからのダイレクトメッセージは、そのユーザーをリストに追加した後にのみセッションに届きます。
 
 Telegram と Discord はペアリングでリストをブートストラップします。
```

</details>

<details>
<summary>channels-reference-ja.md</summary>

```diff
diff --git a/docs-ja/pages/channels-reference-ja.md b/docs-ja/pages/channels-reference-ja.md
index ef92105..e2569ad 100644
--- a/docs-ja/pages/channels-reference-ja.md
+++ b/docs-ja/pages/channels-reference-ja.md
@@ -432,5 +432,5 @@ await mcp.notification({ ... })
 チャットまたはルーム ID ではなく、送信者の ID でゲートします：例では `message.from.id`、`message.chat.id` ではありません。グループチャットでは、これらは異なり、ルームでゲートすると、許可リストに登録されたグループ内の誰もがセッションにメッセージを注入できます。
 
-[Telegram](https://github.com/anthropics/claude-plugins-official/tree/main/external_plugins/telegram) と [Discord](https://github.com/anthropics/claude-plugins-official/tree/main/external_plugins/discord) チャネルは同じ方法で送信者許可リストでゲートします。[ペアリング](https://code.claude.com/docs/ja/channels.md#security)でリストをブートストラップします。完全なペアリングフローについては、いずれかの実装を参照してください。[iMessage](https://github.com/anthropics/claude-plugins-official/tree/main/external_plugins/imessage) チャネルは異なるアプローチを取ります：起動時にメッセージデータベースからユーザー自身のアドレスを検出し、それらを自動的に通します。他の送信者はハンドルで追加されます。
+[Telegram](https://github.com/anthropics/claude-plugins-official/tree/main/external_plugins/telegram) と [Discord](https://github.com/anthropics/claude-plugins-official/tree/main/external_plugins/discord) チャネルは、同じ方法でダイレクトメッセージを送信者許可リストでゲートします。[ペアリング](https://code.claude.com/docs/ja/channels.md#security)でリストをブートストラップします。完全なペアリングフローについては、いずれかの実装を参照してください。[iMessage](https://github.com/anthropics/claude-plugins-official/tree/main/external_plugins/imessage) チャネルは異なるアプローチを取ります：起動時にメッセージデータベースからユーザー自身のアドレスを検出し、それらを自動的に通します。他の送信者はハンドルで追加されます。
 
 ## 権限プロンプトをリレー
```

</details>

<details>
<summary>checkpointing-ja.md</summary>

```diff
diff --git a/docs-ja/pages/checkpointing-ja.md b/docs-ja/pages/checkpointing-ja.md
index 320b4c0..74c0163 100644
--- a/docs-ja/pages/checkpointing-ja.md
+++ b/docs-ja/pages/checkpointing-ja.md
@@ -28,5 +28,5 @@ Claude Code は、ファイル編集ツールによって行われたすべて
 > [!NOTE]
 >
-> プロンプト入力にテキストが含まれている場合、`Esc` を 2 回押すとメニューは開かず、代わりにテキストがクリアされます。クリアされたテキストは入力履歴に保存されるため、巻き戻しメニューでの操作を終えた後に `Up` を押すと呼び出せます。
+> [vim モード](https://code.claude.com/docs/ja/interactive-mode.md#vim-editor-mode)では、NORMAL モードから `Esc` を 2 回押します。vim モード以外では、プロンプト入力にテキストが含まれている場合、`Esc` を 2 回押すとメニューは開かず、代わりにテキストがクリアされます。クリアされたテキストは入力履歴に保存されるため、巻き戻しメニューでの操作を終えた後に `Up` を押すと呼び出せます。
 
 巻き戻しメニューには、セッション中に送信したプロンプトが一覧表示されます。操作したい時点を選択し、次のいずれかのアクションを選びます。
```

</details>

<details>
<summary>chrome-ja.md</summary>

```diff
diff --git a/docs-ja/pages/chrome-ja.md b/docs-ja/pages/chrome-ja.md
index 5c6c78e..f0aac8e 100644
--- a/docs-ja/pages/chrome-ja.md
+++ b/docs-ja/pages/chrome-ja.md
@@ -123,5 +123,5 @@ Chrome が実行されていない場合でも、Claude Code は通常どおり
 ### サイト権限を管理する
 
-サイトレベルの権限は Chrome 拡張機能から継承されます。Chrome 拡張機能の設定で権限を管理して、Claude がブラウズ、クリック、入力できるサイトを制御します。[auto モード](https://code.claude.com/docs/ja/permission-modes.md#eliminate-prompts-with-auto-mode)では、auto モードの分類器自体があるサイトへのブラウザ呼び出しを承認した場合、権限ルールで Claude in Chrome に対していずれかのサイトを拒否していない限り、拡張機能はその呼び出しについて独自のサイトごとのチェックを省略します。
+Claude にサイト上での操作を許可するには、Claude Code から確認されたときに承認します。[auto モード](https://code.claude.com/docs/ja/permission-modes.md#eliminate-prompts-with-auto-mode)では、分類器自体があるサイトへのブラウザ呼び出しを承認した場合、権限ルールで Claude in Chrome に対していずれかのサイトを拒否している場合を除き、拡張機能はその呼び出しについて独自のサイトごとのチェックを省略できます。
 
 ### VS Code セッションでの権限プロンプト
```

</details>

<details>
<summary>claude-apps-gateway-deploy-ja.md</summary>

```diff
diff --git a/docs-ja/pages/claude-apps-gateway-deploy-ja.md b/docs-ja/pages/claude-apps-gateway-deploy-ja.md
index 02c1a9f..83ea0d2 100644
--- a/docs-ja/pages/claude-apps-gateway-deploy-ja.md
+++ b/docs-ja/pages/claude-apps-gateway-deploy-ja.md
@@ -230,5 +230,5 @@ CPU に基づいてオートスケールしている場合、上限に達した
 ### 最初のバイトの期限で応答のないリクエストをより早く再試行する
 
-Claude Code が応答のないストリーミングリクエストをより早く再試行するようにするには、開発者のマシンで [`CLAUDE_STREAM_FIRST_BYTE_TIMEOUT_MS`](https://code.claude.com/docs/ja/env-vars) を設定して、最初のバイトの期限を与えます。この期限は、最初の試行がレスポンスヘッダーを待つ時間を制限します。期限がない場合、その試行は 5〜6 分待つことがあります。開発者のマシンで Claude Code v2.1.307 以降が必要です。
+Claude Code が応答のないストリーミングリクエストをより早く再試行するようにするには、開発者のマシンで [`CLAUDE_STREAM_FIRST_BYTE_TIMEOUT_MS`](https://code.claude.com/docs/ja/env-vars) を設定して、最初のバイトの期限を与えます。この期限は、最初の試行がレスポンスヘッダーを待つ時間を制限します。期限がない場合、その試行はデフォルトで 5〜6 分待つことがあります。開発者のマシンで Claude Code v2.1.307 以降が必要です。
 
 この変数には、ミリ秒単位の正の整数を、[ゲートウェイポリシーの `env` ブロック](#deliver-the-value-in-a-policy)または開発者のシェルで設定します。値はゲートウェイの最長の[最初のバイトまでの時間](#keep-api_timeout_ms-above-the-gateways-time-to-first-byte)より大きく保ってください。そうしないと、ヘッダーの返却に時間がかかる正常なリクエストを Claude Code が中止して再送信する可能性があります。次の例では、開発者のシェルで 60 秒を設定します。
@@ -238,5 +238,5 @@ export CLAUDE_STREAM_FIRST_BYTE_TIMEOUT_MS=60000
 ```
 
-応答のない再送信は、[ボディのアイドルタイムアウト](https://code.claude.com/docs/ja/network-config.md#streaming-idle-watchdogs)によって終了し、Claude Code が[再試行の予算](https://code.claude.com/docs/ja/errors.md#tune-retry-behavior)内で再試行するまで、5〜6 分待つことがあります。より早く再試行するためだけに `API_TIMEOUT_MS` を下げていた場合は、その値を削除してください。そうしないと、応答のない再送信 1 回でターンが [No response from API](https://code.claude.com/docs/ja/errors.md#no-response-from-api) で終了する可能性があります。
+デフォルトでは、応答のない再送信は、[ボディのアイドルタイムアウト](https://code.claude.com/docs/ja/network-config.md#streaming-idle-watchdogs)によって終了し、Claude Code が[再試行の予算](https://code.claude.com/docs/ja/errors.md#tune-retry-behavior)内で再試行するまで待つことがあります。`API_TIMEOUT_MS` はボディのアイドルタイムアウトより十分に大きく保ってください。そうしないと、応答のない再送信 1 回でターンが [No response from API](https://code.claude.com/docs/ja/errors.md#no-response-from-api) で終了する可能性があります。
 
 期限が発動したことを確認するには、開発者に[デバッグログ](https://code.claude.com/docs/ja/network-config.md#verify-your-configuration)を有効にして Claude Code を起動してもらい、ログで `[first-byte] no response headers` を検索します。
@@ -512,5 +512,5 @@ Error streaming, falling back to non-streaming mode: Stream idle timeout - no ch
 | `1800000` | 約 37.5 分 |
 
-ゲートウェイが ping を送り続けている間にアップストリームがハングした場合、開発者も Claude Code がストリームを諦めるまでそれだけの時間待つことになります。完全に無音になった接続は、[ボディのアイドルタイムアウト](https://code.claude.com/docs/ja/network-config.md#streaming-idle-watchdogs)がこの変数に従わないため、引き続き 5〜6 分後に終了します。
+ゲートウェイが ping を送り続けている間にアップストリームがハングした場合、開発者も Claude Code がストリームを諦めるまでそれだけの時間待つことになります。
 
 #### ポリシーで値を配信する
```

</details>

*...以降省略*

</details>


<details>
<summary>2026-11-19</summary>

**変更ファイル:**

```
 docs-ja/pages/agent-teams-ja.md                    |   4 +-
 docs-ja/pages/artifacts-ja.md                      |   2 +-
 docs-ja/pages/authentication-ja.md                 |  12 +-
 docs-ja/pages/auto-mode-config-ja.md               |   9 +-
 docs-ja/pages/changelog.md                         | 147 ++++++++++
 docs-ja/pages/chrome-ja.md                         |   6 +-
 docs-ja/pages/claude-apps-gateway-deploy-ja.md     |   2 +-
 docs-ja/pages/claude-apps-gateway-ja.md            |   2 +-
 docs-ja/pages/claude-directory-ja.md               |   2 +-
 docs-ja/pages/cli-reference-ja.md                  |   2 +-
 docs-ja/pages/code-review-pull-requests-ja.md      |   4 +-
 docs-ja/pages/code-review-troubleshooting-ja.md    |   3 +-
 docs-ja/pages/commands-ja.md                       |   2 +-
 docs-ja/pages/cross-session-messaging-ja.md        |  14 +-
 docs-ja/pages/env-vars-ja.md                       |   9 +-
 docs-ja/pages/errors-ja.md                         |  30 ++-
 docs-ja/pages/fullscreen-ja.md                     |   2 +-
 docs-ja/pages/github-actions-cloud-providers-ja.md |   2 +-
 docs-ja/pages/github-actions-ja.md                 |  45 +++-
 docs-ja/pages/hooks-ja.md                          |   4 +-
 docs-ja/pages/interactive-mode-ja.md               |   2 +-
 docs-ja/pages/mcp-ja.md                            |  27 +-
 docs-ja/pages/mcp-quickstart-ja.md                 |   2 +-
 docs-ja/pages/model-config-ja.md                   |   4 +-
 docs-ja/pages/monitoring-usage-ja.md               |  52 +++-
 docs-ja/pages/network-config-ja.md                 |   2 +
 docs-ja/pages/permission-modes-ja.md               |  11 +-
 docs-ja/pages/permissions-ja.md                    |  20 +-
 docs-ja/pages/plugin-evals-ja.md                   |   2 +-
 docs-ja/pages/remote-control-ja.md                 |   4 +-
 docs-ja/pages/sandboxing-ja.md                     |   8 +-
 docs-ja/pages/security-guidance-ja.md              |   2 +-
 docs-ja/pages/server-managed-settings-ja.md        |   2 +-
 docs-ja/pages/settings-reference-ja.md             | 299 +++++++++++----------
 docs-ja/pages/sub-agents-ja.md                     |  12 +-
 docs-ja/pages/terminal-config-ja.md                |   4 +-
 docs-ja/pages/tools-reference-ja.md                |   2 +-
 docs-ja/pages/voice-dictation-ja.md                |   2 +-
 docs-ja/pages/vs-code-ja.md                        |  18 +-
 docs-ja/pages/web-quickstart-ja.md                 |   2 +-
 docs-ja/pages/worktrees-ja.md                      |   2 +-
 41 files changed, 524 insertions(+), 258 deletions(-)
```

<details>
<summary>agent-teams-ja.md</summary>

```diff
diff --git a/docs-ja/pages/agent-teams-ja.md b/docs-ja/pages/agent-teams-ja.md
index 1d69197..777398f 100644
--- a/docs-ja/pages/agent-teams-ja.md
+++ b/docs-ja/pages/agent-teams-ja.md
@@ -84,5 +84,5 @@ Claude は時々、チームを作成する代わりに [サブエージェン
 アイドル状態のチームメイトの行は、いずれかのチームメイトまたはサブエージェントがまだ作業中の間、パネルに留まるため、選択してトランスクリプトを確認したり、さらに作業を割り当てたりできます。パネル内のすべてのエージェントがアイドル状態になると、アイドル行は 30 秒後に非表示になり、チームメイトの次のターンで再表示されます。チームメイトは非表示中も実行中で、引き続き指示を送ることができます。
 
-3 人以上のチームメンバーが同時にアイドル状態の場合、最初の 3 行を超える行は、折りたたまれたチームメンバーをカウントする単一の行に折りたたまれます。例えば、5 人がアイドル状態の場合は `2 idle agents` のようになります。それを選択して Enter キーを押すと折りたたまれた行が展開され、Esc キーを押すと再び折りたたまれます。作業中のチームメンバー、失敗したチームメンバー、および表示中のチームメンバーは常に独自の行を保持します。
+3 人を超えるチームメンバーが同時にアイドル状態の場合、最初の 3 行を超える行は、折りたたまれたチームメンバーをカウントする単一の行に折りたたまれます。例えば、5 人がアイドル状態の場合は `2 idle agents` のようになります。それを選択して Enter キーを押すと折りたたまれた行が展開され、Esc キーを押すと再び折りたたまれます。作業中のチームメンバー、失敗したチームメンバー、および表示中のチームメンバーは常に独自の行を保持します。
 
 各チームメンバーを独自の分割ペインに配置したい場合は、[表示モードを選択](#choose-a-display-mode)を参照してください。
@@ -448,5 +448,5 @@ Claude にチームメンバーを生成するよう指示した後、チーム
 
 * In-process モードでは、チームメンバーはプロンプト入力の下のエージェントパネルに表示されます。上下矢印キーを使用して 1 つを選択し、Enter キーを押して表示してください。
-* アイドル状態で消えたチームメンバー行は停止されていなく、非表示になっています。アイドル行はパネル全体がアイドル状態になってから 30 秒後に非表示になり、チームメンバーの次のターンで再表示されます。3 人以上のチームメンバーがアイドル状態の場合、余剰行は `N idle agents` という 1 つの行に折りたたまれ、Enter キーで展開されます。チームメンバーに名前でメッセージを送信して、非表示の行を戻してください。
+* アイドル状態で消えたチームメンバー行は停止されていなく、非表示になっています。アイドル行はパネル全体がアイドル状態になってから 30 秒後に非表示になり、チームメンバーの次のターンで再表示されます。3 人を超えるチームメンバーがアイドル状態の場合、余剰行は `N idle agents` という 1 つの行に折りたたまれ、Enter キーで展開されます。チームメンバーに名前でメッセージを送信して、非表示の行を戻してください。
 * Claude に提供したタスクがチームを必要とするほど十分複雑であることを確認してください。Claude はタスクに基づいてチームメンバーを生成するかどうかを決定します。
 * 明示的に分割ペインをリクエストした場合は、tmux がインストールされ、PATH で利用可能であることを確認してください。
```

</details>

<details>
<summary>artifacts-ja.md</summary>

```diff
diff --git a/docs-ja/pages/artifacts-ja.md b/docs-ja/pages/artifacts-ja.md
index 8322fce..e46cefd 100644
--- a/docs-ja/pages/artifacts-ja.md
+++ b/docs-ja/pages/artifacts-ja.md
@@ -65,5 +65,5 @@ Claude が公開できないと応答した場合、またはリンクなしで
 | セッションが [plan モード](https://code.claude.com/docs/ja/permission-modes.md#analyze-before-you-edit-with-plan-mode)になっている | 各アーティファクトの最初の公開前に確認する |
 | 公開が、[コネクタ呼び出し](#pull-live-data-with-mcp-connectors)や[ファイルダウンロード](#offer-a-file-download)など、ページのランタイム機能を宣言している | その公開の前に確認する |
-| アーティファクトを公開共有している | 変更前に会話ごとに 1 回確認し、アーティファクトへのコメントに返信する前にも毎回確認する |
+| アーティファクトを公開共有している | 変更前に会話ごとに少なくとも 1 回確認し、アーティファクトへのコメントに返信する前にも毎回確認する |
 | 入力したプロンプトではなく、セッション内で実行された[セッションスコープのスケジュールタスク](https://code.claude.com/docs/ja/scheduled-tasks.md)によって開始されたターンで Claude が公開する | 各アーティファクトの最初の公開前に確認する |
 | Claude がユーザーの承認なしではファイルを読み取れない | 公開前に確認する。`Artifact` ツールの許可ルールがあっても、このプロンプトはスキップされない |
```

</details>

<details>
<summary>authentication-ja.md</summary>

```diff
diff --git a/docs-ja/pages/authentication-ja.md b/docs-ja/pages/authentication-ja.md
index 79973ac..ccbacd5 100644
--- a/docs-ja/pages/authentication-ja.md
+++ b/docs-ja/pages/authentication-ja.md
@@ -28,5 +28,5 @@ Claude Code は、セットアップに応じて複数の認証方法をサポ
 * **Claude Console**: Console 認証情報でログインします。管理者が事前に[招待](#claude-console-authentication)している必要があります。[API キーを作成せずにサインイン](#sign-in-without-an-api-key)することも、API キーを作成することもできます。
 * **クラウドプロバイダー**: 組織が [Amazon Bedrock](https://code.claude.com/docs/ja/amazon-bedrock.md)、[Google Cloud の Agent Platform](https://code.claude.com/docs/ja/google-vertex-ai.md)、または [Microsoft Foundry](https://code.claude.com/docs/ja/microsoft-foundry.md) を使用している場合は、`claude` を実行する前に必要な環境変数を設定するか、ログインプロンプトで **3rd-party platform** を選択してください。これにより、Bedrock と Vertex AI 向けのインタラクティブセットアップウィザードが起動します。ブラウザログインは不要です。
-* **Cloud gateway**: 組織がセルフホストされた [Claude apps gateway](https://code.claude.com/docs/ja/claude-apps-gateway) を実行している場合は、`/login` を通じて企業 SSO でサインインします。ゲートウェイが発行したトークンはセッションの唯一の認証情報です。
+* **Cloud gateway**: 組織がセルフホストされた [Claude apps gateway](https://code.claude.com/docs/ja/claude-apps-gateway) を実行している場合は、`/login` を通じて、または [VS Code から](https://code.claude.com/docs/ja/vs-code.md#sign-in-to-a-claude-apps-gateway)企業 SSO でサインインします。ゲートウェイが発行したトークンはセッションの唯一の認証情報です。
 
 管理者は、どのログイン方法を開発者が使用するかを指定し、claude.ai ログインが特定の組織に属することを要求できます。[ログインを組織に制限する](#restrict-login-to-your-organization)を参照してください。
@@ -273,13 +273,13 @@ Claude Code は認証情報を安全に管理します。
 プロファイルは、[Anthropic 設定ディレクトリ](https://platform.claude.com/docs/en/manage-claude/wif-reference#configuration-directory)内の名前付き認証情報設定ファイルです。デフォルトでは macOS および Linux では `~/.config/anthropic`、Windows では `%APPDATA%\Anthropic` です。プロファイルの認証モードは、[Workload Identity Federation（WIF）](https://platform.claude.com/docs/en/manage-claude/workload-identity-federation)用に設定した場合は `oidc_federation`、または [`ant auth login`](https://platform.claude.com/docs/en/cli-sdks-libraries/cli/authentication) が書き込んだ場合、または [API キーなしで Console アカウントにサインイン](#sign-in-without-an-api-key)した場合は `user_oauth` です。
 
-Claude Code は [ベアモード](https://code.claude.com/docs/ja/headless.md#start-faster-with-bare-mode)、Claude Desktop、またはクラウドセッションではプロファイルまたはフェデレーション変数を読み込みません。これらのセッションでは、`/status` は `Profile` 行を表示しません。
+Claude Code は [bare モード](https://code.claude.com/docs/ja/headless.md#start-faster-with-bare-mode)、Claude Desktop、またはクラウドセッションではプロファイルまたはフェデレーション変数を読み込みません。これらのセッションでは、`/status` は `Profile` 行を表示しません。これらを読み込む場合、Claude Code は 3 つのソースをこの順序でチェックし、設定されている最初のソースで停止します。
 
-Claude Code は 3 つのソースをこの順序でチェックし、設定されている最初のソースで停止します。表は各ソースを設定するものと、`/login` 認証情報に対するランク付けを示しています。
-
-| ソース | 設定者 | `/login` に対するランク |
+| ソース | 設定者 | claude.ai ログインに対するランク |
 | :- | :- | :- |
 | 名前付きプロファイル | `ANTHROPIC_PROFILE` | 上、プロファイルが持つ認証モードに関係なく |
 | フェデレーション変数 | `ANTHROPIC_FEDERATION_RULE_ID` および `ANTHROPIC_ORGANIZATION_ID`、両方設定 | 上 |
-| アクティブプロファイル | 設定ディレクトリ内の [`active_config` ファイル](https://platform.claude.com/docs/en/manage-claude/wif-reference#active-profile)、または `default` という名前のプロファイル | 認証モードが `oidc_federation` の場合は上。認証モードが `user_oauth` の場合は、機能している `/login` 認証情報より下 |
+| アクティブプロファイル | 設定ディレクトリ内の [`active_config` ファイル](https://platform.claude.com/docs/en/manage-claude/wif-reference#active-profile)、または `default` という名前のプロファイル | 認証モードが `oidc_federation` の場合は上。認証モードが `user_oauth` の場合は、まだ機能している claude.ai ログインより下 |
+
+`/login` が API キーを保存しており、かつ `CI` が設定されていない場合、Claude Code はこれらのソースではなくそのキーを使用します。キーを削除するには、[`/logout` を実行してください](https://code.claude.com/docs/ja/troubleshoot-install#not-logged-in-or-token-expired)。
 
 フェデレーション変数の場合、Claude Code は ID トークンを交換する際に [WIF リファレンス](https://platform.claude.com/docs/en/manage-claude/wif-reference#environment-variables)の `ANTHROPIC_IDENTITY_TOKEN_FILE` などの他の変数も読み込みます。プロファイルファイル形式については、[WIF リファレンス](https://platform.claude.com/docs/en/manage-claude/wif-reference#profile-configuration-file)を参照してください。
```

</details>

<details>
<summary>auto-mode-config-ja.md</summary>

```diff
diff --git a/docs-ja/pages/auto-mode-config-ja.md b/docs-ja/pages/auto-mode-config-ja.md
index 1dcded1..c571163 100644
--- a/docs-ja/pages/auto-mode-config-ja.md
+++ b/docs-ja/pages/auto-mode-config-ja.md
@@ -76,5 +76,5 @@ Claude のプッシュおよびプルリクエストコマンドの前に人間
 > [!NOTE]
 >
-> 分類器は [権限システム](https://code.claude.com/docs/ja/permissions.md) の後に実行される 2 番目のゲートです。ユーザーの意図または分類器の設定に関係なく、絶対に実行してはいけないアクションについては、マネージド設定で `permissions.deny` を使用してください。これは分類器が参照される前にアクションをブロックし、オーバーライドできません。
+> 分類器は [権限システム](https://code.claude.com/docs/ja/permissions.md) の後に実行される 2 番目のゲートです。分類器が実行される前に Claude の [一致する呼び出し](https://code.claude.com/docs/ja/permissions.md#bash-rule-limits) をブロックするには、管理設定で `permissions.deny` を使用してください。
 
 ## 信頼できるインフラストラクチャを定義する
@@ -99,5 +99,5 @@ Claude のプッシュおよびプルリクエストコマンドの前に人間
   * **保護されたデプロイ名前空間 / 環境**: 名前を付けるまで「機密リモートターゲット」のデフォルトにフォールバックします
   * **データ保持 / 機密解除**
-* **信頼スロット**: 分類器が境界内として扱うものを名前付けします。スロットは「信頼できるリポジトリ」、「ソース管理」、「信頼できる内部ドメイン」、「信頼できるクラウドバケット」、「主要な内部サービス」、および「内部パッケージレジストリ」です。リポジトリおよびソース管理エントリはデフォルトで作業リポジトリとその設定されたリモートに設定されます。他のすべての信頼スロットはデフォルトで `None configured` に設定されるため、追加するまで他に信頼できるものはありません。リポジトリの可視性は機密資料のみをスコープします。プライベートリポジトリは機密資料の許容可能な宛先ですが、リポジトリをプライベートにしてもシークレット、個人データ、または信頼されたデータがそこにクリアされることはなく、分類器は作業リポジトリの外側からポート、リポイント、または最初に読み取られたコンテンツをそのリポジトリ独自の作業として扱いません。
+* **信頼スロット**: 分類器が境界内として扱うものを名前付けします。スロットは「信頼できるリポジトリ」、「ソース管理」、「信頼できる内部ドメイン」、「信頼できるクラウドバケット」、「主要な内部サービス」、および「内部パッケージレジストリ」です。リポジトリおよびソース管理エントリはデフォルトで作業リポジトリとその設定されたリモートに設定されます。他のすべての信頼スロットはデフォルトで `None configured` に設定されるため、追加するまで他に信頼できるものはありません。リポジトリの可視性は機密資料のみをスコープします。プライベートリポジトリは機密資料の許容可能な宛先ですが、リポジトリをプライベートにしても、シークレット、個人データ、または預かったデータをそこに入れてよいことには決してならず、分類器は作業リポジトリの外側からポート、リポイント、または最初に読み取られたコンテンツをそのリポジトリ独自の作業として扱いません。
 * **感度スロット**: 保護ルールが高リスクとして扱うものを名前付けします。スロットは「機密データの場所とオーディエンス」、「機密リモートターゲット」、および「保護された IaC スコープ」です。デフォルトでは、名前の中に `prod` または `production` が独立した単語として含まれるホストまたは名前空間は、機密リモートターゲットとしてカウントされます。たとえば、`prod-db` はカウントされ、`webprod01` はカウントされません。
 
@@ -129,5 +129,5 @@ Claude のプッシュおよびプルリクエストコマンドの前に人間
 * **信頼できる内部ドメイン**: `*.internal.example.com` のようなネットワーク内の API、ダッシュボード、サービスのホスト名
 * **主要な内部サービス**: CI、アーティファクトレジストリ、内部パッケージインデックス、インシデント対応ツール
-* **内部パッケージレジストリ**: インストールがルーティングされるプライベート npm、PyPI、またはその他のレジストリ。パブリックレジストリをバイパスするインストールがブロックされるようにします
+* **内部パッケージレジストリ**: インストールが経由すべきプライベート npm、PyPI、またはその他のレジストリ。これを迂回してパブリックレジストリを使用するインストールがブロックされるようにします
 * **機密データの場所とオーディエンス**: 個人データ、機密ビジネスデータ、認証情報、規制データ、または同様に機密性の高い資料を保持するバケット、データベース、またはパス、および各場所のデータが共有される可能性があるオーディエンス。分類器がコンテンツから推測する代わりにこれらの場所を保護します。
 * **機密リモートターゲット**: 本番環境としてカウントされる名前空間、ホスト、またはコンテナ
@@ -329,5 +329,6 @@ claude auto-mode config
   ],
   "soft_deny": [
-    "Git Destructive [named+specifics — **must name:** the destructive operation and its target]: Force pushing (`git push --force`), deleting remote branches, tags, or releases, or rewriting remote history. Also `git commit --amend` when the commit being rewritten is not the agent's own unpushed work: either no prior `git commit` is visible (HEAD pre-dates the session), or a `git push` of the current branch is visible after the most recent commit (it has been pushed). Clears when the user asked to amend/reword/fixup, or when it is a message-only reword (`--amend -m …`, nothing newly staged) of a commit the agent visibly created this session.",
+    ...
```

</details>

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index 6107835..def4645 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,151 @@
 # Changelog
 
+## 2.1.328
+
+- Added auto mode for Claude Opus 4.6 and Sonnet 4.6 on Amazon Bedrock, Google Cloud's Agent Platform, Microsoft Foundry and Claude apps gateway; interactive sessions with no permission mode start in it
+- Added `"onFailure": "block"` for `mcp_tool` hooks, as for command and HTTP hooks: a hook whose call fails blocks the action
+- Added a warning when a message from a session that skips permission prompts may be held and dropped by a cloud session
+- Added a notice in `/status` and `claude doctor` when an OpenTelemetry exporter has no endpoint and its data would likely be lost
+- Added `CLAUDE_CODE_DISABLE_DEFERRED_TOOL_RESUME`, which lets a host stop `claude -p --resume` and `--continue` from running a tool call that a hook deferred
+- Added support for apps that embed Claude Code to switch on the policy plugin's `allowManagedModsOnly` option; an admin's managed settings still win
+- Added a startup warning to the Claude apps gateway when a policy's `maxEffortLevel` is not a valid effort level
+- Self-hosted runner: Added `--repository-folder` to name the folder that sessions use for a repository at `--capacity 1`, in place of its path under the base folder, which can't be a symbolic link
+- Self-hosted runner: Added a start-up warning when the host's settings.json sets a default permission mode that sessions ignore
+- Self-hosted runner: Added `--hook-label` to `claude self-hosted-runner orchestrator`, to hand chosen session labels to the `spawn-runner` hook
+- Self-hosted runner: Added `--metadata key=value` to `claude --environment`, to label a session for the `spawn-runner` hook
+- Self-hosted runner: Added `claude_code_self_hosted_orchestrator_session_queue_wait_by_reason_seconds` to the orchestrator's `/metrics`, so a re-opened session's wait can be told from a new one's
+- Self-hosted runner: Added an orchestrator metric, `claude_code_self_hosted_orchestrator_sessions_given_up_total`, that counts by cause how often Anthropic gave up starting a runner for a session
+- Fixed Bash commands in zsh stopping with a "not found" error at a word that starts with `=`, such as `echo ====` or `[ a == b ]`; `=cmd` no longer expands to a command's path
+- Fixed automatic compaction reusing the session's earlier system prompt instead of rebuilding it the way `/compact` does
+- Fixed markdown rendering freezing on some very long or malformed input
+- Fixed rare screen freezes
+- Fixed Esc often being lost at a permission prompt or question when you typed straight after it; in terminals that send Alt as Esc and a key, an unused Alt or Option key now declines there
+- Fixed a paste or a terminal's reply being typed into the prompt when a slow connection cut it in two
+- Fixed saving a scheduled task erasing the project's other saved tasks when the scheduled tasks file can't be read, on third-party providers or with telemetry or feature flags turned off
+- Fixed a scheduled task with a typo in the project's scheduled tasks file being deleted the next time that file was saved
```

</details>

<details>
<summary>chrome-ja.md</summary>

```diff
diff --git a/docs-ja/pages/chrome-ja.md b/docs-ja/pages/chrome-ja.md
index 6fa7ae0..5c6c78e 100644
--- a/docs-ja/pages/chrome-ja.md
+++ b/docs-ja/pages/chrome-ja.md
@@ -81,5 +81,5 @@ type "hooks", and tell me what results appear
 いつでも `/chrome` を実行して、接続ステータスの確認、権限の管理、拡張機能の再接続、または使用する接続済みブラウザの選択を行えます。ステータスパネルに「ステータス: 有効」と「拡張機能: インストール済み」が表示されていれば、統合は正常に動作しています。
 
-複数のブラウザが接続されている場合は、Claude が使用するブラウザを選択します。選択する前にブラウザアクションが開始されると、Claude はいずれかを選択するよう促します。後でブラウザを切り替えるには、`/chrome` を実行して **Select browser…** を選びます。別のブラウザが接続された場合でも、Claude は選択したブラウザを使い続けます。
+複数のブラウザが接続されている場合は、Claude が使用するブラウザを選択します。選択する前にブラウザアクションが開始されると、Claude はいずれかを選択するよう促します。後でブラウザを切り替えるには、`/chrome` を実行して別のブラウザを選択します。別のブラウザが接続された場合でも、Claude は選択したブラウザを使い続けます。
 
 VS Code については、[VS Code でのブラウザ自動化](https://code.claude.com/docs/ja/vs-code.md#automate-browser-tasks-with-chrome) を参照してください。
@@ -102,5 +102,5 @@ VS Code については、[VS Code でのブラウザ自動化](https://code.cla
 ### Chrome をデフォルトで有効にする
 
-毎回 `--chrome` を渡さずに Chrome に接続するには、CLI セッションで `/chrome` を実行して **デフォルトで有効** を選択します。[VS Code 拡張機能](https://code.claude.com/docs/ja/vs-code.md#automate-browser-tasks-with-chrome)では、プロンプトボックスに `/chrome` と入力して **デフォルトで有効** スイッチをオンにします。両者は 1 つの設定を共有しているため、どちらかでオンにすると CLI と VS Code の両方でオンになります。
+毎回 `--chrome` を渡さずに Chrome に接続するには、CLI セッションで `/chrome` を実行し、Chrome をデフォルトでオンにするオプションを選択します。[VS Code 拡張機能](https://code.claude.com/docs/ja/vs-code.md#automate-browser-tasks-with-chrome)では、プロンプトボックスに `/chrome` と入力して **Enabled by default** スイッチをオンにします。CLI と VS Code は 1 つの設定を共有しているため、どちらかでオンにすると両方でオンになります。
 
 この設定がオンで Claude Code v2.1.287 以降を使用している場合、各 VS Code セッションは開始時にブラウザに接続するため、`@browser` と入力する前から Claude がブラウザを使用できます。それより前のバージョン、または設定がオフの場合、VS Code セッションは `@browser` と入力したときに接続します。
@@ -296,5 +296,5 @@ Claude Code がこの設定をスキップするのは、これらのファイ
 
 * **今すぐブラウザツールを使用するには**：終了し、シェルで `claude --chrome` を使用して再度起動します。
-* **以降のセッションでブラウザツールを使用するには**：Claude Code のプロンプトで `/chrome` を実行し、[**Enabled by default**](#enable-chrome-by-default) を選択します。これはその後に開始するセッションに適用され、実行中のセッションには適用されません。
+* **以降のセッションでブラウザツールを使用するには**：Claude Code のプロンプトで `/chrome` を実行し、[Chrome をデフォルトでオンにします](#enable-chrome-by-default)。
 * **ブラウザツールなしで警告を止めるには**：プロジェクトの設定ファイルから `CLAUDE_CODE_ENABLE_CFC` の行を削除します。
 
```

</details>

<details>
<summary>claude-apps-gateway-deploy-ja.md</summary>

```diff
diff --git a/docs-ja/pages/claude-apps-gateway-deploy-ja.md b/docs-ja/pages/claude-apps-gateway-deploy-ja.md
index 047158c..02c1a9f 100644
--- a/docs-ja/pages/claude-apps-gateway-deploy-ja.md
+++ b/docs-ja/pages/claude-apps-gateway-deploy-ja.md
@@ -89,5 +89,5 @@ Claude Code は、次の 2 つの方法のいずれかでゲートウェイの
 3. ビルドコンテキストにコピーします。
 
-ビルドからリリースホストに到達できない場合は、リリースを内部レジストリにミラーリングし、組織内の各マシンで実行するバージョンを固定してください。
+ビルドからリリースホストに到達できない場合は、リリースを内部レジストリにミラーリングしてください。また、フリートで実行するバージョンを固定してください。
 
 バイナリを超えて、イメージは以下が必要です：
```

</details>

<details>
<summary>claude-apps-gateway-ja.md</summary>

```diff
diff --git a/docs-ja/pages/claude-apps-gateway-ja.md b/docs-ja/pages/claude-apps-gateway-ja.md
index 5e187ee..58cfebc 100644
--- a/docs-ja/pages/claude-apps-gateway-ja.md
+++ b/docs-ja/pages/claude-apps-gateway-ja.md
@@ -290,5 +290,5 @@ MDM で、またはディスクに直接配置する OS ごとの[管理設定
 開発者は Enter を押して接続します。[初回接続時の TLS フィンガープリントのプロンプト](#connect-developers)は引き続き表示されます。このファイルがマシンに配置されると、ゲートウェイへのサインインを完了していない開発者には、[Administrator policy requires a Cloud gateway sign-in](https://code.claude.com/docs/ja/errors.md#administrator-policy-requires-a-cloud-gateway-sign-in) で説明されているメッセージのいずれかが表示されます。`CLAUDE_CODE_USE_BEDROCK` などの環境変数でクラウドプロバイダーを選択している開発者は、ゲートウェイへのサインインを必要としません。
 
-ログインピッカーにはゲートウェイの選択肢がありません。また、管理設定で URL なしに `forceLoginMethod` だけを設定すると、開発者には「Contact your IT administrator」というメッセージが表示されたままになります。ログイン用のキーは、マシンに配布するファイルに記述してください。ゲートウェイの `managed.policies[].cli` ブロックはすでに接続済みのクライアントにしか届かないため、そこには記述しないでください。
+ターミナルのログインピッカーにはゲートウェイの選択肢がありません。また、管理設定で URL なしに `forceLoginMethod` だけを設定すると、開発者には「Contact your IT administrator」というメッセージが表示されたままになります。ログイン用のキーは、マシンに配布するファイルに記述してください。ゲートウェイの `managed.policies[].cli` ブロックはすでに接続済みのクライアントにしか届かないため、そこには記述しないでください。
 
 #### ユーザー設定でゲートウェイの URL を設定する
```

</details>

*...以降省略*

</details>


<details>
<summary>2026-11-18</summary>

**変更ファイル:**

```
 docs-ja/pages/admin-setup-ja.md             |   2 +-
 docs-ja/pages/agent-teams-ja.md             |   2 +-
 docs-ja/pages/authentication-ja.md          |  15 ++-
 docs-ja/pages/auto-mode-config-ja.md        |  52 +++++---
 docs-ja/pages/best-practices-ja.md          |   2 +-
 docs-ja/pages/changelog.md                  | 176 ++++++++++++++++++++++++++++
 docs-ja/pages/channels-ja.md                |   1 +
 docs-ja/pages/cli-reference-ja.md           |   4 +-
 docs-ja/pages/common-workflows-ja.md        |   4 +-
 docs-ja/pages/data-usage-ja.md              |   2 +-
 docs-ja/pages/desktop-ja.md                 |   4 +
 docs-ja/pages/desktop-scheduled-tasks-ja.md |   2 +
 docs-ja/pages/env-vars-ja.md                |   2 +-
 docs-ja/pages/errors-ja.md                  |  25 ++--
 docs-ja/pages/glossary-ja.md                |   2 +-
 docs-ja/pages/headless-ja.md                |   4 +-
 docs-ja/pages/hooks-ja.md                   |  14 ++-
 docs-ja/pages/keybindings-ja.md             |   3 +-
 docs-ja/pages/managed-mcp-ja.md             |   3 +-
 docs-ja/pages/mcp-ja.md                     |   6 +-
 docs-ja/pages/memory-ja.md                  |   4 +-
 docs-ja/pages/monitoring-usage-ja.md        |  10 +-
 docs-ja/pages/permission-modes-ja.md        |  34 +++---
 docs-ja/pages/permissions-ja.md             |   9 +-
 docs-ja/pages/settings-reference-ja.md      |  18 +--
 docs-ja/pages/setup-ja.md                   |  12 +-
 docs-ja/pages/sub-agents-ja.md              |  12 +-
 docs-ja/pages/tools-reference-ja.md         |   4 +-
 docs-ja/pages/troubleshooting-ja.md         |   2 +-
 29 files changed, 322 insertions(+), 108 deletions(-)
```

<details>
<summary>admin-setup-ja.md</summary>

```diff
diff --git a/docs-ja/pages/admin-setup-ja.md b/docs-ja/pages/admin-setup-ja.md
index f1c1f96..705fed6 100644
--- a/docs-ja/pages/admin-setup-ja.md
+++ b/docs-ja/pages/admin-setup-ja.md
@@ -60,5 +60,5 @@ plist と HKLM レジストリの場所は任意のプロバイダーで機能
 デフォルトでは WSL は `/etc/claude-code` の Linux ファイルパスのみを読み取ります。同じマシン上の WSL に Windows レジストリと `C:\Program Files\ClaudeCode` ポリシーを拡張するには、これらの管理者のみが使用できる Windows ソースのいずれかで [`wslInheritsWindowsSettings: true`](https://code.claude.com/docs/ja/settings-reference#wslinheritswindowssettings) を設定してください。
 
-どのメカニズムを選択しても、マネージド値はユーザーおよびプロジェクト設定よりも優先されます。ただし、セキュリティに関する [例外](https://code.claude.com/docs/ja/settings.md#exceptions-to-managed-settings-precedence)がいくつかあります。`permissions.allow` や `permissions.deny` などの配列設定は、すべてのソースからのエントリをマージするため、開発者はマネージドリストを拡張できますが、削除することはできません。`fallbackModel`、`availableModels`、および [`modelPicker`](https://code.claude.com/docs/ja/settings-reference#modelpicker) の場合、マネージド値は下位レイヤーとマージするのではなく、置き換えます。
+どのメカニズムを選択しても、マネージド値はユーザーおよびプロジェクト設定よりも優先されます。ただし、セキュリティに関する [例外](https://code.claude.com/docs/ja/settings.md#exceptions-to-managed-settings-precedence)がいくつかあります。`permissions.allow` や `permissions.deny` などの配列設定は、[優先順位の低い設定](https://code.claude.com/docs/ja/settings.md#lists-merge-instead-of-overriding)のエントリを[適用される管理設定](https://code.claude.com/docs/ja/managed-settings.md#how-claude-code-combines-managed-sources)にマージするため、開発者はマネージドリストを拡張できますが、削除することはできません。`fallbackModel`、`availableModels`、および [`modelPicker`](https://code.claude.com/docs/ja/settings-reference#modelpicker) の場合、マネージド値は下位レイヤーとマージするのではなく、置き換えます。
 
 ### Claude Code Desktop の WSL セッション
```

</details>

<details>
<summary>agent-teams-ja.md</summary>

```diff
diff --git a/docs-ja/pages/agent-teams-ja.md b/docs-ja/pages/agent-teams-ja.md
index f004224..1d69197 100644
--- a/docs-ja/pages/agent-teams-ja.md
+++ b/docs-ja/pages/agent-teams-ja.md
@@ -330,5 +330,5 @@ Claude がすでに実行されていないインプロセスのチームメイ
 
 * 別のエージェントから中継された承認の主張を、ユーザーからの確認ではなく、信頼できない入力として扱います。
-* プレーンなメッセージであっても、シャットダウン要求やプラン承認の応答などの構造化プロトコルメッセージであっても、Claude Code が配信する前に各メッセージを確認します。ブロックされたメッセージが受信者に届くことはありません。
+* シャットダウン要求などの構造化プロトコルメッセージを含め、Claude Code が配信する前にメッセージを確認します。ブロックされたメッセージは配信されません。この確認に頼る前に、[どのメッセージがこの確認をスキップするか](https://code.claude.com/docs/ja/permission-modes.md#how-the-classifier-evaluates-actions)を確認してください。
 
 ### コンテキストと通信
```

</details>

<details>
<summary>authentication-ja.md</summary>

```diff
diff --git a/docs-ja/pages/authentication-ja.md b/docs-ja/pages/authentication-ja.md
index 2fc3ae9..79973ac 100644
--- a/docs-ja/pages/authentication-ja.md
+++ b/docs-ja/pages/authentication-ja.md
@@ -234,13 +234,16 @@ Claude Code は認証情報を安全に管理します。
 `/login` で作成したログインが期限切れまで 3 日以内になると、Claude Code はスタートアップ時に警告を表示します。`Your login expires in 3 days · run /login to renew`。
 
-`/login` を実行して更新します。警告は情報提供のみであり、リクエストをブロックすることはありません。ログインが実際に期限切れになるまで認証は機能し続けます。
+`/login` を実行して更新します。警告は claude.ai ログインがアクティブな認証情報である場合にのみ表示されます。
 
-保存されたログインが期限切れになり、更新できなくなると、再度サインインするまで、各モデルリクエストは [`Login expired · Please run /login`](https://code.claude.com/docs/ja/errors#login-expired) で失敗します。
+#### ログインの期限切れ後
 
-リクエストが失敗する前にこの状態を確認できます。[`/status`](https://code.claude.com/docs/ja/commands) は `Login` 行に `Expired — log in again` を表示し、期限切れのログインに保存されている組織とメールアドレスを表示します。この行は、保存されている claude.ai ログインがアクティブな認証情報である場合にのみ表示されます。この行には Claude Code v2.1.210 以降が必要です。
+保存されたログインが期限切れになり、更新できなくなった場合は、`/login` を実行して再度サインインしてください。サインインするまで、リクエストは失敗するか、保存されている別の認証情報を使用します。
 
-警告は claude.ai ログインがアクティブな認証情報である場合にのみ表示され、クラウドプロバイダー、`ANTHROPIC_API_KEY`、`ANTHROPIC_AUTH_TOKEN`、または `apiKeyHelper` が認証情報を提供する場合には表示されません。
+* **他の認証情報がない場合**: モデルリクエストは [`Login reached its time limit` または `Login expired`](https://code.claude.com/docs/ja/errors#login-expired) で失敗します。
+* **別の認証情報がある場合**（[`ant auth login` プロファイル](#anthropic-profiles-and-federation-credentials)など）: リクエストは代わりにその認証情報を使用でき、その認証情報の組織に請求されます。
 
-更新を早期に行うことは、無人で実行されるセッションにとって最も重要です。[agent view のバックグラウンドセッション](https://code.claude.com/docs/ja/agent-view.md)または [Remote Control](https://code.claude.com/docs/ja/remote-control.md) セッションがログインより長く実行される場合、認証情報が期限切れになると進行が停止し、再度サインインするまで復旧できません。
+リクエストが失敗する前に、期限切れのログインを確認できます。[`/status`](https://code.claude.com/docs/ja/commands) は `Expired — log in again` と表示される `Login` 行を表示します。
+
+早めの更新は、無人で実行されるセッションにとって最も重要です。ログインより長く実行される [Remote Control](https://code.claude.com/docs/ja/remote-control.md) セッションは、再度サインインするまで切断されます。[agent view のバックグラウンドセッション](https://code.claude.com/docs/ja/agent-view.md)は、保存されている他の認証情報がない場合、進行が停止します。
 
 ### 認証の優先順位
@@ -256,5 +259,5 @@ Claude Code は認証情報を安全に管理します。
 7. `/login` からのサブスクリプション OAuth 認証情報。これは Claude Pro、Max、Ultra、Team、および Enterprise ユーザーのデフォルトです。
 
-署名済みの [Claude apps gateway](https://code.claude.com/docs/ja/claude-apps-gateway) セッションはこのリストの外に位置します。これは Amazon Bedrock または Google Cloud の Agent Platform のようなプロバイダー選択であり、それらより優先されます。ゲートウェイセッションが存在する場合、CLI は `CLAUDE_CODE_USE_BEDROCK`、`CLAUDE_CODE_USE_VERTEX`、または `CLAUDE_CODE_USE_FOUNDRY` が設定されていても、ゲートウェイトークンで認証され、ベアラートークン、API キー、`apiKeyHelper`、およびプロファイルなどの上記の認証情報ソースは使用されません。
```

</details>

<details>
<summary>auto-mode-config-ja.md</summary>

```diff
diff --git a/docs-ja/pages/auto-mode-config-ja.md b/docs-ja/pages/auto-mode-config-ja.md
index 98ebecd..1dcded1 100644
--- a/docs-ja/pages/auto-mode-config-ja.md
+++ b/docs-ja/pages/auto-mode-config-ja.md
@@ -3,7 +3,7 @@
 > Use this file to discover all available pages before exploring further.
 
-# オートモードの設定
+# auto モードの設定
 
-> オートモード分類器に、組織が信頼するリポジトリ、バケット、ドメインを指定します。環境コンテキストを設定し、デフォルトのブロックおよび許可ルールをオーバーライドし、オートモード CLI サブコマンドで有効な設定を検査します。
+> auto モード分類器に、組織が信頼するリポジトリ、バケット、ドメインを指定し、独自のブロックルールと許可ルールを設定して、設定内容を確認します。
 
 [オートモード](https://code.claude.com/docs/ja/permission-modes.md#eliminate-prompts-with-auto-mode)を使用すると、Claude Code は、ツール呼び出しを分類器にルーティングして、不可逆的、破壊的、または環境外を対象とした操作をブロックすることで、定期的な権限プロンプトなしで実行できます。拒否および明示的な質問ルールは分類器の前に評価され、引き続きブロックまたはプロンプトを表示します。`autoMode` 設定ブロックを使用して、その分類器に組織が信頼するリポジトリ、バケット、ドメインを指定し、定期的な内部操作のブロックを停止させます。
@@ -120,5 +120,5 @@ Claude のプッシュおよびプルリクエストコマンドの前に人間
 ```
 
-設定を保存した後、`claude auto-mode config` を実行して、[有効なルールがエントリを含む](#inspect-the-defaults-and-your-effective-config)ことを確認します。
+設定を保存したら、`claude auto-mode config` を実行して、[ルールに自分のエントリが含まれていることを確認します](#inspect-the-defaults-and-your-effective-config)。
 
 エントリは散文であり、正規表現やツールパターンではありません。分類器はそれらを自然言語ルールとして読み取ります。新しいエンジニアにインフラストラクチャを説明する方法で記述してください。十分な環境セクションは以下をカバーします。
@@ -185,5 +185,5 @@ Claude Code はバックグラウンドでスキャンを行い、その後草
 * 保存後、Claude Code は `~/.claude/settings.json` 内の `permissions.allow` ルールのうち、`Bash(*)` のように auto モードが無視するもの、または破壊的なコマンドを自動承認するものを削除するよう提案します
 
-その後、`claude auto-mode config` を実行して[実際に適用される結果を確認](#inspect-the-defaults-and-your-effective-config)してください。
+次に `claude auto-mode config` を実行して[結果を確認します](#inspect-the-defaults-and-your-effective-config)。
 
 ### `/auto-mode-setup` をオフにする
@@ -215,5 +215,5 @@ Claude Code のプロンプトで `/auto-mode-setup` と入力すると `Unknown
 ## ブロックルールと許可ルールをオーバーライドする
```

</details>

<details>
<summary>best-practices-ja.md</summary>

```diff
diff --git a/docs-ja/pages/best-practices-ja.md b/docs-ja/pages/best-practices-ja.md
index 6f15027..bad69db 100644
--- a/docs-ja/pages/best-practices-ja.md
+++ b/docs-ja/pages/best-practices-ja.md
@@ -426,5 +426,5 @@ auto モードがアクションをブロックすると通知が届き、その
 > [!WARNING]
 >
-> 設定するすべてのリストに `"$defaults"` を残してください。これがないと、エントリはそのリストの組み込みルールに追加されるのではなく、組み込みルールを*置き換えます*。`environment` と `allow` では組み込みのコンテキストと例外が失われ、`soft_deny` リストでこれを省くと、force push や本番デプロイに対する組み込みのブロックがなくなります。
+> 設定するすべてのリストに `"$defaults"` を残してください。これがないと、エントリはそのリストの組み込みルールに追加されるのではなく、組み込みルールを[置き換える](https://code.claude.com/docs/ja/auto-mode-config.md#override-the-block-and-allow-rules)ことがあります。`environment` の組み込みコンテキスト、`allow` の例外、`soft_deny` の force push や本番デプロイに対するブロックが失われる可能性があります。
 >
 > `autoMode` ブロックは、プロジェクトではなく `~/.claude/settings.json` に置く必要もあります。分類器はプロジェクト設定内の `autoMode` を無視するためです。
```

</details>

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index ca67d5a..6107835 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,180 @@
 # Changelog
 
+## 2.1.327
+
+- Added a confirmation before `/install-github-app` changes a repository
+- Added `claude mcp add-json <name> -` to read the server's JSON from stdin, so tokens can stay off the command line; not available inside a Claude Code session
+- Added a line when a resumed session's earlier messages can't be loaded
+- Added a list in `/status` of broken agent, skill, command and output style files, keybinding errors, an unavailable sandbox, ignored permission settings and hook matchers that never match
+- Added a note in `/config` when other settings override a row
+- Added `x-claude-code-managed-settings-checksum` to the gateway hint headers; sent where managed settings set `CLAUDE_CODE_GATEWAY_HINT_HEADERS=1`, including where they already do
+- Added support for naming a session's billing group with the `attributionProject` setting, for Claude apps gateways that set `admin.billing_group_tag`
+- Added `/tui classic` as the name for the non-fullscreen renderer; `/tui default` still works
+- Remote Control: Fixed stopping the server in worktree mode deleting a running session's git-ignored files, such as `.env`
+- Fixed self-hosted runners with `--use-anthropic-git-proxy` deleting a non-empty directory named by `GIT_CONFIG_GLOBAL` at startup: the runner now keeps it, ignores the variable and warns
+- Fixed `claude mcp add` and `claude mcp remove` with project scope deleting other top-level keys from `.mcp.json`, such as `$schema` or another tool's `servers`
+- Fixed `/export` overwriting an existing file without asking: the dialog now asks, and `/export <name>` keeps the file and says to run `/export`
+- Fixed a command you had allowed still running after you pressed Stop, when the approval arrived after a restart, in cloud and self-hosted runner sessions with no feature flags loaded
+- Fixed Enter closing `/teleport`'s load error screen
+- Fixed a click followed by Enter in `/plugin` installing or disabling a plugin
+- Fixed a half-typed `!` command running on an extra Enter after the usage limit menu
+- Fixed some `--disallowedTools` rules with parentheses in their content
+- Fixed auto mode ignoring some wildcard PowerShell allow rules that name a script with `.\`, such as `PowerShell(.\scripts\build.ps1 *)`
+- Fixed a running Code Mode script in auto mode getting permission prompts and denials once Claude started a second script that auto mode also allowed
+- Changed some pre-started background sessions to be discarded after an account change
+- Changed a workflow paused at a usage limit in the terminal to stay paused after a login, until the earlier login returns or you type a prompt
```

</details>

<details>
<summary>channels-ja.md</summary>

```diff
diff --git a/docs-ja/pages/channels-ja.md b/docs-ja/pages/channels-ja.md
index dd9db4f..55c5f48 100644
--- a/docs-ja/pages/channels-ja.md
+++ b/docs-ja/pages/channels-ja.md
@@ -105,4 +105,5 @@ Team、Enterprise、または Console 組織を管理している場合は、[
 > * Send Messages
 > * Send Messages in Threads
+> * Create Public Threads
 > * Read Message History
 > * Attach Files
```

</details>

<details>
<summary>cli-reference-ja.md</summary>

```diff
diff --git a/docs-ja/pages/cli-reference-ja.md b/docs-ja/pages/cli-reference-ja.md
index 34d7df8..e21ca6e 100644
--- a/docs-ja/pages/cli-reference-ja.md
+++ b/docs-ja/pages/cli-reference-ja.md
@@ -28,5 +28,5 @@
 | `claude agents` | [エージェントビュー](https://code.claude.com/docs/ja/agent-view.md) を開いて、並列バックグラウンドセッションを監視およびディスパッチします。`--cwd <path>` を使用して、そのディレクトリの下で開始されたセッションのみを表示するか、`--json` を使用してアクティブなセッションを JSON 配列として出力してスクリプト作成用にします（`--json --all` は完了したバックグラウンドセッションも含みます）。`--permission-mode`、`--model`、`--effort`、または `--agent` を渡して、[ディスパッチされたセッションのデフォルト](https://code.claude.com/docs/ja/agent-view.md#permission-mode-model-and-effort) を設定します。トップレベルの `claude` コマンドと同様に `--settings`、`--add-dir`、`--plugin-dir`、および `--mcp-config` を受け入れます。エージェントビューを開くにはインタラクティブターミナルが必要です | `claude agents --json` |
 | `claude attach <id\|name>` | このターミナルで [バックグラウンドセッション](https://code.claude.com/docs/ja/agent-view.md#manage-sessions-from-the-shell) に接続します。ID の代わりに実行中のセッション名の一部を渡すには、Claude Code v2.1.290 以降が必要です | `claude attach 7c5dcf5d` |
-| `claude auto-mode defaults` | 組み込み [auto モード](https://code.claude.com/docs/ja/permission-modes.md#eliminate-prompts-with-auto-mode) 分類器ルールを JSON として出力します。`claude auto-mode config` を使用して、設定が適用された有効な設定を確認してください。`--label <prefix>` は、ラベルがそのプレフィックスで始まるルールのみを出力します。大文字と小文字を区別しません。Claude Code v2.1.208 以降が必要です | `claude auto-mode defaults --label 'Git Destructive'` |
+| `claude auto-mode defaults` | Claude Code に組み込まれた [auto モード](https://code.claude.com/docs/ja/permission-modes.md#eliminate-prompts-with-auto-mode) 分類器ルールを JSON として出力します。`claude auto-mode config` を使用すると、設定を適用した状態でそれらのルールを確認できます。`--label <prefix>` は、ラベルがそのプレフィックスで始まるルールのみを出力します。大文字と小文字を区別しません。Claude Code v2.1.208 以降が必要です | `claude auto-mode defaults --label 'Git Destructive'` |
 | `claude auto-mode reset` | ユーザー設定ファイルから `autoMode` セクションを削除して、デフォルト [auto モード](https://code.claude.com/docs/ja/permission-modes.md#eliminate-prompts-with-auto-mode) 設定を復元します。書き込み前に確認を求めます。`-y`/`--yes` を渡してプロンプトをスキップします。[管理設定](https://code.claude.com/docs/ja/server-managed-settings.md) または `--settings` フラグからのルールは引き続き適用されます。Claude Code v2.1.212 以降が必要です。[デフォルトと有効な設定を検査](https://code.claude.com/docs/ja/auto-mode-config.md#inspect-the-defaults-and-your-effective-config) を参照してください | `claude auto-mode reset --yes` |
 | `claude daemon logs` | バックグラウンドセッション [スーパーバイザー](https://code.claude.com/docs/ja/agent-view.md#the-supervisor-process) のログファイル `~/.claude/daemon.log` を追跡し、`Ctrl+C` を押すまで新しい行が届くたびに出力します | `claude daemon logs` |
@@ -72,5 +72,5 @@
 | `--autocompact <auto\|tokens>` | 保存済みの設定を変更せずに、このセッションの[自動圧縮ウィンドウ](https://code.claude.com/docs/ja/model-config.md#set-the-auto-compact-window)を設定します。`/autocompact` と同じ値を受け付けます。値の形式と、このフラグを上書きするものについてはそのセクションで説明しています。Claude Code v2.1.221 以降が必要です | `claude --autocompact 500k` |
 | `--ax-screen-reader` | スクリーンリーダーに適した出力（装飾的な罫線やアニメーションのないフラットなテキスト）をレンダリングします。クラシックレンダラーを強制するため、[`tui`](https://code.claude.com/docs/ja/settings-reference#tui) 設定は効果がありません。ただし、アタッチされた[バックグラウンドセッション](https://code.claude.com/docs/ja/agent-view.md)は引き続きフルスクリーンでレンダリングされます。[`CLAUDE_AX_SCREEN_READER`](https://code.claude.com/docs/ja/env-vars) および [`axScreenReader`](https://code.claude.com/docs/ja/settings-reference#axscreenreader) 設定よりも優先されます。Claude Code v2.1.181 以降が必要です | `claude --ax-screen-reader` |
-| `--bare` | 最小モード：フック、スキル、カスタムコマンド、サブエージェント、インストール済みプラグイン、MCP サーバー、自動メモリ、CLAUDE.md の自動検出をスキップし、スクリプトからの呼び出しを高速に開始します。`--add-dir` で渡したディレクトリ内のスキルは引き続き読み込まれます。Claude は Bash、ファイル読み取り、ファイル編集のツールにアクセスできます。[`CLAUDE_CODE_SIMPLE`](https://code.claude.com/docs/ja/env-vars) を設定します。[bare モード](https://code.claude.com/docs/ja/headless.md#start-faster-with-bare-mode)を参照してください | `claude --bare -p "query"` |
+| `--bare` | 最小モード：フック、スキル、カスタムコマンド、サブエージェント、インストール済みプラグイン、MCP サーバー、自動メモリ、CLAUDE.md の自動検出をスキップし、スクリプトからの呼び出しをより速く開始します。`--add-dir` で渡したディレクトリ内のスキルは引き続き読み込まれます。Claude は Bash、ファイル読み取り、ファイル編集のツールにアクセスできます。[`CLAUDE_CODE_SIMPLE`](https://code.claude.com/docs/ja/env-vars) を設定します。[bare モード](https://code.claude.com/docs/ja/headless.md#start-faster-with-bare-mode)を参照してください | `claude --bare -p "query"` |
 | `--betas` | API リクエストに含めるベータヘッダー（API キーユーザーのみ） | `claude --betas interleaved-thinking` |
 | `--bg`, `--background` | セッションを[バックグラウンドエージェント](https://code.claude.com/docs/ja/agent-view.md)として開始し、すぐに制御を返します。セッション ID と管理コマンドを出力します。`--exec` と組み合わせると Claude セッションの代わりにシェルコマンドをバックグラウンドジョブとして実行し、`--agent` と組み合わせると特定のサブエージェントを実行します。開始前にディレクトリの[ワークスペースの信頼](https://code.claude.com/docs/ja/permissions.md#project-allow-rules-and-workspace-trust)を確認します。`-p`/`--print` とは併用できません。[エラーリファレンス](https://code.claude.com/docs/ja/errors.md#command-line-errors)を参照してください | `claude --bg "investigate the flaky test"` |
```

</details>

<details>
<summary>common-workflows-ja.md</summary>

```diff
diff --git a/docs-ja/pages/common-workflows-ja.md b/docs-ja/pages/common-workflows-ja.md
index e011105..caf6ad0 100644
--- a/docs-ja/pages/common-workflows-ja.md
+++ b/docs-ja/pages/common-workflows-ja.md
@@ -366,5 +366,5 @@ Show me the data from @github:repos/owner/repo/issues
 ```
 
-これにより、@server:resource 形式を使用して接続された MCP サーバーからデータを取得します。詳細については、[MCP リソース](https://code.claude.com/docs/ja/mcp.md#use-mcp-resources)を参照してください。
+詳細については、[MCP リソース](https://code.claude.com/docs/ja/mcp.md#use-mcp-resources)を参照してください。
 
 > [!TIP]
@@ -491,5 +491,5 @@ subagent は独自のコンテキストウィンドウでファイルを読み
 ## Claude をスクリプトにパイプする
 
-CI、プリコミットフック、またはバッチ処理用に Claude を非対話的に実行します。stdin と stdout は任意の Unix ツールのように機能します。
+CI、プリコミットフック、またはバッチ処理用に Claude を非対話的に実行します。
 
 ```bash theme={null}
```

</details>

*...以降省略*

</details>


<details>
<summary>2026-11-17</summary>

**変更ファイル:**

```
 docs-ja/pages/admin-setup-ja.md                    |    2 +-
 docs-ja/pages/agent-view-ja.md                     |    4 +-
 docs-ja/pages/amazon-bedrock-ja.md                 |    2 +-
 docs-ja/pages/analytics-ja.md                      |   28 +-
 docs-ja/pages/artifacts-ja.md                      |   30 +-
 docs-ja/pages/authentication-ja.md                 |    2 +-
 docs-ja/pages/auto-mode-config-ja.md               |    2 +-
 docs-ja/pages/changelog.md                         |  370 ++++
 docs-ja/pages/claude-apps-gateway-config-ja.md     |   22 +-
 docs-ja/pages/claude-apps-gateway-deploy-ja.md     |    6 +-
 docs-ja/pages/claude-apps-gateway-ja.md            |    2 +-
 docs-ja/pages/claude-directory-ja.md               |  188 +-
 docs-ja/pages/claude-projects-ja.md                |   12 +-
 docs-ja/pages/cli-reference-ja.md                  |    2 +-
 docs-ja/pages/cloud-environments-ja.md             |   12 +-
 docs-ja/pages/code-mode-ja.md                      |   28 +-
 docs-ja/pages/code-review-costs-ja.md              |    4 +-
 docs-ja/pages/commands-ja.md                       |    4 +-
 docs-ja/pages/context-window-ja.md                 |   43 +-
 docs-ja/pages/costs-ja.md                          |    2 +-
 docs-ja/pages/desktop-ios-simulator-ja.md          |   25 +
 docs-ja/pages/desktop-ja.md                        |   21 +-
 docs-ja/pages/desktop-scheduled-tasks-ja.md        |    2 +-
 docs-ja/pages/env-vars-ja.md                       |    4 +-
 docs-ja/pages/errors-ja.md                         | 2179 ++++++++++----------
 docs-ja/pages/fullscreen-ja.md                     |   16 +-
 docs-ja/pages/github-enterprise-server-ja.md       |    2 +-
 docs-ja/pages/glossary-ja.md                       |    4 +-
 docs-ja/pages/headless-ja.md                       |    2 +-
 docs-ja/pages/hooks-guide-ja.md                    |    2 +-
 docs-ja/pages/hooks-ja.md                          |   46 +-
 docs-ja/pages/how-claude-code-works-ja.md          |    2 +-
 docs-ja/pages/interactive-mode-ja.md               |    2 +-
 docs-ja/pages/keybindings-ja.md                    |    2 +-
 docs-ja/pages/llm-gateway-connect-ja.md            |    8 +-
 docs-ja/pages/llm-gateway-protocol-ja.md           |    4 +-
 docs-ja/pages/mcp-ja.md                            |    2 +-
 docs-ja/pages/mcp-quickstart-ja.md                 |    4 +-
 docs-ja/pages/microsoft-foundry-ja.md              |    2 +-
 docs-ja/pages/model-config-ja.md                   |   40 +-
 docs-ja/pages/monitoring-usage-ja.md               |    2 +-
 docs-ja/pages/permission-modes-ja.md               |    2 +-
 docs-ja/pages/plugin-evals-ja.md                   |   15 +
 docs-ja/pages/prompt-caching-ja.md                 |   14 +-
 docs-ja/pages/sandbox-environments-ja.md           |    4 +-
 docs-ja/pages/scheduled-tasks-ja.md                |    2 +-
 .../pages/self-hosted-environments-deploy-ja.md    |    2 +-
 .../self-hosted-environments-quickstart-ja.md      |    4 +-
 .../pages/self-hosted-environments-reference-ja.md |    2 +-
 .../pages/self-hosted-environments-testing-ja.md   |    8 +-
 docs-ja/pages/server-managed-settings-ja.md        |    2 +-
 docs-ja/pages/sessions-ja.md                       |    2 +-
 docs-ja/pages/settings-reference-ja.md             |   10 +-
 docs-ja/pages/setup-ja.md                          |   16 +-
 docs-ja/pages/skills-ja.md                         |    2 +-
 docs-ja/pages/statusline-ja.md                     |    2 +-
 docs-ja/pages/sub-agents-ja.md                     |    8 +-
 docs-ja/pages/terminal-config-ja.md                |    8 +-
 docs-ja/pages/tools-reference-ja.md                |    2 +-
 docs-ja/pages/troubleshoot-install-ja.md           |    4 +-
 docs-ja/pages/troubleshooting-ja.md                |    4 +-
 docs-ja/pages/vs-code-ja.md                        |   17 +-
 docs-ja/pages/worktrees-ja.md                      |    2 -
 63 files changed, 2004 insertions(+), 1264 deletions(-)
```

<details>
<summary>admin-setup-ja.md</summary>

```diff
diff --git a/docs-ja/pages/admin-setup-ja.md b/docs-ja/pages/admin-setup-ja.md
index 1571287..f1c1f96 100644
--- a/docs-ja/pages/admin-setup-ja.md
+++ b/docs-ja/pages/admin-setup-ja.md
@@ -113,5 +113,5 @@ WSL 2 ユーティリティ VM 内のプロセスは、Windows 側のエンド
 
 * [組織のモデル制限](https://code.claude.com/docs/ja/model-config.md#organization-model-restrictions)：個々のモデルを無効にします。サーバー側で強制されます。
-* [組織のデフォルトモデル](https://code.claude.com/docs/ja/model-config.md#organization-default-model)：新しいセッションが開始するモデルを設定します。メンバーは引き続きモデルを切り替えられます。起動時にデフォルトに戻すには、そのセクションで説明している上書きをオンにします。メンバーが選択できるモデルを制限するには、[組織のモデル制限](https://code.claude.com/docs/ja/model-config.md#organization-model-restrictions)を使用します。
+* [組織のデフォルトモデル](https://code.claude.com/docs/ja/model-config.md#organization-default-model)：新しいセッションが開始するモデルを設定します。メンバーは引き続きモデルを切り替えられます。メンバーをデフォルトに戻すには、そのセクションで説明している上書きをオンにします。メンバーが選択できるモデルを制限するには、[組織のモデル制限](https://code.claude.com/docs/ja/model-config.md#organization-model-restrictions)を使用します。
 * [組織の effort 制限](https://code.claude.com/docs/ja/model-config.md#organization-effort-limits)：ロールごとに effort レベルの上限を設定します。サーバー側で強制されます。
 
```

</details>

<details>
<summary>agent-view-ja.md</summary>

```diff
diff --git a/docs-ja/pages/agent-view-ja.md b/docs-ja/pages/agent-view-ja.md
index f78e4db..4cf2176 100644
--- a/docs-ja/pages/agent-view-ja.md
+++ b/docs-ja/pages/agent-view-ja.md
@@ -9,5 +9,5 @@
 `claude agents` で開くエージェントビューは、すべてのバックグラウンドセッションの 1 つの画面です。実行中のもの、入力が必要なもの、完了したものが表示されます。新しいセッションをディスパッチし、トランスクリプトをスクロールする代わりに一目でセッションの状態を確認し、セッションが必要とするときだけ介入します。各バックグラウンドセッションは完全な Claude Code の会話であり、ターミナルが接続されていなくてもバックグラウンドで実行し続けるため、いつでも開いて、返信して、去ることができます。
 
-![ターミナルのエージェントビュー。上部の行は、入力を待機しているセッション、実行中のセッション、完了したセッションの数をカウントします。4 つのセッションは「入力が必要」、「実行中」、「完了」の下にグループ化されています。各行はセッションの名前、最新のステータスまたは質問、および時間を表示します。下部には新しいタスクを説明するための入力と、キーボードヒントの行があります。](https://mintcdn.com/claude-code/v_J840yKc6uuKDX_/images/agent-view-light.png?fit=max\&auto=format\&n=v_J840yKc6uuKDX_\&q=85\&s=bd95fda83ea66ca8b2e0e7b68f8cb29e)
+![ターミナルのエージェントビュー。上部の行は、入力を待機しているセッション、実行中のセッション、完了したセッションの数をカウントします。4 つのセッションは「入力が必要」、「実行中」、「完了」の下にグループ化されています。各行はセッションの名前、最新のステータスまたは質問、および時間を表示します。下部には新しいタスクを説明するための入力と、キーボードヒントの行があります。](https://mintcdn.com/claude-code/H7YQo-xfDxC94ETh/images/agent-view-light.png?fit=max\&auto=format\&n=H7YQo-xfDxC94ETh\&q=85\&s=f27b570ff81c2a316bef487645b1331c)
 
 Claude が複数の独立したタスクに対して、あなたが毎ステップを監視することなく作業できる場合に、エージェントビューを使用します。バグ修正、プルリクエストレビュー、不安定なテストの調査を 3 つの行としてディスパッチし、別のウィンドウで作業を続け、行が入力が必要であることを示すか、結果が得られたときに確認します。
@@ -266,5 +266,5 @@ Windows では、アタッチしてから約 0.5 秒以内に `←` を押すと
 プロンプトのテキストの最後の文字を削除した直後、またはプロンプト履歴を移動した直後に `←` を押すと、Claude Code は確認を求めます。最初の押下では `Press ← again to open agents`（アタッチされたセッションでは `Press ← again to go back to agents`）が表示され、2 回目の押下で切り替わります。
 
-`←` がフォアグラウンドセッションをバックグラウンドにすると、エージェントビューはリストの上に `Your conversation moved to the background` を表示し、そのセッションの行が既に選択されています。そこから：
+`←` でセッションをバックグラウンドにした後：
 
 * `Enter` を押して会話を再度開きます。
```

</details>

<details>
<summary>amazon-bedrock-ja.md</summary>

```diff
diff --git a/docs-ja/pages/amazon-bedrock-ja.md b/docs-ja/pages/amazon-bedrock-ja.md
index 95aa4b3..663cebf 100644
--- a/docs-ja/pages/amazon-bedrock-ja.md
+++ b/docs-ja/pages/amazon-bedrock-ja.md
@@ -466,5 +466,5 @@ export ANTHROPIC_BEDROCK_SERVICE_TIER=priority
 ```
 
-Claude Code は、この変数が設定されたセッションからのすべての [Invoke API](https://docs.aws.amazon.com/bedrock/latest/APIReference/API_runtime_InvokeModelWithResponseStream.html) リクエストで、これを `X-Amzn-Bedrock-Service-Tier` ヘッダーとして送信します。ただし、[モデルアクセスチェック](#startup-model-checks)は除きます。この設定は、[Mantle エンドポイント](#use-the-mantle-endpoint)へのリクエストや [Claude apps ゲートウェイ](https://code.claude.com/docs/ja/claude-apps-gateway)を経由するリクエストには影響しません。ティアの可用性はモデルとリージョンによって異なります。予約容量は、この設定の代わりに[プロビジョニングされたスループット](https://docs.aws.amazon.com/bedrock/latest/userguide/prov-throughput.html) ARN をモデル ID として使用します。
+Claude Code は、この変数が設定されたセッションからのすべての [Invoke API](https://docs.aws.amazon.com/bedrock/latest/APIReference/API_runtime_InvokeModelWithResponseStream.html) リクエストで、これを `X-Amzn-Bedrock-Service-Tier` ヘッダーとして送信します。ただし、[モデルアクセスチェック](#startup-model-checks)は除きます。この設定は、[Mantle エンドポイント](#use-the-mantle-endpoint)へのリクエストや [Claude apps ゲートウェイ](https://code.claude.com/docs/ja/claude-apps-gateway)を経由するリクエストには影響しません。ティアの可用性はモデルとリージョンによって異なります。
 
 ターミナルから開始する[バックグラウンドセッション](https://code.claude.com/docs/ja/agent-view.md#settings-and-provider)にも適用するには、設定の [`env`](https://code.claude.com/docs/ja/settings-reference#env) ブロックで `ANTHROPIC_BEDROCK_SERVICE_TIER` を設定します。これらのセッションがエクスポートした値を受け取るのは、[スーパーバイザー](https://code.claude.com/docs/ja/agent-view.md#the-supervisor-process)を開始したシェルがその値をエクスポートしていた場合のみです。
```

</details>

<details>
<summary>analytics-ja.md</summary>

```diff
diff --git a/docs-ja/pages/analytics-ja.md b/docs-ja/pages/analytics-ja.md
index cc8b9e9..fdcd4dd 100644
--- a/docs-ja/pages/analytics-ja.md
+++ b/docs-ja/pages/analytics-ja.md
@@ -72,9 +72,8 @@ GitHub 認証フローを完了し、分析に含める GitHub 組織を選択
 > これらのメトリクスは意図的に保守的であり、Claude Code の実際の影響の過小評価を表しています。Claude Code の関与に高い信頼度がある行と PR のみがカウントされます。
 
-ダッシュボードの上部に以下のサマリーメトリクスが表示されます。
+ダッシュボードには以下のサマリーメトリクスが表示されます。
 
-* **PRs with CC**：Claude Code で記述された少なくとも 1 行のコードを含むマージされたプルリクエストの総数
-* **Lines of code with CC**：Claude Code 支援で記述されたすべてのマージされた PR 全体のコード行数。「有効な行」のみがカウントされます。正規化後に 3 文字以上の行で、空行と括弧またはトリビアルな句読点のみの行を除きます。
-* **PRs with Claude Code（%）**：Claude Code 支援コードを含むすべてのマージされた PR のパーセンテージ
+* **PRs with Claude Code**：Claude Code で記述された少なくとも 1 行のコードを含むマージされたプルリクエスト。1 つのカードには件数が、もう 1 つのカードにはマージされたすべての PR に占める割合が表示されます
+* **LOC with Claude Code**：Claude Code 支援で記述された、すべてのマージされた PR 全体のコード行（LOC）の総数。「有効な行」のみがカウントされます。これは正規化後に 3 文字を超える行です。
 * **Suggestion accept rate**：ユーザーが Claude Code のコード編集提案を受け入れる回数のパーセンテージ。Edit、Write、NotebookEdit ツール使用を含みます。
 * **Lines of code accepted**：受け入れられた編集において Claude Code の Edit ツールと Write ツールが追加または削除したコード行の総数。拒否された提案は除外され、後で削除された行によって合計が減ることはありません。
@@ -84,17 +83,7 @@ GitHub 認証フローを完了し、分析に含める GitHub 組織を選択
 ダッシュボードには、時系列でトレンドを視覚化するためのいくつかのチャートが含まれています。
 
-#### 採用を追跡する
-
-採用チャートは日次使用トレンドを表示します。
-
-* **users**：日次アクティブユーザー
-* **sessions**：1 日あたりのアクティブな Claude Code セッション数
-
 #### ユーザーあたりの PR を測定する
 
-このチャートは、時系列での個々の開発者アクティビティを表示します。
```

</details>

<details>
<summary>artifacts-ja.md</summary>

```diff
diff --git a/docs-ja/pages/artifacts-ja.md b/docs-ja/pages/artifacts-ja.md
index a80e153..8322fce 100644
--- a/docs-ja/pages/artifacts-ja.md
+++ b/docs-ja/pages/artifacts-ja.md
@@ -205,5 +205,5 @@ Claude は、1 時間以内にそのアーティファクトで 60 件の送信
 以下のいずれかの方法で、Claude の自動返信を停止できます。
 
-* **アイドルプロンプトで Ctrl+C を 1 回押す**：Claude はセッションが監視しているすべてのアーティファクトへの返信を一時停止します。次のメッセージを送信した後、返信が再開されます。
+* **アイドル状態の空のプロンプトで Ctrl+C を 1 回押す**：Claude はセッションが監視しているすべてのアーティファクトへの返信を一時停止します。次のメッセージを送信した後、返信が再開されます。
 * **`/tasks` でタスクを停止する**：Claude はそのアーティファクトへの返信を停止し、そこで返信を再開するよう求めるまで停止したままになります。アーティファクトを再度公開しても返信は再開されず、セッションを再開しても停止は適用されたままになります。
 * **3 秒以内に `Ctrl+X Ctrl+K` を 2 回押す**：[すべての実行中のバックグラウンドサブエージェントを停止](https://code.claude.com/docs/ja/interactive-mode.md#general-controls)するコードは、セッションの残りの間、Claude がすべてのアーティファクトに返信するのも停止します。Claude に返信を再開するよう求めても、この停止は元に戻りません。
@@ -243,5 +243,5 @@ Claude は公開処理の一環として、ページが呼び出せるコネク
 コネクタを利用するページは描画されるものの、組織内の閲覧者に対してライブセクションが空のままになる場合は、次の原因を確認してください。
 
-* **閲覧者がコネクタを接続していない**：コネクタはアカウントごとに設定されるため、各閲覧者はページが呼び出すすべてのコネクタについて、自分自身の接続が必要です。claude.ai の [**Customize > Connectors**](https://claude.ai/customize/connectors) でコネクタを追加してから、ページを再読み込みしてもらいます。
+* **閲覧者がコネクタを接続していない**：コネクタはアカウントごとに設定されるため、各閲覧者はページが呼び出すすべてのコネクタについて、自分自身の接続が必要です。[claude.ai/customize/connectors](https://claude.ai/customize/connectors) でコネクタを追加してから、ページを再読み込みしてもらいます。
 * **閲覧者が権限の確認を拒否した**：拒否はそのページ読み込みの間だけ有効です。ページを再読み込みすると、権限の確認が再び表示されます。
 * **組織でコネクタ呼び出しが無効になっている**：Owner が管理設定の [**Enable artifact connectors** トグル](#control-connector-calls-from-artifacts)を制御します。
@@ -324,23 +324,19 @@ Claude はデザインシステムを独自の選択肢より高い優先度と
 タイポグラフィについて、Claude は Google Fonts からタイプフェイスを読み込むことができます。これはアーティファクトページが読み込むことができる唯一の外部フォントソースです。Claude は他のタイプフェイスを `@font-face` データ URI としてインライン化し、すべてのタイプフェイスにフォールバックスタックを提供するため、フォントが読み込まれない場合でもページは引き続きレンダリングされます。特定のタイプフェイスを使用するには、プロンプトまたはデザインシステムで名前を付けます。
 
-## スライド、デザイン、またはドキュメントテンプレートから開始する
+## テンプレートからアーティファクトを開始する
 
-ページをゼロから構築する代わりに、Claude は claude.ai アカウント上のテンプレートの 1 つからアーティファクトを開始できます。プレゼンテーション用の [Claude Slides](https://support.claude.com/en/articles/17153992-what-are-artifacts-and-how-do-i-use-them#h_11d5a9a5fa)、ビジュアルデザイン用の [Claude Design](https://support.claude.com/en/articles/14604416-get-started-with-claude-design)、または他の人が読んで編集するドキュメント用の [Claude Docs](https://support.claude.com/en/articles/16923645-get-started-with-claude-docs) です。各テンプレートは claude.ai 上の独自のエディターで開き、あなたとチームメンバーが直接変更するか Claude に変更を依頼でき、PowerPoint、PDF、Word などの形式にエクスポートできます。
+claude.ai アカウント上の[アーティファクトテンプレート](https://support.claude.com/en/articles/17153992-what-are-artifacts-and-how-do-i-use-them#h_11d5a9a5fa)は Claude Code からも使用できます。たとえば、ビジュアルデザインには [Claude Design](https://support.claude.com/en/articles/14604416-get-started-with-claude-design) テンプレートを、他の人が読んで編集するドキュメントには [Claude Docs](https://support.claude.com/en/articles/16923645-get-started-with-claude-docs) テンプレートを使用します。アカウントには Sheets、Whiteboards、Data などの他のテンプレートが含まれている場合もあります。セッションで利用できるテンプレートを確認するには、利用可能なアーティファクトテンプレートを一覧表示するよう Claude に依頼してください。
 
-テンプレートから開始するには、「移行ノートを木曜日のレビュー用のデッキに変換する」や「このプランをチーム用のドキュメントとして作成する」など、必要な内容を説明します。Claude は一致するテンプレートを選択し、リクエストとセッションが既に持っている内容から入力し、リンクを提供します。デッキまたはデザインの場合、`/slides` または `/design` をブリーフと共に実行することもできます。
+Claude Code からテンプレートを使用するには、次のものが必要です。
 
```

</details>

<details>
<summary>authentication-ja.md</summary>

```diff
diff --git a/docs-ja/pages/authentication-ja.md b/docs-ja/pages/authentication-ja.md
index a9865d3..2fc3ae9 100644
--- a/docs-ja/pages/authentication-ja.md
+++ b/docs-ja/pages/authentication-ja.md
@@ -97,5 +97,5 @@ API ベースの請求を希望する組織の場合、Claude Console を通じ
 以下のいずれかの方法でユーザーを追加できます。
 
-* [platform.claude.com/settings/members](https://platform.claude.com/settings/members) にある Console の Members ページからユーザーを一括招待します。**Invite** をクリックします
+* [platform.claude.com/settings/members](https://platform.claude.com/settings/members) にある Console の Members ページからユーザーを一括招待します。**Invite to organization** をクリックします
 * [SSO を設定](https://support.claude.com/en/articles/13132885-setting-up-single-sign-on-sso)
 
```

</details>

<details>
<summary>auto-mode-config-ja.md</summary>

```diff
diff --git a/docs-ja/pages/auto-mode-config-ja.md b/docs-ja/pages/auto-mode-config-ja.md
index 0dd3777..98ebecd 100644
--- a/docs-ja/pages/auto-mode-config-ja.md
+++ b/docs-ja/pages/auto-mode-config-ja.md
@@ -225,5 +225,5 @@ Claude Code のプロンプトで `/auto-mode-setup` と入力すると `Unknown
 > [!NOTE]
 >
-> [Code Mode](https://code.claude.com/docs/ja/code-mode.md#permission-checks) セッションでは、分類器は Claude のコードをレビューする際に `hard_deny` と `soft_deny` を適用し、コードが行う個々のツール呼び出しには適用しません。`permissions.deny` ルールは個々の呼び出しに適用されます。
+> [Code Mode](https://code.claude.com/docs/ja/code-mode.md#permission-checks) セッションでは、分類器はコードが実行される前に、各コード片の全体に対して `hard_deny` と `soft_deny` を適用します。コードが行う特定のツール呼び出しをブロックするには、`permissions.deny` ルールを使用します。
 
 分類器内では、優先順位は 4 つのレベルで機能します。
```

</details>

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index 0746feb..ca67d5a 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,374 @@
 # Changelog
 
+## 2.1.326
+
+- Added support for turning on Code Mode while agent teams are enabled; if you already turned it on, sessions with teams on now start in Code Mode
+- Added a startup warning when an `--allowedTools`, `--disallowedTools` or `--tools` value has an entry that doesn't look like a complete rule
+- Added a message explaining why MCP servers stop loading when an administrator adds `managed-mcp.json` during a session
+- Added a row to `/status` that says when your provider or an environment variable such as `DISABLE_TELEMETRY` turns features off
+- Added a note in `/plugin` and `claude plugin list` when a malformed `plugin.json` field such as `author` or `homepage` is ignored
+- Added Ctrl+O to show hidden startup notices
+- Added a hint in the empty prompt that says what to do after a request fails
+- Added an `esc to stop` footer hint in a subagent's view where Esc would stop it
+- Added `OTEL_RESOURCE_INCLUDE_HOST` to include `host.name` and `host.id` in OpenTelemetry resource attributes (off by default)
+- Added `overflowX="scroll"` on a mod's `Box`, and `maxLines` and `wrap="clip"` on its `Text`
+- Fixed `cp` of a file being refused when only its source was covered by an `Edit` deny rule
+- Fixed Bash commands that delete or overwrite files (`find -delete`, `cat a > b`, `sort -o`) being summed up in the transcript as a search or a read
+- Fixed a misleading "Dangerous rm operation" warning in the Bash permission prompt on some commands with no rm that Claude Code can't read reliably
+- Fixed background sessions losing the LLM gateway your shell exported after a crash, after a reopen from another folder, or when the background service lacks it: they now stop before any model request
+- Fixed the background service ending your own processes, such as an SSH login, when a process number on its list had been reused by another user's process
+- Fixed rules added in `/permissions` or at a main-conversation tool prompt, and `/add-dir` folders, looking saved when the settings file couldn't be written; the terminal now warns and names it
+- Fixed a failed MCP `headersHelper`, or one not run in an untrusted folder, making other sessions start without that server, for most servers with no stored OAuth refresh token
+- Fixed managed settings with certain key names stopping Claude Code from starting or affecting other managed files
+- Fixed settings files with values nested thousands of levels deep crashing Claude Code or applying only some of the time; values past 64 levels are now dropped with a warning
+- Fixed a settings file saved with an error mid-session being skipped silently; a warning now names the file
+- Fixed the subagent model set in managed settings not applying in Claude Desktop's Code tab; it now overrides your own, as in a terminal, unless those settings also pick a provider or gateway
```

</details>

<details>
<summary>claude-apps-gateway-config-ja.md</summary>

```diff
diff --git a/docs-ja/pages/claude-apps-gateway-config-ja.md b/docs-ja/pages/claude-apps-gateway-config-ja.md
index d3fe5ab..d41c3f7 100644
--- a/docs-ja/pages/claude-apps-gateway-config-ja.md
+++ b/docs-ja/pages/claude-apps-gateway-config-ja.md
@@ -23,5 +23,5 @@ Claude apps gateway デプロイメントは、慣例的に `gateway.yaml` と
 * [`session`](#session)：ゲートウェイが発行するベアラートークン、シークレット、ライフタイム
 * [`store`](#store)：デバイスグラント、レート制限カウンター用の PostgreSQL
-* [`upstreams`](#upstreams)：推論の送信先、Anthropic、Amazon Bedrock、AWS 上の Claude Platform、Google Cloud の Agent Platform、Microsoft Foundry のいずれか
+* [`upstreams`](#upstreams)：推論の送信先、Anthropic、Amazon Bedrock、AWS 上の Claude Platform、Google Cloud 上の Claude Models（Anthropic 管理）、Google Cloud の Agent Platform、Microsoft Foundry のいずれか
 
 **オプションセクション：**
@@ -176,5 +176,5 @@ export CLAUDE_GATEWAY_PROXY_IS_EGRESS_BOUNDARY=1
 | `provider: anthropic` のアップストリーム、Workload Identity Federation のトークン交換、`telemetry.forward_to` のエクスポート | ローカルで解決およびチェックされた後、チェック済みの IP アドレスへプロキシ経由で `CONNECT`。`NO_PROXY` に列挙されたテレメトリコレクターには代わりに直接到達 | ホスト名をプロキシに渡す |
 | IdP のディスカバリ、JWKS、トークン、userinfo | [`oidc.use_proxy: true`](#idp-requests-through-a-forward-proxy) でない限り直接。その場合はチェック済みの IP アドレスへ `CONNECT` | ホスト名をプロキシに渡す。ただし `oidc.use_proxy: false` で内部 IdP を直接のままにできる |
-| Amazon Bedrock、Claude Platform on AWS、Google Cloud の Agent Platform、Microsoft Foundry のアップストリーム、Google グループの検索 | ホスト名をプロキシに渡す | 変更なし |
+| Amazon Bedrock、Claude Platform on AWS、Claude Models on Google Cloud (Anthropic managed)、Google Cloud の Agent Platform、Microsoft Foundry のアップストリーム、Google グループの検索 | ホスト名をプロキシに渡す | 変更なし |
 
 プロキシのみのエグレスは、ゲートウェイの環境が次の 3 つの条件をすべて満たさない限りオフのままです。
@@ -611,4 +611,22 @@ upstreams:
 このプラットフォームはファーストパーティのモデル ID を解決するため、組み込みカタログは [`models:`](#models) ブロックなしでこのプラットフォームにルーティングされます。`models:` リストを独自に作成する場合は、エントリのキーを `anthropicAws:` にしてファーストパーティの ID を指定してください。
 
+#### Claude Models on Google Cloud (Anthropic managed)
+
+Claude Models on Google Cloud (Anthropic managed) は、Google Cloud プロジェクトを通じてアクセスする、Anthropic が運用する Claude API です。モデルリクエストをここに送信するには、`anthropicGoogleCloud` プロバイダーを使用したアップストリームを追加します。
+
+アップストリームを追加する前に、ゲートウェイのレプリカを Claude Code v2.1.307 以降にアップグレードし、[Google Cloud プロジェクトでサービスをセットアップ](https://platform.claude.com/docs/en/build-with-claude/claude-models-on-google-cloud/anthropic-managed#set-up-your-account)してください。ゲートウェイの Google 認証情報が解決される ID に、そのプロジェクトに対する `roles/claude.user` を付与します。
+
+```yaml theme={null}
+upstreams:
+  - provider: anthropicGoogleCloud
```

</details>

*...以降省略*

</details>


<details>
<summary>2026-11-15</summary>

**変更ファイル:**

```
 docs-ja/pages/advisor-ja.md                    |   6 +-
 docs-ja/pages/agent-view-ja.md                 |  18 +-
 docs-ja/pages/artifacts-ja.md                  |   1 -
 docs-ja/pages/auto-mode-config-ja.md           |  32 +-
 docs-ja/pages/best-practices-ja.md             |   4 +-
 docs-ja/pages/checkpointing-ja.md              |   2 +-
 docs-ja/pages/chrome-ja.md                     |   8 +-
 docs-ja/pages/claude-apps-gateway-config-ja.md |   2 +-
 docs-ja/pages/claude-directory-ja.md           |   1 +
 docs-ja/pages/cli-reference-ja.md              |   2 +-
 docs-ja/pages/commands-ja.md                   |   6 +-
 docs-ja/pages/debug-your-config-ja.md          |  10 +-
 docs-ja/pages/desktop-ja.md                    |   2 +-
 docs-ja/pages/env-vars-ja.md                   |  13 +-
 docs-ja/pages/fast-mode-ja.md                  |   2 +-
 docs-ja/pages/feature-availability-ja.md       |  54 +-
 docs-ja/pages/google-vertex-ai-ja.md           |   4 +
 docs-ja/pages/headless-ja.md                   |  16 +-
 docs-ja/pages/hooks-guide-ja.md                |  22 +-
 docs-ja/pages/hooks-ja.md                      |  23 +-
 docs-ja/pages/interactive-mode-ja.md           |   7 +-
 docs-ja/pages/llm-gateway-protocol-ja.md       |   2 +-
 docs-ja/pages/managed-settings-ja.md           |   2 +-
 docs-ja/pages/mcp-ja.md                        |   8 +-
 docs-ja/pages/mcp-quickstart-ja.md             |   2 +-
 docs-ja/pages/microsoft-foundry-ja.md          |  12 +-
 docs-ja/pages/model-config-ja.md               |  57 ++-
 docs-ja/pages/monitoring-usage-ja.md           | 658 ++++++++++++-------------
 docs-ja/pages/network-config-ja.md             |   4 +-
 docs-ja/pages/permission-modes-ja.md           |   8 +-
 docs-ja/pages/permissions-ja.md                |   6 +-
 docs-ja/pages/remote-control-ja.md             |  16 +-
 docs-ja/pages/server-managed-settings-ja.md    |  10 +-
 docs-ja/pages/sessions-ja.md                   |  26 +-
 docs-ja/pages/settings-example-ja.md           |   2 +-
 docs-ja/pages/settings-reference-ja.md         |  19 +-
 docs-ja/pages/skills-ja.md                     |  25 +-
 docs-ja/pages/statusline-ja.md                 |   2 +-
 docs-ja/pages/terminal-config-ja.md            |   2 +-
 docs-ja/pages/third-party-integrations-ja.md   |   1 +
 docs-ja/pages/tools-reference-ja.md            |  16 +-
 docs-ja/pages/vs-code-ja.md                    |  17 +-
 docs-ja/pages/zero-data-retention-ja.md        |   1 +
 43 files changed, 638 insertions(+), 493 deletions(-)
```

**新規追加:**


<details>
<summary>advisor-ja.md</summary>

```diff
diff --git a/docs-ja/pages/advisor-ja.md b/docs-ja/pages/advisor-ja.md
index c44ff56..14c156c 100644
--- a/docs-ja/pages/advisor-ja.md
+++ b/docs-ja/pages/advisor-ja.md
@@ -9,5 +9,5 @@
 > [!NOTE]
 >
-> advisor ツールは実験的機能であり、Anthropic API または [Claude Platform on AWS](https://code.claude.com/docs/ja/claude-platform-on-aws.md) が必要です。Claude Platform on AWS では、Claude Code v2.1.300 以降が必要です。Amazon Bedrock、Google Cloud の Agent Platform、Microsoft Foundry では利用できません。動作、価格設定、および利用可能性は変更される可能性があります。
+> advisor ツールは実験的機能であり、Anthropic API、[Claude Platform on AWS](https://code.claude.com/docs/ja/claude-platform-on-aws.md)、または [Claude Models on Google Cloud (Anthropic managed)](https://code.claude.com/docs/ja/claude-models-on-google-cloud-anthropic-managed.md) が必要です。Claude Platform on AWS または Claude Models on Google Cloud (Anthropic managed) では、Claude Code v2.1.300 以降が必要です。Amazon Bedrock、Google Cloud の Agent Platform、Microsoft Foundry では利用できません。動作、価格設定、および利用可能性は変更される可能性があります。
 
 advisor ツールを使用すると、Claude はタスク中の重要な瞬間（アプローチをコミットする前、繰り返し発生するエラーで行き詰まった場合、またはタスク完了を宣言する前など）に、通常はより強力な 2 番目のモデルに相談できます。advisor は、すべてのツール呼び出しと結果を含む完全な会話を受け取り、Claude が続行する前に適用するガイダンスを返します。
@@ -175,8 +175,8 @@ advisor モデル自体の会話の読み取りはキャッシュされません
 ## 要件
 
-* **プロバイダー**：Anthropic API または [Claude Platform on AWS](https://code.claude.com/docs/ja/claude-platform-on-aws.md)。Amazon Bedrock、Google Cloud の Agent Platform、Microsoft Foundry では利用できません。Claude Platform on AWS では、advisor を使用するには Claude Code v2.1.300 以降が必要です。
+* **プロバイダー**：Anthropic API、[Claude Platform on AWS](https://code.claude.com/docs/ja/claude-platform-on-aws.md)、または [Claude Models on Google Cloud（Anthropic managed）](https://code.claude.com/docs/ja/claude-models-on-google-cloud-anthropic-managed.md)。Amazon Bedrock、Google Cloud の Agent Platform、Microsoft Foundry では利用できません。Claude Platform on AWS または Claude Models on Google Cloud（Anthropic managed）では、advisor を使用するには Claude Code v2.1.300 以降が必要です。
 * **LLM ゲートウェイ**：`ANTHROPIC_BASE_URL` で構成された [LLM ゲートウェイ](https://code.claude.com/docs/ja/llm-gateway)を経由する場合、利用可能性はゲートウェイがリクエストを Anthropic API にそのまま転送するかどうかに依存します。ゲートウェイまたはそのアップストリームが advisor ツールを認識しない場合に Claude Code がどのように応答するかについては、[自動再試行とエラー転送](https://code.claude.com/docs/ja/llm-gateway-protocol.md#automatic-retry-and-error-forwarding)を参照してください。
 * **サポートされているメインモデル**：Fable、Opus 4.6 以降、Sonnet 4.6 以降、Haiku 4.5、または Haiku 5.5。各メインモデルがどの advisor を受け入れるかについては、[advisor モデルを選択する](#choose-an-advisor-model)を参照してください。
-* **フィーチャーフラグ取得**：Claude Platform on AWS を使用している場合を除き、advisor には Anthropic から取得するフィーチャーフラグが必要です。`DISABLE_TELEMETRY` など、取得をオフにする変数が設定されているセッションには、そのフラグがありません。セッションを確認するには、[取得をスキップするセッション、またはフラグなしで開始するセッション](https://code.claude.com/docs/ja/env-vars.md#features-that-need-feature-flag-fetching)を参照してください。
+* **フィーチャーフラグ取得**：Claude Platform on AWS または Claude Models on Google Cloud（Anthropic managed）を使用している場合を除き、advisor には Anthropic から取得するフィーチャーフラグが必要です。`DISABLE_TELEMETRY` など、取得をオフにする変数が設定されているセッションには、そのフラグがありません。セッションを確認するには、[取得をスキップするセッション、またはフラグなしで開始するセッション](https://code.claude.com/docs/ja/env-vars.md#features-that-need-feature-flag-fetching)を参照してください。
 
 ## advisor をオフにする
```

</details>

<details>
<summary>agent-view-ja.md</summary>

```diff
diff --git a/docs-ja/pages/agent-view-ja.md b/docs-ja/pages/agent-view-ja.md
index 2d95f35..f78e4db 100644
--- a/docs-ja/pages/agent-view-ja.md
+++ b/docs-ja/pages/agent-view-ja.md
@@ -376,5 +376,6 @@ Claude Code がセッションをバックグラウンドにすると（約 10 
 | `Ctrl+X` | セッションを停止。2 秒以内に再度押して削除 |
 | `Shift+↑` / `Shift+↓` | 選択したセッションを並べ替え |
-| `Esc` | ピークパネルを閉じるか、入力をクリアするか、終了します。`←` でセッションをバックグラウンドにしてエージェントビューを開いた場合、最後の `Esc` は終了する代わりにその会話に戻ります。[vim エディターモード](https://code.claude.com/docs/ja/interactive-mode.md#vim-editor-mode) がオンの場合、入力で `Esc` を押すと、メインプロンプトと同様に INSERT から NORMAL モードに切り替わり、テキストは保持されます |
+| `Esc` | ピークパネルを閉じるか、入力をクリアするか、終了します。Claude Code v2.1.323 以降では、プロンプトのクリアには 2 回の押下が必要です。`←` でセッションをバックグラウンドにしてエージェントビューを開いた場合、最後の `Esc` は終了する代わりにその会話に戻ります。[vim エディターモード](https://code.claude.com/docs/ja/interactive-mode.md#vim-editor-mode) がオンの場合、入力で `Esc` を押すと、メインプロンプトと同様に INSERT から NORMAL モードに切り替わり、テキストは保持されます |
+| `Ctrl+Y` | ディスパッチ入力で、最後にクリアしたテキスト、または `Ctrl+K`、`Ctrl+U`、`Ctrl+W` で削除したテキストを復元します。エージェントビューが終了すると、そのテキストは失われます |
 | `Ctrl+C` | 入力をクリア。2 回押して終了。画面上のテキストが選択されている間は、代わりに選択を解除します。その際、[選択時に既にコピーされている](https://code.claude.com/docs/ja/settings-reference.md#copyonselect) 場合を除き、先に選択内容をコピーします |
 | `?` | ショートカットを表示 |
@@ -482,5 +483,5 @@ Claude Code がセッションをバックグラウンドにすると（約 10 
 セッションをバックグラウンドに移動すると、進行中のバックグラウンド作業は種類ごとに、バックグラウンドセッションに引き継がれるか、Claude がそこで再起動した場合にのみ続行されるか、停止するかのいずれかになります。
 
-* **引き継がれるもの**: 実行中のバックグラウンドシェルコマンド、バックグラウンド化されたサブエージェント、[`/loop`](https://code.claude.com/docs/ja/scheduled-tasks) で作成したスケジュールタスク、および Claude の [アーティファクトコメントへの自動返信](https://code.claude.com/docs/ja/artifacts.md#let-claude-reply-to-comments-on-its-own) は、バックグラウンドセッションで実行を続けます。サブエージェントは自身が開始したすべてのものと一緒に移動するため、その作業のすべてが移動できる場合にのみ引き継がれます。
+* **引き継がれるもの**: 実行中のバックグラウンドシェルコマンド、バックグラウンド化されたサブエージェント、および [`/loop`](https://code.claude.com/docs/ja/scheduled-tasks) で作成したスケジュールタスクは、バックグラウンドセッションで実行を続けます。サブエージェントは自身が開始したすべてのものと一緒に移動するため、その作業のすべてが移動できる場合にのみ引き継がれます。
 * **Claude が再起動した場合にのみ続行されるもの**: 実行中の [動的ワークフロー](https://code.claude.com/docs/ja/workflows.md)。バックグラウンドセッションを確認したときにワークフローが続行されていない場合は、[Claude に再起動を依頼してください](#dynamic-workflows-when-you-background)。
 * **停止するもの**: 実行中の [モニター](https://code.claude.com/docs/ja/tools-reference.md#monitor-tool) など、バックグラウンドセッションに移動できない作業。そのような作業が実行中の場合、Claude Code は `Background this session?` ダイアログを表示し、作業を停止する前に確認できるようにします。モニターを所有するバックグラウンド化されたサブエージェントは、モニターと一緒に停止します。
@@ -902,9 +903,9 @@ Background sessions still running will stop in about a minute. Run 'claude agent
 ### バックグラウンド化が `Background this session?` ダイアログを表示する
 
-`←` を押してセッションをバックグラウンドに移すときに `Background this session?` ダイアログが表示される場合、そのセッションには、停止する、中断される、または無人で実行され続けることになる実行中のバックグラウンド作業があります：
+`←` を押してセッションをバックグラウンドに移すときに `Background this session?` ダイアログが表示される場合、そのセッションには、停止または中断されることになる実行中のバックグラウンド作業があります：
 
 * **移動できない作業**：セッションには、実行中の [モニター](https://code.claude.com/docs/ja/tools-reference.md#monitor-tool) など、バックグラウンドセッションに移動できない作業があります。ダイアログは Claude Code が停止するバックグラウンド作業を名前で表示し、転送されるタスクは別にカウントします。
 * **実行中のサブエージェントを持つワークフロー**：[動的ワークフロー](https://code.claude.com/docs/ja/workflows.md)にはまだ実行中のサブエージェントがあります。それでもバックグラウンド化すると、それらのサブエージェントは停止し、ダイアログはその数を表示します。Claude が[バックグラウンドセッションでワークフローを再起動する](#dynamic-workflows-when-you-background)と、それらのサブエージェントは最初からやり直します。
-* **自動アーティファクト返信**：Claude が[アーティファクトのコメントに自動で返信している](https://code.claude.com/docs/ja/artifacts.md#let-claude-reply-to-comments-on-its-own)場合があります。これらの返信はバックグラウンドセッションで続行され、ダイアログはそのことを表示します。
+* **自動アーティファクト返信**：Claude が[アーティファクトのコメントに自動で返信している](https://code.claude.com/docs/ja/artifacts.md#let-claude-reply-to-comments-on-its-own)場合があります。それでもバックグラウンド化すると、これらの返信は停止します。
 
```

</details>

<details>
<summary>artifacts-ja.md</summary>

```diff
diff --git a/docs-ja/pages/artifacts-ja.md b/docs-ja/pages/artifacts-ja.md
index b2d142a..a80e153 100644
--- a/docs-ja/pages/artifacts-ja.md
+++ b/docs-ja/pages/artifacts-ja.md
@@ -369,5 +369,4 @@ README などのコードベースに属するドキュメントはファイル
 | バックエンドなし | アーティファクトは静的ページです。ビューアを自身で認証することはできません。 |
 | ダウンロード | ページはダウンロードを自身で開始することはできません。ビューアがページが生成するファイルを保存できるようにするには、Claude はダウンロード機能を宣言します。[ファイルダウンロードを提供する](#offer-a-file-download)を参照してください。 |
-| シングルページ | 相対リンクは解決されません。ページと一緒に何もデプロイされていないためです。マルチセクションコンテンツの場合、Claude は個別ファイルではなくページ内アンカーを使用します。 |
 | ソースファイルタイプ | 公開されるファイルは `.html`、`.htm`、または `.md` である必要があり、UTF-8 として、またはバイトオーダーマークによってリトルエンディアン UTF-16 としてデコードできる必要があります。Markdown ファイルはスタイル付きドキュメントページとしてレンダリングされ、構文強調表示されたコードが含まれます。デコードできないファイル、または置換文字 `U+FFFD` を含むファイルは、[修正する行と列とともに拒否されます](https://code.claude.com/docs/ja/errors.md#the-source-file-is-not-valid-utf-8-text)。 |
 | ソースの場所 | ネットワークホストを指すパスにあるファイルは、読み込まれることなく拒否されます。拒否されるパスと、Windows でのマップされたドライブの例外については、[公開されませんでした：そのファイルはネットワーク共有上にあります](https://code.claude.com/docs/ja/errors.md#not-published-that-file-is-on-a-network-share)を参照してください。 |
```

</details>

<details>
<summary>auto-mode-config-ja.md</summary>

```diff
diff --git a/docs-ja/pages/auto-mode-config-ja.md b/docs-ja/pages/auto-mode-config-ja.md
index c7ab6a8..0dd3777 100644
--- a/docs-ja/pages/auto-mode-config-ja.md
+++ b/docs-ja/pages/auto-mode-config-ja.md
@@ -29,5 +29,5 @@
 ## 一般的な境界
 
-オートモードでは、作業中のリポジトリのあらゆるブランチ（デフォルトブランチを含む）へのプッシュが許可され、デフォルトではプルリクエストの作成も可能です。`production`、`release`、`gh-pages` など、デプロイまたは公開ターゲットとしてマークされた非デフォルトブランチは、このデフォルトの対象外です。分類器はそこへのプッシュを独自の条件で判定し、本番環境へのデプロイとして扱います。プッシュの内容も引き続きチェックされるため、強制プッシュ、コミットへのシークレット入力、または CI やデプロイパイプラインの実行時にシークレットをリポジトリ外に送信する変更は、ブロックされたままです。
+auto モードでは、デフォルトで、Claude は作業中のリポジトリ（デフォルトブランチを含む）へのプッシュをプロンプトなしで実行できます。また、タスクで求められた場合は、そこでプルリクエストを作成することもできます。シークレットを含むプッシュや別のリポジトリへのプルリクエストなど、一部のプッシュやプルリクエストは[ブロックされます](https://code.claude.com/docs/ja/permission-modes.md#what-the-classifier-blocks-by-default)。
 
 Claude のプッシュおよびプルリクエストコマンドの前に人間によるチェックポイントが必要な場合は、権限ルールを追加してください。[以下のレシピ](#add-a-human-checkpoint)では、他のすべてのアクションに対してオートモードを有効に保ちます。
@@ -35,5 +35,5 @@ Claude のプッシュおよびプルリクエストコマンドの前に人間
 ### 人間によるチェックポイントを追加する
 
-最も直接的なメカニズムは [`permissions.ask`](https://code.claude.com/docs/ja/permissions#permission-rule-syntax) です。以下のようなコンテンツスコープの ask ルールは、分類器の前に評価され、オートモードでも常に権限プロンプトを強制します。これは、明示的な ask ルールがそのアクションについてプロンプトを表示する意図を示しているためです。[設定](https://code.claude.com/docs/ja/settings.md#where-settings-live)にルールを追加してください。
+最も直接的なメカニズムは [`permissions.ask`](https://code.claude.com/docs/ja/permissions#permission-rule-syntax) です。以下の確認ルールは分類器の前に評価されるため、デフォルトではプロンプトが表示されます。[設定](https://code.claude.com/docs/ja/settings.md#where-settings-live)にルールを追加してください。
 
 ```json theme={null}
@@ -54,5 +54,5 @@ Claude のプッシュおよびプルリクエストコマンドの前に人間
 | 境界 | メカニズム | オートモードでの動作 |
 | :- | :- | :- |
-| アクション前にプロンプト表示 | `permissions.ask` | 上記のレシピのようなコンテンツスコープのルールに一致するコマンドに対して常にプロンプトを表示します。分類器は一致するアクションを自動承認できません。 |
+| アクション前にプロンプト表示 | `permissions.ask` | デフォルトでは、上記のレシピのようなコンテンツスコープのルールに一致するコマンドに対してプロンプトを表示します。分類器は一致するアクションを自動承認できません。 |
 | アクションを実行しない | `permissions.deny` | 分類器が参照される前にブロックします。分類器もユーザーの意図も、これをオーバーライドできません。 |
 | このセッション限定の境界 | 「レビューするまでプッシュしない」のように会話で述べる | 分類器は一致するアクションをブロックしますが、[コンテキストコンパクション](https://code.claude.com/docs/ja/costs.md#reduce-token-usage)がそのステートメントを含むメッセージを削除すると、境界が失われる可能性があります。永続的な保証のために ask ルールまたは deny ルールを使用してください。 |
@@ -96,9 +96,9 @@ Claude のプッシュおよびプルリクエストコマンドの前に人間
   * **CI/CD デプロイターゲット**
   * **ネットワーク体制**
-  * **ホスト隔離**: デフォルトは、オープンインターネットを備えた通常の開発者マシンまたは CI ランナーです。Claude Code がコンテナ、VM、またはポッド内で実行され、エグレス許可リストまたは接触してはいけないネイバーがある場合は、許可されたホスト、クラウドメタデータエンドポイントに到達可能かどうか、およびタスクが使用するクラウドプロジェクト、クラスタ、またはレジストリと使用する ID を名前付けします。このエントリがその ID を名前付けするまで、分類器は[ホストの独自の認証情報に対するリクエストをブロック](https://code.claude.com/docs/ja/permission-modes.md#what-the-classifier-blocks-by-default)します。Claude Code v2.1.257 以降が必要です
-  * **保護されたデプロイメント名前空間 / 環境**: 名前を付けるまで「機密リモートターゲット」ヒューリスティックにフォールバックします
```

</details>

<details>
<summary>best-practices-ja.md</summary>

```diff
diff --git a/docs-ja/pages/best-practices-ja.md b/docs-ja/pages/best-practices-ja.md
index 99b6943..6f15027 100644
--- a/docs-ja/pages/best-practices-ja.md
+++ b/docs-ja/pages/best-practices-ja.md
@@ -11,5 +11,5 @@ Claude Code は、ほとんどの場合、新しいセッションで最初に
 例えば：
 
-* 各コマンドを逐一承認しなくても安全に実行できるよう、新しいターミナルおよび VS Code セッションは [auto モード](https://code.claude.com/docs/ja/permission-modes.md#eliminate-prompts-with-auto-mode)で開始します。このモードでは、リスクのある操作は実行前に分類器がレビューします。
+* 各コマンドを逐一承認しなくても実行できるよう、新しいターミナルおよび VS Code セッションは [auto モード](https://code.claude.com/docs/ja/permission-modes.md#eliminate-prompts-with-auto-mode)で開始します。
 * 独立した作業を並列で進めながらメインの会話を集中した状態に保つため、Claude はサブエージェントに委譲し、必要なときだけ確認を求めます。
 * ユーザーが管理しなくても長いセッションを続けられるよう、コンテキストウィンドウがいっぱいになる前に、会話が自動でコンテキスト圧縮されます。
@@ -596,5 +596,5 @@ config/dev-credentials.json
 これらを自分でクリーンアップしなければならないことはほとんどありません：
 
-* 名前のない worktree セッションを終了すると、中身が何もなければ Claude Code は [worktree を削除します](https://code.claude.com/docs/ja/worktrees.md#clean-up-worktrees)。名前付きセッションや変更のあるセッションの場合は、どうするかを尋ねます。
+* 名前のない worktree セッションを終了すると、中身が何もなければ Claude Code は [git で作成した worktree を削除します](https://code.claude.com/docs/ja/worktrees.md#clean-up-worktrees)。名前付きセッションや変更のあるセッションの場合は、どうするかを尋ねます。
 * サブエージェントの worktree は、サブエージェントが変更なしで終了すると消えます。
 * 残されたサブエージェントやバックグラウンドセッションの worktree は、`cleanupPeriodDays` より古くなり、作業を含んでいなければ一掃されます。
```

</details>

<details>
<summary>checkpointing-ja.md</summary>

```diff
diff --git a/docs-ja/pages/checkpointing-ja.md b/docs-ja/pages/checkpointing-ja.md
index f61b283..320b4c0 100644
--- a/docs-ja/pages/checkpointing-ja.md
+++ b/docs-ja/pages/checkpointing-ja.md
@@ -7,5 +7,5 @@
 > Claude のエディット内容と会話を追跡、巻き戻し、要約してセッション状態を管理します。
 
-Claude Code は、作業中に Claude が行ったファイルエディットを自動的に追跡し、変更をすばやく取り消したり、問題が発生した場合に以前の状態に巻き戻したりできます。
+Claude Code は、作業中に Claude が行ったファイルエディットを自動的に追跡します。エディットを取り消すには、セッションで `/rewind` またはそのエイリアスである `/undo` を実行して、[巻き戻しメニュー](#rewind-and-summarize)を開きます。
 
 ## チェックポイントの仕組み
```

</details>

<details>
<summary>chrome-ja.md</summary>

```diff
diff --git a/docs-ja/pages/chrome-ja.md b/docs-ja/pages/chrome-ja.md
index 7d766ed..6fa7ae0 100644
--- a/docs-ja/pages/chrome-ja.md
+++ b/docs-ja/pages/chrome-ja.md
@@ -42,6 +42,4 @@ Claude Code を Chrome で使用する前に、以下が必要です。
 * 直接 Anthropic プラン（Pro、Max、Ultra、Team、または Enterprise）
 
-HIPAA が有効になっている Enterprise 組織では、Claude in Chrome はデフォルトでオフになっており、[Owner](https://code.claude.com/docs/ja/server-managed-settings.md#access-control) が [**Organization settings > Claude in Chrome**](https://claude.ai/admin-settings/browser-extension) でオンにできます。Anthropic との事業提携契約（BAA）は、Claude in Chrome を通じてサードパーティのサイトに送信されるデータを対象としていません。対象サービス（Eligible Services）の一覧については、[実装ガイド](https://trust.anthropic.com/resources?s=l1wrssd9hsbi4gak0tp5a6\&name=%5Banthropic%5D-hipaa-ready-offering-implementation-guide)を参照してください。
-
 Chrome 統合を使用するには、`/login` でサインインする必要もあります。API キーまたは [`claude setup-token`](https://code.claude.com/docs/ja/authentication#generate-a-long-lived-token) で発行した長期間有効なトークンで認証している場合、`--chrome` を渡しても Claude Code は Chrome 統合を無効のままにします。ブラウザ拡張機能はこれらの認証情報では認証できません。
 
@@ -50,4 +48,10 @@ Chrome 統合を使用するには、`/login` でサインインする必要も
 > Chrome 統合は Amazon Bedrock、Google Cloud の Agent Platform、Microsoft Foundry などのサードパーティプロバイダーを通じては利用できません。Claude にサードパーティプロバイダーを通じてのみアクセスする場合、この機能を使用するには別の claude.ai アカウントが必要です。
 
+### HIPAA またはゼロデータ保持が有効な場合の Chrome の利用可否
+
+HIPAA が有効になっている Enterprise 組織では、Claude in Chrome はデフォルトでオフになっており、[Owner](https://code.claude.com/docs/ja/server-managed-settings.md#access-control) が [**Organization settings > Claude in Chrome**](https://claude.ai/admin-settings/browser-extension) でオンにできます。Anthropic との事業提携契約（BAA）は、Claude in Chrome を通じてサードパーティのサイトに送信されるデータを対象としていません。対象サービス（Eligible Services）の一覧については、[実装ガイド](https://trust.anthropic.com/resources?s=l1wrssd9hsbi4gak0tp5a6\&name=%5Banthropic%5D-hipaa-ready-offering-implementation-guide)を参照してください。
+
+組織で Claude Code に対して[ゼロデータ保持（ZDR）](https://code.claude.com/docs/ja/zero-data-retention.md)が有効になっている場合、Claude Code では Claude in Chrome を利用できません。Owner が **Organization settings > Claude in Chrome** でオンにしていても、また `--chrome` を渡しても、オフのままになります。`/chrome` は `Claude in Chrome is disabled by your organization's policy` と表示します。組織が許可している場合は、Claude Code の外で引き続き拡張機能を使用できます。
+
 ## CLI で開始する
 
```

</details>

<details>
<summary>claude-apps-gateway-config-ja.md</summary>

```diff
diff --git a/docs-ja/pages/claude-apps-gateway-config-ja.md b/docs-ja/pages/claude-apps-gateway-config-ja.md
index 3259721..d3fe5ab 100644
--- a/docs-ja/pages/claude-apps-gateway-config-ja.md
+++ b/docs-ja/pages/claude-apps-gateway-config-ja.md
@@ -1348,5 +1348,5 @@ Claude Desktop をデプロイしない場合は、ポリシーから `desktop`
 ##### Code タブで `code` 設定を適用する
 
-ポリシーが [`code`](#choose-cli-or-code) キーの下に持つ Claude Code 設定は、次のすべてが成り立つ場合に Claude Desktop の Code タブで適用されます。
+[一部のプロバイダーとモデルの変数](https://code.claude.com/docs/ja/desktop.md#managed-settings) を除き、ポリシーが [`code`](#choose-cli-or-code) キーの下に持つ Claude Code の設定は、次のすべてが満たされる場合に Claude Desktop の Code タブで適用されます。
 
 * ポリシーに `desktop` キーもあること（空の `desktop: {}` でもかまいません）
```

</details>

<details>
<summary>claude-directory-ja.md</summary>

```diff
diff --git a/docs-ja/pages/claude-directory-ja.md b/docs-ja/pages/claude-directory-ja.md
index cf75f41..e347387 100644
--- a/docs-ja/pages/claude-directory-ja.md
+++ b/docs-ja/pages/claude-directory-ja.md
@@ -138,4 +138,5 @@ Claude Code は、[`cleanupPeriodDays`](https://code.claude.com/docs/ja/settings
 | `skills/.trash/`、`plugins/.trash/` | [スキル](https://code.claude.com/docs/ja/skills.md#how-synced-skills-behave)と [プラグイン](https://code.claude.com/docs/ja/plugins/loading.md#synced-plugins)。claude.ai 同期で削除されたもの。例えば、claude.ai でオフにした後、または同期を停止した後。ファイルはここに残るため、スイープが削除するまで復元できます |
 | `plugins/installed_plugins.set-aside.<date>.<hash>.json`、`plugins/installed_plugins.unreadable.<date>.<hash>.kept` | 日付付きコピー。Claude Code が [`installed_plugins.json`](https://code.claude.com/docs/ja/plugins/loading#find-plugins-on-disk) を書き直す前に作成します。削除したインストールレコード、および読み込めなかったファイルの内容 |
+| `plugins/mcpb/` | プラグインが宣言する [MCP バンドル](https://code.claude.com/docs/ja/plugins/components.md#include-a-packaged-mcpb-server)から Claude Code が展開したファイル。バンドルの経過日数は、それを最後に使用したセッションから数えます |
 | `todos/`、`statsig/`、`logs/` | 古いバージョンのレガシーディレクトリ。現在は書き込まれていません。スイープはその内容を削除してから、空のディレクトリを削除します |
 
```

</details>

*...以降省略*

</details>


<details>
<summary>2026-11-14</summary>

**変更ファイル:**

```
 docs-ja/pages/agent-teams-ja.md                    |  35 +++--
 docs-ja/pages/agent-view-ja.md                     |  75 +++++------
 docs-ja/pages/artifacts-ja.md                      |   4 +-
 docs-ja/pages/auto-mode-config-ja.md               |   6 +-
 docs-ja/pages/changelog.md                         | 142 +++++++++++++++++++++
 docs-ja/pages/claude-apps-gateway-config-ja.md     |  31 ++++-
 docs-ja/pages/claude-code-on-the-web-ja.md         |   4 +-
 docs-ja/pages/claude-projects-ja.md                |  12 +-
 docs-ja/pages/cli-reference-ja.md                  |   2 +-
 docs-ja/pages/commands-ja.md                       |   6 +-
 docs-ja/pages/desktop-ja.md                        |   7 +-
 docs-ja/pages/desktop-scheduled-tasks-ja.md        |   8 +-
 docs-ja/pages/env-vars-ja.md                       |  12 +-
 docs-ja/pages/errors-ja.md                         |   3 +-
 docs-ja/pages/feature-availability-ja.md           |  20 ++-
 docs-ja/pages/features-overview-ja.md              |   2 +-
 docs-ja/pages/github-actions-ja.md                 |   1 +
 docs-ja/pages/glossary-ja.md                       |   2 +-
 docs-ja/pages/hooks-guide-ja.md                    |   8 +-
 docs-ja/pages/hooks-ja.md                          |  17 ++-
 docs-ja/pages/keybindings-ja.md                    |   2 +-
 docs-ja/pages/llm-gateway-ja.md                    |   4 +
 docs-ja/pages/llm-gateway-protocol-ja.md           |   1 +
 docs-ja/pages/managed-mcp-ja.md                    |   5 +-
 docs-ja/pages/mcp-ja.md                            |   4 +-
 docs-ja/pages/model-config-ja.md                   |   4 +-
 docs-ja/pages/monitoring-usage-ja.md               |   4 +-
 docs-ja/pages/permission-modes-ja.md               |   3 +-
 docs-ja/pages/permissions-ja.md                    |   4 +-
 docs-ja/pages/remote-control-ja.md                 |   2 +-
 docs-ja/pages/sandbox-environments-ja.md           |   2 +-
 docs-ja/pages/sandboxing-ja.md                     |  11 +-
 docs-ja/pages/security-ja.md                       |   4 +-
 .../pages/self-hosted-environments-deploy-ja.md    |  12 +-
 docs-ja/pages/server-managed-settings-ja.md        |   8 +-
 docs-ja/pages/settings-reference-ja.md             |  65 ++++------
 docs-ja/pages/setup-ja.md                          |  33 +++--
 docs-ja/pages/skills-ja.md                         |  12 +-
 docs-ja/pages/statusline-ja.md                     |  40 ------
 docs-ja/pages/sub-agents-ja.md                     | 101 +++++++++------
 docs-ja/pages/third-party-integrations-ja.md       |   4 +
 docs-ja/pages/troubleshoot-install-ja.md           |   8 +-
 docs-ja/pages/vs-code-ja.md                        |  10 ++
 docs-ja/pages/workflows-ja.md                      |   2 +-
 docs-ja/pages/worktrees-ja.md                      |   5 +-
 45 files changed, 470 insertions(+), 277 deletions(-)
```

**新規追加:**


<details>
<summary>agent-teams-ja.md</summary>

```diff
diff --git a/docs-ja/pages/agent-teams-ja.md b/docs-ja/pages/agent-teams-ja.md
index 89d3278..f004224 100644
--- a/docs-ja/pages/agent-teams-ja.md
+++ b/docs-ja/pages/agent-teams-ja.md
@@ -103,9 +103,18 @@ Claude は時々、チームを作成する代わりに [サブエージェン
 > `tmux` には特定のオペレーティングシステムでの既知の制限があり、従来は macOS で最も効果的に動作します。iTerm2 で `tmux -CC` を使用することが、`tmux` への推奨エントリーポイントです。
 
-デフォルトは `"in-process"` です。`"auto"` を設定して、既に tmux セッション内で実行している場合または使用しているターミナルが iTerm2 で `it2` CLI がインストールされている場合は分割ペインを有効にし、それ以外の場合は in-process にフォールバックします。`"tmux"` 設定は分割ペインモードを有効にし、ターミナルに基づいて tmux または iTerm2 を使用するかどうかを自動検出します。
+エージェントチームを[有効化](#enable-agent-teams)した状態で、次の手順に従って各チームメイトに専用のペインを割り当てます。
 
-`"iterm2"` を設定して iTerm2 ネイティブ分割ペインを明示的に使用してください。このモードは [`it2` CLI](https://github.com/mkusaka/it2) が必要で、`it2` が見つからない場合はインストールコマンド付きでエラーを表示します。`it2` をインストールするか tmux に切り替えるオプションを提供するセットアッププロンプトは、ターミナルが iTerm2 で tmux がフォールバックとして利用可能な場合、`"auto"` または `"tmux"` の下に表示されます。
+**1. tmux をインストールするか iTerm2 をセットアップする**
 
-デフォルトをオーバーライドするには、`~/.claude/settings.json` で [`teammateMode`](https://code.claude.com/docs/ja/settings-reference#teammatemode) を設定してください。
+分割ペインモードには、[tmux](https://github.com/tmux/tmux/wiki) または [`it2` CLI](https://github.com/mkusaka/it2) を備えた iTerm2 が必要です。Claude Code を実行する方をセットアップしてください。
+
+* **tmux**：システムのパッケージマネージャーを通じてインストールしてください。プラットフォーム固有の手順については、[tmux wiki](https://github.com/tmux/tmux/wiki/Installing) を参照してください。
+* **iTerm2**：[`it2` CLI](https://github.com/mkusaka/it2) をインストールし、**iTerm2 > Settings > General > Magic > Enable Python API** で Python API を有効にしてください。
+
+**2. 分割ペインをオンにする**
+
+[`teammateMode`](https://code.claude.com/docs/ja/settings-reference#teammatemode) 設定を変更するまで、チームメイトは in-process で実行されます。
+
+`~/.claude/settings.json` で `"auto"` に設定してください。
 
 ```json theme={null}
@@ -115,4 +124,17 @@ Claude は時々、チームを作成する代わりに [サブエージェン
 ```
 
+`"auto"` では、tmux または iTerm2 内で Claude Code を実行するとチームメイトが分割ペインで開き、その他のターミナルでは in-process で実行されます。
```

</details>

<details>
<summary>agent-view-ja.md</summary>

```diff
diff --git a/docs-ja/pages/agent-view-ja.md b/docs-ja/pages/agent-view-ja.md
index d980ea1..2d95f35 100644
--- a/docs-ja/pages/agent-view-ja.md
+++ b/docs-ja/pages/agent-view-ja.md
@@ -9,5 +9,5 @@
 `claude agents` で開くエージェントビューは、すべてのバックグラウンドセッションの 1 つの画面です。実行中のもの、入力が必要なもの、完了したものが表示されます。新しいセッションをディスパッチし、トランスクリプトをスクロールする代わりに一目でセッションの状態を確認し、セッションが必要とするときだけ介入します。各バックグラウンドセッションは完全な Claude Code の会話であり、ターミナルが接続されていなくてもバックグラウンドで実行し続けるため、いつでも開いて、返信して、去ることができます。
 
-![ターミナルのエージェントビュー。上部の行は、入力を待機しているセッション、実行中のセッション、完了したセッションの数をカウントします。4 つのセッションは「入力が必要」、「実行中」、「完了」の下にグループ化されています。各行はセッションの名前、最新のステータスまたは質問、および時間を表示します。下部には新しいタスクを説明するための入力と、キーボードヒントの行があります。](https://mintcdn.com/claude-code/HDAmBwgbrZVk0pOt/images/agent-view-light.png?fit=max\&auto=format\&n=HDAmBwgbrZVk0pOt\&q=85\&s=d6905012bee31f3e6b3920b09c05dd02)
+![ターミナルのエージェントビュー。上部の行は、入力を待機しているセッション、実行中のセッション、完了したセッションの数をカウントします。4 つのセッションは「入力が必要」、「実行中」、「完了」の下にグループ化されています。各行はセッションの名前、最新のステータスまたは質問、および時間を表示します。下部には新しいタスクを説明するための入力と、キーボードヒントの行があります。](https://mintcdn.com/claude-code/v_J840yKc6uuKDX_/images/agent-view-light.png?fit=max\&auto=format\&n=v_J840yKc6uuKDX_\&q=85\&s=bd95fda83ea66ca8b2e0e7b68f8cb29e)
 
 Claude が複数の独立したタスクに対して、あなたが毎ステップを監視することなく作業できる場合に、エージェントビューを使用します。バグ修正、プルリクエストレビュー、不安定なテストの調査を 3 つの行としてディスパッチし、別のウィンドウで作業を続け、行が入力が必要であることを示すか、結果が得られたときに確認します。
@@ -145,5 +145,5 @@ Completed
 | :- | :- |
 | `✻` またはアニメーション `✽` | セッションプロセスが実行中であるか、セッションがユーザーの入力を必要としています |
-| `∙` | プロセスは終了しています。行のピーク表示は引き続き可能で、返信またはアタッチすると、Claude は保存された会話からセッションを再起動します |
+| `∙` | プロセスは終了しています。行のピーク表示は引き続き可能で、返信するか `Enter` を押すと、Claude は保存された会話からセッションを再起動します |
 | `✢` | イテレーション間でスリープしている [`/loop`](https://code.claude.com/docs/ja/scheduled-tasks) セッションです。行は実行回数とカウントダウンを表示します |
 
@@ -317,5 +317,5 @@ Claude Code がセッションをバックグラウンドにすると（約 10 
 * `Ctrl+X` を押してセッションを停止し、2 秒以内に `Ctrl+X` を再度押してリストから削除します。削除せずに確認を閉じるには `Esc` を押します。2 回目の押下は、たとえば [バックグラウンドサービスが応答していない](#agent-view-says-the-background-service-did-not-respond) ために停止の試みが失敗した場合でも、セッションを削除します。その場合、確認はさらに 2 秒間有効なままで、削除によってセッションのプロセス自体が終了されます
 
-グループヘッダーで `Ctrl+X` を押すと、確認後、そのグループ内のすべてのセッションが削除されます。[セッションを削除するときに削除されるもの](#what-deleting-a-session-removes) で説明されている保持されるケースを除き、削除するとセッションはリストから削除されます。Claude がそのセッション用に作成した worktree は、削除方法と worktree の内容に応じて、削除、保持、またはそのまま残されます。会話のトランスクリプトはローカルマシンに残り、`claude --resume` から利用できます。
+グループヘッダーで `Ctrl+X` を押すと、確認後、そのグループ内のすべてのセッションが削除されます。ただし、Claude Code が [削除を拒否する](#delete-a-session-after-claude-code-refuses) セッションは除きます。各セッションの worktree がどうなるかについては、[セッションを削除するときに削除されるもの](#what-deleting-a-session-removes) を参照してください。会話のトランスクリプトはローカルマシンに残り、`claude --resume` から利用できます。
 
 画面に収まらない完了したセッションは `… N more` 行に折りたたまれます。`Completed` グループはライブグループの後に残った縦のスペースを埋めます。短いターミナルではヘッダーが 1 行の概要に圧縮されるため、作業中または入力が必要なセッションは表示されたままになります。
@@ -623,5 +623,5 @@ Claude が入った worktree でバックグラウンドセッションがコー
 #### セッションを削除すると何が削除されるか
 
-セッションを削除するには、[エージェントビュー](#organize-the-list) で `Ctrl+X` を 2 回押すか、[`claude rm`](#manage-sessions-from-the-shell) を使用します。以下で保持されるケースを除き、セッションはリストから削除されます。そのトランスクリプトは `claude --resume` で利用できるようマシン上に残り、削除はスーパーバイザーの再起動後も維持されます。
+セッションを削除するには、[エージェントビュー](#organize-the-list) で `Ctrl+X` を 2 回押すか、[`claude rm`](#manage-sessions-from-the-shell) を使用します。Claude Code が [削除を拒否した](#delete-a-session-after-claude-code-refuses) 場合を除き、セッションはリストから削除されます。そのトランスクリプトはマシン上に残り、`claude --resume` で利用できます。
```

</details>

<details>
<summary>artifacts-ja.md</summary>

```diff
diff --git a/docs-ja/pages/artifacts-ja.md b/docs-ja/pages/artifacts-ja.md
index c8344e1..b2d142a 100644
--- a/docs-ja/pages/artifacts-ja.md
+++ b/docs-ja/pages/artifacts-ja.md
@@ -433,7 +433,7 @@ Team プランと Enterprise プランのオーナーは、[claude.ai 管理設
 アーティファクトが自動削除される前に保持される期間を設定するには、[**Organization settings > Data and privacy**](https://claude.ai/admin-settings/data-privacy-controls)に移動します。作成者にのみプライベートなアーティファクトと共有されたアーティファクトに対して、別々の保持期間を設定できます。
 
-### 監査ログを確認する
+### Compliance API でアーティファクトのアクティビティを監査する
 
-アーティファクトの公開、共有、削除は、それぞれ組織の監査ログに `claude_artifact_*` イベントタイプの下に表示されます。これは claude.ai の会話で作成されたアーティファクトに使用されるのと同じファミリーです。
+Enterprise プランでは、Compliance API の [Activity Feed](https://platform.claude.com/docs/en/manage-claude/compliance-activity-feed) をクエリして、誰がアーティファクトを公開、共有、または削除したかを確認できます。フィルタリングに使用するアクティビティタイプを見つけるには、[Activity Feed リファレンス](https://platform.claude.com/docs/en/api/compliance/activities/list)で `activity_types` を展開し、`artifact` を含む名前を探します。
 
 ### ビューアドメインをホワイトリストに登録する
```

</details>

<details>
<summary>auto-mode-config-ja.md</summary>

```diff
diff --git a/docs-ja/pages/auto-mode-config-ja.md b/docs-ja/pages/auto-mode-config-ja.md
index 4285381..c7ab6a8 100644
--- a/docs-ja/pages/auto-mode-config-ja.md
+++ b/docs-ja/pages/auto-mode-config-ja.md
@@ -223,4 +223,8 @@ Claude Code のプロンプトで `/auto-mode-setup` と入力すると `Unknown
 各フィールドは散文説明の配列であり、自然言語ルールとして読み込まれます。分類器の前に実行されるツールパターンベースのハードブロックについては、[`permissions.deny`](https://code.claude.com/docs/ja/permissions) を使用します。
 
+> [!NOTE]
+>
+> [Code Mode](https://code.claude.com/docs/ja/code-mode.md#permission-checks) セッションでは、分類器は Claude のコードをレビューする際に `hard_deny` と `soft_deny` を適用し、コードが行う個々のツール呼び出しには適用しません。`permissions.deny` ルールは個々の呼び出しに適用されます。
+
 分類器内では、優先順位は 4 つのレベルで機能します。
 
@@ -284,5 +288,5 @@ Claude Code は [管理設定](https://code.claude.com/docs/ja/server-managed-se
 デフォルトでは、狭い Bash および PowerShell の許可ルール（`Bash(npm test)` など）はオートモードで有効なままであり、Claude Code は分類器が実行される前にそれらを解決します。ただし、コマンドが [コマンドごとの許可ドメイン](https://code.claude.com/docs/ja/sandboxing.md#per-command-allowed-domains-in-auto-mode) を含む場合は除きます。Claude Code は、`Bash(*)` やワイルドカード化されたインタープリターなどの任意のコード実行を許可する広いルール、および [`Monitor`](https://code.claude.com/docs/ja/tools-reference#monitor-tool) という名前のすべてのルールを一時停止します。Monitor コマンドはシェルを通して実行されるためです。これは、狭いルールが、分類器が見ることなく、破壊的な引数（スクリプトパスやルールのプレフィックスが予想しなかったフラグなど）を通す可能性があることを意味します。
 
-`autoMode.classifyAllShell` を `true` に設定して、オートモードがアクティブな間、すべての Bash および PowerShell の許可ルールを一時停止し、分類器が許可リストに関係なくすべてのシェルコマンドを評価するようにします。ただし、[重要パスの削除](https://code.claude.com/docs/ja/permission-modes.md#critical-paths) は除きます。
+`autoMode.classifyAllShell` を `true` に設定すると、auto モードがアクティブな間、すべての Bash および PowerShell の許可ルールが一時停止され、分類器が許可リストに関係なくすべてのシェルコマンドを評価するようになります。ただし、[重要パスの削除](https://code.claude.com/docs/ja/permission-modes.md#critical-paths) は除きます。[Code Mode](https://code.claude.com/docs/ja/code-mode.md#permission-checks) セッションでは、この設定がオンの場合でも、分類器はコマンドを実行するコードをレビューします。
 
 ```json theme={null}
```

</details>

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index 8e86b6b..0746feb 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,146 @@
 # Changelog
 
+## 2.1.325
+
+- Fixed a security issue in how zstd-compressed responses are decoded
+- Added a spinner tip in VS Code and similar integrated terminals about re-running a notebook cell, shown once Claude has read or edited a Jupyter notebook
+- Added a line under the error shown when your organization's policy blocks a request, saying how to continue: run `/rewind` and change the message, or run `/clear`
+- Added a note for Claude when a sandboxed `git checkout`, `git stash` or autostash pull cannot update protected files such as those in `.claude`
+- Fixed `/security-review` and skills' inline git commands stopping with an error in worktrees of bare repositories, `--separate-git-dir` checkouts and Android `repo` checkouts
+- Fixed subagents with their own model being moved to the plan-mode model when the model setting is `opusplan` or `haiku`
+- Fixed subagents on a different model sizing file reads and MCP results with the main session's model
+- Fixed sessions on many third-party gateways and Foundry stopping with a context length error on every turn instead of compacting
+- Fixed recent turns sometimes going missing from a resumed session after Claude Code stopped without a clean exit
+- Fixed shell commands running in the launch directory after the working directory was deleted; the command now fails with a message and can be re-issued
+- Fixed an approved plan edit being lost when the `plansDirectory` folder can't take it: the plan is now saved in the default plans folder, and a warning says where and why
+- Fixed a saved `sonnet[1m]` model setting being rewritten on a new install to a model id the API rejects
+- Fixed focus view hiding the reply to your prompt when a scheduled task replied after it
+- Fixed the prompt sometimes missing from a background subagent's view when fullscreen is off
+- Fixed long options in lists and permission prompts being partly overwritten when they wrap, and first-run screens losing lines on narrow terminals
+- Fixed startup warnings about permission rules and the "N MCP servers need authentication" notice being recorded as seen when they were scrolled out of view
+- Fixed the welcome header showing control characters or splitting across lines when an agent's name or the working folder contains them or a line break
+- Fixed the red error shown when Claude tries a command only you can run: a dim line now says it runs only when you type it at the prompt
+- Fixed `/stats` showing an Active days total that was one day too high
+- Fixed `/insights` saying a report was ready when no session qualified for analysis, and writing two values into its HTML report without escaping them
+- Fixed `/voice` saying voice mode changed when managed settings, `--settings`, or the project's `.claude/settings.json` or `.claude/settings.local.json` kept it as it was; it now says what holds it
```

</details>

<details>
<summary>claude-apps-gateway-config-ja.md</summary>

```diff
diff --git a/docs-ja/pages/claude-apps-gateway-config-ja.md b/docs-ja/pages/claude-apps-gateway-config-ja.md
index de3ceb9..3259721 100644
--- a/docs-ja/pages/claude-apps-gateway-config-ja.md
+++ b/docs-ja/pages/claude-apps-gateway-config-ja.md
@@ -15,5 +15,5 @@ Claude apps gateway デプロイメントは、慣例的に `gateway.yaml` と
 ## ファイル構造
 
-5 つのセクションが[必須](#required-sections)です。その他のセクションはすべて[オプション](#optional-sections)であり、省略されたセクションはデフォルト値を使用します。不明なキーはブート時に失敗するため、タイプミスは設定が無視されるのではなく、名前付きエラーとして表示されます。
+5 つのセクションが[必須](#required-sections)です。その他のセクションはすべて[オプション](#optional-sections)であり、省略されたセクションはデフォルト値を使用します。
 
 **必須セクション：**
@@ -518,4 +518,8 @@ models:
 Claude Code v2.1.281 以降を実行しているゲートウェイが必要です。[AWS でのコスト帰属](https://code.claude.com/docs/ja/claude-apps-gateway-on-aws.md#cost-attribution)では、IAM ロールと、AWS の請求でセッションがどこに表示されるかを説明しています。
 
+> [!NOTE]
+>
+> 開発者ごとの帰属を行うには、`aws_bearer_token` を使用するものを除くすべての `bedrock` および [`mantle`](#amazon-bedrock-mantle-endpoint) アップストリームで、`session_name` を指定した `assume_role` を設定してください。`aws_bearer_token` を使用するアップストリームは [`assume_role` を使用できない](#bedrock-in-another-aws-account)ため、そのリクエストは 1 つのプリンシパルのままになります。
+
 ```yaml theme={null}
 upstreams:
@@ -534,6 +538,4 @@ upstreams:
 ゲートウェイは、このロールで独自の呼び出しも 1 つ行います。[支出制限](https://code.claude.com/docs/ja/claude-apps-gateway-spend-limits.md)を正確に保つための、クライアントが中断したリクエストのトークンカウントです。そのカウントとその [1 トークンのフォールバックリクエスト](#amazon-bedrock)は共有の `claude-apps-gateway` セッションで署名されるため、AWS はフォールバックを開発者ではなく `claude-apps-gateway` に帰属させます。
 
-厳密な開発者ごとの帰属を行うには、列挙するすべての Bedrock アップストリームで `session_name` 付きの `assume_role` を設定してください。これがないアップストリームは、処理するリクエストに自身の認証情報で署名します。
-
 #### Amazon Bedrock Mantle エンドポイント
 
@@ -1282,4 +1284,8 @@ Claude Code は、デベロッパーに承認ダイアログを表示せずに
 代わりに 1M コンテキストをオフにするには、同じ `env` ブロックで [`CLAUDE_CODE_DISABLE_1M_CONTEXT: "1"`](https://code.claude.com/docs/ja/model-config#extended-context) を設定します。すると Claude Code はすべてのモデルのウィンドウを 200K として扱います。インタラクティブセッションでは、この変数が有効になる前に、各デベロッパーが [承認ダイアログ](#what-goes-in-cli) でこれを承認します。
 
```

</details>

<details>
<summary>claude-code-on-the-web-ja.md</summary>

```diff
diff --git a/docs-ja/pages/claude-code-on-the-web-ja.md b/docs-ja/pages/claude-code-on-the-web-ja.md
index fb56049..9e2d9a1 100644
--- a/docs-ja/pages/claude-code-on-the-web-ja.md
+++ b/docs-ja/pages/claude-code-on-the-web-ja.md
@@ -190,6 +190,6 @@ CLI はメッセージをセッションのキューに追加し、返信を待
 ```
 Sent to cloud session.
-Session ID: session_01DiUkqY2kzbUbDmW1w96rfi
-View: https://claude.ai/code/session_01DiUkqY2kzbUbDmW1w96rfi?from=cli&m=0
+Session ID: session_01HJKLMNOPQRSTUVWXYZ
+View: https://claude.ai/code/session_01HJKLMNOPQRSTUVWXYZ?from=cli&m=0
 ```
 
```

</details>

*...以降省略*

</details>


<details>
<summary>2026-11-13</summary>

**変更ファイル:**

```
 docs-ja/pages/amazon-bedrock-ja.md                 |  84 +++---
 docs-ja/pages/best-practices-ja.md                 |   2 +-
 docs-ja/pages/changelog.md                         | 301 ++++++++++++++++++++-
 docs-ja/pages/claude-apps-gateway-config-ja.md     |  10 +-
 docs-ja/pages/claude-apps-gateway-deploy-ja.md     |   2 +-
 docs-ja/pages/claude-apps-gateway-ja.md            |   4 +-
 docs-ja/pages/claude-projects-ja.md                |   2 +
 docs-ja/pages/commands-ja.md                       |   2 -
 docs-ja/pages/desktop-linux-ja.md                  |   2 +-
 docs-ja/pages/desktop-scheduled-tasks-ja.md        |   9 +-
 docs-ja/pages/errors-ja.md                         |  66 ++++-
 docs-ja/pages/fast-mode-ja.md                      |   2 +-
 docs-ja/pages/gateways-ja.md                       |   2 +-
 docs-ja/pages/github-actions-cloud-providers-ja.md |   2 +-
 docs-ja/pages/google-vertex-ai-ja.md               |  11 +-
 docs-ja/pages/hooks-guide-ja.md                    |   6 +-
 docs-ja/pages/hooks-ja.md                          |  12 +-
 docs-ja/pages/interactive-mode-ja.md               |  14 +-
 docs-ja/pages/keybindings-ja.md                    |   7 +-
 docs-ja/pages/llm-gateway-connect-ja.md            |   5 +-
 docs-ja/pages/llm-gateway-rollout-ja.md            |  10 +-
 docs-ja/pages/microsoft-foundry-ja.md              |  18 +-
 docs-ja/pages/model-config-ja.md                   |   8 +-
 docs-ja/pages/monitoring-usage-ja.md               |   2 +-
 docs-ja/pages/permission-modes-ja.md               |   2 +-
 docs-ja/pages/prompt-caching-ja.md                 |   8 +-
 docs-ja/pages/quickstart-ja.md                     |  10 +-
 docs-ja/pages/remote-control-ja.md                 |   3 +-
 docs-ja/pages/routines-ja.md                       |   2 +-
 docs-ja/pages/sandboxing-ja.md                     |   8 +-
 docs-ja/pages/settings-ja.md                       |   2 +-
 docs-ja/pages/settings-reference-ja.md             | 134 +++++++--
 docs-ja/pages/setup-ja.md                          |  34 +--
 docs-ja/pages/terminal-config-ja.md                |   2 +-
 docs-ja/pages/tools-reference-ja.md                |   4 +-
 docs-ja/pages/troubleshoot-install-ja.md           |  14 +-
 docs-ja/pages/troubleshooting-ja.md                |   2 +-
 docs-ja/pages/workflows-ja.md                      |   2 -
 38 files changed, 620 insertions(+), 190 deletions(-)
```

<details>
<summary>amazon-bedrock-ja.md</summary>

```diff
diff --git a/docs-ja/pages/amazon-bedrock-ja.md b/docs-ja/pages/amazon-bedrock-ja.md
index 483d241..95aa4b3 100644
--- a/docs-ja/pages/amazon-bedrock-ja.md
+++ b/docs-ja/pages/amazon-bedrock-ja.md
@@ -350,9 +350,14 @@ Claude Code は、次のピンについてはチェックも更新の促しも
 ### モデルがセッション中に無効化される場合
 
-セッションが実行されているモデルへのアカウントアクセスが失われた場合（例えば、管理者が Amazon Bedrock アカウントでそれを無効化した場合）、Claude Code は各リクエストが失敗する代わりにセッションを別のモデルに切り替え、`Switched to <fallback> because <model> is not available` を表示します。スタートアップフォールバックと同じモデルを試します。同じティアの以前のバージョンを最初に試し、Opus セッションで Opus バージョンが利用できない場合、デフォルト Sonnet モデルを試します。
+Amazon Bedrock がセッションのモデルをアカウントで利用できないとして拒否した場合、Claude Code はセッションを別のモデルに切り替えるため、作業を続けられます。`Switched to <fallback> because <model> is not available` で始まるメッセージが表示されます。これは、例えば管理者がモデルを無効化した場合や、最新のモデルがまだアカウントで利用できない場合に発生します。
 
-切り替えは、ピン留めしていないティアにのみ適用されます。これはスタートアップフォールバックと同じ条件です。選択した特定のバージョン、または[アプリケーション推論プロファイル ARN](#map-each-model-version-to-an-inference-profile)でセッションを実行している場合、そのモデルを保持し、フォールバックモデルチェーンがないため、リクエストは失敗します。[auto モード](https://code.claude.com/docs/ja/permission-modes.md#enable-auto-mode-on-bedrock-agent-platform-or-foundry)では、Claude Code は Amazon Bedrock で auto モードがサポートするモデルにのみ切り替えます。それらのモデルも利用できない場合、リクエストは[AWS 認証失敗](https://code.claude.com/docs/ja/errors.md#aws-authentication-failed)で失敗し、モデルを有効にするためのヒントが表示されます。
+[フォールバックモデルチェーン](https://code.claude.com/docs/ja/model-config.md#fallback-model-chains)を設定している場合、Claude Code は代わりに設定したフォールバックに切り替えます。チェーンがない場合、次のようなケースではリクエストが失敗します。
 
-設定した[フォールバックモデルチェーン](https://code.claude.com/docs/ja/model-config.md#fallback-model-chains)はティア切り替えを置き換えます。これらの拒否では Claude Code は設定したフォールバックに切り替えます。拒否されたリクエストが切り替わるのではなく失敗するようにするには、[`CLAUDE_CODE_DISABLE_MODEL_ACCESS_FALLBACK=1`](https://code.claude.com/docs/ja/env-vars)を設定してください。設定したフォールバックチェーンはこれらの拒否で切り替わります。すべての拒否されたリクエストが失敗するようにしたい場合は、チェーンも削除してください。
+* セッションが、ピン留めされたモデル、選択した特定のバージョン、または[アプリケーション推論プロファイル ARN](#map-each-model-version-to-an-inference-profile) で実行されている
+* [Claude Code が試すモデル](#startup-model-checks)がどれも利用できない。[auto モード](https://code.claude.com/docs/ja/permission-modes.md#enable-auto-mode-on-bedrock-agent-platform-or-foundry)では、Claude Code は Amazon Bedrock で auto モードがサポートするモデルにのみ切り替えます。
+
+作業を続けるには、セッションで `/model` を実行し、アカウントで使用できるモデル上で `s` を押してください。この操作ではデフォルトは変更されません。`403` は [AWS authentication failed](https://code.claude.com/docs/ja/errors.md#aws-authentication-failed) として表示されます。
+
+拒否されたリクエストが切り替わるのではなく失敗するようにするには、[`CLAUDE_CODE_DISABLE_MODEL_ACCESS_FALLBACK=1`](https://code.claude.com/docs/ja/env-vars)を設定してください。フォールバックモデルチェーンを設定している場合は、Claude Code が引き続きそのフォールバックに移行するため、チェーンも削除してください。
 
 ## クロスリージョン推論プロファイルプレフィックス
@@ -514,5 +519,5 @@ claude --model anthropic.claude-haiku-4-5
 ### Mantle を Invoke API と並行して実行する
 
-Mantle で利用可能なモデルは、今日使用するすべてのモデルを含まない場合があります。`CLAUDE_CODE_USE_BEDROCK` と `CLAUDE_CODE_USE_MANTLE` の両方を設定すると、Claude Code は同じセッションから両方のエンドポイントを呼び出せます。Mantle 形式に一致するモデル ID は Mantle にルーティングされ、他のすべてのモデル ID は Amazon Bedrock Invoke API に移動します。
+Mantle で利用可能なモデルは、今日使用するすべてのモデルを含まない場合があります。ゲートウェイを介さずに接続する場合は、`CLAUDE_CODE_USE_BEDROCK` と `CLAUDE_CODE_USE_MANTLE` の両方を設定すると、同じセッションから Mantle と Invoke API の両方を呼び出せます。Mantle 形式に一致するモデル ID は Mantle にルーティングされ、他のすべてのモデル ID は Amazon Bedrock Invoke API に移動します。
 
 ```bash theme={null}
@@ -558,67 +563,72 @@ export ANTHROPIC_BEDROCK_MANTLE_BASE_URL=https://your-gateway.example.com
```

</details>

<details>
<summary>best-practices-ja.md</summary>

```diff
diff --git a/docs-ja/pages/best-practices-ja.md b/docs-ja/pages/best-practices-ja.md
index a645f5c..99b6943 100644
--- a/docs-ja/pages/best-practices-ja.md
+++ b/docs-ja/pages/best-practices-ja.md
@@ -316,5 +316,5 @@ use a subagent to review the rate limiter diff against SPEC.md, check every requ
         "matcher": "Edit|Write",
         "hooks": [
-          { "type": "command", "command": "npx prettier --write --ignore-unknown \"$(jq -r '.tool_input.file_path')\"" }
+          { "type": "command", "command": "f=$(jq -r '.tool_input.file_path') && npx prettier --write --ignore-unknown \"$f\"" }
         ]
       }
```

</details>

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index 766241d..8e86b6b 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,301 @@
 # Changelog
 
+## 2.1.323
+
+- Added Code Mode, an experimental opt-in in which Claude writes JavaScript to call its tools; see https://code.claude.com/docs/en/code-mode to turn it on, or to turn it off for an organization
+- Added `engines["claude-code"]` to `plugin.json`: plugins outside their stated Claude Code version range are not installed, updated or loaded, and install and update pick the newest version that fits
+- Added type checking of a plugin's TypeScript hooks module to `claude plugin validate`; each finding is a warning, and `--strict` fails on it
+- Added to `claude plugin validate` the `$` nouns a mod's `engine.create` hook adds, withholds or replaces
+- Added support for `CLAUDE_CODE_AUTO_MODE_MODEL` in managed settings for Claude Desktop sessions on third-party providers (takes effect once Claude Desktop includes this version)
+- Added an options menu (stop, switch to usage credits, upgrade) when a model needs usage credits that are turned off or used up
+- Added a progress heartbeat every 30 seconds while hooks run long in `claude -p` and SDK sessions, so a host such as Claude Desktop won't end the turn as hung (once it includes this version)
+- Added `.docx` support to Artifact tool asset uploads
+- Added a `/diff to close` hint to the diff panel, and the keys that focus and close a panel to the `?` shortcut guide
+- Added a start-up warning for Bash allow rules with a `*` in a variable's value, such as `Bash(PORT=* npm run dev)`
+- Added a warning when a plugin's language server can't start, naming the server and what to check
+- Added a one-time startup notice naming `CLAUDE_CODE_PERFORCE_MODE` when Perforce settings are found and the mode is off
+- Added `CLAUDE_CODE_DISABLE_AGENT_PROGRESS_SUMMARIES` (available since 2.1.318): set it to `1` to turn off subagent progress summaries and the requests that write them (anthropics/claude-code#86879)
+- Added `CLAUDE_CODE_RESUME_HINT_COMMAND`, which a program that starts Claude Code can set to have the exit hint name its own resume command
+- Added `unsetOptionCount` to the `claude plugin install --json` result: how many `userConfig` options are not yet set
+- Added `isPromptCovered` to the props a mod's pane is drawn with, telling it when a dialog or a field above the prompt covers the prompt
+- Fixed running `/compact` again, or after a command such as `/context`, summarizing away a message that Claude had not answered yet
+- Fixed a resumed session joining your next message to an old interrupted message that was not resumed
+- Fixed a memory spike at the next prompt after Claude changed a very large file
+- Fixed a setting saved in a running session undoing a hand edit made to `settings.json` moments earlier; a settings file you delete during a session now stays deleted
+- Fixed `claude plugin` commands and `claude mcp list` signing you out of a Console profile when they ended while the token was being renewed
```

</details>

<details>
<summary>claude-apps-gateway-config-ja.md</summary>

```diff
diff --git a/docs-ja/pages/claude-apps-gateway-config-ja.md b/docs-ja/pages/claude-apps-gateway-config-ja.md
index 681492b..de3ceb9 100644
--- a/docs-ja/pages/claude-apps-gateway-config-ja.md
+++ b/docs-ja/pages/claude-apps-gateway-config-ja.md
@@ -655,5 +655,5 @@ upstreams:
 | セットアップ | 方法 |
 | - | - |
-| RBAC | ゲートウェイの ID に、Microsoft Foundry リソースに対する `Azure AI User` または `Cognitive Services User` を付与します |
+| RBAC | ゲートウェイの ID に、Microsoft Foundry リソースに対する `Foundry User` または `Cognitive Services User` ロールを付与します |
 | デプロイ | Microsoft Foundry は、正規のモデル ID ではなく管理者が選択したデプロイ名を使用します。各正規 ID をデプロイ名にマッピングする [`models:`](#models) ブロックを追加してください。 |
 | AKS（ワークロード ID） | ユーザー割り当てマネージド ID をクラスターの OIDC 発行者とフェデレーションし、ゲートウェイのサービスアカウントにバインドします。`use_azure_ad: true` が `WorkloadIdentityCredential` 経由でそれを取得します。 |
@@ -1000,4 +1000,6 @@ models:
 `upstream_model` の各キーは、設定された上流の `name` と一致する必要があります。デフォルトはプロバイダー名です。キーが上流と一致しない場合、ブート失敗を引き起こすため、使用しないプロバイダーの行は省略してください。
 
+`auto_include_builtin_models: false` で開発者が `fable` エイリアスを使用できるようにするには、`models` に `claude-fable-5` エントリを追加します。これは、ゲートウェイにサインインした開発者に対して [`fable` エイリアス](https://code.claude.com/docs/ja/model-config#fable-alias-resolution) が解決される ID です。これがないと、メッセージは `API Error: 400 model claude-fable-5 is not in the operator's model allowlist` で始まるエラーで失敗します。
+
 ### `managed`
 
@@ -1024,5 +1026,9 @@ managed:
 
 * **許可リスト**：`availableModels` と `permissions.allow`。特定のポリシーのリストは基盤のリストを完全に置き換えます。
-* **拒否リストとフック配列**：`permissions.deny`、`permissions.ask`、`disabledMcpjsonServers`、`deniedMcpServers`、`blockedMarketplaces`、`deniedModels`、およびすべての `hooks` イベントタイプ配列。これらはベースとポリシーの和集合をとるため、組織全体の拒否や監査フックがロールごとの上書きによって誤って失われることはありません。
+* **拒否リストとフック配列**: ベースとポリシーの和集合になります。
+  * `permissions.deny` と `permissions.ask`
+  * `disabledMcpjsonServers` と `deniedMcpServers`
+  * `blockedMarketplaces` と `deniedModels`
+  * `hooks` のイベントタイプ配列
 * **レコード型キー**：`env`、`modelOverrides`、`skillOverrides`。これらは浅くマージされるため、ロールごとの `env` ブロックは設定するキーを上書きし、残りを基盤から継承します。
 
```

</details>

<details>
<summary>claude-apps-gateway-deploy-ja.md</summary>

```diff
diff --git a/docs-ja/pages/claude-apps-gateway-deploy-ja.md b/docs-ja/pages/claude-apps-gateway-deploy-ja.md
index 5051ef1..ded6e3c 100644
--- a/docs-ja/pages/claude-apps-gateway-deploy-ja.md
+++ b/docs-ja/pages/claude-apps-gateway-deploy-ja.md
@@ -93,5 +93,5 @@ Claude Code は、次の 2 つの方法のいずれかでゲートウェイの
 バイナリを超えて、イメージは以下が必要です：
 
-* **glibc ベースのイメージ**：glibc ビルドの唯一の動的依存関係は glibc ライブラリです。Musl ベースのイメージは `linux-x64-musl` または `linux-arm64-musl` ビルドと追加パッケージが必要です。[Alpine Linux セットアップ](https://code.claude.com/docs/ja/setup.md#alpine-linux-and-musl-based-distributions) を参照してください。
+* **glibc ベースのイメージ**：glibc ビルドの唯一の動的依存関係は glibc ライブラリです。Musl ベースのイメージには `linux-x64-musl` または `linux-arm64-musl` ビルドが必要で、その唯一の動的依存関係は musl です。
 * **書き込み可能な状態ディレクトリ**：ゲートウェイは任意のユーザーとして実行されますが、最小限のイメージには書き込み可能なホームがありません。`CLAUDE_CONFIG_DIR` を `/tmp/.claude` などの書き込み可能なパスに設定します。
 * **コンテナコマンド**：`claude gateway --config /etc/claude/gateway.yaml`。設定ファイルは読み取り専用でマウントされ、シークレットは環境変数として提供されます。ゲートウェイは `listen.port` でリッスンします。デフォルトは `8080` です。
```

</details>

<details>
<summary>claude-apps-gateway-ja.md</summary>

```diff
diff --git a/docs-ja/pages/claude-apps-gateway-ja.md b/docs-ja/pages/claude-apps-gateway-ja.md
index cf5b606..9f519f9 100644
--- a/docs-ja/pages/claude-apps-gateway-ja.md
+++ b/docs-ja/pages/claude-apps-gateway-ja.md
@@ -75,7 +75,9 @@ Claude アプリゲートウェイは、開発者の Claude Code クライアン
 | モデルアップストリーム | Amazon Bedrock 認証情報、Claude Platform on AWS 認証情報、Google Cloud 認証情報、Microsoft Foundry リソース、または Anthropic API キー。複数のアップストリームがサポートされ、フェイルオーバーがあります。 |
 | HTTPS | ゲートウェイは開発者ラップトップとサインインに使用されるブラウザから `https://` 経由で到達可能である必要があります。ゲートウェイは同じリスナーでデバイス検証ページを提供します。`listen.tls` 経由で TLS 証明書を提供するか、TLS 終了イングレスの背後で実行し、いずれの場合も `listen.public_url` を外部オリジンに設定します。`/login` では、Claude Code はゲートウェイホストがループバック（`localhost`、`127.0.0.1`、または `::1`）の場合にのみプレーン `http://` オリジンを受け入れます。 |
-| プライベートネットワークアドレス | `/login` では、Claude Code はゲートウェイのホスト名または IP アドレスがプライベートアドレスのみに解決されることを要求します。RFC 1918、リンクローカル、CGNAT `100.64.0.0/10`、IPv6 ULA `fc00::/7`、またはループバック。ホストするゲートウェイの場合、宣言するブロック外のパブリックアドレスは拒否されます。デプロイガイドの[脅威モデル](https://code.claude.com/docs/ja/claude-apps-gateway-deploy.md#threat-model-summary)を参照してください。開発者マシンが HTTPS を企業プロキシ経由でルーティングする場合、サインインはプロキシホストもプライベートアドレスに解決されることを要求します。そうでない場合は、ゲートウェイホストを `NO_PROXY` に追加して、CLI が直接接続するようにします。内部ネットワークが組織が所有するパブリック IPv4 スペースから番号付けされている場合は、[これらのブロックを宣言](#allow-a-gateway-on-public-address-space-you-own)して、`/login` がそこでゲートウェイを受け入れるようにします。 |
+| プライベートネットワークアドレス | `/login` では、Claude Code はゲートウェイのホスト名または IP アドレスがプライベートアドレスのみに解決されることを要求します。プライベートアドレスとは、RFC 1918 およびリンクローカル範囲、CGNAT `100.64.0.0/10`、IPv6 ULA `fc00::/7`、ループバックです。[脅威モデル](https://code.claude.com/docs/ja/claude-apps-gateway-deploy.md#threat-model-summary)を参照してください。内部ネットワークが組織が所有するパブリック IPv4 スペースから番号付けされている場合は、[これらのブロックを宣言](#allow-a-gateway-on-public-address-space-you-own)して、`/login` がそこでゲートウェイを受け入れるようにします。 |
 | Linux ランタイム | ゲートウェイサーバーはネイティブ Linux バイナリでのみ実行されます。macOS はローカル開発用に機能します。Windows はサーバープラットフォームとしてサポートされていません。 |
 
+ゲートウェイホストに `HTTPS_PROXY` または `HTTP_PROXY` が適用される場合、サインインには、ホスト名がプライベートアドレスに解決されるプロキシか、開発者マシンの `NO_PROXY` にゲートウェイホストが含まれていることも必要です。これらのマシンで `no_proxy` も設定している場合は、そこにもゲートウェイホストを追加してください。追加しないと、モデルリクエストは引き続きプロキシを経由します。
+
 ### ステップ
 
```

</details>

<details>
<summary>claude-projects-ja.md</summary>

```diff
diff --git a/docs-ja/pages/claude-projects-ja.md b/docs-ja/pages/claude-projects-ja.md
index 0bef865..e9d184a 100644
--- a/docs-ja/pages/claude-projects-ja.md
+++ b/docs-ja/pages/claude-projects-ja.md
@@ -275,4 +275,6 @@ Claude は**デバイス上のフォルダーで作業することを Claude に
 スレッドは[自動モード](https://code.claude.com/docs/ja/permission-modes.md#eliminate-prompts-with-auto-mode)で実行されるため、Claude はそのフォルダー内のコマンドを実行し、毎回あなたに尋ねることなくファイルを編集します。自動モードがそのコンピューターの Claude Code で利用できないか、オフになっている場合、スレッドはそれなしで実行され、発生するすべての権限プロンプトは、[承認を待機しているスレッドのブロックを解除する](#unblock-a-thread-waiting-on-approval)が説明するように、スレッドであなたの答えを待ちます。
 
+別のモードでスレッドを実行するには、[`--settings`](https://code.claude.com/docs/ja/remote-control#start-a-remote-control-session) を付けて `claude remote-control` を開始します。そのうえで、そのファイルまたはそのコンピューターの設定にある [`permissions.defaultMode`](https://code.claude.com/docs/ja/permission-modes#start-in-a-different-mode) で別のモードを選択できます。
+
 スレッドが実行されている間、ヘッダーのラップトップアイコンはコンピューターが接続されているかどうかを示します。クリックしてスレッドが使用しているフォルダーを確認するか、接続をオフにします。そのコンピューターがスリープ状態の間、スレッドは一時停止し、デスクトップアプリまたは `claude remote-control` が終了すると停止します。
 
```

</details>

<details>
<summary>commands-ja.md</summary>

```diff
diff --git a/docs-ja/pages/commands-ja.md b/docs-ja/pages/commands-ja.md
index 0661930..47cfe5a 100644
--- a/docs-ja/pages/commands-ja.md
+++ b/docs-ja/pages/commands-ja.md
@@ -36,7 +36,5 @@ Claude が応答中にコマンドを送信した場合、Claude Code はそれ
 
 * **[Skill](https://code.claude.com/docs/ja/skills.md#bundled-skills)**: バンドルスキル。自分で書くスキルと同じように機能します：Claude に渡されるプロンプトです。
-  * `/verify` は呼び出したときのみ実行されます。
 * **[Workflow](https://code.claude.com/docs/ja/workflows.md#bundled-workflows)**: バンドルされた[動的ワークフロー](https://code.claude.com/docs/ja/workflows.md)で、多くのサブエージェントに作業を展開し、バックグラウンドで実行されます。
-  * `/deep-research` は呼び出したときのみ実行されます。
 
 独自のコマンドを追加するには、[スキル](https://code.claude.com/docs/ja/skills.md)を参照してください。
```

</details>

<details>
<summary>desktop-linux-ja.md</summary>

```diff
diff --git a/docs-ja/pages/desktop-linux-ja.md b/docs-ja/pages/desktop-linux-ja.md
index 11a9497..f926168 100644
--- a/docs-ja/pages/desktop-linux-ja.md
+++ b/docs-ja/pages/desktop-linux-ja.md
@@ -72,5 +72,5 @@ sudo apt update && sudo apt install claude-desktop
 アプリケーションランチャーから **Claude** を起動するか、ターミナルから `claude-desktop` を実行して、Anthropic アカウントでサインインします。
 
-Linux アプリは macOS と Windows と同じ方法でサインインします。claude.ai サブスクリプション、または組織の SSO を通じてサインインします。API キー認証には [CLI](https://code.claude.com/docs/ja/quickstart.md) を使用してください。代わりに Amazon Bedrock、Google Cloud の Agent Platform、Microsoft Foundry、または LLM ゲートウェイで Desktop を使用する場合は、[Claude Desktop on 3P](https://claude.com/docs/third-party/claude-desktop/overview) を参照してください。これらのデプロイにおけるプロキシサーバーとカスタム認証局については、[ネットワーク設定](https://code.claude.com/docs/ja/network-config.md) を参照してください。
+Linux アプリは macOS と Windows と同じ方法でサインインします。claude.ai サブスクリプション、または組織の SSO を通じてサインインします。代わりに Claude API キー、Amazon Bedrock、Google Cloud の Agent Platform、Microsoft Foundry、または LLM ゲートウェイで Desktop を使用する場合は、[Claude Desktop on 3P](https://claude.com/docs/third-party/claude-desktop/overview) を参照してください。これらのデプロイにおけるプロキシサーバーとカスタム認証局については、[ネットワーク設定](https://code.claude.com/docs/ja/network-config.md) を参照してください。
 
 ### ダウンロードしたファイルからインストールする
```

</details>

*...以降省略*

</details>


<details>
<summary>2026-11-12</summary>

**変更ファイル:**

```
 docs-ja/pages/chrome-ja.md                         |  2 +-
 docs-ja/pages/claude-directory-ja.md               |  2 +-
 docs-ja/pages/commands-ja.md                       |  2 +-
 docs-ja/pages/common-workflows-ja.md               |  2 +-
 docs-ja/pages/context-window-ja.md                 |  2 +-
 docs-ja/pages/desktop-ja.md                        | 31 +++++++++++++++---
 docs-ja/pages/env-vars-ja.md                       |  2 +-
 docs-ja/pages/errors-ja.md                         |  4 +--
 docs-ja/pages/glossary-ja.md                       |  4 +--
 docs-ja/pages/hooks-ja.md                          |  2 +-
 docs-ja/pages/model-config-ja.md                   | 37 +++++++++++++---------
 docs-ja/pages/permission-modes-ja.md               |  6 ++--
 docs-ja/pages/scheduled-tasks-ja.md                |  2 +-
 .../self-hosted-environments-configuration-ja.md   |  4 +--
 .../pages/self-hosted-environments-deploy-ja.md    | 12 +++++--
 .../pages/self-hosted-environments-reference-ja.md |  1 +
 docs-ja/pages/skills-ja.md                         |  1 +
 docs-ja/pages/tools-reference-ja.md                |  2 +-
 docs-ja/pages/vs-code-ja.md                        |  5 ++-
 19 files changed, 82 insertions(+), 41 deletions(-)
```

<details>
<summary>chrome-ja.md</summary>

```diff
diff --git a/docs-ja/pages/chrome-ja.md b/docs-ja/pages/chrome-ja.md
index 0514e3b..7d766ed 100644
--- a/docs-ja/pages/chrome-ja.md
+++ b/docs-ja/pages/chrome-ja.md
@@ -129,5 +129,5 @@ VS Code セッションでは、ブラウザアクションの前に Claude Code
 ### plan モードでのブラウザツール
 
-[plan モード](https://code.claude.com/docs/ja/permission-modes.md#analyze-before-you-edit-with-plan-mode)では、Claude が GIF を記録する、新しいタブを開く、またはショートカットを実行する前に権限プロンプトが表示されます。対話型 CLI セッションでは、[bypassPermissions モードが利用可能](https://code.claude.com/docs/ja/permission-modes.md#skip-all-checks-with-bypasspermissions-mode)で、かつ[機能フラグの取得](https://code.claude.com/docs/ja/env-vars.md#features-that-need-feature-flag-fetching)がオフの場合、これらの呼び出しはプロンプトなしで実行されます。
+[plan モード](https://code.claude.com/docs/ja/permission-modes.md#analyze-before-you-edit-with-plan-mode)では、Claude が GIF を記録する前、または新しいタブを開く前に権限プロンプトが表示されます。対話型 CLI セッションでは、[bypassPermissions モードが利用可能](https://code.claude.com/docs/ja/permission-modes.md#skip-all-checks-with-bypasspermissions-mode)で、かつ[機能フラグの取得](https://code.claude.com/docs/ja/env-vars.md#features-that-need-feature-flag-fetching)がオフの場合、これらの呼び出しはプロンプトなしで実行されます。
 
 `createIfEmpty` を設定する `tabs_context_mcp` 呼び出しや、これらのアクションのいずれかを含む `browser_batch` 呼び出しでもプロンプトが表示されます。
```

</details>

<details>
<summary>claude-directory-ja.md</summary>

```diff
diff --git a/docs-ja/pages/claude-directory-ja.md b/docs-ja/pages/claude-directory-ja.md
index 8c7e390..cf75f41 100644
--- a/docs-ja/pages/claude-directory-ja.md
+++ b/docs-ja/pages/claude-directory-ja.md
@@ -171,5 +171,5 @@ Claude Code は、以下の場合に年齢ベースのスイープをスキッ
 * **Windows**：`%TEMP%\claude\<project>\<session-id>\scratchpad\`
 
-`<project>` は、文字と数字以外のすべての文字が `-` に置き換えられた作業ディレクトリパスです。例えば、`-Users-you-my-project`。[`CLAUDE_CODE_TMPDIR`](https://code.claude.com/docs/ja/env-vars)を設定する場合、ツリーはそのディレクトリの下に移動します。フックは現在のセッションのパスを [`scratchpad_dir`](https://code.claude.com/docs/ja/hooks#common-input-fields)として受け取ります。
+`<project>` は、英字と数字以外のすべての文字が `-` に置き換えられた作業ディレクトリパスです。例えば、`-Users-you-my-project`。Windows では、`<project>` はその文字列の 16 文字のハッシュです。例えば、`73295dabccd14c56`。Desktop アプリのセッションでは、文字列そのものになる場合があります。正確なパスを知るには、Claude に尋ねてください。[`CLAUDE_CODE_TMPDIR`](https://code.claude.com/docs/ja/env-vars) を設定する場合、ツリーはそのディレクトリの下に移動します。フックは現在のセッションのパスを [`scratchpad_dir`](https://code.claude.com/docs/ja/hooks#common-input-fields) として受け取ります。
 
 スクラッチパッドファイルはセッションのトランスクリプトと同じ期間続きます。[保持スイープ](#cleaned-up-automatically)はトランスクリプトを削除するときにディレクトリを削除し、[`claude purge`](#clear-local-data)は一時ディレクトリに触れません。ディレクトリはシステムの一時場所の下にあるため、オペレーティングシステムもそれをクリアできます。例えば、再起動時。Claude がそこに書き込んだものを保持するには、Claude にそれをプロジェクトに移動するよう依頼します。
```

</details>

<details>
<summary>commands-ja.md</summary>

```diff
diff --git a/docs-ja/pages/commands-ja.md b/docs-ja/pages/commands-ja.md
index e4936c8..0661930 100644
--- a/docs-ja/pages/commands-ja.md
+++ b/docs-ja/pages/commands-ja.md
@@ -66,5 +66,5 @@ Claude が応答中にコマンドを送信した場合、Claude Code はそれ
 | `/cd <path>` | このセッションを新しい作業ディレクトリに移動し、会話を保持します。部分的なパスを入力して一致するディレクトリの提案を表示し、`Tab` を押して 1 つを受け入れます。Claude Code が新しいディレクトリからすぐに適用するもの、および `/cd` が `/add-dir` とどのように異なるかについては、[セッションを別のディレクトリに移動する](https://code.claude.com/docs/ja/permissions.md#move-the-session-to-another-directory)を参照してください |
 | `/chrome` | [Claude in Chrome](https://code.claude.com/docs/ja/chrome.md) 設定を構成します |
-| `/claude-api [migrate\|upgrade\|api-version\|managed-agents-onboard\|managed-agents-secure\|prompt-audit\|cost-optimize\|build-eval\|hillclimb\|preserved-thinking-migration]` | **[Skill](https://code.claude.com/docs/ja/skills.md#bundled-skills).** プロジェクトの言語用に [Claude API](https://platform.claude.com/docs/en/api/overview) および [Managed Agents](https://platform.claude.com/docs/en/managed-agents/overview) リファレンス資料を読み込みます。コードが `anthropic` または `@anthropic-ai/sdk` をインポートするときも自動的にアクティブになります。各サブコマンドが何をするか、および必要なバージョンについては、[Claude API プロジェクトで作業する](https://code.claude.com/docs/ja/skills.md#work-on-claude-api-projects)を参照してください |
+| `/claude-api [migrate\|upgrade\|api-version\|managed-agents-onboard\|managed-agents-secure\|prompt-audit\|cost-optimize\|latency-optimize\|build-eval\|hillclimb\|preserved-thinking-migration]` | **[Skill](https://code.claude.com/docs/ja/skills.md#bundled-skills).** プロジェクトの言語用に [Claude API](https://platform.claude.com/docs/en/api/overview) および [Managed Agents](https://platform.claude.com/docs/en/managed-agents/overview) リファレンス資料を読み込みます。コードが `anthropic` または `@anthropic-ai/sdk` をインポートするときも自動的にアクティブになります。各サブコマンドが何をするか、および必要なバージョンについては、[Claude API プロジェクトで作業する](https://code.claude.com/docs/ja/skills.md#work-on-claude-api-projects)を参照してください |
 | `/claude-in-chrome [task]` | **[Skill](https://code.claude.com/docs/ja/skills.md#bundled-skills).** Claude にブラウザでタスクを実行させます。ページのテスト、フォームの入力、コンソールログの読み取りなど、[Claude in Chrome](https://code.claude.com/docs/ja/chrome.md) を通じて。Chrome 統合がセッションで有効な場合（たとえば `claude --chrome` など）、または Claude Code が[拡張機能をインストール](https://code.claude.com/docs/ja/chrome.md#install-the-extension-when-claude-asks)することを提案できる場合に利用可能です |
 | `/clear [name]` | 空のコンテキストで新しい会話を開始します。前の会話に `/resume` ピッカーでラベルを付けるために名前を渡します。同じ会話を続けながらコンテキストを解放するには、代わりに `/compact` を使用します。`/resume` で前の会話を再開するか、同じ Claude Code プロセスで、[rewind メニューの previous-session エントリ](https://code.claude.com/docs/ja/checkpointing.md#rewind-past-a-cleared-conversation)から復元します。エイリアス：`/reset`、`/new` |
```

</details>

<details>
<summary>common-workflows-ja.md</summary>

```diff
diff --git a/docs-ja/pages/common-workflows-ja.md b/docs-ja/pages/common-workflows-ja.md
index 5967fd6..e011105 100644
--- a/docs-ja/pages/common-workflows-ja.md
+++ b/docs-ja/pages/common-workflows-ja.md
@@ -467,5 +467,5 @@ claude --worktree feature-auth
 ```
 
-別の名前で 2 番目のターミナルで同じコマンドを実行して、分離された並列セッションを開始します。コミットがないリポジトリでは、コマンドは `Failed to resolve base branch "HEAD": git rev-parse failed` というエラーで失敗します。クリーンアップ、`.worktreeinclude`、および非 git VCS サポートについては、[Worktrees](https://code.claude.com/docs/ja/worktrees.md) を参照してください。1 つの画面から並列セッションを監視するには、別のターミナルではなく、[バックグラウンドエージェント](https://code.claude.com/docs/ja/agent-view.md) を参照してください。
+別の名前で 2 番目のターミナルで同じコマンドを実行して、分離された並列セッションを開始します。クリーンアップ、`.worktreeinclude`、および非 git VCS サポートについては、[Worktrees](https://code.claude.com/docs/ja/worktrees.md) を参照してください。別々のターミナルではなく 1 つの画面から並列セッションを監視するには、[バックグラウンドエージェント](https://code.claude.com/docs/ja/agent-view.md) を参照してください。
 
 ## 編集前に計画する
```

</details>

<details>
<summary>context-window-ja.md</summary>

```diff
diff --git a/docs-ja/pages/context-window-ja.md b/docs-ja/pages/context-window-ja.md
index 34f907f..da60dc0 100644
--- a/docs-ja/pages/context-window-ja.md
+++ b/docs-ja/pages/context-window-ja.md
@@ -20,5 +20,5 @@ Claude Code のコンテキストウィンドウには、セッションにつ
 ## コンテキスト圧縮後に残るもの
 
-長いセッションでコンテキスト圧縮が行われると、Claude Code は会話履歴をコンテキストウィンドウに収まるようにまとめます。v2.1.198 以降、要約リクエストはセッションの[拡張思考](https://code.claude.com/docs/ja/model-config.md#extended-thinking)設定を継承するため、セッションで有効になっている場合は思考を有効にして推論し、そうでない場合はオフのままになります。思考は要約の生成方法にのみ影響します。セッション設定はその後変更されません。各種コンテンツに何が起こるかは、それらがどのように読み込まれたかによって異なります。
+長いセッションでコンテキスト圧縮が行われると、Claude Code は会話履歴をコンテキストウィンドウに収まるようにまとめます。
 
 | メカニズム | 圧縮後 |
```

</details>

<!-- UPDATE_LOG_END -->
