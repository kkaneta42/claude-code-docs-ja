> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# サーバー管理設定を構成する

> デバイス管理インフラストラクチャを必要とせずに、サーバー配信設定を通じて組織全体で Claude Code を一元的に構成します。

サーバー管理設定により、組織の所有者は claude.ai コンソールの [**Organization settings > Claude Code > Managed settings**](https://claude.ai/admin-settings/claude-code) から Claude Code を一元的に構成できます。Claude Code クライアントは、ユーザーが対象となる認証情報を使用して、サーバー管理配信がサポートされているプラットフォームで認証すると、これらの設定を自動的に取得します。対象となる認証情報とプラットフォームについては、[プラットフォームの可用性](#platform-availability)を参照してください。

> [!NOTE]
>
> サーバー管理設定は [Claude for Teams](https://claude.com/pricing?utm_source=claude_code\&utm_medium=docs\&utm_content=server_settings_teams#team-&-enterprise) および [Claude for Enterprise](https://anthropic.com/contact-sales?utm_source=claude_code\&utm_medium=docs\&utm_content=server_settings_enterprise) カスタマー向けに利用可能です。

## 要件

サーバー管理設定を使用するには、以下が必要です。

* Claude for Teams または Claude for Enterprise プラン
* Claude 組織の Owner または Primary Owner ロール（設定を表示および編集するため）
* `api.anthropic.com` へのネットワークアクセス

## サーバー管理設定とエンドポイント管理設定の選択

Claude Code は、一元的な構成のための 2 つのアプローチをサポートしています。サーバー管理設定は Anthropic のサーバーから構成を配信します。[エンドポイント管理設定](https://code.claude.com/docs/ja/managed-settings.md#delivery-mechanisms)は、ネイティブ OS ポリシー（macOS 管理設定、Windows レジストリ）または管理設定ファイルを通じてデバイスに直接配置されます。

| アプローチ | 最適な用途 | セキュリティモデル |
| :- | :- | :- |
| **サーバー管理設定** | MDM がない組織、または管理されていないデバイス上のユーザー | Claude Code が起動時に Anthropic のサーバーから取得し、セッション中に 1 時間ごとに更新する設定 |
| **[エンドポイント管理設定](https://code.claude.com/docs/ja/managed-settings.md#delivery-mechanisms)** | MDM またはエンドポイント管理がある組織 | MDM 構成プロファイル、レジストリポリシー、または管理設定ファイルを通じてデバイスに配置される設定 |

デバイスが MDM またはエンドポイント管理ソリューションに登録されている場合、エンドポイント管理設定はより強力なセキュリティ保証を提供します。これは、設定ファイルが OS レベルでユーザーの変更から保護される可能性があるためです。エンドポイント管理設定は Anthropic がホストする環境の[クラウドセッション](https://code.claude.com/docs/ja/model-config.md#surface-coverage)に到達しないため、開発者がクラウドセッションを実行する組織はサーバー管理設定も構成する必要があります。[自己ホスト環境](https://code.claude.com/docs/ja/self-hosted-environments)内のセッションも、ランナーイメージ内の管理設定ファイルを読み取ります。以下の[設定の優先順位](#settings-precedence)は、そのファイルが適用される場合を示しています。

## サーバー管理設定を構成する

**1. 管理コンソールを開く**

claude.ai コンソールで、[**Organization settings > Claude Code > Managed settings**](https://claude.ai/admin-settings/claude-code) に移動します。

Team または Enterprise の組織で、このページにアクセス権がないと表示された場合は、[Owner または Primary Owner](#access-control) に変更を依頼してください。

**2. 設定を定義する**

設定を JSON として追加します。OS レベルのポリシー配信に限定された設定を除き、[`settings.json` で使用できるすべての設定](https://code.claude.com/docs/ja/settings-reference#all-settings)がサポートされます。その短いリストについては[現在の制限事項](#current-limitations)を参照してください。これには、[フック](https://code.claude.com/docs/ja/hooks.md)、[環境変数](https://code.claude.com/docs/ja/env-vars.md)、および `allowManagedPermissionRulesOnly` などの[管理設定専用の設定](https://code.claude.com/docs/ja/managed-settings.md#managed-only-settings)が含まれます。

この例では、権限の拒否リストを強制し、ユーザーが権限をバイパスできないようにし、権限ルールを管理設定で定義されたものに制限します。`Bash(curl *)` ルールは [Claude が記述するとおりの](https://code.claude.com/docs/ja/permissions.md#bash-rule-limits) `curl` にマッチし、`/usr/bin/curl` や `sh -c 'curl …'` にはマッチしません。コマンドのテキストに依存しないネットワークの強制には、[`allowManagedDomainsOnly` を含む `sandbox` ブロック](https://code.claude.com/docs/ja/sandboxing#configure-the-sandbox-for-your-organization)を追加してください。

```json theme={null}
{
  "permissions": {
    "deny": [
      "Bash(curl *)",
      "Read(./.env)",
      "Read(./.env.*)",
      "Read(./secrets/**)"
    ],
    "disableBypassPermissionsMode": "disable"
  },
  "allowManagedPermissionRulesOnly": true
}
```

フックは `settings.json` と同じ形式を使用します。

この例では、組織全体でファイルが編集されるたびに監査スクリプトを実行します。

```json theme={null}
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [
          { "type": "command", "command": "/usr/local/bin/audit-edit.sh" }
        ]
      }
    ]
  }
}
```

フックはシェルコマンドを実行するため、対話型セッションのユーザーには、Claude Code がフックを適用する前に[セキュリティ承認ダイアログ](#security-approval-dialogs)が表示されます。

組織が信頼するリポジトリ、バケット、ドメインを [auto モード](https://code.claude.com/docs/ja/permission-modes.md#eliminate-prompts-with-auto-mode)の分類器が把握できるように設定するには、同じ方法で `autoMode` ブロックを配信します。`autoMode` のエントリが分類器のブロック対象にどのように影響するか、および `environment`、`allow`、`soft_deny`、`hard_deny` フィールドに関する重要な警告については、[auto モードを設定する](https://code.claude.com/docs/ja/auto-mode-config.md)を参照してください。

**3. 保存してデプロイする**

変更を保存します。Claude Code クライアントは、次回の起動時または 1 時間ごとのポーリングサイクルで更新された設定を受け取ります。

エディターは、公開されている Claude Code 設定の JSON スキーマに照らして JSON をチェックします。解析可能な JSON に問題が見つかった場合は、警告が表示され、保存ボタンのラベルが変わります。設定がすでに保存されている場合のラベルは **Update with errors**、まだ設定が保存されていない場合は **Add with errors** です。スキーマの警告は保存をブロックしないため、このボタンでも保存は行われます。

スキーマは[最新リリースに追従していない場合がある](https://code.claude.com/docs/ja/settings.md#edit-a-settings-file)ため、エディターが[設定リファレンス](https://code.claude.com/docs/ja/settings-reference.md#all-settings)に記載されているキーや値を警告することがあります。Claude Code は保存されたキーと値を受け取り、読み込む際に[独自の検証](#invalid-entries-in-delivered-settings)を実行します。

### 設定の配信を確認する

設定が適用されていることを確認するには、ユーザーに Claude Code を再起動してもらいます。[セキュリティ承認ダイアログ](#security-approval-dialogs)をトリガーする設定が含まれている場合、Claude Code が次に管理設定を取得したとき（次回の起動時、または実行中の対話型セッションでは 1 時間以内）に、ユーザーには管理設定の内容を説明するプロンプトが表示されます。また、ユーザーに `/permissions` を実行してもらい、有効な権限ルールを表示することで、管理された権限ルールが有効になっていることを確認することもできます。

特定のマシンでの取得結果を確認するには、ユーザーに `claude doctor` を実行してもらい、`Managed settings (remote)` の行を確認します。Claude Code v2.1.248 以降が必要です。この行には、次の 4 つの結果のいずれかが表示されます。

* 配信された設定が読み込まれた
* 組織にサーバー管理設定が構成されていない
* 取得に失敗した（原因と、キャッシュされたポリシーが引き続き適用されるかどうかが表示されます）
* Claude Code が取得をスキップした（理由が表示されます）。取得をスキップするプロバイダーと構成については、[プラットフォームの対応状況](#platform-availability)を参照してください

取得がまだ進行中の場合は、この行にその旨が表示されます。

実行中のセッションでは、取得に失敗した後、および取得スキップの原因の一部（ユーザーのシェルでエクスポートされたサードパーティプロバイダーの変数やカスタムの `ANTHROPIC_BASE_URL` など）について、`/status` に同じ行が表示されます。

### アクセス制御

次のロールがサーバー管理設定を管理できます。

* **Primary Owner**
* **Owner**

設定の変更は組織内のすべてのユーザーに適用されるため、アクセスは信頼できる担当者に限定してください。

### 管理設定専用の設定

ほとんどの[設定キー](https://code.claude.com/docs/ja/settings-reference.md#all-settings)はどのスコープでも機能します。一部のキーは管理設定からのみ読み取られ、ユーザーまたはプロジェクトの設定ファイルに配置しても効果はありません。権限とプラグインの制御については[管理設定専用の設定](https://code.claude.com/docs/ja/managed-settings.md#managed-only-settings)を参照するか、完全な一覧については[すべての設定](https://code.claude.com/docs/ja/settings-reference.md#all-settings)インデックスの Scope 列を確認してください。

### 現在の制限事項

サーバー管理設定には次の制限があります。

* 設定は組織内のすべてのユーザーに一律に適用されます。グループごとの構成はまだサポートされていません。
* [`managed-mcp.json`](https://code.claude.com/docs/ja/managed-mcp) ファイルをサーバー管理設定で配布することはできません。代わりに、`allowedMcpServers` および `deniedMcpServers` ポリシーキーをそこで配信してください。Claude Code v2.1.259 以降では、[`managedMcpServers`](https://code.claude.com/docs/ja/managed-mcp#provide-servers-through-managed-settings) でリモートサーバーを提供することもできます。これは `http` および `sse` サーバーのみを受け付け、ファイルのように排他的な制御は行いません。

  Claude Code は、[システムパス](https://code.claude.com/docs/ja/managed-mcp.md#exclusive-control-with-managed-mcp-json)にデプロイされた `managed-mcp.json` を管理設定の階層とは別に読み取るため、サーバー管理設定が有効な場合でもこのファイルは引き続き適用されます。
* `policyHelper` や `wslInheritsWindowsSettings` など、OS レベルのポリシーソースに限定された設定は反映されません。代わりに MDM またはシステムの `managed-settings.json` ファイルでデプロイしてください。その方法でデプロイされた `policyHelper` は、そのソースが[管理階層内の優先順位](https://code.claude.com/docs/ja/managed-settings.md#precedence-within-the-managed-tier)に従って選択されたものである場合にのみ実行されます。

## 設定の配信

### 設定の優先順位

サーバー管理設定と[エンドポイント管理設定](https://code.claude.com/docs/ja/managed-settings.md#delivery-mechanisms)は、どちらも Claude Code の[設定の階層](https://code.claude.com/docs/ja/settings.md#settings-precedence)の最上位に位置します。ここで設定したキーは、[管理設定の優先順位の例外](https://code.claude.com/docs/ja/settings.md#exceptions-to-managed-settings-precedence)を除き、ユーザー自身の設定ファイルや `--settings` の値にある同じキーよりも優先されます。

管理層の中では、Claude Code はデフォルトで、少なくとも 1 つのポリシーキーを配信する最初のソースを使用します。確認する順序はサーバー管理設定が先で、次にエンドポイント管理設定です。ただし、[次に説明する例外キー](#per-key-exceptions-across-managed-sources)は除きます。完全な順位付け、制御キーに対する除外規定、すべてのソースを適用するオプトインについては、[Claude Code が管理ソースを組み合わせる方法](https://code.claude.com/docs/ja/managed-settings.md#precedence-within-the-managed-tier)を参照してください。

選択されたソースが MDM ポリシーまたは管理設定ファイルで、その [`policyHelper`](https://code.claude.com/docs/ja/settings-reference#policyhelper) が管理設定を提供する場合、ヘルパーの出力がそのソースに置き換わり、その実行における唯一の管理設定になります。サーバー管理設定がポリシーキーを配信している間、Claude Code は MDM やファイルベースの設定で構成された `policyHelper` を参照しません。

後続のフェッチでサーバー管理設定が削除されていることが判明した場合、Claude Code は次回の起動時ではなく、すぐにそのヘルパーを実行します。その実行が失敗した場合の動作については、[`policyHelper`](https://code.claude.com/docs/ja/settings-reference#policyhelper) の項目を参照してください。

エンドポイント管理の plist やレジストリのポリシーにフォールバックする意図で管理コンソールからサーバー管理設定をクリアする場合、[キャッシュされた設定](#fetch-and-caching-behavior)は次回のフェッチが成功するまでクライアントマシン上に残り、`model` のような[次回の起動時にのみ適用される](#fetch-and-caching-behavior)キーは、各クライアントが再起動するまで有効なままであることに注意してください。どの管理ソースが有効かを確認するには `/status` を実行します。

### 管理ソース間でのキーごとの例外

以下のキーは、マージしないというルールの例外です。

* **ソース横断のロックキー**: サンドボックスの許可リストのロックなど、[管理設定のページに記載されている](https://code.claude.com/docs/ja/managed-settings.md#precedence-within-the-managed-tier)少数のキーです。管理者が制御するいずれかの管理ソースがこれらを設定していれば、Claude Code はそれを尊重します。ユーザーが書き込み可能な HKCU レジストリ層は対象外です。

  [`policyHelper`](https://code.claude.com/docs/ja/settings-reference#policyhelper) が管理設定を提供する場合、これらのチェックが読み取るソースはその出力のみです。ただし [`forceRemoteSettingsRefresh`](https://code.claude.com/docs/ja/settings-reference#forceremotesettingsrefresh) は例外で、Claude Code は起動時に管理者ソースから直接読み取ります。
* **`env` ブロック**: 後述するテレメトリユニットと、認証情報キーと組み合わされたルーティング変数を除き、管理者が制御するソース間でキーごとにマージされます。各環境変数について、それを定義している最も優先度の高いソースが優先され、上位のソースが未設定のままにした変数は下位の管理者ソースが補完します。そのため、サーバー管理設定がその変数を未設定のままにしている場合、またはその変数のキャッシュされたサーバー値が[サーバーによる確認待ちで保留されている](#fetch-and-caching-behavior)間は、エンドポイント管理の `env` エントリが適用されます。Claude Code v2.1.223 以降が必要です。v2.1.223 より前では、Claude Code は選択されたソースの `env` ブロック全体のみを適用します。
  * **テレメトリユニット**: `OTEL_EXPORTER_OTLP_*` エクスポーターキー、`OTEL_LOG_*` コンテンツキャプチャのトグル、`OTEL_LOGS_EXPORTER`、およびベータトレーシング変数の `ENABLE_BETA_TRACING_DETAILED` と `BETA_TRACING_ENDPOINT` は、いずれかを設定している最上位のソースに 1 つのユニットとして従います。`otelHeadersHelper` 認証情報キーを配信するソースもこのユニットを確保しますが、これらの変数が反映されるのは、そのソースが選択されたソースである場合のみです。選択されていないもののこのキーを配信するソースは、これらの変数を一切提供せず、それでも下位のソースがこれらを補完することを妨げます。いずれの場合も、あるソースのエクスポーターエンドポイントが別のソースの認証情報と組み合わされることはありません。
  * **認証情報と組み合わされたルーティング**: `apiKeyHelper` や `otelHeadersHelper` など、選択されたソースでのみ有効な認証情報キーとルーティング変数を組み合わせているソースは、そのスロットで優先された場合にのみ、それらのルーティング変数を提供します。
* **`allowedProviders`**: マシン上で設定されたリストとサーバー管理のリストは、[その項目のスコープに関する注記](https://code.claude.com/docs/ja/settings-reference.md#allowedproviders)に記載されているとおりに組み合わされます。Claude Code v2.1.285 以降が必要です
* **ゲートウェイのサインインキー**: Claude Code は、[`forceLoginGatewayUrl`](https://code.claude.com/docs/ja/settings-reference#forcelogingatewayurl)、[`gatewayInternalNetworks`](https://code.claude.com/docs/ja/settings-reference#gatewayinternalnetworks)、または [`forceLoginMethod`](https://code.claude.com/docs/ja/settings-reference#forceloginmethod) の `"gateway"` 値をサーバー管理設定から読み取ることはありません。そのため、サーバー管理設定にある値は適用されず、MDM ポリシーや管理設定ファイルで設定された値を隠すこともありません。マシン上のどの管理者ソースがこれらを提供するかについては、[`managedSourcesBehavior` の項目](https://code.claude.com/docs/ja/settings-reference#managedsourcesbehavior)を参照してください。

### フェッチとキャッシュの動作

Claude Code は起動時に Anthropic のサーバーから設定をフェッチし、アクティブなセッション中は 1 時間ごとに更新をポーリングします。

[Claude apps ゲートウェイ](#platform-availability)経由でサインインしたクライアントは、ゲートウェイから設定をフェッチし、セッション開始前にそのフェッチを待機するため、以下のリストのフェッチは適用されません。そのフェッチが失敗した場合の動作については、[フェイルクローズ起動を強制する](#enforce-fail-closed-startup)を参照してください。

**キャッシュされた設定がない初回起動時:**

* 初回実行時や `/logout` の後など、開発者が起動時にサインインする場合、Claude Code はセッションを開く前に最大 5 秒間フェッチを待機します。ポリシーが時間内に届いた場合、Claude Code は最初の画面からそれを適用し、その画面に [`companyAnnouncements`](https://code.claude.com/docs/ja/settings-reference#companyannouncements) を表示します。ペイロードが[セキュリティ承認](#security-approval-dialogs)を必要とする場合、Claude Code は待機を終了し、開発者が承認した時点でペイロードを適用します
* その他の起動時、およびこの 5 秒間の待機がタイムアウトした場合、Claude Code はフェッチを続行したままセッションを開くため、設定が読み込まれて制限が有効になるまでに短い時間が生じます
* フェッチが失敗した場合、Claude Code はサーバー管理設定なしで続行し、対話型セッションではリモートポリシーが適用されていないことを警告します。エンドポイント管理設定は引き続き適用されます。管理ソースが [`forceRemoteSettingsRefresh`](#enforce-fail-closed-startup) を設定している場合、Claude Code は代わりに終了します

**キャッシュされた設定がある 2 回目以降の起動時:**

* キャッシュされた設定は起動時に即座に適用されます。ただし、キャッシュされた `modelPricing` と `managedMcpServers` の値、サーバーがペイロードを確認するまで Claude Code が保留する環境変数、キャッシュされたプラグインリストによる[組み込みガード](https://code.claude.com/docs/ja/plugins/mods/admin.md#know-what-happens-by-default)の削除、位置の変更、または無効化、そしてエンドポイント管理ソースが独自にプラグインを列挙または有効化しているマシンでは、キャッシュされたリストのみが有効化しているプラグインの[組織としての扱い](https://code.claude.com/docs/ja/plugins/mods/admin.md#install-your-organizations-mods)は除きます
* キャッシュされた [`modelPricing`](https://code.claude.com/docs/ja/settings-reference#modelpricing) は、セッションのフェッチがペイロードを確認するまで適用されません。それまでの間、開発者が `/usage` やステータスラインで目にするコストの数値は定価になります
* キャッシュされた [`managedMcpServers`](https://code.claude.com/docs/ja/settings-reference#managedmcpservers) ブロックは、セッションのフェッチがペイロードを確認するまで適用されません。Claude Code は MCP サーバーに接続する前に、そのフェッチを最大 30 秒間待機します。フェッチが失敗するかタイムアウトした場合、セッションは組織のサーバーなしで開始され、`/status` にその旨が表示されます。サーバーは後続のフェッチで確認された時点で接続されます。初回起動時を含む動作の詳細については、[提供されたサーバーが接続されるタイミング](https://code.claude.com/docs/ja/managed-mcp.md#when-provided-servers-connect)を参照してください。Claude Code v2.1.259 以降が必要です
* キャッシュされた [`prependPlugins`](https://code.claude.com/docs/ja/settings-reference#prependplugins)、[`appendPlugins`](https://code.claude.com/docs/ja/settings-reference#appendplugins)、または [`enabledPlugins`](https://code.claude.com/docs/ja/settings-reference#enabledplugins) の値は、セッションのフェッチがペイロードを確認するまで、組み込みガードを削除したり、その位置を変更したり、オフにしたりすることはできません
* [エンドポイント管理ソース](https://code.claude.com/docs/ja/managed-settings.md#choose-a-delivery-mechanism)が独自にプラグインを列挙または有効化しているマシンでは、キャッシュされたリストのみが有効化しているプラグインは、フェッチがペイロードを確認するまで、組織のものではなく[ユーザーのもの](https://code.claude.com/docs/ja/plugins/mods/admin.md#install-your-organizations-mods)として扱われます
* Claude Code はバックグラウンドで最新の設定をフェッチします
* キャッシュされた設定はネットワーク障害が発生しても維持されます。起動時のフェッチが失敗した場合、Claude Code は対話型セッションで、キャッシュされたポリシーが有効であることを警告します
* フェッチが成功するまで、起動時に保留された値は保留されたままです

Claude Code は、サーバーがセッションのペイロードを確認するまで、キャッシュされた `env` ブロック内のいくつかのカテゴリの変数を保留します。これにより、キャッシュされたプロキシ、認証局、エンドポイント、または認証情報の値によって、ペイロードを確認する設定フェッチがリダイレクト、傍受、または再認証されることを防ぎます。この強化策はサーバーからフェッチされた設定のキャッシュにのみ適用されます。MDM や `managed-settings.json` を通じてデプロイされた[エンドポイント管理設定](https://code.claude.com/docs/ja/managed-settings.md#delivery-mechanisms)は影響を受けません。保留されるカテゴリには以下が含まれます。

* `HTTPS_PROXY`、`NODE_EXTRA_CA_CERTS`、mTLS クライアント証明書の変数 `CLAUDE_CODE_CLIENT_CERT` と `CLAUDE_CODE_CLIENT_KEY` などのプロキシおよび TLS の設定
* `ANTHROPIC_BASE_URL`、`CLAUDE_CODE_USE_BEDROCK` や `CLAUDE_CODE_USE_VERTEX` などのプロバイダー選択変数、`ANTHROPIC_BEDROCK_BASE_URL` などのプロバイダーエンドポイント URL を含む、API ルーティングとプロバイダー選択
* `ANTHROPIC_API_KEY`、`ANTHROPIC_AUTH_TOKEN`、`CLAUDE_CODE_OAUTH_TOKEN` などの認証情報
* 設定ディレクトリのセレクターである `CLAUDE_CONFIG_DIR`
* Claude Code v2.1.223 以降における、認証情報ソースおよび設定ディレクトリのセレクター: `ANTHROPIC_FEDERATION_RULE_ID` や `ANTHROPIC_IDENTITY_TOKEN` などの Workload Identity Federation 変数、プロファイルおよび設定ディレクトリのセレクターである `ANTHROPIC_PROFILE` と `ANTHROPIC_CONFIG_DIR`、オペレーティングシステムのディレクトリ変数である `HOME`、`XDG_CONFIG_HOME`、`APPDATA`、`USERPROFILE`

Claude Code は Workload Identity Federation 変数と `ANTHROPIC_PROFILE` および `ANTHROPIC_CONFIG_DIR` セレクターを起動時にのみ読み取るため、これらに対してサーバーから配信された値は、フェッチが成功した後であってもセッションの認証情報ソースを切り替えません。Claude Code v2.1.223 以降でこれらのセレクターを配信するには、MDM や `managed-settings.json` などの[エンドポイント管理設定](https://code.claude.com/docs/ja/managed-settings.md#delivery-mechanisms)を使用してください。`CLAUDE_CONFIG_DIR` とオペレーティングシステムのディレクトリ変数については、保留そのものが保護となります。キャッシュされた値は、サーバーがペイロードを確認するまで環境に入りません。

キャッシュされた `env` ブロック内のその他のキーはすべて起動時に適用されます。サーバーがペイロードを確認し、ペイロードが[セキュリティ承認](#security-approval-dialogs)を必要とする場合はユーザーが承認すると、保留されていた変数がセッションの残りの期間に適用されます。

組織が `api.anthropic.com` に到達するためにプロキシを必要とする場合、保留はサーバーから配信された `env` ブロック自体にのみ影響します。MDM や `managed-settings.json` を通じた[エンドポイント管理](https://code.claude.com/docs/ja/managed-settings.md#delivery-mechanisms)の `env` ブロック、シェル環境、または[ユーザー設定](https://code.claude.com/docs/ja/settings.md#where-settings-live)で設定されたプロキシは、設定フェッチに反映されます。エンドポイント管理のソースには Claude Code v2.1.223 以降が必要です。キャッシュされたサーバー管理のプロキシ値はフェッチで確認されるまで保留されるため、エンドポイント管理の値がキーごとに補完され、フェッチ自体に反映されます。v2.1.223 より前では、キャッシュされたサーバーペイロードと並行してプロキシが適用されるよう、シェル環境またはユーザー設定を使用してください。初回起動時にはキャッシュがないため、最初のフェッチには引き続きエンドポイント管理のソース、シェル環境、またはユーザー設定が必要です。

Claude Code は、ほとんどの設定の更新を再起動なしで実行中のセッションに適用します。OpenTelemetry エクスポーターの設定、`model` キー、`env` ブロックからの変数の削除など、一部の更新は次回の起動時にのみ適用されます。

### 配信された設定内の無効なエントリ

ペイロードの一部がスキーマ検証に失敗した場合、Claude Code は検証エラーを表示し、残りの有効な設定をすべて適用します。何が破棄され、どのキーがより厳格な値にフォールバックするかについては、[管理設定内の無効なエントリ](https://code.claude.com/docs/ja/managed-settings.md#invalid-entries-in-managed-settings)を参照してください。Claude Code v2.1.169 以降が必要です。

サーバー管理の配信では、以下の動作が追加されます。

* `~/.claude/remote-settings.json` のキャッシュで実行される起動では、無効なエントリは、そのキャッシュを書き込んだフェッチと同じように扱われます。
  * 検証に失敗したエントリは破棄されたままです。
  * [フェイルクローズするキー](https://code.claude.com/docs/ja/managed-settings.md#keys-that-fail-closed)は、より厳格な値を維持します。
  * 無効な `cleanupPeriodDays` または `desktopSessionCleanupPeriodDays` の値はキャッシュされたコピーに残り、適用されることはありません。
* 次の 3 つの条件がすべて当てはまる場合、Claude Code はペイロードから何も適用せず、キャッシュも変更しません。

  * ペイロード内のすべての設定が検証に失敗している。
  * いずれの設定もより厳格な値にフォールバックしない。
  * ペイロードに、上記 2 つの保持期間キー以外のキーが含まれている。

  この場合、起動時の通知、`/status`、`claude doctor` は、原因 `no setting in the server response could be applied as written` とともに[読み込みの失敗](https://code.claude.com/docs/ja/errors.md#remote-managed-settings-failed-to-load)を報告し、その項目にはセッションがどのポリシーで実行されるかが記載されます。[フェイルクローズ起動を強制する](#enforce-fail-closed-startup)クライアントは、代わりに起動時に終了します。
* [セキュリティ承認ダイアログ](#security-approval-dialogs)は、無効なエントリを除去した後のペイロードを評価するため、除去された無効なエントリが承認を求めて表示されたり、実行されたりすることはありません。

配信の問題をデバッグするには、`claude --debug-file <path>` を実行し、ログで `Remote settings` を検索します。組織に展開する前に、テストマシン上で `claude doctor` を使用してペイロードの変更を検証してください。

### フェイルクローズ起動を強制する

デフォルトでは、起動時にリモート設定のフェッチが失敗した場合、CLI は最後に成功したフェッチでキャッシュされた設定で続行します。ただし、フェッチが成功するまで [Claude Code が保留する値](#fetch-and-caching-behavior)は除きます。一度もフェッチしたことがないマシンでは、CLI はサーバー管理設定なしで続行し、デバイス上の[エンドポイント管理設定](https://code.claude.com/docs/ja/managed-settings.md#delivery-mechanisms)は引き続き適用します。

クライアントがキャッシュされたサーバー管理設定で、またはサーバー管理設定がない状態で起動しないようにするには、管理設定で `forceRemoteSettingsRefresh: true` を設定します。

[Claude apps ゲートウェイ](#platform-availability)経由でサインインしたクライアントは、この設定の有無にかかわらず起動時のフェッチを待機し、フェッチの失敗を次のように処理します。

* ユーザーが操作している対話型の起動に対してゲートウェイが `401` を返し、この設定がオフの場合、ゲートウェイはそのサインインを終了しています。Claude Code は [`Cloud gateway session expired — run /login to reconnect.`](https://code.claude.com/docs/ja/errors#cloud-gateway-session-expired) を表示し、ユーザーが `/login` を実行するまで、ゲートウェイからサインアウトした状態でセッションを開きます。
* その他の理由でフェッチが失敗した場合、または `claude auth` サブコマンドを除くその他の種類の起動では、クライアントはエラーで終了します。

サーバー管理設定をフェッチするセッションでこの設定が有効な場合、CLI はリモート設定が新たにフェッチされるまで起動時にブロックします。フェッチが失敗した場合、CLI はポリシーなしで続行するのではなく終了します。この設定は自己永続的です。サーバーから一度配信されると、ローカルにもキャッシュされるため、以降の起動では、新しいセッションで最初のフェッチが成功する前であっても同じ動作が強制されます。[サーバー管理設定をフェッチしない](#platform-availability)セッションは、待機せずに開始されます。

これを有効にするには、管理設定の構成にキーを追加します。

```json theme={null}
{
  "forceRemoteSettingsRefresh": true
}
```

サーバーペイロードが届く前の初回起動時にフェイルクローズ動作を強制するために、このキーを[エンドポイント管理](https://code.claude.com/docs/ja/managed-settings.md#delivery-mechanisms)の MDM プロファイルやシステムの `managed-settings.json` ファイルで設定することもできます。このフラグは上記の[優先順位のルール](#settings-precedence)の例外です。キャッシュされたサーバー管理ペイロードが存在する場合でも、管理者が制御するいずれかの管理ソースがこれを設定していれば Claude Code はそれを尊重するため、サーバー管理設定が存在するときに MDM から配信された値が無視されることはありません。

[`policyHelper`](https://code.claude.com/docs/ja/settings-reference#policyhelper) が管理設定を提供する場合、Claude Code が起動後に読み取るキーについては、その出力が他のすべての管理ソースに置き換わります。Claude Code がこのキーを読み取るソースについては、[その設定項目](https://code.claude.com/docs/ja/settings-reference.md#forceremotesettingsrefresh)を参照してください。Claude Code がどのソースからヘルパーを読み取り、いつ実行するかについては、`policyHelper` の項目を参照してください。

設定フェッチでは `Cache-Control: no-cache` ヘッダーも送信されるため、中間の HTTP プロキシが古いレスポンスを返すことはありません。

この設定を有効にする前に、ネットワークポリシーで `api.anthropic.com` への接続が許可されていることを確認してください。このエンドポイントに到達できない場合、CLI は起動時に終了し、ユーザーは Claude Code を起動できなくなります。

`claude auth login` などの `claude auth` サブコマンドは、このチェックおよびゲートウェイの起動時終了の対象外です。そのため、期限切れの認証情報が設定フェッチの失敗の原因である場合でも、ユーザーは再認証できます。

### セキュリティ承認ダイアログ

セキュリティリスクをもたらす可能性のある特定の設定は、Claude Code が対話型セッションでそれらを適用する前に、ユーザーの明示的な承認を必要とします。

* **シェルコマンドの設定**: `apiKeyHelper`、`statusLine`、`otelHeadersHelper` など、シェルコマンドを実行する設定
* **サンドボックスのバイナリ設定**: `sandbox.bwrapPath`、`sandbox.socatPath`、`sandbox.ripgrep`。これらの各設定は実行ファイルを指しており、Claude Code はその実行ファイルを実行します
* **サンドボックスのネットワークおよび分離の設定**: サンドボックスのプロキシがトラフィックを読み取る、経路を変更する、または認証することを可能にする、あるいはサンドボックスの分離を弱める[サンドボックス](https://code.claude.com/docs/ja/sandboxing.md)設定です: `sandbox.network.tlsTerminate`、`sandbox.network.httpProxyPort`、`sandbox.network.socksProxyPort`、`sandbox.credentials`、`sandbox.allowAppleEvents`、`sandbox.allowNestedUserNamespaces`、`sandbox.enableWeakerNestedSandbox`、`sandbox.enableWeakerNetworkIsolation`、`sandbox.filesystem.disabled`、`sandbox.network.allowAllUnixSockets`、`sandbox.network.allowUnixSockets`、`sandbox.network.allowMachLookup`。`deny` ルールのみを含む `sandbox.credentials` ブロックは、プロキシに認証情報を与えずにサンドボックスを制限するだけなので、承認は不要です。v2.1.251 より前では、Claude Code はこれらの設定を承認なしで適用していました
* **カスタム環境変数**: プロキシやベース URL の変数など、ユーザーの承認を必要とする配信された `env` 変数。[環境変数と承認ダイアログ](#environment-variables-and-the-approval-dialog)を参照してください
* **フックの設定**: すべてのフック定義

これらの設定が存在する場合、ユーザーには何が設定されるかを説明するセキュリティダイアログが表示されます。続行するにはユーザーが承認する必要があります。ユーザーが設定を拒否した場合、Claude Code は終了します。

[`claudeMd`](https://code.claude.com/docs/ja/settings-reference#claudemd) キーを通じて配信される管理された CLAUDE.md は、Claude Code が実行するコマンドではなく Claude に対する指示テキストであるため、承認は不要です。Claude がそれらの指示に従う際に使用するツールについては、Claude Code は引き続き[権限](https://code.claude.com/docs/ja/permissions.md)をチェックします。v2.1.260 より前では、`claudeMd` の値も承認が必要でした。

#### 承認の記憶

Claude Code は承認を設定ディレクトリに記録します。[`CLAUDE_CONFIG_DIR`](https://code.claude.com/docs/ja/env-vars) を設定していない場合、このディレクトリは `~/.claude` です。何が記録されるかは、設定フェッチが使用する認証情報によって異なります。

* **`/login` または `claude auth login` で保存された claude.ai ログイン、または[キーレスの Console サインイン](https://code.claude.com/docs/ja/authentication.md#sign-in-without-an-api-key)**: 組織ごとに 1 つの承認で、最後に承認したアカウントが保持します。
* **[Claude apps ゲートウェイ](https://code.claude.com/docs/ja/claude-apps-gateway)のサインイン**: ゲートウェイごとに 1 つの承認です。

  同じゲートウェイからサインアウトして再度サインインした場合、承認が必要な設定が変更されていない間は、Claude Code はダイアログを再表示しません。Claude Code は、それらの設定が変更されたとき、別のゲートウェイにサインインしたとき、同じゲートウェイの新しい証明書を受け入れたときに、ダイアログを再表示します。

  プレーン HTTP で到達するループバックの開発用ゲートウェイについては、Claude Code は承認を保存しないため、サインインするたびにダイアログが再表示されます。
* **その他の認証情報**（API キーや `CLAUDE_CODE_OAUTH_TOKEN` など）: 配信された設定に対する 1 つの承認で、その設定ディレクトリ内の設定のキャッシュコピーとともに保持されます。Claude Code は、承認が必要な設定が変更されたとき、および `/logout` または `claude auth logout` を実行した後にダイアログを再表示します。これらのコマンドはいずれもキャッシュコピーを削除します。

`sandbox.credentials` または `sandbox.network.tlsTerminate` の承認は、同じ配信された設定内の [`sandbox.network.allowedDomains`](https://code.claude.com/docs/ja/settings-reference#sandbox-network-alloweddomains) エントリも対象とします。どちらの設定もその許可リストに作用するためです。`sandbox.network.allowedDomains` 自体は承認を必要としませんが、管理者がこれらのエントリのいずれかを追加または削除すると、ダイアログが再表示されます。

保存された claude.ai ログインの場合:

* サインアウトして再度サインインした場合、または別の組織に切り替えて後で戻った場合、それらの設定が変更されていない間は、Claude Code はダイアログを再表示しません。ただし、その間に同じ設定ディレクトリで別のアカウントがその組織の設定を承認した場合は除きます。
* 別のアカウントで同じ組織にサインインした場合、設定が変更されていなくても Claude Code はダイアログを再表示します。そのアカウントの承認が以前の承認に置き換わるため、元のアカウントに戻すと、Claude Code はもう一度ダイアログを表示します。

Claude Code は常にダイアログを表示できるとは限りません。以下の各ケースでは、ダイアログを表示できない場合にどの設定が適用されるか、および次にいつダイアログが表示されるかを説明します。

* **ダイアログを表示できない対話型セッション**: Claude Code は配信された設定を適用せず、最後に承認された設定を維持します。ダイアログは、表示可能な次のセッションで表示されます。
* **`claude install` または `claude update`**: Claude Code はどちらのコマンドの実行中もダイアログを表示しません。コマンドは最後に承認された設定で実行され、ダイアログは次の対話型セッションで表示されます。[`forceRemoteSettingsRefresh`](#enforce-fail-closed-startup) が設定されている場合や [Claude apps ゲートウェイ](https://code.claude.com/docs/ja/claude-apps-gateway)のデプロイなど、Claude Code が起動時に設定フェッチを待機する場合は、代わりにコマンドの実行中にダイアログを表示し、パイプから実行したインストールは失敗します。[インストール中の `Raw mode is not supported`](https://code.claude.com/docs/ja/troubleshoot-install#raw-mode-is-not-supported-during-install) を参照してください。v2.1.246 より前では、Claude Code はこれらのコマンドの実行中にもダイアログの表示を試みていました。
* **ターミナルに出力するがキーボードから読み取れない `claude plugin` コマンド**: Claude Code が起動時に設定フェッチを待機しない場合、コマンドは配信された設定を適用しません。[キャッシュされた設定](#fetch-and-caching-behavior)がない場合、プラグインやマーケットプレイスを変更するコマンドは[エラーで停止します](https://code.claude.com/docs/ja/errors.md#managed-settings-need-your-approval)。キャッシュされた設定がある場合は、最後に承認された設定で実行されます。ダイアログは、次にターミナルで `claude` を実行したときに表示されます。

  コマンドがキーボードから読み取れないのは、入力をパイプまたはリダイレクトしていて、かつ macOS と Linux では `/dev/tty` も開けない場合です。出力もパイプまたはリダイレクトしている場合、その実行は代わりに非対話型となり、配信された設定はその実行に限り適用されます。
* **ユーザーが応答する前にエラーによってダイアログが閉じられた場合**: Claude Code は配信された設定を適用せず、最後に承認された設定を維持します。ダイアログは、表示可能な次のセッションで再表示されます。
* **非対話型の実行**（`claude -p`、Agent SDK セッション、VS Code 拡張機能のチャットパネルやデスクトップアプリの Code タブでのセッションなど）: Claude Code はダイアログを表示できないため、配信された設定が承認を必要とする場合は、その実行に限りそれらを適用します。承認済みとして記録したり、[ローカルキャッシュ](#fetch-and-caching-behavior)に書き込んだりはしないため、次の対話型セッションでダイアログが表示されます。ユーザーが対話型セッションで承認するまで、非対話型の実行はそれぞれ起動時に設定を再度フェッチします。v2.1.207 より前では、非対話型の実行が設定を承認済みとして保存していたため、以降の対話型セッションでそれらの設定に対するダイアログが表示されることはありませんでした。

#### 環境変数と承認ダイアログ

Claude Code は、配信された一部の `env` 変数を、ユーザーに承認ダイアログを表示せずに適用します。これには以下が含まれます。

* 機能およびコマンドのトグル
* `ANTHROPIC_MODEL`、`DISABLE_PROMPT_CACHING`、`CLAUDE_CODE_EFFORT_LEVEL` などのモデル選択と動作の設定
* `DISABLE_AUTO_COMPACT` などのコンテキストウィンドウとコンテキスト圧縮の設定（ただし `CLAUDE_CODE_DISABLE_1M_CONTEXT` は除く）
* ターミナル UI とアクセシビリティのオプション
* 数値の上限、予算、タイムアウト

その他の配信された変数は、有効になる前にユーザーの承認を必要とする場合があります。たとえば、対話型セッションでは、以下の変数は空でない値であれば常に承認が必要です。

* プロキシまたはベース URL の変数
* `OTEL_EXPORTER_OTLP_ENDPOINT`
* `CLAUDE_CODE_DISABLE_1M_CONTEXT`

配信された変数が承認を必要とする場合、ダイアログにその変数名が表示されるため、ユーザーはポリシーが何を設定しようとしているかを正確に確認できます。v2.1.218 より前では、Claude Code がユーザーに確認せずに適用する変数はより少なかったため、`DISABLE_AUTO_COMPACT` などの設定は空でない値であればダイアログを表示していました。

Claude Code は、4 つのプライバシートグル `CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC`、`DISABLE_ERROR_REPORTING`、`DISABLE_TELEMETRY`、`DO_NOT_TRACK` について、承認が必要かどうかを変数名ではなく配信された値によって判断します。`1` や `true` などの真値は、トラッキング、レポート、その他の必須ではないトラフィックをオフにするだけなので、Claude Code はユーザーに確認せずに適用します。その他の空でない値の場合、Claude Code はダイアログを表示します。v2.1.218 より前では、`DO_NOT_TRACK` を除くすべてが値にかかわらず承認なしで適用され、`DO_NOT_TRACK` は空でない値であればダイアログを表示していました。

Claude Code は、[`API_FORCE_IDLE_TIMEOUT`](https://code.claude.com/docs/ja/env-vars) についても、承認が必要かどうかを配信された値によって判断します。真値は[ボディのアイドルタイムアウト](https://code.claude.com/docs/ja/network-config.md#streaming-idle-watchdogs)をオンにするだけなので、Claude Code はユーザーに確認せずに適用します。その他の空でない値の場合、Claude Code はダイアログを表示します。v2.1.248 より前では、空でない値であればダイアログが表示されていました。

[`ANTHROPIC_CUSTOM_HEADERS`](https://code.claude.com/docs/ja/env-vars#variables) が承認を必要とするかどうかも、配信された値によって異なります。`Accept-Language` など、リクエストにタグを付けるだけのヘッダーはダイアログなしで適用されます。`Authorization`、`X-Api-Key`、`Host`、`anthropic-beta`、`X-Amzn-Bedrock-*` ヘッダーなど、認証情報、組織またはテナントのセレクター、ルーティングまたはホストの上書き、API の動作に関わるヘッダーを指定する行は承認が必要です。名前が有効な HTTP ヘッダートークンでない行や、値に HTTP ヘッダーが含むことのできない文字が含まれている行も承認が必要です。このチェックはヘッダー名に含まれる単語と照合するため、`client` と `version` を含む `X-Client-Version` も承認が必要です。v2.1.251 より前では、`ANTHROPIC_CUSTOM_HEADERS` の値はすべて承認なしで適用されていました。

[`ENABLE_BETA_TRACING_DETAILED`](https://code.claude.com/docs/ja/env-vars#variables) または [`OTEL_LOG_RAW_API_BODIES`](https://code.claude.com/docs/ja/env-vars#variables) に対する `0` や `false` などの偽値は、詳細なトレーシングや API の生のボディのキャプチャをオフにするだけなので、ダイアログなしで適用されます。いずれかの変数に対するその他の空でない値は承認が必要です。

## プラットフォームの可用性

サーバー管理設定は `api.anthropic.com` への直接接続が必要です。配信にはセッションが以下のいずれかの認証情報で認証される必要があります。

* Team または Enterprise OAuth ログイン
* `CLAUDE_CODE_OAUTH_TOKEN` を通じて提供される OAuth トークン
* 直接設定された API キー
* Anthropic プロファイルの `user_oauth`（[Anthropic プロファイル](https://code.claude.com/docs/ja/authentication.md#anthropic-profiles-and-federation-credentials)、ただしプロファイルが Anthropic API 以外の `base_url` を設定していない場合）。Claude Code v2.1.257 以降が必要です。

[`apiKeyHelper`](https://code.claude.com/docs/ja/settings-reference#apikeyhelper) スクリプトによって返されたキーも [Workload Identity Federation](https://platform.claude.com/docs/en/manage-claude/workload-identity-federation) 認証情報も設定フェッチをトリガーしません。

セッションは、認証に使用する認証情報を所有する組織の管理設定を受け取ります。[Claude Console](https://platform.claude.com) の API キーは、そのキーが作成された Console 組織に属しており、これは claude.ai の Team または Enterprise 組織とは別の組織です。そのため、claude.ai の Admin Settings で構成した設定は、会社の Console API キーを使用する CI ジョブなど、そのキーで認証するセッションには届きません。そのジョブに設定を適用するには、以下のいずれかのオプションを使用します。OAuth トークンのオプションは、[`--bare`](https://code.claude.com/docs/ja/headless#start-faster-with-bare-mode) で実行されるジョブには適用されません。bare モードは `CLAUDE_CODE_OAUTH_TOKEN` を読み取らないためです。

* **OAuth トークン**：[`claude setup-token`](https://code.claude.com/docs/ja/authentication#generate-a-long-lived-token) でトークンを生成し、Team または Enterprise 組織に対して認可したうえで、ジョブの環境で `CLAUDE_CODE_OAUTH_TOKEN` として設定します。`ANTHROPIC_API_KEY` など、トークンより[優先される](https://code.claude.com/docs/ja/authentication.md#authentication-precedence)認証情報はその環境から削除してください。
* **エンドポイント管理設定**：ジョブを実行するマシンに[管理設定ファイル](https://code.claude.com/docs/ja/managed-settings.md#delivery-mechanisms)をデプロイします。

Claude Desktop アプリの [Cowork](https://claude.com/docs/cowork/overview) セッションでは、ユーザーが Team または Enterprise アカウントでサインインしている場合でも、Claude Code は claude.ai 管理コンソールからサーバー管理設定をフェッチしません。[ポリシーが適用される場所と時期](https://code.claude.com/docs/ja/managed-settings.md#where-and-when-a-policy-applies) では、ユーザーのマシン上の Cowork セッションとリモート Cowork セッションにどのポリシーが適用されるかについて説明しています。claude.ai は、Cowork ユーザーが claude.ai の git リポジトリからマーケットプレイスを追加するか、Cowork の **Customize** から追加する場合、[`strictKnownMarketplaces`](https://code.claude.com/docs/ja/settings-reference#strictknownmarketplaces) および [`blockedMarketplaces`](https://code.claude.com/docs/ja/settings-reference#blockedmarketplaces) リストを自身で適用します。[制限がどのように機能するか](https://code.claude.com/docs/ja/plugins/org.md#restrict-what-users-can-install) がそのチェックについて説明しています。

シェルで `CLAUDE_CODE_USE_*` プロバイダー変数またはデフォルト以外の `ANTHROPIC_BASE_URL` をエクスポートする場合、Claude Code はセッションの設定フェッチをスキップします。[`claude doctor` と `/status` はスキップされたフェッチとその原因を報告します](#verify-settings-delivery)。

エクスポートがフェッチを防ぐため、サーバー管理 `env` ブロックでエクスポートをクリアすることはできません。[エンドポイント管理設定](https://code.claude.com/docs/ja/managed-settings.md#delivery-mechanisms) `env` ブロックもフェッチを復元しません。Claude Code は管理 `env` ブロックを適用する前に適格性をチェックするため、エンドポイント管理値はセッションのプロバイダー選択を変更しますが、フェッチはスキップされたままです。

サーバー管理配信を復元するには、シェルからエクスポートを削除するか、ユーザー設定 `env` ブロックで変数を `""` に設定します。これは適格性チェックの前に適用されます。ユーザーがシェルを変更することに依存せずにポリシーを適用するには、代わりにエンドポイント管理チャネルを通じて設定を配信してください。

Amazon Bedrock、Google Cloud の Agent Platform、Microsoft Foundry、および [Claude Platform on AWS](https://code.claude.com/docs/ja/claude-platform-on-aws.md) デプロイメントの場合、自己ホスト型の [Claude apps ゲートウェイ](https://code.claude.com/docs/ja/claude-apps-gateway) は同等のリモート管理設定配信を提供します。ゲートウェイにサインインしたクライアントは、`api.anthropic.com` の代わりにゲートウェイから管理設定をフェッチします。起動時の失敗セマンティクスは異なります。ゲートウェイに到達できないゲートウェイクライアントはキャッシュされた設定にフォールバックする代わりにエラーで終了しますが、時間ごとのバックグラウンド更新は両方のチャネルで fail-open です。

## 監査ログ

設定変更の監査ログイベントは、コンプライアンス API または監査ログエクスポートを通じて利用可能です。アクセスについては、Anthropic アカウントチームにお問い合わせください。

監査イベントには、実行されたアクションのタイプ、アクションを実行したアカウントとデバイス、および前の値と新しい値への参照が含まれます。

## セキュリティに関する考慮事項

サーバー管理設定は一元的なポリシー適用を提供しますが、クライアント側の制御として機能し、セキュリティ境界ではありません。管理されていないデバイスでは、ユーザーは管理者または sudo アクセス権を持つ必要なく、これらをバイパスできます。

| シナリオ | 動作 |
| :- | :- |
| ユーザーがキャッシュされた設定ファイルを編集する | 改ざんされたファイルは起動時に適用されますが、[サーバーがペイロードを確認するまで Claude Code が保留する値](#fetch-and-caching-behavior)を除きます。次のサーバーフェッチで正しい設定が復元されます。ただし、[次回の起動時にのみ適用されるキー](#fetch-and-caching-behavior)（`model` や `env` ブロックに追加された変数など）は、再起動されるまで有効なままです |
| ユーザーがキャッシュされた設定ファイルを削除する | [初回起動動作](#fetch-and-caching-behavior)が発生します |
| ユーザーが変更された Claude Code バイナリを実行する | 変更されたクライアントを実行できるユーザーは、クライアント側の制御をバイパスできます |
| ユーザーが古い Claude Code バージョンを実行する | サーバー管理設定より前のバージョンは、これらをフェッチまたは適用しません |
| API が利用不可 | キャッシュされた設定が利用可能な場合は適用されます。ただし、[フェッチが成功するまで Claude Code が保留する値](#fetch-and-caching-behavior)を除きます。キャッシュがない場合、Claude Code は次の成功したフェッチまでサーバー管理設定を適用しません。また、デバイス上の[エンドポイント管理設定](https://code.claude.com/docs/ja/managed-settings.md#delivery-mechanisms)は引き続き適用されます。`forceRemoteSettingsRefresh: true` の場合、CLI は続行するのではなく終了します。ただし、[`claude auth` サブコマンド](#enforce-fail-closed-startup)を除きます。[Claude apps gateway](#platform-availability)を通じてサインインしているクライアントは、その設定がない場合、起動時に終了します。同じ `claude auth` 除外があります |
| ユーザーが別の組織で認証する | 管理対象組織外のアカウントには設定が配信されません。これには [Console API キー](#platform-availability)で認証するセッションも含まれます |
| ユーザーが[サードパーティモデルプロバイダー](#platform-availability)を構成する | サーバー管理設定はバイパスされます。これには `CLAUDE_CODE_USE_BEDROCK`、`CLAUDE_CODE_USE_MANTLE`、`CLAUDE_CODE_USE_VERTEX`、`CLAUDE_CODE_USE_FOUNDRY`、`CLAUDE_CODE_USE_ANTHROPIC_AWS`、またはデフォルト以外の `ANTHROPIC_BASE_URL` の設定が含まれます |
| ネットワークトラフィックが傍受またはリダイレクトされる | TLS 検証が無効化されたか、傍受されたトラフィックは、クライアントが受け取る設定を変更できます |

ローカル設定ファイル（`managed-settings.json` を含む）への編集をログに記録するには、[`ConfigChange` フック](https://code.claude.com/docs/ja/hooks#configchange)を使用してください。Claude Code は、サーバー管理設定が到着または更新されるとき、または MDM プロファイルまたはレジストリポリシーが変更されるときにこれらを実行しません。また、フックは `policy_settings` の変更をブロックできません。

ユーザーがクライアントが提供する認証情報でアクセスできる組織を制限するには、Claude ヘルプセンターの[テナント制限を使用したネットワークレベルのアクセス制御の適用](https://support.claude.com/en/articles/13198485-enforce-network-level-access-control-with-tenant-restrictions)を参照してください。より強力な適用保証については、MDM ソリューションに登録されているデバイスで[エンドポイント管理設定](https://code.claude.com/docs/ja/managed-settings.md#delivery-mechanisms)を使用してください。

## 関連項目

Claude Code 構成を管理するための関連ページ：

* [すべての設定](https://code.claude.com/docs/ja/settings-reference.md)：すべての設定キー
* [Endpoint-managed settings](https://code.claude.com/docs/ja/managed-settings.md#delivery-mechanisms)：IT によってデバイスに配置される管理設定
* [Authentication](https://code.claude.com/docs/ja/authentication.md)：Claude Code へのユーザーアクセスのセットアップ
* [Security](https://code.claude.com/docs/ja/security.md)：セキュリティ保護とベストプラクティス
