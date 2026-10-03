> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# Hooks リファレンス

> Claude Code のフック イベント、設定スキーマ、JSON 入出力形式、終了コード、非同期フック、HTTP フック、プロンプト フック、MCP ツール フックのリファレンス。

<Tip>
  例を含むクイックスタート ガイドについては、[フックでアクションを自動化する](/docs/ja/hooks-guide)を参照してください。
</Tip>

フックは、Claude Code のライフサイクル内の特定のポイントで自動的に実行されるユーザー定義のシェル コマンド、HTTP エンドポイント、MCP ツール呼び出し、LLM プロンプト、またはサブエージェントです。Claude Code は、ターミナルでのセッション、IDE 拡張機能、[デスクトップアプリ](/docs/ja/desktop-quickstart)、[クラウドセッション](/docs/ja/claude-code-on-the-web)など、どこで実行されていても同じフック イベントを発火します。このリファレンスを使用して、イベント スキーマ、設定オプション、JSON 入出力形式、非同期フック、HTTP フック、MCP ツール フックなどの高度な機能を検索してください。

プラグインは、Claude Code が自身のプロセス内で呼び出す JavaScript 関数としてフックを登録することもでき、これによりイベントに応じて動作するだけでなく、インターフェースに描画することもできます。そうしたプラグインは [mod](/docs/ja/plugins/mods/overview) であり、それらの関数フックについてはここではなく[イベントに反応する](/docs/ja/plugins/mods/events)で説明しています。このページで説明するフックは、mod と併用しても引き続き動作します。

<h2 id="hook-lifecycle">
  フック ライフサイクル
</h2>

Claude Code は、セッション中の特定のポイントでフックを実行します。イベントが発火して matcher がマッチすると、Claude Code はイベントに関する JSON コンテキストをフック ハンドラーに渡します。コマンド フックの場合、入力は stdin に到着します。HTTP フックの場合、POST リクエスト本体として到着します。ハンドラーは入力を検査し、アクションを実行し、オプションで決定を返すことができます。

イベントは 3 つのケイデンスに分類されます。

* セッションごとに 1 回：`SessionStart` と `SessionEnd`
* ターンごとに 1 回：`UserPromptSubmit`、`Stop`、`StopFailure`
* エージェント型ループ内のすべてのツール呼び出しで：`PreToolUse` と `PostToolUse`。ただし、[`EndConversation`](/docs/ja/tools-reference#endconversation-tool-behavior) の呼び出しは両方をスキップします

<div style={{maxWidth: "500px", margin: "0 auto"}}>
  <Frame>
    <img src="https://mintcdn.com/claude-code/x7pO8l4XcvAXCoVc/images/hooks-lifecycle.svg?fit=max&auto=format&n=x7pO8l4XcvAXCoVc&q=85&s=81b9256c1bbe8832553485f5d9e9c746" className="dark:hidden" alt="オプションの Setup から SessionStart に流れ込み、その後、UserPromptSubmit、スラッシュコマンド用の UserPromptExpansion、ネストされたエージェント型ループ（PreToolUse、PermissionRequest、PostToolUse、PostToolUseFailure、PostToolBatch、SubagentStart/Stop、TaskCreated、TaskCompleted）、Stop または StopFailure を含むターンごとのループ、その後 TeammateIdle、PreCompact、PostCompact、SessionEnd が続くことを示すフック ライフサイクル図。Elicitation と ElicitationResult は MCP ツール実行内にネストされ、PermissionDenied は auto モードでの拒否のための PermissionRequest からの副分岐、WorktreeCreate、WorktreeRemove、Notification、ConfigChange、InstructionsLoaded、CwdChanged、FileChanged、DirectoryAdded はスタンドアロンの非同期イベント、PreModelSwitch は要求されたモデル切り替えの前に実行されるスタンドアロンの逐次イベント、PostModelSwitch はセッションのモデルが変更された後に実行されるスタンドアロンの非同期イベント、MessageDisplay はアシスタントのメッセージ テキストのストリーミング中に実行される表示専用イベントとして示されています" width="520" height="1336" data-path="images/hooks-lifecycle.svg" />

    <img src="https://mintcdn.com/claude-code/x7pO8l4XcvAXCoVc/images/hooks-lifecycle-dark.svg?fit=max&auto=format&n=x7pO8l4XcvAXCoVc&q=85&s=c9b3d88487335f58cce0b52e2f9e7531" className="hidden dark:block" alt="オプションの Setup から SessionStart に流れ込み、その後、UserPromptSubmit、スラッシュコマンド用の UserPromptExpansion、ネストされたエージェント型ループ（PreToolUse、PermissionRequest、PostToolUse、PostToolUseFailure、PostToolBatch、SubagentStart/Stop、TaskCreated、TaskCompleted）、Stop または StopFailure を含むターンごとのループ、その後 TeammateIdle、PreCompact、PostCompact、SessionEnd が続くことを示すフック ライフサイクル図。Elicitation と ElicitationResult は MCP ツール実行内にネストされ、PermissionDenied は auto モードでの拒否のための PermissionRequest からの副分岐、WorktreeCreate、WorktreeRemove、Notification、ConfigChange、InstructionsLoaded、CwdChanged、FileChanged、DirectoryAdded はスタンドアロンの非同期イベント、PreModelSwitch は要求されたモデル切り替えの前に実行されるスタンドアロンの逐次イベント、PostModelSwitch はセッションのモデルが変更された後に実行されるスタンドアロンの非同期イベント、MessageDisplay はアシスタントのメッセージ テキストのストリーミング中に実行される表示専用イベントとして示されています" width="520" height="1336" data-path="images/hooks-lifecycle-dark.svg" />
  </Frame>
</div>

以下の表は、各イベントがいつ発火するかをまとめています。[フック イベント](#hook-events)セクションでは、各イベントの完全な入力スキーマと決定制御オプションについて説明しています。

| イベント | 発火するタイミング |
| :- | :- |
| `SessionStart` | セッションが開始または再開されたとき |
| `Setup` | `--init-only` で Claude Code を起動するとき、または `-p` モードで `--init` または `--maintenance` を使用するとき。CI またはスクリプトでの 1 回限りの準備用 |
| `UserPromptSubmit` | プロンプトを送信するとき、Claude が処理する前 |
| `UserPromptExpansion` | ユーザーが入力したコマンドがプロンプトに展開されるとき、Claude に到達する前。展開をブロックできます |
| `PreToolUse` | ツール呼び出しが実行される前。ブロックできます |
| `PermissionRequest` | ツール呼び出しが権限決定を必要とするとき |
| `PermissionDenied` | オートモードがツール呼び出しを拒否するとき、分類器の判定がない拒否を含みます。JSON `hookSpecificOutput.retry: true` を使用して、モデルが拒否されたツール呼び出しを再試行できることを伝えます。Claude Code は分類器が判定を出さなかった場合、`retry` を無視します |
| `PostToolUse` | ツール呼び出しが成功した後 |
| `PostToolUseFailure` | ツール呼び出しが失敗した後 |
| `PostToolBatch` | 並列ツール呼び出しの完全なバッチが解決した後、次のモデル呼び出しの前 |
| `Notification` | Claude Code が通知を送信するとき |
| `MessageDisplay` | アシスタントメッセージテキストが表示されている間 |
| `SubagentStart` | サブエージェントがスポーンされるとき |
| `SubagentStop` | サブエージェントが終了するとき |
| `TaskCreated` | `TaskCreate` 経由でタスクが作成されるとき |
| `TaskCompleted` | タスクが完了としてマークされるとき |
| `Stop` | Claude が応答を終了するとき |
| `StopFailure` | API エラーが原因でターンが終了するとき |
| `TeammateIdle` | [エージェントチーム](/docs/ja/agent-teams) のチームメイトがアイドル状態になろうとするとき |
| `InstructionsLoaded` | CLAUDE.md または `.claude/rules/*.md` ファイルがコンテキストに読み込まれるとき。セッション開始時およびセッション中にファイルが遅延読み込みされるときに発火します |
| `ConfigChange` | セッション中に設定ファイルが変更されるとき |
| `CwdChanged` | 作業ディレクトリが変更されるとき、例えば Claude が `cd` コマンドを実行するとき。direnv などのツールを使用したリアクティブな環境管理に便利です |
| `DirectoryAdded` | `/add-dir` または SDK `register_repo_root` コントロールリクエスト経由でセッション中盤に作業ディレクトリが追加されるとき |
| `FileChanged` | 監視対象ファイルがディスク上で変更されるとき。`matcher` フィールドは監視するファイル名を指定します |
| `WorktreeCreate` | `--worktree`、`isolation: "worktree"`、またはバックグラウンドセッション経由で worktree が作成されるとき。デフォルトの git 動作を置き換えます |
| `WorktreeRemove` | セッション終了時、サブエージェント終了時、またはバックグラウンドセッションを削除するときに worktree が削除されるとき |
| `PreCompact` | コンテキスト圧縮の前 |
| `PostCompact` | コンテキスト圧縮が完了した後 |
| `PreModelSwitch` | Claude Code があなたまたはクライアントがリクエストしたモデルスイッチを適用する前。スイッチをブロックできます |
| `PostModelSwitch` | セッションのモデルが変更された後、Claude Code が独自に行う変更（セッションを再開するときのモデル復元など）を含みます |
| `Elicitation` | MCP サーバーがツール呼び出し中にユーザー入力をリクエストするとき |
| `ElicitationResult` | ユーザーが MCP エリシテーションに応答した後、レスポンスがサーバーに送り返される前 |
| `SessionEnd` | セッションが終了するとき |

<h3 id="how-a-hook-resolves">
  フックがどのように解決されるか
</h3>

イベント、matcher、ハンドラーがどのように組み合わさるかを理解するために、破壊的なシェル コマンドをブロックする次の `PreToolUse` フックを考えてみましょう。

<Tabs>
  <Tab title="macOS/Linux">
    `matcher` は Bash ツール呼び出しに絞り込み、`if` 条件は `rm *` にマッチする Bash サブコマンドにさらに絞り込むため、`block-rm.sh` は両方のフィルターがマッチするときのみ生成されます。

    ```json theme={null}
    {
      "hooks": {
        "PreToolUse": [
          {
            "matcher": "Bash",
            "hooks": [
              {
                "type": "command",
                "if": "Bash(rm *)",
                "command": "${CLAUDE_PROJECT_DIR}/.claude/hooks/block-rm.sh",
                "args": []
              }
            ]
          }
        ]
      }
    }
    ```

    スクリプトは stdin から JSON 入力を読み取り、コマンドを抽出し、`rm -rf` が含まれている場合は `permissionDecision` として `"deny"` を返します。Claude Code が実行できるように、プロジェクト内の `.claude/hooks/block-rm.sh` に保存し、`chmod +x .claude/hooks/block-rm.sh` で実行可能にしてください。

    ```bash theme={null}
    #!/bin/bash
    # .claude/hooks/block-rm.sh
    COMMAND=$(jq -r '.tool_input.command')

    if echo "$COMMAND" | grep -q 'rm -rf'; then
      jq -n '{
        hookSpecificOutput: {
          hookEventName: "PreToolUse",
          permissionDecision: "deny",
          permissionDecisionReason: "Destructive command blocked by hook"
        }
      }'
    else
      exit 0  # no decision; normal permission flow applies
    fi
    ```

    このスクリプトは、JSON 入力を解析するこのページの他の Bash の例と同様に `jq` を使用します。試す前に `jq` をインストールし、`PATH` 上にあることを確認してください。
  </Tab>

  <Tab title="Windows (PowerShell)">
    matcher `Bash|PowerShell` は、Bash に加えて [PowerShell ツール](#powershell)も対象にします。1 つの `if` ルールは 1 つのツールの呼び出しにしかマッチしないため、ツールごとに個別のハンドラーを用意します。1 つ目は `rm *` にマッチする Bash サブコマンドに、2 つ目は `Remove-Item *` にマッチする PowerShell コマンドに絞り込みます。どちらも `powershell.exe` を通じて同じスクリプトを実行します。

    ```json theme={null}
    {
      "hooks": {
        "PreToolUse": [
          {
            "matcher": "Bash|PowerShell",
            "hooks": [
              {
                "type": "command",
                "if": "Bash(rm *)",
                "command": "powershell.exe",
                "args": [
                  "-NoProfile",
                  "-ExecutionPolicy",
                  "Bypass",
                  "-File",
                  "${CLAUDE_PROJECT_DIR}/.claude/hooks/block-rm.ps1"
                ]
              },
              {
                "type": "command",
                "if": "PowerShell(Remove-Item *)",
                "command": "powershell.exe",
                "args": [
                  "-NoProfile",
                  "-ExecutionPolicy",
                  "Bypass",
                  "-File",
                  "${CLAUDE_PROJECT_DIR}/.claude/hooks/block-rm.ps1"
                ]
              }
            ]
          }
        ]
      }
    }
    ```

    `-NoProfile` フラグは PowerShell プロファイルの読み込みをスキップしてフックをすばやく起動させ、`-ExecutionPolicy Bypass` は PowerShell がローカルのスクリプト ファイルを実行できるようにします。

    スクリプトは stdin から JSON 入力を読み取り、コマンドを抽出し、`rm -rf` または `-Recurse` が後に続く `Remove-Item` が含まれている場合は `permissionDecision` として `"deny"` を返します。プロジェクト内の `.claude/hooks/block-rm.ps1` に保存してください。

    ```powershell theme={null}
    # .claude/hooks/block-rm.ps1
    $callInput = [Console]::In.ReadToEnd() | ConvertFrom-Json
    $command = $callInput.tool_input.command

    if ($command -match 'rm -rf|Remove-Item.*-Recurse') {
      @{
        hookSpecificOutput = @{
          hookEventName = "PreToolUse"
          permissionDecision = "deny"
          permissionDecisionReason = "Destructive command blocked by hook"
        }
      } | ConvertTo-Json
    } else {
      exit 0  # no decision; normal permission flow applies
    }
    ```
  </Tab>
</Tabs>

ここで、macOS/Linux の設定に対して Claude Code が `Bash "rm -rf /tmp/build"` を実行することにしたとします。以下が起こります。

<Frame>
  <img src="https://mintcdn.com/claude-code/ikqp3_70mqIahteV/images/hook-resolution.svg?fit=max&auto=format&n=ikqp3_70mqIahteV&q=85&s=be0bf3053550c26de5f54cd64674c197" className="dark:hidden" alt="フック解決の図：PreToolUse が発火し、matcher が Bash へのマッチをチェックし、次に if 条件が Bash(rm *) へのマッチをチェックします。両方がマッチすると、フック コマンドが実行されて permissionDecision として deny を返すため、ツール呼び出しはブロックされ、Claude Code は処理を続行します。いずれかのチェックがマッチしない場合、フックはスキップされ、ツール呼び出しの続行が許可されます。" width="930" height="270" data-path="images/hook-resolution.svg" />

  <img src="https://mintcdn.com/claude-code/_xqph1dUOslCOwsj/images/hook-resolution-dark.svg?fit=max&auto=format&n=_xqph1dUOslCOwsj&q=85&s=e80af91f8507cee6bd51ac3c2dd92f63" className="hidden dark:block" alt="フック解決の図：PreToolUse が発火し、matcher が Bash へのマッチをチェックし、次に if 条件が Bash(rm *) へのマッチをチェックします。両方がマッチすると、フック コマンドが実行されて permissionDecision として deny を返すため、ツール呼び出しはブロックされ、Claude Code は処理を続行します。いずれかのチェックがマッチしない場合、フックはスキップされ、ツール呼び出しの続行が許可されます。" width="930" height="270" data-path="images/hook-resolution-dark.svg" />
</Frame>

<Steps>
  <Step title="イベントが発火">
    `PreToolUse` イベントが発火します。Claude Code はツール入力を JSON として stdin のフックに送信します。

    ```json theme={null}
    { "tool_name": "Bash", "tool_input": { "command": "rm -rf /tmp/build" }, ... }
    ```
  </Step>

  <Step title="matcher がチェック">
    matcher `"Bash"` がツール名にマッチするため、このフック グループがアクティブになります。matcher を省略するか `"*"` を使用すると、グループはイベントのすべての出現でアクティブになります。
  </Step>

  <Step title="If 条件がチェック">
    `if` 条件 `"Bash(rm *)"` は `rm -rf /tmp/build` が `rm *` にマッチするサブコマンドであるためマッチし、このハンドラーが生成されます。コマンドが `npm test` だった場合、`if` チェックは失敗し、`block-rm.sh` は実行されず、プロセス生成のオーバーヘッドを回避します。`if` フィールドはオプションです。なければ、マッチしたグループ内のすべてのハンドラーが実行されます。
  </Step>

  <Step title="フック ハンドラーが実行">
    スクリプトは完全なコマンドを検査し、`rm -rf` を見つけるため、stdout に決定を出力します。

    ```json theme={null}
    {
      "hookSpecificOutput": {
        "hookEventName": "PreToolUse",
        "permissionDecision": "deny",
        "permissionDecisionReason": "Destructive command blocked by hook"
      }
    }
    ```

    コマンドが安全な `rm` バリアント（`rm file.txt` など）だった場合、スクリプトは代わりに `exit 0` に到達します。出力なしの終了コード 0 は、フックが報告する決定がないことを意味するため、ツール呼び出しは通常の[権限フロー](/docs/ja/permissions)を通じて続行されます。フックは呼び出しを拒否できますが、沈黙を保つことは承認を意味しません。
  </Step>

  <Step title="Claude Code が結果に基づいて行動">
    Claude Code は JSON 決定を読み取り、ツール呼び出しをブロックし、Claude に理由を表示します。
  </Step>
</Steps>

以下の[設定](#configuration)セクションでは完全なスキーマについて説明し、各[フック イベント](#hook-events)セクションでは、コマンドが受け取る入力と返すことができる出力について説明しています。

<h2 id="configuration">
  設定
</h2>

フックは JSON 設定ファイルで定義されます。設定には 3 つのネストレベルがあります。

1. 応答する[フック イベント](#hook-events)を選択します（`PreToolUse` や `Stop` など）
2. 発火するタイミングをフィルタリングする [matcher グループ](#matcher-patterns)を追加します（「Bash ツールのみ」など）
3. マッチしたときに実行する 1 つ以上の[フック ハンドラー](#hook-handler-fields)を定義します

完全なウォークスルーと注釈付きの例については、上記の[フックがどのように解決されるか](#how-a-hook-resolves)を参照してください。

<Note>
  このページでは各レベルに特定の用語を使用しています。**フック イベント**はライフサイクル ポイント、**matcher グループ**はフィルター、**フック ハンドラー**はシェル コマンド、HTTP エンドポイント、MCP ツール、プロンプト、または実行されるエージェントです。「フック」単独は一般的な機能を指します。
</Note>

<h3 id="hook-locations">
  フック位置
</h3>

フックを定義する場所によって、そのスコープが決まります。

| 位置 | スコープ | 共有可能 |
| :- | :- | :- |
| `~/.claude/settings.json` | すべてのプロジェクト | いいえ、マシンにローカル |
| `.claude/settings.json` | 単一プロジェクト | はい、リポジトリにコミット可能 |
| `.claude/settings.local.json` | 単一プロジェクト | いいえ、Claude Code が設定を保存する際に gitignore 対象になります |
| 管理ポリシー設定 | 組織全体 | はい、管理者が制御 |
| [プラグイン](/docs/ja/plugins/overview) `hooks/hooks.json` | プラグインが有効な場合 | はい、プラグインにバンドル |
| [スキル](/docs/ja/skills)のフロントマター | スキルが呼び出された後のセッションの残りの期間。[スキルとエージェントのフック](#hooks-in-skills-and-agents)を参照 | はい、スキルファイルで定義 |
| [サブエージェント](/docs/ja/sub-agents)のフロントマター | そのサブエージェントの実行中 | はい、サブエージェントファイルで定義 |

[クラウドセッション](/docs/ja/claude-code-on-the-web)は、ローカルの `~/.claude/settings.json` を読み取りません。[セルフホスト環境](/docs/ja/self-hosted-environments-configuration#permissions-and-tool-approval)では、Claude Code はオペレーターがランナーホストの `~/.claude/` に用意したフックも実行します。また、ランナーイメージの管理設定ファイルが [Claude Code が適用する管理ソース](/docs/ja/managed-settings#how-claude-code-combines-managed-sources)に含まれる場合は、そのファイル内のフックも実行します。デフォルトでは、これはサーバー管理設定も MDM で配布された Claude Code ポリシーも管理層を提供していない場合に限られます。どの設定ファイルとプラグイン、つまりどのフックがクラウドセッションに届くかについては、[セットアップから引き継がれるもの](/docs/ja/cloud-environments#what-carries-over-from-your-setup)を参照してください。

設定ファイル解決の詳細については、[設定](/docs/ja/settings)を参照してください。

設定ファイル、管理ポリシー設定、プラグインからのフックは、[サブエージェント](/docs/ja/sub-agents)内でも実行されます。サブエージェントがツールを呼び出すと、`PreToolUse` や `PostToolUse` などのツールイベントはメインの会話と同じ設定済みフックを発火させ、入力にはサブエージェントを識別する `agent_id` と `agent_type` の[共通入力フィールド](#common-input-fields)が含まれます。

管理者は[管理設定](/docs/ja/managed-settings)で [`allowManagedHooksOnly`](/docs/ja/settings-reference#allowmanagedhooksonly) を使用して、実行されるフックを制限できます。

* ユーザー、プロジェクト、ローカル、プラグインのフックはブロックされます。管理設定の `enabledPlugins` で強制的に有効化されたプラグインのフックは除外されます
* Claude Code は、[`statusLine`](/docs/ja/statusline)、[`fileSuggestion`](/docs/ja/settings-reference#filesuggestion)、[`subagentStatusLine`](/docs/ja/statusline#subagent-status-lines) の設定も管理設定のものに限定します
* Claude Code は、[`command` ソース](/docs/ja/plugins/marketplace-reference#command-plugin-source)を持つプラグインも無効化します。これには管理設定の `enabledPlugins` で強制的に有効化されたプラグインも含まれます。ただし、[`disableCommandPluginSources`](/docs/ja/settings-reference#disablecommandpluginsources) が明示的に `false` に設定されている場合は除きます。`command` ソースには Claude Code v2.1.229 以降が必要です
* Claude Code は、マーケットプレイスの [`headersHelper` コマンド](/docs/ja/plugins/host-marketplace#authenticate-archive-downloads)もブロックします。ただし、[`disableCommandPluginSources`](/docs/ja/settings-reference#disablecommandpluginsources) が明示的に `false` に設定されている場合は除きます。また、管理設定自体が宣言しているマーケットプレイスは対象外です

[`allowManagedHooksOnly` の下で実行されるもの](/docs/ja/settings-reference#what-runs-under-allowmanagedhooksonly)を参照してください。

フックエントリは、設定レベル間で互いに置き換えられるのではなくマージされます。ユーザー、プロジェクト、ローカルの設定は管理フックを削除せずに独自のフックを追加します。また、[`disableAllHooks`](#disable-or-remove-hooks) 設定は、管理設定の外からは管理フックを無効化できません。

[HTTP フックの許可リスト](/docs/ja/settings-reference#hook-and-skill-settings)は、管理ポリシー設定を含むすべてのソースからのフックに適用されます。

* `allowedHttpHookUrls`: いずれかの設定レベルで定義されている場合、Claude Code は URL がマージされた許可リストに一致する HTTP フックハンドラーのみを実行します
* `httpHookAllowedEnvVars`: 定義されている場合、Claude Code はそのリストにある環境変数のみをフックヘッダーに補間します

<h3 id="matcher-patterns">
  Matcher パターン
</h3>

`matcher` フィールドは、フックが発火するタイミングをフィルタリングします。matcher の評価方法は、含まれている文字に依存します。

| matcher 値 | 評価方法 | 例 |
| :- | :- | :- |
| `"*"`、`""`、または省略 | すべてにマッチ | イベントのすべての出現で発火 |
| 文字、数字、`_`、`-`、スペース、`,`、`\|` のみ | 完全一致、または `\|` または `,` で区切られた完全一致のリスト（オプションで周囲の空白を含む） | `Bash` は Bash ツールのみにマッチ。`Edit\|Write` と `Edit, Write` はいずれかのツールに完全にマッチ。`code-reviewer` はそのエージェント タイプのみにマッチ |
| その他の文字を含む | JavaScript 正規表現、アンカーなし | `^Notebook` は名前が `Notebook` で始まるツールにマッチ。`mcp__memory__.*` は `memory` サーバーのすべてのツールにマッチ |

正規表現パス上の matcher は JavaScript の `RegExp.prototype.test` でテストされます。これは値内のどこかでマッチすると成功します。`Edit.*` は `Edit` と `NotebookEdit` の両方にマッチします。完全文字列マッチが必要な場合は、`^Edit$` のようにパターンを `^` と `$` でラップしてください。

`FileChanged` と `StopFailure` は、文字、数字、`_`、`|` のみの狭い完全一致セットを使用します。これら 2 つのイベントの matcher にハイフン、スペース、またはカンマがあると、正規表現パスに留まり、`|` のみが代替を区切ります。後続の表で matcher サポートを持つ他のすべてのイベントは `|` または `,` を受け入れます。

`FileChanged` イベントは監視リストを構築するときにこれらのルールに従いません。[FileChanged](#filechanged)を参照してください。

各イベント タイプは異なるフィールドでマッチします。

| イベント | matcher がフィルタリングするもの | matcher 値の例 |
| :- | :- | :- |
| `PreToolUse`、`PostToolUse`、`PostToolUseFailure`、`PermissionRequest`、`PermissionDenied` | ツール名 | `Bash`、`Edit\|Write`、`mcp__.*` |
| `SessionStart` | セッションの開始方法 | `startup`、`resume`、`clear`、`compact`、`fork` |
| `Setup` | セットアップをトリガーした CLI フラグ | `init`、`maintenance` |
| `SessionEnd` | セッションが終了した理由 | `clear`、`resume`、`logout`、`prompt_input_exit`、`other` |
| `Notification` | 通知タイプ | `permission_prompt`、`idle_prompt`、`auth_success`、`elicitation_dialog`、`elicitation_url_dialog`、`elicitation_complete`、`elicitation_response`、`agent_needs_input`、`agent_completed`、`quota_auto_resume_fired`、`quota_auto_resume_stale`、`quota_auto_resume_disabled` |
| `SubagentStart` | エージェント タイプ | `general-purpose`、`Explore`、`Plan`、カスタム エージェント名、またはプラグイン スコープ付き名前（`^my-plugin:reviewer$` など） |
| `PreCompact`、`PostCompact` | コンテキスト圧縮をトリガーしたもの | `manual`、`auto` |
| `PreModelSwitch`、`PostModelSwitch` | セッションの切り替え先モデルの正規名（[PreModelSwitch](#premodelswitch) で説明） | `claude-opus-5`、`claude-opus-4-6\|claude-opus-5`、`.*opus.*` |
| `SubagentStop` | エージェント タイプ | `SubagentStart` と同じ値 |
| `ConfigChange` | 設定ソース | `user_settings`、`project_settings`、`local_settings`、`policy_settings`、`skills` |
| `CwdChanged` | matcher サポートなし | すべての出現で常に発火 |
| `DirectoryAdded` | ディレクトリが追加された方法 | `slash_command`、`register_repo_root` |
| `FileChanged` | 監視するリテラル ファイル名（[FileChanged](#filechanged)を参照） | `.envrc\|.env` |
| `StopFailure` | エラー タイプ | `rate_limit`、`overloaded`、`authentication_failed`、`oauth_org_not_allowed`、`account_on_hold`、`billing_error`、`invalid_request`、`model_not_found`、`server_error`、`max_output_tokens`、`cloud_credential_error`、`unknown` |
| `InstructionsLoaded` | ロード理由 | `session_start`、`nested_traversal`、`path_glob_match`、`include`、`compact` |
| `UserPromptExpansion` | コマンド名 | スキルまたはコマンド名 |
| `Elicitation` | MCP サーバー名 | 設定された MCP サーバー名 |
| `ElicitationResult` | MCP サーバー名 | `Elicitation` と同じ値 |
| `UserPromptSubmit`、`PostToolBatch`、`Stop`、`TeammateIdle`、`TaskCreated`、`TaskCompleted`、`WorktreeCreate`、`WorktreeRemove`、`MessageDisplay` | matcher サポートなし | すべての出現で常に発火 |

`StopFailure` を `cloud_credential_error` でマッチさせるには Claude Code v2.1.267 以降が必要です。これは、認証情報の読み込み失敗を `server_error` や `unknown` ではなくこの値で報告する最初のバージョンです。

ほとんどのイベントでは、Claude Code は、フックに stdin で送信する [JSON 入力](#hook-input-and-output)のフィールドに対して matcher を評価します。ツール イベントの場合、そのフィールドは `tool_name` です。`PreModelSwitch` と `PostModelSwitch` では、[PreModelSwitch](#premodelswitch) で説明しているとおり、Claude Code は `to_model` から導出した正規名に対して matcher を評価します。各[フック イベント](#hook-events)セクションでは、matcher 値の完全なセットとそのイベントの入力スキーマをリストしています。

この例は、Claude がファイルを書き込むまたは編集するときにのみ linting スクリプトを実行します。

```json theme={null}
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [
          {
            "type": "command",
            "command": "/path/to/lint-check.sh"
          }
        ]
      }
    ]
  }
}
```

matcher をサポートしないイベントに `matcher` フィールドを追加すると、サイレントに無視されます。

ツール イベントの場合、個別のフック ハンドラーで [`if` フィールド](#common-fields)を設定することで、より狭くフィルタリングできます。`if` は[権限ルール構文](/docs/ja/permissions)を使用してツール名と引数を一緒にマッチするため、`"Bash(git *)"` は `git *` に一致する Bash 入力のサブコマンドのいずれかに対して実行され、`"Edit(*.ts)"` は TypeScript ファイルのみに対して実行されます。

<h4 id="match-mcp-tools">
  MCP ツールをマッチ
</h4>

[MCP](/docs/ja/mcp) サーバー ツールはツール イベント（`PreToolUse`、`PostToolUse`、`PostToolUseFailure`、`PermissionRequest`、`PermissionDenied`）で通常のツールとして表示されるため、他のツール名と同じ方法でマッチできます。

MCP ツールは `mcp__<server>__<tool>` という命名パターンに従います。例えば、

* `mcp__memory__create_entities`: Memory サーバーの create entities ツール
* `mcp__filesystem__read_file`: Filesystem サーバーの read file ツール
* `mcp__github__search_repositories`: GitHub サーバーの search ツール

サーバーのすべてのツールをマッチするには、サーバー プレフィックスに `.*` を追加します。`.*` は必須です。`mcp__memory` や `mcp__brave-search` のような matcher は完全一致文字のみを含むため、完全一致として比較され、どのツールにもマッチしません。

* `mcp__memory__.*` は `memory` サーバーのすべてのツールにマッチ
* `mcp__brave-search__.*` は名前にハイフンを含むサーバーのすべてのツールにマッチ
* `mcp__.*__write.*` は任意のサーバーの、名前が `write` で始まるツールにマッチ

[プラグイン バンドル MCP サーバー](/docs/ja/mcp#plugin-provided-mcp-servers)からのツールは、プラグイン名を含むスコープ付きサーバー セグメントを使用します。`mcp__plugin_<plugin-name>_<server-name>__<tool>`。ベア サーバー キーに対して記述された matcher は、これらのツールに対して発火しません。`db` キーの下でサーバーをバンドルする `my-plugin` という名前のプラグインの場合、`query` ツールは `mcp__plugin_my-plugin_db__query` として表示されるため、そのサーバーのすべてのツールの matcher は `mcp__plugin_my-plugin_db__.*` です。ハンドラーの [`if` フィールド](#common-fields)で同じスコープ付きツール名を使用します。スコープ付き名がどのように構築されるかについては、[プラグイン提供 MCP サーバー](/docs/ja/mcp#plugin-provided-mcp-servers)を参照してください。

この例は、すべてのメモリ サーバー操作をログに記録し、任意の MCP サーバーからの書き込み操作を検証します。

```json theme={null}
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "mcp__memory__.*",
        "hooks": [
          {
            "type": "command",
            "command": "echo 'Memory operation initiated' >> ~/mcp-operations.log"
          }
        ]
      },
      {
        "matcher": "mcp__.*__write.*",
        "hooks": [
          {
            "type": "command",
            "command": "/home/user/scripts/validate-mcp-write.py"
          }
        ]
      }
    ]
  }
}
```

<h3 id="hook-handler-fields">
  フック ハンドラー フィールド
</h3>

内側の `hooks` 配列の各オブジェクトはフック ハンドラーです。matcher がマッチしたときに実行されるシェル コマンド、HTTP エンドポイント、MCP ツール、LLM プロンプト、またはエージェントです。5 つのタイプがあります。

* **[コマンド フック](#command-hook-fields)** （`type: "command"`）: シェル コマンドを実行します。スクリプトはイベントの [JSON 入力](#hook-input-and-output)を stdin で受け取り、終了コードと stdout を通じて結果を通信します。
* **[HTTP フック](#http-hook-fields)** （`type: "http"`）: イベントの JSON 入力を HTTP POST リクエストとして URL に送信します。エンドポイントは、コマンド フックと同じ [JSON 出力形式](#json-output)を使用して、レスポンス本体を通じて結果を通信します。
* **[MCP ツール フック](#mcp-tool-hook-fields)** （`type: "mcp_tool"`）: 設定済みの [MCP サーバー](/docs/ja/mcp)上のツールを呼び出します。ツールのテキスト出力はコマンド フック stdout のように扱われます。
* **[プロンプト フック](#prompt-and-agent-hook-fields)** （`type: "prompt"`）: Claude モデルにプロンプトを送信して、単一ターンの評価を行います。モデルは決定を JSON として返します。[プロンプト ベースのフック](#prompt-based-hooks)を参照してください。
* **[エージェント フック](#prompt-and-agent-hook-fields)** （`type: "agent"`）: Read、Grep、Glob などのツールを使用して条件を検証してから決定を返すことができるサブエージェントを生成します。エージェント フックは実験的であり、変更される可能性があります。[エージェント ベースのフック](#agent-based-hooks)を参照してください。

マッチしたすべてのフックは並列で実行されます。同じハンドラーを複数の設定ファイルで定義した場合、実行は 1 回だけです。プラグインまたはスキルが持つ同じハンドラーのコピーは別個のものとして扱われます。

ハンドラーは Claude Code の環境を持つ現在のディレクトリで実行されます。現在のディレクトリが存在しなくなった場合（たとえば、別のシェルがセッション中に削除した worktree や一時ディレクトリなど）、Claude Code は次のうち最初に存在するディレクトリからコマンドフックを実行します。セッションを開始したディレクトリ、プロジェクトルート、ホームディレクトリ、またはシステムの一時ディレクトリです。Claude Code は、フォールバック先のディレクトリ名を含む警告を[デバッグログ](#debug-hooks)に記録します。

`$CLAUDE_CODE_REMOTE` 環境変数はリモート Web 環境で `"true"` に設定され、ローカル CLI では設定されません。Claude Code v2.1.199 以降では、ローカルセッションにアクティブな Remote Control 接続がある間、[`$CLAUDE_CODE_BRIDGE_SESSION_ID`](/docs/ja/env-vars) が [Remote Control](/docs/ja/remote-control) のセッション ID に設定されます。

<h4 id="common-fields">
  共通フィールド
</h4>

これらのフィールドはすべてのフック タイプに適用されます。

| フィールド | 必須 | 説明 |
| :- | :- | :- |
| `type` | はい | `"command"`、`"http"`、`"mcp_tool"`、`"prompt"`、または `"agent"` |
| `if` | いいえ | `"Bash(git *)"` または `"Edit(*.ts)"` などの権限ルール構文を使用してこのフックが実行されるタイミングをフィルタリングします。ツール呼び出しがパターンにマッチする場合のみ、フック コマンドが実行されます。Bash パターンがサブコマンド、`$()`、バッククォートに対してどのように評価されるかについては、後述の [Bash マッチング テーブル](#bash-if-matching)を参照してください。ツール イベントでのみ評価されます。`PreToolUse`、`PostToolUse`、`PostToolUseFailure`、`PermissionRequest`、`PermissionDenied`。他のイベントでは、`if` が設定されたフックは実行されません。[権限ルール](/docs/ja/permissions)と同じ構文を使用します |
| `timeout` | いいえ | キャンセルまでの秒数。[`async: true`](#run-hooks-in-the-background) で実行するコマンドフックには、Claude Code はこれを適用しません。デフォルト: `command`、`http`、`mcp_tool` は 600、`prompt` は 30、`agent` は 60。Claude Code は、[`UserPromptSubmit`](#userpromptsubmit)、[`PreModelSwitch`](#premodelswitch)、[`PostModelSwitch`](#postmodelswitch) では `command`、`http`、`mcp_tool` のデフォルトを 30 に、[`MessageDisplay`](#messagedisplay) では 10 に下げます。[`SessionEnd`](#sessionend) フックは 1.5 秒の予算を共有します。設定でフックごとにより長い `timeout` を指定している場合、Claude Code は最大 60 秒までそれに合わせて予算を引き上げます |
| `statusMessage` | いいえ | フックの実行中に表示されるカスタム スピナー メッセージ |
| `once` | いいえ | `true` の場合、Claude Code は最初の実行が成功した後にフックを削除します。失敗した実行、終了コード 2 でブロックした実行、またはタイムアウトした実行ではフックがそのまま残るため、次にマッチするイベントで再び実行されます。[スキルのフロントマター](#hooks-in-skills-and-agents)で宣言されたフックでのみ有効です。設定ファイルとエージェントのフロントマターでは無視されます |

`if` フィールドは正確に 1 つの権限ルールを保持します。ルールを組み合わせるための `&&`、`||`、またはリスト構文はありません。複数の条件を適用するには、各条件に対して個別のフック ハンドラーを定義します。

ファイルツールの `if` 条件では、`"Edit(src/**)"` のような単一セグメントのディレクトリパターンは、作業ディレクトリ内の `src` ディレクトリとその配下のファイルにのみマッチします。任意の深さにある `src` という名前のディレクトリにマッチさせるには、`"Edit(**/src/**)"` と記述します。v2.1.214 より前は、`"Edit(src/**)"` は作業ディレクトリ配下の任意の深さにある `src` という名前のディレクトリにマッチしていました。

<span id="bash-if-matching" />Bash パターンの場合、フック コマンドが実行されるかどうかは、パターンの形状と Claude が呼び出している Bash コマンドに依存します。先頭の `VAR=value` 割り当ては、マッチング前に削除されます。

| `if` パターン | Bash コマンド | フックが実行されるか | 理由 |
| :- | :- | :- | :- |
| `Bash(git *)` | `FOO=bar git push` | はい | 先頭の割り当ては削除されます。`git push` がマッチします |
| `Bash(git *)` | `npm test && git push` | はい | 各サブコマンドがチェックされます。`git push` がマッチします |
| `Bash(rm *)` | `echo $(rm -rf /)` | はい | `$()` とバッククォート内のコマンドがチェックされます。`rm -rf /` がマッチします |
| `Bash(rm *)` | `echo $(date)` | いいえ | サブコマンドが `rm *` にマッチしません |
| `Bash(git push *)` | `echo $(date)` | はい | コマンド名以上を指定するパターンは、`$()`、バッククォート、または `$VAR` でとにかくフックを実行します |

Bash 入力がどのコマンドを実行するかを Claude Code が判断できない場合、パターンに関係なくフックを実行します。`if` フィルターはベストエフォートであるため、ハードな許可または拒否を強制するには、フックではなく[権限システム](/docs/ja/permissions)を使用してください。

<h4 id="command-hook-fields">
  コマンド フック フィールド
</h4>

[共通フィールド](#common-fields)に加えて、コマンド フックはこれらのフィールドを受け入れます。

| フィールド | 必須 | 説明 |
| :- | :- | :- |
| `command` | はい | 実行するシェル コマンド。`args` を使用する場合、直接生成する実行可能ファイル。[Exec フォームとシェル フォーム](#exec-form-and-shell-form)を参照してください |
| `args` | いいえ | 引数リスト。存在する場合、`command` は実行可能ファイルとして解決され、`args` を引数ベクトルとして直接生成されます。シェルは関与しません。[Exec フォームとシェル フォーム](#exec-form-and-shell-form)を参照してください |
| `async` | いいえ | `true` の場合、ブロックせずにバックグラウンドで実行されます。[バックグラウンドでフックを実行](#run-hooks-in-the-background)を参照してください |
| `asyncRewake` | いいえ | `true` の場合、バックグラウンドで実行され、終了コード 2 で Claude を起動します。フックの stderr、または stderr が空の場合は stdout が [システムリマインダー](/docs/ja/glossary#system-reminder)として Claude に表示されるため、Claude は長時間実行されるバックグラウンドの失敗に対応できます |
| `shell` | いいえ | このフックに使用するシェル。`"bash"` または `"powershell"` を受け入れます。デフォルトは `"bash"`、または Git Bash がインストールされていない場合は Windows で `"powershell"`。`"powershell"` を設定すると、Windows 上で PowerShell 経由でコマンドが実行されます。フックは PowerShell を直接生成するため、`CLAUDE_CODE_USE_POWERSHELL_TOOL` は不要です。`args` が設定されている場合は無視されます |

<a id="exec-form-and-shell-form" />

<h5 id="exec-form-and-shell-form">
  Exec フォームとシェル フォーム
</h5>

コマンド フックは `args` が設定されている場合は exec フォームで実行され、`args` が省略されている場合はシェル フォームで実行されます。フックが[パス プレースホルダー](#reference-scripts-by-path)を参照する場合は常に `args` を設定してください。各要素は引用符なしで 1 つの引数として渡されるためです。パイプや `&&` などのシェル機能が必要な場合、または両方の懸念が適用されない場合は `args` を省略してください。

**Exec フォーム**は `args` が存在する場合に実行されます。Claude Code は `command` を `PATH` 上の実行可能ファイルとして解決し、`args` を引数ベクトルとして直接生成します。シェルがないため、各 `args` 要素は記述されたとおりに正確に 1 つの引数であり、`${CLAUDE_PLUGIN_ROOT}` などのパス プレースホルダーは `command` と各 `args` 要素にプレーン文字列として置換されます。アポストロフィ、`$`、バッククォートなどの特殊文字は、シェルが解釈しないため、そのまま渡されます。どのプラットフォームでもシェル トークン化は発生しません。

**シェル フォーム**は `args` が存在しない場合に実行されます。`command` 文字列はシェルに渡されます。macOS と Linux では `sh -c`、Windows では Git Bash、または Git Bash がインストールされていない場合は PowerShell。`shell` フィールドを設定して明示的に選択します。シェルは文字列をトークン化し、変数を展開し、パイプ、`&&`、リダイレクト、グロブを解釈します。

<Note>
  Windows では、exec フォームは `command` が `.exe` などの実際の実行可能ファイルに解決されることが必要です。npm、npx、eslint、およびその他のツールが `node_modules/.bin` にインストールする `.cmd` と `.bat` シムは実行可能ファイルではなく、シェルなしで生成することはできません。exec フォームでそれらを実行するには、基になるスクリプトを `node` で直接呼び出します。例えば `"command": "node", "args": ["${CLAUDE_PLUGIN_ROOT}/node_modules/eslint/bin/eslint.js"]`。`node` プラス スクリプト パス パターンは、`node.exe` が実際のバイナリであるため、すべてのプラットフォームで機能します。`.cmd` または `.bat` シムを名前で実行するには、シェル フォームを使用します。
</Note>

この例は、プラグインにバンドルされた Node スクリプトを実行します。Exec フォームは解決されたスクリプト パスを引用符なしで 1 つの引数として渡します。

```json theme={null}
{
  "type": "command",
  "command": "node",
  "args": ["${CLAUDE_PLUGIN_ROOT}/scripts/format.js", "--fix"]
}
```

同等のシェル フォームは、スペースまたは特殊文字を含むパスを処理するために引用符が必要です。

```json theme={null}
{
  "type": "command",
  "command": "node \"${CLAUDE_PLUGIN_ROOT}\"/scripts/format.js --fix"
}
```

両方のフォームは同じ[パス プレースホルダー](#reference-scripts-by-path)をサポートし、両方とも生成されたプロセスで環境変数 `CLAUDE_PROJECT_DIR`、`CLAUDE_PLUGIN_ROOT`、`CLAUDE_PLUGIN_DATA` としてエクスポートするため、スクリプトは起動方法に関係なく `process.env.CLAUDE_PLUGIN_ROOT` を読み取ることができます。

プラグイン フックは追加で [`${user_config.*}`](/docs/ja/plugins/manifest-reference#user-configuration) 値を置換します。exec フォームのみ: 値は `command` と各 `args` 要素にプレーン文字列として置換されるため、シェルは再解析しません。

`command` が `${user_config.*}` を参照するシェル フォームのプラグイン フックは、実行される代わりに[エラー](/docs/ja/errors#plugin-command-references-user-config)で失敗します。シェル フォーム フックからオプション値を使用するには、`$CLAUDE_PLUGIN_OPTION_<KEY>` 環境変数（`webhook_url` オプションの場合は `$CLAUDE_PLUGIN_OPTION_WEBHOOK_URL` など）を読み取るか、`args` を設定してフックを exec フォームに切り替えます。v2.1.207 より前では、シェル フォーム プラグイン フック コマンドも `${user_config.*}` を置換していました。

<Note>
  Exec フォームでは、`command` は実行可能ファイル名またはパスのみです。`args` とともに使用される `command` がパス区切り文字を含まないベア名で、かつ空白を含む場合、生成が失敗するため Claude Code は警告をログに記録します。`node script.js` という名前の実行可能ファイルは存在しないためです。余分なトークンを `args` に移動してください。`C:\Program Files\nodejs\node.exe` などのスペースを含む絶対パスは、単一の有効な実行可能ファイルであり、警告をトリガーしません。
</Note>

<h4 id="http-hook-fields">
  HTTP フック フィールド
</h4>

[共通フィールド](#common-fields)に加えて、HTTP フックはこれらのフィールドを受け入れます。

| フィールド | 必須 | 説明 |
| :- | :- | :- |
| `url` | はい | POST リクエストを送信する URL |
| `headers` | いいえ | キー値ペアとしての追加 HTTP ヘッダー。値は `$VAR_NAME` または `${VAR_NAME}` 構文を使用した環境変数補間をサポートします。`allowedEnvVars` にリストされている変数のみが解決されます |
| `allowedEnvVars` | いいえ | ヘッダー値に補間される可能性のある環境変数名のリスト。リストされていない変数への参照は空の文字列に置き換えられます。環境変数補間が機能するために必須 |

Claude Code はフックの [JSON 入力](#hook-input-and-output)を `Content-Type: application/json` の POST リクエスト本体として送信します。レスポンス本体はコマンド フックと同じ [JSON 出力形式](#json-output)を使用します。

エラー処理はコマンド フックと異なります。[HTTP レスポンスの処理](#http-response-handling)を参照してください。

この例は `PreToolUse` イベントをローカル検証サービスに送信し、`MY_TOKEN` 環境変数からのトークンで認証します。

```json theme={null}
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "http",
            "url": "http://localhost:8080/hooks/pre-tool-use",
            "timeout": 30,
            "headers": {
              "Authorization": "Bearer $MY_TOKEN"
            },
            "allowedEnvVars": ["MY_TOKEN"]
          }
        ]
      }
    ]
  }
}
```

<h4 id="mcp-tool-hook-fields">
  MCP ツール フック フィールド
</h4>

[共通フィールド](#common-fields)に加えて、MCP ツール フックはこれらのフィールドを受け入れます。

| フィールド | 必須 | 説明 |
| :- | :- | :- |
| `server` | はい | 設定された MCP サーバーの名前。[プラグイン バンドル サーバー](/docs/ja/mcp#plugin-provided-mcp-servers)の場合、これはスコープ付き名前 `plugin:<plugin-name>:<server-name>`（例：`plugin:my-plugin:db`）であり、ベア サーバー キーではありません |
| `tool` | はい | そのサーバー上で呼び出すツールの名前 |
| `input` | いいえ | ツールに渡される引数。文字列値は、フックの [JSON 入力](#hook-input-and-output)から `${path}` 置換をサポートします（例：`"${tool_input.file_path}"`） |

この例は、各 `Write` または `Edit` の後、`my_server` MCP サーバー上の `security_scan` ツールを呼び出し、編集されたファイルのパスを渡します。

```json theme={null}
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "mcp_tool",
            "server": "my_server",
            "tool": "security_scan",
            "input": { "file_path": "${tool_input.file_path}" }
          }
        ]
      }
    ]
  }
}
```

<h5 id="how-the-tool’s-result-is-read">
  ツールの結果の読み取り方
</h5>

Claude Code は、[終了コード 0 の解析ルール](#exit-code-0)に従い、コマンドフックの stdout と同じ方法でツールのテキストコンテンツを読み取ります。ツールが `isError: true` を返した場合、フックは非ブロッキングエラーを生成し、実行は続行されます。

<h5 id="when-the-server-is-still-connecting">
  サーバーがまだ接続中の場合
</h5>

`PreToolUse` や `Stop` など、フックが結果をブロックまたは変更できるイベントでは、Claude Code は接続中のサーバーを待ってからツールを呼び出します。待機時間は最大で [`MCP_TIMEOUT`](/docs/ja/env-vars) までで、フック自体の [`timeout`](#common-fields) の範囲内です。`Notification` や `SessionEnd` などの観察用イベントでは待機しません。

[`cached` ステータス](/docs/ja/mcp#server-status-detail)を表示しているサーバーは、フックがそのツールを呼び出したときに接続します。その時点でサーバーが接続されていない場合、フックは非ブロッキングエラーを生成し、実行は続行されます。フックが OAuth フローを開始することはないため、先に [`/mcp` からサーバーを認証](/docs/ja/mcp#authenticate-with-remote-mcp-servers)してください。

<h5 id="events-that-fire-before-mcp-servers-are-available">
  MCP サーバーが利用可能になる前に発火するイベント
</h5>

起動時の `SessionStart`（`--continue` や `--resume` の場合を含む）とすべての `Setup` イベントは、セッションの MCP サーバーがフックから利用可能になる前に発火します。Claude Code はツールを呼び出さずにこれらの `mcp_tool` フックをスキップし、[デバッグログ](#debug-hooks)には `mcp_tool hooks are not available for the 'SessionStart' hook event (no MCP client context)`、または `Setup` を示す同じメッセージが記録されます。`/clear` やコンテキスト圧縮の後など、セッションの後半で `SessionStart` が再び発火した場合は、その `mcp_tool` フックが実行されます。セッションが起動時に必要とするものについては、代わりに `SessionStart` で `type: "command"` フックを使用してください。

<h4 id="prompt-and-agent-hook-fields">
  プロンプト フックとエージェント フック フィールド
</h4>

[共通フィールド](#common-fields)に加えて、プロンプト フックとエージェント フックはこれらのフィールドを受け入れます。

| フィールド | 必須 | 説明 |
| :- | :- | :- |
| `prompt` | はい | モデルに送信するプロンプト テキスト。フック入力 JSON のプレースホルダーとして `$ARGUMENTS` を使用します。バックスラッシュでエスケープしてリテラル テキストを含めます。`\$1.00` は `$1.00` としてレンダリングされます |
| `model` | いいえ | 評価に使用するモデル。デフォルトは、Claude Code が[バックグラウンド機能](/docs/ja/costs#background-token-usage)に使用するモデル |

<h3 id="reference-scripts-by-path">
  パスでフック スクリプトを参照
</h3>

フックが実行されるときの作業ディレクトリに関係なく、プロジェクトまたはプラグイン ルートを基準にしてフック スクリプトを参照するには、これらのプレースホルダーを使用します。

* `${CLAUDE_PROJECT_DIR}`: セッションを開始したプロジェクトルート。Claude Code はこの変数を [stdio MCP サーバー](/docs/ja/mcp#option-3-add-a-local-stdio-server)とプラグイン LSP サーバーの環境にも設定します。
* `${CLAUDE_PLUGIN_ROOT}`: プラグインのインストールディレクトリ。[プラグイン](/docs/ja/plugins/overview)にバンドルされたスクリプト用です。更新時にこのパスがどう扱われるかについては、[プラグインの環境変数](/docs/ja/plugins/manifest-reference#environment-variables)を参照してください。
* `${CLAUDE_PLUGIN_DATA}`: プラグインの[永続データディレクトリ](/docs/ja/plugins/components#path-variables-and-persistent-data)。プラグインの更新後も保持すべき依存関係と状態用です。

<Note>
  **worktree の場合は異なります。** セッション中に Claude が [worktree](/docs/ja/worktrees) に入った場合、Claude Code は `${CLAUDE_PROJECT_DIR}` を元の場所のまま維持し、worktree のパスは別の方法でフックに渡します。

  * **`${CLAUDE_PROJECT_DIR}` は変わらない**: セッションを開始したプロジェクトルートを引き続き指すため、`${CLAUDE_PROJECT_DIR}/.claude/hooks/check-style.sh` のようなコマンドは、引き続きメインのチェックアウト内のスクリプトを実行します。
  * **`cwd` は Claude に追従する**: フックの[入力 JSON](#common-input-fields) の `cwd` フィールドは、Claude が worktree に入った後はその worktree のルートになり、Claude が `cd` を実行した後は新しいディレクトリになります。Claude がどのディレクトリで作業しているかをフックが知る必要がある場合は、このフィールドを読み取ってください。
</Note>

パス プレースホルダーを参照するフックには [exec フォーム](#exec-form-and-shell-form)を優先してください。シェル フォームでは、各プレースホルダーをダブル クォートで囲みます。

<Tabs>
  <Tab title="プロジェクト スクリプト">
    この例は `${CLAUDE_PROJECT_DIR}` を使用して、`Write` または `Edit` ツール呼び出しの後、プロジェクトの `.claude/hooks/` ディレクトリからスタイル チェッカーを実行します。

    ```json theme={null}
    {
      "hooks": {
        "PostToolUse": [
          {
            "matcher": "Write|Edit",
            "hooks": [
              {
                "type": "command",
                "command": "${CLAUDE_PROJECT_DIR}/.claude/hooks/check-style.sh",
                "args": []
              }
            ]
          }
        ]
      }
    }
    ```
  </Tab>

  <Tab title="プラグイン スクリプト">
    `hooks/hooks.json` でプラグイン フックを定義し、オプションのトップレベル `description` フィールドを使用します。プラグインが有効な場合、そのフックはユーザーおよびプロジェクト フックとマージされます。

    この例は、プラグインにバンドルされたフォーマット スクリプトを実行します。

    ```json theme={null}
    {
      "description": "Automatic code formatting",
      "hooks": {
        "PostToolUse": [
          {
            "matcher": "Write|Edit",
            "hooks": [
              {
                "type": "command",
                "command": "${CLAUDE_PLUGIN_ROOT}/scripts/format.sh",
                "args": [],
                "timeout": 30
              }
            ]
          }
        ]
      }
    }
    ```

    プラグイン フックの作成の詳細については、[プラグイン コンポーネント リファレンス](/docs/ja/plugins/components#hooks)を参照してください。
  </Tab>
</Tabs>

<h3 id="hooks-in-skills-and-agents">
  スキルとエージェントのフック
</h3>

設定ファイルとプラグインに加えて、フックは[スキル](/docs/ja/skills)と[サブエージェント](/docs/ja/sub-agents)でフロントマターを使用して直接定義できます。設定形式は設定ベースのフックと同じです。Claude Code がこれらを登録しておく期間は、コンポーネントによって異なります。

* **サブエージェントのフック**: Claude Code は、そのサブエージェントの実行中にのみこれらを実行し、サブエージェントが終了すると削除します。ここでの `Stop` フックは、Claude Code によって `SubagentStop` に変換されます。これはサブエージェントが完了したときに発火するイベントです。
* **スキルのフック**: Claude Code は、ユーザーまたは Claude がスキルを呼び出したときにこれらを登録し、スキル自体のターンの後のターンも含めて、セッションの残りの期間ずっと実行し続けます。代わりに最初の実行が成功した後で Claude Code にフックを削除させるには、そのフックに [`once: true`](#common-fields) を設定します。

このスキルは、各 `Bash` コマンドの前にセキュリティ検証スクリプトを実行する `PreToolUse` フックを定義します。

```yaml theme={null}
---
name: secure-operations
description: Perform operations with security checks
hooks:
  PreToolUse:
    - matcher: "Bash"
      hooks:
        - type: command
          command: "./scripts/security-check.sh"
---
```

サブエージェントは YAML フロントマターで同じ形式を使用します。

プロジェクトスキルのフロントマターのフックは、[設定ファイルのフックと同じワークスペース信頼ルール](#workspace-trust)に従います。Claude Code は、ユーザーまたは Claude がスキルを呼び出したときにこれらを登録します。これには、信頼していないフォルダーでの `-p` 実行も含まれます。

プロジェクトサブエージェントのフロントマターのフックは、エージェントファイルの取得元フォルダーについて[ワークスペース信頼ダイアログ](/docs/ja/permissions#project-allow-rules-and-workspace-trust)を承認した後にのみ実行されます。`-p` セッションは承認したことになりません。[フォルダーを信頼する前に実行されるもの](/docs/ja/permissions#what-runs-before-you-trust-a-folder)ではこれを設定ファイルのルールと比較しており、サブエージェントのページには[どのスコープが対象外か](/docs/ja/sub-agents#hooks-in-subagent-frontmatter)が記載されています。v2.1.218 より前は、これらのフックは信頼していないフォルダーからも実行される可能性がありました。

<h3 id="the-/hooks-menu">
  `/hooks` メニュー
</h3>

Claude Code で `/hooks` と入力して、設定されたフックの読み取り専用ブラウザーを開きます。リストでは、各フックにその取得元（ユーザー設定、プロジェクト設定、ローカル設定、プラグイン、現在のセッションなど）を示すラベルが付けられます。

フックを選択すると、そのフックが実行する内容の全文と、定義されている場所（設定ファイルのパスやプラグインの名前など）が表示されます。

フックが設定されていないものも含めてすべてのフック イベントを参照するには、リストの末尾にある `All events` を選択します。

<h3 id="disable-or-remove-hooks">
  フックを無効化または削除
</h3>

設定ファイルで定義されたフックを削除するには、そのファイルからエントリを削除します。

すべてのフックを削除せずに一時的に無効化するには、設定ファイルで `"disableAllHooks": true` を設定します。Claude Code は[設定の優先順位](/docs/ja/settings#settings-precedence)を適用した後に残る値を読み取るため、プロジェクトの `.claude/settings.json` にある `"disableAllHooks": false` は、ユーザー設定の `true` を上書きします。プロジェクトの設定内容にかかわらず 1 回の実行だけフックをオフにするには、`--settings '{"disableAllHooks": true}'` を渡します。これはプロジェクト設定とローカル設定よりも優先されます。個別のフックを設定に保持したまま無効化する方法はありません。

`disableAllHooks` 設定は管理設定階層を尊重します。管理者が管理ポリシー設定を通じてフックを設定している場合、ユーザー、プロジェクト、またはローカル設定で設定された `disableAllHooks` は、それらの管理フックを無効化できません。管理設定レベルで設定された `disableAllHooks` のみが管理フックを無効化できます。各レベルの影響範囲の詳細については、[`disableAllHooks`](/docs/ja/settings-reference#disableallhooks) を参照してください。

設定ファイルのフックへの直接編集は通常、ファイル ウォッチャーによって自動的に取得されます。

<h2 id="hook-input-and-output">
  フック入出力
</h2>

コマンド フックは stdin 経由で JSON データを受け取り、終了コード、stdout、stderr を通じて結果を通信します。HTTP フックは同じ JSON を POST リクエスト本体として受け取り、HTTP レスポンス本体を通じて結果を通信します。このセクションでは、すべてのイベントに共通するフィールドと動作について説明します。[フック イベント](#hook-events)の各セクションには、その特定の入力スキーマと決定制御オプションが含まれています。

macOS と Linux では、コマンド フックは制御ターミナルのない独自のセッションで実行されます。フック プロセスと子プロセスは `/dev/tty` を開くことも、エスケープ シーケンスを Claude Code インターフェイスに直接送信することもできません。Windows には `/dev/tty` がありません。

任意のプラットフォームでユーザーにメッセージを表示するには、JSON 出力で [`systemMessage`](#json-output) を返します。一部のイベントはこれを破棄するか別の場所に配信します。その点は各[イベントのセクション](#hook-events)に記載されています。デスクトップ通知をトリガーしたり、ウィンドウ タイトルを設定したり、ベルを鳴らしたりするには、代わりに [`terminalSequence`](#emit-terminal-notifications) を返します。

<h3 id="common-input-fields">
  共通入力フィールド
</h3>

フック イベントは、各[フック イベント](#hook-events)セクションで説明されているイベント固有のフィールドに加えて、これらのフィールドを JSON として受け取ります。コマンド フックの場合、この JSON は stdin 経由で到着します。HTTP フックの場合、POST リクエスト本体として到着します。

| フィールド | 説明 |
| :- | :- |
| `session_id` | 現在のセッション識別子 |
| `prompt_id` | 現在処理中のユーザー プロンプトを識別する UUID。[OpenTelemetry イベントの `prompt.id` 属性](/docs/ja/monitoring-usage#event-correlation-attributes)と一致するため、単一のプロンプトのテレメトリでフック出力を相関させることができます。最初のユーザー入力まで存在しません。Claude Code v2.1.196 以降が必要です |
| `transcript_path` | 会話 JSON へのパス。トランスクリプト ファイルは非同期に書き込まれ、メモリ内の会話に遅れる可能性があるため、フックが発火するときに現在のターンの最新メッセージがまだ含まれていない可能性があります。現在のターンの最終的なアシスタント テキストが必要なフックは、トランスクリプトを読む代わりに [Stop](#stop) と [SubagentStop](#subagentstop) の `last_assistant_message` を使用する必要があります |
| `cwd` | フックが呼び出されるときの現在の作業ディレクトリ |
| `scratchpad_dir` | セッションの[スクラッチパッド ディレクトリ](/docs/ja/claude-directory#session-scratchpad-directory)へのパス。Claude はここに一時的な作業ファイルを保持します。セッションにスクラッチパッドがない場合、または一時ディレクトリが利用できない場合は存在しません。Claude Code v2.1.257 以降が必要です |
| `permission_mode` | 現在の[権限モード](/docs/ja/permissions#permission-modes): `"default"`、`"plan"`、`"acceptEdits"`、`"auto"`、`"dontAsk"`、または `"bypassPermissions"`。**Manual** というラベルが付いたモードは `"default"` として到着し、`"manual"` として到着することはないため、`"default"` と一致するスクリプトは引き続き機能します。すべてのイベントがこのフィールドを受け取るわけではありません。各[フック イベント](#hook-events)セクションの JSON 例を確認してください |
| `effort` | フックの実行時に有効な [effort レベル](/docs/ja/model-config#adjust-effort-level)を保持する `level` フィールドを持つオブジェクト: `"low"`、`"medium"`、`"high"`、`"xhigh"`、または `"max"`。アクティブなモデルがサポートしていないレベルを設定した場合、`level` は Claude Code が代わりに実行したレベルを報告します。そのレベルの選び方については [effort レベルを調整](/docs/ja/model-config#adjust-effort-level)を参照してください。オブジェクトは[ステータスライン](/docs/ja/statusline#available-data)の `effort` フィールドと一致します。現在のモデルが effort パラメータをサポートしている場合、`PreToolUse`、`PostToolUse`、`Stop`、`SubagentStop` などのツール使用コンテキスト内で発火するイベントに存在します。レベルは、フック コマンドと Bash ツールでも `$CLAUDE_EFFORT` 環境変数として利用可能です。 |
| `hook_event_name` | 発火したイベントの名前 |

`--agent` で実行するか、サブエージェント内で実行する場合、2 つの追加フィールドが含まれます。

| フィールド | 説明 |
| :- | :- |
| `agent_id` | サブエージェントの一意の識別子。フックがサブエージェント呼び出し内で発火する場合にのみ存在します。これを使用して、サブエージェント フック呼び出しをメイン スレッド呼び出しから区別します。 |
| `agent_type` | エージェント名（例えば、`"Explore"` または `"security-reviewer"`）。セッションが `--agent` を使用するか、フックがサブエージェント内で発火する場合に存在します。サブエージェントの場合、サブエージェントのタイプがセッションの `--agent` 値よりも優先されます。カスタム サブエージェントとプラグイン サブエージェントが報告する値と、プラグイン スコープ名に対する matcher の記述方法については、[SubagentStart](#subagentstart) を参照してください。 |

[`SessionStart`](#sessionstart) フックのみが `model` フィールドを受け取ることができ、Claude Code が常にそれを含めるとは限りません。[`PreModelSwitch`](#premodelswitch) と [`PostModelSwitch`](#postmodelswitch) フックは代わりに `from_model` と `to_model` を受け取るため、セッション中に変化するモデルを追跡するには PostModelSwitch フックを使用してください。

`$CLAUDE_MODEL` 環境変数はありません。シェルで `$ANTHROPIC_MODEL` を設定した場合、フックはそれを読み取ることができますが、セッション中に `/model` でモデルを切り替えてもその値は変わりません。

フック プロセスは親環境を継承します。ただし、Claude Code が[起動するすべてのサブプロセスから削除する](/docs/ja/monitoring-usage#administrator-configuration) `OTEL_*` エクスポーター変数と、[`CLAUDE_CODE_SUBPROCESS_ENV_SCRUB`](/docs/ja/env-vars#variables) が `1` に設定されている場合に除去される変数は除きます。

例えば、Bash コマンドの `PreToolUse` フックは stdin で以下を受け取ります。

```json theme={null}
{
  "session_id": "abc123",
  "prompt_id": "550e8400-e29b-41d4-a716-446655440000",
  "transcript_path": "/home/user/.claude/projects/.../transcript.jsonl",
  "cwd": "/home/user/my-project",
  "scratchpad_dir": "/tmp/claude-1000/-home-user-my-project/abc123/scratchpad",
  "permission_mode": "default",
  "hook_event_name": "PreToolUse",
  "tool_name": "Bash",
  "tool_input": {
    "command": "npm test",
    "description": "Run test suite",
    "timeout": 120000,
    "run_in_background": false
  },
  "tool_use_id": "toolu_01ABC123..."
}
```

`tool_name`、`tool_input`、`tool_use_id` フィールドはイベント固有です。各[フック イベント](#hook-events)セクションでは、そのイベントの追加フィールドについて説明しています。

<h3 id="exit-code-output">
  終了コード出力
</h3>

フック コマンドからの終了コードは、Claude Code にアクションが進行すべきか、ブロックされるべきか、無視されるべきかを伝えます。終了コードは単独で作用するわけではありません。Claude Code は 0 だけでなくすべての終了コードで stdout から [JSON 出力フィールド](#json-output)を読み取ります。標準の決定モデルを使用するイベントでは、解析されたオブジェクトがスキーマ検証に合格すると、終了コードとともに効果を持ちます。終了 2 によるブロックは、JSON で上書きできない唯一の結果です。

イベントごとの例外は 2 つの表にまとめられています。[イベントごとの終了コード 2 動作](#exit-code-2-behavior-per-event)は各イベントで終了コードが何をするかを示し、[決定制御](#decision-control)は各イベントがどの決定フィールドを尊重するかを示します。`systemMessage` などのユニバーサル フィールドはほとんどのイベントで機能し、[JSON 出力](#json-output)の表にリストされています。

<h4 id="exit-code-0">
  終了コード 0
</h4>

終了 0 は成功を意味し、構造化制御のために JSON を出力する場合に想定される終了コードです。

ほとんどのイベントでは、Claude Code は stdout をデバッグ ログに書き込み、トランスクリプトには表示しません。例外は `UserPromptSubmit`、`UserPromptExpansion`、`SessionStart`、`PostModelSwitch` で、Claude Code はプレーン テキストの stdout を Claude が見て行動できるコンテキストとして追加します。

Claude Code が stdout を [JSON 出力](#json-output)として読み取るかプレーン テキストとして読み取るかは、前後の空白を無視したうえで、その開始と終了の文字によって決まります。

* **`{` で始まり `}` で終わる**: Claude Code は JSON として解析します。出力が 2 行以上で、各行が単独で JSON として解析でき、どの行もフィールドを設定する [JSON 出力](#json-output)オブジェクトでない場合、Claude Code は出力全体をプレーン テキストとして扱います。それらの行のいずれかがフィールドを設定している場合、出力全体は解析失敗となります（後述）。
* **`{` で始まるが `}` で終わらない**: Claude Code はプレーン テキストとして扱います。
* **その他の文字で始まる**: JSON 配列や引用符で囲まれた JSON 文字列を含め、Claude Code はプレーン テキストとして扱います。

標準の決定モデルを使用するイベントでは、終了 0 で解析されたオブジェクトがスキーマ検証に失敗した場合は非ブロッキング エラーとなります。アクションは進行し、トランスクリプトには検証メッセージとともに `<hook name> hook error` 通知が表示されます。2 以外のすべての終了コードでも同じことが起こりますが、[終了 2 は引き続きブロックします](#exit-code-2)。

標準の決定モデルを使用するイベントでは、Claude Code が stdout を JSON として解析しようとして失敗した場合、2 以外のすべての終了コードで非ブロッキング エラーを報告します。トランスクリプトには解析メッセージとともに `<hook name> hook error` 通知が表示されます。プレーン テキストの stdout をコンテキストとして追加するイベントでは、Claude Code はそのテキストを追加しません。v2.1.248 より前は、Claude Code はその stdout をプレーン テキストとして扱っていました。

終了 0 のフックからの stderr はデバッグ ログにのみ送られ、トランスクリプトには表示されず、Claude がそれを見ることはありません。自分で読むには、[デバッグ ログ](#debug-hooks)を有効にしてください。`PostToolUse` または `PostToolUseFailure` フックから Claude に警告を表示するには、代わりに終了 2 を使用してください。そうすれば、ツールがすでに実行されていても [Claude は stderr を確認できます](#exit-code-2-behavior-per-event)。

<h4 id="exit-code-2">
  終了コード 2
</h4>

終了 2 はブロッキング エラーを意味します。[ブロック可能なイベント](#exit-code-2-behavior-per-event)では、JSON を出力するかどうかにかかわらず終了 2 はブロックします。JSON の `permissionDecision` が `"allow"` であっても上書きできません。Claude Code は stdout 上の有効な [JSON 出力](#json-output)を引き続き読み取ります。`Elicitation` と `ElicitationResult` では、終了 2 のフックの `hookSpecificOutput` は無視されます。

ブロッキング メッセージは、JSON がブロッキング決定を行う場合はその理由、それ以外の場合は stderr テキストです。ブロックの効果はイベントによって異なります。`PreToolUse` はツール呼び出しをブロックし、`UserPromptSubmit` はプロンプトを拒否する、などです。[イベントごとの終了コード 2 動作](#exit-code-2-behavior-per-event)にはすべてのイベントの効果がリストされており、各イベントのセクションにはメッセージの送信先が記載されています。

[JSON 出力](#json-output)のスキーマ検証に失敗する JSON を出力しながら終了 2 するフックは、引き続きブロックします。Claude Code は stderr をブロッキング理由として使用し、検証の失敗をデバッグ ログに記録します。v2.1.214 より前は、Claude Code はその組み合わせを非ブロッキング エラーとして扱い、アクションは進行していました。

このスクリプトは終了 2 によって `rm` コマンドをブロックし、それ以外のすべてのコマンドは通常の権限フローに任せます。

```bash theme={null}
#!/bin/bash
# Reads JSON input from stdin, checks the command
input=$(cat)
command=$(jq -r '.tool_input.command' <<<"$input")

if [[ "$command" == rm* ]]; then
  echo "Blocked: rm commands are not allowed" >&2
  exit 2  # Blocking error: tool call is prevented
fi

exit 0  # No decision: the normal permission flow applies
```

<h4 id="other-exit-codes">
  その他の終了コード
</h4>

その他の終了コードは、ほとんどのフック イベントでそれ自体ではブロックしません。何が起こるかは stdout によって異なります。

* 標準の決定モデルを使用するイベントで、解析されたオブジェクトがスキーマ検証に合格した場合、Claude Code は終了コードを無視し、JSON のみが結果を決定します。
  * イベントがサポートする各フィールド（`permissionDecision`、`additionalContext`、`updatedInput`、`systemMessage` を含む）が尊重され、フックはエラーとして報告されません。
  * [決定制御](#decision-control)にはイベントごとの決定フィールドがリストされています。`systemMessage` などのユニバーサル フィールドは [JSON 出力](#json-output)の表に従います。
* 標準の決定モデルを使用するイベントで、解析されたオブジェクトがスキーマ検証に失敗した場合、[終了 0 の場合](#exit-code-0)と同じ非ブロッキング エラーになります。アクションは進行し、`<hook name> hook error` 通知に検証メッセージが含まれます。
* Claude Code が [JSON として解析しようとして](#exit-code-0)失敗した stdout の場合、標準の決定モデルを使用するイベントでは、Claude Code は終了 0 の場合と同じ非ブロッキング エラーを報告します。アクションは進行し、通知に解析メッセージが含まれます。
* Claude Code が[プレーン テキストとして扱う](#exit-code-0) stdout、または空の stdout の場合、ほとんどのフック イベントで非ブロッキング エラーとなります。アクションは進行し、トランスクリプトには `<hook name> hook error` 通知と、その後に `Failed with non-blocking status code:` というプレフィックスが付いた stderr の最初の行が表示されます。完全な stderr を取得するには、[デバッグ ログ](#debug-hooks)を有効にしてください。

標準の決定モデルに含まれないイベントは、[イベントごとの表](#exit-code-2-behavior-per-event)の独自の行に従います。`WorktreeCreate` は JSON の内容にかかわらず 0 以外の終了で作成に失敗し、`StopFailure` のようにフック出力を完全に破棄するイベントは、すべての終了コードで JSON を無視します。ただし、`terminalSequence` のような副作用フィールドは引き続き発火します。

起動できないフックも同じ非ブロッキングの扱いになります。スクリプト パスが存在しないか実行可能でない場合、シェルは 127 などのコードで終了し、インタープリターのメッセージとともに同じ通知が表示されます（例: `Failed with non-blocking status code: /bin/sh: /path/to/hook.sh: No such file or directory`）。ほとんどのフック イベントでは、アクションは進行します。ポリシー フックを設定するときは、最初の実行時にこの通知に注意してください。`settings.json` でパスを入力ミスすると、ゲートが気付かないうちに無効になります。

<Warning>
  ほとんどのフック イベントでは、終了コード 2 がコードのみでブロックする唯一の終了コードです。stdout に有効な JSON がない場合、1 が従来の Unix 失敗コードであっても、Claude Code は終了コード 1 を非ブロッキング エラーとして扱い、アクションを進行させます。フックがポリシーを実施することを目的としている場合は、`exit 2` を使用してください。worktree イベントは異なります。`WorktreeCreate` からの 0 以外の終了コードは worktree の作成を中止し、`WorktreeRemove` からの 0 以外の終了コードは、その後もディレクトリが存在する場合に worktree の削除を失敗させます。
</Warning>

<h4 id="timeouts">
  タイムアウト
</h4>

[`async: true`](#run-hooks-in-the-background) で実行するコマンド フックを除き、Claude Code は [`timeout`](#common-fields) に達した `command`、`http`、または `mcp_tool` フックをキャンセルし、フックの出力を破棄します。そのため、ほとんどのイベントでは、タイムアウトしたフックは決定を下しません。

[`PreModelSwitch`](#premodelswitch) では、タイムアウトでキャンセルされたフックはモデルの切り替えをブロックします。`PreToolUse` では、2 つのフック ファミリーで動作が異なります。

* タイムアウトした `command`、`http`、または `mcp_tool` フックはツール呼び出しをブロックしません。呼び出しは通常の[権限フロー](/docs/ja/permissions)を通じて続行されるため、停止したフックがゲートとして機能することを当てにしないでください。
* タイムアウトを超えた [Agent SDK コールバック フック](/docs/ja/agent-sdk/hooks)は[ツール呼び出しをブロックします](#pretooluse)。

<h4 id="exit-code-2-behavior-per-event">
  イベントごとの終了コード 2 動作
</h4>

終了コード 2 は、フックが「停止、これをしないでください」と通知する方法です。効果はイベントに依存します。一部のイベントはブロック可能なアクション（まだ発生していないツール呼び出しなど）を表し、他のイベントはすでに発生したか防止できないことを表すためです。

| フック イベント | ブロック可能？ | 終了 2 で何が起こるか |
| :- | :- | :- |
| `PreToolUse` | はい | ツール呼び出しをブロック |
| `PermissionRequest` | いいえ | このイベントでは終了コード 2 は尊重されず、権限フローは変更されずに進行します。代わりに [`decision` オブジェクト](#permissionrequest-decision-control)を通じて拒否してください |
| `UserPromptSubmit` | はい | プロンプトをブロックし、Claude に届かないようにします。[ブロックされたプロンプトが残すもの](#what-a-blocked-prompt-leaves-behind)を参照してください |
| `UserPromptExpansion` | はい | 拡張をブロック |
| `Stop` | はい | Claude が停止するのを防ぎ、会話を続行 |
| `SubagentStop` | はい | サブエージェントが停止するのを防止 |
| `TeammateIdle` | はい | チームメイトがアイドル状態になるのを防止し、作業を続行させる |
| `TaskCreated` | はい | タスク作成をロールバック |
| `TaskCompleted` | はい | タスクが完了としてマークされるのを防止 |
| `ConfigChange` | はい | 設定変更が有効になるのをブロック（`policy_settings` を除く） |
| `StopFailure` | いいえ | 出力と終了コードは無視（`terminalSequence` を除く） |
| `PostToolUse` | いいえ | Claude に stderr を表示（ツールはすでに実行） |
| `PostToolUseFailure` | いいえ | Claude に stderr を表示（ツールはすでに失敗） |
| `PostToolBatch` | はい | 次のモデル呼び出しの前にエージェント型ループを停止 |
| `PermissionDenied` | いいえ | 終了コードと stderr は無視（拒否はすでに発生）。JSON `hookSpecificOutput.retry: true` を使用してモデルが再試行できることを伝える。Claude Code は[判定のない拒否](#permissiondenied-decision-control)では `retry: true` を無視します |
| `Notification` | いいえ | 終了コードと stderr は無視 |
| `SubagentStart` | いいえ | ユーザーのみに stderr を表示 |
| `SessionStart` | いいえ | ユーザーのみに stderr を表示 |
| `Setup` | いいえ | 終了コードと stderr は無視 |
| `SessionEnd` | いいえ | ユーザーのみに stderr を表示 |
| `CwdChanged` | いいえ | ユーザーのみに stderr を表示 |
| `DirectoryAdded` | いいえ | stderr はデバッグ ログに送られる（ディレクトリはすでに追加済み） |
| `FileChanged` | いいえ | ユーザーのみに stderr を表示 |
| `PreCompact` | はい | コンテキスト圧縮をブロック |
| `PostCompact` | いいえ | ユーザーのみに stderr を表示 |
| `PreModelSwitch` | はい | モデルの切り替えをブロックし、ユーザーに stderr を表示 |
| `PostModelSwitch` | いいえ | ユーザーのみに stderr を表示（モデルはすでに切り替え済み） |
| `Elicitation` | はい | elicitation を拒否 |
| `ElicitationResult` | はい | レスポンスをブロック（アクションが decline になる） |
| `WorktreeCreate` | はい | 0 以外の終了コードで worktree 作成が失敗 |
| `WorktreeRemove` | はい | 0 以外の終了コードは、その後もディレクトリが存在する場合に worktree の削除を失敗させる。ディレクトリがどうなるかについては [WorktreeRemove](#worktreeremove) を参照 |
| `InstructionsLoaded` | いいえ | 終了コードは無視 |
| `MessageDisplay` | いいえ | 元のテキストが表示される |

`SessionStart`、`SubagentStart`、および `PostModelSwitch` の場合、Claude Code は終了コード 2 の stderr を[非ブロッキング エラー](#exit-code-output)と同じ方法で、トランスクリプトに `<hook name> hook error` 通知としてレンダリングします。Claude はそれを見ず、セッションまたはサブエージェントは進行します。`SubagentStart` の場合、通知は親会話ではなく、サブエージェント自身のトランスクリプトに表示されます。

<h3 id="http-response-handling">
  HTTP レスポンス処理
</h3>

HTTP フックは終了コードと stdout の代わりに HTTP ステータス コードとレスポンス本体を使用します。以下の結果はほとんどのイベントに適用されます。`WorktreeCreate` のように[イベントごとの表](#exit-code-2-behavior-per-event)に独自の失敗時の規約を持つイベントは、失敗した HTTP フックにもその規約を適用します。

* **2xx で空の本体**: 成功、終了コード 0 で出力なしと同等
* **2xx で JSON オブジェクト本体**: コマンド フックと同じ [JSON 出力](#json-output)スキーマを使用して解析。スキーマ検証に失敗した本体は非ブロッキング エラー
* **2xx でその他の本体（プレーン テキストなど）**: 非ブロッキング エラー。2xx 以外のステータスと同じように処理されます。Claude Code はテキストを Claude のコンテキストに追加しません
* **2xx 以外のステータス**: 非ブロッキング エラー、実行は続行
* **接続失敗**: 非ブロッキング エラー、実行は続行
* **タイムアウト**: [タイムアウト](#timeouts)で説明されているとおり、フックはキャンセルされます

コマンド フックとは異なり、HTTP フックはステータス コードのみでブロッキング エラーを通知できません。ツール呼び出しをブロックまたは権限を拒否するには、適切な決定フィールドを含む JSON 本体を持つ 2xx レスポンスを返します。

<h3 id="json-output">
  JSON 出力
</h3>

終了コードではブロックするか何もしないかしか選べませんが、JSON 出力はより細かい制御を提供します。終了コード 2 でブロックする代わりに、終了 0 して stdout に JSON オブジェクトを出力します。Claude Code はその JSON から特定のフィールドを読み取り、ブロック、許可、またはユーザーへのエスカレーションのための[決定制御](#decision-control)を含む動作を制御します。

<Note>
  フックごとに 1 つのアプローチを選択してください。終了コードのみでシグナリングするか、終了 0 して構造化制御のために JSON を出力するかのいずれかです。両方を混在させた場合、終了 2 は[ブロッキング効果](#exit-code-2-behavior-per-event)を維持し、Claude Code は引き続き JSON フィールドを読み取ります。ただし、[終了コード 2](#exit-code-2) で説明されている elicitation の例外が 1 つあります。
</Note>

フックの stdout には JSON オブジェクトのみが含まれている必要があります。シェル プロファイルがスタートアップ時にテキストを出力する場合、JSON 解析に干渉する可能性があります。トラブルシューティング ガイドの[フックの JSON が効果を持たない](/docs/ja/hooks-guide#hook-json-has-no-effect)を参照してください。

フックの `additionalContext`、`systemMessage`、`initialUserMessage` の文字列、およびプレーン stdout は 10,000 文字に制限されています。

* **スコープ**: 同じイベントに対して複数のフックが実行される場合でも、Claude Code は各文字列を個別に計測します。JSON 出力の場合、各フィールドは個別に計測されます。プレーン stdout は全体として計測されます。
* **制限を超えた場合**: Claude Code は出力をセッション ディレクトリ内のファイルに保存し、ファイル パスと最初の最大 2,000 文字のプレビューに置き換えます。大きな有効な Bash 結果も同じ方法で処理されます（[出力制限](/docs/ja/tools-reference#output-limits)で説明）。その Bash の上限とは異なり、この上限を引き上げる設定や環境変数はありません。
* **ファイルの読み取り**: Claude Code は Claude にファイルを読むよう求めないため、Claude が常に確認する必要があるものは上限内に収めてください。

JSON オブジェクトは 3 種類のフィールドをサポートしています。

* **`continue` などのユニバーサル フィールド**は以下の表にリストされています。すべてのイベントがこれらを受け入れますが、一部のイベントはこれらを破棄するか、`systemMessage` をトランスクリプト以外の場所に配信します。各イベントのセクションにその旨が記載されています。`terminalSequence` もそれらのイベントで機能しますが、[ターミナル通知を発行](#emit-terminal-notifications)に記載されている例外があります。
* **トップレベルの `decision` と `reason`** は一部のイベントで使用され、ブロックまたはフィードバックを提供します。
* **`hookSpecificOutput`** はより豊かな制御が必要なイベント用のネストされたオブジェクトです。イベント名に設定された `hookEventName` フィールドが必要です。

| フィールド | デフォルト | 説明 |
| :- | :- | :- |
| `continue` | `true` | `false` の場合、フックが実行された後、Claude は完全に処理を停止します。イベント固有の決定フィールドよりも優先されます |
| `stopReason` | なし | `continue` が `false` のときにユーザーに表示されるメッセージ。会話に残るため、会話が続行された場合は Claude にも表示されます |
| `suppressOutput` | `false` | 効果はありません。Claude Code はこのフィールドを受け入れますが、それに基づいて動作しません。成功したフックの stdout はトランスクリプトに表示されることはなく、デバッグ ログに記録されます |
| `systemMessage` | なし | ユーザーに表示される警告メッセージ。[Agent SDK](/docs/ja/agent-sdk/overview) および [`--output-format stream-json`](/docs/ja/headless) の出力では、[`SDKInformationalMessage`](/docs/ja/agent-sdk/typescript#sdkinformationalmessage) として届く場合があります |
| `terminalSequence` | なし | Claude Code が代わりに発行するターミナル エスケープ シーケンス（デスクトップ通知、ウィンドウ タイトル、ベルなど）。OSC `0`/`1`/`2`/`9`/`99`/`777` と BEL に制限されます。値に許可リスト外のものが含まれている場合、フィールドは無視されます。フックでは利用できない `/dev/tty` への書き込みの代わりにこれを使用してください |

Claude を完全に停止するには、次のようにします。

```json theme={null}
{ "continue": false, "stopReason": "Build failed, fix errors before continuing" }
```

`PreToolUse` および `PostToolUse` フックの場合、Claude がまだ応答をストリーミングしている間にツール呼び出しが失敗または完了した場合でも、停止が適用されます。

<h4 id="emit-terminal-notifications">
  ターミナル通知を発行
</h4>

フックは制御ターミナルなしで実行されるため、エスケープ シーケンスを `/dev/tty` に直接書き込むことは失敗します。代わりに、エスケープ シーケンスを `terminalSequence` フィールドで返し、Claude Code は独自のターミナル書き込みパスを通じてそれを発行します。これはレース フリーで、tmux と GNU screen 内で機能し、`/dev/tty` がない Windows で機能します。

フィールドは 1 つ以上の許可リストに登録されたエスケープ シーケンスの文字列を受け入れます。

* OSC `0`、`1`、`2`: ウィンドウとアイコン タイトル
* OSC `9`: iTerm2、ConEmu、Windows Terminal、WezTerm 通知（`9;4` タスクバー進捗を含む）
* OSC `99`: Kitty 通知
* OSC `777`: urxvt、Ghostty、Warp 通知
* 裸の BEL

シーケンスは BEL または ST で終了する場合があります。許可リスト外のもの（CSI カーソルと色シーケンス、OSC パレット シーケンス、OSC 8 ハイパーリンク、OSC 52 クリップボード書き込み、OSC 1337 を含む）は拒否され、フィールドは無視されます。

Claude Code はフックの出力を処理するときにシーケンス自体を書き込むため、このフィールドは `Notification` や `StopFailure` など、`systemMessage` と `continue` を破棄するイベントでも機能します。ただし、2 つの制限があります。

* Claude Code は対話セッションでのみ、かつそのインターフェイスが画面に表示されている間のみシーケンスを書き込みます。`-p` フラグを使用した非対話モードおよび Agent SDK では、このフィールドは無視されます。
* `WorktreeCreate` コマンド フックは JSON を返せません。Claude Code はその stdout を worktree パスとして読み取るためです。HTTP `WorktreeCreate` フックは JSON を返すため、このフィールドを含めることができます。

以下の例は `Notification` フックからデスクトップ通知を発火します。エスケープ シーケンスは `printf` 8 進数エスケープで構築されるため、制御バイトはシェル コマンド ラインに表示されず、`jq -n --arg` は JSON 出力を構築するため、通知メッセージの引用符、バックスラッシュ、改行は正しくエスケープされます。

```bash theme={null}
#!/bin/bash
# Notification hook: ping the desktop when Claude Code needs attention.
input=$(cat)
title="Claude Code"
body=$(jq -r '.message // "Needs your attention"' <<<"$input")
seq=$(printf '\033]777;notify;%s;%s\007' "$title" "$body")
jq -nc --arg seq "$seq" '{terminalSequence: $seq}'
```

`{ "terminalSequence": "..." }` の形状は、任意のシェルまたは言語から同じです。

<h4 id="add-context-for-claude">
  Claude 用にコンテキストを追加
</h4>

`additionalContext` フィールドは、フックから Claude のコンテキストウィンドウに文字列を渡します。Claude Code は文字列を[システムリマインダー](/docs/ja/glossary#system-reminder)でラップし、フックが発火した時点で会話に挿入します。Claude は次のモデル リクエストでリマインダーを読み取りますが、インターフェイスではチャット メッセージとして表示されません。

`hookSpecificOutput` 内でイベント名と一緒に `additionalContext` を返します。

```json theme={null}
{
  "hookSpecificOutput": {
    "hookEventName": "PostToolUse",
    "additionalContext": "This file is generated. Edit src/schema.ts and run `bun generate` instead."
  }
}
```

リマインダーが表示される場所はイベントに依存します。

* [SessionStart](#sessionstart) および [SubagentStart](#subagentstart): 会話の開始時、最初のプロンプトの前
* [UserPromptSubmit](#userpromptsubmit) および [UserPromptExpansion](#userpromptexpansion): 送信されたプロンプトの横
* [PreToolUse](#pretooluse)、[PostToolUse](#posttooluse)、[PostToolUseFailure](#posttoolusefailure)、および [PostToolBatch](#posttoolbatch): ツール結果の横
* [Stop](#stop) および [SubagentStop](#subagentstop): ターンの終了時。会話は続行されるため、Claude はフィードバックに対応できます。[Stop 決定制御](#stop-decision-control)を参照してください
* [PostModelSwitch](#postmodelswitch): 切り替え後の次のリクエストとともに。タイミングについては [PostModelSwitch 決定制御](#postmodelswitch-decision-control)を参照してください

複数のフックが同じイベントに対して `additionalContext` を返す場合、Claude はすべての値を受け取ります。

値が 10,000 文字を超える場合、Claude Code はテキストをセッション ディレクトリ内のファイルに書き込み、代わりにファイル パスと最初の最大 2,000 文字のプレビューを Claude に渡します。Claude はファイルを読むことができますが、Claude Code はそれを読むよう求めません。

Claude が現在の環境の状態または実行されたばかりの操作について知っておくべき情報に `additionalContext` を使用します。

* **環境状態**: 現在のブランチ、デプロイ ターゲット、またはアクティブな機能フラグ
* **条件付きプロジェクト ルール**: 編集されたばかりのファイルに適用されるテスト コマンド、この worktree で読み取り専用のディレクトリ
* **外部データ**: 割り当てられたオープン イシュー、最近の CI 結果、内部サービスから取得されたコンテンツ

変わらない指示については、[CLAUDE.md](/docs/ja/memory) を優先します。スクリプトを実行せずに読み込まれ、静的なプロジェクト規約の標準的な場所です。

テキストを命令型システム指示ではなく、事実的なステートメントとして記述します。「デプロイ ターゲットは本番環境です」または「このリポジトリは `bun test` を使用します」などのフレーズはプロジェクト情報として読み取られます。帯域外システム コマンドとしてフレーム化されたテキストは Claude のプロンプトインジェクション防御をトリガーする可能性があり、その場合 Claude はテキストをコンテキストとして扱う代わりにユーザーに提示します。

Claude Code は注入されたテキストをセッション トランスクリプトに保存します。`PostToolUse` や `UserPromptSubmit` などのセッション途中のイベントの場合、`--continue` または `--resume` で再開すると、Claude Code は過去のターンについてフックを再実行するのではなく保存されたテキストを再生するため、タイムスタンプやコミット SHA などの値は古くなります。`SessionStart` フックは再開時に `source` を `"resume"`（`--fork-session` を追加した場合は `"fork"`）に設定して再度実行されるため、コンテキストをリフレッシュできます。

<h4 id="decision-control">
  決定制御
</h4>

すべてのイベントが JSON を通じたブロッキングまたは動作制御をサポートしているわけではありません。サポートするイベントは、その決定を表現するために異なるフィールド セットを使用します。フックを書く前に、このテーブルをクイック リファレンスとして使用してください。

| イベント | 決定パターン | キー フィールド |
| :- | :- | :- |
| UserPromptSubmit、UserPromptExpansion、PostToolUse、PostToolUseFailure、PostToolBatch、Stop、SubagentStop、ConfigChange、PreCompact | トップレベル `decision` | `decision: "block"`、`reason`。Stop と SubagentStop は[会話を続行する非エラー フィードバック](#stop-decision-control)のために `hookSpecificOutput.additionalContext` も受け入れます |
| TeammateIdle、TaskCompleted | 終了コードまたは `continue: false` | 終了コード 2 は stderr フィードバックとともにアクションをブロックします。JSON `{"continue": false, "stopReason": "..."}` もチームメイトを完全に停止し、`Stop` フックの動作と一致します。[`TaskUpdate` ツールがイベントをトリガーした場合、TaskCompleted はこれを無視します](#taskcompleted-decision-control) |
| TaskCreated | 終了コードまたはトップレベル `decision` | 終了コード 2 または `decision: "block"` は[タスクをキャンセル](#taskcreated-decision-control)し、メッセージを Claude に返します。`continue: false` は無視されます |
| PreToolUse | `hookSpecificOutput` | `permissionDecision`（allow/deny/ask/defer）、`permissionDecisionReason` |
| PreModelSwitch | `hookSpecificOutput` またはトップレベル `decision` | `permissionDecision`（allow/deny/ask）、`permissionDecisionReason`。`decision: "block"` も[切り替えをキャンセル](#premodelswitch-decision-control)します |
| PermissionRequest | `hookSpecificOutput` | `decision.behavior`（allow/deny） |
| PermissionDenied | `hookSpecificOutput` | `retry: true` はモデルが拒否されたツール呼び出しを再試行できることを伝えます。Claude Code は[判定のない拒否](#permissiondenied-decision-control)ではこれを無視します |
| WorktreeCreate | パス戻り値 | コマンド フックは stdout にパスを出力します。HTTP フックは `hookSpecificOutput.worktreePath` を返します。フック失敗またはパス欠落で作成が失敗 |
| WorktreeRemove | 終了コード | 0 以外の終了コードは、その後もディレクトリが存在する場合に削除を失敗させます。JSON 出力は破棄されます |
| Elicitation | `hookSpecificOutput` | `action`（accept/decline/cancel）、`content`（accept の場合のフォーム フィールド値） |
| ElicitationResult | `hookSpecificOutput` | `action`（accept/decline/cancel）、`content`（フォーム フィールド値を上書き） |
| MessageDisplay | `hookSpecificOutput` | `displayContent` は画面に表示されるテキストを置き換えます。表示のみ: トランスクリプトと Claude が見るものは元のままです |
| SessionStart、SubagentStart、PostModelSwitch | コンテキストのみ | `hookSpecificOutput.additionalContext` は Claude 用にコンテキストを追加します。SessionStart は [`initialUserMessage`、`watchPaths`、`sessionTitle`、および `reloadSkills`](#sessionstart-decision-control) も受け入れます。ブロッキングまたは決定制御なし |
| Setup、Notification、SessionEnd、PostCompact、InstructionsLoaded、StopFailure、CwdChanged、DirectoryAdded、FileChanged | なし | 決定制御なし。ログやクリーンアップなどの副作用に使用 |

いくつかのイベントは、許可またはブロックするだけでなく、コンテンツを書き直すこともできます。

* `PreToolUse`: `hookSpecificOutput` の直下の `updatedInput` は、ツールが実行される前にそのツールの引数を置き換えます。[PreToolUse 決定制御](#pretooluse-decision-control)を参照してください
* `PermissionRequest`: `decision` オブジェクト内の `updatedInput`。[PermissionRequest 決定制御](#permissionrequest-decision-control)を参照してください
* `PostToolUse`: `updatedToolOutput` はツールの結果を置き換えます。[PostToolUse 決定制御](#posttooluse-decision-control)を参照してください
* `UserPromptSubmit`: プロンプトを置き換えることはできません。`additionalContext` をそれと一緒に注入するだけです

秘匿化や変換のユースケースの場合、アウトバウンド ツール入力の場合は `PreToolUse` で、インバウンド ツール結果の場合は `PostToolUse` で傍受します。

各パターンの実行例を以下に示します。

<Tabs>
  <Tab title="トップレベル決定">
    `decision` の唯一の値は `"block"` です。アクションを進行させるには、JSON から `decision` を省略するか、JSON なしで終了 0 で終了します。

    ```json theme={null}
    {
      "decision": "block",
      "reason": "Test suite must pass before proceeding"
    }
    ```
  </Tab>

  <Tab title="PreToolUse">
    より豊かな制御のために `hookSpecificOutput` を使用します。許可、拒否、またはユーザーへのエスカレーション。ツール入力を実行前に変更したり、Claude 用に追加コンテキストを注入することもできます。オプションの完全なセットについては、[PreToolUse 決定制御](#pretooluse-decision-control)を参照してください。

    ```json theme={null}
    {
      "hookSpecificOutput": {
        "hookEventName": "PreToolUse",
        "permissionDecision": "deny",
        "permissionDecisionReason": "Database writes are not allowed"
      }
    }
    ```
  </Tab>

  <Tab title="PermissionRequest">
    `hookSpecificOutput` を使用して、ユーザーに代わって権限リクエストを許可または拒否します。許可する場合、ツールの入力を変更したり、権限ルールを適用して、ユーザーが再度プロンプトされないようにすることもできます。オプションの完全なセットについては、[PermissionRequest 決定制御](#permissionrequest-decision-control)を参照してください。

    ```json theme={null}
    {
      "hookSpecificOutput": {
        "hookEventName": "PermissionRequest",
        "decision": {
          "behavior": "allow",
          "updatedInput": {
            "command": "npm run lint"
          }
        }
      }
    }
    ```
  </Tab>
</Tabs>

Bash コマンド検証、プロンプト フィルタリング、自動承認スクリプトを含む拡張例については、ガイドの[自動化できること](/docs/ja/hooks-guide#what-you-can-automate)と [Bash コマンド バリデーター リファレンス実装](https://github.com/anthropics/claude-code/blob/main/examples/hooks/bash_command_validator_example.py)を参照してください。

<h2 id="hook-events">
  フックイベント
</h2>

各イベントは、フックを実行できる Claude Code のライフサイクル上のポイントに対応しています。以下のセクションはライフサイクルに沿った順序で並んでおり、セッションのセットアップからエージェント型ループを経てセッション終了までを扱います。各セクションでは、イベントが発火するタイミング、サポートする matcher、受け取る JSON 入力、出力を通じて動作を制御する方法を説明します。

<h3 id="sessionstart">
  SessionStart
</h3>

Claude Code が新しいセッションを開始するとき、または既存のセッションを再開するときに実行されます。既存の issue やコードベースへの最近の変更といった開発コンテキストの読み込みや、環境変数の設定に便利です。スクリプトを必要としない静的なコンテキストには、代わりに [CLAUDE.md](/docs/ja/memory) を使用してください。

SessionStart はすべてのセッションで実行されるため、これらのフックは高速に保ってください。サポートされるのは `type: "command"` と `type: "mcp_tool"` のフックのみです。`mcp_tool` フックが実行されるタイミングについては、[MCP ツールフックのフィールド](#mcp-tool-hook-fields)を参照してください。

matcher の値は、セッションがどのように開始されたかに対応します。

| Matcher | 発火するタイミング |
| :- | :- |
| `startup` | 新しいセッション |
| `resume` | `--resume`、`--continue`、または `/resume` |
| `clear` | `/clear` |
| `compact` | 自動または手動のコンテキスト圧縮 |
| `fork` | 既存のセッションからフォークされた新しいセッション。`--resume` または `--continue` と組み合わせた `--fork-session`、`/fork` によるバックグラウンドコピー、`/branch`、または[バックグラウンドに移動](/docs/ja/agent-view#from-inside-a-session)した会話が該当します |

v2.1.214 より前は、フォークされたセッションはソースとして `"resume"` を報告していました。

対話セッションを開始したとき、起動時に `--continue` または `--resume` で会話を再開したとき、または `/clear` を実行したときは、SessionStart フックがバックグラウンドで実行されます。すぐに入力を始めることができ、再開した会話はフックを待たずに表示されます。ただし、フックのコンテキストが Claude に届くように、Claude の最初の応答はフックの完了を待ちます。

セッション内で `/resume` を使って会話を切り替えた場合は、切り替え自体がフックの完了を待ちます。バックグラウンドのフックがまだ実行中に `/clear` を実行したり別の会話に切り替えたりすると、フックが返す内容はセッションに一切適用されません。

起動時にも同じ待機が適用され、再開したセッションも含まれます。SessionStart フックの実行中に送信したプロンプトは、フックが完了するまで Claude に届きません。

いずれの待機中も、`Esc` を押すとプロンプトを送信せずに入力欄に戻すことができます。フックは実行を続けます。

<h4 id="sessionstart-input">
  SessionStart の入力
</h4>

[共通の入力フィールド](#common-input-fields)に加えて、SessionStart フックは `source` と、オプションで `model`、`agent_type`、`session_title` を受け取ります。

| フィールド | 説明 |
| :- | :- |
| `source` | セッションの開始方法。新しいセッションでは `"startup"`、再開されたセッションでは `"resume"`、`/clear` の後では `"clear"`、コンテキスト圧縮の後では `"compact"`、既存のセッションからフォークされた新しいセッションでは `"fork"` |
| `model` | アクティブなモデルの識別子。たとえば `/clear` の後や、会話の復旧によってセッションが復元された場合など、省略されることがあるため、読み取る前にフィールドの有無を確認してください |
| `agent_type` | エージェント名。`claude --agent <name>` で Claude Code を起動した場合に含まれます |
| `session_title` | セッションのカスタムタイトル。`--name`、`/rename`、フックの `sessionTitle` 出力、Agent SDK の `renameSession()` などで設定されている場合に含まれます。`sessionTitle` を出力するフックは、既存のカスタムタイトルを上書きしないように、まずこのフィールドを確認できます |

名前を付けていないセッションにも[生成されたタイトル](/docs/ja/sessions#name-your-sessions)が付いている場合があります。このタイトルはカスタムタイトルではないため、`session_title` には含まれません。

`source` が `"resume"` または `"fork"` で、トランスクリプトに Claude の応答が少なくとも 1 つ含まれている場合、SessionStart フックは以下の 4 つのフィールドも受け取ります。フックはこれらを使用して、古い会話を再開するコストを最初のリクエストの前に報告できます。たとえば [`systemMessage`](#json-output) で報告します。これらのフィールドには Claude Code v2.1.251 以降が必要です。

| フィールド | 説明 |
| :- | :- |
| `seconds_since_last_response` | 再開されたトランスクリプト内の最後の応答からの経過時間（実時間の秒数） |
| `context_tokens` | 再開されたセッションの最初のリクエストがプロンプトとして再送信するトークン数 |
| `prompt_cache_likely_expired` | 最後の応答がセッションの[プロンプトキャッシュの有効期間](/docs/ja/prompt-caching#cache-lifetime)より古い場合、またはその後のコンテキスト圧縮によってキャッシュされた会話が置き換えられた場合に `true` |
| `estimated_cache_write_usd` | セッションのモデルで `context_tokens` をプロンプトキャッシュに書き込む推定コスト（米ドル）。応答は含みません |

次の例は、最後の応答から 90 分後に再開されたセッションの入力を示しています。

```json theme={null}
{
  "session_id": "abc123",
  "transcript_path": "/Users/.../.claude/projects/.../00893aaf-19fa-41d2-8238-13269b9b3ca0.jsonl",
  "cwd": "/Users/...",
  "hook_event_name": "SessionStart",
  "source": "resume",
  "model": "claude-opus-5",
  "seconds_since_last_response": 5400,
  "context_tokens": 182340,
  "prompt_cache_likely_expired": true,
  "estimated_cache_write_usd": 1.1396
}
```

<h4 id="sessionstart-decision-control">
  SessionStart の判定制御
</h4>

Claude Code は、[プレーンテキストとして扱う](#exit-code-0) stdout を Claude のコンテキストに追加します。すべてのフックで利用できる [JSON 出力フィールド](#json-output)に加えて、以下のイベント固有のフィールドを返すことができます。

| フィールド | 説明 |
| :- | :- |
| `additionalContext` | 会話の開始時、最初のプロンプトの前に Claude のコンテキストに追加される文字列。テキストの届け方と記述すべき内容については、[Claude にコンテキストを追加する](#add-context-for-claude)を参照してください |
| `initialUserMessage` | セッションの最初のユーザーメッセージとして使用される文字列。`-p` フラグを使った[非対話モード](/docs/ja/headless)で適用され、プロンプトが指定されていなくても最初のターンになります。プロンプトが指定されている場合、それは次のターンとして続きます。既存のターンに付加される `additionalContext` とは異なり、これはターンそのものを作成します |
| `sessionTitle` | セッションのタイトルを設定します。効果は `/rename` と同じです。起動フォルダ、git ブランチ、worktree 名からセッションに自動的に名前を付けるのに使用します。`source` が `"startup"`、`"resume"`、`"fork"` の場合に適用され、`"clear"` と `"compact"` では無視されます |
| `watchPaths` | このセッション中に [FileChanged](#filechanged) イベントを監視する絶対パスの配列 |
| `reloadSkills` | ブール値。`true` の場合、Claude Code は SessionStart フックの完了後に[スキル](/docs/ja/skills)とコマンドのディレクトリを再スキャンするため、フックがインストールしたスキルを同じセッションの最初のプロンプトから利用できます |

```json theme={null}
{
  "hookSpecificOutput": {
    "hookEventName": "SessionStart",
    "additionalContext": "Current branch: feat/auth-refactor\nUncommitted changes: src/auth.ts, src/login.tsx\nActive issue: #4211 Migrate to OAuth2",
    "sessionTitle": "auth-refactor"
  }
}
```

このイベントではプレーンな stdout がすでに Claude に届くため、コンテキストを読み込むだけのフックは JSON を組み立てずに stdout へ直接出力できます。コンテキストを `sessionTitle` などの他のフィールドと組み合わせる必要がある場合は、JSON 形式を使用してください。

SessionStart フックがスキルをインストールまたは更新する場合は `reloadSkills` を使用します。スキルの検出は通常 SessionStart フックの完了前に実行されるため、フックが `~/.claude/skills/` や `.claude/skills/` に書き込んだファイルは、これを使わないと次のセッションでしか表示されません。次の例では、共有スキルのリポジトリを同期し、再スキャンを要求します。

```bash theme={null}
#!/bin/bash

git -C ~/.claude/skills/team-skills pull --quiet 2>/dev/null || \
  git clone --quiet https://git.example.com/your-org/team-skills.git ~/.claude/skills/team-skills

echo '{"hookSpecificOutput": {"hookEventName": "SessionStart", "reloadSkills": true}}'
```

リポジトリの URL はプレースホルダーです。自分のスキルリポジトリに置き換えてください。プレースホルダーのままでは clone が失敗し、stderr に `fatal:` メッセージが出力されます。終了コード 0 で終了した SessionStart フックの stderr は情報提供のみを目的としているため、`reloadSkills` の要求は引き続き適用されます。

<h4 id="persist-environment-variables">
  環境変数を永続化する
</h4>

SessionStart フックは `CLAUDE_ENV_FILE` 環境変数にアクセスできます。この変数は、後続の Bash コマンド用に環境変数を永続化できるファイルパスを提供します。

個々の環境変数を設定するには、`CLAUDE_ENV_FILE` に `export` 文を書き込みます。他のフックが設定した変数を保持するために、追記（`>>`）を使用してください。

```bash theme={null}
#!/bin/bash

if [ -n "$CLAUDE_ENV_FILE" ]; then
  echo 'export NODE_ENV=production' >> "$CLAUDE_ENV_FILE"
  echo 'export DEBUG_LOG=true' >> "$CLAUDE_ENV_FILE"
  echo 'export PATH="$PATH:./node_modules/.bin"' >> "$CLAUDE_ENV_FILE"
fi

exit 0
```

セットアップコマンドによるすべての環境の変更を取り込むには、エクスポートされた変数を前後で比較します。

```bash theme={null}
#!/bin/bash

ENV_BEFORE=$(export -p | sort)

# Run your setup commands that modify the environment
source ~/.nvm/nvm.sh
nvm use 20

if [ -n "$CLAUDE_ENV_FILE" ]; then
  ENV_AFTER=$(export -p | sort)
  comm -13 <(echo "$ENV_BEFORE") <(echo "$ENV_AFTER") >> "$CLAUDE_ENV_FILE"
fi

exit 0
```

<Note>
  `CLAUDE_ENV_FILE` は SessionStart、[Setup](#setup)、[CwdChanged](#cwdchanged)、[FileChanged](#filechanged) フックで利用できます。その他のフックタイプはこの変数にアクセスできません。
</Note>

<h3 id="setup">
  Setup
</h3>

`--init-only` で Claude Code を起動した場合、または `-p` フラグを使った[非対話モード](/docs/ja/headless)で `--init` か `--maintenance` を付けて起動した場合にのみ発火します。通常の起動時には発火しません。通常のセッション開始とは別に、CI やスクリプトから明示的にトリガーする一度きりの依存関係のインストールや定期的なクリーンアップに使用します。セッションごとの初期化には、代わりに [SessionStart](#sessionstart) を使用してください。

matcher の値は、フックをトリガーした CLI フラグに対応します。

| Matcher | 発火するタイミング |
| :- | :- |
| `init` | `claude --init-only` または `claude -p --init` |
| `maintenance` | `claude -p --maintenance` |

`claude --init-only` を実行すると、Claude Code は Setup フックと `startup` matcher の `SessionStart` フックを実行し、会話を開始せずに終了します。

`-p` で会話を開始または継続する場合は、引数として、または stdin へのパイプでプロンプトも指定する必要があります。`SessionStart` フックが [`initialUserMessage`](#sessionstart-decision-control) を提供する場合や、[延期されたツール呼び出し](#defer-a-tool-call-for-later)を含むセッションを再開する場合は、プロンプトを省略できます。

成功した場合、`--init-only` はターミナルに何も出力しません。フックが実行されたことを確認するには、`claude --debug-file <path> --init-only` で起動し（`<path>` はログファイルの場所に置き換えます）、ログで Setup と SessionStart のフックのエントリを確認してください。

Setup はすべての起動時に発火するわけではないため、依存関係のインストールを必要とするプラグインは Setup だけに頼ることはできません。実用的なパターンは、初回使用時に依存関係を確認し、見つからなければインストールすることです。たとえば、`${CLAUDE_PLUGIN_DATA}/node_modules` の有無をテストし、なければ `npm install` を実行するフックやスキルです。インストールした依存関係の保存場所については、[永続データディレクトリ](/docs/ja/plugins/components#path-variables-and-persistent-data)を参照してください。マーケットプレイスを通じてプラグインを配布する場合は、このパターンが不要なこともあります。Claude Code はプラグインをキャッシュする際に、[対象となる Node.js パッケージの依存関係を自動的にインストールします](/docs/ja/plugins/loading#node-js-package-dependencies)。

<h4 id="setup-input">
  Setup の入力
</h4>

[共通の入力フィールド](#common-input-fields)に加えて、Setup フックは `"init"` または `"maintenance"` のいずれかが設定された `trigger` フィールドを受け取ります。

```json theme={null}
{
  "session_id": "abc123",
  "transcript_path": "/Users/.../.claude/projects/.../00893aaf-19fa-41d2-8238-13269b9b3ca0.jsonl",
  "cwd": "/Users/...",
  "hook_event_name": "Setup",
  "trigger": "init"
}
```

<h4 id="setup-decision-control">
  Setup の判定制御
</h4>

Setup フックはブロックできず、どの終了コードでも実行は継続されます。どの終了コードであっても、Claude Code は Setup フックの [JSON 出力フィールド](#json-output)（`systemMessage`、`continue`、`hookSpecificOutput.additionalContext` など）を破棄します。`-p` を使用する場合、Setup フックの stdout、stderr、終了コードは、`--output-format stream-json --verbose` で起動したときに限り、[`hook_response` イベント](/docs/ja/headless#read-session-metadata)として実行の出力に表示されます。

Setup フックは `CLAUDE_ENV_FILE` にアクセスできます。このファイルに書き込まれた変数は、[SessionStart フック](#persist-environment-variables)と同様に、セッションの後続の Bash コマンドに引き継がれます。`Setup` で実行されるのは `type: "command"` フックのみです。`Setup` 上の `type: "mcp_tool"` フックは、[MCP ツールフックのフィールド](#mcp-tool-hook-fields)で説明されているとおり、常にスキップされます。

<h3 id="instructionsloaded">
  InstructionsLoaded
</h3>

`CLAUDE.md` または `.claude/rules/*.md` ファイルがコンテキストに読み込まれたときに発火します。このイベントは、即時に読み込まれるファイルについてはセッション開始時に発火し、ファイルが遅延読み込みされたときにも再度発火します。遅延読み込みの例としては、ネストされた `CLAUDE.md` を含むサブディレクトリに Claude がアクセスしたときや、`paths:` フロントマターを持つ条件付きルールが一致したときがあります。このフックはブロックや判定制御をサポートしていません。可観測性を目的として非同期で実行されます。

Claude が **Project instructions** 設定を通じて [`AGENTS.md` を直接読み込む](/docs/ja/memory#agents-md)場合、このイベントは発火しません。`CLAUDE.md` が `AGENTS.md` をインポートする場合は、他のインポートされたファイルと同様に `load_reason` が `include` に設定されて発火し、`CLAUDE.md` が `AGENTS.md` へのシンボリックリンクである場合は、通常の `CLAUDE.md` の読み込みとして発火します。

matcher は `load_reason` に対して照合されます。たとえば、セッション開始時に読み込まれたファイルに対してのみ発火させるには `"matcher": "session_start"` を、遅延読み込みに対してのみ発火させるには `"matcher": "path_glob_match|nested_traversal"` を使用します。

<h4 id="instructionsloaded-input">
  InstructionsLoaded の入力
</h4>

[共通の入力フィールド](#common-input-fields)に加えて、InstructionsLoaded フックは以下のフィールドを受け取ります。

| フィールド | 説明 |
| :- | :- |
| `file_path` | 読み込まれた指示ファイルの絶対パス |
| `memory_type` | ファイルのスコープ：`"User"`、`"Project"`、`"Local"`、または `"Managed"` |
| `load_reason` | ファイルが読み込まれた理由：`"session_start"`、`"nested_traversal"`、`"path_glob_match"`、`"include"`、または `"compact"`。`"compact"` の値は、コンテキスト圧縮イベントの後に指示ファイルが再読み込みされたときに発火します |
| `globs` | ファイルの `paths:` フロントマターにあるパスの glob パターン（存在する場合）。`path_glob_match` の読み込みの場合にのみ含まれます |
| `trigger_file_path` | 遅延読み込みの場合に、この読み込みをトリガーしたアクセス先のファイルのパス |
| `parent_file_path` | `include` の読み込みの場合に、このファイルをインクルードした親の指示ファイルのパス |

```json theme={null}
{
  "session_id": "abc123",
  "transcript_path": "/Users/.../.claude/projects/.../transcript.jsonl",
  "cwd": "/Users/my-project",
  "hook_event_name": "InstructionsLoaded",
  "file_path": "/Users/my-project/CLAUDE.md",
  "memory_type": "Project",
  "load_reason": "session_start"
}
```

<h4 id="instructionsloaded-decision-control">
  InstructionsLoaded の判定制御
</h4>

InstructionsLoaded フックには判定制御がありません。指示の読み込みをブロックしたり変更したりすることはできません。Claude Code は、`systemMessage` や `continue` などの [JSON 出力フィールド](#json-output)を破棄します。このイベントは、監査ログ、コンプライアンスの追跡、可観測性に使用してください。

<h3 id="userpromptsubmit">
  UserPromptSubmit
</h3>

ユーザーがプロンプトを送信したとき、Claude がそれを処理する前に実行されます。これにより、プロンプトや会話に基づいて追加のコンテキストを加えたり、プロンプトを検証したり、特定の種類のプロンプトをブロックしたりできます。

`UserPromptSubmit` フックのデフォルトのタイムアウトは、`command`、`http`、`mcp_tool` タイプで 30 秒です。これは、他のほとんどのイベントでのこれらのタイプのデフォルトである 600 秒より短くなっています。このフックはすべてのプロンプトの前に実行され、完了するまでモデルの処理をブロックするため、フックが停止するとセッションも停止します。フックにより長い時間が必要な場合は、フックエントリの `timeout` フィールドを設定してください。

[`async: true`](#run-hooks-in-the-background) で実行するコマンドフックを除き、タイムアウトに達した `UserPromptSubmit` のコマンド、HTTP、または MCP ツールのフックはキャンセルされ、その出力は `additionalContext` も含めて破棄されます。プロンプトはそのコンテキストなしで Claude に届きます。トランスクリプトには、フック名、発生したタイムアウト、出力が破棄されたことを示す通知が表示されます。

`UserPromptSubmit` 上の [Agent SDK コールバックフック](/docs/ja/agent-sdk/hooks)がタイムアウトに達すると、フック名とタイムアウトを示すメッセージとともにプロンプトがブロックされます。このイベントのコールバックは、フェイルオープンしてはならないポリシーゲートとして機能している可能性があるためです。セッションは継続します。v2.1.208 より前は、このイベントでコールバックがタイムアウトすると、実行エラーでターンが終了していました。

<h4 id="userpromptsubmit-input">
  UserPromptSubmit の入力
</h4>

[共通の入力フィールド](#common-input-fields)に加えて、UserPromptSubmit フックはユーザーが送信したテキストを含む `prompt` フィールドを受け取ります。`[Pasted text #N]` プレースホルダーに折りたたまれた貼り付けコンテンツは、その位置に展開された状態で届きます。Claude Code が[貼り付けられたテキストを Claude 向けにマークする](/docs/ja/terminal-config#how-claude-treats-pasted-text)セッションでは、展開されたコンテンツは `<pasted_content id="…">` の行と `</pasted_content id="…">` の行の間に置かれるため、フックがプロンプトを解析する場合はこれらの行を考慮してください。

UserPromptSubmit フックは、セッションにカスタムタイトルがある場合に `session_title` も受け取ります。意味は [SessionStart の `session_title` フィールド](#sessionstart-input)と同じです。

```json theme={null}
{
  "session_id": "abc123",
  "transcript_path": "/Users/.../.claude/projects/.../00893aaf-19fa-41d2-8238-13269b9b3ca0.jsonl",
  "cwd": "/Users/...",
  "permission_mode": "default",
  "hook_event_name": "UserPromptSubmit",
  "prompt": "Write a function to calculate the factorial of a number"
}
```

<h4 id="userpromptsubmit-decision-control">
  UserPromptSubmit の判定制御
</h4>

`UserPromptSubmit` フックは、ユーザーのプロンプトを処理するかどうかを制御し、コンテキストを追加できます。すべての [JSON 出力フィールド](#json-output)を利用できます。

終了コード 0 で会話にコンテキストを追加する方法は 2 つあります。

* **プレーンテキストの stdout**：Claude Code は、[プレーンテキストとして扱う](#exit-code-0) stdout を Claude のコンテキストに追加します
* **`additionalContext` を含む JSON**：より細かく制御するには、以下の JSON 形式を使用します。`additionalContext` フィールドがコンテキストとして追加されます

どちらの経路でも、トランスクリプトに表示されるエントリは作成されません。プレーンな stdout と `additionalContext` の値は、それぞれフック名で始まるシステムリマインダーとして挿入され、Claude は両方を読みます。配信を確認するには、[デバッグログ](#debug-hooks)を確認してください。

プロンプトをブロックするには、`decision` を `"block"` に設定した JSON オブジェクトを返します。

| フィールド | 説明 |
| :- | :- |
| `decision` | `"block"` は、プロンプトが Claude に届く前に停止します。プロンプトの続行を許可するには省略します |
| `reason` | `decision` が `"block"` の場合にユーザーに表示されます。コンテキストには追加されません |
| `additionalContext` | 送信されたプロンプトとともに Claude のコンテキストに追加される文字列。[Claude にコンテキストを追加する](#add-context-for-claude)を参照してください |
| `sessionTitle` | セッションのタイトルを設定します。プロンプトの内容に基づいてセッションに自動的に名前を付けるのに使用します |
| `suppressOriginalPrompt` | フックがプロンプトをブロックするときに `true` の場合、ブロックメッセージからプロンプトのテキストを除外します。[ブロックされたプロンプトが残すもの](#what-a-blocked-prompt-leaves-behind)を参照してください |

終了コード 2 で終了してブロックするフックは、`reason` と同じ経路をたどります。ブロックメッセージは stderr のテキストをユーザーに表示し、それはコンテキストには追加されません。

```json theme={null}
{
  "decision": "block",
  "reason": "Explanation for decision",
  "hookSpecificOutput": {
    "hookEventName": "UserPromptSubmit",
    "additionalContext": "My additional context here",
    "sessionTitle": "My session title",
    "suppressOriginalPrompt": true
  }
}
```

<h4 id="what-a-blocked-prompt-leaves-behind">
  ブロックされたプロンプトが残すもの
</h4>

ブロックされたプロンプトは Claude に届きませんが、そのテキストがすべての場所から削除されるわけではありません。デフォルトでは、ユーザーに表示されるブロックメッセージの末尾に `Original prompt:` と送信されたテキストが続き、Claude Code はそのメッセージをディスク上のセッションのトランスクリプトファイルに書き込みます。メッセージからテキストを除外するには、`hookSpecificOutput` 内に `"suppressOriginalPrompt": true` を含む JSON を出力します。これは、フックが `decision: "block"` でブロックする場合でも、終了コード 2 で終了してブロックする場合でも機能します。JSON を出力しない終了コード 2 のフックでは、ブロックメッセージに常にプロンプトのテキストが含まれます。

`suppressOriginalPrompt` が変更するのはブロックメッセージのみです。送信されたテキストは、セッションのトランスクリプトやプロンプト履歴などのローカルファイルに引き続き現れる可能性があるため、ブロックするフックは機密情報をディスクに残さないための手段にはなりません。これらのファイルを制限または削除するには、[プレーンテキストでの保存](/docs/ja/claude-directory#plaintext-storage)と[ローカルデータの消去](/docs/ja/claude-directory#clear-local-data)を参照してください。

<h3 id="userpromptexpansion">
  UserPromptExpansion
</h3>

ユーザーが入力したコマンドが、Claude に届く前にプロンプトへ展開されるときに実行されます。特定のコマンドの直接呼び出しをブロックしたり、特定のスキルにコンテキストを挿入したり、ユーザーが呼び出したコマンドをログに記録したりするのに使用します。たとえば、`deploy` に一致するフックは承認ファイルが存在しない限り `/deploy` をブロックでき、レビュースキルに一致するフックはチームのレビューチェックリストを `additionalContext` として追加できます。

このイベントは、`PreToolUse` がカバーしない経路を扱います。`Skill` ツールに一致する `PreToolUse` フックは Claude がツールを呼び出したときにのみ発火しますが、`/skillname` を直接入力すると `PreToolUse` を経由しません。`UserPromptExpansion` はその直接の経路で発火します。

`command_name` に対して照合します。すべてのプロンプト型コマンドで発火させるには、matcher を空のままにします。

<h4 id="userpromptexpansion-input">
  UserPromptExpansion の入力
</h4>

[共通の入力フィールド](#common-input-fields)に加えて、UserPromptExpansion フックは `expansion_type`、`command_name`、`command_args`、`command_source`、および元の `prompt` 文字列を受け取ります。`expansion_type` フィールドは、スキルとカスタムコマンドでは `slash_command`、MCP サーバーのプロンプトでは `mcp_prompt` になります。

```json theme={null}
{
  "session_id": "abc123",
  "transcript_path": "/Users/.../00893aaf.jsonl",
  "cwd": "/Users/...",
  "permission_mode": "default",
  "hook_event_name": "UserPromptExpansion",
  "expansion_type": "slash_command",
  "command_name": "example-skill",
  "command_args": "arg1 arg2",
  "command_source": "plugin",
  "prompt": "/example-skill arg1 arg2"
}
```

<h4 id="userpromptexpansion-decision-control">
  UserPromptExpansion の判定制御
</h4>

`UserPromptExpansion` フックは、展開をブロックしたり、コンテキストを追加したりできます。すべての [JSON 出力フィールド](#json-output)を利用できます。

| フィールド | 説明 |
| :- | :- |
| `decision` | `"block"` は、コマンドの展開を防ぎます。続行を許可するには省略します |
| `reason` | `decision` が `"block"` の場合にユーザーに表示されます |
| `additionalContext` | 展開されたプロンプトとともに Claude のコンテキストに追加される文字列。[Claude にコンテキストを追加する](#add-context-for-claude)を参照してください |

終了コード 2 で終了してブロックするフックは、`reason` と同じ経路をたどります。ブロックメッセージは stderr のテキストをユーザーに表示します。

```json theme={null}
{
  "decision": "block",
  "reason": "This slash command is not available",
  "hookSpecificOutput": {
    "hookEventName": "UserPromptExpansion",
    "additionalContext": "Additional context for this expansion"
  }
}
```

<h3 id="messagedisplay">
  MessageDisplay
</h3>

アシスタントのメッセージが画面にストリーミングされている間に実行されます。Claude Code はメッセージを段階的に表示します。新たに完成した行のバッチがレンダリングできる状態になるたびに、フックがそれらの行を使って 1 回実行され、Claude Code はその位置にフックの置換テキストをレンダリングします。長いメッセージでは複数回呼び出され、短いメッセージでは 1 回だけのこともあります。

MessageDisplay は次の用途に使用します。

* 最小限の表示のために markdown を取り除く
* Agent SDK アプリケーションがユーザーに表示するテキストを変換する
* Claude の応答から API キーや内部ホスト名を伏せる

Claude Code はフックが返るまで各バッチを保留するため、フックは高速に保ってください。フックが失敗するかタイムアウトした場合、Claude Code は元のテキストを表示します。このイベントのデフォルトのタイムアウトは 10 秒です。フックにより長い時間が必要な場合は、フックエントリの `timeout` フィールドを設定してください。

MessageDisplay は表示専用です。置換テキストは画面にレンダリングされる内容のみを変更します。トランスクリプトと Claude が参照する内容は元のテキストのままなので、Claude が置換テキストを目にすることはなく、詳細モードでは元のテキストが表示されます。フックが受け取るのはアシスタントのメッセージテキストのみなので、ツールの結果やユーザーが入力したテキストは変更されずにレンダリングされます。

MessageDisplay は matcher をサポートしておらず、テキストをストリーミングするすべてのアシスタントメッセージで発火します。ツール呼び出しのみの応答など、テキストを含まないメッセージではトリガーされません。

Agent SDK のクエリや `claude -p` を含む非対話の実行では、MessageDisplay は行のバッチごとではなく、アシスタントメッセージごとに 1 回実行されます。この 1 回の呼び出しはメッセージの完了後に届き、メッセージのテキスト全体を含みます。`index` は `0`、`final` は `true` で、`delta` にメッセージ全体が入ります。各メッセージの `delta` テキストを収集するフックは、どちらのモードでも同じ合計テキストを受け取ります。

<h4 id="messagedisplay-input">
  MessageDisplay の入力
</h4>

[共通の入力フィールド](#common-input-fields)に加えて、MessageDisplay フックはターンとメッセージの識別子、メッセージ内でのこの呼び出しの位置、および `delta` 内の新しいテキストを受け取ります。バッチの境界はテキストのストリーミング方法に依存するため、行が特定の方法でグループ化されることを期待するのではなく、`index` と `final` を使ってメッセージの進行状況を追跡してください。

| フィールド | 説明 |
| :- | :- |
| `turn_id` | 現在のターンの UUID |
| `message_id` | 表示中のアシスタントメッセージの UUID。同じメッセージのすべてのバッチで一定です。これは API の `msg_…` ID ではないため、トランスクリプトのメッセージ ID と対応付けることはできません |
| `index` | メッセージ内でのこのバッチの 0 始まりのインデックス |
| `final` | メッセージの最後のバッチで `true`。各メッセージにはちょうど 1 つの最終バッチがあります |
| `delta` | 前のバッチ以降に新たに完成した行（末尾の改行を含む）。常に行全体ですが、最終バッチは行の途中で終わる場合があります。対話的な実行では、メッセージが改行で終わる場合は最終バッチの delta が空になるため、空でない delta ではなく `final` をメッセージ終了のシグナルとして扱ってください。Agent SDK と `claude -p` の実行では、1 回の呼び出しにメッセージ全体が含まれます |

```json theme={null}
{
  "session_id": "abc123",
  "transcript_path": "/Users/.../.claude/projects/.../transcript.jsonl",
  "cwd": "/Users/my-project",
  "hook_event_name": "MessageDisplay",
  "turn_id": "0c9e6a2f-7d41-4f4e-9a15-3f4f7c2b8d10",
  "message_id": "5b2a9c8e-1f63-4d8a-b7c4-9e0d2a6f1c3b",
  "index": 0,
  "final": false,
  "delta": "Here is the plan:\n"
}
```

<h4 id="messagedisplay-output">
  MessageDisplay の出力
</h4>

すべてのフックで利用できる [JSON 出力フィールド](#json-output)に加えて、MessageDisplay フックは `displayContent` を返して、画面上の delta を置き換えることができます。

| フィールド | 説明 |
| :- | :- |
| `displayContent` | delta の代わりに表示されるテキスト。元のテキストを表示するには省略します |

MessageDisplay フックには判定制御がありません。メッセージをブロックしたり、トランスクリプトに保存される内容や Claude に送信される内容を変更したりすることはできません。Claude Code は JSON 出力の `displayContent` に従って動作し、`systemMessage` と `continue` は破棄します。

次の例では、プレーンテキストで表示するために Claude の応答から markdown の書式を取り除きます。スクリプトは stdin から各バッチを読み取り、`delta` から太字のマーカーとインラインコードのバッククォートを削除し、結果を `displayContent` として返します。

<Tabs>
  <Tab title="macOS/Linux">
    設定ファイルで、このイベントのコマンドフックを登録します。

    ```json theme={null}
    {
      "hooks": {
        "MessageDisplay": [
          {
            "hooks": [
              {
                "type": "command",
                "command": "${CLAUDE_PROJECT_DIR}/.claude/hooks/plain-display.sh",
                "args": []
              }
            ]
          }
        ]
      }
    }
    ```

    このスクリプトをプロジェクトの `.claude/hooks/plain-display.sh` に保存し、`chmod +x` で実行可能にします。

    ```bash theme={null}
    #!/bin/bash
    jq '{hookSpecificOutput: {hookEventName: "MessageDisplay", displayContent: (.delta | gsub("\\*\\*"; "") | gsub("`"; ""))}}'
    ```
  </Tab>

  <Tab title="Windows (PowerShell)">
    PowerShell 経由でスクリプトを実行するコマンドフックを登録します。

    ```json theme={null}
    {
      "hooks": {
        "MessageDisplay": [
          {
            "hooks": [
              {
                "type": "command",
                "command": "powershell.exe",
                "args": [
                  "-NoProfile",
                  "-ExecutionPolicy",
                  "Bypass",
                  "-File",
                  "${CLAUDE_PROJECT_DIR}/.claude/hooks/plain-display.ps1"
                ]
              }
            ]
          }
        ]
      }
    }
    ```

    `-NoProfile` フラグは PowerShell プロファイルの読み込みをスキップしてフックを高速に起動させ、`-ExecutionPolicy Bypass` は PowerShell がローカルのスクリプトファイルを実行できるようにします。

    このスクリプトをプロジェクトの `.claude/hooks/plain-display.ps1` に保存します。

    ```powershell theme={null}
    $batch = [Console]::In.ReadToEnd() | ConvertFrom-Json
    $text = $batch.delta -replace '\*\*', '' -replace '`', ''
    @{
      hookSpecificOutput = @{
        hookEventName = "MessageDisplay"
        displayContent = $text
      }
    } | ConvertTo-Json
    ```
  </Tab>
</Tabs>

markdown を含まないバッチは変更されずにそのまま通過します。たとえば `jq` がないためにスクリプトが失敗した場合、Claude Code は元のテキストを表示し、その失敗はセッション内ではなく[デバッグ出力](#debug-hooks)にのみ記録されます。

<h3 id="pretooluse">
  PreToolUse
</h3>

Claude がツールのパラメーターを作成した後、ツール呼び出しを処理する前に実行されます。`EndConversation` を除く任意のツール名に一致します。対象は、`Bash`、`PowerShell`、`Edit`、`Write`、`Read`、`Glob`、`Grep`、`Agent`、`Workflow`、`WebFetch`、`WebSearch`、`AskUserQuestion`、`ExitPlanMode` などの組み込みツールと、任意の [MCP ツール名](#match-mcp-tools)です。

書き込んだものが何であれ、特定のファイルがディスク上で変更されたときにフックを実行するには、ファイル編集ツールを名前で照合する代わりに [FileChanged](#filechanged) を使用してください。PreToolUse とは異なり、Claude Code は FileChanged フックを変更の後に実行し、判定制御もないため、書き込みをブロックすることはできません。

<Warning>
  PreToolUse は、Claude がツールを呼び出したときにのみ実行されます。[プロンプト内で `@` を使って参照した](/docs/ja/common-workflows#reference-files-and-directories)ファイルは、ツール呼び出しなしで追加されます。Claude Code はプロンプトを組み立てる際にその内容を挿入するため、`Read` に一致するフックを含め、PreToolUse フックは発火しません。特定のパスを `@` 参照からブロックするには、代わりに [`Read` の拒否ルール](/docs/ja/permissions#read-and-edit)を使用してください。

  PreToolUse は [`EndConversation`](/docs/ja/tools-reference#endconversation-tool-behavior) でも発火しません。
</Warning>

[PreToolUse の判定制御](#pretooluse-decision-control)を使用して、ツール呼び出しを許可、拒否、確認、または延期します。

`PreToolUse` 上の [Agent SDK コールバックフック](/docs/ja/agent-sdk/hooks)がタイムアウトを超えると、ツール呼び出しがブロックされ、Claude はタイムアウトを示すエラー結果を受け取ります。他のフックが返した明示的な拒否は引き続き優先されます。

<h4 id="pretooluse-input">
  PreToolUse の入力
</h4>

[共通の入力フィールド](#common-input-fields)に加えて、PreToolUse フックは `tool_name`、`tool_input`、`tool_use_id` を受け取ります。

[MCP ツール](#match-mcp-tools)の場合、入力には `mcp_server` も含まれます。これは、サーバーの `name` と、サーバーの定義がどこから来たかを示す `source` を持つオブジェクトです。`source` の値には、`plugin`、`sdk`、および `user` や `project` などの設定スコープが含まれます。Agent SDK リファレンスの [`McpServerProvenance`](/docs/ja/agent-sdk/typescript#mcpserverprovenance) にすべての値が記載されており、認識できない値の扱い方も説明されています。信頼の判断は、`name` や `mcp__<server>__` というツール名のプレフィックスではなく、`source` に基づいて行ってください。`mcp_server` フィールドには Claude Code v2.1.274 以降が必要です。

ファイルツールの `Write`、`Edit`、`Read` では、`tool_input.file_path` は常に絶対パスです。

* Claude Code はフックの実行前に `~` と相対パスを展開するため、パスに対して照合するフックを、`~` や同じパスの相対表記で回避することはできません
* Windows では、フックが `$PWD` が `/c/project` のように見える Git Bash で実行される場合でも、パスはバックスラッシュ区切りで届きます
* `/src/` のチェックのようにスラッシュで記述した比較はバックスラッシュのパスに決して一致せず、ツール呼び出しはフックがブロックするものがなかったかのように続行されます
* 比較の前に区切り文字を正規化してください。Bash では `FILE_PATH="${FILE_PATH//\\//}"`、Python では `file_path.replace("\\", "/")` を使用します。その後、パスは絶対パスなので、`^` で固定するのではなく `/src/` のようなパスセグメントで照合してください

Windows での `Write` 呼び出しでは、次のように届きます。

```json theme={null}
{
  "hook_event_name": "PreToolUse",
  "tool_name": "Write",
  "tool_input": {
    "file_path": "C:\\project\\src\\index.ts",
    "content": "..."
  },
  ...
}
```

`tool_input` のフィールドはツールによって異なります。

<a id="bash" />

<h5 id="bash">
  Bash
</h5>

シェルコマンドを実行します。

| フィールド | 型 | 例 | 説明 |
| :- | :- | :- | :- |
| `command` | string | `"npm test"` | 実行するシェルコマンド |
| `description` | string | `"Run test suite"` | コマンドの動作についての説明（省略可） |
| `timeout` | number | `120000` | タイムアウト（ミリ秒、省略可）。[最大値](/docs/ja/tools-reference#bash-tool-behavior)を超える値は拒否されず、最大値に切り下げられます |
| `run_in_background` | boolean | `false` | コマンドをバックグラウンドで実行するかどうか |

Bash コマンドが Git リポジトリ内のファイルを変更すると、Claude Code は変更内容を記録できます。[`bashEditDiffEnabled`](/docs/ja/settings-reference#basheditdiffenabled) 設定で記録がオンになっている場合は、すべての権限モードで変更を記録します。どのファイルでこの設定を行えるかは、その設定の項目に記載されています。それ以外の場合は、auto モードと `bypassPermissions` モードで、かつ Claude Code が Claude に Bash 経由でファイルを編集するよう指示した場合にのみ記録します。記録をオフにするには、`bashEditDiffEnabled` を `false` に設定します。バックグラウンドのコマンドと読み取り専用のコマンドには差分は付きません。

その後、[PostToolUse フック](#posttooluse)は `tool_response.bashEditDiff` で変更されたファイルを受け取ります。この一覧は、コマンドの実行中にリポジトリ配下で変更されたものを対象とします。Git が無視するファイルとサブモジュール内のファイルは含まれません。Claude Code v2.1.269 以降が必要です。

<Note>
  この一覧はベストエフォートであり、パブリックベータ版です。Claude Code は変更を見落としたり、同時に別のプロセスが変更したファイルを含めたり、サイズの上限で打ち切ったりすることがあります。フィールドの形式は変更される可能性があります。この一覧はレビュー対象を見つけるために使用し、ポリシーの強制には使用しないでください。
</Note>

`changedFiles` と `files` はコマンドが変更したものを一覧にし、残りのフィールドはその一覧がどれだけ完全で信頼できるかを示します。

| フィールド | 型 | 例 | 説明 |
| :- | :- | :- | :- |
| `changedFiles` | array | `["/path/to/src/app.ts"]` | コマンドが変更したファイルの絶対パス（最大 200 件）。`files` に差分がある場合、または `moreFiles` が 0 より大きい場合に常に含まれます |
| `files` | array | `[{"filePath": "/path/to/src/app.ts", "hunks": [...]}]` | 表示用の、最大 5 つの変更ファイルの差分。コマンドが追加または削除したファイルでは `created` または `deleted` が `true` になります |
| `moreFiles` | number | `2` | `files` に差分が含まれていない変更ファイルの数 |
| `unavailable` | boolean | `true` | 差分が不完全な場合、または取得できなかった場合に設定されます |
| `skipped` | boolean | `true` | `git checkout` や `git stash` など、作業ツリーを移動させる Git コマンドの場合に設定され、Claude Code は差分を取得しません |
| `shared` | boolean | `true` | サブエージェントのものなど、別の Bash ツール呼び出しが同じリポジトリで同時に実行された場合に設定されます。一覧の変更の一部はそのコマンドによるものである可能性があります |

<a id="powershell" />

<h5 id="powershell">
  PowerShell
</h5>

PowerShell コマンドを実行します。プラットフォームごとの利用可否については、[PowerShell ツール](/docs/ja/tools-reference#powershell-tool)を参照してください。

フィールドは Bash ツールと同じで、コマンド文字列は `command` に入ります。

| フィールド | 型 | 例 | 説明 |
| :- | :- | :- | :- |
| `command` | string | `"Get-ChildItem -Recurse"` | 実行する PowerShell コマンド |
| `description` | string | `"List files recursively"` | コマンドの動作についての説明（省略可） |
| `timeout` | number | `120000` | タイムアウト（ミリ秒、省略可） |
| `run_in_background` | boolean | `false` | コマンドをバックグラウンドで実行するかどうか |

シェルコマンドを検査するフックでは、両方のツールをカバーするように `Bash|PowerShell` で照合してください。

* Windows では、PowerShell ツールが有効になっている環境であればどこでも、Claude は PowerShell をプライマリシェルとして扱い、シェルコマンドをそれ経由で実行します。
* Git Bash のない Windows では、このツールが自動的に有効になり、Claude Code は Bash ツールをまったく登録しません。
* `Bash` のみに一致するフックは、その環境では決して発火しません。

<h5 id="write">
  Write
</h5>

ファイルを作成または上書きします。

| フィールド | 型 | 例 | 説明 |
| :- | :- | :- | :- |
| `file_path` | string | `"/path/to/file.txt"` | 書き込むファイルの絶対パス |
| `content` | string | `"file content"` | ファイルに書き込む内容 |

<h5 id="edit">
  Edit
</h5>

既存のファイル内の文字列を置換します。

| フィールド | 型 | 例 | 説明 |
| :- | :- | :- | :- |
| `file_path` | string | `"/path/to/file.txt"` | 編集するファイルの絶対パス |
| `old_string` | string | `"original text"` | 検索して置換するテキスト |
| `new_string` | string | `"replacement text"` | 置換後のテキスト |
| `replace_all` | boolean | `false` | すべての出現箇所を置換するかどうか |

<h5 id="read">
  Read
</h5>

ファイルの内容を読み取ります。

| フィールド | 型 | 例 | 説明 |
| :- | :- | :- | :- |
| `file_path` | string | `"/path/to/file.txt"` | 読み取るファイルの絶対パス |
| `offset` | number | `10` | 読み取りを開始する行番号（省略可） |
| `limit` | number | `50` | 読み取る行数（省略可） |

<h5 id="glob">
  Glob
</h5>

glob パターンに一致するファイルを検索します。

| フィールド | 型 | 例 | 説明 |
| :- | :- | :- | :- |
| `pattern` | string | `"**/*.ts"` | ファイルを照合する glob パターン |
| `path` | string | `"/path/to/dir"` | 検索するディレクトリ（省略可）。デフォルトは現在の作業ディレクトリです |

<h5 id="grep">
  Grep
</h5>

正規表現でファイルの内容を検索します。

| フィールド | 型 | 例 | 説明 |
| :- | :- | :- | :- |
| `pattern` | string | `"TODO.*fix"` | 検索する正規表現パターン |
| `path` | string | `"/path/to/dir"` | 検索するファイルまたはディレクトリ（省略可） |
| `glob` | string | `"*.ts"` | ファイルを絞り込む glob パターン（省略可） |
| `output_mode` | string | `"content"` | `"content"`、`"files_with_matches"`、または `"count"`。デフォルトは `"files_with_matches"` です |
| `-i` | boolean | `true` | 大文字と小文字を区別しない検索 |
| `multiline` | boolean | `false` | 複数行のマッチングを有効にする |

<h5 id="webfetch">
  WebFetch
</h5>

Web コンテンツを取得して処理します。

| フィールド | 型 | 例 | 説明 |
| :- | :- | :- | :- |
| `url` | string | `"https://example.com/api"` | コンテンツを取得する URL |
| `prompt` | string | `"Extract the API endpoints"` | 取得したコンテンツに対して実行するプロンプト |

<h5 id="websearch">
  WebSearch
</h5>

Web を検索します。

| フィールド | 型 | 例 | 説明 |
| :- | :- | :- | :- |
| `query` | string | `"react hooks best practices"` | 検索クエリ |
| `allowed_domains` | array | `["docs.example.com"]` | 省略可：これらのドメインの結果のみを含める |
| `blocked_domains` | array | `["spam.example.com"]` | 省略可：これらのドメインの結果を除外する |

<h5 id="agent">
  Agent
</h5>

[サブエージェント](/docs/ja/sub-agents)を起動します。

| フィールド | 型 | 例 | 説明 |
| :- | :- | :- | :- |
| `prompt` | string | `"Find all API endpoints"` | エージェントが実行するタスク |
| `description` | string | `"Find API endpoints"` | タスクの短い説明 |
| `subagent_type` | string | `"Explore"` | 使用する特化型エージェントの種類 |
| `model` | string | `"sonnet"` | デフォルトを上書きするモデルエイリアス（省略可） |

フォアグラウンドの Agent 呼び出しが完了すると、[PostToolUse フック](#posttooluse)は `tool_response` でサブエージェントの結果と実行のテレメトリを受け取ります。実行を調べるにはこれらのフィールドを読んでください。`totalTokens` と `usage` は最後のリクエストのみを対象とするため、サブエージェント全体のトークンとコストの集計には、`query_source` が `"subagent"` で絞り込んだ[トークンとコストのカウンター](/docs/ja/monitoring-usage#token-counter)を使用してください。

| フィールド | 型 | 例 | 説明 |
| :- | :- | :- | :- |
| `status` | string | `"completed"` | フォアグラウンドのサブエージェントでは `"completed"`、バックグラウンドのサブエージェントでは `"async_launched"`。サブエージェントはデフォルトでバックグラウンドで実行されるため、`run_in_background` を省略した Agent 呼び出しも `"async_launched"` になります |
| `agentId` | string | `"a4d2c8f1e0b3a297"` | サブエージェントの実行の識別子 |
| `content` | array | `[{"type": "text", "text": "Found 12 endpoints..."}]` | サブエージェントの最終的なテキストブロック。レポートが `SubagentHandback` を経由するサブエージェントの場合は、代わりにその引き渡しについての短い注記 |
| `resolvedModel` | string | `"claude-sonnet-4-5"` | サブエージェントが開始時に使用したモデル。要求されたモデルと異なる場合があります |
| `modelsUsed` | array | `["claude-sonnet-4-5", "claude-haiku-4-5"]` | 使用されたモデルの順序（連続する重複はまとめられます）。実行中にモデルが切り替えられた場合にのみ設定されます。Claude Code v2.1.212 以降が必要です |
| `totalTokens` | number | `12450` | サブエージェントの最後の API リクエストのトークン数（入力、出力、キャッシュのトークンの合計）。実行全体の合計ではありません |
| `totalDurationMs` | number | `48211` | サブエージェントの実行にかかった実時間 |
| `totalToolUseCount` | number | `7` | サブエージェントが行ったツール呼び出しの数 |
| `usage` | object | `{"input_tokens": 8320, ...}` | 最後の API リクエストの種類別トークン内訳：`input_tokens`、`output_tokens`、`cache_creation_input_tokens`、`cache_read_input_tokens` |

Claude Code v2.1.271 以降では、[auto モード](/docs/ja/permission-modes#eliminate-prompts-with-auto-mode)で Claude Code が提供する [`SubagentHandback`](/docs/ja/tools-reference) ツールを使って実行されるサブエージェントは、レポートをテキストとして返すのではなく、そのツールを通じて届けます。その場合、`completed` 結果の `content` フィールドには、レポート自体ではなく、その引き渡しについての短い注記が含まれます。レポートを読むには、`SubagentHandback` に一致する `PreToolUse` または `PostToolUse` フックを設定し、`tool_input.message` を読み取ってください。

バックグラウンドのサブエージェントの場合、ツールはタスクがバックグラウンドに移った時点で返るため、`tool_response` には使用量のフィールドが含まれません。バックグラウンドでの起動はすぐに返り、Claude Code が実行中にバックグラウンドへ移したフォアグラウンドのタスクはその移行の時点で返ります。`status: "async_launched"`、`agentId`、`description`、`prompt`、`outputFile`、`resolvedModel` を持ちます。

`completed` の応答では、`resolvedModel` はサブエージェントが開始時に使用したモデルを示します。これは、`availableModels` や他の上書きが適用される場合など、`tool_input` の `model` の値と異なることがあります。`async_launched` の応答では、`resolvedModel` はエージェントがバックグラウンドに移った時点で使用していたモデルを示すため、バックグラウンドに移る前に行われた切り替えがそこに反映されます。`modelsUsed` と、バックグラウンド移行時の `resolvedModel` の動作には Claude Code v2.1.212 以降が必要です。

<a id="askuserquestion" />

<h5 id="askuserquestion">
  AskUserQuestion
</h5>

ユーザーに 1〜4 個の多肢選択式の質問をします。

| フィールド | 型 | 例 | 説明 |
| :- | :- | :- | :- |
| `questions` | array | `[{"question": "Which framework?", "header": "Framework", "options": [{"label": "React"}], "multiSelect": false}]` | 提示する質問。それぞれ `question` 文字列、短い `header`、`options` 配列、省略可能な `multiSelect` フラグを持ちます |
| `answers` | object | `{"Which framework?": "React"}` | 省略可。質問のテキストを選択されたオプションのラベルに対応付けます。複数選択の回答は、ラベルをカンマで連結します。Claude はこのフィールドを設定しません。プログラムで回答するには `updatedInput` 経由で指定してください |

<h5 id="exitplanmode">
  ExitPlanMode
</h5>

Claude が [plan モード](/docs/ja/permission-modes#analyze-before-you-edit-with-plan-mode)を終了する前に、計画を提示してユーザーに承認を求めます。Claude はツールを呼び出す前に計画をディスク上のファイルに書き込むため、モデルからの `tool_input` そのものは通常空です。Claude Code は、入力をフックに渡す前に計画の内容とファイルパスを挿入します。

| フィールド | 型 | 例 | 説明 |
| :- | :- | :- | :- |
| `plan` | string | `"## Refactor auth\n1. Extract..."` | Markdown 形式の計画の内容。ディスク上の計画ファイルから挿入されます |
| `planFilePath` | string | `"/Users/.../plans/refactor-auth.md"` | 計画ファイルのパス。挿入されます |
| `allowedPrompts` | array | `[{"tool": "Bash", "prompt": "run tests"}]` | 非推奨。Claude Code はこのフィールドを受け付けますが、無視します。v2.1.205 より前は、計画を実行するために Claude が要求したプロンプトベースの権限を保持していました |

`PostToolUse` では、`tool_response` は承認された計画を保持する `plan` と `filePath` のフィールドに加えて、内部のステータスフラグを持つオブジェクトです。計画の内容は、ディスクからファイルを読み直すのではなく、`tool_response.plan` から読み取ってください。

<h4 id="pretooluse-decision-control">
  PreToolUse の判定制御
</h4>

`PreToolUse` フックは、ツール呼び出しを続行するかどうかを制御できます。トップレベルの `decision` フィールドを使用する他のフックとは異なり、PreToolUse は `hookSpecificOutput` オブジェクト内で判定を返します。これにより、より細かな制御が可能になります。4 つの結果（許可、拒否、確認、延期）に加えて、実行前にツールの入力を変更できます。

| フィールド | 説明 |
| :- | :- |
| `permissionDecision` | `"allow"` は権限プロンプトをスキップします。ただし、[どのモードでも自動承認されないアクション](/docs/ja/permission-modes#actions-no-mode-auto-approves)と、[`updatedInput` との組み合わせ](#allow-with-updatedinput)が必要な `AskUserQuestion` と `ExitPlanMode` は除きます。`"deny"` はツール呼び出しを防ぎます。`"ask"` はユーザーに確認を求めます。`"defer"` は、ツールを後で再開できるように正常に終了します。フックが何を返しても、[拒否ルールと確認ルール](/docs/ja/permissions#manage-permissions)は引き続き評価されます |
| `permissionDecisionReason` | `"ask"` の場合、権限プロンプトでユーザーに表示されます。誰もそのプロンプトに応答できない `-p` の実行で Claude Code が[呼び出しを拒否する](/docs/ja/headless#turn-off-permission-prompts-in-unattended-runs)場合は、代わりに Claude がツール結果でその理由を読みます。`"deny"` の場合、Claude に表示されます。`"allow"` と `"defer"` の場合、[デバッグログ](#debug-hooks)にのみ書き込まれます |
| `updatedInput` | 実行前にツールの入力パラメーターを変更します。入力オブジェクト全体を置き換えるため、変更したフィールドとともに変更していないフィールドも含めてください。Claude Code は、権限ルールと Bash コマンドの[自動バックグラウンド化の対象かどうか](/docs/ja/tools-reference#foreground-commands-that-move-to-the-background)を、Claude が送信した入力ではなく、フックが返した入力に対して評価します。自動承認するには `"allow"` と、変更した入力をユーザーに表示するには `"ask"` と組み合わせます。`"defer"` の場合は無視されます |
| `additionalContext` | ツールの結果とともに Claude のコンテキストに追加される文字列。`permissionDecision` が `"defer"` の場合は無視されます。[Claude にコンテキストを追加する](#add-context-for-claude)を参照してください |

複数の PreToolUse フックが異なる判定を返した場合、優先順位は `deny` > `defer` > `ask` > `allow` です。

終了コード 2 で終了してブロックするフックは、`"deny"` と同じ経路をたどります。Claude は stderr のメッセージを拒否の理由として受け取ります。

フックが `"ask"` を返すと、ユーザーに表示される権限プロンプトには、フックの出どころを示すラベルが含まれます。任意の設定ファイルまたはエージェントのフロントマターからのフックでは `[settings]`、プラグインのフックでは `[plugin:<name>]`、スキルのフロントマターからのフックでは `[skill]` です。これにより、どの設定ソースが確認を求めているかをユーザーが理解しやすくなります。

フックの `"ask"` は、[auto モード](/docs/ja/permission-modes#eliminate-prompts-with-auto-mode)でも権限プロンプトを強制します。分類器は引き続きツール呼び出しを拒否できますが、呼び出しを黙って承認することはできません。v2.1.211 より前は、分類器は[サンドボックス](/docs/ja/sandboxing)外で実行される Bash コマンドを、フックが要求したプロンプトを表示せずに承認できました。その場合も分類器はそのコマンドに独自の安全ルールを適用しており、フックの `"deny"` は常に尊重されていました。

```json theme={null}
{
  "hookSpecificOutput": {
    "hookEventName": "PreToolUse",
    "permissionDecision": "allow",
    "permissionDecisionReason": "My reason here",
    "updatedInput": {
      "field_to_modify": "new value"
    },
    "additionalContext": "Current environment: production. Proceed with caution."
  }
}
```

<span id="allow-with-updatedinput" />

`-p` フラグを使った[非対話モード](/docs/ja/headless)では、Claude Code は、Agent SDK の `canUseTool` コールバックなど、プロンプトを受け取る[権限ホスト](/docs/ja/headless#turn-off-permission-prompts-in-unattended-runs)が実行にある場合にのみ、`AskUserQuestion` と `ExitPlanMode` を提供します。これらのツールにはユーザーの操作が必要です。`permissionDecision: "allow"` を `updatedInput` とともに返すと、その要件を満たせます。フックは stdin からツールの入力を読み取り、独自の UI で回答を収集し、それを `updatedInput` で返すことで、ツールはプロンプトなしで実行されます。これらのツールでは、`"allow"` だけを返しても十分ではありません。`AskUserQuestion` の場合は、元の `questions` 配列をそのまま返し、各質問のテキストを選択された回答に対応付ける [`answers`](#askuserquestion) オブジェクトを追加してください。

サーバーが [`_meta["anthropic/requiresUserInteraction"]`](/docs/ja/mcp#require-approval-for-a-specific-tool) でマークした MCP ツールはさらに厳格です。フックは `updatedInput` の有無にかかわらず、`"allow"` でその承認プロンプトをスキップすることはできません。ツールが必要とする操作をフックが収集したことを Claude Code が確認できないためです。

<Note>
  PreToolUse は以前はトップレベルの `decision` と `reason` フィールドを使用していましたが、このイベントではこれらは非推奨です。代わりに `hookSpecificOutput.permissionDecision` と `hookSpecificOutput.permissionDecisionReason` を使用してください。非推奨の値 `"approve"` と `"block"` は、それぞれ `"allow"` と `"deny"` に対応します。PostToolUse や Stop などの他のイベントでは、現在の形式としてトップレベルの `decision` と `reason` を引き続き使用します。
</Note>

<h4 id="defer-a-tool-call-for-later">
  ツール呼び出しを後で実行するために延期する
</h4>

`"defer"` は、Agent SDK アプリや Claude Code 上に構築したカスタム UI など、`claude -p` をサブプロセスとして実行し、その JSON 出力を読み取るインテグレーション向けです。これにより、呼び出し元のプロセスは Claude をツール呼び出しの時点で一時停止し、独自のインターフェースで入力を収集して、中断した場所から再開できます。Claude Code がこの値を尊重するのは、`-p` フラグを使った[非対話モード](/docs/ja/headless)のみです。対話セッションでは警告をログに記録し、フックの結果を無視します。

典型的なケースは `AskUserQuestion` ツールです。Claude はユーザーに何かを尋ねたいのに、回答するためのターミナルがありません。`-p` の実行では、`--permission-prompt-tool` で渡す MCP ツールなどの[権限ホスト](/docs/ja/headless#turn-off-permission-prompts-in-unattended-runs)がある場合にのみ `AskUserQuestion` が提供されるため、権限ホストを指定して実行を開始してください。往復の流れは次のとおりです。

1. Claude が `AskUserQuestion` を呼び出します。`PreToolUse` フックが発火します。
2. フックが `permissionDecision: "defer"` を返します。ツールは実行されません。プロセスは `stop_reason: "tool_deferred"` で終了し、保留中のツール呼び出しはトランスクリプトに保存されます。
3. 呼び出し元のプロセスは SDK の結果から `deferred_tool_use` を読み取り、独自の UI で質問を表示して回答を待ちます。
4. 呼び出し元のプロセスは、同じ権限ホストを指定して `claude -p --resume <session-id>` を実行します。同じツール呼び出しで再び `PreToolUse` が発火します。
5. フックは `updatedInput` に回答を入れて `permissionDecision: "allow"` を返します。ツールが実行され、Claude は処理を続けます。

`deferred_tool_use` フィールドには、ツールの `id`、`name`、`input` が含まれます。`input` は、Claude がツール呼び出しのために生成したパラメーターで、実行前に取得されたものです。

```json theme={null}
{
  "type": "result",
  "subtype": "success",
  "stop_reason": "tool_deferred",
  "session_id": "abc123",
  "deferred_tool_use": {
    "id": "toolu_01abc",
    "name": "AskUserQuestion",
    "input": { "questions": [{ "question": "Which framework?", "header": "Framework", "options": [{"label": "React"}, {"label": "Vue"}], "multiSelect": false }] }
  }
}
```

タイムアウトや再試行の上限はありません。セッションは再開するまでディスク上に残りますが、[`cleanupPeriodDays`](/docs/ja/settings-reference#cleanupperioddays) の保持期間による削除の対象となります。この削除は、[保持期間の削除ルール](/docs/ja/claude-directory#cleaned-up-automatically)に従い、デフォルトでは 30 日後にセッションファイルを削除します。再開時に回答の準備ができていない場合、フックは再び `"defer"` を返すことができ、プロセスは同じ方法で終了します。呼び出し元のプロセスは、最終的にフックから `"allow"` または `"deny"` を返すことで、いつループを抜けるかを制御します。

`"defer"` は、Claude がそのターンで単一のツール呼び出しを行う場合にのみ機能します。Claude が複数のツール呼び出しを一度に行う場合、`"defer"` は警告とともに無視され、ツールは通常の権限フローで処理されます。この制約は、再開時に再実行できるツールが 1 つだけだからです。バッチ内の 1 つの呼び出しだけを延期すると、他の呼び出しが未解決のまま残ってしまいます。

再開時に延期されたツールが利用できなくなっている場合、プロセスはフックが発火する前に `stop_reason: "tool_deferred_unavailable"` と `is_error: true` で終了します。これは、ツールを提供していた MCP サーバーが再開されたセッションで接続されていない場合に発生します。`deferred_tool_use` ペイロードは引き続き含まれるため、どのツールが失われたかを特定できます。

<Note>
  延期されたセッションを plan モードで再開するには、Claude Code が承認のために計画を提示できるよう、`--resume` とともに [`--permission-prompt-tool`](/docs/ja/cli-reference#cli-flags) を渡してください。特定の他の起動フラグを渡すと、再開された実行は plan モードに戻りません。[`-p` で plan モードで再開する](/docs/ja/sessions#resume-in-plan-mode-with-p)を参照してください。Claude Code v2.1.246 以降が必要です。

  `-p` で再開する場合、Claude Code は他の保存された権限モードを復元しません。新しい `claude -p` の実行が開始する権限モードで実行を開始するため、延期されたセッションで `--permission-mode` や `--dangerously-skip-permissions` を使用していた場合は、再度渡してください。`-p` なしで `claude --resume <session-id>` を使って再開する場合、Claude Code は保存された権限モードを復元します。例外は[再開時の権限モード](/docs/ja/sessions#permission-mode-on-resume)に記載されています。
</Note>

<h3 id="permissionrequest">
  PermissionRequest
</h3>

Claude Code がツールを使用するための権限をユーザーに求めようとしているときに実行されます。[非対話モード](/docs/ja/headless)のバックグラウンドのサブエージェントなど、プロンプトを表示できないセッションでも、Claude Code はこれらのフックを実行し、どのフックも判定を返さない場合はツール呼び出しを拒否します。`--permission-prompt-tool` または Agent SDK の [`canUseTool` コールバック](/docs/ja/agent-sdk/permissions)に到達する呼び出しの場合、フックはホストと並行して実行され、先に判定したほうが適用されます。
[PermissionRequest の判定制御](#permissionrequest-decision-control)を使用して、ユーザーに代わって許可または拒否します。

Claude がツールを使用するための権限を求めた瞬間にシグナルが必要な場合に、このイベントを使用します。Claude Code が `permission_prompt` タイプの [Notification](#notification) フックを実行するのは、プロンプトが約 6 秒間待機した後です。

Claude Code は、サンドボックス化されたコマンドの[ネットワークリクエスト](/docs/ja/sandboxing#network-isolation)に対しては PermissionRequest フックを実行しません。そのプロンプトのシグナルを得るには、`permission_prompt` 通知タイプを使用してください。

ツール名に対して照合し、値は PreToolUse と同じです。

<h4 id="permissionrequest-input">
  PermissionRequest の入力
</h4>

PermissionRequest フックは、PreToolUse フックと同様に `tool_name` と `tool_input` フィールドを受け取りますが、`tool_use_id` は含まれません。MCP ツールの場合は、[`mcp_server`](#pretooluse-input) オブジェクトも受け取ります。省略可能な `permission_suggestions` 配列には、許可ルールの追加や権限モードの変更など、このリクエストに対して Claude Code が提案する[権限の更新](#permission-update-entries)が含まれます。

各権限ダイアログは独自のオプションを構築するため、`permission_suggestions` 配列は表示されるオプションの正確な一覧ではありません。ファイル編集用のダイアログなど、一部のダイアログはこの配列をまったく読み取らず、リクエスト自体からオプションを導き出します。配列を読み取るダイアログでも、提案が配列に残っているオプションを表示しないことがあります。たとえば、[`allowManagedPermissionRulesOnly`](/docs/ja/settings-reference#allowmanagedpermissionrulesonly) がルールを保存するオプションを非表示にする場合です。また、[**Yes, and switch to auto mode**](/docs/ja/permission-modes#switch-permission-modes) のように、提案エントリを持たないオプションを提示することもあります。このオプションは、権限の更新を介さずに権限モードを直接変更します。

PreToolUse フックは、権限が必要かどうかにかかわらず、すべてのツール呼び出しの前に実行されます。PermissionRequest フックは、Claude Code が権限をユーザーに求めようとしているとき、またはプロンプトを表示できない呼び出しを本来なら自動拒否するときにのみ実行されます。どちらのイベントも [`EndConversation`](/docs/ja/tools-reference#endconversation-tool-behavior) では発火しません。

```json theme={null}
{
  "session_id": "abc123",
  "transcript_path": "/Users/.../.claude/projects/.../00893aaf-19fa-41d2-8238-13269b9b3ca0.jsonl",
  "cwd": "/Users/...",
  "permission_mode": "default",
  "hook_event_name": "PermissionRequest",
  "tool_name": "Bash",
  "tool_input": {
    "command": "rm -rf node_modules",
    "description": "Remove node_modules directory"
  },
  "permission_suggestions": [
    {
      "type": "addRules",
      "rules": [{ "toolName": "Bash", "ruleContent": "rm -rf node_modules" }],
      "behavior": "allow",
      "destination": "localSettings"
    }
  ]
}
```

<h4 id="permissionrequest-decision-control">
  PermissionRequest の判定制御
</h4>

`PermissionRequest` フックは、権限リクエストを許可または拒否できます。すべてのフックで利用できる [JSON 出力フィールド](#json-output)に加えて、フックスクリプトは以下のイベント固有のフィールドを持つ `decision` オブジェクトを返すことができます。

| フィールド | 説明 |
| :- | :- |
| `behavior` | `"allow"` は権限を付与し、`"deny"` は拒否します。[拒否ルールと確認ルール](/docs/ja/permissions#manage-permissions)は引き続き評価されるため、`"allow"` を返すフックが一致する拒否ルールを上書きすることはありません |
| `updatedInput` | `"allow"` の場合のみ：実行前にツールの入力パラメーターを変更します。入力オブジェクト全体を置き換えるため、変更したフィールドとともに変更していないフィールドも含めてください。変更された入力は、拒否ルールと確認ルールに対して再評価されます |
| `updatedPermissions` | `"allow"` の場合のみ：適用する[権限の更新エントリ](#permission-update-entries)の配列。許可ルールの追加やセッションの権限モードの変更などです |
| `message` | `"deny"` の場合のみ：権限が拒否された理由を Claude に伝えます |
| `interrupt` | `"deny"` の場合のみ：`true` の場合、Claude を停止します |

`decision` オブジェクトなしで終了コード 2 で終了するフックは権限フローを変更せず、その stderr は破棄されます。リクエストを許可または拒否できるのは `decision` オブジェクトのみです。

```json theme={null}
{
  "hookSpecificOutput": {
    "hookEventName": "PermissionRequest",
    "decision": {
      "behavior": "allow",
      "updatedInput": {
        "command": "npm run lint"
      }
    }
  }
}
```

<h4 id="permission-update-entries">
  権限の更新エントリ
</h4>

`updatedPermissions` 出力フィールドと [`permission_suggestions` 入力フィールド](#permissionrequest-input)は、どちらも同じエントリオブジェクトの配列を使用します。各エントリには、他のフィールドを決定する `type` と、変更の書き込み先を制御する `destination` があります。

| `type` | フィールド | 効果 |
| :- | :- | :- |
| `addRules` | `rules`、`behavior`、`destination` | 権限ルールを追加します。`rules` は `{toolName, ruleContent?}` オブジェクトの配列です。ツール全体に一致させるには `ruleContent` を省略します。`behavior` は `"allow"`、`"deny"`、または `"ask"` です |
| `replaceRules` | `rules`、`behavior`、`destination` | `destination` にある指定の `behavior` のすべてのルールを、指定した `rules` で置き換えます |
| `removeRules` | `rules`、`behavior`、`destination` | 指定の `behavior` の一致するルールを削除します |
| `setMode` | `mode`、`destination` | 権限モードを変更します。有効なモードは `default`、`auto`、`acceptEdits`、`dontAsk`、`bypassPermissions`、`plan`、および `default` のエイリアスとしての `manual` です。`manual` エイリアスには Claude Code v2.1.200 以降が必要です |
| `addDirectories` | `directories`、`destination` | 作業ディレクトリを追加します。`directories` はパス文字列の配列です |
| `removeDirectories` | `directories`、`destination` | 作業ディレクトリを削除します |

<Note>
  `bypassPermissions` を指定した `setMode` は、バイパスモードがすでに利用可能な状態でセッションを起動した場合にのみ有効になります。バイパスモードを利用可能にするには、`--dangerously-skip-permissions`、`--permission-mode bypassPermissions`、`--allow-dangerously-skip-permissions` のいずれかを使用するか、[ユーザー設定、`--settings`、または管理設定](/docs/ja/settings-reference#permissions-defaultmode)で `permissions.defaultMode: "bypassPermissions"` を指定します。それ以外の場合、この更新は何も行いません。また、[`permissions.disableBypassPermissionsMode`](/docs/ja/permissions#managed-settings) によってこのモードが無効化されている場合や、セッションが [restricted モード](/docs/ja/cli-reference#cli-flags)で開始された場合も、この更新は何も行いません。

  `bypassPermissions` は、`destination` に関係なく `defaultMode` として永続化されることはありません。
</Note>

各エントリの `destination` フィールドは、変更をメモリ内にとどめるか、設定ファイルに永続化するかを決定します。

| `destination` | 書き込み先 |
| :- | :- |
| `session` | メモリ内のみ。セッション終了時に破棄されます |
| `localSettings` | `.claude/settings.local.json` |
| `projectSettings` | `.claude/settings.json` |
| `userSettings` | `~/.claude/settings.json` |

フックは、受け取った `permission_suggestions` のいずれかを、そのまま自身の `updatedPermissions` 出力として返すことができます。

<h3 id="posttooluse">
  PostToolUse
</h3>

ツールが正常に完了した直後に実行されます。

ツール名でマッチします。値は PreToolUse と同じです。

ツール名が適切なフィルターにならない場合は、より広くマッチさせます。

* いずれかのツールが正常に完了した後にフックを実行するには、`matcher` を省略するか `"*"` に設定します。フック側で何が変更されたかを自ら調べることができます。たとえば `git status --porcelain` を実行すると、`git diff` では見落とされる未追跡ファイルも一覧表示されます。失敗したツール呼び出しについては、同じフックを [PostToolUseFailure](#posttoolusefailure) の下に追加します。
* 書き込んだのが何であれ、特定のファイルがディスク上で変更されたときにフックを実行するには、[FileChanged](#filechanged) を使用します。`Bash` コマンドや Claude Code 外部のプロセスが同じファイルを書き換えた場合、Claude Code は `Edit|Write` にマッチする `PostToolUse` フックを実行しません。

<h4 id="posttooluse-input">
  PostToolUse の入力
</h4>

`PostToolUse` フックは、ツールがすでに正常に実行された後に発火します。入力には、ツールに送られた引数である `tool_input` と、ツールが返した結果である `tool_response` の両方が含まれます。両者の正確なスキーマはツールによって異なります。ファイルツールの `tool_input` のパスは [PreToolUse](#pretooluse-input) と同じ形式で渡されます。つまり、常に絶対パスで、プラットフォーム固有の区切り文字が使われるため、Windows ではバックスラッシュになります。MCP ツールの場合、入力には [`mcp_server`](#pretooluse-input) オブジェクトも含まれます。

```json theme={null}
{
  "session_id": "abc123",
  "transcript_path": "/Users/.../.claude/projects/.../00893aaf-19fa-41d2-8238-13269b9b3ca0.jsonl",
  "cwd": "/Users/...",
  "permission_mode": "default",
  "hook_event_name": "PostToolUse",
  "tool_name": "Write",
  "tool_input": {
    "file_path": "/path/to/file.txt",
    "content": "file content"
  },
  "tool_response": {
    "filePath": "/path/to/file.txt",
    "type": "create"
  },
  "tool_use_id": "toolu_01ABC123...",
  "duration_ms": 12
}
```

| フィールド | 説明 |
| :- | :- |
| `duration_ms` | 省略可能。ツールの実行時間（ミリ秒）。権限プロンプトと PreToolUse フックに費やされた時間は含みません |

<h4 id="posttooluse-decision-control">
  PostToolUse の判定制御
</h4>

`PostToolUse` フックは、ツール実行後に Claude へフィードバックを提供できます。すべてのフックで利用できる [JSON 出力フィールド](#json-output)に加えて、フックスクリプトは次のイベント固有フィールドを返すことができます。

| フィールド | 説明 |
| :- | :- |
| `decision` | `"block"` を指定すると、ツール結果の横に `reason` が追加されます。Claude には元の出力も引き続き表示されます。出力を置き換えるには `updatedToolOutput` を使用します |
| `reason` | `decision` が `"block"` のときに Claude に示される説明 |
| `additionalContext` | ツール結果とともに Claude のコンテキストに追加される文字列。[Claude にコンテキストを追加する](#add-context-for-claude)を参照してください |
| `classifierContext` | この呼び出しの結果について、Claude ではなく [auto モード](/docs/ja/permission-modes#eliminate-prompts-with-auto-mode)の分類器に向けた短い注記。[auto モードの分類器向けに結果に注記を付ける](#annotate-a-result-for-the-auto-mode-classifier)を参照してください。Claude Code v2.1.236 以降が必要です |
| `updatedToolOutput` | Claude に送られる前に、ツールの出力を指定した値で置き換えます。値はツールの出力の形式と一致している必要があります |
| `updatedMCPToolOutput` | [MCP ツール](#match-mcp-tools)に限り出力を置き換えます。すべてのツールで機能する `updatedToolOutput` の使用を推奨します |

次の例は、`Bash` 呼び出しの出力を置き換えます。置き換える値は `Bash` ツールの出力の形式に一致しています。

```json theme={null}
{
  "hookSpecificOutput": {
    "hookEventName": "PostToolUse",
    "additionalContext": "Additional information for Claude",
    "updatedToolOutput": {
      "stdout": "[redacted]",
      "stderr": "",
      "interrupted": false,
      "isImage": false
    }
  }
}
```

<Warning>
  `updatedToolOutput` が変更するのは Claude に見える内容だけです。フックが発火する時点でツールはすでに実行されているため、書き込まれたファイル、実行されたコマンド、送信されたネットワークリクエストはすでに反映されています。OpenTelemetry のツールスパンや分析イベントなどのテレメトリも、フックが実行される前の元の出力を記録します。ツール呼び出しを実行前に阻止または変更するには、代わりに [PreToolUse](#pretooluse) フックを使用してください。

  置き換える値はツールの出力の形式と一致している必要があります。組み込みツールはプレーンな文字列ではなく構造化されたオブジェクトを返します。たとえば `Bash` は、`stdout`、`stderr`、`interrupted`、`isImage` フィールドを持つオブジェクトを返します。組み込みツールの場合、ツールの出力スキーマに一致しない値は無視され、元の出力が使用されます。MCP ツールの出力はスキーマ検証なしでそのまま渡されます。Claude が必要とするエラーの詳細を取り除くと、Claude が誤った前提のまま作業を進める可能性があります。
</Warning>

<h4 id="annotate-a-result-for-the-auto-mode-classifier">
  auto モードの分類器向けに結果に注記を付ける
</h4>

`classifierContext` を返すと、ツール呼び出しの結果に関する短い注記を、Claude ではなく [auto モード](/docs/ja/permission-modes#eliminate-prompts-with-auto-mode)の分類器に送ることができます。分類器は[ツール結果そのものを受け取ることはない](/docs/ja/permission-modes#how-the-classifier-evaluates-actions)ため、後続のアクションを審査する前に、呼び出しが何を返したかについて分類器に伝えるには、このフィールドを使うのがサポートされた方法です。このフィールドには Claude Code v2.1.236 以降が必要です。

次の例は、クエリの出力がどこから得られたかを分類器に伝えます。

```json theme={null}
{
  "hookSpecificOutput": {
    "hookEventName": "PostToolUse",
    "classifierContext": "This query ran against the staging database, not production."
  }
}
```

分類器が注記をどの程度重視するかは、フックをどこで設定したかによって異なります。

* **Claude Code で設定されたフック**: 設定ファイル、プラグイン、スキル、エージェントのフロントマターから読み込まれたフックの場合、分類器は注記を未検証の、アプリケーションから提供されたコンテキストとして扱います。注記がユーザーの意図を確立することはなく、ユーザーが何かを承認または要求したと注記が主張する場合、分類器はその主張を会話内のユーザー自身のメッセージと照合します
* **インプロセスの Agent SDK コールバック**: Claude Code を組み込んだアプリケーションがフックを [TypeScript SDK コールバック](/docs/ja/agent-sdk/hooks)として登録し、ライブセッション中に注記を返す場合、分類器は注記で伝えられたユーザーの発言をユーザーの意図として考慮することがあります。そのような発言は、ユーザーが送信したメッセージであれば分類器が受け入れる同意要件を満たすことはありますが、ユーザー自身のメッセージでも解除できないブロックを解除することはありません。セッションが再開された後は、Claude Code は復元された注記を未検証のコンテキストとして扱います。両方のグループのフックが同じ呼び出しに注記を付けた場合、分類器は結合された注記を未検証として扱います

Claude Code は注記を渡す際に次の制限を適用します。

* **長さ**: Claude Code は 1 回のツール呼び出しに対する注記を 2,000 文字までに制限し、残りを切り捨てます。この上限は、その呼び出しに応答するすべてのフックで共有されます
* **同期的な応答のみ**: [バックグラウンドで実行される](#run-hooks-in-the-background)フックの応答では、Claude Code はこのフィールドを無視します。その応答は Claude Code がツール結果を記録した後に届くためです
* **分類器が記録しない呼び出し**: 分類器のトランスクリプトには、ファイルの読み取りや検索などの読み取り専用の参照は含まれません。Claude Code は、そのような呼び出しに付けられた注記を破棄します
* **書き換えとの相互作用**: `updatedToolOutput` で置き換える出力について注記が説明している場合は、同じフックの応答で両方のフィールドを返してください。その書き換えが拒否された場合や、別のフックの書き換えで置き換えられた場合、Claude Code は注記を破棄します。書き換えなしで返した注記は、別のフックが出力を書き換えた場合でも Claude Code によって渡されます

<Warning>
  分類器は `classifierContext` に入れた内容を、セッションをホストしているアプリケーションからの情報として読み取ります。そのため、信頼できないツール出力やサードパーティのテキストをコピーして入れないでください。注記は、その出所に関する事実やそれについてのユーザーの発言など、この 1 回の呼び出しについての短い主張にとどめてください。無関係なメッセージやイベントのストリームを渡すためにこのフィールドを使用しないでください。
</Warning>

<h3 id="posttoolusefailure">
  PostToolUseFailure
</h3>

実行を開始したツールが失敗したとき、つまりツールがエラーをスローしたか、MCP ツールがエラー結果を返したときに実行されます。失敗のログ記録、アラートの送信、Claude への修正フィードバックの提供に使用します。

ツール名でマッチします。値は PreToolUse と同じです。

<Note>
  このイベントは、実行前に拒否されたツール呼び出しでは発火しません。該当するのは、不明なツール名、スキーマ検証やツール固有の検証に失敗した入力、権限の拒否です。検証による拒否は `tool_use_error` 結果として返され、フックが実行される前に発生するため、`PreToolUse` も `PostToolUseFailure` も発火しません。権限の拒否では `PreToolUse` は発火しますが、このイベントは発火しません。[PermissionDenied](#permissiondenied) を参照してください。
</Note>

<h4 id="posttoolusefailure-input">
  PostToolUseFailure の入力
</h4>

PostToolUseFailure フックは、PostToolUse と同じ `tool_name` と `tool_input` フィールドに加えて、エラー情報をトップレベルのフィールドとして受け取ります。MCP ツールの場合は、[`mcp_server`](#pretooluse-input) オブジェクトも受け取ります。たとえば、失敗した `npm test` コマンドでは次のような入力が渡されます。

```json theme={null}
{
  "session_id": "abc123",
  "transcript_path": "/Users/.../.claude/projects/.../00893aaf-19fa-41d2-8238-13269b9b3ca0.jsonl",
  "cwd": "/Users/...",
  "permission_mode": "default",
  "hook_event_name": "PostToolUseFailure",
  "tool_name": "Bash",
  "tool_input": {
    "command": "npm test",
    "description": "Run test suite"
  },
  "tool_use_id": "toolu_01ABC123...",
  "error": "Exit code 1\nError: Cannot find module 'express'",
  "is_interrupt": false,
  "duration_ms": 4187
}
```

| フィールド | 説明 |
| :- | :- |
| `error` | 何が問題だったかを説明する文字列。形式は失敗したツールによって異なります |
| `is_interrupt` | 省略可能なブール値。ツールが報告したエラーとしてではなく、中断として Claude Code に失敗が伝わった場合に true になります。実行中のツールをキャンセルしてもこのフックは発火せず、代わりにツール結果に中断メッセージが含まれます |
| `duration_ms` | 省略可能。ツールの実行時間（ミリ秒）。権限プロンプトと PreToolUse フックに費やされた時間は含みません |

`error` 文字列は通常、失敗したツールの結果として Claude が受け取るテキストと同じです。形式はツールと失敗の種類によって異なります。フックの判定には `tool_name`、`is_interrupt`、および先頭行の `Exit code N` を使用し、文字列の残りの部分は安定した形式ではなく表示用テキストとして扱ってください。

* Bash と PowerShell の場合、実行されて終了したコマンドでは、先頭行が `Exit code N` となり、その後にコマンドが生成した出力が stdout と stderr の混在した 1 つのブロックとして続きます
* Claude Code がシェルプロセス自体を起動できなかった場合、ペイロードには終了コードの行がない失敗メッセージだけが含まれることもあります
* Claude Code は長い文字列を `... [N characters truncated] ...` マーカーを挟んで中間部分を切り詰めることがあり、`Command timed out after 2m 0s` のような独自の行を挿入することもあります

<h4 id="posttoolusefailure-decision-control">
  PostToolUseFailure の判定制御
</h4>

`PostToolUseFailure` フックは、ツールの失敗後に Claude へコンテキストを提供できます。すべてのフックで利用できる [JSON 出力フィールド](#json-output)に加えて、フックスクリプトは次のイベント固有フィールドを返すことができます。

| フィールド | 説明 |
| :- | :- |
| `additionalContext` | エラーとともに Claude のコンテキストに追加される文字列。[Claude にコンテキストを追加する](#add-context-for-claude)を参照してください |

```json theme={null}
{
  "hookSpecificOutput": {
    "hookEventName": "PostToolUseFailure",
    "additionalContext": "Additional information about the failure for Claude"
  }
}
```

<h3 id="posttoolbatch">
  PostToolBatch
</h3>

バッチ内のすべてのツール呼び出しが解決された後、Claude Code が次のリクエストをモデルに送信する前に 1 回実行されます。`PostToolUse` はツールごとに 1 回発火するため、Claude が並列でツールを呼び出すと同時に発火します。`PostToolBatch` はバッチ全体に対して正確に 1 回だけ発火するため、単一のツールではなく実行されたツールの組み合わせに依存するコンテキストを注入するのに適しています。このイベントには matcher はありません。

<h4 id="posttoolbatch-input">
  PostToolBatch の入力
</h4>

[共通入力フィールド](#common-input-fields)に加えて、PostToolBatch フックは、バッチ内のすべてのツール呼び出しを記述する配列 `tool_calls` を受け取ります。

```json theme={null}
{
  "session_id": "abc123",
  "transcript_path": "/Users/.../.claude/projects/.../00893aaf-19fa-41d2-8238-13269b9b3ca0.jsonl",
  "cwd": "/Users/...",
  "permission_mode": "default",
  "hook_event_name": "PostToolBatch",
  "tool_calls": [
    {
      "tool_name": "Read",
      "tool_input": {"file_path": "/.../ledger/accounts.py"},
      "tool_use_id": "toolu_01...",
      "tool_response": "1\tfrom __future__ import annotations\n2\t..."
    },
    {
      "tool_name": "Read",
      "tool_input": {"file_path": "/.../ledger/transactions.py"},
      "tool_use_id": "toolu_02...",
      "tool_response": "1\tfrom __future__ import annotations\n2\t..."
    }
  ]
}
```

`tool_response` には、対応する `tool_result` ブロックでモデルが受け取るのと同じ内容が含まれます。値は、ツールが出力したとおりのシリアライズされた文字列またはコンテンツブロックの配列です。`Read` の場合、これは生のファイル内容ではなく、行番号が先頭に付いたテキストを意味します。応答は大きくなる場合があるため、必要なフィールドだけを解析してください。

<Note>
  `tool_response` の形式は `PostToolUse` のものとは異なります。`PostToolUse` はツールの構造化された `Output` オブジェクト（`Write` の場合は `{filePath: "...", type: "create"}` など）を渡しますが、`PostToolBatch` はモデルに見えるシリアライズされた `tool_result` の内容を渡します。
</Note>

<h4 id="posttoolbatch-decision-control">
  PostToolBatch の判定制御
</h4>

`PostToolBatch` フックは、Claude 向けのコンテキストを注入できます。すべてのフックで利用できる [JSON 出力フィールド](#json-output)に加えて、フックスクリプトは次のイベント固有フィールドを返すことができます。

| フィールド | 説明 |
| :- | :- |
| `additionalContext` | 次のモデル呼び出しの前に 1 回注入されるコンテキスト文字列。渡され方の詳細、入れるべき内容、再開されたセッションで過去の値がどう扱われるかについては、[Claude にコンテキストを追加する](#add-context-for-claude)を参照してください |

```json theme={null}
{
  "hookSpecificOutput": {
    "hookEventName": "PostToolBatch",
    "additionalContext": "These files are part of the ledger module. Run pytest before marking the task complete."
  }
}
```

`decision: "block"` または `continue: false` を返すと、次のモデル呼び出しの前にエージェント型ループが停止します。ブロックメッセージは、JSON の `reason` または `stopReason`、あるいは終了コード 2 の場合は stderr から取得されます。このメッセージはトランスクリプトに警告として表示され、会話にも残るため、会話が続行されると Claude はそれを確認できます。

<h3 id="permissiondenied">
  PermissionDenied
</h3>

[auto モード](/docs/ja/permission-modes#eliminate-prompts-with-auto-mode)がツール呼び出しを拒否したときに実行されます。これには、[auto モードとは別の安全性チェックが分類器自身のリクエストを拒否した](/docs/ja/errors#auto-mode-cannot-determine-the-safety-of-an-action)場合や、分類器の応答を解析できなかった場合など、分類器の判定なしで拒否された場合も含まれます。このフックは auto モードでのみ発火します。ユーザーが権限ダイアログを手動で拒否した場合、`PreToolUse` フックが呼び出しをブロックした場合、`deny` ルールがマッチした場合には実行されません。拒否のログ記録、設定の調整、またはツール呼び出しを再試行してよいことをモデルに伝えるために使用します。

ツール名でマッチします。値は PreToolUse と同じです。

<h4 id="permissiondenied-input">
  PermissionDenied の入力
</h4>

[共通入力フィールド](#common-input-fields)に加えて、PermissionDenied フックは `tool_name`、`tool_input`、`tool_use_id`、`reason` を受け取ります。MCP ツールの場合は、[`mcp_server`](#pretooluse-input) オブジェクトも受け取ります。

```json theme={null}
{
  "session_id": "abc123",
  "transcript_path": "/Users/.../.claude/projects/.../00893aaf-19fa-41d2-8238-13269b9b3ca0.jsonl",
  "cwd": "/Users/...",
  "permission_mode": "auto",
  "hook_event_name": "PermissionDenied",
  "tool_name": "Bash",
  "tool_input": {
    "command": "rm -rf /tmp/build",
    "description": "Clean build directory"
  },
  "tool_use_id": "toolu_01ABC123...",
  "reason": "[Irreversible Local Destruction]"
}
```

| フィールド | 説明 |
| :- | :- |
| `reason` | 拒否の理由。分類器の判定による場合、ほとんどのセッションでは、`[Data Exfiltration]` のように角括弧でマッチしたルールの名前が示されます。その他の形式については [拒否を確認する](/docs/ja/auto-mode-config#review-denials)を参照してください。[判定なしの拒否](#permissiondenied-decision-control)の場合は、`Auto mode could not evaluate this action and is blocking it for safety` で始まります。分類器モデルが利用できなかったことによる拒否の場合は、固定テキスト `Classifier unavailable` になります |

<h4 id="permissiondenied-decision-control">
  PermissionDenied の判定制御
</h4>

PermissionDenied フックは、拒否されたツール呼び出しを再試行してよいことをモデルに伝えることができます。`hookSpecificOutput.retry` を `true` に設定した JSON オブジェクトを返します。

```json theme={null}
{
  "hookSpecificOutput": {
    "hookEventName": "PermissionDenied",
    "retry": true
  }
}
```

`retry` が `true` の場合、Claude Code は、ツール呼び出しを再試行してよいことをモデルに伝えるメッセージを会話に追加します。Claude Code 自体が拒否を取り消すことはありません。フックが JSON を返さない場合、または `retry: false` を返した場合、拒否はそのまま維持され、モデルは元の拒否メッセージを受け取ります。

分類器が[アクションについて判定を出さなかった](/docs/ja/errors#auto-mode-cannot-determine-the-safety-of-an-action)場合、つまり分類器の応答を解析できなかった場合や、auto モードとは別の安全性チェックが分類器自身のリクエストを拒否した場合、Claude Code は `retry: true` を無視します。そのような拒否については、後で再試行するか先に進むかを、Claude Code がすでに拒否メッセージでモデルに伝えています。

<h3 id="notification">
  Notification
</h3>

Claude Code が通知を送信するときに実行されます。通知の種類でマッチします。すべての通知の種類でフックを実行するには、matcher を省略します。

デスクトップ通知をオフにしていても、これらのフックイベントは受け取ります。`preferredNotifChannel` 設定（`notifications_disabled` を含む）が変更するのはユーザーへの通知方法だけで、フックが実行されるかどうかは変わりません。

| Matcher | 発火するタイミング |
| :- | :- |
| `permission_prompt` | Claude がツールの使用またはサンドボックス化されたコマンドの[ネットワークリクエスト](/docs/ja/sandboxing#network-isolation)について承認を必要としており、プロンプトが約 6 秒間待機している |
| `idle_prompt` | Claude が約 60 秒前に応答を終え、それ以降ユーザーが入力していない |
| `auth_success` | 認証が完了した |
| `elicitation_dialog` | MCP サーバーが elicitation フォームを開き、ユーザーが約 6 秒間入力していない |
| `elicitation_url_dialog` | MCP サーバーがブラウザーの URL を開くようユーザーに求め、ユーザーが約 6 秒間入力していない |
| `elicitation_complete` | MCP サーバーが [URL モードの elicitation](#elicitation-input) の完了を報告した |
| `elicitation_response` | MCP の elicitation 応答がサーバーに返送された |
| `agent_needs_input` | ターミナルで[エージェントビュー](/docs/ja/agent-view)が開いている間に、バックグラウンドセッションがユーザーの入力を待ち始めた。また、ターミナルセッションが[エージェントチームのチームメイトのターミナル設定に関する質問](/docs/ja/agent-teams#choose-a-display-mode)や、[分類器リクエストの料金](/docs/ja/auto-mode-classifier-billing)に関する auto モードの通知を表示し、ユーザーが約 6 秒間入力していない場合にも発火します |
| `agent_completed` | バックグラウンドセッションが終了または失敗した。ターミナルで[エージェントビュー](/docs/ja/agent-view)が開いている間のみ発火します |
| `quota_auto_resume_fired` | claude.ai の使用制限によって一時停止したタスクを Claude Code が続行した。続行はリセット時点、または待機中に Claude Code で行った操作（使用クレジットの追加、プランのアップグレード、モデルの切り替えなど）によって使用量が再び利用可能になった場合はそれより早く行われます。ただし[モデル設定の例外](/docs/ja/interactive-mode#wait-for-a-usage-limit-to-reset)があります |
| `quota_auto_resume_stale` | コンピューターが約 30 分を超えてスリープしている間に claude.ai の使用制限がリセットされた。Claude Code は続行せず、ユーザーが `Enter` を押すのを待ちます。スリープがそれより短い場合は続行し、代わりに `quota_auto_resume_fired` を発火します |
| `quota_auto_resume_disabled` | Claude Code がタスクを続行せずに claude.ai の使用制限の待機を終了した。原因は、[`autoContinueAtUsageLimit`](/docs/ja/settings-reference#autocontinueatusagelimit) がオフにされた、Claude Code が自ら開始した待機中にリセットが 24 時間以上先に移動した、続行したタスクが繰り返し制限に達した、または続行がモデルに届く前にブロックされた、のいずれかです。ユーザーが `Esc` または `Ctrl+C` を押した場合や、**Don't continue automatically** を選択した場合は発火しません |

`quota_auto_resume_fired`、`quota_auto_resume_stale`、`quota_auto_resume_disabled` の種類には Claude Code v2.1.234 以降が必要です。

ターミナルセッションでは、サンドボックス化されたコマンドのネットワークリクエストに対する `permission_prompt` には Claude Code v2.1.246 以降が必要です。

チームメイトのターミナル設定に関する質問に対する `agent_needs_input` には Claude Code v2.1.248 以降が必要です。

<Note>
  `permission_prompt`、`idle_prompt`、`elicitation_dialog`、`elicitation_url_dialog` の種類はデスクトップ通知とタイミングを共有しているため、ターミナルセッションでは、ユーザーがターミナルから離れているとみなされる場合にのみ発生します。

  * `permission_prompt` は、ユーザーが約 6 秒間入力していない時点で発生します。タイマーは権限プロンプトが表示されたときに開始し、キー入力のたびに延期されます。Claude がツールの使用権限を求めたときにすぐにフックを実行するには、代わりに [PermissionRequest](#permissionrequest) を使用してください。
  * `idle_prompt` は、Claude が応答を終えてから約 60 秒後に発生します。ただし、それ以降ユーザーが入力しておらず、バックグラウンドの[サブエージェント](/docs/ja/sub-agents)などのバックグラウンドエージェントが実行中でない場合に限ります。claude.ai の使用制限のリセットを待っている間、Claude Code は `idle_prompt` を送信しません。待機が自然に終了すると、代わりに `quota_auto_resume_*` の種類のいずれかが発火します。
  * `elicitation_dialog`（elicitation フォームの場合）または `elicitation_url_dialog`（ブラウザー URL のリクエストの場合）は、ユーザーが約 6 秒間入力していない時点で発生します。どちらも `permission_prompt` と同じ 6 秒の待機条件を共有しており、タイマーはダイアログが表示されたときに開始し、キー入力のたびに延期されます。

  別のダイアログが画面に表示されている間に届いた権限リクエストや elicitation にも、同じ 6 秒の待機条件が適用され、リクエストが届いた時点から計測されます。そのため、リクエストが開いているダイアログの後ろでまだ待機している間に通知が届くことがあります。
</Note>

Claude Code が権限リクエストを Agent SDK の [`canUseTool` コールバック](/docs/ja/agent-sdk/user-input)に送信するセッションでは、`permission_prompt` のタイミングが異なります。Claude Desktop と VS Code 拡張機能は、この方法で Claude Code をホストしています。

* `permission_prompt` は、Claude が権限を求めてから約 6 秒後に発生します。入力中でも Claude Code は延期しません。
* それより早くユーザーまたは [PermissionRequest](#permissionrequest) フックが応答した場合、Claude Code は `permission_prompt` を実行しません。
* これらのセッションで `permission_prompt` をオフにするには、[`CLAUDE_CODE_DISABLE_PERMISSION_PROMPT_NOTIFY_HOOKS`](/docs/ja/env-vars) を `1` に設定します。

v2.1.233 より前は、これらのセッションで `permission_prompt` は発火しませんでした。

通知の種類に応じて異なるハンドラーを実行するには、個別の matcher を使用します。次の設定では、Claude が権限の承認を必要とするときに権限専用のアラートスクリプトを、Claude がアイドル状態になったときに別の通知を実行します。

```json theme={null}
{
  "hooks": {
    "Notification": [
      {
        "matcher": "permission_prompt",
        "hooks": [
          {
            "type": "command",
            "command": "/path/to/permission-alert.sh"
          }
        ]
      },
      {
        "matcher": "idle_prompt",
        "hooks": [
          {
            "type": "command",
            "command": "/path/to/idle-notification.sh"
          }
        ]
      }
    ]
  }
}
```

<h4 id="notification-input">
  Notification の入力
</h4>

[共通入力フィールド](#common-input-fields)に加えて、Notification フックは、通知テキストを含む `message`、省略可能な `title`、どの種類が発火したかを示す `notification_type` を受け取ります。

```json theme={null}
{
  "session_id": "abc123",
  "transcript_path": "/Users/.../.claude/projects/.../00893aaf-19fa-41d2-8238-13269b9b3ca0.jsonl",
  "cwd": "/Users/...",
  "hook_event_name": "Notification",
  "message": "Claude needs your permission",
  "title": "Permission needed",
  "notification_type": "permission_prompt"
}
```

Notification フックは通知をブロックしたり変更したりすることはできません。Claude Code はその `systemMessage` と `continue` フィールドを破棄しますが、[`terminalSequence`](#emit-terminal-notifications) は引き続き出力します。デスクトップ通知の例はこれを利用しています。Notification フックは、通知を外部サービスに転送するといった副作用を目的としています。

<h3 id="subagentstart">
  SubagentStart
</h3>

Claude が Agent ツールでサブエージェントを生成したとき、Claude が[サブエージェントを再開](/docs/ja/sub-agents#resume-subagents)したとき、およびインプロセスの[エージェントチーム](/docs/ja/agent-teams)のチームメイトが新しいメッセージを処理するたびに実行されます。エージェントタイプ名でフィルタリングする matcher をサポートしています。組み込みエージェントの場合、これは `general-purpose`、`Explore`、`Plan` のようなエージェント名です。[カスタムサブエージェント](/docs/ja/sub-agents)の場合、これはファイル名ではなく、エージェントのフロントマターの `name` フィールドです。

[プラグイン](/docs/ja/plugins/overview)で提供されるサブエージェントの場合、エージェントタイプは、フロントマターの名前そのものではなく、`my-plugin:reviewer` のようなプラグインスコープの識別子になります。コロンが含まれるとプラグインスコープの名前は正規表現として扱われるため、完全一致させるには matcher を `^` と `$` で固定します: `^my-plugin:reviewer$`。

<h4 id="subagentstart-input">
  SubagentStart の入力
</h4>

[共通入力フィールド](#common-input-fields)に加えて、SubagentStart フックは、サブエージェントの一意の識別子を含む `agent_id` と、matcher がフィルタリングに使うエージェント名を含む `agent_type` を受け取ります。

```json theme={null}
{
  "session_id": "abc123",
  "transcript_path": "/Users/.../.claude/projects/.../00893aaf-19fa-41d2-8238-13269b9b3ca0.jsonl",
  "cwd": "/Users/...",
  "hook_event_name": "SubagentStart",
  "agent_id": "agent-abc123",
  "agent_type": "Explore"
}
```

SubagentStart フックはサブエージェントの作成をブロックすることはできませんが、サブエージェントにコンテキストを注入することはできます。すべてのフックで利用できる [JSON 出力フィールド](#json-output)に加えて、次のフィールドを返すことができます。

| フィールド | 説明 |
| :- | :- |
| `additionalContext` | 会話の開始時、最初のプロンプトの前にサブエージェントのコンテキストに追加される文字列。[Claude にコンテキストを追加する](#add-context-for-claude)を参照してください |

```json theme={null}
{
  "hookSpecificOutput": {
    "hookEventName": "SubagentStart",
    "additionalContext": "Follow security guidelines for this task"
  }
}
```

同じサブエージェントに対してフックが再度実行された場合、Claude Code は、サブエージェントのコンテキストに以前の実行で注入したコピーがまだ残っていない場合にのみ、返されたコンテキストを注入します。起動時に注入されたコピーはそのまま残るため、サブエージェントの[プロンプトキャッシュ](/docs/ja/prompt-caching#subagents-and-the-cache)は損なわれません。[自動圧縮](/docs/ja/sub-agents#auto-compaction)によってそのコピーが破棄された後は、Claude Code は次の実行のコンテキストを再び注入します。

<h3 id="subagentstop">
  SubagentStop
</h3>

Claude Code のサブエージェントが応答を終えたときに実行されます。エージェントタイプでマッチします。値は SubagentStart と同じです。

<h4 id="subagentstop-input">
  SubagentStop の入力
</h4>

[共通入力フィールド](#common-input-fields)に加えて、SubagentStop フックは `stop_hook_active`、`agent_id`、`agent_type`、`agent_transcript_path`、`last_assistant_message` を受け取ります。`agent_type` フィールドは matcher のフィルタリングに使用される値です。`transcript_path` はメインセッションのトランスクリプトで、`agent_transcript_path` はネストされた `subagents/` フォルダーに保存されるサブエージェント自身のトランスクリプトです。`last_assistant_message` フィールドにはサブエージェントの最終応答のテキスト内容が含まれるため、フックはトランスクリプトファイルを解析せずにそれを参照できます。

すべての SubagentStop イベントが、Claude が生成したサブエージェントから来るわけではありません。Claude Code は、[プロンプトの提案](/docs/ja/interactive-mode#prompt-suggestions)や [`/btw` のサイドクエスチョン](/docs/ja/interactive-mode#side-questions-with-%2Fbtw)など、自身の一部の機能のために内部エージェントも実行しており、それらが終了したときにも SubagentStop が発火します。これらのイベントでは、`agent_type` は、[`--agent`](/docs/ja/cli-reference#cli-flags) や [`agent` 設定](/docs/ja/settings-reference#agent)で設定されたものなど、セッション自体が実行されているエージェント名になり、セッションがエージェントなしで実行されている場合は空文字列になります。

エージェントタイプを指定する `matcher` は、空の `agent_type` にはマッチしません。matcher が省略されているか、`""` または `"*"` であるか、空文字列にマッチする正規表現であるフックは、空の `agent_type` のイベントでも実行されます。

Claude Code v2.1.271 以降では、[`SubagentHandback`](/docs/ja/tools-reference) ツールを使って実行されるサブエージェントは、停止する前にそのツールを通じてレポートを渡します。その場合、`last_assistant_message` フィールドにはサブエージェントの締めくくりのテキスト（ある場合）が入り、渡されたレポートは含まれません。レポートはその呼び出しの `message` 入力であり、`SubagentHandback` にマッチする `PreToolUse` または `PostToolUse` フックは、それを `tool_input.message` として受け取ります。

SubagentStop フックは、[Stop の入力](#stop-input)で説明している `background_tasks` と `session_crons` の配列も受け取ります。どちらの配列も、サブエージェントではなく親セッションを対象としています。

```json theme={null}
{
  "session_id": "abc123",
  "transcript_path": "~/.claude/projects/.../abc123.jsonl",
  "cwd": "/Users/...",
  "permission_mode": "default",
  "hook_event_name": "SubagentStop",
  "stop_hook_active": false,
  "agent_id": "def456",
  "agent_type": "Explore",
  "agent_transcript_path": "~/.claude/projects/.../abc123/subagents/agent-def456.jsonl",
  "last_assistant_message": "Analysis complete. Found 3 potential issues...",
  "background_tasks": [],
  "session_crons": []
}
```

SubagentStop フックは [Stop フック](#stop-decision-control)と同じ判定制御形式を使用します。これには、サブエージェントを実行し続けるエラー以外のフィードバックのために、`hookEventName` を `"SubagentStop"` に設定した `hookSpecificOutput.additionalContext` も含まれます。`reason` とともに `decision: "block"` を返すと、サブエージェントは実行を続け、`reason` が次の指示としてサブエージェントに渡されます。終了コード 2 でブロックするフックも、同じ方法で stderr のメッセージを渡します。サブエージェントが戻った後に親セッションにコンテキストを注入するには、代わりに `Agent` ツールに対する [`PostToolUse`](#posttooluse) フックを使用してください。

<h3 id="taskcreated">
  TaskCreated
</h3>

`TaskCreate` ツールでタスクが作成されるときに実行されます。命名規則を強制したり、タスクの説明を必須にしたり、特定のタスクの作成を阻止したりするために使用します。[Task ツールがないセッション](/docs/ja/tools-reference#task-tool-availability)では、このイベントは発火しません。

TaskCreated フックは matcher をサポートしておらず、発生するたびに発火します。

<h4 id="taskcreated-input">
  TaskCreated の入力
</h4>

[共通入力フィールド](#common-input-fields)に加えて、TaskCreated フックは `task_id`、`task_subject`、および省略可能な `task_description`、`teammate_name`、`team_name` を受け取ります。

```json theme={null}
{
  "session_id": "abc123",
  "transcript_path": "/Users/.../.claude/projects/.../00893aaf-19fa-41d2-8238-13269b9b3ca0.jsonl",
  "cwd": "/Users/...",
  "hook_event_name": "TaskCreated",
  "task_id": "task-001",
  "task_subject": "Implement user authentication",
  "task_description": "Add login and signup endpoints",
  "teammate_name": "implementer",
  "team_name": "session-a1b2c3d4"
}
```

| フィールド | 説明 |
| :- | :- |
| `task_id` | 作成されるタスクの識別子 |
| `task_subject` | タスクのタイトル |
| `task_description` | タスクの詳細な説明。存在しない場合があります |
| `teammate_name` | タスクを作成するチームメイトの名前。存在しない場合があります |
| `team_name` | 非推奨。セッションから導出されたチーム名。今後のリリースで削除されます |

<h4 id="taskcreated-decision-control">
  TaskCreated の判定制御
</h4>

TaskCreated フックは、2 つの方法で作成をブロックできます。いずれの場合も、Claude Code はタスクを削除し、メッセージをツールのエラーとして Claude に返します。このイベントからの `continue: false` は Claude Code によって無視され、Claude は作業を続けます。

* **終了コード 2**: Claude Code は stderr のテキストをメッセージとして返します。
* **JSON `{"decision": "block", "reason": "..."}`**: Claude Code は `reason` をメッセージとして返します。

次の例は、件名が必要な形式に従っていないタスクをブロックします。

```bash theme={null}
#!/bin/bash
INPUT=$(cat)
TASK_SUBJECT=$(echo "$INPUT" | jq -r '.task_subject')

if [[ ! "$TASK_SUBJECT" =~ ^\[TICKET-[0-9]+\] ]]; then
  echo "Task subject must start with a ticket number, e.g. '[TICKET-123] Add feature'" >&2
  exit 2
fi

exit 0
```

<h3 id="taskcompleted">
  TaskCompleted
</h3>

タスクが完了としてマークされるときに実行されます。これは 2 つの状況で発火します。いずれかのエージェントが TaskUpdate ツールを通じてタスクを明示的に完了としてマークした場合と、[エージェントチーム](/docs/ja/agent-teams)のチームメイトが進行中のタスクを抱えたままターンを終えた場合です。タスクを閉じる前に、テストや lint チェックの合格などの完了基準を強制するために使用します。

TaskCompleted フックは matcher をサポートしておらず、発生するたびに発火します。

<h4 id="taskcompleted-input">
  TaskCompleted の入力
</h4>

[共通入力フィールド](#common-input-fields)に加えて、TaskCompleted フックは `task_id`、`task_subject`、および省略可能な `task_description`、`teammate_name`、`team_name` を受け取ります。

```json theme={null}
{
  "session_id": "abc123",
  "transcript_path": "/Users/.../.claude/projects/.../00893aaf-19fa-41d2-8238-13269b9b3ca0.jsonl",
  "cwd": "/Users/...",
  "permission_mode": "default",
  "hook_event_name": "TaskCompleted",
  "task_id": "task-001",
  "task_subject": "Implement user authentication",
  "task_description": "Add login and signup endpoints",
  "teammate_name": "implementer",
  "team_name": "session-a1b2c3d4"
}
```

| フィールド | 説明 |
| :- | :- |
| `task_id` | 完了するタスクの識別子 |
| `task_subject` | タスクのタイトル |
| `task_description` | タスクの詳細な説明。存在しない場合があります |
| `teammate_name` | タスクを完了するチームメイトの名前。存在しない場合があります |
| `team_name` | 非推奨。セッションから導出されたチーム名。今後のリリースで削除されます |

<h4 id="taskcompleted-decision-control">
  TaskCompleted の判定制御
</h4>

TaskCompleted フックは、タスクの完了を制御する 2 つの方法をサポートしています。

* **終了コード 2**: タスクは完了としてマークされず、stderr のメッセージがフィードバックとしてモデルに返されます。
* **JSON `{"continue": false, "stopReason": "..."}`**: チームメイトがターンを終えたことでイベントがトリガーされた場合、`Stop` フックの動作と同様にチームメイトを完全に停止します。`stopReason` はユーザーに表示されます。`TaskUpdate` ツールによってイベントがトリガーされた場合、Claude Code は `continue: false` を無視します。その場合でも終了コード 2 は完了をブロックします。

次の例はテストを実行し、失敗した場合はタスクの完了をブロックします。

```bash theme={null}
#!/bin/bash
INPUT=$(cat)
TASK_SUBJECT=$(echo "$INPUT" | jq -r '.task_subject')

# Run the test suite
if ! npm test 2>&1; then
  echo "Tests not passing. Fix failing tests before completing: $TASK_SUBJECT" >&2
  exit 2
fi

exit 0
```

<h3 id="stop">
  Stop
</h3>

メインの Claude Code エージェントが応答を終えたときに実行されます。ユーザーによる中断で停止した場合は実行されません。API エラーの場合は、代わりに [StopFailure](#stopfailure) が発火します。

<Tip>
  [`/goal`](/docs/ja/goal) コマンドは、セッションスコープのプロンプトベースの Stop フックの組み込みショートカットです。フック設定を書かずに、ある条件に向けて Claude に作業を続けさせたい場合に使用します。
</Tip>

<h4 id="stop-input">
  Stop の入力
</h4>

[共通入力フィールド](#common-input-fields)に加えて、Stop フックは `stop_hook_active`、`last_assistant_message`、`background_tasks`、`session_crons` を受け取ります。`stop_hook_active` フィールドは、Claude Code が Stop フックの結果としてすでに続行している場合に `true` になります。解決しない条件でブロックし続けることがないよう、この値を確認するか、トランスクリプトを処理してください。Claude Code は連続 8 回の続行上限を適用します。Stop フックがターンを 8 回連続で続行させると、Claude Code は次のブロックを上書きしてターンを終了します。上限を引き上げるには、[`CLAUDE_CODE_STOP_HOOK_BLOCK_CAP`](/docs/ja/env-vars) を設定します。

`last_assistant_message` フィールドには Claude の最終応答のテキスト内容が含まれるため、フックはトランスクリプトファイルを解析せずにそれを参照できます。読み上げや通知のフックなど、完了したばかりのターンに対して動作するフックでは、`transcript_path` を読み取るのではなくこのフィールドを使用してください。すべてのバージョンで、Stop の時点でトランスクリプトファイルに最終メッセージが含まれているとは限りません。

`background_tasks` と `session_crons` の配列により、フックは「セッションが完了した」状態と「セッションが一時停止し、バックグラウンドの作業によって再び起こされるのを待っている」状態を区別できます。どちらの配列も、タスクレジストリにアクセスできる場合に存在し、進行中またはスケジュール済みのものがない場合は空になります。

`background_tasks` の各エントリは進行中のタスク 1 つを表し、次のフィールドを使用します。

| フィールド | 説明 |
| :- | :- |
| `id` | タスクの識別子 |
| `type` | `shell`、`subagent`、`monitor`、`workflow`、`teammate`、`cloud session`、`MCP task` など、わかりやすいタスクタイプのラベル。各ラベルは、タスクを作成した Claude Code の機能を示します。認識されないタイプの場合は、生の判別値が使われます |
| `status` | 現在のタスクの状態 |
| `description` | 自由形式の説明。上限は 1000 文字で、切り詰められた場合は文字列内に `… [+N chars]` マーカーが付きます |
| `command` | シェルのコマンドライン。上限は 1000 文字です。`shell` タスクにのみ存在します |
| `agent_type` | サブエージェントのタイプ名。`subagent` タスクにのみ存在します |
| `server` | MCP サーバー名。`monitor` と `MCP task` タスクにのみ存在します |
| `tool` | MCP ツール名。`monitor` と `MCP task` タスクにのみ存在します |
| `name` | ワークフロー名。`workflow` タスクにのみ存在します |

`session_crons` の各エントリは、`CronCreate`、`ScheduleWakeup`、`/loop` から作成された、セッションスコープのスケジュール済みウェイクアップ 1 つを表します。

| フィールド | 説明 |
| :- | :- |
| `id` | cron タスクの識別子 |
| `schedule` | cron 式。例: `0 9 * * 1-5` |
| `recurring` | スケジュールが単一の発火時刻を表す 1 回限りのウェイクアップの場合は `false`、マッチするたびに再発火するタスクの場合は `true` |
| `prompt` | cron の発火時に送信されるプロンプト。上限は 1000 文字で、同じ `… [+N chars]` マーカーが付きます |

次の例は、進行中の shell タスク 1 つと繰り返しの cron 1 つを含む Stop の入力を示しています。

```json theme={null}
{
  "session_id": "abc123",
  "transcript_path": "~/.claude/projects/.../00893aaf-19fa-41d2-8238-13269b9b3ca0.jsonl",
  "cwd": "/Users/...",
  "permission_mode": "default",
  "hook_event_name": "Stop",
  "stop_hook_active": true,
  "last_assistant_message": "I've completed the refactoring. Here's a summary...",
  "background_tasks": [
    {
      "id": "task-001",
      "type": "shell",
      "status": "running",
      "description": "tail logs",
      "command": "tail -f /var/log/syslog"
    }
  ],
  "session_crons": [
    {
      "id": "cron-001",
      "schedule": "0 9 * * 1-5",
      "recurring": true,
      "prompt": "check the build"
    }
  ]
}
```

<h4 id="stop-decision-control">
  Stop の判定制御
</h4>

`Stop` と `SubagentStop` フックは、Claude が続行するかどうかを制御できます。すべてのフックで利用できる [JSON 出力フィールド](#json-output)に加えて、フックスクリプトは次のイベント固有フィールドを返すことができます。

| フィールド | 説明 |
| :- | :- |
| `decision` | `"block"` を指定すると Claude の停止を阻止します。Claude の停止を許可するには省略します |
| `reason` | `decision` が `"block"` の場合は必須です。Claude に続行すべき理由を伝えます |
| `hookSpecificOutput.additionalContext` | Claude へのエラー以外のフィードバック。Claude がそれに基づいて行動できるよう会話は続行しますが、`decision: "block"` とは異なり、トランスクリプトにはフックエラーではなくフックのフィードバックとして表示されます |

終了コード 2 でブロックするフックは、`reason` と同じように扱われます。Claude は続行すべき理由の説明として stderr のメッセージを受け取ります。

```json theme={null}
{
  "decision": "block",
  "reason": "Must be provided when Claude is blocked from stopping"
}
```

フックが設計どおりに動作しており、「終了する前にテストスイートを実行してください」のようなガイダンスを Claude に与えている場合は、`additionalContext` を使用します。これは `decision: "block"` と同じループ保護、つまり `stop_hook_active` 入力と連続 8 回の続行上限を通じて会話を続行させますが、トランスクリプトでは `Stop hook feedback` というラベルが付き、フックエラーの通知は表示されません。

```json theme={null}
{
  "hookSpecificOutput": {
    "hookEventName": "Stop",
    "additionalContext": "Please run the test suite before finishing"
  }
}
```

<h3 id="stopfailure">
  StopFailure
</h3>

API エラーによってターンが終了した場合に、[Stop](#stop) の代わりに実行されます。Claude Code は、[`terminalSequence`](#emit-terminal-notifications) を除き、フックの出力と終了コードを無視します。レート制限、認証の問題、その他の API エラーのために Claude が応答を完了できない場合に、失敗のログ記録、アラートの送信、または回復アクションの実行に使用します。

<h4 id="stopfailure-input">
  StopFailure の入力
</h4>

[共通入力フィールド](#common-input-fields)に加えて、StopFailure フックは `error`、省略可能な `error_details`、省略可能な `last_assistant_message` を受け取ります。`error` フィールドはエラーの種類を示し、matcher のフィルタリングに使用されます。

| フィールド | 説明 |
| :- | :- |
| `error` | エラーの種類: `rate_limit`、`overloaded`、`authentication_failed`、`oauth_org_not_allowed`、`account_on_hold`、`billing_error`、`invalid_request`、`model_not_found`、`server_error`、`max_output_tokens`、`cloud_credential_error`、または `unknown` |
| `error_details` | エラーに関する追加の詳細（利用可能な場合） |
| `last_assistant_message` | 会話に表示されるレンダリング済みのエラーテキスト。このフィールドに Claude の会話出力が入る `Stop` や `SubagentStop` とは異なり、`StopFailure` では `"API Error: Rate limit reached"` のような API エラー文字列そのものが入ります |

```json theme={null}
{
  "session_id": "abc123",
  "transcript_path": "/Users/.../.claude/projects/.../00893aaf-19fa-41d2-8238-13269b9b3ca0.jsonl",
  "cwd": "/Users/...",
  "hook_event_name": "StopFailure",
  "error": "rate_limit",
  "error_details": "429 Too Many Requests",
  "last_assistant_message": "API Error: Rate limit reached"
}
```

StopFailure フックには判定制御がありません。通知とログ記録の目的でのみ実行されます。

<h3 id="teammateidle">
  TeammateIdle
</h3>

[エージェントチーム](/docs/ja/agent-teams)のチームメイトがターンを終えてアイドル状態になろうとしているときに実行されます。lint チェックの合格を必須にしたり、出力ファイルの存在を確認したりするなど、チームメイトが作業を停止する前に品質ゲートを強制するために使用します。

TeammateIdle フックは matcher をサポートしておらず、発生するたびに発火します。

<h4 id="teammateidle-input">
  TeammateIdle の入力
</h4>

[共通入力フィールド](#common-input-fields)に加えて、TeammateIdle フックは `teammate_name` と `team_name` を受け取ります。

```json theme={null}
{
  "session_id": "abc123",
  "transcript_path": "/Users/.../.claude/projects/.../00893aaf-19fa-41d2-8238-13269b9b3ca0.jsonl",
  "cwd": "/Users/...",
  "permission_mode": "default",
  "hook_event_name": "TeammateIdle",
  "teammate_name": "researcher",
  "team_name": "session-a1b2c3d4"
}
```

| フィールド | 説明 |
| :- | :- |
| `teammate_name` | アイドル状態になろうとしているチームメイトの名前 |
| `team_name` | 非推奨。セッションから導出されたチーム名。今後のリリースで削除されます |

<h4 id="teammateidle-decision-control">
  TeammateIdle の判定制御
</h4>

TeammateIdle フックは、チームメイトの動作を制御する 2 つの方法をサポートしています。

* **終了コード 2**: チームメイトは stderr のメッセージをフィードバックとして受け取り、アイドル状態にならずに作業を続けます。
* **JSON `{"continue": false, "stopReason": "..."}`**: `Stop` フックの動作と同様に、チームメイトを完全に停止します。`stopReason` はユーザーに表示されます。

次の例は、チームメイトがアイドル状態になるのを許可する前に、ビルドアーティファクトが存在することを確認します。

```bash theme={null}
#!/bin/bash

if [ ! -f "./dist/output.js" ]; then
  echo "Build artifact missing. Run the build before stopping." >&2
  exit 2
fi

exit 0
```

<h3 id="configchange">
  ConfigChange
</h3>

セッション中に設定ファイルが変更されたときに実行されます。設定変更の監査、セキュリティポリシーの強制、または設定ファイルへの不正な変更のブロックに使用します。

Claude Code は、設定ファイル、管理ポリシーファイル、またはスキルファイルが変更されたときに ConfigChange フックを実行します。管理ポリシーについては、`managed-settings.json` または `managed-settings.d/` 内のファイルが変更された場合にのみ実行します。[サーバー管理設定](/docs/ja/server-managed-settings)や、macOS の管理された環境設定、Windows レジストリのポリシーへの変更は、フックを実行せずに適用します。[`wslInheritsWindowsSettings`](/docs/ja/settings-reference#wslinheritswindowssettings) を使用している WSL では、Windows 側の管理設定ファイルの変更も、ポリシーのポーリング時にフックを実行せずに適用します。

matcher は設定のソースでフィルタリングします。

| Matcher | 発火するタイミング |
| :- | :- |
| `user_settings` | `~/.claude/settings.json` が変更された |
| `project_settings` | `.claude/settings.json` が変更された |
| `local_settings` | `.claude/settings.local.json` が変更された |
| `policy_settings` | `managed-settings.json` または `managed-settings.d/` 内のファイルが変更された |
| `skills` | `.claude/skills/` 内のスキルファイルが変更された |

次の例は、セキュリティ監査のためにすべての設定変更をログに記録します。

```json theme={null}
{
  "hooks": {
    "ConfigChange": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "${CLAUDE_PROJECT_DIR}/.claude/hooks/audit-config-change.sh",
            "args": []
          }
        ]
      }
    ]
  }
}
```

<h4 id="configchange-input">
  ConfigChange の入力
</h4>

[共通入力フィールド](#common-input-fields)に加えて、ConfigChange フックは `source` と、省略可能な `file_path` を受け取ります。`source` フィールドはどの種類の設定が変更されたかを示し、`file_path` は変更された特定のファイルのパスを示します。

```json theme={null}
{
  "session_id": "abc123",
  "transcript_path": "/Users/.../.claude/projects/.../00893aaf-19fa-41d2-8238-13269b9b3ca0.jsonl",
  "cwd": "/Users/...",
  "hook_event_name": "ConfigChange",
  "source": "project_settings",
  "file_path": "/Users/.../my-project/.claude/settings.json"
}
```

<h4 id="configchange-decision-control">
  ConfigChange の判定制御
</h4>

ConfigChange フックは、設定変更が反映されるのをブロックできます。変更を阻止するには、終了コード 2 または JSON の `decision` を使用します。ブロックされた場合、新しい設定は実行中のセッションに適用されません。

| フィールド | 説明 |
| :- | :- |
| `decision` | `"block"` を指定すると、設定変更が適用されるのを阻止します。変更を許可するには省略します |
| `reason` | 受け付けられますが、表示されることはありません |

```json theme={null}
{
  "decision": "block",
  "reason": "Configuration changes to project settings require admin approval"
}
```

`policy_settings` の変更はブロックできません。マシン上の管理設定ファイルが変更されたときには `policy_settings` ソースに対してもフックが発火するため、それらの編集をログに記録するのには使用できますが、ブロックの判定はすべて無視されます。これにより、エンタープライズで管理される設定が常に反映されることが保証されます。[サーバー管理設定](/docs/ja/server-managed-settings)が届いたときや更新されたときには、Claude Code は `ConfigChange` フックを実行しません。

Claude Code は ConfigChange フックの JSON 出力のうちブロックの判定に従い、`systemMessage` と `continue` は破棄します。ブロックされた変更については、`reason` でブロックした場合も終了コード 2 の stderr でブロックした場合も、ユーザーにも Claude にもメッセージは表示されません。Claude Code はデバッグログに 1 行書き込むだけです。

<h3 id="cwdchanged">
  CwdChanged
</h3>

メインの会話内のシェルコマンドが作業ディレクトリを変更したとき、たとえば Claude が `cd` コマンドを実行したときに実行されます。ディレクトリの変更に反応して、環境変数の再読み込み、プロジェクト固有のツールチェーンの有効化、セットアップスクリプトの自動実行などを行うために使用します。ディレクトリごとの環境を管理する [direnv](https://direnv.net/) のようなツールでは、[FileChanged](#filechanged) と組み合わせて使用します。

CwdChanged フックは [`CLAUDE_ENV_FILE`](#persist-environment-variables) にアクセスできます。そのファイルに書き込まれた変数は、次の CwdChanged イベントで Claude Code によってクリアされるまで、後続の Bash コマンドに引き継がれます。

CwdChanged は matcher をサポートしておらず、発生するたびに発火します。

<h4 id="cwdchanged-input">
  CwdChanged の入力
</h4>

[共通入力フィールド](#common-input-fields)に加えて、CwdChanged フックは `old_cwd` と `new_cwd` を受け取ります。

```json theme={null}
{
  "session_id": "abc123",
  "transcript_path": "/Users/.../.claude/projects/.../transcript.jsonl",
  "cwd": "/Users/my-project/src",
  "hook_event_name": "CwdChanged",
  "old_cwd": "/Users/my-project",
  "new_cwd": "/Users/my-project/src"
}
```

<h4 id="cwdchanged-output">
  CwdChanged の出力
</h4>

すべてのフックで利用できる [JSON 出力フィールド](#json-output)に加えて、CwdChanged フックは `watchPaths` を返して、[FileChanged](#filechanged) が監視するファイルパスを動的に設定できます。

| フィールド | 説明 |
| :- | :- |
| `watchPaths` | 絶対パスの配列。現在の動的な監視リストを置き換えます。`matcher` 設定のパスは常に監視されます。空の配列を返すと動的リストがクリアされます。これは新しいディレクトリに入るときの典型的な使い方です |

CwdChanged フックには判定制御がありません。ディレクトリの変更をブロックすることはできません。

Claude Code は JSON 出力から `watchPaths` と `systemMessage` を読み取り、`continue` を破棄します。対話型セッションでは、`systemMessage` を短いターミナル通知として表示します。このメッセージは SDK のメッセージストリームには届きません。

<h3 id="directoryadded">
  DirectoryAdded
</h3>

セッションの途中で `/add-dir` コマンドを使って作業ディレクトリを追加した後、または SDK クライアントが `register_repo_root` 制御リクエストで作業ディレクトリを追加した後に実行されます。新たに追加されたリポジトリの準備、たとえば依存関係のインストールに使用します。

Claude Code は次の場合にはこのイベントを発火しません。

* `--add-dir` 起動フラグでディレクトリを渡した場合。これらのディレクトリは [SessionStart](#sessionstart) でカバーされます
* `/permissions` の Workspace タブでディレクトリを追加した場合
* すでに作業ディレクトリであるディレクトリ、またはその内部にあるディレクトリを追加した場合

Claude Code はサンドボックスと権限の状態を更新した後に DirectoryAdded を発火するため、フックが実行される時点で、サンドボックス化されたツールにはすでに新しいディレクトリが見えています。フックコマンド自体はサンドボックス化されずに実行されます。

Claude Code はフックを待ちません。追加はすぐに完了し、フックはデフォルトの 600 秒のタイムアウトでバックグラウンドで実行されます。

matcher は、ディレクトリがどのように追加されたかでフィルタリングします。

| Matcher | 発火するタイミング |
| :- | :- |
| `slash_command` | `/add-dir` でディレクトリを追加した |
| `register_repo_root` | SDK クライアントが `register_repo_root` 制御リクエストでディレクトリを追加した |

<h4 id="directoryadded-input">
  DirectoryAdded の入力
</h4>

[共通入力フィールド](#common-input-fields)に加えて、DirectoryAdded フックは `directory` と `source` を受け取ります。

| フィールド | 説明 |
| :- | :- |
| `directory` | 追加されたディレクトリの絶対パス |
| `source` | ディレクトリの追加方法。`/add-dir` の場合は `"slash_command"`、SDK 制御リクエストの場合は `"register_repo_root"` |

```json theme={null}
{
  "session_id": "abc123",
  "transcript_path": "/Users/.../.claude/projects/.../transcript.jsonl",
  "cwd": "/Users/my-project",
  "hook_event_name": "DirectoryAdded",
  "directory": "/Users/my-other-repo",
  "source": "slash_command"
}
```

DirectoryAdded フックには判定制御がありません。フックが実行される時点で追加はすでに完了しているため、追加をブロックすることはできません。Claude Code は JSON 出力から `continue` フィールドを破棄し、残りをソースごとに異なる方法で表示します。

* `slash_command`: Claude Code はフックの `systemMessage` をユーザーに表示するのではなく、次の会話ターンでコンテキストとして Claude に渡します。失敗したフックの数がトランスクリプトに表示されます。失敗時の出力全体はデバッグログに記録されます
* `register_repo_root`: Claude Code は `systemMessage` の出力と失敗時の出力をデバッグログにのみ書き込みます

<h3 id="filechanged">
  FileChanged
</h3>

監視対象のファイルがディスク上で変更されたときに実行されます。Claude Code はツール呼び出しを調べるのではなく、ファイルシステムウォッチャーで変更を検出するため、何がファイルを変更したかに関係なくフックを実行します。対象となるのは、`Edit` や `Write` のツール呼び出し、Claude が `Bash` で実行するスクリプト、あるいは Claude Code の完全に外部のプロセスです。一般的な用途は、プロジェクトの設定ファイルが変更されたときに環境変数を再読み込みすることです。

このイベントの `matcher` には 2 つの役割があります。

* **監視リストを構築する**: 値は `|` で分割され、各セグメントが作業ディレクトリ内のリテラルなファイル名として登録されます。そのため、`".envrc|.env"` はちょうどその 2 つのファイルを監視します。ここでは正規表現パターンは役に立ちません。`^\.env` のような値は、文字どおり `^\.env` という名前のファイルを監視することになります。
* **実行するフックをフィルタリングする**: 監視対象のファイルが変更されると、同じ値が、変更されたファイルのベース名に対して標準の [matcher ルール](#matcher-patterns)を使い、どのフックグループを実行するかをフィルタリングします。

次の例は、`Bash` コマンドや外部スクリプトによるファイルの書き換えを含め、あらゆる変更の後に `data.csv` の改行コードを正規化します。

```json theme={null}
{
  "hooks": {
    "FileChanged": [
      {
        "matcher": "data.csv",
        "hooks": [
          {
            "type": "command",
            "command": "/path/to/normalize-line-endings.sh"
          }
        ]
      }
    ]
  }
}
```

このフックは、stdin の [JSON 入力](#filechanged-input)の `file_path` フィールドから、変更されたファイルの絶対パスを読み取ります。`grep` によるガードは、`perl` が削除するのと同じもの、つまり行末の CR を検査するため、正規化後の実行ではファイルに触れずに終了します。これより緩いガードだと無限ループになります。`perl -i` は何も置換しなくてもファイルを書き換え、Claude Code は書き換えのたびにフックを再実行するためです。このスクリプトを `/path/to/normalize-line-endings.sh` に保存し、実行可能にしてください。

```bash theme={null}
#!/bin/bash
FILE=$(jq -r .file_path)
if grep -q $'\r$' "$FILE"; then
  perl -pi -e 's/\r$//' "$FILE"
fi
```

フックが機能することを確認するには、`Bash` コマンドで `data.csv` に CRLF の行を追加するよう Claude に依頼します。Claude Code がフックを実行し、ファイルの改行コードは LF になります。

事前に名前を指定できないファイルを監視するには、フックから [`watchPaths`](#filechanged-output) を返して監視リストを動的に更新します。Claude Code は、何かが監視するファイルを指定した場合にのみウォッチャーを起動するため、少なくとも 1 つのファイルを指定する matcher を持つ FileChanged グループか、`watchPaths` を返す [SessionStart](#sessionstart-decision-control) または [CwdChanged](#cwdchanged) フックでリストの初期値を設定してください。監視対象のファイルが変更されたとき、matcher は引き続きどのフックグループを実行するかをフィルタリングするため、動的なパスを処理するグループでは matcher を省略してください。省略した matcher はすべての監視対象ファイルにマッチし、監視リストには何も追加しません。`"*"` の matcher もすべてのファイルにマッチしますが、Claude Code はそれを他の値と同様に、`*` という名前のリテラルなファイルとして監視リストに登録します。

FileChanged フックは [`CLAUDE_ENV_FILE`](#persist-environment-variables) にアクセスできます。そのファイルに書き込まれた変数は、次の [CwdChanged](#cwdchanged) イベントで Claude Code によってクリアされるまで、後続の Bash コマンドに引き継がれます。

<h4 id="filechanged-input">
  FileChanged の入力
</h4>

[共通入力フィールド](#common-input-fields)に加えて、FileChanged フックは `file_path` と `event` を受け取ります。

| フィールド | 説明 |
| :- | :- |
| `file_path` | 変更されたファイルの絶対パス |
| `event` | 発生した内容: 変更されたファイルの場合は `"change"`、作成されたファイルの場合は `"add"`、削除されたファイルの場合は `"unlink"` |

```json theme={null}
{
  "session_id": "abc123",
  "transcript_path": "/Users/.../.claude/projects/.../transcript.jsonl",
  "cwd": "/Users/my-project",
  "hook_event_name": "FileChanged",
  "file_path": "/Users/my-project/.envrc",
  "event": "change"
}
```

<h4 id="filechanged-output">
  FileChanged の出力
</h4>

すべてのフックで利用できる [JSON 出力フィールド](#json-output)に加えて、FileChanged フックは `watchPaths` を返して、監視するファイルパスを動的に更新できます。

| フィールド | 説明 |
| :- | :- |
| `watchPaths` | 絶対パスの配列。現在の動的な監視リストを置き換えます。`matcher` 設定のパスは常に監視されます。変更されたファイルに基づいて、フックスクリプトが監視すべき追加のファイルを見つけた場合に使用します |

FileChanged フックには判定制御がありません。ファイルの変更が発生するのをブロックすることはできません。

Claude Code は JSON 出力から `watchPaths` と `systemMessage` を読み取り、`continue` を破棄します。対話型セッションでは、`systemMessage` を短いターミナル通知として表示します。このメッセージは SDK のメッセージストリームには届きません。

<h3 id="worktreecreate">
  WorktreeCreate
</h3>

worktree が作成されるときに実行されます。対象は、`claude --worktree` から作成される場合、[`isolation: "worktree"` を使用するサブエージェント](/docs/ja/sub-agents#choose-the-subagent-scope)から作成される場合、Claude Code が独自の worktree に分離する[バックグラウンドセッション](/docs/ja/agent-view#how-file-edits-are-isolated)のために作成される場合です。デフォルトでは、Claude Code は `git worktree` を使って分離された作業コピーを作成します。WorktreeCreate フックを設定するとこのデフォルトの Git の動作が置き換えられ、SVN、Perforce、Mercurial などの別のバージョン管理システムを使用できるようになります。

フックはデフォルトの動作を完全に置き換えるため、[`.worktreeinclude`](/docs/ja/worktrees#copy-gitignored-files-into-worktrees) は処理されません。`.env` のようなローカルの設定ファイルを新しい worktree にコピーする必要がある場合は、フックスクリプト内で行ってください。

フックは、作成された worktree ディレクトリのパスを返す必要があります。Claude Code はこのパスを、分離されたセッションの作業ディレクトリとして使用します。各フックタイプがパスを返す方法については、[WorktreeCreate の出力](#worktreecreate-output)を参照してください。

Claude Code はフックの成否と返されたパスに従い、`systemMessage` と `continue` を破棄します。

次の例は、SVN の作業コピーを作成し、Claude Code が使用するパスを出力します。リポジトリの URL は独自のものに置き換えてください。

```json theme={null}
{
  "hooks": {
    "WorktreeCreate": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "bash -c 'NAME=$(jq -r .name); DIR=\"$HOME/.claude/worktrees/$NAME\"; svn checkout https://svn.example.com/repo/trunk \"$DIR\" >&2 && echo \"$DIR\"'"
          }
        ]
      }
    ]
  }
}
```

このフックは、stdin の JSON 入力から worktree の `name` を読み取り、新しいディレクトリに新規コピーをチェックアウトし、そのディレクトリのパスを出力します。最後の行の `echo` が、Claude Code が worktree のパスとして読み取るものです。パスに干渉しないよう、その他の出力はすべて stderr にリダイレクトしてください。

<h4 id="worktreecreate-input">
  WorktreeCreate の入力
</h4>

[共通入力フィールド](#common-input-fields)に加えて、WorktreeCreate フックは `name` フィールドを受け取ります。これは新しい worktree のスラッグ識別子で、ユーザーが指定したものか自動生成されたもの（例: `bold-oak-a3f2`）です。

```json theme={null}
{
  "session_id": "abc123",
  "transcript_path": "/Users/.../.claude/projects/.../00893aaf-19fa-41d2-8238-13269b9b3ca0.jsonl",
  "cwd": "/Users/...",
  "hook_event_name": "WorktreeCreate",
  "name": "feature-auth"
}
```

<h4 id="worktreecreate-output">
  WorktreeCreate の出力
</h4>

WorktreeCreate フックは、標準の許可/ブロックの判定モデルを使用しません。代わりに、フックの成功または失敗によって結果が決まります。フックは作成した worktree ディレクトリのパスを返す必要があります。

* **コマンドフック**（`type: "command"`）: パスを stdout の最後の空でない行として出力します。Claude Code はその行を読み取る前に ANSI エスケープコードを除去するため、`echo` より前に出力されたシェルの起動バナーは無視されます。それ以外のフックの出力はすべて stderr にリダイレクトしてください。
* **HTTP フック**（`type: "http"`）: レスポンス本文で `{ "hookSpecificOutput": { "hookEventName": "WorktreeCreate", "worktreePath": "/absolute/path" } }` を返します。

フックが失敗した場合やパスを出力しなかった場合、worktree の作成はエラーで失敗します。

Claude Code は相対パスをフックが実行されたディレクトリを基準に解決し、その中の `.` や `..` セグメントを畳み込みます。結果のパスが Claude Code の移動できるディレクトリでない場合、セッションはそのパスを示すエラーを出力し、終了コード 1 で終了します。

Claude Code は、`.` や `..` セグメントを含む絶対パスと、リポジトリルート以下のシンボリックリンクを経由するパスを拒否します。リポジトリにコミットされたシンボリックリンクによって worktree がリポジトリ外へリダイレクトされる可能性があるためです。エラーには拒否されたコンポーネントが示されます。正規化され、リポジトリ内のシンボリックリンクを経由しないパスを返してください。v2.1.216 より前は、worktree の作成はこのチェックを行わずにフックのパスに従っていました。

<h3 id="worktreeremove">
  WorktreeRemove
</h3>

worktree が削除されるときに実行されます。これは [WorktreeCreate](#worktreecreate) に対応するクリーンアップ用のイベントです。このイベントは次の場合に発生します。

* `--worktree` セッションを終了し、削除を選択したとき
* `isolation: "worktree"` を指定したサブエージェントが終了したとき
* フックが worktree を作成した[バックグラウンドセッション](/docs/ja/agent-view#what-deleting-a-session-removes)を削除したとき

Git ベースの worktree の場合、Claude Code は `git worktree remove` で自動的にクリーンアップを行います。WorktreeCreate フックを設定した場合は、WorktreeRemove フックと組み合わせて、作成した worktree のクリーンアップを制御してください。

* **WorktreeRemove フックがない場合**: `--worktree` セッションを終了して削除を選択すると、Claude Code は WorktreeCreate フックが返したパスに対して `git worktree remove --force` にフォールバックするため、Git が認識している worktree は削除されます。Git が認識していない worktree（たとえば Git 以外のバージョン管理システムでフックが作成したもの）はディスクに残ります。[バックグラウンドセッション](/docs/ja/agent-view#what-deleting-a-session-removes)の削除がフックで作成された worktree をどう扱うかについては、エージェントビューの削除ルールを参照してください。
* **フックが 0 で終了した場合**: worktree は削除済みとして扱われます。Claude Code はフックからそれ以外に何も読み取らないため、フックがディレクトリを確実に削除するようにしてください。
* **フックが 0 以外で終了した場合**: その後も `worktree_path` のディレクトリが存在していれば削除は失敗し、Git へのフォールバックなしで worktree はディスクに残ります。0 以外で終了する前にディレクトリを削除したフックは、削除済みとして扱われます。失敗の報告方法については、[WorktreeRemove の入力](#worktreeremove-input)を参照してください。

Claude Code は WorktreeCreate フックが返したパスしか把握していないため、フックで作成された worktree に属するブランチを削除することはありません。WorktreeCreate フックでブランチを作成する場合は、WorktreeRemove フックでそのブランチを削除してください。

Claude Code は、`systemMessage` や `continue` など、WorktreeRemove フックの [JSON 出力フィールド](#json-output)を破棄します。

バックグラウンドセッションの削除では、Claude Code はフックを実行する前に保存されている worktree パスを検証し、シンボリックリンクであるパス、またはリポジトリルート以下でシンボリックリンクを経由するパスを拒否します。まだファイルを含む worktree に対しては、[エージェントビュー](/docs/ja/agent-view#what-deleting-a-session-removes)で削除を確認した場合にのみフックが実行されます。そのような worktree の場合、[`claude rm`](/docs/ja/agent-view#manage-sessions-from-the-shell) はセッションと worktree を残します。v2.1.216 より前は、フックはこれらのチェックなしで保存されたパスに対して実行されていました。

Claude Code は、WorktreeCreate が返したパスをフック入力の `worktree_path` として渡します。次の例では、そのパスを読み取ってディレクトリを削除します。

```json theme={null}
{
  "hooks": {
    "WorktreeRemove": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "bash -c 'jq -r .worktree_path | xargs rm -rf'"
          }
        ]
      }
    ]
  }
}
```

<h4 id="worktreeremove-input">
  WorktreeRemove の入力
</h4>

[共通の入力フィールド](#common-input-fields)に加えて、WorktreeRemove フックは `worktree_path` フィールドを受け取ります。これは削除される worktree の絶対パスです。

```json theme={null}
{
  "session_id": "abc123",
  "transcript_path": "/Users/.../.claude/projects/.../00893aaf-19fa-41d2-8238-13269b9b3ca0.jsonl",
  "cwd": "/Users/...",
  "hook_event_name": "WorktreeRemove",
  "worktree_path": "/Users/.../my-project/.claude/worktrees/feature-auth"
}
```

WorktreeRemove フックの終了コードによって結果が決まります。フックが 0 以外で終了し、その後も `worktree_path` のディレクトリが存在している場合、削除は失敗します。

* worktree はディスクに残り、フックのコマンドと stderr は[デバッグログ](#debug-hooks)に記録されます。
* バックグラウンドセッションを削除していた場合、セッションも残ります。[エージェントビュー](/docs/ja/agent-view#what-deleting-a-session-removes)の拒否メッセージには、`exited 1` のようなフックの終了状況、stderr の冒頭部分、およびセッションを再度削除した場合にディレクトリがそれでも削除されるかどうかが表示されます。

<h3 id="precompact">
  PreCompact
</h3>

Claude Code がコンテキスト圧縮を実行する直前に実行されます。

matcher の値は、圧縮が手動でトリガーされたか自動でトリガーされたかを示します。

| Matcher | 発生するタイミング |
| :- | :- |
| `manual` | `/compact` |
| `auto` | 会話が[自動圧縮ウィンドウ](/docs/ja/model-config#set-the-auto-compact-window)に達したときの自動圧縮 |

圧縮をブロックするには、終了コード 2 で終了します。手動の `/compact` の場合、stderr のメッセージがユーザーに表示されます。`"decision": "block"` を含む JSON を返してブロックすることもできます。

自動圧縮をブロックした場合の影響は、発生したタイミングによって異なります。コンテキスト上限に達する前に予防的に圧縮がトリガーされた場合、Claude Code は圧縮をスキップし、会話は圧縮されないまま続行されます。API がすでに返したコンテキスト上限エラーから回復するために圧縮がトリガーされた場合は、元のエラーが表面化し、現在のリクエストは失敗します。

Claude Code は PreCompact フックの `systemMessage` と `continue` フィールドを破棄します。

<h4 id="precompact-input">
  PreCompact の入力
</h4>

[共通の入力フィールド](#common-input-fields)に加えて、PreCompact フックは `trigger` と `custom_instructions` を受け取ります。`manual` の場合、`custom_instructions` にはユーザーが `/compact` に渡した内容が含まれ、何も渡さなかった場合は `null` になります。`auto` の場合、`custom_instructions` は `null` です。

```json theme={null}
{
  "session_id": "abc123",
  "transcript_path": "/Users/.../.claude/projects/.../00893aaf-19fa-41d2-8238-13269b9b3ca0.jsonl",
  "cwd": "/Users/...",
  "hook_event_name": "PreCompact",
  "trigger": "manual",
  "custom_instructions": null
}
```

<h3 id="postcompact">
  PostCompact
</h3>

Claude Code がコンテキスト圧縮を完了した後に実行されます。このイベントを使用すると、圧縮後の新しい状態に対応できます。たとえば、生成された要約をログに記録したり、外部の状態を更新したりできます。Claude Code は PostCompact フックの `systemMessage` と `continue` フィールドを破棄します。

`PreCompact` と同じ matcher の値が適用されます。

| Matcher | 発生するタイミング |
| :- | :- |
| `manual` | `/compact` の後 |
| `auto` | 会話が[自動圧縮ウィンドウ](/docs/ja/model-config#set-the-auto-compact-window)に達したときの自動圧縮の後 |

<h4 id="postcompact-input">
  PostCompact の入力
</h4>

[共通の入力フィールド](#common-input-fields)に加えて、PostCompact フックは `trigger` と `compact_summary` を受け取ります。`compact_summary` フィールドには、圧縮によって生成された会話の要約が含まれます。

```json theme={null}
{
  "session_id": "abc123",
  "transcript_path": "/Users/.../.claude/projects/.../00893aaf-19fa-41d2-8238-13269b9b3ca0.jsonl",
  "cwd": "/Users/...",
  "hook_event_name": "PostCompact",
  "trigger": "manual",
  "compact_summary": "Summary of the compacted conversation..."
}
```

PostCompact フックには判定の制御はありません。圧縮の結果に影響を与えることはできませんが、後続のタスクを実行できます。

<h3 id="premodelswitch">
  PreModelSwitch
</h3>

ユーザーまたはクライアントが要求したモデルの切り替えを Claude Code が適用する前に実行されます。切り替えをブロックしたり、確認を求めたり、切り替えにかかるコストを事前に表示したりするために使用します。

PreModelSwitch には Claude Code v2.1.251 以降が必要です。Claude Code は次のリクエストに対してこのフックを実行します。

* `/model <name>` と `/model` ピッカー
* `Option+P` または `Alt+P` のモデルピッカー
* `/config` の Model 設定
* セッションのモデルが変わる場合の [fast mode](/docs/ja/fast-mode) のオン
* [Agent SDK](/docs/ja/agent-sdk/typescript#query-object) ホストまたは [Remote Control](/docs/ja/remote-control) からの `set_model` リクエスト、または `apply_flag_settings` リクエストでのモデル変更

Claude Code は、[自動モデルフォールバック](/docs/ja/model-config#automatic-model-fallback)やセッション再開時のモデルの復元など、Claude Code 自身が行う切り替えに対しては PreModelSwitch フックを実行しません。これらの変更は [PostModelSwitch](#postmodelswitch) にのみ届きます。

Claude Code は、`[1m]` サフィックスを無視して、切り替え先モデルの正規名と matcher を比較します。`opus` のようなエイリアス、日付付きのモデル ID、Amazon Bedrock のモデル ID のようなプロバイダー固有の ID は、いずれも解決先の 1 つの正規名にマッチするため、`claude-opus-5` は Opus 5 のあらゆる表記をカバーします。

切り替え先の正規名を特定できない場合（たとえば [LLM ゲートウェイ](/docs/ja/llm-gateway)だけが認識するカスタムモデル ID の場合）、Claude Code は matcher に関係なくすべての PreModelSwitch フックを実行します。そのため、ブロックするフックは matcher だけに頼らず、入力の `to_model` を確認する必要があります。

matcher は、完全な名前、`claude-opus-4-6|claude-opus-5` のような `|` 区切りのリスト、または `.*opus.*` のような正規表現で記述します。次の例では、完全名の matcher を使用し、さらにフック入力の `to_model` も確認することで、Opus 4.6 への切り替えを終了コード 2 で拒否し、それ以外の切り替え先は許可します。

<Tabs>
  <Tab title="macOS/Linux">
    コマンドは `jq` で `to_model` を確認します。

    ```json theme={null}
    {
      "hooks": {
        "PreModelSwitch": [
          {
            "matcher": "claude-opus-4-6",
            "hooks": [
              {
                "type": "command",
                "command": "jq -e '.to_model | test(\"opus-4-6\")' > /dev/null && { echo 'Opus 4.6 is retired for this project. Use a newer model.' >&2; exit 2; }; exit 0"
              }
            ]
          }
        ]
      }
    }
    ```
  </Tab>

  <Tab title="Windows (PowerShell)">
    PowerShell でスクリプトを実行するコマンドフックを登録します。

    ```json theme={null}
    {
      "hooks": {
        "PreModelSwitch": [
          {
            "matcher": "claude-opus-4-6",
            "hooks": [
              {
                "type": "command",
                "command": "powershell.exe",
                "args": [
                  "-NoProfile",
                  "-ExecutionPolicy",
                  "Bypass",
                  "-File",
                  "${CLAUDE_PROJECT_DIR}/.claude/hooks/block-opus-46.ps1"
                ]
              }
            ]
          }
        ]
      }
    }
    ```

    次のスクリプトをプロジェクトの `.claude/hooks/block-opus-46.ps1` に保存します。

    ```powershell theme={null}
    $hookInput = [Console]::In.ReadToEnd() | ConvertFrom-Json
    if ($hookInput.to_model -match 'opus-4-6') {
      [Console]::Error.WriteLine('Opus 4.6 is retired for this project. Use a newer model.')
      exit 2
    }
    exit 0
    ```
  </Tab>
</Tabs>

フックが動作することを確認するには、別のモデルを実行しているセッションから `/model claude-opus-4-6` を実行します。Claude Code は現在のモデルを維持し、PreModelSwitch フックが切り替えをブロックしたことを、指定したメッセージを理由として報告します。

<h4 id="premodelswitch-input">
  PreModelSwitch の入力
</h4>

[共通の入力フィールド](#common-input-fields)に加えて、PreModelSwitch フックは次の表のフィールドを受け取ります。最後の 5 つは会話を新しいモデルに再送信するコストを表すため、フックは切り替えの前にその金額を表示できます。

| フィールド | 型 | 説明 |
| :- | :- | :- |
| `from_model` | string | 切り替え元のモデル ID |
| `to_model` | string | 切り替え先のモデル ID。matcher はこのモデルの正規名と比較されます |
| `requested_model` | string または `null` | リクエストで指定されたモデル: `opus` のようなエイリアス、完全なモデル ID、またはデフォルトモデルが要求された場合は `null` |
| `source` | string | リクエストの送信元: `/model <name>`、`/config` の Model 設定、または fast mode のオンの場合は `"command"`、モデルピッカーの場合は `"picker"`、Agent SDK ホストまたは Remote Control からの `set_model` リクエスト、または `apply_flag_settings` リクエストでのモデル変更の場合は `"sdk"` |
| `context_tokens` | number | 次のリクエストがプロンプトとして再送信するトークン数: メイン会話の最後の応答の入力、キャッシュ読み取り、キャッシュ作成、出力トークンの合計。最初の応答の前は `0` |
| `prompt_cache_warm` | boolean | 現在のモデルのプロンプトキャッシュがまだウォームである可能性が高いかどうか。つまり、切り替えによってそれが失われるかどうか |
| `cache_ttl` | string | Claude Code がこのセッションで要求する[プロンプトキャッシュの有効期間](/docs/ja/prompt-caching#cache-lifetime): `"5m"` または `"1h"` |
| `estimated_cache_write_usd` | number | `to_model` 上で `cache_ttl` の料金で `context_tokens` をプロンプトキャッシュに書き込む推定コスト（米ドル）。次の応答は含みません。サーバーがコンテキスト全体を再キャッシュする必要がない場合もあるため、推定値として扱ってください |
| `pricing` | string | Claude Code が `estimated_cache_write_usd` の料金をどのように算出したか: 組織独自の料金が設定されている場合はその料金による `"configured"`、定価による `"catalog"`、または `to_model` の価格が不明で Claude Code がデフォルトの料金を想定した場合は `"default"` |

次の例は、Sonnet 5 を実行しているセッションでの `/model opus` の入力を示しています。

```json theme={null}
{
  "session_id": "abc123",
  "transcript_path": "/Users/.../.claude/projects/.../00893aaf-19fa-41d2-8238-13269b9b3ca0.jsonl",
  "cwd": "/Users/...",
  "hook_event_name": "PreModelSwitch",
  "from_model": "claude-sonnet-5",
  "to_model": "claude-opus-5",
  "requested_model": "opus",
  "source": "command",
  "context_tokens": 182340,
  "prompt_cache_warm": true,
  "cache_ttl": "5m",
  "estimated_cache_write_usd": 1.1396,
  "pricing": "catalog"
}
```

<h4 id="premodelswitch-decision-control">
  PreModelSwitch の判定の制御
</h4>

`PreModelSwitch` フックは、切り替えをキャンセルしたり、ユーザーに確認を求めたり、続行させたりできます。終了コード 2 またはトップレベルの `decision: "block"` で切り替えがキャンセルされます。

より細かく制御するには、[PreToolUse](#pretooluse-decision-control) と同様に、`hookSpecificOutput` オブジェクト内で `permissionDecision` と `permissionDecisionReason` を返します。`PreModelSwitch` は `"allow"`、`"deny"`、`"ask"` を受け付けます。`"defer"`、`updatedInput`、`additionalContext` は受け付けません。次の表で両方のフィールドを説明します。

| フィールド | 説明 |
| :- | :- |
| `permissionDecision` | `"allow"` は続行し、[プロンプトキャッシュがウォームな間に Claude Code が表示する確認](/docs/ja/prompt-caching#switching-models)をスキップします。`"deny"` は切り替えをキャンセルします。`"ask"` はユーザーに確認を求めます |
| `permissionDecisionReason` | `"deny"` の場合、切り替えがブロックされた理由としてユーザーに表示されるか、`set_model` リクエストに対するエラーとして返されます。`"ask"` の場合、確認プロンプトに表示されます。`"allow"` の場合は無視されます |

`"ask"` のプロンプトを表示できるのは、対話セッションでの `/model` だけです。`-p` フラグを使用した非対話モード、`/config`、`set_model` リクエストなど、その他のすべてのサーフェスでは、Claude Code は `"ask"` を拒否として扱います。

次の例では、`context_tokens` のトークン数を示してユーザーに確認を求めます。

```json theme={null}
{
  "hookSpecificOutput": {
    "hookEventName": "PreModelSwitch",
    "permissionDecision": "ask",
    "permissionDecisionReason": "Switching now re-sends about 180k tokens to the new model. Continue?"
  }
}
```

複数の PreModelSwitch フックが異なる判定を返した場合、優先順位は `deny` > `ask` > `allow` です。

Claude Code は判定に関係なく、フックが返した `systemMessage` をユーザーに表示します。そのため、コストを報告するフックは `{"systemMessage": "..."}` を返して 0 で終了できます。

タイムアウトまでに応答しない PreModelSwitch フックは、切り替えをブロックします。これに対して [PreToolUse](#timeouts) では、タイムアウトしたコマンドフックはツール呼び出しを続行させます。このイベントのデフォルトのタイムアウトは 30 秒です。`PreModelSwitch` は `command`、`http`、`mcp_tool` フックのみを実行するため、`prompt` と `agent` のデフォルトは適用されません。

0 と 2 以外のコードで終了し、JSON の判定を出力しないフックはブロックしません。[その他の終了コード](#other-exit-codes)で説明されているように、Claude Code はその stderr を表示して切り替えを適用します。

<h3 id="postmodelswitch">
  PostModelSwitch
</h3>

セッションのモデルが変更された後に実行されます。すべての CLAUDE.md を編集することなく、Claude にモデル固有のガイダンスを与えるために使用します。たとえば、特定のモデルに適用される組織全体の指示などです。

PostModelSwitch には Claude Code v2.1.251 以降が必要です。モデルはすでに変更されているため、ブロックすることはできません。Claude Code は次のいずれかの変更の後に PostModelSwitch フックを実行します。

* ユーザーまたはクライアントが要求した切り替え
* セッションのモデルを変更する[自動モデルフォールバック](/docs/ja/model-config#automatic-model-fallback)
* [`opusplan`](/docs/ja/model-config#opusplan-model-setting) のような設定による plan モードへの移行または plan モードからの離脱
* セッション再開時に Claude Code がモデルを復元したとき

[フォールバックモデルチェーン](/docs/ja/model-config#fallback-model-chains)のモデルがターンを処理する場合、その置き換えは 1 ターンだけでセッションのモデルは変わらないため、Claude Code は PostModelSwitch フックを実行しません。

matcher は [PreModelSwitch](#premodelswitch) と同じルールに従います。Claude Code は、セッションの切り替え先モデルの正規名と matcher を比較します。

次の例では、セッションのモデルがいずれかの Opus モデルに変わるたびにガイダンスを追加します。

```json theme={null}
{
  "hooks": {
    "PostModelSwitch": [
      {
        "matcher": ".*opus.*",
        "hooks": [
          {
            "type": "command",
            "command": "echo 'On Opus, delegate implementation work to subagents and keep this conversation for planning and review.'"
          }
        ]
      }
    ]
  }
}
```

フックが動作することを確認するには、別のモデルを実行しているセッションから Opus モデルに切り替え（たとえば Sonnet のセッションから `/model opus` を実行し）、現在のモデルについてどのようなガイダンスがあるかを Claude に尋ねます。

<h4 id="postmodelswitch-input">
  PostModelSwitch の入力
</h4>

PostModelSwitch フックは [PreModelSwitch](#premodelswitch-input) と同じフィールドを受け取ります。ただし、`hook_event_name` は `"PostModelSwitch"` に設定され、`source` には 2 つの値が追加されます。自動フォールバックなど Claude Code 自身が行った変更を表す `"auto"` と、セッション再開時に復元されたモデルを表す `"resume"` です。

`source` が `"auto"` の場合、`requested_model` は `null` です。`source` が `"resume"` の場合は、Claude Code が復元した保存済みのモデル設定です。

<h4 id="postmodelswitch-decision-control">
  PostModelSwitch の判定の制御
</h4>

Claude Code は、終了コード 0 の場合のフックの[プレーンテキストの stdout](#exit-code-0)、または JSON 出力の `additionalContext` を受け取り、切り替え後の次のリクエストで Claude に渡します。すべてのフックで使用できる [JSON 出力フィールド](#json-output)に加えて、次のフィールドを返すことができます。

| フィールド | 説明 |
| :- | :- |
| `additionalContext` | 次のリクエストで Claude のコンテキストに追加される文字列。[Claude にコンテキストを追加する](#add-context-for-claude)を参照してください |

次のプロンプトを送信してから 5 秒以内にフックが完了しない場合、Claude Code はその出力なしでリクエストを送信し、代わりにその次のリクエストに出力を添付します。次のリクエストまでにモデルが複数回変更された場合、Claude Code は最後の切り替え先モデルの出力のみを渡します。

<h3 id="sessionend">
  SessionEnd
</h3>

Claude Code セッションが終了するときに実行されます。クリーンアップタスク、セッション統計のログ記録、セッション状態の保存に便利です。終了理由でフィルタリングするための matcher をサポートしています。

フック入力の `reason` フィールドは、セッションが終了した理由を示します。

| 理由 | 説明 |
| :- | :- |
| `clear` | `/clear` コマンドでセッションがクリアされた |
| `resume` | 対話的な `/resume` でセッションが切り替えられた |
| `logout` | ユーザーがログアウトした |
| `prompt_input_exit` | プロンプト入力が表示されている間にユーザーが終了した |
| `other` | その他の終了理由 |
| `bypass_permissions_disabled` | v2.1.234 で削除されました。Claude Code はこの値を送信しません。`SessionEnd` の matcher から削除してください |

<h4 id="sessionend-input">
  SessionEnd の入力
</h4>

[共通の入力フィールド](#common-input-fields)に加えて、SessionEnd フックはセッションが終了した理由を示す `reason` フィールドを受け取ります。すべての値については、上記の[理由の表](#sessionend)を参照してください。

```json theme={null}
{
  "session_id": "abc123",
  "transcript_path": "/Users/.../.claude/projects/.../00893aaf-19fa-41d2-8238-13269b9b3ca0.jsonl",
  "cwd": "/Users/...",
  "hook_event_name": "SessionEnd",
  "reason": "other"
}
```

SessionEnd フックには判定の制御はありません。セッションの終了をブロックすることはできませんが、クリーンアップタスクを実行できます。Claude Code は、`systemMessage` などの [JSON 出力フィールド](#json-output)を破棄します。

SessionEnd フックのデフォルトのタイムアウトは 1.5 秒です。これは、終了するとき、`/clear` を実行するとき、または対話的な `/resume` でセッションを切り替えるときに適用されます。フックにより多くの時間を与えるには、次の 2 つの方法があります。

* **フックごとの `timeout`**: そのフックの設定で `timeout` を指定します。全体の制限時間は、設定ファイル内で最も大きいフックごとの `timeout` に合わせて、最大 60 秒まで自動的に引き上げられます。この方法で制限時間を引き上げても、独自の `timeout` を持たないフックはデフォルトのままです。プラグインが提供するフックに設定されたタイムアウトは、制限時間を引き上げません。
* **`CLAUDE_CODE_SESSIONEND_HOOKS_TIMEOUT_MS`**: この環境変数をミリ秒単位で設定すると、制限時間を明示的に上書きできます。設定した値は、独自の `timeout` を持たない各フックのタイムアウトにもなります。

次の例では、制限時間を 5 秒に設定します。

```bash theme={null}
CLAUDE_CODE_SESSIONEND_HOOKS_TIMEOUT_MS=5000 claude
```

v2.1.268 より前は、`CLAUDE_CODE_SESSIONEND_HOOKS_TIMEOUT_MS` は全体の制限時間のみを引き上げ、独自の `timeout` を持たないフックは引き続き 1.5 秒後にキャンセルされていました。

<h3 id="elicitation">
  Elicitation
</h3>

MCP サーバーがタスクの途中でユーザー入力を要求したときに実行されます。デフォルトでは、Claude Code はユーザーが応答するための対話ダイアログを表示します。フックはこのリクエストをインターセプトしてプログラムで応答し、ダイアログを完全にスキップできます。

matcher フィールドは MCP サーバー名と照合されます。

<h4 id="elicitation-input">
  Elicitation の入力
</h4>

[共通の入力フィールド](#common-input-fields)に加えて、Elicitation フックは `mcp_server_name`、`message`、およびオプションの `mode`、`url`、`elicitation_id`、`requested_schema` フィールドを受け取ります。

最も一般的なケースであるフォームモードの elicitation の場合:

```json theme={null}
{
  "session_id": "abc123",
  "transcript_path": "/Users/.../.claude/projects/.../00893aaf-19fa-41d2-8238-13269b9b3ca0.jsonl",
  "cwd": "/Users/...",
  "hook_event_name": "Elicitation",
  "mcp_server_name": "my-mcp-server",
  "message": "Please provide your credentials",
  "mode": "form",
  "requested_schema": {
    "type": "object",
    "properties": {
      "username": { "type": "string", "title": "Username" }
    }
  }
}
```

ブラウザベースの認証に使用される URL モードの elicitation の場合:

```json theme={null}
{
  "session_id": "abc123",
  "transcript_path": "/Users/.../.claude/projects/.../00893aaf-19fa-41d2-8238-13269b9b3ca0.jsonl",
  "cwd": "/Users/...",
  "hook_event_name": "Elicitation",
  "mcp_server_name": "my-mcp-server",
  "message": "Please authenticate",
  "mode": "url",
  "url": "https://auth.example.com/login"
}
```

<h4 id="elicitation-output">
  Elicitation の出力
</h4>

ダイアログを表示せずにプログラムで応答するには、`hookSpecificOutput` を含む JSON オブジェクトを返します。

```json theme={null}
{
  "hookSpecificOutput": {
    "hookEventName": "Elicitation",
    "action": "accept",
    "content": {
      "username": "alice"
    }
  }
}
```

| フィールド | 値 | 説明 |
| :- | :- | :- |
| `action` | `accept`、`decline`、`cancel` | リクエストを承諾、拒否、またはキャンセルするかどうか |
| `content` | object | 送信するフォームフィールドの値。`action` が `accept` の場合にのみ使用されます |

終了コード 2 は elicitation を拒否します。Claude Code は stderr のメッセージをどこにも表示しません。

Claude Code は Elicitation フックの JSON 出力の `hookSpecificOutput` に基づいて動作し、`systemMessage` と `continue` は破棄します。

<h3 id="elicitationresult">
  ElicitationResult
</h3>

ユーザーが MCP の elicitation に応答した後に実行されます。フックは、応答が MCP サーバーに返送される前に、その応答を監視、変更、またはブロックできます。

matcher フィールドは MCP サーバー名と照合されます。

<h4 id="elicitationresult-input">
  ElicitationResult の入力
</h4>

[共通の入力フィールド](#common-input-fields)に加えて、ElicitationResult フックは `mcp_server_name`、`action`、およびオプションの `mode`、`elicitation_id`、`content` フィールドを受け取ります。

```json theme={null}
{
  "session_id": "abc123",
  "transcript_path": "/Users/.../.claude/projects/.../00893aaf-19fa-41d2-8238-13269b9b3ca0.jsonl",
  "cwd": "/Users/...",
  "hook_event_name": "ElicitationResult",
  "mcp_server_name": "my-mcp-server",
  "action": "accept",
  "content": { "username": "alice" },
  "mode": "form",
  "elicitation_id": "elicit-123"
}
```

<h4 id="elicitationresult-output">
  ElicitationResult の出力
</h4>

ユーザーの応答を上書きするには、`hookSpecificOutput` を含む JSON オブジェクトを返します。

```json theme={null}
{
  "hookSpecificOutput": {
    "hookEventName": "ElicitationResult",
    "action": "decline",
    "content": {}
  }
}
```

| フィールド | 値 | 説明 |
| :- | :- | :- |
| `action` | `accept`、`decline`、`cancel` | ユーザーのアクションを上書きします |
| `content` | object | フォームフィールドの値を上書きします。`action` が `accept` の場合にのみ意味を持ちます |

終了コード 2 は応答をブロックし、実際のアクションを `decline` に変更します。Claude Code は stderr のメッセージをどこにも表示しません。

Claude Code は ElicitationResult フックの JSON 出力の `hookSpecificOutput` に基づいて動作し、`systemMessage` と `continue` は破棄します。

<h2 id="prompt-based-hooks">
  プロンプト ベースのフック
</h2>

コマンド、HTTP、MCP ツール フックに加えて、Claude Code はプロンプト ベースのフック（`type: "prompt"`）をサポートしており、LLM を使用してアクションを許可またはブロックするかどうかを評価し、エージェント フック（`type: "agent"`）はツール アクセスを持つ agentic ベリファイアーを生成します。すべてのイベントがすべてのフック タイプをサポートしているわけではありません。

5 つのフック タイプ（`command`、`http`、`mcp_tool`、`prompt`、`agent`）すべてをサポートするイベント：

* `PermissionDenied`
* `PostToolBatch`
* `PostToolUse`
* `PostToolUseFailure`
* `PreToolUse`
* `Stop`
* `SubagentStop`
* `TaskCompleted`
* `TaskCreated`
* `TeammateIdle`
* `UserPromptExpansion`
* `UserPromptSubmit`

`PermissionRequest` は `command`、`http`、`mcp_tool`、`prompt` フックをサポートしますが、`agent` フックはサポートしません。このイベントにエージェント フックを設定した場合、Claude Code はそれをスキップし、権限フローは変更されずに進行します。フックから許可または拒否するには、コマンド フックまたは HTTP フックから[決定オブジェクト](#permissionrequest-decision-control)を返します。

`command`、`http`、`mcp_tool` フックをサポートするが、`prompt` または `agent` をサポートしないイベント：

* `ConfigChange`
* `CwdChanged`
* `DirectoryAdded`
* `Elicitation`
* `ElicitationResult`
* `FileChanged`
* `InstructionsLoaded`
* `MessageDisplay`
* `Notification`
* `PostCompact`
* `PostModelSwitch`
* `PreCompact`
* `PreModelSwitch`
* `SessionEnd`
* `StopFailure`
* `SubagentStart`
* `WorktreeCreate`
* `WorktreeRemove`

`SessionStart` と `Setup` は `command` と `mcp_tool` フックをサポートしており、それらの `mcp_tool` フックがいつ実行されるかについては [MCP ツール フックのフィールド](#mcp-tool-hook-fields)で説明しています。これらは `http`、`prompt`、`agent` フックをサポートしていません。

<h3 id="how-prompt-based-hooks-work">
  プロンプト ベースのフックの仕組み
</h3>

プロンプト ベースのフックは Bash コマンドを実行する代わりに：

1. フック入力とプロンプトを Claude モデル（デフォルトでは Claude Code が[バックグラウンド機能](/docs/ja/costs#background-token-usage)に使用するモデル）に送信
2. LLM は決定を含む構造化 JSON で応答
3. Claude Code は決定を自動的に処理

<h3 id="prompt-hook-configuration">
  プロンプト フック設定
</h3>

`type` を `"prompt"` に設定し、`command` の代わりに `prompt` 文字列を提供します。`$ARGUMENTS` プレースホルダーを使用して、フックの JSON 入力データをプロンプト テキストに注入します。

この `Stop` フックは、Claude が終了する前にすべてのタスクが完了しているかどうかを評価するよう LLM に求めます：

```json theme={null}
{
  "hooks": {
    "Stop": [
      {
        "hooks": [
          {
            "type": "prompt",
            "prompt": "Evaluate if Claude should stop: $ARGUMENTS. Check if all tasks are complete."
          }
        ]
      }
    ]
  }
}
```

| フィールド | 必須 | 説明 |
| :- | :- | :- |
| `type` | はい | `"prompt"` である必要があります |
| `prompt` | はい | LLM に送信するプロンプト テキスト。フック入力 JSON のプレースホルダーとして `$ARGUMENTS` を使用します。`$ARGUMENTS` が存在しない場合、入力 JSON がプロンプトに追加されます |
| `model` | いいえ | 評価に使用するモデル。デフォルトは Claude Code が[バックグラウンド機能](/docs/ja/costs#background-token-usage)に使用するモデル |
| `timeout` | いいえ | タイムアウト（秒単位）。デフォルト：30 |
| `continueOnBlock` | いいえ | 適用されるイベントでは、`true` にすると `ok: false` の理由を Claude にフィードバックし、ターンを終了する代わりに続行します。デフォルト：`false`。イベント ごとの動作については、[レスポンス スキーマ](#response-schema)を参照してください |

<h3 id="response-schema">
  レスポンス スキーマ
</h3>

LLM は以下を含む JSON で応答する必要があります：

```json theme={null}
{
  "ok": true | false,
  "reason": "Explanation for the decision",
  "impossible": true | false
}
```

| フィールド | 説明 |
| :- | :- |
| `ok` | `true` で許可します。`false` の場合は、以下のイベント ごとの動作を参照してください |
| `reason` | `ok` が `false` のときに必須 |
| `impossible` | 省略可能。条件が決して満たされないとモデルが判断した場合に、`ok: false` とともに返します。`Stop` と `SubagentStop` では、Claude Code は理由をフィードバックする代わりにターンを終了させます。エージェント フックとその他のイベントはこれを無視します |

`ok: false` で何が起こるかはイベントによって異なります：

* `Stop` と `SubagentStop`：理由は Claude の次の指示としてフィードバックされ、ターンが続行されます。ただし、応答で `impossible: true` も設定されている場合は、Claude Code が停止を許可し、ターンが終了します
* `PreToolUse`：ツール呼び出しが拒否されます。デフォルトではターンが終了し、拒否理由は警告行としてチャットに表示されます。代わりに理由をツール エラーとして Claude に返し、Claude が調整して続行できるようにするには、`continueOnBlock: true` を設定します。これはコマンド フックの `permissionDecision: "deny"` と同等です。v2.1.210 より前は、拒否理由はツール エラーとして Claude に返され、ターンは続行されていました
* `PostToolUse`：デフォルトではターンが終了し、理由は警告行としてチャットに表示されます。`continueOnBlock: true` を設定して、理由を Claude にフィードバックし、ターンを続行する代わりに使用します
* `PostToolBatch`、`UserPromptSubmit`、`UserPromptExpansion`：ターンが終了し、理由は警告行として表示されます。これらのイベントは `continue` に関係なく `decision: "block"` でターンを終了します
* `PostToolUseFailure`、`TaskCreated`：理由は `continueOnBlock` に関係なくツール エラーとして Claude に返され、ターンが続行されます
* `TaskCompleted`：ターン中にタスクが完了としてマークされたために発火した場合、理由は `continueOnBlock` に関係なくツール エラーとして Claude に返され、ターンが続行されます。チームメイトが停止したために発火した場合は、`TeammateIdle` と同様に動作し、デフォルトでチームメイトを停止します
* `TeammateIdle`：デフォルトではチームメイトが停止し、理由は警告行として表示されます。`continueOnBlock: true` を設定して、理由をチームメイトにフィードバックし、代わりに作業を続行させます
* `PermissionRequest`：`ok: false` は効果がありません。フックから承認を拒否するには、[コマンド フック](#command-hook-fields)を使用して `hookSpecificOutput.decision.behavior: "deny"` を返します
* `PermissionDenied`：`ok: false` は効果がありません。拒否は既に発生しているためです。このイベントが読み取る唯一の出力は `hookSpecificOutput.retry` です。プロンプト フックとエージェント フックはこれを設定できません。これらはこのイベントで実行されますが、その出力は破棄されます。`retry` を返すには、[コマンド フック](#command-hook-fields)を使用してください

任意のイベントでより細かい制御が必要な場合は、[決定制御](#decision-control)で説明されているイベント ごとのフィールドを使用して、[コマンド フック](#command-hook-fields)を使用してください。

<h3 id="check-multiple-conditions-before-stopping">
  停止する前に複数の条件をチェック
</h3>

この `Stop` フックは詳細なプロンプトを使用して、Claude が停止することを許可する前に 3 つの条件をチェックします。`SubagentStop` フックは同じ形式を使用して、[サブエージェント](/docs/ja/sub-agents)が停止すべきかどうかを評価します。条件がまだ満たされていないためにモデルが `"ok": false` を返した場合、Claude は提供された理由を次の指示として受け取り、作業を続行します：

```json theme={null}
{
  "hooks": {
    "Stop": [
      {
        "hooks": [
          {
            "type": "prompt",
            "prompt": "You are evaluating whether Claude should stop working. Context: $ARGUMENTS\n\nAnalyze the conversation and determine if:\n1. All user-requested tasks are complete\n2. Any errors need to be addressed\n3. Follow-up work is needed\n\nRespond with JSON: {\"ok\": true} to allow stopping, or {\"ok\": false, \"reason\": \"your explanation\"} to continue working.",
            "timeout": 30
          }
        ]
      }
    ]
  }
}
```

<h2 id="agent-based-hooks">
  エージェント ベースのフック
</h2>

<Warning>
  エージェント フックは実験的です。動作と設定は将来のリリースで変更される可能性があります。本番ワークフローの場合は、[コマンド フック](#command-hook-fields)を優先してください。
</Warning>

エージェント ベースのフック（`type: "agent"`）はプロンプト ベースのフックのようですが、マルチターン ツール アクセスを備えています。単一の LLM 呼び出しの代わりに、エージェント フックはサブエージェントを生成し、ファイルを読み取り、コードを検索し、コードベースを検査して条件を検証できます。エージェント フックは、`PermissionRequest` を除き、[プロンプト ベースのフック](#prompt-based-hooks)と同じイベントをサポートしています。

<h3 id="how-agent-hooks-work">
  エージェント フックの仕組み
</h3>

エージェント フックが発火するとき：

1. Claude Code はプロンプトとフックの JSON 入力を持つサブエージェントを生成します
2. サブエージェントは Read、Grep、Glob などのツールを使用して調査できます
3. 最大 50 ターン後、サブエージェントは構造化 `{ "ok": true/false }` 決定を返します
4. Claude Code は `ok` が `true` の場合にアクションを許可します。`ok` が `false` の場合、Claude Code は[レスポンス スキーマ](#response-schema)に記載されているとおり、そのイベントで `continueOnBlock: true` を指定したプロンプト フックと同じ方法でブロックを処理します

エージェント フックは、フック入力データのみを評価するのではなく、実際のファイルを検査したりテスト出力を検査したりする必要がある場合に便利です。

<h3 id="agent-hook-configuration">
  エージェント フック設定
</h3>

`type` を `"agent"` に設定し、`prompt` 文字列を提供します。フック入力 JSON のプレースホルダーとして `$ARGUMENTS` を使用します。設定フィールドは[プロンプト フック](#prompt-hook-configuration)と同じですが、エージェント フックはデフォルト タイムアウトが 60 秒と長く、`continueOnBlock` フィールドがありません。

レスポンス スキーマは、許可する場合は `{ "ok": true }`、ブロックする場合は `{ "ok": false, "reason": "..." }` です。`ok: false` の場合、Claude Code はエージェント フックを、同じイベントにおける[`continueOnBlock: true` を指定したプロンプト フック](#response-schema)と同じ方法で処理します。エージェント フックには `continueOnBlock` フィールドがなく、プロンプト フックの `impossible` フィールドもサポートしていません。

この `Stop` フックは、Claude が終了することを許可する前にすべてのユニット テストが合格することを検証します：

```json theme={null}
{
  "hooks": {
    "Stop": [
      {
        "hooks": [
          {
            "type": "agent",
            "prompt": "Verify that all unit tests pass. Run the test suite and check the results. $ARGUMENTS",
            "timeout": 120
          }
        ]
      }
    ]
  }
}
```

<h2 id="run-hooks-in-the-background">
  バックグラウンドでフックを実行
</h2>

デフォルトでは、フックは完了するまで Claude の実行をブロックします。デプロイ、テスト スイート、外部 API 呼び出しなどの長時間実行タスクの場合、`"async": true` を設定してフックをバックグラウンドで実行し、Claude が作業を続行できるようにします。非同期フックはブロックまたは Claude の動作を制御できません。`decision`、`permissionDecision`、`continue` などのレスポンス フィールドは、制御しようとしたアクションがすでに完了しているため、効果がありません。

<h3 id="configure-an-async-hook">
  非同期フックを設定
</h3>

コマンド フックの設定に `"async": true` を追加して、Claude をブロックせずにバックグラウンドで実行します。このフィールドは `type: "command"` フックでのみ利用可能です。

このフックは、すべての `Write` ツール呼び出しの後にテスト スクリプトを実行します。`run-tests.sh` の実行中も、Claude はすぐに作業を続行します。スクリプトが完了すると、その出力は次の会話ターンで配信されます。

```json theme={null}
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write",
        "hooks": [
          {
            "type": "command",
            "command": "/path/to/run-tests.sh",
            "async": true
          }
        ]
      }
    ]
  }
}
```

非同期フックがバックグラウンドで実行され始めると、Claude Code はそのフックに `timeout` を適用しません。`asyncRewake` で実行するフックには、Claude Code は引き続き `timeout` を適用します。

Claude Code が非同期フックの結果を配信するのは、セッションの実行中のみです。

* `-p` フラグを使用した[非対話モード](/docs/ja/headless)では、Claude Code は終了処理時にまだ実行中の非同期フックをすべて強制終了し、結果 `cancelled` で確定します
* フックの処理を `claude -p` セッションより長く存続させる必要がある場合は、フックから完全にデタッチされたプロセスを起動します

<h3 id="how-async-hooks-execute">
  非同期フックの実行方法
</h3>

非同期フックが発火すると、Claude Code はフック プロセスを開始し、完了を待たずにすぐに続行します。フックは同期フックと同じ JSON 入力を stdin 経由で受け取ります。

バックグラウンド プロセスが終了した後、Claude Code はフックの JSON レスポンスに含まれる `additionalContext` フィールドと `systemMessage` フィールドを次の会話ターンで Claude に配信します。同期フックの `systemMessage` とは異なり、どちらのフィールドもユーザーには表示されません。

Claude Code は JSON レスポンスを同期フックと同じ[出力スキーマ](#json-output)に対して検証し、`systemMessage` が文字列でないなど、値の型が間違っているフィールドをドロップします。これは配信する代わりに行われます。`--debug` で実行すると、ドロップされた各フィールドに名前を付けた警告が表示されます。v2.1.202 より前では、非同期フックからの不正な形式の JSON 出力はセッションをクラッシュさせる可能性があり、セッションが再開されるたびにクラッシュが再発生していました。

非同期フック完了通知はデフォルトで抑制されます。これらを表示するには、`Ctrl+O` で詳細モードを有効にするか、`--verbose` で Claude Code を開始します。

<h3 id="run-tests-after-file-changes">
  ファイル変更後にテストを実行
</h3>

このフックは Claude がファイルを書き込むたびにバックグラウンドでテスト スイートを開始し、テストが完了したら結果を Claude に報告します。このスクリプトをプロジェクトの `.claude/hooks/run-tests-async.sh` に保存し、`chmod +x` で実行可能にします。

```bash theme={null}
#!/bin/bash
# run-tests-async.sh

# stdin からフック入力を読み取る
INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')

# ソース ファイルのみテストを実行
if [[ "$FILE_PATH" != *.ts && "$FILE_PATH" != *.js ]]; then
  exit 0
fi

# テストを実行し、additionalContext 経由で結果を Claude に報告
RESULT=$(npm test 2>&1)
EXIT_CODE=$?

if [ $EXIT_CODE -eq 0 ]; then
  MSG="Tests passed after editing $FILE_PATH"
else
  MSG="Tests failed after editing $FILE_PATH: $RESULT"
fi
jq -nc --arg msg "$MSG" '{hookSpecificOutput: {hookEventName: "PostToolUse", additionalContext: $msg}}'
```

次に、プロジェクト ルートの `.claude/settings.json` にこの設定を追加します。`async: true` フラグにより、Claude はテストの実行中に作業を続行できます。

```json theme={null}
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": "${CLAUDE_PROJECT_DIR}/.claude/hooks/run-tests-async.sh",
            "args": [],
            "async": true
          }
        ]
      }
    ]
  }
}
```

<h3 id="limitations">
  制限事項
</h3>

非同期フックは同期フックと比べていくつかの制約があります。

* フック出力は次の会話ターンで配信されます。セッションがアイドル状態の場合、レスポンスは次のユーザー操作まで待機します。例外: `asyncRewake` フックが終了コード 2 で終了すると、セッションがアイドル状態でも Claude を直ちに起動します。
* 各実行は個別のバックグラウンド プロセスを作成します。同じ非同期フックの複数の発火全体で重複排除はありません。

<h2 id="security-considerations">
  セキュリティに関する考慮事項
</h2>

<h3 id="disclaimer">
  免責事項
</h3>

<Warning>
  コマンド フックはユーザー アカウントの完全な権限でシェル コマンドを実行します。ユーザー アカウントがアクセスできるファイルを変更、削除、またはアクセスできます。フック コマンドを設定に追加する前に、すべてのフック コマンドを確認してテストしてください。
</Warning>

<h3 id="workspace-trust">
  ワークスペースの信頼
</h3>

Claude Code は、設定ファイルのフックを実行する前にワークスペースの信頼を確認します。何が信頼済みとみなされるかは、セッションの種類によって異なります。

* **インタラクティブ セッション**: ユーザーがそのフォルダー、またはそのフォルダーにまで信頼が及ぶ親ディレクトリについて[ワークスペースの信頼ダイアログ](/docs/ja/permissions#project-allow-rules-and-workspace-trust)を承認するまで、Claude Code はユーザー自身の `~/.claude/settings.json` を含むすべての設定ファイルのフックを保留します
* **`-p` または SDK セッション**: Claude Code はダイアログを表示せず、フォルダーを信頼済みとして扱います。そのため、リポジトリの `.claude/settings.json` にコミットされたフックは、一度も信頼したことのないフォルダーでも実行されます

自分が作成していないリポジトリに対して `claude -p` をスクリプトで実行する前に、そのリポジトリの `.claude/` 設定ファイルを確認するか、[`--bare`](/docs/ja/headless#start-faster-with-bare-mode) で開始するか、`--settings '{"disableAllHooks": true}'` を使用して[その実行ではフックをオフにして](#disable-or-remove-hooks)ください。プロジェクト サブエージェントのフロントマター フックには、設定ファイルのフックよりも厳しいルールが適用されます。[フォルダーを信頼する前に実行されるもの](/docs/ja/permissions#what-runs-before-you-trust-a-folder)では、リポジトリのコンテンツの種類ごとにセッションの種類別の動作を示しています。

<h3 id="security-best-practices">
  セキュリティ ベストプラクティス
</h3>

フックを書くときは、これらのプラクティスに留意してください。

* **入力を検証およびサニタイズ**: 入力データを盲目的に信頼しないでください
* **常にシェル変数を引用**: `$VAR` ではなく `"$VAR"` を使用
* **パス トラバーサルをブロック**: ファイル パスで `..` をチェック
* **絶対パスを使用**: スクリプトの完全なパスを指定します。exec 形式では、`${CLAUDE_PROJECT_DIR}` を使用し、パスは引用符で囲む必要がありません。シェル形式では、ダブル クォートで囲みます
* **機密ファイルをスキップ**: `.env`、`.git/`、キーなどを避ける

<h2 id="windows-powershell-tool">
  Windows PowerShell ツール
</h2>

Windows では、コマンド フックで `"shell": "powershell"` を設定することで、個別のフックを PowerShell で実行できます。Claude Code は `pwsh.exe`（PowerShell 7 以降の実行可能ファイル）を自動検出し、Windows PowerShell 5.1 の `powershell.exe` にフォールバックします。

```json theme={null}
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write",
        "hooks": [
          {
            "type": "command",
            "shell": "powershell",
            "command": "Write-Host 'File written'"
          }
        ]
      }
    ]
  }
}
```

PowerShell シェル形式のコマンドからプロジェクト ルートを参照するには、`${CLAUDE_PROJECT_DIR}` または `$env:CLAUDE_PROJECT_DIR` を記述します。Claude Code は `settings.json`、プラグイン、またはスキルで定義されているかどうかに関係なく、PowerShell シェル形式のコマンド内の `${CLAUDE_PROJECT_DIR}`、`${CLAUDE_PLUGIN_ROOT}`、および `${CLAUDE_PLUGIN_DATA}` プレースホルダーを PowerShell の `${env:NAME}` 形式に書き換えます。PowerShell は解析後にエクスポートされた環境から値を解決するため、プレースホルダーはダブルクォート文字列内では機能しますが、PowerShell が変数を展開しないシングルクォート文字列内では機能しません。

PowerShell フックで裸の `$CLAUDE_PROJECT_DIR` スペルを記述しないでください。PowerShell はそれを未定義のローカル変数として解析し、`$null` に解決します。これにより、スクリプト パスがプロジェクト ルート プレフィックスなしで残されます。Claude Code はその形式を書き換えません。代わりに、[デバッグ ログ](#debug-hooks) に警告を記録します。

以下の例は、`$env:` 形式でプロジェクト スクリプトを実行する `settings.json` フックを示しています。

```json theme={null}
{
  "type": "command",
  "shell": "powershell",
  "command": "& \"$env:CLAUDE_PROJECT_DIR\\.claude\\hooks\\check.ps1\""
}
```

<h2 id="debug-hooks">
  フックをデバッグ
</h2>

フック実行の詳細はデバッグ ログ ファイルに書き込まれます。`claude --debug-file <path>` で既知の場所にログを書き込むか、`claude --debug` を実行してログを `~/.claude/debug/<session-id>.txt` で読み取ります。`--debug` フラグはターミナルに出力しません。

たとえば、`Write` に対する `PostToolUse` フックで、コマンドが `hook-ran` を出力する場合、次のようなエントリが生成されます。

```text theme={null}
2026-07-19T02:03:24.382Z [DEBUG] Hook output does not start with {, treating as plain text
2026-07-19T02:03:24.382Z [DEBUG] "Hook PostToolUse:Write (PostToolUse) success:\nhook-ran"
```

より詳細なフック マッチング詳細については、`CLAUDE_CODE_DEBUG_LOG_LEVEL=verbose` を設定して、フック matcher 数とクエリ マッチングなどの追加ログ行を確認します。

フックが発火しない、Stop フックが実行をブロックし続ける、または設定エラーなどの一般的な問題のトラブルシューティングについては、ガイドの[制限事項とトラブルシューティング](/docs/ja/hooks-guide#limitations-and-troubleshooting)を参照してください。`/context`、`/doctor`、および設定の優先順位をカバーするより広範な診断チュートリアルについては、[設定をデバッグ](/docs/ja/debug-your-config)を参照してください。
