> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# トラブルシューティング

> Claude Code のインストールと使用に関する一般的な問題の解決策を見つけます。

## インストールの一般的な問題

### Windows インストールの問題：WSL でのエラー

WSL では以下の問題が発生する可能性があります。

**OS/プラットフォーム検出の問題**：インストール中にエラーが発生した場合、WSL が Windows の `npm` を使用している可能性があります。以下を試してください。

* インストール前に `npm config set os linux` を実行してください
* `npm install -g @anthropic-ai/claude-code --force --no-os-check` でインストールしてください（`sudo` は使用しないでください）

**Node が見つからないエラー**：`claude` を実行するときに `exec: node: not found` が表示される場合、WSL 環境が Windows インストール版の Node.js を使用している可能性があります。`which npm` と `which node` で確認できます。これらは `/usr/` で始まる Linux パスではなく `/mnt/c/` を指しているはずです。これを修正するには、Linux ディストリビューションのパッケージマネージャーまたは [`nvm`](https://github.com/nvm-sh/nvm) 経由で Node をインストールしてみてください。

**nvm バージョンの競合**：WSL と Windows の両方に nvm がインストールされている場合、WSL で Node バージョンを切り替えるときにバージョンの競合が発生する可能性があります。これは WSL がデフォルトで Windows PATH をインポートするため、Windows nvm/npm が WSL インストール版よりも優先されるために発生します。

この問題は以下の方法で特定できます。

* `which npm` と `which node` を実行します。これらが Windows パス（`/mnt/c/` で始まる）を指している場合、Windows バージョンが使用されています
* WSL で nvm を使用して Node バージョンを切り替えた後、機能が破損しています

この問題を解決するには、Linux PATH を修正して、Linux node/npm バージョンが優先されるようにしてください。

**主要な解決策：nvm がシェルで正しく読み込まれていることを確認する**

最も一般的な原因は、nvm が非対話型シェルで読み込まれていないことです。シェル設定ファイル（`~/.bashrc`、`~/.zshrc` など）に以下を追加してください。

```bash  theme={null}
# Load nvm if it exists
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
```

または現在のセッションで直接実行してください。

```bash  theme={null}
source ~/.nvm/nvm.sh
```

**代替案：PATH の順序を調整する**

nvm が正しく読み込まれているが Windows パスがまだ優先されている場合、シェル設定で Linux パスを PATH の先頭に明示的に追加できます。

```bash  theme={null}
export PATH="$HOME/.nvm/versions/node/$(node -v)/bin:$PATH"
```

<Warning>
  Windows PATH インポートを無効にする（`appendWindowsPath = false`）ことは避けてください。これにより WSL から Windows 実行可能ファイルを呼び出す機能が破損します。同様に、Windows 開発に使用している場合は Windows から Node.js をアンインストールすることも避けてください。
</Warning>

### WSL2 サンドボックスのセットアップ

[Sandboxing](/ja/sandboxing) は WSL2 でサポートされていますが、追加パッケージのインストールが必要です。`/sandbox` を実行するときに「Sandbox requires socat and bubblewrap」のようなエラーが表示される場合は、依存関係をインストールしてください。

<Tabs>
  <Tab title="Ubuntu/Debian">
    ```bash  theme={null}
    sudo apt-get install bubblewrap socat
    ```
  </Tab>

  <Tab title="Fedora">
    ```bash  theme={null}
    sudo dnf install bubblewrap socat
    ```
  </Tab>
</Tabs>

WSL1 はサンドボックスをサポートしていません。「Sandboxing requires WSL2」が表示される場合は、WSL2 にアップグレードするか、サンドボックスなしで Claude Code を実行する必要があります。

### Linux と Mac のインストールの問題：権限またはコマンドが見つからないエラー

npm で Claude Code をインストールするときに、`PATH` の問題により `claude` へのアクセスが妨げられる可能性があります。
npm グローバルプレフィックスがユーザー書き込み可能でない場合（例えば `/usr` または `/usr/local`）、権限エラーが発生する可能性もあります。

#### 推奨される解決策：Claude Code のネイティブインストール

Claude Code には npm または Node.js に依存しないネイティブインストールがあります。

ネイティブインストーラーを実行するには、以下のコマンドを使用してください。

**macOS、Linux、WSL：**

```bash  theme={null}
# Install stable version (default)
curl -fsSL https://claude.ai/install.sh | bash

# Install latest version
curl -fsSL https://claude.ai/install.sh | bash -s latest

# Install specific version number
curl -fsSL https://claude.ai/install.sh | bash -s 1.0.58
```

**Windows PowerShell：**

```powershell  theme={null}
# Install stable version (default)
irm https://claude.ai/install.ps1 | iex

# Install latest version
& ([scriptblock]::Create((irm https://claude.ai/install.ps1))) latest

# Install specific version number
& ([scriptblock]::Create((irm https://claude.ai/install.ps1))) 1.0.58

```

このコマンドは、オペレーティングシステムとアーキテクチャに適切な Claude Code ビルドをインストールし、`~/.local/bin/claude`（Windows では `%USERPROFILE%\.local\bin\claude.exe`）のインストールへのシンボリックリンクを追加します。

<Tip>
  インストールディレクトリがシステム PATH に含まれていることを確認してください。
</Tip>

### Windows：「Claude Code on Windows requires git-bash」

ネイティブ Windows 上の Claude Code には、Git Bash を含む [Git for Windows](https://git-scm.com/downloads/win) が必要です。Git がインストールされているが検出されない場合：

1. Claude を実行する前に PowerShell でパスを明示的に設定してください。
   ```powershell  theme={null}
   $env:CLAUDE_CODE_GIT_BASH_PATH="C:\Program Files\Git\bin\bash.exe"
   ```

2. または、システムプロパティ → 環境変数を通じてシステム環境変数に永続的に追加してください。

Git が標準以外の場所にインストールされている場合は、パスを適切に調整してください。

### Windows：「installMethod is native, but claude command not found」

インストール後にこのエラーが表示される場合、`claude` コマンドが PATH に含まれていません。手動で追加してください。

<Steps>
  <Step title="環境変数を開く">
    `Win + R` を押して、`sysdm.cpl` と入力し、Enter キーを押します。**詳細設定** → **環境変数** をクリックします。
  </Step>

  <Step title="ユーザー PATH を編集する">
    「ユーザー変数」で **Path** を選択し、**編集** をクリックします。**新規** をクリックして以下を追加します。

    ```
    %USERPROFILE%\.local\bin
    ```
  </Step>

  <Step title="ターミナルを再起動する">
    PowerShell または CMD を閉じて再度開き、変更を有効にします。
  </Step>
</Steps>

インストールを確認してください。

```bash  theme={null}
claude doctor # Check installation health
```

## 権限と認証

### 繰り返される権限プロンプト

同じコマンドを繰り返し承認する必要がある場合は、`/permissions` コマンドを使用して特定のツールを承認なしで実行できるようにすることができます。[権限ドキュメント](/ja/permissions#manage-permissions) を参照してください。

### 認証の問題

認証に問題が発生している場合：

1. `/logout` を実行して完全にサインアウトしてください
2. Claude Code を閉じてください
3. `claude` で再起動し、認証プロセスを再度完了してください

ログイン中にブラウザが自動的に開かない場合は、`c` を押して OAuth URL をクリップボードにコピーし、手動でブラウザに貼り付けてください。

問題が解決しない場合は、以下を試してください。

```bash  theme={null}
rm -rf ~/.config/claude-code/auth.json
claude
```

これにより、保存された認証情報が削除され、クリーンなログインが強制されます。

## 設定ファイルの場所

Claude Code は複数の場所に設定を保存します。

| ファイル                          | 目的                                                                                 |
| :---------------------------- | :--------------------------------------------------------------------------------- |
| `~/.claude/settings.json`     | ユーザー設定（権限、hooks、モデルオーバーライド）                                                        |
| `.claude/settings.json`       | プロジェクト設定（ソース管理にチェックイン）                                                             |
| `.claude/settings.local.json` | ローカルプロジェクト設定（コミットされない）                                                             |
| `~/.claude.json`              | グローバル状態（テーマ、OAuth、MCP サーバー）                                                        |
| `.mcp.json`                   | プロジェクト MCP サーバー（ソース管理にチェックイン）                                                      |
| `managed-mcp.json`            | [Managed MCP servers](/ja/mcp#managed-mcp-configuration)                           |
| Managed settings              | [Managed settings](/ja/settings#settings-files)（サーバー管理、MDM/OS レベルのポリシー、またはファイルベース） |

Windows では、`~` はユーザーホームディレクトリ（例：`C:\Users\YourName`）を指します。

これらのファイルの設定の詳細については、[Settings](/ja/settings) と [MCP](/ja/mcp) を参照してください。

### 設定のリセット

Claude Code をデフォルト設定にリセットするには、設定ファイルを削除できます。

```bash  theme={null}
# Reset all user settings and state
rm ~/.claude.json
rm -rf ~/.claude/

# Reset project-specific settings
rm -rf .claude/
rm .mcp.json
```

<Warning>
  これにより、すべての設定、MCP サーバー設定、セッション履歴が削除されます。
</Warning>

## パフォーマンスと安定性

### CPU またはメモリ使用率が高い

Claude Code はほとんどの開発環境で動作するように設計されていますが、大規模なコードベースを処理するときに大量のリソースを消費する可能性があります。パフォーマンスの問題が発生している場合：

1. `/compact` を定期的に使用してコンテキストサイズを削減してください
2. 主要なタスク間で Claude Code を閉じて再起動してください
3. 大規模なビルドディレクトリを `.gitignore` ファイルに追加することを検討してください

### コマンドがハングまたはフリーズする

Claude Code が応答しないように見える場合：

1. Ctrl+C を押して現在の操作をキャンセルしてみてください
2. 応答しない場合は、ターミナルを閉じて再起動する必要があります

### 検索と発見の問題

Search ツール、`@file` メンション、カスタムエージェント、カスタムスキルが機能していない場合は、システム `ripgrep` をインストールしてください。

```bash  theme={null}
# macOS (Homebrew)  
brew install ripgrep

# Windows (winget)
winget install BurntSushi.ripgrep.MSVC

# Ubuntu/Debian
sudo apt install ripgrep

# Alpine Linux
apk add ripgrep

# Arch Linux
pacman -S ripgrep
```

次に、[environment](/ja/settings#environment-variables) で `USE_BUILTIN_RIPGREP=0` を設定してください。

### WSL での遅い、または不完全な検索結果

[WSL でファイルシステム間で作業する](https://learn.microsoft.com/en-us/windows/wsl/filesystems) ときのディスク読み取りパフォーマンスペナルティにより、WSL で Claude Code を使用するときに予想より少ないマッチ（ただし検索機能の完全な欠落ではない）が発生する可能性があります。

<Note>
  この場合、`/doctor` は Search を OK として表示します。
</Note>

**解決策：**

1. **より具体的な検索を送信する**：検索するファイル数を減らすために、ディレクトリまたはファイルタイプを指定します。'auth-service パッケージで JWT 検証ロジックを検索'または'JS ファイルで md5 ハッシュの使用を検索'。

2. **プロジェクトを Linux ファイルシステムに移動する**：可能であれば、プロジェクトが Windows ファイルシステム（`/mnt/c/`）ではなく Linux ファイルシステム（`/home/`）に配置されていることを確認してください。

3. **ネイティブ Windows を使用する**：ファイルシステムパフォーマンスを向上させるために、WSL ではなくネイティブ Windows で Claude Code を実行することを検討してください。

## IDE 統合の問題

### WSL2 で JetBrains IDE が検出されない

WSL2 で Claude Code を使用していて JetBrains IDE を使用している場合、'No available IDEs detected'エラーが表示される場合、これは WSL2 のネットワーク設定または Windows ファイアウォールが接続をブロックしている可能性があります。

#### WSL2 ネットワークモード

WSL2 はデフォルトで NAT ネットワークを使用しており、IDE 検出を妨げる可能性があります。2 つのオプションがあります。

**オプション 1：Windows ファイアウォールを設定する**（推奨）

1. WSL2 IP アドレスを見つけます。
   ```bash  theme={null}
   wsl hostname -I
   # Example output: 172.21.123.456
   ```

2. PowerShell を管理者として開き、ファイアウォールルールを作成します。
   ```powershell  theme={null}
   New-NetFirewallRule -DisplayName "Allow WSL2 Internal Traffic" -Direction Inbound -Protocol TCP -Action Allow -RemoteAddress 172.21.0.0/16 -LocalAddress 172.21.0.0/16
   ```
   （ステップ 1 の WSL2 サブネットに基づいて IP 範囲を調整してください）

3. IDE と Claude Code の両方を再起動します

**オプション 2：ミラーリングネットワークに切り替える**

Windows ユーザーディレクトリの `.wslconfig` に追加します。

```ini  theme={null}
[wsl2]
networkingMode=mirrored
```

次に、PowerShell から `wsl --shutdown` で WSL を再起動します。

<Note>
  これらのネットワーク問題は WSL2 にのみ影響します。WSL1 はホストのネットワークを直接使用し、これらの設定は必要ありません。
</Note>

JetBrains 設定のその他のヒントについては、[JetBrains IDE ガイド](/ja/jetbrains#plugin-settings) を参照してください。

### Windows IDE 統合の問題を報告する（ネイティブと WSL の両方）

Windows で IDE 統合の問題が発生している場合は、以下の情報を含む [issue を作成](https://github.com/anthropics/claude-code/issues) してください。

* 環境タイプ：ネイティブ Windows（Git Bash）または WSL1/WSL2
* WSL ネットワークモード（該当する場合）：NAT またはミラーリング
* IDE 名とバージョン
* Claude Code 拡張機能/プラグインバージョン
* シェルタイプ：Bash、Zsh、PowerShell など

### JetBrains（IntelliJ、PyCharm など）ターミナルで Escape キーが機能しない

Claude Code を JetBrains ターミナルで使用していて、`Esc` キーがエージェントを中断しない場合、これは JetBrains のデフォルトショートカットとのキーバインディングの競合が原因である可能性があります。

この問題を修正するには：

1. 設定 → ツール → ターミナルに移動します
2. 以下のいずれかを実行します。
   * 「Escape でエディターにフォーカスを移動」をオフにするか、
   * 「ターミナルキーバインディングを設定」をクリックして「エディターにフォーカスを切り替え」ショートカットを削除します
3. 変更を適用します

これにより、`Esc` キーが Claude Code 操作を適切に中断できるようになります。

## Markdown フォーマットの問題

Claude Code は、コードフェンスに言語タグが欠落している Markdown ファイルを生成することがあります。これは GitHub、エディター、ドキュメントツールでの構文強調表示と読みやすさに影響を与える可能性があります。

### コードブロックの言語タグが欠落している

生成された Markdown でこのようなコードブロックに気付いた場合：

````markdown  theme={null}
```
function example() {
  return "hello";
}
```
````

適切にタグ付けされたブロックの代わりに：

````markdown  theme={null}
```javascript
function example() {
  return "hello";
}
```
````

**解決策：**

1. **Claude に言語タグを追加するよう依頼する**：「この Markdown ファイルのすべてのコードブロックに適切な言語タグを追加してください」とリクエストしてください。

2. **後処理 hooks を使用する**：言語タグが欠落しているコードブロックを検出して追加するための自動フォーマット hooks を設定します。[Auto-format code after edits](/ja/hooks-guide#auto-format-code-after-edits) で PostToolUse フォーマット hook の例を参照してください。

3. **手動確認**：Markdown ファイルを生成した後、適切なコードブロックフォーマットを確認し、必要に応じて修正をリクエストしてください。

### 一貫性のないスペースとフォーマット

生成された Markdown に過度な空行または一貫性のないスペースがある場合：

**解決策：**

1. **フォーマット修正をリクエストする**：Claude に「この Markdown ファイルのスペースとフォーマットの問題を修正してください」とリクエストしてください。

2. **フォーマットツールを使用する**：`prettier` またはカスタムフォーマットスクリプトなどの Markdown フォーマッターを実行する hooks を設定します。

3. **フォーマット設定を指定する**：プロンプトまたはプロジェクト [memory](/ja/memory) ファイルにフォーマット要件を含めます。

### Markdown 生成のベストプラクティス

フォーマットの問題を最小化するには：

* **リクエストで明示的にする**：「言語タグ付きコードブロックを含む適切にフォーマットされた Markdown」をリクエストしてください
* **プロジェクト規約を使用する**：[`CLAUDE.md`](/ja/memory) で優先される Markdown スタイルを文書化してください
* **検証 hooks を設定する**：後処理 hooks を使用して、一般的なフォーマットの問題を自動的に確認および修正してください

## さらにサポートを受ける

ここで説明されていない問題が発生している場合：

1. Claude Code 内で `/bug` コマンドを使用して、Anthropic に直接問題を報告してください
2. [GitHub リポジトリ](https://github.com/anthropics/claude-code) で既知の問題を確認してください
3. `/doctor` を実行して問題を診断してください。以下をチェックします。
   * インストールタイプ、バージョン、検索機能
   * 自動更新ステータスと利用可能なバージョン
   * 無効な設定ファイル（不正な形式の JSON、不正な型）
   * MCP サーバー設定エラー
   * キーバインディング設定の問題
   * コンテキスト使用警告（大規模な CLAUDE.md ファイル、高い MCP トークン使用量、到達不可能な権限ルール）
   * プラグインとエージェント読み込みエラー
4. Claude に直接その機能と特性について質問してください。Claude はドキュメントへの組み込みアクセスを持っています
