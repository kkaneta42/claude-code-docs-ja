> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# マネージド設定をデプロイする

> すべての開発者のマシンにマネージド設定をデプロイします。OS ごとの配信メカニズム、Claude Code がマネージドソースを組み合わせる方法、および強制の検証方法について説明します。

マネージド設定は、組織がすべての開発者のマシンにデプロイする設定です。Claude Code はこれらを他のすべてのレベルの上に適用するため、ユーザー、プロジェクト、ローカル、または `--settings` の値は、いくつかの [セキュリティに関連する例外](https://code.claude.com/docs/ja/settings.md#exceptions-to-managed-settings-precedence) を除いて、これらをオーバーライドできません。これらの例外では、下位レベルからのより厳密な値がカウントされます。

このページは、マネージド設定をデプロイするか、設定が適用されない理由をデバッグする管理者向けです。強制する内容を決定するには、[強制する内容を決定する](https://code.claude.com/docs/ja/admin-setup.md#decide-what-to-enforce) テーブルから始めてください。claude.ai コンソールパスについては、[サーバーマネージド設定](https://code.claude.com/docs/ja/server-managed-settings.md) を参照してください。開発者自身の値がどのファイルに入るかについては、[設定](https://code.claude.com/docs/ja/settings.md) を参照してください。

## マネージド設定ファイルをデプロイする

これは各マシンにポリシーを配置する最速の方法です。`managed-settings.json` ファイルです。マネージド設定の配信方法をまだ選択していない場合、またはデバイスが MDM 下にあるか開発者がクラウドセッションを実行している場合は、最初に [配信メカニズムを選択する](#choose-a-delivery-mechanism) を読んでください。

**1. managed-settings.json を作成する**

強制することを決定したキーを保持する `managed-settings.json` を作成します。これは `settings.json` と同じ JSON 形式です。[強制する内容を決定する](https://code.claude.com/docs/ja/admin-setup.md#decide-what-to-enforce) テーブルは各コントロールの背後にあるキーをリストしており、[設定リファレンス](https://code.claude.com/docs/ja/settings-reference.md) の各エントリは、マネージドソースがそれを設定できるかどうかを示しています。このファイルは 2 つのファイル読み取りをブロックし、バイパスモードをオフにし、Claude Code がユーザー、プロジェクト、ローカルファイルおよび `--allowedTools` からの権限ルールを無視するようにします。

```json managed-settings.json theme={null}
{
  "permissions": {
    "deny": [
      "Read(./.env)",
      "Read(./secrets/**)"
    ],
    "disableBypassPermissionsMode": "disable"
  },
  "allowManagedPermissionRulesOnly": true
}
```

ログイン方法、モデル、MCP サーバー、マーケットプレイスを含むより多くのマネージドキーの形状を示すより完全な例については、[組織のマネージド設定](https://code.claude.com/docs/ja/settings-example.md#an-organizations-managed-settings) を参照してください。

**2. ファイルを各マシンに配置する**

ファイルを `managed-settings.json` として、オペレーティングシステムのシステムディレクトリに保存します。フリート上のファイルを配置するために既に使用しているツールを使用します。

* **macOS**: `/Library/Application Support/ClaudeCode/managed-settings.json`
* **Linux と WSL**: `/etc/claude-code/managed-settings.json`
* **Windows**: `C:\Program Files\ClaudeCode\managed-settings.json`

**3. ポリシーが適用されたことを確認する**

1 つのマシンで、Claude Code 内で `/status` を実行します。`Setting sources` 行は `Enterprise managed settings (file)` を表示します。その後、フリートの残りにロールアウトします。[ポリシーが有効であることを確認する](#check-that-a-policy-is-in-force) は、行が見つからない場合に何を確認するかについて説明しています。

## 配信メカニズムを選択する

上記の手順で作成したファイルは、管理設定をマシンに配置する 4 つの方法のうちの 1 つです。どのメカニズムも `settings.json` ファイルと同じポリシーキーを扱うため、[設定リファレンス](https://code.claude.com/docs/ja/settings-reference.md)はそのすべてに当てはまります。一部のキーは特定のソースに結び付いており、各エントリの Scope 行にそれが記載されています:

* **配信制御**: [`policyHelper`](https://code.claude.com/docs/ja/settings-reference#policyhelper)、[`wslInheritsWindowsSettings`](https://code.claude.com/docs/ja/settings-reference#wslinheritswindowssettings)、[`managedSourcesBehavior`](https://code.claude.com/docs/ja/settings-reference#managedsourcesbehavior)
* **ゲートウェイログインキー**: [`forceLoginGatewayUrl`](https://code.claude.com/docs/ja/settings-reference#forcelogingatewayurl)、[`gatewayInternalNetworks`](https://code.claude.com/docs/ja/settings-reference#gatewayinternalnetworks)、[`forceLoginMethod`](https://code.claude.com/docs/ja/settings-reference#forceloginmethod) の `"gateway"` 値

管理設定ファイル、MDM プロファイル、claude.ai コンソールは、それが届くすべてのユーザーに 1 つのポリシーを適用します。特定の開発者グループに異なるポリシーを適用するには、そのグループに別のファイルまたはプロファイルをデプロイします。claude.ai コンソールは[まだグループを対象にできません](https://code.claude.com/docs/ja/server-managed-settings.md#current-limitations)が、セルフホストの [Claude apps gateway](https://code.claude.com/docs/ja/claude-apps-gateway) は IdP グループごとに管理設定を配信します。

複数のメカニズムが同じマシンにポリシーを配信する場合、Claude Code はデフォルトで 1 つを使用し、他は無視します。[Claude Code が管理ソースを組み合わせる方法](#how-claude-code-combines-managed-sources)では、その順序と、すべてのソースを適用するオプトインについて説明しています。

MDM とファイルの行は、まとめてエンドポイント管理設定と呼ばれます。これは、Claude Code がポリシーを取得するサーバー管理の行とは異なり、ポリシーが開発者のデバイスに保存されるためです。

以下の表を参考に、すでに行っているデバイス管理の方法に応じてメカニズムを選択してください。

| メカニズム | 配信方法 | Claude Code が読み取るタイミング | 使用する場面 |
| :- | :- | :- | :- |
| [サーバー管理設定](https://code.claude.com/docs/ja/server-managed-settings.md) | claude.ai 管理コンソール、またはセルフホストの [Claude apps gateway](https://code.claude.com/docs/ja/claude-apps-gateway) 上で | 起動時に取得され、1 時間ごとにポーリングされます。[承認が必要な変更](#where-and-when-a-policy-applies)を参照してください | 各マシンに触れることなく、claude.ai 組織のポリシーを 1 か所で変更したい場合 |
| MDM または OS レベルのポリシー | Jamf、Intune、グループポリシー、または同様のツールを通じて、macOS 構成プロファイルまたは Windows `HKLM` レジストリ値として。[各メカニズムがポリシーを保存する場所](#where-each-mechanism-stores-the-policy)を参照してください | 起動時に読み取られ、30 分ごとに変更がチェックされます | すでに MDM またはグループポリシーでデバイスを管理している場合 |
| ファイルベース | 各マシンのシステムディレクトリ内の `managed-settings.json` として。[各メカニズムがポリシーを保存する場所](#where-each-mechanism-stores-the-policy)を参照してください | 起動時に読み取られ、ファイルが変更されると再読み込みされます | MDM のないマシン、Linux ホスト、または自分でビルドするイメージ |
| HKCU レジストリ、Windows および WSL | Windows `HKCU` レジストリ値として。[各メカニズムがポリシーを保存する場所](#where-each-mechanism-stores-the-policy)を参照してください | 起動時に読み取られ、30 分ごとに変更がチェックされます。Claude Code がこれを使用するのは、[これより上位の管理ドキュメントが存在せず](#present-admin-documents)、かつ[ホストが提供する親設定](#let-an-embedding-host-add-policy)が制限的なキーを提供していない場合に限られます | マシンレベルの `HKLM` キーに書き込めない場合 |

Jamf、Iru、Intune、グループポリシー用のスターターテンプレートは、[MDM サンプルリポジトリ](https://github.com/anthropics/claude-code/tree/main/examples/mdm)にあります。

組織に [HIPAA 設定](https://code.claude.com/docs/ja/hipaa-setup.md#deploy-managed-settings)が適用されている場合は、サンドボックス化、ネットワーク許可リスト、認証情報の保護、ローカルデータ保持を含むより充実した `managed-settings.json` について、[設定サンプルリポジトリ](https://github.com/anthropics/claude-code/tree/main/examples/settings)の `settings-hipaa.json` と `README-hipaa.md` を参照してください。

これらのいずれかと併せて `managed-mcp.json` を通じてデプロイする、または [`managedMcpServers`](https://code.claude.com/docs/ja/settings-reference#managedmcpservers) キーを通じて提供する管理 MCP サーバーについては、[管理 MCP 設定](https://code.claude.com/docs/ja/managed-mcp.md)を参照してください。

### ポリシーが適用される場所とタイミング

デプロイされたポリシーは、次のように開発者のセッションに反映されます:

* **サーフェス**: 開発者のマシン上では、ターミナル、VS Code および JetBrains 拡張機能、デスクトップアプリの Code タブ、[Agent SDK](https://code.claude.com/docs/ja/agent-sdk/typescript.md) のセッションが、これらすべてのソースを読み取ります。Agent SDK のセッションは、`settingSources` がユーザー、プロジェクト、ローカルのファイルを除外している場合でも管理設定を読み込みます。
* **クラウドセッション**: Anthropic がホストする環境のセッションはデバイスの MDM プロファイルやファイルを読み取らないため、そのポリシーはサーバー管理設定から提供する必要があります。[セルフホスト環境](https://code.claude.com/docs/ja/self-hosted-environments)のセッションは、ランナーイメージ内の管理設定ファイルも読み取りますが、デフォルトでは、[Claude Code がすべての管理ソースから読み取るキー](#keys-read-from-every-admin-source)を除き、サーバー管理設定がポリシーキーを 1 つも配信しない場合に限られます。両方を適用するオプトインについては、[Claude Code が管理ソースを組み合わせる方法](#how-claude-code-combines-managed-sources)で説明しています。
* **Claude Tag セッション**: [Claude Tag](https://claude.com/docs/claude-tag/overview) のセッションはクラウド環境で実行されますが、サーバー管理設定は受け取りません。[セルフホスト環境](https://code.claude.com/docs/ja/self-hosted-environments)では、ランナーイメージ内の管理設定ファイルは引き続き読み取ります。Claude Tag 自体は [Claude Tag 管理設定](https://claude.com/docs/claude-tag/admins/customize)で設定します。
* **Cowork セッション**: Claude Desktop アプリの [Cowork](https://claude.com/docs/cowork/overview) は、そのセッションを Claude Code 上で実行します。Cowork セッションでは、ユーザーが Team または Enterprise アカウントでサインインしている場合でも、Claude Code が claude.ai 管理コンソールからサーバー管理設定を取得することはありません。そのため、どのポリシーが適用されるかはセッションの実行場所によって異なります:

  * **ユーザーのマシン上**: デフォルトでは、Cowork セッション内の Claude Code はそのデバイス上の MDM または OS レベルのポリシーと管理設定ファイルを読み取るため、ポリシーはそこにデプロイします。
  * **フル VM サンドボックス内**: Claude Desktop の管理設定で [`requireCoworkFullVmSandbox`](https://claude.com/docs/third-party/claude-desktop/configuration#requirecoworkfullvmsandbox) が設定されている場合、Claude Code は仮想マシン内で実行され、そこにはデバイスの MDM ポリシーや管理設定ファイルが存在しません。
  * **リモート Cowork セッション**: これらは Anthropic が管理する VM 上で実行され、Claude Code が読み取るデバイスポリシーはありません。

  セッションがどこで実行されても、claude.ai 上の git リポジトリから、または Cowork の **Customize** から誰かがマーケットプレイスを追加すると、claude.ai は管理コンソールの [`strictKnownMarketplaces`](https://code.claude.com/docs/ja/settings-reference#strictknownmarketplaces) と [`blockedMarketplaces`](https://code.claude.com/docs/ja/settings-reference#blockedmarketplaces) のリストを自ら適用します。そのチェックについては[制限の仕組み](https://code.claude.com/docs/ja/plugins/org.md#restrict-what-users-can-install)で説明しています。[サーフェスの対応範囲](https://code.claude.com/docs/ja/model-config.md#surface-coverage)の表では、Cowork と他のサーフェスを比較しています。
* **実行中のセッション**: ほとんどの変更は、[配信メカニズムの表](#choose-a-delivery-mechanism)のスケジュールに従い、再起動なしで実行中のセッションに反映されます。
  * [`forceRemoteSettingsRefresh`](https://code.claude.com/docs/ja/settings-reference#forceremotesettingsrefresh)、[`requiredMinimumVersion`](https://code.claude.com/docs/ja/settings-reference#requiredminimumversion)、および[一部のユーザーが編集可能なキー](https://code.claude.com/docs/ja/settings.md#when-edits-take-effect)への変更は、次回のセッション開始時に有効になります。
  * 新規または変更された [`policyHelper`](https://code.claude.com/docs/ja/settings-reference#policyhelper) エントリは、次回の起動時に有効になります。その起動時にサーバー管理設定がヘルパーを覆い隠している場合、取得によってそれらの設定の削除が報告されるとすぐにヘルパーが実行されます。
* **承認が必要な変更**: [次回の起動まで待機する更新](https://code.claude.com/docs/ja/server-managed-settings.md#fetch-and-caching-behavior)を除き、フックや `env` 変数など[承認が必要な](https://code.claude.com/docs/ja/server-managed-settings.md#security-approval-dialogs)設定に対するサーバー管理の変更は、対話型セッションでは開発者がダイアログを承認するまで待機し、IDE 拡張機能または Agent SDK がホストするセッションでは現在の実行に適用されます。その他のサーバー管理の変更は、次回のポーリングで適用されます。
* **長期間のセッション**: 数週間開いたままのセッションは、ロールアウトに遅れることがあります。[`requiredMinimumVersion`](https://code.claude.com/docs/ja/settings-reference#requiredminimumversion) は古いバイナリの起動をブロックしますが、すでに実行中のセッションを終了させることはありません。

### 各メカニズムがポリシーを保存する場所

キーはどこでも同じですが、各メカニズムはそれらを異なる場所と形式で保存します:

* **サーバー管理**: Anthropic のサーバー、またはユーザーのゲートウェイがポリシーを保持します。Claude Code はローカルキャッシュを保持し、起動時にそれを適用し、[取得が成功するたびに置き換えます](https://code.claude.com/docs/ja/server-managed-settings.md#security-considerations)。
* **macOS 構成プロファイル**: `com.anthropic.claudecode` 管理環境設定ドメイン。`managed-settings.json` と同じトップレベルキーを使用し、ネストされた設定は辞書として、リストは plist 配列として記述します。
* **Windows HKLM レジストリ**: `HKLM\SOFTWARE\Policies\ClaudeCode` の下にある `Settings` という名前の `REG_SZ` または `REG_EXPAND_SZ` 値としての JSON。
* **ファイルベース**: システムディレクトリ内の `managed-settings.json`、オプションの `managed-settings.d/` ディレクトリ、および `managed-mcp.json`。システムディレクトリは、macOS では `/Library/Application Support/ClaudeCode/`、Linux と WSL では `/etc/claude-code/`、Windows では `C:\Program Files\ClaudeCode\` です。Claude Code は、従来の Windows パス `C:\ProgramData\ClaudeCode\managed-settings.json` を読み取りません。

  これらのファイルはいずれもシンボリックリンクとしてデプロイでき、Claude Code はリンク先のファイルを読み取ります。リンク先がシステムディレクトリの外にある場合や、リンク先がシステムディレクトリ内にとどまっていることを Claude Code が確認できない場合でも、ポリシーは引き続き適用されます。その場合は、そのファイル名を示す警告が `/status` と `claude doctor` に表示されます。警告を解消するには、リンクがシステムディレクトリ内のターゲットを指すようにしてください。
* **Windows HKCU レジストリ**: `HKCU\SOFTWARE\Policies\ClaudeCode` の下にある同じ `Settings` 値。

### ファイルベースのポリシーをチーム間で分割する

複数のチームが 1 つのポリシーの一部をそれぞれ所有している場合は、1 つの共有ファイルを編集する代わりに、各部分を同じシステムディレクトリ内の `managed-settings.json` の隣にある `managed-settings.d/` 内の個別のファイルに配置します。

Claude Code は最初に `managed-settings.json` をマージし、次にディレクトリ内のすべての `*.json` ファイルをアルファベット順にマージします。順序を制御するには、`10-telemetry.json` や `20-security.json` のように、ファイル名に数字のプレフィックスを付けます。Claude Code は、隠しファイルと `.json` で終わらないファイルを無視します。

2 つのファイルが同じキーを設定している場合、Claude Code は次のルールに従ってそれらを組み合わせます:

* **単一の値**（`"model": "opus"` や `"cleanupPeriodDays": 7` など）: 後のファイルの値が前の値を置き換えます
* **リスト**（`permissions.deny` や `sandbox.network.allowedDomains` など）: 2 つのリストが結合され、重複は削除されます
* **ネストされたブロック**（`env` や `sandbox` など）: 2 つのブロックはキーごとにマージされ、内部の各キーも同じルールに従います
* **`fallbackModel`**: 後のチェーンが前のチェーン全体を置き換えます
* **[`extraKnownMarketplaces`](https://code.claude.com/docs/ja/settings-reference#extraknownmarketplaces) と [`managedMcpServers`](https://code.claude.com/docs/ja/settings-reference#managedmcpservers)**: 同じ名前を持つ後のエントリが前のエントリ全体を置き換えます
* **[`modelPicker`](https://code.claude.com/docs/ja/settings-reference#modelpicker)**: 後のラインナップが前のラインナップ全体を置き換えます

## Claude Code が管理されたソースを組み合わせる方法

組織が同じマシンに複数の管理されたソースを配信する場合、[`managedSourcesBehavior`](https://code.claude.com/docs/ja/settings-reference#managedsourcesbehavior) キーは Claude Code が他のソースに対して何を行うかを決定します。

* **`"first-wins"`、デフォルト**: Claude Code は、少なくとも 1 つのポリシーキーを配信する最も高いランクのソースを使用し、[すべての管理者ソースから読み取られるキー](#keys-read-from-every-admin-source)内のキーを除いて、残りを無視します。Claude Code はスキップするソースについて警告を表示しません。`/status` は[使用したソースとスキップしたソースに名前を付けます](#read-the-source-in-/status)。
* **`"merge"`**: Claude Code はポリシーキーを配信するすべての管理者ソースを適用し、キーの種類ごとに組み合わせます。ほとんどのキーでは高いランクのソースの値が適用され、リストは和集合、ロックは最も厳しい値を取ります。[すべての管理されたソースを構成する](#compose-every-managed-source)では、キーを設定する場所と各種類のキーがどのように組み合わされるかを説明しています。Claude Code v2.1.242 以降が必要です。

両方の設定は同じ方法でソースをランク付けします。これらの用語はこのセクション全体で繰り返されます。

* **ポリシーキー**: 2 つの制御キー（[`wslInheritsWindowsSettings`](https://code.claude.com/docs/ja/settings-reference#wslinheritswindowssettings) と [`managedSourcesBehavior`](https://code.claude.com/docs/ja/settings-reference#managedsourcesbehavior)）以外のすべての設定キー。これらのキーのみを含む管理設定ファイルまたは MDM ポリシーはカウントされず、Claude Code は次のソースに移動します。
* **管理者ソース**: 以下の最初の 3 つのソースの 1 つ。HKCU レジストリはユーザーが書き込み可能であり、1 つではありません。

Claude Code は、最初に最優先度の順でソースをチェックします。

1. リモート設定。claude.ai から[サーバー管理設定](https://code.claude.com/docs/ja/server-managed-settings.md)として、または[Claude アプリゲートウェイ](https://code.claude.com/docs/ja/claude-apps-gateway)によって配信されます。Claude Code は、セッションが[適格な認証情報](https://code.claude.com/docs/ja/server-managed-settings.md#platform-availability)で Anthropic の API に直接認証する場合、`/login` でゲートウェイにサインインする場合、または[そのセッションに設定を提供する](https://code.claude.com/docs/ja/claude-apps-gateway-config.md#apply-code-settings-in-the-code-tab)ゲートウェイの背後で Claude Desktop の Code タブで実行される場合にのみ、このソースをフェッチします。他のプロバイダー、または `ANTHROPIC_BASE_URL` が Anthropic の API 以外を指す場合、次のソースから開始します
2. MDM または OS レベルのポリシー: macOS plist または HKLM レジストリキー
3. 管理設定ファイル、`managed-settings.d/*.json` と `managed-settings.json` をマージしたもの
4. Windows 上の HKCU レジストリ、および WSL 上で HKLM レジストリまたは Windows 管理設定ファイルが [`wslInheritsWindowsSettings`](https://code.claude.com/docs/ja/settings-reference#wslinheritswindowssettings) をオンにし、HKCU 値もそれを設定している場合の HKCU レジストリ。Claude Code は、[それより上に管理者ドキュメントが存在せず](#present-admin-documents)、[ホスト提供の親設定](#let-an-embedding-host-add-policy)が制限的なキーを提供しない場合にのみこれを読み取ります

このダイアグラムはランク付けを示し、どちらの設定でも Claude Code が最初の 3 つのソースから読み取るクロスソースキーの例を示しています。

![リモート設定から上部を通じて MDM、管理設定ファイル、および下部の HKCU レジストリにランク付けされた 4 つの管理設定ソースを示すダイアグラム。デフォルトではポリシーキーを持つ最初のソースがポリシーを提供し、残りはスキップされます。managedSourcesBehavior を merge に設定すると、ポリシーキーを持つすべての管理者ソースが寄与し、キーの種類ごとに組み合わされ、HKCU レジストリは除外されます。サイドパネルは、サンドボックスロック、forceRemoteSettingsRefresh、および変数ごとの env マージなどのクロスソースキーが、HKCU レジストリを除外するすべての管理者ソースから読み取られることを示しています。](https://mintcdn.com/claude-code/zuWID2B-Rxm8DEC8/images/managed-source-precedence.svg?fit=max\&auto=format\&n=zuWID2B-Rxm8DEC8\&q=85\&s=53f6be49f06eff48e01422c8ae1bc2e6)

### 管理者ドキュメントが存在するとみなされる場合

[管理されたソースのランク付け](#how-claude-code-combines-managed-sources)において、Claude Code は、存在する管理者ドキュメントの下にあるユーザーが書き込み可能な HKCU レジストリを決して適用しません。ドキュメントは次の場合に存在するとみなされます。

* ポリシーキーを `null` 以外の値に設定している場合（Claude Code が読み取れない値であっても）
* 存在するものの読み取れない HKLM 値、管理設定ファイル、または `managed-settings.d` ディレクトリである場合

WSL では、`/etc/claude-code` もユーザーが書き込み可能であり、[`wslInheritsWindowsSettings`](https://code.claude.com/docs/ja/settings-reference#wslinheritswindowssettings) エントリに、Windows のドキュメントがそれより上に位置する場合が示されています。

### すべての管理者ソースから読み取られるキー

デフォルトの `"first-wins"` 設定では、Claude Code はほとんどのキーを[選択したソース](#how-claude-code-combines-managed-sources)からのみ読み取り、選択したソースがそのキーを設定しないままにしている場合でも、低いランクのソースの値を無視します。

いくつかのキーは異なる動作をします。Claude Code はそれらをすべての管理者ソースから読み取るため、選択したソースが設定しない場合でも、低いランクの MDM ポリシーまたは管理設定ファイルがそれらを設定できます。Claude Code はユーザーが書き込み可能な HKCU レジストリをそのスキャンから除外します。HKCU が唯一のソースであり、ホストが親設定を提供しない場合、HKCU は選択されたソースのように適用されます。

クロスソースキーには以下が含まれます。

* `sandbox.network.allowManagedDomainsOnly` と `sandbox.filesystem.allowManagedReadPathsOnly`: 任意の管理者ソースの `true` がロックをオンにします。ロックがオンの間、Claude Code はロックするアロウリスト（`sandbox.network.allowedDomains` と `WebFetch(domain:...)` アロー ルの組み合わせ、または `sandbox.filesystem.allowRead`）をすべての管理者ソースにまたがって和集合にします。ロックがない場合、Claude Code はアロウリストを他のキーのように扱うため、`"first-wins"` では選択されていない管理者ソースのアロウリストは無視されます。
* `allowAllClaudeAiMcps`
* `allowManagedMcpServersOnly`: 任意の管理者ソースの `true` が MCP アロウリストロックをオンにします。ロックがオンの間、管理された `allowedMcpServers` リストは、1 つを設定する最も高いランクの管理者ソースから取得されます。サーバー管理リストは、低いソースのリストと組み合わせるのではなく、置き換えます。

  管理者ソースがリストを設定しない場合、[親設定](#let-an-embedding-host-add-policy)がリストを提供しない限り、デニーリストを通過するすべてのサーバーが読み込まれます。

  ロックがない場合、Claude Code は適用する管理ソースから `allowedMcpServers` を読み取るため、`"first-wins"` では選択されていない管理者ソースのリストは無視されます。Claude Code v2.1.273 以降が必要です。
* `deniedMcpServers` と [`disableClaudeAiConnectors`](https://code.claude.com/docs/ja/settings-reference#disableclaudeaiconnectors): 任意の管理者ソースのエントリまたは `true` が適用されます。Claude Code v2.1.273 以降が必要です。
* サンドボックスバイナリパス `sandbox.bwrapPath` と `sandbox.socatPath`
* サンドボックス `ripgrep` バイナリ、[`sandbox.ripgrep`](https://code.claude.com/docs/ja/settings-reference#sandbox-ripgrep)
* `sandbox.filesystem.disabled` と `sandbox.network.strictAllowlist`
* [`useAutoModeDuringPlan`](https://code.claude.com/docs/ja/settings-reference#useautomodeduringplan)、[`syncClaudeAiSkills`](https://code.claude.com/docs/ja/settings-reference#syncclaudeaiskills)、および [`syncClaudeAiPlugins`](https://code.claude.com/docs/ja/settings-reference#syncclaudeaiplugins)。任意の管理者ソースの `false` が動作をオフにします。開発者のユーザーまたはローカル設定の `false` もそれをオフにします。各キーは拒否のみが可能です。
* [`enableArtifact`](https://code.claude.com/docs/ja/settings-reference#enableartifact)。任意の管理者ソースの `false` が[Artifact ツール](https://code.claude.com/docs/ja/artifacts.md)をオフにします。開発者のユーザー、プロジェクト、またはローカル設定の `false` もそれをオフにし、ソースはそれをオンに戻しません。[どの下位レベルの値がまだカウントされるか](https://code.claude.com/docs/ja/settings.md#exceptions-to-managed-settings-precedence)を参照してください。Claude Code v2.1.242 以降が必要です。
* [`maxEffortLevel`](https://code.claude.com/docs/ja/settings-reference#maxeffortlevel)。任意の管理者ソースの最も低いキャップが適用されます。開発者が自分の設定または `--settings` で低いキャップを設定する場合、Claude Code はそれを適用します。ソースはキャップを上げることはできません。Claude Code v2.1.267 以降が必要です。
* `attribution` のコミットトレーラーオプトアウト、または非推奨の `includeCoAuthoredBy` から任意のティア
* [`forceRemoteSettingsRefresh`](https://code.claude.com/docs/ja/server-managed-settings)
* `env`。管理者ソース全体で変数ごとにマージされます。各変数は、それを定義する最も高い優先度のソースから取得されるため、低いソースは高いソースが設定しないままにした変数を埋めます。いくつかの変数は独自のルールに従います。[管理されたソース全体のキーごとの例外](https://code.claude.com/docs/ja/server-managed-settings.md#per-key-exceptions-across-managed-sources)は各変数に名前を付けます。Claude Code v2.1.223 以降が必要です。v2.1.223 より前では、Claude Code は選択されたソースの全体 `env` ブロックのみを適用しました。

[ゲートウェイログインキー](#choose-a-delivery-mechanism)は別のルールに従います。Claude Code はサーバー管理設定からそれらを読み取ることはないため、サーバー管理設定が選択されたソースである間、ポリシーキーを持つマシン上の最も高いランクの管理者ソースがそれらを提供します。それより下にランク付けされた管理者ソースの値、または HKCU レジストリの値は無視されます。

[`allowedProviders`](https://code.claude.com/docs/ja/settings-reference#allowedproviders) には独自のルールがあります。そのエントリの Scope の注記で、マシン上で設定されたリストがサーバー管理のリストとどのように組み合わされるかを説明しています。Claude Code v2.1.285 以降が必要です。

管理者ソースが `allowManagedMcpServersOnly` または `allowedMcpServers` リストを設定し、その値が実行中のものではない場合、`/status` と `claude doctor` はそのソースとキーに名前を付けます。

### すべての管理されたソースを構成する

組織が配信するすべての管理者ソースを Claude Code に適用させるには、デプロイする最も高いランクのソースで [`managedSourcesBehavior`](https://code.claude.com/docs/ja/settings-reference#managedsourcesbehavior) を `"merge"` に設定します。Claude Code はキーまたはポリシーキーを持つ最も高いランクのソースからのみキーを読み取るため、低いソースはそれ自体をそれより上のソースとのマージにオプトインすることはできず、サーバー管理設定を受け取らないマシンは MDM プロファイルにもキーが必要です。ユーザーが書き込み可能な HKCU レジストリは別のソースとマージされることはありません。Claude Code v2.1.242 以降が必要です。

`"merge"` では、Claude Code は低いソースのリストエントリ（`permissions.allow` ルールやフック など）をポリシーに追加するため、最も高いランクより下にランク付けされたすべてのソースが管理者の制御下にある場合にのみオンにします。

この表は、`"merge"` の下で Claude Code が各種類のキーをどのように組み合わせるかを示しています。[`managedSourcesBehavior` エントリ](https://code.claude.com/docs/ja/settings-reference#managedsourcesbehavior)は 3 つの行のすべてのキーに名前を付けます。制限アロウリスト、全体で取得される値、および最も高いランクのソースからのみ読み取られるキー。

| キーの種類 | Claude Code がそれを組み合わせる方法 | 例 |
| :- | :- | :- |
| リスト | すべてのソースからのエントリを組み合わせます | `permissions.allow`、`hooks`、`sandbox.network.allowedDomains`、`deniedMcpServers`、`deniedModels` |
| ロック | 任意のソースが設定する最も厳しい値を適用します。より緩い値は最も高いランクのソースからのみ適用されます | `allowManagedHooksOnly`、`permissions.disableBypassPermissionsMode`、`crossSessionInbound`、`availableModelsMatch` |
| 制限アロウリスト | それを設定する最も高いランクのソースから全体でリストを取得し、低いソースからエントリを追加しません | `availableModels`、`allowedMcpServers`、`strictKnownMarketplaces`、`allowedChannelPlugins`、および `fallbackModel` チェーン |
| 全体で取得される値 | それを設定する最も高いランクのソースから全体で値を取得し、低いソースからエントリまたはフィールドを組み合わせません | `sandbox.credentials.awsPairs`、`sandbox.ripgrep` |
| 提供される MCP サーバー | すべてのソースからサーバー名を組み合わせます。2 つのソースが同じ名前を設定する場合、最も高いランクのソースの全体エントリを適用します | `managedMcpServers` |
| 最も高いランクのソースからのみ読み取られるキー | 最も高いランクのソースがそれを設定しないままにしている場合でも、すべての低いソースのキーを無視します | `apiKeyHelper` などの認証情報ヘルパー、`forceLoginOrgUUID` などのログインピン、`modelPicker`、`permissions.defaultMode` |
| `env` | 管理者ソース全体で変数ごとにマージされます。どちらの設定でも、[すべての管理者ソースから読み取られるキー](#keys-read-from-every-admin-source)で説明されています | |
| その他のすべてのキー | それを設定する最も高いランクのソースから値を取得します | `model`、`cleanupPeriodDays` |

マシンで組み合わされたソースを確認するには、[`/status` の `Setting sources` 行を読み取ります](#read-the-source-in-/status)。そのセクションは各ラベルが何を意味するかを説明しています。

### ヘルパープログラムでポリシーを計算する

[`policyHelper`](https://code.claude.com/docs/ja/settings-reference#policyhelper) は MDM ポリシーまたは管理設定ファイルが名前を付ける実行可能ファイルであり、Claude Code はそれを実行して起動時に管理設定を計算します。選択されたソースが 1 つを構成し、ヘルパーが `managedSettings` オブジェクトを出力する場合、その出力は Claude Code が読み取る内容を変更します。

* **出力された `managedSettings` オブジェクトはセッションの唯一の管理設定です**。これは[それが他の方法で読み取るすべての管理者ソースからのキー](#keys-read-from-every-admin-source)を含みます。ただし、[`forceRemoteSettingsRefresh` は独自の起動ルールを持っています](https://code.claude.com/docs/ja/settings-reference#forceremotesettingsrefresh)。

ヘルパー実行が失敗する場合、および 1 つが失敗する場合に Claude Code が何を行うかについては、[ヘルパー失敗](https://code.claude.com/docs/ja/settings-reference.md#helper-failures)を参照してください。

### 埋め込みホストにポリシーを追加させる

別のアプリケーション（Claude Desktop、IDE 拡張機能、Agent SDK アプリなど）が Claude Code を起動する場合、そのホストは SDK `managedSettings` オプションを通じて独自の管理設定を渡すことができます。Claude Code はこれらを親設定と呼びます。

デフォルトでは、Claude Code は管理者ソースが存在する場合、親設定を無視します。サーバー管理設定、MDM または OS レベルのポリシー、または管理設定ファイル。

Claude Code が親設定を管理者ソースと並行してマージするようにするには、最も高い優先度の管理ソースで [`parentSettingsBehavior`](https://code.claude.com/docs/ja/settings-reference#parentsettingsbehavior) を `"merge"` に設定します。Claude Code はそのソースからのみキーを読み取ります。

Claude Code はホストの値のうち、Claude が実行できることを制限するものだけを保持します。知っておくべき 1 つのギャップがあります。`allowManaged*Only` ロックも設定しない限り、ホストの権限アロー ルとサンドボックスアロウリストはまだ適用されます。[親設定を制限する](https://code.claude.com/docs/ja/claude-apps-gateway#restrict-parent-settings)でロックを参照してください。

[`policyHelper`](https://code.claude.com/docs/ja/settings-reference#policyhelper) はこのキーに関係なく親マージをオフにすることができます。そのエントリは時期を示します。

Claude Code はまた、親が提供する値にこれらのチェックを適用します。

* 任意の管理者ソースが `allowManagedPermissionRulesOnly` を設定する場合、Claude Code は[親が提供する](https://code.claude.com/docs/ja/claude-apps-gateway#restrict-parent-settings)権限アロー ルと `additionalDirectories` をそれらを読み取るときにドロップします。高い優先度のソースがキーを設定しないままにしている場合でも。キーの効果は、Claude Code が適用する管理設定、または親設定がマージするように選択したものから来ます。
* Claude Code は適用する管理設定の `forceLoginOrgUUID` または `allowedMcpServers` 値を強制し、親が提供するものをブロックします。MCP アロウリストロックの外では、Claude Code が適用しない低い管理者ソースの値は適用されず、ブロックもされません。

  Claude Code v2.1.273 以降では、`allowManagedMcpServersOnly` がオンの間、1 つを設定する最も高いランクの管理者ソースからの `allowedMcpServers` リストが適用され、親のものをブロックします。これは[クロスソースキー](#keys-read-from-every-admin-source)です。親のリストは、管理者ソースがリストを設定しない場合にのみ適用されます。[`managedSourcesBehavior`](https://code.claude.com/docs/ja/settings-reference#managedsourcesbehavior) エントリは `"merge"` の下で各キーを提供するソースを示します。v2.1.223 より前では、任意の管理者ソースの値が親のものをブロックしました。
* `availableModels` の場合、Claude Code は適用する管理設定の値を強制し、親が提供するリストをブロックします。
* `strictKnownMarketplaces` の場合、Claude Code は同様に適用する管理設定のリストを強制し、親が提供するものをブロックします。親のリストは、適用された管理ソースがリストを設定しない場合にのみ適用されます。Claude Code v2.1.282 以降が必要です。
* `allowedProviders` の場合、[選択された管理ソース](#which-managed-source-claude-code-uses)のリストが親が提供するリストをブロックし、[`managedSourcesBehavior`](https://code.claude.com/docs/ja/settings-reference#managedsourcesbehavior) の `"merge"` オプトインの下では、任意の管理者ソースのリストがブロックします。Claude Code v2.1.285 以降が必要です
* 親が提供する `blockedMarketplaces` は、管理ソースが設定するブロックリストに加えて適用されます。Claude Code v2.1.282 以降が必要です。

#### 管理されたルールのみが適用される場合に Cowork フォルダアクセスを保持する

Claude Desktop アプリの [Cowork](https://claude.com/docs/cowork/overview) はそのセッションを Claude Code で実行し、各セッションにそのワーキングフォルダ（ユーザーが接続するフォルダなど）へのアクセスを許可します。セッションを起動するときに提供するアロー ルを通じて。管理ポリシーが [`allowManagedPermissionRulesOnly`](https://code.claude.com/docs/ja/settings-reference#allowmanagedpermissionrulesonly) を設定する場合、Claude Code は管理ポリシーのアロー ルのみを保持します。ホストが親設定として、`--allowedTools` として、または設定ファイルで提供するアロー ルをドロップするため、これらのフォルダへの書き込みは事前承認を失います。編集前に確認を求める Cowork セッションでは、Cowork はプロンプトを表示できず、Claude は各書き込みを保護された場所またはそれより上のパスの外のパスに解決されるため、ブロックされたと報告します。

書き込みを復元するには、Claude Code が[選択する](#precedence-within-the-managed-tier)マシンの管理ソースにこれらのフォルダのアロー ルを追加します。MDM 管理フリートでは、それは別の管理設定ファイルではなく MDM ポリシーです。この例はファイル形式を使用し、MDM ポリシーは同じキーを取ります。`allowManagedPermissionRulesOnly` を設定したままにし、各ユーザーのホームディレクトリの `CoworkProjects` フォルダの下での編集を許可します。パスをユーザーが接続するフォルダに置き換えます。

```json managed-settings.json theme={null}
{
  "allowManagedPermissionRulesOnly": true,
  "permissions": {
    "allow": [
      "Edit(~/CoworkProjects/**)"
    ]
  }
}
```

ポリシーをデプロイした後、Claude は新しい Cowork セッションでそのフォルダの下にファイルを保存できます。[読み取りと編集ルール](https://code.claude.com/docs/ja/permissions.md#read-and-edit)はパス構文（絶対パスの `//` 形式を含む）をカバーしています。

### 開発者が変更できるもの

開発者の独自の設定ファイル、`--settings` 値、およびプロジェクトファイルは管理値をオーバーライドしません。[例外](https://code.claude.com/docs/ja/settings.md#exceptions-to-managed-settings-precedence)は、より厳しい下位レベルの値がカウントされることのみを許可します。これらのケースはそのルールの外にあります。

* **セッションのモデル**: 管理された `model` はロックではなくデフォルトです。`--model` と `ANTHROPIC_MODEL` はそのセッションのモデルを選択できるため、[`availableModels`](https://code.claude.com/docs/ja/settings-reference#availablemodels) をデプロイして選択を制限します。
* **セッションの自動圧縮ウィンドウ**: 管理された [`autoCompactWindow`](https://code.claude.com/docs/ja/settings-reference#autocompactwindow) もデフォルトです。`--autocompact` フラグと `CLAUDE_CODE_AUTO_COMPACT_WINDOW` 変数は、引き続きそのセッションの[自動圧縮ウィンドウ](https://code.claude.com/docs/ja/model-config.md#set-the-auto-compact-window)を設定できます。
* **ローカル管理者権限**: マシンの管理者である開発者は、管理ソース自体を編集できます。これが MDM ツールがスケジュールでプロファイルまたはファイルを再デプロイできる理由であり、HKLM レジストリと macOS 管理設定ドメインが存在する理由です。
* **サーバー管理キャッシュ**: サーバー管理設定は Anthropic のサーバーから取得され、ローカルキャッシュへの編集は[次の成功したフェッチまでのみ続きます](https://code.claude.com/docs/ja/server-managed-settings.md#security-considerations)。
* **その他のツール**: 管理設定は Claude Code のみをバインドします。別のツールから API を呼び出す開発者はそれらの下にはありません。

## ポリシーが有効であることを確認する

開発者がポリシーが適用されていないと報告している場合、またはロールアウトがフリートへのプッシュ前に完了したことを確認したい場合があります。そのマシン上の 2 つのコマンドがこれに答えます。`/status` は Claude Code が選択した管理対象ソースを表示し、`claude doctor` はドロップしたものをリストします。

### /status でソースを読む

開発者のマシンで Claude Code 内で `/status` を実行し、`Setting sources` 行を読みます。管理対象ソースが有効な場合、その行は `Enterprise managed settings` をリストし、括弧内に Claude Code が選択したソースを表示します。

* `(remote)`：claude.ai またはゲートウェイからのサーバー管理設定
* `(plist)` または `(HKLM)`：MDM または OS ポリシー
* `(file)`、`(drop-ins)`、または `(file + drop-ins)`：`managed-settings.json`、ドロップイン ディレクトリ、またはその両方
* `(remote + file, merged)` または別のリスト（`, merged` で終わる）：組織が[すべての管理対象ソースを構成](#compose-every-managed-source)し、Claude Code がリストされたソースをポリシーにマージしました。下位のソースは、リストに表示されなくても `env` 変数を提供できます。Claude Code v2.1.242 以降が必要です
* `(HKCU)`：ユーザー書き込み可能なレジストリ フォールバック
* `(parent process)`：[埋め込みホスト](#let-an-embedding-host-add-policy)が制限的な設定を提供しました
* `(helper)`：選択した MDM またはファイル ソースによって構成された [`policyHelper`](https://code.claude.com/docs/ja/settings-reference#policyhelper)

Claude Code がマシン上で管理対象ソースを見つけたが選択しなかった場合、2 番目の行 `Skipped sources` が各ソースを名前で示します。これを読んで、ポリシーがマシンに到達しなかった場合と、到達したが高優先度のソースがオーバーライドした場合を区別します。Claude Code v2.1.242 以降が必要です。

ポリシーが適用されていない場合、`Setting sources` 行は 2 つの問題のどちらがあるかを示します。

* **行が見つかりません**：Claude Code はポリシー キーを配信する管理対象ソースを見つけませんでした。

  管理対象設定ファイルをデプロイした場合、OS のパスに配置されていることを確認し、制御キーのみではなく[ポリシー キー](#how-claude-code-combines-managed-sources)が含まれていることを確認します。有効な JSON ではないファイルはこの状態を生成しません。Claude Code は代わりに[起動を拒否](#find-entries-claude-code-dropped)します。

  代わりにサーバー管理設定を通じてデプロイした場合は、`claude doctor` を実行します。これは[フェッチ結果](https://code.claude.com/docs/ja/server-managed-settings.md#verify-settings-delivery)を報告します。
* **行が展開したソース以外のソースを名前で示す**：高優先度のソースが存在し、Claude Code があなたのソースを無視しました。`Skipped sources` がそれをリストします。[Claude Code が管理対象ソースを組み合わせる方法](#how-claude-code-combines-managed-sources)は順序を示します。

### Claude Code がドロップしたエントリを見つける

管理対象設定ファイル、MDM プロファイル、レジストリ値、またはサーバー管理ペイロードがスキーマ検証に失敗した場合、Claude Code は最初に修復できる個別エントリ（無効なパーミッション ルールなど）をスキップし、各エントリに対して警告を表示します。Claude Code はその後、値がまだ失敗するものをドロップします。ただし、値が[閉じた状態で失敗するキー](#keys-that-fail-closed)のいずれかに属する場合は除きます。

Claude Code は [`policyHelper`](https://code.claude.com/docs/ja/settings-reference#policyhelper) が出力する `managedSettings` に対してより厳密です。同じエントリ修復を行いますが、生き残るスキーマ違反は全体のヘルパー実行を失敗させ、起動時に Claude Code は起動を拒否します。これは非ゼロで終了するヘルパーと同じです。

管理対象設定ファイル、ドロップイン ファイル、MDM plist、または HKLM レジストリ値が存在するが JSON オブジェクトとして解析できない場合、Claude Code は起動を拒否し、別の管理者ソースが有効なポリシーを配信する場合でも[ソースを名前で示すエラー](https://code.claude.com/docs/ja/errors.md#managed-settings-document-could-not-be-parsed)を出力します。各ソースは次の場合にこのように失敗します。

* **管理対象設定ファイルまたはドロップイン ファイル**：ファイルが有効な JSON ではない、またはその最上位がオブジェクトではない
* **MDM plist**：macOS の `plutil` が plist が不正形式であると報告する、またはその変換されたコンテンツが JSON オブジェクトではない
* **HKLM レジストリ値**：`Settings` 値が文字列ではない、空である、または JSON オブジェクトを保持していない

3 つのソース状態はこの拒否を引き起こしません。

* 不在のファイル、プロファイル、またはレジストリ値は失敗ではありません。Claude Code はそのソースなしで実行されます。
* 空の管理対象設定ファイルは `{}` としてカウントされます。
* ユーザー書き込み可能な HKCU レジストリ キーの不正形式の値は起動をブロックしません。Claude Code は代わりに `/status` と `claude doctor` で通知として報告します。

管理対象設定ファイル、ドロップイン ファイル、`managed-settings.d/` ディレクトリ、MDM プロファイル、または HKLM レジストリ値が存在するが読み取ることができず、管理者ソースがポリシーを提供しない場合、何が起こるかは読み取りが失敗した理由によって異なります。

* オペレーティング システムが読み取りを拒否した場合（root のみが読み取れるファイルなど）、すべてのセッションはそのソースのポリシーなしで起動します。`/status` と `claude doctor` は失敗を記録し、`-p` を使用した実行では stderr にも出力されます。
* I/O エラーなど、その他の読み取り失敗の場合、すべてのセッションは起動時に[管理者に連絡するよう求めるメッセージ](https://code.claude.com/docs/ja/errors.md#unable-to-read-managed-policy-settings)を表示して終了します。

ドロップされたエントリを見つけるには、3 つの場所のいずれかを確認します。

* インタラクティブ セッションは起動時に無効なエントリをリストするダイアログを表示します。
* `-p` を使用した非インタラクティブ実行は stderr に概要を出力します。
* [`claude doctor`](https://code.claude.com/docs/ja/debug-your-config) は各無効なエントリをそのソースとフィールドでリストします。

#### 閉じた状態で失敗するキー

管理対象ソースが `allowManagedPermissionRulesOnly`、`disableAutoMode`、または `skipDangerousModePermissionPrompt` などの単一の制限的な値を持つトップレベル キーを Claude Code が読み取ることができない値に設定した場合、キーはあなたがそれを修正するまでその値として読み取られます。レポートはキーが `was present but invalid` であったと言い、Claude Code が値として扱う値を名前で示します。`sandbox` 内のキーについては、[`sandbox` 内の無効な値](#invalid-values-inside-sandbox)を参照してください。

これらのケースは閉じた状態で失敗しません。

* `null` はキーを削除します。
* 無効な `disableAllHooks` は、引用符で囲まれたブール値であっても警告とともにドロップされます。`true` を適用すると、組織自身の管理設定がデプロイするフックもアンロードされてしまうためです。
* このルールが対象とするその他のすべてのブール キーについては、文字列 `"true"` または `"false"` はそのブール値として読み取られ、`/status` に引用符を削除するよう求める通知が表示されます。

Claude Code は `permissions`、`autoMode`、`worktree`、および `attribution` ブロックをフィールドごとに修復します。全体をドロップするのではなく。

* `permissions.disableBypassPermissionsMode` などのブロック内のロックはその制限的な値として読み取られます。
* 無効な `permissions.defaultMode` は `default` として読み取られます。
* `permissions` 内の `deny` または `ask` リストを全く読み取ることができない場合、Claude Code は `allow` と `additionalDirectories` を保留するため、制限が横に書かれていない限りグラントは適用されません。レポートは各保留されたグラントと読み取ることができなかったリストを名前で示します。
* `autoMode` では、読み取ることができない `soft_deny` または `hard_deny` リスト、または無効なエントリを失った場合、`allow` と `environment` を同じ方法で保留します。

単一の制限的な値を持つキーの閉じた状態で失敗するルールとフィールドごとの修復には Claude Code v2.1.282 以降が必要です。

これらのキーは独自のフォールバックを持ちます。

| フィールド | 存在するが無効な場合の動作 |
| :- | :- |
| `allowedMcpServers` | ユーザーが追加する MCP サーバーが許可されないように、値が修正されるまで空の許可リストとして適用されます。組織が [`managedMcpServers`](https://code.claude.com/docs/ja/settings-reference#managedmcpservers) を通じて配信するサーバーは引き続きロードされ、`managed-mcp.json` サーバーは[許可リストのチェックをスキップするサーバー](https://code.claude.com/docs/ja/managed-mcp.md#servers-that-skip-the-allowlist-check)に従ってロードされます。個別の無効なエントリは削除され、有効なサブセットが適用されます。 |
| [`allowedProviders`](https://code.claude.com/docs/ja/settings-reference#allowedproviders) | 値が修正されるまで空の許可リストとして適用されるため、すべての API プロバイダーが拒否され、そのマシンで Claude Code は起動しません。個別のエントリが既知のプロバイダー名ではないだけの場合、Claude Code はそのエントリをドロップして報告し、残りを適用します。 |
| `allowedHttpHookUrls` | Claude Code は値を修正するまで空の管理[アローリスト](https://code.claude.com/docs/ja/settings-reference.md#allowedhttphookurls)を適用するため、HTTP フックは別の設定ファイルがその URL をリストしている場合にのみ実行されます。無効なエントリが 1 つだけの場合、Claude Code はそのエントリを削除し、残りを適用します。 |
| `httpHookAllowedEnvVars` | Claude Code は値を修正するまで空の管理[アローリスト](https://code.claude.com/docs/ja/settings-reference.md#httphookallowedenvvars)を適用するため、ヘッダー変数は別の設定ファイルがそれを名前で示している場合にのみ補間されます。無効なエントリが 1 つだけの場合、Claude Code はそのエントリを削除し、残りを適用します。 |
| `allowedChannelPlugins` | 値を修正するまで空のアローリストとして適用されるため、`--channels` に渡されるチャネル プラグインは許可されません。無効なエントリが 1 つだけの場合、それを削除し、残りを適用します。 |
| `strictKnownMarketplaces` | 値が修正されるまで空のアローリストとして適用されるため、[マーケットプレイス ソース](https://code.claude.com/docs/ja/plugins/org.md#restrict-what-users-can-install)は許可されません。無効なエントリ、または `hostPattern` 正規表現がコンパイルされないなど適用できないエントリは削除され、有効なサブセットが適用されます。 |
| `availableModels` | 修正されるまで空のアローリストとして適用されるため、デフォルト モデルのみが利用可能です。文字列以外のエントリは削除され、有効なサブセットが適用されます。 |
| [`availableModelsMatch`](https://code.claude.com/docs/ja/settings-reference#availablemodelsmatch) | 値が修正されるまで `exact` として扱われます。 |
| `forceLoginOrgUUID` | 値が修正されるまで、組織がログインすることは許可されません。 |
| `gatewayInternalNetworks` | 無効な値が最も高い管理対象ソースから来ている場合、そのマシン上の `/login` は値が修正されるまで、すべての新しい[クラウド ゲートウェイ](https://code.claude.com/docs/ja/claude-apps-gateway#allow-a-gateway-on-public-address-space-you-own)サインインを拒否します。 |
| `crossSessionInbound` | 最も制限的な値である `refuse` として扱われるため、値が修正されるまで[クロスセッション メッセージ](https://code.claude.com/docs/ja/cross-session-messaging.md#control-inbound-messages)のインバウンドは拒否されます。開発者は[警告](https://code.claude.com/docs/ja/errors.md#crosssessioninbound-must-be-one-of-accept-hold-refuse)を見ます。 |
| `deniedMcpServers` | 個別の無効なエントリは削除され、有効なサブセットが適用されます。完全に無効な値は警告とともにドロップされます。すべてのサーバーを拒否するとポリシーが名前を付けなかったサーバーがブロックされるためです。 |
| [`deniedModels`](https://code.claude.com/docs/ja/settings-reference#deniedmodels) | 文字列以外のエントリは削除され、リストの残りが適用されます。完全に無効な値は警告とともにドロップされ、修正されるまでモデルはブロックされません。 |
| `blockedMarketplaces` | 個別の無効なエントリは削除され、有効なサブセットが適用されます。`hostPattern` 正規表現がコンパイルされないなど、解析されるが決してマッチしないエントリは警告とともに保持されます。修正されるまでは何もブロックしませんが、[マーケットプレイス制限](https://code.claude.com/docs/ja/plugins/org.md#restrict-what-users-can-install)は有効なままです。完全に無効な値は警告とともにドロップされます。すべてのマーケットプレイスをブロックするとポリシーが名前を付けなかったソースがブロックされるためです。 |
| `sandbox` | ブロック内の 1 つの値が無効な場合、Claude Code はブロック全体をドロップしません。各種類の無効なフィールドに何が起こるかについては、[`sandbox` 内の無効な値](#invalid-values-inside-sandbox)を参照してください。 |
| `sandbox.credentials` | 回復可能な無効なエントリは `mode: "deny"` に低下し、警告が表示されます。回復不可能なエントリは削除されます。有効なエントリは適用されたままです。[管理対象設定の無効な認証情報エントリ](https://code.claude.com/docs/ja/settings-reference.md#invalid-credential-entries-in-managed-settings)を参照してください。 |
| `strictPluginOnlyCustomization` | 値がブール値でも配列でもない場合、`true` として扱われ、4 つのサーフェスすべてをロックします。このバージョンがサーフェスとして認識しない配列エントリは何もロックしません。ステータス ノートはそのようなエントリをカウントするため、タイプミスをチェックできます。 |
| `enabledPlugins` | 無効なエントリは警告とともにドロップされ、他のエントリは適用されたままです。プラグイン ID のマップではない値、またはすべてのエントリが無効な値は、警告とともに全体としてドロップされます。 |

`allowedHttpHookUrls` と `httpHookAllowedEnvVars` は設定ファイル全体でマージされるため、管理対象リストが空の間、ユーザー、プロジェクト、またはローカル設定のエントリは引き続き適用されます。

これら 2 つのキーと `allowedChannelPlugins` のフォールバックには Claude Code v2.1.267 以降が必要です。以前のバージョンは、値またはエントリが無効な場合、キー全体をドロップします。`strictKnownMarketplaces` と `blockedMarketplaces` のフォールバックには Claude Code v2.1.277 以降が必要です。以前のバージョンは、値またはエントリが無効な場合、キー全体をドロップします。`strictPluginOnlyCustomization` と `enabledPlugins` のフォールバックには Claude Code v2.1.282 以降が必要です。

`requiredMinimumVersion` と `requiredMaximumVersion` は設計上オープンに失敗します。無効な値は適用されるのではなくドロップされます。

この許容度は管理対象設定にのみ適用されます。ユーザー、プロジェクト、およびローカル設定ファイルは厳密なままです。JSON またはトップレベルの形状が検証に失敗するファイルは全体として拒否され、報告されます。不正形式のパーミッション ルールなどの個別エントリが失敗する場合は、警告とともにスキップされ、ファイルの残りが適用されます。

#### `sandbox` 内の無効な値

管理対象 `sandbox` ブロック内の 1 つの値が無効な場合、Claude Code はブロック全体をドロップしません。各フィールドを独立して検証するためです。このフィールドごとの処理には Claude Code v2.1.283 以降が必要です。v2.1.283 より前のバージョンでは、`credentials` 以外の値が無効な場合、Claude Code は [`credentials`](https://code.claude.com/docs/ja/settings-reference#invalid-credential-entries-in-managed-settings) を除くすべての `sandbox` フィールドをドロップします。

無効なフィールドに対して取得する警告は、フィールドを名前で示し、それに何が起こるかを示します。何が起こるかは、フィールドが何を制御するかによって異なります。

* Boolean キーを引用符で囲まれた `"true"` または `"false"` に設定した場合、値はその Boolean としてカウントされます。警告の代わりに、`/status` は引用符を削除するよう求める通知を表示します。
* `failIfUnavailable` が無効な場合、Claude Code は値をドロップするため、読み取り不可能な値はフリート全体でセッションの開始を停止しません。
* Claude Code は他のすべての無効な Boolean を、値が修正されるまでサンドボックスを最も厳密に保つ値として扱います。`enabled` や `network.allowManagedDomainsOnly` など、サンドボックスまたはその制限の 1 つをオンにするキーは `true` としてカウントされます。`allowUnsandboxedCommands` など、それを緩和するキーは `false` としてカウントされます。
* `credentials` 外のリスト（`excludedCommands` や `network.allowedDomains` など）では、Claude Code は無効なエントリをドロップし、リストの残りを保持します。配列ではないリスト、または有効なエントリがないリストは、まったく適用されません。
* `network.deniedDomains` またはそのいずれかのエントリが無効な間、Claude Code は `network.allowedDomains` も保留するため、管理対象アローリストは拒否リストを修正するまで何も許可しません。
* `filesystem.denyRead`、`filesystem.denyWrite`、またはそのいずれかのエントリが無効な間、Claude Code は `filesystem.allowRead` と `filesystem.allowWrite` の両方を保留するため、拒否リストを修正するまで何も許可しません。

## マネージドソースのみが設定できるキー

Claude Code は以下のキーをマネージドソースからのみ読み込みます。ユーザーまたはプロジェクト設定ファイルに配置しても効果がありません。

これらのほとんどはロックです。ロックが管理する値（権限ルールや `sandbox.network.allowedDomains` など）は、任意のレベルで設定できる通常のキーであり、ロックは Claude Code にマネージド値のみを尊重するよう指示します。

このテーブルは権限、プラグイン、配信制御をカバーしています。ここに記載されていないキーについては、[設定リファレンス](https://code.claude.com/docs/ja/settings-reference.md#all-settings)インデックスの Scope 列に、それがマネージドのみかどうかが記載されています。

| 設定 | 説明 |
| :- | :- |
| [`allowAllClaudeAiMcps`](https://code.claude.com/docs/ja/settings-reference#allowallclaudeaimcps) | デプロイされた `managed-mcp.json` と一緒に Claude Code が自身で取得する claude.ai コネクタを読み込みます。それ以外の場合は抑制されます |
| [`allowedChannelPlugins`](https://code.claude.com/docs/ja/settings-reference#allowedchannelplugins) | メッセージをプッシュできるチャネルプラグインの許可リスト。設定時にデフォルトの Anthropic 許可リストを置き換えます。`channelsEnabled: true` が必要です。[チャネルプラグインの実行を制限する](https://code.claude.com/docs/ja/channels.md#restrict-which-channel-plugins-can-run)を参照してください |
| [`allowManagedHooksOnly`](https://code.claude.com/docs/ja/settings-reference#allowmanagedhooksonly) | `true` の場合、どのフックが実行されるかを制限します。完全な効果リストについては[`allowManagedHooksOnly` の下で実行されるもの](https://code.claude.com/docs/ja/settings-reference#what-runs-under-allowmanagedhooksonly)を参照してください |
| [`allowManagedMcpServersOnly`](https://code.claude.com/docs/ja/settings-reference#allowmanagedmcpserversonly) | `true` の場合、管理設定からの `allowedMcpServers` のみが尊重されます。`deniedMcpServers` はすべてのソースからマージされます。どのマネージドソースがこれを設定できるかについては[すべての管理者ソースから読み込まれるキー](#keys-read-from-every-admin-source)を参照し、[マネージド MCP 設定](https://code.claude.com/docs/ja/managed-mcp.md)を参照してください |
| [`allowManagedPermissionRulesOnly`](https://code.claude.com/docs/ja/settings-reference#allowmanagedpermissionrulesonly) | 管理設定を権限ルールの唯一の設定ソースにします。エントリは無視するすべてのソースをリストします |
| [`blockedMarketplaces`](https://code.claude.com/docs/ja/settings-reference#blockedmarketplaces) | マーケットプレイスソースのブロックリスト。ブロックされたソースはダウンロード前にチェックされるため、ファイルシステムに触れることはありません。[マネージドマーケットプレイス制限](https://code.claude.com/docs/ja/plugins/org.md#restrict-what-users-can-install)を参照してください |
| [`channelsEnabled`](https://code.claude.com/docs/ja/settings-reference#channelsenabled) | 組織の[チャネル](https://code.claude.com/docs/ja/channels.md)を許可します。各プランのデフォルトについては[エンタープライズ制御](https://code.claude.com/docs/ja/channels.md#enterprise-controls)を参照してください |
| [`disableCommandPluginSources`](https://code.claude.com/docs/ja/settings-reference#disablecommandpluginsources) | `true` の場合、[`command` プラグインソース](https://code.claude.com/docs/ja/plugins/marketplace-reference#command-plugin-source)を完全にブロックするため、マーケットプレイスで宣言されたコマンドは実行されません。また、マーケットプレイスの[`headersHelper` コマンド](https://code.claude.com/docs/ja/plugins/host-marketplace#authenticate-archive-downloads)もブロックします。ただし、管理設定自体が宣言するマーケットプレイスは除きます。設定されていない場合は、`allowManagedHooksOnly` に従います。Claude Code v2.1.229 以降が必要であり、`headersHelper` ブロックには v2.1.238 以降が必要です |
| [`disableSideloadFlags`](https://code.claude.com/docs/ja/settings-reference#disablesideloadflags) | 起動時に `--plugin-dir`、`--plugin-url`、`--agents`、`--mcp-config` フラグを拒否します。クラウドセッションでは、Claude Code はセッションを開始し、サーバー配信の `--mcp-config` サーバーをドロップします。ただし、その[リファレンスエントリ](https://code.claude.com/docs/ja/settings-reference.md#disablesideloadflags)がリストする例外は除きます。Claude Code v2.1.193 以降が必要です |
| [`forceRemoteSettingsRefresh`](https://code.claude.com/docs/ja/settings-reference#forceremotesettingsrefresh) | `true` の場合、リモート管理設定が新たに取得されるまで CLI 起動をブロックし、取得に失敗した場合は終了します。[フェイルクローズ実装](https://code.claude.com/docs/ja/server-managed-settings.md#enforce-fail-closed-startup)を参照してください |
| [`managedMcpServers`](https://code.claude.com/docs/ja/settings-reference#managedmcpservers) | すべてのユーザーに自身のサーバーと一緒に提供されるリモート MCP サーバー。何かをロックダウンするのではなく、サーバーを提供します。[管理設定を通じてサーバーを提供する](https://code.claude.com/docs/ja/managed-mcp.md#provide-servers-through-managed-settings)を参照してください。Claude Code v2.1.259 以降が必要です |
| [`managedSourcesBehavior`](https://code.claude.com/docs/ja/settings-reference#managedsourcesbehavior) | Claude Code が最優先のマネージドソースのみを適用するか、[すべてのマネージドソースを構成する](#compose-every-managed-source)かどうか |
| [`parentSettingsBehavior`](https://code.claude.com/docs/ja/settings-reference#parentsettingsbehavior) | ホスト提供の親設定がマネージドポリシーの下でマージされるかどうか |
| [`pluginSuggestionMarketplaces`](https://code.claude.com/docs/ja/settings-reference#pluginsuggestionmarketplaces) | Claude Code がユーザーに提案できるプラグインのマーケットプレイス |
| [`pluginTrustMessage`](https://code.claude.com/docs/ja/settings-reference#plugintrustmessage) | インストール前に表示されるプラグイン信頼警告に追加されるカスタムメッセージ |
| [`policyHelper`](https://code.claude.com/docs/ja/settings-reference#policyhelper) | 起動時に管理設定を計算する実行可能ファイル。[ポリシーヘルパーで管理設定を計算する](https://code.claude.com/docs/ja/settings-reference.md#policyhelper)を参照してください |
| [`sandbox.filesystem.allowManagedReadPathsOnly`](https://code.claude.com/docs/ja/settings-reference#sandbox-filesystem-allowmanagedreadpathsonly) | `true` の場合、管理設定からの `filesystem.allowRead` パスのみが尊重されます。`denyRead` はすべてのソースからマージされます |
| [`sandbox.network.allowManagedDomainsOnly`](https://code.claude.com/docs/ja/settings-reference#sandbox-network-allowmanageddomainsonly) | マネージドの `allowedDomains` と `WebFetch(domain:...)` 許可ルールのみを尊重します。他のドメインはプロンプトなしでブロックします |
| [`strictKnownMarketplaces`](https://code.claude.com/docs/ja/settings-reference#strictknownmarketplaces) | ユーザーが追加してプラグインをインストールできるプラグインマーケットプレイスソースを制御します。[マネージドマーケットプレイス制限](https://code.claude.com/docs/ja/plugins/org.md#restrict-what-users-can-install)を参照してください |
| [`strictPluginOnlyCustomization`](https://code.claude.com/docs/ja/settings-reference#strictpluginonlycustomization) | ユーザーおよびプロジェクトソースからのスキル、エージェント、フック、MCP サーバーをブロックします。`true` はすべて 4 つをロックし、配列はどれをロックするかを指定します |
| [`wslInheritsWindowsSettings`](https://code.claude.com/docs/ja/settings-reference#wslinheritswindowssettings) | HKLM レジストリまたは `C:\Program Files\ClaudeCode` の下のファイルに設定されている場合、WSL に Windows ポリシーチェーンを読み込ませ、[Windows 管理ドキュメントが存在しない](#present-admin-documents)場合にのみ `/etc/claude-code` を読み込みます。エントリは順序を指定します |

> [!NOTE]
>
> Team および Enterprise プランでは、Owner が [Claude Code 管理設定](https://claude.ai/admin-settings/claude-code)で組織全体の [Remote Control](https://code.claude.com/docs/ja/remote-control.md) と[クラウドセッション](https://code.claude.com/docs/ja/claude-code-on-the-web.md)を有効または無効にします。Owner が Remote Control をオフにすると、Claude Code v2.1.286 以降を実行している接続済みのセッションも切断されます。各セッションは、次に組織のポリシーを更新したとき（約 1 時間に 1 回）に切断されます。それらのセッションで何が起こるかについては、[`Remote Control was turned off by your organization's policy`](https://code.claude.com/docs/ja/remote-control#remote-control-was-turned-off-by-your-organizations-policy) を参照してください。
>
> Remote Control は [`disableRemoteControl`](https://code.claude.com/docs/ja/settings-reference#disableremotecontrol) 設定でデバイスごとに無効にすることもできます。クラウドセッションにはデバイスごとの管理設定キーはありません。
>
> これらの組織設定が特定のマシンに到達したかどうかを確認するには、そこで `claude doctor` を実行し、`Organization policy` 行を読みます。この行は Claude Code がポリシーをどこから読み込んだか、または読み込まなかった理由を示します。Claude Code v2.1.261 以降が必要です。実行中のセッションでは、ポリシーが読み込まれなかった場合、`/status` は同じ行を表示します。

## 組織のテレメトリをオフにする

Claude Code は、Anthropic API を直接、LLM ゲートウェイを通じて、またはカスタム `ANTHROPIC_BASE_URL` を通じて使用するセッションで、デフォルトで Anthropic 運用 [テレメトリ](https://code.claude.com/docs/ja/data-usage.md#telemetry-services) を送信します。[API プロバイダーごとのデフォルト動作](https://code.claude.com/docs/ja/data-usage.md#default-behaviors-by-api-provider) はどのプロバイダーがそれを送信するかを示しています。すべての開発者が各人のシェルに依存することなく、マネージド設定の `env` ブロックを通じて `DISABLE_TELEMETRY` を配信することでオフにします。この例は、ポリシーが到達するすべてのユーザーに対して `DISABLE_TELEMETRY` を設定します。

```json theme={null}
{
  "env": {
    "DISABLE_TELEMETRY": "1"
  }
}
```

Claude Code は `1` の値を [承認ダイアログ](https://code.claude.com/docs/ja/server-managed-settings.md#environment-variables-and-the-approval-dialog) を表示せずに適用します。

テレメトリをオフにする場合、Claude Code はポリシーが到達する開発者の組織の [分析ダッシュボード](https://code.claude.com/docs/ja/analytics.md) を供給する使用データの送信を停止します。変数は [フィーチャーフラグフェッチが必要な機能](https://code.claude.com/docs/ja/env-vars.md#features-that-need-feature-flag-fetching) もオフにします。リモートコントロールについては、[リモートコントロール要件](https://code.claude.com/docs/ja/remote-control.md#requirements) を参照してください。

[ポリシーが適用される場所と時期](#where-and-when-a-policy-applies) は各サーフェスに到達する配信メカニズムを示し、[プラットフォーム可用性](https://code.claude.com/docs/ja/server-managed-settings.md#platform-availability) はどのセッションがサーバーマネージド設定フェッチをスキップするかを示しています。

組織がカスタマー管理暗号化キーを使用し、Claude Code をゲートウェイを通じてルーティングする場合、[プロキシとゲートウェイを構成する](https://code.claude.com/docs/ja/third-party-integrations.md#configure-proxies-and-gateways) はこれらのセッションがこの変数を必要とする理由を示しています。

## 関連項目

* [組織向けに Claude Code をセットアップする](https://code.claude.com/docs/ja/admin-setup.md): 強制する内容と方法を決定します
* [サーバーマネージド設定](https://code.claude.com/docs/ja/server-managed-settings.md): claude.ai コンソールまたはゲートウェイからポリシーを配信します
* [マネージド MCP 構成](https://code.claude.com/docs/ja/managed-mcp.md): 開発者が使用できる MCP サーバーを制御します
* [すべての設定](https://code.claude.com/docs/ja/settings-reference.md): すべてのキー。マネージドソースがそれを設定できるかどうか
* [設定ファイルの例](https://code.claude.com/docs/ja/settings-example.md#an-organizations-managed-settings): マネージドキーの形状を示す完全な `managed-settings.json`
