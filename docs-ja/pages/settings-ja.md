> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# Claude Code の設定

> グローバルおよびプロジェクトレベルの設定と環境変数を使用して Claude Code を構成します。

Claude Code は、ニーズに合わせて動作を構成するためのさまざまな設定を提供しています。インタラクティブ REPL を使用する際に `/config` コマンドを実行することで Claude Code を構成できます。これにより、ステータス情報を表示し、構成オプションを変更できるタブ付き設定インターフェースが開きます。

## 構成スコープ

Claude Code は、**スコープシステム**を使用して、構成がどこに適用され、誰と共有されるかを決定します。スコープを理解することで、個人使用、チーム協力、またはエンタープライズデプロイメント用に Claude Code を構成する方法を決定するのに役立ちます。

### 利用可能なスコープ

| スコープ        | 場所                                                         | 影響を受けるユーザー          | チームと共有されるか          |
| :---------- | :--------------------------------------------------------- | :------------------ | :------------------ |
| **Managed** | サーバー管理設定、plist / レジストリ、またはシステムレベルの `managed-settings.json` | マシン上のすべてのユーザー       | はい（IT によってデプロイされます） |
| **User**    | `~/.claude/` ディレクトリ                                        | すべてのプロジェクト全体でのあなた   | いいえ                 |
| **Project** | リポジトリ内の `.claude/`                                         | このリポジトリのすべてのコラボレーター | はい（git にコミットされます）   |
| **Local**   | `.claude/*.local.*` ファイル                                   | このリポジトリ内のあなたのみ      | いいえ（gitignored）     |

### 各スコープを使用する場合

**Managed スコープ**は以下の場合に使用します：

* 組織全体で実施する必要があるセキュリティポリシー
* オーバーライドできないコンプライアンス要件
* IT/DevOps によってデプロイされた標準化された構成

**User スコープ**は以下の場合に最適です：

* すべての場所で必要な個人設定（テーマ、エディター設定）
* すべてのプロジェクト全体で使用するツールとプラグイン
* API キーと認証（安全に保存）

**Project スコープ**は以下の場合に最適です：

* チーム共有設定（権限、hooks、MCP サーバー）
* チーム全体が持つべきプラグイン
* コラボレーター全体でのツール標準化

**Local スコープ**は以下の場合に最適です：

* 特定のプロジェクトの個人的なオーバーライド
* チームと共有する前に構成をテストする
* 他のユーザーには機能しないマシン固有の設定

### スコープの相互作用

同じ設定が複数のスコープで構成されている場合、より具体的なスコープが優先されます：

1. **Managed**（最高） - 何によってもオーバーライドできません
2. **コマンドライン引数** - 一時的なセッションオーバーライド
3. **Local** - プロジェクトおよびユーザー設定をオーバーライド
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
* **Managed 設定**：集中管理が必要な組織向けに、Claude Code は managed 設定の複数の配信メカニズムをサポートしています。すべて同じ JSON 形式を使用し、ユーザーまたはプロジェクト設定によってオーバーライドできません：

  * **サーバー管理設定**：Anthropic のサーバーから Claude.ai 管理コンソール経由で配信されます。[サーバー管理設定](/ja/server-managed-settings)を参照してください。
  * **MDM/OS レベルのポリシー**：macOS および Windows のネイティブデバイス管理を通じて配信されます：
    * macOS：`com.anthropic.claudecode` managed preferences ドメイン（Jamf、Kandji、または他の MDM ツールの構成プロファイルを通じてデプロイ）
    * Windows：`HKLM\SOFTWARE\Policies\ClaudeCode` レジストリキーと JSON を含む `Settings` 値（REG\_SZ または REG\_EXPAND\_SZ）（グループポリシーまたは Intune を通じてデプロイ）
    * Windows（ユーザーレベル）：`HKCU\SOFTWARE\Policies\ClaudeCode`（最低ポリシー優先度、管理者レベルのソースが存在しない場合のみ使用）
  * **ファイルベース**：`managed-settings.json` および `managed-mcp.json` がシステムディレクトリにデプロイされます：
    * macOS：`/Library/Application Support/ClaudeCode/`
    * Linux および WSL：`/etc/claude-code/`
    * Windows：`C:\Program Files\ClaudeCode\`

  詳細については、[managed 設定](/ja/permissions#managed-only-settings)および [Managed MCP 構成](/ja/mcp#managed-mcp-configuration)を参照してください。

  <Note>
    Managed デプロイメントは、`strictKnownMarketplaces` を使用して**プラグインマーケットプレイスの追加**を制限することもできます。詳細については、[Managed マーケットプレイス制限](/ja/plugin-marketplaces#managed-marketplace-restrictions)を参照してください。
  </Note>
* **その他の構成**は `~/.claude.json` に保存されます。このファイルには、設定（テーマ、通知設定、エディターモード）、OAuth セッション、[MCP サーバー](/ja/mcp)ユーザーおよびローカルスコープの構成、プロジェクトごとの状態（許可されたツール、信頼設定）、および様々なキャッシュが含まれます。プロジェクトスコープの MCP サーバーは `.mcp.json` に別途保存されます。

<Note>
  Claude Code は構成ファイルのタイムスタンプ付きバックアップを自動的に作成し、データ損失を防ぐために最新の 5 つのバックアップを保持します。
</Note>

```JSON Example settings.json theme={null}
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

上記の例の `$schema` 行は、Claude Code 設定の[公式 JSON スキーマ](https://json.schemastore.org/claude-code-settings.json)を指しています。これを `settings.json` に追加すると、VS Code、Cursor、および JSON スキーマ検証をサポートする他のエディターでオートコンプリートとインライン検証が有効になります。

### 利用可能な設定

`settings.json` は多くのオプションをサポートしています：

| キー                                | 説明                                                                                                                                                                                                        | 例                                                                       |
| :-------------------------------- | :-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :---------------------------------------------------------------------- |
| `apiKeyHelper`                    | `/bin/sh` で実行される認証値を生成するカスタムスクリプト。この値は、モデルリクエストの `X-Api-Key` および `Authorization: Bearer` ヘッダーとして送信されます                                                                                                    | `/bin/generate_temp_api_key.sh`                                         |
| `cleanupPeriodDays`               | この期間より長い間非アクティブなセッションは起動時に削除されます。`0` に設定するとすべてのセッションが即座に削除されます。（デフォルト：30 日）                                                                                                                               | `20`                                                                    |
| `companyAnnouncements`            | 起動時にユーザーに表示するアナウンスメント。複数のアナウンスメントが提供される場合、ランダムにサイクルされます。                                                                                                                                                  | `["Welcome to Acme Corp! Review our code guidelines at docs.acme.com"]` |
| `env`                             | すべてのセッションに適用される環境変数                                                                                                                                                                                       | `{"FOO": "bar"}`                                                        |
| `attribution`                     | git コミットおよびプルリクエストの属性をカスタマイズします。[属性設定](#attribution-settings)を参照してください                                                                                                                                    | `{"commit": "🤖 Generated with Claude Code", "pr": ""}`                 |
| `includeCoAuthoredBy`             | **非推奨**：代わりに `attribution` を使用してください。git コミットおよびプルリクエストに `co-authored-by Claude` バイラインを含めるかどうか（デフォルト：`true`）                                                                                              | `false`                                                                 |
| `permissions`                     | 権限の構造については以下の表を参照してください。                                                                                                                                                                                  |                                                                         |
| `hooks`                           | ライフサイクルイベントで実行するカスタムコマンドを構成します。形式については [hooks ドキュメント](/ja/hooks)を参照してください                                                                                                                                 | [hooks](/ja/hooks) を参照                                                  |
| `disableAllHooks`                 | すべての [hooks](/ja/hooks) およびカスタム [status line](/ja/statusline) を無効にします                                                                                                                                     | `true`                                                                  |
| `allowManagedHooksOnly`           | （Managed 設定のみ）ユーザー、プロジェクト、およびプラグイン hooks の読み込みを防止します。managed hooks および SDK hooks のみを許可します。[Hook 構成](#hook-configuration)を参照してください                                                                         | `true`                                                                  |
| `allowedHttpHookUrls`             | HTTP hooks がターゲットにできる URL パターンのホワイトリスト。`*` をワイルドカードとしてサポートします。設定すると、一致しない URL を持つ hooks はブロックされます。未定義 = 制限なし、空配列 = すべての HTTP hooks をブロック。配列は設定ソース全体でマージされます。[Hook 構成](#hook-configuration)を参照してください       | `["https://hooks.example.com/*"]`                                       |
| `httpHookAllowedEnvVars`          | HTTP hooks がヘッダーに補間できる環境変数名のホワイトリスト。設定すると、各 hook の有効な `allowedEnvVars` はこのリストとの交差になります。未定義 = 制限なし。配列は設定ソース全体でマージされます。[Hook 構成](#hook-configuration)を参照してください                                              | `["MY_TOKEN", "HOOK_SECRET"]`                                           |
| `allowManagedPermissionRulesOnly` | （Managed 設定のみ）ユーザーおよびプロジェクト設定が `allow`、`ask`、または `deny` 権限ルールを定義するのを防止します。managed 設定のルールのみが適用されます。[Managed のみの設定](/ja/permissions#managed-only-settings)を参照してください                                         | `true`                                                                  |
| `allowManagedMcpServersOnly`      | （Managed 設定のみ）managed 設定からの `allowedMcpServers` のみが尊重されます。`deniedMcpServers` はすべてのソースからマージされます。ユーザーは MCP サーバーを追加できますが、管理者定義のホワイトリストのみが適用されます。[Managed MCP 構成](/ja/mcp#managed-mcp-configuration)を参照してください | `true`                                                                  |
| `model`                           | Claude Code に使用するデフォルトモデルをオーバーライドします                                                                                                                                                                      | `"claude-sonnet-4-6"`                                                   |
| `availableModels`                 | `/model`、`--model`、Config ツール、または `ANTHROPIC_MODEL` を通じてユーザーが選択できるモデルを制限します。デフォルトオプションには影響しません。[モデル選択を制限](/ja/model-config#restrict-model-selection)を参照してください                                             | `["sonnet", "haiku"]`                                                   |
| `otelHeadersHelper`               | 動的 OpenTelemetry ヘッダーを生成するスクリプト。起動時および定期的に実行されます（[動的ヘッダー](/ja/monitoring-usage#dynamic-headers)を参照）                                                                                                       | `/bin/generate_otel_headers.sh`                                         |
| `statusLine`                      | コンテキストを表示するカスタムステータスラインを構成します。[`statusLine` ドキュメント](/ja/statusline)を参照してください                                                                                                                              | `{"type": "command", "command": "~/.claude/statusline.sh"}`             |
| `fileSuggestion`                  | `@` ファイルオートコンプリート用のカスタムスクリプトを構成します。[ファイル提案設定](#file-suggestion-settings)を参照してください                                                                                                                         | `{"type": "command", "command": "~/.claude/file-suggestion.sh"}`        |
| `respectGitignore`                | `@` ファイルピッカーが `.gitignore` パターンを尊重するかどうかを制御します。`true`（デフォルト）の場合、`.gitignore` パターンに一致するファイルは提案から除外されます                                                                                                     | `false`                                                                 |
| `outputStyle`                     | システムプロンプトを調整する出力スタイルを構成します。[出力スタイルドキュメント](/ja/output-styles)を参照してください                                                                                                                                     | `"Explanatory"`                                                         |
| `forceLoginMethod`                | Claude.ai アカウントへのログインを制限するには `claudeai` を使用し、Claude Console（API 使用量請求）アカウントへのログインを制限するには `console` を使用します                                                                                                 | `claudeai`                                                              |
| `forceLoginOrgUUID`               | ログイン中に自動的に選択される組織の UUID を指定し、組織選択ステップをバイパスします。`forceLoginMethod` が設定されている必要があります                                                                                                                          | `"xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"`                                |
| `enableAllProjectMcpServers`      | プロジェクト `.mcp.json` ファイルで定義されたすべての MCP サーバーを自動的に承認します                                                                                                                                                      | `true`                                                                  |
| `enabledMcpjsonServers`           | 承認する `.mcp.json` ファイルからの特定の MCP サーバーのリスト                                                                                                                                                                  | `["memory", "github"]`                                                  |
| `disabledMcpjsonServers`          | 拒否する `.mcp.json` ファイルからの特定の MCP サーバーのリスト                                                                                                                                                                  | `["filesystem"]`                                                        |
| `allowedMcpServers`               | managed-settings.json で設定された場合、ユーザーが構成できる MCP サーバーのホワイトリスト。未定義 = 制限なし、空配列 = ロックダウン。すべてのスコープに適用されます。拒否リストが優先されます。[Managed MCP 構成](/ja/mcp#managed-mcp-configuration)を参照してください                              | `[{ "serverName": "github" }]`                                          |
| `deniedMcpServers`                | managed-settings.json で設定された場合、明示的にブロックされた MCP サーバーの拒否リスト。managed サーバーを含むすべてのスコープに適用されます。拒否リストがホワイトリストより優先されます。[Managed MCP 構成](/ja/mcp#managed-mcp-configuration)を参照してください                               | `[{ "serverName": "filesystem" }]`                                      |
| `strictKnownMarketplaces`         | managed-settings.json で設定された場合、ユーザーが追加できるプラグインマーケットプレイスのホワイトリスト。未定義 = 制限なし、空配列 = ロックダウン。マーケットプレイス追加のみに適用されます。[Managed マーケットプレイス制限](/ja/plugin-marketplaces#managed-marketplace-restrictions)を参照してください     | `[{ "source": "github", "repo": "acme-corp/plugins" }]`                 |
| `blockedMarketplaces`             | （Managed 設定のみ）マーケットプレイスソースのブロックリスト。ブロックされたソースはダウンロード前にチェックされるため、ファイルシステムに触れることはありません。[Managed マーケットプレイス制限](/ja/plugin-marketplaces#managed-marketplace-restrictions)を参照してください                             | `[{ "source": "github", "repo": "untrusted/plugins" }]`                 |
| `awsAuthRefresh`                  | `.aws` ディレクトリを変更するカスタムスクリプト（[高度な認証情報構成](/ja/amazon-bedrock#advanced-credential-configuration)を参照）                                                                                                         | `aws sso login --profile myprofile`                                     |
| `awsCredentialExport`             | AWS 認証情報を含む JSON を出力するカスタムスクリプト（[高度な認証情報構成](/ja/amazon-bedrock#advanced-credential-configuration)を参照）                                                                                                     | `/bin/generate_aws_grant.sh`                                            |
| `alwaysThinkingEnabled`           | すべてのセッションに対して[拡張思考](/ja/common-workflows#use-extended-thinking-thinking-mode)をデフォルトで有効にします。通常は直接編集するのではなく `/config` コマンドを通じて構成されます                                                                        | `true`                                                                  |
| `plansDirectory`                  | プランファイルが保存される場所をカスタマイズします。パスはプロジェクトルートに相対的です。デフォルト：`~/.claude/plans`                                                                                                                                      | `"./plans"`                                                             |
| `showTurnDuration`                | ターン期間メッセージを応答後に表示します（例：「Cooked for 1m 6s」）。`false` に設定するとこれらのメッセージを非表示にします                                                                                                                                | `true`                                                                  |
| `spinnerVerbs`                    | スピナーおよびターン期間メッセージに表示されるアクション動詞をカスタマイズします。`mode` を `"replace"` に設定して動詞のみを使用するか、`"append"` に設定してデフォルトに追加します                                                                                                 | `{"mode": "append", "verbs": ["Pondering", "Crafting"]}`                |
| `language`                        | Claude の優先応答言語を構成します（例：`"japanese"`、`"spanish"`、`"french"`）。Claude はデフォルトでこの言語で応答します                                                                                                                      | `"japanese"`                                                            |
| `autoUpdatesChannel`              | 更新に従うリリースチャネル。通常約 1 週間古いバージョンでメジャーリグレッションのあるバージョンをスキップする `"stable"` を使用するか、最新リリースの `"latest"`（デフォルト）を使用します                                                                                                | `"stable"`                                                              |
| `spinnerTipsEnabled`              | Claude が作業中にスピナーにヒントを表示します。ヒントを無効にするには `false` に設定します（デフォルト：`true`）                                                                                                                                       | `false`                                                                 |
| `spinnerTipsOverride`             | スピナーヒントをカスタム文字列でオーバーライドします。`tips`：ヒント文字列の配列。`excludeDefault`：`true` の場合、カスタムヒントのみを表示します。`false` または不在の場合、カスタムヒントは組み込みヒントとマージされます                                                                          | `{ "excludeDefault": true, "tips": ["Use our internal tool X"] }`       |
| `terminalProgressBarEnabled`      | Windows Terminal および iTerm2 などのサポートされているターミナルで進捗を表示するターミナル進捗バーを有効にします（デフォルト：`true`）                                                                                                                       | `false`                                                                 |
| `prefersReducedMotion`            | アクセシビリティのために UI アニメーション（スピナー、シマー、フラッシュエフェクト）を削減または無効にします                                                                                                                                                  | `true`                                                                  |
| `fastModePerSessionOptIn`         | `true` の場合、高速モードはセッション全体で永続化されません。各セッションは高速モードがオフで開始され、ユーザーが `/fast` で有効にする必要があります。ユーザーの高速モード設定は保存されます。[セッションごとのオプトインを要求](/ja/fast-mode#require-per-session-opt-in)を参照してください                              | `true`                                                                  |
| `teammateMode`                    | [エージェントチーム](/ja/agent-teams)チームメイトの表示方法：`auto`（tmux または iTerm2 で分割ペインを選択、それ以外の場合はインプロセス）、`in-process`、または `tmux`。[エージェントチームをセットアップ](/ja/agent-teams#set-up-agent-teams)を参照してください                          | `"in-process"`                                                          |

### 権限設定

| キー                             | 説明                                                                                                                                                                          | 例                                                                      |
| :----------------------------- | :-------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :--------------------------------------------------------------------- |
| `allow`                        | ツール使用を許可する権限ルールの配列。パターンマッチングの詳細については以下の[権限ルール構文](#permission-rule-syntax)を参照してください                                                                                          | `[ "Bash(git diff *)" ]`                                               |
| `ask`                          | ツール使用時に確認を求める権限ルールの配列。パターンマッチングの詳細については以下の[権限ルール構文](#permission-rule-syntax)を参照してください                                                                                       | `[ "Bash(git push *)" ]`                                               |
| `deny`                         | ツール使用を拒否する権限ルールの配列。Claude Code アクセスから機密ファイルを除外するために使用します。[権限ルール構文](#permission-rule-syntax)および [Bash 権限制限](/ja/permissions#tool-specific-permission-rules)を参照してください         | `[ "WebFetch", "Bash(curl *)", "Read(./.env)", "Read(./secrets/**)" ]` |
| `additionalDirectories`        | Claude がアクセスできる追加の[作業ディレクトリ](/ja/permissions#working-directories)                                                                                                           | `[ "../docs/" ]`                                                       |
| `defaultMode`                  | Claude Code を開く際のデフォルト[権限モード](/ja/permissions#permission-modes)                                                                                                             | `"acceptEdits"`                                                        |
| `disableBypassPermissionsMode` | `bypassPermissions` モードの有効化を防ぐために `"disable"` に設定します。これにより `--dangerously-skip-permissions` コマンドラインフラグが無効になります。[managed 設定](/ja/permissions#managed-only-settings)を参照してください | `"disable"`                                                            |

### 権限ルール構文

権限ルールは `Tool` または `Tool(specifier)` の形式に従います。ルールは順序で評価されます：最初に拒否ルール、次に ask、次に allow。最初に一致するルールが優先されます。

クイック例：

| ルール                            | 効果                         |
| :----------------------------- | :------------------------- |
| `Bash`                         | すべての Bash コマンドに一致          |
| `Bash(npm run *)`              | `npm run` で始まるコマンドに一致      |
| `Read(./.env)`                 | `.env` ファイルの読み取りに一致        |
| `WebFetch(domain:example.com)` | example.com へのフェッチリクエストに一致 |

ワイルドカード動作、Read、Edit、WebFetch、MCP、および Agent ルールのツール固有パターン、および Bash パターンのセキュリティ制限を含む完全なルール構文リファレンスについては、[権限ルール構文](/ja/permissions#permission-rule-syntax)を参照してください。

### サンドボックス設定

高度なサンドボックス動作を構成します。サンドボックスは bash コマンドをファイルシステムとネットワークから分離します。詳細については [Sandboxing](/ja/sandboxing)を参照してください。

| キー                                | 説明                                                                                                                                                                                                                                 | 例                               |
| :-------------------------------- | :--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :------------------------------ |
| `enabled`                         | bash サンドボックスを有効にします（macOS、Linux、WSL2）。デフォルト：false                                                                                                                                                                                  | `true`                          |
| `autoAllowBashIfSandboxed`        | サンドボックス化されている場合、bash コマンドを自動承認します。デフォルト：true                                                                                                                                                                                       | `true`                          |
| `excludedCommands`                | サンドボックスの外で実行する必要があるコマンド                                                                                                                                                                                                            | `["git", "docker"]`             |
| `allowUnsandboxedCommands`        | `dangerouslyDisableSandbox` パラメーターを通じてコマンドをサンドボックスの外で実行することを許可します。`false` に設定すると、`dangerouslyDisableSandbox` エスケープハッチは完全に無効になり、すべてのコマンドはサンドボックス化されるか `excludedCommands` に含まれる必要があります。厳密なサンドボックスを必要とするエンタープライズポリシーに役立ちます。デフォルト：true | `false`                         |
| `filesystem.allowWrite`           | サンドボックス化されたコマンドが書き込みできる追加パス。配列はすべての設定スコープ全体でマージされます：ユーザー、プロジェクト、および managed パスが結合され、置き換えられません。`Edit(...)` allow 権限ルールからのパスともマージされます。[パスプレフィックス](#sandbox-path-prefixes)を参照してください。                                                  | `["//tmp/build", "~/.kube"]`    |
| `filesystem.denyWrite`            | サンドボックス化されたコマンドが書き込みできないパス。配列はすべての設定スコープ全体でマージされます。`Edit(...)` deny 権限ルールからのパスともマージされます。                                                                                                                                           | `["//etc", "//usr/local/bin"]`  |
| `filesystem.denyRead`             | サンドボックス化されたコマンドが読み取りできないパス。配列はすべての設定スコープ全体でマージされます。`Read(...)` deny 権限ルールからのパスともマージされます。                                                                                                                                           | `["~/.aws/credentials"]`        |
| `network.allowUnixSockets`        | サンドボックスでアクセス可能な Unix ソケットパス（SSH エージェントなど）                                                                                                                                                                                          | `["~/.ssh/agent-socket"]`       |
| `network.allowAllUnixSockets`     | サンドボックス内のすべての Unix ソケット接続を許可します。デフォルト：false                                                                                                                                                                                        | `true`                          |
| `network.allowLocalBinding`       | localhost ポートへのバインドを許可します（macOS のみ）。デフォルト：false                                                                                                                                                                                    | `true`                          |
| `network.allowedDomains`          | アウトバウンドネットワークトラフィックを許可するドメインの配列。ワイルドカード（例：`*.example.com`）をサポートします。                                                                                                                                                                | `["github.com", "*.npmjs.org"]` |
| `network.allowManagedDomainsOnly` | （Managed 設定のみ）managed 設定からの `allowedDomains` および `WebFetch(domain:...)` allow ルールのみが尊重されます。ユーザー、プロジェクト、およびローカル設定からのドメインは無視されます。許可されていないドメインはユーザーにプロンプトを表示せずに自動的にブロックされます。拒否されたドメインはすべてのソースから尊重されます。デフォルト：false                     | `true`                          |
| `network.httpProxyPort`           | 独自のプロキシを持ち込む場合に使用される HTTP プロキシポート。指定されない場合、Claude は独自のプロキシを実行します。                                                                                                                                                                  | `8080`                          |
| `network.socksProxyPort`          | 独自のプロキシを持ち込む場合に使用される SOCKS5 プロキシポート。指定されない場合、Claude は独自のプロキシを実行します。                                                                                                                                                                | `8081`                          |
| `enableWeakerNestedSandbox`       | 非特権 Docker 環境用の弱いサンドボックスを有効にします（Linux および WSL2 のみ）。**セキュリティが低下します。** デフォルト：false                                                                                                                                                   | `true`                          |

#### サンドボックスパスプレフィックス

`filesystem.allowWrite`、`filesystem.denyWrite`、および `filesystem.denyRead` のパスはこれらのプレフィックスをサポートしています：

| プレフィックス           | 意味                    | 例                                      |
| :---------------- | :-------------------- | :------------------------------------- |
| `//`              | ファイルシステムルートからの絶対パス    | `//tmp/build` は `/tmp/build` になります     |
| `~/`              | ホームディレクトリに相対的         | `~/.kube` は `$HOME/.kube` になります        |
| `/`               | 設定ファイルのディレクトリに相対的     | `/build` は `$SETTINGS_DIR/build` になります |
| `./` またはプレフィックスなし | 相対パス（サンドボックスランタイムで解決） | `./output`                             |

**構成例：**

```json  theme={null}
{
  "sandbox": {
    "enabled": true,
    "autoAllowBashIfSandboxed": true,
    "excludedCommands": ["docker"],
    "filesystem": {
      "allowWrite": ["//tmp/build", "~/.kube"],
      "denyRead": ["~/.aws/credentials"]
    },
    "network": {
      "allowedDomains": ["github.com", "*.npmjs.org", "registry.yarnpkg.com"],
      "allowUnixSockets": [
        "/var/run/docker.sock"
      ],
      "allowLocalBinding": true
    }
  }
}
```

**ファイルシステムおよびネットワーク制限**は、マージされる 2 つの方法で構成できます：

* **`sandbox.filesystem` 設定**（上記）：OS レベルのサンドボックス境界でパスを制御します。これらの制限は、Claude のファイルツールだけでなく、すべてのサブプロセスコマンド（例：`kubectl`、`terraform`、`npm`）に適用されます。
* **権限ルール**：`Edit` allow/deny ルールを使用して Claude のファイルツールアクセスを制御し、`Read` deny ルールを使用して読み取りをブロックし、`WebFetch` allow/deny ルールを使用してネットワークドメインを制御します。これらのルールからのパスもサンドボックス構成にマージされます。

### 属性設定

Claude Code は git コミットおよびプルリクエストに属性を追加します。これらは別々に構成されます：

* コミットはデフォルトで[git trailers](https://git-scm.com/docs/git-interpret-trailers)（`Co-Authored-By` など）を使用し、カスタマイズまたは無効にできます
* プルリクエストの説明はプレーンテキストです

| キー       | 説明                                                 |
| :------- | :------------------------------------------------- |
| `commit` | git コミットの属性（任意の trailers を含む）。空の文字列はコミット属性を非表示にします |
| `pr`     | プルリクエストの説明の属性。空の文字列はプルリクエスト属性を非表示にします              |

**デフォルトコミット属性：**

```text  theme={null}
🤖 Generated with [Claude Code](https://claude.com/claude-code)

   Co-Authored-By: Claude Sonnet 4.6 <noreply@anthropic.com>
```

**デフォルトプルリクエスト属性：**

```text  theme={null}
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
  `attribution` 設定は非推奨の `includeCoAuthoredBy` 設定より優先されます。すべての属性を非表示にするには、`commit` および `pr` を空の文字列に設定します。
</Note>

### ファイル提案設定

`@` ファイルパスオートコンプリート用のカスタムコマンドを構成します。組み込みファイル提案は高速ファイルシステムトラバーサルを使用しますが、大規模なモノレポは事前構築されたファイルインデックスやカスタムツールなどのプロジェクト固有のインデックスから利益を得る可能性があります。

```json  theme={null}
{
  "fileSuggestion": {
    "type": "command",
    "command": "~/.claude/file-suggestion.sh"
  }
}
```

コマンドは [hooks](/ja/hooks)と同じ環境変数で実行され、`CLAUDE_PROJECT_DIR` を含みます。stdin 経由で `query` フィールドを含む JSON を受け取ります：

```json  theme={null}
{"query": "src/comp"}
```

stdout にニュー行で区切られたファイルパスを出力します（現在 15 に制限）：

```text  theme={null}
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

これらの設定は、実行が許可される hooks と HTTP hooks がアクセスできるものを制御します。`allowManagedHooksOnly` 設定は [managed 設定](#settings-files)でのみ構成できます。URL および環境変数ホワイトリストは任意の設定レベルで設定でき、ソース全体でマージされます。

**`allowManagedHooksOnly` が `true` の場合の動作：**

* Managed hooks および SDK hooks が読み込まれます
* ユーザー hooks、プロジェクト hooks、およびプラグイン hooks はブロックされます

**HTTP hook URL を制限：**

HTTP hooks がターゲットにできる URL を制限します。マッチングのワイルドカードとして `*` をサポートします。配列が定義されている場合、一致しない URL をターゲットにする HTTP hooks はサイレントにブロックされます。

```json  theme={null}
{
  "allowedHttpHookUrls": ["https://hooks.example.com/*", "http://localhost:*"]
}
```

**HTTP hook 環境変数を制限：**

HTTP hooks がヘッダー値に補間できる環境変数名を制限します。各 hook の有効な `allowedEnvVars` は、独自のリストとこの設定の交差です。

```json  theme={null}
{
  "httpHookAllowedEnvVars": ["MY_TOKEN", "HOOK_SECRET"]
}
```

### 設定優先度

設定は優先度の順に適用されます。最高から最低：

1. **Managed 設定**（[サーバー管理](/ja/server-managed-settings)、[MDM/OS レベルのポリシー](#configuration-scopes)、または [managed 設定](/ja/settings#settings-files)）
   * IT がサーバー配信、MDM 構成プロファイル、レジストリポリシー、または managed 設定ファイルを通じてデプロイしたポリシー
   * ユーザーまたはプロジェクト設定によってオーバーライドできません
   * managed ティア内では、優先度は：サーバー管理 > MDM/OS レベルのポリシー > `managed-settings.json` > HKCU レジストリ（Windows のみ）。1 つの managed ソースのみが使用されます。ソースはマージされません。

2. **コマンドライン引数**
   * 特定のセッションの一時的なオーバーライド

3. **ローカルプロジェクト設定**（`.claude/settings.local.json`）
   * 個人的なプロジェクト固有の設定

4. **共有プロジェクト設定**（`.claude/settings.json`）
   * ソース管理のチーム共有プロジェクト設定

5. **ユーザー設定**（`~/.claude/settings.json`）
   * 個人的なグローバル設定

この階層は、組織のポリシーが常に実施されることを保証しながら、チームと個人がエクスペリエンスをカスタマイズできるようにします。

たとえば、ユーザー設定が `Bash(npm run *)` を許可しているが、プロジェクトの共有設定がそれを拒否している場合、プロジェクト設定が優先され、コマンドはブロックされます。

<Note>
  **配列設定はスコープ全体でマージされます。** 同じ配列値設定（`sandbox.filesystem.allowWrite` または `permissions.allow` など）が複数のスコープに表示される場合、配列は**連結および重複排除**され、置き換えられません。これは、低優先度のスコープが高優先度のスコープで設定されたエントリをオーバーライドすることなくエントリを追加でき、その逆も同様です。たとえば、managed 設定が `allowWrite` を `["//opt/company-tools"]` に設定し、ユーザーが `["~/.kube"]` を追加する場合、両方のパスが最終構成に含まれます。
</Note>

### アクティブな設定を確認

Claude Code 内で `/status` を実行して、どの設定ソースがアクティブで、どこから来ているかを確認します。出力は、`Enterprise managed settings (remote)`、`Enterprise managed settings (plist)`、`Enterprise managed settings (HKLM)`、または `Enterprise managed settings (file)` などの起源を含む各構成レイヤー（managed、ユーザー、プロジェクト）を表示します。設定ファイルにエラーが含まれている場合、`/status` は問題を報告して修正できるようにします。

### 構成システムに関する重要なポイント

* **メモリファイル（`CLAUDE.md`）**：Claude が起動時に読み込む指示とコンテキストを含みます
* **設定ファイル（JSON）**：権限、環境変数、およびツール動作を構成します
* **Skills**：`/skill-name` で呼び出すか、Claude によって自動的に読み込むことができるカスタムプロンプト
* **MCP サーバー**：追加のツールと統合で Claude Code を拡張します
* **優先度**：高レベルの構成（Managed）が低レベルの構成（User/Project）をオーバーライドします
* **継承**：設定はマージされ、より具体的な設定がより広い設定に追加またはオーバーライドされます

### システムプロンプト

Claude Code の内部システムプロンプトは公開されていません。カスタム指示を追加するには、`CLAUDE.md` ファイルまたは `--append-system-prompt` フラグを使用します。

### 機密ファイルを除外

API キー、シークレット、環境ファイルなどの機密情報を含むファイルへの Claude Code アクセスを防ぐには、`.claude/settings.json` ファイルの `permissions.deny` 設定を使用します：

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

これは非推奨の `ignorePatterns` 構成に置き換わります。これらのパターンに一致するファイルはファイル検出と検索結果から除外され、これらのファイルの読み取り操作は拒否されます。

## Subagent 構成

Claude Code は、ユーザーおよびプロジェクトレベルで構成できるカスタム AI subagents をサポートしています。これらの subagents は YAML frontmatter を含む Markdown ファイルとして保存されます：

* **ユーザー subagents**：`~/.claude/agents/` - すべてのプロジェクト全体で利用可能
* **プロジェクト subagents**：`.claude/agents/` - プロジェクト固有で、チームと共有できます

Subagent ファイルは、カスタムプロンプトとツール権限を持つ特化した AI アシスタントを定義します。subagents の作成と使用の詳細については、[subagents ドキュメント](/ja/sub-agents)を参照してください。

## プラグイン構成

Claude Code は、skills、agents、hooks、および MCP サーバーで機能を拡張できるプラグインシステムをサポートしています。プラグインはマーケットプレイスを通じて配布され、ユーザーおよびリポジトリレベルで構成できます。

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
* **ローカル設定**（`.claude/settings.local.json`）：マシンごとのオーバーライド（コミットされません）

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

リポジトリで利用可能にする必要がある追加マーケットプレイスを定義します。通常、チームメンバーが必要なプラグインソースにアクセスできるようにするためにリポジトリレベルの設定で使用されます。

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
* `directory`：ローカルファイルシステムパス（開発のみ、`path` を使用）
* `hostPattern`：マーケットプレイスホストに一致する正規表現パターン（`hostPattern` を使用）

#### `strictKnownMarketplaces`

**Managed 設定のみ**：ユーザーが追加できるプラグインマーケットプレイスを制御します。この設定は [managed 設定](/ja/settings#settings-files)でのみ構成でき、管理者にマーケットプレイスソースに対する厳密な制御を提供します。

**Managed 設定ファイルの場所**：

* **macOS**：`/Library/Application Support/ClaudeCode/managed-settings.json`
* **Linux および WSL**：`/etc/claude-code/managed-settings.json`
* **Windows**：`C:\Program Files\ClaudeCode\managed-settings.json`

**主な特性**：

* managed 設定（`managed-settings.json`）でのみ利用可能
* ユーザーまたはプロジェクト設定によってオーバーライドできません（最高優先度）
* ネットワーク/ファイルシステム操作の前に実施されます（ブロックされたソースは実行されません）
* `hostPattern` を除き、ソース仕様に対して完全一致を使用します。`hostPattern` は正規表現マッチングを使用します

**ホワイトリスト動作**：

* `undefined`（デフォルト）：制限なし - ユーザーは任意のマーケットプレイスを追加できます
* 空配列 `[]`：完全ロックダウン - ユーザーは新しいマーケットプレイスを追加できません
* ソースのリスト：ユーザーは正確に一致するマーケットプレイスのみを追加できます

**サポートされているすべてのソースタイプ**：

ホワイトリストは 7 つのマーケットプレイスソースタイプをサポートしています。ほとんどのソースは完全一致を使用しますが、`hostPattern` はマーケットプレイスホストに対して正規表現マッチングを使用します。

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
  URL ベースのマーケットプレイスは `marketplace.json` ファイルのみをダウンロードします。サーバーからプラグインファイルをダウンロードしません。URL ベースのマーケットプレイスのプラグインは、相対パスではなく外部ソース（GitHub、npm、または git URL）を使用する必要があります。相対パスを持つプラグインの場合は、代わりに Git ベースのマーケットプレイスを使用してください。[トラブルシューティング](/ja/plugin-marketplaces#plugins-with-relative-paths-fail-in-url-based-marketplaces)の詳細を参照してください。
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

各リポジトリを列挙することなく、特定のホストからすべてのマーケットプレイスを許可する場合はホストパターンマッチングを使用します。これは、開発者が独自のマーケットプレイスを作成する内部 GitHub Enterprise または GitLab サーバーを持つ組織に役立ちます。

ソースタイプ別のホスト抽出：

* `github`：常に `github.com` に対してマッチ
* `git`：URL からホスト名を抽出（HTTPS および SSH 形式をサポート）
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

例：内部 git サーバーからすべてのマーケットプレイスを許可：

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

マーケットプレイスソースはユーザーの追加を許可するために**正確に**一致する必要があります。git ベースのソース（`github` および `git`）の場合、これはすべてのオプションフィールドを含みます：

* `repo` または `url` は正確に一致する必要があります
* `ref` フィールドは正確に一致する必要があります（または両方が未定義）
* `path` フィールドは正確に一致する必要があります（または両方が未定義）

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

| 側面            | `strictKnownMarketplaces`  | `extraKnownMarketplaces`  |
| ------------- | -------------------------- | ------------------------- |
| **目的**        | 組織ポリシー実施                   | チーム利便性                    |
| **設定ファイル**    | `managed-settings.json` のみ | 任意の設定ファイル                 |
| **動作**        | 許可されていない追加をブロック            | 不足しているマーケットプレイスを自動インストール  |
| **実施時期**      | ネットワーク/ファイルシステム操作の前        | ユーザー信頼プロンプト後              |
| **オーバーライド可能** | いいえ（最高優先度）                 | はい（高優先度設定による）             |
| **ソース形式**     | 直接ソースオブジェクト                | ネストされたソースを持つ名前付きマーケットプレイス |
| **ユースケース**    | コンプライアンス、セキュリティ制限          | オンボーディング、標準化              |

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

**重要な注意**：

* 制限はネットワークリクエストまたはファイルシステム操作の前にチェックされます
* ブロックされた場合、ユーザーはソースが managed ポリシーによってブロックされていることを示す明確なエラーメッセージを表示します
* 制限は新しいマーケットプレイスの追加にのみ適用されます。以前にインストールされたマーケットプレイスはアクセス可能なままです
* Managed 設定は最高優先度を持ち、オーバーライドできません

ユーザー向けドキュメントについては、[Managed マーケットプレイス制限](/ja/plugin-marketplaces#managed-marketplace-restrictions)を参照してください。

### プラグインを管理

`/plugin` コマンドを使用してプラグインを対話的に管理します：

* マーケットプレイスから利用可能なプラグインを参照
* プラグインをインストール/アンインストール
* プラグインを有効/無効にする
* プラグインの詳細を表示（提供されるコマンド、エージェント、hooks）
* マーケットプレイスを追加/削除

プラグインシステムの詳細については、[プラグインドキュメント](/ja/plugins)を参照してください。

## 環境変数

Claude Code は、その動作を制御するために以下の環境変数をサポートしています：

<Note>
  すべての環境変数は [`settings.json`](#available-settings) でも構成できます。これは、各セッションの環境変数を自動的に設定するか、チーム全体または組織全体の環境変数セットをロールアウトする方法として役立ちます。
</Note>

| 変数                                             | 目的                                                                                                                                                                                                                                                                                                                                     |     |
| :--------------------------------------------- | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --- |
| `ANTHROPIC_API_KEY`                            | `X-Api-Key` ヘッダーとして送信される API キー。通常は Claude SDK 用（インタラクティブ使用の場合は `/login` を実行）                                                                                                                                                                                                                                                          |     |
| `ANTHROPIC_AUTH_TOKEN`                         | `Authorization` ヘッダーのカスタム値（ここで設定した値には `Bearer ` が付加されます）                                                                                                                                                                                                                                                                               |     |
| `ANTHROPIC_CUSTOM_HEADERS`                     | リクエストに追加するカスタムヘッダー（`Name: Value` 形式、複数ヘッダーの場合はニュー行で区切られます）                                                                                                                                                                                                                                                                             |     |
| `ANTHROPIC_DEFAULT_HAIKU_MODEL`                | [モデル構成](/ja/model-config#environment-variables)を参照                                                                                                                                                                                                                                                                                     |     |
| `ANTHROPIC_DEFAULT_OPUS_MODEL`                 | [モデル構成](/ja/model-config#environment-variables)を参照                                                                                                                                                                                                                                                                                     |     |
| `ANTHROPIC_DEFAULT_SONNET_MODEL`               | [モデル構成](/ja/model-config#environment-variables)を参照                                                                                                                                                                                                                                                                                     |     |
| `ANTHROPIC_FOUNDRY_API_KEY`                    | Microsoft Foundry 認証用の API キー（[Microsoft Foundry](/ja/microsoft-foundry)を参照）                                                                                                                                                                                                                                                           |     |
| `ANTHROPIC_FOUNDRY_BASE_URL`                   | Foundry リソースの完全なベース URL（例：`https://my-resource.services.ai.azure.com/anthropic`）。`ANTHROPIC_FOUNDRY_RESOURCE` の代替（[Microsoft Foundry](/ja/microsoft-foundry)を参照）                                                                                                                                                                       |     |
| `ANTHROPIC_FOUNDRY_RESOURCE`                   | Foundry リソース名（例：`my-resource`）。`ANTHROPIC_FOUNDRY_BASE_URL` が設定されていない場合は必須（[Microsoft Foundry](/ja/microsoft-foundry)を参照）                                                                                                                                                                                                              |     |
| `ANTHROPIC_MODEL`                              | 使用するモデル設定の名前（[モデル構成](/ja/model-config#environment-variables)を参照）                                                                                                                                                                                                                                                                       |     |
| `ANTHROPIC_SMALL_FAST_MODEL`                   | \[非推奨] バックグラウンドタスク用の [Haiku クラスモデル](/ja/costs)の名前                                                                                                                                                                                                                                                                                      |     |
| `ANTHROPIC_SMALL_FAST_MODEL_AWS_REGION`        | Bedrock を使用する場合、Haiku クラスモデルの AWS リージョンをオーバーライド                                                                                                                                                                                                                                                                                        |     |
| `AWS_BEARER_TOKEN_BEDROCK`                     | Bedrock 認証用の API キー（[Bedrock API キー](https://aws.amazon.com/blogs/machine-learning/accelerate-ai-development-with-amazon-bedrock-api-keys/)を参照）                                                                                                                                                                                        |     |
| `BASH_DEFAULT_TIMEOUT_MS`                      | 長時間実行される bash コマンドのデフォルトタイムアウト                                                                                                                                                                                                                                                                                                         |     |
| `BASH_MAX_OUTPUT_LENGTH`                       | 中央で切り詰められる前の bash 出力の最大文字数                                                                                                                                                                                                                                                                                                             |     |
| `BASH_MAX_TIMEOUT_MS`                          | モデルが長時間実行される bash コマンドに設定できる最大タイムアウト                                                                                                                                                                                                                                                                                                   |     |
| `CLAUDE_AUTOCOMPACT_PCT_OVERRIDE`              | オートコンパクションがトリガーされるコンテキスト容量のパーセンテージ（1～100）を設定します。デフォルトでは、オートコンパクションは約 95% 容量でトリガーされます。`50` などの低い値を使用して早期にコンパクトします。デフォルト閾値より上の値は効果がありません。メイン会話と subagents の両方に適用されます。このパーセンテージは [status line](/ja/statusline) で利用可能な `context_window.used_percentage` フィールドと一致します                                                                        |     |
| `CLAUDE_BASH_MAINTAIN_PROJECT_WORKING_DIR`     | 各 Bash コマンド後に元の作業ディレクトリに戻ります                                                                                                                                                                                                                                                                                                           |     |
| `CLAUDE_CODE_ACCOUNT_UUID`                     | 認証されたユーザーのアカウント UUID。SDK 呼び出し元が同期的にアカウント情報を提供するために使用され、初期テレメトリイベントがアカウントメタデータを欠く競合状態を回避します。`CLAUDE_CODE_USER_EMAIL` および `CLAUDE_CODE_ORGANIZATION_UUID` も設定する必要があります                                                                                                                                                                   |     |
| `CLAUDE_CODE_ADDITIONAL_DIRECTORIES_CLAUDE_MD` | `--add-dir` で指定されたディレクトリから CLAUDE.md ファイルを読み込むには `1` に設定します。デフォルトでは、追加ディレクトリはメモリファイルを読み込みません                                                                                                                                                                                                                                           | `1` |
| `CLAUDE_CODE_API_KEY_HELPER_TTL_MS`            | 認証情報をリフレッシュする間隔（ミリ秒）（`apiKeyHelper` を使用する場合）                                                                                                                                                                                                                                                                                           |     |
| `CLAUDE_CODE_CLIENT_CERT`                      | mTLS 認証用のクライアント証明書ファイルへのパス                                                                                                                                                                                                                                                                                                             |     |
| `CLAUDE_CODE_CLIENT_KEY`                       | mTLS 認証用のクライアント秘密鍵ファイルへのパス                                                                                                                                                                                                                                                                                                             |     |
| `CLAUDE_CODE_CLIENT_KEY_PASSPHRASE`            | 暗号化された CLAUDE\_CODE\_CLIENT\_KEY のパスフレーズ（オプション）                                                                                                                                                                                                                                                                                        |     |
| `CLAUDE_CODE_DISABLE_1M_CONTEXT`               | [1M コンテキストウィンドウ](/ja/model-config#extended-context)サポートを無効にするには `1` に設定します。設定すると、1M モデルバリアントはモデルピッカーで利用できません。コンプライアンス要件を持つエンタープライズ環境に役立ちます                                                                                                                                                                                             |     |
| `CLAUDE_CODE_DISABLE_ADAPTIVE_THINKING`        | Opus 4.6 および Sonnet 4.6 の[適応推論](/ja/model-config#adjust-effort-level)を無効にするには `1` に設定します。無効にすると、これらのモデルは `MAX_THINKING_TOKENS` で制御される固定思考予算にフォールバックします                                                                                                                                                                                 |     |
| `CLAUDE_CODE_DISABLE_AUTO_MEMORY`              | [自動メモリ](/ja/memory#auto-memory)を無効にするには `1` に設定します。段階的ロールアウト中に自動メモリを強制的にオンにするには `0` に設定します。無効にすると、Claude は自動メモリファイルを作成または読み込みません                                                                                                                                                                                                       |     |
| `CLAUDE_CODE_DISABLE_BACKGROUND_TASKS`         | Bash および subagent ツールの `run_in_background` パラメーター、自動バックグラウンド化、Ctrl+B ショートカットを含むすべてのバックグラウンドタスク機能を無効にするには `1` に設定します                                                                                                                                                                                                                    |     |
| `CLAUDE_CODE_DISABLE_EXPERIMENTAL_BETAS`       | Anthropic API 固有の `anthropic-beta` ヘッダーを無効にするには `1` に設定します。サードパーティプロバイダーを持つ LLM ゲートウェイを使用する場合に「Unexpected value(s) for the `anthropic-beta` header」などの問題が発生している場合に使用します                                                                                                                                                                |     |
| `CLAUDE_CODE_DISABLE_FAST_MODE`                | [高速モード](/ja/fast-mode)を無効にするには `1` に設定します                                                                                                                                                                                                                                                                                              |     |
| `CLAUDE_CODE_DISABLE_FEEDBACK_SURVEY`          | 「Claude はどのように機能していますか？」セッション品質調査を無効にするには `1` に設定します。サードパーティプロバイダーを使用する場合またはテレメトリが無効な場合にも無効になります。[セッション品質調査](/ja/data-usage#session-quality-surveys)を参照してください                                                                                                                                                                          |     |
| `CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC`     | `DISABLE_AUTOUPDATER`、`DISABLE_BUG_COMMAND`、`DISABLE_ERROR_REPORTING`、および `DISABLE_TELEMETRY` を設定するのと同等                                                                                                                                                                                                                                |     |
| `CLAUDE_CODE_DISABLE_TERMINAL_TITLE`           | 会話コンテキストに基づいて自動ターミナルタイトル更新を無効にするには `1` に設定します                                                                                                                                                                                                                                                                                          |     |
| `CLAUDE_CODE_EFFORT_LEVEL`                     | サポートされているモデルの努力レベルを設定します。値：`low`、`medium`、`high`。低い努力はより高速で安価、高い努力はより深い推論を提供します。Opus 4.6 および Sonnet 4.6 でサポートされています。[努力レベルを調整](/ja/model-config#adjust-effort-level)を参照してください                                                                                                                                                          |     |
| `CLAUDE_CODE_ENABLE_PROMPT_SUGGESTION`         | プロンプト提案を無効にするには `false` に設定します（`/config` の「Prompt suggestions」トグル）。これらは Claude が応答した後、プロンプト入力に表示される灰色の予測です。[プロンプト提案](/ja/interactive-mode#prompt-suggestions)を参照してください                                                                                                                                                                 |     |
| `CLAUDE_CODE_ENABLE_TASKS`                     | 以前の TODO リストに一時的に戻すには `false` に設定します。デフォルト：`true`。[タスクリスト](/ja/interactive-mode#task-list)を参照してください                                                                                                                                                                                                                                    |     |
| `CLAUDE_CODE_ENABLE_TELEMETRY`                 | メトリクスとログの OpenTelemetry データ収集を有効にするには `1` に設定します。OTel エクスポーターを構成する前に必須です。[監視](/ja/monitoring-usage)を参照してください                                                                                                                                                                                                                           |     |
| `CLAUDE_CODE_EXIT_AFTER_STOP_DELAY`            | クエリループがアイドル状態になった後、自動的に終了するまで待機する時間（ミリ秒）。SDK モードを使用する自動化されたワークフローとスクリプトに役立ちます                                                                                                                                                                                                                                                          |     |
| `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS`         | [エージェントチーム](/ja/agent-teams)を有効にするには `1` に設定します。エージェントチームは実験的で、デフォルトで無効です                                                                                                                                                                                                                                                              |     |
| `CLAUDE_CODE_FILE_READ_MAX_OUTPUT_TOKENS`      | ファイル読み取りのデフォルトトークン制限をオーバーライドします。より大きなファイルを完全に読み取る必要がある場合に役立ちます                                                                                                                                                                                                                                                                         |     |
| `CLAUDE_CODE_HIDE_ACCOUNT_INFO`                | Claude Code UI からメールアドレスと組織名を非表示にするには `1` に設定します。ストリーミングまたは記録時に役立ちます                                                                                                                                                                                                                                                                   |     |
| `CLAUDE_CODE_IDE_SKIP_AUTO_INSTALL`            | IDE 拡張機能の自動インストールをスキップ                                                                                                                                                                                                                                                                                                                 |     |
| `CLAUDE_CODE_MAX_OUTPUT_TOKENS`                | ほとんどのリクエストの最大出力トークン数を設定します。デフォルト：32,000。最大：64,000。この値を増やすと、[オートコンパクション](/ja/costs#reduce-token-usage)がトリガーされる前に利用可能な有効コンテキストウィンドウが削減されます。                                                                                                                                                                                              |     |
| `CLAUDE_CODE_ORGANIZATION_UUID`                | 認証されたユーザーの組織 UUID。SDK 呼び出し元が同期的にアカウント情報を提供するために使用されます。`CLAUDE_CODE_ACCOUNT_UUID` および `CLAUDE_CODE_USER_EMAIL` も設定する必要があります                                                                                                                                                                                                             |     |
| `CLAUDE_CODE_OTEL_HEADERS_HELPER_DEBOUNCE_MS`  | 動的 OpenTelemetry ヘッダーをリフレッシュする間隔（ミリ秒）（デフォルト：1740000 / 29 分）。[動的ヘッダー](/ja/monitoring-usage#dynamic-headers)を参照してください                                                                                                                                                                                                                    |     |
| `CLAUDE_CODE_PLAN_MODE_REQUIRED`               | [エージェントチーム](/ja/agent-teams)チームメイトがプラン承認を必要とする場合、自動的に `true` に設定されます。読み取り専用：Claude Code がチームメイトをスポーンするときに設定されます。[チームメイトのプラン承認を要求](/ja/agent-teams#require-plan-approval-for-teammates)を参照してください                                                                                                                                        |     |
| `CLAUDE_CODE_PLUGIN_GIT_TIMEOUT_MS`            | プラグインをインストールまたは更新する際の git 操作のタイムアウト（ミリ秒）（デフォルト：120000）。大規模なリポジトリまたは遅いネットワーク接続の場合、この値を増やします。[Git 操作がタイムアウト](/ja/plugin-marketplaces#git-operations-time-out)を参照してください                                                                                                                                                                   |     |
| `CLAUDE_CODE_PROXY_RESOLVES_HOSTS`             | プロキシが呼び出し元の代わりに DNS 解決を実行できるようにするには `true` に設定します。プロキシがホスト名解決を処理する必要がある環境でオプトイン                                                                                                                                                                                                                                                        |     |
| `CLAUDE_CODE_SHELL`                            | 自動シェル検出をオーバーライドします。ログインシェルが優先作業シェルと異なる場合に役立ちます（例：`bash` vs `zsh`）                                                                                                                                                                                                                                                                      |     |
| `CLAUDE_CODE_SHELL_PREFIX`                     | すべての bash コマンドをラップするコマンドプレフィックス（ロギングまたは監査用など）。例：`/path/to/logger.sh` は `/path/to/logger.sh <command>` を実行します                                                                                                                                                                                                                           |     |
| `CLAUDE_CODE_SIMPLE`                           | 最小限のシステムプロンプトと Bash、ファイル読み取り、ファイル編集ツールのみで実行するには `1` に設定します。MCP ツール、添付ファイル、hooks、および CLAUDE.md ファイルを無効にします                                                                                                                                                                                                                              |     |
| `CLAUDE_CODE_SKIP_BEDROCK_AUTH`                | Bedrock の AWS 認証をスキップします（例：LLM ゲートウェイを使用する場合）                                                                                                                                                                                                                                                                                          |     |
| `CLAUDE_CODE_SKIP_FOUNDRY_AUTH`                | Microsoft Foundry の Azure 認証をスキップします（例：LLM ゲートウェイを使用する場合）                                                                                                                                                                                                                                                                              |     |
| `CLAUDE_CODE_SKIP_VERTEX_AUTH`                 | Vertex の Google 認証をスキップします（例：LLM ゲートウェイを使用する場合）                                                                                                                                                                                                                                                                                        |     |
| `CLAUDE_CODE_SUBAGENT_MODEL`                   | [モデル構成](/ja/model-config)を参照                                                                                                                                                                                                                                                                                                           |     |
| `CLAUDE_CODE_TASK_LIST_ID`                     | セッション全体でタスクリストを共有します。複数の Claude Code インスタンスで同じ ID を設定して、共有タスクリストで調整します。[タスクリスト](/ja/interactive-mode#task-list)を参照してください                                                                                                                                                                                                               |     |
| `CLAUDE_CODE_TEAM_NAME`                        | このチームメイトが属するエージェントチームの名前。[エージェントチーム](/ja/agent-teams)メンバーで自動的に設定されます                                                                                                                                                                                                                                                                   |     |
| `CLAUDE_CODE_TMPDIR`                           | 内部一時ファイルに使用される一時ディレクトリをオーバーライドします。Claude Code はこのパスに `/claude/` を追加します。デフォルト：Unix/macOS では `/tmp`、Windows では `os.tmpdir()`                                                                                                                                                                                                             |     |
| `CLAUDE_CODE_USER_EMAIL`                       | 認証されたユーザーのメールアドレス。SDK 呼び出し元が同期的にアカウント情報を提供するために使用されます。`CLAUDE_CODE_ACCOUNT_UUID` および `CLAUDE_CODE_ORGANIZATION_UUID` も設定する必要があります                                                                                                                                                                                                      |     |
| `CLAUDE_CODE_USE_BEDROCK`                      | [Bedrock](/ja/amazon-bedrock) を使用                                                                                                                                                                                                                                                                                                      |     |
| `CLAUDE_CODE_USE_FOUNDRY`                      | [Microsoft Foundry](/ja/microsoft-foundry) を使用                                                                                                                                                                                                                                                                                         |     |
| `CLAUDE_CODE_USE_VERTEX`                       | [Vertex](/ja/google-vertex-ai) を使用                                                                                                                                                                                                                                                                                                     |     |
| `CLAUDE_CONFIG_DIR`                            | Claude Code が構成とデータファイルを保存する場所をカスタマイズ                                                                                                                                                                                                                                                                                                  |     |
| `DISABLE_AUTOUPDATER`                          | 自動更新を無効にするには `1` に設定します。                                                                                                                                                                                                                                                                                                               |     |
| `DISABLE_BUG_COMMAND`                          | `/bug` コマンドを無効にするには `1` に設定します                                                                                                                                                                                                                                                                                                         |     |
| `DISABLE_COST_WARNINGS`                        | コスト警告メッセージを無効にするには `1` に設定します                                                                                                                                                                                                                                                                                                          |     |
| `DISABLE_ERROR_REPORTING`                      | Sentry エラーレポートをオプトアウトするには `1` に設定します                                                                                                                                                                                                                                                                                                   |     |
| `DISABLE_INSTALLATION_CHECKS`                  | インストール警告を無効にするには `1` に設定します。標準インストールの問題をマスクできるため、インストール場所を手動で管理する場合のみ使用します                                                                                                                                                                                                                                                             |     |
| `DISABLE_NON_ESSENTIAL_MODEL_CALLS`            | フレーバーテキストなどの非重要パスのモデル呼び出しを無効にするには `1` に設定します                                                                                                                                                                                                                                                                                           |     |
| `DISABLE_PROMPT_CACHING`                       | すべてのモデルのプロンプトキャッシングを無効にするには `1` に設定します（モデルごとの設定より優先）                                                                                                                                                                                                                                                                                   |     |
| `DISABLE_PROMPT_CACHING_HAIKU`                 | Haiku モデルのプロンプトキャッシングを無効にするには `1` に設定します                                                                                                                                                                                                                                                                                               |     |
| `DISABLE_PROMPT_CACHING_OPUS`                  | Opus モデルのプロンプトキャッシングを無効にするには `1` に設定します                                                                                                                                                                                                                                                                                                |     |
| `DISABLE_PROMPT_CACHING_SONNET`                | Sonnet モデルのプロンプトキャッシングを無効にするには `1` に設定します                                                                                                                                                                                                                                                                                              |     |
| `DISABLE_TELEMETRY`                            | Statsig テレメトリをオプトアウトするには `1` に設定します（Statsig イベントはコード、ファイルパス、bash コマンドなどのユーザーデータを含まないことに注意）                                                                                                                                                                                                                                             |     |
| `ENABLE_CLAUDEAI_MCP_SERVERS`                  | Claude Code で [claude.ai MCP サーバー](/ja/mcp#use-mcp-servers-from-claudeai)を無効にするには `false` に設定します。ログインしているユーザーに対してデフォルトで有効                                                                                                                                                                                                              |     |
| `ENABLE_TOOL_SEARCH`                           | [MCP ツール検索](/ja/mcp#scale-with-mcp-tool-search)を制御します。値：`auto`（デフォルト、10% コンテキストで有効）、`auto:N`（カスタム閾値、例：5% の場合は `auto:5`）、`true`（常にオン）、`false`（無効）                                                                                                                                                                                       |     |
| `FORCE_AUTOUPDATE_PLUGINS`                     | メイン自動更新プログラムが `DISABLE_AUTOUPDATER` で無効になっている場合でも、プラグイン自動更新を強制するには `true` に設定します                                                                                                                                                                                                                                                       |     |
| `HTTP_PROXY`                                   | ネットワーク接続用の HTTP プロキシサーバーを指定                                                                                                                                                                                                                                                                                                            |     |
| `HTTPS_PROXY`                                  | ネットワーク接続用の HTTPS プロキシサーバーを指定                                                                                                                                                                                                                                                                                                           |     |
| `IS_DEMO`                                      | デモモード：UI からメールと組織を非表示にし、オンボーディングをスキップし、内部コマンドを非表示にするには `true` に設定します。ストリーミングまたは記録セッションに役立ちます                                                                                                                                                                                                                                           |     |
| `MAX_MCP_OUTPUT_TOKENS`                        | MCP ツール応答で許可される最大トークン数。Claude Code は出力が 10,000 トークンを超える場合に警告を表示します（デフォルト：25000）                                                                                                                                                                                                                                                        |     |
| `MAX_THINKING_TOKENS`                          | [拡張思考](https://platform.claude.com/docs/en/build-with-claude/extended-thinking)トークン予算をオーバーライドします。思考はデフォルトで最大予算（31,999 トークン）で有効になります。予算を制限するために使用します（例：`MAX_THINKING_TOKENS=10000`）または思考を完全に無効にします（`MAX_THINKING_TOKENS=0`）。Opus 4.6 の場合、思考の深さは代わりに[努力レベル](/ja/model-config#adjust-effort-level)で制御され、`0` に設定して思考を無効にしない限り、この変数は無視されます。 |     |
| `MCP_CLIENT_SECRET`                            | [事前構成された認証情報](/ja/mcp#use-pre-configured-oauth-credentials)を必要とする MCP サーバーの OAuth クライアントシークレット。サーバーを `--client-secret` で追加する場合、対話的なプロンプトを回避します                                                                                                                                                                                         |     |
| `MCP_OAUTH_CALLBACK_PORT`                      | [事前構成された認証情報](/ja/mcp#use-pre-configured-oauth-credentials)を持つ MCP サーバーを追加する場合、`--callback-port` の代替として OAuth リダイレクトコールバック用の固定ポート                                                                                                                                                                                                      |     |
| `MCP_TIMEOUT`                                  | MCP サーバー起動のタイムアウト（ミリ秒）                                                                                                                                                                                                                                                                                                                 |     |
| `MCP_TOOL_TIMEOUT`                             | MCP ツール実行のタイムアウト（ミリ秒）                                                                                                                                                                                                                                                                                                                  |     |
| `NO_PROXY`                                     | プロキシをバイパスして直接発行されるリクエストのドメインと IP のリスト                                                                                                                                                                                                                                                                                                  |     |
| `SLASH_COMMAND_TOOL_CHAR_BUDGET`               | [Skill ツール](/ja/skills#control-who-invokes-a-skill)に表示される skill メタデータの文字予算をオーバーライドします。予算はコンテキストウィンドウの 2% で動的にスケーリングされ、フォールバックは 16,000 文字です。後方互換性のために古い名前が保持されています                                                                                                                                                                      |     |
| `USE_BUILTIN_RIPGREP`                          | Claude Code に含まれる `rg` の代わりにシステムインストール済みの `rg` を使用するには `0` に設定します                                                                                                                                                                                                                                                                      |     |
| `VERTEX_REGION_CLAUDE_3_5_HAIKU`               | Vertex AI を使用する場合、Claude 3.5 Haiku のリージョンをオーバーライド                                                                                                                                                                                                                                                                                      |     |
| `VERTEX_REGION_CLAUDE_3_7_SONNET`              | Vertex AI を使用する場合、Claude 3.7 Sonnet のリージョンをオーバーライド                                                                                                                                                                                                                                                                                     |     |
| `VERTEX_REGION_CLAUDE_4_0_OPUS`                | Vertex AI を使用する場合、Claude 4.0 Opus のリージョンをオーバーライド                                                                                                                                                                                                                                                                                       |     |
| `VERTEX_REGION_CLAUDE_4_0_SONNET`              | Vertex AI を使用する場合、Claude 4.0 Sonnet のリージョンをオーバーライド                                                                                                                                                                                                                                                                                     |     |
| `VERTEX_REGION_CLAUDE_4_1_OPUS`                | Vertex AI を使用する場合、Claude 4.1 Opus のリージョンをオーバーライド                                                                                                                                                                                                                                                                                       |     |

## Claude が利用可能なツール

Claude Code は、コードベースを理解および変更するのに役立つ強力なツールセットにアクセスできます：

| ツール                 | 説明                                                                                                                                                                                   | 権限が必要 |
| :------------------ | :----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :---- |
| **AskUserQuestion** | 要件を収集または曖昧さを明確にするために複数選択質問をします                                                                                                                                                       | いいえ   |
| **Bash**            | 環境でシェルコマンドを実行します（以下の [Bash ツール動作](#bash-tool-behavior)を参照）                                                                                                                           | はい    |
| **TaskOutput**      | バックグラウンドタスク（bash シェルまたは subagent）から出力を取得します                                                                                                                                          | いいえ   |
| **Edit**            | 特定のファイルに対して対象を絞った編集を行います                                                                                                                                                             | はい    |
| **ExitPlanMode**    | ユーザーにプランモードを終了してコーディングを開始するよう促します                                                                                                                                                    | はい    |
| **Glob**            | パターンマッチングに基づいてファイルを検索します                                                                                                                                                             | いいえ   |
| **Grep**            | ファイルコンテンツ内のパターンを検索します                                                                                                                                                                | いいえ   |
| **KillShell**       | ID でバックグラウンド bash シェルを強制終了します                                                                                                                                                        | いいえ   |
| **MCPSearch**       | [ツール検索](/ja/mcp#scale-with-mcp-tool-search)が有効な場合、MCP ツールを検索して読み込みます                                                                                                                 | いいえ   |
| **NotebookEdit**    | Jupyter ノートブックセルを変更します                                                                                                                                                               | はい    |
| **Read**            | ファイルの内容を読み取ります                                                                                                                                                                       | いいえ   |
| **Skill**           | メイン会話内で [skill](/ja/skills#control-who-invokes-a-skill) を実行します                                                                                                                       | はい    |
| **Agent**           | 複雑なマルチステップタスクを処理するために subagent を実行します                                                                                                                                                | いいえ   |
| **TaskCreate**      | タスクリストに新しいタスクを作成します                                                                                                                                                                  | いいえ   |
| **TaskGet**         | 特定のタスクの完全な詳細を取得します                                                                                                                                                                   | いいえ   |
| **TaskList**        | すべてのタスクを現在のステータスでリストします                                                                                                                                                              | いいえ   |
| **TaskUpdate**      | タスクのステータス、依存関係、詳細を更新するか、タスクを削除します                                                                                                                                                    | いいえ   |
| **WebFetch**        | 指定された URL からコンテンツをフェッチします                                                                                                                                                            | はい    |
| **WebSearch**       | ドメインフィルタリング付きで Web 検索を実行します                                                                                                                                                          | はい    |
| **Write**           | ファイルを作成または上書きします                                                                                                                                                                     | はい    |
| **LSP**             | 言語サーバー経由のコード知能。ファイル編集後に型エラーと警告を自動的に報告します。また、ナビゲーション操作もサポートします：定義にジャンプ、参照を検索、型情報を取得、シンボルをリスト、実装を検索、呼び出し階層をトレース。[コード知能プラグイン](/ja/discover-plugins#code-intelligence)とその言語サーバーバイナリが必要です | いいえ   |

権限ルールは `/allowed-tools` または [権限設定](/ja/settings#available-settings)を使用して構成できます。[ツール固有の権限ルール](/ja/permissions#tool-specific-permission-rules)も参照してください。

### Bash ツール動作

Bash ツールは以下の永続性動作でシェルコマンドを実行します：

* **作業ディレクトリは永続化**：Claude が作業ディレクトリを変更する場合（例：`cd /path/to/dir`）、後続の Bash コマンドはそのディレクトリで実行されます。`CLAUDE_BASH_MAINTAIN_PROJECT_WORKING_DIR=1` を使用して、各コマンド後にプロジェクトディレクトリにリセットできます。
* **環境変数は永続化されません**：1 つの Bash コマンドで設定された環境変数（例：`export MY_VAR=value`）は、後続の Bash コマンドでは**利用できません**。各 Bash コマンドは新しいシェル環境で実行されます。

Bash コマンドで環境変数を利用可能にするには、**3 つのオプション**があります：

**オプション 1：Claude Code を開始する前に環境をアクティブ化**（最も簡単なアプローチ）

Claude Code を起動する前に、ターミナルで仮想環境をアクティブ化します：

```bash  theme={null}
conda activate myenv
# または：source /path/to/venv/bin/activate
claude
```

これはシェル環境で機能しますが、Claude の Bash コマンド内で設定された環境変数はコマンド間で永続化されません。

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

[SessionStart hooks](/ja/hooks#persist-environment-variables)の詳細については、オプション 3 を参照してください。

### hooks でツールを拡張

[Claude Code hooks](/ja/hooks-guide) を使用して、任意のツール実行の前後にカスタムコマンドを実行できます。

たとえば、Claude が Python ファイルを変更した後に Python フォーマッターを自動的に実行したり、特定のパスへの Write 操作をブロックして本番構成ファイルの変更を防止したりできます。

## 関連項目

* [権限](/ja/permissions)：権限システム、ルール構文、ツール固有パターン、および managed ポリシー
* [認証](/ja/authentication)：Claude Code へのユーザーアクセスをセットアップ
* [トラブルシューティング](/ja/troubleshooting)：一般的な構成問題の解決策
