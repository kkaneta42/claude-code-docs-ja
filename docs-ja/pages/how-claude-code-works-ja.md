> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# Claude Code の仕組み

> agentic ループ、組み込みツール、Claude Code がプロジェクトとどのように相互作用するかを理解します。

Claude Code はターミナルで実行される agentic アシスタントです。コーディングに優れていますが、コマンドラインからできることなら何でも支援できます。ドキュメント作成、ビルド実行、ファイル検索、トピック調査など、様々なタスクに対応します。

このガイドでは、コアアーキテクチャ、組み込み機能、および [Claude Code を効果的に使用するためのヒント](#work-effectively-with-claude-code) について説明します。ステップバイステップのウォークスルーについては、[一般的なワークフロー](/docs/ja/common-workflows.md) を参照してください。スキル、MCP、フックなどの拡張機能については、[Claude Code を拡張する](/docs/ja/features-overview.md) を参照してください。

## agentic ループ

Claude にタスクを与えると、3 つのフェーズを通じて作業します。**コンテキストの収集**、**アクションの実行**、**結果の検証** です。これらのフェーズは相互に融合します。Claude はツールを使用して、コードを理解するためのファイル検索、変更を加えるための編集、作業を確認するためのテスト実行など、様々な場面で活用します。

![agentic ループの図：プロンプトから Claude がコンテキストを収集し、アクションを実行し、結果を検証し、タスク完了まで繰り返します。任意の時点で中断できます。](https://mintcdn.com/claude-code/ikqp3_70mqIahteV/images/agentic-loop.svg?fit=max\&auto=format\&n=ikqp3_70mqIahteV\&q=85\&s=4a30fb7ce2815012a9f27c955e2c6bb0)

ループは、あなたが何を求めるかに応じて適応します。コードベースに関する質問は、コンテキスト収集だけで済むかもしれません。バグ修正は 3 つのフェーズすべてを繰り返し循環します。リファクタリングは広範な検証を伴うかもしれません。Claude は前のステップから学んだことに基づいて各ステップが何を必要とするかを判断し、数十のアクションを連鎖させ、途中で軌道修正します。

あなたもこのループの一部です。任意の時点で中断して Claude を別の方向に導いたり、追加のコンテキストを提供したり、別のアプローチを試すよう求めたりできます。Claude は自律的に動作しますが、あなたの入力に対して応答性を保ちます。

agentic ループは 2 つのコンポーネントによって駆動されます。推論する [モデル](#models) と、アクションを実行する [ツール](#tools) です。Claude Code はモデルの周りのレイヤーで、ツールを提供し、モデルが見るコンテキストを管理します。この周囲のレイヤーが agentic ハーネスという用語が指すものです。

### モデル

Claude Code は Claude モデルを使用して、コードを理解し、タスクについて推論します。Claude は任意の言語のコードを読み、コンポーネントがどのように接続されているかを理解し、目標を達成するために何を変更する必要があるかを判断できます。複雑なタスクの場合、作業をステップに分割し、実行し、学んだことに基づいて調整します。

[複数のモデル](/docs/ja/model-config.md) が異なるトレードオフで利用可能です。Sonnet はほとんどのコーディングタスクをうまく処理します。Opus は複雑なアーキテクチャ上の決定に対してより強力な推論を提供します。セッション中に `/model` で切り替えるか、`claude --model <name>` で開始します。

このガイドで「Claude が選択する」または「Claude が決定する」と言う場合、モデルが推論を行っています。

### ツール

ツールは Claude Code を agentic にするものです。ツールがなければ、Claude はテキストで応答することしかできません。ツールがあれば、Claude はアクションを実行できます。コードを読み、ファイルを編集し、コマンドを実行し、ウェブを検索し、外部サービスと相互作用します。各ツール使用は情報を返し、ループにフィードバックされ、Claude の次の決定に情報を与えます。

組み込みツールは一般的に 5 つのカテゴリに分類され、それぞれが異なる種類のエージェンシーを表します。

| カテゴリ | Claude ができること |
| - | - |
| **ファイル操作** | ファイルの読み取り、コード編集、新規ファイル作成、名前変更と再編成 |
| **検索** | パターンでファイルを検索、正規表現でコンテンツを検索、コードベースを探索 |
| **実行** | シェルコマンド実行、サーバー起動、テスト実行、git 使用 |
| **ウェブ** | ウェブ検索、ドキュメント取得、エラーメッセージ検索 |
| **コード インテリジェンス** | 編集後の型エラーと警告を表示、定義にジャンプ、参照を検索（[コード インテリジェンス プラグイン](/docs/ja/plugins/code-intelligence.md) が必要） |

これらが主な機能です。Claude には subagent の生成、質問、その他のオーケストレーションタスク用のツールもあります。完全なリストについては、[Claude が利用可能なツール](/docs/ja/tools-reference.md) を参照してください。

Claude はプロンプトと学んだことに基づいて、どのツールを使用するかを選択します。「失敗しているテストを修正して」と言うと、Claude は以下のようなことを行うかもしれません。

1. テストスイートを実行して、何が失敗しているかを確認
2. エラー出力を読む
3. 関連するソースファイルを検索
4. それらのファイルを読んでコードを理解
5. ファイルを編集して問題を修正
6. テストを再度実行して検証

各ツール使用は Claude に新しい情報を与え、次のステップに情報を与えます。これが agentic ループの実際の動作です。

**基本機能の拡張：** 組み込みツールが基盤です。[スキル](/docs/ja/skills.md) で Claude が知ることを拡張し、[MCP](/docs/ja/mcp.md) で外部サービスに接続し、[フック](/docs/ja/hooks.md) でワークフローを自動化し、[subagent](/docs/ja/sub-agents.md) にタスクをオフロードできます。これらの拡張は、コア agentic ループの上に層を形成します。ニーズに合った拡張を選択するためのガイダンスについては、[Claude Code を拡張する](/docs/ja/features-overview.md) を参照してください。

## Claude がアクセスできるもの

ディレクトリで `claude` を実行すると、Claude Code は以下にアクセスできます。

* **プロジェクト。** ディレクトリとサブディレクトリ内のファイル、および許可を得た他の場所のファイル。
* **ターミナル。** 実行できるあらゆるコマンド。ビルドツール、git、パッケージマネージャー、システムユーティリティ、スクリプト。コマンドラインからできることなら、Claude もできます。
* **git の状態。** 現在のブランチ、コミットされていない変更、最近のコミット履歴。
* **[CLAUDE.md](/docs/ja/memory.md)。** プロジェクト固有の指示、規約、Claude が毎回のセッションで知っておくべきコンテキストを保存するマークダウンファイル。リポジトリに他のコーディングエージェント用の AGENTS.md がある場合、Claude は CLAUDE.md の代わりに [それを読むことができます](/docs/ja/memory.md#agents-md)。
* **[自動メモリ](/docs/ja/memory.md#auto-memory)。** 作業中に Claude が自動的に保存する学習。設定など。MEMORY.md の最初の 200 行または 25KB のいずれか先に達した方が、各セッションの開始時に読み込まれます。
* **設定した拡張機能。** 外部サービス用の [MCP サーバー](/docs/ja/mcp.md)、ワークフロー用の [skills](/docs/ja/skills.md)、委譲作業用の [subagents](/docs/ja/sub-agents.md)、ブラウザ相互作用用の [Claude in Chrome](/docs/ja/chrome.md)。

Claude はプロジェクト全体を見ることができるため、プロジェクト全体で作業できます。「認証バグを修正して」と Claude に求めると、関連ファイルを検索し、複数のファイルを読んでコンテキストを理解し、それらを横断して調整された編集を行い、テストを実行して修正を検証し、求めればコミットします。これは現在のファイルのみを見るインラインコードアシスタントとは異なります。

## 環境とインターフェース

[agentic ループ](#the-agentic-loop)、[ツール](#tools)、および機能は、Claude Code を使用するあらゆる場所で同じです。変わるのは、コードが実行される場所とそれとの相互作用方法です。

### 実行環境

Claude Code は 3 つの環境で実行され、各環境はコード実行場所に対して異なるトレードオフを持ちます。

| 環境 | コード実行場所 | ユースケース |
| - | - | - |
| **ローカル** | マシン | デフォルト。ファイル、ツール、環境への完全なアクセス |
| **クラウド** | Anthropic 管理 VM、または [セルフホスト環境](/docs/ja/self-hosted-environments)（組織が運用） | タスクをオフロード、ローカルにないリポジトリで作業 |
| **リモートコントロール** | マシン、ブラウザから制御 | ウェブ UI を使用しながら実行とファイルをローカルに保つ |

### インターフェース

Claude Code には、ターミナル、[デスクトップアプリ](/docs/ja/desktop.md)、[IDE 拡張機能](/docs/ja/vs-code.md)、[claude.ai/code](https://claude.ai/code)、[リモートコントロール](/docs/ja/remote-control.md)、[Slack](/docs/ja/slack.md)、[CI/CD パイプライン](/docs/ja/github-actions.md) を通じてアクセスできます。インターフェースは Claude の表示方法と相互作用方法を決定しますが、基盤となる agentic ループは同じです。完全なリストについては、[Claude Code をどこでも使用する](/docs/ja/overview.md#use-claude-code-everywhere) を参照してください。

## セッションで作業する

Claude Code は作業中にローカルで会話を保存します。各メッセージ、ツール使用、結果は `~/.claude/projects/` の下のプレーンテキスト JSONL ファイルに書き込まれ、[巻き戻し](#undo-changes-with-checkpoints)、[再開、フォーク](#resume-or-fork-sessions) セッションが可能になります。Claude がコード変更を行う前に、影響を受けるファイルのスナップショットも作成されるため、必要に応じて元に戻すことができます。パス、保持期間、このデータをクリアする方法については、[`~/.claude` のアプリケーションデータ](/docs/ja/claude-directory#application-data) を参照してください。

**セッションは独立しています。** 各新規セッションは、前のセッションの会話履歴なしで、新しいコンテキストウィンドウで開始されます。Claude は [自動メモリ](/docs/ja/memory.md#auto-memory) を使用してセッション間で学習を保持でき、[CLAUDE.md](/docs/ja/memory.md) に独自の永続的な指示を追加できます。

### ブランチ間で作業する

各 Claude Code 会話は、現在のディレクトリに結び付けられたセッションです。`/resume` ピッカーはデフォルトで現在の worktree からのセッションを表示し、キーボードショートカットを使用してリストを他の worktree またはプロジェクトに拡張できます。ピッカーショートカットの完全なリストと名前解決の仕組みについては、[セッションを管理する](/docs/ja/sessions.md#use-the-session-picker) を参照してください。

Claude は現在のブランチのファイルを見ます。ブランチを切り替えると、Claude は新しいブランチのファイルを見ますが、会話履歴は同じままです。Claude はブランチ切り替え後も、議論したことを覚えています。

セッションはディレクトリに結び付けられているため、[git worktrees](/docs/ja/worktrees.md) を使用して並列 Claude Code セッションを実行できます。これは個別のブランチ用に別のディレクトリを作成します。

### セッションを再開またはフォークする

`claude --continue` または `claude --resume` でセッションを再開すると、同じセッション ID を使用して中断したところから再開し、新しいメッセージを既存の会話に追加します。`--fork-session` または `/branch` でフォークすると、履歴を新しいセッション ID にコピーし、元のセッションは変更されません。

![セッション継続性の図：再開は同じセッションを続行し、フォークは新しい ID で新しいブランチを作成します。](https://mintcdn.com/claude-code/ikqp3_70mqIahteV/images/session-continuity.svg?fit=max\&auto=format\&n=ikqp3_70mqIahteV\&q=85\&s=04ed0984a58e4127e05b3640265241a3)

再開フラグ、`/resume` ピッカー、命名、同じセッションが 2 つのターミナルで開いている場合の動作については、[セッションを管理する](/docs/ja/sessions.md) を参照してください。

### コンテキストウィンドウ

Claude のコンテキストウィンドウは、会話履歴、ファイルコンテンツ、コマンド出力、[CLAUDE.md](/docs/ja/memory.md)、[自動メモリ](/docs/ja/memory.md#auto-memory)、読み込まれたスキル、システム指示を保持します。作業を進めると、コンテキストが満杯になります。Claude は自動的にコンパクト化しますが、会話の早い段階からの指示が失われる可能性があります。永続的なルールを CLAUDE.md に入れ、`/context` を実行してスペースを使用しているものを確認してください。

対話的なウォークスルーについては、[コンテキストウィンドウを探索する](/docs/ja/context-window.md) を参照してください。

#### コンテキスト Claude Code が独自に追加するもの

Claude が `Co-Authored-By` トレーラーをコミットに追加するなど、自分で書いていないルールに従う場合、そのルールは [システムリマインダー](/docs/ja/glossary.md#system-reminder) から来ている可能性があります。作業を進めると、Claude Code はメッセージと共に独自のコンテキストを会話に追加します：

* CLAUDE.md ファイル
* [出力スタイル](/docs/ja/output-styles.md) の指示
* Claude が以前に読んだファイルがディスク上で変更されたときのメモ
* コミットとプルリクエストの属性行

属性行を変更または削除するには、[`attribution`](/docs/ja/settings-reference#attribution) を設定します。Claude Code の組み込みコミットおよびプルリクエスト指示を削除するには、[`includeGitInstructions`](/docs/ja/settings-reference#includegitinstructions) を `false` に設定します。その他のスイッチについては、[エージェントが置き換えるコンテキストをオフにする](/docs/ja/agent-sdk/modifying-system-prompts.md#turn-off-the-context-your-agent-replaces) を参照してください。

#### コンテキストが満杯になったとき

Claude Code はコンテキストウィンドウの制限に近づくと、自動的にコンテキストを管理します。古いツール出力をクリアし、必要に応じて会話を要約します。リクエストと主要なコードスニペットは保持されます。会話の早い段階からの詳細な指示は失われる可能性があります。会話履歴に依存するのではなく、永続的なルールを CLAUDE.md に入れてください。

コンパクト化中に保持されるものを制御するには、CLAUDE.md に「Compact Instructions」セクションを追加するか、`/compact` をフォーカス付きで実行します（例：`/compact focus on the API changes`）。

単一のファイルまたはツール出力が非常に大きく、各要約後にコンテキストがすぐに再度満杯になる場合、Claude Code は数回の試行後に自動コンパクト化を停止し、ループする代わりにエラーを表示します。[自動コンパクト化が thrashing エラーで停止する](/docs/ja/troubleshooting.md#auto-compaction-stops-with-a-thrashing-error) を参照して、復旧手順を確認してください。

`/context` を実行してスペースを使用しているものを確認してください。MCP ツール定義はデフォルトで遅延され、[ツール検索](/docs/ja/mcp.md#scale-with-mcp-tool-search) を通じてオンデマンドで読み込まれるため、Claude が特定のツールを使用するまで、ツール名とサーバー指示のみがコンテキストを消費します。

#### スキルと subagent でコンテキストを管理する

コンパクト化を超えて、他の機能を使用してコンテキストに読み込まれるものを制御できます。

[スキル](/docs/ja/skills.md) はオンデマンドで読み込まれます。Claude はセッション開始時にスキル説明を見ますが、完全なコンテンツはスキルが使用されるときのみ読み込まれます。手動で呼び出すスキルの場合、`disable-model-invocation: true` を設定して、必要になるまで説明をコンテキストから除外します。自分で書いていないスキルの場合、[`skillOverrides`](/docs/ja/skills#override-skill-visibility-from-settings) を使用して設定から同じことを行います。

[Subagent](/docs/ja/sub-agents.md) は独自のコンテキストウィンドウで動作します。Subagent は、[フォーク](/docs/ja/sub-agents.md#fork-the-current-conversation) でない限り新規に開始されます。フォークの場合は、これまでの会話のコピーで開始されます。どちらの場合でも、subagent のツール呼び出しはコンテキストから除外され、Claude は subagent が完了したときに要約を取得します。

各機能のコストについては [コンテキストコスト](/docs/ja/features-overview.md#understand-context-costs) を参照し、コンテキスト管理のヒントについては [トークン使用量を削減する](/docs/ja/costs.md#reduce-token-usage) を参照してください。

## チェックポイントと権限で安全に保つ

Claude には 2 つのセーフティメカニズムがあります。チェックポイントはファイル変更を元に戻すことができ、権限は Claude が質問なしにできることを制御します。

### チェックポイントで変更を元に戻す

**ファイル編集は可逆的です。** Claude がファイルを編集する前に、現在の内容のスナップショットを作成します。何か問題が発生した場合は、`Esc` キーを 2 回押して前の状態に戻すか、Claude に元に戻すよう依頼してください。

チェックポイントは git とは別で、会話を再開するときも利用可能です。ファイル変更のみをカバーし、復元は [シンボリックリンクとハードリンクされたファイルをスキップします](/docs/ja/checkpointing.md#symlinked-and-hard-linked-paths-not-restored)。リモートシステム（データベース、API、デプロイメント）に影響を与えるアクションはチェックポイント化できません。これらは権限モードと権限ルールで制御します。

### Claude ができることを制御する

権限モードを選択して、Claude が質問なしにできることを設定します。`Shift+Tab` を押して権限モードをサイクルさせます。

* **Auto**: 分類器がバックグラウンドでほとんどのアクションをレビューし、質問する代わりにリスクのあるものをブロックします。Claude Code v2.1.283 以降では、インタラクティブターミナルと VS Code セッションの [組み込みの開始権限モード](/docs/ja/permission-modes.md#which-mode-a-session-starts-in) であり、以前のバージョンでは Pro、Max、Team プランのみです
* **Manual**: Claude はファイル編集とシェルコマンドの前に質問します
* **Accept edits**: Claude は `mkdir` や `mv` などの一般的なファイルシステムコマンドを質問なしでファイル編集および実行し、他のコマンドについては引き続き質問します
* **Plan**: Claude はソースファイルを編集せずにプランを探索および提案します

`.claude/settings.json` で特定のコマンドを許可することもできるため、Claude は毎回質問する必要がありません。これは `npm test` や `git status` などの信頼できるコマンドに便利です。設定は組織全体のポリシーから個人的な設定までスコープできます。詳細は [Permissions](/docs/ja/permissions.md) を参照してください。

***

## Claude Code を効果的に使用する

これらのヒントは Claude Code からより良い結果を得るのに役立ちます。特定のプロンプト、検証、計画の詳細については、[ベストプラクティス](/docs/ja/best-practices.md)を参照してください。

### Claude Code に助言を求める

Claude Code はそれの使い方を教えることができます。「hooks をどのようにセットアップするのか」や「CLAUDE.md を構造化する最良の方法は何か」といった質問をしてください。Claude が説明します。

組み込みコマンドもセットアップをガイドします：

* `/init` はプロジェクト用のスターター CLAUDE.md を生成します
* `/doctor` はセットアップチェックアップを実行し、インストールと設定の問題を診断し、修正することができます

### これは会話です

Claude Code は会話型です。完璧なプロンプトは必要ありません。やりたいことから始めて、その後改善します：

```text theme={null}
Fix the login bug
```

\[Claude が調査し、何かを試す]

```text theme={null}
That's not quite right. The issue is in the session handling.
```

\[Claude がアプローチを調整する]

最初の試みが正しくない場合、最初からやり直す必要はありません。反復します。

#### 割り込みと操舵

任意の時点で Claude をリダイレクトでき、最初からやり直す必要はありません。以下のいずれかを実行してください：

* **`Esc` キーを押す**と Claude が直ちに停止します。実行中のツール呼び出しがキャンセルされ、Claude は次の指示を待ちます。メッセージがキューに入っている場合、Claude Code は[次にそれらを送信します](/docs/ja/interactive-mode.md#queue-messages-while-claude-works)。
* **修正を入力して `Enter` キーを押す**と Claude を停止せずに実行します。メッセージは入力ボックスの上にキューに入っているものとして表示されます。Claude がツール呼び出しを実行している場合、それらの呼び出しが完了するとすぐに、同じターン内でメッセージを読み取り、次のステップの前に調整します。[Claude が作業している間にメッセージをキューに入れる](/docs/ja/interactive-mode.md#queue-messages-while-claude-works)は、他のキューに入っているエントリがいつ送信されるかについて説明しています。

### 指示するのではなく委譲する

有能な同僚に委譲することを考えてください。コンテキストと方向性を提供し、その後 Claude が詳細を理解することを信頼してください：

```text theme={null}
The checkout flow is broken for users with expired cards.
The relevant code is in src/payments/. Can you investigate and fix it?
```

どのファイルを読むか、どのコマンドを実行するかを指定する必要はありません。Claude がそれを理解します。

## 次のステップ

> **[機能で拡張する](/docs/ja/features-overview.md)**
>
> スキルと MCP 接続を追加

> **[一般的なワークフロー](/docs/ja/common-workflows.md)**
>
> 典型的なタスクのステップバイステップガイド
