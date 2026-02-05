> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# トラブルシューティング

> Claude Codeのインストールと使用に関する一般的な問題の解決策を発見してください。

## 一般的なインストールの問題

### Windowsのインストール問題: WSLでのエラー

WSLで以下の問題が発生する可能性があります:

**OS/プラットフォーム検出の問題**: インストール中にエラーが発生した場合、WSLがWindows `npm`を使用している可能性があります。以下を試してください:

* インストール前に `npm config set os linux` を実行してください
* `npm install -g @anthropic-ai/claude-code --force --no-os-check` でインストールしてください (`sudo` は使用しないでください)

**Nodeが見つからないエラー**: `claude` を実行するときに `exec: node: not found` が表示される場合、WSL環境がWindowsにインストールされたNode.jsを使用している可能性があります。`which npm` と `which node` で確認できます。これらは `/usr/` で始まるLinuxパスを指す必要があり、`/mnt/c/` ではありません。これを修正するには、Linuxディストリビューションのパッケージマネージャーまたは [`nvm`](https://github.com/nvm-sh/nvm) 経由でNodeをインストールしてみてください。

**nvmバージョンの競合**: WSLとWindowsの両方にnvmがインストールされている場合、WSLでNodeバージョンを切り替えるときにバージョンの競合が発生する可能性があります。これはWSLがデフォルトでWindows PATHをインポートするため、Windows nvm/npmがWSLインストールより優先されるために発生します。

この問題は以下の方法で特定できます:

* `which npm` と `which node` を実行してください。`/mnt/c/` で始まるWindowsパスを指している場合、Windowsバージョンが使用されています
* WSLでnvmを使用してNodeバージョンを切り替えた後、機能が壊れている

この問題を解決するには、Linux PATH を修正してLinux node/npmバージョンが優先されるようにしてください:

**主な解決策: nvmがシェルで正しく読み込まれていることを確認する**

最も一般的な原因は、nvmが非対話型シェルで読み込まれていないことです。シェル設定ファイル (`~/.bashrc`, `~/.zshrc` など) に以下を追加してください:

```bash  theme={null}
# Load nvm if it exists
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
```

または現在のセッションで直接実行してください:

```bash  theme={null}
source ~/.nvm/nvm.sh
```

**代替案: PATH順序を調整する**

nvmが正しく読み込まれているがWindowsパスがまだ優先される場合、シェル設定でLinuxパスをPATHの前に明示的に追加できます:

```bash  theme={null}
export PATH="$HOME/.nvm/versions/node/$(node -v)/bin:$PATH"
```

<Warning>
  Windowsパスのインポートを無効にする (`appendWindowsPath = false`) ことは避けてください。これはWSLからWindowsの実行可能ファイルを呼び出す機能を破壊します。同様に、Windows開発にNode.jsを使用している場合は、Windowsからアンインストールすることも避けてください。
</Warning>

### LinuxおよびMacのインストール問題: パーミッションまたはコマンドが見つからないエラー

npmでClaude Codeをインストールするとき、`PATH` の問題により `claude` へのアクセスが妨げられる可能性があります。
また、npmグローバルプレフィックスがユーザー書き込み可能でない場合 (例えば `/usr` または `/usr/local`) パーミッションエラーが発生する可能性があります。

#### 推奨される解決策: ネイティブClaude Codeインストール

Claude CodeにはnpmまたはNode.jsに依存しないネイティブインストールがあります。

ネイティブインストーラーを実行するには、以下のコマンドを使用してください。

**macOS、Linux、WSL:**

```bash  theme={null}
# Install stable version (default)
curl -fsSL https://claude.ai/install.sh | bash

# Install latest version
curl -fsSL https://claude.ai/install.sh | bash -s latest

# Install specific version number
curl -fsSL https://claude.ai/install.sh | bash -s 1.0.58
```

**Windows PowerShell:**

```powershell  theme={null}
# Install stable version (default)
irm https://claude.ai/install.ps1 | iex

# Install latest version
& ([scriptblock]::Create((irm https://claude.ai/install.ps1))) latest

# Install specific version number
& ([scriptblock]::Create((irm https://claude.ai/install.ps1))) 1.0.58

```

このコマンドは、オペレーティングシステムとアーキテクチャに適切なClaude Codeビルドをインストールし、`~/.local/bin/claude` (またはWindows上の `%USERPROFILE%\.local\bin\claude.exe`) へのシンボリックリンクを追加します。

<Tip>
  インストールディレクトリがシステムPATHに含まれていることを確認してください。
</Tip>

### Windows: 「Claude Code on Windows requires git-bash」

ネイティブWindowsのClaude Codeには [Git for Windows](https://git-scm.com/downloads/win) が必要です。これにはGit Bashが含まれています。Gitがインストールされているが検出されない場合:

1. Claude を実行する前にPowerShellでパスを明示的に設定してください:
   ```powershell  theme={null}
   $env:CLAUDE_CODE_GIT_BASH_PATH="C:\Program Files\Git\bin\bash.exe"
   ```

2. または、システムプロパティ → 環境変数を通じてシステム環境変数に永続的に追加してください。

Gitが標準以外の場所にインストールされている場合は、パスを適切に調整してください。

### Windows: 「installMethod is native, but claude command not found」

インストール後にこのエラーが表示される場合、`claude` コマンドがPATHにありません。手動で追加してください:

<Steps>
  <Step title="環境変数を開く">
    `Win + R` を押して、`sysdm.cpl` と入力し、Enterキーを押してください。**詳細設定** → **環境変数** をクリックしてください。
  </Step>

  <Step title="ユーザーPATHを編集する">
    「ユーザー変数」で **Path** を選択して **編集** をクリックしてください。**新規** をクリックして以下を追加してください:

    ```
    %USERPROFILE%\.local\bin
    ```
  </Step>

  <Step title="ターミナルを再起動する">
    PowerShellまたはCMDを閉じて再度開き、変更を有効にしてください。
  </Step>
</Steps>

インストールを確認してください:

```bash  theme={null}
claude doctor # Check installation health
```

## パーミッションと認証

### 繰り返されるパーミッションプロンプト

同じコマンドを繰り返し承認する必要がある場合、`/permissions` コマンドを使用して特定のツールを承認なしで実行できます。[パーミッションドキュメント](/ja/iam#configuring-permissions) を参照してください。

### 認証の問題

認証に問題が発生している場合:

1. `/logout` を実行して完全にサインアウトしてください
2. Claude Codeを閉じてください
3. `claude` で再起動して、認証プロセスを再度完了してください

問題が解決しない場合は、以下を試してください:

```bash  theme={null}
rm -rf ~/.config/claude-code/auth.json
claude
```

これにより、保存された認証情報が削除され、クリーンなログインが強制されます。

## 設定ファイルの場所

Claude Codeは複数の場所に設定を保存します:

| ファイル                          | 目的                                             |
| :---------------------------- | :--------------------------------------------- |
| `~/.claude/settings.json`     | ユーザー設定 (パーミッション、フック、モデルオーバーライド)                |
| `.claude/settings.json`       | プロジェクト設定 (ソース管理にチェックイン)                        |
| `.claude/settings.local.json` | ローカルプロジェクト設定 (コミットされない)                        |
| `~/.claude.json`              | グローバル状態 (テーマ、OAuth、MCPサーバー、許可されたツール)           |
| `.mcp.json`                   | プロジェクトMCPサーバー (ソース管理にチェックイン)                   |
| `managed-settings.json`       | [管理設定](/ja/settings#settings-files)            |
| `managed-mcp.json`            | [管理MCPサーバー](/ja/mcp#managed-mcp-configuration) |

Windowsでは、`~` はユーザーホームディレクトリ (例: `C:\Users\YourName`) を指します。

**管理ファイルの場所:**

* macOS: `/Library/Application Support/ClaudeCode/`
* Linux/WSL: `/etc/claude-code/`
* Windows: `C:\Program Files\ClaudeCode\`

これらのファイルの設定の詳細については、[設定](/ja/settings) と [MCP](/ja/mcp) を参照してください。

### 設定をリセットする

Claude Codeをデフォルト設定にリセットするには、設定ファイルを削除できます:

```bash  theme={null}
# Reset all user settings and state
rm ~/.claude.json
rm -rf ~/.claude/

# Reset project-specific settings
rm -rf .claude/
rm .mcp.json
```

<Warning>
  これにより、すべての設定、許可されたツール、MCPサーバー設定、およびセッション履歴が削除されます。
</Warning>

## パフォーマンスと安定性

### 高いCPUまたはメモリ使用率

Claude Codeはほとんどの開発環境で動作するように設計されていますが、大規模なコードベースを処理する場合、かなりのリソースを消費する可能性があります。パフォーマンスの問題が発生している場合:

1. `/compact` を定期的に使用してコンテキストサイズを削減してください
2. 主要なタスク間でClaude Codeを閉じて再起動してください
3. 大規模なビルドディレクトリを `.gitignore` ファイルに追加することを検討してください

### コマンドがハングまたはフリーズする

Claude Codeが応答しないように見える場合:

1. Ctrl+C を押して現在の操作をキャンセルしてみてください
2. 応答しない場合は、ターミナルを閉じて再起動する必要があります

### 検索と発見の問題

検索ツール、`@file` メンション、カスタムエージェント、カスタムスラッシュコマンドが機能していない場合は、システム `ripgrep` をインストールしてください:

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

次に、[環境](/ja/settings#environment-variables) で `USE_BUILTIN_RIPGREP=0` を設定してください。

### WSLでの遅い、または不完全な検索結果

[WSLでファイルシステム間で作業する](https://learn.microsoft.com/en-us/windows/wsl/filesystems) ときのディスク読み取りパフォーマンスペナルティにより、WSLでClaude Codeを使用する場合、予想より少ない一致結果 (ただし検索機能の完全な欠落ではない) が発生する可能性があります。

<Note>
  この場合、`/doctor` は検索をOKと表示します。
</Note>

**解決策:**

1. **より具体的な検索を送信してください**: 検索するファイル数を減らすために、ディレクトリまたはファイルタイプを指定してください: 「auth-serviceパッケージでJWT検証ロジックを検索してください」または「JSファイルでmd5ハッシュの使用を見つけてください」。

2. **プロジェクトをLinuxファイルシステムに移動してください**: 可能であれば、プロジェクトがWindowsファイルシステム (`/mnt/c/`) ではなくLinuxファイルシステム (`/home/`) に配置されていることを確認してください。

3. **ネイティブWindowsを使用してください**: WSLではなくネイティブWindowsでClaude Codeを実行することを検討してください。ファイルシステムのパフォーマンスが向上します。

## IDE統合の問題

### WSL2でJetBrains IDEが検出されない

WSL2でClaude CodeをJetBrains IDEと一緒に使用していて、「No available IDEs detected」エラーが表示される場合、これはWSL2のネットワーク設定またはWindows Firewallが接続をブロックしている可能性があります。

#### WSL2ネットワークモード

WSL2はデフォルトでNATネットワークを使用します。これはIDE検出を妨げる可能性があります。2つのオプションがあります:

**オプション1: Windows Firewallを設定する** (推奨)

1. WSL2 IPアドレスを見つけてください:
   ```bash  theme={null}
   wsl hostname -I
   # Example output: 172.21.123.456
   ```

2. PowerShellを管理者として開き、ファイアウォールルールを作成してください:
   ```powershell  theme={null}
   New-NetFirewallRule -DisplayName "Allow WSL2 Internal Traffic" -Direction Inbound -Protocol TCP -Action Allow -RemoteAddress 172.21.0.0/16 -LocalAddress 172.21.0.0/16
   ```
   (ステップ1のWSL2サブネットに基づいてIPレンジを調整してください)

3. IDEとClaude Codeの両方を再起動してください

**オプション2: ミラーリングネットワークに切り替える**

Windowsユーザーディレクトリの `.wslconfig` に追加してください:

```ini  theme={null}
[wsl2]
networkingMode=mirrored
```

次に、PowerShellから `wsl --shutdown` でWSLを再起動してください。

<Note>
  これらのネットワーク問題はWSL2のみに影響します。WSL1はホストのネットワークを直接使用し、これらの設定は必要ありません。
</Note>

JetBrains設定のその他のヒントについては、[JetBrains IDEガイド](/ja/jetbrains#plugin-settings) を参照してください。

### Windows IDE統合の問題を報告する (ネイティブとWSL両方)

Windowsで IDE統合の問題が発生している場合、以下の情報を含めて [問題を作成](https://github.com/anthropics/claude-code/issues) してください:

* 環境タイプ: ネイティブWindows (Git Bash) またはWSL1/WSL2
* WSLネットワークモード (該当する場合): NATまたはミラーリング
* IDE名とバージョン
* Claude Code拡張機能/プラグインバージョン
* シェルタイプ: Bash、Zsh、PowerShellなど

### JetBrains (IntelliJ、PyCharmなど) ターミナルでEscキーが機能しない

Claude CodeをJetBrainsターミナルで使用していて、`Esc` キーがエージェントを中断しない場合、これはJetBrainsのデフォルトショートカットとのキーバインディングの競合が原因である可能性があります。

この問題を修正するには:

1. 設定 → ツール → ターミナルに移動してください
2. 以下のいずれかを実行してください:
   * 「Escapeでエディターにフォーカスを移動」をオフにするか、
   * 「ターミナルキーバインディングを設定」をクリックして「エディターにフォーカスを切り替え」ショートカットを削除してください
3. 変更を適用してください

これにより、`Esc` キーがClaude Code操作を適切に中断できるようになります。

## Markdownフォーマットの問題

Claude Codeは、コードフェンスに言語タグが欠落しているMarkdownファイルを生成することがあります。これはGitHub、エディター、ドキュメントツールの構文ハイライトと読みやすさに影響を与える可能性があります。

### コードブロックの言語タグが欠落している

生成されたMarkdownで以下のようなコードブロックに気付いた場合:

````markdown  theme={null}
```
function example() {
  return "hello";
}
```
````

適切にタグ付けされたブロックの代わりに:

````markdown  theme={null}
```javascript
function example() {
  return "hello";
}
```
````

**解決策:**

1. **Claudeに言語タグを追加するよう依頼してください**: 「このMarkdownファイルのすべてのコードブロックに適切な言語タグを追加してください」とリクエストしてください。

2. **後処理フックを使用してください**: 言語タグが欠落しているのを検出して追加するための自動フォーマットフックを設定してください。実装の詳細については、[Markdownフォーマットフックの例](/ja/hooks-guide#markdown-formatting-hook) を参照してください。

3. **手動で確認してください**: Markdownファイルを生成した後、適切なコードブロックフォーマットを確認し、必要に応じて修正をリクエストしてください。

### 一貫性のないスペースとフォーマット

生成されたMarkdownに過度な空行または一貫性のないスペースがある場合:

**解決策:**

1. **フォーマット修正をリクエストしてください**: Claudeに「このMarkdownファイルのスペースとフォーマットの問題を修正してください」とリクエストしてください。

2. **フォーマットツールを使用してください**: `prettier` またはカスタムフォーマットスクリプトなどのMarkdownフォーマッターを実行するフックを設定してください。

3. **フォーマット設定を指定してください**: プロンプトまたはプロジェクト [メモリ](/ja/memory) ファイルにフォーマット要件を含めてください。

### Markdownの生成のベストプラクティス

フォーマットの問題を最小化するには:

* **リクエストで明示的にしてください**: 「言語タグ付きコードブロック付きの適切にフォーマットされたMarkdown」をリクエストしてください
* **プロジェクト規約を使用してください**: [`CLAUDE.md`](/ja/memory) で優先するMarkdownスタイルを文書化してください
* **検証フックを設定してください**: 後処理フックを使用して、一般的なフォーマットの問題を自動的に確認して修正してください

## さらにヘルプを得る

ここでカバーされていない問題が発生している場合:

1. Claude Code内で `/bug` コマンドを使用して、Anthropicに直接問題を報告してください
2. [GitHubリポジトリ](https://github.com/anthropics/claude-code) で既知の問題を確認してください
3. `/doctor` を実行してClaude Codeインストールの健全性を確認してください
4. Claudeに直接その機能と特性について質問してください。Claudeはドキュメントへの組み込みアクセスを持っています
