> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# 権限モードを選択する

> Claude が行動する前に確認するかどうかを制御します。CLI では Shift+Tab で、VS Code ではモード表示で、Desktop ではモードセレクターで権限モードを切り替えます。

権限モードは、セッション内で Claude Code が最初にあなたに確認することなく実行できるアクションを設定します。Manual モードでは、Claude Code はファイルを編集したり、シェルコマンドを実行したり、ネットワークに到達したりするほとんどのアクションの前に停止して確認を求めます。[auto モード](#eliminate-prompts-with-auto-mode)では、分類器という 2 番目のモデルがあなたの代わりにアクションをレビューします。[分類器がアクションを評価する方法](#how-the-classifier-evaluates-actions)には、分類器がレビューするアクションと、スキップするアクションが記載されています。

Claude Code v2.1.283 以降では、auto モードはインタラクティブターミナルと VS Code セッションの組み込みの開始権限モードです。それより前のバージョンでは、Pro、Max、Team プランでのみ組み込みの開始権限モードです。[セッションが開始される権限モード](#which-mode-a-session-starts-in)は、開始権限モードを変更するサーフェスと設定をカバーしています。実行中のセッションの権限モードはいつでも変更できます。

<h2 id="available-modes">
  利用可能なモード
</h2>

各モードは、利便性と監視のバランスを異なる方法で取ります。以下の表は、各モードで Claude がパーミッション プロンプトなしで実行できることを示しています。Manual モードはその設定値である `default` の下に表示されます。

| モード | 確認なしで実行されるもの | 最適な用途 |
| :- | :- | :- |
| `default` | 読み取りのみ | すべてのアクションを自分で確認する、機密性の高い作業 |
| [`acceptEdits`](#auto-approve-file-edits-with-acceptedits-mode) | 読み取り、ファイル編集、一般的なファイルシステム コマンド（`mkdir`、`touch`、`mv`、`cp` など） | 確認中のコードを反復処理する |
| [`plan`](#analyze-before-you-edit-with-plan-mode) | 読み取り、および [auto モード](#eliminate-prompts-with-auto-mode) が利用可能な場合の分類器承認コマンド | コードベースを変更する前に探索する |
| [`auto`](#eliminate-prompts-with-auto-mode) | すべて、バックグラウンド安全性チェック付き | 長いタスク、プロンプト疲労の軽減 |
| [`dontAsk`](#allow-only-pre-approved-tools-with-dontask-mode) | 読み取りと事前承認ツール。プロンプトが表示されるものはすべて拒否 | ロックダウン CI とスクリプト |
| [`bypassPermissions`](#skip-all-checks-with-bypasspermissions-mode) | すべて | 分離されたコンテナと VM のみ |

すべてのアクションを確認するモードは、CLI、`claude --help`、VS Code および JetBrains 拡張機能、デスクトップアプリでは **Manual** という名前です。その設定値は `default` で、フックと SDK 統合ではこの値が使用されます。CLI は、値を入力するあらゆる場所で `manual` をエイリアスとして受け付けます。例えば `claude --permission-mode manual` や `"defaultMode": "manual"` のように指定できます。

[保護されたパス](#protected-paths) への書き込みは、`bypassPermissions` モードおよび bypass 権限が利用可能な plan モード セッション（つまり、[`bypassPermissions` をモード サイクルに含める](#switch-permission-modes) 方法で開始されたインタラクティブ ターミナル セッション）を除いて、自動承認されることはありません。

モードはベースラインを設定します。特定のツールを事前承認またはブロックするために、[権限ルール](/docs/ja/permissions#manage-permissions) を上に重ねます。拒否ルールは `bypassPermissions` を含むすべてのモードでブロックします。拒否ルールと確認ルールは、Claude が呼び出せる他のツールが少なくとも 1 つある限り、[`EndConversation`](/docs/ja/tools-reference#endconversation-tool-behavior) には適用されません。許可ルールは `bypassPermissions` では効果がありません。

<h3 id="actions-no-mode-auto-approves">
  どのモードも自動承認しないアクション
</h3>

Claude Code は、`bypassPermissions` を含むどのモードでも、以下を自動承認しません。各項目は、各モードで代わりに何が起こるかを説明するセクションにリンクしています。

* 明示的な [確認ルール](/docs/ja/permissions#manage-permissions) に一致するツール
* 組織が [`ask`](/docs/ja/mcp#organization-controls-on-connector-tools) に設定したコネクタ ツール（その設定が Claude Code に到達するセッション内）
* ユーザー インタラクションが必要なツール：組み込みの `AskUserQuestion` ツールと [`requiresUserInteraction`](/docs/ja/mcp#require-approval-for-a-specific-tool) でマークされた MCP ツール
* [重要なパス](#critical-paths) をターゲットとする `rm` および `rmdir` 削除。許可ルールまたは `PreToolUse` hook `"allow"` では承認されません
* [クロス セッション メッセージング セーフガード](#skip-all-checks-with-bypasspermissions-mode)
* [`permissions.blockReadsOutsideWorkingDirectories`](/docs/ja/settings-reference#permissions-blockreadsoutsideworkingdirectories) がオンの場合、作業ディレクトリ外の読み取り：認識されたファイル読み取り Bash コマンドおよび auto モードおよび `bypassPermissions` モードでもサンドボックス外で実行するために承認が必要な [unsandboxed retry](/docs/ja/sandboxing#the-unsandboxed-retry-escape-hatch)。Claude Code v2.1.257 以降が必要です

  シェル パーサーが追跡できないコマンド（例えば、複数回ディレクトリを変更したり、サブシェルを実行したりするコマンド）は、外部パスを指定しない場合でも同じ方法でプロンプトが表示されます。このプロンプトは、コマンドが [sandbox](/docs/ja/sandboxing) で実行され、sandbox がブロックを強制する場合には適用されません。

<h2 id="common-setups">
  一般的なセットアップ
</h2>

権限モードは Claude がアクションの前に確認するかどうかを決定し、[Bash サンドボックス](/docs/ja/sandboxing)と外側の[隔離境界](/docs/ja/sandbox-environments)は、アクションが実行されると何に到達できるかを決定します。以下の各行は、目標をフラグまたは設定と、必要な隔離とペアにします。これは開始点です。[利用可能なモード](#available-modes)は、各モードでプロンプトなしで実行されるものをリストしています。

| 実現したいこと | 開始する | 必要な隔離 | 注記 |
| :- | :- | :- | :- |
| すべてのアクションを自分でレビュー | Manual モード：`claude --permission-mode default` | なし | 機密作業、不慣れなコード |
| ローカルで反復、分類器なしでプロンプトを減らす | Manual モード + [auto-allow モード](/docs/ja/sandboxing#sandbox-modes)の Bash サンドボックス：`claude --permission-mode default`、その後 `/sandbox` を実行して auto-allow を選択 | 組み込み Bash サンドボックス、macOS、Linux、WSL2 上 | 拒否ルールは依然として適用され、`Bash(git push *)` のようなコマンドに名前を付ける ask ルールは依然としてプロンプトを表示します。代わりに設定ファイルからサンドボックスをオンにするには、[`sandbox.enabled`](/docs/ja/settings-reference#sandbox-enabled) を `true` に設定します |
| 何かを変更する前に探索 | `claude --permission-mode plan` | なし | Claude Code は[計画を承認](#review-and-approve-a-plan)するまで編集をブロックします |
| auto モードでハンズオフで作業 | `claude --permission-mode auto`、v2.1.283 以降の[組み込み開始権限モード](#which-mode-a-session-starts-in) | なし。サンドボックスまたはコンテナは防御の深さを追加 | [サポートされているモデル](#eliminate-prompts-with-auto-mode)が必要で、組織は [auto モードをオフ](#eliminate-prompts-with-auto-mode)にできます |
| 正確な許可リストで CI で実行 | `claude -p "run the test suite" --permission-mode dontAsk --allowedTools "Bash(npm test)" "Read"` | CI ランナーが提供するもの以外はなし | [Web 上の Claude Code](/docs/ja/claude-code-on-the-web)は設定ファイルから `dontAsk` を無視します |
| コンテナ内で完全に無人で実行 | `claude -p "<prompt>" --dangerously-skip-permissions` | 必須：コンテナ、VM、または[サンドボックスランタイム](/docs/ja/sandbox-environments#sandbox-runtime)。Linux と macOS では、[非 root ユーザー](#skip-all-checks-with-bypasspermissions-mode)として実行 | Web 上の Claude Code は設定ファイルからこのモードを無視します。この `-p` 実行では、[依然としてプロンプトが表示される少数の呼び出し](#skip-all-checks-with-bypasspermissions-mode)は代わりに拒否されます |

Bash サンドボックスと auto モードは独立して機能し、[Sandbox modes](/docs/ja/sandboxing#sandbox-modes)の下にリストされている例外を除いて組み合わさります。完全な相互作用については、[サンドボックスが権限と権限モードにどのように関連するか](/docs/ja/sandboxing#how-sandboxing-relates-to-permissions-and-permission-modes)および[隔離が権限モードにどのように関連するか](/docs/ja/sandbox-environments#how-isolation-relates-to-permission-modes)を参照してください。

<h2 id="which-mode-a-session-starts-in">
  セッションが開始するモード
</h2>

ターミナルで新しいセッションを開始すると、Claude Code は最初に適用されるものから権限モードを取得します。

1. `--permission-mode` フラグ、または `--dangerously-skip-permissions`

2. [設定ファイル](/docs/ja/settings#where-settings-live)の `permissions.defaultMode`

   `.claude/settings.json` または `.claude/settings.local.json` で `"auto"` を設定した場合、値は有効にならず、Claude Code は `~/.claude/settings.json` からの `defaultMode` ではなく組み込みデフォルトを使用します。これらの 2 つのファイルで `"bypassPermissions"` を設定した場合、それも有効にならず、セッションは Manual モードで開始します。他の値はすべての設定ファイルから適用されます。

3. 組み込みデフォルト

VS Code 拡張機能が開始する会話は、[権限モードを切り替える](#switch-permission-modes)の拡張機能独自のリストに従います。Claude Code が再開されたセッションを開始する権限モードについては、[再開時の権限モード](/docs/ja/sessions#permission-mode-on-resume)を参照してください。

組み込み `auto` デフォルトには、macOS、Linux、WSL では Claude Code v2.1.228 以降が必要で、ネイティブ Windows では v2.1.233 以降が必要です。以前のバージョンでは、組み込みデフォルトは Manual です。

組み込みデフォルトは、Claude Code の実行方法によって異なります。セッションに一致する最初の行が適用されます。表は、ターミナルまたは VS Code 拡張機能を通じて開始するセッションをカバーしています。デスクトップアプリと claude.ai については、[権限モードを切り替える](#switch-permission-modes)の Desktop と Web タブを参照してください。

| Claude Code の実行方法 | 組み込み開始権限モード |
| :- | :- |
| 設定ファイルが `disableAutoMode` を `"disable"` に設定 | `default` |
| `claude -p` または [Agent SDK](/docs/ja/agent-sdk/permissions#permission-modes) | [フィーチャーフラグを取得](/docs/ja/env-vars#features-that-need-feature-flag-fetching)するセッションでは `default`。テレメトリがオフの場合やサードパーティプロバイダーなど、フィーチャーフラグを取得しないセッションでは、Claude Code v2.1.285 以降では `auto`、以前のバージョンでは `default`。`auto` デフォルトを保留するポリシーを持つ組織内のセッションは、代わりに `default` で開始します |
| 組織に [HIPAA 設定](#hipaa-configuration)が適用されており、セッションが[その対象](/docs/ja/hipaa-setup#check-how-developers-sign-in-and-connect)である | Claude Code v2.1.285 以降では `default`。auto モードへの切り替えは引き続き可能です |
| ターミナルまたは [VS Code 拡張機能](/docs/ja/vs-code)を通じて | Claude Code v2.1.283 以降では `auto`。以前のバージョンでは、Pro、Max、または Team プランで [フィーチャーフラグを取得](/docs/ja/env-vars#features-that-need-feature-flag-fetching)するセッションでは `auto`、それ以外は `default` |

[インストールまたはアップグレード後の最初のセッション](/docs/ja/env-vars#first-session-after-an-install-or-upgrade)では、Claude Code はフィーチャーフラグが到達する前に開始権限モードを選択できます。そのセッションは表が示すものとは異なる権限モードで開始する可能性があります。

フラグ、設定ファイル、または組み込みデフォルトが `auto` を選択しても、auto モードがセッションで利用できない場合、Claude Code はセッションを Manual で開始します。Auto モードは、セッションが [利用可能性要件](#eliminate-prompts-with-auto-mode)を満たさない場合（設定ファイルがそれをオフにするか、サポートしていないモデルなど）、または Anthropic がサーバー側で一時的にそれをオフにした場合に利用できません。

組み込みデフォルトが初めてセッションを auto モードで開始するとき、Claude Code はこのページにリンクする通知を表示します。

* ターミナルでは、セッションの上部に 1 回
* VS Code 拡張機能では、新しい会話画面のカードとして、却下するまで表示されます

`~/.claude/settings.json` が `auto` 以外の `defaultMode` を設定し、他の設定ファイルが設定しない場合、セッションはそのモードで開始し続けます。Pro、Max、Team プランおよび [フィーチャーフラグを取得しない](/docs/ja/env-vars#features-that-need-feature-flag-fetching)セッションでは、Claude Code はターミナルまたは VS Code 拡張機能で 1 回、設定を auto モードに変更するかどうかを尋ねます。却下した場合、設定はそのままです。

<h3 id="start-in-a-different-mode">
  異なる権限モードで開始する
</h3>

1 つのセッション、マシン上のすべてのセッション、プロジェクト内、または組織内のすべてのセッションの開始権限モードを設定できます。複数の設定ファイルが `permissions.defaultMode` を設定する場合、[設定の優先順位](/docs/ja/settings#settings-precedence)が決定するため、プロジェクトまたは管理値は `~/.claude/settings.json` より優先されます。実行中のセッションの権限モードを変更するには、[権限モードを切り替える](#switch-permission-modes)を参照してください。

| 開始権限モードを設定する対象 | これを実行 |
| :- | :- |
| 開始しようとしている 1 つのセッション | 権限モードをフラグとして渡します。例えば `claude --permission-mode default` |
| このマシンで開始するすべてのターミナルセッション | `~/.claude/settings.json` で `permissions.defaultMode` を設定します。VS Code 拡張機能が読み取る内容については、[権限モードを切り替える](#switch-permission-modes)を参照してください |
| 1 つのプロジェクトで開始するすべてのターミナルセッション | プロジェクトの `.claude/settings.json` で `permissions.defaultMode` を設定します。ターミナルで開始するセッションは `auto` と `bypassPermissions` を除くすべての値を尊重します。VS Code 拡張機能が開始するセッションはプロジェクト設定を開始権限モードに読み込みません |
| 組織内のすべてのターミナルセッション | [管理設定](/docs/ja/managed-settings)で `permissions.defaultMode` を設定します。ターミナルセッションはそのモードで開始し、ユーザーは依然として auto モードに切り替えることができます。VS Code 拡張機能が読み取る内容については、[権限モードを切り替える](#switch-permission-modes)を参照してください。auto モードを削除してユーザーが選択できないようにするには、代わりに `permissions.disableAutoMode` を `"disable"` に設定します |

この例は、マシン上のすべてのターミナルセッションを Manual モード（その設定値は `default`）で開始するようにします。`~/.claude/settings.json` に保存します。

```json theme={null}
{
  "permissions": {
    "defaultMode": "default"
  }
}
```

次に開始するセッションは、ステータスバーに `⏸ manual mode on` を表示します。

<h3 id="hipaa-configuration">
  HIPAA 設定での権限モード
</h3>

[HIPAA 設定](/docs/ja/hipaa-setup)が適用されている組織では、組み込みの `auto` デフォルトは適用されません。開始権限モードを他に選択するものがない場合、ターミナルまたは VS Code のセッションは Manual モードで開始します。ターミナルセッションでは `Auto mode isn't the default for your organization · Shift+Tab to switch` も表示され、VS Code 拡張機能では通知は表示されません。これが適用されるセッションについては、[開発者のサインイン方法と接続方法を確認する](/docs/ja/hipaa-setup#check-how-developers-sign-in-and-connect)に記載されています。

auto モードと `bypassPermissions` は引き続き利用できます。

* **auto モードに切り替える**: `Shift+Tab` を押すか、[使用しているインターフェースのコントロール](#switch-permission-modes)を使用します
* **auto モードで開始する**: `--permission-mode auto` を渡すか、ユーザー設定で `permissions.defaultMode` を `auto` に設定します。組織全体に対しては管理設定で設定します。[異なる権限モードで開始する](#start-in-a-different-mode)を参照してください
* **auto モードを削除する**: 管理設定で [`permissions.disableAutoMode`](/docs/ja/settings-reference#disableautomode) を `"disable"` に設定します
* **`bypassPermissions` をブロックする**: 管理設定で [`permissions.disableBypassPermissionsMode`](/docs/ja/settings-reference#permissions-disablebypasspermissionsmode) を `"disable"` に設定します

Claude Code v2.1.285 以降が必要です。これは [HIPAA 設定の最小バージョン](/docs/ja/hipaa-setup#update-claude-code-and-claude-desktop)です。

<h2 id="switch-permission-modes">
  権限モードを切り替える
</h2>

各インターフェースには、セッション中に権限モードを切り替えるための独自のコントロールと、新しいセッションが開始する権限モードを選択するための独自の方法があります。インターフェースを選択して、そのコントロールを確認してください。

<Tabs>
  <Tab title="CLI">
    **セッション中**：`Shift+Tab` を押して権限モードをサイクルします。`auto` からの場合、最初のプレスで `default` に切り替わり、その後サイクルは `default` → `acceptEdits` → `plan` の順に進みます。オプションモードは `plan` の後にスロットインします。ステータスバーはアクティブなモードを、`default` の場合はグレーの `⏸ manual mode on`、または `⏵⏵ accept edits on`、`⏸ plan mode on`、`⏵⏵ auto mode on`、`⏵⏵ don't ask on`、または `⏵⏵ bypass permissions on` として表示します。

    auto モードで開始したセッションのこのクリップで、ステータスバーに注目してください。`Shift+Tab` を押すたびに、`auto mode on` から `manual mode on`、`accept edits on`、`plan mode on` へと変わり、再び `auto mode on` に戻ります。

    <Frame>
      <video autoPlay muted loop playsInline className="w-full dark:hidden" style={{aspectRatio: "1440 / 264"}} src="https://mintcdn.com/claude-code/oa7CKjMeIChox26S/images/permission-modes-cycle-light.mp4?fit=max&auto=format&n=oa7CKjMeIChox26S&q=85&s=198ca90aeb2e3675b3d01b7d686aab0b" aria-label="Claude Code のプロンプトの下にあるステータスバーが、Shift+Tab を押すたびに auto mode on、manual mode on、accept edits on、plan mode on、そして再び auto mode on へと変わります。" data-path="images/permission-modes-cycle-light.mp4" />

      <video autoPlay muted loop playsInline className="w-full hidden dark:block" style={{aspectRatio: "1440 / 264"}} src="https://mintcdn.com/claude-code/oa7CKjMeIChox26S/images/permission-modes-cycle-dark.mp4?fit=max&auto=format&n=oa7CKjMeIChox26S&q=85&s=994cdeec4e99d2f474d236c1087d6e63" aria-label="Claude Code のプロンプトの下にあるステータスバーが、Shift+Tab を押すたびに auto mode on、manual mode on、accept edits on、plan mode on、そして再び auto mode on へと変わります。" data-path="images/permission-modes-cycle-dark.mp4" />
    </Frame>

    すべてのモードがデフォルトサイクルに含まれるわけではありません。

    * `auto`：[auto モードが利用可能](#eliminate-prompts-with-auto-mode)な場合に表示されます。auto へのサイクルは確認プロンプトなしで権限モードを切り替えます
    * `bypassPermissions`：`--permission-mode bypassPermissions`、`--dangerously-skip-permissions`、`--allow-dangerously-skip-permissions`、または [ユーザー、`--settings`、または管理設定](/docs/ja/settings-reference#permissions-defaultmode)の `permissions.defaultMode: "bypassPermissions"` で開始した後に表示されます。`--allow-` バリアントはモードをサイクルに追加しますが、アクティブ化しません
    * `dontAsk`：サイクルに表示されることはありません。`--permission-mode dontAsk` で設定します

    有効なオプションモードは `plan` の後にスロットインし、`bypassPermissions` が最初で `auto` が最後です。両方が有効な場合、`bypassPermissions` から `auto` へのサイクルを通過します。

    **Bash 権限プロンプトから**：Manual と `acceptEdits` 権限モードで、[auto モード](#eliminate-prompts-with-auto-mode)が利用可能な場合、Claude Code は Bash コマンドの権限プロンプトに **Yes, and switch to auto mode** を追加します。それを選択してコマンドを承認し、セッションを auto モードに切り替えます。[PowerShell ツール](/docs/ja/tools-reference#powershell-tool)プロンプトはオプションを提供しません。Claude Code v2.1.247 以降が必要です。

    Claude Code は、[`ask` ルール](/docs/ja/permissions#manage-permissions)の 1 つによって強制されたプロンプト、または [フック](/docs/ja/hooks#pretooluse-decision-control)によるプロンプトにはオプションを追加しません。auto モードは依然としてそれらのプロンプトを表示するため、切り替えてもそれらは削除されません。

    **起動時**：権限モードをフラグとして渡します。

    ```bash theme={null}
    claude --permission-mode plan
    ```

    **デフォルトとして**：[異なる権限モードで開始する](#start-in-a-different-mode)で説明されているように、必要なスコープで `permissions.defaultMode` を設定します。

    同じ `--permission-mode` フラグは [非対話的実行](/docs/ja/headless)用に `-p` で機能します。
  </Tab>

  <Tab title="VS Code">
    **セッション中**：プロンプトボックスの下部にあるモード指示器をクリックします。このページのモードに対して以下のラベルを使用します。

    | UI ラベル | モード |
    | :- | :- |
    | Manual | `default` |
    | Edit automatically | `acceptEdits` |
    | Plan | `plan` |
    | Auto | `auto` |
    | Bypass permissions | `bypassPermissions` |

    **デフォルトとして**：権限モード会話が開始するようにピンするには、VS Code ユーザー設定で `claudeCode.initialPermissionMode` を `default`、`manual`、`acceptEdits`、`plan`、または `bypassPermissions` に設定します。設定は `auto` を受け入れません。Auto で開始するには、設定を解除したままにして、以下の項目 2 で説明されているようにモード指示器から **Auto** を 1 回選択します。拡張機能は以下の最初に適用されるものでそれぞれの新しい会話を開始します。

    1. `claudeCode.initialPermissionMode`
    2. モード指示器から最後に選択したモード（Manual、Edit automatically、または Auto の場合）。Plan または Bypass permissions を選択すると、その会話のみに適用されます
    3. [管理設定](/docs/ja/managed-settings)または `~/.claude/settings.json` からの `permissions.defaultMode`
    4. プラン、プロバイダー、組織設定の[組み込みデフォルト](#which-mode-a-session-starts-in)

    拡張機能は開始権限モードのためにプロジェクトの `.claude/settings.json` または `.claude/settings.local.json` を読み込むことはありません。`claudeCode.claudeProcessWrapper` が設定されている場合、項目 3 と 4 は適用されません。それらの会話は、項目 1 または項目 2 が権限モードを設定しない限り Manual で開始します。

    v2.1.283 より前では、項目 3 は Pro、Max、Team プランでのみ [フィーチャーフラグ取得](/docs/ja/env-vars#features-that-need-feature-flag-fetching)を行うセッションに適用されました。

    Auto は [auto モードが利用可能](#eliminate-prompts-with-auto-mode)な場合、モード指示器に表示されます。

    Bypass permissions には拡張機能設定の **Allow dangerously skip permissions** トグルが必要です。それなしでは、権限モードは指示器に表示されず、項目 1 または項目 3 からの `bypassPermissions` 値は会話を Manual で開始します。同様に、auto モードが利用できない場合、項目からの Auto は会話を Manual で開始します。

    拡張機能固有の詳細については、[VS Code ガイド](/docs/ja/vs-code)を参照してください。
  </Tab>

  <Tab title="JetBrains">
    JetBrains プラグインは IDE ターミナルで Claude Code を実行するため、権限モードの切り替えは CLI と同じように機能します。`Shift+Tab` を押してサイクルするか、起動時に `--permission-mode` を渡します。
  </Tab>

  <Tab title="Desktop">
    **セッション中**：Code タブで、送信ボタンの横にあるモードセレクターを使用します。すべてのモードがセレクターに表示されるわけではありません。

    * **Auto**：[auto モードが利用可能](#eliminate-prompts-with-auto-mode)な場合に表示されます
    * **Bypass permissions**：Pro と Max プランの Desktop 設定で **Allow bypass permissions mode** トグルが必要です。Team と Enterprise プランでは、組織ポリシーがそれを制御します

    Cowork タブはこれらのモードを使用しません。Cowork には独自の権限モードがあり、別々に有効化され、Cowork タブはアカウントのデフォルトを超えるモードが有効化されるまでモードセレクターを表示しません。[Cowork ドキュメント](https://claude.com/docs/cowork/overview)を参照してください。

    Desktop 固有の詳細については、Desktop ガイドの [権限モードを選択する](/docs/ja/desktop#choose-a-permission-mode)を参照してください。

    **デフォルトとして**：[設定](/docs/ja/settings#where-settings-live)で `defaultMode` を設定します。デスクトップアプリは CLI と同じ設定ファイルを読み取り、新しいローカルセッションに権限モードを適用します。

    モードセレクターで選択したモードはフォルダごとに記憶され、そのフォルダの `defaultMode` より優先されます。Plan は例外です。それを選択すると現在のセッションのみに適用されます。

    `defaultMode` が設定ファイルのどこに行くかについては、[異なる権限モードで開始する](#start-in-a-different-mode)の例を参照してください。
  </Tab>

  <Tab title="Web and mobile">
    [claude.ai/code](https://claude.ai/code) のプロンプトボックスの横またはモバイルアプリのモードドロップダウンを使用します。権限プロンプトは承認のために claude.ai に表示されます。どのモードが表示されるかはセッションが実行される場所によります。

    * **[Claude Code on the web](/docs/ja/claude-code-on-the-web)のクラウドセッション**：Accept edits、Plan、Auto。Accept edits は `default` モードに対応します。クラウドセッションはモードに関係なくファイル編集を事前承認するため、ドロップダウンは Manual の代わりに Accept edits を表示します。設定からの `defaultMode: "acceptEdits"` は依然として尊重されます。Auto モードは組織がそれを許可し、選択されたモデルがそれをサポートする場合にのみ表示されます。Bypass permissions は利用できません。
    * **ローカルマシンの [Remote Control](/docs/ja/remote-control)セッション**：自分で開始したセッションの場合、Manual、Accept edits、Plan。アプリから Auto または Bypass permissions を選択することはできません。プロジェクトスレッドがコンピューター上で実行されている場合は、[スレッドを自分のコンピューター上で実行する](/docs/ja/claude-projects#run-a-thread-on-your-own-computer)を参照してください。
      * Bypass permissions を除き、ドロップダウンはローカルセッションが実行されているモードを表示します。これにはターミナルから設定されたモードが含まれ、アプリまたはターミナルでモードが変更されると更新されます。
      * [デスクトップアプリ](/docs/ja/desktop)または [VS Code 拡張機能](/docs/ja/vs-code)でホストされるセッションは、アプリで発生するのと同じように権限モード変更を claude.ai に報告します。
      * v2.1.202 より前では、`/remote-control` または `claude --remote-control` で接続されたセッションはモードをまったく報告しなかったため、claude.ai とモバイルアプリはセッションが実行されていないモードを表示する可能性がありました。不一致はラベルのみに影響しました。Claude Code は権限プロンプトをセッションの実際のモードから生成し、それらは依然としてアプリに表示されて承認されました。

    Remote Control の場合、ローカルマシンを実行するセッションは claude.ai アカウントでサインインする必要があります。API キーはサポートされていません。ローカルセッションを起動するときに開始権限モードを設定することもできます。

    ```bash theme={null}
    claude remote-control --permission-mode acceptEdits
    ```
  </Tab>
</Tabs>

<h2 id="auto-approve-file-edits-with-acceptedits-mode">
  acceptEdits モードでファイル編集を自動承認する
</h2>

`acceptEdits` モードでは Claude はプロンプトなしに作業ディレクトリ内のファイルを作成および編集できます。このモードがアクティブな間、ステータスバーは `⏵⏵ accept edits on` を表示します。

ファイル編集に加えて、`acceptEdits` モードは一般的なファイルシステム Bash コマンドを自動承認します。`mkdir`、`touch`、`rm`、`rmdir`、`mv`、`cp`、`sed`。これらのコマンドは `LANG=C` または `NO_COLOR=1` のような安全な環境変数、または `timeout`、`nice`、`nohup` のようなプロセスラッパーでプレフィックスされた場合にも自動承認されます。ファイル編集と同様に、自動承認は作業ディレクトリまたは `additionalDirectories` 内のパスにのみ適用されます。

各パスは [シンボリックリンクチェック](/docs/ja/permissions#symlinks) を通過するため、そのスコープ外に解決される書き込みは自動承認されません。そのスコープ外のパス、[保護されたパス](#protected-paths) への書き込み、`rm` と `rmdir` の削除が [重要なパス](#critical-paths) をターゲットにしている場合、および [読み取り専用コマンドセット](/docs/ja/permissions#read-only-commands) を除くその他すべての Bash コマンドはまだプロンプトが表示されます。

[PowerShell ツール](/docs/ja/tools-reference#powershell-tool) が有効な場合、`acceptEdits` モードはスコープ内のパスに対して `Set-Content`、`Add-Content`、`Clear-Content`、`Remove-Item` も自動承認し、それらの一般的なエイリアスも承認します。同じスコープと保護されたパスのルールが適用され、`Remove-Item` は [独自のチェック](#remove-item-in-powershell) を取得します。`Set-Content .\notes.txt "It's done"` のようなアポストロフィを含む引用符を含む位置引数は、Claude Code が引用符付きと引用符なしの読み取りが異なるため、スコープ内のパスでもプロンプトが表示されます。`-Value` のような名前付きパラメーターを通じてコンテンツを渡してプロンプトを回避します。

事実後にエディターまたは `git diff` 経由で変更をレビューしたい場合、各編集をインラインで承認するのではなく `acceptEdits` を使用します。

Manual モードから `Shift+Tab` を 1 回押して入るか、直接開始します。

```bash theme={null}
claude --permission-mode acceptEdits
```

<h2 id="analyze-before-you-edit-with-plan-mode">
  プランモードで編集前に分析する
</h2>

プランモードは Claude に変更を研究して提案するよう指示しますが、実際には変更を加えません。Claude はファイルを読み込み、シェルコマンドを実行して探索し、プランを作成しますが、ソースを編集しません。[bypass 権限が利用可能](#skip-all-checks-with-bypasspermissions-mode)なインタラクティブターミナルセッションを除き、編集はプランを承認するまでブロックされたままです。

プランニング中のシェルコマンドの動作はセッションによって異なり、以下のケースのうち最初に該当するものが適用されます。

* **bypass 権限が利用可能なインタラクティブターミナルセッション**: 分類器もプロンプトもプランニングコマンドには適用されません。[bypassPermissions モードですべてのチェックをスキップ](#skip-all-checks-with-bypasspermissions-mode)は、そこでもまだプロンプトが表示される少数のものをカバーしています。
* **[オートモード](/docs/ja/auto-mode-config)が利用可能で、`useAutoModeDuringPlan` 設定がオン**（デフォルトではオンです）: 分類器は[重要パス削除](#critical-paths)以外のシェルコマンドをプロンプトを表示する代わりにレビューします。承認されたコマンドは実行され、拒否されたコマンドはブロックされます。
* **オートモードが利用不可、または `useAutoModeDuringPlan` がオフ**: [組み込みの読み取り専用セット](/docs/ja/permissions#read-only-commands)外のコマンドはサンドボックスの[オートアロウモード](/docs/ja/sandboxing#sandbox-modes)が有効な場合を含めて承認を求めるプロンプトが表示されます。

プランモードに入るには、`Shift+Tab` を押すか、単一のプロンプトに `/plan` を付けます。CLI からプランモードで開始することもできます。

```bash theme={null}
claude --permission-mode plan
```

`Shift+Tab` をもう一度押してプランを承認せずにプランモードを終了します。

<h3 id="review-and-approve-a-plan">
  プランをレビューして承認する
</h3>

プランの準備ができたら、Claude はそれを提示し、どのように進めるかを尋ねます。そのプロンプトから以下を選択できます。

* **はい、オートモードを使用する**: 承認して[オートモード](#eliminate-prompts-with-auto-mode)で開始します。オートモードがセッションで[利用可能でない](#eliminate-prompts-with-auto-mode)場合（例えば、組織がそれをオフにした場合）、このオプションは**はい、編集を自動受け入れ**と表示されます。bypass 権限を有効にしてセッションを開始した場合、オプションは代わりに**はい、このセッションで BYPASS PERMISSIONS（以降プロンプトなし）に切り替える**と表示されます。
* **はい、編集を手動で承認する**: 承認して各編集を個別にレビューします。
* **いいえ、プランニングを続ける**: プランモードにとどまり、Claude に何を変更するかを伝えます。

プランを承認するとプランモードを終了し、セッションを各承認オプションが説明する権限モードに切り替えるため、Claude は編集を開始します。再度プランを立てるには、`Shift+Tab` でプランモードに戻すか、次のプロンプトに `/plan` を付けます。

`Ctrl+G` を押して、提案されたプランをデフォルトのテキストエディタで開き、Claude が進める前に直接編集します。[`showClearContextOnPlanAccept`](/docs/ja/settings-reference#showclearcontextonplanaccept)が有効な場合、リストはプランを承認してプランニングコンテキストをクリアする最初のオプションを取得します。

プランを受け入れると、セッションはプランに基づいて[生成されたタイトル](/docs/ja/sessions#name-your-sessions)も取得します。ただし、セッションに既に名前を付けている場合を除きます。

<h3 id="set-plan-mode-as-the-default">
  プランモードをデフォルトとして設定する
</h3>

プロジェクトのターミナルセッションのデフォルトをプランモードにするには、`.claude/settings.json` で `defaultMode` を `plan` に設定します。これは[別の権限モードで開始](#start-in-a-different-mode)の下の例として配置されます。[VS Code 拡張機能](/docs/ja/vs-code)が開始する会話は、開始権限モードのプロジェクト設定を読み込みません。そこで、VS Code ユーザー設定で `claudeCode.initialPermissionMode` を `plan` に設定してください。

<h2 id="eliminate-prompts-with-auto-mode">
  auto モードで権限プロンプトを排除する
</h2>

auto モードを使用すると、Claude は日常的な権限プロンプトなしで実行できます。別の分類器モデルが実行前にアクションをレビューし、リクエストの範囲を超えるもの、認識されていないインフラストラクチャを対象とするもの、または Claude が読んだ悪意のあるコンテンツによって駆動されているように見えるものをブロックします。明示的な [ask ルール](/docs/ja/permissions#manage-permissions)は引き続きプロンプトを強制します。

Claude Code v2.1.283 以降では、auto モードはすべてのプランとプロバイダーにおいて、インタラクティブなターミナルセッションと VS Code セッションの[組み込みの開始権限モード](#which-mode-a-session-starts-in)です。それより前のバージョンでは、Pro、Max、Team プランでのみ組み込みの開始権限モードです。

分類器は、auto モードと [plan モードで分類器がコマンドをレビューしている間](#analyze-before-you-edit-with-plan-mode)の両方で、Claude が [`SendMessage`](/docs/ja/tools-reference) を使用して別のエージェントに送信する各メッセージ（プレーンテキストか構造化された[エージェントチーム](/docs/ja/agent-teams)メッセージかを問わず）も、Claude Code が配信する前にレビューします。送信のレビューには Claude Code v2.1.222 以降が必要です。

デフォルトでは、分類器は `rm -rf /` や `rm -rf ~` など、重要なパスを対象とする `rm` および `rmdir` による削除をレビューしません。各権限モードでそれらがどのように扱われるかについては、[重要なパス](#critical-paths)を参照してください。

auto モードはまた、Claude が確認のための質問で止まらずに作業を続けるよう促します。ただし、プロンプトやスキルが明示的にそれを前提としている場合は、Claude は引き続き質問します。引き続きプロンプトが表示されるモードでより強い自律的な動作を得るには、代わりに [Proactive 出力スタイル](/docs/ja/output-styles)を設定してください。

<Warning>
  auto モードは権限プロンプトを減らしますが、安全性を保証するものではありません。全体的な方向性を信頼できるタスクに使用し、機密性の高い操作のレビューの代わりとしては使用しないでください。
</Warning>

auto モードは、アカウントが以下のすべての要件を満たす場合にのみ利用できます。

* **プラン**: すべてのプラン。
* **組織**: Team と Enterprise では、auto モードはデフォルトで利用可能です。管理者は[管理設定](/docs/ja/managed-settings)で `permissions.disableAutoMode` を `"disable"` に設定することで、組織の auto モードをオフにできます。
* **モデル**: Anthropic API と [Claude Platform on AWS](/docs/ja/claude-platform-on-aws) では、Claude Opus 4.6 以降、Sonnet 4.6 以降、または [Fable モデル](/docs/ja/model-config#work-with-fable)。Amazon Bedrock、Google Cloud の Agent Platform、Microsoft Foundry、およびサインイン済みの [Claude apps gateway](/docs/ja/claude-apps-gateway) セッションでは、Claude Sonnet 5 以降、Opus 4.7 以降、および Fable モデルのみです。Sonnet 4.5、Opus 4.5、Haiku、claude-3 モデルを含む古いモデルは、どのプロバイダーでもサポートされていません。
* **プロバイダー**: Anthropic API、Claude Platform on AWS、Amazon Bedrock、Google Cloud の Agent Platform、Microsoft Foundry、およびサインイン済みの Claude apps gateway セッションでデフォルトで利用可能です。

Claude Code が auto モードを利用不可と報告する場合は、まずこれらの要件と、いずれかの設定ファイルが [`disableAutoMode`](/docs/ja/settings-reference#disableautomode) を設定していないかを確認してください。また、Anthropic がサーバー側で auto モードをオフにしているか、サーバーがアカウントに対して auto モードを拒否した可能性もあります。いずれかの回答を受け取ったセッションは、セッションが終了するまで auto モードをオフのままにするため、後で新しいセッションを開始してください。

モデル名を示し、auto モードがアクションの「安全性を判断できない」と述べる別のメッセージは、分類器リクエストが失敗したことを意味します。この失敗は通常一時的なものですが、Amazon Bedrock では、アカウントがそのモデルを呼び出せるようになるまで繰り返される場合があります。原因と対処方法については、[エラーリファレンス](/docs/ja/errors#auto-mode-cannot-determine-the-safety-of-an-action)を参照してください。

[設定](/docs/ja/settings-reference#all-settings)で `defaultMode: "auto"` を設定したのに、ターミナルセッションがエラーなしで Manual モードで開始する場合、その設定は `.claude/settings.json` または `.claude/settings.local.json` にある可能性があります。`auto` はこれらのファイルからは有効になりません。`~/.claude/settings.json` に移動してください。VS Code 拡張機能が開始した会話の場合は、代わりに[権限モードの切り替え](#switch-permission-modes)にある拡張機能独自のリストを確認してください。

<h3 id="enable-auto-mode-on-bedrock-agent-platform-or-foundry">
  Bedrock、Agent Platform、または Foundry での auto モード
</h3>

[Amazon Bedrock](/docs/ja/amazon-bedrock)、[Google Cloud の Agent Platform](/docs/ja/google-vertex-ai)、[Microsoft Foundry](/docs/ja/microsoft-foundry)、およびサインイン済みの [Claude apps gateway](/docs/ja/claude-apps-gateway) セッションでは、auto モードはデフォルトで利用可能です。他に権限モードを設定するものがない場合、そのセクションの表に記載されているバージョンでは、[組み込みの開始権限モード](#which-mode-a-session-starts-in)でもあります。開始権限モードを自分で選択するには、[別の権限モードで開始する](#start-in-a-different-mode)の説明に従って `permissions.defaultMode` を設定するか、VS Code 拡張機能のモードインジケーターから権限モードを選択します。

これらのプロバイダーでサポートされているのは、Claude Sonnet 5 以降、Opus 4.7 以降、および Fable モデルのみです。その他のモデルでは、セッションは代わりに Manual で開始します。

開発者が auto モードを使用できないようにするには、[管理設定](/docs/ja/managed-settings)で `disableAutoMode` を `"disable"` に設定します。これにより `auto` が `Shift+Tab` のサイクルから削除され、`--permission-mode auto` で開始されたセッションは代わりに Manual で開始します。すでに auto モードで実行中のセッションは、この設定が[管理者がデプロイしたソース](/docs/ja/managed-settings#which-managed-source-claude-code-uses)からそのセッションに届くと auto モードを終了し、`auto mode disabled by settings` と表示します。v2.1.251 より前では、実行中のセッションは終了するまで auto モードを維持していました。

v2.1.158 から v2.1.206 では、これらのプロバイダーでは `CLAUDE_CODE_ENABLE_AUTO_MODE=1` を設定するまで auto モードはオフであり、Claude Code はこの変数も設定されていない限り、これらのプロバイダーで `defaultMode: "auto"` を無視していました。この変数は互換性のために引き続き受け付けられますが、v2.1.207 以降は効果がありません。

<h3 id="server-side-classifier-review">
  サーバー側の分類器レビュー
</h3>

auto モードでは、Claude Code は独自の分類器リクエストを送信する代わりに、セッションのモデルリクエストの一部として、[決定順序](#how-the-classifier-evaluates-actions)がレビューに回すアクションをチェックするようサーバーに依頼できます。以下のセッションがサーバーに依頼します。

* **Anthropic API への直接接続**: インタラクティブなターミナルセッション、および `-p`、Agent SDK、[VS Code 拡張機能](/docs/ja/vs-code)、[デスクトップアプリ](/docs/ja/desktop)のセッションで、プランやアカウントの種類を問わず、Anthropic の段階的な展開に応じて。インタラクティブなターミナルセッションでは、Pro、Max、Team プランでは Claude Code v2.1.271 以降、Enterprise プランと Claude API アカウントでは v2.1.278 以降が必要です。`-p`、Agent SDK、VS Code 拡張機能、デスクトップアプリのセッションでは、Claude Code v2.1.281 以降が必要です。v2.1.282 以降、テレメトリをオフにしたなどの理由で[機能フラグを取得しない](/docs/ja/env-vars#features-that-need-feature-flag-fetching)セッションは、どの種類のセッションでもデフォルトでサーバーに依頼します。
* **クラウドプロバイダー、または LLM ゲートウェイやプロキシ**: [Claude Platform on AWS](/docs/ja/claude-platform-on-aws)、Amazon Bedrock、Google Cloud の Agent Platform、Microsoft Foundry で、また `ANTHROPIC_BASE_URL` を [LLM ゲートウェイまたはプロキシ](/docs/ja/llm-gateway)に向けている場合は常に、プランを問わず。デフォルトで依頼するには Claude Code v2.1.278 以降が必要です。
* **サインイン済みの [Claude apps gateway](/docs/ja/claude-apps-gateway) セッション**: Claude Code v2.1.280 以降が必要です

サーバーがアクションをレビューする場合、その判定によってアクションの扱いが決まります。それ以外に 2 つの結果があり得ます。

* **サーバーがセッションをレビューしない**: レスポンスがレビュー結果なしで完了するか、サーバーがこのセッションをレビューしないと応答します。最も一般的な原因は、レビューの依頼や結果を破棄する LLM ゲートウェイまたはプロキシと、まだサーバー側チェックに対応していないプラットフォーム、リージョン、または認証情報です。Claude Code は独自の分類器リクエストにフォールバックします。そのフォールバックがセッションの残りの期間にわたって維持されることになると、分類器リクエストが課金対象となるアカウントでは、[分類器リクエストの料金に関する通知](/docs/ja/auto-mode-classifier-billing)が表示されます。
* **サーバーがアクションの判定を返さない**: Claude Code は、レビューなしで実行するのではなく、アクションを拒否します。どの接続でも、レビュー結果が届く前にレスポンスが終了した場合や、結果が Claude Code の読み取れない形式で届いた場合に発生します。レスポンスを途中で切ったり結果を書き換えたりする LLM ゲートウェイやプロキシは、どちらの原因にもなり得ます。Anthropic API への直接接続では、タイムアウトなどでサーバーのチェックがそのアクションについて失敗した場合にも発生します。拒否メッセージ、拒否が繰り返された場合の動作、および対処方法については、[サーバーが安全性の判定を返さなかった](/docs/ja/errors#the-server-returned-no-safety-verdict)を参照してください。

サーバーへの依頼をスキップして常に Claude Code 独自の分類器リクエストを使用するには、[`CLAUDE_CODE_AUTO_MODE_SERVER=0`](/docs/ja/env-vars) を設定します。Anthropic API への直接接続では、この変数には Claude Code v2.1.281 以降が必要です。そこで `1` に設定すると、`CLAUDE_CODE_DISABLE_EXPERIMENTAL_BETAS=1` も設定していない限り、まだサーバーレビューが有効になっていないセッションでサーバーレビューがオンになります。`CLAUDE_CODE_DISABLE_EXPERIMENTAL_BETAS=1` を設定して `CLAUDE_CODE_AUTO_MODE_SERVER` を未設定のままにすると、[プレリリース機能を無効にする](/docs/ja/llm-gateway-protocol#disable-pre-release-capabilities)で説明されている場合を除き、Claude Code はサーバーへの依頼も停止します。

<h3 id="what-the-classifier-blocks-by-default">
  分類器がデフォルトでブロックするもの
</h3>

分類器は、作業ディレクトリと、セッション開始時にそのディレクトリに設定されていたリモートを信頼します。セッション中に `git remote add` や `git remote set-url` で追加または向け先を変更されたリモートは信頼されず、それ以外のものはすべて、[信頼できるインフラストラクチャを設定する](/docs/ja/auto-mode-config)まで外部として扱われます。

**デフォルトでブロック**:

* `curl | bash` のようなコードのダウンロードと実行
* 外部エンドポイントへの機密データの送信
* 本番環境へのデプロイとマイグレーション
* クラウドストレージでの大量削除
* IAM またはリポジトリ権限の付与
* 共有インフラストラクチャの変更
* セッション前から存在していたファイルの不可逆的な破壊
* Force push
* 実行時にシークレットや機密データをリポジトリの外に送信する、またはデプロイが公開する範囲を広げる変更のコミットまたはプッシュ。これには、まだシークレットを受け取っていない宛先にシークレットを渡す CI ワークフローやデプロイ設定、シークレットストアを読み取ってデータを外部に送信するスクリプトやセットアップ手順、そしてレジストリ、可視性、アーティファクト、ソースマップの設定など、デプロイが公開する範囲を広げる設定変更が含まれます。このチェックはどのブランチにも適用され、リポジトリが公開されている場合でも適用され、そのコミットやプッシュがパイプラインをトリガーするかどうかにかかわらず、変更がコミットまたはプッシュされた時点で発動します。解除するには、コミットやプッシュだけでなく、実行時の影響を明示する必要があります。v2.1.211 より前では、このチェックは代わりにデフォルトブランチに限定されていました。デフォルトブランチへのプッシュは、機密コンテンツを含む場合、依頼内容に対して変更が隠されていたり誤って説明されていたりする場合、リポジトリ外から持ち込まれたコンテンツを含む場合、または依頼したレビューを迂回する場合にブロックされていました
* `git reset --hard`、`git checkout -- .`、`git restore .`、`git clean -fd`、`git stash drop`、または `git stash clear`（分類器はコミットされていない変更を破棄するものと推定します）
* HEAD のコミットがこのセッションで作成されたものでない場合の `git commit --amend`
* v2.1.198 以降、HEAD のコミットがすでにプッシュされている場合の `git commit --amend`。メッセージのみの書き換えはブロックされません。これは、Claude がこのセッション中に作成したコミットに対し、新たにステージされたものがない状態で `--amend -m` を実行する場合です
* `terraform destroy`、`pulumi destroy`、`cdk destroy`、または `terragrunt destroy`、およびリソースを破棄するプランの適用
* シークレットマネージャーへの書き込み、または DNS レコードや TLS 証明書の変更
* 人間が承認していないプルリクエストのマージ、Claude 自身のプルリクエストの承認、または CI チェックの無効化
* `atlantis apply` やボットの `/deploy`、`/merge` など、それ自体が自動化へのコマンドとなるコメントの投稿
* 本番環境の機能フラグの切り替え、段階的な展開、または削除
* 保護された IaC スコープへのインフラストラクチャ変更の適用、またはクラスターノードのドレインと削除
* ラベルセレクターや他のユーザーのジョブまで対象にしてしまう `--all` など、指定したリソースを超えて及ぶ共有コンピュートクラスターへの書き込み
* DaemonSets や admission webhooks など、すべてのノードで実行される、またはクラスタートラフィックを傍受する Kubernetes リソースの作成
* 機密性の高いリモートターゲットへのインタラクティブシェルやポートフォワード
* ローカルサービスをパブリックインターネットから到達可能にするトンネルやリバースシェルの開設
* 有効な認証情報やトークンのトランスクリプトまたはファイルへの出力
* [環境](/docs/ja/auto-mode-config#define-trusted-infrastructure)で機密データの保存場所として記載されている場所へのアクセス、そこからのデータのコピー、またはエントリが除外している対象者へのそこからのデータ送信
* 内部パッケージレジストリを迂回してパブリックレジストリからパッケージをインストールすること。これは、内部レジストリやミラーが環境に記載されている場合、または会話の中で Claude にそれが存在すると伝えた場合に適用されます
* `--insecure` のような、安全ガードを無効にするフラグを付けたコマンドの実行
* `--dangerously-skip-permissions` や `--no-sandbox` で起動したものなど、人間の承認やサンドボックスなしで実行される自律エージェントループの起動。これには、`--yes-always` で起動したランナーなど、分離とアクションごとの承認を無効にしてサードパーティのエージェントや eval ハーネスを実行することも含まれます
* ページコンテンツ、Cookie、または認証情報をオリジン外に送信する可能性のある [Claude in Chrome](/docs/ja/chrome) のブラウザアクション
* 特定の名前付きパスではなく、ワイルドカード、glob、または経過時間フィルターによって `/tmp`、`$TMPDIR`、またはその他の共有スクラッチディレクトリやキャッシュディレクトリ内のファイルを削除すること
* 他の人や共有システムに送信、アップロード、公開、または書き込まれるコンテンツに、ユーザー自身のメッセージがその受信者に対して認めていない機密性の高い詳細を含めること。リポジトリが信頼境界の外にあるか公開されている場合（組織自身の公開リポジトリを含む）、PR やイシューの本文、コミットメッセージ、コメントはこの種の外部向けコンテンツとして扱われます。内部のファイルパス、コードネーム、メールアドレスやアカウント識別子などの実際の API レスポンスデータ、インフラストラクチャ識別子は機密性の高い詳細として扱われます。メールアドレス、アカウントや組織の識別子、使用量の指標など、API レスポンスから得た実際の個人データを PR やイシューの本文に含める場合は、リポジトリの可視性や信頼境界にかかわらず、それらの詳細と受信者を明示する必要があります。このチェックには Claude Code v2.1.203 以降が必要です
* Claude Code 自身の tmux ペインにキーストロークを送信して自身のインターフェースを操作すること（分類器はこれを、Claude が自身の権限や監視を変更するものとして扱います）
* 認証、アクセス制御、入力検証、サンドボックス化などのセキュリティ動作を保護するテストやアサーションのコメントアウト、削除、または強制的な合格化
* より具体的な削除ルールが適用されず、ユーザーがそのリソースを指定していない場合に、セッション中に Claude が作成していないステートフルなリソースを削除または破棄すること
* API ベース URL、プロキシエンドポイント、webhook レシーバー、またはレジストリミラーを、タスクにそぐわないサードパーティホストに向け直すこと（`.env.example` のようなサンプルファイル内を含む）
* 新しいリモートをユーザーが指定していない限り、`git remote set-url` や `git remote add` でプッシュ先を変更すること
* 公開されていることがわかっているリポジトリへのシークレット、個人データ、または預かったデータのプッシュ、またはそのリポジトリ自体の作業に含まれない機密資料のプッシュ。dotfiles リポジトリ自体の対象となる内容は、個人データや預かったデータに関する唯一の例外であり、プライベートリポジトリのコンテンツがいずれかの公開サーフェスに到達する場合も同様にブロックされます。これらの改善にはいずれも Claude Code v2.1.203 以降が必要です。v2.1.203 より前では、個人データは機密資料と同じ扱いで、そのリポジトリ自体の作業に含まれない場合にのみブロックされていました。リポジトリの可視性が確認できない場合、分類器はそれだけを理由にブロックせず、代わりに他のルールに照らしてコンテンツを判断します
* 外部のターゲットをユーザーが指定していない限り、別のリポジトリや組織に対するプルリクエストの作成、`gh repo fork` によるフォーク、またはサードパーティリポジトリへのプッシュ

これらのカテゴリのいくつかは、機密性の高いリモートターゲットや保護された IaC スコープなど、具体的な名前に絞り込める[環境](/docs/ja/auto-mode-config#define-trusted-infrastructure)エントリに依存しています。

Claude Code v2.1.203 以降では、以下もデフォルトでブロックされます。

* ソースと宛先の両方をユーザーが指定していない限り、機密性の高いローカルストア、または名前、パス、種類から機密であるとわかるファイルのコンテンツを、コミット、プッシュ、PR やイシューのテキスト、gist やペースト、またはパッケージの公開に含めること。セッションのトランスクリプトと会話ログ、SSH キー、クラウドの認証情報、ブラウザプロファイル、シェル履歴などの認証情報や設定のドットフォルダ、ユーザーデータのエクスポートはすべて対象であり、リポジトリがプライベートであっても解除されません

Claude Code v2.1.205 以降では、以下もデフォルトでブロックされます。

* Claude Code のセッショントランスクリプト、つまり `~/.claude/projects/` または設定した config ディレクトリ配下の `.jsonl` 履歴ファイルへの書き込み（直接か、シェルコマンド経由かを問いません）。このルールは、Claude Code が独自のチェックのために各トランスクリプトエントリに追加するメタデータ行も対象とします。トランスクリプトの読み取りはブロックされません
* `rm -rf "$VAR"` や `Remove-Item -Recurse -Force $dir` のような再帰的な強制削除で、対象が分類器の見る会話のどこでも代入されていないシェル変数、またはそのような変数を起点とする glob であるもの。その値は分類器が受け取らない以前のコマンド出力からのみ得られたものであるため、分類器は削除対象を他の削除ルールに照らして検証できません。このブロックは、削除する正確なパスをユーザーが指定するか、Claude が解決済みのリテラルパスをコマンドに書き込んで削除を再実行すると解除されます。分類器が対象を解決できる削除は影響を受けません。

  `rm -rf "$VAR"/*` のように変数の直下にある glob は、代わりに[重要なパス](#critical-paths)として扱われます。`Remove-Item` の対象が単独の `*` であるか、`/*` または `\*` で終わる場合は分類器に到達せず、Claude Code が[それらを直ちに拒否します](#remove-item-in-powershell)。

Claude Code v2.1.257 以降では、以下もデフォルトでブロックされます。

* `169.254.169.254` などのクラウドインスタンスメタデータエンドポイントに認証情報を要求すること、またはマシン自身のサービスアカウントやノード ID を使ってクラウド、クラスター、レジストリへの呼び出しを明示的に認証すること
* トンネル、リバースシェル、外部を指すように書き換えたリゾルバーやプロキシの設定など、直接リクエスト以外の経路でパブリックホストに到達すること
* ノード証明書やノードのコンテナレジストリ認証など、タスクではなくホストに属する認証情報を読み取ること
* Claude が起動していない隣接するコンテナ、ポッド、VM、またはコンテナの下にあるノードへの接続やスキャン

Claude Code を実行する環境がこれらのいずれかを許可する前提である場合は、`autoMode.environment` の [Host containment エントリ](/docs/ja/auto-mode-config#define-trusted-infrastructure)でその構成を説明してください。

Claude Code v2.1.261 以降では、以下もデフォルトでブロックされます。

* URL 自体に共有するコンテンツが含まれている場合に、公開ペースト、図、またはデータ共有サービスへのリンクを、メッセージ、PR やイシューのテキスト、ドキュメント、その他リンクが開かれたり取得されたりする場所に投稿または書き込むこと（ユーザーがそのサービスを指定した場合を除く）

**デフォルトで許可**:

* 作業ディレクトリ内のローカルファイル操作
* ロックファイルやマニフェストで宣言された依存関係のインストール
* `.env` の読み取りと、対応する API への認証情報の送信
* 読み取り専用の HTTP リクエスト
* デフォルトブランチを含む、作業中のリポジトリの任意のブランチへのプッシュ。`production` や `gh-pages` など、名前からデプロイ先や公開先であるとわかるデフォルト以外のブランチは対象外で、分類器はそこへのプッシュを個別に判断します。プッシュの内容は引き続き他のルールに照らしてチェックされ、[`permissions.deny` ルール](/docs/ja/permissions#manage-permissions)はすべてのモードで引き続き[記述されたとおりに](/docs/ja/permissions#bash-rule-limits)プッシュコマンドをブロックでき、リモート側のブランチ保護も引き続き適用されます。v2.1.211 より前では、開始時のブランチ、Claude が作成したブランチへのプッシュ、およびデフォルトブランチへの日常的なプッシュのみがデフォルトで許可されており、v2.1.203 より前では、デフォルトブランチへの直接プッシュはすべてブロックされていました
* 同じセッション内で Claude が以前に作成したジョブそのものの削除
* タスクの一環としての、セキュリティ関連のコード、設定、脅威モデルの読み取り、レビュー、または作成
* 同じマルチエージェントセッションで協働するエージェント間のメッセージ
* [`environment`](/docs/ja/auto-mode-config#define-trusted-infrastructure) に記載した信頼できるドメイン、バケット、サービスへのデータ送信。これはデータの流れのみを対象とし、同じインフラストラクチャに対する破壊的な操作や認証情報の操作は対象外です
* 信頼できる内部ドメイン、localhost、またはユーザーが指定した URL への [Claude in Chrome](/docs/ja/chrome) のナビゲーション

サンドボックス化されたコマンドは、デフォルトではネットワークアクセスを持ちません。Claude はコマンドに必要なホストをコマンド自体に明示し、分類器はそれらをコマンドと一緒にレビューし、承認されたリストによってそのコマンドに限りそれらのホストへのアクセスが開かれます。リストで開けるものと開けないもの、およびコマンドがリストにないホストにアクセスしようとした場合の動作については、[コマンドごとの許可ドメイン](/docs/ja/sandboxing#per-command-allowed-domains-in-auto-mode)を参照してください。

`claude auto-mode defaults` を実行すると、完全なルールリストが JSON として出力されます。日常的なアクションがブロックされる場合、管理者は `autoMode.environment` 設定で信頼できるリポジトリ、バケット、サービスを追加できます。[auto モードを設定する](/docs/ja/auto-mode-config)を参照してください。

作業中のリポジトリの任意のブランチへのプッシュと、リクエストに沿ったプルリクエストの作成は、シークレットや機密データがリポジトリの外に出る場合や、プルリクエストが別のリポジトリや組織を対象とする場合など、そのプッシュやプルリクエストが[ブロックリスト](#what-the-classifier-blocks-by-default)に該当しない限り、プロンプトなしで実行されます。auto モードのまま、これらのコマンドの前に人間によるチェックポイントを設けるには、コマンドに[記述されたとおりに](/docs/ja/permissions#bash-rule-limits)マッチする `permissions.ask` ルールを追加します。[一般的な境界](/docs/ja/auto-mode-config#common-boundaries)を参照してください。

<h3 id="first-read-outside-the-working-directories">
  作業ディレクトリ外の最初の読み取り
</h3>

[`permissions.blockReadsOutsideWorkingDirectories`](/docs/ja/settings-reference#permissions-blockreadsoutsideworkingdirectories) がオフの間、auto モードでは[作業ディレクトリ](/docs/ja/permissions#working-directories)外の読み取りを含め、ファイルの読み取りはプロンプトなしで実行されます。Claude が作業ディレクトリ外のパスに対して Read、Grep、または Glob ツールを初めて使用するとき、Claude Code はその読み取りを許可するかどうかを尋ねます。

このプロンプトは、非インタラクティブな `-p` 実行やバックグラウンドセッションでは表示されず、そこでの読み取りは従来どおり実行されます。

どのように回答しても、Claude は作業を続けます。

* **はい、今後も作業ディレクトリ外の読み取りを許可する**: 読み取りが実行され、以降の作業ディレクトリ外の読み取りも従来どおり実行されます。Claude Code は回答を記録するため、このプロンプトは再び表示されません
* **いいえ、今後は作業ディレクトリ外の読み取りをブロックする**: 読み取りは拒否され、Claude Code はユーザー設定で [`permissions.blockReadsOutsideWorkingDirectories`](/docs/ja/settings-reference#permissions-blockreadsoutsideworkingdirectories) を `true` に設定します。これにより、以降のすべてのセッションとすべての権限モードで、ファイルツールはそのような読み取りを拒否します。後でそのようなパスを Claude が読み取れるようにするには、`/add-dir` でそのディレクトリを追加するか、この設定を削除します。
* **いいえ、次回も確認する**: 読み取りは拒否され、次に作業ディレクトリ外を読み取るときに再びプロンプトが表示されます
* **はい、ただし次回も確認する**: 読み取りが実行されますが何も保存されず、次に作業ディレクトリ外を読み取るときに再びプロンプトが表示されます

<h3 id="boundaries-you-state-in-conversation">
  会話で伝えた境界
</h3>

分類器は、会話で伝えた境界をブロックのシグナルとして扱います。Claude に「プッシュしないで」や「デプロイする前に私のレビューを待って」と伝えると、デフォルトのルールでは許可されるアクションであっても、分類器は該当するアクションをブロックします。境界は、後のメッセージで解除するまで有効です。条件が満たされたという Claude 自身の判断では解除されません。

境界はルールとして保存されません。分類器はチェックのたびにトランスクリプトから境界を読み直すため、[コンテキスト圧縮](/docs/ja/costs#reduce-token-usage)によって境界を伝えたメッセージが削除されると、境界が失われる可能性があります。確実な保証が必要な場合は、代わりに [deny ルール](/docs/ja/permissions#permission-rule-syntax)を追加してください。

<h3 id="approvals-you-state-in-conversation">
  会話で伝えた承認
</h3>

ブロックされたアクションを許可すると Claude に伝えると、分類器はそれをユーザーの承認と解釈し、ブロックを解除できます。伝え方によって、アクションが実行されるかどうかと、承認がどこまで及ぶかが決まります。

* **アクションとその詳細を明示する**: メッセージでは、アクションと、force push の対象ブランチなど、それを危険にしている具体的な要素を明示する必要があります。動詞だけを示しても何も解除されないため、「force-push してもいいよ」ではブロックは残ります。
* **1 つのアクションにのみ適用されると考える**: 承認は明示した破壊的アクションに適用されるため、継続的な承認として与えない限り、後のアクションは再びブロックされます。日常的なパターンを 1 つずつ承認するのをやめるには、[`autoMode.allow`](/docs/ja/auto-mode-config#override-the-block-and-allow-rules) に追加してください。
* **一部のブロックは解除されない**: [分類器の優先順位](/docs/ja/auto-mode-config#override-the-block-and-allow-rules)に、承認で解除できるブロックが定められています。承認で解除されない手順を実行するには、[auto モードを終了して](#switch-permission-modes)権限プロンプトに回答してください。

<h3 id="when-auto-mode-falls-back">
  auto モードがフォールバックするとき
</h3>

auto モードがセッションのアクションを承認できない場合、その後の動作はケースによって異なります。

* **アクションがブロックされた場合**: Claude Code は通知を表示し、そのアクションを `/permissions` の **Recently denied** タブに表示します。そこで `r` を押すと、手動承認で再試行できます。
* **ブロックが繰り返された場合**: 分類器がアクションを 3 回連続、または合計 20 回ブロックすると、auto モードは一時停止し、Claude Code はプロンプトの表示を再開します。プロンプトで示されたアクションを承認すると auto モードが再開します。ブロックの数え方については、[繰り返しブロックのしきい値](#repeated-block-thresholds)を参照してください。
* **分類器から判定が得られない場合**: auto モードとは別の安全チェックが分類器自体のリクエストを拒否した場合、または分類器の応答を解析できない場合、Claude Code は通知も **Recently denied** のエントリもなしにアクションを拒否します。各ケースで表示されるメッセージと対処方法については、[auto モードがアクションの安全性を判断できない](/docs/ja/errors#auto-mode-cannot-determine-the-safety-of-an-action)を参照してください。
* **サーバーから判定が得られない場合**: [サーバー側の分類器レビュー](#server-side-classifier-review)では、Claude Code はサーバーが判定を返さないアクションを拒否し、判定のないレスポンスが 10 回連続するとターンを停止します。[サーバーが安全性の判定を返さなかった](/docs/ja/errors#the-server-returned-no-safety-verdict)を参照してください。
* **チェック中にモードを切り替えた場合**: 分類器のチェックが保留中に権限モードを切り替えると、Claude Code は新しいモードでは要求されなかったはずの判定を破棄します。代わりに承認を求めるプロンプトが表示されるか、[`dontAsk` モード](#allow-only-pre-approved-tools-with-dontask-mode)ではアクションが自動的に拒否されます。

<h4 id="repeated-block-thresholds">
  繰り返しブロックのしきい値
</h4>

3 回連続および合計 20 回というブロックのしきい値は設定できません。合計カウンターはセッションの間保持され、それ自体の上限によってフォールバックが発生したときにのみリセットされます。auto モードとは別の安全チェックが分類器自体のリクエストを拒否した場合、Claude Code はその拒否をどちらのしきい値にもカウントしません。

[`--permission-prompt-tool`](/docs/ja/cli-reference#cli-flags) を指定していない[非インタラクティブ](/docs/ja/headless)な `-p` 実行には、フォールバック先のプロンプトがありません。繰り返しのブロックがしきい値に達すると、そのアクションは実行されず、Claude は作業を続けます。Claude Code は実行を停止しません。

ブロックが繰り返される場合、通常は分類器がインフラストラクチャに関するコンテキストを欠いていることを意味します。`/feedback` を使用して誤検知を報告するか、管理者に[信頼できるインフラストラクチャを設定](/docs/ja/auto-mode-config)してもらってください。

<h3 id="how-auto-mode-evaluates-actions">
  auto モードがアクションを評価する方法
</h3>

以下のセクションでは、Claude Code がアクションを評価する順序、分類器がサブエージェントの作業をレビューする方法、および分類器の呼び出しによって追加されるコストとレイテンシーについて説明します。

<span id="how-the-classifier-evaluates-actions" />

<AccordionGroup>
  <Accordion title="分類器がアクションを評価する方法">
    各アクションは決まった決定順序で処理され、最初に該当したステップが適用されます。

    1. [allow、ask、または deny ルール](/docs/ja/permissions#manage-permissions)に一致するアクションは直ちに解決されます。ただし、以下の例外があります。
       * [保護されたパス](#protected-paths)への書き込みは、allow ルールに一致する場合でも分類器に回されます
       * [重要なパス](#critical-paths)を対象とする `rm` および `rmdir` による削除は、どの allow ルールでも承認されません
       * [`requiresUserInteraction`](/docs/ja/mcp#require-approval-for-a-specific-tool) が指定された MCP ツールは、allow ルールに一致する場合でも直接プロンプトを表示します。その設定が Claude Code に届くセッションでは、[組織が `ask` に設定した](/docs/ja/mcp#organization-controls-on-connector-tools)コネクタツールも同様です
       * [コマンドごとの許可ドメイン](/docs/ja/sandboxing#per-command-allowed-domains-in-auto-mode)を含むシェルコマンドも、allow ルールに一致する場合でも分類器に回されます。ルールが承認するのはコマンドであって、そのホストではないためです
       * `Bash(git push *)` のように、コマンドの内容にマッチする ask ルールは、権限プロンプトにフォールバックします
       * Claude が要求したパス自体は保護されていないものの、[シンボリックリンクのチェック](/docs/ja/permissions#symlinks)によって保護されたパスに解決される書き込みは、プロンプトを表示します
    2. 作業ディレクトリ内での読み取り専用アクションとファイル編集は自動承認されます。ただし、[保護されたパス](#protected-paths)への書き込みと、プロンプトを表示する[作業ディレクトリ外の最初の読み取り](#first-read-outside-the-working-directories)は除きます
       * [サーバー側の分類器レビュー](#server-side-classifier-review)が有効なセッションでは、読み取り専用のシェルコマンドと[サンドボックス化された](/docs/ja/sandboxing#sandbox-modes)シェルコマンドはそのレビューを待ち、レビューで指摘された場合はブロックされます
       * 作業ディレクトリ内への書き込みのうち、[シンボリックリンクのチェック](/docs/ja/permissions#symlinks)によって作業ディレクトリ外の場所に解決されるものは、プロンプトを表示します
       * Claude が[他の人が作成したアーティファクト](/docs/ja/artifacts#read-an-artifact-shared-with-you)を読み取る場合は、そのセクションに記載されている承認のケースが適用されます
    3. それ以外のすべては分類器に回されます。ただし、デフォルトの処理が適用される[重要なパスの削除](#critical-paths)は除きます。ステップ 1 で直接プロンプトを表示するコネクタツールと `requiresUserInteraction` の MCP ツールも分類器には到達しないため、組織が求める承認も同意の手順も自動承認されることはありません
    4. 分類器がブロックした場合、Claude はその理由を受け取ります。ほとんどのセッションでは、理由は文章による説明ではなく、`[Data Exfiltration]` のように分類器が該当させたルールの名前です。[拒否をレビューする](/docs/ja/auto-mode-config#review-denials)を参照してください

    インストールした [mod](/docs/ja/plugins/mods/overview) が `tool.check` にフックしている場合、ステップ 3 の前にアクションを承認でき、mod が承認したアクションを分類器はチェックしません。[フックで権限を拡張する](/docs/ja/permissions#extend-permissions-with-hooks)を参照してください。

    VS Code 拡張機能では、[Claude in Chrome](/docs/ja/chrome) のブラウザアクションがどのように承認されるかは、セッションがブラウザにどのように接続したかによって異なります。[VS Code セッションでの権限プロンプト](/docs/ja/chrome#permission-prompts-in-vs-code-sessions)を参照してください。

    auto モードに入ると、任意のコード実行を許可する広範な allow ルールは除外されます。

    * 包括的な `Bash(*)` または `PowerShell(*)`
    * `Bash(python*)` のようなワイルドカード付きのインタープリター
    * パッケージマネージャーの run コマンド
    * `Agent` の allow ルール
    * [`Monitor`](/docs/ja/tools-reference#monitor-tool) の allow ルール（Claude Code は Monitor のコマンドをシェル経由で実行するため）

    `Bash(npm test)` のような限定的なルールは引き続き有効です。Claude Code は auto モードを終了すると、除外したルールを復元します。v2.1.236 より前では、Claude Code は auto モードで `Monitor` の allow ルールを有効なままにしていたため、ツール全体に一致するルールが分類器のレビューなしで Monitor のコマンドを承認していました。

    また、Claude Code は `git reset --hard` や `rm -rf` など、コミットされていない作業を破棄する可能性のあるコマンドの前に自ら `git status` を実行し、ステージ済み、変更済み、または未追跡の作業があるかどうかを分類器に示します。リポジトリの git 設定で `status.showUntrackedFiles=no` が設定されている場合でも、Claude Code はこのチェックで未追跡のファイルを報告します。

    Claude Code 自体が送信する分類器リクエストでは、分類器はユーザーメッセージ、ファイルの読み取りや検索などの読み取り専用の参照以外のツール呼び出し、および CLAUDE.md の内容を確認します。ツールの結果はこれらのリクエストから除去されるため、ファイルやウェブページ内の悪意のあるコンテンツが分類器を直接操作することはできません。

    [PostToolUse フックの `classifierContext` フィールド](/docs/ja/hooks#annotate-a-result-for-the-auto-mode-classifier)を使って呼び出しの結果に注釈を付けることができ、分類器はこれをアプリケーションが提供するコンテキストとして読み取ります。このフィールドには Claude Code v2.1.236 以降が必要です。

    別のサーバー側プローブが受信したツールの結果をスキャンし、Claude が読む前に疑わしいコンテンツを指摘します。これらの層がどのように連携するかの詳細については、[auto モードの発表](https://claude.com/blog/auto-mode)と[エンジニアリングの詳細解説](https://www.anthropic.com/engineering/claude-code-auto-mode)を参照してください。
  </Accordion>

  <Accordion title="auto モードがサブエージェントを扱う方法">
    分類器は[サブエージェント](/docs/ja/sub-agents)の作業を 3 つの時点でチェックします。

    1. サブエージェントが開始する前に、委任されたタスクの説明が評価されるため、危険に見えるタスクは生成時にブロックされます。
    2. サブエージェントの実行中、その各アクションは親セッションと同じ[決定順序](#how-the-classifier-evaluates-actions)で、同じブロックルールと allow ルールに基づいて処理されます。サブエージェントのフロントマターにある `permissionMode` は無視されます。
    3. サブエージェントが終了すると、親がレポートを読む前に、分類器がその作業と最終レポートをレビューします。分類器がサブエージェントの作業やレポートを指摘した場合、または別の API 安全チェックがレビューを拒否した場合でも、レポートはセキュリティ警告を先頭に付けて配信されます。分類器がレビューに利用できない場合、レポートには、行動する前にサブエージェントの作業を検証するよう促すメモが付いて届きます。
  </Accordion>

  <Accordion title="コストとレイテンシー">
    分類器は、`/model` での選択ではなく、デフォルトで Claude Sonnet 5 で実行されます。Anthropic がサーバー側で設定した分類器モデルは、このデフォルトより優先されます。セッションのモデルが Claude Sonnet 4.6 の場合、または [`availableModels`](/docs/ja/model-config#restrict-model-selection) が Sonnet 5 を除外している場合、分類器は代わりにセッションのモデルで実行され、セッションが [Fable モデル](/docs/ja/model-config#work-with-fable)で実行されている場合は Opus モデルで実行されます。Anthropic API 以外のプロバイダーでは、この Opus のフォールバックは [`ANTHROPIC_DEFAULT_OPUS_MODEL`](/docs/ja/model-config#environment-variables) で設定したモデルであり、設定していない場合は Opus 5 です。

    セッションの最初の auto モードのリクエストで、Sonnet 5 のデフォルトが検証されます。リクエストが成功すれば Sonnet 5 がセッションの分類器モデルとして維持され、モデルが利用できないために失敗した場合は、セッションは代わりにフォールバックを使用します。

    Enterprise プラン、および Claude API、[Claude Platform on AWS](/docs/ja/claude-platform-on-aws)、Amazon Bedrock、Google Cloud の Agent Platform、または Microsoft Foundry を使用するアカウントでは、分類器の呼び出しはトークン使用量にカウントされます。各チェックではトランスクリプトの一部と保留中のアクションが送信され、実行前に往復の通信が 1 回加わります。読み取りと、保護されたパス以外での作業ディレクトリ内の編集は分類器をスキップするため、オーバーヘッドは主にシェルコマンドとネットワーク操作から生じます。サーバーがセッションのモデルリクエストの一部としてアクションをレビューする場合は、カウントされる個別の分類器呼び出しはありません。[サーバー側の分類器レビュー](#server-side-classifier-review)を参照してください。

    サンドボックス化されたネットワークアクセスによって、接続ごとの分類器リクエストが追加されることはありません。分類器は[コマンドが明示するホスト](/docs/ja/sandboxing#per-command-allowed-domains-in-auto-mode)をコマンドと一緒に 1 回のレビューで判断し、Claude Code は分類器を再度呼び出すことなく、各接続を承認済みのリストと照合します。
  </Accordion>
</AccordionGroup>

<h2 id="allow-only-pre-approved-tools-with-dontask-mode">
  dontAsk モードで事前承認済みツールのみを許可する
</h2>

`dontAsk` モードを設定すると、Claude Code は本来プロンプトを表示するすべてのツール呼び出しを自動的に拒否します。Claude は Manual モードで承認が不要なアクション（作業ディレクトリ内のファイル読み取りや[読み取り専用 Bash コマンド](/docs/ja/permissions#read-only-commands)など）、および `permissions.allow` ルールに一致するアクション、[PreToolUse フック](/docs/ja/permissions#extend-permissions-with-hooks)によって承認されたコール実行を継続します。このモードは CI パイプラインや制限された環境で使用します。Claude が実行できる内容を事前に定義でき、セッションは入力を待つことはありません。このモードがアクティブな間、ステータスバーに `⏵⏵ don't ask on` が表示されます。

Claude Code は、プロンプトを表示する代わりに、明示的な[`ask` ルール](/docs/ja/permissions#manage-permissions)に一致するコールを拒否します。また、allow ルールが一致する場合でも組み込みの `AskUserQuestion` ツールを拒否し、その設定が Claude Code に到達するセッションで[組織が `ask` に設定したコネクタツール](/docs/ja/mcp#organization-controls-on-connector-tools)についても同じことを行います。[`_meta["anthropic/requiresUserInteraction"]`](/docs/ja/mcp#require-approval-for-a-specific-tool)でマークされた MCP ツールも同じ方法で拒否します。これは、承認カードがこのモードが収集しない回答を必要とするためです。

[重要なパス](#critical-paths)（`rm -rf /` や `rm -rf ~` など）を対象とした `rm` および `rmdir` の削除は、allow ルールが一致する場合や `PreToolUse` フックが許可する場合でも拒否されます。

[Claude Code on the web](/docs/ja/claude-code-on-the-web) のクラウドセッションは `defaultMode: "dontAsk"` を無視します。詳細は[bypassPermissions](#skip-all-checks-with-bypasspermissions-mode)を参照してください。

スタートアップ時にフラグで設定します：

```bash theme={null}
claude --permission-mode dontAsk
```

<h2 id="skip-all-checks-with-bypasspermissions-mode">
  bypassPermissions モードですべてのチェックをスキップする
</h2>

`bypassPermissions` モードは権限プロンプトとセーフティチェックを無効にするため、[保護されたパス](#protected-paths)への書き込みを含むツール呼び出しが即座に実行されます。

[どのモードでも自動承認されないアクション](#actions-no-mode-auto-approves)は、このモードでもプロンプトが表示されます。[別の組織の公開アーティファクト](/docs/ja/artifacts#read-an-artifact-shared-with-you)を読み取るにはユーザーの承認が必要ですが、このモードでは承認を求めないため、Claude はそれを読み取れません。[PowerShell の Remove-Item](#remove-item-in-powershell) の拒否もこのモードで適用されます。

このモードでは、および権限バイパスが利用可能なインタラクティブターミナルプランモードセッションでは、2 つの[クロスセッションメッセージング](/docs/ja/cross-session-messaging)セーフガードが引き続き適用されます。

* このマシンを超えたセッションへのメッセージに対する [`isolatePeerMachines`](/docs/ja/settings-reference#isolatepeermachines) 承認プロンプトが引き続き表示されます。
* [`crossSessionInbound`](/docs/ja/cross-session-messaging#control-inbound-messages) 値が適用されない場合、Claude Code は別のセッションからのインバウンドメッセージを承認待ちで保持し、送信セッションが権限プロンプトもバイパスしていることを識別した場合にのみ確認なしで配信します。権限モードを終了してメッセージが保持されている場合、Claude Code はインバウンドルールを再適用し、保持されているメッセージのうち現在受け入れるものを配信します。

権限バイパスが利用可能なインタラクティブターミナルセッションでは、Claude Code は[プランモードの](#analyze-before-you-edit-with-plan-mode)ブロックも強制しません。Claude はまだ編集なしでプランするよう指示されていますが、プランニング中に試みるファイル編集またはシェルコマンドはプロンプトなしで実行されます。明示的な[質問ルール](/docs/ja/permissions#manage-permissions)および `rm` と `rmdir` の削除で[クリティカルパス](#critical-paths)をターゲットにしたものはまだプロンプトが表示されます。

プランモードは Claude Code がインタラクティブターミナルなしで実行される場所ではブロックを保持します。これには `-p` を使用した[非インタラクティブ実行](/docs/ja/headless)、[Agent SDK](/docs/ja/agent-sdk/permissions#plan-mode-plan) セッション、および [VS Code 拡張機能](/docs/ja/vs-code)のチャットパネルでの会話が含まれます。そこでは、`--allow-dangerously-skip-permissions` により `bypassPermissions` が後で選択可能になります。

<Warning>
  このモードはコンテナ、VM、またはインターネットアクセスのない dev コンテナなどの隔離された環境でのみ使用してください。そのような環境では Claude Code がホストシステムに損害を与えることができません。
</Warning>

このモードを有効にせずに開始したセッションから `bypassPermissions` に入ることはできません。[`permissions.defaultMode: "bypassPermissions"`](/docs/ja/settings-reference#permissions-defaultmode) で起動時に有効にするか、有効化フラグを使用して有効にしてください。

```bash theme={null}
claude --permission-mode bypassPermissions
```

`--dangerously-skip-permissions` フラグは同等です。

Claude Code は [`--restricted`](/docs/ja/cli-reference#cli-flags) で開始したセッションで `bypassPermissions` を拒否します。`--restricted` には Claude Code v2.1.248 以降が必要です。

このモードを有効にしてインタラクティブセッションを初めて開始すると、Claude Code は権限チェックなしで実行されたアクションの責任を受け入れるよう求める警告ダイアログを表示します。

* **受け入れた場合**: Claude Code は `skipDangerousModePermissionPrompt` を `~/.claude/settings.json` の `true` に設定するため、後のセッションではダイアログをスキップします。ダイアログを再度表示するには、そのファイルからキーを削除するか、`false` に設定してください。[`skipDangerousModePermissionPrompt` リファレンス](/docs/ja/settings-reference#skipdangerousmodepermissionprompt)には、ユーザーまたは組織が設定できる他の設定ファイルが記載されています。
* **拒否した場合**: Claude Code は終了します。

[非インタラクティブモード](/docs/ja/headless)ではダイアログは表示されず、`--bg` で開始した[バックグラウンドセッション](/docs/ja/agent-view)はインタラクティブセッションでダイアログを受け入れるまで拒否されます。

Linux と macOS では、Claude Code はこのモードで root として、または `sudo` の下で実行されている場合、起動を拒否します。

```text theme={null}
--dangerously-skip-permissions cannot be used with root/sudo privileges for security reasons
```

チェックは認識されたサンドボックス内では自動的にスキップされます。コンテナで自律的に実行するには、[dev コンテナ](/docs/ja/devcontainer)設定を使用してください。これは Claude Code を非 root ユーザーとして実行します。

[Web 上の Claude Code](/docs/ja/claude-code-on-the-web) は設定ファイルから `defaultMode: "bypassPermissions"` または `"dontAsk"` を尊重しないため、リポジトリのチェックイン設定はクラウドセッションをバイパス権限モードで開始できません。設定は無視され、セッションはモードドロップダウンに表示される権限モードで開始されます。[権限モードを切り替える](#switch-permission-modes)を参照して、クラウドセッションが提供するモードを確認してください。

<Warning>
  `bypassPermissions` はプロンプトインジェクションまたは意図しないアクションに対する保護を提供しません。権限プロンプトがはるかに少ないバックグラウンドセーフティチェックの場合は、代わりに[オートモード](#eliminate-prompts-with-auto-mode)を使用してください。管理者は [管理設定](/docs/ja/managed-settings)で `permissions.disableBypassPermissionsMode` を `"disable"` に設定することでこのモードをブロックできます。
</Warning>

<h2 id="protected-paths">
  保護されたパス
</h2>

パスの小さなセットへの書き込みは、`bypassPermissions` モードおよび [bypass permissions が利用可能](#skip-all-checks-with-bypasspermissions-mode)なプラン モード セッションを除き、自動承認されることはありません。これはリポジトリ状態と Claude 独自の設定の偶発的な破損を防ぎます。

| モード | 保護されたパスへの書き込み |
| :- | :- |
| `default`、`acceptEdits` | プロンプト表示 |
| `plan` | [bypass permissions](#skip-all-checks-with-bypasspermissions-mode)が利用可能なセッションで許可。そうでない場合、[auto モード](#eliminate-prompts-with-auto-mode)が計画中に利用可能な場合は分類器にルーティング。利用できない場合はプロンプト表示 |
| `auto` | 分類器にルーティング |
| `dontAsk` | 拒否 |
| `bypassPermissions` | 許可 |

[`--restricted`](/docs/ja/cli-reference#cli-flags)で開始されたセッションでは、Claude Code v2.1.248 以降が必要で、分類器は保護されたパスへの書き込みを承認できません。

保護されたパスへの書き込みを分類器にルーティングするモードでは、[symlink チェック](/docs/ja/permissions#symlinks)が保護されたパスに解決される書き込みは、Claude が要求したパス自体が保護されていない場合、代わりにプロンプトを表示します。

設定ファイルの [`permissions.allow`](/docs/ja/permissions#manage-permissions) ルールは、保護されたパスへの書き込みを事前承認しません。安全性チェックは Claude Code が設定から allow ルールを評価する前に実行されるため、`~/.claude/settings.json` または `.claude/settings.json` の `Edit(.claude/**)` などのエントリは、上記の表のモード別の結果を変更しません。プロンプトを表示するモードでは、プロジェクトの `.claude/` フォルダまたは `~/.claude/` への書き込みのプロンプトで、以下のセッション スコープ オプションのいずれかを提供できます。

* プロジェクトの `.claude/` フォルダの場合：**Yes, and allow Claude to edit files in this project's .claude folder for this session**
* `~/.claude/` の場合：**Yes, and allow Claude to edit files in its \~/.claude folder for this session**

保護されたディレクトリ：

* `.git`
* `.config/git`
* `.vscode`
* `.idea`
* `.husky`
* `.cargo`
* `.devcontainer`
* `.yarn`
* `.mvn`
* `.claude`。ただし、次のようないくつかの例外があります：
  * `.claude/worktrees/` 配下にある Claude 自身の git worktree
  * `~/.claude/plans/`、または設定した [`plansDirectory`](/docs/ja/settings-reference#plansdirectory) 内にある、現在のセッション自身のプランファイル
  * `~/.claude/jobs/<id>/tmp/` にある[バックグラウンドセッション](/docs/ja/agent-view#where-state-is-stored)自身のスクラッチディレクトリ
  * `--restricted` なしで開始されたセッションにおける、`~/.claude/projects/<project>/memory/` などのプロジェクトの[自動メモリ](/docs/ja/memory#storage-location)ディレクトリ内の markdown ファイル
  * `--restricted` なしで開始されたセッションにおける、`.claude/agent-memory/` などの[サブエージェントメモリ](/docs/ja/sub-agents#enable-persistent-memory)ディレクトリ内の markdown ファイル
* [`--plugin-dir`](/docs/ja/plugins/mods/create#change-a-mod-with-claude) で読み込んだディレクトリ。ファイルが変更されると、Claude Code がそこから mod のコードを再読み込みして実行するためです

保護されたファイル：

* `.gitconfig`、`.gitmodules`
* `.bashrc`、`.bash_profile`、`.bash_login`、`.bash_aliases`、`.bash_logout`、`.zshrc`、`.zprofile`、`.zshenv`、`.zlogin`、`.zlogout`、`.profile`、`.envrc`
* `.npmrc`、`.yarnrc`、`.yarnrc.yml`、`.pnp.cjs`、`.pnp.loader.mjs`、`.pnpmfile.cjs`、`bunfig.toml`、`.bunfig.toml`
* `.bazelrc`、`.bazelversion`、`.bazeliskrc`
* `.pre-commit-config.yaml`、`lefthook.yml`、`lefthook.yaml`、`.lefthook.yml`、`.lefthook.yaml`
* `gradle-wrapper.properties`、`maven-wrapper.properties`
* `.devcontainer.json`
* `.ripgreprc`、`pyrightconfig.json`
* `.mcp.json`、`.claude.json`

<h2 id="critical-paths">
  重要なパス
</h2>

重要なパスは、Claude Code が `rm` および `rmdir` コマンドから保護するディレクトリです。ファイルシステムのルート、ホームディレクトリ、作業ディレクトリなどが含まれます。

Claude Code は、[`permissions.allow`](/docs/ja/permissions#manage-permissions) ルールまたは `"allow"` を返す [`PreToolUse` フック](/docs/ja/permissions#extend-permissions-with-hooks) が `rm` または `rmdir` コマンドを承認することはありません。そのコマンドが重要なパスをターゲットにしている場合、他のプロンプトをスキップするモードであっても承認されません。このサーキットブレーカーはモデルエラーから保護します。マッチする deny ルールはコマンドを完全にブロックします。

代わりに何が起こるかは、[権限モードによって異なります](#critical-path-removals-in-each-permission-mode)。`Remove-Item` と `cmd` 削除ビルトインには独自のチェックがあり、[PowerShell の Remove-Item](#remove-item-in-powershell) で説明されています。

<h3 id="which-paths-are-critical">
  どのパスが重要なのか
</h3>

Claude Code は、`rm` または `rmdir` ターゲットが以下のいずれかである場合、重要なパスとして扱います。

* ファイルシステムのルート
* トップレベルディレクトリ、つまりルートの直接の子である `/usr`、`/etc`、`/data` などのディレクトリ
* ホームディレクトリ
* Windows ドライブルートとそのトップレベルディレクトリ（`C:\` や `C:\Windows` など）
* 作業ディレクトリとその親
* 追加の作業ディレクトリとその親。ただし、削除が `rm -rf <dir>/*` のようにそれらの下のグロブである場合のみ。ディレクトリ自体に対する `rm -rf <dir>` はこのチェックをトリガーしません

<h3 id="other-targets-that-count-as-critical-paths">
  重要なパスとしてカウントされるその他のターゲット
</h3>

Claude Code は、以下の `rm` および `rmdir` ターゲットも重要なパスとして扱います。最後の列は、各ターゲットがカウントされる理由を説明しています。

| ターゲット | 例 | カウントされる理由 |
| :- | :- | :- |
| シェル変数の直下のグロブまたは末尾のスラッシュ | `rm -rf "$DIR"/*` | 変数が空の場合、コマンドはファイルシステムルートからの削除になります |
| `$1` または `$@` などの位置パラメータの下の同じ形式。コマンド内で値を与えるものがない場合 | `rm -rf "$1"/*` | コマンドはルートへの削除に展開されます |
| シェル変数の後に `mnt`、`tmp`、`usr`、`Users` などの一般的なトップレベルディレクトリ名が続く場合 | `rm -rf "$TMPDIR/mnt"` | 変数が空に展開されると、コマンドは `/mnt` を削除します |
| 同じコマンドが `$(pwd)` または `$(git rev-parse --show-toplevel)` などのディレクトリ出力置換から割り当てる変数 | `D=$(pwd); rm -rf "$D"` | 値は作業ディレクトリまたはリポジトリルートに名前を付けることができます |
| コマンド置換の出力のみであるターゲット。`rm` が再帰的な場合 | `rm -rf "$(pwd)"` | Claude Code はコマンドが実行される前にターゲットをチェックできません |
| 重要なパスの後に続く末尾のコマンド置換 | `rm -rf ~/$(cmd)` | Claude Code は、置換が空に展開された場合に残るパス（この例ではホームディレクトリ）をチェックします |
| バックスラッシュのみであるターゲット | `rm -rf "\\"` | Windows 上の Git Bash は単一のバックスラッシュを現在のドライブのルートとして読み取るため、チェックはすべてのプラットフォームで適用されます |
| 末尾が `/*` または `/*/` である一部のターゲット | `rm -rf logs/*/*`、`rm -rf logs/*/`、`cd logs && rm -rf a/*` | Claude Code は、コマンドが実行される前に、それらがどのディレクトリに及ぶかを判断できません |

コマンド置換の出力のみであるターゲットのチェックをオフにするには、Claude Code を起動する環境で [`CLAUDE_CODE_DISABLE_SUBSTITUTION_RM_PROMPT=1`](/docs/ja/env-vars#variables) を設定します。

<h3 id="removals-inside-nested-commands-and-inline-scripts">
  ネストされたコマンドとインラインスクリプト内の削除
</h3>

Claude Code はこれらの構造内も確認します。

* **ネストされたコマンド**: `(...)` を使用したサブシェル、`{ ...; }` を使用したブレースグループ、`$(...)` またはバッククォートを使用したコマンド置換、または `<(...)` を使用したプロセス置換。Claude Code は、`(rm -rf ~)` や `echo "$(rm -rf ~)"` のように置換内にある重要なパスの削除、または同じコマンド内の他の場所にある削除を見つけます。
* **インラインスクリプト**: `bash -c 'rm -rf ~'` のように、`-c` を付けて `sh`、`bash`、`zsh`、または同様の POSIX シェルに渡されるスクリプト。
  * スクリプトがダブルクォートで囲まれている場合、呼び出し元のシェルはスクリプトの変数を展開してから、内部シェルがスクリプトを受け取ります。`find . -name '*.tmp' -exec sh -c "rm -rf \"$1\"/*" _ {} \;` では、コマンドはマッチごとに 1 回ファイルシステムルートからの削除に展開され、Claude Code はこれを重要なパスの削除として扱います。
  * `sh -c 'rm -rf "$1"/*' _ {}` のように `$1` を実際の値にバインドするシングルクォートスクリプトは警告されません。

`~` など、`-c` スクリプト内に直接書かれた重要なパスに対するチェックをオフにするには、Claude Code を起動する環境で [`CLAUDE_CODE_DISABLE_INLINE_SHELL_RM_PROMPT=1`](/docs/ja/env-vars#variables) を設定します。

<h3 id="rewrite-a-flagged-command">
  フラグが付いたコマンドを書き直す
</h3>

コマンドをチェックに合格するように書き直す方法は、使用している[その他のターゲット](#other-targets-that-count-as-critical-paths)によって異なります。

* **`$DIR` などの変数の下のグロブまたは末尾のスラッシュ**: 各展開をガードして、変数が設定されていないか空の場合にシェルがエラーで停止するようにします。例えば `rm -rf "${DIR:?}"/*` のように、またはリテラルパスを使用します。すべての展開がこのようにガードされている削除はこのチェックに合格するため、`bypassPermissions` モードではプロンプトなしで実行されます。別の[重要なパス](#critical-paths)チェックがそれにフラグを付けない限り。
* **`$HOME` などの通常設定されている変数の下のグロブまたは末尾のスラッシュ**: リテラルパスを使用します。
* **ディレクトリ出力置換から割り当てられた変数**: リテラルパスを使用します。`"${D:?}"` ガードはこのチェックをクリアしません。変数は空ではないためです。
* **コマンド置換の出力のみであるターゲット**: 置換を単独で実行してから、それが出力するリテラルパスを削除します。プロンプトは Claude に同じことを行うよう指示します。

変数の下のグロブまたは末尾のスラッシュの場合、プロンプトはフラグが付いた `rm` に名前を付け、チェックに合格するように書き直す方法を説明します。

<h3 id="critical-path-removals-in-each-permission-mode">
  各権限モードでの重要なパスの削除
</h3>

Claude Code が重要なパスの削除に対して行うことは、権限モードによって異なります。

| モード | 結果 |
| :- | :- |
| `default`、`acceptEdits` | 承認を求めます |
| `plan` | 承認を求めます。[計画中に分類器がコマンドをレビューする](#analyze-before-you-edit-with-plan-mode)場合、バイパス権限が利用できないときは `auto` モードのように処理します |
| `auto` | ターミナルで承認を求めます（[時間制限](#time-limits-and-denials-in-auto-and-bypasspermissions-modes)付き）。その他の場所では拒否します |
| `dontAsk` | 拒否します |
| `bypassPermissions` | 承認を求めます（ターミナルでは時間制限付き） |

明示的な [ask ルール](/docs/ja/permissions#manage-permissions) がコマンドにマッチする場合、Claude Code は `auto` モードでも承認を求めます。時間制限はありません。承認を求めるモードでは、[`PermissionRequest` フック](/docs/ja/hooks#permissionrequest) はプロンプトに答えることができます。

<h3 id="time-limits-and-denials-in-auto-and-bypasspermissions-modes">
  auto および bypassPermissions モードでの時間制限と拒否
</h3>

`auto` および `bypassPermissions` モードでは、重要なパスの削除に対するターミナルプロンプトに 2 分間のカウントダウンが表示されます。

* カウントダウンが終了する前に答えない場合、Claude Code はコマンドを拒否し、Claude に代わりに何をするかを伝えるため、無人セッションは動作し続けます。
* プロンプトが開いている間に任意のキーを押すと、カウントダウンが停止し、プロンプトは答えを待ち続けます。
* セッション内でこれらのプロンプトが 3 回答えられずに終了した後、Claude Code はそれらの表示を停止し、重要なパスの削除をすぐに拒否します。新しいメッセージを送信するとカウントが再開されます。

`auto` モードでは、Claude Code がターミナルプロンプトを表示できない場所では、コマンドをすぐに拒否します。例えば、`-p` を使用した[非対話型実行](/docs/ja/headless)、[Agent SDK](/docs/ja/agent-sdk/permissions) セッション、VS Code 拡張機能のチャットパネル、デスクトップアプリなどです。拒否は Claude に削除したかったものを報告し、削除をあなたに任せるよう伝えます。

`auto` および `bypassPermissions` の処理には Claude Code v2.1.281 以降が必要です。これをオフにするには、Claude Code を起動する環境で [`CLAUDE_CODE_DISABLE_DANGEROUS_RM_TIMEOUT=1`](/docs/ja/env-vars#variables) を設定します。`auto` モードでは、重要なパスの削除は代わりに分類器に送信され、`bypassPermissions` モードではプロンプトに時間制限がありません。

<h3 id="remove-item-in-powershell">
  PowerShell の Remove-Item
</h3>

[PowerShell ツール](/docs/ja/tools-reference#powershell-tool)を有効にすると、Claude Code は `Remove-Item` と `cmd` ビルトイン `rd`、`rmdir`、`del`、`erase` に独自のチェックを与えます。これは `rm` 重要なパスリストとは別です。`Remove-Item` の場合、結果はターゲットに依存し、最初にマッチするケースが適用されます。

* **システムパス**。ファイルシステムルートとそのトップレベルディレクトリ、ドライブルートとそのトップレベルディレクトリ、およびホームディレクトリ。Claude Code はすべてのモードでコマンドを拒否し、承認を求めません。
* **ワイルドカード**。裸の `*`、または `/*` または `\*` で終わるターゲット（`$dir/*` のようなシェル変数の下のグロブを含む）。Claude Code は [分類器](#eliminate-prompts-with-auto-mode) がそれを見る前に、すべてのモードでコマンドを拒否し、承認を求めません。
* **作業ディレクトリまたはその親の 1 つ（`-Recurse` 付き）**。Claude Code はコマンドを承認が必要な他のコマンドと同じように扱うため、承認を求めるモードでは承認を求め、`auto` モードでは分類器に送信し、`dontAsk` モードでは拒否します。`bypassPermissions` モードはこのチェックをスキップします。

システムパスのケースは、Claude が `cmd /c rd /s /q C:\Users` のように `cmd` を通じて実行する場合、`rd`、`rmdir`、`del`、`erase` にも適用されます。デフォルトでは、Claude Code はすべてのモードでそのようなコマンドを拒否し、承認を求めません。この `cmd` チェックには Claude Code v2.1.283 以降が必要です。

`cmd` ターゲットを判定する場合、Claude Code はリテラルテキストに続く PowerShell 変数を空として扱います。これにより `cmd /c rd /s /q "C:\$name"` は `C:\` の削除となるため、これも拒否されます。末尾のワイルドカードはそれが空にするフォルダとしてカウントされるため、`cmd /c del /q C:\*` は拒否され、プロジェクト内の `cmd /c del /q dist\*` は拒否されません。

`cmd` チェックをオフにするには、Claude Code を起動する環境で [`CLAUDE_CODE_DISABLE_POWERSHELL_CMD_RM_DENY=1`](/docs/ja/env-vars#variables) を設定します。Claude Code はこの変数を設定ファイルの `env` ブロック内では無視します。システムパス上の `Remove-Item` はどちらの場合でも拒否されたままです。

<h2 id="see-also">
  関連項目
</h2>

* [Permissions](/docs/ja/permissions)：allow、ask、deny ルール。管理ポリシー
* [Configure auto mode](/docs/ja/auto-mode-config)：分類器に組織が信頼するインフラストラクチャを伝える
* [Hooks](/docs/ja/hooks)：`PreToolUse` および `PermissionRequest` フック経由のカスタム権限ロジック
* [Security](/docs/ja/security)：セキュリティ保護とベストプラクティス
* [Sandboxing](/docs/ja/sandboxing)：Bash コマンドのファイルシステムとネットワーク隔離
* [Non-interactive mode](/docs/ja/headless)：`-p` フラグで Claude Code を実行
