> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# 設定ファイルの例

> 開発者、チーム、組織向けの現実的な settings.json ファイル：1 つをコピーして、必要なキーを保持し、値を変更してください。

このページには 3 つの例 `settings.json` ファイルがあります。設定を保存する場所ごとに 1 つずつです：

* 開発者の `~/.claude/settings.json`
* チームの `.claude/settings.json`（リポジトリにコミットされたもの）
* 組織の `managed-settings.json`

それぞれが読者にとって妥当なファイルなので、形状を確認して必要な部分をコピーできます。どれも推奨されるベースラインではありません。すべての値は [設定リファレンス](https://code.claude.com/docs/ja/settings-reference.md) のキーのエントリから取得されており、そこには型、デフォルト値、および設定できる場所が記載されています。

各例には 2 つのタブがあります。**コピー可能な設定ファイル** は保存するファイルです。**各キーの機能** は同じファイルですが、各キーの上にコメントがあります。Claude Code は設定ファイルのコメントを受け入れないため、最初のタブからコピーしてください。

## 独自の設定

1 人の開発者の個人設定です。モデルと努力レベルを選択し、ターミナルを調整し、読み取り専用コマンドと 1 つのファイル読み取りを事前承認します。リストされていないすべてのものはデフォルトを保持します。このようなファイルは `~/.claude/settings.json` に保存され、開くすべてのプロジェクトに適用されます。

> [tab] コピー可能な設定ファイル
>
> これを `~/.claude/settings.json` として保存してください。コメントのない有効な JSON なので、そのまま貼り付けて、不要なキーを削除できます。
>
> ```json ~/.claude/settings.json theme={null}
> {
>   "model": "claude-sonnet-5",
>   "modelSettings": {
>     "claude-sonnet-5": { "effortLevel": "xhigh" }
>   },
>   "editorMode": "vim",
>   "theme": "light-daltonized",
>   "statusLine": {
>     "type": "command",
>     "command": "jq -r '\"[\\(.model.display_name)] \\(.context_window.used_percentage // 0)% context\"'",
>     "padding": 2
>   },
>   "spinnerTipsEnabled": false,
>   "preferredNotifChannel": "terminal_bell",
>   "permissions": {
>     "allow": [
>       "Bash(git diff *)",
>       "Read(~/.zshrc)"
>     ]
>   },
>   "autoUpdatesChannel": "stable",
>   "cleanupPeriodDays": 20
> }
> ```

> [tab] 各キーの機能
>
> 同じファイルですが、各キーの上にコメントがあります。ここで読んでください。Claude Code は設定ファイルのコメントを受け入れないため、別のタブからコピーしてください。
>
> ```jsonc ~/.claude/settings.json theme={null}
> {
>   // すべてのセッションを Sonnet 5 で開始
>   "model": "claude-sonnet-5",
>   // Sonnet 5 をデフォルトの高レベルより上で実行します。/effort はモデルごとにレベルを保存し、--effort は単一セッションに設定します
>   "modelSettings": {
>     "claude-sonnet-5": { "effortLevel": "xhigh" }
>   },
>   // プロンプトの Vim キーバインディング
>   "editorMode": "vim",
>   // 色覚異常対応のライトテーマ
>   "theme": "light-daltonized",
>   // プロンプトの下のステータスライン：モデル名とコンテキスト使用量
>   "statusLine": {
>     "type": "command",
>     "command": "jq -r '\"[\\(.model.display_name)] \\(.context_window.used_percentage // 0)% context\"'",
>     "padding": 2
>   },
>   // スピナーの下で回転するヒントを非表示にする
>   "spinnerTipsEnabled": false,
>   // 完了したタスクや待機中の権限プロンプトなどの通知のためにターミナルベルを鳴らす
>   "preferredNotifChannel": "terminal_bell",
>   // Claude Code が git diff を実行し、.zshrc を読み取ることを許可する（確認なし）
>   "permissions": {
>     "allow": [
>       "Bash(git diff *)",
>       "Read(~/.zshrc)"
>     ]
>   },
>   // 安定チャネルから更新を取得
>   "autoUpdatesChannel": "stable",
>   // 20 日以上前のセッショントランスクリプトおよび他のローカルセッションデータを削除
>   "cleanupPeriodDays": 20
> }
> ```

## チームの共有設定

1 つのチームの共有設定は、リポジトリにコミットされるため、それをクローンした全員が同じ権限、hooks、プラグインマーケットプレイスを取得します。リポジトリのトップレベルに `.claude/settings.json` のようなファイルを保存してください。コミットする前に知っておくべきことは以下の通りです。

* **[プロジェクト](https://code.claude.com/docs/ja/claude-projects.md#what-threads-pick-up-from-your-repositories)のスレッド外のクラウドセッションもこれを読みます。** 1 つのリポジトリを持つ[クラウドセッション](https://code.claude.com/docs/ja/settings.md#settings-in-cloud-sessions)はクローン内で開始されるため、コミットされたファイルはそこにも適用されます。
* **テレメトリは管理設定または個人設定に入ります。** Claude Code は、リポジトリの設定ファイルの [OpenTelemetry エクスポーター変数](https://code.claude.com/docs/ja/settings-reference.md#variables-claude-code-ignores-in-env)を無視します。ただし、テレメトリをオフにする値は除きます。組織の[管理設定](https://code.claude.com/docs/ja/monitoring-usage.md#administrator-configuration)、または各ユーザーの `~/.claude/settings.json` で設定してください。
* **許可ルールは信頼を待ちます。** 許可ルールと `extraKnownMarketplaces` エントリは、各ユーザーが[このフォルダ自体を信頼](https://code.claude.com/docs/ja/permissions.md#project-allow-rules-and-workspace-trust)した後に有効になります。親フォルダだけではなく、このフォルダ自体を信頼する必要があります。拒否ルールと確認ルールは、信頼されているセッションでもそうでないセッションでも、すべてのセッションで適用されます。
* **hook はリポジトリ内のスクリプトです。** このファイルの hook は `.claude/hooks/block-rm.sh` を実行します。[hook がどのように解決されるか](https://code.claude.com/docs/ja/hooks.md#how-a-hook-resolves)では、これを書く方法について説明しています。
* **ルールはコマンドとパスを記述されたとおりにマッチします。** `Bash(git push *)` は [`git -C . push`](https://code.claude.com/docs/ja/permissions#bash-rule-limits) にはマッチしません。`Read(./.env)` 単独では、ファイルツールと `cat .env` のようにファイルを名前で指定するコマンドを停止しますが、[`grep -r` をディレクトリ上で実行](https://code.claude.com/docs/ja/permissions#read-and-edit)することは停止しません。このファイルの `sandbox` ブロックはそのギャップを埋めます。sandbox は[あなたの `Read` 拒否パス](https://code.claude.com/docs/ja/settings-reference#sandbox-filesystem-denyread)をすべてのサンドボックス化されたコマンドが読み取れないものに追加するためです。

> [tab] コピー可能な設定ファイル
>
> これをリポジトリのトップレベルに `.claude/settings.json` として保存してコミットしてください。コメントのない有効な JSON なので、そのまま貼り付けて、不要なキーを削除できます。
>
> ```json .claude/settings.json theme={null}
> {
>   "permissions": {
>     "allow": [
>       "Bash(npm run *)"
>     ],
>     "ask": [
>       "Bash(git push *)"
>     ],
>     "deny": [
>       "Read(./.env)",
>       "Read(./.env.*)",
>       "Read(./secrets/**)"
>     ]
>   },
>   "hooks": {
>     "PreToolUse": [
>       {
>         "matcher": "Bash",
>         "hooks": [
>           {
>             "type": "command",
>             "command": "${CLAUDE_PROJECT_DIR}/.claude/hooks/block-rm.sh"
>           }
>         ]
>       }
>     ]
>   },
>   "extraKnownMarketplaces": {
>     "acme-tools": {
>       "source": {
>         "source": "github",
>         "repo": "acme-corp/claude-plugins"
>       }
>     }
>   },
>   "enabledPlugins": {
>     "code-formatter@acme-tools": true
>   },
>   "sandbox": {
>     "enabled": true,
>     "filesystem": {
>       "allowWrite": [
>         "/tmp/build"
>       ]
>     },
>     "network": {
>       "allowedDomains": [
>         "registry.npmjs.org",
>         "*.example.com"
>       ]
>     }
>   },
>   "plansDirectory": "./plans"
> }
> ```

> [tab] 各キーの機能
>
> 各キーの上にコメントが付いた同じファイルです。ここで読んでください。Claude Code は設定ファイルのコメントを受け入れないため、他のタブからコピーしてください。
>
> ```jsonc .claude/settings.json theme={null}
> {
>   "permissions": {
>     // npm スクリプトを確認なしで実行
>     "allow": [
>       "Bash(npm run *)"
>     ],
>     // git push コマンドの前に確認
>     "ask": [
>       "Bash(git push *)"
>     ],
>     // ファイルツールとファイル読み取りコマンドによる env ファイルと secrets フォルダの読み取りを拒否
>     "deny": [
>       "Read(./.env)",
>       "Read(./.env.*)",
>       "Read(./secrets/**)"
>     ]
>   },
>   // すべての Bash コマンドの前に、リポジトリ内のスクリプトを実行してそれをブロックできます
>   "hooks": {
>     "PreToolUse": [
>       {
>         "matcher": "Bash",
>         "hooks": [
>           {
>             "type": "command",
>             "command": "${CLAUDE_PROJECT_DIR}/.claude/hooks/block-rm.sh"
>           }
>         ]
>       }
>     ]
>   },
>   // すべてのクローンでチームのプラグインマーケットプレイスを登録
>   "extraKnownMarketplaces": {
>     "acme-tools": {
>       "source": {
>         "source": "github",
>         "repo": "acme-corp/claude-plugins"
>       }
>     }
>   },
>   // そのマーケットプレイスから 1 つのプラグインを有効化。GitHub リポジトリなどの外部ソースからのプラグインは、各ユーザーが 1 回インストールする必要があります
>   "enabledPlugins": {
>     "code-formatter@acme-tools": true
>   },
>   // サンドボックスコマンド：書き込み可能なビルドディレクトリ。npm と example.com は事前に許可
>   "sandbox": {
>     "enabled": true,
>     "filesystem": {
>       "allowWrite": [
>         "/tmp/build"
>       ]
>     },
>     "network": {
>       "allowedDomains": [
>         "registry.npmjs.org",
>         "*.example.com"
>       ]
>     }
>   },
>   // プランファイルをリポジトリ内に保持
>   "plansDirectory": "./plans"
> }
> ```

## 組織の管理設定

管理対象のキーの構造を示す `managed-settings.json` ファイルで、各キーに妥当な値を 1 つずつ設定しています。これは推奨ポリシーではありません。自身の要件に合うキーを選び、独自の値を設定してください。この例では次のキーを設定しています。

* `forceLoginMethod` と `forceLoginOrgUUID` は、ログイン方法と組織を固定します
* `availableModels` と `enforceAvailableModels` は、セッションで使用できるモデルを制限します
* `permissions.deny` は、2 つのファイル読み取りと、[Claude が記述する形式での](https://code.claude.com/docs/ja/permissions.md#bash-rule-limits) `curl` コマンドを拒否します。また、`disableBypassPermissionsMode` はバイパス権限モードを削除します
* [`allowManagedPermissionRulesOnly`](https://code.claude.com/docs/ja/settings-reference#allowmanagedpermissionrulesonly) と [`allowManagedMcpServersOnly`](https://code.claude.com/docs/ja/settings-reference#allowmanagedmcpserversonly) は、管理対象の権限と MCP の許可リストのみが適用されるようにします
* `allowedMcpServers` は、MCP サーバーを URL で固定します
* `strictKnownMarketplaces` は、1 つのプラグインマーケットプレイスを許可します
* `sandbox` は、固定のネットワーク許可リストを使用し、サンドボックス外での再試行なしでコマンドをサンドボックス化します。その `failIfUnavailable` キーは、[サンドボックスを実行できない環境で Claude Code が起動しないようにします](https://code.claude.com/docs/ja/sandboxing.md#enforce-sandboxing-with-managed-settings)
* `requiredMinimumVersion` は、Claude Code の最小バージョンを設定します
* `cleanupPeriodDays` は、セッションのトランスクリプトおよびその他のローカルデータの保持期間を 7 日間に短縮します
* `companyAnnouncements` は、起動時にメッセージを表示します

管理者は、このようなファイルを `managed-settings.json` としてデプロイするか、同じ JSON を MDM または[サーバー管理設定](https://code.claude.com/docs/ja/server-managed-settings.md)を通じてデプロイします。デプロイされた 1 つのファイルは、それが届くすべてのマシンまたはアカウントに適用されます。グループに異なる値を与えるには、そのグループに別のファイルまたはプロファイルをデプロイします。Enterprise プランでは、代わりにサーバー管理設定で[グループに独自の設定を与える](https://code.claude.com/docs/ja/server-managed-settings.md#give-groups-different-settings)こともできます。

> [tab] コピー可能な設定ファイル
>
> これを `managed-settings.json` としてデプロイするか、同じ JSON を MDM または claude.ai コンソールを通じてデプロイします。コメントを含まない有効な JSON です。例の組織 UUID、サーバー URL、マーケットプレイスを独自のものに置き換え、不要なキーは削除してください。
>
> ```json managed-settings.json theme={null}
> {
>   "forceLoginMethod": "claudeai",
>   "forceLoginOrgUUID": [
>     "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
>   ],
>   "availableModels": [
>     "opus",
>     "sonnet"
>   ],
>   "enforceAvailableModels": true,
>   "permissions": {
>     "deny": [
>       "Bash(curl *)",
>       "Read(./.env)",
>       "Read(./secrets/**)"
>     ],
>     "disableBypassPermissionsMode": "disable"
>   },
>   "allowManagedPermissionRulesOnly": true,
>   "allowedMcpServers": [
>     {
>       "serverUrl": "https://api.githubcopilot.com/*"
>     }
>   ],
>   "allowManagedMcpServersOnly": true,
>   "strictKnownMarketplaces": [
>     {
>       "source": "github",
>       "repo": "acme-corp/approved-plugins"
>     }
>   ],
>   "sandbox": {
>     "enabled": true,
>     "failIfUnavailable": true,
>     "allowUnsandboxedCommands": false,
>     "network": {
>       "allowedDomains": [
>         "registry.npmjs.org",
>         "github.com"
>       ],
>       "allowManagedDomainsOnly": true
>     }
>   },
>   "requiredMinimumVersion": "2.1.150",
>   "cleanupPeriodDays": 7,
>   "companyAnnouncements": [
>     "Welcome to Acme Corp! Review our code guidelines at docs.example.com"
>   ]
> }
> ```

> [tab] 各キーの役割
>
> 同じファイルで、各キーの上にコメントを付けたものです。ここで内容を確認し、コピーはもう一方のタブから行ってください。Claude Code は設定ファイル内のコメントを受け付けないためです。
>
> ```jsonc managed-settings.json theme={null}
> {
>   // claude.ai ログインのみ、かつこの組織のみ
>   "forceLoginMethod": "claudeai",
>   "forceLoginOrgUUID": [
>     "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
>   ],
>   // Opus と Sonnet モデルのみ。enforceAvailableModels により、Default オプションもこのリストに従う
>   "availableModels": [
>     "opus",
>     "sonnet"
>   ],
>   "enforceAvailableModels": true,
>   "permissions": {
>     // すべてのマシンで、curl コマンドと、プロジェクトの .env ファイルおよび secrets フォルダの読み取りを拒否
>     "deny": [
>       "Bash(curl *)",
>       "Read(./.env)",
>       "Read(./secrets/**)"
>     ],
>     // すべてのセッションからバイパス権限モードを削除
>     "disableBypassPermissionsMode": "disable"
>   },
>   // ユーザー、プロジェクト、ローカルの設定からの権限ルールを無視
>   "allowManagedPermissionRulesOnly": true,
>   // GitHub MCP サーバーのみ。ユーザーは任意のサーバーに "github" という名前を付けられるため、
>   // 名前ではなく URL で照合する。一致しないユーザー追加サーバーは読み込まれない。リストに
>   // URL エントリしかない場合は、すべての stdio サーバーも読み込まれない。下の allowManagedMcpServersOnly
>   // キーにより、この管理対象リストが適用される唯一の許可リストになる
>   "allowedMcpServers": [
>     {
>       "serverUrl": "https://api.githubcopilot.com/*"
>     }
>   ],
>   "allowManagedMcpServersOnly": true,
>   // プラグインはこのマーケットプレイスからのみ取得可能
>   "strictKnownMarketplaces": [
>     {
>       "source": "github",
>       "repo": "acme-corp/approved-plugins"
>     }
>   ],
>   // Claude が実行するすべてのコマンドをサンドボックス化し、サンドボックスをセットアップできない場合は
>   // 起動を拒否し、ブロックされたコマンドをサンドボックス外で再試行させない。ネットワークは
>   // npm と GitHub に制限し、ユーザーはドメインを追加できない
>   "sandbox": {
>     "enabled": true,
>     "failIfUnavailable": true,
>     "allowUnsandboxedCommands": false,
>     "network": {
>       "allowedDomains": [
>         "registry.npmjs.org",
>         "github.com"
>       ],
>       "allowManagedDomainsOnly": true
>     }
>   },
>   // 2.1.150 より古いバージョンでは起動を拒否
>   "requiredMinimumVersion": "2.1.150",
>   // セッションのトランスクリプトおよびその他のローカルセッションデータを 7 日後に削除
>   "cleanupPeriodDays": 7,
>   // 起動時にすべてのユーザーに表示されるメッセージ
>   "companyAnnouncements": [
>     "Welcome to Acme Corp! Review our code guidelines at docs.example.com"
>   ]
> }
> ```
