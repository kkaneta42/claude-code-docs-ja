> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# MCPを使用してClaude Codeをツールに接続する

> Model Context Protocolを使用してClaude Codeをツールに接続する方法を学びます。

export const MCPServersTable = ({platform = "all"}) => {
  const ifYouAreAnAiAgentReadingThisYouShouldInsteadFetch = 'https://api.anthropic.com/mcp-registry/docs';
  const [servers, setServers] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  useEffect(() => {
    const fetchServers = async () => {
      try {
        setLoading(true);
        const allServers = [];
        let cursor = null;
        do {
          const url = new URL('https://api.anthropic.com/mcp-registry/v0/servers');
          url.searchParams.set('version', 'latest');
          url.searchParams.set('visibility', 'commercial');
          url.searchParams.set('limit', '100');
          if (cursor) {
            url.searchParams.set('cursor', cursor);
          }
          const response = await fetch(url);
          if (!response.ok) {
            throw new Error(`Failed to fetch MCP registry: ${response.status}`);
          }
          const data = await response.json();
          allServers.push(...data.servers);
          cursor = data.metadata?.nextCursor || null;
        } while (cursor);
        const transformedServers = allServers.map(item => {
          const server = item.server;
          const meta = item._meta?.['com.anthropic.api/mcp-registry'] || ({});
          const worksWith = meta.worksWith || [];
          const availability = {
            claudeCode: worksWith.includes('claude-code'),
            mcpConnector: worksWith.includes('claude-api'),
            claudeDesktop: worksWith.includes('claude-desktop')
          };
          const remotes = server.remotes || [];
          const httpRemote = remotes.find(r => r.type === 'streamable-http');
          const sseRemote = remotes.find(r => r.type === 'sse');
          const preferredRemote = httpRemote || sseRemote;
          const remoteUrl = preferredRemote?.url || meta.url;
          const remoteType = preferredRemote?.type;
          const isTemplatedUrl = remoteUrl?.includes('{');
          let setupUrl;
          if (isTemplatedUrl && meta.requiredFields) {
            const urlField = meta.requiredFields.find(f => f.field === 'url');
            setupUrl = urlField?.sourceUrl || meta.documentation;
          }
          const urls = {};
          if (!isTemplatedUrl) {
            if (remoteType === 'streamable-http') {
              urls.http = remoteUrl;
            } else if (remoteType === 'sse') {
              urls.sse = remoteUrl;
            }
          }
          let envVars = [];
          if (server.packages && server.packages.length > 0) {
            const npmPackage = server.packages.find(p => p.registryType === 'npm');
            if (npmPackage) {
              urls.stdio = `npx -y ${npmPackage.identifier}`;
              if (npmPackage.environmentVariables) {
                envVars = npmPackage.environmentVariables;
              }
            }
          }
          return {
            name: meta.displayName || server.title || server.name,
            description: meta.oneLiner || server.description,
            documentation: meta.documentation,
            urls: urls,
            envVars: envVars,
            availability: availability,
            customCommands: meta.claudeCodeCopyText ? {
              claudeCode: meta.claudeCodeCopyText
            } : undefined,
            setupUrl: setupUrl
          };
        });
        setServers(transformedServers);
        setError(null);
      } catch (err) {
        setError(err.message);
        console.error('Error fetching MCP registry:', err);
      } finally {
        setLoading(false);
      }
    };
    fetchServers();
  }, []);
  const generateClaudeCodeCommand = server => {
    if (server.customCommands && server.customCommands.claudeCode) {
      return server.customCommands.claudeCode;
    }
    const serverSlug = server.name.toLowerCase().replace(/[^a-z0-9]/g, '-');
    if (server.urls.http) {
      return `claude mcp add ${serverSlug} --transport http ${server.urls.http}`;
    }
    if (server.urls.sse) {
      return `claude mcp add ${serverSlug} --transport sse ${server.urls.sse}`;
    }
    if (server.urls.stdio) {
      const envFlags = server.envVars && server.envVars.length > 0 ? server.envVars.map(v => `--env ${v.name}=YOUR_${v.name}`).join(' ') : '';
      const baseCommand = `claude mcp add ${serverSlug} --transport stdio`;
      return envFlags ? `${baseCommand} ${envFlags} -- ${server.urls.stdio}` : `${baseCommand} -- ${server.urls.stdio}`;
    }
    return null;
  };
  if (loading) {
    return <div>Loading MCP servers...</div>;
  }
  if (error) {
    return <div>Error loading MCP servers: {error}</div>;
  }
  const filteredServers = servers.filter(server => {
    if (platform === "claudeCode") {
      return server.availability.claudeCode;
    } else if (platform === "mcpConnector") {
      return server.availability.mcpConnector;
    } else if (platform === "claudeDesktop") {
      return server.availability.claudeDesktop;
    } else if (platform === "all") {
      return true;
    } else {
      throw new Error(`Unknown platform: ${platform}`);
    }
  });
  return <>
      <style jsx>{`
        .cards-container {
          display: grid;
          gap: 1rem;
          margin-bottom: 2rem;
        }
        .server-card {
          border: 1px solid var(--border-color, #e5e7eb);
          border-radius: 6px;
          padding: 1rem;
        }
        .command-row {
          display: flex;
          align-items: center;
          gap: 0.25rem;
        }
        .command-row code {
          font-size: 0.75rem;
          overflow-x: auto;
        }
      `}</style>

      <div className="cards-container">
        {filteredServers.map(server => {
    const claudeCodeCommand = generateClaudeCodeCommand(server);
    const mcpUrl = server.urls.http || server.urls.sse;
    const commandToShow = platform === "claudeCode" ? claudeCodeCommand : mcpUrl;
    return <div key={server.name} className="server-card">
              <div>
                {server.documentation ? <a href={server.documentation}>
                    <strong>{server.name}</strong>
                  </a> : <strong>{server.name}</strong>}
              </div>

              <p style={{
      margin: '0.5rem 0',
      fontSize: '0.9rem'
    }}>
                {server.description}
              </p>

              {server.setupUrl && <p style={{
      margin: '0.25rem 0',
      fontSize: '0.8rem',
      fontStyle: 'italic',
      opacity: 0.7
    }}>
                  Requires user-specific URL.{' '}
                  <a href={server.setupUrl} style={{
      textDecoration: 'underline'
    }}>
                    Get your URL here
                  </a>.
                </p>}

              {commandToShow && !server.setupUrl && <>
                <p style={{
      display: 'block',
      fontSize: '0.75rem',
      fontWeight: 500,
      minWidth: 'fit-content',
      marginTop: '0.5rem',
      marginBottom: 0
    }}>
                  {platform === "claudeCode" ? "Command" : "URL"}
                </p>
                <div className="command-row">
                  <code>
                    {commandToShow}
                  </code>
                </div>
              </>}
            </div>;
  })}
      </div>
    </>;
};

Claude Codeは、AI-ツール統合のためのオープンソース標準である[Model Context Protocol (MCP)](https://modelcontextprotocol.io/introduction)を通じて、数百の外部ツールとデータソースに接続できます。MCPサーバーは、Claude Codeにツール、データベース、APIへのアクセスを提供します。

## MCPでできることは何か

MCPサーバーが接続されている場合、Claude Codeに以下を依頼できます：

* **イシュートラッカーから機能を実装する**: 「JIRA issue ENG-4521に記載されている機能を追加し、GitHubにPRを作成してください。」
* **監視データを分析する**: 「SentryとStatsigをチェックして、ENG-4521に記載されている機能の使用状況を確認してください。」
* **データベースをクエリする**: 「PostgreSQLデータベースに基づいて、ENG-4521機能を使用した10人のランダムユーザーのメールアドレスを検索してください。」
* **デザインを統合する**: 「Slackに投稿された新しいFigmaデザインに基づいて、標準メールテンプレートを更新してください。」
* **ワークフローを自動化する**: 「新機能に関するフィードバックセッションにこれら10人のユーザーを招待するGmailドラフトを作成してください。」

## 人気のあるMCPサーバー

Claude Codeに接続できる一般的に使用されているMCPサーバーは以下の通りです：

<Warning>
  サードパーティのMCPサーバーは自己責任で使用してください。Anthropicはこれらすべてのサーバーの正確性またはセキュリティを検証していません。
  インストールするMCPサーバーを信頼していることを確認してください。
  信頼されていないコンテンツを取得する可能性があるMCPサーバーを使用する場合は特に注意してください。これらはプロンプトインジェクションリスクにさらされる可能性があります。
</Warning>

<MCPServersTable platform="claudeCode" />

<Note>
  **特定の統合が必要ですか？** [GitHubで数百以上のMCPサーバーを検索](https://github.com/modelcontextprotocol/servers)するか、[MCP SDK](https://modelcontextprotocol.io/quickstart/server)を使用して独自のサーバーを構築してください。
</Note>

## MCPサーバーのインストール

MCPサーバーは、ニーズに応じて3つの異なる方法で構成できます：

### オプション1：リモートHTTPサーバーを追加する

HTTPサーバーは、リモートMCPサーバーに接続するための推奨オプションです。これはクラウドベースのサービスに最も広くサポートされているトランスポートです。

```bash  theme={null}
# 基本的な構文
claude mcp add --transport http <name> <url>

# 実際の例：Notionに接続する
claude mcp add --transport http notion https://mcp.notion.com/mcp

# Bearerトークンを使用した例
claude mcp add --transport http secure-api https://api.example.com/mcp \
  --header "Authorization: Bearer your-token"
```

### オプション2：リモートSSEサーバーを追加する

<Warning>
  SSE (Server-Sent Events)トランスポートは非推奨です。利用可能な場合はHTTPサーバーを使用してください。
</Warning>

```bash  theme={null}
# 基本的な構文
claude mcp add --transport sse <name> <url>

# 実際の例：Asanaに接続する
claude mcp add --transport sse asana https://mcp.asana.com/sse

# 認証ヘッダーを使用した例
claude mcp add --transport sse private-api https://api.company.com/sse \
  --header "X-API-Key: your-key-here"
```

### オプション3：ローカルstdioサーバーを追加する

Stdioサーバーはマシン上でローカルプロセスとして実行されます。システムアクセスが必要なツールやカスタムスクリプトに最適です。

```bash  theme={null}
# 基本的な構文
claude mcp add [options] <name> -- <command> [args...]

# 実際の例：Airtableサーバーを追加する
claude mcp add --transport stdio --env AIRTABLE_API_KEY=YOUR_KEY airtable \
  -- npx -y airtable-mcp-server
```

<Note>
  **重要：オプションの順序**

  すべてのオプション（`--transport`、`--env`、`--scope`、`--header`）はサーバー名の**前に**来る必要があります。`--`（ダブルダッシュ）はサーバー名をMCPサーバーに渡されるコマンドと引数から分離します。

  例：

  * `claude mcp add --transport stdio myserver -- npx server` → `npx server`を実行します
  * `claude mcp add --transport stdio --env KEY=value myserver -- python server.py --port 8080` → 環境に`KEY=value`を設定して`python server.py --port 8080`を実行します

  これにより、Claudeのフラグとサーバーのフラグ間の競合を防ぎます。
</Note>

### サーバーの管理

構成したら、これらのコマンドでMCPサーバーを管理できます：

```bash  theme={null}
# すべての構成済みサーバーをリストする
claude mcp list

# 特定のサーバーの詳細を取得する
claude mcp get github

# サーバーを削除する
claude mcp remove github

# （Claude Code内）サーバーステータスを確認する
/mcp
```

### 動的ツール更新

Claude CodeはMCP `list_changed`通知をサポートしており、MCPサーバーが接続を切断して再接続することなく、利用可能なツール、プロンプト、リソースを動的に更新できます。MCPサーバーが`list_changed`通知を送信すると、Claude Codeはそのサーバーから利用可能な機能を自動的に更新します。

<Tip>
  ヒント：

  * `--scope`フラグを使用して、構成が保存される場所を指定します：
    * `local`（デフォルト）：現在のプロジェクト内でのみ利用可能（古いバージョンでは`project`と呼ばれていました）
    * `project`：`.mcp.json`ファイルを介してプロジェクト内のすべてのユーザーと共有
    * `user`：すべてのプロジェクト全体で利用可能（古いバージョンでは`global`と呼ばれていました）
  * `--env`フラグで環境変数を設定します（例：`--env KEY=value`）
  * `MCP_TIMEOUT`環境変数を使用してMCPサーバーのスタートアップタイムアウトを構成します（例：`MCP_TIMEOUT=10000 claude`は10秒のタイムアウトを設定します）
  * Claude CodeはMCPツール出力が10,000トークンを超える場合に警告を表示します。この制限を増やすには、`MAX_MCP_OUTPUT_TOKENS`環境変数を設定します（例：`MAX_MCP_OUTPUT_TOKENS=50000`）
  * `/mcp`を使用してOAuth 2.0認証が必要なリモートサーバーで認証します
</Tip>

<Warning>
  **Windowsユーザー向け**：ネイティブWindows（WSLではない）では、`npx`を使用するローカルMCPサーバーは適切な実行を確保するために`cmd /c`ラッパーが必要です。

  ```bash  theme={null}
  # これはWindowsが実行できるcommand="cmd"を作成します
  claude mcp add --transport stdio my-server -- cmd /c npx -y @some/package
  ```

  `cmd /c`ラッパーがないと、Windowsは`npx`を直接実行できないため「Connection closed」エラーが発生します。（`--`パラメータの説明については上記のメモを参照してください。）
</Warning>

### プラグイン提供のMCPサーバー

[プラグイン](/ja/plugins)はMCPサーバーをバンドルでき、プラグインが有効になると自動的にツールと統合を提供します。プラグインMCPサーバーはユーザー構成サーバーと同じように機能します。

**プラグインMCPサーバーの仕組み**：

* プラグインはプラグインルートの`.mcp.json`または`plugin.json`内でMCPサーバーを定義します
* プラグインが有効になると、そのMCPサーバーが自動的に開始されます
* プラグインMCPツールは手動で構成されたMCPツールと一緒に表示されます
* プラグインサーバーはプラグインのインストールを通じて管理されます（`/mcp`コマンドではありません）

**プラグインMCP構成の例**：

プラグインルートの`.mcp.json`内：

```json  theme={null}
{
  "database-tools": {
    "command": "${CLAUDE_PLUGIN_ROOT}/servers/db-server",
    "args": ["--config", "${CLAUDE_PLUGIN_ROOT}/config.json"],
    "env": {
      "DB_URL": "${DB_URL}"
    }
  }
}
```

または`plugin.json`内にインライン：

```json  theme={null}
{
  "name": "my-plugin",
  "mcpServers": {
    "plugin-api": {
      "command": "${CLAUDE_PLUGIN_ROOT}/servers/api-server",
      "args": ["--port", "8080"]
    }
  }
}
```

**プラグインMCP機能**：

* **自動ライフサイクル**：プラグインが有効になるとサーバーが開始されますが、MCPサーバーの変更を適用するにはClaude Codeを再起動する必要があります（有効化または無効化）
* **環境変数**：プラグイン相対パスに`${CLAUDE_PLUGIN_ROOT}`を使用します
* **ユーザー環境アクセス**：手動で構成されたサーバーと同じ環境変数へのアクセス
* **複数のトランスポートタイプ**：stdio、SSE、HTTPトランスポートをサポート（トランスポートサポートはサーバーによって異なる場合があります）

**プラグインMCPサーバーの表示**：

```bash  theme={null}
# Claude Code内で、プラグインを含むすべてのMCPサーバーを表示
/mcp
```

プラグインサーバーはプラグインから来ていることを示すインジケータ付きでリストに表示されます。

**プラグインMCPサーバーの利点**：

* **バンドル配布**：ツールとサーバーが一緒にパッケージされています
* **自動セットアップ**：手動のMCP構成は不要です
* **チーム一貫性**：プラグインがインストールされると、すべてのユーザーが同じツールを取得します

プラグインでMCPサーバーをバンドルする詳細については、[プラグインコンポーネントリファレンス](/ja/plugins-reference#mcp-servers)を参照してください。

## MCPインストールスコープ

MCPサーバーは3つの異なるスコープレベルで構成でき、それぞれサーバーのアクセス可能性と共有を管理するための異なる目的を果たします。これらのスコープを理解することで、特定のニーズに対してサーバーを構成する最良の方法を決定するのに役立ちます。

### ローカルスコープ

ローカルスコープのサーバーはデフォルトの構成レベルを表し、プロジェクトのパスの下の`~/.claude.json`に保存されます。これらのサーバーはあなたにプライベートなままで、現在のプロジェクトディレクトリ内で作業する場合にのみアクセス可能です。このスコープは、個人的な開発サーバー、実験的な構成、または共有すべきでない機密認証情報を含むサーバーに最適です。

```bash  theme={null}
# ローカルスコープのサーバーを追加する（デフォルト）
claude mcp add --transport http stripe https://mcp.stripe.com

# ローカルスコープを明示的に指定する
claude mcp add --transport http stripe --scope local https://mcp.stripe.com
```

### プロジェクトスコープ

プロジェクトスコープのサーバーは、プロジェクトのルートディレクトリの`.mcp.json`ファイルに構成を保存することでチーム協力を可能にします。このファイルはバージョン管理にチェックインするように設計されており、すべてのチームメンバーが同じMCPツールとサービスにアクセスできることを保証します。プロジェクトスコープのサーバーを追加すると、Claude Codeは自動的にこのファイルを作成または更新して、適切な構成構造を使用します。

```bash  theme={null}
# プロジェクトスコープのサーバーを追加する
claude mcp add --transport http paypal --scope project https://mcp.paypal.com/mcp
```

結果の`.mcp.json`ファイルは標準化された形式に従います：

```json  theme={null}
{
  "mcpServers": {
    "shared-server": {
      "command": "/path/to/server",
      "args": [],
      "env": {}
    }
  }
}
```

セキュリティ上の理由から、Claude Codeは`.mcp.json`ファイルからプロジェクトスコープのサーバーを使用する前に承認を求めます。これらの承認選択をリセットする必要がある場合は、`claude mcp reset-project-choices`コマンドを使用します。

### ユーザースコープ

ユーザースコープのサーバーは`~/.claude.json`に保存され、クロスプロジェクトのアクセス可能性を提供し、マシン上のすべてのプロジェクト全体で利用可能にしながら、ユーザーアカウントにプライベートなままです。このスコープは、個人的なユーティリティサーバー、開発ツール、または異なるプロジェクト全体で頻繁に使用するサービスに適しています。

```bash  theme={null}
# ユーザースコープのサーバーを追加する
claude mcp add --transport http hubspot --scope user https://mcp.hubspot.com/anthropic
```

### 適切なスコープの選択

以下に基づいてスコープを選択します：

* **ローカルスコープ**：個人的なサーバー、実験的な構成、または1つのプロジェクトに固有の機密認証情報
* **プロジェクトスコープ**：チーム共有サーバー、プロジェクト固有のツール、または協力に必要なサービス
* **ユーザースコープ**：複数のプロジェクト全体で必要な個人的なユーティリティ、開発ツール、または頻繁に使用されるサービス

<Note>
  **MCPサーバーはどこに保存されていますか？**

  * **ユーザーおよびローカルスコープ**：`~/.claude.json`（`mcpServers`フィールドまたはプロジェクトパスの下）
  * **プロジェクトスコープ**：プロジェクトルートの`.mcp.json`（ソース管理にチェックイン）
  * **管理対象**：システムディレクトリの`managed-mcp.json`（[管理対象MCP構成](#managed-mcp-configuration)を参照）
</Note>

### スコープ階層と優先順位

MCPサーバー構成は明確な優先順位階層に従います。同じ名前のサーバーが複数のスコープに存在する場合、システムはローカルスコープのサーバーを最初に優先し、その次にプロジェクトスコープのサーバー、最後にユーザースコープのサーバーを優先することで競合を解決します。この設計により、個人的な構成が必要に応じて共有されたものをオーバーライドできることを保証します。

### `.mcp.json`での環境変数展開

Claude Codeは`.mcp.json`ファイルの環境変数展開をサポートしており、チームが構成を共有しながらマシン固有のパスとAPIキーなどの機密値の柔軟性を維持できます。

**サポートされている構文：**

* `${VAR}` - 環境変数`VAR`の値に展開
* `${VAR:-default}` - `VAR`が設定されている場合は展開、そうでない場合は`default`を使用

**展開場所：**
環境変数は以下で展開できます：

* `command` - サーバー実行可能ファイルパス
* `args` - コマンドライン引数
* `env` - サーバーに渡される環境変数
* `url` - HTTPサーバータイプの場合
* `headers` - HTTPサーバー認証の場合

**変数展開を使用した例：**

```json  theme={null}
{
  "mcpServers": {
    "api-server": {
      "type": "http",
      "url": "${API_BASE_URL:-https://api.example.com}/mcp",
      "headers": {
        "Authorization": "Bearer ${API_KEY}"
      }
    }
  }
}
```

必要な環境変数が設定されておらず、デフォルト値がない場合、Claude Codeは構成の解析に失敗します。

## 実践的な例

{/* ### 例：Playwrightでブラウザテストを自動化する

  ```bash
  # 1. Playwright MCPサーバーを追加する
  claude mcp add --transport stdio playwright -- npx -y @playwright/mcp@latest

  # 2. ブラウザテストを作成して実行する
  > "Test if the login flow works with test@example.com"
  > "Take a screenshot of the checkout page on mobile"
  > "Verify that the search feature returns results"
  ``` */}

### 例：Sentryでエラーを監視する

```bash  theme={null}
# 1. Sentry MCPサーバーを追加する
claude mcp add --transport http sentry https://mcp.sentry.dev/mcp

# 2. /mcpを使用してSentryアカウントで認証する
> /mcp

# 3. 本番環境の問題をデバッグする
> "What are the most common errors in the last 24 hours?"
> "Show me the stack trace for error ID abc123"
> "Which deployment introduced these new errors?"
```

### 例：コードレビューのためにGitHubに接続する

```bash  theme={null}
# 1. GitHub MCPサーバーを追加する
claude mcp add --transport http github https://api.githubcopilot.com/mcp/

# 2. Claude Codeで必要に応じて認証する
> /mcp
# GitHubの「認証」を選択

# 3. これでClaude CodeにGitHubで作業するよう依頼できます
> "Review PR #456 and suggest improvements"
> "Create a new issue for the bug we just found"
> "Show me all open PRs assigned to me"
```

### 例：PostgreSQLデータベースをクエリする

```bash  theme={null}
# 1. 接続文字列を使用してデータベースサーバーを追加する
claude mcp add --transport stdio db -- npx -y @bytebase/dbhub \
  --dsn "postgresql://readonly:pass@prod.db.com:5432/analytics"

# 2. データベースを自然にクエリする
> "What's our total revenue this month?"
> "Show me the schema for the orders table"
> "Find customers who haven't made a purchase in 90 days"
```

## リモートMCPサーバーで認証する

多くのクラウドベースのMCPサーバーは認証が必要です。Claude CodeはセキュアなOAuth 2.0接続をサポートしています。

<Steps>
  <Step title="認証が必要なサーバーを追加する">
    例：

    ```bash  theme={null}
    claude mcp add --transport http sentry https://mcp.sentry.dev/mcp
    ```
  </Step>

  <Step title="Claude Code内で/mcpコマンドを使用する">
    Claude Codeで、コマンドを使用します：

    ```
    > /mcp
    ```

    その後、ブラウザのステップに従ってログインします。
  </Step>
</Steps>

<Tip>
  ヒント：

  * 認証トークンは安全に保存され、自動的に更新されます
  * `/mcp`メニューの「Clear authentication」を使用してアクセスを取り消します
  * ブラウザが自動的に開かない場合は、提供されたURLをコピーします
  * OAuth認証はHTTPサーバーで機能します
</Tip>

## JSON構成からMCPサーバーを追加する

MCPサーバーのJSON構成がある場合、直接追加できます：

<Steps>
  <Step title="JSONからMCPサーバーを追加する">
    ```bash  theme={null}
    # 基本的な構文
    claude mcp add-json <name> '<json>'

    # 例：JSON構成を使用してHTTPサーバーを追加する
    claude mcp add-json weather-api '{"type":"http","url":"https://api.weather.com/mcp","headers":{"Authorization":"Bearer token"}}'

    # 例：JSON構成を使用してstdioサーバーを追加する
    claude mcp add-json local-weather '{"type":"stdio","command":"/path/to/weather-cli","args":["--api-key","abc123"],"env":{"CACHE_DIR":"/tmp"}}'
    ```
  </Step>

  <Step title="サーバーが追加されたことを確認する">
    ```bash  theme={null}
    claude mcp get weather-api
    ```
  </Step>
</Steps>

<Tip>
  ヒント：

  * JSONがシェルで適切にエスケープされていることを確認します
  * JSONはMCPサーバー構成スキーマに準拠する必要があります
  * `--scope user`を使用して、プロジェクト固有のサーバーの代わりにユーザー構成にサーバーを追加できます
</Tip>

## Claude DesktopからMCPサーバーをインポートする

Claude DesktopでMCPサーバーを既に構成している場合は、それらをインポートできます：

<Steps>
  <Step title="Claude Desktopからサーバーをインポートする">
    ```bash  theme={null}
    # 基本的な構文 
    claude mcp add-from-claude-desktop 
    ```
  </Step>

  <Step title="インポートするサーバーを選択する">
    コマンドを実行した後、インポートするサーバーを選択できるインタラクティブダイアログが表示されます。
  </Step>

  <Step title="サーバーがインポートされたことを確認する">
    ```bash  theme={null}
    claude mcp list 
    ```
  </Step>
</Steps>

<Tip>
  ヒント：

  * この機能はmacOSとWindows Subsystem for Linux (WSL)でのみ機能します
  * これらのプラットフォームの標準的な場所からClaude Desktop構成ファイルを読み取ります
  * `--scope user`フラグを使用してサーバーをユーザー構成に追加します
  * インポートされたサーバーはClaude Desktopと同じ名前を持ちます
  * 同じ名前のサーバーが既に存在する場合、数値サフィックスが付きます（例：`server_1`）
</Tip>

## Claude CodeをMCPサーバーとして使用する

Claude Code自体をMCPサーバーとして使用して、他のアプリケーションが接続できます：

```bash  theme={null}
# Claude をstdio MCPサーバーとして開始する
claude mcp serve
```

これはClaude Desktopで使用でき、claude\_desktop\_config.jsonにこの構成を追加します：

```json  theme={null}
{
  "mcpServers": {
    "claude-code": {
      "type": "stdio",
      "command": "claude",
      "args": ["mcp", "serve"],
      "env": {}
    }
  }
}
```

<Warning>
  **実行可能ファイルパスの構成**：`command`フィールドはClaude Code実行可能ファイルを参照する必要があります。`claude`コマンドがシステムのPATHにない場合は、実行可能ファイルへの完全なパスを指定する必要があります。

  完全なパスを見つけるには：

  ```bash  theme={null}
  which claude
  ```

  その後、構成で完全なパスを使用します：

  ```json  theme={null}
  {
    "mcpServers": {
      "claude-code": {
        "type": "stdio",
        "command": "/full/path/to/claude",
        "args": ["mcp", "serve"],
        "env": {}
      }
    }
  }
  ```

  正しい実行可能ファイルパスがないと、`spawn claude ENOENT`のようなエラーが発生します。
</Warning>

<Tip>
  ヒント：

  * サーバーはView、Edit、LSなどのClaude のツールへのアクセスを提供します
  * Claude Desktopで、Claude にディレクトリ内のファイルを読み取り、編集などを行うよう依頼してみてください。
  * このMCPサーバーはClaude Code のツールをMCPクライアントに公開しているだけなので、独自のクライアントは個々のツール呼び出しのユーザー確認を実装する責任があります。
</Tip>

## MCPの出力制限と警告

MCPツールが大きな出力を生成する場合、Claude Codeはトークン使用量を管理して会話コンテキストを圧倒するのを防ぐのに役立ちます：

* **出力警告閾値**：MCPツール出力が10,000トークンを超える場合、Claude Codeは警告を表示します
* **構成可能な制限**：`MAX_MCP_OUTPUT_TOKENS`環境変数を使用して、許可される最大MCPツール出力トークンを調整できます
* **デフォルト制限**：デフォルトの最大値は25,000トークンです

大きな出力を生成するツールの制限を増やすには：

```bash  theme={null}
# MCPツール出力の制限を高く設定する
export MAX_MCP_OUTPUT_TOKENS=50000
claude
```

これは特に以下のMCPサーバーで作業する場合に便利です：

* 大規模なデータセットまたはデータベースをクエリする
* 詳細なレポートまたはドキュメントを生成する
* 広範なログファイルまたはデバッグ情報を処理する

<Warning>
  特定のMCPサーバーで出力警告が頻繁に発生する場合は、制限を増やすか、サーバーをページネーションまたはフィルタリング応答するように構成することを検討してください。
</Warning>

## MCPリソースを使用する

MCPサーバーはファイルを参照する方法と同様に、@メンションを使用して参照できるリソースを公開できます。

### MCPリソースを参照する

<Steps>
  <Step title="利用可能なリソースをリストする">
    プロンプトで`@`を入力して、接続されたすべてのMCPサーバーから利用可能なリソースを表示します。リソースはオートコンプリートメニューのファイルと一緒に表示されます。
  </Step>

  <Step title="特定のリソースを参照する">
    `@server:protocol://resource/path`の形式を使用してリソースを参照します：

    ```
    > Can you analyze @github:issue://123 and suggest a fix?
    ```

    ```
    > Please review the API documentation at @docs:file://api/authentication
    ```
  </Step>

  <Step title="複数のリソース参照">
    1つのプロンプトで複数のリソースを参照できます：

    ```
    > Compare @postgres:schema://users with @docs:file://database/user-model
    ```
  </Step>
</Steps>

<Tip>
  ヒント：

  * リソースは参照されると自動的に取得され、添付ファイルとして含まれます
  * リソースパスは@メンションオートコンプリートでファジー検索可能です
  * Claude Codeはサーバーがサポートしている場合、MCPリソースをリストして読み取るツールを自動的に提供します
  * リソースはMCPサーバーが提供するあらゆるタイプのコンテンツを含むことができます（テキスト、JSON、構造化データなど）
</Tip>

## MCPプロンプトをスラッシュコマンドとして使用する

MCPサーバーはClaude Codeでスラッシュコマンドとして利用可能になるプロンプトを公開できます。

### MCPプロンプトを実行する

<Steps>
  <Step title="利用可能なプロンプトを発見する">
    `/`を入力して、MCPサーバーからのプロンプトを含むすべての利用可能なコマンドを表示します。MCPプロンプトは`/mcp__servername__promptname`の形式で表示されます。
  </Step>

  <Step title="引数なしでプロンプトを実行する">
    ```
    > /mcp__github__list_prs
    ```
  </Step>

  <Step title="引数を使用してプロンプトを実行する">
    多くのプロンプトは引数を受け入れます。コマンドの後にスペース区切りで渡します：

    ```
    > /mcp__github__pr_review 456
    ```

    ```
    > /mcp__jira__create_issue "Bug in login flow" high
    ```
  </Step>
</Steps>

<Tip>
  ヒント：

  * MCPプロンプトは接続されたサーバーから動的に発見されます
  * 引数はプロンプトの定義されたパラメータに基づいて解析されます
  * プロンプト結果は会話に直接注入されます
  * サーバーとプロンプト名は正規化されます（スペースはアンダースコアになります）
</Tip>

## 管理対象MCP構成

MCPサーバーの集中管理が必要な組織の場合、Claude Codeは2つの構成オプションをサポートしています：

1. **`managed-mcp.json`による排他的制御**：ユーザーが変更または拡張できない固定のMCPサーバーセットをデプロイ
2. **許可リスト/拒否リストによるポリシーベースの制御**：ユーザーが独自のサーバーを追加できるようにしますが、許可されているサーバーを制限

これらのオプションにより、IT管理者は以下を実行できます：

* **従業員がアクセスできるMCPサーバーを制御する**：組織全体で承認されたMCPサーバーの標準化されたセットをデプロイ
* **許可されていないMCPサーバーを防止する**：ユーザーが承認されていないMCPサーバーを追加するのを制限
* **MCPを完全に無効にする**：必要に応じてMCP機能を完全に削除

### オプション1：managed-mcp.jsonによる排他的制御

`managed-mcp.json`ファイルをデプロイすると、すべてのMCPサーバーの**排他的制御**が行われます。ユーザーはこのファイルで定義されているもの以外のMCPサーバーを追加、変更、または使用することはできません。これは完全な制御を望む組織にとって最も単純なアプローチです。

システム管理者は構成ファイルをシステム全体のディレクトリにデプロイします：

* macOS：`/Library/Application Support/ClaudeCode/managed-mcp.json`
* LinuxおよびWSL：`/etc/claude-code/managed-mcp.json`
* Windows：`C:\Program Files\ClaudeCode\managed-mcp.json`

<Note>
  これらはシステム全体のパス（`~/Library/...`のようなユーザーホームディレクトリではない）で、管理者権限が必要です。IT管理者によってデプロイされるように設計されています。
</Note>

`managed-mcp.json`ファイルは標準的な`.mcp.json`ファイルと同じ形式を使用します：

```json  theme={null}
{
  "mcpServers": {
    "github": {
      "type": "http",
      "url": "https://api.githubcopilot.com/mcp/"
    },
    "sentry": {
      "type": "http",
      "url": "https://mcp.sentry.dev/mcp"
    },
    "company-internal": {
      "type": "stdio",
      "command": "/usr/local/bin/company-mcp-server",
      "args": ["--config", "/etc/company/mcp-config.json"],
      "env": {
        "COMPANY_API_URL": "https://internal.company.com"
      }
    }
  }
}
```

### オプション2：許可リストと拒否リストによるポリシーベースの制御

排他的な制御を行う代わりに、管理者はユーザーが独自のMCPサーバーを構成できるようにしながら、許可されているサーバーに制限を適用できます。このアプローチは[管理対象設定ファイル](/ja/settings#settings-files)の`allowedMcpServers`と`deniedMcpServers`を使用します。

<Note>
  **オプション間の選択**：固定のサーバーセットをユーザーのカスタマイズなしでデプロイする場合はオプション1（`managed-mcp.json`）を使用します。ユーザーがポリシー制約内で独自のサーバーを追加できるようにする場合はオプション2（許可リスト/拒否リスト）を使用します。
</Note>

#### 制限オプション

許可リストまたは拒否リストの各エントリは、3つの方法でサーバーを制限できます：

1. **サーバー名による** (`serverName`)：サーバーの構成名と一致
2. **コマンドによる** (`serverCommand`)：stdioサーバーを開始するために使用される正確なコマンドと引数と一致
3. **URLパターンによる** (`serverUrl`)：ワイルドカード対応のリモートサーバーURLと一致

**重要**：各エントリは`serverName`、`serverCommand`、または`serverUrl`のいずれか1つだけを持つ必要があります。

#### 構成例

```json  theme={null}
{
  "allowedMcpServers": [
    // サーバー名で許可
    { "serverName": "github" },
    { "serverName": "sentry" },

    // 正確なコマンドで許可（stdioサーバーの場合）
    { "serverCommand": ["npx", "-y", "@modelcontextprotocol/server-filesystem"] },
    { "serverCommand": ["python", "/usr/local/bin/approved-server.py"] },

    // URLパターンで許可（リモートサーバーの場合）
    { "serverUrl": "https://mcp.company.com/*" },
    { "serverUrl": "https://*.internal.corp/*" }
  ],
  "deniedMcpServers": [
    // サーバー名でブロック
    { "serverName": "dangerous-server" },

    // 正確なコマンドでブロック（stdioサーバーの場合）
    { "serverCommand": ["npx", "-y", "unapproved-package"] },

    // URLパターンでブロック（リモートサーバーの場合）
    { "serverUrl": "https://*.untrusted.com/*" }
  ]
}
```

#### コマンドベースの制限の仕組み

**正確な一致**：

* コマンド配列は**正確に**一致する必要があります。コマンドと正しい順序のすべての引数
* 例：`["npx", "-y", "server"]`は`["npx", "server"]`または`["npx", "-y", "server", "--flag"]`と一致しません

**Stdioサーバーの動作**：

* 許可リストに**任意の** `serverCommand`エントリが含まれている場合、stdioサーバーはそれらのいずれかと一致する**必要があります**
* Stdioサーバーはコマンド制限が存在する場合、名前だけでは通過できません
* これにより、管理者が実行を許可するコマンドを強制できます

**非stdioサーバーの動作**：

* リモートサーバー（HTTP、SSE、WebSocket）は、許可リストに`serverUrl`エントリが存在する場合、URLベースのマッチングを使用します
* URLエントリが存在しない場合、リモートサーバーは名前ベースのマッチングにフォールバックします
* コマンド制限はリモートサーバーに適用されません

#### URLベースの制限の仕組み

URLパターンは`*`を使用してワイルドカードをサポートし、任意の文字シーケンスと一致します。これは特定のドメインまたはサブドメイン全体を許可するのに便利です。

**ワイルドカードの例**：

* `https://mcp.company.com/*` - 特定のドメイン上のすべてのパスを許可
* `https://*.example.com/*` - example.comの任意のサブドメインを許可
* `http://localhost:*/*` - localhostの任意のポートを許可

**リモートサーバーの動作**：

* 許可リストに**任意の** `serverUrl`エントリが含まれている場合、リモートサーバーはそれらのURLパターンのいずれかと一致する**必要があります**
* リモートサーバーはURL制限が存在する場合、名前だけでは通過できません
* これにより、管理者が許可されるリモートエンドポイントを強制できます

<Accordion title="例：URLのみの許可リスト">
  ```json  theme={null}
  {
    "allowedMcpServers": [
      { "serverUrl": "https://mcp.company.com/*" },
      { "serverUrl": "https://*.internal.corp/*" }
    ]
  }
  ```

  **結果**：

  * `https://mcp.company.com/api`のHTTPサーバー：✅ 許可（URLパターンと一致）
  * `https://api.internal.corp/mcp`のHTTPサーバー：✅ 許可（ワイルドカードサブドメインと一致）
  * `https://external.com/mcp`のHTTPサーバー：❌ ブロック（URLパターンと一致しない）
  * 任意のコマンドのStdioサーバー：❌ ブロック（一致する名前またはコマンドエントリなし）
</Accordion>

<Accordion title="例：コマンドのみの許可リスト">
  ```json  theme={null}
  {
    "allowedMcpServers": [
      { "serverCommand": ["npx", "-y", "approved-package"] }
    ]
  }
  ```

  **結果**：

  * `["npx", "-y", "approved-package"]`のStdioサーバー：✅ 許可（コマンドと一致）
  * `["node", "server.js"]`のStdioサーバー：❌ ブロック（コマンドと一致しない）
  * 「my-api」という名前のHTTPサーバー：❌ ブロック（一致する名前エントリなし）
</Accordion>

<Accordion title="例：混合名とコマンドの許可リスト">
  ```json  theme={null}
  {
    "allowedMcpServers": [
      { "serverName": "github" },
      { "serverCommand": ["npx", "-y", "approved-package"] }
    ]
  }
  ```

  **結果**：

  * 「local-tool」という名前で`["npx", "-y", "approved-package"]`のStdioサーバー：✅ 許可（コマンドと一致）
  * 「local-tool」という名前で`["node", "server.js"]`のStdioサーバー：❌ ブロック（コマンドエントリが存在しますが一致しない）
  * 「github」という名前で`["node", "server.js"]`のStdioサーバー：❌ ブロック（stdioサーバーはコマンドエントリが存在する場合、コマンドと一致する必要があります）
  * 「github」という名前のHTTPサーバー：✅ 許可（名前と一致）
  * 「other-api」という名前のHTTPサーバー：❌ ブロック（名前と一致しない）
</Accordion>

<Accordion title="例：名前のみの許可リスト">
  ```json  theme={null}
  {
    "allowedMcpServers": [
      { "serverName": "github" },
      { "serverName": "internal-tool" }
    ]
  }
  ```

  **結果**：

  * 任意のコマンドで「github」という名前のStdioサーバー：✅ 許可（コマンド制限なし）
  * 任意のコマンドで「internal-tool」という名前のStdioサーバー：✅ 許可（コマンド制限なし）
  * 「github」という名前のHTTPサーバー：✅ 許可（名前と一致）
  * 「other」という名前のサーバー：❌ ブロック（名前と一致しない）
</Accordion>

#### 許可リスト動作（`allowedMcpServers`）

* `undefined`（デフォルト）：制限なし。ユーザーは任意のMCPサーバーを構成できます
* 空配列`[]`：完全なロックダウン。ユーザーはMCPサーバーを構成できません
* エントリのリスト：ユーザーは名前、コマンド、またはURLパターンで一致するサーバーのみを構成できます

#### 拒否リスト動作（`deniedMcpServers`）

* `undefined`（デフォルト）：サーバーはブロックされません
* 空配列`[]`：サーバーはブロックされません
* エントリのリスト：指定されたサーバーはすべてのスコープ全体で明示的にブロックされます

#### 重要な注意事項

* **オプション1とオプション2を組み合わせることができます**：`managed-mcp.json`が存在する場合、排他的な制御があり、ユーザーはサーバーを追加できません。許可リスト/拒否リストは管理対象サーバー自体に適用されます。
* **拒否リストは絶対的な優先順位を持ちます**：サーバーが拒否リストエントリ（名前、コマンド、またはURL）と一致する場合、許可リストに含まれていても、ブロックされます
* **名前ベース、コマンドベース、URLベースの制限は一緒に機能します**：サーバーは名前エントリ、コマンドエントリ、またはURLパターンのいずれかと一致する場合に通過します（拒否リストでブロックされていない限り）

<Note>
  **`managed-mcp.json`を使用する場合**：ユーザーは`claude mcp add`または構成ファイルを通じてMCPサーバーを追加できません。`allowedMcpServers`と`deniedMcpServers`設定は、実際にロードされる管理対象サーバーをフィルタリングするために適用されます。
</Note>
