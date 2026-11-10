> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# 他の Claude Code セッションにメッセージを送信する

> Claude が同じマシン上の他の Claude Code セッションをリストアップしてメッセージを送信できるようにし、他のマシンまたはクラウド上のセッションに到達します。

> [!NOTE]
>
> クロスセッションメッセージングには、macOS と Linux（WSL 2 内の Linux を含む）で Claude Code v2.1.224 以降が必要です。ネイティブ Windows では、Claude Code v2.1.234 以降が必要です。セッションが要件を満たしている場合、メッセージングは有効になっており、有効にするものはありません。プロバイダー要件とセッションがそれを持っていることを確認する方法については、[利用可能性](#availability)を参照してください。

クロスセッションメッセージングにより、Claude は一つの Claude Code セッションから別のセッションにメッセージを配信できます。一つのセッションでの変更が別のセッションが構築しているものを破壊する場合、Claude はあなたが気付く前にそのセッションに警告することができます。一つのセッションが別のセッションがブロックされている質問を解決する場合、Claude は答えを送信することができます。

メッセージは、一つの Claude が別の Claude に書くテキストの一部であり、送信者の会話履歴またはファイルではありません。会話全体またはそのコンテキストを移動するには、代わりに[セッションを再開](https://code.claude.com/docs/ja/sessions.md#resume-a-session)してください。

## クロスセッションメッセージングを使用する場合

1 つのセッションが別のセッションが必要とするものを持っている場合にメッセージングを使用します。Claude は必要に応じて自動的にメッセージを送信できます。たとえば、別のセッションが実行している作業に影響する変更を加えた後、または送信するよう求めることができます。一般的なケースは次のとおりです。

* **検出結果を引き継ぐ**: 1 つのセッションが破壊的な変更を発見するか決定を下すと、Claude はそれを影響を受ける領域で作業しているセッションに要約します。そこで再度説明する代わりに。
* **並列ワークツリーを調整する**: セッションが別の[ワークツリー](https://code.claude.com/docs/ja/worktrees.md)で同じリポジトリで作業する場合、Claude は他のセッションに何がマージされたかを伝えることができます。
* **長時間実行される作業からステータスを取得する**: マイグレーションまたはテスト実行を監視しているセッションに報告させるか、そこから自分で尋ねます。そのセッションがこのマシン上にある場合、Claude は[次にアイドル状態になるか終了するときに 1 つの通知を求める](#get-a-notice-when-another-session-goes-idle)こともできます。
* **マシン間でメッセージを送信する**: 別のマシンまたはウェブ上の 1 つのセッションに到達します。

## 別のセッションにメッセージを送る

あるセッションが、発見した事実、ステータス、決定事項など、別のセッションが必要とする情報を得たときは、ターミナル間でコピー＆ペーストする代わりに Claude がそれを伝えます。Claude は `ListAgents` で送信先を見つけ、`SendMessage` で送信するため、どちらのツールもユーザー自身が呼び出す必要はありません。Claude は頼まれなくてもメッセージを送ることを判断できますし、プロンプトで送信を指示することもできます。

自分で指示するには、別のセッションに知らせたいことや、してほしいことを Claude に伝えます。次の例は、Claude が送るメッセージではなく、ユーザーが入力するプロンプトです。

```text wrap theme={null}
Ask the session running in my other terminal whether the migration finished
```

実際のメッセージは Claude 自身が書くため、プロンプトでは内容を Claude に任せることができます。次のプロンプトは文言を指定せずに要約を求めるもので、Claude が送る内容は毎回異なります。

```text wrap theme={null}
Explain what we just did to the session working on the payments API
```

送信先を自分で指定するには、プロンプト内でセッションをメンションします。[サブエージェントを @ メンションする](https://code.claude.com/docs/ja/sub-agents.md#invoke-subagents-explicitly)のと同じ方法で、`@` に続けてセッション名の先頭の数文字を入力し、入力候補からセッションを選びます。Claude Code v2.1.232 以降が必要です。Claude Code は `@api-worker` のようなメンションを挿入し、それがどのセッションを指すかを Claude に伝えるため、Claude はセッションの一覧を取得せずにそのセッションへメッセージを送れます。次のプロンプトは、メンションで送信先を指定しています。

```text wrap theme={null}
Let @api-worker know the schema migration finished
```

入力候補には、このマシン上で実行中の他のセッションが表示されます。次の 2 つの場合は、名前の先頭の数文字を入力するだけでは足りません。

* **このマシン以外のセッション**: クラウドセッションや Remote Control セッションは、Claude がこのマシン以外のセッションの一覧を取得するか、それらにメッセージを送った後でなければ入力候補に表示されません。そのため、まず Claude に一覧を取得するよう依頼してください。
* **スペースや、英字、数字、ハイフン、アンダースコア以外の文字を含む名前**: `@"release notes"` のように二重引用符で囲んで入力します。入力候補からセッションを選ぶと、Claude Code が引用符を自動で挿入します。

候補を使わずにメンションを入力することもできます。メンションした名前に該当する実行中のセッションが複数ある場合、Claude は送信前にどのセッションを指しているかをユーザーに確認します。

Claude が書いたメッセージが届いたときにどのように見えるか（例を含む）については、[メッセージの見え方](#what-a-message-looks-like)を参照してください。

### メッセージの配信

受信側の Claude は、アクティブなターン中のツール呼び出しの合間にメッセージを読みます。受信側のセッションがアイドル状態の場合、Claude Code はそのメッセージで新しいターンを開始します。

別のセッションからのメッセージはプレーンテキストとして届きます。メッセージが `@` でファイルや [MCP リソース](https://code.claude.com/docs/ja/mcp.md#use-mcp-resources)をメンションしていても、Claude には書かれたとおりのメンションが見えるだけで、Claude Code は何も添付しません。これは、メッセージが新しいターンを開始する場合もターン中に届く場合も同じです。ただし Claude は、受信側セッションの権限の範囲内で、自身のツールを使って受信側マシン上のメンションされたパスを開くことができます。

Claude Code は次の場合にメッセージを拒否します。

* メッセージが[サイズ上限を超えている](#limitations)。Claude Code は送信側のセッションで、メッセージが送出される前に拒否します。
* このマシン上のセッションへの短時間の連続送信が、[そのセッションの受信箱が受け付ける量](#limitations)に達した。Claude Code はそのセッションへのそれ以上のメッセージを拒否します。
* このマシン以外のセッションが、[クロスセッションメッセージを受信できないと一覧に表示されている](#message-sessions-on-other-machines)。Claude Code は送信側のセッションで、メッセージがこのマシンから送出される前に拒否します。
* このマシン上の返信先が、シンボリックリンクされた送信先など、安全性チェックに失敗した。これらのチェックについては [Refusing to send a cross-session message](https://code.claude.com/docs/ja/errors.md#refusing-to-send-a-cross-session-message) を参照してください。

受信側のセッションは、届いた各メッセージを自身の[受信制御](#control-inbound-messages)と照合し、そのチェックは次の 3 つの結果のいずれかになります。

* **配信**: Claude Code はメッセージを受信側の Claude に渡します。
* **保留**: Claude Code はメッセージを配信せずに保留します。保留されたメッセージが Claude に届くのは、ユーザーが承認したとき、または後のモードや設定の変更で許可されたときだけです。
* **拒否**: Claude Code はメッセージを配信せずに破棄します。

配信されたメッセージは、ユーザーが入力するプロンプトと同様に[使用量](https://code.claude.com/docs/ja/costs.md)にカウントされます。受信側の Claude は `SendMessage` で送信元に返信できます。ただし、[他のマシンやクラウドセッションからの返信](#replies-from-other-machines-and-cloud-sessions)と[クロスセッションメッセージをオフにする](#turn-off-cross-session-messaging)で説明する場合を除きます。

権限の境界はセッションごとに維持されます。Claude は、自身のセッションで拒否またはブロックされた操作や、自身の権限設定でブロックされるはずの操作を別のセッションに依頼しないよう指示されており、そうした作業はユーザーに差し戻します。受信側では、メッセージが求めるあらゆる操作に対して、[受信側セッション自身の権限プロンプトとルールが引き続き適用されます](#how-a-session-treats-an-incoming-message)。

### 別のセッションがアイドルになったときに通知を受け取る

Claude は、このマシン上のセッションの 1 つに対し、そのセッションが次にアイドル状態になったとき、または終了したときに通知を 1 件返すよう依頼できます。ここでのアイドルとは、セッションがキューに何も残さずにターンを終えた状態を指します。別のセッションで長時間のタスクを待っていて、確認しに行く代わりに完了したときに知らせてほしい場合に使います。両方のセッションで Claude Code v2.1.236 以降が必要です。

#### 通知を依頼する

何を待っているかを Claude に伝えます。次のプロンプトは、マイグレーションのセッションからの通知を依頼します。

```text wrap theme={null}
Tell me when the migration session finishes what it's working on
```

Claude は `SendMessage` ツールの `notify_when_idle` 入力を使ってサブスクライブします。これは、いずれにせよ送るメッセージに付けることも、単独で使うこともできます。単独の場合、Claude Code は監視対象のセッションでターンを開始したりトークンを消費したりせずにサブスクライブし、そのセッションがすでにアイドル状態であればすぐに通知を送ります。メッセージに付けた場合、Claude Code はまずメッセージを配信し、後で通知を送ります。

#### 各セッションの表示内容

監視対象のセッションには、別のプロセスがこのセッションが次にアイドルになったときに知らせるよう依頼した旨の行が表示されます。依頼したセッションには、監視対象のセッション名を示す行として通知が表示されます。この行には、そのセッションのターンが終了した時刻と、そのターンの 1 行のステータスが含まれる場合があります。依頼したセッションがアイドル状態の場合、Claude Code はその通知で新しいターンを開始します。

#### 制限

12 時間以内に通知が届かない場合、Claude Code はサブスクリプションを破棄して Claude に伝えるため、Claude が待ち続けることはありません。

通知にも、メッセージと同様に各側の[受信制御](#control-inbound-messages)が適用されます。

* **どちらかの側が `refuse`**: 何も届きません。監視対象のセッションはリクエストを記録も応答もせずに破棄するため、サブスクリプションは 12 時間後に応答がないまま期限切れになります。また、`refuse` の依頼側セッションはサブスクライブしません。
* **どちらかの側が `hold`**: 通知は内容が減った状態で届きます。監視対象のセッションは 1 行のステータスを省き、依頼側のセッションは通知を Claude に配信せずにトランスクリプトに表示します。

サブスクライブできるのはメインの会話の Claude だけで、対象はこのマシン上のユーザーのセッションに限られます。チームメイト、サブエージェント、このマシン以外のセッションなど、それ以外の対象に Claude が通知を求めた場合、Claude Code は付随するメッセージも含めて呼び出し全体を拒否します。

### Claude が到達できるセッションを確認する

Claude はメッセージの送信先を自分で見つけるため、送信を依頼する前に何かを実行する必要はありません。Claude が到達できるセッションを自分で確認するには、`/list-agents` コマンドを実行します。最初の行がある場合、それはこのセッション自身の名前で、他のセッションがこのセッションにメッセージを送る際に使う名前です。その下の行は、Claude が到達できるセッションです。

* **サブエージェント**: 現在のセッション内で実行中のエージェント。
* **チームメイト**: このセッション自身の[エージェントチーム](https://code.claude.com/docs/ja/agent-teams.md)のチームメイト。
* **他のローカルセッション**: [バックグラウンドセッション](https://code.claude.com/docs/ja/agent-view.md)を含む、同じマシン上で実行中の Claude Code セッション。セッションが表示されるのは、[受信箱ソケット](#the-sessions-inbox-socket)をバインドしている場合だけです。
* **[クラウドセッション](https://code.claude.com/docs/ja/claude-code-on-the-web.md)**: このセッションが [Remote Control](https://code.claude.com/docs/ja/remote-control.md) に接続している間に表示されます。
* **他のマシン上の Remote Control セッション**: このセッションが [Remote Control](https://code.claude.com/docs/ja/remote-control.md) に接続している間に表示され、`Remote Control` というラベルが付きます。Remote Control 接続が切断されたセッションのステータスには、Claude Code が `offline` と表示します。

このセッションが [Remote Control](https://code.claude.com/docs/ja/remote-control.md) に接続している間、Claude Code は `/list-agents` の出力からローカルセッションの詳細の一部を伏せます。ただし、メッセージの送信先を探す際に Claude 自身が見る内容は変わりません。

* **作業ディレクトリ**: 各ローカルセッションの作業ディレクトリを省きます。
* **セッション名**: 人に帰属させられないセッション名を省くため、名前がなくなった行は `(unnamed session)` と表示されます。
* **最初の行**: セッションを起動または最後に再開してから、このターミナルで `--name` または `/rename` と名前を使ってその名前を入力していない限り、このセッション自身の名前を示す行を省きます。

出力に何かが表示される場合、末尾に詳細が伏せられたことを示す注記が付きます。セッション自身のキーボードで `/rename` に続けて未使用の名前を実行すると、そのセッションに出力に表示される名前が付きます。

セッションは、[`/rename`](https://code.claude.com/docs/ja/commands) コマンドまたは [`--name`](https://code.claude.com/docs/ja/cli-reference#cli-flags) フラグで設定した名前に応答します。名前を設定しない場合は、Claude Code がセッションに名前を付けます。対話型セッションの場合、それは[実行中のセッションの一覧](https://code.claude.com/docs/ja/sessions.md#name-your-sessions)に表示される名前です。

このセッションが Remote Control に接続していない限り、Claude Code は `/list-agents` の出力に各ローカルセッションの作業ディレクトリを表示するため、同じ名前のセッションが異なるディレクトリで実行されていても区別できます。Claude は、その名前に応答する実行中のセッションの数に応じて、次の 2 つの方法のいずれかでメッセージの宛先を指定します。

* **その名前に応答するセッションが 1 つの場合**: Claude Code は名前だけでメッセージを配信します。
* **複数のセッションが同じ名前を共有している場合、または Claude Code がセッションの実行場所をすべて確認できなかった場合**: Claude は一覧の各行に短い識別子を付け、その識別子を宛先に使います。

### 他のマシン上のセッションにメッセージを送る

メッセージがどのように伝わるか、また Anthropic のサーバーを経由するかどうかは、送信先のセッションが実行されている場所によって異なります。

| 他のセッションの実行場所 | メッセージの伝わり方 |
| :- | :- |
| このマシン上 | macOS と Linux ではセッションごとのソケット、ネイティブ Windows ではセッションごとの名前付きパイプを経由し、Anthropic のサーバーは経由しません |
| 自分の別のマシン上 | Anthropic のサーバーを経由し、そのマシンの [Remote Control](https://code.claude.com/docs/ja/remote-control.md) 接続を通じて届きます |
| [クラウド](https://code.claude.com/docs/ja/claude-code-on-the-web.md) | Anthropic のサーバーを経由し、クラウドセッションに直接届きます |

自分の別のマシン上のセッションとの会話を開始するには、Claude Code v2.1.225 以降と、[一覧に表示される](#see-which-sessions-claude-can-reach)送信先が必要です。

[一覧](#see-which-sessions-claude-can-reach)のセッションの行には、Claude がそのセッションにメッセージを送ったときの動作を変える状態が表示される場合があります。

* **`offline`**: そのセッションの Remote Control 接続が切断されています。メッセージは送信されますが、届くのはそのセッションのマシンが再接続した後です。
* **`can't receive cross-session messages (off in that session)`**: そのセッションではメッセージ機能が[利用できない](#availability)か、その [`crossSessionInbound`](https://code.claude.com/docs/ja/settings-reference#crosssessioninbound) の値が `refuse` です。Claude Code は、メッセージがこのマシンから送出される前に、そのセッションへのメッセージを拒否します。Claude の `SendMessage` 呼び出しの結果は `Not sent` で始まり、理由が示されます。そのセッションで原因が解消されると、以降の一覧にはこの状態が表示されなくなり、Claude はそのセッションにメッセージを送れるようになります。

コンテナ内のセッションとホスト上のセッションは、互いに到達できません。同じコンテナ内の 2 つのセッションは、[セルフホストランナー](https://code.claude.com/docs/ja/self-hosted-environments)上を含め、引き続き互いにメッセージを送れます。同じコンピューター上の WSL 2 内のセッションとネイティブ Windows のセッションも、互いに到達できません。

このマシンの外にメッセージが送られる前に必ず自分の承認を求めるようにするには、[`isolatePeerMachines`](#require-approval-for-cross-machine-messages) を設定します。

#### 他のマシンやクラウドセッションからの返信

[セルフホストランナー](https://code.claude.com/docs/ja/self-hosted-environments)上のものを含む[クラウドセッション](https://code.claude.com/docs/ja/claude-code-on-the-web.md)は、メッセージに[返信アドレス](#what-a-message-looks-like)が含まれていても、`SendMessage` を使って別のマシンからのメッセージに返信することはできません。メッセージ自体は届きます。クラウドセッションの応答は、[claude.ai/code](https://claude.ai/code) のトランスクリプトで確認してください。

Claude がこのマシン以外のセッションに送信する際にこのセッションが Remote Control に接続していない場合、メッセージは送信されますが、[返信アドレス](#what-a-message-looks-like)は付きません。受信側の Claude はそのメッセージに返信できません。

## セッションが受信メッセージをどのように扱うか

セッション A がセッション B にメッセージを送信する場合、Claude Code は B の Claude に対して、そのメッセージがユーザーからではなく別のセッションから来たことを伝え、メッセージが実行できることを制限します。

* **何も承認できません**: 別のセッションからのメッセージはユーザーの同意としてカウントされないため、ユーザーに代わって保留中の権限プロンプトに応答することはできません。
* **設定を変更できません**: Claude Code は受信側の Claude に対して、別のセッションが要求したため権限設定、`CLAUDE.md`、またはその他の設定を変更しないよう指示します。
* **コマンドは実行されません**: メッセージのテキスト内のコマンド（`/compact` など）はプレーンテキストとして到着します。Claude Code はそれを実行することはありません。
* **権限プロンプトは引き続き発火します**: メッセージに対応するために受信側セッションが持っていない権限が必要な場合、他の作業と同じプロンプトが表示されます。

### メッセージの外観

メッセージが到着すると、Claude Code は会話内に薄い 1 行のプレビューとして表示し、プレビュー行は後で会話に残ります。プレビューには送信者の名前とメッセージの最初の行が含まれ、長い場合は `…` で切られます。例えば `› Message from @api-worker: Schema migration finished (ctrl+o to expand)` のようになります。

以下のいずれかで完全なテキストが表示されます。

* `Ctrl+O` を押して[トランスクリプトビューア](https://code.claude.com/docs/ja/interactive-mode.md#transcript-viewer)を開き、送信者のセッション名の下で完全なテキストを読みます。

  Claude がビジー状態でまだメッセージを受け取っていない場合は、トランスクリプトの末尾までスクロールしてください。メッセージは `Waiting to be delivered` の下に一覧表示されています。Claude Code v2.1.309 以降が必要です。

* [フルスクリーンレンダリング](https://code.claude.com/docs/ja/fullscreen.md#use-the-mouse)では、メッセージの一部が省略されているプレビュー行をクリックすると、その場で展開されます。

* [`--verbose`](https://code.claude.com/docs/ja/cli-reference#cli-flags) で開始されたセッションでは、Claude Code はプレビューではなく完全なテキストを表示します。

プレビューは表示内容のみを短縮します。展開するかどうかに関わらず、Claude はメッセージ全体を読みます。

Claude は送信者の名前と返信アドレスを含むメッセージを受け取ります。ただし、[一方向クロスマシンメッセージ](#message-sessions-on-other-machines)は返信アドレスを含みません。

この例は、ある Claude が別の Claude に書いたメッセージで、展開時の完全なテキストは次のように読まれます。

```text wrap theme={null}
Schema migration finished
The new column is tenant_id, and rebasing on main is safe now.
```

### インバウンドメッセージを制御する

[`crossSessionInbound`](https://code.claude.com/docs/ja/settings-reference#crosssessioninbound) を設定して、セッションが他のセッションから到着するメッセージをどのように処理するかを選択します。

| 値 | 動作 |
| :- | :- |
| `accept` | Claude Code は各メッセージを Claude に配信します |
| `hold` | Claude Code は各メッセージの通知を表示し、配信しません。後で `accept` が適用される場合、[優先順位ルール](https://code.claude.com/docs/ja/settings-reference.md#crosssessioninbound)に従って、Claude Code は保留中のメッセージをリリースします |
| `refuse` | Claude Code は各メッセージを配信せずにドロップします |

設定ファイルを編集する以外に、`/config` 行の **Messages from your other sessions** で値を選択できます。Claude Code は選択した値をユーザー設定に書き込みます。この行には Claude Code v2.1.232 以降が必要で、管理設定または `--settings` フラグがキーを設定している場合は表示されません。ユーザー設定値は適用されないためです。Claude Code はこのキーに対して `/config crossSessionInbound=value` ショートハンドを拒否します。

どの値が適用されるかを確認するには、[設定リファレンス](https://code.claude.com/docs/ja/settings-reference.md#crosssessioninbound)の `crossSessionInbound` 優先順位ルールに従います。

値が適用されない場合、Claude Code は 2 つのセッションの権限モードに基づいてメッセージごとに決定します。[権限プロンプトをバイパス](https://code.claude.com/docs/ja/permission-modes.md#skip-all-checks-with-bypasspermissions-mode)するセッションを 1 つのクラスにグループ化し、他のすべてのセッションを別のクラスにグループ化します。plan モードは、バイパス権限が利用可能なインタラクティブなターミナルセッションではバイパスとしてカウントされ、[auto](https://code.claude.com/docs/ja/permission-modes.md#eliminate-prompts-with-auto-mode)、`acceptEdits`、`dontAsk` はプロンプトとしてカウントされます。

* **受信側セッションが権限をプロンプト**: Claude Code は各メッセージを配信します。送信側セッションが権限プロンプトをバイパスしていることを識別する場合のみ、承認のために 1 つを保留します。
* **受信側セッションが権限をバイパス**: Claude Code は各メッセージを承認のために保留します。送信側セッションも同様にバイパスしていることを識別する場合のみ、1 つを配信します。

インタラクティブなターミナルセッションでデフォルトがメッセージを保留する場合、Claude Code はそのセッションで承認ダイアログを開きます。ダイアログには送信者とプレビューが表示されます。

* **Approve** はそのメッセージを Claude に配信します。
* **Deny** またはダイアログを閉じると、ドロップされます。
* ダイアログが [`dialogExpiry`](https://code.claude.com/docs/ja/settings-reference#dialogexpiry) 期限を過ぎて未回答のままの場合、Claude Code はそれを閉じてメッセージをドロップします。期限のデフォルトは 5 分です。
* [バックグラウンドセッション](https://code.claude.com/docs/ja/agent-view.md)にターミナルが接続されていない場合、Claude Code はダイアログを期限を過ぎて開いたままにします。接続後、ダイアログが完全な期限期間未回答のままの場合、Claude Code はそれを閉じてメッセージをドロップします。
* このセッションの権限モードクラスがメッセージが保留されている間に変更される場合、Claude Code はインバウンドルールを再適用し、現在受け入れるメッセージを配信し、通知を表示します。

VS Code 拡張機能または Desktop アプリのセッションはダイアログを表示できません。その場合、[非インタラクティブセッション](#non-interactive-sessions)で説明しているように、Claude Code は保留中のメッセージを同じ期限まで保持します。

Claude Code は最大 100 個のメッセージを保留し、それを超えると最も古いものをドロップします。

### 非インタラクティブセッション

Claude Code は [`claude -p`](https://code.claude.com/docs/ja/headless) セッションのインボックスソケットをインタラクティブなものと同様にバインドするため、長時間実行される `-p` ワーカーはメッセージを受信でき、リストに表示されます。[bare モード](https://code.claude.com/docs/ja/headless.md#start-faster-with-bare-mode)でセッションを開始する場合、Claude Code はソケットをバインドしないため、そのセッションはメッセージを受信できず、エージェントリストに表示されません。

`-p` セッションは承認ダイアログを表示できません。[インバウンドデフォルト](#control-inbound-messages)がそこでメッセージを保留する場合、Claude Code はダイアログが使用する同じ [`dialogExpiry`](https://code.claude.com/docs/ja/settings-reference#dialogexpiry) 期限（デフォルトは 5 分）でそれを保持します。

* **期限前**: モードまたは設定変更によりメッセージが許可される場合、Claude Code はそれを配信します。
* **期限後**: Claude Code はメッセージをドロップし、到達できる送信者に期限切れとして報告します。

`dialogExpiry` を `"never"` に設定して、デフォルト保留メッセージをセッション終了まで保持します。明示的な `hold` 設定で保留されたメッセージは期限切れになりません。Claude Code は、後で `accept` が適用されたときにそれを配信します。

`-p` ワーカーが無人でメッセージを受け取れるようにするには、その `--settings` 値で `crossSessionInbound` を `accept` に設定して開始します。ユーザー設定の `accept` も機能しますが、実行するすべてのセッションに適用されます。

### セッションのインボックスソケット

期待するセッションがエージェントリストにない場合、スクリプトまたはフックをセッションに投稿したい場合、またはサンドボックス化されたコマンドがソケットに到達できない場合は、このセクションを読んでください。

Claude Code は、クロスセッションメッセージングが有効になっている各セッションのインボックスソケットをバインドします。ここで、マシン上の他のセッションはメッセージを配信します。ソケットは macOS と Linux（WSL 2 内の Linux を含む）では Unix ドメインソケットで、ネイティブ Windows ではネームドパイプです。どのセッションの種類がバインドするかについては、[非インタラクティブセッション](#non-interactive-sessions)を参照してください。

ソケットのパスは 2 つの場所で見つけることができます。

* `/status` は `Peer address` 行に表示します。パスは `uds:` で始まります。
* Claude Code は[フック](https://code.claude.com/docs/ja/hooks.md)と Bash コマンドに [`CLAUDE_CODE_MESSAGING_SOCKET`](https://code.claude.com/docs/ja/env-vars#variables) 環境変数としてエクスポートします。
  * メッセージングがオンで開始するセッションでは、Claude Code は `SessionStart` を含むすべてのフックが実行される前に変数をエクスポートします。

macOS と Linux では、Claude Code はソケットをオペレーティングシステムユーザーに制限します。ネイティブ Windows では、代わりに各接続がまずオペレーティングシステムユーザーのみが読み取ることができるキーで認証することを要求します。どちらの方法でも、共有マシン上の別のユーザーのセッションはそれに配信できません。

macOS と Linux では、Claude Code は受け入れることができないディレクトリ（例えば別のユーザーが所有するディレクトリ）にソケットを作成することも拒否し、代わりにプライベートなユーザーごとのディレクトリ `/tmp/cc-socks-<uid>` を使用します。受け入れることができるディレクトリがない場合、セッションはインボックスなしで実行されます。Claude Code は通知を表示し、`/status` は `Peer address` 行に `unavailable` と理由を表示し、[`--debug`](https://code.claude.com/docs/ja/cli-reference#cli-flags) ログは完全な拒否を記録します。

ソケットのパスと共に、Claude Code はセッションごとのトークンを [`CLAUDE_CODE_MESSAGING_TOKEN`](https://code.claude.com/docs/ja/env-vars#variables) としてエクスポートします。独自のセッションのソケットに投稿するスクリプトは、接続の最初の行として `{"type":"auth","token":"<token>"}` を送信できます。ここで `<token>` は `CLAUDE_CODE_MESSAGING_TOKEN` の値です。Claude Code が行を要求するかどうかはプラットフォームに依存します。

* **macOS と Linux（WSL 2 を含む）**: 行はオプションです。Claude Code は認証行の有無にかかわらず接続を受け入れます。
* **ネイティブ Windows**: 行は必須です。Claude Code は最初の行が有効な認証行でない接続を閉じ、その接続からは何も配信しません。

投稿するメッセージの準備ができたときにのみ接続を開きます。Claude Code は 30 秒以内に完全な行を送信していない接続を閉じるため、遅いコマンドの出力をまずキャプチャしてから接続を開いて送信します。

Claude Code はソケットに到着するメッセージを、1 つの例外と 1 つの前提条件を除いて、他のピアメッセージと同じ[インバウンドコントロール](#control-inbound-messages)を通して実行します。

* **独自の子メッセージ**: `crossSessionInbound` 値が適用されない場合、Claude Code はセッションの独自の子プロセス（フックや Bash コマンドなど）から来たことを検証したメッセージを配信します。これらは独自のセッションのソケットに投稿します。
  * Linux（WSL 2 内を含む）では、Claude Code は既に終了した子についても、プロセス証拠によって検証できます。macOS では、投稿プロセスがまだ実行中の場合のみそのように検証でき、Claude Code がプロセス ID 1 として実行されるコンテナではプロセス証拠がまったくありません。ネイティブ Windows でも同様です。
  * 投稿プロセスが終了した後の macOS と Claude Code がプロセス ID 1 として実行されるコンテナでは、そのプロセス証拠がなく、Claude Code は代わりに接続を開いた認証行でセッションのエクスポートされた [`CLAUDE_CODE_MESSAGING_TOKEN`](https://code.claude.com/docs/ja/env-vars#variables) を送信した子を検証します。ネイティブ Windows では、そのトークンが Claude Code が独自の子メッセージを検証する唯一の方法です。
  * Claude Code がどちらの方法でも検証できない場合、それはメッセージを権限クラスを主張しない他のメッセージのように扱うため、権限プロンプトをバイパスするセッションは承認のためにそれを保留します。
* **サンドボックス化されたセッション**: Bash コマンドが[サンドボックス](https://code.claude.com/docs/ja/sandboxing.md)内からソケットに到達できるかどうかを、サンドボックスの Unix ソケット設定 [`sandbox.network.allowAllUnixSockets` と `sandbox.network.allowUnixSockets`](https://code.claude.com/docs/ja/settings-reference#sandbox-settings) で制御します。

## クロスセッションメッセージングを制限する

メッセージごとのデフォルトを超えて、2 つの方法でメッセージングを狭めることができます。マシンを超えたメッセージが出発する前に承認を要求するか、セッションまたは組織のメッセージングをオフにします。

### クロスマシンメッセージの承認を要求する

[`isolatePeerMachines`](https://code.claude.com/docs/ja/settings-reference#isolatepeermachines)を `true` に設定して、`SendMessage` がこのマシンを超えたセッションに到達する前に明示的な承認を要求します。

```json theme={null}
{
  "isolatePeerMachines": true
}
```

これが設定されている場合、Claude Code は、`bypassPermissions` モード（通常の権限プロンプトをスキップする）でも、Claude のメッセージがこのマシンを超えたセッションに出発する前に承認を求めます。任意の設定スコープからの `true` が適用されるため、チェックインされたプロジェクトファイルは要件をオンにできますが、オフにはできません。Claude Code は同じマシン上のセッション間のメッセージをプロンプトしません。

### クロスセッションメッセージングをオフにする

受信と送信は別のコントロールであるため、必要な方向をオフにするか、両方をオフにします。到着するメッセージには `crossSessionInbound` を使用し、Claude がここで送信またはリストできるものには権限ルールを使用します。

* **受信を停止**: `crossSessionInbound` を `refuse` に設定し、Claude Code はインバウンドピアメッセージをドロップし、配信しません。プロジェクトまたはローカル設定から、`refuse` はすべての他のソースに適用され、ユーザー設定から、管理設定または `--settings` フラグが値を設定しない限り適用されます。
* **送信とリストを停止**: `SendMessage` と `ListAgents` に名前を付ける[権限拒否ルール](https://code.claude.com/docs/ja/permissions.md#tool-specific-permission-rules)を追加します。両方は指定子なしでベアツール名を取ります。

管理者は、[管理設定](https://code.claude.com/docs/ja/managed-settings.md)で組織の両側をオフにでき、拒否ルールと `refuse` を組み合わせることができます。

```json theme={null}
{
  "permissions": {
    "deny": ["SendMessage", "ListAgents"]
  },
  "crossSessionInbound": "refuse"
}
```

これが設定されている場合、Claude Code は各セッションのインボックスソケットをバインドしますが、それに到着するすべてのメッセージをドロップし、Claude に何も配信しません。`SendMessage` を拒否すると、同じツールが両方に機能するため、サブエージェントとエージェントチームチームメイトへのメッセージングも削除されます。拒否するセッションは、独自の `/status` またはマシン上の他のセッションのリストに目に見える変化を示さないため、確認するには、ステータスではなく、そのセッションに適用される設定ファイルを確認してください。

## 利用可能性

クロスセッションメッセージングには、macOS、Linux、WSL 2 では Claude Code v2.1.224 以降が必要です。ネイティブ Windows では v2.1.234 以降が必要です。利用可能性と Claude がメッセージを送信できるセッションは、オペレーティングシステム、プロバイダー、設定によって異なります。

* **オペレーティングシステム**: macOS、Windows、Linux（WSL 2 内の Linux を含む）で利用可能です。

* **このマシン上のセッション**: Amazon Bedrock、Claude Platform on AWS、Google Cloud の Agent Platform、Microsoft Foundry を含むすべてのプロバイダーで利用可能です。また、[フィーチャーフラグ取得](https://code.claude.com/docs/ja/env-vars.md#features-that-need-feature-flag-fetching)がオフで実行されるセッションでも利用可能です。これらのプロバイダーでフラグ取得がオフの場合、同一マシン上のメッセージングには Claude Code v2.1.248 以降が必要です。Claude Code はこれらのメッセージを [セッションごとのソケット](#the-sessions-inbox-socket)を通じてマシン上で配信し、Anthropic サーバーを経由することはありません。

  セッションがメッセージを受け取らないようにするには、[`crossSessionInbound`](#turn-off-cross-session-messaging)を`refuse`に設定してください。

* **このマシンを超えたセッション**: Claude は [ウェブ上の Claude Code](https://code.claude.com/docs/ja/claude-code-on-the-web.md)セッションと、Remote Control に接続されているセッションから他のマシン上のセッションを検出します。このセッションのアクティブな認証として claude.ai サインインが必要であり、他の [Remote Control 要件](https://code.claude.com/docs/ja/remote-control.md#requirements)も必要です。Claude は API キーまたは Amazon Bedrock、Claude Platform on AWS、Google Cloud の Agent Platform、Microsoft Foundry ではこれらのセッションを検出できません。

セッションを確認するには、`/list-agents`を入力してください。`/peers`としても利用可能です。結果は、フィーチャーを持たないセッションと、`SendMessage`ツールの欠落や送信の拒否など、より狭い範囲でメッセージをブロックしたセッションを区別します。

* **`/list-agents`が認識されない**: セッションはクロスセッションメッセージングを持っていません。上記の要件を確認してください。バージョン要件については`claude --version`から始めてください。
* **`/list-agents`は機能するが、送信が到着しなかった**: メッセージングはオンであり、より狭い範囲の何かが適用されます。
  * **拒否ルール**: [権限拒否ルール](#turn-off-cross-session-messaging)は`SendMessage`と`ListAgents`ツールを削除します。
  * **インバウンドコントロール**: [受信セッションのインバウンドコントロール](#control-inbound-messages)は、送信したものを保持またはドロップできます。
  * **クラウドセッションが見つからない**: クラウドセッションは、このセッションが [Remote Control](https://code.claude.com/docs/ja/remote-control.md)に接続されている間のみ表示されます。
  * **他のマシンのセッションが見つからない**: 別のマシン上のセッションは、[Remote Control](https://code.claude.com/docs/ja/remote-control.md)で実行され、このセッションも接続されている場合にのみ表示されます。
  * **他のマシンのセッションが`offline`**: `offline`としてリストされているセッションへのメッセージは通過しますが、[そのセッションのマシンが再接続した後にのみ到着します](#message-sessions-on-other-machines)。
  * **クラウドまたは他のマシンのセッションが `can't receive cross-session messages`**: この状態でリストされているセッションへのメッセージは[このマシンから送信されず](#message-sessions-on-other-machines)、`SendMessage` の結果は `Not sent` で始まります。
  * **古いクラウドまたは他のマシンのセッションが見つからない**: Claude Code はこれらのセッションリストを最新順に読み込み、制限されたページ数の後に停止するため、Claude はそれらのページを超えて落ちたセッションを名前でメッセージすることはできません。

メッセージング機能を持つセッションでは、`/status`はセッション自身のインボックスアドレスを含む`Peer address`行も表示するか、Claude Code が [インボックスをセットアップできなかった](#the-sessions-inbox-socket)場合は`unavailable`と理由を表示します。

## 制限

ここの制限はメッセージングチャネル自体の特性であり、機能が実行される場所に適用されます。プラットフォームとプロバイダーのギャップについては、代わりに[利用可能性](#availability)を参照してください。

* **プレーンテキストのみ**: Claude はセッション間でプレーンテキストのみを送信します。構造化された[エージェントチーム](https://code.claude.com/docs/ja/agent-teams.md)プロトコルメッセージはチーム内に留まります。
* **同じマシンメッセージサイズは上限があります**: Claude Code は、シリアル化された形式が約 100 万文字を超えると、このマシン上のセッションへのメッセージを拒否します。拒否は[正確なサイズに名前を付けます](https://code.claude.com/docs/ja/errors.md#message-too-large-for-cross-session-delivery)。受信側のセッションには何も到達しません。
* **このマシン上のセッションへの急速なバーストは送信者で拒否されます**: このマシン上のセッションへのメッセージの急速なバーストがそのセッションのインボックスが受け入れるものに達すると、Claude Code は送信側のセッションでさらなる送信を拒否します。[拒否はバーストに名前を付けます](https://code.claude.com/docs/ja/errors.md#too-many-messages-to-this-session-just-now)。Claude に残りを 1 つのメッセージにバッチするか、待機するよう伝えます。
* **メッセージループはスロットルされます**: 受信側のセッションでは、Claude Code は送信者ごとに繰り返されたメッセージをレート制限し、短いウィンドウ内に到着する同一の繰り返しをドロップし、最大 50 個の受け入れられたメッセージを Claude が読むためにキューに入れます。したがって、2 つのセッション間のメッセージループは独自に停止します。

## 関連リソース

* [サブエージェント](https://code.claude.com/docs/ja/sub-agents.md#resume-subagents)と[エージェントチーム](https://code.claude.com/docs/ja/agent-teams.md#messages-between-agents): 単一のセッションまたはチーム内のメッセージング
* [バックグラウンドエージェント](https://code.claude.com/docs/ja/agent-view.md): メッセージを送信する可能性のある並列セッションをディスパッチおよび監視します
* [リモートコントロール](https://code.claude.com/docs/ja/remote-control.md): このセッションを接続して、他のマシン上のセッションに到達します
* [チャネル](https://code.claude.com/docs/ja/channels.md): CI 結果やチャットメッセージなどの外部イベントをセッションにプッシュします
* [設定](https://code.claude.com/docs/ja/settings-reference.md#all-settings): `crossSessionInbound`、`isolatePeerMachines`、`dialogExpiry`
* [権限モード](https://code.claude.com/docs/ja/permission-modes.md): インバウンドデフォルトの 2 つのクラスの背後にあるモード
* [ツールリファレンス](https://code.claude.com/docs/ja/tools-reference.md): ツールテーブルの `ListAgents` と `SendMessage` 行
* [エージェントを並列で実行](https://code.claude.com/docs/ja/agents.md): Claude Code が複数のエージェントを実行する方法を比較します
