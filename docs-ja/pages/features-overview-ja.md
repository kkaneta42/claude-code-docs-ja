> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# Claude Code を拡張する

> CLAUDE.md、Skills、subagents、hooks、MCP、plugins をいつ使用するかを理解します。

Claude Code は、コードについて推論するモデルと、ファイル操作、検索、実行、ウェブアクセス用の[組み込みツール](/ja/how-claude-code-works#tools)を組み合わせています。組み込みツールはほとんどのコーディングタスクをカバーしています。このガイドは拡張レイヤーについて説明します。これは、Claude が何を知るかをカスタマイズし、外部サービスに接続し、ワークフローを自動化するために追加する機能です。

<Note>
  コア agentic ループがどのように機能するかについては、[How Claude Code works](/ja/how-claude-code-works) を参照してください。
</Note>

**Claude Code は初めてですか？** [CLAUDE.md](/ja/memory) でプロジェクト規約を開始します。必要に応じて他の拡張機能を追加してください。

## 概要

拡張機能は agentic ループのさまざまな部分に接続します。

* **[CLAUDE.md](/ja/memory)** は、Claude がすべてのセッションで見る永続的なコンテキストを追加します
* **[Skills](/ja/skills)** は再利用可能な知識と呼び出し可能なワークフローを追加します
* **[MCP](/ja/mcp)** は Claude を外部サービスとツールに接続します
* **[Subagents](/ja/sub-agents)** は独立したコンテキストで独自のループを実行し、サマリーを返します
* **[Agent teams](/ja/agent-teams)** は、共有タスクとピアツーピアメッセージングを使用して複数の独立したセッションを調整します
* **[Hooks](/ja/hooks)** はループの外側で決定論的スクリプトとして実行されます
* **[Plugins](/ja/plugins)** と **[marketplaces](/ja/plugin-marketplaces)** はこれらの機能をパッケージ化して配布します

[Skills](/ja/skills) は最も柔軟な拡張機能です。skill は知識、ワークフロー、または指示を含むマークダウンファイルです。`/deploy` のようなスラッシュコマンドで skill を呼び出すことができます。または Claude は関連する場合に自動的にそれらを読み込むことができます。skill は現在の会話で実行することも、subagents を介して分離されたコンテキストで実行することもできます。

## 機能をあなたの目標に合わせる

機能は、Claude がすべてのセッションで見る常時オンのコンテキストから、あなたまたは Claude が呼び出すことができるオンデマンド機能、特定のイベントで実行されるバックグラウンド自動化まで、さまざまです。以下の表は、利用可能なものと各機能が意味をなす場合を示しています。

| 機能                                 | 機能                           | 使用する場合                            | 例                                                               |
| ---------------------------------- | ---------------------------- | --------------------------------- | --------------------------------------------------------------- |
| **CLAUDE.md**                      | すべての会話で読み込まれる永続的なコンテキスト      | プロジェクト規約、「常に X を実行する」ルール          | 「npm ではなく pnpm を使用します。コミット前にテストを実行します。」                         |
| **Skill**                          | Claude が使用できる指示、知識、ワークフロー    | 再利用可能なコンテンツ、リファレンスドキュメント、反復可能なタスク | `/review` はコードレビューチェックリストを実行します。エンドポイントパターンを持つ API ドキュメント skill |
| **Subagent**                       | 要約された結果を返す分離された実行コンテキスト      | コンテキスト分離、並列タスク、特殊なワーカー            | 多くのファイルを読み取るが、主要な結果のみを返す研究タスク                                   |
| **[Agent teams](/ja/agent-teams)** | 複数の独立した Claude Code セッションを調整 | 並列研究、新機能開発、競合する仮説でのデバッグ           | セキュリティ、パフォーマンス、テストを同時にチェックするレビュアーをスポーン                          |
| **MCP**                            | 外部サービスに接続                    | 外部データまたはアクション                     | データベースをクエリ、Slack に投稿、ブラウザを制御                                    |
| **Hook**                           | イベントで実行される決定論的スクリプト          | 予測可能な自動化、LLM は関与しない               | すべてのファイル編集後に ESLint を実行                                         |

**[Plugins](/ja/plugins)** はパッケージングレイヤーです。plugin は skill、hook、subagent、MCP サーバーを単一のインストール可能なユニットにバンドルします。Plugin skill は名前空間化されています（`/my-plugin:review` など）ため、複数の plugin が共存できます。同じセットアップを複数のリポジトリ全体で再利用したい場合、または **[marketplace](/ja/plugin-marketplaces)** を介して他のユーザーに配布したい場合は plugin を使用します。

### 類似機能を比較する

一部の機能は似ているように見えることがあります。ここでそれらを区別する方法を説明します。

<Tabs>
  <Tab title="Skill vs Subagent">
    Skill と subagent は異なる問題を解決します。

    * **Skills** は任意のコンテキストに読み込むことができる再利用可能なコンテンツです
    * **Subagents** はメインの会話とは別に実行される分離されたワーカーです

    | 側面        | Skill                     | Subagent                       |
    | --------- | ------------------------- | ------------------------------ |
    | **それは何か** | 再利用可能な指示、知識、またはワークフロー     | 独自のコンテキストを持つ分離されたワーカー          |
    | **主な利点**  | コンテキスト全体でコンテンツを共有         | コンテキスト分離。作業は別々に行われ、サマリーのみが返される |
    | **最適な用途** | リファレンスマテリアル、呼び出し可能なワークフロー | 多くのファイルを読み取るタスク、並列作業、特殊なワーカー   |

    **Skill はリファレンスまたはアクションです。** リファレンス skill は Claude がセッション全体で使用する知識を提供します（API スタイルガイドなど）。アクション skill は Claude に特定の操作を実行するよう指示します（デプロイメントワークフローを実行する `/deploy` など）。

    **コンテキスト分離が必要な場合、または コンテキストウィンドウがいっぱいになっている場合は subagent を使用します。** subagent は数十のファイルを読み取るか、広範な検索を実行する可能性がありますが、メインの会話はサマリーのみを受け取ります。subagent の作業はメインコンテキストを消費しないため、中間作業を表示したままにする必要がない場合にも便利です。カスタム subagent は独自の指示を持つことができ、skill をプリロードできます。

    **それらは組み合わせることができます。** subagent は特定の skill をプリロードできます（`skills:` フィールド）。skill は `context: fork` を使用して分離されたコンテキストで実行できます。詳細は [Skills](/ja/skills) を参照してください。
  </Tab>

  <Tab title="CLAUDE.md vs Skill">
    どちらも指示を保存しますが、読み込み方法と目的が異なります。

    | 側面                  | CLAUDE.md          | Skill                     |
    | ------------------- | ------------------ | ------------------------- |
    | **読み込み**            | すべてのセッション、自動的に     | オンデマンド                    |
    | **ファイルを含めることができます** | はい、`@path` インポート付き | はい、`@path` インポート付き        |
    | **ワークフローをトリガーできます** | いいえ                | はい、`/<name>` 付き           |
    | **最適な用途**           | 「常に X を実行する」ルール    | リファレンスマテリアル、呼び出し可能なワークフロー |

    **Claude が常にそれを知るべき場合は CLAUDE.md に入れます。** コーディング規約、ビルドコマンド、プロジェクト構造、「X を実行しないでください」ルール。

    **Claude が時々必要とするリファレンスマテリアル（API ドキュメント、スタイルガイド）である場合、または `/<name>` でトリガーするワークフロー（デプロイ、レビュー、リリース）である場合は skill に入れます。**

    **経験則：** CLAUDE.md を約 500 行以下に保ちます。増加している場合は、リファレンスコンテンツを skill に移動します。
  </Tab>

  <Tab title="Subagent vs Agent team">
    どちらも作業を並列化しますが、アーキテクチャ的には異なります。

    * **Subagents** はセッション内で実行され、結果をメインコンテキストに報告します
    * **Agent teams** は独立した Claude Code セッションであり、互いに通信します

    | 側面          | Subagent                     | Agent team                   |
    | ----------- | ---------------------------- | ---------------------------- |
    | **コンテキスト**  | 独自のコンテキストウィンドウ。結果は呼び出し元に返される | 独自のコンテキストウィンドウ。完全に独立         |
    | **通信**      | 結果をメインエージェントにのみ報告            | チームメイトが直接互いにメッセージを送信         |
    | **調整**      | メインエージェントがすべての作業を管理          | 共有タスクリストと自己調整                |
    | **最適な用途**   | 結果のみが重要な焦点を絞ったタスク            | 議論と協力が必要な複雑な作業               |
    | **トークンコスト** | 低い：結果がメインコンテキストに要約されて返される    | 高い：各チームメイトは個別の Claude インスタンス |

    **クイックで焦点を絞ったワーカーが必要な場合は subagent を使用します。** 質問を研究し、主張を検証し、ファイルをレビューします。subagent は作業を実行してサマリーを返します。メインの会話はクリーンなままです。

    **チームメイトが結果を共有し、互いに異議を唱え、独立して調整する必要がある場合は agent team を使用します。** Agent team は競合する仮説での研究、並列コードレビュー、各チームメイトが個別の部分を所有する新機能開発に最適です。

    **遷移ポイント：** 並列 subagent を実行しているがコンテキスト制限に達している場合、または subagent が互いに通信する必要がある場合、agent team は自然な次のステップです。

    <Note>
      Agent team は実験的であり、デフォルトで無効になっています。セットアップと現在の制限については [agent teams](/ja/agent-teams) を参照してください。
    </Note>
  </Tab>

  <Tab title="MCP vs Skill">
    MCP は Claude を外部サービスに接続します。Skill は Claude が知ることを拡張します。これらのサービスを効果的に使用する方法を含みます。

    | 側面        | MCP                       | Skill                                 |
    | --------- | ------------------------- | ------------------------------------- |
    | **それは何か** | 外部サービスに接続するためのプロトコル       | 知識、ワークフロー、リファレンスマテリアル                 |
    | **提供**    | ツールとデータアクセス               | 知識、ワークフロー、リファレンスマテリアル                 |
    | **例**     | Slack 統合、データベースクエリ、ブラウザ制御 | コードレビューチェックリスト、デプロイワークフロー、API スタイルガイド |

    これらは異なる問題を解決し、一緒に機能します。

    **MCP** は Claude に外部システムと相互作用する能力を与えます。MCP がなければ、Claude はデータベースをクエリしたり、Slack に投稿したりできません。

    **Skills** は Claude にこれらのツールを効果的に使用する方法についての知識を与え、さらに `/<name>` でトリガーできるワークフローを提供します。skill には、チームのデータベーススキーマとクエリパターン、または `/post-to-slack` ワークフローとチームのメッセージフォーマットルールが含まれる場合があります。

    例：MCP サーバーは Claude をデータベースに接続します。skill は Claude にデータモデル、一般的なクエリパターン、さまざまなタスクに使用するテーブルを教えます。
  </Tab>
</Tabs>

### 機能がどのようにレイヤーするかを理解する

機能は複数のレベルで定義できます。ユーザー全体、プロジェクトごと、plugin を介して、または管理ポリシーを通じて。また、サブディレクトリに CLAUDE.md ファイルをネストしたり、monorepo の特定のパッケージに skill を配置したりすることもできます。同じ機能が複数のレベルに存在する場合、ここでそれらがどのようにレイヤーするかを説明します。

* **CLAUDE.md ファイル** は加算的です。すべてのレベルがコンテンツを同時に Claude のコンテキストに提供します。作業ディレクトリ以上のファイルは起動時に読み込まれます。サブディレクトリは作業中に読み込まれます。指示が競合する場合、Claude は判断を使用してそれらを調整し、より具体的な指示が通常優先されます。[Claude がメモリを検索する方法](/ja/memory#how-claude-looks-up-memories) を参照してください。
* **Skills と subagents** は名前でオーバーライドします。同じ名前が複数のレベルに存在する場合、優先度に基づいて 1 つの定義が勝ちます（skill の場合は managed > user > project。subagent の場合は managed > CLI flag > project > user > plugin）。Plugin skill は [名前空間化](/ja/plugins#add-skills-to-your-plugin) されており、競合を回避します。[skill discovery](/ja/skills#where-skills-live) と [subagent scope](/ja/sub-agents#choose-the-subagent-scope) を参照してください。
* **MCP サーバー** は名前でオーバーライドします。local > project > user。[MCP scope](/ja/mcp#scope-hierarchy-and-precedence) を参照してください。
* **Hooks** はマージされます。ソースに関係なく、すべての登録済みフックは一致するイベントに対して発火します。[Hooks](/ja/hooks) を参照してください。

### 機能を組み合わせる

各拡張機能は異なる問題を解決します。CLAUDE.md は常時オンのコンテキストを処理し、skill はオンデマンド知識とワークフローを処理し、MCP は外部接続を処理し、subagent は分離を処理し、hook は自動化を処理します。実際のセットアップはワークフローに基づいてそれらを組み合わせます。

たとえば、CLAUDE.md をプロジェクト規約に使用し、デプロイメントワークフロー用の skill を使用し、データベースに接続するために MCP を使用し、すべての編集後にリント実行する hook を使用する場合があります。各機能は最適な機能を処理します。

| パターン                   | 機能                                                           | 例                                                             |
| ---------------------- | ------------------------------------------------------------ | ------------------------------------------------------------- |
| **Skill + MCP**        | MCP は接続を提供します。skill は Claude にそれを効果的に使用する方法を教えます             | MCP はデータベースに接続し、skill はスキーマとクエリパターンを文書化します                    |
| **Skill + Subagent**   | skill は並列作業用に subagent をスポーン                                 | `/review` skill はセキュリティ、パフォーマンス、スタイル subagent を分離されたコンテキストで実行 |
| **CLAUDE.md + Skills** | CLAUDE.md は常時オンのルールを保持します。skill はオンデマンドで読み込まれるリファレンスマテリアルを保持 | CLAUDE.md は「API 規約に従う」と言い、skill には完全な API スタイルガイドが含まれます       |
| **Hook + MCP**         | hook は MCP を通じて外部アクションをトリガー                                  | 編集後フックは Claude が重要なファイルを変更するときに Slack 通知を送信                   |

## コンテキストコストを理解する

追加する各機能は Claude のコンテキストの一部を消費します。多すぎるとコンテキストウィンドウがいっぱいになる可能性がありますが、Claude の効果を低下させるノイズを追加することもできます。skill が正しくトリガーされない場合や、Claude が規約を失う場合があります。これらのトレードオフを理解することで、効果的なセットアップを構築できます。

### 機能別のコンテキストコスト

各機能には異なる読み込み戦略とコンテキストコストがあります。

| 機能            | 読み込み時期        | 読み込まれるもの                 | コンテキストコスト                |
| ------------- | ------------- | ------------------------ | ------------------------ |
| **CLAUDE.md** | セッション開始       | 完全なコンテンツ                 | すべてのリクエスト                |
| **Skills**    | セッション開始 + 使用時 | 開始時の説明、使用時の完全なコンテンツ      | 低い（すべてのリクエストの説明）\*       |
| **MCP サーバー**  | セッション開始       | すべてのツール定義とスキーマ           | すべてのリクエスト                |
| **Subagents** | スポーン時         | 指定された skill を持つ新しいコンテキスト | メインセッションから分離             |
| **Hooks**     | トリガー時         | なし（外部で実行）                | ゼロ、hook が追加コンテキストを返さない限り |

\*デフォルトでは、skill の説明はセッション開始時に読み込まれるため、Claude はそれらを使用する時期を決定できます。skill のフロントマターで `disable-model-invocation: true` を設定して、手動で呼び出すまで完全に非表示にします。これにより、自分でのみトリガーする skill のコンテキストコストをゼロに削減します。

### 機能がどのように読み込まれるかを理解する

各機能はセッションの異なるポイントで読み込まれます。以下のタブは、各機能がいつ読み込まれるか、およびコンテキストに何が入るかを説明しています。

<img src="https://mintcdn.com/claude-code/TBPmHzr19mDCuhZi/images/context-loading.svg?fit=max&auto=format&n=TBPmHzr19mDCuhZi&q=85&s=43114d93ae62bdc1ab6aa64660e2ba3b" alt="コンテキスト読み込み：CLAUDE.md と MCP はセッション開始時に読み込まれ、すべてのリクエストに留まります。Skill は開始時に説明を読み込み、呼び出し時に完全なコンテンツを読み込みます。Subagent は分離されたコンテキストを取得します。Hook は外部で実行されます。" data-og-width="720" width="720" data-og-height="410" height="410" data-path="images/context-loading.svg" data-optimize="true" data-opv="3" srcset="https://mintcdn.com/claude-code/TBPmHzr19mDCuhZi/images/context-loading.svg?w=280&fit=max&auto=format&n=TBPmHzr19mDCuhZi&q=85&s=cc37ac2b6b486c75dea4cf64add648ec 280w, https://mintcdn.com/claude-code/TBPmHzr19mDCuhZi/images/context-loading.svg?w=560&fit=max&auto=format&n=TBPmHzr19mDCuhZi&q=85&s=22394bf8452988091802c6bc471a3153 560w, https://mintcdn.com/claude-code/TBPmHzr19mDCuhZi/images/context-loading.svg?w=840&fit=max&auto=format&n=TBPmHzr19mDCuhZi&q=85&s=aaf0301abbd63349b3f5ecf27f3bc4c5 840w, https://mintcdn.com/claude-code/TBPmHzr19mDCuhZi/images/context-loading.svg?w=1100&fit=max&auto=format&n=TBPmHzr19mDCuhZi&q=85&s=f262d974340400cfd964c555b523808a 1100w, https://mintcdn.com/claude-code/TBPmHzr19mDCuhZi/images/context-loading.svg?w=1650&fit=max&auto=format&n=TBPmHzr19mDCuhZi&q=85&s=430b76391f55ba65a0a3da569a52a450 1650w, https://mintcdn.com/claude-code/TBPmHzr19mDCuhZi/images/context-loading.svg?w=2500&fit=max&auto=format&n=TBPmHzr19mDCuhZi&q=85&s=46522043165b15cfef464d5f63c70f7c 2500w" />

<Tabs>
  <Tab title="CLAUDE.md">
    **時期：** セッション開始

    **読み込まれるもの：** すべての CLAUDE.md ファイルの完全なコンテンツ（管理、ユーザー、プロジェクトレベル）。

    **継承：** Claude は作業ディレクトリからルートまで CLAUDE.md ファイルを読み取り、それらのファイルにアクセスするときにサブディレクトリ内のネストされたものを検出します。詳細は [Claude がメモリを検索する方法](/ja/memory#how-claude-looks-up-memories) を参照してください。

    <Tip>CLAUDE.md を約 500 行以下に保ちます。リファレンスマテリアルを skill に移動します。これはオンデマンドで読み込まれます。</Tip>
  </Tab>

  <Tab title="Skills">
    Skill は Claude のツールキットの追加機能です。リファレンスマテリアル（API スタイルガイドなど）または `/<name>` でトリガーする呼び出し可能なワークフロー（`/deploy` など）です。一部は組み込みです。独自に作成することもできます。Claude は適切な場合に skill を使用するか、直接呼び出すことができます。

    **時期：** skill の設定によって異なります。デフォルトでは、説明はセッション開始時に読み込まれ、完全なコンテンツは使用時に読み込まれます。ユーザーのみの skill（`disable-model-invocation: true`）の場合、呼び出すまで何も読み込まれません。

    **読み込まれるもの：** モデル呼び出し可能な skill の場合、Claude はすべてのリクエストで名前と説明を見ます。`/<name>` で skill を呼び出すか、Claude が自動的にそれを読み込むと、完全なコンテンツが会話に読み込まれます。

    **Claude が skill を選択する方法：** Claude はタスクを skill の説明と照合して、関連するものを決定します。説明が曖昧または重複している場合、Claude は間違った skill を読み込むか、役立つものを見落とす可能性があります。Claude に特定の skill を使用するよう指示するには、`/<name>` で呼び出します。`disable-model-invocation: true` を持つ skill は、呼び出すまで Claude に見えません。

    **コンテキストコスト：** 使用されるまで低い。ユーザーのみの skill は呼び出されるまでコストがゼロです。

    **Subagent 内：** Skill は subagent で異なる動作をします。オンデマンド読み込みの代わりに、subagent に渡された skill は起動時にそのコンテキストに完全にプリロードされます。Subagent はメインセッションから skill を継承しません。明示的に指定する必要があります。

    <Tip>副作用のある skill には `disable-model-invocation: true` を使用します。これはコンテキストを節約し、あなたのみがそれらをトリガーすることを保証します。</Tip>
  </Tab>

  <Tab title="MCP servers">
    **時期：** セッション開始。

    **読み込まれるもの：** 接続されたサーバーからのすべてのツール定義と JSON スキーマ。

    **コンテキストコスト：** [Tool search](/ja/mcp#scale-with-mcp-tool-search)（デフォルトで有効）は MCP ツールをコンテキストの最大 10% まで読み込み、残りは必要になるまで遅延します。

    **信頼性に関する注記：** MCP 接続はセッション中に静かに失敗する可能性があります。サーバーが切断されると、そのツールは警告なく消えます。Claude は以前アクセスできた MCP ツールを使用しようとする可能性があります。Claude が以前アクセスできた MCP ツールを使用できなくなったことに気付いた場合は、`/mcp` で接続を確認してください。

    <Tip>`/mcp` を実行してサーバーごとのトークンコストを確認します。積極的に使用していないサーバーを切断します。</Tip>
  </Tab>

  <Tab title="Subagents">
    **時期：** オンデマンド、タスク用に you または Claude がスポーンするとき。

    **読み込まれるもの：** 以下を含む新しい分離されたコンテキスト：

    * システムプロンプト（キャッシュ効率のため親と共有）
    * エージェントの `skills:` フィールドにリストされている skill の完全なコンテンツ
    * CLAUDE.md と git ステータス（親から継承）
    * リードエージェントがプロンプトで渡すコンテキスト

    **コンテキストコスト：** メインセッションから分離。Subagent は会話履歴または呼び出された skill を継承しません。

    <Tip>完全な会話コンテキストが必要ない作業に subagent を使用します。それらの分離はメインセッションの膨張を防ぎます。</Tip>
  </Tab>

  <Tab title="Hooks">
    **時期：** トリガー時。Hook はツール実行、セッション境界、プロンプト送信、権限リクエスト、コンパクション などの特定のライフサイクルイベントで発火します。完全なリストは [Hooks](/ja/hooks) を参照してください。

    **読み込まれるもの：** デフォルトではなし。Hook は外部スクリプトとして実行されます。

    **コンテキストコスト：** ゼロ、hook が会話にメッセージとして追加されるコンテキストを返さない限り。

    <Tip>Hook は Claude のコンテキストに影響を与える必要がない副作用（リント、ログ）に最適です。</Tip>
  </Tab>
</Tabs>

## さらに詳しく

各機能には、セットアップ指示、例、設定オプションを含む独自のガイドがあります。

<CardGroup cols={2}>
  <Card title="CLAUDE.md" icon="file-lines" href="/ja/memory">
    プロジェクトコンテキスト、規約、指示を保存
  </Card>

  <Card title="Skills" icon="brain" href="/ja/skills">
    Claude にドメイン専門知識と再利用可能なワークフローを提供
  </Card>

  <Card title="Subagents" icon="users" href="/ja/sub-agents">
    分離されたコンテキストに作業をオフロード
  </Card>

  <Card title="Agent teams" icon="network" href="/ja/agent-teams">
    複数のセッションを並列で調整
  </Card>

  <Card title="MCP" icon="plug" href="/ja/mcp">
    Claude を外部サービスに接続
  </Card>

  <Card title="Hooks" icon="bolt" href="/ja/hooks-guide">
    Hook でワークフローを自動化
  </Card>

  <Card title="Plugins" icon="puzzle-piece" href="/ja/plugins">
    機能セットをバンドルして共有
  </Card>

  <Card title="Marketplaces" icon="store" href="/ja/plugin-marketplaces">
    Plugin コレクションをホストして配布
  </Card>
</CardGroup>
