> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# Claude Code がプロンプトキャッシングを使用する方法

> Claude Code はプロンプトキャッシングを自動的に管理します。モデル切り替えがキャッシュなしの遅いターンをトリガーする理由、`/compact` のコスト、CLAUDE.md の編集がセッション中に適用されない理由、キャッシュヒット率を確認する方法を確認してください。

プロンプトキャッシングにより、Claude Code はより高速で費用効率的になります。キャッシングがなければ、API はターンごとに完全な履歴を再処理します。キャッシングがあれば、既に処理したものを再利用し、再読み込みを[キャッシュされたトークンレート](https://platform.claude.com/docs/en/about-claude/pricing)で請求し、変更されたものに対してのみ完全に処理します。

Claude Code はプロンプトキャッシングを自動的に処理します。ただし、[無効にする](#disable-prompt-caching)ことはできます。プロンプトキャッシングの仕組みを理解することは依然として有用です。キャッシュを無効にするアクションがあり、次の応答が遅くなり、再構築中により高くなるためです。このページでは、どのアクションがそうであるか、一部の設定が再起動を待つ理由、使用量が高く見える場合にキャッシュパフォーマンスを確認する方法について説明します。

<h2 id="how-the-cache-is-organized">
  キャッシュの構成方法
</h2>

Claude Code でメッセージを送信するたびに、新しい API リクエストが行われます。モデルはリクエスト間で何も記憶しないため、Claude Code は完全なコンテキストを再送信します。システムプロンプト、プロジェクトコンテキスト、すべての以前のメッセージとツール結果、および新しいメッセージです。新しいコンテンツは最後に追加されます。つまり、各リクエストのほとんどは前のリクエストと同じです。プロンプトキャッシングは、API が変更されなかった部分を再処理しないようにする方法です。

API は、プリフィックスと呼ばれる各リクエストの開始を、最近処理したコンテンツと照合することでキャッシュします。通常のターンでは、プリフィックスは前のリクエスト全体であり、最新の交換のみが新しいものです。一致は正確であるため、プリフィックスのどこかの変更は、その後のすべてを再計算します。ファイルごとまたはセグメントごとのキャッシングはありません。API リファレンスの[プロンプトキャッシングの仕組み](https://platform.claude.com/docs/en/build-with-claude/prompt-caching#how-prompt-caching-works)を参照して、基礎となるメカニズムを確認してください。

<img src="https://mintcdn.com/claude-code/VbDJw--l6T9a9Wvm/images/prompt-caching-prefix.svg?fit=max&auto=format&n=VbDJw--l6T9a9Wvm&q=85&s=f2e8f0b8298a50305fe428ca3f1d1594" className="dark:hidden" alt="4 つのターンが成長する水平バーとして表示されます。各ターンのリクエストには、前のターンのすべてと最新の交換が最後に追加されたものが含まれます。ターン 2 と 3 では、変更されていないプリフィックスはキャッシュから読み取られ、新しい交換のみが処理されます。ターン 4 では、システムプロンプトが変更されたため、プリフィックスは一致しなくなり、リクエスト全体が再処理されて書き込まれます。" width="720" height="454" data-path="images/prompt-caching-prefix.svg" />

<img src="https://mintcdn.com/claude-code/_xqph1dUOslCOwsj/images/prompt-caching-prefix-dark.svg?fit=max&auto=format&n=_xqph1dUOslCOwsj&q=85&s=297dc1c639f0915cae858d0c4b6f3be5" className="hidden dark:block" alt="4 つのターンが成長する水平バーとして表示されます。各ターンのリクエストには、前のターンのすべてと最新の交換が最後に追加されたものが含まれます。ターン 2 と 3 では、変更されていないプリフィックスはキャッシュから読み取られ、新しい交換のみが処理されます。ターン 4 では、システムプロンプトが変更されたため、プリフィックスは一致しなくなり、リクエスト全体が再処理されて書き込まれます。" width="720" height="454" data-path="images/prompt-caching-prefix-dark.svg" />

プリフィックスマッチングを最大限に活用するために、Claude Code は各リクエストを順序付けして、ターン間で変更されることがめったにないコンテンツが最初に来るようにします。

| レイヤー         | コンテンツ                      | 変更される場合                                                      |
| ------------ | -------------------------- | ------------------------------------------------------------ |
| システムプロンプト    | コア命令、ツール定義、出力スタイル          | 読み込まれたツール定義のセットが変更されるか、出力スタイルを切り替えるか、Claude Code がアップグレードされる |
| プロジェクトコンテキスト | CLAUDE.md、自動メモリ、スコープなしのルール | セッション開始時、または `/clear` または `/compact` の後                      |
| 会話           | メッセージ、Claude の応答、ツール結果     | すべてのターン                                                      |

会話レイヤーへの変更は、システムプロンプトとプロジェクトコンテキストをキャッシュしたままにします。システムプロンプトへの変更は、すべての後続コンテンツが異なるプリフィックスの後ろに配置されるため、すべてを無効にします。3 番目の列は、完全なリストではなく一般的なトリガーを示しており、以下のセクションでは完全なセットについて説明します。

プリフィックスマッチルールは、このページのほとんどの動作を説明しています。たとえば、[Plan mode](/docs/ja/permission-modes#analyze-before-you-edit-with-plan-mode) と[スキル読み込み](/docs/ja/skills)は、会話メッセージとして命令を追加するため、キャッシュされたプリフィックスはそのままです。

2 つの設定はレイヤーテーブルに表示されませんが、キャッシュされたままのものに影響を与えます。

* **モデル**: 各モデルは独自のキャッシュを持ちます。モデルを切り替えると、コンテンツが同じであっても、リクエスト全体が再計算されます。以下の[モデルの切り替え](#switching-models)を参照してください。
* **努力レベル**: ほとんどのモデルでは、各努力レベルは独自のキャッシュを持つため、セッション中に変更するとリクエスト全体が再計算されます。API キーまたは Claude サブスクリプションを使用する Fable 5.1 では、デフォルトでキャッシュはそのままです。以下の[努力レベルの変更](#changing-effort-level)を参照してください。

<Tip>
  セッションの最初にモデルと努力レベルを選択してから、タスク間の自然な区切りのために `/compact` を保存します。タスク中に行う変更が少ないほど、キャッシュヒット率が高くなります。
</Tip>

<h3 id="where-the-cache-lives">
  キャッシュが存在する場所
</h3>

キャッシングはサーバー側で行われ、モデルを提供するインフラストラクチャで行われます。その場所は、認証方法によって異なります。

* **API キー、Claude サブスクリプション、または[Claude Platform on AWS](/docs/ja/claude-platform-on-aws)**: キャッシュは Anthropic のインフラストラクチャに存在し、[Claude API](https://platform.claude.com/docs) を通じてアクセスされます
* **Amazon Bedrock または Google Cloud の Agent Platform**: キャッシュはクラウドプロバイダーのサービングインフラストラクチャに存在します
* **Microsoft Foundry**: デプロイメントの[ホスティングオプション](https://platform.claude.com/docs/en/build-with-claude/claude-in-microsoft-foundry#hosting-options)に依存します。Azure にホストされているデプロイメントは Azure インフラストラクチャで提供されます。Anthropic にホストされているデプロイメントは Anthropic のインフラストラクチャで提供されます
* **カスタム `ANTHROPIC_BASE_URL` または[LLM gateway](/docs/ja/llm-gateway)**: キャッシュはリクエストが転送される場所に存在し、キャッシングが機能するかどうかはゲートウェイに依存します

Claude Code は会話の途中でシステムコンテキスト（ファイル変更通知など）を追加し、すべてのプロバイダーと接続でそのブロックをキャッシング用にマークします。

プロバイダー自身のエンドポイントでは、Amazon Bedrock とその[Mantle エンドポイント](/docs/ja/amazon-bedrock#use-the-mantle-endpoint)、Google Cloud の Agent Platform、および Microsoft Foundry は、Claude API と同じ方法でブロックをキャッシュします。

リクエストが[LLM gateway](/docs/ja/llm-gateway)、カスタム `ANTHROPIC_BASE_URL`、または [`ANTHROPIC_BEDROCK_BASE_URL`](/docs/ja/env-vars) などのクラウドプロバイダーベース URL オーバーライドを通じて渡される場合、キャッシュされたままのものは、ゲートウェイが Claude Code が送信する[`cache_control` マーカー](https://platform.claude.com/docs/en/build-with-claude/prompt-caching#explicit-cache-breakpoints)をどのように処理するかに依存します。

* **変更されずに転送する**: ブロックと会話は、プロバイダー自身のエンドポイントと同じようにキャッシュされます。
* **`cache_control` を名前に含む `400` エラーでマークされたリクエストを拒否する**: Claude Code はマーカーをブロックから最後の会話メッセージに移動させてリクエストを再送信し、会話の残りの部分でそこに保持します。ブロックはキャッシュされていない入力として請求されます。会話はキャッシュされたままです。
* **成功を返しながらマーカーを削除する**: 会話履歴全体は、すべてのターンでキャッシュされていない入力として請求されます。ブロック形式のシステムコンテンツをプレーンな文字列に変換するゲートウェイは、同じ方法でマーカーを削除します。

各プロバイダーが保存および処理するものについては、[データ使用](/docs/ja/data-usage)を参照してください。キャッシュがどこに存在するかに関わらず、エントリは非アクティブ期間後に期限切れになり、以下の[キャッシュライフタイム](#cache-lifetime)は TTL とそれを延長する方法について説明します。

<h2 id="actions-that-invalidate-the-cache">
  キャッシュを無効にするアクション
</h2>

これらのアクションにより、次のリクエストはキャッシュの一部またはすべてをミスします。1 回限りの遅く、より高価なターンが表示され、その後、新しいプリフィックスがキャッシュされます。ほとんどは、コストがあることを知ったら、タスク中に回避可能です。モデル切り替えは、その後の遅いターンに気付くまで無料に感じることができます。

* [モデルの切り替え](#switching-models)
* [努力レベルの変更](#changing-effort-level)
* [高速モードの有効化](#turning-on-fast-mode)
* [MCP サーバーの接続または切断](#connecting-or-disconnecting-an-mcp-server)
* [プラグインの有効化または無効化](#enabling-or-disabling-a-plugin)
* [ツール全体の拒否](#denying-an-entire-tool)
* [出力スタイルの変更](#changing-output-style)
* [会話のコンパクト化](#compacting-the-conversation)
* [多くの画像の蓄積](#accumulating-many-images)
* [Claude Code のアップグレード](#upgrading-claude-code)

<h3 id="switching-models">
  モデルの切り替え
</h3>

各モデルは独自のキャッシュを持ちます。[`/model`](/docs/ja/model-config#setting-your-model) で切り替えると、次のリクエストはコンテンツが同じであっても、キャッシュヒットなしで会話履歴全体を読み取ります。

ターミナルで `/model` を実行すると、Claude Code はキャッシュがまだ温かい間のみ切り替えを確認するよう求めます。キャッシュは、Claude Code がこの会話で最後にリクエストを送信した後、または Claude が最後に応答した後、1 つの[キャッシュ TTL](#cache-lifetime) の間、温かいままです。その時間が経過すると、キャッシュは期限切れになるため、Claude Code は確認なしに切り替えます。

v2.1.238 より前では、Claude Code はキャッシュ TTL をチェックせず、キャッシュが期限切れになった後でも確認を求めていました。

[PreModelSwitch フック](/docs/ja/hooks#premodelswitch-decision-control)を使用して、この確認を必須にするか、スキップすることもできます。

[`opusplan` モデル設定](/docs/ja/model-config#opusplan-model-setting)は、Plan Mode 中に Opus に、実行中に Sonnet に解決されるため、各 Plan Mode トグルはモデル切り替えであり、新しいキャッシュを開始します。

[Fable モデルと Opus 5 での自動モデルフォールバック](/docs/ja/model-config#automatic-model-fallback)もモデル切り替えです。安全性分類器がフォールバックモデルを持つカテゴリーでリクエストにフラグを立てると、Claude Code はそのモデルでリクエストを再実行し、セッションはそこで続行されます。

スキルまたはコマンドのフロントマターがセッションの現在のモデル以外の[`model`](/docs/ja/skills#frontmatter-reference)を指定する場合、そのターンもモデル切り替えです。次のリクエストはキャッシュヒットなしで会話履歴全体を読み取ります。セッションモデルは次のプロンプトで再開されます。`context: fork` スキルは、代わりに[フォークされたサブエージェントのモデル](/docs/ja/skills#run-skills-in-a-subagent)を設定します。

<h3 id="changing-effort-level">
  努力レベルの変更
</h3>

ほとんどのモデルでは、セッション中に[努力レベル](/docs/ja/model-config#adjust-effort-level)を変更すると、次のリクエストはキャッシュヒットなしで会話履歴全体を読み取ります。キャッシュがまだ温かい間、Claude Code は最初に変更を確認するよう求めます。

API キーまたは Claude サブスクリプションを使用した Fable 5.1 では、努力レベルを変更するとキャッシュが保持され、Claude Code は確認なしに新しいレベルを適用します。これは Amazon Bedrock、Google Cloud の Agent Platform、または[Claude アプリゲートウェイ](/docs/ja/claude-apps-gateway)には適用されません。また、[`CLAUDE_CODE_DISABLE_EXPERIMENTAL_BETAS`](/docs/ja/llm-gateway-protocol#disable-pre-release-capabilities)を設定した場合、または組織が HIPAA 設定を持つ場合にも適用されません。

v2.1.260 より前では、API キーまたは Claude サブスクリプションを使用した Fable 5.1 での努力レベルの変更もキャッシュを無効にしていました。

<h3 id="turning-on-fast-mode">
  高速モードの有効化
</h3>

[高速モード](/docs/ja/fast-mode)を有効にすると、キャッシュキーの一部であるリクエストヘッダーが追加されるため、Claude Code が高速モードで送信する最初のリクエストはキャッシュヒットなしで会話履歴全体を読み取ります。Claude Code はターンが開始されるときにそのヘッダーを 1 回設定し、ターン全体でそれを保持するため、Claude が作業中に高速モードをオンにすると、ヘッダーからのキャッシュミスは次のターンの最初のリクエストで発生します。これらのキャッシュされていない入力トークンは[高速モードレート](/docs/ja/fast-mode#understand-the-cost-tradeoff)で課金されます。これが、セッションの開始時に有効にする方が、長いセッションの深くで有効にするよりもコストが低い理由です。現在のモデルが高速モードをサポートしていない場合、高速モードを有効にすると[モデルも切り替わります](#switching-models)。その切り替えは、実行中のターンの次のリクエストから独自に新しいキャッシュを開始します。

コストはキャッシュごとに 1 回適用されます。最初の高速モードターンの後、Claude Code はヘッダーを送信し続け、リクエストの速度設定のみを変更します。これはキャッシュキーの一部ではありません。高速モードをオフにする、[レート制限後の標準速度への自動フォールバック](/docs/ja/fast-mode#handle-rate-limits)、および後で再度有効にすることはすべてキャッシュを保持します。[使用クレジットが不足した](/docs/ja/fast-mode#handle-rate-limits)場合、Claude Code は各拒否された高速モードリクエストを標準速度で同じ方法で再試行するため、このフォールバックもキャッシュを保持します。`/clear` と `/compact` はこれをリセットします。これらはとにかくそれらのポイントでキャッシュを再構築するためです。

<h3 id="connecting-or-disconnecting-an-mcp-server">
  MCP サーバーの接続または切断
</h3>

ツール定義はシステムプロンプトレイヤーに存在するため、リクエスト間でリクエスト内のツール定義のセットが変更されるとキャッシュが無効になります。[advisor ツール](/docs/ja/advisor)のトグルは例外です。その定義はキャッシュブレークポイントの後に存在するため、`/advisor` を有効化または無効化してもキャッシュされたプリフィックスはそのままです。[MCP サーバー](/docs/ja/mcp)の変更がこれを行うかどうかは、そのツールが[ツール検索](/docs/ja/mcp#scale-with-mcp-tool-search)によって遅延されるか、プリフィックスに読み込まれるかによって異なります。

* **遅延ツール**、サポートされているモデルのデフォルト：サーバーの接続、切断、またはツールリストの変更は、新しいコンテンツのみを追加し、既にキャッシュされているものを妨害しません。
* **プリフィックスに読み込まれるツール**：それらへの変更はキャッシュを無効にします。これは[ツール検索が利用不可または無効](/docs/ja/mcp#configure-tool-search)な場合に発生します。Google Cloud の Agent Platform モデルが Claude 4.5 世代より前の場合、カスタム `ANTHROPIC_BASE_URL` ゲートウェイ、または Claude Code がデプロイメントがツール検索を拒否することを検出した Microsoft Foundry [Azure でホストされているデプロイメント](https://platform.claude.com/docs/en/build-with-claude/claude-in-microsoft-foundry#hosting-options)など。また、[`alwaysLoad`](/docs/ja/mcp#exempt-a-server-from-deferral)とマークされたサーバーまたはツール、および[しきい値ベースの読み込み](/docs/ja/mcp#configure-tool-search)によって前もって保持される定義についても発生します。

ツールがプリフィックスに読み込まれる場合、無効化の最も一般的な原因は、セッション中にサーバーが接続または切断されることです。これはアクションなしで発生する可能性があります。stdio サーバーのプロセスが終了するか、HTTP セッションが期限切れになるか、サーバーが[一時的な障害後に自動的に再接続](/docs/ja/mcp#automatic-reconnection)します。接続されたサーバーは、ツールリストを変更する[動的ツール更新](/docs/ja/mcp#dynamic-tool-updates)をプッシュすることもできます。

MCP 設定を編集しても、それ自体ではキャッシュは変更されません。新しい設定は再起動後にのみ有効になります。これは、サーバーが接続または切断されるときです。

<h3 id="enabling-or-disabling-a-plugin">
  プラグインの有効化または無効化
</h3>

[プラグイン](/docs/ja/plugins)を有効化または無効化する場合、変更のコストはプラグインが提供するコンポーネントタイプによって異なります。以下のケースは、各コンポーネントタイプ、Claude Code が変更を適用するタイミング、および同じセッションでプラグインを再度無効化するときに何が起こるかをカバーしています。

<h4 id="plugin-components-that-keep-the-cache">
  キャッシュを保持するプラグインコンポーネント
</h4>

Claude Code は、プラグインのスキル、コマンド、エージェント、フック、モニター、またはテーマのキャッシュを無効にしません。それらのコンテンツは既存の会話の後に追加されるため、次のリクエストはそのコンテンツに対して支払いますが、それでもその前のすべてをキャッシュから読み取ります。

<h4 id="plugins-that-provide-mcp-servers">
  MCP サーバーを提供するプラグイン
</h4>

[MCP サーバー](/docs/ja/plugins-reference#mcp-servers)を提供するプラグインを有効化または無効化する場合、Claude Code は[MCP サーバーの接続または切断](#connecting-or-disconnecting-an-mcp-server)時と同じルールに従います。

* Claude Code がサーバーのツールを遅延させる場合、キャッシュが保持されます。
* Claude Code がそれらをプリフィックスに読み込む場合、次のリクエストは会話全体を再度読み取ります。

<h4 id="code-intelligence-plugins">
  コード インテリジェンス プラグイン
</h4>

[コード インテリジェンス プラグイン](/docs/ja/discover-plugins#code-intelligence)を有効化すると、Claude は[LSP ツール](/docs/ja/tools-reference#lsp-tool-behavior)を取得します。

<h4 id="when-plugin-changes-apply">
  プラグイン変更が適用されるタイミング
</h4>

Claude Code は、[`/reload-plugins`](/docs/ja/discover-plugins#apply-plugin-changes-without-restarting)を実行するか、新しいセッションを開始するときにプラグイン変更を適用します。コスト（追加されたアナウンスメントまたは完全な再読み取り）は、`/plugin enable` または `/plugin disable` を実行するときではなく、変更が適用された後の最初のターンに表示されます。Claude Code は 3 つのケースで独自に変更を適用することもできます。

* `command` ソースを持つプラグインの場合、Claude Code は[プラグイン自体を再度読み込むことができます](/docs/ja/plugin-marketplaces#when-claude-code-re-runs-the-command)。
* [`/plugin` インターフェースからプラグインをインストール](/docs/ja/discover-plugins#install-plugins)する場合、Claude Code はインストール中にそれを有効化できます。Claude Code はインストール概要でそれを行ったかどうか、または `/reload-plugins` を実行するかどうかを通知します。
* v2.1.246 以降で[`/cd`](/docs/ja/permissions#move-the-session-to-another-directory)でセッションを移動する場合、Claude Code は移動の一部として新しいディレクトリの設定が有効にするプラグインを適用します。これは `/reload-plugins` を保持する完全な再読み取り警告なしです。

`/reload-plugins` を実行してリロードが完全な再読み取りをトリガーする場合、Claude Code は警告を表示し、リロードを適用しません。`--force` を使用して再実行して、とにかくリロードを適用します。

`/reload-plugins` は、デスクトップアプリ、Agent SDK、および[非対話型モード](/docs/ja/headless)（`-p` 付き）など、対話型ターミナルがないセッションでも実行されます。セッションに直接入力する場合。Claude Code v2.1.260 以降が必要です。

これらのセッションではリロードはプラグイン MCP サーバー変更以外のすべてを適用します。これは[次のセッションで有効になり](/docs/ja/discover-plugins#apply-plugin-changes-without-restarting)、セッション中に完全な再読み取りのコストが発生することはありません。

<h4 id="plugins-you-enable-and-then-disable-in-one-session">
  1 つのセッションで有効化してから無効化するプラグイン
</h4>

セッションの前半で有効にしたプラグインを無効化すると、Claude Code は以前のリクエスト形状を復元します。そのプリフィックスがまだ[キャッシュライフタイム](#cache-lifetime)内にある場合、次のリクエストは再構築するのではなく、古いキャッシュエントリを読み取ります。

<h3 id="denying-an-entire-tool">
  ツール全体の拒否
</h3>

`Bash` や `WebFetch` のような裸のツール名を[拒否ルール](/docs/ja/permissions#manage-permissions)として追加すると、そのツールは Claude のコンテキストから完全に削除されます。Claude Code は組み込みツール定義をシステムプロンプトレイヤーに読み込むため、セッション中にこれらのルールの 1 つを追加または削除するとキャッシュが無効になります。Claude Code は、`/permissions` を通じてルールを追加するか、[設定ファイルを直接編集](/docs/ja/settings#when-edits-take-effect)するかにかかわらず、次のリクエストで変更を適用します。これには、ターンの途中で `/permissions` を通じて追加するルールが含まれます。

ツール名位置で一致する拒否ルールのみがこの効果を持ちます。裸のツール名、同等の `Bash(*)` 形式、または[ツール名グロブ](/docs/ja/permissions#tool-name-wildcards)（`"*"` など）。`"mcp__*"` のような MCP ツールのみに一致するグロブは、それらのツールを同じ方法で削除しますが、一致したツールが[遅延](#connecting-or-disconnecting-an-mcp-server)されている場合、デフォルトではキャッシュはそのままです。遅延定義はキャッシュされたプリフィックスに含まれていなかったため。`Bash(rm *)` のようなスコープ付き拒否ルール、およびすべての許可ルールと質問ルールは、Claude が見るツールを変更しません。Claude Code は Claude が呼び出しを試みるときにそれらをチェックし、プリフィックスをそのままにします。

<h3 id="changing-output-style">
  出力スタイルの変更
</h3>

[出力スタイル](/docs/ja/output-styles)はシステムプロンプトの一部です。`/config` または `outputStyle` 設定でセッション中にスタイルを切り替えると、Claude は次のメッセージから新しいスタイルを使用し、そのリクエストはキャッシュヒットなしで会話履歴全体を読み取ります。そのコストを小さく保つには、セッションの最初のメッセージの前、または `/clear` または `/compact` の直後にスタイルを切り替えます。このときは会話履歴がほとんどまたはまったくありません。

v2.1.251 より前では、セッション中のスタイル切り替えはキャッシュを保持していましたが、`/clear` を実行するか新しいセッションを開始するまで適用されませんでした。

<h3 id="compacting-the-conversation">
  会話のコンパクト化
</h3>

[コンパクト化](/docs/ja/context-window#what-survives-compaction)は、メッセージ履歴を要約に置き換えます。設計上、これは会話レイヤーを無効にします。次のリクエストには、古いものとプリフィックスを共有しない新しい、より短い履歴があるためです。Claude Code はシステムプロンプトレイヤーを再利用し、ディスクからプロジェクトコンテキストを再度読み込みます。これは、セッション開始以降 CLAUDE.md とメモリが変更されていない場合にのみキャッシュヒットします。

要約を生成するために、Claude Code は、会話と同じシステムプロンプト、ツール、履歴を持つ別のリクエストを送信し、最終ユーザーメッセージとして要約命令を追加します。キャッシュがまだ温かい間、そのリクエストはキャッシュからプリフィックスを読み取るため、セッション中の `/compact` はコンテキストサイズが示唆するコストのほんの一部であり、ほとんどの時間を要約の生成に費やします。

[キャッシュライフタイム](#cache-lifetime)より長い休止の後、読み取るキャッシュが残っていないため、要約リクエストはキャッシュされていない入力として完全な履歴を再処理します。これが、[古いセッションを再開](/docs/ja/sessions#resume-from-a-summary)するときに `/compact` のコストが最も高い理由です。温かいケースと冷たいケースの両方で、コンパクト化後のターンは、はるかに短い要約に対してのみ会話キャッシュを再構築するため、そのターンは遅い部分ではありません。

<Tip>
  コンパクト化は、不要になったコンテンツを破棄する場合に有利に機能します。オーバーヘッドが発生するタイミングを選択するには、タスク間などの作業の自然な区切りで `/compact` を実行します。完全に放棄したいパスに進んだ場合は、代わりに[`/rewind`](#rewinding-the-conversation)を使用して以前のターンに戻ります。巻き戻しは、コンパクト化が行うように新しいものを構築するのではなく、既にキャッシュされているプリフィックスに切り詰めます。
</Tip>

<h3 id="accumulating-many-images">
  多くの画像の蓄積
</h3>

API は、各リクエストが実行できる画像と PDF の数を制限します。現在の数については、API ドキュメントの[リクエスト制限](https://platform.claude.com/docs/en/build-with-claude/vision#request-limits)を参照してください。Claude Code はリクエスト内の画像と PDF の合計サイズもキャップするため、大きなスクリーンショットは小さいものより少ない画像でリミットに達します。

次のリクエストがいずれかのリミットを超える場合、Claude Code は送信する最も古い画像と PDF のバッチを削除します。これにより、再度削除する必要があるまでさらに多くのスペースが確保されます。Claude はもう削除された画像を見ることができません。Claude が再度それらの 1 つが必要な場合は、再度共有してください。

画像を削除すると、それらを保持していたメッセージが変更されるため、次のリクエストはそれらのメッセージの最も早いものから会話を再処理します。Claude Code はバッチごとに削除するため、新しいスクリーンショットごとに 1 つではなく、バッチごとに 1 つの遅いターンが表示されます。

<h3 id="upgrading-claude-code">
  Claude Code のアップグレード
</h3>

新しい Claude Code バージョンは通常、システムプロンプトまたはツール定義を更新するため、アップグレード後の最初のリクエストはキャッシュを最初から再構築します。[自動更新](/docs/ja/setup#auto-updates)は新しいバージョンをバックグラウンドでダウンロードしますが、次の起動時に適用され、セッション中には適用されません。そのため、セッション中のサプライズではなく、再起動後のキャッシュなしの最初のターンとして表示されます。`DISABLE_AUTOUPDATER=1` を設定して、アップグレードが適用されるタイミングを制御します。

<Note>
  [セッションを再開](/docs/ja/sessions#resume-a-session)すると、履歴が異なるシステムプロンプトの後ろに配置されるため、キャッシュヒットなしで会話履歴全体が再処理されます。コストは再開された会話の長さに応じてスケーリングされるため、長いセッションに戻る最初のターンは、送信する最も高価なリクエストになる可能性があります。
</Note>

<h2 id="actions-that-keep-the-cache">
  キャッシュを保持するアクション
</h2>

これらのアクションは、会話の最後に追加するか、リクエストにまったく触れません。CLAUDE.md の編集など、一部は、`/clear`、`/compact`、または再起動を待つ理由でもあります。

* [リポジトリ内のファイルの編集](#editing-files-in-your-repository)
* [セッション中の CLAUDE.md の編集](#editing-claude-md-mid-session)
* [権限モードの変更](#changing-permission-mode)
* [スキルとコマンドの呼び出し](#invoking-skills-and-commands)
* [`/recap` の実行](#running-%2Frecap)
* [会話の巻き戻し](#rewinding-the-conversation)
* [サブエージェントの生成](#subagents-and-the-cache)

<h3 id="editing-files-in-your-repository">
  リポジトリ内のファイルの編集
</h3>

ファイルコンテンツがコンテキストに入るのは Claude が読むときだけであり、読み取りは会話に追加されます。Claude が以前読んだファイルを編集しても、履歴内の以前の読み取りは遡及的に変更されません。代わりに、Claude Code はファイルが変更されたことを示す `<system-reminder>` を追加し、必要に応じて Claude が再度読み取ります。

<h3 id="editing-claude-md-mid-session">
  セッション中の CLAUDE.md の編集
</h3>

プロジェクトルートとユーザーレベルの CLAUDE.md ファイルはセッション開始時に 1 回読み取られ、メモリに保持されます。セッション中に編集してもキャッシュは無効になりませんが、編集も適用されません。Claude はセッション開始時に読み込まれたバージョンで作業を続けます。新しいコンテンツは次の `/clear`、`/compact`、または再起動時に読み込まれます。

[サブディレクトリ内のネストされた CLAUDE.md ファイル](/docs/ja/memory)と[`paths:` frontmatter を持つルール](/docs/ja/memory#path-specific-rules)は、Claude が最初に一致するファイルを読むときに後で読み込まれます。読み込まれる前に編集すると、有効になります。読み込まれた後、コンテンツは会話履歴の一部であるため、セッション中の編集は遡及的に変更されません。

<h3 id="changing-permission-mode">
  権限モードの変更
</h3>

[権限モード](/docs/ja/permission-modes)間の切り替え（Manual から編集受け入れへなど）は、システムプロンプトまたはツール定義を変更しないため、モード変更はキャッシュセーフです。例外は、[`opusplan`](/docs/ja/model-config#opusplan-model-setting) モデル設定を使用した Plan Mode です。これは、Plan Mode に入るか出るときにモデルを Opus と Sonnet の間で切り替えます。これにより、モード切り替えは[モデル切り替え](#switching-models)になります。

<h3 id="invoking-skills-and-commands">
  スキルとコマンドの呼び出し
</h3>

[スキル](/docs/ja/skills)と[コマンド](/docs/ja/commands)は、呼び出しポイントでユーザーメッセージとして命令を注入します。会話内の以前のものは何も変わりません。frontmatter で `model` を指定するスキルまたはコマンドは、そのターンの[モデル切り替え](#switching-models)になる可能性があります。

<h3 id="running-/recap">
  `/recap` の実行
</h3>

[`/recap`](/docs/ja/interactive-mode#session-recap)は、ターミナルに表示するための要約を生成します。`/compact` とは異なり、メッセージ履歴を置き換えるのではなく、コマンド出力として要約を追加するため、キャッシュされたプリフィックスはそのままです。

<h3 id="rewinding-the-conversation">
  会話の巻き戻し
</h3>

[`/rewind`](/docs/ja/checkpointing)は、会話を以前のターンに切り詰めます。残りの履歴は、その時点でキャッシュが構築されたのと同じコンテンツであり、システムプロンプトとプロジェクトコンテキストレイヤーは変更されないため、次のリクエストは以前のキャッシュエントリにヒットします。それ以降のすべてのターンはそのプリフィックスを通じて読み取られており、元のターンが TTL より長い前であっても、エントリを温かく保ちました。

会話と一緒にファイルチェックポイントを復元しても、キャッシュに対する個別の効果はありません。ファイルコンテンツがコンテキストに入るのは Claude が読むときだけであり、[リポジトリ内のファイルの編集](#editing-files-in-your-repository)と同じです。

<h2 id="cache-lifetime">
  キャッシュライフタイム
</h2>

キャッシュされたプリフィックスは、非アクティブ期間後に期限切れになります。キャッシュにヒットするすべてのリクエストはタイマーをリセットするため、作業を続ける限りキャッシュは温かく保たれます。十分に長いギャップの後、次のリクエストは完全な入力を再計算し、キャッシュを再確立します。これが、立ち去った後の最初のターンが顕著に遅い理由です。

Pro または Max プランでは、長い休止後に大規模なセッションを再開する場合、Claude Code は[サマリーから再開する](/docs/ja/sessions#resume-from-a-summary)ことを提案するため、後続のリクエストは完全な履歴を保持する必要がありません。

Time to Live（TTL）は、キャッシュが生き残るギャップの長さを制御します。API は 2 つを提供します。5 分の TTL と、より長い休止を通じてキャッシュを温かく保つ[1 時間の TTL](https://platform.claude.com/docs/en/build-with-claude/prompt-caching#1-hour-cache-duration)ですが、[キャッシュ書き込みをより高いレートで請求](https://platform.claude.com/docs/en/build-with-claude/prompt-caching#pricing)します。より長い TTL は、セッションをアイドル状態のままにして戻ってくる場合に役立ちます。期限切れのプリフィックスが発生する再処理をスキップできるためです。5 分を超えてアイドル状態にならない短いバースト作業では、より高い書き込みレートが適用され、より長いキャッシュライフタイムが未使用のままになるため、コストが高くなります。

<h3 id="which-ttl-each-request-gets">
  各リクエストが取得する TTL
</h3>

Claude Code はリクエストごとに TTL を決定し、すべてのリクエストは 2 つの固定バケットのいずれかに該当します。

* **メイン会話**: インタラクティブなターン、非インタラクティブな `-p` 実行、Agent SDK ターン、およびそれらと共にインラインで実行される Claude Code ヘルパー
* **その他すべて**: [サブエージェント](/docs/ja/sub-agents)、[ワークフロー](/docs/ja/workflows)、プロセス内[チームメイト](/docs/ja/agent-teams)、フォーク、圧縮、セッションタイトルなど、その会話の外で Claude Code が行うリクエスト

TTL を自分で選択しない限り、Claude Code は Claude サブスクリプション内でプランに含まれる使用量内でのみ 1 時間の TTL をリクエストします。そこでメイン会話に対して 1 時間をリクエストし、Anthropic がサーバー側で制御する小さなヘルパーリクエストセットをリクエストします。このテーブルは、両方の種類の請求下での各バケットのデフォルト TTL を示しています。

| リクエストバケット | Claude サブスクリプション、プラン使用量内        | 使用クレジット、API キー、またはクラウドプロバイダー |
| --------- | ------------------------------- | ---------------------------- |
| メイン会話     | 1 時間                            | 5 分                          |
| その他すべて    | 5 分（ただし、サーバー制御のヘルパーリクエストは 1 時間） | 5 分                          |

プランの使用量制限を超えて、Claude Code が[使用クレジット](https://support.claude.com/en/articles/12429409-extra-usage-for-paid-claude-plans)を引き出すと、その使用量に対して請求されるため、Claude Code はメイン会話をより安い 5 分の TTL に低下させます。そこで 1 時間の TTL を保つには、[TTL を自分で選択](#choose-the-ttl-yourself)してください。

<h3 id="choose-the-ttl-yourself">
  TTL を自分で選択する
</h3>

どちらのバケットに対しても TTL を設定できます。各コントロールは `5m` または `1h` を取り、Claude Code は他の値を無視します。

* **メイン会話**: [`promptCacheTtl`](/docs/ja/settings-reference#promptcachettl) 設定、または `CLAUDE_CODE_PROMPT_CACHE_TTL` [環境変数](/docs/ja/env-vars)
* **その他すべて**: [`subagentPromptCacheTtl`](/docs/ja/settings-reference#subagentpromptcachettl) 設定、または `CLAUDE_CODE_SUBAGENT_PROMPT_CACHE_TTL` 環境変数

両方の設定と両方の環境変数には Claude Code v2.1.242 以降が必要です。API キーで署名するか、クラウドプロバイダーを使用する場合は、`promptCacheTtl` を `1h` に設定して、メイン会話に 1 時間のキャッシュを与えます。その外のリクエストは、そのバケットに対しても TTL を選択するまで 5 分のデフォルトを保ちます。

複数のコントロールが適用される場合、Claude Code はこの順序で最初にマッチするものを取ります。

1. `FORCE_PROMPT_CACHING_5M=1`。両方のバケットに対して 5 分を強制します
2. バケットの環境変数
3. バケットの設定
4. サブエージェントのリクエストの場合、サブエージェントの [`experimental` frontmatter フィールド](/docs/ja/sub-agents#supported-frontmatter-fields)の `cacheTtl` 値。Claude Code v2.1.248 以降が必要です。Claude サブスクリプションが使用クレジットを使用している間、Claude Code はそこの `1h` を無視します
5. `ENABLE_PROMPT_CACHING_1H=1`。両方のバケットに対して 1 時間をリクエストします
6. [リクエストのバケットのデフォルト](#which-ttl-each-request-gets)

キャッシング動作をデバッグする場合、2 つの TTL を比較する場合、または[管理設定](/docs/ja/managed-settings)で設定された長い TTL をオーバーライドする場合は、`FORCE_PROMPT_CACHING_5M=1` を設定します。

メイン会話のキャッシュ書き込みが使用した TTL を確認するには、`claude -p "hello" --output-format json` を実行し、結果の `usage.cache_creation` を読みます。Claude Code は 1 時間のキャッシュ書き込みを `ephemeral_1h_input_tokens` の下で報告し、5 分のキャッシュ書き込みを `ephemeral_5m_input_tokens` の下で報告します。

`ANTHROPIC_BASE_URL` で設定した LLM ゲートウェイを通じて、1 時間のリクエストの一部は `anthropic-beta` ヘッダーで移動するため、ゲートウェイを[そのヘッダーを変更されずに転送](/docs/ja/llm-gateway-protocol#request-headers)するように設定します。1 時間の TTL は[Claude アプリゲートウェイ](/docs/ja/claude-apps-gateway#availability-and-limitations)を通じて利用できません。Amazon Bedrock では、プロンプトキャッシングサポート、最小キャッシュ可能プリフィックス長、および 1 時間の TTL 可用性はすべてモデルによって異なります。キャッシュトークン数がゼロのままの場合は、Amazon Bedrock ドキュメントの[サポートされているモデル、リージョン、制限](https://docs.aws.amazon.com/bedrock/latest/userguide/prompt-caching.html#prompt-caching-models)を確認してください。

<h2 id="cache-scope">
  キャッシュスコープ
</h2>

Claude Code では、キャッシュは事実上 1 つのマシンとディレクトリにスコープされます。システムプロンプトは、作業ディレクトリ、プラットフォーム、シェル、OS バージョン、および自動メモリパスを埋め込むため、異なるディレクトリの 2 つのセッションは異なるプリフィックスを構築し、互いのキャッシュをミスします。これには、同じリポジトリの worktrees が含まれます。各 worktree は独自の作業ディレクトリを持つためです。

同じディレクトリで並行して実行するセッションは、一致するプリフィックスを構築し、互いのキャッシュを読み取ります。順序付きセッションは、起動時の git ステータススナップショットが一致する場合にのみプリフィックスを共有します。システムプロンプトはブランチと最近のコミットもキャプチャするためです。

基礎となる API キャッシュはより広いです。キャッシュは組織間で分離され、一部のプロバイダーでは、[組織内のワークスペース間](https://platform.claude.com/docs/ja/build-with-claude/prompt-caching#cache-storage-and-sharing)で分離されます。これらの境界内で、同じモデルとプリフィックスを持つ 2 つのリクエストは同じキャッシュを読み取ります。自動化されたプロセスのフリートを実行する Agent SDK 呼び出し元については、[ユーザーとマシン間でプロンプトキャッシングを改善](/docs/ja/agent-sdk/modifying-system-prompts#improve-prompt-caching-across-users-and-machines)を参照して、システムプロンプトのマシンごとのセクションを抑制し、マシン間でキャッシュを共有します。

<h2 id="check-cache-performance">
  キャッシュパフォーマンスを確認する
</h2>

キャッシュパフォーマンスは、API がすべての応答で報告する 2 つのトークン数として表示されます。最も直接的な方法は、`current_usage` オブジェクトを読み取る[statusline スクリプト](/docs/ja/statusline)を監視することです。

| フィールド                         | 意味                                           |
| ----------------------------- | -------------------------------------------- |
| `cache_creation_input_tokens` | このターンでキャッシュに書き込まれたトークン。キャッシュ書き込みレートで請求されます   |
| `cache_read_input_tokens`     | このターンでキャッシュから提供されたトークン。標準入力レートの約 10% で請求されます |

読み取りから作成への比率が高いほど、キャッシングが機能しています。作成がターンごとに高いままの場合、プリフィックスで何かが変更されています。[キャッシュを無効にするアクション](#actions-that-invalidate-the-cache)セクションは、通常の原因をリストします。

セッションごとのサマリーについては、`/usage` を実行してください。メインの会話の最初の応答の後、Claude Code はセッションブロックに[`Prompt cache (main)` 行](/docs/ja/costs#prompt-cache-statistics)を追加し、セッションのヒット率、ミス数、およびキャッシュが現在ウォームであるかどうかを表示します。statusline スクリプトは、[`prompt_cache` オブジェクト](/docs/ja/statusline#prompt-cache-fields)から同じ数値を読み取ることができます。どちらも Claude Code v2.1.251 以降が必要です。

`Prompt cache (main)` 行は、Claude Code が識別できる場合、最後のミスの可能性のある原因も名前を付けます。例えば `likely cause: tool definitions changed` のようにです。可能性のある原因テキストには Claude Code v2.1.260 以降が必要です。

組織全体の可視性については、OpenTelemetry エクスポーターはユーザーとセッションごとにキャッシュ読み取りと作成トークンを報告します。メトリックとイベント属性リファレンスについては、[使用状況の監視](/docs/ja/monitoring-usage)を参照してください。

<h2 id="subagents-and-the-cache">
  サブエージェントとキャッシュ
</h2>

[サブエージェント](/docs/ja/sub-agents)は、親とは別に、独自のシステムプロンプトとツールセットを持つ独自の会話を開始します。最初のリクエストは親のキャッシュを読み取りません。2 つのプリフィックスが異なるためです。また、独自のターン全体で独自のキャッシュを温めます。サブエージェントはメイン会話の [TTL バケット](#which-ttl-each-request-gets)の外にあるため、サブスクリプション上でも 5 分間の TTL を取得します。[より長い TTL を選択](#choose-the-ttl-yourself)するまでです。

親のキャッシュは影響を受けません。親の側から、サブエージェントの呼び出しと結果は会話に追加され、親のプリフィックスはそのままです。

一方、[フォーク](/docs/ja/sub-agents#fork-the-current-conversation)は、親のシステムプロンプト、ツール、会話履歴を正確に継承するため、最初のリクエストは親のキャッシュを読み取ります。

他のリクエストも、以前のリクエストがキャッシュしたプリフィックスを読み取ることができます。

* **セッションコピー**: [`/fork`](/docs/ja/agent-view#copy-the-session-with-%2Ffork)でコピーしたセッションは、コピーされた会話の最後にメッセージとして分離命令を受け取るため、元の会話が構築したキャッシュはそのままです。
* **コンパクト化**: [会話のコンパクト化](#compacting-the-conversation)で説明されている要約呼び出しは、同じプリフィックス共有アプローチを使用します。
* **ワークフローファンアウト**: [ワークフローファンアウト](/docs/ja/workflows#prompt-caching-in-a-fan-out)の同じプリフィックスエージェントでは、Claude Code はデフォルトで最初のエージェント以外をすべて最大 5 秒間保持するため、最初のエージェントがキャッシュしたプリフィックスを読み取ることができます。

<h2 id="disable-prompt-caching">
  プロンプトキャッシングを無効にする
</h2>

キャッシング動作を特定のモデルまたはプロバイダーでデバッグするときは、キャッシングを無効にすることが時々役立ちます。オフにするには、これらの環境変数のいずれかを `1` に設定します。

| 変数                              | 効果                 |
| ------------------------------- | ------------------ |
| `DISABLE_PROMPT_CACHING`        | すべてのモデルに対して無効にする   |
| `DISABLE_PROMPT_CACHING_HAIKU`  | Haiku のみに対して無効にする  |
| `DISABLE_PROMPT_CACHING_SONNET` | Sonnet のみに対して無効にする |
| `DISABLE_PROMPT_CACHING_OPUS`   | Opus のみに対して無効にする   |
| `DISABLE_PROMPT_CACHING_FABLE`  | Fable のみに対して無効にする  |

組織全体でキャッシングポリシーを設定するには、これらのいずれかまたは [TTL 変数](#cache-lifetime)を [管理設定](/docs/ja/managed-settings)の `env` ブロックに入れます。通常の使用では、キャッシングを有効のままにしてください。

<h2 id="related-resources">
  関連リソース
</h2>

* [Claude Code の構築から学んだ教訓: プロンプトキャッシングがすべて](https://claude.com/blog/lessons-from-building-claude-code-prompt-caching-is-everything): Plan mode、遅延ツール読み込み、コンパクト化の設計根拠
* [コンテキストウィンドウを探索](/docs/ja/context-window): コンテキストに読み込まれるもの、いつ読み込まれるか
* [トークン使用量を削減](/docs/ja/costs#reduce-token-usage): コンテキストサイズを管理するためのキャッシング以外の戦略
* [コストを追跡および削減](/docs/ja/agent-sdk/cost-tracking): Agent SDK 呼び出し元のキャッシュトークン追跡と TTL 設定
* [プロンプトキャッシング](https://platform.claude.com/docs/ja/build-with-claude/prompt-caching): 基礎となる API メカニズム、ブレークポイント、価格設定
