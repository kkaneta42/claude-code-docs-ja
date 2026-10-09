> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# サンドボックス化された Bash ツールを設定する

> 組み込みのサンドボックスを使用して、Claude Code のシェルコマンドがアクセスできるファイルとネットワークホストを制限します。サンドボックスをオンにし、境界を設定し、それによって生じる問題を解決します。

Bash サンドボックスは、Claude がユーザーのマシン上で実行するシェルコマンドの周囲に、オペレーティングシステムが適用する境界です。これらのコマンドがアクセスできるファイルとネットワークドメインを設定すると、その制限は Bash、PowerShell、Monitor の各コマンドと、それらが起動するプロセスに適用されます。コマンドの実行中にオペレーティングシステムが制限を適用するため、Claude Code はサンドボックス化されたコマンドを 1 つずつ承認を求めることなく[実行できます](#sandbox-modes)。

サンドボックスの対象はシェルコマンドのみです。Claude のファイルツール、MCP サーバー、フックは[サンドボックスの外で実行されます](#what-runs-outside-the-sandbox)。

サンドボックスは macOS、Linux、WSL2 で動作します。ネイティブ Windows では、Claude Code はコマンドをサンドボックス化せずに実行します。Windows マシンでサンドボックスを使用するには、WSL2 ディストリビューション内で Claude Code を実行してください。

<Note>
  このページでは、ユーザー自身のマシン上のシェルコマンドを囲むサンドボックスについて説明します。関連する内容は他のページで説明しています。

  * クラウドセッションがどのように分離されるかについては、[セキュリティと分離](/docs/ja/claude-code-on-the-web#security-and-isolation)を参照してください
  * dev container、カスタムコンテナ、仮想マシンなど、他の分離方法を比較するには、[サンドボックス環境](/docs/ja/sandbox-environments)を参照してください
  * Bash 以外のツールの権限プロンプトを減らすには、[権限モード](/docs/ja/permission-modes)を参照してください
</Note>

<h2 id="what-the-sandbox-restricts">
  サンドボックスが制限する内容
</h2>

サンドボックスがオンの間、Claude が実行するシェルコマンドはその境界内で起動し、それらのコマンドが起動するプロセスも同様に境界内で起動します。サンドボックスはデフォルトでオフです。オンにするには、[はじめに](#get-started)で示すようにセッションで `/sandbox` を実行するか、`~/.claude/settings.json` などの[設定ファイル](/docs/ja/settings)で [`sandbox.enabled`](/docs/ja/settings-reference#sandbox-enabled) を `true` に設定します。

次の表は、サンドボックス化されたコマンドがデフォルトでアクセスできる範囲と、各デフォルトを変更する設定を示しています。

| アクセス | デフォルト | 変更方法 |
| :- | :- | :- |
| 書き込み | 作業ディレクトリ、ユーザーごとの一時ディレクトリ、および[追加したディレクトリ](/docs/ja/permissions#additional-directories-grant-file-access-not-configuration)。[保護されたパス](#protected-paths)は書き込みが拒否されたままです | [`filesystem.allowWrite`](/docs/ja/settings-reference#sandbox-filesystem-allowwrite)、[`filesystem.denyWrite`](/docs/ja/settings-reference#sandbox-filesystem-denywrite) |
| 読み取り | `~/.ssh` や `~/.aws/credentials` などの認証情報ファイルを含む、マシンの大部分 | [`filesystem.denyRead`](/docs/ja/settings-reference#sandbox-filesystem-denyread)、[`credentials`](#protect-credentials) |
| ネットワーク | 外部への直接のルートはありません。接続はマシン上のプロキシを経由し、プロキシが各ホストを許可ドメインと照合します。許可ドメインは最初は空です。[その他のホストの扱い](#hosts-outside-your-allowed-domains)は権限モードによって決まります | [`network.allowedDomains`](/docs/ja/settings-reference#sandbox-network-alloweddomains)、[`network.deniedDomains`](/docs/ja/settings-reference#sandbox-network-denieddomains) |
| 環境変数 | Claude Code から継承され、その環境内のシークレットも含まれます | [`credentials`](#protect-credentials)、[`CLAUDE_CODE_SUBPROCESS_ENV_SCRUB`](/docs/ja/env-vars) |

Claude Code は、オープンソースの [`@anthropic-ai/sandbox-runtime`](https://github.com/anthropics/sandbox-runtime) パッケージを基にサンドボックスをビルドしています。

<h3 id="what-runs-outside-the-sandbox">
  サンドボックスの外で実行されるもの
</h3>

サンドボックスはシェルコマンドをラップします。次のツールとプロセスはサンドボックスの外で実行されます。

* **組み込みのファイルツールと Web ツール**：Read、Edit、Write、WebFetch、WebSearch などのツールは、代わりに[権限ルール](/docs/ja/permissions)に従います。`denyRead` エントリは Read ツールを止めず、`allowedDomains` は WebFetch を制限しません
* **Claude Code が起動するその他のプロセス**：コマンド[フック](/docs/ja/hooks)、ローカルの [MCP サーバー](/docs/ja/mcp)、[プラグインモニター](/docs/ja/plugins/components#monitors)、[LSP サーバー](/docs/ja/tools-reference#lsp-tool-behavior)、および[ステータスライン](/docs/ja/statusline)コマンドや `apiKeyHelper` などのヘルパーコマンドは、ユーザーの完全なアクセス権で実行されます

設定によっては、一部のシェルコマンドもサンドボックスの外で実行されます。

* **自分で入力したコマンド**：[`!` シェルモードのプロンプト](/docs/ja/interactive-mode#shell-mode-with-prefix)で入力したコマンドは、ほとんどのセッションでサンドボックス化されずに実行されます。入力したコマンドがサンドボックス内で実行されるセッションについては、[厳格サンドボックスモード](#turn-off-the-retry-with-strict-sandbox-mode)を参照してください
* **除外されたコマンド**：[`excludedCommands`](#run-commands-outside-the-sandbox-with-excludedcommands) に一致するコマンドは、サンドボックス化されずに実行されます
* **サンドボックス外での再試行**：Claude は、通常はサンドボックス内でコマンドが失敗した後に、[そのコマンドをサンドボックス外で実行するよう求める](#the-unsandboxed-retry-escape-hatch)ことがあります

このセクションで挙げたツール、プロセス、コマンドを 1 つの境界の内側に置くには、Claude Code プロセス自体を[コンテナ、仮想マシン、またはサンドボックスランタイム](/docs/ja/sandbox-environments)内で実行します。

<h2 id="get-started">
  はじめに
</h2>

サンドボックスは Claude Code に組み込まれています。インストールが必要なものはプラットフォームによって異なります。

* **macOS**：サンドボックス化には組み込みの Seatbelt フレームワークが使われるため、そのまま手順に進めます
* **Linux と WSL2**：サンドボックスは `bubblewrap` と `socat` に依存しています。これらについては [Linux と WSL2 のセットアップ](#set-up-linux-and-wsl2)で説明しています。まだインストールしていなくても、`/sandbox` から始められます。そのパネルに不足しているものが表示されるためです

<Steps>
  <Step title="/sandbox を実行する">
    Claude Code のセッションを開始し、`/sandbox` コマンドを実行します。

    ```text theme={null}
    /sandbox
    ```

    これによりサンドボックスパネルが開きます。パネルには 3 つのタブがあり、Linux でオプションの seccomp フィルターが不足している場合はさらに Dependencies タブが表示されます。

    * **Mode**：サンドボックス化されたコマンドの承認方法を選択します。次のステップで説明します
    * **Overrides**：サンドボックス内で失敗したコマンドを、サンドボックス外での実行にフォールバックできるかどうかを選択します。これは [`allowUnsandboxedCommands`](/docs/ja/settings-reference#sandbox-allowunsandboxedcommands) 設定です
    * **Config**：解決済みのサンドボックス設定を表示します

    パネルに Dependencies タブしか表示されない場合は、必須パッケージが不足しています。[Linux と WSL2 のセットアップ](#set-up-linux-and-wsl2)の説明に従ってインストールし、Claude Code を再起動してから、もう一度 `/sandbox` を実行してください。
  </Step>

  <Step title="モードを選択する">
    Mode タブで、auto-allow または regular permissions を選択します。auto-allow ではサンドボックス化されたコマンドがプロンプトなしで実行され、regular permissions ではコマンドがサンドボックス化されていても通常の権限プロンプトが維持されます。auto-allow モードでもプロンプトが表示されるコマンドについては、[サンドボックスモード](#sandbox-modes)を参照してください。
  </Step>

  <Step title="Bash コマンドを実行する">
    ビルドやテストスイートなどのコマンドを実行するよう Claude に依頼します。デフォルトでは、サンドボックス内のコマンドは、作業ディレクトリ、[ユーザーごとの一時ディレクトリ](/docs/ja/env-vars)、および `--add-dir`、`/add-dir`、`permissions.additionalDirectories` で[追加したディレクトリ](/docs/ja/permissions#additional-directories-grant-file-access-not-configuration)に書き込めます。

    コマンドが新しいネットワークドメインを初めて必要とするとき、Claude Code は承認を求めるプロンプトを表示します。[auto モード](/docs/ja/permission-modes#eliminate-prompts-with-auto-mode)では代わりに、コマンドが必要とするホストを Claude が[コマンド自体に](#per-command-allowed-domains-in-auto-mode)記載し、分類器がそれをコマンドとともに審査します。

    サンドボックスが許可する範囲を広げたり狭めたりするには、[サンドボックス化の設定](#configure-sandboxing)を参照してください。

    コンテナ内でサンドボックス化されたコマンドが `Operation not permitted` で失敗する場合は、[コンテナ内で Bubblewrap の起動に失敗する](#bubblewrap-fails-to-start-inside-a-container)を参照してください。
  </Step>
</Steps>

パネルでモードを選択すると、Claude Code はそれをプロジェクトのローカル設定 `.claude/settings.local.json` に保存します。この設定は現在のプロジェクトに適用されます。Claude Code はそこに設定を保存するときに、そのファイルをグローバル gitignore に追加します。すべてのプロジェクトでサンドボックスを有効にするには、ユーザー設定 `~/.claude/settings.json` で [`sandbox.enabled`](/docs/ja/settings-reference#sandbox-enabled) を `true` に設定します。組織内のすべての開発者にサンドボックス化を強制するには、[管理設定](#enforce-sandboxing-with-managed-settings)を使用します。

設定ファイルに書き込まずに 1 つのセッションだけサンドボックスを変更するには、[`--settings`](/docs/ja/settings#change-a-setting-for-one-session) を付けて Claude Code を起動します。たとえば次のコマンドは、ブロックされたコマンドを Claude がサンドボックス外で再試行できない、サンドボックス化されたセッションを開始します。

```bash theme={null}
claude --settings '{"sandbox": {"enabled": true, "allowUnsandboxedCommands": false}}'
```

<Warning>
  デフォルトでは、依存関係が不足している、またはプラットフォームがサポートされていないためにサンドボックスを起動できない場合、Claude Code はサンドボックス化せずにコマンドを実行します。代わりに起動時に Claude Code を終了させるには、[`sandbox.failIfUnavailable`](/docs/ja/settings-reference#sandbox-failifunavailable) を `true` に設定します。サンドボックス化をセキュリティゲートとして必須とする管理されたデプロイでは、この設定を使用できます。
</Warning>

<h3 id="confirm-commands-run-inside-the-sandbox">
  コマンドがサンドボックス内で実行されることを確認する
</h3>

サンドボックスが機能していることを確認するには、表の各行を実行するよう Claude に依頼します。[`!` プロンプト](#what-runs-outside-the-sandbox)で入力したものは通常サンドボックス外で実行されるため、自分で行を入力してもテストにはなりません。

| コマンド | サンドボックス内での結果 |
| :- | :- |
| `touch ~/sandbox-probe` | macOS では `Operation not permitted`、Linux と WSL2 では `Read-only file system` で失敗します |
| `curl --noproxy '*' https://example.com` | コマンドにはサンドボックスプロキシを迂回する経路がないため、`Could not resolve host` で失敗します |

失敗したコマンドをサンドボックス外で再試行するよう Claude が求めてきた場合は、再試行を拒否してください。`touch` が成功し、ホームディレクトリがサンドボックスでコマンドの書き込みが許可されているディレクトリに含まれていない場合は、`~/sandbox-probe` を削除してください。その後、`/sandbox` を実行して、サンドボックスがオンになっていることと、その依存関係がインストールされていることを確認します。

<h3 id="set-up-linux-and-wsl2">
  Linux と WSL2 のセットアップ
</h3>

Linux と WSL2 では、サンドボックスは次のパッケージに依存しています。

* [`bubblewrap`](https://github.com/containers/bubblewrap)：ファイルシステムの分離を強制する、特権不要のサンドボックス化ツール
* [`socat`](http://www.dest-unreach.org/socat/)：ネットワークトラフィックをサンドボックスプロキシ経由でルーティングするために使われるリレー

ディストリビューションのパッケージマネージャーでインストールします。

<Tabs>
  <Tab title="Ubuntu/Debian">
    ```bash theme={null}
    sudo apt-get install bubblewrap socat
    ```
  </Tab>

  <Tab title="Fedora">
    ```bash theme={null}
    sudo dnf install bubblewrap socat
    ```
  </Tab>
</Tabs>

依存関係が不足している場合、`/sandbox` の Dependencies タブには、`ripgrep`、`bubblewrap`、`socat`、seccomp フィルターのうちプラットフォームに不足しているものが一覧表示されます。インストールして Claude Code を再起動した後にこのタブが表示されなければ、すべての依存関係がそろっています。

Ripgrep はネイティブの Claude Code バイナリに同梱されています。seccomp フィルターはオプションで、Unix ドメインソケットのブロックを追加します。不足している場合は `npm install -g @anthropic-ai/sandbox-runtime` でインストールしてください。

必須の依存関係が不足している場合、インストールするまで Dependencies タブだけが表示されます。オプションの seccomp フィルターだけが不足している場合は、Dependencies タブが他のタブと並んで表示されます。依存関係のチェックは起動時に実行されるため、`/sandbox` にパッケージを検出させるには、インストール後に Claude Code を再起動してください。

<AccordionGroup>
  <Accordion title="Ubuntu 24.04 以降：bubblewrap によるユーザー名前空間の作成を許可する">
    Ubuntu 24.04 以降では、デフォルトの AppArmor ポリシーにより、bubblewrap が分離に必要なユーザー名前空間を作成できません。

    WSL2 内も含め、環境がこの制限を強制しているかどうかを確認するには、`sysctl kernel.apparmor_restrict_unprivileged_userns` を実行します。コマンドが `0` を返す場合は、このステップをスキップしてください。`No such file or directory` エラーが表示される場合は、キーが存在しないため、このステップをスキップできます。`1` を返す場合は、`bwrap` にこの機能を付与する AppArmor プロファイルを追加します。

    ```bash theme={null}
    sudo tee /etc/apparmor.d/bwrap > /dev/null <<'EOF'
    abi <abi/4.0>,
    include <tunables/global>

    profile bwrap /usr/bin/bwrap flags=(unconfined) {
      userns,
      include if exists <local/bwrap>
    }
    EOF
    ```

    このプロファイルは `bwrap` 自体にのみ適用され、サンドボックス内で `bwrap` が実行するコマンドには適用されません。適用するには AppArmor を再読み込みします。

    ```bash theme={null}
    sudo systemctl reload apparmor
    ```
  </Accordion>

  <Accordion title="WSL2 に関する注意事項">
    PowerShell から `wsl -l -v` を実行して WSL のバージョンを確認します。`Sandboxing requires WSL2` と表示される場合、ディストリビューションは WSL1 で実行されています。WSL2 にアップグレードするか、サンドボックス化せずに Claude Code を実行してください。

    WSL2 では、`cmd.exe`、`powershell.exe`、または `/mnt/c/` 配下のものなど Windows バイナリの起動を、WSL が Unix ソケット経由で Windows ホストに引き渡します。そのため、サンドボックス化されたコマンドがそれらを起動できるかどうかは、サンドボックスの [Unix ソケット設定](/docs/ja/settings-reference#sandbox-network-allowunixsockets)に従います。そもそもソケットをブロックするには、オプションの seccomp フィルターがインストールされている必要があります。これらの起動を許可するには、`allowAllUnixSockets` を設定します。これにより、サンドボックス化されたコマンドにすべての Unix ソケットが開放されます。
  </Accordion>
</AccordionGroup>

<h3 id="sandbox-modes">
  サンドボックスモード
</h3>

Claude Code には 2 つのサンドボックスモードがあります。どちらのモードでも、サンドボックスは同じファイルシステムとネットワークの制限を強制します。違いは、サンドボックス化されたコマンドが自動承認されるか、明示的な権限が必要かという点だけです。

<h4 id="auto-allow-mode">
  auto-allow モード
</h4>

コマンドがサンドボックス内で実行される場合、Claude Code はプロンプトなしでそのコマンドを自動的に承認します。コマンドが [`excludedCommands`](#run-commands-outside-the-sandbox-with-excludedcommands) に一致するため、または Claude が[サンドボックス外で再試行する](#the-unsandboxed-retry-escape-hatch)ためにサンドボックス外で実行される場合、そのコマンドは通常の[権限フロー](/docs/ja/permissions)を経由します。

許可していないホストに接続するサンドボックス化されたコマンドは、サンドボックス内にとどまります。接続を通すかどうかを誰が決めるかについては、[許可されたドメイン外のホスト](#hosts-outside-your-allowed-domains)で説明しています。

auto-allow モードでも、次の点は引き続き適用されます。

* 明示的な[拒否ルール](/docs/ja/permissions)は常に尊重されます
* [重要なパス](/docs/ja/permission-modes#critical-paths)を対象とする `rm` または `rmdir` コマンドは、引き続き通常の権限フローを経由します
* `Bash(git push *)` のような内容を限定した[確認ルール](/docs/ja/permissions)は、サンドボックス化されたコマンドであっても引き続きプロンプトを強制します
* 単独の `Bash` 確認ルール、またはそれと同等の `Bash(*)` 形式は、サンドボックス化されて実行されるコマンドではスキップされます。通常の権限フローにフォールバックするコマンドには引き続き適用されます。[plan モード](/docs/ja/permission-modes#analyze-before-you-edit-with-plan-mode)では、このルールはスキップされず、読み取り専用のものも含め、サンドボックス化されたコマンドに対してもプロンプトを表示します

<Info>
  auto-allow モードは権限モードの設定とは独立して動作しますが、例外が 3 つあります。[plan モード](/docs/ja/permission-modes#analyze-before-you-edit-with-plan-mode)、[コマンドごとの許可ドメイン](#per-command-allowed-domains-in-auto-mode)を持つ auto モードのコマンド、そして auto モードでのサンドボックス化されたコマンドに対する[サーバー側の分類器による審査](/docs/ja/permission-modes#how-the-classifier-evaluates-actions)です。「accept edits」モードでなくても、auto-allow が有効な場合、サンドボックス化された Bash コマンドは自動的に実行されます。つまり、ファイル編集ツールであればプロンプトが表示される Manual モードでも、サンドボックスの境界内でファイルを変更する Bash コマンドはプロンプトなしで実行されます。

  plan モードでは、auto-allow によって承認の範囲は広がりません。計画中に Claude Code がコマンドをどのように制御するかについては、[plan モード](/docs/ja/permission-modes#analyze-before-you-edit-with-plan-mode)を参照してください。
</Info>

<h4 id="regular-permissions-mode">
  regular permissions モード
</h4>

すべての Bash コマンドは、サンドボックス化されている場合でも通常の権限フローを経由します。より細かく制御できますが、より多くの承認が必要になります。

<h4 id="the-unsandboxed-retry-escape-hatch">
  サンドボックス外での再試行という抜け道
</h4>

サンドボックス外での再試行は、サンドボックスと互換性のないツールなど、サンドボックス内で失敗するコマンドのための抜け道です。サンドボックスがネットワーク接続をブロックすると、Claude Code はコマンドの結果の中で拒否されたホストを示すため、Claude は何がブロックされたかを把握できます。Claude は失敗を分析し、`dangerouslyDisableSandbox` パラメーターを付けてコマンドを再試行することがあります。

再試行されたコマンドはサンドボックス外で実行されます。インタラクティブなターミナルセッションでは、誰が承認するかは権限モードによって異なります。

* **`bypassPermissions` モード**：再試行はプロンプトなしで実行されます
* **Manual モードと `acceptEdits` モード**：「Bash command (unsandboxed)」というタイトルのプロンプトが表示されます
* **[auto モード](/docs/ja/permission-modes#eliminate-prompts-with-auto-mode)**：別の分類器モデルが基になるコマンドを評価します
* **`dontAsk` モード**：Claude Code は再試行を拒否します
* **plan モード**：[計画中に Claude Code がコマンドをどのように制御するか](/docs/ja/permission-modes#analyze-before-you-edit-with-plan-mode)を参照してください

次のルールと設定によって、再試行を誰が承認するかが変わります。

* **一致する許可ルール**：`Bash(curl *)` などの許可ルールがコマンドに一致する場合、そのルールは再試行も承認するため、コマンドはプロンプトなしでサンドボックス外で実行されます
* **パラメーターに対する確認ルール**：Bash の再試行時にプロンプトを表示させるには、`Bash(dangerouslyDisableSandbox:true)` に対する[確認ルール](/docs/ja/permissions#match-by-input-parameter)を追加します。auto モードと `bypassPermissions` モードでもプロンプトが表示され、このルールは一致する許可ルールより優先されます
* **[`permissions.blockReadsOutsideWorkingDirectories`](/docs/ja/settings-reference#permissions-blockreadsoutsideworkingdirectories)**：これがオンの間にプロンプトが表示される再試行については、[どのモードでも自動承認されないアクション](/docs/ja/permission-modes#actions-no-mode-auto-approves)で説明しています

<h4 id="turn-off-the-retry-with-strict-sandbox-mode">
  strict sandbox モードで再試行をオフにする
</h4>

[サンドボックス設定](/docs/ja/settings-reference#sandbox-settings)で `"allowUnsandboxedCommands": false` を設定すると、サンドボックス外での再試行を無効にできます。再試行が無効になると、Claude Code は `dangerouslyDisableSandbox` パラメーターを無視します。これにより、サンドボックスが動作している間、Claude が実行するコマンドは `excludedCommands` のエントリに一致しない限りサンドボックス化されます。サンドボックスを起動できないときに Claude Code がコマンドをサンドボックス外で実行しないようにするには、[`failIfUnavailable`](/docs/ja/settings-reference#sandbox-failifunavailable) も設定します。`/sandbox` の **Overrides** タブでは、この設定は **Strict sandbox mode** として表示されます。

ユーザー設定、`--settings`、または管理設定での `false` は、プロジェクトの設定で `true` が設定されていても維持されます。ユーザー設定での `false` によってサンドボックスが管理者必須になることはないため、プロジェクトのその他のサンドボックス設定は引き続き適用されます。v2.1.285 より前は、プロジェクトの `true` がユーザー設定の `false` を上書きしていました。

ユーザーまたは管理者が管理設定または `--settings` フラグで再試行を無効にすると、サンドボックスは管理者必須になります。その場合、Claude Code は、`excludedCommands` のエントリも含め、リポジトリのファイル内にあるサンドボックスを緩める設定を無視します。それらの一覧は、[管理者必須のサンドボックスにおけるリポジトリ設定](#repository-settings-under-an-admin-required-sandbox)に記載されています。

strict sandbox モードは、Claude が実行するコマンドに適用されます。[`!` シェルモードのプロンプト](/docs/ja/interactive-mode#shell-mode-with-prefix)で自分で入力したコマンドは、セッションが次のいずれかでない限り、サンドボックス外で実行されます。

* **[バックグラウンドセッション](/docs/ja/agent-view)**：strict sandbox モードはシェルモードのコマンドにも適用されます
* **[`CLAUDE_CODE_SUBPROCESS_ENV_SCRUB`](/docs/ja/env-vars#variables) が設定された Linux セッション**：シェルモードのコマンドも含め、すべてのコマンドがサンドボックス化されて実行されます

v2.1.260 より前は、strict sandbox モードはすべてのセッションでシェルモードのコマンドをサンドボックス化していました。

<h4 id="temporary-directories">
  一時ディレクトリ
</h4>

デフォルトでは、作業ディレクトリに加えて、ユーザーごとの一時ディレクトリにもサンドボックス内から書き込めます。[ファイルシステムの分離を無効にする](#disable-filesystem-isolation)場合を除き、Claude Code はサンドボックス化されたコマンドに対して `$TMPDIR` をこのディレクトリに設定するため、一時ファイルを書き込むツールは追加の設定なしで動作します。

サンドボックス化されていないコマンドは、シェルの `$TMPDIR` が設定されていればそれを継承します。そのため、ファイルシステムの分離がオンの間は、サンドボックス化されたコマンドとされていないコマンドで `$TMPDIR` が異なるディレクトリに解決されます。シェルで `$TMPDIR` が未設定または空の場合、`$TMPDIR` を参照するサンドボックス外のコマンドには、[`CLAUDE_CODE_TMPDIR`](/docs/ja/env-vars) による上書き値が渡されます。上書き値を設定していない場合や上書き値が長いパスである場合はオペレーティングシステムの一時ディレクトリが渡されるため、変数が空文字列に展開されることはありません。両者の間で一時ファイルを受け渡すには、代わりに作業ディレクトリ配下に書き込んでください。

<h2 id="configure-sandboxing">
  サンドボックスを設定する
</h2>

サンドボックスの動作は `settings.json` ファイルでカスタマイズできます。設定の完全なリファレンスについては、[設定](/docs/ja/settings-reference#sandbox-settings)を参照してください。

デフォルトでは、サンドボックス化されたコマンドが書き込めるのは、現在の作業ディレクトリ、ユーザーごとの一時ディレクトリ、そして `--add-dir`、`/add-dir`、または `permissions.additionalDirectories` で[追加したディレクトリ](/docs/ja/permissions#additional-directories-grant-file-access-not-configuration)です。`kubectl`、`terraform`、`npm` などのサブプロセスコマンドがこれらのディレクトリの外に書き込む必要がある場合は、`sandbox.filesystem.allowWrite` を使用して特定のパスへのアクセスを付与します。

```json theme={null}
{
  "sandbox": {
    "enabled": true,
    "filesystem": {
      "allowWrite": ["~/.kube", "/tmp/build"]
    }
  }
}
```

これらのパスは OS レベルで適用されるため、サンドボックス内で実行されるすべてのコマンドは、その子プロセスも含めてこれらに従います。ツールが特定の場所への書き込みアクセスを必要とする場合は、`excludedCommands` でツールをサンドボックスから完全に除外するのではなく、この方法を使用することを推奨します。

同じファイルシステム配列を複数の[設定スコープ](/docs/ja/settings#settings-precedence)で定義した場合、Claude Code はそれらをマージし、あるスコープの配列を別のスコープの配列で置き換えるのではなく、すべてのスコープのパスを結合します。[開発者がポリシーを広げないようにする](#keep-developers-from-widening-the-policy)で説明しているロックがエントリを対象としている場合、Claude Code はそのエントリをマージから除外します。

CLI の [`--setting-sources`](/docs/ja/cli-reference) や Agent SDK の [`settingSources`](/docs/ja/agent-sdk/claude-code-features#control-filesystem-settings-with-settingsources) で設定ソースを除外した場合、Claude Code はサンドボックス設定を構築する際に、そのソースの `sandbox.filesystem` エントリ、`Edit` 権限ルール、`Read` 拒否ルールを無視します。Claude Code v2.1.246 以降が必要です。

セッション中にこれらのファイルシステムリストを編集すると、Claude Code は[実行中のセッションに変更を適用する](/docs/ja/settings#when-edits-take-effect)ため、次にサンドボックス化されたコマンドは新しいパスのもとで実行されます。

サンドボックスのファイルシステムパスは標準的な規則に従います。`/tmp/build` は絶対パスで、`~/.kube` はホームディレクトリからの相対パスです。これは、絶対パスに `//path`、プロジェクト相対パスに `/path` を使用する [Read と Edit の権限ルール](/docs/ja/permissions#read-and-edit)とは異なります。相対パス、末尾のスラッシュ、ワイルドカードについては、[サンドボックスのパスプレフィックス](/docs/ja/settings-reference#sandbox-path-prefixes)を参照してください。

`sandbox.filesystem.denyWrite` と `sandbox.filesystem.denyRead` を使用して書き込みや読み取りのアクセスを拒否することもでき、`sandbox.filesystem.allowRead` を使用して拒否された領域内の特定のパスを再び許可することもできます。読み取りルールが重なる場合は、より狭いパスのルールが適用されます。

| ルールの例 | 結果 |
| :- | :- |
| `"denyRead": ["~/"]` と `"allowRead": ["~/projects"]` | `~/projects` は読み取り可能で、ホームディレクトリの残りはブロックされたままになります。より狭い許可が、拒否された領域のその部分を再び開きます |
| `"allowRead": ["~/"]` と `"denyRead": ["~/.env"]` | `~/.env` はブロックされたままで、ホームディレクトリの残りは読み取り可能です。拒否はより広い許可の内側でも維持されるため、広範な許可によってシークレットが気付かないうちに再び公開されることはありません |
| `"allowRead": ["~/"]` と `"denyRead": ["~/**/.env"]` | ホームディレクトリ配下のすべての `.env` はブロックされたままで、残りは読み取り可能です。[ワイルドカードによる拒否](/docs/ja/settings-reference#sandbox-path-prefixes)も、正確なパスと同じようにより広い許可の内側で維持されます |

以下の例では、現在のプロジェクトからの読み取りを許可しつつ、ホームディレクトリ全体からの読み取りをブロックします。相対パス `.` がプロジェクトルートに解決されるのは設定がプロジェクト設定にある場合のみなので、この設定はプロジェクトの `.claude/settings.json` に配置してください。

```json theme={null}
{
  "sandbox": {
    "enabled": true,
    "filesystem": {
      "denyRead": ["~/"],
      "allowRead": ["."]
    }
  }
}
```

同じ設定を `~/.claude/settings.json` に配置した場合、`.` は代わりに `~/.claude` に解決され、プロジェクトファイルは `denyRead` ルールによってブロックされたままになります。

作業ディレクトリを読み取り可能に保ちつつ、サンドボックス化されたコマンドによるホームディレクトリやマウントされたボリュームへの読み取りアクセスを拒否するには、パスルールを書く代わりに [`permissions.blockReadsOutsideWorkingDirectories`](/docs/ja/settings-reference#permissions-blockreadsoutsideworkingdirectories) を設定します。

<h3 id="run-commands-outside-the-sandbox-with-excludedcommands">
  `excludedCommands` でコマンドをサンドボックスの外で実行する
</h3>

[`sandbox.excludedCommands`](/docs/ja/settings-reference#sandbox-excludedcommands) にコマンドパターンを記載すると、一致するコマンドがサンドボックスの外で実行されます。つまり、ファイルシステムの制限もネットワークプロキシもありません。サンドボックス内では動作せず、完全なアクセス権を委ねても信頼できるツールに使用してください。ディレクトリやホストが 1 つ追加で必要なだけのツールであれば、コマンドをサンドボックス化したままにできる `allowWrite` や `allowedDomains` で動作する場合があります。

この例では、`docker compose` コマンドをサンドボックスから外します。すべてのプロジェクトに適用するには、`~/.claude/settings.json` に保存してください。

```json theme={null}
{
  "sandbox": {
    "enabled": true,
    "excludedCommands": ["docker compose *"]
  }
}
```

Claude Code は、Bash と Monitor の各呼び出しに対してエントリを照合します。呼び出しとは Claude が送信するコマンドライン全体であり、複数のコマンドが連結されている場合があります。呼び出しがサンドボックスの外に出るかどうかは、以下のルールによって決まります。

* **パターンの末尾は ` *` にする**: エントリは `Bash(...)` の[権限ルール](/docs/ja/permissions#permission-rule-syntax)と同じ構文を使用し、ワイルドカードのないパターンは完全一致になります。`docker` は引数のない `docker` のみに一致します。`docker *` は引数の有無にかかわらず `docker` に一致します
* **呼び出し内のすべてのコマンドが一致する必要がある**: `npm ci && docker compose build` は、別のエントリが `npm ci` をカバーしていない限り、サンドボックス化されたままです
* **Claude Code は呼び出しのテキストを照合する**: 内部で `docker` を呼び出すスクリプトや `make` ターゲットは一致せず、`/usr/local/bin/docker` も一致しません
* **サンドボックス化されたままになる呼び出しがある**: ファイルへのリダイレクト、`cd`、または `$(...)` のようなコマンド置換があると、呼び出し全体がサンドボックス化されたままになります。サンドボックス化されたままになるその他の呼び出しについては、[リファレンスのエントリ](/docs/ja/settings-reference#sandbox-excludedcommands)に記載されています
* **エントリの保存場所が影響する場合がある**: サンドボックスが[管理者によって必須化](#repository-settings-under-an-admin-required-sandbox)されている間、Claude Code は `.claude/settings.json` と `.claude/settings.local.json` 内のエントリを無視します

除外されたコマンドは、通常の権限フローを経由します。

* [読み取り専用コマンド](/docs/ja/permissions#read-only-commands)と、許可ルールでカバーされているコマンドは、プロンプトなしで実行されます
* auto モードでは、その他の除外されたコマンドを分類器がレビューします
* `bypassPermissions` モードでは、除外されたコマンドは確認ルールに一致しない限りプロンプトなしで実行されます

エントリが一致することを確認するには、Manual モードに切り替えて、`docker compose up -d` のような何かを変更する一致コマンドを実行するよう Claude に依頼します。権限プロンプトのタイトルは「Bash command (unsandboxed)」になります。

<Warning>
  除外されたコマンドは、ユーザーの完全なアクセス権で実行されます。`docker *` のような広範なエントリは、そのツールができることすべてをカバーします。インタープリター、作業ディレクトリ内のスクリプト、またはそこにあるファイルに作用するツール（`docker compose` が compose ファイルに対して行うように）をカバーするパターンを書くと、Claude はそのファイルを書き込み、その後サンドボックスの外で実行できてしまいます。パターンを狭くするほど、Claude がサンドボックスの外で実行できるものは少なくなります。
</Warning>

<h3 id="disable-filesystem-isolation">
  ファイルシステム分離を無効にする
</h3>

`sandbox.filesystem.disabled` を `true` に設定すると、ネットワーク分離を維持したままファイルシステム分離をスキップできます。以下の例では、ネットワークドメインの許可リストを維持したまま、ファイルシステム分離をオフにします。

```json theme={null}
{
  "sandbox": {
    "enabled": true,
    "filesystem": {
      "disabled": true
    },
    "network": {
      "allowedDomains": ["github.com", "*.npmjs.org"]
    }
  }
}
```

サンドボックスには独立した 2 つのレイヤーがあります。[ファイルシステム分離](#filesystem-isolation)はサンドボックス化されたコマンドが読み書きできるパスを制御し、[ネットワーク分離](#network-isolation)はそれらが到達できるドメインを制御します。ファイルシステムレイヤーをオフにすると、サンドボックス化されたコマンドはホストのファイルシステムに対して無制限の読み書きアクセスを得ますが、ネットワークの送信先は許可したドメインに限定されたままです。コマンドが何を書き込むかではなく、どこに接続するかを制御する目的でサンドボックスを使う場合に、このレイヤーをオフにしてください。

`sandbox.filesystem.disabled` のデフォルトは `false` です。Claude Code v2.1.216 以降が必要です。

<Warning>
  ファイルシステム分離がオフでコマンドが自動許可されている場合、サンドボックス化されたコマンドは、シェルの起動ファイル、`$PATH` 上の実行ファイル、`~/.claude/settings.json` など、後続のコマンドが実行または読み取るファイルを書き込み、それを利用して次回の実行時に自身のアクセス権を広げることができます。`filesystem.disabled` を `true` に設定するのは、自身のアクセス権を昇格させないと信頼できるワークロードに限定してください。[`allowManagedDomainsOnly`](#keep-developers-from-widening-the-policy) でネットワークドメインをロックするとリスクは狭まりますが、このロックはサンドボックス内で実行されるコマンドにのみ適用されるため、リスクがなくなるわけではありません。
</Warning>

<h4 id="which-settings-can-disable-it">
  無効にできる設定
</h4>

ファイルシステム分離をオフにすると、サンドボックス化されたコマンドができることが広がるため、Claude Code は以下の設定ソースからの `filesystem.disabled` のみを尊重します。

* ユーザー設定、管理設定、および `--settings` CLI フラグで設定できます。`.claude/settings.json` と `.claude/settings.local.json` のプロジェクト設定では設定できないため、チェックアウトしたプロジェクトがファイルシステム分離をオフにすることはできません。
* 管理設定が `sandbox.filesystem` を何らかの形で設定している場合、または `"mode": "deny"` の `sandbox.credentials.files` エントリを記載している場合は、管理設定のみがこのキーを設定できます。これにより、管理者がデプロイしたファイルシステムの制限が有効なまま維持されます。そのようなデプロイを緩和するには、管理設定で `"disabled": true` を設定します。
* [`CLAUDE_CODE_SUBPROCESS_ENV_SCRUB`](/docs/ja/env-vars) が設定されている場合、Claude Code は管理設定を含むすべてのソースからの `filesystem.disabled` を無視し、ファイルシステム分離をオンのまま維持します。

[有効な](/docs/ja/settings-reference#invalid-credential-entries-in-managed-settings) `mask` エントリは、起動時に Claude Code がそのエントリについて [`deny` にフォールバック](#mask-credential-files)した場合でも、このキーを固定しません。認証情報ディレクトリのようにマスクできないパスは、管理設定で明示的な `deny` エントリとして記載してください。これによりキーが固定されます。

<h4 id="what-changes-when-filesystem-isolation-is-off">
  ファイルシステム分離がオフのときに変わること
</h4>

`filesystem.disabled` を設定すると、ファイルシステムレイヤー自体が適用している保護が解除されます。他のレイヤーが適用している保護は引き続き適用されます。

| 保護 | ファイルシステム分離がオフの場合 |
| - | - |
| `filesystem.denyRead` と [`credentials.files`](#protect-credentials) の `deny` による読み取りブロック | 適用されません。どちらもファイルシステムレイヤーが適用しています |
| `credentials.envVars` の `deny` と `mask` エントリ | 適用されます。環境変数の除去はファイルシステムレイヤーから独立しています |
| マスクとして適用された [`credentials.files` の `mask` エントリ](#mask-credential-files) | 適用されます。マスキングはファイルシステムレイヤーから独立しています。[`deny` にフォールバックした](#mask-credential-files)エントリは、他の `deny` エントリと同様に適用されません |

その他に 2 つの点が変わります。

* サンドボックス化されたコマンドは、ユーザーごとの一時ディレクトリではなく、シェルの `$TMPDIR` を継承します。すべての一時ディレクトリが書き込み可能になり、Claude Code がコマンドをユーザーごとの一時ディレクトリにリダイレクトしなくなるためです。

  Linux では、親シェルでこの変数が設定されていないことがよくあります。Bash ツールのガイダンスは、`$TMPDIR` に頼るのではなく `mktemp -d` で作業用ディレクトリを作成するよう Claude に指示します。
* [`autoAllowBashIfSandboxed`](/docs/ja/settings-reference#sandbox-autoallowbashifsandboxed) のデフォルトは引き続き `true` であるため、サンドボックス化されたコマンドはプロンプトなしで実行され続けます。サンドボックス化されたコマンドでプロンプトを表示するには、`false` に設定します。

<h3 id="protect-credentials">
  認証情報を保護する
</h3>

`sandbox.credentials` 設定では、サンドボックス化されたコマンドから保護する認証情報ファイルと環境変数を宣言します。各エントリには、ファイルパスまたは環境変数と、`mode` を指定します。専用の `credentials` ブロックを使うことで、認証情報のルールをまとめて、一般的なファイルシステムのルールとは分けて管理できます。

`"mode": "deny"` のエントリでは、ファイルパスはサンドボックス内での読み取りが拒否され（`filesystem.denyRead` が適用するのと同じ制限）、環境変数はサンドボックス化された各コマンドの実行前に未設定にされます。ファイルの保護はファイルシステムレイヤーの一部であるため、[ファイルシステム分離を無効にした](#disable-filesystem-isolation)場合は適用されませんが、環境変数の保護は引き続き適用されます。

以下の例では、AWS の認証情報ファイルと SSH ディレクトリの読み取りをブロックし、サンドボックス化されたコマンドの環境から `GITHUB_TOKEN` と `NPM_TOKEN` を削除します。

```json theme={null}
{
  "sandbox": {
    "enabled": true,
    "credentials": {
      "files": [
        { "path": "~/.aws/credentials", "mode": "deny" },
        { "path": "~/.ssh", "mode": "deny" }
      ],
      "envVars": [
        { "name": "GITHUB_TOKEN", "mode": "deny" },
        { "name": "NPM_TOKEN", "mode": "deny" }
      ]
    }
  }
}
```

環境変数のエントリとファイルのエントリは `"mode": "mask"` も受け付けます。これについては[認証情報をマスクする](#mask-credentials)で説明します。

ファイルパスは、`sandbox.filesystem.*` 設定と同じ[プレフィックスのルール](/docs/ja/settings-reference#sandbox-path-prefixes)に従います。

Claude Code は、セッションが読み込むすべての[設定スコープ](/docs/ja/settings#settings-precedence)の `deny` エントリをマージします。`deny` エントリはアクセスを狭めることしかしないため、どのスコープでも追加できますが、別のスコープが追加したエントリをどのスコープも削除することはできません。

[設定ソースを除外した](#configure-sandboxing)場合:

* **プロジェクト設定またはローカル設定**: Claude Code はそれらの `credentials` エントリをいずれも適用しません。Claude Code v2.1.246 以降が必要です。
* **ユーザー設定**: Claude Code は `~/.claude/settings.json` 内の `deny` エントリを引き続き適用し、[ファイルの `mask` エントリ](#mask-credential-files)も制限として維持します（ただし、それらはプロキシが実際の値に置換することを認可しなくなります）が、[環境変数の `mask` エントリ](#mask-environment-variables)は破棄します。

組み込みの認証情報拒否リストはないため、制限されるのは記載したファイルと変数のみです。

`sandbox.credentials` は、サンドボックス化された Bash コマンドにのみ影響します。サンドボックス化にかかわらずすべてのサブプロセスから認証情報を除去するには、[`CLAUDE_CODE_SUBPROCESS_ENV_SCRUB`](/docs/ja/env-vars) を設定します。

<h3 id="mask-credentials">
  認証情報をマスクする
</h3>

認証情報をマスクすると、Claude Code はサンドボックス化されたコマンドにセンチネルと呼ばれるセッションごとのプレースホルダーを見せ、[サンドボックスプロキシ](#network-isolation)が許可したホストへの送信リクエストで実際の値に置き換えます。[認証情報を保護する](#protect-credentials)で説明した `deny` エントリは、代わりに認証情報をブロックします。macOS 上のファイルについては、Claude Code はマスクする代わりに[ファイルをブロックします](#mask-credential-files)。すべてのフィールドは [`sandbox.credentials`](/docs/ja/settings-reference#sandbox-credentials) のリファレンスに記載されています。

マスキングには以下が必要です。

* **TLS 終端**: プロキシはリクエストの内容の中で実際の値を置換するため、その内容を参照できる必要があります。プロキシ自体が TLS を終端するように、[`network.tlsTerminate`](/docs/ja/settings-reference#sandbox-network-tlsterminate) を設定してください。これを設定しない場合、マスキングは何も漏らさずに失敗します。コマンドにはセンチネルしか見えませんが、センチネルはそのままサーバーに届き、認証が失敗します。この設定ミスを確認するには、ターミナルで `claude doctor` を実行し、`TLS termination is unavailable` という警告がないか確認してください。
* **許可された送信先**: 各 `mask` エントリには `injectHosts`（実際の値の送信先として許可されるホスト）を記載できます。プロキシは[ドメイン許可リスト](#network-isolation)が許可する接続でのみ注入を行うため、各 `injectHosts` のホストは `network.allowedDomains` を通じても到達可能である必要があります。`injectHosts` のない `mask` エントリの場合、プロキシは `network.allowedDomains` 内のすべてのホストへのリクエストで実際の値に置換します。
* **信頼できる設定スコープ**: マスキングはプロキシが実際の認証情報をどこかに送信することを認可するため、Claude Code は `mask` エントリ、`network.tlsTerminate`、[`credentials.allowPlaintextInject`](/docs/ja/settings-reference#sandbox-credentials-allowplaintextinject)、`awsPairs`、`sigv4` を、ユーザー設定、管理設定、および `--settings` フラグからのみ尊重します。リポジトリの `.claude/settings.json` や `.claude/settings.local.json` 内のこれらは無視されます。管理者がサーバー管理設定を通じて `mask` エントリ、`network.tlsTerminate`、または `credentials.allowPlaintextInject` を配布する場合、それらは[承認が必要な設定](/docs/ja/server-managed-settings#security-approval-dialogs)として扱われます。

<h4 id="mask-environment-variables">
  環境変数をマスクする
</h4>

環境変数をマスクするには、その `credentials.envVars` エントリに `"mode": "mask"` を設定します。コマンドやそれがログに記録するものが実際の認証情報を保持することはありませんが、リクエストは引き続き認証されます。同じ変数がいずれかのスコープで `deny` として記載されている場合は、`deny` が優先されます。

以下の例では、2 つのトークンをマスクします。`GH_TOKEN` は `api.github.com` へのリクエストでのみ置換され、`NPM_TOKEN` は `injectHosts` がないため、`network.allowedDomains` 内のすべてのホストへのリクエストで置換されます。

```json theme={null}
{
  "sandbox": {
    "enabled": true,
    "network": {
      "tlsTerminate": {},
      "allowedDomains": ["*.github.com", "registry.npmjs.org"]
    },
    "credentials": {
      "envVars": [
        { "name": "GH_TOKEN", "mode": "mask", "injectHosts": ["api.github.com"] },
        { "name": "NPM_TOKEN", "mode": "mask" }
      ]
    }
  }
}
```

マスキングはデフォルトで値全体を置き換えます。`DATABASE_URL` 接続文字列や JWT のように構造を持つ値には、[`extract`、`decode`、`maskClaims`、`onExtractNoMatch` フィールド](/docs/ja/settings-reference#sandbox-credentials-envvars)を使用して、値を解析するツールが動作し続けるようにしてください。

<span id="ipv6-destinations-in-injecthosts" />IPv6 の送信先は、2 つのリストで異なる書き方をしてください。

* **`network.allowedDomains`**: `"[::1]"` のような角括弧付きの形式
* **`injectHosts`**: `"::1"` のような、正規の圧縮形式による角括弧なしのアドレス

プロキシはポートを無視して各 `injectHosts` エントリを接続の角括弧なしの送信先アドレスと照合するため、角括弧付き、ゾーン ID 付き、または異なる圧縮方法で書かれたものは決して一致しません。`claude doctor` は、決して一致しないエントリを `Sandbox credential injectHosts entries can never match their destination` という警告で指摘します。このチェックには Claude Code v2.1.229 以降が必要です。

<h4 id="re-sign-aws-requests">
  AWS リクエストを再署名する
</h4>

AWS リクエストはリクエストの内容に対する SigV4 署名を持つため、`AWS_ACCESS_KEY_ID` と `AWS_SECRET_ACCESS_KEY` は一緒にマスクしてください。プロキシはアクセスキーの[センチネル](#mask-credentials)によって SigV4 リクエストを検出し、実際の値でリクエストを再署名します。これには Claude Code v2.1.221 以降が必要です。シークレットのみをマスクすると、リクエストはプロキシが検出できないプレースホルダーで署名されるため、AWS で失敗します。

Claude Code は、慣例的な変数である `AWS_ACCESS_KEY_ID`、`AWS_SECRET_ACCESS_KEY`、`AWS_SESSION_TOKEN` の値全体をマスクすると、それらを自動的に 1 つの認証情報として関連付けます。AWS の認証情報が別の名前の変数にある場合は、[`credentials.awsPairs`](/docs/ja/settings-reference#sandbox-credentials-awspairs) でグループ化してください。これには Claude Code v2.1.224 以降が必要です。

ストリーミングアップロード、署名付き URL、SigV4A リクエストは、プロキシが再計算できない署名を持ちます。これらのリクエストがマスクされたペアのプレースホルダーで署名されている場合、プロキシは壊れた署名を転送するのではなく、リクエストを失敗させます。マスクされていない認証情報で署名されたリクエストが影響を受けることはありません。これらのリクエスト形式のいずれかを代わりに転送するには、[`credentials.sigv4`](/docs/ja/settings-reference#sandbox-credentials-sigv4) を使用します。これには Claude Code v2.1.224 以降が必要です。AWS は依然としてリクエストを拒否するため、呼び出し元のツールはプロキシエラーではなく AWS 自身の拒否レスポンスを受け取ります。

<h4 id="mask-credential-files">
  認証情報ファイルをマスクする
</h4>

認証情報ファイルをマスクするには、その `credentials.files` エントリに `"mode": "mask"` を設定します。ファイルのマスキングには Claude Code v2.1.221 以降が必要です。サンドボックス化されたコマンドに何が見えるかは、プラットフォームによって異なります。

* **Linux と WSL2**: サンドボックス化されたコマンドはファイルの[センチネル](#mask-credentials)コピーを読み取り、プロキシが送信リクエストで実際の値に置換します。
* **macOS**: サンドボックス化されたコマンドはファイルをまったく読み取れません。Claude Code はセンチネルコピーを作成しないため、そのファイルを使って認証するツールはサンドボックス内で動作しません。これは `deny` と同じ効果です。[ファイルシステム分離を無効にした](#disable-filesystem-isolation)場合でも、読み取りブロックは維持されます。

以下の例では、`~/.config/gh/hosts.yml` に保存された GitHub トークンをマスクします。`extract` パターンはファイルのどの部分がシークレットであるかを示すため、Linux と WSL2 では `gh` が設定の残りの部分を引き続き解析できます。

```json theme={null}
{
  "sandbox": {
    "enabled": true,
    "network": {
      "tlsTerminate": {},
      "allowedDomains": ["*.github.com"]
    },
    "credentials": {
      "files": [
        {
          "path": "~/.config/gh/hosts.yml",
          "mode": "mask",
          "extract": "oauth_token:\\s*(\\S+)",
          "injectHosts": ["api.github.com"]
        }
      ]
    }
  }
}
```

マスクが有効であることを確認するには、サンドボックス化されたコマンドで `cat ~/.config/gh/hosts.yml` を実行するよう Claude に依頼します。Linux と WSL2 では出力にトークンの代わりにセンチネルが表示され、macOS では読み取りが失敗します。

`extract` または `decode` がない場合、Claude Code はファイル全体を 1 つのセンチネルに置き換えます。これは、単独のシークレットだけを保持するファイルに適しています。部分的なマスキングと、パターンが何にも一致しない場合の動作を制御するには、[`extract`、`decode`、`maskClaims`、`onExtractNoMatch`、`maskDuplicates` フィールド](/docs/ja/settings-reference#sandbox-credentials-files)を使用してください。

<Warning>
  照合でマスクするものが見つからなかった場合、`onExtractNoMatch` のデフォルト値である `warn` はエントリをスキップするため、サンドボックス化されたコマンドはマスクされていない実際のファイルを読み取れます。macOS では、ファイルシステム分離がオンのときは常に Claude Code がパターンの実行前に `mask` エントリを `deny` として適用するため、一致しない場合の結果が有効になるのは[ファイルシステム分離がオフ](#disable-filesystem-isolation)の場合のみです。このデフォルトは正当に存在しない場合がある認証情報に適しています。シークレットが存在する可能性があるもののパターンがそれを見逃す可能性がある場合は、[`deny`](/docs/ja/settings-reference#mask-fields-for-files) を使用してください。
</Warning>

`mask` は単一のファイルに適用されるため、各認証情報ファイルを個別に記載してください。Claude Code は、安全にマスクできない `mask` エントリ（ディレクトリパス、glob パターン、8 MiB を超えるファイル、UTF-8 テキストではないファイル）については `deny` にフォールバックします。

<h2 id="how-sandboxing-works">
  サンドボックス化の仕組み
</h2>

<h3 id="filesystem-isolation">
  ファイルシステムの分離
</h3>

サンドボックス化された Bash ツールは、ファイルシステムへのアクセスを特定のディレクトリに制限します。

* **デフォルトの書き込み動作**: 現在の作業ディレクトリとそのサブディレクトリ、`--add-dir`、`/add-dir`、または [`permissions.additionalDirectories`](/docs/ja/settings-reference#permissions-additionaldirectories) で追加したディレクトリ、さらに `$TMPDIR` が指すユーザーごとの一時ディレクトリへの読み取りおよび書き込みアクセス
* **デフォルトの読み取り動作**: 特定の拒否されたディレクトリを除き、コンピューター全体への読み取りアクセス。このデフォルトでは認証情報ファイルの読み取りも許可されるため、コマンドに読み取らせたくない[認証情報を保護](#protect-credentials)してください。
* **読み取りブロック**: [`permissions.blockReadsOutsideWorkingDirectories`](/docs/ja/settings-reference#permissions-blockreadsoutsideworkingdirectories) をオンにすると、サンドボックス化されたコマンドは、[ブロック下のサンドボックス化されたコマンド](/docs/ja/settings-reference#sandboxed-commands-under-the-block)に記載されたパスを除き、ホームディレクトリおよびユーザーファイルを保持するその他のディレクトリへの読み取りアクセスも失います。このセクションでは、ブロックのこの部分が適用されない場合についても説明しています。
* **Git worktree**: 作業ディレクトリが[リンクされた git worktree](/docs/ja/worktrees) である場合、サンドボックスはメインリポジトリの共有 `.git` ディレクトリへの書き込みも許可するため、`git commit` などのコマンドで ref やインデックスを更新できます。そのディレクトリ内の `hooks/` と `config` への書き込みは引き続き拒否されます。

ネットワークの分離を維持したままファイルシステムの分離を完全にスキップするには、[`sandbox.filesystem.disabled`](#disable-filesystem-isolation) を設定します。

<h3 id="protected-paths">
  保護されたパス
</h3>

サンドボックス化されたコマンドが書き込み可能なディレクトリ内であっても、サンドボックスは Claude Code が設定やコードを読み込むファイルへの書き込みを引き続き拒否します。これらのファイルを編集できるコマンドは、自身に権限を付与したり、Claude Code がサンドボックスの外で実行するフックや MCP サーバーを追加したりできてしまうためです。権限システムには独自の[保護されたパス](/docs/ja/permission-modes#protected-paths)があり、ツールの実行前に Claude Code が何を承認するかを制御します。サンドボックスのリストは、すでに実行中のコマンドに適用されます。対象となるパスは次の 4 つのグループです。

* **作業ディレクトリとその上位のディレクトリ**: `.claude` 設定ファイル、`.claude/skills`、`.claude/agents`、`.claude/commands`、`.claude/hooks` ディレクトリ、`.mcp.json`、および `.claude/workflows` や `.claude/scheduled_tasks.json` など Claude Code が自ら実行するファイル
* **作業ディレクトリのみ**: `.bashrc` や `.zshrc` などのシェル起動ファイル、`.gitconfig`、`.vscode` および `.idea` ディレクトリ、`.git` 内の `hooks` と `config`
* **作業ディレクトリをベア git リポジトリに変えてしまうファイル**: 最上位の `HEAD`、`objects`、`refs`、および `HEAD` が隣にある場合の既存の `config` と `hooks` エントリ。`config` という名前のファイルは、`HEAD` がなくても拒否されます。Linux と WSL2 では、サンドボックス化されたコマンドの実行中に最上位の `HEAD` ファイルや `objects` または `refs` ディレクトリが出現すると、サンドボックスがそれを削除します
* **`~/.claude`、または `CLAUDE_CONFIG_DIR` が指すディレクトリ内**: その内容の大部分、および `~/.claude.json` と `.credentials.json` 認証情報ストア

セッション中に保護された設定ファイルのパスにシンボリックリンクが出現した場合、サンドボックスは次のコマンドから、そのリンク先のファイルへの書き込みも拒否します。

これらのパスのいずれかを除外する方法はありません。パスを対象とする `allowWrite` エントリや `Edit` 許可ルールでは保護は解除されません。保護をオフにする唯一の方法は [`filesystem.disabled`](#disable-filesystem-isolation) で、これはすべてのパスでファイルシステムの分離をオフにします。ご使用のマシンで解決されたこれらのパスの大部分を確認するには、`/sandbox` を実行して **Config** タブを開きます。ここでは、これらのパスがユーザー自身の `denyWrite` エントリと混在して **Denied within allowed** の下に一覧表示されます。

これらのパスのいずれかで `git merge` または `git checkout` が `unable to unlink old` で失敗する場合は、[git コマンドが `unable to unlink old` で失敗する](#a-git-command-fails-with-unable-to-unlink-old)を参照してください。

<h3 id="network-isolation">
  ネットワークの分離
</h3>

サンドボックス化されたコマンドには、ネットワークへの直接の経路がありません。

* **Linux と WSL2**: コマンドは、ユーザーのネットワークに接続されていない別のネットワーク名前空間で実行されます
* **macOS**: Seatbelt サンドボックスフレームワークが、デフォルトでサンドボックスプロキシへの接続以外の接続をブロックします

Claude Code はサンドボックスの外、ユーザーのマシン上でサンドボックスプロキシを実行し、`HTTP_PROXY`、`HTTPS_PROXY`、`ALL_PROXY` および関連する環境変数を使ってコマンドをプロキシに向けます。プロキシは、各接続のホスト名を許可ドメインおよび拒否ドメインと照合します。

ツールが到達できる範囲は、そのツールがプロキシを使用するかどうかによって異なります。

* **プロキシ変数を読み取るツール**: `curl`、`npm`、HTTPS 経由の `git` などのツールは、ホストが許可されると接続できます。ポートを指定しない `allowedDomains` エントリは、そのホストのすべてのポートを許可します
* **プロキシ変数を無視するツール**: 素の `ssh`、ほとんどのデータベースドライバーなどのツールは、許可されたホストであっても接続できません。[データベースクライアントやその他の非 HTTP ツールが許可されたホストに到達できない](#a-database-client-or-other-non-http-tool-fails-to-reach-an-allowed-host)を参照してください
* **TCP 以外のもの**: UDP、QUIC 上の HTTP/3、および `ping` などの ICMP ツールはサンドボックスの外に出られません

以下の設定と動作により、プロキシが許可するホストが制御されます。

* **ドメイン制限**: 許可ドメインは最初は空です。コマンドが新しいドメインを初めて必要とした場合の動作については、[許可ドメイン外のホスト](#hosts-outside-your-allowed-domains)で説明しています。
* **承認の選択**: プロンプトで Yes を選択すると、Claude Code は現在のセッションの残りの間、そのホストを許可します。「Yes, and don't ask again」を選択すると、Claude Code は `WebFetch(domain:...)` 許可ルールを[ローカル設定](/docs/ja/permissions#permission-system)に保存するため、今後のセッションでもそのホストは許可されたままになります。サンドボックスが[管理者必須](#repository-settings-under-an-admin-required-sandbox)の場合、Claude Code はルールをユーザー設定に保存し、すべてのプロジェクトに適用されます。
* **事前許可ドメイン**: [`allowedDomains`](/docs/ja/settings-reference#sandbox-network-alloweddomains) でドメインを事前に許可すると、プロンプトを完全に回避できます。[権限ルール](#permission-rules)で説明しているように、Claude Code は `WebFetch(domain:...)` 許可ルールのドメインも事前に許可します。
* **厳格な許可リスト**: ユーザー設定、管理設定、または CLI の `--settings` 設定で [`strictAllowlist`](/docs/ja/settings-reference#sandbox-network-strictallowlist) を `true` に設定すると、Claude Code はプロンプトを表示する代わりに、サンドボックス化されたコマンドから許可リスト外のホストへのアクセスを拒否します。許可リストは `allowedDomains` と `WebFetch(domain:...)` 許可ルールのドメインの合計で、`allowManagedDomainsOnly` が設定されている場合は管理設定のエントリのみとなります。リポジトリのエントリについては、[管理者必須のサンドボックスなしで適用されるロック](#locks-that-apply-without-an-admin-required-sandbox)で説明しています。Claude Code はこれをサンドボックス化されたコマンドにのみ適用します。`WebFetch` などのプロセス内ツールは引き続き[権限ルール](#permission-rules)に従います。リポジトリの `.claude/settings.json` または `.claude/settings.local.json` で設定しても効果はありません。Claude Code v2.1.219 以降が必要です。
* **管理設定によるロックダウン**: 管理設定で [`allowManagedDomainsOnly`](/docs/ja/settings-reference#sandbox-network-allowmanageddomainsonly) が設定されている場合、許可されていないドメインはプロンプトを表示せずに自動的にブロックされ、管理設定の `allowedDomains` と `WebFetch(domain:...)` 許可ルールのみが適用されます。
* **企業プロキシ**: ネットワークで送信トラフィックを企業プロキシ経由にする必要がある場合は、[プロキシ設定](/docs/ja/network-config#proxy-configuration)の説明に従って `HTTPS_PROXY`、`HTTP_PROXY`、`NO_PROXY` を設定します。[バックグラウンドエージェント](/docs/ja/network-config#set-network-variables-in-settings-not-the-shell)にも適用されるよう設定の `env` ブロックで設定するか、Claude Code を起動する環境で設定してください。Claude Code はドメイン許可リストを適用したうえで、許可された接続をその上流プロキシ経由でトンネリングします。`http://` と `https://` のプロキシ URL が使用でき、必要に応じて URL に Basic 認証を含めることもできます。

`WebFetch(domain:...)` ルールでは、サンドボックスは 2 つのワイルドカード形式を認識します。`*.example.com` のような先頭の `*.` と、単独の `*` です。単独の `*` 形式には Claude Code v2.1.186 以降が必要です。`WebFetch(domain:example.*)` のようにそれ以外の位置にあるワイルドカードは、フェッチには引き続き一致しますが、サンドボックス化されたコマンドには効果がありません。

<Note>
  組み込みプロキシは、要求されたホスト名に基づいて許可リストを適用し、デフォルトでは TLS トラフィックの終端や検査を行いません。実験的な [`network.tlsTerminate`](/docs/ja/settings-reference#sandbox-network-tlsterminate) 設定を使用すると、組み込みプロキシ自体が TLS を終端します。これは [`mask` 認証情報エントリ](#mask-credentials)に必要です。デフォルトの影響については[セキュリティ上の制限](#security-limitations)を、脅威モデルで TLS の検査が必要な場合は[カスタムプロキシ設定](#custom-proxy-configuration)を参照してください。
</Note>

<h4 id="hosts-outside-your-allowed-domains">
  許可ドメイン外のホスト
</h4>

サンドボックス化されたコマンドが許可ドメインにないホストに接続すると、コマンドはサンドボックス内にとどまり、判断を待ちます。インタラクティブなターミナルセッションでは、判断は権限モードによって異なります。

| 権限モード | 接続の扱い |
| :- | :- |
| `bypassPermissions` モード、および[権限のバイパスが利用可能](/docs/ja/permission-modes#skip-all-checks-with-bypasspermissions-mode)な plan モード | プロンプトなしで許可 |
| 手動モード、`acceptEdits` モード、およびそれ以外の plan モード | プロンプトが表示される |
| auto モード | コマンドが[ホストを列挙](#per-command-allowed-domains-in-auto-mode)し、分類器がそのリストを承認した場合を除き拒否 |
| `dontAsk` モード | 拒否 |

[`strictAllowlist`](/docs/ja/settings-reference#sandbox-network-strictallowlist) または [`allowManagedDomainsOnly`](/docs/ja/settings-reference#sandbox-network-allowmanageddomainsonly) がオンの場合、組み込みのサンドボックスプロキシはすべての権限モードで接続を拒否します。`bypassPermissions` モードでは、これらのいずれかがオンでない限り、許可ドメイン外のホストは許可されます。そのモードでコマンドがサンドボックスの外に出られる場合については、[サンドボックスなしでの再試行というエスケープハッチ](#the-unsandboxed-retry-escape-hatch)で説明しています。[`deniedDomains`](/docs/ja/settings-reference#sandbox-network-denieddomains) にあるホストへの接続も、すべての権限モードで拒否されます。

<h4 id="hostnames-that-resolve-to-local-addresses">
  ローカルアドレスに解決されるホスト名
</h4>

ホスト名が許可リストを通過した後、サンドボックスプロキシはその名前を解決し、ローカルアドレスのみに解決される場合は接続を拒否します。ローカルアドレスには、`127.0.0.1` などのループバックアドレス、`169.254.169.254` クラウドメタデータエンドポイントなどのリンクローカルアドレス、およびユーザー自身のマシンに割り当てられたアドレスが含まれます。`localhost` および `*.localhost` という名前は、ループバックへの解決が許可されます。

`10.0.0.0/8` などのプライベート範囲に解決される許可済みのイントラネットホスト名は接続できます。名前が拒否されるアドレスに解決されることを許可するには、`"127.0.0.1:8080"` のように、その IP アドレスを `allowedDomains` に追加します。

このチェックはホスト名に適用されます。IP アドレスへの接続は、許可ドメインと権限モードによって判断されます。また、プロキシは上流の企業プロキシ経由で送信する接続についてはこのチェックをスキップします。名前の解決はその企業プロキシが行うためです。

<h4 id="per-command-allowed-domains-in-auto-mode">
  auto モードでのコマンドごとの許可ドメイン
</h4>

サンドボックス化がオンの [auto モード](/docs/ja/permission-modes#eliminate-prompts-with-auto-mode)では、Claude は接続ごとにネットワーク承認をトリガーする代わりに、コマンドが必要とするホストをコマンド自体に指定します。サンドボックス内で実行される各 Bash、PowerShell、または [Monitor](/docs/ja/tools-reference#monitor-tool) コマンドは、サンドボックスの許可リストを超えるホストのリストを持つことができます。`registry.npmjs.org` のようなドメイン、`*.pythonhosted.org` のようなワイルドカード、または IP アドレスで、それぞれにオプションで `:port` を付けられます。分類器はホストをコマンドと一緒に審査します。Claude Code v2.1.271 以降が必要です。

承認されたリストは、そのコマンドの実行中に限り、そのコマンドに対してのみそれらのホストを開放します。セッションの許可ホストや設定には何も追加されず、次のコマンドは独自のホストを指定します。

ホストを持つコマンドは、権限ルールやサンドボックスの[自動許可モード](#sandbox-modes)によって承認されるのではなく、分類器に送られます。[確認ルール](/docs/ja/permissions#manage-permissions)によってコマンドにプロンプトが強制される場合、ターミナルの権限ダイアログではコマンドの横にホストが一覧表示され、そこで承認すると両方が対象になります。

コマンドごとのリストは、サンドボックスがデフォルトで拒否する範囲のみを広げます。[`deniedDomains`](/docs/ja/settings-reference#sandbox-network-denieddomains) のエントリは引き続きブロックされます。[`strictAllowlist`](/docs/ja/settings-reference#sandbox-network-strictallowlist) または [`allowManagedDomainsOnly`](/docs/ja/settings-reference#sandbox-network-allowmanageddomainsonly) が許可リストをロックしている場合、Claude Code はコマンドごとのリストを拒否します。

コマンドごとのリストが適用されている間、Claude Code は、承認されたどのコマンドにも列挙されていないホストへの接続を、プロンプトや分類器のチェックなしに拒否します。拒否の際はコマンドの結果にホスト名が示され、Claude はそのホストを追加してコマンドを再実行します。

<h4 id="ipv6-addresses-in-domain-lists">
  ドメインリスト内の IPv6 アドレス
</h4>

`allowedDomains`、`deniedDomains`、または `WebFetch(domain:...)` ルールで IPv6 アドレスに一致させるには、アドレスを角括弧で囲んで記述します。`"[::1]"` はすべてのポートでそのアドレスに一致し、`"[::1]:443"` はポート 443 でのみ一致します。角括弧形式には Claude Code v2.1.229 以降が必要です。

`::1:443` のような角括弧のないエントリは、アドレスとポート付きのアドレスのどちらとも解釈できるため曖昧です。

* **拒否リスト**: Claude Code はエントリが解釈され得るすべての読み方を拒否するため、意図した読み方がどちらであってもブロックされます。解釈可能な読み方がないエントリについては、Claude Code は何もブロックしません
* **許可リスト**: Claude Code は記述された以上のものを許可しません。曖昧なエントリは、ホストとポートとしての読み方が正しく解析できる場合はその読み方に書き換え、許可リストを広げるよりはエントリを完全に破棄することがあります

曖昧なエントリを見つけるには、ターミナルで `claude doctor` を実行し、`Sandbox network domain entries have unreliable spellings` という警告を確認します。曖昧なエントリはそれぞれ角括弧形式で書き直してください。

<h3 id="os-level-enforcement">
  OS レベルの適用
</h3>

サンドボックス化された Bash ツールは、オペレーティングシステムのセキュリティプリミティブを使用します。

* **macOS**: サンドボックスの適用に Seatbelt を使用します
* **Linux**: 分離に [bubblewrap](https://github.com/containers/bubblewrap) を使用します
* **WSL2**: Linux と同じく bubblewrap を使用します

[`@anthropic-ai/sandbox-runtime`](https://github.com/anthropics/sandbox-runtime) パッケージを単独で実行して、Claude Code プロセスをラップすることもできます。[サンドボックスランタイム](/docs/ja/sandbox-environments#sandbox-runtime)を参照してください。

<h2 id="how-sandboxing-relates-to-permissions-and-permission-modes">
  サンドボックスが権限と権限モードにどのように関連するか
</h2>

サンドボックス、[権限ルール](/docs/ja/permissions)、および[権限モード](/docs/ja/permission-modes)は補完的なレイヤーです。以下のセクションでは、サンドボックスが各レイヤーとどのように相互作用するかについて説明します。

<h3 id="permission-rules">
  権限ルール
</h3>

権限ルールとサンドボックスは異なるものを制御します。

* **権限ルール**は Claude Code が使用できるツールを制御し、ツールが実行される前に評価されます。Bash、Read、Edit、WebFetch、MCP、およびその他のツールを含むすべてのツールに適用されます。ただし、deny ルールまたは ask ルールは、他のツールが残っている間は[`EndConversation`](/docs/ja/tools-reference#endconversation-tool-behavior)をブロックできません。
* **サンドボックス化**は OS レベルの強制を提供し、シェルコマンドがファイルシステムおよびネットワークレベルでアクセスできるものを制限します。Bash、PowerShell、および [Monitor](/docs/ja/tools-reference#monitor-tool) ツールのコマンドとその子プロセスに適用されます。

この 2 つのレイヤーは、強制方法も異なります。Claude Code は、コマンド文字列に基づいて、またはオートモードでは別の分類器がコマンドが安全かどうかについての判断に基づいて、コマンドが実行される前に権限の決定を評価します。オペレーティングシステムは、実行中のプロセスにサンドボックス境界を強制するため、モデルが実行することを選択したものに関係なく、また許可されたコマンドがその名前が示唆するもの以上のことを行う場合でも、それが保持されます。

ファイルシステムおよびネットワーク制限は、サンドボックス設定と権限ルールの両方を通じて構成されます。

| 設定またはルール | 機能 |
| :- | :- |
| `sandbox.filesystem.allowWrite` | 作業ディレクトリ外のパスへのサブプロセス書き込みアクセスを許可します |
| `sandbox.filesystem.denyWrite` および `sandbox.filesystem.denyRead` | 特定のパスへのサブプロセスアクセスをブロックします |
| `sandbox.filesystem.allowRead` | `denyRead` 領域内の特定のパスの読み取りを再度許可します |
| [`sandbox.filesystem.disabled`](#disable-filesystem-isolation) | ネットワーク分離を維持しながら、ファイルシステムレイヤーを完全にオフにします |
| `Edit` allow ルール | `sandbox.filesystem.allowWrite` と同じ方法で、特定のパスへの書き込みアクセスを許可します |
| `Read` および `Edit` deny ルール | 特定のファイルまたはディレクトリへのアクセスをブロックします |
| `WebFetch(domain:...)` allow および deny ルール | ドメインアクセスを制御します |
| サンドボックス `allowedDomains` | Bash コマンドが到達できるドメインを制御します |
| サンドボックス `deniedDomains` | より広い `allowedDomains` ワイルドカードが許可する場合でも、特定のドメインをブロックします |

サンドボックス設定と権限ルールの両方からのパスとドメインは、最終的なサンドボックス構成にマージされます。

[claude-code リポジトリの examples ディレクトリ](https://github.com/anthropics/claude-code/tree/main/examples/settings)には、サンドボックス固有の例を含む、一般的なデプロイメントシナリオ用のスターター設定構成が含まれています。これらを出発点として使用し、ニーズに合わせて調整してください。

<h3 id="permission-modes">
  権限モード
</h3>

`/sandbox` は[権限モード](/docs/ja/permission-modes)ではありません。権限モードは、ツール呼び出しが実行されるかどうか、および最初にプロンプトが表示されるかどうかを決定しますが、サンドボックスは Bash コマンドが実行されたら何にアクセスできるかを制限します。制御対象と、アクション単位のプロンプトに代わるものが異なります。

| | 制御対象 | プロンプトに代わるもの |
| :- | :- | :- |
| `/sandbox` | Bash コマンドが実行されたら何にアクセスできるか | [オートアロー モード](#sandbox-modes)のサンドボックス境界自体 |
| [オートモード](/docs/ja/permission-modes#eliminate-prompts-with-auto-mode) | 各ツール呼び出しが実行されるかどうか | アクションをレビューする分類器 |
| `--dangerously-skip-permissions` | 各ツール呼び出しが実行されるかどうか | なし。[保護されたパス](/docs/ja/permission-modes#protected-paths)チェックもスキップされます。[モードが自動承認しないアクション](/docs/ja/permission-modes#actions-no-mode-auto-approves)は引き続き適用されます |

サンドボックスの[オートアロー モード](#sandbox-modes)は[オートモード](/docs/ja/permission-modes#eliminate-prompts-with-auto-mode)とは別です。オートアロー はサンドボックス境界がそれらを含むため Bash コマンドを承認し、オートモードはアクションをレビューするために分類器を使用します。この 2 つは独立して機能し、[サンドボックス モード](#sandbox-modes)の下にリストされている例外を除いて組み合わせることができます。無人実行の分離境界を選択するには、[サンドボックス環境](/docs/ja/sandbox-environments#how-isolation-relates-to-permission-modes)を参照してください。各フラグを開始する一般的な権限モードとサンドボックスペアリングのテーブルについては、[一般的なセットアップ](/docs/ja/permission-modes#common-setups)を参照してください。

<h2 id="configure-the-sandbox-for-your-organization">
  組織のサンドボックスを設定する
</h2>

管理者はすべてのユーザーにサンドボックス化を要求し、開発者がポリシーを広げるのを防ぎ、サンドボックストラフィックを企業プロキシを通じてルーティングできます。

<h3 id="enforce-sandboxing-with-managed-settings">
  管理設定でサンドボックス化を実施する
</h3>

すべての開発者にサンドボックスを要求するには、[管理設定](/docs/ja/managed-settings#delivery-mechanisms)を通じて `sandbox` キーを配信します。MDM で管理されるファイルまたは claude.ai の[サーバー管理設定](/docs/ja/server-managed-settings)を通じて配信します。

以下の管理設定はサンドボックスを有効化し、プラットフォームがサポートされていない場合や依存関係が不足している場合は Claude Code の起動を拒否し、モデルがサンドボックス外でコマンドを再試行するのを防止します。

```json theme={null}
{
  "sandbox": {
    "enabled": true,
    "failIfUnavailable": true,
    "allowUnsandboxedCommands": false
  }
}
```

`enabled` 以外の 2 つのキーは、サンドボックスがコマンドを実行できない場合に何が起こるかを制御します。

* **`failIfUnavailable`**：Linux の bubblewrap などの依存関係が不足している場合、サンドボックス化されていない実行にフォールバックするのではなく、Claude Code の起動をブロックします
* **`allowUnsandboxedCommands: false`**：Claude Code は `dangerouslyDisableSandbox` エスケープハッチを無視するため、サンドボックス内でコマンドが失敗しても、Claude はそれをサンドボックス外で再試行できません

これらと併せて、次の追加を検討してください。

* 分離なしで実行する必要がある組織承認済みのツールについて `excludedCommands` を追加します。この設定により、[リポジトリの設定でコマンドをサンドボックスの外に出すことができなくなる](#repository-settings-under-an-admin-required-sandbox)ためです
* `~/.aws` や `~/.ssh` などの認証情報ディレクトリと、秘密の環境変数について [`sandbox.credentials`](#protect-credentials) エントリを追加します。デフォルトの読み取りポリシーではこれらが引き続き許可されるためです

この設定は Claude が実行するコマンドをサンドボックス化します。開発者は依然として [`!` シェルモードプロンプト](/docs/ja/interactive-mode#shell-mode-with-prefix)でコマンドを入力し、Claude Code の外の任意のターミナルで既に持っているのと同じアクセス権でサンドボックス外で実行できます。入力されたコマンドがサンドボックス内で実行されるセッションについては、[strict サンドボックスモード](#turn-off-the-retry-with-strict-sandbox-mode)を参照してください。

サンドボックスはネイティブ Windows では実行されないため、`failIfUnavailable` が設定されていると、それらのマシンでは Claude Code が起動時に終了します。フリートに Windows ホストが含まれている場合は、次の方法を取れます。

* **オペレーティングシステムごとに設定を配信する**：MDM を通じて、または[管理設定ファイル](/docs/ja/managed-settings#delivery-mechanisms)として、macOS と Linux のマシンにのみデプロイします。[サーバー管理設定](/docs/ja/server-managed-settings#current-limitations)は組織内のすべてのユーザーに適用されます
* **Windows ユーザーをサポートされている環境に移行する**：WSL2 またはコンテナ内で Claude Code を実行してもらいます

<h3 id="keep-developers-from-widening-the-policy">
  開発者がポリシーを広げるのを防ぐ
</h3>

管理設定で `enabled` や `failIfUnavailable` などのブール値キーを設定した場合、Claude Code は管理値を使用し、開発者がローカルで設定したものを無視します。`allowRead` などの配列キーの場合、Claude Code はセッションが読み込むスコープからエントリをマージするため、そのキーがロックの対象になっていない限り、開発者はポリシーを広げるエントリを追加できます。

管理設定で設定されていない限り、開発者のユーザー設定または `--settings` で次のキーをオンにできます。サンドボックスが[管理者必須](#repository-settings-under-an-admin-required-sandbox)でない限り、リポジトリの `.claude/settings.json` でもオンにできます。いずれもサンドボックスを弱めるため、使用させたくない場合は管理設定で `false` に設定してください。

* [`enableWeakerNestedSandbox`](/docs/ja/settings-reference#sandbox-enableweakernestedsandbox)
* [`enableWeakerNetworkIsolation`](/docs/ja/settings-reference#sandbox-enableweakernetworkisolation)
* [`network.allowAllUnixSockets`](/docs/ja/settings-reference#sandbox-network-allowallunixsockets)
* [`network.allowLocalBinding`](/docs/ja/settings-reference#sandbox-network-allowlocalbinding)
* [`allowAppleEvents`](/docs/ja/settings-reference#sandbox-allowappleevents)（リポジトリではオンにできません）

管理設定で `allowManagedReadPathsOnly` を `true` に設定して、管理設定からの `allowRead` エントリのみが尊重されるようにします。これにより、開発者が組織承認済みのパスを超えて読み取りアクセスを広げるのを防止します。

ネットワークドメインを同じ方法で管理値にロックするには、[`allowManagedDomainsOnly`](/docs/ja/settings-reference#sandbox-network-allowmanageddomainsonly) を設定します。このロックがオンの場合、[プロキシポート](#custom-proxy-configuration)を設定できるのは管理設定のみです。

管理設定が `sandbox.filesystem` を設定するか、`"mode": "deny"` を含む `sandbox.credentials.files` エントリをリストする場合、管理設定のみが [`filesystem.disabled`](#disable-filesystem-isolation) を設定できるため、開発者は管理者がデプロイしたファイルシステム制限をオフにすることはできません。[有効な](/docs/ja/settings-reference#invalid-credential-entries-in-managed-settings) `mask` エントリはキーをロックしません。[どの設定がそれを無効にできるか](#which-settings-can-disable-it)を参照してください。

<h4 id="repository-settings-under-an-admin-required-sandbox">
  管理者必須のサンドボックスにおけるリポジトリ設定
</h4>

次のいずれかの設定が有効な間、サンドボックスは管理者必須になります。

* [`allowUnsandboxedCommands`](/docs/ja/settings-reference#sandbox-allowunsandboxedcommands) が管理設定で `false` に設定されている場合、または管理設定で `true` に設定されていない限り `--settings` フラグで `false` に設定されている場合
* [`allowManagedDomainsOnly`](/docs/ja/settings-reference#sandbox-network-allowmanageddomainsonly) が管理設定で `true` に設定されている場合

これらの設定はサンドボックスをオンにしないため、`enabled` も設定してください。

サンドボックスが管理者必須である間、Claude Code はサンドボックスを緩める設定を、管理設定、`--settings` フラグ、および各開発者の `~/.claude/settings.json` からのみ取得します。リポジトリの `.claude/settings.json` および `.claude/settings.local.json` にある次の設定は無視されます。

| リポジトリの設定 | Claude Code が無視するもの |
| :- | :- |
| `excludedCommands`、`ignoreViolations`、`network.allowedDomains`、`network.allowUnixSockets`、`network.allowMachLookup`、`network.httpProxyPort`、`network.socksProxyPort` | すべてのエントリ |
| `filesystem.allowWrite`、`Edit(...)` 許可ルール、`permissions.additionalDirectories` | 各エントリがサンドボックス化されたコマンドに与える書き込みアクセス。Claude のファイルツールは引き続き `Edit(...)` ルールと追加ディレクトリに従います |
| `WebFetch(domain:...)` 許可ルール | 各ルールがサンドボックスの許可リストに追加するホスト。WebFetch ツールは引き続きそのルールに従います |
| `enableWeakerNestedSandbox`、`enableWeakerNetworkIsolation`、`network.allowAllUnixSockets`、`network.allowLocalBinding` | `true`。`false` は引き続き適用されます |
| `enabled`、`failIfUnavailable` | 開発者の `~/.claude/settings.json` が `true` を設定している場合の `false` |
| `filesystem.allowRead` | 管理設定、`--settings`、またはユーザー設定で読み取りが拒否されているパスまたはその配下のエントリ、あるいはそれに一致する可能性のある glob |

サンドボックスが管理者必須である間も、次の設定は引き続き適用されます。

* **リポジトリのファイル内**：deny エントリと `autoAllowBashIfSandboxed` の値。リポジトリによる変更を防ぐには、管理設定でこのキーを設定してください
* **開発者自身の設定内**：表にある設定は、`allowManagedDomainsOnly` などの管理専用ロックの対象でない限り、`~/.claude/settings.json` または `--settings` から引き続き適用されます。`excludedCommands` や `filesystem.allowWrite` など、そのほとんどには管理専用ロックがありません

[管理設定でサンドボックス化を実施する](#enforce-sandboxing-with-managed-settings)の設定により、サンドボックスは管理者必須になります。リポジトリからは指定できないため、承認済みのツールに必要な `excludedCommands`、`allowWrite`、およびソケットのエントリは管理設定に追加してください。

Claude Code v2.1.285 以降が必要です。v2.1.282 から v2.1.284 では、同じ設定によって Claude Code はリポジトリの `excludedCommands` エントリを無視していました。

<h4 id="locks-that-apply-without-an-admin-required-sandbox">
  管理者必須のサンドボックスがなくても適用されるロック
</h4>

一部の設定は、サンドボックスが管理者必須でない場合でも、1 つの制限を直接上書きするリポジトリのキーを Claude Code に無視させます。各設定がこの効果を持つのは、その行に記載されたファイルで設定した場合のみであり、リポジトリのその他のサンドボックス設定は引き続き適用されます。Claude Code v2.1.285 以降が必要です。

| 設定 | 設定する場所 | Claude Code がリポジトリの設定で無視するもの |
| :- | :- | :- |
| `network.deniedDomains` または `WebFetch(domain:...)` 拒否ルール | 管理設定、`--settings` | `httpProxyPort` と `socksProxyPort` |
| `network.strictAllowlist` | 管理設定、`--settings`、ユーザー設定 | プロキシポート、`allowedDomains`、および `WebFetch(domain:...)` 許可ルール |
| `filesystem.denyRead`、`Read(...)` 拒否ルール、または `credentials.files` エントリ | 管理設定、`--settings` | 管理設定、`--settings`、またはユーザー設定で読み取りが拒否されているパスまたはその配下にある `allowRead`、`allowWrite`、`Edit(...)` 許可、または `additionalDirectories` のエントリ、あるいはそれに一致する可能性のある glob |

これらのロックは、サンドボックス化されたコマンドがアクセスできる範囲を変更します。WebFetch ツールと Claude のファイルツールは、引き続きリポジトリのルールと追加ディレクトリに従います。

<h3 id="custom-proxy-configuration">
  カスタムプロキシ設定
</h3>

独自のツールでサンドボックストラフィックを検査、フィルタリング、またはログに記録するには、組み込みのサンドボックスプロキシを、同じマシン上で実行する独自のプロキシに置き換えます。

ネットワーク上の別の場所にある企業プロキシを通じてサンドボックストラフィックをルーティングするには、代わりに [ネットワーク分離](#network-isolation)の **企業プロキシ** の項目で説明されているように `HTTPS_PROXY` を設定します。そうすることで、Claude Code の許可リストが引き続き適用されます。

サンドボックス化されたコマンドをプロキシに向けるには、[サンドボックス設定](/docs/ja/settings-reference#sandbox-settings)でプロキシがリッスンする localhost のポートを設定します。

```json theme={null}
{
  "sandbox": {
    "network": {
      "httpProxyPort": 8080,
      "socksProxyPort": 8081
    }
  }
}
```

ポートを設定し、さらに `HTTPS_PROXY` または `HTTP_PROXY` も設定した場合、Claude Code はサンドボックス化されたコマンドが独自のプロキシに送信したものを、これらの変数で指定されたプロキシに転送しません。企業プロキシにアクセスするには、独自のプロキシがそこへ転送するように設定してください。

どのファイルでポートを設定できるかは、その他のサンドボックス設定によって異なります。最初に一致するケースが適用されます。

* **`allowManagedDomainsOnly` がオンの場合**：管理設定のみ
* **サンドボックスが[管理者必須](#repository-settings-under-an-admin-required-sandbox)である場合、または[より限定的なネットワークロック](#locks-that-apply-without-an-admin-required-sandbox)が適用される場合**：管理設定、`--settings`、およびユーザー設定
* **それ以外の場合**：任意の設定ファイル

Claude Code はそれ以外の場所で設定されたポートを無視します。v2.1.285 より前は、任意の設定ファイルでポートを設定できました。

<Warning>
  いずれかのポートが適用されると、そのプロキシに送信されるすべてのものをフィルタリングする責任は独自のプロキシが負います。`allowedDomains`、`deniedDomains`、`strictAllowlist`、承認プロンプト、[ローカルアドレスのチェック](#hostnames-that-resolve-to-local-addresses)など、Claude Code 自体のネットワーク制御はそのトラフィックには適用されなくなります。サンドボックス化されたコマンドはどちらのプロキシにも接続できるため、ポートを 1 つだけ設定した場合、もう一方のプロキシにおける Claude Code のドメインリストでは、コマンドが独自のプロキシを通じてアクセスする先を制限できません。
</Warning>

<h2 id="troubleshooting">
  トラブルシューティング
</h2>

一部のコマンドは、サンドボックス外では機能するにもかかわらず、サンドボックス内では失敗します。症状やエラーメッセージに一致する見出しを探してください。

組織のサンドボックスが[管理者必須](#repository-settings-under-an-admin-required-sandbox)の場合、Claude Code はプロジェクトの設定ファイル内にある、これらの修正で挙げる設定を無視します。そのため、すべてのプロジェクトで適用される `~/.claude/settings.json` に保存してください。それでも修正が効果を持たない場合は、組織の管理設定がそのキーを設定している可能性があります。

`excludedCommands` パターンを追加する修正では、そのパターンに一致するコマンドからサンドボックスが外れます。[除外されたコマンドでできること](#run-commands-outside-the-sandbox-with-excludedcommands)を参照してください。

<h3 id="commands-fail-with-a-host-not-allowed-error">
  コマンドがホスト許可なしエラーで失敗する
</h3>

多くの CLI ツールは特定のホストに到達する必要があります。プロンプトが表示されたらホストを承認するか、[`allowedDomains`](/docs/ja/settings-reference#sandbox-network-alloweddomains) に追加してください。組織が `allowManagedDomainsOnly` で許可リストをロックしている場合はプロンプトが表示されないため、管理者にホストの追加を依頼してください。

<h3 id="jest-hangs-or-fails">
  `jest` がハングまたは失敗する
</h3>

`watchman` はサンドボックスと互換性がありません。代わりに `jest --no-watchman` を実行してください。

<h3 id="go-based-clis-fail-tls-verification-on-macos">
  Go ベースの CLI が macOS で TLS 検証に失敗する
</h3>

`gh`、`gcloud`、`terraform` などのツールは [Seatbelt](#os-level-enforcement) の下で TLS 検証に失敗する可能性があります。これらのツールをサンドボックス外で実行するには、各ツールのパターン（`gh *` など）を [`excludedCommands`](#run-commands-outside-the-sandbox-with-excludedcommands) に追加してください。そのツールはユーザーの完全なアクセス権と保存された認証情報で実行されます。`httpProxyPort` を MITM プロキシとカスタム CA で使用している場合は、代わりに [`enableWeakerNetworkIsolation`](/docs/ja/settings-reference#sandbox-enableweakernetworkisolation) を `true` に設定してください。

<h3 id="open-osascript-or-browser-based-auth-flows-fail-with-error-600-on-macos">
  `open`、`osascript`、またはブラウザベースの認証フローが macOS でエラー `-600` で失敗する
</h3>

サンドボックスはデフォルトで Apple Events をブロックします。ユーザー、管理、または CLI 設定で [`allowAppleEvents`](/docs/ja/settings-reference#sandbox-allowappleevents) を `true` に設定して、それらを許可してください。Claude Code はプロジェクト設定ではこのキーを無視します。

`allowAppleEvents` を有効にするとコード実行の分離が削除されます。サンドボックス化されたコマンドはユーザープロンプトなしで他のアプリケーションをサンドボックス化されていない状態で起動でき、macOS オートメーション同意プロンプト（TCC）の対象となる実行中のアプリケーションに AppleScript コマンドを送信できるためです。または、`open *` などのパターンを [`excludedCommands`](#run-commands-outside-the-sandbox-with-excludedcommands) に追加してください。その場合、各 `open` 呼び出しは権限フローを経由します。また、`open` は Claude が書いたものを含め、任意のファイルやアプリを起動できます。

<h3 id="docker-commands-fail">
  `docker` コマンドが失敗する
</h3>

`docker` はサンドボックスと互換性がありません。必要な `docker` コマンドを、`docker compose *` などの `excludedCommands` パターンでサンドボックス外に出してください。除外された `docker` コマンドが到達できる範囲については、[`excludedCommands` でサンドボックス外でコマンドを実行する](#run-commands-outside-the-sandbox-with-excludedcommands)で説明しています。パターンを狭くするほど、サンドボックス外に出るコマンドは少なくなります。

<h3 id="pbcopy-xclip-or-wl-copy-doesn’t-update-the-clipboard">
  `pbcopy`、`xclip`、または `wl-copy` がクリップボードを更新しない
</h3>

`pbcopy`、`xclip`、`wl-copy` のクリップボードユーティリティはサンドボックス内からシステムクリップボードに到達できない場合があり、その場合はパイプされたテキストが到達しません。

Claude の出力をクリップボードに配置するには、Claude に応答で出力するよう依頼してから、[`/copy`](/docs/ja/commands) を実行してください。`/copy` はサンドボックス化されたコマンドではなく Claude Code プロセスからクリップボードに書き込みます。

Claude がテキストをこれらのツールの 1 つにパイプする場合、ツールを [`excludedCommands`](/docs/ja/settings-reference#sandbox-excludedcommands) に追加しても、それだけではその呼び出しはサンドボックス外に出ません。

<h3 id="a-git-command-fails-with-unable-to-unlink-old">
  git コマンドが `unable to unlink old` で失敗する
</h3>

`git merge`、`git checkout` などのコマンドは、サンドボックスが書き込みを拒否するファイルを置き換える必要がある場合に `unable to unlink old` で失敗します。Linux と WSL2 ではエラーは `Read-only file system` で終わります。そのファイルは次のいずれかの場所にある可能性があります：

* `.claude/skills` などの[保護されたパス](#protected-paths)の下
* `denyWrite` エントリの 1 つの下
* サンドボックスがコマンドに書き込みを許可するディレクトリの外

失敗後、Claude は[コマンドをサンドボックス外で再実行することを提案](#the-unsandboxed-retry-escape-hatch)する場合があります。その再試行を承認するか、別のターミナルで git コマンドを自分で実行してください。`allowUnsandboxedCommands` を `false` に設定している場合、Claude は再試行を提案できないため、コマンドを自分で実行してください。

<h3 id="bubblewrap-fails-to-start-inside-a-container">
  Bubblewrap がコンテナ内で起動に失敗する
</h3>

非特権コンテナでは、[bubblewrap](#os-level-enforcement) は新しい `/proc` ファイルシステムをマウントできないため、サンドボックス化されたコマンドは `bwrap` エラー（`Can't mount proc on /newroot/proc: Operation not permitted` など）で失敗します。[`enableWeakerNestedSandbox`](/docs/ja/settings-reference#sandbox-enableweakernestedsandbox) を `true` に設定して、サンドボックスが代わりにコンテナの既存の `/proc` をバインドマウントするようにしてください。この設定は、外部コンテナが既に必要な分離境界を提供する場合にのみ使用してください。新しい `/proc` マウントであれば隠されるプロセス情報を、この設定はサンドボックス化されたコマンドに公開するためです。

<h3 id="0-byte-read-only-files-appear-at-claude-settings-paths-and-yes-and-don’t-ask-again-doesn’t-save">
  0 バイトの読み取り専用ファイルが `.claude` 設定パスに表示され、「はい、今後は聞かない」が保存されない
</h3>

Linux と WSL2 では、サンドボックスはサンドボックス化されたコマンドが実行されている間に、まだ存在しないファイルに対する書き込み拒否を保持するために、そこに 0 バイトの読み取り専用プレースホルダーを作成します。サンドボックスはその後プレースホルダーを削除します。SIGKILL などによってセッションがそのクリーンアップが実行される前に強制終了された場合、プレースホルダーは残ります。後のセッションは毎回起動時にそれらを読み取り専用で再度バインドするため、プレースホルダーが残っている箇所では、権限の選択を保存するなどの設定書き込みが失敗します。

ターミナルで `claude doctor` を実行して、残されたプレースホルダーファイルをリストアップしてください。[`Stale sandbox mask files left by a killed session`](/docs/ja/errors#stale-sandbox-mask-files-left-by-a-killed-session) 警告はその一部の名前を表示し、残りをカウントします。そのプロジェクトで他の Claude Code セッションが実行されていない間に、`rm` で各ファイルを削除してください。v2.1.257 より前では、Claude Code は同じプレースホルダーを残していましたが、警告していませんでした。

<h3 id="git-over-ssh-fails-with-the-sandbox-on">
  サンドボックスがオンの状態で SSH 経由の `git` が失敗する
</h3>

macOS では、SSH リモートに対する `git fetch`、`git pull`、`git push` は、ホストが許可されていてもサンドボックス内で失敗します。Linux と WSL2 では、ホストが許可されれば動作します。Claude Code は git の SSH 接続を[サンドボックスプロキシ](#network-isolation)経由でトンネリングしますが、macOS のトンネルはそのプロキシに対して認証できません。

Linux と WSL2 でそれでも接続が失敗する場合は、以下を確認してください：

* **ホストがポート 22 で許可されている**：`"git.example.com"` のようにポートを指定しない `allowedDomains` エントリで対象になります
* **企業プロキシがポート 22 を許可している**：ネットワークでアップストリームプロキシが必要な場合、トンネルもそれを経由します
* **鍵がファイルとして読み取り可能である**：サンドボックスは `ssh-agent` ソケットをブロックする場合があり、`~/.ssh` に対する `denyRead` または `credentials` エントリは鍵ファイルを隠します

macOS では、リモートを HTTPS に切り替えてください。これには個人用アクセストークンなどの HTTPS 認証情報が必要です：

```bash theme={null}
git remote set-url origin https://git.example.com/example-org/example-repo.git
```

SSH リモートを維持する必要がある場合は、[`excludedCommands`](#run-commands-outside-the-sandbox-with-excludedcommands) で git のネットワークコマンドをサンドボックス外に出してください：

```json theme={null}
{
  "sandbox": {
    "excludedCommands": ["git fetch *", "git pull *", "git push *"]
  }
}
```

これらのエントリは `git push origin main` に一致します。`cd` を追加する呼び出し、`git -C` を使用する呼び出し、またはコマンド置換を含む呼び出しは、サンドボックス内のままです。除外された git コマンドは、`allowedDomains` にあるホストだけでなく、任意のホストに到達できます。

SSH 経由の単純な `ssh`、`scp`、`rsync` は、[データベースクライアントの項目](#a-database-client-or-other-non-http-tool-fails-to-reach-an-allowed-host)で説明している理由で失敗します。

<h3 id="a-database-client-or-other-non-http-tool-fails-to-reach-an-allowed-host">
  データベースクライアントやその他の非 HTTP ツールが許可されたホストに到達できない
</h3>

プロキシの環境変数を無視するツールは、`allowedDomains` にあるホストであっても、サンドボックス内から接続できません。サンドボックス化されたコマンドには[ネットワークへの直接の経路がない](#network-isolation)ため、独自に接続を開くツールは失敗します。ほとんどのデータベースドライバー、単純な `ssh`、UDP を使用するツールはこのように動作します。

失敗はネットワークエラーまたは名前解決エラーのように見えます：

* **macOS**：`Operation not permitted`、または `Could not resolve host` などの名前解決エラー
* **Linux と WSL2**：`Network is unreachable`、または `Temporary failure in name resolution` などの名前解決エラー

プロキシを使用するツールは、ホストが許可されていない場合に異なる形で失敗します。ネットワークのプロンプトが表示されるか、ツールがプロキシから `403` レスポンスを受け取ります。

ツールが接続できるようにするには、それを必要とするコマンドを [`excludedCommands`](#run-commands-outside-the-sandbox-with-excludedcommands) でサンドボックス外で実行してください。この例では 1 つのスクリプトを除外し、[ask ルール](/docs/ja/permissions)を追加して、実行ごとに承認するようにしています：

```json theme={null}
{
  "sandbox": {
    "excludedCommands": ["python scripts/load_orders.py *"]
  },
  "permissions": {
    "ask": ["Bash(python scripts/load_orders.py *)"]
  }
}
```

スクリプトはユーザーの完全なアクセス権で実行され、Claude は作業ディレクトリ内にあるスクリプトを編集できるため、プロンプトが表示されたらスクリプトを確認してください。

<h3 id="a-command-fails-to-reach-a-server-on-localhost">
  コマンドが localhost 上のサーバーに到達できない
</h3>

デフォルトでは、サンドボックス化されたコマンドは、開発サーバーやコンテナ内のデータベースなど、マシン上でサンドボックス外で実行されているサーバーに直接接続できません。変更できる内容はプラットフォームによって異なります：

* **macOS**：[`network.allowLocalBinding`](/docs/ja/settings-reference#sandbox-network-allowlocalbinding) を `true` に設定します。これにより、サンドボックス化されたコマンドはネットワークポートでリッスンし、localhost の任意のポートに接続できるようになります。これには、そこでリッスンしている他のすべてのサービスが含まれます。その結果、認証を必要としない localhost サービス（デバッガーなど）がサンドボックス外でコマンドの代わりに動作できるようになり、非ループバックアドレスでリッスンするコマンドは他のマシンからの接続を受け入れます
* **Linux と WSL2**：サンドボックス化されたコマンドの `localhost` はそのコマンド専用です。コマンドはポートでリッスンでき、自身が起動したサーバーに到達できます。`localhost` または `127.0.0.1` への直接接続はホスト上のサーバーには到達せず、`allowLocalBinding` は効果がありません。ホストのサーバーを必要とするコマンドは、[`excludedCommands`](#run-commands-outside-the-sandbox-with-excludedcommands) でサンドボックス外で実行してください。そこではファイルシステムやネットワークの制限はありません。サンドボックスプロキシを経由する接続については、[ローカルアドレスに解決されるホスト名](#hostnames-that-resolve-to-local-addresses)を参照してください

この例では macOS でこの設定をオンにします：

```json theme={null}
{
  "sandbox": {
    "network": {
      "allowLocalBinding": true
    }
  }
}
```

`localhost` に対する `allowedDomains` エントリはプロキシを経由する接続に適用されるため、直接接続には影響しません。Claude Code はサンドボックス化されたコマンドに `NO_PROXY` を設定し、プロキシ経由ではなく `localhost` に直接接続するようにしています。また、このエントリは、プロキシを使用するコマンドに対して、マシンの localhost のすべてのポートを公開します。`127.0.0.1` を指す開発用ホスト名については、[許可されたホスト名が `resolved to a loopback address` で拒否される](#an-allowed-hostname-is-refused-with-resolved-to-a-loopback-address)を参照してください。

<h3 id="an-allowed-hostname-is-refused-with-resolved-to-a-loopback-address">
  許可されたホスト名が `resolved to a loopback address` で拒否される
</h3>

サンドボックスプロキシは、[ローカルアドレスに解決される](#hostnames-that-resolve-to-local-addresses)許可されたホスト名を拒否します。これは `127.0.0.1` を指す `myapp.test` などの開発用の名前に影響します。コマンドは `403` レスポンスを受け取り、その本文には `Connection to myapp.test blocked: resolved to a loopback address` のようにアドレスの種類が示されます。

名前の解決先の IP アドレスをホスト名と並べて `allowedDomains` に追加し、それぞれにサーバーがリッスンするポートを指定してください：

```json theme={null}
{
  "sandbox": {
    "network": {
      "allowedDomains": ["myapp.test:3000", "127.0.0.1:3000"]
    }
  }
}
```

ポートを指定しない IP アドレスのエントリでは、サンドボックス化されたコマンドがそのアドレスでリッスンしているすべてのサービスに到達できるようになります。

v2.1.284 より前では、プロキシは許可されたホスト名がどのアドレスに解決されても接続していました。

<h3 id="/sandbox-fails-with-sandbox-settings-are-overridden-by-a-higher-priority-configuration">
  `/sandbox` が `Sandbox settings are overridden by a higher-priority configuration` で失敗する
</h3>

上位の[設定レベル](/docs/ja/settings#settings-precedence)が `sandbox.enabled`、`sandbox.autoAllowBashIfSandboxed`、または `sandbox.allowUnsandboxedCommands` を設定している場合、`/sandbox` はパネルを開く代わりに `Error: Sandbox settings are overridden by a higher-priority configuration and cannot be changed locally.` を出力します。パネルは選択内容を `.claude/settings.local.json` に保存しますが、そこに保存された値はそれらのレベルを上書きできません。

管理設定と `--settings` はローカル設定より優先されます。このセッションでどれが読み込まれたかを確認するには、`/status` を実行して `Setting sources` 行を確認してください：

* **`Command line arguments`**：[`--settings`](/docs/ja/settings#change-a-setting-for-one-session) を指定して Claude Code を起動した場合は、渡したファイルまたは JSON がこれらのキーのいずれかを設定しているか確認してください。設定している場合は、そこで値を変更するか、これらのキーを含めずに Claude Code を再起動してください。
* **`Enterprise managed settings`**：組織の管理設定が読み込まれています。それらがこれらのキーのいずれかを設定している場合、そのキーは `/sandbox` からも、ユーザーが管理するどの設定ファイルからも変更できないため、管理者に問い合わせてください。

<h2 id="limitations">
  制限事項
</h2>

サンドボックス化はリスクを軽減しますが、完全な分離境界ではありません。ハードセキュリティ制御として依存する前に、以下の制限事項を確認してください。

<h3 id="security-limitations">
  セキュリティ上の制限
</h3>

* **ネットワークフィルタリング**：サンドボックスは、プロセスが接続できるドメインを制限します。デフォルトでは、組み込みプロキシは発信トラフィックの TLS を終端または検査しないため、暗号化された接続の内容は検査されません。実験的な [`network.tlsTerminate`](/docs/ja/settings-reference#sandbox-network-tlsterminate) 設定は、[`mask` 認証情報置換](#mask-credentials)のためにプロキシで TLS を終了しますが、コンテンツフィルタリングは追加しません。ポリシーで許可されるのは信頼できるドメインのみであることを確認する責任があります。

<Warning>
  `github.com` などの広いドメインを許可すると、データ流出のパスが作成される可能性があります。プロキシは TLS を検査せずにクライアント提供のホスト名から許可決定を行うため、サンドボックス内で実行されるコードは [ドメインフロンティング](https://en.wikipedia.org/wiki/Domain_fronting)または同様の技術を使用して許可リスト外のホストに到達する可能性があります。脅威モデルがより強力な保証を必要とする場合は、TLS を終了してトラフィックを検査し、CA 証明書をサンドボックス内にインストールする [カスタムプロキシ](#custom-proxy-configuration)を設定してください。より強力な TLS 対応ネットワーク分離は開発の活発な領域です。
</Warning>

* **Unix ソケットを通じた権限昇格**：`allowUnixSockets` 設定は、サンドボックスバイパスにつながる可能性のあるシステムサービスへのアクセスを不注意に付与する可能性があります。たとえば、`/var/run/docker.sock` へのアクセスを許可すると、Docker ソケットを通じてホストシステムへのアクセスが効果的に付与されます。サンドボックスを通じて許可する Unix ソケットを慎重に検討してください。
* **ファイルシステム権限昇格**：過度に広いファイルシステム書き込み権限は権限昇格攻撃を有効にする可能性があります。`$PATH` の実行可能ファイルを含むディレクトリ、システム設定ディレクトリ、またはユーザーシェル設定ファイル（`.bashrc` または `.zshrc`）への書き込みを許可すると、他のユーザーまたはシステムプロセスがこれらのファイルにアクセスするときに異なるセキュリティコンテキストでコード実行につながる可能性があります。
* **Linux サンドボックス強度**：Linux 実装は強力なファイルシステムとネットワーク分離を提供しますが、特権付き名前空間のない Docker 環境内で動作できるようにする `enableWeakerNestedSandbox` モードが含まれています。このオプションはセキュリティを大幅に弱め、追加の分離が別の方法で実施される場合にのみ使用する必要があります。
* **macOS での Apple Events**：macOS サンドボックスはデフォルトで Apple Events をブロックします。`allowAppleEvents` 設定はこの制限を解除して、`open` や `osascript` などのツールが動作するようにしますが、コード実行分離を削除します。サンドボックス化されたコマンドは、ユーザープロンプトなしで他のアプリケーションをサンドボックス化されていない状態で起動でき、実行中のアプリケーションに AppleScript コマンドを送信できます。これはアプリごとの macOS オートメーション同意プロンプト（TCC）の対象です。これはユーザー、管理、または CLI 設定からのみ有効です。プロジェクト設定では有効にできません。

<h3 id="scope">
  スコープ
</h3>

サンドボックスはシェルコマンドとその子プロセスを分離します。サンドボックスの対象外となるツールとヘルパープロセスは、[サンドボックス外で実行されるもの](#what-runs-outside-the-sandbox)に記載されています。コンピュータ使用とサブエージェントとサンドボックスの関係は次のとおりです。

* **コンピュータ使用**：Claude がアプリを開いてスクリーンを制御する場合、分離された環境ではなく実際のデスクトップで実行されます。アプリごとの権限プロンプトが各アプリケーションをゲートします。[CLI でのコンピュータ使用](/docs/ja/computer-use)または [Desktop でのコンピュータ使用](/docs/ja/desktop#let-claude-use-your-computer)を参照してください。
* **サブエージェント**：[subagents](/docs/ja/sub-agents)は親セッションと同じプロセスで実行され、同じサンドボックス設定を使用します。親セッションでサンドボックス化が有効な場合、サブエージェント内の Bash コマンドはサンドボックス化されます。
* **バックグラウンドセッション**：[バックグラウンドセッション](/docs/ja/agent-view)は独自のプロセスで実行され、[その設定](/docs/ja/agent-view#settings-and-provider)でサンドボックス化が有効になっている場合、その Bash コマンドはサンドボックス化されます。
* **プロセス全体を囲む境界**：[サンドボックス外で実行されるもの](#what-runs-outside-the-sandbox)に記載されたプロセスも境界の内側に置くには、承認したホストに限定したネットワーク許可リストを指定して [sandbox runtime](/docs/ja/sandbox-environments#sandbox-runtime) 内で Claude Code（ローカルモード）を実行するか、ファイアウォールスクリプトを備えた [dev container](/docs/ja/devcontainer) 内で実行します。バックグラウンドサービスとそれがホストするセッションについては、[企業ランチャーの背後で Claude Code を実行する](/docs/ja/corporate-launcher)を参照してください。
* **Mod**：[mod](/docs/ja/plugins/mods/overview) は Claude Code 内で独自のコードを実行するプラグインであり、mod が起動するプロセスはサンドボックス外で実行されます。[mod がアクセスできる範囲](/docs/ja/plugins/mods/overview#what-a-mod-can-reach)を参照してください。

<Warning>
  効果的なサンドボックス化にはファイルシステムとネットワークの両方の分離が必要です。ネットワーク分離がない場合、侵害されたエージェントは SSH キーなどの機密ファイルを流出させる可能性があります。ファイルシステム分離がない場合、それが制限の緩いポリシーによるものであれ、[ファイルシステムレイヤーを無効化](#disable-filesystem-isolation)したことによるものであれ、侵害されたエージェントはシステムリソースにバックドアを仕掛けてネットワークアクセスを取得する可能性があります。デフォルトを広げるときは、`allowWrite` パス、広い `allowedDomains` エントリ、または `excludedCommands` 例外が反対側の制限を元に戻さないことを確認してください。
</Warning>

<h2 id="see-also">
  関連項目
</h2>

* [Sandbox environments](/docs/ja/sandbox-environments)：組み込みサンドボックスと dev コンテナ、コンテナ、VM を比較する
* [Security](/docs/ja/security)：セキュリティ機能とベストプラクティス
* [Permissions](/docs/ja/permissions)：許可設定とアクセス制御
* [All settings](/docs/ja/settings-reference)：すべての設定キー
* [CLI reference](/docs/ja/cli-reference)：コマンドラインオプション
