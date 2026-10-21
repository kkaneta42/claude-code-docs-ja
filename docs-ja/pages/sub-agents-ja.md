> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# カスタムサブエージェントの作成

> Claude Code でタスク固有のワークフローと改善されたコンテキスト管理のための特化した AI サブエージェントを作成して使用します。

サブエージェントは、特定の種類のタスクを処理する特化した AI アシスタントです。サイドタスクがメイン会話に検索結果、ログ、または再度参照しないファイルコンテンツで溢れかえる場合に使用します。サブエージェントはそのタスクを独自のコンテキストで実行し、概要のみを返します。同じ種類のワーカーを同じ指示で繰り返し生成する場合は、カスタムサブエージェントを定義します。

各サブエージェントは、カスタムシステムプロンプト、特定のツールアクセス、および独立した権限を備えた独自のコンテキストウィンドウで実行されます。また、独自のリクエストを送信し、これはメイン会話と同じ [使用制限](/docs/ja/costs#plan-usage-breakdown) にカウントされます。Claude がサブエージェントの説明に一致するタスクに遭遇すると、そのサブエージェントに委譲し、サブエージェントは独立して動作して結果を返します。実際にコンテキスト節約を確認するには、[コンテキストウィンドウの可視化](/docs/ja/context-window)で、サブエージェントが独自の別のウィンドウで研究を処理するセッションを説明しています。

> [!NOTE]
>
> サブエージェントは単一のセッション内で動作します。多くの独立したセッションを並行して実行し、1 つの場所から監視するには、[バックグラウンドエージェント](/docs/ja/agent-view)を参照してください。互いにメッセージを渡すセッションについては、[クロスセッションメッセージング](/docs/ja/cross-session-messaging)を参照してください。Claude が生成および監督する調整されたセッションのチームについては、[エージェントチーム](/docs/ja/agent-teams)を参照してください。

サブエージェントは以下に役立ちます：

* **コンテキストを保持する** ことで、探索と実装をメインの会話から分離します
* **制約を強制する** ことで、サブエージェントが使用できるツールを制限します
* **設定を再利用する** ことで、ユーザーレベルのサブエージェントをプロジェクト全体で再利用します
* **動作を特化させる** ことで、特定のドメイン向けの焦点を絞ったシステムプロンプトを使用します
* **コストを制御する** ことで、Haiku のような高速で安価なモデルにタスクをルーティングします

Claude は各サブエージェントの説明を使用して、タスクを委譲するかどうかを決定します。サブエージェントを作成するときは、Claude がいつそれを使用するかを知るように、明確な説明を書いてください。

これらの説明はコンテキストを占有するため、短く保ってください。組み込みのサブエージェントを除いたサブエージェントの説明の合計が 15,000 トークンを超える場合、Claude Code は[スタートアップ時に総トークン数を含む警告を表示](/docs/ja/errors#agent-descriptions-are-over-the-15000-token-limit)します。サブエージェントの `description` フィールドをトリミングし、詳細を各サブエージェントのシステムプロンプトに移動します。システムプロンプトは、そのサブエージェントが実行される場合にのみロードされます。

## 組み込みサブエージェント

Claude Code には、Claude が必要に応じて自動的に使用する組み込みサブエージェントが含まれています。各サブエージェントは親の会話の権限を継承します。ほとんどは制限されたツールセットで実行されます。

Explore と Plan は、調査を高速かつ低コストに保つために、CLAUDE.md ファイルと git ステータスのスナップショットを読み込まずに開始します。その他の組み込みサブエージェントと[カスタムサブエージェント](#configure-subagents)は両方を読み込みます。ただし、カスタムサブエージェントの定義で [`omitClaudeMd`](#supported-frontmatter-fields) を設定すると、ユーザー、プロジェクト、およびローカルの CLAUDE.md ファイルを読み込まずに開始できます。サブエージェントに到達するものの完全な内訳については、[スタートアップ時に読み込まれるもの](#what-loads-at-startup)を参照してください。

**Explore**

コードベースの検索と分析に最適化された高速な読み取り専用エージェント。

* **モデル**: メイン会話のモデル。メイン会話が Fable で実行されている場合、Explore のモデルは接続方法によって異なります。
  * Claude サブスクリプション、Anthropic Console アカウント、または `ANTHROPIC_BASE_URL` 経由で接続する [LLM ゲートウェイ](/docs/ja/llm-gateway)を使用する場合、Explore は [`opus` エイリアス](/docs/ja/model-config#model-aliases)が解決される Opus モデルで実行されます。
  * Amazon Bedrock、Google Cloud の Agent Platform、Microsoft Foundry、[Claude Platform on AWS](/docs/ja/claude-platform-on-aws)、または [Claude apps ゲートウェイ](/docs/ja/claude-apps-gateway)では、Explore はメイン会話のモデルのままです。
* **ツール**: 読み取り専用ツール。Write と Edit は拒否されます。
* **目的**: ファイル検出、コード検索、コードベース探索

`Explore` という名前の[ユーザーまたはプロジェクトサブエージェント](#choose-the-subagent-scope)は組み込みを上書きし、独自の `model` フィールドを保持します。そのため、`model: haiku` で定義すると、探索をより低コストのモデルで実行できます。Explore を含むすべてのサブエージェントに 1 つのモデルを強制するには、[すべてのサブエージェントを 1 つのモデルで実行](#run-every-subagent-on-one-model)を参照してください。

Claude は、変更を加えずにコードベースを検索または理解する必要がある場合、Explore に委譲します。これにより、探索結果がメイン会話コンテキストから除外されます。

Explore を呼び出すとき、Claude は徹底度レベルを指定します。ターゲット検索の場合は**quick**、バランスの取れた探索の場合は**medium**、包括的な分析の場合は**very thorough**です。

**Plan**

[プランモード](/docs/ja/permission-modes#analyze-before-you-edit-with-plan-mode)中にプランを提示する前にコンテキストを収集するために使用される研究エージェント。

* **モデル**: メイン会話から継承されます。ただし、`CLAUDE_CODE_SUBAGENT_MODEL`を設定して[すべてのサブエージェントを 1 つのモデルで実行](#run-every-subagent-on-one-model)する場合を除きます。
* **ツール**: 読み取り専用ツール。Write と Edit は拒否されます。
* **目的**: 計画のためのコードベース研究

プランモード中で Claude がコードベースを理解する必要がある場合、探索出力が別のコンテキストウィンドウに留まるように、Plan サブエージェントに研究を委譲し、メイン会話は読み取り専用のままです。

**General-purpose**

探索とアクションの両方を必要とする複雑なマルチステップタスク用の有能なエージェント。

* **モデル**: [`CLAUDE_CODE_SUBAGENT_MODEL`](#choose-a-model)モデル（設定した場合で、他の何もモデルを別の方法で割り当てない場合）、それ以外の場合はメイン会話のモデル。[モデルを選択](#choose-a-model)は完全な順序を示し、[すべてのサブエージェントを 1 つのモデルで実行](#run-every-subagent-on-one-model)は変数がこれらのソースをオーバーライドする方法を示します。
* **ツール**: [サブエージェントで利用可能](#available-tools)なすべてのツール
* **目的**: 複雑な研究、マルチステップ操作、コード変更

Claude は、タスクが探索と変更の両方を必要とする場合、結果を解釈するための複雑な推論、または複数の依存ステップが必要な場合、general-purpose に委譲します。

**Other**

Claude Code には、特定のタスク用の追加のヘルパーエージェントが含まれています。これらは通常自動的に呼び出されるため、直接使用する必要はありません。

| エージェント | モデル | Claude が使用する場合 |
| :- | :- | :- |
| claude | 独自のモデルはありません。Claude がサブエージェントとして生成する場合は[モデル順序](#choose-a-model)に従います | タスクがより特化したエージェントに適合しない場合。[サブエージェントで利用可能](#available-tools)なすべてのツールを備えたキャッチオール。また、ディスパッチされた[バックグラウンドセッション](/docs/ja/agent-view)のデフォルトエージェント。[セッションが開始される方法に応じて、開始される権限モード](/docs/ja/agent-view#permission-mode-model-and-effort)。 |
| statusline-setup | Sonnet | `/statusline`を実行してステータスラインを設定する場合 |
| claude-code-guide | Haiku | Claude Code 機能について質問する場合 |

組み込みサブエージェントはインタラクティブセッションでデフォルトで登録されます。これらを制限するには：

* 特定の組み込みタイプをブロックするには、[特定のサブエージェントを無効にする](#disable-specific-subagents)に示されているように、`permissions.deny`に追加します。
* Claude がサブエージェントに委譲するのを防ぐには、[`permissions.deny`](/docs/ja/permissions#tool-specific-permission-rules)で`Agent`ツール自体を拒否します。
* 組み込みの`Explore`および`Plan`サブエージェントのみを削除するには、[`CLAUDE_CODE_DISABLE_EXPLORE_PLAN_AGENTS=1`](/docs/ja/env-vars)を設定します。Claude はファイルを直接読み取り、探索し、サブエージェントに委譲しません。Claude Code v2.1.198 以降が必要です。
* [非インタラクティブモード](/docs/ja/headless)および[Agent SDK](/docs/ja/agent-sdk/overview)では、[`CLAUDE_AGENT_SDK_DISABLE_BUILTIN_AGENTS=1`](/docs/ja/env-vars)を設定して、すべての組み込みタイプを削除し、独自のタイプのみを提供します。

`subagent_type` を省略する Agent ツール呼び出しは、フォールバック先となる `general-purpose` サブエージェントがセッションにない場合、[`subagent_type is required`](/docs/ja/errors#subagent-type-is-required) で失敗します。

これらの組み込みサブエージェント以外に、カスタムプロンプト、ツール制限、権限モード、フック、およびスキルを使用して独自のサブエージェントを作成できます。次のセクションでは、サブエージェントの使用を開始し、カスタマイズする方法を示します。

## クイックスタート：最初のサブエージェントを作成する

サブエージェントは YAML フロントマターを含む Markdown ファイルです。Claude に作成してもらうか、[手動で作成](#write-subagent-files)することができます。

このチュートリアルでは、コードをレビューして改善を提案するユーザーレベルのサブエージェントを作成します。

**1. Claude にサブエージェントの作成を依頼する**

Claude Code で、作成したいサブエージェントと保存場所を説明します：

```text wrap theme={null}
Create a personal code-improver subagent in ~/.claude/agents/ that scans
files and suggests improvements for readability, performance, and best
practices. It should explain each issue, show the current code, and
provide an improved version. Make it read-only and have it use Sonnet.
```

Claude は `name`、`description`、`tools` リスト、`model`、およびシステムプロンプトを含むファイルを作成します。

**2. ファイルを確認する**

`~/.claude/agents/code-improver.md` を開き、フロントマターが要求内容と一致することを確認します。結果は次のようになります：

```markdown theme={null}
---
name: code-improver
description: Scans files and suggests improvements for readability, performance, and best practices. Use after writing or modifying code.
tools: Read, Grep, Glob
model: sonnet
---

You are a code improvement specialist. For each issue you find, explain
the problem, show the current code, and provide an improved version.
```

ファイルが `~/.claude/agents/` に存在するため、サブエージェントはマシン上のすべてのプロジェクトで利用可能です。代わりに 1 つのプロジェクトにスコープを設定するには、そのプロジェクトの `.claude/agents/` ディレクトリに移動します。[サブエージェントスコープを選択する](#choose-the-subagent-scope)で 2 つを比較しています。

**3. 試してみる**

Claude に新しいサブエージェントに委譲するよう依頼します：

```text wrap theme={null}
Use the code-improver agent to suggest improvements in this project
```

Claude は新しいサブエージェントに委譲し、コードベースをスキャンして改善提案を返します。トランスクリプトでは、委譲はツール呼び出し行として表示され、サブエージェント名の後に短いタスク説明が続きます（例：`code-improver(Suggest code improvements)`）。

Claude が新しいサブエージェントを見つけられない場合は、Claude Code を再起動してもう一度試してください。これは `~/.claude/agents/` がセッション開始前に存在しなかった場合にのみ発生します。実行中のセッションは新しく作成された `agents` ディレクトリを検出しないためです。

これで、マシン上のプロジェクトでコードベースを分析し、改善を提案するために使用できるサブエージェントができました。

サブエージェントファイルを手動で作成したり、CLI フラグを使用して定義したり、プラグインを通じて配布したりすることもできます。以下のセクションでは、すべての設定オプションについて説明します。

> [!NOTE]
>
> `/agents` を実行すると、Claude に依頼するか、`.claude/agents/` および `~/.claude/agents/` を直接編集するよう促すメッセージが表示されます。
> Claude Code v2.1.197 以前では、`/agents` はライブサブエージェントを一覧表示する **Running** タブと、サブエージェントを作成、編集、削除するための **Library** タブを備えたインタラクティブウィザードを開きます。

## サブエージェントの設定

サブエージェントのファイルの場所によって、誰がそれを利用できるかが決まり、frontmatter によってそれが何をできるかが決まります。このセクションでは、サブエージェントファイルがどこに存在するか、およびサポートされるすべてのフィールドについて説明します。

### サブエージェントのスコープを選択する

スコープに応じて、サブエージェントファイルを異なる場所に保存します。複数のサブエージェントが同じ名前を共有する場合、Claude Code はより優先度の高い場所のものを使用します。

| 場所 | スコープ | 優先度 | 作成方法 |
| :- | :- | :- | :- |
| 管理設定 | 組織全体 | 1（最高） | [管理設定](/docs/ja/settings)経由でデプロイ |
| `--agents` CLI フラグ | 現在のセッション | 2 | Claude Code 起動時に JSON を渡す |
| `.claude/agents/` | 現在のプロジェクト | 3 | Claude に依頼するか、ファイルを手動で作成 |
| `~/.claude/agents/` | すべてのプロジェクト | 4 | Claude に依頼するか、ファイルを手動で作成 |
| プラグインの `agents/` ディレクトリ | プラグインが有効な場所 | 5（最低） | [プラグイン](/docs/ja/plugins/overview)でインストール |

**プロジェクトサブエージェント**（`.claude/agents/`）は、コードベースに固有のサブエージェントに最適です。バージョン管理にチェックインして、チームが協力して使用および改善できるようにします。

プロジェクトサブエージェントは現在の作業ディレクトリから上へ向かって検出されるため、そこからリポジトリルートまでのすべての `.claude/agents/` がスキャンされます。これらのネストされたディレクトリの複数が同じ `name` を定義する場合、Claude Code は作業ディレクトリに最も近い定義を使用します。

`--add-dir` または `/add-dir` でディレクトリを追加すると、Claude Code はプロジェクトサブエージェントと一緒にその `.claude/agents/` フォルダも読み込みます。[追加ディレクトリ](/docs/ja/permissions#additional-directories-grant-file-access-not-configuration)を参照して、`--add-dir` から読み込む他の設定タイプを確認してください。`--add-dir` を使用せずにプロジェクト間でサブエージェントを共有するには、`~/.claude/agents/` または[プラグイン](/docs/ja/plugins/overview)を使用します。

**ユーザーサブエージェント**（`~/.claude/agents/`）は、すべてのプロジェクトで利用可能な個人用サブエージェントです。

Claude Code は `.claude/agents/` と `~/.claude/agents/` を再帰的にスキャンするため、`agents/review/` や `agents/research/` などのサブフォルダに定義を整理できます。サブディレクトリパスはサブエージェントの識別方法や呼び出し方法に影響しません。これは、ID が `name` frontmatter フィールドのみから来るためです。

`name` 値をツリー全体で一意に保ちます。同じ `.claude/agents/` ディレクトリ内（サブフォルダを含む）の 2 つのファイルが同じ名前を宣言する場合、Claude Code はそのうちの 1 つだけを読み込み、ドキュメント化された優先順位ではなくファイルシステムの読み取り順序で選択されます。ネストされたプロジェクトディレクトリ全体では、作業ディレクトリに最も近い定義が優先されます（上記で説明）。[`/doctor`](/docs/ja/commands#all-commands) セットアップチェックアップは、同じディレクトリ内で名前を共有するファイルをレポートし、1 つを除くすべての名前変更または削除を提案します。

プラグイン `agents/` ディレクトリも再帰的にスキャンされます。プロジェクトおよびユーザースコープとは異なり、プラグインの `agents/` ディレクトリ内のサブフォルダは[スコープ付き識別子](#invoke-subagents-explicitly)の一部になります。プラグイン `my-plugin` の `agents/review/security.md` にあるファイルは `my-plugin:review:security` として登録されます。

**CLI 定義サブエージェント**は Claude Code 起動時に JSON として渡されます。これらはそのセッションのみに存在し、ディスクに保存されないため、クイックテストまたは自動化スクリプトに便利です。1 つの `--agents` 呼び出しで複数のサブエージェントを定義できます。

**macOS, Linux, WSL**

```bash theme={null}
claude --agents '{
  "code-reviewer": {
    "description": "Expert code reviewer. Use proactively after code changes.",
    "prompt": "You are a senior code reviewer. Focus on code quality, security, and best practices.",
    "tools": ["Read", "Grep", "Glob", "Bash"],
    "model": "sonnet"
  },
  "debugger": {
    "description": "Debugging specialist for errors and test failures.",
    "prompt": "You are an expert debugger. Analyze errors, identify root causes, and provide fixes."
  }
}'
```

**Windows PowerShell**

```powershell theme={null}
claude --agents @'
{
  "code-reviewer": {
    "description": "Expert code reviewer. Use proactively after code changes.",
    "prompt": "You are a senior code reviewer. Focus on code quality, security, and best practices.",
    "tools": ["Read", "Grep", "Glob", "Bash"],
    "model": "sonnet"
  },
  "debugger": {
    "description": "Debugging specialist for errors and test failures.",
    "prompt": "You are an expert debugger. Analyze errors, identify root causes, and provide fixes."
  }
}
'@
```

[非対話モード](/docs/ja/headless)では、`--agents` はコマンドラインで渡すには大きすぎる定義用に、JSON ファイルを保持するパスも受け入れます。例えば、`claude -p --agents ./agents.json "Review my changes"` はそのファイルから定義を読み取ります。対話型セッションでは、Claude Code はファイルパスを拒否します。ファイル形式には Claude Code v2.1.281 以降が必要です。

JSON の各トップレベルキーはエージェントの名前で、その値がそのエージェントの定義です。名前を `-` で始めないでください。定義は以下のフィールドを取ります。

* **`prompt`**。エージェントのシステムプロンプト。ファイルベースのサブエージェントのマークダウン本体と同等です。`prompt` は空にすることができます。空の `prompt` と `memory` フィールドのないエージェントを `--agent` でセッションのエージェントとして選択する場合、セッションのシステムプロンプトは変更されません。空の `prompt` には Claude Code v2.1.281 以降が必要です。
* **[フロントマターフィールド](#supported-frontmatter-fields)**。`description`、`tools`、`disallowedTools`、`model`、`permissionMode`、`mcpServers`、`hooks`、`maxTurns`、`autoCompactWindow`、`skills`、`initialPrompt`、`memory`、`effort`、`background`、`omitClaudeMd`、および `isolation`。
* **無視されるフィールド**。`color` と `experimental` はここでは受け入れられず、拒否されるのではなく無視されます。

Claude Code が読み込めない値で何をするか、およびそのチェックをスキップするフラグと環境変数については、[`Invalid --agents configuration`](/docs/ja/errors#invalid-agents-configuration)を参照してください。

**管理サブエージェント**は組織管理者によってデプロイされます。[管理設定ディレクトリ](/docs/ja/managed-settings#delivery-mechanisms)内の `.claude/agents/` にマークダウンファイルを配置し、プロジェクトおよびユーザーサブエージェントと同じ frontmatter 形式を使用します。管理定義は同じ名前のプロジェクトおよびユーザーサブエージェントより優先されます。

**プラグインサブエージェント**は、インストールした[プラグイン](/docs/ja/plugins/overview)から来ます。これらはカスタムサブエージェントと一緒に自動的に読み込まれ、スコープ付き名の下の @-mention タイプアヘッドに表示されます。プラグインサブエージェント作成の詳細については、[プラグインコンポーネントリファレンス](/docs/ja/plugins/components#agents)を参照してください。

> [!NOTE]
>
> セキュリティ上の理由から、プラグインサブエージェントは `hooks`、`mcpServers`、または `permissionMode` フロントマターフィールドをサポートしていません。これらのフィールドはプラグインからエージェントを読み込むときに無視されます。これらが必要な場合は、エージェントファイルを `.claude/agents/` または `~/.claude/agents/` にコピーしてください。また、`settings.json` または `settings.local.json` の [`permissions.allow`](/docs/ja/settings-reference#permissions-allow) にルールを追加することもできますが、これらのルールはセッション全体に適用され、プラグインサブエージェントのみには適用されません。
>
> プラグインの作成者である場合は、代わりにフックをプラグインの [`hooks/hooks.json`](/docs/ja/plugins/components#hooks) に、MCP サーバーをその [`.mcp.json`](/docs/ja/plugins/components#mcp-servers) に含めて配布してください。これらはサブエージェント内だけでなく、プラグインが有効な場合は常に適用されます。

サブエージェント定義は、[エージェントチーム](/docs/ja/agent-teams)のチームメイトとして再利用することもできます。Claude にチームメイトのスポーンを依頼するときにサブエージェントタイプを指定すると、Claude Code はその定義の一部をチームメイトに適用します。各表示モードでどのスコープとどの部分が適用されるかについては、[チームメイトにサブエージェント定義を使用する](/docs/ja/agent-teams#use-subagent-definitions-for-teammates)を参照してください。

### サブエージェントファイルを作成する

サブエージェントファイルは設定用の YAML frontmatter を使用し、その後にマークダウンのシステムプロンプトが続きます。

> [!NOTE]
>
> Claude Code は `~/.claude/agents/` と `.claude/agents/` を監視します。ディスク上のサブエージェントファイルを追加または編集するか、Claude にそれを作成するよう依頼すると、Claude Code は数秒以内に変更を検出し、次の委任は再起動なしで更新された定義を使用します。
>
> 3 つのケースではまだ再起動が必要です。
>
> * ウォッチャーはセッション開始時に存在していたディレクトリのみをカバーするため、新しい `agents` ディレクトリでスコープの最初のエージェントファイルを作成した後、再起動して読み込みます。
> * Claude Code は `--add-dir` または `/add-dir` で追加されたディレクトリ内の `.claude/agents/` を監視しないため、そこでサブエージェントを追加または編集した後、再起動して変更を読み込みます。
> * `--disable-slash-commands` で開始されたセッションはこれらのディレクトリをまったく監視しません。

```markdown .claude/agents/code-reviewer.md theme={null}
---
name: code-reviewer
description: Reviews code for quality and best practices
tools: Read, Glob, Grep
model: sonnet
---

You are a code reviewer. When invoked, analyze the code and provide
specific, actionable feedback on quality, security, and best practices.
```

frontmatter はサブエージェントのメタデータと設定を定義します。本体はサブエージェントの動作をガイドするシステムプロンプトになります。サブエージェントは、このシステムプロンプトと作業ディレクトリなどの基本的な環境詳細のみを受け取り、Claude Code システムプロンプトは受け取りません。

[非対話モード](/docs/ja/headless)では、[`--append-subagent-system-prompt`](/docs/ja/cli-reference#cli-flags)を渡して、テキストをすべてのサブエージェント（ネストされたサブエージェントを含む）のシステムプロンプトの末尾に追加します。ただし、[フォークされたサブエージェント](#fork-the-current-conversation)は除きます。これは会話独自のプロンプトを再利用します。Claude Code v2.1.205 以降が必要です。テキストがコマンドラインで渡すには長すぎる場合は、ファイルに保存して `--append-subagent-system-prompt-file` でパスを渡してください。ファイルフラグには Claude Code v2.1.261 以降が必要です。

サブエージェントはメイン会話の現在の作業ディレクトリで開始します。サブエージェント内では、`cd` コマンドは Bash または PowerShell ツール呼び出し間で永続化されず、メイン会話の作業ディレクトリに影響しません。代わりにサブエージェントにリポジトリの分離されたコピーを与えるには、[`isolation: worktree`](#supported-frontmatter-fields)を設定します。

`isolation: worktree` を持つサブエージェントは、その worktree 内で Bash および PowerShell コマンドを実行します。作業ディレクトリが代わりにメインチェックアウトに解決されるコマンド（例えば、サブエージェント実行中に worktree ディレクトリが削除された場合）はエラーで失敗します。

この作業ディレクトリチェックは、Claude Code を起動したディレクトリを含むリポジトリ全体をカバーします。セッションがリンクされた[worktree](/docs/ja/worktrees)で独自に実行される場合、チェックはその worktree がリンクされているメインチェックアウトもカバーします。

Bash コマンドの場合、Claude Code はコマンド自体を 2 つの方法でチェックします。

* git をメインチェックアウトにリダイレクトするコマンドをブロックします。
* コマンドテキストから、コマンドが実行する git がすべて worktree 内に留まることを確認できないコマンドを拒否します。例えば、コマンド名が実行時に計算される場合。

リダイレクトベクトルと形状ルールは[Claude Code が分離を強制する方法](/docs/ja/worktrees#how-claude-code-enforces-isolation)の下にリストされています。PowerShell コマンドは作業ディレクトリチェックのみを取得します。

[Monitor](/docs/ja/tools-reference#monitor-tool)コマンドは Bash コマンドと同じ作業ディレクトリおよびコマンドコンテンツチェックを通過します。

メイン会話自体が worktree で分離されて実行される場合、Claude Code はセッションとそれがスポーンするすべてのサブエージェント（`isolation: worktree` なしのサブエージェントを含む）に同じチェックを適用します。[Claude Code が分離を強制する方法](/docs/ja/worktrees#how-claude-code-enforces-isolation)を参照してください。

### Frontmatter リファレンス

サブエージェントは、ファイル先頭の `---` マーカーで囲んだ YAML [フロントマター](/docs/ja/glossary#frontmatter)で設定し、閉じの `---` の後にシステムプロンプトを Markdown で記述します。`name` と `description` のみが必須です。

複数単語のフィールド名は `maxTurns` や `disallowedTools` などの camelCase を使用し、テーブルと正確に一致する必要があります。Claude Code は認識しないフィールドを無視し、エラーを報告しません。

* 読み込まれたサブエージェントでスペルミスのあるフィールドを見つけるには、シェルで [`claude --debug`](/docs/ja/cli-reference#cli-flags) を実行し、`~/.claude/debug/<session-id>.txt` にあるデバッグログで `does not recognize or apply` を検索します。デバッグログには、Claude Code が認識しないサブエージェントファイル内のトップレベルフィールドが最大 5 つまで示され、サポートされているフィールドに近い場合は意図したと思われる名前も示されます。Claude Code v2.1.296 以降が必要です。
* サブエージェントファイルが読み込まれなかった理由を確認するには、[Claude Code がスキップするサブエージェントファイル](#subagent-files-claude-code-skips)を参照してください。

| フィールド | 必須 | 説明 |
| :- | :- | :- |
| `name` | はい | 最大 256 文字の一意の識別子（`code-reviewer` や `reviewer-v2` など）。[フック](/docs/ja/hooks#subagentstart)はこの値を `agent_type` として受け取ります。ファイル名は一致する必要はありません。名前に `:` を含めることはできません。これは [プラグインスコープ付き識別子](/docs/ja/plugins/overview)（`my-plugin:reviewer` など）用に予約されています |
| `description` | はい | Claude がこのサブエージェントに委任すべき場合 |
| `tools` | いいえ | サブエージェントが使用できる[ツール](#available-tools)。`Read, Grep, Bash` などのカンマ区切り文字列、または YAML リストとして指定します。省略した場合、サブエージェントで利用可能なすべてのツールを継承します。リスト内のエントリがツールに解決されない場合、サブエージェントは通常、エントリに名前を付けるエラーで[起動に失敗](/docs/ja/errors#agent-would-be-spawned-with-zero-tools)します。スキルをコンテキストにプリロードするには、ここで `Skill` をリストするのではなく、`skills` フィールドを使用します |
| `disallowedTools` | いいえ | 継承または指定されたリストから削除するツール。`tools` と同じ形式。`Bash(git push *)` などの指定子を持つエントリでも、[ツール全体](#restrict-which-tools-a-subagent-can-use)が削除されます |
| `model` | いいえ | 使用する[モデル](#choose-a-model)。`sonnet`、`opus`、`haiku`、`fable`、`claude-opus-5-5` などの完全なモデル ID、または `inherit`。省略した場合、Claude Code は[サブエージェントモデル順序](#choose-a-model)でモデルを選択します |
| `permissionMode` | いいえ | [権限モード](#permission-modes)。`default`、`acceptEdits`、`auto`、`dontAsk`、`bypassPermissions`、`plan`、または `default` のエイリアスとしての `manual`。[プラグインサブエージェント](#choose-the-subagent-scope)では無視されます |
| `maxTurns` | いいえ | サブエージェントが停止する前の最大 agentic ターン数。サブエージェントが制限に達すると、Claude Code は出力を部分的としてマークして返し、Claude は[再開](#resume-subagents)して続行できます。部分的なマーキングには Claude Code v2.1.246 以降が必要です |
| `autoCompactWindow` | いいえ | このサブエージェントの[自動圧縮ウィンドウ](#subagent-auto-compact-window)を、`100000` から `1000000` までのトークン数に下げます。Claude Code v2.1.296 以降が必要です |
| `skills` | いいえ | 起動時にサブエージェントのコンテキストにプリロードする[スキル](/docs/ja/skills)。説明のみではなく、完全なスキルコンテンツが注入されます。サブエージェントは、Skill ツールを通じてリストされていないプロジェクト、ユーザー、およびプラグインスキルを呼び出すことができます |
| `mcpServers` | いいえ | このサブエージェントで利用可能な[MCP サーバー](/docs/ja/mcp)。各エントリは、既に設定されているサーバーを参照するサーバー名（例えば、`"slack"`）、または完全な[MCP サーバー設定](/docs/ja/mcp#installing-mcp-servers)を値として持つサーバー名をキーとするインライン定義のいずれかです。[プラグインサブエージェント](#choose-the-subagent-scope)では無視されます |
| `hooks` | いいえ | このサブエージェントにスコープされた[ライフサイクルフック](#define-hooks-for-subagents)。[プラグインサブエージェント](#choose-the-subagent-scope)では無視されます |
| `memory` | いいえ | [永続メモリスコープ](#enable-persistent-memory)。`user`、`project`、または `local`。クロスセッション学習を有効にします |
| `background` | いいえ | Claude がこのサブエージェントの完了を待つよう要求した場合でも、このサブエージェントをバックグラウンドに保つには `true` に設定します。デフォルトでは、Claude がメイン会話からスポーンするサブエージェントは既に[バックグラウンドで開始](#run-subagents-in-foreground-or-background)されます |
| `omitClaudeMd` | いいえ | このサブエージェントを、[初期コンテキスト](#what-loads-at-startup)にユーザー、プロジェクト、およびローカルの CLAUDE.md ファイルを含めずに起動するには `true` に設定します。[管理ポリシーファイル](/docs/ja/memory#how-claude-md-files-load)は引き続き読み込まれます。ただし、[管理サブエージェント](#choose-the-subagent-scope)は除きます。委任プロンプトから必要なすべてを取得するサブエージェントに使用します。エージェントが `--agent` または `agent` 設定経由でメインセッションエージェントとして実行される場合は無視されます。Claude Code v2.1.271 以降が必要です |
| `effort` | いいえ | このサブエージェントがアクティブな場合の effort レベル。セッションの effort レベルを上書きしますが、[`CLAUDE_CODE_EFFORT_LEVEL`](/docs/ja/env-vars#variables) 環境変数は上書きしません。オプション：`low`、`medium`、`high`、`xhigh`、`max`。利用可能なレベルはモデルによって異なります。[effort レベルを選択する](#choose-an-effort-level)を参照してください |
| `isolation` | いいえ | サブエージェントを一時的な[git worktree](/docs/ja/worktrees)で実行するには `worktree` に設定します。これにより、親セッションの `HEAD` ではなく、デフォルトで[デフォルトブランチ](/docs/ja/worktrees#choose-the-base-branch)からブランチされたリポジトリの分離されたコピーが提供されます。サブエージェントが変更を加えない場合、worktree は自動的にクリーンアップされます |
| `color` | いいえ | タスクリストとトランスクリプトでのサブエージェントの表示カラー。`red`、`blue`、`green`、`yellow`、`purple`、`orange`、`pink`、または `cyan` を受け入れます |
| `initialPrompt` | いいえ | このエージェントがメインセッションエージェント（`--agent` または `agent` 設定経由）として実行される場合、最初のユーザーターンとして自動送信されます。[コマンド](/docs/ja/commands)と[スキル](/docs/ja/skills)が処理されます。ユーザー提供のプロンプトの前に付加されます。[プラグインサブエージェント](#choose-the-subagent-scope)では無視されます |
| `experimental` | いいえ | 実験的オプションのマップ。その `cacheTtl` キーを `5m` または `1h` に設定して、このサブエージェントのリクエストの[プロンプトキャッシュライフタイム](/docs/ja/prompt-caching#choose-the-ttl-yourself)を選択します。この値は、[キャッシュライフタイム優先順位](/docs/ja/prompt-caching#choose-the-ttl-yourself)の中でフロントマターが占める位置で適用されます。Claude Code は他の値を無視し、Claude サブスクリプションが使用クレジットを使用している間は `1h` を無視し、サブエージェントファイルからのみフィールドを読み取ります。Claude Code v2.1.248 以降が必要です |

`cacheTtl` を frontmatter のトップレベルではなく、`experimental` マップ内に書き込みます。

```yaml theme={null}
---
name: repo-auditor
description: Audits a large repository and reports what it finds
experimental:
  cacheTtl: 1h
---
```

#### Claude Code がスキップするサブエージェントファイル

Claude Code は、frontmatter に以下の問題がある場合、プロジェクト、ユーザー、または管理 `agents` ディレクトリ、または `--add-dir` で追加したディレクトリの下のファイルをセッションで報告せずにスキップします。

* **`name` がない**。Claude Code はファイルをエージェントの横に保持されたドキュメントとして扱います。
* **ファイルの最初の行ではない開き `---`**。Claude Code はファイルに frontmatter がないと読み取り、ドキュメントとして扱います。
* **`-` で始まる、`:` を含む、または 256 文字を超える `name`**。Claude Code はファイルをスキップし、デバッグログにエラーを書き込みます。
* **`name` があるが `description` がない**。Claude Code はファイルをスキップし、理由をデバッグログに書き込みます。
* **解析されない YAML**。Claude Code はファイルからフィールドを読み取らず、スキップして、解析エラーをデバッグログに書き込みます。

デバッグログを表示するには、`--debug` で Claude Code を実行します。

frontmatter に `name` がない、または解析されない[プラグインサブエージェント](/docs/ja/plugins/components#agents)は、ファイル名の下で引き続き読み込まれます。

##### セッション前に `agents` ディレクトリをチェックする

frontmatter が解析されない `agents` ディレクトリ内のファイルを見つけるには、例えば `.claude/agents` または `~/.claude/agents` に対して `claude plugin validate` を実行します。Claude Code は[名前を付けたディレクトリのみをチェック](/docs/ja/plugins/cli-reference#validate-a-directory)し、frontmatter が解析されるが `name` がないファイルにはフラグを立てません。Claude Code v2.1.233 以降が必要です。

### モデルを選択する

`model` フィールドはサブエージェントが使用するモデルを制御します。

* **モデルエイリアス**。利用可能なエイリアスの 1 つを使用します。`sonnet`、`opus`、`haiku`、または `fable`
* **完全なモデル ID**。`claude-opus-5-5` または `claude-sonnet-5` などの完全なモデル ID を使用します。`--model` フラグと同じ値を受け入れます
* **inherit**。メイン会話と同じモデルを使用します

Claude がサブエージェントを呼び出すとき、その特定の呼び出しに対して `model` パラメータを渡すこともできます。Claude Code はサブエージェントのモデルをこの順序で解決します。

1. 呼び出しごとの `model` パラメータ
2. サブエージェント定義の `model` frontmatter。`inherit` はメイン会話のモデルを選択します
3. [`CLAUDE_CODE_SUBAGENT_MODEL`](/docs/ja/model-config#environment-variables)環境変数。モデルエイリアスまたはモデル ID に設定した場合
4. メイン会話のモデル

インストール済みの [mod](/docs/ja/plugins/mods/overview) が [`agent.spawn`](/docs/ja/plugins/mods/reference#subagents) フックでモデルを設定する場合、Claude Code は呼び出しごとのパラメータの代わりにそのモデルを使用します。

2 つのケースでは、`opus` などのファミリエイリアスが、呼び出しごとのパラメータまたは frontmatter で、メイン会話のモデルの代わりに[エイリアスが指す](/docs/ja/model-config#model-aliases)バージョンに解決されます。

* **メイン会話のモデルがそのファミリに属する**。サブエージェントはメイン会話の正確なモデル（`[1m]` サフィックスを含む）で実行されるため、メイン会話と同じ[拡張コンテキスト](/docs/ja/model-config#extended-context)ウィンドウを取得します。
* **Claude Code がメイン会話のモデルファミリを判断できない。[Anthropic API 以外のプロバイダー](/docs/ja/third-party-integrations)上で**。これは Claude Code がバッキングモデルに解決していない[アプリケーション推論プロファイル ARN](/docs/ja/amazon-bedrock#iam-configuration)を持つ Amazon Bedrock で発生する可能性があります。このケースは `opus` エイリアスのみをカバーし、[`ANTHROPIC_DEFAULT_OPUS_MODEL`](/docs/ja/model-config#environment-variables)を設定した場合は適用されません。`opus` はその後、設定したモデルに解決されるため。

`CLAUDE_CODE_SUBAGENT_MODEL` のエイリアスは、メイン会話のファミリを指定している場合でも、常にエイリアスが指すバージョンに解決されます。この変数を `inherit` に設定することは、設定しないのと同じです。

`CLAUDE_CODE_SUBAGENT_MODEL` を単独で設定しても、組み込みの Explore および Plan サブエージェントが実行されるモデルは変わりません。変更するには、[すべてのサブエージェントを 1 つのモデルで実行](#run-every-subagent-on-one-model)を参照してください。

v2.1.251 より前では、`CLAUDE_CODE_SUBAGENT_MODEL` はこの順序で最初に来て、呼び出しごとのパラメータと frontmatter（`model: inherit` を含む）の両方をオーバーライドしました。

Claude Code は、呼び出しごとのパラメータ、frontmatter、および環境変数の値を組織の [`availableModels`](/docs/ja/model-config#restrict-model-selection)許可リストに対してチェックします。ブロックされた値の場合、別のモデルに置き換えます。

* `opus` などのファミリエイリアスがブロックされた場合、Claude Code はサブエージェントを許可リストが許可するそのファミリの最新バージョンで実行します。`/model` と同じ[置換ルールとプロバイダースコープ](/docs/ja/model-config#restrict-model-selection)に従います。v2.1.222 より前では、Claude Code はブロックされたファミリエイリアスについても継承されたモデルでサブエージェントを実行していました。
* その他のブロックされた値の場合、その置換が動作しないプロバイダー、または許可リストがファミリのバージョンを許可しない場合、Claude Code は代わりに継承されたモデルでサブエージェントを実行します。`CLAUDE_CODE_SUBAGENT_MODEL` を設定した場合、Claude Code はそのモデルを最初に試します。これらの同じルールの下で。

対話型セッションでは、Claude Code は要求されたモデルとサブエージェントが実行されるモデルに名前を付ける警告を表示します。どちらの置換についても。

サブエージェントが実行されているモデルを確認するには、[`/tasks`](/docs/ja/commands)を実行します。Claude Code はサブエージェントの行にモデル名を表示し、そのサブエージェントに [effort レベル](/docs/ja/model-config#adjust-effort-level)が設定されている場合はそれも追加します。Claude Code v2.1.242 以降が必要です。

呼び出しごとの `model` パラメータは、サブエージェントが[再開または後続メッセージが送信](#resume-subagents)される場合にも適用されるため、サブエージェントはそのモデルに留まります。

v2.1.198 以降、サブエージェントはメイン会話の[拡張思考](/docs/ja/model-config#extended-thinking)設定も継承します。セッションで思考がオンの場合、サブエージェントではオンになり、オフの場合、オフのままです。サブエージェントごとの思考設定はありません。v2.1.198 より前では、サブエージェントはメイン会話の設定に関係なく、拡張思考が無効で実行されていました。

#### すべてのサブエージェントを 1 つのモデルで実行する

`CLAUDE_CODE_SUBAGENT_MODEL` はデフォルトであるため、サブエージェントの定義または Claude が渡すモデルは引き続き優先されます。すべてのサブエージェント、[チームメイト](/docs/ja/agent-teams#specify-teammates-and-models)、および[ワークフローエージェント](/docs/ja/workflows)に 1 つのモデルを適用するには、`CLAUDE_CODE_SUBAGENT_MODEL_FORCE` を `1` に設定します。Claude Code v2.1.257 以降が必要です。

* 両方の変数を設定した場合、サブエージェントは `CLAUDE_CODE_SUBAGENT_MODEL` のモデルで実行されます。
* `CLAUDE_CODE_SUBAGENT_MODEL_FORCE` のみを設定した場合、サブエージェントはメイン会話のモデルで実行されます。ただし、組み込みの Explore サブエージェントは、[組み込みサブエージェントの項でそれに対して記載されているモデル](#built-in-subagents)で実行されます。

例えば、すべてのサブエージェントを Haiku で実行するには、[設定ファイル](/docs/ja/settings)の `env` ブロックで両方の変数を設定します。

```json theme={null}
{
  "env": {
    "CLAUDE_CODE_SUBAGENT_MODEL": "haiku",
    "CLAUDE_CODE_SUBAGENT_MODEL_FORCE": "1"
  }
}
```

設定が有効になったことを確認するには、サブエージェントが実行されている間に [`/tasks`](/docs/ja/commands)を実行します。サブエージェントの行は、実行されるモデルを示します。

`CLAUDE_CODE_SUBAGENT_MODEL_FORCE` が[オン](/docs/ja/env-vars)の間、Claude Code はサブエージェント定義の `model` フィールドを無視し、Claude はサブエージェント開始時にモデルを渡すことができません。以下のサブエージェントは引き続きメイン会話のモデルで実行されます。

* [フォーク](#fork-the-current-conversation)
* `model: inherit` を持つ[サブエージェントで実行されるスキル](/docs/ja/skills#run-skills-in-a-subagent)

### effort レベルを選択する

サブエージェントを独自の [effort レベル](/docs/ja/model-config#adjust-effort-level)で実行するには、その定義で [`effort`](#supported-frontmatter-fields) フィールドを設定します。

フォーク以外のサブエージェントを特定の effort レベルで実行するよう Claude に依頼すると、Claude はその呼び出しに対して `effort` パラメータを渡すこともできます。このパラメータは `effort` フィールドを上書きし、サブエージェントが[再開](#resume-subagents)されても有効なままです。[`CLAUDE_CODE_EFFORT_LEVEL`](/docs/ja/env-vars#variables) 環境変数はその両方より優先されます。呼び出しごとのパラメータには Claude Code v2.1.292 以降が必要です。

### サブエージェント機能を制御する

ツールアクセス、権限モード、および条件付きルールを通じて、サブエージェントが何をできるかを制御できます。

#### 利用可能なツール

サブエージェントは、メイン会話で利用可能な[組み込みツール](/docs/ja/tools-reference)と MCP ツールを継承しますが、2 つのフィルタで絞られます。最初のフィルタはすべてのサブエージェントから短いツールリストを削除し、2 番目のフィルタは[バックグラウンド](#run-subagents-in-foreground-or-background)で実行されるサブエージェント（デフォルト）の組み込みツールセットを削減します。macOS、Linux、および WSL では、メイン会話にない場合、サブエージェントは Glob および Grep ツールを受け取ることもできます。[Glob ツール動作](/docs/ja/tools-reference#glob-tool-behavior)で説明されています。[フォーク](#fork-the-current-conversation)は両方のフィルタをスキップし、メイン会話の正確なツールプールを受け取ります。最初のフィルタは、`tools` フィールドにリストされている場合でも、これらのツールを削除します。

* `Agent`。サブエージェントが[深さ制限](#let-subagents-spawn-their-own-subagents)にある場合。[フォーク](#fork-the-current-conversation)ではツールはリストされたままですが、代わりにエラーを返します
* `AskUserQuestion`
* `EndConversation`。メイン会話のみを終了できます。[EndConversation ツール動作](/docs/ja/tools-reference#endconversation-tool-behavior)を参照してください
* `EnterPlanMode`
* `ExitPlanMode`。サブエージェントの [`permissionMode`](#permission-modes)が `plan` でない限り
* `ScheduleWakeup`
* `WaitForMcpServers`
* `Workflow`

2 番目のフィルタはバックグラウンドで実行されるサブエージェントに適用されます。`Agent` と `ExitPlanMode` はサブエージェントがどこで実行されても最初のフィルタの条件に従います。それ以外については、バックグラウンドサブエージェントはすべての MCP ツールを保持しますが、組み込みツールは `Read`、`Grep`、`Glob`、`LSP`、`Bash`、`PowerShell`、`Edit`、`Write`、`NotebookEdit`、`WebFetch`、`WebSearch`、`TodoWrite`、`Skill`、`ToolSearch`、`EnterWorktree`、`ExitWorktree`、`Monitor`、`TaskStop`、`SendMessage`、`Artifact` のみを保持し、[`SubagentHandback`](/docs/ja/tools-reference) を通じて報告するサブエージェントはそれも保持します。Claude Code は、継承されたものか `tools` フィールドに列挙されたものかにかかわらず、それ以外のすべての組み込みツールをバックグラウンドサブエージェントから削除するため、同じ定義でもフォアグラウンドとバックグラウンドで異なるツールに解決される場合があります。この削除は、`tools` リストが[何にも解決されなくなる](/docs/ja/errors#agent-would-be-spawned-with-zero-tools)場合を除き、エラーを報告しません。

v2.1.280 より前では、バックグラウンドサブエージェントは `LSP` を使用できませんでした。

[`ListAgents`](/docs/ja/cross-session-messaging)は、他の組み込みツールと同様にこれらのフィルタに従います。フォアグラウンドサブエージェントは、クロスセッションメッセージングが有効なセッションで継承し、バックグラウンドサブエージェントは保持しません。

[エージェントチーム](/docs/ja/agent-teams)のチームメイトは、さらにタスクツールと cron ツールを保持します。`TaskCreate`、`TaskGet`、`TaskList`、`TaskUpdate`、`CronCreate`、`CronDelete`、および `CronList`。

[Task ツールのないセッション](/docs/ja/tools-reference#task-tool-availability)では、Claude Code はサブエージェントにもタスクツールを提供しません。サブエージェントが異なるモデルを実行する場合でも。インプロセスチームメイトはセッションと同じ方法に従いますが、チームメイトが独自の[分割ペイン](/docs/ja/agent-teams#choose-a-display-mode)で実行される場合、別の Claude Code プロセスとして実行されるため、独自のモデルが決定します。

#### サブエージェントが使用できるツールを制限する

ツールを制限するには、`tools` フィールドを許可リストとして、または `disallowedTools` フィールドを拒否リストとして使用します。両方が設定されている場合、`disallowedTools` が最初に適用され、次に `tools` が残りのプールに対して解決されます。両方にリストされているツールは削除されます。

この例は `tools` を使用して、Read、Grep、Glob、および Bash のみを許可します。サブエージェントはファイルを編集、書き込み、または MCP ツールを使用することはできません。

```yaml theme={null}
---
name: safe-researcher
description: Research agent with restricted capabilities
tools: Read, Grep, Glob, Bash
---
```

この例は `disallowedTools` を使用して、Write と Edit を除く利用可能なツールを継承します。サブエージェントは Bash、MCP ツール、およびプールの残りを保持します。

```yaml theme={null}
---
name: no-writes
description: Inherits the available tools except file writes
disallowedTools: Write, Edit
---
```

`tools` リスト内の何もツールに解決されない場合（例えば、すべてのエントリが誤字であるか、サブエージェントで利用できないツールを指定している場合）、Claude Code は通常、サブエージェントの起動を拒否し、Agent ツールは解決されないエントリを示すエラーを返します。メッセージと各エントリの修正方法については、[Agent would be spawned with zero tools](/docs/ja/errors#agent-would-be-spawned-with-zero-tools)を参照してください。

`tools` フィールドと `disallowedTools` フィールドは、MCP サーバー全体を指すエントリも受け入れます。

| 目的 | フィールド | エントリの例 |
| :- | :- | :- |
| 1 つのサーバーのすべてのツールをサブエージェントに与える | `tools` | `mcp__github__*` |
| 1 つのサーバーのツールを除外する | `disallowedTools` | `mcp__github` または `mcp__github__*` |
| すべてのサーバーのすべての MCP ツールを除外する | `disallowedTools` | `mcp__*` |

この例は、`github` MCP サーバーのすべてのツールを削除しながら、他のサーバーのツールと組み込みツールをサブエージェントのプールに保持します。

```yaml theme={null}
---
name: local-only
description: Inherits every tool except those from the github MCP server
disallowedTools: mcp__github
---
```

`disallowedTools` エントリに `Bash(git push *)` などの指定子がある場合、マッチングコマンドのみではなく、ツール全体をサブエージェントから削除します。Bash を保持し、特定のコマンドをブロックするには、設定に [Bash 拒否ルール](/docs/ja/permissions#bash)（`Bash(git push *)` など）を `permissions.deny` に追加します。ルールはメイン会話とサブエージェントに適用されます。

#### スポーンできるサブエージェントを制限する

エージェントが `claude --agent` でメインスレッドとして実行される場合、Agent ツールを使用してサブエージェントをスポーンできます。スポーンできるサブエージェントタイプを制限するには、`tools` フィールドで `Agent(agent_type)` 構文を使用します。

> [!NOTE]
>
> バージョン 2.1.63 では、Task ツールが Agent に名前変更されました。設定とエージェント定義の既存の `Task(...)` 参照は引き続きエイリアスとして機能します。

```yaml theme={null}
---
name: coordinator
description: Coordinates work across specialized agents
tools: Agent(worker, researcher), Read, Bash
---
```

これは許可リストです。`worker` と `researcher` サブエージェントのみをスポーンできます。エージェントが他のタイプをスポーンしようとすると、リクエストは失敗し、エージェントはプロンプトで許可されたタイプのみを見ます。特定のエージェントをブロックしながら他のすべてを許可するには、代わりに [`permissions.deny`](#disable-specific-subagents)を使用します。

制限なしでサブエージェントをスポーンできるようにするには、括弧なしで `Agent` を使用します。

```yaml theme={null}
tools: Agent, Read, Bash
```

`tools` リストから `Agent` を完全に省略した場合、エージェントは Agent ツールでサブエージェントをスポーンできません。

`Agent(agent_type)` 許可リスト構文は、`claude --agent` でメインスレッドとして実行されるエージェントにのみ適用されます。サブエージェント定義では、`tools` に `Agent` をリストするとそのサブエージェントが[深さ制限](#let-subagents-spawn-their-own-subagents)を許可する限り独自のサブエージェントをスポーンできますが、括弧内のタイプリストは無視されます。

#### MCP サーバーをサブエージェントにスコープする

`mcpServers` フィールドを使用して、メイン会話で利用できない[MCP](/docs/ja/mcp)サーバーへのアクセスをサブエージェントに与えます。ここで定義されたインラインサーバーは、サブエージェント開始時に接続され、[エージェントファイルのフォルダの信頼ルール](#inline-server-trust)の対象となり、終了時に切断されます。文字列参照は親セッションの接続を共有します。

> [!NOTE]
>
> `mcpServers` フィールドは、エージェントファイルが実行できる両方のコンテキストに適用されます。
>
> * Agent ツールまたは @-mention を通じてスポーンされたサブエージェント
> * [`--agent`](#invoke-subagents-explicitly)または `agent` 設定で起動されたメインセッション
>
> エージェントがメインセッションの場合、インラインサーバー定義は [`.mcp.json`](/docs/ja/mcp)および設定ファイルのサーバーと一緒に起動時に接続され、[エージェントファイルのフォルダの信頼ルール](#inline-server-trust)の下にあります。`/mcp` では、以前に使用したリモート（HTTP または SSE）サーバーは [`cached` ステータス](/docs/ja/mcp#managing-your-servers)を代わりに表示できます。Claude Code は Claude が最初にそのツールの 1 つを呼び出すときに接続します。

リスト内の各エントリは、インラインサーバー定義またはセッションで既に設定されている MCP サーバーを参照する文字列のいずれかです。

```yaml theme={null}
---
name: browser-tester
description: Tests features in a real browser using Playwright
mcpServers:
  # Inline definition: scoped to this subagent only
  - playwright:
      type: stdio
      command: npx
      args: ["-y", "@playwright/mcp@latest"]
  # Reference by name: reuses an already-configured server
  - github
---

Use the Playwright tools to navigate, screenshot, and interact with pages.
```

インライン定義は `.mcp.json` サーバーエントリと同じスキーマを使用し、サーバー名でキー付けされ、`stdio`、`http`、`sse`、および `ws` タイプをサポートします。

MCP サーバーをメイン会話から完全に除外し、そのツール説明がコンテキストを消費するのを避けるには、`.mcp.json` ではなくここでインラインで定義します。サブエージェントはツールを取得します。親会話は取得しません。

メインセッションに適用される MCP 制限は、サブエージェントのフロントマターで宣言されたサーバーにも適用されます。

* [`--strict-mcp-config`](/docs/ja/cli-reference) および [`--bare`](/docs/ja/cli-reference)
* [エンタープライズ管理 MCP 設定](/docs/ja/managed-mcp)
* [`allowedMcpServers` および `deniedMcpServers` ポリシー](/docs/ja/managed-mcp#policy-based-control-with-allowlists-and-denylists)

これらのいずれかがサーバーをブロックする場合、Claude Code はそのサーバーをスキップし、ブロックされたサーバーを示す警告を表示します。

管理設定の制限は、定義方法に関係なくすべてのサブエージェントに適用されます。`--strict-mcp-config` は、`--agents` または SDK の `agents` オプション経由でインラインで渡すサーバーをフィルタリングしません。これらは呼び出し元による明示的な入力であるためです。

#### インライン MCP サーバーに必要な信頼

Claude Code は、プロジェクトの `.claude/agents/` ディレクトリ、または `--add-dir` ディレクトリの `.claude/agents/` にあるエージェントファイルから[インライン MCP サーバー](#scope-mcp-servers-to-a-subagent)を読み込むのは、[エージェントファイルのあるフォルダを信頼](/docs/ja/permissions#what-runs-before-you-trust-a-folder)した後のみです。v2.1.238 より前では、Claude Code はこれらのサーバーを信頼をチェックせずに読み込んでいました。

* **カウントされない信頼**。親フォルダの信頼、および `-p` または SDK セッションが[設定ファイルのフック](/docs/ja/permissions#what-runs-before-you-trust-a-folder)に対して取得する自動信頼
* **それまで**。Claude Code はそのエージェントファイル内のすべてのインラインサーバーをスキップし、`~/.claude.json` の正確な `projects["<path>"].hasTrustDialogAccepted` キーをデバッグログに書き込みます
* **`--add-dir` ディレクトリ**。信頼されたワークスペースのリポジトリの外側のディレクトリは、その `.claude/agents/` ファイルがワークスペースの信頼を継承しないため、独自の信頼エントリが必要です

Claude Code は、エージェントファイルが来たフォルダの信頼をチェックせずに 2 種類のサーバーを読み込みます。

* 既に設定されているサーバーを参照する名前
* `~/.claude/agents/` のエージェントファイル、`--agents` または SDK `agents` オプションで渡すもの、または管理設定が提供するもの内のインラインサーバー

#### 権限モード

`permissionMode` を設定して、サブエージェントが実行される[権限モード](/docs/ja/permission-modes)を選択します。モードの設定値を使用するため、Manual モードは `default` です。設定を解除した場合、サブエージェントはメイン会話のモードを継承します。

メイン会話の権限モードは、Claude Code が設定した値を使用するかどうかを決定します。

* メイン会話が `bypassPermissions`、`acceptEdits`、または[自動モード](/docs/ja/permission-modes#eliminate-prompts-with-auto-mode)にある場合、サブエージェントはそのモードで実行され、Claude Code は設定した `permissionMode` を無視します。自動モードでは、分類器はメイン会話のブロックおよび許可ルールでサブエージェントのツール呼び出しを評価します。サブエージェントが終了すると、分類器はその作業と最終レポートもレビューしてから、レポートが配信されます。[自動モードがサブエージェントを処理する方法](/docs/ja/permission-modes#eliminate-prompts-with-auto-mode)を参照してください。
* メイン会話が `default`、`dontAsk`、または `plan` モードの場合、サブエージェントは設定した権限モードで実行されます。次の場合は、代わりにメイン会話の権限モードを維持します。
  * `bypassPermissions` を設定した場合。`bypassPermissions` の例外には Claude Code v2.1.267 以降が必要です。
  * `auto` を設定し、サブエージェントで [auto モードが利用できない](/docs/ja/permission-modes#eliminate-prompts-with-auto-mode)場合。例えば、設定ファイルで [`disableAutoMode`](/docs/ja/settings-reference#disableautomode) が設定されている場合や、サブエージェントのモデルが auto モードをサポートしていない場合です。

`permissionMode` はこれらの値を受け入れ、`default` のエイリアスとして `manual` を受け入れます。

| モード | 動作 |
| :- | :- |
| `default` | Manual モード。権限を求めるプロンプト |
| `acceptEdits` | ファイル編集と作業ディレクトリまたは `additionalDirectories` 内のパスの一般的なファイルシステムコマンドを自動受け入れ |
| `auto` | [自動モード](/docs/ja/permission-modes#eliminate-prompts-with-auto-mode)。バックグラウンド分類器がコマンドと保護されたディレクトリ書き込みをレビュー |
| `dontAsk` | プロンプトが表示される呼び出しを自動拒否。ただし、インストールした [mod](/docs/ja/plugins/mods/overview) は[それらの呼び出しの一部](/docs/ja/permissions#precedence-among-rules-hooks-and-mods)を引き続き承認できます。明示的に許可されたツールは引き続き機能します。`AskUserQuestion`、[`requiresUserInteraction`](/docs/ja/mcp#require-approval-for-a-specific-tool)とマークされた MCP ツール、[ネットワークパスからの読み取り](/docs/ja/permissions#network-paths)、および[組織が `ask` に設定した](/docs/ja/mcp#organization-controls-on-connector-tools)コネクタツール（その設定が Claude Code に届くセッションの場合）は、許可していても拒否されます |
| `bypassPermissions` | [権限プロンプトをスキップ](/docs/ja/permission-modes#skip-all-checks-with-bypasspermissions-mode)。サブエージェントはメイン会話がそうである場合のみこのモードで実行されます |
| `plan` | Plan モード（読み取り専用探索） |

#### スキルをサブエージェントにプリロードする

`skills` フィールドを使用して、スキルコンテンツをサブエージェントのコンテキストに起動時に注入します。これにより、実行中にスキルを発見して読み込む必要なく、サブエージェントにドメイン知識を提供します。

```yaml theme={null}
---
name: api-developer
description: Implement API endpoints following team conventions
skills:
  - api-conventions
  - error-handling-patterns
---

Implement API endpoints. Follow the conventions and patterns from the preloaded skills.
```

リストされた各スキルの完全なコンテンツは、リスト内の最初の 32 個の異なる名前まで、起動時にサブエージェントのコンテキストに注入されます。このフィールドはプリロードされるスキルを制御するものであり、サブエージェントがアクセスできるスキルを制御するものではありません。このフィールドがなくても、サブエージェントは実行中に Skill ツールを通じてプロジェクト、ユーザー、およびプラグインスキルを発見して呼び出すことができます。サブエージェントがスキルを呼び出すことを完全に防ぐには、[`tools`](#available-tools) リストから `Skill` を省略するか、`disallowedTools` に追加します。

[`disable-model-invocation: true`](/docs/ja/skills#control-who-invokes-a-skill)を設定するスキルはプリロードできません。プリロードは Claude が呼び出すことができるスキルと同じセットから取得されるためです。これには、Claude が単独で実行できないバンドルされた `/verify` スキルが含まれます。

リストされたスキルが見つからないか無効な場合（例えば、組織のポリシーによって）、Claude Code はスキップし、デバッグログに警告をログします。

> [!NOTE]
>
> これは[スキルをサブエージェントで実行する](/docs/ja/skills#run-skills-in-a-subagent)の逆です。サブエージェント内の `skills` を使用すると、サブエージェントはシステムプロンプトを制御し、スキルコンテンツを読み込みます。スキル内の `context: fork` を使用すると、スキルコンテンツが指定したエージェントに注入されます。どちらの場合も、サブエージェントは会話履歴なしで開始されます。

#### 永続メモリを有効にする

`memory` フィールドはサブエージェントに、会話全体で存続する永続ディレクトリを提供します。サブエージェントはこのディレクトリを使用して、コードベースパターン、デバッグインサイト、アーキテクチャ決定などの知識を時間をかけて構築します。

```yaml theme={null}
---
name: code-reviewer
description: Reviews code for quality and best practices
memory: user
---

You are a code reviewer. As you review code, update your agent memory with
patterns, conventions, and recurring issues you discover.
```

メモリがどの程度広く適用されるべきかに基づいてスコープを選択します。

| スコープ | 場所 | 使用時期 |
| :- | :- | :- |
| `user` | `~/.claude/agent-memory/<name-of-agent>/` | サブエージェントはすべてのプロジェクト全体で学習を記憶すべき |
| `project` | `.claude/agent-memory/<name-of-agent>/` | サブエージェントの知識はプロジェクト固有で、バージョン管理経由で共有可能 |
| `local` | `.claude/agent-memory-local/<name-of-agent>/` | サブエージェントの知識はプロジェクト固有だが、バージョン管理にチェックインすべきではない |

サブエージェントメモリは[自動メモリ](/docs/ja/memory#auto-memory)の一部です。自動メモリをオフにした場合、`autoMemoryEnabled` 設定または `CLAUDE_CODE_DISABLE_AUTO_MEMORY` を使用すると、`memory` フィールドは効果がなく、サブエージェントはメモリ指示またはメモリツールアクセスなしで起動されます。以下で説明します。

メモリが有効な場合。

* サブエージェントのシステムプロンプトには、メモリディレクトリへの読み取りと書き込みの指示が含まれます。
* サブエージェントのシステムプロンプトには、メモリディレクトリの `MEMORY.md` の最初の 200 行または 25KB（どちらか先）も含まれます。その制限を超える場合は `MEMORY.md` をキュレートする指示付き。
* Read、Write、および Edit ツールは自動的に有効になり、サブエージェントはメモリファイルを管理できます。

##### 永続メモリのヒント

* `project` は推奨されるデフォルトスコープです。サブエージェント知識をバージョン管理経由で共有可能にします。
* サブエージェントに作業開始前にメモリを確認するよう依頼します。「このプルリクエストをレビューし、以前に見たパターンについてメモリを確認してください。」
* タスク完了後にメモリを更新するようサブエージェントに依頼します。「完了したので、学習したことをメモリに保存してください。」時間をかけて、これはサブエージェントをより効果的にする知識ベースを構築します。
* メモリ指示をサブエージェントのマークダウンファイルに直接含めて、積極的にメモリを維持します。

  ```markdown theme={null}
  Update your agent memory as you discover codepaths, patterns, library
  locations, and key architectural decisions. This builds up institutional
  knowledge across conversations. Write concise notes about what you found
  and where.
  ```

#### フックを使用した条件付きルール

ツール使用をより動的に制御するには、`PreToolUse` フックを使用して、実行前に操作を検証します。これは、ツールの一部の操作を許可しながら他をブロックする必要がある場合に便利です。

この例は、読み取り専用データベースクエリのみを許可するサブエージェントを作成します。`PreToolUse` フックは、各 Bash コマンド実行前に `command` で指定されたスクリプトを実行します。

```yaml theme={null}
---
name: db-reader
description: Execute read-only database queries
tools: Bash
hooks:
  PreToolUse:
    - matcher: "Bash"
      hooks:
        - type: command
          command: "./scripts/validate-readonly-query.sh"
---
```

Claude Code は[フック入力を JSON として](/docs/ja/hooks#pretooluse-input)stdin 経由でフックコマンドに渡します。検証スクリプトはこの JSON を読み取り、Bash コマンドを抽出し、[終了コード 2](/docs/ja/hooks#exit-code-2-behavior-per-event)で書き込み操作をブロックします。

```bash theme={null}
#!/bin/bash
# ./scripts/validate-readonly-query.sh

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty')

# Block SQL write operations (case-insensitive)
if echo "$COMMAND" | grep -iE '\b(INSERT|UPDATE|DELETE|DROP|CREATE|ALTER|TRUNCATE)\b' > /dev/null; then
  echo "Blocked: Only SELECT queries are allowed" >&2
  exit 2
fi

exit 0
```

macOS および Linux では、スクリプトを実行可能にするか、フックが失敗します。何もブロックしません。

```bash theme={null}
chmod +x ./scripts/validate-readonly-query.sh
```

ルールをテストするには、サブエージェントに `UPDATE` ステートメントを実行するよう依頼します。スクリプトは終了コード 2 で終了し、Claude Code はコマンドをブロックし、サブエージェントは `Blocked: Only SELECT queries are allowed` メッセージを見ます。

完全な入力スキーマについては[フック入力](/docs/ja/hooks#pretooluse-input)を、終了コードが動作に影響する方法については[終了コード](/docs/ja/hooks#exit-code-output)を参照してください。Windows では、PowerShell でフックスクリプトを作成し、[PowerShell でフックを実行](/docs/ja/hooks#windows-powershell-tool)に示すように、フックエントリに `shell: powershell` を追加します。

#### 特定のサブエージェントを無効にする

[設定](/docs/ja/settings-reference#permission-settings)の `deny` 配列にサブエージェントを追加して、Claude が特定のサブエージェントを使用するのを防ぐことができます。`Agent(subagent-name)` 形式を使用します。ここで `subagent-name` はサブエージェントの name フィールドと一致します。

```json theme={null}
{
  "permissions": {
    "deny": ["Agent(Explore)", "Agent(my-custom-agent)"]
  }
}
```

これは組み込みとカスタムサブエージェントの両方で機能します。`--disallowedTools` CLI フラグを使用することもできます。

```bash theme={null}
claude --disallowedTools "Agent(Explore)"
```

権限ルールの詳細については、[権限ドキュメント](/docs/ja/permissions#tool-specific-permission-rules)を参照してください。

### サブエージェント用のフックを定義する

サブエージェントはサブエージェントのライフサイクル中に実行される[フック](/docs/ja/hooks)を定義できます。フックを設定する 2 つの方法があります。

* **サブエージェントの frontmatter で**。そのサブエージェントがアクティブな間のみ実行されるフックを定義
* **`settings.json` で**。セッション全体のフック。サブエージェント内でも発火します。`PreToolUse` および `PostToolUse` などのツールイベントはメイン会話と同じ方法でサブエージェントのツール呼び出しに対して発火し、`SubagentStart` および `SubagentStop` はサブエージェント開始時および終了時に発火します

[設定ファイル、管理ポリシー設定、およびプラグイン](/docs/ja/hooks#hook-locations)からのフックはすべてサブエージェント内に適用されるため、`settings.json` の `PreToolUse` フックはサブエージェントが使用するすべてのツールの前にも実行されます。

#### サブエージェント frontmatter のフック

サブエージェントのマークダウンファイルでフックを直接定義します。これらのフックはその特定のサブエージェントがアクティブな間のみ実行され、終了時にクリーンアップされます。

> [!NOTE]
>
> Frontmatter フックは、Agent ツールまたは @-mention を通じてサブエージェントとしてスポーンされた場合、および [`--agent`](#invoke-subagents-explicitly)または `agent` 設定経由でメインセッションとして実行される場合に発火します。メインセッションの場合、[`settings.json`](/docs/ja/hooks)で定義されたフックと一緒に実行されます。

プロジェクトレベルのサブエージェントの frontmatter フックを実行させるには、エージェントファイルを含むフォルダの[ワークスペース信頼ダイアログ](/docs/ja/permissions#project-allow-rules-and-workspace-trust)を受け入れます。`~/.claude/agents/` のユーザーレベルサブエージェントからのフックと `--agents` で渡す定義は、このステップなしで実行されます。`--add-dir` で信頼されたワークスペースのリポジトリの外側からフォルダを追加した場合、そのフォルダを個別に信頼します。その `.claude/agents/` フックはワークスペースの付与を継承しません。

フォルダを信頼するまで、サブエージェントは引き続き実行されますが、Claude Code は frontmatter フックをスキップし、フォルダを信頼する方法を説明するエラーをデバッグログにログします。これは設定ファイルのフックのルールより厳しいです。親フォルダの信頼は十分ではなく、`-p` セッションは信頼されたとしてカウントされません。[フォルダを信頼する前に実行されるもの](/docs/ja/permissions#what-runs-before-you-trust-a-folder)は 2 つを比較します。v2.1.218 より前では、frontmatter フックは信頼していないフォルダから実行でき、非対話型セッションを含めて実行できました。

すべての[フックイベント](/docs/ja/hooks#hook-events)がサポートされています。サブエージェントの最も一般的なイベントは。

| イベント | マッチャー入力 | 発火時期 |
| :- | :- | :- |
| `PreToolUse` | ツール名 | サブエージェントがツールを使用する前 |
| `PostToolUse` | ツール名 | サブエージェントがツールを使用した後 |
| `Stop` | （なし） | サブエージェントが終了する場合（実行時に `SubagentStop` に変換） |

この例は `PreToolUse` フックで Bash コマンドを検証し、`PostToolUse` でファイル編集後にリンターを実行します。

```yaml theme={null}
---
name: code-reviewer
description: Review code changes with automatic linting
hooks:
  PreToolUse:
    - matcher: "Bash"
      hooks:
        - type: command
          command: "./scripts/validate-command.sh"
  PostToolUse:
    - matcher: "Edit|Write"
      hooks:
        - type: command
          command: "./scripts/run-linter.sh"
---
```

エージェントがサブエージェントとして呼び出される場合、frontmatter の `Stop` フックは自動的に `SubagentStop` イベントに変換されます。

#### サブエージェントイベント用のプロジェクトレベルフック

メインセッションでサブエージェントライフサイクルイベントに応答するフックを `settings.json` で設定します。

| イベント | マッチャー入力 | 発火時期 |
| :- | :- | :- |
| `SubagentStart` | エージェントタイプ名 | サブエージェント実行開始時 |
| `SubagentStop` | エージェントタイプ名 | サブエージェント完了時 |

両方のイベントは、名前でエージェントタイプをターゲットするマッチャーをサポートします。マッチャー値は、プロジェクトレベルおよびユーザーレベルサブエージェントの frontmatter `name`、または[プラグインサブエージェント](/docs/ja/plugins/components#agents)の `my-plugin:db-agent` などのプラグインスコープ識別子です。スコープ付き名にはコロンが含まれるため、[アンカーなし正規表現](/docs/ja/hooks#matcher-patterns)として評価されます。`^my-plugin:db-agent$` のように `^` と `$` でアンカーして、そのエージェントのみをマッチします。

この例は、`db-agent` サブエージェント開始時のみセットアップスクリプトを実行し、サブエージェント停止時にクリーンアップスクリプトを実行します。

```json theme={null}
{
  "hooks": {
    "SubagentStart": [
      {
        "matcher": "db-agent",
        "hooks": [
          { "type": "command", "command": "./scripts/setup-db-connection.sh" }
        ]
      }
    ],
    "SubagentStop": [
      {
        "hooks": [
          { "type": "command", "command": "./scripts/cleanup-db-connection.sh" }
        ]
      }
    ]
  }
}
```

完全なフック設定形式については[フック](/docs/ja/hooks)を参照してください。

## サブエージェントを使う

### 自動委任を理解する

Claude は、リクエスト内のタスクの説明、サブエージェント設定の `description` フィールド、および現在のコンテキストに基づいて、タスクを自動的に委任します。積極的な委任を促すには、サブエージェントの description フィールドに「use proactively」のようなフレーズを含めてください。

説明は簡潔にしてください。サブエージェントの説明の合計が[15,000 トークンの上限](/docs/ja/errors#agent-descriptions-are-over-the-15000-token-limit)を超えると、Claude Code は起動時に警告を表示します。ただし、その場合でもすべてのサブエージェントは読み込まれます。

サブエージェントが[プラグイン](/docs/ja/plugins/overview)で提供されている場合は、1 つずつ確認する代わりに、現実的なプロンプト全体で Claude がどの程度確実にそのサブエージェントへ委任するかを測定できます。[`claude plugin eval`](/docs/ja/plugin-evals) は、各プロンプトをプラグインありとなしで実行し、結果をスコア化します。

### サブエージェントを明示的に呼び出す

自動委任だけでは不十分な場合は、自分でサブエージェントを要求できます。1 回限りの提案からセッション全体のデフォルトまで、段階的な 3 つのパターンがあります。

* **自然言語**: プロンプト内でサブエージェントの名前を挙げます。委任するかどうかは Claude が判断します
* **@ メンション**: 1 つのタスクについて、そのサブエージェントが確実に実行されます
* **セッション全体**: `--agent` フラグまたは `agent` 設定により、セッション全体がそのサブエージェントとして実行されます

自然言語の場合、特別な構文はありません。サブエージェントの名前を挙げれば、Claude は通常そのサブエージェントに委任します。

```text wrap theme={null}
Use the test-runner subagent to fix failing tests
Have the code-reviewer subagent look at my recent changes
```

**サブエージェントを @ メンションする。** ファイルを @ メンションするのと同じ要領で、`@` を入力して入力候補からサブエージェントを選びます。これにより、選択を Claude に任せるのではなく、特定のサブエージェントが確実に実行されます。

```text wrap theme={null}
@"code-reviewer (agent)" look at the auth changes
```

メッセージ全体は引き続き Claude に送られ、Claude はユーザーの依頼内容に基づいてサブエージェントのタスクプロンプトを作成します。@ メンションが制御するのは Claude がどのサブエージェントを呼び出すかであり、そのサブエージェントがどのようなプロンプトを受け取るかではありません。

有効化された[プラグイン](/docs/ja/plugins/overview)が提供するサブエージェントは、`my-plugin:code-reviewer` のようなスコープ付きの名前で入力候補に表示されます。プラグインが[エージェントをサブフォルダーに整理している](#choose-the-subagent-scope)場合は、`my-plugin:review:security` のようになります。セッション内で現在実行中の名前付きバックグラウンドサブエージェントも入力候補に表示され、名前の横にステータスが示されます。

ピッカーを使わずにメンションを手動で入力することもできます。ローカルのサブエージェントには `@agent-<name>`、プラグインのサブエージェントには `@agent-` の後にスコープ付きの名前を続けます（例: `@agent-my-plugin:code-reviewer`）。この形式を入力している間、入力候補にはエージェントではなく一致するファイルが表示されますが、送信時にはエージェントのメンションとして解決されます。

**セッション全体をサブエージェントとして実行する。** [`--agent <name>`](/docs/ja/cli-reference) を渡すと、メインスレッド自体がそのサブエージェントのツール制限とモデルを引き継いだセッションが開始されます。

```bash theme={null}
claude --agent code-reviewer
```

エージェントの[プロンプトが空](#choose-the-subagent-scope)である場合を除き、カスタムサブエージェントのシステムプロンプトは、[`--system-prompt`](/docs/ja/cli-reference) と同様に、デフォルトの Claude Code システムプロンプトを完全に置き換えます。`CLAUDE.md` ファイルとプロジェクトメモリは、エージェントの定義で [`omitClaudeMd`](#supported-frontmatter-fields) が設定されている場合でも、通常のメッセージフローを通じて読み込まれます。独自のプロンプトを持つカスタムエージェントとして `-p` 付きでセッションを実行した場合は、[Git ステータスのスナップショット](/docs/ja/settings-reference#includegitinstructions)もなしで開始されます。

起動時のヘッダーにはエージェント名が `@<name>` として表示されるので、有効になっていることを確認できます。

これは組み込みサブエージェントとカスタムサブエージェントの両方で機能し、この選択はセッションを再開したときにも保持されます。Claude Code は会話とともに、エージェントのツール制限とモデルを復元します。再開時にそのエージェントがもう存在しない場合、セッションはデフォルトのツールで続行され、[そのエージェント名を示す警告](/docs/ja/errors#session-agent-no-longer-available)が表示されます。どちらの場合のシステムプロンプトについても、[再開された会話でのシステムプロンプトフラグ](/docs/ja/cli-reference#system-prompt-flags-in-resumed-conversations)を参照してください。

プラグインが提供するサブエージェントの場合は、エージェント名だけを渡せば Claude Code が見つけます。

```bash theme={null}
claude --agent security-reviewer
```

複数のプラグインが同じ名前のエージェントを提供している場合は、スコープ付きの名前を渡して区別します。

```bash theme={null}
claude --agent my-plugin:security-reviewer
```

プラグインがエージェントを `agents/` ディレクトリのサブフォルダーに配置している場合は、スコープ付きの名前にサブフォルダーを含めます（例: `claude --agent my-plugin:review:security`）。

プロジェクト内のすべてのセッションでデフォルトにするには、`.claude/settings.json` で `agent` を設定します。

```json theme={null}
{
  "agent": "code-reviewer"
}
```

両方が存在する場合は、CLI フラグが設定を上書きします。

### サブエージェントをフォアグラウンドまたはバックグラウンドで実行する

サブエージェントはフォアグラウンドでもバックグラウンドでも実行できます。

* **フォアグラウンドサブエージェント**は、完了するまでメインの会話をブロックします。権限プロンプトは発生した時点でユーザーに渡されます。
* **バックグラウンドサブエージェント**は、ユーザーが作業を続けている間に並行して実行されます。バックグラウンドサブエージェントが権限を必要とするツール呼び出しに達すると、Claude Code はメインセッションにそのプロンプトを表示し、要求しているサブエージェントの名前を示します。承認するとサブエージェントは続行します。Esc を押すと、サブエージェントを停止することなく、その 1 つのツール呼び出しだけを拒否できます。

#### どのサブエージェントがバックグラウンドで実行されるか

何も設定していない場合、Claude がメインの会話から生成したサブエージェントはバックグラウンドで開始されます。

* **`claude -p` と Agent SDK**: Claude は自身の判断で、またはユーザーが求めたときに、待機できます。
* **ローカルマシン上のインタラクティブなターミナルセッション、VS Code、デスクトップアプリのセッション**: Claude がサブエージェントを待機できるようにするには、[デフォルトでオン](#turn-fork-mode-on-or-off)になっている[フォークモードをオフにします](#let-claude-wait-for-a-subagent)。

`context: fork` を持つスキルについては、フォークモードがオンかどうかにかかわらず、Claude Code は代わりに[サブエージェントでスキルを実行する](/docs/ja/skills#run-skills-in-a-subagent)のルールに従います。

#### Claude にサブエージェントを待機させる

1. `CLAUDE_CODE_FORK_SUBAGENT` を `0` に設定して、[フォークモード](#turn-fork-mode-on-or-off)をオフにします。たとえば [`settings.json`](/docs/ja/settings) で次のように設定します。

   ```json theme={null}
   {
     "env": {
       "CLAUDE_CODE_FORK_SUBAGENT": "0"
     }
   }
   ```

2. シェルから `claude` を再度実行するか、VS Code で新しい会話を開きます。

3. 先に結果が必要な場合は、Claude に待機するよう依頼します。たとえば「run the reviewer subagent and wait for its report」のように依頼します。

Claude が待機している間も作業を続けるには、ターミナルで **Ctrl+B** を押すか、VS Code で [**Run in background**](/docs/ja/vs-code#move-a-running-command-or-subagent-to-the-background) をクリックします。

フォークモードをオフにする代わりに [`CLAUDE_CODE_DISABLE_BACKGROUND_TASKS`](/docs/ja/env-vars) 環境変数を `1` に設定した場合、Claude はすべてのサブエージェントを待機し、**Ctrl+B** を含めてバックグラウンドタスクはオフになります。

#### バックグラウンドサブエージェントのツール、権限、結果

バックグラウンドサブエージェントは、フォアグラウンドサブエージェントよりも[小さな組み込みツールセット](#available-tools)で実行されます。ただし、会話のフォークと[再開された](#resume-subagents)フォアグラウンドサブエージェントは例外です。

バックグラウンドサブエージェントは、すべての権限プロンプトをメインセッションに表示します。それらのプロンプトのいずれかに対して、セッションの残りの期間にわたって有効な付与など、その 1 つのツール呼び出しを超えて持続する選択肢で応答すると、Claude Code はその応答をメインの会話を含むセッション全体に適用します。

バックグラウンドサブエージェントは、バックグラウンドの [Bash または PowerShell コマンド](/docs/ja/tools-reference#background-commands)を[自身のターン終了後も実行したまま](/docs/ja/interactive-mode#how-backgrounding-works)にしておくことができます。そのコマンドが終了すると、Claude Code はサブエージェントに通知を送ります。

バックグラウンドサブエージェントの結果は、後のターンで完了通知として Claude に届きます。Claude はその通知を待ってからサブエージェントの結果を報告し、それより前に進捗を尋ねられた場合は、サブエージェントがまだ実行中であると報告します。

#### パネルとタスクリストにおける完了したサブエージェント

Claude Code は、サブエージェントの終了の仕方に応じて、次の 2 つのいずれかの方法で、プロンプト入力の下にあるサブエージェントパネルからバックグラウンドサブエージェントの行を消去します。

* サブエージェントが正常に終了すると、Claude Code はその行を直ちに削除し、[スクリーンリーダーモード](/docs/ja/accessibility)の場合を除き、フッターに `/tasks to see subagents` を 30 秒間表示します。この 30 秒の間に [`/tasks`](/docs/ja/commands) を実行し、サブエージェント上で `Enter` を押すと、そのトランスクリプトを開けます。v2.1.232 より前では、Claude Code は失敗したサブエージェントと同様に、終了後 30 秒間その行を保持し、フッターのヒントは表示していませんでした。
* サブエージェントが失敗した場合、またはユーザーが停止した場合、Claude Code はその行を 30 秒間保持します。もっと早く行を消去するには、行を選択して `x` を押します。

完了したバックグラウンドサブエージェントは、フッターのヒントと同じ 30 秒間、完了済みとしてマークされ、実行中の作業の下に並べられた状態で [`/tasks`](/docs/ja/commands) に一覧表示されたままになります。サブエージェントが終了しても、その詳細ビューは開いたままです。失敗したサブエージェントやユーザーが停止したサブエージェントは一覧から消えます。v2.1.208 より前では、完了したサブエージェントは終了した瞬間に一覧から消え、詳細ビューも閉じていました。

### サブエージェント名

Claude は、Agent ツールの呼び出しで `name` パラメーターを渡すことでサブエージェントに名前を付けることができ、ユーザーに事前に確認せずに自らそうすることもあります。名前を付けるとサブエージェントをアドレス指定できるようになり、Claude はサブエージェントの終了後に[名前でメッセージを送ったり再開したり](#resume-subagents)できます。

[エージェントチーム](/docs/ja/agent-teams)が有効なインタラクティブセッションでは、Claude がメインの会話から `name` 付きで生成したサブエージェントは、代わりにチームメイトとして起動します。ただし、その呼び出しが[フォーク](#fork-the-current-conversation)である場合、または呼び出し自体で `isolation` を渡している場合は除きます。サブエージェントのフロントマターにある `isolation` の値ではこれを防げず、その場合チームメイトはメインセッションの作業ディレクトリで実行されます。[Claude がエージェントチームを開始する方法](/docs/ja/agent-teams#how-claude-starts-agent-teams)を参照してください。

### サブエージェントでの API エラー

何らかの原因で[サブエージェントの応答がストリームの途中で途切れ](/docs/ja/errors#the-response-above-may-be-incomplete)、その部分的な応答にテキストは含まれているもののツール呼び出しが含まれていない場合、Claude Code は実行を終了するのではなく、サブエージェントに続行を促します。これはインタラクティブセッションでも同様です。実行がエラーで終了するのは、それらの続行の試行を使い切った場合のみです。

使用制限や繰り返し発生するサーバーエラーなどの API エラーで実行が終了したサブエージェントは、その失敗を Claude に報告します。Claude が受け取る内容は、サブエージェントがどこで実行されていたかによって異なります。

* **フォアグラウンド**: すでにテキスト出力を生成していたサブエージェントがレート制限、過負荷、またはサーバーエラーによって途中で途切れた場合、Agent ツールはその部分的な出力を、サブエージェントが途中で途切れてタスクを完了しなかったという注記とともに返します。何も生成しなかったサブエージェント、または出力がツール呼び出しのみだったサブエージェントは、[`Agent terminated early due to an API error`](/docs/ja/errors#agent-terminated-early-due-to-an-api-error) とそれに続くエラーの詳細で失敗します。
* **バックグラウンド**: サブエージェントは失敗としてマークされ、終了時に Claude が受け取るメッセージには API エラーの名前とサブエージェントの最後の出力が含まれるため、途中までの作業は失われません。

サブエージェントのレポートが次の行で始まっている場合、そのサブエージェントはフォールバックモデルで終了しています。

```text theme={null}
⚠ This agent switched to <model> because its earlier model could not be used.
```

[フォールバックモデルチェーン](/docs/ja/model-config#fallback-model-chains)を設定していて、サブエージェントがそのモデルを利用できないなど、チェーンが対象とする失敗に遭遇した場合、Claude Code はサブエージェントを、チェーン内でリクエストを受け付ける最初のモデルに切り替えます。サブエージェントはエラーで終了せずに作業を続けます。

根本的な API エラーが解消したら、Claude にタスクの再試行を依頼するか、[サブエージェントを再開](#resume-subagents)してください。

### サブエージェント出力のスキャン

Claude Code は、Claude が読む前に各サブエージェントの最終レポートをスキャンします。サブエージェントは、ユーザーが確認していないファイル、Web ページ、またはコマンド出力を読んでいる可能性があり、それらのソースからのテキストには、メインの会話を狙った指示が含まれている場合があります。スキャンによって何かが削除されたり書き換えられたりすることはありません。レポートで気付く可能性のある変更は次の 2 種類です。

* **バックスラッシュの挿入**: `<system-reminder>` タグや、`Human:` または `Assistant:` で始まる行など、Claude Code 自身の出力を模倣したテキストに、スキャンがバックスラッシュを挿入します。これにより、その模倣は会話の一部と誤認されることなく、通常のテキストとして読まれます。
* **マーカー行**: レポートが `<system-reminder>` のようなタグを模倣している場合、または `bypassPermissions` や `--dangerously-skip-permissions` などの権限設定に言及している場合、スキャンは `[harness: subagent output matched instruction-shaped pattern(s):` で始まる行を先頭に追加します。権限設定への言及にはマーカー行が付きますが、テキスト自体は書かれたとおりのままです。

スキャンは内容が悪意のあるものかどうかを判断せず、レポート内の指示が実行できる内容も変えません。レポートに促されて Claude が行うツール呼び出しは、引き続きセッションの[権限チェック](/docs/ja/permissions)と[サンドボックス化](/docs/ja/sandboxing)を通過します。これは[サブエージェントがアクセスできる範囲を制限すること](#control-subagent-capabilities)の代わりにはなりません。

サブエージェントの結果として Claude に返されるレポートは、サブエージェントの出力であることを示すヘッダーの下に届きます。このヘッダーは、レポート内の指示や承認の主張はサブエージェントの言葉であり、ユーザーからの権限を一切持たないことを明示します。

[バックグラウンドサブエージェントのレポート](#run-subagents-in-foreground-or-background)は完了通知の中に届き、その通知はユーザーからのメッセージではなく自動化されたイベントとしてマークされます。

### 一般的なパターン

#### 大量の出力を伴う操作を分離する

サブエージェントの最も効果的な使い方の 1 つは、大量の出力を生成する操作を分離することです。テストの実行、ドキュメントの取得、ログファイルの処理は、かなりのコンテキストを消費する可能性があります。これらをサブエージェントに委任すると、冗長な出力はサブエージェントのコンテキスト内にとどまり、関連する要約だけがメインの会話に返されます。

```text wrap theme={null}
Use a subagent to run the test suite and report only the failing tests with their error messages
```

#### 並列で調査を実行する

互いに独立した調査では、複数のサブエージェントを生成して同時に作業させます。

```text wrap theme={null}
Research the authentication, database, and API modules in parallel using separate subagents
```

各サブエージェントはそれぞれの領域を独立して調べ、その後 Claude が調査結果を統合します。これは、調査の流れが互いに依存していない場合に最も効果的です。

> [!WARNING]
>
> サブエージェントが完了すると、その結果はメインの会話に返されます。それぞれが詳細な結果を返す多数のサブエージェントを実行すると、かなりのコンテキストを消費する可能性があり、各サブエージェントは実行中にそれ自体のトークンも消費します。

並列で実行し続ける必要がある作業や、1 つのコンテキストウィンドウに収まらない作業は、[別々のセッション](/docs/ja/agents)で実行し、Claude に[セッション間で調査結果を受け渡させます](/docs/ja/cross-session-messaging)。

#### サブエージェントを連鎖させる

複数のステップからなるワークフローでは、サブエージェントを順番に使うよう Claude に依頼します。各サブエージェントはタスクを完了して結果を Claude に返し、Claude は関連するコンテキストを次のサブエージェントに渡します。

```text wrap theme={null}
Use the code-reviewer subagent to find performance issues, then use the optimizer subagent to fix them
```

### サブエージェントとメインの会話のどちらを使うか

次の場合は**メインの会話**を使います。

* タスクに頻繁なやり取りや反復的な改善が必要な場合
* 計画、実装、テストなど、複数のフェーズがかなりのコンテキストを共有する場合
* すばやく的を絞った変更を行う場合
* レイテンシが重要な場合。[フォーク](#fork-the-current-conversation)ではないサブエージェントはまっさらな状態から開始するため、コンテキストの収集に時間がかかることがあります

次の場合は**サブエージェント**を使います。

* タスクが、メインのコンテキストには不要な冗長な出力を生成する場合
* 特定のツール制限や権限を適用したい場合
* 作業が自己完結しており、要約を返せる場合

分離されたサブエージェントのコンテキストではなく、メインの会話のコンテキストで実行される再利用可能なプロンプトやワークフローが必要な場合は、代わりに[スキル](/docs/ja/skills)を検討してください。

会話内にすでにある事柄についての質問には、サブエージェントではなく [`/btw`](/docs/ja/interactive-mode#side-questions-with-%2Fbtw) を使います。これは完全なコンテキストを参照できますが、ツールへのアクセスはなく、回答は履歴に追加されません。

### サブエージェントに独自のサブエージェントを生成させる

デフォルトでは、サブエージェントはメインの会話から 3 階層下まで、独自のサブエージェントを生成できます。深さの上限に達すると、Claude Code は[フォーク](#fork-the-current-conversation)以外のすべてのサブエージェントから `Agent` ツールを取り除くため、上限に達したサブエージェントは委任された作業を自ら行い、1 つの要約を返します。上限に達したフォークは継承したツールリストに `Agent` を保持しますが、そのツールはサブエージェントを生成する代わりにエラーを返します。

ネストされたサブエージェントは、委任されたタスク自体が並列のサブタスクに分かれる場合に適しています。たとえば、検出結果ごとに検証役を送り出すレビュー役のサブエージェントなどです。デフォルトでは、生成元のサブエージェントは、ネストされた各サブエージェントのレポートを待ちます。

* **インタラクティブなターミナルセッション**: バックグラウンドサブエージェントを起動したサブエージェントは終了する前にそれらの結果を待つため、ユーザーに返されるのは最上位のサブエージェントの要約だけです。
* **`claude -p` と Agent SDK**: [フォークモード](#turn-fork-mode-on-or-off)がオンの間、生成元のサブエージェントは待機します。フォークモードをオフにすると、ネストされたサブエージェントは代わりに[バックグラウンド](#run-subagents-in-foreground-or-background)で開始されます。生成元のサブエージェントはバックグラウンドのネストされたサブエージェントを待たず、そのネストされたサブエージェントは生成元より長く実行された場合、メインの会話に報告します。

上限を変更するには、[`CLAUDE_CODE_MAX_SUBAGENT_SPAWN_DEPTH`](/docs/ja/env-vars) に、メインの会話の下に置きたいサブエージェントの階層数を設定します。たとえば、[`settings.json`](/docs/ja/settings) の次のエントリは、ネストを 2 階層までに制限します。

```json theme={null}
{
  "env": {
    "CLAUDE_CODE_MAX_SUBAGENT_SPAWN_DEPTH": "2"
  }
}
```

この値では、サブエージェントは自身の下の第 2 階層に委任でき、その第 2 階層はそれ以上委任できません。ネストをオフにするには `1` を設定します。

ネストされたサブエージェントは最上位のサブエージェントと同じ方法で設定され、同じ[スコープ](#choose-the-subagent-scope)から解決されます。ネストがオンの間に、読み取り専用のままにしておくべきレビュー役など、特定のサブエージェントが生成を行わないようにするには、その [`tools`](#available-tools) リストから `Agent` を除外するか、`disallowedTools` に追加します。

ターミナルでは、Claude Code はプロンプト入力の下にあるサブエージェントパネルにネストされたサブエージェントをツリーとして表示し、パネル内にまだ子孫を持つ各行に、その数を示す `(+N)` を付けます。行を開くと、そのサブエージェントの兄弟と直接の子が、`main` までのパスとともに表示されます。

> [!NOTE]
>
> 以前のバージョンでは、デフォルトが異なっていました。
>
> * **v2.1.172 から v2.1.216**: サブエージェントはデフォルトで最大 5 階層までネストでき、上限は変更できませんでした。
> * **v2.1.217 から v2.1.218**: 上限のデフォルトは 1 だったため、上限を引き上げない限り、サブエージェントは独自のサブエージェントを生成できませんでした。v2.1.219 でデフォルトが 3 に引き上げられました。

### 同時実行サブエージェントの上限

サブエージェントの使用は 2 つの上限で制御され、それぞれに独自の変数があります。この上限は、実行中のサブエージェントが多すぎるときに Claude がさらにサブエージェントを生成するのを止め、[深さの上限](#let-subagents-spawn-their-own-subagents)はサブエージェントのネストの深さを制限します。セッション全体で Claude が生成できるサブエージェントの総数に上限はありません。

デフォルトでは、セッション内で 20 個のサブエージェントが実行中のとき、Agent ツールでさらに生成しようとすると `Concurrent subagent limit reached` で失敗し、そのエラーは Claude に再試行しないよう伝えます。実行中の数が上限を下回ると、再び生成できるようになります。上限を変更するには、[`CLAUDE_CODE_MAX_CONCURRENT_SUBAGENTS`](/docs/ja/env-vars) に任意の正の整数を設定します。[ultracode](/docs/ja/model-config#adjust-effort-level) が有効なセッションは対象外で、そこでは上限が適用されません。Claude Code v2.1.217 以降が必要です。

この上限がブロックするのは Claude が Agent ツールで生成するサブエージェントだけですが、他の実行も同じ枠を占有します。

* [`/subtask`](#fork-the-current-conversation) で開始したセッション内のフォークは、実行中に枠を 1 つ占有し、上限によってブロックされることはありません。
* すでに終了した[サブエージェントの再開](#resume-subagents)は、上限を確認せずに新しい枠を占有するため、再開によって実行中の数が上限を超えることがあります。

[ワークフロー](/docs/ja/workflows)のエージェントや[エージェントチーム](/docs/ja/agent-teams)のチームメイトなど、他の機能が実行するエージェントは、代わりにそれぞれ独自の上限に従います。

### サブエージェントのコンテキストを管理する

#### 起動時に読み込まれるもの

各サブエージェントは、新しく分離されたコンテキストウィンドウで開始します。会話履歴、すでに呼び出したスキル、Claude がすでに読んだファイルは参照できません。Claude はタスクを要約した委任メッセージを作成し、サブエージェントはそこから作業を進めます。例外は[フォーク](#fork-the-current-conversation)で、まっさらな状態から開始する代わりに親の会話を継承します。

フォークではないサブエージェントの初期コンテキストには、次のものが含まれます。

* **システムプロンプト**: Claude Code のシステムプロンプトではなく、エージェント自身のプロンプトに Claude Code が追加する環境の詳細を加えたものです。カスタムサブエージェントは、[markdown 本文](#write-subagent-files)または `prompt` フィールドでこれを定義します。組み込みエージェントには定義済みのプロンプトがあります。
* **タスクメッセージ**: 作業を引き渡すときに Claude が作成する委任プロンプトです。
* **CLAUDE.md ファイル**: `~/.claude/CLAUDE.md`、プロジェクトのルール、`CLAUDE.local.md`、管理ポリシーファイル、プロジェクトの指示として読み込まれる [`AGENTS.md` ファイル](/docs/ja/memory#agents-md)など、メインの会話が読み込む [CLAUDE.md の階層](/docs/ja/memory#how-claude-md-files-load)のすべてのレベルです。組み込みの Explore エージェントと Plan エージェントはこれをスキップします。定義で [`omitClaudeMd`](#supported-frontmatter-fields) が設定されているサブエージェントは、管理ポリシーファイルのみを読み込みます。定義が[管理設定](#choose-the-subagent-scope)から来ている場合は、何も読み込みません。
* **Git ステータス**: サブエージェントの開始時に Claude Code がリポジトリから読み取るスナップショットです。そのリポジトリの[独自の worktree](/docs/ja/worktrees#isolate-subagents-with-worktrees) 内のサブエージェントの場合、スナップショットには worktree のブランチ、ステータス、最近のコミットが表示されます。Git リポジトリの外にいる場合や、スナップショットがオフになっている場合は含まれません。[`includeGitInstructions`](/docs/ja/settings-reference#includegitinstructions) を参照してください。Explore と Plan は、いずれにしてもこれをスキップします。
* **プリロードされたスキル**: エージェントの [`skills` フィールド](#preload-skills-into-subagents)で指定されたスキルの全内容です。組み込みエージェントはスキルをプリロードしません。
* **兄弟エージェントの一覧**: `main` と、セッション内の他のすべての名前付きエージェントを列挙する[システムリマインダー](/docs/ja/glossary#system-reminder)です。それぞれが [`SendMessage`](#resume-subagents) の有効な `to` 値になります。この一覧は、サブエージェントのツールに `SendMessage` が含まれていて、かつ少なくとも 1 つの他のエージェントが名前を持っている場合にのみ表示されます。その名前は、Claude が生成時に付けたものでも、[エージェントチーム](/docs/ja/agent-teams)のチームメイトとして実行されていることによるものでもかまいません。これはサブエージェントの開始時に取得されたスナップショットであるため、後から名前が付けられたエージェントは表示されません。

独自のサブエージェントを、ユーザー、プロジェクト、ローカルの CLAUDE.md ファイルなしで起動するには、そのフロントマターまたは `--agents` の JSON で [`omitClaudeMd: true`](#supported-frontmatter-fields) を設定します。Explore、Plan、および `omitClaudeMd` を持つサブエージェントでも、サブディレクトリ内のファイルを扱うときには、そのサブディレクトリの `CLAUDE.md` と、一致する[パススコープのルール](/docs/ja/memory#path-specific-rules)が[読み込まれます](/docs/ja/memory#how-claude-md-files-load)。

メインの会話は、これらのサブエージェントの結果を読むときにも完全な CLAUDE.md を保持しているため、ほとんどのルールはサブエージェント自体に届く必要はありません。「`vendor/` ディレクトリを無視する」のように、ルールをどうしても届ける必要がある場合は、委任時に Claude に与えるプロンプトでそれを改めて伝えてください。

どのサブエージェントが Git ステータスを受け取るかは変更できません。これをスキップするのは Explore と Plan だけです。

メインの会話の一部の状態は、フォークではないサブエージェントには一切届きません。

* **出力スタイル**: サブエージェントは独自のシステムプロンプトで実行されるため、[フォーク](#fork-the-current-conversation)の場合を除き、[出力スタイル](/docs/ja/output-styles)はその応答に影響しません。
* **自動メモリ**: メインの会話の[自動メモリ](/docs/ja/memory#auto-memory)は読み込まれません。サブエージェントに独自の永続的なメモリを持たせるには、[`memory` フィールド](#enable-persistent-memory)を使います。
* **コンテキストウィンドウのサイズ**: サブエージェントのコンテキストウィンドウのサイズは、親のモデルではなく、サブエージェント自身のモデルによって決まります。より小さなウィンドウを持つモデルに委任すると、そのサブエージェントのウィンドウは小さくなります。

#### サブエージェントを再開する

サブエージェントを呼び出すたびに、以前のインスタンスを続行するのではなく、新しいインスタンスが作成されます。最初からやり直すのではなく、既存のサブエージェントの作業を続けるには、それを再開するよう Claude に依頼します。

再開されたサブエージェントは、以前のすべてのツール呼び出し、結果、推論を含む、完全な会話履歴を保持します。サブエージェントが[独自のバックグラウンドサブエージェント](#let-subagents-spawn-their-own-subagents)を生成していた場合、その履歴には、実行中にそれらが届けた結果も含まれます。サブエージェントはまっさらな状態から始めるのではなく、停止したところから正確に作業を再開します。

* サブエージェントが完了すると、Claude はそのエージェント ID を受け取ります。
* 組み込みの Explore エージェントと Plan エージェントは 1 回限りのもので、エージェント ID を返さないため、Claude はそれらを再開できません。作業を続ける必要がある場合は、`general-purpose` またはカスタムサブエージェントを使います。
* サブエージェントが [`maxTurns`](#supported-frontmatter-fields) の上限で停止すると、Claude Code は返された出力を部分的なものとしてマークし、Claude はサブエージェントを再開して作業を続けさせることができます。

Claude は、エージェントの ID または名前を `to` フィールドに指定して `SendMessage` ツールを使い、サブエージェントを再開します。`SendMessage` を使うのに[エージェントチーム](/docs/ja/agent-teams)を有効にする必要はありません。有効化が必要なのは、`shutdown_request` や `plan_approval_response` などの構造化されたチームプロトコルメッセージだけです。サブエージェントやチームメイトに加えて、セッション間メッセージングが有効なセッションでは、Claude は同じツールを使って、このマシン上または[このマシンの外](/docs/ja/cross-session-messaging#message-sessions-on-other-machines)にある[ユーザーの他の Claude Code セッション](/docs/ja/cross-session-messaging)にメッセージを送ることができます。

サブエージェントを再開するには、以前の作業を続けるよう Claude に依頼します。

```text wrap theme={null}
Use the code-reviewer subagent to review the authentication module
[Agent completes]

Continue that code review and now analyze the authorization logic
[Claude resumes the subagent with full context from previous conversation]
```

Claude が `SendMessage` ツールで完了済みのサブエージェントにメッセージを送ると、そのサブエージェントは新たな `Agent` 呼び出しなしにバックグラウンドで再開します。Claude が `TaskStop` ツールで停止したサブエージェントについても、停止した実行が終了した後は同様です。再開された実行は、[サブエージェントが最初に実行されたときのツールセット](#run-subagents-in-foreground-or-background)を維持し、[元の実行がウォームアップしたプロンプトキャッシュ](/docs/ja/prompt-caching#subagents-and-the-cache)を引き続き読み取ることができます。

`SendMessage` ツールを持つサブエージェントも、そのメッセージを送ることができます。インタラクティブセッションでは、再開されたエージェントは、メインの会話ではなく、自身を再開したサブエージェントに報告します。そのサブエージェントは、自身の作業を終える前にその結果を待ちます。サブエージェントが、自身の起動元など報告先のエージェントにメッセージを送った場合、Claude Code はそのエージェントの結果の送り先を変更せずに、そのエージェントを再開します。

`/tasks` での `x` や SDK の `stop_task` リクエストによってユーザー自身が停止したサブエージェントは、自動的には再開されません。Claude がメッセージを送っても、そのメッセージは拒否され、Claude にはそのエージェントがキャンセルされたことが伝えられます。

[そのサブエージェントの行がまだサブエージェントパネルにある](#run-subagents-in-foreground-or-background)間は、そのトランスクリプトに入力することで自分で再開できます。その後は、Claude からのメッセージで再び自動再開できるようになります。

再開すると同じ ID でエージェントの新しい実行が開始されるため、すでに失敗または完了していたサブエージェントは、タスクリストと Agent SDK のタスクイベントで再び実行中として表示されます。

`SendMessage` は、名前が会話の前の時点で到達したのと同じエージェントを引き続き指しているかどうかを確認します。名前を再利用して再生成されたバックグラウンドエージェントなど、より新しいエージェントがその名前を取得している場合、Claude Code は誤ったエージェントに届けるのではなく送信を拒否し、エラーにはその名前が現在どのエージェントに到達するかが示されるため、Claude は宛先を変更できます。以前のエージェントがまだ実行中の場合にそのエージェントに到達するには、Claude はそのエージェントを生成したときに受け取ったエージェント ID で宛先を指定します。この確認は現在の会話に限定され、`/clear` でリセットされます。

サブエージェントは、自身を起動したエージェントからのメッセージを、タスク途中の軌道修正を含む通常のタスク指示として扱い、自身の権限設定の範囲内でそれに従って行動します。誰がメッセージを送ったかにかかわらず、2 つの制限が適用されます。どのエージェントからのメッセージも、保留中の権限プロンプトに対するユーザーの承認とは見なされません。また、どのエージェントのメッセージも、サブエージェントの権限設定、`CLAUDE.md`、または設定を変更できません。承認を与えられるのは、権限システムまたはユーザー自身のメッセージだけです。

エージェント ID を明示的に参照したい場合は、Claude に尋ねることもできます。また、`~/.claude/projects/{project}/{sessionId}/subagents/` にあるトランスクリプトファイルで ID を確認することもできます。各トランスクリプトは `agent-{agentId}.jsonl` として保存されます。

サブエージェントのトランスクリプトは、メインの会話とは独立して保持されます。

* **メインの会話のコンテキスト圧縮**: メインの会話が圧縮されても、サブエージェントのトランスクリプトは影響を受けません。これらは別のファイルに保存されています。
* **セッションの永続性**: サブエージェントのトランスクリプトは、そのセッション内で保持されます。同じセッションを再開することで、Claude Code を再起動した後でも[サブエージェントを再開](#resume-subagents)できます。
* **自動クリーンアップ**: Claude Code は、[保持期間のスイープルール](/docs/ja/claude-directory#cleaned-up-automatically)に従い、`cleanupPeriodDays` の保持期間（デフォルトは 30 日）が過ぎたサブエージェントのトランスクリプトを削除します。

#### 自動圧縮

サブエージェントは自動圧縮をサポートしています。コンテキスト圧縮は、サブエージェント自身のコンテキストウィンドウが埋まるにつれてトリガーされ、`CLAUDE_AUTOCOMPACT_PCT_OVERRIDE` はサブエージェントにも適用されます。この上書きがいつ有効になるかについては、[環境変数](/docs/ja/env-vars)を参照してください。

圧縮イベントは、サブエージェントのトランスクリプトファイルに記録されます。

```json theme={null}
{
  "type": "system",
  "subtype": "compact_boundary",
  "compactMetadata": {
    "trigger": "auto",
    "preTokens": 167189
  }
}
```

`preTokens` の値は、圧縮が行われる前に使用されていたトークン数を示します。

##### 1 つのサブエージェントに自動圧縮のウィンドウを設定する

1 つのサブエージェントを通常よりも早く圧縮させるには、その[フロントマター](#supported-frontmatter-fields)で `autoCompactWindow` に `100000` から `1000000` までのトークン数を設定します。[`CLAUDE_CODE_AUTO_COMPACT_WINDOW`](/docs/ja/env-vars#variables) を設定している場合、Claude Code が[その変数の値を無視する](/docs/ja/model-config#claude_code_auto_compact_window-values)場合を除き、サブエージェントは代わりにその変数のウィンドウを使用し、このフィールドは効果を持ちません。Claude Code v2.1.296 以降が必要です。

次のフロントマターは、長いログファイルを読むサブエージェントに対して `autoCompactWindow` を 200,000 トークンに設定します。

```yaml theme={null}
---
name: log-reader
description: Reads long log files and reports the errors it finds
autoCompactWindow: 200000
---
```

値は `200000` のようなプレーンな整数で記述してください。フロントマターでは、Claude Code は `200k` を 200 として読み取り、これは許容範囲外になるためです。その場合でもサブエージェントは、このフィールドがないものとして読み込まれ、圧縮されます。Claude Code が値を無視したかどうかを確認するには、シェルで `claude --debug` を実行し、[デバッグログ](#supported-frontmatter-fields)で `invalid autoCompactWindow` を検索します。

値が範囲内なのに変化が見られない場合は、次の原因を確認してください。

* **値が、サブエージェントが本来継承する[自動圧縮のウィンドウ](/docs/ja/model-config#context-window-and-auto-compaction)より小さくない**: より早く圧縮させるには、そのウィンドウより小さい値を設定します。
* **`--agent` または `agent` 設定で、セッション全体をこのサブエージェントとして実行している**: その場合、このフィールドは効果を持ちません。セッションのウィンドウを設定するには、[自動圧縮のウィンドウを設定する](/docs/ja/model-config#set-the-auto-compact-window)を参照してください。

## 現在の会話をフォークする

> [!NOTE]
>
> [エージェントビューがオフになっている](/docs/ja/agent-view#turn-off-agent-view)場合、`/subtask` は利用できず、代わりに `/fork` がフォークされたサブエージェントを開始します。それ以外の場合、`/fork` はセッション全体を新しい[バックグラウンドセッション](/docs/ja/agent-view#from-inside-a-session)にコピーします。

フォークは、これまでの会話全体を継承するサブエージェントです。これにより、サブエージェントが通常提供する入力分離が削除されます。フォークはメインセッションと同じシステムプロンプト、ツール、モデル、およびメッセージ履歴を表示するため、状況を再度説明することなく、サイドタスクを渡すことができます。フォークのツール呼び出しはまだ会話から除外され、最終結果のみが返されるため、メインコンテキストウィンドウはクリーンなままです。フォークを使用する場合は、他のサブエージェントが有用であるには背景が多すぎる場合、または同じ開始点から複数のアプローチを並行して試したい場合です。

フォークモードがオンの間（デフォルトではオンです）、Claude は自らフォークを開始できます。フォークを停止するには、[フォークモードをオフにする](#turn-fork-mode-on-or-off)を参照してください。

`/subtask` の後にタスクを続けることで、フォークモードがオンかどうかに関わらず、自分でフォークを開始できます。Claude Code はフォークにタスクの最初の単語から名前を付けます。次の例は、メインセッションで実装を続ける間に、会話をドラフトテストケースにフォークします：

```text wrap theme={null}
/subtask draft unit tests for the parser changes so far
```

フォークはプロンプト入力の下のパネルに表示され、作業を続ける間にバックグラウンドで実行されます。完了すると、その結果がメイン会話にメッセージとして到着します。次のセクションでは、実行中のフォークを監視して操作するためのパネルコントロールについて説明します。

### 実行中のフォークを観察して操作する

実行中のフォークはプロンプト入力の下のパネルに表示され、メインセッション用に 1 行、各フォーク用に 1 行があります。

フォークが正常に完了すると、Claude Code はその行を削除します。Claude Code は失敗したフォークまたは停止したフォークの行を 30 秒間保持します。これは[他のバックグラウンドサブエージェントと同じ](#run-subagents-in-foreground-or-background)です。v2.1.232 より前では、Claude Code は完了したフォークの行も 30 秒間保持していました。

これらのキーを使用してパネルと対話します：

| キー | アクション |
| :- | :- |
| `↑` / `↓` | 行間を移動 |
| `Enter` | 選択したフォークのトランスクリプトを開き、フォローアップメッセージを送信 |
| `x` | 実行中の場合は選択したフォークを停止するか、実行中でなくなった場合はその行を閉じます。メインセッション行またはトランスクリプトを `Enter` で開いたフォークの行では、`x` はプロンプトに入力します |
| `Esc` | フォーカスをプロンプト入力に戻す |

フォークまたはサブエージェントのトランスクリプトが開いている場合、フォローアップメッセージと[スキル](/docs/ja/skills)はそのエージェントに送信され、組み込みコマンドはメイン会話に送信されます。ただし、次の安全策があります：

* `/compact`、`/clear`、`/rewind` はメイン会話に対して動作するため、このビューからこれらのいずれかを実行する前に、Claude Code は確認を求めます。
* `/model` と `/fast` は、表示しているエージェントではなくメイン会話のモデルと fast mode を設定するため、このビューからは実行されません。その理由は通知で表示されます。

表示しているエージェントが待機中の作業が完了する前にメッセージを読むようにするには、[`Ctrl+Enter` または `Ctrl+X Ctrl+S`](/docs/ja/keybindings#chat-actions) で送信します。エージェントが待機しているシェルコマンドやサブエージェントのうち、[バックグラウンド](/docs/ja/tools-reference#background-commands)に移動できるものはバックグラウンドに移動し、実行を続けます。エージェントが応答を書いている場合、またはバックグラウンドに移動できない作業を待っている場合は、そのまま処理を続け、それが完了した時点でメッセージを読みます。Claude Code v2.1.286 以降が必要です。

### フォークと他のサブエージェントの違い

フォークはメインセッションがその時点で持っているすべてを継承します。他のサブエージェントはその定義から開始します。

| | フォーク | 非フォークサブエージェント |
| :- | :- | :- |
| コンテキスト | 完全な会話履歴 | 渡すプロンプトを使用した新しいコンテキスト |
| システムプロンプトとツール | メインセッションと同じ | サブエージェントの[定義ファイル](#write-subagent-files)から、[バックグラウンド実行用にフィルタリング](#available-tools) |
| モデル | メインセッションと同じ | サブエージェントの `model` フィールドから |
| プロンプトキャッシュ | メインセッションと共有 | 別のキャッシュ |

フォークのシステムプロンプトとツール定義は親と同じであるため、最初のリクエストは親の[プロンプトキャッシュ](/docs/ja/prompt-caching#subagents-and-the-cache)を再利用します。この再利用により、同じコンテキストが必要なタスクの場合、フォークは新しいサブエージェントよりも安価です。

Claude が Agent ツール経由でフォークをスポーンするときに、`isolation: "worktree"` を渡すことができるため、フォークのファイル編集は、チェックアウトではなく、別の git worktree に書き込まれます。フォークはさらにフォークをスポーンできません。

### フォークモードをオフにする

フォークモードでは、Claude が自らフォークを開始できます。Claude がフォークを開始しないようにするには：

* **フォークのみを停止する**：[設定](#disable-specific-subagents)の `permissions.deny` に `"Agent(fork)"` を追加します。
* **フォークモードをオフにする**：[Claude にサブエージェントを待機させる](#let-claude-wait-for-a-subagent)の手順に従って、`CLAUDE_CODE_FORK_SUBAGENT` を `0` に設定します。

フォークモードがオンの間、ローカルマシン上のインタラクティブなターミナル、VS Code、またはデスクトップのセッションでは、Claude は[サブエージェントを待機する](#run-subagents-in-foreground-or-background)こともできません。フォークモードは Claude Code v2.1.302 からデフォルトでオンになっており、インタラクティブなターミナルセッションでは v2.1.232 からオンになっています。

## サブエージェントの例

これらの例は、サブエージェントを構築するための効果的なパターンを示しています。出発点として使用するか、Claude を使用してカスタマイズされたバージョンを生成します。

> [!TIP]
>
> **ベストプラクティス：**
>
> * **焦点を絞ったサブエージェントを設計する：** 各サブエージェントは 1 つの特定のタスクに優れている必要があります
> * **各サブエージェントを単独で指定する説明を書く：** Claude は説明を使用して委譲するかどうかを決定します。各説明は正しいサブエージェントにルーティングするのに十分な具体性を持たせ、組み合わせたセット全体を[15,000 トークン説明予算](#understand-automatic-delegation)内に保ちます
> * **ツールアクセスを制限する：** セキュリティと焦点のために必要な権限のみを付与します
> * **バージョン管理にチェックインする：** プロジェクトサブエージェントをチームと共有します

### コードレビュアー

コードを変更せずにレビューする読み取り専用サブエージェント。この例は、制限されたツールアクセス（Edit と Write を除外）と、何を探すべきか、出力をどのようにフォーマットするかを正確に指定する詳細なプロンプトを使用して、焦点を絞ったサブエージェントを設計する方法を示しています。

```markdown theme={null}
---
name: code-reviewer
description: Expert code review specialist. Proactively reviews code for quality, security, and maintainability. Use immediately after writing or modifying code.
tools: Read, Grep, Glob, Bash
model: inherit
---

You are a senior code reviewer ensuring high standards of code quality and security.

When invoked:
1. Run git diff to see recent changes
2. Focus on modified files
3. Begin review immediately

Review checklist:
- Code is clear and readable
- Functions and variables are well-named
- No duplicated code
- Proper error handling
- No exposed secrets or API keys
- Input validation implemented
- Good test coverage
- Performance considerations addressed

Provide feedback organized by priority:
- Critical issues (must fix)
- Warnings (should fix)
- Suggestions (consider improving)

Include specific examples of how to fix issues.
```

### デバッガー

問題を分析して修正できるサブエージェント。コードレビュアーとは異なり、このサブエージェントはバグの修正にはコード変更が必要なため、Edit を含みます。プロンプトは診断から検証までの明確なワークフローを提供します。

```markdown theme={null}
---
name: debugger
description: Debugging specialist for errors, test failures, and unexpected behavior. Use proactively when encountering any issues.
tools: Read, Edit, Bash, Grep, Glob
---

You are an expert debugger specializing in root cause analysis.

When invoked:
1. Capture error message and stack trace
2. Identify reproduction steps
3. Isolate the failure location
4. Implement minimal fix
5. Verify solution works

Debugging process:
- Analyze error messages and logs
- Check recent code changes
- Form and test hypotheses
- Add strategic debug logging
- Inspect variable states

For each issue, provide:
- Root cause explanation
- Evidence supporting the diagnosis
- Specific code fix
- Testing approach
- Prevention recommendations

Focus on fixing the underlying issue, not the symptoms.
```

### データサイエンティスト

データ分析作業向けのドメイン固有のサブエージェント。この例は、典型的なコーディングタスク以外の特化したワークフロー向けのサブエージェントを作成する方法を示しています。より有能な分析のために `model: sonnet` を明示的に設定します。

```markdown theme={null}
---
name: data-scientist
description: Data analysis expert for SQL queries, BigQuery operations, and data insights. Use proactively for data analysis tasks and queries.
tools: Bash, Read, Write
model: sonnet
---

You are a data scientist specializing in SQL and BigQuery analysis.

When invoked:
1. Understand the data analysis requirement
2. Write efficient SQL queries
3. Use BigQuery command line tools (bq) when appropriate
4. Analyze and summarize results
5. Present findings clearly

Key practices:
- Write optimized SQL queries with proper filters
- Use appropriate aggregations and joins
- Include comments explaining complex logic
- Format results for readability
- Provide data-driven recommendations

For each analysis:
- Explain the query approach
- Document any assumptions
- Highlight key findings
- Suggest next steps based on data

Always ensure queries are efficient and cost-effective.
```

### データベースクエリバリデーター

Bash アクセスを許可しますが、読み取り専用 SQL クエリのみを許可するようにコマンドを検証するサブエージェント。この例は、`tools` フィールドが提供するよりも細かい制御が必要な場合に、`PreToolUse` hooks を使用して条件付き検証を行う方法を示しています。

```markdown theme={null}
---
name: db-reader
description: Execute read-only database queries. Use when analyzing data or generating reports.
tools: Bash
hooks:
  PreToolUse:
    - matcher: "Bash"
      hooks:
        - type: command
          command: "./scripts/validate-readonly-query.sh"
---

You are a database analyst with read-only access. Execute SELECT queries to answer questions about the data.

When asked to analyze data:
1. Identify which tables contain the relevant data
2. Write efficient SELECT queries with appropriate filters
3. Present results clearly with context

You cannot modify data. If asked to INSERT, UPDATE, DELETE, or modify schema, explain that you only have read access.
```

Claude Code は[hook 入力を JSON として](/docs/ja/hooks#pretooluse-input)stdin を通じて hook コマンドに渡します。検証スクリプトはこの JSON を読み取り、実行されるコマンドを抽出し、SQL 書き込み操作のリストに対してチェックします。書き込み操作が検出された場合、スクリプトは[終了コード 2](/docs/ja/hooks#exit-code-2-behavior-per-event)で終了して、stderr を通じて Claude にエラーメッセージを返します。

プロジェクト内の任意の場所に検証スクリプトを作成します。パスは hook 設定の `command` フィールドと一致する必要があります：

```bash theme={null}
#!/bin/bash
# Blocks SQL write operations, allows SELECT queries

# Read JSON input from stdin
INPUT=$(cat)

# Extract the command field from tool_input using jq
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty')

if [ -z "$COMMAND" ]; then
  exit 0
fi

# Block write operations (case-insensitive)
if echo "$COMMAND" | grep -iE '\b(INSERT|UPDATE|DELETE|DROP|CREATE|ALTER|TRUNCATE|REPLACE|MERGE)\b' > /dev/null; then
  echo "Blocked: Write operations not allowed. Use SELECT queries only." >&2
  exit 2
fi

exit 0
```

macOS と Linux では、スクリプトを実行可能にします：

```bash theme={null}
chmod +x ./scripts/validate-readonly-query.sh
```

Windows では、検証スクリプトを PowerShell で記述し、hook エントリに `shell: powershell` を追加します。[PowerShell で hooks を実行する](/docs/ja/hooks#windows-powershell-tool)を参照してください。

hook は stdin を通じて JSON を受け取り、Bash コマンドは `tool_input.command` にあります。終了コード 2 は操作をブロックし、エラーメッセージを Claude にフィードバックします。終了コードと出力の詳細については[Hooks](/docs/ja/hooks#exit-code-output)を参照し、完全な入力スキーマについては[Hook 入力](/docs/ja/hooks#pretooluse-input)を参照してください。

システムプロンプトはサブエージェントに書き込みリクエストを拒否するよう指示するため、hook はバックストップです。サブエージェントが書き込みを試みた場合、Claude Code はコマンドをブロックし、サブエージェントは `Blocked: Write operations not allowed. Use SELECT queries only.` メッセージを表示します。

## 次のステップ

サブエージェントを理解したので、これらの関連機能を探索してください：

* [プラグインでサブエージェントを配布する](/docs/ja/plugins/components#agents)ことで、チームまたはプロジェクト全体でサブエージェントを共有します
* [Claude Code をプログラムで実行する](/docs/ja/headless)ことで、Agent SDK を使用して CI/CD と自動化を行います
* [MCP サーバーを使用する](/docs/ja/mcp)ことで、サブエージェントに外部ツールとデータへのアクセスを提供します
