> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# Claude Code をセットアップする

> 開発マシンに Claude Code をインストール、認証し、使用を開始します。

## システム要件

* **オペレーティングシステム**: macOS 13.0+、Ubuntu 20.04+/Debian 10+、または Windows 10+（WSL 1、WSL 2、または Git for Windows を使用）
* **ハードウェア**: 4 GB 以上の RAM
* **ネットワーク**: インターネット接続が必要です（[ネットワーク設定](/ja/network-config#network-access-requirements)を参照）
* **シェル**: Bash または Zsh で最適に動作します
* **場所**: [Anthropic がサポートしている国](https://www.anthropic.com/supported-countries)

### 追加の依存関係

* **ripgrep**: 通常は Claude Code に含まれています。検索が失敗する場合は、[検索のトラブルシューティング](/ja/troubleshooting#search-and-discovery-issues)を参照してください。
* **[Node.js 18+](https://nodejs.org/en/download)**: [非推奨の npm インストール](#npm-installation-deprecated)にのみ必要です

## インストール

To install Claude Code, use one of the following methods:

<Tabs>
  <Tab title="Native Install (Recommended)">
    **macOS, Linux, WSL:**

    ```bash  theme={null}
    curl -fsSL https://claude.ai/install.sh | bash
    ```

    **Windows PowerShell:**

    ```powershell  theme={null}
    irm https://claude.ai/install.ps1 | iex
    ```

    **Windows CMD:**

    ```batch  theme={null}
    curl -fsSL https://claude.ai/install.cmd -o install.cmd && install.cmd && del install.cmd
    ```

    <Info>
      Native installations automatically update in the background to keep you on the latest version.
    </Info>
  </Tab>

  <Tab title="Homebrew">
    ```sh  theme={null}
    brew install --cask claude-code
    ```

    <Info>
      Homebrew installations do not auto-update. Run `brew upgrade claude-code` periodically to get the latest features and security fixes.
    </Info>
  </Tab>

  <Tab title="WinGet">
    ```powershell  theme={null}
    winget install Anthropic.ClaudeCode
    ```

    <Info>
      WinGet installations do not auto-update. Run `winget upgrade Anthropic.ClaudeCode` periodically to get the latest features and security fixes.
    </Info>
  </Tab>
</Tabs>

インストールプロセスが完了した後、プロジェクトに移動して Claude Code を開始します：

```bash  theme={null}
cd your-awesome-project
claude
```

インストール中に問題が発生した場合は、[トラブルシューティングガイド](/ja/troubleshooting)を参照してください。

<Tip>
  インストール後に `claude doctor` を実行して、インストールタイプとバージョンを確認します。
</Tip>

<Note>
  **Alpine Linux およびその他の musl/uClibc ベースのディストリビューション**: ネイティブインストーラーには `libgcc`、`libstdc++`、および `ripgrep` が必要です。Alpine の場合: `apk add libgcc libstdc++ ripgrep`。`USE_BUILTIN_RIPGREP=0` を設定します。
</Note>

### 認証

#### 個人向け

1. **Claude Pro または Max プラン**（推奨）: Claude の [Pro または Max プラン](https://claude.ai/pricing)にサブスクライブして、Claude Code と Web 上の Claude の両方を含む統一されたサブスクリプションを取得します。1 つの場所でアカウントを管理し、Claude.ai アカウントでログインします。
2. **Claude Console**: [Claude Console](https://console.anthropic.com)を通じて接続し、OAuth プロセスを完了します。Anthropic Console でのアクティブな課金が必要です。「Claude Code」ワークスペースは使用状況の追跡とコスト管理のために自動的に作成されます。Claude Code ワークスペース用の API キーを作成することはできません。これは Claude Code の使用専用です。

#### チームおよび組織向け

1. **Claude for Teams または Enterprise**（推奨）: [Claude for Teams](https://claude.com/pricing#team-&-enterprise)または [Claude for Enterprise](https://anthropic.com/contact-sales)にサブスクライブして、一元化された課金、チーム管理、および Claude Code と Web 上の Claude の両方へのアクセスを取得します。チームメンバーは Claude.ai アカウントでログインします。
2. **チーム課金を使用した Claude Console**: チーム課金を使用して共有 [Claude Console](https://console.anthropic.com)組織をセットアップします。チームメンバーを招待し、使用状況の追跡のためにロールを割り当てます。
3. **クラウドプロバイダー**: [Amazon Bedrock、Google Vertex AI、または Microsoft Foundry](/ja/third-party-integrations)を使用するように Claude Code を設定して、既存のクラウドインフラストラクチャでのデプロイメントを行います。

### 特定のバージョンをインストール

ネイティブインストーラーは、特定のバージョン番号またはリリースチャネル（`latest` または `stable`）を受け入れます。インストール時に選択したチャネルが自動更新のデフォルトになります。詳細については、[リリースチャネルの設定](#configure-release-channel)を参照してください。

最新バージョンをインストールするには（デフォルト）:

<Tabs>
  <Tab title="macOS、Linux、WSL">
    ```bash  theme={null}
    curl -fsSL https://claude.ai/install.sh | bash
    ```
  </Tab>

  <Tab title="Windows PowerShell">
    ```powershell  theme={null}
    irm https://claude.ai/install.ps1 | iex
    ```
  </Tab>

  <Tab title="Windows CMD">
    ```batch  theme={null}
    curl -fsSL https://claude.ai/install.cmd -o install.cmd && install.cmd && del install.cmd
    ```
  </Tab>
</Tabs>

安定版をインストールするには:

<Tabs>
  <Tab title="macOS、Linux、WSL">
    ```bash  theme={null}
    curl -fsSL https://claude.ai/install.sh | bash -s stable
    ```
  </Tab>

  <Tab title="Windows PowerShell">
    ```powershell  theme={null}
    & ([scriptblock]::Create((irm https://claude.ai/install.ps1))) stable
    ```
  </Tab>

  <Tab title="Windows CMD">
    ```batch  theme={null}
    curl -fsSL https://claude.ai/install.cmd -o install.cmd && install.cmd stable && del install.cmd
    ```
  </Tab>
</Tabs>

特定のバージョン番号をインストールするには:

<Tabs>
  <Tab title="macOS、Linux、WSL">
    ```bash  theme={null}
    curl -fsSL https://claude.ai/install.sh | bash -s 1.0.58
    ```
  </Tab>

  <Tab title="Windows PowerShell">
    ```powershell  theme={null}
    & ([scriptblock]::Create((irm https://claude.ai/install.ps1))) 1.0.58
    ```
  </Tab>

  <Tab title="Windows CMD">
    ```batch  theme={null}
    curl -fsSL https://claude.ai/install.cmd -o install.cmd && install.cmd 1.0.58 && del install.cmd
    ```
  </Tab>
</Tabs>

### バイナリの整合性とコード署名

* すべてのプラットフォームの SHA256 チェックサムはリリースマニフェストで公開されており、現在 `https://storage.googleapis.com/claude-code-dist-86c565f3-f756-42ad-8dfa-d59b1c096819/claude-code-releases/{VERSION}/manifest.json` に位置しています（例：`{VERSION}` を `2.0.30` に置き換えます）
* 署名されたバイナリは以下のプラットフォーム向けに配布されています：
  * macOS: 「Anthropic PBC」によって署名され、Apple によって公証されています
  * Windows: 「Anthropic, PBC」によって署名されています

## NPM インストール（非推奨）

NPM インストールは非推奨です。可能な場合は[ネイティブインストール](#installation)方法を使用してください。既存の npm インストールをネイティブに移行するには、`claude install` を実行します。

**グローバル npm インストール**

```sh  theme={null}
npm install -g @anthropic-ai/claude-code
```

<Warning>
  `sudo npm install -g` を使用しないでください。これは権限の問題とセキュリティリスクにつながる可能性があります。
  権限エラーが発生した場合は、推奨されるソリューションについて[権限エラーのトラブルシューティング](/ja/troubleshooting#command-not-found-claude-or-permission-errors)を参照してください。
</Warning>

## Windows セットアップ

**オプション 1: WSL 内の Claude Code**

* WSL 1 と WSL 2 の両方がサポートされています

**オプション 2: Git Bash を使用したネイティブ Windows での Claude Code**

* [Git for Windows](https://git-scm.com/downloads/win)が必要です
* ポータブル Git インストールの場合は、`bash.exe` へのパスを指定します：
  ```powershell  theme={null}
  $env:CLAUDE_CODE_GIT_BASH_PATH="C:\Program Files\Git\bin\bash.exe"
  ```

## Claude Code を更新

### 自動更新

Claude Code は最新の機能とセキュリティ修正を確保するために自動的に自身を最新に保ちます。

* **更新チェック**: スタートアップ時および実行中に定期的に実行されます
* **更新プロセス**: バックグラウンドで自動的にダウンロードおよびインストールされます
* **通知**: 更新がインストールされたときに通知が表示されます
* **更新の適用**: 更新は Claude Code を次回起動したときに有効になります

<Note>
  Homebrew および WinGet インストールは自動更新されません。`brew upgrade claude-code` または `winget upgrade Anthropic.ClaudeCode` を使用して手動で更新します。

  **既知の問題**: Claude Code は新しいバージョンがこれらのパッケージマネージャーで利用可能になる前に更新を通知する場合があります。アップグレードが失敗した場合は、待機してから後で再度試してください。
</Note>

### リリースチャネルの設定

`autoUpdatesChannel` 設定を使用して、自動更新と `claude update` の両方に対して Claude Code が従うリリースチャネルを設定します：

* `"latest"`（デフォルト）: リリースされるとすぐに新機能を受け取ります
* `"stable"`: 通常約 1 週間古いバージョンを使用し、大きな回帰を伴うリリースをスキップします

これを `/config` → **自動更新チャネル**経由で設定するか、[settings.json ファイル](/ja/settings)に追加します：

```json  theme={null}
{
  "autoUpdatesChannel": "stable"
}
```

エンタープライズデプロイメントの場合、[管理設定](/ja/iam#managed-settings)を使用して組織全体で一貫したリリースチャネルを強制できます。

### 自動更新を無効にする

シェルまたは [settings.json ファイル](/ja/settings)で `DISABLE_AUTOUPDATER` 環境変数を設定します：

```bash  theme={null}
export DISABLE_AUTOUPDATER=1
```

### 手動で更新

```bash  theme={null}
claude update
```

## Claude Code をアンインストール

Claude Code をアンインストールする必要がある場合は、インストール方法の指示に従ってください。

### ネイティブインストール

Claude Code バイナリとバージョンファイルを削除します：

**macOS、Linux、WSL:**

```bash  theme={null}
rm -f ~/.local/bin/claude
rm -rf ~/.local/share/claude
```

**Windows PowerShell:**

```powershell  theme={null}
Remove-Item -Path "$env:USERPROFILE\.local\bin\claude.exe" -Force
Remove-Item -Path "$env:USERPROFILE\.local\share\claude" -Recurse -Force
```

**Windows CMD:**

```batch  theme={null}
del "%USERPROFILE%\.local\bin\claude.exe"
rmdir /s /q "%USERPROFILE%\.local\share\claude"
```

### Homebrew インストール

```bash  theme={null}
brew uninstall --cask claude-code
```

### WinGet インストール

```powershell  theme={null}
winget uninstall Anthropic.ClaudeCode
```

### NPM インストール

```bash  theme={null}
npm uninstall -g @anthropic-ai/claude-code
```

### 設定ファイルをクリーンアップする（オプション）

<Warning>
  設定ファイルを削除すると、すべての設定、許可されたツール、MCP サーバー設定、およびセッション履歴が削除されます。
</Warning>

Claude Code の設定とキャッシュされたデータを削除するには：

**macOS、Linux、WSL:**

```bash  theme={null}
# ユーザー設定と状態を削除
rm -rf ~/.claude
rm ~/.claude.json

# プロジェクト固有の設定を削除（プロジェクトディレクトリから実行）
rm -rf .claude
rm -f .mcp.json
```

**Windows PowerShell:**

```powershell  theme={null}
# ユーザー設定と状態を削除
Remove-Item -Path "$env:USERPROFILE\.claude" -Recurse -Force
Remove-Item -Path "$env:USERPROFILE\.claude.json" -Force

# プロジェクト固有の設定を削除（プロジェクトディレクトリから実行）
Remove-Item -Path ".claude" -Recurse -Force
Remove-Item -Path ".mcp.json" -Force
```

**Windows CMD:**

```batch  theme={null}
REM ユーザー設定と状態を削除
rmdir /s /q "%USERPROFILE%\.claude"
del "%USERPROFILE%\.claude.json"

REM プロジェクト固有の設定を削除（プロジェクトディレクトリから実行）
rmdir /s /q ".claude"
del ".mcp.json"
```
