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
<summary>2026-11-28</summary>

**変更ファイル:**

```
 docs-ja/pages/desktop-ja.md      | 15 ++++++++++++++-
 docs-ja/pages/model-config-ja.md |  2 +-
 2 files changed, 15 insertions(+), 2 deletions(-)
```

<details>
<summary>desktop-ja.md</summary>

```diff
diff --git a/docs-ja/pages/desktop-ja.md b/docs-ja/pages/desktop-ja.md
index d169fc3..65b8f7a 100644
--- a/docs-ja/pages/desktop-ja.md
+++ b/docs-ja/pages/desktop-ja.md
@@ -2069,4 +2069,5 @@ HIPAA が有効になっている Enterprise 組織では、**Desktop** トグ
 | `disableAutoMode` | [Auto](https://code.claude.com/docs/ja/permission-modes.md#eliminate-prompts-with-auto-mode)モードをモードセレクタから削除するには`"disable"`に設定します。`permissions`の下でも受け入れられます。 |
 | `autoMode` | 組織全体で auto モード分類器が信頼およびブロックするものをカスタマイズします。[auto モードを設定する](https://code.claude.com/docs/ja/auto-mode-config.md)を参照してください。 |
+| `model` | [新しいローカルセッションの開始時に使用される](#set-the-model-that-new-sessions-start-on)モデル ID を設定します |
 | `browserExternalPageTools` | Claude が[Browser ペイン](#browse-external-sites)の外部ページを読み取るまたは操作するためのツールを使用するのを防ぐには`"disabled"`に設定します。ユーザーは引き続き外部サイトに自分でナビゲートできます。ローカル開発サーバープレビューは影響を受けません。 |
 | `disableMobileSimulatorTools` | Claude の[iOS Simulator ペイン](https://code.claude.com/docs/ja/desktop-ios-simulator.md#turn-off-simulator-access)でデバイスを制御およびキャプチャするためのツールをブロックするには`true`に設定します。ペインはユーザー自身のタップに対して使用可能なままです。Claude のアクセスのみが削除されます。値は JSON ブール値`true`である必要があります。文字列`"true"`は無視されます。 |
@@ -2100,4 +2101,16 @@ Desktop セッションがどこで実行されるかに応じて、どの管理
 管理ソースのみが設定できる権限、プラグイン、および配信キーについては、[管理設定のみが設定できるキー](https://code.claude.com/docs/ja/managed-settings.md#managed-only-settings)を参照してください。
 
+#### 新しいセッションの開始時に使用されるモデルを設定する
+
+モデルピッカーでモデルの横に **Set by admin** と表示されている場合、管理設定でそのモデルが[`model`](https://code.claude.com/docs/ja/model-config#control-the-model-users-run-on)として設定されていることを意味します。このラベルが表示されている場合、新しいローカルセッションの開始時には、ユーザーがそのモデルを選択できるのであれば、ユーザーが最後に選択したモデルよりもそのモデルが優先されます。ユーザーは引き続き、セッションごとに別のモデルを選択できます。
+
+開始時のモデルの設定をやめるには：
+
+1. ユーザーのコンピューターで **Settings > Code** または **Settings > Claude Code** を開き、**Starting values from your organization** の下を見て、どの管理ソースが適用されているかを確認します。
+2. `model`を設定している各管理ソースから`model`を削除し、ユーザーに Desktop を再起動してもらいます。
+3. 各ユーザーに、使用する各フォルダで、セッションの最初のメッセージを送信する前にモデルを選択してもらいます。それまでは、新しいセッションが削除したモデルで開始される可能性があります。
+
+[組織のデフォルトモデル](https://code.claude.com/docs/ja/model-config.md#organization-default-model)がユーザーの選択を上書きする場合、ターミナルでは`model`が優先されるにもかかわらず、これらのセッションはユーザーがそのデフォルトを選択できるときにはそのデフォルトで開始されます。ユーザーが選択できるようにするには、[**Organization settings > Models**](https://claude.ai/admin-settings/models)と、独自のデフォルトを持つ各カスタムロールでも、**Always start with the default model and effort level** をオフにしてください。
+
 #### すべてのユーザーにスキルをデプロイする
 
@@ -2300,5 +2313,5 @@ Desktop と CLI は同じ設定ファイルを読み込むため、セットア
 * 設定で定義された **[フック](https://code.claude.com/docs/ja/hooks.md)** および **[スキル](https://code.claude.com/docs/ja/skills.md)** は両方に適用されます
 * `~/.claude.json` および `~/.claude/settings.json` の **[設定](https://code.claude.com/docs/ja/settings.md)** は共有されます。`settings.json` の権限ルール、許可されたツール、およびその他の設定は Desktop セッションに適用されます。一部のキーは[コードタブでは異なる動作をします](#claude-code-settings-that-behave-differently-in-the-code-tab)。
```

</details>

<details>
<summary>model-config-ja.md</summary>

```diff
diff --git a/docs-ja/pages/model-config-ja.md b/docs-ja/pages/model-config-ja.md
index 6aa5cec..15177d3 100644
--- a/docs-ja/pages/model-config-ja.md
+++ b/docs-ja/pages/model-config-ja.md
@@ -460,5 +460,5 @@ Claude Enterprise プランの組織管理者は、claude.ai の管理コンソ
 管理者は、組織のデフォルトがユーザーの選択を上書きするように設定することもできます。上書きが有効な場合、組織のデフォルトはユーザー、プロジェクト、ローカル設定内の `model` の値よりも優先されます。その場合、`/model` で保存したモデルは現在のセッションに適用され、新しいセッションでは組織のデフォルトに戻ります。ユーザーの選択が異なる場合、`/model` には `Your organization's default (<model>) applies on restart` と表示されます。
 
-上書きが有効な場合でも、`--model` フラグ、`ANTHROPIC_MODEL`、管理設定、`--settings` は引き続き優先されます。メンバーが選択できるモデルを制限するには、代わりに[組織のモデル制限](#organization-model-restrictions)または [`availableModels`](#restrict-model-selection) を使用してください。
+ターミナルでは、上書きが有効な場合でも、新しいセッションは `--model` フラグ、`ANTHROPIC_MODEL`、管理設定、または `--settings` で設定されたモデルで開始されます。メンバーが選択できるモデルを制限するには、[組織のモデル制限](#organization-model-restrictions)または [`availableModels`](#restrict-model-selection) を使用してください。
 
 Claude Code は起動時に一度だけ組織のデフォルトを読み込むため、セッション中に管理者がデフォルトを変更した場合は、次回の起動時に反映されます。
```

</details>

</details>


<details>
<summary>2026-11-26</summary>

**変更ファイル:**

```
 docs-ja/pages/claude-security-ja.md   | 26 ++++++++--
 docs-ja/pages/costs-ja.md             |  2 +-
 docs-ja/pages/debug-your-config-ja.md |  2 +-
 docs-ja/pages/errors-ja.md            |  1 +
 docs-ja/pages/hooks-guide-ja.md       |  6 ++-
 docs-ja/pages/hooks-ja.md             | 92 ++++++++++++++++++++++++++++++++---
 docs-ja/pages/managed-settings-ja.md  |  2 +-
 docs-ja/pages/settings-example-ja.md  |  2 +-
 docs-ja/pages/skills-ja.md            |  2 +
 docs-ja/pages/sub-agents-ja.md        |  2 +-
 docs-ja/pages/voice-dictation-ja.md   | 46 +++++++++++++++---
 11 files changed, 159 insertions(+), 24 deletions(-)
```

<details>
<summary>claude-security-ja.md</summary>

```diff
diff --git a/docs-ja/pages/claude-security-ja.md b/docs-ja/pages/claude-security-ja.md
index a2783a8..26bc941 100644
--- a/docs-ja/pages/claude-security-ja.md
+++ b/docs-ja/pages/claude-security-ja.md
@@ -68,5 +68,5 @@ VS Code 拡張機能またはデスクトップアプリでは、[プラグイ
 ### プラグインを更新する
 
-コマンドやオプションが動作しない場合は、プラグインのバージョンが 0.13.0 以降であることを[確認](https://code.claude.com/docs/ja/plugins/install.md#install-a-plugin)してください。
+コマンドやオプションが動作しない場合は、プラグインのバージョンが 0.13.1 以降であることを[確認](https://code.claude.com/docs/ja/plugins/install.md#install-a-plugin)してください。
 
 プラグインを自分で更新するには、[プラグインを今すぐ更新する](https://code.claude.com/docs/ja/plugins/install.md#update-plugins-now)を参照してください。また、自動更新がオフになっている場合を除き、Claude Code は[プラグインを自動的に更新](https://code.claude.com/docs/ja/plugins/install.md#keep-plugins-updated)します。
@@ -291,9 +291,25 @@ Claude が草案を表示したら、次の手順を行います。
 このコマンドはプラグインに含まれています。`PATH` に追加するには、Claude Code で `/claude-security:install-cli` と入力し、表示される指示に従ってください。
 
-次に、リポジトリ内で実行します。システムで必要な場合は `--sudo` または `--no-sandbox` を付けてください。
+サンドボックス内でスキャンする場合は、コードを受け取るプロバイダーに対応する値を指定して `--provider` を追加します。
 
-* **コードベースをスキャンする**：`claude-security`
-* **このブランチの変更をスキャンする**：`claude-security --changes`
-* **フルスクリーン表示でスキャンする**：`claude-security --tui`（Node.js 18 以降が必要）
+* `anthropic`：有料プランまたは Anthropic API
+* `bedrock`：[Amazon Bedrock](https://code.claude.com/docs/ja/amazon-bedrock.md)
+* `vertex`：[Google Cloud の Agent Platform](https://code.claude.com/docs/ja/google-vertex-ai.md)（旧 Vertex AI）
+* `foundry`：[Microsoft Foundry](https://code.claude.com/docs/ja/microsoft-foundry.md)
+
+使用する値を確認するには、ターミナルで `claude` を実行し、[`/status`](https://code.claude.com/docs/ja/commands#all-commands) と入力して、`API provider` 行とベース URL 行を確認します。
+
+* **`API provider` 行**：`Amazon Bedrock`、`Google Vertex AI`、`Microsoft Foundry` のいずれかに対応する値を使用します。`Amazon Bedrock (Mantle)` など、それ以外のプロバイダーの場合は、[セッション内でスキャン](#scan-and-fix-your-codebase)してください。
+* **ベース URL 行**：URL も渡します。たとえば `Anthropic base URL` の場合は、`--provider anthropic --model-base-url https://models.example.com` を使用します。コマンドが URL を拒否した場合は、セッション内でスキャンしてください。
+* **どちらの行もない場合**：組織経由で Claude Code を使用している場合は、使用する値を管理者に確認してください。それ以外の場合は `anthropic` を使用します。
```

</details>

<details>
<summary>costs-ja.md</summary>

```diff
diff --git a/docs-ja/pages/costs-ja.md b/docs-ja/pages/costs-ja.md
index 12a5a0c..0502868 100644
--- a/docs-ja/pages/costs-ja.md
+++ b/docs-ja/pages/costs-ja.md
@@ -299,5 +299,5 @@ MCP ツール定義は [デフォルトで遅延](https://code.claude.com/docs/j
 > [tab] settings.json
 >
-> これを [settings.json](https://code.claude.com/docs/ja/settings.md#where-settings-live) に追加して、すべての Bash コマンドの前にフックを実行します。
+> これを [settings.json](https://code.claude.com/docs/ja/settings.md#where-settings-live) に追加して、すべての Bash ツール呼び出しの前にフックを実行します。
 >
 > ```json theme={null}
```

</details>

<details>
<summary>debug-your-config-ja.md</summary>

```diff
diff --git a/docs-ja/pages/debug-your-config-ja.md b/docs-ja/pages/debug-your-config-ja.md
index f41634a..79745a2 100644
--- a/docs-ja/pages/debug-your-config-ja.md
+++ b/docs-ja/pages/debug-your-config-ja.md
@@ -63,5 +63,5 @@ Claude が指示を無視したり、設定した機能が表示されない場
 
 * フックがスタンドアロンファイルで定義されている。フックは[設定ファイル](https://code.claude.com/docs/ja/settings.md#settings-files)の `"hooks"` キーの下に置きます。
-* `matcher` の値が単一の文字列ではなく配列になっている。Claude Code は、対話型セッションの開始時と `claude doctor` で、そのエントリを無効な設定として一覧表示します。配列が `PreToolUse` または `PermissionRequest` の下にある場合、そのファイルの他のフックも一切読み込まれません。
+* `matcher` の値が単一の文字列ではなく配列になっている。Claude Code は、対話型セッションの開始時と `claude doctor` で、そのエントリを無効な設定として一覧表示します。配列が `PreToolUse`、`PermissionRequest`、または `PreSkillShellCommand` の下にある場合、そのファイルの他のフックも一切読み込まれません。
 * フックがスキルのフロントマターにあり、このセッションでユーザーも Claude もまだそのスキルを呼び出していない。スキルを呼び出すか Claude に呼び出しを依頼してから、`/hooks` を再度実行してください。それでもフックが表示されない場合は、[解析されなかったフロントマター](https://code.claude.com/docs/ja/skills.md#skill-not-triggering)や[スキルフックの制限](https://code.claude.com/docs/ja/hooks.md#limits-on-skill-hooks)のいずれかなど、他の原因がないか確認してください。
 
```

</details>

<details>
<summary>errors-ja.md</summary>

```diff
diff --git a/docs-ja/pages/errors-ja.md b/docs-ja/pages/errors-ja.md
index dea3213..7cca2ac 100644
--- a/docs-ja/pages/errors-ja.md
+++ b/docs-ja/pages/errors-ja.md
@@ -310,4 +310,5 @@
 | `Shell command permission check failed for pattern "..."`（動的コンテキストを挿入するスキルから） | [コマンドラインエラー](#security-review-fails-without-origin-head) |
 | ``Couldn't run `<command>` for <name>. A file named HEAD or .git in this folder or one above it may not be yours``（動的コンテキストを挿入するスキルから） | [挿入されたコマンドの権限チェック](https://code.claude.com/docs/ja/skills.md#permission-checks-on-injected-commands) |
+| `/security-review` または動的コンテキストを挿入するスキルからの `Not run in /<name>` / `Ran anyway in /<name>` / `[not run: blocked by hook` | [PreSkillShellCommand の決定制御](https://code.claude.com/docs/ja/hooks.md#preskillshellcommand-decision-control) |
 | ``Skill <name> requires bash (`shell: bash` in frontmatter) but Git Bash was not found`` | [コマンドラインエラー](#security-review-fails-without-origin-head) |
 | `No shell command in <name> was run, because the <tool> tool does not accept one of them` | [コマンドラインエラー](#no-shell-command-was-run) |
```

</details>

<details>
<summary>hooks-guide-ja.md</summary>

```diff
diff --git a/docs-ja/pages/hooks-guide-ja.md b/docs-ja/pages/hooks-guide-ja.md
index 92d612c..6c886d4 100644
--- a/docs-ja/pages/hooks-guide-ja.md
+++ b/docs-ja/pages/hooks-guide-ja.md
@@ -476,4 +476,5 @@ Claude Code は、ライフサイクルの特定の時点でフックイベン
 | `UserPromptSubmit` | プロンプトを送信するとき、Claude が処理する前。[Claude Code が独自に開始するターン](https://code.claude.com/docs/ja/hooks.md#userpromptsubmit)でも発火します |
 | `UserPromptExpansion` | ユーザーが入力したコマンドがプロンプトに展開されるとき、Claude に到達する前。展開をブロックできます |
+| `PreSkillShellCommand` | スキルの[挿入されたシェルコマンド](https://code.claude.com/docs/ja/skills.md#inject-dynamic-context)が実行される前。コマンドをブロックできます |
 | `PreToolUse` | ツール呼び出しが実行される前。ブロックできます |
 | `PermissionRequest` | ツール呼び出しが権限決定を必要とするとき |
@@ -695,4 +696,5 @@ matcher がない場合、フックはそのイベントが発生するたびに
 | `FileChanged` | 監視するファイル名のリテラル（[FileChanged](https://code.claude.com/docs/ja/hooks.md#filechanged) を参照） | `.envrc\|.env` |
 | `UserPromptExpansion` | コマンド名 | スキル名またはコマンド名 |
+| `PreSkillShellCommand` | コマンドを実行するツール | `Bash`、`PowerShell` |
 | `UserPromptSubmit`、`PostToolBatch`、`Stop`、`TeammateIdle`、`TaskCreated`、`TaskCompleted`、`WorktreeCreate`、`WorktreeRemove`、`CwdChanged`、`MessageDisplay` | matcher 非対応 | 発生するたびに常に発火 |
 
@@ -806,5 +808,7 @@ Claude Code が Bash の入力をサブコマンドに分割できない場合
 `if` フィールドは、権限ルールと同じパターン（`"Bash(git *)"`、`"Edit(*.ts)"` など）を受け付けます。複数のツール名に一致させるには、それぞれ独自の `if` 値を持つ個別のハンドラーを使用するか、パイプによる選択がサポートされている `matcher` レベルで照合してください。
 
-`if` はツールイベント（`PreToolUse`、`PostToolUse`、`PostToolUseFailure`、`PermissionRequest`、`PermissionDenied`）でのみ機能します。それ以外のイベントに追加すると、フックは実行されなくなります。
+> [!NOTE]
+>
+> `if` は `PreToolUse`、`PostToolUse`、`PostToolUseFailure`、`PermissionRequest`、`PermissionDenied`、`PreSkillShellCommand` でのみ機能します。それ以外のイベントに追加すると、フックは実行されなくなります。
 
 ### フックの場所を設定する
```

</details>

<details>
<summary>hooks-ja.md</summary>

```diff
diff --git a/docs-ja/pages/hooks-ja.md b/docs-ja/pages/hooks-ja.md
index 782588e..e6d152d 100644
--- a/docs-ja/pages/hooks-ja.md
+++ b/docs-ja/pages/hooks-ja.md
@@ -25,5 +25,5 @@ Claude Code は、セッション中の特定のポイントでフックを実
 * エージェント型ループ内のすべてのツール呼び出しで：`PreToolUse` と `PostToolUse`。ただし、[`EndConversation`](https://code.claude.com/docs/ja/tools-reference#endconversation-tool-behavior) の呼び出しは両方をスキップします
 
-![オプションの Setup から SessionStart に流れ込み、その後、UserPromptSubmit、スラッシュコマンド用の UserPromptExpansion、ネストされたエージェント型ループ（PreToolUse、PermissionRequest、PostToolUse、PostToolUseFailure、PostToolBatch、SubagentStart/Stop、TaskCreated、TaskCompleted）、Stop または StopFailure を含むターンごとのループ、その後 TeammateIdle、PreCompact、PostCompact、SessionEnd が続くことを示すフック ライフサイクル図。Elicitation と ElicitationResult は MCP ツール実行内にネストされ、PermissionDenied は auto モードでの拒否のための PermissionRequest からの副分岐、WorktreeCreate、WorktreeRemove、Notification、ConfigChange、InstructionsLoaded、CwdChanged、FileChanged、DirectoryAdded はスタンドアロンの非同期イベント、PreModelSwitch は要求されたモデル切り替えの前に実行されるスタンドアロンの逐次イベント、PostModelSwitch はセッションのモデルが変更された後に実行されるスタンドアロンの非同期イベント、MessageDisplay はアシスタントのメッセージ テキストのストリーミング中に実行される表示専用イベントとして示されています](https://mintcdn.com/claude-code/x7pO8l4XcvAXCoVc/images/hooks-lifecycle.svg?fit=max\&auto=format\&n=x7pO8l4XcvAXCoVc\&q=85\&s=81b9256c1bbe8832553485f5d9e9c746)
+![オプションの Setup から SessionStart に流れ込み、その後、UserPromptSubmit、スラッシュコマンド用の UserPromptExpansion、ネストされたエージェント型ループ（PreToolUse、PermissionRequest、PostToolUse、PostToolUseFailure、PostToolBatch、SubagentStart/Stop、TaskCreated、TaskCompleted）、Stop または StopFailure を含むターンごとのループ、その後 TeammateIdle、PreCompact、PostCompact、SessionEnd が続くことを示すフック ライフサイクル図。Elicitation と ElicitationResult は MCP ツール実行内にネストされ、PermissionDenied は auto モードでの拒否のための PermissionRequest からの副分岐、WorktreeCreate、WorktreeRemove、Notification、ConfigChange、InstructionsLoaded、CwdChanged、FileChanged、DirectoryAdded はスタンドアロンの非同期イベント、PreSkillShellCommand は読み込み中のスキル内のシェル コマンドの前に実行されるスタンドアロンのブロッキング イベント、PreModelSwitch は要求されたモデル切り替えの前に実行されるスタンドアロンの逐次イベント、PostModelSwitch はセッションのモデルが変更された後に実行されるスタンドアロンの非同期イベント、MessageDisplay はアシスタントのメッセージ テキストのストリーミング中に実行される表示専用イベントとして示されています](https://mintcdn.com/claude-code/IWhl7FXSx6ARoVoo/images/hooks-lifecycle.svg?fit=max\&auto=format\&n=IWhl7FXSx6ARoVoo\&q=85\&s=a8adf56a3d13b8a8ba9c446bbd7171f8)
 
 以下の表は、各イベントがいつ発火するかをまとめています。[フック イベント](#hook-events)セクションでは、各イベントの完全な入力スキーマと決定制御オプションについて説明しています。
@@ -35,4 +35,5 @@ Claude Code は、セッション中の特定のポイントでフックを実
 | `UserPromptSubmit` | プロンプトを送信するとき、Claude が処理する前。[Claude Code が独自に開始するターン](https://code.claude.com/docs/ja/hooks.md#userpromptsubmit)でも発火します |
 | `UserPromptExpansion` | ユーザーが入力したコマンドがプロンプトに展開されるとき、Claude に到達する前。展開をブロックできます |
+| `PreSkillShellCommand` | スキルの[挿入されたシェルコマンド](https://code.claude.com/docs/ja/skills.md#inject-dynamic-context)が実行される前。コマンドをブロックできます |
 | `PreToolUse` | ツール呼び出しが実行される前。ブロックできます |
 | `PermissionRequest` | ツール呼び出しが権限決定を必要とするとき |
@@ -309,4 +310,5 @@ Claude Code は JSON 決定を読み取り、ツール呼び出しをブロッ
 | `InstructionsLoaded` | ロード理由 | `session_start`、`nested_traversal`、`path_glob_match`、`include`、`compact` |
 | `UserPromptExpansion` | コマンド名 | スキルまたはコマンド名 |
+| `PreSkillShellCommand` | コマンドを実行するツール | `Bash`、`PowerShell` |
 | `Elicitation` | MCP サーバー名 | 設定された MCP サーバー名 |
 | `ElicitationResult` | MCP サーバー名 | `Elicitation` と同じ値 |
@@ -422,5 +424,5 @@ Monitor コマンドに対して実行されるフックは、そのコマンド
 | :- | :- | :- |
 | `type` | はい | `"command"`、`"http"`、`"mcp_tool"`、`"prompt"`、または `"agent"` |
-| `if` | いいえ | このフックが実行されるタイミングをフィルタリングする[権限ルール構文](https://code.claude.com/docs/ja/permissions.md#permission-rule-syntax)（`"Bash(git *)"` や `"Edit(*.ts)"` など）。ツール呼び出しがパターンにマッチする場合のみ、フック コマンドが実行されます。Bash パターンがサブコマンド、`$()`、バッククォートに対してどのように評価されるかについては、[Bash マッチング テーブル](#bash-if-matching)を参照してください。ツール イベントでのみ評価されます: `PreToolUse`、`PostToolUse`、`PostToolUseFailure`、`PermissionRequest`、`PermissionDenied`。他のイベントでは、`if` が設定されたフックは実行されません |
+| `if` | いいえ | このフックが実行されるタイミングをフィルタリングする[権限ルール構文](https://code.claude.com/docs/ja/permissions.md#permission-rule-syntax)（`"Bash(git *)"` や `"Edit(*.ts)"` など）。ツール呼び出しがパターンにマッチする場合のみ、フック コマンドが実行されます。Bash パターンがサブコマンド、`$()`、バッククォートに対してどのように評価されるかについては、[Bash マッチング テーブル](#bash-if-matching)を参照してください。`PreToolUse`、`PostToolUse`、`PostToolUseFailure`、`PermissionRequest`、`PermissionDenied`、`PreSkillShellCommand` でのみ評価されます。他のイベントでは、`if` が設定されたフックは実行されません |
 | `timeout` | いいえ | キャンセルまでの秒数。[`async: true`](#run-hooks-in-the-background) で実行するコマンドフックには、Claude Code はこれを適用しません。デフォルト: `command`、`http`、`mcp_tool` は 600、`prompt` は 30、`agent` は 60。Claude Code は、[`UserPromptSubmit`](#userpromptsubmit)、[`PreModelSwitch`](#premodelswitch)、[`PostModelSwitch`](#postmodelswitch) では `command`、`http`、`mcp_tool` のデフォルトを 30 に、[`MessageDisplay`](#messagedisplay) では 10 に下げます。[`SessionEnd`](#sessionend) フックは 1.5 秒の予算を共有します。設定でフックごとにより長い `timeout` を指定している場合、Claude Code は最大 60 秒までそれに合わせて予算を引き上げます |
 | `statusMessage` | いいえ | フックの実行中に表示されるカスタム スピナー メッセージ |
```

</details>

<details>
<summary>managed-settings-ja.md</summary>

```diff
diff --git a/docs-ja/pages/managed-settings-ja.md b/docs-ja/pages/managed-settings-ja.md
index 739f3f1..ce55f0d 100644
--- a/docs-ja/pages/managed-settings-ja.md
+++ b/docs-ja/pages/managed-settings-ja.md
@@ -138,5 +138,5 @@ claude.ai の [**Organization settings > Desktop 3P**](https://claude.ai/admin-s
 Claude Code は、優先度の高い順に次の順序でソースを確認します。
 
-1. リモート設定。claude.ai から[サーバー管理設定](https://code.claude.com/docs/ja/server-managed-settings.md)として、または [Claude apps ゲートウェイ](https://code.claude.com/docs/ja/claude-apps-gateway)によって配信されます。Claude Code がこのソースを取得するのは、セッションが次のいずれかの条件を満たす場合のみです。
+1. リモート設定。claude.ai から[サーバー管理設定](https://code.claude.com/docs/ja/server-managed-settings.md)として、または [Claude apps ゲートウェイ](https://code.claude.com/docs/ja/claude-apps-gateway)によって配信されます。セッションが次のいずれかの条件を満たす場合、Claude Code はこのソースを取得できます。
 
    * [対象となる認証情報](https://code.claude.com/docs/ja/server-managed-settings.md#platform-availability)を持っている
```

</details>

<details>
<summary>settings-example-ja.md</summary>

```diff
diff --git a/docs-ja/pages/settings-example-ja.md b/docs-ja/pages/settings-example-ja.md
index e28705e..3cb3c19 100644
--- a/docs-ja/pages/settings-example-ja.md
+++ b/docs-ja/pages/settings-example-ja.md
@@ -184,5 +184,5 @@
 >     ]
 >   },
->   // すべての Bash コマンドの前に、リポジトリ内のスクリプトを実行してそれをブロックできます
+>   // すべての Bash ツール呼び出しの前に、それをブロックできるリポジトリ内のスクリプトを実行
 >   "hooks": {
 >     "PreToolUse": [
```

</details>

<details>
<summary>skills-ja.md</summary>

```diff
diff --git a/docs-ja/pages/skills-ja.md b/docs-ja/pages/skills-ja.md
index 1b00749..274d478 100644
--- a/docs-ja/pages/skills-ja.md
+++ b/docs-ja/pages/skills-ja.md
@@ -822,4 +822,6 @@ PowerShell ツールも、実行するコマンドに同じタイムアウト、
 auto モードでは、本来ユーザーの承認が必要なコマンドでも呼び出しは中止されません。スキルは、最初にそのコマンドを実行するよう Claude に指示する内容とともに読み込まれ、Claude 自身による呼び出しは [auto モードの通常のチェック](https://code.claude.com/docs/ja/permission-modes.md#how-the-classifier-evaluates-actions)を経由します。ただし、`agent` を設定する[フォークされたスキル](#run-skills-in-a-subagent)や、Claude が[注入されたコマンドを実行するシェルツール](#how-injected-commands-run)を持たないセッションでは、引き続き呼び出しが中止されます。
 
+`PreToolUse` フックは、スキルの読み込み時に実行される注入されたコマンドに対しては発火しません。権限チェックを通過したコマンドをログに記録またはブロックするには、[`PreSkillShellCommand` フック](https://code.claude.com/docs/ja/hooks#preskillshellcommand)を使用してください。
+
 ### サブエージェントでスキルを実行する
 
```

</details>

<details>
<summary>sub-agents-ja.md</summary>

```diff
diff --git a/docs-ja/pages/sub-agents-ja.md b/docs-ja/pages/sub-agents-ja.md
index 68012b7..43501b5 100644
--- a/docs-ja/pages/sub-agents-ja.md
+++ b/docs-ja/pages/sub-agents-ja.md
@@ -715,5 +715,5 @@ the review preferences and corrections you're given.
 ツールの使用をより動的に制御するには、`PreToolUse` フックを使用して操作の実行前に検証します。これは、あるツールの一部の操作を許可しつつ他の操作をブロックする必要がある場合に便利です。
 
-この例では、読み取り専用のデータベースクエリのみを許可するサブエージェントを作成します。`PreToolUse` フックは、各 Bash コマンドの実行前に `command` で指定されたスクリプトを実行します。
+この例では、読み取り専用のデータベースクエリのみを許可するサブエージェントを作成します。`PreToolUse` フックは、各 Bash ツール呼び出しの実行前に `command` で指定されたスクリプトを実行します。
 
 ```yaml theme={null}
```

</details>

*...以降省略*

</details>


<details>
<summary>2026-11-25</summary>

**変更ファイル:**

```
 docs-ja/pages/admin-setup-ja.md                    |   6 +-
 docs-ja/pages/advisor-ja.md                        |   4 +-
 docs-ja/pages/agent-teams-ja.md                    |   2 +-
 docs-ja/pages/agent-view-ja.md                     |  10 +-
 docs-ja/pages/amazon-bedrock-ja.md                 |   9 +
 docs-ja/pages/approvals-github-rules-ja.md         |   2 +-
 docs-ja/pages/approvals-ja.md                      |   7 +-
 docs-ja/pages/approvals-policy-ja.md               | 183 +++---
 docs-ja/pages/approvals-pull-requests-ja.md        |  28 +-
 docs-ja/pages/approvals-setup-ja.md                |  36 +-
 docs-ja/pages/approvals-troubleshooting-ja.md      |  13 +-
 docs-ja/pages/artifacts-ja.md                      |  32 +-
 docs-ja/pages/authentication-ja.md                 |   4 +-
 docs-ja/pages/best-practices-ja.md                 |   5 +-
 docs-ja/pages/champion-kit-ja.md                   |   2 +-
 docs-ja/pages/changelog.md                         | 153 +++++
 docs-ja/pages/channels-ja.md                       |   2 +-
 docs-ja/pages/checkpointing-ja.md                  |   2 +-
 docs-ja/pages/claude-apps-gateway-config-ja.md     |   4 +-
 docs-ja/pages/claude-apps-gateway-deploy-ja.md     |   1 +
 docs-ja/pages/claude-code-on-the-web-ja.md         |   8 +-
 docs-ja/pages/claude-directory-ja.md               |   6 +-
 docs-ja/pages/claude-platform-on-aws-ja.md         |   2 +-
 docs-ja/pages/claude-projects-ja.md                |   4 +-
 docs-ja/pages/claude-security-ja.md                | 315 +++++++---
 docs-ja/pages/cli-reference-ja.md                  |   2 +-
 docs-ja/pages/cloud-environments-ja.md             |   2 +-
 docs-ja/pages/code-mode-ja.md                      |  70 ++-
 docs-ja/pages/code-review-ja.md                    |   4 +-
 docs-ja/pages/code-review-local-ja.md              |   2 +-
 docs-ja/pages/code-review-setup-ja.md              |   2 +-
 docs-ja/pages/commands-ja.md                       |  11 +-
 docs-ja/pages/desktop-ios-simulator-ja.md          |   2 +-
 docs-ja/pages/desktop-ja.md                        |  32 +-
 docs-ja/pages/desktop-quickstart-ja.md             |   6 +-
 docs-ja/pages/env-vars-ja.md                       |  22 +-
 docs-ja/pages/errors-ja.md                         |  78 ++-
 docs-ja/pages/fast-mode-ja.md                      |   2 +-
 docs-ja/pages/feature-availability-ja.md           |  22 +-
 docs-ja/pages/features-overview-ja.md              |   4 +-
 docs-ja/pages/google-vertex-ai-ja.md               |   9 +-
 docs-ja/pages/headless-ja.md                       |   3 +-
 docs-ja/pages/hooks-ja.md                          |  12 +-
 docs-ja/pages/how-claude-code-works-ja.md          |   8 +-
 docs-ja/pages/large-codebases-ja.md                |   2 +-
 docs-ja/pages/llm-gateway-connect-ja.md            |   6 +-
 docs-ja/pages/managed-settings-ja.md               |  12 +-
 docs-ja/pages/mcp-ja.md                            | 680 +++++++++++++--------
 docs-ja/pages/memory-ja.md                         |   6 +-
 docs-ja/pages/microsoft-foundry-ja.md              |   9 +
 docs-ja/pages/mobile-ja.md                         |   3 +-
 docs-ja/pages/model-config-ja.md                   |   4 +-
 docs-ja/pages/monitoring-usage-ja.md               |  33 +-
 docs-ja/pages/network-config-ja.md                 |   6 +-
 docs-ja/pages/overview-ja.md                       |   6 +-
 docs-ja/pages/permission-modes-ja.md               |  12 +-
 docs-ja/pages/permissions-ja.md                    |  14 +-
 docs-ja/pages/platforms-ja.md                      |   5 +-
 docs-ja/pages/plugin-evals-ja.md                   |  38 +-
 docs-ja/pages/pr-steward-ja.md                     |   2 +-
 docs-ja/pages/pr-steward-pull-requests-ja.md       |   6 +-
 docs-ja/pages/pr-steward-setup-ja.md               |   6 +-
 docs-ja/pages/pr-steward-troubleshooting-ja.md     |   3 +
 docs-ja/pages/prompt-caching-ja.md                 |   6 +-
 docs-ja/pages/quickstart-ja.md                     |   2 +-
 docs-ja/pages/remote-control-ja.md                 |   3 +-
 docs-ja/pages/routines-ja.md                       |  12 +-
 docs-ja/pages/scheduled-tasks-ja.md                |  12 +-
 .../self-hosted-environments-configuration-ja.md   |  26 +-
 docs-ja/pages/server-managed-settings-ja.md        |   2 +-
 docs-ja/pages/settings-ja.md                       |  24 +-
 docs-ja/pages/settings-reference-ja.md             |  29 +-
 docs-ja/pages/setup-ja.md                          |  12 +-
 docs-ja/pages/share-sessions-ja.md                 |   7 +-
 docs-ja/pages/ship-command-ja.md                   |  89 ++-
 docs-ja/pages/ship-command-troubleshooting-ja.md   | 104 +++-
 docs-ja/pages/skills-ja.md                         |  34 +-
 docs-ja/pages/slack-ja.md                          | 247 +-------
 docs-ja/pages/sub-agents-ja.md                     |  14 +-
 docs-ja/pages/tools-reference-ja.md                |  65 +-
 docs-ja/pages/troubleshoot-install-ja.md           |   9 +-
 docs-ja/pages/vs-code-ja.md                        |  18 +-
 docs-ja/pages/web-quickstart-ja.md                 |   2 +-
 docs-ja/pages/workflows-ja.md                      |   2 +-
 docs-ja/pages/worktrees-ja.md                      |  20 +-
 85 files changed, 1712 insertions(+), 1013 deletions(-)
```

<details>
<summary>admin-setup-ja.md</summary>

```diff
diff --git a/docs-ja/pages/admin-setup-ja.md b/docs-ja/pages/admin-setup-ja.md
index 2af11a9..1fcadfb 100644
--- a/docs-ja/pages/admin-setup-ja.md
+++ b/docs-ja/pages/admin-setup-ja.md
@@ -54,5 +54,5 @@ Claude Code は複数の API プロバイダーのいずれかを通じて Claud
 Claude Code はスタートアップ時に server-managed 設定をフェッチし、セッション中は 1 時間ごとに更新します。デプロイするエンドポイントインフラストラクチャはありません。claude.ai 管理コンソール経由の配信には Claude for Teams または Enterprise プランが必要です。Amazon Bedrock、Google Cloud の Agent Platform、または Microsoft Foundry でのデプロイは、[Claude apps gateway](https://code.claude.com/docs/ja/claude-apps-gateway) を実行することで同じリモート配信を取得できます。または、ファイルベースまたは OS レベルのメカニズムのいずれかを代わりに使用してください。
 
-claude.ai の **Organization settings > Desktop 3P** でプロバイダーまたはゲートウェイを設定している場合は、Enterprise Admin Console ガイドの[どの設定が優先されるか](https://claude.com/docs/third-party/claude-desktop/admin-console-claude-code#which-settings-take-priority)を参照してください。
+claude.ai の [**Organization settings > Desktop 3P**](https://claude.ai/admin-settings/desktop-deployment) でプロバイダーまたはゲートウェイを設定している場合は、Enterprise Admin Console ガイドの[どの設定が優先されるか](https://claude.com/docs/third-party/claude-desktop/admin-console-claude-code#which-settings-take-priority)を参照してください。
 
 組織が複数のプロバイダーを混在させている場合、claude.ai ユーザー向けに [server-managed settings](https://code.claude.com/docs/ja/server-managed-settings.md) を設定し、他のユーザーがマネージドポリシーを受け取るように [ファイルベースまたは plist/registry フォールバック](https://code.claude.com/docs/ja/managed-settings.md#delivery-mechanisms)を設定してください。
@@ -159,5 +159,5 @@ Claude 組織にリンクできる github.com の組織と個人アカウント
 **1. 組織を許可する**
 
-Team または Enterprise プランの Owner として、ブラウザで [**Organization settings > Git providers**](https://claude.ai/admin-settings/source-control) の GitHub セクションを開き、**Choose organizations** をクリックします。承認する組織を表で選択し、**Allow** をクリックします。すでにリンクされている組織は自動的には許可されないため、それらも含めてください。
+Team または Enterprise プランでは、[Owner](https://code.claude.com/docs/ja/server-managed-settings.md#access-control) がこれを設定できます。ブラウザで [**Organization settings > Git providers**](https://claude.ai/admin-settings/source-control) の GitHub セクションを開き、**Choose organizations** をクリックします。承認する組織を表で選択し、**Allow** をクリックします。すでにリンクされている組織は自動的には許可されないため、それらも含めてください。
 
 **2. その他のアカウントを名前で許可する**
@@ -190,5 +190,5 @@ Team または Enterprise プランの Owner として、ブラウザで [**Orga
 | Analytics dashboard | Teams / Enterprise でのリーダーボード付き採用度と貢献度メトリクス、Console でのユーザーごとの使用状況と支出メトリクス | Teams / Enterprise は [claude.ai/analytics](https://claude.ai/analytics/claude-code)、Console は [platform.claude.com/claude-code](https://platform.claude.com/claude-code) | [Analytics](https://code.claude.com/docs/ja/analytics.md) |
 | Programmatic reporting | API を通じたユーザーごとの使用状況とコストデータ | Enterprise 向け [Enterprise Analytics API](https://platform.claude.com/docs/en/api/admin/analytics)、Console 向け [Claude Code Analytics API](https://platform.claude.com/docs/en/build-with-claude/claude-code-analytics-api) | [Costs](https://code.claude.com/docs/ja/costs.md#manage-costs-for-your-organization) |
-| Spend controls | 支出制限とレート制限 | Teams / Enterprise の組織設定、Console のワークスペース制限、サードパーティクラウドではクラウド予算管理またはユーザーごとの [支出制限](https://code.claude.com/docs/ja/claude-apps-gateway-spend-limits.md) を備えた [Claude apps gateway](https://code.claude.com/docs/ja/claude-apps-gateway) | [Costs](https://code.claude.com/docs/ja/costs.md#manage-costs-for-your-organization) |
+| Spend controls | 支出制限とレート制限 | Teams / Enterprise の [組織設定](https://claude.ai/admin-settings/usage)、Console のワークスペース制限、サードパーティクラウドではクラウド予算管理またはユーザーごとの [支出制限](https://code.claude.com/docs/ja/claude-apps-gateway-spend-limits.md) を備えた [Claude apps gateway](https://code.claude.com/docs/ja/claude-apps-gateway) | [Costs](https://code.claude.com/docs/ja/costs.md#manage-costs-for-your-organization) |
 
 Teams および Enterprise では、ユーザーごとの使用状況と支出の数値は分析ダッシュボードではなく、組織の分析設定の [支出レポート](https://support.claude.com/en/articles/12883420-view-usage-analytics-for-team-and-enterprise-plans) から取得されます。クラウドプロバイダーは AWS Cost Explorer、GCP Billing、または Azure Cost Management を通じて支出を公開します。Claude チャット、Claude Code、Cowork 全体にわたるエンタープライズ予算計画については、[Claude Enterprise 消費ガイド](https://support.claude.com/en/articles/14782391-claude-enterprise-consumption-guide) を参照してください。
```

</details>

<details>
<summary>advisor-ja.md</summary>

```diff
diff --git a/docs-ja/pages/advisor-ja.md b/docs-ja/pages/advisor-ja.md
index 14c156c..3a7565f 100644
--- a/docs-ja/pages/advisor-ja.md
+++ b/docs-ja/pages/advisor-ja.md
@@ -51,5 +51,5 @@ advisor モデルは 3 つの方法で設定できます。
 * `/advisor off` を実行してそれをオフにします。
 
-Claude Code は、組織の [`availableModels`](https://code.claude.com/docs/ja/model-config#restrict-model-selection) 許可リストが除外した保存済み advisor を呼び出しません。advisor を使用するには、`/advisor` で許可されたモデルを選択してください。
+Claude Code は、設定内の [`availableModels`](https://code.claude.com/docs/ja/model-config#restrict-model-selection) 許可リストが除外した保存済み advisor を呼び出しません。advisor を使用するには、`/advisor` で許可されたモデルを選択してください。
 
 Claude Code は、現在のメインモデルがサポートしていない advisor を引き続き保存します。その advisor は、[`/model`](https://code.claude.com/docs/ja/model-config#setting-your-model) で[互換性のあるメインモデル](#choose-an-advisor-model)に切り替えた後にアクティブになります。API がすでに現在の会話で保存済み advisor を拒否した場合、モデルを切り替えた後でも、`/clear` または `/compact` まで、それはオフのままです。
@@ -79,5 +79,5 @@ Claude Code はそのセッションの `advisorModel` 設定の代わりにフ
 * セッションのメインモデルが advisor をサポートしていない
 * Haiku 4.5 などのリクエストされたモデルが advisor として機能できない
-* 組織の [`availableModels`](https://code.claude.com/docs/ja/model-config#restrict-model-selection) 許可リストがリクエストされたモデルを除外している
+* [`availableModels`](https://code.claude.com/docs/ja/model-config#restrict-model-selection) 許可リストがリクエストされたモデルを除外している
 * Fable をリクエストし、アカウントがまだ[使用クレジット同意](#fable-advisor-and-usage-credits)を必要としている
 
```

</details>

<details>
<summary>agent-teams-ja.md</summary>

```diff
diff --git a/docs-ja/pages/agent-teams-ja.md b/docs-ja/pages/agent-teams-ja.md
index 2744fb8..54721cb 100644
--- a/docs-ja/pages/agent-teams-ja.md
+++ b/docs-ja/pages/agent-teams-ja.md
@@ -171,5 +171,5 @@ v2.1.251 より前は、`CLAUDE_CODE_SUBAGENT_MODEL` がこの順序で最初に
 > `teammateDefaultModel` は v2.1.234 で削除されました。Claude Code は残された値を無視します。代わりにプロンプトでモデルを指定してください。
 
-Claude Code は、チームメンバーに対して選択したモデルを、組織の [`availableModels`](https://code.claude.com/docs/ja/model-config#restrict-model-selection) 許可リストに対してチェックします。許可リストが値をブロックすると、Claude Code は別のモデルを代替します。
+Claude Code は、チームメンバーに対して選択したモデルを、[`availableModels`](https://code.claude.com/docs/ja/model-config#restrict-model-selection) 許可リストが存在する場合はそれに対してチェックします。許可リストが値をブロックすると、Claude Code は別のモデルを代替します。
 
 * **`opus` などのファミリーエイリアス**：Anthropic API および AWS 上の Claude Platform では、Claude Code はチームメンバーを許可リストが許可するそのファミリーの最新バージョンで実行します。プロバイダー固有のモデル ID を持つプロバイダーでは、[代替が動作しない](https://code.claude.com/docs/ja/model-config.md#restrict-model-selection)場合、ブロックされたエイリアスは次の箇条書きに従って他のブロックされた値のようにフォールバックします。
```

</details>

<details>
<summary>agent-view-ja.md</summary>

```diff
diff --git a/docs-ja/pages/agent-view-ja.md b/docs-ja/pages/agent-view-ja.md
index eb8b621..8a08bda 100644
--- a/docs-ja/pages/agent-view-ja.md
+++ b/docs-ja/pages/agent-view-ja.md
@@ -240,5 +240,5 @@ Completed
 選択した行で `Enter` または `→` を押してアタッチします。エージェントビューは完全なインタラクティブセッションに置き換えられます。アタッチすると、Claude は不在中に何が起こったかの短い要約を投稿します。
 
-アタッチ中、セッションは他の Claude Code セッションと同様に動作します。[コマンド](https://code.claude.com/docs/ja/commands.md)、キーボードショートカット、機能はすべて動作しますが、以下の例外があります。
+アタッチ中は、[コマンド](https://code.claude.com/docs/ja/commands.md)、キーボードショートカット、機能はすべて動作しますが、以下の例外があります。[`/ship` または `/steward` のウォッチ](https://code.claude.com/docs/ja/ship-command-troubleshooting#a-session-setting-blocks-a-watch) は、バックグラウンドセッションでは開始されません。
 
 アタッチ中は、ターミナルにいる人がダイアログを完了できるため、`/install-github-app` と [`/mcp`](https://code.claude.com/docs/ja/mcp) 設定リストは通常どおり機能します。誰もアタッチしていない場合、これらのコマンドはダイアログを開けないため、セッションはエージェントビューの `Needs input` の下に `open this session to manage MCP servers` のような行とともに表示され、トランスクリプトの返信にも同じ内容が示されます。続行するにはアタッチしてコマンドを再度実行します。アタッチすると入力が必要な行はクリアされます。`/mcp reconnect <server>`、`/mcp enable`、および `/mcp disable` は、どちらの場合もアタッチせずに機能します。
@@ -446,4 +446,8 @@ Claude Code がセッションをバックグラウンドにすると（約 10 
 `/background` またはそのエイリアス `/bg` を実行すると、現在の会話がバックグラウンドセッションに移動します。`/bg run the test suite and fix any failures` のようにプロンプトを渡すと、先にもう 1 つ指示を与えられます。`/bg` の実行時に Claude が応答中の場合、応答はバックグラウンドセッションで続行されます。
 
+> [!NOTE]
+>
+> [`/ship` または `/steward` の監視](https://code.claude.com/docs/ja/ship-command) が有効な間は、`/bg` はセッションをフォアグラウンドに残し、その理由を出力します。[監視中のメッセージ](https://code.claude.com/docs/ja/ship-command-troubleshooting.md#messages-during-a-watch) を参照してください。
+
 サブエージェントやワークフローなど、特定の種類のバックグラウンド作業が実行中にセッションを終了すると、`Background work is running` ダイアログが表示され、その作業が停止することを警告します。`Move to background and exit` を選択すると、`/background` と同じ方法でセッションをバックグラウンドに移動してシェルに戻ります。エージェントビューが [オフになっている](#turn-off-agent-view) 場合、このオプションは表示されません。
 
@@ -846,5 +850,5 @@ Claude Code は、エージェントビューに一覧表示されるすべて
 * **作業中、権限プロンプトやその他のダイアログで一時停止中、またはアタッチ中**：プロセスは実行を続けます。実行中のサブエージェント、ワークフロー、モニターは作業中とみなされ、`/loop` のウェイクアップなど保留中の[セッションスコープのスケジュールタスク](https://code.claude.com/docs/ja/scheduled-tasks.md)も同様です。
 * **完了済み、または次のメッセージを待機中で、約 1 時間アタッチされていない**：スーパーバイザーはリソースを解放するためにプロセスを停止します。質問をしてターンを終えたセッションは、次のメッセージを待機中とみなされます。会話はディスク上に残り、次にアタッチまたは返信すると、セッションは中断したところから再開します。プロセスを実行し続けるには、`Ctrl+T` でセッションをピン留めします。
-* **スーパーバイザーの実行中にセッションのプロセスが予期せず終了した**：スーパーバイザーがそのプロセスを再起動します。`←` または `/background` で自分でバックグラウンドに送ったセッションを、たとえば `kill` で終了した場合は、再起動されずに停止済みとしてマークされます。シャットダウンによって終了したセッションについては、[シャットダウン後にセッションが失敗または停止と表示される](#sessions-show-as-failed-after-shutdown)を参照してください。
+* **スーパーバイザーの実行中にセッションのプロセスが予期せず終了した**：スーパーバイザーはそのプロセスを再起動できます。`←` または `/background` で自分でバックグラウンドに送ったセッションを、たとえば `kill` で終了した場合は、再起動されずに停止済みとしてマークされます。セッションの行に `∙` と表示されている場合は、そのセッションを選択して `Enter` を押すとセッションを再起動できます。シャットダウンによって終了したセッションについては、[シャットダウン後にセッションが失敗または停止と表示される](#sessions-show-as-failed-after-shutdown)を参照してください。
 * **自動更新の後**：スーパーバイザーは新しいバージョンで自身を再起動し、アイドル状態のセッションをバックグラウンドで移行します。作業中、ユーザーの応答待ち、またはアタッチ中のセッションは中断されません。
 * **スーパーバイザー自体が停止した**（たとえば、そのプロセスが Claude Code の外部から終了された場合）：macOS と Linux では、約 1 分以内に新しいスーパーバイザーが接続しない限り、セッションは停止します。スーパーバイザーを起動するには、シェルで `claude agents` を実行します。その 1 分を過ぎた場合は、[スーパーバイザー停止後もセッションを実行し続ける](#keep-sessions-running-after-the-supervisor-stops)を参照してください。
@@ -1053,4 +1057,6 @@ Agent view はリサーチプレビュー中に急速に進化しました。古
 | バージョン | 変更 |
 | - | - |
```

</details>

<details>
<summary>amazon-bedrock-ja.md</summary>

```diff
diff --git a/docs-ja/pages/amazon-bedrock-ja.md b/docs-ja/pages/amazon-bedrock-ja.md
index 663cebf..4454fc2 100644
--- a/docs-ja/pages/amazon-bedrock-ja.md
+++ b/docs-ja/pages/amazon-bedrock-ja.md
@@ -12,4 +12,13 @@ View plans
 Contact sales
 
+このページでは、Claude Code CLI および IDE 拡張機能向けに Amazon Bedrock をセットアップする方法について説明します。
+
+> [!NOTE]
+>
+> Claude Desktop アプリの **Code** タブで Amazon Bedrock を使用するには、ユーザー自身または管理者がアプリを設定します。
+>
+> * **組織がアプリをインストールした場合**：管理者に [Amazon Bedrock 向けの設定](https://claude.com/docs/third-party/claude-desktop/bedrock)を依頼してください
+> * **ユーザー自身がアプリをインストールする場合**：[単一マシンのセットアップ手順](https://claude.com/docs/third-party/claude-desktop/installation#single-machine-setup)に従い、[Amazon Bedrock の接続値とモデル値](https://claude.com/docs/third-party/claude-desktop/bedrock#configure-the-app)を入力してください
+
 ## 前提条件
 
```

</details>

<details>
<summary>approvals-github-rules-ja.md</summary>

```diff
diff --git a/docs-ja/pages/approvals-github-rules-ja.md b/docs-ja/pages/approvals-github-rules-ja.md
index 226788a..f76edbe 100644
--- a/docs-ja/pages/approvals-github-rules-ja.md
+++ b/docs-ja/pages/approvals-github-rules-ja.md
@@ -25,5 +25,5 @@ Approvals をオンにしていても、プルリクエストは作成者以外
 * マシンユーザー（スクリプトやエージェントが操作するユーザーアカウント）。これは[人としてカウントされる場合があります](https://code.claude.com/docs/ja/approvals-policy.md#whether-a-pull-request’s-author-counts)
 * プッシュ後もシートを維持する [`reuse`](https://code.claude.com/docs/ja/approvals-policy#reuse)
-* どのルールにも該当しないファイル。この場合、GitHub は neutral の結果を成功としてカウントします
+* どのルールもカバーしないファイル。この場合、GitHub は neutral の結果を成功としてカウントします
 * ルールの `if`、上書きの `if`、または `reuse` 内で[分類器](https://code.claude.com/docs/ja/approvals-classifiers.md)の回答を参照する条件。その回答は[プルリクエストのテキストによって誘導され得る](#classifier-answers-that-a-pull-request-can-steer)ものです
 
```

</details>

<details>
<summary>approvals-ja.md</summary>

```diff
diff --git a/docs-ja/pages/approvals-ja.md b/docs-ja/pages/approvals-ja.md
index 151b9f0..6227c18 100644
--- a/docs-ja/pages/approvals-ja.md
+++ b/docs-ja/pages/approvals-ja.md
@@ -27,5 +27,10 @@ Approvals を使うと、変更を承認する必要がある人数を設定で
 Approvals は、評価するプルリクエストに **Claude Approvals** という名前のチェックを追加します。チェックのタイトルには、まだ何が必要かが示されます（例：**Waiting on human review from any person (1/2)**）。タイトルが **(observe mode)** で始まる場合は、チェックの実行時にポリシーが適用されていなかったことを意味します。[observe モード](#set-up-claude-approvals)では、チェックはポリシーがどのように判定するかを示します。
 
-Claude は理由を記載したコメントも投稿します。ポリシーが許可している場合、Claude は承認レビューを投稿できます。よく表示されるタイトルとそれぞれへの対処方法については、[承認ステータスと次に行うことを確認する](https://code.claude.com/docs/ja/approvals-pull-requests.md#find-your-approval-status-and-what-to-do-next)を参照してください。プルリクエストにチェックがない場合は、[Claude Approvals のチェックが表示されない](https://code.claude.com/docs/ja/approvals-troubleshooting.md#no-claude-approvals-check-appeared)を参照してください。
+Claude は理由を記載したコメントも投稿します。ポリシーが許可している場合、Claude は承認レビューを投稿できます。
+
+* **Claude GitHub App がチェックを報告する github.com のリポジトリの場合**：そのレビューは `claude[bot]` から投稿されます
+* **`claude[bot]` が作成したプルリクエストの場合**：[Claude Approvals GitHub App](https://code.claude.com/docs/ja/approvals-pull-requests.md#pull-requests-that-claude-opens) を追加すると、そのレビューは `claude-approvals[bot]` から投稿されます
+
+よく表示されるタイトルとそれぞれへの対処方法については、[承認ステータスと次に行うことを確認する](https://code.claude.com/docs/ja/approvals-pull-requests.md#find-your-approval-status-and-what-to-do-next)を参照してください。プルリクエストにチェックがない場合は、[Claude Approvals のチェックが表示されない](https://code.claude.com/docs/ja/approvals-troubleshooting.md#no-claude-approvals-check-appeared)を参照してください。
 
 ## ポリシーの例
```

</details>

<details>
<summary>approvals-policy-ja.md</summary>

```diff
diff --git a/docs-ja/pages/approvals-policy-ja.md b/docs-ja/pages/approvals-policy-ja.md
index b10b446..595ab1c 100644
--- a/docs-ja/pages/approvals-policy-ja.md
+++ b/docs-ja/pages/approvals-policy-ja.md
@@ -77,24 +77,29 @@ rules:
 * **一部のカスタム分類器は `advisory` の下にのみ置く**: これは、[`tools`](https://code.claude.com/docs/ja/approvals-classifiers#tools) に `reviewers` または `labels` が含まれる分類器、または `merge` のない[入力](https://code.claude.com/docs/ja/approvals-classifiers.md#inputs)を持つ分類器です。`if` のない適用ルールに記載してください。ルールがその結果を読み取る場合、ディレクトリのポリシーファイル配下のプルリクエストでは、チェックに **Cannot evaluate: classifier outside advisory** と表示されることがあります
 
-## トップレベルのキー
+## ファイル全体のルール
+
+ファイルのすべての部分で次のルールに従ってください。
 
-Approvals は、不明なキーを含むファイルを拒否します。キーと、`observe` や `approves` などの固定語は小文字で記述してください。すべての purpose、パターン、条件、`"!"` 項目はダブルクォートで囲みます。
+* **キーと固定値**: キー、および `observe` や `approves` などの固定値は小文字で記述します。Approvals は未知のキーを含むファイルを拒否します
+* **目的、パターン、条件**: すべての目的、`paths` パターン、条件をダブルクォートで囲みます
+* **`!` 項目**: 条件の外にある各 `"!"` 項目はダブルクォートで囲みます。条件の中では、`!` 項目はシングルクォートで囲みます。Approvals はクォートされていない `!` 項目を含むファイルを拒否します
+* **YAML**: ファイルは 1 つの YAML ドキュメントにまとめてください。そうしないと Approvals はファイルを拒否します。インデントにはスペースを使います。アンカー、エイリアス、`!!` タグは少なくとも警告の対象になります
 
-ファイルは 1 つの YAML ドキュメントにとどめ、各 `!` 項目をクォートし、インデントにはスペースを使用してください。そうしないと Approvals はファイルを拒否します。アンカー、エイリアス、`!!` タグは警告の対象になります。
+## トップレベルのキー
 
-ファイルのトップレベルには次のキーを記述します。
+以下のキーはファイルのトップレベルに記述します。
 
 | キー | 必須 | 値 | デフォルト | 説明 |
 | :- | :- | :- | :- | :- |
-| `version` | はい | `1` | | スキーマのバージョン。裸の数値で記述します |
+| `version` | はい | `1` | | スキーマのバージョン。引用符なしの数値で指定します |
 | `rules` | はい | [ルール](#rule-keys)のリスト | | ルールの順序は関係ありません |
-| `mode` | いいえ | `enforce`、`observe` | `enforce` | `observe` はルールによって何が決まるかを表示し、ファイル内のすべてのルールに適用されます。引き続き neutral にならないチェックや、他のブランチへのプルリクエストについては、[observe モードの Approvals](https://code.claude.com/docs/ja/approvals-pull-requests.md#approvals-in-observe-mode) を参照してください |
```

</details>

*...以降省略*

</details>


<details>
<summary>2026-11-24</summary>

**変更ファイル:**

```
 docs-ja/pages/agent-teams-ja.md                    |   4 +-
 docs-ja/pages/agent-view-ja.md                     |   8 +-
 docs-ja/pages/analytics-ja.md                      |   4 -
 docs-ja/pages/artifacts-ja.md                      |   6 +-
 docs-ja/pages/auto-mode-config-ja.md               |   4 +-
 docs-ja/pages/champion-kit-ja.md                   |   2 +-
 docs-ja/pages/changelog.md                         | 138 +++++++++++++++++++++
 docs-ja/pages/channels-reference-ja.md             |   4 +-
 docs-ja/pages/chrome-ja.md                         |   4 +-
 docs-ja/pages/claude-apps-gateway-config-ja.md     |  16 ++-
 docs-ja/pages/claude-apps-gateway-deploy-ja.md     |  18 +--
 docs-ja/pages/claude-apps-gateway-ja.md            |   8 +-
 docs-ja/pages/claude-apps-gateway-on-gcp-ja.md     |   4 +-
 docs-ja/pages/claude-code-on-the-web-ja.md         |  26 +---
 docs-ja/pages/claude-directory-ja.md               |   2 +-
 docs-ja/pages/claude-projects-ja.md                |  82 ++++++------
 docs-ja/pages/cli-reference-ja.md                  |   2 +-
 docs-ja/pages/cloud-environments-ja.md             |   4 +-
 docs-ja/pages/code-mode-ja.md                      |  19 ++-
 docs-ja/pages/code-review-costs-ja.md              |   4 +-
 docs-ja/pages/code-review-ja.md                    |   2 +-
 docs-ja/pages/code-review-pull-requests-ja.md      |  10 +-
 docs-ja/pages/code-review-setup-ja.md              |  37 ++++--
 docs-ja/pages/code-review-troubleshooting-ja.md    |  11 +-
 docs-ja/pages/commands-ja.md                       |   5 +-
 docs-ja/pages/communications-kit-ja.md             |   2 +-
 docs-ja/pages/costs-ja.md                          |   2 +-
 docs-ja/pages/deep-links-ja.md                     |   2 +-
 docs-ja/pages/desktop-ja.md                        |  16 +--
 docs-ja/pages/desktop-linux-ja.md                  |   6 +-
 docs-ja/pages/desktop-quickstart-ja.md             |   2 +-
 docs-ja/pages/desktop-wsl-ja.md                    |   2 +-
 docs-ja/pages/env-vars-ja.md                       |   6 +-
 docs-ja/pages/errors-ja.md                         |   2 +-
 docs-ja/pages/feature-availability-ja.md           |   4 +
 docs-ja/pages/features-overview-ja.md              |   2 +-
 docs-ja/pages/fullscreen-ja.md                     |   4 +-
 docs-ja/pages/github-enterprise-server-ja.md       |   4 +-
 docs-ja/pages/glossary-ja.md                       |   2 +-
 docs-ja/pages/google-vertex-ai-ja.md               |   8 +-
 docs-ja/pages/headless-ja.md                       |   2 +-
 docs-ja/pages/hooks-guide-ja.md                    |   2 +-
 docs-ja/pages/hooks-ja.md                          |  24 ++--
 docs-ja/pages/how-claude-code-works-ja.md          |   4 +-
 docs-ja/pages/interactive-mode-ja.md               |   6 +-
 docs-ja/pages/large-codebases-ja.md                |   2 +-
 docs-ja/pages/llm-gateway-protocol-ja.md           |   2 +-
 docs-ja/pages/managed-mcp-ja.md                    |   2 +-
 docs-ja/pages/mcp-ja.md                            |   4 +-
 docs-ja/pages/memory-ja.md                         |   2 +-
 docs-ja/pages/microsoft-foundry-ja.md              |   2 +-
 docs-ja/pages/model-config-ja.md                   |  10 +-
 docs-ja/pages/monitoring-usage-ja.md               |  13 +-
 docs-ja/pages/output-styles-ja.md                  |  14 +--
 docs-ja/pages/permission-modes-ja.md               |   8 +-
 docs-ja/pages/permissions-ja.md                    |   2 +-
 docs-ja/pages/prompt-caching-ja.md                 |   2 +-
 docs-ja/pages/remote-control-ja.md                 |  10 +-
 docs-ja/pages/routines-ja.md                       |  10 +-
 docs-ja/pages/security-guidance-ja.md              |   2 +-
 .../self-hosted-environments-configuration-ja.md   |  10 +-
 .../self-hosted-environments-quickstart-ja.md      |   2 +-
 .../pages/self-hosted-environments-reference-ja.md |   4 +-
 docs-ja/pages/server-managed-settings-ja.md        |   2 +-
 docs-ja/pages/settings-ja.md                       |   2 +-
 docs-ja/pages/settings-reference-ja.md             |   8 +-
 docs-ja/pages/setup-ja.md                          |  50 +++++---
 docs-ja/pages/skills-ja.md                         |  15 ++-
 docs-ja/pages/statusline-ja.md                     |  20 ++-
 docs-ja/pages/sub-agents-ja.md                     |  10 +-
 docs-ja/pages/terminal-config-ja.md                |   8 +-
 docs-ja/pages/third-party-integrations-ja.md       |   2 +-
 docs-ja/pages/tools-reference-ja.md                |   2 +-
 docs-ja/pages/troubleshoot-install-ja.md           |   2 +-
 docs-ja/pages/troubleshooting-ja.md                |   4 +-
 docs-ja/pages/vs-code-ja.md                        |   2 +-
 docs-ja/pages/workflows-ja.md                      |  18 ++-
 docs-ja/pages/worktrees-ja.md                      |   4 +-
 78 files changed, 499 insertions(+), 277 deletions(-)
```

**新規追加:**


<details>
<summary>agent-teams-ja.md</summary>

```diff
diff --git a/docs-ja/pages/agent-teams-ja.md b/docs-ja/pages/agent-teams-ja.md
index a832b0b..2744fb8 100644
--- a/docs-ja/pages/agent-teams-ja.md
+++ b/docs-ja/pages/agent-teams-ja.md
@@ -96,5 +96,5 @@ Claude は時々、チームを作成する代わりに [サブエージェン
 エージェントチームは 2 つの表示モードをサポートしています。
 
-* **In-process**：すべてのチームメンバーがメインターミナル内で実行されます。エージェントパネルで上下矢印キーを使用してチームメンバーを選択し、Enter キーを押してそれを表示して、直接メッセージを入力してください。追加のセットアップなしで任意のターミナルで動作します。
+* **In-process**：すべてのチームメンバーがメインターミナル内で実行されます。エージェントパネルで上下矢印キーを使用してチームメンバーを選択し、Enter キーを押してそれを表示して、直接メッセージを入力してください。任意のターミナルで動作します。
 * **分割ペイン**：各チームメンバーが独自のペインを取得します。すべてのユーザーの出力を一度に表示でき、ペインをクリックして直接対話できます。tmux または iTerm2 が必要です。
 
@@ -340,5 +340,5 @@ Claude がすでに実行されていないインプロセスのチームメイ
 **チームメイトが情報を共有する方法:**
 
-* **メッセージの自動配信**: チームメイトがメッセージを送信すると、受信者に自動的に配信されます。リーダーが更新をポーリングする必要はありません。
+* **メッセージの自動配信**: チームメイトがメッセージを送信すると、受信者に自動的に配信されます。
 * **アイドル通知**: チームメイトは作業を終えて停止すると、自動的にリーダーに通知し、その通知に最終的な回答を含めます。API エラーでターンが終了したチームメイトは、失敗したことをリーダーに通知し、エラーテキストを含めます。
 * **共有タスクリスト**: [Task ツールを持つエージェント](https://code.claude.com/docs/ja/tools-reference.md#task-tool-availability)は、タスクのステータスを確認し、引き受け可能な作業を引き受けることができます。
```

</details>

<details>
<summary>agent-view-ja.md</summary>

```diff
diff --git a/docs-ja/pages/agent-view-ja.md b/docs-ja/pages/agent-view-ja.md
index 1ad0c2a..eb8b621 100644
--- a/docs-ja/pages/agent-view-ja.md
+++ b/docs-ja/pages/agent-view-ja.md
@@ -61,5 +61,5 @@ claude agents
 通常の `claude` セッションでは、空のプロンプトで `←` を押すとエージェントビューが開き、フッターの `←` ヒントがバックグラウンドセッションの状況を表示します。
 
-* **ヒント**: セッションが開いてから 10 秒間、フッターに `← for agents` が表示されます。ヒントが消えた後も `←` を押すと機能します
+* **ヒント**: セッションが開いてから 10 秒間、フッターに `← for agents` が表示されます
 * **待機中の数**: バックグラウンドセッションが入力を待機している間、同じ位置にその数が `← 2 agents` のように表示されます。99 を超える場合は `← 99+ agents` と表示されます。カウントはターミナルがフォーカスされている間は約 10 秒ごとに更新され、フォーカスが戻ると即座に更新されます
 * **完了数**: 入力を待機しているセッションがない状態でバックグラウンドセッションが正常に完了すると、フッターに完了した数が一時的に表示されます。たとえば 2 つの場合は `← 2 done` と表示されます
@@ -840,5 +840,5 @@ Claude Code は、エージェントビューに一覧表示されるすべて
 ### スーパーバイザープロセス
 
-スーパーバイザーは、エージェントビューやターミナルを閉じた後もバックグラウンドセッションが動作し続けるよう、それらを実行するバックグラウンドサービスです。Claude Code は、初めてセッションをバックグラウンドに送るかエージェントビューを開いたときにスーパーバイザーを起動するため、自分で管理する必要はありません。
+スーパーバイザーは、エージェントビューやターミナルを閉じた後もバックグラウンドセッションが動作し続けるよう、それらを実行するバックグラウンドサービスです。Claude Code は、初めてセッションをバックグラウンドに送るかエージェントビューを開いたときにスーパーバイザーを起動します。
 
 各セッションはスーパーバイザー配下の個別の Claude Code プロセスであり、そのプロセスがどうなるかはセッションの状態によって異なります。
@@ -913,5 +913,5 @@ Background sessions still running will stop in about a minute. Run 'claude agent
 この通知は、このセッションで実行されていないバックグラウンドの[サブエージェント](https://code.claude.com/docs/ja/sub-agents.md)を示しています。
 
-Claude はこの通知を確認して自動的に返信するため、プロンプトを入力する必要はありません。Claude の返信を読んだ後もそのサブエージェントの作業が必要な場合は、Claude に依頼してください。
+Claude はこの通知を確認して自動的に返信します。Claude の返信を読んだ後もそのサブエージェントの作業が必要な場合は、Claude に依頼してください。
 
 ### プロンプトが短すぎるとして拒否される
@@ -930,5 +930,5 @@ Claude はこの通知を確認して自動的に返信するため、プロン
 [トランスクリプトクリーンアップ](https://code.claude.com/docs/ja/settings-reference.md#cleanupperioddays)が停止したセッションの保存された会話を削除した場合、Claude Code は行を開くことを拒否します。メッセージは再開するものがないことを示しています。`claude rm <id>` は行を削除し（ただし [Claude Code が拒否する](#what-deleting-a-session-removes)場合を除きます）、`claude respawn <id>` は元のプロンプトを再度実行します。[このセッションの保存された会話はディスク上にもはやありません](https://code.claude.com/docs/ja/errors.md#this-sessions-saved-conversation-is-no-longer-on-disk)を参照してください。
 
-スリープだけではセッションを停止しません。セッションはスリープ全体で保持され、スーパーバイザーはウェイク時にそれらに再接続します。
+セッションはスリープ中も保持され、スーパーバイザーはウェイク時にそれらに再接続します。
```

</details>

<details>
<summary>analytics-ja.md</summary>

```diff
diff --git a/docs-ja/pages/analytics-ja.md b/docs-ja/pages/analytics-ja.md
index fdcd4dd..ae17aea 100644
--- a/docs-ja/pages/analytics-ja.md
+++ b/docs-ja/pages/analytics-ja.md
@@ -119,6 +119,4 @@ GitHub 認証フローを完了し、分析に含める GitHub 組織を選択
 比較前に、行は正規化されます。空白がトリミングされ、複数のスペースが折りたたまれ、引用符が標準化され、テキストが小文字に変換されます。
 
-Claude Code 支援行を含むマージされたプルリクエストは、GitHub で `claude-code-assisted` としてラベル付けされます。
-
 #### 時間ウィンドウ
 
@@ -175,6 +173,4 @@ PR マージ日の 21 日前から 2 日後のセッションが属性マッチ
 Enterprise プランでは、[Claude Enterprise Analytics API](https://platform.claude.com/docs/en/api/admin/analytics) は、Claude Code を含む Claude サーフェス全体で、組織のユーザーごとのエンゲージメント、使用状況、コストレポートを返します。プライマリオーナーが [claude.ai/analytics/api-keys](https://claude.ai/analytics/api-keys) で `read:analytics` スコープを持つキーを作成します。API は Teams プランでは利用できません。
 
-GitHub を通じてこのデータをクエリするには、`claude-code-assisted` でラベル付けされた PR を検索します。
-
 ## API カスタマー向けの分析にアクセスする
 
```

</details>

<details>
<summary>artifacts-ja.md</summary>

```diff
diff --git a/docs-ja/pages/artifacts-ja.md b/docs-ja/pages/artifacts-ja.md
index d1cb0fe..744130e 100644
--- a/docs-ja/pages/artifacts-ja.md
+++ b/docs-ja/pages/artifacts-ja.md
@@ -79,13 +79,11 @@ Claude にページを修正するよう依頼するか、長時間実行され
 
 ```text wrap theme={null}
-概要チャートの下に地域別の内訳を追加して再度公開します。
+Add a per-region breakdown below the summary chart and republish.
 ```
 
-ページを開いているすべてのユーザーは、その場で更新を確認できます。公開するたびにバージョンになり、ページヘッダーの **Share** コントロールから、ビューアーに表示するバージョンを選択できます。
-
 別のセッションからアーティファクトを更新するには、Claude にその URL を指定するか、[`/artifacts`](#find-an-artifact-again) で添付します。どちらもない場合、新しいセッションは既存のアーティファクトを更新する代わりに、新しいアーティファクトを作成します。
 
 ```text wrap theme={null}
-https://claude.ai/code/artifact/5fbea6f3-... を本日の数値で更新します。
+Update https://claude.ai/code/artifact/5fbea6f3-... with today's numbers.
 ```
 
```

</details>

<details>
<summary>auto-mode-config-ja.md</summary>

```diff
diff --git a/docs-ja/pages/auto-mode-config-ja.md b/docs-ja/pages/auto-mode-config-ja.md
index c571163..62837ec 100644
--- a/docs-ja/pages/auto-mode-config-ja.md
+++ b/docs-ja/pages/auto-mode-config-ja.md
@@ -7,5 +7,5 @@
 > auto モード分類器に、組織が信頼するリポジトリ、バケット、ドメインを指定し、独自のブロックルールと許可ルールを設定して、設定内容を確認します。
 
-[オートモード](https://code.claude.com/docs/ja/permission-modes.md#eliminate-prompts-with-auto-mode)を使用すると、Claude Code は、ツール呼び出しを分類器にルーティングして、不可逆的、破壊的、または環境外を対象とした操作をブロックすることで、定期的な権限プロンプトなしで実行できます。拒否および明示的な質問ルールは分類器の前に評価され、引き続きブロックまたはプロンプトを表示します。`autoMode` 設定ブロックを使用して、その分類器に組織が信頼するリポジトリ、バケット、ドメインを指定し、定期的な内部操作のブロックを停止させます。
+[auto モード](https://code.claude.com/docs/ja/permission-modes.md#eliminate-prompts-with-auto-mode)を使用すると、Claude Code は、ツール呼び出しを分類器にルーティングして、不可逆的、破壊的、または環境外を対象としていると判断した操作をブロックすることで、日常的な権限プロンプトなしで実行できます。`autoMode` 設定ブロックを使用して、その分類器に組織が信頼するリポジトリ、バケット、ドメインを指定し、日常的な内部操作のブロックを停止させます。
 
 > [!NOTE]
@@ -56,5 +56,5 @@ Claude のプッシュおよびプルリクエストコマンドの前に人間
 | アクション前にプロンプト表示 | `permissions.ask` | デフォルトでは、上記のレシピのようなコンテンツスコープのルールに一致するコマンドに対してプロンプトを表示します。分類器は一致するアクションを自動承認できません。 |
 | アクションを実行しない | `permissions.deny` | 分類器が参照される前にブロックします。分類器もユーザーの意図も、これをオーバーライドできません。 |
-| このセッション限定の境界 | 「レビューするまでプッシュしない」のように会話で述べる | 分類器は一致するアクションをブロックしますが、[コンテキストコンパクション](https://code.claude.com/docs/ja/costs.md#reduce-token-usage)がそのステートメントを含むメッセージを削除すると、境界が失われる可能性があります。永続的な保証のために ask ルールまたは deny ルールを使用してください。 |
+| このセッション限定の境界 | 「レビューするまでプッシュしない」のように会話で述べる | 分類器は、自身がレビューするアクションのうち一致するものをブロックしますが、境界を述べたメッセージが[コンテキスト圧縮](https://code.claude.com/docs/ja/costs.md#reduce-token-usage)によって削除されると、境界が失われる可能性があります。境界が失われないようにするには、代わりに確認ルールまたは拒否ルールを使用してください。 |
 
 ## 分類器が設定を読み込む場所
```

</details>

<details>
<summary>champion-kit-ja.md</summary>

```diff
diff --git a/docs-ja/pages/champion-kit-ja.md b/docs-ja/pages/champion-kit-ja.md
index a1960a7..ba00f2c 100644
--- a/docs-ja/pages/champion-kit-ja.md
+++ b/docs-ja/pages/champion-kit-ja.md
@@ -124,5 +124,5 @@ plan モードがあるからこそ、重要なコードでも安心してこれ
 | 専用チャネル | `#claude-code` チャネルを作成し（または既存のチャネルで定期的なスレッド）、[Quickstart](https://code.claude.com/docs/ja/quickstart.md) リンクと 1 つの強い例をピンで留め、公開で質問に答えて、各答えがすべての視聴者に利益をもたらすようにします。 | セットアップに約 5 分、その後は環境 |
 | 週次のショーアンドテルスレッド | 毎週金曜日に「Claude は今週何を手伝いましたか？」と投稿します。準備、スライド、またはミーティングは不要です。スクリーンショットと短い説明で十分です。 | 週あたり約 2 分 |
-| カスタムスキルを共有する | 最も有用な `.claude/skills/<name>/SKILL.md` ファイルを投稿します。例えば、コミット前にテストと lint を実行する `/ship` スキルと、1 行の説明。スキルはプレーン Markdown であるため、同僚はすぐに採用できます。 | スキルあたり約 5 分 |
+| カスタムスキルを共有する | 最も有用な `.claude/skills/<name>/SKILL.md` ファイルを 1 行の説明とともに投稿します。例えば、コミット前にテストと lint を実行する `/precommit` スキルなどです。スキルはプレーン Markdown であるため、同僚はすぐに採用できます。 | スキルあたり約 5 分 |
 | 自分の使用からセットアップガイドを生成する | 実際の時間を費やしたプロジェクトで `/team-onboarding` を実行します。Claude は最近のセッション、コマンド、MCP サーバーをスキャンし、新しいチームメイトが最初のメッセージとして貼り付けてセットアップを再生できるガイドを生成します。チャネルにピンで留めます。 | 約 2 分 |
 | 最初のタスクでペアリング | 開始している誰かに 1 つの 15 分間のペアリングセッションを提供します。自分のコードでの 1 つの成功した結果は、どのプレゼンテーションよりも説得力があります。 | 1 人あたり約 15 分 |
```

</details>

<details>
<summary>changelog.md</summary>

```diff
diff --git a/docs-ja/pages/changelog.md b/docs-ja/pages/changelog.md
index 169c78c..401835b 100644
--- a/docs-ja/pages/changelog.md
+++ b/docs-ja/pages/changelog.md
@@ -1,4 +1,142 @@
 # Changelog
 
+## 2.1.331
+
+- Added Code Mode support in terminal sessions on Amazon Bedrock, Google Cloud's Agent Platform, Microsoft Foundry and Claude Platform on AWS
+- Added `oidc.groups_jsonpath` to the Claude apps gateway, to read groups from the matching entries of a list of objects with a small subset of JSONPath (RFC 9535)
+- Added an API connectivity section to `claude doctor` that reports whether the API can be reached, with the HTTP status or the error, or says why it wasn't tested
+- Added a notice when tap-mode voice dictation stops by itself, after 15 seconds without recognized speech or at its 2-minute limit
+- Added `CLAUDE_CODE_DISABLE_RESPONSE_COMPRESSION` to ask for uncompressed model responses behind a proxy that cuts compressed ones off; not advised yet for self-hosted runners or Remote Control
+- Added `CLAUDE_GATEWAY_IDP_CONNECT_BY_HOSTNAME=1` for Claude apps gateways: with `oidc.use_proxy: true`, sign-in requests hand the proxy an `https` IdP's hostname even with `NO_PROXY` set
+- Added `gen_ai.usage.*`, `gen_ai.response.model` and `gen_ai.operation.name` to `claude_code.llm_request` trace spans; `gen_ai.usage.input_tokens` includes prompt cache tokens
+- Added `optionalDependencies` to plugin manifests: plugins that install with the plugin listing them and can be disabled or uninstalled on their own
+- Fixed MCP tool calls hanging for up to 30 minutes on some malformed replies from a local or WebSocket server
+- Fixed PushNotification telling a headless run, such as a scheduled one, that the terminal was active in its first minute, instead of saying whether a mobile push was requested
+- Fixed `/install-github-app` skipping the repository step after setup warnings when no repository was found, and Esc not going back from its workflow list and sign-in steps
+- Fixed one-line tool results cut with no ellipsis in narrow windows, Markdown stars in the Auto mode tab of /permissions, and a hook's reason to stop a forked skill showing twice
+- Fixed `/diff` hiding its key hints and not selecting files in windows of 24 to 26 rows, and leaving out files added with `git add -N` in a repository with no commits
+- Fixed the first-run theme list showing too few themes in short windows, and /usage and other tall screens coming out garbled there
+- Fixed `/bug` in fullscreen hiding its Yes and No answers behind a long report, and Yes staying out of view in very short windows
+- Fixed /compact and auto-compact sometimes losing part of the conversation summary when the summary quoted certain XML tags
+- Fixed Claude not being told when permission rules on the Agent tool dropped its queued message to a subagent that had already ended
+- Fixed a Remote Control message sometimes showing above the reply that was finishing when it was sent
+- Fixed Stop hooks that read the transcript missing the last reply in Claude Desktop; SubagentStop hooks now wait for it too
+- Fixed turns and subagents failing in cloud sessions, or timing out on long replies elsewhere, when a reply went silent while Claude was still thinking; Claude Code now tries the request once more
+- Fixed Esc and Stop waiting about a minute or more when the contents of a cloud or network file that Claude is reading stall
```

</details>

<details>
<summary>channels-reference-ja.md</summary>

```diff
diff --git a/docs-ja/pages/channels-reference-ja.md b/docs-ja/pages/channels-reference-ja.md
index e2569ad..3b32410 100644
--- a/docs-ja/pages/channels-reference-ja.md
+++ b/docs-ja/pages/channels-reference-ja.md
@@ -39,5 +39,5 @@
 ## 必要なもの
 
-唯一のハード要件は、[`@modelcontextprotocol/sdk`](https://www.npmjs.com/package/@modelcontextprotocol/sdk) パッケージと Node.js 互換ランタイムです。[Bun](https://bun.sh)、[Node](https://nodejs.org)、[Deno](https://deno.com) すべて動作します。リサーチプレビューの事前構築プラグインは Bun を使用していますが、チャネルはそうである必要はありません。
+唯一のハード要件は、[`@modelcontextprotocol/sdk`](https://www.npmjs.com/package/@modelcontextprotocol/sdk) パッケージと Node.js 互換ランタイムです。[Bun](https://bun.sh)、[Node](https://nodejs.org)、[Deno](https://deno.com) すべて動作します。
 
 サーバーは以下を実行する必要があります：
@@ -256,5 +256,5 @@ Claude Code は通知を確認しません。`mcp.notification()` の `await` 
 ## 返信ツールを公開
 
-チャネルが双方向の場合、アラートフォワーダーではなくチャットブリッジのような場合、Claude がメッセージを返送するために呼び出せる標準 [MCP ツール](https://modelcontextprotocol.io/docs/concepts/tools)を公開します。ツール登録に関するチャネル固有のものはありません。返信ツールには 3 つのコンポーネントがあります：
+チャネルが双方向の場合、アラートフォワーダーではなくチャットブリッジのような場合、Claude がメッセージを返送するために呼び出せる標準 [MCP ツール](https://modelcontextprotocol.io/docs/concepts/tools)を公開します。返信ツールには 3 つのコンポーネントがあります：
 
 1. `Server` コンストラクタ機能に `tools: {}` エントリがあり、Claude Code がツールを検出できるようにする
```

</details>

*...以降省略*

</details>


<details>
<summary>2026-11-23</summary>

**変更ファイル:**

```
 docs-ja/pages/agent-view-ja.md         |  8 +++-----
 docs-ja/pages/chrome-ja.md             |  2 +-
 docs-ja/pages/claude-projects-ja.md    | 21 ++++++++++-----------
 docs-ja/pages/cloud-environments-ja.md |  2 +-
 docs-ja/pages/commands-ja.md           |  2 +-
 docs-ja/pages/costs-ja.md              |  8 ++++----
 docs-ja/pages/desktop-ja.md            | 14 +++++++++-----
 docs-ja/pages/env-vars-ja.md           |  1 +
 docs-ja/pages/errors-ja.md             |  6 +++---
 docs-ja/pages/hooks-ja.md              |  5 +++--
 docs-ja/pages/mcp-ja.md                |  2 +-
 docs-ja/pages/network-config-ja.md     |  2 +-
 docs-ja/pages/permission-modes-ja.md   |  3 ++-
 docs-ja/pages/security-guidance-ja.md  |  2 +-
 docs-ja/pages/sessions-ja.md           |  2 +-
 docs-ja/pages/settings-ja.md           |  4 ++--
 docs-ja/pages/skills-ja.md             |  2 +-
 docs-ja/pages/statusline-ja.md         |  2 +-
 docs-ja/pages/terminal-config-ja.md    |  2 +-
 docs-ja/pages/tools-reference-ja.md    |  2 +-
 20 files changed, 48 insertions(+), 44 deletions(-)
```

<details>
<summary>agent-view-ja.md</summary>

```diff
diff --git a/docs-ja/pages/agent-view-ja.md b/docs-ja/pages/agent-view-ja.md
index 91d6872..1ad0c2a 100644
--- a/docs-ja/pages/agent-view-ja.md
+++ b/docs-ja/pages/agent-view-ja.md
@@ -987,7 +987,7 @@ claude daemon stop --any --keep-workers
 | `supervisor (pid=<pid>) is still running` | Windows | `taskkill /PID <pid>` でプロセスを終了します |
 
-### ディスパッチが `Could not resolve authentication method` で失敗する
+### バックグラウンドセッションに `Not logged in` と表示される
 
-バックグラウンドディスパッチが `Could not resolve authentication method` で失敗し、インタラクティブセッションが正常に認証される場合、ディスパッチを受け取ったワーカーは認証情報を取得しませんでした。バックグラウンドセッションは[スーパーバイザー](#the-supervisor-process)から認証情報を取得するため、このエラーはスーパーバイザープロセス自体で利用可能な保存された認証情報がないことを意味します。`/login` を実行したか、API キーを設定したことを確認してから、スーパーバイザーを停止してください：
+インタラクティブセッションは正常に認証されるのに、バックグラウンドセッションに [`Not logged in`](https://code.claude.com/docs/ja/errors#not-logged-in) と表示される場合は、`/login` を実行したか API キーを設定したことを確認してから、[スーパーバイザー](#the-supervisor-process)を停止してください：
 
 ```bash theme={null}
@@ -995,7 +995,5 @@ claude daemon stop --any --keep-workers
 ```
 
-[約 1 分](#the-supervisor-process)以内に、シェルで `claude agents` または `claude --bg` を実行して、保存された認証情報を読み取る新しいスーパーバイザーを開始します。`/login` ではなく `ANTHROPIC_API_KEY` などの環境変数で認証する場合は、変数が設定されているシェルからその次のコマンドを実行してください。
-
-原因と修正の完全なリストについては、[エラーリファレンス](https://code.claude.com/docs/ja/errors.md#could-not-resolve-authentication-method)を参照してください。
+停止してから[約 1 分](#the-supervisor-process)以内に、シェルで `claude agents` を実行して新しいスーパーバイザーを開始します。`CLAUDE_CODE_OAUTH_TOKEN` などの環境変数で認証する場合は、その変数が設定されているシェルから `claude agents` を実行してください。その後、[`claude respawn <id>`](#manage-sessions-from-the-shell) を実行してセッションを再起動し、メッセージを再送信します。
 
 ### バックグラウンドセッションに `No LLM gateway` と表示される
```

</details>

<details>
<summary>chrome-ja.md</summary>

```diff
diff --git a/docs-ja/pages/chrome-ja.md b/docs-ja/pages/chrome-ja.md
index f0aac8e..c0e7554 100644
--- a/docs-ja/pages/chrome-ja.md
+++ b/docs-ja/pages/chrome-ja.md
@@ -79,5 +79,5 @@ type "hooks", and tell me what results appear
 ブラウザアクションの前に Claude Code が権限を求めた場合は、承認してください。ダイアログは `Claude in Chrome wants to` で始まり、そのサイトでのすべてのアクションをセッション中許可するオプションが表示されます。Claude は新しいタブを開いてタスクを開始します。
 
-いつでも `/chrome` を実行して、接続ステータスの確認、権限の管理、拡張機能の再接続、または使用する接続済みブラウザの選択を行えます。ステータスパネルに「ステータス: 有効」と「拡張機能: インストール済み」が表示されていれば、統合は正常に動作しています。
+いつでも `/chrome` を実行して、接続ステータスの確認、権限の管理、拡張機能の再接続、または使用する接続済みブラウザの選択を行えます。
 
 複数のブラウザが接続されている場合は、Claude が使用するブラウザを選択します。選択する前にブラウザアクションが開始されると、Claude はいずれかを選択するよう促します。後でブラウザを切り替えるには、`/chrome` を実行して別のブラウザを選択します。別のブラウザが接続された場合でも、Claude は選択したブラウザを使い続けます。
```

</details>

<details>
<summary>claude-projects-ja.md</summary>

```diff
diff --git a/docs-ja/pages/claude-projects-ja.md b/docs-ja/pages/claude-projects-ja.md
index 6ba9885..adb064d 100644
--- a/docs-ja/pages/claude-projects-ja.md
+++ b/docs-ja/pages/claude-projects-ja.md
@@ -31,5 +31,5 @@
 * **多くのリポジトリにまたがる 1 つの目標**: 「すべてのサービスを新しい lint 設定に対応させる」。Claude はリポジトリごとに 1 つのスレッドを実行でき、各スレッドは独自のプルリクエストを持ち、[Overview ペイン](#see-what-needs-you-in-overview) にはどのスレッドがレビュー準備ができているかが表示されます。
 * **継続的に供給する領域**: 1 つのサービスのバグ、スタックトレース、レビューリクエストが到達するたびに会話に貼り付けられます。1 つの修正後に Claude に覚えておくよう指示した落とし穴は、次のために [プロジェクトメモリ](#give-a-project-standing-context) に含まれます。
-* **セッションより大きいビルドまたはマイグレーション**: 「`docs/spec.md` が説明していることをビルドする」または「アプリを非推奨の ORM から移動する」。作業は各部分を取得するスレッドに分割され、Claude に早期に覚えておくよう求めた決定は後のスレッドに到達し、ビルド中に見つかった仕様の変更とバグが同じ会話に入ります。
+* **セッションより大きいビルドまたはマイグレーション**: 「`docs/spec.md` が説明していることをビルドする」または「アプリを非推奨の ORM から移動する」。作業は各部分を取得するスレッドに分割され、Claude に早期に覚えておくよう求めた決定は後のクラウドスレッドに到達し、ビルド中に見つかった仕様の変更とバグが同じ会話に入ります。
 * **コードではない作業**: 「これらのチケットで最も一般的な 10 の統合ミスを見つける」など、新しい質問で何度も戻ってくる契約フォルダまたはサポートチケットエクスポート。リポジトリを追加する代わりにドキュメントをアップロードし、スレッドはプロジェクトの [**Library**](#see-what-needs-you-in-overview) にファイルとして各レポートを配信します。
 
@@ -80,5 +80,5 @@
 
 * **プラン**：Pro、Max、または Ultra プランを利用しており、サイドバーに **Projects** が直接または **More** の下に表示されている。**Projects** を選択し、**New project** または **Get started** が表示されることを確認してください。
-* **GitHub（プロジェクトがコードで作業する場合）**：コードが GitHub Enterprise Server、GitLab、または Bitbucket ではなく github.com にあり、接続された GitHub アカウントがそれへのプッシュアクセス権を持っており、Claude GitHub App がインストールされている。[`/web-setup`](https://code.claude.com/docs/ja/web-quickstart#connect-from-your-terminal)で GitHub を接続した場合、そのトークンは他のクラウドセッションがリポジトリに到達することを許可しますが、Claude GitHub App が必要なプロジェクトスレッドには十分ではありません。[GitHub アクセスをセットアップする](#set-up-github-access)に手順があります。
+* **GitHub（プロジェクトがコードで作業する場合）**：コードが GitHub Enterprise Server、GitLab、または Bitbucket ではなく github.com にあり、接続された GitHub アカウントがそれへのプッシュアクセス権を持っており、Claude GitHub App がインストールされている。[`/web-setup`](https://code.claude.com/docs/ja/web-quickstart#connect-from-your-terminal)で GitHub を接続した場合、そのトークンは他のクラウドセッションがリポジトリに到達することを許可しますが、Claude GitHub App が必要なプロジェクトのクラウドスレッドには十分ではありません。[GitHub アクセスをセットアップする](#set-up-github-access)に手順があります。
 * **ネットワークアクセス、シークレット、ツール**：クラウドスレッドの場合、これらはプロジェクトの [クラウド環境](#choose-an-environment-for-threads)から取得されます。デフォルト環境は既に [一般的なパッケージレジストリ](https://code.claude.com/docs/ja/cloud-environments.md#default-allowed-domains)に到達しているため、作業が他のドメイン、シークレット、またはプリインストールされていないツールを必要とする場合のみ確認してください。作業が MCP サーバーを必要とする場合は、[claude.ai connectors](https://claude.ai/customize/connectors)で接続済みとして表示されていることを確認してください。
 
@@ -236,5 +236,5 @@ Claude がメッセージを希望と異なる方法でルーティングした
 * 「スレッドを開始せずに、ここで答えて」（ユーザーがちょっとした質問のつもりで送ったものに対して Claude がスレッドを開始した場合）
 
-Claude はこのような設定を[プロジェクトメモリ](#give-a-project-standing-context)に自動的に保存し、後のスレッドでそれに従います。これらは Claude が守る指示であり、強制される設定ではないため、この方法で与えるスレッド制限はハードキャップではありません。最初からすべてのスレッドに正確に適用したい場合は、プロジェクト指示に 1 つを追加します。
+Claude はこのような設定を[プロジェクトメモリ](#give-a-project-standing-context)に自動的に保存し、後のクラウドスレッドでそれに従います。これらは Claude が守る指示であり、強制される設定ではないため、この方法で与えるスレッド制限はハードキャップではありません。正確な文言で記述し、最初からすべてのスレッドに適用したい場合は、プロジェクト指示に 1 つを追加します。
 
 ### 承認を待機しているスレッドのブロックを解除する
@@ -280,5 +280,5 @@ Claude は**コンピューター上のフォルダーで作業することを C
 ## プロジェクトに常時コンテキストを付与する
 
-プロジェクトメモリ、プロジェクト指示、およびプロジェクトのリポジトリ、ファイル、環境は、スレッド全体でコンテキストを保持します。各項目を 1 回設定すると、すべての新しいスレッドに適用されます。
+プロジェクトメモリ、プロジェクト指示、そしてプロジェクトのリポジトリ、ファイル、環境は、スレッドをまたいでコンテキストを引き継ぎます。それぞれの設定は一度だけで済みます。
```

</details>

<details>
<summary>cloud-environments-ja.md</summary>

```diff
diff --git a/docs-ja/pages/cloud-environments-ja.md b/docs-ja/pages/cloud-environments-ja.md
index 9668c98..679f468 100644
--- a/docs-ja/pages/cloud-environments-ja.md
+++ b/docs-ja/pages/cloud-environments-ja.md
@@ -292,5 +292,5 @@ Anthropic ホスト環境では、各セッションは独自のオペレーテ
 | リポジトリの `.claude/rules/` | はい | クローンの一部 |
 | リポジトリの `.claude/skills/`、`.claude/agents/`、`.claude/commands/` | はい | クローンの一部 |
-| リポジトリの `.claude/settings.json` で宣言されたプラグインとマーケットプレイス | いいえ | クラウドセッションは、リポジトリが [`enabledPlugins`](https://code.claude.com/docs/ja/settings-reference#enabledplugins) で有効にするプラグインをインストールしません。これには [`extraKnownMarketplaces`](https://code.claude.com/docs/ja/settings-reference#extraknownmarketplaces) の下にリストされているマーケットプレイスのプラグインも含まれます |
+| リポジトリの `.claude/settings.json` で宣言されたマーケットプレイス | いいえ、Anthropic ホスト環境の場合 | セッションは、リポジトリが [`extraKnownMarketplaces`](https://code.claude.com/docs/ja/settings-reference#extraknownmarketplaces) の下にリストしているマーケットプレイスを追加しません。セルフホスト環境については、[どのリポジトリの設定が適用されるか](https://code.claude.com/docs/ja/self-hosted-environments-configuration.md#repository-settings-in-sessions-with-several-repositories)を参照してください |
 | 組織の[サーバー管理設定](https://code.claude.com/docs/ja/server-managed-settings.md) | はい、[Claude Tag](https://claude.com/docs/claude-tag/overview) セッションを除く | セッション開始時に Anthropic のサーバーから取得されます。クラウドセッションで `availableModels` がどのように適用されるかについては、[Surface coverage](https://code.claude.com/docs/ja/model-config.md#surface-coverage) を参照してください。MDM または管理設定ファイルを通じてデバイスにデプロイされた設定は適用されません。セッションは Anthropic 管理 VM で実行されるためです。[セルフホスト環境](https://code.claude.com/docs/ja/self-hosted-environments)では、セッションはランナーイメージの管理設定ファイルも読み取ります。[Claude Code が管理ソースを組み合わせる方法](https://code.claude.com/docs/ja/managed-settings.md#how-claude-code-combines-managed-sources)に従います |
 | ユーザー `~/.claude/CLAUDE.md` | いいえ | マシンに存在し、リポジトリには存在しません。[リポジトリにコミットせずに個人設定を追加する](#add-personal-preferences-without-committing-to-the-repo)を参照してください |
```

</details>

<details>
<summary>commands-ja.md</summary>

```diff
diff --git a/docs-ja/pages/commands-ja.md b/docs-ja/pages/commands-ja.md
index 6448826..b6a9418 100644
--- a/docs-ja/pages/commands-ja.md
+++ b/docs-ja/pages/commands-ja.md
@@ -86,5 +86,5 @@ Claude が応答中にコマンドを送信した場合、Claude Code はそれ
 | `/effort [level\|auto\|status\|ultracode [on\|off]]` | [effort レベル](https://code.claude.com/docs/ja/model-config.md#adjust-effort-level)を設定します：`low` から `xhigh`、`max`、または `auto`。`status` はそれを出力します。`ultracode` または `ultracode on` はセッションで [ultracode](https://code.claude.com/docs/ja/workflows.md#let-claude-decide-with-ultracode) をオンにし、`ultracode off` はそれをオフにします。[`ultracode`](https://code.claude.com/docs/ja/settings-reference#ultracode) キーは永続化されます。`max` はセッションのみです。`on` および `off` 引数には Claude Code v2.1.284 以降が必要です。Claude が作業している間に `/effort` を実行する場合は、[新しいレベルが適用されるタイミング](https://code.claude.com/docs/ja/model-config.md#when-a-new-effort-level-starts)を参照してください。v2.1.205 以降では `-p` で機能します |
 | `/exit` | CLI を終了します。アタッチされた[バックグラウンドセッション](https://code.claude.com/docs/ja/agent-view.md#attach-to-a-session)では、これはデタッチし、セッションは実行し続けます。エイリアス：`/quit` |
-| `/export [filename]` | 現在の会話をプレーンテキストとしてエクスポートします。ファイル名を指定すると、そのファイルに直接書き込みます。指定しない場合、クリップボードにコピーするか、ファイルに保存するためのダイアログが開きます |
+| `/export [filename]` | 現在の会話をプレーンテキストとしてエクスポートします。ファイル名を指定すると、そのファイルに直接書き込みます。v2.1.327 以降では、すでに存在するファイルは拒否します。指定しない場合、クリップボードにコピーするか、ファイルに保存するためのダイアログが開きます |
 | `/fast [on\|off]` | [fast mode](https://code.claude.com/docs/ja/fast-mode.md) をオンまたはオフに切り替えます。Claude が応答している間に実行すると、Claude Code はターンの終了を待たずに fast mode を切り替えます。ただし、実行中のターンは元の速度で終了します。v2.1.242 より前は、Claude Code は Anthropic から取得したフィーチャーフラグからコマンドをミッドターンで実行するか、ターンが終了するまでキューに入れるかを決定し、[フィーチャーフラグをフェッチしない](https://code.claude.com/docs/ja/env-vars.md#features-that-need-feature-flag-fetching)セッションでは常にキューに入れていました。`-p` を使用した非対話モードでの可用性は限定的です。[fast mode を切り替える](https://code.claude.com/docs/ja/fast-mode.md#toggle-fast-mode)を参照してください |
 | `/feedback [report]` | Claude Code に関する製品フィードバックを送信します。[`/bug`](#all-commands) と同じダイアログを開き、同じ同意ステップ、送信ルール、ミッドターン動作があります。[Claude がドラフトしたフィードバック](https://code.claude.com/docs/ja/tools-reference.md#sendfeedback-tool-behavior)を含むセッションでは、引数なしで `/feedback` を実行するとドラフトキューが代わりに開き、Claude がキューに入れたドラフトを確認、編集、送信、または破棄できます。キューには新しいレポートをダイアログで書き込むオプションが含まれます。引数を指定した場合、および `/bug` の場合は常に、ダイアログが直接開きます |
```

</details>

<details>
<summary>costs-ja.md</summary>

```diff
diff --git a/docs-ja/pages/costs-ja.md b/docs-ja/pages/costs-ja.md
index 2e75a51..9df95b9 100644
--- a/docs-ja/pages/costs-ja.md
+++ b/docs-ja/pages/costs-ja.md
@@ -23,8 +23,8 @@ Claude Code は API トークン消費によって課金されます。サブス
 Claude Code のプロンプトで `/usage` を実行し、**Session** 見出しの下で現在のセッションのトークン使用量を確認します。
 
-Claude Code は、[`modelPricing`](https://code.claude.com/docs/ja/settings-reference#modelpricing) テーブルが有効でない限り、トークン数から定価に基づいてドル数値をローカルで計算します。管理者は組織の管理設定でこのテーブルを設定し、数値が契約レートを使用するようにします。テーブルが有効な間、`Total cost` 行には `at your organization's configured rates` という注記が付きます。この数値は推定値であるため、正式な請求情報については [組織のコストを管理する](#manage-costs-for-your-organization) を参照してください。
+Claude Code は、[`modelPricing`](https://code.claude.com/docs/ja/settings-reference#modelpricing) テーブルが有効でない限り、トークン数から定価に基づいてドル数値をローカルで計算します。管理者は組織の管理設定でこのテーブルを設定し、数値が契約レートを使用するようにします。テーブルが有効な間、`Estimated cost` 行には `at your organization's configured rates` という注記が付きます。この数値は推定値であるため、正式な請求情報については [組織のコストを管理する](#manage-costs-for-your-organization) を参照してください。
 
 ```text theme={null}
-Total cost:            $0.55
+Estimated cost:        $0.55
 Total duration (API):  6m 20s
 Total duration (wall): 6h 33m 10s
@@ -175,5 +175,5 @@ Claude Code にアクセスする方法によって、利用可能なコント
 [マネージド設定](https://code.claude.com/docs/ja/managed-settings.md) として配信してください。サーバー管理設定、MDM ポリシー、`managed-settings.json`、または [ポリシーヘルパー](https://code.claude.com/docs/ja/managed-settings.md#compute-the-policy-with-a-helper-program)。Claude Code はユーザー、プロジェクト、ローカル設定、および `--settings` のキーを無視します。
 
-レートが有効であることを確認するには、[マネージド設定を受け取った](https://code.claude.com/docs/ja/managed-settings.md#read-the-source-in-%2Fstatus) セッションで `/usage` を実行してください。Session ブロックの `Total cost` 行には `at your organization's configured rates` という注記が付きます。数値はまだ推定値であり、請求書ではありません。`/model` ピッカーのトークンあたり百万単位の価格は定価のままです。
+レートが有効であることを確認するには、[管理設定を受け取った](https://code.claude.com/docs/ja/managed-settings.md#read-the-source-in-%2Fstatus) セッションで `/usage` を実行してください。Session ブロックの `Estimated cost` 行には `at your organization's configured rates` という注記が付きます。数値はあくまで推定値であり、請求書ではありません。`/model` ピッカーの 100 万トークンあたりの価格は定価のままです。
 
 ### Claude for Teams および Enterprise
@@ -252,5 +252,5 @@ Amazon Bedrock、Google Cloud の Agent Platform、および Microsoft Foundry 
 * チームを小さく保ちます。各チームメイトは独自のコンテキストウィンドウを実行するため、トークン使用量はおおよそチームサイズに比例します。
 * スポーンプロンプトを焦点を絞ったものにします。チームメイトは CLAUDE.md、MCP サーバー、およびスキルを自動的に読み込みますが、スポーンプロンプト内のすべてが最初からコンテキストに追加されます。
-* 作業が完了したらチームをシャットダウンします。アクティブなチームメイトはアイドル状態でもトークンを消費し続けます。
+* 作業が完了したらチームメイトをシャットダウンします。アクティブな各チームメイトは、終了するかセッションが終わるまでトークンを消費し続けます。
 * エージェントチームはデフォルトで無効になっています。[settings.json](https://code.claude.com/docs/ja/settings.md) または環境で `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1` を設定して有効にします。[エージェントチームを有効にする](https://code.claude.com/docs/ja/agent-teams.md#enable-agent-teams) を参照してください。
 
```

</details>

<details>
<summary>desktop-ja.md</summary>

```diff
diff --git a/docs-ja/pages/desktop-ja.md b/docs-ja/pages/desktop-ja.md
index 2d7fdf2..68061b9 100644
--- a/docs-ja/pages/desktop-ja.md
+++ b/docs-ja/pages/desktop-ja.md
@@ -519,9 +519,9 @@ worktree にコミットされていない変更があるセッションをア
 ### メインセッションを脱線させずにサイドクエスチョンを尋ねる
 
-サイドチャットを使用すると、セッションのコンテキストを使用するが、メインの会話に何も追加しない質問を Claude に尋ねることができます。コードの一部を理解したい、仮定を確認したい、またはセッションを脱線させずにアイデアを探索したい場合に使用します。
+サイドチャットを使用すると、セッションについて Claude に質問できます。サイドチャットでの Claude の回答は、メインの会話に自動的には追加されません。コードの一部を理解したり、仮定を確認したり、アイデアを探索したりする場合にサイドチャットを使用します。
 
-macOS で\*\*Cmd+;**を、Windows で**Ctrl+;\*\*を押してサイドチャットを開くか、プロンプトボックスで`/btw`を入力します。サイドチャットはその時点までのメインスレッドのすべてを読み取ることができます。完了したら、サイドチャットを閉じてメインセッションを続行します。
+macOS で **Cmd+;** を、Windows で **Ctrl+;** を押してサイドチャットを開くか、プロンプトボックスで `/btw` を入力します。サイドチャットはその時点までのメインスレッドのすべてを読み取ることができます。完了したら、サイドチャットを閉じてメインセッションに戻ります。
 
-サイドチャットはローカル、SSH、および WSL セッションで利用可能です。デスクトップアプリはサイドチャットをディスクに保存しないため、アプリを閉じた後に戻ることはできません。
+サイドチャットはローカル、SSH、および WSL セッションで利用可能です。
 
 ### バックグラウンドタスクを監視する
@@ -675,5 +675,9 @@ Claude の作業中でも、他のメッセージと同様にコマンドを送
 プラグインのスコープは、ユーザーアカウント、特定のプロジェクト、またはローカルのみに設定できます。組織がプラグインを一元管理している場合、それらのプラグインは CLI と同じようにデスクトップセッションでも利用できます。ただし、デスクトップアプリが [`disableSideloadFlags` により保留する](https://code.claude.com/docs/ja/settings-reference#disablesideloadflags)ものは除きます。
 
-プラグインブラウザはクラウドセッションでは利用できず、デスクトップアプリからインストールしたプラグインもクラウドセッションでは利用できません。また、[セットアップから引き継がれるもの](https://code.claude.com/docs/ja/cloud-environments.md#what-carries-over-from-your-setup)で説明しているとおり、クラウドセッションは、リポジトリの `.claude/settings.json` で宣言されているプラグインもインストールしません。プラグインは WSL セッションでは利用できません。独自のプラグインの作成を含むプラグインの完全なリファレンスについては、[プラグイン](https://code.claude.com/docs/ja/plugins/overview.md)を参照してください。
+> [!NOTE]
+>
+> プラグインブラウザはクラウドセッションでは利用できません。また、デスクトップアプリからユーザーアカウント用またはローカルのみとしてインストールしたプラグインも、クラウドセッションでは利用できません。[セットアップから引き継がれるもの](https://code.claude.com/docs/ja/cloud-environments.md#what-carries-over-from-your-setup)を参照してください。プラグインは WSL セッションでは利用できません。
+
+独自のプラグインの作成を含むプラグインの完全なリファレンスについては、[プラグイン](https://code.claude.com/docs/ja/plugins/overview.md)を参照してください。
 
 ### プレビューサーバーを設定する
@@ -2281,5 +2285,5 @@ Desktop と CLI は同じ設定ファイルを読み込むため、セットア
 #### Claude Desktop チャットアプリからの MCP サーバー
```

</details>

<details>
<summary>env-vars-ja.md</summary>

```diff
diff --git a/docs-ja/pages/env-vars-ja.md b/docs-ja/pages/env-vars-ja.md
index 3458bc5..4ba774c 100644
--- a/docs-ja/pages/env-vars-ja.md
+++ b/docs-ja/pages/env-vars-ja.md
@@ -277,4 +277,5 @@ Claude Code はスタートアップ時にシェル環境変数を読み込む
 | `CLAUDE_CODE_DISABLE_PROXY_SCHEME_REPAIR` | `1` に設定すると、ターミナルなしで起動した場合でも、`HTTPS_PROXY` または `https_proxy` にプレーンな `host:port` が指定されていれば、Claude Code は起動時に停止します。Claude Code はプロジェクト設定とローカル設定ではこれを無視します。Claude Code v2.1.327 以降が必要です |
 | `CLAUDE_CODE_DISABLE_REFUSAL_FALLBACK` | `1` に設定すると、[安全性分類器がリクエストを警告したときの自動モデル切り替え](https://code.claude.com/docs/ja/model-config.md#automatic-model-fallback)をオフにします。これは [`switchModelsOnFlag`](https://code.claude.com/docs/ja/settings-reference#switchmodelsonflag) 設定が制御する動作です |
+| `CLAUDE_CODE_DISABLE_SHELL_HEAD_START` | `1` に設定すると、Claude がセッションの最初の Bash コマンドを書いている間、そのコマンドの権限プロンプトより前にシェルの起動ファイルを実行できる先行起動をオフにします。Claude Code v2.1.327 以降が必要です |
 | `CLAUDE_CODE_DISABLE_STRUCTURED_OUTPUTS` | `1` に設定すると、アップストリームが構造化出力の `output_config.format` フィールドとそれと対になる `anthropic-beta` 値を拒否する [LLM ゲートウェイ](https://code.claude.com/docs/ja/llm-gateway-protocol.md#feature-pass-through)向けに、Claude Code がそれらを送信しないようにします。[`CLAUDE_CODE_DISABLE_EXPERIMENTAL_BETAS`](https://code.claude.com/docs/ja/llm-gateway-protocol#disable-pre-release-capabilities) がオフにするその他のプレリリース機能はオンのままになります。Claude Code v2.1.288 以降が必要です |
 | `CLAUDE_CODE_DISABLE_SUBSTITUTION_RM_PROMPT` | `1` に設定すると、`rm -rf "$(pwd)"` のように、対象全体がコマンド置換の出力である再帰的な `rm` に対する[クリティカルパス](https://code.claude.com/docs/ja/permission-modes.md#critical-paths)のチェックをオフにします。その他のクリティカルパスのチェックは引き続き実行されます。Claude Code は設定の `env` ブロックを通じて配信されたコピーを無視するため、Claude Code を起動する環境で設定してください。Claude Code v2.1.281 以降が必要です |
```

</details>

<details>
<summary>errors-ja.md</summary>

```diff
diff --git a/docs-ja/pages/errors-ja.md b/docs-ja/pages/errors-ja.md
index 4434906..54f5990 100644
--- a/docs-ja/pages/errors-ja.md
+++ b/docs-ja/pages/errors-ja.md
@@ -1158,5 +1158,5 @@ macOS の v2.1.286 より前では、別のウィンドウからサインイン
 ### Could not resolve authentication method
 
-セッションが認証情報なしで API クライアントに到達しました。[バックグラウンドセッション](https://code.claude.com/docs/ja/agent-view.md)とクラウドセッションでは、ワーカーが認証情報なしで起動したときにこのメッセージが表示されます。対話モード、`-p`、Agent SDK の実行では、同じ状態を [Not logged in](#not-logged-in) として報告し、この文字列はデバッグログにのみ書き込まれます。そのため、デバッグログでこれを見つけた場合は、代わりにそちらの項目に従ってください。
+セッションが認証情報なしで API クライアントに到達しました。対話実行、`-p` 実行、または Agent SDK 実行で [Not logged in](#not-logged-in) が表示され、この文字列がそのデバッグログにある場合は、そのエントリの手順に従ってください。
 
 ```text theme={null}
@@ -1164,5 +1164,5 @@ Could not resolve authentication method. Expected one of apiKey, authToken, cred
 ```
 
-現在のバージョンでは、このエラーはワーカープロセスが使用できる認証情報がなかったことを意味します。v2.1.174 より前では、アイドル状態の事前初期化済みワーカーに割り当てられたバックグラウンドセッションが、有効な認証情報が設定されていてもこのように失敗することがありました。v2.1.176 より前では、割り当てられる前にアイドル状態だったクラウドセッションでも同様でした。アップグレードすると復旧します。
+v2.1.174 より前では、アイドル状態の事前初期化済みワーカーに割り当てられたバックグラウンドセッションが、有効な認証情報が設定されていてもこのように失敗することがありました。v2.1.176 より前では、割り当てられる前にアイドル状態だったクラウドセッションでも同様に失敗することがありました。復旧するにはアップグレードしてください。
 
 **対処方法：**
@@ -5996,5 +5996,5 @@ Claude Code は、[retention sweep](https://code.claude.com/docs/ja/claude-direc
 
 * 別の方法で変更を元に戻してください。Claude に編集を逆にするよう依頼するか、バージョン管理からファイルを復元してください。バックアップがなくなると、`/rewind` を再度実行しても同じ方法で失敗します。
-* Claude Code がファイルに書き込みまたは削除できない場合は、ファイル権限など書き込みをブロックしているものを修正してから、`/rewind` を再度実行してください。
+* **Restore code** を選択した後に Claude Code がファイルに書き込みまたは削除できなかった場合は、ファイル権限など書き込みをブロックしているものを修正してから、`/rewind` を再度実行してください。
 * 今後のセッションでバックアップをより長く保持するには、[`cleanupPeriodDays`](https://code.claude.com/docs/ja/settings-reference#cleanupperioddays) を増やしてください。
 
```

</details>

*...以降省略*

</details>


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

<!-- UPDATE_LOG_END -->
