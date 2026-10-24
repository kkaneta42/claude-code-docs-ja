> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# カスタムサブエージェントの作成

> Claude Code でタスク固有のワークフローと改善されたコンテキスト管理のための特化した AI サブエージェントを作成して使用します。

サブエージェントは、特定の種類のタスクを処理する特化した AI アシスタントです。サイドタスクがメイン会話に検索結果、ログ、または再度参照しないファイルコンテンツで溢れかえる場合に使用します。サブエージェントはそのタスクを独自のコンテキストで実行し、概要のみを返します。同じ種類のワーカーを同じ指示で繰り返し生成する場合は、カスタムサブエージェントを定義します。

各サブエージェントは、カスタムシステムプロンプト、特定のツールアクセス、および独立した権限を備えた独自のコンテキストウィンドウで実行されます。また、独自のリクエストを送信し、これはメイン会話と同じ [使用制限](https://code.claude.com/docs/ja/costs.md#plan-usage-breakdown) にカウントされます。Claude がサブエージェントの説明に一致するタスクに遭遇すると、そのサブエージェントに委譲し、サブエージェントは独立して動作して結果を返します。実際にコンテキスト節約を確認するには、[コンテキストウィンドウの可視化](https://code.claude.com/docs/ja/context-window.md)で、サブエージェントが独自の別のウィンドウで研究を処理するセッションを説明しています。

> [!NOTE]
>
> サブエージェントは単一のセッション内で動作します。多くの独立したセッションを並行して実行し、1 つの場所から監視するには、[バックグラウンドエージェント](https://code.claude.com/docs/ja/agent-view.md)を参照してください。互いにメッセージを渡すセッションについては、[クロスセッションメッセージング](https://code.claude.com/docs/ja/cross-session-messaging.md)を参照してください。Claude が生成および監督する調整されたセッションのチームについては、[エージェントチーム](https://code.claude.com/docs/ja/agent-teams.md)を参照してください。

サブエージェントは以下に役立ちます：

* **コンテキストを保持する** ことで、探索と実装をメインの会話から分離します
* **制約を強制する** ことで、サブエージェントが使用できるツールを制限します
* **設定を再利用する** ことで、ユーザーレベルのサブエージェントをプロジェクト全体で再利用します
* **動作を特化させる** ことで、特定のドメイン向けの焦点を絞ったシステムプロンプトを使用します
* **コストを制御する** ことで、Haiku のような高速で安価なモデルにタスクをルーティングします

Claude は各サブエージェントの説明を使用して、タスクを委譲するかどうかを決定します。サブエージェントを作成するときは、Claude がいつそれを使用するかを知るように、明確な説明を書いてください。

これらの説明はコンテキストを占有するため、短く保ってください。組み込みのサブエージェントを除いたサブエージェントの説明の合計が 15,000 トークンを超える場合、Claude Code は[スタートアップ時に総トークン数を含む警告を表示](https://code.claude.com/docs/ja/errors.md#agent-descriptions-are-over-the-15000-token-limit)します。サブエージェントの `description` フィールドをトリミングし、詳細を各サブエージェントのシステムプロンプトに移動します。システムプロンプトは、そのサブエージェントが実行される場合にのみロードされます。

## 組み込みサブエージェント

Claude Code には、Claude が必要に応じて自動的に使用する組み込みサブエージェントが含まれています。各サブエージェントは親の会話の権限を継承します。ほとんどは制限されたツールセットで実行されます。

Explore と Plan は、調査を高速かつ低コストに保つために、CLAUDE.md ファイルと git ステータスのスナップショットを読み込まずに開始します。その他の組み込みサブエージェントと[カスタムサブエージェント](#configure-subagents)は両方を読み込みます。ただし、カスタムサブエージェントの定義で [`omitClaudeMd`](#supported-frontmatter-fields) を設定すると、ユーザー、プロジェクト、およびローカルの CLAUDE.md ファイルを読み込まずに開始できます。サブエージェントに到達するものの完全な内訳については、[スタートアップ時に読み込まれるもの](#what-loads-at-startup)を参照してください。

**Explore**

コードベースの検索と分析に最適化された高速な読み取り専用エージェント。

* **モデル**: メイン会話のモデル。メイン会話が Fable で実行されている場合、Explore のモデルは接続方法によって異なります。
  * Claude サブスクリプション、Anthropic Console アカウント、または `ANTHROPIC_BASE_URL` 経由で接続する [LLM ゲートウェイ](https://code.claude.com/docs/ja/llm-gateway)を使用する場合、Explore は [`opus` エイリアス](https://code.claude.com/docs/ja/model-config#model-aliases)が解決される Opus モデルで実行されます。
  * Amazon Bedrock、Google Cloud の Agent Platform、Microsoft Foundry、[Claude Platform on AWS](https://code.claude.com/docs/ja/claude-platform-on-aws.md)、または [Claude apps ゲートウェイ](https://code.claude.com/docs/ja/claude-apps-gateway)では、Explore はメイン会話のモデルのままです。
* **ツール**: 読み取り専用ツール。Write と Edit は拒否されます。
* **目的**: ファイル検出、コード検索、コードベース探索

`Explore` という名前の[ユーザーまたはプロジェクトサブエージェント](#choose-the-subagent-scope)は組み込みを上書きし、独自の `model` フィールドを保持します。そのため、`model: haiku` で定義すると、探索をより低コストのモデルで実行できます。Explore を含むすべてのサブエージェントに 1 つのモデルを強制するには、[すべてのサブエージェントを 1 つのモデルで実行](#run-every-subagent-on-one-model)を参照してください。

Claude は、変更を加えずにコードベースを検索または理解する必要がある場合、Explore に委譲します。これにより、探索結果がメイン会話コンテキストから除外されます。

Explore を呼び出すとき、Claude は徹底度レベルを指定します。ターゲット検索の場合は**quick**、バランスの取れた探索の場合は**medium**、包括的な分析の場合は**very thorough**です。

**Plan**

[プランモード](https://code.claude.com/docs/ja/permission-modes.md#analyze-before-you-edit-with-plan-mode)中にプランを提示する前にコンテキストを収集するために使用される研究エージェント。

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
| claude | 独自のモデルはありません。Claude がサブエージェントとして生成する場合は[モデル順序](#choose-a-model)に従います | タスクがより特化したエージェントに適合しない場合。[サブエージェントで利用可能](#available-tools)なすべてのツールを備えたキャッチオール。また、ディスパッチされた[バックグラウンドセッション](https://code.claude.com/docs/ja/agent-view.md)のデフォルトエージェント。[セッションが開始される方法に応じて、開始される権限モード](https://code.claude.com/docs/ja/agent-view.md#permission-mode-model-and-effort)。 |
| statusline-setup | Sonnet | `/statusline`を実行してステータスラインを設定する場合 |
| claude-code-guide | Haiku | Claude Code 機能について質問する場合 |

組み込みサブエージェントはインタラクティブセッションでデフォルトで登録されます。これらを制限するには：

* 特定の組み込みタイプをブロックするには、[特定のサブエージェントを無効にする](#disable-specific-subagents)に示されているように、`permissions.deny`に追加します。
* Claude がサブエージェントに委譲するのを防ぐには、[`permissions.deny`](https://code.claude.com/docs/ja/permissions#tool-specific-permission-rules)で`Agent`ツール自体を拒否します。
* 組み込みの`Explore`および`Plan`サブエージェントのみを削除するには、[`CLAUDE_CODE_DISABLE_EXPLORE_PLAN_AGENTS=1`](https://code.claude.com/docs/ja/env-vars)を設定します。Claude はファイルを直接読み取り、探索し、サブエージェントに委譲しません。Claude Code v2.1.198 以降が必要です。
* [非インタラクティブモード](https://code.claude.com/docs/ja/headless.md)および[Agent SDK](https://code.claude.com/docs/ja/agent-sdk/overview.md)では、[`CLAUDE_AGENT_SDK_DISABLE_BUILTIN_AGENTS=1`](https://code.claude.com/docs/ja/env-vars)を設定して、すべての組み込みタイプを削除し、独自のタイプのみを提供します。

`subagent_type` を省略する Agent ツール呼び出しは、フォールバック先となる `general-purpose` サブエージェントがセッションにない場合、[`subagent_type is required`](https://code.claude.com/docs/ja/errors#subagent-type-is-required) で失敗します。

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

## サブエージェントを設定する

サブエージェントのファイルの場所によって誰が利用できるかが決まり、フロントマターによって何ができるかが決まります。このセクションでは、サブエージェントファイルの配置場所と、サポートされているすべてのフィールドについて説明します。

### サブエージェントのスコープを選択する

サブエージェントファイルは、スコープに応じて異なる場所に保存します。複数のサブエージェントが同じ名前を持つ場合、Claude Code は優先順位の高い場所にあるものを使用します。

| 場所 | スコープ | 優先順位 | 作成方法 |
| :- | :- | :- | :- |
| 管理設定 | 組織全体 | 1（最高） | [管理設定](https://code.claude.com/docs/ja/settings.md)を通じてデプロイ |
| `--agents` CLI フラグ | 現在のセッション | 2 | Claude Code の起動時に JSON を渡す |
| `.claude/agents/` | 現在のプロジェクト | 3 | Claude に依頼するか、ファイルを手動で作成 |
| `~/.claude/agents/` | すべてのプロジェクト | 4 | Claude に依頼するか、ファイルを手動で作成 |
| プラグインの `agents/` ディレクトリ | プラグインが有効な場所 | 5（最低） | [プラグイン](https://code.claude.com/docs/ja/plugins/overview.md)とともにインストール |

**プロジェクトサブエージェント**（`.claude/agents/`）は、特定のコードベースに固有のサブエージェントに最適です。バージョン管理にチェックインすると、チームで共同で使用・改善できます。

プロジェクトサブエージェントは現在の作業ディレクトリから上位へたどって検出されるため、そこからリポジトリのルートまでの間にあるすべての `.claude/agents/` がスキャンされます。これらのネストされたディレクトリのうち複数が同じ `name` を定義している場合、Claude Code は作業ディレクトリに最も近い定義を使用します。

`--add-dir` または `/add-dir` でディレクトリを追加すると、Claude Code はプロジェクトサブエージェントに加えて、そのディレクトリの `.claude/agents/` フォルダも読み込みます。`--add-dir` からほかにどの種類の設定が読み込まれるかについては、[追加ディレクトリ](https://code.claude.com/docs/ja/permissions.md#additional-directories-grant-file-access-not-configuration)を参照してください。`--add-dir` を使わずにプロジェクト間でサブエージェントを共有するには、`~/.claude/agents/` または[プラグイン](https://code.claude.com/docs/ja/plugins/overview.md)を使用します。

**ユーザーサブエージェント**（`~/.claude/agents/`）は、すべてのプロジェクトで利用できる個人用のサブエージェントです。

Claude Code は `.claude/agents/` と `~/.claude/agents/` を再帰的にスキャンするため、定義を `agents/review/` や `agents/research/` などのサブフォルダに整理できます。サブエージェントの識別はフロントマターの `name` フィールドのみによって行われるため、サブディレクトリのパスはサブエージェントの識別方法や呼び出し方法に影響しません。

`name` の値はツリー全体で一意にしてください。同じ `.claude/agents/` ディレクトリ（サブフォルダを含む）の下にある 2 つのファイルが同じ名前を宣言している場合、Claude Code はそのうち 1 つだけを読み込みます。どちらが選ばれるかは文書化された優先順位ではなく、ファイルシステムの読み取り順序によって決まります。ネストされたプロジェクトディレクトリ間では、前述のとおり、作業ディレクトリに最も近い定義が優先されます。[`/doctor`](https://code.claude.com/docs/ja/commands#all-commands) のセットアップチェックは、同じディレクトリ内で名前が重複しているファイルを報告し、1 つを残して名前を変更するか削除することを提案します。

プラグインの `agents/` ディレクトリも再帰的にスキャンされます。プロジェクトスコープやユーザースコープとは異なり、プラグインの `agents/` ディレクトリ内のサブフォルダは[スコープ付き識別子](#invoke-subagents-explicitly)の一部になります。プラグイン `my-plugin` の `agents/review/security.md` にあるファイルは `my-plugin:review:security` として登録されます。

**CLI で定義されたサブエージェント**は、Claude Code の起動時に JSON として渡されます。そのセッションの間だけ存在し、ディスクには保存されないため、簡単なテストや自動化スクリプトに便利です。1 回の `--agents` 呼び出しで複数のサブエージェントを定義できます。

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

[非対話モード](https://code.claude.com/docs/ja/headless.md)では、コマンドラインで渡すには大きすぎる定義のために、`--agents` は同じオブジェクトを含む JSON ファイルへのパスも受け付けます。たとえば、`claude -p --agents ./agents.json "Review my changes"` はそのファイルから定義を読み込みます。対話セッションでは、Claude Code はファイルパスを拒否します。ファイル形式には Claude Code v2.1.281 以降が必要です。

JSON の各トップレベルキーはエージェントの名前で、その値はそのエージェントの定義です。名前を `-` で始めないでください。定義には次のフィールドを指定できます。

* **`prompt`**: エージェントのシステムプロンプトです。ファイルベースのサブエージェントにおける markdown 本文に相当します。`prompt` は空でもかまいません。`prompt` が空で `memory` フィールドのないエージェントを `--agent` でセッションのエージェントとして選択した場合、セッションのシステムプロンプトは変更されません。空の `prompt` には Claude Code v2.1.281 以降が必要です。
* **[フロントマターフィールド](#supported-frontmatter-fields)**: `description`、`tools`、`disallowedTools`、`model`、`permissionMode`、`mcpServers`、`hooks`、`maxTurns`、`autoCompactWindow`、`skills`、`initialPrompt`、`memory`、`effort`、`background`、`omitClaudeMd`、`isolation`。
* **無視されるフィールド**: `color` と `experimental` はここでは受け付けられず、拒否されるのではなく無視されます。

Claude Code が読み込めない値をどう扱うか、およびそのチェックをスキップするフラグと環境変数については、[`Invalid --agents configuration`](https://code.claude.com/docs/ja/errors#invalid-agents-configuration) を参照してください。

**管理サブエージェント**は組織の管理者によってデプロイされます。[管理設定ディレクトリ](https://code.claude.com/docs/ja/managed-settings.md#delivery-mechanisms)内の `.claude/agents/` に markdown ファイルを配置し、プロジェクトサブエージェントやユーザーサブエージェントと同じフロントマター形式を使用します。管理定義は、同じ名前のプロジェクトサブエージェントやユーザーサブエージェントよりも優先されます。

**プラグインサブエージェント**は、インストールした[プラグイン](https://code.claude.com/docs/ja/plugins/overview.md)から提供されます。カスタムサブエージェントとともに自動的に読み込まれ、@ メンションの入力補完にスコープ付きの名前で表示されます。プラグインサブエージェントの作成について詳しくは、[プラグインコンポーネントリファレンス](https://code.claude.com/docs/ja/plugins/components.md#agents)を参照してください。

> [!NOTE]
>
> セキュリティ上の理由から、プラグインサブエージェントは `hooks`、`mcpServers`、`permissionMode` のフロントマターフィールドをサポートしていません。これらのフィールドは、プラグインからエージェントを読み込む際に無視されます。これらが必要な場合は、エージェントファイルを `.claude/agents/` または `~/.claude/agents/` にコピーしてください。`settings.json` または `settings.local.json` の [`permissions.allow`](https://code.claude.com/docs/ja/settings-reference#permissions-allow) にルールを追加することもできますが、これらのルールはプラグインサブエージェントだけでなくセッション全体に適用されます。
>
> プラグインの作成者である場合は、代わりにフックをプラグインの [`hooks/hooks.json`](https://code.claude.com/docs/ja/plugins/components#hooks) に、MCP サーバーをプラグインの [`.mcp.json`](https://code.claude.com/docs/ja/plugins/components#mcp-servers) に含めて配布してください。これらはサブエージェント内だけでなく、プラグインが有効なときは常に適用されます。

サブエージェントの定義を[エージェントチーム](https://code.claude.com/docs/ja/agent-teams.md)のチームメイトとして再利用することもできます。Claude にチームメイトの生成を依頼するときにサブエージェントの種類を指定すると、Claude Code はその定義の一部をチームメイトに適用します。各表示モードでどのスコープとどの部分が適用されるかについては、[チームメイトにサブエージェント定義を使用する](https://code.claude.com/docs/ja/agent-teams.md#use-subagent-definitions-for-teammates)を参照してください。

### サブエージェントファイルを作成する

サブエージェントファイルでは、設定に YAML フロントマターを使用し、その後に Markdown でシステムプロンプトを記述します。

> [!NOTE]
>
> Claude Code は `~/.claude/agents/` と `.claude/agents/` を監視しています。ディスク上でサブエージェントファイルを追加または編集したり、Claude にファイルの作成を依頼したりすると、Claude Code は数秒以内に変更を検出し、次回の委任では更新された定義が使用されます。再起動は必要ありません。
>
> ただし、次の 3 つの場合は再起動が必要です。
>
> * 監視対象はセッション開始時に存在していたディレクトリのみです。そのため、新しい `agents` ディレクトリにそのスコープ最初のエージェントファイルを作成した後は、再起動して読み込んでください。
> * Claude Code は、`--add-dir` または `/add-dir` で追加したディレクトリ内の `.claude/agents/` を監視しません。そこでサブエージェントを追加または編集した後は、再起動して変更を読み込んでください。
> * `--disable-slash-commands` で開始したセッションは、これらのディレクトリをまったく監視しません。

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

フロントマターはサブエージェントのメタデータと設定を定義します。本文はサブエージェントの動作を導くシステムプロンプトになります。サブエージェントが受け取るのはこのシステムプロンプトと、作業ディレクトリなどの基本的な環境情報のみで、Claude Code のシステムプロンプトは受け取りません。

[非対話モード](https://code.claude.com/docs/ja/headless.md)では、[`--append-subagent-system-prompt`](https://code.claude.com/docs/ja/cli-reference#cli-flags) を渡すと、ネストされたサブエージェントを含むすべてのサブエージェントのシステムプロンプトの末尾にテキストを追加できます。ただし、会話自体のプロンプトを再利用する[フォークされたサブエージェント](#fork-the-current-conversation)は除きます。Claude Code v2.1.205 以降が必要です。テキストが長すぎてコマンドラインで渡せない場合は、ファイルに保存し、代わりに `--append-subagent-system-prompt-file` でそのパスを渡してください。ファイルフラグには Claude Code v2.1.261 以降が必要です。

サブエージェントはメインの会話の現在の作業ディレクトリで開始します。サブエージェント内では、`cd` コマンドは Bash ツールや PowerShell ツールの呼び出し間で保持されず、メインの会話の作業ディレクトリにも影響しません。代わりにサブエージェントにリポジトリの分離されたコピーを与えるには、[`isolation: worktree`](#supported-frontmatter-fields) を設定します。

`isolation: worktree` を持つサブエージェントは、Bash コマンドと PowerShell コマンドを自身の worktree 内で実行します。サブエージェントの実行中に worktree ディレクトリが削除された場合など、作業ディレクトリがメインのチェックアウトに解決されるコマンドは、エラーで失敗します。

この作業ディレクトリのチェックは、Claude Code を起動したディレクトリを含むリポジトリ全体を対象とします。セッションが独自のリンクされた [worktree](https://code.claude.com/docs/ja/worktrees.md) で実行されている場合、チェックはその worktree のリンク元であるメインのチェックアウトも対象とします。

Bash コマンドについては、Claude Code はコマンド自体も 2 つの方法でチェックします。

* git をメインのチェックアウトにリダイレクトするコマンドをブロックします。
* コマンドが実行する git が worktree 内にとどまることをコマンドテキストから検証できない場合（たとえば、コマンド名が実行時に算出される場合）、そのコマンドを拒否します。

リダイレクトの手段と形式のルールは、[Claude Code による分離の強制方法](https://code.claude.com/docs/ja/worktrees.md#how-claude-code-enforces-isolation)に記載されています。PowerShell コマンドには作業ディレクトリのチェックのみが適用されます。

[Monitor](https://code.claude.com/docs/ja/tools-reference.md#monitor-tool) コマンドには、Bash コマンドと同じ作業ディレクトリとコマンド内容のチェックが適用されます。

メインの会話自体が worktree で分離されて実行されている場合、Claude Code は同じチェックをセッションと、`isolation: worktree` を持たないサブエージェントを含め、セッションが生成するすべてのサブエージェントに適用します。[Claude Code による分離の強制方法](https://code.claude.com/docs/ja/worktrees.md#how-claude-code-enforces-isolation)を参照してください。

### フロントマターリファレンス

サブエージェントは、ファイル先頭の `---` マーカーで囲まれた YAML [フロントマター](https://code.claude.com/docs/ja/glossary.md#frontmatter)で設定し、閉じの `---` の後に Markdown でシステムプロンプトを記述します。必須なのは `name` と `description` のみです。

複数の単語からなるフィールド名は `maxTurns` や `disallowedTools` のように camelCase を使用し、表と完全に一致させる必要があります。Claude Code は認識できないフィールドをエラーを報告せずに無視します。

* 読み込まれたサブエージェント内のスペルミスのあるフィールドを見つけるには、シェルで [`claude --debug`](https://code.claude.com/docs/ja/cli-reference#cli-flags) を実行し、`~/.claude/debug/<session-id>.txt` にあるデバッグログで `does not recognize or apply` を検索します。デバッグログには、サブエージェントのファイル内で Claude Code が認識しないトップレベルフィールドが最大 5 つ示され、サポートされているフィールドに近い場合は意図されたと思われる名前も示されます。Claude Code v2.1.296 以降が必要です。
* サブエージェントファイルが読み込まれなかった理由を調べるには、[Claude Code がスキップするサブエージェントファイル](#subagent-files-claude-code-skips)を参照してください。

| フィールド | 必須 | 説明 |
| :- | :- | :- |
| `name` | はい | `code-reviewer` や `reviewer-v2` などの、最大 256 文字の一意の識別子。[フック](https://code.claude.com/docs/ja/hooks.md#subagentstart)はこの値を `agent_type` として受け取ります。ファイル名と一致させる必要はありません。名前に `:` を含めることはできません。`:` は `my-plugin:reviewer` などの[プラグインスコープの識別子](https://code.claude.com/docs/ja/plugins/overview.md)用に予約されています |
| `description` | はい | Claude がこのサブエージェントに委任すべきタイミング |
| `tools` | いいえ | サブエージェントが使用できる[ツール](#available-tools)。`Read, Grep, Bash` のようなカンマ区切りの文字列または YAML リストで指定します。省略した場合、サブエージェントが利用できるすべてのツールを継承します。リスト内のどのエントリもツールに解決されない場合、通常サブエージェントはそのエントリを示すエラーとともに[起動に失敗します](https://code.claude.com/docs/ja/errors.md#agent-would-be-spawned-with-zero-tools)。スキルをコンテキストにプリロードするには、ここに `Skill` を列挙するのではなく `skills` フィールドを使用します |
| `disallowedTools` | いいえ | 拒否するツール。継承されたリストまたは指定されたリストから削除されます。形式は `tools` と同じです。`Bash(git push *)` のような指定子付きのエントリでも、[ツール全体が削除されます](#restrict-which-tools-a-subagent-can-use) |
| `model` | いいえ | 使用する[モデル](#choose-a-model): `sonnet`、`opus`、`haiku`、`fable`、`claude-opus-5-5` などの完全なモデル ID、または `inherit`。省略した場合、Claude Code は[サブエージェントのモデルの決定順序](#choose-a-model)に従ってモデルを選択します |
| `permissionMode` | いいえ | [権限モード](#permission-modes): `default`、`acceptEdits`、`auto`、`dontAsk`、`bypassPermissions`、`plan`、または `default` のエイリアスとしての `manual`。[プラグインサブエージェント](#choose-the-subagent-scope)では無視されます |
| `maxTurns` | いいえ | サブエージェントが停止するまでのエージェントターンの最大数。サブエージェントが上限に達すると、Claude Code はその出力を部分的なものとしてマークして返し、Claude はサブエージェントを[再開](#resume-subagents)して続行できます。部分的なマークには Claude Code v2.1.246 以降が必要です |
| `autoCompactWindow` | いいえ | このサブエージェントの[自動圧縮ウィンドウ](#subagent-auto-compact-window)を、`100000` から `1000000` までのトークン数に引き下げます。Claude Code v2.1.296 以降が必要です |
| `skills` | いいえ | 起動時にサブエージェントのコンテキストにプリロードする[スキル](https://code.claude.com/docs/ja/skills.md)。説明だけでなく、スキルの内容全体が注入されます。サブエージェントは、列挙されていないプロジェクト、ユーザー、プラグインのスキルも Skill ツールを通じて引き続き呼び出せます |
| `mcpServers` | いいえ | このサブエージェントが利用できる [MCP サーバー](https://code.claude.com/docs/ja/mcp.md)。各エントリは、設定済みのサーバーを参照するサーバー名（例: `"slack"`）、またはサーバー名をキーとし完全な [MCP サーバー設定](https://code.claude.com/docs/ja/mcp.md#installing-mcp-servers)を値とするインライン定義のいずれかです。[プラグインサブエージェント](#choose-the-subagent-scope)では無視されます |
| `hooks` | いいえ | このサブエージェントにスコープされた[ライフサイクルフック](#define-hooks-for-subagents)。[プラグインサブエージェント](#choose-the-subagent-scope)では無視されます |
| `memory` | いいえ | [永続メモリのスコープ](#enable-persistent-memory): `user`、`project`、または `local`。セッションをまたいだ学習を有効にします |
| `background` | いいえ | `true` に設定すると、Claude が待機を求めた場合でもこのサブエージェントをバックグラウンドに維持します。デフォルトでは、Claude がメインの会話から生成するサブエージェントはすでに[バックグラウンドで開始します](#run-subagents-in-foreground-or-background) |
| `omitClaudeMd` | いいえ | `true` に設定すると、このサブエージェントは[初期コンテキスト](#what-loads-at-startup)にユーザー、プロジェクト、ローカルの CLAUDE.md ファイルを含めずに開始します。[管理ポリシーファイル](https://code.claude.com/docs/ja/memory.md#how-claude-md-files-load)は引き続き読み込まれますが、[管理サブエージェント](#choose-the-subagent-scope)の場合は除きます。必要なものをすべて委任プロンプトから受け取るサブエージェントに使用します。エージェントが `--agent` または `agent` 設定によってメインセッションのエージェントとして実行される場合は無視されます。Claude Code v2.1.271 以降が必要です |
| `effort` | いいえ | このサブエージェントがアクティブなときの effort レベル。セッションの effort レベルを上書きしますが、[`CLAUDE_CODE_EFFORT_LEVEL`](https://code.claude.com/docs/ja/env-vars#variables) 環境変数は上書きしません。オプション: `low`、`medium`、`high`、`xhigh`、`max`。利用可能なレベルはモデルによって異なります。[effort レベルを選択する](#choose-an-effort-level)を参照してください |
| `isolation` | いいえ | `worktree` に設定すると、サブエージェントを一時的な [git worktree](https://code.claude.com/docs/ja/worktrees.md) で実行し、リポジトリの分離されたコピーを与えます。このコピーは、デフォルトでは親セッションの `HEAD` ではなく[デフォルトブランチ](https://code.claude.com/docs/ja/worktrees.md#choose-the-base-branch)から分岐します。サブエージェントが変更を加えなかった場合、worktree は自動的にクリーンアップされます |
| `color` | いいえ | タスクリストとトランスクリプトにおけるサブエージェントの表示カラー。`red`、`blue`、`green`、`yellow`、`purple`、`orange`、`pink`、`cyan` を指定できます |
| `initialPrompt` | いいえ | このエージェントがメインセッションのエージェントとして（`--agent` または `agent` 設定によって）実行される場合に、最初のユーザーターンとして自動送信されます。[コマンド](https://code.claude.com/docs/ja/commands.md)と[スキル](https://code.claude.com/docs/ja/skills.md)は処理されます。ユーザーが指定したプロンプトの前に付加されます。[プラグインサブエージェント](#choose-the-subagent-scope)では無視されます |
| `experimental` | いいえ | 実験的なオプションのマップ。`cacheTtl` キーを `5m` または `1h` に設定すると、このサブエージェントのリクエストの[プロンプトキャッシュの有効期間](https://code.claude.com/docs/ja/prompt-caching.md#choose-the-ttl-yourself)を選択できます。これは[キャッシュ有効期間の優先順位](https://code.claude.com/docs/ja/prompt-caching.md#choose-the-ttl-yourself)におけるフロントマターの位置で適用されます。Claude Code はそれ以外の値を無視し、Claude のサブスクリプションが使用クレジットを使用している間は `1h` を無視し、このフィールドをサブエージェントファイルからのみ読み取ります。Claude Code v2.1.248 以降が必要です |

`cacheTtl` は、フロントマターのトップレベルではなく、`experimental` マップ内に記述します。

```yaml theme={null}
---
name: repo-auditor
description: Audits a large repository and reports what it finds
experimental:
  cacheTtl: 1h
---
```

#### Claude Code がスキップするサブエージェントファイル

プロジェクト、ユーザー、または管理の `agents` ディレクトリ、あるいは `--add-dir` で追加したディレクトリ配下の `agents` ディレクトリにあるファイルについて、フロントマターに次のいずれかの問題がある場合、Claude Code はセッション内で報告せずにそのファイルをスキップします。

* **`name` がない**: Claude Code はそのファイルを、エージェントと並べて置かれたドキュメントとして扱います。
* **開始の `---` がファイルの 1 行目にない**: Claude Code はそのファイルをフロントマターのないものとして読み取り、ドキュメントとして扱います。
* **`name` が `-` で始まる、`:` を含む、または 256 文字を超える**: Claude Code はそのファイルをスキップし、デバッグログにエラーを書き込みます。
* **`name` はあるが `description` がない**: Claude Code はそのファイルをスキップし、デバッグログに理由を書き込みます。
* **YAML を解析できない**: Claude Code はそのファイルからフィールドを一切読み取らずにスキップし、デバッグログに解析エラーを書き込みます。

デバッグログを確認するには、`--debug` を付けて Claude Code を実行します。

フロントマターに `name` がないか解析できない[プラグインサブエージェント](https://code.claude.com/docs/ja/plugins/components.md#agents)は、ファイル名で引き続き読み込まれます。

##### セッション前に `agents` ディレクトリをチェックする

`agents` ディレクトリ内でフロントマターを解析できないファイルを見つけるには、`.claude/agents` や `~/.claude/agents` などのディレクトリに対して `claude plugin validate` を実行します。Claude Code は[指定したディレクトリ](https://code.claude.com/docs/ja/plugins/cli-reference.md#validate-a-directory)のみをチェックし、フロントマターは解析できるが `name` がないファイルは指摘しません。Claude Code v2.1.233 以降が必要です。

### モデルを選択する

`model` フィールドは、サブエージェントが使用するモデルを制御します。

* **モデルエイリアス**: 利用可能なエイリアスのいずれかを使用します: `sonnet`、`opus`、`haiku`、または `fable`
* **完全なモデル ID**: `claude-opus-5-5` や `claude-sonnet-5` などの完全なモデル ID を使用します。`--model` フラグと同じ値を受け付けます
* **inherit**: メインの会話と同じモデルを使用します

Claude がサブエージェントを呼び出す際、その呼び出しに対して `model` パラメータを渡すこともできます。Claude Code は次の順序でサブエージェントのモデルを決定します。

1. 呼び出しごとの `model` パラメータ
2. サブエージェント定義の `model` フロントマター（`inherit` はメインの会話のモデルを選択します）
3. [`CLAUDE_CODE_SUBAGENT_MODEL`](https://code.claude.com/docs/ja/model-config#environment-variables) 環境変数（モデルエイリアスまたはモデル ID に設定した場合）
4. メインの会話のモデル

インストールされた [mod](https://code.claude.com/docs/ja/plugins/mods/overview.md) が [`agent.spawn`](https://code.claude.com/docs/ja/plugins/mods/reference#subagents) フックでモデルを設定している場合、Claude Code は呼び出しごとのパラメータの代わりにそのモデルを使用します。

次の 2 つの場合、呼び出しごとのパラメータまたはフロントマターにおける `opus` などのファミリーエイリアスは、[エイリアスが指すバージョン](https://code.claude.com/docs/ja/model-config.md#model-aliases)ではなくメインの会話のモデルに解決されます。

* **メインの会話のモデルがそのファミリーに属している場合**: サブエージェントは `[1m]` サフィックスを含め、メインの会話とまったく同じモデルで実行されるため、メインの会話と同じ[拡張コンテキスト](https://code.claude.com/docs/ja/model-config.md#extended-context)ウィンドウを得られます。
* **[Anthropic API 以外のプロバイダー](https://code.claude.com/docs/ja/third-party-integrations.md)で、Claude Code がメインの会話のモデルファミリーを判別できない場合**: これは、Amazon Bedrock で Claude Code が基盤モデルに解決していない[アプリケーション推論プロファイル ARN](https://code.claude.com/docs/ja/amazon-bedrock.md#iam-configuration) を使用している場合に発生することがあります。このケースは `opus` エイリアスのみが対象で、[`ANTHROPIC_DEFAULT_OPUS_MODEL`](https://code.claude.com/docs/ja/model-config#environment-variables) を設定している場合は適用されません。その場合、`opus` は設定したモデルに解決されるためです。

`CLAUDE_CODE_SUBAGENT_MODEL` 内のエイリアスは、メインの会話のファミリーを指している場合でも、常にエイリアスが指すバージョンに解決されます。この変数を `inherit` に設定することは、未設定のままにすることと同じです。

`CLAUDE_CODE_SUBAGENT_MODEL` を設定するだけでは、組み込みの Explore サブエージェントと Plan サブエージェントが実行されるモデルは変わりません。変更するには、[すべてのサブエージェントを 1 つのモデルで実行する](#run-every-subagent-on-one-model)を参照してください。

v2.1.251 より前は、`CLAUDE_CODE_SUBAGENT_MODEL` がこの順序の先頭にあり、`model: inherit` を含め、呼び出しごとのパラメータとフロントマターの両方を上書きしていました。

Claude Code は、呼び出しごとのパラメータ、フロントマター、環境変数の値を組織の [`availableModels`](https://code.claude.com/docs/ja/model-config#restrict-model-selection) 許可リストと照合します。ブロックされた値については、別のモデルで代替します。

* ブロックされた値が `opus` などのファミリーエイリアスである場合、Claude Code は `/model` と同じ[代替ルールとプロバイダーの範囲](https://code.claude.com/docs/ja/model-config.md#restrict-model-selection)に従い、許可リストで許可されているそのファミリーの最新バージョンでサブエージェントを実行します。v2.1.222 より前は、ブロックされたファミリーエイリアスについても、Claude Code は継承されたモデルでサブエージェントを実行していました。
* その他のブロックされた値の場合、その代替が機能しないプロバイダーの場合、または許可リストでそのファミリーのどのバージョンも許可されていない場合、Claude Code は代わりに継承されたモデルでサブエージェントを実行します。`CLAUDE_CODE_SUBAGENT_MODEL` を設定している場合、Claude Code はこれらと同じルールの下でまずそのモデルを試します。

対話セッションでは、いずれの代替の場合も、Claude Code は要求されたモデルとサブエージェントが実際に実行されるモデルを示す警告を表示します。

サブエージェントがどのモデルで実行されているかを確認するには、[`/tasks`](https://code.claude.com/docs/ja/commands) を実行します。Claude Code はサブエージェントの行にモデルを表示し、そのサブエージェントに [effort レベル](https://code.claude.com/docs/ja/model-config.md#adjust-effort-level)が設定されている場合はそれも表示します。Claude Code v2.1.242 以降が必要です。

呼び出しごとの `model` パラメータは、サブエージェントが[再開されたり、フォローアップメッセージを送られたり](#resume-subagents)した場合にも適用されるため、サブエージェントはそのモデルのまま維持されます。

v2.1.198 以降、サブエージェントはメインの会話の[拡張思考](https://code.claude.com/docs/ja/model-config.md#extended-thinking)設定も継承します。セッションで思考がオンであればサブエージェントでもオンになり、オフであればオフのままです。サブエージェントごとの思考設定はありません。v2.1.198 より前は、メインの会話の設定にかかわらず、サブエージェントは拡張思考が無効な状態で実行されていました。

#### すべてのサブエージェントを 1 つのモデルで実行する

`CLAUDE_CODE_SUBAGENT_MODEL` はデフォルト値であるため、サブエージェントの定義や Claude が渡すモデルのほうが引き続き優先されます。すべてのサブエージェント、[チームメイト](https://code.claude.com/docs/ja/agent-teams.md#specify-teammates-and-models)、[ワークフローエージェント](https://code.claude.com/docs/ja/workflows.md)に 1 つのモデルを適用するには、`CLAUDE_CODE_SUBAGENT_MODEL_FORCE` も `1` に設定します。Claude Code v2.1.257 以降が必要です。

* 両方の変数を設定した場合、サブエージェントは `CLAUDE_CODE_SUBAGENT_MODEL` のモデルで実行されます。
* `CLAUDE_CODE_SUBAGENT_MODEL_FORCE` のみを設定した場合、サブエージェントはメインの会話のモデルで実行されます。ただし、組み込みの Explore サブエージェントは、[組み込みサブエージェントに記載されているモデル](#built-in-subagents)で実行されます。

たとえば、すべてのサブエージェントを Haiku で実行するには、[設定ファイル](https://code.claude.com/docs/ja/settings.md)の `env` ブロックで両方の変数を設定します。

```json theme={null}
{
  "env": {
    "CLAUDE_CODE_SUBAGENT_MODEL": "haiku",
    "CLAUDE_CODE_SUBAGENT_MODEL_FORCE": "1"
  }
}
```

設定が反映されたことを確認するには、サブエージェントの実行中に [`/tasks`](https://code.claude.com/docs/ja/commands) を実行します。サブエージェントの行に、実行されているモデルが表示されます。

`CLAUDE_CODE_SUBAGENT_MODEL_FORCE` が[オン](https://code.claude.com/docs/ja/env-vars.md)の間、Claude Code はサブエージェント定義の `model` フィールドを無視し、Claude はサブエージェントの開始時にモデルを渡せません。次のサブエージェントは引き続きメインの会話のモデルで実行されます。

* [フォーク](#fork-the-current-conversation)
* `model: inherit` を指定した[サブエージェントで実行されるスキル](https://code.claude.com/docs/ja/skills.md#run-skills-in-a-subagent)

### effort レベルを選択する

サブエージェントを独自の [effort レベル](https://code.claude.com/docs/ja/model-config.md#adjust-effort-level)で実行するには、その定義で [`effort`](#supported-frontmatter-fields) フィールドを設定します。

フォーク以外のサブエージェントを特定の effort レベルで実行するよう Claude に依頼すると、Claude はその呼び出しに `effort` パラメータを渡すこともできます。このパラメータは `effort` フィールドを上書きし、サブエージェントが[再開](#resume-subagents)されたときも有効なままです。[`CLAUDE_CODE_EFFORT_LEVEL`](https://code.claude.com/docs/ja/env-vars#variables) 環境変数は、その両方よりも優先されます。呼び出しごとのパラメータには Claude Code v2.1.292 以降が必要です。

### サブエージェントの機能を制御する

ツールへのアクセス、権限モード、条件付きルールによって、サブエージェントができることを制御できます。

#### 利用可能なツール

サブエージェントは、メインの会話で利用可能な[組み込みツール](https://code.claude.com/docs/ja/tools-reference.md)と MCP ツールを継承しますが、2 つのフィルターによって絞り込まれます。1 つ目はすべてのサブエージェントから少数のツールを削除し、2 つ目は[バックグラウンド](#run-subagents-in-foreground-or-background)で実行されるサブエージェント（デフォルト）の組み込みツールセットを縮小します。macOS、Linux、WSL では、[Glob ツールの動作](https://code.claude.com/docs/ja/tools-reference.md#glob-tool-behavior)で説明されているとおり、メインの会話に Glob ツールと Grep ツールがない場合でも、サブエージェントはそれらを受け取ることがあります。[フォーク](#fork-the-current-conversation)は両方のフィルターをスキップし、メインの会話とまったく同じツールプールを受け取ります。1 つ目のフィルターは、`tools` フィールドに列挙されている場合でも、次のツールを削除します。

* `Agent`（サブエージェントが[深さの上限](#let-subagents-spawn-their-own-subagents)に達している場合）。[フォーク](#fork-the-current-conversation)ではツールは一覧に残りますが、生成する代わりにエラーを返します
* `AskUserQuestion`
* `EndConversation`（メインの会話のみを終了できます。[EndConversation ツールの動作](https://code.claude.com/docs/ja/tools-reference.md#endconversation-tool-behavior)を参照してください）
* `EnterPlanMode`
* `ExitPlanMode`（ただし、サブエージェントの [`permissionMode`](#permission-modes) が `plan` の場合は削除されません）
* `ScheduleWakeup`
* `WaitForMcpServers`
* `Workflow`

2 つ目のフィルターは、バックグラウンドで実行されるサブエージェントに適用されます。サブエージェントがどこで実行されても 1 つ目のフィルターの条件に従う `Agent` と `ExitPlanMode` を除き、バックグラウンドのサブエージェントはすべての MCP ツールを保持しますが、組み込みツールは次のもののみを保持します: `Read`、`Grep`、`Glob`、`LSP`、`Bash`、`PowerShell`、`Edit`、`Write`、`NotebookEdit`、`WebFetch`、`WebSearch`、`TodoWrite`、`Skill`、`ToolSearch`、`EnterWorktree`、`ExitWorktree`、`Monitor`、`TaskStop`、`SendMessage`、`Artifact`。さらに、[`SubagentHandback`](https://code.claude.com/docs/ja/tools-reference) を通じて報告するサブエージェントではそのツールも保持します。Claude Code は、継承されたものか `tools` フィールドに列挙されたものかにかかわらず、それ以外のすべての組み込みツールをバックグラウンドのサブエージェントから削除します。そのため、同じ定義でもフォアグラウンドとバックグラウンドで異なるツールに解決されることがあります。この削除によって `tools` リストが[何にも解決されなくなる](https://code.claude.com/docs/ja/errors.md#agent-would-be-spawned-with-zero-tools)場合を除き、エラーは報告されません。

v2.1.280 より前は、バックグラウンドのサブエージェントは `LSP` を使用できませんでした。

[`ListAgents`](https://code.claude.com/docs/ja/cross-session-messaging) は、他の組み込みツールと同様にこれらのフィルターに従います。セッション間メッセージングが有効なセッションでは、フォアグラウンドのサブエージェントはこれを継承し、バックグラウンドのサブエージェントは保持しません。

[エージェントチーム](https://code.claude.com/docs/ja/agent-teams.md)のチームメイトは、さらにタスクツールと cron ツールを保持します: `TaskCreate`、`TaskGet`、`TaskList`、`TaskUpdate`、`CronCreate`、`CronDelete`、`CronList`。[Task ツールのないセッション](https://code.claude.com/docs/ja/tools-reference.md#task-tool-availability)では、サブエージェントが別のモデルで実行される場合でも、Claude Code はサブエージェントにもタスクツールを提供しません。インプロセスのチームメイトも同様にセッションに従います。分割ペインのチームメイトがタスクツールを持つかどうかを確認するには、[Task ツールの利用可否](https://code.claude.com/docs/ja/tools-reference.md#task-tool-availability)を参照してください。

#### サブエージェントが使用できるツールを制限する

ツールを制限するには、`tools` フィールドを許可リストとして、または `disallowedTools` フィールドを拒否リストとして使用します。両方が設定されている場合、まず `disallowedTools` が適用され、次に残りのプールに対して `tools` が解決されます。両方に列挙されたツールは削除されます。

この例では、`tools` を使用して Read、Grep、Glob、Bash のみを許可しています。サブエージェントはファイルの編集、ファイルの書き込み、MCP ツールの使用ができません。

```yaml theme={null}
---
name: safe-researcher
description: Research agent with restricted capabilities
tools: Read, Grep, Glob, Bash
---
```

この例では、`disallowedTools` を使用して、Write と Edit を除くサブエージェントのツールプールを継承しています。サブエージェントは Bash、MCP ツール、およびプールの残りのツールを保持します。

```yaml theme={null}
---
name: no-writes
description: Inherits the available tools except file writes
disallowedTools: Write, Edit
---
```

すべてのエントリがスペルミスである場合や、サブエージェントが利用できないツールを指定している場合など、`tools` リスト内のどれもツールに解決されない場合、通常 Claude Code はサブエージェントの起動を拒否し、Agent ツールは解決できなかったエントリを示すエラーを返します。メッセージと各エントリの修正方法については、[Agent would be spawned with zero tools](https://code.claude.com/docs/ja/errors.md#agent-would-be-spawned-with-zero-tools) を参照してください。

`tools` フィールドと `disallowedTools` フィールドは、MCP サーバー全体を対象とするエントリも受け付けます。

| 目的 | フィールド | エントリの例 |
| :- | :- | :- |
| 1 つのサーバーのすべてのツールをサブエージェントに与える | `tools` | `mcp__github__*` |
| 1 つのサーバーのツールを除外する | `disallowedTools` | `mcp__github` または `mcp__github__*` |
| すべてのサーバーのすべての MCP ツールを除外する | `disallowedTools` | `mcp__*` |

この例では、`github` MCP サーバーのすべてのツールを削除しつつ、他のサーバーのツールと組み込みツールをサブエージェントのプールに残しています。

```yaml theme={null}
---
name: local-only
description: Inherits every tool except those from the github MCP server
disallowedTools: mcp__github
---
```

`Bash(git push *)` のような指定子付きの `disallowedTools` エントリは、一致するコマンドだけでなく、ツール全体をサブエージェントから削除します。Bash を保持したまま特定のコマンドをブロックするには、設定の `permissions.deny` に `Bash(git push *)` などの [Bash 拒否ルール](https://code.claude.com/docs/ja/permissions.md#bash)を追加します。このルールはメインの会話とサブエージェントの両方に適用されます。

##### 名前に二重アンダースコアを含む MCP サーバー

`reports__v2` のように名前に `__` を含む MCP サーバーのツールをサブエージェントが 1 つも取得できない場合は、サブエージェントの `mcp__` エントリを確認してください。

* **`tools` の場合**: `mcp__` に続けて[サーバーの完全な名前](https://code.claude.com/docs/ja/permissions.md#mcp)と `__*` を記述します（例: `mcp__reports__v2__*`）。末尾の `__*` がないと、`mcp__reports__v2` はそのサーバーのどのツールにも一致しません。
* **`disallowedTools` の場合**: `reports` という名前のサーバーを除外するエントリである `mcp__reports` または `mcp__reports__*` を探します。いずれかのエントリがあると、サブエージェントは `reports__v2` のすべてのツールも失います。これらのツール名も `mcp__reports__` で始まるためです。`reports` サーバーのツールのみを除外するには、代わりに `mcp__reports__run_query` のように 1 つずつ列挙します。

#### 生成できるサブエージェントを制限する

エージェントが `claude --agent` でメインスレッドとして実行される場合、Agent ツールを使用してサブエージェントを生成できます。生成できるサブエージェントの種類を制限するには、`tools` フィールドで `Agent(agent_type)` 構文を使用します。

> [!NOTE]
>
> バージョン 2.1.63 で、Task ツールは Agent に名前が変更されました。設定やエージェント定義内の既存の `Task(...)` 参照は、エイリアスとして引き続き機能します。

```yaml theme={null}
---
name: coordinator
description: Coordinates work across specialized agents
tools: Agent(worker, researcher), Read, Bash
---
```

これは許可リストです。`worker` サブエージェントと `researcher` サブエージェントのみを生成できます。エージェントが他の種類を生成しようとするとリクエストは失敗し、エージェントのプロンプトには許可された種類のみが表示されます。他のすべてを許可しつつ特定のエージェントをブロックするには、代わりに [`permissions.deny`](#disable-specific-subagents) を使用します。

制限なしで任意のサブエージェントの生成を許可するには、括弧なしで `Agent` を使用します。

```yaml theme={null}
tools: Agent, Read, Bash
```

`tools` リストから `Agent` を完全に省略すると、エージェントは Agent ツールでサブエージェントを生成できなくなります。

`Agent(agent_type)` 許可リスト構文は、`claude --agent` でメインスレッドとして実行されるエージェントにのみ適用されます。サブエージェント定義では、`tools` に `Agent` を列挙すると、[深さの上限](#let-subagents-spawn-their-own-subagents)が許す限りそのサブエージェントが独自のサブエージェントを生成できるようになりますが、括弧内の種類リストは無視されます。

#### MCP サーバーをサブエージェントにスコープする

`mcpServers` フィールドを使用すると、メインの会話では利用できない [MCP](https://code.claude.com/docs/ja/mcp.md) サーバーへのアクセスをサブエージェントに与えられます。ここで定義したインラインサーバーは、[エージェントファイルのフォルダに対する信頼ルール](#inline-server-trust)に従って、サブエージェントの開始時に接続され、終了時に切断されます。文字列による参照は、親セッションの接続を共有します。

> [!NOTE]
>
> `mcpServers` フィールドは、エージェントファイルが実行される両方のコンテキストで適用されます。
>
> * Agent ツールまたは @ メンションによって生成されるサブエージェントとして
> * [`--agent`](#invoke-subagents-explicitly) または `agent` 設定で起動されるメインセッションとして
>
> エージェントがメインセッションである場合、インラインサーバー定義は、同じ[エージェントファイルのフォルダに対する信頼ルール](#inline-server-trust)の下で、[`.mcp.json`](https://code.claude.com/docs/ja/mcp) や設定ファイルのサーバーとともに起動時に接続されます。`/mcp` では、以前に使用したリモート（HTTP または SSE）サーバーが代わりに [`cached` ステータス](https://code.claude.com/docs/ja/mcp#managing-your-servers)を表示することがあります。Claude Code は、Claude がそのツールのいずれかを初めて呼び出したときに接続します。

リストの各エントリは、インラインサーバー定義か、セッションですでに設定されている MCP サーバーを参照する文字列のいずれかです。

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

インライン定義は `.mcp.json` のサーバーエントリと同じスキーマを使用し、サーバー名をキーとし、`stdio`、`http`、`sse`、`ws` の各タイプをサポートします。

MCP サーバーをメインの会話から完全に除外し、そのツールの説明がメインの会話でコンテキストを消費しないようにするには、`.mcp.json` ではなくここでインラインで定義します。サブエージェントはツールを取得しますが、親の会話は取得しません。

メインセッションに適用される MCP の制限は、サブエージェントのフロントマターで宣言されたサーバーにも適用されます。

* [`--strict-mcp-config`](https://code.claude.com/docs/ja/cli-reference) と [`--bare`](https://code.claude.com/docs/ja/cli-reference)
* [エンタープライズ管理 MCP 設定](https://code.claude.com/docs/ja/managed-mcp.md)
* [`allowedMcpServers` および `deniedMcpServers` ポリシー](https://code.claude.com/docs/ja/managed-mcp#policy-based-control-with-allowlists-and-denylists)

これらのいずれかがサーバーをブロックした場合、Claude Code はそのサーバーをスキップし、ブロックされたサーバーを示す警告を表示します。

管理設定による制限は、定義方法にかかわらずすべてのサブエージェントに適用されます。`--strict-mcp-config` は、`--agents` または SDK の `agents` オプションでインラインで渡したサーバーをフィルタリングしません。これらは呼び出し元による明示的な入力であるためです。

#### インライン MCP サーバーに必要な信頼

Claude Code は、プロジェクトの `.claude/agents/` ディレクトリ、または `--add-dir` ディレクトリの `.claude/agents/` にあるエージェントファイルからの[インライン MCP サーバー](#scope-mcp-servers-to-a-subagent)を、[エージェントファイルの取得元フォルダを信頼](https://code.claude.com/docs/ja/permissions.md#what-runs-before-you-trust-a-folder)した後にのみ読み込みます。v2.1.238 より前は、Claude Code は信頼を確認せずにこれらのサーバーを読み込んでいました。

* **信頼として扱われないもの**: 親フォルダの信頼、および `-p` セッションや SDK セッションが[設定ファイル内のフック](https://code.claude.com/docs/ja/permissions.md#what-runs-before-you-trust-a-folder)のために得る自動的な信頼
* **信頼するまで**: Claude Code はそのエージェントファイル内のすべてのインラインサーバーをスキップし、`~/.claude.json` 用の正確な `projects["<path>"].hasTrustDialogAccepted` キーをデバッグログに書き込みます
* **`--add-dir` ディレクトリ**: 信頼済みワークスペースのリポジトリ外にあるディレクトリには、独自の信頼エントリが必要です。その `.claude/agents/` ファイルはワークスペースの信頼を継承しないためです

Claude Code は、次の 2 種類のサーバーについては、エージェントファイルの取得元フォルダの信頼を確認せずに読み込みます。

* 設定済みのサーバーを参照する名前
* `~/.claude/agents/` のエージェントファイル、`--agents` または SDK の `agents` オプションで渡したエージェントファイル、あるいは管理設定が提供するエージェントファイル内のインラインサーバー

#### 権限モード

`permissionMode` を設定して、サブエージェントが実行される権限モードを選択します。モードの設定値を使用するため、Manual モードは `default` です。未設定のままにすると、サブエージェントはメインの会話の[権限モード](https://code.claude.com/docs/ja/permission-modes.md)を継承します。

メインの会話の権限モードによって、Claude Code が設定した値を使用するかどうかが決まります。

* メインの会話が `bypassPermissions`、`acceptEdits`、または [auto モード](https://code.claude.com/docs/ja/permission-modes.md#eliminate-prompts-with-auto-mode)の場合、サブエージェントはそれと同じモードで実行され、Claude Code は設定した `permissionMode` を無視します。auto モードでは、分類器がメインの会話のブロックルールと許可ルールを使用してサブエージェントのツール呼び出しを評価します。サブエージェントが終了すると、[auto モードでのサブエージェントの扱い](https://code.claude.com/docs/ja/permission-modes.md#eliminate-prompts-with-auto-mode)で説明されているとおり、分類器は最終レポートが配信される前に、サブエージェントの作業と最終レポートもレビューします。
* メインの会話が `plan` モードの場合、サブエージェントが[エージェントチームのルール](https://code.claude.com/docs/ja/agent-teams.md#have-teammates-plan-before-implementing)の下で[エージェントチームのチームメイト](#subagent-names)として実行される場合を除き、設定した `permissionMode` にかかわらずサブエージェントは plan モードのままになります。`dontAsk` を設定した場合、サブエージェントはプロンプトも表示しません。plan モードで承認を求めることになる操作は、代わりに拒否されます。
* メインの会話が `default` または `dontAsk` モードの場合、サブエージェントは設定した権限モードで実行されます。ただし、次の場合は代わりにメインの会話の権限モードを維持します。
  * `bypassPermissions` を設定した場合。`bypassPermissions` の例外には Claude Code v2.1.267 以降が必要です。
  * `auto` を設定したが、設定ファイルで [`disableAutoMode`](https://code.claude.com/docs/ja/settings-reference#disableautomode) が設定されている場合や、サブエージェントのモデルが auto モードをサポートしていない場合など、サブエージェントで [auto モードが利用できない](https://code.claude.com/docs/ja/permission-modes.md#eliminate-prompts-with-auto-mode)場合。

`permissionMode` は次の値と、`default` のエイリアスとしての `manual` を受け付けます。

| モード | 動作 |
| :- | :- |
| `default` | Manual モード: 権限を求めるプロンプトを表示します |
| `acceptEdits` | 作業ディレクトリまたは `additionalDirectories` 内のパスに対するファイル編集と一般的なファイルシステムコマンドを自動的に承認します |
| `auto` | [auto モード](https://code.claude.com/docs/ja/permission-modes.md#eliminate-prompts-with-auto-mode): バックグラウンドの分類器がコマンドと保護されたディレクトリへの書き込みをレビューします |
| `dontAsk` | プロンプトを表示することになる呼び出しを自動的に拒否します。ただし、インストールした [mod](https://code.claude.com/docs/ja/plugins/mods/overview.md) は[それらの呼び出しの一部](https://code.claude.com/docs/ja/permissions.md#precedence-among-rules-hooks-and-mods)を引き続き承認できます。明示的に許可されたツールは引き続き機能します。`AskUserQuestion`、[`requiresUserInteraction`](https://code.claude.com/docs/ja/mcp#require-approval-for-a-specific-tool) とマークされた MCP ツール、[ネットワークパスからの読み取り](https://code.claude.com/docs/ja/permissions.md#network-paths)、および[組織が `ask` に設定した](https://code.claude.com/docs/ja/mcp#organization-controls-on-connector-tools)コネクタツール（その設定が Claude Code に反映されるセッションの場合）は、許可していても拒否されます |
| `bypassPermissions` | [権限プロンプトをスキップします](https://code.claude.com/docs/ja/permission-modes.md#skip-all-checks-with-bypasspermissions-mode)。サブエージェントがこのモードで実行されるのは、メインの会話がこのモードの場合のみです |
| `plan` | plan モード（読み取り専用の探索） |

#### サブエージェントにスキルをプリロードする

`skills` フィールドを使用して、起動時にサブエージェントのコンテキストにスキルの内容を注入します。これにより、実行中にスキルを検出して読み込む必要なく、サブエージェントにドメイン知識を与えられます。

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

列挙された各スキルの内容全体が、リスト内の最初の 32 個の異なる名前まで、起動時にサブエージェントのコンテキストに注入されます。このフィールドはどのスキルをプリロードするかを制御するものであり、サブエージェントがどのスキルにアクセスできるかを制御するものではありません。このフィールドがなくても、サブエージェントは実行中に Skill ツールを通じてプロジェクト、ユーザー、プラグインのスキルを検出して呼び出せます。サブエージェントがスキルを一切呼び出せないようにするには、[`tools`](#available-tools) リストから `Skill` を省略するか、`disallowedTools` に追加します。

[`disable-model-invocation: true`](https://code.claude.com/docs/ja/skills#control-who-invokes-a-skill) を設定したスキルはプリロードできません。プリロードは Claude が呼び出せるスキルと同じセットから取得されるためです。これには、Claude が単独では実行できないバンドルされた `/verify` スキルも含まれます。

列挙されたスキルが存在しないか、組織のポリシーなどによって無効化されている場合、Claude Code はそれをスキップし、デバッグログに警告を記録します。

> [!NOTE]
>
> これは[サブエージェントでスキルを実行する](https://code.claude.com/docs/ja/skills.md#run-skills-in-a-subagent)ことの逆です。サブエージェントで `skills` を使用する場合、サブエージェントがシステムプロンプトを制御し、スキルの内容を読み込みます。スキルで `context: fork` を使用する場合、スキルの内容は指定したエージェントに注入されます。どちらの場合も、サブエージェントは会話履歴なしで開始します。

#### 永続メモリを有効にする

`memory` フィールドは、会話をまたいで保持される永続ディレクトリをサブエージェントに与えます。サブエージェントはこのディレクトリを使用して、コードベースのパターン、デバッグの知見、アーキテクチャ上の決定などの知識を時間をかけて蓄積します。

```yaml theme={null}
---
name: code-reviewer
description: Reviews code for quality and best practices
memory: user
---

You are a code reviewer. As you review code, update your agent memory with
patterns, conventions, and recurring issues you discover.
```

メモリをどの程度広く適用するかに応じてスコープを選択します。

| スコープ | 場所 | 使用する場面 |
| :- | :- | :- |
| `user` | `~/.claude/agent-memory/<name-of-agent>/` | サブエージェントがすべてのプロジェクトにわたって学習内容を記憶すべき場合 |
| `project` | `.claude/agent-memory/<name-of-agent>/` | サブエージェントの知識がプロジェクト固有で、バージョン管理を通じて共有できる場合 |
| `local` | `.claude/agent-memory-local/<name-of-agent>/` | サブエージェントの知識がプロジェクト固有だが、バージョン管理にチェックインすべきでない場合 |

サブエージェントのメモリは[自動メモリ](https://code.claude.com/docs/ja/memory.md#auto-memory)の一部です。`autoMemoryEnabled` 設定または `CLAUDE_CODE_DISABLE_AUTO_MEMORY` で自動メモリをオフにすると、`memory` フィールドは効果を持たず、サブエージェントは以下で説明するメモリの指示やメモリツールへのアクセスなしで起動します。

メモリが有効な場合:

* サブエージェントのシステムプロンプトに、メモリディレクトリの読み書きに関する指示が含まれます。
* サブエージェントのシステムプロンプトには、メモリディレクトリ内の `MEMORY.md` の最初の 200 行または 25KB のいずれか先に達したほうも含まれ、その上限を超えた場合に `MEMORY.md` を整理するよう指示されます。
* サブエージェントがメモリファイルを管理できるように、Read、Write、Edit ツールが自動的に有効になります。

##### 永続メモリのヒント

* `project` が推奨されるデフォルトのスコープです。サブエージェントの知識をバージョン管理を通じて共有できます。
* 作業を開始する前にメモリを参照するようサブエージェントに依頼します:「この PR をレビューして。以前に見たパターンがないかメモリを確認して。」
* タスクの完了後にメモリを更新するようサブエージェントに依頼します:「完了したら、学んだことをメモリに保存して。」時間が経つにつれて、サブエージェントをより効果的にするナレッジベースが構築されます。
* サブエージェントが自らのナレッジベースを積極的に維持するよう、サブエージェントの markdown ファイルにメモリの指示を直接含めます。

  ```markdown theme={null}
  Update your agent memory as you discover codepaths, patterns, library
  locations, and key architectural decisions. This builds up institutional
  knowledge across conversations. Write concise notes about what you found
  and where.
  ```

#### フックによる条件付きルール

ツールの使用をより動的に制御するには、`PreToolUse` フックを使用して操作の実行前に検証します。これは、あるツールの一部の操作を許可しつつ他の操作をブロックする必要がある場合に便利です。

この例では、読み取り専用のデータベースクエリのみを許可するサブエージェントを作成します。`PreToolUse` フックは、各 Bash コマンドの実行前に `command` で指定されたスクリプトを実行します。

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

Claude Code は、stdin を介してフックコマンドに[フック入力を JSON として渡します](https://code.claude.com/docs/ja/hooks.md#pretooluse-input)。検証スクリプトはこの JSON を読み取り、Bash コマンドを抽出し、書き込み操作をブロックするために[終了コード 2 で終了します](https://code.claude.com/docs/ja/hooks.md#exit-code-2-behavior-per-event)。

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

macOS と Linux では、スクリプトを実行可能にしてください。そうしないと、フックは何もブロックせずに失敗します。

```bash theme={null}
chmod +x ./scripts/validate-readonly-query.sh
```

ルールをテストするには、サブエージェントに `UPDATE` ステートメントを実行するよう依頼します。スクリプトは終了コード 2 で終了し、Claude Code はコマンドをブロックし、サブエージェントには `Blocked: Only SELECT queries are allowed` メッセージが表示されます。

完全な入力スキーマについては[フック入力](https://code.claude.com/docs/ja/hooks.md#pretooluse-input)を、終了コードが動作にどう影響するかについては[終了コード](https://code.claude.com/docs/ja/hooks.md#exit-code-output)を参照してください。Windows では、[PowerShell でのフックの実行](https://code.claude.com/docs/ja/hooks.md#windows-powershell-tool)に示されているように、フックスクリプトを PowerShell で記述し、フックエントリに `shell: powershell` を追加します。

#### 特定のサブエージェントを無効にする

[設定](https://code.claude.com/docs/ja/settings-reference.md#permission-settings)の `deny` 配列に追加することで、Claude が特定のサブエージェントを使用できないようにできます。`Agent(subagent-name)` の形式を使用し、`subagent-name` はサブエージェントの name フィールドと一致させます。

```json theme={null}
{
  "permissions": {
    "deny": ["Agent(Explore)", "Agent(my-custom-agent)"]
  }
}
```

これは組み込みサブエージェントとカスタムサブエージェントの両方で機能します。`--disallowedTools` CLI フラグを使用することもできます。

```bash theme={null}
claude --disallowedTools "Agent(Explore)"
```

権限ルールについて詳しくは、[権限のドキュメント](https://code.claude.com/docs/ja/permissions.md#tool-specific-permission-rules)を参照してください。

### サブエージェントのフックを定義する

サブエージェントは、サブエージェントのライフサイクル中に実行される[フック](https://code.claude.com/docs/ja/hooks.md)を定義できます。フックを設定する方法は 2 つあります。

* **サブエージェントのフロントマター内**: そのサブエージェントがアクティブな間のみ実行されるフックを定義します
* **`settings.json` 内**: サブエージェント内でも発火するセッション全体のフックを定義します。`PreToolUse` や `PostToolUse` などのツールイベントは、メインの会話と同じようにサブエージェントのツール呼び出しに対して発火し、`SubagentStart` と `SubagentStop` はサブエージェントの開始時または終了時に発火します

[設定ファイル、管理ポリシー設定、プラグイン](https://code.claude.com/docs/ja/hooks.md#hook-locations)からのフックはすべてサブエージェント内で適用されるため、`settings.json` の `PreToolUse` フックは、サブエージェントが使用するすべてのツールの前にも実行されます。

#### サブエージェントのフロントマター内のフック

サブエージェントの markdown ファイルに直接フックを定義します。これらのフックは、その特定のサブエージェントがアクティブな間のみ実行され、終了時にクリーンアップされます。

> [!NOTE]
>
> フロントマターのフックは、エージェントが Agent ツールまたは @ メンションによってサブエージェントとして生成された場合と、エージェントが [`--agent`](#invoke-subagents-explicitly) または `agent` 設定によってメインセッションとして実行される場合に発火します。メインセッションの場合、これらは [`settings.json`](https://code.claude.com/docs/ja/hooks) で定義されたフックとともに実行されます。

プロジェクトレベルのサブエージェントのフロントマターのフックを実行できるようにするには、エージェントファイルを含むフォルダについて[ワークスペースの信頼ダイアログ](https://code.claude.com/docs/ja/permissions.md#project-allow-rules-and-workspace-trust)を承認します。`~/.claude/agents/` にあるユーザーレベルのサブエージェントのフックと、`--agents` で渡した定義のフックは、この手順なしで実行されます。信頼済みワークスペースのリポジトリ外から `--add-dir` でフォルダを追加した場合は、そのフォルダを別途信頼してください。その `.claude/agents/` のフックはワークスペースの許可を継承しません。

フォルダを信頼するまで、サブエージェントは引き続き実行されますが、Claude Code はそのフロントマターのフックをスキップし、フォルダを信頼する方法を説明するエラーをデバッグログに記録します。これは設定ファイル内のフックに対するルールよりも厳格なルールです。親フォルダを信頼するだけでは不十分で、`-p` セッションは信頼済みとして扱われません。[フォルダを信頼する前に実行されるもの](https://code.claude.com/docs/ja/permissions.md#what-runs-before-you-trust-a-folder)で 2 つを比較しています。v2.1.218 より前は、非対話セッションを含め、信頼していないフォルダからでもフロントマターのフックが実行される可能性がありました。

すべての[フックイベント](https://code.claude.com/docs/ja/hooks.md#hook-events)がサポートされています。サブエージェントで最も一般的なイベントは次のとおりです。

| イベント | matcher の入力 | 発火するタイミング |
| :- | :- | :- |
| `PreToolUse` | ツール名 | サブエージェントがツールを使用する前 |
| `PostToolUse` | ツール名 | サブエージェントがツールを使用した後 |
| `Stop` | （なし） | サブエージェントが終了したとき（実行時に `SubagentStop` に変換されます） |

この例では、`PreToolUse` フックで Bash コマンドを検証し、`PostToolUse` でファイル編集後にリンターを実行します。

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

エージェントがサブエージェントとして呼び出された場合、フロントマター内の `Stop` フックは自動的に `SubagentStop` イベントに変換されます。

#### サブエージェントイベント用のプロジェクトレベルのフック

メインセッションでサブエージェントのライフサイクルイベントに応答するフックを `settings.json` で設定します。

| イベント | matcher の入力 | 発火するタイミング |
| :- | :- | :- |
| `SubagentStart` | エージェントの種類名 | サブエージェントが実行を開始したとき |
| `SubagentStop` | エージェントの種類名 | サブエージェントが完了したとき |

どちらのイベントも、名前で特定のエージェントの種類を対象とする matcher をサポートしています。matcher の値は、プロジェクトレベルおよびユーザーレベルのサブエージェントではエージェントのフロントマターの `name`、[プラグインサブエージェント](https://code.claude.com/docs/ja/plugins/components.md#agents)では `my-plugin:db-agent` などのプラグインスコープの識別子です。スコープ付きの名前にはコロンが含まれるため、[アンカーなしの正規表現](https://code.claude.com/docs/ja/hooks.md#matcher-patterns)として評価されます。そのエージェントのみに一致させるには、`^my-plugin:db-agent$` のように `^` と `$` でアンカーしてください。

この例では、`db-agent` サブエージェントが開始したときにのみセットアップスクリプトを実行し、いずれかのサブエージェントが停止したときにクリーンアップスクリプトを実行します。

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

完全なフック設定形式については、[フック](https://code.claude.com/docs/ja/hooks.md)を参照してください。

## サブエージェントを使う

### 自動委任を理解する

Claude は、リクエスト内のタスクの説明、サブエージェント設定の `description` フィールド、および現在のコンテキストに基づいて、タスクを自動的に委任します。積極的な委任を促すには、サブエージェントの description フィールドに「use proactively」のようなフレーズを含めてください。

説明は簡潔にしてください。サブエージェントの説明の合計が[15,000 トークンの上限](https://code.claude.com/docs/ja/errors.md#agent-descriptions-are-over-the-15000-token-limit)を超えると、Claude Code は起動時に警告を表示します。ただし、その場合でもすべてのサブエージェントは読み込まれます。

サブエージェントが[プラグイン](https://code.claude.com/docs/ja/plugins/overview.md)で提供されている場合は、1 つずつ確認する代わりに、現実的なプロンプト全体で Claude がどの程度確実にそのサブエージェントへ委任するかを測定できます。[`claude plugin eval`](https://code.claude.com/docs/ja/plugin-evals) は、各プロンプトをプラグインありとなしで実行し、結果をスコア化します。

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

有効化された[プラグイン](https://code.claude.com/docs/ja/plugins/overview.md)が提供するサブエージェントは、`my-plugin:code-reviewer` のようなスコープ付きの名前で入力候補に表示されます。プラグインが[エージェントをサブフォルダーに整理している](#choose-the-subagent-scope)場合は、`my-plugin:review:security` のようになります。セッション内で現在実行中の名前付きバックグラウンドサブエージェントも入力候補に表示され、名前の横にステータスが示されます。

ピッカーを使わずにメンションを手動で入力することもできます。ローカルのサブエージェントには `@agent-<name>`、プラグインのサブエージェントには `@agent-` の後にスコープ付きの名前を続けます（例: `@agent-my-plugin:code-reviewer`）。この形式を入力している間、入力候補にはエージェントではなく一致するファイルが表示されますが、送信時にはエージェントのメンションとして解決されます。

**セッション全体をサブエージェントとして実行する。** [`--agent <name>`](https://code.claude.com/docs/ja/cli-reference) を渡すと、メインスレッド自体がそのサブエージェントのツール制限とモデルを引き継いだセッションが開始されます。

```bash theme={null}
claude --agent code-reviewer
```

エージェントの[プロンプトが空](#choose-the-subagent-scope)である場合を除き、カスタムサブエージェントのシステムプロンプトは、[`--system-prompt`](https://code.claude.com/docs/ja/cli-reference) と同様に、デフォルトの Claude Code システムプロンプトを完全に置き換えます。`CLAUDE.md` ファイルとプロジェクトメモリは、エージェントの定義で [`omitClaudeMd`](#supported-frontmatter-fields) が設定されている場合でも、通常のメッセージフローを通じて読み込まれます。独自のプロンプトを持つカスタムエージェントとして `-p` 付きでセッションを実行した場合は、[Git ステータスのスナップショット](https://code.claude.com/docs/ja/settings-reference.md#includegitinstructions)もなしで開始されます。

起動時のヘッダーにはエージェント名が `@<name>` として表示されるので、有効になっていることを確認できます。

これは組み込みサブエージェントとカスタムサブエージェントの両方で機能し、この選択はセッションを再開したときにも保持されます。Claude Code は会話とともに、エージェントのツール制限とモデルを復元します。再開時にそのエージェントがもう存在しない場合、セッションはデフォルトのツールで続行され、[そのエージェント名を示す警告](https://code.claude.com/docs/ja/errors.md#session-agent-no-longer-available)が表示されます。どちらの場合のシステムプロンプトについても、[再開された会話でのシステムプロンプトフラグ](https://code.claude.com/docs/ja/cli-reference.md#system-prompt-flags-in-resumed-conversations)を参照してください。

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

`context: fork` を持つスキルについては、フォークモードがオンかどうかにかかわらず、Claude Code は代わりに[サブエージェントでスキルを実行する](https://code.claude.com/docs/ja/skills.md#run-skills-in-a-subagent)のルールに従います。

#### Claude にサブエージェントを待機させる

1. `CLAUDE_CODE_FORK_SUBAGENT` を `0` に設定して、[フォークモード](#turn-fork-mode-on-or-off)をオフにします。たとえば [`settings.json`](https://code.claude.com/docs/ja/settings) で次のように設定します。

   ```json theme={null}
   {
     "env": {
       "CLAUDE_CODE_FORK_SUBAGENT": "0"
     }
   }
   ```

2. シェルから `claude` を再度実行するか、VS Code で新しい会話を開きます。

3. 先に結果が必要な場合は、Claude に待機するよう依頼します。たとえば「run the reviewer subagent and wait for its report」のように依頼します。

Claude が待機している間も作業を続けるには、ターミナルで **Ctrl+B** を押すか、VS Code で [**Run in background**](https://code.claude.com/docs/ja/vs-code.md#move-a-running-command-or-subagent-to-the-background) をクリックします。

フォークモードをオフにする代わりに [`CLAUDE_CODE_DISABLE_BACKGROUND_TASKS`](https://code.claude.com/docs/ja/env-vars) 環境変数を `1` に設定した場合、Claude はすべてのサブエージェントを待機します。バックグラウンドコマンドもオフになり、**Ctrl+B** を押しても何もバックグラウンドに移動しません。

#### バックグラウンドサブエージェントのツール、権限、結果

バックグラウンドサブエージェントは、フォアグラウンドサブエージェントよりも[小さな組み込みツールセット](#available-tools)で実行されます。ただし、会話のフォークと[再開された](#resume-subagents)フォアグラウンドサブエージェントは例外です。

バックグラウンドサブエージェントは、すべての権限プロンプトをメインセッションに表示します。それらのプロンプトのいずれかに対して、セッションの残りの期間にわたって有効な付与など、その 1 つのツール呼び出しを超えて持続する選択肢で応答すると、Claude Code はその応答をメインの会話を含むセッション全体に適用します。

バックグラウンドサブエージェントは、バックグラウンドの [Bash または PowerShell コマンド](https://code.claude.com/docs/ja/tools-reference.md#background-commands)を[自身のターン終了後も実行したまま](https://code.claude.com/docs/ja/interactive-mode.md#how-backgrounding-works)にしておくことができます。そのコマンドが終了すると、Claude Code はサブエージェントに通知を送ります。

バックグラウンドサブエージェントの結果は、後のターンで完了通知として Claude に届きます。Claude はその通知を待ってからサブエージェントの結果を報告し、それより前に進捗を尋ねられた場合は、サブエージェントがまだ実行中であると報告します。

#### パネルとタスクリストにおける完了したサブエージェント

Claude Code は、サブエージェントの終了の仕方に応じて、次の 2 つのいずれかの方法で、プロンプト入力の下にあるサブエージェントパネルからバックグラウンドサブエージェントの行を消去します。

* サブエージェントが正常に終了すると、Claude Code はその行を直ちに削除し、[スクリーンリーダーモード](https://code.claude.com/docs/ja/accessibility.md)の場合を除き、フッターに `/tasks to see subagents` を 30 秒間表示します。この 30 秒の間に [`/tasks`](https://code.claude.com/docs/ja/commands) を実行し、サブエージェント上で `Enter` を押すと、そのトランスクリプトを開けます。v2.1.232 より前では、Claude Code は失敗したサブエージェントと同様に、終了後 30 秒間その行を保持し、フッターのヒントは表示していませんでした。
* サブエージェントが失敗した場合、またはユーザーが停止した場合、Claude Code はその行を 30 秒間保持します。もっと早く行を消去するには、行を選択して `x` を押します。

完了したバックグラウンドサブエージェントは、フッターのヒントと同じ 30 秒間、完了済みとしてマークされ、実行中の作業の下に並べられた状態で [`/tasks`](https://code.claude.com/docs/ja/commands) に一覧表示されたままになります。サブエージェントが終了しても、その詳細ビューは開いたままです。失敗したサブエージェントやユーザーが停止したサブエージェントは一覧から消えます。v2.1.208 より前では、完了したサブエージェントは終了した瞬間に一覧から消え、詳細ビューも閉じていました。

### サブエージェント名

[エージェントチーム](https://code.claude.com/docs/ja/agent-teams.md#enable-agent-teams)を有効にしてセッションを開始した場合、Claude は Agent ツールの呼び出しで `name` パラメーターを渡すことでサブエージェントに名前を付けることができます。ユーザーに事前に確認せずに自らそうすることもあります。名前を付けるとサブエージェントをアドレス指定できるようになり、Claude はサブエージェントの終了後に[名前でメッセージを送ったり再開したり](#resume-subagents)できます。

[エージェントチーム](https://code.claude.com/docs/ja/agent-teams.md)が有効なインタラクティブセッションでは、Claude がメインの会話から `name` 付きで生成したサブエージェントは、代わりにチームメイトとして起動します。ただし、その呼び出しが[フォーク](#fork-the-current-conversation)である場合、または呼び出し自体で `isolation` を渡している場合は除きます。サブエージェントのフロントマターにある `isolation` の値ではこれを防げず、その場合チームメイトはメインセッションの作業ディレクトリで実行されます。[Claude がエージェントチームを開始する方法](https://code.claude.com/docs/ja/agent-teams.md#how-claude-starts-agent-teams)を参照してください。

### サブエージェントでの API エラー

何らかの原因で[サブエージェントの応答がストリームの途中で途切れ](https://code.claude.com/docs/ja/errors.md#the-response-above-may-be-incomplete)、その部分的な応答にテキストは含まれているもののツール呼び出しが含まれていない場合、Claude Code は実行を終了するのではなく、サブエージェントに続行を促します。これはインタラクティブセッションでも同様です。実行がエラーで終了するのは、それらの続行の試行を使い切った場合のみです。

使用制限や繰り返し発生するサーバーエラーなどの API エラーで実行が終了したサブエージェントは、その失敗を Claude に報告します。Claude が受け取る内容は、サブエージェントがどこで実行されていたかによって異なります。

* **フォアグラウンド**: すでにテキスト出力を生成していたサブエージェントがレート制限、過負荷、またはサーバーエラーによって途中で途切れた場合、Agent ツールはその部分的な出力を、サブエージェントが途中で途切れてタスクを完了しなかったという注記とともに返します。何も生成しなかったサブエージェント、または出力がツール呼び出しのみだったサブエージェントは、[`Agent terminated early due to an API error`](https://code.claude.com/docs/ja/errors#agent-terminated-early-due-to-an-api-error) とそれに続くエラーの詳細で失敗します。
* **バックグラウンド**: サブエージェントは失敗としてマークされ、終了時に Claude が受け取るメッセージには API エラーの名前とサブエージェントの最後の出力が含まれるため、途中までの作業は失われません。

サブエージェントのレポートが次の行で始まっている場合、そのサブエージェントはフォールバックモデルで終了しています。

```text theme={null}
⚠ This agent switched to <model> because its earlier model could not be used.
```

[フォールバックモデルチェーン](https://code.claude.com/docs/ja/model-config.md#fallback-model-chains)を設定していて、サブエージェントがそのモデルを利用できないなど、チェーンが対象とする失敗に遭遇した場合、Claude Code はサブエージェントを、チェーン内でリクエストを受け付ける最初のモデルに切り替えます。サブエージェントはエラーで終了せずに作業を続けます。

根本的な API エラーが解消したら、Claude にタスクの再試行を依頼するか、[サブエージェントを再開](#resume-subagents)してください。

### サブエージェント出力のスキャン

Claude Code は、Claude が読む前に各サブエージェントの最終レポートをスキャンします。サブエージェントは、ユーザーが確認していないファイル、Web ページ、またはコマンド出力を読んでいる可能性があり、それらのソースからのテキストには、メインの会話を狙った指示が含まれている場合があります。スキャンによって何かが削除されたり書き換えられたりすることはありません。レポートで気付く可能性のある変更は次の 2 種類です。

* **バックスラッシュの挿入**: `<system-reminder>` タグや、`Human:` または `Assistant:` で始まる行など、Claude Code 自身の出力を模倣したテキストに、スキャンがバックスラッシュを挿入します。これにより、その模倣は会話の一部と誤認されることなく、通常のテキストとして読まれます。
* **マーカー行**: レポートが `<system-reminder>` のようなタグを模倣している場合、または `bypassPermissions` や `--dangerously-skip-permissions` などの権限設定に言及している場合、スキャンは `[harness: subagent output matched instruction-shaped pattern(s):` で始まる行を先頭に追加します。権限設定への言及にはマーカー行が付きますが、テキスト自体は書かれたとおりのままです。

スキャンは内容が悪意のあるものかどうかを判断せず、レポート内の指示が実行できる内容も変えません。レポートに促されて Claude が行うツール呼び出しは、引き続きセッションの[権限チェック](https://code.claude.com/docs/ja/permissions.md)と[サンドボックス化](https://code.claude.com/docs/ja/sandboxing.md)を通過します。これは[サブエージェントがアクセスできる範囲を制限すること](#control-subagent-capabilities)の代わりにはなりません。

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

並列で実行し続ける必要がある作業や、1 つのコンテキストウィンドウに収まらない作業は、[別々のセッション](https://code.claude.com/docs/ja/agents.md)で実行し、Claude に[セッション間で調査結果を受け渡させます](https://code.claude.com/docs/ja/cross-session-messaging.md)。

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

分離されたサブエージェントのコンテキストではなく、メインの会話のコンテキストで実行される再利用可能なプロンプトやワークフローが必要な場合は、代わりに[スキル](https://code.claude.com/docs/ja/skills.md)を検討してください。

会話内にすでにある事柄についての質問には、サブエージェントではなく [`/btw`](https://code.claude.com/docs/ja/interactive-mode#side-questions-with-%2Fbtw) を使います。これは完全なコンテキストを参照できますが、ツールへのアクセスはなく、回答は履歴に追加されません。

### サブエージェントに独自のサブエージェントを生成させる

デフォルトでは、サブエージェントはメインの会話から 3 階層下まで、独自のサブエージェントを生成できます。深さの上限に達すると、Claude Code は[フォーク](#fork-the-current-conversation)以外のすべてのサブエージェントから `Agent` ツールを取り除くため、上限に達したサブエージェントは委任された作業を自ら行い、1 つの要約を返します。上限に達したフォークは継承したツールリストに `Agent` を保持しますが、そのツールはサブエージェントを生成する代わりにエラーを返します。

ネストされたサブエージェントは、委任されたタスク自体が並列のサブタスクに分かれる場合に適しています。たとえば、検出結果ごとに検証役を送り出すレビュー役のサブエージェントなどです。デフォルトでは、生成元のサブエージェントは、ネストされた各サブエージェントのレポートを待ちます。

* **インタラクティブなターミナルセッション**: バックグラウンドサブエージェントを起動したサブエージェントは終了する前にそれらの結果を待つため、ユーザーに返されるのは最上位のサブエージェントの要約だけです。
* **`claude -p` と Agent SDK**: [フォークモード](#turn-fork-mode-on-or-off)がオンの間、生成元のサブエージェントは待機します。フォークモードをオフにすると、ネストされたサブエージェントは代わりに[バックグラウンド](#run-subagents-in-foreground-or-background)で開始されます。生成元のサブエージェントはバックグラウンドのネストされたサブエージェントを待たず、そのネストされたサブエージェントは生成元より長く実行された場合、メインの会話に報告します。

上限を変更するには、[`CLAUDE_CODE_MAX_SUBAGENT_SPAWN_DEPTH`](https://code.claude.com/docs/ja/env-vars) に、メインの会話の下に置きたいサブエージェントの階層数を設定します。たとえば、[`settings.json`](https://code.claude.com/docs/ja/settings) の次のエントリは、ネストを 2 階層までに制限します。

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

デフォルトでは、セッション内で 20 個のサブエージェントが実行中のとき、Agent ツールでさらに生成しようとすると `Concurrent subagent limit reached` で失敗し、そのエラーは Claude に再試行しないよう伝えます。実行中の数が上限を下回ると、再び生成できるようになります。上限を変更するには、[`CLAUDE_CODE_MAX_CONCURRENT_SUBAGENTS`](https://code.claude.com/docs/ja/env-vars) に任意の正の整数を設定します。[ultracode](https://code.claude.com/docs/ja/model-config.md#adjust-effort-level) が有効なセッションは対象外で、そこでは上限が適用されません。Claude Code v2.1.217 以降が必要です。

この上限がブロックするのは Claude が Agent ツールで生成するサブエージェントだけですが、他の実行も同じ枠を占有します。

* [`/subtask`](#fork-the-current-conversation) で開始したセッション内のフォークは、実行中に枠を 1 つ占有し、上限によってブロックされることはありません。
* すでに終了した[サブエージェントの再開](#resume-subagents)は、上限を確認せずに新しい枠を占有するため、再開によって実行中の数が上限を超えることがあります。

[ワークフロー](https://code.claude.com/docs/ja/workflows.md)のエージェントや[エージェントチーム](https://code.claude.com/docs/ja/agent-teams.md)のチームメイトなど、他の機能が実行するエージェントは、代わりにそれぞれ独自の上限に従います。

### サブエージェントのコンテキストを管理する

#### 起動時に読み込まれるもの

各サブエージェントは、新しく分離されたコンテキストウィンドウで開始します。会話履歴、すでに呼び出したスキル、Claude がすでに読んだファイルは参照できません。Claude はタスクを要約した委任メッセージを作成し、サブエージェントはそこから作業を進めます。例外は[フォーク](#fork-the-current-conversation)で、まっさらな状態から開始する代わりに親の会話を継承します。

フォークではないサブエージェントの初期コンテキストには、次のものが含まれます。

* **システムプロンプト**: Claude Code のシステムプロンプトではなく、エージェント自身のプロンプトに Claude Code が追加する環境の詳細を加えたものです。カスタムサブエージェントは、[markdown 本文](#write-subagent-files)または `prompt` フィールドでこれを定義します。組み込みエージェントには定義済みのプロンプトがあります。
* **タスクメッセージ**: 作業を引き渡すときに Claude が作成する委任プロンプトです。
* **CLAUDE.md ファイル**: `~/.claude/CLAUDE.md`、プロジェクトのルール、`CLAUDE.local.md`、管理ポリシーファイル、プロジェクトの指示として読み込まれる [`AGENTS.md` ファイル](https://code.claude.com/docs/ja/memory#agents-md)など、メインの会話が読み込む [CLAUDE.md の階層](https://code.claude.com/docs/ja/memory.md#how-claude-md-files-load)のすべてのレベルです。組み込みの Explore エージェントと Plan エージェントはこれをスキップします。定義で [`omitClaudeMd`](#supported-frontmatter-fields) が設定されているサブエージェントは、管理ポリシーファイルのみを読み込みます。定義が[管理設定](#choose-the-subagent-scope)から来ている場合は、何も読み込みません。
* **Git ステータス**: サブエージェントの開始時に Claude Code がリポジトリから読み取るスナップショットです。そのリポジトリの[独自の worktree](https://code.claude.com/docs/ja/worktrees.md#isolate-subagents-with-worktrees) 内のサブエージェントの場合、スナップショットには worktree のブランチ、ステータス、最近のコミットが表示されます。Git リポジトリの外にいる場合や、スナップショットがオフになっている場合は含まれません。[`includeGitInstructions`](https://code.claude.com/docs/ja/settings-reference#includegitinstructions) を参照してください。Explore と Plan は、いずれにしてもこれをスキップします。
* **プリロードされたスキル**: エージェントの [`skills` フィールド](#preload-skills-into-subagents)で指定されたスキルの全内容です。組み込みエージェントはスキルをプリロードしません。
* **兄弟エージェントの一覧**: `main` と、セッション内の他のすべての名前付きエージェントを列挙する[システムリマインダー](https://code.claude.com/docs/ja/glossary.md#system-reminder)です。それぞれが [`SendMessage`](#resume-subagents) の有効な `to` 値になります。この一覧は、サブエージェントのツールに `SendMessage` が含まれていて、かつ少なくとも 1 つの他のエージェントが名前を持っている場合にのみ表示されます。その名前は、Claude が生成時に付けたものでも、[エージェントチーム](https://code.claude.com/docs/ja/agent-teams.md)のチームメイトとして実行されていることによるものでもかまいません。これはサブエージェントの開始時に取得されたスナップショットであるため、後から名前が付けられたエージェントは表示されません。

独自のサブエージェントを、ユーザー、プロジェクト、ローカルの CLAUDE.md ファイルなしで起動するには、そのフロントマターまたは `--agents` の JSON で [`omitClaudeMd: true`](#supported-frontmatter-fields) を設定します。Explore、Plan、および `omitClaudeMd` を持つサブエージェントでも、サブディレクトリ内のファイルを扱うときには、そのサブディレクトリの `CLAUDE.md` と、一致する[パススコープのルール](https://code.claude.com/docs/ja/memory.md#path-specific-rules)が[読み込まれます](https://code.claude.com/docs/ja/memory.md#how-claude-md-files-load)。

メインの会話は、これらのサブエージェントの結果を読むときにも完全な CLAUDE.md を保持しているため、ほとんどのルールはサブエージェント自体に届く必要はありません。「`vendor/` ディレクトリを無視する」のように、ルールをどうしても届ける必要がある場合は、委任時に Claude に与えるプロンプトでそれを改めて伝えてください。

どのサブエージェントが Git ステータスを受け取るかは変更できません。これをスキップするのは Explore と Plan だけです。

メインの会話の一部の状態は、フォークではないサブエージェントには一切届きません。

* **出力スタイル**: サブエージェントは独自のシステムプロンプトで実行されるため、[フォーク](#fork-the-current-conversation)の場合を除き、[出力スタイル](https://code.claude.com/docs/ja/output-styles.md)はその応答に影響しません。
* **自動メモリ**: メインの会話の[自動メモリ](https://code.claude.com/docs/ja/memory.md#auto-memory)は読み込まれません。サブエージェントに独自の永続的なメモリを持たせるには、[`memory` フィールド](#enable-persistent-memory)を使います。
* **コンテキストウィンドウのサイズ**: サブエージェントのコンテキストウィンドウのサイズは、親のモデルではなく、サブエージェント自身のモデルによって決まります。より小さなウィンドウを持つモデルに委任すると、そのサブエージェントのウィンドウは小さくなります。

#### サブエージェントを再開する

サブエージェントを呼び出すたびに、以前のインスタンスを続行するのではなく、新しいインスタンスが作成されます。最初からやり直すのではなく、既存のサブエージェントの作業を続けるには、それを再開するよう Claude に依頼します。

再開されたサブエージェントは、以前のすべてのツール呼び出し、結果、推論を含む、完全な会話履歴を保持します。サブエージェントが[独自のバックグラウンドサブエージェント](#let-subagents-spawn-their-own-subagents)を生成していた場合、その履歴には、実行中にそれらが届けた結果も含まれます。v2.1.304 より前では、終了直後に Claude がメッセージを送ったり再開したりしたサブエージェントは、直近の作業を忘れてしまうことがありました。

* サブエージェントが完了すると、Claude はそのエージェント ID を受け取ります。
* 組み込みの Explore エージェントと Plan エージェントは 1 回限りのもので、エージェント ID を返さないため、Claude はそれらを再開できません。作業を続ける必要がある場合は、`general-purpose` またはカスタムサブエージェントを使います。
* サブエージェントが [`maxTurns`](#supported-frontmatter-fields) の上限で停止すると、Claude Code は返された出力を部分的なものとしてマークし、Claude はサブエージェントを再開して作業を続けさせることができます。

Claude は、エージェントの ID または名前を `to` フィールドに指定して `SendMessage` ツールを使い、サブエージェントを再開します。`SendMessage` を使うのに[エージェントチーム](https://code.claude.com/docs/ja/agent-teams.md)を有効にする必要はありません。有効化が必要なのは、`shutdown_request` や `plan_approval_response` などの構造化されたチームプロトコルメッセージだけです。サブエージェントやチームメイトに加えて、セッション間メッセージングが有効なセッションでは、Claude は同じツールを使って、このマシン上または[このマシンの外](https://code.claude.com/docs/ja/cross-session-messaging.md#message-sessions-on-other-machines)にある[ユーザーの他の Claude Code セッション](https://code.claude.com/docs/ja/cross-session-messaging.md)にメッセージを送ることができます。

サブエージェントを再開するには、以前の作業を続けるよう Claude に依頼します。

```text wrap theme={null}
Use the code-reviewer subagent to review the authentication module
[Agent completes]

Continue that code review and now analyze the authorization logic
[Claude resumes the subagent with full context from previous conversation]
```

Claude が `SendMessage` ツールで完了済みのサブエージェントにメッセージを送ると、そのサブエージェントは新たな `Agent` 呼び出しなしにバックグラウンドで再開します。Claude が `TaskStop` ツールで停止したサブエージェントについても、停止した実行が終了した後は同様です。再開された実行は、[サブエージェントが最初に実行されたときのツールセット](#run-subagents-in-foreground-or-background)を維持し、[元の実行がウォームアップしたプロンプトキャッシュ](https://code.claude.com/docs/ja/prompt-caching.md#subagents-and-the-cache)を引き続き読み取ることができます。

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
* **自動クリーンアップ**: Claude Code は、[保持期間のスイープルール](https://code.claude.com/docs/ja/claude-directory.md#cleaned-up-automatically)に従い、`cleanupPeriodDays` の保持期間（デフォルトは 30 日）が過ぎたサブエージェントのトランスクリプトを削除します。

##### 再起動後に名前でサブエージェントにメッセージを送る

> [!NOTE]
>
> チームメイトとして起動したサブエージェントについては、代わりに[エージェントチームの制限事項](https://code.claude.com/docs/ja/agent-teams.md#limitations)を参照してください。

Claude Code を再起動してセッションを再開した後、Claude が名前でサブエージェントにメッセージを送れない場合は、代わりにそのサブエージェントのエージェント ID を Claude に伝えてください。メインの会話の最後の[コンテキスト圧縮](https://code.claude.com/docs/ja/context-window.md#what-survives-compaction)以降に Claude がメインの会話から付けた名前は、再起動後も保持されます。その圧縮より前に付けられた名前は保持されません。名前に対応する ID を見つけるには、`~/.claude/projects/{project}/{sessionId}/subagents/` にある `agent-{agentId}.meta.json` ファイルでその名前を探します。

ID で一度メッセージを送ると、より新しいエージェントがその名前を取得していない限り、サブエージェントの名前は再び機能するようになります。v2.1.299 より前では、再起動後に保持される名前はなく、エージェント ID がまだ機能する場合でも名前による送信は拒否されていました。

#### 自動圧縮

サブエージェントは自動圧縮をサポートしています。コンテキスト圧縮は、サブエージェント自身のコンテキストウィンドウが埋まるにつれてトリガーされ、`CLAUDE_AUTOCOMPACT_PCT_OVERRIDE` はサブエージェントにも適用されます。この上書きがいつ有効になるかについては、[環境変数](https://code.claude.com/docs/ja/env-vars.md)を参照してください。

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

1 つのサブエージェントを通常よりも早く圧縮させるには、その[フロントマター](#supported-frontmatter-fields)で `autoCompactWindow` に `100000` から `1000000` までのトークン数を設定します。[`CLAUDE_CODE_AUTO_COMPACT_WINDOW`](https://code.claude.com/docs/ja/env-vars#variables) を設定している場合、Claude Code が[その変数の値を無視する](https://code.claude.com/docs/ja/model-config.md#claude_code_auto_compact_window-values)場合を除き、サブエージェントは代わりにその変数のウィンドウを使用し、このフィールドは効果を持ちません。Claude Code v2.1.296 以降が必要です。

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

* **値が、サブエージェントが本来継承する[自動圧縮のウィンドウ](https://code.claude.com/docs/ja/model-config.md#context-window-and-auto-compaction)より小さくない**: より早く圧縮させるには、そのウィンドウより小さい値を設定します。
* **`--agent` または `agent` 設定で、セッション全体をこのサブエージェントとして実行している**: その場合、このフィールドは効果を持ちません。セッションのウィンドウを設定するには、[自動圧縮のウィンドウを設定する](https://code.claude.com/docs/ja/model-config.md#set-the-auto-compact-window)を参照してください。

## 現在の会話をフォークする

> [!NOTE]
>
> [エージェントビューがオフになっている](https://code.claude.com/docs/ja/agent-view.md#turn-off-agent-view)場合、`/subtask` は利用できず、代わりに `/fork` がフォークされたサブエージェントを開始します。それ以外の場合、`/fork` はセッション全体を新しい[バックグラウンドセッション](https://code.claude.com/docs/ja/agent-view.md#from-inside-a-session)にコピーします。

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

フォークまたはサブエージェントのトランスクリプトが開いている場合、フォローアップメッセージと[スキル](https://code.claude.com/docs/ja/skills.md)はそのエージェントに送信され、組み込みコマンドはメイン会話に送信されます。ただし、次の安全策があります：

* `/compact`、`/clear`、`/rewind` はメイン会話に対して動作するため、このビューからこれらのいずれかを実行する前に、Claude Code は確認を求めます。
* `/model` と `/fast` は、表示しているエージェントではなくメイン会話のモデルと fast mode を設定するため、このビューからは実行されません。その理由は通知で表示されます。

表示しているエージェントが待機中の作業が完了する前にメッセージを読むようにするには、[`Ctrl+Enter` または `Ctrl+X Ctrl+S`](https://code.claude.com/docs/ja/keybindings#chat-actions) で送信します。エージェントが待機しているシェルコマンドやサブエージェントのうち、[バックグラウンド](https://code.claude.com/docs/ja/tools-reference.md#background-commands)に移動できるものはバックグラウンドに移動し、実行を続けます。エージェントが応答を書いている場合、またはバックグラウンドに移動できない作業を待っている場合は、そのまま処理を続け、それが完了した時点でメッセージを読みます。Claude Code v2.1.286 以降が必要です。

### フォークと他のサブエージェントの違い

フォークはメインセッションがその時点で持っているすべてを継承します。他のサブエージェントはその定義から開始します。

| | フォーク | 非フォークサブエージェント |
| :- | :- | :- |
| コンテキスト | 完全な会話履歴 | 渡すプロンプトを使用した新しいコンテキスト |
| システムプロンプトとツール | メインセッションと同じ | サブエージェントの[定義ファイル](#write-subagent-files)から、[バックグラウンド実行用にフィルタリング](#available-tools) |
| モデル | メインセッションと同じ | サブエージェントの `model` フィールドから |
| プロンプトキャッシュ | メインセッションと共有 | 別のキャッシュ |

フォークのシステムプロンプトとツール定義は親と同じであるため、最初のリクエストは親の[プロンプトキャッシュ](https://code.claude.com/docs/ja/prompt-caching.md#subagents-and-the-cache)を再利用します。この再利用により、同じコンテキストが必要なタスクの場合、フォークは新しいサブエージェントよりも安価です。

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

Claude Code は[hook 入力を JSON として](https://code.claude.com/docs/ja/hooks.md#pretooluse-input)stdin を通じて hook コマンドに渡します。検証スクリプトはこの JSON を読み取り、実行されるコマンドを抽出し、SQL 書き込み操作のリストに対してチェックします。書き込み操作が検出された場合、スクリプトは[終了コード 2](https://code.claude.com/docs/ja/hooks.md#exit-code-2-behavior-per-event)で終了して、stderr を通じて Claude にエラーメッセージを返します。

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

Windows では、検証スクリプトを PowerShell で記述し、hook エントリに `shell: powershell` を追加します。[PowerShell で hooks を実行する](https://code.claude.com/docs/ja/hooks.md#windows-powershell-tool)を参照してください。

hook は stdin を通じて JSON を受け取り、Bash コマンドは `tool_input.command` にあります。終了コード 2 は操作をブロックし、エラーメッセージを Claude にフィードバックします。終了コードと出力の詳細については[Hooks](https://code.claude.com/docs/ja/hooks.md#exit-code-output)を参照し、完全な入力スキーマについては[Hook 入力](https://code.claude.com/docs/ja/hooks.md#pretooluse-input)を参照してください。

システムプロンプトはサブエージェントに書き込みリクエストを拒否するよう指示するため、hook はバックストップです。サブエージェントが書き込みを試みた場合、Claude Code はコマンドをブロックし、サブエージェントは `Blocked: Write operations not allowed. Use SELECT queries only.` メッセージを表示します。

## 次のステップ

サブエージェントを理解したので、これらの関連機能を探索してください：

* [プラグインでサブエージェントを配布する](https://code.claude.com/docs/ja/plugins/components.md#agents)ことで、チームまたはプロジェクト全体でサブエージェントを共有します
* [Claude Code をプログラムで実行する](https://code.claude.com/docs/ja/headless.md)ことで、Agent SDK を使用して CI/CD と自動化を行います
* [MCP サーバーを使用する](https://code.claude.com/docs/ja/mcp.md)ことで、サブエージェントに外部ツールとデータへのアクセスを提供します
