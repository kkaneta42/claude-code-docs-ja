> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# 用語集

> Claude Code の用語の定義。agentic loop、compaction、CLAUDE.md、hooks、subagents、MCP などのコア概念の意味を学びます。

この用語集は Claude Code の用語を定義しています。各エントリは、その概念について詳しく説明されているページにリンクしています。トークン、temperature、RAG などのモデルレベルの概念については、[プラットフォーム用語集](https://platform.claude.com/docs/ja/about-claude/glossary)を参照してください。

## A

### Agent teams

複数の独立した Claude Code セッションがチームリーダーによって調整され、共有タスクリストとピアツーピアメッセージングを備えています。単一のセッション内で実行され、親にのみレポートする [subagents](#subagent) とは異なり、チームメイトはそれぞれ独自のコンテキストウィンドウを持ち、任意のメンバーと直接対話できます。Agent teams は実験的機能であり、`CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1` を設定して有効にする必要があります。

詳細情報: [Run agent teams](/ja/agent-teams)

### Agentic coding

AI がファイルを読み取り、コマンドを実行し、自律的に変更を加えることができるワークフロー。あなたが見守ったり、リダイレクトしたり、立ち去ったりできます。これは、テキストのみで応答するチャットベースのアシスタントとは異なり、自分で適用する必要があります。Claude Code は agentic です。なぜなら、アドバイスするだけでなく、行動できる [tools](#tool) を持っているからです。

詳細情報: [How Claude Code works](/ja/how-claude-code-works)

### Agentic harness

言語モデルを有能なコーディングエージェントに変える、ツール、コンテキスト管理、実行環境。Claude Code はハーネスです。Claude はその中のモデルです。ハーネスはファイルアクセス、シェル実行、権限ゲーティング、メモリロード、およびアクションをチェーンするループを提供します。

詳細情報: [How Claude Code works](/ja/how-claude-code-works)

### Agentic loop

Claude がすべてのタスクで実行するサイクル: コンテキストを収集し、アクションを実行し、結果を検証し、完了するまで繰り返します。各ツール使用は次のステップに情報を提供します。ループはいつでも中断してリダイレクトできます。[hooks](#hook)、[skills](#skill)、[MCP](#mcp-model-context-protocol) を含むほとんどの拡張ポイントは、このループの特定のフェーズにプラグインします。

詳細情報: [How Claude Code works](/ja/how-claude-code-works#the-agentic-loop)

### Auto memory

Claude が自分自身のために書いたメモ。あなたの修正と設定に基づいて、git リポジトリごとに `~/.claude/projects/` に保存されます。同じリポジトリのすべてのワークツリーは 1 つの auto memory ディレクトリを共有します。`MEMORY.md` インデックスの最初の 200 行または 25 KB がすべてのセッションの開始時にロードされます。Auto memory は、あなたが書く [CLAUDE.md](#claude-md) に対する Claude が書いた対応物です。

詳細情報: [Auto memory](/ja/memory#auto-memory)

### Auto mode

[permission mode](#permission-mode) の一種。承認プロンプトを表示する代わりに、別の分類器モデルがバックグラウンドで各アクションをレビューします。分類器はスコープエスカレーション、信頼されていないインフラストラクチャ、および [prompt injection](#prompt-injection) をブロックします。ツール結果を見ることはないため、注入された指示がその決定に影響を与えることはできません。Auto mode は Max、Team、Enterprise、API プランで利用可能な研究プレビューです。

詳細情報: [Eliminate prompts with auto mode](/ja/permission-modes#eliminate-prompts-with-auto-mode)

## B

### Bare mode

スタートアップフラグ `--bare`。hooks、skills、plugins、MCP servers、auto memory、CLAUDE.md の自動検出をスキップします。明示的に渡したフラグのみが有効になります。ローカル設定に関係なく、マシン間で同じ動作が必要な CI とスクリプト呼び出しに推奨されます。

詳細情報: [Start faster with bare mode](/ja/headless#start-faster-with-bare-mode)

### Bundled skills

Claude Code に含まれるプロンプトベースのプレイブック。`/batch`、`/simplify`、`/debug`、`/loop` など。固定ロジックを実行する組み込みコマンドとは異なり、bundled skills は Claude に詳細なプロンプトを与え、作業をオーケストレーションさせるため、エージェントを生成し、ファイルを読み取り、コードベースに適応できます。

詳細情報: [Bundled skills](/ja/skills#bundled-skills)

## C

### Channel

[MCP server](#mcp-model-context-protocol) の一種。実行中のセッションにイベントをプッシュして、Claude がターミナルから離れている間に発生することに反応できるようにします。チャネルは双方向にできます。Claude は受信イベントを読み取り、同じチャネルを通じて返信します。Telegram、Discord、iMessage は研究プレビューに含まれています。

詳細情報: [Channels](/ja/channels)

### Checkpoint

Claude が各編集を行う前にキャプチャされたコードの自動スナップショット。`Esc` を 2 回押すか `/rewind` を実行して、コード、会話、またはその両方を以前のポイントに復元します。チェックポイントはセッションに対してローカルであり、git とは別であり、Bash ツールを通じて行われた変更は追跡しません。

詳細情報: [Checkpointing](/ja/checkpointing)

### `.claude` directory

Claude Code がプロジェクトスコープの設定を読み取るディレクトリ: 設定、hooks、skills、subagents、rules、auto memory。プロジェクトはそのルートに `.claude/` を持ちます。ユーザーレベルのデフォルトは `~/.claude/` にあります。

詳細情報: [The `.claude` directory](/ja/claude-directory)

### CLAUDE.md

Claude のために書く永続的な指示のマークダウンファイル。システムプロンプトの後、ユーザーメッセージとしてすべてのセッションの開始時にロードされます。プロジェクト規約、アーキテクチャノート、「常に X を行う」ルールをここに配置します。CLAUDE.md は [compaction](#compaction) を生き残り、その後ディスクから新しく再読み込みされます。

CLAUDE.md は `./CLAUDE.md` または `./.claude/CLAUDE.md` のプロジェクトスコープに、`~/.claude/CLAUDE.md` のユーザースコープに、または組織の [managed policy](#managed-settings) として配置できます。より具体的な場所が優先されます。

詳細情報: [CLAUDE.md files](/ja/memory#claude-md-files)

### Command

プロンプトに `/name` と入力して呼び出す再利用可能な指示。`/clear`、`/model`、`/compact` などの組み込みコマンドはセッションを制御します。`.claude/commands/` のファイルとして独自のコマンドを定義するか、[plugin](#plugin) からインストールできます。[Skills](#skill) は複数ステップのコマンドをパッケージ化するための推奨される方法です。

詳細情報: [Commands](/ja/commands) · [Skills](/ja/skills)

### Compaction

[context window](#context-window) がその制限に近づくときの会話の自動要約。古いツール出力が最初にクリアされ、次に会話が要約されます。プロジェクトルート CLAUDE.md と auto memory は compaction を生き残り、ディスクから再ロードされます。会話でのみ与えられた指示は失われる可能性があります。`/compact` を手動でトリガーするか、オプションで `/compact focus on the API changes` のようなフォーカスを指定します。

詳細情報: [What survives compaction](/ja/context-window#what-survives-compaction) · [When context fills up](/ja/how-claude-code-works#when-context-fills-up)

### Context window

セッションの作業メモリ。会話履歴、ファイルコンテンツ、コマンド出力、CLAUDE.md、auto memory、ロードされたスキル、システム指示を保持します。作業を進めるにつれて、コンテキストが満杯になるまで [compaction](#compaction) がそれを要約します。`/context` を実行して、スペースを使用しているものを確認します。基礎となるモデル概念については、[プラットフォーム用語集](https://platform.claude.com/docs/ja/about-claude/glossary#context-window)を参照してください。

詳細情報: [Explore the context window](/ja/context-window)

## D

### Dispatch

電話で開始されたタスクルーター。Claude モバイルアプリからコーディングタスクを送信すると、Desktop アプリで Claude Code セッションを生成します。プロンプトは自動的に正しいツールにルーティングされます。Pro および Max プランで利用可能です。

詳細情報: [Sessions from Dispatch](/ja/desktop#sessions-from-dispatch)

## E

### Effort level

各ターンで Claude が適応的推論思考予算をどの程度使用するかを制御する設定。より高い努力は、より多くの思考トークンとより深い推論を意味します。より低い努力はより速く、より安価です。Effort は Opus 4.7、Opus 4.6、Sonnet 4.6 でサポートされています。

詳細情報: [Adjust effort level](/ja/model-config#adjust-effort-level)

### Extended thinking

モデルが応答する前に実行する可視的なステップバイステップの推論。`MAX_THINKING_TOKENS` で思考トークンをキャップするか、[effort level](#effort-level) を調整できます。思考はターミナルのグレーイタリックテキストで表示されます。

詳細情報: [Use extended thinking](/ja/common-workflows#use-extended-thinking-thinking-mode)

## H

### Hook

Claude Code のライフサイクルの特定のポイント（ツール実行前、ファイル編集後、セッション開始時など）で自動的に実行されるユーザー定義ハンドラー。ハンドラーはシェルコマンド、HTTP エンドポイント、MCP ツール、LLM プロンプト、または subagent にできます。Hooks は決定論的です。モデルの裁量ではなく、固定ライフサイクルポイントで発火します。

フック設定には 3 つのレベルがあります:

* **Hook event**: ライフサイクルポイント
* **Matcher**: どのイベントがそれを発火させるかをフィルタリング
* **Hook handler**: 実行内容

詳細情報: [Get started with hooks](/ja/hooks-guide) · [Hooks reference](/ja/hooks)

## M

### Managed settings

IT または DevOps によって組織全体で実施される設定ファイル。`~/.claude` の外の OS レベルパスに配置されます。ユーザーは managed settings をオーバーライドまたは除外することはできません。セキュリティポリシー、コンプライアンス要件、またはフロート全体の標準化されたツールに使用します。

詳細情報: [Server-managed settings](/ja/server-managed-settings)

### MCP (Model Context Protocol)

AI ツールを外部データソースとサービスに接続するためのオープン標準。MCP servers は Claude に Slack、Jira、データベース、ブラウザ、および数百の他の統合用の新しいツールを提供します。`/mcp` を使用するか、`.mcp.json` に追加してサーバーを接続します。プロトコル自体については、[プラットフォーム用語集](https://platform.claude.com/docs/ja/about-claude/glossary#mcp-model-context-protocol)を参照してください。

詳細情報: [Model Context Protocol](/ja/mcp)

### MCP Tool Search

コンテキスト節約メカニズム。MCP ツールスキーマを必要になるまで遅延させます。スタートアップ時にはツール名のみがロードされます。Claude は特定のツールを使用することを決定したときにオンデマンドで完全なスキーマを取得します。これにより、アイドル MCP servers がコンテキストをあまり消費しないようにします。

詳細情報: [Scale with MCP Tool Search](/ja/mcp#scale-with-mcp-tool-search)

## N

### Non-interactive mode

単一のプロンプトを実行して会話セッションなしで終了するモード。`-p` または `--print` で呼び出されます。CI、スクリプト、パイピングに使用されます。[Agent SDK](/ja/agent-sdk/overview) は Python および TypeScript の同等物です。以前は headless mode と呼ばれていました。

詳細情報: [Run Claude Code programmatically](/ja/headless)

## O

### Output style

Claude のシステムプロンプトを変更して応答動作、トーン、または形式を変更する設定。Output styles は、システムプロンプトの後に配信される [CLAUDE.md](#claude-md) とは異なり、デフォルトシステムプロンプトのソフトウェアエンジニアリング固有の部分をオフにします。組み込みスタイルには Default、Explanatory、Learning が含まれます。

詳細情報: [Output styles](/ja/output-styles)

## P

### Permission mode

セッションのベースライン承認動作。CLI で `Shift+Tab` でサイクルするか、VS Code、Desktop、claude.ai のモードセレクターを使用します。利用可能なモードは `default`、`acceptEdits`、`plan`、`auto`、`dontAsk`、`bypassPermissions` です。

詳細情報: [Choose a permission mode](/ja/permission-modes)

### Permission rule

ツール名と引数パターンに基づいてツール呼び出しを許可、質問、または拒否する設定エントリ。ルールは deny→ask→allow で評価され、最初にマッチしたものが優先されます。Permission rules は、より広い [permission mode](#permission-mode) の上に層状化された細粒度制御です。

詳細情報: [Configure permissions](/ja/permissions)

### Plan mode

[permission mode](#permission-mode) の一種。Claude はソースファイルを編集せずに変更を研究および提案します。読み取り、検索、探索コマンドを実行でき、その後、何かに触れる前に承認用の計画を提示します。`/plan` を入力するか、`Shift+Tab` を押して plan mode に入ります。

詳細情報: [Analyze before you edit with plan mode](/ja/permission-modes#analyze-before-you-edit-with-plan-mode)

### Plugin

skills、hooks、subagents、MCP servers のバンドル。単一のインストール可能なユニットとしてパッケージ化されます。Plugin skills は `plugin-name:skill-name` として名前空間化されるため、複数のプラグインが共存できます。[marketplace](/ja/plugin-marketplaces) を通じてチーム全体にプラグインを配布します。

詳細情報: [Plugins](/ja/plugins)

### Project trust

ディレクトリを受け入れる 1 回限りのダイアログ。Claude Code がその設定をロードする前に。Trust は marketplace プラグインの自動インストールとプロジェクト定義フックの実行をゲートします。ディレクトリを信頼することは、その `.claude/settings.json`、`.mcp.json`、および他の設定ファイルが有効になることを意味します。

詳細情報: [The `.claude` directory](/ja/claude-directory)

### Prompt injection

ファイル、ウェブページ、またはツール結果に埋め込まれた敵対的な指示。Claude を、あなたが決して求めなかったアクションにリダイレクトしようとします。Claude Code の防御には、権限システム、コマンドブロックリスト、信頼検証が含まれます。[Auto mode](#auto-mode) は、ツール結果の疑わしいコンテンツをスキャンするサーバー側プローブと、ツール結果を見ない分類器を追加します。そのため、注入されたテキストが承認決定に影響を与えることはできません。

詳細情報: [Protect against prompt injection](/ja/security#protect-against-prompt-injection)

## R

### Remote Control

ローカル Claude Code セッションを電話またはブラウザから claude.ai 経由で続行する方法。コードはマシンに留まります。UI のみがリモートです。クラウドサンドボックスで実行される web 上の Claude Code とは異なります。

詳細情報: [Remote Control](/ja/remote-control)

### Rules

`.claude/rules/` のモジュール化された指示ファイル。CLAUDE.md と一緒にロードされます。ルールは YAML `paths:` frontmatter でパススコープできるため、Claude が一致するファイルを読み取るときのみロードされ、関連になるまでコンテキストを精力的に保ちます。

詳細情報: [Organize rules with `.claude/rules/`](/ja/memory#organize-rules-with-claude/rules/)

## S

### Sandboxing

Bash ツールの OS レベルのファイルシステムおよびネットワーク分離。コマンドは事前に定義した境界内で実行されるため、Claude はコマンドごとの承認プロンプトなしで自由に作業できます。Sandboxing は [permission rules](#permission-rule) とは別のレイヤーです。

詳細情報: [Sandboxing](/ja/sandboxing)

### Session

現在のディレクトリに関連付けられた会話。独自の独立した [context window](#context-window) を持ちます。セッションは `claude -c` で再開でき、`--fork-session` でフォークして履歴を新しいセッション ID の下に保存でき、またはターミナル全体で並列実行できます。`/clear` を実行すると新しいセッションが開始されます。前のセッションは保存されたままで、`/resume` を通じて利用可能です。各セッションのトランスクリプトは `~/.claude/projects/` に保存されます。

詳細情報: [Work with sessions](/ja/how-claude-code-works#work-with-sessions)

### Settings layers

Claude Code が設定を読み取る階層。優先順位の高い順から低い順: [managed policy](#managed-settings)、コマンドライン引数、`.claude/settings.local.json` のローカル設定、`.claude/settings.json` のプロジェクト設定、`~/.claude/settings.json` のユーザー設定。配列はレイヤー全体でマージされます。スカラーは高いレイヤーで低いレイヤーをオーバーライドします。

詳細情報: [Settings files](/ja/settings#settings-files)

### Skill

指示、知識、またはワークフローを含む `SKILL.md` ファイル。Claude はそれをツールキットに追加します。Claude は関連する場合に自動的にスキルをロードするか、`/skill-name` で直接呼び出します。Skills は Agent Skills オープン標準に従います。Claude Code はそれを呼び出し制御と subagent 実行で拡張します。

Skills は custom commands の推奨される後継者です。`.claude/commands/deploy.md` のファイルと `.claude/skills/deploy/SKILL.md` のファイルの両方が `/deploy` を作成し、同じように機能します。既存のコマンドファイルは引き続き機能します。

詳細情報: [Extend Claude with skills](/ja/skills)

### Subagent

独自のコンテキストウィンドウ、カスタムシステムプロンプト、特定のツールアクセス、独立した権限で実行される特化した AI アシスタント。委任されたタスクで機能し、メイン会話に要約を返します。大規模な探索をプライマリコンテキストから除外するか、並列研究を実行するために subagents を使用します。各エージェントが直接対話できる完全な独立したセッションである [agent teams](#agent-teams) とは異なります。

組み込み subagents には Explore、Plan、汎用があります。

詳細情報: [Create custom subagents](/ja/sub-agents)

### Surface

Claude Code にアクセスする任意の場所: CLI、VS Code、JetBrains、Desktop、または claude.ai。すべてのサーフェスは同じエンジンを共有するため、CLAUDE.md、設定、スキルはすべてのサーフェスで同じように機能します。Slack と Chrome 拡張機能は、サーフェス自体ではなくサーフェスに接続する統合です。

詳細情報: [Platforms and integrations](/ja/platforms)

## T

### Teleport

コマンド `/teleport`。クラウド Claude Code セッションをローカルターミナルにプルします。Claude はブランチをフェッチし、会話履歴をロードし、web セッションの最後の状態から再開します。逆方向は `--remote` です。ローカルタスクを web で実行するために送信します。

詳細情報: [From web to terminal](/ja/claude-code-on-the-web#from-web-to-terminal)

### Tool

Claude が実行できるアクション: ファイルを読み取る、コードを編集する、シェルコマンドを実行する、web を検索する、subagent を生成する。Tools は Claude Code を agentic にするものです。それらなしでは、Claude はテキストのみで応答できます。各ツール使用は、[agentic loop](#agentic-loop) での Claude の次の決定に情報を提供する結果を返します。

詳細情報: [Tools available to Claude](/ja/tools-reference)

## W

### Worktree isolation

Claude を `.claude/worktrees/` の別の git worktree で実行する分離モード。`-w` フラグまたは subagent 設定の `isolation: worktree` で有効にされます。変更は別のブランチの別のディレクトリに留まるため、並列エージェントはお互いのファイルを上書きしません。

詳細情報: [Run parallel sessions with git worktrees](/ja/common-workflows#run-parallel-claude-code-sessions-with-git-worktrees)

***

## 非推奨および名前変更された用語

これらの用語は古いドキュメント、ブログ投稿、コミュニティコンテンツに表示されます。このサイトを検索するときは現在の名前を使用してください。

| 古い用語            | 現在の呼び方                                        | 注記                              |
| --------------- | --------------------------------------------- | ------------------------------- |
| Headless mode   | [Non-interactive mode](#non-interactive-mode) | 同じ `-p` フラグ、同じ動作                |
| Custom commands | [Skills](#skill)                              | `.claude/commands/` ファイルは引き続き機能 |
| Slash commands  | Commands                                      | 製品コピーから「Slash」を削除               |
