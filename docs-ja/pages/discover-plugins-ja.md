> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# マーケットプレイスを通じてプリビルトプラグインを発見してインストールする

> マーケットプレイスからプラグインを見つけてインストールし、Claude Codeを新しいコマンド、エージェント、機能で拡張します。

プラグインはカスタムコマンド、エージェント、フック、MCPサーバーでClaude Codeを拡張します。プラグインマーケットプレイスは、自分で構築することなくこれらの拡張機能を発見してインストールするのに役立つカタログです。

独自のマーケットプレイスを作成して配布したいですか？[プラグインマーケットプレイスを作成して配布する](/ja/plugin-marketplaces)を参照してください。

## マーケットプレイスの仕組み

マーケットプレイスは、他の誰かが作成して共有したプラグインのカタログです。マーケットプレイスを使用するのは2段階のプロセスです：

<Steps>
  <Step title="マーケットプレイスを追加する">
    これにより、カタログがClaude Codeに登録され、利用可能なものを参照できます。まだプラグインはインストールされていません。
  </Step>

  <Step title="個別のプラグインをインストールする">
    カタログを参照して、必要なプラグインをインストールします。
  </Step>
</Steps>

アプリストアを追加するようなものと考えてください：ストアを追加するとそのコレクションを参照できるようになりますが、どのアプリをダウンロードするかは個別に選択します。

## 公式Anthropicマーケットプレイス

公式Anthropicマーケットプレイス（`claude-plugins-official`）は、Claude Codeを起動すると自動的に利用可能になります。`/plugin`を実行して**Discover**タブに移動して、利用可能なものを参照してください。

公式マーケットプレイスからプラグインをインストールするには：

```shell  theme={null}
/plugin install plugin-name@claude-plugins-official
```

<Note>
  公式マーケットプレイスはAnthropicによって保守されています。独自のプラグインを配布するには、[独自のマーケットプレイスを作成](/ja/plugin-marketplaces)してユーザーと共有してください。
</Note>

公式マーケットプレイスには、いくつかのカテゴリのプラグインが含まれています：

### コード インテリジェンス

コード インテリジェンスプラグインは、Claudeがコードベースをより深く理解するのに役立ちます。これらのプラグインがインストールされていると、Claudeは定義にジャンプしたり、参照を見つけたり、編集直後に型エラーを表示したりできます。これらのプラグインは[Language Server Protocol](https://microsoft.github.io/language-server-protocol/)（LSP）を使用します。これはVS Codeのコード インテリジェンスを強化する同じテクノロジーです。

これらのプラグインには、システムにインストールされた言語サーバーバイナリが必要です。既に言語サーバーがインストールされている場合、プロジェクトを開くときにClaudeが対応するプラグインをインストールするよう促す場合があります。

| 言語         | プラグイン               | 必要なバイナリ                      |
| :--------- | :------------------ | :--------------------------- |
| C/C++      | `clangd-lsp`        | `clangd`                     |
| C#         | `csharp-lsp`        | `csharp-ls`                  |
| Go         | `gopls-lsp`         | `gopls`                      |
| Java       | `jdtls-lsp`         | `jdtls`                      |
| Lua        | `lua-lsp`           | `lua-language-server`        |
| PHP        | `php-lsp`           | `intelephense`               |
| Python     | `pyright-lsp`       | `pyright-langserver`         |
| Rust       | `rust-analyzer-lsp` | `rust-analyzer`              |
| Swift      | `swift-lsp`         | `sourcekit-lsp`              |
| TypeScript | `typescript-lsp`    | `typescript-language-server` |

[他の言語用の独自のLSPプラグインを作成](/ja/plugins-reference#lsp-servers)することもできます。

<Note>
  プラグインをインストール後に`/plugin`エラータブで`Executable not found in $PATH`が表示される場合は、上記の表から必要なバイナリをインストールしてください。
</Note>

### 外部統合

これらのプラグインは事前設定された[MCPサーバー](/ja/mcp)をバンドルしているため、手動セットアップなしでClaudeを外部サービスに接続できます：

* **ソース管理**: `github`、`gitlab`
* **プロジェクト管理**: `atlassian`（Jira/Confluence）、`asana`、`linear`、`notion`
* **デザイン**: `figma`
* **インフラストラクチャ**: `vercel`、`firebase`、`supabase`
* **コミュニケーション**: `slack`
* **モニタリング**: `sentry`

### 開発ワークフロー

一般的な開発タスク用のコマンドとエージェントを追加するプラグイン：

* **commit-commands**: コミット、プッシュ、PR作成を含むGitコミットワークフロー
* **pr-review-toolkit**: プルリクエストレビュー用の特化したエージェント
* **agent-sdk-dev**: Claude Agent SDKで構築するためのツール
* **plugin-dev**: 独自のプラグインを作成するためのツールキット

### 出力スタイル

Claudeの応答方法をカスタマイズします：

* **explanatory-output-style**: 実装の選択肢に関する教育的な洞察
* **learning-output-style**: スキル構築のためのインタラクティブラーニングモード

## 試してみる：デモマーケットプレイスを追加する

Anthropicは、プラグインシステムで何が可能かを示す例のプラグインを含む[デモプラグインマーケットプレイス](https://github.com/anthropics/claude-code/tree/main/plugins)（`claude-code-plugins`）も保守しています。公式マーケットプレイスとは異なり、このマーケットプレイスは手動で追加する必要があります。

<Steps>
  <Step title="マーケットプレイスを追加する">
    Claude Code内から、`anthropics/claude-code`マーケットプレイスの`plugin marketplace add`コマンドを実行します：

    ```shell  theme={null}
    /plugin marketplace add anthropics/claude-code
    ```

    これにより、マーケットプレイスカタログがダウンロードされ、そのプラグインが利用可能になります。
  </Step>

  <Step title="利用可能なプラグインを参照する">
    `/plugin`を実行してプラグインマネージャーを開きます。これにより、**Tab**（または後ろに戻るには**Shift+Tab**）を使用して循環できる4つのタブを持つタブ付きインターフェイスが開きます：

    * **Discover**: すべてのマーケットプレイスから利用可能なプラグインを参照
    * **Installed**: インストール済みプラグインを表示および管理
    * **Marketplaces**: 追加したマーケットプレイスを追加、削除、または更新
    * **Errors**: プラグイン読み込みエラーを表示

    **Discover**タブに移動して、追加したばかりのマーケットプレイスからのプラグインを確認してください。
  </Step>

  <Step title="プラグインをインストールする">
    プラグインを選択して詳細を表示し、インストールスコープを選択します：

    * **ユーザースコープ**: すべてのプロジェクト全体で自分用にインストール
    * **プロジェクトスコープ**: このリポジトリのすべてのコラボレーター用にインストール
    * **ローカルスコープ**: このリポジトリ内で自分用にのみインストール

    たとえば、**commit-commands**（gitワークフローコマンドを追加するプラグイン）を選択して、ユーザースコープにインストールします。

    コマンドラインから直接インストールすることもできます：

    ```shell  theme={null}
    /plugin install commit-commands@anthropics-claude-code
    ```

    スコープの詳細については、[設定スコープ](/ja/settings#configuration-scopes)を参照してください。
  </Step>

  <Step title="新しいプラグインを使用する">
    インストール後、プラグインのコマンドはすぐに利用可能になります。プラグインコマンドはプラグイン名でネームスペース化されているため、**commit-commands**は`/commit-commands:commit`のようなコマンドを提供します。

    ファイルに変更を加えて、以下を実行して試してみてください：

    ```shell  theme={null}
    /commit-commands:commit
    ```

    これにより、変更がステージングされ、コミットメッセージが生成され、コミットが作成されます。

    各プラグインは異なる方法で機能します。**Discover**タブのプラグインの説明またはそのホームページをチェックして、提供されるコマンドと機能を学習してください。
  </Step>
</Steps>

このガイドの残りの部分では、マーケットプレイスを追加し、プラグインをインストールし、設定を管理するすべての方法について説明します。

## マーケットプレイスを追加する

`/plugin marketplace add`コマンドを使用して、異なるソースからマーケットプレイスを追加します。

<Tip>
  **ショートカット**: `/plugin marketplace`の代わりに`/plugin market`を使用でき、`remove`の代わりに`rm`を使用できます。
</Tip>

* **GitHubリポジトリ**: `owner/repo`形式（例：`anthropics/claude-code`）
* **Git URL**: 任意のGitリポジトリURL（GitLab、Bitbucket、自己ホスト）
* **ローカルパス**: ディレクトリまたは`marketplace.json`ファイルへの直接パス
* **リモートURL**: ホストされた`marketplace.json`ファイルへの直接URL

### GitHubから追加する

`.claude-plugin/marketplace.json`ファイルを含むGitHubリポジトリを`owner/repo`形式を使用して追加します。ここで`owner`はGitHubユーザー名または組織で、`repo`はリポジトリ名です。

たとえば、`anthropics/claude-code`は`anthropics`が所有する`claude-code`リポジトリを指します：

```shell  theme={null}
/plugin marketplace add anthropics/claude-code
```

### 他のGitホストから追加する

完全なURLを提供することで、任意のGitリポジトリを追加します。これはGitLab、Bitbucket、自己ホストサーバーを含む任意のGitホストで機能します：

HTTPSを使用：

```shell  theme={null}
/plugin marketplace add https://gitlab.com/company/plugins.git
```

SSHを使用：

```shell  theme={null}
/plugin marketplace add git@gitlab.com:company/plugins.git
```

特定のブランチまたはタグを追加するには、`#`の後に参照を追加します：

```shell  theme={null}
/plugin marketplace add https://gitlab.com/company/plugins.git#v1.0.0
```

### ローカルパスから追加する

`.claude-plugin/marketplace.json`ファイルを含むローカルディレクトリを追加します：

```shell  theme={null}
/plugin marketplace add ./my-marketplace
```

`marketplace.json`ファイルへの直接パスを追加することもできます：

```shell  theme={null}
/plugin marketplace add ./path/to/marketplace.json
```

### リモートURLから追加する

URLを介してリモート`marketplace.json`ファイルを追加します：

```shell  theme={null}
/plugin marketplace add https://example.com/marketplace.json
```

<Note>
  URLベースのマーケットプレイスは、Gitベースのマーケットプレイスと比べていくつかの制限があります。プラグインをインストールするときに「パスが見つかりません」エラーが発生する場合は、[トラブルシューティング](/ja/plugin-marketplaces#plugins-with-relative-paths-fail-in-url-based-marketplaces)を参照してください。
</Note>

## プラグインをインストールする

マーケットプレイスを追加したら、プラグインを直接インストールできます（デフォルトではユーザースコープにインストール）：

```shell  theme={null}
/plugin install plugin-name@marketplace-name
```

別の[インストールスコープ](/ja/settings#configuration-scopes)を選択するには、インタラクティブUIを使用します：`/plugin`を実行して**Discover**タブに移動し、プラグインで**Enter**を押します。以下のオプションが表示されます：

* **ユーザースコープ**（デフォルト）: すべてのプロジェクト全体で自分用にインストール
* **プロジェクトスコープ**: このリポジトリのすべてのコラボレーター用にインストール（`.claude/settings.json`に追加）
* **ローカルスコープ**: このリポジトリ内で自分用にのみインストール（コラボレーターと共有されない）

**管理**スコープのプラグインも表示される場合があります。これらは管理者が[管理設定](/ja/settings#settings-files)を通じてインストールしたもので、変更することはできません。

`/plugin`を実行して**Installed**タブに移動して、スコープでグループ化されたプラグインを確認してください。

<Warning>
  プラグインをインストールする前に、それを信頼していることを確認してください。Anthropicはプラグインに含まれるMCPサーバー、ファイル、またはその他のソフトウェアを制御せず、意図したとおりに機能することを確認できません。詳細については、各プラグインのホームページを確認してください。
</Warning>

## インストール済みプラグインを管理する

`/plugin`を実行して**Installed**タブに移動して、プラグインを表示、有効化、無効化、またはアンインストールします。

直接コマンドでプラグインを管理することもできます。

プラグインをアンインストールせずに無効化：

```shell  theme={null}
/plugin disable plugin-name@marketplace-name
```

無効化されたプラグインを再度有効化：

```shell  theme={null}
/plugin enable plugin-name@marketplace-name
```

プラグインを完全に削除：

```shell  theme={null}
/plugin uninstall plugin-name@marketplace-name
```

`--scope`オプションを使用すると、CLIコマンドで特定のスコープをターゲットにできます：

```shell  theme={null}
claude plugin install formatter@your-org --scope project
claude plugin uninstall formatter@your-org --scope project
```

## マーケットプレイスを管理する

インタラクティブ`/plugin`インターフェイスまたはCLIコマンドを使用してマーケットプレイスを管理できます。

### インタラクティブインターフェイスを使用する

`/plugin`を実行して**Marketplaces**タブに移動して、以下を実行します：

* 追加したすべてのマーケットプレイスをソースとステータスとともに表示
* 新しいマーケットプレイスを追加
* マーケットプレイスリストを更新して最新のプラグインを取得
* 不要になったマーケットプレイスを削除

### CLIコマンドを使用する

直接コマンドでマーケットプレイスを管理することもできます。

設定されたすべてのマーケットプレイスをリスト：

```shell  theme={null}
/plugin marketplace list
```

マーケットプレイスからプラグインリストを更新：

```shell  theme={null}
/plugin marketplace update marketplace-name
```

マーケットプレイスを削除：

```shell  theme={null}
/plugin marketplace remove marketplace-name
```

<Warning>
  マーケットプレイスを削除すると、そこからインストールしたプラグインがアンインストールされます。
</Warning>

### 自動更新を設定する

Claude Codeは起動時にマーケットプレイスとそのインストール済みプラグインを自動的に更新できます。マーケットプレイスで自動更新が有効になっている場合、Claude Codeはマーケットプレイスデータを更新し、インストール済みプラグインを最新バージョンに更新します。プラグインが更新された場合、Claude Codeを再起動することをお勧めする通知が表示されます。

UIを通じて個別のマーケットプレイスの自動更新を切り替えます：

1. `/plugin`を実行してプラグインマネージャーを開く
2. **Marketplaces**を選択
3. リストからマーケットプレイスを選択
4. **自動更新を有効化**または**自動更新を無効化**を選択

公式Anthropicマーケットプレイスはデフォルトで自動更新が有効になっています。サードパーティおよびローカル開発マーケットプレイスはデフォルトで自動更新が無効になっています。

Claude Codeとすべてのプラグインのすべての自動更新を完全に無効にするには、`DISABLE_AUTOUPDATER`環境変数を設定します。詳細については、[自動更新](/ja/setup#auto-updates)を参照してください。

Claude Code自動更新を無効にしながらプラグイン自動更新を有効にしておくには、`DISABLE_AUTOUPDATER`と一緒に`FORCE_AUTOUPDATE_PLUGINS=true`を設定します：

```shell  theme={null}
export DISABLE_AUTOUPDATER=true
export FORCE_AUTOUPDATE_PLUGINS=true
```

これは、Claude Code更新を手動で管理したいが、プラグイン更新は自動的に受け取りたい場合に便利です。

## チームマーケットプレイスを設定する

チーム管理者は、`.claude/settings.json`にマーケットプレイス設定を追加することで、プロジェクトの自動マーケットプレイスインストールを設定できます。チームメンバーがリポジトリフォルダを信頼すると、Claude Codeはこれらのマーケットプレイスとプラグインをインストールするよう促します。

`extraKnownMarketplaces`と`enabledPlugins`を含む完全な設定オプションについては、[プラグイン設定](/ja/settings#plugin-settings)を参照してください。

## トラブルシューティング

### /pluginコマンドが認識されない

「不明なコマンド」が表示されるか、`/plugin`コマンドが表示されない場合：

1. **バージョンを確認**: `claude --version`を実行します。プラグインにはバージョン1.0.33以降が必要です。
2. **Claude Codeを更新**:
   * **Homebrew**: `brew upgrade claude-code`
   * **npm**: `npm update -g @anthropic-ai/claude-code`
   * **ネイティブインストーラー**: [セットアップ](/ja/setup)からインストールコマンドを再実行
3. **Claude Codeを再起動**: 更新後、ターミナルを再起動して`claude`を再度実行します。

### 一般的な問題

* **マーケットプレイスが読み込まれない**: URLがアクセス可能で、`.claude-plugin/marketplace.json`がパスに存在することを確認
* **プラグインインストール失敗**: プラグインソースURLがアクセス可能で、リポジトリが公開されている（またはアクセス権がある）ことを確認
* **インストール後にファイルが見つからない**: プラグインはキャッシュにコピーされるため、プラグインディレクトリ外のファイルを参照するパスは機能しません
* **プラグインスキルが表示されない**: `rm -rf ~/.claude/plugins/cache`でキャッシュをクリアし、Claude Codeを再起動して、プラグインを再インストールします。詳細については、[プラグインスキルがインストール後に表示されない](/ja/skills#plugin-skills-not-appearing-after-installation)を参照してください。

詳細なトラブルシューティングと解決策については、マーケットプレイスガイドの[トラブルシューティング](/ja/plugin-marketplaces#troubleshooting)を参照してください。デバッグツールについては、[デバッグおよび開発ツール](/ja/plugins-reference#debugging-and-development-tools)を参照してください。

## 次のステップ

* **独自のプラグインを構築**: カスタムコマンド、エージェント、フックを作成するには、[プラグイン](/ja/plugins)を参照してください
* **マーケットプレイスを作成**: チームまたはコミュニティにプラグインを配布するには、[プラグインマーケットプレイスを作成](/ja/plugin-marketplaces)を参照してください
* **技術リファレンス**: 完全な仕様については、[プラグインリファレンス](/ja/plugins-reference)を参照してください
