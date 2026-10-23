> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# 組織の MCP サーバーアクセスを制御する

> 管理対象設定ファイル、管理対象設定、許可リスト、拒否リストを使用して、ユーザーが追加または接続できる MCP サーバーを制限するか、すべてのユーザーにサーバーを提供します。

デフォルトでは、Claude Code を実行している誰もが、選択した任意の [MCP サーバー](/docs/ja/mcp.md) に接続できます。Anthropic は、[Anthropic Directory](https://claude.ai/directory) に追加する前に、コネクターを [リスティング基準](https://claude.com/docs/connectors/building/review-criteria) に照らして確認しますが、MCP サーバーのセキュリティ監査や管理は行いません。管理者として、組織内で実行されるサーバーを制限できます。固定された承認済みセットのデプロイから MCP 全体の無効化まで、すべてのユーザーにサーバーを提供することもできます。

これらの制限は、Claude Code が自身で読み込むサーバー（claude.ai から取得するコネクターを含む）に適用されます。デスクトップアプリがローカルセッションと SSH セッションに配信するコネクターはプロセス内で到着し、代わりに claude.ai 組織設定から管理されます。[コネクターが Claude Code に到達する方法](/docs/ja/mcp.md#how-connectors-reach-claude-code) は、クラウドセッションを含む各種セッションのコネクターに適用される制御を示しています。

このページでは、以下の方法について説明します。

* [必要な制御量に合致するパターンを選択する](#choose-a-pattern)
* [`managed-mcp.json` で固定サーバーセットをデプロイする](#exclusive-control-with-managed-mcp-json)（[MCP 全体を無効化する](#disable-mcp-entirely) 方法を含む）
* [管理対象設定を通じてサーバーを提供する](#provide-servers-through-managed-settings)（ユーザーが独自のサーバーを保持する場合）
* [許可リストと拒否リストでサーバーを制御する](#policy-based-control-with-allowlists-and-denylists)
* [制限がサーバーをブロックするときにユーザーが何を期待するかを伝える](#how-restrictions-appear-to-users)
* [組織が実際に使用するサーバーを監視する](#monitor-mcp-usage)

> [!NOTE]
>
> [セキュリティ](/docs/ja/security.md) ページは MCP の脅威モデルと、サーバーを承認する前に評価する方法について説明しています。[実施する内容を決定する](/docs/ja/admin-setup.md#decide-what-to-enforce) は、他の管理制御と並んで MCP 制限について説明しています。

## パターンを選択する

Claude Code は、さまざまな制限レベルをサポートしています。各パターンは、以下で説明するメカニズムの 1 つ以上を使用します。`managed-mcp.json` は固定セットをデプロイするため、`managedMcpServers` マネージド設定はユーザーが追加するサーバーと共にサーバーを提供するため、`allowedMcpServers`/`deniedMcpServers` はユーザーが設定する内容をフィルタリングするためです。

| パターン | 機能 | 設定 |
| :- | :- | :- |
| **MCP を無効化** | [排他的制御](#exclusive-control-with-managed-mcp-json)の下で読み込まれるいくつかのサーバーを除き、サーバーは読み込まれません | 空のサーバーマップを含む `managed-mcp.json` |
| **固定デプロイ** | すべてのユーザーが同じサーバーを取得し、他のサーバーを追加できません | 必要なサーバーを含む `managed-mcp.json` |
| **提供されるサーバー** | すべてのユーザーがリストされたリモートサーバーを取得し、独自のサーバーを保持します | マネージド設定の `managedMcpServers` |
| **承認されたカタログ** | 承認されたサーバーのリストを公開します。ユーザーは必要なものを追加し、その他はすべてブロックされます | `allowedMcpServers` + `allowManagedMcpServersOnly: true` |
| **プラグインサーバーのみ** | ユーザーは `~/.claude.json` または `.mcp.json` を通じてサーバーを追加できません。[スキルディレクトリプラグイン](/docs/ja/plugins/loading.md#skills-directory-plugins-blocked-by-managed-settings)はプラグインとして読み込まれなくなり、その他のプラグインのサーバーは引き続き読み込まれます | [`strictPluginOnlyCustomization`](/docs/ja/settings-reference#strictpluginonlycustomization) とリストの `mcp` |
| **ソフト許可リスト** | ユーザーが独自の設定で拡張できる許可リストを適用します | `allowManagedMcpServersOnly` なしの `allowedMcpServers` |
| **拒否リストのみ** | 既知の不正なサーバーをブロックし、その他はすべて許可します | `deniedMcpServers` |
| **制限なし** | ユーザーは何でも追加できます | マネージド MCP 設定をデプロイしないでください |

> [!NOTE]
>
> Claude Code には、ユーザーが参照してインストールできる組み込み MCP サーバーレジストリはありません。承認されたカタログパターンの場合、承認されたリストとその `claude mcp add` コマンドを、内部 wiki などのユーザーが見つけやすい場所で共有するか、[マネージドプラグインマーケットプレイス](/docs/ja/plugins/org.md#restrict-what-users-can-install)を通じてプラグインとしてサーバーを配布して、ユーザーが `/plugin` から参照してインストールできるようにしてください。

## managed-mcp.json による排他的制御

`managed-mcp.json` ファイルをデプロイすると、Claude Code はこれらの MCP サーバーのみを読み込みます。

* ファイルで定義されたサーバー
* [「`managedMcpServers` を通じて提供するサーバー」](#provide-servers-through-managed-settings)
* セッションを開始したアプリが登録するインプロセスサーバー（VS Code 拡張機能独自のサーバーや[デスクトップアプリが提供するコネクタ](/docs/ja/mcp.md#how-connectors-reach-claude-code)など）
* [「Claude in Chrome」](/docs/ja/chrome.md)の組み込みサーバー（[マネージドセットと共にそれを許可](#allow-claude-in-chrome-alongside-the-managed-set)する場合）

ユーザーは、プラグイン提供のサーバーや[「`--mcp-config` CLI フラグ」](/docs/ja/cli-reference#cli-flags)で渡されたサーバーを含む、その他の MCP サーバーを追加、変更、または使用することはできません。このファイルは、[マネージドセットと共にそれらを許可](#allow-claude-ai-connectors-alongside-the-managed-set)しない限り、Claude Code が自身で取得する claude.ai コネクタも抑制します。

### managed-mcp.json をデプロイする

`managed-mcp.json` はスタンドアロンファイルであるため、[サーバー管理設定](/docs/ja/server-managed-settings.md)を通じて配信することはできません。マネージドセットなしで管理設定を通じてサーバーを配信するには、代わりに[「`managedMcpServers`」](#provide-servers-through-managed-settings)を使用してください。

管理者権限を持つシステムパスに書き込むことができるすべてのプロセスがファイルをデプロイできます。フリート全体では、通常は Jamf などのデバイス管理ツール、macOS 上の構成プロファイル、Windows 上のグループポリシーまたは Intune、または Linux 上の選択したフリート管理を通じて行われます。Claude Code は以下のパスのいずれかでファイルを探します。

| プラットフォーム | パス |
| :- | :- |
| macOS | `/Library/Application Support/ClaudeCode/managed-mcp.json` |
| Linux と WSL | `/etc/claude-code/managed-mcp.json` |
| Windows | `C:\Program Files\ClaudeCode\managed-mcp.json` |

このファイルはプロジェクト[「`.mcp.json`」](/docs/ja/mcp#project-scope)ファイルと同じ形式を使用します。

```json theme={null}
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
        "COMPANY_API_URL": "https://internal.example.com"
      }
    }
  }
}
```

### ユーザーごとの認証情報で認証する

マシン上のすべてのユーザーがこのファイルを読むことができるため、API キーやその他の認証情報を `env` ブロックに保存しないでください。代わりに、以下のいずれかを使用してユーザーごとの認証情報を渡してください。

* [「`${VAR}` 展開」](/docs/ja/mcp#environment-variable-expansion-in-mcp-json)を使用して、各ユーザーの環境からシークレットを読み込む。
* [「OAuth またはユーザーごとのヘッダー」](/docs/ja/mcp.md#authenticate-with-remote-mcp-servers)を使用して、各ユーザーが自分自身として認証する。
* [「`headersHelper`」](/docs/ja/mcp#use-dynamic-headers-for-custom-authentication)を使用して、接続時に認証情報を生成する。

### `--mcp-config` または `--strict-mcp-config` で渡されたサーバー

セッションが `managed-mcp.json` がデプロイされている間に `--mcp-config` を通じてサーバーを受け取る場合、ユーザーが見るものはワークステーションとクラウドセッション間で異なります。

* ワークステーション上では、Claude Code は `You cannot dynamically configure MCP servers when an enterprise MCP config is present` というメッセージで起動時に終了します。
* ファイルがデプロイされているホスト上の[「クラウドセッション」](/docs/ja/claude-code-on-the-web.md)（[「セルフホストランナー」](/docs/ja/self-hosted-environments-configuration.md#mcp-servers)など）では、Claude Code はマネージドサーバーのみで起動し、claude.ai コネクタおよびクラウドホストが `--mcp-config` を通じて配信するその他のサーバーをスキップします。セッション内のどのサーバーが除外されたかをユーザーに伝えるものはありません。Claude Code はそれらを stderr の警告で名前を付けます。これはセルフホストランナーが `debug` ログレベルで記録します。

`--strict-mcp-config` フラグはマネージドセットを置き換えるよう要求します。ユーザーがそのようなファイルがデプロイされている間にそれを渡す場合、Claude Code はワークステーション上とクラウドセッション上の両方で起動時に終了します。

### 許可リストと拒否リストがマネージドセットに適用される方法

拒否リストは `managed-mcp.json` 内のサーバーをさらにフィルタリングできます。

* `deniedMcpServers` はマネージドサーバーにも適用されるため、エントリに一致するマネージドサーバーは読み込まれません。
* ユーザー独自の `deniedMcpServers` は設定からマージされるため、ユーザーはマネージドサーバーを自分自身でブロックできます。

`managed-mcp.json` 内のサーバーには `allowedMcpServers` エントリは不要ですが、1 つの例外があります。サーバーが `env` 以外で[「`${VAR}` 展開」](/docs/ja/mcp#environment-variable-expansion-in-mcp-json)を使用する場合、Claude Code はそのサーバーを許可リストに対してチェックします。v2.1.305 より前では、`env` 内でのみ `${VAR}` 展開を使用するサーバーもチェックしていました。また v2.1.259 より前では、許可リストが設定されている場合は常にすべてのマネージドサーバーをチェックしていました。どのフィールドが `${VAR}` チェックをトリガーするか、およびチェックの完全な順序については、[「サーバーがどのように評価されるか」](#how-a-server-is-evaluated)を参照してください。

`allowedMcpServers` を使用して独自の `managed-mcp.json` サーバーの一部が読み込まれないようにしていた場合は、ユーザーがアップグレードする前に、それらのサーバーに対する `deniedMcpServers` エントリを追加するか、グループごとに別の `managed-mcp.json` をデプロイしてください。`env` 以外で `${VAR}` 展開を使用しない限り、これらのサーバーは、それらをチェックしないバージョンを各ユーザーが初めて起動したときに、プロンプトや通知なしで読み込まれ始めます。

### 構成を検証する

ファイルが有効であることを確認するには、マネージドマシン上で 2 つのチェックを実行してください。

1. `claude mcp list` は `managed-mcp.json` 内のサーバーのみを表示します。`managedMcpServers` を通じて提供するサーバーも表示されます。2 つの他の結果は何かが間違っていることを意味します。
   * ユーザー独自のサーバーがまだ表示される場合、Claude Code はファイルを読み込んでいません。そのパスと親ディレクトリの権限を確認してください。
   * ファイルのサーバーが表示されず、`MCP config diagnostics` セクションがエンタープライズ構成の解析失敗をマークしている場合、Claude Code はファイルを読み込むか解析できません。そのセクションが名前を付けるエラーを修正してから、ユーザーに Claude Code を再起動させてください。
2. `claude mcp add --transport http test https://example.com/mcp` は `Cannot add MCP server: enterprise MCP configuration is active and has exclusive control over MCP servers` で失敗します。ポリシーチェックが何かに接続される前にコマンドを拒否するため、URL は実際のサーバーである必要はありません。

### MCP を完全に無効にする

空のサーバーマップを含む `managed-mcp.json` をデプロイして、[「排他的制御」](#exclusive-control-with-managed-mcp-json)の下で読み込まれるもの以外のすべての MCP サーバーをブロックします。

```json theme={null}
{
  "mcpServers": {}
}
```

`claude mcp add` は上記のエンタープライズポリシーエラーで失敗します。ユーザーが以前に構成したサーバーは、次回セッションを開始するときに読み込まれなくなります。ポリシーが理由であることについての警告はありません。`managedMcpServers` を通じて提供するサーバーと、マネージドセットと共に許可するその他のすべてのものは、空のマップの下でも読み込まれるため、MCP を完全に無効にするにはそれらのキーを設定しないままにしてください。

### マネージドセットと共に claude.ai コネクタを許可する

デフォルトでは、`managed-mcp.json` をデプロイすると、Claude Code が自身で取得する[「claude.ai コネクタ」](/docs/ja/mcp.md#use-mcp-servers-from-claude-ai)（管理者が claude.ai 管理コンソールで組織用に構成したコネクタを含む）が抑制されます。`managed-mcp.json` 内のサーバーと共にそれらのコネクタを読み込むには、[「マネージド設定ソース」](/docs/ja/admin-setup.md#decide-how-settings-reach-devices)で `"allowAllClaudeAiMcps": true` を設定してください。

設定が有効になると、Claude Code は `managed-mcp.json` がデプロイされていない場合に読み込むのと同じ claude.ai コネクタを読み込みます。[「許可リストと拒否リスト」](#policy-based-control-with-allowlists-and-denylists)はそれらのコネクタに引き続き適用されるため、`deniedMcpServers` で特定のコネクタをブロックできます。この設定は Claude Code が自身で取得する claude.ai コネクタのみに影響します。プラグイン提供のサーバーは抑制されたままです。

クラウドセッションとデスクトップアプリのローカルおよび SSH セッションは、別の方法でコネクタを受け取ります。これは[「コネクタが Claude Code に到達する方法」](/docs/ja/mcp.md#how-connectors-reach-claude-code)で説明されています。クラウドセッションを実行するホスト上の `managed-mcp.json`（[「セルフホストランナーホスト」](/docs/ja/self-hosted-environments-configuration.md#mcp-servers)など）は、`allowAllClaudeAiMcps` を設定するかどうかに関わらず、そのセッションのコネクタを抑制します。デスクトップアプリがローカルおよび SSH セッションに配信するコネクタには `managed-mcp.json` は到達しません。

Claude Code は `allowAllClaudeAiMcps` を管理者制御のポリシー層からのみ読み込みます。サーバー管理設定、MDM デプロイされた plist または HKLM レジストリキー、またはシステム `managed-settings.json` ファイルです。ユーザーまたはプロジェクト設定に配置しても効果がないため、ユーザーは排他的制御が抑制したコネクタを再度有効にすることはできません。

### マネージドセットと共に Claude in Chrome を許可する

デフォルトでは、`managed-mcp.json` をデプロイすると、Claude Code はターミナルセッションで組み込みの[「Claude in Chrome」](/docs/ja/chrome.md)サーバーをブロックします。ユーザーは[「拡張機能インストールプロンプト」](/docs/ja/chrome.md#install-the-extension-when-claude-asks)を取得しません。また、ユーザーが[「Chrome をデフォルトで有効にした」](/docs/ja/chrome.md#enable-chrome-by-default)セッションは、Chrome なしで起動し、警告を出力しません。本来であれば Claude in Chrome を実行できるユーザーが `claude --chrome` を起動した場合、Claude Code は `allowClaudeInChromeWithManagedMcp` 設定の名前を示すエラーで起動時に終了します。

ユーザーがマネージドセットと共に Claude in Chrome を実行できるようにするには、デバイス独自の管理設定で `"allowClaudeInChromeWithManagedMcp": true` を設定してください。MDM デプロイされた plist、HKLM レジストリキー、またはシステム `managed-settings.json` ファイルのうち、Claude Code がそのデバイスで[「選択」](/docs/ja/managed-settings.md#precedence-within-the-managed-tier)するものに配置してください。Claude Code v2.1.282 以降が必要です。[「サーバー管理設定」](/docs/ja/server-managed-settings.md)がポリシーの残りを配信する場合でも、Claude Code はそれらのデバイスソースからのみこの設定を読み込みます。この設定がオンの場合でも、`claude-in-chrome` に対する[「`deniedMcpServers`」](#policy-based-control-with-allowlists-and-denylists)エントリは引き続きサーバーをブロックします。

## マネージド設定を通じてサーバーを提供する

MCP を排他的に制御することなく、すべてのユーザーにリモート MCP サーバーのセットを提供するには、[マネージド設定ソース](/docs/ja/admin-setup.md#decide-how-settings-reach-devices)（サーバーマネージド設定、[Claude アプリゲートウェイ](/docs/ja/claude-apps-gateway-config.md#what-goes-in-cli)ポリシー、MDM プロファイルまたはレジストリポリシー、または `managed-settings.json`）の `managedMcpServers` の下にリストします。ユーザーは自分で追加したサーバーを保持し、さらにあなたのサーバーを受け取ります。Claude Code v2.1.259 以降が必要です。以前のクライアントはこのキーを無視します。

値はサーバー名をキーとするオブジェクトです。各エントリは、プロジェクト [`.mcp.json`](/docs/ja/mcp#project-scope) ファイル内の HTTP または SSE サーバーと同じ形状を持ち、[リモート MCP サーバーで認証する](/docs/ja/mcp.md#authenticate-with-remote-mcp-servers)で説明されているオプションの `headers` および `oauth` メンバーを含みます。この例は、各ユーザーが OAuth でサインインする検索サーバーと、組織が発行するヘッダーを送信するレコードサーバーを提供します。

```json theme={null}
{
  "managedMcpServers": {
    "search": {
      "type": "http",
      "url": "https://search.example.com/mcp"
    },
    "records": {
      "type": "http",
      "url": "https://records.example.com/mcp",
      "headers": {
        "X-Records-Key": "key-issued-for-all-claude-code-users"
      }
    }
  }
}
```

マシン上のマネージド設定を読み取ることができるすべてのユーザー（ユーザー自身を含む）は、ここで設定したヘッダー値を読み取ることができます。その全体的なオーディエンス向けに発行された認証情報を使用するか、`headers` を省略して、各ユーザーが OAuth でサインインするようにしてください。

### エントリに含めることができるもの

Claude Code は、以下のすべてのチェックに合格した場合にのみエントリを読み込みます。1 つのチェックに失敗したエントリはドロップし、`/status` で読み取ることができる通知を記録し、他のエントリは引き続き読み込みます。

* `type` は `http` または `sse` です。`.mcp.json` と同様に、`streamable-http` は `http` のエイリアスとして受け入れられます。
* `url` は `https://` URL です。Claude Code は `localhost` を指すものを含む、プレーンな `http://` URL を拒否します。
* エントリに `command`、`args`、`env`、または `headersHelper` メンバーがないため、マネージド設定ドキュメントはユーザーのマシン上で実行するプログラムを指定しません。
* 値に `${VAR}` 参照が含まれていません。Claude Code はこれらのエントリ内の環境変数を展開しないため、リテラル値を記述してください。
* サーバー名には文字、数字、ハイフン、アンダースコアのみが含まれ、キーまたは値に制御文字や非表示の書式文字が含まれていません。

Claude Desktop には同じ名前のマネージド設定があり、その値は異なるエントリ形状の配列であるため、一方を他方にコピーしないでください。Claude Code は配列形式を受け入れず、代わりに通知を記録します。

Claude アプリゲートウェイは起動時に同じチェックを実行します。[ポリシー内の MCP サーバー](/docs/ja/claude-apps-gateway-config.md#mcp-servers-in-a-policy)を参照してください。

### 提供されたサーバーがどのように読み込まれるか

これらのルールは、提供されたサーバーが別のサーバー定義またはこのページの別の設定と重複する場合に何が読み込まれるかを決定します。

* 提供されたサーバーは、ローカル、プロジェクト、またはユーザースコープ内の同じ名前のサーバーよりも優先され、同じ URL を指すプラグインサーバーまたは claude.ai コネクタよりも優先されます。
* `managed-mcp.json` もデプロイする場合、Claude Code はそのサーバーと提供されたサーバーを一緒に読み込み、両方が名前を定義する場合はファイルのエントリが優先されます。
* [`strictPluginOnlyCustomization`](/docs/ja/settings-reference#strictpluginonlycustomization) が `mcp` サーフェスをロックしても、提供されたサーバーは引き続き読み込まれます。
* `deniedMcpServers` はユーザー自身の設定からのエントリを含む提供されたサーバーに適用されるため、ユーザーは自分自身のためにそれをブロックできます。提供されたサーバーは `allowedMcpServers` エントリを必要としません。

`managed-mcp.json` もデプロイしていない場合、実行ごとのフラグはその意味を保持します。

* ユーザーが同じ名前で `--mcp-config` で渡すサーバーは、その実行のために提供されたサーバーを置き換え、`allowedMcpServers` に対してチェックされます。
* `--strict-mcp-config` は、提供されたサーバーを他のすべての設定されたサーバーと一緒に除外します。

`managed-mcp.json` がデプロイされている場合、両方のフラグは [managed-mcp.json による排他的制御](#exclusive-control-with-managed-mcp-json)で説明されているように動作します。

### ユーザーが見ることができ、変更できるもの

ユーザーは提供されたサーバーを編集または削除できません。

* `claude mcp remove` は、サーバーが組織によって提供されていることを報告します。
* `managed-mcp.json` もデプロイしていない場合、ユーザーが同じ名前で追加するエントリは保存されますが、あなたのサーバーが存在する間は使用されません。
* ユーザーは [`/mcp`](/docs/ja/mcp#disable-a-server-without-removing-it) で提供されたサーバーを自分自身のためにオフにすることができます。これは **Managed MCPs** の下に提供されたサーバーをリストします。

`claude mcp get` と `/mcp` は、提供されたサーバーの URL をそのホストのみとして表示します。例えば `https://mcp.example.com/…` であり、`claude mcp get` はヘッダー名を値なしで表示します。

### `managedMcpServers` が適用される場所

Claude Code は、[Claude Code がマネージドソースを組み合わせる方法](/docs/ja/managed-settings.md#how-claude-code-combines-managed-sources)の下で選択するマネージドソースから `managedMcpServers` を読み取ります。そのソースが [`managedSourcesBehavior`](/docs/ja/settings-reference#managedsourcesbehavior) を `"merge"` に設定する場合、Claude Code は代わりにすべての管理者ソースからサーバーを提供し、2 つのソースが同じ名前を定義する場合、より高いランクのソースのエントリが全体に適用されます。ユーザーが書き込み可能な HKCU レジストリから、[埋め込みホストが提供する親設定](/docs/ja/managed-settings.md#parent-settings-from-embedding-hosts)から、またはユーザー、プロジェクト、またはローカル設定ファイルから読み取ることはなく、警告とともにキーをドロップします。

Claude Code は、サードパーティデプロイメント上の Claude Desktop アプリの Code タブまたはアプリの Cowork セッションでキーを読み取りません。Claude Desktop はそれらのセッションの MCP サーバーを自身で提供およびロックするためです。マネージド設定がそこにキーを含む場合、`/status` と `claude doctor` はそう言います。

### 提供されたサーバーが接続するとき

`managedMcpServers` がサーバーマネージド設定を通じて到着する場合、そのタイミングは [フェッチとキャッシング動作](/docs/ja/server-managed-settings.md#fetch-and-caching-behavior)に従います。

* キャッシュされた設定を持つマシンでは、Claude Code はこのキーのキャッシュされたコピーを、サーバーがセッションの設定を確認するまで保留し、その確認を待ってから MCP サーバーを読み込みます。確認が失敗した場合、セッションは提供されたサーバーなしで続行され、`/status` はそれらが保留されていることを示します。
* マシンの最初の起動時に、まだキャッシュされたものがない場合、設定が到着する前に開始される対話型セッションは、提供されたサーバーが到着するとすぐに接続し、既に開始されている `claude -p` 実行はそれらなしで完了できます。

[ゲートウェイサインイン](/docs/ja/claude-apps-gateway-config.md#precedence-with-other-managed-sources)では、Claude Code はセッション開始前にポリシーを読み込むため、どちらのケースも提供されたサーバーを遅延またはスキップしません。

既に実行中の対話型セッションはキーへの編集を適用します。

* **サーバーを追加する**：Claude Code は更新された設定が到着したときにそれを接続し、再起動は不要です。
* **サーバーのエントリを変更する**：これらのセッションは新しい定義で再接続します。
* **サーバーを削除する**：実行中の対話型セッションは、変更された設定を読み取ると、それを切断します。非対話型（`-p`）実行はそれが終了するまでそれを保持します。

## 許可リストと拒否リストによるポリシーベースの制御

許可リストと拒否リストは、設定済みのサーバーのうちどれの読み込みを許可するかをフィルタリングします。これらはレジストリではありません。どちらのリストが適用されるにしても、その前にサーバーがユーザー、プラグイン、または組織によって追加されている必要があります。

組織が `managedMcpServers` を通じて配信するサーバーは許可リストのエントリなしで読み込まれます。`managed-mcp.json` のサーバーについては[許可リストのチェックをスキップするサーバー](#servers-that-skip-the-allowlist-check)で説明しています。拒否リストは、インプロセスの `type: "sdk"` エントリを除き、出所に関係なくすべてのサーバーに適用されます。

ユーザーにサーバーをデプロイするには、[`managed-mcp.json`](#exclusive-control-with-managed-mcp-json) または [`managedMcpServers`](#provide-servers-through-managed-settings) を使用します。どちらのリストも、インプロセスの `type: "sdk"` エントリを除き、ユーザーが [`--mcp-config` CLI フラグ](/docs/ja/cli-reference#cli-flags)で渡すサーバーもフィルタリングします。`--strict-mcp-config` は読み込まれる設定ファイルを制限するものであり、どちらのリストも回避しません。

許可リストを確定的なものにするには、サーバー管理設定やデプロイされた `managed-settings.json` ファイルなどの[管理設定ソース](/docs/ja/admin-setup.md#decide-how-settings-reach-devices)で、`allowedMcpServers` と `allowManagedMcpServersOnly: true` を併せて設定します。

このロックは管理者が制御するすべての管理ソースから適用されるため、MCP に言及していないサーバー管理設定が併用されている場合でも、デプロイされたファイルでのロックダウンは引き続き適用されます。ロックが有効な間、管理許可リストは、許可リストを設定している管理者ソースのうち最も順位の高いものから取得されます。ソースをまたいでロックと許可リストを読み取るには、Claude Code v2.1.273 以降が必要です。

設定方法は[許可リストを管理設定のみに制限する](#restrict-the-allowlist-to-managed-settings-only)を参照してください。

`allowManagedMcpServersOnly` がない場合、ユーザー自身の `~/.claude/settings.json` を含むすべての設定スコープの許可リストがマージされるため、ユーザーは許可リストで許可される範囲を広げることができます。拒否リストはいずれにしてもすべてのスコープからマージされます。

> [!NOTE]
>
> `allowManagedMcpServersOnly` は `allowManagedPermissionRulesOnly` とは別のものです。後者は[権限ルール](/docs/ja/permissions.md#managed-settings)のみをロックダウンします。このフラグを設定しても MCP 許可リストは強制されません。

### URL、コマンド、または名前でサーバーを照合する

`allowedMcpServers` と `deniedMcpServers` はエントリのリストです。各エントリは単一のキーを持つオブジェクトで、URL、コマンド、または名前によってサーバーを識別します。

| キー | 照合対象 | 用途 |
| :- | :- | :- |
| `serverUrl` | リモートサーバーの URL。完全一致または `*` ワイルドカード | HTTP および SSE サーバー |
| `serverCommand` | stdio サーバーを起動するコマンドと引数の完全一致 | stdio サーバー |
| `serverName` | ユーザーが割り当てたラベル。完全一致のみで、ワイルドカードは展開されません | どちらのタイプでも可。ただし[`serverName` エントリの照合方法](#how-servername-entries-match)を参照してください |

`allowedMcpServers` を未設定のままにすることは、空の配列に設定することとは異なります。

| 設定 | 未設定（デフォルト） | 空の配列 `[]` | 値あり |
| :- | :- | :- | :- |
| `allowedMcpServers` | すべてのサーバーを許可 | [許可リストのチェックをスキップするもの](#servers-that-skip-the-allowlist-check)を除き、どのサーバーも許可しない | [許可リストのチェックをスキップするもの](#servers-that-skip-the-allowlist-check)を除き、一致するサーバーのみ許可 |
| `deniedMcpServers` | どのサーバーもブロックしない | どのサーバーもブロックしない | 一致するサーバーをブロック |

エントリがスキーマ検証に失敗した場合の動作については、[管理設定の無効なエントリ](/docs/ja/managed-settings.md#invalid-entries-in-managed-settings)を参照してください。

#### `serverName` エントリの照合方法

`serverName` エントリは、ユーザーが割り当てたラベルとワイルドカードなしで完全一致で照合されます。

> [!WARNING]
>
> `serverName` エントリは、どちらのリストにおいてもセキュリティ制御ではありません。名前は、ユーザーが `claude mcp add` を実行したり設定ファイルを編集したりする際に割り当てるラベルであり、基盤となるサーバーそのものではないため、ユーザーはどのサーバーにも `github` という名前を付けることができます。claude.ai コネクタの場合、名前は claude.ai から返される表示名であり、変更される可能性があります。実際に実行されるサーバーを強制するには、`serverCommand` または `serverUrl` エントリを追加してください。

`serverName` の検証は 2 つのリストで異なります。

* `deniedMcpServers` では、`serverName` は先頭または末尾に空白のない空でない任意の文字列を受け付けるため、[claude.ai コネクタ](/docs/ja/mcp.md#use-mcp-servers-from-claude-ai)を表示名でブロックできます。たとえば、`{ "serverName": "claude.ai Slack" }` は Slack コネクタをブロックします。名前の変更に左右されない拒否が必要な場合や、コネクタ名が衝突して ` (N)` サフィックスが付く場合は、`serverUrl` エントリを優先してください。
* `allowedMcpServers` では、`serverName` は英字、数字、ハイフン、アンダースコアに限られます。Claude Code 自身が取得する claude.ai コネクタを許可リストに追加するには `serverUrl` を使用してください。クラウドホストがセルフホストのセッションに配信するコネクタについては、代わりに[コネクタのトラフィックはネットワーク外に出る](/docs/ja/self-hosted-environments-deploy.md#connector-traffic-leaves-your-network)に記載されているエントリを使用してください。

Claude Code 自身が取得するすべての claude.ai コネクタをオフにするには、[`disableClaudeAiConnectors`](/docs/ja/mcp#disable-claude-ai-connectors) を参照してください。

#### `serverCommand` エントリの照合方法

`serverCommand` エントリは、`{ "serverCommand": ["npx", "-y", "server"] }` のように、コマンドとその引数を 1 つの配列として保持します。Claude Code はこの配列を、サーバーの設定内のコマンドおよび引数と比較します。

* **コマンドは完全一致で照合されます。** すべての引数が順序どおりに一致する必要があります。`["npx", "-y", "server"]` は `["npx", "server"]` にも `["npx", "-y", "server", "--flag"]` にも一致しません。
* **`env` ブロックは比較されません。** `["node", "server.js"]` は、そのコマンドを任意の `env` 値で実行するサーバーに一致します。一部の環境変数は、起動時に `node` が読み込む内容を変更します。`env` の値を自分で設定するには、[`managed-mcp.json`](#exclusive-control-with-managed-mcp-json) でサーバーを定義してください。

#### `serverUrl` エントリの照合方法

URL は `*` ワイルドカードをサポートしており、スキーム全体を `*` にすることもできます。ホスト名の照合では大文字と小文字が区別されず、末尾の FQDN のドットは無視されるため、`https://Mcp.Example.com/*` は `https://mcp.example.com/api` に一致します。パスは大文字と小文字が区別されたままです。ポートを指定しない場合、ホスト名の書き方によって、パターンがスキームのデフォルトポートのみに一致するか、すべてのポートに一致するかが決まります。

* **ホスト名を完全に記述した場合**: デフォルトポートのみ（`https` の場合は 443、`http` の場合は 80）
* **ホスト名に `*` を含む場合**: すべてのポート

一般的なパターンで許可される内容を次の表に示します。

| パターン | 許可される内容 |
| :- | :- |
| `https://mcp.example.com/*` | 特定のドメイン上のすべてのパス（ポート 443 のみ） |
| `https://mcp.example.com` | 同じくそのドメイン上のすべてのパス（ポート 443 のみ）。パスのないパターンは任意のパスに一致します |
| `https://mcp.example.com:8443/*` | そのドメイン上のすべてのパス（ポート 8443 のみ） |
| `https://mcp.example.com:*/*` | そのドメイン上のすべてのパス（443 を含む任意のポート） |
| `https://*.example.com/*` | `example.com` の任意のサブドメイン（任意のポート） |
| `http://localhost:*/*` | localhost の任意のポート |
| `*://mcp.example.com/*` | 特定のドメインへの任意のスキーム（各スキームのデフォルトポートのみ） |

`deniedMcpServers` のエントリも同じ方法でポートを照合するため、`staging.example.com` のエントリは、ブロックする必要のあるポートとスキームに応じて選択してください。

* `https://staging.example.com/*`：そのホスト上の `https` サーバーをポート 443 のみでブロックするため、`https://staging.example.com:8443/api` にあるサーバーはブロックされません
* `https://staging.example.com:*/*`：そのホスト上の `https` サーバーをすべてのポートでブロックします
* `*://staging.example.com:*/*`：そのホストを任意のスキーム、任意のポートでブロックします

#### `serverCommand` および `serverUrl` エントリー内の環境変数

`serverCommand` と `serverUrl` の値は照合の前に展開されます。ポリシーエントリとサーバーに設定された値の両方が [`${VAR}` および `${VAR:-default}` の展開](/docs/ja/mcp#environment-variable-expansion-in-mcp-json)を経るため、`["${HOME}/bin/server"]` と記述されたエントリは、同じ参照を使用するサーバー設定にも、展開後のパスを使用するサーバー設定にも一致します。`serverName` の値はリテラルとして照合され、展開されることはありません。

両者は異なる環境を読み取ります。

* **サーバーに設定された値**：`.mcp.json` の他の部分と同様に、実行中のプロセス環境から展開されます
* **ポリシーエントリ**：固定された環境から展開されるため、プロジェクトやユーザーの設定ファイルで設定された変数によって許可リストのエントリの意味が変わることはありません

ポリシーエントリは、参照する変数について依然として起動元シェルの値に依存するため、強制のために依拠するエントリにはリテラルの URL とコマンドを使用してください。

Windows では、`${HOME}` の代わりに `${USERPROFILE}` など、Windows で設定されている環境変数を参照してください。

2 つのリストは展開方法が異なります。

| エントリリスト | 展開元 | URL エントリのスキーム、ホスト、またはパスの範囲を変更するような展開の場合 |
| - | - | - |
| `allowedMcpServers` | Claude Code の起動時の環境、および管理設定の `env` 値 | Claude Code はそのエントリを無視します |
| `deniedMcpServers` | 同上。加えて、起動時の値も `:-default` もない変数は、ユーザー設定や管理設定などリポジトリ外の設定ファイルから値が補われます。これによってエントリが一致する範囲は広がる一方で、狭まることはありません | エントリは引き続き一致します |

固定された環境とこの表のルールには、Claude Code v2.1.219 以降が必要です。

### サーバーの評価方法

`managed-mcp.json` のサーバーを含め、サーバーを読み込む前に、Claude Code は以下の 3 つのチェックを順に実行します。ユーザーが `/mcp` でサーバーを再接続したり、無効化されたサーバーを再びオンにしたりした場合にも、これらのチェックが再度実行されます。[セッションを開始したアプリが登録する](/docs/ja/mcp.md#how-connectors-reach-claude-code)インプロセスの `type: "sdk"` サーバーは、3 つのチェックすべてをスキップします。

1. **リストをマージする。** すべての設定スコープの許可リストと拒否リストのエントリが、1 つの許可リストと 1 つの拒否リストに統合されます。`allowManagedMcpServersOnly` が `true` の場合、管理許可リストのみが保持されます。拒否リストは常にすべてのスコープからマージされます。複数の管理ソースが存在する場合、どのソースが管理スコープのリストを提供するかについては、[すべての管理者ソースから読み取られるキー](/docs/ja/managed-settings.md#keys-read-from-every-admin-source)を参照してください。
2. **拒否リストをチェックする。** URL、コマンド、または名前によっていずれかの拒否リストエントリに一致するサーバーはブロックされます。拒否リストへの一致を上書きするものはありません。
3. **許可リストをチェックする。** [一部のサーバーはこのチェックをスキップします](#servers-that-skip-the-allowlist-check)。`allowedMcpServers` がどこにも設定されていない場合、拒否リストを通過したすべてのサーバーが読み込まれます。設定されている場合、サーバーが一致する必要のある対象は、下の表に示すとおりそのタイプによって異なります。

| サーバータイプ | 許可される条件 |
| :- | :- |
| リモート（HTTP または SSE） | `serverUrl` エントリに一致すること。`serverName` への一致は、許可リストに `serverUrl` エントリが 1 つもない場合にのみ有効です |
| stdio | `serverCommand` エントリに一致すること。`serverName` への一致は、許可リストに `serverCommand` エントリが 1 つもない場合にのみ有効です |

#### 許可リストのチェックをスキップするサーバー

[3 つのチェックすべて](#how-a-server-is-evaluated)をスキップするインプロセスの `type: "sdk"` サーバーに加えて、次の 3 つのグループのサーバーが許可リストのチェックをスキップします。

* 組織自身のサーバー：すべての `managedMcpServers` エントリ、および `env` 以外の値で `${VAR}` 展開を使用していない `managed-mcp.json` エントリ。
* 組み込みサーバー：Claude in Chrome、実行中の VS Code または JetBrains IDE で Claude Code が接続する `ide` サーバー、CLI 自身が設定するサーバーなど。
* [Claude Tag](/docs/ja/claude-tag.md) セッションの Slack ツール：スレッドを読み取り返信を投稿するために使用するサーバーは、許可リストのエントリなしで読み込まれます。

コマンド、引数、URL、またはヘッダーで `${VAR}` 展開を使用する `managed-mcp.json` サーバーは、引き続きチェックされます。Claude Code は、ユーザー、プラグイン、または claude.ai が追加するすべてのサーバー、およびユーザーが `--mcp-config` で渡すすべてのサーバーもチェックします。チェック対象となる `managed-mcp.json` サーバーが変更されたバージョンや、サーバーの読み込みを防ぐ方法については、[許可リストと拒否リストが管理セットにどのように適用されるか](#how-allowlists-and-denylists-apply-to-the-managed-set)を参照してください。

### 設定例

以下の設定は、拒否リストを伴う厳格な許可リストを構成します。ハイライトされた行はリストの残りの部分の評価方法を変えるもので、ブロックの後の説明でそれぞれを解説します。

```json {3,5,11} theme={null}
{
  "allowedMcpServers": [
    { "serverUrl": "https://api.githubcopilot.com/*" },
    { "serverUrl": "https://mcp.sentry.dev/*" },
    { "serverCommand": ["npx", "-y", "@modelcontextprotocol/server-filesystem", "."] },
    { "serverCommand": ["python", "/usr/local/bin/approved-server.py"] },
    { "serverUrl": "https://mcp.example.com/*" },
    { "serverUrl": "https://*.internal.example.com/*" }
  ],
  "deniedMcpServers": [
    { "serverName": "dangerous-server" },
    { "serverCommand": ["npx", "-y", "unapproved-package"] },
    { "serverUrl": "https://*.untrusted.example.com/*" }
  ]
}
```

* **3 行目**：最初の `serverUrl` エントリ。これが 1 つでも存在すると、すべてのリモートサーバーが URL パターンに一致する必要があるため、ユーザーは許可された名前を付けることでリストにないリモートサーバーを通すことはできません。
* **5 行目**：最初の `serverCommand` エントリ。stdio サーバーに対して同じ効果があり、すべてのローカルサーバーがリストにあるコマンドに完全に一致する必要があります。
* **11 行目**：拒否リスト内の `serverName` エントリ。拒否リストのエントリは常に適用されるため、`dangerous-server` という名前のサーバーは、その URL やコマンドに関係なくブロックされます。

この許可リストに `serverName` エントリを追加しても、どちらのトランスポートタイプにもすでにより厳格なエントリがあるため、何にも一致しません。

以下のアコーディオンでは、他の許可リストと拒否リストの組み合わせに対してサーバーがどのように評価されるかを説明します。

> **URL のみの許可リスト**
>
> ```json theme={null}
> {
>   "allowedMcpServers": [
>     { "serverUrl": "https://mcp.example.com/*" },
>     { "serverUrl": "https://*.internal.example.com/*" }
>   ]
> }
> ```
>
> | サーバー | 結果 |
> | :- | :- |
> | `https://mcp.example.com/api` の HTTP サーバー | 許可：URL パターンに一致 |
> | `https://api.internal.example.com/mcp` の HTTP サーバー | 許可：ワイルドカードのサブドメインに一致 |
> | `https://external.example.com/mcp` の HTTP サーバー | ブロック：どの URL パターンにも一致しない |
> | 任意のコマンドを使用する stdio サーバー | ブロック：照合する名前またはコマンドのエントリがない |

> **コマンドのみの許可リスト**
>
> ```json theme={null}
> {
>   "allowedMcpServers": [
>     { "serverCommand": ["npx", "-y", "approved-package"] }
>   ]
> }
> ```
>
> | サーバー | 結果 |
> | :- | :- |
> | `["npx", "-y", "approved-package"]` を使用する stdio サーバー | 許可：コマンドに一致 |
> | `["node", "server.js"]` を使用する stdio サーバー | ブロック：コマンドに一致しない |
> | `my-api` という名前の HTTP サーバー | ブロック：照合する名前のエントリがない |

> **名前とコマンドが混在する許可リスト**
>
> ```json theme={null}
> {
>   "allowedMcpServers": [
>     { "serverName": "github" },
>     { "serverCommand": ["npx", "-y", "approved-package"] }
>   ]
> }
> ```
>
> | サーバー | 結果 |
> | :- | :- |
> | `["npx", "-y", "approved-package"]` を使用する `local-tool` という名前の stdio サーバー | 許可：コマンドに一致 |
> | `["node", "server.js"]` を使用する `local-tool` という名前の stdio サーバー | ブロック：コマンドのエントリが存在するが一致しない |
> | `["node", "server.js"]` を使用する `github` という名前の stdio サーバー | ブロック：コマンドのエントリが存在する場合、stdio サーバーはコマンドに一致する必要がある |
> | `github` という名前の HTTP サーバー | 許可：名前に一致 |
> | `other-api` という名前の HTTP サーバー | ブロック：名前が一致しない |

> **名前のみの許可リスト**
>
> ```json theme={null}
> {
>   "allowedMcpServers": [
>     { "serverName": "github" },
>     { "serverName": "internal-tool" }
>   ]
> }
> ```
>
> | サーバー | 結果 |
> | :- | :- |
> | 任意のコマンドを使用する `github` という名前の stdio サーバー | 許可：コマンドの制限がない |
> | 任意のコマンドを使用する `internal-tool` という名前の stdio サーバー | 許可：コマンドの制限がない |
> | `github` という名前の HTTP サーバー | 許可：名前に一致 |
> | `other` という名前の任意のサーバー | ブロック：名前が一致しない |

> **拒否リストによる上書きを伴う許可リスト**
>
> ```json theme={null}
> {
>   "allowedMcpServers": [
>     { "serverUrl": "https://*.example.com/*" }
>   ],
>   "deniedMcpServers": [
>     { "serverUrl": "https://staging.example.com/*" }
>   ]
> }
> ```
>
> | サーバー | 結果 |
> | :- | :- |
> | `https://mcp.example.com/api` の HTTP サーバー | 許可：許可リストの URL パターンに一致し、拒否リストには一致しない |
> | `https://staging.example.com/api` の HTTP サーバー | ブロック：両方に一致するが、拒否リストが優先される |
> | `https://staging.example.com:8443/api` の HTTP サーバー | 許可：許可リストの URL パターンに一致し、[このポートでは拒否リストに一致しない](#how-serverurl-entries-match) |
> | `https://other.com/mcp` の HTTP サーバー | ブロック：許可リストに一致しない |

### 許可リストを管理設定のみに制限する

管理許可リストのみが適用されるようにするには、管理設定ファイルで `allowManagedMcpServersOnly` を設定します。

```json theme={null}
{
  "allowManagedMcpServersOnly": true,
  "allowedMcpServers": [
    { "serverUrl": "https://api.githubcopilot.com/*" },
    { "serverUrl": "https://*.internal.example.com/*" }
  ]
}
```

`allowManagedMcpServersOnly` が `true` の場合、ユーザー設定、プロジェクト設定、ローカル設定の許可リストは無視されます。拒否リストは引き続きすべての設定スコープからマージされるため、ユーザーはいつでも自分でサーバーをブロックできます。

## 制限がユーザーに表示される方法

`managed-mcp.json` がデプロイされ、セッションに `--mcp-config` サーバーもある場合にスタートアップ時にユーザーに表示される内容については、[managed-mcp.json による排他的制御](#exclusive-control-with-managed-mcp-json)を参照してください。このテーブルを使用して他のレポートを認識し、変更をロールアウトする前にユーザーが何を期待するかを伝えてください。

| 制限 | ユーザーに表示される内容 |
| :- | :- |
| `managed-mcp.json` が存在し、ユーザーが `claude mcp add` を実行する | `Cannot add MCP server: enterprise MCP configuration is active and has exclusive control over MCP servers` |
| `managed-mcp.json` が存在し、Chrome で Claude を実行できるユーザーが `claude --chrome` を実行する | Claude Code はスタートアップ時に `Claude in Chrome is blocked by your organization's managed MCP configuration (managed-mcp.json). An administrator can allow it with allowClaudeInChromeWithManagedMcp in device policy.` で終了します |
| サーバーがデニーリストにあり、ユーザーが `claude mcp add` を実行する | `Cannot add MCP server "<name>": server is explicitly blocked by enterprise policy` |
| サーバーがアローリストになく、ユーザーが `claude mcp add` を実行する | `Cannot add MCP server "<name>": not allowed by enterprise policy` |
| [`strictPluginOnlyCustomization`](/docs/ja/settings-reference#strictpluginonlycustomization) が `true` であるか `mcp` を含み、ユーザーが `claude mcp add` を実行する | [`Cannot add MCP server: your organization's managed settings allow only MCP servers that plugins provide`](/docs/ja/errors#cannot-add-mcp-server-when-managed-settings-allow-only-plugin-servers) |
| ユーザーが `managedMcpServers` のサーバーで `claude mcp remove` を実行する | `MCP server "<name>" is provided by your organization (managed settings) and cannot be removed locally.` |
| 以前に設定されたサーバーがポリシーによってブロックされるようになった | サーバーは `/mcp` と `claude mcp list` から消える |
| セッション実行中にサーバーがブロックされ、ユーザーが **Reconnect** を選択するか、`/mcp` でそれをオンに戻す | [`MCP server <name> is blocked by enterprise managed policy`](/docs/ja/errors#mcp-server-is-blocked-by-enterprise-managed-policy) |

サーバーが静かに消える場合、ユーザーはポリシーが理由であるという信号を受け取らないため、変更をロールアウトする際に影響を受けるユーザーにどのサーバーがブロックされているかを伝えてください。

## MCP 使用状況を監視する

[OpenTelemetry エクスポート](/docs/ja/monitoring-usage.md)を設定すると、Claude Code はユーザーが呼び出す MCP サーバーとツールを記録できます。`OTEL_LOG_TOOL_DETAILS=1` を設定して、MCP サーバーとツール名をツールイベントと[コストおよびトークンカウンター](/docs/ja/monitoring-usage.md#cost-counter)に含めます。その後、コレクターで集計して、ユーザーが実際に接続するサーバーを確認します。エクスポーターを設定し、完全なイベントスキーマについては、[監視](/docs/ja/monitoring-usage.md)を参照してください。

## 設定の概要

このページで扱うすべてのファイルと設定、それらが制御する内容、および配信方法：

| サーフェス | 制御内容 | 保存場所 | 配信方法 |
| :- | :- | :- | :- |
| `managed-mcp.json` | 固定サーバーセット、排他的制御 | システムパス：`/Library/Application Support/ClaudeCode/`、`/etc/claude-code/`、または `C:\Program Files\ClaudeCode\` | MDM、GPO、フリート管理、または管理者権限を持つプロセス。サーバー管理設定を通じて設定することはできません |
| `managedMcpServers` | すべてのユーザーに提供されるリモートサーバー（ユーザー自身のサーバーと並行） | 管理設定ソースのみ。この設定は他の場所では効果がありません | [管理設定ソース](/docs/ja/admin-setup.md#decide-how-settings-reach-devices)：サーバー管理設定、ゲートウェイポリシー、`managed-settings.json`、MDM プロファイル、または HKLM レジストリ |
| `allowedMcpServers` | 許可されたサーバーのホワイトリスト | 任意の[設定スコープ](/docs/ja/settings.md#where-settings-live)。[サーバーの評価方法](#how-a-server-is-evaluated)に、複数のスコープと管理ソースからのリストがどのように組み合わされるかが記載されています | 強制するには、[管理設定ソース](/docs/ja/admin-setup.md#decide-how-settings-reach-devices)：サーバー管理設定、`managed-settings.json`、MDM プロファイル、またはレジストリ |
| `deniedMcpServers` | ブロックされたサーバーのブラックリスト | 任意の設定スコープ。[サーバーの評価方法](#how-a-server-is-evaluated)に、複数のスコープと管理ソースからのリストがどのように組み合わされるかが記載されています | `allowedMcpServers` と同じ |
| `allowManagedMcpServersOnly` | ホワイトリストを管理ソースのみにロック | 管理設定ソースのみ。[すべての管理ソースから読み込まれるキー](/docs/ja/managed-settings.md#keys-read-from-every-admin-source)に、どの管理ソースがこれをオンにできるかが記載されています。この設定は他のスコープでは効果がありません | `allowedMcpServers` と同じ |
| `allowClaudeInChromeWithManagedMcp` | 組み込みの Claude in Chrome サーバーが `managed-mcp.json` と並行して実行されることを許可します | デバイス上の管理設定のみ：MDM プロファイル、HKLM レジストリ、または `managed-settings.json`。サーバー管理設定とユーザー書き込み可能なソースは効果がありません | MDM、GPO、フリート管理、または管理者権限を持つプロセス |
| `allowAllClaudeAiMcps` | Claude Code が自身で取得する claude.ai コネクタを `managed-mcp.json` と並行して読み込みます。[クラウドセッションを実行するホスト上の `managed-mcp.json` は、そのセッションのコネクタを依然として抑制します](#allow-claude-ai-connectors-alongside-the-managed-set) | 管理設定ソースのみ。この設定は他の場所では効果がありません | `allowedMcpServers` と同じ |

## 関連リソース

* [実施する内容を決定する](/docs/ja/admin-setup.md#decide-what-to-enforce)：MCP 制限と権限ルール、サンドボックス化、および他の管理制御
* [MCP 経由で Claude Code をツールに接続する](/docs/ja/mcp.md)：トランスポート、スコープ、認証を含む完全な MCP リファレンス
* [設定](/docs/ja/settings.md)：設定階層と管理設定がどのように優先されるか
* [サーバー管理設定](/docs/ja/server-managed-settings.md)：Claude.ai 管理コンソールから `allowedMcpServers` と `deniedMcpServers` を配信します
* [セキュリティ](/docs/ja/security.md)：これらの制御が防御する脅威モデル
* [Claude Enterprise Administrator Guide](https://claude.com/resources/tutorials/claude-enterprise-administrator-guide)：SSO、SCIM、シート管理、およびロールアウトプレイブック
