> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# 機能の利用可能性

> Anthropic のサブスクリプションプラン、Anthropic Console、Amazon Bedrock、Claude Platform on AWS、Google Cloud の Agent Platform、Microsoft Foundry 全体で利用可能な Claude Code 機能を比較します。

Claude Code CLI とローカルで実行されるすべてのものは、すべてのプロバイダーで同じように動作します。プロバイダーごとのセットアップ手順については、[エンタープライズデプロイメント概要](https://code.claude.com/docs/ja/third-party-integrations.md)を参照してください。プロバイダーで不足している機能に直接進みたい場合は、[プロバイダー別サマリー](#summary-by-provider)タブを参照してください。

以下の表では、✓ は利用可能、✗ は利用不可、「注記を参照」は部分的なサポートについての脚注にリンクしています。✓ の後の修飾子は、その部分集合への利用可能性を絞り込み、「Admin-enabled」は、組織管理者がそれをオンにするまで機能がオフであることを意味します。

## モデルプロバイダー別の利用可能性

認証方法によって、Claude Code が利用できる機能が決まります。利用中のプロバイダーで使えない機能の一覧は、[プロバイダー別の概要](#summary-by-provider)のタブを参照してください。表の中で該当する列を見つけるには、次を参考にしてください。

* **Claude サブスクリプション**：Pro、Max、Team、または Enterprise プランの claude.ai アカウントでサインインしている場合
* **Anthropic Console**：Anthropic API キーで認証しているか、[API キーなしで Console アカウントにサインイン](https://code.claude.com/docs/ja/authentication.md#sign-in-without-an-api-key)している場合
* **Amazon Bedrock**：Amazon Bedrock のモデルカタログから Claude モデルを使用し、`CLAUDE_CODE_USE_BEDROCK` を設定している場合。[Mantle エンドポイント](https://code.claude.com/docs/ja/amazon-bedrock.md#use-the-mantle-endpoint)（`CLAUDE_CODE_USE_MANTLE`）もこの列に含まれます
* **Claude Platform on AWS**：AWS Marketplace を通じて Claude を購入しているものの Anthropic API を呼び出しており、`CLAUDE_CODE_USE_ANTHROPIC_AWS` を設定している場合
* **Google Cloud's Agent Platform**：Google が運営。`CLAUDE_CODE_USE_VERTEX` を設定します
* **Microsoft Foundry**：Anthropic が運営。`CLAUDE_CODE_USE_FOUNDRY` を設定します

### すべてのプロバイダーで利用できる機能

次の機能はすべてのプロバイダーで動作します。

* [CLI](https://code.claude.com/docs/ja/quickstart.md) と [Agent SDK](https://code.claude.com/docs/ja/agent-sdk/overview.md)
* [VS Code](https://code.claude.com/docs/ja/vs-code.md) および [JetBrains](https://code.claude.com/docs/ja/jetbrains.md) 拡張機能
* [サブエージェント](https://code.claude.com/docs/ja/sub-agents.md)、[フック](https://code.claude.com/docs/ja/hooks-guide.md)、[コマンド](https://code.claude.com/docs/ja/commands.md)、[スキル](https://code.claude.com/docs/ja/skills.md)
* [CLAUDE.md メモリ](https://code.claude.com/docs/ja/memory.md)、[プラグイン](https://code.claude.com/docs/ja/plugins/overview.md)、[MCP サーバー](https://code.claude.com/docs/ja/mcp.md)
* [チェックポイント](https://code.claude.com/docs/ja/checkpointing.md)、[サンドボックス化](https://code.claude.com/docs/ja/sandboxing.md)、[ワークフロー](https://code.claude.com/docs/ja/workflows.md)
* [OpenTelemetry メトリクス](https://code.claude.com/docs/ja/monitoring-usage.md)と[管理設定ファイル](https://code.claude.com/docs/ja/managed-settings.md#delivery-mechanisms)

次の機能にはプロバイダー固有の違いがあります。

* **MCP サーバー**：[claude.ai のコネクタ](https://code.claude.com/docs/ja/mcp.md#use-mcp-servers-from-claude-ai)は、claude.ai サブスクリプションが有効な認証方法である場合にのみ読み込まれます。[ツール検索](https://code.claude.com/docs/ja/mcp.md#configure-tool-search)は、Microsoft Foundry の [Azure でホストされるデプロイ](https://platform.claude.com/docs/en/build-with-claude/claude-in-microsoft-foundry#hosting-options)ではサポートされていません。Google Cloud's Agent Platform では、Claude Opus 4.5、Claude Sonnet 4.5、Claude Haiku 4.5 より前のモデルではツール検索がサポートされていません
* **サブエージェント**：メインの会話で Fable を実行している場合、組み込みの [Explore サブエージェント](https://code.claude.com/docs/ja/sub-agents.md#built-in-subagents)は、Claude サブスクリプション、Anthropic Console アカウント、または `ANTHROPIC_BASE_URL` 経由で接続する [LLM ゲートウェイ](https://code.claude.com/docs/ja/llm-gateway)では Opus で実行されます。Claude Platform on AWS を含むその他のプロバイダーでは Fable で実行されます
* **[コマンド](https://code.claude.com/docs/ja/commands.md#all-commands)**：
  * `/design-sync` と、`claude import` サブコマンド形式を持つ `/import` は、Amazon Bedrock、Google Cloud's Agent Platform、Microsoft Foundry、Claude Platform on AWS、および [Claude apps ゲートウェイ](https://code.claude.com/docs/ja/claude-apps-gateway#availability-and-limitations)経由では利用できません
  * `/voice` には claude.ai アカウントが必要です
  * `/list-agents` とそのエイリアス `/peers` は、[セッション間メッセージングが有効になっている](https://code.claude.com/docs/ja/cross-session-messaging.md#availability)セッションでのみ利用できます

### Claude サブスクリプションが必要な機能

次の機能には claude.ai アカウントでのサインインが必要で、Anthropic Console の API キーやサードパーティプロバイダーからは利用できません。

* [クラウドセッション](https://code.claude.com/docs/ja/claude-code-on-the-web.md)とモバイル版 Claude Code
* [Slack での Claude Code](https://code.claude.com/docs/ja/slack.md)：Pro および Max プラン
* [Claude Code Desktop](https://code.claude.com/docs/ja/desktop.md)
* [クラウドのスケジュールタスク](https://code.claude.com/docs/ja/routines.md)（`/schedule`）
* [Ultrareview](https://code.claude.com/docs/ja/ultrareview.md)
* [Code Review](https://code.claude.com/docs/ja/code-review.md)：Team および Enterprise プラン
* [Remote Control](https://code.claude.com/docs/ja/remote-control.md)
* [Chrome 拡張機能](https://code.claude.com/docs/ja/chrome.md)
* [コンピューター操作](https://code.claude.com/docs/ja/computer-use.md)：Pro および Max プラン
* [アーティファクト](https://code.claude.com/docs/ja/artifacts.md)：Pro、Max、Team、Enterprise プラン
* [音声入力](https://code.claude.com/docs/ja/voice-dictation.md)

Desktop は部分的な例外です。[ゲートウェイのルーティングはアプリ内で、または管理者が設定できます](https://code.claude.com/docs/ja/llm-gateway-connect.md#desktop-app)。[Claude Desktop on 3P](https://claude.com/docs/third-party/claude-desktop/overview) でも、Amazon Bedrock、Google Cloud's Agent Platform、Microsoft Foundry、またはセルフホストの LLM ゲートウェイ上で Code タブを実行できます。また、Anthropic Console の API キーを使用して [Claude API](https://claude.com/docs/third-party/claude-desktop/claude-api) 上で Code タブを実行することもできます。これらの機能のプラン別の利用可能性については、[サブスクリプションプラン別の利用可能性](#availability-by-subscription-plan)を参照してください。

### プロバイダーによって異なる CLI の機能

次の機能はローカルの CLI で動作しますが、すべてのプロバイダーが提供しているわけではないサーバー側の機能に依存しています。

<table>
  <thead>
    <tr>
      <th>機能</th>
      <th>Claude サブスクリプション</th>
      <th>Anthropic Console</th>
      <th>Amazon Bedrock</th>
      <th>Claude Platform on AWS</th>
      <th>Google Cloud's Agent Platform</th>
      <th>Microsoft Foundry</th>
    </tr>
  </thead>

  <tbody>
    <tr>
      <td>[Web 検索](https://code.claude.com/docs/ja/tools-reference.md#websearch-tool-behavior)</td>
      <td>✓</td>
      <td>✓</td>
      <td>✗</td>
      <td>✓</td>
      <td>注を参照 <sup>[1](#fn1)</sup></td>
      <td>✓</td>
    </tr>

    <tr>
      <td>[fast mode](https://code.claude.com/docs/ja/fast-mode.md)</td>
      <td>✓（Team および Enterprise では [Owner による有効化](https://code.claude.com/docs/ja/fast-mode.md#enable-fast-mode-for-your-organization)が必要）</td>
      <td>✓（Opus 5 および 4.8 ではプロビジョニングが必要）</td>
      <td>✗</td>
      <td>✗</td>
      <td>✗</td>
      <td>✗</td>
    </tr>

    <tr>
      <td>[auto モード](https://code.claude.com/docs/ja/auto-mode-config.md)</td>
      <td>✓</td>
      <td>✓</td>
      <td>注を参照 <sup>[2](#fn2)</sup></td>
      <td>✓</td>
      <td>注を参照 <sup>[2](#fn2)</sup></td>
      <td>注を参照 <sup>[2](#fn2)</sup></td>
    </tr>

    <tr>
      <td>[Advisor](https://code.claude.com/docs/ja/advisor.md)</td>
      <td>✓</td>
      <td>✓</td>
      <td>✗</td>
      <td>✗</td>
      <td>✗</td>
      <td>✗</td>
    </tr>

    <tr>
      <td>[セッション間メッセージング](https://code.claude.com/docs/ja/cross-session-messaging.md)</td>
      <td>✓ <sup>[5](#fn5)</sup></td>
      <td>✓（同一マシン） <sup>[5](#fn5)</sup></td>
      <td>✓（同一マシン） <sup>[5](#fn5)</sup></td>
      <td>✓（同一マシン） <sup>[5](#fn5)</sup></td>
      <td>✓（同一マシン） <sup>[5](#fn5)</sup></td>
      <td>✓（同一マシン） <sup>[5](#fn5)</sup></td>
    </tr>

    <tr>
      <td>[チャネル](https://code.claude.com/docs/ja/channels.md)</td>
      <td>✓</td>
      <td>✓</td>
      <td>✗</td>
      <td>✗</td>
      <td>✗</td>
      <td>✗</td>
    </tr>

    <tr>
      <td>[GitHub Actions](https://code.claude.com/docs/ja/github-actions.md)</td>
      <td>✓</td>
      <td>✓</td>
      <td>✓</td>
      <td>✗</td>
      <td>✓</td>
      <td>✓</td>
    </tr>

    <tr>
      <td>[GitLab CI/CD](https://code.claude.com/docs/ja/gitlab-ci-cd.md)</td>
      <td>✓</td>
      <td>✓</td>
      <td>✓</td>
      <td>✓</td>
      <td>✓</td>
      <td>✗</td>
    </tr>
  </tbody>
</table>

### 管理と分析

組織レベルの制御と使用状況の可視化です。

<table>
  <thead>
    <tr>
      <th>機能</th>
      <th>Claude サブスクリプション</th>
      <th>Anthropic Console</th>
      <th>Amazon Bedrock</th>
      <th>Claude Platform on AWS</th>
      <th>Google Cloud's Agent Platform</th>
      <th>Microsoft Foundry</th>
    </tr>
  </thead>

  <tbody>
    <tr>
      <td>[分析ダッシュボードと API](https://code.claude.com/docs/ja/analytics.md)</td>
      <td>✓（ダッシュボード：Team および Enterprise、API：Enterprise）</td>
      <td>✓ <sup>[4](#fn4)</sup></td>
      <td>✗</td>
      <td>✗</td>
      <td>✗</td>
      <td>✗</td>
    </tr>

    <tr>
      <td>[サーバー管理設定](https://code.claude.com/docs/ja/server-managed-settings.md)</td>
      <td>✓（Team および Enterprise）</td>
      <td>[プラットフォームの利用可能性](https://code.claude.com/docs/ja/server-managed-settings.md#platform-availability)を参照</td>
      <td>✗</td>
      <td>✗</td>
      <td>✗</td>
      <td>✗</td>
    </tr>

    <tr>
      <td>[Zero Data Retention](https://code.claude.com/docs/ja/zero-data-retention.md)</td>
      <td>✓（条件を満たす Enterprise アカウント）</td>
      <td>✓（条件を満たすアカウント）</td>
      <td>注を参照 <sup>[3](#fn3)</sup></td>
      <td>✓（条件を満たすアカウント）</td>
      <td>注を参照 <sup>[3](#fn3)</sup></td>
      <td>注を参照 <sup>[3](#fn3)</sup></td>
    </tr>
  </tbody>
</table>

<sup>1</sup> Google Cloud's Agent Platform では、Web 検索は Opus 4、Sonnet 4、Haiku 4.5 以降のモデルで利用できます。\

<sup>2</sup> これらのプロバイダーでは、auto モードは Claude Sonnet 5 以降、Opus 4.7 以降、Haiku 5.5、および Fable モデルのみをサポートします。[auto モードの設定](https://code.claude.com/docs/ja/auto-mode-config.md)を参照してください。これらのプロバイダーでセッションがどの権限モードで開始されるかについては、[セッションが開始されるモード](https://code.claude.com/docs/ja/permission-modes.md#which-mode-a-session-starts-in)を参照してください。\

<sup>3</sup> クラウドプロバイダーとの契約に従います。\

<sup>4</sup> ダッシュボードと API のみです。[コントリビューションメトリクス](https://code.claude.com/docs/ja/analytics.md#enable-contribution-metrics)には claude.ai の Team または Enterprise 組織が必要です。\

<sup>5</sup> macOS および Linux（WSL 2 内の Linux を含む）では Claude Code v2.1.224 以降が必要です。ネイティブの Windows では Claude Code v2.1.234 以降が必要です。API キー認証の場合、メッセージングは同一マシン内に限られます。Amazon Bedrock、Claude Platform on AWS、Google Cloud's Agent Platform、Microsoft Foundry では、メッセージングは同一マシン内に限られ、Claude Code v2.1.248 以降が必要です。Claude が[クラウドセッション](https://code.claude.com/docs/ja/claude-code-on-the-web.md)や他のマシン上のセッションを見つけられるのは、[Remote Control](https://code.claude.com/docs/ja/remote-control.md) に接続されたセッションからのみです。接続するには、claude.ai でのサインインと、その他の [Remote Control の要件](https://code.claude.com/docs/ja/remote-control.md#requirements)を満たす必要があります。[他のマシン上のセッションにメッセージを送る](https://code.claude.com/docs/ja/cross-session-messaging.md#message-sessions-on-other-machines)を参照してください。

> [!NOTE]
>
> [LLM ゲートウェイ](https://code.claude.com/docs/ja/llm-gateway)経由で認証する場合、機能の利用可能性はゲートウェイの転送先である基盤プロバイダーと同じになります。ただし、Claude Code 自体がオフにする機能は除きます。`ANTHROPIC_BASE_URL` が `api.anthropic.com` 以外のホストを指している場合、ゲートウェイが何を転送するかにかかわらず、Claude Code は [Remote Control](https://code.claude.com/docs/ja/remote-control.md#requirements) や[サーバー管理設定](https://code.claude.com/docs/ja/server-managed-settings.md#platform-availability)などの機能をオフにします。[Advisor](https://code.claude.com/docs/ja/advisor.md) などの一部の Anthropic 専用機能は、ゲートウェイがリクエストをそのままの形で Anthropic API に転送する場合にのみ動作します。
>
> Amazon Bedrock 形式または Agent Platform 形式のゲートウェイ、`ANTHROPIC_BASE_URL` ゲートウェイ、Claude apps ゲートウェイでのサインインの間で、Claude Code が送信するリクエストがどのように異なるかについては、[接続方法別のクライアントの動作](https://code.claude.com/docs/ja/llm-gateway-protocol.md#how-the-connection-method-changes-client-behavior)を参照してください。

### プロバイダー別の概要

各タブには、そのプロバイダーで利用できない機能や部分的にサポートされている機能と、代替手段がある場合はその代替手段を記載しています。記載されていないものは、上記の[プロバイダー固有の違い](#features-available-on-every-provider)を除き、Claude サブスクリプションと同じように動作します。Amazon Bedrock、Google Cloud's Agent Platform、Microsoft Foundry、Claude Platform on AWS では、Anthropic へのエラーレポートとテレメトリはデフォルトでオフになっています。それでも Anthropic に送信される通信と、オプトアウトの方法については、[API プロバイダー別のデフォルトの動作](https://code.claude.com/docs/ja/data-usage.md#default-behaviors-by-api-provider)を参照してください。

**Amazon Bedrock**

\*\*利用不可：\*\*すべての [Claude サブスクリプションが必要な機能](#features-that-require-a-claude-subscription)に加え、[Web 検索](https://code.claude.com/docs/ja/tools-reference.md#websearch-tool-behavior)、[fast mode](https://code.claude.com/docs/ja/fast-mode.md)、[Advisor](https://code.claude.com/docs/ja/advisor.md)、[チャネル](https://code.claude.com/docs/ja/channels.md)、[分析ダッシュボード](https://code.claude.com/docs/ja/analytics.md)、[サーバー管理設定](https://code.claude.com/docs/ja/server-managed-settings.md)、[`/design-sync` および `/import` コマンド](https://code.claude.com/docs/ja/commands#all-commands)。

**部分的なサポート：**

* [Desktop](https://code.claude.com/docs/ja/desktop.md)：[Claude Desktop on 3P](https://claude.com/docs/third-party/claude-desktop/overview) 経由のみ
* [auto モード](https://code.claude.com/docs/ja/auto-mode-config.md)：Sonnet 5 以降、Opus 4.7 以降、Haiku 5.5、および Fable モデルのみ
* [セッション間メッセージング](https://code.claude.com/docs/ja/cross-session-messaging.md)：このマシン上の自分のセッション間のみ <sup>[5](#fn5)</sup>
* [Zero Data Retention](https://code.claude.com/docs/ja/zero-data-retention.md)：AWS との契約に従います

\*\*代替手段：\*\*スケジュール設定には、`/schedule` の代わりに [`/loop`](https://code.claude.com/docs/ja/scheduled-tasks) を使用します。クラウドセッションの代わりには、[GitHub Actions](https://code.claude.com/docs/ja/github-actions.md) または [GitLab CI/CD](https://code.claude.com/docs/ja/gitlab-ci-cd.md) を使用します。Web 上の情報を調べるには、特定の URL を指定して [WebFetch ツール](https://code.claude.com/docs/ja/tools-reference.md#webfetch-tool-behavior)を使用します。

**Claude Platform on AWS**

\*\*利用不可：\*\*すべての [Claude サブスクリプションが必要な機能](#features-that-require-a-claude-subscription)に加え、[fast mode](https://code.claude.com/docs/ja/fast-mode.md)、[Advisor](https://code.claude.com/docs/ja/advisor.md)、[チャネル](https://code.claude.com/docs/ja/channels.md)、[GitHub Actions](https://code.claude.com/docs/ja/github-actions.md)、[分析ダッシュボード](https://code.claude.com/docs/ja/analytics.md)、[サーバー管理設定](https://code.claude.com/docs/ja/server-managed-settings.md)、[`/design-sync` および `/import` コマンド](https://code.claude.com/docs/ja/commands#all-commands)。

**Amazon Bedrock では利用できないが、こちらでは利用可能：**[Web 検索](https://code.claude.com/docs/ja/tools-reference.md#websearch-tool-behavior)。

**部分的なサポート：**

* [セッション間メッセージング](https://code.claude.com/docs/ja/cross-session-messaging.md)：このマシン上の自分のセッション間のみ <sup>[5](#fn5)</sup>

\*\*代替手段：\*\*スケジュール設定には、`/schedule` の代わりに [`/loop`](https://code.claude.com/docs/ja/scheduled-tasks) を使用します。クラウドセッションの代わりには、[GitLab CI/CD](https://code.claude.com/docs/ja/gitlab-ci-cd.md) を使用します。

**Google Cloud's Agent Platform**

\*\*利用不可：\*\*すべての [Claude サブスクリプションが必要な機能](#features-that-require-a-claude-subscription)に加え、[fast mode](https://code.claude.com/docs/ja/fast-mode.md)、[Advisor](https://code.claude.com/docs/ja/advisor.md)、[チャネル](https://code.claude.com/docs/ja/channels.md)、[分析ダッシュボード](https://code.claude.com/docs/ja/analytics.md)、[サーバー管理設定](https://code.claude.com/docs/ja/server-managed-settings.md)、[`/design-sync` および `/import` コマンド](https://code.claude.com/docs/ja/commands#all-commands)。

**部分的なサポート：**

* [Desktop](https://code.claude.com/docs/ja/desktop.md)：[管理設定](https://claude.com/docs/third-party/claude-desktop/configuration)または [Claude Desktop on 3P](https://claude.com/docs/third-party/claude-desktop/overview) 経由
* [Web 検索](https://code.claude.com/docs/ja/tools-reference.md#websearch-tool-behavior)：Opus 4、Sonnet 4、Haiku 4.5 以降のモデル
* [auto モード](https://code.claude.com/docs/ja/auto-mode-config.md)：Sonnet 5 以降、Opus 4.7 以降、Haiku 5.5、および Fable モデルのみ
* [セッション間メッセージング](https://code.claude.com/docs/ja/cross-session-messaging.md)：このマシン上の自分のセッション間のみ <sup>[5](#fn5)</sup>
* [Zero Data Retention](https://code.claude.com/docs/ja/zero-data-retention.md)：Google Cloud との契約に従います

\*\*代替手段：\*\*スケジュール設定には、`/schedule` の代わりに [`/loop`](https://code.claude.com/docs/ja/scheduled-tasks) を使用します。クラウドセッションの代わりには、[GitHub Actions](https://code.claude.com/docs/ja/github-actions.md) または [GitLab CI/CD](https://code.claude.com/docs/ja/gitlab-ci-cd.md) を使用します。

**Microsoft Foundry**

\*\*利用不可：\*\*すべての [Claude サブスクリプションが必要な機能](#features-that-require-a-claude-subscription)に加え、[fast mode](https://code.claude.com/docs/ja/fast-mode.md)、[Advisor](https://code.claude.com/docs/ja/advisor.md)、[チャネル](https://code.claude.com/docs/ja/channels.md)、[GitLab CI/CD](https://code.claude.com/docs/ja/gitlab-ci-cd.md)、[分析ダッシュボード](https://code.claude.com/docs/ja/analytics.md)、[サーバー管理設定](https://code.claude.com/docs/ja/server-managed-settings.md)、[`/design-sync` および `/import` コマンド](https://code.claude.com/docs/ja/commands#all-commands)。

**部分的なサポート：**

* [Desktop](https://code.claude.com/docs/ja/desktop.md)：[Claude Desktop on 3P](https://claude.com/docs/third-party/claude-desktop/overview) 経由のみ
* [auto モード](https://code.claude.com/docs/ja/auto-mode-config.md)：Sonnet 5 以降、Opus 4.7 以降、Haiku 5.5、および Fable モデルのみ
* [セッション間メッセージング](https://code.claude.com/docs/ja/cross-session-messaging.md)：このマシン上の自分のセッション間のみ <sup>[5](#fn5)</sup>
* [Zero Data Retention](https://code.claude.com/docs/ja/zero-data-retention.md)：Azure との契約に従います

\*\*代替手段：\*\*スケジュール設定には、`/schedule` の代わりに [`/loop`](https://code.claude.com/docs/ja/scheduled-tasks) を使用します。クラウドセッションの代わりには、[GitHub Actions](https://code.claude.com/docs/ja/github-actions.md) を使用します。

**Anthropic Console**

\*\*利用不可：\*\*すべての [Claude サブスクリプションが必要な機能](#features-that-require-a-claude-subscription)。

[プロバイダーによって異なる CLI の機能](#cli-capabilities-that-vary-by-provider)はすべて利用できますが、Claude Opus 5 または Claude Opus 4.8 で [fast mode](https://code.claude.com/docs/ja/fast-mode.md) を使用するには[プロビジョニングされたアクセス](https://code.claude.com/docs/ja/fast-mode.md#enable-fast-mode-for-your-organization)が必要です。claude.ai の Team または Enterprise 組織で構成した[サーバー管理設定](https://code.claude.com/docs/ja/server-managed-settings.md)は、Console の API キーで認証するセッションには適用されません。それらのセッションにも適用する方法については、[プラットフォームの利用可能性](https://code.claude.com/docs/ja/server-managed-settings.md#platform-availability)を参照してください。

**部分的なサポート：**

* [Desktop](https://code.claude.com/docs/ja/desktop.md)：[Claude API を使用した Claude Desktop on 3P](https://claude.com/docs/third-party/claude-desktop/claude-api) 経由

## サブスクリプションプラン別の利用可能性

Amazon Bedrock、Google Cloud の Agent Platform、Microsoft Foundry、または Anthropic Console API キーを通じて認証する場合、このセクションは適用されません。claude.ai アカウントでサインインすると、プランによって以下の機能の利用可能性が決まります。

[HIPAA 設定](https://code.claude.com/docs/ja/hipaa-setup.md)が適用されている Enterprise 組織では、この表の一部の機能が無効になります。

| 機能 | Pro | Max | Team | Enterprise |
| :- | :- | :- | :- | :- |
| [クラウドセッション](https://code.claude.com/docs/ja/claude-code-on-the-web.md) | ✓ | ✓ | ✓ | ✓ <sup>[6](#fn6)</sup> |
| [クラウドスケジュールタスク](https://code.claude.com/docs/ja/routines.md) | ✓ | ✓ | ✓ | ✓ |
| [Remote Control](https://code.claude.com/docs/ja/remote-control.md) | ✓ | ✓ | Admin-enabled | Admin-enabled |
| [Channels](https://code.claude.com/docs/ja/channels.md) | ✓ | ✓ | Admin-enabled | Admin-enabled |
| [Computer use](https://code.claude.com/docs/ja/computer-use.md) | ✓ | ✓ | ✗ | ✗ |
| Dispatch（[Desktop](https://code.claude.com/docs/ja/desktop.md#sessions-from-dispatch)） | ✓ | ✓ | ✗ | ✗ |
| [Code Review](https://code.claude.com/docs/ja/code-review.md) | ✗ | ✗ | ✓ | ✓ |
| [Artifacts](https://code.claude.com/docs/ja/artifacts.md) | ✓ | ✓ | ✓ | ✓ |
| [アナリティクスダッシュボードと貢献メトリクス](https://code.claude.com/docs/ja/analytics.md) | ✗ | ✗ | ✓ | ✓ |
| [Enterprise Analytics API](https://code.claude.com/docs/ja/analytics.md#access-data-programmatically) | ✗ | ✗ | ✗ | ✓ |
| [サーバー管理設定](https://code.claude.com/docs/ja/server-managed-settings.md) | ✗ | ✗ | ✓ | ✓ |
| [SSO](https://support.claude.com/en/articles/9266767-what-is-the-team-plan) | ✗ | ✗ | ✓ | ✓ |
| SCIM | ✗ | ✗ | ✗ | ✓ |
| [Compliance API](https://platform.claude.com/docs/en/api/compliance) | ✗ | ✗ | ✗ | ✓ |
| [Zero Data Retention](https://code.claude.com/docs/ja/zero-data-retention.md) | ✗ | ✗ | ✗ | ✓ <sup>[7](#fn7)</sup> |

<sup>6</sup> Enterprise では、プレミアムシートまたは Chat + Claude Code シートが必要です。[クラウド上で Claude Code を使用する](https://code.claude.com/docs/ja/claude-code-on-the-web.md)を参照してください。\

<sup>7</sup> 標準 Enterprise プランに含まれていません。適格なアカウントについては Anthropic による個別の有効化が必要です。[Zero Data Retention](https://code.claude.com/docs/ja/zero-data-retention.md)を参照してください。

価格設定と完全なプラン比較については、[Team プラン](https://support.claude.com/en/articles/9266767-what-is-the-team-plan)と [Enterprise プラン](https://support.claude.com/en/articles/9797531-what-is-the-enterprise-plan)を参照してください。

## モデルの利用可能性

プロバイダーとリージョンごとに利用可能な Claude モデルとコンテキストウィンドウサイズについては、[モデル設定](https://code.claude.com/docs/ja/model-config.md)と [モデル概要](https://platform.claude.com/docs/en/about-claude/models/overview)を参照してください。Vision、PDF 入力、および拡張思考はモデル機能であり Claude Code 機能ではなく、モデルを提供するすべてのプロバイダーで動作します。[Prompt caching](https://code.claude.com/docs/ja/prompt-caching.md) はほとんどのプロバイダーで同じように動作します。Amazon Bedrock では、サポートはモデルによって異なります。

## 関連リソース

* [エンタープライズデプロイメント概要](https://code.claude.com/docs/ja/third-party-integrations.md)：プロバイダー全体で認証、請求、およびリージョンを比較
* プロバイダーセットアップガイド：[Amazon Bedrock](https://code.claude.com/docs/ja/amazon-bedrock.md)、[Claude Platform on AWS](https://code.claude.com/docs/ja/claude-platform-on-aws.md)、[Google Cloud の Agent Platform](https://code.claude.com/docs/ja/google-vertex-ai.md)、[Microsoft Foundry](https://code.claude.com/docs/ja/microsoft-foundry.md)
* [プラットフォームと統合](https://code.claude.com/docs/ja/platforms.md)：CLI、Desktop、IDE 拡張機能、Web、モバイル、CI/CD を含む Claude Code が実行される場所
