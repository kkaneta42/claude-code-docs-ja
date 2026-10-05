> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# 環境変数

> Claude Code の動作を制御する環境変数のリファレンス。

環境変数は、モデル選択、認証、リクエストルーティング、機能トグルなど、Claude Code の動作を制御できます。同じ動作の多くは、[設定ファイル](/docs/ja/settings)フィールド、[CLI フラグ](/docs/ja/cli-reference)、または `/model` などのセッション内コマンドを通じても設定できます。

このページでは、以下の内容について説明します。

* [環境変数を設定する](#set-environment-variables)方法（シェルまたは設定ファイル内）
* [複数の方法で動作を設定できる場合](#precedence)、どの値が適用されるかを確認する
* [Claude Code が読み込む変数を検索する](#variables)
* [変数が機能フラグ取得をオフにする場合](#features-that-need-feature-flag-fetching)、どの機能が動作しなくなるかを確認する

<h2 id="set-environment-variables">
  環境変数を設定する
</h2>

シェルで設定した変数はそのターミナルセッション中のみ有効ですが、設定ファイル内の変数は `claude` を実行するたびに適用されます。

<h3 id="in-your-shell">
  シェルで設定する
</h3>

`claude` を起動する前に変数を設定します。

<Tabs>
  <Tab title="macOS、Linux、WSL">
    ```bash theme={null}
    export API_TIMEOUT_MS="1200000"
    claude
    ```

    すべてのセッションで設定するには、`export` 行を `~/.bashrc`、`~/.zshrc`、またはシェルのプロファイルファイルに追加します。
  </Tab>

  <Tab title="Windows PowerShell">
    ```powershell theme={null}
    $env:API_TIMEOUT_MS = "1200000"
    claude
    ```

    すべてのセッションで設定するには、`[Environment]::SetEnvironmentVariable("API_TIMEOUT_MS", "1200000", "User")` を実行して新しいターミナルを開きます。
  </Tab>

  <Tab title="Windows CMD">
    ```batch theme={null}
    set API_TIMEOUT_MS=1200000
    claude
    ```

    すべてのセッションで設定するには、`setx API_TIMEOUT_MS "1200000"` を実行して新しいターミナルを開きます。
  </Tab>
</Tabs>

代入行は成功時に何も出力しないため、同じシェルで変数を出力して確認します。

<Tabs>
  <Tab title="macOS、Linux、WSL">
    ```bash theme={null}
    echo $API_TIMEOUT_MS
    ```
  </Tab>

  <Tab title="Windows PowerShell">
    ```powershell theme={null}
    echo $env:API_TIMEOUT_MS
    ```
  </Tab>

  <Tab title="Windows CMD">
    ```batch theme={null}
    echo %API_TIMEOUT_MS%
    ```
  </Tab>
</Tabs>

<h3 id="in-settings-files">
  設定ファイルで設定する
</h3>

`settings.json` ファイルの `env` キーの下に変数を追加します。ファイルが存在しない場合は作成します。Claude Code はファイルから直接読み込むため、`claude` がどのように起動されたかに関わらず有効になります。実行中のセッションは、ファイルを保存するときに新しい値と変更された値を環境に適用しますが、[OpenTelemetry monitoring](/docs/ja/monitoring-usage) のように起動時に変数を一度だけ読み込む機能は、再起動するまで起動時の値を保持します。ファイルから変数を削除しても、実行中のセッションではその変数は設定解除されません。削除は `claude` を次に起動するときに有効になります。

```json ~/.claude/settings.json theme={null}
{
  "env": {
    "API_TIMEOUT_MS": "1200000",
    "BASH_DEFAULT_TIMEOUT_MS": "300000"
  }
}
```

選択したファイルは、変数が適用される対象を制御します。

| ファイル | 適用対象 |
| :- | :- |
| `~/.claude/settings.json` | すべてのプロジェクトで、あなた |
| `.claude/settings.json` | プロジェクトで作業しているすべての人、ソース管理にチェックイン |
| `.claude/settings.local.json` | このプロジェクトのみで、あなた。Claude Code が設定を保存するときに gitignore されます。手動で作成した場合は gitignore に追加してください |
| 管理設定 | 組織内のすべての人、管理者によってデプロイ |

各ファイルの場所については [Settings files](/docs/ja/settings#where-settings-live) を、複数のファイルが同じ変数を設定する場合の組み合わせ方については [Settings precedence](/docs/ja/settings#settings-precedence) を参照してください。

<h2 id="precedence">
  優先順位
</h2>

いくつかの動作には環境変数と専用の設定キーの両方があり、Claude Code がどちらを最初に読むかはキーごとに異なります。`ANTHROPIC_MODEL` と `CLAUDE_CODE_AUTO_CONNECT_IDE` の場合、Claude Code は変数を最初に読み、変数が設定されていない場合にのみ `model` または `autoConnectIde` 設定を使用します。設定しているペアについては、以下の変数の行と [設定リファレンス](/docs/ja/settings-reference) のキーのエントリを確認してください。

同じ変数がシェルと設定ファイルの `env` ブロックの両方で設定されている場合、ほとんどのセッションで設定ファイルの値が適用されます。Claude Code は各 `env` エントリをプロセス環境に書き込み、シェルから継承された値を置き換えます。[`env` 値がシェルとどのように相互作用するか](/docs/ja/settings-reference#how-env-values-interact-with-your-shell) は、代わりに継承された値を保持するセッションについて説明しており、[`env` 設定](/docs/ja/settings-reference#when-claude-code-applies-env-values) はそれらがいつ適用されるかを示しています。いくつかの変数は特別な扱いを受けます。[`env` 設定](/docs/ja/settings-reference#env) は例外をリストしています。

設定ファイルでは変数を設定できますが、削除することはできません。制御していないシェルプロファイルによってエクスポートされた古い `CLAUDE_CODE_USE_VERTEX` など、設定を解除できない変数をオーバーライドするには、`env` ブロックで空の文字列に設定します。`"CLAUDE_CODE_USE_VERTEX": ""`。Claude Code は空の値をプロバイダー選択の未設定として扱います。サブプロセスは引き続き空の値を継承します。

設定ファイル間では、`env` 値は [設定の優先順位](/docs/ja/settings#settings-precedence) に従うため、マネージド設定エントリはユーザーまたはプロジェクト設定の同じ変数をオーバーライドします。プロジェクトおよびローカル設定は、`CLAUDE_CONFIG_DIR` や OpenTelemetry エクスポーター変数など、一部の変数を設定できません。[`env` で Claude Code が無視する変数](/docs/ja/settings-reference#variables-claude-code-ignores-in-env) は、それらと、引き続き適用される OpenTelemetry オフ値をリストしています。

環境変数が CLI フラグおよびセッション内コマンドとどのように相互作用するかは、機能ごとに異なります。`--model` と `/model` は `ANTHROPIC_MODEL` をオーバーライドしますが、`CLAUDE_CODE_EFFORT_LEVEL` は `--effort` と `/effort` をオーバーライドします。変数が別の設定ソースと相互作用する場合、[変数](#variables) リストの行は優先順位を示すか、それを文書化するページにリンクします。

Claude Code はスタートアップ時にシェル環境変数を読み込むため、それらへの変更は次回 `claude` を起動するときに有効になります。設定ファイルの `env` キーの下に設定された変数は、[設定ファイル内](#in-settings-files) で説明されているスタートアップのみの例外を除き、ファイルが変更されたときに実行中のセッションに再適用されます。

<h2 id="variables">
  変数
</h2>

タイムアウト、トークン予算、再試行回数などの数値変数は、通常の数字に加えて、科学的記数法や桁区切り文字を使った表記も受け付けます。ただし、変数の行に通常の数字のみ受け付けると記載されている場合は除きます。たとえば、Claude Code は `2e3` を 2000、`64_000` を 64000 として読み取ります。v2.1.211 より前は、`1e6` でタイムアウトが 1 に設定されるなど、これらの表記によって意図よりはるかに小さい値が警告なしに設定されることがありました。

<Note>
  動作をオンまたはオフにする変数では、大文字小文字を問わず、`1`、`true`、`yes`、`on` を設定するとオンに、`0`、`false`、`no`、`off` を設定するとオフになります。

  一部の変数は設定されているかどうかのみを読み取るため、`0` を含む空でない値はすべて動作をオンにします。動作をオフにするには、変数の設定を解除するか、空の値を設定します。次の変数がこのように動作します。

  * `CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC`
  * `DISABLE_TELEMETRY`
  * `DISABLE_ERROR_REPORTING`
  * `CLAUDE_CODE_TMUX_TRUECOLOR`
  * `FALLBACK_FOR_ALL_PRIMARY_MODELS`
  * `IS_DEMO`

  もう 1 つの変数には独自のルールがあります。`FORCE_HYPERLINK` は数値を読み取るため、`0` を設定した場合にのみオフになります。各変数の行にも、それぞれのルールが記載されています。
</Note>

| 変数 | 用途 |
| :- | :- |
| `ANTHROPIC_API_KEY` | `X-Api-Key` ヘッダーとして送信される API キー。設定されている場合、ログインしていても、Claude Pro、Max、Team、Enterprise のサブスクリプションの代わりにこのキーが使用されます。非対話モード（`-p`）では、キーが存在する場合は常に使用されます。対話モードでは、キーがサブスクリプションを上書きする前に、キーを承認するよう一度求められます。代わりにサブスクリプションを使用するには、`unset ANTHROPIC_API_KEY` を実行します |
| `ANTHROPIC_AUTH_TOKEN` | `Authorization` ヘッダーのカスタム値（ここで設定した値には `Bearer ` が前に付加されます） |
| `ANTHROPIC_AWS_API_KEY` | [Claude Platform on AWS](/docs/ja/claude-platform-on-aws) 用のワークスペース API キー。AWS コンソールで生成します。`x-api-key` として送信され、AWS SigV4 より優先されます |
| `ANTHROPIC_AWS_BASE_URL` | [Claude Platform on AWS](/docs/ja/claude-platform-on-aws) のエンドポイント URL を上書きします。カスタムリージョンや、[LLM ゲートウェイ](/docs/ja/llm-gateway)経由でルーティングする場合に使用します。デフォルトは `https://aws-external-anthropic.{region}.api.aws` です。Claude Code は [Amazon Bedrock と同じ優先順位](/docs/ja/amazon-bedrock#3-configure-claude-code)でリージョンを解決します |
| `ANTHROPIC_AWS_WORKSPACE_ID` | [Claude Platform on AWS](/docs/ja/claude-platform-on-aws) で必須です。すべてのリクエストで `anthropic-workspace-id` ヘッダーとして送信されます |
| `ANTHROPIC_BASE_URL` | API エンドポイントを上書きして、プロキシまたはゲートウェイ経由でリクエストをルーティングします。ファーストパーティ以外のホストに設定すると、[MCP ツール検索](/docs/ja/mcp#scale-with-mcp-tool-search)はデフォルトで無効になります。プロキシが `tool_reference` ブロックを転送する場合は、`ENABLE_TOOL_SEARCH=true` を設定してください。v2.1.196 以降、これが `api.anthropic.com` 以外のホストを指している場合、[Remote Control](/docs/ja/remote-control#requirements) は無効になります。これは Amazon Bedrock、Google Cloud's Agent Platform、Microsoft Foundry での動作と同じです |
| `ANTHROPIC_BEDROCK_BASE_URL` | Amazon Bedrock のエンドポイント URL を上書きします。カスタムの Amazon Bedrock エンドポイントや、[LLM ゲートウェイ](/docs/ja/llm-gateway)経由でルーティングする場合に使用します。[Amazon Bedrock](/docs/ja/amazon-bedrock) を参照してください |
| `ANTHROPIC_BEDROCK_MANTLE_BASE_URL` | Amazon Bedrock Mantle のエンドポイント URL を上書きします。[Mantle エンドポイント](/docs/ja/amazon-bedrock#use-the-mantle-endpoint)を参照してください |
| `ANTHROPIC_BEDROCK_REGION_PREFIX` | AWS リージョンから導出されるプレフィックスの代わりに Claude Code が最初に試す、クロスリージョン推論プロファイルのプレフィックス（`us`、`eu`、`apac`、`jp`、`au`、または `global`）。AWS GovCloud リージョンでは無視されます。Claude Code v2.1.224 以降が必要です。[Amazon Bedrock](/docs/ja/amazon-bedrock#cross-region-inference-profile-prefixes) を参照してください |
| `ANTHROPIC_BEDROCK_SERVICE_TIER` | Amazon Bedrock の[サービスティア](https://docs.aws.amazon.com/bedrock/latest/userguide/service-tiers-inference.html)（`default`、`flex`、または `priority`）。`X-Amzn-Bedrock-Service-Tier` ヘッダーとして送信されます。[Amazon Bedrock](/docs/ja/amazon-bedrock#service-tiers) を参照してください |
| `ANTHROPIC_BETAS` | API リクエストに含める追加の `anthropic-beta` ヘッダー値のカンマ区切りリスト。Claude Code は必要なベータヘッダーをすでに送信しています。Claude Code がネイティブにサポートする前に [Anthropic API のベータ機能](https://platform.claude.com/docs/en/api/beta-headers)を利用するには、この変数を使用します。API キー認証が必要な [`--betas` フラグ](/docs/ja/cli-reference#cli-flags)とは異なり、この変数は Claude.ai サブスクリプションを含むすべての認証方法で機能します |
| `ANTHROPIC_CUSTOM_HEADERS` | リクエストに追加するカスタムヘッダー（`Name: Value` 形式、複数のヘッダーは改行区切り）。名前または値に、カーリークォートやゼロ幅スペースなど HTTP ヘッダーで扱えない文字が含まれている場合、リクエストは失敗し、そのペアを位置で特定するエラーが表示されます。Claude Code v2.1.227 以降が必要です。[Invalid request header value](/docs/ja/errors#invalid-request-header-value) に、正確な文字セットとチェックが実行される場所が記載されています。`Authorization` や `Host` など、認証情報、組織またはテナント、ルーティング、API の動作に関わるヘッダーを設定する値は、サーバー管理設定によって配信された場合、[承認が必要な設定](/docs/ja/server-managed-settings#environment-variables-and-the-approval-dialog)として扱われます。プロジェクト設定またはローカル設定からの場合、このような値は [`env` の値が適用されるタイミングのルール](/docs/ja/settings-reference#when-claude-code-applies-env-values)に従います |
| `ANTHROPIC_CUSTOM_MODEL_OPTION` | `/model` ピッカーにカスタムエントリとして追加するモデル ID。組み込みエイリアスを置き換えずに、標準外のモデルやゲートウェイ固有のモデルを選択できるようにするために使用します。[モデル設定](/docs/ja/model-config#add-a-custom-model-option)を参照してください |
| `ANTHROPIC_CUSTOM_MODEL_OPTION_DESCRIPTION` | `/model` ピッカーでのカスタムモデルエントリの表示用説明。設定されていない場合のデフォルトは `Custom model (<model-id>)` です |
| `ANTHROPIC_CUSTOM_MODEL_OPTION_NAME` | `/model` ピッカーでのカスタムモデルエントリの表示名。設定されていない場合、Claude Code が [ID を認識](/docs/ja/model-config#customize-pinned-model-display-and-capabilities)していればモデル名が、認識していなければモデル ID が表示されます |
| `ANTHROPIC_CUSTOM_MODEL_OPTION_SUPPORTED_CAPABILITIES` | カスタムモデルがサポートする[機能](/docs/ja/model-config#customize-pinned-model-display-and-capabilities)のカンマ区切りリスト（例：`effort,thinking`）。[モデル設定](/docs/ja/model-config#customize-pinned-model-display-and-capabilities)を参照してください |
| `ANTHROPIC_DEFAULT_FABLE_MODEL` | `fable` エイリアスが解決されるモデル ID。また、サードパーティプロバイダーでの[自動モデルフォールバック](/docs/ja/model-config#automatic-model-fallback)において、Claude Code が Fable モデルとして認識する ID でもあります。[モデル設定](/docs/ja/model-config#environment-variables)を参照してください |
| `ANTHROPIC_DEFAULT_FABLE_MODEL_DESCRIPTION` | `/model` ピッカーでの、固定された Fable モデルの表示用説明。設定されていない場合、その行には `Custom Fable model` で始まるデフォルトの説明が表示されます。[モデル設定](/docs/ja/model-config#customize-pinned-model-display-and-capabilities)を参照してください |
| `ANTHROPIC_DEFAULT_FABLE_MODEL_NAME` | `/model` ピッカーでの、固定された Fable モデルの表示名。設定されていない場合、Claude Code が固定された ID を認識していればモデル名が、認識していなければ固定された ID が表示されます。[モデル設定](/docs/ja/model-config#customize-pinned-model-display-and-capabilities)を参照してください |
| `ANTHROPIC_DEFAULT_FABLE_MODEL_SUPPORTED_CAPABILITIES` | 固定された Fable モデルがサポートする[機能](/docs/ja/model-config#customize-pinned-model-display-and-capabilities)のカンマ区切りリスト（例：`effort,thinking`）。[モデル設定](/docs/ja/model-config#customize-pinned-model-display-and-capabilities)を参照してください |
| `ANTHROPIC_DEFAULT_HAIKU_MODEL` | `haiku` エイリアスが解決されるモデル ID。[バックグラウンド機能](/docs/ja/costs#background-token-usage)にも使用されます。[モデル設定](/docs/ja/model-config#environment-variables)を参照してください |
| `ANTHROPIC_DEFAULT_HAIKU_MODEL_DESCRIPTION` | `/model` ピッカーでの、固定された Haiku モデルの表示用説明。設定されていない場合、その行には `Custom Haiku model` で始まるデフォルトの説明が表示されます。[モデル設定](/docs/ja/model-config#customize-pinned-model-display-and-capabilities)を参照してください |
| `ANTHROPIC_DEFAULT_HAIKU_MODEL_NAME` | `/model` ピッカーでの、固定された Haiku モデルの表示名。設定されていない場合、Claude Code が固定された ID を認識していればモデル名が、認識していなければ固定された ID が表示されます。[モデル設定](/docs/ja/model-config#customize-pinned-model-display-and-capabilities)を参照してください |
| `ANTHROPIC_DEFAULT_HAIKU_MODEL_SUPPORTED_CAPABILITIES` | 固定された Haiku モデルがサポートする[機能](/docs/ja/model-config#customize-pinned-model-display-and-capabilities)のカンマ区切りリスト（例：`effort,thinking`）。[モデル設定](/docs/ja/model-config#customize-pinned-model-display-and-capabilities)を参照してください |
| `ANTHROPIC_DEFAULT_MODEL` | 新しいセッションがデフォルトで開始するモデル。Claude Code v2.1.236 以降が必要です。[新しいセッションのデフォルトモデルを設定する](/docs/ja/model-config#set-a-default-model-for-new-sessions)を参照してください |
| `ANTHROPIC_DEFAULT_OPUS_MODEL` | `opus` エイリアスが解決されるモデル ID。plan モードがアクティブな間に `opusplan` が使用するモデルでもあります。[モデル設定](/docs/ja/model-config#environment-variables)を参照してください |
| `ANTHROPIC_DEFAULT_OPUS_MODEL_DESCRIPTION` | `/model` ピッカーでの、固定された Opus モデルの表示用説明。設定されていない場合、その行には `Custom Opus model` で始まるデフォルトの説明が表示されます。[モデル設定](/docs/ja/model-config#customize-pinned-model-display-and-capabilities)を参照してください |
| `ANTHROPIC_DEFAULT_OPUS_MODEL_NAME` | `/model` ピッカーでの、固定された Opus モデルの表示名。設定されていない場合、Claude Code が固定された ID を認識していればモデル名が、認識していなければ固定された ID が表示されます。[モデル設定](/docs/ja/model-config#customize-pinned-model-display-and-capabilities)を参照してください |
| `ANTHROPIC_DEFAULT_OPUS_MODEL_SUPPORTED_CAPABILITIES` | 固定された Opus モデルがサポートする[機能](/docs/ja/model-config#customize-pinned-model-display-and-capabilities)のカンマ区切りリスト（例：`effort,thinking`）。[モデル設定](/docs/ja/model-config#customize-pinned-model-display-and-capabilities)を参照してください |
| `ANTHROPIC_DEFAULT_SONNET_MODEL` | `sonnet` エイリアスが解決されるモデル ID。plan モードがアクティブでないときに `opusplan` が使用するモデルでもあります。[モデル設定](/docs/ja/model-config#environment-variables)を参照してください |
| `ANTHROPIC_DEFAULT_SONNET_MODEL_DESCRIPTION` | `/model` ピッカーでの、固定された Sonnet モデルの表示用説明。設定されていない場合、その行には `Custom Sonnet model` で始まるデフォルトの説明が表示されます。[モデル設定](/docs/ja/model-config#customize-pinned-model-display-and-capabilities)を参照してください |
| `ANTHROPIC_DEFAULT_SONNET_MODEL_NAME` | `/model` ピッカーでの、固定された Sonnet モデルの表示名。設定されていない場合、Claude Code が固定された ID を認識していればモデル名が、認識していなければ固定された ID が表示されます。[モデル設定](/docs/ja/model-config#customize-pinned-model-display-and-capabilities)を参照してください |
| `ANTHROPIC_DEFAULT_SONNET_MODEL_SUPPORTED_CAPABILITIES` | 固定された Sonnet モデルがサポートする[機能](/docs/ja/model-config#customize-pinned-model-display-and-capabilities)のカンマ区切りリスト（例：`effort,thinking`）。[モデル設定](/docs/ja/model-config#customize-pinned-model-display-and-capabilities)を参照してください |
| `ANTHROPIC_FEDERATION_RULE_ID` | [Workload Identity Federation](https://platform.claude.com/docs/en/manage-claude/workload-identity-federation) のフェデレーションルール ID。`ANTHROPIC_ORGANIZATION_ID` と一緒に設定すると、Claude Code はフェデレーション認証情報を選択します。これは `/login` の認証情報より優先されます。[認証の優先順位](/docs/ja/authentication#authentication-precedence)を参照してください |
| `ANTHROPIC_FOUNDRY_API_KEY` | Microsoft Foundry 認証用の API キー（[Microsoft Foundry](/docs/ja/microsoft-foundry) を参照） |
| `ANTHROPIC_FOUNDRY_AUTH_TOKEN` | Microsoft Entra アクセストークンなど、Microsoft Foundry 認証用のベアラートークン。Claude Code はこれを `Authorization: Bearer` ヘッダーとして送信します。`ANTHROPIC_FOUNDRY_API_KEY` および Azure のデフォルト認証情報チェーンより優先されます。[Microsoft Foundry](/docs/ja/microsoft-foundry) を参照してください。Claude Code v2.1.203 以降が必要です |
| `ANTHROPIC_FOUNDRY_BASE_URL` | Microsoft Foundry リソースの完全なベース URL（例：`https://my-resource.services.ai.azure.com/anthropic`）。`ANTHROPIC_FOUNDRY_RESOURCE` の代替です（[Microsoft Foundry](/docs/ja/microsoft-foundry) を参照） |
| `ANTHROPIC_FOUNDRY_RESOURCE` | Microsoft Foundry のリソース名（例：`my-resource`）。Claude Code は [URL やホスト名を拒否します](/docs/ja/errors#anthropic-foundry-resource-must-be-a-foundry-resource-name)。`ANTHROPIC_FOUNDRY_BASE_URL` が設定されていない場合は必須です（[Microsoft Foundry](/docs/ja/microsoft-foundry) を参照） |
| `ANTHROPIC_MODEL` | 使用するモデル設定の名前（[モデル設定](/docs/ja/model-config#environment-variables)を参照） |
| `ANTHROPIC_ORGANIZATION_ID` | [Workload Identity Federation](https://platform.claude.com/docs/en/manage-claude/workload-identity-federation) の組織 ID。`ANTHROPIC_FEDERATION_RULE_ID` と一緒に設定します。[認証の優先順位](/docs/ja/authentication#authentication-precedence)を参照してください |
| `ANTHROPIC_PROFILE` | 認証に使用する Anthropic プロファイルの名前。[`ant auth login`](https://platform.claude.com/docs/en/cli-sdks-libraries/cli/authentication) で作成したプロファイルや、[API キーなしで Console アカウントにサインイン](/docs/ja/authentication#sign-in-without-an-api-key)して作成したプロファイルなどです。[認証の優先順位](/docs/ja/authentication#authentication-precedence)を参照してください |
| `ANTHROPIC_SMALL_FAST_MODEL` | \[非推奨] [バックグラウンドタスク用の Haiku クラスのモデル](/docs/ja/costs)の名前 |
| `ANTHROPIC_SMALL_FAST_MODEL_AWS_REGION` | Amazon Bedrock または Amazon Bedrock Mantle を使用する場合に、Haiku クラスのモデルの AWS リージョンを上書きします。Amazon Bedrock では、`ANTHROPIC_DEFAULT_HAIKU_MODEL` または非推奨の `ANTHROPIC_SMALL_FAST_MODEL` も設定されている場合にのみ有効になります。それ以外の場合、Amazon Bedrock はセッションのリージョンで[デフォルトの Sonnet モデルまたはプライマリモデル](/docs/ja/amazon-bedrock#4-pin-model-versions)を使ってバックグラウンドタスクを実行するためです |
| `ANTHROPIC_VERTEX_BASE_URL` | Google Cloud's Agent Platform のエンドポイント URL を上書きします。カスタムの Google Cloud's Agent Platform エンドポイントや、[LLM ゲートウェイ](/docs/ja/llm-gateway)経由でルーティングする場合に使用します。[Google Cloud's Agent Platform](/docs/ja/google-vertex-ai) を参照してください |
| `ANTHROPIC_VERTEX_PROJECT_ID` | Google Cloud's Agent Platform のリクエストの宛先となる GCP プロジェクト ID。[GCP 認証情報を設定する](/docs/ja/google-vertex-ai#3-configure-gcp-credentials)を参照してください |
| `ANTHROPIC_WORKSPACE_ID` | [ワークロード ID フェデレーション](https://platform.claude.com/docs/en/manage-claude/workload-identity-federation)のワークスペース ID。フェデレーションルールのスコープが複数のワークスペースにまたがる場合に、トークン交換でどのワークスペースを対象にするかを指定するために設定します |
| `API_FORCE_IDLE_TIMEOUT` | バイトが届かないときにストリーミングのモデル応答を中止する、5 分間のボディアイドルタイムアウトを上書きします。`0` に設定するとタイムアウトがオフになります。たとえば、低速な[ゲートウェイ](/docs/ja/llm-gateway)やローカルモデルがチャンク間で 5 分以上停止する場合に使用します。`1` に設定すると、すべてのプロバイダーでオンのままになります。未設定の場合、タイムアウトは直接の Anthropic API、[Claude Platform on AWS](/docs/ja/claude-platform-on-aws)、および `CLAUDE_ENABLE_BYTE_WATCHDOG_BEDROCK=1` が設定された Amazon Bedrock 以外のプロバイダーで有効です。[ストリームウォッチドッグ](/docs/ja/network-config#streaming-idle-watchdogs)はこれとは独立して動作し、ここで `0` を設定した場合でも、長時間の無応答の停止を中止します |
| `API_TIMEOUT_MS` | API リクエストのタイムアウト（ミリ秒）（デフォルト：600000、つまり 10 分。最大：2147483647）。低速なネットワークやプロキシ経由のルーティングでリクエストがタイムアウトする場合は、この値を増やしてください。最大値を超える値は基盤となるタイマーをオーバーフローさせ、リクエストが即座に失敗する原因となります |
| `AWS_BEARER_TOKEN_BEDROCK` | 認証用の Amazon Bedrock API キー（[Amazon Bedrock API キー](https://aws.amazon.com/blogs/machine-learning/accelerate-ai-development-with-amazon-bedrock-api-keys/)を参照） |
| `BASH_DEFAULT_TIMEOUT_MS` | フォアグラウンドの Bash または PowerShell ツールコマンドのデフォルトタイムアウト（ミリ秒）（デフォルト：120000、つまり 2 分）。30 分より長いデフォルト値は、無人セッションにおける[バックグラウンドコマンドの時間制限](/docs/ja/tools-reference#time-limit-for-background-commands)のデフォルトにもなります。バックグラウンドの時間制限には Claude Code v2.1.285 以降が必要です |
| `BASH_MAX_OUTPUT_LENGTH` | Claude Code がコマンドの結果に読み戻す bash 出力の最大文字数（デフォルト：30000、最大：150000）。[`bashOutputMaxChars`](/docs/ja/settings-reference#bashoutputmaxchars) 設定を行っている場合、Claude Code はこの変数を無視します。[出力の制限](/docs/ja/tools-reference#output-limits)を参照してください |
| `BASH_MAX_TIMEOUT_MS` | フォアグラウンドの Bash または PowerShell ツールコマンドにモデルが設定できる最大タイムアウト（ミリ秒）（デフォルト：600000、つまり 10 分）。実効的な上限は、この値と `BASH_DEFAULT_TIMEOUT_MS` のうち大きい方です。2 時間より長い実効上限は、無人セッションにおける[バックグラウンドコマンドの時間制限](/docs/ja/tools-reference#time-limit-for-background-commands)の最大値にもなります。バックグラウンドの時間制限には Claude Code v2.1.285 以降が必要です |
| `BETA_TRACING_ENDPOINT` | [詳細なベータトレース](/docs/ja/monitoring-usage#traces-beta)用の OTLP エンドポイント。`ENABLE_BETA_TRACING_DETAILED=1` を設定すると、ログとトレースは設定済みのエクスポーターではなくこのエンドポイントに送信されます。シェル、ユーザー設定、または管理設定で設定してください。[プロジェクト設定とローカル設定](/docs/ja/settings-reference#variables-claude-code-ignores-in-env)では無視されます |
| `CCR_FORCE_BUNDLE` | `1` に設定すると、[`claude --cloud`](/docs/ja/claude-code-on-the-web#send-local-repositories-without-github) がリモートからクローンする代わりに、ローカルリポジトリをバンドルしてアップロードするよう強制します |
| `CLAUDECODE` | Claude Code が起動するサブプロセス（Bash ツールと PowerShell ツール、tmux セッション、[フック](/docs/ja/hooks)コマンド、[ステータスライン](/docs/ja/statusline)コマンド、stdio [MCP サーバー](/docs/ja/mcp)のサブプロセス）で `1` に設定されます。IDE 拡張機能も統合ターミナルでこれを設定します。スクリプトが Claude Code によって起動されたサブプロセス内で実行されているかを検出するために使用します。Claude Code が起動した stdio MCP サーバー内ではなく、ツール呼び出しやフックによって現在のプロセスが直接起動されたかどうかを確認するには、代わりに `CLAUDE_CODE_CHILD_SESSION` を使用してください |
| `CLAUDE_AFK_COUNTDOWN_MS` | 未回答の [`AskUserQuestion`](/docs/ja/tools-reference) ダイアログで、自動続行の何ミリ秒前に画面上のカウントダウンを表示するか。デフォルトは `20000`（20 秒）で、自動続行のタイムアウトが上限です。自動続行がオンでない限り効果はありません。[`askUserQuestionTimeout`](/docs/ja/settings-reference#askuserquestiontimeout) 設定と `CLAUDE_AFK_TIMEOUT_MS` を参照してください。Claude Code v2.1.198 以降が必要です |
| `CLAUDE_AFK_TIMEOUT_MS` | 未回答の [`AskUserQuestion`](/docs/ja/tools-reference) ダイアログが、ユーザーの操作なしに自動続行するまでのアイドル時間（ミリ秒）。自動続行はデフォルトでオフです。[`askUserQuestionTimeout`](/docs/ja/settings-reference#askuserquestiontimeout) 設定でオプトインしてください。この変数はデモや自動テスト用の上書きです。設定すると、その設定より優先され、設定が未設定または `never` の場合でも自動続行がオンになります。`0` を設定してもタイムアウトはオフにならず、ダイアログが即座に閉じます。v2.1.198 と v2.1.199 では、自動続行はデフォルトでオンで、タイムアウトは `60000`（60 秒）でした。Claude Code v2.1.198 以降が必要です |
| `CLAUDE_AGENT_SDK_DISABLE_BUILTIN_AGENTS` | `1` に設定すると、Explore や Plan などの組み込み[サブエージェント](/docs/ja/sub-agents)タイプをすべて無効にします。非対話モード（`-p` フラグ）でのみ適用されます。まっさらな状態から始めたい SDK ユーザーに便利です。これにより、Agent ツール呼び出しで `subagent_type` が省略されたときに Claude Code が実行するサブエージェントである `general-purpose` も削除されます。その場合、そのような呼び出しは [`subagent_type is required`](/docs/ja/errors#subagent-type-is-required) で失敗します |
| `CLAUDE_AGENT_SDK_MCP_NO_PREFIX` | `1` に設定すると、SDK で作成された MCP サーバーのツール名に付く `mcp__<server>__` プレフィックスを省略します。ツールは元の名前を使用します。SDK での使用のみ |
| `CLAUDE_ASYNC_AGENT_STALL_TIMEOUT_MS` | サブエージェントのストールタイムアウト（ミリ秒）。デフォルトは `600000`（10 分）です。ストリームウォッチドッグがオンの状態で `CLAUDE_STREAM_IDLE_TIMEOUT_MS` を引き上げると、[低速または停止した API レスポンスの処理](/docs/ja/agent-sdk/typescript#handle-slow-or-stalled-api-responses)で説明されているように、デフォルトもそれに合わせて引き上げられます。タイマーはストリーミングの進行イベントごとにリセットされます。期間内に進行がない場合、Claude Code はサブエージェントを中止し、ストールを親に報告します |
| `CLAUDE_AUTOCOMPACT_PCT_OVERRIDE` | 自動圧縮がトリガーされる、自動圧縮ウィンドウのパーセンテージ（1-100）を設定します。早めに圧縮するには `50` などの低い値を使用します。この変数でしきい値を引き上げることはできないため、デフォルトのパーセンテージを超える値は無視されます。[モデルのコンテキスト上限の前に圧縮する](/docs/ja/model-config#context-window-and-auto-compaction)セッションでのみ適用されます。メインの会話とサブエージェントの両方に適用されます |
| `CLAUDE_AUTO_BACKGROUND_TASKS` | `1` に設定すると、長時間実行されるエージェントタスクの自動バックグラウンド化を強制的に有効にします。有効にすると、サブエージェントは約 2 分間実行された後にバックグラウンドに移動されます。Claude Code v2.1.212 以降では、非対話モードでの[長時間の MCP ツール呼び出しの自動バックグラウンド化](/docs/ja/mcp#automatic-backgrounding-of-long-tool-calls)も有効になります |
| `CLAUDE_AX_PREPARK_MS` | [スクリーンリーダーモード](/docs/ja/accessibility)で、新しい行または変更された行を書き込む前に Claude Code が待機するミリ秒数。デフォルトは `0` で、Claude Code は待機しません。v2.1.287 より前のデフォルトは `50` でした。Claude Code は待機時間の上限を `5000` にしています。Claude Code v2.1.233 以降が必要です |
| `CLAUDE_AX_SCREEN_READER` | `1` に設定すると、装飾的な枠線やアニメーションのないフラットなテキストという、スクリーンリーダー向けの出力をレンダリングします。`0` に設定すると、[`axScreenReader`](/docs/ja/settings-reference#axscreenreader) が `true` の場合でもスクリーンリーダーモードを強制的にオフにします。[`--ax-screen-reader`](/docs/ja/cli-reference#cli-flags) フラグが優先されます。Claude Code v2.1.181 以降が必要です |
| `CLAUDE_AX_STARTUP_QUIET_MS` | [スクリーンリーダーモード](/docs/ja/accessibility)で、起動確認行の後、最初のインターフェースのレンダリングを Claude Code が保留するミリ秒数。これにより、新しい出力で中断される前に、スクリーンリーダーがその行を最後まで読み上げられます。デフォルトは `3000` です。すぐにレンダリングするには `0` を設定します。Claude Code は保留時間の上限を `600000`（10 分）にしています。最初のキー入力で保留は早期に終了します。Claude Code v2.1.217 以降が必要です |
| `CLAUDE_BASH_MAINTAIN_PROJECT_WORKING_DIR` | メインセッションで、各 Bash または PowerShell コマンドの後に元の作業ディレクトリに戻ります |
| `CLAUDE_BYTE_STREAM_IDLE_TIMEOUT_MS` | バイトレベルのストリーミングアイドルウォッチドッグのタイムアウト（ミリ秒）。設定すると、そのウォッチドッグについては `CLAUDE_STREAM_IDLE_TIMEOUT_MS` より優先され、イベントレベルのウォッチドッグは変更されません。Claude Code はこの変数を 10 秒から 30 分の範囲に制限します。Claude Code v2.1.210 以降が必要です |
| `CLAUDE_CLIENT_PRESENCE_FILE` | 画面ロックリスナーなどの外部ツールが、画面のロック解除時に作成し、ロック時に削除するファイルへのパス。ファイルが存在する間、Claude Code は [Remote Control のモバイルプッシュ通知](/docs/ja/remote-control#mobile-push-notifications)をスキップするため、コンピューターを使用している間はプッシュ通知が届かなくなります。ファイルが存在しないか読み取れない場合、通知は通常どおり送信されます。Claude Code はファイルをポーリングするのではなく、プッシュをトリガーするイベントごとに 1 回確認します。Claude Code v2.1.181 以降が必要です |
| `CLAUDE_CODE_ACCESSIBILITY` | `1` に設定すると、ネイティブのターミナルカーソルを表示したままにし、反転テキストのカーソルインジケーターを無効にします。macOS のズーム機能などの画面拡大ツールがカーソル位置を追跡できるようになります |
| `CLAUDE_CODE_ADDITIONAL_DIRECTORIES_CLAUDE_MD` | `1` に設定すると、`--add-dir` で指定したディレクトリからメモリファイルを読み込みます。`CLAUDE.md`、`.claude/CLAUDE.md`、`.claude/rules/*.md`、`CLAUDE.local.md` を読み込みます。デフォルトでは、追加ディレクトリからメモリファイルは読み込まれません |
| `CLAUDE_CODE_ALT_SCREEN_FULL_REPAINT` | `1` に設定すると、[フルスクリーンレンダリング](/docs/ja/fullscreen)で増分更新を送信する代わりに、毎フレーム画面全体を再描画します。フルスクリーンモードで古いテキストや位置のずれたテキストの断片が表示される場合に使用します。Windows では、バックグラウンドセッションと[エージェントビュー](/docs/ja/agent-view)に対して Claude Code がこれを自動的に有効にします |
| `CLAUDE_CODE_ALWAYS_ENABLE_EFFORT` | `1` に設定すると、Claude Code がモデル ID を effort 対応として認識しない場合でも、すべてのリクエストで [effort](/docs/ja/model-config#adjust-effort-level) パラメーターを送信します。カスタム識別子でモデルを提供する [LLM ゲートウェイ](/docs/ja/llm-gateway)やサードパーティプロバイダー経由でルーティングする場合に使用します。Claude 3 モデル、Sonnet 4.0 と 4.5、Opus 4.0 と 4.1、Haiku 4.5 など、API で effort パラメーターを拒否するモデルは、リクエストが失敗しないよう引き続き除外されます |
| `CLAUDE_CODE_API_KEY_HELPER_TTL_MS` | 認証情報を更新する間隔（ミリ秒）（[`apiKeyHelper`](/docs/ja/settings-reference#apikeyhelper) を使用する場合） |
| `CLAUDE_CODE_ARTIFACT_AUTO_OPEN` | `0` に設定すると、新しい[アーティファクト](/docs/ja/artifacts#create-an-artifact)が公開されたときに Claude Code がブラウザを自動的に開かないようにします |
| `CLAUDE_CODE_ARTIFACT_COMMENTS` | `0` に設定すると、Claude が[アーティファクトへのコメント](/docs/ja/artifacts#collect-comments-on-an-artifact)を読んで返信しないようにします。`CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC` によって[アーティファクトがオフになっている](/docs/ja/artifacts#availability)場合は効果がありません。Claude Code v2.1.221 以降が必要です |
| `CLAUDE_CODE_ARTIFACT_COMMENTS_AUTOREACT` | `0` に設定すると、Claude が[送信されたコメントに自ら返信する](/docs/ja/artifacts#let-claude-reply-to-comments-on-its-own)のを停止します。Claude Code v2.1.228 以降が必要です |
| `CLAUDE_CODE_ATTRIBUTION_HEADER` | `0` に設定すると、クライアントのバージョンとプロンプトのフィンガープリントを含む[帰属ブロック](/docs/ja/llm-gateway-protocol#system-prompt-attribution-block)をシステムプロンプトの先頭から省略します。いずれの場合も、Anthropic API への直接接続でのキャッシュには影響しません。一部の直接接続の構成では、`0` を設定しても、Claude Code は [auto モード](/docs/ja/permission-modes#eliminate-prompts-with-auto-mode)の分類器リクエストでこのブロックを保持します。これが対象とする接続と認証情報については、[システムプロンプトの帰属ブロック](/docs/ja/llm-gateway-protocol#system-prompt-attribution-block)を確認してください。v2.1.181 より前は、カスタムベース URL と Microsoft Foundry 接続ではこのブロックにリクエストごとのトークンが含まれていたため、これらのバージョンでは、LLM ゲートウェイがリクエストボディに基づいてキャッシュする場合、リクエストをサードパーティプロバイダーに転送する場合、または Microsoft Foundry に直接接続する場合に `0` に設定してください |
| `CLAUDE_CODE_AUTO_BACKGROUND_WORKER_CHECKIN_SECONDS` | v2.1.283 で削除されました。代わりに `CLAUDE_CODE_WORKER_CHECKIN_SCHEDULE` を使用してください |
| `CLAUDE_CODE_AUTO_COMPACT_WINDOW` | [自動圧縮ウィンドウ](/docs/ja/model-config#set-the-auto-compact-window)をトークン数で `100000` から `1000000` の範囲で設定します。`500000` のようなプレーンな整数のみ受け付けます。`500k` のような値は `500` として読み取られ、最小値の 100K に制限されます。実効ウィンドウはモデルのコンテキストウィンドウによっても制限されます。`/autocompact` コマンド、`--autocompact` フラグ、`autoCompactWindow` 設定より優先されます。ステータスラインの `used_percentage` は常にモデルのコンテキストウィンドウ全体に対して測定されるため、この変数を設定すると、そのパーセンテージは圧縮が実行されるタイミングを示さなくなります |
| `CLAUDE_CODE_AUTO_CONNECT_IDE` | 自動 [IDE 接続](/docs/ja/vs-code)を上書きします。デフォルトでは、サポートされている IDE の統合ターミナル内で起動すると、Claude Code は自動的に接続します。これを防ぐには `false` に設定します。tmux が親ターミナルを隠している場合など、自動検出が失敗したときに接続を強制的に試行するには `true` に設定します。[`autoConnectIde`](/docs/ja/settings-reference#autoconnectide) グローバル設定より優先されます |
| `CLAUDE_CODE_AUTO_MODE_SERVER` | Claude Code がサーバーに [auto モードのアクションのレビュー](/docs/ja/permission-modes#server-side-classifier-review)を依頼するかどうかを制御します。代わりに Claude Code 独自の分類器リクエストを使用するには `0` に設定します。Anthropic API への直接接続では v2.1.281 以降が必要です。リンク先のセクションに、変数が未設定の場合にどのセッションがサーバーに依頼するか、またどのバージョンからかが記載されています。Claude Code v2.1.271 以降が必要です |
| `CLAUDE_CODE_AWS_CHAIN_RESOLVE_TIMEOUT_MS` | AWS のデフォルト認証情報プロバイダーチェーンが認証情報を生成するまで Claude Code が待機する時間（ミリ秒）。この時間を過ぎると、リクエストは [`AWS default-chain credential resolve timed out`](/docs/ja/errors#aws-default-chain-credential-resolve-timed-out) で失敗します（デフォルト：`60000`）。`aws-vault` のようなラッパーを介した MFA 付きのブラウザベースの SSO サインインなど、チェーン内のステップに正当により長い時間が必要な場合は、値を引き上げてください。Claude Code がデフォルトチェーンで署名するすべての場所（[Amazon Bedrock](/docs/ja/amazon-bedrock#credential-caching-and-resolution-timeout)、[Claude Platform on AWS](/docs/ja/claude-platform-on-aws)、[Mantle エンドポイント](/docs/ja/amazon-bedrock#use-the-mantle-endpoint)）に適用されます。Claude Code v2.1.207 以降が必要です |
| `CLAUDE_CODE_BASH_EDIT_DIFF` | `0` に設定すると [Bash コマンドの実行中に変更されたファイルの差分](/docs/ja/hooks#bash)をオフにし、`1` に設定するとすべての権限モードで差分を記録します。[`bashEditDiffEnabled`](/docs/ja/settings-reference#basheditdiffenabled) 設定より優先されます。Claude Code v2.1.269 以降が必要です |
| `CLAUDE_CODE_BG_TASKS_REPORT_RUNNING` | `0` に設定すると、バックグラウンド作業がまだ実行中であっても、非対話セッションがターンの終了ごとにホストにアイドルステータスを報告するようになります。デフォルトでは、バックグラウンドエージェントや[ワークフロー](/docs/ja/workflows)の実行などのバックグラウンド作業がまだ動作している間、セッションはターン終了後も実行中ステータスを報告し続けます。これにより、リモートセッションリストなど、ステータスを監視するホストが、作業の途中で Claude がユーザーの入力を待っていると通知するのを防ぎます。開発サーバーなどのバックグラウンドシェルコマンドは、実行中ステータスを保持しません。実行中ステータスのデフォルトと `0` によるオプトアウトには Claude Code v2.1.269 以降が必要です。それより前のバージョンでは、実行中ステータスを保持するには `1` を設定します |
| `CLAUDE_CODE_BRIDGE_SESSION_ID` | セッションにアクティブな [Remote Control](/docs/ja/remote-control) 接続がある間、Bash ツールと[フックコマンド](/docs/ja/hooks)のサブプロセスで自動的に設定され、接続が終了すると削除されます。値は `session_` 形式のセッション ID で、セッションの `claude.ai/code` URL に表示されるのと同じ識別子です。これにより、スクリプトは自身を実行したセッションへのリンクを作成できます。Claude Code v2.1.199 以降が必要です。[クラウドセッション](/docs/ja/claude-code-on-the-web)では、代わりに `CLAUDE_CODE_REMOTE_SESSION_ID` を読み取ってください |
| `CLAUDE_CODE_BS_AS_CTRL_BACKSPACE` | `0` に設定すると、Claude Code は `0x08` バイト（`^H` とも表記）を通常の Backspace として読み取り、`1` に設定すると Ctrl+Backspace として読み取ります。どちらの値もプラットフォームのデフォルトを置き換えます。デフォルトでは、Claude Code は Windows では Ctrl+Backspace として読み取り（ただし `TERM_PROGRAM` が `mintty` の場合や `TERM` が `cygwin` の場合を除く）、macOS と Linux では通常の Backspace として読み取ります。[Backspace で単語全体が削除される](/docs/ja/terminal-config#fix-backspace-deleting-a-whole-word-on-windows) Windows ターミナルでは `0` を設定してください |
| `CLAUDE_CODE_CERT_STORE` | TLS 接続用の CA 証明書ソースのカンマ区切りリスト。`bundled` は Claude Code に同梱されている Mozilla の CA セットです。`system` はオペレーティングシステムのトラストストアで、`tls.getCACertificates` を備えたランタイム（ネイティブバイナリ、または npm インストールの場合は Node 22.15 以降）でのみ読み取られます。[CA 証明書ストア](/docs/ja/network-config#ca-certificate-store)を参照してください。デフォルトは `bundled,system` です |
| `CLAUDE_CODE_CHILD_SESSION` | Bash、PowerShell、Monitor ツール、[フック](/docs/ja/hooks)コマンド、[ステータスライン](/docs/ja/statusline)コマンドを介して Claude Code が起動するサブプロセスで `1` に設定されます。stdio [MCP サーバー](/docs/ja/mcp)のサブプロセスには設定されません。これらは長時間存続し、起動元のセッションより長く存続するためです。`CLAUDECODE` とは異なり、これは Claude Code 自体がサブプロセスを起動するときにのみ設定され、IDE 拡張機能によっては設定されないため、ネストされたセッションと、IDE 統合ターミナルで起動されたトップレベルの `claude` を確実に区別できます。このように起動されたネストされた対話型の `claude` TUI は、`--resume`、`--continue`、上矢印キーの履歴、`claude agents` のリストから自動的に除外されます。非対話の `claude -p` セッションは引き続き保持されます。この除外を上書きするには `CLAUDE_CODE_FORCE_SESSION_PERSISTENCE=1` を設定します。Claude Code v2.1.172 以降が必要です |
| `CLAUDE_CODE_CLIENT_CERT` | mTLS 認証用のクライアント証明書ファイルへのパス |
| `CLAUDE_CODE_CLIENT_KEY` | mTLS 認証用のクライアント秘密鍵ファイルへのパス |
| `CLAUDE_CODE_CLIENT_KEY_PASSPHRASE` | 暗号化された CLAUDE\_CODE\_CLIENT\_KEY のパスフレーズ（オプション） |
| `CLAUDE_CODE_CONNECT_TIMEOUT_MS` | v2.1.186 で削除され、現在は何も行いません。以前は、ストリーミング API リクエストの接続、TLS、レスポンスヘッダーのフェーズに個別のタイムアウトを設定していました。リクエストごとのタイムアウトには `API_TIMEOUT_MS` を使用してください。ストリーミングリクエストのレスポンスヘッダーのフェーズについては、`CLAUDE_STREAM_FIRST_BYTE_TIMEOUT_MS` を参照してください |
| `CLAUDE_CODE_DEBUG_LOGS_DIR` | デバッグログファイルのパスを上書きします。名前に反して、これはディレクトリではなくファイルパスです。デバッグモードは `--debug`、`/debug`、または `DEBUG` 環境変数で別途有効にする必要があります。この変数を設定しただけではログは有効になりません。[`--debug-file`](/docs/ja/cli-reference#cli-flags) フラグは両方を一度に行います。デフォルトは `~/.claude/debug/<session-id>.txt` です |
| `CLAUDE_CODE_DEBUG_LOG_LEVEL` | デバッグログファイルに書き込まれる最小ログレベル。値：`verbose`、`debug`（デフォルト）、`info`、`warn`、`error`。ステータスラインコマンドの完全な出力など、大量の診断情報を含めるには `verbose` に設定し、ノイズを減らすには `error` に引き上げます |
| `CLAUDE_CODE_DISABLE_1M_CONTEXT` | `1` に設定すると、[1M コンテキストウィンドウ](/docs/ja/model-config#extended-context)のサポートを無効にします。設定すると、モデルピッカーで 1M モデルバリアントが使用できなくなり、[Sonnet 5.5](/docs/ja/model-config#sonnet-5-5-and-sonnet-5-context-window) や Fable モデルなど、ネイティブで 1M ウィンドウを持つモデルのセッションを、Claude Code は 200K ウィンドウに抑えます。この制限の適用方法については[拡張コンテキスト](/docs/ja/model-config#extended-context)を参照してください。コンプライアンス要件のあるエンタープライズ環境で役立ちます。認識されない `[1m]` モデル ID のウィンドウを補正する際の役割については、[ゲートウェイまたはカスタムモデル ID のウィンドウを補正する](/docs/ja/model-config#correct-the-window-for-a-gateway-or-custom-model-id)を参照してください |
| `CLAUDE_CODE_DISABLE_ADAPTIVE_THINKING` | `1` に設定すると、Opus 4.6 と Sonnet 4.6 で[適応型推論](/docs/ja/model-config#adjust-effort-level)を無効にし、`MAX_THINKING_TOKENS` で制御される固定の思考予算にフォールバックします。常に適応型推論を使用する [Fable モデル](/docs/ja/model-config#extended-thinking)、Sonnet 5 以降、Opus 4.7 以降には効果がありません |
| `CLAUDE_CODE_DISABLE_ADMIN_ENV_UNION` | `1` に設定すると、Claude Code が管理者ソース間で[管理設定](/docs/ja/managed-settings#precedence-within-the-managed-tier)の `env` ブロックをキーごとにマージしないようにします。これにより、v2.1.223 より前と同様に、優先順位が最も高いソースの `env` ブロック全体のみが適用されます。Claude Code は設定の `env` ブロックを通じて渡されたコピーを無視するため、Claude Code を起動する環境で設定してください。Claude Code v2.1.223 以降が必要です |
| `CLAUDE_CODE_DISABLE_ADVISOR_TOOL` | `1` に設定すると、[アドバイザーツール](/docs/ja/advisor)を無効にします。`/advisor` コマンドが使用できなくなり、設定済みの `advisorModel` は無視され、`--advisor` フラグは受け付けられますが効果はありません。そのため、このフラグを渡す既存のスクリプトはエラーなしで動作し続けます |
| `CLAUDE_CODE_DISABLE_AGENT_VIEW` | `1` に設定すると、[バックグラウンドエージェントとエージェントビュー](/docs/ja/agent-view)（`claude agents`、`--bg`、`/background`、オンデマンドのスーパーバイザー）をオフにします。[`disableAgentView`](/docs/ja/settings-reference#disableagentview) 設定と同等です |
| `CLAUDE_CODE_DISABLE_ALTERNATE_SCREEN` | `1` に設定すると、[フルスクリーンレンダリング](/docs/ja/fullscreen)を無効にし、従来のメイン画面レンダラーを使用します。会話はターミナルのネイティブのスクロールバックに残るため、`Cmd+f` や tmux のコピーモードが通常どおり機能します。`CLAUDE_CODE_NO_FLICKER` と [`tui`](/docs/ja/settings-reference#tui) 設定より優先されます。`/tui default` で切り替えることもできます。常にフルスクリーンレンダリングを使用する、[エージェントビュー](/docs/ja/agent-view)から開いたバックグラウンドセッションには適用されません |
| `CLAUDE_CODE_DISABLE_ARTIFACT` | `1` に設定すると、セッションの出力を claude.ai 上のプライベートな Web ページとして公開する [Artifact](/docs/ja/artifacts) ツールをオフにします。一度設定すると、どの設定ファイルでもツールを再びオンにすることはできません。代わりに設定ファイルからツールをオフにするには、[`enableArtifact`](/docs/ja/settings-reference#enableartifact) を `false` に設定します。非推奨の [`disableArtifact`](/docs/ja/settings-reference#disableartifact) キーでもオフにできます |
| `CLAUDE_CODE_DISABLE_ATTACHMENTS` | `1` に設定すると、添付ファイルの処理を無効にします。`@` 構文によるファイルメンションは、ファイルの内容に展開されず、プレーンテキストとして送信されます |
| `CLAUDE_CODE_DISABLE_AUTH_REFRESH_LOCK` | `1` に設定すると、別のプロセスが [`gcpAuthRefresh`](/docs/ja/settings-reference#gcpauthrefresh) または [`awsAuthRefresh`](/docs/ja/settings-reference#awsauthrefresh) コマンドを実行している間待機するのではなく、Claude Code プロセスがそのコマンドを自ら実行するようになります。Claude Code v2.1.286 以降が必要です |
| `CLAUDE_CODE_DISABLE_AUTO_MEMORY` | `1` に設定すると、[自動メモリ](/docs/ja/memory#auto-memory)を無効にします。`0` に設定すると、`--bare` モードや [`autoMemoryEnabled: false`](/docs/ja/settings-reference#automemoryenabled) によって無効になる場合でも、自動メモリを強制的にオンにします。無効にすると、Claude は自動メモリファイルを作成も読み込みもしません |
| `CLAUDE_CODE_DISABLE_BACKGROUND_TASKS` | `1` に設定すると、Bash ツールとサブエージェントツールの `run_in_background` パラメーター、自動バックグラウンド化、Ctrl+B ショートカットを含む、すべてのバックグラウンドタスク機能を無効にします |
| `CLAUDE_CODE_DISABLE_BEDROCK_CONTENT_TYPE_DEFAULT` | `1` に設定すると、`Content-Type` ヘッダーが欠落しているか空の [Amazon Bedrock](/docs/ja/amazon-bedrock) ストリーミングレスポンスを、Claude Code が Amazon Bedrock のバイナリイベントストリームとして扱わないようにします。デフォルトでは、Claude Code は、ゲートウェイがそれ以外は変更されていないレスポンスからヘッダーを削除したとみなすため、ボディをデコードし、ストリーミングは機能し続けます。これは、ストリームをサーバー送信イベントとして再出力するゲートウェイの場合にのみ設定してください。その場合、Claude Code はヘッダーのないボディをサーバー送信イベントとして読み取ります。Claude Code v2.1.239 以降が必要です |
| `CLAUDE_CODE_DISABLE_BEDROCK_CONTENT_TYPE_GUARD` | `1` に設定すると、[Amazon Bedrock](/docs/ja/amazon-bedrock) のストリーミングレスポンスが `application/vnd.amazon.eventstream` の content-type を持っているかどうかのチェックをスキップします。この変数がない場合、レスポンスが異なる content-type を持っていると、Claude Code はその型を示すエラーでリクエストを失敗させます。これは[ゲートウェイまたはプロキシがレスポンスを変換している](/docs/ja/amazon-bedrock#streaming-errors-behind-a-gateway-or-proxy)ことを意味します。この変数を設定するのではなく、`Content-Type` ヘッダーとボディを変更せずに転送するようゲートウェイを設定してください。Claude Code v2.1.208 以降が必要です |
| `CLAUDE_CODE_DISABLE_BG_EXIT_HANDOFF` | `1` に設定すると、[スーパーバイザー](/docs/ja/agent-view#the-supervisor-process)がセッションのプロセスを停止、再起動、または更新したときに、[バックグラウンドセッション](/docs/ja/agent-view)で実行中のバックグラウンドシェルコマンド、動的ワークフロー、および v2.1.198 以降ではバックグラウンドサブエージェントを、セッションの次のプロセスに引き渡すのではなく停止します。影響するのはこの引き渡しのみです。`←` または [`/background`](/docs/ja/agent-view#from-inside-a-session) でセッションをバックグラウンド化した場合は、進行中の作業が引き続き引き継がれます。`CLAUDE_DISABLE_ADOPT` は両方をオフにします。Claude Code v2.1.196 以降が必要です |
| `CLAUDE_CODE_DISABLE_BG_SHELL_PRESSURE_REAP` | `1` に設定すると、メモリ逼迫時に Claude Code が[バックグラウンドシェルコマンド](/docs/ja/interactive-mode#background-bash-commands)を終了しないようにします。デフォルトでは、macOS と Linux で、オペレーティングシステムが深刻なメモリ逼迫を報告し、セッションがターンやサブエージェントを実行せずに 30 分間アイドル状態だった場合、Claude Code はバックグラウンドシェルを終了します。Windows にはメモリ逼迫のシグナルがないため、この変数は効果がありません。Claude Code v2.1.193 以降が必要です |
| `CLAUDE_CODE_DISABLE_BUNDLED_SKILLS` | `1` に設定すると、Claude Code に含まれる[スキル](/docs/ja/skills)とワークフローを無効にします。バンドルスキルとワークフローは完全に削除され、`/init` などの組み込みコマンドは入力可能なままですが、モデルからは隠されます。`/doctor` も組み込みコマンドと同様に入力可能なままです。これを隠すには、代わりに `DISABLE_DOCTOR_COMMAND` を使用してください。プラグイン、`.claude/skills/`、`.claude/commands/` のスキルは影響を受けません。[`disableBundledSkills`](/docs/ja/settings-reference#disablebundledskills) 設定と同等です |
| `CLAUDE_CODE_DISABLE_CFC_PROMPT` | `1` に設定すると、[Claude in Chrome](/docs/ja/chrome) のブラウザツールを使用可能なまま、システムプロンプトの Chrome セクションと `/claude-in-chrome` [バンドルスキル](/docs/ja/skills#bundled-skills)を省略します。Claude Code を組み込み、独自のブラウザガイダンスを提供するホスト向けです。Claude Code v2.1.257 以降が必要です |
| `CLAUDE_CODE_DISABLE_CLAUDE_MDS` | `1` に設定すると、ユーザー、プロジェクト、自動メモリファイルを含む、すべての CLAUDE.md メモリファイルのコンテキストへの読み込みを防ぎます |
| `CLAUDE_CODE_DISABLE_CRON` | `1` に設定すると、[スケジュールタスク](/docs/ja/scheduled-tasks)を無効にします。`/loop` スキルと cron ツールが使用できなくなり、セッションの途中ですでに実行中のタスクを含め、スケジュール済みのタスクはすべて実行されなくなります |
| `CLAUDE_CODE_DISABLE_DANGEROUS_RM_TIMEOUT` | `1` に設定すると、[クリティカルパスの削除](/docs/ja/permission-modes#critical-paths)プロンプトの時間制限をオフにします。その場合、`auto` モードでは Claude Code はこれらの削除を代わりに分類器に送信し、`bypassPermissions` モードではプロンプトがユーザーの回答を待ちます。Claude Code は設定の `env` ブロックを通じて渡されたコピーを無視するため、Claude Code を起動する環境で設定してください。Claude Code v2.1.281 以降が必要です |
| `CLAUDE_CODE_DISABLE_EXPERIMENTAL_BETAS` | `1` に設定すると、プレリリースの `anthropic-beta` リクエストヘッダー、それと対になるボディフィールド、および `defer_loading` や `eager_input_streaming` などのベータ版ツールスキーマフィールドを API リクエストから除去します。プロキシゲートウェイが `anthropic-beta` ヘッダーに対する `Unexpected value(s)` エラーや `Extra inputs are not permitted` エラーでリクエストを拒否する場合に使用します。[プレリリース機能を無効にする](/docs/ja/llm-gateway-protocol#disable-pre-release-capabilities)に、[MCP ツール検索](/docs/ja/mcp#scale-with-mcp-tool-search)を含め、この変数が削除するものと、Claude Code が引き続き送信するものが記載されています |
| `CLAUDE_CODE_DISABLE_EXPLORE_PLAN_AGENTS` | `1` に設定すると、組み込みの [Explore および Plan サブエージェント](/docs/ja/sub-agents#built-in-subagents)を無効にします。Claude は代わりに検索ツールまたは汎用サブエージェントで探索し、[plan モード](/docs/ja/permission-modes#analyze-before-you-edit-with-plan-mode)は Explore エージェントや Plan エージェントを起動するのではなく、ファイルを直接読み取ります。`Explore` または `Plan` という名前のカスタムサブエージェントは影響を受けません。Agent SDK または非対話モードですべての組み込みサブエージェントタイプを削除するには、代わりに `CLAUDE_AGENT_SDK_DISABLE_BUILTIN_AGENTS` を使用してください。Claude Code v2.1.198 以降が必要です |
| `CLAUDE_CODE_DISABLE_FAST_MODE` | `1` に設定すると、[fast モード](/docs/ja/fast-mode)を無効にします |
| `CLAUDE_CODE_DISABLE_FEEDBACK_SURVEY` | `1` に設定すると、「How is Claude doing?」セッション品質アンケートを無効にします。`DISABLE_TELEMETRY`、`DO_NOT_TRACK`、または `CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC` が設定されている場合も、`CLAUDE_CODE_ENABLE_FEEDBACK_SURVEY_FOR_OTEL` で再度オプトインしない限り、アンケートは無効になります。完全に無効にする代わりにサンプリング率を設定するには、[`feedbackSurveyRate`](/docs/ja/settings-reference#feedbacksurveyrate) 設定を使用します。[セッション品質アンケート](/docs/ja/data-usage#session-quality-surveys)を参照してください |
| `CLAUDE_CODE_DISABLE_FILE_CHECKPOINTING` | `1` に設定すると、ファイルの[チェックポイント機能](/docs/ja/checkpointing)を無効にします。`/rewind` コマンドでコードの変更を復元できなくなります。[`fileCheckpointingEnabled`](/docs/ja/settings-reference#filecheckpointingenabled) 設定を上書きします |
| `CLAUDE_CODE_DISABLE_GIT_INSTRUCTIONS` | `1` に設定すると、組み込みのコミットと PR のワークフロー指示、および git ステータスのスナップショットを Claude のコンテキストから削除します。独自の git ワークフロースキルを使用する場合に便利です。設定すると、[`includeGitInstructions`](/docs/ja/settings-reference#includegitinstructions) 設定より優先されます |
| `CLAUDE_CODE_DISABLE_INLINE_SHELL_RM_PROMPT` | `1` に設定すると、`bash -c 'rm -rf ~'` など `-c` でシェルに渡されたスクリプトを、Claude Code が[クリティカルパス](/docs/ja/permission-modes#removals-inside-nested-commands-and-inline-scripts)の削除について読み取らないようにします。Claude Code はそれらのスクリプト内のシェル変数や位置パラメーターの対象は引き続きチェックし、その他のクリティカルパスのチェックも実行され続けます。Claude Code は設定の `env` ブロックを通じて渡されたコピーを無視するため、Claude Code を起動する環境で設定してください。Claude Code v2.1.288 以降が必要です |
| `CLAUDE_CODE_DISABLE_LEGACY_MODEL_REMAP` | `1` に設定すると、Anthropic API 上で Opus 4.0 と 4.1 が現在の Opus バージョンに自動的に再マッピングされるのを防ぎます。意図的に古いモデルを固定したい場合に使用します。再マッピングは Amazon Bedrock、Google Cloud's Agent Platform、Microsoft Foundry では実行されません |
| `CLAUDE_CODE_DISABLE_MODEL_ACCESS_FALLBACK` | `1` に設定すると、[Amazon Bedrock](/docs/ja/amazon-bedrock#when-a-model-is-disabled-mid-session) および [Google Cloud's Agent Platform](/docs/ja/google-vertex-ai#when-a-model-is-disabled-mid-session) 上で、セッションの途中でアカウントがセッションのモデルへのアクセスを失ったときに、Claude Code が古いモデルに切り替えないようにします。代わりに、拒否されたリクエストは即座に失敗します。設定した[フォールバックモデルチェーン](/docs/ja/model-config#fallback-model-chains)はその拒否時にも切り替わり、[起動時のモデルチェック](/docs/ja/amazon-bedrock#startup-model-checks)も起動時に引き続きフォールバックします。Claude Code v2.1.285 以降が必要です |
| `CLAUDE_CODE_DISABLE_MOUSE` | `1` に設定すると、[フルスクリーンレンダリング](/docs/ja/fullscreen)でのマウストラッキングを無効にします。`PgUp` と `PgDn` によるキーボードスクロールは引き続き機能します。ターミナルのネイティブな選択時コピーの動作を維持するために使用します |
| `CLAUDE_CODE_DISABLE_MOUSE_CLICKS` | `1` に設定すると、マウスホイールのスクロールを維持したまま、[フルスクリーンレンダリング](/docs/ja/fullscreen)でのクリック、ドラッグ、ホバーの処理を無効にします。Claude Code 内でホイールスクロールは機能させたいが、クリックでカーソルを配置したり、ツールの出力を展開したり、リンクを開いたりしたくない場合に使用します。両方が設定されている場合は `CLAUDE_CODE_DISABLE_MOUSE` が優先されます。Claude Code v2.1.195 以降が必要です |
| `CLAUDE_CODE_DISABLE_MTLS_RELOAD_ON_STALE_CONNECTION` | `1` に設定すると、接続のリセットや TLS ハンドシェイクエラーなどの接続レベルのエラーで API リクエストが失敗したときに、Claude Code が [mTLS クライアント証明書と鍵](/docs/ja/network-config#mtls-authentication)を再読み込みしないようにします。再読み込みを無効にすると、Claude Code はローテーションされたファイルを、次に設定を適用するとき、または次回の起動時にのみ読み込みます。Claude Code v2.1.232 以降が必要です |
| `CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC` | `1` などの空でない任意の値に設定すると、自動更新、テレメトリ、エラーレポート、`/feedback` コマンド、[Claude が下書きしたフィードバック](/docs/ja/tools-reference#sendfeedback-tool-behavior)、リリースノート、[PR と MR のステータスバッジ](/docs/ja/interactive-mode#pr-review-status)のチェック、および [fast モード](/docs/ja/fast-mode#use-fast-mode-behind-proxies-and-llm-gateways)のチェックなどの可用性チェックといった、必須ではないネットワークトラフィックを無効にします。また、[プラグインの `command` ソースのバックグラウンド実行](/docs/ja/plugins/loading#when-a-command-source-re-runs)も停止します。これらはネットワークトラフィックではなくローカルコマンドですが、依存関係のインストールをトリガーする可能性があるためです。**ほとんどのオン/オフ変数とは異なり、`0` や `false` に設定してもこのトラフィックは無効になります**。再び許可するには、変数の設定を解除してください。また、機能フラグの取得も無効になるため、[Remote Control](/docs/ja/remote-control#requirements) やその他の[機能フラグの取得を必要とする機能](#features-that-need-feature-flag-fetching)が使用できなくなります。公式プラグインマーケットプレイスの自動インストールは対象外です。これは `CLAUDE_CODE_DISABLE_OFFICIAL_MARKETPLACE_AUTOINSTALL` で無効にしてください。独自のオプトインがある[ゲートウェイモデルの検出](/docs/ja/llm-gateway-connect#add-gateway-models-to-the-model-picker)には影響しません |
| `CLAUDE_CODE_DISABLE_NONSTREAMING_FALLBACK` | `1` に設定すると、ストリーミングリクエストがストリームの途中で失敗したときの非ストリーミングフォールバックを無効にします。代わりに、ストリーミングエラーは再試行レイヤーに伝播されます。プロキシやゲートウェイが原因で、フォールバックによってツールが重複して実行される場合に便利です |
| `CLAUDE_CODE_DISABLE_NOTIFICATION_PRESENCE_CHECK` | `1` に設定すると、ターミナルで入力中またはターミナルにフォーカスしている間でも、`PushNotification` ツールのデスクトップ通知を送信します。デフォルトでは、最近のキーボード操作やターミナルのフォーカスを検出すると、ツールはデスクトップ通知と[モバイルプッシュ](/docs/ja/remote-control#mobile-push-notifications)の両方をスキップします。この変数はそのローカルチェックのみを無効にするため、ユーザーがアクティブであることをサーバーが検出した場合、サーバーは引き続きモバイルプッシュを抑制できます。Claude Code v2.1.193 以降が必要です |
| `CLAUDE_CODE_DISABLE_OFFICIAL_MARKETPLACE_AUTOINSTALL` | `1` に設定すると、公式プラグインマーケットプレイスの自動登録を無効にします。Claude Code は、マーケットプレイスを登録しようとするとき（通常はマシンでの最初の対話型起動時）にこの変数を読み取ります。その時点で変数が設定されている場合、Claude Code は登録を恒久的にスキップします。後で変数の設定を解除しても、スキップは取り消されません。いつでもマーケットプレイスを登録するには、`claude plugin marketplace add anthropics/claude-plugins-official` を実行します |
| `CLAUDE_CODE_DISABLE_PERMISSION_PROMPT_NOTIFY_HOOKS` | `1` に設定すると、Claude Code が権限リクエストを Agent SDK の `canUseTool` コールバックに送信するセッション（Claude Desktop と VS Code 拡張機能が Claude Code をホストする方法）で、Claude Code が[未回答の権限リクエストに対する `Notification` フック](/docs/ja/hooks#notification)を実行しないようにします。ターミナルセッションでは効果がありません。Claude Code v2.1.233 以降が必要です |
| `CLAUDE_CODE_DISABLE_POLICY_SKILLS` | `1` に設定すると、システム全体の管理スキルディレクトリからのスキルの読み込みをスキップします。オペレーターがプロビジョニングしたスキルを読み込むべきでないコンテナや CI のセッションに便利です |
| `CLAUDE_CODE_DISABLE_POWERSHELL_CMD_RM_DENY` | `1` に設定すると、ドライブのルートやホームディレクトリなどの[システムパス](/docs/ja/permission-modes#remove-item-in-powershell)に対する `cmd` 組み込みコマンド `rd`、`rmdir`、`del`、`erase` を拒否する [PowerShell ツール](/docs/ja/tools-reference#powershell-tool)のチェックをオフにします。Claude Code は設定ファイルの `env` ブロック内のこの変数を無視します。Claude Code v2.1.283 以降が必要です |
| `CLAUDE_CODE_DISABLE_REFUSAL_FALLBACK` | `1` に設定すると、[安全性分類器がリクエストを指摘したときの自動モデル切り替え](/docs/ja/model-config#automatic-model-fallback)をオフにします。これは [`switchModelsOnFlag`](/docs/ja/settings-reference#switchmodelsonflag) 設定が制御する動作です |
| `CLAUDE_CODE_DISABLE_STRUCTURED_OUTPUTS` | `1` に設定すると、アップストリームが構造化出力の `output_config.format` フィールドとそれと対になる `anthropic-beta` 値を拒否する [LLM ゲートウェイ](/docs/ja/llm-gateway-protocol#feature-pass-through)向けに、Claude Code がそれらを送信しないようにします。[`CLAUDE_CODE_DISABLE_EXPERIMENTAL_BETAS`](/docs/ja/llm-gateway-protocol#disable-pre-release-capabilities) がオフにするその他のプレリリース機能はオンのままになります。Claude Code v2.1.288 以降が必要です |
| `CLAUDE_CODE_DISABLE_SUBSTITUTION_RM_PROMPT` | `1` に設定すると、`rm -rf "$(pwd)"` のように、対象全体がコマンド置換の出力である再帰的な `rm` に対する[クリティカルパス](/docs/ja/permission-modes#critical-paths)のチェックをオフにします。その他のクリティカルパスのチェックは実行され続けます。Claude Code は設定の `env` ブロックを通じて渡されたコピーを無視するため、Claude Code を起動する環境で設定してください。Claude Code v2.1.281 以降が必要です |
| `CLAUDE_CODE_DISABLE_TERMINAL_TITLE` | `1` に設定すると、会話のコンテキストに基づくターミナルタイトルの自動更新を無効にします。これにより、[セッションタイトルを生成する](/docs/ja/sessions#name-your-sessions)バックグラウンドの small/fast モデルのリクエストもスキップされます |
| `CLAUDE_CODE_DISABLE_THINKING` | `1` に設定すると、API リクエストから `thinking` パラメーターを完全に省略します。これは、このパラメーターを拒否するプロキシやゲートウェイ向けの互換性オプションです。デフォルトで思考するモデルでは、パラメーターを省略してもモデルが思考する場合があります。Anthropic API で[拡張思考](https://platform.claude.com/docs/en/build-with-claude/extended-thinking)を明示的に無効にするには、代わりに `MAX_THINKING_TOKENS=0` を使用してください。Opus 5.5、Sonnet 5.5、Fable モデルは思考をオフにできないため、どちらの変数でも思考はオフになりません。[サードパーティプロバイダー](/docs/ja/third-party-integrations)では、`MAX_THINKING_TOKENS=0` も同様にパラメーターを省略するため、2 つの変数は同じように動作します |
| `CLAUDE_CODE_DISABLE_UNKNOWN_MODEL_WINDOW_ENFORCEMENT` | `1` に設定すると、[LLM ゲートウェイ](/docs/ja/llm-gateway)のエイリアスなど、Claude Code がモデル ID を認識しない場合に、事前の[自動圧縮](/docs/ja/costs#reduce-token-usage)をスキップします。この変数がない場合、Claude Code はその ID に対して想定するコンテキストウィンドウで圧縮します。代わりに `CLAUDE_CODE_MAX_CONTEXT_TOKENS` で想定ウィンドウを補正することもできます。各変数が適用される場合については、[ゲートウェイまたはカスタムモデル ID のウィンドウを補正する](/docs/ja/model-config#correct-the-window-for-a-gateway-or-custom-model-id)を参照してください。Claude Code v2.1.223 以降が必要です |
| `CLAUDE_CODE_DISABLE_VIRTUAL_SCROLL` | `1` に設定すると、[フルスクリーンレンダリング](/docs/ja/fullscreen)での仮想スクロールを無効にし、トランスクリプト内のすべてのメッセージをレンダリングします。フルスクリーンモードでスクロールすると、メッセージが表示されるべき場所に空白の領域が表示される場合に使用します |
| `CLAUDE_CODE_DISABLE_WEB_FETCH` | `1` に設定すると、[WebFetch](/docs/ja/tools-reference#webfetch-tool-behavior) ツールをオフにします。[WebSearch](/docs/ja/tools-reference#websearch-tool-behavior) ツールは引き続き使用できます。Claude Code v2.1.285 以降が必要です |
| `CLAUDE_CODE_DISABLE_WINDOWS_SHELL_LAUNCHER` | `1` に設定すると、Windows で [PowerShell ツール](/docs/ja/tools-reference#powershell-tool)のコマンドを `cmd.exe` ランチャー経由ではなく直接起動します。デフォルトでは、ランチャーにより、[バックグラウンドで実行中](/docs/ja/tools-reference#background-commands)の PowerShell コマンドを、[セッションをバックグラウンド化](/docs/ja/agent-view#from-inside-a-session)したときなどに[セッションの次のプロセスに引き継ぐ](/docs/ja/agent-view#the-supervisor-process)ことができます。この変数を設定すると、バックグラウンド化された PowerShell コマンドはセッションのプロセスが終了したときに停止します。Bash コマンドは影響を受けません。Claude Code v2.1.269 以降が必要です |
| `CLAUDE_CODE_DISABLE_WORKFLOWS` | `1` に設定すると、[ワークフロー](/docs/ja/workflows#turn-workflows-off)を無効にします。[`disableWorkflows`](/docs/ja/settings-reference#disableworkflows) 設定と同等です |
| `CLAUDE_CODE_EFFORT_LEVEL` | サポートされているモデルの effort レベルを設定します。値：`low`、`medium`、`high`、`xhigh`、`max`、またはモデルのデフォルトを使用する `auto`。使用可能なレベルはモデルによって異なります。`--effort`、`/effort`、`modelSettings` 設定と `effortLevel` 設定より優先されます。[`maxEffortLevel`](/docs/ja/settings-reference#maxeffortlevel) の上限は引き続き適用されます。[effort レベルを調整する](/docs/ja/model-config#adjust-effort-level)を参照してください |
| `CLAUDE_CODE_ENABLE_AUTO_MODE` | 古いリリースとの互換性のために受け付けられますが、効果はありません。auto モードは、Amazon Bedrock、Google Cloud's Agent Platform、Microsoft Foundry、サインイン済みの [Claude apps gateway](/docs/ja/claude-apps-gateway) セッションを含むすべてのプロバイダーでデフォルトで利用できます。v2.1.158 から v2.1.206 では、これらのプロバイダーで [auto モード](/docs/ja/permission-modes#eliminate-prompts-with-auto-mode) を利用可能にするために、これを `1` に設定する必要がありました |
| `CLAUDE_CODE_ENABLE_AWAY_SUMMARY` | [セッションの要約](/docs/ja/interactive-mode#session-recap) の利用可否を上書きします。`0` に設定すると、`/config` のトグルに関係なく要約を強制的にオフにします。`1` に設定すると、[`awaySummaryEnabled`](/docs/ja/settings-reference#awaysummaryenabled) が `false` の場合に要約を強制的にオンにします。設定および `/config` のトグルよりも優先されます |
| `CLAUDE_CODE_ENABLE_BACKGROUND_PLUGIN_REFRESH` | `1` に設定すると、[非対話モード](/docs/ja/headless) でバックグラウンドインストールが完了した後、ターンの境界でプラグインの状態を更新します。更新によってセッションの途中でシステムプロンプトが変わり、そのターンの [プロンプトキャッシュ](/docs/ja/prompt-caching) が無効になるため、デフォルトではオフです |
| `CLAUDE_CODE_ENABLE_FEEDBACK_SURVEY_FOR_OTEL` | `1` に設定すると、Anthropic 宛ての必須ではないトラフィックがブロックされている場合に、「How is Claude doing?」セッション品質アンケートを独自の [OpenTelemetry コレクター](/docs/ja/monitoring-usage) にルーティングします。アンケートの評価は、設定したコレクターへの OTEL イベントとしてのみ出力されます。このモードでは、アンケートデータは Anthropic に送信されません。`CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC`、`DISABLE_TELEMETRY`、または `DO_NOT_TRACK` が設定されている場合に適用され、それ以外の場合は効果がありません。`CLAUDE_CODE_DISABLE_FEEDBACK_SURVEY` と組織のプロダクトフィードバックポリシーが優先されます |
| `CLAUDE_CODE_ENABLE_FINE_GRAINED_TOOL_STREAMING` | Claude が生成するのに合わせてツール呼び出しの入力を API からストリーミングするかどうかを制御します。オフの場合、長いファイル書き込みなどの大きなツール入力は Claude が生成を終えた後にのみ届くため、ハングしているように見えることがあります。Anthropic API ではデフォルトで有効です。Amazon Bedrock と Google Cloud's Agent Platform では、デプロイされたコンテナーがサポートしている場合にモデルごとに有効になります。オプトアウトするには `0` に設定します。`ANTHROPIC_BASE_URL`、`ANTHROPIC_VERTEX_BASE_URL`、または `ANTHROPIC_BEDROCK_BASE_URL` を介してプロキシ経由でルーティングする場合に強制的にオンにするには `1` に設定します。Microsoft Foundry および [ゲートウェイ](/docs/ja/llm-gateway) 接続ではデフォルトでオフです |
| `CLAUDE_CODE_ENABLE_GATEWAY_MODEL_DISCOVERY` | `1` に設定すると、`ANTHROPIC_BASE_URL` が LiteLLM、Kong、内部プロキシなどの Anthropic 互換ゲートウェイを指している場合に、ゲートウェイの `/v1/models` エンドポイントから `/model` ピッカーの項目を取得します。共有 API キーを使用するゲートウェイでは、キーがアクセスできるすべてのモデルがすべてのユーザーに表示されてしまうため、デフォルトではオフです。検出されたモデルは、セッションが受け取る [`availableModels`](/docs/ja/settings-reference#availablemodels) 許可リストによって引き続きフィルタリングされます。[ゲートウェイ構成ではサーバー管理設定による配信は利用できない](/docs/ja/server-managed-settings#platform-availability) ため、リストは [MDM または管理設定ファイル](/docs/ja/managed-settings#delivery-mechanisms) を通じて配信してください |
| `CLAUDE_CODE_ENABLE_OPUS_4_7_FAST_MODE` | [fast mode](/docs/ja/fast-mode) のデフォルトが Opus 4.6 から Opus 4.7 に移行した v2.1.142 で削除されました |
| `CLAUDE_CODE_ENABLE_PROMPT_SUGGESTION` | `false` に設定すると、プロンプト入力に表示されるグレーアウトされた予測であるプロンプト候補をオフにします。[`promptSuggestionEnabled`](/docs/ja/settings-reference#promptsuggestionenabled) 設定よりも優先されます。この設定は、`/config` の **Prompt suggestions** トグルが書き込むものです。Claude Code は、[アカウントが使用制限に近づいているか達している間は候補を一時停止します](/docs/ja/interactive-mode#when-claude-code-skips-suggestions)。制限に達するまで候補をオンのままにするには `true` に設定します。Claude Code v2.1.238 以降が必要です。[プロンプト候補](/docs/ja/interactive-mode#prompt-suggestions) を参照してください |
| `CLAUDE_CODE_ENABLE_TASKS` | [タスク追跡ツールを持つセッション](/docs/ja/tools-reference#task-tool-availability) で Claude Code が提供するタスク追跡ツールを選択します。デフォルトでは、Claude Code は Task ツール `TaskCreate`、`TaskUpdate`、`TaskGet`、`TaskList` を提供します。代わりに従来の `TodoWrite` ツールを使用するには `0` に設定します。[タスクリスト](/docs/ja/interactive-mode#task-list) を参照してください |
| `CLAUDE_CODE_ENABLE_TELEMETRY` | `1` に設定すると、メトリクスとログ記録のための OpenTelemetry データ収集を有効にします。OTel エクスポーターを設定する前に必要です。シェル、ユーザー設定、または管理設定で設定してください。[プロジェクト設定およびローカル設定](/docs/ja/settings-reference#variables-claude-code-ignores-in-env) では無視されます。[モニタリング](/docs/ja/monitoring-usage) を参照してください |
| `CLAUDE_CODE_ENABLE_TODO_TOOLS` | `1` に設定すると、すべてのモデルでタスク追跡ツールを使用できるようになります。設定しない場合、Claude Code はデフォルトで [Task ツールの利用可否](/docs/ja/tools-reference#task-tool-availability) に記載されているモデルでのみこれらのツールを提供します。`CLAUDE_CODE_ENABLE_TASKS` は引き続き Task ツールと `TodoWrite` のどちらを使うかを選択します。Claude Code v2.1.233 以降が必要です |
| `CLAUDE_CODE_EXIT_AFTER_STOP_DELAY` | クエリループがアイドル状態になってから自動的に終了するまでの待機時間（ミリ秒）。SDK モードを使用する自動化ワークフローやスクリプトで役立ちます |
| `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS` | `1` に設定すると、[エージェントチーム](/docs/ja/agent-teams) を有効にします。エージェントチームは実験的な機能で、デフォルトでは無効です |
| `CLAUDE_CODE_EXTRA_BODY` | すべての API リクエストボディのトップレベルにマージする JSON オブジェクト。Claude Code が直接公開していないプロバイダー固有のパラメーターを渡すのに役立ちます。シェルでエクスポートした値は、`claude agents` または `--bg` でディスパッチする [バックグラウンドセッション](/docs/ja/agent-view) にも適用されます。v2.1.206 より前は、バックグラウンドセッションはシェルでエクスポートされた値を無視し、バックグラウンドスーパーバイザープロセスが継承したコピーを使用していました |
| `CLAUDE_CODE_FILE_READ_MAX_OUTPUT_TOKENS` | ファイル読み取りのデフォルトのトークン制限を上書きします。大きなファイルを全体的に読み取る必要がある場合に役立ちます |
| `CLAUDE_CODE_FORCE_SESSION_PERSISTENCE` | `1` に設定すると、この `claude` が別の Claude Code セッション内から起動された場合でも、トランスクリプトの永続化、プロンプト履歴、`claude agents` への登録を強制します。`screen` セッションや、Claude Code の Bash ツールによって最初に起動されたバックグラウンドランチャーなどから継承された `CLAUDE_CODE_CHILD_SESSION` の値によって、本来のトップレベルセッションがネストされたセッションと誤分類される場合に使用します。v2.1.178 以降、Claude Code は tmux の場合を自動的に検出して継承されたマーカーを無視するため、tmux ではこの変数は不要になりました。v2.1.169 以前でも有効です。この変数が上書きするネストされたセッションの検出が削除されていた v2.1.170 と v2.1.171 では効果がありません |
| `CLAUDE_CODE_FORCE_STRIKETHROUGH` | `1` に設定すると、`TERM_PROGRAM` が転送されない SSH 経由など、ターミナルが取り消し線をサポートしているにもかかわらず自動検出されない場合に、Claude の応答内の `~~text~~` を強制的に取り消し線で表示します。これを設定しない場合、検出されないターミナルではテキストが取り消し線で表示されず、`~~` マーカーがそのまま表示されます。Claude Code v2.1.186 以降が必要です |
| `CLAUDE_CODE_FORCE_SYNC_OUTPUT` | `1` に設定すると、ターミナルがサポートしているにもかかわらず自動検出されない場合に、DEC プライベートモード 2026 の [同期出力](https://gist.github.com/christianparpart/d8a62cc1ab659194337d73e399004036) を強制的に有効にします。BSU/ESU を実装しているものの機能プローブに応答しない Emacs `eat` などのエミュレーターで役立ちます。tmux 下では効果がありません。[フルスクリーンレンダリング](/docs/ja/fullscreen) に切り替える `CLAUDE_CODE_NO_FLICKER` とは異なり、これはレンダラーを変更しません |
| `CLAUDE_CODE_FORK_SUBAGENT` | [フォークモード](/docs/ja/sub-agents#turn-fork-mode-on-or-off) を制御します。フォークモードでは Claude 自身が [フォークされたサブエージェント](/docs/ja/sub-agents#fork-the-current-conversation) を生成でき、対話セッションでのみデフォルトでオンです。`claude -p` と Agent SDK でもオンにするには `1` に、すべての種類のセッションでオフにするには `0` に設定します。`/subtask` はフォークモードがオンかどうかに関係なく実行できます。対話セッションでのデフォルトには Claude Code v2.1.232 以降が必要です。それより前のバージョンでは、フォークモードをオンにするには変数を `1` に設定してください |
| `CLAUDE_CODE_FORWARD_SUBAGENT_TEXT` | `1` に設定すると、`claude -p --output-format stream-json` の出力に [サブエージェント](/docs/ja/sub-agents) のテキストブロックと思考ブロックを出力します。[`--forward-subagent-text`](/docs/ja/cli-reference#cli-flags) フラグと同じ動作です。ハーネスが `claude` を呼び出し、フラグ自体を渡せない場合にこの変数を使用します。stream-json 出力を伴う非対話モード以外ではエラーで終了するフラグとは異なり、変数はそれ以外の場合には無視されるため、プロセス全体に設定した場合でもネストされた呼び出しは引き続き動作します。Claude Code v2.1.211 以降が必要です |
| `CLAUDE_CODE_GATEWAY_HINT_HEADERS` | `1` に設定すると、カスタムプロキシ、または Amazon Bedrock や Claude Platform on AWS などのサードパーティプロバイダーで、`x-claude-code-request-class` や `x-claude-code-compaction` などの [ゲートウェイヒントヘッダー](/docs/ja/llm-gateway-protocol#gateway-hint-headers) を送信します。`0` に設定すると、Claude Code がデフォルトでこれらを送信する Anthropic API への直接接続を含む、すべての接続で送信を停止します。Claude Code v2.1.273 以降が必要です |
| `CLAUDE_CODE_GATEWAY_MODEL_DISCOVERY_TIMEOUT_MS` | `CLAUDE_CODE_ENABLE_GATEWAY_MODEL_DISCOVERY` がオンにする [ゲートウェイモデル検出](/docs/ja/llm-gateway-protocol#model-discovery) リクエストのタイムアウト（ミリ秒）（デフォルト: `3000`）。起動時にゲートウェイが `/v1/models` に応答するのに 3 秒より長くかかる場合は引き上げてください。数字のみを受け付けます。`0`、負の値、その他の表記ではデフォルトが維持されます。Claude Code v2.1.269 以降が必要です |
| `CLAUDE_CODE_GIT_BASH_PATH` | Windows のみ: Git Bash 実行ファイル（`bash.exe`）へのパス。Git Bash がインストールされているものの PATH にない場合に使用します。パスが存在しないか、ファイル名が `bash.exe`、`sh.exe`、`bash`、`sh` のいずれでもない場合、Claude Code はこの変数を無視し、未設定の場合と同様に Git Bash を自動検出して、`--debug` で確認できる警告をログに記録します。v2.1.219 より前は、パスが存在しない場合に Claude Code は起動時に終了し、既存のファイルであれば bash または sh であることを確認せずにシェルとして使用していました。[Windows でのセットアップ](/docs/ja/setup#set-up-on-windows) を参照してください |
| `CLAUDE_CODE_GLOB_HIDDEN` | `false` に設定すると、Claude が [Glob ツール](/docs/ja/tools-reference#glob-tool-behavior) を呼び出したときの結果からドットファイルを除外します。デフォルトでは含まれます。`@` ファイルのオートコンプリート、`ls`、Grep、Read には影響しません |
| `CLAUDE_CODE_GLOB_NO_IGNORE` | `false` に設定すると、[Glob ツール](/docs/ja/tools-reference#glob-tool-behavior) が `.gitignore` パターンに従うようになります。デフォルトでは、Glob は gitignore されたファイルを含む、一致するすべてのファイルを返します。独自の [`respectGitignore` 設定](/docs/ja/settings-reference#respectgitignore) を持つ `@` ファイルのオートコンプリートには影響しません |
| `CLAUDE_CODE_GLOB_TIMEOUT_SECONDS` | Glob ツールによるファイル検出のタイムアウト（秒）。ほとんどのプラットフォームではデフォルトで 20 秒、WSL では 60 秒です |
| `CLAUDE_CODE_GOAL_CHECKIN_MINUTES` | Claude Code が [Claude に確認を求める](/docs/ja/goal#background-work-defers-evaluation) までに、バックグラウンド作業がアクティブなゴールを待機させておける時間（分）。デフォルトは `30` です。チェックインをオフにするには `0` を設定します。分単位の整数を数字のみで、最大 `10080`（1 週間）まで指定してください。それ以外の値は未設定として扱われ、デフォルトが使用されます。Claude Code v2.1.234 以降が必要です |
| `CLAUDE_CODE_HIDE_CWD` | `1` に設定すると、起動時のロゴに作業ディレクトリを表示しません。パスから OS のユーザー名がわかってしまう画面共有や録画で役立ちます |
| `CLAUDE_CODE_IDE_HOST_OVERRIDE` | IDE 拡張機能への接続に使用するホストアドレスを上書きします。デフォルトでは、Claude Code は WSL から Windows へのルーティングを含め、正しいアドレスを自動検出します |
| `CLAUDE_CODE_IDE_SKIP_AUTO_INSTALL` | `1` に設定すると、IDE 拡張機能の自動インストールをスキップします。[`autoInstallIdeExtension`](/docs/ja/settings-reference#autoinstallideextension) を `false` に設定するのと同等です |
| `CLAUDE_CODE_IDE_SKIP_VALID_CHECK` | `1` に設定すると、接続時の IDE ロックファイルエントリの検証をスキップします。IDE が実行中にもかかわらず自動接続で見つからない場合に使用します |
| `CLAUDE_CODE_MAX_CONCURRENT_SUBAGENTS` | Agent ツールが新たな生成を拒否するまでに、1 つのセッションで同時に実行できる [サブエージェント](/docs/ja/sub-agents#concurrent-subagent-limit) の数（デフォルト: 20）。数字のみの正の整数を受け付けます。それ以外は無視されるため、この変数で上限を調整することはできますが、無効にすることはできません。Claude Code v2.1.217 以降が必要です |
| `CLAUDE_CODE_MAX_CONTEXT_TOKENS` | アクティブなモデルに対して Claude Code が想定するコンテキストウィンドウのサイズを上書きします。v2.1.193 以降、適用方法は Claude Code がモデル ID をどのように解決するかによって異なります。[ゲートウェイまたはカスタムモデル ID のウィンドウを修正する](/docs/ja/model-config#correct-the-window-for-a-gateway-or-custom-model-id) を参照してください。`ANTHROPIC_BASE_URL` を介してルーティングするモデルのコンテキストウィンドウが、その名前に対応する組み込みのサイズと一致しない場合に使用します |
| `CLAUDE_CODE_MAX_MCP_DESCRIPTION_LENGTH` | Claude Code がモデルに送信する各 MCP ツールの説明と各 MCP サーバーの指示の最大長（文字数）（デフォルト: 2048）。Claude Code は [それより長いテキストを切り詰めます](/docs/ja/mcp#for-mcp-server-authors)。数字のみの正の整数を受け付けます。それ以外は無視され、デフォルトが適用されます。Claude Code v2.1.280 以降が必要です |
| `CLAUDE_CODE_MAX_OUTPUT_TOKENS` | ほとんどのリクエストにおける出力トークンの最大数を設定します。デフォルトと上限はモデルによって異なります。[最大出力トークン](https://platform.claude.com/docs/en/about-claude/models/overview#latest-models-comparison) を参照してください。モデルの上限を超える値は、Claude Code によって上限まで引き下げられます。Claude Code が既知のモデルに解決できないモデル ID の場合、デフォルトは 32000、上限は 128000 です。この値を増やすと、[自動圧縮](/docs/ja/costs#reduce-token-usage) がトリガーされるまでに使用できる実効コンテキストウィンドウが減少します |
| `CLAUDE_CODE_MAX_RETRIES` | 失敗した API リクエストを再試行する回数を上書きします（デフォルト: 10）。v2.1.186 以降は 15 が上限です。v2.1.199 以降は、`CLAUDE_CODE_RETRY_WATCHDOG` によってデフォルトが引き上げられ、上限が撤廃されます。より長い障害を待ち続ける必要がある無人セッションでは、代わりに `CLAUDE_CODE_RETRY_WATCHDOG` を設定してください |
| `CLAUDE_CODE_MAX_SUBAGENTS_PER_SESSION` | v2.1.224 で削除され、現在は何もしません。以前は、1 つのセッションで Claude が Agent ツールを使って生成できる [サブエージェント](/docs/ja/sub-agents) の総数を制限していました（デフォルト: 200）。上限を超えて生成しようとすると `Subagent spawn limit reached` で失敗していました。[同時実行サブエージェントの制限](/docs/ja/sub-agents#concurrent-subagent-limit) と [深さの制限](/docs/ja/sub-agents#let-subagents-spawn-their-own-subagents) は引き続き適用されます |
| `CLAUDE_CODE_MAX_SUBAGENT_SPAWN_DEPTH` | メインの会話の下に許可される [サブエージェントの階層](/docs/ja/sub-agents#let-subagents-spawn-their-own-subagents) の数（デフォルト: 3）。デフォルトでは、サブエージェントは独自のサブエージェントを生成でき、3 番目の階層にあるサブエージェントはそれ以上生成できません。ネストをオフにするには `1` を設定します。v2.1.217 から v2.1.218 ではデフォルトが 1 だったため、制限を引き上げない限り、サブエージェントは独自のサブエージェントを生成できませんでした。v2.1.219 でデフォルトが 3 に引き上げられました。数字のみの正の整数を受け付けます。それ以外は無視されるため、制限は調整できますが撤廃はできません。Claude Code v2.1.217 以降が必要です |
| `CLAUDE_CODE_MAX_TOOL_USE_CONCURRENCY` | 並列実行できる読み取り専用ツールとサブエージェントの最大数（デフォルト: 10）。値を大きくすると並列性が高まりますが、より多くのリソースを消費します |
| `CLAUDE_CODE_MAX_TURNS` | 明示的な制限が渡されていない場合に、エージェントのターン数に上限を設けます。[`--max-turns`](/docs/ja/cli-reference#cli-flags) を渡すのと同等で、両方が設定されている場合はフラグが優先されます。正の整数でない値は、上限なしとして扱われるのではなく、起動時にエラーとして拒否されます |
| `CLAUDE_CODE_MAX_WEB_SEARCHES_PER_SESSION` | 1 つのセッションで実行できる [WebSearch](/docs/ja/tools-reference#websearch-tool-behavior) 呼び出しの総数の上限（デフォルト: 200）。Claude が上限に達すると、以降の WebSearch 呼び出しは、すでに収集した情報で続行するよう指示する通知を返します。上限のない正の整数を受け付けます。それ以外は無視されてデフォルトが適用されるため、上限は引き上げられますがオフにはできません。Claude Code v2.1.212 以降が必要です |
| `CLAUDE_CODE_MCP_ALLOWLIST_ENV` | `1` に設定すると、シェル環境を継承する代わりに、安全な基本環境とサーバーに設定された `env` のみで stdio MCP サーバーを起動します |
| `CLAUDE_CODE_MCP_AUTO_BACKGROUND_MS` | 実行中の MCP ツール呼び出しが [バックグラウンドタスクに移行する](/docs/ja/mcp#automatic-backgrounding-of-long-tool-calls) までの経過時間（ミリ秒）（デフォルト: 120000、つまり 2 分）。自動バックグラウンド化をオフにするには `0` に設定します。Claude Code v2.1.212 以降が必要です |
| `CLAUDE_CODE_MCP_STARTUP_WAIT_MS` | [非対話](/docs/ja/headless) セッションの最初のターンが、まだ接続中の MCP サーバーを待機する時間（ミリ秒）。デフォルトの [最初のターンの待機](/docs/ja/agent-sdk/mcp#connection-timing) の代わりに使用されます。設定すると、待機はすべての保留中のサーバーに適用されます。待機をスキップするには `0` に設定します。[`--permission-prompt-tool`](/docs/ja/cli-reference#cli-flags) サーバーは、値に関係なく独自の `MCP_TIMEOUT` の待機を維持します。Claude Code v2.1.274 以降が必要です |
| `CLAUDE_CODE_MCP_TOOL_IDLE_TIMEOUT` | MCP ツール呼び出しのアイドルタイムアウト（ミリ秒）。stdio、HTTP、SSE、WebSocket、または [claude.ai コネクタ](/docs/ja/mcp#use-mcp-servers-from-claude-ai) の MCP サーバーがこの時間、応答も進捗通知も送信しない場合、ツール呼び出しは全体の `MCP_TOOL_TIMEOUT` を待たずにエラーで中止されます。ネットワークサーバーの 300000（5 分）、stdio サーバーの 1800000（30 分）というトランスポートごとのデフォルトを上書きします。アイドルチェックを無効にするには `0` に設定します。1000 未満の値は 1 秒に引き上げられ、値は有効な `MCP_TOOL_TIMEOUT` が上限となります。`.mcp.json` でサーバーごとに 1000 以上の `timeout` を設定すると、そのサーバーのアイドル時間枠は少なくとも `timeout` の値まで引き上げられます。IDE サーバーや SDK のインプロセスサーバーには適用されません。Claude Code v2.1.187 以降が必要です。v2.1.203 より前は、stdio サーバーはアイドルタイムアウトの対象外でした |
| `CLAUDE_CODE_MESSAGING_SOCKET` | ユーザーではなく Claude Code によって設定されます。[受信ボックスソケット](/docs/ja/cross-session-messaging#the-sessions-inbox-socket) をバインドするセッションでは、Claude Code はソケットをバインドする際に、そのソケットのパスをフックと Bash コマンドにエクスポートします。メッセージングがオンの状態で開始されたセッションでは、Claude Code はフックが実行される前にソケットをバインドします。マシン上の他のセッションは、このパスにメッセージを配信します。各セッションは親から継承したソケットではなく独自のソケットをエクスポートし、そこに届いたメッセージはセッションの [受信制御](/docs/ja/cross-session-messaging#control-inbound-messages) を経由します。設定の `env` ブロックでは設定できません。Claude Code v2.1.224 以降が必要です |
| `CLAUDE_CODE_MESSAGING_TOKEN` | ユーザーではなく Claude Code によって設定されます。[受信ボックスソケット](/docs/ja/cross-session-messaging#the-sessions-inbox-socket) をバインドするセッションでは、Claude Code はこのセッションごとのトークンを `CLAUDE_CODE_MESSAGING_SOCKET` とともにフックと Bash コマンドにエクスポートします。ソケットに投稿するスクリプトは、最初の行として `{"type":"auth","token":"<token>"}` を送信することで、そのセッションに属していることを証明できます。ネイティブ Windows では、Claude Code はこの行を必須とし、有効な行で始まらない接続を閉じます。Claude Code がトークンを参照するタイミングについては、[自身の子プロセスに関するルール](/docs/ja/cross-session-messaging#the-sessions-inbox-socket) を参照してください。各セッションは独自のトークンをエクスポートし、親セッションから継承したトークンをエクスポートすることはありません。設定の `env` ブロックでは設定できません。Claude Code v2.1.228 以降が必要です |
| `CLAUDE_CODE_NATIVE_CURSOR` | `1` に設定すると、描画されたブロックの代わりに、ターミナル自身のカーソルを入力キャレットの位置に表示します。カーソルはターミナルの点滅、形状、フォーカスの設定に従います |
| `CLAUDE_CODE_NEW_INIT` | `1` に設定すると、`/init` で対話的なセットアップフローを実行します。このフローでは、コードベースを探索してファイルを書き込む前に、CLAUDE.md、スキル、フックなど、どのファイルを生成するかを尋ねます。この変数がない場合、`/init` は確認なしで CLAUDE.md を自動的に生成します |
| `CLAUDE_CODE_NONBLOCKING_STDOUT` | `1` に設定すると、2 つ目のノンブロッキングファイルディスクリプタを通じてターミナル出力を書き込みます。これにより、一時停止した tmux コントロールモードのペインや停止した SSH 接続など、読み取りを停止したターミナルによって Claude Code がセッションの途中でフリーズすることを防ぎます。stdout がターミナルの場合に、macOS、Linux、WSL で適用されます。Claude Code v2.1.261 以降が必要です |
| `CLAUDE_CODE_NONSTREAMING_TIMEOUT_RETRIES` | タイムアウトした [非ストリーミングリクエスト](/docs/ja/errors#streaming-response-ended-before-any-complete-data-was-received) を Claude Code が再送信する回数を制限します。`0` の場合、リクエストは最初のタイムアウトで失敗します。デフォルトでは未設定のため、`CLAUDE_CODE_MAX_RETRIES` がこれらの再送信を制限します。タイムアウトについては [再試行の動作を調整する](/docs/ja/errors#tune-retry-behavior) を参照してください。Claude Code v2.1.285 以降が必要です |
| `CLAUDE_CODE_NO_FLICKER` | `1` に設定すると、[フルスクリーンレンダリング](/docs/ja/fullscreen) を有効にします。これは、ちらつきを軽減し、長い会話でもメモリ使用量を一定に保つリサーチプレビューです。[`tui`](/docs/ja/settings-reference#tui) 設定を上書きします。`/tui fullscreen` で切り替えることもできます |
| `CLAUDE_CODE_OAUTH_REFRESH_TOKEN` | Claude.ai 認証用の OAuth リフレッシュトークン。設定すると、`claude auth login` はブラウザを開く代わりにこのトークンを直接交換します。`CLAUDE_CODE_OAUTH_SCOPES` が必要です。自動化された環境で認証をプロビジョニングするのに役立ちます |
| `CLAUDE_CODE_OAUTH_SCOPES` | リフレッシュトークンの発行時に指定された、スペース区切りの OAuth スコープ（`"user:profile user:inference user:sessions:claude_code"` など）。`CLAUDE_CODE_OAUTH_REFRESH_TOKEN` を設定する場合に必須です |
| `CLAUDE_CODE_OAUTH_TOKEN` | claude.ai 認証用の OAuth アクセストークン。SDK や自動化された環境で `/login` の代わりに使用します。キーチェーンに保存された認証情報よりも優先されます。[`claude setup-token`](/docs/ja/authentication#generate-a-long-lived-token) で生成します。[`/login`](/docs/ja/authentication#authentication-precedence) を実行しない限り、Claude Code はセッション全体で設定したトークンを使用します。期限切れのトークンを置き換えるには、新しいトークンを生成して再起動してください |
| `CLAUDE_CODE_OPUS_4_6_FAST_MODE_OVERRIDE` | v2.1.160 で削除され、現在は何もしません。以前は、[fast mode](/docs/ja/fast-mode) を現在のデフォルトではなく Claude Opus 4.6 に固定していました。Opus 4.6 は fast mode をサポートしなくなりました |
| `CLAUDE_CODE_OTEL_CONTENT_MAX_LENGTH` | コンテンツを含む OpenTelemetry 属性（モデルの応答、ツールのコンテンツ、システムプロンプト、未加工の API ボディ）の最大長。切り詰めマーカーを含み、UTF-16 コード単位で指定します（デフォルト: 61440、つまり 60 KB）。テレメトリバックエンドが 64 KB を超える属性値を受け付ける場合にのみ引き上げるか、テレメトリの量を減らすために引き下げてください。Claude Code v2.1.214 以降が必要です。[モニタリング](/docs/ja/monitoring-usage) を参照してください |
| `CLAUDE_CODE_OTEL_DIAG_STDERR` | `1` に設定すると、OpenTelemetry エクスポーターの診断エラーを stderr に書き込みます。デフォルトではこれらのエラーは `--debug` を指定した場合にのみ表示されるため、Prometheus のポート競合などの誤設定されたエクスポーターは、通常は何も表示せずに失敗します。Claude Code v2.1.179 以降が必要です。[モニタリング](/docs/ja/monitoring-usage) を参照してください |
| `CLAUDE_CODE_OTEL_FLUSH_TIMEOUT_MS` | 保留中の OpenTelemetry スパンをフラッシュする際のタイムアウト（ミリ秒）（デフォルト: 5000）。[モニタリング](/docs/ja/monitoring-usage) を参照してください |
| `CLAUDE_CODE_OTEL_HEADERS_HELPER_DEBOUNCE_MS` | 動的な OpenTelemetry ヘッダーを更新する間隔（ミリ秒）（デフォルト: 1740000 / 29 分）。[動的ヘッダー](/docs/ja/monitoring-usage#dynamic-headers) を参照してください |
| `CLAUDE_CODE_OTEL_SHUTDOWN_TIMEOUT_MS` | シャットダウン時に OpenTelemetry エクスポーターが完了するまでのタイムアウト（ミリ秒）（デフォルト: 2000）。終了時にメトリクスが失われる場合は増やしてください。[モニタリング](/docs/ja/monitoring-usage) を参照してください |
| `CLAUDE_CODE_PACKAGE_MANAGER_AUTO_UPDATE` | `1` に設定すると、新しいバージョンが利用可能になったときに、Claude Code がパッケージマネージャーのアップグレードコマンドをバックグラウンドで実行できるようになります。Homebrew と WinGet でのインストールに適用されます。その他のパッケージマネージャーでは、引き続きアップグレードコマンドが表示されるだけで、実行はされません。[自動更新](/docs/ja/setup#auto-updates) を参照してください |
| `CLAUDE_CODE_PERFORCE_MODE` | `1` に設定すると、Perforce 対応の書き込み保護を有効にします。設定すると、対象ファイルに所有者の書き込みビットがない場合、Edit、Write、NotebookEdit は `p4 edit <file>` のヒントとともに失敗します。Perforce は、同期したファイルについて `p4 edit` で開くまでこのビットをクリアします。これにより、Claude Code が Perforce の変更追跡をバイパスすることを防ぎます |
| `CLAUDE_CODE_PLUGIN_CACHE_DIR` | プラグインのルートディレクトリを上書きします。名前に反して、これはキャッシュ自体ではなく親ディレクトリを設定します。マーケットプレイスとプラグインキャッシュは、このパスの下のサブディレクトリに配置されます。デフォルトは `~/.claude/plugins` です |
| `CLAUDE_CODE_PLUGIN_DIRS` | セッションで読み込むプラグインディレクトリ。それぞれ [`--plugin-dir`](/docs/ja/plugins/cli-reference#flags-that-load-a-plugin-for-one-session) フラグと同じ方法で読み込まれます。複数のパスは、Unix では `:`、Windows では `;` で区切ります。Claude Code は相対パスをスキップするため、各パスは絶対パスで指定するか `~` で始めてください。Claude Code v2.1.280 以降が必要です。[1 つのセッションでプラグインを読み込む](/docs/ja/plugins/create#load-a-directory-or-archive-for-one-session) を参照してください |
| `CLAUDE_CODE_PLUGIN_GIT_TIMEOUT_MS` | プラグインマーケットプレイスのクローンまたは更新のタイムアウト（ミリ秒）（デフォルト: 120000）。大きなリポジトリや低速なネットワーク接続の場合は、この値を増やしてください。[Git clone timed out](/docs/ja/plugins/troubleshooting#git-clone-timed-out-after-120s) を参照してください |
| `CLAUDE_CODE_PLUGIN_KEEP_MARKETPLACE_ON_FAILURE` | `1` に設定すると、マーケットプレイスの更新でリモートに到達できないか認証できない場合に、再クローンの試行をスキップし、既存のマーケットプレイスのチェックアウトを引き続き使用します。再クローンも同様に失敗するオフライン環境やエアギャップ環境で役立ちます。[オフライン環境でマーケットプレイスの更新が失敗する](/docs/ja/plugins/troubleshooting#marketplace-updates-keep-failing-offline) を参照してください |
| `CLAUDE_CODE_PLUGIN_PREFER_HTTPS` | `1` に設定すると、GitHub の `owner/repo` 短縮形のソースを SSH ではなく HTTPS でクローンします。プラグインのインストールと更新、および `/plugin marketplace add` と `update` に適用されます。CI ランナー、コンテナー、または `github.com` 用の SSH キーが設定されていない環境で役立ちます |
| `CLAUDE_CODE_PLUGIN_SEED_DIR` | 1 つ以上の読み取り専用プラグインシードディレクトリへのパス。Unix では `:`、Windows では `;` で区切ります。事前に準備したプラグインディレクトリをコンテナーイメージにバンドルするために使用します。Claude Code は起動時にこれらのディレクトリからマーケットプレイスを登録し、事前にキャッシュされたプラグインを再クローンせずに使用します。[コンテナー用にプラグインを事前準備する](/docs/ja/plugins/org#seed-containers-and-ci) を参照してください |
| `CLAUDE_CODE_POWERSHELL_RESPECT_EXECUTION_POLICY` | `1` に設定すると、ツール呼び出し、フック、ステータスラインのコマンドのために PowerShell を起動する際に Claude Code が `-ExecutionPolicy Bypass` を渡すのを停止し、代わりにマシンの有効な実行ポリシーに従います。デフォルトでは、Claude Code はプロセススコープで実行ポリシーをバイパスするため、デフォルトで Restricted になっている Windows 環境でも `.ps1` スクリプトやモジュールのインポートが動作します。プロセススコープのバイパスは、この設定に関係なく、グループポリシーの `MachinePolicy` や `UserPolicy` を上書きすることはありません |
| `CLAUDE_CODE_PRINT_BG_WAIT_CEILING_MS` | `-p` フラグを使用した [非対話モード](/docs/ja/headless#background-tasks-at-exit) で、最後のターンの後にサブエージェントやワークフローなどのバックグラウンド作業をアイドル状態で待機する時間の上限（ミリ秒）。Claude がバックグラウンドの結果を処理するためにターンを実行するたびに、アイドル待機は最初からやり直されます。デフォルト: `600000`、つまり 10 分。アイドル待機が上限に達すると、Claude Code は残りのバックグラウンドタスクの待機を停止して終了します。無期限に待機するには `0` に設定します。この上限は、通常のバックグラウンドシェルに適用される 5 秒の猶予期間とは別のものです。Claude Code v2.1.182 以降が必要です |
| `CLAUDE_CODE_PROCESS_WRAPPER` | [エージェントビュー](/docs/ja/agent-view) セッションをホストするバックグラウンドサービスなど、Claude Code が自身のバイナリから開始するプロセスを、`/opt/corp/launcher` のような argv プレフィックスとして指定した企業ランチャーを通じて起動します。切り離されたバックグラウンドサービスが継承できるように、シェルでのエクスポートではなく、ユーザー設定または [管理設定](/docs/ja/managed-settings) の `env` ブロックで設定してください。プロジェクト設定とローカル設定では設定できません。[`processWrapper` 設定](/docs/ja/settings-reference#processwrapper) と同等です。この設定には Claude Code v2.1.210 以降が必要で、両方が設定されている場合はこの変数が優先されます。VS Code 拡張機能は、独自の `claudeProcessWrapper` 設定を通じて独自のランチャーを別途設定します。Windows では無視されます。値の形式、ランチャーの適用範囲、ランチャーが満たす必要のある要件については、[企業ランチャーの背後で Claude Code を実行する](/docs/ja/corporate-launcher) を参照してください。Claude Code v2.1.208 以降が必要です |
| `CLAUDE_CODE_PROJECT_DIR_NAME` | `CLAUDE_CONFIG_DIR` と一緒に設定して、Claude Code がそのセッションのトランスクリプトと自動メモリを保存する `projects/` ディレクトリの名前を、作業ディレクトリのパスから導出される名前の代わりに指定します。たとえば、`CLAUDE_CONFIG_DIR=/srv/tenant-a CLAUDE_CODE_PROJECT_DIR_NAME=work claude` で Claude Code を起動すると、`/srv/tenant-a/projects/work/` の下に保存されます。`CLAUDE_CONFIG_DIR` が未設定の場合、Claude Code はこの変数を無視します。また、この変数は `claude` を起動する環境からのみ読み取られ、[設定ファイルの `env` ブロック](#in-settings-files) からは読み取られません。[プロジェクトディレクトリに自分で名前を付ける](/docs/ja/sessions#name-the-project-directory-yourself) を参照してください。Claude Code v2.1.234 以降が必要です |
| `CLAUDE_CODE_PROMPT_CACHE_TTL` | Claude Code が受け付ける唯一の値である `5m` または `1h` を設定して、メインの会話（対話、`-p`、SDK のターン、およびそれらとインラインで実行されるヘルパー）の [プロンプトキャッシュの TTL](/docs/ja/prompt-caching#cache-lifetime) を選択します。`promptCacheTtl` 設定および `ENABLE_PROMPT_CACHING_1H` よりも優先され、`FORCE_PROMPT_CACHING_5M` によって上書きされます。API は 1 時間のキャッシュ書き込みに高い料金を請求します。Claude Code v2.1.242 以降が必要です |
| `CLAUDE_CODE_PROPAGATE_TRACEPARENT` | `1` に設定すると、`ANTHROPIC_BASE_URL` がカスタムプロキシを指している場合に W3C トレースコンテキストを伝播します。伝播の対象は、モデルおよび HTTP MCP リクエストの `traceparent` ヘッダーと、Bash、PowerShell、フックのサブプロセスの `TRACEPARENT` 環境変数です。デフォルトでは、伝播は Anthropic API に直接接続している場合にのみ有効です。v2.1.152 で追加されました。[トレース（ベータ）](/docs/ja/monitoring-usage#traces-beta) を参照してください |
| `CLAUDE_CODE_PROVIDER_MANAGED_BY_HOST` | Claude Code を組み込み、Claude Code に代わってモデルプロバイダーのルーティングを管理するホストプラットフォームによって設定されます。設定されている場合、Claude Code は設定ファイル内の `CLAUDE_CODE_USE_BEDROCK`、`ANTHROPIC_BASE_URL`、`ANTHROPIC_API_KEY` などのプロバイダー選択、エンドポイント、認証の変数を無視するため、ユーザー設定でホストのルーティングを上書きすることはできません。Claude Code はまた、どの管理ソースから配信されたかにかかわらず、[管理設定](/docs/ja/managed-settings) 内の `model`、`fallbackModel`、`modelOverrides` などのモデル選択キーも無視するため、ホストのモデル設定が古い管理設定のモデル固定よりも優先されます。Claude Code はさらに、管理設定の `env` ブロック内の `ANTHROPIC_MODEL` や `ANTHROPIC_DEFAULT_*_MODEL` ファミリーなどのモデル選択変数も無視します。ただし、管理設定内の [`availableModels`](/docs/ja/model-config#restrict-model-selection) 許可リストは、ホストが独自のものを提供しない限り引き続き適用されます。Claude Code はまた、Amazon Bedrock、Claude Platform on AWS、Google Cloud's Agent Platform、Microsoft Foundry などのサードパーティプロバイダーで通常適用する自動テレメトリオプトアウトもスキップするため、テレメトリは標準の `DISABLE_TELEMETRY` オプトアウトに従います。[API プロバイダー別のデフォルトの動作](/docs/ja/data-usage#default-behaviors-by-api-provider) を参照してください |
| `CLAUDE_CODE_PROXY_RESOLVES_HOSTS` | `1` に設定すると、呼び出し元ではなくプロキシが DNS 解決を実行できるようにします。プロキシがホスト名の解決を処理すべき環境向けのオプトイン設定です |
| `CLAUDE_CODE_REMOTE` | Claude Code が [クラウドセッション](/docs/ja/claude-code-on-the-web) として実行されている場合に、自動的に `true` に設定されます。フックやセットアップスクリプトからこれを読み取って、クラウドセッション内にいるかどうかを検出します |
| `CLAUDE_CODE_REMOTE_SESSION_ID` | [クラウドセッション](/docs/ja/claude-code-on-the-web) で、現在のセッションの ID に自動的に設定されます。これを読み取って、セッションのトランスクリプトへのリンクを作成します。[出力をセッションにリンクする](/docs/ja/cloud-environments#link-output-back-to-the-session) を参照してください |
| `CLAUDE_CODE_RESTRICTED` | `1` に設定すると、[`--restricted`](/docs/ja/cli-reference#cli-flags) を渡した場合と同じく、制限モードでセッションを開始します。Claude Code は、設定ファイルの `env` ブロック内のこの変数を無視します。Claude Code v2.1.248 以降が必要です |
| `CLAUDE_CODE_RESUME_INTERRUPTED_TURN` | `1` に設定すると、前回のセッションがターンの途中で終了した場合に自動的に再開します。SDK モードで使用され、SDK がプロンプトを再送信しなくてもモデルが続行できるようにします。オフにするには、変数の設定を解除するか `0` に設定します。VS Code のチャットパネルについては、[再読み込み後に会話を続ける](/docs/ja/vs-code#continue-conversations-after-a-reload) を参照してください |
| `CLAUDE_CODE_RESUME_INTERRUPTED_TURN_MAX_AGE_MS` | ターンの途中で終了したセッションが再開時に自動的に続行されるための、最後のトランスクリプトメッセージの最大経過時間（ミリ秒）。最後のメッセージがこの上限より古い場合、Claude Code は `CLAUDE_CODE_RESUME_INTERRUPTED_TURN` による自動再開とその `CLAUDE_CODE_RESUME_PROMPT` 継続メッセージをスキップし、セッションはアイドル状態で開始されるため、明示的に続行することになります。未設定または `0` は上限なしを意味します。ただし、最後のリクエストが API エラーで失敗したターンは、そのエラーの発生から 6 時間未満の間のみ再開されます。正の値は、そのようなターンを含むすべてのターンに上限を設けます。負の値や数値以外の値では 1 時間の上限が適用されます。長時間実行されるエージェントの起動スクリプトでこれを設定すると、古いトランスクリプトに対して再起動した際に古いプロンプトが再実行されるのを防げます。対話セッションから会話を引き継いだ [エージェントビュー](/docs/ja/agent-view) セッションがクラッシュして再起動する際は、Claude Code が自ら 1 時間の上限を設定します。Claude Code v2.1.211 以降が必要です |
| `CLAUDE_CODE_RESUME_PROMPT` | `CLAUDE_CODE_RESUME_INTERRUPTED_TURN` が中断されたターンをプロンプトの再送信ではなく続行する場合、または `-p` で [延期されたツール呼び出し](/docs/ja/hooks#defer-a-tool-call-for-later) を再開する場合に、Claude Code が Claude に送信する継続メッセージを上書きします。デフォルトは `Continue from where you left off.` です。空文字列の場合はデフォルトが使用されます |
| `CLAUDE_CODE_RETRY_WATCHDOG` | 評価ハーネス、CI ジョブ、リモートワーカーなどの無人セッションでは `1` に設定します。`429` および `529` の容量エラーを、`CLAUDE_CODE_MAX_RETRIES` 回の試行後に失敗させるのではなく、無期限に再試行します。標準速度のリクエストが、支出制限または使用クレジットの枯渇を報告する `429` を受け取った場合、スケジュールに従ってリセットされる [ゲートウェイの支出上限](/docs/ja/errors#spend-limit-reached) によるものであっても、Claude Code は直ちに失敗します。v2.1.239 より前は、ウォッチドッグはこれらを無期限に再試行していました。fast mode のリクエストについては、[レート制限を処理する](/docs/ja/fast-mode#handle-rate-limits) を参照してください。ウォッチドッグは試行の間に最大 5 分、またはレスポンスにレート制限のリセット時刻が含まれている場合は制限がリセットされるまでバックオフするため、使用制限に達したセッションは残りの期間を待機します。v2.1.199 以降では、サーバーエラー、タイムアウト、接続の切断など、その他の一時的なエラーのデフォルトの再試行回数も 300 回（約 3 時間のバックオフ）に引き上げ、`CLAUDE_CODE_MAX_RETRIES` を明示的に設定した場合の 15 回という上限も撤廃します。Claude Code v2.1.186 以降が必要です |
| `CLAUDE_CODE_SAFE_MODE` | `1` に設定すると、セーフモードで起動します。壊れた設定のトラブルシューティングのために、CLAUDE.md、スキル、プラグイン、フック、MCP サーバー、カスタムコマンドとエージェント、出力スタイル、ワークフロー、カスタムテーマ、カスタムキーボードショートカット、ステータスラインとファイル候補のコマンド、LSP サーバー、自動メモリを読み込みません。管理設定のポリシーは引き続き適用され、ポリシーで設定されたフック、ステータスライン、ファイル候補のコマンドもこれに含まれます。一方、管理プラグイン、管理スキル、管理 CLAUDE.md、ポリシーで設定された MCP サーバーは読み込まれません。[`--safe-mode`](/docs/ja/cli-reference#cli-flags) を渡すのと同等です。直接起動された子プロセスはこの変数を継承します |
| `CLAUDE_CODE_SCRIPT_CAPS` | `CLAUDE_CODE_SUBPROCESS_ENV_SCRUB` が設定されている場合に、特定のスクリプトをセッションごとに呼び出せる回数を制限する JSON オブジェクト。キーはコマンドテキストと照合される部分文字列、値は整数の呼び出し回数の上限です。たとえば、`{"deploy.sh": 2}` は `deploy.sh` の呼び出しを最大 2 回に制限します。照合は部分文字列ベースのため、`./scripts/deploy.sh $(evil)` のようなシェル展開のトリックも上限にカウントされます。`xargs` や `find -exec` による実行時のファンアウトは検出されません。これは多層防御のための制御です |
| `CLAUDE_CODE_SCROLL_SPEED` | [フルスクリーンレンダリング](/docs/ja/fullscreen#mouse-wheel-scrolling) でのマウスホイールのスクロール倍率を設定します。20 までの任意の正の値を受け付けます。すでにホイールイベントを増幅しているターミナルで、加速されたトラックパッドやホイールのスクロールを遅くするための `0.5` など、1 未満の小数値も指定できます。ターミナルが増幅なしでノッチごとに 1 つのホイールイベントを送信する場合は、`vim` に合わせて `3` に設定します。Claude Code が独自のスクロール処理を使用する JetBrains IDE のターミナルでは無視されます |
| `CLAUDE_CODE_SEND_FEEDBACK` | `0` に設定すると、セッションで [Claude が下書きするフィードバック](/docs/ja/tools-reference#sendfeedback-tool-behavior) をオフにします。`1` に設定すると、アカウントがすでにアクセス権を持っている場合にオンにします。この変数自体でアクセス権を付与することはできず、`DISABLE_FEEDBACK_COMMAND` や [`feedbackDrafts`](/docs/ja/settings-reference#feedbackdrafts) 設定の `off` 値など、フィードバックをオフにするその他のスイッチも引き続き適用されます |
| `CLAUDE_CODE_SESSIONEND_HOOKS_TIMEOUT_MS` | [SessionEnd](/docs/ja/hooks#sessionend) フックの時間予算（ミリ秒）を上書きします。この値は、独自の `timeout` を設定していない各フックのタイムアウトにもなります。セッションの終了、`/clear`、対話モードでの `/resume` によるセッションの切り替えに適用されます。デフォルトの予算は 1.5 秒で、設定ファイルで構成されたフックごとの `timeout` の最大値まで、最大 60 秒まで自動的に引き上げられます。プラグインが提供するフックのタイムアウトでは予算は引き上げられません |
| `CLAUDE_CODE_SESSION_ID` | Bash および PowerShell ツールのサブプロセス、[フックコマンド](/docs/ja/hooks) のサブプロセス、stdio [MCP サーバー](/docs/ja/mcp) のサブプロセスで、現在のセッション ID に自動的に設定されます。Bash、PowerShell、フックの場合、これはフックの JSON 入力の `session_id` フィールドと一致し、`/clear` で更新されます。MCP サーバーのサブプロセスは、起動時の ID を保持します。`--resume <session-id>` の場合は再開された ID を受け取り、フックや Bash と一致します。明示的な ID なしの `--continue` または `--resume` の場合は、代わりに最初の起動時の ID を受け取ることがあります。スクリプトや外部ツールを、それらを起動した Claude Code セッションと関連付けるために使用します |
| `CLAUDE_CODE_SHELL` | Claude Code が Bash ツールのコマンドを実行するために使用するシェルを設定します。`bash` または `zsh` バイナリへのパス（例: `/opt/homebrew/bin/bash`）を受け付けます。`fish` などのその他のシェルはサポートされていません。値が動作する `bash` または `zsh` のパスでない場合、Claude Code はそれを無視して自動検出にフォールバックします。自動検出では、`$SHELL` が `bash` または `zsh` を指している場合はそれを使用し、それ以外の場合は `PATH` と標準のインストール場所で最初に見つかった動作する `zsh`、次に `bash` を選択します |
| `CLAUDE_CODE_SHELL_PREFIX` | Claude Code が起動するシェルコマンド（Bash ツールの呼び出し、[フック](/docs/ja/hooks) コマンド、[ステータスライン](/docs/ja/statusline) コマンド、stdio [MCP サーバー](/docs/ja/mcp) の起動コマンド）をラップするコマンドプレフィックス。PowerShell フックと exec 形式のフックはプレフィックスなしで実行されます。ログ記録や監査に役立ちます。`/path/to/logger.sh` のような実行ファイルのパスのみを設定すると、各コマンドは `/path/to/logger.sh '<command>'` として実行されます。ラッパーはコマンドラインを `$1` の単一のシェルクォートされた引数として受け取るため、ラッパーは `exec bash -c "$1"` のように `$1` をシェルで再評価する必要があります。`$1` を実行ファイルのパスそのものとして扱うと、`npx -y <package>` のような引数を渡す stdio MCP サーバーが動作しなくなります。Bash ツールの呼び出しでは、`$1` には Claude が実行したコマンドだけでなく、環境設定を含む、Claude Code が組み立てた完全なシェル呼び出しが含まれます |
| `CLAUDE_CODE_SIMPLE` | `1` に設定すると、最小限のシステムプロンプトと、Bash、ファイル読み取り、ファイル編集ツールのみで実行します。`--mcp-config` からの MCP ツールは引き続き利用できます。フック、スキル、カスタムコマンド、サブエージェント、インストール済みプラグイン、MCP サーバー、自動メモリ、CLAUDE.md の自動検出を無効にします。`--add-dir` で渡したディレクトリ内のスキルは引き続き読み込まれます。OAuth トークンとキーチェーンの認証情報は読み取られないため、Anthropic の認証は `ANTHROPIC_API_KEY` または `--settings` 内の `apiKeyHelper` から行う必要があります。[`--bare`](/docs/ja/headless#start-faster-with-bare-mode) を渡すのと同等です |
| `CLAUDE_CODE_SIMPLE_SYSTEM_PROMPT` | `1` に設定すると、任意のモデルで短いシステムプロンプトと簡略化されたツールの説明を使用します。`0`、`false`、`no`、`off` に設定すると、実験やサーバー設定によって本来有効になるモデルでもオプトアウトします。完全なツールセット、フック、MCP サーバー、CLAUDE.md の検出は有効なままです |
| `CLAUDE_CODE_SKIP_ANTHROPIC_AWS_AUTH` | リクエストに自ら署名するゲートウェイ向けに、[Claude Platform on AWS](/docs/ja/claude-platform-on-aws) のクライアント側認証をスキップします |
| `CLAUDE_CODE_SKIP_AWS_CRED_CACHE` | `1` に設定すると、AWS のデフォルト認証情報プロバイダーチェーンから解決された認証情報のプロセス内キャッシュをオフにし、Claude Code が API リクエストごとにチェーンを解決するようにします。キャッシュがオフの場合、SSO ベースのプロファイルはリクエストごとに IAM Identity Center に認証情報を要求します。[認証情報のキャッシュと解決のタイムアウト](/docs/ja/amazon-bedrock#credential-caching-and-resolution-timeout) を参照してください。Claude Code v2.1.207 以降が必要です |
| `CLAUDE_CODE_SKIP_BEDROCK_AUTH` | Amazon Bedrock の AWS 認証をスキップします（LLM ゲートウェイを使用する場合など） |
| `CLAUDE_CODE_SKIP_FAST_MODE_NETWORK_ERRORS` | `1` に設定すると、チェックによる `api.anthropic.com` への直接リクエストをブロックするネットワーク向けに、失敗した [fast mode](/docs/ja/fast-mode#use-fast-mode-behind-proxies-and-llm-gateways) の利用可否チェックを利用可能として扱います。Claude Code は「組織によって無効化されている」という応答には引き続き従います |
| `CLAUDE_CODE_SKIP_FAST_MODE_ORG_CHECK` | `1` に設定すると、チェックのリクエストを拒否するのではなく傍受するプロキシ向けに、クライアント側の [fast mode](/docs/ja/fast-mode#use-fast-mode-behind-proxies-and-llm-gateways) の利用可否チェックをスキップします。組織で fast mode が無効になっている場合、API は引き続き fast mode のリクエストを拒否します |
| `CLAUDE_CODE_SKIP_FOUNDRY_AUTH` | 独自の `Authorization` ヘッダーを挿入するプロキシまたはゲートウェイ向けに、Microsoft Foundry の Azure 認証をスキップします。Claude Code は Azure の認証情報なしでリクエストを送信し、`ANTHROPIC_CUSTOM_HEADERS` などを通じて指定した `Authorization` ヘッダーを保持します。`ANTHROPIC_FOUNDRY_API_KEY` または `ANTHROPIC_FOUNDRY_AUTH_TOKEN` が設定されている場合は無視されます。v2.1.203 より前は、API キーも設定されていない限り、この変数によって Microsoft Foundry クライアントがリクエストを送信できなくなっていました |
| `CLAUDE_CODE_SKIP_MANTLE_AUTH` | Amazon Bedrock Mantle の AWS 認証をスキップします（LLM ゲートウェイを使用する場合など） |
| `CLAUDE_CODE_SKIP_MODEL_ACCESS_MEMORY` | [Amazon Bedrock](/docs/ja/amazon-bedrock) と [Google Cloud's Agent Platform](/docs/ja/google-vertex-ai) での [起動時のモデルチェック](/docs/ja/amazon-bedrock#startup-model-checks) は、アカウントで呼び出せないことが判明したモデルを、このマシン上で最大 1 日記憶します。`1` に設定すると、この記憶をオフにします。Claude Code v2.1.285 以降が必要です |
| `CLAUDE_CODE_SKIP_PROMPT_HISTORY` | `1` に設定すると、プロンプト履歴とセッションのトランスクリプトのディスクへの書き込みをスキップします。この変数を設定して開始したセッションは、`--resume`、`--continue`、上矢印キーの履歴に表示されません。一時的なスクリプトセッションに役立ちます |
| `CLAUDE_CODE_SKIP_VERTEX_AUTH` | Google Cloud's Agent Platform の Google 認証をスキップします（LLM ゲートウェイを使用する場合など） |
| `CLAUDE_CODE_STARTUP_FAILURE_RESULTS` | `1` に設定すると、`--output-format stream-json` で開始したセッションで、通常は stderr への出力だけで終わる起動失敗について、[Claude Code が起動を拒否した理由を示す result メッセージ](/docs/ja/agent-sdk/typescript#startup_failure_reason) を書き込みます。Claude Code v2.1.274 以降が必要です |
| `CLAUDE_CODE_STOP_HOOK_BLOCK_CAP` | Claude Code がフックを上書きしてターンを終了させるまでに、[Stop](/docs/ja/hooks#stop) または [SubagentStop](/docs/ja/hooks#subagentstop) フックがターンの終了を連続してブロックできる最大回数（デフォルト: 8）。上限を無効にするには `0` に設定します。フックが解決のために正当にそれ以上の反復を必要とする場合は引き上げてください |
| `CLAUDE_CODE_SUBAGENT_MODEL` | 他の方法でモデルが割り当てられていない [サブエージェント](/docs/ja/sub-agents#choose-a-model)、[エージェントチーム](/docs/ja/agent-teams#specify-teammates-and-models) のチームメイト、[ワークフロー](/docs/ja/workflows) エージェントのデフォルトモデル。`haiku` などのエイリアスまたは完全なモデル名を受け付けます。これより優先されるソースが 2 つあります。Claude がエージェントを生成する際に渡すモデルと、`inherit` を含むエージェント定義内の `model` フィールドです。これを変更するには、[`CLAUDE_CODE_SUBAGENT_MODEL_FORCE`](/docs/ja/sub-agents#run-every-subagent-on-one-model) を設定します。完全な優先順位については、[モデルを選択する](/docs/ja/sub-agents#choose-a-model) を参照してください。`inherit` に設定するのは、未設定のままにするのと同じです。v2.1.251 より前は、この変数は呼び出しごとのモデルと定義の `model` フィールドの両方を上書きしていました |
| `CLAUDE_CODE_SUBAGENT_MODEL_FORCE` | `1` に設定すると、サブエージェント、チームメイト、ワークフローエージェントに 1 つのモデルを強制します。それがどのモデルかについては、[すべてのサブエージェントを 1 つのモデルで実行する](/docs/ja/sub-agents#run-every-subagent-on-one-model) を参照してください。Claude Code v2.1.257 以降が必要です |
| `CLAUDE_CODE_SUBAGENT_PROMPT_CACHE_TTL` | Claude Code が受け付ける唯一の値である `5m` または `1h` を設定して、[サブエージェント](/docs/ja/sub-agents)、ワークフロー、バックグラウンド作業など、メインの会話以外のリクエストの [プロンプトキャッシュの TTL](/docs/ja/prompt-caching#cache-lifetime) を選択します。`subagentPromptCacheTtl` 設定および `ENABLE_PROMPT_CACHING_1H` よりも優先され、`FORCE_PROMPT_CACHING_5M` によって上書きされます。API は 1 時間のキャッシュ書き込みに高い料金を請求します。Claude Code v2.1.242 以降が必要です |
| `CLAUDE_CODE_SUBPROCESS_ENV_SCRUB` | `1` に設定すると、Bash コマンド、フック、stdio MCP サーバーなど、Claude Code が開始するサブプロセスの環境から認証情報を削除します。スクラブは変数名または値によって認証情報を識別し、GitHub トークンとプロキシ設定はそのまま残します。[サブプロセス環境のスクラブで削除されるもの](#what-the-subprocess-environment-scrub-removes) を参照してください。`allowed_non_write_users` が設定されている場合、`claude-code-action` はこれを自動的に設定します |
| `CLAUDE_CODE_SYNC_PLUGIN_INSTALL` | 非対話モード（`-p` フラグ）で `1` に設定すると、最初のクエリの前にプラグインのインストールが完了するまで待機します。これを設定しない場合、プラグインはバックグラウンドでインストールされ、最初のターンでは利用できない場合があります。待機時間を制限するには、`CLAUDE_CODE_SYNC_PLUGIN_INSTALL_TIMEOUT_MS` と組み合わせてください |
| `CLAUDE_CODE_SYNC_PLUGIN_INSTALL_TIMEOUT_MS` | 同期プラグインインストールのタイムアウト（ミリ秒）。超過すると、Claude Code はプラグインなしで続行し、エラーをログに記録します。デフォルトはありません。この変数がない場合、同期インストールは完了するまで待機します |
| `CLAUDE_CODE_SYNC_SKILLS` | `-p` フラグを使用した非対話モードで `1` に設定すると、Claude Code はその実行で claude.ai アカウントに対して有効になっているスキルをダウンロードし、最初のクエリを実行する前に、`CLAUDE_CODE_SYNC_SKILLS_WAIT_TIMEOUT_MS` を上限としてスキルのリストを待機します。ダウンロード自体はバックグラウンドで完了し、Claude はスキルを呼び出す際にそのスキルのダウンロードを待機します。claude.ai 認証が必要です。claude.ai アカウントでサインインしたターミナルセッションでは、この変数がなくても、これらのスキルが `~/.claude/skills/synced/` に [ダウンロード](/docs/ja/skills#where-synced-skills-load) され、約 10 分ごとに再同期されます。そのため、`-p` の実行で最初のクエリから最新のスキルが必要な場合にのみ設定してください。v2.1.273 より前は、ターミナルセッションでは、この変数を設定した `-p` の実行でのみスキルがダウンロードされていました。`synced` フォルダ名は [このダウンロード用に予約されています](/docs/ja/skills#where-skills-live)。v2.1.227 より前は、スキルは `~/.claude/skills/` に直接ダウンロードされていました。Claude Code は、マシン上でスキルの `!` コマンドを実行しないなど、[ダウンロードされたスキルに追加のルール](/docs/ja/skills#how-synced-skills-behave) を適用します |
| `CLAUDE_CODE_SYNC_SKILLS_INSTALL_TIMEOUT_MS` | [Agent SDK](/docs/ja/agent-sdk/typescript#query-object) で構築されたアプリがスキルを再読み込みする際に、セッションの途中で実行されるスキルの再同期のタイムアウト（ミリ秒）（デフォルト: 30000）。超過すると、再読み込みはすでに届いたスキルで続行され、残りのダウンロードはバックグラウンドで完了します |
| `CLAUDE_CODE_SYNC_SKILLS_WAIT_TIMEOUT_MS` | `CLAUDE_CODE_SYNC_SKILLS` が設定されている場合に、最初のクエリが初期スキルリストを待機するタイムアウト（ミリ秒）（デフォルト: 5000）。超過すると、最初のクエリはすでに届いたスキルで実行されます。いずれの場合もダウンロードはバックグラウンドで完了し、Claude はスキルを呼び出す際にそのスキルのダウンロードを待機します |
| `CLAUDE_CODE_SYNTAX_HIGHLIGHT` | `false` に設定すると、差分出力のシンタックスハイライトを無効にします。色がターミナルの設定と干渉する場合に役立ちます。コードブロックやファイルプレビューでもハイライトを無効にするには、[`syntaxHighlightingDisabled`](/docs/ja/settings-reference#syntaxhighlightingdisabled) 設定を使用します |
| `CLAUDE_CODE_TASK_LIST_ID` | セッション間でタスクリストを共有します。[Task ツールを持つセッション](/docs/ja/tools-reference#task-tool-availability) で、複数の Claude Code インスタンスに同じ ID を設定すると、共有タスクリストで連携できます。[タスクリスト](/docs/ja/interactive-mode#task-list) を参照してください |
| `CLAUDE_CODE_TEAM_TEARDOWN_PARK_TIMEOUT_MS` | 非対話セッションが終了時に [エージェントチーム](/docs/ja/agent-teams) の破棄が完了するまで待機する時間を、ミリ秒単位で上書きします。1000 から 60000 を受け付けます。範囲外の値は無視され、デフォルトの 10000 が適用されます。Claude Code v2.1.206 以降が必要です |
| `CLAUDE_CODE_TMPDIR` | 内部一時ファイルに使用する一時ディレクトリを上書きします。Claude Code はこのパスに、Unix では `/claude-{uid}/`、Windows では `/claude/` を追加します。デフォルト: macOS では `/tmp`、Linux と Windows では `os.tmpdir()`。macOS と Linux では、一時パスが長すぎると失敗するツールがあるため、上書きしたパスが長い場合、[サンドボックス化された](/docs/ja/sandboxing) Bash サブプロセスにはシステムデフォルト配下の短いフォールバック `$TMPDIR` が渡されます。サンドボックス化されていない Bash コマンドは、シェルの `$TMPDIR` が設定されている場合はそれを継承します。ネイティブ Windows では、シェルが `$TMPDIR` を設定していない場合、`$TMPDIR` を参照する Bash コマンドには上書きした値が渡され、上書きを設定していない場合は `%TEMP%` が渡されます。Claude Code 自身の一時ファイルは常に上書きした値を使用します。シェル、ユーザー設定、または管理設定で設定してください。[プロジェクト設定およびローカル設定](/docs/ja/settings-reference#variables-claude-code-ignores-in-env) では無視されます |
| `CLAUDE_CODE_TMUX_TRUECOLOR` | `1` など、空でない任意の値に設定すると、tmux 内で 24 ビットのトゥルーカラー出力を許可します。ほとんどのオン/オフ変数とは異なり、**`0` や `false` に設定してもトゥルーカラーは許可されます**。256 色への制限に戻すには、変数の設定を解除してください。tmux は設定しない限りトゥルーカラーのエスケープシーケンスを通過させないため、デフォルトでは `$TMUX` が設定されている場合、Claude Code は 256 色に制限します。`~/.tmux.conf` に `set -ga terminal-overrides ',*:Tc'` を追加した後に、これを設定してください。その他の tmux の設定については、[ターミナルの設定](/docs/ja/terminal-config) を参照してください |
| `CLAUDE_CODE_TOOL_MEMORY_CGROUP_EXCLUDE` | Linux と WSL で、Claude Code が [ツールのメモリ上限から除外する](/docs/ja/tools-reference#memory-limit-on-linux-and-wsl) プロセスの種類（`mcp` や `lsp` など）をカンマ区切りのリストで設定します。すべての種類に上限を適用するには `none`、Bash、PowerShell、Monitor ツールのコマンドのみに上限を適用するには `all-new` を設定します。何を指定しても、Claude Code は Bash、PowerShell、Monitor ツールのコマンドを上限の対象として維持します。Claude Code v2.1.246 以降が必要です |
| `CLAUDE_CODE_TOOL_MEMORY_LIMIT` | Linux と WSL で、`4G` などのサイズを設定して [Bash と PowerShell ツールのコマンドが使用できるメモリに上限を設けます](/docs/ja/tools-reference#memory-limit-on-linux-and-wsl)。v2.1.246 以降では Monitor ツールのコマンドも対象になります。サイズは数字のみで記述し、バイト数の場合は数字だけ、それ以外は `K`、`M`、`G`、`T` のサフィックスを付けます。上限をオフにするには `0` または `off` を設定します。Claude Code が開始する最初のプロセスが上限をオンまたはオフにした後は、変更した値は次に `claude` を起動したときに有効になります。Claude Code v2.1.233 以降が必要です |
| `CLAUDE_CODE_TRANSCRIPT_LOCAL_GC` | `1` に設定すると、長時間の `-p` または Agent SDK セッションの [トランスクリプトファイル](/docs/ja/sessions#where-transcripts-are-stored) が大きくなりすぎないよう制限します。各コンテキスト圧縮の後、ファイルが 5 MB を超えている場合、Claude Code はその圧縮より前の履歴を削除します。セッションを再開すると、ファイルが切り詰められたかどうかに関係なく、同じ会話が復元されます。設定の `env` ブロックではオンにできないため、Claude Code を起動する環境で設定してください。Claude Code v2.1.287 以降が必要です |
| `CLAUDE_CODE_USER_DIALOG_TIMEOUT_MS` | [Remote Control](/docs/ja/remote-control) や SDK ホストなどのリモートクライアントに転送するダイアログ、または [保留中のセッション間メッセージ](/docs/ja/cross-session-messaging#control-inbound-messages) の承認ダイアログを、Claude Code がキャンセルするまでの期限（ミリ秒）。権限プロンプトと `AskUserQuestion` の質問は独自のフローを使用するため、この設定の影響を受けません。Claude Code v2.1.236 以降では、無人で実行されている可能性のあるセッションにおける、セッション途中の [Fable 使用クレジットの同意プロンプト](/docs/ja/model-config#fable-and-usage-credits) の期限にもなります。期限が適用されないケースを含む、保留中のメッセージの有効期限に関する完全なルールについては、[受信メッセージを制御する](/docs/ja/cross-session-messaging#control-inbound-messages) と [非対話セッション](/docs/ja/cross-session-messaging#non-interactive-sessions) を参照してください。[`dialogExpiry`](/docs/ja/settings-reference#dialogexpiry) 設定を上書きします。`0` または負の値で期限を無効にします |
| `CLAUDE_CODE_USE_ANTHROPIC_AWS` | [Claude Platform on AWS](/docs/ja/claude-platform-on-aws) を使用します |
| `CLAUDE_CODE_USE_BEDROCK` | [Amazon Bedrock](/docs/ja/amazon-bedrock) を使用します |
| `CLAUDE_CODE_USE_FOUNDRY` | [Microsoft Foundry](/docs/ja/microsoft-foundry) を使用します |
| `CLAUDE_CODE_USE_MANTLE` | Amazon Bedrock の [Mantle エンドポイント](/docs/ja/amazon-bedrock#use-the-mantle-endpoint) を使用します |
| `CLAUDE_CODE_USE_NATIVE_FILE_SEARCH` | `1` に設定すると、ripgrep の代わりに Node.js のファイル API を使用して、カスタムコマンド、サブエージェント、出力スタイルを検出します。バンドルされた ripgrep バイナリが利用できないか、環境でブロックされている場合に設定してください。Grep やファイル検索ツールには影響しません |
| `CLAUDE_CODE_USE_POWERSHELL_TOOL` | PowerShell ツールを制御します。Git Bash のない Windows では、ツールは自動的に有効になります。無効にするには `0` に設定します。Git Bash がインストールされている Windows では、claude.ai および Console アカウントではデフォルトでオンです。Amazon Bedrock、Google Cloud's Agent Platform、Microsoft Foundry のセッションで有効にするには `1` に、オフにするには `0` に設定します。Linux、macOS、WSL では `1` に設定すると有効になり、`PATH` 上に `pwsh` が必要です。Windows で有効にすると、Claude は Git Bash を経由せずに PowerShell コマンドをネイティブに実行できます。[PowerShell ツール](/docs/ja/tools-reference#powershell-tool) を参照してください |
| `CLAUDE_CODE_USE_VERTEX` | [Google Cloud's Agent Platform](/docs/ja/google-vertex-ai) を使用します |
| `CLAUDE_CODE_WEBFETCH_CACHE_TTL_MS` | [WebFetch](/docs/ja/tools-reference#webfetch-tool-behavior) が取得した各 URL のレスポンスをキャッシュに保持する時間をミリ秒単位で設定します。デフォルトは `900000`（15 分）です。数字のみを受け付けます。`0`、小数、その他の表記の場合はデフォルトが維持されます。Claude Code はこの値を起動ごとに 1 回読み込むため、設定の `env` ブロックでの変更は次に `claude` を起動したときに適用されます。Claude Code v2.1.233 以降が必要です |
| `CLAUDE_CODE_WEBFETCH_DEADLINE_MS` | [WebFetch](/docs/ja/tools-reference#webfetch-tool-behavior) がページのダウンロード（追従するリダイレクトを含む）を待機する時間の上限（ミリ秒）。それまでに完了しなかったダウンロードはデッドラインエラーで失敗します。デフォルトは `300000`（5 分）です。`0` に設定すると制限がなくなります。数字のみを受け付けます。小数やその他の表記の場合はデフォルトが維持されます。Claude Code v2.1.268 以降が必要です |
| `CLAUDE_CODE_WORKER_CHECKIN_SCHEDULE` | `CLAUDE_AUTO_BACKGROUND_TASKS` が `1` に設定されている場合に、まだ実行中の[バックグラウンドサブエージェント](/docs/ja/sub-agents#run-subagents-in-foreground-or-background)を確認するよう Claude にリマインドする前に、Claude Code が待機する時間。`1` から `86400` までの整数秒による待機時間を 1 つ以上カンマ区切りで指定します（`600` や `600,1800,3600` など）。各値は次のリマインダーまでの待機時間で、最後の値が繰り返されます。数字のみを受け付けます。その他の値や表記は未設定として扱われます。未設定の場合、リマインダーは送られません。Claude Code v2.1.283 以降が必要です |
| `CLAUDE_CODE_WORKFLOW_MAX_CONCURRENT_AGENTS` | 1 回の[ワークフロー](/docs/ja/workflows)実行で同時に実行するエージェントの数（`1` から `256`）。デフォルトでは、1 回の実行で最大 16 個のエージェントを同時に実行し、Claude Code が利用できる CPU が少ない場合はそれより少なくなります。キューに入った `agent()` 呼び出しは空きスロットを待ちます。実行中の各エージェントのトランスクリプトは Claude Code のメモリに保持されるため、値を大きくするとメモリ使用量が増えます。数字のみを受け付けます。範囲外の値やその他の表記の場合はデフォルトが維持されます。Claude Code v2.1.269 以降が必要です |
| `CLAUDE_CODE_WORKFLOW_PREFIX_STAGGER_MS` | [ワークフロー](/docs/ja/workflows)のエージェントが、自身の最初のリクエストを送信する前に、同じプレフィックスを持つ兄弟エージェントの最初の応答が始まるのを待つ時間の上限（ミリ秒）。ファンアウトで[プロンプトキャッシュのプレフィックス](/docs/ja/workflows#prompt-caching-in-a-fan-out)を共有する複数のエージェントを開始すると、Claude Code は最初のエージェント以外を最大この時間だけ保留し、残りのエージェントがそれぞれキャッシュなしでプレフィックスを処理する代わりに、キャッシュされたプレフィックスを読み取れるようにします。デフォルトは `5000` です。`0` に設定すると待機を無効にします。`DISABLE_PROMPT_CACHING` が設定されている場合、エージェントは待機しません。Claude Code v2.1.229 以降が必要です |
| `CLAUDE_CONFIG_DIR` | 設定ディレクトリを上書きします（デフォルト: `~/.claude`）。すべての設定、セッション履歴、プラグインはこのパスの下に保存されます。認証情報については、[Claude Code が認証情報を保存する場所](/docs/ja/authentication#credential-management)を参照してください。複数のアカウントを並行して実行する場合に便利です。例: `alias claude-work='CLAUDE_CONFIG_DIR=~/.claude-work claude'`。シェル、ユーザー設定、または管理設定で設定します。[プロジェクト設定とローカル設定](/docs/ja/settings-reference#variables-claude-code-ignores-in-env)では無視されます |
| `CLAUDE_DISABLE_ADOPT` | `1` に設定すると、`←` を押すか [`/background`](/docs/ja/agent-view#from-inside-a-session) でセッションをバックグラウンドに移すときに、実行中のバックグラウンド作業を引き継ぐ代わりに停止します。Claude Code はバックグラウンドに移す前に確認を求め、その後、本来引き継がれるはずだったタスクを停止します。Claude Code v2.1.195 以降が必要です |
| `CLAUDE_EFFORT` | Bash ツールのサブプロセスとフックコマンドで、サブプロセスの開始時に有効な [effort レベル](/docs/ja/model-config#adjust-effort-level)（`low`、`medium`、`high`、`xhigh`、または `max`）に自動的に設定されます。[フック](/docs/ja/hooks)に渡される `effort.level` フィールドと一致します。現在のモデルが effort パラメータをサポートしている場合にのみ設定されます |
| `CLAUDE_ENABLE_BYTE_WATCHDOG` | `1` に設定するとバイトレベルのストリーミングアイドルウォッチドッグを強制的に有効にし、`0` に設定すると強制的に無効にします。`0` は、[最初のバイトのデッドライン](/docs/ja/network-config#streaming-idle-watchdogs)が適用される接続で、そのデッドラインもオフにします。未設定の場合、ウォッチドッグは Anthropic API への直接接続と [Claude Platform on AWS](/docs/ja/claude-platform-on-aws) 接続、および `ANTHROPIC_BASE_URL` または `ANTHROPIC_AWS_BASE_URL` を介して到達する[ゲートウェイ](/docs/ja/gateways)接続のストリーミングレスポンスで、デフォルトで有効になります。v2.1.222 より前はこれらのゲートウェイ接続では実行されなかったため、キープアライブ ping が届いている間でも、イベントレベルのウォッチドッグがそこで停止を報告することがありました。タイムアウトとタイマーの相互作用については、[ストリーミングアイドルウォッチドッグ](/docs/ja/network-config#streaming-idle-watchdogs)を参照してください |
| `CLAUDE_ENABLE_BYTE_WATCHDOG_BEDROCK` | `1` に設定すると、Amazon Bedrock の `vnd.amazon.eventstream` レスポンスでバイトレベルのストリーミングアイドルウォッチドッグを有効にします。これにより、Bedrock のストリーミングリクエストで[最初のバイトのデッドライン](/docs/ja/network-config#streaming-idle-watchdogs)も有効になります。デフォルトではオフです。タイムアウトは `CLAUDE_STREAM_IDLE_TIMEOUT_MS` で設定します |
| `CLAUDE_ENABLE_STREAM_WATCHDOG` | `0` に設定するとイベントレベルのストリーミングアイドルウォッチドッグを強制的に無効にし、`1` に設定すると強制的に有効にします。未設定の場合、ウォッチドッグはすべてのプロバイダーでデフォルトでオンになります。v2.1.196 より前は、未設定時のデフォルトは Anthropic API への直接接続ではサーバー側で制御され、その他のプロバイダーではオフでした。タイムアウトは `CLAUDE_STREAM_IDLE_TIMEOUT_MS` で設定します。これと並行して動作するその他の停止タイマーについては、[ストリーミングアイドルウォッチドッグ](/docs/ja/network-config#streaming-idle-watchdogs)を参照してください |
| `CLAUDE_ENV_FILE` | 各 Bash コマンドの前に、Claude Code が同じシェルプロセス内でその内容を実行するシェルスクリプトへのパス。ファイル内の export はコマンドから参照できます。virtualenv や conda の有効化をコマンド間で維持するために使用します。[SessionStart](/docs/ja/hooks#persist-environment-variables)、[Setup](/docs/ja/hooks#setup)、[CwdChanged](/docs/ja/hooks#cwdchanged)、[FileChanged](/docs/ja/hooks#filechanged) フックによっても動的に設定されます |
| `CLAUDE_JOB_DIR` | Claude Code が各[バックグラウンドセッション](/docs/ja/agent-view)で、そのセッションの `~/.claude/jobs/<id>` ディレクトリに設定します。セッションが実行するシェルコマンドはこれを継承します。一時ファイルは [`$CLAUDE_JOB_DIR/tmp`](/docs/ja/agent-view#where-state-is-stored) に書き込みます。そこへの Claude の `Write` および `Edit` 呼び出しでは権限プロンプトが表示されず、ディレクトリはセッションの削除時に削除されます |
| `CLAUDE_PID` | Claude Code は、自身が生成するサブプロセス（Bash および PowerShell ツールのコマンドとフックコマンド）で、これを自身のプロセス ID に設定します。Linux では、Bash ツールのシェル統合がこれを使用して、Claude Code プロセス自体に一致する `pkill` パターンを拒否します。[エラーリファレンス](/docs/ja/errors#pkill-pattern-matches-the-claude-code-process)を参照してください。独自のスクリプトからこれを読み取り、親の Claude Code プロセスを意図的に識別したりシグナルを送ったりできます。Claude Code v2.1.214 以降が必要です |
| `CLAUDE_REMOTE_CONTROL_SESSION_NAME_PREFIX` | 明示的な名前が指定されていない場合に自動生成される [Remote Control](/docs/ja/remote-control) セッション名のプレフィックス。デフォルトはマシンのホスト名で、`myhost-graceful-unicorn` のような名前が生成されます。`--remote-control-session-name-prefix` CLI フラグは、1 回の呼び出しに対して同じ値を設定します |
| `CLAUDE_STREAM_FIRST_BYTE_TIMEOUT_MS` | [最初のバイトのデッドライン](/docs/ja/network-config#streaming-idle-watchdogs)が適用される接続での、ストリーミングリクエストの最初のレスポンスバイトのデッドライン（ミリ秒）。Claude Code がこの値をどのように制限するか、大きなリクエスト本文に対して追加する時間、およびこれを未設定のままにした場合にデッドラインをどのように選択するかについては、[No response from API](/docs/ja/errors#no-response-from-api) を参照してください。Claude Code v2.1.242 以降が必要です |
| `CLAUDE_STREAM_IDLE_TIMEOUT_MS` | イベントレベルおよびバイトレベルのストリーミングアイドルウォッチドッグが、停止した接続を閉じるまでのタイムアウト（ミリ秒）。この変数を明示的に設定する場合、最小値は `300000`（5 分）です。それより小さい値は、拡張思考の一時停止やプロキシのバッファリングを吸収するために通知なしで切り上げられ、バイトレベルのウォッチドッグは値の上限を 30 分とします。バイトレベルのウォッチドッグについては、`CLAUDE_BYTE_STREAM_IDLE_TIMEOUT_MS` がこの変数より優先されます。ウォッチドッグごとの未設定時のデフォルトについては、[ストリーミングアイドルウォッチドッグ](/docs/ja/network-config#streaming-idle-watchdogs)を参照してください |
| `CLAUDE_SUBAGENT_BG_SHELL_MAX_MS` | v2.1.260 で削除され、現在は何も行いません。以前は、[サブエージェント](/docs/ja/sub-agents)が開始した[バックグラウンドシェルコマンド](/docs/ja/interactive-mode#background-bash-commands)の実行可能時間をミリ秒単位で制限しており、デフォルトは 60 分でした。[バックグラウンドコマンドの存続期間のルール](/docs/ja/tools-reference#background-commands)を参照してください |
| `DEBUG` | `1` に設定するとデバッグモードを有効にします。[`--debug`](/docs/ja/cli-reference#cli-flags) で起動するのと同じです。デバッグログは `~/.claude/debug/<session-id>.txt`、または `CLAUDE_CODE_DEBUG_LOGS_DIR` で設定されたパスに書き込まれます。デバッグモードを有効にするのは真値 `1`、`true`、`yes`、`on` のみであるため、他のツール向けに設定された `DEBUG=express:*` のような名前空間パターンではトリガーされません |
| `DISABLE_AUTOUPDATER` | `1` に設定すると、バックグラウンドでの自動更新を無効にします。手動の `claude update` は引き続き機能します。両方をブロックするには `DISABLE_UPDATES` を使用します |
| `DISABLE_AUTO_COMPACT` | `1` に設定すると、コンテキスト制限に近づいたときの自動コンテキスト圧縮を無効にします。手動の `/compact` コマンドは引き続き使用できます。圧縮のタイミングを明示的に制御したい場合に使用します。[`autoCompactEnabled`](/docs/ja/settings-reference#autocompactenabled) 設定を上書きします |
| `DISABLE_COMPACT` | `1` に設定すると、自動圧縮と手動の `/compact` コマンドの両方を含む、すべてのコンテキスト圧縮を無効にします |
| `DISABLE_COST_WARNINGS` | `1` に設定すると、コスト警告メッセージを無効にします |
| `DISABLE_DOCTOR_COMMAND` | `1` に設定すると、[`/doctor`](/docs/ja/commands#all-commands) セットアップチェックアップスキルとそのエイリアス `/checkup` を非表示にします。ユーザーがセッションからセットアップ診断を実行すべきでない管理されたデプロイで便利です。`claude doctor` ターミナルコマンドには影響しません。v2.1.205 より前は、この変数は `/doctor` 診断画面コマンドを非表示にしていました |
| `DISABLE_ERROR_REPORTING` | `1` などの空でない任意の値に設定すると、エラー報告をオプトアウトします。ほとんどのオン/オフ変数とは異なり、**`0` や `false` に設定してもオプトアウトされます**。エラー報告を再度オンにするには、変数の設定を解除します |
| `DISABLE_EXTRA_USAGE_COMMAND` | `1` に設定すると、ユーザーがレート制限を超えて追加の使用量を購入できる `/usage-credits` コマンドを非表示にします |
| `DISABLE_FEEDBACK_COMMAND` | `1` に設定すると、`/feedback` コマンドと [Claude が下書きするフィードバック](/docs/ja/tools-reference#sendfeedback-tool-behavior)を無効にします。同じ経路で報告する `/bug` と `/share` も無効にします。v2.1.212 より前はこれらは `/feedback` のエイリアスだったため、コマンドはどの名前でも無効になっていました。旧名の `DISABLE_BUG_COMMAND` も受け付けられます |
| `DISABLE_GROWTHBOOK` | `1` または `true` に設定すると、GrowthBook の機能フラグの取得を無効にし、すべてのフラグにコードのデフォルトを使用します。これにより、[Remote Control](/docs/ja/remote-control#requirements) およびその他の[機能フラグの取得を必要とする機能](#features-that-need-feature-flag-fetching)が利用できなくなります。`0` または `false` に設定すると、取得はオンのままです。`DISABLE_TELEMETRY` も設定しない限り、テレメトリイベントのログ記録はオンのままです |
| `DISABLE_INSTALLATION_CHECKS` | `1` に設定すると、インストールに関する警告を無効にします。標準的なインストールの問題を隠してしまう可能性があるため、インストール場所を手動で管理する場合にのみ使用してください |
| `DISABLE_INSTALL_GITHUB_APP_COMMAND` | `1` に設定すると、`/install-github-app` コマンドを非表示にします。サードパーティプロバイダー（Amazon Bedrock、Google Cloud's Agent Platform、または Microsoft Foundry）を使用している場合は、すでに非表示になっています |
| `DISABLE_INTERLEAVED_THINKING` | `1` に設定すると、interleaved-thinking ベータヘッダーの送信を防ぎます。LLM ゲートウェイまたはプロバイダーが[インターリーブ思考](https://platform.claude.com/docs/en/build-with-claude/extended-thinking#interleaved-thinking)をサポートしていない場合に便利です |
| `DISABLE_LOGIN_COMMAND` | `1` に設定すると、`/login` コマンドを非表示にします。API キーまたは `apiKeyHelper` によって認証が外部で処理される場合に便利です |
| `DISABLE_LOGOUT_COMMAND` | `1` に設定すると、`/logout` コマンドを非表示にします |
| `DISABLE_PROMPT_CACHING` | `1` に設定すると、すべてのモデルで[プロンプトキャッシュ](/docs/ja/prompt-caching#disable-prompt-caching)を無効にします（モデルごとの設定より優先されます） |
| `DISABLE_PROMPT_CACHING_FABLE` | `1` に設定すると、Fable モデルのプロンプトキャッシュを無効にします |
| `DISABLE_PROMPT_CACHING_HAIKU` | `1` に設定すると、実行場所に関係なく、[デフォルトの Haiku モデル](/docs/ja/prompt-caching#disable-prompt-caching)のプロンプトキャッシュを無効にします |
| `DISABLE_PROMPT_CACHING_OPUS` | `1` に設定すると、[デフォルトの Opus モデル](/docs/ja/prompt-caching#disable-prompt-caching)のプロンプトキャッシュを無効にします |
| `DISABLE_PROMPT_CACHING_SONNET` | `1` に設定すると、[デフォルトの Sonnet モデル](/docs/ja/prompt-caching#disable-prompt-caching)のプロンプトキャッシュを無効にします |
| `DISABLE_TELEMETRY` | `1` などの空でない任意の値に設定すると、テレメトリをオプトアウトします。ほとんどのオン/オフ変数とは異なり、**`0` や `false` に設定してもオプトアウトされます**。テレメトリを再度オンにするには、変数の設定を解除します。テレメトリイベントには、コード、ファイルパス、Bash コマンドなどのユーザーデータは含まれません。[機能フラグの取得](#features-that-need-feature-flag-fetching)も無効にします。[組織のテレメトリをオフにする](/docs/ja/managed-settings#turn-telemetry-off-for-your-organization)を参照してください |
| `DISABLE_UPDATES` | `1` に設定すると、手動の `claude update` と `claude install` を含むすべての更新をブロックします。`DISABLE_AUTOUPDATER` より厳格です。独自の配布経路で Claude Code を配布しており、ユーザーに自己更新させたくない場合に使用します |
| `DISABLE_UPGRADE_COMMAND` | `1` に設定すると、`/upgrade` コマンドを非表示にします |
| `DO_NOT_TRACK` | `1` に設定すると、テレメトリをオプトアウトします。効果は `DISABLE_TELEMETRY` と同じで、[機能フラグの取得](#features-that-need-feature-flag-fetching)への影響も含みます。Claude Code はこの変数を標準的なブール値として読み取るため、`0` ではテレメトリはオンのままです。また、多くの開発者向け CLI で認識されているツール横断の慣例として、この変数を尊重します |
| `ENABLE_BETA_TRACING_DETAILED` | `BETA_TRACING_ENDPOINT` とともに `1` に設定すると、[詳細なベータトレーシング](/docs/ja/monitoring-usage#traces-beta)をオンにします。これにより、コンテンツを含むスパン属性と `claude_code.hook` スパンが追加されます。対話型 CLI セッションでは、組織がベータの許可リストに登録されている必要もあります。両方の変数は[プロジェクト設定とローカル設定](/docs/ja/settings-reference#variables-claude-code-ignores-in-env)では無視されます |
| `ENABLE_CLAUDEAI_MCP_SERVERS` | `false` に設定すると、Claude Code が [claude.ai の MCP サーバー](/docs/ja/mcp#use-mcp-servers-from-claude-ai)を取得しないようにします。ログインしているユーザーに対してはデフォルトで有効です。プロジェクト単位または組織単位で無効にするには、代わりに設定で [`disableClaudeAiConnectors`](/docs/ja/settings-reference#disableclaudeaiconnectors) を設定します |
| `ENABLE_PROMPT_CACHING_1H` | `1` に設定すると、デフォルトの 5 分ではなく 1 時間の[プロンプトキャッシュ TTL](/docs/ja/prompt-caching#cache-lifetime) を要求します。API キー、[Amazon Bedrock](/docs/ja/amazon-bedrock)、[Google Cloud's Agent Platform](/docs/ja/google-vertex-ai)、[Microsoft Foundry](/docs/ja/microsoft-foundry)、[Claude Platform on AWS](/docs/ja/claude-platform-on-aws) のユーザー向けです。含まれる使用量の範囲内にあるサブスクリプションユーザーは、[メインの会話](/docs/ja/prompt-caching#which-ttl-each-request-gets)で自動的に 1 時間の TTL が適用されます。[使用クレジット](https://support.claude.com/en/articles/12429409-extra-usage-for-paid-claude-plans)を消費しているサブスクリプションユーザーは、これを設定して 1 時間の TTL を維持できます。1 時間のキャッシュ書き込みは、より高い料金で課金されます。代わりにリクエストバケットごとに TTL を選択するには、この変数より優先される `CLAUDE_CODE_PROMPT_CACHE_TTL` と `CLAUDE_CODE_SUBAGENT_PROMPT_CACHE_TTL` を使用します |
| `ENABLE_PROMPT_CACHING_1H_BEDROCK` | 非推奨です。代わりに `ENABLE_PROMPT_CACHING_1H` を使用してください |
| `ENABLE_TOOL_SEARCH` | [MCP ツール検索](/docs/ja/mcp#scale-with-mcp-tool-search)を制御します。未設定の場合、Claude Code はデフォルトですべての MCP ツールを遅延読み込みします。ただし、Claude 4.5 世代より前の Google Cloud's Agent Platform のモデル、Azure でホストされている Microsoft Foundry のデプロイ、および `ANTHROPIC_BASE_URL` がファーストパーティ以外のホストを指している場合は、引き続き事前に読み込みます。`true` は、同じ Agent Platform のモデルと Microsoft Foundry のデプロイを除き、常に遅延読み込みしてベータヘッダーを送信します。`tool_reference` をサポートしていないプロキシではリクエストが失敗します。`auto` は、ツール定義がコンテキストの 10% 以内に収まる場合に事前に読み込みます。`auto:N` はカスタムしきい値を設定します（5% の場合は `auto:5` など）。`false` はすべてのツールを事前に読み込みます。`CLAUDE_CODE_DISABLE_EXPERIMENTAL_BETAS` が設定されている場合、ユーザー自身が設定した値は無視されます。v2.1.221 より前は、この変数を `true` に設定しない限り、Claude Code は Google Cloud's Agent Platform のすべてのモデルでツール検索を無効にしていました |
| `FALLBACK_FOR_ALL_PRIMARY_MODELS` | `1` などの空でない任意の値に設定すると、フォールバックモデルが設定されていない場合に、すべてのモデルで過負荷エラーが繰り返されたときに Claude Code が再試行を停止するようにします。ほとんどのオン/オフ変数とは異なり、**`0` や `false` に設定してもこれは有効になります**。デフォルトの再試行動作に戻すには、変数の設定を解除します。この変数がない場合、Claude Code がこの方法で再試行を停止するのは、Claude サブスクリプションではなく API キーまたは[サードパーティプロバイダー](/docs/ja/third-party-integrations)で認証している場合に、Opus、Fable、または Mythos のモデルとして認識するモデルに対してのみです。Claude Code v2.1.160 以降では、任意のプライマリモデルで過負荷エラーが繰り返されると、Claude Code は設定された[フォールバックモデルチェーン](/docs/ja/model-config#fallback-model-chains)に切り替えるため、この変数はフォールバックモデルへの切り替えには影響しません |
| `FORCE_AUTOUPDATE_PLUGINS` | `1` に設定すると、メインの自動アップデーターが `DISABLE_AUTOUPDATER` で無効になっている場合でも、プラグインの自動更新を強制します |
| `FORCE_HYPERLINK` | `1` に設定すると、ターミナルがサポートしているのに自動検出されない場合にクリック可能な OSC 8 ハイパーリンクを有効にし、`0` に設定すると無効にします。未設定の場合、Claude Code はターミナルのサポートを検出したときにのみハイパーリンクを有効にします。Claude Code はこの値をブール値ではなく数値として解析するため、`false`、`no`、`off` などの値はハイパーリンクを無効にするのではなく有効にします。フッターの [PR またはマージリクエストのバッジ](/docs/ja/interactive-mode#pr-review-status)は、SSH 経由など Claude Code がターミナルのサポートを検出できない場合でもハイパーリンクとして表示されます。バッジをプレーンテキストとして表示するには `0` を設定します |
| `FORCE_PROMPT_CACHING_5M` | `1` に設定すると、本来 1 時間の TTL が適用される場合でも、5 分のプロンプトキャッシュ TTL を強制します。`CLAUDE_CODE_PROMPT_CACHE_TTL`、`CLAUDE_CODE_SUBAGENT_PROMPT_CACHE_TTL`、`ENABLE_PROMPT_CACHING_1H`、および `promptCacheTtl` と `subagentPromptCacheTtl` の設定を上書きします |
| `HTTP_PROXY` | ネットワーク接続用の HTTP プロキシサーバーを指定します |
| `HTTPS_PROXY` | ネットワーク接続用の HTTPS プロキシサーバーを指定します |
| `IS_DEMO` | `1` などの空でない任意の値に設定すると、デモモードを有効にします。ヘッダーと `/status` の出力からメールアドレスと組織名を非表示にし、オンボーディングをスキップします。ほとんどのオン/オフ変数とは異なり、**`0` や `false` に設定してもデモモードは有効になります**。オフにするには、変数の設定を解除します。セッションをストリーミング配信または録画する場合に便利です |
| `MAX_MCP_OUTPUT_TOKENS` | MCP ツールのレスポンスで許可される最大トークン数（デフォルト: 25000）。出力が 10,000 トークンを超えると、Claude Code は警告を表示します。[`anthropic/maxResultSizeChars`](/docs/ja/mcp#raise-the-limit-for-a-specific-tool) を宣言しているツールは、テキストコンテンツに対して代わりにその文字数制限を使用しますが、それらのツールからの画像コンテンツには引き続きこの変数が適用されます。そのアノテーションのないツールからの 50,000 文字を超える成功したテキスト結果は、この変数に関係なく[ファイルに保存されます](/docs/ja/mcp#mcp-output-limits-and-warnings) |
| `MAX_STRUCTURED_OUTPUT_RETRIES` | `-p` フラグを使用した非対話モードで、モデルの応答が [`--json-schema`](/docs/ja/cli-reference#cli-flags) に対する検証に失敗した場合に Claude Code が許可する試行回数。その回数だけ失敗して有効な出力が得られない場合、実行は失敗します。[ワークフロー](/docs/ja/workflows)のサブエージェントの構造化出力が検証に失敗した場合にも、同じ上限が適用されます。デフォルトは 5 で、最初の試行と 4 回の再試行です |
| `MAX_THINKING_TOKENS` | [拡張思考](https://platform.claude.com/docs/en/build-with-claude/extended-thinking)の固定トークン予算。Claude Code はこの値を、リクエストの最大出力トークン数より 1 トークン少ない値に制限し、1,024 未満にはしません。その上限の設定方法については、`CLAUDE_CODE_MAX_OUTPUT_TOKENS` を参照してください。未設定で思考が有効な場合、[適応型推論](/docs/ja/model-config#adjust-effort-level)を備えたモデルは独自に思考の深さを選択し、その他のモデルは上限を使用します。`0` に設定すると Anthropic API で思考を無効にします。ただし、Opus 5.5、Sonnet 5.5、および Fable モデルでは思考をオフにできません。[サードパーティプロバイダー](/docs/ja/third-party-integrations)では、`0` は代わりに `thinking` パラメータを省略します。Anthropic API で思考をオフにした場合、Claude Code は、Opus 5 など[その組み合わせを受け付けない](/docs/ja/errors#effort-isnt-available-with-thinking-turned-off)ことがわかっているモデルには、より高いレベルではなく effort `high` を送信します。正の値の場合、`CLAUDE_CODE_DISABLE_ADAPTIVE_THINKING` で適応型推論をオフにしている場合を除き、Claude Code は適応型推論モデルでは数値自体を無視します |
| `MCP_CLIENT_SECRET` | [事前設定された認証情報](/docs/ja/mcp#use-pre-configured-oauth-credentials)を必要とする MCP サーバー用の OAuth クライアントシークレット。`--client-secret` を指定してサーバーを追加する際の対話型プロンプトを回避します |
| `MCP_CONNECTION_NONBLOCKING` | 起動時に、最初のクエリの前に MCP サーバーの接続を待機するかどうかを制御します。MCP の起動はデフォルトでノンブロッキングです。サーバーはバックグラウンドで接続し、接続が完了するとそのツールが利用可能になります。`0` に設定すると、Claude Code は最初のクエリの前にサーバーの接続を待機します。[`alwaysLoad: true`](/docs/ja/mcp#exempt-a-server-from-deferral) で設定されたサーバーは、最初のプロンプトの構築時にツールが存在している必要があるため、[ディスカバリーキャッシュ](/docs/ja/mcp#server-status-detail)から提供される場合を除き、この設定に関係なく起動を待機させます。`--input-format stream-json` を指定しない非対話モード（`-p`）では、Claude Code はこの変数に関係なく、最初のターンの前にまだ保留中のサーバーも待機します。[`--mcp-config`](/docs/ja/cli-reference#cli-flags) を明示的に渡すと、待機のデッドラインが長くなります。キャッシュされたサーバーの例外については、そのフラグの項目を参照してください |
| `MCP_CONNECT_TIMEOUT_MS` | ブロッキングの MCP 起動が、ツールリストのスナップショットを取る前に接続バッチを待機する時間（ミリ秒、デフォルト: 5000）。`MCP_CONNECTION_NONBLOCKING=0` の場合、または [`alwaysLoad: true`](/docs/ja/mcp#exempt-a-server-from-deferral) が指定されたサーバーに適用されます。デッドラインの時点でまだ保留中のサーバーは、バックグラウンドで接続を続けます。個々のサーバーの接続試行を制限する `MCP_TIMEOUT` とは異なります |
| `MCP_DISCOVERY_CACHE` | [MCP ディスカバリーキャッシュ](/docs/ja/mcp#server-status-detail)のオン/オフを切り替えます。キャッシュがオンの場合、以前に使用したリモート HTTP または SSE サーバーは [`cached` ステータス](/docs/ja/mcp#server-status-detail)を表示することがあり、Claude Code は起動時ではなく最初のツール呼び出し時にそのサーバーに接続します。段階的なロールアウトでアカウントに対して有効になっていない限り、キャッシュはデフォルトでオフです。オンにするには `1` に設定し、ロールアウトで有効になっている場合でもオフのままにするには `0` に設定します。v2.1.238 より前は、キャッシュはデフォルトでオンでした。`cached` ステータスには Claude Code v2.1.221 以降が必要です |
| `MCP_DISCOVERY_CACHE_MAX_STALE_S` | [ディスカバリーキャッシュ](/docs/ja/mcp#server-status-detail)のエントリの最大経過時間（秒）（デフォルト: 14400、つまり 4 時間）。エントリがそれより古い状態で起動した場合、Claude Code はそのエントリを破棄し、キャッシュがオフの場合と同様に起動時にサーバーに接続します。Claude Code は値の上限を 7 日とします。v2.1.238 より前は、デフォルトは 86400（24 時間）で、Claude Code は値に上限を設けていませんでした |
| `MCP_DISCOVERY_CACHE_STRIKES` | [ディスカバリーキャッシュ](/docs/ja/mcp#server-status-detail)のエントリが `MCP_DISCOVERY_CACHE_TTL_S` より古い状態で起動した場合、Claude Code はバックグラウンドでそのエントリを更新します。この変数は、Claude Code がエントリを破棄して次回の起動時にサーバーに接続するようになるまでに、連続して何回の更新の失敗を許容するかを設定します（デフォルト: 1）。ネットワーク接続がときどき切断される場合は、1 回の更新の失敗でエントリが破棄されないように値を上げてください。Claude Code v2.1.238 以降が必要です |
| `MCP_DISCOVERY_CACHE_TTL_S` | Claude Code が[ディスカバリーキャッシュ](/docs/ja/mcp#server-status-detail)のエントリを更新せずに使用する秒数（デフォルト: 900）。エントリがそれより古い状態で起動した場合、Claude Code は引き続きそのエントリを使用しますが、バックグラウンドで更新します。エントリが `MCP_DISCOVERY_CACHE_MAX_STALE_S` より古くなると、Claude Code は代わりにそのエントリを破棄します。Claude Code は値の上限を `MCP_DISCOVERY_CACHE_MAX_STALE_S`（デフォルトでは 4 時間）とします。v2.1.238 より前は、Claude Code は値に上限を設けていませんでした |
| `MCP_OAUTH_CALLBACK_PORT` | OAuth リダイレクトコールバック用の固定ポート。[事前設定された認証情報](/docs/ja/mcp#use-pre-configured-oauth-credentials)を使用して MCP サーバーを追加する際の `--callback-port` の代替です |
| `MCP_PROTOCOL_NEGOTIATION` | [v2 MCP クライアントランタイム](/docs/ja/mcp#mcp-client-runtimes)でのみ、Claude Code が MCP プロトコルリビジョン 2026-07-28 についてサーバーをプローブするかどうか。`auto` に設定すると HTTP、claude.ai コネクタ、stdio の各サーバーをプローブし、`legacy` に設定するとどれもプローブしません。変数が未設定の場合、Claude Code は [MCP クライアントランタイム](/docs/ja/mcp#mcp-client-runtimes)で説明されているサーバーをプローブします。その他の値は、デバッグログに警告を出力したうえで無視されます。Claude Code v2.1.221 以降が必要です |
| `MCP_REMOTE_SERVER_CONNECTION_BATCH_SIZE` | 起動時に並列で接続するリモート MCP サーバー（HTTP/SSE）の最大数（デフォルト: 20） |
| `MCP_SDK_GENERATION` | このプロセスが MCP サーバーへの接続に使用する [MCP クライアントランタイム](/docs/ja/mcp#mcp-client-runtimes)を固定します。MCP TypeScript SDK 1.x 上に構築された `v1`、または [MCP TypeScript SDK 2.0](https://ts.sdk.modelcontextprotocol.io/v2/) 上に構築された `v2` を指定します。変数がない場合、Claude Code はそのセクションに記載されているバージョン以降で v2 を使用します。Claude Code v2.1.221 以降では、v2 ランタイムは MCP OAuth サーバーが認可レスポンスで返す issuer を確認し、一致しない場合は `Issuer mismatch in authorization response` で始まるエラーでサインインを失敗させます。v1 ランタイムはこのチェックを行いません。認識されない値を設定した場合、Claude Code はそれを無視し、デバッグログに警告を書き込みます。Claude Code はこの値をプロセスごとに 1 回読み込みます。Claude Code v2.1.218 以降が必要です |
| `MCP_SERVER_CONNECTION_BATCH_SIZE` | 起動時に並列で接続するローカル MCP サーバー（stdio）の最大数（デフォルト: 3） |
| `MCP_TIMEOUT` | MCP サーバーの起動のタイムアウト（ミリ秒、デフォルト: 30000、つまり 30 秒） |
| `MCP_TOOL_TIMEOUT` | MCP ツールの実行のタイムアウト（ミリ秒、デフォルト: 100000000、約 28 時間）。HTTP、SSE、または claude.ai コネクタのサーバーでは、各リクエストもデフォルトで 60 秒後にタイムアウトします。このリクエストごとの制限を引き上げるには、この変数またはサーバーごとの `timeout` を 60000 より大きい値に設定します。それより小さい値でも全体のツール実行タイムアウトは短縮されますが、リクエストごとの制限は 60 秒のままです。stdio サーバーと WebSocket サーバーには、リクエストごとのタイマーはありません。`.mcp.json` のサーバーごとの `timeout` フィールドは、そのサーバーについてこの値を上書きします。1000 以上のサーバーごとの `timeout` は、そのサーバーのツール呼び出しの最小アイドル時間も設定するため、`CLAUDE_CODE_MCP_TOOL_IDLE_TIMEOUT` がそれより早くツール呼び出しを中断することはありません。この下限には Claude Code v2.1.203 以降が必要です。環境変数では、1000 未満の値は 1 秒に切り上げられます。サーバーごとのフィールドでは、1000 未満の値は無視されます |
| `NO_PROXY` | プロキシをバイパスして直接リクエストを送信するドメインと IP のリスト |
| `OTEL_ATTRIBUTE_VALUE_LENGTH_LIMIT` | 属性値の長さに関する標準の OpenTelemetry SDK の制限。Claude Code は、コンテンツを含むテレメトリ属性を、この値と `CLAUDE_CODE_OTEL_CONTENT_MAX_LENGTH` のうち小さい方に制限するため、切り詰めマーカーは SDK の制限内に収まります。Claude Code は `OTEL_LOGRECORD_ATTRIBUTE_VALUE_LENGTH_LIMIT` と `OTEL_SPAN_ATTRIBUTE_VALUE_LENGTH_LIMIT` のバリアントも同様に読み取り、設定された値のうち最小のものがすべてのシグナルに適用されます。Claude Code v2.1.214 以降が必要です。[モニタリング](/docs/ja/monitoring-usage#common-configuration-variables)を参照してください |
| `OTEL_LOG_ASSISTANT_RESPONSES` | `1` に設定すると、`assistant_response` OpenTelemetry ログイベントにモデルの応答テキストを含めます。未設定の場合、Claude Code は代わりに `OTEL_LOG_USER_PROMPTS` の値を使用します。`0` に設定すると、`OTEL_LOG_USER_PROMPTS` が設定されている場合でも応答を秘匿したままにします。シェル、ユーザー設定、または管理設定で設定します。[プロジェクト設定とローカル設定](/docs/ja/settings-reference#variables-claude-code-ignores-in-env)では無視されます。Claude Code v2.1.193 以降が必要です。[モニタリング](/docs/ja/monitoring-usage#assistant-response-event)を参照してください |
| `OTEL_LOG_MANAGED_SETTINGS` | `1` に設定すると、秘匿処理された管理設定と、秘匿処理前の設定の SHA-256 ダイジェストを `managed_settings_resolved` OpenTelemetry ログイベントに追加します。デフォルトでは無効です。シェル、ユーザー設定、または管理設定で設定します。プロジェクト設定またはローカル設定の値ではオンになりません。Claude Code v2.1.274 以降が必要です。[モニタリング](/docs/ja/monitoring-usage#managed-settings-resolved-event)を参照してください |
| `OTEL_LOG_RAW_API_BODIES` | Anthropic Messages API のリクエストとレスポンスの JSON を `api_request_body` / `api_response_body` ログイベントとして出力します。`1` に設定するとコンテンツ制限で切り詰められた本文をインラインで出力し、`file:<dir>` に設定すると切り詰められていない本文をディスクに書き込み、代わりに `body_ref` パスを出力します。`CLAUDE_CODE_OTEL_CONTENT_MAX_LENGTH` でコンテンツ制限を設定します（デフォルトは 60 KB）。デフォルトでは無効です。本文には会話履歴全体が含まれます。シェル、ユーザー設定、または管理設定で設定します。[プロジェクト設定とローカル設定](/docs/ja/settings-reference#variables-claude-code-ignores-in-env)では無視されます。[モニタリング](/docs/ja/monitoring-usage#api-request-body-event)を参照してください |
| `OTEL_LOG_TOOL_CONTENT` | `1` に設定すると、`tool.output` OpenTelemetry スパンイベントにツールのコンテンツを含めます。スパン属性は、[独自のゲート](/docs/ja/monitoring-usage#new-context-gates)のもとでツールのコンテンツを保持します。[トレーシング](/docs/ja/monitoring-usage#traces-beta)が必要です。機密データを保護するため、デフォルトでは無効です。シェル、ユーザー設定、または管理設定で設定します。そのセクションで説明しているオフの値を除き、[プロジェクト設定とローカル設定](/docs/ja/settings-reference#variables-claude-code-ignores-in-env)では無視されます。[モニタリング](/docs/ja/monitoring-usage#tool-output-span-event)を参照してください |
| `OTEL_LOG_TOOL_DETAILS` | `1` に設定すると、ツールの入力引数、MCP サーバー名、ユーザーが作成したワークフロー名、ツール失敗時の生のエラー文字列、`api_refusal` イベントの拒否 `category`、[コストとトークンのメトリクス](/docs/ja/monitoring-usage#cost-counter)における実際のエージェント名、スキル名、プラグイン名、MCP サーバー名、およびその他のツールの詳細を、OpenTelemetry のメトリクス、トレース、ログに含めます。PII を保護するため、デフォルトでは無効です。シェル、ユーザー設定、または管理設定で設定します。そのセクションで説明しているオフの値を除き、[プロジェクト設定とローカル設定](/docs/ja/settings-reference#variables-claude-code-ignores-in-env)では無視されます。[モニタリング](/docs/ja/monitoring-usage)を参照してください |
| `OTEL_LOG_USER_PROMPTS` | `1` に設定すると、OpenTelemetry のトレースとログにユーザーのプロンプトテキストを含めます。デフォルトでは無効です（プロンプトは秘匿されます）。シェル、ユーザー設定、または管理設定で設定します。そのセクションで説明しているオフの値を除き、[プロジェクト設定とローカル設定](/docs/ja/settings-reference#variables-claude-code-ignores-in-env)では無視されます。[モニタリング](/docs/ja/monitoring-usage)を参照してください |
| `OTEL_METRICS_INCLUDE_ACCOUNT_UUID` | `false` に設定すると、メトリクス属性からアカウント UUID を除外します（デフォルト: 含める）。[モニタリング](/docs/ja/monitoring-usage)を参照してください |
| `OTEL_METRICS_INCLUDE_ENTRYPOINT` | `true` に設定すると、メトリクス属性にセッションのエントリポイントを含めます（デフォルト: 除外）。v2.1.152 で追加されました。[モニタリング](/docs/ja/monitoring-usage)を参照してください |
| `OTEL_METRICS_INCLUDE_REPOSITORY` | `true` に設定すると、セッションのリポジトリを識別する `vcs.*` 属性を OpenTelemetry のメトリクスとイベントに付与します（デフォルト: 除外）。Claude Code v2.1.269 以降が必要です。[リポジトリ属性](/docs/ja/monitoring-usage#repository-attributes)を参照してください |
| `OTEL_METRICS_INCLUDE_RESOURCE_ATTRIBUTES` | v2.1.161 以降、Claude Code は `OTEL_RESOURCE_ATTRIBUTES` のキーをメトリクスのデータポイントラベルに付加します。`false` に設定すると、これらを除外します（デフォルト: 含める）。[モニタリング](/docs/ja/monitoring-usage#multi-team-organization-support)を参照してください |
| `OTEL_METRICS_INCLUDE_SESSION_ID` | `false` に設定すると、メトリクス属性からセッション ID を除外します（デフォルト: 含める）。[モニタリング](/docs/ja/monitoring-usage)を参照してください |
| `OTEL_METRICS_INCLUDE_VERSION` | `true` に設定すると、メトリクス属性に Claude Code のバージョンを含めます（デフォルト: 除外）。[モニタリング](/docs/ja/monitoring-usage)を参照してください |
| `SLASH_COMMAND_TOOL_CHAR_BUDGET` | [Skill ツール](/docs/ja/skills#control-who-invokes-a-skill)に表示されるスキルメタデータの文字数予算を上書きします。予算はコンテキストウィンドウの 1% で動的にスケールし、フォールバックは 8,000 文字です。後方互換性のために従来の名前が維持されています |
| `TASK_MAX_OUTPUT_LENGTH` | v2.1.277 で、この変数がサイズを決めていた `TaskOutput` ツールとともに削除され、現在は何も行いません。以前は、`TaskOutput` ツールが保持する[バックグラウンドタスク](/docs/ja/tools-reference#background-commands)の出力の最大文字数を設定していました。Claude は代わりに `Read` でバックグラウンドタスクの出力ファイルを読み取ります |
| `USE_BUILTIN_RIPGREP` | `0` に設定すると、Claude Code に含まれる `rg` の代わりに、システムにインストールされた `rg` を使用します |
| `VERTEX_REGION_CLAUDE_3_5_HAIKU` | Google Cloud's Agent Platform を使用する場合の Claude 3.5 Haiku のリージョンを上書きします |
| `VERTEX_REGION_CLAUDE_3_5_SONNET` | Google Cloud's Agent Platform を使用する場合の Claude 3.5 Sonnet のリージョンを上書きします |
| `VERTEX_REGION_CLAUDE_3_7_SONNET` | Google Cloud's Agent Platform を使用する場合の Claude 3.7 Sonnet のリージョンを上書きします |
| `VERTEX_REGION_CLAUDE_4_0_OPUS` | Google Cloud's Agent Platform を使用する場合の Claude 4.0 Opus のリージョンを上書きします |
| `VERTEX_REGION_CLAUDE_4_0_SONNET` | Google Cloud's Agent Platform を使用する場合の Claude 4.0 Sonnet のリージョンを上書きします |
| `VERTEX_REGION_CLAUDE_4_1_OPUS` | Google Cloud's Agent Platform を使用する場合の Claude 4.1 Opus のリージョンを上書きします |
| `VERTEX_REGION_CLAUDE_4_5_OPUS` | Google Cloud's Agent Platform を使用する場合の Claude Opus 4.5 のリージョンを上書きします |
| `VERTEX_REGION_CLAUDE_4_5_SONNET` | Google Cloud's Agent Platform を使用する場合の Claude Sonnet 4.5 のリージョンを上書きします |
| `VERTEX_REGION_CLAUDE_4_6_OPUS` | Google Cloud's Agent Platform を使用する場合の Claude Opus 4.6 のリージョンを上書きします |
| `VERTEX_REGION_CLAUDE_4_6_SONNET` | Google Cloud's Agent Platform を使用する場合の Claude Sonnet 4.6 のリージョンを上書きします |
| `VERTEX_REGION_CLAUDE_4_7_OPUS` | Google Cloud's Agent Platform を使用する場合の Claude Opus 4.7 のリージョンを上書きします |
| `VERTEX_REGION_CLAUDE_4_8_OPUS` | Google Cloud's Agent Platform を使用する場合の Claude Opus 4.8 のリージョンを上書きします |
| `VERTEX_REGION_CLAUDE_5_5_OPUS` | Google Cloud's Agent Platform を使用する場合の Claude Opus 5.5 のリージョンを上書きします。v2.1.280 で追加されました |
| `VERTEX_REGION_CLAUDE_5_5_SONNET` | Google Cloud's Agent Platform を使用する場合の Claude Sonnet 5.5 のリージョンを上書きします。v2.1.284 で追加されました |
| `VERTEX_REGION_CLAUDE_5_OPUS` | Google Cloud's Agent Platform を使用する場合の Claude Opus 5 のリージョンを上書きします。v2.1.219 で追加されました |
| `VERTEX_REGION_CLAUDE_5_SONNET` | Google Cloud's Agent Platform を使用する場合の Claude Sonnet 5 のリージョンを上書きします。v2.1.197 で追加されました |
| `VERTEX_REGION_CLAUDE_FABLE_5` | Google Cloud's Agent Platform を使用する場合の Claude Fable 5 のリージョンを上書きします。v2.1.170 で追加されました |
| `VERTEX_REGION_CLAUDE_FABLE_5_1` | Google Cloud's Agent Platform を使用する場合の Claude Fable 5.1 のリージョンを上書きします。v2.1.257 で追加されました |
| `VERTEX_REGION_CLAUDE_HAIKU_4_5` | Google Cloud's Agent Platform を使用する場合の Claude Haiku 4.5 のリージョンを上書きします |

標準の OpenTelemetry エクスポーター変数（`OTEL_METRICS_EXPORTER`、`OTEL_LOGS_EXPORTER`、`OTEL_EXPORTER_OTLP_ENDPOINT`、`OTEL_EXPORTER_OTLP_PROTOCOL`、`OTEL_EXPORTER_OTLP_HEADERS`、`OTEL_METRIC_EXPORT_INTERVAL`、`OTEL_RESOURCE_ATTRIBUTES`、およびシグナル固有のバリアント）もサポートされています。設定の詳細については、[モニタリング](/docs/ja/monitoring-usage)を参照してください。

`CLAUDE_CODE_ENABLE_TELEMETRY` と、エクスポートをオンにする、エクスポート先を選択する、またはコンテンツをキャプチャする OpenTelemetry 変数は、シェル、ユーザー設定、または管理設定で設定します。そのセクションで説明しているオフの値を除き、Claude Code は[プロジェクト設定とローカル設定ではこれらを無視します](/docs/ja/settings-reference#variables-claude-code-ignores-in-env)。`OTEL_RESOURCE_ATTRIBUTES` と、`OTEL_METRIC_EXPORT_INTERVAL` などのエクスポート間隔、タイムアウト、圧縮に関する変数は、プロジェクト設定とローカル設定からも引き続き適用されます。

<h2 id="what-the-subprocess-environment-scrub-removes">
  サブプロセス環境のスクラブで削除されるもの
</h2>

[`CLAUDE_CODE_SUBPROCESS_ENV_SCRUB`](#variables) を `1` に設定すると、Claude Code は Bash コマンド、フック、stdio MCP サーバーなど、自身が起動するサブプロセスの環境から認証情報を削除します。これにより、プロンプトインジェクション攻撃がシェル展開を通じて読み取れる情報が減ります。Claude Code のプロセス自体は、独自の API 呼び出しのために認証情報を保持します。

スクラブは変数名または値の形式によって認証情報を識別するため、唯一の制御手段としてではなく、範囲を絞った[権限ルール](/docs/ja/permissions)と併用する一つの層として使用してください。

次の表は、スクラブが例示の変数に対して行う処理を示しています。

| 変数の例 | スクラブの処理 |
| :- | :- |
| `ANTHROPIC_API_KEY`、`AWS_SECRET_ACCESS_KEY` | 削除します |
| `NPM_TOKEN`、`DB_PASSWORD` | 名前が認証情報のように見えるため、削除します |
| パスワードを含む `DATABASE_URL` | 値が認証情報のように見えるため、削除します |
| パスワードを含む `PIP_INDEX_URL` または `NPM_CONFIG_REGISTRY` | URL は保持し、そこからユーザー名とパスワードを取り除きます |
| `CLAUDE_CONFIG_DIR` | 削除します。Claude Code v2.1.251 以降が必要です |
| `GITHUB_TOKEN`、`GH_TOKEN`、`GH_ENTERPRISE_TOKEN`、`GITHUB_ENTERPRISE_TOKEN` | `gh` や GitHub API を呼び出すスクリプトが引き続き動作するよう、そのまま残します |
| `HTTP_PROXY`、`HTTPS_PROXY` | [URL 内のユーザー名とパスワード](/docs/ja/network-config#basic-authentication)も含めて、そのまま残します。[サンドボックス](/docs/ja/sandboxing#network-isolation)は、サンドボックス化されたコマンドに対してこれらの変数を自ら設定できます |
| `GIT_CONFIG_COUNT`、`GIT_CONFIG_KEY_<n>`、`GIT_CONFIG_VALUE_<n>` | 内容にかかわらず、そのまま残します |
| 変数名も値も認証情報のように見えないシークレット | そのまま残します |

スクラブは `GITHUB_TOKEN` をそのまま残すため、GitHub Actions のジョブには必要最小限の `permissions` を付与してください。サンドボックス化された Bash コマンドから GitHub トークンを削除するには、[`sandbox.credentials`](/docs/ja/sandboxing#protect-credentials) の下に `deny` エントリを追加します。

サブプロセスが削除対象の変数のいずれかを必要とする場合は、スクラブを設定しないでください。

Linux では、スクラブは Bash サブプロセスを分離された PID 名前空間でも実行するため、サブプロセスは `/proc` を通じてホストのプロセス環境を読み取れません。その副作用として、`ps`、`pgrep`、`kill` はホストのプロセスを参照したり、シグナルを送信したりできません。

<h2 id="features-that-need-feature-flag-fetching">
  機能フラグの取得が必要な機能
</h2>

Claude Code の一部の機能は、Anthropic から取得する機能フラグによってオンになります。次のセッションでは、Claude Code はこの取得をスキップします。

* `DISABLE_GROWTHBOOK`、`DISABLE_TELEMETRY`、`DO_NOT_TRACK`、または `CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC` を設定したセッション。どの値で取得がオフになるかは、[変数の表](#variables)の各変数の行に記載されています
* Amazon Bedrock、Claude Platform on AWS、Google Cloud の Agent Platform、Microsoft Foundry などの[サードパーティプロバイダー](/docs/ja/third-party-integrations)上のセッション。ただし、Claude Code を組み込んだホストプラットフォームが `CLAUDE_CODE_PROVIDER_MANAGED_BY_HOST` を設定している場合を除きます
* [Claude apps ゲートウェイ](/docs/ja/claude-apps-gateway)のセッション

取得がオフの場合、次のことはできません。

* [`/auto-mode-setup`](/docs/ja/auto-mode-config#generate-environment-entries) を実行して `autoMode.environment` のエントリを下書きする
* `CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC` または `DISABLE_GROWTHBOOK` を設定した状態で [Remote Control](/docs/ja/remote-control) を使用する。`DISABLE_TELEMETRY` と `DO_NOT_TRACK` については、[Remote Control の要件](/docs/ja/remote-control#requirements)を参照してください
* [Remote Control](/docs/ja/remote-control#requirements) が利用できない場合に、[このマシン以外のセッションにメッセージを送る](/docs/ja/cross-session-messaging#message-sessions-on-other-machines)。このマシン上のセッション間のメッセージングは、取得がオフでも機能します
* [`claude import` または `/import` コマンド](/docs/ja/cli-reference#cli-commands)を実行する
* [`/skill-doctor`](/docs/ja/skills#find-unused-skills) を実行する、またはそのレポートを `/plugin` の **Stats** タブで開く
* claude.ai アカウントで有効にした[スキル](/docs/ja/skills#where-synced-skills-load)と[プラグイン](/docs/ja/plugins/loading#synced-plugins)をターミナルセッションに同期する
* [アドバイザーツール](/docs/ja/advisor#requirements)を使用する
* [アーティファクトへのコメント](/docs/ja/artifacts#collect-comments-on-an-artifact)を読む、または返信する
* Claude に[別の組織の公開アーティファクト](/docs/ja/artifacts#read-an-artifact-shared-with-you)を読ませる
* `MCP_PROTOCOL_NEGOTIATION=auto` を設定しない限り、Claude Code に claude.ai コネクタサーバーや stdio サーバーに対して [MCP プロトコルリビジョン 2026-07-28](/docs/ja/mcp#mcp-client-runtimes) をプローブさせる
* Git Bash がインストールされた Windows 上の claude.ai アカウントおよび Console アカウントで、[PowerShell ツール](/docs/ja/tools-reference#powershell-tool)をデフォルトで利用する。`CLAUDE_CODE_USE_POWERSHELL_TOOL=1` を設定しない限り、Claude Code はシェルコマンドを Git Bash 経由で実行します。Git Bash のない Windows では、このツールはオンのままです
* [Claude が下書きするフィードバック](/docs/ja/tools-reference#sendfeedback-tool-behavior)を利用する。この機能は、Claude Code が取得したフラグによってオンにします
* Claude に[大きな貼り付けを、入力したテキストではなく貼り付けたテキストとして扱わせる](/docs/ja/terminal-config#how-claude-treats-pasted-text)。`[Pasted text #N]` プレースホルダーの背後にあるコンテンツは、マークなしで Claude に届きます
* Claude Code に [API が拒否する入力スキーマを持つ MCP ツールを除外させる](/docs/ja/mcp#tools-with-invalid-input-schemas)。Claude Code はそのスキーマをそのまま送信し、それを含むリクエストは[ツールを位置で示す 400 エラー](/docs/ja/errors#tool-input-schema-is-invalid)で失敗します

<h3 id="first-session-after-an-install-or-upgrade">
  インストールまたはアップグレード後の最初のセッション
</h3>

Claude Code をインストールした後、または機能が追加されたバージョンにアップグレードした後の最初のセッションでは、[フラグで制御される機能](#features-that-need-feature-flag-fetching)が利用できないことがあります。また、そのセッションは、以降のセッションとは異なる[権限モード](/docs/ja/permission-modes#which-mode-a-session-starts-in)で開始されることもあります。そのセッション中に Claude Code がフラグを取得すると、フラグはマシンに保存されるため、そのマシンでの次のセッションでは機能が利用でき、通常の開始権限モードになります。

新規インストール後、`claude -p`、Agent SDK、VS Code 拡張機能などの非対話型セッションでは、Claude Code は[開始権限モードを選択する](/docs/ja/permission-modes#which-mode-a-session-starts-in)前にフラグを取得できることがありますが、必ずしもフラグを待つわけではありません。

次のような構成では、最初以降のセッションも、新たに取得したフラグなしで開始されます。

* **実行のたびにクリーンな環境になる場合**: 各実行が CI コンテナや、以前のセッションが保存したフラグのないその他の環境で開始される場合、すべての実行が最初のセッションになります
* **API キーのないゲートウェイトークンの場合**: API キーなしで `ANTHROPIC_AUTH_TOKEN` を使用して認証し、`ANTHROPIC_BASE_URL` が [LLM ゲートウェイ](/docs/ja/llm-gateway)など Anthropic 以外のホストを指している場合、Claude Code にはフラグを取得するための認証情報がありません

これらの構成でセッションを開始する権限モードを選択するには、[別の権限モードで開始する](/docs/ja/permission-modes#start-in-a-different-mode)を参照してください。

<h2 id="see-also">
  関連項目
</h2>

* [設定](/docs/ja/settings)：すべての `settings.json` 設定（`env` キーを含む）
* [CLI リファレンス](/docs/ja/cli-reference)：起動時フラグ
* [ネットワーク設定](/docs/ja/network-config)：プロキシと TLS セットアップ
* [監視](/docs/ja/monitoring-usage)：OpenTelemetry 設定
