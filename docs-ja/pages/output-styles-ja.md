> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# 出力スタイル

> ソフトウェアエンジニアリング以外の用途に合わせて Claude Code を適応させる

出力スタイルは Claude がどのように応答するかを変更し、Claude が何を知っているかは変更しません。これらはすべての応答に対して Claude のロール、トーン、出力形式を設定します。毎回同じ声や形式で再度プロンプトを入力し続ける場合、または Claude がソフトウェアエンジニア以外として機能することを望む場合に使用します。

カスタム出力スタイルは Claude に独自の指示を提供し、Claude Code の組み込みソフトウェアエンジニアリング指示を保持するかどうかを選択できます。Claude がコミュニケーション方法を変更しているがまだコーディングしている場合（常に図で答えるなど）は保持します。Claude がソフトウェアエンジニアリングをまったく行っていない場合（執筆アシスタントやデータアナリストなど）は除外します。

プロジェクト、規約、またはコードベースに関する指示については、代わりに [CLAUDE.md](/docs/ja/memory) を使用してください。

<h2 id="built-in-output-styles">
  組み込み出力スタイル
</h2>

Claude Code の **Default** 出力スタイルは標準的な指示セットであり、ソフトウェアエンジニアリングタスクを効率的に完了するのに役立つように設計されています。

4 つの追加の組み込み出力スタイルがあります。

* **Proactive**: Claude は即座に実行し、日常的な決定で一時停止する代わりに合理的な仮定を立て、計画よりもアクションを優先します。これは [オートモード](/docs/ja/permission-modes#eliminate-prompts-with-auto-mode) が適用するより強力な自律実行ガイダンスであり、権限モードを変更せずに機能するため、権限モードは依然として何が実行されるかを決定し、確認を求めません。

* **Concise**: Claude は結果を最初に示し、前置きと説明をスキップし、デフォルトスタイルと同じくらい徹底的にエンジニアリング作業を行いながら、デフォルトでは応答を短く保ちます。説明や詳細情報を求めると、Claude は完全に答えます。Claude は常にエラーレポート、セキュリティ警告、および破壊的なアクションの確認の完全な内容を保持します。Claude Code v2.1.237 以降が必要です。

* **Explanatory**: ソフトウェアエンジニアリングタスクの完了を支援しながら、教育的な「Insights」を提供します。実装の選択肢とコードベースのパターンを理解するのに役立ちます。

* **Learning**: 協調的な学習型モードです。Claude はコーディング中に「Insights」を共有するだけでなく、小さな戦略的なコードの一部を自分で実装するよう求めます。Claude Code はコード内に `TODO(human)` マーカーを追加して、実装するべき箇所を示します。

<h2 id="change-your-output-style">
  出力スタイルを変更する
</h2>

以下のいずれかの方法でスタイルを選択します。

* **Terminal**: `/config` を実行し、**Output style** を選択してメニューからスタイルを選択します。Claude Code は選択内容を [ローカルプロジェクトレベル](/docs/ja/settings) の `.claude/settings.local.json` に保存します。
* **VS Code extension**: [コマンドメニュー](/docs/ja/vs-code#use-the-prompt-box) を `/` で開き、**Output styles** を選択してスタイルを選択します。カスタムスタイルも含まれます。Claude Code は選択内容を `.claude/settings.local.json` に保存します。これはターミナルメニューが書き込むのと同じファイルです。Claude Code v2.1.257 以降が必要です。
* **Desktop app**: 設定ファイル（例えば `.claude/settings.local.json`、ターミナルメニューが書き込むファイル）の `outputStyle` フィールドを設定します。`/config` を実行すると、Claude Code は [**Settings > Claude Code**](/docs/ja/desktop#what%E2%80%99s-not-available-in-desktop) を開きます。メニューではなく設定画面が開きます。

<Note>スタンドアロン `/output-style` コマンドは v2.1.73 で廃止され、v2.1.91 で削除されました。`/config` を使用するか、`outputStyle` 設定を直接編集してください。</Note>

メニューなしでスタイルを設定するには、設定ファイルの `outputStyle` フィールドを直接編集します。

```json theme={null}
{
  "outputStyle": "Explanatory"
}
```

セッション中にスタイルを切り替えると、Claude は次のメッセージから新しいスタイルを使用します。最初のメッセージのプロンプトキャッシングのコストについては、[出力スタイルの変更](/docs/ja/prompt-caching#changing-output-style) を参照してください。v2.1.251 より前は、新しいスタイルは `/clear` を実行するか新しいセッションを開始した後にのみ適用されました。

<h2 id="create-a-custom-output-style">
  カスタム出力スタイルを作成する
</h2>

カスタム出力スタイルは Markdown ファイルです。メタデータ用の frontmatter、その後に Claude の指示が続きます。

VS Code 拡張機能では、手書きではなく [**Output styles** メニュー](/docs/ja/vs-code#use-the-prompt-box) からファイルを作成することもできます。これには Claude Code v2.1.261 以降が必要です。

<Steps>
  <Step title="Markdown ファイルを作成する">
    3 つのレベルのいずれかに保存します。ファイル名がスタイル名になります。frontmatter で `name` を設定しない限り。

    * ユーザー: `~/.claude/output-styles`
    * プロジェクト: `.claude/output-styles`
    * 管理ポリシー: [管理設定ディレクトリ](/docs/ja/managed-settings#delivery-mechanisms) 内の `.claude/output-styles`

    プロジェクト出力スタイルは、作業ディレクトリとリポジトリルートの間のすべての `.claude/output-styles/` から読み込まれます。これらのネストされたディレクトリの複数が同じ名前のスタイルを定義する場合、Claude Code は作業ディレクトリに最も近いものを使用します。
  </Step>

  <Step title="Frontmatter と指示を追加する">
    Claude Code のソフトウェアエンジニアリング指示を保持するかどうかを決定します。Claude がコミュニケーション方法を変更しているがまだ同じ方法でコーディングしたい場合は `keep-coding-instructions: true` を設定します。Claude がソフトウェアエンジニアリングを行わない場合は除外します。

    この例は Claude のコーディング動作を保持しながら、すべての説明を図で始めます。

    ```markdown theme={null}
    ---
    name: Diagrams first
    description: Lead every explanation with a diagram
    keep-coding-instructions: true
    ---

    When explaining code, architecture, or data flow, start with a Mermaid diagram showing the structure, then explain in prose.

    ## Diagram conventions

    Use `flowchart TD` for control flow and `sequenceDiagram` for request paths. Keep diagrams under 15 nodes.
    ```
  </Step>

  <Step title="スタイルに切り替える">
    ターミナルで `/config` を実行し、**Output style** でスタイルを選択します。Claude は次のメッセージから新しいスタイルを使用します。ターミナルでは、Claude Code はスタイルファイルを起動時に読み込むため、実行中のセッション中に作成または編集した場合は、Claude Code を再起動して変更を反映させてください。
  </Step>
</Steps>

[プラグイン](/docs/ja/plugins-reference) は `output-styles/` ディレクトリで出力スタイルを配布することもできます。

<h3 id="frontmatter">
  Frontmatter
</h3>

出力スタイルファイルは、これらの frontmatter フィールドをサポートしています。

| Frontmatter                | 目的                                                                                                                                                   | デフォルト     |
| :------------------------- | :--------------------------------------------------------------------------------------------------------------------------------------------------- | :-------- |
| `name`                     | 出力スタイルの名前（ファイル名でない場合）                                                                                                                                | ファイル名から継承 |
| `description`              | `/config` ピッカーに表示される出力スタイルの説明                                                                                                                        | なし        |
| `keep-coding-instructions` | Claude Code の組み込みソフトウェアエンジニアリング指示を保持する                                                                                                               | `false`   |
| `force-for-plugin`         | プラグイン出力スタイルのみ: プラグインが有効になるたびに、ユーザーが選択する必要なく、このスタイルを自動的に適用します。ユーザーの `outputStyle` 設定をオーバーライドします。複数の有効なプラグインがこれを設定する場合、Claude Code は最初に読み込まれたものを使用します。 | `false`   |

<h2 id="how-output-styles-work">
  出力スタイルの仕組み
</h2>

出力スタイルは Claude Code が Claude に与える指示を変更します。

* Claude Code はアクティブなスタイルの指示をすべてのリクエストで送信します。
* [Default 以外のスタイルを選択](#change-your-output-style)すると、Claude Code は会話中に Claude にそのスタイルを思い出させます。
* カスタム出力スタイルは、`keep-coding-instructions` が `true` に設定されていない限り、スコープ変更の方法、コメントの書き方、作業の検証方法など、Claude Code の組み込みソフトウェアエンジニアリング指示を除外します。

出力スタイルはメイン会話と [フォーク](/docs/ja/sub-agents#fork-the-current-conversation)に適用されます。フォークは親の完全な会話とシステムプロンプトを継承します。その他の [サブエージェントは独自のシステムプロンプトを実行](/docs/ja/sub-agents#what-loads-at-startup)するため、スタイルはそれらの応答方法を変更しません。

トークン使用量はスタイルによって異なります。スタイルの指示はインプットトークンを追加しますが、プロンプトキャッシングはセッション内の最初のリクエスト後にこのコストを削減します。

組み込みの Explanatory および Learning スタイルは、設計上 Default よりも長い応答を生成するため、アウトプットトークンが増加します。Concise スタイルはその逆で、Claude にデフォルトで応答を短く保つよう指示することで、反対の効果を生み出します。カスタムスタイルの場合、アウトプットトークン使用量は、指示が Claude に生成させるものに依存します。

<h2 id="comparisons-to-related-features">
  関連機能との比較
</h2>

Claude Code の動作をカスタマイズするいくつかの機能があります。出力スタイルは Claude Code のデフォルト指示を変更し、すべての応答に適用されます。その他は、デフォルトを変更せずに指示を追加するか、特定のタスクにスコープします。

| 機能                       | 仕組み                                  | 使用する場合                                                                     |
| :----------------------- | :----------------------------------- | :------------------------------------------------------------------------- |
| 出力スタイル                   | Claude Code のデフォルト指示を変更する            | 毎回異なるロール、トーン、またはデフォルト応答形式が必要な場合                                            |
| [CLAUDE.md](/docs/ja/memory)  | システムプロンプトの後にユーザーメッセージを追加する           | Claude がプロジェクト規約とコードベースコンテキストを常に知っている必要がある場合                               |
| `--append-system-prompt` | 何も削除せずにシステムプロンプトに追加する                | [CLI フラグ](/docs/ja/cli-reference#system-prompt-flags)として起動時に渡される 1 回限りの追加が必要な場合 |
| [エージェント](/docs/ja/sub-agents) | 独自のシステムプロンプト、モデル、ツールを持つサブエージェントを実行する | フォーカスされたタスク用に個別にスコープされたヘルパーが必要な場合                                          |
| [スキル](/docs/ja/skills)        | 呼び出されたときまたは関連する場合にタスク固有の指示を読み込む      | 再利用可能なワークフローがある場合                                                          |

<h2 id="related-resources">
  関連リソース
</h2>

* [設定](/docs/ja/settings): `outputStyle` フィールドが存在する場所と設定の優先順位の仕組み
* [権限モード](/docs/ja/permission-modes): Proactive スタイルがオートモードとどのように比較されるか
* [プラグイン](/docs/ja/plugins): スキル、フック、エージェントと一緒に出力スタイルをパッケージ化して配布する
* [設定をデバッグする](/docs/ja/debug-your-config): 出力スタイルが有効にならない理由を診断する
