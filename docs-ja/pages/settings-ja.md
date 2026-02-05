> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# Claude Code の設定

> Claude Code をグローバル設定とプロジェクトレベルの設定、および環境変数で構成します。

Claude Code は、ニーズに合わせて動作を構成するためのさまざまな設定を提供しています。インタラクティブ REPL を使用する際に `/config` コマンドを実行することで Claude Code を構成できます。これにより、ステータス情報を表示し、構成オプションを変更できるタブ付き設定インターフェースが開きます。

## 構成スコープ

Claude Code は、**スコープシステム**を使用して、構成が適用される場所と共有される対象を決定します。スコープを理解することで、個人使用、チーム協力、またはエンタープライズデプロイメント用に Claude Code を構成する方法を決定するのに役立ちます。

### 利用可能なスコープ

| スコープ        | 場所                               | 影響を受ける対象         | チームと共有?        |
| :---------- | :------------------------------- | :--------------- | :------------- |
| **Managed** | システムレベルの `managed-settings.json` | マシン上のすべてのユーザー    | はい（IT により展開）   |
| **User**    | `~/.claude/` ディレクトリ              | すべてのプロジェクト全体のあなた | いいえ            |
| **Project** | リポジトリ内の `.claude/`               | このリポジトリのすべての協力者  | はい（git にコミット）  |
| **Local**   | `.claude/*.local.*` ファイル         | このリポジトリ内のあなたのみ   | いいえ（gitignore） |

### 各スコープの使用時期

**Managed スコープ**は以下の用途です：

* 組織全体で実施する必要があるセキュリティポリシー
* オーバーライドできないコンプライアンス要件
* IT/DevOps により展開される標準化された構成

**User スコープ**は以下の用途に最適です：

* すべての場所で必要な個人設定（テーマ、エディタ設定）
* すべてのプロジェクト全体で使用するツールとプラグイン
* API キーと認証（安全に保存）

**Project スコープ**は以下の用途に最適です：

* チーム共有設定（権限、hooks、MCP servers）
* チーム全体が持つべきプラグイン
* 協力者全体でツール化を標準化

**Local スコープ**は以下の用途に最適です：

* 特定のプロジェクトの個人的なオーバーライド
* チームと共有する前に構成をテスト
* 他のユーザーには機能しないマシン固有の設定

### スコープの相互作用

同じ設定が複数のスコープで構成されている場合、より具体的なスコープが優先されます：

1. **Managed**（最高） - 何もオーバーライドできない
2. **コマンドラインの引数** - 一時的なセッションオーバーライド
3. **Local** - プロジェクトとユーザー設定をオーバーライド
4. **Project** - ユーザー設定をオーバーライド
5. **User**（最低） - 他に何も設定を指定しない場合に適用

たとえば、ユーザー設定で権限が許可されているが、プロジェクト設定で拒否されている場合、プロジェクト設定が優先され、権限はブロックされます。

### スコープを使用する機能

スコープは多くの Claude Code 機能に適用されます：

| 機能              | ユーザーの場所                   | プロジェクトの場所                           | ローカルの場所                       |
| :-------------- | :------------------------ | :---------------------------------- | :---------------------------- |
| **Settings**    | `~/.claude/settings.json` | `.claude/settings.json`             | `.claude/settings.local.json` |
| **Subagents**   | `~/.claude/agents/`       | `.claude/agents/`                   | —                             |
| **MCP servers** | `~/.claude.json`          | `.mcp.json`                         | `~/.claude.json`（プロジェクトごと）    |
| **Plugins**     | `~/.claude/settings.json` | `.claude/settings.json`             | `.claude/settings.local.json` |
| **CLAUDE.md**   | `~/.claude/CLAUDE.md`     | `CLAUDE.md` または `.claude/CLAUDE.md` | `CLAUDE.local.md`             |

***

## 設定ファイル

`settings.json` ファイルは、階層的な設定を通じて Claude Code を構成するための公式メカニズムです：

* **ユーザー設定**は `~/.claude/settings.json` で定義され、すべてのプロジェクトに適用されます。
* **プロジェクト設定**はプロジェクトディレクトリに保存されます：
  * `.claude/settings.json` ソース管理にチェックインされ、チームと共有される設定用
  * `.claude/settings.local.json` チェックインされない設定用。個人設定と実験に役立ちます。Claude Code は作成時に `.claude/settings.local.json` を無視するように git を構成します。
* **Managed 設定**：集中管理が必要な組織の場合、Claude Code はシステムディレクトリに展開できる `managed-settings.json` と `managed-mcp.json` ファイルをサポートしています：

  * macOS：`/Library/Application Support/ClaudeCode/`
  * Linux と WSL：`/etc/claude-code/`
  * Windows：`C:\Program Files\ClaudeCode\`

  <Note>
    これらはシステム全体のパス（`~/Library/...` のようなユーザーホームディレクトリではない）であり、管理者権限が必要です。IT 管理者により展開されるように設計されています。
  </Note>

  詳細については、[Managed 設定](/ja/permissions#managed-settings)と[Managed MCP 構成](/ja/mcp#managed-mcp-configuration)を参照してください。

  <Note>
    Managed デプロイメントは、`strictKnownMarketplaces` を使用して**プラグインマーケットプレイスの追加**を制限することもできます。詳細については、[Managed マーケットプレイス制限](/ja/plugin-marketplaces#managed-marketplace-restrictions)を参照してください。
  </Note>
* **その他の構成**は `~/.claude.json` に保存されます。このファイルには、設定（テーマ、通知設定、エディタモード）、OAuth セッション、[MCP server](/ja/mcp) 構成（ユーザーとローカルスコープ用）、プロジェクトごとの状態（許可されたツール、信頼設定）、およびさまざまなキャッシュが含まれます。プロジェクトスコープの MCP サーバーは `.mcp.json` に別途保存されます。

<Note>
  Claude Code は構成ファイルのタイムスタンプ付きバックアップを自動的に作成し、データ損失を防ぐために最新の 5 つのバックアップを保持します。
</Note>

```JSON settings.json の例 theme={null}
{
  "$schema": "https://json.schemastore.org/claude-code-settings.json",
  "permissions": {
    "allow": [
      "Bash(npm run lint)",
      "Bash(npm run test *)",
      "Read(~/.zshrc)"
    ],
    "deny": [
      "Bash(curl *)",
      "Read(./.env)",
      "Read(./.env.*)",
      "Read(./secrets/**)"
    ]
  },
  "env": {
    "CLAUDE_CODE_ENABLE_TELEMETRY": "1",
    "OTEL_METRICS_EXPORTER": "otlp"
  },
  "companyAnnouncements": [
    "Welcome to Acme Corp! Review our code guidelines at docs.acme.com",
    "Reminder: Code reviews required for all PRs",
    "New security policy in effect"
  ]
}
```

上記の例の `$schema` 行は、Claude Code 設定の[公式 JSON スキーマ](https://json.schemastore.org/claude-code-settings.json)を指しています。これを `settings.json` に追加すると、VS Code、Cursor、および JSON スキーマ検証をサポートする他のエディタでオートコンプリートとインライン検証が有効になります。

### 利用可能な設定

`settings.json` は多くのオプションをサポートしています：

| キー                                | 説明                                                                                                                                                                                                    | 例                                                                       |
| :-------------------------------- | :---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :---------------------------------------------------------------------- |
| `apiKeyHelper`                    | `/bin/sh` で実行される認証値を生成するカスタムスクリプト。この値は、モデルリクエストの `X-Api-Key` および `Authorization: Bearer` ヘッダーとして送信されます                                                                                                | `/bin/generate_temp_api_key.sh`                                         |
| `cleanupPeriodDays`               | この期間より長い間非アクティブなセッションは起動時に削除されます。`0` に設定するとすべてのセッションが即座に削除されます。（デフォルト：30 日）                                                                                                                           | `20`                                                                    |
| `companyAnnouncements`            | 起動時にユーザーに表示するアナウンス。複数のアナウンスが提供される場合、ランダムにサイクルされます。                                                                                                                                                    | `["Welcome to Acme Corp! Review our code guidelines at docs.acme.com"]` |
| `env`                             | すべてのセッションに適用される環境変数                                                                                                                                                                                   | `{"FOO": "bar"}`                                                        |
| `attribution`                     | git コミットとプルリクエストの属性をカスタマイズします。[属性設定](#attribution-settings)を参照してください                                                                                                                                  | `{"commit": "🤖 Generated with Claude Code", "pr": ""}`                 |
| `includeCoAuthoredBy`             | **非推奨**：代わりに `attribution` を使用してください。git コミットとプルリクエストに `co-authored-by Claude` バイラインを含めるかどうか（デフォルト：`true`）                                                                                            | `false`                                                                 |
| `permissions`                     | 権限の構造については以下の表を参照してください。                                                                                                                                                                              |                                                                         |
| `hooks`                           | ライフサイクルイベントで実行するカスタムコマンドを構成します。形式については[hooks ドキュメント](/ja/hooks)を参照してください                                                                                                                              | [hooks](/ja/hooks) を参照                                                  |
| `disableAllHooks`                 | すべての[hooks](/ja/hooks)を無効にします                                                                                                                                                                         | `true`                                                                  |
| `allowManagedHooksOnly`           | （Managed 設定のみ）ユーザー、プロジェクト、プラグイン hooks の読み込みを防止します。Managed hooks と SDK hooks のみを許可します。[Hook 構成](#hook-configuration)を参照してください                                                                          | `true`                                                                  |
| `allowManagedPermissionRulesOnly` | （Managed 設定のみ）ユーザーとプロジェクト設定が `allow`、`ask`、または `deny` 権限ルールを定義するのを防止します。Managed 設定のルールのみが適用されます。[Managed のみの設定](/ja/permissions#managed-only-settings)を参照してください                                       | `true`                                                                  |
| `model`                           | Claude Code に使用するデフォルトモデルをオーバーライドします                                                                                                                                                                  | `"claude-sonnet-4-5-20250929"`                                          |
| `otelHeadersHelper`               | 動的 OpenTelemetry ヘッダーを生成するスクリプト。起動時と定期的に実行されます（[動的ヘッダー](/ja/monitoring-usage#dynamic-headers)を参照）                                                                                                     | `/bin/generate_otel_headers.sh`                                         |
| `statusLine`                      | コンテキストを表示するカスタムステータスラインを構成します。[`statusLine` ドキュメント](/ja/statusline)を参照してください                                                                                                                          | `{"type": "command", "command": "~/.claude/statusline.sh"}`             |
| `fileSuggestion`                  | `@` ファイルオートコンプリート用のカスタムスクリプトを構成します。[ファイル提案設定](#file-suggestion-settings)を参照してください                                                                                                                     | `{"type": "command", "command": "~/.claude/file-suggestion.sh"}`        |
| `respectGitignore`                | `@` ファイルピッカーが `.gitignore` パターンを尊重するかどうかを制御します。`true`（デフォルト）の場合、`.gitignore` パターンに一致するファイルは提案から除外されます                                                                                                 | `false`                                                                 |
| `outputStyle`                     | システムプロンプトを調整するための出力スタイルを構成します。[出力スタイルドキュメント](/ja/output-styles)を参照してください                                                                                                                              | `"Explanatory"`                                                         |
| `forceLoginMethod`                | `claudeai` を使用して Claude.ai アカウントへのログインを制限するか、`console` を使用して Claude Console（API 使用量請求）アカウントへのログインを制限します                                                                                               | `claudeai`                                                              |
| `forceLoginOrgUUID`               | ログイン中に自動的に選択する組織の UUID を指定し、組織選択ステップをバイパスします。`forceLoginMethod` を設定する必要があります                                                                                                                          | `"xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"`                                |
| `enableAllProjectMcpServers`      | プロジェクト `.mcp.json` ファイルで定義されたすべての MCP サーバーを自動的に承認します                                                                                                                                                  | `true`                                                                  |
| `enabledMcpjsonServers`           | 承認する `.mcp.json` ファイルからの特定の MCP サーバーのリスト                                                                                                                                                              | `["memory", "github"]`                                                  |
| `disabledMcpjsonServers`          | 拒否する `.mcp.json` ファイルからの特定の MCP サーバーのリスト                                                                                                                                                              | `["filesystem"]`                                                        |
| `allowedMcpServers`               | managed-settings.json で設定された場合、ユーザーが構成できる MCP サーバーのアローリスト。未定義 = 制限なし、空配列 = ロックダウン。すべてのスコープに適用されます。デニーリストが優先されます。[Managed MCP 構成](/ja/mcp#managed-mcp-configuration)を参照してください                          | `[{ "serverName": "github" }]`                                          |
| `deniedMcpServers`                | managed-settings.json で設定された場合、明示的にブロックされた MCP サーバーのデニーリスト。すべてのスコープ（Managed サーバーを含む）に適用されます。デニーリストがアローリストより優先されます。[Managed MCP 構成](/ja/mcp#managed-mcp-configuration)を参照してください                        | `[{ "serverName": "filesystem" }]`                                      |
| `strictKnownMarketplaces`         | managed-settings.json で設定された場合、ユーザーが追加できるプラグインマーケットプレイスのアローリスト。未定義 = 制限なし、空配列 = ロックダウン。マーケットプレイスの追加のみに適用されます。[Managed マーケットプレイス制限](/ja/plugin-marketplaces#managed-marketplace-restrictions)を参照してください | `[{ "source": "github", "repo": "acme-corp/plugins" }]`                 |
| `awsAuthRefresh`                  | `.aws` ディレクトリを変更するカスタムスクリプト（[高度な認証情報構成](/ja/amazon-bedrock#advanced-credential-configuration)を参照）                                                                                                     | `aws sso login --profile myprofile`                                     |
| `awsCredentialExport`             | AWS 認証情報を含む JSON を出力するカスタムスクリプト（[高度な認証情報構成](/ja/amazon-bedrock#advanced-credential-configuration)を参照）                                                                                                 | `/bin/generate_aws_grant.sh`                                            |
| `alwaysThinkingEnabled`           | すべてのセッションに対してデフォルトで[拡張思考](/ja/common-workflows#use-extended-thinking-thinking-mode)を有効にします。通常は直接編集するのではなく `/config` コマンドを使用して構成されます                                                                   | `true`                                                                  |
| `plansDirectory`                  | プランファイルが保存される場所をカスタマイズします。パスはプロジェクトルートに相対的です。デフォルト：`~/.claude/plans`                                                                                                                                  | `"./plans"`                                                             |
| `showTurnDuration`                | 応答後にターン期間メッセージを表示します（例：「Cooked for 1m 6s」）。`false` に設定するとこれらのメッセージが非表示になります                                                                                                                           | `true`                                                                  |
| `spinnerVerbs`                    | スピナーとターン期間メッセージに表示されるアクション動詞をカスタマイズします。`mode` を `"replace"` に設定して動詞のみを使用するか、`"append"` に設定してデフォルトに追加します                                                                                               | `{"mode": "append", "verbs": ["Pondering", "Crafting"]}`                |
| `language`                        | Claude の優先応答言語を構成します（例：`"japanese"`、`"spanish"`、`"french"`）。Claude はデフォルトでこの言語で応答します                                                                                                                  | `"japanese"`                                                            |
| `autoUpdatesChannel`              | 更新に従うリリースチャネル。`"stable"` を使用して通常約 1 週間古いバージョンを使用し、大きな回帰があるバージョンをスキップするか、最新リリース用に `"latest"`（デフォルト）を使用します                                                                                              | `"stable"`                                                              |
| `spinnerTipsEnabled`              | Claude が作業中にスピナーにヒントを表示します。`false` に設定するとヒントが無効になります（デフォルト：`true`）                                                                                                                                    | `false`                                                                 |
| `terminalProgressBarEnabled`      | Windows Terminal や iTerm2 などのサポートされているターミナルで進捗を表示するターミナル進捗バーを有効にします（デフォルト：`true`）                                                                                                                     | `false`                                                                 |

### 権限設定

| キー                             | 説明                                                                                                                                                                    | 例                                                                      |
| :----------------------------- | :-------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :--------------------------------------------------------------------- |
| `allow`                        | ツール使用を許可する権限ルールの配列。パターンマッチングの詳細については、以下の[権限ルール構文](#permission-rule-syntax)を参照してください                                                                                   | `[ "Bash(git diff *)" ]`                                               |
| `ask`                          | ツール使用時に確認を求める権限ルールの配列。[権限ルール構文](#permission-rule-syntax)を参照してください                                                                                                     | `[ "Bash(git push *)" ]`                                               |
| `deny`                         | ツール使用を拒否する権限ルールの配列。これを使用して、Claude Code アクセスから機密ファイルを除外します。[権限ルール構文](#permission-rule-syntax)と[Bash 権限制限](/ja/permissions#tool-specific-permission-rules)を参照してください     | `[ "WebFetch", "Bash(curl *)", "Read(./.env)", "Read(./secrets/**)" ]` |
| `additionalDirectories`        | Claude がアクセスできる追加の[作業ディレクトリ](/ja/permissions#working-directories)                                                                                                     | `[ "../docs/" ]`                                                       |
| `defaultMode`                  | Claude Code を開く際のデフォルト[権限モード](/ja/permissions#permission-modes)                                                                                                       | `"acceptEdits"`                                                        |
| `disableBypassPermissionsMode` | `"disable"` に設定して `bypassPermissions` モードの有効化を防止します。これにより `--dangerously-skip-permissions` コマンドラインフラグが無効になります。[Managed 設定](/ja/permissions#managed-settings)を参照してください | `"disable"`                                                            |

### 権限ルール構文

権限ルールは `Tool` または `Tool(specifier)` の形式に従います。ルールは順序で評価されます：最初に deny ルール、次に ask、最後に allow。最初に一致するルールが優先されます。

クイック例：

| ルール                            | 効果                         |
| :----------------------------- | :------------------------- |
| `Bash`                         | すべての Bash コマンドに一致          |
| `Bash(npm run *)`              | `npm run` で始まるコマンドに一致      |
| `Read(./.env)`                 | `.env` ファイルの読み取りに一致        |
| `WebFetch(domain:example.com)` | example.com へのフェッチリクエストに一致 |

ワイルドカード動作、Read、Edit、WebFetch、MCP、Task ルール用のツール固有パターン、Bash パターンのセキュリティ制限を含む完全なルール構文リファレンスについては、[権限ルール構文](/ja/permissions#permission-rule-syntax)を参照してください。

### サンドボックス設定

高度なサンドボックス動作を構成します。サンドボックスは bash コマンドをファイルシステムとネットワークから分離します。詳細については、[サンドボックス](/ja/sandboxing)を参照してください。

**ファイルシステムとネットワーク制限**は、これらのサンドボックス設定ではなく、Read、Edit、WebFetch 権限ルールを使用して構成されます。

| キー                            | 説明                                                                                                                                                                                                                                 | 例                               |
| :---------------------------- | :--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :------------------------------ |
| `enabled`                     | bash サンドボックスを有効にします（macOS、Linux、WSL2）。デフォルト：false                                                                                                                                                                                  | `true`                          |
| `autoAllowBashIfSandboxed`    | サンドボックス化されている場合、bash コマンドを自動承認します。デフォルト：true                                                                                                                                                                                       | `true`                          |
| `excludedCommands`            | サンドボックスの外で実行する必要があるコマンド                                                                                                                                                                                                            | `["git", "docker"]`             |
| `allowUnsandboxedCommands`    | `dangerouslyDisableSandbox` パラメータを使用してコマンドをサンドボックスの外で実行することを許可します。`false` に設定すると、`dangerouslyDisableSandbox` エスケープハッチが完全に無効になり、すべてのコマンドはサンドボックス化されるか `excludedCommands` に含まれる必要があります。厳密なサンドボックスを必要とするエンタープライズポリシーに役立ちます。デフォルト：true | `false`                         |
| `network.allowUnixSockets`    | サンドボックスでアクセス可能な Unix ソケットパス（SSH エージェントなど）                                                                                                                                                                                          | `["~/.ssh/agent-socket"]`       |
| `network.allowAllUnixSockets` | サンドボックスでのすべての Unix ソケット接続を許可します。デフォルト：false                                                                                                                                                                                        | `true`                          |
| `network.allowLocalBinding`   | localhost ポートへのバインドを許可します（macOS のみ）。デフォルト：false                                                                                                                                                                                    | `true`                          |
| `network.allowedDomains`      | アウトバウンドネットワークトラフィックを許可するドメインの配列。ワイルドカードをサポートします（例：`*.example.com`）。                                                                                                                                                                | `["github.com", "*.npmjs.org"]` |
| `network.httpProxyPort`       | 独自のプロキシを使用する場合に使用される HTTP プロキシポート。指定されない場合、Claude は独自のプロキシを実行します。                                                                                                                                                                  | `8080`                          |
| `network.socksProxyPort`      | 独自のプロキシを使用する場合に使用される SOCKS5 プロキシポート。指定されない場合、Claude は独自のプロキシを実行します。                                                                                                                                                                | `8081`                          |
| `enableWeakerNestedSandbox`   | 非特権 Docker 環境用の弱いサンドボックスを有効にします（Linux と WSL2 のみ）。**セキュリティが低下します。** デフォルト：false                                                                                                                                                     | `true`                          |

**構成例：**

```json  theme={null}
{
  "sandbox": {
    "enabled": true,
    "autoAllowBashIfSandboxed": true,
    "excludedCommands": ["docker"],
    "network": {
      "allowedDomains": ["github.com", "*.npmjs.org", "registry.yarnpkg.com"],
      "allowUnixSockets": [
        "/var/run/docker.sock"
      ],
      "allowLocalBinding": true
    }
  },
  "permissions": {
    "deny": [
      "Read(.envrc)",
      "Read(~/.aws/**)"
    ]
  }
}
```

**ファイルシステムとネットワーク制限**は標準的な権限ルールを使用します：

* `Read` deny ルールを使用して、Claude が特定のファイルまたはディレクトリを読み取るのをブロックします
* `Edit` allow ルールを使用して、Claude が現在の作業ディレクトリを超えてディレクトリに書き込むことを許可します
* `Edit` deny ルールを使用して、特定のパスへの書き込みをブロックします
* `WebFetch` allow/deny ルールを使用して、Claude がアクセスできるネットワークドメインを制御します

### 属性設定

Claude Code は git コミットとプルリクエストに属性を追加します。これらは個別に構成されます：

* コミットはデフォルトで[git trailers](https://git-scm.com/docs/git-interpret-trailers)（`Co-Authored-By` など）を使用し、カスタマイズまたは無効にできます
* プルリクエストの説明はプレーンテキストです

| キー       | 説明                                                 |
| :------- | :------------------------------------------------- |
| `commit` | git コミットの属性（任意の trailers を含む）。空の文字列はコミット属性を非表示にします |
| `pr`     | プルリクエストの説明の属性。空の文字列はプルリクエスト属性を非表示にします              |

**デフォルトコミット属性：**

```
🤖 Generated with [Claude Code](https://claude.com/claude-code)

   Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>
```

**デフォルトプルリクエスト属性：**

```
🤖 Generated with [Claude Code](https://claude.com/claude-code)
```

**例：**

```json  theme={null}
{
  "attribution": {
    "commit": "Generated with AI\n\nCo-Authored-By: AI <ai@example.com>",
    "pr": ""
  }
}
```

<Note>
  `attribution` 設定は非推奨の `includeCoAuthoredBy` 設定より優先されます。すべての属性を非表示にするには、`commit` と `pr` を空の文字列に設定します。
</Note>

### ファイル提案設定

`@` ファイルパスオートコンプリート用のカスタムコマンドを構成します。組み込みのファイル提案は高速ファイルシステムトラバーサルを使用しますが、大規模なモノレポは事前構築されたファイルインデックスやカスタムツール化などのプロジェクト固有のインデックスから利益を得ることができます。

```json  theme={null}
{
  "fileSuggestion": {
    "type": "command",
    "command": "~/.claude/file-suggestion.sh"
  }
}
```

コマンドは[hooks](/ja/hooks)と同じ環境変数で実行され、`CLAUDE_PROJECT_DIR` を含みます。`query` フィールドを含む JSON を stdin 経由で受け取ります：

```json  theme={null}
{"query": "src/comp"}
```

stdout に改行で区切られたファイルパスを出力します（現在 15 に制限）：

```
src/components/Button.tsx
src/components/Modal.tsx
src/components/Form.tsx
```

**例：**

```bash  theme={null}
#!/bin/bash
query=$(cat | jq -r '.query')
your-repo-file-index --query "$query" | head -20
```

### Hook 構成

**Managed 設定のみ**：実行が許可されている hooks を制御します。この設定は[Managed 設定](#settings-files)でのみ構成でき、管理者に hook 実行の厳密な制御を提供します。

**`allowManagedHooksOnly` が `true` の場合の動作：**

* Managed hooks と SDK hooks が読み込まれます
* ユーザー hooks、プロジェクト hooks、プラグイン hooks がブロックされます

**構成：**

```json  theme={null}
{
  "allowManagedHooksOnly": true
}
```

### 設定の優先順位

設定は優先順位の順に適用されます。最高から最低まで：

1. **Managed 設定**（`managed-settings.json`）
   * IT/DevOps によってシステムディレクトリに展開されるポリシー
   * ユーザーまたはプロジェクト設定でオーバーライドできない

2. **コマンドラインの引数**
   * 特定のセッションの一時的なオーバーライド

3. **ローカルプロジェクト設定**（`.claude/settings.local.json`）
   * 個人的なプロジェクト固有の設定

4. **共有プロジェクト設定**（`.claude/settings.json`）
   * ソース管理のチームが共有するプロジェクト設定

5. **ユーザー設定**（`~/.claude/settings.json`）
   * 個人的なグローバル設定

この階層により、組織のポリシーが常に実施されながら、チームと個人が経験をカスタマイズできるようになります。

たとえば、ユーザー設定が `Bash(npm run *)` を許可しているが、プロジェクトの共有設定がそれを拒否している場合、プロジェクト設定が優先され、コマンドはブロックされます。

### 構成システムに関する重要なポイント

* **メモリファイル（`CLAUDE.md`）**：Claude が起動時に読み込む指示とコンテキストを含みます
* **設定ファイル（JSON）**：権限、環境変数、ツール動作を構成します
* **Skills**：`/skill-name` で呼び出すか、Claude により自動的に読み込むことができるカスタムプロンプト
* **MCP servers**：追加のツールと統合で Claude Code を拡張します
* **優先順位**：より高いレベルの構成（Managed）がより低いレベルの構成（User/Project）をオーバーライドします
* **継承**：設定がマージされ、より具体的な設定がより広い設定に追加またはオーバーライドされます

### システムプロンプト

Claude Code の内部システムプロンプトは公開されていません。カスタム指示を追加するには、`CLAUDE.md` ファイルまたは `--append-system-prompt` フラグを使用してください。

### 機密ファイルの除外

API キー、シークレット、環境ファイルなどの機密情報を含むファイルから Claude Code がアクセスするのを防ぐには、`.claude/settings.json` ファイルの `permissions.deny` 設定を使用してください：

```json  theme={null}
{
  "permissions": {
    "deny": [
      "Read(./.env)",
      "Read(./.env.*)",
      "Read(./secrets/**)",
      "Read(./config/credentials.json)",
      "Read(./build)"
    ]
  }
}
```

これは非推奨の `ignorePatterns` 構成に置き換わります。これらのパターンに一致するファイルはファイル検出と検索結果から除外され、これらのファイルへの読み取り操作は拒否されます。

## Subagent 構成

Claude Code は、ユーザーとプロジェクトレベルの両方で構成できるカスタム AI subagents をサポートしています。これらの subagents は YAML frontmatter を含む Markdown ファイルとして保存されます：

* **ユーザー subagents**：`~/.claude/agents/` - すべてのプロジェクト全体で利用可能
* **プロジェクト subagents**：`.claude/agents/` - プロジェクトに固有で、チームと共有できます

Subagent ファイルは、カスタムプロンプトとツール権限を持つ特殊な AI アシスタントを定義します。subagents の作成と使用の詳細については、[subagents ドキュメント](/ja/sub-agents)を参照してください。

## プラグイン構成

Claude Code は、skills、agents、hooks、MCP servers で機能を拡張できるプラグインシステムをサポートしています。プラグインはマーケットプレイスを通じて配布され、ユーザーとリポジトリレベルの両方で構成できます。

### プラグイン設定

`settings.json` のプラグイン関連設定：

```json  theme={null}
{
  "enabledPlugins": {
    "formatter@acme-tools": true,
    "deployer@acme-tools": true,
    "analyzer@security-plugins": false
  },
  "extraKnownMarketplaces": {
    "acme-tools": {
      "source": "github",
      "repo": "acme-corp/claude-plugins"
    }
  }
}
```

#### `enabledPlugins`

どのプラグインが有効かを制御します。形式：`"plugin-name@marketplace-name": true/false`

**スコープ**：

* **ユーザー設定**（`~/.claude/settings.json`）：個人的なプラグイン設定
* **プロジェクト設定**（`.claude/settings.json`）：チームと共有されるプロジェクト固有のプラグイン
* **ローカル設定**（`.claude/settings.local.json`）：マシンごとのオーバーライド（コミットされない）

**例**：

```json  theme={null}
{
  "enabledPlugins": {
    "code-formatter@team-tools": true,
    "deployment-tools@team-tools": true,
    "experimental-features@personal": false
  }
}
```

#### `extraKnownMarketplaces`

リポジトリで利用可能にする必要がある追加のマーケットプレイスを定義します。通常、リポジトリレベルの設定で使用され、チームメンバーが必要なプラグインソースにアクセスできるようにします。

**リポジトリが `extraKnownMarketplaces` を含む場合**：

1. チームメンバーはフォルダを信頼するときにマーケットプレイスをインストールするよう求められます
2. チームメンバーはそのマーケットプレイスからプラグインをインストールするよう求められます
3. ユーザーは不要なマーケットプレイスまたはプラグインをスキップできます（ユーザー設定に保存）
4. インストールは信頼境界を尊重し、明示的な同意が必要です

**例**：

```json  theme={null}
{
  "extraKnownMarketplaces": {
    "acme-tools": {
      "source": {
        "source": "github",
        "repo": "acme-corp/claude-plugins"
      }
    },
    "security-plugins": {
      "source": {
        "source": "git",
        "url": "https://git.example.com/security/plugins.git"
      }
    }
  }
}
```

**マーケットプレイスソースタイプ**：

* `github`：GitHub リポジトリ（`repo` を使用）
* `git`：任意の git URL（`url` を使用）
* `directory`：ローカルファイルシステムパス（`path` を使用、開発のみ）
* `hostPattern`：マーケットプレイスホストに一致する正規表現パターン（`hostPattern` を使用）

#### `strictKnownMarketplaces`

**Managed 設定のみ**：ユーザーが追加できるプラグインマーケットプレイスを制御します。この設定は[`managed-settings.json`](/ja/permissions#managed-settings)でのみ構成でき、管理者にマーケットプレイスソースの厳密な制御を提供します。

**Managed 設定ファイルの場所**：

* **macOS**：`/Library/Application Support/ClaudeCode/managed-settings.json`
* **Linux と WSL**：`/etc/claude-code/managed-settings.json`
* **Windows**：`C:\Program Files\ClaudeCode\managed-settings.json`

**主な特性**：

* Managed 設定（`managed-settings.json`）でのみ利用可能
* ユーザーまたはプロジェクト設定でオーバーライドできない（最高優先度）
* ネットワーク/ファイルシステム操作の前に実施（ブロックされたソースは実行されない）
* ソース仕様の完全一致を使用します（git ソースの `ref`、`path` を含む）。ただし `hostPattern` は正規表現マッチングを使用します

**アローリスト動作**：

* `undefined`（デフォルト）：制限なし - ユーザーは任意のマーケットプレイスを追加できます
* 空配列 `[]`：完全ロックダウン - ユーザーは新しいマーケットプレイスを追加できません
* ソースのリスト：ユーザーは完全に一致するマーケットプレイスのみを追加できます

**サポートされているすべてのソースタイプ**：

アローリストは 7 つのマーケットプレイスソースタイプをサポートしています。ほとんどのソースは完全一致を使用しますが、`hostPattern` はマーケットプレイスホストに対して正規表現マッチングを使用します。

1. **GitHub リポジトリ**：

```json  theme={null}
{ "source": "github", "repo": "acme-corp/approved-plugins" }
{ "source": "github", "repo": "acme-corp/security-tools", "ref": "v2.0" }
{ "source": "github", "repo": "acme-corp/plugins", "ref": "main", "path": "marketplace" }
```

フィールド：`repo`（必須）、`ref`（オプション：ブランチ/タグ/SHA）、`path`（オプション：サブディレクトリ）

2. **Git リポジトリ**：

```json  theme={null}
{ "source": "git", "url": "https://gitlab.example.com/tools/plugins.git" }
{ "source": "git", "url": "https://bitbucket.org/acme-corp/plugins.git", "ref": "production" }
{ "source": "git", "url": "ssh://git@git.example.com/plugins.git", "ref": "v3.1", "path": "approved" }
```

フィールド：`url`（必須）、`ref`（オプション：ブランチ/タグ/SHA）、`path`（オプション：サブディレクトリ）

3. **URL ベースのマーケットプレイス**：

```json  theme={null}
{ "source": "url", "url": "https://plugins.example.com/marketplace.json" }
{ "source": "url", "url": "https://cdn.example.com/marketplace.json", "headers": { "Authorization": "Bearer ${TOKEN}" } }
```

フィールド：`url`（必須）、`headers`（オプション：認証アクセス用の HTTP ヘッダー）

<Note>
  URL ベースのマーケットプレイスは `marketplace.json` ファイルのみをダウンロードします。サーバーからプラグインファイルをダウンロードしません。URL ベースのマーケットプレイスのプラグインは、相対パスではなく外部ソース（GitHub、npm、git URL）を使用する必要があります。相対パスを持つプラグインの場合は、代わりに Git ベースのマーケットプレイスを使用してください。詳細については、[トラブルシューティング](/ja/plugin-marketplaces#plugins-with-relative-paths-fail-in-url-based-marketplaces)を参照してください。
</Note>

4. **NPM パッケージ**：

```json  theme={null}
{ "source": "npm", "package": "@acme-corp/claude-plugins" }
{ "source": "npm", "package": "@acme-corp/approved-marketplace" }
```

フィールド：`package`（必須、スコープ付きパッケージをサポート）

5. **ファイルパス**：

```json  theme={null}
{ "source": "file", "path": "/usr/local/share/claude/acme-marketplace.json" }
{ "source": "file", "path": "/opt/acme-corp/plugins/marketplace.json" }
```

フィールド：`path`（必須：marketplace.json ファイルへの絶対パス）

6. **ディレクトリパス**：

```json  theme={null}
{ "source": "directory", "path": "/usr/local/share/claude/acme-plugins" }
{ "source": "directory", "path": "/opt/acme-corp/approved-marketplaces" }
```

フィールド：`path`（必須：`.claude-plugin/marketplace.json` を含むディレクトリへの絶対パス）

7. **ホストパターンマッチング**：

```json  theme={null}
{ "source": "hostPattern", "hostPattern": "^github\\.example\\.com$" }
{ "source": "hostPattern", "hostPattern": "^gitlab\\.internal\\.example\\.com$" }
```

フィールド：`hostPattern`（必須：マーケットプレイスホストに対してマッチする正規表現パターン）

各リポジトリを列挙することなく、特定のホストからのすべてのマーケットプレイスを許可する場合は、ホストパターンマッチングを使用してください。これは、開発者が独自のマーケットプレイスを作成する内部 GitHub Enterprise または GitLab サーバーを持つ組織に役立ちます。

ソースタイプ別のホスト抽出：

* `github`：常に `github.com` に対してマッチ
* `git`：URL からホスト名を抽出（HTTPS と SSH 形式の両方をサポート）
* `url`：URL からホスト名を抽出
* `npm`、`file`、`directory`：ホストパターンマッチングではサポートされていません

**構成例**：

例：特定のマーケットプレイスのみを許可：

```json  theme={null}
{
  "strictKnownMarketplaces": [
    {
      "source": "github",
      "repo": "acme-corp/approved-plugins"
    },
    {
      "source": "github",
      "repo": "acme-corp/security-tools",
      "ref": "v2.0"
    },
    {
      "source": "url",
      "url": "https://plugins.example.com/marketplace.json"
    },
    {
      "source": "npm",
      "package": "@acme-corp/compliance-plugins"
    }
  ]
}
```

例 - すべてのマーケットプレイス追加を無効にする：

```json  theme={null}
{
  "strictKnownMarketplaces": []
}
```

例：内部 git サーバーからのすべてのマーケットプレイスを許可：

```json  theme={null}
{
  "strictKnownMarketplaces": [
    {
      "source": "hostPattern",
      "hostPattern": "^github\\.example\\.com$"
    }
  ]
}
```

**完全一致要件**：

マーケットプレイスソースは、ユーザーの追加が許可されるために**完全に一致**する必要があります。git ベースのソース（`github` と `git`）の場合、これにはすべてのオプションフィールドが含まれます：

* `repo` または `url` は完全に一致する必要があります
* `ref` フィールドは完全に一致する必要があります（または両方が未定義）
* `path` フィールドは完全に一致する必要があります（または両方が未定義）

一致**しない**ソースの例：

```json  theme={null}
// これらは異なるソースです：
{ "source": "github", "repo": "acme-corp/plugins" }
{ "source": "github", "repo": "acme-corp/plugins", "ref": "main" }

// これらも異なります：
{ "source": "github", "repo": "acme-corp/plugins", "path": "marketplace" }
{ "source": "github", "repo": "acme-corp/plugins" }
```

**`extraKnownMarketplaces` との比較**：

| 側面            | `strictKnownMarketplaces`  | `extraKnownMarketplaces` |
| ------------- | -------------------------- | ------------------------ |
| **目的**        | 組織ポリシーの実施                  | チームの利便性                  |
| **設定ファイル**    | `managed-settings.json` のみ | 任意の設定ファイル                |
| **動作**        | ホワイトリストに登録されていない追加をブロック    | 不足しているマーケットプレイスを自動インストール |
| **実施時期**      | ネットワーク/ファイルシステム操作の前        | ユーザー信頼プロンプト後             |
| **オーバーライド可能** | いいえ（最高優先度）                 | はい（より高い優先度設定による）         |
| **ソース形式**     | 直接ソースオブジェクト                | 名前付きマーケットプレイスとネストされたソース  |
| **ユースケース**    | コンプライアンス、セキュリティ制限          | オンボーディング、標準化             |

**形式の違い**：

`strictKnownMarketplaces` は直接ソースオブジェクトを使用します：

```json  theme={null}
{
  "strictKnownMarketplaces": [
    { "source": "github", "repo": "acme-corp/plugins" }
  ]
}
```

`extraKnownMarketplaces` は名前付きマーケットプレイスが必要です：

```json  theme={null}
{
  "extraKnownMarketplaces": {
    "acme-tools": {
      "source": { "source": "github", "repo": "acme-corp/plugins" }
    }
  }
}
```

**重要な注意事項**：

* 制限はネットワークリクエストまたはファイルシステム操作の前にチェックされます
* ブロックされた場合、ユーザーはソースが Managed ポリシーによってブロックされていることを示す明確なエラーメッセージが表示されます
* 制限は新しいマーケットプレイスの追加にのみ適用されます。以前にインストールされたマーケットプレイスはアクセス可能なままです
* Managed 設定は最高優先度を持ち、オーバーライドできません

ユーザー向けドキュメントについては、[Managed マーケットプレイス制限](/ja/plugin-marketplaces#managed-marketplace-restrictions)を参照してください。

### プラグインの管理

`/plugin` コマンドを使用してプラグインを対話的に管理します：

* マーケットプレイスから利用可能なプラグインを参照
* プラグインをインストール/アンインストール
* プラグインを有効/無効にする
* プラグインの詳細を表示（提供されるコマンド、agents、hooks）
* マーケットプレイスを追加/削除

プラグインシステムの詳細については、[プラグインドキュメント](/ja/plugins)を参照してください。

## 環境変数

Claude Code は、その動作を制御するために以下の環境変数をサポートしています：

<Note>
  すべての環境変数は[`settings.json`](#available-settings)でも構成できます。これは、各セッションの環境変数を自動的に設定するか、チーム全体または組織全体に環境変数のセットをロールアウトする方法として役立ちます。
</Note>

| 変数                                             | 目的                                                                                                                                                                                                                                                                                                                                                                                              |     |
| :--------------------------------------------- | :---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --- |
| `ANTHROPIC_API_KEY`                            | `X-Api-Key` ヘッダーとして送信される API キー。通常は Claude SDK 用（インタラクティブ使用の場合は `/login` を実行）                                                                                                                                                                                                                                                                                                                   |     |
| `ANTHROPIC_AUTH_TOKEN`                         | `Authorization` ヘッダーのカスタム値（ここで設定した値には `Bearer ` が付加されます）                                                                                                                                                                                                                                                                                                                                        |     |
| `ANTHROPIC_CUSTOM_HEADERS`                     | リクエストに追加するカスタムヘッダー（`Name: Value` 形式、複数ヘッダーの場合は改行区切り）                                                                                                                                                                                                                                                                                                                                            |     |
| `ANTHROPIC_DEFAULT_HAIKU_MODEL`                | [モデル構成](/ja/model-config#environment-variables)を参照                                                                                                                                                                                                                                                                                                                                              |     |
| `ANTHROPIC_DEFAULT_OPUS_MODEL`                 | [モデル構成](/ja/model-config#environment-variables)を参照                                                                                                                                                                                                                                                                                                                                              |     |
| `ANTHROPIC_DEFAULT_SONNET_MODEL`               | [モデル構成](/ja/model-config#environment-variables)を参照                                                                                                                                                                                                                                                                                                                                              |     |
| `ANTHROPIC_FOUNDRY_API_KEY`                    | Microsoft Foundry 認証用の API キー（[Microsoft Foundry](/ja/microsoft-foundry)を参照）                                                                                                                                                                                                                                                                                                                    |     |
| `ANTHROPIC_FOUNDRY_BASE_URL`                   | Foundry リソースの完全なベース URL（例：`https://my-resource.services.ai.azure.com/anthropic`）。`ANTHROPIC_FOUNDRY_RESOURCE` の代替（[Microsoft Foundry](/ja/microsoft-foundry)を参照）                                                                                                                                                                                                                                |     |
| `ANTHROPIC_FOUNDRY_RESOURCE`                   | Foundry リソース名（例：`my-resource`）。`ANTHROPIC_FOUNDRY_BASE_URL` が設定されていない場合は必須（[Microsoft Foundry](/ja/microsoft-foundry)を参照）                                                                                                                                                                                                                                                                       |     |
| `ANTHROPIC_MODEL`                              | 使用するモデル設定の名前（[モデル構成](/ja/model-config#environment-variables)を参照）                                                                                                                                                                                                                                                                                                                                |     |
| `ANTHROPIC_SMALL_FAST_MODEL`                   | \[非推奨] バックグラウンドタスク用の[Haiku クラスモデルの名前](/ja/costs)                                                                                                                                                                                                                                                                                                                                                |     |
| `ANTHROPIC_SMALL_FAST_MODEL_AWS_REGION`        | Bedrock を使用する場合、Haiku クラスモデルの AWS リージョンをオーバーライド                                                                                                                                                                                                                                                                                                                                                 |     |
| `AWS_BEARER_TOKEN_BEDROCK`                     | 認証用の Bedrock API キー（[Bedrock API キー](https://aws.amazon.com/blogs/machine-learning/accelerate-ai-development-with-amazon-bedrock-api-keys/)を参照）                                                                                                                                                                                                                                                 |     |
| `BASH_DEFAULT_TIMEOUT_MS`                      | 長時間実行される bash コマンドのデフォルトタイムアウト                                                                                                                                                                                                                                                                                                                                                                  |     |
| `BASH_MAX_OUTPUT_LENGTH`                       | 中央で切り詰められる前の bash 出力の最大文字数                                                                                                                                                                                                                                                                                                                                                                      |     |
| `BASH_MAX_TIMEOUT_MS`                          | モデルが長時間実行される bash コマンドに設定できる最大タイムアウト                                                                                                                                                                                                                                                                                                                                                            |     |
| `CLAUDE_AUTOCOMPACT_PCT_OVERRIDE`              | 自動コンパクションがトリガーされるコンテキスト容量のパーセンテージ（1～100）を設定します。デフォルトでは、自動コンパクションは約 95% の容量でトリガーされます。`50` などの低い値を使用して早期にコンパクトします。デフォルトしきい値より高い値は効果がありません。メイン会話と subagents の両方に適用されます。このパーセンテージは[ステータスライン](/ja/statusline)で利用可能な `context_window.used_percentage` フィールドと一致します                                                                                                                                     |     |
| `CLAUDE_BASH_MAINTAIN_PROJECT_WORKING_DIR`     | 各 Bash コマンド後に元の作業ディレクトリに戻ります                                                                                                                                                                                                                                                                                                                                                                    |     |
| `CLAUDE_CODE_ADDITIONAL_DIRECTORIES_CLAUDE_MD` | `--add-dir` で指定されたディレクトリから CLAUDE.md ファイルを読み込むには `1` に設定します。デフォルトでは、追加ディレクトリはメモリファイルを読み込みません                                                                                                                                                                                                                                                                                                    | `1` |
| `CLAUDE_CODE_API_KEY_HELPER_TTL_MS`            | 認証情報をリフレッシュする間隔（ミリ秒）（`apiKeyHelper` を使用する場合）                                                                                                                                                                                                                                                                                                                                                    |     |
| `CLAUDE_CODE_CLIENT_CERT`                      | mTLS 認証用のクライアント証明書ファイルへのパス                                                                                                                                                                                                                                                                                                                                                                      |     |
| `CLAUDE_CODE_CLIENT_KEY_PASSPHRASE`            | 暗号化された CLAUDE\_CODE\_CLIENT\_KEY のパスフレーズ（オプション）                                                                                                                                                                                                                                                                                                                                                 |     |
| `CLAUDE_CODE_CLIENT_KEY`                       | mTLS 認証用のクライアント秘密鍵ファイルへのパス                                                                                                                                                                                                                                                                                                                                                                      |     |
| `CLAUDE_CODE_DISABLE_EXPERIMENTAL_BETAS`       | Anthropic API 固有の `anthropic-beta` ヘッダーを無効にするには `1` に設定します。サードパーティプロバイダーを持つ LLM ゲートウェイを使用する場合、「`anthropic-beta` ヘッダーの予期しない値」などの問題が発生している場合に使用します                                                                                                                                                                                                                                                |     |
| `CLAUDE_CODE_DISABLE_BACKGROUND_TASKS`         | すべてのバックグラウンドタスク機能（Bash と subagent ツールの `run_in_background` パラメータ、自動バックグラウンド化、Ctrl+B ショートカットを含む）を無効にするには `1` に設定します                                                                                                                                                                                                                                                                              |     |
| `CLAUDE_CODE_DISABLE_FEEDBACK_SURVEY`          | 「Claude はどのように機能していますか？」セッション品質調査を無効にするには `1` に設定します。サードパーティプロバイダーを使用する場合またはテレメトリが無効な場合も無効になります。[セッション品質調査](/ja/data-usage#session-quality-surveys)を参照してください                                                                                                                                                                                                                                    |     |
| `CLAUDE_CODE_EXIT_AFTER_STOP_DELAY`            | クエリループがアイドル状態になった後、自動的に終了するまでの待機時間（ミリ秒）。SDK モードを使用する自動化されたワークフローとスクリプトに役立ちます                                                                                                                                                                                                                                                                                                                    |     |
| `CLAUDE_CODE_PROXY_RESOLVES_HOSTS`             | プロキシが呼び出し元の代わりに DNS 解決を実行できるようにするには `true` に設定します。プロキシがホスト名解決を処理する必要がある環境でのオプトイン                                                                                                                                                                                                                                                                                                                |     |
| `CLAUDE_CODE_TASK_LIST_ID`                     | セッション全体でタスクリストを共有します。複数の Claude Code インスタンスで同じ ID を設定して、共有タスクリストで調整します。[タスクリスト](/ja/interactive-mode#task-list)を参照してください                                                                                                                                                                                                                                                                        |     |
| `CLAUDE_CODE_TMPDIR`                           | 内部一時ファイルに使用される一時ディレクトリをオーバーライドします。Claude Code はこのパスに `/claude/` を追加します。デフォルト：Unix/macOS では `/tmp`、Windows では `os.tmpdir()`                                                                                                                                                                                                                                                                      |     |
| `CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC`     | `DISABLE_AUTOUPDATER`、`DISABLE_BUG_COMMAND`、`DISABLE_ERROR_REPORTING`、`DISABLE_TELEMETRY` を設定するのと同等                                                                                                                                                                                                                                                                                             |     |
| `CLAUDE_CODE_DISABLE_TERMINAL_TITLE`           | 会話コンテキストに基づいて自動ターミナルタイトル更新を無効にするには `1` に設定します                                                                                                                                                                                                                                                                                                                                                   |     |
| `CLAUDE_CODE_ENABLE_PROMPT_SUGGESTION`         | プロンプト提案を無効にするには `false` に設定します（`/config` の「プロンプト提案」トグル）。これらは Claude が応答した後、プロンプト入力に表示される灰色の予測です。[プロンプト提案](/ja/interactive-mode#prompt-suggestions)を参照してください                                                                                                                                                                                                                                     |     |
| `CLAUDE_CODE_ENABLE_TASKS`                     | 前の TODO リストに一時的に戻すには `false` に設定します。デフォルト：`true`。[タスクリスト](/ja/interactive-mode#task-list)を参照してください                                                                                                                                                                                                                                                                                              |     |
| `CLAUDE_CODE_ENABLE_TELEMETRY`                 | メトリクスとログの OpenTelemetry データ収集を有効にするには `1` に設定します。OTel エクスポーターを構成する前に必須です。[監視](/ja/monitoring-usage)を参照してください                                                                                                                                                                                                                                                                                    |     |
| `CLAUDE_CODE_FILE_READ_MAX_OUTPUT_TOKENS`      | ファイル読み取りのデフォルトトークン制限をオーバーライドします。より大きなファイルを完全に読み取る必要がある場合に役立ちます                                                                                                                                                                                                                                                                                                                                  |     |
| `CLAUDE_CODE_HIDE_ACCOUNT_INFO`                | Claude Code UI からメールアドレスと組織名を非表示にするには `1` に設定します。ストリーミングまたは記録時に役立ちます                                                                                                                                                                                                                                                                                                                            |     |
| `CLAUDE_CODE_IDE_SKIP_AUTO_INSTALL`            | IDE 拡張機能の自動インストールをスキップ                                                                                                                                                                                                                                                                                                                                                                          |     |
| `CLAUDE_CODE_MAX_OUTPUT_TOKENS`                | ほとんどのリクエストの最大出力トークン数を設定します。デフォルト：32,000。最大：64,000。この値を増やすと、[自動コンパクション](/ja/costs#reduce-token-usage)がトリガーされる前に利用可能な有効コンテキストウィンドウが減少します。                                                                                                                                                                                                                                                         |     |
| `CLAUDE_CODE_OTEL_HEADERS_HELPER_DEBOUNCE_MS`  | 動的 OpenTelemetry ヘッダーをリフレッシュする間隔（ミリ秒）（デフォルト：1740000 / 29 分）。[動的ヘッダー](/ja/monitoring-usage#dynamic-headers)を参照してください                                                                                                                                                                                                                                                                             |     |
| `CLAUDE_CODE_SHELL`                            | 自動シェル検出をオーバーライドします。ログインシェルが優先作業シェルと異なる場合に役立ちます（例：`bash` vs `zsh`）                                                                                                                                                                                                                                                                                                                               |     |
| `CLAUDE_CODE_SHELL_PREFIX`                     | すべての bash コマンドをラップするコマンドプレフィックス（ログまたは監査用など）。例：`/path/to/logger.sh` は `/path/to/logger.sh <command>` を実行します                                                                                                                                                                                                                                                                                      |     |
| `CLAUDE_CODE_SKIP_BEDROCK_AUTH`                | Bedrock の AWS 認証をスキップします（例：LLM ゲートウェイを使用する場合）                                                                                                                                                                                                                                                                                                                                                   |     |
| `CLAUDE_CODE_SKIP_FOUNDRY_AUTH`                | Microsoft Foundry の Azure 認証をスキップします（例：LLM ゲートウェイを使用する場合）                                                                                                                                                                                                                                                                                                                                       |     |
| `CLAUDE_CODE_SKIP_VERTEX_AUTH`                 | Vertex の Google 認証をスキップします（例：LLM ゲートウェイを使用する場合）                                                                                                                                                                                                                                                                                                                                                 |     |
| `CLAUDE_CODE_SUBAGENT_MODEL`                   | [モデル構成](/ja/model-config)を参照                                                                                                                                                                                                                                                                                                                                                                    |     |
| `CLAUDE_CODE_USE_BEDROCK`                      | [Bedrock](/ja/amazon-bedrock)を使用                                                                                                                                                                                                                                                                                                                                                                |     |
| `CLAUDE_CODE_USE_FOUNDRY`                      | [Microsoft Foundry](/ja/microsoft-foundry)を使用                                                                                                                                                                                                                                                                                                                                                   |     |
| `CLAUDE_CODE_USE_VERTEX`                       | [Vertex](/ja/google-vertex-ai)を使用                                                                                                                                                                                                                                                                                                                                                               |     |
| `CLAUDE_CONFIG_DIR`                            | Claude Code が構成とデータファイルを保存する場所をカスタマイズ                                                                                                                                                                                                                                                                                                                                                           |     |
| `DISABLE_AUTOUPDATER`                          | 自動更新を無効にするには `1` に設定します。                                                                                                                                                                                                                                                                                                                                                                        |     |
| `DISABLE_BUG_COMMAND`                          | `/bug` コマンドを無効にするには `1` に設定します                                                                                                                                                                                                                                                                                                                                                                  |     |
| `DISABLE_COST_WARNINGS`                        | コスト警告メッセージを無効にするには `1` に設定します                                                                                                                                                                                                                                                                                                                                                                   |     |
| `DISABLE_ERROR_REPORTING`                      | Sentry エラーレポートをオプトアウトするには `1` に設定します                                                                                                                                                                                                                                                                                                                                                            |     |
| `DISABLE_INSTALLATION_CHECKS`                  | インストール警告を無効にするには `1` に設定します。標準インストールの問題をマスクできるため、インストール場所を手動で管理する場合のみ使用してください                                                                                                                                                                                                                                                                                                                   |     |
| `DISABLE_NON_ESSENTIAL_MODEL_CALLS`            | フレーバーテキストなどの非重要パスのモデル呼び出しを無効にするには `1` に設定します                                                                                                                                                                                                                                                                                                                                                    |     |
| `DISABLE_PROMPT_CACHING`                       | すべてのモデルのプロンプトキャッシングを無効にするには `1` に設定します（モデルごとの設定より優先）                                                                                                                                                                                                                                                                                                                                            |     |
| `DISABLE_PROMPT_CACHING_HAIKU`                 | Haiku モデルのプロンプトキャッシングを無効にするには `1` に設定します                                                                                                                                                                                                                                                                                                                                                        |     |
| `DISABLE_PROMPT_CACHING_OPUS`                  | Opus モデルのプロンプトキャッシングを無効にするには `1` に設定します                                                                                                                                                                                                                                                                                                                                                         |     |
| `DISABLE_PROMPT_CACHING_SONNET`                | Sonnet モデルのプロンプトキャッシングを無効にするには `1` に設定します                                                                                                                                                                                                                                                                                                                                                       |     |
| `DISABLE_TELEMETRY`                            | Statsig テレメトリをオプトアウトするには `1` に設定します（Statsig イベントにはコード、ファイルパス、bash コマンドなどのユーザーデータは含まれません）                                                                                                                                                                                                                                                                                                        |     |
| `ENABLE_TOOL_SEARCH`                           | [MCP ツール検索](/ja/mcp#scale-with-mcp-tool-search)を制御します。値：`auto`（デフォルト、10% コンテキストで有効）、`auto:N`（カスタムしきい値、例：5% の場合は `auto:5`）、`true`（常にオン）、`false`（無効）                                                                                                                                                                                                                                              |     |
| `FORCE_AUTOUPDATE_PLUGINS`                     | メイン自動アップデーターが `DISABLE_AUTOUPDATER` で無効になっている場合でも、プラグイン自動更新を強制するには `true` に設定します                                                                                                                                                                                                                                                                                                                |     |
| `HTTP_PROXY`                                   | ネットワーク接続用の HTTP プロキシサーバーを指定                                                                                                                                                                                                                                                                                                                                                                     |     |
| `HTTPS_PROXY`                                  | ネットワーク接続用の HTTPS プロキシサーバーを指定                                                                                                                                                                                                                                                                                                                                                                    |     |
| `IS_DEMO`                                      | デモモードを有効にするには `true` に設定します：UI からメールと組織を非表示にし、オンボーディングをスキップし、内部コマンドを非表示にします。ストリーミングまたは記録セッションに役立ちます                                                                                                                                                                                                                                                                                             |     |
| `MAX_MCP_OUTPUT_TOKENS`                        | MCP ツール応答で許可される最大トークン数。出力が 10,000 トークンを超える場合、Claude Code は警告を表示します（デフォルト：25000）                                                                                                                                                                                                                                                                                                                 |     |
| `MAX_THINKING_TOKENS`                          | [拡張思考](https://platform.claude.com/docs/en/build-with-claude/extended-thinking)トークン予算をオーバーライドします。思考はデフォルトで最大予算（31,999 トークン）で有効になります。予算を制限するには（例：`MAX_THINKING_TOKENS=10000`）または思考を完全に無効にするには（`MAX_THINKING_TOKENS=0`）これを使用してください。拡張思考は複雑な推論とコーディングタスクのパフォーマンスを向上させますが、[プロンプトキャッシング効率](https://platform.claude.com/docs/en/build-with-claude/prompt-caching#caching-with-thinking-blocks)に影響します。 |     |
| `MCP_TIMEOUT`                                  | MCP サーバー起動のタイムアウト（ミリ秒）                                                                                                                                                                                                                                                                                                                                                                          |     |
| `MCP_TOOL_TIMEOUT`                             | MCP ツール実行のタイムアウト（ミリ秒）                                                                                                                                                                                                                                                                                                                                                                           |     |
| `NO_PROXY`                                     | プロキシをバイパスして直接発行されるリクエストのドメインと IP のリスト                                                                                                                                                                                                                                                                                                                                                           |     |
| `SLASH_COMMAND_TOOL_CHAR_BUDGET`               | [Skill ツール](/ja/skills#control-who-invokes-a-skill)に表示される skill メタデータの最大文字数（デフォルト：15000）。後方互換性のため従来の名前を保持                                                                                                                                                                                                                                                                                       |     |
| `USE_BUILTIN_RIPGREP`                          | Claude Code に含まれる `rg` の代わりにシステムインストール済みの `rg` を使用するには `0` に設定します                                                                                                                                                                                                                                                                                                                               |     |
| `VERTEX_REGION_CLAUDE_3_5_HAIKU`               | Vertex AI を使用する場合、Claude 3.5 Haiku のリージョンをオーバーライド                                                                                                                                                                                                                                                                                                                                               |     |
| `VERTEX_REGION_CLAUDE_3_7_SONNET`              | Vertex AI を使用する場合、Claude 3.7 Sonnet のリージョンをオーバーライド                                                                                                                                                                                                                                                                                                                                              |     |
| `VERTEX_REGION_CLAUDE_4_0_OPUS`                | Vertex AI を使用する場合、Claude 4.0 Opus のリージョンをオーバーライド                                                                                                                                                                                                                                                                                                                                                |     |
| `VERTEX_REGION_CLAUDE_4_0_SONNET`              | Vertex AI を使用する場合、Claude 4.0 Sonnet のリージョンをオーバーライド                                                                                                                                                                                                                                                                                                                                              |     |
| `VERTEX_REGION_CLAUDE_4_1_OPUS`                | Vertex AI を使用する場合、Claude 4.1 Opus のリージョンをオーバーライド                                                                                                                                                                                                                                                                                                                                                |     |

## Claude が利用可能なツール

Claude Code は、コードベースを理解および変更するのに役立つ強力なツールのセットにアクセスできます：

| ツール                 | 説明                                                                                                                                                                                               | 権限が必要 |
| :------------------ | :----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :---- |
| **AskUserQuestion** | 要件を収集または曖昧さを明確にするための複数選択質問をします                                                                                                                                                                   | いいえ   |
| **Bash**            | 環境でシェルコマンドを実行します（以下の[Bash ツール動作](#bash-tool-behavior)を参照）                                                                                                                                        | はい    |
| **TaskOutput**      | バックグラウンドタスク（bash シェルまたは subagent）から出力を取得します                                                                                                                                                      | いいえ   |
| **Edit**            | 特定のファイルに対象を絞った編集を行います                                                                                                                                                                            | はい    |
| **ExitPlanMode**    | ユーザーにプランモードを終了してコーディングを開始するよう促します                                                                                                                                                                | はい    |
| **Glob**            | パターンマッチングに基づいてファイルを検索します                                                                                                                                                                         | いいえ   |
| **Grep**            | ファイルコンテンツ内のパターンを検索します                                                                                                                                                                            | いいえ   |
| **KillShell**       | ID でバックグラウンド bash シェルを実行中に終了します                                                                                                                                                                  | いいえ   |
| **MCPSearch**       | [ツール検索](/ja/mcp#scale-with-mcp-tool-search)が有効な場合、MCP ツールを検索して読み込みます                                                                                                                             | いいえ   |
| **NotebookEdit**    | Jupyter ノートブックセルを変更します                                                                                                                                                                           | はい    |
| **Read**            | ファイルの内容を読み取ります                                                                                                                                                                                   | いいえ   |
| **Skill**           | メイン会話内で[skill](/ja/skills#control-who-invokes-a-skill)を実行します                                                                                                                                     | はい    |
| **Task**            | 複雑なマルチステップタスクを処理するために subagent を実行します                                                                                                                                                            | いいえ   |
| **TaskCreate**      | タスクリストに新しいタスクを作成します                                                                                                                                                                              | いいえ   |
| **TaskGet**         | 特定のタスクの完全な詳細を取得します                                                                                                                                                                               | いいえ   |
| **TaskList**        | 現在のステータスを持つすべてのタスクをリストします                                                                                                                                                                        | いいえ   |
| **TaskUpdate**      | タスクステータス、依存関係、詳細を更新するか、タスクを削除します                                                                                                                                                                 | いいえ   |
| **WebFetch**        | 指定された URL からコンテンツをフェッチします                                                                                                                                                                        | はい    |
| **WebSearch**       | ドメインフィルタリング付きで Web 検索を実行します                                                                                                                                                                      | はい    |
| **Write**           | ファイルを作成または上書きします                                                                                                                                                                                 | はい    |
| **LSP**             | 言語サーバー経由のコード インテリジェンス。ファイル編集後に型エラーと警告を自動的にレポートします。ナビゲーション操作もサポート：定義にジャンプ、参照を検索、型情報を取得、シンボルをリスト、実装を検索、呼び出し階層をトレース。[コード インテリジェンス プラグイン](/ja/discover-plugins#code-intelligence)とその言語サーバー バイナリが必要です | いいえ   |

権限ルールは `/allowed-tools` または[権限設定](/ja/settings#available-settings)を使用して構成できます。[ツール固有の権限ルール](/ja/permissions#tool-specific-permission-rules)も参照してください。

### Bash ツール動作

Bash ツールは、以下の永続性動作でシェルコマンドを実行します：

* **作業ディレクトリが永続化**：Claude が作業ディレクトリを変更する場合（例：`cd /path/to/dir`）、後続の Bash コマンドはそのディレクトリで実行されます。`CLAUDE_BASH_MAINTAIN_PROJECT_WORKING_DIR=1` を使用して、各コマンド後にプロジェクトディレクトリにリセットできます。
* **環境変数は永続化しない**：1 つの Bash コマンドで設定された環境変数（例：`export MY_VAR=value`）は、後続の Bash コマンドで**利用できません**。各 Bash コマンドは新しいシェル環境で実行されます。

Bash コマンドで環境変数を利用可能にするには、**3 つのオプション**があります：

**オプション 1：Claude Code を開始する前に環境をアクティブ化**（最も簡単なアプローチ）

Claude Code を起動する前に、ターミナルで仮想環境をアクティブ化します：

```bash  theme={null}
conda activate myenv
# または：source /path/to/venv/bin/activate
claude
```

これはシェル環境で機能しますが、Claude の Bash コマンド内で設定された環境変数はコマンド間で永続化しません。

**オプション 2：Claude Code を開始する前に CLAUDE\_ENV\_FILE を設定**（永続的な環境セットアップ）

環境セットアップを含むシェルスクリプトへのパスをエクスポートします：

```bash  theme={null}
export CLAUDE_ENV_FILE=/path/to/env-setup.sh
claude
```

ここで `/path/to/env-setup.sh` には以下が含まれます：

```bash  theme={null}
conda activate myenv
# または：source /path/to/venv/bin/activate
# または：export MY_VAR=value
```

Claude Code はこのファイルを各 Bash コマンド前にソースし、すべてのコマンド全体で環境を永続化します。

**オプション 3：SessionStart hook を使用**（プロジェクト固有の構成）

`.claude/settings.json` で構成します：

```json  theme={null}
{
  "hooks": {
    "SessionStart": [{
      "matcher": "startup",
      "hooks": [{
        "type": "command",
        "command": "echo 'conda activate myenv' >> \"$CLAUDE_ENV_FILE\""
      }]
    }]
  }
}
```

hook は `$CLAUDE_ENV_FILE` に書き込み、その後各 Bash コマンド前にソースされます。これはチーム共有プロジェクト構成に最適です。

[SessionStart hooks](/ja/hooks#persist-environment-variables)でオプション 3 の詳細を参照してください。

### hooks でツールを拡張

[Claude Code hooks](/ja/hooks-guide)を使用して、任意のツール実行の前後にカスタムコマンドを実行できます。

たとえば、Claude が Python ファイルを変更した後に Python フォーマッタを自動的に実行するか、特定のパスへの Write 操作をブロックして本番構成ファイルの変更を防ぐことができます。

## 関連項目

* [権限](/ja/permissions)：権限システム、ルール構文、ツール固有パターン、Managed ポリシー
* [認証](/ja/authentication)：Claude Code へのユーザーアクセスをセットアップ
* [トラブルシューティング](/ja/troubleshooting)：一般的な構成の問題の解決策
