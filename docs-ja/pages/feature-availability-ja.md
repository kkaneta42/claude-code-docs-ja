> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# 機能の利用可能性

> Anthropic のサブスクリプションプラン、Anthropic Console、Amazon Bedrock、Claude Platform on AWS、Google Vertex AI、Microsoft Foundry 全体で利用可能な Claude Code 機能を比較します。

Claude Code CLI とローカルで実行されるすべてのものは、すべてのプロバイダーで同じように動作します。プロバイダーごとのセットアップ手順については、[エンタープライズデプロイメント概要](/ja/third-party-integrations)を参照してください。プロバイダーで不足している機能に直接進みたい場合は、[プロバイダー別サマリー](#summary-by-provider)タブを参照してください。

以下の表では、✓ は利用可能、✗ は利用不可、「注記を参照」は部分的なサポートについての脚注にリンクしています。✓ の後の修飾子は、その部分集合への利用可能性を絞り込み、「Admin-enabled」は、組織管理者がそれをオンにするまで機能がオフであることを意味します。

<h2 id="availability-by-model-provider">
  モデルプロバイダー別の利用可能性
</h2>

認証方法によって、Claude Code がアクセスできる機能が決まります。プロバイダーで不足している機能の単一リストについては、[プロバイダー別サマリー](#summary-by-provider)タブを参照してください。表内の列を見つけるには：

* **Claude サブスクリプション**：Pro、Max、Team、または Enterprise プランで claude.ai アカウントでサインインします
* **Anthropic Console**：Anthropic API キーで認証します
* **Amazon Bedrock**：Bedrock モデルカタログから Claude モデルを使用し、`CLAUDE_CODE_USE_BEDROCK` を設定します。[Mantle エンドポイント](/ja/amazon-bedrock#use-the-mantle-endpoint)（`CLAUDE_CODE_USE_MANTLE`）はこの列でカバーされています
* **Claude Platform on AWS**：AWS Marketplace を通じて Claude を購入しましたが、Anthropic API を呼び出し、`CLAUDE_CODE_USE_ANTHROPIC_AWS` を設定します
* **Google Vertex AI**：Google が運営しており、`CLAUDE_CODE_USE_VERTEX` を設定します
* **Microsoft Foundry**：Azure 上で Anthropic が運営しており、`CLAUDE_CODE_USE_FOUNDRY` を設定します

<h3 id="features-available-on-every-provider">
  すべてのプロバイダーで利用可能な機能
</h3>

これらはすべてのプロバイダーで同じように動作します：

* [CLI](/ja/quickstart) と [Agent SDK](/ja/agent-sdk/overview)
* [VS Code](/ja/vs-code) と [JetBrains](/ja/jetbrains) 拡張機能
* [Subagents](/ja/sub-agents)、[hooks](/ja/hooks-guide)、[commands](/ja/commands)、および [skills](/ja/skills)
* [CLAUDE.md メモリ](/ja/memory)、[plugins](/ja/plugins)、および [MCP サーバー](/ja/mcp)
* [Checkpoints](/ja/checkpointing)、[sandboxing](/ja/sandboxing)、および [Workflows](/ja/workflows)
* [OpenTelemetry メトリクス](/ja/monitoring-usage) と [管理設定ファイル](/ja/settings#settings-files)

<h3 id="features-that-require-a-claude-subscription">
  Claude サブスクリプションが必要な機能
</h3>

これらは claude.ai アカウントでサインインする必要があり、Anthropic Console API キーまたはサードパーティプロバイダーからはアクセスできません：

* [Web 上の Claude Code](/ja/claude-code-on-the-web)、モバイル上の Claude Code、および [Slack の Claude Code](/ja/slack)
* [Claude Code Desktop](/ja/desktop)
* [Routines](/ja/routines)（`/schedule`）
* [Ultraplan](/ja/ultraplan) と [Ultrareview](/ja/ultrareview)
* [Code Review](/ja/code-review)：Team および Enterprise プラン
* [Remote Control](/ja/remote-control)
* [Chrome 拡張機能](/ja/chrome)
* [Computer use](/ja/computer-use)：Pro および Max プラン
* [Artifacts](/ja/artifacts)：Pro、Max、Team、および Enterprise プラン
* [Voice dictation](/ja/voice-dictation)

Desktop は部分的な例外です：Enterprise デプロイメントは、[管理設定](https://support.claude.com/en/articles/12622667-enterprise-configuration)を介して Desktop を Vertex AI またはゲートウェイプロバイダーにルーティングでき、[Cowork on 3P research preview](https://claude.com/docs/cowork/3p/overview) は Code タブを Bedrock、Vertex AI、Foundry、または自己ホスト型 LLM ゲートウェイで実行します。これらの機能のプラン別利用可能性については、[サブスクリプションプラン別の利用可能性](#availability-by-subscription-plan)を参照してください。

<h3 id="cli-capabilities-that-vary-by-provider">
  プロバイダーによって異なる CLI 機能
</h3>

これらの機能はローカル CLI で動作しますが、すべてのプロバイダーが公開していないサーバー側の機能に依存しています。

<table>
  <thead>
    <tr>
      <th>機能</th>
      <th>Claude サブスクリプション</th>
      <th>Anthropic Console</th>
      <th>Amazon Bedrock</th>
      <th>Claude Platform on AWS</th>
      <th>Google Vertex AI</th>
      <th>Microsoft Foundry</th>
    </tr>
  </thead>

  <tbody>
    <tr>
      <td>[Web 検索](/ja/tools-reference#websearch-tool-behavior)</td>
      <td>✓</td>
      <td>✓</td>
      <td>✗</td>
      <td>✓</td>
      <td>注記を参照 <sup><a href="#fn1">1</a></sup></td>
      <td>✓</td>
    </tr>

    <tr>
      <td>[Fast mode](/ja/fast-mode)</td>
      <td>✓</td>
      <td>✓</td>
      <td>✗</td>
      <td>✗</td>
      <td>✗</td>
      <td>✗</td>
    </tr>

    <tr>
      <td>[Auto mode](/ja/auto-mode-config)</td>
      <td>✓</td>
      <td>✓</td>
      <td>注記を参照 <sup><a href="#fn2">2</a></sup></td>
      <td>✓</td>
      <td>注記を参照 <sup><a href="#fn2">2</a></sup></td>
      <td>注記を参照 <sup><a href="#fn2">2</a></sup></td>
    </tr>

    <tr>
      <td>[Advisor](/ja/advisor)</td>
      <td>✓</td>
      <td>✓</td>
      <td>✗</td>
      <td>✗</td>
      <td>✗</td>
      <td>✗</td>
    </tr>

    <tr>
      <td>[Channels](/ja/channels)</td>
      <td>✓</td>
      <td>✓</td>
      <td>✗</td>
      <td>✗</td>
      <td>✗</td>
      <td>✗</td>
    </tr>

    <tr>
      <td>[`/loop` スケジュール済みタスク](/ja/scheduled-tasks)</td>
      <td>✓</td>
      <td>✓</td>
      <td>注記を参照 <sup><a href="#fn3">3</a></sup></td>
      <td>✓</td>
      <td>注記を参照 <sup><a href="#fn3">3</a></sup></td>
      <td>注記を参照 <sup><a href="#fn3">3</a></sup></td>
    </tr>

    <tr>
      <td>[GitHub Actions](/ja/github-actions) と [GitLab CI/CD](/ja/gitlab-ci-cd)</td>
      <td>✓</td>
      <td>✓</td>
      <td>✓</td>
      <td>✓</td>
      <td>✓</td>
      <td>✗</td>
    </tr>
  </tbody>
</table>

<h3 id="admin-and-analytics">
  管理とアナリティクス
</h3>

組織レベルのコントロールと使用状況の可視化。

<table>
  <thead>
    <tr>
      <th>機能</th>
      <th>Claude サブスクリプション</th>
      <th>Anthropic Console</th>
      <th>Amazon Bedrock</th>
      <th>Claude Platform on AWS</th>
      <th>Google Vertex AI</th>
      <th>Microsoft Foundry</th>
    </tr>
  </thead>

  <tbody>
    <tr>
      <td>[アナリティクスダッシュボードと API](/ja/analytics)</td>
      <td>✓（Team および Enterprise）</td>
      <td>✓ <sup><a href="#fn5">5</a></sup></td>
      <td>✗</td>
      <td>✗</td>
      <td>✗</td>
      <td>✗</td>
    </tr>

    <tr>
      <td>[サーバー管理設定](/ja/server-managed-settings)</td>
      <td>✓（Team および Enterprise）</td>
      <td>✓（Team および Enterprise）</td>
      <td>✗</td>
      <td>✗</td>
      <td>✗</td>
      <td>✗</td>
    </tr>

    <tr>
      <td>[Zero Data Retention](/ja/zero-data-retention)</td>
      <td>✓（適格な Enterprise アカウント）</td>
      <td>✓（適格なアカウント）</td>
      <td>注記を参照 <sup><a href="#fn4">4</a></sup></td>
      <td>✓（適格なアカウント）</td>
      <td>注記を参照 <sup><a href="#fn4">4</a></sup></td>
      <td>注記を参照 <sup><a href="#fn4">4</a></sup></td>
    </tr>
  </tbody>
</table>

<span id="fn1" style={{display: 'block', position: 'relative', top: '-120px'}} /><sup>1</sup> Vertex AI では、Claude 4 モデル以降で Web 検索が利用可能です。<br />
<span id="fn2" style={{display: 'block', position: 'relative', top: '-120px'}} /><sup>2</sup> `CLAUDE_CODE_ENABLE_AUTO_MODE` が必要です。[Auto mode 設定](/ja/auto-mode-config)を参照してください。<br />
<span id="fn3" style={{display: 'block', position: 'relative', top: '-120px'}} /><sup>3</sup> `/loop every 2 hours` などの明示的な間隔はすべてのプロバイダーで動作します。Bedrock、Vertex AI、および Foundry では、`/loop` は独自の間隔を選択したり、デフォルトのメンテナンスプロンプトを提供したりできないため、間隔のないプロンプトは 10 分ごとに実行され、引数のない `/loop` は使用メッセージを表示します。[スケジュール済みタスク](/ja/scheduled-tasks)を参照してください。<br />
<span id="fn4" style={{display: 'block', position: 'relative', top: '-120px'}} /><sup>4</sup> クラウドプロバイダーとの契約に従います。<br />
<span id="fn5" style={{display: 'block', position: 'relative', top: '-120px'}} /><sup>5</sup> ダッシュボードと API のみ。[貢献メトリクス](/ja/analytics#enable-contribution-metrics)には claude.ai Team または Enterprise 組織が必要です。

<Note>
  [LLM ゲートウェイ](/ja/llm-gateway)を通じて認証する場合、機能の利用可能性はゲートウェイが転送する基盤となるプロバイダーと一致します。[Advisor](/ja/advisor) などの一部の Anthropic 専用機能は、ゲートウェイが要求を Anthropic API に完全に転送する場合にのみ機能します。
</Note>

<h3 id="summary-by-provider">
  プロバイダー別サマリー
</h3>

各タブには、そのプロバイダーで利用不可または部分的にサポートされている機能と、存在する場合は代替案が記載されています。記載されていないすべてのものは Claude サブスクリプションと同じように動作します。Bedrock、Vertex AI、Foundry、および Claude Platform on AWS では、Anthropic へのエラー報告とテレメトリはデフォルトでオフです。[API プロバイダー別のデフォルト動作](/ja/data-usage#default-behaviors-by-api-provider)を参照して、どのトラフィックが Anthropic に到達し、オプトアウトする方法を確認してください。

<Tabs>
  <Tab title="Amazon Bedrock">
    **利用不可：** すべての [Claude サブスクリプションが必要な機能](#features-that-require-a-claude-subscription)、および [Web 検索](/ja/tools-reference#websearch-tool-behavior)、[Fast mode](/ja/fast-mode)、[Advisor](/ja/advisor)、[Channels](/ja/channels)、[アナリティクスダッシュボード](/ja/analytics)、および [サーバー管理設定](/ja/server-managed-settings)。

    **部分的なサポート：**

    * [Desktop](/ja/desktop)：[Cowork on 3P research preview](https://claude.com/docs/cowork/3p/overview) 経由のみ
    * [Auto mode](/ja/auto-mode-config)：`CLAUDE_CODE_ENABLE_AUTO_MODE` を設定
    * [`/loop`](/ja/scheduled-tasks)：明示的な間隔のみ
    * [Zero Data Retention](/ja/zero-data-retention)：AWS 契約に従う

    **代替案：** スケジューリングの場合、`/schedule` の代わりに明示的な間隔で [`/loop`](/ja/scheduled-tasks) を使用してください。クラウドセッションの場合、[GitHub Actions](/ja/github-actions) または [GitLab CI/CD](/ja/gitlab-ci-cd) を使用してください。Web ルックアップの場合、特定の URL で [WebFetch ツール](/ja/tools-reference#webfetch-tool-behavior)を使用してください。
  </Tab>

  <Tab title="Claude Platform on AWS">
    **利用不可：** すべての [Claude サブスクリプションが必要な機能](#features-that-require-a-claude-subscription)、および [Fast mode](/ja/fast-mode)、[Advisor](/ja/advisor)、[Channels](/ja/channels)、[アナリティクスダッシュボード](/ja/analytics)、および [サーバー管理設定](/ja/server-managed-settings)。

    **Bedrock では利用不可の場合に利用可能：** [Web 検索](/ja/tools-reference#websearch-tool-behavior)、オプトインフラグなしの [Auto mode](/ja/auto-mode-config)、および [`/loop` 自己ペーシング](/ja/scheduled-tasks)。

    **代替案：** スケジューリングの場合、`/schedule` の代わりに [`/loop`](/ja/scheduled-tasks) を使用してください。クラウドセッションの場合、[GitHub Actions](/ja/github-actions) または [GitLab CI/CD](/ja/gitlab-ci-cd) を使用してください。
  </Tab>

  <Tab title="Google Vertex AI">
    **利用不可：** すべての [Claude サブスクリプションが必要な機能](#features-that-require-a-claude-subscription)、および [Fast mode](/ja/fast-mode)、[Advisor](/ja/advisor)、[Channels](/ja/channels)、[アナリティクスダッシュボード](/ja/analytics)、および [サーバー管理設定](/ja/server-managed-settings)。

    **部分的なサポート：**

    * [Desktop](/ja/desktop)：[管理設定](https://support.claude.com/en/articles/12622667-enterprise-configuration)または [Cowork on 3P research preview](https://claude.com/docs/cowork/3p/overview) 経由
    * [Web 検索](/ja/tools-reference#websearch-tool-behavior)：Claude 4 モデル以降
    * [Auto mode](/ja/auto-mode-config)：`CLAUDE_CODE_ENABLE_AUTO_MODE` を設定
    * [`/loop`](/ja/scheduled-tasks)：明示的な間隔のみ
    * [Zero Data Retention](/ja/zero-data-retention)：Google Cloud 契約に従う

    **代替案：** スケジューリングの場合、`/schedule` の代わりに明示的な間隔で [`/loop`](/ja/scheduled-tasks) を使用してください。クラウドセッションの場合、[GitHub Actions](/ja/github-actions) または [GitLab CI/CD](/ja/gitlab-ci-cd) を使用してください。
  </Tab>

  <Tab title="Microsoft Foundry">
    **利用不可：** すべての [Claude サブスクリプションが必要な機能](#features-that-require-a-claude-subscription)、および [Fast mode](/ja/fast-mode)、[Advisor](/ja/advisor)、[Channels](/ja/channels)、[GitHub Actions](/ja/github-actions) と [GitLab CI/CD](/ja/gitlab-ci-cd)、[アナリティクスダッシュボード](/ja/analytics)、および [サーバー管理設定](/ja/server-managed-settings)。

    **部分的なサポート：**

    * [Desktop](/ja/desktop)：[Cowork on 3P research preview](https://claude.com/docs/cowork/3p/overview) 経由のみ
    * [Auto mode](/ja/auto-mode-config)：`CLAUDE_CODE_ENABLE_AUTO_MODE` を設定
    * [`/loop`](/ja/scheduled-tasks)：明示的な間隔のみ
    * [Zero Data Retention](/ja/zero-data-retention)：Azure 契約に従う

    **代替案：** スケジューリングの場合、明示的な間隔で [`/loop`](/ja/scheduled-tasks) を使用してください。`/schedule` の代わりに。
  </Tab>

  <Tab title="Anthropic Console">
    **利用不可：** すべての [Claude サブスクリプションが必要な機能](#features-that-require-a-claude-subscription)。

    [プロバイダーによって異なる CLI 機能](#cli-capabilities-that-vary-by-provider)のすべてが利用可能であり、API キーが Team または Enterprise 組織に属する場合は [サーバー管理設定](/ja/server-managed-settings)も利用可能です。
  </Tab>
</Tabs>

<h2 id="availability-by-subscription-plan">
  サブスクリプションプラン別の利用可能性
</h2>

Bedrock、Vertex AI、Foundry、または Anthropic Console API キーを通じて認証する場合、このセクションは適用されません。claude.ai アカウントでサインインすると、プランによって以下の機能の利用可能性が決まります。

| 機能                                                                                      | Pro | Max | Team          | Enterprise                        |
| :-------------------------------------------------------------------------------------- | :-- | :-- | :------------ | :-------------------------------- |
| [Web 上の Claude Code](/ja/claude-code-on-the-web)                                        | ✓   | ✓   | ✓             | ✓ <sup><a href="#fn6">6</a></sup> |
| [Routines](/ja/routines)                                                                | ✓   | ✓   | ✓             | ✓                                 |
| [Remote Control](/ja/remote-control)                                                    | ✓   | ✓   | Admin-enabled | Admin-enabled                     |
| [Channels](/ja/channels)                                                                | ✓   | ✓   | Admin-enabled | Admin-enabled                     |
| [Computer use](/ja/computer-use)                                                        | ✓   | ✓   | ✗             | ✗                                 |
| Dispatch（[Desktop](/ja/desktop#sessions-from-dispatch)）                                 | ✓   | ✓   | ✗             | ✗                                 |
| [Code Review](/ja/code-review)                                                          | ✗   | ✗   | ✓             | ✓                                 |
| [Artifacts](/ja/artifacts)                                                              | ✓   | ✓   | ✓             | Admin-enabled                     |
| [アナリティクスダッシュボード、API、および貢献メトリクス](/ja/analytics)                                          | ✗   | ✗   | ✓             | ✓                                 |
| [サーバー管理設定](/ja/server-managed-settings)                                                 | ✗   | ✗   | ✓             | ✓                                 |
| [SSO](https://support.claude.com/en/articles/9266767-what-is-the-team-plan)             | ✗   | ✗   | ✓             | ✓                                 |
| SCIM                                                                                    | ✗   | ✗   | ✗             | ✓                                 |
| [Compliance API](https://platform.claude.com/docs/en/api/admin-api/compliance/overview) | ✗   | ✗   | ✗             | ✓                                 |
| [Zero Data Retention](/ja/zero-data-retention)                                          | ✗   | ✗   | ✗             | ✓ <sup><a href="#fn7">7</a></sup> |

<span id="fn6" style={{display: 'block', position: 'relative', top: '-120px'}} /><sup>6</sup> Enterprise では、プレミアムシートまたは Chat + Claude Code シートが必要です。[Web 上の Claude Code](/ja/claude-code-on-the-web)を参照してください。<br />
<span id="fn7" style={{display: 'block', position: 'relative', top: '-120px'}} /><sup>7</sup> 標準 Enterprise プランに含まれていません。適格なアカウントについては Anthropic による個別の有効化が必要です。[Zero Data Retention](/ja/zero-data-retention)を参照してください。

価格設定と完全なプラン比較については、[Team プラン](https://support.claude.com/en/articles/9266767-what-is-the-team-plan)と [Enterprise プラン](https://support.claude.com/en/articles/9797531-what-is-the-enterprise-plan)を参照してください。

<h2 id="model-availability">
  モデルの利用可能性
</h2>

プロバイダーとリージョンごとに利用可能な Claude モデルとコンテキストウィンドウサイズについては、[モデル設定](/ja/model-config)と [モデル概要](https://platform.claude.com/docs/en/about-claude/models/overview)を参照してください。Vision、PDF 入力、および拡張思考はモデル機能であり Claude Code 機能ではなく、モデルを提供するすべてのプロバイダーで動作します。[Prompt caching](/ja/prompt-caching) はほとんどのプロバイダーで同じように動作します。Bedrock では、サポートはモデルによって異なります。

<h2 id="related-resources">
  関連リソース
</h2>

* [エンタープライズデプロイメント概要](/ja/third-party-integrations)：プロバイダー全体で認証、請求、およびリージョンを比較
* プロバイダーセットアップガイド：[Amazon Bedrock](/ja/amazon-bedrock)、[Claude Platform on AWS](/ja/claude-platform-on-aws)、[Google Vertex AI](/ja/google-vertex-ai)、[Microsoft Foundry](/ja/microsoft-foundry)
* [プラットフォームと統合](/ja/platforms)：CLI、Desktop、IDE 拡張機能、Web、モバイル、CI/CD を含む Claude Code が実行される場所
