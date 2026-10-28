> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# 動的ワークフローで大規模にサブエージェントをオーケストレーションする

> 動的ワークフローは、Claude が作成したスクリプトから多くのサブエージェントをオーケストレーションし、再実行できます。コードベース監査、大規模マイグレーション、相互検証研究に使用します。

> [!NOTE]
>
> 動的ワークフローはすべての有料プランで利用可能で、Anthropic API アクセス、Amazon Bedrock、Google Cloud の Agent Platform、Microsoft Foundry で利用できます。Pro では、`/config` の Dynamic workflows 行からオンにしてください。

動的ワークフローは、[サブエージェント](https://code.claude.com/docs/ja/sub-agents.md)を大規模にオーケストレーションする JavaScript スクリプトです。Claude は説明したタスク用のスクリプトを作成し、ランタイムはバックグラウンドで実行しながら、セッションは応答性を保ちます。

1 つの会話が調整できるより多くのエージェントが必要なタスク、またはオーケストレーションを読み直して再実行できるスクリプトとしてコード化したい場合にワークフローを使用します。例としては、コードベース全体のバグスイープ、500 ファイルのマイグレーション、複数のソースに対して相互検証が必要な研究質問、1 つにコミットする前に複数の独立した角度から下書きする価値のある難しい計画があります。

## ワークフローを使用するタイミング

[サブエージェント](https://code.claude.com/docs/ja/sub-agents.md)、[スキル](https://code.claude.com/docs/ja/skills.md)、[エージェントチーム](https://code.claude.com/docs/ja/agent-teams.md)、およびワークフローはすべてマルチステップタスクを実行できます。違いは、計画を保持する者です。

| | サブエージェント | スキル | エージェントチーム | ワークフロー |
| :- | :- | :- | :- | :- |
| それは何か | Claude が生成するワーカー | Claude が従う指示 | ピアセッションを監督するリードエージェント | ランタイムが実行するスクリプト |
| 次に何が実行されるかを決定する者 | Claude、ターンごと | Claude、プロンプトに従う | リードエージェント、ターンごと | スクリプト |
| 中間結果が存在する場所 | Claude のコンテキストウィンドウ | Claude のコンテキストウィンドウ | 共有タスクリスト | スクリプト変数 |
| 繰り返し可能なもの | ワーカー定義 | 指示 | チーム定義 | オーケストレーション自体 |
| スケール | ターンごとに委任されたいくつかのタスク | サブエージェントと同じ | 長時間実行される少数のピア | 実行ごとに数十から数百のエージェント |
| 中断 | ターンを再開始 | ターンを再開始 | チームメイトは実行を続ける | 同じセッション内で再開可能 |

ワークフローは計画をコードに移動します。サブエージェント、スキル、およびエージェントチームでは、Claude がオーケストレーターです。ターンごとに次に何を生成または割り当てるかを決定し、すべての結果は Claude のコンテキストウィンドウに入ります。ワークフロースクリプトはループ、分岐、および中間結果自体を保持するため、Claude のコンテキストは最終的な答えのみを保持します。

計画をコードに移動することで、ワークフローは単に複数のエージェントを実行するだけでなく、繰り返し可能な品質パターンを適用することもできます。独立したエージェントが相互に対立的にレビューしてから報告されるようにすることも、複数の角度から計画を下書きして相互に比較することもできるため、単一パスより信頼性の高い結果が得られます。

## バンドルされたワークフローを実行する

ワークフローの動作を最も簡単に確認する方法は、Claude Code に含まれている[組み込みワークフロー](#bundled-workflows)である `/deep-research` を実行することです。このワークフローは、複数のソースにわたって質問を調査するためのものです。セッションがバックグラウンドで一連のフェーズを処理している間、セッションは自由に使用でき、ターンバイターンのトランスクリプトではなく、最後に 1 つのレポートが得られます。

**1. ワークフローを実行する**

調査したい質問を使用して `/deep-research` を実行します。複数の角度から Web 検索を展開し、見つけたソースを取得してクロスチェックし、引用されたレポートを合成します。

```text wrap theme={null}
/deep-research What changed in the Node.js permission model between v20 and v22?
```

**2. ワークフローを許可する**

Claude Code はワークフローを許可するかどうかを尋ねます。**Yes** を選択して続行します。正確なプロンプトは権限モードによって異なります。[実行前にプランを承認する](#approve-the-plan-before-it-runs)を参照して、モード別のオプションを確認してください。

**3. 進捗を監視する**

実行がバックグラウンドで開始されます。`/workflows` を実行して進捗ビューを開きます。

```text wrap theme={null}
/workflows
```

`/workflows` に実行のリストが表示された場合は、開始したばかりの実行を選択して Enter キーを押します。ビューには、各フェーズがエージェント数とともに表示されます。任意のフェーズをドリルダウンして、そのエージェントと各エージェントが見つけたものを確認します。[実行を監視する](#watch-the-run)を参照して、コントロールの完全なセットを確認してください。

入力ボックスの下のタスクパネルからも監視できます。実行中は、1 行の進捗サマリーがそこに表示されます。下矢印を押してフォーカスし、Enter キーを押して展開します。

**4. レポートを読む**

実行が完了すると、レポートがセッションに表示されます。各クレームの出所を引用し、クロスチェックで生き残らなかったクレームは既にフィルタリングされています。

検証エージェントがレート制限や API エラーの後など、クレームをチェックできない場合、レポートはそのクレームを未検証として列挙し、反論されたものとしてカウントしません。

独自のタスク用にワークフローを実行するには、[Claude にワークフローを作成させ](#have-claude-write-a-workflow)、実行が目的を達成したら、それを[保存](#save-the-workflow-for-reuse)して独自のコマンドとして使用できます。

### バンドルされたワークフロー

Claude Code には、組み込みワークフローとして `/deep-research` が含まれています。

| コマンド | 機能 |
| :- | :- |
| `/deep-research <question>` | 複数の角度から質問に対する Web 検索を展開し、見つけたソースを取得してクロスチェックし、各クレームに投票し、クロスチェックで生き残らなかったクレームがフィルタリングされた引用されたレポートを返します。[WebSearch ツール](https://code.claude.com/docs/ja/tools-reference.md#websearch-tool-behavior)が利用可能である必要があります |

`/deep-research` は、呼び出すときのみ実行されます。

[自分で保存](#save-the-workflow-for-reuse)したワークフローは同じ方法でコマンドになり、バンドルされたものと一緒に `/` オートコンプリートに表示されます。

### 実行を監視する

ワークフローはバックグラウンドで実行されるため、エージェントが作業している間、セッションは応答性を保ちます。任意の時点で `/workflows` を実行して、実行中および完了したワークフローをリストアップし、1 つを選択してその進捗ビューを開きます。セッションに実行が 1 つしかない場合、`/workflows` はリストをスキップしてその実行を開きます。実行中のワークフローを開かずに停止するには、リストで選択して `x` を押します。

進捗ビューには、各フェーズがエージェント数とともに表示されます。フッターには各アクションのキーが表示されます。

| キー | アクション |
| :- | :- |
| `↑` / `↓` | フェーズまたはエージェントを選択します |
| `Enter` または `→` | 選択したフェーズをドリルダウンし、次にエージェントの詳細をドリルダウンします。詳細では、`Enter` で展開または折りたたみます |
| `Esc` または `←` | 1 レベル戻ります |
| `j` / `k` | エージェント詳細がオーバーフローしたときにスクロールします |
| `f` | 選択したフェーズのエージェントリストをステータスでフィルタリングします。もう一度押すとサイクルします |
| `p` | 実行を一時停止または再開します |
| `x` | 選択したエージェントを停止するか、フォーカスが実行にある場合はワークフロー全体を停止します |
| `r` | 選択した実行中のエージェントを再起動します |
| `s` | 実行のスクリプトを[保存](#save-the-workflow-for-reuse)してコマンドにします |

エージェント詳細には、エージェントのプロンプト、最近のツール呼び出し、および結果が表示されます。各呼び出しは、実行中またはエラーなどの状態を示します。エージェントが独自のタスクリストを保持している場合、詳細にはそれも表示され、各タスクのステータスが表示されます。

`Enter` を押して詳細を展開します。プロンプトと結果は完全に表示され、リストされた各呼び出しはその入力と結果の開始を表示します。

## Claude にワークフローを書かせる

Claude にタスク用のワークフローを書かせるには、2 つの方法があります。

* [プロンプトでワークフローをリクエストする](#ask-for-a-workflow-in-your-prompt)。自分の言葉で、またはキーワード `ultracode` を含めることで、Claude がそのタスク用のワークフローを書きます。
* [ultracode で Claude に決めさせる](#let-claude-decide-with-ultracode)。`/effort ultracode` を設定すると、Claude がセッション内のすべての実質的なタスク用にワークフローを計画します。

既に存在するワークフローコマンドを実行することもできます。`/deep-research` のような[バンドルされたワークフロー](#bundled-workflows)、または[保存した](#save-the-workflow-for-reuse)ワークフローです。

### プロンプトでワークフローをリクエストする

セッションの努力レベルを変更せずに単一のタスクをワークフローとして実行するには、プロンプトにキーワード `ultracode` を含めます。「ワークフローを使用する」または「ワークフローを実行する」など、自分の言葉で尋ねることも機能します。Claude は直接的なリクエストを同じオプトインとして扱います。

```text wrap theme={null}
ultracode: audit every API endpoint under src/routes/ for missing auth checks
```

Claude Code はあなたの入力でキーワードをハイライトし、Claude はターンバイターンで作業するのではなく、タスク用のワークフロースクリプトを書きます。キーワードは Claude が作業をどのように構成するかのみを選択します。エージェントのツール呼び出しは、セッション内の他のツール呼び出しと同じ権限チェックと[サンドボックス化](https://code.claude.com/docs/ja/sandboxing.md)を受けます。

実行が望んだことを実行した場合、その後[コマンドとして保存](#save-the-workflow-for-reuse)できます。別の方法で構築されたオーケストレーターが既にある場合（サブエージェントプロンプトのフォルダーやスキルなど）、Claude にそれを指し示し、同じことを行うワークフローをリクエストできます。

#### キーワードを無視するか、オフにする

ワークフローを開始するつもりがなかった場合、macOS では `Option+W`、Windows と Linux では `Alt+W` を押してこのプロンプトのハイライトを無視するか、ハイライトされたキーワードの直後にカーソルがある状態でバックスペースを押します。キーワードがまったくトリガーされないようにするには、`/config` で Ultracode キーワードトリガーをオフにします。

#### キーワードが機能する場所

キーワードは、自分で入力したプロンプトでのみオプトインです。対話型プロンプト、IDE 拡張機能パネル、[Remote Control](https://code.claude.com/docs/ja/remote-control.md) クライアント、またはキーボード入力の [`origin`](https://code.claude.com/docs/ja/agent-sdk/typescript#sdkmessageorigin) を `{ kind: "human" }` としてスタンプする Agent SDK アプリケーションです。セッションに別の方法で到達した場合、ワークフローを開始しません。

* `-p` で渡されたプロンプト
* Agent SDK アプリケーションが人間の入力としてスタンプせずに送信するプロンプト
* スケジュールされたタスクプロンプト
* ウェブフック ペイロードまたはプルリクエストコメントが会話にリレーされた場合

### ultracode で Claude に決めさせる

Ultracode は Claude Code の設定で、セッションが実行される[努力レベル](https://code.claude.com/docs/ja/model-config.md#adjust-effort-level)で自動ワークフローオーケストレーションをオンにします。オンにすると、Claude はあなたが尋ねるのを待つのではなく、各実質的なタスク用にワークフローを計画します。Claude Code プロンプトでオンにします。

```text wrap theme={null}
/effort ultracode
```

ultracode が既にオンの状態でセッションを開始するには、`claude --effort ultracode` で起動します。これにより effort レベルも `xhigh` に設定されます。

`/effort` スライダーからオンにするには、`Tab` を押して **Ultracode** トグルを反転させ、`Enter` を押して適用します。[努力レベルを調整する](https://code.claude.com/docs/ja/model-config.md#adjust-effort-level)は ultracode をオンにするルートをリストします。

ultracode がオンの場合、Claude はタスクがワークフローを必要とするかどうかを決定します。単一のリクエストは複数のワークフローに変わる可能性があります。コードを理解するためのワークフロー、変更を加えるためのワークフロー、それを検証するためのワークフローです。これはセッション内のすべてのタスクに適用されるため、各リクエストはより多くのトークンを使用し、ワークフローなしの同じリクエストよりも長くかかります。サブスクリプションプランでは、これらのトークンは使用制限に対して引き出されるため、ultracode がオンのセッションは、オフの同じ作業よりも早くセッションまたは週間制限に達します。

ultracode をオンにすると既に大規模な実行にオプトインしているため、これらのチェックはオンの間は適用されません。

* [`Large workflow` 警告](#cost)はワークフロー実行に表示されません
* セッションの[同時サブエージェント制限](https://code.claude.com/docs/ja/sub-agents.md#concurrent-subagent-limit)は、Claude が Agent ツールで生成するサブエージェントに対して強制されません
* 自動権限モード では、[ワークフロー起動を承認](#approve-the-plan-before-it-runs)するよう求められません

`/effort ultracode` は現在のセッション用です。すべてのセッションをそれで開始するには、[`ultracode`](https://code.claude.com/docs/ja/settings-reference#ultracode) 設定を設定します。日常的な作業に戻るときは `/effort ultracode off` でオフにします。`/effort` スライダーは [ultracode が利用可能な場合](https://code.claude.com/docs/ja/model-config.md#when-ultracode-is-available)のみトグルを提供します。v2.1.284 より前は、`/effort ultracode` はセッションを `xhigh` に設定し、`/effort ultracode off` は `Invalid argument` で失敗していました。

### 実行前にプランを承認する

CLI では、実行ごとのプロンプトは計画されたフェーズとこれらのオプションを表示します。

* **Yes, run it**: 実行を開始する
* **Yes, and don't ask again for `<name>` in `<path>`**: 開始し、このプロジェクトでこのワークフローに対してこのプロンプトをスキップします。Claude Code は、現在のタスク用に Claude が書いたスクリプトではなく、バンドルされた、保存された、またはプラグインワークフローを名前で実行する場合にこのオプションを提供します。
* **View raw script**: 決定する前にスクリプトを読む
* **No**: キャンセル

`Ctrl+G` はスクリプトをエディターで開きます。**Yes, run it** または **No** を選択した状態で `Tab` を押すと、回答に[コメントを追加](https://code.claude.com/docs/ja/permissions.md#add-a-comment-when-you-answer-a-permission-prompt)できます。

このプロンプトが表示されるかどうかは、[権限モード](https://code.claude.com/docs/ja/permission-modes.md)によって異なります。

| 権限モード | プロンプトが表示される場合 |
| :- | :- |
| Auto | 最初の起動のみ。任意の **Yes** はユーザー設定に同意を記録し、後の起動はプロンプトなしで開始します。ultracode がオンの場合は完全にスキップされます |
| Manual, accept edits | すべての実行。ただし、このプロジェクトでそのワークフローに対して **Yes, and don't ask again** を選択した場合を除きます |
| Bypass permissions | Claude Code はプロンプトを表示しません。実行は直ちに開始されます |
| `claude -p`, Agent SDK | Claude Code はプロンプトを表示しません |

`claude -p` と Agent SDK では、Claude Code はこのプロンプトを表示しません。セッションの残りの部分と同じ[権限評価](https://code.claude.com/docs/ja/agent-sdk/permissions.md#how-permissions-are-evaluated)を通じてワークフロー ツール呼び出しを実行するため、拒否ルール、質問ルール、および `dontAsk` モードはすべてのツール呼び出しに適用されるのと同じように適用されます。これらの実行でワークフローを開始させるには、次のいずれかを使用します。

* **権限ルール**: すべてのワークフローを承認するには許可ルールに `Workflow` を追加し、名前で 1 つの保存されたワークフローを承認するには `Workflow(<name>)` を追加します。
* **auto 権限モード**: [auto モード](https://code.claude.com/docs/ja/permission-modes.md#eliminate-prompts-with-auto-mode)で実行します。auto モードでは分類器が呼び出しをレビューし、それを承認できます。
* **バイパス権限モード**: バイパス権限モードで実行します。
* **フック**: [`PreToolUse`](https://code.claude.com/docs/ja/hooks#pretooluse) フックから呼び出しに対して `"allow"` を返します。[plan モード](https://code.claude.com/docs/ja/permission-modes.md#analyze-before-you-edit-with-plan-mode)では、フックの承認だけではワークフローは開始されないため、代わりに権限ルールまたはホストの承認を使用します。
* **ホスト**: [`--permission-prompt-tool`](https://code.claude.com/docs/ja/cli-reference#cli-flags)、または Agent SDK では [`canUseTool`](https://code.claude.com/docs/ja/agent-sdk/permissions) コールバックがそれを承認します。

デスクトップアプリでは、承認カードはワークフロー名、フェーズリスト、トークン使用量の注意を表示し、**Once**、**Always**、**Deny** アクションを表示します。進行状況ビューは、バックグラウンドタスクサイドペインに表示されます。

ワークフローが生成するサブエージェントは、[権限ルール](https://code.claude.com/docs/ja/settings-reference.md#permission-settings)を使用し、Claude Code は[サブエージェントが実行される権限モード](https://code.claude.com/docs/ja/sub-agents.md#permission-modes)の下のルールによって権限モードを選択します。長い実行でプロンプトを避けるには、エージェントが必要とするツールを開始する前に許可ルールに追加します。

### 再利用するためにワークフローを保存する

Claude が繰り返すタスク用のワークフローを書く場合、その実行のスクリプトをコマンドとして保存できます。すべてのブランチで実行するレビューなどのプロセスは、毎回同じオーケストレーションを実行します。

`/workflows` を実行し、保持したい実行を選択して、`s` を押します。保存ダイアログで、Tab は 2 つの保存場所を切り替えます。

* プロジェクト内の `.claude/workflows/`。リポジトリをクローンする全員と共有されます
* ホームディレクトリ内の `~/.claude/workflows/`。すべてのプロジェクトで利用可能で、あなたにのみ表示されます。[`CLAUDE_CONFIG_DIR`](https://code.claude.com/docs/ja/env-vars) を設定した場合、この場所はそのパスの下の `workflows/` ディレクトリです。

保存ダイアログには個人用の場所の解決されたパスが表示されます。Enter を押して保存します。ワークフローは、どちらの場所に保存した場合も、以降のセッションで `/<name>` として実行されます。

Claude Code は書き込み前に保存場所にシンボリックリンクがないかをチェックし、シンボリックリンクを通じて書き込む代わりにエラーを表示します。

* プロジェクト場所: `.claude`、`.claude/workflows`、またはターゲットファイルがシンボリックリンクの場合、Claude Code は拒否します。
* 個人用の場所: Claude Code はターゲットファイル自体がシンボリックリンクの場合のみ拒否するため、ドットファイルツールで管理される `~/.claude` ディレクトリは引き続き機能します。

複数の `.claude/` ディレクトリを持つモノレポでは、ワークフローを適用するパッケージの横に保持できます。プロジェクト場所に保存すると、作業ディレクトリとリポジトリルートの間に既に存在する最も近い `.claude/workflows/` ディレクトリに書き込むか、まだ存在しない場合はリポジトリルートに書き込みます。プロジェクトワークフローはそのパス沿ったすべての `.claude/workflows/` からも読み込まれ、複数が同じ名前を定義する場合、Claude Code は作業ディレクトリに最も近いものを実行します。

プロジェクトワークフローと個人用ワークフローが名前を共有する場合、プロジェクトのものが実行されます。

### プラグインでワークフローを配布する

チーム間またはリポジトリ間でワークフローを共有するには、[プラグイン](https://code.claude.com/docs/ja/plugins/overview.md)に含めます。スクリプトをプラグインルートの `workflows/` ディレクトリに配置するか、[`workflows` マニフェストフィールド](https://code.claude.com/docs/ja/plugins/manifest-reference#fields)で別の場所を指します。

プラグインワークフローはプラグイン名でネームスペースされます。`meta.name` が `release-audit` のスクリプトを含む `acme-tools` というプラグインは `/acme-tools:release-audit` として実行されます。

### 保存されたワークフローに入力を渡す

保存されたワークフローは `args` パラメーターを通じて入力を受け入れることができます。スクリプトは `args` という名前のグローバルとして読み込みます。スクリプトを編集するのではなく、呼び出し時に研究質問、ターゲットパスのリスト、または構成オブジェクトを提供するために使用します。

次のプロンプトは、問題番号のリストを使用して保存されたワークフローを実行します。

```text wrap theme={null}
Run /triage-issues on issues 1024, 1025, and 1030
```

Claude はリストを構造化データとして渡すため、スクリプトは最初に解析することなく `args` に対して配列とオブジェクトメソッドを直接呼び出すことができます。`args` が省略された場合、グローバルはスクリプト内で `undefined` です。

## ワークフローの実行例プロンプト

ワークフローは、タスクが 1 つのエージェントがコンテキストに保持できるより大きい場合、または同じステップが多くのアイテムにわたって実行する必要がある場合に最適です。以下のプロンプトは一般的な形を示しています。それぞれは Claude にそのタスク用のワークフローを作成して実行するよう依頼します。スクリプト自体は作成しません。

### 同じ問題について多くのファイルを監査する

1 つのエージェントをファイルごとにファンアウトし、その後、検出結果を収集して検証します。

```text wrap theme={null}
use a workflow to audit every route handler under src/routes/ for missing authentication checks, and adversarially verify each finding before reporting it
```

### チェックが合格するまで修正を続ける

チェッカーを実行し、失敗したものを修正し、合格するか進捗が止まるまで繰り返します。

```text wrap theme={null}
use a workflow to run npx tsc --noEmit and keep fixing the reported errors until the type check passes or two rounds in a row make no progress
```

### 多くのファイルを並列でマイグレーションする

マイグレーションするファイルを検出し、編集が競合しないように各ファイルを分離されたコピーで変換し、各結果を検証します。

```text wrap theme={null}
use a workflow to migrate every component under src/components/ from JavaScript to TypeScript, working on each file in its own isolated copy
```

### すべての変更されたファイルをレビューして 1 つのサマリーを作成する

ファイルごとにレビュアーを実行し、その後、すべての検出結果を 1 つのエージェントに渡して、それらをランク付けして重複排除します。

```text wrap theme={null}
use a workflow to review every file changed in this PR for correctness issues, then merge the per-file findings into one ranked summary
```

### 多くのソースにわたってトピックを研究する

チェンジログ、問題、ドキュメント全体でリーダーをファンアウトし、その後、合成します。バンドルされた `/deep-research` ワークフローはこれを実行します。より狭いバージョンを説明することもできます。

```text wrap theme={null}
use a workflow to research how our three competitors handle rate limiting: read their public docs and recent changelog entries in parallel, then compare the approaches
```

### リストが成長を停止するまで問題を見つける

ラウンドで検索を続け、新しいラウンドが新しいものを見つけなくなったら停止します。

```text wrap theme={null}
use a workflow to find flaky tests in this repo: run the suite repeatedly, record which tests fail intermittently, and stop once two rounds in a row find nothing new
```

### 保存されたスクリプトの外観

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

`agent()` 呼び出しは、実行中に停止した場合または回復不可能な API エラーが発生した場合は `null` に解決されます。`pipeline()` はその `null` を結果配列に保持するため、例は `.filter(Boolean)` で終わり、[すべての試行で停止したエージェント](#when-an-agent-stalls-and-restarts)のスロットを含め、それらのエントリを削除します。

[auto モード](https://code.claude.com/docs/ja/permission-modes.md#eliminate-prompts-with-auto-mode)では、スクリプトが `agent()` に渡すプロンプトは、分類器がそのサブエージェントのアクションをレビューするときにあなたからのリクエストとしてカウントされません。Claude Code はそれをスクリプトが計算したテキストとしてマークするためです。

`agent()` 呼び出しで `schema` を渡す場合、そのサブエージェントはプローズの代わりに形状に一致する JSON を返します。Claude Code はサブエージェントを開始する前にスキーマをチェックします。スキーマが矛盾していることを証明できる場合、呼び出しは矛盾を名前付けするエラーで失敗し、サブエージェントは開始されません。証明できる 1 つの矛盾は、`additionalProperties: false` が除外する `required` キーです。

サブエージェントの出力が 5 回の試行後も検証に失敗する場合、呼び出しは最後の検証失敗を含むエラーで失敗します。試行回数を変更するには、[`MAX_STRUCTURED_OUTPUT_RETRIES`](https://code.claude.com/docs/ja/env-vars) を設定します。

### 保存されたスクリプトを編集する

[保存したワークフロー](#save-the-workflow-for-reuse)を変更するには、その `.js` ファイルを編集するか、Claude に変更を依頼します。編集または依頼する前に、`/workflow-authoring` [バンドルされたスキル](https://code.claude.com/docs/ja/skills.md#bundled-skills)を実行して、Claude が作業する対象のスクリプト作成リファレンスを読み込みます。スキルには Claude Code v2.1.248 以降が必要です。

現在のセッションで編集されたバージョンを実行するには、[`/reload-skills`](https://code.claude.com/docs/ja/commands#all-commands) を実行してワークフロー ディレクトリを再度読み込み、その後 `/<name>` を再度実行します。

Claude Code はスクリプトを読み込んで実行するときに、ファイルの各部分に次のルールを適用します。

* **`meta` ブロック**: `export const meta` を最初のステートメントとして保持し、`name` と `description` を持つプレーン オブジェクト リテラルとして保持します。変数、関数呼び出し、スプレッドなどのリテラル値以外のものが含まれている場合、Claude Code は `/` オートコンプリートから `/<name>` を削除します。
* **本体**: `agent()`、`pipeline()`、`parallel()` の他に、`phase()` を呼び出して、進捗ビューのタイトルの下に続くエージェントをグループ化し、`log()` を呼び出してフェーズの上にメッセージを表示し、[`args`](#pass-input-to-a-saved-workflow) グローバルを読み取ることができます。本体に構文エラーがある場合、Claude Code はワークフローを実行するときにそれを報告します。
* **`phases`**: `meta` にそれらをリストする場合、`phase()` に渡す各エントリに正確にタイトルを付けます。エントリのない `phase()` タイトルは独自の進捗グループを取得します。
* **タイムスタンプとランダム性**: Claude Code はスクリプト内で `Date.now()`、`Math.random()`、および引数なしの `new Date()` をスローするため、[再開された実行](#resume-after-a-pause)は同じ `agent()` 呼び出しを繰り返します。代わりに `args` を通じてタイムスタンプを渡します。

保存されたコピーではなく、[単一の実行のスクリプト](#how-a-workflow-runs)を編集することもできます。[一時停止後に再開](#resume-after-a-pause)は、編集されたスクリプトを再開したときにどのエージェントが再度実行されるかについて説明します。Workflow ツールの入力については、[Agent SDK リファレンス](https://code.claude.com/docs/ja/agent-sdk/typescript.md#workflow)のそのエントリを参照してください。

## ワークフローの実行方法

ワークフローランタイムは、会話から分離された隔離環境でスクリプトを実行します。中間結果は Claude のコンテキストに入る代わりにスクリプト変数に留まります。

Claude がスクリプトファイルのパスから実行を開始する場合を除き、Claude Code は実行のスクリプトを `~/.claude/projects/` 内のセッションのディレクトリ配下のファイルに書き込みます。実行が開始されると Claude はスクリプトのパスを受け取るため、それを尋ねることができます。そのファイルを開いて、Claude が作成したオーケストレーションを読んだり、前回の実行のスクリプトとの差分を確認したり、編集して Claude に編集版から再起動するよう依頼したりできます。

Claude がワークフローを開始できるのは、セッションが既に読み取りを許可されているスクリプトファイルからのみです。作業ディレクトリの外に保存されているスクリプトを実行するには、まず [`/add-dir`](https://code.claude.com/docs/ja/permissions#working-directories) でそのディレクトリを追加するか、[Read 許可ルール](https://code.claude.com/docs/ja/permissions.md#read-and-edit)を設定してください。

ランタイムは実行が進むにつれて各エージェントの結果を追跡します。これが実行を[一時停止後に再開](#resume-after-a-pause)可能にする理由です。同じセッション内で。

### ファンアウトでのプロンプトキャッシング

同じ実行内のエージェントは、互いの[プロンプトキャッシュ](https://code.claude.com/docs/ja/prompt-caching.md#subagents-and-the-cache)を読み取ることができます。同じモデル、努力レベル、エージェントタイプ、ツール、出力スキーマ、および作業ディレクトリで実行される 2 つのエージェントは、同じツールおよびシステムプロンプトプレフィックスを構築するため、マッチングする兄弟の応答が開始された後に開始されるエージェントは、最初のリクエストでその兄弟のキャッシュを読み取ります。

ワークフローエージェントのリクエストはメイン会話の[キャッシュ TTL バケット](https://code.claude.com/docs/ja/prompt-caching.md#which-ttl-each-request-gets)の外にあるため、そのキャッシュはデフォルトで 5 分間保持されます。Claude サブスクリプションでも同様です。1 時間保持するには、[`subagentPromptCacheTtl`](https://code.claude.com/docs/ja/settings-reference#subagentpromptcachettl) を `1h` に設定してください。API は 1 時間のキャッシュ書き込みをより高いレートで課金します。

ファンアウトが複数のマッチングエージェントを一度に開始する場合、Claude Code は最初のエージェント以外をすべて保持し、最初のエージェントの応答が開始されるまで待機してから、保持されたエージェントを一緒にリリースして、最初のリクエストで共有プレフィックスを読み取り、各エージェントがキャッシュなしで処理するのを避けます。Claude Code は保持を [`CLAUDE_CODE_WORKFLOW_PREFIX_STAGGER_MS`](https://code.claude.com/docs/ja/env-vars) ミリ秒でキャップします。デフォルトは `5000` です。保持を無効にするには `0` に設定してください。

### 動作と制限

ランタイムは以下の制約を適用します。

| 制約 | 理由 |
| :- | :- |
| 実行中のユーザー入力なし | 実行は、エージェント権限プロンプトと[使用制限待機](#when-a-run-hits-your-usage-limit)のみで一時停止します。ステージ間の署名のために、各ステージを独自のワークフローとして実行してください |
| ワークフロー自体からの直接ファイルシステムまたはシェルアクセスなし | エージェントは読み取り、書き込み、コマンドを実行します。スクリプトはエージェントを調整します |
| モジュール読み込みなし：`import()` を含むスクリプトは実行開始前に失敗します | スクリプト本体はプレーン JavaScript です。ライブラリが必要な作業はエージェントのタスクに配置してください |
| 最大 16 個の同時エージェント。デフォルトでは、CPU が限定されたコンテナ内を含め、Claude Code が利用可能な CPU が少ない場合はより少ない。制限を変更するには、[`CLAUDE_CODE_WORKFLOW_MAX_CONCURRENT_AGENTS`](https://code.claude.com/docs/ja/env-vars#variables) を 1 から 256 の値に設定します。これには Claude Code v2.1.269 以降が必要です | ローカルリソース使用を制限します |
| ファンアウトでは、最初のエージェントのプロンプトキャッシュプレフィックスを共有するエージェントはデフォルトで最初のエージェントの 5 秒後までに開始します | すべてが最初のエージェント以外は、[最初のエージェントがキャッシュしたプレフィックス](#prompt-caching-in-a-fan-out)を読み取り、各エージェントがキャッシュなしで処理するのを避けます |
| 単一の `parallel()` または `pipeline()` 呼び出しで最大 4,096 個のアイテム：ランタイムはより長いリストをエラーで拒否します | サイレント上限はスクリプトに通知せずにワークロードの一部をドロップします |
| 実行ごとに合計 1,000 エージェント | 暴走ループを防止します |

## 実行を管理する

実行が開始されたら、`/workflows` ビューから、または入力ボックスの下にあるタスクパネルで進捗行を展開して管理します。

実行を停止しても、そのエージェントのプロセスがまだ動作している間は、実行はタスクパネルに残ります。もう一度停止すると、Claude Code はそれらのプロセスに再度シグナルを送ります。

### 一時停止後に再開する

一時停止した実行は、`/workflows` で選択して `p` を押すと再開できます。停止した実行については、同じスクリプトでワークフローを再起動するよう Claude に依頼します。停止した実行のエージェントがまだ終了していない場合、Claude Code はそれらが終了するまで再起動を拒否します。これにより、それらのエージェントの 2 つ目のコピーが並行して実行されることを防ぎます。

#### どのエージェントが再実行されるか

Claude Code はエージェントが開始される順序で実行をリプレイし、各エージェントは保存された結果を返すか、再実行されます。

* **完了済み**: 保存された結果を返します。スクリプトを編集した、または前のエージェントが異なる結果を返したために、前回の実行とプロンプトが異なる最初のエージェントは再実行され、それ以降のすべてのエージェントも、完了済みのものを含めて再実行されます。

  v2.1.305 より前では、`pipeline()` の各項目や `parallel()` の各タスクがそれぞれ複数のエージェントを実行するスクリプトを編集せずに再起動した場合にも、完了済みのエージェントが再実行されることがありました。新しい実行でこうした再実行を防ぐには、Claude Code を更新してください。
* **停止時にまだ実行中だったもの**: 最初からやり直します。実行全体を停止しても、どのエージェントも失敗とは見なされません。
* **失敗したもの**: 再実行され、スクリプトがその後に開始するすべてのエージェントも、完了済みのものを含めて再実行されます。[`/workflows`](#watch-the-run) でエージェントを選択して `x` を押し、1 つのエージェントだけを停止した場合は、失敗として扱われます。

この最後のケースは、ファンアウトの途中で失敗が起きると、すでに完了した作業が再実行されることを意味します。スクリプトが A、B、C、D の順に開始し、B が失敗した場合、再起動すると A はキャッシュから返され、B、C、D が再実行されます。

A、B、C、D を開始していたスクリプトを編集して A、C、B、D の順に開始するようにすると、2 番目に開始するエージェントは C になりますが、前回の実行では B でした。再起動すると A はキャッシュから返され、C、B、D が再実行されます。

#### セッションを離れた後に再開する

ワークフローの実行中にセッションをバックグラウンドに移したり Claude Code を終了したりした場合、実行は自動的には続行しません。実行が続行するのは、Claude が `Workflow` 呼び出しで再起動したときだけで、その際は[保存された結果から実行がリプレイされます](#which-agents-run-again)。

* **セッションをバックグラウンドに移した、または [`Move to background and exit`](https://code.claude.com/docs/ja/agent-view#from-inside-a-session) を選択した場合**: [バックグラウンドセッション](https://code.claude.com/docs/ja/agent-view.md#what-carries-over-when-you-background)を確認した時点で実行が続行していなければ、そのセッションでワークフローの再起動を Claude に依頼します。[権限モード](#approve-the-plan-before-it-runs)によっては、Claude Code はまず再起動の承認を求めます。セッションがエージェントビューの `Needs input` の下に表示されている場合は、[セッションにアタッチして](https://code.claude.com/docs/ja/agent-view.md#attach-to-a-session)承認プロンプトに応答してください。
* **バックグラウンドセッションでの再起動が `nothing to resume` で失敗した場合**: ワークフローを新しい実行として最初から開始するよう Claude に依頼します。作業ディレクトリ内のスクリプトなど、`~/.claude/projects/` の外にあるスクリプトファイルのパスから Claude が実行を開始した場合、Claude はバックグラウンドセッションでその実行を再起動できません。
* **`Exit and stop tasks` を選択した場合、または `Move to background and exit` が表示されなかった場合**: 実行はセッションとともに停止し、Claude Code は実行の保存済み結果を `~/.claude/projects/` 内のそのセッションのディレクトリに保持します。シェルで `claude --resume` を使ってセッションを再開し、ワークフローの再起動を Claude に依頼してください。新しく開始したセッションでは、Claude には再起動する以前の実行がないため、ワークフローを最初から開始します。

[クラウドセッション](https://code.claude.com/docs/ja/claude-code-on-the-web.md)では、Claude Code は実行の結果をセッションの会話履歴とともにも保存し、これはセッションの VM が回収されても残ります。[そのようなセッションを再度開いて](https://code.claude.com/docs/ja/claude-code-on-the-web.md#environment-expired)ワークフローの再起動を Claude に依頼すると、完了済みのエージェントは引き続き保存された結果を返します。

ローカルセッションでもクラウドセッションでも、Claude が以前の実行を再起動する際に Claude Code がその実行の保存済み結果をまったく見つけられない場合、再起動は自動的に実行を最初からやり直すのではなく、`nothing to resume` エラーで失敗します。ワークフローを新しい実行として最初から開始するよう Claude に依頼してください。

### 実行が使用制限に達した場合

エージェントが claude.ai の[使用制限](https://code.claude.com/docs/ja/interactive-mode.md#wait-for-a-usage-limit-to-reset)に達すると、そのエージェントを失敗させるのではなく、実行が一時停止します。制限に達したエージェントはリセットを待ち、新しいエージェントは開始されません。制限がリセットされた直後に、待機中のエージェントが再実行され、実行は自動的に続行します。Claude Code v2.1.271 以降が必要です。それより前のバージョンでは、影響を受けたエージェントは失敗します。

実行が待機している間、タスクパネルの進捗行と [`/workflows`](#watch-the-run) のヘッダーに制限がリセットされる時刻が表示されます。

実行が一時停止するのは、以下のすべてが満たされる場合のみです。いずれかが満たされない場合、影響を受けたエージェントは代わりに失敗します。

* セッションが対話型で、claude.ai サブスクリプションでサインインしていること。`claude -p` による[非対話モード](https://code.claude.com/docs/ja/headless.md)や [Agent SDK](https://code.claude.com/docs/ja/agent-sdk/overview.md)、[バックグラウンドセッション](https://code.claude.com/docs/ja/agent-view.md)、[Remote Control](https://code.claude.com/docs/ja/remote-control.md) や[エージェントチーム](https://code.claude.com/docs/ja/agent-teams.md)のチームメイトセッションでは、実行は一時停止しません。
* [`autoContinueAtUsageLimit`](https://code.claude.com/docs/ja/settings-reference#autocontinueatusagelimit) がオンであること。これは、セッション自体が[使用制限のリセットを待つ](https://code.claude.com/docs/ja/interactive-mode.md#wait-for-a-usage-limit-to-reset)ようにするのと同じ設定です。待機中にオフにすると、待機が終了し、待機中のエージェントは失敗します。
* 制限が 24 時間以内にリセットされること。週単位の制限はそれより先にリセットされる場合があります。
* 実行がまだ 2 回待機していないこと。3 回目に制限に達すると、エージェントは失敗します。

### エージェントが停滞して再起動する場合

出力が十分に長い時間届かなくなったエージェントは、同じプロンプトから最初からやり直します。[`/workflows`](#watch-the-run) では、その名前に `(retry 1)` という接尾辞が付き、詳細に `attempt 2 (stalled)` と表示されます。再起動は自動で行われるため、何もする必要はありません。

新しい試行は、停滞した試行のトランスクリプトなしで開始されます。停滞した試行がすでに変更したファイルは変更されたままで、消費したトークンは実行の合計に残ります。停滞ウィンドウとは、Claude Code が試行を終了する前にエージェントからの出力を待つ時間です。エージェントが自身のツール呼び出しや[使用制限のリセット](#when-a-run-hits-your-usage-limit)を待っている時間は、停滞ウィンドウにはカウントされません。

エージェントの再起動は、`r` で依頼した再起動も含めて最大 5 回です。6 回目の試行も停滞した場合、`agent()` 呼び出しは失敗し、エラーの冒頭にその理由が示されます。

* `agent stalled on all 6 attempts`: すべての試行がウィンドウ全体にわたって出力なしでした。エージェントの作業がそれほど長く出力を生まない場合は、ウィンドウを延長してください
* `agent lost its reply on all 6 attempts`: すべての試行で応答ストリームが途絶え、Claude Code がその待機を断念しました。[ストリーミングアイドルウォッチドッグ](https://code.claude.com/docs/ja/network-config.md#streaming-idle-watchdogs)が先に応答を終了させており、そのウォッチドッグのタイムアウトは `CLAUDE_STREAM_IDLE_TIMEOUT_MS` で設定されるため、停滞ウィンドウを延長しても効果はありません
* `agent abandoned after 6 attempts`: 試行がそれぞれ異なる形で終了しました。エラーにはそれらが順に列挙されます

ウィンドウが終了する前にエージェントが出力を生成するための時間を延ばすには、次のようにします。

* **1 つのエージェント**: その `agent()` 呼び出しでミリ秒単位の `stallMs` を渡します。たとえば 30 分なら `agent(prompt, { stallMs: 1800000 })` とします
* **すべてのエージェント**: [`CLAUDE_ASYNC_AGENT_STALL_TIMEOUT_MS`](https://code.claude.com/docs/ja/env-vars#variables) を設定します。これはワークフロー外のサブエージェントにも適用されます

失敗後に実行が続行するかどうかは、スクリプトがエージェントをどのように呼び出したかによって異なります。

* **[`parallel()` または `pipeline()`](#what-the-saved-script-looks-like) 内**: エージェントの結果の代わりに `null` を使って実行が続行します
* **直接 await した場合**: 実行はエラーで終了します

もう一度試すには、ワークフローの再起動を Claude に依頼します。何が再実行されるかについては[一時停止後に再開する](#resume-after-a-pause)を参照してください。

### コスト

ワークフローは多数のエージェントを生成するため、1 回の実行で、同じタスクを会話で進める場合よりもかなり多くのトークンを使用することがあります。実行はプランの使用量とレート制限にカウントされます。

大きなタスクに取りかかる前に消費量を見積もるには、まず小さな範囲でワークフローを実行してください。たとえば、リポジトリ全体ではなく 1 つのディレクトリで、あるいは広範な質問ではなく絞り込んだ質問で実行します。`/workflows` ビューには実行の進行に合わせて各エージェントのトークン使用量が表示され、そこでいつでも実行を停止できます。通常、完了した作業は失われません。停止した実行で何が保持されるかについては[一時停止後に再開する](#resume-after-a-pause)を参照してください。ランタイムの[エージェント上限](#behavior-and-limits)により、1 回の実行で生成できるエージェント数が制限されるため、暴走したスクリプトのコストにも上限があります。実行のエージェント数を少なく抑えるには、`small` の[サイズガイドライン](#set-a-size-guideline)を選択してください。

Claude Code は、異常に大きくなった実行についても警告します。ワークフローが 25 を超えるエージェントをスケジュールした場合、または予測トークン合計が 150 万を超えた場合、入力ボックスの下にあるタスクパネルの進捗行に `Large workflow` 警告が表示されます。この警告は [`/workflows`](#watch-the-run) を案内しており、そこで実行を停止できます。

この警告は参考情報であり、実行を一時停止したり制限したりはしません。警告が表示されるタイミングは、次の 2 つの設定で変わります。

* [サイズガイドライン](#set-a-size-guideline)を自分で選択した場合、そのエージェント数が 25 エージェントのしきい値に置き換わります。組み込みのデフォルトガイドラインでは、しきい値は 25 のままです。
* [ultracode](#let-claude-decide-with-ultracode) がオンのセッションでは、警告は表示されません。ultracode をオンにした時点で、大規模な実行をすでに許可しているためです。

Claude Code は、各ワークフローエージェントのモデルを、[サブエージェントで使用するのと同じ順序](https://code.claude.com/docs/ja/sub-agents.md#choose-a-model)で選択します。スクリプトがステージに指定したモデルは、その順序における呼び出しごとのモデルとして扱われます。他に何も割り当てられていない場合、エージェントはセッションのモデルで実行されます。

モデルのコストを管理するには、次のようにします。

* 日常的な作業で普段は小さいモデルに切り替えている場合は、大規模な実行の前に `/model` を確認します
* タスクを説明する際に、最も強力なモデルを必要としないステージには小さいモデルを使うよう Claude に依頼します

組織の [`availableModels` 許可リスト](https://code.claude.com/docs/ja/model-config#restrict-model-selection)によって、スクリプトがエージェントに要求したモデルがブロックされた場合、そのエージェントは[サブエージェントと同じ置き換えルール](https://code.claude.com/docs/ja/sub-agents.md#choose-a-model)に従い、代わりのモデルで実行されます。

### サイズガイドラインを設定する

サイズガイドラインは、Claude が動的ワークフローを作成する際に目標とするエージェント数を伝えるものです。Claude Code はガイドラインを上限ではなく助言として Claude に送信するため、異なる規模を求めるプロンプトはガイドラインを上書きします。

各値はエージェント数に対応しています。

| 値 | Claude が目標とするエージェント数 |
| :- | :- |
| `unrestricted` | ガイドラインなし: Claude がタスクに合わせてワークフローの規模を決定します |
| `small` | 5 エージェント未満 |
| `medium` | 10 エージェント未満 |
| `large` | 50 エージェント未満 |

デフォルトは `medium` です。ただし、Claude Code v2.1.271 以降で Pro プランでサインインしている場合は `small` です。値を選択するまで、`/config` の行ではその値がデフォルトとして示され、ワークフローの `Running in background` 行には適用中のサイズが表示されます。

ガイドラインを変更するには、`/config` の Dynamic workflow size 設定で値を選択するか、`/config workflowSizeGuideline=small` を実行します。任意の設定ファイルで [`workflowSizeGuideline` キー](https://code.claude.com/docs/ja/settings-reference#workflowsizeguideline)を設定することもできます。その値は `/config` より優先され、設定ファイルで値が指定されている間、Claude Code は `/config` の行を非表示にします。

変更は次のプロンプトから有効になります。設定にかかわらず、[ランタイムのエージェント上限](#behavior-and-limits)は引き続き適用されます。

### ワークフローをオフにする

ワークフローは、CLI、デスクトップアプリ、IDE 拡張機能、`claude -p` による[非対話モード](https://code.claude.com/docs/ja/headless.md)、[Agent SDK](https://code.claude.com/docs/ja/agent-sdk/overview.md) で利用できます。すべてのサーフェスで同じ無効化設定が適用されます。

自分用にワークフローをオフにするには、次のいずれかを行います。

* `/config` で Dynamic workflows をオフに切り替えます。セッションをまたいで保持されます。
* `~/.claude/settings.json` で `"disableWorkflows": true` を設定します。セッションをまたいで保持されます。
* `CLAUDE_CODE_DISABLE_WORKFLOWS=1` を設定します。起動時に読み込まれるため、設定した場所で適用されます。

組織全体でワークフローをオフにするには、[管理設定](https://code.claude.com/docs/ja/server-managed-settings.md)で `"disableWorkflows": true` を設定するか、[Claude Code 管理設定](https://claude.ai/admin-settings/claude-code)ページのトグルを使用します。

ワークフローが無効な場合:

* `/workflows`、ワークフローコマンド、`/workflow-authoring` スキルは利用できません
* `ultracode` キーワードで実行がトリガーされなくなり、`/effort` から **Ultracode** トグルが削除されます

すでに進行中だった実行は続行します。

ワークフローをオフにすると、[ultracode](#let-claude-decide-with-ultracode) も利用できなくなります。ultracode だけを禁止する管理設定はありません。ultracode が[利用可能](https://code.claude.com/docs/ja/model-config.md#when-ultracode-is-available)な環境であれば、ユーザーは `/effort ultracode` でオンにできます。[effort の上限](https://code.claude.com/docs/ja/model-config.md#organization-effort-limits)を設定すると、ultracode がオンのセッションで実行される effort レベルは下がりますが、ultracode がオフになるわけではありません。

## 関連リソース

* [エージェントを並列実行](https://code.claude.com/docs/ja/agents.md)：サブエージェント、エージェントビュー、エージェントチーム、ワークフローを比較
* [カスタムサブエージェントを作成](https://code.claude.com/docs/ja/sub-agents.md)：ワークフローがオーケストレーションするワーカープリミティブ
* [コストを管理](https://code.claude.com/docs/ja/costs.md)：マルチエージェント実行が使用制限にカウントされる方法
