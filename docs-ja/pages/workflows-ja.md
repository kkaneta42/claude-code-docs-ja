> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# 動的ワークフローで大規模にサブエージェントをオーケストレーションする

> 動的ワークフローは、Claude が作成したスクリプトから多くのサブエージェントをオーケストレーションし、再実行できます。コードベース監査、大規模マイグレーション、相互検証研究に使用します。

<Note>
  動的ワークフローはすべての有料プランで利用可能で、Anthropic API アクセス、Amazon Bedrock、Google Cloud の Agent Platform、Microsoft Foundry で利用できます。Pro では、`/config` の Dynamic workflows 行からオンにしてください。
</Note>

動的ワークフローは、[サブエージェント](/docs/ja/sub-agents)を大規模にオーケストレーションする JavaScript スクリプトです。Claude は説明したタスク用のスクリプトを作成し、ランタイムはバックグラウンドで実行しながら、セッションは応答性を保ちます。

1 つの会話が調整できるより多くのエージェントが必要なタスク、またはオーケストレーションを読み直して再実行できるスクリプトとしてコード化したい場合にワークフローを使用します。例としては、コードベース全体のバグスイープ、500 ファイルのマイグレーション、複数のソースに対して相互検証が必要な研究質問、1 つにコミットする前に複数の独立した角度から下書きする価値のある難しい計画があります。

<h2 id="when-to-use-a-workflow">
  ワークフローを使用するタイミング
</h2>

[サブエージェント](/docs/ja/sub-agents)、[スキル](/docs/ja/skills)、[エージェントチーム](/docs/ja/agent-teams)、およびワークフローはすべてマルチステップタスクを実行できます。違いは、計画を保持する者です。

|                  | サブエージェント            | スキル                 | エージェントチーム             | ワークフロー             |
| :--------------- | :------------------ | :------------------ | :-------------------- | :----------------- |
| それは何か            | Claude が生成するワーカー    | Claude が従う指示        | ピアセッションを監督するリードエージェント | ランタイムが実行するスクリプト    |
| 次に何が実行されるかを決定する者 | Claude、ターンごと        | Claude、プロンプトに従う     | リードエージェント、ターンごと       | スクリプト              |
| 中間結果が存在する場所      | Claude のコンテキストウィンドウ | Claude のコンテキストウィンドウ | 共有タスクリスト              | スクリプト変数            |
| 繰り返し可能なもの        | ワーカー定義              | 指示                  | チーム定義                 | オーケストレーション自体       |
| スケール             | ターンごとに委任されたいくつかのタスク | サブエージェントと同じ         | 長時間実行される少数のピア         | 実行ごとに数十から数百のエージェント |
| 中断               | ターンを再開始             | ターンを再開始             | チームメイトは実行を続ける         | 同じセッション内で再開可能      |

ワークフローは計画をコードに移動します。サブエージェント、スキル、およびエージェントチームでは、Claude がオーケストレーターです。ターンごとに次に何を生成または割り当てるかを決定し、すべての結果は Claude のコンテキストウィンドウに入ります。ワークフロースクリプトはループ、分岐、および中間結果自体を保持するため、Claude のコンテキストは最終的な答えのみを保持します。

計画をコードに移動することで、ワークフローは単に複数のエージェントを実行するだけでなく、繰り返し可能な品質パターンを適用することもできます。独立したエージェントが相互に対立的にレビューしてから報告されるようにすることも、複数の角度から計画を下書きして相互に比較することもできるため、単一パスより信頼性の高い結果が得られます。

<h2 id="run-a-bundled-workflow">
  バンドルされたワークフローを実行する
</h2>

最速の方法でワークフローの動作を確認するには、Claude Code に含まれている組み込みワークフロー `/deep-research` を実行します。これは[バンドルされたワークフロー](#bundled-workflows)で、多くのソースにわたって質問を調査するためのものです。セッションが無料のままで、ターンバイターンのトランスクリプトの代わりに 1 つのレポートを取得しながら、エージェントがバックグラウンドで一連のフェーズを処理するのを見ることができます。

<Steps>
  <Step title="ワークフローを実行する">
    調査したい質問で `/deep-research` を実行します。複数の角度にわたって Web 検索をファンアウトし、見つけたソースをフェッチして相互検証し、引用されたレポートを合成します。

    ```text wrap theme={null}
    /deep-research What changed in the Node.js permission model between v20 and v22?
    ```
  </Step>

  <Step title="ワークフローを許可する">
    Claude Code はワークフローを許可するかどうかを尋ねます。**Yes** を選択して続行します。正確なプロンプトは権限モードによって異なります。[実行前に計画を承認する](#approve-the-plan-before-it-runs)でモードごとのオプションを参照してください。
  </Step>

  <Step title="進捗を監視する">
    実行がバックグラウンドで開始されます。`/workflows` を実行し、矢印キーを使用して実行を選択し、Enter キーを押して進捗ビューを開きます。

    ```text wrap theme={null}
    /workflows
    ```

    ビューは各フェーズをエージェント数、トークン合計、経過時間とともに表示します。任意のフェーズにドリルダウンして、そのエージェントと各エージェントが見つけたものを確認します。[実行を監視する](#watch-the-run)で完全なコントロールセットを参照してください。

    入力ボックスの下のタスクパネルからも監視できます。実行中は 1 行の進捗サマリーが表示されます。下矢印を押してフォーカスし、Enter キーを押して展開します。
  </Step>

  <Step title="レポートを読む">
    実行が完了すると、レポートがセッションに表示されます。各クレームが由来するソースを引用し、相互検証を生き残らなかったクレームは既にフィルタリングされています。

    検証エージェントがレート制限や API エラーの後など、クレームを確認できない場合、レポートはそのクレームを未検証として列挙し、反論されたものとしてカウントしません。
  </Step>
</Steps>

独自のタスク用にワークフローを実行するには、[Claude にワークフローを作成させ](#have-claude-write-a-workflow)、実行が必要なことを実行したら、[保存して](#save-the-workflow-for-reuse)独自のコマンドとして使用できます。

<h3 id="bundled-workflows">
  バンドルされたワークフロー
</h3>

Claude Code には、組み込みワークフローとして `/deep-research` が含まれています。

| コマンド                        | 実行内容                                                                                                                                                                                 |
| :-------------------------- | :----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `/deep-research <question>` | 複数の角度にわたって質問に対する Web 検索をファンアウトし、見つけたソースをフェッチして相互検証し、各クレームに投票し、相互検証を生き残らなかったクレームがフィルタリングされた引用されたレポートを返します。[WebSearch ツール](/docs/ja/tools-reference#websearch-tool-behavior)が利用可能である必要があります |

`/deep-research` は呼び出すときのみ実行されます。

[自分で保存](#save-the-workflow-for-reuse)したワークフローは同じ方法でコマンドになり、バンドルされたものと一緒に `/` オートコンプリートに表示されます。

<h3 id="watch-the-run">
  実行を監視する
</h3>

ワークフローはバックグラウンドで実行されるため、エージェントが作業している間、セッションは応答性を保ちます。任意の時点で `/workflows` を実行して、実行中および完了したワークフローをリストアップし、1 つを選択して進捗ビューを開きます。

進捗ビューは各フェーズをエージェント数、トークン合計、経過時間とともに表示します。フッターは各アクションのキーをリストアップします。

| キー              | アクション                                                                                    |
| :-------------- | :--------------------------------------------------------------------------------------- |
| `↑` / `↓`       | フェーズまたはエージェントを選択                                                                         |
| `Enter` または `→` | 選択したフェーズにドリルダウンし、次にエージェントにドリルダウンしてプロンプト、最近のツール呼び出し、結果を読む                                 |
| `Esc` または `←`   | 1 レベル戻る。v2.1.203 から v2.1.205 では、`←` はフェーズまたはエージェントから戻りませんでした。これらのバージョンでは `Esc` を使用してください |
| `j` / `k`       | オーバーフローするときにエージェント詳細内でスクロール                                                              |
| `f`             | 選択したフェーズのエージェントリストをステータスでフィルタリングします。もう一度押すとサイクルします                                       |
| `p`             | 実行を一時停止または再開                                                                             |
| `x`             | 選択したエージェントを停止するか、フォーカスが実行にあるときにワークフロー全体を停止                                               |
| `r`             | 選択した実行中のエージェントを再開始                                                                       |
| `s`             | 実行のスクリプトを[保存](#save-the-workflow-for-reuse)してコマンドとして保存                                   |

<h2 id="have-claude-write-a-workflow">
  Claude にワークフローを作成させる
</h2>

Claude にワークフローを作成させるには 2 つの方法があります。

* [プロンプトでワークフローを要求](#ask-for-a-workflow-in-your-prompt)し、キーワード `ultracode` を含めるか、自分の言葉で要求して、Claude がタスク用のワークフローを作成します。
* [ultracode で Claude に決定させる](#let-claude-decide-with-ultracode)。`/effort ultracode` を設定し、Claude はセッション内のすべての実質的なタスク用にワークフローを計画します。

既に存在するワークフローコマンドを実行することもできます。[バンドルされたワークフロー](#bundled-workflows)（`/deep-research` など）、または[保存](#save-the-workflow-for-reuse)したワークフロー。

<h3 id="ask-for-a-workflow-in-your-prompt">
  プロンプトでワークフローを要求する
</h3>

セッションの努力レベルを変更せずに単一のタスクをワークフローとして実行するには、プロンプトにキーワード `ultracode` を含めます。「ワークフローを使用する」または「ワークフローを実行する」など、自分の言葉で要求することもできます。Claude は直接的な要求を同じオプトインとして扱います。

```text wrap theme={null}
ultracode: audit every API endpoint under src/routes/ for missing auth checks
```

Claude Code はキーワードをプロンプトでハイライトし、Claude はターンバイターンで処理する代わりにタスク用のワークフロースクリプトを作成します。キーワードは Claude の作業の構造化方法のみを選択します。エージェントのツール呼び出しは、セッション内の他のツール呼び出しと同じ権限チェックと[サンドボックス化](/docs/ja/sandboxing)を受け取ります。

実行が必要なことを実行した場合、その後[コマンドとして保存](#save-the-workflow-for-reuse)できます。別の方法で構築されたオーケストレーター（サブエージェントプロンプトのフォルダーや、作業をファンアウトするスキルなど）が既にある場合は、Claude にそれを指し示し、同じことを行うワークフローを要求できます。

<h4 id="dismiss-or-turn-off-the-keyword">
  キーワードを無視するか、オフにする
</h4>

意図しない場合は、macOS で `Option+W` または Windows と Linux で `Alt+W` を押してこのプロンプトのハイライトを無視するか、ハイライトされたキーワードの直後にカーソルがある状態でバックスペースを押します。キーワードがまったくトリガーされないようにするには、`/config` で Ultracode キーワードトリガーをオフにします。

<h4 id="where-the-keyword-works">
  キーワードが機能する場所
</h4>

キーワードはオプトインのみで、自分で入力するプロンプトです。対話的なプロンプト、IDE 拡張機能パネル、[Remote Control](/docs/ja/remote-control) クライアント、または[`origin`](/docs/ja/agent-sdk/typescript#sdkmessageorigin) を `{ kind: "human" }` としてスタンプするエージェント SDK アプリケーション。セッションに別の方法で到達した場合、ワークフローを開始しません。

* `-p` で渡されたプロンプト
* エージェント SDK アプリケーションが人間入力としてスタンプせずに送信するプロンプト
* スケジュール済みタスクプロンプト
* ウェブフック ペイロードまたはプルリクエストコメントが会話にリレーされた

<Note>
  v2.1.210 より前は、キーワードはこれらのルートのいずれからでもワークフローを開始しました。ウェブフック ペイロードまたはプルリクエストコメントが会話にリレーされた場合も含みます。
</Note>

<h3 id="let-claude-decide-with-ultracode">
  ultracode で Claude に決定させる
</h3>

Ultracode は、`xhigh` [推論努力](/docs/ja/model-config#adjust-effort-level)と自動ワークフローオーケストレーションを組み合わせた Claude Code 設定です。オンにすると、Claude は各実質的なタスク用にワークフローを計画し、あなたが要求するのを待ちません。

```text wrap theme={null}
/effort ultracode
```

ultracode がオンの状態でセッションを開始するには、`claude --effort ultracode` で起動します。Claude Code v2.1.203 以降が必要です。

ultracode をオンにしながらモデルを選択するには、矢印キーで `/model` ピッカーの努力スライダーを `ultracode` に移動します。[努力レベルを調整する](/docs/ja/model-config#adjust-effort-level)は ultracode をオンにするルートをリストします。

ultracode がオンの場合、Claude はタスクがワークフローを必要とするかどうかを決定します。単一のリクエストは複数のワークフローに変わる可能性があります。コードを理解するためのワークフロー、変更を加えるためのワークフロー、検証するためのワークフロー。これはセッション内のすべてのタスクに適用されるため、各リクエストはより多くのトークンを使用し、より低い努力レベルより長くかかります。

`/effort ultracode` は現在のセッション用に続きます。すべてのセッションをそれで開始するには、[`ultracode`](/docs/ja/settings-reference#ultracode) 設定を設定します。ルーチンワークに戻るときは `/effort high` でドロップバックします。`xhigh` [努力](/docs/ja/model-config#adjust-effort-level)をサポートするモデルで利用可能です。他のモデルでは、`/effort` メニューはそれを提供しません。

<h3 id="approve-the-plan-before-it-runs">
  実行前に計画を承認する
</h3>

CLI では、実行ごとのプロンプトは計画されたフェーズとこれらのオプションを表示します。

* **Yes, run it**: 実行を開始
* **Yes, and don't ask again for `<name>` in `<path>`**: 開始し、このプロジェクトからこのワークフロー用にこのプロンプトをスキップします。Claude Code は、バンドルされた、保存された、またはプラグインワークフローを名前で実行する場合にこのオプションを提供します。現在のタスク用に Claude が作成したスクリプトではありません。
* **View raw script**: 決定する前にスクリプトを読む
* **No**: キャンセル

`Ctrl+G` はエディターでスクリプトを開きます。`Tab` を使用すると、実行開始前にプロンプトを調整できます。

このプロンプトを表示するかどうかは、[権限モード](/docs/ja/permission-modes)によって異なります。

| 権限モード                 | プロンプトが表示される場合                                                                      |
| :-------------------- | :--------------------------------------------------------------------------------- |
| 自動                    | 最初の起動のみ。任意の **Yes** はユーザー設定に同意を記録し、後の起動はプロンプトなしで開始します。ultracode がオンの場合は完全にスキップされます |
| 手動、編集を受け入れ            | すべての実行、そのワークフロー用に**Yes, and don't ask again** を選択していない限り                           |
| 権限をバイパス               | Claude Code はプロンプトを表示しません。実行は直ちに開始                                                 |
| `claude -p`、Agent SDK | Claude Code はプロンプトを表示しません                                                          |

`claude -p` と Agent SDK では、Claude Code はこのプロンプトを表示しません。ワークフロー ツール呼び出しをセッションの残りの部分と同じ[権限評価](/docs/ja/agent-sdk/permissions#how-permissions-are-evaluated)を通じて実行するため、拒否ルール、質問ルール、および `dontAsk` モードはすべてのツール呼び出しに適用されるようにワークフロー起動に適用されます。これらの実行でワークフローを開始させるには、次のいずれかを使用します。

* **権限ルール**: 許可ルール内の `Workflow` はすべてのワークフローを承認し、`Workflow(<name>)` は保存されたワークフローを名前で承認します。
* **自動権限モード**: [分類器](/docs/ja/permission-modes#eliminate-prompts-with-auto-mode)は呼び出しを確認し、それを承認できます。
* **権限をバイパスモード**: Claude Code は呼び出しを承認します。
* **`PreToolUse` フック**: 呼び出しに対して `allow` を返す[フック](/docs/ja/hooks#pretooluse)はそれを承認します。
* **ホスト**: [`--permission-prompt-tool`](/docs/ja/cli-reference#cli-flags)はそれを承認するか、Agent SDK を使用して、[`canUseTool`](/docs/ja/agent-sdk/permissions)コールバックまたは[`PermissionRequest` フック](/docs/ja/hooks#permissionrequest)はそれを承認します。

Desktop アプリでは、承認カードはワークフロー名、フェーズリスト、トークン使用量の注意を表示し、**Once**、**Always**、**Deny** アクションがあります。進捗ビューは Background tasks サイドペインに表示されます。

ワークフローが生成するサブエージェントは[権限ルール](/docs/ja/settings-reference#permission-settings)を使用し、Claude Code は[サブエージェントが実行される権限モード](/docs/ja/sub-agents#permission-modes)の下のルールによってサブエージェントの権限モードを選択します。長い実行でプロンプトを回避するには、開始前にエージェントが必要とするツールを許可ルールに追加します。

<h3 id="save-the-workflow-for-reuse">
  再利用用にワークフローを保存する
</h3>

Claude が繰り返すタスク用にワークフローを作成した場合、その実行のスクリプトをコマンドとして保存できます。すべてのブランチで実行するレビューなどのプロセスは、毎回同じオーケストレーションを実行します。

`/workflows` を実行し、保持したい実行を選択し、`s` を押します。保存ダイアログで、Tab は 2 つの保存場所を切り替えます。

* `.claude/workflows/` プロジェクト内。リポジトリをクローンする全員と共有
* `~/.claude/workflows/` ホームディレクトリ内。すべてのプロジェクトで利用可能、自分にのみ表示。[`CLAUDE_CONFIG_DIR`](/docs/ja/env-vars) を設定した場合、この場所はそのパスの下の `workflows/` ディレクトリです。

保存ダイアログは個人用の場所の解決されたパスを表示します。

Enter キーを押して保存します。ワークフローは、どちらかの場所から今後のセッションで `/<name>` として実行されます。

Claude Code は書き込み前に保存場所をシンボリックリンクでチェックし、エラーを表示する代わりに 1 つを通じて書き込みます。チェックする内容は保存場所によって異なります。

* プロジェクト場所: `.claude`、`.claude/workflows`、またはターゲットファイルがシンボリックリンクの場合、Claude Code は拒否します。
* 個人場所: ターゲットファイル自体がシンボリックリンクの場合のみ Claude Code は拒否するため、ドットファイルツールで管理される `~/.claude` ディレクトリは引き続き機能します。

v2.1.216 より前は、Claude Code はリンクをたどり、ファイルを選択した場所の外に配置する可能性がありました。

複数の `.claude/` ディレクトリを持つモノレポでは、ワークフローをそれが適用されるパッケージの横に保持できます。v2.1.178 以降、プロジェクトの場所に保存すると、作業ディレクトリとリポジトリルートの間に既に存在する最も近い `.claude/workflows/` ディレクトリに書き込まれるか、まだ存在しない場合はリポジトリルートに書き込まれます。プロジェクトワークフローはその経路に沿ったすべての `.claude/workflows/` から読み込まれ、複数が同じ名前を定義する場合、Claude Code は作業ディレクトリに最も近いものを実行します。

プロジェクトワークフローと個人ワークフローが名前を共有する場合、プロジェクトワークフローが実行されます。

<h3 id="distribute-a-workflow-in-a-plugin">
  プラグインでワークフローを配布する
</h3>

ワークフローをチーム間またはリポジトリ間で共有するには、[プラグイン](/docs/ja/plugins)に含めます。スクリプトをプラグインルートの `workflows/` ディレクトリに配置するか、[`workflows` マニフェストフィールド](/docs/ja/plugins-reference#component-path-fields)で別の場所を指します。

プラグインワークフローはプラグイン名でネームスペース化されます。`meta.name` が `release-audit` であるスクリプトを含む `acme-tools` というプラグインは `/acme-tools:release-audit` として実行されます。

<h3 id="pass-input-to-a-saved-workflow">
  保存されたワークフローに入力を渡す
</h3>

保存されたワークフローは、`args` パラメーターを通じて入力を受け入れることができます。スクリプトはそれを `args` という名前のグローバルとして読み取ります。これを使用して、スクリプトを実行するたびに編集する代わりに、呼び出し時に研究質問、ターゲットパスのリスト、または設定オブジェクトを提供します。

次のプロンプトは、問題番号のリストを使用して保存されたワークフローを実行します。

```text wrap theme={null}
Run /triage-issues on issues 1024, 1025, and 1030
```

Claude はリストを構造化データとして渡すため、スクリプトは最初に解析することなく、`args` に対して配列とオブジェクトメソッドを直接呼び出すことができます。`args` が省略された場合、グローバルはスクリプト内で `undefined` です。

<h2 id="example-workflow-prompts">
  ワークフローの実行例プロンプト
</h2>

ワークフローは、タスクが 1 つのエージェントがコンテキストに保持できるより大きい場合、または同じステップが多くのアイテムにわたって実行する必要がある場合に最適です。以下のプロンプトは一般的な形を示しています。それぞれは Claude にそのタスク用のワークフローを作成して実行するよう依頼します。スクリプト自体は作成しません。

<h3 id="audit-many-files-for-the-same-issue">
  同じ問題について多くのファイルを監査する
</h3>

1 つのエージェントをファイルごとにファンアウトし、その後、検出結果を収集して検証します。

```text wrap theme={null}
use a workflow to audit every route handler under src/routes/ for missing authentication checks, and adversarially verify each finding before reporting it
```

<h3 id="keep-fixing-until-a-check-passes">
  チェックが合格するまで修正を続ける
</h3>

チェッカーを実行し、失敗したものを修正し、合格するか進捗が止まるまで繰り返します。

```text wrap theme={null}
use a workflow to run npx tsc --noEmit and keep fixing the reported errors until the type check passes or two rounds in a row make no progress
```

<h3 id="migrate-many-files-in-parallel">
  多くのファイルを並列でマイグレーションする
</h3>

マイグレーションするファイルを検出し、編集が競合しないように各ファイルを分離されたコピーで変換し、各結果を検証します。

```text wrap theme={null}
use a workflow to migrate every component under src/components/ from JavaScript to TypeScript, working on each file in its own isolated copy
```

<h3 id="review-every-changed-file-and-write-one-summary">
  すべての変更されたファイルをレビューして 1 つのサマリーを作成する
</h3>

ファイルごとにレビュアーを実行し、その後、すべての検出結果を 1 つのエージェントに渡して、それらをランク付けして重複排除します。

```text wrap theme={null}
use a workflow to review every file changed in this PR for correctness issues, then merge the per-file findings into one ranked summary
```

<h3 id="research-a-topic-across-many-sources">
  多くのソースにわたってトピックを研究する
</h3>

チェンジログ、問題、ドキュメント全体でリーダーをファンアウトし、その後、合成します。バンドルされた `/deep-research` ワークフローはこれを実行します。より狭いバージョンを説明することもできます。

```text wrap theme={null}
use a workflow to research how our three competitors handle rate limiting: read their public docs and recent changelog entries in parallel, then compare the approaches
```

<h3 id="find-issues-until-the-list-stops-growing">
  リストが成長を停止するまで問題を見つける
</h3>

ラウンドで検索を続け、新しいラウンドが新しいものを見つけなくなったら停止します。

```text wrap theme={null}
use a workflow to find flaky tests in this repo: run the suite repeatedly, record which tests fail intermittently, and stop once two rounds in a row find nothing new
```

<h3 id="what-the-saved-script-looks-like">
  保存されたスクリプトの外観
</h3>

[ワークフローを保存](#save-the-workflow-for-reuse)すると、`.claude/workflows/` のファイルは `meta` ブロックの後にサブエージェントをオーケストレーションするスクリプト本体を保持します。通常は編集する必要はありませんが、ここは小さいものの形なので、Claude が生成したものを認識できます。

```javascript theme={null}
export const meta = {
  name: 'audit-routes',
  description: 'Audit every route handler for missing auth checks',
}

const found = await agent('List every .ts file under src/routes/.', {
  schema: { type: 'object', required: ['files'], properties: { files: { type: 'array', items: { type: 'string' } } } },
})

const audits = await pipeline(found.files, file =>
  agent(`Audit ${file} for missing authentication checks.`, { label: file }),
)

return audits.filter(Boolean)
```

本体は最上位の `await` を持つプレーン JavaScript です。`agent()` は 1 つのサブエージェントを生成し、`pipeline()` はリスト内の 1 つのアイテムごとに 1 つを実行し、`parallel()` は一連のエージェント タスクを同時に実行してすべてが完了するのを待ちます。

`agent()` 呼び出しは、実行中に停止した場合または回復不可能な API エラーが発生した場合は `null` に解決されます。`pipeline()` はその `null` を結果配列に保持するため、例は `.filter(Boolean)` で終わってそれらのエントリを削除します。

`agent()` 呼び出しで `schema` を渡す場合、そのサブエージェントはプローズの代わりに形状に一致する JSON を返します。Claude Code はサブエージェントを開始する前にスキーマをチェックします。スキーマが矛盾していることを証明できる場合、呼び出しは矛盾を名前付けするエラーで失敗し、サブエージェントは開始されません。証明できる 1 つの矛盾は、`additionalProperties: false` が除外する `required` キーです。

サブエージェントの出力が 5 回の試行後も検証に失敗する場合、呼び出しは最後の検証失敗を含むエラーで失敗します。試行回数を変更するには、[`MAX_STRUCTURED_OUTPUT_RETRIES`](/docs/ja/env-vars) を設定します。

<h3 id="edit-a-saved-script">
  保存されたスクリプトを編集する
</h3>

[保存したワークフロー](#save-the-workflow-for-reuse)を変更するには、その `.js` ファイルを編集するか、Claude に変更を依頼します。編集または依頼する前に、`/workflow-authoring` [バンドルされたスキル](/docs/ja/skills#bundled-skills)を実行して、Claude が作業する対象のスクリプト作成リファレンスを読み込みます。スキルには Claude Code v2.1.248 以降が必要です。

現在のセッションで編集されたバージョンを実行するには、[`/reload-skills`](/docs/ja/commands#all-commands) を実行してワークフロー ディレクトリを再度読み込み、その後 `/<name>` を再度実行します。

Claude Code はスクリプトを読み込んで実行するときに、ファイルの各部分に次のルールを適用します。

* **`meta` ブロック**: `export const meta` を最初のステートメントとして保持し、`name` と `description` を持つプレーン オブジェクト リテラルとして保持します。変数、関数呼び出し、スプレッドなどのリテラル値以外のものが含まれている場合、Claude Code は `/` オートコンプリートから `/<name>` を削除します。
* **本体**: `agent()`、`pipeline()`、`parallel()` の他に、`phase()` を呼び出して、進捗ビューのタイトルの下に続くエージェントをグループ化し、`log()` を呼び出してフェーズの上にメッセージを表示し、[`args`](#pass-input-to-a-saved-workflow) グローバルを読み取ることができます。本体に構文エラーがある場合、Claude Code はワークフローを実行するときにそれを報告します。
* **`phases`**: `meta` にそれらをリストする場合、`phase()` に渡す各エントリに正確にタイトルを付けます。エントリのない `phase()` タイトルは独自の進捗グループを取得します。
* **タイムスタンプとランダム性**: Claude Code はスクリプト内で `Date.now()`、`Math.random()`、および引数なしの `new Date()` をスローするため、[再開された実行](#resume-after-a-pause)は同じ `agent()` 呼び出しを繰り返します。代わりに `args` を通じてタイムスタンプを渡します。

保存されたコピーではなく、[単一の実行のスクリプト](#how-a-workflow-runs)を編集することもできます。[一時停止後に再開](#resume-after-a-pause)は、編集されたスクリプトを再開したときにどのエージェントが再度実行されるかについて説明します。Workflow ツールの入力については、[Agent SDK リファレンス](/docs/ja/agent-sdk/typescript#workflow)のそのエントリを参照してください。

<h2 id="how-a-workflow-runs">
  ワークフローの実行方法
</h2>

ワークフローランタイムは、会話から分離された隔離環境でスクリプトを実行します。中間結果は Claude のコンテキストに入る代わりにスクリプト変数に留まります。

すべての実行は、セッションディレクトリの `~/.claude/projects/` 配下のファイルにスクリプトを書き込みます。実行が開始されると Claude はパスを受け取るため、それを尋ねることができます。そのファイルを開いて、Claude が作成したオーケストレーションを読んだり、前回の実行のスクリプトと比較したり、編集して Claude に編集版から再起動するよう依頼したりできます。

Claude がワークフローを開始できるのは、セッションが既に読み取りを許可されているスクリプトファイルからのみです。作業ディレクトリの外に保存されているスクリプトを実行するには、まず [`/add-dir`](/docs/ja/permissions#working-directories) でそのディレクトリを追加するか、[Read 許可ルール](/docs/ja/permissions#read-and-edit)を設定してください。

ランタイムは実行が進むにつれて各エージェントの結果を追跡します。これが実行を[一時停止後に再開](#resume-after-a-pause)可能にする理由です。同じセッション内で。

<h3 id="prompt-caching-in-a-fan-out">
  ファンアウトでのプロンプトキャッシング
</h3>

同じ実行内のエージェントは、互いの[プロンプトキャッシュ](/docs/ja/prompt-caching#subagents-and-the-cache)を読み取ることができます。同じモデル、努力レベル、エージェントタイプ、ツール、出力スキーマ、および作業ディレクトリで実行される 2 つのエージェントは、同じツールおよびシステムプロンプトプレフィックスを構築するため、マッチングする兄弟の応答が開始された後に開始されるエージェントは、最初のリクエストでその兄弟のキャッシュを読み取ります。

ワークフローエージェントのリクエストはメイン会話の[キャッシュ TTL バケット](/docs/ja/prompt-caching#which-ttl-each-request-gets)の外にあるため、そのキャッシュはデフォルトで 5 分間保持されます。Claude サブスクリプションでも同様です。1 時間保持するには、[`subagentPromptCacheTtl`](/docs/ja/settings-reference#subagentpromptcachettl) を `1h` に設定してください。API は 1 時間のキャッシュ書き込みをより高いレートで課金します。

ファンアウトが複数のマッチングエージェントを一度に開始する場合、Claude Code は最初のエージェント以外をすべて保持し、最初のエージェントの応答が開始されるまで待機してから、保持されたエージェントを一緒にリリースして、最初のリクエストで共有プレフィックスを読み取り、各エージェントがキャッシュなしで処理するのを避けます。Claude Code は保持を [`CLAUDE_CODE_WORKFLOW_PREFIX_STAGGER_MS`](/docs/ja/env-vars) ミリ秒でキャップします。デフォルトは `5000` です。保持を無効にするには `0` に設定してください。

<h3 id="behavior-and-limits">
  動作と制限
</h3>

ランタイムは以下の制約を適用します。

| 制約                                                                             | 理由                                                                                                        |
| :----------------------------------------------------------------------------- | :-------------------------------------------------------------------------------------------------------- |
| 実行中のユーザー入力なし                                                                   | エージェント権限プロンプトのみが実行を一時停止できます。ステージ間の署名のために、各ステージを独自のワークフローとして実行します                                          |
| ワークフロー自体からの直接ファイルシステムまたはシェルアクセスなし                                              | エージェントは読み取り、書き込み、コマンドを実行します。スクリプトはエージェントを調整します                                                            |
| モジュール読み込みなし：`import()` を含むスクリプトは実行開始前に失敗します                                    | スクリプト本体はプレーン JavaScript です。ライブラリが必要な作業はエージェントのタスクに配置してください                                                |
| 最大 16 個の同時エージェント。CPU が限定されたコンテナ内を含め、Claude Code が利用可能な CPU が少ない場合はより少ない        | ローカルリソース使用を制限します                                                                                          |
| ファンアウトでは、最初のエージェントのプロンプトキャッシュプレフィックスを共有するエージェントはデフォルトで最初のエージェントの 5 秒後までに開始します  | すべてが最初のエージェント以外は、[最初のエージェントがキャッシュしたプレフィックス](#prompt-caching-in-a-fan-out)を読み取り、各エージェントがキャッシュなしで処理するのを避けます |
| 単一の `parallel()` または `pipeline()` 呼び出しで最大 4,096 個のアイテム：ランタイムはより長いリストをエラーで拒否します | サイレント上限はスクリプトに通知せずにワークロードの一部をドロップします                                                                      |
| 実行ごとに合計 1,000 エージェント                                                           | 暴走ループを防止します                                                                                               |

<h2 id="manage-runs">
  実行を管理する
</h2>

実行が開始されたら、`/workflows` ビューから、または入力ボックスの下のタスクパネルで進捗行を展開して管理します。

実行を停止すると、そのエージェントのプロセスがまだ実行中の間、タスクパネルに留まります。もう一度停止すると、Claude Code はそれらのプロセスに再度シグナルを送信します。

<h3 id="resume-after-a-pause">
  一時停止後に再開する
</h3>

一時停止した実行を `/workflows` から再開するには、それを選択して `p` を押します。停止した実行の場合は、Claude に同じスクリプトでワークフローを再起動するよう依頼します。停止した実行のエージェントがまだ終了していない場合、Claude Code は再起動を拒否し、それらのエージェントの 2 番目のコピーが並行して実行されないようにします。

Claude Code は、エージェントが開始した順序で実行を再生し、各エージェントは保存された結果を返すか、再度実行します。

* **完了**: 保存された結果を返します。スクリプトを編集したか、前のエージェントが異なる結果を返したため、プロンプトが前の実行と異なる最初のエージェントが再度実行され、その後のすべてのエージェント（完了したものも含む）も実行されます。
* **停止時にまだ実行中**: 最初からやり直します。実行全体を停止しても、エージェントは失敗としてカウントされません。
* **失敗**: 再度実行され、その後に開始したすべてのエージェント（完了したものも含む）も実行されます。[`/workflows`](#watch-the-run) で選択して `x` を押すことで 1 つのエージェントだけを停止することは、失敗としてカウントされます。

最後のケースは、既に完了した作業をファンアウトの途中で失敗が再実行することを意味します。スクリプトが A、B、C、D をその順序で開始し、B が失敗した場合、再起動は A をキャッシュから返し、B、C、D を再度実行します。

同じ Claude Code セッション内で実行を再開できます。セッションを離れるときに実行中のワークフローに何が起こるかは、どのように離れるかによって異なります。

* [セッションをバックグラウンドにする](/docs/ja/agent-view#what-carries-over-when-you-background)場合、Claude Code はバックグラウンドセッションで同じ方法で実行を再生し、それを続行します。
* ワークフローが実行中に Claude Code を終了し、[エージェントビューがオン](/docs/ja/agent-view#from-inside-a-session)の場合、終了ダイアログは `Move to background and exit` を提供し、実行を同じ方法で引き継ぎます。代わりに `Exit and stop tasks` を選択するか、オプションが提供されない場合、実行はセッションで停止します。Claude Code は `~/.claude/projects/` のそのセッションのディレクトリの下に実行の保存された結果を保持するため、`claude --resume` で再開するセッションは Claude にワークフローを再起動するよう依頼するときにそれらを再生でき、新規に開始するセッションは再生するものがなく、ワークフローを最初から開始します。

<h3 id="cost">
  コスト
</h3>

ワークフローは多くのエージェントを生成するため、単一の実行は会話で同じタスクを処理するより意味のあるほど多くのトークンを使用できます。実行は他のセッションと同様にプランの使用量とレート制限にカウントされます。

大規模なタスクにコミットする前に支出を見積もるには、まず小さなスライスでワークフローを実行します。リポジトリ全体ではなく 1 つのディレクトリ、または広い質問ではなく狭い質問です。`/workflows` ビューは実行の進行に伴い各エージェントのトークン使用量を表示し、完了した作業を失うことなくいつでも実行を停止できます。[一時停止後に再開する](#resume-after-a-pause)は停止した実行が何を保持するかをカバーしています。ランタイムの[エージェント上限](#behavior-and-limits)は単一の実行が生成できるエージェント数を制限し、暴走スクリプトのコストを制限します。実行をより少ないエージェント数に保つには、`small` [サイズガイドライン](#set-a-size-guideline)を選択します。

Claude Code はまた、異常に大きくなった実行にフラグを立てます。ワークフローが 25 個を超えるエージェントをスケジュールするか、その予想トークン合計が 150 万を超える場合、入力ボックスの下のタスクパネルの進捗行に `Large workflow` 警告が表示されます。警告は [`/workflows`](#watch-the-run) を指し、そこで実行を停止できます。

警告は参考情報です。実行を一時停止または制限しません。警告が表示されたときに 2 つの設定が変わります。

* [サイズガイドラインを設定](#set-a-size-guideline)した場合、ガイドラインのエージェント数が 25 エージェントのしきい値に置き換わります。組み込みのデフォルトガイドラインはしきい値を 25 のままにします。
* [ultracode](#let-claude-decide-with-ultracode) がオンのセッションは警告を表示しません。ultracode をオンにすることで既に大規模な実行にオプトインしているためです。

Claude Code は各ワークフローエージェントのモデルを、[サブエージェントに使用するのと同じ順序](/docs/ja/sub-agents#choose-a-model)で選択します。スクリプトがステージに名前を付けるモデルは、その順序でのエージェントごとのモデルとしてカウントされます。他に何も割り当てない場合、エージェントはセッションのモデルで実行されます。

モデルコストを制御するには：

* 通常、ルーチンワーク用に小さいモデルに切り替える場合は、大規模な実行前に `/model` を確認
* タスクを説明するときに、最強のモデルが必要ないステージ用に小さいモデルを使用するよう Claude に依頼

組織の [`availableModels` 許可リスト](/docs/ja/model-config#restrict-model-selection)がスクリプトがエージェントに要求するモデルをブロックする場合、そのエージェントは代わりに代替モデルで実行され、[サブエージェントと同じ代替ルール](/docs/ja/sub-agents#choose-a-model)に従います。[`/workflows`](#watch-the-run) の実行の進捗ビューは、要求されたモデルと代替モデルの両方を名前で示す警告を表示します。

<h3 id="set-a-size-guideline">
  サイズガイドラインを設定する
</h3>

サイズガイドラインは、Claude が動的ワークフローを作成するときに目指すエージェント数を Claude に指示します。Claude Code はガイドラインを Claude へのアドバイスとして送信し、上限ではないため、異なるスケールを要求するプロンプトはそれをオーバーライドします。Claude Code v2.1.202 以降が必要です。

各値はエージェント数にマップされます。

| 値              | Claude が目指すエージェント数                       |
| :------------- | :--------------------------------------- |
| `unrestricted` | ガイドラインなし。Claude はワークフローをタスクに合わせてサイズ設定します |
| `small`        | 5 未満のエージェント                              |
| `medium`       | 15 未満のエージェント                             |
| `large`        | 50 未満のエージェント                             |

デフォルトは `medium` です。値を選択するまで、`/config` 行は `medium (default)` を表示し、ワークフローの `Running in background` 行は `medium size (/config)` を表示します。Claude Code v2.1.219 以降が必要です。以前のバージョンはデフォルトで `unrestricted` です。

ガイドラインを変更するには、`/config` で Dynamic workflow size 設定の値を選択するか、`/config workflowSizeGuideline=small` を実行します。v2.1.219 以降では、任意の設定ファイルで [`workflowSizeGuideline` キー](/docs/ja/settings-reference#workflowsizeguideline)を設定することもできます。その値は `/config` より優先され、設定ファイルが 1 つを提供している間、Claude Code は `/config` 行を非表示にします。

変更は次のプロンプトで有効になります。[ランタイムエージェント上限](#behavior-and-limits)は設定に関係なく引き続き適用されます。

<h3 id="turn-workflows-off">
  ワークフローをオフにする
</h3>

ワークフローは CLI、Desktop アプリ、IDE 拡張機能、[非対話モード](/docs/ja/headless)（`claude -p`）、[Agent SDK](/docs/ja/agent-sdk/overview)で利用可能です。同じ無効化設定がすべてのサーフェスに適用されます。

自分用にワークフローをオフにするには：

* `/config` で Dynamic workflows をオフに切り替え。セッション間で保持
* `~/.claude/settings.json` で `"disableWorkflows": true` を設定。セッション間で保持
* `CLAUDE_CODE_DISABLE_WORKFLOWS=1` を設定。起動時に読み取られるため、設定した場所に適用

組織全体のワークフローをオフにするには、[管理設定](/docs/ja/server-managed-settings)で `"disableWorkflows": true` を設定するか、[Claude Code 管理設定](https://claude.ai/admin-settings/claude-code)ページのトグルを使用します。

ワークフローが無効化されている場合、バンドルされたワークフローコマンドと `/workflow-authoring` スキルは利用不可、`ultracode` キーワードは実行をトリガーしなくなり、`ultracode` は `/effort` メニューから削除されます。

<h2 id="related-resources">
  関連リソース
</h2>

* [エージェントを並列実行](/docs/ja/agents)：サブエージェント、エージェントビュー、エージェントチーム、ワークフローを比較
* [カスタムサブエージェントを作成](/docs/ja/sub-agents)：ワークフローがオーケストレーションするワーカープリミティブ
* [コストを管理](/docs/ja/costs)：マルチエージェント実行が使用制限にカウントされる方法
