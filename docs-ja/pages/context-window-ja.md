> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# コンテキストウィンドウを探索する

> Claude Code のコンテキストウィンドウがセッション中にどのように満たされるかのインタラクティブなシミュレーション。自動的に読み込まれるもの、各ファイル読み込みのコスト、ルールとフックが発火するタイミングを確認できます。

Claude Code のコンテキストウィンドウには、セッションについて Claude が知っているすべてのものが含まれます。つまり、あなたの指示、読み込まれたファイル、Claude 自身の応答、およびターミナルに表示されないコンテンツです。以下のタイムラインは、スタートアップからコンパクションまでの完全なセッションを再生します。何が読み込まれ、各ファイル読み込み、ルール、フックが Claude の作業中に追加するもの、そしてサブエージェントが大きな読み込みをコンテキストから外す方法を確認できます。[書かれた説明](#what-the-timeline-shows)で同じコンテンツをリストとして確認できます。

## タイムラインが示すもの

セッションは、代表的なトークン数を含む現実的なフローを通じて進みます。

* **何も入力する前に**: CLAUDE.md、自動メモリ、MCP ツール名、スキルの説明がすべてコンテキストに読み込まれます。CLAUDE.md の代わりに [AGENTS.md ファイル](https://code.claude.com/docs/ja/memory.md#agents-md)が読み込まれる場合もあります。ユーザー自身のセットアップによっては、[出力スタイル](https://code.claude.com/docs/ja/output-styles.md)や [`--append-system-prompt`](https://code.claude.com/docs/ja/cli-reference) からのテキストなど、ここにさらに多くのものが追加される可能性があります。
* **Claude が作業するとき**: 各ファイル読み込みがコンテキストに追加され、[パススコープ付きルール](https://code.claude.com/docs/ja/memory.md#path-specific-rules)は一致するファイルと一緒に自動的に読み込まれ、[PostToolUse フック](https://code.claude.com/docs/ja/hooks-guide.md)は各編集後に発火します。
* **フォローアップ プロンプト**: [サブエージェント](https://code.claude.com/docs/ja/sub-agents.md)は独自の別のコンテキストウィンドウで研究を処理するため、大きなファイル読み込みはあなたのコンテキストウィンドウから外れます。サマリーと小さなメタデータトレーラーだけが戻ってきます。
* **最後に**: `/compact` は会話を構造化されたサマリーに置き換えます。ほとんどのスタートアップコンテンツは自動的に再度読み込まれます。以下の表は、各メカニズムに何が起こるかを示しています。

## コンテキスト圧縮後に残るもの

長いセッションでコンテキスト圧縮が行われると、Claude Code は会話履歴をコンテキストウィンドウに収まるようにまとめます。v2.1.198 以降、要約リクエストはセッションの[拡張思考](https://code.claude.com/docs/ja/model-config.md#extended-thinking)設定を継承するため、セッションで有効になっている場合は思考を有効にして推論し、そうでない場合はオフのままになります。思考は要約の生成方法にのみ影響します。セッション設定はその後変更されません。各種コンテンツに何が起こるかは、それらがどのように読み込まれたかによって異なります。

| メカニズム | 圧縮後 |
| :- | :- |
| システムプロンプトと出力スタイル | 両方とも引き続き適用されます |
| プロジェクトルート CLAUDE.md とスコープなしルール | ディスクから再度注入されます |
| 自動メモリ | ディスクから再度注入されます |
| スキルの説明 | 現在の[スキル](https://code.claude.com/docs/ja/skills.md)から再構築され、再度注入されます。Claude Code v2.1.304 以降が必要です |
| [Git ステータススナップショット](https://code.claude.com/docs/ja/settings-reference.md#includegitinstructions) | セッション開始時にスナップショットがあった場合、Claude Code はリポジトリから新しいものを読み込みます |
| [plan モード](https://code.claude.com/docs/ja/permission-modes.md#analyze-before-you-edit-with-plan-mode)で Claude が作成したプラン | ディスクから再度注入されます |
| `paths:` フロントマターを持つルール | Claude Code が[必要に応じて](https://code.claude.com/docs/ja/memory.md#path-specific-rules)再度読み込みます |
| サブディレクトリ内のネストされた CLAUDE.md | Claude Code が[必要に応じて](https://code.claude.com/docs/ja/memory.md#how-claude-md-files-load)再度読み込みます |
| Claude が読み込んだまたは編集したファイル | Claude Code は最大 5 つを再度読み込みます。最近変更されたものが最初です |
| 呼び出されたスキル本体 | 再度注入されます。スキルあたり 5,000 トークン、合計 25,000 トークンでキャップされます。最も古いものが最初にドロップされます |
| [バックグラウンドコマンド](https://code.claude.com/docs/ja/interactive-mode.md#background-bash-commands)とバックグラウンド[サブエージェント](https://code.claude.com/docs/ja/sub-agents.md#run-subagents-in-foreground-or-background) | 実行を続けます。Claude Code は Claude に対して、どのコマンドがまだ実行中であるかを通知し、重複を開始しないようにします |
| フックが以前に追加したコンテキスト | 会話の残りの部分と一緒にまとめられます |
| `compact` ソースと一致する [SessionStart フック](https://code.claude.com/docs/ja/hooks-guide.md#re-inject-context-after-compaction) | Claude Code がそれらを実行し、その出力を圧縮されたコンテキストに追加します |

圧縮直後に、Claude Code はセッション内で Claude が読み込んだまたは編集したファイルのうち最大 5 つを再度読み込みます。最近変更されたものを選択します。5,000 トークンを超えるファイルはパス参照として戻ります。その内容なしで、`Read` ではなく `Referenced file` として表示されます。

パススコープ付きルールとネストされた CLAUDE.md ファイルは、Claude がそのトリガーファイルを読み込む、書き込む、または編集するときにメッセージ履歴に読み込まれるため、圧縮によって他のすべてのものと一緒にまとめられて消えます。ルールを圧縮後も保持する必要がある場合は、`paths:` フロントマターを削除するか、プロジェクトルート CLAUDE.md に移動してください。

スキル本体は圧縮後に再度注入されますが、大きなスキルはスキルあたりのキャップに収まるようにトリミングされ、合計予算を超えると最も古い呼び出されたスキルがドロップされます。トリミングはファイルの開始を保持するため、`SKILL.md` の上部に最も重要な指示を配置してください。

## コンテキストがいっぱいになったとき

Claude Code は上限に近づくと自動的にコンテキスト圧縮を行うため、コンテキストウィンドウがいっぱいになってもセッションが終了することはありません。自動圧縮は、タイムラインの `/compact` ステップと同じように動作します。何が保持されるかについては、[コンテキストがいっぱいになったとき](https://code.claude.com/docs/ja/how-claude-code-works.md#when-context-fills-up)を参照してください。放置された会話を Claude Code が圧縮する場合については、[アイドル時の圧縮](https://code.claude.com/docs/ja/settings-reference.md#idlecompaction)を参照してください。

自動圧縮が実行される前に、自分で対処することもできます。

* **焦点を指定して圧縮する**: 長い新しいタスクを始める前に、`/compact focus on the auth bug fix` のように指示を付けて `/compact` を実行します。要約には、自動圧縮が重要だと推測する内容ではなく、ユーザーが選んだ内容が残ります。
* **会話の一部を圧縮する**: `/rewind` を実行してメッセージを選択し、**Summarize from here** または **Summarize up to here** を選びます。各オプションで何が保持されるか、また要約をどのように誘導するかについては、[巻き戻しと要約](https://code.claude.com/docs/ja/checkpointing.md#rewind-and-summarize)を参照してください。
* **早めに圧縮する**: `/autocompact 500k` のようにトークン数を指定して [`/autocompact`](https://code.claude.com/docs/ja/commands#all-commands) を実行し、自動圧縮が実行されるまでにコンテキストウィンドウがどれだけ埋まるかを設定します。指定できる値と上書きについては、[自動圧縮のウィンドウを設定する](https://code.claude.com/docs/ja/model-config.md#set-the-auto-compact-window)を参照してください。
* **タスクの合間にクリアする**: 関係のない作業に切り替えるときは `/clear` を実行します。古い会話は次に必要なファイルを押し出し、メッセージごとにトークンを消費します。
* **大量の読み込みを委任する**: 調査を[サブエージェント](https://code.claude.com/docs/ja/sub-agents.md)に任せると、ファイルの内容はユーザーのコンテキストウィンドウではなく、サブエージェントのコンテキストウィンドウにとどまります。

会話を小さくするのではなく、より大きなウィンドウが必要な場合は、Fable モデル、Sonnet 5 以降、Haiku 5.5、Opus 4.6 以降、Sonnet 4.6 が 100 万トークンのコンテキストウィンドウに対応しています。プランごとの利用可否と `[1m]` モデルバリアントの選択方法については、[拡張コンテキスト](https://code.claude.com/docs/ja/model-config.md#extended-context)を参照してください。上限が大きくなっても、圧縮は同じように動作します。

自動圧縮が実行されるタイミングは、モデルと設定によって異なります。モデルごとの境界については[デフォルトの自動圧縮のしきい値](https://code.claude.com/docs/ja/model-config.md#default-auto-compact-thresholds)を参照してください。また、[LLM ゲートウェイ](https://code.claude.com/docs/ja/llm-gateway)のエイリアスなど、Claude Code がモデル ID に対して誤ったウィンドウを想定している場合は、[ゲートウェイまたはカスタムモデル ID のウィンドウを修正する](https://code.claude.com/docs/ja/model-config.md#correct-the-window-for-a-gateway-or-custom-model-id)を参照してください。

## あなた自身のセッションを確認する

ビジュアライゼーションは代表的な数値を使用しています。任意の時点でのあなたの実際のコンテキスト使用状況を確認するには、`/context` を実行して、カテゴリ別の詳細な内訳と最適化の提案を取得してください。これには、どの CLAUDE.md と自動メモリファイルが読み込まれたかが含まれます。`/memory` を実行して、これらのファイルを開いて編集してください。

## 関連リソース

タイムラインに示されている機能の詳細なカバレッジについては、これらのページを参照してください。

* [Claude Code を拡張する](https://code.claude.com/docs/ja/features-overview.md): CLAUDE.md とスキルとルールとフックと MCP をいつ使用するか
* [指示とメモリを保存する](https://code.claude.com/docs/ja/memory.md): CLAUDE.md 階層と自動メモリ
* [サブエージェント](https://code.claude.com/docs/ja/sub-agents.md): 研究を別のコンテキストウィンドウに委譲する
* [ベストプラクティス](https://code.claude.com/docs/ja/best-practices.md#keep-cost-and-context-down): セッションを焦点を絞ったものに保ち、コストを抑える
* [プロンプト キャッシング](https://code.claude.com/docs/ja/prompt-caching.md): キャッシュされたプレフィックスを無効にするアクション
* [トークン使用量を削減する](https://code.claude.com/docs/ja/costs.md#reduce-token-usage): コンテキスト使用量を低く保つための戦略
