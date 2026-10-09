> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# コマンド

> Claude Code で利用可能なコマンドの完全なリファレンス。ビルトインコマンドとバンドルされたスキルを含みます。

コマンドはセッション内から Claude Code を制御します。モデルの切り替え、権限の管理、コンテキストのクリア、ワークフローの実行など、様々な操作を素早く行うことができます。

`/` と入力するとご利用いただけるコマンドが表示されます。または `/` の後に文字を入力してフィルタリングできます。[コマンドメニューが入力内容にどのようにマッチするか](#how-the-command-menu-matches-what-you-type)では、ハイライト、タイプミス、および Claude Code がメニューから非表示にするコマンドについて説明しています。これらのコマンドは完全な名前を入力するまで表示されません。

コマンドはメッセージの開始時にのみ認識されます。コマンド名の後に続くテキストがその引数になります。[スキル](/docs/ja/skills#pass-arguments-to-skills)は例外です。スキル呼び出しの後に別のスキルが続く場合（例：`/skill-a /skill-b do XYZ`）、開始時に指定されたスキルが読み込まれ、末尾のテキストが各スキルに引数として渡されます。最大 6 つのスキルをチェーンできます。

Claude が応答中にコマンドを送信した場合、Claude Code はそれをキューに入れ、現在のターンが終了した後に実行します。Claude Code は `/status`、`/tasks`、`/usage` など、応答を中断せずにすぐに実行するコマンドもあります。[フルスクリーンレンダリング](/docs/ja/fullscreen)では、Claude Code は `/theme` や `/help` などのダイアログコマンドもすぐに開きます。v2.1.234 より前では、Claude Code はこれらのダイアログをターンが終了するまでキューに入れていました。

<h2 id="commands-across-a-typical-workflow">
  典型的なワークフロー全体でのコマンド
</h2>

ほとんどのコマンドはセッション内の特定の時点で有用です。プロジェクトのセットアップから変更のリリースまでです。

**リポジトリでの最初のセッション。** `/init` を実行してスターター `CLAUDE.md` を生成し、その後 `/memory` を実行して改善します。`/mcp` を使用してプロジェクトが必要とするサーバーをセットアップし、Claude に作成してほしい [サブエージェント](/docs/ja/sub-agents) があれば尋ね、`/permissions` を実行して承認ルールを設定します。

**タスク中。** `/plan` は大きな変更の前にプランモードに切り替えます。`/model` と `/effort` は使用しているモデルと適用する推論の量を調整します。会話が長くなったら、`/context` はウィンドウを埋めているものを表示し、`/compact` はそれを要約してスペースを解放します。`/btw` を使用して、会話履歴に追加されるべきではない副次的な質問をします。

**並行して作業を実行します。** Claude は副次的なタスクを [サブエージェント](/docs/ja/sub-agents) に委譲し、`/tasks` は現在のセッションのバックグラウンド作業（完了したサブエージェントを含む）をリストします。`/background` はセッション全体をデタッチして [バックグラウンドエージェント](/docs/ja/agent-view) として実行し続け、ターミナルを解放します。コードベース全体にまたがる大きな変更の場合、`/batch` はそれを独立したユニットに分解し、各ユニットを独自の [ワークツリー](/docs/ja/worktrees) で実行します。これらのアプローチがどのように関連しているかについては、[エージェントを並行実行する](/docs/ja/agents) を参照してください。

**リリース前。** `/diff` は変更内容を表示します。`/code-review` は現在の diff を正確性バグについてチェックし、`--fix` で結果を適用できます。PR 番号（例：`/code-review high 1234`）を渡して、代わりにプルリクエストをレビューします。`/review` はエイリアスです。`/code-review ultra` はクラウドでマルチエージェントレビューを実行します。`/security-review` は diff をセキュリティ脆弱性についてチェックします。

**セッション間。** `/clear` はプロジェクトメモリを保持しながら新しいタスクで新規開始します。`/resume` は以前の会話に戻り、`/branch` は現在の会話をブランチして別の方向を試し、`/fork` はそれを新しい [バックグラウンドセッション](/docs/ja/agent-view) にコピーします。`/teleport` は Web セッションをこのターミナルに引き込み、`/remote-control` はこのローカルセッションを別のデバイスから続行できるようにします。

**何か問題がある場合。** `/rewind` はコードと会話をチェックポイントまで戻すか、会話の一部を要約します。`/doctor` はセットアップチェックアップを実行して、インストールと設定の問題を診断し、修正できます。`/debug` はランタイム問題を診断し、`/feedback` はセッションコンテキストが添付されたバグレポートを報告します。

<h2 id="all-commands">
  すべてのコマンド
</h2>

以下の表は、Claude Code に含まれるすべてのコマンドを一覧にしています。ほとんどは組み込みコマンドで、その動作は CLI にコード化されています。2 種類のエントリが標記されています：

* **[Skill](/docs/ja/skills#bundled-skills)**: バンドルスキル。自分で書くスキルと同じように機能します：Claude に渡されるプロンプトです。
  * `/verify` は呼び出したときのみ実行されます。v2.1.215 より前は、Claude が自動的に `/verify` を実行することもできました。
* **[Workflow](/docs/ja/workflows#bundled-workflows)**: バンドルされた[動的ワークフロー](/docs/ja/workflows)で、多くのサブエージェントに作業を展開し、バックグラウンドで実行されます。
  * `/deep-research` は呼び出したときのみ実行されます。v2.1.218 より前は、Claude が自動的に開始することもできました。

独自のコマンドを追加するには、[スキル](/docs/ja/skills)を参照してください。

以下の表では、`<arg>` は必須引数を示し、`[arg]` はオプション引数を示します。

<Note>
  すべてのコマンドがすべてのユーザーに表示されるわけではありません。可用性はプラットフォーム、プラン、環境によって異なります。たとえば、`/desktop` は Claude サブスクリプションでサインインしている場合、macOS と x64 Windows にのみ表示され、`/upgrade` は Enterprise プランには表示されません。
</Note>

| コマンド | 目的 |
| :- | :- |
| `/add-dir <path>` | ファイルアクセスのための作業ディレクトリを現在のセッション中に追加します。部分的なパスを入力して一致するディレクトリの提案を表示し、`Tab` を押して 1 つを受け入れます。ほとんどの `.claude/` 設定は追加されたディレクトリから[検出されません](/docs/ja/permissions#additional-directories-grant-file-access-not-configuration)。ほとんどの[ネットワークパス](/docs/ja/errors#working-directory-is-a-network-path)（`\\server\share` など）は追加できません。正常に追加された後、[`DirectoryAdded` フック](/docs/ja/hooks#directoryadded)が実行されます。Claude が応答している間に実行すると、Claude Code はディレクトリをすぐに確認するよう求め、確認すると Claude の同じターンの次のツール呼び出しがアクセスできます。v2.1.234 より前は、Claude Code はターンが終了するまでコマンドをキューに入れていました |
| `/advisor [model\|off]` | [advisor ツール](/docs/ja/advisor)を有効または無効にします。このツールはタスク中の重要な瞬間に 2 番目のモデルに相談します。`fable`、`opus`、`sonnet`、または完全なモデル ID を受け入れます。`fable` には [Fable アクセス](/docs/ja/advisor#choose-an-advisor-model)が必要です。引数がない場合、ピッカーが開きます。インタラクティブなターミナルがないセッション、または [Remote Control](/docs/ja/remote-control#limitations) 経由では、モデルまたは `off` を引数として渡します。引数がない場合、コマンドは現在の advisor をテキストとして出力します。これらの形式には Claude Code v2.1.260 以降が必要です |
| `/agents` | Claude に[サブエージェント](/docs/ja/sub-agents)の作成または管理を依頼するか、`.claude/agents/` または `~/.claude/agents/` を直接編集するよう促すリマインダーを出力します。v2.1.197 以前では、サブエージェント設定を作成および管理するためのインタラクティブなインターフェイスが開きます |
| `/artifact-capabilities` | **[Skill](/docs/ja/skills#bundled-skills).** 公開された[アーティファクト](/docs/ja/artifacts)が使用できるランタイム機能のリファレンスを読み込みます。たとえば、[コネクタを呼び出す](/docs/ja/artifacts#pull-live-data-with-mcp-connectors)か[ファイルダウンロードを提供する](/docs/ja/artifacts#offer-a-file-download)など、アカウントが持つものを含みます。Claude は通常、1 つを使用するページを構築する前にそれを自動的に読み込みます。[アーティファクト](/docs/ja/artifacts#availability)が利用可能な場所で利用できます |
| `/artifact-diagramming` | **[Skill](/docs/ja/skills#bundled-skills).** [アーティファクト](/docs/ja/artifacts)で Claude が従うべき図作成ガイダンスを読み込みます：図が役立つ場合、何を描くか、明るいテーマと暗いテーマで読みやすいままのインライン SVG を書く方法。Claude Code v2.1.221 以降が必要です |
| `/artifacts` | 所有または共有されている[アーティファクト](/docs/ja/artifacts#find-an-artifact-again)を一覧表示し、セッションに添付するか、ブラウザで開くか、そのリンクをコピーします。[アーティファクト](/docs/ja/artifacts#availability)が利用可能な場所で利用できます。Claude Code v2.1.208 以降が必要です。`Enter` で添付するには v2.1.216 が必要です |
| `/auto-mode-setup` | プロジェクトと最近のセッションから [`autoMode.environment` エントリ](/docs/ja/auto-mode-config#generate-environment-entries)をドラフトし、ドラフトを確認してユーザー設定に保存します。Pro、Max、または Team プランと Claude Code v2.1.228 以降が必要です。ネイティブ Windows では v2.1.233 以降が必要です |
| `/autocompact [auto\|<tokens>]` | 自動圧縮ウィンドウを設定します：Claude Code が自動的に圧縮する前にコンテキストウィンドウがどのくらい満杯になるかです。`500k` などのサイズを渡すか、`auto` を渡してモデル用に調整されたウィンドウに戻します。Claude Code は値をユーザー設定に保存し、現在のセッションに適用します。受け入れられる値と何がそれを上書きするかについては、[自動圧縮ウィンドウを設定する](/docs/ja/model-config#set-the-auto-compact-window)を参照してください。引数がない場合、現在のウィンドウを表示するダイアログが開きます。Claude Code v2.1.221 以降が必要です |
| `/autofix-pr [prompt]` | 現在のブランチの PR を監視し、CI が失敗するか、レビュアーがコメントを残すと修正をプッシュする[クラウドセッション](/docs/ja/claude-code-on-the-web#auto-fix-pull-requests)を生成します。`gh pr view` で現在チェックアウトされているブランチから開いている PR を検出します。別の PR を監視するには、最初にそのブランチをチェックアウトします。デフォルトでは、クラウドセッションはすべての CI 失敗とレビューコメントを修正するよう指示されます。別の指示を与えるためにプロンプトを渡します。たとえば `/autofix-pr only fix lint and type errors`。`gh` CLI と[クラウドセッション](/docs/ja/claude-code-on-the-web)へのアクセスが必要です |
| `/background [prompt]` | 現在のセッションをデタッチして[バックグラウンドエージェント](/docs/ja/agent-view)として実行し、このターミナルを解放します。デタッチする前に別の指示を送るためにプロンプトを渡します。`claude agents` でセッションを監視します。このセッションが実行し続けている間に会話を新しいバックグラウンドセッションにコピーするには、`/fork` を使用します。エイリアス：`/bg` |
| `/batch <instruction>` | **[Skill](/docs/ja/skills#bundled-skills).** コードベース全体で大規模な変更を並列に調整します。コードベースを調査し、作業を 5 ～ 30 個の独立したユニットに分解し、計画を提示します。承認されると、分離された [worktree](/docs/ja/worktrees) 内でユニットごとに 1 つの[バックグラウンドサブエージェント](/docs/ja/sub-agents#run-subagents-in-foreground-or-background)を生成します。各サブエージェントはそのユニットを実装し、テストを実行し、その変更を公開します。git リポジトリまたは worktree を作成する [`WorktreeCreate` フック](/docs/ja/worktrees#non-git-version-control)が必要です。git リポジトリの外では、`/batch` には Claude Code v2.1.281 以降が必要です。例：`/batch migrate src/ from JavaScript to TypeScript` |
| `/branch [name]` | 現在の会話をこの時点で分岐させて、現状の会話を失わずに別の方向を試すことができます。分岐に切り替え、元の会話を保持します。元の会話には `/resume` で戻ることができます。コピーに切り替える代わりに別の[バックグラウンドセッション](/docs/ja/agent-view)として実行するには、`/fork` を使用します。この会話に報告する[サブエージェント](/docs/ja/sub-agents)に副タスクを渡すには、`/subtask` を使用します |
| `/btw [question]` | 会話に追加せずに現在のセッションについて[副質問](/docs/ja/interactive-mode#side-questions-with-%2Fbtw)をします。`/btw` を質問なしで実行すると、Claude Code は最新の副質問を表示して、以前の回答を参照できます。まだ質問していない場合、Claude Code は使用方法の行を出力します。v2.1.212 より前は、`/btw` は質問が必要でした |
| `/bug [report]` | バグを報告するか、会話を共有します。セッション履歴をどのくらい含めるかを選択し、何かが送信される前に同意画面で確認します。ファーストパーティ接続で Anthropic にサインインしている場合、レポートは Anthropic に送信されます。サードパーティプロバイダーの場合、または Anthropic 認証情報がない場合、Claude Code はレポートを [`~/.claude/feedback-bundles/` 配下のローカルアーカイブ](/docs/ja/data-usage#telemetry-services)に書き込み、自分で転送します。[VS Code 拡張機能](/docs/ja/vs-code#use-the-prompt-box)では、`/bug` は代わりに拡張機能独自のフィードバックダイアログを開きます。Claude Code v2.1.229 以降が必要です。Claude が応答している間に実行すると、Claude Code はダイアログをすぐに開きます。v2.1.232 より前は、Claude Code はターンが終了するまでコマンドをキューに入れていました。エイリアス：`/share`。v2.1.212 より前は、`/bug` と `/share` は `/feedback` のエイリアスでした |
| `/cd <path>` | このセッションを新しい作業ディレクトリに移動し、会話を保持します。部分的なパスを入力して一致するディレクトリの提案を表示し、`Tab` を押して 1 つを受け入れます。提案には Claude Code v2.1.206 以降が必要です。Claude Code が新しいディレクトリからすぐに適用するもの、および `/cd` が `/add-dir` とどのように異なるかについては、[セッションを別のディレクトリに移動する](/docs/ja/permissions#move-the-session-to-another-directory)を参照してください |
| `/chrome` | [Claude in Chrome](/docs/ja/chrome) 設定を構成します |
| `/claude-api [migrate\|upgrade\|managed-agents-onboard\|prompt-audit\|cost-optimize\|build-eval\|hillclimb\|preserved-thinking-migration]` | **[Skill](/docs/ja/skills#bundled-skills).** プロジェクトの言語用に [Claude API](https://platform.claude.com/docs/en/api/overview) および [Managed Agents](https://platform.claude.com/docs/en/managed-agents/overview) リファレンス資料を読み込みます。コードが `anthropic` または `@anthropic-ai/sdk` をインポートするときも自動的にアクティブになります。各サブコマンドが何をするか、および必要なバージョンについては、[Claude API プロジェクトで作業する](/docs/ja/skills#work-on-claude-api-projects)を参照してください |
| `/claude-in-chrome [task]` | **[Skill](/docs/ja/skills#bundled-skills).** Claude にブラウザでタスクを実行させます。ページのテスト、フォームの入力、コンソールログの読み取りなど、[Claude in Chrome](/docs/ja/chrome) を通じて。Chrome 統合がセッションで有効な場合（たとえば `claude --chrome` など）、または Claude Code が[拡張機能をインストール](/docs/ja/chrome#install-the-extension-when-claude-asks)することを提案できる場合に利用可能です |
| `/clear [name]` | 空のコンテキストで新しい会話を開始します。前の会話に `/resume` ピッカーでラベルを付けるために名前を渡します。同じ会話を続けながらコンテキストを解放するには、代わりに `/compact` を使用します。`/resume` で前の会話を再開するか、同じ Claude Code プロセスで、[rewind メニューの previous-session エントリ](/docs/ja/checkpointing#rewind-past-a-cleared-conversation)から復元します。エイリアス：`/reset`、`/new` |
| `/code-review [low\|medium\|high\|xhigh\|max\|ultra] [--fix] [--comment] [--max-findings n\|all\|default] [pr#\|branch\|path]` | **[Skill](/docs/ja/skills#bundled-skills).** 現在の差分、または渡す PR 番号、ブランチ、またはパスを正確性バグについてレビューします。モデルと effort レベルに応じて、レビューはクリーンアップの機会もカバーします。`--fix` を渡して検出結果を適用し、`--comment` を渡して GitHub PR または GitLab マージリクエストに投稿するか、`ultra` を渡してディープ[クラウドレビュー](/docs/ja/ultrareview)を実行します。GitLab マージリクエストに投稿するには Claude Code v2.1.257 以降が必要です。`github.com` PR ターゲットで `ultra` を使用する場合、`--post` を渡して [PR に完成した検出結果を投稿する](/docs/ja/ultrareview#post-findings-to-the-pull-request)ことを起動ダイアログで事前選択します。`--post` には Claude Code v2.1.227 以降が必要です。effort レベル、ターゲット、および `/simplify` との関係については、[差分をローカルでレビューする](/docs/ja/code-review#review-a-diff-locally)を参照してください。エイリアス：`/review` |
| `/color [color\|default]` | 現在のセッションのプロンプトバーのカラーを設定します。利用可能なカラー：`red`、`blue`、`green`、`yellow`、`purple`、`orange`、`pink`、`cyan`。`default` を使用してリセットするか、引数なしで実行してランダムなカラーを選択します。[Remote Control](/docs/ja/remote-control) が接続されている場合、カラーは claude.ai/code に同期されます。非対話モード（`-p`）でも利用可能です。Claude Code v2.1.205 以降が必要です |
| `/compact [instructions]` | ここまでの会話を要約してコンテキストを解放します。オプションで要約のフォーカス指示を渡します。[コンテキスト圧縮がルール、スキル、メモリファイルをどのように処理するか](/docs/ja/context-window#what-survives-compaction)を参照してください |
| `/config [key=value ...]` | [設定](/docs/ja/settings)インターフェイスを開いて、テーマ、モデル、[出力スタイル](/docs/ja/output-styles)、その他の設定を調整します。1 つ以上の `key=value` ペアを渡して、インターフェイスを開かずに設定を直接設定します。たとえば `/config thinking=false`、`/config theme=dark`、または `/config model=sonnet`。`key=value` 形式は非対話モード（`-p`）および Claude モバイルアプリから [Remote Control](/docs/ja/remote-control) 経由でも機能します。`key=value` 形式は、[`autoContinueAtUsageLimit`](/docs/ja/interactive-mode#turn-automatic-continue-off) などのパネルで確認が必要な設定をオンにすることはできませんが、オフにすることはできます。`/config --help` を実行して、受け入れるキーを一覧表示します。エイリアス：`/settings` |
| `/context [all]` | 現在のコンテキスト使用量をカラーグリッドとして視覚化します。コンテキストが多いツール、メモリ肥大化、容量警告の最適化提案を表示します。会話がコンテキストウィンドウを超える場合、出力には制限をどのくらい超えているか、どのコマンドがスペースを解放するかを示す[警告](/docs/ja/errors#context-exceeds-the-token-limit)が含まれます。[フルスクリーンモード](/docs/ja/fullscreen)では、`/context` は項目ごとの内訳を折りたたんでグリッドを表示したままにします。`all` を渡して展開します |
| `/copy [N]` | 最後のアシスタント応答をクリップボードにコピーします。数値 `N` を渡して N 番目に最新の応答をコピーします：`/copy 2` は 2 番目に最新の応答をコピーします。コードブロックが存在する場合、個別のブロックまたは完全な応答を選択するためのインタラクティブなピッカーを表示します。ピッカーで `w` を押して、クリップボードの代わりにファイルに選択を書き込みます。これは SSH 経由で便利です |
| `/cost` | `/usage` のエイリアス |
| `/dataviz [request]` | **[Skill](/docs/ja/skills#bundled-skills).** チャート、グラフ、ダッシュボードの設計ガイダンス。Claude はデータのチャート形式を選択し、役割別にカラーを割り当て、バンドルされたスクリプトで色覚異常の安全性とコントラストを検証し、マーク、インタラクション、アクセシビリティルールを適用します。独自のパレットに置き換えるブランド中立的なプレースホルダーパレットを使用します |
| `/debug [description]` | **[Skill](/docs/ja/skills#bundled-skills).** 現在のセッションのデバッグログを有効にし、セッションデバッグログを読んで問題をトラブルシューティングします。デバッグログはデフォルトではオフです。`claude --debug` で開始した場合を除き、セッション中に `/debug` を実行するとその時点からログのキャプチャを開始します。オプションで問題を説明して分析にフォーカスを当てます |
| `/deep-research <question>` | **[Workflow](/docs/ja/workflows#bundled-workflows).** 質問に関する Web 検索をファンアウトし、ソースをフェッチして相互チェックし、引用付きのレポートを合成します |
| `/design [brief]` | **[Skill](/docs/ja/skills#bundled-skills).** UI モックアップ、スクリーンフロー、ランディングページ、またはポスターを 1 つのキャンバス上のアートボードとしてドラフトし、Claude Design [アーティファクト](/docs/ja/artifacts#draft-a-design-canvas)として公開します。たとえば `/design a settings screen for a mobile banking app`。デスクトップブラウザでアートボードを編集し、編集は自動的に保存されます。各アートボードを PNG または PDF としてエクスポートできます。Claude Code v2.1.265 以降が必要です。[アーティファクトが利用可能](/docs/ja/artifacts#availability)なセッション、およびアカウントで [Design テンプレートが利用可能](/docs/ja/artifacts#start-from-a-slides-design-or-docs-template)である必要があります。組織がそのテンプレートをオフにしている場合、`/design` はデザインをドラフトしません。Anthropic API で利用可能です。Amazon Bedrock、Google Cloud の Agent Platform、Microsoft Foundry、および Claude Platform on AWS では、アーティファクトが利用できないため、コマンドは利用できません |
| `/design-login` | `/design-sync` のデザインシステムアクセスを claude.ai アカウントで認可します |
| `/design-sync [hint]` | **[Skill](/docs/ja/skills#bundled-skills).** リポジトリの React デザインシステムを変換して [Claude Design](https://claude.ai/design) にアップロードし、生成されるデザインが実際のコンポーネントを使用するようにします。オプションでデザインシステムに名前を付けます。たとえば `/design-sync Acme DS`。初回同期はすべてのコンポーネントを検証し、大規模なリポジトリでは数時間かかる場合があります。Anthropic API で利用可能です。claude.ai が必要ですが、Amazon Bedrock、Google Cloud の Agent Platform、Microsoft Foundry、Claude Platform on AWS、または [Claude apps gateway](/docs/ja/claude-apps-gateway#availability-and-limitations) 経由では CLI が claude.ai に接続しないため、コマンドは利用できません |
| `/desktop` | 現在のセッションを Claude Code Desktop アプリで続行します。macOS または x64 Windows と Claude サブスクリプションが必要です。エイリアス：`/app` |
| `/diff` | 作業ツリーの変更（Claude がこれまでに行った編集を含む）を確認します。[/diff で変更を確認する](/docs/ja/interactive-mode#review-changes-with-%2Fdiff)を参照してください |
| `/doctor [prompt-audit [path]]` | **[Skill](/docs/ja/skills#bundled-skills).** インストール、設定、拡張機能、`CLAUDE.md` の問題を診断し、確認後に Claude が適用する修正を提案するセットアップチェックアップを実行します。チェックアップの対象範囲、または代わりに `prompt-audit` で指示を監査する方法については、[`/doctor` でセットアップを確認する](/docs/ja/skills#check-your-setup-with-/doctor)を参照してください。`prompt-audit` サブコマンドには Claude Code v2.1.283 以降が必要です。エイリアス：`/checkup` |
| `/effort [level\|auto\|status\|ultracode [on\|off]]` | [effort レベル](/docs/ja/model-config#adjust-effort-level)を設定します：`low` から `xhigh`、`max`、または `auto`。`status` はそれを出力します。`ultracode` または `ultracode on` は現在のレベルのままセッションで [ultracode](/docs/ja/workflows#let-claude-decide-with-ultracode) をオンにし、`ultracode off` はそれをオフにします。[`ultracode`](/docs/ja/settings-reference#ultracode) キーは永続化されます。`max` はセッションのみです。`on` および `off` 引数と現在のレベルを保持するには Claude Code v2.1.284 以降が必要です。v2.1.284 より前は、`/effort ultracode` はセッションを `xhigh` に設定し、`/effort ultracode off` は `Invalid argument` で失敗しました。Claude が応答している間に実行すると、Claude Code が[キャッシュ警告](/docs/ja/prompt-caching#changing-effort-level)を表示した場合はそれを確認した後、Claude Code は新しいレベルをそのターンの次のリクエストに適用します。v2.1.242 より前は、Claude Code は Anthropic から取得したフィーチャーフラグからコマンドをミッドターンで実行するか、ターンが終了するまでキューに入れるかを決定し、[フィーチャーフラグをフェッチしない](/docs/ja/env-vars#features-that-need-feature-flag-fetching)セッション（[サードパーティプロバイダー](/docs/ja/third-party-integrations)など）では常にキューに入れていました。`-p` で機能します |
| `/exit` | CLI を終了します。アタッチされた[バックグラウンドセッション](/docs/ja/agent-view#attach-to-a-session)では、これはデタッチし、セッションは実行し続けます。エイリアス：`/quit` |
| `/export [filename]` | 現在の会話をプレーンテキストとしてエクスポートします。ファイル名を指定すると、そのファイルに直接書き込みます。指定しない場合、クリップボードにコピーするか、ファイルに保存するためのダイアログが開きます |
| `/fast [on\|off]` | [fast mode](/docs/ja/fast-mode) をオンまたはオフに切り替えます。Claude が応答している間に実行すると、Claude Code はターンの終了を待たずに fast mode を切り替えます。ただし、実行中のターンは元の速度で終了します。v2.1.242 より前は、Claude Code は Anthropic から取得したフィーチャーフラグからコマンドをミッドターンで実行するか、ターンが終了するまでキューに入れるかを決定し、[フィーチャーフラグをフェッチしない](/docs/ja/env-vars#features-that-need-feature-flag-fetching)セッションでは常にキューに入れていました。`-p` を使用した非対話モードでの可用性は限定的です。[fast mode を切り替える](/docs/ja/fast-mode#toggle-fast-mode)を参照してください。Claude Code v2.1.205 以降が必要です |
| `/feedback [report]` | Claude Code に関する製品フィードバックを送信します。[`/bug`](#all-commands) と同じダイアログを開き、同じ同意ステップ、送信ルール、ミッドターン動作があります。[Claude がドラフトしたフィードバック](/docs/ja/tools-reference#sendfeedback-tool-behavior)を含むセッションでは、引数なしで `/feedback` を実行するとドラフトキューが代わりに開き、Claude がキューに入れたドラフトを確認、編集、送信、または破棄できます。キューには新しいレポートをダイアログで書き込むオプションが含まれます。引数を指定した場合、および `/bug` の場合は常に、ダイアログが直接開きます |
| `/fewer-permission-prompts` | **[Skill](/docs/ja/skills#bundled-skills).** トランスクリプトで一般的な読み取り専用 Bash および MCP ツール呼び出しをスキャンし、プロジェクト `.claude/settings.json` に優先順位付きの許可リストを追加して権限プロンプトを減らします |
| `/focus` | フォーカスビューを切り替えます。最後のプロンプト、1 行のツール呼び出し要約と編集 diffstats、および最終応答のみを表示します。ツール呼び出し要約はターンで起動されたサブエージェントもカウントし、完了したバックグラウンドタスク通知を 1 つのカウントに折りたたみます。選択はセッション間で永続化されます。設定で [`viewMode`](/docs/ja/settings-reference#viewmode) を設定して上書きします。[フルスクリーンレンダリング](/docs/ja/fullscreen)でのみ利用可能です。[Remote Control](/docs/ja/remote-control) クライアントから、`/focus [on\|off]` を実行して、保存された選択を変更せずに現在のセッションのみのフォーカスビューをオンまたはオフにします。これには Claude Code v2.1.281 以降が必要です。[VS Code 拡張機能](/docs/ja/vs-code#use-the-prompt-box)は独自のフォーカスビューをコマンドメニューの切り替えとして提供し、拡張機能設定として保存され、`viewMode` とは独立しています |
| `/fork [prompt]` | [現在の会話をコピー](/docs/ja/agent-view#copy-the-session-with-%2Ffork)して新しいバックグラウンドセッションを作成し、ここで作業を続けます。プロンプトを渡すとコピーはすぐにそれに対して作業を開始します。渡さない場合、エージェントビューで最初のプロンプトを待ちます。コピーが[その場で編集](/docs/ja/agent-view#how-file-edits-are-isolated)する場合を除き、Claude Code はコード変更を行う前に独自の worktree を作成するよう指示します。分離指示には Claude Code v2.1.221 以降が必要です。結果がこの会話に戻ってくるサブエージェントに副タスクを渡すには、`/subtask` を使用します。自分でコピーに切り替えるには、`/branch` を使用します。Claude Code v2.1.212 以降が必要です。v2.1.161 ～ v2.1.211 では、および [agent view がオフ](/docs/ja/agent-view#turn-off-agent-view)になっている場合は常に、`/fork` は代わりに[フォークされたサブエージェント](/docs/ja/sub-agents#fork-the-current-conversation)を開始します |
| `/goal [condition\|clear]` | [goal](/docs/ja/goal) を設定します：Claude は条件が満たされるか goal が[別の理由でクリア](/docs/ja/goal#how-evaluation-works)されるまでターンをまたいで作業を続けます。引数がない場合、現在または最近達成された goal を表示します。`clear`、`stop`、`off`、`reset`、`none`、または `cancel` はアクティブな goal を早期に削除します |
| `/heapdump` | JavaScript ヒープスナップショットとメモリ内訳を `~/Desktop`、または Desktop フォルダがない Linux ではホームディレクトリに書き込んで、高いメモリ使用量を診断します。メモリ問題を報告するときは `-diagnostics.json` ファイルのみを添付してください。`.heapsnapshot` には完全な会話と認証情報が含まれているため、共有しないでください。[コマンドメニューから非表示](#how-the-command-menu-matches-what-you-type)です。完全に入力してください。[出力をどう扱うか](/docs/ja/troubleshooting#high-cpu-or-memory-usage)を参照してください |
| `/help` | ヘルプと利用可能なコマンドを表示します |
| `/hooks` | [フック](/docs/ja/hooks#the-%2Fhooks-menu)設定を表示します |
| `/ide` | IDE 統合を管理して状態を表示します |
| `/import [codex\|gemini\|cursor] [--dry-run] [--yes]` | マシン上の OpenAI Codex、Google Gemini CLI、または Cursor から Claude Code に設定を取り込みます。指示ファイル、MCP サーバー、コマンド、サブエージェント、スキルを含みます。`-p` を使用した[非対話モード](/docs/ja/headless)では、`/import` は見つけたものを一覧表示し、インポートを確認するコマンドを提供します。`--dry-run` を追加して何も書き込まずにプレビューするか、`--yes` を追加してインタラクティブなピッカーをスキップします。Amazon Bedrock、Google Cloud の Agent Platform、Microsoft Foundry、Claude Platform on AWS、または [Claude apps gateway](/docs/ja/claude-apps-gateway#availability-and-limitations) 経由では利用できません。[フィーチャーフラグフェッチング](/docs/ja/env-vars#features-that-need-feature-flag-fetching)をオフにしている場合も利用できません。Claude Code v2.1.213 以降が必要です。Cursor からのインポートには v2.1.265 以降が必要です |
| `/init` | `CLAUDE.md` ガイドでプロジェクトを初期化します。`CLAUDE_CODE_NEW_INIT=1` を設定すると、スキル、フック、個人メモリファイルのウォークスルーも行うインタラクティブなフローになります。`/init` が OpenAI Codex または Google Gemini CLI の設定を見つけた場合、`/import` で引き継ぐことを提案します |
| `/insights` | このマシンの最近のセッションを分析する HTML レポートを生成します：どのプロジェクトで作業するか、Claude Code をどのように使用するか、何が問題になるか、試すべき機能。[クラウドセッション](/docs/ja/claude-code-on-the-web)では利用できません。レポートの場所、保持、コストについては、[使用パターンを分析する](/docs/ja/costs#analyze-your-usage-patterns)を参照してください |
| `/install-github-app` | リポジトリの Claude GitHub App をインストールし、[GitHub Actions](/docs/ja/github-actions) ワークフローとシークレットをセットアップするオプションのステップを実行します。リポジトリを選択して統合を設定するウォークスルーを行います。github.com リポジトリでのみ機能します。リポジトリの git リモートが gitlab.com または bitbucket.org にある場合、コマンドは通知を出力してセットアップを開始する代わりに終了します。GitLab パイプラインから Claude Code を実行するには、[GitLab CI/CD](/docs/ja/gitlab-ci-cd) を参照してください |
| `/install-slack-app` | Claude Slack アプリをインストールします。OAuth フローを完了するためにブラウザを開きます |
| `/keybindings` | [キーボードショートカット](/docs/ja/keybindings)ファイルを開きます |
| `/list-agents` | サブエージェント、[エージェントチーム](/docs/ja/agent-teams)のチームメイト、および Claude がメッセージを送信できるその他の Claude Code セッションを、それぞれに使用する名前とともに一覧表示します。[クロスセッションメッセージング](/docs/ja/cross-session-messaging)を参照してください。`/peers` としても利用可能です。Claude Code v2.1.224 以降が必要です。以前のバージョンは `Unknown command: /list-agents` を報告します。チームメイト行とこのセッション自身の名前を示す最初の行には v2.1.239 以降が必要です。[クロスセッションメッセージングが有効](/docs/ja/cross-session-messaging#availability)なセッションでのみ利用可能です |
| `/login` | Anthropic アカウントにサインインします |
| `/logout` | Anthropic アカウントからサインアウトします |
| `/loop [interval] [prompt]` | **[Skill](/docs/ja/skills#bundled-skills).** セッションが開いている間、プロンプトを繰り返し実行します。間隔を省略すると、Claude は[反復間で自分のペースを設定](/docs/ja/scheduled-tasks#let-claude-choose-the-interval)します。プロンプトを省略すると、Claude は[組み込みメンテナンスプロンプト](/docs/ja/scheduled-tasks#run-the-built-in-maintenance-prompt)または [`loop.md`](/docs/ja/scheduled-tasks#customize-the-default-prompt-with-loop-md) を実行します。例：`/loop 5m check if the deploy finished`。[スケジュールでプロンプトを実行する](/docs/ja/scheduled-tasks)を参照してください。エイリアス：`/proactive` |
| `/mcp [reconnect (<server>\|all)\|enable\|disable [<server>\|all]]` | MCP サーバー接続と OAuth 認証を管理します。引数なしで実行してインタラクティブなリストを開くか、`reconnect`、`enable`、または `disable` をサーバー名または `all` とともに渡して、リストを開かずに接続状態を変更します。`reconnect all` は[失敗したサーバーまたは認証が必要なサーバーをすべて再試行](/docs/ja/mcp#retry-failed-servers-yourself)します。非対話モード（`-p`）でも利用可能で、引数なしで実行するとリストを開く代わりにサーバー状態のテキスト要約を出力します。Claude Code v2.1.205 以降が必要です |
| `/memory` | `CLAUDE.md` ファイルを編集し、[自動メモリ](/docs/ja/memory#auto-memory)を有効または無効にし、自動メモリのエントリを表示します |
| `/mobile` | Claude モバイルアプリをダウンロードするための QR コードを表示します。エイリアス：`/ios`、`/android` |
| `/model [model]` | AI モデルを切り替えて、新しいセッションのデフォルトとして保存します。サポートするモデルの場合、左右の矢印を使用して [effort レベルを調整](/docs/ja/model-config#adjust-effort-level)します。引数がない場合、ピッカーが開きます。行で `s` を押すと現在のセッションのみ切り替えます。[Claude Code が切り替えを確認するよう求めるとき](/docs/ja/prompt-caching#switching-models)を参照してください。Claude Code が確認を求めた場合は切り替えを確認すると、Claude Code は現在の応答の終了を待たずに変更を適用します。v2.1.242 より前は、Claude Code は Anthropic から取得したフィーチャーフラグからコマンドをミッドターンで実行するか、ターンが終了するまでキューに入れるかを決定し、[フィーチャーフラグをフェッチしない](/docs/ja/env-vars#features-that-need-feature-flag-fetching)セッション（[サードパーティプロバイダー](/docs/ja/third-party-integrations)など）では常にキューに入れていました。非対話モード（`-p`）でも、ピッカーの代わりにモデル引数を使用して利用可能です。その場合は現在のセッションのみに適用され、デフォルトとして保存されません。Claude Code v2.1.205 以降が必要です |
| `/output-style [style]` | [出力スタイル](/docs/ja/output-styles)を一覧表示するか、1 つに切り替えます。たとえば `/output-style concise`。[出力スタイルを変更する](/docs/ja/output-styles#change-your-output-style)を参照してください。Claude Code v2.1.269 以降が必要です |
| `/passes` | 友人と Claude Code の無料 1 週間を共有します。アカウントが適格な場合のみ表示されます |
| `/permissions` | ツール権限の許可、質問、拒否ルールを管理します。スコープ別にルールを表示し、ルールを追加または削除し、作業ディレクトリを管理し、[最近の auto モードの拒否](/docs/ja/auto-mode-config#review-denials)を確認できるインタラクティブなダイアログが開きます。ダイアログの **Auto mode** タブから [auto モード分類器ルール](/docs/ja/auto-mode-config#edit-rules-from-permissions)を表示および編集することもできます。Claude が応答している間に実行すると、Claude Code はダイアログをすぐに開き、同じターンで Claude の次のツール呼び出しから変更を適用します。v2.1.234 より前は、Claude Code はターンが終了するまでコマンドをキューに入れていました。エイリアス：`/allowed-tools` |
| `/plan [description]` | プロンプトから直接 plan モードに入ります。オプションの説明を渡して plan モードに入り、すぐにそのタスクで開始します。たとえば `/plan fix the auth bug` |
| `/plugin [subcommand]` | Claude Code [プラグイン](/docs/ja/plugins/overview)を管理します。引数なしで実行してプラグインメニューを開くか、`list`、`install`、`enable`、`disable` などのサブコマンドを渡して直接実行します。Claude Code はインストール中にプラグインをアクティブ化できます。[インストール要約](/docs/ja/plugins/install#install-a-plugin)は、アクティブ化したかどうか、または `/reload-plugins` を実行する必要があるかを示します |
| `/plugin-authoring` | Claude が [mod を作成する](/docs/ja/plugins/mods/create#ask-claude-for-a-mod)際に参照するリファレンスを読み込みます。mod を依頼すると、Claude が自動的に読み込むこともあります。これは[組み込みプラグイン](/docs/ja/plugins/mods/overview#mods-built-into-claude-code)のスキルで、`/plugin` でオフにできます。Claude Code v2.1.287 以降が必要です |
| `/powerup` | アニメーション化されたデモを含むクイックインタラクティブなレッスンを通じて Claude Code 機能を発見します |
| `/pr-comments [PR]` | v2.1.91 で削除されました。代わりに Claude に直接プルリクエストコメントを表示するよう求めてください。以前のバージョンでは、GitHub プルリクエストからコメントをフェッチして表示します。現在のブランチの PR を自動的に検出するか、PR URL または番号を渡します。`gh` CLI が必要です |
| `/privacy-settings` | プライバシー設定を表示および更新します。Pro および Max プランのサブスクライバーのみが利用可能です |
| `/radio` | ブラウザで Claude FM lo-fi ラジオを開きます。ブラウザが利用できない場合、ストリーム URL を出力します |
| `/rate-limit-options` | claude.ai の使用制限がリクエストをブロックしている場合に作業を続ける方法を表示します：待機して[制限がリセットされたときに自動的に続行](/docs/ja/interactive-mode#wait-for-a-usage-limit-to-reset)、[使用クレジット](/docs/ja/costs#add-usage-credits-to-your-subscription)を追加、またはプランをアップグレードします。自分のターミナルで制限に達したとき、Claude Code がこのメニューを自動的に開くこともあります。[自動続行をオフにする](/docs/ja/interactive-mode#turn-automatic-continue-off)を参照してください。claude.ai サブスクリプションが必要です。待機して続行する行には Claude Code v2.1.234 以降が必要です |
| `/recap` | 現在のセッションの 1 行の要約をオンデマンドで生成します。離れていた後に表示される自動要約については、[セッション要約](/docs/ja/interactive-mode#session-recap)を参照してください |
| `/release-notes` | インタラクティブなバージョンピッカーでチェンジログを表示します。特定のバージョンを選択してそのリリースノートを表示するか、すべてのバージョンを表示することを選択します。ノートはトランスクリプトに表示されますが、Claude が見る会話には入りません |
| `/reload-plugins [--force]` | すべてのアクティブな[プラグイン](/docs/ja/plugins/overview)を再度読み込んで、保留中の変更を再起動なしで適用します。再度読み込まれた各コンポーネントのカウントを報告し、読み込みエラーを指摘します。再読み込みによって読み込まれる MCP ツールが変わり、プロンプトキャッシュが無効になる場合、コマンドは警告を出し、`--force` を渡さない限りスキップします。非対話モード（`-p`）、Agent SDK、デスクトップアプリでも利用可能です。これらではセッションに直接入力された入力でのみ実行され、プラグイン MCP サーバーの変更は適用されません。Claude Code v2.1.260 以降が必要です。[再起動なしでプラグイン変更を適用する](/docs/ja/plugins/cli-reference#reload-plugins)を参照してください |
| `/reload-skills` | [スキル](/docs/ja/skills)とコマンドディレクトリを再スキャンして、セッション中にディスク上で追加または変更されたスキルが再起動なしで利用可能になるようにします。利用可能なスキルの数と追加または削除されたスキルの数を報告します |
| `/remote-control` | このセッションを claude.ai から [Remote Control](/docs/ja/remote-control) で利用可能にします。サインアウト状態で実行すると、Remote Control に claude.ai サブスクリプションが必要であることを出力し、サインイン方法を示します。v2.1.206 より前は `Unknown command: /remote-control` を報告しました。エイリアス：`/rc` |
| `/remote-env` | CLI から開始するクラウドセッションのデフォルト[クラウド環境](/docs/ja/cloud-environments#select-an-environment-from-the-cli)を選択します |
| `/rename [name]` | 現在のセッションの名前を変更し、プロンプトバーに名前を表示します。名前がない場合、会話履歴から自動生成されます。非対話モード（`-p`）でも利用可能です。Claude Code v2.1.205 以降が必要です。claude.ai とデスクトップアプリを含むすべての名前変更サーフェスから、Claude Code は新しい名前の制御文字と非表示文字をスペースに置き換え、名前を 200 文字に制限します。非表示文字を削除すると名前が空になる場合、Claude Code はそれを拒否し、`That name is empty once invisible characters are removed. Usage: /rename <name>` を表示します。文字置換と長さ制限には Claude Code v2.1.221 以降が必要です。このマシン上の別のライブセッションが既に渡した名前を使用している場合、Claude Code は代わりに[その変種](/docs/ja/sessions#name-your-sessions)を適用します |
| `/resume [session]` | ID または名前で会話を再開するか、セッションピッカーを開きます。[バックグラウンドセッション](/docs/ja/agent-view)はピッカーに `bg` でマークされて表示されます。実行中のセッションをピッカーから、または ID または名前で再開すると、[そのセッションが開きます](/docs/ja/sessions#resume-a-running-background-session)：現在の会話はバックグラウンドに移動し、このターミナルは実行中のセッションにアタッチされます。空のプロンプトで `←` を押すとエージェントビューに戻ります。エージェントビューには離れた会話も一覧表示されます。v2.1.285 より前は、Claude Code は拒否し、`claude attach` でセッションを開くか、先にそれを停止するよう指示していました。エイリアス：`/continue` |
| `/review [low\|medium\|high\|xhigh\|max\|ultra] [--fix] [--comment] [--max-findings n\|all\|default] [pr#\|branch\|path]` | [`/code-review`](/docs/ja/code-review#review-a-diff-locally) のエイリアス：現在の差分、または `/review 1234` などの渡す PR 番号、ブランチ、またはパスをレビューし、同じ effort レベルとフラグを取ります。レベルが指定されていない場合、レビューは最後に入力した `low` ～ `max` のレベルを再利用します。正確なルールについては、[差分をローカルでレビューする](/docs/ja/code-review#review-a-diff-locally)を参照してください。ディープクラウドレビューの場合は、[`/code-review ultra`](/docs/ja/ultrareview) を使用してください。v2.1.223 より前は、`/review` は GitHub プルリクエストを番号で指定して単一パスの読み取り専用レビューを実行する別のコマンドで、引数なしで実行すると開いている PR を一覧表示して選択できました。v2.1.186 ～ v2.1.201 では、`/code-review medium` と同じマルチエージェントエンジンを実行しました |
| `/rewind` | 会話またはコードを前の時点に巻き戻すか、選択したメッセージから要約します。[チェックポイント機能](/docs/ja/checkpointing)を参照してください。エイリアス：`/checkpoint`、`/undo` |
| `/run` | **[Skill](/docs/ja/skills#bundled-skills).** プロジェクトのアプリを起動して操作し、テストに合格するだけでなく、変更が実際に機能していることを確認します。[アプリを実行して検証する](/docs/ja/skills#run-and-verify-your-app)を参照してください |
| `/run-skill-generator` | **[Skill](/docs/ja/skills#bundled-skills).** プロジェクトごとの[スキル](/docs/ja/skills#run-and-verify-your-app)を書くことで、クリーンな環境からプロジェクトのアプリをビルド、起動、操作する方法を `/run` と `/verify` に教えます |
| `/sandbox` | [サンドボックスモード](/docs/ja/sandboxing)を切り替えます。サポートされているプラットフォームでのみ利用可能です |
| `/schedule [description]` | クラウドで実行される[ルーティン](/docs/ja/routines)を作成、更新、一覧表示、または実行します。Claude はセットアップを会話形式でガイドします。[ルーティンの最近の実行](/docs/ja/routines#manage-routines-from-the-cli)について質問することもできます。エイリアス：`/routines` |
| `/scroll-speed` | マウスホイールの[スクロール速度](/docs/ja/fullscreen#mouse-wheel-scrolling)をインタラクティブに調整します。[フルスクリーンレンダリング](/docs/ja/fullscreen)でのみ利用可能で、JetBrains IDE ターミナルでは利用できません |
| `/security-review` | 現在のブランチの変更をセキュリティ脆弱性について分析します。ブランチと origin のデフォルトブランチ間の差分をレビューし、インジェクション、認証の問題、データ公開などのリスクを特定します。`origin` リモートが必要です。レビューが `ambiguous argument` エラーで失敗した場合、[エラーリファレンス](/docs/ja/errors#security-review-fails-without-origin-head)を参照してください |
| `/setup-bedrock` | インタラクティブなウィザードを通じて [Amazon Bedrock](/docs/ja/amazon-bedrock) の認証、リージョン、モデルピンを設定します。`CLAUDE_CODE_USE_BEDROCK=1` が設定されるまで[コマンドメニューから非表示](#how-the-command-menu-matches-what-you-type)です。完全に入力してください。初めて Amazon Bedrock を使用するユーザーはログイン画面からこのウィザードにアクセスすることもできます |
| `/setup-vertex` | インタラクティブなウィザードを通じて [Google Cloud の Agent Platform](/docs/ja/google-vertex-ai) の認証、プロジェクト、リージョン、モデルピンを設定します。`CLAUDE_CODE_USE_VERTEX=1` が設定されるまで[コマンドメニューから非表示](#how-the-command-menu-matches-what-you-type)です。完全に入力してください。初めて Google Cloud の Agent Platform を使用するユーザーはログイン画面からこのウィザードにアクセスすることもできます |
| `/simplify [target]` | **[Skill](/docs/ja/skills#bundled-skills).** 変更されたコードをクリーンアップの機会についてレビューし、修正を適用します。4 つのレビュー[エージェント](/docs/ja/sub-agents)が並列で実行され、既存のヘルパーの再利用、簡略化、効率、変更が適切な抽象化レベルにあるかどうかをカバーします。レビューは正確性バグを探しません。バグを見つけるには `/code-review` を使用してください。パスまたは PR リファレンスを渡して特定のターゲットをレビューします |
| `/skill-doctor` | 各[スキル](/docs/ja/skills)がコンテキストでどれだけのコストを占めるか、およびどのくらいの頻度で使用されるかを表示して、[オフにするスキルを見つけ](/docs/ja/skills#find-unused-skills)られるようにします。Claude Code v2.1.252 以降と[フィーチャーフラグフェッチング](/docs/ja/env-vars#features-that-need-feature-flag-fetching)が必要です |
| `/skills` | 利用可能な[スキル](/docs/ja/skills)を一覧表示します。入力して名前、説明、またはソースでリストをフィルタリングします。`t` を押してトークン数でソートし、`Space` または `Enter` を押して[Claude と `/` メニューに対するスキルの可視性を切り替え](/docs/ja/skills#override-skill-visibility-from-settings)、`Esc` を押して保存して閉じます。プラグインスキル、フロントマターで `disable-model-invocation: true` を設定しているスキル、または管理設定や `--settings` フラグに `skillOverrides` エントリがあるスキルは切り替えできません |
| `/slides [brief]` | **[Skill](/docs/ja/skills#bundled-skills).** ブリーフの内容で埋めた新しいプレゼンテーションを Claude Slides [アーティファクト](/docs/ja/artifacts#make-a-slide-deck)として作成します。たとえば `/slides a quarterly review of the platform team`。Claude Code v2.1.265 以降が必要です。[アーティファクトが利用可能](/docs/ja/artifacts#availability)なセッション、およびアカウントで [Slides テンプレートが利用可能](/docs/ja/artifacts#start-from-a-slides-design-or-docs-template)である必要があります。そうでない場合、コマンドは表示されません。Anthropic API で利用可能です。Amazon Bedrock、Google Cloud の Agent Platform、Microsoft Foundry、および Claude Platform on AWS では、アーティファクトが利用できないため、コマンドは利用できません |
| `/stats` | `/usage` のエイリアス。Stats タブで開きます |
| `/status` | 設定インターフェイスを Status タブで開き、バージョン、モデル、アカウント、接続性を表示します。`Session kind` 行は、[バックグラウンドセッション](/docs/ja/agent-view)ではターミナルがアタッチされているかどうかに応じて `background job · attached` または `background job · unattended` と表示され、その他のセッションでは `interactive` と表示されます。v2.1.221 より前は、`/status` はこの行を表示しませんでした。Claude が応答している間も機能します |
| `/statusline` | Claude Code の[ステータスライン](/docs/ja/statusline)を設定します。何をしたいかを説明するか、引数なしで実行してシェルプロンプトから自動設定します |
| `/stickers` | Claude Code ステッカーを注文します |
| `/stop` | アタッチしている[バックグラウンドセッション](/docs/ja/agent-view)、または[ピーク返信](/docs/ja/agent-view#peek-and-reply)として送信した先のセッションを停止します。トランスクリプトと worktree は保持されます。停止せずにデタッチするには、`/exit` を使用するか、`←` を押します |
| `/subtask <task>` | [フォークされたサブエージェント](/docs/ja/sub-agents#fork-the-current-conversation)を生成します：完全な会話を継承し、ユーザーが作業を続けている間にタスクに取り組むバックグラウンドサブエージェントです。その結果は完了時にこの会話に戻ります。代わりに会話を別のバックグラウンドセッションにコピーするには、`/fork` を使用します。Claude Code v2.1.212 以降が必要です。v2.1.161 ～ v2.1.211 では、このコマンドは `/fork` です。[agent view がオフ](/docs/ja/agent-view#turn-off-agent-view)になっている場合、`/subtask` は利用できず、`/fork` がフォークされたサブエージェントの動作を維持します |
| `/tasks` | 完了したサブエージェントを含む、現在のセッションのバックグラウンド作業を表示および管理します。`/bashes` としても利用可能です |
| `/team-onboarding` | Claude Code の使用履歴からチームオンボーディングガイドを生成します。Claude は過去 30 日間のセッション、コマンド、MCP サーバーの使用状況を分析し、チームメイトが最初のメッセージとして貼り付けて素早くセットアップできる markdown ガイドを生成します。Pro、Max、Team、Enterprise プランの claude.ai サブスクライバーには、チームメイトが Claude Code で直接開くことができる共有リンクも返します |
| `/teleport` | [クラウドセッション](/docs/ja/claude-code-on-the-web#from-cloud-to-terminal)をこのターミナルに取り込みます。ピッカーを開き、ブランチと会話をフェッチします。`/tp` としても利用可能です。claude.ai サブスクリプションが必要です |
| `/terminal-setup` | VS Code、Cursor、Devin Desktop、Alacritty、または Zed で[改行用の Shift+Enter キーボードショートカットをインストール](/docs/ja/terminal-config#enter-multiline-prompts)します。Apple Terminal では、代わりに[改行用に Option+Enter を有効にして、可聴ベルをオフ](/docs/ja/terminal-config#enable-option-key-shortcuts-on-macos)にします。iTerm2 では、[`/copy` が機能するようにクリップボードアクセスをオン](/docs/ja/terminal-config#enable-option-key-shortcuts-on-macos)にします |
| `/theme` | カラーテーマを変更します。ターミナルの明るいまたは暗い背景に一致する `auto` オプション、明るいおよび暗い変種、色覚異常対応（daltonized）テーマ、ターミナルのカラーパレットを使用する ANSI テーマ、および `~/.claude/themes/` またはプラグインからの[カスタムテーマ](/docs/ja/terminal-config#create-a-custom-theme)を含みます。**New custom theme…** を選択して 1 つを作成します |
| `/tui [default\|fullscreen]` | ターミナル UI レンダラーを設定し、会話をそのまま保持して再起動します。`fullscreen` は[ちらつきのない alt-screen レンダラー](/docs/ja/fullscreen)を有効にします。引数がない場合、アクティブなレンダラーを出力します |
| `/ultraplan <prompt>` | 削除されました。代わりに [plan モード](/docs/ja/permission-modes#analyze-before-you-edit-with-plan-mode)を使用してください。以前は計画タスクを[クラウドセッション](/docs/ja/claude-code-on-the-web)に送信してブラウザで確認しました |
| `/ultrareview [PR or branch]` | [ultrareview](/docs/ja/ultrareview) を使用してクラウドサンドボックスでディープなマルチエージェントコードレビューを実行します。PR リファレンスを渡してそのプルリクエストをレビューするか、ベースブランチまたはコミットを渡して比較ベースを変更します。推奨される呼び出しは `/code-review ultra` で、`/ultrareview` はエイリアスです。Pro および Max で 3 回の無料実行が含まれ、その後は[使用クレジット](https://support.claude.com/en/articles/12429409-extra-usage-for-paid-claude-plans)が必要です |
| `/update-config [request]` | **[Skill](/docs/ja/skills#bundled-skills).** コマンドを許可する、環境変数を設定する、[フック](/docs/ja/hooks)を追加するなどの設定変更を説明すると、Claude は該当する [`settings.json`](/docs/ja/settings) ファイルを編集します。テーマやモデルなどのオプションについては、代わりに `/config` を使用してください |
| `/upgrade` | ブラウザでアップグレードページを開いて、より上位のプランティアに切り替えます。ブラウザが開かない場合、コマンドは URL を出力せずにサインインプロンプトを表示します |
| `/usage` | セッションコスト、プランの使用制限、アクティビティ統計を表示します。Pro、Max、Team、または Enterprise プランでは、[プラン制限に対してカウントされるもの](/docs/ja/costs#plan-usage-breakdown)の内訳が含まれます。`/cost` と `/stats` はエイリアスです |
| `/usage-credits` | 制限に達したときに使用クレジットを設定するか、管理者に要求します。ブラウザで[使用クレジットの請求設定](/docs/ja/costs#add-usage-credits-to-your-subscription)を開きます。ただし、請求アクセスを持たない Team および Enterprise メンバーは、リクエストが管理者に通知されることをダイアログで確認した後、代わりに CLI から管理者に使用クレジットのリクエストを送信します。SSH 経由など、ブラウザで請求ページを開けない場合、コマンドは代わりにアクセスする URL を出力します。これには Claude Code v2.1.205 以降が必要で、以前のバージョンはこの場合に何も表示しませんでした。以前は `/extra-usage` |
| `/verify` | **[Skill](/docs/ja/skills#bundled-skills).** テストや型チェックに頼るのではなく、プロジェクトのアプリをビルド、実行し、結果を観察することで、コード変更が意図どおりに動作することを確認します。[アプリを実行して検証する](/docs/ja/skills#run-and-verify-your-app)を参照してください |
| `/vim` | v2.1.92 で削除されました。Vim と Normal 編集モード間を切り替えるには、`/config` → Editor mode を使用してください |
| `/voice [hold\|tap\|off]` | [音声入力](/docs/ja/voice-dictation)を切り替えるか、特定のモードで有効にします。Claude.ai アカウントが必要です |
| `/web-setup` | ローカルの `gh` CLI 認証情報を使用して、[クラウドセッション](/docs/ja/web-quickstart#connect-from-your-terminal)用に GitHub アカウントを接続します |
| `/workflow-authoring` | **[Skill](/docs/ja/skills#bundled-skills).** [動的ワークフロー](/docs/ja/workflows)スクリプトを書くためのリファレンスを読み込みます：スクリプト API、再開動作、品質パターン、実装例。Claude は通常、スクリプトを書く前にそれを自動的に読み込みます。[保存されたスクリプトを手で編集する](/docs/ja/workflows#edit-a-saved-script)前に自分で実行してください。動的ワークフローが有効な場合に利用可能で、Claude Code v2.1.248 以降が必要です |
| `/workflows` | [ワークフロー](/docs/ja/workflows#watch-the-run)の進捗ビューを開いて、実行中および完了したワークフローを監視、一時停止、再開、または保存します |

<h2 id="how-the-command-menu-matches-what-you-type">
  コマンドメニューが入力内容にどのようにマッチするか
</h2>

Claude Code は、入力時に `/` メニューをフィルタリングします。以下の各項目は、フィルタリング中に気付く可能性のあることを説明しています。

* **ハイライト表示**: Claude Code は、`/` の後の文字がコマンド名またはエイリアスの名前の開始位置から、または名前内の単語から一致する場合にのみ、トップの提案をハイライト表示します。`:` 、`_` 、および `-` セパレータは無視されます。`/adddir` と入力するとハイライト表示は `/add-dir` になり、`/new` と入力するとそのエイリアスを通じて `/clear` がハイライト表示されます。`Enter` キーを押してハイライト表示された提案を実行します。これらのハイライト表示ルールには Claude Code v2.1.236 以降が必要です。
* **タイプミスの後**: Claude Code はハイライト表示されません。近い一致はリストに残り、`Tab` または矢印キーで選択できますが、`Enter` キーを押すと入力したテキストがそのまま送信され、[不明なコマンド](/docs/ja/errors#unknown-command)が報告されます。
* **利用できないコマンド**: Claude Code はメニューからそれらを除外します。何も一致しない場合、Claude Code は `No commands match "/name"` と表示します。ほとんどの利用できないコマンドは、送信時に[不明なコマンド](/docs/ja/errors#unknown-command)を返します。ただし、[Console API キーの `/schedule`](/docs/ja/routines#schedule-returns-unknown-command)など、独自の利用可能性メッセージで応答するものもあります。組織のポリシーがコマンドを無効にしている場合、一部のコマンドは独自のメッセージで応答します。
* **非表示コマンド**: Claude Code は、`/heapdump` などの利用可能なコマンドをいくつか、設計上の理由からメニューから除外しています。部分的な名前は非表示コマンドをメニューに表示させることはありません。部分的な一致が表示されるものと一致しない場合、Claude Code は同じ一致なしメッセージを表示します。完全な名前を入力すると、Claude Code はコマンドを一度だけリストに表示し、完全な名前を送信するとそれを実行します。

<h2 id="mcp-prompts">
  MCP プロンプト
</h2>

MCP サーバーはコマンドとして表示されるプロンプトを公開できます。詳細については、[MCP プロンプト](/docs/ja/mcp#use-mcp-prompts-as-commands)を参照してください。

<h2 id="see-also">
  関連項目
</h2>

* [スキル](/docs/ja/skills): 独自のコマンドを作成
* [インタラクティブモード](/docs/ja/interactive-mode): キーボードショートカット、Vim モード、およびコマンド履歴
* [CLI リファレンス](/docs/ja/cli-reference): 起動時フラグ
