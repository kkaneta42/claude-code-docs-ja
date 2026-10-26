> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# Claude Code を拡張する

> CLAUDE.md、Skills、subagents、hooks、MCP、plugins をいつ使用するかを理解します。

Claude Code は、コードについて推論するモデルと、ファイル操作、検索、実行、ウェブアクセス用の[組み込みツール](https://code.claude.com/docs/ja/how-claude-code-works.md#tools)を組み合わせています。組み込みツールはほとんどのコーディングタスクをカバーしています。このガイドは拡張レイヤーについて説明します。つまり、Claude が何を知るかをカスタマイズし、外部サービスに接続し、ワークフローを自動化するために追加する機能です。

> [!NOTE]
>
> コア agentic ループがどのように機能するかについては、[How Claude Code works](https://code.claude.com/docs/ja/how-claude-code-works.md) を参照してください。

**Claude Code は初めてですか？** [CLAUDE.md](https://code.claude.com/docs/ja/memory.md) でプロジェクト規約を開始します。その後、[特定のトリガーが発生したときに](#build-your-setup-over-time)他の拡張機能を追加してください。

## 概要

拡張機能は agentic ループのさまざまな部分に接続します。

* **[CLAUDE.md](https://code.claude.com/docs/ja/memory.md)** は、Claude がすべてのセッションで見る永続的なコンテキストを追加します
* **[Output styles](https://code.claude.com/docs/ja/output-styles.md)** はすべてのセッションのすべての応答に対して Claude の役割、トーン、応答形式を設定します
* **[Skills](https://code.claude.com/docs/ja/skills.md)** は再利用可能な知識と呼び出し可能なワークフローを追加します
* **[Code intelligence](https://code.claude.com/docs/ja/tools-reference.md#lsp-tool-behavior)** は Claude を言語サーバーに接続し、シンボルレベルのナビゲーションとライブ型エラーを実現します
* **[MCP](https://code.claude.com/docs/ja/mcp.md)** は Claude を外部サービスとツールに接続します
* **[Subagents](https://code.claude.com/docs/ja/sub-agents.md)** は独立したコンテキストで独自のループを実行し、サマリーを返します
* **[Dynamic workflows](https://code.claude.com/docs/ja/workflows.md)** は Claude が書いたスクリプトから多くの subagents を実行し、1 つの結果を返します
* **[Cross-session messaging](https://code.claude.com/docs/ja/cross-session-messaging.md)** により、Claude はあなたのセッションの 1 つから別のセッションにメッセージを渡すことができます
* **[Hooks](https://code.claude.com/docs/ja/hooks-guide.md)** はライフサイクルイベントで発火し、スクリプト、HTTP リクエスト、MCP ツール呼び出し、プロンプト、または subagent を実行できます
* **[Plugins](https://code.claude.com/docs/ja/plugins/overview.md)** と **[marketplaces](https://code.claude.com/docs/ja/plugins/overview.md)** はこれらの機能をパッケージ化して配布します

[Skills](https://code.claude.com/docs/ja/skills.md) は最も柔軟な拡張機能です。スキルは知識、ワークフロー、または指示を含むマークダウンファイルです。`/deploy` のようなコマンドでスキルを呼び出すことができます。または Claude は関連する場合に自動的にスキルをロードできます。スキルは現在の会話で実行することも、subagents を介して独立したコンテキストで実行することもできます。

## 目的に合わせて機能を選ぶ

機能には、Claude がすべてのセッションで参照する常時有効なコンテキストから、ユーザーや Claude が呼び出せるオンデマンドの機能、特定のイベントで実行されるバックグラウンドの自動化まで、さまざまなものがあります。次の表は、利用可能な機能とそれぞれが適している場面を示しています。

| 機能 | 機能の内容 | 使用する場面 | 例 |
| - | - | - | - |
| **CLAUDE.md** | すべての会話で読み込まれる永続的なコンテキスト | プロジェクトの規約、「常に X を行う」ルール | 「npm ではなく pnpm を使用する。コミット前にテストを実行する。」 |
| **[出力スタイル](https://code.claude.com/docs/ja/output-styles.md)** | セッション全体にわたって Claude の役割、トーン、応答形式を設定する指示 | すべての応答に適用したい口調、長さ、形式、またはソフトウェアエンジニア以外の役割で Claude を動作させる場合 | 応答を短くする組み込みの Concise スタイル、すべての質問にまず図で答えるカスタムスタイル |
| **スキル** | Claude が使用できる指示、知識、ワークフロー | 再利用可能なコンテンツ、リファレンスドキュメント、繰り返し可能なタスク | `/deploy` でデプロイチェックリストを実行する、エンドポイントのパターンを含む API ドキュメントのスキル |
| **サブエージェント** | 要約された結果を返す分離された実行コンテキスト | コンテキストの分離、並列タスク、専門化されたワーカー | 多数のファイルを読み込むものの、主要な調査結果のみを返すリサーチタスク |
| **[動的ワークフロー](https://code.claude.com/docs/ja/workflows.md)** | 多数のサブエージェントをバックグラウンドで実行する、Claude が作成するスクリプト | 少数のサブエージェントでは収まりきらない作業、またはクロスチェックしたい調査結果 | コードベース全体を監査し、2 つ目のエージェント群が各調査結果を検証する |
| **[セッション間メッセージング](https://code.claude.com/docs/ja/cross-session-messaging.md)** | Claude がユーザーのあるセッションから別のセッションにメッセージを届ける | ユーザー自身が実行している複数のセッションで、タスクの途中で互いの調査結果が必要な場合 | あるセッションが、自分の加えた変更によって別のセッションの作業の前提が壊れることを警告する |
| **[コードインテリジェンス](https://code.claude.com/docs/ja/tools-reference.md#lsp-tool-behavior)** | 言語サーバーによるナビゲーションと診断 | 型付き言語、grep では遅いまたは不正確な大規模コードベース | ファイル全体を読む代わりにシンボルの定義へジャンプする |
| **MCP** | 外部サービスに接続する | 外部データやアクション | データベースへのクエリ、Slack への投稿、ブラウザーの操作 |
| **フック** | イベントによってトリガーされるスクリプト、HTTP リクエスト、MCP ツール呼び出し、プロンプト、またはサブエージェント | 一致するすべてのイベントで必ず実行する必要がある自動化 | ファイルを編集するたびに ESLint を実行する |
| **[アーティファクト](https://code.claude.com/docs/ja/artifacts.md)** | セッションの出力を非公開のインタラクティブな Web ページとして公開する | ターミナルのテキストではなく視覚的に確認または共有したい出力 | Claude の調査に合わせて更新されるインシデントのタイムライン |

**[プラグイン](https://code.claude.com/docs/ja/plugins/overview.md)** はパッケージングのレイヤーです。プラグインは、スキル、フック、サブエージェント、MCP サーバーを 1 つのインストール可能な単位にまとめます。プラグインのスキルには名前空間が付けられる（`/my-plugin:review` のように）ため、複数のプラグインを共存させることができます。同じセットアップを複数のリポジトリで再利用したい場合や、**[マーケットプレイス](https://code.claude.com/docs/ja/plugins/overview.md)** を通じて他のユーザーに配布したい場合は、プラグインを使用します。

### セットアップを段階的に構築する

最初からすべてを設定する必要はありません。各機能にはわかりやすいきっかけがあり、ほとんどのチームはおおよそ次の順序で機能を追加していきます。

| きっかけ | 追加するもの |
| :- | :- |
| Claude が規約やコマンドを 2 回間違えた | [CLAUDE.md](https://code.claude.com/docs/ja/memory.md) に追加する |
| Claude に短くする、もっと説明する、同じ形式で答えるよう何度も求めている | [出力スタイル](https://code.claude.com/docs/ja/output-styles.md)を設定する |
| タスクを開始するために同じプロンプトを何度も入力している | ユーザーが呼び出せる[スキル](https://code.claude.com/docs/ja/skills.md)として保存する |
| 同じプレイブックや複数ステップの手順をチャットに貼り付けるのが 3 回目になった | [スキル](https://code.claude.com/docs/ja/skills.md)としてまとめる |
| Claude が参照できないブラウザーのタブからデータを何度もコピーしている | そのシステムを [MCP サーバー](https://code.claude.com/docs/ja/mcp.md)として接続する |
| Claude がシンボルの定義箇所や使用箇所を見つけるために多数のファイルを読んでいる | 使用している言語向けの[コードインテリジェンスプラグイン](https://code.claude.com/docs/ja/plugins/code-intelligence.md)をインストールする |
| 付随的なタスクが、後で参照しない出力で会話を埋め尽くしている | [サブエージェント](https://code.claude.com/docs/ja/sub-agents.md)経由で実行する |
| 指示しなくても毎回何かを実行させたい | [フック](https://code.claude.com/docs/ja/hooks-guide.md)を作成する |
| 2 つ目のリポジトリで同じセットアップが必要になった | [プラグイン](https://code.claude.com/docs/ja/plugins/overview.md)としてパッケージ化する |

同じきっかけは、既存の設定を更新すべきタイミングも教えてくれます。繰り返される間違いや何度も出てくるレビューコメントは、チャットでのその場限りの修正ではなく、CLAUDE.md を編集すべきものです。手作業で何度も調整しているワークフローは、改訂が必要なスキルです。

### 似ている機能を比較する

一部の機能は似ているように見えることがあります。どちらを選ぶべきかの詳しい解説については、ブログ記事 [Steering Claude Code: when to use CLAUDE.md, skills, hooks, and subagents](https://claude.com/blog/steering-claude-code-skills-hooks-rules-subagents-and-more) を参照してください。ここでは、それぞれの違いを説明します。

**スキルとサブエージェント**

スキルとサブエージェントは、異なる問題を解決します。

* **スキル**は、任意のコンテキストに読み込める再利用可能なコンテンツです
* **サブエージェント**は、メインの会話とは別に実行される分離されたワーカーです

| 観点 | スキル | サブエージェント |
| - | - | - |
| **概要** | 再利用可能な指示、知識、またはワークフロー | 独自のコンテキストを持つ分離されたワーカー |
| **主な利点** | コンテキスト間でコンテンツを共有できる | コンテキストの分離。作業は別の場所で行われ、要約のみが返される |
| **[コンテキストウィンドウ](https://code.claude.com/docs/ja/context-window.md)への影響** | メインのウィンドウに追加される | 独自の入力トークンと出力トークンを持つ別のウィンドウを使用する |
| **最適な用途** | 参考資料、呼び出し可能なワークフロー | 多数のファイルを読むタスク、並列作業、専門化されたワーカー |

**スキルには参照型とアクション型があります。** 参照型スキルは、Claude がセッション全体で使用する知識（API スタイルガイドなど）を提供します。アクション型スキルは、Claude に特定の処理を実行させます（デプロイワークフローを実行する `/deploy` など）。

コンテキストの分離が必要な場合や、コンテキストウィンドウがいっぱいになりつつある場合は、**サブエージェントを使用します**。サブエージェントは数十のファイルを読んだり広範な検索を実行したりすることがありますが、メインの会話が受け取るのは要約のみです。サブエージェントの作業はメインのコンテキストを消費しないため、途中の作業を表示したままにする必要がない場合にも便利です。カスタムサブエージェントは独自の指示を持つことができ、スキルを事前に読み込むこともできます。

**両者は組み合わせられます。** サブエージェントは特定のスキルを事前に読み込むことができます（`skills:` フィールド）。スキルは `context: fork` を使用して分離されたコンテキストで実行できます。詳細については[スキル](https://code.claude.com/docs/ja/skills.md)を参照してください。

**CLAUDE.md とスキル**

どちらも指示を保存しますが、読み込まれ方と目的が異なります。

| 観点 | CLAUDE.md | スキル |
| - | - | - |
| **読み込み** | すべてのセッションで自動的に | オンデマンド |
| **ファイルを含められるか** | はい、`@path` インポートで | はい、`@path` インポートで |
| **ワークフローをトリガーできるか** | いいえ | はい、`/<name>` で |
| **最適な用途** | 「常に X を行う」ルール | 参考資料、呼び出し可能なワークフロー |

Claude が常に知っておくべきこと（コーディング規約、ビルドコマンド、プロジェクト構造、「X は決して行わない」ルール）であれば、**CLAUDE.md に記述します**。

Claude が時々必要とする参考資料（API ドキュメント、スタイルガイド）や、`/<name>` でトリガーするワークフロー（デプロイ、レビュー、リリース）であれば、**スキルに記述します**。

**目安:** CLAUDE.md は 200 行以内に収めます。長くなってきたら、参照用のコンテンツをスキルに移すか、[`.claude/rules/`](https://code.claude.com/docs/ja/memory#organize-rules-with-claude/rules/) ファイルに分割します。

**CLAUDE.md と出力スタイル**

どちらも Claude に恒常的な指示を与えます。CLAUDE.md は Claude が知っておくべきことを伝え、出力スタイルは Claude がどのように応答するかを設定します。

| 観点 | CLAUDE.md | 出力スタイル |
| - | - | - |
| **保持する内容** | プロジェクトに関する事実とルール | 役割、トーン、応答形式 |
| **切り替え** | 常に読み込まれる | 一度に有効なのは 1 つ。いつでも[スタイルを切り替え](https://code.claude.com/docs/ja/output-styles.md#change-your-output-style)られる |
| **最適な用途** | ビルドコマンド、規約、「X は決して行わない」ルール | 短い応答、コードに添えた説明、エンジニアリング以外の役割 |

どのスタイルを使用していてもプロジェクトに当てはまること（コーディング規約、ビルドコマンド、プロジェクト構造）であれば、**CLAUDE.md に記述します**。

応答そのものに関すること（長さ、形式、Claude がどの程度説明するか、あるいはライティングアシスタントのような別の役割）で、後でオフに戻す可能性があるものであれば、**出力スタイルを使用します**。Claude Code には[組み込みスタイル](https://code.claude.com/docs/ja/output-styles.md#built-in-output-styles)が用意されており、独自のスタイルを作成することもできます。

**両者は組み合わせられます。** どのスタイルを選んでも、CLAUDE.md は読み込まれたままです。Claude はどちらも指示として従うため、どちらも強制されるものではありません。毎回必ず実行する必要があることには、[フック](https://code.claude.com/docs/ja/hooks-guide.md)を使用してください。

**CLAUDE.md とルールとスキル**

3 つとも指示を保存しますが、読み込まれ方が異なります。

| 観点 | CLAUDE.md | `.claude/rules/` | スキル |
| - | - | - | - |
| **読み込み** | すべてのセッション | すべてのセッション、または一致するファイルが開かれたとき | オンデマンド、呼び出されたときまたは関連するとき |
| **スコープ** | プロジェクト全体 | ファイルパスにスコープを限定できる | タスク固有 |
| **最適な用途** | 中核となる規約とビルドコマンド | 言語固有またはディレクトリ固有のガイドライン | 参考資料、繰り返し可能なワークフロー |

すべてのセッションで必要な指示（ビルドコマンド、テストの規約、プロジェクトのアーキテクチャ）には **CLAUDE.md を使用します**。

CLAUDE.md を要点に絞るには**ルールを使用します**。[`paths` フロントマター](https://code.claude.com/docs/ja/memory#path-specific-rules)を持つルールは、Claude が一致するファイルを扱うときにのみ読み込まれるため、コンテキストを節約できます。

Claude が時々しか必要としないコンテンツ（API ドキュメントや、`/<name>` でトリガーするデプロイチェックリストなど）には**スキルを使用します**。

**サブエージェントと動的ワークフロー**

どちらもメインの会話の外で作業を行います。サブエージェントの場合、次に何を実行するかは Claude がターンごとに決定します。ワークフローの場合は、スクリプトが決定します。

* **サブエージェント**は Claude が生成するワーカーで、それぞれが生成元の会話に要約を返します
* **[動的ワークフロー](https://code.claude.com/docs/ja/workflows.md)** は Claude が作成するスクリプトで、多数のサブエージェントをバックグラウンドで実行し、1 つの結果を返します

質問の調査、主張の検証、ファイルのレビューなど、素早く集中して作業するワーカーが必要な場合は、**サブエージェントを使用します**。サブエージェントが作業を行って要約を返すため、メインの会話はすっきりしたままです。Claude が生成時に[名前を付けた](https://code.claude.com/docs/ja/sub-agents.md#subagent-names)サブエージェントは、[互いにメッセージを送る](https://code.claude.com/docs/ja/sub-agents.md#what-loads-at-startup)こともできます。

コードベース全体の監査、大規模な移行、複数の観点から作成する計画など、ジョブが[少数のサブエージェントでは収まりきらない](https://code.claude.com/docs/ja/workflows.md#when-to-use-a-workflow)場合や、調査結果を確認する前にクロスチェックしたい場合は、**動的ワークフローを使用します**。開始するには、[プロンプトでワークフローを依頼します](https://code.claude.com/docs/ja/workflows.md#ask-for-a-workflow-in-your-prompt)。

**あるセッションの調査結果を別のセッションに渡すには**、最初のセッションの Claude に送信を依頼します。Claude は[セッション間メッセージング](https://code.claude.com/docs/ja/cross-session-messaging.md)でそれを届けます。[エージェントを並列実行する](https://code.claude.com/docs/ja/agents.md)では、作業を任せて後で確認するセッションを含め、複数の Claude を同時に実行するその他の方法を比較しています。

**MCP とスキル**

MCP は Claude を外部サービスに接続します。スキルは、それらのサービスを効果的に使用する方法を含め、Claude の知識を拡張します。

| 観点 | MCP | スキル |
| - | - | - |
| **概要** | 外部サービスに接続するためのプロトコル | 知識、ワークフロー、参考資料 |
| **提供するもの** | ツールとデータへのアクセス | 知識、ワークフロー、参考資料 |
| **例** | Slack 連携、データベースクエリ、ブラウザーの操作 | コードレビューのチェックリスト、デプロイワークフロー、API スタイルガイド |

これらは異なる問題を解決し、組み合わせるとうまく機能します。

**MCP** は、外部システム用に特化したツールを Claude に提供し、接続と認証はサーバーが処理します。

**スキル**は、それらのツールを効果的に使用する方法についての知識と、`/<name>` でトリガーできるワークフローを Claude に提供します。スキルには、チームのデータベーススキーマやクエリパターン、あるいはチームのメッセージ書式ルールを含む `/post-to-slack` ワークフローなどを含めることができます。

**フックとスキル**

Claude Code は、フックをライフサイクルイベントで実行し、スキルは Claude が適用できるようにコンテキストに読み込みます。

| 観点 | フック | スキル |
| - | - | - |
| **実行するもの** | シェルコマンド、HTTP リクエスト、MCP ツール呼び出し、LLM プロンプト、またはサブエージェント | Claude が読んで従う指示 |
| **トリガー** | `PostToolUse` や `SessionStart` などの[ライフサイクルイベント](https://code.claude.com/docs/ja/hooks.md#hook-events) | ユーザーが `/<name>` と入力するか、Claude が説明をタスクに一致すると判断したとき |
| **決定性** | Claude の判断なしにイベントで発火する | Claude が指示を解釈するため、結果は変わり得る |
| **コンテキストのコスト** | フックが出力を返さない限りゼロ | 説明は各セッションで読み込まれ、全内容は使用時に読み込まれる |
| **最適な用途** | 編集後の lint、安全でないコマンドのブロック、ログ記録、通知 | 推論が必要なワークフロー、参考資料、複数ステップのタスク |

アクションを毎回同じ方法で実行する必要があり、Claude に考えさせる必要がない場合は、**フックを使用します**。たとえば、保存時のフォーマット、`rm -rf /` の拒否、セッション終了時の Slack メッセージの投稿などです。

手順の適用方法を Claude に判断させたい場合や、内容がスクリプトではなく知識である場合は、**スキルを使用します**。たとえば、`/release` チェックリスト、API スタイルガイド、デバッグのプレイブックなどです。

**ガードレールはフックに置きます。** CLAUDE.md やスキルに書かれた「`.env` は決して編集しない」といった指示は要望であり、保証ではありません。編集をブロックする `PreToolUse` フックは強制力を持ちます。ルールを毎回必ず守らせる必要がある場合は、プロンプトの指示ではなくフックにします。

**フックの出力はコンテキストに入ります。** リンターを実行する `PostToolUse` フックは、結果を Claude が読むテキストとして返します。`/fix-lint` スキルは、それらを解決する方法を Claude に伝えます。

### 機能の階層構造を理解する

機能は、ユーザー全体、プロジェクトごと、プラグイン経由、または管理ポリシーを通じてなど、複数のレベルで定義できます。また、CLAUDE.md ファイルをサブディレクトリにネストしたり、モノレポの特定のパッケージにスキルを配置したりすることもできます。同じ機能が複数のレベルに存在する場合、次のように階層化されます。

* **CLAUDE.md ファイル**は加算的です。すべてのレベルが同時に Claude のコンテキストにコンテンツを提供します。作業ディレクトリとその上位のファイルは起動時に読み込まれ、サブディレクトリのファイルはそこで作業するときに読み込まれます。指示が矛盾する場合、Claude は判断してそれらを調整します。[CLAUDE.md ファイルの読み込み方法](https://code.claude.com/docs/ja/memory.md#how-claude-md-files-load)を参照してください。
* **スキルとサブエージェント**は名前で上書きされます。同じ名前が複数のレベルに存在する場合、優先順位に基づいて 1 つの定義が採用されます（スキルは managed > user > project、サブエージェントは managed > CLI フラグ > project > user > plugin）。プラグインのスキルは競合を避けるために[名前空間が付けられます](https://code.claude.com/docs/ja/plugins/components.md#skills)。[スキルの検出](https://code.claude.com/docs/ja/skills.md#resolve-skills-that-share-a-name)と[サブエージェントのスコープ](https://code.claude.com/docs/ja/sub-agents.md#choose-the-subagent-scope)を参照してください。
* **MCP サーバー**は名前で上書きされます（local > project > user）。[MCP のスコープ](https://code.claude.com/docs/ja/mcp.md#scope-hierarchy-and-precedence)を参照してください。
* **フック**はマージされます。登録されたすべてのフックは、ソースに関係なく一致するイベントで発火します。[フック](https://code.claude.com/docs/ja/hooks.md)を参照してください。

### 機能を組み合わせる

各拡張機能は異なる問題を解決します。CLAUDE.md は常時有効なコンテキスト、スキルはオンデマンドの知識とワークフロー、MCP は外部接続、サブエージェントは分離、フックは自動化を担います。実際のセットアップでは、ワークフローに応じてこれらを組み合わせます。

たとえば、プロジェクトの規約には CLAUDE.md を、デプロイワークフローにはスキルを、データベースへの接続には MCP を、編集のたびに lint を実行するにはフックを使用できます。それぞれの機能が最も得意なことを担当します。

| パターン | 仕組み | 例 |
| - | - | - |
| **スキル + MCP** | MCP が接続を提供し、スキルがその上手な使い方を Claude に教える | MCP がデータベースに接続し、スキルがスキーマとクエリパターンを文書化する |
| **スキル + サブエージェント** | スキルが並列作業のためにサブエージェントを生成する | `/audit` スキルが、分離されたコンテキストで作業するセキュリティ、パフォーマンス、スタイルのサブエージェントを起動する |
| **CLAUDE.md + スキル** | CLAUDE.md が常時有効なルールを保持し、スキルがオンデマンドで読み込まれる参考資料を保持する | CLAUDE.md には「API の規約に従う」と記述し、スキルには完全な API スタイルガイドを含める |
| **フック + MCP** | フックが MCP を通じて外部アクションをトリガーする | Claude が重要なファイルを変更したときに、編集後のフックが Slack 通知を送信する |

## コンテキストコストを理解する

追加する各機能は Claude のコンテキストの一部を消費します。多すぎるとコンテキストウィンドウがいっぱいになる可能性がありますが、Claude の効果を低下させるノイズを追加することもできます。スキルが正しくトリガーされない場合や、Claude が規約を失う場合があります。これらのトレードオフを理解することで、効果的なセットアップを構築するのに役立ちます。実行中のセッションでこれらの機能がどのように組み合わされるかのインタラクティブビューについては、[コンテキストウィンドウを探索する](https://code.claude.com/docs/ja/context-window.md) を参照してください。

### 機能別のコンテキストコスト

各機能には異なるロード戦略とコンテキストコストがあります。

| 機能 | ロード時期 | ロード内容 | コンテキストコスト |
| - | - | - | - |
| **CLAUDE.md** | セッション開始 | セッション開始時にロードされる各ファイルの完全なコンテンツ | すべてのリクエスト |
| **Output styles** | セッション開始、およびスタイルを切り替えるときに再度 | アクティブなスタイルの完全な指示。デフォルトスタイルの場合は何もロードされない | すべてのリクエスト |
| **Skills** | セッション開始 + 使用時 | 開始時の説明、使用時の完全なコンテンツ | 低い（毎リクエスト説明）\* |
| **MCP サーバー** | セッション開始 | ツール名。完全なスキーマはオンデマンド | 低い（ツール使用まで） |
| **Code intelligence** | ファイル編集後およびオンデマンド | 編集後の診断。シンボル検索時の定義、参照、型情報 | 低い。ファイル読み取りを削減 |
| **Subagents** | スポーン時 | 指定されたスキルを持つ新しいコンテキスト、または [fork](https://code.claude.com/docs/ja/sub-agents.md#fork-the-current-conversation) の親会話 | メインセッションから分離 |
| **Hooks** | トリガー時 | なし（外部で実行） | ゼロ（フックが追加コンテキストを返さない限り） |

\*スキルのフロントマターで [`disable-model-invocation: true`](https://code.claude.com/docs/ja/skills#control-who-invokes-a-skill) を設定すると、その説明を Claude のコンテキストから除外できます。書いていないスキルの場合は、ファイルを編集せずに同じことを行うために設定で [`skillOverrides`](https://code.claude.com/docs/ja/skills#override-skill-visibility-from-settings) を設定します。

### 機能がどのようにロードされるかを理解する

各機能はセッション内の異なるポイントでロードされます。以下のタブは、各機能がいつロードされるか、およびコンテキストに何が入るかを説明しています。

![コンテキストロード：CLAUDE.md はセッション開始時にロードされ、すべてのリクエストに留まります。MCP ツール名は開始時にロードされ、完全なスキーマは使用時に遅延されます。スキルは開始時に説明をロードし、呼び出し時に完全なコンテンツをロードします。Subagents は独立したコンテキストを取得します。Hooks は外部で実行されます。](https://mintcdn.com/claude-code/ikqp3_70mqIahteV/images/context-loading.svg?fit=max\&auto=format\&n=ikqp3_70mqIahteV\&q=85\&s=aab139e750494a237ae2e0c8f9139b0a)

**CLAUDE.md**

**時期：** セッション開始

**ロード内容：** セッション開始時にロードされる各 CLAUDE.md ファイル（管理、ユーザー、プロジェクトレベル）の完全なコンテンツ。

**継承：** Claude は作業ディレクトリからルートまで CLAUDE.md ファイルを読み取り、サブディレクトリにネストされたものを、それらのファイルにアクセスするときに検出します。詳細は [CLAUDE.md ファイルがどのようにロードされるか](https://code.claude.com/docs/ja/memory.md#how-claude-md-files-load) を参照してください。ネストされた CLAUDE.md が[ファイルごとのサイズ制限](https://code.claude.com/docs/ja/memory.md#claude-ignores-the-end-of-my-subdirectory-claude-md)を超えている場合、Claude はファイルの先頭部分のみを受け取ります。

> [!TIP]
>
> CLAUDE.md を 200 行以下に保ちます。リファレンスマテリアルをスキルに移動します。スキルはオンデマンドでロードされます。[チェックインされた CLAUDE.md のトリム提案を取得する](https://code.claude.com/docs/ja/memory.md#my-claude-md-is-too-large) には、`/doctor` を実行します。

**Skills**

スキルは Claude のツールキットの追加機能です。リファレンスマテリアル（API スタイルガイドなど）または `/<name>` でトリガーする呼び出し可能なワークフロー（`/deploy` など）です。Claude Code は `/code-review`、`/batch`、`/debug` などの[バンドルされたスキル](https://code.claude.com/docs/ja/commands.md) を備えており、すぐに機能します。独自のスキルを作成することもできます。

**時期：** スキルの設定によって異なります。デフォルトでは、説明はセッション開始時にロードされ、完全なコンテンツは使用時にロードされます。ユーザーのみのスキル（`disable-model-invocation: true`）の場合、呼び出すまで何もロードされません。

**ロード内容：** モデル呼び出し可能なスキルの場合、Claude はすべてのリクエストで名前と説明を見ます。`/<name>` でスキルを呼び出すか、Claude が自動的にロードする場合、完全なコンテンツが会話にロードされます。

**Claude がスキルを選択する方法：** Claude はタスクをスキル説明と照合して、関連するものを決定します。説明が曖昧または重複している場合、Claude は間違ったスキルをロードするか、役立つスキルを見落とす可能性があります。Claude に特定のスキルを使用するよう指示するには、`/<name>` で呼び出します。

**コンテキストコスト：** 使用されるまで低い。ユーザーのみのスキルは呼び出されるまでゼロコストです。

**サブエージェント内：** サブエージェントの `skills` フィールドにリストされているスキルの完全なコンテンツは、オンデマンドではなく[起動時にそのコンテキストにロードされます](https://code.claude.com/docs/ja/sub-agents.md#preload-skills-into-subagents)。サブエージェントは引き続き、Skill ツールを通じてリストされていないプロジェクト、ユーザー、プラグインのスキルを発見して呼び出すことができます。

> [!TIP]
>
> 副作用を持つスキルには `disable-model-invocation: true` を使用します。これによりコンテキストを節約でき、名前を指定したときにのみ実行されるようになります。

**MCP servers**

**時期：** セッション開始。

**ロード内容：** 接続されたサーバーからのツール名とサーバー指示。完全な JSON スキーマは Claude が特定のツールを必要とするまで遅延されます。

**コンテキストコスト：** [ツール検索](https://code.claude.com/docs/ja/mcp.md#scale-with-mcp-tool-search) はデフォルトで有効になっているため、アイドル MCP ツールは最小限のコンテキストを消費します。

> [!TIP]
>
> `/mcp` を実行して各サーバーの接続ステータスを確認します。`/context all` を実行して、ロードされた各 MCP ツールが使用するトークン数を確認します。Claude Code は、リモートサーバーが切断された場合は[自動的に再接続](https://code.claude.com/docs/ja/mcp.md#automatic-reconnection) し、積極的に使用していないサーバーを切断できます。

**Code intelligence**

**時期：** ファイル編集後、および Claude がコードをナビゲートするときのオンデマンド。

**ロード内容：** 各ファイル編集後の型エラーと警告。Claude がシンボルを検索するときの定義、参照、型情報。

**コンテキストコスト：** 低い。シンボル検索は多くの場合、広範なファイル読み取りを置き換えるため、ネットコンテキスト使用量は減少する可能性があります。

> [!TIP]
>
> LSP ツールは、言語の[コード intelligence プラグイン](https://code.claude.com/docs/ja/plugins/code-intelligence.md) をインストールするまで非アクティブです。

**Subagents**

**時期：** オンデマンド、タスクのためにあなたまたは Claude がスポーンするとき。

**ロード内容：** 以下を含む新しい独立したコンテキスト：

* エージェント独自のシステムプロンプト（Claude Code システムプロンプトではない）
* エージェントの `skills:` フィールドにリストされているスキルの完全なコンテンツ
* CLAUDE.md と git ステータス。組み込みの Explore および Plan エージェントは[どちらもなしで開始](https://code.claude.com/docs/ja/sub-agents.md#what-loads-at-startup) し、定義で [`omitClaudeMd`](https://code.claude.com/docs/ja/sub-agents#supported-frontmatter-fields) を設定したエージェントは、ユーザー、プロジェクト、ローカル CLAUDE.md ファイルなしで開始します。
* リードエージェントがプロンプトで渡すコンテキスト

[fork](https://code.claude.com/docs/ja/sub-agents.md#fork-the-current-conversation) の場合、Claude Code は親の会話（これまでのところ）、システムプロンプト、ツールをロードします。

**コンテキストコスト：** メインセッションから分離。

> [!TIP]
>
> フルな会話コンテキストが必要ない作業に subagents を使用します。それらの分離はメインセッションの膨張を防ぎます。

**Hooks**

**時期：** トリガー時。Claude Code はツール実行、セッション境界、プロンプト送信、権限リクエスト、コンパクション などの特定のライフサイクルイベントで hooks を実行します。完全なリストは [Hooks](https://code.claude.com/docs/ja/hooks.md) を参照してください。

**ロード内容：** デフォルトではなし。フックは外部で実行されます。

**コンテキストコスト：** ゼロ（フックが会話にメッセージとして追加されるコンテキストを返さない限り）。

> [!TIP]
>
> フックは Claude のコンテキストに影響する必要がない副作用（リント、ロギング）に最適です。

## 詳細を学ぶ

各機能には、セットアップ指示、例、設定オプションを含む独自のガイドがあります。

> **[CLAUDE.md](https://code.claude.com/docs/ja/memory.md)**
>
> プロジェクトコンテキスト、規約、指示を保存

> **[Skills](https://code.claude.com/docs/ja/skills.md)**
>
> Claude にドメイン専門知識と再利用可能なワークフローを提供

> **[Subagents](https://code.claude.com/docs/ja/sub-agents.md)**
>
> 独立したコンテキストに作業をオフロード

> **[Dynamic workflows](https://code.claude.com/docs/ja/workflows.md)**
>
> 1 つのスクリプトから多くのサブエージェントを実行

> **[Cross-session messaging](https://code.claude.com/docs/ja/cross-session-messaging.md)**
>
> Claude が他のセッションにメッセージを送信できるようにする

> **[MCP](https://code.claude.com/docs/ja/mcp.md)**
>
> Claude を外部サービスに接続

> **[Hooks](https://code.claude.com/docs/ja/hooks-guide.md)**
>
> フックでアクションを自動化

> **[Plugins](https://code.claude.com/docs/ja/plugins/overview.md)**
>
> 機能セットをバンドルして共有

> **[Marketplaces](https://code.claude.com/docs/ja/plugins/create-marketplace.md)**
>
> プラグインコレクションをホストして配布
