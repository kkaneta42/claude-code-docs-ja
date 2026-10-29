> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# 設定ファイルと優先順位

> Claude Code の設定を変更し、キーが属するスコープを選択し、変更を確認し、複数の場所でキーが設定されている場合に Claude Code が使用する値を学びます。

設定は、Claude Code の動作を変更する JSON キーです。どのモデルで開始するか、何を確認なしで実行できるか、どのファイルを読み取れないか、ターミナルでどのように見えるか、および組織が強制する内容を決定します。

> [!TIP]
>
> 特定のキーを検索するには、[すべての設定](https://code.claude.com/docs/ja/settings-reference.md)に移動してください。すべてのキーが、設定するファイル、デフォルト、および例とともにリストされています。

Claude Code は `~/.claude/settings.json` などの JSON 設定ファイルから設定を読み込みます。いくつかの場所でそれらを探し、[設定を読み込むファイルが、その設定が誰に適用されるかを決定します](#settings-files-and-who-they-affect)。このページでは、これらのファイルについて説明します。設定をどのファイルに入れるか、設定を変更して適用されたことを確認する方法、および同じキーが複数のファイルで設定されている場合に Claude Code が使用する値について説明します。[権限を構成する](https://code.claude.com/docs/ja/permissions.md)では、Claude Code が確認なしで実行できる内容と、`allow`、`ask`、および `deny` ルールを記述する方法について説明します。

> [!NOTE]
>
> このページでは、マシンで実行されている Claude Code について説明します。ターミナル、[VS Code](https://code.claude.com/docs/ja/vs-code.md) および [JetBrains](https://code.claude.com/docs/ja/jetbrains.md) 拡張機能、および [デスクトップアプリ](https://code.claude.com/docs/ja/desktop.md)は、すべて同じ設定ファイルを読み込みます。[Claude Code on the web](https://code.claude.com/docs/ja/claude-code-on-the-web.md) のクラウドセッションは別のマシンで実行され、そのうちのいくつかのみを読み込みます。[クラウドセッションの設定](#settings-in-cloud-sessions)を参照してください。

## 設定ファイルと誰に影響するか

Claude Code は 4 つのファイルから設定を読み込み、組織は claude.ai コンソールから管理設定を配信することもできます。各ソースにはスコープがあります。スコープとは、そのソースに保存された設定が適用される人とプロジェクトの範囲のことで、自分だけ、プロジェクト内の全員、組織内の全員のいずれかです。

| スコープ | ファイル | 誰に影響するか | 用途 |
| :- | :- | :- | :- |
| ユーザー | `~/.claude/settings.json` | 自分自身、このマシン上のすべてのプロジェクト | 個人設定：テーマ、エディターモード、デフォルトモデル、独自の権限ルール |
| 共有プロジェクト | `.claude/settings.json` | このファイルを含むフォルダで作業しているすべての人。git リポジトリでは、コミットしてチームメイトが取得できるようにします | チーム権限、フック、プラグイン、およびプロジェクトが必要とする環境変数 |
| プロジェクトローカル | `.claude/settings.local.json` | 自分自身、このプロジェクトのみ。Claude Code はファイルを作成するときに git から除外します。手動で作成する場合は、自分で `.gitignore` に追加してください | 1 つのプロジェクトでの個人的な上書き、および共有する前のテスト |
| 管理 | `managed-settings.json` およびその他の[管理ソース](https://code.claude.com/docs/ja/managed-settings.md#delivery-mechanisms) | 組織がデプロイするすべての人。何がこれを上書きできるかは[設定の優先順位](#settings-precedence)を参照してください | セキュリティポリシーおよびコンプライアンス要件 |

ファイル列では、`~/.claude` はホームディレクトリの `.claude` フォルダ、パスなしの `.claude` はプロジェクト内の `.claude` フォルダです。

### 各設定ファイルのスコープを比較する

マシン上に 3 つのプロジェクト `website/`、`api/`、および `acme-app/` があり、チームメイトが `acme-app/` の独自のクローンを持ち、`acme-app/` で[クラウドセッション](#settings-in-cloud-sessions)を開始するとします。

下のグラフィックは、それらのフォルダから Claude Code を開始するときに設定が適用されるフォルダを示しています。設定ファイルをクリックして、到達するフォルダを確認してください。

Settings file

Your machine

A teammate’s machine

A cloud session

* **`~/.claude/settings.json`**：自分のマシン上のすべてのプロジェクト。チームメイトのクローンやクラウドセッションには適用されません
* **`acme-app/.claude/settings.json`**：自分の `acme-app/`。バージョン管理にファイルをコミットした場合のみ、チームメイトのクローンとクラウドセッションに到達します。それまでは、ディスク上の他のファイルと同じ単なるファイルであり、他の誰も持っていません
* **`acme-app/.claude/settings.local.json`**：自分の `acme-app/` のみ。Claude Code はファイルを初めて書き込むときに、グローバル git 除外に追加するため、コミットから除外されます。手動でファイルを作成する場合は、[自分で `.gitignore` に追加してください](#keep-personal-settings-out-of-a-repository)
* **管理設定**。`managed-settings.json` ファイル、MDM ポリシー、または claude.ai コンソールからの[サーバー管理設定](https://code.claude.com/docs/ja/server-managed-settings.md)：組織がデプロイするすべてのマシン、または組織アカウントでサインインするマシン上のすべてのプロジェクト。クラウドセッションに到達するのはサーバー管理設定のみです

### 設定ファイルを見つけるか作成する

Claude Code をインストールしても、設定ファイルは作成されません。マシンまたはプロジェクトに既に設定ファイルがある場合は、次のいずれかのソースから来たものです：

* **管理**：組織がデプロイします。自分で作成または編集することはありません。
* **共有プロジェクト**：Claude Code を既に使用しているプロジェクトには、コミットされたものがあるかもしれません。ない場合は、プロジェクトフォルダに `.claude/settings.json` として作成してください。
* **ユーザー**および**プロジェクトローカル**：自分で作成するか、Claude Code に作成させます。テーマなど、ユーザー設定に保存される `/config` メニューのオプションを初めて変更するときに `~/.claude/settings.json` を書き込み、Bash コマンドに対する「はい、今後は聞かないでください」など、権限プロンプトで恒久的な承認を初めて与えるときに `.claude/settings.local.json` を書き込みます。**ヒントを表示**を含むいくつかの `/config` オプションは、ユーザーファイルではなく `.claude/settings.local.json` に保存されます。

> [!NOTE]
>
> Windows では、`~/.claude` は `%USERPROFILE%\.claude` を意味します。ホームディレクトリのファイルを別の場所に保存するには、[`CLAUDE_CONFIG_DIR`](https://code.claude.com/docs/ja/env-vars) を設定してください。Claude Code は設定、セッション履歴、およびプラグインを代わりにそこに保存します。

Claude Code は、[`~/.claude.json`](https://code.claude.com/docs/ja/claude-directory#ce-claude-json) という 5 番目のファイルも保持します。これは Claude Code 自身が書き込むもので、編集する必要はありません。アカウントの詳細、[MCP サーバー](https://code.claude.com/docs/ja/mcp.md)の設定、信頼の決定などのプロジェクトごとの状態、および `/config` が書き込む[グローバル設定キー](https://code.claude.com/docs/ja/settings-reference.md#global-config-settings)を保持します。

### チームと設定を共有する

`.claude/settings.json` をコミットして、リポジトリをクローンするすべての人が同じ権限、フック、およびプラグインを取得するようにします。各チームメイトは、独自の `.claude/settings.local.json` で自分用にそれを上書きできるため、個人的な例外にコミットは必要ありません。完全なチームファイルについては、[チームの共有設定](https://code.claude.com/docs/ja/settings-example.md#a-teams-shared-settings)を参照してください。

コミットするものの一部は、各チームメイトが[フォルダを信頼する](https://code.claude.com/docs/ja/permissions.md#project-allow-rules-and-workspace-trust)まで待機し、いくつかのキーはリポジトリファイルからは決して有効になりません。[適用されない設定をトラブルシューティングする](#common-cases)で両方を説明しています。

### リポジトリから個人設定を除外する

1 つのプロジェクトで、チームメイトの設定を変えずに自分の設定だけを変更するには、プロジェクト内の `.claude/settings.local.json` に保存してください。Claude Code はそのファイルをコミットされた `.claude/settings.json` の上に適用するため、チームのファイルが `"model": "claude-sonnet-5"` を設定していて Opus を使いたい場合は、ローカルファイルに `"model": "claude-opus-5-5"` を入れれば、自分のセッションだけが変わります。

Claude Code もこのファイルに書き込み、コミットから除外し、信頼ステップなしでその許可ルールを適用します：

* **Claude Code もこのファイルに書き込みます。** Claude が Bash コマンドを実行する権限を求め、「はい、今後は聞かないでください」を選択すると、Claude Code はその[権限の承認](https://code.claude.com/docs/ja/permissions.md#permission-system)をここに `allow` ルールとして保存します。
* **手動で作成した場合を除き、自分で gitignore する必要はありません。** Claude Code が、まだこのファイルを無視していない git リポジトリでファイルを初めて書き込むときに、グローバル git 除外ファイルに `**/.claude/settings.local.json` を追加するため、ファイルはすべてのリポジトリでコミットから除外されます。そのファイルは、グローバル git 設定で `core.excludesFile` が絶対パスまたは `~` で始まるパスに設定されている場合はそのファイル、それ以外の場合は `$XDG_CONFIG_HOME/git/ignore`、`XDG_CONFIG_HOME` が設定されていない場合は `~/.config/git/ignore` です。手動でファイルを作成し、Claude Code がまだそれに書き込んでいない場合は、自分で `.gitignore` に追加してください。
* **ファイルが追跡されていない間、その許可ルールは信頼を待ちません。** ファイルはリポジトリのものではなく自分のものであるため、Claude Code はコミットされたファイルに必要な[ワークスペースの信頼](https://code.claude.com/docs/ja/permissions.md#project-allow-rules-and-workspace-trust)ステップなしで、その `allow` ルールを適用します。ファイルが git で追跡されている場合は、信頼ステップがこのファイルにも適用されます。[ローカル設定ファイルが信頼を必要とする場合](https://code.claude.com/docs/ja/permissions.md#when-your-local-settings-file-needs-trust)を参照してください。

#### Claude Code が git リポジトリでローカルファイルを保持する場所

Claude が Bash コマンドを実行する権限を求め、「はい、今後は聞かないでください」を選択すると、Claude Code はその承認を `.claude/settings.local.json` の `allow` ルールとして保存します。git リポジトリのサブディレクトリで Claude Code を開始した場合、リポジトリルートにあるそのファイルを読み書きし、承認をリポジトリ全体に適用します。[worktree](https://code.claude.com/docs/ja/worktrees.md) では、メインチェックアウトのルートにあるファイルを使用します。

ルートの場所には 2 つの条件があります：

* **ファイルが代わりに `.claude/settings.json` と同じ場所に置かれる場合**：git リポジトリの外、リポジトリルートがホームディレクトリである場合、Windows の場合、またはリポジトリルートやその `.git` または `.claude` エントリの所有者が自分のユーザーでない場合。
* **ファイル内のパスはリポジトリルートを基準にしません**：`/` で始まる権限ルールや相対サンドボックスパスは、代わりに[セッションのプライマリ作業ディレクトリを基準にします](https://code.claude.com/docs/ja/permissions.md#read-and-edit)。

v2.1.211 より前では、Claude Code は開始ディレクトリにファイルを保持していました。以前のバージョンがそこに残したファイルも、ルートのファイルと併せて読み込みます。両方が同じキーを設定している場合はルートの値が適用され、権限ルールは両方のファイルのものが適用されます。Agent SDK の [`resolveSettings()`](https://code.claude.com/docs/ja/agent-sdk/typescript#resolvesettings) ヘルパーは常に開始ディレクトリからファイルを読み込みます。

Claude Code は共有 `.claude/settings.json` をセッションの[プライマリ作業ディレクトリ](https://code.claude.com/docs/ja/permissions.md#working-directories)から読み込むため、リポジトリルートにコミットされたファイルを使用するには、そこで Claude Code を開始してください。[`/cd` でセッションを移動した](https://code.claude.com/docs/ja/permissions#move-the-session-to-another-directory)後は、Claude Code は代わりに新しいディレクトリから両方のプロジェクトファイルを読み込み、ローカルファイルは同じルールで配置します。移動先のディレクトリから読み込むには Claude Code v2.1.246 以降が必要です。デスクトップアプリから開始する worktree セッションについては、[worktree がメインチェックアウトと共有するもの](https://code.claude.com/docs/ja/worktrees.md#what-worktrees-share-with-the-main-checkout)を参照してください。

### 組織が強制する内容を確認する

組織が Claude Code を管理している場合、一部の設定はあらかじめ決定されており、自分のファイルに何を書いても変更できません。どの設定が該当するかを確認するには、`/status` を実行してください。`Setting sources` 行に、適用される管理ソースの名前が表示されます。管理設定は、このマシン上で Claude Code が実行されるすべての場所に適用されます。ローカル管理者権限と Claude Code 以外のツールについては、[開発者が変更できる内容](https://code.claude.com/docs/ja/managed-settings.md#what-a-developer-can-change)を参照してください。

管理設定は、管理設定ページで説明している[配信メカニズム](https://code.claude.com/docs/ja/managed-settings.md#delivery-mechanisms)を通じて届きます。最も一般的なものは次のとおりです：

* [サーバー管理設定](https://code.claude.com/docs/ja/server-managed-settings.md)。Claude Code が claude.ai 管理コンソールまたはセルフホストの [Claude apps gateway](https://code.claude.com/docs/ja/claude-apps-gateway) から取得します
* MDM または OS レベルのポリシー、およびシステムディレクトリ内の `managed-settings.json` ファイル
* Claude Desktop などの埋め込みホスト。SDK の `managedSettings` オプションを通じて配信されます。[埋め込みホストからポリシーを制御する](https://code.claude.com/docs/ja/managed-settings.md#parent-settings-from-embedding-hosts)を参照してください

Claude Desktop アプリで自分のマシン上で実行される [Cowork](https://claude.com/docs/cowork/overview) セッションでは、Claude Code は claude.ai 管理コンソールからサーバー管理設定を取得しません。また、組織の Claude Desktop 設定で `requireCoworkFullVmSandbox` が設定されていない限り、デバイスにデプロイされたポリシーを読み込みます。Cowork とクラウドセッションについては、[ポリシーが適用される場所と時期](https://code.claude.com/docs/ja/managed-settings.md#where-and-when-a-policy-applies)を参照してください。

管理者の場合、[組織向けに Claude Code をセットアップする](https://code.claude.com/docs/ja/admin-setup.md)で何を強制するかを選択する手順を、[管理設定をデプロイする](https://code.claude.com/docs/ja/managed-settings.md)で配信方法とポリシーが有効であることを確認する方法を説明しています。claude.ai 管理コンソールの管理設定エディターに表示されることがある警告については、[サーバー管理設定を構成する](https://code.claude.com/docs/ja/server-managed-settings.md#configure-server-managed-settings)を参照してください。

## 設定を変更する

`/config` メニューから、設定ファイルを編集して、または 1 つのセッションのコマンドラインから設定を変更できます。

Claude Code のシステムプロンプトは公開されていません。Claude に立ったままの命令を与えるには、[`CLAUDE.md` ファイル](https://code.claude.com/docs/ja/memory)または `--append-system-prompt` フラグを使用してください。

### /config メニューを使用する

Claude Code 内で `/config` を実行し、**Config** タブを開きます。テーマ、エディターモード、詳細出力などの短いセットの個人的なオプションをリストします。すべての設定キーではありません。オプションを選択して変更します。Claude Code はあなたのために保存します：

* **ほとんどのオプション**：`~/.claude/settings.json`
* **ヒントを表示などのいくつかのオプション**：`.claude/settings.local.json`
* **[グローバル構成オプション](https://code.claude.com/docs/ja/settings-reference.md#global-config-settings)**：`~/.claude.json`

1 つのオプションをメニューなしで設定するには、`/config verbose=true` などの `key=value` を渡してください。

> [!NOTE]
>
> `/config` はターミナルインターフェースの一部です。[VS Code](https://code.claude.com/docs/ja/vs-code.md) チャットパネルと[デスクトップアプリ](https://code.claude.com/docs/ja/desktop.md)はそれを開きません。設定ファイルを編集するか、これらのアプリ独自の設定を通じて設定を変更してください。

### 設定ファイルを編集する

エディターで必要なスコープの設定ファイルを開き、キーを追加または変更します。設定ファイルは厳密な JSON です。`//` コメントまたは末尾のコンマは構文エラーであり、Claude Code はファイルを[設定エラー](#fix-a-broken-settings-file)として次の開始時に報告します。たとえば、Claude Code が確認なしに lint とテストコマンドを実行し、`.env` ファイルの読み取りを停止するようにするには、これを `~/.claude/settings.json` に追加してください：

```json ~/.claude/settings.json theme={null}
{
  "$schema": "https://json.schemastore.org/claude-code-settings.json",
  "permissions": {
    "allow": [
      "Bash(npm run lint)",
      "Bash(npm run test *)"
    ],
    "deny": [
      "Read(./.env)",
      "Read(./.env.*)"
    ]
  }
}
```

`permissions` の下の各エントリは、ツールとそれが何ができるかを名前付けするルールです。[権限を構成する](https://code.claude.com/docs/ja/permissions.md)は構文を説明します。`$schema` 行は Claude Code 設定の[公開 JSON スキーマ](https://json.schemastore.org/claude-code-settings.json)を指し、VS Code、Cursor、および JSON スキーマをサポートする他のエディターでオートコンプリートとインライン検証を提供します。スキーマは最新の CLI リリースより遅れることができるため、最近ドキュメント化されたキーの検証警告は、構成が無効であることを意味しません。

保存した後、Claude Code 内で `/status` を実行してファイルが読み込まれたことを確認してください。[読み込まれたものを確認する](#check-what-loaded)は `Setting sources` 行が表示するものと、壊れたファイルがどのように報告されるかを説明します。

完全な個人ファイル、チームファイル、および組織ファイルについては、それが設定するすべてのキーのコメント付きで、[設定ファイルの例](https://code.claude.com/docs/ja/settings-example.md)を参照してください。

### 1 つのセッションの設定を変更する

値を保存せずに試すには、Claude Code を開始するときに設定します。値はそのセッションに適用され、設定ファイルはそのままです。3 つの方法があります：

* **`--settings`**：JSON としてキーを渡します。インラインまたはファイルへのパス。Claude Code はそれをユーザー、プロジェクト、およびローカルファイルの上に適用し、管理設定の下に適用します。ユーザー設定ファイルが設定できるキーを設定できます。`Managed` または `Global config` キーを設定することはできません。
* **そのキーのフラグ**：いくつかのキーには独自のフラグがあります。`model` の `--model` や `effortLevel` と `modelSettings` の `--effort` など。
* **環境変数**：`model` の `ANTHROPIC_MODEL` など、キーのペアリングされた変数をエクスポートしてから `claude` を実行してください。

各キーの[設定リファレンス](https://code.claude.com/docs/ja/settings-reference.md)のエントリは、その 1 セッションのオーバーライドと、どれが優先されるかをリストします。変更したいキーのエントリを確認してください。

セッション内で実行するコマンドはほとんどあなたの選択を保存します。`/config` で設定を変更すると、Claude Code はそれを設定ファイルに書き込み、`/model` は値を新しいセッションのデフォルトとして保存します。

`/model` ピッカーで `s` を押すと、Claude Code はモデルを切り替えますが、ユーザーデフォルトとして保存しません。[努力レベルを調整する](https://code.claude.com/docs/ja/model-config.md#adjust-effort-level)は、Claude Code が使用しているモデルのデフォルトとして保存する `/effort` ピックと、現在のセッションのみに適用するものを説明します。

たとえば、デフォルトを変更せずに 1 つのセッションで Opus で開始するには：

```bash theme={null}
claude --settings '{"model": "claude-opus-5-5"}'
```

### 編集がいつ有効になるか

Claude Code は設定ファイルを監視し、変更時に再読み込みするため、`permissions`、`hooks`、および `apiKeyHelper` などの認証情報ヘルパーへの編集を含む、ほとんどの編集は再起動なしで実行中のセッションに適用されます。Claude Code は、セッションの途中で作成した設定ファイルも、そのフォルダがセッション開始時に存在していれば読み込みます。プロジェクトの `.claude/` フォルダについては、同じセッション内でフォルダを作成した場合でもファイルを読み込みます。

再読み込みはユーザー、プロジェクト、ローカル、および管理設定をカバーし、Claude Code は検出した各設定ファイル変更に対して [`ConfigChange` hook](https://code.claude.com/docs/ja/hooks#configchange) を実行します。MDM または claude.ai コンソールから到達する管理設定ではありません。MDM または claude.ai コンソールから到達する管理設定は、保存時ではなくスケジュールに従って実行中のセッションに到達します。[配信テーブル](https://code.claude.com/docs/ja/managed-settings.md#choose-a-delivery-mechanism)はソースごとにそれを提供します。

Claude Code はセッション開始時に一度だけいくつかのキーを読み込むため、そのうちの 1 つへの編集は実行中のセッションに到達しません。`requiredMinimumVersion` などの管理者側のキーも再起動を待ちます。[ポリシーが適用される場所と時期](https://code.claude.com/docs/ja/managed-settings.md#where-and-when-a-policy-applies)の下にリストされています。セッション中に編集する可能性が最も高いもの：

* [`model`](https://code.claude.com/docs/ja/settings-reference#model)：セッション中に切り替えるには [`/model`](https://code.claude.com/docs/ja/model-config#setting-your-model) を使用してください。各モデルには独自のプロンプトキャッシュがあるため、切り替え後の最初のリクエストは会話全体をキャッシュなしで再読み込みします。[モデルを切り替える](https://code.claude.com/docs/ja/prompt-caching.md#switching-models)を参照してください
* [`effortLevel`](https://code.claude.com/docs/ja/settings-reference#effortlevel) および [`modelSettings`](https://code.claude.com/docs/ja/settings-reference#modelsettings)：セッション中に努力を変更するには [`/effort`](https://code.claude.com/docs/ja/model-config#adjust-effort-level) を使用してください

### 読み込まれたものを確認する

Claude Code 内で `/status` を実行して、どの設定ソースがアクティブであるかを確認してください。**Status** タブには、Claude Code が現在のセッション用に読み込んだ各設定ファイルをリストする `Setting sources` 行が含まれています。`User settings` または `Project local settings` など。[管理設定](https://code.claude.com/docs/ja/admin-setup.md#decide-how-settings-reach-devices)が有効な場合、管理設定エントリは括弧内にそれらがマシンに到達した方法を示します。

行は Claude Code が読み込んだファイルを確認します。各ファイルがどのキーを供給したかは表示されません。Claude Code が拒否したエントリをリストするには、[`claude doctor`](https://code.claude.com/docs/ja/debug-your-config) を実行してください。プロジェクトまたは管理設定が設定するモデルについては、スタートアップヘッダーがそれを設定したファイルの名前を付けます。`/status` と `/config` は異なるタブで同じダイアログを開き、**Config** タブは `settings.json` コンテンツのビューではありません。

### 壊れた設定ファイルを修正する

JSON をタイプミスするか、Claude Code が受け入れない値にキーを設定する場合、Claude Code はインタラクティブセッションの開始時にあなたに伝えます。表示される内容は、ファイルのどの程度が影響を受けるかによって異なります：

* **設定エラー**：ユーザー、プロジェクト、またはローカルファイルに無効な JSON またはスキーマが拒否する値があります。インタラクティブセッションの開始時に Claude Code はダイアログを表示し、Claude の助けでファイルを修正するか、終了するか、壊れた設定なしで続行できます。
* **設定警告**：個別のエントリのみが失敗します。不正な形式の権限ルールまたは不明な hook イベント名など。Claude Code はそれらの値をスキップし、ファイルの残りを有効に保ちます。
* **管理設定**：Claude Code はファイルの残りを強制し続けます。[管理設定の無効なエントリ](https://code.claude.com/docs/ja/managed-settings.md#invalid-entries-in-managed-settings)は、それが削除するものと、修正するまでどのキーがより厳密な値にフォールバックするかを説明します。有効な JSON ではない管理設定ドキュメントについては、[管理設定ドキュメントを解析できませんでした](https://code.claude.com/docs/ja/errors.md#managed-settings-document-could-not-be-parsed)を参照してください。
* **構成エラー**：`~/.claude.json` を解析できません。Claude Code は壊れたファイルを `~/.claude/backups/.claude.json.corrupted.<timestamp>` にコピーし、終了して手動で修正するか、デフォルト構成にリセットするかを尋ねます。`-p` 実行はエラーを出力して終了します。以前の状態を復旧するには、`~/.claude/backups/` の 5 つの最新 `.claude.json.backup.<timestamp>` ファイルの 1 つをコピーして戻してください。Claude Code はファイルを書き込む前に保存します。

続行した後、`/status` を実行して影響を受けたファイルを確認し、各エラーの詳細について `claude doctor` を実行してください。

`-p` 実行はダイアログを表示しません。[管理設定ドキュメントを解析できない](https://code.claude.com/docs/ja/errors.md#managed-settings-document-could-not-be-parsed)場合を除き、Claude Code は壊れたファイルまたは値をスキップして残りで続行するため、設定をスキップした `-p` 実行の後、`claude doctor` を実行して削除したものを確認してください。

## 設定の優先順位

同じキーが複数の場所に現れる場合、Claude Code はそのキーを設定している最も上位のレベルの値を使用します。以下のスタックはレベルを示しており、最上位が一番上にあります。上位レベルのキーは、それより下のどこにある同じキーも上書きします。

Settings precedence, highest first: managed settings, command line, project local, shared project, user. A key set at a higher level overrides the same key set lower down.

優先順位の高い順に並べると、次のとおりです。

1. **管理設定**: 組織が `managed-settings.json` ファイル、MDM ポリシー、または claude.ai コンソールからの[サーバー管理設定](https://code.claude.com/docs/ja/server-managed-settings.md)によって配布する設定です。自分の設定ファイルや `--settings` のどれも管理対象のキーを上書きすることはできず、`--model` などのフラグは組織が許可しているモデルの中からしか選択できません。管理設定の [`model`](https://code.claude.com/docs/ja/settings-reference#model) は初期のデフォルトであり、固定するものではありません。固定するのは [`availableModels`](https://code.claude.com/docs/ja/settings-reference#availablemodels) と [`deniedModels`](https://code.claude.com/docs/ja/settings-reference#deniedmodels) です。組織が複数の管理ソースを配布している場合、Claude Code がそれぞれから何を読み取るかは[管理ティア内の優先順位](https://code.claude.com/docs/ja/managed-settings.md#precedence-within-the-managed-tier)のルールで決まります。
2. **コマンドライン**: `claude` の起動時に `--settings <file-or-json>` で渡す JSON で、そのセッションにのみ適用されます。[1 つのセッションだけ設定を変更する](#change-a-setting-for-one-session)を参照してください。ここで設定したキーはプロジェクトおよびユーザーの設定ファイルにある同じキーを上書きし、指定しなかったキーはそれらのファイルの値を維持します。`--model` などのその他のフラグは、セッションに対して 1 つの項目を設定するもので、このスタックには含まれません。どのフラグがキーを上書きするかは、[設定リファレンス](https://code.claude.com/docs/ja/settings-reference.md)の各キーの項目に記載されています。
3. **プロジェクトのローカル設定**（`.claude/settings.local.json`）: このプロジェクトにおける個人用の設定です。
4. **共有プロジェクト設定**（`.claude/settings.json`）: チームがソース管理にチェックインする設定です。
5. **ユーザー設定**（`~/.claude/settings.json`）: すべてのプロジェクトに適用される個人用の設定です。

環境変数はこのスタックのレベルではありません。ある動作にシェル変数と設定キーの両方がある場合、どちらが適用されるかはレベルではなくペアごとに決まります。シェルでエクスポートした `ANTHROPIC_MODEL` はどのファイルの `model` キーよりも優先して適用されますが、`ANTHROPIC_DEFAULT_MODEL` はどのファイルも `model` を設定していない場合にのみ適用されます。どのキーにペアがあり、Claude Code がどちらを先に読み取るかは、[環境変数リファレンス](https://code.claude.com/docs/ja/env-vars.md#precedence)に記載されています。設定ファイル内の `env` ブロックは通常のキーであり、上記のレベルに従います。

セキュリティに関わるいくつかのキーについては、Claude Code は管理設定の値よりも下位レベルのより厳格な値を尊重します。それらは[管理設定の優先順位の例外](#exceptions-to-managed-settings-precedence)に一覧があります。

### リストは上書きではなくマージされる

`permissions.allow` などの同じリストキーを複数のファイルで設定すると、Claude Code はどれか 1 つを選ぶのではなくリストを結合するため、各ファイルは他のファイルのエントリを削除することなくエントリを追加できます。モデルのリストまたはモデルごとのエントリを保持する 4 つのキーは、それぞれ独自のルールに従います。

* [`fallbackModel`](https://code.claude.com/docs/ja/settings-reference#fallbackmodel) は位置に意味がある順序付きのチェーンであるため、Claude Code はそれを定義している最も優先順位の高いファイルから値全体を取得します。
* [`modelPicker`](https://code.claude.com/docs/ja/settings-reference#modelpicker) は順序付きの行のリスト 1 つと置換フラグを保持するため、Claude Code は 2 つのソースの行をマージすることはありません。管理設定、`--settings`、ユーザー設定のうち、それを定義している最も上位のものから値全体を取得し、プロジェクト設定とローカル設定にあるこのキーは無視します。Claude Code v2.1.242 以降が必要です。
* [`availableModels`](https://code.claude.com/docs/ja/settings-reference#availablemodels): Claude Code が適用する管理設定でこれが定義されている場合、Claude Code はそのリストをそのまま適用し、ユーザー設定、プロジェクト設定、ローカル設定で追加したエントリを無視します。ただし、Claude Code を組み込んだアプリが独自のモデルリストを提供している場合は除きます。[管理設定の優先順位の例外](#exceptions-to-managed-settings-precedence)を参照してください。管理ソース間でもこのリストがマージされることはありません。どのソースのリストが適用されるかは、[Claude Code が管理ソースを組み合わせる方法](https://code.claude.com/docs/ja/managed-settings.md#how-claude-code-combines-managed-sources)に記載されています。管理対象外のスコープ間では、Claude Code は通常どおり配列をマージします。
* [`modelSettings`](https://code.claude.com/docs/ja/settings-reference#modelsettings): Claude Code はこれを [`effortLevel`](https://code.claude.com/docs/ja/settings-reference#effortlevel) と合わせて、モデルごとに解決します。どのファイルの値がモデルに適用されるかは、`modelSettings` の項目に記載されています。

### 優先順位の例

Claude が作業している間、Claude Code はスピナーの下に「Use /config to change your default permission mode (including Plan Mode)」のような 1 行のヒントを表示します。このヒントをオフにしたいので、`~/.claude/settings.json` で [`spinnerTipsEnabled`](https://code.claude.com/docs/ja/settings-reference#spinnertipsenabled) を `false` に設定したとします。以下の各シナリオは、ヒントを再びオンにしてしまう可能性のある状況と、それに対してできることを示しています。

#### チームの設定が個人の設定を上書きする

チームの `.claude/settings.json` がこれを `true` に設定しています。共有プロジェクトはユーザーより上位にあるため Claude Code はプロジェクトの値を使用し、そのプロジェクトでのみヒントが表示され、他の場所では表示されません。

自分の値を取り戻すことができます。そのプロジェクトの `.claude/settings.local.json` に `"spinnerTipsEnabled": false` を追加してください。プロジェクトのローカル設定は共有プロジェクトより上位にあるため、そこでの自分のセッションではヒントが表示されなくなり、チームメイトのセッションは変わりません。

#### 組織の設定がすべてを上書きする

組織の管理設定がこれを `true` に設定しています。ユーザー設定、プロジェクト設定、ローカル設定に何を書いてもヒントはオフにならず、`--settings` でも同様です。管理設定は最上位のレベルです。

自分の値を取り戻すことはできません。`/status` を実行してどの管理ソースが適用されているかを確認し、ポリシーを変更すべきかどうか管理者に相談してください。

#### コマンドラインが 1 つのセッションに限りファイルを上書きする

`claude --settings '{"spinnerTipsEnabled": true}'` でセッションを開始しました。コマンドラインは管理設定を除くすべてのファイルより上位にあるため、ファイルでは `false` となっていても、そのセッションではヒントが表示されます。

次のセッションでは自分の値に戻ります。`--settings` は 1 つのセッションの間だけ有効で、どのファイルにも書き込みません。

#### フラグまたは環境変数が同じ項目を設定する

一部のキーには、どのファイルで設定されたかにかかわらず設定値を上書きするコマンドラインフラグまたは環境変数があります。`ANTHROPIC_MODEL` は [`model`](https://code.claude.com/docs/ja/settings-reference#model) 設定を上書きし、`--model` はセッションに対してその両方を上書きします。

自分の値を取り戻せるかどうかはキーによって異なります。変数を解除するかフラグを外したうえで、Claude Code がどちらを使用するかを[設定リファレンス](https://code.claude.com/docs/ja/settings-reference.md)のキーの項目と[環境変数リファレンス](https://code.claude.com/docs/ja/env-vars.md)の変数の行で確認してください。

### 適用されない設定のトラブルシューティング

キーを設定したのに Claude Code がそのとおりに動作しない場合は、まず `/status` で読み込まれたファイルを確認し、以下から該当する症状を探してください。クリーンな設定でのテストを含む、より広範なチェックについては[設定のデバッグ](https://code.claude.com/docs/ja/debug-your-config.md)で説明しています。

#### 設定した値が無視される

別の何かが同じキーを設定している、ファイルがその値を設定できない、またはファイルが読み込まれていない、のいずれかです。

* **上位のレベルが設定している。** 別の設定ファイル、`--settings` フラグ、または管理ソースが、自分の設定より上位でそのキーを設定しています。どれが該当するかは[スタック](#settings-precedence)で確認できます。フラグや環境変数もそれ単独でキーを上書きすることがあり、これはキーごとに決まります。Claude Code がどちらを使用するかは[設定リファレンス](https://code.claude.com/docs/ja/settings-reference.md)のキーの項目に記載されており、管理設定の `env` の値とシェルでのエクスポートの関係については [`env` の項目](https://code.claude.com/docs/ja/settings-reference#env)で説明しています。
* **セキュリティ関連のキーが厳格な値を維持している。** いくつかのキーについては、Claude Code はどのファイルからの制限的な値も尊重するため、[`disableClaudeAiConnectors`](https://code.claude.com/docs/ja/settings-reference#disableclaudeaiconnectors) をプロジェクトで `true` にするとオンのままになります。[管理設定の優先順位の例外](#exceptions-to-managed-settings-precedence)を参照してください。
* **ファイルがその値を設定できない。** [`permissions.defaultMode`](https://code.claude.com/docs/ja/settings-reference#permissions-defaultmode) の値 `auto` と `bypassPermissions` は、プロジェクト設定やローカル設定からは有効になりません。代わりにユーザー設定または管理設定で設定するか、1 つのセッションに限り `--permission-mode` を渡してください。v2.1.257 より前は、`bypassPermissions` はどのファイルからでも有効になっていました。

  [`env`](https://code.claude.com/docs/ja/settings-reference#env) ブロック内のテレメトリエクスポート変数も、いくつかのオフの値を除き、プロジェクト設定やローカル設定からは有効になりません。該当する変数とそれらの値は、[Claude Code が `env` で無視する変数](https://code.claude.com/docs/ja/settings-reference#variables-claude-code-ignores-in-env)に一覧があります。
* **ファイルが壊れている。** 無効な JSON や拒否された値があると、Claude Code はそのファイルまたはエントリをスキップします。[壊れた設定ファイルを修正する](#fix-a-broken-settings-file)を参照してください。

#### Claude Code 内で行った変更が新しいセッションで失われる

`/model` によるデフォルトモデルのように、Claude Code 内から新しいセッション向けの選択を保存すると、Claude Code はそれをユーザー設定ファイル `~/.claude/settings.json` に書き込みます。別のツールがこのファイルを生成している、あるいは読み取り専用のコピーにリンクしているなどの理由でこのファイルに書き込めない場合、変更は現在のセッションに適用されますが、次のセッションでは失われます。ファイルを生成しているツールでキーを設定するか、書き込み可能なファイルに置き換えてください。

ファイルに書き込めるのに変更が保持されない場合は、その変更が [1 つのセッションのみを対象としていた](#change-a-setting-for-one-session)か、[上位のレベルが同じキーを設定している](#a-value-you-set-is-ignored)かを確認してください。`model` キーについては、[新しいセッションが選択したものとは異なるモデルで開始される](https://code.claude.com/docs/ja/model-config.md#a-new-session-starts-on-a-different-model-than-you-picked)に他の原因も挙げられています。

#### 管理設定の変更が反映されない

管理ソースは[配布方法の表](https://code.claude.com/docs/ja/managed-settings.md#choose-a-delivery-mechanism)に示されたスケジュールで実行中のセッションに反映されるため、まずセッションを再起動してください。その後 `/status` に管理者が変更したものとは別のソースが表示される場合は、より優先度の高いソースが適用されています。順序は [Claude Code が管理ソースを組み合わせる方法](https://code.claude.com/docs/ja/managed-settings.md#how-claude-code-combines-managed-sources)に記載されています。

#### コミットしたキーがチームメイトに反映されない

`.claude/settings.json` にあるキーが、クローンしたすべての人に適用されない原因は 2 つあります。

* **Claude Code がリポジトリファイル内のそのキーを無視している。** [設定インデックス](https://code.claude.com/docs/ja/settings-reference.md#settings-index)の Scope 列で、`User, local, or managed`、`User or managed`、`User`、`Managed`、または `Global config` を探してください。これらのキーは共有ファイルからは決して適用されません。ただし、リポジトリファイルからでもオフにできるいくつかのキーは例外で、それらの項目の Scope 行にその旨が記載されています。`Global config` のキーは `~/.claude.json` からのみ適用されます。

  `env` キー内でも、テレメトリエクスポート変数は、いくつかのオフの値を除き、共有ファイルからは決して適用されません。[Claude Code が `env` で無視する変数](https://code.claude.com/docs/ja/settings-reference#variables-claude-code-ignores-in-env)を参照してください。
* **キーが信頼を待っている。** `permissions.allow` ルール、`permissions.additionalDirectories`、`extraKnownMarketplaces`、およびほとんどの [`env`](https://code.claude.com/docs/ja/settings-reference#env) の値は、各チームメイトが[フォルダーを信頼](https://code.claude.com/docs/ja/permissions.md#project-allow-rules-and-workspace-trust)した後にのみ適用されます。それまでは、チームメイトには引き続きプロンプトが表示され、ファイルで宣言されたマーケットプレイスからプラグインを取得することもありません。`deny` ルールと `ask` ルールはすぐに適用されます。

#### 権限ルールが想定と異なる方法で組み合わされる

* **権限プロンプトで「Yes, and don't ask again」を選んだのに、同じツールについて引き続きプロンプトが表示される。** その選択によって許可ルールがローカルファイルに保存されますが、そこにある `allow` ルールはプロジェクトファイルや管理ファイルからの `ask` ルールより優先されることはありません。順序については[権限ルールの組み合わせ方](https://code.claude.com/docs/ja/permissions.md#settings-precedence)で説明しています。VS Code 拡張機能では、承認カードで保存先のファイルを選択でき、プロジェクトの共有ファイルも選べますが、その場合はすべての人に対してルールが変わります。CLI では、Claude Code はローカルファイルにのみ書き込みます。
* **組織の許可ルールが自分のルールと並んで引き続き適用される。** これは想定どおりの動作です。組織が [`allowManagedPermissionRulesOnly`](https://code.claude.com/docs/ja/settings-reference#allowmanagedpermissionrulesonly) を設定していない限り、Claude Code は [`permissions.allow`](https://code.claude.com/docs/ja/settings-reference#permissions-allow) をスコープ間でマージします。

### 管理設定の優先順位の例外

値がセッションを制限するいくつかのキーについては、Claude Code は本来なら管理設定を上書きできないスコープからの制限的な値を尊重します。この表でキーを探し、どの値がどこから尊重されるかを確認してください。

| キー | Claude Code が尊重する値 | 備考 |
| :- | :- | :- |
| [`disableClaudeAiConnectors`](https://code.claude.com/docs/ja/settings-reference#disableclaudeaiconnectors) | 任意のスコープからの `true` | 管理ソースが `false` を設定していても尊重されます |
| [`enableArtifact`](https://code.claude.com/docs/ja/settings-reference#enableartifact) | 任意のスコープからの `false`、および任意のスコープからの `disableArtifact: true` | 管理ソースが `true` を設定していても尊重され、[Artifact ツール](https://code.claude.com/docs/ja/artifacts.md#disable-artifacts)を再びオンにする手段はありません。Claude Code v2.1.242 以降が必要です |
| [`isolatePeerMachines`](https://code.claude.com/docs/ja/settings-reference#isolatepeermachines) | 任意のスコープからの `true` | 管理ソースが `false` を設定していても尊重されます |
| [`permissions.blockReadsOutsideWorkingDirectories`](https://code.claude.com/docs/ja/settings-reference#permissions-blockreadsoutsideworkingdirectories) | 任意のスコープからの `true` | 管理ソースが `false` を設定していても尊重されます。Claude Code v2.1.257 以降が必要です |
| [`autoMode.classifyAllShell`](https://code.claude.com/docs/ja/settings-reference#automode-classifyallshell) | `~/.claude/settings.json` または `--settings` からの `true` | 管理ソースが `false` を設定していても尊重されます |
| [`remoteControlAtStartup`](https://code.claude.com/docs/ja/settings-reference#remotecontrolatstartup) | `.claude/settings.json` または `.claude/settings.local.json` からの `false` | 管理ソースが `true` を設定していても尊重されます。プロジェクトまたはローカルの `true` は無視されます |
| [`crossSessionInbound`](https://code.claude.com/docs/ja/settings-reference#crosssessioninbound) | `.claude/settings.json` または `.claude/settings.local.json` からの、`accept` \< `hold` \< `refuse` の段階でより厳格な値 | 管理設定、`--settings`、ユーザーの値より優先して尊重されます。より厳格でないプロジェクトまたはローカルの値は無視されます |
| [`useAutoModeDuringPlan`](https://code.claude.com/docs/ja/settings-reference#useautomodeduringplan) | 任意の管理ソース、`--settings`、`~/.claude/settings.json`、または `.claude/settings.local.json` からの `false` | 優先される管理ソースが `true` を設定していても尊重されます。`.claude/settings.json` 内の `false` は無視されます |
| [`syncClaudeAiSkills`](https://code.claude.com/docs/ja/settings-reference#syncclaudeaiskills) | 任意の管理ソース、`--settings`、`~/.claude/settings.json`、または `.claude/settings.local.json` からの `false` | 優先される管理ソースが `true` を設定していても尊重されます。`.claude/settings.json` 内の `false` は無視されます |
| [`syncClaudeAiPlugins`](https://code.claude.com/docs/ja/settings-reference#syncclaudeaiplugins) | 任意の管理ソース、`--settings`、`~/.claude/settings.json`、または `.claude/settings.local.json` からの `false` | 優先される管理ソースが `true` を設定していても尊重されます。`.claude/settings.json` 内の `false` は無視されます |
| [`maxEffortLevel`](https://code.claude.com/docs/ja/settings-reference#maxeffortlevel) | `--settings` を含む任意のスコープからの、より低い上限 | Claude Code が適用する管理設定がより高い上限を設定していても尊重され、最も低い上限が適用されます。Claude Code v2.1.267 以降が必要です |

Claude Code を内部で実行し、[`CLAUDE_CODE_PROVIDER_MANAGED_BY_HOST`](https://code.claude.com/docs/ja/env-vars) を設定するアプリも例外です。Claude Code は、すべての管理ソースの `model`、`fallbackModel`、`modelPicker`、`modelOverrides` キー、および管理設定の `env` ブロック内の `ANTHROPIC_MODEL` や `ANTHROPIC_DEFAULT_*_MODEL` ファミリーなどのモデル選択変数よりも、そのアプリのモデル設定を優先します。アプリが独自の許可リストを提供しない限り、Claude Code は管理設定の [`availableModels`](https://code.claude.com/docs/ja/settings-reference#availablemodels) 許可リストを有効なまま維持します。

## クラウドセッションの設定

[クラウドセッション](https://code.claude.com/docs/ja/claude-code-on-the-web.md)は[クラウド環境](https://code.claude.com/docs/ja/cloud-environments.md)で実行され、マシン上ではなくリポジトリの新しいクローンで実行されます。これにより、どの設定がそこに到達するかが変わります：

* **プロジェクト内のクラウドスレッド**：[プロジェクト](https://code.claude.com/docs/ja/claude-projects.md#what-threads-pick-up-from-your-repositories)内のクラウドスレッドでは、プロジェクトに含まれるリポジトリの数にかかわらず、リポジトリの `.claude/settings.json` の権限ルール、フック、`env` はいずれも適用されません。代わりに使用するものについては、[スレッドがリポジトリから取り込むもの](https://code.claude.com/docs/ja/claude-projects.md#what-threads-pick-up-from-your-repositories)に記載されています。
* **共有プロジェクト設定**（`.claude/settings.json`）：プロジェクトのスレッド外の 1 つのリポジトリを持つセッションで読み込まれます。ファイルはクローンの一部であり、セッションはその内部で開始されるためです。その設定をコミットして、それらのセッションに適用してください。
* **複数のリポジトリを持つ共有プロジェクト設定**：Anthropic がホストする環境では、複数のリポジトリを持つセッションはクローンの上で開始され、各リポジトリの `.claude/settings.json` から `enabledPlugins` と `extraKnownMarketplaces` キーのみを読み込み、権限ルール、フック、`env`、またはその他のキーは読み込みません。これら 2 つのキーが宣言するマーケットプレイスとプラグインは、それでも[クラウドセッションでは読み込まれません](https://code.claude.com/docs/ja/cloud-environments.md#what-carries-over-from-your-setup)。自己ホスト型環境については、[どのリポジトリの設定が適用されるか](https://code.claude.com/docs/ja/self-hosted-environments-configuration.md#repository-settings-in-sessions-with-several-repositories)を参照してください。
* **ユーザーおよびプロジェクトローカル設定**（`~/.claude/settings.json` および `.claude/settings.local.json`）：読み込まれません。両方ともマシンに留まり、ローカルファイルはクローンにありません。
* **管理設定**：デバイスの `managed-settings.json` ファイルまたは MDM プロファイルはクラウドセッションに到達しません。組織の[サーバー管理設定](https://code.claude.com/docs/ja/server-managed-settings.md)は到達します。[サーフェスカバレッジ](https://code.claude.com/docs/ja/model-config.md#surface-coverage)はどのクラウドセッションがそれらを受け取るかをリストします。[自己ホスト型環境](https://code.claude.com/docs/ja/self-hosted-environments)もランナーイメージの管理設定ファイルを読み込みます。[Claude Code が管理ソースを結合する方法](https://code.claude.com/docs/ja/managed-settings.md#how-claude-code-combines-managed-sources)はそのファイルがいつ適用されるかを説明します。
* **`/config`**：ブラウザの claude.ai/code では、値を変更する代わりに claude.ai の **Code** または **Claude Code** 設定ページを開きます。クラウドセッションの設定を変更するには、環境で[環境変数](https://code.claude.com/docs/ja/cloud-environments.md#set-environment-variables)を設定してください。プロジェクトのスレッド外の 1 つのリポジトリを持つセッションでは、代わりにそのリポジトリの `.claude/settings.json` にキーをコミットすることもできます。

[セットアップから何が引き継がれるか](https://code.claude.com/docs/ja/cloud-environments.md#what-carries-over-from-your-setup)は残りをリストします：`CLAUDE.md`、skills、MCP サーバー、plugins、および認証情報。

## 次は何か

* [すべての設定](https://code.claude.com/docs/ja/settings-reference.md)：すべてのキー。設定する場所と例
* [設定ファイルの例](https://code.claude.com/docs/ja/settings-example.md)：個人ファイル、チームファイル、および組織の管理ファイル
* [権限を構成する](https://code.claude.com/docs/ja/permissions.md)：allow、ask、および deny ルール。Claude Code が確認なしで実行するもの
* [環境変数](https://code.claude.com/docs/ja/env-vars.md)：Claude Code が読み込む変数および `env` ブロック
* [構成をデバッグする](https://code.claude.com/docs/ja/debug-your-config.md)：設定が適用されない場合
* [Claude ディレクトリリファレンス](https://code.claude.com/docs/ja/claude-directory.md)：Claude Code が読み込むすべてのファイル。subagents、MCP サーバー、プラグイン、および `CLAUDE.md` を含む
