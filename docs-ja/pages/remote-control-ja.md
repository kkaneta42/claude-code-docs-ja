> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# 任意のデバイスからローカルセッションを続行する Remote Control

> Remote Control を使用して、電話、タブレット、または任意のブラウザから Claude Code のローカルセッションを続行します。claude.ai/code と Claude モバイルアプリで動作します。

Remote Control は [claude.ai/code](https://claude.ai/code) または Claude アプリ（[iOS](https://apps.apple.com/us/app/claude-by-anthropic/id6473753684) および [Android](https://play.google.com/store/apps/details?id=com.anthropic.claude)）をマシン上で実行されている Claude Code セッションに接続します。デスクでタスクを開始してから、ソファの電話またはコンピュータのブラウザで続行できます。

マシン上で Remote Control セッションを開始すると、Claude はローカルで実行され続けるため、コード実行とファイルシステムアクセスはマシン上に留まります。Remote Control を使用すると、以下のことができます。

* **ローカル環境全体をリモートで使用する**: ファイルシステム、[MCP サーバー](/docs/ja/mcp.md)、ツール、プロジェクト設定がすべて利用可能なままです。また、`@` を入力するとローカルプロジェクトのファイルパスが自動補完されます。
* **両方のサーフェスから同時に作業する**: 会話と [subagents](/docs/ja/sub-agents.md) および [dynamic workflows](/docs/ja/workflows.md) の進捗がすべての接続されたデバイス間で同期されるため、ターミナル、ブラウザ、電話から相互に交換可能にメッセージを送信できます。
* **電話またはブラウザから画像とファイルを送信する**: Claude アプリまたは claude.ai/code に写真またはファイルを添付できます。キャプション付きまたはキャプションなしで添付できます。Claude は添付された写真をメッセージの一部として直接見ることができます。Claude Code は他のファイルをマシンにダウンロードし、`@` ファイル参照として Claude に渡します。
* **中断に対応する**: ラップトップがスリープ状態になったり、ネットワークが切断されたりした場合、マシンがオンラインに戻ると、Claude Code は自動的に再接続されます。

[Web 上の Claude Code](/docs/ja/claude-code-on-the-web.md) はクラウドインフラストラクチャで実行されるのに対し、Remote Control セッションはマシン上で直接実行され、ローカルファイルシステムと相互作用します。Web およびモバイルインターフェースは、そのローカルセッションへのウィンドウにすぎません。そのため、コンピュータはオンのままである必要があり、`claude` プロセスは実行され続ける必要があります。

> [!NOTE]
>
> Remote Control は Claude Code の機能です。その他の Claude 製品での会話については、[Claude ヘルプセンター](https://support.claude.com)を参照してください。

## 要件

Remote Control を使用する前に、環境が以下の条件を満たしていることを確認してください。

* **サブスクリプション**: Pro、Max、Team、および Enterprise プランで利用可能です。API キーはサポートされていません。Team および Enterprise では、Owner が [Claude Code 管理設定](https://claude.ai/admin-settings/claude-code) で Remote Control トグルを最初に有効にする必要があります。
* **カスタムロール**: Enterprise 組織が [カスタムロール](https://support.claude.com/en/articles/13930452) でアクセスを管理している場合、ロールにはクラウドセッション権限と **Claude Code remote control** 権限の両方が含まれている必要があります。どちらかが欠けていると、Remote Control を開始したときに [`Remote Control is disabled by your organization's policy`](#remote-control-is-disabled-by-your-organizations-policy) と表示されます。Owner にロールを確認してもらい、[**Organization settings > Roles**](https://claude.ai/admin-settings/roles) で不足しているものを追加するよう依頼してください。
* **認証**: `claude` を実行し、まだサインインしていない場合は `/login` を使用して claude.ai 経由でサインインします。適格なログインがない場合、`claude remote-control` はエラーで終了しますが、`claude --remote-control` は対話型セッションを開始し、起動直後に Remote Control 失敗通知を表示します。
* **API エンドポイント**: 以下のいずれかの構成では利用できません。
  * Amazon Bedrock、Google Cloud の Agent Platform、または Microsoft Foundry を使用している。
  * [`ANTHROPIC_BASE_URL`](/docs/ja/env-vars) が `api.anthropic.com` 以外のホスト（[LLM gateway](/docs/ja/llm-gateway) やプロキシなど）を指している。Remote Control を使用するには、この変数を設定解除してください。
  * エンタープライズ [Claude apps gateway](/docs/ja/claude-apps-gateway) 経由でサインインしている。
* **機能フラグ評価**: [環境変数を設定して機能フラグ評価をオフにする](/docs/ja/env-vars.md#features-that-need-feature-flag-fetching) 場合、Remote Control が利用可能かどうかは、どの変数を設定するかによって異なります。
  * `CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC` または `DISABLE_GROWTHBOOK` を設定した場合、Remote Control は利用できません。シェル環境または [`settings.json` ファイル](/docs/ja/settings-reference#all-settings) の `env` ブロックのいずれかで変数が設定されている場所で変数を設定解除して、Remote Control を使用してください。
  * `DISABLE_TELEMETRY` または `DO_NOT_TRACK` のみを設定した場合、組織が [Trusted Devices](#trusted-devices) を要求しない限り、Remote Control は利用可能なままです。要求する場合は、Remote Control を使用するために変数を設定解除してください。いずれかの変数を設定した状態で Remote Control を使用するには、Claude Code v2.1.283 以降、または Claude Desktop アプリでは v2.1.304 以降が必要です。
* **ワークスペース信頼**: まだ信頼していないディレクトリで、`claude remote-control` は信頼を有効にする内容を出力し、開始する前に `Trust <directory>? [y/N]` と尋ねます。`y` と答えると選択が保存されます。ただし、ホームディレクトリでは信頼は保存されず、実行するたびに質問が返されます。標準入力または出力がターミナルでない場合、コマンドは質問できず、[`Workspace not trusted`](/docs/ja/errors#workspace-not-trusted-when-starting-remote-control) エラーで終了します。

## Remote Control セッションを開始する

Remote Control セッションは、CLI、[Claude Desktop アプリ](/docs/ja/desktop.md)、または VS Code 拡張機能から開始できます。CLI には 3 つの起動モードがあり、Desktop アプリと VS Code では `/remote-control` コマンドを使用します。

**サーバーモード**

プロジェクトディレクトリで次を実行します。

```bash theme={null}
claude remote-control
```

Remote Control の初回確認を承諾するまでは、`claude remote-control` はサーバーを起動する前にその動作を説明し、`Enable Remote Control? (y/n)` と尋ねます。`y` と答えると承諾してサーバーを起動します。拒否した場合、Claude Code はサーバーを起動せずに終了し、次回このコマンドを実行したときに再度尋ねます。

プロセスはサーバーモードでターミナル内で実行され続け、リモート接続を待機します。[別のデバイスから接続する](#connect-from-another-device)ために使用できるセッション URL が表示され、スペースバーを押すとスマートフォンからすばやくアクセスするための QR コードを表示できます。リモートセッションがアクティブな間、ターミナルには接続状態とツールのアクティビティが表示されます。

`remote-control` の後に次のフラグを渡せます。

| フラグ | 説明 |
| - | - |
| `--name "My Project"` | claude.ai/code のセッション一覧に表示されるカスタムセッションタイトルを設定します。 |
| `--remote-control-session-name-prefix <prefix>` | 明示的な名前が設定されていない場合に自動生成されるセッション名のプレフィックスです。デフォルトはマシンのホスト名で、`myhost-graceful-unicorn` のような名前になります。`CLAUDE_REMOTE_CONTROL_SESSION_NAME_PREFIX` を設定しても同じ効果が得られます。 |
| `-c`, `--continue` | 新しいセッションを作成する代わりに、このディレクトリで最後に実行したサーバーが開始時に作成したセッションを復元します。[サーバー停止後にセッションを再開する](#resume-sessions-after-stopping-the-server)を参照してください。`--session-id`、`--spawn`、`--capacity`、`--create-session-in-dir` とは併用できません。Claude Code v2.1.200 以降が必要です。 |
| `--session-id <id>` | ID を指定して 1 つのセッションを復元します。[サーバー停止後にセッションを再開する](#resume-sessions-after-stopping-the-server)を参照してください。`--continue`、`--spawn`、`--capacity`、`--create-session-in-dir` とは併用できません。Claude Code v2.1.200 以降が必要です。 |
| `--spawn <mode>` | サーバーがセッションを作成する方法です。 • `same-dir`（モードが保存されていない場合のデフォルト）：すべてのセッションが現在の作業ディレクトリを共有するため、同じファイルを編集すると競合する可能性があります。 • `worktree`：オンデマンドの各セッションが独自の [git worktree](/docs/ja/worktrees.md) を取得します。git リポジトリまたは [`WorktreeCreate` フック](/docs/ja/hooks#worktreecreate)が必要です。 • `session`：シングルセッションモード。ちょうど 1 つのセッションのみを提供し、追加の接続を拒否します。起動時にのみ設定できます。 実行中に `w` を押すと `same-dir` と `worktree` を切り替えられます。切り替えたモードは[このプロジェクトのデフォルト](#set-the-default-spawn-mode-for-a-project)になります。 |
| `--capacity <N>` | 同時セッションの最大数です。デフォルトは 32 です。`--spawn=session` とは併用できません。 |
| `--[no-]create-session-in-dir` | サーバー起動時に現在のディレクトリにセッションを 1 つ事前作成し、すぐに入力できるようにします。`worktree` モードでは、このセッションは現在のディレクトリに留まり、オンデマンドのセッションは分離された worktree を取得します。デフォルトでオンです。`--no-create-session-in-dir` を渡してセッションなしで起動した場合、Claude Code はサーバーを停止したときにそのセッションをアーカイブするため、[再開](#resume-sessions-after-stopping-the-server)できるものは残りません。 |
| `--permission-mode <mode>` | サーバーのセッションの開始時の[権限モード](/docs/ja/permission-modes.md)（`acceptEdits` など）を設定します。`manual` は `default` のエイリアスとして受け付けます。認識できないモードを指定すると、サーバーは起動時に停止し、有効なモードを一覧表示します。 |
| `--chrome` / `--no-chrome` | サーバーが作成するセッションで [Chrome 統合](/docs/ja/chrome.md)をオンまたはオフにし、別のデバイスから作業している間に Claude がマシン上の Chrome を使用できるようにします。どちらのフラグも指定しない場合、サーバーが事前作成するセッションと、claude.ai/code または Claude アプリから自分で開始したセッションは、[Chrome をデフォルトで有効にした](/docs/ja/chrome.md#enable-chrome-by-default)場合でも Chrome がオフの状態で開始されます。サーバーが[プロジェクト](/docs/ja/claude-projects.md)のスレッドのために開始するセッションは、代わりにその設定に従います（`bypassPermissions` モードを除く）。Claude Code v2.1.273 以降が必要です。 |
| `-d`, `--debug[=<filter>]` | サーバーのデバッグログをオンにします。必要に応じてカテゴリでフィルタリングできます。フィルターは `--debug=api,hooks` のように `=` 形式でのみ渡します。Claude Code v2.1.282 以降が必要です。 |
| `--debug-file <path>` | デバッグログを指定したファイルに書き込みます。 |
| `--verbose` | 詳細な接続ログとセッションログを表示します。 |
| `--sandbox`, `--no-sandbox` | v2.1.300 で削除されました。どちらかのフラグを渡すと、サーバーは起動せずに[エラーで終了](/docs/ja/errors.md#sandbox-is-not-supported-by-claude-remote-control)します。 |

`remote-control` の前にグローバルな `claude` フラグを渡した場合、またはラッパースクリプトがフラグを追加した場合、Claude Code はそのフラグをサーバーが作成するセッションに引き継ぎません。Claude Code がフラグを通すのは、`--verbose` や `--model` のように、それを削除してもセッションでできることが変わらないとわかっている場合だけです。`--settings` などその他のフラグの場合、Claude Code は[起動を拒否](/docs/ja/errors.md#not-carried-over-to-the-sessions-remote-control-starts)し、削除すべきフラグ名を表示します。

サーバーが開始するセッションをサンドボックス化するには、設定ファイルで[サンドボックス化](/docs/ja/sandboxing.md)をオンにします。

ターミナルに `remote-control` のフラグを表示するには、`claude remote-control --help` を実行します。v2.1.302 より前は、対象となるサインインがない場合、このコマンドは代わりに[トラブルシューティング](#troubleshooting)に記載されているエラーのいずれかを返していました。

**インタラクティブセッション**

Remote Control を有効にした通常のインタラクティブな Claude Code セッションを開始するには、`--remote-control` フラグ（または `--rc`）を使用します。

```bash theme={null}
claude --remote-control
```

必要に応じてセッション名を渡します。

```bash theme={null}
claude --remote-control "My Project"
```

これにより、claude.ai や Claude アプリからも操作できる完全なインタラクティブセッションがターミナル内で利用できます。`claude remote-control`（サーバーモード）とは異なり、セッションがリモートからも利用可能な状態のまま、ローカルでメッセージを入力できます。

**既存のセッションから**

すでに Claude Code セッション中で、それをリモートで続けたい場合は、`/remote-control`（または `/rc`）コマンドを使用します。

```text theme={null}
/remote-control
```

引数として名前を渡すと、カスタムセッションタイトルを設定できます。

```text theme={null}
/remote-control My Project
```

これにより、現在の会話履歴を引き継いだ Remote Control セッションが開始されます。

Remote Control の初回確認を承諾するまでは、`/remote-control` が接続する前にダイアログが表示されます。**Enable Remote Control** を選択すると承諾して接続します。**Never mind** を選択するか Esc を押すと、Claude Code は接続せず、次回 `/remote-control` を実行したときに再度尋ねます。

このコマンドでは `--verbose` フラグは使用できません。

**VS Code**

[Claude Code VS Code 拡張機能](/docs/ja/vs-code.md)で、プロンプトボックスに `/remote-control` または `/rc` と入力します。

```text theme={null}
/remote-control
```

Remote Control がオンの間、Claude Code はプロンプトボックスのフッターに **Remote Control** インジケーターを表示します。セッションが接続されたら、インジケーターをクリックしてセッションに直接移動するか、[claude.ai/code](https://claude.ai/code) のセッション一覧で見つけます。Claude Code はセッション URL も会話に投稿します。切断するには、`/remote-control` を再度実行します。

CLI とは異なり、VS Code のコマンドは名前の引数を受け付けず、QR コードも表示しません。セッションタイトルは会話履歴または最初のプロンプトから決まります。

**Desktop アプリ**

[Claude Desktop アプリ](/docs/ja/desktop.md)の Code タブのローカルセッションで、プロンプトボックスに `/remote-control` または `/rc` と入力します。

```text theme={null}
/remote-control
```

セッションが接続されたら、[claude.ai/code](https://claude.ai/code) のセッション一覧で見つけます。切断するには、`/remote-control` を再度実行します。

代わりにすべてのセッションで Remote Control をデフォルトでオンにするには、[すべてのセッションで Remote Control を有効にする](#enable-remote-control-for-all-sessions)を参照してください。

### 接続状態を確認する

インタラクティブセッションでは、Remote Control が接続されている間、ターミナルに claude.ai 上のセッションへリンクする `/rc active` インジケーターが表示されます。ターミナルの幅が狭すぎて収まらない場合、インジケーターは非表示になります。セッション URL と[別のデバイスから接続する](#connect-from-another-device)ための QR コードを確認するには、`/remote-control` を再度実行してステータスパネルを開きます。このパネルでは、ローカルセッションを実行したまま Remote Control を切断することもできます。

インタラクティブセッションで接続が失敗すると、インジケーターが失敗を示す表示に変わり、Claude Code は通知で理由を表示して会話にも追加します。理由がセッションが別の場所で変更されたことを示している場合を除き、`/remote-control` を実行して再接続します。

* **Another connection took over this session**：別のデバイスまたは Claude Code セッションが現在このセッションを保持しています。取り戻したい場合にのみ `/remote-control` を実行してください。
* **This session was ended or archived from another device or app**：セッションを戻したい場合にのみ `/remote-control` を実行してください。Claude Code はアーカイブされたセッションを再び開きます。
* **The server no longer reports this session**：別のデバイスまたはアプリから削除された可能性があります。

### 別のデバイスから接続する

Remote Control セッションがアクティブになったら、別のデバイスから接続する方法がいくつかあります。

* 任意のブラウザで**セッション URL を開く**と、[claude.ai/code](https://claude.ai/code) 上のセッションに直接移動します。
* セッション URL と一緒に表示される **QR コードをスキャンする**と、Claude アプリで直接開きます。`claude remote-control` では、スペースバーを押すと QR コードの表示を切り替えられます。
* **[claude.ai/code](https://claude.ai/code) または Claude アプリを開き**、セッション一覧から名前でセッションを見つけます。Claude モバイルアプリでは、ナビゲーションの **Code** をタップするとセッション一覧に移動できます。Remote Control セッションは、オンライン時に緑色のステータスドット付きのコンピューターアイコンで表示されます。

接続すると、デバイスにはセッションがすでにバックグラウンドで実行しているサブエージェントとワークフローが表示されます。デバイスからそのいずれかを停止すると、Claude Code はマシン上のそのタスクを停止します。

リモートセッションのタイトルは次の順序で決まります。

1. `--name`、`--remote-control`、または `/remote-control` に渡した名前
2. `/rename` で設定したタイトル
3. 既存の会話履歴内の最後の意味のあるメッセージ
4. `myhost-graceful-unicorn` のような自動生成された名前（`myhost` はマシンのホスト名、または `--remote-control-session-name-prefix` で設定したプレフィックス）

明示的な名前を設定していない場合、プロンプトを送信すると Claude Code はそれを反映してタイトルを更新します。claude.ai または Claude アプリからセッション名を変更すると、Claude Code は `claude --resume` に表示されるローカルのタイトルも更新します。

まだ Claude アプリを持っていない場合は、Claude Code 内で `/mobile` を実行すると [claude.ai/mobile](https://claude.ai/mobile) の QR コードが表示され、スマートフォンに合ったアプリストアが開きます。

### 接続されたデバイスに表示される内容

接続されたデバイスには、ターミナル内の会話がリアルタイムで表示されます。通常のメッセージ以外には、次のようなケースがあります。

* **コンテキスト圧縮と `/clear`**：Claude Code が[会話を圧縮](/docs/ja/context-window.md#what-survives-compaction)している間、接続されたデバイスには進行状況が表示され、その後会話が圧縮された位置が表示されます。`/clear` を実行すると、接続されたデバイス上の会話もリセットされます。
* **`/resume` による会話の切り替え**：接続されたデバイスは切り替え先の会話のタイトルや過去の履歴を受け取りませんが、双方向の新しいメッセージはターミナルで開いている会話との間でやり取りされます。デバイスから元の会話で再び作業するには、ターミナルで `/resume` を実行して元の会話に切り替えます。
* **`/teleport` によるセッションの取り込み**：`/teleport` で[クラウドセッション](/docs/ja/claude-code-on-the-web.md#from-cloud-to-terminal)をターミナルに取り込むと、接続されたデバイスは取り込んだ会話の過去の履歴を受け取りません。双方向の新しいメッセージは、現在ターミナルで開いている取り込んだ会話との間でやり取りされます。
* **自分の他のセッションからのメッセージ**：[セッション間メッセージング](/docs/ja/cross-session-messaging.md)を使用すると、同じ接続で異なるマシン上の自分のセッション間のメッセージもやり取りされます。
* **変更の差分**：セッションのディレクトリが git リポジトリ内にある場合、接続されたデバイスの差分ペインに変更が表示されます。リポジトリのデフォルトブランチより先行するコミットがあるブランチでは、ペインにはデフォルトブランチから分岐して以降の変更が、コミットされていない編集も含めて表示されます。デフォルトブランチ自体、またはデフォルトブランチより先行していないブランチでは、コミットされていない変更のみが表示されます。
* **モデル**：接続されたデバイスから[モデル](/docs/ja/model-config.md)を選択すると、Claude Code はそのモデルでセッションを実行します。Claude Code v2.1.238 以降が必要です。デバイスのモデルコントロールで選択したモデルは現在のセッションにのみ適用されます。デバイスからインタラクティブセッションに `/model <name>` を送信すると、Claude Code は新しいセッションのデフォルトも設定します。
* **effort レベル**：接続されたデバイスから `/effort` またはデバイスの effort コントロールで [effort レベル](/docs/ja/model-config.md#adjust-effort-level)を設定すると、Claude Code はそれをマシン上のセッションに適用します。`CLAUDE_CODE_EFFORT_LEVEL` でレベルを固定している場合、セッションはそのレベルを維持し、Claude Code は effort コントロールでの異なる選択を拒否します。effort コントロールからレベルを選択するには、マシン上で Claude Code v2.1.234 以降が必要です。
* **接続失敗後の再接続**：`/remote-control` を実行して再接続します。その間にコンテキスト圧縮によって会話が書き換えられたか、`/resume` で会話を切り替えた場合、Claude Code は使用していたサーバーセッションをセッション一覧に残さずアーカイブします。[アーカイブされたセッションでフィルタリング](/docs/ja/claude-code-on-the-web.md#archive-sessions)すれば引き続き見つけられます。デバイスが接続されたままの状態で会話を切り替えても、セッションはアーカイブされません。

### すべてのセッションで Remote Control を有効にする

自動接続がオンになっていない限り、Remote Control は `claude remote-control`、`claude --remote-control`、または `/remote-control` を明示的に実行したときにのみ有効になります。すべてのインタラクティブセッションで自動接続をオンにするには、Claude Code 内で `/config` を実行し、**Enable Remote Control for all sessions** を設定します。このトグルは 3 つの値を取ります。

* **`true`**：インタラクティブセッションの開始時に自動的に接続します。
* **`false`**：自動接続をオフにします。ただし、Claude Code はこの選択をユーザー設定に保存するため、[管理設定](/docs/ja/managed-settings.md)の `true` がこれより優先されます。プロジェクト設定またはローカル設定（`.claude/settings.json`、`.claude/settings.local.json`）の `false` は、管理設定の `true` よりも優先して自動接続をオフにします。
* **`default`**：選択をクリアし、組織の管理者によるデフォルトが設定されていればそれに従い、設定されていなければ Claude Code の現在のデフォルトに従います。`DISABLE_TELEMETRY` または `DO_NOT_TRACK` を設定している場合は、[`DISABLE_TELEMETRY` または `DO_NOT_TRACK` を設定した状態での自動接続](#auto-connect-with-disable-telemetry-or-do-not-track)を参照してください。

VS Code 拡張機能と Desktop アプリにも自動接続のトグルがあります。

* **VS Code 拡張機能**：[コマンドメニュー](/docs/ja/vs-code.md#use-the-prompt-box)の Settings セクションにある **Enable Remote Control for all sessions**。
* **Desktop アプリ**：**Settings > Claude Code > Connect new sessions to Remote Control**。[他のデバイスに表示するセッションを制御する](/docs/ja/desktop.md#control-which-sessions-appear-on-your-other-devices)を参照してください。

代わりに設定ファイルから自動接続をオンにするには、ユーザーの `~/.claude/settings.json` または[管理設定](/docs/ja/managed-settings.md)で [`remoteControlAtStartup`](/docs/ja/settings-reference#remotecontrolatstartup) を `true` に設定します。プロジェクト設定またはローカル設定（`.claude/settings.json`、`.claude/settings.local.json`）では、Claude Code は `false` を尊重してそのリポジトリの自動接続をオフにしますが、`true` は無視します。そのため、チェックインされたファイルによって、リポジトリを開くすべての人の Remote Control がオンになることはありません。

自動接続は自分の claude.ai アカウントでサインインするため、自動接続で開始したセッションは自分のアカウントの Claude アプリにのみ表示され、他の誰にもアクセス権を与えません。

この設定をオンにすると、各インタラクティブ Claude Code プロセスが 1 つのリモートセッションを登録します。複数のインスタンスを実行すると、それぞれが独自のリモートセッションを取得します。単一のプロセスから複数の同時セッションを実行するには、代わりに[サーバーモード](#start-a-remote-control-session)を使用してください。

#### `DISABLE_TELEMETRY` または `DO_NOT_TRACK` を設定した状態での自動接続

`DISABLE_TELEMETRY` または `DO_NOT_TRACK` のみを設定している場合、組織の管理者によるデフォルトや Claude Code 自体のデフォルトによってセッションが自動接続されることはありません。`DISABLE_GROWTHBOOK` や LLM ゲートウェイなど、他の理由で Remote Control が利用できない場合は、代わりに[要件](#requirements)から確認してください。

`DISABLE_TELEMETRY` または `DO_NOT_TRACK` のみを設定した状態で自動接続をオンにする前に、Claude Code のバージョンが[これらの変数の要件](#requirements)を満たしていることを確認してください。次に、組織が [Trusted Devices](#trusted-devices) を必須としているかどうかを確認します。

* **必須でない場合**：`/config` で **Enable Remote Control for all sessions** を `true` に設定します。
* **必須の場合**：`DISABLE_TELEMETRY` または `DO_NOT_TRACK` が設定されている間は Remote Control を利用できません。2 つの変数のうち設定した方を解除してください。それでもセッションが自動接続されない場合は、`/config` で **Enable Remote Control for all sessions** を `true` に設定します。

### サーバー停止後にセッションを再開する

Ctrl+C で `claude remote-control` を停止すると、提供していたセッションはスマートフォンやブラウザから応答しなくなります。同じディレクトリで別の `claude remote-control` を実行しておらず、このサーバーを `--no-create-session-in-dir` で起動していない限り、Claude Code はそれらのセッションをアーカイブしません。セッションを復元するには、同じディレクトリで次のいずれかのコマンドを実行します。

* **`claude remote-control`**：サーバーが提供していたすべてのセッションを復元します。
* **`claude remote-control --continue`**：サーバーが開始時に作成したセッションのみを復元し、そのセッションが終了すると終了します。このディレクトリに記録がない場合、Claude Code はこのリポジトリの他の git worktree にある最新の記録を使用します。
* **`claude remote-control --session-id <id>`**：渡した ID のセッションのみを復元し、そのセッションが終了すると終了します。ID は、claude.ai/code のセッション URL のうち `/code/` と `?`（ある場合）の間の部分です。

これらのコマンドは、サーバー停止後約 4 時間使用できます。それ以降は、`claude remote-control` を実行して新しいセッションを開始してください。その間にセッションをアーカイブした場合、Claude Code v2.1.228 以降では `--continue` と `--session-id` によってアーカイブが解除されます。

`claude --remote-control` または `/remote-control` で開始したセッションを復元するには、`claude --continue` または `claude --resume` で会話を再開します。再開した会話が開始時に使用する権限モードについては、[再開時の権限モード](/docs/ja/sessions.md#permission-mode-on-resume)を参照してください。Remote Control が再接続されない場合は、[Couldn't reconnect to your Remote Control session](#couldnt-reconnect-to-your-remote-control-session) を参照してください。

最初のターミナルで Remote Control がオンのまま 2 つ目のターミナルで会話を再開すると、Claude Code は 2 つ目のターミナルに `Remote Control not started here` という通知を表示し、最初のターミナルからセッションを奪う代わりに、そちらでは Remote Control をオフのままにします。Remote Control を 2 つ目のターミナルに移すには、2 つ目のターミナルで `/remote-control` を実行します。

Remote Control がオンだった会話を Claude Desktop または IDE 拡張機能で再開すると、Claude Code はセッション一覧に新しいセッションを追加する代わりに、既存の claude.ai セッションに再接続します。

### プロジェクトのデフォルトの spawn モードを設定する

`claude remote-control` が起動時に `Spawn mode: <mode> (saved for this folder; press w to change)` と表示する場合、サーバーはこのプロジェクトで以前に保存された spawn モードで起動しています。

保存されたモードは、自分のターミナルで行った選択に基づきます。そこで `claude remote-control` が `Spawn mode for this project:` と尋ねた場合、Claude Code は回答（`same-dir` なら `1`、`worktree` なら `2`）を保持しています。実行中に `w` を押した場合、Claude Code は切り替え先のモードを保持します。これは `--spawn same-dir` または `--spawn worktree` で開始した実行でも同様です。

* サーバーが `same-dir` または `worktree` モードで実行されている間、サーバーのターミナルで `w` を押すともう一方のモードに切り替わります。切り替えには git リポジトリまたは `WorktreeCreate` フックが必要です。
* 1 回の実行だけ別のモードを使用するには、`--spawn <mode>` を渡します。

## 接続とセキュリティ

ローカル Claude Code セッションは、アウトバウンド HTTPS リクエストのみを行い、マシン上のインバウンドポートを開くことはありません。Remote Control を開始すると、Anthropic API に登録され、作業をポーリングします。別のデバイスから接続すると、サーバーは Web またはモバイルクライアントとローカルセッション間のメッセージをストリーミング接続経由でルーティングします。

すべてのトラフィックは TLS 経由で Anthropic API を通じて移動し、Claude Code セッションと同じトランスポートセキュリティです。接続は複数の短命の認証情報を使用し、各認証情報は単一の目的にスコープされ、独立して有効期限が切れます。

Remote Control が接続されている間、セッショントランスクリプト（メッセージ、Claude の応答、ツールアクティビティを含む）は Anthropic サーバーに保存されます。保存されたトランスクリプトは、デバイス間で会話を同期させ、ネットワーク障害後にセッションが再接続できるようにします。実行とファイルシステムアクセスはマシン上に留まり、保存されたトランスクリプトは [データ使用](/docs/ja/data-usage.md) ポリシーに基づいて保持されます。

Remote Control を完全にオフにするには、[`disableRemoteControl`](/docs/ja/settings-reference#disableremotecontrol) 設定を使用します。[Zero Data Retention](/docs/ja/zero-data-retention.md) が有効になっている組織、または [HIPAA 構成](/docs/ja/hipaa-setup.md) が適用されている組織は、Remote Control を有効にすることはできません。

## 信頼できるデバイス

> [!NOTE]
>
> 信頼できるデバイスは現在ベータ版です。エクスペリエンスが改善されるにつれて、機能と機能が進化する可能性があります。
>
> 信頼できるデバイスは Pro、Max、Team、および Enterprise プランで利用可能であり、デフォルトではオフになっています。Team および Enterprise プランでは、Owner が組織に対してこれをオンにします。Pro および Max プランでは、設定の Cowork またはアカウントページで、自分で **信頼できるデバイスを要求** をオンにします。

信頼できるデバイスは、組織のメンバー、または Pro もしくは Max プランではあなた自身が、claude.ai、Claude モバイルアプリ、または Claude Desktop から Remote Control セッションを表示または操作する前に、デバイスを確認する必要があります。これは、署名されたアカウントだけでなく、既知のデバイスと最近の認証に Remote Control アクセスを結び付けます。

設定がオンの場合、Remote Control セッションと相互作用するには、以下の両方が必要です。

* **登録されたデバイス**: メンバーが Remote Control に使用する各ブラウザ、電話、またはデスクトップアプリは、独自の認証情報を登録します。登録は完全なサインイン直後にのみ提供されるため、デバイスはバックグラウンドで静かに登録されるのではなく、実際の認証の一部として信頼できるリストに参加します。
* **最近のサインイン**: メンバーのサインインは 18 時間以内である必要があります。毎日サインインする代わりに、メンバーは Face ID、Touch ID、Windows Hello、またはパスキーで存在を確認します。このバイオメトリック段階的認証はセッションを即座にリフレッシュします。

バイオメトリック チェックはデバイス上でオペレーティングシステムまたはブラウザを通じて実行され、パスキーサインインと同じメカニズムです。Anthropic は指紋、顔データ、またはその他のバイオメトリック情報を受け取ったり保存したりすることはありません。デバイスの公開鍵と表示名、プラットフォーム、登録時刻などの基本的なメタデータのみが保存されます。

この設定は、Claude Code の Remote Control と、[Cowork](https://claude.com/docs/cowork/overview) の Computer access に適用されます。このページでは Claude Code 側について説明します。通常の Claude チャット、ターミナルの Claude Code、および API 使用は影響を受けません。

### Team または Enterprise 組織で信頼できるデバイスを有効にする

Owner は claude.ai 組織設定から設定を有効にします。

**1. Capabilities ページに移動する**

[**Organization settings > Capabilities > Remote sessions**](https://claude.ai/admin-settings/capabilities) に移動します。**Require trusted devices** トグルはそのセクションに表示されます。

**2. 信頼できるデバイスを要求をオンにする**

この設定は組織のすべてのメンバーと、トグルを有効にした後に開始された Remote Control セッションに適用されます。トグルがオンになる前に既に実行されていたセッションは遡及的に保護されず、終了するまでデバイス要件なしで続行されます。チームごとまたはプロジェクトごとのスコープは利用できません。

**3. メンバーに何を期待するかを伝える**

設定が有効になった後、メンバーがブラウザ、電話、またはデスクトップアプリから新しい Remote Control セッションを初めて表示または操作するときに、そのデバイスを登録するよう求められます。事前に知らせることで混乱を避けられます。

### メンバーが見るもの

登録はデバイスごとに 1 回限りのステップです。その後、唯一の目に見える変化は時折のバイオメトリック プロンプトです。

* **各デバイスでの初回使用**: メンバーは登録するよう求められます。サインインが最近でない場合は、SSO が設定されている場合を含む通常のフローを通じてサインインしてから、登録を確認します。
* **日々**: 登録されたデバイスと最近のサインインを持つメンバーはプロンプトを見ません。サインインが 18 時間を超えて経過すると、次の Remote Control インタラクションは単一の Face ID、Touch ID、Windows Hello、またはパスキー プロンプトを表示します。
* **登録されていないデバイス**: デバイスが登録されるまで、Remote Control セッションを表示または操作することはできません。そのデバイスでの通常の Claude チャットは影響を受けません。
* **プラットフォーム認証器がない**: Face ID、Touch ID、または Windows Hello がないマシン上のメンバーは、ハードウェアセキュリティキーを使用するか、段階的認証の代わりにサインインできます。
* **ターミナルで**: Claude Code を実行しているマシンは、開発者が CLI にサインインするときに独自の認証情報を自動的に受け取ります。ターミナルに別の登録ステップはありません。

### 登録されたデバイスを管理する

メンバーはアカウント設定から独自のデバイスを確認および取り消すことができます。

[claude.ai/settings/account](https://claude.ai/settings/account#trusted-devices) を開き、**Trusted devices** セクションを見つけて、名前、プラットフォーム、登録日を含むすべての登録されたデバイスを確認します。デバイスを削除すると、その認証情報は即座に取り消され、デバイスは後で新しいサインイン後に再登録できます。認証情報は更新されない場合は自動的に有効期限が切れるため、未使用のデバイスは信頼できるリストから自動的に削除されます。

紛失または盗難されたデバイスの場合、メンバーはこのページから削除します。メンバーがサインインできない場合、管理者は管理コンソールで **Sign out everywhere** を使用してそのメンバーのすべてのセッションと登録されたデバイスを取り消すことができます。その後、メンバーは保持しているデバイスを再登録します。

## リモートコントロール対クラウドセッション

リモートコントロールと[クラウドセッション](/docs/ja/claude-code-on-the-web.md)は、どちらも claude.ai/code インターフェースを使用します。主な違いは、セッションが実行される場所です。リモートコントロールはお客様のマシン上で実行されるため、ローカル MCP サーバー、ツール、プロジェクト設定が利用可能なままです。クラウドセッションはクラウドインフラストラクチャ上で実行され、デフォルトでは Anthropic が管理します。

ローカル作業の途中で別のデバイスから続行したい場合は、リモートコントロールを使用してください。ローカルセットアップなしでタスクを開始したい場合、クローンしていないリポジトリで作業したい場合、または複数のタスクを並行して実行したい場合は、クラウドセッションを使用してください。[プロジェクト](/docs/ja/claude-projects.md)は両者を組み合わせたもので、そのスレッドはクラウドで実行され、お客様がそこで要求した場合、リモートコントロールを使用して[スレッドをお客様のコンピュータで実行](/docs/ja/claude-projects.md#run-a-thread-on-your-own-computer)します。

Claude Code は、ターミナルにいない時に作業するための複数の方法を提供しています。これらは、何が作業をトリガーするか、Claude がどこで実行されるか、そしてセットアップにどの程度の手間が必要かが異なります。

| | トリガー | Claude が実行される場所 | セットアップ | 最適な用途 |
| :- | :- | :- | :- | :- |
| [Dispatch](/docs/ja/desktop.md#sessions-from-dispatch) | Claude モバイルアプリからタスクをメッセージで送信 | あなたのマシン（Desktop） | [モバイルアプリを Desktop とペアリング](https://support.claude.com/en/articles/13947068) | 外出中の作業委譲、最小限のセットアップ |
| [Remote Control](/docs/ja/remote-control.md) | [claude.ai/code](https://claude.ai/code) または Claude モバイルアプリから実行中のセッションを操作 | あなたのマシン（CLI、Desktop、または VS Code） | [`claude remote-control` または `/remote-control`](/docs/ja/remote-control#start-a-remote-control-session) を実行 | 別のデバイスから進行中の作業を操舵 |
| [Channels](/docs/ja/channels.md) | Telegram や Discord などのチャットアプリ、またはあなた自身のサーバーからイベントをプッシュ | あなたのマシン（CLI） | [チャネルプラグインをインストール](/docs/ja/channels.md#quickstart)するか、[独自に構築](/docs/ja/channels-reference.md) | CI 失敗やチャットメッセージなどの外部イベントに対応 |
| [Slack](/docs/ja/slack.md) | チームチャンネルで `@Claude` をメンション | Anthropic クラウド | [ウェブ上の Claude Code](/docs/ja/claude-code-on-the-web.md) を有効にした状態で [Slack アプリをインストール](/docs/ja/slack.md#setting-up-claude-code-in-slack)、Pro および Max プラン | チームチャットからの PR とレビュー |
| [Self-hosted environments](/docs/ja/self-hosted-environments) | [クラウドセッション](/docs/ja/claude-code-on-the-web.md)を開始し、組織の環境を選択 | あなたの組織のインフラストラクチャ | [ランナーをデプロイ](/docs/ja/self-hosted-environments-quickstart.md)、Team および Enterprise プラン | ネットワーク内で実行する必要があるクラウドセッション |
| [Scheduled tasks](/docs/ja/scheduled-tasks.md) | スケジュールを設定 | [CLI](/docs/ja/scheduled-tasks.md)、[Desktop](/docs/ja/desktop-scheduled-tasks.md)、または[クラウド](/docs/ja/routines.md) | 頻度を選択 | 日次レビューなどの定期的な自動化 |

## モバイルプッシュ通知

リモートコントロールがアクティブな場合、Claude はお客様の電話にプッシュ通知を送信できます。

Claude がプッシュを送信するタイミングを決定します。通常は、長時間実行されるタスクが完了したときや、続行するためにお客様の決定が必要なときに送信されます。プロンプトでプッシュをリクエストすることもできます。例えば `notify me when the tests finish` のようにです。以下の 2 つのオン/オフトグルを除いて、イベントごとの設定はありません。

モバイルプッシュ通知を設定するには：

**1. Claude モバイルアプリをインストール**

[iOS](https://apps.apple.com/us/app/claude-by-anthropic/id6473753684) または [Android](https://play.google.com/store/apps/details?id=com.anthropic.claude) 用の Claude アプリをダウンロードしてください。

**2. Claude Code アカウントでサインイン**

ターミナルで Claude Code に使用するのと同じアカウントと組織を使用してください。

**3. 通知を許可**

オペレーティングシステムからの通知権限プロンプトを受け入れてください。

**4. Claude Code でプッシュを有効化**

ターミナルで `/config` を実行し、プロアクティブな通知の場合は **Push when Claude decides**、権限プロンプトと質問の場合は **Push when actions required**、またはその両方を有効にしてください。

通知が届かない場合：

* `/config` に **No mobile registered** と表示されている場合は、Claude アプリをお客様の電話で開いて、プッシュトークンをリフレッシュしてください。リモートコントロールが次に接続するときに警告がクリアされます。
* iOS では、フォーカスモードと通知サマリーがプッシュを抑制または遅延させることができます。設定 → 通知 → Claude を確認してください。
* Android では、積極的なバッテリー最適化により配信が遅延することがあります。システム設定で Claude アプリをバッテリー最適化から除外してください。

Claude Code は、お客様がターミナルに入力中または接続されたターミナルにフォーカスしている間、モバイルプッシュ通知をスキップします。これをマシンにいるときはいつでも（別のウィンドウにいる場合でも）に拡張するには、[`CLAUDE_CLIENT_PRESENCE_FILE`](/docs/ja/env-vars) をマーカーファイルパスに設定してください。ファイルが存在する間は通知がスキップされます。スクリーンロックリスナーまたは同様のツールを設定して、スクリーンがロック解除されたときにファイルを作成し、スクリーンがロックされたときに削除してください。

## 制限事項

* **対話型プロセスごとに 1 つのリモートセッション**: サーバーモード以外では、各 Claude Code インスタンスは一度に 1 つのリモートセッションをサポートします。単一のプロセスから複数のセッションを同時に実行するには、[サーバーモード](#start-a-remote-control-session)を使用してください。
* **ローカルプロセスを実行し続ける必要がある**: Remote Control はローカルプロセスとして実行されます。ターミナルを閉じる、マシン上でセッションを実行している Desktop アプリや VS Code を終了する、またはその他の方法で `claude` プロセスを停止すると、[再開する](#resume-sessions-after-stopping-the-server)までセッションはオフラインになります。リモートマシン上のターミナルから `claude` を実行する場合は、SSH から切断した後もセッションが実行され続けるように、`tmux` または `screen` の中で起動してください。
* **サーバーモードでクラッシュしたセッション**: `claude remote-control` で提供されているセッションがクラッシュした場合は、接続済みのデバイスからそのセッションにメッセージを送信してください。Claude Code がそのセッションを再び提供します。サーバーを再起動する必要はありません。Claude Code v2.1.238 以降が必要です。
* **接続済みセッションでの HTTP 403 拒否**: 対話型セッションが接続されると、VPN やネットワークの変更後などに、マシンと Anthropic のサーバーの間にある何かが HTTP 403 で応答した場合、Claude Code は最大 3 分間再試行を続けます。拒否がそれより長く続くと Claude Code は切断し、その理由として拒否したもの（ネットワークエッジ、または自分のネットワーク上のプロキシ、VPN、ファイアウォール）が示されます。
* **長時間のネットワーク障害**: マシンがスリープしていないのにネットワークに到達できない場合、次に行うことはモードによって異なります。
  * **サーバーモード**: Claude Code は約 10 分後に諦め、`claude remote-control` プロセスが終了します。新しいセッションを開始するには、`claude remote-control` を再度実行してください。
  * **対話型セッション**: ローカルで作業を続けてください。Claude Code は障害が続く間再試行を続け、ネットワークが復旧すると自動的に再接続します。
* **ダウンロードされない添付ファイル**: スマートフォンやブラウザから添付したファイルをマシンにダウンロードできない場合でも、Claude はメッセージとダウンロードできたファイルを受け取ります。欠けているファイルの代わりに、Claude Code は `[1 of 3 attachments did not arrive]` のような注記をメッセージに追加します。
* **プレゼンスハートビートの失敗**: 対話型セッションが `could not reach the Remote Control server for about 30 minutes` で切断された場合は、`/remote-control` を実行して再接続してください。
* **転送されたダイアログの有効期限**: Claude Code は、権限プロンプトと `AskUserQuestion` の質問を、回答するまで開いたままにします。安全性による拒否の後に表示されるモデル選択プロンプトなど、別の種類のダイアログを Claude Code がリモートセッションに転送した場合は、デフォルトで 5 分間待機した後、ダイアログを閉じて、そのダイアログの何もしないデフォルトで続行します。期限を調整または無効にするには、[`dialogExpiry`](/docs/ja/settings-reference#dialogexpiry) を設定してください。Claude Code v2.1.224 以降が必要です。
* **Fable の使用クレジット同意プロンプトは転送されない**: Claude Code は、セッション中の [Fable の使用クレジット同意プロンプト](/docs/ja/model-config.md#fable-and-usage-credits)を、デバイス上ではなくセッションが実行されている場所でのみ表示します。セッションがターミナルで実行されていて、Claude Code がプロンプトを閉じる前にそこで誰も回答しなかった場合、ターンはリクエストを送信せずに終了します。[The prompt to confirm went unanswered](/docs/ja/errors.md#the-prompt-to-confirm-went-unanswered) を参照してください。
* **一部のコマンドはローカル専用**: `/plugin` や `/resume` など、ターミナルインターフェースでのみ実行されるコマンドは、引数を渡すかどうかにかかわらず、ローカルの CLI からのみ動作します。`/claude-api` も、モバイルや Web から入力した場合は使用できません。ただし、そこでも Claude は[そのスキルを自ら読み込む](/docs/ja/skills.md#work-on-claude-api-projects)ことができます。以下はモバイルと Web から動作します。
  * テキスト出力コマンド: `/compact`、`/clear`、`/context`、`/usage`、`/exit`、`/usage-credits`、`/recap`、`/reload-plugins`。`/usage-credits` はブラウザを開く代わりに請求 URL を出力します。`/reload-plugins` は、セッションが対話型ターミナルで実行されている場合にのみ動作します。対話型ターミナルのないセッションではこのコマンドは拒否されます。
  * `/model`、`/effort`、`/fast`、`/color`、`/rename`: 値を引数として渡します（例: `/model sonnet` や `/effort high`）。モバイルと Web からは、`/model` と `/effort` はターミナルのピッカーやスライダーの代わりに引数を受け取ります。
  * `/mcp`: モバイルアプリからは、ピッカーを開く代わりにサーバーのステータスのテキスト要約を返します。Web では、`/mcp` を単独で実行すると、要約を返す代わりに [claude.ai コネクタ](/docs/ja/mcp.md#use-mcp-servers-from-claude-ai)のディレクトリが開きます。`reconnect`、`enable`、`disable` の[サブコマンド](/docs/ja/commands.md#all-commands)は、セッションが対話型ターミナルで実行されている場合、どちらからでも動作します。サーバー名を指定しない `/mcp reconnect` は、失敗した、または認証が必要なすべてのサーバーを再試行します。ピッカーを使わずに claude.ai コネクタを認可するには、[シェルからコネクタを再度認可する](#authorize-a-connector-again-from-your-shell)を参照してください。
  * `/config`: モバイルアプリからは、`key=value` を渡して設定を変更するか、引数なしで実行して設定可能なキーを一覧表示します。Web では、`/config` は代わりに設定の Claude Code セクションを開きます。
  * Team と Enterprise では、モバイルや Web からの `/usage-credits` は[管理者への使用クレジットのリクエスト](/docs/ja/costs.md#add-usage-credits-to-your-subscription)を送信しません。送信には対話型 CLI でのみ表示される確認が必要なため、このコマンドは代わりにそちらで実行するよう案内します。
  * `/autocompact`（v2.1.221 以降）: ウィンドウサイズを引数として渡します（例: `/autocompact 500k`）。引数なしの場合、ターミナルセッションでこのコマンドが表示するダイアログを開く代わりに、現在のウィンドウサイズをテキストとして出力します。
  * `/advisor`（v2.1.260 以降）: モデルを引数として渡すか（例: `/advisor opus`）、`off` を渡してアドバイザーをオフにします。どちらの形式も現在のセッションにのみ適用され、保存済みのデフォルトは変更されません。引数なしの場合、ピッカーを開く代わりに現在のアドバイザーをテキストとして出力します。
  * `/output-style`（v2.1.269 以降）: スタイル名を引数として渡すか（例: `/output-style concise`）、引数なしで実行してスタイルを一覧表示します。モバイルと Web からは、[組み込みスタイル](/docs/ja/output-styles.md#built-in-output-styles)のみを一覧表示・選択できます。[カスタムスタイル](/docs/ja/output-styles.md#create-a-custom-output-style)を使用するには、セッション自体で選択してください。
  * `/focus`（v2.1.281 以降）: `on` または `off` を引数として渡すか（例: `/focus on`）、引数なしで実行して[フォーカスビュー](/docs/ja/commands.md#all-commands)を切り替えます。どちらの形式も現在のセッションにのみ適用され、保存済みの選択は変更されません。

## シェルからコネクタを再度認可する

Remote Control で操作しているセッションで claude.ai コネクタの認証が必要になった場合、モバイルアプリや Web からは `/mcp` パネルを利用できません。セッションが実行されているマシン上のターミナルから認可リンクを取得し、使用しているデバイスでそのリンクを開いてください。このコマンドはモバイルアプリや Web からは実行できません。そこから送信した `!` で始まる行は Claude へのメッセージとして送られ、[シェルモード](/docs/ja/interactive-mode.md#shell-mode-with-prefix)では実行されません。

**1. 認可リンクを取得する**

セッションが実行されているマシン上のターミナル（SSH 経由など）で、コネクタ名を引用符で囲んで `claude mcp login` を実行します。コネクタ名は `claude.ai` で始まります。たとえば Slack コネクタの場合は `claude.ai Slack` です。次のコマンドは Slack コネクタのリンクを取得します。

```bash theme={null}
claude mcp login "claude.ai Slack" --no-browser
```

このコマンドは claude.ai のリンクを出力して終了します。ブラウザでリンクを開き、claude.ai で認可を完了してください。`--no-browser` を指定すると、コマンドがそのマシン上でブラウザを開かなくなります。そのマシンは、使用しているデバイスとは限らないためです。

**2. セッションでコネクタを使用する**

新しいセッションを開始するか、すでに実行中のセッションでコネクタを再接続します。

* **新しいセッション**：認可後に開始したセッションは、追加の手順なしでコネクタに接続します。
* **実行中のセッション**：Claude Code のプロンプトで、またはモバイルアプリや Web から、同じ名前を引用符なしで指定して `/mcp reconnect` を実行します。セッションがモバイルアプリや Web からこのコマンドを受け付けるかどうかを確認するには、[モバイルと Web から使用できるコマンド](#limitations)の `/mcp` の項目を参照してください。

次のコマンドは Slack コネクタを再接続します。

```text theme={null}
/mcp reconnect claude.ai Slack
```

ターミナルでは、Claude Code が `Successfully reconnected to claude.ai Slack` と出力します。モバイルアプリや Web からの場合、応答は `Reconnected "claude.ai Slack".` です。

## トラブルシューティング

### "Remote Control requires a claude.ai subscription"

claude.ai アカウントでサインインしていないか、別の認証情報がログインより優先されています。メッセージは以下のいずれかの形式です。

* サインアウト状態で `/remote-control` または `--remote-control` から：`Remote Control requires a claude.ai subscription.` または `/remote-control requires a claude.ai subscription.`
* サインアウト状態で `claude remote-control` から：`You must be logged in to use Remote Control. Remote Control is only available with claude.ai subscriptions.`
* サインイン状態だが API キーまたはトークンが使用中：`Remote Control requires claude.ai subscription auth.` の後に、使用中の認証情報（例：`ANTHROPIC_API_KEY is set, so this session is using API-key auth`）が続きます。`apiKeyHelper` 設定と `ANTHROPIC_AUTH_TOKEN` も同じ方法で名前が示されます。

`claude auth login` を実行して claude.ai オプションを選択してください。メッセージが `ANTHROPIC_API_KEY` または `ANTHROPIC_AUTH_TOKEN` を名前に挙げている場合は、それが設定されている場所（シェル環境または [設定ファイル](/docs/ja/settings-reference.md#env) の `env` ブロック）から削除してください。`apiKeyHelper` を名前に挙げている場合は、その設定を削除してください。

### "Remote Control requires a full-scope login token"

`claude setup-token` または `CLAUDE_CODE_OAUTH_TOKEN` 環境変数から取得した長期トークンで認証されています。これらのトークンはモデルリクエストのみを実行できるため、Remote Control セッションを確立できません。代わりに `claude auth login` を実行して、フルスコープセッショントークンで認証してください。

### "Unable to determine your organization for Remote Control eligibility"

キャッシュされたアカウント情報が古いか不完全です。`claude auth login` を実行してリフレッシュしてください。

### "Remote Control isn't enabled for this account"

Claude Code は、サインインしているアカウントの Remote Control 利用可能性を確認し、チェック結果がオフでした。通常の原因は、プラン変更後に期限切れになったキャッシュされた権限です。`claude auth logout` を実行してから `claude auth login` を実行してリフレッシュし、古いバージョンを使用している場合は Claude Code を更新してください。

`claude doctor` を実行して、どの個別の適格性チェックが失敗したかを確認してください。環境変数の競合、到達不可能なチェック、および組織の Remote Control 設定はそれぞれ独自のメッセージを生成するため、このエラーはアカウントレベルのチェック自体を意味します。

v2.1.239 より前では、このメッセージは「Remote Control is not yet enabled for your account」と表示されていました。

### "Couldn't verify Remote Control eligibility"

Claude Code は、Remote Control がアカウントに対して有効になっているかどうかを確認するためにフィーチャーフラグサービスに到達できませんでした。通常の原因は、オフラインであるか、プロキシがリクエストをブロックしていることです。ネットワークアクセスが可能になったら再試行するか、詳細については `claude doctor` を実行してください。関連メッセージ「Couldn't verify your organization's Remote Control policy」は、Claude Code がそのポリシーの読み取りでエラーに遭遇したことを意味し、同じ修正方法があります。

### "Remote Control requires feature-flag evaluation"

フィーチャーフラグ評価をオフにする [環境変数](/docs/ja/env-vars.md#features-that-need-feature-flag-fetching) が設定されており、完全なメッセージは Claude Code が見つけた変数を名前に挙げています。v2.1.154 より前のバージョンでは、同じ設定により「Remote Control is not yet enabled for your account」が代わりに生成されます。実行する内容は、メッセージが名前に挙げている変数によって異なります。

* **`CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC` または `DISABLE_GROWTHBOOK`**：シェル環境または [`settings.json` ファイル](/docs/ja/settings-reference#all-settings) の `env` ブロックで設定されている場所から変数を設定解除してください。
* **`DISABLE_TELEMETRY` または `DO_NOT_TRACK`**：Pro、Max、Team、または Enterprise プランで `DISABLE_GROWTHBOOK` が設定解除されている場合、これらの変数は組織が [Trusted Devices](#trusted-devices) を要求しない限り Remote Control を利用可能なままにします。要求する場合は、Remote Control を使用するために変数を設定されている場所から設定解除してください。v2.1.154 から v2.1.282 までは、どちらかの変数が設定されているとこのメッセージが表示されるため、[これらの変数の要件](#requirements)を満たすバージョンに Claude Code を更新してください。

### "Remote Control is only available when using Claude via api.anthropic.com"

セッションが Anthropic API と直接通信していませんが、Remote Control にはこれが必要です。これは Amazon Bedrock、Google Cloud の Agent Platform、および Microsoft Foundry で発生します。また、[`ANTHROPIC_BASE_URL`](/docs/ja/env-vars) が `api.anthropic.com` 以外のホスト（[LLM ゲートウェイ](/docs/ja/llm-gateway) やプロキシなど）を指している場合にも発生します。claude.ai でサインインしている場合でも同様です。完全な原因リストについては、[エラーリファレンス](/docs/ja/errors.md#remote-control-requires-the-anthropic-api) を参照してください。

メッセージは、セッションを Anthropic API から遠ざけたもの（`CLAUDE_CODE_USE_BEDROCK` やカスタム `ANTHROPIC_BASE_URL` など）を名前に挙げています。適格な claude.ai ログインがある場合は、名前に挙げられた変数を設定解除し、[設定](/docs/ja/settings.md) の `env` キーで設定した場合はそこから削除して、セッションを再起動してください。

### "Remote Control is disabled by your organization's policy"

ポリシーが Remote Control をブロックしています。以下の原因を順番に確認してください。

* **エラーが `disableRemoteControl` に言及している**：IT 管理者が [管理設定](/docs/ja/managed-settings.md) を通じてこのデバイスで Remote Control を無効にしており、組織全体のトグルおよびサインイン方法とは無関係です。
* **claude.ai プランが Pro または Max である**：Claude Code は以前のログインから Team または Enterprise 組織の下でまだサインインしているため、その組織の Remote Control ポリシーをチェックします。`/status` を実行して、サインインが使用するプランと組織を確認してください。`claude auth logout` を実行してから `claude auth login` を実行して、現在のプランの下で再度サインインしてください。
* **メッセージが組織管理者に連絡するよう指示していない**：組織に [HIPAA 設定](/docs/ja/hipaa-setup.md) が適用されており、これにより Remote Control がオフになっています。確認するには、`/status` を実行し、`Organization configuration` 行に `HIPAA` があるかを確認してください。Owner には [管理設定](https://claude.ai/admin-settings/claude-code) の **Remote Control** トグルがグレーアウトして表示され、オンにすることはできません。この設定について質問がある場合は、Owner に問い合わせてください。Owner は組織の Anthropic アカウントチームに連絡できます。v2.1.267 より前では、このケースは「Remote Control isn't available for your organization due to its compliance policy」と表示されていました。
* **組織内の他のユーザーは Remote Control を使用できるが、自分は使用できない**：Enterprise 組織が [カスタムロール](https://support.claude.com/en/articles/13930452) でアクセスを管理している場合、ロールが原因である可能性があります。Remote Control には、クラウドセッションの権限と **Claude Code remote control** 権限の両方が必要です。Owner に、ロールに両方が含まれているかを確認し、不足しているものを [**Organization settings > Roles**](https://claude.ai/admin-settings/roles) で追加するよう依頼してください。
* **それ以外の場合、Owner が組織に対して有効にしていない**：Remote Control は Team および Enterprise プランではデフォルトでオフです。Owner は [claude.ai/admin-settings/claude-code](https://claude.ai/admin-settings/claude-code) で **Remote Control** トグルをオンにすることで有効にできます。このトグルはサーバー側の組織設定です。

v2.1.281 より前では、このメッセージは Claude Code がこのマシンで組織のポリシーを読み込んでいない場合（例えば、オフラインで開始した後）にも表示されていました。後のバージョンではその状態を [`Couldn't verify your organization's policy for remote control`](#couldnt-verify-your-organizations-policy-for-remote-control) として報告します。

### "Remote Control was turned off by your organization's policy"

セッションの接続中に組織のポリシーが Remote Control を許可しなくなったため、Claude Code はセッションを切断しました。セッションがどうなるかは、Remote Control をどのように開始したかによって異なります。

* **`/remote-control`、`claude --remote-control`、または [自動接続](#enable-remote-control-for-all-sessions) で開始した場合**：セッションは Remote Control なしで実行し続け、Claude Code は claude.ai でそのセッションをアーカイブします
* **`claude remote-control` で開始した場合**：サーバーは停止し、提供していたセッションをアーカイブしてから終了します

アーカイブされたセッションは、[アーカイブされたセッションでフィルタリング](/docs/ja/claude-code-on-the-web.md#archive-sessions)することで引き続き見つけられます。

Remote Control は自動的には再接続しません。組織が再び許可した後にオンに戻すには、セッションで `/remote-control` を実行するか、シェルで `claude remote-control` を実行してください。このマシンの Claude Code が変更されたポリシーを取得するまで、どちらのコマンドも [`Remote Control is disabled by your organization's policy`](#remote-control-is-disabled-by-your-organizations-policy) で失敗します。開いているセッションは約 1 時間に 1 回ポリシーを取得します。Remote Control をブロックしている原因を確認するには、コマンドが出力する完全なテキストをその項目と照合してください。

### "Couldn't verify your organization's policy for remote control"

Claude Code は組織のポリシーを取得できず、代わりに使用するためにこのマシンに保存されたコピーがないため、組織がそれを許可していることを確認できるまで Remote Control をオフのままにしておきます。これは通常、Claude Code をオフラインで開始するか VPN が接続する前に開始する場合、またはプロキシがリクエストに干渉する場合に発生します。遅い接続では、最初のリクエストがまだ進行中の間に表示されることもあります。

メッセージは以下のいずれかの形式です。

* `/remote-control`、`claude remote-control`、または `claude --remote-control` から：`Couldn't verify your organization's policy for remote control. Check your network connection and try again.`
* [自動接続](#enable-remote-control-for-all-sessions) からセッション開始時：`couldn't verify your organization's policy — check your network connection and try again`。通知では `Remote Control failed` が前に付き、会話では `Remote Control disconnected` が前に付きます。その後、セッションは Remote Control をオフのままにします。

ネットワーク接続を復元してから、`/remote-control` を実行するか、コマンドを再度実行してください。各試行はポリシーを再度チェックするため、Claude Code を再起動する必要はありません。メッセージが表示され続ける場合は、`claude doctor` を実行し、その `Organization policy` 行を読んでください。ポリシーが読み込まれなかった理由が表示されます。

v2.1.281 より前では、この状態は `Remote Control is disabled by your organization's policy` と表示されていました。

### "Remote credentials fetch failed"

Claude Code は、接続を確立するために Anthropic API から短期認証情報を取得できませんでした。`--verbose` で再実行して完全なエラーを確認してください。

```bash theme={null}
claude remote-control --verbose
```

一般的な原因：

* サインインしていない：`claude` を実行して `/login` を使用して claude.ai アカウントで認証してください。API キー認証は Remote Control ではサポートされていません。
* ネットワークまたはプロキシの問題：ファイアウォールまたはプロキシが送信 HTTPS リクエストをブロックしている可能性があります。Remote Control には、ポート 443 の Anthropic API へのアクセスが必要です。
* セッション作成失敗：`Session creation failed — see debug log` も表示される場合、失敗はセットアップの前の段階で発生しました。サブスクリプションがアクティブであることを確認してください。

### "Couldn't reconnect to your Remote Control session"

`claude --resume` または `claude --continue` で会話を再開すると、Claude Code はその会話に記録された Remote Control セッションに再接続します。このメッセージは、ネットワーク中断やサーバーエラーなど、一時的である可能性がある理由で再接続が失敗したことを意味するため、Claude Code はリモートセッションがまだ存在するかどうかを確認できません。

`/remote-control` を実行して接続を再試行するか、`claude --remote-control` で新しいセッションを開始して新しい Remote Control セッションを作成してください。その間、ローカルセッションは Remote Control なしで実行し続けます。

### "Previous session is unavailable — run /remote-control to start a new one"

Claude Code は前の Remote Control セッションを復元できず、自動的に新しいセッションを開始する代わりに停止しました。`claude --resume` または `claude --continue` で会話を再開した後、または Claude Code が [切断後に自動的に再接続](/docs/ja/errors.md#remote-control-couldnt-refresh-your-login) した後に、このメッセージが表示される場合があります。

`/remote-control` を実行して、現在のログインの下で新しい Remote Control セッションを開始してください。その間、ローカルセッションは Remote Control なしで実行し続けます。関連メッセージ `Remote Control could not verify the signed-in account — run /remote-control to reconnect` も同じ方法で修正できます。`Previous session is unavailable` の後に Claude Code を再起動せずに `/remote-control` を実行する場合、Claude Code は会話の以前のメッセージを新しいセッションから除外します。

### "Remote Control got an unexpected server response"

Remote Control サーバーはリクエストを受け入れましたが、リモートセッションを作成するか認証情報を取得する際に、このバージョンの Claude Code が読み取れない形式で応答しました。同じバージョンで再試行すると同じ方法で失敗します。`claude update` を実行してから、`/remote-control` を実行して再接続してください。

### "Your organization requires Trusted Devices for Remote Control, but this device is not enrolled"

組織は [Trusted Devices](#trusted-devices) を有効にしており、このマシンはまだ登録されていません。Claude Code で `/login` を実行してください。登録はサインインの一部として行われ、個別の登録コマンドはありません。

### "session expired for trusted-device check"

サインインが 18 時間以上前のものです。Claude Code で `/login` を実行するか、claude.ai またはモバイルアプリが Face ID、Touch ID、Windows Hello、またはパスキーで確認するよう求めるときに確認してください。[Trusted Devices](#trusted-devices) を参照してください。

## 関連リソース

* [Web 上の Claude Code](/docs/ja/claude-code-on-the-web.md): マシン上ではなくクラウドでセッションを実行します。[クラウド環境](/docs/ja/cloud-environments.md)を通じて設定します
* [クロスセッションメッセージング](/docs/ja/cross-session-messaging.md): Claude が他のマシンまたは [クラウドセッション](/docs/ja/claude-code-on-the-web.md)上のセッションにメッセージを送信できるようにします
* [チャネル](/docs/ja/channels.md): Telegram、Discord、または iMessage をセッションに転送して、Claude が離席中にメッセージに反応するようにします
* [Dispatch](/docs/ja/desktop.md#sessions-from-dispatch): 電話からタスクをメッセージして、Desktop セッションを生成して処理できます
* [認証](/docs/ja/authentication.md): `/login` をセットアップし、claude.ai の認証情報を管理します
* [CLI リファレンス](/docs/ja/cli-reference.md): `claude remote-control` を含むフラグとコマンドの完全なリスト
* [セキュリティ](/docs/ja/security.md): Remote Control セッションが Claude Code セキュリティモデルにどのように適合するか
* [データ使用](/docs/ja/data-usage.md): ローカル、Remote Control、およびクラウドセッション中に Anthropic API を通じてどのようなデータが流れるか
