> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# マーケットプレイスから事前構築されたプラグインを発見してインストールする

> マーケットプレイスからプラグインを検索してインストールし、Claude Code を新しいスキル、エージェント、機能で拡張します。

プラグインは Claude Code をスキル、エージェント、フック、MCP サーバーで拡張します。プラグインマーケットプレイスは、これらの拡張機能を自分で構築することなく発見してインストールするのに役立つカタログです。

独自のマーケットプレイスを作成して配布したいですか？[プラグインマーケットプレイスを作成して配布する](/docs/ja/plugin-marketplaces)を参照してください。

<h2 id="how-marketplaces-work">
  マーケットプレイスの仕組み
</h2>

マーケットプレイスは、他の誰かが作成して共有したプラグインのカタログです。マーケットプレイスを使用するのは 2 段階のプロセスです：

<Steps>
  <Step title="マーケットプレイスを追加する">
    これにより、カタログが Claude Code に登録され、利用可能なものを参照できるようになります。プラグインはまだインストールされていません。
  </Step>

  <Step title="個別のプラグインをインストールする">
    カタログを参照して、必要なプラグインをインストールします。
  </Step>
</Steps>

<h2 id="official-anthropic-marketplace">
  公式 Anthropic マーケットプレイス
</h2>

Claude Code は初めて対話的に起動すると、公式 Anthropic マーケットプレイス（`claude-plugins-official`）を自動的に追加します。ネットワークがダウンロードをブロックしている場合や、[マーケットプレイスポリシー](/docs/ja/plugin-marketplaces#managed-marketplace-restrictions)が以前の試行をブロックした場合など、Claude Code がそれを追加できない場合は、`/plugin marketplace add anthropics/claude-plugins-official` を使用して自分で追加してください。

利用可能なものを参照するには、`/plugin` を実行して **Discover** タブに移動するか、[claude.com/plugins](https://claude.com/plugins)でカタログを表示してください。

公式マーケットプレイスからプラグインをインストールするには、`/plugin install <name>@claude-plugins-official` を使用します。たとえば、GitHub 統合をインストールするには：

```shell theme={null}
/plugin install github@claude-plugins-official
```

`/plugin` はターミナル CLI で対話的なパネルを開きます。Claude が `/plugin` がこの環境では利用できないと返答する場合は、Claude デスクトップアプリの[プラグインブラウザー](/docs/ja/desktop#install-plugins)を使用するか、クラウドセッションの `.claude/settings.json` で [`enabledPlugins`](/docs/ja/settings-reference#enabledplugins) の下にプラグインを宣言してください。

インストールが失敗した場合は、Claude Code が報告するメッセージと照合してください：

* `Marketplace "claude-plugins-official" not found`：`/plugin marketplace add anthropics/claude-plugins-official` でマーケットプレイスを追加してから、インストールを再試行してください。
* プラグインが[マーケットプレイスで見つかりません](#install-plugins)：プラグイン名を確認してください。

<Note>
  公式マーケットプレイスは Anthropic によって管理されており、掲載は Anthropic の裁量です。アプリ内送信フォームはプラグインを[コミュニティマーケットプレイス](#community-marketplace)に追加します。公式マーケットプレイスには追加されません。プラグインを独立して配布するには、[独自のマーケットプレイスを作成](/docs/ja/plugin-marketplaces)してユーザーと共有してください。
</Note>

公式マーケットプレイスには、プラグインのいくつかのカテゴリが含まれています：

<h3 id="code-intelligence">
  コード インテリジェンス
</h3>

コード インテリジェンス プラグインは Claude Code の組み込み LSP ツールを有効にし、Claude が定義にジャンプしたり、参照を見つけたり、編集直後に型エラーを確認したりできるようにします。これらのプラグインは [Language Server Protocol](https://microsoft.github.io/language-server-protocol/) 接続を構成します。これは VS Code のコード インテリジェンスを強化する同じテクノロジーです。[クラウドセッション](/docs/ja/claude-code-on-the-web)では、Claude Code はプラグイン言語サーバーを起動しないため、Claude はそこで LSP ツールを取得しません。

これらのプラグインを使用する前に、以下の表から言語サーバーバイナリをインストールしてください。プラグインはそれをインストールしません。言語サーバーが既にインストールされている場合、プロジェクトを開くと Claude は対応するプラグインをインストールするよう促す場合があります。

| 言語         | プラグイン               | 必要なバイナリ                      |
| :--------- | :------------------ | :--------------------------- |
| C/C++      | `clangd-lsp`        | `clangd`                     |
| C#         | `csharp-lsp`        | `csharp-ls`                  |
| Go         | `gopls-lsp`         | `gopls`                      |
| Java       | `jdtls-lsp`         | `jdtls`                      |
| Kotlin     | `kotlin-lsp`        | `kotlin-language-server`     |
| Lua        | `lua-lsp`           | `lua-language-server`        |
| PHP        | `php-lsp`           | `intelephense`               |
| Python     | `pyright-lsp`       | `pyright-langserver`         |
| Rust       | `rust-analyzer-lsp` | `rust-analyzer`              |
| Swift      | `swift-lsp`         | `sourcekit-lsp`              |
| TypeScript | `typescript-lsp`    | `typescript-language-server` |

[他の言語用に独自の LSP プラグインを作成](/docs/ja/plugins-reference#lsp-servers)することもできます。

<Note>
  プラグインをインストール後に `/plugin` Errors タブに `Executable not found in $PATH` が表示される場合は、上記の表から必要なバイナリをインストールしてください。
</Note>

<h4 id="what-claude-gains-from-code-intelligence-plugins">
  コード インテリジェンス プラグインから Claude が得られるもの
</h4>

コード インテリジェンス プラグインがインストールされ、その言語サーバーバイナリが利用可能になると、Claude は 2 つの機能を得られます：

* **自動診断**：Claude が行うすべてのファイル編集後、言語サーバーはエラーと警告を報告し、Claude はコンパイラやリンターを実行することなく、型エラー、不足しているインポート、構文の問題を確認します。Claude がエラーを導入した場合、それに気付いて同じターンで修正します。
* **コード ナビゲーション**: Claude は言語サーバーを使用して定義にジャンプしたり、参照を見つけたり、ホバーで型情報を取得したり、シンボルをリストしたり、実装を見つけたり、呼び出し階層をトレースしたりできます。これらの操作により、Claude は grep ベースの検索よりも正確なナビゲーションが可能になりますが、言語と環境によって可用性が異なる場合があります。

診断を自分で読むには、Claude Code が **Found 3 new diagnostic issues in 2 files** などのインジケーターを表示するときに **Ctrl+O** を押してください。

問題が発生した場合は、[コード インテリジェンスのトラブルシューティング](#code-intelligence-issues)を参照してください。

<h3 id="external-integrations">
  外部統合
</h3>

これらのプラグインは事前構成された [MCP サーバー](/docs/ja/mcp)をバンドルしているため、手動セットアップなしで Claude を外部サービスに接続できます：

* **ソース管理**: `github`、`gitlab`
* **プロジェクト管理**: `atlassian`（Jira/Confluence）、`asana`、`linear`、`notion`
* **デザイン**: `figma`
* **インフラストラクチャ**: `vercel`、`firebase`、`supabase`
* **コミュニケーション**: `slack`
* **監視**: `sentry`

<h3 id="automatic-security-review">
  自動セキュリティレビュー
</h3>

`security-guidance` プラグインは Claude が行う各変更を一般的な脆弱性についてレビューし、Claude に見つかったものを修正するよう指示します。[Claude がコードを書く際にセキュリティの問題をキャッチする](/docs/ja/security-guidance)を参照して、何をチェックするか、プロジェクト固有のルールを追加する方法を確認してください。

<h3 id="development-workflows">
  開発ワークフロー
</h3>

一般的な開発タスク用のスキルとエージェントを追加するプラグイン：

* **commit-commands**: コミット、プッシュ、PR 作成を含む Git コミット ワークフロー
* **pr-review-toolkit**: プルリクエストをレビューするための特化したエージェント
* **agent-sdk-dev**: Claude Agent SDK で構築するためのツール
* **plugin-dev**: 独自のプラグインを作成するためのツールキット

<h3 id="output-styles">
  出力スタイル
</h3>

Claude の応答方法をカスタマイズします：

* **explanatory-output-style**: 実装の選択に関する教育的な洞察
* **learning-output-style**: スキル構築のためのインタラクティブな学習モード

<h2 id="community-marketplace">
  コミュニティ マーケットプレイス
</h2>

[`anthropics/claude-plugins-community`](https://github.com/anthropics/claude-plugins-community)のコミュニティ マーケットプレイスは、Anthropic の自動検証とセキュリティ スクリーニングに合格したサードパーティ プラグインをホストしています。各プラグインはカタログ内の特定のコミット SHA に固定されています。公式マーケットプレイスとは異なり、手動で追加します：

```shell theme={null}
/plugin marketplace add anthropics/claude-plugins-community
```

その後、`claude-community` マーケットプレイス名を使用してプラグインをインストールします：

```shell theme={null}
/plugin install <plugin-name>@claude-community
```

独自のプラグインをコミュニティ マーケットプレイスに送信するには、プラグイン作成ガイドの[プラグインをコミュニティ マーケットプレイスに送信する](/docs/ja/plugins#submit-your-plugin-to-the-community-marketplace)を参照してください。

<h2 id="try-it-add-the-demo-marketplace">
  試してみる: デモマーケットプレイスを追加する
</h2>

Anthropic は、プラグインシステムで何が可能かを示す例プラグインを含む [デモプラグインマーケットプレイス](https://github.com/anthropics/claude-code/tree/main/plugins)（`claude-code-plugins`）も管理しています。公式マーケットプレイスとは異なり、このマーケットプレイスは手動で追加する必要があります。

<Steps>
  <Step title="マーケットプレイスを追加する">
    Claude Code 内から、`anthropics/claude-code` マーケットプレイスの `plugin marketplace add` コマンドを実行します：

    ```shell theme={null}
    /plugin marketplace add anthropics/claude-code
    ```

    これにより、マーケットプレイスカタログがダウンロードされ、そのプラグインが利用可能になります。
  </Step>

  <Step title="利用可能なプラグインを参照する">
    `/plugin` を実行してプラグインマネージャーを開きます。これにより、**Tab**（または後方に移動するには **Shift+Tab**）を使用して循環できるタブ付きインターフェースが開きます：

    * **Discover**: すべてのマーケットプレイスから利用可能なプラグインを参照
    * **Installed**: インストール済みプラグインを表示および管理
    * **Marketplaces**: 追加したマーケットプレイスを追加、削除、または更新
    * **Errors**: プラグイン読み込みエラーを表示
    * **Stats**: [各スキルのコンテキストコストと使用頻度を確認](/docs/ja/skills#find-unused-skills)します。`/skill-doctor` が利用可能なセッションで確認できます

    **Discover** タブに移動して、追加したばかりのマーケットプレイスからプラグインを確認してください。管理者が [`pluginSuggestionMarketplaces`](/docs/ja/settings-reference#pluginsuggestionmarketplaces) マネージド設定を通じてマーケットプレイスをホワイトリストに登録している場合、現在の作業ディレクトリに関連するとマークされたプラグインは、**suggested for this directory** ラベル付きで上部に固定されます。
  </Step>

  <Step title="プラグインをインストールする">
    プラグインを選択してその詳細を表示します。詳細ペインには、プラグインに含まれるもの、およびそのコストが表示されます：

    * **Context cost** の推定値。毎ターン [コンテキストウィンドウ](/docs/ja/features-overview#understand-context-costs) にプラグインが追加するトークン数を確認できます
    * プラグインの **Last updated** 日付
    * プラグインのコマンド、エージェント、スキル、フック、MCP および LSP サーバーをリストアップする **Will install** セクション。インストール前に正確に何が追加されるかを確認できます

    すべてのプラグインがこれらのフィールドの背後にあるデータを提供するわけではありません。ローカルまたはカスタムマーケットプレイスのプラグインの場合、**Context cost** および **Last updated** 行が表示されない場合があり、**Will install** セクションは代わりに **Components will be discovered at installation** を表示する場合があります。

    インストールスコープを選択します：

    * **User scope**: すべてのプロジェクト全体で自分用にインストール
    * **Project scope**: このリポジトリのすべてのコラボレーター用にインストール
    * **Local scope**: このリポジトリ内で自分用にのみインストール

    たとえば、**commit-commands**（git ワークフロースキルを追加するプラグイン）を選択して、ユーザースコープにインストールします。

    コマンドラインから直接インストールすることもできます：

    ```shell theme={null}
    /plugin install commit-commands@claude-code-plugins
    ```

    スコープの詳細については、[設定ファイル](/docs/ja/settings#where-settings-live)を参照してください。
  </Step>

  <Step title="新しいプラグインを使用する">
    インストール概要を確認します。`Run /reload-plugins to activate.` と報告されている場合は、`/reload-plugins` を実行してください。リロードが会話を再読み込みすることを警告する場合は、`/reload-plugins --force` として再実行してください。

    プラグインスキルはプラグイン名でネームスペース化されているため、**commit-commands** は `/commit-commands:commit` のようなスキルを提供します。

    ファイルに変更を加えて、以下を実行して試してみてください：

    ```shell theme={null}
    /commit-commands:commit
    ```

    これにより、変更がステージされ、コミットメッセージが生成され、コミットが作成されます。

    各プラグインは異なる方法で機能します。**Discover** タブのプラグインの詳細を確認して、提供されるコマンドとスキルを確認するか、使用方法のガイダンスについてそのホームページにアクセスしてください。
  </Step>
</Steps>

<h2 id="add-marketplaces">
  マーケットプレイスを追加する
</h2>

`/plugin marketplace add` コマンドを使用して、異なるソースからマーケットプレイスを追加します。

<Tip>
  **ショートカット**: `/plugin marketplace` の代わりに `/plugin market` を使用でき、`remove` の代わりに `rm` を使用できます。
</Tip>

* **GitHub リポジトリ**: `owner/repo` 形式（例：`anthropics/claude-code`）
* **Git URL**: 任意の git リポジトリ URL（GitLab、Bitbucket、自己ホスト）
* **ローカル パス**: ディレクトリまたは `marketplace.json` ファイルへの直接パス
* **リモート URL**: ホストされた `marketplace.json` ファイルへの直接 URL

<h3 id="add-from-github">
  GitHub から追加する
</h3>

`.claude-plugin/marketplace.json` ファイルを含む GitHub リポジトリを `owner/repo` 形式を使用して追加します。ここで `owner` は GitHub ユーザー名または組織で、`repo` はリポジトリ名です。

たとえば、`anthropics/claude-code` は `anthropics` が所有する `claude-code` リポジトリを指します：

```shell theme={null}
/plugin marketplace add anthropics/claude-code
```

<h3 id="add-from-other-git-hosts">
  他の Git ホストから追加する
</h3>

git マーケットプレイス リポジトリを完全な URL を提供することで追加します。`https://` URL の場合、`.git` サフィックスを含めるかどうかはホストによって異なります：

* **`github.com` と `gitlab.com`**: Claude Code はリポジトリ URL を `.git` サフィックスの有無にかかわらず認識し、クローンします。サフィックスなしで `gitlab.com` URL を追加するには、Claude Code v2.1.232 以降が必要です。v2.1.232 より前では、Claude Code はこれをホストされた `marketplace.json` ファイルへの直接リンクとして扱いました。
* **Azure DevOps**: サフィックスを省略します。Claude Code はパスに `/_git/` を含む任意の URL をクローンします。`/_git/` パスに `.git` を追加すると、クローンが失敗します。
* **自己管理 GitLab サーバーを含む他のすべてのホスト**: `.git` サフィックスを含めて、Claude Code がリポジトリをクローンするようにしてください。URL をホストされた `marketplace.json` ファイルへの直接リンクとして扱うのではなく。AWS CodeCommit のようにクローン URL にサフィックスを含まないホストの場合は、代わりに [`extraKnownMarketplaces`](/docs/ja/settings-reference#extraknownmarketplaces) に git エントリとしてマーケットプレイスを追加してください。Claude Code は git エントリを URL が `.git` で終わるかどうかにかかわらずクローンします。

Claude Code は `https://gitlab.com/group/subgroup/project` のようなネストされたサブグループを持つ `gitlab.com` URL もクローンします。

`https://` プレフィックスを含めてください。Claude Code v2.1.196 以降は、`gitlab.com/company/plugins.git` のようにプレフィックスなしで入力されたホストを無効な GitHub `owner/repo` ショートハンドとして拒否し、エラーメッセージでプレフィックスを追加するよう指示します。以前のバージョンでは、これを GitHub リポジトリパスとして誤読し、クローン時に失敗します。

HTTPS を使用する場合：

```shell theme={null}
/plugin marketplace add https://gitlab.com/company/plugins.git
```

SSH を使用する場合：

```shell theme={null}
/plugin marketplace add git@gitlab.com:company/plugins.git
```

Claude Code は SSH アドレスを `.git` で終わるかどうかにかかわらずクローンします。

特定のブランチまたはタグを追加するには、`#` の後に ref を追加します：

```shell theme={null}
/plugin marketplace add https://gitlab.com/company/plugins.git#v1.0.0
```

<h3 id="add-from-local-paths">
  ローカル パスから追加する
</h3>

`.claude-plugin/marketplace.json` ファイルを含むローカル ディレクトリを追加します：

```shell theme={null}
/plugin marketplace add ./my-marketplace
```

`marketplace.json` ファイルへの直接パスを追加することもできます：

```shell theme={null}
/plugin marketplace add ./path/to/marketplace.json
```

<h3 id="add-from-remote-urls">
  リモート URL から追加する
</h3>

URL 経由でリモート `marketplace.json` ファイルを追加します：

```shell theme={null}
/plugin marketplace add https://example.com/marketplace.json
```

<Note>
  URL ベースのマーケットプレイスは、Git ベースのマーケットプレイスと比べていくつかの制限があります。プラグインをインストールするときに「path not found」エラーが発生した場合は、[トラブルシューティング](/docs/ja/plugin-marketplaces#plugins-with-relative-paths-fail-in-url-based-marketplaces)を参照してください。
</Note>

<h2 id="install-plugins">
  プラグインをインストールする
</h2>

マーケットプレイスを追加したら、プラグインを名前でインストールできます：

```shell theme={null}
/plugin install plugin-name@marketplace-name
```

このコマンドはそのプラグインの詳細を開き、[インストール スコープ](/docs/ja/settings#where-settings-live)を選択できます。`/plugin` を実行して **Discover** タブに移動し、プラグインで **Enter** を押すと、同じ選択肢が表示されます：

* **User scope**: すべてのプロジェクト全体で自分用にインストール
* **Project scope**: このリポジトリのすべてのコラボレーター用にインストール（`.claude/settings.json` に追加）
* **Local scope**: このリポジトリ内で自分用にのみインストール（コラボレーターと共有されない）

インタラクティブなステップなしでインストールするには、[`claude plugin install`](/docs/ja/plugins-reference#plugin-install) シェル コマンドを使用します。このコマンドはユーザー スコープにインストールします。`--scope` を渡さない限り、ユーザー スコープにインストールされます。[`command` ソース](/docs/ja/plugin-marketplaces#how-users-accept-the-command)を持つプラグインの場合、`--yes` を渡して、それが表示するコマンドを受け入れます。

**managed** スコープのプラグインも表示される場合があります。これらは管理者が[管理設定](/docs/ja/managed-settings)経由でインストールしたもので、変更することはできません。

Claude Code はローカル マーケットプレイス カタログのコピーでプラグインを検索します。プラグインの名前の付け方によって、Claude Code がそのコピーを最初に更新するかどうかが決まります：

* **マーケットプレイス名を含む場合**: セッションで `plugin-name@marketplace-name` をインストールするか、`claude plugin install` で実行すると、Claude Code はルックアップの前にそのマーケットプレイスを更新します。Claude Code は、マーケットプレイスの[自動更新](#configure-auto-updates)をオフにしたか、`DISABLE_AUTOUPDATER` を設定した場合でも、更新を実行します。v2.1.232 より前では、Claude Code はルックアップの前にマーケットプレイスを更新しませんでした。Claude Code は以下の場合、この更新をスキップします：
  * マーケットプレイスが[GitHub、別の Git ホスト、またはリモート URL から追加](/docs/ja/plugin-marketplaces#pre-populate-plugins-for-containers)されていない。
  * [シード ディレクトリ](/docs/ja/plugin-marketplaces#pre-populate-plugins-for-containers)がマーケットプレイスを提供している。
  * Claude Code が過去 30 秒以内にマーケットプレイスを更新した。
  * [`CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC`](/docs/ja/env-vars)を設定した。
  * [管理設定](/docs/ja/plugin-marketplaces#managed-marketplace-restrictions)がマーケットプレイスをブロックしている。この場合、Claude Code はインストールも拒否します。
* **プラグイン名のみ**: セッションで `/plugin install plugin-name` を実行すると、Claude Code は[バックグラウンドでも更新](/docs/ja/plugin-marketplaces#configure-auto-updates)するマーケットプレイスのみを更新し、ルックアップが失敗した後のみです。`claude plugin install plugin-name` を実行すると、Claude Code は更新なしでキャッシュされたカタログを読み取ります。最後の更新後に公開されたプラグインをインストールするには、セッションで `/plugin marketplace update <marketplace-name>` を実行するか、シェルで [`claude plugin marketplace update <marketplace-name>`](/docs/ja/plugin-marketplaces#plugin-marketplace-update)を実行してから、インストールを再試行します。

名前付きインストール前の更新が失敗した場合（例えば、オフラインの場合）、Claude Code はキャッシュされたカタログでプラグインを検索します。`claude plugin install` は成功メッセージで `marketplace not refreshed` を報告し、`/plugin install` はプラグインの詳細の上または見つからないメッセージでエラーを表示します。

`/plugin` インターフェイスからインストールすると、インストール サマリーは、プラグインが現在のセッションでアクティブかどうかを示します：

* `Plugin is now active.`: Claude Code はインストールの一部としてプラグインをアクティブにしました。
* `Run /reload-plugins to activate.`: プラグインはまだアクティブではありません。これは、アクティブ化すると[プロンプト キャッシュが無効になる](/docs/ja/prompt-caching#enabling-or-disabling-a-plugin)か、アクティブ化の試行が失敗したためです。コマンドを実行してプラグインをアクティブにします。
* プラグインの読み込みに失敗した場合、サマリーは失敗を報告し、`/plugin` **Errors** タブに詳細が表示されます。

v2.1.221 より前では、`/reload-plugins` を実行するか再起動するまで、現在のセッションでインストールが有効になりませんでした。

`claude plugin install` シェル コマンドはセッションで実行されないため、Claude Code は次回 Claude Code を起動するか、既に開いているセッションで `/reload-plugins` を実行するときに、インストールしたプラグインを読み込みます。

<Warning>
  プラグインをインストールする前に、それを信頼していることを確認してください。Anthropic はプラグインに含まれる MCP サーバー、ファイル、またはその他のソフトウェアを制御せず、意図したとおりに機能することを確認できません。詳細については、各プラグインのホームページを確認してください。
</Warning>

<h2 id="manage-installed-plugins">
  インストール済みプラグインを管理する
</h2>

`/plugin` を実行して **Installed** タブに移動し、プラグインを表示、有効化、無効化、またはアンインストールします。リストはスコープでグループ化され、問題が最初に表示されるようにソートされます。読み込みエラーまたは未解決の依存関係を持つプラグインが上部に表示され、その後にお気に入りが続き、無効化されたプラグインは下部の折りたたまれたヘッダーの後ろに折りたたまれます。

リストから以下を実行できます：

* `f` を押して、選択したプラグインをお気に入りに追加またはお気に入りから削除
* 入力してプラグイン名または説明でフィルタリング
* Enter を押してプラグインの詳細ビューを開き、有効化、無効化、またはアンインストール

プロジェクトの `.claude/settings.json` が有効化しているプラグインをアンインストールすると、Claude Code はどのスコープを意図しているかを尋ねます。自分だけのために無効化する場合は、`.claude/settings.local.json` にオーバーライドを書き込み、プラグインはプロジェクトにインストールされたままになります。または、すべてのユーザーのためにアンインストールする場合は、共有の `.claude/settings.json` から削除されます。

詳細ビューには、プラグインが提供するコンポーネントが表示されます。コマンド、skills、agents、hooks、MCP サーバー、LSP サーバーです。同じインベントリは、コマンドラインから `claude plugin details` で利用できます。

Claude Code はまた、マーケットプレイスから自分でインストールしたが、少なくとも 2 週間以上、かつ少なくとも 10 セッション以上にわたって使用していないプラグインも一覧表示します。これらは **Installed** タブの **Not used recently** ヘッダーの下に表示されます。詳細ビューには、各プラグインの **Last used** 行が表示されます。これらを使用して、もう使用していないが、それでもスタートアップとコンテキストコストを追加しているプラグインを見つけ、無効化またはアンインストールできます。

2 種類のプラグインは、未使用として一覧表示されることはありません：

* 組織が管理するプラグイン、または `--plugin-dir` で読み込むプラグイン
* テーマ、出力スタイル、モニター、またはワークフローを提供するプラグイン。これらは追跡する呼び出しなしで価値を提供するため

**Not used recently** ヘッダーと **Last used** 行は、組織が [`strictKnownMarketplaces`](/docs/ja/settings-reference#strictknownmarketplaces) でマーケットプレイスを制限している場合、両方とも非表示になります。

プラグインの [言語サーバー](/docs/ja/plugins#add-lsp-servers-to-your-plugin) は、診断を提供するか、コード ナビゲーション リクエストに応答するときに使用済みとしてカウントされます。そのため、LSP プラグインのサーバーがセッションでアクティブな場合、未使用として一覧表示されません。v2.1.203 より前では、言語サーバー アクティビティを使用としてカウントできなかったため、LSP サーバーを提供するプラグインはグループ全体から除外されていました。これはテーマと出力スタイル プラグインと同じ方法です。

言語サーバー アクティビティをカウントするバージョンの最初のセッションは、まだ使用を記録していない各 LSP プラグインの使用記録もリセットするため、Claude Code は、サーバー アクティビティが追跡される前に記録されたデータに基づいて、以前にインストールしたプラグインを未使用と判断しません。

依存関係を宣言するプラグインをインストールすると、インストール出力には、それと共に自動インストールされた依存関係が一覧表示されます。

直接コマンドでプラグインを管理することもできます：

* `/plugin disable`、`/plugin enable`、または `/plugin uninstall` を実行すると、Claude Code はプラグインパネルを開いて変更を適用し、パネルを開いたままにします。別のコマンドを入力する前に **Esc** を押してパネルを閉じます。
* スクリプティングの場合は、代わりに `claude plugin` シェルコマンドを使用します。これらはパネルを開きません。

メニューを開かずにインストール済みプラグインを一覧表示します：

```shell theme={null}
/plugin list
```

`--enabled` または `--disabled` を渡して、その状態のプラグインのみを表示します。

プラグインをアンインストールせずに無効化します：

```shell theme={null}
/plugin disable plugin-name@marketplace-name
```

無効化されたプラグインを再度有効化します：

```shell theme={null}
/plugin enable plugin-name@marketplace-name
```

これらの識別子では、`plugin-name` は [マーケットプレイスエントリ](/docs/ja/plugin-marketplaces#plugin-entries) の `name` であり、プラグイン自体の `plugin.json` の `name` と異なる場合があります。

Claude Code v2.1.195 以降では、`/plugin` インターフェイスの **Enable** と **Disable** は、2 つの名前が異なるプラグインに対して機能し、`/plugin enable` と `/plugin disable` はどちらの名前でも受け入れます。以前のバージョンでそのようなプラグインを無効化すると、Claude Code は `already disabled` を報告し、有効なままにします。

プラグインを完全に削除します：

```shell theme={null}
/plugin uninstall plugin-name@marketplace-name
```

`--scope` オプションを使用すると、CLI コマンドで特定のスコープをターゲットにできます：

```shell theme={null}
claude plugin install formatter@your-org --scope project
claude plugin uninstall formatter@your-org --scope project
```

<h3 id="apply-plugin-changes-without-restarting">
  プラグインの変更をリスタートなしで適用する
</h3>

[インストール概要](#install-plugins) が `Plugin is now active.` を報告する場合、Claude Code はすでにプラグインをアクティブ化しており、このステップをスキップできます。その他すべての場合、セッション中に有効化または無効化したプラグイン、およびインストール概要が `Run /reload-plugins to activate.` を報告するインストールについては、すべての変更をリスタートなしで適用します：

```shell theme={null}
/reload-plugins
```

リロードがプロンプトキャッシュを無効にする場合、コマンドは警告を表示し、`--force` を使用して再実行するまでスキップします。

`/reload-plugins` はまた、デスクトップアプリ、Agent SDK、および [`-p` を使用した非対話型モード](/docs/ja/headless) など、対話型ターミナルのないセッションでも実行されます。Claude Code v2.1.260 以降が必要です。これらのセッションでは 2 つの制限が適用されます：

* コマンドは、`-p` プロンプトやデスクトップアプリのプロンプトボックスなど、セッションに直接入力した場合にのみ実行されます。代わりに [Remote Control](/docs/ja/remote-control) やリレーされたチャットメッセージなどのリモート接続を介して送信する場合、コマンドは何もリロードせずに拒否されます。
* リロードはプラグイン MCP サーバーを接続または切断しません。これらの変更は次のセッションで有効になります。

Claude Code はすべてのアクティブなプラグインをリロードし、プラグイン、skills、agents、hooks、プラグイン MCP サーバー、プラグイン LSP サーバーのカウントを表示します。対話型ターミナルのないセッションではプラグイン MCP サーバーのカウントを省略します。skills のカウントでは、Claude Code はプラグインが提供するすべての skill を含みます。`commands/` エントリと `SKILL.md` skills の両方です。v2.1.246 より前では、Claude Code は `commands/` エントリのみをカウントしていたため、プラグインの `SKILL.md` skills をリロードしても、概要で `0 skills` を報告する可能性がありました。

リロードには次のリクエストでトークンコストがあります。新しくロードされたコンポーネントは会話に追加されたコンテンツで自身を発表し、既存の履歴はプロンプトキャッシュから読み込まれたままです。MCP サーバーを提供するプラグインは、そのツールが [tool search](/docs/ja/mcp#scale-with-mcp-tool-search) によって遅延されていない場合、より多くのコストがかかります。変更はキャッシュを無効にし、次のリクエストは会話全体を再度読み込みます。詳細については、[プラグインの有効化または無効化](/docs/ja/prompt-caching#enabling-or-disabling-a-plugin) を参照してください。

<h2 id="manage-marketplaces">
  マーケットプレイスを管理する
</h2>

インタラクティブな `/plugin` インターフェースまたは CLI コマンドを使用してマーケットプレイスを管理できます。

<h3 id="use-the-interactive-interface">
  インタラクティブ インターフェースを使用する
</h3>

`/plugin` を実行して **Marketplaces** タブに移動して、以下を実行します：

* 追加したすべてのマーケットプレイスをそのソースとステータスで表示
* 新しいマーケットプレイスを追加
* マーケットプレイス リストを更新して最新のプラグインを取得
* 不要になったマーケットプレイスを削除

<h3 id="use-cli-commands">
  CLI コマンドを使用する
</h3>

直接コマンドでマーケットプレイスを管理することもできます。

構成されたすべてのマーケットプレイスをリストします：

```shell theme={null}
/plugin marketplace list
```

マーケットプレイスからプラグイン リストを更新します：

```shell theme={null}
/plugin marketplace update marketplace-name
```

マーケットプレイスを削除します：

```shell theme={null}
/plugin marketplace remove marketplace-name
```

<Warning>
  マーケットプレイスを削除すると、そこからインストールしたプラグインがアンインストールされます。
</Warning>

<h3 id="configure-auto-updates">
  自動更新を構成する
</h3>

Claude Code はスタートアップ時にマーケットプレイスとそのインストール済みプラグインをバックグラウンドで自動的に更新できます。マーケットプレイスで自動更新が有効になっている場合、Claude Code はマーケットプレイス データを更新し、インストール済みプラグインをディスク上の最新バージョンに更新します。

Claude Code はセッション開始後、最大 10 分のランダムな遅延でマーケットプレイスとプラグインの更新をチェックするため、実行中のセッションは起動時に読み込んだバージョンを使用し続けます。プラグインが更新された場合、`/reload-plugins` を実行するよう促すメッセージが表示されるか、次回の起動時に新しいバージョンが読み込まれます。

自動更新は、マーケットプレイス エントリが `headersHelper` を宣言するプラグインも除外します。Claude Code は [そのパス上のコマンドを実行したり、アーカイブをダウンロードしたりしません](/docs/ja/plugin-marketplaces#installs-and-updates-that-refuse-the-command-instead-of-asking)。そのセクションでは、Claude Code がプラグインを `/plugin` Errors タブにリストする時期について説明しており、独自のビューから更新できます。

Claude Code は [`command` ソース](/docs/ja/plugin-marketplaces#command-sources)を持つプラグインを、マーケットプレイス自動更新設定および `DISABLE_AUTOUPDATER` とは異なるペースで更新します。代わりに、[セッションごとに 1 回コマンドを再実行](/docs/ja/plugin-marketplaces#when-claude-code-re-runs-the-command)し、その [ハッシュ](/docs/ja/plugins-reference#version-management)が変更された場合、出力を新しいプラグイン バージョンとしてインストールします。

UI を通じて個別のマーケットプレイスの自動更新を切り替えます：

1. `/plugin` を実行してプラグイン マネージャーを開く
2. **Marketplaces** を選択
3. リストからマーケットプレイスを選択
4. **Enable auto-update** または **Disable auto-update** を選択

`claude-plugins-official` および他のほとんどの公式 Anthropic マーケットプレイスはデフォルトで自動更新が有効になっています。サードパーティおよびローカル開発マーケットプレイスはデフォルトで自動更新が無効になっています。

管理者は、マネージド設定で各 [`extraKnownMarketplaces`](/docs/ja/settings-reference#extraknownmarketplaces) エントリに `"autoUpdate": true` を設定して、各ユーザーが切り替える必要なく、組織マーケットプレイスの自動更新を有効にすることもできます。

Claude Code とマーケットプレイスから取得されたプラグインの自動更新を無効にするには、`DISABLE_AUTOUPDATER` 環境変数を設定します。[`command` ソース](/docs/ja/plugin-marketplaces#command-sources)を持つプラグインは独自のセッションごと 1 回の再解決に従います。詳細については、[自動更新](/docs/ja/setup#auto-updates)を参照してください。

Claude Code の自動更新を無効化しながらプラグイン自動更新を有効化したままにするには、`DISABLE_AUTOUPDATER` と共に `FORCE_AUTOUPDATE_PLUGINS=1` を設定します：

```bash theme={null}
export DISABLE_AUTOUPDATER=1
export FORCE_AUTOUPDATE_PLUGINS=1
```

<h2 id="configure-team-marketplaces">
  チーム マーケットプレイスを構成する
</h2>

チーム管理者は、`.claude/settings.json` にマーケットプレイス構成を追加することで、プロジェクトの自動マーケットプレイス インストールを設定できます。チーム メンバーが[リポジトリ フォルダを信頼](/docs/ja/permissions#what-runs-before-you-trust-a-folder)すると、Claude Code はこれらのマーケットプレイスをさらなるプロンプトなしで追加します。

Claude Code v2.1.195 以降、マーケットプレイスを追加しても、プラグインを読み込むすべてのパスで外部ソースから提供されるプラグインはインストールされません。プロジェクトの `.claude/settings.json` のみで有効にされ、GitHub リポジトリや npm パッケージなどの外部ソースから提供されるプラグインは、チーム メンバーがインストールするまで読み込まれません。それまでの間、Claude Code はプラグインがインストールされていないと報告し、実行する `claude plugin install` コマンドを表示します。

プロジェクトの `.claude/settings.json` に `extraKnownMarketplaces` を追加します：

```json theme={null}
{
  "extraKnownMarketplaces": {
    "my-team-tools": {
      "source": {
        "source": "github",
        "repo": "your-org/claude-plugins"
      }
    }
  }
}
```

`extraKnownMarketplaces` と `enabledPlugins` を含む完全な構成オプションについては、[プラグイン設定](/docs/ja/settings-reference#plugin-settings)を参照してください。

<h2 id="security">
  セキュリティ
</h2>

プラグインとマーケットプレイスは、ユーザー権限でマシン上で任意のコードを実行できる、非常に信頼されたコンポーネントです。信頼できるソースからのみプラグインをインストールし、マーケットプレイスを追加してください。組織は、[管理マーケットプレイス制限](/docs/ja/plugin-marketplaces#managed-marketplace-restrictions)を使用してユーザーが追加できるマーケットプレイスを制限できます。

<h2 id="troubleshooting">
  トラブルシューティング
</h2>

<h3 id="/plugin-command-not-recognized">
  /plugin コマンドが認識されない
</h3>

「unknown command」が表示されるか、`/plugin` コマンドが表示されない場合：

1. **バージョンを確認する**: `claude --version` を実行して、インストールされているものを確認します。
2. **Claude Code を更新する**:
   * **Homebrew**: `brew upgrade claude-code`、または `brew upgrade claude-code@latest` をインストールした場合は `brew upgrade claude-code@latest`
   * **npm**: `npm install -g @anthropic-ai/claude-code@latest`
   * **ネイティブ インストーラー**: [セットアップ](/docs/ja/setup)からインストール コマンドを再実行します。
3. **Claude Code を再起動する**: 更新後、ターミナルを再起動して `claude` を再度実行します。

<h3 id="common-issues">
  一般的な問題
</h3>

プラグイン スキルが表示されない場合は、`rm -rf ~/.claude/plugins/cache` でキャッシュをクリアし、Claude Code を再起動して、プラグインを再度インストールしてください。

詳細なトラブルシューティングとソリューションについては、マーケットプレイス ガイドの [トラブルシューティング](/docs/ja/plugin-marketplaces#troubleshooting)を参照してください。デバッグ ツールについては、[デバッグと開発ツール](/docs/ja/plugins-reference#debugging-and-development-tools)を参照してください。

<h3 id="code-intelligence-issues">
  コード インテリジェンスの問題
</h3>

* **言語サーバーが起動しない**: バイナリがインストールされており、`$PATH` で利用可能であることを確認してください。詳細については、`/plugin` Errors タブを確認してください。
* **メモリ使用量が多い**: `rust-analyzer` や `pyright` などの言語サーバーは、大規模なプロジェクトで大量のメモリを消費する可能性があります。メモリの問題が発生した場合は、`/plugin disable <plugin-name>` でプラグインを無効化し、代わりに Claude の組み込み検索ツールを使用してください。
* **モノレポでの誤検知診断**: ワークスペースが正しく構成されていない場合、言語サーバーは内部パッケージの未解決インポート エラーを報告する可能性があります。これらはコードを編集する Claude の能力に影響しません。

<h2 id="next-steps">
  次のステップ
</h2>

* **独自のプラグインを構築する**: スキル、エージェント、フックを作成するには、[プラグイン](/docs/ja/plugins)を参照してください。
* **マーケットプレイスを作成する**: チームまたはコミュニティにプラグインを配布するには、[プラグイン マーケットプレイスを作成](/docs/ja/plugin-marketplaces)を参照してください。
* **技術リファレンス**: 完全な仕様については、[プラグイン リファレンス](/docs/ja/plugins-reference)を参照してください。
