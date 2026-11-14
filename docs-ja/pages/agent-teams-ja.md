> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# Claude Code セッションのチームを調整する

> 複数の Claude Code インスタンスがチームとして連携して動作するように調整し、共有タスク、エージェント間メッセージング、および一元管理を実現します。

> [!WARNING]
>
> エージェントチームは実験的機能であり、デフォルトでは無効になっています。[settings.json](https://code.claude.com/docs/ja/settings.md) または環境に `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1` を設定して有効にしてください。エージェントチームには、セッション再開、タスク調整、シャットダウン動作に関する[既知の制限](#limitations)があります。

エージェントチームを使用すると、複数の Claude Code インスタンスが連携して動作するように調整できます。1 つのセッションがチームリーダーとして機能し、作業を調整し、タスクを割り当て、結果を統合します。チームメンバーは独立して動作し、それぞれ独自のコンテキストウィンドウで動作し、互いに直接通信します。リーダーを経由せずに、任意のチームメンバーと直接対話することもできます。

チームを設定する前に、より軽量なオプションで十分かどうかを確認してください。[Subagents](https://code.claude.com/docs/ja/sub-agents.md) は単一セッション内で動作し、[クロスセッションメッセージング](https://code.claude.com/docs/ja/cross-session-messaging.md) を使用すると Claude は自分で実行するセッション間で検出結果を渡すことができます。

## エージェントチームを使用する場合

エージェントチームは、並列探索が実際の価値を追加するタスクに最も効果的です。完全なシナリオについては、[ユースケース例](#use-case-examples)を参照してください。最も強力なユースケースは以下の通りです。

* **調査とレビュー**：複数のチームメンバーが問題のさまざまな側面を同時に調査し、その後、各自の調査結果を共有して相互に検証できます
* **新しいモジュールまたは機能**：チームメンバーが互いに干渉することなく、それぞれ別々の部分を担当できます
* **競合する仮説でのデバッグ**：チームメンバーが異なる理論を並列でテストし、より迅速に答えに収束できます
* **クロスレイヤー調整**：フロントエンド、バックエンド、テストにまたがる変更で、それぞれ異なるチームメンバーが担当します

エージェントチームは調整オーバーヘッドを追加し、単一セッションよりも大幅に多くのトークンを使用します。チームメンバーが独立して動作できる場合に最も効果的です。順序付きタスク、同じファイルの編集、または多くの依存関係を持つ作業の場合は、単一セッションまたは [subagents](https://code.claude.com/docs/ja/sub-agents.md) がより効果的です。

### subagents との比較

エージェントチームと [subagents](https://code.claude.com/docs/ja/sub-agents.md) の両方を使用すると、作業を並列化できますが、動作方法が異なります。チームなしでメッセージを相互に渡す別々のセッションについては、[クロスセッションメッセージング](https://code.claude.com/docs/ja/cross-session-messaging.md)を参照してください。

![Subagent とエージェントチームのアーキテクチャを比較する図。Subagents はメインエージェントによって生成され、作業を実行し、結果を報告します。エージェントチームは共有タスクリストを通じて調整され、チームメンバーが互いに直接通信します。](https://mintcdn.com/claude-code/nsvRFSDNfpSU5nT7/images/subagents-vs-agent-teams-light.png?fit=max\&auto=format\&n=nsvRFSDNfpSU5nT7\&q=85\&s=2f8db9b4f3705dd3ab931fbe2d96e42a)

Subagents は結果をメインエージェントに報告します。エージェントチームでは、チームメンバーがタスクリストを共有し、作業を要求し、互いに直接通信します。

| | Subagents | エージェントチーム |
| :- | :- | :- |
| **コンテキスト** | 独自のコンテキストウィンドウ。結果は呼び出し元に返される | 独自のコンテキストウィンドウ。完全に独立 |
| **通信** | 呼び出し元に結果を返します。Claude が生成時に[名前を付けた](https://code.claude.com/docs/ja/sub-agents.md#subagent-names)サブエージェントは、[互いにメッセージを送信](https://code.claude.com/docs/ja/sub-agents.md#what-loads-at-startup)することもできます | チームメイトが互いに直接メッセージを送信 |
| **調整** | メインエージェントがすべての作業を管理 | メッセージを通じた自己調整、および [Task ツールを持つエージェント](https://code.claude.com/docs/ja/tools-reference.md#task-tool-availability)のための共有タスクリスト |
| **最適な用途** | 結果のみが重要な焦点を絞ったタスク | 議論と協力が必要な複雑な作業 |
| **トークンコスト** | 低い：結果がメインコンテキストに要約されて返される | 高い：各チームメンバーが個別の Claude インスタンス |

結果を報告する必要がある迅速で焦点を絞ったワーカーが必要な場合は subagents を使用してください。チームメンバーが調査結果を共有し、互いに検証し、独立して調整する必要がある場合は、エージェントチームを使用してください。

## エージェントチームを有効にする

エージェントチームはデフォルトでは無効になっています。`CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS` 環境変数を `1` に設定して有効にしてください。シェル環境または [settings.json](https://code.claude.com/docs/ja/settings.md) を通じて設定できます。

```json settings.json theme={null}
{
  "env": {
    "CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS": "1"
  }
}
```

エージェントチームを有効にすると、通常の委譲も変わります。Claude は [サブエージェントに名前を付ける](https://code.claude.com/docs/ja/sub-agents.md#subagent-names) ことができます。エージェントチームが有効な間、Claude が名前を付けたサブエージェントはチームメイトとして起動するため、リクエストしなくてもチームが形成される可能性があります。詳細については、[Claude がエージェントチームを開始する方法](#how-claude-starts-agent-teams) を参照してください。この動作をオフにするには、[Claude はサブエージェントの代わりにチームメイトを生成する](#claude-spawns-teammates-instead-of-subagents) を参照してください。

チームメイトの生成には、インタラクティブセッションも必要です。`-p` フラグを含む [非インタラクティブモード](https://code.claude.com/docs/ja/headless.md) では、Agent SDK セッションを含めて、Claude はチームメイトを生成せず、Claude が名前を付けたサブエージェントはエージェントチームが有効な場合でも通常の [サブエージェント](https://code.claude.com/docs/ja/sub-agents.md) として実行されます。

## 最初のエージェントチームを開始する

エージェントチームを有効にした後、実行したいタスクとチームメンバーを自然言語で説明してください。Claude がチームメンバーを生成し、プロンプトに基づいて作業を調整します。

この例は、3 つの役割が独立しており、互いに待つことなく問題を探索できるため、うまく機能します。

```text wrap theme={null}
I'm designing a CLI tool that helps developers track TODO comments across
their codebase. Spawn three teammates to explore this from different angles:
one on UX, one on technical architecture, one playing devil's advocate.
```

その後、Claude は [共有タスクリスト](https://code.claude.com/docs/ja/interactive-mode.md#task-list) を作成し、[Task ツールを持つセッション](https://code.claude.com/docs/ja/tools-reference.md#task-tool-availability)内で各視点のチームメンバーを生成し、問題を探索させ、完了時に調査結果を統合します。

Claude は時々、チームを作成する代わりに [サブエージェント](https://code.claude.com/docs/ja/sub-agents.md)を使用することがあります。サブエージェントはチームメンバーと同じエージェントパネルに表示されるため、パネルだけではチームが形成されたことを確認できません。Claude がサブエージェントを生成した場合は、もう一度質問し、明示的にエージェントチームをリクエストしてください。

リーダーのターミナルには、プロンプト入力の下のエージェントパネルにチームメンバーが表示されます。パネルから以下の操作ができます。

* **上下矢印**: チームメンバーを選択する
* **Enter**: 選択したチームメンバーのトランスクリプトを開き、直接メッセージを送信する
* **Escape**: 選択を解除します。チームメンバーのトランスクリプトを表示している間、Escape はそのチームメンバーの現在のターンを中断します

アイドル状態のチームメイトの行は、いずれかのチームメイトまたはサブエージェントがまだ作業中の間、パネルに留まるため、選択してトランスクリプトを確認したり、さらに作業を割り当てたりできます。パネル内のすべてのエージェントがアイドル状態になると、アイドル行は 30 秒後に非表示になり、チームメイトの次のターンで再表示されます。チームメイトは非表示中も実行中で、引き続き指示を送ることができます。

3 人以上のチームメンバーが同時にアイドル状態の場合、最初の 3 行を超える行は、折りたたまれたチームメンバーをカウントする単一の行に折りたたまれます。例えば、5 人がアイドル状態の場合は `2 idle agents` のようになります。それを選択して Enter キーを押すと折りたたまれた行が展開され、Esc キーを押すと再び折りたたまれます。作業中のチームメンバー、失敗したチームメンバー、および表示中のチームメンバーは常に独自の行を保持します。

各チームメンバーを独自の分割ペインに配置したい場合は、[表示モードを選択](#choose-a-display-mode)を参照してください。

## エージェントチームを制御する

リーダーに自然言語で実行したい内容を指示してください。チーム調整、タスク割り当て、および指示に基づいた委任を処理します。

### 表示モードを選択する

エージェントチームは 2 つの表示モードをサポートしています。

* **In-process**：すべてのチームメンバーがメインターミナル内で実行されます。エージェントパネルで上下矢印キーを使用してチームメンバーを選択し、Enter キーを押してそれを表示して、直接メッセージを入力してください。追加のセットアップなしで任意のターミナルで動作します。
* **分割ペイン**：各チームメンバーが独自のペインを取得します。すべてのユーザーの出力を一度に表示でき、ペインをクリックして直接対話できます。tmux または iTerm2 が必要です。

> [!NOTE]
>
> `tmux` には特定のオペレーティングシステムでの既知の制限があり、従来は macOS で最も効果的に動作します。iTerm2 で `tmux -CC` を使用することが、`tmux` への推奨エントリーポイントです。

エージェントチームを[有効化](#enable-agent-teams)した状態で、次の手順に従って各チームメイトに専用のペインを割り当てます。

**1. tmux をインストールするか iTerm2 をセットアップする**

分割ペインモードには、[tmux](https://github.com/tmux/tmux/wiki) または [`it2` CLI](https://github.com/mkusaka/it2) を備えた iTerm2 が必要です。Claude Code を実行する方をセットアップしてください。

* **tmux**：システムのパッケージマネージャーを通じてインストールしてください。プラットフォーム固有の手順については、[tmux wiki](https://github.com/tmux/tmux/wiki/Installing) を参照してください。
* **iTerm2**：[`it2` CLI](https://github.com/mkusaka/it2) をインストールし、**iTerm2 > Settings > General > Magic > Enable Python API** で Python API を有効にしてください。

**2. 分割ペインをオンにする**

[`teammateMode`](https://code.claude.com/docs/ja/settings-reference#teammatemode) 設定を変更するまで、チームメイトは in-process で実行されます。

`~/.claude/settings.json` で `"auto"` に設定してください。

```json theme={null}
{
  "teammateMode": "auto"
}
```

`"auto"` では、tmux または iTerm2 内で Claude Code を実行するとチームメイトが分割ペインで開き、その他のターミナルでは in-process で実行されます。

**3. Claude Code を起動してチームメイトをスポーンする**

tmux 内または iTerm2 で `claude` を実行し、Claude にチームメイトのスポーンを依頼してください。

iTerm2 で `it2` のセットアッププロンプトが表示された場合は、**Install it2 now** を選択すると、iTerm2 ウィンドウでペインが開きます。

Claude Code を tmux でも iTerm2 でもない環境で実行する場合、または iTerm2 ウィンドウでペインが開かない場合は、`teammateMode` を再度変更してください。

* **tmux と iTerm2 の外部**：tmux がインストールされている状態で、`teammateMode` を `"tmux"` に設定してください。ペインは別の tmux セッションで開きます。それらを確認するには、Claude Code プロンプトの `View teammates` 行からコマンドをコピーし、2 つ目のターミナルでそのコマンドを実行してください。
* **iTerm2 ウィンドウでペインが開かない**：`teammateMode` を `"iterm2"` に設定して、iTerm2 独自のペインを使用してください。その場合、チームメイトは `it2` がセットアップされた iTerm2 で Claude Code を実行したときにのみ起動します。

単一セッションに対してモードを設定するには、フラグとして渡してください。

```bash theme={null}
claude --teammate-mode auto
```

`--teammate-mode` フラグは実験的であり、`claude --help` に表示されません。

### チームメンバーとモデルを指定する

Claude はタスクに基づいて生成するチームメンバーの数を決定するか、正確に実行したい内容を指定できます。

```text wrap theme={null}
Spawn 4 teammates to refactor these modules in parallel. Use Sonnet for
each teammate.
```

Claude Code は各チームメンバーのモデルを、以下の最初に適用されるものから選択します。

1. スポーンプロンプトがそのチームメンバーに対して指定するモデル。
2. [サブエージェント定義](#use-subagent-definitions-for-teammates)からスポーンされたチームメンバーの場合、定義の `model`。ここで `inherit` はリーダーのモデルを選択します。
3. [`CLAUDE_CODE_SUBAGENT_MODEL`](https://code.claude.com/docs/ja/model-config#environment-variables)。`inherit` 以外に設定されている場合。
4. リーダーの現在のモデル。

インストールされている [mod](https://code.claude.com/docs/ja/plugins/mods/overview.md) が [`agent.spawn`](https://code.claude.com/docs/ja/plugins/mods/reference#subagents) フックでモデルを設定している場合、Claude Code は最初のソースの代わりにそのモデルを使用します。

[`CLAUDE_CODE_SUBAGENT_MODEL_FORCE=1`](https://code.claude.com/docs/ja/sub-agents#run-every-subagent-on-one-model) を設定した場合、最初の 2 つのソースは適用されません。Claude Code は `CLAUDE_CODE_SUBAGENT_MODEL` が `inherit` 以外に設定されている場合はそこからすべてのチームメンバーのモデルを選択し、それ以外の場合はリーダーの現在のモデルから選択します。Claude Code v2.1.257 以降が必要です。

v2.1.251 より前は、`CLAUDE_CODE_SUBAGENT_MODEL` がこの順序で最初に来ていました。

> [!NOTE]
>
> `teammateDefaultModel` は v2.1.234 で削除されました。Claude Code は残された値を無視します。代わりにプロンプトでモデルを指定してください。

Claude Code は、チームメンバーに対して選択したモデルを、組織の [`availableModels`](https://code.claude.com/docs/ja/model-config#restrict-model-selection) 許可リストに対してチェックします。許可リストが値をブロックすると、Claude Code は別のモデルを代替します。

* **`opus` などのファミリーエイリアス**：Anthropic API および AWS 上の Claude Platform では、Claude Code はチームメンバーを許可リストが許可するそのファミリーの最新バージョンで実行します。プロバイダー固有のモデル ID を持つプロバイダーでは、[代替が動作しない](https://code.claude.com/docs/ja/model-config.md#restrict-model-selection)場合、ブロックされたエイリアスは次の箇条書きに従って他のブロックされた値のようにフォールバックします。
* **プロバイダー固有のモデル ID を持つプロバイダーで代替が動作しないファミリーエイリアス、またはそのファミリーに許可されたバージョンがないもの、またはその他のブロックされた値**：Claude Code はチームメンバーをリーダーのモデルで実行します。`CLAUDE_CODE_SUBAGENT_MODEL` を設定した場合、Claude Code はそのモデルを最初に試し、これらの同じルールの下で実行します。

デフォルトでは、リーダーのモデルで動作するチームメイトはリーダーの [effort レベル](https://code.claude.com/docs/ja/model-config.md#adjust-effort-level)を継承します。分割ペインモードではこれは v2.1.186 から適用されます。それより前のバージョンではリーダーのセッションの effort を分割ペインのチームメイトに渡していませんでした。別のモデルで動作するチームメイトについては、[サブエージェントとチームメイトの effort レベル](https://code.claude.com/docs/ja/model-config.md#effort-level-of-subagents-and-teammates)を参照してください。

### チームメンバーが実装前にプランを立てるようにする

複雑またはリスクの高いタスクの場合、チームメンバーが実装前にプランを立てることができます。リーダーが [plan モード](https://code.claude.com/docs/ja/permission-modes.md#analyze-before-you-edit-with-plan-mode)にある間に Claude がスポーンするチームメンバーも、プランが準備できるまで plan モードで動作します。まずリーダーを plan モードに切り替えてから、チームメンバーを要求してください。

```text wrap theme={null}
Spawn an architect teammate to refactor the authentication module.
```

そのチームメイトがプランを完了すると、リーダーにプラン承認リクエストを送信します。スポーン後にそのチームメイトの権限モードを変更していない場合、Claude Code はリクエストが到着するとすぐにプランを承認し、リーダーがそれをレビューすることはありません。承認されると、チームメイトは plan モードを終了し、実装を開始します。Claude Code はチームメイトにリーダーの現在の[権限モード](#permissions)を渡します。それが plan モードの場合は Manual を渡します。

実行中の in-process チームメイトのセッションを表示している間に [`Shift+Tab`](https://code.claude.com/docs/ja/permission-modes#switch-permission-modes) を押してそのチームメイトを plan モードにした場合、その実行のプランは Claude Code が承認するのではなく、リーダーがレビューします。ユーザーに承認は求められません。リーダーがプランを承認するか、修正のために差し戻します。

### チームメンバーと直接通信する

各チームメンバーは、完全で独立した Claude Code セッションです。任意のチームメンバーに直接メッセージを送信して、追加の指示を与えたり、フォローアップの質問をしたり、アプローチをリダイレクトしたりできます。

* **In-process モード**：エージェントパネルで上下矢印キーを使用してチームメンバーを選択し、Enter キーを押してそのセッションを表示して、メッセージを入力してください。選択したチームメンバーで `x` を押してそれを停止してください。Ctrl+T を押してタスクリストを切り替えてください。
* **分割ペインモード**：チームメンバーのペインをクリックして、セッションと直接対話してください。各チームメンバーは独自のターミナルの完全なビューを持っています。

In-process チームメイトを表示している間、プレーンテキストと[スキル](https://code.claude.com/docs/ja/skills.md)はそのチームメイトに送信され、組み込みコマンドはリーダーのセッションに送信されます。ただし、次の安全策があります。

* `/compact`、`/clear`、`/rewind` はリーダーの会話に作用するため、このビューからいずれかを実行する前に Claude Code が確認を求めます。
* `/model` と `/fast` はチームメイトではなくリーダーのモデルと fast mode を設定するため、このビューからは実行されません。その理由を示す通知が表示されます。

チームメイトのモデルと fast mode は、スポーン時に固定されます。

### タスクを割り当てて要求する

共有タスクリストはチーム全体の作業を調整します。リーダーがタスクを作成し、チームメンバーがそれらを処理します。タスクには 3 つの状態があります。保留中、進行中、完了。タスクは他のタスクに依存することもでき、その場合は依存先のタスクが完了するまでタスクリストでブロック中として表示されます。チームメンバーはブロックされたタスクを自己要求しませんが、ユーザーまたはリーダーは引き続きそのタスクを割り当てることができます。

[Task ツールを持たない](https://code.claude.com/docs/ja/tools-reference.md#task-tool-availability)エージェントは、共有タスクリストの代わりにメッセージを通じて調整します。

リーダーはタスクを明示的に割り当てるか、チームメンバーが自己要求できます。

* **リーダーが割り当て**：リーダーにどのタスクをどのチームメンバーに与えるかを指示してください
* **自己要求**：タスクを完了した後、チームメンバーは独立して次の未割り当て、ブロック解除されたタスクを選択します

タスク要求はファイルロックを使用して、複数のチームメンバーが同時に同じタスクを要求しようとするときの競合状態を防ぎます。

### チームメンバーをシャットダウンする

チームメンバーのセッションを適切に終了するには、名前で参照してください。例えば、researcher という名前のチームメンバーの場合：

```text wrap theme={null}
Ask the researcher teammate to shut down
```

リーダーはシャットダウンリクエストを送信します。チームメンバーは承認して適切に終了するか、説明付きで却下できます。

チームの共有ディレクトリは、セッションが終了すると自動的にクリーンアップされるため、別のクリーンアップステップはありません。削除されるディレクトリと、ディスク上に残るディレクトリについては、[Architecture](#architecture) を参照してください。

### hooks で品質ゲートを実施する

[hooks](https://code.claude.com/docs/ja/hooks.md) を使用して、チームメンバーが作業を完了したときまたはタスクが作成または完了したときのルールを実施してください。

* [`TeammateIdle`](https://code.claude.com/docs/ja/hooks#teammateidle)：チームメンバーがアイドル状態になろうとしているときに実行されます。終了コード 2 でフィードバックを送信し、チームメンバーを動作させ続けてください。
* [`TaskCreated`](https://code.claude.com/docs/ja/hooks#taskcreated)：タスクが作成されているときに実行されます。終了コード 2 で作成を防止し、フィードバックを送信してください。
* [`TaskCompleted`](https://code.claude.com/docs/ja/hooks#taskcompleted)：タスクが完了としてマークされているときに実行されます。終了コード 2 で完了を防止し、フィードバックを送信してください。

## エージェントチームの仕組み

このセクションでは、エージェントチームの背後にあるアーキテクチャと仕組みについて説明します。使い始めたい場合は、上記の[エージェントチームを制御する](#control-your-agent-team)を参照してください。

### Claude がエージェントチームを開始する方法

チームを開始するには、Claude にチームメイトを依頼します。エージェントチームが有効な状態で、Claude が [`name`](https://code.claude.com/docs/ja/sub-agents#subagent-names) を指定して [Agent ツール](https://code.claude.com/docs/ja/tools-reference.md)を呼び出すと、Claude はチームメイトを起動します。ただし、その呼び出しが[フォーク](https://code.claude.com/docs/ja/sub-agents.md#fork-the-current-conversation)である場合や、呼び出し自体に `isolation` を渡している場合は除きます。Claude Code は起動の確認を求めません。

Claude は、後でメッセージを送れるように、通常のサブエージェントにも自ら名前を付けます。これらの呼び出しにも同じルールが適用されるため、ユーザーがチームを依頼していなくてもチームが形成されることがあります。チームではなくサブエージェントを使いたい場合は、[エージェントチームをオフにしてください](#claude-spawns-teammates-instead-of-subagents)。

### アーキテクチャ

エージェントチームは次の要素で構成されます。

| コンポーネント | 役割 |
| :- | :- |
| **チームリーダー** | チームメイトを生成し、作業を調整するメインの Claude Code セッション |
| **チームメイト** | それぞれ割り当てられたタスクに取り組む個別の Claude Code インスタンス |
| **タスクリスト** | チームメイトが引き受けて完了させる作業項目の共有リスト |
| **メールボックス** | エージェント間の通信のためのメッセージングシステム |

各エージェントのメールボックスは、`~/.claude/teams/{team-name}/inboxes/{agent-name}.json` にある JSON ファイルです。Claude Code はメールボックスファイルを読み込む際に、すべてのエントリを検証します。メッセージ形式に一致しないエントリはエラーとして報告され、ファイルから削除されます。有効なメッセージは引き続き配信されます。

Claude Code は、受信者のメールボックスファイルへの書き込みが成功した場合にのみ、メッセージを送信済みとして報告します。これは、メッセージがプレーンテキストであっても、プラン承認やシャットダウン要求などの構造化プロトコルメッセージであっても同様です。ディスクがいっぱいである、メールボックスディレクトリに書き込めないなどの理由で書き込みが失敗した場合、送信側のエージェントはエラーを受け取り、何も送信されません。エラーメッセージと復旧手順については、[チームメイトの受信箱への書き込みに失敗した場合](https://code.claude.com/docs/ja/errors.md#failed-to-write-to-a-teammate-inbox)を参照してください。

Claude Code はタスクの依存関係を自動的に管理します。他のタスクが依存しているタスクをチームメイトが完了すると、ユーザーが何も操作しなくても、依存しているタスクのブロックが解除されます。

チームとタスクは、セッションから派生した名前でローカルに保存されます。名前は `session-` の後にセッション ID の最初の 8 文字が続く形式です。

* **チーム設定**: `~/.claude/teams/{team-name}/config.json`。Claude Code はセッション終了時にチーム設定ディレクトリを削除します。
* **タスクリスト**: `~/.claude/tasks/{team-name}/`。このディレクトリはセッション終了後もディスク上に残ります。[Claude Code がこれを保持する期間](https://code.claude.com/docs/ja/claude-directory.md#cleaned-up-automatically)を変更するには、[`cleanupPeriodDays`](https://code.claude.com/docs/ja/settings-reference#cleanupperioddays) を設定してください。

Claude Code は、セッション開始時にこれらの両方を自動的に生成し、チームメイトの参加、アイドル状態への移行、離脱に応じて更新します。

チーム設定にはセッション ID や tmux ペイン ID などのランタイム状態が保持されているため、手動で編集したり事前に作成したりしないでください。変更内容は次の状態更新時に上書きされます。

再利用可能なチームメイトの役割を定義するには、代わりに[サブエージェント定義](#use-subagent-definitions-for-teammates)を使用してください。

チーム設定には、各メンバーの名前とエージェント ID を含む `members` 配列が含まれています。リーダーのエントリには、常にエージェントタイプ `team-lead` が付きます。チームメイトのエントリには、リーダーが生成時に指定したエージェントタイプが付きます。これは[組み込みタイプ](https://code.claude.com/docs/ja/sub-agents.md#built-in-subagents)の場合も[サブエージェント定義](#use-subagent-definitions-for-teammates)の場合もあり、リーダーが何も指定しなかった場合はこのフィールドは省略されます。チームメイトはこのファイルを読み取って、他のチームメンバーを把握できます。

チーム設定に相当するプロジェクトレベルの設定はありません。プロジェクトディレクトリ内の `.claude/teams/teams.json` のようなファイルは設定として認識されず、Claude は通常のファイルとして扱います。

### チームメイトにサブエージェント定義を使用する

どちらの表示モードでチームメイトを生成する場合でも、プロジェクト、ユーザー、管理、またはプラグインの[サブエージェントスコープ](https://code.claude.com/docs/ja/sub-agents.md#choose-the-subagent-scope)にある[サブエージェント](https://code.claude.com/docs/ja/sub-agents.md)タイプを参照できます。これにより、security-reviewer や test-runner などの役割を一度定義するだけで、委任されたサブエージェントとしても、エージェントチームのチームメイトとしても再利用できます。

サブエージェント定義を使用するには、Claude にチームメイトの生成を依頼する際にその名前を指定します。

```text wrap theme={null}
Spawn a teammate using the security-reviewer agent type to audit the auth module.
```

Claude Code は指定されたサブエージェント定義を読み込み、その次の部分をチームメイトに適用します。ある部分がチームメイトの[表示モード](#choose-a-display-mode)に依存する場合は、その項目に記載しています。

* **`tools`**: Claude Code は、チームメイトが使用できるツールを定義の `tools` リストにあるツールに限定します。インプロセスのチームメイトの場合、Claude Code はそのリストに `SendMessage` を追加し、[Task ツールを持つセッション](https://code.claude.com/docs/ja/tools-reference.md#task-tool-availability)では `TaskCreate`、`TaskGet`、`TaskList`、`TaskUpdate` も追加します。
* **`model`**: 生成プロンプトでモデルが指定されていない場合、Claude Code はどちらの表示モードでも定義の `model` を使用します。[Claude Code がチームメイトのモデルを選択する方法](#specify-teammates-and-models)を参照してください。
* **`disallowedTools`**: インプロセスのチームメイトの場合、Claude Code は定義の `disallowedTools` にあるツールをチームメイトのツールセットから削除します。`SendMessage` と Claude Code が追加する Task ツールは、リストに含まれていても引き続き使用できます。
* **`effort`**: インプロセスのチームメイトの場合、Claude Code は[フロントマターの effort ルール](https://code.claude.com/docs/ja/model-config.md#set-the-effort-level)に従って定義の [`effort`](https://code.claude.com/docs/ja/sub-agents#supported-frontmatter-fields) を適用します。
* **`autoCompactWindow`**: インプロセスのチームメイトの場合、Claude Code は[このフィールドのルール](https://code.claude.com/docs/ja/sub-agents.md#subagent-auto-compact-window)に従って定義の [`autoCompactWindow`](https://code.claude.com/docs/ja/sub-agents#supported-frontmatter-fields) を適用します。分割ペインのチームメイトはこのフィールドを無視します。Claude Code v2.1.296 以降が必要です。
* **本文**: インプロセスのチームメイトの場合、Claude Code は定義の本文を追加の指示としてデフォルトのシステムプロンプトに追記します。分割ペインのチームメイトの場合、Claude Code はデフォルトのシステムプロンプトの代わりに本文を使用します。
* **`skills`**: Claude Code は、どちらの表示モードでも定義の `skills` をチームメイトに適用しません。チームメイトはプロジェクト設定とユーザー設定からスキルを読み込みます。
* **`mcpServers`**: 分割ペインのチームメイトの場合、Claude Code は[このフィールドのルール](https://code.claude.com/docs/ja/sub-agents.md#scope-mcp-servers-to-a-subagent)に従って定義の `mcpServers` を適用します。このルールは `--agent` で開始したセッションにも適用されます。インプロセスのチームメイトはこのフィールドを無視し、プロジェクト設定とユーザー設定から MCP サーバーを読み込みます。

Claude がすでに実行されていないインプロセスのチームメイトにメッセージを送ると、Claude Code は同じセッション内でそのチームメイトを復帰させ、保存されている会話があれば復元し、そのメッセージを次のプロンプトとして渡します。セッションを再開した後は、[再開に関する制限](#limitations)により、チームメイトはこの方法では復帰しません。

復帰させたチームメイトについて、Claude Code は、プロジェクトの `.claude/agents/` ディレクトリまたは `--add-dir` ディレクトリから取得した定義を、[エージェントファイルがあるフォルダーを信頼](https://code.claude.com/docs/ja/permissions.md#what-runs-before-you-trust-a-folder)している場合にのみ再適用します。親フォルダーを信頼していても対象にはなりません。信頼するまでは、チームメイトは定義のツールや指示を一切持たずに復帰し、Claude Code がすべてのインプロセスのチームメイトに追加するツールのみを保持します。通知テキストについては、[チームメイトのエージェント定義が復元されなかった場合](https://code.claude.com/docs/ja/errors.md#teammate-agent-definition-not-restored)を参照してください。

### 権限

実行中のチームメイトの権限モードを切り替えるには、[`Shift+Tab`](https://code.claude.com/docs/ja/permission-modes#switch-permission-modes) を押します。ただし、インプロセスのチームメイトは代わりにリーダーのモードで実行される場合があります。分割ペインのチームメイトの場合は、そのペインで押します。[インプロセス](#choose-a-display-mode)のチームメイトの場合は、[そのセッションを表示](#talk-to-teammates-directly)している間に押すと、チームメイトは次のターンを開始する際にモードを確認します。

> [!NOTE]
>
> [plan モード](#have-teammates-plan-before-implementing)ではないインプロセスのチームメイトは、リーダーが [`acceptEdits`](https://code.claude.com/docs/ja/permission-modes#auto-approve-file-edits-with-acceptedits-mode)、[`auto`](https://code.claude.com/docs/ja/permission-modes#eliminate-prompts-with-auto-mode)、または [`bypassPermissions`](https://code.claude.com/docs/ja/permission-modes#skip-all-checks-with-bypasspermissions-mode) モードである間、リーダーのモードで実行されます。チームメイトを Manual に切り替えても、ステータスバーに Manual と表示されていても、この動作は変わりません。
>
> 編集前に確認を求めるようにするには、エージェントパネルの `main` 行で Enter を押し、リーダーも Manual モードに切り替えてください。これにより、リーダーも確認を求めるようになり、Manual モードの他のチームメイトも同様に確認を求めます。

生成時にチームメイトごとの権限モードを設定することはできません。新しいチームメイトはリーダーのモードで開始されます。これには、`--dangerously-skip-permissions` によってオンになる `bypassPermissions` モードも含まれます。リーダーが [`dontAsk` モード](https://code.claude.com/docs/ja/permission-modes#allow-only-pre-approved-tools-with-dontask-mode)の場合、チームメイトは代わりに [Manual モード](https://code.claude.com/docs/ja/permission-modes.md#available-modes)で開始されます。リーダーが Manual モードまたは `dontAsk` モードである分割ペインのチームメイトの場合、これには Claude Code v2.1.317 以降が必要です。

[インプロセス](#choose-a-display-mode)のチームメイトはリーダーの現在の許可ルールと拒否ルールの下で実行されるため、[`--disallowedTools`](https://code.claude.com/docs/ja/cli-reference#cli-flags)、`--tools`、`--allowedTools` はすべてこのチームメイトに適用されます。分割ペインのチームメイトの場合は、フラグごとに確認してください。

* **`--disallowedTools` と `--tools`**: チームメイトは、リーダーのコマンドラインの拒否ルールとツールリストを持った状態で開始されます。Claude Code v2.1.309 以降が必要です。
* **`--allowedTools`**: Claude Code はこのフラグを分割ペインのチームメイトに渡さないため、このフラグだけで許可したアクションは、分割ペインのチームメイトでは事前承認されません。これらのアクションを事前に承認するには、リーダーを開始する際に [`--settings`](https://code.claude.com/docs/ja/settings#change-a-setting-for-one-session) の `permissions.allow` にルールを記述します。たとえば、シェルで `claude --settings '{"permissions":{"allow":["Bash(npm *)"]}}'` を実行します。このルールは、そのセッションのリーダーと各分割ペインのチームメイトに適用されます。

チームメイトの権限プロンプトはリーダーのセッションに表示されるため、そこでユーザー自身が承認してください。[チームメイトのプラン](#have-teammates-plan-before-implementing)を承認する必要はありません。

#### エージェント間のメッセージ

あるエージェントが `SendMessage` を介して別のエージェントにメッセージを送ると、Claude Code は受信側のエージェントに、そのメッセージがユーザーからではなく別の Claude セッションから来たものであることを伝えます。チームメイトはユーザーに代わって権限プロンプトを承認したり同意を与えたりすることはできず、アクションを拒否されたチームメイトがチェックを回避するためにそのアクションを別のチームメイトに中継することもできません。チームの外部にある[ユーザーの他の Claude Code セッションのいずれか](https://code.claude.com/docs/ja/cross-session-messaging.md#how-a-session-treats-an-incoming-message)から届いたメッセージにも、同じルールが適用されます。

[auto モード](https://code.claude.com/docs/ja/permission-modes.md#eliminate-prompts-with-auto-mode)では、分類器はエージェント間のメッセージに 2 つのチェックを適用します。

* 別のエージェントから中継された承認の主張を、ユーザーからの確認ではなく、信頼できない入力として扱います。
* プレーンなメッセージであっても、シャットダウン要求やプラン承認の応答などの構造化プロトコルメッセージであっても、Claude Code が配信する前に各メッセージを確認します。ブロックされたメッセージが受信者に届くことはありません。

### コンテキストと通信

各チームメイトは独自のコンテキストウィンドウを持ちます。生成されると、チームメイトは通常のセッションと同じプロジェクトコンテキスト（CLAUDE.md、MCP サーバー、スキル）を読み込みます。[`--setting-sources`](https://code.claude.com/docs/ja/cli-reference#cli-flags) を指定してリーダーを開始した場合、チームメイトも同じ制限されたソースのリストから読み込みます。v2.1.281 より前は、[分割ペイン](#choose-a-display-mode)のチームメイトはすべての設定ソースを読み込んでいました。

チームメイトはリーダーから生成プロンプトも受け取ります。リーダーの会話履歴は引き継がれません。

**チームメイトが情報を共有する方法:**

* **メッセージの自動配信**: チームメイトがメッセージを送信すると、受信者に自動的に配信されます。リーダーが更新をポーリングする必要はありません。
* **アイドル通知**: チームメイトは作業を終えて停止すると、自動的にリーダーに通知し、その通知に最終的な回答を含めます。API エラーでターンが終了したチームメイトは、失敗したことをリーダーに通知し、エラーテキストを含めます。
* **共有タスクリスト**: [Task ツールを持つエージェント](https://code.claude.com/docs/ja/tools-reference.md#task-tool-availability)は、タスクのステータスを確認し、引き受け可能な作業を引き受けることができます。
* **チームメイトへのメッセージ送信**: 特定のチームメイト 1 人に名前を指定してメッセージを送信します。全員に届けるには、受信者ごとに 1 通ずつメッセージを送信します。

リーダーはチームメイトを生成する際に全員に名前を割り当て、どのチームメイトもその名前で他のチームメイトにメッセージを送ることができます。後のプロンプトで参照できる予測可能な名前にするには、生成の指示の中で各チームメイトを何と呼ぶかをリーダーに伝えてください。

### トークン使用量

エージェントチームは、単一のセッションよりも大幅に多くのトークンを使用します。各チームメイトは独自のコンテキストウィンドウを持ち、トークン使用量はアクティブなチームメイトの数に比例して増加します。調査、レビュー、新機能の開発では、通常、追加のトークンに見合う価値があります。日常的なタスクでは、単一のセッションの方が費用対効果に優れています。使用量のガイダンスについては、[エージェントチームのトークンコスト](https://code.claude.com/docs/ja/costs.md#agent-team-token-costs)を参照してください。

インプロセスのチームメイトのリクエストはメインの会話の[キャッシュ TTL バケット](https://code.claude.com/docs/ja/prompt-caching.md#which-ttl-each-request-gets)の対象外となるため、Claude サブスクリプションを利用している場合も含め、そのキャッシュはデフォルトで 5 分間保持されます。1 時間保持するには、[`subagentPromptCacheTtl`](https://code.claude.com/docs/ja/settings-reference#subagentpromptcachettl) を `1h` に設定してください。API では、1 時間のキャッシュ書き込みはより高い料金で課金されます。

## ユースケース例

これらの例は、エージェントチームが並列探索が価値を追加するタスクをどのように処理するかを示しています。

### 並列コードレビューを実行する

単一のレビュアーは一度に 1 つのタイプの問題に傾く傾向があります。レビュー基準を独立したドメインに分割することで、セキュリティ、パフォーマンス、およびテストカバレッジがすべて同時に徹底的に注意を受けます。プロンプトは各チームメンバーに異なるレンズを割り当てるため、重複しません。

```text wrap theme={null}
Spawn three teammates to review PR #142:
- One focused on security implications
- One checking performance impact
- One validating test coverage
Have them each review and report findings.
```

各レビュアーは同じ PR から動作しますが、異なるフィルターを適用します。リーダーは完了後、3 つすべてにわたって調査結果を統合します。

### 競合する仮説で調査する

根本原因が不明な場合、単一のエージェントは 1 つのもっともらしい説明を見つけて停止する傾向があります。プロンプトはチームメンバーを明示的に敵対的にすることでこれと戦います。各チームメンバーの仕事は、独自の理論を調査するだけでなく、他の理論に異議を唱えることです。

```text wrap theme={null}
Users report the app exits after one message instead of staying connected.
Spawn 5 agent teammates to investigate different hypotheses. Have them talk to
each other to try to disprove each other's theories, like a scientific
debate. Update the findings doc with whatever consensus emerges.
```

議論構造はここでの重要なメカニズムです。順序付き調査はアンカリングに悩まされます。1 つの理論が探索されると、その後の調査はそれに向かってバイアスされます。

複数の独立した調査官が互いに積極的に反証しようとしている場合、生き残る理論は実際の根本原因である可能性がはるかに高くなります。

## ベストプラクティス

### チームメンバーに十分なコンテキストを提供する

チームメンバーはプロジェクトコンテキスト（CLAUDE.md、MCP servers、および skills を含む）を自動的にロードしますが、リーダーの会話履歴は継承しません。詳細については、[コンテキストと通信](#context-and-communication)を参照してください。生成プロンプトにタスク固有の詳細を含めてください。

```text wrap theme={null}
Spawn a security reviewer teammate with the prompt: "Review the authentication module
at src/auth/ for security vulnerabilities. Focus on token handling, session
management, and input validation. The app uses JWT tokens stored in
httpOnly cookies. Report any issues with severity ratings."
```

### 適切なチームサイズを選択する

チームメンバーの数に厳しい制限はありませんが、実際の制約が適用されます。

* **トークンコストは線形にスケール**：各チームメンバーは独自のコンテキストウィンドウを持ち、独立してトークンを消費します。詳細については、[エージェントチームトークンコスト](https://code.claude.com/docs/ja/costs.md#agent-team-token-costs)を参照してください。
* **調整オーバーヘッドが増加**：より多くのチームメンバーは、より多くの通信、タスク調整、および競合の可能性を意味します
* **収穫逓減**：ある時点を超えると、追加のチームメンバーは作業を比例的に高速化しません

ほとんどのワークフローでは、3～5 人のチームメンバーで開始してください。これは並列作業と管理可能な調整のバランスを取ります。15 個の独立したタスクがある場合、3 人のチームメンバーが良い出発点です。

チームメンバーが同時に動作することから本当に作業が利益を得る場合にのみスケールアップしてください。3 人の焦点を絞ったチームメンバーは、5 人の散らばったチームメンバーよりもしばしば優れています。

### タスクを適切にサイズ設定する

* **小さすぎる**：調整オーバーヘッドが利益を超える
* **大きすぎる**：チームメンバーはチェックインなしで長時間動作し、無駄な努力のリスクが増加します
* **ちょうど良い**：関数、テストファイル、またはレビューなど、明確な成果物を生成する自己完結型ユニット

> [!TIP]
>
> リーダーは作業をタスクに分割し、チームメンバーに自動的に割り当てます。十分なタスクを作成していない場合は、作業をより小さな部分に分割するよう指示してください。チームメンバーあたり 5～6 個のタスクを持つことで、誰もが生産的に保たれ、誰かが立ち往生した場合、リーダーが作業を再割り当てできます。

### チームメンバーが完了するまで待つ

時々、リーダーはチームメンバーを待つ代わりに、タスク自体を実装し始めます。これに気付いた場合は、以下を実行してください。

```text wrap theme={null}
Wait for your teammates to complete their tasks before proceeding
```

### 調査とレビューから開始する

エージェントチームが初めての場合は、明確な境界があり、コードを書く必要がないタスクから開始してください。PR をレビューする、ライブラリを調査する、またはバグを調査します。これらのタスクは、並列実装に伴う調整の課題なしに、並列探索の価値を示しています。

### ファイルの競合を回避する

2 人のチームメンバーが同じファイルを編集すると、上書きが発生します。作業を分割して、各チームメンバーが異なるファイルセットを所有するようにしてください。

### 監視と操舵

チームメンバーの進捗をチェックし、機能していないアプローチをリダイレクトし、調査結果が入ってくるにつれて統合してください。チームを長時間無人で実行させると、無駄な努力のリスクが増加します。

## トラブルシューティング

### チームメンバーが表示されない

Claude にチームメンバーを生成するよう指示した後、チームメンバーが表示されない場合は、以下を実行してください。

* In-process モードでは、チームメンバーはプロンプト入力の下のエージェントパネルに表示されます。上下矢印キーを使用して 1 つを選択し、Enter キーを押して表示してください。
* アイドル状態で消えたチームメンバー行は停止されていなく、非表示になっています。アイドル行はパネル全体がアイドル状態になってから 30 秒後に非表示になり、チームメンバーの次のターンで再表示されます。3 人以上のチームメンバーがアイドル状態の場合、余剰行は `N idle agents` という 1 つの行に折りたたまれ、Enter キーで展開されます。チームメンバーに名前でメッセージを送信して、非表示の行を戻してください。
* Claude に提供したタスクがチームを必要とするほど十分複雑であることを確認してください。Claude はタスクに基づいてチームメンバーを生成するかどうかを決定します。
* 明示的に分割ペインをリクエストした場合は、tmux がインストールされ、PATH で利用可能であることを確認してください。
  ```bash theme={null}
  which tmux
  ```
* iTerm2 の場合、`it2` CLI がインストールされ、Python API が iTerm2 の設定で有効になっていることを確認してください。

### Claude がサブエージェントの代わりにチームメンバーを生成する

エージェントチームが有効な場合、Claude がリーダーのセッションで名前を付けたサブエージェントはチームメンバーとして起動します。Claude は[独自にサブエージェントに名前を付けることができる](#how-claude-starts-agent-teams)ため、これはチームワークとしてフレーム化したことのない委任中に発生する可能性があります。

名前付きサブエージェントをサブエージェントとして再度起動するには、`CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS` を `0` に設定してエージェントチームをオフにしてください。

```json settings.json theme={null}
{
  "env": {
    "CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS": "0"
  }
}
```

新しいセッションを開始する必要はありません。Claude Code は、保存時に実行中のセッションに設定ファイルの `env` 値を再適用し、Claude がサブエージェントを生成するたびに変数を再読み込みするため、次に Claude が名前を付けたサブエージェントはサブエージェントとして起動します。

ユーザー `settings.json` で変数を `0` に設定すると、シェルエクスポートがオーバーライドされます。他の設定ソースはエージェントチームを有効にできます。

* **優先度の高い設定ファイル**：プロジェクト設定、ローカル設定、および `--settings` ペイロードはユーザー設定の後に適用されるため、それらのいずれかで変数を `1` に設定する `env` エントリが優先されます。[設定の優先度](https://code.claude.com/docs/ja/settings.md#settings-precedence)を参照してください。
* **マネージド設定**：[マネージド設定](https://code.claude.com/docs/ja/server-managed-settings.md)は他のすべてのソースの後に適用されます。組織がそこでエージェントチームを有効にしている場合は、管理者にマネージド値の変更を依頼してください。

変更後、Claude はまだサブエージェントに名前を付ける可能性があり、その名前は [`SendMessage` アドレス](https://code.claude.com/docs/ja/sub-agents#resume-subagents)として機能し続けます。Claude は各サブエージェントが完了したときにその結果を受け取ります。

### 権限プロンプトが多すぎる

チームメンバーの権限リクエストはリーダーにバブルアップし、摩擦を生じさせる可能性があります。チームメンバーを生成する前に、[権限設定](https://code.claude.com/docs/ja/permissions.md)で一般的な操作を事前承認して、中断を減らしてください。

### エージェントが早期に停止する

チームメンバーはエラーが発生した後、回復する代わりに停止する可能性があります。In-process モードでエージェントパネルでチームメンバーを選択して Enter キーを押すか、分割モードでペインをクリックして出力を確認し、以下のいずれかを実行してください。

* 直接追加の指示を与える
* 作業を続行するために置き換えチームメンバーを生成する

リーダーまたは別のチームメンバーからのメッセージは、失敗した API リクエストの再試行を待機している In-process チームメンバーをウェイクアップするため、完全な再試行遅延を待つ代わりに、すぐに再試行されます。

リーダーも早期に停止する可能性があり、すべてのタスクが実際に完了する前にチームが完了したと判断します。これが発生した場合は、続行するよう指示してください。

### 孤立した tmux セッション

チームが終了した後、tmux セッションが持続する場合、完全にクリーンアップされていない可能性があります。セッションをリストして、チームによって作成されたセッションを終了してください。

```bash theme={null}
tmux ls
tmux kill-session -t <session-name>
```

## 制限事項

Agent teams は実験的な機能です。現在の制限事項は以下の通りです。

* **インプロセス teammates でのセッション再開非対応**: `/resume` と `/rewind` はインプロセス teammates を復元しません。セッションを再開した後、lead が存在しなくなった teammates にメッセージを送ろうとする可能性があります。この場合、lead に新しい teammates をスポーンするよう指示してください。
* **タスク状態が遅延することがある**: teammates は時々タスク完了のマークに失敗し、これが依存タスクをブロックします。タスクが止まっているように見える場合、実際に作業が完了しているかどうかを確認し、タスク状態を手動で更新するか、lead に teammate に促すよう指示してください。
* **シャットダウンが遅い可能性がある**: teammates は現在のリクエストまたはツール呼び出しを完了してからシャットダウンするため、時間がかかる可能性があります。
* **セッションごとに 1 つのチーム**: セッションは正確に 1 つのチームを持ち、そのセッションにスコープされています。追加の名前付きチームを作成したり、セッション間でチームを共有したりすることはできません。
* **ネストされたチーム非対応**: teammates は独自の teammates をスポーンできません。lead のみがチームを管理できます。
* **インプロセスのチームメイトからのバックグラウンドサブエージェント非対応**: インプロセスのチームメイト自身のサブエージェントはフォアグラウンドで実行されます。これはチームメイトのバックグラウンド作業がチームリーダーのプロセスより長く存続できないためです。Claude Code は、チームメイトが `background: true` を設定する定義を持つサブエージェントをスポーンする場合、エラーを返します。チームメイトの `run_in_background: true` リクエストも失敗し、エラーが発生するか、フォアグラウンドで静かに実行されます。メイン会話から起動されたサブエージェントは[バックグラウンドのデフォルト](https://code.claude.com/docs/ja/sub-agents.md#run-subagents-in-foreground-or-background)に従います。
* **Lead は固定**: メインセッションはその存続期間中、lead です。teammate を lead に昇格させたり、リーダーシップを譲渡したりすることはできません。
* **スポーン時のチームメイトごとの権限モード設定非対応**: チームメイトは[権限](#permissions)で説明されている権限モードで開始します。
* **分割ペインは tmux または iTerm2 が必要**: デフォルトのインプロセスモードはすべてのターミナルで機能します。

## 次のステップ

並列作業と委任の関連アプローチを探索してください。

* **軽量委任**：[subagents](https://code.claude.com/docs/ja/sub-agents.md) はセッション内で調査または検証用のヘルパーエージェントを生成し、エージェント間調整が必要ないタスクに適しています
* **セッション間のメッセージング**：[クロスセッションメッセージング](https://code.claude.com/docs/ja/cross-session-messaging.md) により、Claude は自分で実行するセッション間で検出結果を渡すことができます
* **手動並列セッション**：[Git worktrees](https://code.claude.com/docs/ja/worktrees.md) を使用すると、自動チーム調整なしで複数の Claude Code セッションを自分で実行できます
