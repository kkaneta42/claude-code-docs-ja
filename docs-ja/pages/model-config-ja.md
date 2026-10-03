> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# モデル設定

> Claude Code が使用するモデル、effort レベル、拡張コンテキスト、自動圧縮ウィンドウを設定します

<h2 id="available-models">
  利用可能なモデル
</h2>

Claude Code の `model` 設定には、次のいずれかを設定できます。

* **モデルエイリアス**
* **モデル名**
  * Anthropic API: 完全な **[モデル名](https://platform.claude.com/docs/en/about-claude/models/overview)**
  * Amazon Bedrock: 推論プロファイル ARN
  * Microsoft Foundry: デプロイ名
  * Google Cloud's Agent Platform: バージョン名

さまざまな種類の作業にどのモデルと effort レベルが適しているかについては、ブログの [Choosing a Claude model and effort level in Claude Code](https://claude.com/blog/claude-model-and-effort-level-in-claude-code) を参照してください。

<Note>
  `ANTHROPIC_BASE_URL` はリクエストの送信先を変更するものであり、どのモデルが応答するかを変更するものではありません。LLM ゲートウェイ経由で Claude にルーティングするには、[LLM ゲートウェイ](/docs/ja/llm-gateway)を参照してください。
</Note>

<h3 id="model-aliases">
  モデルエイリアス
</h3>

モデルエイリアスを使用すると、正確なバージョン番号を覚えなくてもモデル設定を選択できます。

| モデルエイリアス | 動作 |
| - | - |
| **`default`** | モデルの上書きをすべてクリアし、[アカウントのランタイムデフォルト](#default-model-setting)に戻す特別な値。それ自体はモデルエイリアスではありません |
| **`best`** | Fable が利用可能な場合は [`fable` エイリアスが解決されるモデル](#fable-alias-resolution)を使用し、それ以外の場合は `opus` と同じモデルを使用します |
| **`fable`** | 最も難しく長時間実行されるタスク向けに、[プロバイダーの Fable モデル](#fable-alias-resolution)を使用します |
| **`sonnet`** | 日常的なコーディングタスク向けに最新の Sonnet モデルを使用します |
| **`opus`** | 複雑な推論タスク向けに最新の Opus モデルを使用します |
| **`haiku`** | シンプルなタスク向けに高速で効率的な Haiku モデルを使用します |
| **`sonnet[1m]`** | 長いセッション向けに [100 万トークンのコンテキストウィンドウ](https://platform.claude.com/docs/en/build-with-claude/context-windows#context-window-sizes-by-model)を備えた Sonnet を使用します。`sonnet` がネイティブで 1M ウィンドウを持つ Sonnet 5.5 または Sonnet 5 にすでに解決される場合は効果がありません |
| **`opus[1m]`** | 長いセッション向けに [100 万トークンのコンテキストウィンドウ](https://platform.claude.com/docs/en/build-with-claude/context-windows#context-window-sizes-by-model)を備えた Opus を使用します |
| **`opusplan`** | plan モードでは `opus` を使用し、実行時には `sonnet` に切り替える特別なモード |

`opus` および `sonnet` エイリアスが解決されるバージョンは、プロバイダーによって異なります。

| プロバイダー | `opus` | `sonnet` |
| :- | :- | :- |
| Anthropic API | Opus 5.5 | Sonnet 5.5 |
| [Claude Platform on AWS](/docs/ja/claude-platform-on-aws) | Opus 5.5 | Sonnet 4.6 |
| Amazon Bedrock、Google Cloud's Agent Platform | Opus 5.5 | Sonnet 4.5 |
| Microsoft Foundry | Opus 4.6 | Sonnet 4.5 |

<span id="fable-alias-resolution" />

`ANTHROPIC_DEFAULT_FABLE_MODEL` を設定しない限り、`fable` エイリアスは Fable 5.1 に解決されます。ただし [Claude apps gateway](/docs/ja/claude-apps-gateway) のセッションでは、`fable` と `best` は Fable 5 に解決されます。

`claude-fable-5-1` を提供するように設定されていないゲートウェイは、そのモデルへのリクエストを拒否します。Fable 5.1 を提供しているゲートウェイ経由で使用するには、`/model claude-fable-5-1` で選択してください。

エイリアスが古いモデルに解決される場合、完全なモデル名を明示的に選択するか、`ANTHROPIC_DEFAULT_OPUS_MODEL` または `ANTHROPIC_DEFAULT_SONNET_MODEL` を設定することで、新しいモデルを利用できます。

以前のバージョンでは、これらのエイリアスはより古いモデルに解決されます。各エイリアスがどのバージョンで変更されたかについては、[バージョン履歴](#version-history)を参照してください。

エイリアスはプロバイダーの推奨バージョンを指しており、時間の経過とともに更新されます。特定のバージョンに固定するには、完全なモデル名（例: `claude-opus-5-5`）を使用するか、`ANTHROPIC_DEFAULT_OPUS_MODEL` などの対応する環境変数を設定してください。

<Note>
  Sonnet 5.5 には Claude Code v2.1.284 以降、Opus 5.5 には v2.1.280 以降が必要です。古いバージョンからこれらのモデルへのリクエストが失敗する場合は、[Claude Code does not support this model](/docs/ja/errors#claude-code-does-not-support-this-model) を参照してください。アップグレードするには `claude update` を実行します。
</Note>

<h3 id="work-with-fable">
  Fable を使用する
</h3>

[Claude Fable 5.1](https://platform.claude.com/docs/en/about-claude/models/overview) と Claude Fable 5 は Claude Code で最も高性能なモデルであり、1 回の作業時間に収まらない規模のタスクに適しています。長時間の自律的なセッションを維持し、行動する前に調査を行い、小規模なモデルよりも頻繁に自身の作業を検証します。Fable 5.1 は新しいリリースです。

どちらの Fable モデルも、いずれのプランやプロバイダーにおいてもアカウント種別のデフォルトではありません。明示的に選択してください。

* **Fable 5.1**: `/model fable` を実行するか、`claude --model fable` で起動します。エイリアスが Fable 5 に解決される [Claude apps gateway](/docs/ja/claude-apps-gateway) のセッションでは、代わりに `/model claude-fable-5-1` を実行します。
* **Fable 5**: モデル ID で選択します。Anthropic API では、`/model claude-fable-5` を実行するか、`claude --model claude-fable-5` で起動します。その他のプロバイダーでは、プロバイダーの Fable 5 モデル ID を使用するか、`ANTHROPIC_DEFAULT_FABLE_MODEL` で[固定](#pin-models-for-third-party-deployments)します。

Anthropic API に直接接続していて、ユーザー設定にモデルとして `claude-fable-5` または `claude-fable-5[1m]` が保存されている場合（たとえば v2.1.257 より前に `/model` ピッカーで Fable を選択した場合）、v2.1.257 以降を初めて実行したときに、Claude Code はその保存値を `fable` または `fable[1m]` エイリアスに変更します。起動時のモデル行には `(auto-updated)` が一度だけ表示されます。プロジェクト設定、ローカル設定、または管理設定にある `claude-fable-5` の値はそのまま残ります。

Fable モデルの安全性分類器によって警告されたリクエスト（主にサイバーセキュリティや生物学の分野）は、[自動モデルフォールバック](#automatic-model-fallback)をトリガーします。

Fable を最大限に活用するには:

* **手順ではなく結果を説明する**: 望む結果を伝え、その道筋は Fable に計画させます。その結果に向けて作業を続けさせるには、[ゴールを設定](/docs/ja/goal)します。
* **曖昧な問題を任せる**: 根本原因の調査、障害のデバッグ、アーキテクチャの決定などは、追加の調査と検証が効果を発揮する場面です。
* **検証のリマインダーを省く**: Fable は少ない指示で自身の作業を検証するため、テストや確認を促すリマインダーは通常不要です。
* **より大きなタスクを任せる**: 通常なら分割するような作業を与えてください。Fable は長いセッションでも文脈を見失いません。

<Note>
  Fable 5.1 には Claude Code v2.1.257 以降が必要です。古いバージョンからのリクエストが失敗する場合は、[Claude Code does not support this model](/docs/ja/errors#claude-code-does-not-support-this-model) を参照してください。アップグレードするには `claude update` を実行します。ゼロデータ保持での利用可否については、[ZDR でのモデルの利用可否](/docs/ja/zero-data-retention#model-availability-under-zdr)を参照してください。
</Note>

Anthropic API では、[`availableModels`](#restrict-model-selection) または[組織のモデル制限](#organization-model-restrictions)によって除外されない限り、Fable モデルは `/model` ピッカーに表示されます。組織が Fable をまったく使用できない場合（たとえば[ゼロデータ保持](/docs/ja/zero-data-retention#model-availability-under-zdr)の下にある場合）、その行はグレーアウトされた状態でピッカーに残り、理由が注記されます。

<h4 id="fable-and-usage-credits">
  Fable と使用クレジット
</h4>

プランやシート階層によっては、Fable の使用量がプランに含まれる上限から差し引かれるのではなく、[使用クレジット](https://support.claude.com/en/articles/12429409-extra-usage-for-paid-claude-plans)に課金される場合があります。その場合、`/model` ピッカーの Fable の行に「Requires usage credits」と表示されます。使用クレジットを管理するには、[サブスクリプションに使用クレジットを追加する](/docs/ja/costs#add-usage-credits-to-your-subscription)を参照してください。

対話セッションでは、Fable のリクエストが使用クレジットに課金される前に、Claude Code が同意プロンプトを表示します。組織請求を利用している Enterprise プランのメンバーには、このプロンプトは表示されません。使用クレジットを使って Fable で続行するか、デフォルトモデルに切り替えることができます。プロンプトを閉じることもできます。

* `/model` で Fable モデルを選択した場合は、現在のモデルが維持されます。
* セッションの途中では、Claude Code はデフォルトモデルでそのターンを続行します。

使用クレジットを使って Fable で続行することを選択すると、Claude Code はそれ以降プロンプトを表示しません。

[Remote Control](/docs/ja/remote-control) が接続されているセッション、[バックグラウンドセッション](/docs/ja/agent-view)、または[エージェントチーム](/docs/ja/agent-teams)のチームメイトのセッションでは、ターミナルの前に誰もいない可能性があるため、Claude Code はセッション途中の同意プロンプトを [`dialogExpiry`](/docs/ja/settings-reference#dialogexpiry) の期限（デフォルトは 5 分）まで保持します。期限までに誰も応答しなかった場合、Claude Code はリクエストを送信せずにターンを終了し、トランスクリプトに通知を追加します。この通知は Remote Control クライアントにも表示されます。モデルの選択は変更されず、次のメッセージで Claude Code は再度同意を求めます。

プロンプトが待機している間にできることは、セッションによって異なります。

* Remote Control が接続されている場合やチームメイトのセッションでは、ターミナルで任意のキーを押すと期限がキャンセルされ、Claude Code は応答を待ちます。
* バックグラウンドセッションでは、期限までに応答してください。
* ターミナルで誰かが入力する前にリモートクライアントから新しいメッセージを送信した場合、Claude Code は同様にターンを終了し、新しいメッセージが次のターンを開始します。ターミナルで誰かが入力した後は、Claude Code は応答を待ち続け、新しいメッセージはその後ろにキューイングされます。

別のアプリケーションが [Agent SDK](/docs/ja/agent-sdk/overview) を通じてホストしているセッションでは、プロンプトを表示するかどうかはそのアプリケーション次第です。プロンプトが表示され、同じ [`dialogExpiry`](/docs/ja/settings-reference#dialogexpiry) の期限までに誰も応答しなかった場合、Claude Code はリクエストを送信せずにターンを終了します。

`-p` フラグを使用した[非対話モード](/docs/ja/headless)や、プロンプトを表示しない Agent SDK アプリケーションでは、Claude Code は同意を求めません。そこで Fable のリクエストが使用クレジットに課金される場合、Claude Code は確認なしで課金します。

<h3 id="setting-your-model">
  モデルの設定
</h3>

モデルはいくつかの方法で設定できます。以下は優先順位の高い順です。

1. **セッション中**: `/model <alias|name>` を使用してすぐに切り替えるか、引数なしで `/model` を実行してピッカーを開きます。[Claude Code が切り替えの確認を求める場合](/docs/ja/prompt-caching#switching-models)を参照してください
2. **起動時**: `claude --model <alias|name>` で起動します
3. **環境変数**: `ANTHROPIC_MODEL=<alias|name>` を設定します
4. **設定**: 設定ファイルの `model` フィールドで永続的に設定します
5. **[新しいセッションのデフォルト](#set-a-default-model-for-new-sessions)**: `ANTHROPIC_DEFAULT_MODEL=<alias|name>` を設定します

`/model` は、ユーザー設定の `model` フィールドに書き込むことで、選択内容を新しいセッションのデフォルトとして保存します。ピッカーでは次のキーを使用します。

* `Enter`: モデルを切り替え、デフォルトとして保存します
* `s`: このセッションのみモデルを切り替え、デフォルトは変更しません。別のキーを使用するには、[`modelPicker:thisSessionOnly`](/docs/ja/keybindings#model-picker-actions) を再割り当てします

`/model <name>` を直接入力した場合は、`Enter` と同じ動作になります。このセッションのみ切り替えるには、`/model` でピッカーを開き、そのモデルの行で `s` を押します。

Enterprise プランで claude.ai アカウントでログインしており、`/model` でデフォルトを保存した場合、Claude Code はその選択をアカウントにも記録します。これには Claude Code v2.1.280 以降が必要です。

* 管理者が[組織のデフォルトモデル](#organization-default-model)を設定していない場合、[Default オプション](#default-model-setting)は記録されたモデルに解決されることがあり、その場合はピッカーの Default 行にそのモデル名が表示されます。
* [モデル制限](#restrict-model-selection)によって記録されたモデルが除外されている場合、またはそのモデルがアカウントで利用できない場合で、かつ管理者が組織のデフォルトモデルを設定していない場合、Default オプションは何も記録されていないかのように解決されます。
* `/model` で Default または `opusplan` を選択した場合、記録された選択は変更されません。

`/model` でモデルを切り替えると、その切り替えは[メインの会話のモデルを継承するサブエージェント](/docs/ja/sub-agents#choose-a-model)にも反映されます。Claude がサブエージェントを起動する際、Claude Code はセッションで使用しているモデルからそのモデルを解決するためです。Claude が調査やテスト実行をサブエージェントに委任する前に Opus に切り替えると、その作業も Opus で実行されます。カスタムサブエージェントを小さなモデルのままにするには、その定義で `model` を設定してください。

`-p` フラグを使用した[非対話モード](/docs/ja/headless)で `/model` によってモデルを設定した場合、選択は現在のセッションにのみ適用され、デフォルトとしては保存されません。このモードでの `/model` には Claude Code v2.1.205 以降が必要です。プロジェクト設定と管理設定は引き続き優先され、次回の起動時に再適用されます。管理者がユーザーの選択を上書きするように設定した[組織のデフォルトモデル](#organization-default-model)も、次回の起動時に再適用されます。

v2.1.144 から v2.1.152 では、`/model` は現在のセッションにのみ適用され、ピッカーで `d` を押すとデフォルトが保存されていました。

`--model` フラグと `ANTHROPIC_MODEL` 環境変数は、それらを指定して起動したセッションにのみ適用されます。異なるターミナルで異なるモデルを同時に実行するには、`/model` で切り替えるのではなく、それぞれ独自の `--model` フラグを指定して起動してください。

`/model` ピッカーの価格は、Claude Code が Anthropic API と直接、またはそれをプロキシする [LLM ゲートウェイ](/docs/ja/llm-gateway)経由で通信している場合に表示され、各行の価格はその行が選択するモデルの価格です。Amazon Bedrock などの[サードパーティプロバイダー](/docs/ja/third-party-integrations)や [Claude apps gateway](/docs/ja/claude-apps-gateway) では、支払う金額はプロバイダーまたはゲートウェイによって決まるため、ピッカーの行には価格が表示されません。価格は表示用のラベルにすぎず、行が選択するモデルやプロバイダーの請求額には影響しません。v2.1.206 より前は、[Claude Platform on AWS](/docs/ja/claude-platform-on-aws) とゲートウェイのセッションで Anthropic の定価が表示され、行が選択するモデルとは異なるモデルの価格が表示されることがありました。

`claude --resume`、`--continue`、または `/resume` ピッカーで再開したセッションは、現在の `model` 設定にかかわらず、トランスクリプトが保存された時点で使用していたモデルを維持します。復元されたモデルが廃止されている場合や [`availableModels`](#restrict-model-selection) によって除外されている場合、セッションは通常の優先順位に従います。これにより、別のセッションでの `/model` の選択が再開時のモデルを変更することを防ぎます。Amazon Bedrock、Google Cloud's Agent Platform、Microsoft Foundry など、Anthropic のモデル ID ではなくプロバイダー固有のデプロイ ID を使用するプロバイダーでは、トランスクリプトのモデルはまったく復元されず、セッションは通常の優先順位に従ってモデルを解決します。

新しい起動時に `--model` または `ANTHROPIC_MODEL` で選択したモデルは、引き続き復元されたモデルより優先されます。v2.1.195 以降は、[`ANTHROPIC_DEFAULT_OPUS_MODEL`](#environment-variables) 系の変数も同様に優先されます。[`ANTHROPIC_DEFAULT_MODEL`](#set-a-default-model-for-new-sessions) も、そのセクションに記載されている条件の下で優先されます。

起動時のアクティブなモデルが自分の選択ではなくプロジェクト設定または管理設定に由来する場合、起動時のヘッダーにどの設定ファイルで設定されたかが表示されます。上書きするには `/model` を実行します。プロジェクト設定または管理設定は次回の起動時に再適用されます。Claude Code を組み込み、[`CLAUDE_CODE_PROVIDER_MANAGED_BY_HOST`](/docs/ja/env-vars) を設定しているプラットフォームでは、ホストのモデル設定が管理設定のモデル設定より優先されます。一方、管理設定の `availableModels` 許可リストは、ホストが独自のものを提供しない限り有効なままです。ホストがどのキーと変数を上書きするかについては、[管理設定の優先順位の例外](/docs/ja/settings#exceptions-to-managed-settings-precedence)を参照してください。

ユーザーまたは組織が [PreModelSwitch フック](/docs/ja/hooks#premodelswitch)を設定している場合、それらは要求された切り替えが適用される前に実行され、切り替えをブロックしたり確認を求めたりできます。

組織の[管理プラグイン](/docs/ja/settings-reference#enabledplugins)がどの PreModelSwitch フックを提供しているかを Claude Code が判断できない場合（たとえば管理プラグインの読み込みに失敗した場合）、Claude Code は確認されないまま切り替えを適用するのではなく切り替えを拒否し、新しい試行のたびに再度確認します。メッセージと復旧方法については、[Model switch was blocked by a PreModelSwitch hook](/docs/ja/errors#model-switch-was-blocked-by-a-premodelswitch-hook) を参照してください。

[Agent SDK](/docs/ja/agent-sdk/overview) の `setModel()` メソッド、[デスクトップアプリ](/docs/ja/desktop)などのアプリ、または [Remote Control](/docs/ja/remote-control) 経由で接続されたデバイスからモデルを切り替える場合、Claude Code は切り替え時に値を確認します。

* **Agent SDK またはアプリ**: Claude Code v2.1.268 以降では、[カスタムモデルオプション](#add-a-custom-model-option)の場合のように Claude Code がモデル ID をローカルで受け入れる場合を除き、セッションがそのモデルに初めて切り替わるときにプロバイダーに ID を確認します。この確認はすべてのプロバイダーで実行され、プロバイダーが提供していない ID は、次のリクエストで失敗するのではなく切り替え時に拒否されます。
* **Remote Control**: Anthropic API では、Claude Code は値をローカルで確認し、リクエストは送信しません。

メッセージについては、[Model is not a recognized model id](/docs/ja/errors#model-is-not-a-recognized-model-id) および [Model not found](/docs/ja/errors#model-not-found) を参照してください。

`--model` フラグ、`ANTHROPIC_MODEL` 環境変数、または `model` 設定でモデルを設定した場合、Claude Code は事前に確認を行わないため、値を誤入力すると最初のリクエストで [There's an issue with the selected model](/docs/ja/errors#theres-an-issue-with-the-selected-model) が発生します。

要求されたモデルに廃止予定日が設定されている場合、または新しいバージョンに自動的に再マッピングされる場合、Claude Code は要求されたモデル名を示す警告を表示します。対話セッションでは、起動時の通知として表示されます。v2.1.182 以降、デフォルトのテキスト出力形式を使用している場合、[非対話モード](/docs/ja/headless)でも同じ警告が stderr に書き込まれます。このチェックは、[サブエージェントのフロントマター](/docs/ja/sub-agents)で設定された `model` も対象とします。`--output-format json` および `stream-json` では stderr への警告は抑制されます。代わりに、[結果メッセージ](/docs/ja/headless#get-structured-output)の `modelUsage` フィールドから実際のモデルを読み取ってください。

たとえば、Opus でセッションを開始します。

```bash theme={null}
claude --model opus
```

次に、セッション内からモデルを切り替えます。

```text theme={null}
/model sonnet
```

設定ファイルの例:

```json theme={null}
{
    "permissions": {
        "allow": ["Bash(npm run lint)"]
    },
    "model": "opus"
}
```

<h4 id="set-a-default-model-for-new-sessions">
  新しいセッションのデフォルトモデルを設定する
</h4>

セッションがデフォルトで開始するモデルを選択するには、`ANTHROPIC_DEFAULT_MODEL=<alias|name>` を設定します。Claude Code v2.1.236 以降が必要です。

Claude Code が新しいセッションをこの変数のモデルで開始するのは、次のいずれもモデルを選択していない場合のみです。

* `--model` フラグ
* `ANTHROPIC_MODEL`
* いずれかの設定ファイルにある `model` の値（`/model` で保存した選択を含む）
* [組織のデフォルトモデル](#organization-default-model)

`/model` で保存した選択は、以降の起動でもこの変数より優先されます。代わりに `ANTHROPIC_MODEL` を設定している場合、`/model` で何を保存したかにかかわらず、Claude Code は次回の起動時にその変数のモデルに戻ります。

組織のデフォルトモデルが適用されない限り、Claude Code は Default オプションもこの変数のモデルに解決します。Default オプションがこの変数のモデルに解決される場合、`/model` ピッカーの Default 行には Set by ANTHROPIC\_DEFAULT\_MODEL というラベルが表示されます。

次の場合、Claude Code はこの変数を無視し、Default オプションは変数を設定していないかのように解決されます。

* `default`、`inherit`、`opusplan`、または `haiku` に設定している
* [`enforceAvailableModels`](#enforce-the-allowlist-for-the-default-model) がオンになっている
* 組織の[モデル制限](#restrict-model-selection)によってそのモデルが除外されている
* そのモデルがアカウントで利用できない

新しいセッションがこの変数のモデルで開始される場合、`claude --resume`、`--continue`、または `/resume` ピッカーで再開したセッションもそのモデルで開始されます。Claude Code はそのセッションのトランスクリプトに保存されたモデルを復元しません。それ以外の場合、[セッションを再開](#setting-your-model)するときに Claude Code はこの変数を使用しません。

<h4 id="a-new-session-starts-on-a-different-model-than-you-picked">
  新しいセッションが選択したものとは異なるモデルで開始される
</h4>

`/model` でモデルを選択したのに次のセッションが別のモデルで開始される場合、通常は次のような原因があります。

* **1 つのセッションのみを対象に選択した。** ピッカーで `s` を押す、`--model` で起動する、非対話モードで `/model` を実行する、のいずれも現在のセッションにのみ適用され、保存されたデフォルトは変更されません。
* **より優先順位の高いものがモデルを設定している。** プロジェクト設定や管理設定にある `model` の値、シェルの `ANTHROPIC_MODEL`、または管理者がユーザーの選択を上書きするように設定した[組織のデフォルト](#organization-default-model)は、起動のたびに再適用されます。`/model` での選択は保存されていますが、優先順位で負けています。プロジェクト設定または管理設定がモデルを設定している場合、起動時のヘッダーにそのファイル名が表示されます。
* **Claude Code が選択を保存できなかった。** `/model` は `~/.claude/settings.json` に `model` を書き込みます。別のツールがそのファイルを生成している、または読み取り専用のコピーにリンクしているなどの理由でそのファイルに書き込めない場合、選択したモデルはそのセッションの間だけ有効で、次回の起動時には古い値が読み込まれます。ファイルを生成しているツールで `model` を設定するか、ファイルを書き込み可能にしてください。[Claude Code で行った変更が新しいセッションで失われる](/docs/ja/settings#a-change-you-made-in-claude-code-is-lost-in-new-sessions)を参照してください。
* **セッションを再開した。** `claude --resume` または `--continue` で再開したセッションは、通常、現在のデフォルトではなく[使用していたモデルを維持](#setting-your-model)します。

<h2 id="restrict-model-selection">
  モデル選択を制限する
</h2>

管理者は、[管理設定またはポリシー設定](/docs/ja/managed-settings)の `availableModels` を使用して、ユーザーが選択できるモデルを制限できます。エントリは、`sonnet` のようなモデルファミリー、`claude-sonnet-4-5` のようなバージョンプレフィックス、または `claude-sonnet-4-5-20250929` のような完全なモデル ID に一致します。バージョンプレフィックスは、それにさらにセグメントを付け加えた後続のモデル ID にも一致するため、`claude-fable-5` は Fable 5 と Fable 5.1 の両方を許可し、`claude-fable-5-1` は Fable 5.1 のみを許可します。リストが許可するモデルをブロックする方法や、各モデル ID エントリがその ID で指定されたバージョンのみを許可するようにする方法については、[特定のモデルやバージョンをブロックする](#block-specific-models-or-versions)を参照してください。

Claude Code を組み込み、[`CLAUDE_CODE_PROVIDER_MANAGED_BY_HOST`](/docs/ja/env-vars) を設定しているプラットフォームでは、ホストのモデル設定が管理モデル設定よりも優先されます。ただし、管理設定の `availableModels` 許可リストは、ホストが独自の許可リストを提供しない限り引き続き有効です。ホストがどのキーと変数を上書きするかについては、[管理設定の優先順位の例外](/docs/ja/settings#exceptions-to-managed-settings-precedence)を参照してください。

`availableModels` が設定されている場合、許可リストはユーザーがモデルを指定できるすべての場所に適用されます。

* **メインセッションのモデル**: `/model`、`--model` フラグ、`ANTHROPIC_MODEL` 環境変数、`model` 設定、[`ANTHROPIC_DEFAULT_MODEL`](#set-a-default-model-for-new-sessions)、および[セッションの再開](#setting-your-model)時に復元されるモデル
* **エイリアスの解決**: `ANTHROPIC_DEFAULT_OPUS_MODEL`、`ANTHROPIC_DEFAULT_SONNET_MODEL`、`ANTHROPIC_DEFAULT_HAIKU_MODEL`、`ANTHROPIC_DEFAULT_FABLE_MODEL` 環境変数を使って、許可されたエイリアスをリスト外のモデルにリダイレクトすることはできません
* **fast mode**: リスト外の Opus モデルに暗黙的に切り替わる場合、`/fast` は "is not in your organization's allowed models" というメッセージを表示して切り替えを拒否します
* **サブエージェントとチームメイトのモデル**: [サブエージェント](/docs/ja/sub-agents#choose-a-model)のフロントマターの `model` フィールド、Agent ツールの `model` パラメータ、[エージェントチーム](/docs/ja/agent-teams#specify-teammates-and-models)のチームメイトのモデル、`CLAUDE_CODE_SUBAGENT_MODEL`、および v2.1.197 以前では `/agents` ウィザードのモデルピッカー&#x20;
* **スキルとコマンドのモデル**: [スキルとコマンド](/docs/ja/skills)の `model` フロントマター
* **アドバイザーモデル**: 設定された [`advisorModel`](/docs/ja/advisor) 設定と `--advisor` フラグ
* **バックグラウンドエージェントのモデル**: [Dispatch ピッカー](/docs/ja/agent-view)で選択されたモデル

Anthropic API と [Claude Platform on AWS](/docs/ja/claude-platform-on-aws) では、モデルファミリーのエイリアス（`opus`、`sonnet`、`haiku`、`fable`）は、許可リストがそのモデルを許可している場合、通常のモデルに解決されます。許可リストがそのモデルをブロックしている場合、Claude Code は許可リストが許可するそのファミリーの最新バージョンに置き換え、要求されたモデルと置き換え後のモデルの両方を示す通知を表示します。たとえば `["sonnet", "claude-opus-4-6"]` の場合、`/model opus` と `--model opus` はどちらも、許可されている最新の Opus である Claude Opus 4.6 を選択します。v2.1.205 より前は、最新のリリースバージョンがリスト外にあるエイリアスは、リストが古いバージョンを許可していても、他のブロックされた選択と同様に拒否または置き換えられていました。

この置き換えには、置き換え先となる許可されたバージョンが必要です。許可リストがエイリアスのファミリーのどのバージョンも許可していない場合、そのエイリアスは他のブロックされた値と同様に、以下の拒否および置き換えの動作に従います。

Claude Code は、その他のブロックされた選択を、モデルが設定された場所に応じて次のように処理します。

* **`/model`**: Claude Code はエラーを表示して切り替えを拒否します
* **`--model` フラグ、`ANTHROPIC_MODEL`、または `model` 設定**: Claude Code は起動時に値を置き換え、要求されたモデルと置き換え後のモデルの両方を示す警告を表示します。セッションはデフォルトモデルで開始されます
* **[`ANTHROPIC_DEFAULT_MODEL`](#set-a-default-model-for-new-sessions)**: Claude Code はこの変数を無視します
* **サブエージェントまたはチームメイトの上書き**: Claude Code はリクエストを失敗させるのではなく、フォールバックモデルでサブエージェントまたはチームメイトを実行します。サブエージェントのフォールバックについては[モデルを選択する](/docs/ja/sub-agents#choose-a-model)を、チームメイトのフォールバックについては[チームメイトとモデルを指定する](/docs/ja/agent-teams#specify-teammates-and-models)を参照してください。

  インタラクティブセッションでは、このフォールバックまたは上記の許可された最新バージョンへの置き換えによってサブエージェントのモデルが置き換えられた場合、Claude Code は要求されたモデルと置き換え後のモデルを示す警告を表示します。チームメイトのフォールバックについては報告しません。

  上記の許可された最新バージョンへの置き換えが機能する環境では、ブロックされたファミリーエイリアスはそちらに従います。v2.1.222 より前は、すべてのプロバイダーで、エイリアスは他のブロックされた値と同様にフォールバックしていました
* **スキルまたはコマンドの上書き**: Claude Code は、ブロックされたファミリーエイリアスを含めて上書きを無視し、スキルまたはコマンドはセッションのモデルで実行されます。[サブエージェントで実行される](/docs/ja/skills#run-skills-in-a-subagent)スキルまたはコマンドは、代わりに上記のサブエージェントの動作に従います
* **`advisorModel` 設定**: そのセッションではアドバイザーが無効になります
* **`--advisor` フラグ**: Claude Code は起動時にエラーで終了します。[バックグラウンドセッション](/docs/ja/agent-view)では、終了する代わりにアドバイザーなしでセッションを開始します

Claude Code は、除外されたモデルを `/model` ピッカーから非表示にします。リストに含めたモデル ID が独自の行も持つかどうかは、プロバイダーによって異なります。

* **Anthropic API、[Claude Platform on AWS](/docs/ja/claude-platform-on-aws)、[Claude apps gateway](/docs/ja/claude-apps-gateway)、または `ANTHROPIC_BASE_URL` で設定した [LLM ゲートウェイ](/docs/ja/llm-gateway)**: リストに含めた Anthropic のモデル ID のうち、組み込みのピッカー行がないものは、独自のラベル付き行として表示されます。Claude Code は、リストで固定された古いバージョンなど、Opus、Sonnet、Haiku のバージョンに対してこのような行を追加します。[`modelPicker`](/docs/ja/settings-reference#modelpicker) のラインナップで `replaceBuiltInOptions` を設定している場合、その行は表示されません。v2.1.199 より前は、そのような ID は `/model <id>` と入力することでのみ選択できました。
* **Amazon Bedrock、Google Cloud の Agent Platform、または Microsoft Foundry**: リストに含めたモデル ID が `anthropic.` で始まらない限り、それが Anthropic のモデル ID であってもプロバイダー固有のものであっても、Claude Code はその行を追加しません。[Mantle のモデル ID](#mantle-model-ids) にはこのプレフィックスが付いています。組み込みの行がないリスト内のバージョンを表示するには、[`modelPicker`](/docs/ja/settings-reference#modelpicker) のラインナップにも追加してください。ラインナップはプロバイダーの形式の ID を受け付けます。

Claude Code がユーザーに代わって行うモデル変更も、同じ方法でチェックされます。

* **[フォールバックモデルチェーン](#fallback-model-chains)**: 許可リスト外のエントリは除外されます
* **plan モードのアップグレード**: Anthropic API と Claude Platform on AWS では、[`opusplan`](#opusplan-model-setting) のように除外されたモデルへのアップグレードは、アップグレード先ファミリーの許可された最新バージョンを使用します。プロバイダー固有のモデル ID を持つプロバイダーの場合、および許可されたバージョンがない場合は、アップグレードはスキップされ、計画はセッションのモデルで続行されます
* **[自動モデルフォールバック](#automatic-model-fallback)**: フォールバック先が除外されている場合、フォールバックは実行されないため、警告されたリクエストは代わりに拒否で終了します
* **[auto モードの分類器](/docs/ja/permission-modes#eliminate-prompts-with-auto-mode)**: 分類器のデフォルトである Claude Sonnet 5 は、許可リストが Sonnet 5 を許可している場合にのみ適用されます。除外されている場合、分類器はセッションのモデル（すでに許可リストの制御下にあります）で実行されるか、セッションが [Fable モデル](#work-with-fable)で実行されている場合は Opus モデルで実行されます。Anthropic API 以外のプロバイダーでは、その Opus フォールバックは許可リストを参照せずに、`ANTHROPIC_DEFAULT_OPUS_MODEL` で設定したモデル、または設定していない場合は Opus 5 で実行されます。Claude Code v2.1.210 以降が必要です
* **[fast mode](/docs/ja/fast-mode)**: 有効化後にセッションが実行されるモデルが許可リスト外である場合、fast mode の有効化は拒否されます

```json theme={null}
{
  "availableModels": ["sonnet", "haiku"]
}
```

<h3 id="surface-coverage">
  サーフェスごとの適用範囲
</h3>

すべてのサーフェスは、受け取った許可リストを適用します。各サーフェスに届く配信メカニズムは次のように異なります。

| 配信メカニズム | CLI と IDE | Desktop のローカルセッション | Web、モバイル、クラウドセッション | Agent SDK と非インタラクティブ | Cowork |
| :- | :- | :- | :- | :- | :- |
| 管理コンソールからの[サーバー管理設定](/docs/ja/server-managed-settings) | 適用される | 適用される | 適用される（[Claude Tag](https://claude.com/docs/claude-tag/overview) セッションを除く） | 適用される | リモート Cowork セッション: サーバーがモデルをチェックします。ユーザーのマシン上: 配信されません。 |
| [MDM または管理設定ファイル](/docs/ja/managed-settings#delivery-mechanisms) | 適用される | 適用される | Anthropic がホストする環境には配信されません。[セルフホスト環境](/docs/ja/self-hosted-environments)では、[Claude Code が管理ソースを組み合わせる方法](/docs/ja/managed-settings#how-claude-code-combines-managed-sources)に従ってランナーイメージから適用されます | 適用される | デプロイされている場所で適用される |

* Desktop アプリから開始したものを含む[クラウドセッション](/docs/ja/claude-code-on-the-web)は、デフォルトで Anthropic が管理する VM 上で実行されます。デバイスにデプロイされた設定はこれらに届かないため、許可リストはサーバー管理設定を通じて配信してください。組織が[セルフホスト環境](/docs/ja/self-hosted-environments)にルーティングするセッションは独自のコンピューティング上で実行され、ランナーイメージ内の管理設定ファイルも読み取ります。そのファイルがいつ適用されるかについては、[Claude Code が管理ソースを組み合わせる方法](/docs/ja/managed-settings#how-claude-code-combines-managed-sources)を参照してください。クラウドセッションでのセッション途中のモデル切り替えは、要求されたモデルが許可リストによって除外されている場合は拒否されます。サーバー管理設定の `availableModels` リストが空でない場合、サーバーは、リストが除外するモデルで claude.ai/code または Desktop アプリからクラウドセッションを開始するリクエストを拒否します。
* [Claude Tag](https://claude.com/docs/claude-tag/overview) セッションはクラウド環境で実行されますが、サーバー管理設定を受け取りません。[セルフホスト環境](/docs/ja/self-hosted-environments)では、引き続きランナーイメージ内の管理設定ファイルを読み取ります。これらのセッションのモデルを設定するには、Claude Tag 管理者ガイドの[スコープのモデルを選択する](https://claude.com/docs/claude-tag/admins/customize#choose-the-model-for-a-scope)を参照してください。
* Claude Desktop アプリのエージェント型作業タブである Cowork は、セッションを Claude Code 上で実行しますが、設計上、claude.ai 管理コンソールからサーバー管理設定を受け取りません。サーバー管理設定の `availableModels` リストが空でなく、ユーザーがリスト外のモデルを選択した場合、サーバーはリモート Cowork セッションでそのモデルを拒否します。管理設定ファイルは、セッションが実行される場所に存在する場合に Cowork セッションに適用されます。リモート Cowork セッションは Anthropic が管理する VM 上で実行され、そこにはデバイスにデプロイされたファイルは存在しません。
* Amazon Bedrock、Google Cloud の Agent Platform、Microsoft Foundry、[Claude Platform on AWS](/docs/ja/claude-platform-on-aws) などの[サードパーティプロバイダー](/docs/ja/server-managed-settings#platform-availability)上のセッションはサーバー管理設定を受け取らないため、それらの環境では MDM または管理設定ファイルを通じて許可リストを配信してください。
* サーバー管理による配信では、セッションが[対象となるログインまたはキー](/docs/ja/server-managed-settings#platform-availability)で認証されている必要もあります。[`apiKeyHelper`](/docs/ja/settings-reference#apikeyhelper) スクリプトを通じてのみキーを生成するフリートでは、MDM または管理設定ファイルを通じて許可リストを配信してください。
* Desktop の Code タブは [SSH セッション](/docs/ja/desktop#ssh-sessions)もホストしており、これらは実行先のリモートホストから管理設定ファイルを読み取ります。[Desktop の管理設定](/docs/ja/desktop#managed-settings)を参照してください。
* claude.ai および Desktop アプリのモデルピッカーは、組織の許可リストによって除外されたモデルを非表示にするかグレーアウトします。ピッカーの状態はユーザーの利便性のためのものであり、許可リストを適用するものではありません。

<h3 id="default-model-behavior">
  デフォルトモデルの動作
</h3>

デフォルトのプレフィックス一致では、`availableModels` 単独では、[`enforceAvailableModels`](#enforce-the-allowlist-for-the-default-model) も設定するまで、Default オプションはアカウントに対するシステムの[ランタイムデフォルト](#default-model-setting)のままになります。そのデフォルトが制限したいモデルである場合は、`enforceAvailableModels` も設定するか、[そのモデルをブロック](#block-specific-models-or-versions)してください。

`availableModels: []` の場合、名前を指定したモデル選択はブロックされ、`enforceAvailableModels` は効果を持ちません。

<h3 id="enforce-the-allowlist-for-the-default-model">
  Default モデルに許可リストを適用する
</h3>

管理設定で、空でない `availableModels` とともに `enforceAvailableModels: true` を設定すると、許可リストが Default オプションにも適用されます。これには Claude Code v2.1.175 以降が必要です。

```json theme={null}
{
  "availableModels": ["sonnet", "haiku"],
  "enforceAvailableModels": true
}
```

[アカウントにモデルが記録されていない](#setting-your-model)メンバーの場合、Default オプションはアカウントタイプのデフォルト、または管理者が設定している場合は[組織のデフォルトモデル](#organization-default-model)に解決されます。そのモデルが許可リストにない場合、Default オプションは代わりに、許可されていて利用可能なモデルを指定する最初の `availableModels` エントリに解決され、`/model` ピッカーの Default 行にはそのモデルが表示されます。これは、デフォルトに到達するすべての場所に適用されます。つまり、セッションの起動時、`/model` で Default を選択した場合、[フォールバックモデルチェーン](#fallback-model-chains)の `"default"` キーワード、および除外された選択が除外されたときに使用されるフォールバックです。メンバーのアカウントに記録されたモデルも `availableModels` に照らしてチェックされます。Default オプションがそれをどのように扱うかについては、[モデルを設定する](#setting-your-model)を参照してください。

`enforceAvailableModels` は、`availableModels` が空でない場合にのみ Default オプションを再マッピングします。`availableModels` が空でないものの、許可されていて利用可能なモデルに解決されるエントリがない場合、適用はスキップされ、`--debug` でのみ表示される警告が出されます。これを避けるには、確実に利用可能なエントリを少なくとも 1 つリストに含めてください。

両方のキーは、配信する管理ソースのうち最も順位の高いものに一緒にデプロイしてください。デフォルトでは Claude Code はそのソースのみを読み取るため、管理コンソールが何らかの設定を配信している場合、管理設定ファイルに配置したペアは無視されます。[Claude Code が管理ソースを組み合わせる方法](/docs/ja/managed-settings#how-claude-code-combines-managed-sources)のオプトインのマージを使用する場合でも、Claude Code は `availableModels` を設定するソースより下位のソースからの `modelOverrides` マップを無視します。

<h3 id="control-the-model-users-run-on">
  ユーザーが実行するモデルを制御する
</h3>

`model` 設定は初期選択であり、適用ではありません。これはセッション開始時にどのモデルがアクティブになるかを設定しますが、ユーザーは引き続き `/model` を開いて Default を選択できます。Default は、[`enforceAvailableModels`](#enforce-the-allowlist-for-the-default-model) または[特定のバージョンをブロックするキー](#block-specific-models-or-versions)が適用されない限り、`model` の設定値に関係なくシステムの[ランタイムデフォルト](#default-model-setting)に解決されます。

モデルの動作を完全に制御するには、次の設定を組み合わせます。

* **`availableModels`**: ユーザーが切り替えられる名前付きモデルを制限します
* **`enforceAvailableModels`**: `availableModels` 許可リストを Default オプションに拡張し、Default がリスト外のモデルに解決されないようにします
* **`deniedModels`** と **`availableModelsMatch`**: `availableModels` エントリがなければ許可されてしまう[特定のバージョンをブロック](#block-specific-models-or-versions)します
* **`model`**: セッション開始時の初期モデル選択を設定します
* **`ANTHROPIC_DEFAULT_SONNET_MODEL`** / **`ANTHROPIC_DEFAULT_OPUS_MODEL`** / **`ANTHROPIC_DEFAULT_HAIKU_MODEL`** / **`ANTHROPIC_DEFAULT_FABLE_MODEL`**: `sonnet`、`opus`、`haiku`、`fable` エイリアスが何に解決されるか、および[アカウントタイプのデフォルト](#default-model-setting)がどのバージョンを使用するかを制御します

この例では、ユーザーを Sonnet 4.5 で開始させ、ピッカーを Sonnet と Haiku に制限し、Default がティアのデフォルトではなく許可リスト上のモデルに解決されるようにします。

```json theme={null}
{
  "model": "claude-sonnet-4-5",
  "availableModels": ["claude-sonnet-4-5", "haiku"],
  "enforceAvailableModels": true,
  "env": {
    "ANTHROPIC_DEFAULT_SONNET_MODEL": "claude-sonnet-4-5"
  }
}
```

`enforceAvailableModels` や `env` ブロックがない場合、ピッカーで Default を選択したユーザーには、`model` で固定されたバージョンではなく[ランタイムデフォルト](#default-model-setting)が適用されます。この 2 つの設定は異なる範囲をカバーします。`enforceAvailableModels` は Default を許可リストに従わせ、`env` ブロックは `sonnet` などの許可されたエイリアスがどのバージョンに解決されるかを固定します。モデルファミリーを制限するだけで十分な場合は `enforceAvailableModels` のみを使用し、特定のバージョンも固定する必要がある場合は `env` ブロックを追加してください。

<h3 id="merge-behavior">
  マージの動作
</h3>

Claude Code が適用する管理設定で `availableModels` が定義されている場合、[独自のものを提供するホストプラットフォーム](/docs/ja/settings#exceptions-to-managed-settings-precedence)を除き、そのリストのみが適用されます。ユーザー設定、プロジェクト設定、ローカル設定のエントリでそれを拡張することはできず、Claude Code は管理ソース間で `availableModels` をマージすることもありません。どのソースのリストが適用されるかについては、[Claude Code が管理ソースを組み合わせる方法](/docs/ja/managed-settings#how-claude-code-combines-managed-sources)を参照してください。それ以外の場合、ユーザー設定、プロジェクト設定、ローカル設定のリストは、他の配列設定と同様に[連結され、重複が除去されます](/docs/ja/settings#settings-precedence)。Claude Code v2.1.175 より前は、優先順位の低いスコープのエントリは、管理リストに置き換えられるのではなく、管理リストにマージされていました。

有効なリスト内で、ファミリー内の特定のモデルを指定するエントリ（バージョンプレフィックスまたは完全なモデル ID）は、そのファミリーのワイルドカードエントリを無効にします。`["sonnet", "claude-sonnet-4-5"]` は、すべての Sonnet モデルではなく、Sonnet 4.5 のバージョンのみを許可します。

<h3 id="mantle-model-ids">
  Mantle のモデル ID
</h3>

`availableModels` 内の `anthropic.` で始まるエントリは、カスタムオプションとして `/model` ピッカーに追加されます。これは、[サードパーティのデプロイ向けにモデルを固定する](#pin-models-for-third-party-deployments)で説明されているエイリアス一致の例外です。[Amazon Bedrock Mantle エンドポイント](/docs/ja/amazon-bedrock#use-the-mantle-endpoint)が有効な場合、Claude Code は Mantle 形式に一致するエントリをそのエンドポイントにルーティングします。この設定は引き続きピッカーをリストされたエントリに制限し、Mantle ID にはファミリー名が含まれているため、特定のエントリとしてカウントされ、そのファミリーのワイルドカードを無効にします。Mantle ID と併せて、選択可能なままにしたいバージョンプレフィックスまたは完全な ID をリストしてください。[マージの動作](#merge-behavior)を参照してください。

<h3 id="block-specific-models-or-versions">
  特定のモデルやバージョンをブロックする
</h3>

`claude-opus-5` のような `availableModels` エントリは、Opus 5.5 など、それを拡張する後続のリリースも、Claude Code がサポートした時点で許可します。リリースを保留するための管理設定が 2 つあり、どちらも Claude Code v2.1.283 以降が必要です。

* [`deniedModels`](/docs/ja/settings-reference#deniedmodels): ブロックするモデルをリストします。リストされたモデルは、`availableModels` が許可している場合でもブロックされ、このキーは許可リストがまったくない場合でも機能します。どのエントリにもブロックされないリリースは許可されたままです
* [`availableModelsMatch`](/docs/ja/settings-reference#availablemodelsmatch): これを `"exact"` に設定すると、`availableModels` 内の各モデル ID は、その ID で指定されたバージョンのみを許可します。リストされたモデル ID の新しいバージョンは、リストに追加するまでブロックされたままになります

以前のバージョンはどちらのキーも無視するため、それらのバージョンが起動しないように [`requiredMinimumVersion`](/docs/ja/settings-reference#requiredminimumversion) も設定してください。

この例では、Opus と Sonnet のモデルを許可し、日付付きの ID やプロバイダー固有の ID を含むあらゆる表記の Opus 5.5 をブロックします。

```json theme={null}
{
  "availableModels": ["opus", "sonnet"],
  "deniedModels": ["claude-opus-5-5"]
}
```

ブロックされたモデル（`deniedModels` で指定されたもの、または `"exact"` リストで省略されたもの）は、[許可リストが適用される](#restrict-model-selection)すべての場所で、ブロックされた選択として扱われます。`/model` ピッカーから非表示になり、`/model <name>` はそれを拒否します。`--model`、`ANTHROPIC_MODEL`、または `model` 設定でブロックされたモデル ID を指定すると、Claude Code は起動時にそれを除外し、代わりに Default オプションを解決します。[フック](/docs/ja/hooks)やバックグラウンドのリクエストが `deniedModels` によってブロックされたモデルを指定した場合（エージェントフックの `model` フィールドなど）、そのリクエストは代わりにセッションのモデルで実行されます。

Default オプションも、[`enforceAvailableModels`](#enforce-the-allowlist-for-the-default-model) を設定しているかどうかにかかわらず、両方のキーに従います。空でない `availableModels` とともにそれを設定している場合、ブロックされたデフォルトは許可リスト外のモデルとしてカウントされます。それ以外の場合、ブロックされたモデルに解決されることになる Default オプションは、次の順序で段階的に切り替わります。

1. 同じファミリーの許可された最新バージョン
2. より低コストの各ファミリーの許可された最新モデル（順に Sonnet、次に Haiku）
3. 許可されたモデルを指定する最初の `availableModels` エントリ

これらのいずれも許可されていない場合、Default オプションで開始するセッションは、修正すべきキーを示すエラーとともに[起動を拒否します](/docs/ja/errors#managed-settings-block-the-default-model)。`"exact"` リストが Default オプションに影響するのは、管理設定の `availableModels` リストが少なくとも 1 つのモデルまたはファミリーを指定している場合のみです。

Claude Code は、両方のキーを管理設定からのみ読み取ります。ユーザー設定、プロジェクト設定、ローカル設定、または `--settings` でいずれかを設定した場合、Claude Code は警告を表示してそれを無視します。

<h3 id="organization-model-restrictions">
  組織のモデル制限
</h3>

Claude Enterprise プランの組織管理者は、claude.ai 管理コンソールで個々のモデルを無効にすることで、メンバーが実行できるモデルを制限します。この制限は、Claude Code の認証時にアカウントのエンタイトルメントとともに配信され、設定内の `availableModels` リストとは別のものです。また、サーバーはセッション作成時に同じ制限を独立して適用します。Claude Code v2.1.187 以降が必要です。

この制限は、メンバーがサインインした場合、または自身の API キーを使用した場合に適用されます。組織サービスキーなどの組織スコープの認証情報はユーザーに紐付いていないため、制限は適用されません。

Claude Console にはモデル制限の制御機能はありません。Anthropic API を通じてメンバーが認証する組織を含め、Claude Enterprise プランを持たない組織は、代わりに[管理設定](/docs/ja/managed-settings)の [`availableModels`](#restrict-model-selection) でモデルを制限し、Default オプションをカバーするために [`enforceAvailableModels`](#enforce-the-allowlist-for-the-default-model) を追加します。各サーフェスがこれらの設定をどのように受け取り適用するかについては、[サーフェスごとの適用範囲](#surface-coverage)を参照してください。

制限されたモデルは `/model` ピッカーから非表示になります。`--model`、`ANTHROPIC_MODEL` 環境変数、または `model` 設定で名前を指定してそれを選択すると、`Model "<name>" is restricted by your organization's settings. Using <model> instead.` という通知が表示され、セッションは許可されたモデルで開始されます。制限されたモデルに対して `/model <name>` と入力すると、`Model '<name>' is restricted by your organization's settings. Run /model to choose a different model.` と表示されて拒否され、セッションは現在のモデルを維持します。

`opus` などの[モデルファミリーのエイリアス](#restrict-model-selection)は、組織がそのモデルを許可している場合、通常のモデルに解決されます。組織がそのモデルを制限している場合、Claude Code は組織が許可するそのファミリーの最新バージョンに置き換え、同じ置き換え通知を表示します。`/model <alias>` が拒否されるのは、そのファミリーのすべてのバージョンが制限されている場合のみです。その場合でも、`--model`、`ANTHROPIC_MODEL`、または `model` 設定で設定されたエイリアスは、起動時に置き換えられます。v2.1.205 より前は、古いバージョンが許可されていても、ファミリーエイリアスは最新のリリースバージョンのみに基づいて置き換えまたは拒否されていました。

制限は組織全体またはロールごとに適用されます。

* 組織レベルでモデルを無効にすると、すべてのメンバーからそのモデルが削除されます。
* ロールレベルのアクセスでは、カスタムロールごとに異なるモデルを付与でき、複数のロールを持つメンバーは、いずれかのロールが付与するモデルを使用できます。
* Haiku モデルは常に利用可能で無効にできないため、すべてのメンバーは少なくとも 1 つの使用可能なモデルを保持します。
* アクセスの変更は、約 1 分以内に新しいリクエストに反映されます。`/model` ピッカーには、次回のセッション開始時に反映されます。

両方の制限は同時に適用されます。モデルが選択可能になるのは、`availableModels` で許可されていて、かつ組織によって制限されていない場合のみです。組織の制限が適用されるのは、Anthropic API および [LLM ゲートウェイ](/docs/ja/llm-gateway)のデプロイ上のセッションのみです。その他のプロバイダーでは、代わりに `availableModels` を使用してください。

<h2 id="organization-default-model">
  組織のデフォルトモデル
</h2>

Claude Enterprise プランの組織管理者は、claude.ai の管理コンソールから、組織全体またはカスタムロールごとに Claude Code メンバー向けのデフォルトモデルを設定できます。設定されている場合、Default オプションはそのモデルに解決されます。Claude Code v2.1.196 以降が必要です。

`/model` ピッカーの Default 行には、組織のデフォルトモデルの名前が Org default というラベル付きで表示されます。管理者が組織全体に対してデフォルトを設定した場合でも、ユーザーのロールに対して設定した場合でも、ラベルは Org default と表示されます。ロールのデフォルトはそのカスタムロールのメンバーに適用され、組織全体のデフォルトよりも優先されます。ユーザーの複数のロールで異なるデフォルトが設定されている場合は、最も高性能なモデルが適用されます。

組織のデフォルトは出発点であり、制限ではありません。次の選択は組織のデフォルトよりも優先されます。

* `--model` フラグおよび `ANTHROPIC_MODEL` 環境変数
* [管理設定](/docs/ja/managed-settings)内の `model` の値、または `--settings` で指定された `model` の値
* ユーザー、プロジェクト、またはローカル設定内の `model` の値（`/model` で保存したモデルを含む）

管理者は、組織のデフォルトがユーザーの選択を上書きするように設定することもできます。上書きが有効な場合、組織のデフォルトはユーザー、プロジェクト、ローカル設定内の `model` の値よりも優先されるため、`/model` で保存したモデルは現在のセッションにのみ適用され、次回の起動時には組織のデフォルトに戻ります。ユーザーの選択が異なる場合、`/model` には `Your organization's default (<model>) applies on restart` と表示されます。上書きが有効な場合でも、`--model` フラグ、`ANTHROPIC_MODEL`、管理設定、`--settings` は引き続き優先されます。

メンバーが選択できるモデルを制限するには、代わりに[組織のモデル制限](#organization-model-restrictions)または [`availableModels`](#restrict-model-selection) を使用してください。

Claude Code は起動時に一度だけ組織のデフォルトを読み込むため、セッション中に管理者がデフォルトを変更した場合は、次回の起動時に反映されます。

組織のデフォルトがユーザーの選択を上書きしない場合、管理者がデフォルトを変更した後の最初の対話型起動時に、ユーザー設定から `model` キーが一度だけ削除され、新しいデフォルトが適用されます。ファイル内のそれ以外の内容は変更されず、その起動後に `/model` で保存したモデルは保持されます。

組織のデフォルトは、採用される前に次の制限チェックを通過します。

* デフォルトのプレフィックスマッチングでは、[`availableModels`](#restrict-model-selection) 単体では組織のデフォルトに適用されないため、許可リストに含まれない組織のデフォルトも引き続き適用されます。[`enforceAvailableModels`](#enforce-the-allowlist-for-the-default-model) も設定されている場合は、許可リストに含まれない組織のデフォルトも許可リストの最初のエントリに再マッピングされます
* [組織のモデル制限](#organization-model-restrictions)によってユーザーのアカウントで拒否されている組織のデフォルトは、同じファミリー内で許可されている最新のモデルに置き換えられます。そのファミリーのすべてのバージョンが制限されている場合は、より低コストのファミリーに置き換えられます
* `deniedModels` または `"exact"` リストによってブロックされる組織のデフォルトについては、[特定のモデルまたはバージョンをブロックする](#block-specific-models-or-versions)を参照してください
* ユーザーのアカウントでまったく利用できない組織のデフォルトはスキップされ、Default オプションは[組織のデフォルトがない場合](#default-model-setting)と同様に解決されます

v2.1.199 以降では、組織のデフォルトがユーザーのアカウントタイプの通常のデフォルトとは異なるモデルファミリーである場合、`/model` ピッカーにはその通常のファミリー用の行が別途残るため、セッション中にそのファミリーへ切り替えることもできます。v2.1.196 から v2.1.198 では、この行はピッカーに表示されません。

組織のデフォルトは、Anthropic API で認証されたセッションにのみ適用されます。[LLM ゲートウェイ](/docs/ja/llm-gateway)のデプロイを含むその他の環境でデフォルトを設定するには、代わりに[管理設定](/docs/ja/managed-settings)の `model` キーを使用してください。

<h2 id="organization-effort-limits">
  組織の effort 上限
</h2>

組織は、[effort レベル](#adjust-effort-level)に 2 つの方法で上限を設定できます。Claude Enterprise プランでは、組織の管理者が以下で説明するロールごとの effort 上限を設定します。Amazon Bedrock、Google Cloud の Agent Platform、Microsoft Foundry を含むすべてのプランとプロバイダーでは、代わりに [`maxEffortLevel`](/docs/ja/settings-reference#maxeffortlevel) 管理設定によってクライアント側で effort に上限が設定されます。1 つのモデルに両方が適用される場合は、低いほうの上限が適用されます。

Claude Enterprise プランの組織管理者は、ロールレベルの[組織のモデル制限](#organization-model-restrictions)とあわせて、カスタムロールごとにモデル単位で [effort レベル](#adjust-effort-level)の最大値を設定できます。上限を超えるレベルは `/effort` ピッカーに表示されず、`--effort` または `/effort` でより高いレベルを指定した場合は、代わりに上限のレベルで実行されます。対話型セッションとプレーンテキストの `--print` 実行では、要求されたレベルと適用されたレベルを示す警告が表示されます。`json` または `stream-json` 出力の場合やバックグラウンドエージェントでは、上限への制限は警告なしで適用されます。上限はモデルごとに設定されるため、モデルを切り替えると利用可能なレベルが変わることがあります。ユーザーの複数のロールが同じモデルを許可している場合は、最も制限の緩い上限が適用されます。Claude Code v2.1.195 以降が必要です。

effort 上限は[組織のモデル制限](#organization-model-restrictions)と一緒に配信され、同じセッションに適用されます。

<h2 id="special-model-behavior">
  特殊なモデルの動作
</h2>

<h3 id="default-model-setting">
  `default` モデル設定
</h3>

`default` の動作はアカウントの種類によって異なります。

* **Pro、Max、Team、Enterprise、Anthropic API**：デフォルトは Opus 5.5
* **Claude Platform on AWS、Amazon Bedrock、Google Cloud's Agent Platform**：デフォルトは Opus 5.5
* **Microsoft Foundry**：デフォルトは Sonnet 4.5

v2.1.280 より前は、`default` は Pro と Team Standard では Sonnet 5 に、Max、Team Premium、Enterprise、Anthropic API では Opus 5 に解決され、Claude Platform on AWS、Amazon Bedrock、Google Cloud's Agent Platform では v2.1.219 以降 Opus 5 に解決されていました。v2.1.219 より前は、`default` は Anthropic API、Max、Team Premium、Enterprise の従量課金では v2.1.154 以降 Opus 4.8 に解決され、Claude Platform on AWS、Amazon Bedrock、Google Cloud's Agent Platform では v2.1.207 以降 Opus 4.8 に解決されていました。v2.1.207 より前は、`default` は Claude Platform on AWS では Opus 4.7 に、Amazon Bedrock と Google Cloud's Agent Platform では Sonnet 4.5 に解決されていました。

管理者が[組織のデフォルトモデル](#organization-default-model)を設定している場合、`default` は上記のアカウント種類ごとのデフォルトではなく、そのモデルに解決されます。Claude Code v2.1.196 以降が必要です。また、`default` は、該当セクションに記載された条件のもとで [`ANTHROPIC_DEFAULT_MODEL`](#set-a-default-model-for-new-sessions) で設定したモデルに解決されることや、[アカウントに記録されている](#setting-your-model)モデルに解決されることもあります。

アカウントに何も記録されておらず、管理設定で[Default モデルに許可リストが強制](#enforce-the-allowlist-for-the-default-model)されていて、かつアカウント種類ごとのデフォルトが `availableModels` に含まれていない場合、`default` は上記のアカウント種類ごとのデフォルトではなく、強制された Default に解決されます。組織のデフォルトと強制の両方が適用される場合は、まず組織のデフォルトがアカウント種類ごとのデフォルトを置き換え、その後に強制が適用されます。許可リストに含まれる組織のデフォルトはそのまま維持され、リスト外のものは強制された Default に解決されます。

Fable モデルは、どのプランやプロバイダーでもアカウント種類ごとのデフォルトにはなりません。`/model` で Fable モデルを選ぶと、ユーザー設定に選択中のモデルとして保存されるため、以降のセッションはそのモデルで開始されます。v2.1.257 で Claude Code が保存済みの Fable 5 の選択に対して行う一度限りの変更については、[Fable を使用する](#work-with-fable)を参照してください。

<h3 id="opusplan-model-setting">
  `opusplan` モデル設定
</h3>

`opusplan` モデルエイリアスは、自動化されたハイブリッドアプローチを提供します。

* **plan モードの場合**：複雑な推論やアーキテクチャ上の判断に `opus` を使用します
* **実行モードの場合**：コード生成と実装のために自動的に `sonnet` に切り替えます

これにより、計画には Opus の推論能力を、実行には Sonnet の効率性を組み合わせられます。

plan モードの Opus フェーズは `opus` モデル設定と同じコンテキストウィンドウを使用し、実行フェーズは `sonnet` と同じウィンドウを使用します。`opus` と `sonnet` が、Anthropic API 上の現行モデルのようにデフォルトで [1M コンテキストウィンドウ](#extended-context)で動作するモデルに解決される場合は、両方のフェーズがそのウィンドウで動作します。そうでない場合に両方のフェーズで 1M コンテキストを要求するには、たとえば `/model opusplan[1m]` のように、[モデルを](#setting-your-model) `opusplan[1m]` に設定します。`/model` での設定には Claude Code v2.1.265 以降が必要です。それより前のバージョンでは、代わりに `--model` フラグまたは `model` 設定を使用してください。

[`availableModels`](#restrict-model-selection) が最新の Opus を除外しつつ古いバージョンを許可している場合（たとえば `["sonnet", "claude-opus-4-6"]`）、`opusplan` は許可されている最新の Opus を計画に使用し、すべての Opus が除外されている場合にのみ Sonnet のままになります。同様に、通常は plan モードで Sonnet にアップグレードされる Haiku セッションは、許可されている最新の Sonnet を使用し、すべての Sonnet が除外されている場合にのみ Haiku のままになります。v2.1.205 より前は、アップグレード先ファミリーの最新バージョンが除外されていると、許可リストが古いバージョンを許可していても、plan モードはセッションのモデルのままでした。

許可されている古いバージョンへの置き換えは、Anthropic API と [Claude Platform on AWS](/docs/ja/claude-platform-on-aws) に適用されます。デプロイでプロバイダー固有のモデル ID を使用する Amazon Bedrock、Google Cloud's Agent Platform、Microsoft Foundry、Mantle では、アップグレード先のモデルが除外されている場合、plan モードはセッションのモデルのままになります。

計画の境界で切り替えるのではなく、タスクの途中で Claude が 2 つ目のモデルに相談するタイミングを判断するハイブリッドアプローチについては、[advisor ツール](/docs/ja/advisor)を参照してください。

<h3 id="fallback-model-chains">
  フォールバックモデルチェーン
</h3>

プライマリモデルが過負荷状態、利用不可、またはその他の再試行不可能なサーバーエラーを返した場合、Claude Code はリクエストを失敗させる代わりにフォールバックモデルに切り替えることができます。認証、請求、レート制限、リクエストサイズ、トランスポートのエラー、および[組織のポリシーチェックによる拒否](/docs/ja/errors#automatic-retries)では切り替えは発生せず、通常の再試行とエラー処理に従います。[Amazon Bedrock](/docs/ja/amazon-bedrock#when-a-model-is-disabled-mid-session) または [Google Cloud's Agent Platform](/docs/ja/google-vertex-ai#when-a-model-is-disabled-mid-session) がアカウントで呼び出せないモデルを拒否した場合は切り替えが発生します。Claude Code はこれを認証エラーではなく、モデルが利用不可であるものとして扱います。

1 つ以上のフォールバックモデルを設定すると、Claude Code はそれらを順に試し、切り替え時に通知を表示します。切り替えは現在のターンにのみ有効なため、次のメッセージでは再びプライマリモデルが最初に試されます。Claude Code は重複を除いたうえでチェーンを 3 モデルまでに制限し、それを超えるエントリは無視します。

1 つのセッションにチェーンを設定するには、カンマ区切りのリストを受け付ける `--fallback-model` フラグを使用します。

```bash theme={null}
claude --fallback-model sonnet,haiku
```

セッションをまたいでチェーンを保持するには、[設定](/docs/ja/settings)で `fallbackModel` を配列として設定します。

```json theme={null}
{
  "fallbackModel": ["claude-sonnet-5", "claude-haiku-4-5"]
}
```

`--fallback-model` フラグは `fallbackModel` 設定より優先されます。各エントリにはモデル名またはエイリアスを指定でき、`"default"` はデフォルトモデルに展開されます。

Claude Code は起動時にチェーンを確認せず、`/status` にも表示されません。切り替えが発生したときに表示される通知が、フォールバックが設定されていることを示す最初の目に見えるサインです。

リクエストがフェイルオーバーすると、Claude Code はいずれかのエントリがリクエストを受け付けるまで、各エントリを順に試します。設定に固定された廃止済みモデルなど、到達できないエントリも同様に次のエントリへフェイルオーバーします。Claude Code は、この順次試行を始める前に 2 種類のエントリを除外します。

* **許可リスト外**：Claude Code はチェーンを読み込む際に、[`availableModels`](#restrict-model-selection) で許可されていないエントリを除外します。
* **コンテキスト圧縮中のより小さいコンテキストウィンドウ**：チェーンは[コンテキスト圧縮](/docs/ja/context-window#what-survives-compaction)にも適用されますが、Claude Code はプライマリモデルより小さいコンテキストウィンドウを持つモデルにはフォールバックしません。そこで要約すると、会話の一部が先に切り捨てられてしまうためです。すべてのフォールバックがより小さい場合、圧縮は元のエラーを表示し、再試行できます。

Claude Code はチェーンを[サブエージェント](/docs/ja/sub-agents)にも適用します。サブエージェントのリクエストがフェイルオーバーすると、Claude Code は設定されたフォールバックモデルを順に試し、サブエージェントはリクエストを受け付けたモデルで処理を続行します。セッションのモデルは変わりません。v2.1.247 より前は、チェーンの対象となる失敗が発生するとサブエージェントが終了していました。

<h3 id="automatic-model-fallback">
  自動モデルフォールバック
</h3>

このセクションでは、Fable モデル、Opus 5.5、Sonnet 5.5、Opus 5 からのコンテンツに基づくフォールバックについて説明します。モデルが過負荷状態または利用不可の場合の可用性に基づくフォールバックについては、[フォールバックモデルチェーン](#fallback-model-chains)を参照してください。

Fable モデル、Opus 5.5、Sonnet 5.5、Opus 5 は安全性分類器とともに動作し、分類器が最も頻繁に警告するのはサイバーセキュリティと生物学に関するコンテンツです。分類器がリクエストを警告し、警告されたカテゴリにフォールバックモデルがある場合、Claude Code はそのモデルでリクエストを再実行し、トランスクリプトに通知を表示します。この 2 つのカテゴリについて、フォールバックモデルは拒否したモデルによって異なります。

* **Fable 5.1、Fable 5、Opus 5.5**：生物学で警告されたリクエストは Opus 5 で、サイバーセキュリティで警告されたリクエストは Opus 4.8 で再実行されます。
* **Sonnet 5.5**：サイバーセキュリティで警告されたリクエストは Sonnet 5 で再実行されます。Sonnet 5.5 には生物学のフォールバックモデルがないため、生物学で警告されたリクエストは代わりに拒否で終了します。
* **Opus 5**：サイバーセキュリティで警告されたリクエストは Opus 4.8 で再実行されます。Opus 5 は独自の生物学分類器をフォールバックモデルなしで実行するため、生物学で警告されたリクエストは代わりに拒否で終了します。

Amazon Bedrock、Google Cloud's Agent Platform、Microsoft Foundry では、Claude Code はこれらのターゲットを代わりにデプロイのモデル ID を通じて解決します。[Bedrock、Agent Platform、Foundry でフォールバックを有効にする](#enable-fallback-on-bedrock-agent-platform-and-foundry)を参照してください。

フォールバック後、セッションはフォールバックモデルで続行されます。元のモデルに戻るには、[`/model`](#setting-your-model) を実行します。

カテゴリに基づくフォールバックには Claude Code v2.1.219 以降が必要です。v2.1.219 より前は、警告された Fable 5 のリクエストはすべてプロバイダーのデフォルトの Opus モデルで再実行され、Opus 5 はフォールバック元ではありませんでした。

フォールバックモデルは [`availableModels`](#restrict-model-selection) と照合されます。ブロックされている場合、フォールバックは発生しません。拒否は通常のエラーとして表示され、セッションのモデルは変わりません。

<h4 id="effort-level-after-a-fallback">
  フォールバック後の effort レベル
</h4>

Claude Code がセッションをフォールバックモデルに切り替える際は、そのモデルのデフォルトの effort ではなく、警告されたリクエストが実行されていた effort レベルを維持します。たとえば、デフォルトの `medium` で動作している Opus 5.5 のセッションが Opus 4.8 にフォールバックした場合、Opus 4.8 のデフォルトは `high` ですが、`medium` のままになります。

次のような場合は、別のレベルが適用されます。

* **設定または組織のデフォルト**：フォールバックモデルに適用される設定内のレベル、または組織がそのモデルに設定したデフォルトの effort が代わりに適用されます。
* **ユーザー自身による変更**：effort レベルを選択したり、`/model` でモデルを選んだり、後でセッションを再開したりすると、警告されたリクエストのレベルは引き継がれなくなります。
* **スキルの effort**：スキルの `effort` フロントマターが警告されたリクエストに設定したレベルはそのターンに適用され、以降のターンは [effort の解決順序](#adjust-effort-level)がフォールバックモデルに与えるレベルで実行されます。

セッションヘッダーには、有効なレベルがモデル名の横に表示されます。変更するには、セッション内で `/effort` を実行します。

<h4 id="check-what-triggered-fallback">
  フォールバックのきっかけを確認する
</h4>

フォールバックは、特殊な内容を何も送信する前に、セッションの最初のリクエストで発生することがあります。最初のリクエストには、CLAUDE.md の内容や git status などのワークスペースのコンテキストが含まれるためです。セキュリティや生物学に関する資料を含むリポジトリでは、そのコンテキストだけで分類器が反応することがあります。

カスタマイズがきっかけかどうかを確認するには、`claude --safe-mode` でセッションを開始します。これにより、CLAUDE.md、スキル、MCP サーバー、フックなどのカスタマイズが無効になります。git status やディレクトリ名はカスタマイズではないため、引き続き含まれます。

<h4 id="ask-before-switching">
  切り替える前に確認する
</h4>

自動的に切り替えるのではなく、リクエストが警告されるたびにどうするかを判断したい場合は、`/config` を実行して **Switch models when a message is flagged** をオフにするか、設定ファイルで [`switchModelsOnFlag`](/docs/ja/settings-reference#switchmodelsonflag) を `false` に設定します。すると、警告されたリクエストはセッションを一時停止し、フォールバックモデルに切り替えるか、プロンプトを編集して現在のモデルで再試行するかの 2 つの選択肢を表示します。

次の場合は動作が異なります。

* Opus 5 や Sonnet 5.5 での生物学の警告のように、警告されたカテゴリにフォールバックモデルがない場合、Claude Code は確認を表示せず、リクエストは拒否で終了します。
* 両方のモデルが同じリクエストを警告した場合は、プロンプトを編集して再試行するか、新しいセッションを開始できます。
* モバイルアプリ上の[クラウドセッション](/docs/ja/claude-code-on-the-web)では、編集して再試行することはできません。モデルを切り替えるか、デスクトップのブラウザまたはデスクトップアプリからセッションを続行してください。
* 確認を表示できない[非対話モード](/docs/ja/cli-reference#cli-flags)や SDK 統合では、警告されたリクエストは代わりに拒否でターンを終了します。
* フォールバック先が [`availableModels`](#restrict-model-selection) によってブロックされている場合、Claude Code は確認を表示しません。ターゲットがブロックされている場合の自動フォールバックと同様に、警告されたリクエストは拒否で終了します。

<h4 id="enable-fallback-on-bedrock-agent-platform-and-foundry">
  Bedrock、Agent Platform、Foundry でフォールバックを有効にする
</h4>

[Amazon Bedrock](/docs/ja/amazon-bedrock)、[Google Cloud's Agent Platform](/docs/ja/google-vertex-ai)、[Microsoft Foundry](/docs/ja/microsoft-foundry) では、モデル ID がプロバイダー固有であるため、自動フォールバックは Claude Code が関係する各モデルを識別できる場合にのみ動作します。

* Claude Code が現在のモデルをフォールバック元として認識する必要があります。Fable 5.1 と Fable 5 は、モデル ID に `claude-fable-5` が含まれる場合、`ANTHROPIC_DEFAULT_FABLE_MODEL` の値と一致する場合、または [`modelOverrides`](#override-model-ids-per-version) でマッピングされている場合に認識されます。Opus 5.5、Sonnet 5.5、Opus 5 は、プロバイダーのモデル ID または [`modelOverrides`](#override-model-ids-per-version) のマッピングによって認識されます。
* どのモデルが拒否したかにかかわらず、Opus のターゲットがデプロイで解決される必要があります。`ANTHROPIC_DEFAULT_OPUS_MODEL` を設定するか、プロバイダーのモデルリストに Opus 4.8 のエントリを残してください。どちらもない場合、Sonnet 5.5 を含むすべてのフォールバック元モデルでフォールバックはオフのままとなり、警告されたリクエストは拒否で終了します。
* 警告されたカテゴリのフォールバックモデルがデプロイで解決される必要があります。Fable モデル、Opus 5.5、Opus 5 からの場合、`ANTHROPIC_DEFAULT_OPUS_MODEL` を設定すると、フォールバックがあるすべてのカテゴリについて、警告されたリクエストはそのモデルで再実行されます。ただし、Opus 5 での生物学の警告は引き続き拒否で終了します。設定しない場合、サイバーセキュリティで警告されたリクエストは Opus 4.8 のエントリで再実行され、Fable モデルまたは Opus 5.5 からの生物学で警告されたリクエストは Opus 5 のエントリで再実行されます。Sonnet 5.5 からの場合、サイバーセキュリティで警告されたリクエストは `ANTHROPIC_DEFAULT_SONNET_MODEL` で設定したモデルで再実行されるか、設定しない場合はプロバイダーのモデルリストにある Sonnet 5 のエントリで再実行されます。

いずれかのモデルを識別できない場合、Claude Code は切り替えません。警告されたリクエストは拒否メッセージで終了し、[`/model`](#setting-your-model) でモデルを切り替えて再試行できます。両方のモデルを識別できるようにするには、フォールバック元モデルに応じて次の固定設定を行います。

* **Fable モデル**：Claude Code がフォールバック元として認識できるよう、`ANTHROPIC_DEFAULT_FABLE_MODEL` に Fable のモデル ID を設定します。
* **すべてのフォールバック元モデル**：フォールバックをオンにし、警告されたカテゴリにターゲットを与えるため、`ANTHROPIC_DEFAULT_OPUS_MODEL` に Opus のモデル ID を設定します。Opus ファミリー以外のモデルや、拒否したモデル自体を指定した場合は、拒否がそのまま残ります。
* **Sonnet 5.5**：Opus の固定設定に加えて、`ANTHROPIC_DEFAULT_SONNET_MODEL` を設定するか、プロバイダーのモデルリストに Sonnet 5 のエントリを残して、リクエストを再実行するモデルを用意します。Sonnet ファミリー以外のモデルや Sonnet 5.5 自体を指定した Sonnet の固定設定では、拒否がそのまま残ります。

<h4 id="security-research-and-biology-workloads">
  セキュリティ研究と生物学のワークロード
</h4>

ペネトレーションテスト、Capture the Flag（CTF）演習、生物学に関連するコードベースなど、攻撃的セキュリティや生物学のワークロードでは、フォールバックが頻繁に、多くの場合最初のリクエストで発生します。Fable 5.1、Fable 5、Opus 5.5 で本格的な生物学の作業を行う場合、Claude Code は最初に警告されたリクエストの時点でセッションを Opus 5 に移行し、Opus 5 には生物学のフォールバックがないため、その後の生物学で警告されたリクエストはそこで拒否となります。Opus 5 と Sonnet 5.5 では、最初に警告されたリクエストからその拒否が発生します。

これはこれらの分野における想定どおりのルーティングであり、アカウントに対する警告ではありません。組織がこの作業に Fable クラスの能力を必要とする場合は、Anthropic のアカウントチームに信頼済みアクセスプログラムについてお問い合わせください。

<h3 id="adjust-effort-level">
  effort レベルを調整する
</h3>

[effort レベル](https://platform.claude.com/docs/en/build-with-claude/effort)はアダプティブ推論を制御します。アダプティブ推論では、タスクの複雑さに基づいて、各ステップで思考するかどうか、どの程度思考するかをモデルが判断します。低い effort は単純なタスクに対してより高速かつ低コストで、高い effort は複雑な問題に対してより深い推論を提供します。

利用可能な effort レベルはモデルによって異なります。ここに記載されていないモデルは effort をサポートしていません。

| モデル | レベル |
| :- | :- |
| Fable 5.1 と Fable 5 | `low`、`medium`、`high`、`xhigh`、`max` |
| Opus 5.5、Sonnet 5.5、Opus 5、Sonnet 5、Opus 4.8、Opus 4.7 | `low`、`medium`、`high`、`xhigh`、`max` |
| Opus 4.6 と Sonnet 4.6 | `low`、`medium`、`high`、`max` |

アクティブなモデルがサポートしていないレベルを設定した場合、Claude Code は設定したレベル以下でサポートされている最も高いレベルにフォールバックします。たとえば、Opus 4.6 では `xhigh` は `high` として動作します。組織またはユーザー自身の設定によって、モデルが提供するレベルに上限を設けることもできます。[組織の effort 制限](#organization-effort-limits)を参照してください。

Claude Code は、次の順序でセッションの effort レベルを解決し、最初に該当したものを採用します。

1. 明示的な選択：[`CLAUDE_CODE_EFFORT_LEVEL`](/docs/ja/env-vars#variables) 環境変数、`--effort` を付けた起動、またはセッション内での `/effort`（[非対話の `/effort` は効果の範囲が狭くなります](#non-interactive-effort)）
2. 設定：モデルに対して保存したレベルまたは [`effortLevel`](/docs/ja/settings-reference#effortlevel) キー。これらの間および設定ファイル間の優先順位は [`modelSettings`](/docs/ja/settings-reference#modelsettings) に記載されています
3. モデルのデフォルトの effort：effort をサポートするすべてのモデルで `high`。ただし、Opus 5.5 と Sonnet 5.5 のデフォルトは `medium`、Opus 4.7 のデフォルトは `xhigh` です。また、組織が[組織のデフォルトモデル](#organization-default-model)にデフォルトの effort レベルを設定している場合、そのモデルを実行するときはそのレベルがデフォルトになります。自動モデルフォールバックの後に適用されるレベルについては、[フォールバック後の effort レベル](#effort-level-after-a-fallback)を参照してください

Opus 5.5 は、上記のいずれかのソースでレベルが設定されていない限り `medium` で開始され、ユーザー設定ファイルのトップレベルの `effortLevel` は Opus 5.5 には適用されません。このキーは、Claude Code がモデルごとにレベルを保存するようになる前に `/effort` が書き込んでいた古い形式です。Opus 5、Fable 5.1、およびそれ以前のモデルでは以前と同様に適用され続けますが、Opus 5.5 とそれ以降にリリースされたモデルは、`/effort` または `/model` ピッカーでレベルを選ぶまで、それぞれのデフォルトで開始されます。プロジェクト設定、ローカル設定、管理設定のトップレベルの `effortLevel`、または `--settings` で渡されたものは、すべてのモデルに適用されます。

自分のマシン上の対話セッションで `low`、`medium`、`high`、`xhigh` を設定する場合、確定の方法によって有効期間を選べます。

* `/effort` スライダーまたは `/model` ピッカーでの `Enter`、または `/effort` の後にレベルを入力：レベルをデフォルトとして保存し、以降のセッションにも適用します
* `/effort` スライダーまたは `/model` ピッカーでの `s`：このセッションにのみレベルを適用します。Claude Code v2.1.257 以降が必要です

Claude Code はユーザー設定の [`modelSettings`](/docs/ja/settings-reference#modelsettings) キーの下にモデルごとのレベルを保存するため、各モデルはそれぞれ独自の保存済みレベルを保持します。

`max` は最も深い推論レベルです。`CLAUDE_CODE_EFFORT_LEVEL` 環境変数で設定しない限り、Claude Code は `max` を現在のセッションにのみ適用します。

<Note>
  [Remote Control](/docs/ja/remote-control#what-connected-devices-see) で接続したスマートフォンやブラウザの effort コントロールから選んだレベルは、そのセッションにのみ適用されます。
</Note>

<span id="non-interactive-effort" />

[`-p` 実行](/docs/ja/headless)で `/effort` を使ってレベルを設定した場合、Claude Code はそのセッションにのみ適用し、デフォルトとしては保存しません。

`/effort` スライダーには **Ultracode** トグルもあります。Ultracode はモデルの effort レベルではなく Claude Code の設定です。オンにすると、Claude はセッションの effort レベルにかかわらず、本格的なタスクに対して[動的ワークフロー](/docs/ja/workflows)をオーケストレーションします。永続的に設定できる場所については、[`ultracode`](/docs/ja/settings-reference#ultracode) 設定を参照してください。

`/effort` または `ultracode` 設定で ultracode をオンまたはオフにしても、effort レベルは変わりません。`--effort ultracode` フラグと Agent SDK の `effortLevel: "ultracode"` 値は、ultracode をオンにすると同時にレベルを `xhigh` に設定します。`/effort` スライダーや `/model` ピッカーでレベルを選んでも、ultracode はそのままです。

ultracode は次のいずれかの方法でオンにできます。

* **`/effort`**：`/effort ultracode` を実行すると現在のセッションでオンになり、`/effort ultracode off` を実行するとオフになります。`/effort` スライダーでは、`Tab` を押して **Ultracode** トグルを切り替え、`Enter` で適用します
* **`--effort` フラグ**：`claude --effort ultracode` で起動すると、`xhigh` の effort で ultracode をオンにした状態でセッションが開始されます
* **`ultracode` 設定**：設定ファイル、`--settings`、または Agent SDK のコントロールリクエストで [`"ultracode": true`](/docs/ja/settings-reference#ultracode) を設定します。[`applyFlagSettings()`](/docs/ja/agent-sdk/typescript#applyflagsettings) リクエストは `effortLevel: "ultracode"` も受け付け、ultracode をオンにして effort レベルを `xhigh` に設定します

`/effort ultracode off` 形式、スライダーのトグル、`xhigh` 以外の effort レベルで ultracode をオンのまま維持することには、Claude Code v2.1.284 以降が必要です。v2.1.284 より前は、ultracode をオンにするとセッションが `xhigh` の effort に設定され、別のレベルを選ぶとオフになり、`xhigh` 未満の effort 上限があると利用できませんでした。

`--effort` フラグまたは Agent SDK の `effortLevel` 値に `ultracode` を渡すには、Claude Code v2.1.203 以降が必要です。v2.1.203 より前は、`--effort ultracode` は `Unknown --effort value 'ultracode'` を出力し、セッションはデフォルトの effort で開始されていました。

永続化される `effortLevel` 設定と `CLAUDE_CODE_EFFORT_LEVEL` 環境変数は `ultracode` を受け付けません。`CLAUDE_CODE_EFFORT_LEVEL` または [effort 上限](#organization-effort-limits)によってセッションのレベルが設定されている場合、ultracode はそのレベルでオンのままになります。

<span id="when-ultracode-is-available" />

次の場合、Ultracode は利用できません。

* [ワークフローがオフになっている](/docs/ja/workflows#turn-workflows-off)
* モデルが `xhigh` の effort をサポートしていない

これらの場合、`--effort ultracode` は ultracode をオフにした状態で、モデルと上限が許容する最も高い effort レベル（最大 `xhigh`）でセッションを開始します。

<h4 id="choose-an-effort-level">
  effort レベルを選ぶ
</h4>

各レベルは、トークン消費と能力のトレードオフです。デフォルトはほとんどのコーディングタスクに適しています。異なるバランスが必要な場合に調整してください。

| レベル | 使用する場面 |
| :- | :- |
| `low` | ブレインストーミング、最初の下書き、名前の変更のような小さな変更など、結果を 1 つずつ確認する素早いやり取り |
| `medium` | Opus 5.5 と Sonnet 5.5 のデフォルトで、新機能の実装など、範囲が明確な日常的なエンジニアリング作業に適しています。その他のモデルでは、ある程度の知能と引き換えにできるコスト重視の作業でトークン使用量を削減します |
| `high` | 既存のコードベースのバグ修正など、検証が重要な作業やエッジケースが発生しやすい作業。Opus 5.5、Sonnet 5.5、Opus 4.7 を除くすべてのモデルのデフォルト |
| `xhigh` | より多くのトークン消費でより深い推論。Opus 4.7 のデフォルト |
| `max` | セキュリティ脆弱性の発見など、ユーザーの関与なしに Claude に取り組ませたい難しい問題。`max` は収穫逓減を示すことがあり、考えすぎる傾向があるため、広く採用する前にテストしてください |
| `ultracode` | レベルではなく Claude Code の設定：任意の effort レベルで、本格的なタスクごとに[動的ワークフロー](/docs/ja/workflows)を計画します |

Opus 5.5 と Fable 5.1 でのテストでは、高いレベルの Claude は回答前により多くのエッジケースをテストし、作業のより多くの部分を検証しました。また、自らの判断でより多くの選択を行いました。低いレベルでは、Claude はより早く出発点を返しました。これは、結果を 1 つずつ確認して次のステップを方向付ける作業に適しています。同じタスクを各レベルで実行した例については、ブログの [Using Claude Code: Spending your effort](https://claude.dev/blog/spending-your-effort/) をお読みください。

effort のスケールはモデルごとに調整されているため、同じレベル名でもモデル間で同じ基礎値を表すわけではありません。

Opus 5.5 は[デフォルトで `medium`](#adjust-effort-level) であり、Opus 5 のデフォルトである `high` より 1 段階低くなっています。Anthropic のテストでは、`medium` の Opus 5.5 は、コーディングやナレッジワークの評価で `high` の Opus 5 と同等以上の結果を示しています。同じレベルでは、Opus 5.5 は Opus 5 よりもターンあたりの思考量が多くなる傾向があります。Opus 5 から Opus 5.5 に移行する際は、Opus 5 で使用していたレベルを引き継ぐのではなく、`medium` から始めてください。自分の作業に対してレベルをテストするには、Opus 5.5 のプロンプティングガイドの [Calibrate effort](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/prompting-claude-opus-5-5#calibrate-effort) を参照してください。

<h4 id="use-ultrathink-for-one-off-deep-reasoning">
  一度限りの深い推論に ultrathink を使う
</h4>

プロンプトのどこかに `ultrathink` を含めると、セッションの effort 設定を変更せずに、そのターンでより深い推論を要求できます。Claude Code はこのキーワードを認識し、コンテキスト内に指示を追加します。API に送信される effort レベルは変わりません。「think」、「think hard」、「think more」などのその他の表現は、Claude Code が通常のプロンプトテキストとしてそのまま渡し、キーワードとしては認識しません。

<h4 id="set-the-effort-level">
  effort レベルを設定する
</h4>

effort は次のいずれかの方法で変更できます。

* **`/effort`**：引数なしで `/effort` を実行するとインタラクティブなスライダーが開き、`/effort` の後にレベル名を続けると直接設定でき、`/effort auto` を実行するとアクティブなモデルの保存済みレベルがクリアされます。Claude が作業中でも実行でき、Claude Code が[キャッシュの警告](/docs/ja/prompt-caching#changing-effort-level)を表示した場合はそれを確認すると、Claude Code はターン内の次のリクエストに新しいレベルを適用します
* **`/model` 内**：モデルを選択する際に、左右の矢印キーで effort スライダーを調整します
* **`--effort` フラグ**：Claude Code の起動時にレベル名を渡して、1 つのセッションに設定します
* **環境変数**：`CLAUDE_CODE_EFFORT_LEVEL` にレベル名または `auto` を設定します
* **設定**：[`modelSettings`](/docs/ja/settings-reference#modelsettings) でモデルごとのレベルを設定するか、レベルが設定されていないモデルのデフォルトとして [`effortLevel`](/docs/ja/settings-reference#effortlevel) に `low`、`medium`、`high`、`xhigh` のいずれかを設定します。どちらのキーでも `max` はレベルとして受け付けられず、`ultracode` には専用の [`ultracode`](/docs/ja/settings-reference#ultracode) キーがあります
* **接続されたデバイスから**：[Remote Control](/docs/ja/remote-control#what-connected-devices-see) セッションで、スマートフォンまたはブラウザの effort コントロールからレベルを選びます。レベルは現在のセッションにのみ適用されます。Claude Code v2.1.234 以降が必要です
* **スキルとサブエージェントのフロントマター**：[スキル](/docs/ja/skills#frontmatter-reference)または[サブエージェント](/docs/ja/sub-agents#supported-frontmatter-fields)の markdown ファイルで `effort` を設定すると、そのスキルまたはサブエージェントの実行時に effort レベルを上書きします

フロントマターの effort は、そのスキルまたはサブエージェントがアクティブなときに適用され、セッションのレベルは上書きしますが、環境変数は上書きしません。[`maxEffortLevel`](/docs/ja/settings-reference#maxeffortlevel) または[組織の effort 上限](#organization-effort-limits)は、スキルやサブエージェントが実行されるレベルを引き続き制限します。

[管理設定](/docs/ja/managed-settings)で `effortLevel` を設定した場合、Claude Code は[effort の解決順序](#adjust-effort-level)の設定のステップでそれを適用し、ユーザーは引き続き `/effort` や `--effort` でレベルを変更できます。ユーザーを特定のレベル以下に制限するには、[`maxEffortLevel`](/docs/ja/settings-reference#maxeffortlevel) を設定します。

サポートされているモデルが選択されている場合、effort スライダーは `/model` に表示されます。現在の effort レベルはセッションヘッダーのモデル名の横にも「with low effort」のように表示されるため、`/model` を開かずにどの設定が有効かを確認できます。フッターにも、起動時と変更時に effort レベルが短時間表示されます。

<h4 id="adaptive-reasoning-and-fixed-thinking-budgets">
  アダプティブ推論と固定の思考予算
</h4>

アダプティブ推論では、各ステップで思考が任意になるため、Claude は日常的なプロンプトにはより速く応答し、より深い思考はそれが役立つステップのために取っておけます。現在のレベルよりも思考の頻度を増やしたり減らしたりしたい場合は、プロンプトまたは `CLAUDE.md` で直接そう伝えることができます。モデルは effort 設定の範囲内でその指示に応えます。

Fable モデル、Sonnet 5 以降、Opus 4.7 以降は常にアダプティブ推論を使用します。固定の思考予算モードと `CLAUDE_CODE_DISABLE_ADAPTIVE_THINKING` はこれらのモデルには適用されません。

Opus 4.6 と Sonnet 4.6 では、`CLAUDE_CODE_DISABLE_ADAPTIVE_THINKING=1` を設定すると、`MAX_THINKING_TOKENS` で制御される以前の固定の思考予算に戻せます。[環境変数](/docs/ja/env-vars)を参照してください。

<h3 id="extended-thinking">
  拡張思考
</h3>

拡張思考は、Claude が応答する前に出力する推論です。[アダプティブ推論](#adjust-effort-level)をサポートするモデルでは、effort レベルが思考量の主な制御手段です。以下の設定は、思考のオン/オフと表示方法を制御します。Anthropic API で思考をオフにしている場合、Opus 5 など[その組み合わせを受け付けない](/docs/ja/errors#effort-isnt-available-with-thinking-turned-off)ことを Claude Code が把握しているモデルには、より高いレベルではなく effort `high` を送信します。

| 制御 | 設定方法 |
| :- | :- |
| 現在のセッションで切り替える | macOS では `Option+T`、Windows と Linux では `Alt+T` を押します |
| グローバルのデフォルトを設定する | `/config` を実行して思考モードを切り替えます。`~/.claude/settings.json` に `alwaysThinkingEnabled` として保存されます |
| 環境変数で無効にする | [`MAX_THINKING_TOKENS=0`](/docs/ja/env-vars) を設定します。これにより、Opus 5.5、Sonnet 5.5、Fable モデルを除き、Anthropic API で思考がオフになります。[サードパーティプロバイダー](/docs/ja/third-party-integrations)では、Claude Code は代わりに `thinking` パラメータを省略するため、アダプティブ推論モデルは引き続き思考する場合があります。その他の値は[固定の思考予算](#adaptive-reasoning-and-fixed-thinking-budgets)の場合にのみ適用されます |

Opus 5.5、Sonnet 5.5、Fable モデルでは思考をオフにできません。これらのモデルでは、セッションのトグルと `/config` の行に切り替えの代わりに `Thinking can't be turned off` が表示され、保存済みの `alwaysThinkingEnabled: false` や `MAX_THINKING_TOKENS=0` は効果がありません。これらのモデルでは、effort レベルに基づいて、モデルがステップごとにどの程度思考するかを判断します。保存済みの設定は、それを受け付けるモデルに切り替えると再び適用されます。

Claude Code はデフォルトで思考の出力を折りたたみます。`Ctrl+O` を押して詳細モードを切り替えると、推論がグレーの斜体テキストで表示されます。Anthropic API 上の対話セッションはデフォルトで編集済みの思考ブロックを受け取るため、展開時に完全な要約を表示したい場合は、[設定](/docs/ja/settings)で `showThinkingSummaries: true` を設定してください。折りたたまれていても編集済みであっても、生成されたすべての思考トークンに対して課金されます。

<a id="extended-context-with-1m" />

<h3 id="extended-context">
  拡張コンテキスト
</h3>

Fable 5.1、Fable 5、Sonnet 5 以降、Opus 4.6 以降、Sonnet 4.6 は、大規模なコードベースでの長いセッション向けに [100 万トークンのコンテキストウィンドウ](https://platform.claude.com/docs/en/build-with-claude/context-windows#context-window-sizes-by-model)をサポートしています。

Anthropic API では、Fable 5.1、Fable 5、Sonnet 5 以降、Opus 4.7 以降は、Pro を含むすべてのプランで 1M ウィンドウで動作します。これらのモデルでは、1M ウィンドウのために `[1m]` バリアントを選択したり、使用クレジットをオンにしたりする必要はありません。Fable の利用自体は、一部のプランでは使用クレジットに請求される場合があります。[Fable と使用クレジット](#fable-and-usage-credits)を参照してください。

Opus 4.6 と Sonnet 4.6 が 1M に到達するのは `[1m]` バリアントを通じてのみで、そのバリアントへのアクセスはプランによって異なります。Team Standard と Team Premium の両方のシートを含む Max、Team、Enterprise プランでは、1M コンテキストの Opus 4.6 はサブスクリプションに含まれています。1M コンテキストの Sonnet 4.6 は、Max を含むすべてのサブスクリプションプランで[使用クレジット](https://support.claude.com/en/articles/12429409-extra-usage-for-paid-claude-plans)が必要です。

| プラン | 1M コンテキストの Opus 4.6 | 1M コンテキストの Sonnet 4.6 |
| - | - | - |
| Max、Team、Enterprise | サブスクリプションに含まれる | [使用クレジット](https://support.claude.com/en/articles/12429409-extra-usage-for-paid-claude-plans)が必要 |
| Pro | [使用クレジット](https://support.claude.com/en/articles/12429409-extra-usage-for-paid-claude-plans)が必要 | [使用クレジット](https://support.claude.com/en/articles/12429409-extra-usage-for-paid-claude-plans)が必要 |
| API と従量課金 | フルアクセス | フルアクセス |

Claude Code がこれらのプラン要件を確認するのは、Anthropic API に直接接続する場合のみです。`ANTHROPIC_BASE_URL` を [LLM ゲートウェイ](/docs/ja/llm-gateway#subscriptions-and-gateways)に向け、保存済みの claude.ai ログインがアクティブな認証情報のままである場合、Claude Code はプランの使用クレジットを確認しません。`[1m]` オプションは `/model` で引き続き利用でき、リクエストが成功するかどうかはゲートウェイが判断します。v2.1.229 より前は、この構成でアカウントの使用クレジットを確認できない場合、Claude Code は `/model sonnet[1m]` を拒否していました。

<span id="context-window-behind-a-gateway" />

`ANTHROPIC_BASE_URL` を [LLM ゲートウェイ](/docs/ja/llm-gateway)やその他のプロキシに設定した場合、Claude Code は認識する各モデルに、Anthropic API 上と同じコンテキストウィンドウを割り当てます。Fable 5.1、Fable 5、Sonnet 5 以降、Opus 4.7 以降は、`[1m]` バリアントを選択しなくても 1M ウィンドウを使用でき、Opus 4.6 のように `[1m]` バリアントを通じてのみ 1M に到達するモデルは、バリアントなしでは 200K で動作します。Claude Code は、ゲートウェイやその背後のサーバーが強制するより低い制限を検出できません。ゲートウェイが 200K トークンを超えるリクエストを拒否する場合は、Claude Code を起動する環境で [`CLAUDE_CODE_AUTO_COMPACT_WINDOW=200000`](/docs/ja/env-vars) を設定して、すべてのモデルのセッションが[その境界で圧縮される](#set-the-auto-compact-window)ようにしてください。

1M コンテキストをオフにするには、`CLAUDE_CODE_DISABLE_1M_CONTEXT=1` を設定します。Claude Code はモデルピッカーから 1M のモデルバリアントを削除します。Sonnet 5 や Fable モデルなど、ネイティブで 1M ウィンドウを持つモデルでは、そのモデルのコンテキストウィンドウを 200K として扱います。

* 自動圧縮がオンの場合、セッションは[自動圧縮](#set-the-auto-compact-window)によって 200K の境界で圧縮されます。Claude Code は自動圧縮のウィンドウをモデルのコンテキストウィンドウに制限するため、自動圧縮のウィンドウを 200K より大きく設定しても制限は解除されません。
* 自動圧縮がオフの場合、セッションは圧縮されず、200K の境界で[コンテキスト制限エラー](/docs/ja/errors#prompt-is-too-long)により停止します。

v2.1.223 より前は、Claude Code が 200K に制限していたのは Sonnet 5、Opus 4.8、Opus 5 のセッションのみでした。[環境変数](/docs/ja/env-vars)を参照してください。

1M コンテキストウィンドウは標準のモデル料金を使用し、200K を超えるトークンに対する割増料金はありません。拡張コンテキストがサブスクリプションに含まれるプランでは、使用量は引き続きサブスクリプションでカバーされます。使用クレジットを通じて拡張コンテキストにアクセスするプランでは、トークンは使用クレジットに請求されます。

アカウントが 1M コンテキストをサポートしている場合、最新バージョンの Claude Code では `/model` ピッカーにそのオプションが表示されます。表示されない場合は、セッションを再起動してください。サードパーティプロバイダーでは、デプロイが `ANTHROPIC_DEFAULT_*_MODEL` 変数で[モデルを固定](#pin-models-for-third-party-deployments)していないか確認してください。

`[1m]` サフィックスは、モデルエイリアスや完全なモデル名とともに使用することもできます。

```text theme={null}
# Use the opus[1m] or sonnet[1m] alias
/model opus[1m]
/model sonnet[1m]

# Or append [1m] to a full model name
/model claude-opus-4-8[1m]
```

<h4 id="sonnet-5-5-and-sonnet-5-context-window">
  Sonnet 5.5 と Sonnet 5 のコンテキストウィンドウ
</h4>

Anthropic API では、Sonnet 5.5 と Sonnet 5 は常に 1M コンテキストウィンドウで動作します。200K バリアントはなく、選択する `[1m]` サフィックスもなく、どのプランでも使用クレジットは不要です。セッションはウィンドウが埋まる前に、デフォルトで約 967K トークンで自動圧縮されます。別のしきい値を選ぶには、[`CLAUDE_CODE_AUTO_COMPACT_WINDOW`](/docs/ja/env-vars) を設定してください。

Claude Code は、[LLM ゲートウェイ](/docs/ja/llm-gateway)やその他のカスタム `ANTHROPIC_BASE_URL` の背後でも、Sonnet 5.5 と Sonnet 5 に同じ 1M ウィンドウを割り当てます。ゲートウェイがより低い制限を強制する場合は、[ゲートウェイの背後でのコンテキストウィンドウ](#context-window-behind-a-gateway)を参照してください。

次の設定では、代わりにウィンドウを 200K に制限します。

* **`CLAUDE_CODE_DISABLE_1M_CONTEXT=1`**：ネイティブで 1M ウィンドウを持つすべてのモデルのセッションを 200K ウィンドウに制限します。制限がどのように適用されるかについては[拡張コンテキスト](#extended-context)を参照してください。コンテキストに上限を設ける必要があるデプロイに役立ちます。

<h2 id="context-window-and-auto-compaction">
  コンテキストウィンドウと自動圧縮
</h2>

自動圧縮ウィンドウとは、Claude Code が会話を圧縮する前にコンテキストウィンドウがどこまで埋まってよいかを示すものです。各メカニズムでコンテキスト圧縮が何を保持し何を破棄するかについては、[コンテキスト圧縮後に残るもの](/docs/ja/context-window#what-survives-compaction)を参照してください。

<h3 id="set-the-auto-compact-window">
  自動圧縮ウィンドウを設定する
</h3>

自動圧縮ウィンドウは次の場所で設定できます。

* **現在のモデルについて、現在のセッションとそれ以降のセッション**：`/autocompact 500k` のように、値を指定して `/autocompact` を実行します。Claude Code はこの値をユーザー設定の [`modelSettings`](/docs/ja/settings-reference#modelsettings) に現在のモデル用として保存し、現在のセッションに適用します。管理設定など、より優先順位の高い[設定スコープ](/docs/ja/settings#settings-precedence)がそのモデルまたはすべてのモデルに対して独自のウィンドウを設定している場合、コマンドは値を保存しますが、セッションではそのスコープのウィンドウが維持され、コマンドはその旨を表示します。使用中のモデル向けに調整されたウィンドウに戻すには、`/autocompact auto` を実行します。v2.1.288 より前は、このコマンドはすべてのモデルに共通の 1 つのウィンドウを、トップレベルの `autoCompactWindow` として保存していました。
* **すべてのモデル**：設定ファイルで [`autoCompactWindow`](/docs/ja/settings-reference#autocompactwindow) を設定します（例：`~/.claude/settings.json` に `"autoCompactWindow": 200000` を記述）。`/autocompact` でモデルごとに保存したウィンドウは、そのモデルについては同じファイル内のこのキーよりも優先されます。
* **1 回の起動のみ**：Claude Code の起動時に [`--autocompact`](/docs/ja/cli-reference#cli-flags) を渡します。このフラグは、保存済みの設定を変更することなく、その起動に限って設定を上書きします。また、`claude --autocompact auto` を実行すると、保存済みの設定に値があっても、調整済みのウィンドウでセッションが実行されます。`/autocompact` とは異なり、このフラグは管理設定など、より優先順位の高い設定スコープによって無効化されることはありません。
* **スクリプトおよびクラウド環境**：[`CLAUDE_CODE_AUTO_COMPACT_WINDOW`](/docs/ja/env-vars) を設定します。この環境変数が設定されている間は、コマンド、フラグ、設定よりも優先され、`/autocompact` はウィンドウを変更する代わりに上書きされていることを報告します。

コマンドとフラグには、100K から 1M トークンまでのウィンドウサイズを次のいずれかの形式で指定できます。

* `200000` のような単純なトークン数
* `500k` や `1M` のような `k` または `M` の接尾辞付きの値
* 100 から 1000 までの数値のみ（千単位を意味し、`200` は 200,000 に設定されます）

環境変数には単純なトークン数のみを指定できます。Claude Code は、ウィンドウの上限をモデルのコンテキストウィンドウに制限します。

<h3 id="default-auto-compact-thresholds">
  デフォルトの自動圧縮のしきい値
</h3>

自動圧縮ウィンドウを設定していない場合、Claude Code は会話がモデルのコンテキスト上限に達した時点で圧縮します。ただし、次のセッションは例外です。

* [クラウドセッション](/docs/ja/claude-code-on-the-web)は、会話がモデルの上限に近づいた時点で圧縮します
* [拡張コンテキスト](#extended-context)を使用しない Sonnet 4.6 と Opus 4.6 は 200K の境界で圧縮します。Amazon Bedrock、Google Cloud の Agent Platform、Microsoft Foundry など、200K のコンテキストウィンドウで実行される Opus 4.8 以降も同様です
* [`CLAUDE_CODE_DISABLE_1M_CONTEXT=1`](/docs/ja/env-vars) を設定すると、Sonnet 5 や Fable モデルなど、ネイティブで 1M のウィンドウを持つモデルは 200K の境界で圧縮します
* ネイティブの 1M ウィンドウで実行されるモデルは、ウィンドウが埋まる前に、デフォルトで約 967K トークンの時点で圧縮します。Anthropic API では、Sonnet 5、Fable モデル、Opus 4.7 以降がこれに該当します。Amazon Bedrock、Google Cloud の Agent Platform、Microsoft Foundry でどのモデルがこのウィンドウで実行されるかについては、[サードパーティのデプロイでモデルを固定する](#pin-models-for-third-party-deployments)を参照してください。カスタムの `ANTHROPIC_BASE_URL` を使用している場合は、[ゲートウェイ経由のコンテキストウィンドウ](#context-window-behind-a-gateway)を参照してください
* [LLM ゲートウェイ](/docs/ja/llm-gateway)のエイリアスなど、Claude Code が認識できないモデル ID を使用するセッションは、Claude Code がその ID に対して想定するコンテキストウィンドウで圧縮します。[ゲートウェイまたはカスタムモデル ID のウィンドウを修正する](#correct-the-window-for-a-gateway-or-custom-model-id)を参照してください

<h3 id="correct-the-window-for-a-gateway-or-custom-model-id">
  ゲートウェイまたはカスタムモデル ID のウィンドウを修正する
</h3>

[LLM ゲートウェイ](/docs/ja/llm-gateway)やその他のカスタムデプロイでは、Claude Code がその ID を Claude モデルに解決するかどうかにかかわらず、モデル ID に対してモデルの実際のウィンドウとは異なるコンテキストウィンドウを想定することがあります。Claude Code が代わりに想定すべきウィンドウを [`CLAUDE_CODE_MAX_CONTEXT_TOKENS`](/docs/ja/env-vars) に設定してください。

この変数の適用方法は ID によって異なります。Claude Code は、ID が（大文字小文字を問わず）`claude-` で始まらない場合、または Google Cloud の Agent Platform で使用される `@YYYYMMDD` の日付のように、ID の読み取り時に Claude Code が取り除く接尾辞が付いている場合に、その ID をプロバイダー固有またはカスタムの表記として扱います。v2.1.259 より前の Claude Code は取り除かれた接尾辞を考慮しなかったため、日付の接尾辞が付いた認識できない `claude-` ID は、接尾辞のない `claude-` 名として扱われていました。

認識できないプロバイダー固有またはカスタムの表記、`[1m]` が付いた同じ表記、およびそれ以外のすべての ID は、次の 3 つの異なるケースとして扱われます。

* Claude Code がプロバイダー固有またはカスタムの表記を認識できるモデルに解決できず、ID に `[1m]` が含まれていない場合、この変数は直接適用され、宣言されたウィンドウでプロアクティブなコンテキスト圧縮が継続されます。
* Claude Code がプロバイダー固有またはカスタムの表記を認識できるモデルに解決できず、ID に（大文字小文字を問わず）`[1m]` が含まれている場合、Claude Code はその ID に 1M のウィンドウを想定し、この変数は単独では適用されません。プロアクティブなコンテキスト圧縮を維持しながらウィンドウを修正するには、[`CLAUDE_CODE_DISABLE_1M_CONTEXT=1`](/docs/ja/env-vars) も設定してください。この変数を設定すると、Claude Code はその ID を `[1m]` のない同じ表記と同様にサイズ設定するため、`CLAUDE_CODE_MAX_CONTEXT_TOKENS` は、タグのない表記に適用される場合と同じ条件で適用されます。

  宣言されたウィンドウが 200K を超える場合、Claude Code は 200K の上限が適用されないことを示す[起動時の警告](/docs/ja/errors#the-200k-limit-isnt-enforced)を表示します。この構成では、この警告は想定どおりの動作です。
* ID が Claude Code の認識するモデルに解決される場合、または ID が（大文字小文字を問わず）Claude Code が取り除く接尾辞のない `claude-` 名のみの場合、この変数は [`DISABLE_COMPACT`](/docs/ja/env-vars) も設定したときにのみ有効になります。`DISABLE_COMPACT` はすべてのコンテキスト圧縮を無効にします。

  たとえば、`anthropic/claude-opus-4-8`、`us.anthropic.claude-…-v1:0`、日付付きの `claude-sonnet-4-5@20250929` など、Claude Code が認識している Claude モデル名を含む ID は、そのモデルに解決されます。これには `[1m]` も含む ID も含まれます。`CLAUDE_CODE_DISABLE_1M_CONTEXT` が設定されている場合でも、Claude Code は `claude-opus-4-8[1m]` を Opus 4.8 に解決します。

Claude Code が認識できないモデル ID の場合、[`CLAUDE_CODE_DISABLE_UNKNOWN_MODEL_WINDOW_ENFORCEMENT=1`](/docs/ja/env-vars) を設定すると、API が [Claude Code の認識する長すぎるエラー](/docs/ja/errors#prompt-is-too-long)で会話を拒否した後にのみ、Claude Code が圧縮するようになります。ゲートウェイがエラーを Claude Code の認識できない文言に[書き換える](/docs/ja/llm-gateway-connect#troubleshoot-gateway-errors)場合、Claude Code はこの復旧処理を実行しません。

<h2 id="checking-your-current-model">
  現在のモデルの確認
</h2>

現在使用しているモデルは、2 つの場所で確認できます。

* [ステータスライン](/docs/ja/statusline)内（設定されている場合）
* `/status` 内。アカウント情報も表示されます。

<h2 id="add-a-custom-model-option">
  カスタムモデルオプションを追加する
</h2>

`ANTHROPIC_CUSTOM_MODEL_OPTION` を使用すると、組み込みのエイリアスを置き換えることなく、`/model` ピッカーにカスタムエントリを 1 つ追加できます。これは、Claude Code がデフォルトで一覧表示しないモデル ID をテストする場合に便利です。LLM ゲートウェイのデプロイでは、`CLAUDE_CODE_ENABLE_GATEWAY_MODEL_DISCOVERY=1` が設定されていると、Claude Code はゲートウェイの `/v1/models` エンドポイントからピッカーに項目を取り込めます。そのため、この環境変数が必要になるのは、検出が無効になっている場合、または検出で目的のモデルが返されない場合のみです。[ゲートウェイのモデル検出](/docs/ja/llm-gateway-protocol#model-discovery)を参照してください。

代わりに複数のモデルを、独自の順序で、選択したラベルを付けて一覧表示するには、[`modelPicker`](/docs/ja/settings-reference#modelpicker) を設定します。その項目では、このラインナップが組み込みのラインナップを置き換える際に、ピッカーがどの行を保持するかを説明しています。

この例では、3 つの環境変数すべてを設定して、ゲートウェイ経由でルーティングされる Opus のデプロイを選択可能にします。Claude Code は起動時に環境変数を読み込むため、`claude` を起動する前に export を実行するか、既存のセッションを再起動して変数を反映させてください。

```bash theme={null}
export ANTHROPIC_CUSTOM_MODEL_OPTION="my-gateway/claude-opus-5-5"
export ANTHROPIC_CUSTOM_MODEL_OPTION_NAME="Opus via Gateway"
export ANTHROPIC_CUSTOM_MODEL_OPTION_DESCRIPTION="Custom deployment routed through the internal LLM gateway"
```

`ANTHROPIC_CUSTOM_MODEL_OPTION_NAME` と `ANTHROPIC_CUSTOM_MODEL_OPTION_DESCRIPTION` は省略可能です。

* 名前を省略した場合、Claude Code が [ID を認識する](#customize-pinned-model-display-and-capabilities)ときはエントリにモデルの名前が表示され、それ以外の場合はモデル ID が表示されます。
* 説明を省略した場合、Claude Code は `Custom model (<model-id>)` を使用します。

Claude Code はカスタムエントリを組み込みエントリの後に表示し、追加した [`modelPicker`](/docs/ja/settings-reference#modelpicker) の行はその後に表示されます。

Claude Code は `ANTHROPIC_CUSTOM_MODEL_OPTION` に設定されたモデル ID の検証をスキップするため、API エンドポイントが受け付ける任意の文字列を使用できます。

[`availableModels`](#restrict-model-selection) が設定されている場合は、カスタムモデル ID も許可リストに含めてください。含めない場合、Claude Code はカスタムエントリをピッカーから除外し、`--model` でそれを選択しても、除外された他のモデルと同様に拒否します。

`my-gateway/claude-opus-5-5` のようにファミリー名を含むカスタム ID は、そのファミリーの特定のエントリとして扱われ、そのファミリーのワイルドカードが無効になります。そのため、選択可能なままにしたいバージョンも併せて一覧に含めてください。[マージの動作](#merge-behavior)を参照してください。

<h2 id="environment-variables">
  環境変数
</h2>

エイリアスがマッピングされるモデル名を制御するには、次の環境変数を使用します。各値は完全なモデル名、または API プロバイダーにおける同等の識別子である必要があります。セッション開始時のモデルを選択するには、この表には記載されていない [`ANTHROPIC_DEFAULT_MODEL`](#set-a-default-model-for-new-sessions) を設定します。

| 環境変数 | 説明 |
| - | - |
| `ANTHROPIC_DEFAULT_FABLE_MODEL` | `fable` に使用するモデル。また、サードパーティプロバイダーでの[自動モデルフォールバック](#automatic-model-fallback)において Claude Code が Fable モデルとして認識するモデル ID |
| `ANTHROPIC_DEFAULT_OPUS_MODEL` | `opus` に使用するモデル、または Plan Mode がアクティブな場合の `opusplan` に使用するモデル。 |
| `ANTHROPIC_DEFAULT_SONNET_MODEL` | `sonnet` に使用するモデル、または Plan Mode がアクティブでない場合の `opusplan` に使用するモデル。 |
| `ANTHROPIC_DEFAULT_HAIKU_MODEL` | `haiku` または[バックグラウンド機能](/docs/ja/costs#background-token-usage)に使用するモデル |
| `CLAUDE_CODE_SUBAGENT_MODEL` | 他の方法でモデルが割り当てられていない[サブエージェント](/docs/ja/sub-agents#choose-a-model)、[エージェントチーム](/docs/ja/agent-teams#specify-teammates-and-models)のチームメイト、[ワークフロー](/docs/ja/workflows)エージェントのデフォルトモデル。`haiku` などのエイリアスまたは完全なモデル名を指定できます。呼び出しごとのモデル指定や、定義の `model` フィールド（`inherit` を含む）が優先されます。これを変更するには、[`CLAUDE_CODE_SUBAGENT_MODEL_FORCE`](/docs/ja/sub-agents#run-every-subagent-on-one-model) を設定します |

サードパーティプロバイダーにおいて、固定したモデルの行が `/model` ピッカーにどのように表示されるかについては、[固定モデルの表示と機能のカスタマイズ](#customize-pinned-model-display-and-capabilities)を参照してください。

注: `ANTHROPIC_SMALL_FAST_MODEL` は非推奨となり、
`ANTHROPIC_DEFAULT_HAIKU_MODEL` に置き換えられました。

<h3 id="pin-models-for-third-party-deployments">
  サードパーティデプロイ向けのモデルの固定
</h3>

[Amazon Bedrock](/docs/ja/amazon-bedrock)、[Google Cloud's Agent Platform](/docs/ja/google-vertex-ai)、[Microsoft Foundry](/docs/ja/microsoft-foundry)、または [Claude Platform on AWS](/docs/ja/claude-platform-on-aws) を通じて Claude Code をデプロイする場合は、ユーザーに配布する前にモデルバージョンを固定してください。

固定しない場合、Claude Code は `fable`、`opus`、`sonnet`、`haiku` などのモデルエイリアスを使用し、これらは各プロバイダーの組み込みのデフォルトモデル ID に解決されます。このデフォルトは最新の Anthropic リリースより遅れている場合があり、参照先のモデルがユーザーのアカウントでまだ有効になっていないこともあります。デフォルトが利用できない場合、Amazon Bedrock と Google Cloud's Agent Platform のユーザーには通知が表示され、セッションはデフォルトモデルの以前のバージョンにフォールバックします。デフォルトが Opus モデルで利用可能な Opus バージョンがない場合は、デフォルトの Sonnet モデルにフォールバックします。Microsoft Foundry には同等の起動時チェックがないため、Microsoft Foundry のユーザーには代わりにエラーが表示されます。

Amazon Bedrock と Google Cloud's Agent Platform では、ユーザーが `--model`、`ANTHROPIC_MODEL`、または `model` 設定などで特定の Sonnet または Opus バージョンでセッションを開始すると、そのバージョンが対応するエイリアスのセッションのデフォルトとして固定されます。起動時チェックは置き換えられた組み込みのデフォルトをスキップし、フォールバック通知は表示されません。v2.1.211 より前は、セッションモデルが明示的に設定されていてもチェックが実行され、通知が表示されることがありました。

<Warning>
  初期セットアップの一環として、モデルの環境変数を特定のバージョン ID に設定してください。固定することで、ユーザーが新しいモデルに移行するタイミングを制御できます。
</Warning>

プロバイダーに応じたバージョン固有のモデル ID を指定して、次の環境変数を使用します。

| プロバイダー | 例 |
| :- | :- |
| Amazon Bedrock | `export ANTHROPIC_DEFAULT_OPUS_MODEL='us.anthropic.claude-opus-4-8'` |
| Google Cloud's Agent Platform | `export ANTHROPIC_DEFAULT_OPUS_MODEL='claude-opus-4-8'` |
| Microsoft Foundry | `export ANTHROPIC_DEFAULT_OPUS_MODEL='claude-opus-4-8'` |

`ANTHROPIC_DEFAULT_FABLE_MODEL`、`ANTHROPIC_DEFAULT_SONNET_MODEL`、`ANTHROPIC_DEFAULT_HAIKU_MODEL` にも同じパターンを適用します。すべてのプロバイダーにおける現行およびレガシーのモデル ID については、[モデルの概要](https://platform.claude.com/docs/en/about-claude/models/overview)を参照してください。ユーザーを新しいモデルバージョンにアップグレードするには、これらの環境変数を更新して再デプロイします。

固定したモデルで[拡張コンテキスト](#extended-context)を有効にするには、`ANTHROPIC_DEFAULT_OPUS_MODEL`、`ANTHROPIC_DEFAULT_SONNET_MODEL`、または `ANTHROPIC_DEFAULT_FABLE_MODEL` のモデル ID に `[1m]` を付加します。

```bash theme={null}
export ANTHROPIC_DEFAULT_OPUS_MODEL='claude-opus-4-8[1m]'
```

`[1m]` サフィックスを付けると、1M コンテキストウィンドウは固定したエイリアスのすべての使用に適用されます。これには [`opusplan`](#opusplan-model-setting) の plan モードにおける Opus フェーズや、`model` フロントマターでそのエイリアスを指定している[サブエージェント](/docs/ja/sub-agents#choose-a-model)も含まれます。

* Claude Code はモデル ID をプロバイダーに送信する前にサフィックスを取り除きます。
* `[1m]` は、基盤となるモデルが [1M コンテキストをサポートしている](https://platform.claude.com/docs/en/build-with-claude/context-windows#context-window-sizes-by-model)場合にのみ付加してください。
* サフィックスはモデルごとではなく、変数ごとに読み取られます。Amazon Bedrock、Google Cloud's Agent Platform、Microsoft Foundry では、ある変数で `[1m]` なしのモデル ID を指定すると、別の変数で同じモデルにサフィックスを付けて設定していても、200K コンテキストが使用されます。Sonnet 5 はこれらのプロバイダーでは常に 1M ウィンドウで動作し、サフィックスは必要ありません。

`ANTHROPIC_DEFAULT_*_MODEL` 変数を設定すると、`/model` ピッカーには、そのファミリーの組み込みの行（1M コンテキストの行を含む）の代わりに、そのモデルの行が 1 つ表示されます。その変数にサフィックスを追加せずに 1M ウィンドウを利用するには、ユーザーが `/model opus[1m]` を実行します。すると Claude Code は、変数で指定されたモデルにサフィックスを適用します。`/model sonnet[1m]` も同様に動作します。

<Note>
  [MDM または管理設定ファイル](/docs/ja/managed-settings#delivery-mechanisms)を通じて配布される `availableModels` 許可リストは、サードパーティプロバイダーを使用する場合でも適用されます。[サーバー管理設定はそこには配布されません](/docs/ja/server-managed-settings#platform-availability)。

  フィルタリングは、`opus` などのモデルエイリアス、`claude-opus-4-8` などのバージョンプレフィックス、またはプロバイダー形式の完全なモデル ID に対して照合されます。`us.anthropic.` などのプロバイダー固有のプレフィックスは取り除かれないため、特定のモデルを許可するには、プロバイダー形式の完全な ID を記載するか、[`modelOverrides`](#override-model-ids-per-version) を通じてマッピングしてください。固定したモデルの場合、その ID は対応する `ANTHROPIC_DEFAULT_*_MODEL` 変数に設定した値です。照合の前に、許可リストのエントリと要求されたモデルの両方から `[1m]` サフィックスが取り除かれます。
</Note>

<h3 id="customize-pinned-model-display-and-capabilities">
  固定モデルの表示と機能のカスタマイズ
</h3>

サードパーティプロバイダーでモデルを固定すると、`/model` ピッカーのその行には、Claude Code が固定した ID を認識する場合はデフォルトでモデル名が表示され、認識しない場合は生の ID が表示されます。

* **認識される場合**: Claude Code が把握しているモデルの正確な ID。Anthropic API の ID や、プロバイダーまたはゲートウェイでのその形式などで、`[1m]` サフィックスの有無は問いません。`us.anthropic.claude-sonnet-4-5-20250929-v1:0` を固定すると、行には `Sonnet 4.5` と表示されます。
* **認識されない場合**: アプリケーション推論プロファイル ARN や Claude Code が把握していないモデルバージョンなど、その他の ID。ただし、[`modelOverrides`](#override-model-ids-per-version) のエントリがモデルをその正確な文字列にマッピングしている場合を除きます。Microsoft Foundry ではデプロイ名がユーザー定義であるため、マッピングの有無にかかわらず Claude Code は固定した ID を認識せず、行にはデフォルトでデプロイ名が表示されます。

行にモデル名が表示される場合、そのデフォルトの説明には固定した ID が含まれるため、どの ID が固定されているかを確認できます。

Claude Code は、固定したモデルがどの機能をサポートしているかを認識できない場合もあります。固定した各モデルについて、表示名と説明を自分で設定し、付随する環境変数で機能を宣言できます。

これらの変数は、Amazon Bedrock、Google Cloud's Agent Platform、Microsoft Foundry などのサードパーティプロバイダーで有効になります。`_NAME` と `_DESCRIPTION` 変数は、`ANTHROPIC_BASE_URL` が [LLM ゲートウェイ](/docs/ja/llm-gateway)を指している場合にも有効になります。`api.anthropic.com` に直接接続する場合は効果がありません。

| 環境変数 | 説明 |
| - | - |
| `ANTHROPIC_DEFAULT_OPUS_MODEL_NAME` | `/model` ピッカーにおける固定した Opus モデルの表示名。設定されていない場合、Claude Code が固定した ID を認識すればモデル名が、認識しなければ固定した ID が行に表示されます |
| `ANTHROPIC_DEFAULT_OPUS_MODEL_DESCRIPTION` | `/model` ピッカーにおける固定した Opus モデルの表示説明。設定されていない場合、`Custom Opus model` で始まるデフォルトの説明が行に表示されます |
| `ANTHROPIC_DEFAULT_OPUS_MODEL_SUPPORTED_CAPABILITIES` | 固定した Opus モデルがサポートする機能のカンマ区切りリスト |

同じ `_NAME`、`_DESCRIPTION`、`_SUPPORTED_CAPABILITIES` サフィックスは、`ANTHROPIC_DEFAULT_SONNET_MODEL`、`ANTHROPIC_DEFAULT_HAIKU_MODEL`、`ANTHROPIC_DEFAULT_FABLE_MODEL`、`ANTHROPIC_CUSTOM_MODEL_OPTION` でも使用できます。

Claude Code は、モデル ID を既知のパターンと照合することで、[effort レベル](#adjust-effort-level)や[拡張思考](#extended-thinking)などの機能を有効にします。Amazon Bedrock の ARN やカスタムデプロイ名などのプロバイダー固有の ID はこれらのパターンに一致しないことが多く、サポートされている機能が無効のままになります。`_SUPPORTED_CAPABILITIES` を設定して、モデルが実際にサポートしている機能を Claude Code に伝えてください。

| 機能の値 | 有効になるもの |
| - | - |
| `effort` | [effort レベル](#adjust-effort-level)と `/effort` コマンド |
| `xhigh_effort` | `xhigh` effort レベル |
| `max_effort` | `max` effort レベル |
| `thinking` | [拡張思考](#extended-thinking) |
| `adaptive_thinking` | タスクの複雑さに応じて思考を動的に割り当てる適応型推論 |
| `interleaved_thinking` | ツール呼び出し間の思考 |

`_SUPPORTED_CAPABILITIES` が設定されている場合、Claude Code は対応する固定モデルについて、記載された機能を有効にし、記載されていない機能を無効にします。変数が設定されていない場合、Claude Code はモデル ID に基づく組み込みの検出にフォールバックします。

次の例では、Opus を Amazon Bedrock のカスタムモデル ARN に固定し、わかりやすい名前を設定して、その機能を宣言しています。

```bash theme={null}
export ANTHROPIC_DEFAULT_OPUS_MODEL='arn:aws:bedrock:us-east-1:123456789012:custom-model/abc'
export ANTHROPIC_DEFAULT_OPUS_MODEL_NAME='Opus via Bedrock'
export ANTHROPIC_DEFAULT_OPUS_MODEL_DESCRIPTION='Opus 4.7 routed through a Bedrock custom endpoint'
export ANTHROPIC_DEFAULT_OPUS_MODEL_SUPPORTED_CAPABILITIES='effort,xhigh_effort,max_effort,thinking,adaptive_thinking,interleaved_thinking'
```

<h3 id="override-model-ids-per-version">
  バージョンごとのモデル ID の上書き
</h3>

Claude Code を組み込み、[`CLAUDE_CODE_PROVIDER_MANAGED_BY_HOST`](/docs/ja/env-vars) を設定しているプラットフォームでは、ホストのモデル設定が管理設定のモデル設定より優先されます。一方、管理設定の `availableModels` 許可リストは、ホストが独自のものを提供しない限り引き続き有効です。ホストがどのキーと変数を上書きするかについては、[管理設定の優先順位の例外](/docs/ja/settings#exceptions-to-managed-settings-precedence)を参照してください。

上記のファミリーレベルの環境変数は、ファミリーエイリアスごとに 1 つのモデル ID を設定します。同じファミリー内の複数のバージョンをそれぞれ異なるプロバイダー ID にマッピングする必要がある場合は、代わりに `modelOverrides` 設定を使用します。

`modelOverrides` は、個々の Anthropic モデル ID を、Claude Code がプロバイダーの API に送信するプロバイダー固有の文字列にマッピングします。ユーザーが `/model` ピッカーでマッピングされたモデルを選択すると、Claude Code は組み込みのデフォルトの代わりに、設定された値を使用します。

これにより、エンタープライズの管理者は、ガバナンス、コスト配分、またはリージョンルーティングのために、各モデルバージョンを特定の Amazon Bedrock 推論プロファイル ARN、Google Cloud's Agent Platform のバージョン名、または Microsoft Foundry のデプロイ名にルーティングできます。

[設定ファイル](/docs/ja/settings#where-settings-live)で `modelOverrides` を設定します。

```json theme={null}
{
  "modelOverrides": {
    "claude-opus-4-7": "arn:aws:bedrock:us-east-2:123456789012:application-inference-profile/opus-prod",
    "claude-opus-4-6": "arn:aws:bedrock:us-east-2:123456789012:application-inference-profile/opus-46-prod",
    "claude-sonnet-4-6": "arn:aws:bedrock:us-east-2:123456789012:application-inference-profile/sonnet-prod"
  }
}
```

キーは、[モデルの概要](https://platform.claude.com/docs/en/about-claude/models/overview)に記載されている Anthropic モデル ID である必要があります。日付付きのモデル ID の場合は、そこに記載されているとおりに日付サフィックスを含めてください。不明なキーは無視されます。

ゲートウェイエイリアスなどの ID に対する `[claude-code:unrecognized_model]` [診断行](/docs/ja/errors#unrecognized-model-id-on-a-request)を止めるには、その ID を値とするエントリを追加します。

上書きは、`/model` ピッカーの各エントリの背後にある組み込みのモデル ID を置き換えます。Amazon Bedrock では、`modelOverrides` のエントリは、Claude Code が起動時に自動的に検出する推論プロファイルよりも優先されます。Amazon Bedrock の推論プロファイル ARN や Microsoft Foundry のデプロイ名など、すでにプロバイダーネイティブな値は、Claude Code がそのままプロバイダーに渡します。

上書きは、`--model`、`ANTHROPIC_MODEL` 環境変数、または `ANTHROPIC_DEFAULT_*_MODEL` 環境変数を通じて Anthropic モデル ID を直接渡した場合にも適用されます。Amazon Bedrock、Google Cloud's Agent Platform、[Mantle](/docs/ja/amazon-bedrock#use-the-mantle-endpoint) では、`modelOverrides` エントリのない Anthropic モデル ID は、プロバイダーがそのバージョンをサポートしている場合、そのバージョンの `/model` ピッカーの行と同じプロバイダー固有の ID に解決されます。Mantle はバージョンの一部のみをサポートしています。その範囲外の Anthropic モデル ID の場合、`modelOverrides` エントリで対応していない限り、Claude Code はマッピングせずに生の ID を Mantle に送信します。v2.1.200 より前は、`--model` と環境変数の値は上書きマップを経由せず、そのままプロバイダーに渡されていました。

`modelOverrides` は `availableModels` と連携して動作します。許可リストは上書き値ではなく Anthropic モデル ID に対して評価されるため、Opus バージョンが ARN にマッピングされている場合でも、`availableModels` の `"opus"` のようなエントリは引き続き一致します。管理設定で `enforceAvailableModels` が設定されている場合、強制される Default は[管理設定](/docs/ja/managed-settings#how-claude-code-combines-managed-sources)の `modelOverrides` のみを通じて解決されます。推論プロファイル ARN に固定したバージョンなど、管理者のマッピングは強制される Default に反映されます。ユーザー設定やプロジェクト設定の上書きはこれに影響しません。

[管理設定](/docs/ja/managed-settings)で `availableModels` が設定されている場合、`--model` または上記の環境変数を通じて直接渡された Anthropic モデル ID には、管理設定の `modelOverrides` のみが適用されます。Claude Code はそれらの ID に対するユーザー設定やプロジェクト設定の上書きを無視し、管理リストで除外された ID は、どの設定ソースの `modelOverrides` を通じても解決しません。この管理ソースの制限には Claude Code v2.1.200 以降が必要です。ブロックされた ID の扱いについては、[モデル選択の制限](#restrict-model-selection)を参照してください。

<h3 id="prompt-caching-configuration">
  プロンプトキャッシュの設定
</h3>

Claude Code は、パフォーマンスを最適化しコストを削減するために、自動的に[プロンプトキャッシュ](/docs/ja/prompt-caching)を使用します。プロンプトキャッシュは、グローバルに、または特定のモデル階層ごとに無効にできます。

| 環境変数 | 説明 |
| - | - |
| `DISABLE_PROMPT_CACHING` | `1` に設定すると、すべてのモデルでプロンプトキャッシュを無効にします。モデルごとの設定より優先されます |
| `DISABLE_PROMPT_CACHING_HAIKU` | `1` に設定すると、[デフォルトの Haiku モデル](/docs/ja/prompt-caching#disable-prompt-caching)のプロンプトキャッシュを無効にします |
| `DISABLE_PROMPT_CACHING_SONNET` | `1` に設定すると、[デフォルトの Sonnet モデル](/docs/ja/prompt-caching#disable-prompt-caching)のプロンプトキャッシュを無効にします |
| `DISABLE_PROMPT_CACHING_OPUS` | `1` に設定すると、[デフォルトの Opus モデル](/docs/ja/prompt-caching#disable-prompt-caching)のプロンプトキャッシュを無効にします |
| `DISABLE_PROMPT_CACHING_FABLE` | `1` に設定すると、Fable モデルのみのプロンプトキャッシュを無効にします |

メインの会話とサブエージェントのキャッシュ TTL を個別に選択するには、[TTL を自分で選択する](/docs/ja/prompt-caching#choose-the-ttl-yourself)を参照してください。キャッシュミスが発生する原因については、[Claude Code がプロンプトキャッシュを使用する方法](/docs/ja/prompt-caching)を参照してください。

<h2 id="version-history">
  バージョン履歴
</h2>

この表は、各モデルエイリアスの解決先モデルが変更された Claude Code のバージョンを、新しい順に示しています。

| バージョン | 変更内容 |
| :- | :- |
| v2.1.284 | Anthropic API で `sonnet` が Sonnet 5.5 に解決されるようになりました |
| v2.1.280 | Anthropic API、Claude Platform on AWS、Amazon Bedrock、Google Cloud の Agent Platform で `opus` が Opus 5.5 に解決されるようになりました |
| v2.1.257 | Claude apps ゲートウェイのセッションを除き、`fable` が Fable 5.1 に解決されるようになりました |
| v2.1.219 | Anthropic API、Claude Platform on AWS、Amazon Bedrock、Agent Platform で `opus` が Opus 5 に解決されるようになりました |
| v2.1.207 | Claude Platform on AWS、Amazon Bedrock、Agent Platform で `opus` が Opus 4.8 に解決されるようになりました |
| v2.1.197 | Anthropic API で `sonnet` が Sonnet 5 に解決されるようになりました |
| v2.1.154 | Anthropic API で `opus` が Opus 4.8 に解決されるようになりました |
| それ以前 | `opus` は Claude Platform on AWS では Opus 4.7 に、Amazon Bedrock と Agent Platform では Opus 4.6 に解決されます。`fable` はすべてのプロバイダーで Fable 5 に解決されます |
