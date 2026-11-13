> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# fast mode で応答を高速化

> Claude Code で `/fast` を使って fast mode を切り替え、Opus と Fable の応答を高速化します。

> [!NOTE]
>
> Claude Fable 5.2 および Claude Opus 5.5 の fast mode は利用可能です。Claude Opus 5 および Claude Opus 4.8 の fast mode は[リサーチプレビュー](#research-preview)段階です。

fast mode はサポートされているモデル向けの高速な設定で、モデルを最大 2.5 倍高速化しますが、トークンあたりのコストは高くなります。迅速な反復やライブデバッグなどのインタラクティブな作業で速度が必要な場合は `/fast` でオンにし、コストがレイテンシーより重要な場合はオフにします。

fast mode は同じモデルを、コスト効率よりも速度を優先する異なる API 設定で使用するため、品質と機能は変わりません。Anthropic API では、fast mode は Fable 5.2、Opus 5.5、Opus 5、および Opus 4.8 でサポートされています。Sonnet、Haiku、または他のモデルでは利用できません。Google Cloud の Agent Platform 上のモデルについては、[Agent Platform で fast mode を使用する](#use-fast-mode-on-agent-platform)を参照してください。

> [!WARNING]
>
> Opus 4.8 の fast mode は 2026 年 10 月 30 日に非推奨となり、2026 年 11 月 30 日に削除されます。その日以降も fast mode をオンにした状態で Opus 4.8 を使用している場合、API はリクエストを拒否します。その日までに、Opus 5.5 に切り替えるか、セッションで fast mode をオフにしてください：
>
> * **fast mode を維持する場合**：[`/model`](https://code.claude.com/docs/ja/model-config#setting-your-model) を使用して [Opus 5.5](https://code.claude.com/docs/ja/model-config.md#model-aliases) に切り替えます。これには Claude Code v2.1.280 以降が必要です。切り替え後も fast mode はオンのままです。新しいセッションが引き続き Opus 4.8 で開始される場合は、[選択したモデルとは異なるモデルで新しいセッションが開始される](https://code.claude.com/docs/ja/model-config.md#a-new-session-starts-on-a-different-model-than-you-picked)を参照してください。
> * **標準速度で Opus 4.8 を使い続ける場合**：[`/fast off`](https://code.claude.com/docs/ja/commands) を実行します

Opus 4.7 は高速モードをサポートしていないため、それに切り替えると高速モードがオフになります。Opus 4.7 の高速モードは 2026 年 6 月 25 日に非推奨となり、2026 年 7 月 24 日に削除されました。

知っておくべきこと：

* Claude Code CLI で `/fast` を使用して fast mode をオンにします。[VS Code 拡張機能](https://code.claude.com/docs/ja/vs-code.md)は、選択したモデルが fast mode をサポートしている場合、**Toggle fast mode** コマンドを提供します。Anthropic API では、Claude Code はそのトグルを [`fastMode` 設定](#toggle-fast-mode)に保存します。
* Anthropic の fast mode の価格は、MTok あたりの入力/出力で Fable 5.2 が \$16/\$80、Opus 5.5 が \$8/\$40、Opus 5 および Opus 4.8 が \$10/\$50 です。
* サブスクリプションプラン（Pro/Max/Ultra/Team/Enterprise）の Claude Code ユーザー、Claude Console、および[条件付き](#use-fast-mode-on-agent-platform)で Google Cloud の Agent Platform で利用可能です。Team および Enterprise 組織は Owner が最初に有効にする必要があり、Console 組織は Opus 5 または Opus 4.8 で使用するために、最初にアクセスをプロビジョニングする必要があります。どちらも[要件](#requirements)に記載されています。
* サブスクリプションプラン（Pro/Max/Ultra/Team/Enterprise）の Claude Code ユーザーの場合、fast mode は使用クレジットのみで利用可能であり、サブスクリプションのレート制限には含まれていません。

## 高速モードの切り替え

Agent Platform では、`/fast` と `fastMode` 設定の動作が異なるため、代わりに[Agent Platform で fast mode を使用する](#use-fast-mode-on-agent-platform)の手順に従ってください。

CLI では、次のいずれかの方法で高速モードを切り替えます：

* `/fast` を実行して、Space キーを押してオンまたはオフに切り替えてから、Enter キーを押して確認します
* fast mode をサポートしているモデルで、[ユーザー設定ファイル](https://code.claude.com/docs/ja/settings.md)に `"fastMode": true` を設定します。それ以外のモデルで設定した場合、そのモデルのまま fast mode はオフになります。Fable 5.2 では、Fable 5.2 の使用中に `/fast` を実行するまで、その設定だけでは効果がありません。

Anthropic API では、デフォルトで、対話セッションで有効にした fast mode は、サポートされているモデルであればセッションをまたいで保持されます。Fable 5.2 では、[Fable 5.2 の使用中にオンにした](#switch-models-while-fast-mode-is-on)場合にのみ保持されます。fast mode を各セッションでリセットするように構成できます。詳細は[セッションごとのオプトインが必要](#require-per-session-opt-in)を参照してください。

[クラウドセッション](#use-fast-mode-in-cloud-sessions)の外では、[非インタラクティブモード](https://code.claude.com/docs/ja/headless.md)で `-p` フラグを使用する場合、`/fast` は [`--settings`](https://code.claude.com/docs/ja/cli-reference#cli-flags) 値で高速モードを使用して起動されたセッションでのみ機能します。例えば `claude -p --settings '{"fastMode": true}'` のように使用します。その場合、切り替えはそのセッションにのみ適用され、デフォルトとして保存されません。`-p` 形式には Claude Code v2.1.205 以降が必要です。非インタラクティブモードの他の場所では、コマンドが高速モードが利用できないことを報告します。

Claude が処理中に `/fast` を実行でき、Claude Code は処理の終了を待たずに高速モードを切り替えます。Claude Code は実行中のターンを元の速度で完了するため、速度の変更は次のターンから有効になります。現在のモデルが高速モードをサポートしていない場合、有効にするとモデルも切り替わり、Claude Code はそのターン内の次のリクエストから新しいモデルを使用します。

最高のコスト効率を得るには、会話の途中で切り替えるのではなく、セッションの開始時に高速モードを有効にします。詳細は[コストのトレードオフを理解する](#understand-the-cost-tradeoff)を参照してください。

`/fast` で fast mode を有効にすると：

* Anthropic API では、現在のモデルが fast mode をサポートしていない場合、Claude Code は Opus に切り替わります
* Fable 5.2 での fast mode には Claude Code v2.1.321 以降が必要です
* 確認メッセージが表示されます：「Fast mode ON」
* 高速モードがアクティブな間、プロンプトの横に小さい `↯` アイコンが表示されます
* いつでも `/fast` を再度実行して、高速モードがオンかオフかを確認できます

Anthropic API では、Opus 5.5 は Claude Code v2.1.280 以降の fast mode のデフォルトです。v2.1.280 より前では、fast mode のデフォルトは v2.1.219 以降 Opus 5 でした。

`/fast` を再度実行して fast mode を無効にすると、現在のモデルに留まります。別のモデルに切り替えるには、`/model` を使用します。

### 高速モードがオンの状態でモデルを切り替える

fast mode はモデルの切り替えに追従します：

* **切り替える**：高速モードをサポートしていないモデルに切り替えると、Claude Code は高速モードをオフにします。これには Opus 4.7 が含まれます。v2.1.221 より前では、高速モードは Opus 4.7 への切り替え後もオンのままで、API がリクエストを拒否していました。
* **戻す**：保存された設定がオンの場合、サポートされている Opus モデルに戻すと fast mode が再度オンになります。[セッションごとのオプトイン](#require-per-session-opt-in)を使用している場合は、代わりに `/fast` を実行してください。
* **Fable 5.2 に切り替える**：Fable 5.2 の使用中にオンにした場合を除き、fast mode はオフになります。オンにするには、Fable 5.2 で `/fast` を実行します。[セッションごとのオプトイン](#require-per-session-opt-in)を設定していない限り、オフにするか別のモデルでオンにするまで、その状態は Anthropic API 上でセッションをまたいで保持されます。

モデル切り替えが高速モードをオンまたはオフにするたびに、Claude Code は `Fast mode ON` または `Fast mode OFF` の確認を表示し、高速モードがオンの間は `↯` アイコンが表示されます。これは `/model` で切り替える場合、[`/config model=<model>`](https://code.claude.com/docs/ja/settings)で切り替える場合、または [Remote Control](https://code.claude.com/docs/ja/remote-control.md)を通じて接続されたデバイスから切り替える場合に当てはまります。

### クラウドセッションで高速モードを使用する

fast mode は[クラウドセッション](https://code.claude.com/docs/ja/claude-code-on-the-web.md)で機能します。アカウントで利用可能な場合、セッションが Anthropic 管理インフラストラクチャで実行されるか、Anthropic API 上の[セルフホストランナー](https://code.claude.com/docs/ja/self-hosted-environments)で実行されるかに関わらず機能します。セッションの環境で Claude Code v2.1.271 以降が必要です。

セッションで `/fast on` と入力して高速モードをオンにします。そのセッションのみオンのままで、デフォルトとして保存されません。[要件](#requirements)はクラウドセッションにも適用されます。

ブラウザの [claude.ai/code](https://claude.ai/code)では、メッセージボックスのモデルメニューから高速モードをオンおよびオフにすることもできます。メニューは、プランに高速モードが含まれており、選択されたモデルがそれをサポートしている場合に表示されます。

## コストのトレードオフを理解する

fast mode は標準速度よりもトークンあたりの価格が高くなります。Anthropic の料金は次のとおりです。

| モデル | 入力（MTok） | 出力（MTok） |
| - | - | - |
| Fable 5.2 | \$16 | \$80 |
| Opus 5.5 | \$8 | \$40 |
| Opus 5 | \$10 | \$50 |
| Opus 4.8 | \$10 | \$50 |

fast mode の価格は 1M トークンのコンテキストウィンドウ全体で一定です。比較対象となる標準レートについては、[Claude 価格リファレンス](https://platform.claude.com/docs/ja/about-claude/pricing)を参照してください。

会話で初めて fast mode を有効にすると、会話コンテキスト全体に対して、fast mode のキャッシュされていない入力トークンの価格を全額支払います。会話が進んでいるほどこのコストは高くなるため、最初に fast mode を有効にしたときに請求額が最も小さくなります。fast mode と標準速度は[別々のキャッシュ](https://code.claude.com/docs/ja/prompt-caching.md#turning-on-fast-mode)を保持するため、その後切り替えるたびに、会話の一部または全体が再びキャッシュなしで読み込まれます。

### 高速モード支出がどこに表示されるかを確認する

fast mode の支出がどこに表示されるかは、サインイン方法によって異なるため、まず [`/status`](https://code.claude.com/docs/ja/commands) を実行して確認してください。`Claude Max account` などの `Login method` 行が表示される場合は、Claude サブスクリプションでサインインしています。代わりに `API key` 行が表示される場合は、リクエストが Claude Console 組織に請求されます。

* **Pro、Max、Ultra**：使用クレジットから fast mode の料金を支払います。claude.ai の [**設定 > 使用状況**](https://claude.ai/settings/usage)に移動します。ここで、**使用クレジット**セクションに今月の使用クレジットの支出額が表示されます。この数字には fast mode が含まれていますが、別途に分類されていません。
* **Team と Enterprise**：組織が使用クレジットから高速モード使用の料金を支払います。自分の使用クレジット支出を確認するには、[`/usage`](https://code.claude.com/docs/ja/costs#check-your-usage-credits-spend)を実行してください。組織がその支出をどこで確認するかについては、[Claude for Teams and Enterprise](https://code.claude.com/docs/ja/costs.md#claude-for-teams-and-enterprise)を参照してください。
* **Claude Console**：組織が API 使用の残りの部分と一緒に fast mode の料金を支払います。Console の[使用状況](https://platform.claude.com/usage)ページと[コスト](https://platform.claude.com/cost)ページで、**グループ化**メニューの **速度** を選択して、fast mode を標準速度の使用から分離します。選択した日付範囲に fast mode の使用が含まれている場合にのみ、このオプションが表示されます。

## 高速モードの使用時期を判断する

高速モードはレスポンスレイテンシーがコストより重要なインタラクティブな作業に最適です：

* コード変更の迅速な反復
* ライブデバッグセッション
* 厳しい期限を持つ時間に敏感な作業

標準モードは以下に適しています：

* 速度がそれほど重要でない長い自動タスク
* バッチ処理または CI/CD パイプライン
* コストに敏感なワークロード

### 高速モードと努力レベル

高速モードと努力レベルはどちらもレスポンス速度に影響しますが、方法が異なります：

| 設定 | 効果 |
| - | - |
| **高速モード** | 同じモデル品質、低レイテンシー、高コスト |
| **低い努力レベル** | 思考時間が短い、レスポンスが高速、複雑なタスクでは品質が低下する可能性 |

両方を組み合わせることができます：単純なタスクで最大速度を得るために、低い[努力レベル](https://code.claude.com/docs/ja/model-config.md#adjust-effort-level)で高速モードを使用します。

## 要件

高速モードには以下のすべてが必要です：

* **サポートされているプロバイダー**：fast mode は Anthropic Console API、使用クレジットを使用する Claude サブスクリプションプラン、および Google Cloud の Agent Platform で[条件付き](#use-fast-mode-on-agent-platform)で利用できます。Amazon Bedrock、Microsoft Foundry、または AWS 上の Claude Platform では利用できず、`/fast` は「Fast mode is not available on this provider」と表示します。Console 組織が Opus 5 または Opus 4.8 で fast mode を使用するには、[fast mode アクセスをプロビジョニング](#enable-fast-mode-for-your-organization)する必要もあります。
* **サブスクリプションプランで使用クレジットが有効**：Pro、Max、Ultra、Team、または Enterprise プランでは、アカウントで[使用クレジット](https://code.claude.com/docs/ja/costs.md#add-usage-credits-to-your-subscription)が有効になっている必要があります。これにより、プランに含まれる使用量を超えて課金できるようになります。有効になるまで、`/fast` は「Fast mode requires usage credits」と表示します。有効にする方法はプランによって異なります：
  * Pro、Max、および Ultra では、claude.ai の [**Settings > Usage**](https://claude.ai/settings/usage) の **Usage credits** セクションで有効にするか、`/usage-credits` を実行してそのページを開きます。
  * Team および Enterprise では、請求アクセス権を持つメンバーが [**Organization settings > Usage**](https://claude.ai/admin-settings/usage) で組織の使用クレジットを有効にし、アクセス権を持たないメンバーは `/usage-credits` を実行して組織の管理者にリクエストを送信します。

> [!NOTE]
>
> 高速モード使用量は、プランに残りの使用量がある場合でも、使用量クレジットに直接請求されます。

* **有料 Console 組織**：Claude Console アカウントは使用量クレジットを使用せず、組織は API 使用量の残りと同じようにトークンごとに高速モードの料金を支払います。Console の無料 Evaluation プランでは、`/fast` は「Fast mode unavailable during evaluation. Please purchase credits.」と表示されます。これをクリアするには、[Console 請求設定](https://platform.claude.com/settings/billing)でクレジットを購入します。

  Fable 5.2 または Opus 5.5 での fast mode は、組織の[使用量ティア](https://platform.claude.com/docs/en/api/rate-limits)にも依存します。
* **Team および Enterprise の所有者による有効化**：高速モードは Team および Enterprise 組織ではデフォルトで無効になっています。ユーザーがアクセスできるようにするには、所有者が明示的に[高速モードを有効にする](#enable-fast-mode-for-your-organization)必要があります。

> [!NOTE]
>
> 4 つの組織設定が `/fast` で高速モードをオンにすることをブロックできます：
>
> * **高速モードが有効になっていない**：組織で高速モードが有効になっていない場合、`/fast` で高速モードをオンにすると「Fast mode has been disabled by your organization.」と表示されます。
> * **高速モードが管理設定によってオフにされている**：組織が [`fastMode: false`](https://code.claude.com/docs/ja/settings-reference#fastmode) を設定する[管理設定](https://code.claude.com/docs/ja/managed-settings.md)をデプロイしている場合、`/fast` で高速モードをオンにすると同じ「Fast mode has been disabled by your organization」メッセージが表示されます。
> * **セッションごとのオプトインが必要**：[`fastModePerSessionOptIn: true`](#require-per-session-opt-in) を設定する管理設定は、インタラクティブターミナルセッション以外のすべての場所で `/fast on` を同じメッセージで拒否します。
> * **fast mode モデルが許可されていない**：組織の [`availableModels`](https://code.claude.com/docs/ja/model-config#restrict-model-selection) 許可リストが `/fast` の切り替え先のモデルを除外している場合、オンにすることは「is not in your organization's allowed models」で拒否されます。fast mode をサポートする許可されたモデルで既に実行中のセッションでは、`/fast` はモデルを切り替える代わりに現在のモデルで fast mode を有効にします。

### 組織の高速モードを有効にする

組織で高速モードを有効にする場所は、組織が使用する製品によって異なります：

* **Console**（API 顧客）：管理者が [Claude Code preferences](https://platform.claude.com/claude-code/preferences) で有効にします
* **Claude AI**（Team および Enterprise）：Owner が [**Organization settings > Claude Code**](https://claude.ai/admin-settings/claude-code) で有効にします

Claude Opus 5 または Claude Opus 4.8 を使用する Console 組織は、[Claude API の fast mode](https://platform.claude.com/docs/en/build-with-claude/fast-mode) で説明されているように、プロビジョニングされたアクセスも必要です。そのアクセスがない場合、これらのモデルでの fast mode リクエストは [fast mode レート制限](#handle-rate-limits)に達し、アクセスがプロビジョニングされるまで標準速度にフォールバックします。

高速モードを完全に無効にするもう 1 つのオプションは、`CLAUDE_CODE_DISABLE_FAST_MODE=1` を設定することです。[環境変数](https://code.claude.com/docs/ja/env-vars.md)を参照してください。

### Agent Platform で fast mode を使用する

[Google Cloud の Agent Platform](https://code.claude.com/docs/ja/google-vertex-ai.md) では、Fable 5.2 で fast mode をオンにできます。対話セッションでは `/fast` で、[非対話モード](https://code.claude.com/docs/ja/headless.md)では起動フラグでオンにします。Claude Code v2.1.322 以降が必要です。

fast mode を使用するには、Fable 5.2 の[リージョン](https://code.claude.com/docs/ja/google-vertex-ai.md#region-configuration)が `global`、`us`、または `eu` である必要があります。その他のリージョンでは、`/fast` は `Fast mode needs Vertex region global, us or eu` と表示し、`claude -p` は標準速度で実行されます。Claude Code を起動する前に、シェルでリージョンを設定します。例えば `global` に設定する場合：

```bash theme={null}
export VERTEX_REGION_CLAUDE_FABLE_5_2=global
```

次に、fast mode をオンにします：

* **対話セッションの場合**：`/fast` を実行します。Opus モデル、または Agent Platform で fast mode に対応していない別のモデルから Fable 5.2 に切り替わります。fast mode はデフォルトとして保存されません。
* **非対話モードの場合**：Fable 5.2 を [`--model`](https://code.claude.com/docs/ja/cli-reference#cli-flags) に、fast mode を [`--settings`](https://code.claude.com/docs/ja/cli-reference#cli-flags) に渡します。例：`claude -p "Summarize this project" --model claude-fable-5-2 --settings '{"fastMode": true}'`

Agent Platform では、ユーザー、プロジェクト、ローカル、または管理設定の `"fastMode": true` は効果がありません。

Agent Platform が fast mode を拒否した場合、Claude Code は標準速度にフォールバックします。その後、対話セッションでは次のいずれかのターミナルメッセージが表示されます：

* `Using standard speed on Fable 5.2 · fast mode wasn't available`：`/fast on` を実行して fast mode を再試行します
* `Fast mode was refused for this project · trying again in 30m`：Agent Platform が fast mode リクエストに 403 または 404 エラーで応答しました。より早く再試行するには、`/fast on` を実行します。

### プロキシと LLM ゲートウェイの背後で高速モードを使用する

Anthropic API で fast mode を提供する前に、Claude Code は `api.anthropic.com` への直接リクエストで組織の fast mode の利用可否をチェックします。チェックは [`ANTHROPIC_BASE_URL`](https://code.claude.com/docs/ja/llm-gateway-connect#set-the-base-url-and-credential) に従わないため、Claude トラフィックを [LLM ゲートウェイ](https://code.claude.com/docs/ja/llm-gateway)を通じてルーティングし、`api.anthropic.com` への直接エグレスをブロックするネットワークでは、推論リクエストが機能していてもチェックが失敗します。

チェックは設定された [HTTP プロキシ](https://code.claude.com/docs/ja/network-config.md#proxy-configuration)を使用するため、ネットワークブロックはプロキシを通じても `api.anthropic.com` に到達できない場合にのみチェックに失敗します。組織で fast mode が有効になっているのに `/fast` がそうでないと表示する場合は、表示されたメッセージを以下のケースから探してください。

#### Fast mode unavailable due to network connectivity issues

ネットワークが `api.anthropic.com` をブロックしているなどの理由で利用可否チェックが失敗し、リクエストは標準速度で実行されます。過去に成功したチェックはキャッシュされた結果で機能し続けるため、チェックのブロックは主に新しいインストールに影響します。

fast mode を復元するには、`api.anthropic.com` への直接エグレスを許可リストに登録するか、`CLAUDE_CODE_SKIP_FAST_MODE_NETWORK_ERRORS=1` を設定します。この変数は失敗したチェックを利用可能として扱い、「disabled by your organization」応答は引き続き尊重します。

#### Fast mode is currently unavailable

ゲートウェイの背後では、Claude Code が利用可否チェックを送信せず、以前に成功したチェックもキャッシュされていない、次の設定になっていないか確認してください：

* `ANTHROPIC_BASE_URL` をゲートウェイに向け、[`ANTHROPIC_API_KEY`](https://code.claude.com/docs/ja/llm-gateway-connect#set-the-base-url-and-credential) に Anthropic API キーの形式ではないゲートウェイ発行のキーを設定している。
* [`CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC`](https://code.claude.com/docs/ja/env-vars) を設定しているため、Claude Code がチェックをスキップする。

どちらの設定でも、fast mode を復元するには `CLAUDE_CODE_SKIP_FAST_MODE_NETWORK_ERRORS=1` を設定します。

#### Fast mode has been disabled by your organization

ゲートウェイの背後では、次のいずれかの設定の場合、組織で fast mode が有効になっていてもこのメッセージが表示されることがあります：

* claude.ai ログインも API キーもなく、キャッシュされた成功したチェックもない状態で、[`ANTHROPIC_AUTH_TOKEN`](https://code.claude.com/docs/ja/llm-gateway-connect#set-the-base-url-and-credential) のみで認証している。この場合、Claude Code はリクエストを送信せずに fast mode が組織によって無効化されていると扱います。
* プロキシがチェックをインターセプトし、独自のページで応答している（例えば、HTTP 200 のブロックページを返す TLS 検査プロキシ）。Claude Code はそのページを、組織で fast mode が無効化されていることを示すレスポンスとして読み取ります。

どちらの場合も、`CLAUDE_CODE_SKIP_FAST_MODE_NETWORK_ERRORS` ではなく、チェック全体をスキップする `CLAUDE_CODE_SKIP_FAST_MODE_ORG_CHECK=1` を設定します。`CLAUDE_CODE_SKIP_FAST_MODE_NETWORK_ERRORS` はどちらのケースにも適用されません。

> [!NOTE]
>
> スキップ変数はクライアント側のチェックのみを変更します。組織で fast mode が無効化されている場合、これらが設定されているかどうかに関わらず、API は fast mode リクエストを拒否します。その場合、Claude Code はリクエストを標準速度で再試行し、fast mode をオフにして、`/fast` は組織が fast mode を無効化したことを報告します。

### セッションごとのオプトインが必要

Anthropic API のデフォルトでは、ユーザーが対話セッションでオンにした fast mode は、サポートされているモデル上でセッションをまたいで保持されます。Fable 5.2 では、ユーザーが [Fable 5.2 の使用中にオンにした](#switch-models-while-fast-mode-is-on)場合にのみ保持されます。

すべてのセッションを fast mode がオフの状態で開始させるには、任意の[設定ファイル](https://code.claude.com/docs/ja/settings.md#where-settings-live)で `fastModePerSessionOptIn` を `true` に設定します。これにより、ユーザーは各セッションで `/fast` を使って有効にします。[Team](https://claude.com/pricing?utm_source=claude_code\&utm_medium=docs\&utm_content=fast_mode_teams#team-&-enterprise) または [Enterprise](https://anthropic.com/contact-sales?utm_source=claude_code\&utm_medium=docs\&utm_content=fast_mode_enterprise) プランの Owner は、[サーバー管理設定](https://code.claude.com/docs/ja/server-managed-settings.md)を通じて組織全体にこれをデプロイできます。

```json theme={null}
{
  "fastModePerSessionOptIn": true
}
```

これは、ユーザーが複数の同時セッションを実行する組織でコストを制御するのに役立ちます。ユーザーの高速モード設定は保存されたままなので、この設定を削除するとデフォルトの永続的な動作が復元されます。

管理設定がキーを設定する場合、`/fast on` はインタラクティブターミナルセッションでのみ機能します。[非インタラクティブモード](https://code.claude.com/docs/ja/headless.md)、[VS Code 拡張機能](https://code.claude.com/docs/ja/vs-code.md)、および[クラウドセッション](#use-fast-mode-in-cloud-sessions)を含むその他のすべての場所では、組織が高速モードを無効化したというメッセージで拒否されます。

## レート制限の処理

fast mode には標準速度とは別のレート制限があります。Console の組織の場合、そのレート制限については Claude Platform の[レート制限](https://platform.claude.com/docs/en/api/rate-limits)ページで説明されています。fast mode のレート制限に達した場合：

1. 高速モードは自動的に標準速度にフォールバックします
2. `↯` アイコンがグレーに変わってクールダウンを示します
3. 標準速度と価格で作業を続けます
4. クールダウンが終了すると、高速モードは自動的に再度有効になります

クールダウンを待つ代わりに高速モードを手動で無効にするには、`/fast` を再度実行します。

セッション中に使用量クレジットが不足した場合、Claude Code は拒否された各高速モードリクエストを標準速度と価格で再試行するため、作業を続けることができ、クールダウンはありません。拒否の表示方法はセッションタイプによって異なります：

* 対話セッションでは、Claude Code は「Fast mode disabled · Out of usage credits」通知を表示し、fast mode をオフにします。保存された fast mode 設定は変わりません。`/fast` を実行して fast mode を再度オンにします。
* [非対話モード](https://code.claude.com/docs/ja/headless.md)で `--output-format stream-json` を使用する場合、および Agent SDK を通じて、Claude Code はメッセージストリーム上で同じテキストを、サブタイプ `notification` の `system` メッセージとして発行します。このメッセージは、使用クレジットが不足している間、ターンごとに 1 回届きます。fast mode はオンのままです。

## リサーチプレビュー

Claude Opus 5 および Claude Opus 4.8 の fast mode はリサーチプレビュー機能です。これは以下を意味します：

* 機能はフィードバックに基づいて変更される可能性があります
* 利用可能性と価格設定は変更される可能性があります
* 基盤となる API 構成は進化する可能性があります

通常の Anthropic サポートチャネルを通じて問題またはフィードバックを報告してください。

## 関連項目

* [モデル構成](https://code.claude.com/docs/ja/model-config.md)：モデルを切り替えて努力レベルを調整する
* [コストを効果的に管理する](https://code.claude.com/docs/ja/costs.md)：トークン使用量を追跡してコストを削減する
* [ステータスラインの構成](https://code.claude.com/docs/ja/statusline.md)：モデルとコンテキスト情報を表示する
